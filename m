Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB48D53405A
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 17:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244971AbiEYP1E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 11:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiEYP06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 11:26:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E6A1E9346C
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 08:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653492414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eaP46s2170f4QX/j7XwBtTACiynrShzFO/8b2jBterY=;
        b=WQ1FaGF9uXVC5B46oYMD3X8KhFEDOBn3t2cSkQxf1rnljKbWEwmOp6XrcGqjpes5HMOo8/
        /Y9RJAmhrZ3bVtRA2enk061eKCwtUQLbJ57gsEwjiCy6UsmXn97KM34QwpN+5hxjUiaB1P
        fQD7Tw69eulMVbokTqPVp2lVTevHnF4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-t-vrnXoqNf-0_rXFDMyD8Q-1; Wed, 25 May 2022 11:26:50 -0400
X-MC-Unique: t-vrnXoqNf-0_rXFDMyD8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FFA118E52C6;
        Wed, 25 May 2022 15:26:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78748400F3E6;
        Wed, 25 May 2022 15:26:50 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] KVM changes for Linux 5.19 merge window
Date:   Wed, 25 May 2022 11:26:50 -0400
Message-Id: <20220525152650.250776-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 42226c989789d8da4af1de0c31070c96726d990c:

  Linux 5.18-rc7 (2022-05-15 18:08:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to ffd1925a596ce68bed7d81c61cb64bc35f788a9d:

  KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest (2022-05-25 05:18:27 -0400)

----------------------------------------------------------------
S390:
* ultravisor communication device driver

* fix TEID on terminating storage key ops

RISC-V:

* Added Sv57x4 support for G-stage page table

* Added range based local HFENCE functions

* Added remote HFENCE functions based on VCPU requests

* Added ISA extension registers in ONE_REG interface

* Updated KVM RISC-V maintainers entry to cover selftests support

ARM:

* Add support for the ARMv8.6 WFxT extension

* Guard pages for the EL2 stacks

* Trap and emulate AArch32 ID registers to hide unsupported features

* Ability to select and save/restore the set of hypercalls exposed
  to the guest

* Support for PSCI-initiated suspend in collaboration with userspace

* GICv3 register-based LPI invalidation support

* Move host PMU event merging into the vcpu data structure

* GICv3 ITS save/restore fixes

* The usual set of small-scale cleanups and fixes

x86:

* New ioctls to get/set TSC frequency for a whole VM

* Allow userspace to opt out of hypercall patching

* Only do MSR filtering for MSRs accessed by rdmsr/wrmsr

AMD SEV improvements:

* Add KVM_EXIT_SHUTDOWN metadata for SEV-ES

* V_TSC_AUX support

Nested virtualization improvements for AMD:

* Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
  nested vGIF)

* Allow AVIC to co-exist with a nested guest running

* Fixes for LBR virtualizations when a nested guest is running,
  and nested LBR virtualization support

* PAUSE filtering for nested hypervisors

Guest support:

* Decoupling of vcpu_is_preempted from PV spinlocks

----------------------------------------------------------------

As Catalin mentioned, there is a small conflict in arch/arm64/kvm/sys_regs.c;
the linux.git version is already the correct resolution of the conflict.

Alexandru Elisei (3):
      KVM: arm64: Hide AArch32 PMU registers when not available
      KVM: arm64: Don't BUG_ON() if emulated register table is unsorted
      KVM: arm64: Print emulated register table name when it is unsorted

Anup Patel (9):
      KVM: selftests: riscv: Improve unexpected guest trap handling
      RISC-V: KVM: Use G-stage name for hypervisor page table
      RISC-V: KVM: Add Sv57x4 mode support for G-stage
      RISC-V: KVM: Treat SBI HFENCE calls as NOPs
      RISC-V: KVM: Introduce range based local HFENCE functions
      RISC-V: KVM: Reduce KVM_MAX_VCPUS value
      RISC-V: KVM: Add remote HFENCE functions based on VCPU requests
      RISC-V: KVM: Cleanup stale TLB entries when host CPU changes
      MAINTAINERS: Update KVM RISC-V entry to cover selftests support

