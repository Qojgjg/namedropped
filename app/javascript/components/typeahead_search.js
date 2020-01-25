import React from 'react';
import PropTypes from 'prop-types';
import {AsyncTypeahead} from 'react-bootstrap-typeahead';
import GithubMenuItem from './github_menu_item';

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
            fetch(`https://api.github.com/search/users?q=${query}`)
              .then(resp => resp.json())
              .then(json =>
                this.setState({
                  isLoading: false,
                  options: json.items,
                }),
              );
          }}
          options={this.state.options}
          placeholder="Search for podcasts"
          renderMenuItemChildren={(option, props) => (
            <GithubMenuItem key={option.id} user={option} />
          )}
          labelKey={option => `${option.login}`}
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
