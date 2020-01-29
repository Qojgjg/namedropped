import React from 'react';
import PropTypes from 'prop-types';
import {AsyncTypeahead} from 'react-bootstrap-typeahead';
import GithubMenuItem from './github_menu_item';

import {Menu} from 'react-bootstrap-typeahead';
import {MenuItem} from 'react-bootstrap-typeahead';

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
        <AsyncTypeahead
          isLoading={this.state.isLoading}
          onSearch={query => {
            this.setState({isLoading: true});
            fetch(`http://localhost:3000/search?q=${query}`)
              .then(resp => resp.json())
              .then(json =>
                this.setState({
                  isLoading: false,
                  options: json.items,
                }),
              );
          }}
          options={this.state.options}
          placeholder="Search for a term in podcasts"
          renderMenu={(results, menuProps) => (
            <Menu {...menuProps}>
              {results.map((result, index) => (
                <MenuItem option={result} position={index}>
                  {result}
                </MenuItem>
              ))}
            </Menu>
          )}
          labelKey={option => `${option._id}`}
        />
      </React.Fragment>
    );
  }
}

TypeaheadSearch.propTypes = {
  isLoading: PropTypes.bool,
  onSearch: PropTypes.string,
};

export default TypeaheadSearch;
