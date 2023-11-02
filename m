Return-Path: <kvm+bounces-424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C0CA7DF8BB
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 18:29:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 620C4B2136E
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 17:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E011A2030C;
	Thu,  2 Nov 2023 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cBrj0JT/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57146FAE
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 17:29:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B30F1AA
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 10:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698946162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yWZ3a7xbo4oOq8RweaesJ4FAs7eVLLwEKyJ4EIKA/pQ=;
	b=cBrj0JT/hU49/utn0MyQPD9eGti73XLS9JxwYeG4TXCLJ8Fi47cqJw43PAB2Gy2itZ6ZM/
	93GNJvc1Z9xQWoU835tJxMeHAxaz0LlNJqBMNe84OKvvKx+PncGKbF86gPPGCCD1iy0WK2
	a3VarA1QM/gMOw261YbL3VP5KE/O33Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-f0kb0POfN16AH0NtHIwYgg-1; Thu, 02 Nov 2023 13:29:18 -0400
X-MC-Unique: f0kb0POfN16AH0NtHIwYgg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86B97814084;
	Thu,  2 Nov 2023 17:29:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F2022026D4C;
	Thu,  2 Nov 2023 17:29:18 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 6.7 merge window
Date: Thu,  2 Nov 2023 13:29:17 -0400
Message-Id: <20231102172917.142863-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Linus,

