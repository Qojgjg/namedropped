import React from "react";
import PropTypes from "prop-types";
import { AsyncTypeahead } from "react-bootstrap-typeahead";
import EpisodeMenuItem from "./episode_menu_item";
import SearchIcon from "./search_icon";
import SearchResults from "./search_results";

class TypeaheadSearch extends React.Component {
  constructor(props) {
    super(props);
    this.keyDown = this.keyDown.bind(this);

    this.state = {
      allowNew: false,
      isLoading: false,
      multiple: false,
      options: [],
    };
  }

  keyDown = e => {
    if (e.keyCode === 13) {
      this._form.submit();
    }
  };

  render() {

    return (
      <React.Fragment>
        <form ref={form => this._form = form} action={this.props.mainSearchPath} method="GET">

          <div className="input-group mb-3">
            <AsyncTypeahead
              isLoading={this.state.isLoading}
              onSearch={query => {
                this.setState({ isLoading: true });
                fetch(`${this.props.typeaheadSearchPath}?q=${query}`)
                  .then(resp => resp.json())
                  .then(json =>
                    this.setState({
                      isLoading: false,
                      options: json
                    })
                  );
              }}
              options={this.state.options}
              placeholder="Search through podcast episodes..."
              renderMenuItemChildren={(option, props) => (
                <EpisodeMenuItem key={option.id} episode={option} />
              )}
              labelKey={option => `${option.title}`}
              filterBy={(option, props) => ( true ) }
              ref={typeahead => (this.typeahead = typeahead)}
              minLength={3}
              onKeyDown={this.keyDown}
              inputProps={{ autoComplete: "off", id: "user_query", name: "q" }}
              allowNew={false}
              id="typeahead_async_search"
            />
            <div className="input-group-append">
              <button
                 className="btn btn-outline-secondary"
                 role="button"
                 type="submit"
                 id="button-addon2"
              >
                <SearchIcon />
              </button>
            </div>
          </div>
        </form>
      </React.Fragment>
    );
  }
}

TypeaheadSearch.propTypes = {
  isLoading: PropTypes.bool,
  onSearch: PropTypes.string,
  typeaheadSearchPath: PropTypes.string.isRequired,
  mainSearchPath: PropTypes.string.isRequired,
};

export default TypeaheadSearch;
