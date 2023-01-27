Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898EC67E9EF
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 16:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbjA0PqN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 10:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbjA0Pp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 10:45:59 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C821E84FB8
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:45:35 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id d13so2516583qkk.12
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p8Z/gi3ufwmiA1kAD5TWm5UzQtPDtBj/4S6C+i0Z8XQ=;
        b=mGTtF8mMjUBkM6s4dZEr5EDVhBn4+BQBEBS7AGQYxaaukWVDmBpGBbpMlf419QZat4
         tbHnSEYpTKc022tK2IMpVstFQiACA7T0p+phHxzl91aGjV4ruUzzOzkkr/acD0wC7oFY
         D7VE8yhah/avaWh/7JnOEhPQaVEguB0io0QSeVEyfZhxe/dKa6qd0LVbBccsnKjQbWgx
         rbPjgZjAaj+vT9dVgiuZc6oVBtZFCIfQyqt7sB9DMGPnRmwV5haEDXfZfo+fSo3XU2hG
         cTn4fwLJN0Y+SQx8t7ZGGZZqe2jEDsybalSXhB/JUggpNmTxEVtuCvTaF8SUpZsWcSvY
         /EGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p8Z/gi3ufwmiA1kAD5TWm5UzQtPDtBj/4S6C+i0Z8XQ=;
        b=2G/raulBZKSt/lsxMdk+b1jrh88vOy9gdi0UCHYHF8GBBrmRMkz9yk8KRsEVqAOzuU
         qJgT4PviLeJaDd/rzL0K/JEU/njaFR5GBQeZltI2jPrAGuqyZyQJuD5TNZm06rOqxJ0O
         2n36cmogpc1Rayi2inG4tsTTxnEa1Kr2b8/LZ4cc7K/gpMymt0sy+O0B2XpI4F29TYJE
         J7iSkfhc1ktvOBlGnXwSyM95xR89sMCRqgKMmrVLaNYuVWQAWhaWrT+XOSju5SOvkO3Q
         qLJQODqmFetUJ0MYBTFrM21n7EAh7nycrWAdVVxk9zWPA5stR+K/eZz8zqvuguk3tE+Q
         mMzg==
X-Gm-Message-State: AFqh2krMoZ5zhYYYJ9/uay6Sfy02qbW0/Yj8Er0gUJG9AgKATpHX0ZKs
        pyjCDNYYrWD1Va7hvOjKx94TgyTFZkwI5lFXu7NhAQ==
X-Google-Smtp-Source: AMrXdXvDWqh/1yfuPtUzzdUCYXFtOPArOTAdv2YTeqhlKY0I9gNNhPjHtXPQvKrSRQtdXycpDpOgBJ/y0miouwuimIQ=
X-Received: by 2002:a05:620a:14ba:b0:702:e5b:a78c with SMTP id
 x26-20020a05620a14ba00b007020e5ba78cmr2324123qkj.230.1674834326637; Fri, 27
 Jan 2023 07:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com> <20230113035000.480021-7-ricarkol@google.com>
 <Y9BfdgL+JSYCirvm@thinky-boi> <CAOHnOrysMhp_8Kdv=Pe-O8ZGDbhN5HiHWVhBv795_E6+4RAzPw@mail.gmail.com>
 <86v8ktkqfx.wl-maz@kernel.org>
In-Reply-To: <86v8ktkqfx.wl-maz@kernel.org>
From:   Ricardo Koller <ricarkol@google.com>
Date:   Fri, 27 Jan 2023 07:45:15 -0800
Message-ID: <CAOHnOrx-vvuZ9n8xDRmJTBCZNiqvcqURVyrEt2tDpw5bWT0qew@mail.gmail.com>
Subject: Re: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>, pbonzini@redhat.com,
        oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Jan 26, 2023 at 12:10 PM Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 26 Jan 2023 18:45:43 +0000,
