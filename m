Return-Path: <kvm+bounces-11452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96F9587725A
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 17:40:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E12391F219AF
	for <lists+kvm@lfdr.de>; Sat,  9 Mar 2024 16:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FAB41CD1D;
	Sat,  9 Mar 2024 16:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Qd0GxRWb"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E9E16FF36
	for <kvm@vger.kernel.org>; Sat,  9 Mar 2024 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710002423; cv=none; b=cPLkbfdrOSjGyF7MbM5rDMv+DUCYzyVfue9WMYJRB9aXz5tfA9vxod0S6pxcsx9daXoRiiZDe5vC9l0nFWGk8h7h5/Msm6LNgFkacZRaW8/XEOu4wOJhG1ffuyUVFAHulBSoHKMS3IYgsSUOxzcEtSJN7utAbZR82MuQ1OqeZJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710002423; c=relaxed/simple;
	bh=R30PQyYqiqJNS18gmSJDV/P48omUH2ofvCiz/RbOGtI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OMZPgSKTQNo5XXR8uMc9E6qVlQBGt6QDdHIl3K9YgB80sMh73sPamKgOdnJo7zTPHABHPHqZ9PU+Jv53VONaAsqW+0sLO21BZ5jZgm22hNtpzWtPpGkGhM7ABbn1zCHNF0c0tRhZDA+PUpRDOND6Iycvfq0TeHbg3QJy/Q9dGvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Qd0GxRWb; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sat, 9 Mar 2024 08:40:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710002417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=XZq7PGYR9cBujBQNgj+ZMS0WfFU95iMA+4xN9RNQBUY=;
	b=Qd0GxRWbvohBE//EmZdq5V6jRunRu42yZke7GavYgaFGDpyScRg5qcfQXZME/9a0Vs71w1
	ADCTd+1NDeMnOr6NPlNlus63/7mhFNgavfmZJM+udk5XWGqrAj/Y55izC0Munm2LoMI1DG
	u+M88qpjbBtnVHlJXEW9PjNkUlVcTWs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: ankita@nvidia.com, bhelgaas@google.com, jingzhangos@google.com,
	joey.gouly@arm.com, maz@kernel.org, rananta@google.com,
	rdunlap@infradead.org, seanjc@google.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Subject: [GIT PULL] KVM/arm64 updates for 6.9
Message-ID: <ZeyQ5TK3pULYc32o@thinky-boi>
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

Here's all the KVM/arm64 changes for 6.9. As usual, details about the changes
can be found in the tag.

In terms of interactions with other trees, Alex has pulled my topic branch for
vfio-pci Normal-NC mappings and a (trivial) conflict with the arm64 tree.
Appended my resolution at the end.

Please pull.

-- 
Thanks,
Oliver

