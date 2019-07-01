Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 803052A939
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 11:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfEZJ4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 05:56:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33467 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbfEZJ4A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 05:56:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so4230450wmh.0;
        Sun, 26 May 2019 02:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=V4y1eNNVoOK6/0U7eERLp4HxeWi2eXZbpKBuvUVBXCQ=;
        b=FHhdibBGhypGnt0u7hX3MR+6+Q5Da11bxD074Gv9vIVSuWSoaaxPW4M3dy70pWGUIT
         aLUYVSSnwu/K1rdPIaPBTd7s5nDkYn8LR2t6yWw2MfLOwNWZfI1VQvf6qkmpznyW6VDK
         GeSQIcbWjpr1gGRISEG5PNVUlb7k0dh1puHVVVXHTX6I/+Dqf9M19m3CiQxnXDhfqBIw
         8rm9MFzmuwyj2Vejk0ErEBVXkEETtklPOulWMhazpXjdxgIrovR/nDP+CDvi7UNLZja9
         5keBq8/wiLJAkpn2v5a7rvhGLkF6GUffQZn3JQIESyLgqFDWlUzLfPmCVV68OoZns0A7
         Y0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=V4y1eNNVoOK6/0U7eERLp4HxeWi2eXZbpKBuvUVBXCQ=;
        b=gcoAdu0hMVd58TXYLheD/vlfVCUnqPQpf5zIFaJMzWLZbwOu1jhUJG2vyAYFu8atZq
         hVRRuDh7J3Gaa5+NJOAf6bLJObFZE7BCzLobBjrbGEkwNJRNUnaf7qF63J1yLKCVXXAd
         X2rLy4wCstorv4aRrZ3LlgIrvleLyJCoRzZLNVLEurG9k+DBiqxhdCWuwwHYBT0q1C7t
         shu76LU6J1KouQCZuI4Js+OxJXGPeFZd7Xg2AE8+Rk3fXP/oXoTV9JHsiI+c+N5vepxj
         MlCnR61HMX5FzBnkFqr3Cj8Pd5PXnaeuKOFE38jwBS027BurS/QM6GJnViUGZw2C/uw5
         eLBw==
X-Gm-Message-State: APjAAAUNDEiLxp3K7Vf5jUc+M5W5LzmtEe2f034ITFioeCrW2aMLzCUO
        zMUEKRYi3lnyuH5Zcwk3bQE=
X-Google-Smtp-Source: APXvYqznLZicOimpmrQNby3csyxP01hRvf/AQcz9zFmpsgKYT+JsrYcxO0Z2bcJ2/HwUUzOzfesBuQ==
X-Received: by 2002:a1c:9e8e:: with SMTP id h136mr21653348wme.29.1558864557618;
        Sun, 26 May 2019 02:55:57 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v124sm13557120wme.42.2019.05.26.02.55.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 02:55:56 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.2-rc2
Date:   Sun, 26 May 2019 11:55:55 +0200
Message-Id: <1558864555-53503-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit a188339ca5a396acc588e5851ed7e19f66b0ebd9:

  Linux 5.2-rc1 (2019-05-19 15:47:09 -0700)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 66f61c92889ff3ca365161fb29dd36d6354682ba:

  KVM: x86: fix return value for reserved EFER (2019-05-24 21:55:02 +0200)

----------------------------------------------------------------
The usual smattering of fixes and tunings that came in too late for the
merge window, but should not wait four months before they appear in
a release.  I also travelled a bit more than usual in the first part
of May, which didn't help with picking up patches and reports promptly.

----------------------------------------------------------------
Andrew Jones (3):
      kvm: selftests: aarch64: dirty_log_test: fix unaligned memslot size
      kvm: selftests: aarch64: fix default vm mode
      kvm: selftests: aarch64: compile with warnings on

Borislav Petkov (1):
      x86/kvm/pmu: Set AMD's virt PMU version to 1

Christian Borntraeger (2):
      KVM: s390: change default halt poll time to 50us
      KVM: s390: fix memory slot handling for KVM_SET_USER_MEMORY_REGION

Christoffer Dall (1):
      MAINTAINERS: KVM: arm/arm64: Remove myself as maintainer

Dan Carpenter (1):
      KVM: selftests: Fix a condition in test_hv_cpuid()

James Morse (2):
      KVM: arm64: Move pmu hyp code under hyp's Makefile to avoid instrumentation
      KVM: arm/arm64: Move cc/it checks under hyp's Makefile to avoid instrumentation

