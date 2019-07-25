Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D904974967
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 10:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389878AbfGYIx1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 04:53:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388546AbfGYIx1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 04:53:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 13CFA3E2D7;
        Thu, 25 Jul 2019 08:53:26 +0000 (UTC)
Received: from [10.36.117.212] (ovpn-117-212.ams2.redhat.com [10.36.117.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8510C5DD94;
        Thu, 25 Jul 2019 08:53:14 +0000 (UTC)
Subject: Re: [PATCH v2 4/5] mm: Introduce Hinted pages
To:     Alexander Duyck <alexander.duyck@gmail.com>, nitesh@redhat.com,
        kvm@vger.kernel.org, mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, Matthew Wilcox <willy@infradead.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724170259.6685.18028.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <a9f52894-52df-cd0c-86ac-eea9fbe96e34@redhat.com>
Date:   Thu, 25 Jul 2019 10:53:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190724170259.6685.18028.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 25 Jul 2019 08:53:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.07.19 19:03, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> In order to pave the way for free page hinting in virtualized environments
> we will need a way to get pages out of the free lists and identify those
> pages after they have been returned. To accomplish this, this patch adds
> the concept of a Hinted Buddy, which is essentially meant to just be the
> Offline page type used in conjunction with the Buddy page type.
> 
> It adds a set of pointers we shall call "boundary" which represents the
> upper boundary between the unhinted and hinted pages. The general idea is
> that in order for a page to cross from one side of the boundary to the
> other it will need to go through the hinting process. Ultimately a
> free_list has been fully processed when the boundary has been moved from
> the tail all they way up to occupying the first entry in the list.
> 
> Doing this we should be able to make certain that we keep the hinted
> pages as one contiguous block in each free list. This will allow us to
> efficiently manipulate the free lists whenever we need to go in and start
> sending hints to the hypervisor that there are new pages that have been
> freed and are no longer in use.
> 
> An added advantage to this approach is that we should be reducing the
> overall memory footprint of the guest as it will be more likely to recycle
> warm pages versus trying to allocate the hinted pages that were likely
> evicted from the guest memory.
> 
> Since we will only be hinting one zone at a time we keep the boundary
> limited to being defined for just the zone we are currently placing hinted
> pages into. Doing this we can keep the number of additional pointers needed
> quite small. To flag that the boundaries are in place we use a single bit
> in the zone to indicate that hinting and the boundaries are active.
> 
> The determination of when to start hinting is based on the tracking of the
> number of free pages in a given area versus the number of hinted pages in
> that area. We keep track of the number of hinted pages per free_area in a
> separate zone specific area. We do this to avoid modifying the free_area
> structure as this can lead to false sharing for the highest order with the
> zone lock which leads to a noticeable performance degradation.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  include/linux/mmzone.h       |   40 +++++-
>  include/linux/page-flags.h   |    8 +
>  include/linux/page_hinting.h |  139 ++++++++++++++++++++
>  mm/Kconfig                   |    5 +
>  mm/Makefile                  |    1 
>  mm/memory_hotplug.c          |    1 
>  mm/page_alloc.c              |  136 ++++++++++++++++++-
>  mm/page_hinting.c            |  298 ++++++++++++++++++++++++++++++++++++++++++
>  8 files changed, 620 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/page_hinting.h
>  create mode 100644 mm/page_hinting.c
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index f0c68b6b6154..42bdebb20484 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -460,6 +460,14 @@ struct zone {
>  	seqlock_t		span_seqlock;
>  #endif
>  
> +#ifdef CONFIG_PAGE_HINTING
> +	/*
> +	 * Pointer to hinted page tracking statistics array. The size of
> +	 * the array is MAX_ORDER - PAGE_HINTING_MIN_ORDER. NULL when
> +	 * page hinting is not present.
> +	 */
> +	unsigned long		*hinted_pages;
> +#endif
>  	int initialized;
>  
>  	/* Write-intensive fields used from the page allocator */
> @@ -535,6 +543,14 @@ enum zone_flags {
>  	ZONE_BOOSTED_WATERMARK,		/* zone recently boosted watermarks.
>  					 * Cleared when kswapd is woken.
>  					 */
> +	ZONE_PAGE_HINTING_REQUESTED,	/* zone enabled page hinting and has
> +					 * requested flushing the data out of
> +					 * higher order pages.
> +					 */
> +	ZONE_PAGE_HINTING_ACTIVE,	/* zone enabled page hinting and is
> +					 * activly flushing the data out of
> +					 * higher order pages.
> +					 */
>  };
>  
>  static inline unsigned long zone_managed_pages(struct zone *zone)
> @@ -755,6 +771,8 @@ static inline bool pgdat_is_empty(pg_data_t *pgdat)
>  	return !pgdat->node_start_pfn && !pgdat->node_spanned_pages;
>  }
>  
> +#include <linux/page_hinting.h>
> +
>  /* Used for pages not on another list */
>  static inline void add_to_free_list(struct page *page, struct zone *zone,
>  				    unsigned int order, int migratetype)
> @@ -769,10 +787,16 @@ static inline void add_to_free_list(struct page *page, struct zone *zone,
>  static inline void add_to_free_list_tail(struct page *page, struct zone *zone,
>  					 unsigned int order, int migratetype)
>  {
> -	struct free_area *area = &zone->free_area[order];
> +	struct list_head *tail = get_unhinted_tail(zone, order, migratetype);
>  
> -	list_add_tail(&page->lru, &area->free_list[migratetype]);
> -	area->nr_free++;
> +	/*
> +	 * To prevent the unhinted pages from being interleaved with the
> +	 * hinted ones while we are actively processing pages we will use
> +	 * the head of the hinted pages to determine the tail of the free
> +	 * list.
> +	 */
> +	list_add_tail(&page->lru, tail);
> +	zone->free_area[order].nr_free++;
>  }
>  
>  /* Used for pages which are on another list */
> @@ -781,12 +805,22 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
>  {
>  	struct free_area *area = &zone->free_area[order];
>  
> +	/*
> +	 * Clear Hinted flag, if present, to avoid placing hinted pages
> +	 * at the top of the free_list. It is cheaper to just process this
> +	 * page again, then have to walk around a page that is already hinted.
> +	 */
> +	clear_page_hinted(page, zone);
> +
>  	list_move(&page->lru, &area->free_list[migratetype]);
>  }
>  
>  static inline void del_page_from_free_list(struct page *page, struct zone *zone,
>  					   unsigned int order)
>  {
> +	/* Clear Hinted flag, if present, before clearing the Buddy flag */
> +	clear_page_hinted(page, zone);
> +
>  	list_del(&page->lru);
>  	__ClearPageBuddy(page);
>  	set_page_private(page, 0);
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index b848517da64c..b753dbf673cb 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -745,6 +745,14 @@ static inline int page_has_type(struct page *page)
>  PAGE_TYPE_OPS(Offline, offline)
>  
>  /*
> + * PageHinted() is an alias for Offline, however it is not meant to be an
> + * exclusive value. It should be combined with PageBuddy() when seen as it
> + * is meant to indicate that the page has been scrubbed while waiting in
> + * the buddy system.
> + */
> +PAGE_TYPE_OPS(Hinted, offline)


CCing Matthew

I am still not sure if I like the idea of having two page types at a time.

1. Once we run out of page type bits (which can happen easily looking at
it getting more and more user - e.g., maybe for vmmap pages soon), we
might want to convert again back to a value-based, not bit-based type
detection. This will certainly make this switch harder.

2. It will complicate the kexec/kdump handling. I assume it can be fixed
some way - e.g., making the elf interface aware of the exact notion of
page type bits compared to mapcount values we have right now (e.g.,
PAGE_BUDDY_MAPCOUNT_VALUE). Not addressed in this series yet.


Can't we reuse one of the traditional page flags for that, not used
along with buddy pages? E.g., PG_dirty: Pages that were not hinted yet
are dirty.

Matthew, what's your take?

-- 

Thanks,

David / dhildenb
