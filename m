Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54F272E8B
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbfGXMQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 08:16:06 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55186 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfGXMQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 08:16:06 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so41602249wme.4;
        Wed, 24 Jul 2019 05:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=SLt95QYbjQo4qkZN/GwEGgN0OUNxg3y/mONcPhKuAqY=;
        b=MhdwV55oPsXubgTXUOYG0oxOZTQiJundGhkrJpMdcknYzOV8SpYqCsYCvFIiiU7qqW
         T3qREmkPF1z1fEP455xBMeGDz9GlRvMRRJMptGUe34+OTlW0zAdcSa0Pz/iYNze+VS15
         7cG7BGNPqpywKStA5TeHr3fLX6VIMSGW07oPpftAixOP8UYUcG0C6B3PnAqF6G1w063Y
         gHXkllCZExUeQayQ9pcyHX6UDzhFxkENHkH8Zu3roS6TjieITiLmgHThclhTtsog9xQD
         Ub9BQnfSzj3f3icw6pMSkJhyqcRv23C79djXQYJnTFsgv2EDjL8iECcdObLUe2HmMMMR
         rcWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=SLt95QYbjQo4qkZN/GwEGgN0OUNxg3y/mONcPhKuAqY=;
        b=aCXnDj6vJvSd5RpYzqY5QPGqLZOKgiO6bBAEkxT2EYU4qL8JPKr2xEgD2Q6TIWHAdk
         qBb3QrmCTYBPAyGqFObj33/bhoxWbNyt2ddS29s9AKwu8RjtmEb3EmKJwu86jsm4IvTs
         jj54Os3iRgAhYSuugGbVQyboSMyrO2HowXor4GVuGJRMvHE1AWRmAtoskXdzNkRbRzTb
         pOVKDDVAtu4QtuHhWJSN0XX1PQoEMaqwQgCubScPQZ05q0msLkF3mTPiZRkTG1J0g22a
         NKN4FAuwsiB0vi5XfVc4E+pF1IyE2wWhCceCwaW7SvkTyRLlAHtab1tktZbvwL/QIl++
         Qaug==
X-Gm-Message-State: APjAAAX7vTUJ6HerR2rSfZ1QWSp61jWXU//MzNgQduCzG031H6vr0i2b
        rixM7t6xDhNp8qq23NEOTO2k4fZg3eA=
X-Google-Smtp-Source: APXvYqxLWXrNBrWIjcHD5Vhitxx7W51qWVtaUAHfTjqLntQc/Szx8WPAUClq6rEkyIbPdHHvo1pk3Q==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr75609112wmg.86.1563970563187;
        Wed, 24 Jul 2019 05:16:03 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id o6sm89302289wra.27.2019.07.24.05.16.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 05:16:02 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.3-rc2
