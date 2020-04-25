import React from 'react';
import PropTypes from 'prop-types';
import SearchResult from './search_result';

class SearchResults extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    return(
      <React.Fragment>
          <div className="my-3 p-3 ">
            <h6 className="border-bottom border-gray pb-2 mb-0">Search results for [{ this.props.searchQuery }]</h6>

            { console.log(this.props.results)}
              { this.props.results.map(result => (
                <div key={ result.id } >
                  <SearchResult
                    title={ result.title }
                    description={ result.description }
                    episode_id={ result.id }
                  />
                </div>
                ))
              }
          <small className="d-block text-right mt-3">
            <a href="/alerts">Get notified if [{ this.props.searchQuery }] gets mentioned in a podcast.</a>
          </small>
        </div>
      </React.Fragment>
    );
  }
}

SearchResults.propTypes = {
  results: PropTypes.array.isRequired,
  searchQuery: PropTypes.string.isRequired,

};

export default SearchResults;
