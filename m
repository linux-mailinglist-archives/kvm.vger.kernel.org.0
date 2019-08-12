Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328C38A7CA
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 22:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfHLUEZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 12 Aug 2019 16:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33370 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727224AbfHLUEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 16:04:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88978182D;
        Mon, 12 Aug 2019 20:04:23 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACE7F4D711;
        Mon, 12 Aug 2019 20:04:09 +0000 (UTC)
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>, cohuck@redhat.com
References: <20190812131235.27244-1-nitesh@redhat.com>
 <20190812131235.27244-2-nitesh@redhat.com>
 <CAKgT0UcSabyrO=jUwq10KpJKLSuzorHDnKAGrtWVigKVgvD-6Q@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <b5d4ee25-ae3e-f012-d7f2-7a27d7bbcc54@redhat.com>
Date:   Mon, 12 Aug 2019 16:04:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UcSabyrO=jUwq10KpJKLSuzorHDnKAGrtWVigKVgvD-6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Mon, 12 Aug 2019 20:04:23 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/12/19 2:47 PM, Alexander Duyck wrote:
> On Mon, Aug 12, 2019 at 6:13 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>> This patch introduces the core infrastructure for free page reporting in
>> virtual environments. It enables the kernel to track the free pages which
>> can be reported to its hypervisor so that the hypervisor could
>> free and reuse that memory as per its requirement.
>>
>> While the pages are getting processed in the hypervisor (e.g.,
>> via MADV_DONTNEED), the guest must not use them, otherwise, data loss
>> would be possible. To avoid such a situation, these pages are
>> temporarily removed from the buddy. The amount of pages removed
>> temporarily from the buddy is governed by the backend(virtio-balloon
>> in our case).
>>
>> To efficiently identify free pages that can to be reported to the
>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
>> chunks are reported to the hypervisor - especially, to not break up THP
>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
>> in the bitmap are an indication whether a page *might* be free, not a
>> guarantee. A new hook after buddy merging sets the bits.
>>
>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
>> asynchronously processes the bitmaps, trying to isolate and report pages
>> that are still free. The backend (virtio-balloon) is responsible for
>> reporting these batched pages to the host synchronously. Once reporting/
>> freeing is complete, isolated pages are returned back to the buddy.
>>
>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> So if I understand correctly the hotplug support for this is still not
> included correct? 


That is correct, I have it as an ongoing-item in my cover-email.
In case, we decide to go with this approach do you think it is a blocker?


> I assume that is the case since I don't see any
> logic for zone resizing.
>
> Also I don't see how this dealt with the sparse issue that was pointed
> out earlier. Specifically how would you deal with a zone that has a
> wide range between the base and the end and a huge gap somewhere
> in-between?

It doesn't. However, considering we are tracking page on order of (MAX_ORDER -
2) I don't think the loss will be significant.
In any case, this is certainly a drawback of this approach and I should add this
in my cover.
The one thing which I did change in this version is that now I started
maintaining bitmap for each zone.

>
>> ---
>>  include/linux/mmzone.h         |  11 ++
>>  include/linux/page_reporting.h |  63 +++++++
>>  mm/Kconfig                     |   6 +
>>  mm/Makefile                    |   1 +
>>  mm/page_alloc.c                |  42 ++++-
>>  mm/page_reporting.c            | 332 +++++++++++++++++++++++++++++++++
>>  6 files changed, 448 insertions(+), 7 deletions(-)
>>  create mode 100644 include/linux/page_reporting.h
>>  create mode 100644 mm/page_reporting.c
>>
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index d77d717c620c..ba5f5b508f25 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -559,6 +559,17 @@ struct zone {
>>         /* Zone statistics */
>>         atomic_long_t           vm_stat[NR_VM_ZONE_STAT_ITEMS];
>>         atomic_long_t           vm_numa_stat[NR_VM_NUMA_STAT_ITEMS];
>> +#ifdef CONFIG_PAGE_REPORTING
>> +       /* Pointer to the bitmap in PAGE_REPORTING_MIN_ORDER granularity */
>> +       unsigned long *bitmap;
>> +       /* Preserve start and end PFN in case they change due to hotplug */
>> +       unsigned long base_pfn;
>> +       unsigned long end_pfn;
>> +       /* Free pages of granularity PAGE_REPORTING_MIN_ORDER */
>> +       atomic_t free_pages;
>> +       /* Number of bits required in the bitmap */
>> +       unsigned long nbits;
>> +#endif
>>  } ____cacheline_internodealigned_in_smp;
> Okay, so the original thing this patch set had going for it was that
> it was non-invasive. However, now you are adding a bunch of stuff to
> the zone. That kind of loses the non-invasive argument for this patch
> set compared to mine.

