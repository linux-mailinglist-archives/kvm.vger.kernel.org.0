Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51B048F050
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 20:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244033AbiANTOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 14:14:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24917 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234615AbiANTOJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 14:14:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642187648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1t5rLLFydDMFM3PO8c16/IDFSJ2TtiybOotosUxAb8g=;
        b=OjG/ayqJBe4fn4WNBwaifPp3dD5RnqMQyzEze8hGYvknwYO/lVwdTgU1w7dOGz1jDWMGXc
        SWlyuZD3JMp0R32pPAIIfEToe8TmY3N7mGPK/vtECf4HaYZduCjqPpjFYX0vrl8ZpPPWuZ
        lNDubo8YDqgNAH1zkJYex69/9eClhrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-Y_Y0srPTPg6DlHzut0vLQA-1; Fri, 14 Jan 2022 14:14:04 -0500
X-MC-Unique: Y_Y0srPTPg6DlHzut0vLQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B6E81F6AC;
        Fri, 14 Jan 2022 19:14:03 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E0B25D6D5;
        Fri, 14 Jan 2022 19:14:03 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 5.17
Date:   Fri, 14 Jan 2022 14:14:02 -0500
Message-Id: <20220114191402.808664-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit fdba608f15e2427419997b0898750a49a735afcb:

  KVM: VMX: Wake vCPU when delivering posted IRQ even if vCPU == this vCPU (2021-12-21 12:39:03 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to c862dcd199759d4a45e65dab47b03e3e8a144e3a:

  x86/fpu: Fix inline prefix warnings (2022-01-14 13:48:38 -0500)

----------------------------------------------------------------
RISCV:
- Use common KVM implementation of MMU memory caches

- SBI v0.2 support for Guest

- Initial KVM selftests support

- Fix to avoid spurious virtual interrupts after clearing hideleg CSR

- Update email address for Anup and Atish

ARM:
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

s390:
- fix sigp sense/start/stop/inconsistency

- cleanups

x86:
- Clean up some function prototypes more

- improved gfn_to_pfn_cache with proper invalidation, used by Xen emulation

- add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery

- completely remove potential TOC/TOU races in nested SVM consistency checks

- update some PMCs on emulated instructions

- Intel AMX support (joint work between Thomas and Intel)

- large MMU cleanups

- module parameter to disable PMU virtualization

- cleanup register cache

- first part of halt handling cleanups

- Hyper-V enlightened MSR bitmap support for nested hypervisors

Generic:
- clean up Makefiles

- introduce CONFIG_HAVE_KVM_DIRTY_RING

- optimize memslot lookup using a tree

- optimize vCPU array usage by converting to xarray

----------------------------------------------------------------
Two notes:

1) Despite the AMX commits having very new commit dates, they have been in
linux-next since before the merge window started.  Borislav Petkov spotted
incomplete Signed-off-by chains that I only just got round to reconstruct
and fix.  I'll check with other people if they have scripts to check this,
there ought to be some kind of commit hook in scripts/ that maintainers
can use.

2) A cleanup to the guest perf events came in through the tip tree.
Unfortunately, while I was aware of the series, I missed that it had
been accepted and therefore didn't ask Peter for a topic branch.
Therefore there will be a conflict in both arch/arm64 and arch/x86.
Not big but still a bit annoying.  The resolution is kvm-5.17-conflict
on the https://git.kernel.org/pub/scm/virt/kvm/kvm.git tree.
and at the end of the message, but the gist of it is just this:

- 	if (in_pmi && !kvm_is_in_guest())
++	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
 +		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 +	else
 +		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);

Thanks,

Paolo

Andy Shevchenko (1):
      KVM: arm64: vgic: Replace kernel.h with the necessary inclusions

Anup Patel (5):
      RISC-V: KVM: Forward SBI experimental and vendor extensions
      RISC-V: KVM: Add VM capability to allow userspace get GPA bits
      KVM: selftests: Add EXTRA_CFLAGS in top-level Makefile
      KVM: selftests: Add initial support for RISC-V 64-bit
      MAINTAINERS: Update Anup's email address

Atish Patra (6):
      RISC-V: KVM: Mark the existing SBI implementation as v0.1
      RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file
      RISC-V: KVM: Add SBI v0.2 base extension
      RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2
      RISC-V: KVM: Add SBI HSM extension in KVM
      MAINTAINERS: Update Atish's email address

Ben Gardon (4):
      KVM: x86/mmu: Remove need for a vcpu from kvm_slot_page_track_is_active
      KVM: x86/mmu: Remove need for a vcpu from mmu_try_to_unsync_pages
      KVM: x86/mmu: Propagate memslot const qualifier
      KVM: x86/MMU: Simplify flow of vmx_get_mt_mask

