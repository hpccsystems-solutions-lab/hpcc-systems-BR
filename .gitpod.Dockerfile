FROM gitpod/workspace-full

RUN sudo apt-get -y update

# Install the latest hpccsystems clienttools and required ML bundles.
WORKDIR /tmp

RUN wget https://cdn.hpccsystems.com/releases/CE-Candidate-8.2.18/bin/clienttools/hpccsystems-clienttools-community_8.2.18-1focal_amd64.deb
RUN sudo apt-get install -y --fix-missing ./hpccsystems-clienttools-community_8.2.18-1focal_amd64.deb
RUN rm -f hpccsystems-clienttools-community_8.2.18-1focal_amd64.deb
RUN ecl bundle install https://github.com/hpcc-systems/ML_Core.git
RUN ecl bundle install https://github.com/hpcc-systems/LearningTrees.git
RUN ecl bundle install https://github.com/hpcc-systems/Visualizer.git
RUN ecl bundle install https://github.com/hpcc-systems/DataPatterns.git --update --force
