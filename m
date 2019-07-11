Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0FE26621B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 01:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbfGKXUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 19:20:13 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:39283 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfGKXUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 19:20:13 -0400
Received: by mail-io1-f65.google.com with SMTP id f4so16393379ioh.6;
        Thu, 11 Jul 2019 16:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCPHoz17y0dpD/UZbIl3iQbaQKp5frubKji4q6qVvyg=;
        b=tcTUtS8dZco2rqXX31P2FSSeJcBGk6f+b/efZUS8D7qyxpaCnel/TDHDm4QpAKnE9j
         e5VfKfLV6SuepCtL1g+e+fJh0z8genvbO4HtjQhMQuN7dlxoLExvc00D3V4WGKGOIu5s
         qgaHbkJGjnEBhf5IZecdg2HKDeTqxPpAd4RMtHQiyemChbr8katgOaoupJaEHAYl7KSD
         E6NuMEiXX9Gy5cnxWwGfIqjxp6Tq2sfbO9ffK8TJjnmYOj0mb2jnNHEpctl6yLx3vh9o
         PFaCgm+MiDYZ3qjoKpsPrJlmyEVOkICA8RakfXehLjCsYoKj8L8CpZVPrVgxuIEx/ite
         YFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCPHoz17y0dpD/UZbIl3iQbaQKp5frubKji4q6qVvyg=;
        b=oVbRPjWDWE+j8F1CmWGtqd2hyYyOxZ2mKV8mlczXcKxKnJdDPDMwj5i8RLWI7wSjla
         47xzai1ZvyOR65yH5Wg7f3sRPrqwI14GtaMYp0ee4TGl5zJ3RWNffjwp8jz+jAY1AqPb
         6dhy3m2+9E/k0FhlW9a6jJvc3EyQeC3izd4QpN/PO5ViSnuUyoLsj5RyZKShdSvDgYkh
         NJvMs0CC8OtPCavjGHUsDeX3WpY+U609JYOHpoeq5kTD6joOlLLZgHECDOr2/MoJnlvZ
         LEpDf+FjY37jmgcOXZBL1jJuCV7LvFt/wNvju97vsWwiaJFh2aO/gz74Ev2tA8rq1S6I
         X+DQ==
X-Gm-Message-State: APjAAAW8nbvjANBJJLMNFYXY+gLp1VZanT5cx/LiHyu1PfxG09pBdQAK
        TzBqUeZWhUiRNTXBoD1Hc/Un1H4KOynuxmydJAc=
X-Google-Smtp-Source: APXvYqzEaqbHfFNh+TRcl7ohEcstvzvXgd581ukBAhA/w4uEdRcz2hBu8SNgoIPOn2m6J1GhyxF+pIMqglwUhWaquXU=
X-Received: by 2002:a6b:dd18:: with SMTP id f24mr6836460ioc.97.1562887211609;
 Thu, 11 Jul 2019 16:20:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190710195158.19640-1-nitesh@redhat.com> <20190710195158.19640-2-nitesh@redhat.com>
 <CAKgT0Ue3mVZ_J0GgMUP4PBW4SUD1=L9ixD5nUZybw9_vmBAT0A@mail.gmail.com> <3c6c6b93-eb21-a04c-d0db-6f1b134540db@redhat.com>
In-Reply-To: <3c6c6b93-eb21-a04c-d0db-6f1b134540db@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Jul 2019 16:20:00 -0700
Message-ID: <CAKgT0UcaKhAf+pTeE1CRxqhiPtR2ipkYZZ2+aChetV7=LDeSeA@mail.gmail.com>
Subject: Re: [RFC][Patch v11 1/2] mm: page_hinting: core infrastructure
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 10:58 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 7/10/19 5:56 PM, Alexander Duyck wrote:
> > On Wed, Jul 10, 2019 at 12:52 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
> >> This patch introduces the core infrastructure for free page hinting in
> >> virtual environments. It enables the kernel to track the free pages which
> >> can be reported to its hypervisor so that the hypervisor could
> >> free and reuse that memory as per its requirement.
> >>
> >> While the pages are getting processed in the hypervisor (e.g.,
> >> via MADV_FREE), the guest must not use them, otherwise, data loss
> >> would be possible. To avoid such a situation, these pages are
> >> temporarily removed from the buddy. The amount of pages removed
> >> temporarily from the buddy is governed by the backend(virtio-balloon
> >> in our case).
> >>
> >> To efficiently identify free pages that can to be hinted to the
> >> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
> >> chunks are reported to the hypervisor - especially, to not break up THP
> >> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
> >> in the bitmap are an indication whether a page *might* be free, not a
> >> guarantee. A new hook after buddy merging sets the bits.
> >>
> >> Bitmaps are stored per zone, protected by the zone lock. A workqueue
> >> asynchronously processes the bitmaps, trying to isolate and report pages
> >> that are still free. The backend (virtio-balloon) is responsible for
> >> reporting these batched pages to the host synchronously. Once reporting/
> >> freeing is complete, isolated pages are returned back to the buddy.
> >>
> >> There are still various things to look into (e.g., memory hotplug, more
> >> efficient locking, possible races when disabling).
> >>
> >> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