David Woodhouse (13):
      KVM: Introduce CONFIG_HAVE_KVM_DIRTY_RING
      KVM: Add Makefile.kvm for common files, use it for x86
      KVM: s390: Use Makefile.kvm for common files
      KVM: mips: Use Makefile.kvm for common files
      KVM: RISC-V: Use Makefile.kvm for common files
      KVM: powerpc: Use Makefile.kvm for common files
      KVM: arm64: Use Makefile.kvm for common files
      x86/kvm: Silence per-cpu pr_info noise about KVM clocks and steal time
      KVM: Warn if mark_page_dirty() is called without an active vCPU
      KVM: Reinstate gfn_to_pfn_cache with invalidation support
      KVM: x86/xen: Maintain valid mapping of Xen shared_info page
      KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery
      KVM: x86: Fix wall clock writes in Xen shared_info not to mark page dirty

Emanuele Giuseppe Esposito (6):
      KVM: nSVM: move nested_vmcb_check_cr3_cr4 logic in nested_vmcb_valid_sregs
      KVM: nSVM: introduce svm->nested.save to cache save area before checks
      KVM: nSVM: rename nested_load_control_from_vmcb12 in nested_copy_vmcb_control_to_cache
      KVM: nSVM: use vmcb_save_area_cached in nested_vmcb_valid_sregs()
      KVM: nSVM: use svm->nested.save to load vmcb12 registers and avoid TOC/TOU races
      KVM: nSVM: introduce struct vmcb_ctrl_area_cached

Eric Farman (1):
      KVM: s390: Clarify SIGP orders versus STOP/RESTART

Eric Hankland (2):
      KVM: x86: Update vPMCs when retiring instructions
      KVM: x86: Update vPMCs when retiring branch instructions

Fuad Tabba (3):
      KVM: arm64: Use defined value for SCTLR_ELx_EE
      KVM: arm64: Fix comment for kvm_reset_vcpu()
      KVM: arm64: Fix comment on barrier in kvm_psci_vcpu_on()

Guang Zeng (1):
      kvm: x86: Add support for getting/setting expanded xstate buffer

Hou Wenlong (3):
      KVM: x86: Add an emulation type to handle completion of user exits
      KVM: x86: Use different callback if msr access comes from the emulator
      KVM: x86: Exit to userspace if emulation prepared a completion callback

Janis Schoetterl-Glausch (4):
      KVM: s390: Fix names of skey constants in api documentation
      KVM: s390: gaccess: Refactor gpa and length calculation
      KVM: s390: gaccess: Refactor access address range check
      KVM: s390: gaccess: Cleanup access to guest pages

Janosch Frank (1):
      s390: uv: Add offset comments to UV query struct and fix naming

Jing Liu (11):
      kvm: x86: Fix xstate_required_size() to follow XSTATE alignment rule
      kvm: x86: Exclude unpermitted xfeatures at KVM_GET_SUPPORTED_CPUID
      x86/fpu: Make XFD initialization in __fpstate_reset() a function argument
      kvm: x86: Enable dynamic xfeatures at KVM_SET_CPUID2
      kvm: x86: Add emulation for IA32_XFD
      x86/fpu: Prepare xfd_err in struct fpu_guest
      kvm: x86: Intercept #NM for saving IA32_XFD_ERR
      kvm: x86: Emulate IA32_XFD_ERR for guest
      kvm: x86: Disable RDMSR interception of IA32_XFD_ERR
      kvm: x86: Add XCR0 support for Intel AMX
      kvm: x86: Add CPUID support for Intel AMX

Jing Zhang (1):
      KVM: stats: Add stat to detect if vcpu is currently blocking

Jisheng Zhang (1):
      RISC-V: KVM: make kvm_riscv_vcpu_fp_clean() static

Kevin Tian (2):
      x86/fpu: Provide fpu_update_guest_xfd() for IA32_XFD emulation
      kvm: x86: Disable interception for IA32_XFD on demand

