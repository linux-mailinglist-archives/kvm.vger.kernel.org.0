Return-Path: <kvm+bounces-5720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7820B8252A0
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 12:18:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20C9E285CBC
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 11:18:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275EA28DDD;
	Fri,  5 Jan 2024 11:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJ6oajpH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B93328DAF;
	Fri,  5 Jan 2024 11:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55B1C433C8;
	Fri,  5 Jan 2024 11:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704453499;
	bh=V0v1al0Rcxb0f9SA9OgTnWO94T+jO6COtEJeUGcl9NE=;
	h=From:To:Cc:Subject:Date:From;
	b=bJ6oajpHBIdWEE/16npgE9pE8KHqEOjoG55xUyBaeBSEa2QBhWwz3caivhxc2+CgX
	 Z2ogvc8n1WzAwKjYnpiQ1XvgEaMb6ZvDaQ/jAxBJsHpsfj38+Tuaxe3oz1Q3QMsF2r
	 gXEDa1pgK4pksKyU3klcDeM9YXUG9l3LzwB+LjDkf6DQwR9s2zbJp/8ceas0kphTZW
	 HeKvD8bTevFRovyH8qQwGpyk2FnCELYXSC1gbsHh4D5tTfm5E/f39hRuUNImsKc53o
	 PpyIbiiZCvkKvL11EbbvtfiJGm3rl3tsOOcqy0OCf+cLWDNyyvYrV5VVLGFEOHzRxL
	 sOCrHvxd+cr1w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rLiDQ-0095Tv-UP;
	Fri, 05 Jan 2024 11:18:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Will Deacon <will@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] KVM/arm64 updates for 6.8
Date: Fri,  5 Jan 2024 11:17:56 +0000
Message-Id: <20240105111756.930029-1-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, anshuman.khandual@arm.com, ardb@kernel.org, catalin.marinas@arm.com, tabba@google.com, gankulkarni@os.amperecomputing.com, joey.gouly@arm.com, jiangkunkun@huawei.com, broonie@kernel.org, mark.rutland@arm.com, oliver.upton@linux.dev, qperret@google.com, rmk+kernel@armlinux.org.uk, ryan.roberts@arm.com, will@kernel.org, yuzenghui@huawei.com, james.morse@arm.com, suzuki.poulose@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Hi Paolo,

Here's the set of KVM/arm64 updates for 6.8. The highlight this time
around is the LPA2 work by Ryan, bringing 52bit IPA/PA support to 4k
and 16k page sizes. Also of note is an extensive FGT rework by Fuad
and another set of NV patches, mostly focusing on supporting NV2.

The rest is a small set of fixes, mostly addressing vgic issues.

Note that this PR contains a branch shared with the arm64 tree (sysreg
definition updates), and that the LPA2 series is also shared with
arm64 to resolve some conflicts.

Please pull,

	M.

