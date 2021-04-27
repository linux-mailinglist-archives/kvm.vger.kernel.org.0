Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E8B36C97E
	for <lists+kvm@lfdr.de>; Tue, 27 Apr 2021 18:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhD0QeA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Apr 2021 12:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbhD0Qd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Apr 2021 12:33:59 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35A2C061756
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 09:33:14 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id j12so5151033ils.4
        for <kvm@vger.kernel.org>; Tue, 27 Apr 2021 09:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mC6Lh6YIg8y1o6IPvDiFDC52VhcL58BHx9AXb9c0teQ=;
        b=B+YYOve6z7jb4z/73BxCztQAIz4RyhUas+3lDburTMNqo2mvWnmvYQCH1C7vjywwOV
         T3h/Mf72qfVBW/9a7jcpSDIkJzZUaOs7v07TwUR+VoFWT0tgXGpY0TT+6eyrCs7WJEFA
         OVsTEKo1AyJ9FbnDlZM/QzMOEpDIjKj3k0/hjweaziCVL4kimYS6iWzgtwSyzqwos6rf
         jdluC34oEuoYGln2J9u5+5nUgntg84zQKqNrbR+C9YneugIpFvhhUCb4fCF/4e6aQq5o
         ebglYCDmHyX3GVl78ZPIpjABzs0rHhiE2sWqlsCCQPMJOR5z3c436mkMo4lpVPP6cbN5
         aKbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mC6Lh6YIg8y1o6IPvDiFDC52VhcL58BHx9AXb9c0teQ=;
        b=grswjEsbRoxbSkP+QqWLGXJJ3XeMmzkWG1O/vuuVyd/hhcC7o4S1sqgeIOV16P6JTF
         PrAzDrbDVvqA4Bl8y04OJWVRLvBvbnzbB40icbxUEPkCUXs0yfwvZstwB8XdxtqGPaKC
         sfYdff35ToYPmjJoKWXXn/I4pG53mFnsjG4Wydy6dzGKLGGyiL1i2IVJd/ycqNejtLbB
         tMfbe34qcJG6+JzgcoOxnknFpP1GnTkmOtyN9SKL+5x1uLYykfIoomd7My9Anw5a7Ckl
         KHPw/TsLifQ3Hih4FbkYMxPqxtSKSz7jx3LkeFuh4yD39Ertqr93fI/v91pZJfX8ukrL
         N6LQ==
X-Gm-Message-State: AOAM530+qRQ+AnSoTRNl8yUZ1DNXPkHQDVhOlzq8ns+aORCxT81fJiGU
        mxZ4+DVF7abrik35N3poWxkazFnB3yUmg/XKC1CMew==
X-Google-Smtp-Source: ABdhPJyJXlsEFZtXDrYn6Rqlqa/kdFjGgHheh0Z7Rddyr2mDYHe+KqohS6QHjbg+Q8aNCQOExSBtcoCnEcDt0SzkaFk=
X-Received: by 2002:a92:340e:: with SMTP id b14mr19766869ila.285.1619541193980;
 Tue, 27 Apr 2021 09:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210416082511.2856-1-zhukeqian1@huawei.com> <20210416082511.2856-3-zhukeqian1@huawei.com>
 <CANgfPd_WzX6Fm7BiMoBoehuLL8tjh4WEqehUhF8biPyL8vS4XQ@mail.gmail.com>
 <49e6bf4f-0142-c9ea-a8c1-7cfe211c8d7b@huawei.com> <CANgfPd840MmH5zKRHb4p1Rk0QEDu8iJoMJZGxWF6fhqxANrptg@mail.gmail.com>
 <f0651fce-3b39-3ca7-6681-9fbc6edf8480@huawei.com>
