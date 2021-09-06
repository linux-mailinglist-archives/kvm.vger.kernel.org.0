Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC79401764
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 09:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhIFH7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 03:59:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240593AbhIFH7X (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 03:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630915098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dKd4pIVfvQ/yDhxOPiYfDeg3VN3rar4vhMOSEQWj644=;
        b=IwjCIKAxJLCKeqcJkelfj+HtKpNKkMXHOpeHvI5AbD3ALe/buio3iKasn/AYDrl/EAQrX9
        /s1HkNUpRCEMCIasfcDlLg5BsBrU3aZ55Z+iCa0iuccC2Zb8vbfcngL2HeF2A6m021KSHq
        FKQyZog2R/cE96dPmN4K/o1SmP9bk40=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-dct6fqHdO2q1u4d1nAgvwA-1; Mon, 06 Sep 2021 03:58:17 -0400
X-MC-Unique: dct6fqHdO2q1u4d1nAgvwA-1
Received: by mail-wr1-f72.google.com with SMTP id n1-20020a5d4c41000000b00159305d19baso950283wrt.11
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 00:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKd4pIVfvQ/yDhxOPiYfDeg3VN3rar4vhMOSEQWj644=;
        b=E+TQ85vRGJzDkUKLbDnRjyKDj8tCRvoODp8DrWQQZxE1cmiS37No4MydnGF1Ydpp4u
         5Ww/aZYthSRltoJvbLg/eMvfeWHGRNiJUOrgXu0UWj24QatrIhiH2CJJy9flg8C6xBUz
         ustlwd0psspG51tJklwYTYqv4Ae9Et6aGTpQILjz9r7sJSmc0S0Ym1mGm7FoO8VNnvAb
         EhSLrPsPHv1ejQBJ7ONrwvaJA31FpHRa50po8lDwLc8kFlt10ssN4gEdkmnPvx2ZhmJU
         SkALZesEFYNMzHsYfUMa623NypkDLDl5xooE384sztGO5dYuJEm4vUkG5LIzmeFEFpTx
         OARA==
X-Gm-Message-State: AOAM530Z6x8LZ/xLGNcvlbAqqVitmLCW4slIozxLY4/cOUOfnYAK7Pit
        YQFMFLWbw9vz25rx5iEJl3ZaxQTtriaCBe+cL/fkO8GnsNcUAMpdKH9940+Epdby5mWEHn8NPdQ
        Uzg5/YnePRlF1
X-Received: by 2002:adf:9bdb:: with SMTP id e27mr11579753wrc.162.1630915096260;
        Mon, 06 Sep 2021 00:58:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/egBUcDEuiinyhLtm7XjHKsu24/9JHUDgrRlLV0auOtgsv4vHp/w2PVZvB+GpqHL+OgrsOg==
X-Received: by 2002:adf:9bdb:: with SMTP id e27mr11579732wrc.162.1630915095990;
        Mon, 06 Sep 2021 00:58:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g1sm8818494wrb.27.2021.09.06.00.58.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 00:58:15 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.15
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Scull <ascull@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        Jason Wang <wangborong@cdjrlc.com>,
        Jing Zhang <jingzhangos@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oupton@google.com>,
        Quentin Perret <qperret@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
References: <20210826115649.2641468-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bde646fe-00ef-3518-23e9-2101282f3648@redhat.com>
Date:   Mon, 6 Sep 2021 09:58:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210826115649.2641468-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/21 13:56, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the KVM/arm64 pull request for 5.15. This round is all over the
> map, with plenty of updates around the MM subsystem (page tables, page
> ownership, small fixes), PMU (reset state, perf improvements), PSCI,
> the move to the generic entry code, and a lot of cleanups all over the
> shop, probably owing to having a few more eyes looking at the code.
> 
> A few things to note:
> 
> - the kvmarm-fixes-5.14-2 tag was brought in to allow the merge of
>    some patches
> 
> - the arm64/for-next/sysreg was merged to resolve couple of conflicts
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit c500bee1c5b2f1d59b1081ac879d73268ab0ff17:
> 
>    Linux 5.14-rc4 (2021-08-01 17:04:17 -0700)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.15
> 
> for you to fetch changes up to 419025b3b4190ee867ef4fc48fb3bd7da2e67a0c:
> 
>    Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next (2021-08-26 11:36:12 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 updates for 5.15
> 
> - Page ownership tracking between host EL1 and EL2
> 
> - Rely on userspace page tables to create large stage-2 mappings
> 
> - Fix incompatibility between pKVM and kmemleak
> 
> - Fix the PMU reset state, and improve the performance of the virtual PMU
> 
> - Move over to the generic KVM entry code
> 
> - Address PSCI reset issues w.r.t. save/restore
> 
> - Preliminary rework for the upcoming pKVM fixed feature
> 
> - A bunch of MM cleanups
> 
> - a vGIC fix for timer spurious interrupts
> 
> - Various cleanups
> 
> ----------------------------------------------------------------
> Alexandre Chartre (1):
>        KVM: arm64: Disabling disabled PMU counters wastes a lot of time
> 
> Anshuman Khandual (9):
>        arm64/kexec: Test page size support with new TGRAN range values
>        KVM: arm64: perf: Replace '0xf' instances with ID_AA64DFR0_PMUVER_IMP_DEF
>        arm64/mm: Define ID_AA64MMFR0_TGRAN_2_SHIFT
>        KVM: arm64: Restrict IPA size to maximum 48 bits on 4K and 16K page size
>        arm64/mm: Add remaining ID_AA64MMFR0_PARANGE_ macros
>        KVM: arm64: Use ARM64_MIN_PARANGE_BITS as the minimum supported IPA
>        KVM: arm64: Drop init_common_resources()
>        KVM: arm64: Drop check_kvm_target_cpu() based percpu probe
>        KVM: arm64: Drop unused REQUIRES_VIRT
> 
> David Brazdil (2):
>        KVM: arm64: Fix off-by-one in range_is_memory
>        KVM: arm64: Minor optimization of range_is_memory
> 
> Fuad Tabba (10):
>        KVM: arm64: placeholder to check if VM is protected
>        KVM: arm64: Remove trailing whitespace in comment
>        KVM: arm64: MDCR_EL2 is a 64-bit register
>        KVM: arm64: Fix names of config register fields
>        KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
>        KVM: arm64: Restore mdcr_el2 from vcpu
>        KVM: arm64: Keep mdcr_el2's value as set by __init_el2_debug
>        KVM: arm64: Track value of cptr_el2 in struct kvm_vcpu_arch
>        KVM: arm64: Add feature register flag definitions
>        KVM: arm64: Add config register bit definitions
> 
> Jason Wang (1):
>        KVM: arm64: Fix comments related to GICv2 PMR reporting
> 
> Marc Zyngier (28):
>        KVM: arm64: Walk userspace page tables to compute the THP mapping size
>        KVM: arm64: Avoid mapping size adjustment on permission fault
>        KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
>        KVM: arm64: Use get_page() instead of kvm_get_pfn()
>        KVM: arm64: Introduce helper to retrieve a PTE and its level
>        KVM: Get rid of kvm_get_pfn()
>        KVM: arm64: Narrow PMU sysreg reset values to architectural requirements
>        KVM: arm64: Drop unnecessary masking of PMU registers
>        KVM: arm64: Remove PMSWINC_EL0 shadow register
>        arm64: Move .hyp.rodata outside of the _sdata.._edata range
>        KVM: arm64: Unregister HYP sections from kmemleak in protected mode
>        KVM: arm64: vgic: Resample HW pending state on deactivation
>        KVM: arm64: Move kern_hyp_va() usage in __load_guest_stage2() into the callers
>        KVM: arm64: Unify stage-2 programming behind __load_stage2()
>        KVM: arm64: Upgrade VMID accesses to {READ,WRITE}_ONCE
>        KVM: arm64: Upgrade trace_kvm_arm_set_dreg32() to 64bit
>        Merge branch arm64/for-next/sysreg into kvm-arm64/misc-5.15
>        Merge tag 'kvmarm-fixes-5.14-2' into kvm-arm64/mmu/el2-tracking
>        Merge branch kvm-arm64/pmu/reset-values into kvmarm-master/next
>        Merge branch kvm-arm64/mmu/mapping-levels into kvmarm-master/next
>        Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next
>        Merge branch kvm-arm64/mmu/kmemleak-pkvm into kvmarm-master/next
>        Merge branch kvm-arm64/mmu/el2-tracking into kvmarm-master/next
>        Merge branch kvm-arm64/psci/cpu_on into kvmarm-master/next
>        Merge branch kvm-arm64/generic-entry into kvmarm-master/next
>        Merge branch kvm-arm64/mmu/vmid-cleanups into kvmarm-master/next
>        Merge branch kvm-arm64/pkvm-fixed-features-prologue into kvmarm-master/next
>        Merge branch kvm-arm64/misc-5.15 into kvmarm-master/next
> 
> Oliver Upton (7):
>        KVM: arm64: Fix read-side race on updates to vcpu reset state
>        KVM: arm64: Handle PSCI resets before userspace touches vCPU state
>        KVM: arm64: Enforce reserved bits for PSCI target affinities
>        selftests: KVM: Introduce psci_cpu_on_test
>        KVM: arm64: Record number of signal exits as a vCPU stat
>        entry: KVM: Allow use of generic KVM entry w/o full generic support
>        KVM: arm64: Use generic KVM xfer to guest work function
> 
> Paolo Bonzini (1):
>        KVM: arm64: Count VMID-wide TLB invalidations
> 
> Quentin Perret (20):
>        KVM: arm64: Introduce hyp_assert_lock_held()
>        KVM: arm64: Provide the host_stage2_try() helper macro
>        KVM: arm64: Expose page-table helpers
>        KVM: arm64: Optimize host memory aborts
>        KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
>        KVM: arm64: Don't overwrite software bits with owner id
>        KVM: arm64: Tolerate re-creating hyp mappings to set software bits
>        KVM: arm64: Enable forcing page-level stage-2 mappings
>        KVM: arm64: Allow populating software bits
>        KVM: arm64: Add helpers to tag shared pages in SW bits
>        KVM: arm64: Expose host stage-2 manipulation helpers
>        KVM: arm64: Expose pkvm_hyp_id
>        KVM: arm64: Introduce addr_is_memory()
>        KVM: arm64: Enable retrieving protections attributes of PTEs
>        KVM: arm64: Mark host bss and rodata section as shared
>        KVM: arm64: Remove __pkvm_mark_hyp
>        KVM: arm64: Refactor protected nVHE stage-1 locking
>        KVM: arm64: Restrict EL2 stage-1 changes in protected mode
>        KVM: arm64: Make __pkvm_create_mappings static
>        KVM: arm64: Return -EPERM from __pkvm_host_share_hyp()
> 
> Raghavendra Rao Ananta (1):
>        KVM: arm64: Trim guest debug exception handling
> 
> Ricardo Koller (1):
>        KVM: arm64: vgic: Drop WARN from vgic_get_irq
> 
> Steven Price (1):
>        KVM: arm64: Fix race when enabling KVM_ARM_CAP_MTE
> 
> Will Deacon (2):
>        KVM: arm64: Add hyp_spin_is_locked() for basic locking assertions at EL2
>        KVM: arm64: Make hyp_panic() more robust when protected mode is enabled
> 
>   arch/arm64/include/asm/cpufeature.h                |  27 ++-
>   arch/arm64/include/asm/kvm_arm.h                   |  54 +++--
>   arch/arm64/include/asm/kvm_asm.h                   |   7 +-
>   arch/arm64/include/asm/kvm_host.h                  |  17 +-
>   arch/arm64/include/asm/kvm_hyp.h                   |   2 +-
>   arch/arm64/include/asm/kvm_mmu.h                   |  17 +-
>   arch/arm64/include/asm/kvm_pgtable.h               | 168 ++++++++++----
>   arch/arm64/include/asm/sysreg.h                    |  54 +++--
>   arch/arm64/kernel/cpufeature.c                     |   8 +-
>   arch/arm64/kernel/vmlinux.lds.S                    |   4 +-
>   arch/arm64/kvm/Kconfig                             |  10 +
>   arch/arm64/kvm/arm.c                               | 173 ++++++---------
>   arch/arm64/kvm/debug.c                             |   2 +-
>   arch/arm64/kvm/guest.c                             |   5 +-
>   arch/arm64/kvm/handle_exit.c                       |  43 ++--
>   arch/arm64/kvm/hyp/include/hyp/switch.h            |   6 +-
>   arch/arm64/kvm/hyp/include/nvhe/mem_protect.h      |  35 ++-
>   arch/arm64/kvm/hyp/include/nvhe/mm.h               |   3 +-
>   arch/arm64/kvm/hyp/include/nvhe/spinlock.h         |  25 +++
>   arch/arm64/kvm/hyp/nvhe/debug-sr.c                 |   2 +-
>   arch/arm64/kvm/hyp/nvhe/host.S                     |  21 +-
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c                 |  20 +-
>   arch/arm64/kvm/hyp/nvhe/mem_protect.c              | 244 ++++++++++++++++----
>   arch/arm64/kvm/hyp/nvhe/mm.c                       |  22 +-
>   arch/arm64/kvm/hyp/nvhe/setup.c                    |  82 ++++++-
>   arch/arm64/kvm/hyp/nvhe/switch.c                   |  17 +-
>   arch/arm64/kvm/hyp/nvhe/tlb.c                      |   4 +-
>   arch/arm64/kvm/hyp/pgtable.c                       | 247 +++++++++++----------
>   arch/arm64/kvm/hyp/vhe/debug-sr.c                  |   2 +-
>   arch/arm64/kvm/hyp/vhe/switch.c                    |  18 +-
>   arch/arm64/kvm/hyp/vhe/sysreg-sr.c                 |   2 +-
>   arch/arm64/kvm/hyp/vhe/tlb.c                       |   4 +-
>   arch/arm64/kvm/mmu.c                               |  76 ++++++-
>   arch/arm64/kvm/perf.c                              |   2 +-
>   arch/arm64/kvm/pmu-emul.c                          |  14 +-
>   arch/arm64/kvm/psci.c                              |  15 +-
>   arch/arm64/kvm/reset.c                             |  43 ++--
>   arch/arm64/kvm/sys_regs.c                          | 134 ++++++-----
>   arch/arm64/kvm/sys_regs.h                          |  31 +++
>   arch/arm64/kvm/trace_handle_exit.h                 |  10 +-
>   arch/arm64/kvm/vgic/vgic-mmio-v2.c                 |   4 +-
>   arch/arm64/kvm/vgic/vgic-v2.c                      |  36 +--
>   arch/arm64/kvm/vgic/vgic-v3.c                      |  36 +--
>   arch/arm64/kvm/vgic/vgic.c                         |  39 +++-
>   arch/arm64/kvm/vgic/vgic.h                         |   2 +
>   include/linux/entry-kvm.h                          |   6 +-
>   include/linux/kvm_host.h                           |   1 -
>   include/linux/page-flags.h                         |  37 ---
>   tools/testing/selftests/kvm/.gitignore             |   1 +
>   tools/testing/selftests/kvm/Makefile               |   1 +
>   .../selftests/kvm/aarch64/psci_cpu_on_test.c       | 121 ++++++++++
>   .../selftests/kvm/include/aarch64/processor.h      |   3 +
>   virt/kvm/kvm_main.c                                |  19 +-
>   53 files changed, 1279 insertions(+), 697 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/aarch64/psci_cpu_on_test.c
> 

I'm back and will get to this today or tomorrow.

Paolo

