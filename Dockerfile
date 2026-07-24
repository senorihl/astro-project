FROM node:lts-alpine AS deps

WORKDIR /usr/src/app
COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/root/.yarn YARN_CACHE_FOLDER=/root/.yarn yarn install ; sync

FROM deps AS dev
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "yarn", "dev", "--ignore-lock" ]
EXPOSE 4321
HEALTHCHECK  --interval=30s --timeout=3s --start-interval=5s --start-period=5s    \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:4321/ || exit 1

FROM deps AS prod_builder
ENV PORT=80
COPY . ./
RUN yarn build


FROM nginx:alpine AS prod

WORKDIR /opt/project

COPY --chmod=a+x --from=node:lts-alpine /usr/local/bin /usr/local/bin
COPY --chmod=a+x --from=node:lts-alpine /usr/local/lib /usr/local/lib
COPY --chmod=a+x --from=node:lts-alpine /opt /opt
COPY --chown=www-data:www-data --from=prod_builder /usr/src/app ./
COPY --chown=www-data:www-data --from=prod_builder /usr/src/app/dist/ /usr/share/nginx/html
ENTRYPOINT [ "/opt/project/docker-entrypoint.sh" ]
CMD [  ]
EXPOSE 80
HEALTHCHECK  --interval=30s --timeout=3s --start-interval=5s --start-period=5s    \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:80/ || exit 1