In-Reply-To: <f0651fce-3b39-3ca7-6681-9fbc6edf8480@huawei.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 27 Apr 2021 09:33:02 -0700
Message-ID: <CANgfPd_xJbL388zmirbQW-pSw+o0csmNe=uLA1yV_Zk-QMvDfA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/2] KVM: x86: Not wr-protect huge page with
 init_all_set dirty log
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        wanghaibin.wang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 26, 2021 at 10:04 PM Keqian Zhu <zhukeqian1@huawei.com> wrote:
>
> Hi Ben,
>
> Sorry for the delay reply!
>
> On 2021/4/21 0:30, Ben Gardon wrote:
> > On Tue, Apr 20, 2021 at 12:49 AM Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >>
> >> Hi Ben,
> >>
> >> On 2021/4/20 3:20, Ben Gardon wrote:
> >>> On Fri, Apr 16, 2021 at 1:25 AM Keqian Zhu <zhukeqian1@huawei.com> wrote:
> >>>>
> >>>> Currently during start dirty logging, if we're with init-all-set,
> >>>> we write protect huge pages and leave normal pages untouched, for
> >>>> that we can enable dirty logging for these pages lazily.
> >>>>
> >>>> Actually enable dirty logging lazily for huge pages is feasible
> >>>> too, which not only reduces the time of start dirty logging, also
> >>>> greatly reduces side-effect on guest when there is high dirty rate.
> >>>>
> >>>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> >>>> ---
> >>>>  arch/x86/kvm/mmu/mmu.c | 48 ++++++++++++++++++++++++++++++++++++++----
> >>>>  arch/x86/kvm/x86.c     | 37 +++++++++-----------------------
> >>>>  2 files changed, 54 insertions(+), 31 deletions(-)
> >>>>
> >>>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >>>> index 2ce5bc2ea46d..98fa25172b9a 100644
> >>>> --- a/arch/x86/kvm/mmu/mmu.c
> >>>> +++ b/arch/x86/kvm/mmu/mmu.c
> >>>> @@ -1188,8 +1188,7 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
> >>>>   * @gfn_offset: start of the BITS_PER_LONG pages we care about
> >>>>   * @mask: indicates which pages we should protect
> >>>>   *
> >>>> - * Used when we do not need to care about huge page mappings: e.g. during dirty
> >>>> - * logging we do not have any such mappings.
> >>>> + * Used when we do not need to care about huge page mappings.
> >>>>   */
> >>>>  static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
> >>>>                                      struct kvm_memory_slot *slot,
> >>>> @@ -1246,13 +1245,54 @@ static void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
> >>>>   * It calls kvm_mmu_write_protect_pt_masked to write protect selected pages to
> >>>>   * enable dirty logging for them.
> >>>>   *
> >>>> - * Used when we do not need to care about huge page mappings: e.g. during dirty
> >>>> - * logging we do not have any such mappings.
> >>>> + * We need to care about huge page mappings: e.g. during dirty logging we may
> >>>> + * have any such mappings.
> >>>>   */
> >>>>  void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >>>>                                 struct kvm_memory_slot *slot,
> >>>>                                 gfn_t gfn_offset, unsigned long mask)
> >>>>  {
> >>>> +       gfn_t start, end;
> >>>> +
> >>>> +       /*
> >>>> +        * Huge pages are NOT write protected when we start dirty log with
> >>>> +        * init-all-set, so we must write protect them at here.
> >>>> +        *
> >>>> +        * The gfn_offset is guaranteed to be aligned to 64, but the base_gfn
> >>>> +        * of memslot has no such restriction, so the range can cross two large
> >>>> +        * pages.
> >>>> +        */
> >>>> +       if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> >>>> +               start = slot->base_gfn + gfn_offset + __ffs(mask);
> >>>> +               end = slot->base_gfn + gfn_offset + __fls(mask);
> >>>> +               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> >>>> +
> >>>> +               /* Cross two large pages? */
> >>>> +               if (ALIGN(start << PAGE_SHIFT, PMD_SIZE) !=
> >>>> +                   ALIGN(end << PAGE_SHIFT, PMD_SIZE))
> >>>> +                       kvm_mmu_slot_gfn_write_protect(kvm, slot, end,
> >>>> +                                                      PG_LEVEL_2M);
> >>>> +       }
> >>>> +
> >>>> +       /*
> >>>> +        * RFC:
> >>>> +        *
> >>>> +        * 1. I don't return early when kvm_mmu_slot_gfn_write_protect() returns
> >>>> +        * true, because I am not very clear about the relationship between
> >>>> +        * legacy mmu and tdp mmu. AFAICS, the code logic is NOT an if/else
> >>>> +        * manner.
> >>>> +        *
> >>>> +        * The kvm_mmu_slot_gfn_write_protect() returns true when we hit a
> >>>> +        * writable large page mapping in legacy mmu mapping or tdp mmu mapping.
> >>>> +        * Do we still have normal mapping in that case? (e.g. We have large
> >>>> +        * mapping in legacy mmu and normal mapping in tdp mmu).
> >>>
> >>> Right, we can't return early because the two MMUs could map the page
> >>> in different ways, but each MMU could also map the page in multiple
> >>> ways independently.
> >>> For example, if the legacy MMU was being used and we were running a
> >>> nested VM, a page could be mapped 2M in EPT01 and 4K in EPT02, so we'd
> >>> still need kvm_mmu_slot_gfn_write_protect  calls for both levels.
> >>> I don't think there's a case where we can return early here with the
> >>> information that the first calls to kvm_mmu_slot_gfn_write_protect
> >>> access.
> >> Thanks for the detailed explanation.
> >>
> >>>
> >>>> +        *
> >>>> +        * 2. kvm_mmu_slot_gfn_write_protect() doesn't tell us whether the large
> >>>> +        * page mapping exist. If it exists but is clean, we can return early.
> >>>> +        * However, we have to do invasive change.
> >>>
> >>> What do you mean by invasive change?
> >> We need the kvm_mmu_slot_gfn_write_protect to report whether all mapping are large
> >> and clean, so we can return early. However it's not a part of semantics of this function.
> >>
> >> If this is the final code, compared to old code, we have an extra gfn_write_protect(),
> >> I don't whether it's acceptable?
> >
> > Ah, I see. Please correct me if I'm wrong, but I think that in order
> > to check that the only mappings on the GFN range are large, we'd still
> > have to go over the rmap for the 4k mappings, at least for the legacy
> > MMU. In that case, we're doing about as much work as the extra
> > gfn_write_protect and I don't think that we'd get any efficiency gain
> > for the change in semantics.
> >
> > Likewise for the TDP MMU, if the GFN range is mapped both large and
> > 4k, it would have to be in different TDP structures, so the efficiency
> > gains would again not be very big.
> I am not familiar with the MMU virtualization of x86 arch, but I think
> you are right.
>
> >
> > I'm really just guessing about those performance characteristics
> > though. It would definitely help to have some performance data to back
> > all this up. Even just a few runs of the dirty_log_perf_test (in
> > selftests) could provide some interesting results, and I'd be happy to
> > help review any improvements you might make to that test.
> >
> > Regardless, I'd be inclined to keep this change as simple as possible
> > for now and the early return optimization could happen in a follow-up
> > patch. I think the extra gfn_write_protect is acceptable, especially
> > if you can show that it doesn't cause a big hit in performance when
> > running the dirty_log_perf_test with 4k and 2m backing memory.
> I tested it using dirty_log_perf_test, the result shows that performance
> of clear_dirty_log different within 2%.

I think there are a couple obstacles which make the stock
dirty_log_perf_test less useful for measuring this optimization.

1. Variance between runs
With only 16 vCPUs and whatever the associated default guest memory
size is, random system events and daemons introduce a lot of variance,
at least in my testing. I usually try to run the biggest VM I can to
smooth that out, but even with a 96 vCPU VM, a 2% difference is often
not statistically significant.  CPU pinning for the vCPU threads would
help a lot to reduce variance. I don't remember if anyone has
implemented this yet.

2. The guest dirty pattern
By default, each guest vCPU will dirty it's entire partition of guest
memory on each iteration. This means that instead of amortizing out
the cost of write-protecting and splitting large pages, we simply move
the burden later in the process. I see you didn't include the time for
each iteration below, but I would expect this patch to move some of
the time from "Enabling dirty logging time" and "Dirtying memory time"
for pass 1 to "Clear dirty log time" and "Dirtying memory time" for
pass 2. I wouldn't expect the total time over 5 iterations to change
for this test.

It would probably also serve us well to have some kind of "hot" subset
of memory for each vCPU, since some of the benefit of lazy large page
splitting depend on that access pattern.

3. Lockstep dirtying and dirty log collection
While this test is currently great for timing dirty logging
operations, it's not great for trickier analysis, especially
reductions to guest degradation. In order to measure that we'd need to
change the test to collect the dirty log as quickly as possible,
independent of what the guest is doing and then also record how much
"progress" the guest is able to make while all that is happening.

I'd be happy to help review any improvements to the test which you
feel like making.

>
> *Without this patch*
>
> ./dirty_log_perf_test -i 5 -v 16 -s anonymous
>
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0xffbfffff000
> Populate memory time: 3.105203579s
> Enabling dirty logging time: 0.000323444s
> [...]
> Get dirty log over 5 iterations took 0.000595033s. (Avg 0.000119006s/iteration)
> Clear dirty log over 5 iterations took 0.713212922s. (Avg 0.142642584s/iteration)
>
> ./dirty_log_perf_test -i 5 -v 16 -s anonymous_hugetlb
>
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0xffbfffff000
> Populate memory time: 3.922764235s
> Enabling dirty logging time: 0.000316473s
> [...]
> Get dirty log over 5 iterations took 0.000485459s. (Avg 0.000097091s/iteration)
> Clear dirty log over 5 iterations took 0.603749670s. (Avg 0.120749934s/iteration)
>
>
> *With this patch*
>
> ./dirty_log_perf_test -i 5 -v 16 -s anonymous
>
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0xffbfffff000
> Populate memory time: 3.244515198s
> Enabling dirty logging time: 0.000280207s
> [...]
> Get dirty log over 5 iterations took 0.000484953s. (Avg 0.000096990s/iteration)
> Clear dirty log over 5 iterations took 0.727620114s. (Avg 0.145524022s/iteration)
>
> ./dirty_log_perf_test -i 5 -v 16 -s anonymous_hugetlb
>
> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
> guest physical test memory offset: 0xffbfffff000
> Populate memory time: 3.244294061s
> Enabling dirty logging time: 0.000273590s
> [...]
> Get dirty log over 5 iterations took 0.000474244s. (Avg 0.000094848s/iteration)
> Clear dirty log over 5 iterations took 0.600593672s. (Avg 0.120118734s/iteration)
>
>
> I faced a problem that there is no huge page mapping when test with
> "-s anonymous_hugetlb", both for TDP enabled or disabled.

Do you mean that even before dirty logging was enabled, KVM didn't
create any large mappings? That's odd. I would assume the backing
memory allocation would just fail if there aren't enough hugepages
available.

>
> However, these tests above can tell the fact that our optimization does little effect
> on clear_dirty_log performance.
>
> Thanks,
> Keqian
>
> >
> >>
> >> Thanks,
> >> Keqian
> >>
> >>
> >>>
> >>>> +        */
> >>>> +
> >>>> +       /* Then we can handle the PT level pages */
> >>>>         if (kvm_x86_ops.cpu_dirty_log_size)
> >>>>                 kvm_mmu_clear_dirty_pt_masked(kvm, slot, gfn_offset, mask);
> >>>>         else
> >>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >>>> index eca63625aee4..dfd676ffa7da 100644
> >>>> --- a/arch/x86/kvm/x86.c
> >>>> +++ b/arch/x86/kvm/x86.c
> >>>> @@ -10888,36 +10888,19 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >>>>                  */
> >>>>                 kvm_mmu_zap_collapsible_sptes(kvm, new);
> >>>>         } else {
> >>>> -               /* By default, write-protect everything to log writes. */
> >>>> -               int level = PG_LEVEL_4K;
> >>>> +               /*
> >>>> +                * If we're with initial-all-set, we don't need to write protect
> >>>> +                * any page because they're reported as dirty already.
> >>>> +                */
> >>>> +               if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> >>>> +                       return;
> >>>>
> >>>>                 if (kvm_x86_ops.cpu_dirty_log_size) {
> >>>> -                       /*
> >>>> -                        * Clear all dirty bits, unless pages are treated as
> >>>> -                        * dirty from the get-go.
> >>>> -                        */
> >>>> -                       if (!kvm_dirty_log_manual_protect_and_init_set(kvm))
> >>>> -                               kvm_mmu_slot_leaf_clear_dirty(kvm, new);
> >>>> -
> >>>> -                       /*
> >>>> -                        * Write-protect large pages on write so that dirty
> >>>> -                        * logging happens at 4k granularity.  No need to
> >>>> -                        * write-protect small SPTEs since write accesses are
> >>>> -                        * logged by the CPU via dirty bits.
> >>>> -                        */
> >>>> -                       level = PG_LEVEL_2M;
> >>>> -               } else if (kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> >>>> -                       /*
> >>>> -                        * If we're with initial-all-set, we don't need
> >>>> -                        * to write protect any small page because
> >>>> -                        * they're reported as dirty already.  However
> >>>> -                        * we still need to write-protect huge pages
> >>>> -                        * so that the page split can happen lazily on
> >>>> -                        * the first write to the huge page.
> >>>> -                        */
> >>>> -                       level = PG_LEVEL_2M;
> >>>> +                       kvm_mmu_slot_leaf_clear_dirty(kvm, new);
> >>>> +                       kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_2M);
> >>>> +               } else {
> >>>> +                       kvm_mmu_slot_remove_write_access(kvm, new, PG_LEVEL_4K);
> >>>>                 }
> >>>> -               kvm_mmu_slot_remove_write_access(kvm, new, level);
> >>>>         }
> >>>>  }
> >>>>
> >>>> --
> >>>> 2.23.0
> >>>>
> >>> .
> >>>
> > .
> >
