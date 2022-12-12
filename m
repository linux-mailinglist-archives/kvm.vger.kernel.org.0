Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E0F64A46B
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiLLPvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 10:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232588AbiLLPvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 10:51:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AB46363
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 07:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670860232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=U4XOrVprWI4hXb3sSrycmKTuPRMoJosECuAGQavKBe8=;
        b=iOf3aeg6E7xgqR8WavWfKZTPc3qXCiVxtW5vnaKwMXzIkKmNNvQH1As9EtZV/Fa5nELyYz
        S5vEfkoMy0QMdK4xsUQ8BKEstVnAjLt/8/R2Kd7VSWHG/a8D5+SQuhZ/zFqlDmBmPJ/1Wt
        VAQzpr69wApeBn9d/MhvkREphvHrP/E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-ZVAbBAUYMualm6Gaa4lz3w-1; Mon, 12 Dec 2022 10:50:28 -0500
X-MC-Unique: ZVAbBAUYMualm6Gaa4lz3w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37C0C3C025B9;
        Mon, 12 Dec 2022 15:50:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B478492B00;
        Mon, 12 Dec 2022 15:50:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [GIT PULL] First batch of KVM changes for Linux 6.2
Date:   Mon, 12 Dec 2022 10:50:27 -0500
Message-Id: <20221212155027.2841892-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 8332f0ed4f187c7b700831bd7cc83ce180a944b9:

  KVM: Update gfn_to_pfn_cache khva when it moves within the same page (2022-11-23 18:58:46 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 1396763d469a83c5d791fa84df7dd17eba83dcf2:

  Merge remote-tracking branch 'kvm/queue' into HEAD (2022-12-09 09:15:09 +0100)


There are a few non-KVM changes here:

- introduce FOLL_INTERRUPTIBLE, reviewed by the mm/ people;

- tools/perf: change set_bit to __set_bit etc. in preparation for
  introducing atomic bit operations, acked by perf maintainers;

- a shared topic branch with ARM to introduce automatic generation of
  the system register headers, so you probably want to pull from Catalin
  first;

- MTE work that the ARM folks routed through Marc Zyngier's KVM tree.  This
  also touches mm/ and fs/proc/page.c, in order to introduce a PG_arch_3
  flag, only for 64-bit machines.  The core ARM parts can be found at
  https://lore.kernel.org/all/20220705142619.4135905-1-catalin.marinas@arm.com/
  if you're interested in the list of affected files; they were later
  rebased and extended with the KVM bits.  Note that this is *not*
  a shared topic branch.

----------------------------------------------------------------
ARM64:

* Enable the per-vcpu dirty-ring tracking mechanism, together with an
  option to keep the good old dirty log around for pages that are
  dirtied by something other than a vcpu.

* Switch to the relaxed parallel fault handling, using RCU to delay
  page table reclaim and giving better performance under load.

* Relax the MTE ABI, allowing a VMM to use the MAP_SHARED mapping option,
  which multi-process VMMs such as crosvm rely on.  Includes a shared
  topic branch with the ARM tree (see merge commit 382b5b87a97d:
  "Fix a number of issues with MTE, such as races on the tags being
  initialised vs the PG_mte_tagged flag as well as the lack of support
  for VM_SHARED when KVM is involved.  Patches from Catalin Marinas and
  Peter Collingbourne").

* Merge the pKVM shadow vcpu state tracking that allows the hypervisor
  to have its own view of a vcpu, keeping that state private.

* Add support for the PMUv3p5 architecture revision, bringing support
  for 64bit counters on systems that support it, and fix the
  no-quite-compliant CHAIN-ed counter support for the machines that
  actually exist out there.

* Fix a handful of minor issues around 52bit VA/PA support (64kB pages
  only) as a prefix of the oncoming support for 4kB and 16kB pages.

* Pick a small set of documentation and spelling fixes, because no
  good merge window would be complete without those.

s390:

* Second batch of the lazy destroy patches

* First batch of KVM changes for kernel virtual != physical address support

* Removal of a unused function

x86:

* Allow compiling out SMM support

* Cleanup and documentation of SMM state save area format

* Preserve interrupt shadow in SMM state save area

* Respond to generic signals during slow page faults

* Fixes and optimizations for the non-executable huge page errata fix.

* Reprogram all performance counters on PMU filter change

* Cleanups to Hyper-V emulation and tests

* Process Hyper-V TLB flushes from a nested guest (i.e. from a L2 guest
  running on top of a L1 Hyper-V hypervisor)

* Advertise several new Intel features

* x86 Xen-for-KVM:

** Allow the Xen runstate information to cross a page boundary

** Allow XEN_RUNSTATE_UPDATE flag behaviour to be configured

** Add support for 32-bit guests in SCHEDOP_poll

* Notable x86 fixes and cleanups:

** One-off fixes for various emulation flows (SGX, VMXON, NRIPS=0).

** Reinstate IBPB on emulated VM-Exit that was incorrectly dropped a few
   years back when eliminating unnecessary barriers when switching between
   vmcs01 and vmcs02.

** Clean up vmread_error_trampoline() to make it more obvious that params
   must be passed on the stack, even for x86-64.

** Let userspace set all supported bits in MSR_IA32_FEAT_CTL irrespective
   of the current guest CPUID.

** Fudge around a race with TSC refinement that results in KVM incorrectly
   thinking a guest needs TSC scaling when running on a CPU with a
   constant TSC, but no hardware-enumerated TSC frequency.

** Advertise (on AMD) that the SMM_CTL MSR is not supported

** Remove unnecessary exports

Generic:

* Support for responding to signals during page faults; introduces
  new FOLL_INTERRUPTIBLE flag that was reviewed by mm folks

Selftests:

* Fix an inverted check in the access tracking perf test, and restore
  support for asserting that there aren't too many idle pages when
  running on bare metal.

* Fix build errors that occur in certain setups (unsure exactly what is
  unique about the problematic setup) due to glibc overriding
  static_assert() to a variant that requires a custom message.

* Introduce actual atomics for clear/set_bit() in selftests

* Add support for pinning vCPUs in dirty_log_perf_test.

* Rename the so called "perf_util" framework to "memstress".

* Add a lightweight psuedo RNG for guest use, and use it to randomize
  the access pattern and write vs. read percentage in the memstress tests.

* Add a common ucall implementation; code dedup and pre-work for running
  SEV (and beyond) guests in selftests.

* Provide a common constructor and arch hook, which will eventually be
  used by x86 to automatically select the right hypercall (AMD vs. Intel).

* A bunch of added/enabled/fixed selftests for ARM64, covering memslots,
  breakpoints, stage-2 faults and access tracking.

* x86-specific selftest changes:

** Clean up x86's page table management.

** Clean up and enhance the "smaller maxphyaddr" test, and add a related
   test to cover generic emulation failure.

** Clean up the nEPT support checks.

** Add X86_PROPERTY_* framework to retrieve multi-bit CPUID values.

** Fix an ordering issue in the AMX test introduced by recent conversions
   to use kvm_cpu_has(), and harden the code to guard against similar bugs
   in the future.  Anything that tiggers caching of KVM's supported CPUID,
   kvm_cpu_has() in this case, effectively hides opt-in XSAVE features if
   the caching occurs before the test opts in via prctl().

Documentation:

* Remove deleted ioctls from documentation

* Clean up the docs for the x86 MSR filter.

* Various fixes

----------------------------------------------------------------
Aaron Lewis (5):
      KVM: x86: Disallow the use of KVM_MSR_FILTER_DEFAULT_ALLOW in the kernel
      KVM: x86: Add a VALID_MASK for the MSR exit reason flags
      KVM: x86: Add a VALID_MASK for the flag in kvm_msr_filter
      KVM: x86: Add a VALID_MASK for the flags in kvm_msr_filter_range
      selftests: kvm/x86: Test the flags in MSR filtering and MSR exiting

Anshuman Khandual (1):
      KVM: arm64: PMU: Replace version number '0' with ID_AA64DFR0_EL1_PMUVer_NI

Anton Romanov (1):
      KVM: x86: Use current rather than snapshotted TSC frequency if it is constant

Carlos Bilbao (1):
      KVM: SVM: Name and check reserved fields with structs offset

Catalin Marinas (4):
      mm: Do not enable PG_arch_2 for all 64-bit architectures
      arm64: mte: Fix/clarify the PG_mte_tagged semantics
      KVM: arm64: Simplify the sanitise_mte_tags() logic
      arm64: mte: Lock a page for MTE tag initialisation

Chang S. Bae (1):
      x86: KVM: Advertise AMX-FP16 CPUID to user space

Claudio Imbrenda (6):
      KVM: s390: pv: asynchronous destroy for reboot
      KVM: s390: pv: api documentation for asynchronous destroy
      KVM: s390: pv: add KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
      KVM: s390: pv: avoid export before import if possible
      KVM: s390: pv: support for Destroy fast UVC
      KVM: s390: pv: module parameter to fence asynchronous destroy

Colin Ian King (2):
      KVM: selftests: Fix spelling mistake "begining" -> "beginning"
      KVM: selftests: Fix spelling mistake "probabalistic" -> "probabilistic"

Colton Lewis (4):
      KVM: selftests: implement random number generator for guest code
      KVM: selftests: create -r argument to specify random seed
      KVM: selftests: randomize which pages are written vs read
      KVM: selftests: randomize page access order

David Matlack (15):
      KVM: selftests: Rename perf_test_util.[ch] to memstress.[ch]
      KVM: selftests: Rename pta (short for perf_test_args) to args
      KVM: selftests: Rename perf_test_util symbols to memstress
      KVM: selftests: Rename emulator_error_test to smaller_maxphyaddr_emulation_test
      KVM: selftests: Explicitly require instructions bytes
      KVM: selftests: Delete dead ucall code
      KVM: selftests: Move flds instruction emulation failure handling to header
      KVM: x86/mmu: Use BIT{,_ULL}() for PFERR masks
      KVM: selftests: Copy KVM PFERR masks into selftests
      KVM: selftests: Expect #PF(RSVD) when TDP is disabled
      KVM: selftests: Add a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE
      KVM: selftests: Assert in prepare_eptp() that nEPT is supported
      KVM: selftests: Check for KVM nEPT support using "feature" MSRs
      KVM: x86/mmu: Split huge pages mapped by the TDP MMU on fault
      KVM: x86/mmu: Do not recover dirty-tracked NX Huge Pages

David Woodhouse (5):
      KVM: x86/xen: Add CPL to Xen hypercall tracepoint
      MAINTAINERS: Add KVM x86/xen maintainer list
      KVM: x86/xen: Compatibility fixes for shared runstate area
      KVM: x86/xen: Allow XEN_RUNSTATE_UPDATE flag behaviour to be configured
      KVM: x86/xen: Add runstate tests for 32-bit mode and crossing page boundary

Fuad Tabba (3):
      KVM: arm64: Add hyp_spinlock_t static initializer
      KVM: arm64: Add infrastructure to create and track pKVM instances at EL2
      KVM: arm64: Instantiate pKVM hypervisor VM and vCPU structures from EL1

Gautam Menghani (1):
      KVM: selftests: Don't assume vcpu->id is '0' in xAPIC state test

Gavin Shan (14):
      KVM: x86: Introduce KVM_REQ_DIRTY_RING_SOFT_FULL
      KVM: Move declaration of kvm_cpu_dirty_log_size() to kvm_dirty_ring.h
      KVM: Support dirty ring in conjunction with bitmap
      KVM: arm64: Enable ring-based dirty memory tracking
      KVM: selftests: Use host page size to map ring buffer in dirty_log_test
      KVM: selftests: Clear dirty ring states between two modes in dirty_log_test
      KVM: selftests: Automate choosing dirty ring size in dirty_log_test
      KVM: selftests: memslot_perf_test: Use data->nslots in prepare_vm()
      KVM: selftests: memslot_perf_test: Consolidate loop conditions in prepare_vm()
      KVM: selftests: memslot_perf_test: Probe memory slots for once
      KVM: selftests: memslot_perf_test: Support variable guest page size
      KVM: selftests: memslot_perf_test: Consolidate memory
      KVM: selftests: memslot_perf_test: Report optimal memory slots
      KVM: Push dirty information unconditionally to backup bitmap

Heiko Carstens (1):
      KVM: s390: remove unused gisa_clear_ipm_gisc() function

James Morse (38):
      arm64/sysreg: Standardise naming for ID_MMFR0_EL1
      arm64/sysreg: Standardise naming for ID_MMFR4_EL1
      arm64/sysreg: Standardise naming for ID_MMFR5_EL1
      arm64/sysreg: Standardise naming for ID_ISAR0_EL1
      arm64/sysreg: Standardise naming for ID_ISAR4_EL1
      arm64/sysreg: Standardise naming for ID_ISAR5_EL1
      arm64/sysreg: Standardise naming for ID_ISAR6_EL1
      arm64/sysreg: Standardise naming for ID_PFR0_EL1
      arm64/sysreg: Standardise naming for ID_PFR1_EL1
      arm64/sysreg: Standardise naming for ID_PFR2_EL1
      arm64/sysreg: Standardise naming for ID_DFR0_EL1
      arm64/sysreg: Standardise naming for ID_DFR1_EL1
      arm64/sysreg: Standardise naming for MVFR0_EL1
      arm64/sysreg: Standardise naming for MVFR1_EL1
      arm64/sysreg: Standardise naming for MVFR2_EL1
      arm64/sysreg: Extend the maximum width of a register and symbol name
      arm64/sysreg: Convert ID_MMFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR3_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR4_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR3_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR4_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR5_EL1 to automatic generation
      arm64/sysreg: Convert ID_ISAR6_EL1 to automatic generation
      arm64/sysreg: Convert ID_PFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_PFR1_EL1 to automatic generation
      arm64/sysreg: Convert ID_PFR2_EL1 to automatic generation
      arm64/sysreg: Convert MVFR0_EL1 to automatic generation
      arm64/sysreg: Convert MVFR1_EL1 to automatic generation
      arm64/sysreg: Convert MVFR2_EL1 to automatic generation
      arm64/sysreg: Convert ID_MMFR5_EL1 to automatic generation
      arm64/sysreg: Convert ID_AFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_DFR0_EL1 to automatic generation
      arm64/sysreg: Convert ID_DFR1_EL1 to automatic generation

Javier Martinez Canillas (4):
      KVM: Delete all references to removed KVM_SET_MEMORY_REGION ioctl
      KVM: Delete all references to removed KVM_SET_MEMORY_ALIAS ioctl
      KVM: Reference to kvm_userspace_memory_region in doc and comments
      KVM: Add missing arch for KVM_CREATE_DEVICE and KVM_{SET,GET}_DEVICE_ATTR

Jiaxi Chen (5):
      x86: KVM: Advertise CMPccXADD CPUID to user space
      x86: KVM: Advertise AVX-IFMA CPUID to user space
      KVM: x86: Advertise AVX-VNNI-INT8 CPUID to user space
      KVM: x86: Advertise AVX-NE-CONVERT CPUID to user space
      KVM: x86: Advertise PREFETCHIT0/1 CPUID to user space

Jim Mattson (4):
      KVM: x86: Insert "AMD" in KVM_X86_FEATURE_PSFD
      KVM: VMX: Guest usage of IA32_SPEC_CTRL is likely
      KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS
      KVM: x86: Advertise that the SMM_CTL MSR is not supported

Lei Wang (1):
      KVM: selftests: Move XFD CPUID checking out of __vm_xsave_require_permission()

Like Xu (2):
      KVM: x86/pmu: Defer reprogram_counter() to kvm_pmu_handle_event()
      KVM: x86/pmu: Defer counter emulated overflow via pmc->prev_counter

Marc Zyngier (32):
      Merge tag 'kvmarm-fixes-6.1-3' into kvm-arm64/dirty-ring
      arm64: Add ID_DFR0_EL1.PerfMon values for PMUv3p7 and IMP_DEF
      KVM: arm64: PMU: Align chained counter implementation with architecture pseudocode
      KVM: arm64: PMU: Always advertise the CHAIN event
      KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow
      KVM: arm64: PMU: Narrow the overflow checking when required
      KVM: arm64: PMU: Only narrow counters that are not 64bit wide
      KVM: arm64: PMU: Add counter_index_to_*reg() helpers
      KVM: arm64: PMU: Simplify setting a counter to a specific value
      KVM: arm64: PMU: Do not let AArch32 change the counters' top 32 bits
      KVM: arm64: PMU: Move the ID_AA64DFR0_EL1.PMUver limit to VM creation
      KVM: arm64: PMU: Allow ID_AA64DFR0_EL1.PMUver to be set from userspace
      KVM: arm64: PMU: Allow ID_DFR0_EL1.PerfMon to be set from userspace
      KVM: arm64: PMU: Implement PMUv3p5 long counter support
      KVM: arm64: PMU: Allow PMUv3p5 to be exposed to the guest
      KVM: arm64: PMU: Simplify vcpu computation on perf overflow notification
      KVM: arm64: PMU: Make kvm_pmc the main data structure
      KVM: arm64: PMU: Simplify PMCR_EL0 reset handling
      KVM: arm64: PMU: Sanitise PMCR_EL0.LP on first vcpu run
      KVM: arm64: PMU: Fix period computation for 64bit counters with 32bit overflow
      Merge branch kvm-arm64/selftest/memslot-fixes into kvmarm-master/next
      Merge branch kvm-arm64/selftest/linked-bps into kvmarm-master/next
      Merge branch kvm-arm64/selftest/s2-faults into kvmarm-master/next
      Merge branch kvm-arm64/selftest/access-tracking into kvmarm-master/next
      Merge branch kvm-arm64/52bit-fixes into kvmarm-master/next
      Merge branch kvm-arm64/dirty-ring into kvmarm-master/next
      Merge branch kvm-arm64/parallel-faults into kvmarm-master/next
      Merge branch kvm-arm64/pkvm-vcpu-state into kvmarm-master/next
      Merge branch kvm-arm64/mte-map-shared into kvmarm-master/next
      Merge branch kvm-arm64/pmu-unchained into kvmarm-master/next
      Merge branch kvm-arm64/misc-6.2 into kvmarm-master/next
      Merge remote-tracking branch 'arm64/for-next/sysregs' into kvmarm-master/next

Maxim Levitsky (10):
      bug: introduce ASSERT_STRUCT_OFFSET
      KVM: x86: smm: check for failures on smm entry
      KVM: x86: smm: add structs for KVM's smram layout
      KVM: x86: smm: use smram structs in the common code
      KVM: x86: smm: use smram struct for 32 bit smram load/restore
      KVM: x86: smm: use smram struct for 64 bit smram load/restore
      KVM: svm: drop explicit return value of kvm_vcpu_map
      KVM: x86: SVM: use smram structs
      KVM: x86: SVM: don't save SVM state to SMRAM when VM is not long mode capable
      KVM: x86: smm: preserve interrupt shadow in SMRAM

Metin Kaya (1):
      KVM: x86/xen: add support for 32-bit guests in SCHEDOP_poll

Miaohe Lin (3):
      KVM: x86: remove obsolete kvm_mmu_gva_to_gpa_fetch()
      KVM: x86/mmu: fix some comment typos
      KVM: x86/mmu: use helper macro SPTE_ENT_PER_PAGE

Michal Luczaj (6):
      KVM: Shorten gfn_to_pfn_cache function names
      KVM: x86: Remove unused argument in gpc_unmap_khva()
      KVM: Store immutable gfn_to_pfn_cache properties
      KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_check()
      KVM: Clean up hva_to_pfn_retry()
      KVM: Use gfn_to_pfn_cache's immutable "kvm" in kvm_gpc_refresh()

Mingwei Zhang (1):
      KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()

Nico Boehr (8):
      s390/mm: gmap: sort out physical vs virtual pointers usage
      s390/entry: sort out physical vs virtual pointers usage in sie64a
      KVM: s390: sort out physical vs virtual pointers usage
      KVM: s390: sida: sort out physical vs virtual pointers usage
      KVM: s390: pv: sort out physical vs virtual pointers usage
      KVM: s390: VSIE: sort out virtual/physical address in pin_guest_page
      s390/mm: fix virtual-physical address confusion for swiotlb
      s390/vfio-ap: GISA: sort out physical vs virtual pointers usage

Oliver Upton (21):
      KVM: arm64: Combine visitor arguments into a context structure
      KVM: arm64: Stash observed pte value in visitor context
      KVM: arm64: Pass mm_ops through the visitor context
      KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
      KVM: arm64: Add a helper to tear down unlinked stage-2 subtrees
      KVM: arm64: Use an opaque type for pteps
      KVM: arm64: Tear down unlinked stage-2 subtree after break-before-make
      KVM: arm64: Protect stage-2 traversal with RCU
      KVM: arm64: Atomically update stage 2 leaf attributes in parallel walks
      KVM: arm64: Split init and set for table PTE
      KVM: arm64: Make block->table PTE changes parallel-aware
      KVM: arm64: Make leaf->leaf PTE changes parallel-aware
      KVM: arm64: Make table->block changes parallel-aware
      KVM: arm64: Handle stage-2 faults in parallel
      KVM: arm64: Take a pointer to walker data in kvm_dereference_pteref()
      KVM: arm64: Don't acquire RCU read lock for exclusive table walks
      KVM: arm64: Reject shared table walks in the hyp code
      KVM: selftests: Have perf_test_util signal when to stop vCPUs
      KVM: selftests: Build access_tracking_perf_test for arm64
      KVM: arm64: selftests: Align VA space allocator with TTBR0
      KVM: selftests: Allocate ucall pool from MEM_REGION_DATA

Paolo Bonzini (25):
      KVM: x86: start moving SMM-related functions to new files
      KVM: x86: move SMM entry to a new file
      KVM: x86: move SMM exit to a new file
      KVM: x86: do not go through ctxt->ops when emulating rsm
      KVM: allow compiling out SMM support
      KVM: x86: compile out vendor-specific code if SMM is disabled
      KVM: x86: remove SMRAM address space if SMM is not supported
      KVM: x86: do not define KVM_REQ_SMI if SMM disabled
      KVM: zero output of KVM_GET_VCPU_EVENTS before filling in the struct
      KVM: x86: do not define SMM-related constants if SMM disabled
      KVM: replace direct irq.h inclusion
      Merge tag 'kvm-selftests-6.2-1' of https://github.com/kvm-x86/linux into HEAD
      KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest has to retry
      Merge branch 'kvm-svm-harden' into HEAD
      KVM: x86: avoid memslot check in NX hugepage recovery if it cannot succeed
      Merge branch 'kvm-dwmw2-fixes' into HEAD
      KVM: always declare prototype for kvm_arch_irqchip_in_kernel
      Merge tag 'kvm-s390-next-6.2-1' of https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
      KVM: x86: fix uninitialized variable use on KVM_REQ_TRIPLE_FAULT
      Merge tag 'kvm-selftests-6.2-2' of https://github.com/kvm-x86/linux into HEAD
      Merge tag 'kvm-x86-fixes-6.2-1' of https://github.com/kvm-x86/linux into HEAD
      KVM: x86: remove unnecessary exports
      Merge branch 'gpc-fixes' of git://git.infradead.org/users/dwmw2/linux into HEAD
      Merge tag 'kvmarm-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
      Merge remote-tracking branch 'kvm/queue' into HEAD

Peng Hao (1):
      KVM: x86: Keep the lock order consistent between SRCU and gpc spinlock

Peter Collingbourne (4):
      mm: Add PG_arch_3 page flag
      KVM: arm64: unify the tests for VMAs in memslots when MTE is enabled
      KVM: arm64: permit all VM_MTE_ALLOWED mappings with MTE enabled
      Documentation: document the ABI changes for KVM_CAP_ARM_MTE

Peter Gonda (2):
      tools: Add atomic_test_and_set_bit()
      KVM: selftests: Add ucall pool based implementation

Peter Xu (4):
      mm/gup: Add FOLL_INTERRUPTIBLE
      kvm: Add KVM_PFN_ERR_SIGPENDING
      kvm: Add interruptible flag to __gfn_to_pfn_memslot()
      kvm: x86: Allow to respond to generic signals during slow PF

Quentin Perret (14):
      KVM: arm64: Move hyp refcount manipulation helpers to common header file
      KVM: arm64: Allow attaching of non-coalescable pages to a hyp pool
      KVM: arm64: Back the hypervisor 'struct hyp_page' array for all memory
      KVM: arm64: Fix-up hyp stage-1 refcounts for all pages mapped at EL2
      KVM: arm64: Prevent the donation of no-map pages
      KVM: arm64: Add helpers to pin memory shared with the hypervisor at EL2
      KVM: arm64: Add per-cpu fixmap infrastructure at EL2
      KVM: arm64: Add generic hyp_memcache helpers
      KVM: arm64: Consolidate stage-2 initialisation into a single function
      KVM: arm64: Instantiate guest stage-2 page-tables at EL2
      KVM: arm64: Return guest memory from EL2 via dedicated teardown memcache
      KVM: arm64: Unmap 'kvm_arm_hyp_percpu_base' from the host
      KVM: arm64: Explicitly map 'kvm_vgic_global_state' at EL2
      KVM: arm64: Don't unnecessarily map host kernel sections at EL2

Rafael Mendonca (1):
      x86/kvm: Remove unused virt to phys translation in kvm_guest_cpu_init()

Reiji Watanabe (9):
      KVM: arm64: selftests: Use FIELD_GET() to extract ID register fields
      KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in debug-exceptions
      KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from debug-exceptions
      KVM: arm64: selftests: Add helpers to enable debug exceptions
      KVM: arm64: selftests: Stop unnecessary test stage tracking of debug-exceptions
      KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
      KVM: arm64: selftests: Add a test case for a linked breakpoint
      KVM: arm64: selftests: Add a test case for a linked watchpoint
      KVM: arm64: selftests: Test with every breakpoint/watchpoint

Ricardo Koller (14):
      KVM: selftests: Add a userfaultfd library
      KVM: selftests: aarch64: Add virt_get_pte_hva() library function
      KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
      KVM: selftests: aarch64: Construct DEFAULT_MAIR_EL1 using sysreg.h macros
      tools: Copy bitfield.h from the kernel sources
      KVM: selftests: Stash backing_src_type in struct userspace_mem_region
      KVM: selftests: Add vm->memslots[] and enum kvm_mem_region_type
      KVM: selftests: Fix alignment in virt_arch_pgd_alloc() and vm_vaddr_alloc()
      KVM: selftests: Use the right memslot for code, page-tables, and data allocations
      KVM: selftests: aarch64: Add aarch64/page_fault_test
      KVM: selftests: aarch64: Add userfaultfd tests into page_fault_test
      KVM: selftests: aarch64: Add dirty logging tests into page_fault_test
      KVM: selftests: aarch64: Add readonly memslot tests into page_fault_test
      KVM: selftests: aarch64: Add mix of tests into page_fault_test

Ryan Roberts (3):
      KVM: arm64: Fix kvm init failure when mode!=vhe and VA_BITS=52.
      KVM: arm64: Fix PAR_TO_HPFAR() to work independently of PA_BITS.
      KVM: arm64: Fix benign bug with incorrect use of VA_BITS

Sean Christopherson (80):
      perf/x86/core: Zero @lbr instead of returning -1 in x86_perf_get_lbr() stub
      KVM: x86: Track supported PERF_CAPABILITIES in kvm_caps
      KVM: x86: Init vcpu->arch.perf_capabilities in common x86 code
      KVM: x86: Handle PERF_CAPABILITIES in common x86's kvm_get_msr_feature()
      KVM: x86: Directly query supported PERF_CAPABILITIES for WRMSR checks
      KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
      KVM: x86/mmu: Rename NX huge pages fields/functions for consistency
      KVM: x86/mmu: Properly account NX huge page workaround for nonpaging MMUs
      KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting SPTE
      KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual pages
      KVM: x86/mmu: Add helper to convert SPTE value to its shadow page
      KVM: x86/mmu: WARN if TDP MMU SP disallows hugepage after being zapped
      KVM: x86/pmu: Force reprogramming of all counters on PMU filter change
      KVM: x86/pmu: Clear "reprogram" bit if counter is disabled or disallowed
      KVM: arm64: selftests: Disable single-step with correct KVM define
      KVM: arm64: selftests: Disable single-step without relying on ucall()
      KVM: selftests: Consolidate common code for populating ucall struct
      KVM: selftests: Consolidate boilerplate code in get_ucall()
      KVM: selftests: Automatically do init_ucall() for non-barebones VMs
      KVM: selftests: Make arm64's MMIO ucall multi-VM friendly
      KVM: selftests: Drop now-unnecessary ucall_uninit()
      KVM: selftests: Drop helpers to read/write page table entries
      KVM: selftests: Drop reserved bit checks from PTE accessor
      KVM: selftests: Remove useless shifts when creating guest page tables
      KVM: selftests: Verify parent PTE is PRESENT when getting child PTE
      KVM: selftests: Use virt_get_pte() when getting PTE pointer
      KVM: selftests: Use vm_get_page_table_entry() in addr_arch_gva2gpa()
      KVM: selftests: Play nice with huge pages when getting PTEs/GPAs
      KVM: selftests: Avoid JMP in non-faulting path of KVM_ASM_SAFE()
      KVM: selftests: Provide error code as a KVM_ASM_SAFE() output
      KVM: selftests: Add X86_FEATURE_PAE and use it calc "fallback" MAXPHYADDR
      KVM: selftests: Refactor X86_FEATURE_* framework to prep for X86_PROPERTY_*
      KVM: selftests: Add X86_PROPERTY_* framework to retrieve CPUID values
      KVM: selftests: Use X86_PROPERTY_MAX_KVM_LEAF in CPUID test
      KVM: selftests: Refactor kvm_cpuid_has() to prep for X86_PROPERTY_* support
      KVM: selftests: Add kvm_cpu_*() support for X86_PROPERTY_*
      KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX
      KVM: selftests: Convert vmx_pmu_caps_test to use X86_PROPERTY_*
      KVM: selftests: Add PMU feature framework, use in PMU event filter test
      KVM: selftests: Add dedicated helpers for getting x86 Family and Model
      KVM: selftests: Add and use KVM helpers for x86 Family and Model
      KVM: selftests: Drop helpers for getting specific KVM supported CPUID entry
      x86/hyperv: Move VMCB enlightenment definitions to hyperv-tlfs.h
      KVM: selftests: Move "struct hv_enlightenments" to x86_64/svm.h
      KVM: SVM: Add a proper field for Hyper-V VMCB enlightenments
      x86/hyperv: KVM: Rename "hv_enlightenments" to "hv_vmcb_enlightenments"
      KVM: x86: Move clearing of TLB_FLUSH_CURRENT to kvm_vcpu_flush_tlb_all()
      KVM: x86: hyper-v: Add helper to read hypercall data for array
      KVM: x86: Add BUILD_BUG_ON() to detect bad usage of "scattered" flags
      KVM: x86: Update KVM-only leaf handling to allow for 100% KVM-only leafs
      KVM: Drop KVM's API to allow temporarily unmapping gfn=>pfn cache
      KVM: Do not partially reinitialize gfn=>pfn cache during activation
      KVM: Drop @gpa from exported gfn=>pfn cache check() and refresh() helpers
      KVM: Skip unnecessary "unmap" if gpc is already valid during refresh
      KVM: VMX: Resume guest immediately when injecting #GP on ECREATE
      KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception
      KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid
      KVM: nVMX: Inject #GP, not #UD, if "generic" VMXON CR0/CR4 check fails
      KVM: x86: Delete documentation for READ|WRITE in KVM_X86_SET_MSR_FILTER
      KVM: x86: Reword MSR filtering docs to more precisely define behavior
      KVM: x86: Clean up KVM_CAP_X86_USER_SPACE_MSR documentation
      KVM: nVMX: Reword comments about generating nested CR0/4 read shadows
      KVM: VMX: Make vmread_error_trampoline() uncallable from C code
      KVM: VMX: Allow userspace to set all supported FEATURE_CONTROL bits
      KVM: VMX: Move MSR_IA32_FEAT_CTL.LOCKED check into "is valid" helper
      KVM: selftests: Verify userspace can stuff IA32_FEATURE_CONTROL at will
      KVM: selftests: Fix inverted "warning" in access tracking perf test
      KVM: selftests: Restore assert for non-nested VMs in access tracking test
      KVM: selftests: Move __vm_xsave_require_permission() below CPUID helpers
      KVM: selftests: Disallow "get supported CPUID" before REQ_XCOMP_GUEST_PERM
      KVM: selftests: Do kvm_cpu_has() checks before creating VM+vCPU
      KVM: selftests: Define and use a custom static assert in lib headers
      KVM: Remove stale comment about KVM_REQ_UNHALT
      KVM: arm64: selftests: Enable single-step without a "full" ucall()
      tools: Take @bit as an "unsigned long" in {clear,set}_bit() helpers
      perf tools: Use dedicated non-atomic clear/set bit helpers
      KVM: selftests: Use non-atomic clear/set bit helpers in KVM tests
      tools: Drop conflicting non-atomic test_and_{clear,set}_bit() helpers
      tools: Drop "atomic_" prefix from atomic test_and_set_bit()
      tools: KVM: selftests: Convert clear/set_bit() to actual atomics

Usama Arif (1):
      KVM: arm64: Fix pvtime documentation

Vipin Sharma (7):
      KVM: selftests: Add missing break between -e and -g option in dirty_log_perf_test
      KVM: selftests: Put command line options in alphabetical order in dirty_log_perf_test
      KVM: selftests: Add atoi_paranoid() to catch errors missed by atoi()
      KVM: selftests: Use SZ_* macros from sizes.h in max_guest_memory_test.c
      KVM: selftests: Shorten the test args in memslot_modification_stress_test.c
      KVM: selftests: Add atoi_positive() and atoi_non_negative() for input validation
      KVM: selftests: Allowing running dirty_log_perf_test on specific CPUs

Vishal Annapurve (3):
      KVM: selftests: move common startup logic to kvm_util.c
      KVM: selftests: Add arch specific initialization
      KVM: selftests: Add arch specific post vm creation hook

Vitaly Kuznetsov (41):
      KVM: x86: Rename 'enable_direct_tlbflush' to 'enable_l2_tlb_flush'
      KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
      KVM: x86: hyper-v: Resurrect dedicated KVM_REQ_HV_TLB_FLUSH flag
      KVM: x86: hyper-v: Introduce TLB flush fifo
      KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
      KVM: x86: hyper-v: Expose support for extended gva ranges for flush hypercalls
      KVM: x86: Prepare kvm_hv_flush_tlb() to handle L2's GPAs
      x86/hyperv: Introduce HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK constants
      KVM: x86: hyper-v: Use HV_MAX_SPARSE_VCPU_BANKS/HV_VCPUS_PER_SPARSE_BANK instead of raw '64'
      KVM: x86: hyper-v: Don't use sparse_set_to_vcpu_mask() in kvm_hv_send_ipi()
      KVM: x86: hyper-v: Create a separate fifo for L2 TLB flush
      KVM: x86: hyper-v: Use preallocated buffer in 'struct kvm_vcpu_hv' instead of on-stack 'sparse_banks'
      KVM: nVMX: Keep track of hv_vm_id/hv_vp_id when eVMCS is in use
      KVM: nSVM: Keep track of Hyper-V hv_vm_id/hv_vp_id
      KVM: x86: Introduce .hv_inject_synthetic_vmexit_post_tlb_flush() nested hook
      KVM: x86: hyper-v: Introduce kvm_hv_is_tlb_flush_hcall()
      KVM: x86: hyper-v: L2 TLB flush
      KVM: x86: hyper-v: Introduce fast guest_hv_cpuid_has_l2_tlb_flush() check
      KVM: nVMX: hyper-v: Cache VP assist page in 'struct kvm_vcpu_hv'
      KVM: nVMX: hyper-v: Enable L2 TLB flush
      KVM: x86: Make kvm_hv_get_assist_page() return 0/-errno
      KVM: nSVM: hyper-v: Enable L2 TLB flush
      KVM: x86: Expose Hyper-V L2 TLB flush feature
      KVM: selftests: Better XMM read/write helpers
      KVM: selftests: Move HYPERV_LINUX_OS_ID definition to a common header
      KVM: selftests: Move the function doing Hyper-V hypercall to a common header
      KVM: selftests: Hyper-V PV IPI selftest
      KVM: selftests: Fill in vm->vpages_mapped bitmap in virt_map() too
      KVM: selftests: Export vm_vaddr_unused_gap() to make it possible to request unmapped ranges
      KVM: selftests: Hyper-V PV TLB flush selftest
      KVM: selftests: Sync 'struct hv_enlightened_vmcs' definition with hyperv-tlfs.h
      KVM: selftests: Sync 'struct hv_vp_assist_page' definition with hyperv-tlfs.h
      KVM: selftests: Move Hyper-V VP assist page enablement out of evmcs.h
      KVM: selftests: Split off load_evmcs() from load_vmcs()
      KVM: selftests: Create a vendor independent helper to allocate Hyper-V specific test pages
      KVM: selftests: Allocate Hyper-V partition assist page
      KVM: selftests: Stuff RAX/RCX with 'safe' values in vmmcall()/vmcall()
      KVM: selftests: Introduce rdmsr_from_l2() and use it for MSR-Bitmap tests
      KVM: selftests: evmcs_test: Introduce L2 TLB flush test
      KVM: selftests: hyperv_svm_test: Introduce L2 TLB flush test
      KVM: selftests: Rename 'evmcs_test' to 'hyperv_evmcs'

Will Deacon (9):
      KVM: arm64: Unify identifiers used to distinguish host and hypervisor
      KVM: arm64: Implement do_donate() helper for donating memory
      KVM: arm64: Include asm/kvm_mmu.h in nvhe/mem_protect.h
      KVM: arm64: Rename 'host_kvm' to 'host_mmu'
      KVM: arm64: Initialise hypervisor copies of host symbols unconditionally
      KVM: arm64: Provide I-cache invalidation by virtual address at EL2
      KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits' at EL2
      KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()
      arm64/sysreg: Remove duplicate definitions from asm/sysreg.h

Yuan ZhaoXiong (1):
      KVM: x86: fix APICv/x2AVIC disabled when vm reboot by itself

Zhao Liu (1):
      KVM: SVM: Replace kmap_atomic() with kmap_local_page()

Zhiyuan Dai (1):
      KVM: arm64: Fix typo in comment


 Documentation/virt/kvm/api.rst                     |  264 +++--
 Documentation/virt/kvm/arm/pvtime.rst              |   14 +-
 Documentation/virt/kvm/devices/arm-vgic-its.rst    |    5 +-
 Documentation/virt/kvm/devices/vcpu.rst            |    2 +
 MAINTAINERS                                        |   10 +
 arch/arm64/Kconfig                                 |    1 +
 arch/arm64/include/asm/kvm_arm.h                   |    8 +-
 arch/arm64/include/asm/kvm_asm.h                   |    7 +-
 arch/arm64/include/asm/kvm_host.h                  |   76 +-
 arch/arm64/include/asm/kvm_hyp.h                   |    3 +
 arch/arm64/include/asm/kvm_mmu.h                   |    2 +-
 arch/arm64/include/asm/kvm_pgtable.h               |  175 ++-
 arch/arm64/include/asm/kvm_pkvm.h                  |   38 +
 arch/arm64/include/asm/mte.h                       |   65 +-
 arch/arm64/include/asm/pgtable.h                   |    4 +-
 arch/arm64/include/asm/sysreg.h                    |  138 ---
 arch/arm64/include/uapi/asm/kvm.h                  |    1 +
 arch/arm64/kernel/cpufeature.c                     |  212 ++--
 arch/arm64/kernel/elfcore.c                        |    2 +-
 arch/arm64/kernel/hibernate.c                      |    2 +-
 arch/arm64/kernel/image-vars.h                     |   15 -
 arch/arm64/kernel/mte.c                            |   21 +-
 arch/arm64/kvm/Kconfig                             |    2 +
 arch/arm64/kvm/arm.c                               |   95 +-
 arch/arm64/kvm/guest.c                             |   18 +-
 arch/arm64/kvm/hyp/hyp-constants.c                 |    3 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   25 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h           |   27 +
 arch/arm64/kvm/hyp/include/nvhe/mm.h               |   18 +-
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h             |   68 ++
 arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |   10 +-
 arch/arm64/kvm/hyp/nvhe/cache.S                    |   11 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  110 +-
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c                  |    2 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  521 ++++++++-
 arch/arm64/kvm/hyp/nvhe/mm.c                       |  167 ++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c               |   29 +-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  436 ++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c                    |   98 +-
 arch/arm64/kvm/hyp/pgtable.c                       |  652 ++++++------
 arch/arm64/kvm/hyp/vhe/Makefile                    |    2 +-
 arch/arm64/kvm/irq.h                               |   16 -
 arch/arm64/kvm/mmu.c                               |  195 ++--
 arch/arm64/kvm/pkvm.c                              |  138 ++-
 arch/arm64/kvm/pmu-emul.c                          |  482 ++++-----
 arch/arm64/kvm/reset.c                             |   29 -
 arch/arm64/kvm/sys_regs.c                          |  157 ++-
 arch/arm64/kvm/vgic/vgic-its.c                     |   20 +
 arch/arm64/lib/mte.S                               |    2 +-
 arch/arm64/mm/copypage.c                           |    7 +-
 arch/arm64/mm/fault.c                              |    4 +-
 arch/arm64/mm/mteswap.c                            |   16 +-
 arch/arm64/tools/gen-sysreg.awk                    |    2 +-
 arch/arm64/tools/sysreg                            |  754 +++++++++++++
 arch/powerpc/kvm/book3s_64_mmu_hv.c                |    2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |    2 +-
 arch/powerpc/kvm/irq.h                             |   22 -
 arch/powerpc/kvm/powerpc.c                         |   18 +-
 arch/s390/include/asm/kvm_host.h                   |   14 +-
 arch/s390/include/asm/mem_encrypt.h                |    4 +-
 arch/s390/include/asm/stacktrace.h                 |    1 +
 arch/s390/include/asm/uv.h                         |   10 +
 arch/s390/kernel/asm-offsets.c                     |    1 +
 arch/s390/kernel/entry.S                           |   26 +-
 arch/s390/kernel/uv.c                              |    7 +
 arch/s390/kvm/intercept.c                          |    9 +-
 arch/s390/kvm/interrupt.c                          |    5 -
 arch/s390/kvm/irq.h                                |   19 -
 arch/s390/kvm/kvm-s390.c                           |  116 +-
 arch/s390/kvm/kvm-s390.h                           |    8 +-
 arch/s390/kvm/priv.c                               |    3 +-
 arch/s390/kvm/pv.c                                 |  357 ++++++-
 arch/s390/kvm/vsie.c                               |    4 +-
 arch/s390/mm/gmap.c                                |  147 +--
 arch/s390/mm/init.c                                |   12 +-
 arch/x86/events/intel/lbr.c                        |    6 +-
 arch/x86/include/asm/cpufeatures.h                 |    3 +
 arch/x86/include/asm/hyperv-tlfs.h                 |   37 +
 arch/x86/include/asm/kvm-x86-ops.h                 |    4 +-
 arch/x86/include/asm/kvm_host.h                    |  145 ++-
 arch/x86/include/asm/perf_event.h                  |    6 +-
 arch/x86/include/asm/svm.h                         |  100 +-
 arch/x86/include/uapi/asm/kvm.h                    |   13 +-
 arch/x86/kernel/kvm.c                              |    2 +-
 arch/x86/kvm/Kconfig                               |   11 +
 arch/x86/kvm/Makefile                              |    6 +-
 arch/x86/kvm/cpuid.c                               |   33 +-
 arch/x86/kvm/emulate.c                             |  355 +------
 arch/x86/kvm/hyperv.c                              |  354 +++++--
 arch/x86/kvm/hyperv.h                              |   64 +-
 arch/x86/kvm/irq.c                                 |    7 +-
 arch/x86/kvm/kvm_cache_regs.h                      |    5 -
 arch/x86/kvm/kvm_emulate.h                         |   48 +-
 arch/x86/kvm/lapic.c                               |   16 +-
 arch/x86/kvm/lapic.h                               |    2 +-
 arch/x86/kvm/mmu/mmu.c                             |  176 ++-
 arch/x86/kvm/mmu/mmu_internal.h                    |   33 +-
 arch/x86/kvm/mmu/paging_tmpl.h                     |    6 +-
 arch/x86/kvm/mmu/spte.c                            |   12 +
 arch/x86/kvm/mmu/spte.h                            |   19 +-
 arch/x86/kvm/mmu/tdp_mmu.c                         |  114 +-
 arch/x86/kvm/mmu/tdp_mmu.h                         |    2 +
 arch/x86/kvm/pmu.c                                 |   90 +-
 arch/x86/kvm/pmu.h                                 |    6 +-
 arch/x86/kvm/reverse_cpuid.h                       |   25 +-
 arch/x86/kvm/smm.c                                 |  649 ++++++++++++
 arch/x86/kvm/smm.h                                 |  168 +++
 arch/x86/kvm/svm/hyperv.c                          |   18 +
 arch/x86/kvm/svm/hyperv.h                          |   50 +-
 arch/x86/kvm/svm/nested.c                          |   52 +-
 arch/x86/kvm/svm/pmu.c                             |    4 +-
 arch/x86/kvm/svm/sev.c                             |    6 +-
 arch/x86/kvm/svm/svm.c                             |   63 +-
 arch/x86/kvm/svm/svm.h                             |    5 +-
 arch/x86/kvm/svm/svm_onhyperv.c                    |    8 +-
 arch/x86/kvm/svm/svm_onhyperv.h                    |   25 +-
 arch/x86/kvm/trace.h                               |   36 +-
 arch/x86/kvm/vmx/capabilities.h                    |   24 -
 arch/x86/kvm/vmx/{evmcs.c => hyperv.c}             |   45 +-
 arch/x86/kvm/vmx/{evmcs.h => hyperv.h}             |   12 +-
 arch/x86/kvm/vmx/nested.c                          |  108 +-
 arch/x86/kvm/vmx/nested.h                          |    7 +-
 arch/x86/kvm/vmx/pmu_intel.c                       |   11 +-
 arch/x86/kvm/vmx/sgx.c                             |    4 +-
 arch/x86/kvm/vmx/vmcs12.h                          |    5 +-
 arch/x86/kvm/vmx/vmenter.S                         |    2 +
 arch/x86/kvm/vmx/vmx.c                             |  104 +-
 arch/x86/kvm/vmx/vmx_ops.h                         |   20 +-
 arch/x86/kvm/x86.c                                 |  533 +++-------
 arch/x86/kvm/x86.h                                 |    1 +
 arch/x86/kvm/xen.c                                 |  505 ++++++---
 arch/x86/kvm/xen.h                                 |   13 +-
 drivers/s390/crypto/vfio_ap_ops.c                  |    2 +-
 fs/proc/page.c                                     |    3 +-
 include/asm-generic/hyperv-tlfs.h                  |    5 +
 include/asm-generic/mshyperv.h                     |   11 +-
 include/kvm/arm_pmu.h                              |   15 +-
 include/kvm/arm_vgic.h                             |    1 +
 include/linux/build_bug.h                          |    9 +
 include/linux/kernel-page-flags.h                  |    1 +
 include/linux/kvm_dirty_ring.h                     |   20 +-
 include/linux/kvm_host.h                           |  107 +-
 include/linux/kvm_types.h                          |    1 +
 include/linux/mm.h                                 |    1 +
 include/linux/page-flags.h                         |    3 +-
 include/trace/events/mmflags.h                     |    9 +-
 include/uapi/linux/kvm.h                           |   31 +-
 mm/Kconfig                                         |    8 +
 mm/gup.c                                           |   33 +-
 mm/huge_memory.c                                   |    3 +-
 mm/hugetlb.c                                       |    5 +-
 tools/arch/x86/include/asm/atomic.h                |   11 +
 tools/arch/x86/include/uapi/asm/kvm.h              |    8 -
 tools/include/asm-generic/atomic-gcc.h             |   23 +
 tools/include/asm-generic/bitops/atomic.h          |   15 +-
 tools/include/linux/bitfield.h                     |  176 +++
 tools/include/linux/bitmap.h                       |   34 -
 tools/include/uapi/linux/kvm.h                     |   20 +-
 tools/perf/bench/find-bit-bench.c                  |    2 +-
 tools/perf/builtin-c2c.c                           |    6 +-
 tools/perf/builtin-kwork.c                         |    6 +-
 tools/perf/builtin-record.c                        |    6 +-
 tools/perf/builtin-sched.c                         |    2 +-
 tools/perf/tests/bitmap.c                          |    2 +-
 tools/perf/tests/mem2node.c                        |    2 +-
 tools/perf/util/affinity.c                         |    4 +-
 tools/perf/util/header.c                           |    8 +-
 tools/perf/util/mmap.c                             |    6 +-
 tools/perf/util/pmu.c                              |    2 +-
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 .../util/scripting-engines/trace-event-python.c    |    2 +-
 tools/perf/util/session.c                          |    2 +-
 tools/perf/util/svghelper.c                        |    2 +-
 tools/testing/selftests/kvm/.gitignore             |    8 +-
 tools/testing/selftests/kvm/Makefile               |   16 +-
 .../selftests/kvm/aarch64/aarch32_id_regs.c        |    6 +-
 tools/testing/selftests/kvm/aarch64/arch_timer.c   |   31 +-
 .../selftests/kvm/aarch64/debug-exceptions.c       |  360 +++++--
 tools/testing/selftests/kvm/aarch64/hypercalls.c   |    3 -
 .../selftests/kvm/aarch64/page_fault_test.c        | 1117 ++++++++++++++++++++
 tools/testing/selftests/kvm/aarch64/psci_test.c    |    1 -
 tools/testing/selftests/kvm/aarch64/vgic_init.c    |    2 -
 tools/testing/selftests/kvm/aarch64/vgic_irq.c     |   10 +-
 .../selftests/kvm/access_tracking_perf_test.c      |   52 +-
 tools/testing/selftests/kvm/demand_paging_test.c   |  250 +----
 tools/testing/selftests/kvm/dirty_log_perf_test.c  |  130 ++-
 tools/testing/selftests/kvm/dirty_log_test.c       |   90 +-
 .../selftests/kvm/include/aarch64/processor.h      |   35 +-
 .../testing/selftests/kvm/include/kvm_util_base.h  |   75 +-
 tools/testing/selftests/kvm/include/memstress.h    |   75 ++
 .../testing/selftests/kvm/include/perf_test_util.h |   63 --
 tools/testing/selftests/kvm/include/test_util.h    |   25 +
 tools/testing/selftests/kvm/include/ucall_common.h |   18 +-
 .../selftests/kvm/include/userfaultfd_util.h       |   45 +
 tools/testing/selftests/kvm/include/x86_64/evmcs.h |   48 +-
 .../testing/selftests/kvm/include/x86_64/hyperv.h  |  103 ++
 .../selftests/kvm/include/x86_64/processor.h       |  442 ++++++--
 tools/testing/selftests/kvm/include/x86_64/svm.h   |   26 +-
 .../selftests/kvm/include/x86_64/svm_util.h        |   14 +
 tools/testing/selftests/kvm/include/x86_64/vmx.h   |   25 +-
 tools/testing/selftests/kvm/kvm_page_table_test.c  |    6 +-
 .../testing/selftests/kvm/lib/aarch64/processor.c  |   83 +-
 tools/testing/selftests/kvm/lib/aarch64/ucall.c    |  102 +-
 tools/testing/selftests/kvm/lib/elf.c              |    5 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |  193 +++-
 .../kvm/lib/{perf_test_util.c => memstress.c}      |  136 ++-
 tools/testing/selftests/kvm/lib/riscv/processor.c  |   29 +-
 tools/testing/selftests/kvm/lib/riscv/ucall.c      |   42 +-
 tools/testing/selftests/kvm/lib/s390x/processor.c  |    8 +-
 tools/testing/selftests/kvm/lib/s390x/ucall.c      |   39 +-
 tools/testing/selftests/kvm/lib/test_util.c        |   36 +
 tools/testing/selftests/kvm/lib/ucall_common.c     |  103 ++
 tools/testing/selftests/kvm/lib/userfaultfd_util.c |  186 ++++
 tools/testing/selftests/kvm/lib/x86_64/hyperv.c    |   46 +
 .../lib/x86_64/{perf_test_util.c => memstress.c}   |   37 +-
 tools/testing/selftests/kvm/lib/x86_64/processor.c |  314 +++---
 tools/testing/selftests/kvm/lib/x86_64/ucall.c     |   39 +-
 tools/testing/selftests/kvm/lib/x86_64/vmx.c       |   56 +-
 .../testing/selftests/kvm/max_guest_memory_test.c  |   21 +-
 .../kvm/memslot_modification_stress_test.c         |   44 +-
 tools/testing/selftests/kvm/memslot_perf_test.c    |  339 +++---
 tools/testing/selftests/kvm/rseq_test.c            |    4 -
 tools/testing/selftests/kvm/s390x/memop.c          |    2 -
 tools/testing/selftests/kvm/s390x/resets.c         |    2 -
 tools/testing/selftests/kvm/s390x/sync_regs_test.c |    3 -
 .../testing/selftests/kvm/set_memory_region_test.c |    5 +-
 tools/testing/selftests/kvm/steal_time.c           |    1 -
 .../selftests/kvm/system_counter_offset_test.c     |    1 -
 tools/testing/selftests/kvm/x86_64/amx_test.c      |  112 +-
 tools/testing/selftests/kvm/x86_64/cpuid_test.c    |   11 +-
 .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |    3 -
 .../selftests/kvm/x86_64/emulator_error_test.c     |  193 ----
 .../kvm/x86_64/exit_on_emulation_failure_test.c    |   45 +
 .../testing/selftests/kvm/x86_64/flds_emulation.h  |   55 +
 tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c  |    3 -
 .../kvm/x86_64/{evmcs_test.c => hyperv_evmcs.c}    |  100 +-
 .../testing/selftests/kvm/x86_64/hyperv_features.c |   25 +-
 tools/testing/selftests/kvm/x86_64/hyperv_ipi.c    |  314 ++++++
 .../testing/selftests/kvm/x86_64/hyperv_svm_test.c |  103 +-
 .../selftests/kvm/x86_64/hyperv_tlb_flush.c        |  690 ++++++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c      |    5 +-
 .../selftests/kvm/x86_64/platform_info_test.c      |    3 -
 .../selftests/kvm/x86_64/pmu_event_filter_test.c   |   77 +-
 .../testing/selftests/kvm/x86_64/set_sregs_test.c  |    3 -
 .../kvm/x86_64/smaller_maxphyaddr_emulation_test.c |  111 ++
 tools/testing/selftests/kvm/x86_64/smm_test.c      |    2 +
 .../kvm/x86_64/svm_nested_soft_inject_test.c       |    3 -
 .../testing/selftests/kvm/x86_64/sync_regs_test.c  |    3 -
 .../selftests/kvm/x86_64/userspace_io_test.c       |    3 -
 .../selftests/kvm/x86_64/userspace_msr_exit_test.c |   88 +-
 .../selftests/kvm/x86_64/vmx_dirty_log_test.c      |    1 +
 tools/testing/selftests/kvm/x86_64/vmx_msrs_test.c |   47 +
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c       |   19 +-
 .../selftests/kvm/x86_64/xapic_state_test.c        |    4 +-
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |  141 ++-
 virt/kvm/Kconfig                                   |    6 +
 virt/kvm/dirty_ring.c                              |   46 +-
 virt/kvm/irqchip.c                                 |    3 +-
 virt/kvm/kvm_main.c                                |  107 +-
 virt/kvm/kvm_mm.h                                  |    4 +-
 virt/kvm/pfncache.c                                |  114 +-
 261 files changed, 12921 insertions(+), 5230 deletions(-)

