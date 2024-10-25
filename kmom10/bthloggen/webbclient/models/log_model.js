/**
 * Module for LogModel of bthloggen webclient
 */


const axios = require('axios');


/**
 * model to handle requests to log-server
 */
class logModel {
    #HOST = "log-server";
    #PORT = "8000";
    #FILTER_ROUTE = "/filters";
    #ENTRY_ROUTE = "/data";
    #baseUrl;
    #query = ""


    /**
     * build baseUrl
     * 
     * @param {String|null} host 
     * @param {String|null} port 
     */
    constructor(host = this.#HOST, port = this.#PORT) {
        this.#baseUrl = `http://${host}:${port}`;
    }



    /**
     * get matching log entries
     * 
     * @param {Object} filters 
     * @returns {Promise<Array>}
     */
    async getEntries(filters = {}) {
        // build query string
        await this.#buildQuery(filters);

        try {
            // request server
            const response = await axios.get(this.#baseUrl + this.#ENTRY_ROUTE + this.#query);
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
    async #buildQuery(filters) {
        const valid_filters = await this.#cleanFilters(filters);
        
        let query = ""
        for (let filter_key in valid_filters) {
            let value = encodeURIComponent(filters[filter_key]);
            query += query.length < 1 ? "?":"&"
            query += filter_key + "=" + value
        }

        this.#query = query;
    }



    /**
     * remove invalid filters
     * 
     * @param {Object} filters
     * @return {Object}
     */
    async #cleanFilters(filters){
        const supported_filters = await this.#getSupportedFilters();

        for (let name in filters) {
            if (!filters[name] || !(supported_filters.includes(name))) {
                delete filters[name];
            }
        }

        return filters;
    }



    /**
     * get list of valid filters from log-server
     * 
     * @return {Promise<Array>}
     */
    async #getSupportedFilters() {
        try {
            // request server
            const response = await axios.get(this.#baseUrl + this.#FILTER_ROUTE);
            return response.data;
        } catch (error) {
            console.error("Error fetching filter data:", error.message);
        }
    }
}

module.exports = logModel;
