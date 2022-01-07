Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2A64876B5
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 12:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347196AbiAGLqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 06:46:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiAGLqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 06:46:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23A066191D
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 11:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C807C36AED;
        Fri,  7 Jan 2022 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641555960;
        bh=vz3VQViK5ml7AV6ckusreRI3MEkT4p+GB02SXEo50CE=;
        h=From:To:Cc:Subject:Date:From;
        b=NZyIeuu9N1qP4b16yQJgh1eItgig4i6Ue/X/9LAJbF56ZQ6Br99HzaOLlGYcmNYjF
         WX5hLQeKLbyMgCStnq498yNShUhiF8OHxyFnl5Shdyu5BBdG5U5vNPwr63wwUUOdVe
         cFqBaU740dleFE7PTj2ZMMQi5Kh/vHiqZQk0WNGgEy+uNRLC58vandvFUfRuuHZr0N
         2tnsCmnsLFFEtwNWYMSTCxOl+u+fY7xtnDttP/8Z60qzEcCQzIx+Y2+sNGNNhWcSOX
         ZqliIfvir44PMjBJhj8RVBKMO/RaEaJVx/3PW708WfPJZ7+oCRqq4nTzj+BqTmbQ14
         olmQFCpLEvEaw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n5nh0-00GZ2S-FT; Fri, 07 Jan 2022 11:45:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Walbran <qwandor@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Mark Brown <broonie@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [GIT PULL] KVM/arm64 updates for 5.17
Date:   Fri,  7 Jan 2022 11:45:48 +0000
Message-Id: <20220107114548.4069893-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, drjones@redhat.com, qwandor@google.com, andriy.shevchenko@linux.intel.com, tabba@google.com, gankulkarni@os.amperecomputing.com, broonie@kernel.org, qperret@google.com, ricarkol@google.com, rikard.falkeborn@gmail.com, vkuznets@redhat.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

