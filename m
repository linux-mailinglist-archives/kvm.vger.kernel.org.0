Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73EC4A6322
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 19:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbiBASDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 13:03:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48590 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241735AbiBASDT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Feb 2022 13:03:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643738598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mGtihHwIOnEQr+4oy1pQ3OQAqDY4kFl3QNaUR34YrO0=;
        b=Xqr76V4BEPSJXKdIqe0+y7SMpnbhoiHtpMLbqAwjTJErukCQ0+uFimQObs9LVjM4LspOIw
        ZWQJPc1oJDeRBgIltUYZCDqR5oOiC34CzLRMMobLxam8L9D59Dk/626rmwTn1AfKcRF1iE
        8fQaGUqWbRKF5D1l6CQkqnSWQIJlvsU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-SLRHoPyUPSCbrmTi_z5yuA-1; Tue, 01 Feb 2022 13:03:15 -0500
X-MC-Unique: SLRHoPyUPSCbrmTi_z5yuA-1
Received: by mail-ed1-f71.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso9067178edt.20
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 10:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=mGtihHwIOnEQr+4oy1pQ3OQAqDY4kFl3QNaUR34YrO0=;
        b=OpHExQbDvfRI398skE80fX8Nib1GYCaPr3f/ViVRYIX7ywaY4psO7b10Qhiai8hlPl
         +PohjSx50saJzjdYdPiomrgPtK+5l9tf/XATtsPx+Rs9guvcBqMT3faX0UTYYEYfikG1
         OxPJPhWn8KDtqR1H2vsZJUQHKAIkBflRMTqd0SduVl5HElzxdVYVd2k3n/Ubq4Kukc65
         +UgDCZaOPqiHCeMWuSoDdN5hyEO9IuUgdRzAiY/sjhCMLpNsOTEOdaviTMBII+y9VZ6v
         viA3lMm+zPX2vXzOEK4OyowpJRWcx481xt+0KzXaTCr2iEX3e+Wp/2qTbJGB/UBNA/lV
         9wvA==
X-Gm-Message-State: AOAM532u3OEPDToO4v8bM9SOQUx3+XHctKWWCjXtJEDMhTG7RhXoO/PX
        KThYfpMc4BlezIUQNGpCPOR2FirJ1iXupo5d/YkimoAOw2NNWrJ1eIDKi6UXjnUquKZjhhI5I8D
        XMaL7onJQNKpo
X-Received: by 2002:a17:907:2ce4:: with SMTP id hz4mr21049625ejc.613.1643738592584;
        Tue, 01 Feb 2022 10:03:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5nfbBVX6CAP9we64rafxyCZ+WZP68jLdNCND3yt6wQlrq3AuaLg9JT0NV3H8Ir59kEQ+zGw==
X-Received: by 2002:a17:907:2ce4:: with SMTP id hz4mr21049595ejc.613.1643738592235;
        Tue, 01 Feb 2022 10:03:12 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l1sm2113995ejb.81.2022.02.01.10.03.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Feb 2022 10:03:11 -0800 (PST)
Message-ID: <aa2fac3a-02cc-2d36-a987-2704664dd814@redhat.com>
Date:   Tue, 1 Feb 2022 19:03:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 00/18] KVM: x86/mmu: Eager Page Splitting for the TDP
 MMU