The following changes since commit ffc253263a1375a65fa6c9f62a893e9767fbebfa:

  Linux 6.6 (2023-10-29 16:31:08 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 45b890f7689eb0aba454fc5831d2d79763781677:

  Merge tag 'kvmarm-6.7' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD (2023-10-31 16:37:07 -0400)

The new architecture and selftests make up the bulk of the diffstat,
but there are also some relevant ARM and x86 changes.  I expect 6.8
to be much bigger though.

There is a small conflict in arch/arm64/kvm/arm.c whose resolution is
simply to remove the =====...>>>>> part.  The usual combined diff is
not any more helpful than this, but I put it anyway after my signature.

Likewise you may have a conflict with the risc-v tree on
arch/riscv/include/asm/csr.h, depending on which you pull first, where
the KVM version is the good one:

  #define CSR_SIE			0x104
  #define CSR_STVEC		0x105
  #define CSR_SCOUNTEREN		0x106
++#define CSR_SENVCFG		0x10a
 +#define CSR_SSTATEEN0		0x10c
  #define CSR_SSCRATCH		0x140
  #define CSR_SEPC		0x141
  #define CSR_SCAUSE		0x142

Paolo

----------------------------------------------------------------
ARM:

* Generalized infrastructure for 'writable' ID registers, effectively
  allowing userspace to opt-out of certain vCPU features for its guest

* Optimization for vSGI injection, opportunistically compressing MPIDR
  to vCPU mapping into a table

* Improvements to KVM's PMU emulation, allowing userspace to select
  the number of PMCs available to a VM

* Guest support for memory operation instructions (FEAT_MOPS)

* Cleanups to handling feature flags in KVM_ARM_VCPU_INIT, squashing
  bugs and getting rid of useless code

* Changes to the way the SMCCC filter is constructed, avoiding wasted
  memory allocations when not in use

* Load the stage-2 MMU context at vcpu_load() for VHE systems, reducing
  the overhead of errata mitigations

* Miscellaneous kernel and selftest fixes

LoongArch:

* New architecture.  The hardware uses the same model as x86, s390
  and RISC-V, where guest/host mode is orthogonal to supervisor/user
  mode.  The virtualization extensions are very similar to MIPS,
  therefore the code also has some similarities but it's been cleaned
  up to avoid some of the historical bogosities that are found in
  arch/mips.  The kernel emulates MMU, timer and CSR accesses, while
  interrupt controllers are only emulated in userspace, at least for
  now.

RISC-V:

* Support for the Smstateen and Zicond extensions

* Support for virtualizing senvcfg

* Support for virtualized SBI debug console (DBCN)

S390:

* Nested page table management can be monitored through tracepoints
  and statistics

x86:

* Fix incorrect handling of VMX posted interrupt descriptor in KVM_SET_LAPIC,
  which could result in a dropped timer IRQ

* Avoid WARN on systems with Intel IPI virtualization

* Add CONFIG_KVM_MAX_NR_VCPUS, to allow supporting up to 4096 vCPUs without
  forcing more common use cases to eat the extra memory overhead.

* Add virtualization support for AMD SRSO mitigation (IBPB_BRTYPE and
  SBPB, aka Selective Branch Predictor Barrier).

* Fix a bug where restoring a vCPU snapshot that was taken within 1 second of
  creating the original vCPU would cause KVM to try to synchronize the vCPU's
  TSC and thus clobber the correct TSC being set by userspace.

* Compute guest wall clock using a single TSC read to avoid generating an
  inaccurate time, e.g. if the vCPU is preempted between multiple TSC reads.

* "Virtualize" HWCR.TscFreqSel to make Linux guests happy, which complain
  about a "Firmware Bug" if the bit isn't set for select F/M/S combos.
  Likewise "virtualize" (ignore) MSR_AMD64_TW_CFG to appease Windows Server
  2022.

* Don't apply side effects to Hyper-V's synthetic timer on writes from
  userspace to fix an issue where the auto-enable behavior can trigger
  spurious interrupts, i.e. do auto-enabling only for guest writes.

* Remove an unnecessary kick of all vCPUs when synchronizing the dirty log
  without PML enabled.

* Advertise "support" for non-serializing FS/GS base MSR writes as appropriate.

* Harden the fast page fault path to guard against encountering an invalid
  root when walking SPTEs.

* Omit "struct kvm_vcpu_xen" entirely when CONFIG_KVM_XEN=n.

* Use the fast path directly from the timer callback when delivering Xen
  timer events, instead of waiting for the next iteration of the run loop.
  This was not done so far because previously proposed code had races,
  but now care is taken to stop the hrtimer at critical points such as
  restarting the timer or saving the timer information for userspace.

* Follow the lead of upstream Xen and ignore the VCPU_SSHOTTMR_future flag.

* Optimize injection of PMU interrupts that are simultaneous with NMIs.

* Usual handful of fixes for typos and other warts.

x86 - MTRR/PAT fixes and optimizations:

* Clean up code that deals with honoring guest MTRRs when the VM has
  non-coherent DMA and host MTRRs are ignored, i.e. EPT is enabled.

* Zap EPT entries when non-coherent DMA assignment stops/start to prevent
  using stale entries with the wrong memtype.

* Don't ignore guest PAT for CR0.CD=1 && KVM_X86_QUIRK_CD_NW_CLEARED=y.
  This was done as a workaround for virtual machine BIOSes that did not
  bother to clear CR0.CD (because ancient KVM/QEMU did not bother to
  set it, in turn), and there's zero reason to extend the quirk to
  also ignore guest PAT.

x86 - SEV fixes:

* Report KVM_EXIT_SHUTDOWN instead of EINVAL if KVM intercepts SHUTDOWN while
  running an SEV-ES guest.

* Clean up the recognition of emulation failures on SEV guests, when KVM would
  like to "skip" the instruction but it had already been partially emulated.
  This makes it possible to drop a hack that second guessed the (insufficient)
  information provided by the emulator, and just do the right thing.

Documentation:

* Various updates and fixes, mostly for x86

* MTRR and PAT fixes and optimizations:

----------------------------------------------------------------
Andrew Jones (3):
      MAINTAINERS: RISC-V: KVM: Add another kselftests path
      KVM: selftests: Add array order helpers to riscv get-reg-list
      KVM: riscv: selftests: get-reg-list print_reg should never fail

Anup Patel (11):
      RISC-V: Detect Zicond from ISA string
      dt-bindings: riscv: Add Zicond extension entry
      RISC-V: KVM: Allow Zicond extension for Guest/VM
      KVM: riscv: selftests: Add senvcfg register to get-reg-list test
      KVM: riscv: selftests: Add smstateen registers to get-reg-list test
      KVM: riscv: selftests: Add condops extensions to get-reg-list test
      RISC-V: Add defines for SBI debug console extension
      RISC-V: KVM: Change the SBI specification version to v2.0
      RISC-V: KVM: Allow some SBI extensions to be disabled by default
      RISC-V: KVM: Forward SBI DBCN extension to user-space
      KVM: riscv: selftests: Add SBI DBCN extension to get-reg-list test

David Matlack (1):
      KVM: x86/mmu: Stop kicking vCPUs to sync the dirty log when PML is disabled

David Woodhouse (2):
      KVM: x86/xen: Use fast path for Xen timer delivery
      KVM: x86: Refine calculation of guest wall clock to use a single TSC read

Dongli Zhang (1):
      KVM: x86: remove always-false condition in kvmclock_sync_fn

Haitao Shan (1):
      KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.

Jim Mattson (4):
      KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
      KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
      KVM: selftests: Test behavior of HWCR, a.k.a. MSR_K7_HWCR
      x86: KVM: Add feature flag for CPUID.80000021H:EAX[bit 1]

Jing Zhang (7):
      KVM: arm64: Allow userspace to get the writable masks for feature ID registers
      KVM: arm64: Document KVM_ARM_GET_REG_WRITABLE_MASKS
      KVM: arm64: Use guest ID register values for the sake of emulation
      KVM: arm64: Allow userspace to change ID_AA64MMFR{0-2}_EL1
      KVM: arm64: Allow userspace to change ID_AA64PFR0_EL1
      tools headers arm64: Update sysreg.h with kernel sources
      KVM: arm64: selftests: Test for setting ID register from usersapce

Jinrong Liang (1):
      KVM: x86/pmu: Add documentation for fixed ctr on PMU filter

Josh Poimboeuf (2):
      KVM: x86: Add IBPB_BRTYPE support
      KVM: x86: Add SBPB support

Kristina Martsenko (2):
      KVM: arm64: Add handler for MOPS exceptions
      KVM: arm64: Expose MOPS instructions to guests

Kyle Meyer (1):
      KVM: x86: Add CONFIG_KVM_MAX_NR_VCPUS to allow up to 4096 vCPUs

Li zeming (1):
      KVM: x86/mmu: Remove unnecessary ‘NULL’ values from sptep

Liang Chen (1):
      KVM: x86: remove the unused assigned_dev_head from kvm_arch

Like Xu (1):
      KVM: x86: Don't sync user-written TSC against startup values

Maciej S. Szmigiero (1):
      KVM: x86: Ignore MSR_AMD64_TW_CFG access

Marc Zyngier (16):
      KVM: arm64: vgic: Make kvm_vgic_inject_irq() take a vcpu pointer
      KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
      KVM: arm64: vgic-v3: Refactor GICv3 SGI generation
      KVM: arm64: vgic-v2: Use cpuid from userspace as vcpu_id
      KVM: arm64: vgic: Use vcpu_idx for the debug information
      KVM: arm64: Use vcpu_idx for invalidation tracking
      KVM: arm64: Simplify kvm_vcpu_get_mpidr_aff()
      KVM: arm64: Build MPIDR to vcpu index cache at runtime
      KVM: arm64: Fast-track kvm_mpidr_to_vcpu() when mpidr_data is available
      KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
      KVM: arm64: Clarify the ordering requirements for vcpu/RD creation
      KVM: arm64: Restore the stage-2 context in VHE's __tlb_switch_to_host()
      KVM: arm64: Reload stage-2 for VMID change on VHE
      KVM: arm64: Move VTCR_EL2 into struct s2_mmu
      KVM: arm64: Do not let a L1 hypervisor access the *32_EL2 sysregs
      KVM: arm64: Handle AArch32 SPSR_{irq,abt,und,fiq} as RAZ/WI

Mayuresh Chitale (7):
      RISC-V: Detect Smstateen extension
      dt-bindings: riscv: Add smstateen entry
      RISC-V: KVM: Add kvm_vcpu_config
      RISC-V: KVM: Enable Smstateen accesses
      RISCV: KVM: Add senvcfg context save/restore
      RISCV: KVM: Add sstateen0 context save/restore
      RISCV: KVM: Add sstateen0 to ONE_REG

Michal Luczaj (3):
      KVM: x86: Remove redundant vcpu->arch.cr0 assignments
      KVM: x86: Force TLB flush on userspace changes to special registers
      KVM: Correct kvm_vcpu_event(s) typo in KVM API documentation

Miguel Luis (3):
      arm64: Add missing _EL12 encodings
      arm64: Add missing _EL2 encodings
      KVM: arm64: Refine _EL2 system register list that require trap reinjection

Mingwei Zhang (8):
      KVM: Documentation: Add the missing description for guest_mode in kvm_mmu_page_role
      KVM: Documentation: Update the field name gfns and its description in kvm_mmu_page
      KVM: Documentation: Add the missing description for ptep in kvm_mmu_page
      KVM: Documentation: Add the missing description for tdp_mmu_root_count into kvm_mmu_page
      KVM: Documentation: Add the missing description for mmu_valid_gen into kvm_mmu_page
      KVM: Documentation: Add the missing description for tdp_mmu_page into kvm_mmu_page
      KVM: x86: Update the variable naming in kvm_x86_ops.sched_in()
      KVM: x86: Service NMI requests after PMI requests in VM-Enter path

Nico Boehr (2):
      KVM: s390: add stat counter for shadow gmap events
      KVM: s390: add tracepoint in gmap notifier

Nicolas Saenz Julienne (1):
      KVM: x86: hyper-v: Don't auto-enable stimer on write from user-space

Oliver Upton (42):
      KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
      KVM: arm64: Add generic check for system-supported vCPU features
      KVM: arm64: Hoist PMUv3 check into KVM_ARM_VCPU_INIT ioctl handler
      KVM: arm64: Hoist SVE check into KVM_ARM_VCPU_INIT ioctl handler
      KVM: arm64: Hoist PAuth checks into KVM_ARM_VCPU_INIT ioctl
      KVM: arm64: Prevent NV feature flag on systems w/o nested virt
      KVM: arm64: Hoist NV+SVE check into KVM_ARM_VCPU_INIT ioctl handler
      KVM: arm64: Remove unused return value from kvm_reset_vcpu()
      KVM: arm64: Get rid of vCPU-scoped feature bitmap
      arm64: tlbflush: Rename MAX_TLBI_OPS
      KVM: arm64: Avoid soft lockups due to I-cache maintenance
      KVM: arm64: Advertise selected DebugVer in DBGDIDR.Version
      KVM: arm64: Reject attempts to set invalid debug arch version
      KVM: arm64: Bump up the default KVM sanitised debug version to v8p8
      KVM: arm64: Allow userspace to change ID_AA64ISAR{0-2}_EL1
      KVM: arm64: Allow userspace to change ID_AA64ZFR0_EL1
      KVM: arm64: Document vCPU feature selection UAPIs
      KVM: arm64: Add a predicate for testing if SMCCC filter is configured
      KVM: arm64: Only insert reserved ranges when SMCCC filter is used
      KVM: arm64: Use mtree_empty() to determine if SMCCC filter configured
      tools: arm64: Add a Makefile for generating sysreg-defs.h
      perf build: Generate arm64's sysreg-defs.h and add to include path
      KVM: selftests: Generate sysreg-defs.h and add to include path
      KVM: arm64: Don't zero VTTBR in __tlb_switch_to_host()
      KVM: arm64: Rename helpers for VHE vCPU load/put
      KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
      KVM: arm64: Make PMEVTYPER<n>_EL0.NSH RES0 if EL2 isn't advertised
      KVM: arm64: Add PMU event filter bits required if EL3 is implemented
      KVM: arm64: Always invalidate TLB for stage-2 permission faults
      KVM: arm64: Add tracepoint for MMIO accesses where ISV==0
      Merge branch kvm-arm64/misc into kvmarm/next
      Merge branch kvm-arm64/feature-flag-refactor into kvmarm/next
      Merge branch kvm-arm64/pmevtyper-filter into kvmarm/next
      Merge branch kvm-arm64/smccc-filter-cleanups into kvmarm/next
      Merge branch kvm-arm64/nv-trap-fixes into kvmarm/next
      Merge branch kvm-arm64/stage2-vhe-load into kvmarm/next
      Merge branch kvm-arm64/sgi-injection into kvmarm/next
      tools headers arm64: Fix references to top srcdir in Makefile
      KVM: selftests: Avoid using forced target for generating arm64 headers
      Merge branch kvm-arm64/writable-id-regs into kvmarm/next
      Merge branch kvm-arm64/mops into kvmarm/next
      Merge branch kvm-arm64/pmu_pmcr_n into kvmarm/next

Paolo Bonzini (11):
      Merge tag 'loongarch-kvm-6.7' of git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson into HEAD
      Merge tag 'kvm-riscv-6.7-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-s390-next-6.7-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-x86-apic-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-docs-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-misc-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-mmu-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-xen-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-pmu-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-svm-6.7' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvmarm-6.7' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD

Paul Durrant (1):
      KVM: x86/xen: ignore the VCPU_SSHOTTMR_future flag

Peng Hao (2):
      KVM: X86: Reduce size of kvm_vcpu_arch structure when CONFIG_KVM_XEN=n
      KVM: x86: Use octal for file permission

Peter Gonda (1):
      KVM: SVM: Update SEV-ES shutdown intercepts with more metadata

Raghavendra Rao Ananta (5):
      KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based on the associated PMU
      KVM: arm64: Add {get,set}_user for PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
      KVM: arm64: Sanitize PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR} before first run
      tools: Import arm_pmuv3.h
      KVM: selftests: aarch64: vPMU test for validating user accesses