So just FYI, I thought I would try the patches. It looks like there
might be a bug somewhere that is causing it to free memory it
shouldn't be. After about 10 minutes my VM crashed with a system log
full of various NULL pointer dereferences. The only change I had made
is to use MADV_DONTNEED instead of MADV_FREE in QEMU since my headers
didn't have MADV_FREE on the host. It occurs to me one advantage of
MADV_DONTNEED over MADV_FREE is that you are more likely to catch
these sort of errors since it zeros the pages instead of leaving them
intact.

> >> ---
> >>  include/linux/page_hinting.h |  45 +++++++
> >>  mm/Kconfig                   |   6 +
> >>  mm/Makefile                  |   1 +
> >>  mm/page_alloc.c              |  18 +--
> >>  mm/page_hinting.c            | 250 +++++++++++++++++++++++++++++++++++
> >>  5 files changed, 312 insertions(+), 8 deletions(-)
> >>  create mode 100644 include/linux/page_hinting.h
> >>  create mode 100644 mm/page_hinting.c
> >>
> >> diff --git a/include/linux/page_hinting.h b/include/linux/page_hinting.h
> >> new file mode 100644
> >> index 000000000000..4900feb796f9
> >> --- /dev/null
> >> +++ b/include/linux/page_hinting.h
> >> @@ -0,0 +1,45 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +#ifndef _LINUX_PAGE_HINTING_H
> >> +#define _LINUX_PAGE_HINTING_H
> >> +
> >> +/*
> >> + * Minimum page order required for a page to be hinted to the host.
> >> + */
> >> +#define PAGE_HINTING_MIN_ORDER         (MAX_ORDER - 2)
> >> +
> > Why use (MAX_ORDER - 2)? Is this just because of the issues I pointed
> > out earlier for is it due to something else? I'm just wondering if
> > this will have an impact on architectures outside of x86 as I had
> > chose pageblock_order which happened to be MAX_ORDER - 2 on x86, but I
> > don't know that the impact of doing that is on other architectures
> > versus the (MAX_ORDER - 2) approach you took here.
> If I am not wrong then any order  < (MAX_ORDER - 2) will break the THP.
> That's one reason we decided to stick with this.

That is true for x86, but I don't think that is true for other
architectures. That is why I went with pageblock_order instead of just
using a fixed value such as MAX_ORDER - 2.

<snip>