Content-Language: en-US
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
References: <20220119230739.2234394-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 00:07, David Matlack wrote:
> This series implements Eager Page Splitting for the TDP MMU.
> 
> "Eager Page Splitting" is an optimization that has been in use in Google
> Cloud since 2016 to reduce the performance impact of live migration on
> customer workloads. It was originally designed and implemented by Peter
> Feiner <pfeiner@google.com>.
> 
> For background and performance motivation for this feature, please
> see "RFC: KVM: x86/mmu: Eager Page Splitting" [1].
> 
> Implementation
> ==============
> 
> This series implements support for splitting all huge pages mapped by
> the TDP MMU. Pages mapped by the shadow MMU are not split, although I
> plan to add the support in a future patchset.
> 
> Eager page splitting is triggered in two ways:
> 
> - KVM_SET_USER_MEMORY_REGION ioctl: If this ioctl is invoked to enable
>    dirty logging on a memslot and KVM_DIRTY_LOG_INITIALLY_SET is not
>    enabled, KVM will attempt to split all huge pages in the memslot down
>    to the 4K level.
> 
> - KVM_CLEAR_DIRTY_LOG ioctl: If this ioctl is invoked and
>    KVM_DIRTY_LOG_INITIALLY_SET is enabled, KVM will attempt to split all
>    huge pages cleared by the ioctl down to the 4K level before attempting
>    to write-protect them.
> 
> Eager page splitting is enabled by default in both paths but can be
> disabled via module param eager_page_split=N.
> 
> Splitting for pages mapped by the TDP MMU is done under the MMU lock in
> read mode. The lock is dropped and the thread rescheduled if contention
> or need_resched() is detected.
> 
> To allocate memory for the lower level page tables, we attempt to
> allocate without dropping the MMU lock using GFP_NOWAIT to avoid doing
> direct reclaim or invoking filesystem callbacks. If that fails we drop
> the lock and perform a normal GFP_KERNEL allocation.
> 
> Performance
> ===========
> 
> Eager page splitting moves the cost of splitting huge pages off of the
> vCPU thread and onto the thread invoking one of the aforementioned
> ioctls. This is useful because:
> 
>   - Splitting on the vCPU thread interrupts vCPUs execution and is
>     disruptive to customers whereas splitting on VM ioctl threads can
>     run in parallel with vCPU execution.
> 
>   - Splitting on the VM ioctl thread is more efficient because it does
>     no require performing VM-exit handling and page table walks for every
>     4K page.
> 
> The measure the performance impact of Eager Page Splitting I ran
> dirty_log_perf_test with 96 virtual CPUs, 1GiB per vCPU, and 1GiB
> HugeTLB memory.
> 
> When KVM_DIRTY_LOG_INITIALLY_SET is set, we can see that the first
> KVM_CLEAR_DIRTY_LOG iteration gets longer because KVM is splitting
> huge pages. But the time it takes for vCPUs to dirty their memory
> is significantly shorter since they do not have to take write-
> protection faults.
> 
>             | Iteration 1 clear dirty log time | Iteration 2 dirty memory time
> ---------- | -------------------------------- | -----------------------------
> Before     | 0.049572219s                     | 2.751442902s
> After      | 1.667811687s                     | 0.127016504s
> 
> Eager page splitting does make subsequent KVM_CLEAR_DIRTY_LOG ioctls
> about 4% slower since it always walks the page tables looking for pages
> to split.  This can be avoided but will require extra memory and/or code
> complexity to track when splitting can be skipped.
> 
>             | Iteration 3 clear dirty log time
> ---------- | --------------------------------
> Before     | 1.374501209s
> After      | 1.422478617s
> 
> When not using KVM_DIRTY_LOG_INITIALLY_SET, KVM performs splitting on
> the entire memslot during the KVM_SET_USER_MEMORY_REGION ioctl that
> enables dirty logging. We can see that as an increase in the time it
> takes to enable dirty logging. This allows vCPUs to avoid taking
> write-protection faults which we again see in the dirty memory time.
> 
>             | Enabling dirty logging time      | Iteration 1 dirty memory time
> ---------- | -------------------------------- | -----------------------------
> Before     | 0.001683739s                     | 2.943733325s
> After      | 1.546904175s                     | 0.145979748s
> 
> Testing
> =======
> 
> - Ran all kvm-unit-tests and KVM selftests on debug and non-debug kernels.
> 
> - Ran dirty_log_perf_test with different backing sources (anonymous,
>    anonymous_thp, anonymous_hugetlb_2mb, anonymous_hugetlb_1gb) with and
>    without Eager Page Splitting enabled.
> 
> - Added a tracepoint locally to time the GFP_NOWAIT allocations. Across
>    40 runs of dirty_log_perf_test using 1GiB HugeTLB with 96 vCPUs there
>    were only 4 allocations that took longer than 20 microseconds and the
>    longest was 60 microseconds. None of the GFP_NOWAIT allocations
>    failed.
> 
> - I have not been able to trigger a GFP_NOWAIT allocation failure (to
>    exercise the fallback path). However I did manually modify the code
>    to force every allocation to fallback by removing the GFP_NOWAIT
>    allocation altogether to make sure the logic works correctly.
> 
> - Live migrated a 32 vCPU 32 GiB Linux VM running a workload that
>    aggressively writes to guest memory with Eager Page Splitting enabled.
>    Observed pages being split via tracepoint and the pages_{4k,2m,1g}
>    stats.

Queued, thanks!

Paolo

