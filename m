Return-Path: <kvm+bounces-41538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58330A69F0C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 05:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 077D28A68F9
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 04:29:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEAD11EB1BA;
	Thu, 20 Mar 2025 04:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aaevQ3nI"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7545D1B87F0
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 04:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742444984; cv=none; b=IEgYXx3tbuSq7O2XWrqt304GdP/9ufDdEf0c6fzzR+QesS9d+T/IeT6RN1TNzR4vEFETZsjhbci1zkMoPSIFduukwoFdxtHGdvlNkAL9zVNSnuTEkaPXO4HhZZKe0/Gb3LKrFev8iGmwejeTbN2GImFjlcObI/j1uzNrXvVkCso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742444984; c=relaxed/simple;
	bh=n09s+HLDJ+ua9v9b0DEeJXaKA5HeZvG8zu53EHpp/TY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QpIB+h7CRN0iJ2wuMA59KjAhfbTNUJFUGjljiixa1pLFIAYNDk9Ypi4ThnihfliubAumCZH3wk7+W+6gOgwyhWOyKJBhU79jeJsAI7rpVDOycyH02L+t+gwzJFoKhNdr7pTM05k3toiCcTK0f75KnEPlbpvk1ohe+WgqNLQ07Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aaevQ3nI; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 19 Mar 2025 21:29:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742444978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wYfZkkm9jHOgHlHhpUbP6jjEn8Q4xaPj7vdaTDqsQdo=;
	b=aaevQ3nIXBVBcnpN8k9jyepicA8JLr6CRa0emvNW+gyewVjkKfI+wYhkgCkIv+2OV/oVP3
	UDfcJtRo8jY2JWyxhYE2wpVtr9ZjoZYjIeTjedniwubfuABo0CWrcN+1dZD62+E6Z5giHz
	W5HzZU3Y/N1mu2mJj+w20LdvxnkTt3I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, Akihiko Odaki <akihiko.odaki@daynix.com>,
	Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sebastian Ott <sebott@redhat.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Fuad Tabba <tabba@google.com>
Subject: [GIT PULL] KVM/arm64 updates for 6.15
Message-ID: <Z9uZpZKfqWP8ZwH8@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Paolo,

Here's the latest pile o' patches for 6.15. The pull is based on a later
-rc than I usually aim for to handle some conflicts with fixes that went
in 6.14, but all of these patches have had exposure in -next for a good
while.

There was a small conflict with the arm perf tree, which was addressed
by Will pulling a prefix of the M1 PMU branch:

  https://lore.kernel.org/linux-next/20250312201853.0d75d9fe@canb.auug.org.au/

Please pull.

 - Oliver