Lai Jiangshan (34):
      KVM: X86: Ensure that dirty PDPTRs are loaded
      KVM: VMX: Mark VCPU_EXREG_PDPTR available in ept_save_pdptrs()
      KVM: SVM: Track dirtiness of PDPTRs even if NPT is disabled
      KVM: VMX: Add and use X86_CR4_TLBFLUSH_BITS when !enable_ept
      KVM: VMX: Add and use X86_CR4_PDPTR_BITS when !enable_ept
      KVM: X86: Move CR0 pdptr_bits into header file as X86_CR0_PDPTR_BITS
      KVM: SVM: Remove outdated comment in svm_load_mmu_pgd()
      KVM: SVM: Remove references to VCPU_EXREG_CR3
      KVM: X86: Mark CR3 dirty when vcpu->arch.cr3 is changed
      KVM: VMX: Update vmcs.GUEST_CR3 only when the guest CR3 is dirty
      KVM: X86: Remove kvm_register_clear_available()
      KVM: X86: Update mmu->pdptrs only when it is changed
      KVM: VMX: Avoid to rdmsrl(MSR_IA32_SYSENTER_ESP)
      KVM: VMX: Update msr value after kvm_set_user_return_msr() succeeds
      KVM: VMX: Save HOST_CR3 in vmx_prepare_switch_to_guest()
      KVM: VMX: Use kvm_set_msr_common() for MSR_IA32_TSC_ADJUST in the default way
      KVM: VMX: Change comments about vmx_get_msr()
      KVM: SVM: Rename get_max_npt_level() to get_npt_level()
      KVM: SVM: Allocate sd->save_area with __GFP_ZERO
      KVM: X86: Skip allocating pae_root for vcpu->arch.guest_mmu when !tdp_enabled
      KVM: X86: Fix comment in __kvm_mmu_create()
      KVM: X86: Remove unused declaration of __kvm_mmu_free_some_pages()
      KVM: X86: Remove useless code to set role.gpte_is_8_bytes when role.direct
      KVM: X86: Calculate quadrant when !role.gpte_is_8_bytes
      KVM: X86: Add parameter struct kvm_mmu *mmu into mmu->gva_to_gpa()
      KVM: X86: Remove mmu->translate_gpa
      KVM: X86: Add huge_page_level to __reset_rsvds_bits_mask_ept()
      KVM: X86: Add parameter huge_page_level to kvm_init_shadow_ept_mmu()
      KVM: VMX: Use ept_caps_to_lpage_level() in hardware_setup()
      KVM: X86: Rename gpte_is_8_bytes to has_4_byte_gpte and invert the direction
      KVM: X86: Remove mmu parameter from load_pdptrs()
      KVM: VMX: Save HOST_CR3 in vmx_set_host_fs_gs()
      KVM: x86/mmu: Reconstruct shadow page root if the guest PDPTEs is changed
      KVM: VMX: Mark VCPU_EXREG_CR3 dirty when !CR0_PG -> CR0_PG if EPT + !URG

Li RongQing (2):
      KVM: x86: don't print when fail to read/write pv eoi memory
      KVM: Clear pv eoi pending bit only when it is set

Like Xu (5):
      KVM: x86/svm: Add module param to control PMU virtualization
      KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
      KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()
      KVM: x86/pmu: Reuse pmc_perf_hw_id() and drop find_fixed_event()
      KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()

Maciej S. Szmigiero (12):
      KVM: Resync only arch fields when slots_arch_lock gets reacquired
      KVM: x86: Don't call kvm_mmu_change_mmu_pages() if the count hasn't changed
      KVM: x86: Use nr_memslot_pages to avoid traversing the memslots array
      KVM: Integrate gfn_to_memslot_approx() into search_memslots()
      KVM: Move WARN on invalid memslot index to update_memslots()
      KVM: Resolve memslot ID via a hash table instead of via a static array
      KVM: Use interval tree to do fast hva lookup in memslots
      KVM: s390: Introduce kvm_s390_get_gfn_end()
      KVM: Keep memslots in tree-based structures instead of array-based ones
      KVM: Call kvm_arch_flush_shadow_memslot() on the old slot in kvm_invalidate_memslot()
      KVM: Optimize gfn lookup in kvm_zap_gfn_range()
      KVM: Optimize overlapping memslots check

Marc Zyngier (39):
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
      KVM: Move wiping of the kvm->vcpus array to common code
      KVM: mips: Use kvm_get_vcpu() instead of open-coded access
      KVM: s390: Use kvm_get_vcpu() instead of open-coded access
      KVM: Convert the kvm->vcpus array to a xarray
      KVM: Use 'unsigned long' as kvm_for_each_vcpu()'s index
      KVM: Convert kvm_for_each_vcpu() to using xa_for_each_range()
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

Maxim Levitsky (1):
      KVM: x86: add a tracepoint for APICv/AVIC interrupt delivery

Michael Roth (3):
      KVM: SVM: include CR3 in initial VMSA state for SEV-ES guests
      kvm: selftests: move base kvm_util.h declarations to kvm_util_base.h
      kvm: selftests: move ucall declarations into ucall_common.h