> >> diff --git a/mm/page_hinting.c b/mm/page_hinting.c
> >> new file mode 100644
> >> index 000000000000..0bfa09f8c3ed
> >> --- /dev/null
> >> +++ b/mm/page_hinting.c
> >> @@ -0,0 +1,250 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Page hinting core infrastructure to enable a VM to report free pages to its
> >> + * hypervisor.
> >> + *
> >> + * Copyright Red Hat, Inc. 2019
> >> + *
> >> + * Author(s): Nitesh Narayan Lal <nitesh@redhat.com>
> >> + */
> >> +
> >> +#include <linux/mm.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/page_hinting.h>
> >> +#include <linux/kvm_host.h>
> >> +
> >> +/*
> >> + * struct zone_free_area: For a single zone across NUMA nodes, it holds the
> >> + * bitmap pointer to track the free pages and other required parameters
> >> + * used to recover these pages by scanning the bitmap.
> >> + * @bitmap:            Pointer to the bitmap in PAGE_HINTING_MIN_ORDER
> >> + *                     granularity.
> >> + * @base_pfn:          Starting PFN value for the zone whose bitmap is stored.
> >> + * @end_pfn:           Indicates the last PFN value for the zone.
> >> + * @free_pages:                Tracks the number of free pages of granularity
> >> + *                     PAGE_HINTING_MIN_ORDER.
> >> + * @nbits:             Indicates the total size of the bitmap in bits allocated
> >> + *                     at the time of initialization.
> >> + */
> >> +struct zone_free_area {
> >> +       unsigned long *bitmap;
> >> +       unsigned long base_pfn;
> >> +       unsigned long end_pfn;
> >> +       atomic_t free_pages;
> >> +       unsigned long nbits;
> >> +} free_area[MAX_NR_ZONES];
> >> +
> > You still haven't addressed the NUMA issue I pointed out with v10. You
> > are only able to address the first set of zones with this setup. As
> > such you can end up missing large sections of memory if it is split
> > over multiple nodes.
> I think I did.

I just realized what you did. Actually this doesn't really improve
things in my opinion. More comments below.

