const axios = require('axios');

/**
 * model to handle requests to log-server
 */
class logModel {
    #HOST = "log-server";
    #PORT = "8000";
    #ROUTE = "data";
    #url;
    #query;

    constructor(
        host = this.#HOST,
        port = this.#PORT,
        route = this.#ROUTE
    ) {
        // build url
        this.#url = `http://${host}:${port}/${route}`;
    }

    /**
     * get matching log entries
     * 
     * @param {Object} filters 
     * @returns {Array}
     */
    async getEntries(filters = {}) {
        // build query string
        this.#buildQuery(filters);

        try {
            // request server
            const response = await axios.get(this.#url + this.#query);
            return response.data;
        } catch (error) {
            console.error("Error fetching log data:", error.message);
        }
    }

    /**
     * build query string from object {ip: "111"...}
     * 
     * @param {Object} filters 
     */
    #buildQuery(filters) {
        let query = ""
        for (let filter_key in filters) {
            let key = encodeURIComponent(filter_key);
            let value = encodeURIComponent(filters[filter_key]);
            query += query.length < 1 ? "?":"&"
            query += key + "=" + value
        }

        this.#query = query;
    }
}

module.exports = logModel;