Paolo Bonzini (14):
      KVM: MMU: update comment on the number of page role combinations
      KVM: nSVM: split out __nested_vmcb_check_controls
      KVM: Avoid atomic operations when kicking the running vCPU
      KVM: VMX: Don't unblock vCPU w/ Posted IRQ if IRQs are disabled in guest
      KVM: vmx, svm: clean up mass updates to regs_avail/regs_dirty bits
      Merge branch 'kvm-on-hv-msrbm-fix' into HEAD
      Merge branch 'topic/ppc-kvm' of https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux into HEAD
      Merge remote-tracking branch 'kvm/master' into HEAD
      Merge tag 'kvm-s390-next-5.17-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      Merge tag 'kvmarm-5.17' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge tag 'kvm-riscv-5.17-1' of https://github.com/kvm-riscv/linux into HEAD
      Revert "KVM: X86: Update mmu->pdptrs only when it is changed"
      KVM: x86: avoid out of bounds indices for fixed performance counters
      selftest: kvm: Reorder vcpu_load_state steps for AMX

Peter Gonda (3):
      selftests: KVM: sev_migrate_tests: Fix test_sev_mirror()
      selftests: KVM: sev_migrate_tests: Fix sev_ioctl()
      selftests: KVM: sev_migrate_tests: Add mirror command tests

Peter Zijlstra (1):
      KVM: VMX: Provide vmread version using asm-goto-with-outputs

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

Sean Christopherson (48):
      KVM: Require total number of memslot pages to fit in an unsigned long
      KVM: Open code kvm_delete_memslot() into its only caller
      KVM: Use "new" memslot's address space ID instead of dedicated param
      KVM: Let/force architectures to deal with arch specific memslot data
      KVM: arm64: Use "new" memslot instead of userspace memory region
      KVM: MIPS: Drop pr_debug from memslot commit to avoid using "mem"
      KVM: PPC: Avoid referencing userspace memory region in memslot updates
      KVM: s390: Use "new" memslot instead of userspace memory region
      KVM: x86: Use "new" memslot instead of userspace memory region
      KVM: RISC-V: Use "new" memslot instead of userspace memory region
      KVM: Stop passing kvm_userspace_memory_region to arch memslot hooks
      KVM: Use prepare/commit hooks to handle generic memslot metadata updates
      KVM: x86: Don't assume old/new memslots are non-NULL at memslot commit
      KVM: s390: Skip gfn/size sanity checks on memslot DELETE or FLAGS_ONLY
      KVM: Don't make a full copy of the old memslot in __kvm_set_memory_region()
      KVM: Wait 'til the bitter end to initialize the "new" memslot
      KVM: Dynamically allocate "new" memslots from the get-go
      KVM: x86/mmu: Use shadow page role to detect PML-unfriendly pages for L2
      KVM: SVM: Ensure target pCPU is read once when signalling AVIC doorbell
      KVM: s390: Ensure kvm_arch_no_poll() is read once when blocking vCPU
      KVM: Force PPC to define its own rcuwait object
      KVM: Update halt-polling stats if and only if halt-polling was attempted
      KVM: Refactor and document halt-polling stats update helper
      KVM: Reconcile discrepancies in halt-polling stats
      KVM: s390: Clear valid_wakeup in kvm_s390_handle_wait(), not in arch hook
      KVM: arm64: Move vGIC v4 handling for WFI out arch callback hook
      KVM: Don't block+unblock when halt-polling is successful
      KVM: x86: Tweak halt emulation helper names to free up kvm_vcpu_halt()
      KVM: Drop obsolete kvm_arch_vcpu_block_finish()
      KVM: Rename kvm_vcpu_block() => kvm_vcpu_halt()
      KVM: Split out a kvm_vcpu_block() helper from kvm_vcpu_halt()
      KVM: Don't redo ktime_get() when calculating halt-polling stop/deadline
      KVM: x86: Directly block (instead of "halting") UNINITIALIZED vCPUs
      KVM: x86: Invoke kvm_vcpu_block() directly for non-HALTED wait states
      KVM: Add helpers to wake/query blocking vCPU
      KVM: VMX: Skip Posted Interrupt updates if APICv is hard disabled
      KVM: VMX: Drop unnecessary PI logic to handle impossible conditions
      KVM: VMX: Use boolean returns for Posted Interrupt "test" helpers
      KVM: VMX: Drop pointless PI.NDST update when blocking
      KVM: VMX: Save/restore IRQs (instead of CLI/STI) during PI pre/post block
      KVM: VMX: Read Posted Interrupt "control" exactly once per loop iteration
      KVM: VMX: Move Posted Interrupt ndst computation out of write loop
      KVM: VMX: Remove vCPU from PI wakeup list before updating PID.NV
      KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code seg
      KVM: nVMX: Ensure vCPU honors event request if posting nested IRQ fails
      KVM: VMX: Clean up PI pre/post-block WARNs
      KVM: RISC-V: Use common KVM implementation of MMU memory caches
      x86/fpu: Provide fpu_enable_guest_xfd_features() for KVM

