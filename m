Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749A7347F10
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhCXROc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:14:32 -0400
Received: from foss.arm.com ([217.140.110.172]:36880 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236630AbhCXROP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:14:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 164C9ED1;
        Wed, 24 Mar 2021 10:14:15 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E9B53F7D7;
        Wed, 24 Mar 2021 10:14:14 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, alexandru.elisei@arm.com,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests PATCH 0/3] Add support for external tests and litmus7 documentation
Date:   Wed, 24 Mar 2021 17:13:59 +0000
Message-Id: <20210324171402.371744-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This set of patches makes small changes to the build system to allow
easy integration of tests not included in the repository. To this end,
it adds a parameter to the configuration script `--ext-dir=DIR` which
will instruct the build system to include the Makefile in
DIR/Makefile. The external Makefile can then add extra tests,
link object files and modify/extend flags.

In addition, to demonstrate how we can use this functionality, a
README file explains how to use litmus7 to generate the C code for
litmus tests and link with kvm-unit-tests to produce flat files.

Note that currently, litmus7 produces its own independent Makefile as
an intermediate step. Once this set of changes is committed, litmus7
will be modifed to make use hook to specify external tests and
leverage the build system to build the external tests
(https://github.com/relokin/herdtools7/commit/8f23eb39d25931c2c34f4effa096df58547a3bb4).

Nikos Nikoleris (3):
  arm/arm64: Avoid wildcard in the arm_clean recipe of the Makefile
  arm/arm64: Add a way to specify an external directory with tests
  README: Add a guide of how to run tests with litmus7

 configure           |   7 +++
 arm/Makefile.common |  11 +++-
 README.litmus7.md   | 125 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+), 2 deletions(-)
 create mode 100644 README.litmus7.md

-- 
2.25.1