Ard Biesheuvel (1):
      KVM: arm64: Avoid unnecessary absolute addressing via literals

Ashish Kalra (1):
      KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent kernel data leak

Atish Patra (1):
      RISC-V: KVM: Introduce ISA extension register

Babu Moger (2):
      x86/cpufeatures: Add virtual TSC_AUX feature bit
      KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts

Boris Ostrovsky (1):
      KVM: x86/xen: handle PV spinlocks slowpath

David Woodhouse (14):
      KVM: x86/xen: Use gfn_to_pfn_cache for runstate area
      KVM: x86: Use gfn_to_pfn_cache for pv_time
      KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_info
      KVM: x86/xen: Use gfn_to_pfn_cache for vcpu_time_info
      KVM: x86/xen: Make kvm_xen_set_evtchn() reusable from other places
      KVM: x86/xen: Support direct injection of event channel events
      KVM: x86/xen: Add KVM_XEN_VCPU_ATTR_TYPE_VCPU_ID
      KVM: x86/xen: Kernel acceleration for XENVER_version
      KVM: x86/xen: Support per-vCPU event channel upcall via local APIC
      KVM: x86/xen: Advertise and document KVM_XEN_HVM_CONFIG_EVTCHN_SEND
      KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN_SEND
      KVM: x86/xen: Update self test for Xen PV timers
      KVM: x86: Accept KVM_[GS]ET_TSC_KHZ as a VM ioctl.
      KVM: x86: Test case for TSC scaling and offset sync

Fuad Tabba (4):
      KVM: arm64: Wrapper for getting pmu_events
      KVM: arm64: Repack struct kvm_pmu to reduce size
      KVM: arm64: Pass pmu events to hyp via vcpu
      KVM: arm64: Reenable pmu in Protected Mode

Hou Wenlong (1):
      KVM: x86/mmu: Don't rebuild page when the page is synced and no tlb flushing is required

Janis Schoetterl-Glausch (2):
      KVM: s390: Don't indicate suppression on dirtying, failing memop
      KVM: s390: selftest: Test suppression indication on key prot exception

Jiapeng Chong (1):
      KVM: selftests: riscv: Remove unneeded semicolon

Joao Martins (3):
      KVM: x86/xen: intercept EVTCHNOP_send from guests
      KVM: x86/xen: handle PV IPI vcpu yield
      KVM: x86/xen: handle PV timers oneshot mode

Jon Kohler (1):
      KVM: x86: optimize PKU branching in kvm_load_{guest|host}_xsave_state

Kai Huang (3):
      KVM: x86/mmu: Rename reset_rsvds_bits_mask()
      KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask
      KVM: VMX: Include MKTME KeyID bits in shadow_zero_check

Kalesh Singh (6):
      KVM: arm64: Introduce hyp_alloc_private_va_range()
      KVM: arm64: Introduce pkvm_alloc_private_va_range()
      KVM: arm64: Add guard pages for KVM nVHE hypervisor stack
      KVM: arm64: Add guard pages for pKVM (protected nVHE) hypervisor stack
      KVM: arm64: Detect and handle hypervisor stack overflows
      KVM: arm64: Symbolize the nVHE HYP addresses

Lai Jiangshan (2):
      KVM: X86/MMU: Add sp_has_gptes()
      KVM: X86/MMU: Fix shadowing 5-level NPT for 4-level NPT L1 guest

Li RongQing (2):
      KVM: x86: Support the vCPU preemption check with nopvspin and realtime hint
      KVM: VMX: clean up pi_wakeup_handler

