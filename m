Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC0DCB9C7
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 14:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbfJDMEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 08:04:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37449 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfJDMEA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 08:04:00 -0400
Received: by mail-wm1-f67.google.com with SMTP id f22so5578586wmc.2;
        Fri, 04 Oct 2019 05:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=KVrTSfhJQkcjGUoc6/wChtJatdSgDTO1rfWfls9h3Lo=;
        b=gCuTIPxBpH1goz7Jtyo4AdIW3vOQiGnlAioh/38P0AiDodj95Ep7QBms8Ew3szTn6H
         z3ZyAMgJGNRgKN/pBecNOh/f/7/QpdK1uwz8VnFWQtbhsspZLn2dyxz6ELYD1MXTgmhn
         6KwcNNuPg/qV1HdMzNChLLuxaN0MgX4w8DpqCmAz9OBcdkKx029FT70ShiSul5a2CUmR
         YIJZ4Eq2+U6qgyu6r4JXErswh6ZiLmOcU8cW+LlpVSGTXPvyrrUlbFv59X9e9w6rbnZb
         BaKafSsJzR2R1RRATANDjKaIn0umprbD44+wpvQzyv86ERHeQwbfMRIdLPmD/E/WtAIJ
         Zu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=KVrTSfhJQkcjGUoc6/wChtJatdSgDTO1rfWfls9h3Lo=;
        b=sMKZjd70Jl9W1nSjXj6m6r1BTGUoVXWhMjKFsXhS0Aax7D0wDideJiPsxmml37oFoj
         l9yAhFNO92EINE98hG0vhdUWGYlzejpuBRQ/eKpF+HjZ4LhXJQ/zIle121H3c9Uz+KPc
         KWQUH9EBjA1eANjUSPyOlruWSmQU9/SsGPNmB2cA45CSSYaYxibCVEpZLNNyQIMr+sVm
         5+4aBWZHi28Bkv2Cxs2TmC5bZ9yIPUN8436BIHs7hr1B6BH3E6RmMfo8B1YT6Lfq/RlY
         Te14ivUihFCNyje8kUsllPSlNTakakM+G55uLZtgU44rSekEbo+JgqNZ6kyisKu/9gqD
         QfzQ==
X-Gm-Message-State: APjAAAXFw2I1MU/XqFJinvyJJoov+HrfZ9FlYapLrtzhQoR1Caicqnp2
        OdaV9vh3xdQF8RkjJunmqmQ=
X-Google-Smtp-Source: APXvYqy8k3bgKZ6SInwf+MtKGz30qnvpeRSYEDcISJ/9qHK4gqkYxjgovCiY5DiyZ7FrOUPil/on6Q==
X-Received: by 2002:a1c:66c2:: with SMTP id a185mr10587954wmc.2.1570190636233;
        Fri, 04 Oct 2019 05:03:56 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t83sm9325709wmt.18.2019.10.04.05.03.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 05:03:55 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM fixes for Linux 5.4-rc2
Date:   Fri,  4 Oct 2019 14:03:52 +0200
Message-Id: <1570190632-22964-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit fd3edd4a9066f28de99a16685a586d68a9f551f8:

  KVM: nVMX: cleanup and fix host 64-bit mode checks (2019-09-25 19:22:33 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to cf05a67b68b8d9d6469bedb63ee461f8c7de62e6:

  KVM: x86: omit "impossible" pmu MSRs from MSR list (2019-10-04 14:01:28 +0200)

----------------------------------------------------------------
ARM and x86 bugfixes of all kinds.  The most visible one is that migrating
a nested hypervisor has always been busted on Broadwell and newer processors,
and that has finally been fixed.

----------------------------------------------------------------
Jim Mattson (5):
      kvm: x86: Fix a spurious -E2BIG in __do_cpuid_func
      kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
      kvm: x86: Use AMD CPUID semantics for AMD vCPUs
      kvm: x86: Enumerate support for CLZERO instruction
      kvm: vmx: Limit guest PMCs to those supported on the host

Marc Zyngier (3):
      arm64: KVM: Drop hyp_alternate_select for checking for ARM64_WORKAROUND_834220
      arm64: KVM: Replace hyp_alternate_select with has_vhe()
      arm64: KVM: Kill hyp_alternate_select()

Paolo Bonzini (7):
      KVM: x86: assign two bits to track SPTE kinds
      KVM: x86: fix nested guest live migration with PML
      selftests: kvm: add test for dirty logging inside nested guests
      kvm: x86, powerpc: do not allow clearing largepages debugfs entry
      KVM: x86: omit absent pmu MSRs from MSR list
      Merge tag 'kvmarm-fixes-5.4-1' of git://git.kernel.org/.../kvmarm/kvmarm into HEAD
      KVM: x86: omit "impossible" pmu MSRs from MSR list

Sean Christopherson (1):
      KVM: nVMX: Fix consistency check on injected exception error code

Sebastian Andrzej Siewior (1):
      KVM: x86: Expose XSAVEERPTR to the guest

Shuah Khan (1):
      selftests: kvm: Fix libkvm build error

Vitaly Kuznetsov (1):
      KVM: selftests: x86: clarify what is reported on KVM_GET_MSRS failure

Waiman Long (1):
      KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if !X86_BUG_L1TF

Wanpeng Li (2):
      KVM: LAPIC: Loosen filter for adaptive tuning of lapic_timer_advance_ns
      KVM: X86: Fix userspace set invalid CR4

Zenghui Yu (1):
      KVM: arm/arm64: vgic: Use the appropriate TRACE_INCLUDE_PATH

 arch/arm64/include/asm/kvm_hyp.h                   |  24 ---
 arch/arm64/kvm/hyp/switch.c                        |  17 +-
 arch/arm64/kvm/hyp/tlb.c                           |  36 ++--
 arch/powerpc/kvm/book3s.c                          |   8 +-
 arch/x86/include/asm/kvm_host.h                    |   7 -
 arch/x86/kvm/cpuid.c                               | 102 ++++++-----
 arch/x86/kvm/lapic.c                               |  13 +-
 arch/x86/kvm/mmu.c                                 |  65 +++++--
 arch/x86/kvm/vmx/nested.c                          |   2 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   7 +-
 arch/x86/kvm/vmx/vmx.c                             |  15 +-
 arch/x86/kvm/x86.c                                 |  72 ++++----
 include/linux/kvm_host.h                           |   2 +
 tools/testing/selftests/kvm/Makefile               |   3 +-
 .../selftests/kvm/include/x86_64/processor.h       |   3 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |  14 ++
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 .../testing/selftests/kvm/lib/kvm_util_internal.h  |   3 +
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   2 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       | 201 ++++++++++++++++++++-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      | 156 ++++++++++++++++
 virt/kvm/arm/vgic/trace.h                          |   2 +-
 virt/kvm/kvm_main.c                                |  10 +-
 23 files changed, 584 insertions(+), 182 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_dirty_log_test.c
