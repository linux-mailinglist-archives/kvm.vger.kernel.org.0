Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED8816AFD1
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 19:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbgBXS5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 13:57:53 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39765 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBXS5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 13:57:53 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so430163wme.4;
        Mon, 24 Feb 2020 10:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=aQRhD9hViNOdfqkPRzFwHAM04jgTQv3FSxcn1Z2TBAs=;
        b=ThSS+lG1FnRduPHMNFueF2fpUzcUWyQB63bcTouvvVJWxUMYRapCmy1E2wZoXY+sP6
         6+ZtkFX+4eflwMBDBUD4ULb2iNtnvaASIjzFJMFM7+VCjNRJC5wSFtfhed3Yaqd12uJ7
         T3kaKUXcVSBu7pJcE/12OMpu5RHpzy7hxwNBgdAjTee1KsGAIjrf4XGBu4jFrhy39A/d
         TYdYnOZITlZEH66ZZeSk72PJWC9qPoXQ5pLnOAYMmmpZJf1p0ho3ndKBOQquHsuD88zA
         z645dLZIEjvHmHjL4Oz47jSpHN2EmBASD+33w1nB0evjJsOp9ys5SuS2fah5LO4+lZK+
         /9dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=aQRhD9hViNOdfqkPRzFwHAM04jgTQv3FSxcn1Z2TBAs=;
        b=CQdTzlmxBor/+b3yaN0QJfF1+pS1d3y8XTCSOyQ38QAu9XDPas/MaGw+OY4rP+KdKc
         x3+yL6Phe9TfEnNT0lWv0HYNuwFRGFUW/mtWr4S2LEjpFoHaHGiMObvdQ6bVPo4XBDat
         HnQRt34h7LcvGyCh/e7VGqjdz5h/2PXbwqI35pkPt/62k8Bpau+o9uCGLGR7huOnaBza
         mi1DbT0nKEgxCkIvT7HSGppvzVADENJ9WWKP2Jlq//JlowE3n8NQqu25P0e3kcjNiIid
         b5ji2JxUV4NAVTJo2UfY4FEJVUW3Tsnxi/gVV897YnOLO8TcKMq9t/Fv8j3VpRU07mNy
         TqRw==
X-Gm-Message-State: APjAAAVYJ8SkRaQF2+GAdRHqkWXoZ4zUuNfaha3XhHEZsJEX/Hh3MCm6
        pSkh0IwTz2BVGtDyz6joR6AWSvf9
X-Google-Smtp-Source: APXvYqwXtl93vM0GQoS/Inue+qM/b3QuF68VzbSt9SrrlANF/Xx786+GjGcyrQ6vVHF4Ij4wEx7x5A==
X-Received: by 2002:a1c:44d:: with SMTP id 74mr431615wme.53.1582570671045;
        Mon, 24 Feb 2020 10:57:51 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a16sm20491965wrx.87.2020.02.24.10.57.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:57:50 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.6-rc4
Date:   Mon, 24 Feb 2020 19:57:49 +0100
Message-Id: <1582570669-45822-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 120881b9e888689cbdb90a1dd1689684d8bc95f3:

  docs: virt: guest-halt-polling.txt convert to ReST (2020-02-12 20:10:08 +0100)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a93236fcbe1d0248461b29c0f87cb0b510c94e6f:

  KVM: s390: rstify new ioctls in api.rst (2020-02-24 19:28:40 +0100)

----------------------------------------------------------------
Bugfixes, including the fix for CVE-2020-2732 and a few
issues found by "make W=1".

----------------------------------------------------------------
Christian Borntraeger (1):
      KVM: s390: rstify new ioctls in api.rst

Li RongQing (1):
      KVM: fix error handling in svm_hardware_setup

Miaohe Lin (4):
      KVM: nVMX: Fix some obsolete comments and grammar error
      KVM: x86: don't notify userspace IOAPIC on edge-triggered interrupt EOI
      KVM: apic: avoid calculating pending eoi from an uninitialized val
      KVM: SVM: Fix potential memory leak in svm_cpu_init()

Oliver Upton (3):
      KVM: nVMX: Emulate MTF when performing instruction emulation
      KVM: nVMX: Refactor IO bitmap checks into helper function
      KVM: nVMX: Check IO instruction VM-exit conditions

Paolo Bonzini (4):
      KVM: x86: enable -Werror
      KVM: x86: fix missing prototypes
      KVM: x86: fix incorrect comparison in trace event
      KVM: nVMX: Don't emulate instructions in guest mode

Qian Cai (1):
      kvm/emulate: fix a -Werror=cast-function-type

Suravee Suthikulpanit (1):
      kvm: x86: svm: Fix NULL pointer dereference when AVIC not enabled

Vitaly Kuznetsov (2):
      KVM: nVMX: handle nested posted interrupts when apicv is disabled for L1
      KVM: nVMX: clear PIN_BASED_POSTED_INTR from nested pinbased_ctls only when apicv is globally disabled

Xiaoyao Li (1):
      KVM: VMX: Add VMX_FEATURE_USR_WAIT_PAUSE

wanpeng li (1):
      KVM: nVMX: Hold KVM's srcu lock when syncing vmcs12->shadow

 Documentation/virt/kvm/api.rst     |  33 +++++-----
 arch/x86/include/asm/kvm_emulate.h |  13 +++-
 arch/x86/include/asm/kvm_host.h    |   3 +-
 arch/x86/include/asm/vmx.h         |   2 +-
 arch/x86/include/asm/vmxfeatures.h |   1 +
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/Makefile              |   1 +
 arch/x86/kvm/emulate.c             |  36 ++++------
 arch/x86/kvm/irq_comm.c            |   2 +-
 arch/x86/kvm/lapic.c               |   9 ++-
 arch/x86/kvm/mmutrace.h            |   2 +-
 arch/x86/kvm/svm.c                 |  65 ++++++++++---------
 arch/x86/kvm/vmx/capabilities.h    |   1 +
 arch/x86/kvm/vmx/nested.c          |  89 ++++++++++++++++++-------
 arch/x86/kvm/vmx/nested.h          |  10 ++-
 arch/x86/kvm/vmx/vmx.c             | 130 +++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.h             |   3 +
 arch/x86/kvm/x86.c                 |   2 +
 include/linux/kvm_host.h           |   2 +
 19 files changed, 284 insertions(+), 121 deletions(-)
