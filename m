Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E1937064D
	for <lists+kvm@lfdr.de>; Sat,  1 May 2021 10:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhEAIBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 May 2021 04:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhEAIBU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 May 2021 04:01:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4775DC06174A;
        Sat,  1 May 2021 01:00:30 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u3so509602eja.12;
        Sat, 01 May 2021 01:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:references:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zo3in7s5+kZxfkpkwJc8Nm0gh12e9fIeSgcHsg0IecQ=;
        b=htQen1V2KukjouJSISdTmwAuMGWABhMShpQDHySlYaGgMKFa1gcYsIlP1h3YXAg6x8
         C/LDxsCsZP0AwO7fHXmwyyG/+BFoq6E5WB2Sss1OH2n6MvcauQ9Bw8hfqeQq/dT9k1zc
         8EiEoZNI9rtw57lN/qU2hUJd5+k2vi4rErIhd7cO17/tmikXStc3pWLTwed8ukW29Bjp
         RiZKbZoYCcsTkuu5fafMuvFw7YX6DPRawiAFe0mWHcpxk4KddBYrP8tZce/YlqUJVhEp
         Udj65SdH2uMTQEVV6nfiuRTXD3QrwiEG/dJefx/G+ruAdhsE24Ql/+DXukTDceZJroNY
         mauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:references:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zo3in7s5+kZxfkpkwJc8Nm0gh12e9fIeSgcHsg0IecQ=;
        b=hw/v61YmvxbeEzxfjULSBorNBo3ZhfPmZ50h7+a8Gm6Pr0HpaV0d8ma1wFo8unJ5p6
         DOOCViEuDLALvDBuwXMwp6jr8TzqSSIVSZmjGfvqRuTmksZDOQQU3KmMUQb3akA8KiQV
         0KEgCL8VIkkL5dw9LEHKD7nA2lpqm8IPKjhtsqUZe7EiFkHkM94A3Tr+R+R+3bHhgNoP
         JbAvZE28Sr/UCg2mRRIuFdtrevJGTCmYuRCGhEfmCnJQyyLiBsQwH8p/caiX4hjAEqgy
         V8IOQRWig7OcnroKSJNSty7Cc3J1M0r7QwWWreUjbnmU52q8Y+deUUQmWK5/bMzTpV7J
         ATUA==
X-Gm-Message-State: AOAM530EXs7m+t+ZCQoEMaGw1m1l0o9kTs6ZSC1PkEPjXoNm9cn3Hcuu
        qnQ7Y48dpHCPzpH6hqdqXEg=
X-Google-Smtp-Source: ABdhPJyEdeO6358pkwlMXkPjCxjk3hdku9lQdcGY5c7zOdIdanKBX/Swo4c3E22P84hBhRngYXLcJQ==
X-Received: by 2002:a17:906:2ac5:: with SMTP id m5mr8190180eje.517.1619856028694;
        Sat, 01 May 2021 01:00:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id z26sm4516816ejd.52.2021.05.01.01.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 01:00:27 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20210428230528.189146-1-pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM, AMD PSP and ARM CoreSight changes for 5.13 merge
 window
Message-ID: <61aa0633-d69c-f1b6-dc9f-6ca9442fbbab@redhat.com>
Date:   Sat, 1 May 2021 10:00:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210428230528.189146-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 01:05, Paolo Bonzini wrote:
> Linus,
> 
> The following changes since commit 523caed9efbb049339706b124185c9358c1b6477:
> 
>    x86/sgx: Mark sgx_vepc_vm_ops static (2021-04-12 19:48:32 +0200)
> 
> are available in the Git repository at:
> 
>    https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
> 
> for you to fetch changes up to 3bf0fcd754345d7ea63e1446015ba65ece6788ca:
> 
>    KVM: selftests: Speed up set_memory_region_test (2021-04-26 12:21:27 -0400)

Hi Linus,

is there anything wrong with this pull request?  (I saw that in the 
meanwhile you did the MIPS pull, so the conflict on 
arch/mips/kvm/trap_emul.c will happen when you pull from me).

Mathieu, can you confirm that your coresight branch will *not* be sent 
by the ARM maintainers as well?  (Typically they are sent to both 
upstream maintainers, in this case that would be ARM and KVM/ARM->KVM; 
this is also why I waited until Thursday to send my pull request, as I 
would have preferred if all the topic branches had been merged already).

Thanks,

Paolo