Like Xu (8):
      KVM: x86/i8259: Remove a dead store of irq in a conditional block
      KVM: x86/xen: Remove the redundantly included header file lapic.h
      selftests: kvm/x86/xen: Replace a comma in the xen_shinfo_test with semicolon
      KVM: x86: Move kvm_ops_static_call_update() to x86.c
      KVM: x86: Copy kvm_pmu_ops by value to eliminate layer of indirection
      KVM: x86: Move .pmu_ops to kvm_x86_init_ops and tag as __initdata
      KVM: x86: Use static calls to reduce kvm_pmu_ops overhead
      KVM: selftests: x86: Sync the new name of the test case to .gitignore

Marc Zyngier (29):
      arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
      arm64: Add RV and RN fields for ESR_ELx_WFx_ISS
      arm64: Add HWCAP advertising FEAT_WFXT
      arm64: Add wfet()/wfit() helpers
      arm64: Use WFxT for __delay() when possible
      KVM: arm64: Simplify kvm_cpu_has_pending_timer()
      KVM: arm64: Introduce kvm_counter_compute_delta() helper
      KVM: arm64: Handle blocking WFIT instruction
      KVM: arm64: Offer early resume for non-blocking WFxT instructions
      KVM: arm64: Expose the WFXT feature to guests
      KVM: arm64: Fix new instances of 32bit ESRs
      Merge remote-tracking branch 'arm64/for-next/sme' into kvmarm-master/next
      Merge branch kvm-arm64/wfxt into kvmarm-master/next
      Merge branch kvm-arm64/hyp-stack-guard into kvmarm-master/next
      Merge branch kvm-arm64/aarch32-idreg-trap into kvmarm-master/next
      Documentation: Fix index.rst after psci.rst renaming
      KVM: arm64: vgic-v3: Expose GICR_CTLR.RWP when disabling LPIs
      KVM: arm64: vgic-v3: Implement MMIO-based LPI invalidation
      KVM: arm64: vgic-v3: Advertise GICR_CTLR.{IR, CES} as a new GICD_IIDR revision
      KVM: arm64: vgic-v3: List M1 Pro/Max as requiring the SEIS workaround
      KVM: arm64: Hide KVM_REG_ARM_*_BMAP_BIT_COUNT from userspace
      KVM: arm64: pmu: Restore compilation when HW_PERF_EVENTS isn't selected
      KVM: arm64: Fix hypercall bitmap writeback when vcpus have already run
      Merge branch kvm-arm64/hcall-selection into kvmarm-master/next
      Merge branch kvm-arm64/psci-suspend into kvmarm-master/next
      Merge branch kvm-arm64/vgic-invlpir into kvmarm-master/next
      Merge branch kvm-arm64/per-vcpu-host-pmu-data into kvmarm-master/next
      Merge branch kvm-arm64/misc-5.19 into kvmarm-master/next
      Merge branch kvm-arm64/its-save-restore-fixes-5.19 into kvmarm-master/next

Maxim Levitsky (14):
      KVM: x86: nSVM: implement nested VMLOAD/VMSAVE
      KVM: x86: SVM: allow to force AVIC to be enabled
      KVM: x86: mark synthetic SMM vmexit as SVM_EXIT_SW
      KVM: x86: SVM: use vmcb01 in init_vmcb
      kvm: x86: SVM: use vmcb* instead of svm->vmcb where it makes sense
      KVM: x86: SVM: remove vgif_enabled()
      KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running
      KVM: x86: nSVM: implement nested LBR virtualization
      KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE
      KVM: x86: nSVM: implement nested vGIF
      KVM: x86: allow per cpu apicv inhibit reasons
      KVM: x86: SVM: allow AVIC to co-exist with a nested guest running
      KVM: x86: avoid loading a vCPU after .vm_destroy was called
      KVM: x86: fix typo in __try_cmpxchg_user causing non-atomicness

