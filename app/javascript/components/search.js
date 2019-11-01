import React from "react"
import PropTypes from "prop-types"
import Suggestions from "components/suggestions"

class Search extends React.Component {
  state = {
    query: '',
    results: []
  }
    
  handleInputChange = () => {
    this.setState({
      query: this.search.value
    }, () => {
      if (this.state.query && this.state.query.length > 1) {
        if (this.state.query.length % 2 === 0) {
          this.getInfo()
        }
      } 
    })
  }

  getInfo = () => { 
    const url = `/search?q=${this.state.query}`

    fetch(url)
      .then(response => response.json())
      .then(data => { 

        this.setState({
          results: data
        })

      })
      .catch(function(error) {
        // If there are any errors catch them here
        console.log(error);
      })   
  }

  render () {
    return (
      <form>
        <input
          placeholder="Search for..."
          ref={input => this.search = input}
          onChange={this.handleInputChange}
        />
        <p>{this.state.query}</p>
        <Suggestions results={this.state.results} />
      </form>
    );
  }
}

Search.propTypes = {
};
export default Search
