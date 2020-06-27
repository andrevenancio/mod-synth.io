/* eslint-disable no-nested-ternary */
module.exports = {
    name: 'hapi-gate-rebuild',
    version: '1.0.0',

    register: (server, options) => {
        server.ext('onRequest', (request, h) => {
            const original = {
                protocol:
                    (options.proxy !== false
                        ? request.headers['x-forwarded-proto']
                        : request.server.info.protocol) || 'http',
                host:
                    request.headers['x-forwarded-host'] || request.headers.host,
            };

            const protocol = options.https ? 'https' : 'http';
            const host = options.www
                ? /^www\./.test(original.host)
                    ? original.host
                    : `www.${original.host}`
                : original.host.replace(/^www\./, '');

            if (protocol !== original.protocol || host !== original.host) {
                const { pathname, search } = request.url;
                return h
                    .redirect(`${protocol}://${host}${pathname}${search}`)
                    .takeover()
                    .code(301);
            }

            return h.continue;
        });
    },
};
