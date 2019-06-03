Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AE633965
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 21:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbfFCT5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 15:57:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfFCT5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 15:57:31 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 09AEC7EBB1;
        Mon,  3 Jun 2019 19:57:31 +0000 (UTC)
Received: from [10.36.116.107] (ovpn-116-107.ams2.redhat.com [10.36.116.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5514019C69;
        Mon,  3 Jun 2019 19:57:16 +0000 (UTC)
Subject: Re: [RFC][Patch v10 1/2] mm: page_hinting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        pbonzini@redhat.com, lcapitulino@redhat.com, pagupta@redhat.com,
        wei.w.wang@intel.com, yang.zhang.wz@gmail.com, riel@surriel.com,
        mst@redhat.com, dodgen@google.com, konrad.wilk@oracle.com,
        dhildenb@redhat.com, aarcange@redhat.com, alexander.duyck@gmail.com
References: <20190603170306.49099-1-nitesh@redhat.com>
 <20190603170306.49099-2-nitesh@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <c5aa99d5-8cd0-44cf-9d61-75c8d3b019aa@redhat.com>
Date:   Mon, 3 Jun 2019 21:57:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603170306.49099-2-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 03 Jun 2019 19:57:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.06.19 19:03, Nitesh Narayan Lal wrote:
> This patch introduces the core infrastructure for free page hinting in
> virtual environments. It enables the kernel to track the free pages which
> can be reported to its hypervisor so that the hypervisor could
> free and reuse that memory as per its requirement.
> 
> While the pages are getting processed in the hypervisor (e.g.,
> via MADV_FREE), the guest must not use them, otherwise, data loss
> would be possible. To avoid such a situation, these pages are
> temporarily removed from the buddy. The amount of pages removed
> temporarily from the buddy is governed by the backend(virtio-balloon
> in our case).
> 
> To efficiently identify free pages that can to be hinted to the
> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> chunks are reported to the hypervisor - especially, to not break up THP
> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> in the bitmap are an indication whether a page *might* be free, not a
> guarantee. A new hook after buddy merging sets the bits.
> 
> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> asynchronously processes the bitmaps, trying to isolate and report pages
> that are still free. The backend (virtio-balloon) is responsible for
> reporting these batched pages to the host synchronously. Once reporting/
> freeing is complete, isolated pages are returned back to the buddy.
> 
> There are still various things to look into (e.g., memory hotplug, more
> efficient locking, possible races when disabling).
> 
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
> ---
>  drivers/virtio/Kconfig       |   1 +
>  include/linux/page_hinting.h |  46 +++++++
>  mm/Kconfig                   |   6 +
>  mm/Makefile                  |   2 +
>  mm/page_alloc.c              |  17 +--
>  mm/page_hinting.c            | 236 +++++++++++++++++++++++++++++++++++
>  6 files changed, 301 insertions(+), 7 deletions(-)
>  create mode 100644 include/linux/page_hinting.h
>  create mode 100644 mm/page_hinting.c
> 
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 35897649c24f..5a96b7a2ed1e 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -46,6 +46,7 @@ config VIRTIO_BALLOON
>  	tristate "Virtio balloon driver"
>  	depends on VIRTIO
>  	select MEMORY_BALLOON
> +	select PAGE_HINTING
>  	---help---
>  	 This driver supports increasing and decreasing the amount
>  	 of memory within a KVM guest.
> diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting.h
> new file mode 100644
> index 000000000000..e65188fe1e6b
> --- /dev/null
> +++ b/include/linux/page_hinting.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PAGE_HINTING_H
> +#define _LINUX_PAGE_HINTING_H
> +
> +/*
> + * Minimum page order required for a page to be hinted to the host.
> + */
> +#define PAGE_HINTING_MIN_ORDER		(MAX_ORDER - 2)
> +
> +/*
> + * struct page_hinting_cb: holds the callbacks to store, report and cleanup
> + * isolated pages.
> + * @prepare:		Callback responsible for allocating an array to hold
> + *			the isolated pages.
> + * @hint_pages:		Callback which reports the isolated pages synchornously
> + *			to the host.
> + * @cleanup:		Callback to free the the array used for reporting the
> + *			isolated pages.
> + * @max_pages:		Maxmimum pages that are going to be hinted to the host
> + *			at a time of granularity >= PAGE_HINTING_MIN_ORDER.
> + */
> +struct page_hinting_cb {
> +	int (*prepare)(void);
> +	void (*hint_pages)(struct list_head *list);
> +	void (*cleanup)(void);
> +	int max_pages;

If we allocate the array in virtio-balloon differently (e.g. similar to
bulk inflation/deflation of pfn's right now), we can most probably get
rid of prepare() and cleanup(), simplifying the code further.

> +};
> +
> +#ifdef CONFIG_PAGE_HINTING
> +void page_hinting_enqueue(struct page *page, int order);
> +void page_hinting_enable(const struct page_hinting_cb *cb);
> +void page_hinting_disable(void);
> +#else
> +static inline void page_hinting_enqueue(struct page *page, int order)
> +{
> +}
> +
> +static inline void page_hinting_enable(struct page_hinting_cb *cb)
> +{
> +}
> +
> +static inline void page_hinting_disable(void)
> +{
> +}
> +#endif
> +#endif /* _LINUX_PAGE_HINTING_H */
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ee8d1f311858..177d858de758 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -764,4 +764,10 @@ config GUP_BENCHMARK
>  config ARCH_HAS_PTE_SPECIAL
>  	bool
>  
> +# PAGE_HINTING will allow the guest to report the free pages to the
> +# host in regular interval of time.
> +config PAGE_HINTING
> +       bool
> +       def_bool n
> +       depends on X86_64
>  endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index ac5e5ba78874..bec456dfee34 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -41,6 +41,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
>  			   interval_tree.o list_lru.o workingset.o \
>  			   debug.o $(mmu-y)
>  
> +
>  # Give 'page_alloc' its own module-parameter namespace
>  page-alloc-y := page_alloc.o
>  page-alloc-$(CONFIG_SHUFFLE_PAGE_ALLOCATOR) += shuffle.o
> @@ -94,6 +95,7 @@ obj-$(CONFIG_Z3FOLD)	+= z3fold.o
>  obj-$(CONFIG_GENERIC_EARLY_IOREMAP) += early_ioremap.o
>  obj-$(CONFIG_CMA)	+= cma.o
>  obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
> +obj-$(CONFIG_PAGE_HINTING) += page_hinting.o
>  obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
>  obj-$(CONFIG_USERFAULTFD) += userfaultfd.o
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3b13d3914176..d12f69e0e402 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -68,6 +68,7 @@
>  #include <linux/lockdep.h>
>  #include <linux/nmi.h>
>  #include <linux/psi.h>
> +#include <linux/page_hinting.h>
>  
>  #include <asm/sections.h>
>  #include <asm/tlbflush.h>
> @@ -873,10 +874,10 @@ compaction_capture(struct capture_control *capc, struct page *page,
>   * -- nyc
>   */
>  
> -static inline void __free_one_page(struct page *page,
> +inline void __free_one_page(struct page *page,
>  		unsigned long pfn,
>  		struct zone *zone, unsigned int order,
> -		int migratetype)
> +		int migratetype, bool hint)
>  {
>  	unsigned long combined_pfn;
>  	unsigned long uninitialized_var(buddy_pfn);
> @@ -951,6 +952,8 @@ static inline void __free_one_page(struct page *page,
>  done_merging:
>  	set_page_order(page, order);
>  
> +	if (hint)
> +		page_hinting_enqueue(page, order);
>  	/*
>  	 * If this is not the largest possible page, check if the buddy
>  	 * of the next-highest order is free. If it is, it's possible
> @@ -1262,7 +1265,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  		if (unlikely(isolated_pageblocks))
>  			mt = get_pageblock_migratetype(page);
>  
> -		__free_one_page(page, page_to_pfn(page), zone, 0, mt);
> +		__free_one_page(page, page_to_pfn(page), zone, 0, mt, true);
>  		trace_mm_page_pcpu_drain(page, 0, mt);
>  	}
>  	spin_unlock(&zone->lock);
> @@ -1271,14 +1274,14 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  static void free_one_page(struct zone *zone,
>  				struct page *page, unsigned long pfn,
>  				unsigned int order,
> -				int migratetype)
> +				int migratetype, bool hint)
>  {
>  	spin_lock(&zone->lock);
>  	if (unlikely(has_isolate_pageblock(zone) ||
>  		is_migrate_isolate(migratetype))) {
>  		migratetype = get_pfnblock_migratetype(page, pfn);
>  	}
> -	__free_one_page(page, pfn, zone, order, migratetype);
> +	__free_one_page(page, pfn, zone, order, migratetype, hint);
>  	spin_unlock(&zone->lock);
>  }
>  
> @@ -1368,7 +1371,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	migratetype = get_pfnblock_migratetype(page, pfn);
>  	local_irq_save(flags);
>  	__count_vm_events(PGFREE, 1 << order);
> -	free_one_page(page_zone(page), page, pfn, order, migratetype);
> +	free_one_page(page_zone(page), page, pfn, order, migratetype, true);
>  	local_irq_restore(flags);
>  }
>  
> @@ -2968,7 +2971,7 @@ static void free_unref_page_commit(struct page *page, unsigned long pfn)
>  	 */
>  	if (migratetype >= MIGRATE_PCPTYPES) {
>  		if (unlikely(is_migrate_isolate(migratetype))) {
> -			free_one_page(zone, page, pfn, 0, migratetype);
> +			free_one_page(zone, page, pfn, 0, migratetype, true);
>  			return;
>  		}
>  		migratetype = MIGRATE_MOVABLE;
> diff --git a/mm/page_hinting.c b/mm/page_hinting.c
> new file mode 100644
> index 000000000000..7341c6462de2
> --- /dev/null
> +++ b/mm/page_hinting.c
> @@ -0,0 +1,236 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Page hinting support to enable a VM to report the freed pages back
> + * to the host.
> + *
> + * Copyright Red Hat, Inc. 2019
> + *
> + * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/slab.h>
> +#include <linux/page_hinting.h>
> +#include <linux/kvm_host.h>
> +
> +/*
> + * struct hinting_bitmap: holds the bitmap pointer which tracks the freed PFNs
> + * and other required parameters which could help in retrieving the original
> + * PFN value using the bitmap.
> + * @bitmap:		Pointer to the bitmap of free PFN.
> + * @base_pfn:		Starting PFN value for the zone whose bitmap is stored.
> + * @free_pages:		Tracks the number of free pages of granularity
> + *			PAGE_HINTING_MIN_ORDER.
> + * @nbits:		Indicates the total size of the bitmap in bits allocated
> + *			at the time of initialization.
> + */
> +struct hinting_bitmap {
> +	unsigned long *bitmap;
> +	unsigned long base_pfn;
> +	atomic_t free_pages;
> +	unsigned long nbits;
> +} bm_zone[MAX_NR_ZONES];
> +
> +static void init_hinting_wq(struct work_struct *work);
> +extern int __isolate_free_page(struct page *page, unsigned int order);
> +extern void __free_one_page(struct page *page, unsigned long pfn,
> +			    struct zone *zone, unsigned int order,
> +			    int migratetype, bool hint);
> +const struct page_hinting_cb *hcb;
> +struct work_struct hinting_work;
> +
> +static unsigned long find_bitmap_size(struct zone *zone)
> +{
> +	unsigned long nbits = ALIGN(zone->spanned_pages,
> +			    PAGE_HINTING_MIN_ORDER);
> +
> +	nbits = nbits >> PAGE_HINTING_MIN_ORDER;
> +	return nbits;

I think we can simplify this to

return (zone->spanned_pages >> PAGE_HINTING_MIN_ORDER) + 1;

> +}
> +
> +void page_hinting_enable(const struct page_hinting_cb *callback)
> +{
> +	struct zone *zone;
> +	int idx = 0;
> +	unsigned long bitmap_size = 0;

You should probably protect enabling via a mutex and return -EINVAL or
similar if we already have a callback set (if we ever have different
drivers). But this has very little priority :)

> +
> +	for_each_populated_zone(zone) {
> +		spin_lock(&zone->lock);
> +		bitmap_size = find_bitmap_size(zone);
> +		bm_zone[idx].bitmap = bitmap_zalloc(bitmap_size, GFP_KERNEL);
> +		if (!bm_zone[idx].bitmap)
> +			return;
> +		bm_zone[idx].nbits = bitmap_size;
> +		bm_zone[idx].base_pfn = zone->zone_start_pfn;
> +		spin_unlock(&zone->lock);
> +		idx++;
> +	}
> +	hcb = callback;
> +	INIT_WORK(&hinting_work, init_hinting_wq);

There are also possible races when enabling, you will have to take care
of at one point.

> +}
> +EXPORT_SYMBOL_GPL(page_hinting_enable);
> +
> +void page_hinting_disable(void)
> +{
> +	struct zone *zone;
> +	int idx = 0;
> +
> +	cancel_work_sync(&hinting_work);
> +	hcb = NULL;
> +	for_each_populated_zone(zone) {
> +		spin_lock(&zone->lock);
> +		bitmap_free(bm_zone[idx].bitmap);
> +		bm_zone[idx].base_pfn = 0;
> +		bm_zone[idx].nbits = 0;
> +		atomic_set(&bm_zone[idx].free_pages, 0);
> +		spin_unlock(&zone->lock);
> +		idx++;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(page_hinting_disable);
> +
> +static unsigned long pfn_to_bit(struct page *page, int zonenum)
> +{
> +	unsigned long bitnr;
> +
> +	bitnr = (page_to_pfn(page) - bm_zone[zonenum].base_pfn)
> +			 >> PAGE_HINTING_MIN_ORDER;
> +	return bitnr;
> +}
> +
> +static void release_buddy_pages(struct list_head *pages)

maybe "release_isolated_pages", not sure.

> +{
> +	int mt = 0, zonenum, order;
> +	struct page *page, *next;
> +	struct zone *zone;
> +	unsigned long bitnr;
> +
> +	list_for_each_entry_safe(page, next, pages, lru) {
> +		zonenum = page_zonenum(page);
> +		zone = page_zone(page);
> +		bitnr = pfn_to_bit(page, zonenum);
> +		spin_lock(&zone->lock);
> +		list_del(&page->lru);
> +		order = page_private(page);
> +		set_page_private(page, 0);
> +		mt = get_pageblock_migratetype(page);
> +		__free_one_page(page, page_to_pfn(page), zone,
> +				order, mt, false);
> +		spin_unlock(&zone->lock);
> +	}
> +}
> +
> +static void bm_set_pfn(struct page *page)
> +{
> +	unsigned long bitnr = 0;
> +	int zonenum = page_zonenum(page);
> +	struct zone *zone = page_zone(page);
> +
> +	lockdep_assert_held(&zone->lock);
> +	bitnr = pfn_to_bit(page, zonenum);
> +	if (bm_zone[zonenum].bitmap &&
> +	    bitnr < bm_zone[zonenum].nbits &&
> +	    !test_and_set_bit(bitnr, bm_zone[zonenum].bitmap))
> +		atomic_inc(&bm_zone[zonenum].free_pages);
> +}
> +
> +static void scan_hinting_bitmap(int zonenum, int free_pages)
> +{
> +	unsigned long set_bit, start = 0;
> +	struct page *page;
> +	struct zone *zone;
> +	int scanned_pages = 0, ret = 0, order, isolated_cnt = 0;
> +	LIST_HEAD(isolated_pages);
> +
> +	ret = hcb->prepare();
> +	if (ret < 0)
> +		return;
> +	for (;;) {
> +		ret = 0;
> +		set_bit = find_next_bit(bm_zone[zonenum].bitmap,
> +					bm_zone[zonenum].nbits, start);
> +		if (set_bit >= bm_zone[zonenum].nbits)
> +			break;
> +		page = pfn_to_online_page((set_bit << PAGE_HINTING_MIN_ORDER) +
> +				bm_zone[zonenum].base_pfn);
> +		if (!page)
> +			continue;

You are not clearing the bit / decrementing the counter.

> +		zone = page_zone(page);
> +		spin_lock(&zone->lock);
> +
> +		if (PageBuddy(page) && page_private(page) >=
> +		    PAGE_HINTING_MIN_ORDER) {
> +			order = page_private(page);
> +			ret = __isolate_free_page(page, order);
> +		}
> +		clear_bit(set_bit, bm_zone[zonenum].bitmap);
> +		spin_unlock(&zone->lock);
> +		if (ret) {
> +			/*
> +			 * restoring page order to use it while releasing
> +			 * the pages back to the buddy.
> +			 */
> +			set_page_private(page, order);
> +			list_add_tail(&page->lru, &isolated_pages);
> +			isolated_cnt++;
> +			if (isolated_cnt == hcb->max_pages) {
> +				hcb->hint_pages(&isolated_pages);
> +				release_buddy_pages(&isolated_pages);
> +				isolated_cnt = 0;
> +			}
> +		}
> +		start = set_bit + 1;
> +		scanned_pages++;
> +	}
> +	if (isolated_cnt) {
> +		hcb->hint_pages(&isolated_pages);
> +		release_buddy_pages(&isolated_pages);
> +	}
> +	hcb->cleanup();
> +	if (scanned_pages > free_pages)
> +		atomic_sub((scanned_pages - free_pages),
> +			   &bm_zone[zonenum].free_pages);

This looks overly complicated. Can't we somehow simply decrement when
clearing a bit?

> +}
> +
> +static bool check_hinting_threshold(void)
> +{
> +	int zonenum = 0;
> +
> +	for (; zonenum < MAX_NR_ZONES; zonenum++) {
> +		if (atomic_read(&bm_zone[zonenum].free_pages) >=
> +				hcb->max_pages)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static void init_hinting_wq(struct work_struct *work)
> +{
> +	int zonenum = 0, free_pages = 0;
> +
> +	for (; zonenum < MAX_NR_ZONES; zonenum++) {
> +		free_pages = atomic_read(&bm_zone[zonenum].free_pages);
> +		if (free_pages >= hcb->max_pages) {
> +			/* Find a better way to synchronize per zone
> +			 * free_pages.
> +			 */
> +			atomic_sub(free_pages,
> +				   &bm_zone[zonenum].free_pages);

I can't follow yet why we need that information. Wouldn't it be enough
to just track the number of set bits in the bitmap and start hinting
depending on that count? (there are false positives, but do we really care?)

> +			scan_hinting_bitmap(zonenum, free_pages);
> +		}
> +	}
> +}
> +
> +void page_hinting_enqueue(struct page *page, int order)
> +{
> +	if (hcb && order >= PAGE_HINTING_MIN_ORDER)
> +		bm_set_pfn(page);
> +	else
> +		return;
> +
> +	if (check_hinting_threshold()) {
> +		int cpu = smp_processor_id();
> +
> +		queue_work_on(cpu, system_wq, &hinting_work);
> +	}
> +}
> 


-- 

Thanks,

David / dhildenb