The following changes since commit 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab:

  Linux 6.7-rc3 (2023-11-26 19:59:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-6.8

for you to fetch changes up to 040113fa32f27096f531c377001936e0d7964597:

  KVM: arm64: Add missing memory barriers when switching to pKVM's hyp pgd (2024-01-04 19:33:00 +0000)

----------------------------------------------------------------
KVM/arm64 updates for Linux 6.8

- LPA2 support, adding 52bit IPA/PA capability for 4kB and 16kB
  base granule sizes. Branch shared with the arm64 tree.

- Large Fine-Grained Trap rework, bringing some sanity to the
  feature, although there is more to come. This comes with
  a prefix branch shared with the arm64 tree.

- Some additional Nested Virtualization groundwork, mostly
  introducing the NV2 VNCR support and retargetting the NV
  support to that version of the architecture.

- A small set of vgic fixes and associated cleanups.

----------------------------------------------------------------
Anshuman Khandual (1):
      arm64/mm: Add FEAT_LPA2 specific ID_AA64MMFR0.TGRAN[2]

Ard Biesheuvel (1):
      KVM: arm64: Use helpers to classify exception types reported via ESR

Fuad Tabba (19):
      arm64/sysreg: Update HFGITR_EL2 definiton to DDI0601 2023-09
      arm64/sysreg: Add definition for HAFGRTR_EL2
      arm64/sysreg: Add missing Pauth_LR field definitions to ID_AA64ISAR1_EL1
      arm64/sysreg: Add missing ExtTrcBuff field definition to ID_AA64DFR0_EL1
      arm64/sysreg: Add missing system register definitions for FGT
      arm64/sysreg: Add missing system instruction definitions for FGT
      KVM: arm64: Explicitly trap unsupported HFGxTR_EL2 features
      KVM: arm64: Add missing HFGxTR_EL2 FGT entries to nested virt
      KVM: arm64: Add missing HFGITR_EL2 FGT entries to nested virt
      KVM: arm64: Add bit masks for HAFGRTR_EL2
      KVM: arm64: Handle HAFGRTR_EL2 trapping in nested virt
      KVM: arm64: Update and fix FGT register masks
      KVM: arm64: Add build validation for FGT trap mask values
      KVM: arm64: Use generated FGT RES0 bits instead of specifying them
      KVM: arm64: Define FGT nMASK bits relative to other fields
      KVM: arm64: Macros for setting/clearing FGT bits
      KVM: arm64: Fix which features are marked as allowed for protected VMs
      KVM: arm64: Mark PAuth as a restricted feature for protected VMs
      KVM: arm64: Trap external trace for protected VMs

Joey Gouly (2):
      arm64/sysreg: add system register POR_EL{0,1}
      arm64/sysreg: update CPACR_EL1 register

Marc Zyngier (16):
      Merge remote-tracking branch 'arm64/for-next/sysregs' into kvm-arm64/fgt-rework
      Merge branch kvm-arm64/lpa2 into kvmarm-master/next
      Merge branch kvm-arm64/fgt-rework into kvmarm-master/next
      arm64: cpufeatures: Restrict NV support to FEAT_NV2
      KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
      KVM: arm64: nv: Compute NV view of idregs as a one-off
      KVM: arm64: nv: Drop EL12 register traps that are redirected to VNCR
      KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
      KVM: arm64: nv: Add include containing the VNCR_EL2 offsets
      KVM: arm64: Introduce a bad_trap() primitive for unexpected trap handling
      KVM: arm64: nv: Add EL2_REG_VNCR()/EL2_REG_REDIR() sysreg helpers
      KVM: arm64: nv: Map VNCR-capable registers to a separate page
      KVM: arm64: nv: Handle virtual EL2 registers in vcpu_read/write_sys_reg()
      Merge branch kvm-arm64/nv-6.8-prefix into kvmarm-master/next
      KVM: arm64: vgic-v4: Restore pending state on host userspace write
      Merge branch kvm-arm64/vgic-6.8 into kvmarm-master/next

Mark Brown (9):
      arm64/sysreg: Add definition for ID_AA64PFR2_EL1
      arm64/sysreg: Update ID_AA64ISAR2_EL1 defintion for DDI0601 2023-09
      arm64/sysreg: Add definition for ID_AA64ISAR3_EL1
      arm64/sysreg: Add definition for ID_AA64FPFR0_EL1
      arm64/sysreg: Update ID_AA64SMFR0_EL1 definition for DDI0601 2023-09
      arm64/sysreg: Update SCTLR_EL1 for DDI0601 2023-09
      arm64/sysreg: Update HCRX_EL2 definition for DDI0601 2023-09
      arm64/sysreg: Add definition for FPMR
      arm64/sysreg: Add new system registers for GCS

Oliver Upton (4):
      KVM: arm64: vgic: Use common accessor for writes to ISPENDR
      KVM: arm64: vgic: Use common accessor for writes to ICPENDR
      KVM: arm64: vgic-v3: Reinterpret user ISPENDR writes as I{C,S}PENDR
      KVM: arm64: vgic-its: Avoid potential UAF in LPI translation cache

Ryan Roberts (11):
      arm64/mm: Modify range-based tlbi to decrement scale
      arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
      arm64/mm: Update tlb invalidation routines for FEAT_LPA2
      arm64: Add ARM64_HAS_LPA2 CPU capability
      KVM: arm64: Add new (V)TCR_EL2 field definitions for FEAT_LPA2
      KVM: arm64: Use LPA2 page-tables for stage2 and hyp stage1
      KVM: arm64: Convert translation level parameter to s8
      KVM: arm64: Support up to 5 levels of translation in kvm_pgtable
      KVM: arm64: Allow guests with >48-bit IPA size on FEAT_LPA2 systems
      KVM: selftests: arm64: Determine max ipa size per-page size
      KVM: selftests: arm64: Support P52V48 4K and 16K guest_modes

Will Deacon (1):
      KVM: arm64: Add missing memory barriers when switching to pKVM's hyp pgd

 arch/arm64/include/asm/cpufeature.h                |   5 +
 arch/arm64/include/asm/esr.h                       |  15 +
 arch/arm64/include/asm/kvm_arm.h                   |  63 ++--
 arch/arm64/include/asm/kvm_emulate.h               |  34 +--
 arch/arm64/include/asm/kvm_host.h                  | 138 ++++++---
 arch/arm64/include/asm/kvm_nested.h                |  56 +++-
 arch/arm64/include/asm/kvm_pgtable.h               |  80 ++++--
 arch/arm64/include/asm/kvm_pkvm.h                  |   5 +-
 arch/arm64/include/asm/pgtable-prot.h              |   2 +
 arch/arm64/include/asm/sysreg.h                    |  25 ++
 arch/arm64/include/asm/tlb.h                       |  15 +-
 arch/arm64/include/asm/tlbflush.h                  | 100 ++++---
 arch/arm64/include/asm/vncr_mapping.h              | 103 +++++++
 arch/arm64/kernel/cpufeature.c                     |  41 ++-
 arch/arm64/kvm/arch_timer.c                        |   3 +-
 arch/arm64/kvm/arm.c                               |  11 +
 arch/arm64/kvm/emulate-nested.c                    |  63 ++++
 arch/arm64/kvm/hyp/include/hyp/fault.h             |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  93 ++++--
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |  22 +-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   6 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   6 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   4 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   4 +
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   2 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  90 +++---
 arch/arm64/kvm/mmu.c                               |  49 ++--
 arch/arm64/kvm/nested.c                            |  22 +-
 arch/arm64/kvm/reset.c                             |   9 +-
 arch/arm64/kvm/sys_regs.c                          | 235 +++++++++++----
 arch/arm64/kvm/vgic/vgic-its.c                     |   5 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  28 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    | 101 +++----
 arch/arm64/tools/cpucaps                           |   1 +
 arch/arm64/tools/sysreg                            | 320 ++++++++++++++++++++-
 .../selftests/kvm/include/aarch64/processor.h      |   4 +-
 tools/testing/selftests/kvm/include/guest_modes.h  |   4 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |   1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |  69 ++++-
 tools/testing/selftests/kvm/lib/guest_modes.c      |  50 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c         |   3 +
 41 files changed, 1423 insertions(+), 466 deletions(-)
 create mode 100644 arch/arm64/include/asm/vncr_mapping.h

