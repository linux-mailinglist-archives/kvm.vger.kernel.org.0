Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370F6151646
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 08:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgBDHNt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 02:13:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725834AbgBDHNs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 02:13:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580800427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Wty2W1K09/29/4bSM1LYRouCR57zegW52usmFcmkGLs=;
        b=hT6BXhvRwTlYvFdxYw5uP+gPE0Q2faJ77T68ck6TZMfMuI5mDsLLPEUGij61OUZ6SQI7Ba
        BX/j0BuPgYiCix4jtH1ew/ynbIUhED6TOP6DYWLR+HebMqXLSJ3oehYOEnLcwFVmRUOBfp
        kyMC9OGusPr6nd76bbzIod3T3iJ4Xc8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-nlq_PxfEOym9kC8DEEgBCw-1; Tue, 04 Feb 2020 02:13:43 -0500
X-MC-Unique: nlq_PxfEOym9kC8DEEgBCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 742EB1137841
        for <kvm@vger.kernel.org>; Tue,  4 Feb 2020 07:13:42 +0000 (UTC)
Received: from thuth.com (ovpn-116-39.ams2.redhat.com [10.36.116.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECF025C1D8;
        Tue,  4 Feb 2020 07:13:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     david@redhat.com
Subject: [kvm-unit-tests PULL 0/9] s390x and CI patches
Date:   Tue,  4 Feb 2020 08:13:26 +0100
Message-Id: <20200204071335.18180-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 Hi Paolo,

the following changes since commit 477310421016368983e0be2639b91fc13d47e36d:

  Merge tag 's390x-2020-01-30' of https://github.com/davidhildenbrand/kvm-unit-tests into HEAD (2020-01-30 18:11:59 +0100)

are available in the Git repository at:

  https://gitlab.com/huth/kvm-unit-tests.git tags/s390x-2020-02-04

for you to fetch changes up to 00e4483399bd57c9b49f8e79c9aacf0024193536:

  travis.yml: Prevent 'script' from premature exit (2020-02-04 07:56:37 +0100)

----------------------------------------------------------------
* s390x smp patches from Janosch
* Updates for the gitlab and Travis CI
----------------------------------------------------------------

Janosch Frank (7):
      s390x: smp: Cleanup smp.c
      s390x: smp: Fix ecall and emcall report strings
      s390x: Stop the cpu that is executing exit()
      s390x: Add cpu id to interrupt error prints
      s390x: smp: Only use smp_cpu_setup once
      s390x: smp: Rework cpu start and active tracking
      s390x: smp: Wait for cpu setup to finish

Thomas Huth (1):
      gitlab-ci.yml: Remove ioapic from the x86 tests

Wainer dos Santos Moschetta (1):
      travis.yml: Prevent 'script' from premature exit

 .gitlab-ci.yml        |  2 +-
 .travis.yml           |  3 +-
 lib/s390x/interrupt.c | 20 ++++++-------
 lib/s390x/io.c        |  2 +-
 lib/s390x/smp.c       | 59 +++++++++++++++++++++++--------------
 s390x/cstart64.S      |  2 ++
 s390x/smp.c           | 80 +++++++++++++++++++++++++++++++--------------------
 7 files changed, 102 insertions(+), 66 deletions(-)

