Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342C044CB37
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 22:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbhKJVW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 16:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhKJVW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 16:22:56 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C52C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:06 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h62-20020a25a544000000b005c5d9b06e57so5928629ybi.6
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 13:20:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=mpoSypm/slJD1LNgKUFtixX1m5JXkGVzyzCFlMc0bmU=;
        b=Ctozo/aeEoEn4s+WiskNc0i5I1ufyPkFuAOcNdaUBxhul5t9/FmhTHOTUqGQeoFcAO
         Y5e+WqDsyDAp0aFmw/Tt8aiu9WkQ6sJur8dr57F5ZxXAneTTeFf2NcHUCrg9/RF61HX4
         F2RYdbbuyE2es/Kl7CYm9g45HiZiyjFwG7rynpyv3yZQ40DLNdh5ag1/rTXYy9p2z5Py
         xwhNZJGVx+4o9iiUcOBvMRDobiwwBa3dr74hz7GszVOnMUTPSut1gpkR1yyk/osdaNJv
         /Zjm2YfKyfdONBCpzDdngwubfCIwPKDFuucL/39nZC49S7yUwUN205eXyx5fkV1UIMNU
         giiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=mpoSypm/slJD1LNgKUFtixX1m5JXkGVzyzCFlMc0bmU=;
        b=qI7diaU2MZWKWdH2eiTa237ShlLy6xDzGIA814HOcFXJiJqdZed456NK8mVpjSckwd
         0K8hnKlVGB+g5k+aJBG1xdbpU29S9talvmcSMDfmAAD6o34rhJZJVUXjEbQB39d9F8ST
         GjJ5l1GZ6njaQSY/5X7YXNyXJ9mxoXgxhD4TRMCgDpmTtWt/8f3SEGnKDfmfmk3LatcO
         fqlx10Av8FW5tDikhyQXYoGfkYT7rGFR+YDSEyp4WmpF5DC0BIXCtyaNOrQKT05PHU9Z
         PNCSaOcfc+Do1WUOf3WkB1DKcLrvhnItqQPDJPMxCFMYRHoIv7sAanKPJ8b8Nf1N4SZO
         mIHw==
X-Gm-Message-State: AOAM530VXd4vTlEMTFe3o4cQp70FFEzevAeCNm8MZ4b8kkrusLrYAyck
        5ILwpgRZDh6wNskiocuri8KY/YRl5sKnHspzcPvCRE5BFaZkFHUf1ZwDRo5bkrflx3lBIBjVnSa
        l1cbmsNpBcr1xpDYSWl8YxKzY9lId0CxNSo5L+NTre51fKA/ZxZ7jX35BPS68nG6CtVlS
X-Google-Smtp-Source: ABdhPJyep1VzL1Gy0TpFupm8xlRry392a+l/2YQMVOSHaaZVA097o0aYKAeCOUUihYgSJwmHpUqz93OyHR9WWW+G
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:db45:: with SMTP id
 g66mr2733708ybf.243.1636579205989; Wed, 10 Nov 2021 13:20:05 -0800 (PST)
Date:   Wed, 10 Nov 2021 21:19:47 +0000
Message-Id: <20211110212001.3745914-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [kvm-unit-tests PATCH 00/14] Run access test in an L2 guest
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The motivation behind this change is to test the routing logic when an
exception occurs in an L2 guest and ensure the exception goes to the
correct place.  For example, if an exception occurs in L2, does L1 want
to get involved, or L0, or do niether of them care about it and leave
it to L2 to handle.  Test that the exception doesn't end up going to L1
When L1 didn't ask for it.  This was occurring before commit 18712c13709d
("KVM: nVMX: Use vmx_need_pf_intercept() when deciding if L0 wants a #PF")
fixed the issue.  Without that fix, running
vmx_pf_exception_test_reduced_maxphyaddr with allow_smaller_maxphyaddr=Y
would have resulted in the test failing with the following error:

x86/vmx_tests.c:10698: assert failed: false: Unexpected exit to L1,
exit_reason: VMX_EXC_NMI (0x0)

This series only tests the routing logic for #PFs.  A future
series will address other exceptions, however, getting #PF testing in
place is a big enough chunk that the other exceptions will be submitted
seperately (in a future series).

This series is dependant on Paolo's changes (inlcuded). Without them,
running ac_test_run() on one of the userspace test fails.  Of note:  the
commit ("x86: get rid of ring0stacktop") has been updated to include a fix
for a compiler error to get it building on clang.

This series is also dependant on the commit ("x86: Look up the PTEs rather
than assuming them").  This was sent out for review seperately, however,
it is needed to get ac_test_run() running on a different cr3 than the one
access_test runs on, so it is included here as well.  This is also v2 of
that commit.  While preparing this series a review came in, so I just
included the changes here.

Paolo Bonzini (9):
  x86: cleanup handling of 16-byte GDT descriptors
  x86: fix call to set_gdt_entry
  unify field names and definitions for GDT descriptors
  replace tss_descr global with a function
  x86: Move IDT to desc.c
  x86: unify name of 32-bit and 64-bit GDT
  x86: get rid of ring0stacktop
  x86: Move 64-bit GDT and TSS to desc.c
  x86: Move 32-bit GDT and TSS to desc.c

Aaron Lewis (5):
  x86: Look up the PTEs rather than assuming them (v2)
  x86: Prepare access test for running in L2
  x86: Fix tabs in access.c
  x86: Clean up the global, page_table_levels, in access.c
  x86: Add tests to run ac_test_run() in an L2 guest

 lib/libcflat.h         |    1 +
 lib/x86/asm/setup.h    |    6 +
 lib/x86/desc.c         |  116 +++-
 lib/x86/desc.h         |   31 +-
 lib/x86/setup.c        |   49 ++
 lib/x86/usermode.c     |    9 +-
 lib/x86/vm.c           |   21 +
 lib/x86/vm.h           |    3 +
 x86/Makefile.common    |    4 +
 x86/Makefile.x86_64    |    2 +-
 x86/access.c           | 1447 ++++++++++++++++++++--------------------
 x86/access.h           |    9 +
 x86/access_test.c      |   20 +
 x86/cstart.S           |  115 +---
 x86/cstart64.S         |   98 +--
 x86/flat.lds           |    1 +
 x86/smap.c             |    2 +-
 x86/svm_tests.c        |   15 +-
 x86/taskswitch.c       |    4 +-
 x86/umip.c             |   19 +-
 x86/unittests.cfg      |   17 +-
 x86/vmware_backdoors.c |   22 +-
 x86/vmx.c              |   17 +-
 x86/vmx_tests.c        |   53 +-
 24 files changed, 1080 insertions(+), 1001 deletions(-)
 create mode 100644 lib/x86/asm/setup.h
 create mode 100644 x86/access.h
 create mode 100644 x86/access_test.c

-- 
2.34.0.rc1.387.gb447b232ab-goog

