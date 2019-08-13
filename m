Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 160CD8B1FB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfHMIHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:07:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfHMIHj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:07:39 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 945D930A699B;
        Tue, 13 Aug 2019 08:07:38 +0000 (UTC)
Received: from [10.36.117.2] (ovpn-117-2.ams2.redhat.com [10.36.117.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4830786BB4;
        Tue, 13 Aug 2019 08:07:12 +0000 (UTC)
Subject: Re: [PATCH v5 4/6] mm: Introduce Reported pages
To:     Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        virtio-dev@lists.oasis-open.org, osalvador@suse.de
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
 <20190812213344.22097.86213.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <222cbe8f-90c5-5437-4a77-9926cacc398f@redhat.com>
Date:   Tue, 13 Aug 2019 10:07:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190812213344.22097.86213.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 13 Aug 2019 08:07:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.08.19 23:33, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to pave the way for free page reporting in virtualized
> environments we will need a way to get pages out of the free lists and
> identify those pages after they have been returned. To accomplish this,
> this patch adds the concept of a Reported Buddy, which is essentially
> meant to just be the Uptodate flag used in conjunction with the Buddy
> page type.
> 
> It adds a set of pointers we shall call "boundary" which represents the
> upper boundary between the unreported and reported pages. The general idea
> is that in order for a page to cross from one side of the boundary to the
> other it will need to go through the reporting process. Ultimately a
> free_list has been fully processed when the boundary has been moved from
> the tail all they way up to occupying the first entry in the list.
> 
> Doing this we should be able to make certain that we keep the reported
> pages as one contiguous block in each free list. This will allow us to
> efficiently manipulate the free lists whenever we need to go in and start
> sending reports to the hypervisor that there are new pages that have been
> freed and are no longer in use.
> 
> An added advantage to this approach is that we should be reducing the
> overall memory footprint of the guest as it will be more likely to recycle
> warm pages versus trying to allocate the reported pages that were likely
> evicted from the guest memory.
> 
> Since we will only be reporting one zone at a time we keep the boundary
> limited to being defined for just the zone we are currently reporting pages
> from. Doing this we can keep the number of additional pointers needed quite
> small. To flag that the boundaries are in place we use a single bit
> in the zone to indicate that reporting and the boundaries are active.
> 
> The determination of when to start reporting is based on the tracking of
> the number of free pages in a given area versus the number of reported
> pages in that area. We keep track of the number of reported pages per
> free_area in a separate zone specific area. We do this to avoid modifying
> the free_area structure as this can lead to false sharing for the highest
> order with the zone lock which leads to a noticeable performance
> degradation.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  include/linux/mmzone.h         |   40 +++++
>  include/linux/page-flags.h     |   11 +
>  include/linux/page_reporting.h |  138 ++++++++++++++++++
>  mm/Kconfig                     |    5 +
>  mm/Makefile                    |    1 
>  mm/memory_hotplug.c            |    1 
>  mm/page_alloc.c                |  136 +++++++++++++++++-
>  mm/page_reporting.c            |  308 ++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 632 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/page_reporting.h
>  create mode 100644 mm/page_reporting.c
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 2f2b6f968ed3..b8ed926552b1 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -462,6 +462,14 @@ struct zone {
>  	seqlock_t		span_seqlock;
>  #endif
>  
> +#ifdef CONFIG_PAGE_REPORTING
> +	/*
> +	 * Pointer to reported page tracking statistics array. The size of
> +	 * the array is MAX_ORDER - PAGE_REPORTING_MIN_ORDER. NULL when
> +	 * unused page reporting is not present.
> +	 */
> +	unsigned long		*reported_pages;
> +#endif
>  	int initialized;
>  
>  	/* Write-intensive fields used from the page allocator */
> @@ -537,6 +545,14 @@ enum zone_flags {
>  	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
>  					 * Cleared when kswapd is woken.
>  					 */
> +	ZONE_PAGE_REPORTING_REQUESTED,	/* zone enabled page reporting and has
> +					 * requested flushing the data out of
> +					 * higher order pages.
> +					 */
> +	ZONE_PAGE_REPORTING_ACTIVE,	/* zone enabled page reporting and is
> +					 * activly flushing the data out of
> +					 * higher order pages.
> +					 */
>  };
>  
>  static inline unsigned long zone_managed_pages(struct zone *zone)
> @@ -757,6 +773,8 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
>  	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
>  }
>  
> +#include <linux/page_reporting.h>
> +
>  /* Used for pages not on another list */
>  static inline void add_to_free_list(struct page *page, struct zone *zone,
>  				    unsigned int order, int migratetype)
> @@ -771,10 +789,16 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
>  static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
>  					 unsigned int order, int migratetype)
>  {
> -	struct free_area *area = &zone->free_area[order];
> +	struct list_head *tail = get_unreported_tail(zone, order, migratetype);
>  
> -	list_add_tail(&page->lru, &area->free_list[migratetype]);
> -	area->nr_free++;
> +	/*
> +	 * To prevent the unreported pages from being interleaved with the
> +	 * reported ones while we are actively processing pages we will use
> +	 * the head of the reported pages to determine the tail of the free
> +	 * list.
> +	 */
> +	list_add_tail(&page->lru, tail);
> +	zone->free_area[order].nr_free++;
>  }
>  
>  /* Used for pages which are on another list */
> @@ -783,12 +807,22 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
>  {
>  	struct free_area *area = &zone->free_area[order];
>  
> +	/*
> +	 * Clear Hinted flag, if present, to avoid placing reported pages
> +	 * at the top of the free_list. It is cheaper to just process this
> +	 * page again than to walk around a page that is already reported.
> +	 */
> +	clear_page_reported(page, zone);
> +
>  	list_move(&page->lru, &area->free_list[migratetype]);
>  }
>  
>  static inline void del_page_from_free_list(struct page *page, struct zone *zone,
>  					   unsigned int order)
>  {
> +	/* Clear Reported flag, if present, before resetting page type */
> +	clear_page_reported(page, zone);
> +
>  	list_del(&page->lru);
>  	__ClearPageBuddy(page);
>  	set_page_private(page, 0);
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index f91cb8898ff0..759a3b3956f2 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -163,6 +163,9 @@ enum pageflags {
>  
>  	/* non-lru isolated movable page */
>  	PG_isolated = PG_reclaim,
> +
> +	/* Buddy pages. Used to track which pages have been reported */
> +	PG_reported = PG_uptodate,
>  };
>  
>  #ifndef __GENERATING_BOUNDS_H
> @@ -432,6 +435,14 @@ static inline bool set_hwpoison_free_buddy_page(struct page *page)
>  #endif
>  
>  /*
> + * PageReported() is used to track reported free pages within the Buddy
> + * allocator. We can use the non-atomic version of the test and set
> + * operations as both should be shielded with the zone lock to prevent
> + * any possible races on the setting or clearing of the bit.
> + */
> +__PAGEFLAG(Reported, reported, PF_NO_COMPOUND)
> +
> +/*
>   * On an anonymous page mapped into a user virtual memory area,
>   * page->mapping points to its anon_vma, not to a struct address_space;
>   * with the PAGE_MAPPING_ANON bit set to distinguish it.  See rmap.h.
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> new file mode 100644
> index 000000000000..498bde6ea764
> --- /dev/null
> +++ b/include/linux/page_reporting.h
> @@ -0,0 +1,138 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PAGE_REPORTING_H
> +#define _LINUX_PAGE_REPORTING_H
> +
> +#include <linux/mmzone.h>
> +#include <linux/jump_label.h>
> +#include <linux/pageblock-flags.h>
> +#include <asm/pgtable_types.h>
> +
> +#define PAGE_REPORTING_MIN_ORDER	pageblock_order
> +#define PAGE_REPORTING_HWM		32
> +
> +#ifdef CONFIG_PAGE_REPORTING
> +struct page_reporting_dev_info {
> +	/* function that alters pages to make them "reported" */
> +	void (*report)(struct page_reporting_dev_info *phdev,
> +		       unsigned int nents);
> +
> +	/* scatterlist containing pages to be processed */
> +	struct scatterlist *sg;
> +
> +	/*
> +	 * Upper limit on the number of pages that the react function
> +	 * expects to be placed into the batch list to be processed.
> +	 */
> +	unsigned long capacity;
> +
> +	/* work struct for processing reports */
> +	struct delayed_work work;
> +
> +	/*
> +	 * The number of zones requesting reporting, plus one additional if
> +	 * processing thread is active.
> +	 */
> +	atomic_t refcnt;
> +};
> +
> +extern struct static_key page_reporting_notify_enabled;
> +
> +/* Boundary functions */
> +struct list_head *__page_reporting_get_boundary(unsigned int order,
> +						int migratetype);
> +void page_reporting_del_from_boundary(struct page *page, struct zone *zone);
> +void page_reporting_add_to_boundary(struct page *page, struct zone *zone,
> +				    int migratetype);
> +
> +/* Hinted page accessors, defined in page_alloc.c */
> +struct page *get_unreported_page(struct zone *zone, unsigned int order,
> +				 int migratetype);
> +void put_reported_page(struct zone *zone, struct page *page);
> +
> +void __page_reporting_request(struct zone *zone);
> +void __page_reporting_free_stats(struct zone *zone);
> +
> +/* Tear-down and bring-up for page reporting devices */
> +void page_reporting_shutdown(struct page_reporting_dev_info *phdev);
> +int page_reporting_startup(struct page_reporting_dev_info *phdev);
> +#endif /* CONFIG_PAGE_REPORTING */
> +
> +static inline struct list_head *
> +get_unreported_tail(struct zone *zone, unsigned int order, int migratetype)
> +{
> +#ifdef CONFIG_PAGE_REPORTING
> +	if (order >= PAGE_REPORTING_MIN_ORDER &&
> +	    test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> +		return __page_reporting_get_boundary(order, migratetype);
> +#endif
> +	return &zone->free_area[order].free_list[migratetype];
> +}
> +
> +static inline void clear_page_reported(struct page *page,
> +				     struct zone *zone)
> +{
> +#ifdef CONFIG_PAGE_REPORTING
> +	if (likely(!PageReported(page)))
> +		return;
> +
> +	/* push boundary back if we removed the upper boundary */
> +	if (test_bit(ZONE_PAGE_REPORTING_ACTIVE, &zone->flags))
> +		page_reporting_del_from_boundary(page, zone);
> +
> +	__ClearPageReported(page);
> +
> +	/* page_private will contain the page order, so just use it directly */
> +	zone->reported_pages[page_private(page) - PAGE_REPORTING_MIN_ORDER]--;
> +#endif
> +}
> +
> +/* Free reported_pages and reset reported page tracking count to 0 */
> +static inline void page_reporting_reset(struct zone *zone)
> +{
> +#ifdef CONFIG_PAGE_REPORTING
> +	if (zone->reported_pages)
> +		__page_reporting_free_stats(zone);
> +#endif
> +}
> +
> +/**
> + * page_reporting_notify_free - Free page notification to start page processing
> + * @zone: Pointer to current zone of last page processed
> + * @order: Order of last page added to zone
> + *
> + * This function is meant to act as a screener for __page_reporting_request
> + * which will determine if a give zone has crossed over the high-water mark
> + * that will justify us beginning page treatment. If we have crossed that
> + * threshold then it will start the process of pulling some pages and
> + * placing them in the batch list for treatment.
> + */
> +static inline void page_reporting_notify_free(struct zone *zone, int order)
> +{
> +#ifdef CONFIG_PAGE_REPORTING
> +	unsigned long nr_reported;
> +
> +	/* Called from hot path in __free_one_page() */
> +	if (!static_key_false(&page_reporting_notify_enabled))
> +		return;
> +
> +	/* Limit notifications only to higher order pages */
> +	if (order < PAGE_REPORTING_MIN_ORDER)
> +		return;
> +
> +	/* Do not bother with tests if we have already requested reporting */
> +	if (test_bit(ZONE_PAGE_REPORTING_REQUESTED, &zone->flags))
> +		return;
> +
> +	/* If reported_pages is not populated, assume 0 */
> +	nr_reported = zone->reported_pages ?
> +		    zone->reported_pages[order - PAGE_REPORTING_MIN_ORDER] : 0;
> +
> +	/* Only request it if we have enough to begin the page reporting */
> +	if (zone->free_area[order].nr_free < nr_reported + PAGE_REPORTING_HWM)
> +		return;
> +
> +	/* This is slow, but should be called very rarely */
> +	__page_reporting_request(zone);
> +#endif
> +}
> +#endif /*_LINUX_PAGE_REPORTING_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 1c9698509273..daa8c45e2af4 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -237,6 +237,11 @@ config COMPACTION
>            linux-mm@kvack.org.
>  
>  #
> +# support for unused page reporting
> +config PAGE_REPORTING
> +	bool
> +
> +#
>  # support for page migration
>  #
>  config MIGRATION
> diff --git a/mm/Makefile b/mm/Makefile
> index d0b295c3b764..1e17ba0ed2f0 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -105,3 +105,4 @@ obj-$(CONFIG_PERCPU_STATS) += percpu-stats.o
>  obj-$(CONFIG_ZONE_DEVICE) += memremap.o
>  obj-$(CONFIG_HMM_MIRROR) += hmm.o
>  obj-$(CONFIG_MEMFD_CREATE) += memfd.o
> +obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 5b8811945bbb..bd40beac293b 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1612,6 +1612,7 @@ static int __ref __offline_pages(unsigned long start_pfn,
>  	if (!populated_zone(zone)) {
>  		zone_pcp_reset(zone);
>  		build_all_zonelists(NULL);
> +		page_reporting_reset(zone);
>  	} else
>  		zone_pcp_update(zone);
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4b5812c3800e..d0d3fb12ba54 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -68,6 +68,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/nmi.h>
>  #include <linux/psi.h>
> +#include <linux/page_reporting.h>
>  
>  #include <asm/sections.h>
>  #include <asm/tlbflush.h>
> @@ -915,7 +916,7 @@ static inline struct capture_control *task_capc(struct zone *zone)
>  static inline void __free_one_page(struct page *page,
>  		unsigned long pfn,
>  		struct zone *zone, unsigned int order,
> -		int migratetype)
> +		int migratetype, bool reported)
>  {
>  	struct capture_control *capc = task_capc(zone);
>  	unsigned long uninitialized_var(buddy_pfn);
> @@ -990,11 +991,20 @@ static inline void __free_one_page(struct page *page,
>  done_merging:
>  	set_page_order(page, order);
>  
> -	if (is_shuffle_order(order) ? shuffle_add_to_tail() :
> -	    buddy_merge_likely(pfn, buddy_pfn, page, order))
> +	if (reported ||
> +	    (is_shuffle_order(order) ? shuffle_add_to_tail() :
> +	     buddy_merge_likely(pfn, buddy_pfn, page, order)))
>  		add_to_free_list_tail(page, zone, order, migratetype);
>  	else
>  		add_to_free_list(page, zone, order, migratetype);
> +
> +	/*
> +	 * No need to notify on a reported page as the total count of
> +	 * unreported pages will not have increased since we have essentially
> +	 * merged the reported page with one or more unreported pages.
> +	 */
> +	if (!reported)
> +		page_reporting_notify_free(zone, order);
>  }
>  
>  /*
> @@ -1305,7 +1315,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  		if (unlikely(isolated_pageblocks))
>  			mt = get_pageblock_migratetype(page);
>  
> -		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
> +		__free_one_page(page, page_to_pfn(page), zone, 0, mt, false);
>  		trace_mm_page_pcpu_drain(page, 0, mt);
>  	}
>  	spin_unlock(&zone->lock);
> @@ -1321,7 +1331,7 @@ static void free_one_page(struct zone *zone,
>  		is_migrate_isolate(migratetype))) {
>  		migratetype = get_pfnblock_migratetype(page, pfn);
>  	}
> -	__free_one_page(page, pfn, zone, order, migratetype);
> +	__free_one_page(page, pfn, zone, order, migratetype, false);
>  	spin_unlock(&zone->lock);
>  }
>  
> @@ -2183,6 +2193,122 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
>  	return NULL;
>  }
>  
> +#ifdef CONFIG_PAGE_REPORTING
> +/**
> + * get_unreported_page - Pull an unreported page from the free_list
> + * @zone: Zone to draw pages from
> + * @order: Order to draw pages from
> + * @mt: Migratetype to draw pages from
> + *
> + * This function will obtain a page from the free list. It will start by
> + * attempting to pull from the tail of the free list and if that is already
> + * reported on it will instead pull the head if that is unreported.
> + *
> + * The page will have the migrate type and order stored in the page
> + * metadata. While being processed the page will not be avaialble for
> + * allocation.
> + *
> + * Return: page pointer if raw page found, otherwise NULL
> + */
> +struct page *get_unreported_page(struct zone *zone, unsigned int order, int mt)
> +{
> +	struct list_head *tail = get_unreported_tail(zone, order, mt);
> +	struct free_area *area = &(zone->free_area[order]);
> +	struct list_head *list = &area->free_list[mt];
> +	struct page *page;
> +
> +	/* zone lock should be held when this function is called */
> +	lockdep_assert_held(&zone->lock);
> +
> +	/* Find a page of the appropriate size in the preferred list */
> +	page = list_last_entry(tail, struct page, lru);
> +	list_for_each_entry_from_reverse(page, list, lru) {
> +		/* If we entered this loop then the "raw" list isn't empty */
> +
> +		/* If the page is reported try the head of the list */
> +		if (PageReported(page)) {
> +			page = list_first_entry(list, struct page, lru);
> +
> +			/*
> +			 * If both the head and tail are reported then reset
> +			 * the boundary so that we read as an empty list
> +			 * next time and bail out.
> +			 */
> +			if (PageReported(page)) {
> +				page_reporting_add_to_boundary(page, zone, mt);
> +				break;
> +			}
> +		}
> +
> +		del_page_from_free_list(page, zone, order);
> +
> +		/* record migratetype and order within page */
> +		set_pcppage_migratetype(page, mt);
> +		set_page_private(page, order);

Can you elaborate why you (similar to Nitesh) have to save/restore the
migratetype? I can't yet follow why that is necessary. You could simply
set it to MOVABLE (like e.g., undo_isolate_page_range() would do via
alloc_contig_range()). If a pageblock is completely free, it might even
make sense to set it to MOVABLE.

(mainly wondering if this is required here and what the rational is)


Now a theoretical issue:

You are allocating pages from all zones, including the MOVABLE zone. The
pages are currently unmovable (however, only temporarily allocated).

del_page_from_free_area() will clear PG_buddy, and leave the refcount of
the page set to zero (!). has_unmovable_pages() will skip any pages
either on the MOVABLE zone or with a refcount of zero. So all pages that
are being reported are detected as movable. The isolation of allocated
pages will work - which is not bad, but I wonder what the implications are.

As far as I can follow, alloc_contig_range() ->
__alloc_contig_migrate_range() -> isolate_migratepages_range() ->
isolate_migratepages_block() will choke on these pages ((!PageLRU(page)
-> !__PageMovable(page) -> fail), essentially making
alloc_contig_range() range fail. Same could apply to offline_pages().

I would have thought that there has to be something like a
reported_pages_drain_all(), that waits until all reports are over (or
even signals to the hypervisor to abort reporting). As the pages are
isolated, they won't be allocated for reporting again.

I have not yet understood completely the way all the details work. I am
currently looking into using alloc_contig_range() in a different
context, which would co-exist with free-page-reporting.
-- 

Thanks,

David / dhildenb
