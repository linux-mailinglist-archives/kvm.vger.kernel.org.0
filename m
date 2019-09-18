Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6508FB62B0
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 14:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbfIRMEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 08:04:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730241AbfIRMEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 08:04:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF3A418C4297;
        Wed, 18 Sep 2019 12:04:35 +0000 (UTC)
Received: from thuth.com (ovpn-116-90.ams2.redhat.com [10.36.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14585600CC;
        Wed, 18 Sep 2019 12:04:30 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 0/9] New s390x kvm-unit-tests
Date:   Wed, 18 Sep 2019 14:04:17 +0200
Message-Id: <20190918120426.20832-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 18 Sep 2019 12:04:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Paolo, hi Radim,

the following changes since commit 5eb7ccf658f29642ca6c197fd086f4da0d8d8a73:

  x86: VMX: INVEPT after modifying PA mapping in ept_untwiddle (2019-09-11 17:45:28 +0200)

are available in the Git repository at:

  https://gitlab.com/huth/kvm-unit-tests.git tags/s390x-2019-09-18

for you to fetch changes up to 47df95c747e1c46e7bfb524e734d98a7d9757cb1:

  s390x: Add storage key removal facility (2019-09-18 13:48:09 +0200)

----------------------------------------------------------------
New s390x kvm-unit-tests from Janosch Frank
----------------------------------------------------------------

Janosch Frank (9):
      s390x: Support PSW restart boot
      s390x: Diag288 test
      s390x: Move stsi to library
      s390x: STSI tests
      s390x: Add diag308 subcode 0 testing
      s390x: Move pfmf to lib and make address void
      s390x: Storage key library functions now take void ptr addresses
      s390x: Bump march to zEC12
      s390x: Add storage key removal facility

 lib/s390x/asm/arch_def.h |  17 +++++++
 lib/s390x/asm/mem.h      |  40 ++++++++++++---
 s390x/Makefile           |   5 +-
 s390x/cstart64.S         |  27 ++++++++++
 s390x/diag288.c          | 114 +++++++++++++++++++++++++++++++++++++++++
 s390x/diag308.c          |  31 ++++--------
 s390x/flat.lds           |  14 ++++--
 s390x/pfmf.c             |  71 +++++++++-----------------
 s390x/skey.c             |  47 ++++++-----------
 s390x/skrf.c             | 128 +++++++++++++++++++++++++++++++++++++++++++++++
 s390x/stsi.c             |  84 +++++++++++++++++++++++++++++++
 s390x/unittests.cfg      |   7 +++
 12 files changed, 475 insertions(+), 110 deletions(-)
 create mode 100644 s390x/diag288.c
 create mode 100644 s390x/skrf.c
 create mode 100644 s390x/stsi.c