Reiji Watanabe (7):
      KVM: arm64: PMU: Introduce helpers to set the guest's PMU
      KVM: arm64: Select default PMU in KVM_ARM_VCPU_INIT handler
      KVM: arm64: PMU: Add a helper to read a vCPU's PMCR_EL0
      KVM: arm64: PMU: Allow userspace to limit PMCR_EL0.N for the guest
      KVM: selftests: aarch64: Introduce vpmu_counter_access test
      KVM: selftests: aarch64: vPMU register test for implemented counters
      KVM: selftests: aarch64: vPMU register test for unimplemented counters

Sean Christopherson (2):
      KVM: x86: Refactor can_emulate_instruction() return to be more expressive
      KVM: SVM: Treat all "skip" emulation for SEV guests as outright failures

Tao Su (1):
      KVM: x86: Clear bit12 of ICR after APIC-write VM-exit

Tianrui Zhao (25):
      LoongArch: KVM: Add kvm related header files
      LoongArch: KVM: Implement kvm module related interface
      LoongArch: KVM: Implement kvm hardware enable, disable interface
      LoongArch: KVM: Implement VM related functions
      LoongArch: KVM: Add vcpu related header files
      LoongArch: KVM: Implement basic vcpu interfaces
      LoongArch: KVM: Implement basic vcpu ioctl interfaces
      LoongArch: KVM: Implement fpu operations for vcpu
      LoongArch: KVM: Implement vcpu interrupt operations
      LoongArch: KVM: Implement vcpu load and vcpu put operations
      LoongArch: KVM: Implement misc vcpu related interfaces
      LoongArch: KVM: Implement vcpu timer operations
      LoongArch: KVM: Implement virtual machine tlb operations
      LoongArch: KVM: Implement kvm mmu operations
      LoongArch: KVM: Implement handle csr exception
      LoongArch: KVM: Implement handle iocsr exception
      LoongArch: KVM: Implement handle idle exception
      LoongArch: KVM: Implement handle gspr exception
      LoongArch: KVM: Implement handle mmio exception
      LoongArch: KVM: Implement handle fpu exception
      LoongArch: KVM: Implement kvm exception vectors
      LoongArch: KVM: Implement vcpu world switch
      LoongArch: KVM: Enable kvm config and add the makefile
      LoongArch: KVM: Supplement kvm document about LoongArch-specific part
      LoongArch: KVM: Add maintainers for LoongArch KVM