The following changes since commit 6613476e225e090cc9aad49be7fa504e290dd33d:

  Linux 6.8-rc1 (2024-01-21 14:11:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.9

for you to fetch changes up to 4a09ddb8333a3efec715f6cfd099f9dc4fbaa7cc:

  Merge branch kvm-arm64/kerneldoc into kvmarm/next (2024-03-07 00:56:16 +0000)

----------------------------------------------------------------
KVM/arm64 updates for 6.9

 - Infrastructure for building KVM's trap configuration based on the
   architectural features (or lack thereof) advertised in the VM's ID
   registers

 - Support for mapping vfio-pci BARs as Normal-NC (vaguely similar to
   x86's WC) at stage-2, improving the performance of interacting with
   assigned devices that can tolerate it

 - Conversion of KVM's representation of LPIs to an xarray, utilized to
   address serialization some of the serialization on the LPI injection
   path

 - Support for _architectural_ VHE-only systems, advertised through the
   absence of FEAT_E2H0 in the CPU's ID register

 - Miscellaneous cleanups, fixes, and spelling corrections to KVM and
   selftests

----------------------------------------------------------------
Ankit Agrawal (4):
      KVM: arm64: Introduce new flag for non-cacheable IO memory
      mm: Introduce new flag to indicate wc safe
      KVM: arm64: Set io memory s2 pte as normalnc for vfio pci device
      vfio: Convey kvm that the vfio-pci device is wc safe

Bjorn Helgaas (1):
      KVM: arm64: Fix typos

Jing Zhang (1):
      KVM: arm64: selftests: Handle feature fields with nonzero minimum value correctly

Joey Gouly (3):
      KVM: arm64: print Hyp mode
      KVM: arm64: add comments to __kern_hyp_va
      KVM: arm64: removed unused kern_hyp_va asm macro

Marc Zyngier (41):
      arm64: Add macro to compose a sysreg field value
      arm64: cpufeatures: Correctly handle signed values
      arm64: cpufeature: Correctly display signed override values
      arm64: sysreg: Add layout for ID_AA64MMFR4_EL1
      arm64: cpufeature: Add ID_AA64MMFR4_EL1 handling
      arm64: cpufeature: Detect HCR_EL2.NV1 being RES0
      arm64: Treat HCR_EL2.E2H as RES1 when ID_AA64MMFR4_EL1.E2H0 is negative
      KVM: arm64: Expose ID_AA64MMFR4_EL1 to guests
      KVM: arm64: Force guest's HCR_EL2.E2H RES1 when NV1 is not implemented
      KVM: arm64: Handle Apple M2 as not having HCR_EL2.NV1 implemented
      arm64: cpufeatures: Add missing ID_AA64MMFR4_EL1 to __read_sysreg_by_encoding()
      arm64: cpufeatures: Only check for NV1 if NV is present
      arm64: cpufeatures: Fix FEAT_NV check when checking for FEAT_NV1
      arm64: sysreg: Add missing ID_AA64ISAR[13]_EL1 fields and variants
      KVM: arm64: Add feature checking helpers
      KVM: arm64: nv: Add sanitising to VNCR-backed sysregs
      KVM: arm64: nv: Add sanitising to EL2 configuration registers
      KVM: arm64: nv: Add sanitising to VNCR-backed FGT sysregs
      KVM: arm64: nv: Add sanitising to VNCR-backed HCRX_EL2
      KVM: arm64: nv: Drop sanitised_sys_reg() helper
      KVM: arm64: Unify HDFG[WR]TR_GROUP FGT identifiers
      KVM: arm64: nv: Correctly handle negative polarity FGTs
      KVM: arm64: nv: Turn encoding ranges into discrete XArray stores
      KVM: arm64: Drop the requirement for XARRAY_MULTI
      KVM: arm64: nv: Move system instructions to their own sys_reg_desc array
      KVM: arm64: Always populate the trap configuration xarray
      KVM: arm64: Register AArch64 system register entries with the sysreg xarray
      KVM: arm64: Use the xarray as the primary sysreg/sysinsn walker
      KVM: arm64: Rename __check_nv_sr_forward() to triage_sysreg_trap()
      KVM: arm64: Add Fine-Grained UNDEF tracking information
      KVM: arm64: Propagate and handle Fine-Grained UNDEF bits
      KVM: arm64: Move existing feature disabling over to FGU infrastructure
      KVM: arm64: Streamline save/restore of HFG[RW]TR_EL2
      KVM: arm64: Make TLBI OS/Range UNDEF if not advertised to the guest
      KVM: arm64: Make PIR{,E0}_EL1 UNDEF if S1PIE is not advertised to the guest
      KVM: arm64: Make AMU sysreg UNDEF if FEAT_AMU is not advertised to the guest
      KVM: arm64: Make FEAT_MOPS UNDEF if not advertised to the guest
      KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later checking
      KVM: arm64: Add debugfs file for guest's ID registers
      KVM: arm64: Make build-time check of RES0/RES1 bits optional
      KVM: arm64: Fix TRFCR_EL1/PMSCR_EL1 access in hVHE mode

Oliver Upton (20):
      KVM: selftests: Print timer ctl register in ISTATUS assertion
      KVM: Get rid of return value from kvm_arch_create_vm_debugfs()
      KVM: arm64: vgic: Store LPIs in an xarray
      KVM: arm64: vgic: Use xarray to find LPI in vgic_get_lpi()
      KVM: arm64: vgic-v3: Iterate the xarray to find pending LPIs
      KVM: arm64: vgic-its: Walk the LPI xarray in vgic_copy_lpi_list()
      KVM: arm64: vgic: Get rid of the LPI linked-list
      KVM: arm64: vgic: Use atomics to count LPIs
      KVM: arm64: vgic: Free LPI vgic_irq structs in an RCU-safe manner
      KVM: arm64: vgic: Rely on RCU protection in vgic_get_lpi()
      KVM: arm64: vgic: Ensure the irq refcount is nonzero when taking a ref
      KVM: arm64: vgic: Don't acquire the lpi_list_lock in vgic_put_irq()
      KVM: arm64: Fail the idreg iterator if idregs aren't initialized
      KVM: arm64: Don't initialize idreg debugfs w/ preemption disabled
      Merge branch kvm-arm64/feat_e2h0 into kvmarm/next
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/vm-configuration into kvmarm/next
      Merge branch kvm-arm64/lpi-xarray into kvmarm/next
      Merge branch kvm-arm64/vfio-normal-nc into kvmarm/next
      Merge branch kvm-arm64/kerneldoc into kvmarm/next

Raghavendra Rao Ananta (1):
      KVM: selftests: aarch64: Remove unused functions from vpmu test

Randy Dunlap (10):
      KVM: arm64: debug: fix kernel-doc warnings
      KVM: arm64: guest: fix kernel-doc warnings
      KVM: arm64: hyp/aarch32: fix kernel-doc warnings
      KVM: arm64: vhe: fix a kernel-doc warning
      KVM: arm64: mmu: fix a kernel-doc warning
      KVM: arm64: PMU: fix kernel-doc warnings
      KVM: arm64: sys_regs: fix kernel-doc warnings
      KVM: arm64: vgic-init: fix a kernel-doc warning
      KVM: arm64: vgic-its: fix kernel-doc warnings
      KVM: arm64: vgic: fix a kernel-doc warning

Sean Christopherson (1):
      KVM: selftests: Fix GUEST_PRINTF() format warnings in ARM code

 arch/arm64/include/asm/cpu.h                       |   1 +
 arch/arm64/include/asm/cpufeature.h                |   1 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |   3 +-
 arch/arm64/include/asm/kvm_host.h                  |  99 +++++++-
 arch/arm64/include/asm/kvm_hyp.h                   |   2 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  46 ++--
 arch/arm64/include/asm/kvm_nested.h                |   1 -
 arch/arm64/include/asm/kvm_pgtable.h               |   2 +
 arch/arm64/include/asm/memory.h                    |   2 +
 arch/arm64/include/asm/sysreg.h                    |   5 +-
 arch/arm64/kernel/cpufeature.c                     | 105 +++++++-
 arch/arm64/kernel/cpuinfo.c                        |   1 +
 arch/arm64/kernel/head.S                           |  23 +-
 arch/arm64/kvm/Kconfig                             |  12 +-
 arch/arm64/kvm/arch_timer.c                        |   2 +-
 arch/arm64/kvm/arm.c                               |  14 +-
 arch/arm64/kvm/check-res-bits.h                    | 125 ++++++++++
 arch/arm64/kvm/debug.c                             |   3 +-
 arch/arm64/kvm/emulate-nested.c                    | 231 ++++++++++++-----
 arch/arm64/kvm/fpsimd.c                            |   2 +-
 arch/arm64/kvm/guest.c                             |   7 +-
 arch/arm64/kvm/hyp/aarch32.c                       |   4 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            | 130 +++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  24 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |  12 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   2 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   4 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  24 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   2 +-
 arch/arm64/kvm/inject_fault.c                      |   2 +-
 arch/arm64/kvm/mmu.c                               |  16 +-
 arch/arm64/kvm/nested.c                            | 274 ++++++++++++++++++++-
 arch/arm64/kvm/pmu-emul.c                          |  15 +-
 arch/arm64/kvm/sys_regs.c                          | 266 ++++++++++++++++----
 arch/arm64/kvm/sys_regs.h                          |   2 +
 arch/arm64/kvm/vgic/vgic-debug.c                   |   2 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  10 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  63 +++--
 arch/arm64/kvm/vgic/vgic-v3.c                      |   3 +-
 arch/arm64/kvm/vgic/vgic.c                         |  62 ++---
 arch/arm64/kvm/vgic/vgic.h                         |  15 +-
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/sysreg                            |  45 +++-
 arch/powerpc/kvm/powerpc.c                         |   3 +-
 arch/x86/kvm/debugfs.c                             |   3 +-
 drivers/vfio/pci/vfio_pci_core.c                   |  19 +-
 include/kvm/arm_pmu.h                              |  11 -
 include/kvm/arm_vgic.h                             |   9 +-
 include/linux/kvm_host.h                           |   2 +-
 include/linux/mm.h                                 |  14 ++
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |   2 +-
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |   4 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |   2 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  |  18 +-
 .../selftests/kvm/aarch64/vpmu_counter_access.c    |  28 +--
 virt/kvm/kvm_main.c                                |   8 +-
 58 files changed, 1409 insertions(+), 387 deletions(-)
 create mode 100644 arch/arm64/kvm/check-res-bits.h

--- 
diff --cc arch/arm64/include/asm/cpu.h
index 6c13fd47e170,96379be913cd..9b73fd0cd721
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@@ -56,11 -57,12 +57,13 @@@ struct cpuinfo_arm64 
  	u64		reg_id_aa64mmfr1;
  	u64		reg_id_aa64mmfr2;
  	u64		reg_id_aa64mmfr3;
 +	u64		reg_id_aa64mmfr4;
  	u64		reg_id_aa64pfr0;
  	u64		reg_id_aa64pfr1;
+ 	u64		reg_id_aa64pfr2;
  	u64		reg_id_aa64zfr0;
  	u64		reg_id_aa64smfr0;
+ 	u64		reg_id_aa64fpfr0;
  
  	struct cpuinfo_32bit	aarch32;
  };
diff --cc arch/arm64/include/asm/kvm_arm.h
index a1769e415d72,7f45ce9170bb..e01bb5ca13b7
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@@ -102,8 -102,10 +102,8 @@@
  #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
  #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
  
 -#define HCRX_GUEST_FLAGS \
 -	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
 -	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
 +#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
- #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
+ #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En | HCRX_EL2_EnFPM)
  
  /* TCR_EL2 Registers bits */
  #define TCR_EL2_DS		(1UL << 32)
diff --cc arch/arm64/kernel/cpufeature.c
index f309fd542c20,d6679d8b737e..432d8ee5857c
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@@ -752,14 -754,16 +789,17 @@@ static const struct __ftr_reg_entry 
  			       &id_aa64isar1_override),
  	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64ISAR2_EL1, ftr_id_aa64isar2,
  			       &id_aa64isar2_override),
