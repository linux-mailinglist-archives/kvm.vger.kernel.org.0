Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1176EF3E
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2019 13:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfGTLnM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Jul 2019 07:43:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33063 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbfGTLnM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Jul 2019 07:43:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so25416213wme.0;
        Sat, 20 Jul 2019 04:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=XVV4X3alYKb2X9EHysocks5DqDmw0SO8ilOGMts74Zs=;
        b=p6qIF2FadZEen8ai9zu0WoxyCLHFZns+nZEp2lOxyPSdiZeqJ4cKxjBmTxo8kDGosR
         O7x1uz30V3uq6rD0jxM+5Hm4zH7EM6b/q+y403zN/MPF1p4ZlQYYMhujEM3JhIpzlm+v
         s6WJgHQ4kYI2WlXj75GxeztmrxXN+MNdfPkM7KKLqXjpw9aRRuF8otWim3lKIZSqHA7/
         Dm6YxEpM1PdH9KsKn/hENmVVcMdWRrsFiXYoH0tUjMI5LAw2iDtZOGLKsAFC+MInGlzJ
         TiIKJP5TrBg5HO0EevRdH06KFL0/LKRrHoVjmzeXdxrnvXoQtJSUKEUzzcCWaMDitD3U
         CEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=XVV4X3alYKb2X9EHysocks5DqDmw0SO8ilOGMts74Zs=;
        b=XAajDLz5GLIagAxgY5P75pPX8ASPKUkdUGV77v6k4v2GGzXcbiJjeuOVrVDVQhFlR/
         CWpPNRNUUwTRRlDdaQvFoVqYOTLmKifm7/rwbgD39TpKzzCsuwnzV2qIs7cXYfjRanyK
         EP8gwMaIFD37ial0wszexLYudjP7cqoEBVRmFBn8qHa5w5EspnvGGPM4c/8hE024Qk6Y
         jNFbtTeVWYDiF4s7atDhCTZfHqcXtVP2BJXpTFaIVSb6aiLzP0CyMqSgiKOiuxwiZZ/S
         YodOCA4E6pp4vJED/Ckj7yKzKXvCNkwMQsv2cPaa8H01Tk6H7u0UJl58KYf3Y7lXbK3i
         blLw==
X-Gm-Message-State: APjAAAVsMV9vAVkrksUkVCgW3yeVE2D8HIzSdKNXH+fvaw38MnRDqvtK
        vYvdhzbijYqrsrY69UPNFUg=
X-Google-Smtp-Source: APXvYqzf+D9LIBSrZ42KLnpdqpg4UEiyKywNBWDsLb80+0DyG+rBop/8hhfpEiBaqxJttudl0lM70w==
X-Received: by 2002:a1c:ca14:: with SMTP id a20mr11986794wmg.71.1563622989872;
        Sat, 20 Jul 2019 04:43:09 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g12sm44682270wrv.9.2019.07.20.04.43.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 04:43:09 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] Second batch of KVM changes for 5.3 merge window
Date:   Sat, 20 Jul 2019 13:43:07 +0200
Message-Id: <1563622987-4738-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 964a4eacef67503a1154f7e0a75f52fbdce52022:

  Merge tag 'dlm-5.3' of git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm (2019-07-12 17:37:53 -0700)

are available in the git repository at:


  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 30cd8604323dbaf20a80e797fe7057f5b02e394d:

  KVM: x86: Add fixed counters to PMU filter (2019-07-20 09:00:48 +0200)

----------------------------------------------------------------
Mostly bugfixes, but also:
- s390 support for KVM selftests
- LAPIC timer offloading to housekeeping CPUs
- Extend an s390 optimization for overcommitted hosts to all architectures
- Debugging cleanups and improvements

----------------------------------------------------------------
Arnd Bergmann (2):
      x86: kvm: avoid -Wsometimes-uninitized warning
      x86: kvm: avoid constant-conversion warning