> Ricardo Koller <ricarkol@google.com> wrote:
> >
> > On Tue, Jan 24, 2023 at 2:45 PM Oliver Upton <oliver.upton@linux.dev> wrote:
> > >
> > > Hi Ricardo,
> > >
> > > On Fri, Jan 13, 2023 at 03:49:57AM +0000, Ricardo Koller wrote:
> > > > Split huge pages eagerly when enabling dirty logging. The goal is to
> > > > avoid doing it while faulting on write-protected pages, which
> > > > negatively impacts guest performance.
> > > >
> > > > A memslot marked for dirty logging is split in 1GB pieces at a time.
> > > > This is in order to release the mmu_lock and give other kernel threads
> > > > the opportunity to run, and also in order to allocate enough pages to
> > > > split a 1GB range worth of huge pages (or a single 1GB huge page).
> > > > Note that these page allocations can fail, so eager page splitting is
> > > > best-effort.  This is not a correctness issue though, as huge pages
> > > > can still be split on write-faults.
> > > >
> > > > The benefits of eager page splitting are the same as in x86, added
> > > > with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
> > > > the TDP MMU when dirty logging is enabled"). For example, when running
> > > > dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
> > > > 50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
> > > > all of their memory after dirty logging is enabled decreased by 44%
> > > > from 2.58s to 1.42s.
> > > >
> > > > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > > > ---
> > > >  arch/arm64/include/asm/kvm_host.h |  30 ++++++++
> > > >  arch/arm64/kvm/mmu.c              | 110 +++++++++++++++++++++++++++++-
> > > >  2 files changed, 138 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > index 35a159d131b5..6ab37209b1d1 100644
> > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > @@ -153,6 +153,36 @@ struct kvm_s2_mmu {
> > > >       /* The last vcpu id that ran on each physical CPU */
> > > >       int __percpu *last_vcpu_ran;
> > > >
> > > > +     /*
> > > > +      * Memory cache used to split EAGER_PAGE_SPLIT_CHUNK_SIZE worth of huge
> > > > +      * pages. It is used to allocate stage2 page tables while splitting
> > > > +      * huge pages. Its capacity should be EAGER_PAGE_SPLIT_CACHE_CAPACITY.
> > > > +      * Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE influences both
> > > > +      * the capacity of the split page cache (CACHE_CAPACITY), and how often
> > > > +      * KVM reschedules. Be wary of raising CHUNK_SIZE too high.
> > > > +      *
> > > > +      * A good heuristic to pick CHUNK_SIZE is that it should be larger than
> > > > +      * all the available huge-page sizes, and be a multiple of all the
> > > > +      * other ones; for example, 1GB when all the available huge-page sizes
> > > > +      * are (1GB, 2MB, 32MB, 512MB).
> > > > +      *
> > > > +      * CACHE_CAPACITY should have enough pages to cover CHUNK_SIZE; for
> > > > +      * example, 1GB requires the following number of PAGE_SIZE-pages:
> > > > +      * - 512 when using 2MB hugepages with 4KB granules (1GB / 2MB).
> > > > +      * - 513 when using 1GB hugepages with 4KB granules (1 + (1GB / 2MB)).
> > > > +      * - 32 when using 32MB hugepages with 16KB granule (1GB / 32MB).
> > > > +      * - 2 when using 512MB hugepages with 64KB granules (1GB / 512MB).
> > > > +      * CACHE_CAPACITY below assumes the worst case: 1GB hugepages with 4KB
> > > > +      * granules.
> > > > +      *
> > > > +      * Protected by kvm->slots_lock.
> > > > +      */
> > > > +#define EAGER_PAGE_SPLIT_CHUNK_SIZE                 SZ_1G
> > > > +#define EAGER_PAGE_SPLIT_CACHE_CAPACITY                                      \
> > > > +     (DIV_ROUND_UP_ULL(EAGER_PAGE_SPLIT_CHUNK_SIZE, SZ_1G) +         \
> > > > +      DIV_ROUND_UP_ULL(EAGER_PAGE_SPLIT_CHUNK_SIZE, SZ_2M))
> > >
> > > Could you instead make use of the existing KVM_PGTABLE_MIN_BLOCK_LEVEL
> > > as the batch size? 513 pages across all page sizes is a non-negligible
> > > amount of memory that goes largely unused when PAGE_SIZE != 4K.
> > >
> >
> > Sounds good, will refine this for v2.
> >
> > > With that change it is a lot easier to correctly match the cache
> > > capacity to the selected page size. Additionally, we continue to have a
> > > single set of batching logic that we can improve later on.
> > >
> > > > +     struct kvm_mmu_memory_cache split_page_cache;
> > > > +
> > > >       struct kvm_arch *arch;
> > > >  };
> > > >
> > > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > > > index 700c5774b50d..41ee330edae3 100644
> > > > --- a/arch/arm64/kvm/mmu.c
> > > > +++ b/arch/arm64/kvm/mmu.c
> > > > @@ -31,14 +31,24 @@ static phys_addr_t hyp_idmap_vector;
> > > >
> > > >  static unsigned long io_map_base;
> > > >
> > > > -static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
> > > > +bool __read_mostly eager_page_split = true;
> > > > +module_param(eager_page_split, bool, 0644);
> > > > +
> > >
> > > Unless someone is really begging for it I'd prefer we not add a module
> > > parameter for this.
> >
> > It was mainly to match x86 and because it makes perf testing a bit
> > simpler. What do others think?
>
> From my PoV this is a no.
>
> If you have a flag because this is an experimental feature (like NV),
> then this is a kernel option, and you taint the kernel when it is set.
>
> If you have a flag because this is a modal option that makes different
> use of the HW which cannot be exposed to userspace (like GICv4), then
> this also is a kernel option.
>
> This is neither.

Ah, I see. Thanks for the explanation.

>
> The one thing that would convince me to make it an option is the
> amount of memory this thing consumes. 512+ pages is a huge amount, and
> I'm not overly happy about that. Why can't this be a userspace visible
> option, selectable on a per VM (or memslot) basis?
>

It should be possible.  I am exploring a couple of ideas that could
help when the hugepages are not 1G (e.g., 2M).  However, they add
complexity and I'm not sure they help much.

(will be using PAGE_SIZE=4K to make things simpler)

This feature pre-allocates 513 pages before splitting every 1G range.
For example, it converts 1G block PTEs into trees made of 513 pages.
When not using this feature, the same 513 pages would be allocated,
but lazily over a longer period of time.

Eager-splitting pre-allocates those pages in order to split huge-pages
into fully populated trees.  Which is needed in order to use FEAT_BBM
and skipping the expensive TLBI broadcasts.  513 is just the number of
pages needed to break a 1G huge-page.

We could optimize for smaller huge-pages, like 2M by splitting 1
huge-page at a time: only preallocate one 4K page at a time.  The
trick is how to know that we are splitting 2M huge-pages.  We could
either get the vma pagesize or use hints from userspace.  I'm not sure
that this is worth it though.  The user will most likely want to split
big ranges of memory (>1G), so optimizing for smaller huge-pages only
converts the left into the right:

alloc 1 page            |    |  alloc 512 pages
split 2M huge-page      |    |  split 2M huge-page
alloc 1 page            |    |  split 2M huge-page
split 2M huge-page      | => |  split 2M huge-page
                        ...
alloc 1 page            |    |  split 2M huge-page
split 2M huge-page      |    |  split 2M huge-page

Still thinking of what else to do.

Thanks!
Ricardo

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
