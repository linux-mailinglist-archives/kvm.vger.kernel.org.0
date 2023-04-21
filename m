Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059136EA875
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 12:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDUKkZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 06:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbjDUKkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 06:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC769EF4
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 03:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33B9660CEB
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663F2C433EF;
        Fri, 21 Apr 2023 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682073616;
        bh=f54QJY5K8mTuwzMvRZL1+NpMfvBNMm/MjfsZ4+NoQoE=;
        h=From:To:Cc:Subject:Date:From;
        b=VP4qOS+ovkzE2fmFjLtlvdi6QqRnjDZU86UAt4XRif0RIZLBkISSmQ3hUX+5qhDFp
         q0sG0eAwMs6da8otU1sI64Zfqq2sCWy4uJg71V0iOk0BHaNl/mVqKWzcq/9BVTh9AY
         C5auvXr4bokF/MOM0LRWSZ+ug/zrShz0zUqaZvXu/hk3VPSQ6ns4wx9u2UKn5khht+
         XtagEKqs7WhytoqUHy/g1e6Oli81xHy0rDY68BuDsyfU2hz0DVEWdiq1mjyr2udn9t
         MWmccEtnz80uKXZqTdYWjkYcxztPQs5F1nULvelgBRHMtMq+gDb7Ex+Cka99pWO+ni
         o8jKCvQsVyy3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ppoBa-00A96s-2s;
        Fri, 21 Apr 2023 11:40:14 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoffer Dall <christoffer.dall@arm.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        Colton Lewis <coltonlewis@google.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for v6.4
Date:   Fri, 21 Apr 2023 11:40:05 +0100
Message-Id: <20230421104005.3017731-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, christoffer.dall@arm.com, colin.i.king@gmail.com, coltonlewis@google.com, jeremy.linton@arm.com, broonie@kernel.org, oliver.upton@linux.dev, reijiw@google.com, ryan.roberts@arm.com, seanjc@google.com, suzuki.poulose@arm.com, james.morse@arm.com, yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the initial set of changes for KVM/arm64. A bunch of
infrastructure changes this time around, with two new user
visible changes (hypercall forwarding to userspace, global counter
offset) and a large set of locking inversion fixes.

The remaining of the patches contain the NV timer emulation code, and
a small set of less important fixes/improvements.

Please pull,

       M.

