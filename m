Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF4BE294
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732803AbfIYQhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:37:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728465AbfIYQhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:37:22 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3FD0810C0317;
        Wed, 25 Sep 2019 16:37:22 +0000 (UTC)
Received: from thuth.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3788560E1C;
        Wed, 25 Sep 2019 16:37:18 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 00/17] New s390x kvm-unit-tests and some fixes
Date:   Wed, 25 Sep 2019 18:36:57 +0200
Message-Id: <20190925163714.27519-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 25 Sep 2019 16:37:22 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Paolo, hi Radim,
 
the following changes since commit 5eb7ccf658f29642ca6c197fd086f4da0d8d8a73:

  x86: VMX: INVEPT after modifying PA mapping in ept_untwiddle (2019-09-11 17:45:28 +0200)

are available in the Git repository at:

  https://gitlab.com/huth/kvm-unit-tests.git tags/s390x-2019-09-25

for you to fetch changes up to 2d8b2d367ed9f545fbf0fca25cb1cbc4fbfe3f00:

  s390x: Free allocated page in iep test (2019-09-25 18:20:37 +0200)

Please note that this supersedes my unmerged pull request from last week.

----------------------------------------------------------------
New s390x kvm-unit-tests and some fixes from Janosch Frank
----------------------------------------------------------------

Janosch Frank (17):
      s390x: Support PSW restart boot
      s390x: Diag288 test
      s390x: Move stsi to library
      s390x: STSI tests
      s390x: Add diag308 subcode 0 testing
      s390x: Move pfmf to lib and make address void
      s390x: Storage key library functions now take void ptr addresses
      s390x: Bump march to zEC12
      s390x: Add storage key removal facility
      s390x: Fix stsi unaligned test and add selector tests
      s390x: Use interrupts in SCLP and add locking
      s390x: Add linemode console
      s390x: Add linemode buffer to fix newline on every print
      s390x: Add initial smp code
      s390x: Prepare for external calls
      s390x: SMP test
      s390x: Free allocated page in iep test

 lib/s390x/asm/arch_def.h  |  30 ++++++
 lib/s390x/asm/interrupt.h |   5 +
 lib/s390x/asm/mem.h       |  40 ++++++--
 lib/s390x/asm/sigp.h      |  28 +++++-
 lib/s390x/interrupt.c     |  27 ++++-
 lib/s390x/io.c            |   5 +-
 lib/s390x/sclp-console.c  | 216 ++++++++++++++++++++++++++++++++++++---
 lib/s390x/sclp.c          |  55 +++++++++-
 lib/s390x/sclp.h          |  59 ++++++++++-
 lib/s390x/smp.c           | 252 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/smp.h           |  53 ++++++++++
 s390x/Makefile            |   7 +-
 s390x/cstart64.S          |  34 +++++++
 s390x/diag288.c           | 114 +++++++++++++++++++++
 s390x/diag308.c           |  31 ++----
 s390x/flat.lds            |  14 ++-
 s390x/iep.c               |   1 +
 s390x/pfmf.c              |  71 +++++--------
 s390x/skey.c              |  47 +++------
 s390x/skrf.c              | 128 +++++++++++++++++++++++
 s390x/smp.c               | 242 ++++++++++++++++++++++++++++++++++++++++++++
 s390x/stsi.c              |  86 ++++++++++++++++
 s390x/unittests.cfg       |  11 ++
 23 files changed, 1419 insertions(+), 137 deletions(-)
 create mode 100644 lib/s390x/smp.c
 create mode 100644 lib/s390x/smp.h
 create mode 100644 s390x/diag288.c
 create mode 100644 s390x/skrf.c
 create mode 100644 s390x/smp.c
 create mode 100644 s390x/stsi.c