+ 	ARM64_FTR_REG(SYS_ID_AA64ISAR3_EL1, ftr_id_aa64isar3),
  
  	/* Op1 = 0, CRn = 0, CRm = 7 */
- 	ARM64_FTR_REG(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0),
+ 	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR0_EL1, ftr_id_aa64mmfr0,
+ 			       &id_aa64mmfr0_override),
  	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR1_EL1, ftr_id_aa64mmfr1,
  			       &id_aa64mmfr1_override),
- 	ARM64_FTR_REG(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2),
+ 	ARM64_FTR_REG_OVERRIDE(SYS_ID_AA64MMFR2_EL1, ftr_id_aa64mmfr2,
+ 			       &id_aa64mmfr2_override),
  	ARM64_FTR_REG(SYS_ID_AA64MMFR3_EL1, ftr_id_aa64mmfr3),
 +	ARM64_FTR_REG(SYS_ID_AA64MMFR4_EL1, ftr_id_aa64mmfr4),
  
  	/* Op1 = 1, CRn = 0, CRm = 0 */
  	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
@@@ -1084,11 -1088,12 +1125,13 @@@ void __init init_cpu_features(struct cp
  	init_cpu_ftr_reg(SYS_ID_AA64MMFR1_EL1, info->reg_id_aa64mmfr1);
  	init_cpu_ftr_reg(SYS_ID_AA64MMFR2_EL1, info->reg_id_aa64mmfr2);
  	init_cpu_ftr_reg(SYS_ID_AA64MMFR3_EL1, info->reg_id_aa64mmfr3);
 +	init_cpu_ftr_reg(SYS_ID_AA64MMFR4_EL1, info->reg_id_aa64mmfr4);
  	init_cpu_ftr_reg(SYS_ID_AA64PFR0_EL1, info->reg_id_aa64pfr0);
  	init_cpu_ftr_reg(SYS_ID_AA64PFR1_EL1, info->reg_id_aa64pfr1);
+ 	init_cpu_ftr_reg(SYS_ID_AA64PFR2_EL1, info->reg_id_aa64pfr2);
  	init_cpu_ftr_reg(SYS_ID_AA64ZFR0_EL1, info->reg_id_aa64zfr0);
  	init_cpu_ftr_reg(SYS_ID_AA64SMFR0_EL1, info->reg_id_aa64smfr0);
+ 	init_cpu_ftr_reg(SYS_ID_AA64FPFR0_EL1, info->reg_id_aa64fpfr0);
  
  	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
  		init_32bit_cpu_features(&info->aarch32);
@@@ -2817,13 -2750,32 +2828,39 @@@ static const struct arm64_cpu_capabilit
  		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
  		.matches = has_lpa2,
  	},
 +	{
 +		.desc = "NV1",
 +		.capability = ARM64_HAS_HCR_NV1,
 +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 +		.matches = has_nv1,
 +		ARM64_CPUID_FIELDS_NEG(ID_AA64MMFR4_EL1, E2H0, NI_NV1)
 +	},