The following changes since commit 197b6b60ae7bc51dd0814953c562833143b292aa:

  Linux 6.3-rc4 (2023-03-26 14:40:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.4

for you to fetch changes up to 36fe1b29b3cae48f781011abd5a0b9e938f5b35f:

  Merge branch kvm-arm64/spec-ptw into kvmarm-master/next (2023-04-21 09:44:58 +0100)

----------------------------------------------------------------
KVM/arm64 updates for 6.4

- Numerous fixes for the pathological lock inversion issue that
  plagued KVM/arm64 since... forever.

- New framework allowing SMCCC-compliant hypercalls to be forwarded
  to userspace, hopefully paving the way for some more features
  being moved to VMMs rather than be implemented in the kernel.

- Large rework of the timer code to allow a VM-wide offset to be
  applied to both virtual and physical counters as well as a
  per-timer, per-vcpu offset that complements the global one.
  This last part allows the NV timer code to be implemented on
  top.

- A small set of fixes to make sure that we don't change anything
  affecting the EL1&0 translation regime just after having having
  taken an exception to EL2 until we have executed a DSB. This
  ensures that speculative walks started in EL1&0 have completed.

- The usual selftest fixes and improvements.

----------------------------------------------------------------
Colin Ian King (1):
      KVM: selftests: Fix spelling mistake "KVM_HYPERCAL_EXIT_SMC" -> "KVM_HYPERCALL_EXIT_SMC"

Marc Zyngier (33):
      KVM: arm64: timers: Use a per-vcpu, per-timer accumulator for fractional ns
      arm64: Add CNTPOFF_EL2 register definition
      arm64: Add HAS_ECV_CNTPOFF capability
      KVM: arm64: timers: Use CNTPOFF_EL2 to offset the physical timer
      KVM: arm64: timers: Allow physical offset without CNTPOFF_EL2
      KVM: arm64: Expose {un,}lock_all_vcpus() to the rest of KVM
      KVM: arm64: timers: Allow userspace to set the global counter offset
      KVM: arm64: timers: Allow save/restoring of the physical timer
      KVM: arm64: timers: Rationalise per-vcpu timer init
      KVM: arm64: timers: Abstract per-timer IRQ access
      KVM: arm64: timers: Move the timer IRQs into arch_timer_vm_data
      KVM: arm64: Elide kern_hyp_va() in VHE-specific parts of the hypervisor
      KVM: arm64: timers: Fast-track CNTPCT_EL0 trap handling
      KVM: arm64: timers: Abstract the number of valid timers per vcpu
      KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
      KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
      KVM: arm64: nv: timers: Support hyp timer emulation
      KVM: arm64: selftests: Add physical timer registers to the sysreg list
      KVM: arm64: selftests: Deal with spurious timer interrupts
      KVM: arm64: selftests: Augment existing timer test to handle variable offset
      KVM: arm64: Expose SMC/HVC width to userspace
      KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
      KVM: arm64: Handle 32bit CNTPCTSS traps
      KVM: arm64: nvhe: Synchronise with page table walker on TLBI
      KVM: arm64: pkvm: Document the side effects of kvm_flush_dcache_to_poc()
      KVM: arm64: vhe: Synchronise with page table walker on MMU update
      KVM: arm64: vhe: Drop extra isb() on guest exit
      Merge branch kvm-arm64/lock-inversion into kvmarm-master/next
      Merge branch kvm-arm64/timer-vm-offsets into kvmarm-master/next
      Merge branch kvm-arm64/selftest/lpa into kvmarm-master/next
      Merge branch kvm-arm64/selftest/misc-6.4 into kvmarm-master/next
      Merge branch kvm-arm64/smccc-filtering into kvmarm-master/next
      Merge branch kvm-arm64/spec-ptw into kvmarm-master/next

Mark Brown (1):
      KVM: selftests: Comment newly defined aarch64 ID registers

Oliver Upton (20):
      KVM: arm64: Avoid vcpu->mutex v. kvm->lock inversion in CPU_ON
      KVM: arm64: Avoid lock inversion when setting the VM register width
      KVM: arm64: Use config_lock to protect data ordered against KVM_RUN
      KVM: arm64: Use config_lock to protect vgic state
      KVM: x86: Redefine 'longmode' as a flag for KVM_EXIT_HYPERCALL
      KVM: arm64: Add a helper to check if a VM has ran once
      KVM: arm64: Add vm fd device attribute accessors
      KVM: arm64: Rename SMC/HVC call handler to reflect reality
      KVM: arm64: Start handling SMCs from EL1
      KVM: arm64: Refactor hvc filtering to support different actions
      KVM: arm64: Use a maple tree to represent the SMCCC filter
      KVM: arm64: Add support for KVM_EXIT_HYPERCALL
      KVM: arm64: Introduce support for userspace SMCCC filtering
      KVM: arm64: Return NOT_SUPPORTED to guest for unknown PSCI version
      KVM: arm64: Let errors from SMCCC emulation to reach userspace
      KVM: selftests: Add a helper for SMCCC calls with SMC instruction
      KVM: selftests: Add test for SMCCC filter
      KVM: arm64: Prevent userspace from handling SMC64 arch range
      KVM: arm64: Test that SMC64 arch calls are reserved
      KVM: arm64: vgic: Don't acquire its_lock before config_lock

Reiji Watanabe (2):
      KVM: arm64: Acquire mp_state_lock in kvm_arch_vcpu_ioctl_vcpu_init()
      KVM: arm64: Have kvm_psci_vcpu_on() use WRITE_ONCE() to update mp_state

Ryan Roberts (3):
      KVM: selftests: Fixup config fragment for access_tracking_perf_test
      KVM: selftests: arm64: Fix pte encode/decode for PA bits > 48
      KVM: selftests: arm64: Fix ttbr0_el1 encoding for PA bits > 48

 Documentation/virt/kvm/api.rst                     |  71 ++-
 Documentation/virt/kvm/devices/vm.rst              |  79 +++
 arch/arm64/include/asm/kvm_host.h                  |  25 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   4 +
 arch/arm64/include/asm/sysreg.h                    |   3 +
 arch/arm64/include/uapi/asm/kvm.h                  |  36 ++
 arch/arm64/kernel/cpufeature.c                     |  11 +
 arch/arm64/kvm/arch_timer.c                        | 550 ++++++++++++++++-----
 arch/arm64/kvm/arm.c                               | 147 +++++-
 arch/arm64/kvm/guest.c                             |  31 +-
 arch/arm64/kvm/handle_exit.c                       |  36 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  53 ++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   2 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   7 +
 arch/arm64/kvm/hyp/nvhe/switch.c                   |  18 +
 arch/arm64/kvm/hyp/nvhe/timer-sr.c                 |  18 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |  38 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   7 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  12 +
 arch/arm64/kvm/hypercalls.c                        | 189 ++++++-
 arch/arm64/kvm/pmu-emul.c                          |  25 +-
 arch/arm64/kvm/psci.c                              |  37 +-
 arch/arm64/kvm/reset.c                             |  15 +-
 arch/arm64/kvm/sys_regs.c                          |  10 +
 arch/arm64/kvm/trace_arm.h                         |   6 +-
 arch/arm64/kvm/vgic/vgic-debug.c                   |   8 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  36 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  33 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  85 ++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   4 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |  12 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |  11 +-
 arch/arm64/kvm/vgic/vgic.c                         |  27 +-
 arch/arm64/kvm/vgic/vgic.h                         |   3 -
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/sysreg                            |   4 +
 arch/x86/include/asm/kvm_host.h                    |   7 +
 arch/x86/include/uapi/asm/kvm.h                    |   3 +
 arch/x86/kvm/x86.c                                 |   6 +-
 include/clocksource/arm_arch_timer.h               |   1 +
 include/kvm/arm_arch_timer.h                       |  34 +-
 include/kvm/arm_hypercalls.h                       |   6 +-
 include/kvm/arm_vgic.h                             |   1 +
 include/uapi/linux/kvm.h                           |  12 +-
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |  56 ++-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  15 +-
 tools/testing/selftests/kvm/aarch64/smccc_filter.c | 268 ++++++++++
 tools/testing/selftests/kvm/config                 |   1 +
 .../selftests/kvm/include/aarch64/processor.h      |  13 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  91 ++--
 51 files changed, 1759 insertions(+), 410 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/smccc_filter.c