Date:   Wed, 24 Jul 2019 14:16:01 +0200
Message-Id: <1563970561-44925-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 30cd8604323dbaf20a80e797fe7057f5b02e394d:

  KVM: x86: Add fixed counters to PMU filter (2019-07-20 09:00:48 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 266e85a5ec9100dcd9ae03601453bbc96fefee5d:

  KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption (2019-07-24 13:56:53 +0200)

----------------------------------------------------------------
Bugfixes, and a pvspinlock optimization

----------------------------------------------------------------
Christoph Hellwig (1):
      Documentation: move Documentation/virtual to Documentation/virt

Jan Kiszka (2):
      KVM: nVMX: Clear pending KVM_REQ_GET_VMCS12_PAGES when leaving nested
      KVM: nVMX: Set cached_vmcs12 and cached_shadow_vmcs12 NULL after free

Paolo Bonzini (1):
      Revert "kvm: x86: Use task structs fpu field for user"

Wanpeng Li (3):
      KVM: X86: Fix fpu state crash in kvm guest
      KVM: X86: Dynamically allocate user_fpu
      KVM: X86: Boost queue head vCPU to mitigate lock waiter preemption

 Documentation/admin-guide/kernel-parameters.txt          |  2 +-
 Documentation/{virtual => virt}/index.rst                |  0
 .../{virtual => virt}/kvm/amd-memory-encryption.rst      |  0
 Documentation/{virtual => virt}/kvm/api.txt              |  2 +-
 Documentation/{virtual => virt}/kvm/arm/hyp-abi.txt      |  0
 Documentation/{virtual => virt}/kvm/arm/psci.txt         |  0
 Documentation/{virtual => virt}/kvm/cpuid.rst            |  0
 Documentation/{virtual => virt}/kvm/devices/README       |  0
 .../{virtual => virt}/kvm/devices/arm-vgic-its.txt       |  0
 .../{virtual => virt}/kvm/devices/arm-vgic-v3.txt        |  0
 Documentation/{virtual => virt}/kvm/devices/arm-vgic.txt |  0
 Documentation/{virtual => virt}/kvm/devices/mpic.txt     |  0
 .../{virtual => virt}/kvm/devices/s390_flic.txt          |  0
 Documentation/{virtual => virt}/kvm/devices/vcpu.txt     |  0
 Documentation/{virtual => virt}/kvm/devices/vfio.txt     |  0
 Documentation/{virtual => virt}/kvm/devices/vm.txt       |  0
 Documentation/{virtual => virt}/kvm/devices/xics.txt     |  0
 Documentation/{virtual => virt}/kvm/devices/xive.txt     |  0
 Documentation/{virtual => virt}/kvm/halt-polling.txt     |  0
 Documentation/{virtual => virt}/kvm/hypercalls.txt       |  4 ++--
 Documentation/{virtual => virt}/kvm/index.rst            |  0
 Documentation/{virtual => virt}/kvm/locking.txt          |  0
 Documentation/{virtual => virt}/kvm/mmu.txt              |  2 +-
 Documentation/{virtual => virt}/kvm/msr.txt              |  0
 Documentation/{virtual => virt}/kvm/nested-vmx.txt       |  0
 Documentation/{virtual => virt}/kvm/ppc-pv.txt           |  0
 Documentation/{virtual => virt}/kvm/review-checklist.txt |  2 +-
 Documentation/{virtual => virt}/kvm/s390-diag.txt        |  0
 Documentation/{virtual => virt}/kvm/timekeeping.txt      |  0
 Documentation/{virtual => virt}/kvm/vcpu-requests.rst    |  0
 Documentation/{virtual => virt}/paravirt_ops.rst         |  0
 .../{virtual => virt}/uml/UserModeLinux-HOWTO.txt        |  0
 MAINTAINERS                                              |  6 +++---
 arch/powerpc/include/uapi/asm/kvm_para.h                 |  2 +-
 arch/x86/include/asm/kvm_host.h                          |  7 ++++---
 arch/x86/kvm/mmu.c                                       |  2 +-
 arch/x86/kvm/svm.c                                       | 13 ++++++++++++-
 arch/x86/kvm/vmx/nested.c                                |  4 ++++
 arch/x86/kvm/vmx/vmx.c                                   | 13 ++++++++++++-
 arch/x86/kvm/x86.c                                       | 16 ++++++++++------
 include/uapi/linux/kvm.h                                 |  4 ++--
 tools/include/uapi/linux/kvm.h                           |  4 ++--
 virt/kvm/arm/arm.c                                       |  2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                         |  2 +-
 virt/kvm/arm/vgic/vgic.h                                 |  4 ++--
 45 files changed, 61 insertions(+), 30 deletions(-)
 rename Documentation/{virtual => virt}/index.rst (100%)
 rename Documentation/{virtual => virt}/kvm/amd-memory-encryption.rst (100%)
 rename Documentation/{virtual => virt}/kvm/api.txt (99%)
 rename Documentation/{virtual => virt}/kvm/arm/hyp-abi.txt (100%)
 rename Documentation/{virtual => virt}/kvm/arm/psci.txt (100%)
 rename Documentation/{virtual => virt}/kvm/cpuid.rst (100%)
 rename Documentation/{virtual => virt}/kvm/devices/README (100%)
 rename Documentation/{virtual => virt}/kvm/devices/arm-vgic-its.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/arm-vgic-v3.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/arm-vgic.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/mpic.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/s390_flic.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/vcpu.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/vfio.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/vm.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/xics.txt (100%)
 rename Documentation/{virtual => virt}/kvm/devices/xive.txt (100%)
 rename Documentation/{virtual => virt}/kvm/halt-polling.txt (100%)
 rename Documentation/{virtual => virt}/kvm/hypercalls.txt (97%)
 rename Documentation/{virtual => virt}/kvm/index.rst (100%)
 rename Documentation/{virtual => virt}/kvm/locking.txt (100%)
 rename Documentation/{virtual => virt}/kvm/mmu.txt (99%)
 rename Documentation/{virtual => virt}/kvm/msr.txt (100%)
 rename Documentation/{virtual => virt}/kvm/nested-vmx.txt (100%)
 rename Documentation/{virtual => virt}/kvm/ppc-pv.txt (100%)
 rename Documentation/{virtual => virt}/kvm/review-checklist.txt (95%)
 rename Documentation/{virtual => virt}/kvm/s390-diag.txt (100%)
 rename Documentation/{virtual => virt}/kvm/timekeeping.txt (100%)
 rename Documentation/{virtual => virt}/kvm/vcpu-requests.rst (100%)
 rename Documentation/{virtual => virt}/paravirt_ops.rst (100%)
 rename Documentation/{virtual => virt}/uml/UserModeLinux-HOWTO.txt (100%)
