Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C877470686
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbhLJRBo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 12:01:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240761AbhLJRBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 12:01:43 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D42C061746
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:58:08 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id hg9-20020a17090b300900b001a6aa0b7d8cso6305188pjb.2
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 08:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fSK6uHWpIJtKlImgMjXDQsAlhLi/T4fDrdTrYPdabAk=;
        b=gmoRl0JH3HLkq9IL2jXGgIdQqdHGIeAGwBt+zx0S/xteTkOC1hfbnn6ff+JIlgbAoh
         O/I593FGaV5VSWeswt0lLn1YRwvhjnN43y/RHE+tbBtrFXzzi5cJ16TZ5+QmPqljIxcV
         dCwF7OoROFOL1Q4z/AuWHgxdeGMWyf/T7lngi1HjEaItOXrqxN7s9acLAyqlxEP/f9eI
         QRlzC5VrcypA/suqvn+whHN0KndQHjAWpveakO+R0IsNDsADFbfqtH5nPfqLdRiRbW73
         LR45QEm3Oazr60IaY0Jm6a/Hu+aYvMDQjtC/ixdkWIV8pLtqt1u+rioUqHt0gpgiAlED
         2SKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fSK6uHWpIJtKlImgMjXDQsAlhLi/T4fDrdTrYPdabAk=;
        b=xlobn7mN/K3fzOCh4k3DT9KLKeNzbpqEjtenQ/YyLFJmmOk6Fd8luZr+4ZQSCxd9Iv
         mFH42lf2F9Tf+ePCDwH9IoZAeCmkDOB1r9sPXfnifBFtRMqqpVT716B2mw2e7xyom60D
         5Gb30/m3935H/jmtW95V4Bgd24tr9gEFWHZqy4DoSZKD++W3mHS4OMcaUt5Uqlmuk5rM
         2X2U4BpMO8ye8zCkOZGn03hlEKAC0L7Z5RNhoCy9eC14WWNCI4Qjke9saWs/j1Bja3eO
         jTjx35uPJmgO0QjkyUa/BjYGAGlJJBSesZX0Qwpn75pPimwlIQf65Eb7LDy9aKWxuGxT
         JpfA==
X-Gm-Message-State: AOAM5333OvUgP5HtHrEag9LZzm5R4D0B2HFzR3ZjrLxJAS8bxGbXMjlk
        G8k64iiSAxutSAQZyUroBeMf5IiyktmWZ6M88c1nwWM+tuNxfJ9dYl5e5/1t1NZZyPYSSGN2Y/o
        MAJngEks+49lWdLBzk+5aYdIVDDEheC9v5mXYBvvyBZA6sEspfGH8OkcmEHAr2yU=
X-Google-Smtp-Source: ABdhPJw9a4fTHT/klzsxj+qfZk9tqXdFz3Y92zbP0NFlSiAPFcP7FkkuxV6XyfkLNiDuI4EvRD6YfEfxyb/mow==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:6342:: with SMTP id
 x63mr40205115pgb.295.1639155487878; Fri, 10 Dec 2021 08:58:07 -0800 (PST)
Date:   Fri, 10 Dec 2021 08:58:01 -0800
Message-Id: <20211210165804.1623253-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for
 debug state
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        maz@kernel.org, oupton@google.com, yuzenghui@huawei.com,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some tests for checking that we can migrate debug state correctly: setup
some breakpoints/watchpoints/single-stepping, migrate, and then check that we
get the expected exceptions.

The 3 patches in this series add tests for breakpoints, watchpoints, and
single-stepping one patch at a time.  Each patch adds a migration test and a
sanity test (to test that debugging works with no migration).

Note that this is limited to 64-bits and a single vcpu. Also note that some of
the code, like reset_debug_state, is borrowed from kvm selftests.

Ricardo Koller (3):
  arm64: debug: add a migration test for breakpoint state
  arm64: debug: add a migration test for watchpoint state
  arm64: debug: add a migration test for single-step state

 arm/Makefile.arm64 |   1 +
 arm/debug.c        | 420 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  37 ++++
 3 files changed, 458 insertions(+)
 create mode 100644 arm/debug.c

-- 
2.34.1.173.g76aa8bc2d0-goog

