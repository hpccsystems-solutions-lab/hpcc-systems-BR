FROM gitpod/workspace-full

RUN sudo apt-get -y update

# Install the latest hpccsystems clienttools and required ML bundles.
WORKDIR /tmp

RUN wget https://cdn.hpccsystems.com/releases/CE-Candidate-8.4.12/bin/platform/hpccsystems-platform-community_8.4.12-1focal_amd64.deb
RUN sudo apt-get install -y --fix-missing ./hpccsystems-platform-community_8.4.12-1focal_amd64.deb
RUN rm -f hpccsystems-platform-community_8.4.12-1focal_amd64.deb
COPY ./environment/*.xml /etc/HPCCSystems

RUN ecl bundle install https://github.com/hpcc-systems/ML_Core.git
RUN ecl bundle install https://github.com/hpcc-systems/LearningTrees.git
RUN ecl bundle install https://github.com/hpcc-systems/Visualizer.git
RUN ecl bundle install https://github.com/hpcc-systems/DataPatterns.git