+ 	{
+ 		.desc = "FPMR",
+ 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+ 		.capability = ARM64_HAS_FPMR,
+ 		.matches = has_cpuid_feature,
+ 		.cpu_enable = cpu_enable_fpmr,
+ 		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, FPMR, IMP)
+ 	},
+ #ifdef CONFIG_ARM64_VA_BITS_52
+ 	{
+ 		.capability = ARM64_HAS_VA52,
+ 		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+ 		.matches = has_cpuid_feature,
+ #ifdef CONFIG_ARM64_64K_PAGES
+ 		.desc = "52-bit Virtual Addressing (LVA)",
+ 		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, VARange, 52)
+ #else
+ 		.desc = "52-bit Virtual Addressing (LPA2)",
+ #ifdef CONFIG_ARM64_4K_PAGES
+ 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, TGRAN4, 52_BIT)
+ #else
+ 		ARM64_CPUID_FIELDS(ID_AA64MMFR0_EL1, TGRAN16, 52_BIT)
+ #endif
+ #endif
+ 	},
+ #endif
  	{},
  };
  
diff --cc arch/arm64/kernel/cpuinfo.c
index 7ca3fbd200f0,f0abb150f73e..09eeaa24d456
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@@ -447,11 -463,12 +463,13 @@@ static void __cpuinfo_store_cpu(struct 
  	info->reg_id_aa64mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
  	info->reg_id_aa64mmfr2 = read_cpuid(ID_AA64MMFR2_EL1);
  	info->reg_id_aa64mmfr3 = read_cpuid(ID_AA64MMFR3_EL1);
 +	info->reg_id_aa64mmfr4 = read_cpuid(ID_AA64MMFR4_EL1);
  	info->reg_id_aa64pfr0 = read_cpuid(ID_AA64PFR0_EL1);
  	info->reg_id_aa64pfr1 = read_cpuid(ID_AA64PFR1_EL1);
+ 	info->reg_id_aa64pfr2 = read_cpuid(ID_AA64PFR2_EL1);
  	info->reg_id_aa64zfr0 = read_cpuid(ID_AA64ZFR0_EL1);
  	info->reg_id_aa64smfr0 = read_cpuid(ID_AA64SMFR0_EL1);
+ 	info->reg_id_aa64fpfr0 = read_cpuid(ID_AA64FPFR0_EL1);
  
  	if (id_aa64pfr1_mte(info->reg_id_aa64pfr1))
  		info->reg_gmid = read_cpuid(GMID_EL1);

