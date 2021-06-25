Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ABE3B44B1
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 15:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhFYNqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 09:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhFYNqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 09:46:50 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0882617ED;
        Fri, 25 Jun 2021 13:44:29 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lwm8B-009pWm-KJ; Fri, 25 Jun 2021 14:44:27 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fuad Tabba <tabba@google.com>, Jinank Jain <jinankj@amazon.de>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 updates for 5.14
Date:   Fri, 25 Jun 2021 14:43:57 +0100
Message-Id: <20210625134357.12804-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, ardb@kernel.org, catalin.marinas@arm.com, tabba@google.com, jinankj@amazon.de, zhukeqian1@huawei.com, mark.rutland@arm.com, qperret@google.com, ricarkol@google.com, steven.price@arm.com, will@kernel.org, wangyanan55@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the 5.14 pull request for 5.14. This round, plenty of changes
in the mm department (MTE, CMOs, device mappings, host S2), but also
a lot of work in the selftest infrastructure. On top of that, a few
PMU fixes, and the ability to run guests on the M1...

Note that we carry a branch (arm64/for-next/caches) shared with the
arm64 tree in order to avoid ugly conflicts. You will still get a few
minor ones with the PPC tree, but the resolution is obvious.

Oh, and each merge commit has a full description of what they contain.
Hopefully we won't get yelled at this time.

Please pull,

	M.

