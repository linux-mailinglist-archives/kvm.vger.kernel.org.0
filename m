Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24D0F88623
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2019 00:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbfHIWgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 18:36:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46510 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIWgk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 18:36:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so99556184wru.13;
        Fri, 09 Aug 2019 15:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=fvKIxSYIddDWQf6VIWwU2gRyHhiEehS8mDHcQsKbXzs=;
        b=IdDRpBzOrMNWuYDjQ6P4tI9SgYZ12OhST86/DzvyGE0OHsdfoziLsACizUMa75Mkj3
         bnmYymRsA62LDisDr1NOARRT5gmXXm0fVO/znsLS05y8UsxPidA/TMXjmXMPVw3kuAQY
         Q2KdsBA+ABfQAXA6NcX5wR4f8YcOhVkVCIQlWGEzaFM93AD3RkpZ34olLEmehup3tFPk
         5lQaOU6BrOKb4IIz1nPN7PfjZhp63UIhOBv/mMC7KVuy14ScAck81BnIWKtdnkSvH95K
         FKyl0ogOJmifT4MHLzarjq2LgYfNr2CENFmhjpNkA4AiTCl0vbuw3wcHwhnXWFZwCpNY
         UGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=fvKIxSYIddDWQf6VIWwU2gRyHhiEehS8mDHcQsKbXzs=;
        b=E+Ihubvmq9wE13mv7ox4rNIh6sawcTc/8WZXTxEhVbLMIMw24+nNubYa695UEyzBo8
         nH1Cz+tBYntyTzMV0yMgk1YQOn46Pge60nSLFzRVsrC80sWJStsLg4Brlrl+jjqv29tF
         GOjlCvLUB8DAbRJC0ngZpvE4UES42xh80Xq4I2cdb6YyjC0XhyJMe5P4mT4kNfXt7bl3
         3lkspdLg43p7MW6dZvHuos4Wv8G6AO+VqTI1w2Zc32W1AVR1ayQavVKLrYOzqDZuLmdu
         BTDnDhu5LmAsrcMIkskO9f0ioJYowdv482se2whN32DQuw6g60ALZkXFp6UKeoDKTzqK
         SIKQ==
X-Gm-Message-State: APjAAAXFyPSlpRslBGVhDOuAVq+46SM4nGcpR3eOJh13VjYRrwPWzW0B
        1fQQCMcEDEJnCXGAbxaU9F081ayr
X-Google-Smtp-Source: APXvYqwv8W0D/t4I6A6Fxht9VJKtklqtrHDaiY0CA343Vfmq0Jk4MfNXSYF59MxwVnMeQOmzWifQHA==
X-Received: by 2002:a5d:6981:: with SMTP id g1mr6291575wru.193.1565390198261;
        Fri, 09 Aug 2019 15:36:38 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g25sm7642951wmk.18.2019.08.09.15.36.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 15:36:36 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.3-rc4
Date:   Sat, 10 Aug 2019 00:36:35 +0200
Message-Id: <1565390195-16920-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 266e85a5ec9100dcd9ae03601453bbc96fefee5d:

  KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption (2019-07-24 13:56:53 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to a738b5e75b4c13be3485c82eb62c30047aa9f164:

  Merge tag 'kvmarm-fixes-for-5.3-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2019-08-09 16:53:50 +0200)

----------------------------------------------------------------

Bugfixes (arm and x86) and cleanups.

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts on enable

Anders Roxell (3):
      arm64: KVM: regmap: Fix unexpected switch fall-through
      KVM: arm: vgic-v3: Mark expected switch fall-through
      arm64: KVM: hyp: debug-sr: Mark expected switch fall-through

Greg KH (1):
      KVM: no need to check return value of debugfs_create functions

Marc Zyngier (3):
      KVM: arm/arm64: Sync ICH_VMCR_EL2 back when about to block
      KVM: arm64: Don't write junk to sysregs on reset
      KVM: arm: Don't write junk to CP15 registers on reset

Naresh Kamboju (1):
      selftests: kvm: Adding config fragments

Paolo Bonzini (5):
      KVM: remove kvm_arch_has_vcpu_debugfs()
      x86: kvm: remove useless calls to kvm_para_available
      kvm: remove unnecessary PageReserved check
      Merge tag 'kvmarm-fixes-for-5.3' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      Merge tag 'kvmarm-fixes-for-5.3-2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD

Thomas Huth (1):
      KVM: selftests: Update gitignore file for latest changes

Wanpeng Li (3):
      KVM: LAPIC: Don't need to wakeup vCPU twice afer timer fire
      KVM: Check preempted_in_kernel for involuntary preemption
      KVM: Fix leak vCPU's VMCS value into other pCPU

Zenghui Yu (2):
      KVM: arm/arm64: Introduce kvm_pmu_vcpu_init() to setup PMU counter index
      KVM: arm64: Update kvm_arm_exception_class and esr_class_str for new EC

 arch/arm/kvm/coproc.c                  | 23 ++++++++-----
 arch/arm64/include/asm/kvm_arm.h       |  7 ++--
 arch/arm64/kernel/traps.c              |  1 +
 arch/arm64/kvm/hyp/debug-sr.c          | 30 +++++++++++++++++
 arch/arm64/kvm/regmap.c                |  5 +++
 arch/arm64/kvm/sys_regs.c              | 32 ++++++++++--------
 arch/mips/kvm/mips.c                   | 10 ------
 arch/powerpc/kvm/powerpc.c             | 15 +++------
 arch/s390/kvm/kvm-s390.c               | 10 ------
 arch/x86/include/asm/kvm_host.h        |  3 ++
 arch/x86/kernel/kvm.c                  |  8 -----
 arch/x86/kvm/debugfs.c                 | 46 ++++++++-----------------
 arch/x86/kvm/lapic.c                   |  8 -----
 arch/x86/kvm/svm.c                     |  6 ++++
 arch/x86/kvm/vmx/vmx.c                 |  6 ++++
 arch/x86/kvm/x86.c                     | 16 +++++++++
 include/kvm/arm_pmu.h                  |  2 ++
 include/kvm/arm_vgic.h                 |  1 +
 include/linux/kvm_host.h               |  6 ++--
 tools/testing/selftests/kvm/.gitignore |  3 +-
 tools/testing/selftests/kvm/config     |  3 ++
 virt/kvm/arm/arm.c                     | 18 +++++++---
 virt/kvm/arm/hyp/vgic-v3-sr.c          |  8 +++++
 virt/kvm/arm/pmu.c                     | 18 ++++++++--
 virt/kvm/arm/vgic/vgic-mmio.c          | 16 +++++++++
 virt/kvm/arm/vgic/vgic-v2.c            |  9 ++++-
 virt/kvm/arm/vgic/vgic-v3.c            |  7 +++-
 virt/kvm/arm/vgic/vgic.c               | 11 ++++++
 virt/kvm/arm/vgic/vgic.h               |  2 ++
 virt/kvm/kvm_main.c                    | 61 ++++++++++++++++++++--------------
 30 files changed, 249 insertions(+), 142 deletions(-)