Thomas Gleixner (5):
      x86/fpu: Extend fpu_xstate_prctl() with guest permissions
      x86/fpu: Prepare guest FPU for dynamically enabled FPU features
      x86/fpu: Add guest support to xfd_enable_feature()
      x86/fpu: Add uabi_size to guest_fpu
      x86/fpu: Provide fpu_sync_guest_vmexit_xfd_state()

Vihas Mak (1):
      KVM: x86: change TLB flush indicator to bool

Vincent Chen (1):
      KVM: RISC-V: Avoid spurious virtual interrupts after clearing hideleg CSR

Vitaly Kuznetsov (4):
      KVM: Drop stale kvm_is_transparent_hugepage() declaration
      KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
      KVM: nVMX: Track whether changes in L0 require MSR bitmap for L2 to be rebuilt
      KVM: nVMX: Implement Enlightened MSR Bitmap feature

Wei Wang (1):
      kvm: selftests: Add support for KVM_CAP_XSAVE2

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

Yang Zhong (3):
      selftest: kvm: Move struct kvm_x86_state to header
      selftest: kvm: Add amx selftest
      x86/fpu: Fix inline prefix warnings

Zenghui Yu (1):
      KVM: arm64: Fix comment typo in kvm_vcpu_finalize_sve()

 .mailmap                                           |    2 +
 Documentation/virt/kvm/api.rst                     |   85 +-
 Documentation/virt/kvm/mmu.rst                     |    8 +-
 MAINTAINERS                                        |    4 +-
 arch/arm64/include/asm/kvm_asm.h                   |    1 +
 arch/arm64/include/asm/kvm_emulate.h               |    4 +-
 arch/arm64/include/asm/kvm_host.h                  |   47 +-
 arch/arm64/include/asm/kvm_hyp.h                   |    1 -
 arch/arm64/include/asm/kvm_mmu.h                   |    2 +
 arch/arm64/include/asm/kvm_pgtable.h               |   30 +-
 arch/arm64/include/asm/kvm_pkvm.h                  |   71 ++
 arch/arm64/include/asm/mmu.h                       |    1 +
 arch/arm64/include/asm/sysreg.h                    |    1 +
 arch/arm64/kernel/asm-offsets.c                    |    1 -
 arch/arm64/kernel/fpsimd.c                         |    6 +-
 arch/arm64/kvm/.gitignore                          |    2 +
 arch/arm64/kvm/Kconfig                             |    1 +
 arch/arm64/kvm/Makefile                            |   22 +-
 arch/arm64/kvm/arch_timer.c                        |   13 +-
 arch/arm64/kvm/arm.c                               |  128 ++-
 arch/arm64/kvm/fpsimd.c                            |   79 +-
 arch/arm64/kvm/handle_exit.c                       |    5 +-
 arch/arm64/kvm/hyp/Makefile                        |    2 +-
 arch/arm64/kvm/hyp/fpsimd.S                        |    6 -
 arch/arm64/kvm/hyp/hyp-constants.c                 |   10 +
 arch/arm64/kvm/hyp/include/hyp/switch.h            |   30 +-
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |    6 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |   59 --
 arch/arm64/kvm/hyp/nvhe/early_alloc.c              |    5 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |    8 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  505 ++++++++--
 arch/arm64/kvm/hyp/nvhe/mm.c                       |    4 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |    2 +-
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   25 +-
 arch/arm64/kvm/hyp/nvhe/switch.c                   |    1 -
 arch/arm64/kvm/hyp/pgtable.c                       |  108 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |    1 -
 arch/arm64/kvm/mmu.c                               |  177 +++-
 arch/arm64/kvm/{hyp/reserved_mem.c => pkvm.c}      |    8 +-
 arch/arm64/kvm/pmu-emul.c                          |    3 +-
 arch/arm64/kvm/psci.c                              |   10 +-
 arch/arm64/kvm/reset.c                             |   30 +-
 arch/arm64/kvm/vgic/vgic-init.c                    |   12 +-
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |    2 +-
 arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |    3 +-
 arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   15 +-
 arch/arm64/kvm/vgic/vgic-mmio.c                    |    2 +-
 arch/arm64/kvm/vgic/vgic-mmio.h                    |    2 +-
 arch/arm64/kvm/vgic/vgic-v2.c                      |    9 +-
 arch/arm64/kvm/vgic/vgic-v3.c                      |   10 +-
 arch/arm64/kvm/vgic/vgic-v4.c                      |    5 +-
 arch/arm64/kvm/vgic/vgic.c                         |    2 +-
 arch/mips/include/asm/kvm_host.h                   |    1 -
 arch/mips/kvm/Kconfig                              |    1 +
 arch/mips/kvm/Makefile                             |    3 +-
 arch/mips/kvm/emulate.c                            |    2 +-
 arch/mips/kvm/loongson_ipi.c                       |    4 +-
 arch/mips/kvm/mips.c                               |   32 +-
 arch/powerpc/include/asm/kvm_host.h                |    2 +-
 arch/powerpc/include/asm/kvm_ppc.h                 |   14 +-
 arch/powerpc/kvm/Kconfig                           |    1 +
 arch/powerpc/kvm/Makefile                          |    8 +-
 arch/powerpc/kvm/book3s.c                          |   14 +-
 arch/powerpc/kvm/book3s_32_mmu.c                   |    2 +-
 arch/powerpc/kvm/book3s_64_mmu.c                   |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |    4 +-
 arch/powerpc/kvm/book3s_hv.c                       |   36 +-
 arch/powerpc/kvm/book3s_hv_nested.c                |    4 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c                 |   14 +-
 arch/powerpc/kvm/book3s_pr.c                       |   13 +-
 arch/powerpc/kvm/book3s_pr_papr.c                  |    2 +-
 arch/powerpc/kvm/book3s_xics.c                     |    6 +-
 arch/powerpc/kvm/book3s_xics.h                     |    2 +-
 arch/powerpc/kvm/book3s_xive.c                     |   15 +-
 arch/powerpc/kvm/book3s_xive.h                     |    4 +-
 arch/powerpc/kvm/book3s_xive_native.c              |    8 +-
 arch/powerpc/kvm/booke.c                           |    9 +-
 arch/powerpc/kvm/e500_emulate.c                    |    2 +-
 arch/powerpc/kvm/powerpc.c                         |   24 +-
 arch/riscv/include/asm/kvm_host.h                  |   12 +-
 arch/riscv/include/asm/kvm_types.h                 |    2 +-
 arch/riscv/include/asm/kvm_vcpu_sbi.h              |   33 +
 arch/riscv/include/asm/sbi.h                       |    9 +
 arch/riscv/kvm/Makefile                            |   10 +-
 arch/riscv/kvm/main.c                              |    8 +
 arch/riscv/kvm/mmu.c                               |  102 +-
 arch/riscv/kvm/vcpu.c                              |   28 +-
 arch/riscv/kvm/vcpu_exit.c                         |    2 +-
 arch/riscv/kvm/vcpu_fp.c                           |    2 +-
 arch/riscv/kvm/vcpu_sbi.c                          |  213 ++--
 arch/riscv/kvm/vcpu_sbi_base.c                     |   99 ++
 arch/riscv/kvm/vcpu_sbi_hsm.c                      |  105 ++
 arch/riscv/kvm/vcpu_sbi_replace.c                  |  135 +++
 arch/riscv/kvm/vcpu_sbi_v01.c                      |  126 +++
 arch/riscv/kvm/vm.c                                |   13 +-
 arch/riscv/kvm/vmid.c                              |    2 +-
 arch/s390/include/asm/kvm_host.h                   |    2 -
 arch/s390/include/asm/uv.h                         |   34 +-
 arch/s390/kvm/Kconfig                              |    1 +
 arch/s390/kvm/Makefile                             |    8 +-
 arch/s390/kvm/gaccess.c                            |  158 +--
 arch/s390/kvm/interrupt.c                          |   12 +-
 arch/s390/kvm/kvm-s390.c                           |  161 ++-
 arch/s390/kvm/kvm-s390.h                           |   19 +-
 arch/s390/kvm/pv.c                                 |    4 +-
 arch/s390/kvm/sigp.c                               |   28 +
 arch/x86/include/asm/cpufeatures.h                 |    2 +
 arch/x86/include/asm/fpu/api.h                     |   11 +
 arch/x86/include/asm/fpu/types.h                   |   32 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    1 +
 arch/x86/include/asm/kvm_host.h                    |   65 +-
 arch/x86/include/asm/kvm_page_track.h              |    6 +-
 arch/x86/include/uapi/asm/kvm.h                    |   16 +-
 arch/x86/include/uapi/asm/prctl.h                  |   26 +-
 arch/x86/kernel/fpu/core.c                         |   99 +-
 arch/x86/kernel/fpu/xstate.c                       |  147 ++-
 arch/x86/kernel/fpu/xstate.h                       |   19 +-
 arch/x86/kernel/kvm.c                              |    6 +-
 arch/x86/kernel/kvmclock.c                         |    2 +-
 arch/x86/kernel/process.c                          |    2 +
 arch/x86/kvm/Kconfig                               |    3 +
 arch/x86/kvm/Makefile                              |    7 +-
 arch/x86/kvm/cpuid.c                               |   88 +-
 arch/x86/kvm/cpuid.h                               |    2 +
 arch/x86/kvm/debugfs.c                             |    6 +-
 arch/x86/kvm/emulate.c                             |   55 +-
 arch/x86/kvm/hyperv.c                              |    9 +-
 arch/x86/kvm/i8254.c                               |    2 +-
 arch/x86/kvm/i8259.c                               |    5 +-
 arch/x86/kvm/ioapic.c                              |    4 +-
 arch/x86/kvm/irq_comm.c                            |   19 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   20 +-
 arch/x86/kvm/kvm_emulate.h                         |    1 +
 arch/x86/kvm/kvm_onhyperv.c                        |    3 +-
 arch/x86/kvm/lapic.c                               |   63 +-
 arch/x86/kvm/mmu.h                                 |   16 +-
 arch/x86/kvm/mmu/mmu.c                             |  151 ++-
 arch/x86/kvm/mmu/mmu_internal.h                    |    9 +-
 arch/x86/kvm/mmu/mmutrace.h                        |    2 +-
 arch/x86/kvm/mmu/page_track.c                      |    8 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |   48 +-
 arch/x86/kvm/mmu/spte.c                            |    6 +-
 arch/x86/kvm/mmu/spte.h                            |    2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |    2 +-
 arch/x86/kvm/pmu.c                                 |  128 ++-
 arch/x86/kvm/pmu.h                                 |    5 +-
 arch/x86/kvm/svm/avic.c                            |   16 +-
 arch/x86/kvm/svm/nested.c                          |  262 +++--
 arch/x86/kvm/svm/pmu.c                             |   23 +-
 arch/x86/kvm/svm/sev.c                             |    9 +-
 arch/x86/kvm/svm/svm.c                             |   66 +-
 arch/x86/kvm/svm/svm.h                             |   71 +-
 arch/x86/kvm/trace.h                               |   24 +
 arch/x86/kvm/vmx/capabilities.h                    |    9 +
 arch/x86/kvm/vmx/nested.c                          |   65 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   49 +-
 arch/x86/kvm/vmx/posted_intr.c                     |  159 +--
 arch/x86/kvm/vmx/posted_intr.h                     |    6 +-
 arch/x86/kvm/vmx/vmcs.h                            |    5 +
 arch/x86/kvm/vmx/vmx.c                             |  216 ++--
 arch/x86/kvm/vmx/vmx.h                             |   44 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |   27 +
 arch/x86/kvm/x86.c                                 |  405 +++++---
 arch/x86/kvm/x86.h                                 |    1 -
 arch/x86/kvm/xen.c                                 |  341 ++++++-
 arch/x86/kvm/xen.h                                 |    9 +
 include/kvm/arm_vgic.h                             |    4 +-
 include/linux/kvm_dirty_ring.h                     |   14 +-
 include/linux/kvm_host.h                           |  432 ++++++--
 include/linux/kvm_types.h                          |   19 +
 include/uapi/linux/kvm.h                           |   16 +
 tools/arch/x86/include/uapi/asm/kvm.h              |   16 +-
 tools/include/uapi/linux/kvm.h                     |    3 +
 tools/testing/selftests/kvm/.gitignore             |    1 +
 tools/testing/selftests/kvm/Makefile               |   16 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |    2 +-
 tools/testing/selftests/kvm/aarch64/get-reg-list.c |   50 +
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |  853 ++++++++++++++++
 tools/testing/selftests/kvm/include/aarch64/gic.h  |   26 +
 .../kvm/{lib => include}/aarch64/gic_v3.h          |   12 +
 .../selftests/kvm/include/aarch64/processor.h      |    3 +
 tools/testing/selftests/kvm/include/aarch64/vgic.h |   18 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |  409 +-------
 .../testing/selftests/kvm/include/kvm_util_base.h  |  399 ++++++++
 .../selftests/kvm/include/riscv/processor.h        |  135 +++
 tools/testing/selftests/kvm/include/ucall_common.h |   59 ++
 .../selftests/kvm/include/x86_64/processor.h       |   26 +-
 tools/testing/selftests/kvm/lib/aarch64/gic.c      |   66 ++
 .../selftests/kvm/lib/aarch64/gic_private.h        |   11 +
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |  206 +++-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   82 +-
 tools/testing/selftests/kvm/lib/aarch64/vgic.c     |  103 +-
 tools/testing/selftests/kvm/lib/guest_modes.c      |   59 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  126 +++
 tools/testing/selftests/kvm/lib/riscv/processor.c  |  362 +++++++
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |   87 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c |   95 +-
 tools/testing/selftests/kvm/x86_64/amx_test.c      |  448 ++++++++
 tools/testing/selftests/kvm/x86_64/evmcs_test.c    |    2 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c       |   59 +-
 tools/testing/selftests/kvm/x86_64/smm_test.c      |    2 +-
 tools/testing/selftests/kvm/x86_64/state_test.c    |    2 +-
 .../kvm/x86_64/vmx_preemption_timer_test.c         |    2 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  184 +++-
 virt/kvm/Kconfig                                   |    6 +
 virt/kvm/Makefile.kvm                              |   14 +
 virt/kvm/async_pf.c                                |    2 +-
 virt/kvm/dirty_ring.c                              |   11 +-
 virt/kvm/kvm_main.c                                | 1066 ++++++++++++--------
 virt/kvm/kvm_mm.h                                  |   44 +
 virt/kvm/mmu_lock.h                                |   23 -
 virt/kvm/pfncache.c                                |  337 +++++++
 212 files changed, 9043 insertions(+), 2907 deletions(-)