Oliver Upton (23):
      KVM: x86: Allow userspace to opt out of hypercall patching
      selftests: KVM: Test KVM_X86_QUIRK_FIX_HYPERCALL_INSN
      KVM: arm64: Return a bool from emulate_cp()
      KVM: arm64: Don't write to Rt unless sys_reg emulation succeeds
      KVM: arm64: Wire up CP15 feature registers to their AArch64 equivalents
      KVM: arm64: Plumb cp10 ID traps through the AArch64 sysreg handler
      KVM: arm64: Start trapping ID registers for 32 bit guests
      selftests: KVM: Rename psci_cpu_on_test to psci_test
      selftests: KVM: Create helper for making SMCCC calls
      KVM: arm64: Don't depend on fallthrough to hide SYSTEM_RESET2
      KVM: arm64: Dedupe vCPU power off helpers
      KVM: arm64: Track vCPU power state using MP state values
      KVM: arm64: Rename the KVM_REQ_SLEEP handler
      KVM: arm64: Return a value from check_vcpu_requests()
      KVM: arm64: Add support for userspace to suspend a vCPU
      KVM: arm64: Implement PSCI SYSTEM_SUSPEND
      selftests: KVM: Rename psci_cpu_on_test to psci_test
      selftests: KVM: Create helper for making SMCCC calls
      selftests: KVM: Use KVM_SET_MP_STATE to power off vCPU in psci_test
      selftests: KVM: Refactor psci_test to make it amenable to new tests
      selftests: KVM: Test SYSTEM_SUSPEND PSCI call
      KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
      KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE

Paolo Bonzini (31):
      Merge branch 'kvm-older-features' into HEAD
      Merge branch 'kvm-fixes-for-5.18-rc5' into HEAD
      KVM: x86/mmu: nested EPT cannot be used in SMM
      KVM: x86/mmu: constify uses of struct kvm_mmu_role_regs
      KVM: x86/mmu: pull computation of kvm_mmu_role_regs to kvm_init_mmu
      KVM: x86/mmu: rephrase unclear comment
      KVM: x86/mmu: remove "bool base_only" arguments
      KVM: x86/mmu: split cpu_role from mmu_role
      KVM: x86/mmu: do not recompute root level from kvm_mmu_role_regs
      KVM: x86/mmu: remove ept_ad field
      KVM: x86/mmu: remove kvm_calc_shadow_root_page_role_common
      KVM: x86/mmu: cleanup computation of MMU roles for two-dimensional paging
      KVM: x86/mmu: cleanup computation of MMU roles for shadow paging
      KVM: x86/mmu: store shadow EFER.NX in the MMU role
      KVM: x86/mmu: remove extended bits from mmu_role, rename field
      KVM: x86/mmu: rename kvm_mmu_role union
      KVM: x86/mmu: remove redundant bits from extended role
      KVM: x86/mmu: simplify and/or inline computation of shadow MMU roles
      KVM: x86/mmu: pull CPU mode computation to kvm_init_mmu
      KVM: x86/mmu: replace shadow_root_level with root_role.level
      KVM: x86/mmu: replace root_level with cpu_role.base.level
      KVM: x86/mmu: replace direct_map with root_role.direct
      Merge branch 'kvm-tdp-mmu-atomicity-fix' into HEAD
      Merge branch 'kvm-amd-pmu-fixes' into HEAD
      KVM: x86: a vCPU with a pending triple fault is runnable
      Merge tag 'kvmarm-5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-5.19-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvm-s390-next-5.19-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      s390/uv_uapi: depend on CONFIG_S390
      x86, kvm: use correct GFP flags for preemption disabled
      Documentation: kvm: reorder ARM-specific section about KVM_SYSTEM_EVENT_SUSPEND

Peng Hao (2):
      kvm: x86: Adjust the location of pkru_mask of kvm_mmu to reduce memory
      kvm: vmx: remove redundant parentheses

Peter Gonda (1):
      KVM, SEV: Add KVM_EXIT_SHUTDOWN metadata for SEV-ES

Peter Zijlstra (1):
      x86/uaccess: Implement macros for CMPXCHG on user addresses