Christian Borntraeger (1):
      KVM: selftests: enable pgste option for the linker on s390

Eric Hankland (1):
      KVM: x86: Add fixed counters to PMU filter

Jing Liu (1):
      KVM: x86: expose AVX512_BF16 feature to guest

Like Xu (2):
      KVM: x86/vPMU: reset pmc->counter to 0 for pmu fixed_counters
      KVM: x86/vPMU: refine kvm_pmu err msg when event creation failed

Liran Alon (2):
      KVM: nVMX: Ignore segment base for VMX memory operand when segment not FS or GS
      KVM: SVM: Fix detection of AMD Errata 1096

Paolo Bonzini (3):
      Merge tag 'kvm-s390-next-5.3-1' of git://git.kernel.org/.../kvms390/linux into HEAD
      KVM: VMX: dump VMCS on failed entry
      KVM: nVMX: do not use dangling shadow VMCS after guest reset

Thomas Huth (7):
      KVM: selftests: Guard struct kvm_vcpu_events with __KVM_HAVE_VCPU_EVENTS
      KVM: selftests: Introduce a VM_MODE_DEFAULT macro for the default bits
      KVM: selftests: Align memory region addresses to 1M on s390x
      KVM: selftests: Add processor code for s390x
      KVM: selftests: Add the sync_regs test for s390x
      KVM: selftests: Move kvm_create_max_vcpus test to generic code
      KVM: selftests: Remove superfluous define from vmx.c

Wanpeng Li (4):
      KVM: LAPIC: Make lapic timer unpinned
      KVM: LAPIC: Inject timer interrupt via posted interrupt
      KVM: Boost vCPUs that are delivering interrupts
      KVM: s390: Use kvm_vcpu_wake_up in kvm_s390_vcpu_wakeup

Yi Wang (3):
      kvm: vmx: fix coccinelle warnings
      kvm: x86: some tsc debug cleanup
      kvm: x86: ioapic and apic debug macros cleanup

 Documentation/virtual/kvm/api.txt                  |  15 +-
 MAINTAINERS                                        |   2 +
 arch/s390/kvm/interrupt.c                          |  23 +-
 arch/x86/include/uapi/asm/kvm.h                    |   9 +-
 arch/x86/kvm/cpuid.c                               |  12 +-
 arch/x86/kvm/hyperv.c                              |  20 +-
 arch/x86/kvm/ioapic.c                              |  15 --
 arch/x86/kvm/lapic.c                               | 202 ++++++---------
 arch/x86/kvm/lapic.h                               |   1 +
 arch/x86/kvm/mmu.c                                 |   6 +-
 arch/x86/kvm/pmu.c                                 |  27 +-
 arch/x86/kvm/svm.c                                 |  42 +++-
 arch/x86/kvm/vmx/nested.c                          |  13 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |  11 +-
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/kvm/x86.c                                 |  20 +-
 arch/x86/kvm/x86.h                                 |   2 +
 include/linux/kvm_host.h                           |   1 +
 include/linux/sched/isolation.h                    |   6 +
 kernel/sched/isolation.c                           |   6 +
 tools/testing/selftests/kvm/Makefile               |  14 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   8 +
 .../selftests/kvm/include/s390x/processor.h        |  22 ++
 .../kvm/{x86_64 => }/kvm_create_max_vcpus.c        |   2 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  23 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  | 278 +++++++++++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |   2 -
 tools/testing/selftests/kvm/s390x/sync_regs_test.c | 151 +++++++++++
 virt/kvm/kvm_main.c                                |  12 +-
 31 files changed, 723 insertions(+), 232 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/processor.h
 rename tools/testing/selftests/kvm/{x86_64 => }/kvm_create_max_vcpus.c (95%)
 create mode 100644 tools/testing/selftests/kvm/lib/s390x/processor.c
 create mode 100644 tools/testing/selftests/kvm/s390x/sync_regs_test.c
