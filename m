Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2FF4E2F16
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348398AbiCURdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346206AbiCURdt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:33:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28429A777F
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647883941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cyCEsRKXo/NGE5mMjWZAdBtbI2P9zorUCnN7qNOiGEk=;
        b=CCoOiKQQcJoz7i+7NpigS2aGh9BONu82sH24B3UYAX3ckAI2GQlbxLPLCb9Q5IPH8IgMrI
        abuiI7o5A9I4r0q54/H9Be4gpIqwQYSSnmWjXguUrkrQkHpYxyoDLKjxl+HRDUpptl/9/7
        q9kTH6PwIw3jPoTFBInrigac/AVFSNw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-jtli3dPeNHmfWz1xUfDdIw-1; Mon, 21 Mar 2022 13:32:16 -0400
X-MC-Unique: jtli3dPeNHmfWz1xUfDdIw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3FE6F1C04B44;
        Mon, 21 Mar 2022 17:32:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 187C02026D07;
        Mon, 21 Mar 2022 17:32:16 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM patches for 5.18
Date:   Mon, 21 Mar 2022 13:32:15 -0400
Message-Id: <20220321173215.2824704-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8d25b7beca7ed6ca34f53f0f8abd009e2be15d94:

  KVM: x86: pull kvm->srcu read-side to kvm_arch_vcpu_ioctl_run (2022-03-02 10:55:58 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c9b8fecddb5bb4b67e351bbaeaa648a6f7456912:

  KVM: use kvcalloc for array allocations (2022-03-21 09:28:41 -0400)

----------------------------------------------------------------
ARM:

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

RISC-V:

- Prevent KVM_COMPAT from being selected

- Optimize __kvm_riscv_switch_to() implementation

- RISC-V SBI v0.3 support

s390:

- memop selftest

- fix SCK locking

- adapter interruptions virtualization for secure guests

- add Claudio Imbrenda as maintainer

- first step to do proper storage key checking

x86:

- Continue switching kvm_x86_ops to static_call(); introduce
  static_call_cond() and __static_call_ret0 when applicable.

- Cleanup unused arguments in several functions

- Synthesize AMD 0x80000021 leaf

- Fixes and optimization for Hyper-V sparse-bank hypercalls

- Implement Hyper-V's enlightened MSR bitmap for nested SVM

- Remove MMU auditing

- Eager splitting of page tables (new aka "TDP" MMU only) when dirty
  page tracking is enabled

- Cleanup the implementation of the guest PGD cache

- Preparation for the implementation of Intel IPI virtualization

- Fix some segment descriptor checks in the emulator

- Allow AMD AVIC support on systems with physical APIC ID above 255

- Better API to disable virtualization quirks

- Fixes and optimizations for the zapping of page tables:

  - Zap roots in two passes, avoiding RCU read-side critical sections
    that last too long for very large guests backed by 4 KiB SPTEs.

  - Zap invalid and defunct roots asynchronously via concurrency-managed
    work queue.

  - Allowing yielding when zapping TDP MMU roots in response to the root's
    last reference being put.

  - Batch more TLB flushes with an RCU trick.  Whoever frees the paging
    structure now holds RCU as a proxy for all vCPUs running in the guest,
    i.e. to prolongs the grace period on their behalf.  It then kicks the
    the vCPUs out of guest mode before doing rcu_read_unlock().

Generic:

- Introduce __vcalloc and use it for very large allocations that
  need memcg accounting

----------------------------------------------------------------
Alexandru Elisei (4):
      perf: Fix wrong name in comment for struct perf_cpu_context
      KVM: arm64: Keep a list of probed PMUs
      KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_SET_PMU attribute
      KVM: arm64: Refuse to run VCPU if the PMU doesn't match the physical CPU

Anup Patel (6):
      RISC-V: KVM: Upgrade SBI spec version to v0.3
      RISC-V: KVM: Add common kvm_riscv_vcpu_sbi_system_reset() function
      RISC-V: KVM: Implement SBI v0.3 SRST extension
      RISC-V: Add SBI HSM suspend related defines
      RISC-V: KVM: Add common kvm_riscv_vcpu_wfi() function
      RISC-V: KVM: Implement SBI HSM suspend call

Changcheng Deng (1):
      KVM: arm64: Remove unneeded semicolons

Christian Borntraeger (1):
      KVM: s390: MAINTAINERS: promote Claudio Imbrenda

Claudio Imbrenda (1):
      KVM: s390x: fix SCK locking

David Dunn (3):
      KVM: x86: Provide per VM capability for disabling PMU virtualization
      KVM: selftests: Carve out helper to create "default" VM without vCPUs
      KVM: selftests: Verify disabling PMU virtualization via KVM_CAP_CONFIG_PMU

David Matlack (23):
      KVM: x86/mmu: Move SPTE writable invariant checks to a helper function
      KVM: x86/mmu: Check SPTE writable invariants when setting leaf SPTEs
      KVM: x86/mmu: Move is_writable_pte() to spte.h
      KVM: x86/mmu: Rename DEFAULT_SPTE_MMU_WRITEABLE to DEFAULT_SPTE_MMU_WRITABLE
      KVM: x86/mmu: Consolidate comments about {Host,MMU}-writable
      KVM: x86/mmu: Rename rmap_write_protect() to kvm_vcpu_write_protect_gfn()
      KVM: x86/mmu: Rename __rmap_write_protect() to rmap_write_protect()
      KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
      KVM: x86/mmu: Change tdp_mmu_{set,zap}_spte_atomic() to return 0/-EBUSY
      KVM: x86/mmu: Rename TDP MMU functions that handle shadow pages
      KVM: x86/mmu: Rename handle_removed_tdp_mmu_page() to handle_removed_pt()
      KVM: x86/mmu: Consolidate logic to atomically install a new TDP MMU page table
      KVM: x86/mmu: Remove unnecessary warnings from restore_acc_track_spte()
      KVM: x86/mmu: Drop new_spte local variable from restore_acc_track_spte()
      KVM: x86/mmu: Move restore_acc_track_spte() to spte.h
      KVM: x86/mmu: Refactor TDP MMU iterators to take kvm_mmu_page root
      KVM: x86/mmu: Remove redundant role overrides for TDP MMU shadow pages
      KVM: x86/mmu: Derive page role for TDP MMU shadow pages from parent
      KVM: x86/mmu: Separate TDP MMU shadow page allocation and initialization
      KVM: x86/mmu: Split huge pages mapped by the TDP MMU when dirty logging is enabled
      KVM: x86/mmu: Split huge pages mapped by the TDP MMU during KVM_CLEAR_DIRTY_LOG
      KVM: x86/mmu: Add tracepoint for splitting huge pages
      KVM: selftests: Add an option to disable MANUAL_PROTECT_ENABLE and INITIALLY_SET

Guo Ren (1):
      KVM: compat: riscv: Prevent KVM_COMPAT from being selected

Hou Wenlong (3):
      KVM: x86/emulator: Defer not-present segment check in __load_segment_descriptor()
      KVM: x86/emulator: Fix wrong privilege check for code segment in __load_segment_descriptor()
      KVM: x86/emulator: Move the unhandled outer privilege level logic of far return into __load_segment_descriptor()

Janis Schoetterl-Glausch (16):
      s390/uaccess: Add copy_from/to_user_key functions
      KVM: s390: Honor storage keys when accessing guest memory
      KVM: s390: handle_tprot: Honor storage keys
      KVM: s390: selftests: Test TEST PROTECTION emulation
      KVM: s390: Add optional storage key checking to MEMOP IOCTL
      KVM: s390: Add vm IOCTL for key checked guest absolute memory access
      KVM: s390: Rename existing vcpu memop functions
      KVM: s390: Add capability for storage key extension of MEM_OP IOCTL
      KVM: s390: Update api documentation for memop ioctl
      KVM: s390: Clarify key argument for MEM_OP in api docs
      KVM: s390: Add missing vm MEM_OP size check
      KVM: s390: selftests: Split memop tests
      KVM: s390: selftests: Add macro as abstraction for MEM_OP
      KVM: s390: selftests: Add named stages for memop test
      KVM: s390: selftests: Add more copy memop tests
      KVM: s390: selftests: Add error memop tests

Jing Zhang (3):
      KVM: arm64: Use read/write spin lock for MMU protection
      KVM: arm64: Add fast path to handle permission relaxation during dirty logging
      KVM: selftests: Add vgic initialization for dirty log perf test for ARM

Jinrong Liang (13):
      KVM: x86/mmu: Remove unused "kvm" of kvm_mmu_unlink_parents()
      KVM: x86/mmu: Remove unused "kvm" of __rmap_write_protect()
      KVM: x86/mmu: Remove unused "vcpu" of reset_{tdp,ept}_shadow_zero_bits_mask()
      KVM: x86/tdp_mmu: Remove unused "kvm" of kvm_tdp_mmu_get_root()
      KVM: x86/mmu_audit: Remove unused "level" of audit_spte_after_sync()
      KVM: x86/svm: Remove unused "vcpu" of svm_check_exit_valid()
      KVM: x86/i8259: Remove unused "addr" of elcr_ioport_{read,write}()
      KVM: x86/ioapic: Remove unused "addr" and "length" of ioapic_read_indirect()
      KVM: x86/emulate: Remove unused "ctxt" of setup_syscalls_segments()
      KVM: x86/emulate: Remove unused "tss_selector" of task_switch_{16, 32}()
      KVM: x86: Remove unused "vcpu" of kvm_scale_tsc()
      KVM: Remove unused "kvm" of kvm_make_vcpu_request()
      KVM: x86: Remove unused "flags" of kvm_pv_kick_cpu_op()

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

Maxim Levitsky (1):
      KVM: x86: do not use KVM_X86_OP_OPTIONAL_RET0 for get_mt_mask

Michael Mueller (1):
      KVM: s390: pv: make use of ultravisor AIV support

Oliver Upton (10):
      KVM: arm64: Correctly treat writes to OSLSR_EL1 as undefined
      KVM: arm64: Stash OSLSR_EL1 in the cpu context
      KVM: arm64: Allow guest to set the OSLK bit
      KVM: arm64: Emulate the OS Lock
      selftests: KVM: Add OSLSR_EL1 to the list of blessed regs
      selftests: KVM: Test OS lock behavior
      KVM: arm64: Drop unused param from kvm_psci_version()
      KVM: VMX: Use local pointer to vcpu_vmx in vmx_vcpu_after_set_cpuid()
      Documentation: KVM: Update documentation to indicate KVM is arm64-only
      KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2

Paolo Bonzini (42):
      KVM: SVM: improve split between svm_prepare_guest_switch and sev_es_prepare_guest_switch
      KVM: x86: skip host CPUID call for hypervisor leaves
      Merge remote-tracking branch 'kvm/master' into HEAD
      selftests: KVM: allow sev_migrate_tests on machines without SEV-ES
      KVM: x86: return 1 unconditionally for availability of KVM_CAP_VAPIC
      KVM: x86: use static_call_cond for optional callbacks
      KVM: x86: remove KVM_X86_OP_NULL and mark optional kvm_x86_ops
      KVM: x86: warn on incorrectly NULL members of kvm_x86_ops
      KVM: x86: make several APIC virtualization callbacks optional
      KVM: x86: allow defining return-0 static calls
      Merge tag 'kvm-s390-next-5.18-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge branch 'kvm-ppc-cap-210' into kvm-next-5.18
      Merge branch 'kvm-hv-xmm-hypercall-fixes' into HEAD
      KVM: x86: Reinitialize context if host userspace toggles EFER.LME
      KVM: x86: do not deliver asynchronous page faults if CR0.PG=0
      KVM: x86/mmu: avoid NULL-pointer dereference on page freeing bugs
      KVM: x86: use struct kvm_mmu_root_info for mmu->root
      KVM: x86/mmu: do not consult levels when freeing roots
      KVM: x86/mmu: do not pass vcpu to root freeing functions
      KVM: x86/mmu: look for a cached PGD when going from 32-bit to 64-bit
      KVM: x86/mmu: load new PGD after the shadow MMU is initialized
      KVM: x86/mmu: Always use current mmu's role when loading new PGD
      KVM: x86/mmu: clear MMIO cache when unloading the MMU
      KVM: x86: flush TLB separately from MMU reset
      KVM: x86: Do not change ICR on write to APIC_SELF_IPI
      Merge branch 'kvm-bugfixes' into HEAD
      mm: vmalloc: introduce array allocation functions
      mm: use vmalloc_array and vcalloc for array allocations
      KVM: use __vcalloc for very large allocations
      KVM: x86/mmu: only perform eager page splitting on valid roots
      KVM: x86/mmu: do not allow readers to acquire references to invalid roots
      KVM: x86/mmu: Zap invalidated roots via asynchronous worker
      KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU root
      KVM: x86/mmu: Zap defunct roots via asynchronous worker
      Merge tag 'kvm-s390-next-5.18-2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvm-riscv-5.18-1' of https://github.com/kvm-riscv/linux into HEAD
      Merge tag 'kvmarm-5.18' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      kvm: x86/mmu: Flush TLB before zap_gfn_range releases RCU
      Revert "KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()"
      KVM: x86: add support for CPUID leaf 0x80000021
      KVM: x86: synthesize CPUID leaf 0x80000021h if useful
      KVM: use kvcalloc for array allocations

Peng Hao (3):
      KVM: nVMX: Make setup/unsetup under the same conditions
      kvm: vmx: Fix typos comment in __loaded_vmcs_clear()
      KVM: VMX: Remove scratch 'cpu' variable that shadows an identical scratch var

Peter Gonda (1):
      KVM: SEV: Allow SEV intra-host migration of VM with mirrors

Ricardo Koller (5):
      kvm: selftests: aarch64: fix assert in gicv3_access_reg
      kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
      kvm: selftests: aarch64: fix the failure check in kvm_set_gsi_routing_irqchip_check
      kvm: selftests: aarch64: fix some vgic related comments
      kvm: selftests: aarch64: use a tighter assert in vgic_poke_irq()

Sean Christopherson (75):
      KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap hook
      KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
      KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
      KVM: x86: Unexport __kvm_request_apicv_update()
      KVM: x86: Drop NULL check on kvm_x86_ops.check_apicv_inhibit_reasons
      KVM: x86: Skip APICv update if APICv is disable at the module level
      KVM: x86: Drop export for .tlb_flush_current() static_call key
      KVM: x86: Rename kvm_x86_ops pointers to align w/ preferred vendor names
      KVM: VMX: Call vmx_get_cpl() directly in handle_dr()
      KVM: x86: Use static_call() for .vcpu_deliver_sipi_vector()
      KVM: xen: Use static_call() for invoking kvm_x86_ops hooks
      KVM: nVMX: Refactor PMU refresh to avoid referencing kvm_x86_ops.pmu_ops
      KVM: x86: Uninline and export hv_track_root_tdp()
      KVM: x86: Unexport kvm_x86_ops
      KVM: x86: Use static_call() for copy/move encryption context ioctls()
      KVM: VMX: Rename VMX functions to conform to kvm_x86_ops names
      KVM: x86: Move get_cs_db_l_bits() helper to SVM
      KVM: SVM: Rename svm_flush_tlb() to svm_flush_tlb_current()
      KVM: SVM: Remove unused MAX_INST_SIZE #define
      KVM: x86: Use more verbose names for mem encrypt kvm_x86_ops hooks
      KVM: SVM: Rename SEV implemenations to conform to kvm_x86_ops hooks
      KVM: SVM: Rename hook implementations to conform to kvm_x86_ops' names
      KVM: x86: Get the number of Hyper-V sparse banks from the VARHEAD field
      KVM: x86: Refactor kvm_hv_flush_tlb() to reduce indentation
      KVM: x86: Add a helper to get the sparse VP_SET for IPIs and TLB flushes
      KVM: x86: Don't bother reading sparse banks that end up being ignored
      KVM: x86: Shove vp_bitmap handling down into sparse_set_to_vcpu_mask()
      KVM: x86: Reject fixeds-size Hyper-V hypercalls with non-zero "var_cnt"
      KVM: x86: Add checks for reserved-to-zero Hyper-V hypercall fields
      KVM: SVM: Rename AVIC helpers to use "avic" prefix instead of "svm"
      KVM: x86/mmu: Remove MMU auditing
      KVM: x86: Fix pointer mistmatch warning when patching RET0 static calls
      KVM: VMX: Handle APIC-write offset wrangling in VMX code
      KVM: x86: Use "raw" APIC register read for handling APIC-write VM-Exit
      KVM: SVM: Use common kvm_apic_write_nodecode() for AVIC write traps
      KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure
      KVM: x86: WARN if KVM emulates an IPI without clearing the BUSY flag
      KVM: x86: Make kvm_lapic_reg_{read,write}() static
      KVM: x86: Add helpers to handle 64-bit APIC MSR read/writes
      KVM: x86: Treat x2APIC's ICR as a 64-bit register, not two 32-bit regs
      KVM: x86: Make kvm_lapic_set_reg() a "private" xAPIC helper
      KVM: selftests: Add test to verify KVM handling of ICR
      KVM: x86: Invoke kvm_mmu_unload() directly on CR4.PCIDE change
      KVM: Drop kvm_reload_remote_mmus(), open code request in x86 users
      KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped
      KVM: s390: Replace KVM_REQ_MMU_RELOAD usage with arch specific request
      KVM: Drop KVM_REQ_MMU_RELOAD and update vcpu-requests.rst documentation
      KVM: WARN if is_unsync_root() is called on a root without a shadow page
      KVM: SVM: Exit to userspace on ENOMEM/EFAULT GHCB errors
      KVM: SVM: Disable preemption across AVIC load/put during APICv refresh
      KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU
      KVM: x86/mmu: Fix wrong/misleading comments in TDP MMU fast zap
      KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush logic
      KVM: x86/mmu: Document that zapping invalidated roots doesn't need to flush
      KVM: x86/mmu: Require mmu_lock be held for write in unyielding root iter
      KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP removal
      KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier change_spte
      KVM: x86/mmu: Drop RCU after processing each root in MMU notifier hooks
      KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
      KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in non-atomic path
      KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw values
      KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
      KVM: x86/mmu: Skip remote TLB flush when zapping all of TDP MMU
      KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
      KVM: x86/mmu: Require mmu_lock be held for write to zap TDP MMU range
      KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
      KVM: x86/mmu: Do remote TLB flush before dropping RCU in TDP MMU resched
      KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages
      KVM: x86/mmu: Zap roots in two passes to avoid inducing RCU stalls
      KVM: x86/mmu: Check for a REMOVED leaf SPTE before making the SPTE
      KVM: x86/mmu: WARN on any attempt to atomically update REMOVED SPTE
      KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION helper to utils
      KVM: selftests: Split out helper to allocate guest mem via memfd
      KVM: selftests: Define cpu_relax() helpers for s390 and x86
      KVM: selftests: Add test to populate a VM with the max possible guest mem

Shameer Kolothum (3):
      KVM: arm64: Introduce a new VMID allocator for KVM
      KVM: arm64: Make VMID bits accessible outside of allocator
      KVM: arm64: Make active_vmids invalid on vCPU schedule out

Suravee Suthikulpanit (1):
      KVM: SVM: Allow AVIC support on system w/ physical APIC ID > 255

Thomas Gleixner (1):
      kvm: x86: Require const tsc for RT

Thomas Huth (1):
      selftests: kvm: Check whether SIDA memop fails for normal guests

Vincent Chen (1):
      RISC-V: KVM: Refine __kvm_riscv_switch_to() implementation

Vipin Sharma (1):
      KVM: Move VM's worker kthreads back to the original cgroup before exiting.

Vitaly Kuznetsov (14):
      KVM: nSVM: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
      KVM: x86: Make kvm_hv_hypercall_enabled() static inline
      KVM: nSVM: Split off common definitions for Hyper-V on KVM and KVM on Hyper-V
      KVM: nSVM: Implement Enlightened MSR-Bitmap feature
      KVM: selftests: Adapt hyperv_cpuid test to the newly introduced Enlightened MSR-Bitmap
      KVM: selftests: nVMX: Properly deal with 'hv_clean_fields'
      KVM: selftests: nVMX: Add enlightened MSR-Bitmap selftest
      KVM: selftests: nSVM: Set up MSR-Bitmap for SVM guests
      KVM: selftests: nSVM: Update 'struct vmcb_control_area' definition
      KVM: selftests: nSVM: Add enlightened MSR-Bitmap selftest
      KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_send_ipi()
      KVM: x86: hyper-v: Drop redundant 'ex' parameter from kvm_hv_flush_tlb()
      KVM: x86: hyper-v: Fix the maximum number of sparse banks for XMM fast TLB flush hypercalls
      KVM: x86: hyper-v: HVCALL_SEND_IPI_EX is an XMM fast hypercall

Wanpeng Li (2):
      KVM: VMX: Dont' send posted IRQ if vCPU == this vCPU and vCPU is IN_GUEST_MODE
      KVM: LAPIC: Enable timer posted-interrupt only when mwait/hlt is advertised

Will Deacon (4):
      KVM: arm64: Bump guest PSCI version to 1.1
      KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest
      KVM: arm64: Indicate SYSTEM_RESET2 in kvm_run::system_event flags field
      KVM: arm64: Really propagate PSCI SYSTEM_RESET2 arguments to userspace

Yang Li (1):
      RISC-V: KVM: remove unneeded semicolon

Zhenzhong Duan (1):
      KVM: x86: Fix emulation in writing cr8

 Documentation/admin-guide/kernel-parameters.txt    |  30 +-
 Documentation/virt/kvm/api.rst                     | 276 ++++--
 Documentation/virt/kvm/devices/vcpu.rst            |  36 +-
 Documentation/virt/kvm/vcpu-requests.rst           |   7 +-
 MAINTAINERS                                        |   2 +-
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/include/asm/kvm_host.h                  |  45 +-
 arch/arm64/include/asm/kvm_mmu.h                   |   4 +-
 arch/arm64/include/asm/sysreg.h                    |   8 +
 arch/arm64/include/uapi/asm/kvm.h                  |  11 +
 arch/arm64/kernel/fpsimd.c                         |   8 +-
 arch/arm64/kernel/image-vars.h                     |   3 +
 arch/arm64/kvm/Makefile                            |   2 +-
 arch/arm64/kvm/arm.c                               | 142 +--
 arch/arm64/kvm/debug.c                             |  26 +-
 arch/arm64/kvm/fpsimd.c                            |  14 +-
 arch/arm64/kvm/guest.c                             |   2 +-
 arch/arm64/kvm/handle_exit.c                       |   2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   4 +
 arch/arm64/kvm/hyp/nvhe/Makefile                   |   3 +-
 arch/arm64/kvm/hyp/nvhe/list_debug.c               |  54 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   3 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |   4 +-
 arch/arm64/kvm/hyp/nvhe/stub.c                     |  22 -
 arch/arm64/kvm/mmio.c                              |   3 +-
 arch/arm64/kvm/mmu.c                               |  52 +-
 arch/arm64/kvm/pmu-emul.c                          | 141 ++-
 arch/arm64/kvm/psci.c                              |  66 +-
 arch/arm64/kvm/sys_regs.c                          |  74 +-
 arch/arm64/kvm/vgic/vgic.c                         |   2 +-
 arch/arm64/kvm/vmid.c                              | 196 ++++
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   2 +-
 arch/riscv/include/asm/kvm_host.h                  |   1 +
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   5 +-
 arch/riscv/include/asm/sbi.h                       |  27 +-
 arch/riscv/kernel/cpu_ops_sbi.c                    |   2 +-
 arch/riscv/kvm/vcpu_exit.c                         |  22 +-
 arch/riscv/kvm/vcpu_sbi.c                          |  19 +
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  18 +-
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  44 +
 arch/riscv/kvm/vcpu_sbi_v01.c                      |  20 +-
 arch/riscv/kvm/vcpu_switch.S                       |  60 +-
 arch/s390/include/asm/ctl_reg.h                    |   2 +
 arch/s390/include/asm/kvm_host.h                   |   2 +
 arch/s390/include/asm/page.h                       |   2 +
 arch/s390/include/asm/uaccess.h                    |  22 +
 arch/s390/include/asm/uv.h                         |   1 +
 arch/s390/kvm/gaccess.c                            | 250 +++++-
 arch/s390/kvm/gaccess.h                            |  84 +-
 arch/s390/kvm/intercept.c                          |  12 +-
 arch/s390/kvm/interrupt.c                          |  54 +-
 arch/s390/kvm/kvm-s390.c                           | 170 +++-
 arch/s390/kvm/kvm-s390.h                           |  17 +-
 arch/s390/kvm/priv.c                               |  81 +-
 arch/s390/lib/uaccess.c                            |  81 +-
 arch/x86/include/asm/kvm-x86-ops.h                 | 117 +--
 arch/x86/include/asm/kvm_host.h                    |  73 +-
 arch/x86/include/asm/svm.h                         |   2 +-
 arch/x86/kvm/Kconfig                               |   7 -
 arch/x86/kvm/cpuid.c                               |  59 +-
 arch/x86/kvm/emulate.c                             |  71 +-
 arch/x86/kvm/hyperv.c                              | 242 ++---
 arch/x86/kvm/hyperv.h                              |   6 +-
 arch/x86/kvm/i8259.c                               |   8 +-
 arch/x86/kvm/ioapic.c                              |   6 +-
 arch/x86/kvm/kvm_onhyperv.c                        |  14 +
 arch/x86/kvm/kvm_onhyperv.h                        |  14 +-
 arch/x86/kvm/lapic.c                               | 227 +++--
 arch/x86/kvm/lapic.h                               |  17 +-
 arch/x86/kvm/mmu.h                                 |  44 +-
 arch/x86/kvm/mmu/mmu.c                             | 502 ++++++-----
 arch/x86/kvm/mmu/mmu_audit.c                       | 303 -------
 arch/x86/kvm/mmu/mmu_internal.h                    |  15 +-
 arch/x86/kvm/mmu/mmutrace.h                        |  23 +
 arch/x86/kvm/mmu/page_track.c                      |   7 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   4 +-
 arch/x86/kvm/mmu/spte.c                            |  72 +-
 arch/x86/kvm/mmu/spte.h                            | 129 ++-
 arch/x86/kvm/mmu/tdp_iter.c                        |  14 +-
 arch/x86/kvm/mmu/tdp_iter.h                        |  25 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         | 986 ++++++++++++++-------
 arch/x86/kvm/mmu/tdp_mmu.h                         |  31 +-
 arch/x86/kvm/svm/avic.c                            | 181 ++--
 arch/x86/kvm/svm/hyperv.h                          |  35 +
 arch/x86/kvm/svm/nested.c                          |  51 +-
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/svm/sev.c                             | 121 +--
 arch/x86/kvm/svm/svm.c                             | 134 ++-
 arch/x86/kvm/svm/svm.h                             |  69 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |  25 +-
 arch/x86/kvm/trace.h                               |  20 +-
 arch/x86/kvm/vmx/nested.c                          |  21 +-
 arch/x86/kvm/vmx/nested.h                          |   3 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   5 +-
 arch/x86/kvm/vmx/posted_intr.c                     |   6 +-
 arch/x86/kvm/vmx/posted_intr.h                     |   4 +-
 arch/x86/kvm/vmx/vmx.c                             | 116 +--
 arch/x86/kvm/x86.c                                 | 285 +++---
 arch/x86/kvm/x86.h                                 |   2 +
 arch/x86/kvm/xen.c                                 |   4 +-
 include/asm-generic/hyperv-tlfs.h                  |   7 +
 include/kvm/arm_pmu.h                              |   5 +
 include/kvm/arm_psci.h                             |   9 +-
 include/linux/kvm_host.h                           |   4 +-
 include/linux/perf_event.h                         |   2 +-
 include/linux/vmalloc.h                            |   5 +
 include/uapi/linux/kvm.h                           |  15 +-
 include/uapi/linux/psci.h                          |   4 +
 kernel/static_call.c                               |   1 +
 mm/percpu-stats.c                                  |   2 +-
 mm/swap_cgroup.c                                   |   4 +-
 mm/util.c                                          |  50 ++
 tools/arch/arm64/include/uapi/asm/kvm.h            |   1 +
 tools/include/uapi/linux/kvm.h                     |   4 +
 tools/testing/selftests/kvm/.gitignore             |   3 +
 tools/testing/selftests/kvm/Makefile               |   4 +
 .../selftests/kvm/aarch64/debug-exceptions.c       |  58 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |   1 +
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |  45 +-
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  23 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |   8 +
 .../selftests/kvm/include/s390x/processor.h        |   8 +
 tools/testing/selftests/kvm/include/x86_64/apic.h  |   1 +
 tools/testing/selftests/kvm/include/x86_64/evmcs.h | 150 +++-
 .../selftests/kvm/include/x86_64/processor.h       |   5 +
 tools/testing/selftests/kvm/include/x86_64/svm.h   |   9 +-
 .../selftests/kvm/include/x86_64/svm_util.h        |   6 +
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |  12 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |   9 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  87 +-
 tools/testing/selftests/kvm/lib/x86_64/svm.c       |   6 +
 .../testing/selftests/kvm/max_guest_memory_test.c  | 292 ++++++
 tools/testing/selftests/kvm/s390x/memop.c          | 732 ++++++++++++---
 tools/testing/selftests/kvm/s390x/tprot.c          | 227 +++++
 .../testing/selftests/kvm/set_memory_region_test.c |  35 +-
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |  64 +-
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |  29 +-
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c | 175 ++++
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |  33 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c       | 125 ++-
 .../selftests/kvm/x86_64/xapic_state_test.c        | 150 ++++
 virt/kvm/Kconfig                                   |   2 +-
 virt/kvm/kvm_main.c                                |  40 +-
 143 files changed, 6279 insertions(+), 2516 deletions(-)