Raghavendra Rao Ananta (9):
      KVM: arm64: Factor out firmware register handling from psci.c
      KVM: arm64: Setup a framework for hypercall bitmap firmware registers
      KVM: arm64: Add standard hypervisor firmware register
      KVM: arm64: Add vendor hypervisor firmware register
      Docs: KVM: Rename psci.rst to hypercalls.rst
      Docs: KVM: Add doc for the bitmap firmware registers
      tools: Import ARM SMCCC definitions
      selftests: KVM: aarch64: Introduce hypercall ABI test
      selftests: KVM: aarch64: Add the bitmap firmware registers to get-reg-list

Randy Dunlap (1):
      KVM: arm64: nvhe: Eliminate kernel-doc warnings

Ricardo Koller (4):
      KVM: arm64: vgic: Check that new ITEs could be saved in guest memory
      KVM: arm64: vgic: Add more checks when restoring ITS tables
      KVM: arm64: vgic: Do not ignore vgic_its_restore_cte failures
      KVM: arm64: vgic: Undo work in failed ITS restores

SU Hang (1):
      KVM: VMX: replace 0x180 with EPT_VIOLATION_* definition

Sean Christopherson (22):
      KVM: x86: Don't snapshot "max" TSC if host TSC is constant
      KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX bits
      KVM: x86: Drop WARNs that assert a triple fault never "escapes" from L2
      KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry
      KVM: nVMX: Clear IDT vectoring on nested VM-Exit for double/triple fault
      Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug
      KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits
      KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses
      KVM: x86: Bail to userspace if emulation of atomic user access faults
      KVM: x86/mmu: Check for host MMIO exclusion from mem encrypt iff necessary
      KVM: x86/mmu: Use enable_mmio_caching to track if MMIO caching is enabled
      KVM: x86: Clean up and document nested #PF workaround
      KVM: Add max_vcpus field in common 'struct kvm'
      KVM: x86/mmu: Don't attempt fast page fault just because EPT is in use
      KVM: x86/mmu: Drop exec/NX check from "page fault can be fast"
      KVM: x86/mmu: Add RET_PF_CONTINUE to eliminate bool+int* "returns"
      KVM: x86/mmu: Make all page fault handlers internal to the MMU
      KVM: x86/mmu: Use IS_ENABLED() to avoid RETPOLINE for TDP page faults
      KVM: x86/mmu: Expand and clean up page fault stats
      x86/fpu: KVM: Set the base guest FPU uABI size to sizeof(struct kvm_xsave)
      KVM: x86: avoid calling x86 emulator without a decoded instruction
      x86/kvm: Alloc dummy async #PF token outside of raw spinlock

Steffen Eiden (2):
      drivers/s390/char: Add Ultravisor io device
      selftests: drivers/s390x: Add uvdevice tests

Stephen Rothwell (1):
      Documentation: KVM: Fix title level for PSCI_SUSPEND

Suravee Suthikulpanit (2):
      KVM: SVM: Use target APIC ID to complete AVIC IRQs when possible
      KVM: SVM: Introduce trace point for the slow-path of avic_kic_target_vcpus

Vipin Sharma (1):
      KVM: x86/mmu: Speed up slot_rmap_walk_next for sparsely populated rmaps

Wanpeng Li (3):
      x86/kvm: Don't waste kvmclock memory if there is nopv parameter
      KVM: LAPIC: Trace LAPIC timer expiration on every vmentry
      KVM: LAPIC: Drop pending LAPIC timer injection when canceling the timer

Yanfei Xu (1):
      KVM: x86: Fix the intel_pt PMI handling wrongly considered from guest

Yang Weijiang (1):
      KVM: selftests: x86: Fix test failure on arch lbr capable platforms

Yuan Yao (1):
      KVM: VMX: Use vcpu_to_pi_desc() uniformly in posted_intr.c