I think it is fair to add that it not as invasive as yours. :) (But that has its
own pros and cons)
In any case, I do understand your point.

>
>
> If we are going to continue further with this patch set then it might
> be worth looking into dynamically allocating the space you need for
> this block.

Not sure if I understood this part. Dynamic allocation for the structure which
you are suggesting below?


>  At a minimum you could probably look at making the bitmap
> an RCU based setup so you could define the base and end along with the
> bitmap. It would probably help to resolve the hotplug issues you still
> need to address.


Thanks for the suggestion. I will look into it.


>
>>  enum pgdat_flags {
>> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
>> new file mode 100644
>> index 000000000000..37a39589939d
>> --- /dev/null
>> +++ b/include/linux/page_reporting.h
>> @@ -0,0 +1,63 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_PAGE_REPORTING_H
>> +#define _LINUX_PAGE_REPORTING_H
>> +
>> +#define PAGE_REPORTING_MIN_ORDER               (MAX_ORDER - 2)
>> +#define PAGE_REPORTING_MAX_PAGES               16
>> +
>> +#ifdef CONFIG_PAGE_REPORTING
>> +struct page_reporting_config {
>> +       /* function to hint batch of isolated pages */
>> +       void (*report)(struct page_reporting_config *phconf,
>> +                      unsigned int num_pages);
>> +
>> +       /* scatterlist to hold the isolated pages to be hinted */
>> +       struct scatterlist *sg;
>> +
>> +       /*
>> +        * Maxmimum pages that are going to be hinted to the hypervisor at a
>> +        * time of granularity >= PAGE_REPORTING_MIN_ORDER.
>> +        */
>> +       int max_pages;
>> +
>> +       /* work object to process page reporting rqeuests */
>> +       struct work_struct reporting_work;
>> +
>> +       /* tracks the number of reporting request processed at a time */
>> +       atomic_t refcnt;
>> +};
>> +
>> +void __page_reporting_enqueue(struct page *page);
>> +void __return_isolated_page(struct zone *zone, struct page *page);
>> +void set_pageblock_migratetype(struct page *page, int migratetype);
>> +
>> +/**
>> + * page_reporting_enqueue - checks the eligibility of the freed page based on
>> + * its order for further page reporting processing.
>> + * @page: page which has been freed.
>> + * @order: order for the the free page.
>> + */
>> +static inline void page_reporting_enqueue(struct page *page, int order)
>> +{
>> +       if (order < PAGE_REPORTING_MIN_ORDER)
>> +               return;
>> +       __page_reporting_enqueue(page);
>> +}
>> +
>> +int page_reporting_enable(struct page_reporting_config *phconf);
>> +void page_reporting_disable(struct page_reporting_config *phconf);
>> +#else
>> +static inline void page_reporting_enqueue(struct page *page, int order)
>> +{
>> +}
>> +
>> +static inline int page_reporting_enable(struct page_reporting_config *phconf)
>> +{
>> +       return -EOPNOTSUPP;
>> +}
>> +
>> +static inline void page_reporting_disable(struct page_reporting_config *phconf)
>> +{
>> +}
>> +#endif /* CONFIG_PAGE_REPORTING */
>> +#endif /* _LINUX_PAGE_REPORTING_H */
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 56cec636a1fc..6a35a9dad350 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -736,4 +736,10 @@ config ARCH_HAS_PTE_SPECIAL
>>  config ARCH_HAS_HUGEPD
>>         bool
>>
>> +# PAGE_REPORTING will allow the guest to report the free pages to the
>> +# host in fixed chunks as soon as a fixed threshold is reached.
>> +config PAGE_REPORTING
>> +       bool
>> +       def_bool n
>> +       depends on X86_64
>>  endmenu
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 338e528ad436..6a32cdfa61c2 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -104,3 +104,4 @@ obj-$(CONFIG_HARDENED_USERCOPY) += usercopy.o
>>  obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
>>  obj-$(CONFIG_HMM_MIRROR) += hmm.o
>>  obj-$(CONFIG_MEMFD_CREATE) += memfd.o
>> +obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 272c6de1bf4e..aa7c89d50c85 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -68,6 +68,7 @@
>>  #include <linux/lockdep.h>
>>  #include <linux/nmi.h>
>>  #include <linux/psi.h>
>> +#include <linux/page_reporting.h>
>>
>>  #include <asm/sections.h>
>>  #include <asm/tlbflush.h>
>> @@ -903,7 +904,7 @@ compaction_capture(struct capture_control *capc, struct page *page,
>>  static inline void __free_one_page(struct page *page,
>>                 unsigned long pfn,
>>                 struct zone *zone, unsigned int order,
>> -               int migratetype)
>> +               int migratetype, bool needs_reporting)
>>  {
>>         unsigned long combined_pfn;
>>         unsigned long uninitialized_var(buddy_pfn);
>> @@ -1006,7 +1007,8 @@ static inline void __free_one_page(struct page *page,
>>                                 migratetype);
>>         else
>>                 add_to_free_area(page, &zone->free_area[order], migratetype);
>> -
>> +       if (needs_reporting)
>> +               page_reporting_enqueue(page, order);
>>  }
>>
>>  /*
>> @@ -1317,7 +1319,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>>                 if (unlikely(isolated_pageblocks))
>>                         mt = get_pageblock_migratetype(page);
>>
>> -               __free_one_page(page, page_to_pfn(page), zone, 0, mt);
>> +               __free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
>>                 trace_mm_page_pcpu_drain(page, 0, mt);
>>         }
>>         spin_unlock(&zone->lock);
>> @@ -1326,14 +1328,14 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>>  static void free_one_page(struct zone *zone,
>>                                 struct page *page, unsigned long pfn,
>>                                 unsigned int order,
>> -                               int migratetype)
>> +                               int migratetype, bool needs_reporting)
>>  {
>>         spin_lock(&zone->lock);
>>         if (unlikely(has_isolate_pageblock(zone) ||
>>                 is_migrate_isolate(migratetype))) {
>>                 migratetype = get_pfnblock_migratetype(page, pfn);
>>         }
>> -       __free_one_page(page, pfn, zone, order, migratetype);
>> +       __free_one_page(page, pfn, zone, order, migratetype, needs_reporting);
>>         spin_unlock(&zone->lock);
>>  }
>>
>> @@ -1423,7 +1425,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>>         migratetype = get_pfnblock_migratetype(page, pfn);
>>         local_irq_save(flags);
>>         __count_vm_events(PGFREE, 1 << order);
>> -       free_one_page(page_zone(page), page, pfn, order, migratetype);
>> +       free_one_page(page_zone(page), page, pfn, order, migratetype, true);
>>         local_irq_restore(flags);
>>  }
>>
>> @@ -2197,6 +2199,32 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>>         return NULL;
>>  }
>>
>> +#ifdef CONFIG_PAGE_REPORTING
>> +/**
>> + * return_isolated_page - returns a reported page back to the buddy.
>> + * @zone: zone from where the page was isolated.
>> + * @page: page which will be returned.
>> + */
>> +void __return_isolated_page(struct zone *zone, struct page *page)
>> +{
>> +       unsigned int order, mt;
>> +       unsigned long pfn;
>> +
>> +       /* zone lock should be held when this function is called */
>> +       lockdep_assert_held(&zone->lock);
>> +
>> +       mt = get_pageblock_migratetype(page);
>> +       pfn = page_to_pfn(page);
>> +
>> +       if (unlikely(has_isolate_pageblock(zone) || is_migrate_isolate(mt)))
>> +               mt = get_pfnblock_migratetype(page, pfn);
>> +
>> +       order = page_private(page);
>> +       set_page_private(page, 0);
>> +
>> +       __free_one_page(page, pfn, zone, order, mt, false);
>> +}
>> +#endif /* CONFIG_PAGE_REPORTING */
>>
>>  /*
>>   * This array describes the order lists are fallen back to when
>> @@ -3041,7 +3069,7 @@ static void free_unref_page_commit(struct page *page, unsigned long pfn)
>>          */
>>         if (migratetype >= MIGRATE_PCPTYPES) {
>>                 if (unlikely(is_migrate_isolate(migratetype))) {
>> -                       free_one_page(zone, page, pfn, 0, migratetype);
>> +                       free_one_page(zone, page, pfn, 0, migratetype, true);
>>                         return;
>>                 }
>>                 migratetype = MIGRATE_MOVABLE;
>> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
>> new file mode 100644
>> index 000000000000..4ee2c172cd9a
>> --- /dev/null
>> +++ b/mm/page_reporting.c
>> @@ -0,0 +1,332 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Page reporting core infrastructure to enable a VM to report free pages to its
>> + * hypervisor.
>> + *
>> + * Copyright Red Hat, Inc. 2019
>> + *
>> + * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
>> + */
>> +
>> +#include <linux/mm.h>
>> +#include <linux/slab.h>
>> +#include <linux/page_reporting.h>
>> +#include <linux/scatterlist.h>
>> +#include "internal.h"
>> +
>> +static struct page_reporting_config __rcu *page_reporting_conf __read_mostly;
>> +static DEFINE_MUTEX(page_reporting_mutex);
>> +
>> +static inline unsigned long pfn_to_bit(struct page *page, struct zone *zone)
>> +{
>> +       unsigned long bitnr;
>> +
>> +       bitnr = (page_to_pfn(page) - zone->base_pfn) >>
>> +               PAGE_REPORTING_MIN_ORDER;
>> +
>> +       return bitnr;
>> +}
>> +
>> +static void return_isolated_page(struct zone *zone,
>> +                                struct page_reporting_config *phconf)
>> +{
>> +       struct scatterlist *sg = phconf->sg;
>> +
>> +       spin_lock(&zone->lock);
>> +       do {
>> +               __return_isolated_page(zone, sg_page(sg));
>> +       } while (!sg_is_last(sg++));
>> +       spin_unlock(&zone->lock);
>> +}
>> +
>> +static void bitmap_set_bit(struct page *page, struct zone *zone)
>> +{
>> +       unsigned long bitnr = 0;
>> +
>> +       /* zone lock should be held when this function is called */
>> +       lockdep_assert_held(&zone->lock);
>> +
> So why does the zone lock need to be held? What could you possibly
> race against? If nothing else it might make more sense to look at
> moving the bitmap, base, end, and length values into one RCU
> allocation structure so that you could do without the requirement of
> the zone lock to manipulate the bitmap.


Makes sense to me.


>> +       bitnr = pfn_to_bit(page, zone);
>> +       /* set bit if it is not already set and is a valid bit */
>> +       if (zone->bitmap && bitnr < zone->nbits &&
>> +           !test_and_set_bit(bitnr, zone->bitmap))
>> +               atomic_inc(&zone->free_pages);
>> +}
>> +
>> +static int process_free_page(struct page *page,
>> +                            struct page_reporting_config *phconf, int count)
>> +{
>> +       int mt, order, ret = 0;
>> +
>> +       mt = get_pageblock_migratetype(page);
>> +       order = page_private(page);
>> +       ret = __isolate_free_page(page, order);
>> +
>> +       if (ret) {
>> +               /*
>> +                * Preserving order and migratetype for reuse while
>> +                * releasing the pages back to the buddy.
>> +                */
>> +               set_pageblock_migratetype(page, mt);
>> +               set_page_private(page, order);
>> +
>> +               sg_set_page(&phconf->sg[count++], page,
>> +                           PAGE_SIZE << order, 0);
>> +       }
>> +
>> +       return count;
>> +}
>> +
>> +/**
>> + * scan_zone_bitmap - scans the bitmap for the requested zone.
>> + * @phconf: page reporting configuration object initialized by the backend.
>> + * @zone: zone for which page reporting is requested.
>> + *
>> + * For every page marked in the bitmap it checks if it is still free if so it
>> + * isolates and adds them to a scatterlist. As soon as the number of isolated
>> + * pages reach the threshold set by the backend, they are reported to the
>> + * hypervisor by the backend. Once the hypervisor responds after processing
>> + * they are returned back to the buddy for reuse.
>> + */
>> +static void scan_zone_bitmap(struct page_reporting_config *phconf,
>> +                            struct zone *zone)
>> +{
>> +       unsigned long setbit;
>> +       struct page *page;
>> +       int count = 0;
>> +
>> +       sg_init_table(phconf->sg, phconf->max_pages);
>> +
>> +       for_each_set_bit(setbit, zone->bitmap, zone->nbits) {
>> +               /* Process only if the page is still online */
>> +               page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
>> +                                         zone->base_pfn);
>> +               if (!page)
>> +                       continue;
>> +
> Shouldn't you be clearing the bit and dropping the reference to
> free_pages before you move on to the next bit? Otherwise you are going
> to be stuck with those aren't you?


+1. Thanks for pointing this out.


>> +               spin_lock(&zone->lock);
>> +
>> +               /* Ensure page is still free and can be processed */
>> +               if (PageBuddy(page) && page_private(page) >=
>> +                   PAGE_REPORTING_MIN_ORDER)
>> +                       count = process_free_page(page, phconf, count);
>> +
>> +               spin_unlock(&zone->lock);
> So I kind of wonder just how much overhead you are taking for bouncing
> the zone lock once per page here. Especially since it can result in
> you not actually making any progress since the page may have already
> been reallocated.


Any suggestion about how can I see the overhead involved here?


>> +               /* Page has been processed, adjust its bit and zone counter */
>> +               clear_bit(setbit, zone->bitmap);
>> +               atomic_dec(&zone->free_pages);
> So earlier you were setting this bit and required that the zone->lock
> be held while doing so. Here you are clearing it without any
> zone->lock being held.


I should have held the zone->lock here while clearing the bit.


>
>> +               if (count == phconf->max_pages) {
>> +                       /* Report isolated pages to the hypervisor */
>> +                       phconf->report(phconf, count);
>> +
>> +                       /* Return processed pages back to the buddy */
>> +                       return_isolated_page(zone, phconf);
>> +
>> +                       /* Reset for next reporting */
>> +                       sg_init_table(phconf->sg, phconf->max_pages);
>> +                       count = 0;
>> +               }
>> +       }
>> +       /*
>> +        * If the number of isolated pages does not meet the max_pages
>> +        * threshold, we would still prefer to report them as we have already
>> +        * isolated them.
>> +        */
>> +       if (count) {
>> +               sg_mark_end(&phconf->sg[count - 1]);
>> +               phconf->report(phconf, count);
>> +
>> +               return_isolated_page(zone, phconf);
>> +       }
>> +}
>> +
>> +/**
>> + * page_reporting_wq - checks the number of free_pages in all the zones and
>> + * invokes a request to scan the respective bitmap if free_pages reaches or
>> + * exceeds the threshold specified by the backend.
>> + */
>> +static void page_reporting_wq(struct work_struct *work)
>> +{
>> +       struct page_reporting_config *phconf =
>> +               container_of(work, struct page_reporting_config,
>> +                            reporting_work);
>> +       struct zone *zone;
>> +
>> +       for_each_populated_zone(zone) {
>> +               if (atomic_read(&zone->free_pages) >= phconf->max_pages)
>> +                       scan_zone_bitmap(phconf, zone);
>> +       }
>> +       /*
>> +        * We have processed all the zones, we can process new page reporting
>> +        * request now.
>> +        */
>> +       atomic_set(&phconf->refcnt, 0);
> It doesn't make sense to reset the refcnt once you have made a single pass.
>
>> +}
>> +
>> +/**
>> + * __page_reporting_enqueue - tracks the freed page in the respective zone's
>> + * bitmap and enqueues a new page reporting job to the workqueue if possible.
>> + */
>> +void __page_reporting_enqueue(struct page *page)
>> +{
>> +       struct page_reporting_config *phconf;
>> +       struct zone *zone;
>> +
>> +       rcu_read_lock();
>> +       /*
>> +        * We should not process this page if either page reporting is not
>> +        * yet completely enabled or it has been disabled by the backend.
>> +        */
>> +       phconf = rcu_dereference(page_reporting_conf);
>> +       if (!phconf)
>> +               return;
>> +
>> +       zone = page_zone(page);
>> +       bitmap_set_bit(page, zone);
>> +
>> +       /*
>> +        * We should not enqueue a job if a previously enqueued reporting work
>> +        * is in progress or we don't have enough free pages in the zone.
>> +        */
>> +       if (atomic_read(&zone->free_pages) >= phconf->max_pages &&
>> +           !atomic_cmpxchg(&phconf->refcnt, 0, 1))
> This doesn't make any sense to me. Why are you only incrementing the
> refcount if it is zero? Combining this with the assignment above, this
> isn't really a refcnt. It is just an oversized bitflag.
>

The reason why I have this here is that at a time I only want a single request
to be en-queued.
Now, every time free_page threshold for any zone is met I am checking each zone
for possible reporting.

I think there are two change required here:
1. rename this flag.
2. use refcnt to actually track the usage of page_hinting_config object separately.

> Also I am pretty sure this results in the opportunity to miss pages
> because there is nothing to prevent you from possibly missing a ton of
> pages you could hint on if a large number of pages are pushed out all
> at once and then the system goes idle in terms of memory allocation
> and freeing.

I have failed to reproduce this kind of situation.
I have a test app which simply allocates large memory chunk, touches it and then
exits. In this case, I get most of the memory back.


>
>> +               schedule_work(&phconf->reporting_work);
>> +
>> +       rcu_read_unlock();
>> +}
>> +
>> +/**
>> + * zone_reporting_cleanup - resets the page reporting fields and free the
>> + * bitmap for all the initialized zones.
>> + */
>> +static void zone_reporting_cleanup(void)
>> +{
>> +       struct zone *zone;
>> +
>> +       for_each_populated_zone(zone) {
>> +               /*
>> +                * Bitmap may not be allocated for all the zones if the
>> +                * initialization fails before reaching to the last one.
>> +                */
>> +               if (!zone->bitmap)
>> +                       continue;
>> +               bitmap_free(zone->bitmap);
>> +               zone->bitmap = NULL;
>> +               atomic_set(&zone->free_pages, 0);
>> +       }
>> +}
>> +
>> +static int zone_bitmap_alloc(struct zone *zone)
>> +{
>> +       unsigned long bitmap_size, pages;
>> +
>> +       pages = zone->end_pfn - zone->base_pfn;
>> +       bitmap_size = (pages >> PAGE_REPORTING_MIN_ORDER) + 1;
>> +
>> +       if (!bitmap_size)
>> +               return 0;
>> +
>> +       zone->bitmap = bitmap_zalloc(bitmap_size, GFP_KERNEL);
>> +       if (!zone->bitmap)
>> +               return -ENOMEM;
>> +
>> +       zone->nbits = bitmap_size;
>> +
>> +       return 0;
>> +}
>> +
> So as per your comments in the cover page, the two functions above
> should also probably be plugged into the zone resizing logic somewhere
> so if a zone is resized the bitmap is adjusted.


I think the right way will be to have a common interface which could be called
here and in memory hotplug/unplug case.
Right now, in my prototype, I have a different functions which adjusts the size
of the bitmap based on the memory notifier action.


>
>> +/**
>> + * zone_reporting_init - For each zone initializes the page reporting fields
>> + * and allocates the respective bitmap.
>> + *
>> + * This function returns 0 on successful initialization, -ENOMEM otherwise.
>> + */
>> +static int zone_reporting_init(void)
>> +{
>> +       struct zone *zone;
>> +       int ret;
>> +
>> +       for_each_populated_zone(zone) {
>> +#ifdef CONFIG_ZONE_DEVICE
>> +               /* we can not report pages which are not in the buddy */
>> +               if (zone_idx(zone) == ZONE_DEVICE)
>> +                       continue;
>> +#endif
> I'm pretty sure this isn't needed since I don't think the ZONE_DEVICE
> zone will be considered "populated".


hmm, I was not aware of it. I will dig in more about it.


>
>> +               spin_lock(&zone->lock);
>> +               zone->base_pfn = zone->zone_start_pfn;
>> +               zone->end_pfn = zone_end_pfn(zone);
>> +               spin_unlock(&zone->lock);
>> +
>> +               ret = zone_bitmap_alloc(zone);
>> +               if (ret < 0) {
>> +                       zone_reporting_cleanup();
>> +                       return ret;
>> +               }
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +void page_reporting_disable(struct page_reporting_config *phconf)
>> +{
>> +       mutex_lock(&page_reporting_mutex);
>> +
>> +       if (rcu_access_pointer(page_reporting_conf) != phconf)
>> +               return;
>> +
>> +       RCU_INIT_POINTER(page_reporting_conf, NULL);
>> +       synchronize_rcu();
>> +
>> +       /* Cancel any pending reporting request */
>> +       cancel_work_sync(&phconf->reporting_work);
>> +
>> +       /* Free the scatterlist used for isolated pages */
>> +       kfree(phconf->sg);
>> +       phconf->sg = NULL;
>> +
>> +       /* Cleanup the bitmaps and old tracking data */
>> +       zone_reporting_cleanup();
>> +
>> +       mutex_unlock(&page_reporting_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(page_reporting_disable);
>> +
>> +int page_reporting_enable(struct page_reporting_config *phconf)
>> +{
>> +       int ret = 0;
>> +
>> +       mutex_lock(&page_reporting_mutex);
>> +
>> +       /* check if someone is already using page reporting*/
>> +       if (rcu_access_pointer(page_reporting_conf)) {
>> +               ret = -EBUSY;
>> +               goto out;
>> +       }
>> +
>> +       /* allocate scatterlist to hold isolated pages */
>> +       phconf->sg = kcalloc(phconf->max_pages, sizeof(*phconf->sg),
>> +                            GFP_KERNEL);
>> +       if (!phconf->sg) {
>> +               ret = -ENOMEM;
>> +               goto out;
>> +       }
>> +
>> +       /* initialize each zone's fields required for page reporting */
>> +       ret = zone_reporting_init();
>> +       if (ret < 0) {
>> +               kfree(phconf->sg);
>> +               goto out;
>> +       }
>> +
>> +       atomic_set(&phconf->refcnt, 0);
>> +       INIT_WORK(&phconf->reporting_work, page_reporting_wq);
>> +
>> +       /* assign the configuration object provided by the backend */
>> +       rcu_assign_pointer(page_reporting_conf, phconf);
>> +
>> +out:
>> +       mutex_unlock(&page_reporting_mutex);
>> +       return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(page_reporting_enable);
>> --
>> 2.21.0
>>
-- 
Thanks
Nitesh