Vincent Donnefort (1):
      KVM: arm64: Do not transfer page refcount for THP adjustment

Yan Zhao (5):
      KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
      KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are honored
      KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
      KVM: x86/mmu: Zap KVM TDP when noncoherent DMA assignment starts/stops
      KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED

Zenghui Yu (2):
      KVM: arm64: selftest: Add the missing .guest_prepare()
      KVM: arm64: selftest: Perform ISB before reading PAR_EL1

 .../devicetree/bindings/riscv/extensions.yaml      |  12 +
 Documentation/virt/kvm/api.rst                     | 158 +++-
 Documentation/virt/kvm/arm/index.rst               |   1 +
 Documentation/virt/kvm/arm/vcpu-features.rst       |  48 ++
 Documentation/virt/kvm/devices/arm-vgic-v3.rst     |   7 +
 Documentation/virt/kvm/x86/mmu.rst                 |  43 +-
 MAINTAINERS                                        |  13 +
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |  15 +-
 arch/arm64/include/asm/kvm_host.h                  |  61 +-
 arch/arm64/include/asm/kvm_hyp.h                   |   7 +-
 arch/arm64/include/asm/kvm_mmu.h                   |  45 +-
 arch/arm64/include/asm/kvm_nested.h                |   3 +-
 arch/arm64/include/asm/stage2_pgtable.h            |   4 +-
 arch/arm64/include/asm/sysreg.h                    |  45 +
 arch/arm64/include/asm/tlbflush.h                  |   8 +-
 arch/arm64/include/asm/traps.h                     |  54 +-
 arch/arm64/include/uapi/asm/kvm.h                  |  32 +
 arch/arm64/kernel/traps.c                          |  48 +-
 arch/arm64/kvm/arch_timer.c                        |   6 +-
 arch/arm64/kvm/arm.c                               | 200 ++++-
 arch/arm64/kvm/emulate-nested.c                    |  77 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |  17 +
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |   3 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   8 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |   4 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   2 +
 arch/arm64/kvm/hyp/pgtable.c                       |   4 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |  34 +-
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |  11 +-
 arch/arm64/kvm/hyp/vhe/tlb.c                       |  18 +-
 arch/arm64/kvm/hypercalls.c                        |  36 +-
 arch/arm64/kvm/mmio.c                              |   4 +-
 arch/arm64/kvm/mmu.c                               |  33 +-
 arch/arm64/kvm/pkvm.c                              |   2 +-
 arch/arm64/kvm/pmu-emul.c                          | 145 +++-
 arch/arm64/kvm/reset.c                             |  56 +-
 arch/arm64/kvm/sys_regs.c                          | 353 ++++++--
 arch/arm64/kvm/trace_arm.h                         |  25 +
 arch/arm64/kvm/vgic/vgic-debug.c                   |   6 +-
 arch/arm64/kvm/vgic/vgic-irqfd.c                   |   2 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  49 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |  11 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 | 156 ++--
 arch/arm64/kvm/vgic/vgic.c                         |  12 +-
 arch/arm64/kvm/vmid.c                              |  11 +-
 arch/loongarch/Kbuild                              |   2 +
 arch/loongarch/Kconfig                             |   6 +
 arch/loongarch/configs/loongson3_defconfig         |   2 +
 arch/loongarch/include/asm/inst.h                  |  16 +
 arch/loongarch/include/asm/kvm_csr.h               | 211 +++++
 arch/loongarch/include/asm/kvm_host.h              | 237 ++++++
 arch/loongarch/include/asm/kvm_mmu.h               | 139 +++
 arch/loongarch/include/asm/kvm_types.h             |  11 +
 arch/loongarch/include/asm/kvm_vcpu.h              |  93 ++
 arch/loongarch/include/asm/loongarch.h             |  19 +-
 arch/loongarch/include/uapi/asm/kvm.h              | 108 +++
 arch/loongarch/kernel/asm-offsets.c                |  32 +
 arch/loongarch/kvm/Kconfig                         |  40 +
 arch/loongarch/kvm/Makefile                        |  22 +
 arch/loongarch/kvm/exit.c                          | 696 +++++++++++++++
 arch/loongarch/kvm/interrupt.c                     | 183 ++++
 arch/loongarch/kvm/main.c                          | 420 +++++++++
 arch/loongarch/kvm/mmu.c                           | 914 ++++++++++++++++++++
 arch/loongarch/kvm/switch.S                        | 250 ++++++
 arch/loongarch/kvm/timer.c                         | 197 +++++
 arch/loongarch/kvm/tlb.c                           |  32 +
 arch/loongarch/kvm/trace.h                         | 162 ++++
 arch/loongarch/kvm/vcpu.c                          | 939 +++++++++++++++++++++
 arch/loongarch/kvm/vm.c                            |  94 +++
 arch/riscv/include/asm/csr.h                       |  18 +
 arch/riscv/include/asm/hwcap.h                     |   2 +
 arch/riscv/include/asm/kvm_host.h                  |  18 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   7 +-
 arch/riscv/include/asm/sbi.h                       |   7 +
 arch/riscv/include/uapi/asm/kvm.h                  |  12 +
 arch/riscv/kernel/cpufeature.c                     |   2 +
 arch/riscv/kvm/vcpu.c                              |  74 +-
 arch/riscv/kvm/vcpu_onereg.c                       |  72 +-
 arch/riscv/kvm/vcpu_sbi.c                          |  61 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  32 +
 arch/s390/include/asm/kvm_host.h                   |   7 +
 arch/s390/kvm/gaccess.c                            |   7 +
 arch/s390/kvm/kvm-s390.c                           |  11 +-
 arch/s390/kvm/trace-s390.h                         |  23 +
 arch/s390/kvm/vsie.c                               |   5 +-
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |   3 +-
 arch/x86/include/asm/kvm_host.h                    |  22 +-
 arch/x86/include/asm/msr-index.h                   |   1 +
 arch/x86/kvm/Kconfig                               |  11 +
 arch/x86/kvm/cpuid.c                               |  10 +-
 arch/x86/kvm/cpuid.h                               |   3 +-
 arch/x86/kvm/hyperv.c                              |  10 +-
 arch/x86/kvm/lapic.c                               |  30 +-
 arch/x86/kvm/mmu.h                                 |   7 +
 arch/x86/kvm/mmu/mmu.c                             |  37 +-
 arch/x86/kvm/mtrr.c                                |   2 +-
 arch/x86/kvm/smm.c                                 |   1 -
 arch/x86/kvm/svm/svm.c                             |  52 +-
 arch/x86/kvm/vmx/vmx.c                             |  45 +-
 arch/x86/kvm/x86.c                                 | 248 ++++--
 arch/x86/kvm/x86.h                                 |   1 +
 arch/x86/kvm/xen.c                                 |  59 +-
 include/kvm/arm_arch_timer.h                       |   2 +-
 include/kvm/arm_pmu.h                              |  28 +-
 include/kvm/arm_psci.h                             |   2 +-
 include/kvm/arm_vgic.h                             |   4 +-
 include/linux/perf/arm_pmuv3.h                     |   9 +-
 include/uapi/linux/kvm.h                           |  11 +
 tools/arch/arm64/include/.gitignore                |   1 +
 tools/arch/arm64/include/asm/gpr-num.h             |  26 +
 tools/arch/arm64/include/asm/sysreg.h              | 841 +++++-------------
 tools/arch/arm64/tools/Makefile                    |  38 +
 tools/include/perf/arm_pmuv3.h                     | 308 +++++++
 tools/perf/Makefile.perf                           |  15 +-
 tools/perf/util/Build                              |   2 +-
 tools/testing/selftests/kvm/Makefile               |  25 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |   4 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |  12 +-
 .../selftests/kvm/aarch64/page_fault_test.c        |  11 +-
 tools/testing/selftests/kvm/aarch64/set_id_regs.c  | 481 +++++++++++
 .../selftests/kvm/aarch64/vpmu_counter_access.c    | 670 +++++++++++++++
 .../selftests/kvm/include/aarch64/processor.h      |   1 +
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   6 +-
 tools/testing/selftests/kvm/riscv/get-reg-list.c   | 235 ++++--
 tools/testing/selftests/kvm/x86_64/hwcr_msr_test.c |  47 ++
 127 files changed, 8890 insertions(+), 1508 deletions(-)

diff --combined arch/arm64/kvm/arm.c
index 4ea6c22250a5,317964bad1e1..000000000000
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@@ -1204,12 -1279,25 +1279,25 @@@
  			return -ENOENT;
  	}
  
+ 	if (features & ~system_supported_vcpu_features())
+ 		return -EINVAL;
+ 
+ 	/*
+ 	 * For now make sure that both address/generic pointer authentication
+ 	 * features are requested by the userspace together.
+ 	 */
+ 	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, &features) !=
+ 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
+ 		return -EINVAL;
+ 
+ 	/* Disallow NV+SVE for the time being */
+ 	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features) &&
+ 	    test_bit(KVM_ARM_VCPU_SVE, &features))
+ 		return -EINVAL;
+ 
  	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
  		return 0;
  
- 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
- 		return -EINVAL;
- 
  	/* MTE is incompatible with AArch32 */
  	if (kvm_has_mte(vcpu->kvm))
  		return -EINVAL;