Zeng Guang (1):
      KVM: VMX: Prepare VMCS setting for posted interrupt enabling when APICv is available

 Documentation/arm64/cpu-feature-registers.rst      |    2 +
 Documentation/arm64/elf_hwcaps.rst                 |   37 +
 Documentation/arm64/index.rst                      |    1 +
 Documentation/arm64/sme.rst                        |  428 +++++++
 Documentation/arm64/sve.rst                        |   70 +-
 Documentation/virt/kvm/api.rst                     |  252 +++-
 Documentation/virt/kvm/arm/hypercalls.rst          |  138 +++
 Documentation/virt/kvm/arm/index.rst               |    2 +-
 Documentation/virt/kvm/arm/psci.rst                |   77 --
 Documentation/virt/kvm/x86/mmu.rst                 |    4 +
 MAINTAINERS                                        |    5 +
 arch/arm64/Kconfig                                 |   11 +
 arch/arm64/include/asm/barrier.h                   |    4 +
 arch/arm64/include/asm/cpu.h                       |    4 +
 arch/arm64/include/asm/cpufeature.h                |   24 +
 arch/arm64/include/asm/cputype.h                   |    8 +
 arch/arm64/include/asm/el2_setup.h                 |   64 +-
 arch/arm64/include/asm/esr.h                       |   21 +-
 arch/arm64/include/asm/exception.h                 |    1 +
 arch/arm64/include/asm/fpsimd.h                    |  123 +-
 arch/arm64/include/asm/fpsimdmacros.h              |   87 ++
 arch/arm64/include/asm/hwcap.h                     |    9 +
 arch/arm64/include/asm/kvm_arm.h                   |    4 +-
 arch/arm64/include/asm/kvm_asm.h                   |    1 +
 arch/arm64/include/asm/kvm_emulate.h               |    7 -
 arch/arm64/include/asm/kvm_host.h                  |   48 +-
 arch/arm64/include/asm/kvm_mmu.h                   |    3 +
 arch/arm64/include/asm/processor.h                 |   26 +-
 arch/arm64/include/asm/sysreg.h                    |   67 ++
 arch/arm64/include/asm/thread_info.h               |    2 +
 arch/arm64/include/uapi/asm/hwcap.h                |    9 +
 arch/arm64/include/uapi/asm/kvm.h                  |   34 +
 arch/arm64/include/uapi/asm/ptrace.h               |   69 +-
 arch/arm64/include/uapi/asm/sigcontext.h           |   55 +-
 arch/arm64/kernel/cpufeature.c                     |  120 ++
 arch/arm64/kernel/cpuinfo.c                        |   14 +
 arch/arm64/kernel/entry-common.c                   |   11 +
 arch/arm64/kernel/entry-fpsimd.S                   |   36 +
 arch/arm64/kernel/fpsimd.c                         |  585 ++++++++-
 arch/arm64/kernel/process.c                        |   44 +-
 arch/arm64/kernel/ptrace.c                         |  358 +++++-
 arch/arm64/kernel/signal.c                         |  188 ++-
 arch/arm64/kernel/syscall.c                        |   29 +-
 arch/arm64/kernel/traps.c                          |    1 +
 arch/arm64/kvm/Makefile                            |    4 +-
 arch/arm64/kvm/arch_timer.c                        |   47 +-
 arch/arm64/kvm/arm.c                               |  164 ++-
 arch/arm64/kvm/fpsimd.c                            |   43 +-
 arch/arm64/kvm/guest.c                             |   10 +-
 arch/arm64/kvm/handle_exit.c                       |   49 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |    6 +-
 arch/arm64/kvm/hyp/nvhe/host.S                     |   32 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   18 +-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |   78 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   31 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   87 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |    3 -
 arch/arm64/kvm/hyp/vhe/switch.c                    |   11 +-
 arch/arm64/kvm/hypercalls.c                        |  327 ++++-
 arch/arm64/kvm/mmu.c                               |   68 +-
 arch/arm64/kvm/pmu-emul.c                          |    3 +-
 arch/arm64/kvm/pmu.c                               |   40 +-
 arch/arm64/kvm/psci.c                              |  248 +---
 arch/arm64/kvm/sys_regs.c                          |  305 +++--
 arch/arm64/kvm/sys_regs.h                          |    9 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   13 +-
 arch/arm64/kvm/vgic/vgic-its.c                     |  160 ++-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   18 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |  125 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |    4 +
 arch/arm64/kvm/vgic/vgic.h                         |   10 +
 arch/arm64/lib/delay.c                             |   12 +-
 arch/arm64/tools/cpucaps                           |    3 +
 arch/riscv/include/asm/csr.h                       |    1 +
 arch/riscv/include/asm/kvm_host.h                  |  124 +-
 arch/riscv/include/uapi/asm/kvm.h                  |   20 +
 arch/riscv/kvm/main.c                              |   11 +-
 arch/riscv/kvm/mmu.c                               |  264 +++--
 arch/riscv/kvm/tlb.S                               |   74 --
 arch/riscv/kvm/tlb.c                               |  461 ++++++++
 arch/riscv/kvm/vcpu.c                              |  144 ++-
 arch/riscv/kvm/vcpu_exit.c                         |    6 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |   40 +-
 arch/riscv/kvm/vcpu_sbi_v01.c                      |   35 +-
 arch/riscv/kvm/vm.c                                |    8 +-
 arch/riscv/kvm/vmid.c                              |   30 +-
 arch/s390/include/asm/uv.h                         |   23 +-
 arch/s390/include/uapi/asm/uvdevice.h              |   51 +
 arch/s390/kvm/gaccess.c                            |   22 +-
 arch/x86/include/asm/cpufeatures.h                 |    1 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    1 +
 arch/x86/include/asm/kvm-x86-pmu-ops.h             |   31 +
 arch/x86/include/asm/kvm_host.h                    |   93 +-
 arch/x86/include/asm/uaccess.h                     |  142 +++
 arch/x86/include/asm/vmx.h                         |   10 +-
 arch/x86/include/uapi/asm/kvm.h                    |   11 +-
 arch/x86/kernel/asm-offsets_64.c                   |    4 +-
 arch/x86/kernel/fpu/core.c                         |   17 +-
 arch/x86/kernel/kvm.c                              |  118 +-
 arch/x86/kernel/kvmclock.c                         |    2 +-
 arch/x86/kvm/i8259.c                               |    1 -
 arch/x86/kvm/irq.c                                 |   10 +-
 arch/x86/kvm/irq_comm.c                            |    2 +-
 arch/x86/kvm/lapic.c                               |    5 +-
 arch/x86/kvm/lapic.h                               |    1 -
 arch/x86/kvm/mmu.h                                 |  109 +-
 arch/x86/kvm/mmu/mmu.c                             |  597 +++++-----
 arch/x86/kvm/mmu/mmu_internal.h                    |  123 +-
 arch/x86/kvm/mmu/mmutrace.h                        |    1 +
 arch/x86/kvm/mmu/paging_tmpl.h                     |   71 +-
 arch/x86/kvm/mmu/spte.c                            |   47 +-
 arch/x86/kvm/mmu/spte.h                            |   16 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |   14 +-
 arch/x86/kvm/pmu.c                                 |   66 +-
 arch/x86/kvm/pmu.h                                 |    7 +-
 arch/x86/kvm/svm/avic.c                            |   84 +-
 arch/x86/kvm/svm/nested.c                          |  308 +++--
 arch/x86/kvm/svm/pmu.c                             |    2 +-
 arch/x86/kvm/svm/sev.c                             |   28 +-
 arch/x86/kvm/svm/svm.c                             |  215 +++-
 arch/x86/kvm/svm/svm.h                             |   55 +-
 arch/x86/kvm/trace.h                               |   20 +
 arch/x86/kvm/vmx/nested.c                          |   63 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |    2 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   11 +-
 arch/x86/kvm/vmx/vmcs.h                            |    5 +
 arch/x86/kvm/vmx/vmx.c                             |   45 +-
 arch/x86/kvm/x86.c                                 |  373 +++---
 arch/x86/kvm/xen.c                                 | 1245 ++++++++++++++++----
 arch/x86/kvm/xen.h                                 |   62 +-
 drivers/s390/char/Kconfig                          |   11 +
 drivers/s390/char/Makefile                         |    1 +
 drivers/s390/char/uvdevice.c                       |  257 ++++
 include/kvm/arm_arch_timer.h                       |    2 -
 include/kvm/arm_hypercalls.h                       |    8 +
 include/kvm/arm_pmu.h                              |   34 +-
 include/kvm/arm_psci.h                             |    7 -
 include/kvm/arm_vgic.h                             |    8 +-
 include/linux/irqchip/arm-gic-v3.h                 |    2 +
 include/linux/kvm_host.h                           |    4 +-
 include/uapi/linux/elf.h                           |    2 +
 include/uapi/linux/kvm.h                           |   54 +-
 include/uapi/linux/prctl.h                         |    9 +
 init/Kconfig                                       |    5 +
 kernel/sys.c                                       |   12 +
 scripts/kallsyms.c                                 |    3 +-
 tools/include/linux/arm-smccc.h                    |  193 +++
 tools/testing/selftests/Makefile                   |    1 +
 tools/testing/selftests/drivers/.gitignore         |    1 +
 .../selftests/drivers/s390x/uvdevice/Makefile      |   22 +
 .../selftests/drivers/s390x/uvdevice/config        |    1 +
 .../drivers/s390x/uvdevice/test_uvdevice.c         |  276 +++++
 tools/testing/selftests/kvm/.gitignore             |    6 +-
 tools/testing/selftests/kvm/Makefile               |    7 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |    8 +
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |  336 ++++++
 .../selftests/kvm/aarch64/psci_cpu_on_test.c       |  121 --
 tools/testing/selftests/kvm/aarch64/psci_test.c    |  213 ++++
 .../selftests/kvm/include/aarch64/processor.h      |   22 +
 .../selftests/kvm/include/riscv/processor.h        |    8 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   25 +
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   11 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |   31 +-
 tools/testing/selftests/kvm/s390x/memop.c          |   46 +-
 tools/testing/selftests/kvm/steal_time.c           |   13 +-
 .../selftests/kvm/x86_64/fix_hypercall_test.c      |  170 +++
 .../selftests/kvm/x86_64/tsc_scaling_sync.c        |  119 ++
 .../{vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c}   |   18 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  366 +++++-
 virt/kvm/kvm_main.c                                |    3 +-
 170 files changed, 10302 insertions(+), 2477 deletions(-)
 create mode 100644 Documentation/arm64/sme.rst
 create mode 100644 Documentation/virt/kvm/arm/hypercalls.rst
 delete mode 100644 Documentation/virt/kvm/arm/psci.rst
 delete mode 100644 arch/riscv/kvm/tlb.S
 create mode 100644 arch/riscv/kvm/tlb.c
 create mode 100644 arch/s390/include/uapi/asm/uvdevice.h
 create mode 100644 arch/x86/include/asm/kvm-x86-pmu-ops.h
 create mode 100644 drivers/s390/char/uvdevice.c
 create mode 100644 tools/include/linux/arm-smccc.h
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/Makefile
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/config
 create mode 100644 tools/testing/selftests/drivers/s390x/uvdevice/test_uvdevice.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/hypercalls.c
 delete mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
 create mode 100644 tools/testing/selftests/kvm/aarch64/psci_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c
 create mode 100644 tools/testing/selftests/kvm/x86_64/tsc_scaling_sync.c
 rename tools/testing/selftests/kvm/x86_64/{vmx_pmu_msrs_test.c => vmx_pmu_caps_test.c} (83%)

