Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7985844807F
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 14:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238962AbhKHNvB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 08:51:01 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238013AbhKHNu5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 08:50:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8C9kog016335;
        Mon, 8 Nov 2021 13:48:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=mNiLYGOw1TtXNZbiJd0N7HhnB0gNHde0YBqfEgGO5M8=;
 b=MY6+V3MdM4JRLlq5ORWiyHhnHwDMEFwaImsV/RCrIqX1GgO501LTYukOqWTVk1KeH0HZ
 p3znH6M2s982sPQZ7Cli4yUWnqiBRlhjH1hRMxkTmZjytaUjJoDseFjJ1uXDtMXWwvSA
 J5lM3IniMZ9CA+2cGM59nGZ6J3dWY29HcR/Ucyohp1utKskaq1OoQ/aDt0vmbpU53uwH
 zrz/RfOLKeOZeTu27sDMeTEMraUblHcEa6WX8+wvxQkhI71jNr1rwagwvByiK86HVtAK
 PJDXGkX/0NsRh5GTqYQM5pGtu2AxyT/i5sdd7tMdxs0xeFPhAmO6wpj6xRT4q5Z0LYvl mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6a94ds4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:48:11 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8DApr8024094;
        Mon, 8 Nov 2021 13:48:11 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c6a94ds3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:48:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8Dl6oD025487;
        Mon, 8 Nov 2021 13:48:08 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3c5hb9ddfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 13:48:08 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8Dm5hN54854114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 13:48:06 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF0E7A405C;
        Mon,  8 Nov 2021 13:48:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 759CAA4065;
        Mon,  8 Nov 2021 13:48:05 +0000 (GMT)
Received: from [9.171.16.13] (unknown [9.171.16.13])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 13:48:05 +0000 (GMT)
Message-ID: <f880166d-5c23-4f4d-1dc0-333055de2e3d@de.ibm.com>
Date:   Mon, 8 Nov 2021 14:48:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 5.16
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20211102165331.599683-1-pbonzini@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
In-Reply-To: <20211102165331.599683-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tJlurSU9uzDHGLjeHPkyk59Uo848-tK-
X-Proofpoint-GUID: ni2mANEYiPnQ4MWgl4H2oXpf-xE2r-6w
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_05,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 02.11.21 um 17:53 schrieb Paolo Bonzini:
> Linus,
> 
> The following changes since commit 8228c77d8b56e3f735baf71fefb1b548c23691a7:
> 
>    KVM: x86: switch pvclock_gtod_sync_lock to a raw spinlock (2021-10-25 08:14:38 -0400)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> for you to fetch changes up to 52cf891d8dbd7592261fa30f373410b97f22b76c:
> 
>    Merge tag 'kvm-riscv-5.16-2' of https://github.com/kvm-riscv/linux into HEAD (2021-11-02 09:15:31 -0400)

It seems that this was not yet merged, correct?


