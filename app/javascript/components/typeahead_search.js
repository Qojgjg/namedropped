import React from 'react';
import PropTypes from 'prop-types';
import {AsyncTypeahead} from 'react-bootstrap-typeahead';
import EpisodeMenuItem from './episode_menu_item';
import SearchIcon from './search_icon';

class TypeaheadSearch extends React.Component {
  state = {
    allowNew: false,
    isLoading: false,
    multiple: false,
    options: [],
  };

  render() {
    return (
      <React.Fragment>
        <div className="input-group mb-3">
          <AsyncTypeahead
            isLoading={this.state.isLoading}
            onSearch={query => {
              this.setState({isLoading: true});
              fetch(`http://localhost:3000/search?q=${query}`)
                .then(resp => resp.json())
                .then(json =>
                  this.setState({
                    isLoading: false,
                    options: json,
                  }),
                );
            }}
            options={this.state.options}
            placeholder="Search through podcast episodes..."
            renderMenuItemChildren={(option, props) => (
              <EpisodeMenuItem key={option.id} episode={option} />
            )}
            labelKey={option => `${option.title}`}
            filterBy={['title', 'description']}
          />
        {console.log(this.state.options)}
          <div className="input-group-append">
            <button
              className="btn btn-outline-secondary"
              type="button"
              id="button-addon2"
            >
              <SearchIcon />
            </button>
          </div>
        </div>
      </React.Fragment>
    );
  }
}

TypeaheadSearch.propTypes = {
  isLoading: PropTypes.bool,
  onSearch: PropTypes.string,
};

export default TypeaheadSearch;
