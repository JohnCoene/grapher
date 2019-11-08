/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

const React = require('react');

const CompLibrary = require('../../core/CompLibrary.js');

const MarkdownBlock = CompLibrary.MarkdownBlock; /* Used to read markdown */
const Container = CompLibrary.Container;
const GridBlock = CompLibrary.GridBlock;

class HomeSplash extends React.Component {
  render() {
    const {siteConfig, language = ''} = this.props;
    const {baseUrl, docsUrl} = siteConfig;
    const docsPart = `${docsUrl ? `${docsUrl}/` : ''}`;
    const langPart = `${language ? `${language}/` : ''}`;
    const docUrl = doc => `${baseUrl}${docsPart}${langPart}${doc}`;

    const SplashContainer = props => (
      <div className="homeContainer" id="particles">
        <div className="homeSplashFade">
          <div className="wrapper homeWrapper">{props.children}</div>
        </div>
      </div>
    );

    const Logo = props => (
      <div className="projectLogo">
        {/* <img src={props.img_src} alt="Project Logo" /> */}
      </div>
    );

    const ProjectTitle = () => (
      <h2 className="projectTitle">
        Grapher
        <small>An R integration of ngraph</small>
      </h2>
    );

    const PromoSection = props => (
      <div className="section promoSection">
        <div className="promoRow">
          <div className="pluginRowBlock">{props.children}</div>
        </div>
      </div>
    );

    const Button = props => (
      <div className="pluginWrapper buttonWrapper">
        <a className="button" href={props.href} target={props.target}>
          {props.children}
        </a>
      </div>
    );

    return (
      <SplashContainer>
        <Logo img_src={`${baseUrl}img/grapher.png`} />
        <div className="inner">
          <ProjectTitle siteConfig={siteConfig} />
          <PromoSection>
          <Button href={docUrl('get-started.html')}>Get Started</Button>
            <Button href="https://shiny.john-coene.com/cran" target="_blank">Demo</Button>
          </PromoSection>
        </div>
      </SplashContainer>
    );
  }
}

class Index extends React.Component {
  render() {
    const {config: siteConfig, language = ''} = this.props;
    const {baseUrl} = siteConfig;

    const Block = props => (
      <Container
        padding={['bottom', 'top']}
        id={props.id}
        background={props.background}>
        <GridBlock
          align="center"
          contents={props.children}
          layout={props.layout}
        />
      </Container>
    );

    const FeatureCallout = () => (
      <div
        className="productShowcaseSection paddingBottom"
        style={{textAlign: 'center'}}>
        <h2>Feature Callout</h2>
        <MarkdownBlock>These are features of this project</MarkdownBlock>
      </div>
    );

    const TryOut = () => (
      <Block id="try">
        {[
          {
            content:
              'Accepts all common graph objects (gexf, igraph, tidygraph, etc.). ' +
              'Initialise a graph in a single line, then customise later if needed.',
            image: `${baseUrl}img/grapher-demo.png`,
            imageAlign: 'left',
            title: 'Easy to use',
          },
        ]}
      </Block>
    );

    const Description = () => (
      <Block>
        {[
          {
            content:
              'Easily renders large graphs.' +
              'Simple heuristic to improve performances',
            image: `${baseUrl}img/grapher-demo.png`,
            imageAlign: 'right',
            title: 'Scale',
          },
        ]}
      </Block>
    );

    const LearnHow = () => (
      <Block>
        {[
          {
            content:
              'Easily renders large graphs.' + 
              'with simple heuristics to improve performances',
            image: `${baseUrl}img/fkg.png`,
            imageAlign: 'right',
            title: 'Scale',
          },
        ]}
      </Block>
    );

    const Features = () => (
      <Block layout="fourColumn">
        {[
          {
            content: 'Draw a graph in a single line',
            image: `${baseUrl}img/easy.png`,
            imageAlign: 'top',
            title: 'Easy to use',
          },
          {
            content: 'Visualise large graphs',
            //image: `${baseUrl}img/undraw_operating_system.svg`,
            imageAlign: 'top',
            title: 'Scales',
            href: 'hello'
          },
        ]}
      </Block>
    );

    const Showcase = () => {
      if ((siteConfig.users || []).length === 0) {
        return null;
      }

      const showcase = siteConfig.users
        .filter(user => user.pinned)
        .map(user => (
          <a href={user.infoLink} key={user.infoLink}>
            <img src={user.image} alt={user.caption} title={user.caption} />
          </a>
        ));

      const pageUrl = page => baseUrl + (language ? `${language}/` : '') + page;

      return (
        <div className="productShowcaseSection paddingBottom">
          <h2>Who is Using This?</h2>
          <p>This project is used by all these people</p>
          <div className="logos">{showcase}</div>
          <div className="more-users">
            <a className="button" href={pageUrl('users.html')}>
              More {siteConfig.title} Users
            </a>
          </div>
        </div>
      );
    };

    return (
      <div>
        <HomeSplash siteConfig={siteConfig} language={language} />
        <div className="mainContainer">
          {/* <FeatureCallout /> */}
          <TryOut />
          <LearnHow />
          {/* <Description /> */}
          {/* <Showcase /> */}
          {/* <Features /> */}
        </div>
      </div>
    );
  }
}

module.exports = Index;