Here's the bulk of the KVM/arm64 updates for 5.17. No real new feature
this time around, but a bunch of changes that will make the merging of
upcoming features easier (pKVM is reaching a point where it will
finally be usable, and NV isn't too far off... fingers crossed). This
comes with the usual set of bug fixes and cleanups all over the shop.

We also have a sizeable chunks of selftest updates which probably
account for half of the changes.

Please pull,

	M.

The following changes since commit d58071a8a76d779eedab38033ae4c821c30295a5:

  Linux 5.16-rc3 (2021-11-28 14:09:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.17

for you to fetch changes up to 1c53a1ae36120997a82f936d044c71075852e521:

  Merge branch kvm-arm64/misc-5.17 into kvmarm-master/next (2022-01-04 17:16:15 +0000)

----------------------------------------------------------------
KVM/arm64 updates for Linux 5.16

- Simplification of the 'vcpu first run' by integrating it into
  KVM's 'pid change' flow

- Refactoring of the FP and SVE state tracking, also leading to
  a simpler state and less shared data between EL1 and EL2 in
  the nVHE case

- Tidy up the header file usage for the nvhe hyp object

- New HYP unsharing mechanism, finally allowing pages to be
  unmapped from the Stage-1 EL2 page-tables

- Various pKVM cleanups around refcounting and sharing

- A couple of vgic fixes for bugs that would trigger once
  the vcpu xarray rework is merged, but not sooner

- Add minimal support for ARMv8.7's PMU extension

- Rework kvm_pgtable initialisation ahead of the NV work

- New selftest for IRQ injection

- Teach selftests about the lack of default IPA space and
  page sizes

- Expand sysreg selftest to deal with Pointer Authentication

- The usual bunch of cleanups and doc update

----------------------------------------------------------------
Andy Shevchenko (1):
      KVM: arm64: vgic: Replace kernel.h with the necessary inclusions

Fuad Tabba (3):
      KVM: arm64: Use defined value for SCTLR_ELx_EE
      KVM: arm64: Fix comment for kvm_reset_vcpu()
      KVM: arm64: Fix comment on barrier in kvm_psci_vcpu_on()

Marc Zyngier (33):
      KVM: arm64: Reorder vcpu flag definitions
      KVM: arm64: Get rid of host SVE tracking/saving
      KVM: arm64: Remove unused __sve_save_state
      KVM: arm64: Introduce flag shadowing TIF_FOREIGN_FPSTATE
      KVM: arm64: Stop mapping current thread_info at EL2
      arm64/fpsimd: Document the use of TIF_FOREIGN_FPSTATE by KVM
      KVM: arm64: Move SVE state mapping at HYP to finalize-time
      KVM: arm64: Move kvm_arch_vcpu_run_pid_change() out of line
      KVM: arm64: Restructure the point where has_run_once is advertised
      KVM: arm64: Merge kvm_arch_vcpu_run_pid_change() and kvm_vcpu_first_run_init()
      KVM: arm64: Drop vcpu->arch.has_run_once for vcpu->pid
      Merge branch kvm-arm64/vcpu-first-run into kvmarm-master/next
      Merge branch kvm-arm64/fpsimd-tracking into kvmarm-master/next
      KVM: arm64: Add minimal handling for the ARMv8.7 PMU
      Merge branch kvm-arm64/hyp-header-split into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.17 into kvmarm-master/next
      KVM: arm64: Drop unused workaround_flags vcpu field
      Merge branch kvm-arm64/pkvm-cleanups-5.17 into kvmarm-master/next
      KVM: arm64: vgic-v3: Fix vcpu index comparison
      KVM: arm64: vgic: Demote userspace-triggered console prints to kvm_debug()
      Merge branch kvm-arm64/vgic-fixes-5.17 into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-hyp-sharing into kvmarm-master/next
      KVM: arm64: Rework kvm_pgtable initialisation
      KVM: selftests: arm64: Initialise default guest mode at test startup time
      KVM: selftests: arm64: Introduce a variable default IPA size
      KVM: selftests: arm64: Check for supported page sizes
      KVM: selftests: arm64: Rework TCR_EL1 configuration
      KVM: selftests: arm64: Add support for VM_MODE_P36V48_{4K,64K}
      KVM: selftests: arm64: Add support for various modes with 16kB page size
      KVM: arm64: selftests: get-reg-list: Add pauth configuration
      Merge branch kvm-arm64/selftest/ipa into kvmarm-master/next
      Merge branch kvm-arm64/selftest/irq-injection into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.17 into kvmarm-master/next

Quentin Perret (12):
      KVM: arm64: pkvm: Fix hyp_pool max order
      KVM: arm64: pkvm: Disable GICv2 support
      KVM: arm64: Make the hyp memory pool static
      KVM: arm64: Make __io_map_base static
      KVM: arm64: pkvm: Stub io map functions
      KVM: arm64: pkvm: Make kvm_host_owns_hyp_mappings() robust to VHE
      KVM: arm64: Provide {get,put}_page() stubs for early hyp allocator
      KVM: arm64: Refcount hyp stage-1 pgtable pages
      KVM: arm64: Fixup hyp stage-1 refcount
      KVM: arm64: Introduce kvm_share_hyp()
      KVM: arm64: pkvm: Refcount the pages shared with EL2
      KVM: arm64: pkvm: Unshare guest structs during teardown

Ricardo Koller (17):
      KVM: selftests: aarch64: Move gic_v3.h to shared headers
      KVM: selftests: aarch64: Add function for accessing GICv3 dist and redist registers
      KVM: selftests: aarch64: Add GICv3 register accessor library functions
      KVM: selftests: Add kvm_irq_line library function
      KVM: selftests: aarch64: Add vGIC library functions to deal with vIRQ state
      KVM: selftests: aarch64: Add vgic_irq to test userspace IRQ injection
      KVM: selftests: aarch64: Abstract the injection functions in vgic_irq
      KVM: selftests: aarch64: Cmdline arg to set number of IRQs in vgic_irq test
      KVM: selftests: aarch64: Cmdline arg to set EOI mode in vgic_irq
      KVM: selftests: aarch64: Add preemption tests in vgic_irq
      KVM: selftests: aarch64: Level-sensitive interrupts tests in vgic_irq
      KVM: selftests: aarch64: Add tests for LEVEL_INFO in vgic_irq
      KVM: selftests: aarch64: Add test_inject_fail to vgic_irq
      KVM: selftests: Add IRQ GSI routing library functions
      KVM: selftests: aarch64: Add tests for IRQFD in vgic_irq
      KVM: selftests: aarch64: Add ISPENDR write tests in vgic_irq
      KVM: selftests: aarch64: Add test for restoring active IRQs

Rikard Falkeborn (1):
      KVM: arm64: Constify kvm_io_gic_ops

Vitaly Kuznetsov (1):
      KVM: Drop stale kvm_is_transparent_hugepage() declaration

Will Deacon (11):
      arm64: Add missing include of asm/cpufeature.h to asm/mmu.h
      KVM: arm64: Generate hyp_constants.h for the host
      KVM: arm64: Move host EL1 code out of hyp/ directory
      KVM: arm64: Hook up ->page_count() for hypervisor stage-1 page-table
      KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2
      KVM: arm64: Extend pkvm_page_state enumeration to handle absent pages
      KVM: arm64: Introduce wrappers for host and hyp spin lock accessors
      KVM: arm64: Implement do_share() helper for sharing memory
      KVM: arm64: Implement __pkvm_host_share_hyp() using do_share()
      KVM: arm64: Implement do_unshare() helper for unsharing memory
      KVM: arm64: Expose unshare hypercall to the host

Zenghui Yu (1):
      KVM: arm64: Fix comment typo in kvm_vcpu_finalize_sve()

 arch/arm64/include/asm/kvm_asm.h                   |   1 +
 arch/arm64/include/asm/kvm_emulate.h               |   2 +-
 arch/arm64/include/asm/kvm_host.h                  |  46 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   1 -
 arch/arm64/include/asm/kvm_mmu.h                   |   2 +
 arch/arm64/include/asm/kvm_pgtable.h               |  30 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |  71 ++
 arch/arm64/include/asm/mmu.h                       |   1 +
 arch/arm64/include/asm/sysreg.h                    |   1 +
 arch/arm64/kernel/asm-offsets.c                    |   1 -
 arch/arm64/kernel/fpsimd.c                         |   6 +-
 arch/arm64/kvm/.gitignore                          |   2 +
 arch/arm64/kvm/Makefile                            |  18 +-
 arch/arm64/kvm/arm.c                               |  64 +-
 arch/arm64/kvm/fpsimd.c                            |  79 +-
 arch/arm64/kvm/hyp/Makefile                        |   2 +-
 arch/arm64/kvm/hyp/fpsimd.S                        |   6 -
 arch/arm64/kvm/hyp/hyp-constants.c                 |  10 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  30 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   6 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |  59 --
 arch/arm64/kvm/hyp/nvhe/early_alloc.c              |   5 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   8 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 505 ++++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   4 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |   2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  25 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   1 -
 arch/arm64/kvm/hyp/pgtable.c                       | 108 ++-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   1 -
 arch/arm64/kvm/mmu.c                               | 150 +++-
 arch/arm64/kvm/{hyp/reserved_mem.c => pkvm.c}      |   8 +-
 arch/arm64/kvm/pmu-emul.c                          |   1 +
 arch/arm64/kvm/psci.c                              |   2 +-
 arch/arm64/kvm/reset.c                             |  28 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   8 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |   2 +-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |   2 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |   9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   6 +-
 include/kvm/arm_vgic.h                             |   4 +-
 include/linux/kvm_host.h                           |   1 -
 tools/testing/selftests/kvm/.gitignore             |   1 +
 tools/testing/selftests/kvm/Makefile               |   1 +
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   2 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |  50 ++
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     | 853 +++++++++++++++++++++
 tools/testing/selftests/kvm/include/aarch64/gic.h  |  26 +
 .../kvm/{lib => include}/aarch64/gic_v3.h          |  12 +
 .../selftests/kvm/include/aarch64/processor.h      |   3 +
 tools/testing/selftests/kvm/include/aarch64/vgic.h |  18 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  20 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c      |  66 ++
 .../selftests/kvm/lib/aarch64/gic_private.h        |  11 +
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   | 206 ++++-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  82 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     | 103 ++-
 tools/testing/selftests/kvm/lib/guest_modes.c      |  49 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  94 +++
 60 files changed, 2532 insertions(+), 385 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_pkvm.h
 create mode 100644 arch/arm64/kvm/.gitignore
 create mode 100644 arch/arm64/kvm/hyp/hyp-constants.c
 rename arch/arm64/kvm/{hyp/reserved_mem.c => pkvm.c} (94%)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vgic_irq.c
 rename tools/testing/selftests/kvm/{lib => include}/aarch64/gic_v3.h (80%)