> >
> >> +static void init_hinting_wq(struct work_struct *work);
> >> +static DEFINE_MUTEX(page_hinting_init);
> >> +const struct page_hinting_config *page_hitning_conf;
> >> +struct work_struct hinting_work;
> >> +atomic_t page_hinting_active;
> >> +
> >> +void free_area_cleanup(int nr_zones)
> >> +{
> > I'm not sure why you are passing nr_zones as an argument here. Won't
> > this always be MAX_NR_ZONES?
> free_area_cleanup() gets called from page_hinting_disable() and
> page_hinting_enable(). In page_hinting_enable() when the allocation
> fails we may not have to perform cleanup for all the zones everytime.

Just adding a NULL pointer check to this loop below would still keep
it pretty cheap as the cost for initializing memory to 0 isn't that
high, and this is slow path anyway. Either way I guess it works. You
might want to reset the bitmap pointer to NULL though after you free
it to more easily catch the double free case.

> >> +       int zone_idx;
> >> +
> >> +       for (zone_idx = 0; zone_idx < nr_zones; zone_idx++) {
> >> +               bitmap_free(free_area[zone_idx].bitmap);
> >> +               free_area[zone_idx].base_pfn = 0;
> >> +               free_area[zone_idx].end_pfn = 0;
> >> +               free_area[zone_idx].nbits = 0;
> >> +               atomic_set(&free_area[zone_idx].free_pages, 0);
> >> +       }
> >> +}
> >> +
> >> +int page_hinting_enable(const struct page_hinting_config *conf)
> >> +{
> >> +       unsigned long bitmap_size = 0;
> >> +       int zone_idx = 0, ret = -EBUSY;
> >> +       struct zone *zone;
> >> +
> >> +       mutex_lock(&page_hinting_init);
> >> +       if (!page_hitning_conf) {
> >> +               for_each_populated_zone(zone) {
> > So for_each_populated_zone will go through all of the NUMA nodes. So
> > if I am not mistaken you will overwrite the free_area values of all
> > the previous nodes with the last node in the system.
> Not sure if I understood.

I misread the code. More comments below.

> >  So if we have a
> > setup that has all the memory in the first node, and none in the
> > second it would effectively disable free page hinting would it not?
> Why will it happen? The base_pfn will still be pointing to the base_pfn
> of the first node. Isn't?

So this does address my concern however, it introduces a new issue.
Specifically you could end up introducing a gap of unused bits if the
memory from one zone is not immediately adjacent to another. This gets
back to the SPARSEMEM issue that I think Dave pointed out.


<snip>

> >> +static void scan_zone_free_area(int zone_idx, int free_pages)
> >> +{
> >> +       int ret = 0, order, isolated_cnt = 0;
> >> +       unsigned long set_bit, start = 0;
> >> +       LIST_HEAD(isolated_pages);
> >> +       struct page *page;
> >> +       struct zone *zone;
> >> +
> >> +       for (;;) {
> >> +               ret = 0;
> >> +               set_bit = find_next_bit(free_area[zone_idx].bitmap,
> >> +                                       free_area[zone_idx].nbits, start);
> >> +               if (set_bit >= free_area[zone_idx].nbits)
> >> +                       break;
> >> +               page = pfn_to_online_page((set_bit << PAGE_HINTING_MIN_ORDER) +
> >> +                               free_area[zone_idx].base_pfn);
> >> +               if (!page)
> >> +                       continue;
> >> +               zone = page_zone(page);
> >> +               spin_lock(&zone->lock);
> >> +
> >> +               if (PageBuddy(page) && page_private(page) >=
> >> +                   PAGE_HINTING_MIN_ORDER) {
> >> +                       order = page_private(page);
> >> +                       ret = __isolate_free_page(page, order);
> >> +               }
> >> +               clear_bit(set_bit, free_area[zone_idx].bitmap);
> >> +               atomic_dec(&free_area[zone_idx].free_pages);
> >> +               spin_unlock(&zone->lock);
> >> +               if (ret) {
> >> +                       /*
> >> +                        * restoring page order to use it while releasing
> >> +                        * the pages back to the buddy.
> >> +                        */
> >> +                       set_page_private(page, order);
> >> +                       list_add_tail(&page->lru, &isolated_pages);
> >> +                       isolated_cnt++;
> >> +                       if (isolated_cnt == page_hitning_conf->max_pages) {
> >> +                               page_hitning_conf->hint_pages(&isolated_pages);
> >> +                               release_buddy_pages(&isolated_pages);
> >> +                               isolated_cnt = 0;
> >> +                       }
> >> +               }
> >> +               start = set_bit + 1;
> >> +       }
> >> +       if (isolated_cnt) {
> >> +               page_hitning_conf->hint_pages(&isolated_pages);
> >> +               release_buddy_pages(&isolated_pages);
> >> +       }
> >> +}
> >> +
> > I really worry that this loop is going to become more expensive as the
> > size of memory increases. For example if we hint on just 16 pages we
> > would have to walk something like 4K bits, 512 longs, if a system had
> > 64G of memory. Have you considered testing with a larger memory
> > footprint to see if it has an impact on performance?
> I am hoping this will be noticeable in will-it-scale's page_fault1, if I
> run it on a larger system?

What you will probably see is that the CPU that is running the scan is
going to be sitting at somewhere near 100% because I cannot see how it
can hope to stay efficient if it has to check something like 512 64b
longs searching for just a handful of idle pages.

> >
> >> +static void init_hinting_wq(struct work_struct *work)
> >> +{
> >> +       int zone_idx, free_pages;
> >> +
> >> +       atomic_set(&page_hinting_active, 1);
> >> +       for (zone_idx = 0; zone_idx < MAX_NR_ZONES; zone_idx++) {
> >> +               free_pages = atomic_read(&free_area[zone_idx].free_pages);
> >> +               if (free_pages >= page_hitning_conf->max_pages)
> >> +                       scan_zone_free_area(zone_idx, free_pages);
> >> +       }
> >> +       atomic_set(&page_hinting_active, 0);
> >> +}
> >> +
> >> +void page_hinting_enqueue(struct page *page, int order)
> >> +{
> >> +       int zone_idx;
> >> +
> >> +       if (!page_hitning_conf || order < PAGE_HINTING_MIN_ORDER)
> >> +               return;
> > I would think it is going to be expensive to be jumping into this
> > function for every freed page. You should probably have an inline
> > taking care of the order check before you even get here since it would
> > be faster that way.
> I see, I can take a look. Thanks.
> >
> >> +
> >> +       bm_set_pfn(page);
> >> +       if (atomic_read(&page_hinting_active))
> >> +               return;
> > So I would think this piece is racy. Specifically if you set a PFN
> > that is somewhere below the PFN you are currently processing in your
> > scan it is going to remain unset until you have another page freed
> > after the scan is completed. I would worry you can end up with a batch
> > free of memory resulting in a group of pages sitting at the start of
> > your bitmap unhinted.
> True, but that will be hinted next time threshold is met.

Yes, but that assumes that there is another free immediately coming.
It is possible that you have a big application run and then
immediately shut down and have it free all its memory at once. Worst
case scenario would be that it starts by freeing from the end and
works toward the start. With that you could theoretically end up with
a significant chunk of memory waiting some time for another big free
to come along.
