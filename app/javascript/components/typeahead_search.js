import React from "react";
import PropTypes from "prop-types";
import { AsyncTypeahead } from "react-bootstrap-typeahead";
import EpisodeMenuItem from "./episode_menu_item";
import SearchIcon from "./search_icon";
import SearchResults from "./search_results";

class TypeaheadSearch extends React.Component {
  constructor(props) {
    super(props);
    this.handleSearchClick = this.handleSearchClick.bind(this);

    this.state = {
      allowNew: false,
      isLoading: false,
      multiple: false,
      options: [],
      searchQuery: "",
      searchClick: false
    };
  }

  handleSearchClick() {
    this.setState(state => ({
      searchClick: true
    }));
  }

  render() {
    const { searchClick = false } = this.state;

    return (
      <React.Fragment>
        <div className="input-group mb-3">
          <AsyncTypeahead
            isLoading={this.state.isLoading}
            onSearch={query => {
              this.setState({ isLoading: true });
              this.setState({ searchClick: false });
              fetch(`${this.props.searchPath}?q=${query}`)
                .then(resp => resp.json())
                .then(json =>
                  this.setState({
                    isLoading: false,
                    options: json
                  })
                );
              this.state.searchQuery = query;
            }}
            options={this.state.options}
            placeholder="Search through podcast episodes..."
            renderMenuItemChildren={(option, props) => (
              <EpisodeMenuItem key={option.id} episode={option} />
            )}
            labelKey={option => `${option.title}`}
            filterBy={["title", "description"]}
            ref={typeahead => (this.typeahead = typeahead)}
          />
          {console.log(this.state.options)}
          <div className="input-group-append">
            <button
              className="btn btn-outline-secondary"
              type="button"
              id="button-addon2"
              onClick={this.handleSearchClick}
            >
              <SearchIcon />
            </button>
          </div>
        </div>

        {searchClick && (
          <SearchResults
            results={this.state.options}
            searchQuery={this.state.searchQuery}
          />
        )}
      </React.Fragment>
    );
  }
}

TypeaheadSearch.propTypes = {
  isLoading: PropTypes.bool,
  onSearch: PropTypes.string,
  searchPath: PropTypes.string.isRequired
};

export default TypeaheadSearch;