> Version Log
> ===========
> 
> v2:
> 
> [Overall Changes]
>   - Additional testing by live migrating a Linux VM (see above).
>   - Add Sean's, Ben's, and Peter's Reviewed-by tags.
>   - Use () when referring to functions in commit message and comments [Sean]
>   - Add TDP MMU to shortlog where applicable [Sean]
>   - Fix gramatical errors in commit messages [Sean]
>   - Break 80+ char function declarations across multiple lines [Sean]
> 
> [PATCH v1 03/13] KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
>   - Remove useless empty line [Peter]
>   - Tighten up the wording in comments [Sean]
>   - Move result of rcu_dereference() to a local variable to cut down line lengths [Sean]
> 
> [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically install a new page table
>   - Add prep patch to return 0/-EBUSY instead of bool [Sean]
>   - Add prep patch to rename {un,}link_page to {un,}link_sp [Sean]
>   - Fold tdp_mmu_link_page() into tdp_mmu_install_sp_atomic() [Sean]
> 
> [PATCH v1 05/13] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
>   - Make inline [Sean]
>   - Eliminate WARN_ON_ONCE [Sean]
>   - Eliminate unnecessary local variable new_spte [Sean].
> 
> [PATCH v1 06/13] KVM: x86/mmu: Refactor tdp_mmu iterators to take kvm_mmu_page root
>   - Eliminate unnecessary local variable root_pt [Sean]
> 
> [PATCH v1 07/13] KVM: x86/mmu: Derive page role from parent
>   - Eliminate redundant role overrides [Sean]
> 
> [PATCH v1 08/13] KVM: x86/mmu: Refactor TDP MMU child page initialization
>   - Rename alloc_tdp_mmu_page*() functions [Sean]
> 
> [PATCH v1 09/13] KVM: x86/mmu: Split huge pages when dirty logging is enabled
>   - Drop access from make_huge_page_split_spte() [Sean]
>   - Drop is_mmio_spte() check from make_huge_page_split_spte() [Sean]
>   - Change WARN_ON to WARN_ON_ONCE in make_huge_page_split_spte() [Sean]
>   - Improve comment for making 4K SPTEs executable [Sean]
>   - Rename mark_spte_executable() to mark_spte_executable() [Sean]
>   - Put return type on same line as tdp_mmu_split_huge_page_atomic() [Sean]
>   - Drop child_spte local variable in tdp_mmu_split_huge_page_atomic() [Sean]
>   - Make alloc_tdp_mmu_page_for_split() play nice with
>     commit 3a0f64de479c ("KVM: x86/mmu: Don't advance iterator after restart due to yielding") [Sean]
>   - Free unused sp after dropping RCU [Sean]
>   - Rename module param to something shorter [Sean]
>   - Document module param somewhere [Sean]
>   - Fix rcu_read_unlock in tdp_mmu_split_huge_pages_root() [me]
>   - Document TLB flush behavior [Peter]
> 
> [PATCH v1 10/13] KVM: Push MMU locking down into kvm_arch_mmu_enable_log_dirty_pt_masked
>   - Drop [Peter]
> 
> [PATCH v1 11/13] KVM: x86/mmu: Split huge pages during CLEAR_DIRTY_LOG
>   - Hold the lock in write-mode when splitting [Peter]
>   - Document TLB flush behavior [Peter]
> 
> [PATCH v1 12/13] KVM: x86/mmu: Add tracepoint for splitting huge pages
>   - Record if split succeeded or failed [Sean]
> 
> v1: https://lore.kernel.org/kvm/20211213225918.672507-1-dmatlack@google.com/
> 
> [Overall Changes]
>   - Use "huge page" instead of "large page" [Sean Christopherson]
> 
> [RFC PATCH 02/15] KVM: x86/mmu: Rename __rmap_write_protect to rmap_write_protect
>   - Add Ben's Reviewed-by.
>   - Add Peter's Reviewed-by.
> 
> [RFC PATCH 03/15] KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
>   - Add comment when updating old_spte [Ben Gardon]
>   - Follow kernel style of else case in zap_gfn_range [Ben Gardon]
>   - Don't delete old_spte update after zapping in kvm_tdp_mmu_map [me]
> 
> [RFC PATCH 04/15] KVM: x86/mmu: Factor out logic to atomically install a new page table
>   - Add blurb to commit message describing intentional drop of tracepoint [Ben Gardon]
>   - Consolidate "u64 spte = make_nonleaf_spte(...);" onto one line [Sean Christopherson]
>   - Do not free the sp if set fails  [Sean Christopherson]
> 
> [RFC PATCH 05/15] KVM: x86/mmu: Abstract mmu caches out to a separate struct
>   - Drop to adopt Sean's proposed allocation scheme.
> 
> [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
>   - No changes.
> 
> [RFC PATCH 07/15] KVM: x86/mmu: Pass in vcpu->arch.mmu_caches instead of vcpu
>   - Drop to adopt Sean's proposed allocation scheme.
> 
> [RFC PATCH 08/15] KVM: x86/mmu: Helper method to check for large and present sptes
>   - Drop this commit and the helper function [Sean Christopherson]
> 
> [RFC PATCH 09/15] KVM: x86/mmu: Move restore_acc_track_spte to spte.c
>   - Add Ben's Reviewed-by.
> 
> [RFC PATCH 10/15] KVM: x86/mmu: Abstract need_resched logic from tdp_mmu_iter_cond_resched
>   - Drop to adopt Sean's proposed allocation scheme.
> 
> [RFC PATCH 11/15] KVM: x86/mmu: Refactor tdp_mmu iterators to take kvm_mmu_page root
>   - Add Ben's Reviewed-by.
> 
> [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty logging is enabled
>   - Add a module parameter to control Eager Page Splitting [Peter Xu]
>   - Change level to large_spte_level [Ben Gardon]
>   - Get rid of BUG_ONs [Ben Gardon]
>   - Change += to |= and add a comment [Ben Gardon]
>   - Do not flush TLBs when dropping the MMU lock. [Sean Christopherson]
>   - Allocate memory directly from the kernel instead of using mmu_caches [Sean Christopherson]
> 
> [RFC PATCH 13/15] KVM: x86/mmu: Split large pages during CLEAR_DIRTY_LOG
>   - Fix deadlock by refactoring MMU locking and dropping write lock before splitting. [kernel test robot]
>   - Did not follow Sean's suggestion of skipping write-protection if splitting
>     succeeds as it would require extra complexity since we aren't splitting
>     pages in the shadow MMU yet.
> 
> [RFC PATCH 14/15] KVM: x86/mmu: Add tracepoint for splitting large pages
>   - No changes.
> 
> [RFC PATCH 15/15] KVM: x86/mmu: Update page stats when splitting large pages
>   - Squash into patch that first introduces page splitting.
> 
> Note: I opted not to change TDP MMU functions to return int instead of
> bool per Sean's suggestion. I agree this change should be done but can
> be left to a separate series.
> 
> RFC: https://lore.kernel.org/kvm/20211119235759.1304274-1-dmatlack@google.com/
> 
> [1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t
> 
> David Matlack (18):
>    KVM: x86/mmu: Rename rmap_write_protect() to
>      kvm_vcpu_write_protect_gfn()
>    KVM: x86/mmu: Rename __rmap_write_protect() to rmap_write_protect()
>    KVM: x86/mmu: Automatically update iter->old_spte if cmpxchg fails
>    KVM: x86/mmu: Change tdp_mmu_{set,zap}_spte_atomic() to return
>      0/-EBUSY
>    KVM: x86/mmu: Rename TDP MMU functions that handle shadow pages
>    KVM: x86/mmu: Rename handle_removed_tdp_mmu_page() to
>      handle_removed_pt()
>    KVM: x86/mmu: Consolidate logic to atomically install a new TDP MMU
>      page table
>    KVM: x86/mmu: Remove unnecessary warnings from
>      restore_acc_track_spte()
>    KVM: x86/mmu: Drop new_spte local variable from
>      restore_acc_track_spte()
>    KVM: x86/mmu: Move restore_acc_track_spte() to spte.h
>    KVM: x86/mmu: Refactor TDP MMU iterators to take kvm_mmu_page root
>    KVM: x86/mmu: Remove redundant role overrides for TDP MMU shadow pages
>    KVM: x86/mmu: Derive page role for TDP MMU shadow pages from parent
>    KVM: x86/mmu: Separate TDP MMU shadow page allocation and
>      initialization
>    KVM: x86/mmu: Split huge pages mapped by the TDP MMU when dirty
>      logging is enabled
>    KVM: x86/mmu: Split huge pages mapped by the TDP MMU during
>      KVM_CLEAR_DIRTY_LOG
>    KVM: x86/mmu: Add tracepoint for splitting huge pages
>    KVM: selftests: Add an option to disable MANUAL_PROTECT_ENABLE and
>      INITIALLY_SET
> 
>   .../admin-guide/kernel-parameters.txt         |  26 ++
>   arch/x86/include/asm/kvm_host.h               |   7 +
>   arch/x86/kvm/mmu/mmu.c                        |  79 ++--
>   arch/x86/kvm/mmu/mmutrace.h                   |  23 +
>   arch/x86/kvm/mmu/spte.c                       |  59 +++
>   arch/x86/kvm/mmu/spte.h                       |  16 +
>   arch/x86/kvm/mmu/tdp_iter.c                   |   8 +-
>   arch/x86/kvm/mmu/tdp_iter.h                   |  10 +-
>   arch/x86/kvm/mmu/tdp_mmu.c                    | 419 +++++++++++++-----
>   arch/x86/kvm/mmu/tdp_mmu.h                    |   5 +
>   arch/x86/kvm/x86.c                            |   6 +
>   arch/x86/kvm/x86.h                            |   2 +
>   .../selftests/kvm/dirty_log_perf_test.c       |  13 +-
>   13 files changed, 520 insertions(+), 153 deletions(-)
> 
> 
> base-commit: edb9e50dbe18394d0fc9d0494f5b6046fc912d33