diff --cc arch/arm64/kvm/Kconfig
index f1f8fc069a97,e9761d84f982..3a9c8656b151
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@@ -39,7 -39,7 +39,8 @@@ menuconfig KV
  	select HAVE_KVM_IRQ_BYPASS
  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
  	select SCHED_INFO
 +	select INTERVAL_TREE
+ 	select GUEST_PERF_EVENTS if PERF_EVENTS
  	help
  	  Support hosting virtualized guest machines.
  
diff --cc arch/arm64/kvm/Makefile
index 39b11a4f9063,0bcc378b7961..e02bb7cb9dfa
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@@ -10,10 -10,12 +10,12 @@@ include $(srctree)/virt/kvm/Makefile.kv
  obj-$(CONFIG_KVM) += kvm.o
  obj-$(CONFIG_KVM) += hyp/
  
- kvm-y += arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
+ kvm-y := $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o \
+ 	 $(KVM)/vfio.o $(KVM)/irqchip.o $(KVM)/binary_stats.o \
 -	 arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
++	 arm.o mmu.o mmio.o psci.o perf.o hypercalls.o pvtime.o \
  	 inject_fault.o va_layout.o handle_exit.o \
  	 guest.o debug.o reset.o sys_regs.o \
 -	 vgic-sys-reg-v3.o fpsimd.o pmu.o \
 +	 vgic-sys-reg-v3.o fpsimd.o pmu.o pkvm.o \
  	 arch_timer.o trng.o\
  	 vgic/vgic.o vgic/vgic-init.o \
  	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
