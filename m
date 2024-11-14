Return-Path: <kvm+bounces-31838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C19399C8415
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 08:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E5F51F2297A
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 07:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E7C1F4FD0;
	Thu, 14 Nov 2024 07:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Imlaw8zr"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099E91EBFF6
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 07:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731569919; cv=none; b=Vqr3mbHONBMsExHFdZuboND5mdCbGlYX+kanAFDo9SDjraYijEkM42hQ3dhWc9hTEkdMwfPn9gwhQb//Zf4VNltNFj6b6G3KM8jSiyOCsty2Fy/QQiz85TURlUklnJkOkGXEJNwMZhcQRfpPMoo0EfkNSJyKP2giX77kWfLldNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731569919; c=relaxed/simple;
	bh=iF3I8wem+QM4TRibsqXcg20i1fGoza1q9NZe1LY+scs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=VT2zcFIw+/axlg7779jdXowC9yapMcAA5WXztVQBGa1rPvktZXUhbWjeWSeCDJFXuFDHCo+Q8fwXTZVnd561EApaMQokAn5vVwZ6/yTGkxp8DmIUR6qpIQJy3WEiORkE2CW3jK3U65Bx7BLS0cipuXrDjpl7auBwOfUUK4V3+ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Imlaw8zr; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 13 Nov 2024 23:38:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731569914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=uajpu78lDZfKmTEAGZloofJ5jaXiVrS+GhV/b4AjkEU=;
	b=Imlaw8zrRlqAd/nVp3l00DV2FCVswZQ2ShzkdldV2tG0lcQE7p9abEAqIZxHml+PVwZIS8
	aRt/I2AQ6hnL/U6FZ2zaIbkSJeQQ/Xng2uywTtYtSVg70o5itRF0FvCi8+jmoYI61bw4TW
	zvOijqki5sdwxJwAsI3ccXPRtxGVmyY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	David Woodhouse <dwmw@amazon.co.uk>, Fuad Tabba <tabba@google.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Will Deacon <will@kernel.org>, James Clark <james.clark@linaro.org>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: [GIT PULL] KVM/arm64 changes for 6.13
Message-ID: <ZzWo7_GSUNXe7Ip_@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Here's the main pile of changes for 6.13. The march towards implementing
nested continues on, this time with the PMU and MMU getting attention.

Note I've taken David's patch to use SYSTEM_OFF2 in the PSCI driver to
hibernate, which was part of his combined series. There is also an
extremely trivial conflict between this and the arm64 tree, both adding
the same field enumeration to the sysreg table.

Details found in the tag, please pull.

-- 
Thanks,
Oliver