Jim Mattson (2):
      kvm: x86: Include multiple indices with CPUID leaf 0x8000001d
      kvm: x86: Include CPUID leaf 0x8000001e in kvm's supported CPUID

Paolo Bonzini (10):
      Merge tag 'kvm-s390-master-5.2-1' of git://git.kernel.org/.../kvms390/linux into HEAD
      Merge tag 'kvmarm-fixes-for-5.2' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: nVMX: really fix the size checks on KVM_SET_NESTED_STATE
      kvm: selftests: avoid type punning
      kvm: fix compilation on s390
      KVM: selftests: do not blindly clobber registers in guest asm
      KVM: x86: do not spam dmesg with VMCS/VMCB dumps
      KVM: x86/pmu: mask the result of rdpmc according to the width of the counters
      KVM: x86/pmu: do not mask the value that is written to fixed PMUs
      KVM: x86: fix return value for reserved EFER

Peter Xu (1):
      kvm: Check irqchip mode before assign irqfd

Sean Christopherson (1):
      KVM: nVMX: Clear nested_run_pending if setting nested state fails

Stefan Raspl (1):
      tools/kvm_stat: fix fields filter for child events

Suthikulpanit, Suravee (1):
      kvm: svm/avic: fix off-by-one in checking host APIC ID

Thomas Huth (3):
      KVM: selftests: Compile code with warnings enabled
      KVM: selftests: Remove duplicated TEST_ASSERT in hyperv_cpuid.c
      KVM: selftests: Wrap vcpu_nested_state_get/set functions with x86 guard

Wanpeng Li (4):
      KVM: Fix spinlock taken warning during host resume
      KVM: nVMX: Fix using __this_cpu_read() in preemptible context
      KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
      KVM: LAPIC: Expose per-vCPU timer_advance_ns to userspace

Wei Yongjun (1):
      KVM: s390: fix typo in parameter description

Yi Wang (1):
      kvm: vmx: Fix -Wmissing-prototypes warnings

 MAINTAINERS                                        |   2 -
 arch/arm/kvm/hyp/Makefile                          |   1 +
 arch/arm64/include/asm/kvm_host.h                  |   3 -
 arch/arm64/kvm/hyp/Makefile                        |   1 +
 arch/arm64/kvm/hyp/switch.c                        |  39 ++++++
 arch/arm64/kvm/pmu.c                               |  38 ------
 arch/s390/include/asm/kvm_host.h                   |   2 +-
 arch/s390/kvm/kvm-s390.c                           |  37 +++---
 arch/x86/kvm/cpuid.c                               |   8 +-
 arch/x86/kvm/debugfs.c                             |  18 +++
 arch/x86/kvm/irq.c                                 |   7 ++
 arch/x86/kvm/irq.h                                 |   1 +
 arch/x86/kvm/pmu.c                                 |  10 +-
 arch/x86/kvm/pmu.h                                 |   3 +-
 arch/x86/kvm/pmu_amd.c                             |   4 +-
 arch/x86/kvm/svm.c                                 |  15 ++-
 arch/x86/kvm/vmx/nested.c                          |  35 +++---
 arch/x86/kvm/vmx/pmu_intel.c                       |  26 ++--
 arch/x86/kvm/vmx/vmx.c                             |  26 ++--
 arch/x86/kvm/vmx/vmx.h                             |   1 +
 arch/x86/kvm/x86.c                                 |   4 +-
 tools/kvm/kvm_stat/kvm_stat                        |  16 ++-
 tools/kvm/kvm_stat/kvm_stat.txt                    |   2 +
 tools/testing/selftests/kvm/Makefile               |   4 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |   8 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   2 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  11 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   5 +-
 tools/testing/selftests/kvm/lib/ucall.c            |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   4 +-
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |   1 +
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   7 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |   9 +-
 .../selftests/kvm/x86_64/platform_info_test.c      |   1 -
 tools/testing/selftests/kvm/x86_64/smm_test.c      |   3 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |   7 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |  54 ++++----
 .../kvm/x86_64/vmx_close_while_nested_test.c       |   5 +-
 .../kvm/x86_64/vmx_set_nested_state_test.c         |   2 +-
 .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |   5 +-
 virt/kvm/arm/aarch32.c                             | 121 ------------------
 virt/kvm/arm/hyp/aarch32.c                         | 136 +++++++++++++++++++++
 virt/kvm/eventfd.c                                 |   9 ++
 virt/kvm/kvm_main.c                                |   7 +-
 44 files changed, 399 insertions(+), 303 deletions(-)
 create mode 100644 virt/kvm/arm/hyp/aarch32.c