The following changes since commit 8124c8a6b35386f73523d27eacb71b5364a68c4c:

  Linux 5.13-rc4 (2021-05-30 11:58:25 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.14

for you to fetch changes up to 188982cda00ebfe28b50c2905d9bbaa2e9a001b9:

  Merge branch kvm-arm64/mmu/mte into kvmarm-master/next (2021-06-25 14:25:56 +0100)

----------------------------------------------------------------
KVM/arm64 updates for v5.14.

- Add MTE support in guests, complete with tag save/restore interface
- Reduce the impact of CMOs by moving them in the page-table code
- Allow device block mappings at stage-2
- Reduce the footprint of the vmemmap in protected mode
- Support the vGIC on dumb systems such as the Apple M1
- Add selftest infrastructure to support multiple configuration
  and apply that to PMU/non-PMU setups
- Add selftests for the debug architecture
- The usual crop of PMU fixes

----------------------------------------------------------------
Alexandru Elisei (1):
      KVM: arm64: Don't zero the cycle count register when PMCR_EL0.P is set

Andrew Jones (5):
      KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
      KVM: arm64: selftests: get-reg-list: Prepare to run multiple configs at once
      KVM: arm64: selftests: get-reg-list: Provide config selection option
      KVM: arm64: selftests: get-reg-list: Remove get-reg-list-sve
      KVM: arm64: selftests: get-reg-list: Split base and pmu registers

Fuad Tabba (16):
      arm64: Apply errata to swsusp_arch_suspend_exit
      arm64: Do not enable uaccess for flush_icache_range
      arm64: Do not enable uaccess for invalidate_icache_range
      arm64: Downgrade flush_icache_range to invalidate
      arm64: assembler: remove user_alt
      arm64: Move documentation of dcache_by_line_op
      arm64: Fix comments to refer to correct function __flush_icache_range
      arm64: __inval_dcache_area to take end parameter instead of size
      arm64: dcache_by_line_op to take end parameter instead of size
      arm64: __flush_dcache_area to take end parameter instead of size
      arm64: __clean_dcache_area_poc to take end parameter instead of size
      arm64: __clean_dcache_area_pop to take end parameter instead of size
      arm64: __clean_dcache_area_pou to take end parameter instead of size
      arm64: sync_icache_aliases to take end parameter instead of size
      arm64: Fix cache maintenance function comments
      arm64: Rename arm64-internal cache maintenance functions

Keqian Zhu (2):
      KVM: arm64: Remove the creation time's mapping of MMIO regions
      KVM: arm64: Try stage2 block mapping for host device MMIO

Marc Zyngier (22):
      irqchip/gic: Split vGIC probing information from the GIC code
      KVM: arm64: Handle physical FIQ as an IRQ while running a guest
      KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt masking
      KVM: arm64: vgic: Let an interrupt controller advertise lack of HW deactivation
      KVM: arm64: vgic: move irq->get_input_level into an ops structure
      KVM: arm64: vgic: Implement SW-driven deactivation
      KVM: arm64: timer: Refactor IRQ configuration
      KVM: arm64: timer: Add support for SW-based deactivation
      irqchip/apple-aic: Advertise some level of vGICv3 compatibility
      Merge branch kvm-arm64/m1 into kvmarm-master/next
      Merge branch kvm-arm64/mmu/MMIO-block-mapping into kvmarm-master/next
      Merge branch kvm-arm64/mmu/reduce-vmemmap-overhead into kvmarm-master/next
      Merge branch kvm-arm64/selftest/debug into kvmarm-master/next
      Merge branch kvm-arm64/mmu/stage2-cmos into kvmarm-master/next
      KVM: arm64: Restore PMU configuration on first run
      Merge branch kvm-arm64/pmu-fixes into kvmarm-master/next
      Merge branch arm64/for-next/caches into kvmarm-master/next
      KVM: arm64: Update MAINTAINERS to include selftests
      Merge branch kvm-arm64/selftest/sysreg-list-fix into kvmarm-master/next
      Merge branch kvm-arm64/mmu/mte into kvmarm-master/next
      KVM: arm64: Set the MTE tag bit before releasing the page
      Merge branch kvm-arm64/mmu/mte into kvmarm-master/next

Mark Rutland (2):
      arm64: assembler: replace `kaddr` with `addr`
      arm64: assembler: add conditional cache fixups

Quentin Perret (7):
      KVM: arm64: Move hyp_pool locking out of refcount helpers
      KVM: arm64: Use refcount at hyp to check page availability
      KVM: arm64: Remove list_head from hyp_page
      KVM: arm64: Unify MMIO and mem host stage-2 pools
      KVM: arm64: Remove hyp_pool pointer from struct hyp_page
      KVM: arm64: Use less bits for hyp_page order
      KVM: arm64: Use less bits for hyp_page refcount

Ricardo Koller (6):
      KVM: selftests: Rename vm_handle_exception
      KVM: selftests: Complete x86_64/sync_regs_test ucall
      KVM: selftests: Introduce UCALL_UNHANDLED for unhandled vector reporting
      KVM: selftests: Move GUEST_ASSERT_EQ to utils header
      KVM: selftests: Add exception handling support for aarch64
      KVM: selftests: Add aarch64/debug-exceptions test

Steven Price (6):
      arm64: mte: Sync tags for pages where PTE is untagged
      KVM: arm64: Introduce MTE VM feature
      KVM: arm64: Save/restore MTE registers
      KVM: arm64: Expose KVM_ARM_CAP_MTE
      KVM: arm64: Add ioctl to fetch/store tags in a guest
      KVM: arm64: Document MTE capability and ioctl

Yanan Wang (4):
      KVM: arm64: Introduce two cache maintenance callbacks
      KVM: arm64: Introduce mm_ops member for structure stage2_attr_data
      KVM: arm64: Tweak parameters of guest cache maintenance functions
      KVM: arm64: Move guest CMOs to the fault handlers

 Documentation/virt/kvm/api.rst                     |  61 +++
 MAINTAINERS                                        |   2 +
 arch/arm64/include/asm/alternative-macros.h        |   5 -
 arch/arm64/include/asm/arch_gicv3.h                |   3 +-
 arch/arm64/include/asm/assembler.h                 |  80 ++--
 arch/arm64/include/asm/cacheflush.h                |  71 ++--
 arch/arm64/include/asm/efi.h                       |   2 +-
 arch/arm64/include/asm/kvm_arm.h                   |   3 +-
 arch/arm64/include/asm/kvm_emulate.h               |   3 +
 arch/arm64/include/asm/kvm_host.h                  |  14 +
 arch/arm64/include/asm/kvm_mmu.h                   |  17 +-
 arch/arm64/include/asm/kvm_mte.h                   |  66 ++++
 arch/arm64/include/asm/kvm_pgtable.h               |  42 +-
 arch/arm64/include/asm/mte-def.h                   |   1 +
 arch/arm64/include/asm/mte.h                       |   4 +-
 arch/arm64/include/asm/pgtable.h                   |  22 +-
 arch/arm64/include/asm/sysreg.h                    |   3 +-
 arch/arm64/include/uapi/asm/kvm.h                  |  11 +
 arch/arm64/kernel/alternative.c                    |   2 +-
 arch/arm64/kernel/asm-offsets.c                    |   2 +
 arch/arm64/kernel/efi-entry.S                      |   9 +-
 arch/arm64/kernel/head.S                           |  13 +-
 arch/arm64/kernel/hibernate-asm.S                  |   7 +-
 arch/arm64/kernel/hibernate.c                      |  20 +-
 arch/arm64/kernel/idreg-override.c                 |   3 +-
 arch/arm64/kernel/image-vars.h                     |   2 +-
 arch/arm64/kernel/insn.c                           |   2 +-
 arch/arm64/kernel/kaslr.c                          |  12 +-
 arch/arm64/kernel/machine_kexec.c                  |  30 +-
 arch/arm64/kernel/mte.c                            |  18 +-
 arch/arm64/kernel/probes/uprobes.c                 |   2 +-
 arch/arm64/kernel/smp.c                            |   8 +-
 arch/arm64/kernel/smp_spin_table.c                 |   7 +-
 arch/arm64/kernel/sys_compat.c                     |   2 +-
 arch/arm64/kvm/arch_timer.c                        | 162 ++++++--
 arch/arm64/kvm/arm.c                               |  22 +-
 arch/arm64/kvm/guest.c                             |  86 ++++
 arch/arm64/kvm/hyp/entry.S                         |   7 +
 arch/arm64/kvm/hyp/exception.c                     |   3 +-
 arch/arm64/kvm/hyp/hyp-entry.S                     |   6 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  21 +
 arch/arm64/kvm/hyp/include/nvhe/gfp.h              |  45 +--
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h           |   7 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |  13 +-
 arch/arm64/kvm/hyp/nvhe/cache.S                    |   4 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  60 +--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               | 112 ++++--
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  33 +-
 arch/arm64/kvm/hyp/nvhe/tlb.c                      |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  61 ++-
 arch/arm64/kvm/hyp/reserved_mem.c                  |   3 +-
 arch/arm64/kvm/mmu.c                               | 196 ++++++---
 arch/arm64/kvm/pmu-emul.c                          |   4 +
 arch/arm64/kvm/reset.c                             |   4 +
 arch/arm64/kvm/sys_regs.c                          |  32 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  36 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |  19 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |  19 +-
 arch/arm64/kvm/vgic/vgic.c                         |  14 +-
 arch/arm64/lib/uaccess_flushcache.c                |   4 +-
 arch/arm64/mm/cache.S                              | 158 ++++----
 arch/arm64/mm/flush.c                              |  29 +-
 drivers/irqchip/irq-apple-aic.c                    |   9 +
 drivers/irqchip/irq-gic-common.c                   |  13 -
 drivers/irqchip/irq-gic-common.h                   |   2 -
 drivers/irqchip/irq-gic-v3.c                       |   6 +-
 drivers/irqchip/irq-gic.c                          |   6 +-
 include/kvm/arm_vgic.h                             |  41 +-
 include/linux/irqchip/arm-gic-common.h             |  25 +-
 include/linux/irqchip/arm-vgic-info.h              |  45 +++
 include/uapi/linux/kvm.h                           |   2 +
 tools/testing/selftests/kvm/.gitignore             |   2 +-
 tools/testing/selftests/kvm/Makefile               |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       | 250 ++++++++++++
 .../selftests/kvm/aarch64/get-reg-list-sve.c       |   3 -
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 439 +++++++++++++++------
 .../selftests/kvm/include/aarch64/processor.h      |  83 +++-
 tools/testing/selftests/kvm/include/kvm_util.h     |  23 +-
 .../selftests/kvm/include/x86_64/processor.h       |   4 +-
 tools/testing/selftests/kvm/lib/aarch64/handlers.S | 126 ++++++
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  97 +++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  23 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |   4 +-
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c   |   2 +-
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |   7 +-
 tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c |   9 -
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |   8 +-
 .../testing/selftests/kvm/x86_64/xapic_ipi_test.c  |   2 +-
 89 files changed, 2208 insertions(+), 740 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_mte.h
 create mode 100644 include/linux/irqchip/arm-vgic-info.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/debug-exceptions.c
 delete mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/handlers.S
