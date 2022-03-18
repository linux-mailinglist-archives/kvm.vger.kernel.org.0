Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632BC4DDBC3
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 15:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237329AbiCROiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 10:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236567AbiCROiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 10:38:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0B62E51A2
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 07:36:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 530E261AC2
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 14:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EEE7C340E8;
        Fri, 18 Mar 2022 14:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647614209;
        bh=0h3evQx6Yv2gaoIRUruq18FX6Pu8A8sZlELDeSriisk=;
        h=From:To:Cc:Subject:Date:From;
        b=L7GxGpTLGkpBvkhgfWt+i9nk929o/zoP8Q30xjb2m0d6cyc/TTAr9WEhMBY4RQUSP
         wNJqxz2yFj4Pn9vL04mOmV3DL3NOLpJaEt+jRRMkuIfDzW4xDVJknIjB1wduDa0yHL
         cyG5cQGbP4Ueza4JJoEh6NTo9GoghwJUcPzlvSxOT1/+i/dqZMnSNmT9uo8zpSI/Ps
         DuuNDTGvQhnZdP4Lh36CsxEiqWlgXtOx0Yl0I26YE9q6SSgst7oLKy+shlLzWQ0JYf
         3XmqJt4P9u6YUiR32oQqu+kC1WXaQQUAeFBx8O0pGVrqwzNZahdb2M9zZfk+eLMrOB
         TmevIV1pJYFCg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nVDih-00FSvn-31; Fri, 18 Mar 2022 14:36:47 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Walbran <qwandor@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Keir Fraser <keirf@google.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 updates for 5.18
Date:   Fri, 18 Mar 2022 14:36:29 +0000
Message-Id: <20220318143629.863625-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, qwandor@google.com, catalin.marinas@arm.com, deng.changcheng@zte.com.cn, tabba@google.com, james.morse@arm.com, jingzhangos@google.com, Julia.Lawall@inria.fr, keirf@google.com, broonie@kernel.org, mark.rutland@arm.com, oupton@google.com, reijiw@google.com, ricarkol@google.com, shameerali.kolothum.thodi@huawei.com, suzuki.poulose@arm.com, will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the bulk of KVM/arm64 updates for 5.18. For this time, a bunch
of work has gone into the MMU side of things with a new VMID allocator
and better scalability of the MM locking when tracking dirty pages,
better debug emulation, new PSCI version, more selftests, and the
usual bunch of cleanups all over the map.

Please pull,

	M.