> 
> ----------------------------------------------------------------
> ARM:
> * More progress on the protected VM front, now with the full
>    fixed feature set as well as the limitation of some hypercalls
>    after initialisation.
> 
> * Cleanup of the RAZ/WI sysreg handling, which was pointlessly
>    complicated
> 
> * Fixes for the vgic placement in the IPA space, together with a
>    bunch of selftests
> 
> * More memcg accounting of the memory allocated on behalf of a guest
> 
> * Timer and vgic selftests
> 
> * Workarounds for the Apple M1 broken vgic implementation
> 
> * KConfig cleanups
> 
> * New kvmarm.mode=none option, for those who really dislike us
> 
> RISC-V:
> * New KVM port.
> 
> x86:
> * New API to control TSC offset from userspace
> 
> * TSC scaling for nested hypervisors on SVM
> 
> * Switch masterclock protection from raw_spin_lock to seqcount
> 
> * Clean up function prototypes in the page fault code and avoid
> repeated memslot lookups
> 
> * Convey the exit reason to userspace on emulation failure
> 
> * Configure time between NX page recovery iterations
> 
> * Expose Predictive Store Forwarding Disable CPUID leaf
> 
> * Allocate page tracking data structures lazily (if the i915
> KVM-GT functionality is not compiled in)
> 
> * Cleanups, fixes and optimizations for the shadow MMU code
> 
> s390:
> * SIGP Fixes
> 
> * initial preparations for lazy destroy of secure VMs
> 
> * storage key improvements/fixes
> 
> * Log the guest CPNC
> 
> Starting from this release, KVM-PPC patches will come from
> Michael Ellerman's PPC tree.
> 
> ----------------------------------------------------------------
> There is a trivial Kconfig conflict in arch/riscv, and a slightly
> less trivial conflict with Thomas's x86 FPU rework.  The latter is
> due to fx_init going away in my tree (long before Thomas started his
> work, or I would have synchronized better).  The conflict resolution
> is at the bottom of this email.
> 
> Alexandru Elisei (4):
>        KVM: arm64: Return early from read_id_reg() if register is RAZ
>        KVM: arm64: Use get_raz_reg() for userspace reads of PMSWINC_EL0
>        KVM: arm64: Replace get_raz_id_reg() with get_raz_reg()
>        Documentation: admin-guide: Document side effects when pKVM is enabled
> 
> Andrei Vagin (1):
>        KVM: x86/mmu: kvm_faultin_pfn has to return false if pfh is returned
> 
> Anup Patel (15):
>        RISC-V: Add hypervisor extension related CSR defines
>        RISC-V: Add initial skeletal KVM support
>        RISC-V: KVM: Implement VCPU create, init and destroy functions
>        RISC-V: KVM: Implement VCPU interrupts and requests handling
>        RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
>        RISC-V: KVM: Implement VCPU world-switch
>        RISC-V: KVM: Handle MMIO exits for VCPU
>        RISC-V: KVM: Handle WFI exits for VCPU
>        RISC-V: KVM: Implement VMID allocator
>        RISC-V: KVM: Implement stage2 page table programming
>        RISC-V: KVM: Implement MMU notifiers
>        RISC-V: KVM: Document RISC-V specific parts of KVM API
>        RISC-V: KVM: Add MAINTAINERS entry
>        RISC-V: KVM: Factor-out FP virtualization into separate sources
>        RISC-V: KVM: Fix GPA passed to __kvm_riscv_hfence_gvma_xyz() functions
> 
> Atish Patra (4):
>        RISC-V: KVM: Add timer functionality
>        RISC-V: KVM: FP lazy save/restore
>        RISC-V: KVM: Implement ONE REG interface for FP registers
>        RISC-V: KVM: Add SBI v0.1 support
> 
> Babu Moger (1):
>        KVM: x86: Expose Predictive Store Forwarding Disable
> 
> Bixuan Cui (1):
>        RISC-V: KVM: fix boolreturn.cocci warnings
> 
> Claudio Imbrenda (5):
>        KVM: s390: pv: add macros for UVC CC values
>        KVM: s390: pv: avoid double free of sida page
>        KVM: s390: pv: avoid stalls for kvm_s390_pv_init_vm
>        KVM: s390: pv: avoid stalls when making pages secure
>        KVM: s390: pv: properly handle page flags for protected guests
> 
> Colin Ian King (1):
>        kvm: selftests: Fix spelling mistake "missmatch" -> "mismatch"
> 
> Collin Walling (1):
>        KVM: s390: add debug statement for diag 318 CPNC data
> 
> David Edmondson (4):
>        KVM: x86: Clarify the kvm_run.emulation_failure structure layout
>        KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info
>        KVM: x86: On emulation failure, convey the exit reason, etc. to userspace
>        KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol
> 
> David Hildenbrand (8):
>        s390/gmap: validate VMA in __gmap_zap()
>        s390/gmap: don't unconditionally call pte_unmap_unlock() in __gmap_zap()
>        s390/mm: validate VMA in PGSTE manipulation functions
>        s390/mm: fix VMA and page table handling code in storage key handling functions
>        s390/uv: fully validate the VMA before calling follow_page()
>        s390/mm: no need for pte_alloc_map_lock() if we know the pmd is present
>        s390/mm: optimize set_guest_storage_key()
>        s390/mm: optimize reset_guest_reference_bit()
> 
> David Matlack (6):
>        KVM: x86/mmu: Fold rmap_recycle into rmap_add
>        KVM: x86/mmu: Pass the memslot around via struct kvm_page_fault
>        KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
>        KVM: x86/mmu: Avoid memslot lookup in rmap_add
>        KVM: x86/mmu: Avoid memslot lookup in make_spte and mmu_try_to_unsync_pages
>        KVM: x86/mmu: Rename slot_handle_leaf to slot_handle_level_4k
> 
> David Stevens (3):
>        KVM: x86: add config for non-kvm users of page tracking
>        KVM: x86: only allocate gfn_track when necessary
>        KVM: cleanup allocation of rmaps and page tracking data
> 
> Eric Farman (2):
>        KVM: s390: Simplify SIGP Set Arch handling
>        KVM: s390: Add a routine for setting userspace CPU state
> 
> Fuad Tabba (8):
>        KVM: arm64: Pass struct kvm to per-EC handlers
>        KVM: arm64: Add missing field descriptor for MDCR_EL2
>        KVM: arm64: Simplify masking out MTE in feature id reg
>        KVM: arm64: Add handlers for protected VM System Registers
>        KVM: arm64: Initialize trap registers for protected VMs
>        KVM: arm64: Move sanitized copies of CPU features
>        KVM: arm64: Trap access to pVM restricted features
>        KVM: arm64: Handle protected guests at 32 bits
> 
> Janis Schoetterl-Glausch (1):
>        KVM: s390: Fix handle_sske page fault handling
> 
> Jia He (2):
>        KVM: arm64: vgic: Add memcg accounting to vgic allocations
>        KVM: arm64: Add memcg accounting to KVM allocations
> 
> Jim Mattson (2):
>        kvm: x86: Remove stale declaration of kvm_no_apic_vcpu
>        KVM: selftests: Fix nested SVM tests when built with clang
> 
> Juergen Gross (3):
>        Revert "x86/kvm: fix vcpu-id indexed array sizes"
>        kvm: rename KVM_MAX_VCPU_ID to KVM_MAX_VCPU_IDS
>        kvm: use kvfree() in kvm_arch_free_vm()
> 
> Junaid Shahid (1):
>        kvm: x86: mmu: Make NX huge page recovery period configurable
> 
> Krish Sadhukhan (1):
>        nSVM: Check for reserved encodings of TLB_CONTROL in nested VMCB
> 
> Lai Jiangshan (14):
>        KVM: X86: Don't flush current tlb on shadow page modification
>        KVM: X86: Remove kvm_mmu_flush_or_zap()
>        KVM: X86: Change kvm_sync_page() to return true when remote flush is needed
>        KVM: X86: Zap the invalid list after remote tlb flushing
>        KVM: X86: Remove FNAME(update_pte)
>        KVM: X86: Don't unsync pagetables when speculative
>        KVM: X86: Don't check unsync if the original spte is writible
>        KVM: X86: Move PTE present check from loop body to __shadow_walk_next()
>        KVM: X86: Don't reset mmu context when X86_CR4_PCIDE 1->0
>        KVM: X86: Don't reset mmu context when toggling X86_CR4_PGE
>        KVM: X86: Fix tlb flush for tdp in kvm_invalidate_pcid()
>        KVM: X86: Cache CR3 in prev_roots when PCID is disabled
>        KVM: X86: pair smp_wmb() of mmu_try_to_unsync_pages() with smp_rmb()
>        KVM: X86: Don't unload MMU in kvm_vcpu_flush_tlb_guest()
> 
> Longpeng(Mike) (1):
>        kvm: irqfd: avoid update unmodified entries of the routing
> 
> Lukas Bulwahn (1):
>        riscv: do not select non-existing config ANON_INODES
> 
> Marc Zyngier (33):
>        KVM: arm64: Turn __KVM_HOST_SMCCC_FUNC_* into an enum (mostly)
>        Merge branch kvm-arm64/pkvm/restrict-hypercalls into kvmarm-master/next
>        Merge branch kvm-arm64/vgic-ipa-checks into kvmarm-master/next
>        KVM: arm64: Allow KVM to be disabled from the command line
>        Merge branch kvm-arm64/misc-5.16 into kvmarm-master/next
>        Merge branch kvm-arm64/raz-sysregs into kvmarm-master/next
>        KVM: arm64: Move __get_fault_info() and co into their own include file
>        KVM: arm64: Don't include switch.h into nvhe/kvm-main.c
>        KVM: arm64: Move early handlers to per-EC handlers
>        Merge branch kvm-arm64/pkvm/restrict-hypercalls into kvmarm-master/next
>        KVM: arm64: Fix reporting of endianess when the access originates at EL0
>        Merge branch kvm-arm64/misc-5.16 into kvmarm-master/next
>        KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3
>        KVM: arm64: vgic-v3: Work around GICv3 locally generated SErrors
>        KVM: arm64: vgic-v3: Reduce common group trapping to ICV_DIR_EL1 when possible
>        KVM: arm64: vgic-v3: Don't advertise ICC_CTLR_EL1.SEIS
>        KVM: arm64: vgic-v3: Align emulated cpuif LPI state machine with the pseudocode
>        Merge branch kvm-arm64/vgic-fixes-5.16 into kvmarm-master/next
>        Merge branch kvm-arm64/selftest/timer into kvmarm-master/next
>        Merge branch kvm-arm64/memory-accounting into kvmarm-master/next
>        KVM: arm64: Fix early exit ptrauth handling
>        KVM: arm64: pkvm: Use a single function to expose all id-regs
>        KVM: arm64: pkvm: Make the ERR/ERX*_EL1 registers RAZ/WI
>        KVM: arm64: pkvm: Drop AArch32-specific registers
>        KVM: arm64: pkvm: Drop sysregs that should never be routed to the host
>        KVM: arm64: pkvm: Handle GICv3 traps as required
>        KVM: arm64: pkvm: Preserve pending SError on exit from AArch32
>        KVM: arm64: pkvm: Consolidate include files
>        KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
>        KVM: arm64: pkvm: Pass vpcu instead of kvm to kvm_get_exit_handler_array()
>        KVM: arm64: pkvm: Give priority to standard traps over pvm handling
>        Merge branch kvm-arm64/pkvm/fixed-features into kvmarm-master/next
>        Merge branch kvm/selftests/memslot into kvmarm-master/next
> 
> Maxim Levitsky (4):
>        KVM: x86: nSVM: don't copy pause related settings
>        KVM: x86: SVM: add module param to control LBR virtualization
>        KVM: x86: SVM: add module param to control TSC scaling
>        KVM: x86: nSVM: implement nested TSC scaling
> 
> Michael Roth (1):
>        KVM: selftests: set CPUID before setting sregs in vcpu creation
> 
> Oliver Upton (9):
>        KVM: x86: Fix potential race in KVM_GET_CLOCK
>        KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
>        KVM: x86: Refactor tsc synchronization code
>        KVM: x86: Expose TSC offset controls to userspace
>        tools: arch: x86: pull in pvclock headers
>        selftests: KVM: Add test for KVM_{GET,SET}_CLOCK
>        selftests: KVM: Fix kvm device helper ioctl assertions
>        selftests: KVM: Add helpers for vCPU device attributes
>        selftests: KVM: Introduce system counter offset test
> 
> Paolo Bonzini (36):
>        KVM: x86: SVM: don't set VMLOAD/VMSAVE intercepts on vCPU reset
>        kvm: x86: abstract locking around pvclock_update_vm_gtod_copy
>        KVM: x86: extract KVM_GET_CLOCK/KVM_SET_CLOCK to separate functions
>        KVM: MMU: pass unadulterated gpa to direct_page_fault
>        KVM: MMU: Introduce struct kvm_page_fault
>        KVM: MMU: change mmu->page_fault() arguments to kvm_page_fault
>        KVM: MMU: change direct_page_fault() arguments to kvm_page_fault
>        KVM: MMU: change page_fault_handle_page_track() arguments to kvm_page_fault
>        KVM: MMU: change kvm_faultin_pfn() arguments to kvm_page_fault
>        KVM: MMU: change handle_abnormal_pfn() arguments to kvm_page_fault
>        KVM: MMU: change __direct_map() arguments to kvm_page_fault
>        KVM: MMU: change FNAME(fetch)() arguments to kvm_page_fault
>        KVM: MMU: change kvm_tdp_mmu_map() arguments to kvm_page_fault
>        KVM: MMU: change tdp_mmu_map_handle_target_level() arguments to kvm_page_fault
>        KVM: MMU: change fast_page_fault() arguments to kvm_page_fault
>        KVM: MMU: change kvm_mmu_hugepage_adjust() arguments to kvm_page_fault
>        KVM: MMU: change disallowed_hugepage_adjust() arguments to kvm_page_fault
>        KVM: MMU: change tracepoints arguments to kvm_page_fault
>        KVM: MMU: mark page dirty in make_spte
>        KVM: MMU: unify tdp_mmu_map_set_spte_atomic and tdp_mmu_set_spte_atomic_no_dirty_log
>        KVM: MMU: inline set_spte in mmu_set_spte
>        KVM: MMU: inline set_spte in FNAME(sync_page)
>        KVM: MMU: clean up make_spte return value
>        KVM: MMU: remove unnecessary argument to mmu_set_spte
>        KVM: MMU: set ad_disabled in TDP MMU role
>        KVM: MMU: pass kvm_mmu_page struct to make_spte
>        KVM: MMU: pass struct kvm_page_fault to mmu_set_spte
>        Merge tag 'kvm-riscv-5.16-1' of git://github.com/kvm-riscv/linux into HEAD
>        Merge commit 'kvm-pagedata-alloc-fixes' into HEAD
>        KVM: x86: avoid warning with -Wbitwise-instead-of-logical
>        kvm: x86: protect masterclock with a seqcount
>        KVM: x86/mmu: clean up prefetch/prefault/speculative naming
>        Merge branch 'kvm-pvclock-raw-spinlock' into HEAD
>        Merge tag 'kvmarm-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
>        Merge tag 'kvm-s390-next-5.16-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
>        Merge tag 'kvm-riscv-5.16-2' of https://github.com/kvm-riscv/linux into HEAD
> 
> Raghavendra Rao Ananta (14):
>        KVM: arm64: selftests: Add MMIO readl/writel support
>        tools: arm64: Import sysreg.h
>        KVM: arm64: selftests: Introduce ARM64_SYS_KVM_REG
>        KVM: arm64: selftests: Add support for cpu_relax
>        KVM: arm64: selftests: Add basic support for arch_timers
>        KVM: arm64: selftests: Add basic support to generate delays
>        KVM: arm64: selftests: Add support to disable and enable local IRQs
>        KVM: arm64: selftests: Maintain consistency for vcpuid type
>        KVM: arm64: selftests: Add guest support to get the vcpuid
>        KVM: arm64: selftests: Add light-weight spinlock support
>        KVM: arm64: selftests: Add basic GICv3 support
>        KVM: arm64: selftests: Add host support for vGIC
>        KVM: arm64: selftests: Add arch_timer test
>        KVM: arm64: selftests: arch_timer: Support vCPU migration
> 
> Ricardo Koller (13):
>        kvm: arm64: vgic: Introduce vgic_check_iorange
>        KVM: arm64: vgic-v3: Check redist region is not above the VM IPA size
>        KVM: arm64: vgic-v2: Check cpu interface region is not above the VM IPA size
>        KVM: arm64: vgic-v3: Check ITS region is not above the VM IPA size
>        KVM: arm64: vgic: Drop vgic_check_ioaddr()
>        KVM: arm64: selftests: Make vgic_init gic version agnostic
>        KVM: arm64: selftests: Make vgic_init/vm_gic_create version agnostic
>        KVM: arm64: selftests: Add some tests for GICv2 in vgic_init
>        KVM: arm64: selftests: Add tests for GIC redist/cpuif partially above IPA range
>        KVM: arm64: selftests: Add test for legacy GICv3 REDIST base partially above IPA range
>        KVM: arm64: selftests: Add init ITS device test
>        KVM: selftests: Make memslot_perf_test arch independent
>        KVM: selftests: Build the memslot tests for arm64
> 
> Sean Christopherson (23):
>        KVM: x86: Subsume nested GPA read helper into load_pdptrs()
>        KVM: x86: Simplify retrieving the page offset when loading PDTPRs
>        KVM: x86: Do not mark all registers as avail/dirty during RESET/INIT
>        KVM: x86: Remove defunct setting of CR0.ET for guests during vCPU create
>        KVM: x86: Remove defunct setting of XCR0 for guest during vCPU create
>        KVM: x86: Fold fx_init() into kvm_arch_vcpu_create()
>        KVM: VMX: Drop explicit zeroing of MSR guest values at vCPU creation
>        KVM: VMX: Move RESET emulation to vmx_vcpu_reset()
>        KVM: SVM: Move RESET emulation to svm_vcpu_reset()
>        KVM: x86: WARN on non-zero CRs at RESET to detect improper initalization
>        KVM: x86: Manually retrieve CPUID.0x1 when getting FMS for RESET/INIT
>        KVM: x86/mmu: Complete prefetch for trailing SPTEs for direct, legacy MMU
>        KVM: x86/mmu: Verify shadow walk doesn't terminate early in page faults
>        KVM: arm64: Unconditionally include generic KVM's Kconfig
>        KVM: arm64: Depend on HAVE_KVM instead of OF
>        KVM: x86: Add vendor name to kvm_x86_ops, use it for error messages
>        KVM: x86/mmu: Drop a redundant, broken remote TLB flush
>        KVM: x86/mmu: Drop a redundant remote TLB flush in kvm_zap_gfn_range()
>        KVM: x86/mmu: Extract zapping of rmaps for gfn range to separate helper
>        KVM: x86: Move SVM's APICv sanity check to common x86
>        KVM: x86: Use rw_semaphore for APICv lock to allow vCPU parallelism
>        x86/irq: Ensure PI wakeup handler is unregistered before module unload
>        KVM: VMX: Unregister posted interrupt wakeup handler on hardware unsetup
> 
> Thomas Huth (1):
>        KVM: selftests: Fix kvm_vm_free() in cr4_cpuid_sync and vmx_tsc_adjust tests
> 
> Vitaly Kuznetsov (6):
>        KVM: nVMX: Reset vmxon_ptr upon VMXOFF emulation.
>        KVM: x86: hyper-v: Avoid calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL
>        KVM: Optimize kvm_make_vcpus_request_mask() a bit
>        KVM: Drop 'except' parameter from kvm_make_vcpus_request_mask()
>        KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
>        KVM: Make kvm_make_vcpus_request_mask() use pre-allocated cpu_kick_mask
> 
> Wanpeng Li (2):
>        KVM: vPMU: Fill get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0
>        KVM: emulate: Comment on difference between RDPMC implementation and manual
> 
> Will Deacon (5):
>        arm64: Prevent kexec and hibernation if is_protected_kvm_enabled()
>        KVM: arm64: Reject stub hypercalls after pKVM has been initialised
>        KVM: arm64: Propagate errors from __pkvm_prot_finalize hypercall
>        KVM: arm64: Prevent re-finalisation of pKVM for a given CPU
>        KVM: arm64: Disable privileged hypercalls after pKVM finalisation
> 
> Xiaoyao Li (4):
>        KVM: VMX: Restore host's MSR_IA32_RTIT_CTL when it's not zero
>        KVM: VMX: Use precomputed vmx->pt_desc.addr_range
>        KVM: VMX: Rename pt_desc.addr_range to pt_desc.num_address_ranges
>        KVM: VMX: RTIT_CTL_BRANCH_EN has no dependency on other CPUID bit
> 
> Yang Li (1):
>        KVM: use vma_pages() helper
> 
> Yu Zhang (1):
>        KVM: nVMX: Use INVALID_GPA for pointers used in nVMX.
> 
> ran jianping (1):
>        RISC-V: KVM: remove unneeded semicolon
> 
>   Documentation/admin-guide/kernel-parameters.txt    |   15 +-
>   Documentation/virt/kvm/api.rst                     |  241 +++-
>   Documentation/virt/kvm/devices/vcpu.rst            |   70 ++
>   Documentation/virt/kvm/devices/xics.rst            |    2 +-
>   Documentation/virt/kvm/devices/xive.rst            |    2 +-
>   MAINTAINERS                                        |   12 +
>   arch/arm64/Kconfig                                 |    1 +
>   arch/arm64/include/asm/kvm_arm.h                   |    1 +
>   arch/arm64/include/asm/kvm_asm.h                   |   48 +-
>   arch/arm64/include/asm/kvm_emulate.h               |    5 +-
>   arch/arm64/include/asm/kvm_host.h                  |    4 +-
>   arch/arm64/include/asm/kvm_hyp.h                   |    5 +
>   arch/arm64/include/asm/sysreg.h                    |    3 +
>   arch/arm64/kernel/smp.c                            |    3 +-
>   arch/arm64/kvm/Kconfig                             |   10 +-
>   arch/arm64/kvm/arm.c                               |  102 +-
>   arch/arm64/kvm/hyp/include/hyp/fault.h             |   75 ++
>   arch/arm64/kvm/hyp/include/hyp/switch.h            |  235 ++--
>   arch/arm64/kvm/hyp/include/nvhe/fixed_config.h     |  200 +++
>   arch/arm64/kvm/hyp/include/nvhe/trap_handler.h     |    2 +
>   arch/arm64/kvm/hyp/nvhe/Makefile                   |    2 +-
>   arch/arm64/kvm/hyp/nvhe/host.S                     |   26 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   48 +-
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c              |   11 +-
>   arch/arm64/kvm/hyp/nvhe/pkvm.c                     |  185 +++
>   arch/arm64/kvm/hyp/nvhe/setup.c                    |    3 +
>   arch/arm64/kvm/hyp/nvhe/switch.c                   |   99 ++
>   arch/arm64/kvm/hyp/nvhe/sys_regs.c                 |  487 ++++++++
>   arch/arm64/kvm/hyp/vgic-v3-sr.c                    |   22 +-
>   arch/arm64/kvm/hyp/vhe/switch.c                    |   16 +
>   arch/arm64/kvm/mmu.c                               |    2 +-
>   arch/arm64/kvm/pmu-emul.c                          |    2 +-
>   arch/arm64/kvm/reset.c                             |    2 +-
>   arch/arm64/kvm/sys_regs.c                          |   41 +-
>   arch/arm64/kvm/vgic/vgic-init.c                    |    2 +-
>   arch/arm64/kvm/vgic/vgic-irqfd.c                   |    2 +-
>   arch/arm64/kvm/vgic/vgic-its.c                     |   18 +-
>   arch/arm64/kvm/vgic/vgic-kvm-device.c              |   25 +-
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |    8 +-
>   arch/arm64/kvm/vgic/vgic-v3.c                      |   27 +-
>   arch/arm64/kvm/vgic/vgic-v4.c                      |    2 +-
>   arch/arm64/kvm/vgic/vgic.h                         |    5 +-
>   arch/mips/kvm/mips.c                               |    2 +-
>   arch/powerpc/include/asm/kvm_book3s.h              |    2 +-
>   arch/powerpc/include/asm/kvm_host.h                |    4 +-
>   arch/powerpc/kvm/book3s_xive.c                     |    2 +-
>   arch/powerpc/kvm/powerpc.c                         |    2 +-
>   arch/riscv/Kconfig                                 |    2 +
>   arch/riscv/Makefile                                |    1 +
>   arch/riscv/include/asm/csr.h                       |   87 ++
>   arch/riscv/include/asm/kvm_host.h                  |  264 ++++
>   arch/riscv/include/asm/kvm_types.h                 |    7 +
>   arch/riscv/include/asm/kvm_vcpu_fp.h               |   59 +
>   arch/riscv/include/asm/kvm_vcpu_timer.h            |   44 +
>   arch/riscv/include/uapi/asm/kvm.h                  |  128 ++
>   arch/riscv/kernel/asm-offsets.c                    |  156 +++
>   arch/riscv/kvm/Kconfig                             |   35 +
>   arch/riscv/kvm/Makefile                            |   26 +
>   arch/riscv/kvm/main.c                              |  118 ++
>   arch/riscv/kvm/mmu.c                               |  802 ++++++++++++
>   arch/riscv/kvm/tlb.S                               |   74 ++
>   arch/riscv/kvm/vcpu.c                              |  825 +++++++++++++
>   arch/riscv/kvm/vcpu_exit.c                         |  701 +++++++++++
>   arch/riscv/kvm/vcpu_fp.c                           |  167 +++
>   arch/riscv/kvm/vcpu_sbi.c                          |  185 +++
>   arch/riscv/kvm/vcpu_switch.S                       |  400 ++++++
>   arch/riscv/kvm/vcpu_timer.c                        |  225 ++++
>   arch/riscv/kvm/vm.c                                |   97 ++
>   arch/riscv/kvm/vmid.c                              |  120 ++
>   arch/s390/include/asm/pgtable.h                    |    9 +-
>   arch/s390/include/asm/uv.h                         |   15 +-
>   arch/s390/kernel/uv.c                              |   65 +-
>   arch/s390/kvm/intercept.c                          |    5 +
>   arch/s390/kvm/kvm-s390.c                           |    7 +-
>   arch/s390/kvm/kvm-s390.h                           |    9 +
>   arch/s390/kvm/priv.c                               |    2 +
>   arch/s390/kvm/pv.c                                 |   21 +-
>   arch/s390/kvm/sigp.c                               |   14 +-
>   arch/s390/mm/gmap.c                                |   15 +-
>   arch/s390/mm/pgtable.c                             |  109 +-
>   arch/x86/include/asm/kvm_host.h                    |   48 +-
>   arch/x86/include/asm/kvm_page_track.h              |   11 +-
>   arch/x86/include/uapi/asm/kvm.h                    |    4 +
>   arch/x86/kernel/irq.c                              |    4 +-
>   arch/x86/kvm/Kconfig                               |    3 +
>   arch/x86/kvm/cpuid.c                               |   10 +-
>   arch/x86/kvm/emulate.c                             |    5 +
>   arch/x86/kvm/hyperv.c                              |   22 +-
>   arch/x86/kvm/ioapic.c                              |    2 +-
>   arch/x86/kvm/ioapic.h                              |    4 +-
>   arch/x86/kvm/mmu.h                                 |  114 +-
>   arch/x86/kvm/mmu/mmu.c                             |  702 ++++++-----
>   arch/x86/kvm/mmu/mmu_internal.h                    |   21 +-
>   arch/x86/kvm/mmu/mmutrace.h                        |   18 +-
>   arch/x86/kvm/mmu/page_track.c                      |   49 +-
>   arch/x86/kvm/mmu/paging_tmpl.h                     |  168 ++-
>   arch/x86/kvm/mmu/spte.c                            |   34 +-
>   arch/x86/kvm/mmu/spte.h                            |   21 +-
>   arch/x86/kvm/mmu/tdp_mmu.c                         |  119 +-
>   arch/x86/kvm/mmu/tdp_mmu.h                         |    6 +-
>   arch/x86/kvm/svm/nested.c                          |   52 +-
>   arch/x86/kvm/svm/sev.c                             |    6 +-
>   arch/x86/kvm/svm/svm.c                             |  168 ++-
>   arch/x86/kvm/svm/svm.h                             |    9 +-
>   arch/x86/kvm/trace.h                               |    9 +-
>   arch/x86/kvm/vmx/nested.c                          |   63 +-
>   arch/x86/kvm/vmx/pmu_intel.c                       |    6 +-
>   arch/x86/kvm/vmx/sgx.c                             |   16 +-
>   arch/x86/kvm/vmx/vmx.c                             |  136 +-
>   arch/x86/kvm/vmx/vmx.h                             |    2 +-
>   arch/x86/kvm/x86.c                                 |  800 +++++++-----
>   arch/x86/kvm/x86.h                                 |    2 -
>   drivers/clocksource/timer-riscv.c                  |    9 +
>   drivers/gpu/drm/i915/Kconfig                       |    1 +
>   include/clocksource/timer-riscv.h                  |   16 +
>   include/linux/kvm_host.h                           |   18 +-
>   include/uapi/linux/kvm.h                           |   29 +-
>   tools/arch/arm64/include/asm/sysreg.h              | 1296 ++++++++++++++++++++
>   tools/arch/x86/include/asm/pvclock-abi.h           |   48 +
>   tools/arch/x86/include/asm/pvclock.h               |  103 ++
>   tools/testing/selftests/kvm/.gitignore             |    3 +
>   tools/testing/selftests/kvm/Makefile               |    7 +-
>   tools/testing/selftests/kvm/aarch64/arch_timer.c   |  479 ++++++++
>   .../selftests/kvm/aarch64/debug-exceptions.c       |   30 +-
>   .../selftests/kvm/aarch64/psci_cpu_on_test.c       |    2 +-
>   tools/testing/selftests/kvm/aarch64/vgic_init.c    |  369 ++++--
>   .../selftests/kvm/include/aarch64/arch_timer.h     |  142 +++
>   .../testing/selftests/kvm/include/aarch64/delay.h  |   25 +
>   tools/testing/selftests/kvm/include/aarch64/gic.h  |   21 +
>   .../selftests/kvm/include/aarch64/processor.h      |   90 +-
>   .../selftests/kvm/include/aarch64/spinlock.h       |   13 +
>   tools/testing/selftests/kvm/include/aarch64/vgic.h |   20 +
>   tools/testing/selftests/kvm/include/kvm_util.h     |   13 +
>   tools/testing/selftests/kvm/kvm_create_max_vcpus.c |    2 +-
>   tools/testing/selftests/kvm/lib/aarch64/gic.c      |   95 ++
>   .../selftests/kvm/lib/aarch64/gic_private.h        |   21 +
>   tools/testing/selftests/kvm/lib/aarch64/gic_v3.c   |  240 ++++
>   tools/testing/selftests/kvm/lib/aarch64/gic_v3.h   |   70 ++
>   .../testing/selftests/kvm/lib/aarch64/processor.c  |   24 +-
>   tools/testing/selftests/kvm/lib/aarch64/spinlock.c |   27 +
>   tools/testing/selftests/kvm/lib/aarch64/vgic.c     |   70 ++
>   tools/testing/selftests/kvm/lib/kvm_util.c         |   46 +-
>   tools/testing/selftests/kvm/lib/sparsebit.c        |    2 +-
>   tools/testing/selftests/kvm/lib/x86_64/processor.c |    4 +-
>   tools/testing/selftests/kvm/lib/x86_64/svm.c       |   14 +-
>   tools/testing/selftests/kvm/memslot_perf_test.c    |   56 +-
>   .../selftests/kvm/system_counter_offset_test.c     |  132 ++
>   .../selftests/kvm/x86_64/cr4_cpuid_sync_test.c     |    3 +-
>   .../testing/selftests/kvm/x86_64/kvm_clock_test.c  |  203 +++
>   .../selftests/kvm/x86_64/vmx_tsc_adjust_test.c     |    2 +-
>   virt/kvm/eventfd.c                                 |   15 +-
>   virt/kvm/kvm_main.c                                |  127 +-
>   152 files changed, 11646 insertions(+), 1752 deletions(-)
> 
> 
> diff --cc arch/riscv/Kconfig
> index c28b743eba57,f5fe8a7f0e24..000000000000
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@@ -566,3 -561,6 +566,5 @@@ menu "Power management options
>    source "kernel/power/Kconfig"
>    
>    endmenu
> +
> + source "arch/riscv/kvm/Kconfig"
>   -source "drivers/firmware/Kconfig"
> diff --cc arch/x86/kvm/x86.c
> index 2686f2edb47c,ac83d873d65b..000000000000
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@@ -10485,16 -10869,15 +10730,6 @@@ static int sync_regs(struct kvm_vcpu *v
>    	return 0;
>    }
>    
> - static void fx_init(struct kvm_vcpu *vcpu)
>   -void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
> --{
> - 	/*
> - 	 * Ensure guest xcr0 is valid for loading
> - 	 */
> - 	vcpu->arch.xcr0 = XFEATURE_MASK_FP;
> -
> - 	vcpu->arch.cr0 |= X86_CR0_ET;
>   -	if (vcpu->arch.guest_fpu) {
>   -		kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
>   -		vcpu->arch.guest_fpu = NULL;
>   -	}
> --}
>   -EXPORT_SYMBOL_GPL(kvm_free_guest_fpu);
> --
>    int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>    {
>    	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
> @@@ -10551,13 -10934,24 +10786,11 @@@ int kvm_arch_vcpu_create(struct kvm_vcp
>    	if (!alloc_emulate_ctxt(vcpu))
>    		goto free_wbinvd_dirty_mask;
>    
>   -	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
>   -						GFP_KERNEL_ACCOUNT);
>   -	if (!vcpu->arch.user_fpu) {
>   -		pr_err("kvm: failed to allocate userspace's fpu\n");
>   -		goto free_emulate_ctxt;
>   -	}
>   -
>   -	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
>   -						 GFP_KERNEL_ACCOUNT);
>   -	if (!vcpu->arch.guest_fpu) {
>   +	if (!fpu_alloc_guest_fpstate(&vcpu->arch.guest_fpu)) {
>    		pr_err("kvm: failed to allocate vcpu's fpu\n");
>   -		goto free_user_fpu;
>   +		goto free_emulate_ctxt;
>    	}
>   -	fpstate_init(&vcpu->arch.guest_fpu->state);
>   -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>   -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
>   -			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>    
> - 	fx_init(vcpu);
> -
>    	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>    	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>    
> diff --cc arch/riscv/Kconfig
> index c28b743eba57,f5fe8a7f0e24..000000000000
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@@ -566,3 -561,6 +566,5 @@@ menu "Power management options
>    source "kernel/power/Kconfig"
>    
>    endmenu
> +
> + source "arch/riscv/kvm/Kconfig"
>   -source "drivers/firmware/Kconfig"
> diff --cc arch/x86/kvm/x86.c
> index 2686f2edb47c,ac83d873d65b..000000000000
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@@ -10485,16 -10869,15 +10730,6 @@@ static int sync_regs(struct kvm_vcpu *v
>    	return 0;
>    }
>    
> - static void fx_init(struct kvm_vcpu *vcpu)
>   -void kvm_free_guest_fpu(struct kvm_vcpu *vcpu)
> --{
> - 	/*
> - 	 * Ensure guest xcr0 is valid for loading
> - 	 */
> - 	vcpu->arch.xcr0 = XFEATURE_MASK_FP;
> -
> - 	vcpu->arch.cr0 |= X86_CR0_ET;
>   -	if (vcpu->arch.guest_fpu) {
>   -		kmem_cache_free(x86_fpu_cache, vcpu->arch.guest_fpu);
>   -		vcpu->arch.guest_fpu = NULL;
>   -	}
> --}
>   -EXPORT_SYMBOL_GPL(kvm_free_guest_fpu);
> --
>    int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>    {
>    	if (kvm_check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
> @@@ -10551,13 -10934,24 +10786,11 @@@ int kvm_arch_vcpu_create(struct kvm_vcp
>    	if (!alloc_emulate_ctxt(vcpu))
>    		goto free_wbinvd_dirty_mask;
>    
>   -	vcpu->arch.user_fpu = kmem_cache_zalloc(x86_fpu_cache,
>   -						GFP_KERNEL_ACCOUNT);
>   -	if (!vcpu->arch.user_fpu) {
>   -		pr_err("kvm: failed to allocate userspace's fpu\n");
>   -		goto free_emulate_ctxt;
>   -	}
>   -
>   -	vcpu->arch.guest_fpu = kmem_cache_zalloc(x86_fpu_cache,
>   -						 GFP_KERNEL_ACCOUNT);
>   -	if (!vcpu->arch.guest_fpu) {
>   +	if (!fpu_alloc_guest_fpstate(&vcpu->arch.guest_fpu)) {
>    		pr_err("kvm: failed to allocate vcpu's fpu\n");
>   -		goto free_user_fpu;
>   +		goto free_emulate_ctxt;
>    	}
>   -	fpstate_init(&vcpu->arch.guest_fpu->state);
>   -	if (boot_cpu_has(X86_FEATURE_XSAVES))
>   -		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
>   -			host_xcr0 | XSTATE_COMPACTION_ENABLED;
>    
> - 	fx_init(vcpu);
> -
>    	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
>    	vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
>    
> 
> 
