Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7494227B39B
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgI1RuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40852 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgI1RuN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:13 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=vN7WzldusaKhlRAuePh92B0vVXzTNGz9OjZAHACw6VE=;
        b=e3EREt2VTfVkXg81ULImmDASeF7eDEGO7njrpWnQtCsyJ8oh55+qJL6TO7S8MlSUg/HMlQ
        QPpghmFP034zwa2i2E4ltWZSDMsBGidE2tZvDh2EnFCeqAfzin/yGAqNwLQ8F791MVLuxC
        HY6oEdMwUfjxdncraNxl1pLa4l8YOvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-n0Ooviu2OLmdpekXqCI5Qw-1; Mon, 28 Sep 2020 13:50:04 -0400
X-MC-Unique: n0Ooviu2OLmdpekXqCI5Qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C4C5801AAF;
        Mon, 28 Sep 2020 17:50:03 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AC712100238C;
        Mon, 28 Sep 2020 17:50:01 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 00/11] s390x and generic script updates
Date:   Mon, 28 Sep 2020 19:49:47 +0200
Message-Id: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Paolo,

the following changes since commit 58c94d57a51a6927a68e3f09627b2d85e3404c0f:

  travis.yml: Use TRAVIS_BUILD_DIR to refer to the top directory (2020-09-25 10:00:36 +0200)

are available in the Git repository at:

  https://gitlab.com/huth/kvm-unit-tests.git tags/pull-request-2020-09-28

for you to fetch changes up to b508e1147055255ecce93a95916363bda8c8f299:

  scripts/arch-run: use ncat rather than nc. (2020-09-28 15:03:50 +0200)

----------------------------------------------------------------
- s390x protected VM support
- Some other small s390x improvements
- Generic improvements in the scripts (better TAP13 names, nc -> ncat, ...)
----------------------------------------------------------------

Jamie Iles (1):
      scripts/arch-run: use ncat rather than nc.

Marc Hartmayer (6):
      runtime.bash: remove outdated comment
      Use same test names in the default and the TAP13 output format
      common.bash: run `cmd` only if a test case was found
      scripts: add support for architecture dependent functions
      run_tests/mkstandalone: add arch_cmd hook
      s390x: add Protected VM support

Thomas Huth (4):
      configure: Add a check for the bash version
      travis.yml: Update from Bionic to Focal
      travis.yml: Update the list of s390x tests
      s390x/selftest: Fix constraint of inline assembly

 .travis.yml             |  7 ++++---
 README.md               |  3 ++-
 configure               | 14 ++++++++++++++
 run_tests.sh            | 18 +++++++++---------
 s390x/Makefile          | 15 ++++++++++++++-
 s390x/selftest.c        |  2 +-
 s390x/selftest.parmfile |  1 +
 s390x/unittests.cfg     |  1 +
 scripts/arch-run.bash   |  6 +++---
 scripts/common.bash     | 21 +++++++++++++++++++--
 scripts/mkstandalone.sh |  4 ----
 scripts/runtime.bash    |  9 +++------
 scripts/s390x/func.bash | 35 +++++++++++++++++++++++++++++++++++
 13 files changed, 106 insertions(+), 30 deletions(-)
 create mode 100644 s390x/selftest.parmfile
 create mode 100644 scripts/s390x/func.bash