The following changes since commit 80e54e84911a923c40d7bee33a34c1b4be148d7a:

  Linux 6.14-rc6 (2025-03-09 13:45:25 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags/kvmarm-6.15

for you to fetch changes up to 369c0122682c4468a69f2454614eded71c5348f3:

  Merge branch 'kvm-arm64/pmu-fixes' into kvmarm/next (2025-03-19 14:54:52 -0700)

----------------------------------------------------------------
KVM/arm64 updates for 6.15

 - Nested virtualization support for VGICv3, giving the nested
   hypervisor control of the VGIC hardware when running an L2 VM

 - Removal of 'late' nested virtualization feature register masking,
   making the supported feature set directly visible to userspace

 - Support for emulating FEAT_PMUv3 on Apple silicon, taking advantage
   of an IMPLEMENTATION DEFINED trap that covers all PMUv3 registers

 - Paravirtual interface for discovering the set of CPU implementations
   where a VM may run, addressing a longstanding issue of guest CPU
   errata awareness in big-little systems and cross-implementation VM
   migration

 - Userspace control of the registers responsible for identifying a
   particular CPU implementation (MIDR_EL1, REVIDR_EL1, AIDR_EL1),
   allowing VMs to be migrated cross-implementation

 - pKVM updates, including support for tracking stage-2 page table
   allocations in the protected hypervisor in the 'SecPageTable' stat

 - Fixes to vPMU, ensuring that userspace updates to the vPMU after
   KVM_RUN are reflected into the backing perf events

----------------------------------------------------------------
Akihiko Odaki (5):
      KVM: arm64: PMU: Set raw values from user to PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
      KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
      KVM: arm64: PMU: Reload when user modifies registers
      KVM: arm64: PMU: Reload when resetting

Andre Przywara (1):
      KVM: arm64: nv: Allow userland to set VGIC maintenance IRQ

Fuad Tabba (4):
      KVM: arm64: Factor out setting HCRX_EL2 traps into separate function
      KVM: arm64: Initialize HCRX_EL2 traps in pKVM
      KVM: arm64: Factor out pKVM hyp vcpu creation to separate function
      KVM: arm64: Create each pKVM hyp vcpu after its corresponding host vcpu

Jintack Lim (1):
      KVM: arm64: nv: Respect virtual HCR_EL2.TWx setting

Marc Zyngier (25):
      arm64: cpufeature: Handle NV_frac as a synonym of NV2
      KVM: arm64: Hide ID_AA64MMFR2_EL1.NV from guest and userspace
      KVM: arm64: Mark HCR.EL2.E2H RES0 when ID_AA64MMFR1_EL1.VH is zero
      KVM: arm64: Mark HCR.EL2.{NV*,AT} RES0 when ID_AA64MMFR4_EL1.NV_frac is 0
      KVM: arm64: Advertise NV2 in the boot messages
      KVM: arm64: Consolidate idreg callbacks
      KVM: arm64: Make ID_REG_LIMIT_FIELD_ENUM() more widely available
      KVM: arm64: Enforce NV limits on a per-idregs basis
      KVM: arm64: Move NV-specific capping to idreg sanitisation
      KVM: arm64: Allow userspace to limit NV support to nVHE
      KVM: arm64: Make ID_AA64MMFR4_EL1.NV_frac writable
      KVM: arm64: Advertise FEAT_ECV when possible
      arm64: sysreg: Add layout for ICH_HCR_EL2
      arm64: sysreg: Add layout for ICH_VTR_EL2
      arm64: sysreg: Add layout for ICH_MISR_EL2
      KVM: arm64: nv: Load timer before the GIC
      KVM: arm64: nv: Add ICH_*_EL2 registers to vpcu_sysreg
      KVM: arm64: nv: Plumb handling of GICv3 EL2 accesses
      KVM: arm64: nv: Sanitise ICH_HCR_EL2 accesses
      KVM: arm64: nv: Nested GICv3 emulation
      KVM: arm64: nv: Handle L2->L1 transition on interrupt injection
      KVM: arm64: nv: Add Maintenance Interrupt emulation
      KVM: arm64: nv: Propagate used_lrs between L1 and L0 contexts
      KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
      KVM: arm64: nv: Fail KVM init if asking for NV without GICv3

Oliver Upton (32):
      KVM: arm64: Set HCR_EL2.TID1 unconditionally
      KVM: arm64: Load VPIDR_EL2 with the VM's MIDR_EL1 value
      KVM: arm64: vgic-v4: Only attempt vLPI mapping for actual MSIs
      KVM: arm64: vgic-v4: Only WARN for HW IRQ mismatch when unmapping vLPI
      KVM: arm64: vgic-v4: Fall back to software irqbypass if LPI not found
      KVM: arm64: Document ordering requirements for irqbypass
      KVM: arm64: nv: Request vPE doorbell upon nested ERET to L2
      KVM: arm64: Copy guest CTR_EL0 into hyp VM
      KVM: arm64: Copy MIDR_EL1 into hyp VM when it is writable
      KVM: arm64: Fix documentation for KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
      drivers/perf: apple_m1: Refactor event select/filter configuration
      drivers/perf: apple_m1: Support host/guest event filtering
      KVM: arm64: Compute PMCEID from arm_pmu's event bitmaps
      KVM: arm64: Always support SW_INCR PMU event
      KVM: arm64: Use a cpucap to determine if system supports FEAT_PMUv3
      KVM: arm64: Drop kvm_arm_pmu_available static key
      KVM: arm64: Use guard() to cleanup usage of arm_pmus_lock
      KVM: arm64: Move PMUVer filtering into KVM code
      KVM: arm64: Compute synthetic sysreg ESR for Apple PMUv3 traps
      KVM: arm64: Advertise PMUv3 if IMPDEF traps are present
      KVM: arm64: Remap PMUv3 events onto hardware
      drivers/perf: apple_m1: Provide helper for mapping PMUv3 events
      KVM: arm64: Provide 1 event counter on IMPDEF hardware
      arm64: Enable IMP DEF PMUv3 traps on Apple M*
      Merge branch 'kvm-arm64/misc' into kvmarm/next
      Merge branch 'kvm-arm64/nv-vgic' into kvmarm/next
      Merge branch 'kvm-arm64/nv-idregs' into kvmarm/next
      Merge branch 'kvm-arm64/pv-cpuid' into kvmarm/next
      Merge branch 'kvm-arm64/pmuv3-asahi' into kvmarm/next
      Merge branch 'kvm-arm64/writable-midr' into kvmarm/next
      Merge branch 'kvm-arm64/pkvm-6.15' into kvmarm/next
      Merge branch 'kvm-arm64/pmu-fixes' into kvmarm/next

Sebastian Ott (5):
      KVM: arm64: Maintain per-VM copy of implementation ID regs
      KVM: arm64: Allow userspace to change the implementation ID registers
      KVM: selftests: arm64: Test writes to MIDR,REVIDR,AIDR
      KVM: arm64: Allow userspace to write ID_AA64MMFR0_EL1.TGRAN*_2
      KVM: arm64: selftests: Test that TGRAN*_2 fields are writable

Shameer Kolothum (7):
      arm64: Modify _midr_range() functions to read MIDR/REVIDR internally
      KVM: arm64: Specify hypercall ABI for retrieving target implementations
      KVM: arm64: Introduce KVM_REG_ARM_VENDOR_HYP_BMAP_2
      arm64: Make  _midr_in_range_list() an exported function
      smccc/kvm_guest: Enable errata based on implementation CPUs
      KVM: selftests: Add test for KVM_REG_ARM_VENDOR_HYP_BMAP_2
      smccc: kvm_guest: Fix kernel builds for 32 bit arm

Vincent Donnefort (3):
      KVM: arm64: Add flags to kvm_hyp_memcache
      KVM: arm64: Distinct pKVM teardown memcache for stage-2
      KVM: arm64: Count pKVM stage-2 usage in secondary pagetable stats

Will Deacon (1):
      KVM: arm64: Tear down vGIC on failed vCPU creation

 Documentation/virt/kvm/api.rst                     |  18 +
 Documentation/virt/kvm/arm/fw-pseudo-registers.rst |  15 +-
 Documentation/virt/kvm/arm/hypercalls.rst          |  59 +++
 Documentation/virt/kvm/devices/arm-vgic-its.rst    |   5 +-
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |  12 +-
 arch/arm64/include/asm/apple_m1_pmu.h              |   1 +
 arch/arm64/include/asm/cpucaps.h                   |   2 +
 arch/arm64/include/asm/cpufeature.h                |  28 +-
 arch/arm64/include/asm/cputype.h                   |  40 +-
 arch/arm64/include/asm/hypervisor.h                |   1 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |  37 ++
 arch/arm64/include/asm/kvm_host.h                  |  65 ++-
 arch/arm64/include/asm/kvm_hyp.h                   |   2 +
 arch/arm64/include/asm/kvm_nested.h                |   1 +
 arch/arm64/include/asm/kvm_pkvm.h                  |   1 +
 arch/arm64/include/asm/mmu.h                       |   3 +-
 arch/arm64/include/asm/sysreg.h                    |  30 --
 arch/arm64/include/uapi/asm/kvm.h                  |  14 +
 arch/arm64/kernel/cpu_errata.c                     | 117 ++++-
 arch/arm64/kernel/cpufeature.c                     |  53 ++-
 arch/arm64/kernel/image-vars.h                     |   6 +-
 arch/arm64/kernel/proton-pack.c                    |  17 +-
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arm.c                               |  76 +++-
 arch/arm64/kvm/emulate-nested.c                    |  24 +-
 arch/arm64/kvm/handle_exit.c                       |   6 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   4 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h         |  14 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   6 -
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   2 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  79 ++--
 arch/arm64/kvm/hyp/nvhe/sysreg-sr.c                |   4 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c                    |  16 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  22 +
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  28 +-
 arch/arm64/kvm/hypercalls.c                        |  13 +
 arch/arm64/kvm/mmu.c                               |  22 +-
 arch/arm64/kvm/nested.c                            | 298 +++++++------
 arch/arm64/kvm/pkvm.c                              |  75 ++--
 arch/arm64/kvm/pmu-emul.c                          | 194 +++++----
 arch/arm64/kvm/pmu.c                               |  10 +-
 arch/arm64/kvm/reset.c                             |   3 -
 arch/arm64/kvm/sys_regs.c                          | 478 ++++++++++++++-------
 arch/arm64/kvm/sys_regs.h                          |  10 +
 arch/arm64/kvm/vgic-sys-reg-v3.c                   |   8 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |  29 ++
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  29 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c               | 409 ++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-v3.c                      |  46 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |  35 +-
 arch/arm64/kvm/vgic/vgic.c                         |  38 ++
 arch/arm64/kvm/vgic/vgic.h                         |   6 +
 arch/arm64/tools/cpucaps                           |   2 +
 arch/arm64/tools/sysreg                            |  48 +++
 drivers/clocksource/arm_arch_timer.c               |   2 +-
 drivers/firmware/smccc/kvm_guest.c                 |  66 +++
 drivers/hwtracing/coresight/coresight-etm4x-core.c |   2 +-
 drivers/irqchip/irq-apple-aic.c                    |   8 +-
 drivers/perf/apple_m1_cpu_pmu.c                    | 101 ++++-
 include/kvm/arm_pmu.h                              |  17 +-
 include/kvm/arm_vgic.h                             |  10 +
 include/linux/arm-smccc.h                          |  15 +
 include/linux/perf/arm_pmu.h                       |   4 +
 include/uapi/linux/kvm.h                           |   1 +
 tools/arch/arm/include/uapi/asm/kvm.h              |   1 +
 tools/arch/arm64/include/asm/sysreg.h              |  30 --
 tools/arch/arm64/include/uapi/asm/kvm.h            |  12 +
 tools/testing/selftests/kvm/arm64/get-reg-list.c   |   1 +
 tools/testing/selftests/kvm/arm64/hypercalls.c     |  46 +-
 tools/testing/selftests/kvm/arm64/set_id_regs.c    |  40 +-
 72 files changed, 2173 insertions(+), 752 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-v3-nested.c