> 
> It's a fairly large pull request for KVM standards.  There were quite
> a few common topic branches and crossover series with other trees,
> especially within KVM ARM, which I need to mention explicitly.
> In particular:
> 
> - the coresight/next-ETE-TRBE branch from the KVM ARM tree hasn't yet
> reached you, so I am CCing the maintainer.  Since he sent the patches
> as a pull request to Marc Zyngier (the KVM ARM maintainer) at
> https://lore.kernel.org/kvmarm/20210406224437.330939-1-mathieu.poirier@linaro.org/T/#u,
> I actually suspect that from his point of view he's done.
> 
> - Herbert Xu and Tom Lendacky asked to include AMD PSP driver changes
> in this pull request
> 
> - the KVM ARM tree also brought in a handful of "Get rid of oprofile
> leftovers" patches for other architectures, but they all have maintainer
> acks and are just cleanups, so I am a bit less worried there.
> 
> I hope all this is okay.
> 
> 
> Despite the juggling of topic branches, a couple conflicts escaped:
> 
> - the worst is with the tip rework of x86 TLB flushes.  Basically, tip
> renamed kvm_flush_tlb_others to kvm_flush_tlb_multi, added a comment and
> moved it to a different position.  KVM moved it somewhere else, so after
> merging you'll have both kvm_flush_tlb_multi and kvm_flush_tlb_others.
> You need to take kvm_flush_tlb_multi and paste it in place of
> kvm_flush_tlb_others.  For everything else the KVM code is the correct
> one, again except for s/kvm_flush_tlb_others/kvm_flush_tlb_multi/.
> I have placed the relevant hunks of the "diff --combined" output at the
> end of this message.
> 
> - arch/mips/kvm/trap_emul.c has been deleted in the MIPS tree, which
> will cause a modify/delete conflict either now or when merging the
> MIPS tree.  The conflict is of course solved just by deleting the file.
> For the future, Thomas Bogendorfer will either not take KVM patches or
> ensure that we have a common topic branch.
> 
> 
> Thanks,
> 
> Paolo
> 
> ----------------------------------------------------------------
> ARM:
> 
> - Stage-2 isolation for the host kernel when running in protected mode
> 
> - Guest SVE support when running in nVHE mode
> 
> - Force W^X hypervisor mappings in nVHE mode
> 
> - ITS save/restore for guests using direct injection with GICv4.1
> 
> - nVHE panics now produce readable backtraces
> 
> - Guest support for PTP using the ptp_kvm driver
> 
> - Performance improvements in the S2 fault handler
> 
> x86:
> 
> - Optimizations and cleanup of nested SVM code
> 
> - AMD: Support for virtual SPEC_CTRL
> 
> - Optimizations of the new MMU code: fast invalidation,
>    zap under read lock, enable/disably dirty page logging under
>    read lock
> 
> - /dev/kvm API for AMD SEV live migration (guest API coming soon)
> 
> - support SEV virtual machines sharing the same encryption context
> 
> - support SGX in virtual machines
> 
> - add a few more statistics
> 
> - improved directed yield heuristics
> 
> - Lots and lots of cleanups
> 
> Generic:
> 
> - Rework of MMU notifier interface, simplifying and optimizing
> the architecture-specific code
> 
> - Some selftests improvements
> 
> ----------------------------------------------------------------
> Alexandru Elisei (4):
>        Documentation: KVM: Document KVM_GUESTDBG_USE_HW control flag for arm64
>        KVM: arm64: Initialize VCPU mdcr_el2 before loading it
>        KVM: arm64: Don't print warning when trapping SPE registers
>        KVM: arm64: Don't advertise FEAT_SPE to guests
> 
> Andrew Scull (5):
>        bug: Remove redundant condition check in report_bug
>        bug: Factor out a getter for a bug's file line
>        bug: Assign values once in bug_get_file_line()
>        KVM: arm64: Use BUG and BUG_ON in nVHE hyp
>        KVM: arm64: Log source when panicking from nVHE hyp
> 
> Anshuman Khandual (5):
>        arm64: Add TRBE definitions
>        coresight: core: Add support for dedicated percpu sinks
>        coresight: sink: Add TRBE driver
>        Documentation: coresight: trbe: Sysfs ABI description
>        Documentation: trace: Add documentation for TRBE
> 
> Babu Moger (2):
>        x86/cpufeatures: Add the Virtual SPEC_CTRL feature
>        KVM: SVM: Add support for Virtual SPEC_CTRL
> 
> Ben Gardon (13):
>        KVM: x86/mmu: Re-add const qualifier in kvm_tdp_mmu_zap_collapsible_sptes
>        KVM: x86/mmu: Move kvm_mmu_(get|put)_root to TDP MMU
>        KVM: x86/mmu: use tdp_mmu_free_sp to free roots
>        KVM: x86/mmu: Merge TDP MMU put and free root
>        KVM: x86/mmu: Refactor yield safe root iterator
>        KVM: x86/mmu: Make TDP MMU root refcount atomic
>        KVM: x86/mmu: handle cmpxchg failure in kvm_tdp_mmu_get_root
>        KVM: x86/mmu: Protect the tdp_mmu_roots list with RCU
>        KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock
>        KVM: x86/mmu: Allow zapping collapsible SPTEs to use MMU read lock
>        KVM: x86/mmu: Allow enabling/disabling dirty logging under MMU read lock
>        KVM: x86/mmu: Fast invalidation for TDP MMU
>        KVM: x86/mmu: Tear down roots before kvm_mmu_zap_all_fast returns
> 
> Bhaskar Chowdhury (1):
>        KVM: s390: Fix comment spelling in kvm_s390_vcpu_start()
> 
> Brijesh Singh (6):
>        KVM: SVM: Add KVM_SEV SEND_START command
>        KVM: SVM: Add KVM_SEND_UPDATE_DATA command
>        KVM: SVM: Add KVM_SEV_SEND_FINISH command
>        KVM: SVM: Add support for KVM_SEV_RECEIVE_START command
>        KVM: SVM: Add KVM_SEV_RECEIVE_UPDATE_DATA command
>        KVM: SVM: Add KVM_SEV_RECEIVE_FINISH command
> 
> Cathy Avery (4):
>        KVM: SVM: Use a separate vmcb for the nested L2 guest
>        KVM: nSVM: Track the physical cpu of the vmcb vmrun through the vmcb
>        KVM: nSVM: Track the ASID generation of the vmcb vmrun through the vmcb
>        KVM: nSVM: Optimize vmcb12 to vmcb02 save area copies
> 
> Claudio Imbrenda (5):
>        KVM: s390: split kvm_s390_logical_to_effective
>        KVM: s390: extend kvm_s390_shadow_fault to return entry pointer
>        KVM: s390: VSIE: correctly handle MVPG when in VSIE
>        KVM: s390: split kvm_s390_real_to_abs
>        KVM: s390: VSIE: fix MVPG handling for prefixing and MSO
> 
> Daniel Kiss (1):
>        KVM: arm64: Enable SVE support for nVHE
> 
> David Brazdil (1):
>        KVM: arm64: Support PREL/PLT relocs in EL2 code
> 
> David Edmondson (5):
>        KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid
>        KVM: x86: dump_vmcs should not conflate EFER and PAT presence in VMCS
>        KVM: x86: dump_vmcs should consider only the load controls of EFER/PAT
>        KVM: x86: dump_vmcs should show the effective EFER
>        KVM: x86: dump_vmcs should include the autoload/autostore MSR lists
> 
> Dongli Zhang (1):
>        KVM: x86: to track if L1 is running L2 VM
> 
> Emanuele Giuseppe Esposito (1):
>        doc/virt/kvm: move KVM_CAP_PPC_MULTITCE in section 8
> 
> Eric Auger (11):
>        KVM: arm64: vgic-v3: Fix some error codes when setting RDIST base
>        KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read
>        KVM: arm64: vgic-v3: Fix error handling in vgic_v3_set_redist_base()
>        KVM: arm/arm64: vgic: Reset base address on kvm_vgic_dist_destroy()
>        docs: kvm: devices/arm-vgic-v3: enhance KVM_DEV_ARM_VGIC_CTRL_INIT doc
>        KVM: arm64: Simplify argument passing to vgic_uaccess_[read|write]
>        kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()
>        KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for userspace
>        KVM: selftests: aarch64/vgic-v3 init sequence tests
>        KVM: selftests: vgic_init kvm selftests fixup
>        KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read
> 
> Gavin Shan (3):
>        KVM: arm64: Hide kvm_mmu_wp_memory_region()
>        KVM: arm64: Use find_vma_intersection()
>        KVM: arm64: Don't retrieve memory slot again in page fault handler
> 
> Haiwei Li (2):
>        KVM: vmx: add mismatched size assertions in vmcs_check32()
>        KVM: x86: Take advantage of kvm_arch_dy_has_pending_interrupt()
> 
> Heiko Carstens (1):
>        KVM: s390: fix guarded storage control register handling
> 
> Isaku Yamahata (1):
>        KVM: VMX: use EPT_VIOLATION_GVA_TRANSLATED instead of 0x100
> 
> Jianyong Wu (4):
>        ptp: Reorganize ptp_kvm.c to make it arch-independent
>        clocksource: Add clocksource id for arm arch counter
>        KVM: arm64: Add support for the KVM PTP service
>        ptp: arm/arm64: Enable ptp_kvm for arm/arm64
> 
> Jon Hunter (1):
>        ptp: Don't print an error if ptp_kvm is not supported
> 
> Keqian Zhu (1):
>        KVM: x86: Remove unused function declaration
> 
> Krish Sadhukhan (4):
>        KVM: nSVM: Add missing checks for reserved bits to svm_set_nested_state()
>        KVM: nSVM: If VMRUN is single-stepped, queue the #DB intercept in nested_svm_vmexit()
>        KVM: SVM: Define actual size of IOPM and MSRPM tables
>        nSVM: Check addresses of MSR and IO permission maps
> 
> Marc Zyngier (47):
>        KVM: arm64: Provide KVM's own save/restore SVE primitives
>        KVM: arm64: Use {read,write}_sysreg_el1 to access ZCR_EL1
>        KVM: arm64: Let vcpu_sve_pffr() handle HYP VAs
>        KVM: arm64: Introduce vcpu_sve_vq() helper
>        arm64: sve: Provide a conditional update accessor for ZCR_ELx
>        KVM: arm64: Rework SVE host-save/guest-restore
>        KVM: arm64: Map SVE context at EL2 when available
>        KVM: arm64: Save guest's ZCR_EL1 before saving the FPSIMD state
>        KVM: arm64: Trap host SVE accesses when the FPSIMD state is dirty
>        KVM: arm64: Save/restore SVE state for nVHE
>        arm64: Use INIT_SCTLR_EL1_MMU_OFF to disable the MMU on CPU restart
>        KVM: arm64: Use INIT_SCTLR_EL2_MMU_OFF to disable the MMU on KVM teardown
>        KVM: arm64: Turn SCTLR_ELx_FLAGS into INIT_SCTLR_EL2_MMU_ON
>        KVM: arm64: Force SCTLR_EL2.WXN when running nVHE
>        KVM: arm64: Fix host's ZCR_EL2 restore on nVHE
>        Merge tag 'v5.12-rc3' into kvm-arm64/host-stage2
>        irqchip/gic-v3-its: Add a cache invalidation right after vPE unmapping
>        KVM: arm64: Generate final CTR_EL0 value when running in Protected mode
>        KVM: arm64: Drop the CPU_FTR_REG_HYP_COPY infrastructure
>        KVM: arm64: Elect Alexandru as a replacement for Julien as a reviewer
>        KVM: arm64: Mark the kvmarm ML as moderated for non-subscribers
>        KVM: arm64: Fix table format for PTP documentation
>        Merge remote-tracking branch 'coresight/next-ETE-TRBE' into kvmarm-master/next
>        KVM: arm64: Clarify vcpu reset behaviour
>        KVM: arm64: Fully zero the vcpu state on reset
>        Merge branch 'kvm-arm64/debug-5.13' into kvmarm-master/next
>        Merge branch 'kvm-arm64/host-stage2' into kvmarm-master/next
>        Merge branch 'kvm-arm64/memslot-fixes' into kvmarm-master/next
>        Merge branch 'kvm-arm64/misc-5.13' into kvmarm-master/next
>        Merge branch 'kvm-arm64/nvhe-panic-info' into kvmarm-master/next
>        Merge branch 'kvm-arm64/nvhe-sve' into kvmarm-master/next
>        Merge branch 'kvm-arm64/nvhe-wxn' into kvmarm-master/next
>        Merge branch 'kvm-arm64/ptp' into kvmarm-master/next
>        Merge branch 'kvm-arm64/vgic-5.13' into kvmarm-master/next
>        Merge branch 'kvm-arm64/vlpi-save-restore' into kvmarm-master/next
>        Merge remote-tracking branch 'arm64/for-next/vhe-only' into kvmarm-master/next
>        Merge remote-tracking branch 'arm64/for-next/neon-softirqs-disabled' into kvmarm-master/next
>        Merge remote-tracking branch 'coresight/next-ETE-TRBE' into kvmarm-master/next
>        bug: Provide dummy version of bug_get_file_line() when !GENERIC_BUG
>        Merge branch 'kvm-arm64/nvhe-panic-info' into kvmarm-master/next
>        Merge branch 'kvm-arm64/ptp' into kvmarm-master/next
>        KVM: arm64: Divorce the perf code from oprofile helpers
>        arm64: Get rid of oprofile leftovers
>        s390: Get rid of oprofile leftovers
>        sh: Get rid of oprofile leftovers
>        perf: Get rid of oprofile leftovers
>        Merge branch 'kvm-arm64/kill_oprofile_dependency' into kvmarm-master/next
> 
> Maxim Levitsky (10):
>        KVM: nSVM: always use vmcb01 to for vmsave/vmload of guest state
>        KVM: x86: determine if an exception has an error code only when injecting it.
>        KVM: x86: mmu: initialize fault.async_page_fault in walk_addr_generic
>        KVM: x86: add guest_cpuid_is_intel
>        KVM: nSVM: improve SYSENTER emulation on AMD
>        KVM: nSVM: call nested_svm_load_cr3 on nested state load
>        KVM: x86: pending exceptions must not be blocked by an injected event
>        KVM: x86: implement KVM_CAP_SET_GUEST_DEBUG2
>        KVM: aarch64: implement KVM_CAP_SET_GUEST_DEBUG2
>        KVM: s390x: implement KVM_CAP_SET_GUEST_DEBUG2
> 
> Nathan Tempelman (1):
>        KVM: x86: Support KVM VMs sharing SEV context
> 
> Paolo Bonzini (27):
>        KVM: nSVM: rename functions and variables according to vmcbXY nomenclature
>        KVM: nSVM: do not copy vmcb01->control blindly to vmcb02->control
>        KVM: nSVM: do not mark all VMCB01 fields dirty on nested vmexit
>        KVM: nSVM: do not mark all VMCB02 fields dirty on nested vmexit
>        KVM: nSVM: only copy L1 non-VMLOAD/VMSAVE data in svm_set_nested_state()
>        KVM: SVM: merge update_cr0_intercept into svm_set_cr0
>        KVM: SVM: Pass struct kvm_vcpu to exit handlers (and many, many other places)
>        KVM: SVM: move VMLOAD/VMSAVE to C code
>        Merge branch 'kvm-fix-svm-races' into HEAD
>        Merge branch 'kvm-tdp-fix-flushes' into HEAD
>        Merge branch 'kvm-tdp-fix-rcu' into HEAD
>        Merge tag 'kvm-s390-next-5.13-1' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
>        Merge tag 'kvm-s390-next-5.13-2' of git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux into HEAD
>        Merge remote-tracking branch 'tip/x86/sgx' into kvm-next
>        KVM: MMU: load PDPTRs outside mmu_lock
>        KVM: introduce KVM_CAP_SET_GUEST_DEBUG2
>        KVM: MMU: protect TDP MMU pages only down to required level
>        KVM: constify kvm_arch_flush_remote_tlbs_memslot
>        KVM: MIPS: rework flush_shadow_* callbacks into one that prepares the flush
>        KVM: MIPS: let generic code call prepare_flush_shadow
>        KVM: MIPS: defer flush to generic MMU notifier code
>        KVM: selftests: Always run vCPU thread with blocked SIG_IPI
>        KVM: x86: document behavior of measurement ioctls with len==0
>        Merge branch 'kvm-sev-cgroup' into HEAD
>        Merge tag 'kvmarm-5.13' of git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm into HEAD
>        KVM: documentation: fix sphinx warnings
>        KVM: SEV: Mask CPUID[0x8000001F].eax according to supported features
> 
> Peter Xu (1):
>        KVM: selftests: Sync data verify of dirty logging with guest sync
> 
> Pierre Morel (1):
>        KVM: s390: diag9c (directed yield) forwarding
> 
> Quentin Perret (35):
>        KVM: arm64: Initialize kvm_nvhe_init_params early
>        KVM: arm64: Avoid free_page() in page-table allocator
>        KVM: arm64: Factor memory allocation out of pgtable.c
>        KVM: arm64: Introduce a BSS section for use at Hyp
>        KVM: arm64: Make kvm_call_hyp() a function call at Hyp
>        KVM: arm64: Allow using kvm_nvhe_sym() in hyp code
>        KVM: arm64: Introduce an early Hyp page allocator
>        KVM: arm64: Stub CONFIG_DEBUG_LIST at Hyp
>        KVM: arm64: Introduce a Hyp buddy page allocator
>        KVM: arm64: Enable access to sanitized CPU features at EL2
>        KVM: arm64: Provide __flush_dcache_area at EL2
>        KVM: arm64: Factor out vector address calculation
>        arm64: asm: Provide set_sctlr_el2 macro
>        KVM: arm64: Prepare the creation of s1 mappings at EL2
>        KVM: arm64: Elevate hypervisor mappings creation at EL2
>        KVM: arm64: Use kvm_arch for stage 2 pgtable
>        KVM: arm64: Use kvm_arch in kvm_s2_mmu
>        KVM: arm64: Set host stage 2 using kvm_nvhe_init_params
>        KVM: arm64: Refactor kvm_arm_setup_stage2()
>        KVM: arm64: Refactor __load_guest_stage2()
>        KVM: arm64: Refactor __populate_fault_info()
>        KVM: arm64: Make memcache anonymous in pgtable allocator
>        KVM: arm64: Reserve memory for host stage 2
>        KVM: arm64: Sort the hypervisor memblocks
>        KVM: arm64: Always zero invalid PTEs
>        KVM: arm64: Use page-table to track page ownership
>        KVM: arm64: Refactor the *_map_set_prot_attr() helpers
>        KVM: arm64: Add kvm_pgtable_stage2_find_range()
>        KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB stage 2 flag
>        KVM: arm64: Introduce KVM_PGTABLE_S2_IDMAP stage 2 flag
>        KVM: arm64: Provide sanitized mmfr* registers at EL2
>        KVM: arm64: Wrap the host with a stage 2
>        KVM: arm64: Page-align the .hyp sections
>        KVM: arm64: Disable PMU support in protected mode
>        KVM: arm64: Protect the .hyp sections from the host
> 
> Ricardo Koller (1):
>        KVM: x86: Move reverse CPUID helpers to separate header file
> 
> Sean Christopherson (147):
>        KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT with 64-bit
>        KVM: x86/mmu: Capture 'mmu' in a local variable when allocating roots
>        KVM: x86/mmu: Allocate the lm_root before allocating PAE roots
>        KVM: x86/mmu: Allocate pae_root and lm_root pages in dedicated helper
>        KVM: x86/mmu: Ensure MMU pages are available when allocating roots
>        KVM: x86/mmu: Check PDPTRs before allocating PAE roots
>        KVM: x86/mmu: Fix and unconditionally enable WARNs to detect PAE leaks
>        KVM: x86/mmu: Set the C-bit in the PDPTRs and LM pseudo-PDPTRs
>        KVM: nVMX: Defer the MMU reload to the normal path on an EPTP switch
>        KVM: x86: Defer the MMU unload to the normal path on an global INVPCID
>        KVM: x86/mmu: Unexport MMU load/unload functions
>        KVM: x86/mmu: Sync roots after MMU load iff load as successful
>        KVM: x86/mmu: WARN on NULL pae_root or lm_root, or bad shadow root level
>        KVM: SVM: Don't strip the C-bit from CR2 on #PF interception
>        KVM: nSVM: Set the shadow root level to the TDP level for nested NPT
>        KVM: x86: Move nVMX's consistency check macro to common code
>        KVM: nSVM: Trace VM-Enter consistency check failures
>        KVM: x86: Handle triple fault in L2 without killing L1
>        KVM: nSVM: Add helper to synthesize nested VM-Exit without collateral
>        KVM: nSVM: Add VMLOAD/VMSAVE helper to deduplicate code
>        KVM: x86: Move XSETBV emulation to common code
>        KVM: x86: Move trivial instruction-based exit handlers to common code
>        KVM: x86: Move RDPMC emulation to common code
>        KVM: SVM: Don't manually emulate RDPMC if nrips=0
>        KVM: SVM: Skip intercepted PAUSE instructions after emulation
>        KVM: x86/mmu: Remove spurious TLB flush from TDP MMU's change_pte() hook
>        KVM: x86/mmu: WARN if TDP MMU's set_tdp_spte() sees multiple GFNs
>        KVM: x86/mmu: Use 'end' param in TDP MMU's test_age_gfn()
>        KVM: x86/mmu: Add typedefs for rmap/iter handlers
>        KVM: x86/mmu: Add convenience wrapper for acting on single hva in TDP MMU
>        KVM: x86/mmu: Check for shadow-present SPTE before querying A/D status
>        KVM: x86/mmu: Bail from fast_page_fault() if SPTE is not shadow-present
>        KVM: x86/mmu: Disable MMIO caching if MMIO value collides with L1TF
>        KVM: x86/mmu: Retry page faults that hit an invalid memslot
>        KVM: x86/mmu: Don't install bogus MMIO SPTEs if MMIO caching is disabled
>        KVM: x86/mmu: Handle MMIO SPTEs directly in mmu_set_spte()
>        KVM: x86/mmu: Drop redundant trace_kvm_mmu_set_spte() in the TDP MMU
>        KVM: x86/mmu: Rename 'mask' to 'spte' in MMIO SPTE helpers
>        KVM: x86/mmu: Stop using software available bits to denote MMIO SPTEs
>        KVM: x86/mmu: Add module param to disable MMIO caching (for testing)
>        KVM: x86/mmu: Rename and document A/D scheme for TDP SPTEs
>        KVM: x86/mmu: Use MMIO SPTE bits 53 and 52 for the MMIO generation
>        KVM: x86/mmu: Document dependency bewteen TDP A/D type and saved bits
>        KVM: x86/mmu: Move initial kvm_mmu_set_mask_ptes() call into MMU proper
>        KVM: x86/mmu: Co-locate code for setting various SPTE masks
>        KVM: x86/mmu: Move logic for setting SPTE masks for EPT into the MMU proper
>        KVM: x86/mmu: Make Host-writable and MMU-writable bit locations dynamic
>        KVM: x86/mmu: Use high bits for host/mmu writable masks for EPT SPTEs
>        KVM: x86/mmu: Use a dedicated bit to track shadow/MMU-present SPTEs
>        KVM: x86/mmu: Tweak auditing WARN for A/D bits to !PRESENT (was MMIO)
>        KVM: x86/mmu: Use is_removed_spte() instead of open coded equivalents
>        KVM: x86/mmu: Use low available bits for removed SPTEs
>        KVM: x86/mmu: Dump reserved bits if they're detected on non-MMIO SPTE
>        KVM: x86: Get active PCID only when writing a CR3 value
>        KVM: VMX: Track common EPTP for Hyper-V's paravirt TLB flush
>        KVM: VMX: Stash kvm_vmx in a local variable for Hyper-V paravirt TLB flush
>        KVM: VMX: Fold Hyper-V EPTP checking into it's only caller
>        KVM: VMX: Do Hyper-V TLB flush iff vCPU's EPTP hasn't been flushed
>        KVM: VMX: Invalidate hv_tlb_eptp to denote an EPTP mismatch
>        KVM: VMX: Don't invalidate hv_tlb_eptp if the new EPTP matches
>        KVM: VMX: Explicitly check for hv_remote_flush_tlb when loading pgd
>        KVM: VMX: Define Hyper-V paravirt TLB flush fields iff Hyper-V is enabled
>        KVM: VMX: Skip additional Hyper-V TLB EPTP flushes if one fails
>        KVM: VMX: Track root HPA instead of EPTP for paravirt Hyper-V TLB flush
>        KVM: x86/mmu: Use '0' as the one and only value for an invalid PAE root
>        KVM: x86/mmu: Mark the PAE roots as decrypted for shadow paging
>        KVM: x86/mmu: Coalesce TDP MMU TLB flushes when zapping collapsible SPTEs
>        KVM: x86/mmu: Move flushing for "slot" handlers to caller for legacy MMU
>        KVM: x86/mmu: Coalesce TLB flushes when zapping collapsible SPTEs
>        KVM: x86/mmu: Coalesce TLB flushes across address spaces for gfn range zap
>        KVM: x86/mmu: Pass address space ID to __kvm_tdp_mmu_zap_gfn_range()
>        KVM: x86/mmu: Pass address space ID to TDP MMU root walkers
>        KVM: x86/mmu: Use leaf-only loop for walking TDP SPTEs when changing SPTE
>        KVM: Move prototypes for MMU notifier callbacks to generic code
>        KVM: Move arm64's MMU notifier trace events to generic code
>        KVM: x86/mmu: Drop trace_kvm_age_page() tracepoint
>        KVM: x86/mmu: Remove spurious clearing of dirty bit from TDP MMU SPTE
>        KVM: x86/mmu: Simplify code for aging SPTEs in TDP MMU
>        KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs
>        KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes
>        KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs are created
>        KVM: x86: Account a variety of miscellaneous allocations
>        KVM: Explicitly use GFP_KERNEL_ACCOUNT for 'struct kvm_vcpu' allocations
>        KVM: Assert that notifier count is elevated in .change_pte()
>        KVM: Move x86's MMU notifier memslot walkers to generic code
>        KVM: arm64: Convert to the gfn-based MMU notifier callbacks
>        KVM: MIPS/MMU: Convert to the gfn-based MMU notifier callbacks
>        KVM: PPC: Convert to the gfn-based MMU notifier callbacks
>        KVM: Kill off the old hva-based MMU notifier callbacks
>        KVM: Move MMU notifier's mmu_lock acquisition into common helper
>        KVM: Take mmu_lock when handling MMU notifier iff the hva hits a memslot
>        KVM: x86/mmu: Allow yielding during MMU notifier unmap/zap, if possible
>        KVM: SVM: Don't set current_vmcb->cpu when switching vmcb
>        KVM: SVM: Drop vcpu_svm.vmcb_pa
>        KVM: SVM: Add a comment to clarify what vcpu_svm.vmcb points at
>        KVM: SVM: Enhance and clean up the vmcb tracking comment in pre_svm_run()
>        KVM: Destroy I/O bus devices on unregister failure _after_ sync'ing SRCU
>        KVM: Stop looking for coalesced MMIO zones if the bus is destroyed
>        KVM: Add proper lockdep assertion in I/O bus unregister
>        KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
>        KVM: x86: Define new #PF SGX error code bit
>        KVM: x86: Add support for reverse CPUID lookup of scattered features
>        KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
>        KVM: VMX: Add basic handling of VM-Exit from SGX enclave
>        KVM: VMX: Frame in ENCLS handler for SGX virtualization
>        KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
>        KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
>        KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
>        KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
>        KVM: x86: Add capability to grant VM access to privileged SGX attribute
>        crypto: ccp: Free SEV device if SEV init fails
>        crypto: ccp: Detect and reject "invalid" addresses destined for PSP
>        crypto: ccp: Reject SEV commands with mismatching command buffer
>        crypto: ccp: Play nice with vmalloc'd memory for SEV command structs
>        crypto: ccp: Use the stack for small SEV command buffers
>        crypto: ccp: Use the stack and common buffer for status commands
>        crypto: ccp: Use the stack and common buffer for INIT command
>        KVM: SVM: Allocate SEV command structures on local stack
>        KVM: x86: Fix implicit enum conversion goof in scattered reverse CPUID code
>        KVM: VMX: Invert the inlining of MSR interception helpers
>        KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP unsupported
>        KVM: SVM: Clear MSR_TSC_AUX[63:32] on write
>        KVM: SVM: Delay restoration of host MSR_TSC_AUX until return to userspace
>        KVM: VMX: Intercept FS/GS_BASE MSR accesses for 32-bit KVM
>        KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4 loads
>        KVM: x86: Check CR3 GPA for validity regardless of vCPU mode
>        KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode
>        KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit mode
>        KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in !64-bit
>        KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit
>        KVM: x86/xen: Drop RAX[63:32] when processing hypercall
>        KVM: SVM: Use default rAX size for INVLPGA emulation
>        KVM: x86: Rename GPR accessors to make mode-aware variants the defaults
>        x86/sev: Drop redundant and potentially misleading 'sev_enabled'
>        KVM: SVM: Zero out the VMCB array used to track SEV ASID association
>        KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
>        KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
>        KVM: SVM: Move SEV module params/variables to sev.c
>        KVM: SVM: Append "_enabled" to module-scoped SEV/SEV-ES control variables
>        KVM: SVM: Condition sev_enabled and sev_es_enabled on CONFIG_KVM_AMD_SEV=y
>        KVM: SVM: Enable SEV/SEV-ES functionality by default (when supported)
>        KVM: SVM: Unconditionally invoke sev_hardware_teardown()
>        KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
>        KVM: SVM: Move SEV VMCB tracking allocation to sev.c
>        KVM: SVM: Drop redundant svm_sev_enabled() helper
>        KVM: SVM: Remove an unnecessary prototype declaration of sev_flush_asids()
>        KVM: SVM: Skip SEV cache flush if no ASIDs have been used
> 
> Shenming Lu (4):
>        irqchip/gic-v3-its: Drop the setting of PTZ altogether
>        KVM: arm64: GICv4.1: Add function to get VLPI state
>        KVM: arm64: GICv4.1: Try to save VLPI state in save_pending_tables
>        KVM: arm64: GICv4.1: Give a chance to save VLPI state
> 
> Steve Rutherford (1):
>        KVM: SVM: Add support for KVM_SEV_SEND_CANCEL command
> 
> Suzuki K Poulose (15):
>        perf: aux: Add flags for the buffer format
>        perf: aux: Add CoreSight PMU buffer formats
>        arm64: Add support for trace synchronization barrier
>        KVM: arm64: Handle access to TRFCR_EL1
>        KVM: arm64: Move SPE availability check to VCPU load
>        arm64: KVM: Enable access to TRBE support for host
>        coresight: etm4x: Move ETM to prohibited region for disable
>        coresight: etm-perf: Allow an event to use different sinks
>        coresight: Do not scan for graph if none is present
>        coresight: etm4x: Add support for PE OS lock
>        coresight: ete: Add support for ETE sysreg access
>        coresight: ete: Add support for ETE tracing
>        dts: bindings: Document device tree bindings for ETE
>        coresight: etm-perf: Handle stale output handles
>        dts: bindings: Document device tree bindings for Arm TRBE
> 
> Thomas Gleixner (1):
>        time: Add mechanism to recognize clocksource in time_get_snapshot
> 
> Tom Lendacky (1):
>        KVM: SVM: Make sure GHCB is mapped before updating
> 
> Uros Bizjak (1):
>        KVM/SVM: Move vmenter.S exception fixups out of line
> 
> Vitaly Kuznetsov (3):
>        KVM: x86/vPMU: Forbid reading from MSR_F15H_PERF MSRs when guest doesn't have X86_FEATURE_PERFCTR_CORE
>        KVM: x86: Properly handle APF vs disabled LAPIC situation
>        KVM: selftests: Speed up set_memory_region_test
> 
> Wang Wensheng (1):
>        KVM: arm64: Fix error return code in init_hyp_mode()
> 
> Wanpeng Li (5):
>        x86/kvm: Don't bother __pv_cpu_mask when !CONFIG_SMP
>        KVM: X86: Count attempted/successful directed yield
>        KVM: X86: Do not yield to self
>        KVM: Boost vCPU candidate in user mode which is delivering interrupt
>        KVM: X86: Fix failure to boost kernel lock holder candidate in SEV-ES guests
> 
> Wei Yongjun (2):
>        coresight: core: Make symbol 'csdev_sink' static
>        coresight: trbe: Fix return value check in arm_trbe_register_coresight_cpu()
> 
> Will Deacon (5):
>        arm64: lib: Annotate {clear, copy}_page() as position-independent
>        KVM: arm64: Link position-independent string routines into .hyp.text
>        arm64: kvm: Add standalone ticket spinlock implementation for use at hyp
>        arm/arm64: Probe for the presence of KVM hypervisor
>        KVM: arm64: Advertise KVM UID to guests via SMCCC
> 
> Xiaofei Tan (1):
>        arm64: sve: Provide sve_cond_update_zcr_vq fallback when !ARM64_SVE
> 
> Xu Jia (1):
>        KVM: arm64: Make symbol '_kvm_host_prot_finalize' static
> 
> Yanan Wang (8):
>        tools/headers: sync headers of asm-generic/hugetlb_encode.h
>        KVM: selftests: Print the errno besides error-string in TEST_ASSERT
>        KVM: selftests: Make a generic helper to get vm guest mode strings
>        KVM: selftests: Add a helper to get system configured THP page size
>        KVM: selftests: Add a helper to get system default hugetlb page size
>        KVM: selftests: List all hugetlb src types specified with page sizes
>        KVM: selftests: Adapt vm_userspace_mem_region_add to new helpers
>        KVM: selftests: Add a test for kvm page table code
> 
> Yang Yingliang (1):
>        KVM: selftests: remove redundant semi-colon
> 
> Zenghui Yu (2):
>        KVM: arm64: GICv4.1: Restore VLPI pending state to physical side
>        KVM: arm64: Fix Function ID typo for PTP_KVM service
> 
> Zhenzhong Duan (1):
>        selftests: kvm: Fix the check of return value
> 
>   .../ABI/testing/sysfs-bus-coresight-devices-trbe   |   14 +
>   Documentation/devicetree/bindings/arm/ete.yaml     |   75 ++
>   Documentation/devicetree/bindings/arm/trbe.yaml    |   49 +
>   Documentation/trace/coresight/coresight-trbe.rst   |   38 +
>   Documentation/virt/kvm/amd-memory-encryption.rst   |  143 +++
>   Documentation/virt/kvm/api.rst                     |  214 +++-
>   Documentation/virt/kvm/arm/index.rst               |    1 +
>   Documentation/virt/kvm/arm/ptp_kvm.rst             |   25 +
>   Documentation/virt/kvm/devices/arm-vgic-its.rst    |    2 +-
>   Documentation/virt/kvm/devices/arm-vgic-v3.rst     |    2 +-
>   Documentation/virt/kvm/locking.rst                 |   49 +-
>   Documentation/virt/kvm/s390-diag.rst               |   33 +
>   MAINTAINERS                                        |    6 +-
>   arch/arm/include/asm/hypervisor.h                  |    3 +
>   arch/arm64/include/asm/assembler.h                 |   27 +-
>   arch/arm64/include/asm/barrier.h                   |    1 +
>   arch/arm64/include/asm/el2_setup.h                 |   13 +
>   arch/arm64/include/asm/fpsimd.h                    |   11 +
>   arch/arm64/include/asm/fpsimdmacros.h              |   10 +-
>   arch/arm64/include/asm/hyp_image.h                 |    7 +
>   arch/arm64/include/asm/hypervisor.h                |    3 +
>   arch/arm64/include/asm/kvm_arm.h                   |    2 +
>   arch/arm64/include/asm/kvm_asm.h                   |    9 +
>   arch/arm64/include/asm/kvm_host.h                  |   55 +-
>   arch/arm64/include/asm/kvm_hyp.h                   |   14 +-
>   arch/arm64/include/asm/kvm_mmu.h                   |   25 +-
>   arch/arm64/include/asm/kvm_pgtable.h               |  164 ++-
>   arch/arm64/include/asm/pgtable-prot.h              |    4 +-
>   arch/arm64/include/asm/sections.h                  |    1 +
>   arch/arm64/include/asm/sysreg.h                    |   59 +-
>   arch/arm64/kernel/asm-offsets.c                    |    3 +
>   arch/arm64/kernel/cpu-reset.S                      |    5 +-
>   arch/arm64/kernel/hyp-stub.S                       |    3 +-
>   arch/arm64/kernel/image-vars.h                     |   34 +-
>   arch/arm64/kernel/vmlinux.lds.S                    |   74 +-
>   arch/arm64/kvm/arm.c                               |  220 +++-
>   arch/arm64/kvm/debug.c                             |  118 +-
>   arch/arm64/kvm/fpsimd.c                            |   26 +-
>   arch/arm64/kvm/guest.c                             |   11 +-
>   arch/arm64/kvm/handle_exit.c                       |   45 +
>   arch/arm64/kvm/hyp/Makefile                        |    2 +-
>   arch/arm64/kvm/hyp/fpsimd.S                        |   10 +
>   arch/arm64/kvm/hyp/include/hyp/switch.h            |  107 +-
>   arch/arm64/kvm/hyp/include/nvhe/early_alloc.h      |   14 +
>   arch/arm64/kvm/hyp/include/nvhe/gfp.h              |   68 ++
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |   36 +
>   arch/arm64/kvm/hyp/include/nvhe/memory.h           |   51 +
>   arch/arm64/kvm/hyp/include/nvhe/mm.h               |   96 ++
>   arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |   92 ++
>   arch/arm64/kvm/hyp/nvhe/Makefile                   |    9 +-
>   arch/arm64/kvm/hyp/nvhe/cache.S                    |   13 +
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   56 +-
>   arch/arm64/kvm/hyp/nvhe/early_alloc.c              |   54 +
>   arch/arm64/kvm/hyp/nvhe/gen-hyprel.c               |   18 +
>   arch/arm64/kvm/hyp/nvhe/host.S                     |   18 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-init.S                 |   54 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |   75 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-smp.c                  |    6 +-
>   arch/arm64/kvm/hyp/nvhe/hyp.lds.S                  |    1 +
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c              |  279 +++++
>   arch/arm64/kvm/hyp/nvhe/mm.c                       |  173 +++
>   arch/arm64/kvm/hyp/nvhe/page_alloc.c               |  195 ++++
>   arch/arm64/kvm/hyp/nvhe/psci-relay.c               |    4 +-
>   arch/arm64/kvm/hyp/nvhe/setup.c                    |  214 ++++
>   arch/arm64/kvm/hyp/nvhe/stub.c                     |   22 +
>   arch/arm64/kvm/hyp/nvhe/switch.c                   |   26 +-
>   arch/arm64/kvm/hyp/nvhe/tlb.c                      |    4 +-
>   arch/arm64/kvm/hyp/pgtable.c                       |  410 +++++--
>   arch/arm64/kvm/hyp/reserved_mem.c                  |  113 ++
>   arch/arm64/kvm/hyp/vhe/switch.c                    |    4 +-
>   arch/arm64/kvm/hypercalls.c                        |   80 +-
>   arch/arm64/kvm/mmu.c                               |  254 +++--
>   arch/arm64/kvm/perf.c                              |    7 +-
>   arch/arm64/kvm/pmu-emul.c                          |    2 +-
>   arch/arm64/kvm/pmu.c                               |    8 +-
>   arch/arm64/kvm/reset.c                             |   51 +-
>   arch/arm64/kvm/sys_regs.c                          |   16 +
>   arch/arm64/kvm/trace_arm.h                         |   66 --
>   arch/arm64/kvm/va_layout.c                         |    7 +
>   arch/arm64/kvm/vgic/vgic-init.c                    |   12 +-
>   arch/arm64/kvm/vgic/vgic-its.c                     |    6 +-
>   arch/arm64/kvm/vgic/vgic-kvm-device.c              |    7 +-
>   arch/arm64/kvm/vgic/vgic-mmio-v3.c                 |   81 +-
>   arch/arm64/kvm/vgic/vgic-mmio.c                    |   10 +-
>   arch/arm64/kvm/vgic/vgic-v3.c                      |   66 +-
>   arch/arm64/kvm/vgic/vgic-v4.c                      |   38 +
>   arch/arm64/kvm/vgic/vgic.h                         |    2 +
>   arch/arm64/lib/clear_page.S                        |    4 +-
>   arch/arm64/lib/copy_page.S                         |    4 +-
>   arch/arm64/mm/init.c                               |    3 +
>   arch/mips/include/asm/kvm_host.h                   |   17 +-
>   arch/mips/kvm/mips.c                               |   21 +-
>   arch/mips/kvm/mmu.c                                |  100 +-
>   arch/mips/kvm/trap_emul.c                          |   13 +-
>   arch/mips/kvm/vz.c                                 |   19 +-
>   arch/powerpc/include/asm/kvm_book3s.h              |   12 +-
>   arch/powerpc/include/asm/kvm_host.h                |    7 -
>   arch/powerpc/include/asm/kvm_ppc.h                 |    9 +-
>   arch/powerpc/kvm/book3s.c                          |   18 +-
>   arch/powerpc/kvm/book3s.h                          |   10 +-
>   arch/powerpc/kvm/book3s_64_mmu_hv.c                |   98 +-
>   arch/powerpc/kvm/book3s_64_mmu_radix.c             |   25 +-
>   arch/powerpc/kvm/book3s_hv.c                       |   12 +-
>   arch/powerpc/kvm/book3s_pr.c                       |   56 +-
>   arch/powerpc/kvm/e500_mmu_host.c                   |   29 +-
>   arch/powerpc/kvm/trace_booke.h                     |   15 -
>   arch/s390/include/asm/kvm_host.h                   |    5 +
>   arch/s390/include/asm/smp.h                        |    1 +
>   arch/s390/kernel/smp.c                             |    1 +
>   arch/s390/kvm/diag.c                               |   31 +-
>   arch/s390/kvm/gaccess.c                            |   30 +-
>   arch/s390/kvm/gaccess.h                            |   60 +-
>   arch/s390/kvm/kvm-s390.c                           |   15 +-
>   arch/s390/kvm/kvm-s390.h                           |    8 +
>   arch/s390/kvm/vsie.c                               |  109 +-
>   arch/sh/kernel/perf_event.c                        |   18 -
>   arch/x86/include/asm/cpufeatures.h                 |    1 +
>   arch/x86/include/asm/kvm_host.h                    |   67 +-
>   arch/x86/include/asm/mem_encrypt.h                 |    1 -
>   arch/x86/include/asm/svm.h                         |    4 +-
>   arch/x86/include/asm/vmx.h                         |    1 +
>   arch/x86/include/uapi/asm/vmx.h                    |    1 +
>   arch/x86/kernel/kvm.c                              |  118 +-
>   arch/x86/kvm/Makefile                              |    2 +
>   arch/x86/kvm/cpuid.c                               |   98 +-
>   arch/x86/kvm/cpuid.h                               |  155 +--
>   arch/x86/kvm/emulate.c                             |   80 +-
>   arch/x86/kvm/kvm_cache_regs.h                      |   19 +-
>   arch/x86/kvm/lapic.c                               |    8 +-
>   arch/x86/kvm/mmu.h                                 |   23 +-
>   arch/x86/kvm/mmu/mmu.c                             |  637 ++++++-----
>   arch/x86/kvm/mmu/mmu_audit.c                       |    2 +-
>   arch/x86/kvm/mmu/mmu_internal.h                    |   44 +-
>   arch/x86/kvm/mmu/paging_tmpl.h                     |    3 +-
>   arch/x86/kvm/mmu/spte.c                            |  159 ++-
>   arch/x86/kvm/mmu/spte.h                            |  141 ++-
>   arch/x86/kvm/mmu/tdp_mmu.c                         |  740 +++++++------
>   arch/x86/kvm/mmu/tdp_mmu.h                         |   51 +-
>   arch/x86/kvm/reverse_cpuid.h                       |  186 ++++
>   arch/x86/kvm/svm/avic.c                            |   24 +-
>   arch/x86/kvm/svm/nested.c                          |  573 ++++++----
>   arch/x86/kvm/svm/sev.c                             |  922 ++++++++++++----
>   arch/x86/kvm/svm/svm.c                             | 1107 +++++++++----------
>   arch/x86/kvm/svm/svm.h                             |   91 +-
>   arch/x86/kvm/svm/vmenter.S                         |   47 +-
>   arch/x86/kvm/vmx/nested.c                          |   83 +-
>   arch/x86/kvm/vmx/nested.h                          |    5 +
>   arch/x86/kvm/vmx/sgx.c                             |  502 +++++++++
>   arch/x86/kvm/vmx/sgx.h                             |   34 +
>   arch/x86/kvm/vmx/vmcs12.c                          |    1 +
>   arch/x86/kvm/vmx/vmcs12.h                          |    4 +-
>   arch/x86/kvm/vmx/vmx.c                             |  432 ++++----
>   arch/x86/kvm/vmx/vmx.h                             |   39 +-
>   arch/x86/kvm/vmx/vmx_ops.h                         |    4 +
>   arch/x86/kvm/x86.c                                 |  214 +++-
>   arch/x86/kvm/x86.h                                 |   18 +-
>   arch/x86/mm/mem_encrypt.c                          |   10 +-
>   arch/x86/mm/mem_encrypt_identity.c                 |    1 -
>   drivers/clocksource/arm_arch_timer.c               |   36 +
>   drivers/crypto/ccp/sev-dev.c                       |  193 ++--
>   drivers/crypto/ccp/sev-dev.h                       |    4 +-
>   drivers/firmware/psci/psci.c                       |    2 +
>   drivers/firmware/smccc/Makefile                    |    2 +-
>   drivers/firmware/smccc/kvm_guest.c                 |   50 +
>   drivers/firmware/smccc/smccc.c                     |    1 +
>   drivers/hwtracing/coresight/Kconfig                |   24 +-
>   drivers/hwtracing/coresight/Makefile               |    1 +
>   drivers/hwtracing/coresight/coresight-core.c       |   29 +-
>   drivers/hwtracing/coresight/coresight-etm-perf.c   |  119 +-
>   drivers/hwtracing/coresight/coresight-etm4x-core.c |  161 ++-
>   .../hwtracing/coresight/coresight-etm4x-sysfs.c    |   19 +-
>   drivers/hwtracing/coresight/coresight-etm4x.h      |   83 +-
>   drivers/hwtracing/coresight/coresight-platform.c   |    6 +
>   drivers/hwtracing/coresight/coresight-priv.h       |    3 +
>   drivers/hwtracing/coresight/coresight-trbe.c       | 1157 ++++++++++++++++++++
>   drivers/hwtracing/coresight/coresight-trbe.h       |  152 +++
>   drivers/irqchip/irq-gic-v3-its.c                   |   18 +-
>   drivers/perf/arm_pmu.c                             |   30 -
>   drivers/ptp/Kconfig                                |    2 +-
>   drivers/ptp/Makefile                               |    2 +
>   drivers/ptp/ptp_kvm_arm.c                          |   28 +
>   drivers/ptp/{ptp_kvm.c => ptp_kvm_common.c}        |   85 +-
>   drivers/ptp/ptp_kvm_x86.c                          |   97 ++
>   include/kvm/arm_pmu.h                              |    4 +
>   include/kvm/arm_vgic.h                             |    1 +
>   include/linux/arm-smccc.h                          |   41 +
>   include/linux/bug.h                                |   10 +
>   include/linux/clocksource.h                        |    6 +
>   include/linux/clocksource_ids.h                    |   12 +
>   include/linux/coresight.h                          |   13 +
>   include/linux/kvm_host.h                           |   24 +-
>   include/linux/perf_event.h                         |    2 -
>   include/linux/psp-sev.h                            |   18 +-
>   include/linux/ptp_kvm.h                            |   19 +
>   include/linux/timekeeping.h                        |   12 +-
>   include/trace/events/kvm.h                         |   90 +-
>   include/uapi/linux/kvm.h                           |   45 +
>   include/uapi/linux/perf_event.h                    |   13 +-
>   kernel/events/core.c                               |    5 -
>   kernel/time/clocksource.c                          |    2 +
>   kernel/time/timekeeping.c                          |    1 +
>   lib/bug.c                                          |   54 +-
>   tools/include/asm-generic/hugetlb_encode.h         |    3 +
>   tools/testing/selftests/kvm/.gitignore             |    2 +
>   tools/testing/selftests/kvm/Makefile               |    4 +
>   tools/testing/selftests/kvm/aarch64/vgic_init.c    |  551 ++++++++++
>   tools/testing/selftests/kvm/dirty_log_test.c       |   69 +-
>   tools/testing/selftests/kvm/include/kvm_util.h     |   13 +-
>   tools/testing/selftests/kvm/include/test_util.h    |   21 +-
>   tools/testing/selftests/kvm/kvm_page_table_test.c  |  506 +++++++++
>   tools/testing/selftests/kvm/lib/assert.c           |    4 +-
>   tools/testing/selftests/kvm/lib/kvm_util.c         |  138 ++-
>   tools/testing/selftests/kvm/lib/test_util.c        |  163 ++-
>   .../testing/selftests/kvm/set_memory_region_test.c |   61 +-
>   .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |    2 +-
>   virt/kvm/coalesced_mmio.c                          |   19 +-
>   virt/kvm/kvm_main.c                                |  303 +++--
>   217 files changed, 12444 insertions(+), 4028 deletions(-)
> 
> 
> diff --combined arch/x86/kernel/kvm.c
> index 5d32fa477a62,bd01a6131edf..000000000000
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@@ -574,6 -574,49 +574,54 @@@ static void kvm_smp_send_call_func_ipi(
>    	}
>    }
>    
>   -static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> ++static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
> + 			const struct flush_tlb_info *info)
> + {
> + 	u8 state;
> + 	int cpu;
> + 	struct kvm_steal_time *src;
> + 	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> +
> + 	cpumask_copy(flushmask, cpumask);
> + 	/*
> + 	 * We have to call flush only on online vCPUs. And
> + 	 * queue flush_on_enter for pre-empted vCPUs
> + 	 */
> + 	for_each_cpu(cpu, flushmask) {
> ++		/*
> ++		 * The local vCPU is never preempted, so we do not explicitly
> ++		 * skip check for local vCPU - it will never be cleared from
> ++		 * flushmask.
> ++		 */
> + 		src = &per_cpu(steal_time, cpu);
> + 		state = READ_ONCE(src->preempted);
> + 		if ((state & KVM_VCPU_PREEMPTED)) {
> + 			if (try_cmpxchg(&src->preempted, &state,
> + 					state | KVM_VCPU_FLUSH_TLB))
> + 				__cpumask_clear_cpu(cpu, flushmask);
> + 		}
> + 	}
> +
>   -	native_flush_tlb_others(flushmask, info);
> ++	native_flush_tlb_multi(flushmask, info);
> + }
> +
> + static __init int kvm_alloc_cpumask(void)
> + {
> + 	int cpu;
> +
> + 	if (!kvm_para_available() || nopv)
> + 		return 0;
> +
> + 	if (pv_tlb_flush_supported() || pv_ipi_supported())
> + 		for_each_possible_cpu(cpu) {
> + 			zalloc_cpumask_var_node(per_cpu_ptr(&__pv_cpu_mask, cpu),
> + 				GFP_KERNEL, cpu_to_node(cpu));
> + 		}
> +
> + 	return 0;
> + }
> + arch_initcall(kvm_alloc_cpumask);
> +
>    static void __init kvm_smp_prepare_boot_cpu(void)
>    {
>    	/*
> @@@ -611,38 -654,8 +659,8 @@@ static int kvm_cpu_down_prepare(unsigne
>    	local_irq_enable();
>    	return 0;
>    }
> - #endif
> -
> - static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
> - 			const struct flush_tlb_info *info)
> - {
> - 	u8 state;
> - 	int cpu;
> - 	struct kvm_steal_time *src;
> - 	struct cpumask *flushmask = this_cpu_cpumask_var_ptr(__pv_cpu_mask);
> -
> - 	cpumask_copy(flushmask, cpumask);
> - 	/*
> - 	 * We have to call flush only on online vCPUs. And
> - 	 * queue flush_on_enter for pre-empted vCPUs
> - 	 */
> - 	for_each_cpu(cpu, flushmask) {
> - 		/*
> - 		 * The local vCPU is never preempted, so we do not explicitly
> - 		 * skip check for local vCPU - it will never be cleared from
> - 		 * flushmask.
> - 		 */
> - 		src = &per_cpu(steal_time, cpu);
> - 		state = READ_ONCE(src->preempted);
> - 		if ((state & KVM_VCPU_PREEMPTED)) {
> - 			if (try_cmpxchg(&src->preempted, &state,
> - 					state | KVM_VCPU_FLUSH_TLB))
> - 				__cpumask_clear_cpu(cpu, flushmask);
> - 		}
> - 	}
>    
> - 	native_flush_tlb_multi(flushmask, info);
> - }
> + #endif
>    
>    static void __init kvm_guest_init(void)
>    {
> @@@ -655,15 -668,9 +673,9 @@@
>    
>    	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
>    		has_steal_clock = 1;
>   -		pv_ops.time.steal_clock = kvm_steal_clock;
>   +		static_call_update(pv_steal_clock, kvm_steal_clock);
>    	}
>    
> - 	if (pv_tlb_flush_supported()) {
> - 		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
> - 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> - 		pr_info("KVM setup pv remote TLB flush\n");
> - 	}
> -
>    	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
>    		apic_set_eoi_write(kvm_guest_apic_eoi_write);
>    
> @@@ -673,6 -680,12 +685,12 @@@
>    	}
>    
>    #ifdef CONFIG_SMP
> + 	if (pv_tlb_flush_supported()) {
>   -		pv_ops.mmu.flush_tlb_others = kvm_flush_tlb_others;
> ++		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
> + 		pv_ops.mmu.tlb_remove_table = tlb_remove_table;
> + 		pr_info("KVM setup pv remote TLB flush\n");
> + 	}
> +
>    	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
>    	if (pv_sched_yield_supported()) {
>    		smp_ops.send_call_func_ipi = kvm_smp_send_call_func_ipi;
> 