diff --cc arch/x86/kvm/pmu.c
index 8abdadb7e22a,0c2133eb4cf6..261b39cbef6e
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@@ -55,41 -55,43 +55,41 @@@ static void kvm_pmi_trigger_fn(struct i
  	kvm_pmu_deliver_pmi(vcpu);
  }
  
 -static void kvm_perf_overflow(struct perf_event *perf_event,
 -			      struct perf_sample_data *data,
 -			      struct pt_regs *regs)
 +static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
  {
 -	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
  	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
  
 -	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 -		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 -		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 -	}
 +	/* Ignore counters that have been reprogrammed already. */
 +	if (test_and_set_bit(pmc->idx, pmu->reprogram_pmi))
 +		return;
 +
 +	__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 +	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 +
 +	if (!pmc->intr)
 +		return;
 +
 +	/*
 +	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
 +	 * can be ejected on a guest mode re-entry. Otherwise we can't
 +	 * be sure that vcpu wasn't executing hlt instruction at the
 +	 * time of vmexit and is not going to re-enter guest mode until
 +	 * woken up. So we should wake it, but this is impossible from
 +	 * NMI context. Do it from irq work instead.
 +	 */
- 	if (in_pmi && !kvm_is_in_guest())
++	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
 +		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 +	else
 +		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
  }
  
 -static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 -				   struct perf_sample_data *data,
 -				   struct pt_regs *regs)
 +static void kvm_perf_overflow(struct perf_event *perf_event,
 +			      struct perf_sample_data *data,
 +			      struct pt_regs *regs)
  {
  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
 -	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 -
 -	if (!test_and_set_bit(pmc->idx, pmu->reprogram_pmi)) {
 -		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
 -		kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
  
 -		/*
 -		 * Inject PMI. If vcpu was in a guest mode during NMI PMI
 -		 * can be ejected on a guest mode re-entry. Otherwise we can't
 -		 * be sure that vcpu wasn't executing hlt instruction at the
 -		 * time of vmexit and is not going to re-enter guest mode until
 -		 * woken up. So we should wake it, but this is impossible from
 -		 * NMI context. Do it from irq work instead.
 -		 */
 -		if (!kvm_handling_nmi_from_guest(pmc->vcpu))
 -			irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
 -		else
 -			kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
 -	}
 +	__kvm_perf_overflow(pmc, true);
  }
  
  static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,