The following changes since commit dfd42facf1e4ada021b939b4e19c935dcdd55566:

  Linux 5.17-rc3 (2022-02-06 12:20:50 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.18

for you to fetch changes up to 21ea457842759a236eefed2cfaa8cc7e5dc967a0:

  KVM: arm64: fix typos in comments (2022-03-18 14:04:15 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 5.18

- Proper emulation of the OSLock feature of the debug architecture

- Scalibility improvements for the MMU lock when dirty logging is on

- New VMID allocator, which will eventually help with SVA in VMs

- Better support for PMUs in heterogenous systems

- PSCI 1.1 support, enabling support for SYSTEM_RESET2

- Implement CONFIG_DEBUG_LIST at EL2

- Make CONFIG_ARM64_ERRATUM_2077057 default y

- Reduce the overhead of VM exit when no interrupt is pending

- Remove traces of 32bit ARM host support from the documentation

- Updated vgic selftests

- Various cleanups, doc updates and spelling fixes

----------------------------------------------------------------
Alexandru Elisei (4):
      perf: Fix wrong name in comment for struct perf_cpu_context
      KVM: arm64: Keep a list of probed PMUs
      KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
      KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical CPU

Changcheng Deng (1):
      KVM: arm64: Remove unneeded semicolons

Jing Zhang (3):
      KVM: arm64: Use read/write spin lock for MMU protection
      KVM: arm64: Add fast path to handle permission relaxation during dirty logging
      KVM: selftests: Add vgic initialization for dirty log perf test for ARM

Julia Lawall (1):
      KVM: arm64: fix typos in comments

Julien Grall (1):
      KVM: arm64: Align the VMID allocation with the arm64 ASID

Keir Fraser (1):
      KVM: arm64: pkvm: Implement CONFIG_DEBUG_LIST at EL2

Marc Zyngier (14):
      Merge branch kvm-arm64/oslock into kvmarm-master/next
      Merge branch kvm-arm64/mmu-rwlock into kvmarm-master/next
      Merge branch kvm-arm64/fpsimd-doc into kvmarm-master/next
      Merge branch kvm-arm64/vmid-allocator into kvmarm-master/next
      Merge branch kvm-arm64/selftest/vgic-5.18 into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.18 into kvmarm-master/next
      KVM: arm64: Do not change the PMU event filter after a VCPU has run
      KVM: arm64: Keep a per-VM pointer to the default PMU
      Merge branch kvm-arm64/pmu-bl into kvmarm-master/next
      Merge branch kvm-arm64/psci-1.1 into kvmarm-master/next
      KVM: arm64: Only open the interrupt window on exit due to an interrupt
      Merge branch kvm-arm64/misc-5.18 into kvmarm-master/next
      Merge branch kvm-arm64/psci-1.1 into kvmarm-master/next
      KVM: arm64: Generalise VM features into a set of flags

Mark Brown (4):
      KVM: arm64: Add comments for context flush and sync callbacks
      KVM: arm64: Add some more comments in kvm_hyp_handle_fpsimd()
      arm64/fpsimd: Clarify the purpose of using last in fpsimd_save()
      KVM: arm64: Enable Cortex-A510 erratum 2077057 by default

Oliver Upton (8):
      KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
      KVM: arm64: Stash OSLSR_EL1 in the cpu context
      KVM: arm64: Allow guest to set the OSLK bit
      KVM: arm64: Emulate the OS Lock
      selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
      selftests: KVM: Test OS lock behavior
      KVM: arm64: Drop unused param from kvm_psci_version()
      Documentation: KVM: Update documentation to indicate KVM is arm64-only

Ricardo Koller (5):
      kvm: selftests: aarch64: fix assert in gicv3_access_reg
      kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
      kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
      kvm: selftests: aarch64: fix some vgic related comments
      kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()

Shameer Kolothum (3):
      KVM: arm64: Introduce a new VMID allocator for KVM
      KVM: arm64: Make VMID bits accessible outside of allocator
      KVM: arm64: Make active_vmids invalid on vCPU schedule out

Will Deacon (4):
      KVM: arm64: Bump guest PSCI version to 1.1
      KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
      KVM: arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags field
      KVM: arm64: Really propagate PSCI SYSTEM_RESET2 arguments to userspace

 Documentation/virt/kvm/api.rst                     |  92 +++++-----
 Documentation/virt/kvm/devices/vcpu.rst            |  36 +++-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/kvm_host.h                  |  45 ++++-
 arch/arm64/include/asm/kvm_mmu.h                   |   4 +-
 arch/arm64/include/asm/sysreg.h                    |   8 +
 arch/arm64/include/uapi/asm/kvm.h                  |  11 ++
 arch/arm64/kernel/fpsimd.c                         |   8 +-
 arch/arm64/kernel/image-vars.h                     |   3 +
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arm.c                               | 142 +++++----------
 arch/arm64/kvm/debug.c                             |  26 ++-
 arch/arm64/kvm/fpsimd.c                            |  14 +-
 arch/arm64/kvm/guest.c                             |   2 +-
 arch/arm64/kvm/handle_exit.c                       |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   4 +
 arch/arm64/kvm/hyp/nvhe/Makefile                   |   3 +-
 arch/arm64/kvm/hyp/nvhe/list_debug.c               |  54 ++++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   3 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |   4 +-
 arch/arm64/kvm/hyp/nvhe/stub.c                     |  22 ---
 arch/arm64/kvm/mmio.c                              |   3 +-
 arch/arm64/kvm/mmu.c                               |  52 +++---
 arch/arm64/kvm/pmu-emul.c                          | 141 +++++++++++----
 arch/arm64/kvm/psci.c                              |  66 +++++--
 arch/arm64/kvm/sys_regs.c                          |  74 ++++++--
 arch/arm64/kvm/vgic/vgic.c                         |   2 +-
 arch/arm64/kvm/vmid.c                              | 196 +++++++++++++++++++++
 include/kvm/arm_pmu.h                              |   5 +
 include/kvm/arm_psci.h                             |   9 +-
 include/linux/perf_event.h                         |   2 +-
 include/uapi/linux/psci.h                          |   4 +
 tools/arch/arm64/include/uapi/asm/kvm.h            |   1 +
 .../selftests/kvm/aarch64/debug-exceptions.c       |  58 +++++-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |   1 +
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |  45 +++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  10 ++
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |  12 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |   9 +-
 39 files changed, 865 insertions(+), 311 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/nvhe/list_debug.c
 delete mode 100644 arch/arm64/kvm/hyp/nvhe/stub.c
 create mode 100644 arch/arm64/kvm/vmid.c