The following changes since commit 81983758430957d9a5cb3333fe324fd70cf63e7e:

  Linux 6.12-rc5 (2024-10-27 12:52:02 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-6.13

for you to fetch changes up to 60ad25e14ab5a4e56c8bf7f7d6846eacb9cd53df:

  KVM: arm64: Pass on SVE mapping failures (2024-11-12 11:04:39 -0800)

----------------------------------------------------------------
KVM/arm64 changes for 6.13, part #1

 - Support for stage-1 permission indirection (FEAT_S1PIE) and
   permission overlays (FEAT_S1POE), including nested virt + the
   emulated page table walker

 - Introduce PSCI SYSTEM_OFF2 support to KVM + client driver. This call
   was introduced in PSCIv1.3 as a mechanism to request hibernation,
   similar to the S4 state in ACPI

 - Explicitly trap + hide FEAT_MPAM (QoS controls) from KVM guests. As
   part of it, introduce trivial initialization of the host's MPAM
   context so KVM can use the corresponding traps

 - PMU support under nested virtualization, honoring the guest
   hypervisor's trap configuration and event filtering when running a
   nested guest

 - Fixes to vgic ITS serialization where stale device/interrupt table
   entries are not zeroed when the mapping is invalidated by the VM

 - Avoid emulated MMIO completion if userspace has requested synchronous
   external abort injection

 - Various fixes and cleanups affecting pKVM, vCPU initialization, and
   selftests

----------------------------------------------------------------
David Woodhouse (6):
      firmware/psci: Add definitions for PSCI v1.3 specification
      KVM: arm64: Add PSCI v1.3 SYSTEM_OFF2 function for hibernation
      KVM: arm64: Add support for PSCI v1.2 and v1.3
      KVM: selftests: Add test for PSCI SYSTEM_OFF2
      KVM: arm64: nvhe: Pass through PSCI v1.3 SYSTEM_OFF2 call
      arm64: Use SYSTEM_OFF2 PSCI call to power off for hibernate

Fuad Tabba (4):
      KVM: arm64: Move pkvm_vcpu_init_traps() to init_pkvm_hyp_vcpu()
      KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp use
      KVM: arm64: Initialize the hypervisor's VM state at EL2
      KVM: arm64: Initialize trap register values in hyp in pKVM

James Clark (1):
      KVM: arm64: Pass on SVE mapping failures

James Morse (7):
      arm64/sysreg: Convert existing MPAM sysregs and add the remaining entries
      arm64: head.S: Initialise MPAM EL2 registers and disable traps
      arm64: cpufeature: discover CPU support for MPAM
      KVM: arm64: Fix missing traps of guest accesses to the MPAM registers
      KVM: arm64: Add a macro for creating filtered sys_reg_descs entries
      KVM: arm64: Disable MPAM visibility by default and ignore VMM writes
      KVM: arm64: selftests: Test ID_AA64PFR0.MPAM isn't completely ignored

Jing Zhang (1):
      KVM: arm64: vgic-its: Add a data length check in vgic_its_save_*

Kunkun Jiang (2):
      KVM: arm64: vgic-its: Clear DTE when MAPD unmaps a device
      KVM: arm64: vgic-its: Clear ITE when DISCARD frees an ITE

Marc Zyngier (33):
      arm64: Drop SKL0/SKL1 from TCR2_EL2
      arm64: Remove VNCR definition for PIRE0_EL2
      arm64: Add encoding for PIRE0_EL2
      KVM: arm64: Drop useless struct s2_mmu in __kvm_at_s1e2()
      KVM: arm64: nv: Add missing EL2->EL1 mappings in get_el2_to_el1_mapping()
      KVM: arm64: nv: Handle CNTHCTL_EL2 specially
      arm64: Define ID_AA64MMFR1_EL1.HAFDBS advertising FEAT_HAFT
      KVM: arm64: Add TCR2_EL2 to the sysreg arrays
      KVM: arm64: nv: Save/Restore vEL2 sysregs
      KVM: arm64: Sanitise TCR2_EL2
      KVM: arm64: Correctly access TCR2_EL1, PIR_EL1, PIRE0_EL1 with VHE
      KVM: arm64: Add save/restore for TCR2_EL2
      KVM: arm64: Extend masking facility to arbitrary registers
      KVM: arm64: Add PIR{,E0}_EL2 to the sysreg arrays
      KVM: arm64: Add save/restore for PIR{,E0}_EL2
      KVM: arm64: Handle PIR{,E0}_EL2 traps
      KVM: arm64: Add AT fast-path support for S1PIE
      KVM: arm64: Split S1 permission evaluation into direct and hierarchical parts
      KVM: arm64: Disable hierarchical permissions when S1PIE is enabled
      KVM: arm64: Implement AT S1PIE support
      KVM: arm64: Add a composite EL2 visibility helper
      KVM: arm64: Rely on visibility to let PIR*_ELx/TCR2_ELx UNDEF
      arm64: Add encoding for POR_EL2
      KVM: arm64: Drop bogus CPTR_EL2.E0POE trap routing
      KVM: arm64: Subject S1PIE/S1POE registers to HCR_EL2.{TVM,TRVM}
      KVM: arm64: Add kvm_has_s1poe() helper
      KVM: arm64: Add basic support for POR_EL2
      KVM: arm64: Add save/restore support for POR_EL2
      KVM: arm64: Add POE save/restore for AT emulation fast-path
      KVM: arm64: Disable hierarchical permissions when POE is enabled
      KVM: arm64: Make PAN conditions part of the S1 walk context
      KVM: arm64: Handle stage-1 permission overlays
      KVM: arm64: Handle WXN attribute

Mark Brown (3):
      KVM: arm64: Define helper for EL2 registers with custom visibility
      KVM: arm64: Hide TCR2_EL1 from userspace when disabled for guests
      KVM: arm64: Hide S1PIE registers from userspace when disabled for guests

Oliver Upton (28):
      KVM: arm64: Don't retire aborted MMIO instruction
      tools: arm64: Grab a copy of esr.h from kernel
      KVM: arm64: selftests: Convert to kernel's ESR terminology
      KVM: arm64: selftests: Add tests for MMIO external abort injection
      arm64: sysreg: Describe ID_AA64DFR2_EL1 fields
      arm64: sysreg: Migrate MDCR_EL2 definition to table
      arm64: sysreg: Add new definitions for ID_AA64DFR0_EL1
      KVM: arm64: Describe RES0/RES1 bits of MDCR_EL2
      KVM: arm64: nv: Allow coarse-grained trap combos to use complex traps
      KVM: arm64: nv: Rename BEHAVE_FORWARD_ANY
      KVM: arm64: nv: Reinject traps that take effect in Host EL0
      KVM: arm64: nv: Honor MDCR_EL2.{TPM, TPMCR} in Host EL0
      KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
      KVM: arm64: nv: Advertise support for FEAT_HPMN0
      KVM: arm64: Rename kvm_pmu_valid_counter_mask()
      KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
      KVM: arm64: Add helpers to determine if PMC counts at a given EL
      KVM: arm64: nv: Honor MDCR_EL2.HPME
      KVM: arm64: nv: Honor MDCR_EL2.HLP
      KVM: arm64: nv: Apply EL2 event filtering when in hyp context
      KVM: arm64: nv: Reprogram PMU events affected by nested transition
      Merge branch kvm-arm64/nv-s1pie-s1poe into kvmarm/next
      Merge branch kvm-arm64/psci-1.3 into kvmarm/next
      Merge branch kvm-arm64/mpam-ni into kvmarm/next
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/mmio-sea into kvmarm/next
      Merge branch kvm-arm64/nv-pmu into kvmarm/next
      Merge branch kvm-arm64/vgic-its-fixes into kvmarm/next

Raghavendra Rao Ananta (1):
      KVM: arm64: Get rid of userspace_irqchip_in_use

Sean Christopherson (1):
      KVM: selftests: Don't bother deleting memslots in KVM when freeing VMs

Shameer Kolothum (1):
      KVM: arm64: Make L1Ip feature in CTR_EL0 writable from userspace

Will Deacon (2):
      KVM: arm64: Just advertise SEIS as 0 when emulating ICC_CTLR_EL1
      KVM: arm64: Don't map 'kvm_vgic_global_state' at EL2 with pKVM

 Documentation/arch/arm64/cpu-feature-registers.rst |   2 +
 Documentation/virt/kvm/api.rst                     |  10 +
 arch/arm64/include/asm/cpu.h                       |   1 +
 arch/arm64/include/asm/cpucaps.h                   |   5 +
 arch/arm64/include/asm/cpufeature.h                |  17 +
 arch/arm64/include/asm/el2_setup.h                 |  14 +
 arch/arm64/include/asm/kvm_arm.h                   |  30 +-
 arch/arm64/include/asm/kvm_asm.h                   |   1 -
 arch/arm64/include/asm/kvm_emulate.h               |   9 +
 arch/arm64/include/asm/kvm_host.h                  |  44 +-
 arch/arm64/include/asm/sysreg.h                    |  12 -
 arch/arm64/include/asm/vncr_mapping.h              |   1 -
 arch/arm64/include/uapi/asm/kvm.h                  |   6 +
 arch/arm64/kernel/cpufeature.c                     |  96 +++++
 arch/arm64/kernel/cpuinfo.c                        |   3 +
 arch/arm64/kvm/arch_timer.c                        |   3 +-
 arch/arm64/kvm/arm.c                               |  26 +-
 arch/arm64/kvm/at.c                                | 470 ++++++++++++++++++---
 arch/arm64/kvm/emulate-nested.c                    | 301 +++++++------
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  31 ++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  11 +-
 arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |   2 -
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     | 116 ++++-
 arch/arm64/kvm/hyp/nvhe/psci-relay.c               |   2 +
 arch/arm64/kvm/hyp/nvhe/setup.c                    |  20 +-
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c                |   2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   3 -
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 | 160 ++++++-
 arch/arm64/kvm/hypercalls.c                        |   2 +
 arch/arm64/kvm/mmio.c                              |  32 +-
 arch/arm64/kvm/nested.c                            |  82 +++-
 arch/arm64/kvm/pmu-emul.c                          | 143 ++++++-
 arch/arm64/kvm/psci.c                              |  44 +-
 arch/arm64/kvm/reset.c                             |   5 -
 arch/arm64/kvm/sys_regs.c                          | 309 +++++++++++---
 arch/arm64/kvm/vgic/vgic-its.c                     |  32 +-
 arch/arm64/kvm/vgic/vgic.h                         |  23 +
 arch/arm64/tools/cpucaps                           |   2 +
 arch/arm64/tools/sysreg                            | 249 ++++++++++-
 drivers/firmware/psci/psci.c                       |  45 ++
 include/kvm/arm_arch_timer.h                       |   3 +
 include/kvm/arm_pmu.h                              |  18 +-
 include/kvm/arm_psci.h                             |   4 +-
 include/uapi/linux/psci.h                          |   5 +
 kernel/power/hibernate.c                           |   5 +-
 tools/arch/arm64/include/asm/brk-imm.h             |  42 ++
 tools/arch/arm64/include/asm/esr.h                 | 455 ++++++++++++++++++++
 tools/testing/selftests/kvm/Makefile               |   1 +
 .../selftests/kvm/aarch64/debug-exceptions.c       |  10 +-
 tools/testing/selftests/kvm/aarch64/mmio_abort.c   | 159 +++++++
 tools/testing/selftests/kvm/aarch64/no-vgic-v3.c   |   2 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |   4 +-
 tools/testing/selftests/kvm/aarch64/psci_test.c    |  92 ++++
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |  99 ++++-
 .../selftests/kvm/aarch64/vpmu_counter_access.c    |  12 +-
 .../selftests/kvm/include/aarch64/processor.h      |  15 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  10 +-
 59 files changed, 2859 insertions(+), 461 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/brk-imm.h
 create mode 100644 tools/arch/arm64/include/asm/esr.h
 create mode 100644 tools/testing/selftests/kvm/aarch64/mmio_abort.c

