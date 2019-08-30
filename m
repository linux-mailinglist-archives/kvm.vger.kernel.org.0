Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10C9A3B57
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 18:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfH3QF3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 30 Aug 2019 12:05:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbfH3QF2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Aug 2019 12:05:28 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D469C08EC04;
        Fri, 30 Aug 2019 16:05:28 +0000 (UTC)
Received: from [10.40.204.151] (ovpn-204-151.brq.redhat.com [10.40.204.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 740CA3784;
        Fri, 30 Aug 2019 16:05:07 +0000 (UTC)
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>, cohuck@redhat.com
References: <20190812131235.27244-1-nitesh@redhat.com>
 <20190812131235.27244-2-nitesh@redhat.com>
 <CAKgT0UcSabyrO=jUwq10KpJKLSuzorHDnKAGrtWVigKVgvD-6Q@mail.gmail.com>
 <df82bc99-a212-4f5c-dc2e-28665060acb2@redhat.com>
 <CAKgT0Ueqok+bxANVtB1DdYorcEHN7+Grzb8MAxTzSk8uS81pRA@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <9a2ffed8-a8a7-a0a6-ec2d-4234b4e11e3e@redhat.com>
Date:   Fri, 30 Aug 2019 12:05:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Ueqok+bxANVtB1DdYorcEHN7+Grzb8MAxTzSk8uS81pRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 30 Aug 2019 16:05:28 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/30/19 11:31 AM, Alexander Duyck wrote:
> On Fri, Aug 30, 2019 at 8:15 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>
>> On 8/12/19 2:47 PM, Alexander Duyck wrote:
>>> On Mon, Aug 12, 2019 at 6:13 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>>> This patch introduces the core infrastructure for free page reporting in
>>>> virtual environments. It enables the kernel to track the free pages which
>>>> can be reported to its hypervisor so that the hypervisor could
>>>> free and reuse that memory as per its requirement.
>>>>
>>>> While the pages are getting processed in the hypervisor (e.g.,
>>>> via MADV_DONTNEED), the guest must not use them, otherwise, data loss
>>>> would be possible. To avoid such a situation, these pages are
>>>> temporarily removed from the buddy. The amount of pages removed
>>>> temporarily from the buddy is governed by the backend(virtio-balloon
>>>> in our case).
>>>>
>>>> To efficiently identify free pages that can to be reported to the
>>>> hypervisor, bitmaps in a coarse granularity are used. Only fairly big
>>>> chunks are reported to the hypervisor - especially, to not break up THP
>>>> in the hypervisor - "MAX_ORDER - 2" on x86, and to save space. The bits
>>>> in the bitmap are an indication whether a page *might* be free, not a
>>>> guarantee. A new hook after buddy merging sets the bits.
>>>>
>>>> Bitmaps are stored per zone, protected by the zone lock. A workqueue
>>>> asynchronously processes the bitmaps, trying to isolate and report pages
>>>> that are still free. The backend (virtio-balloon) is responsible for
>>>> reporting these batched pages to the host synchronously. Once reporting/
>>>> freeing is complete, isolated pages are returned back to the buddy.
>>>>
>>>> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
>> [...]
>>>> +static void scan_zone_bitmap(struct page_reporting_config *phconf,
>>>> +                            struct zone *zone)
>>>> +{
>>>> +       unsigned long setbit;
>>>> +       struct page *page;
>>>> +       int count = 0;
>>>> +
>>>> +       sg_init_table(phconf->sg, phconf->max_pages);
>>>> +
>>>> +       for_each_set_bit(setbit, zone->bitmap, zone->nbits) {
>>>> +               /* Process only if the page is still online */
>>>> +               page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
>>>> +                                         zone->base_pfn);
>>>> +               if (!page)
>>>> +                       continue;
>>>> +
>>> Shouldn't you be clearing the bit and dropping the reference to
>>> free_pages before you move on to the next bit? Otherwise you are going
>>> to be stuck with those aren't you?
>>>
>>>> +               spin_lock(&zone->lock);
>>>> +
>>>> +               /* Ensure page is still free and can be processed */
>>>> +               if (PageBuddy(page) && page_private(page) >=
>>>> +                   PAGE_REPORTING_MIN_ORDER)
>>>> +                       count = process_free_page(page, phconf, count);
>>>> +
>>>> +               spin_unlock(&zone->lock);
>>> So I kind of wonder just how much overhead you are taking for bouncing
>>> the zone lock once per page here. Especially since it can result in
>>> you not actually making any progress since the page may have already
>>> been reallocated.
>>>
>> I am wondering if there is a way to measure this overhead?
>> After thinking about this, I do understand your point.
>> One possible way which I can think of to address this is by having a
>> page_reporting_dequeue() hook somewhere in the allocation path.
> Really in order to stress this you probably need to have a lot of
> CPUs, a lot of memory, and something that forces a lot of pages to get
> hit such as the memory shuffling feature.

I will think about it, thanks for the suggestion.

>
>> For some reason, I am not seeing this work as I would have expected
>> but I don't have solid reasoning to share yet. It could be simply
>> because I am putting my hook at the wrong place. I will continue
>> investigating this.
>>
>> In any case, I may be over complicating things here, so please let me
>> if there is a better way to do this.
> I have already been demonstrating the "better way" I think there is to
> do this. I will push v7 of it early next week unless there is some
> other feedback. By putting the bit in the page and controlling what
> comes into and out of the lists it makes most of this quite a bit
> easier. The only limitation is you have to modify where things get
> placed in the lists so you don't create a "vapor lock" that would
> stall the feed of pages into the reporting engine.
>
>> If this overhead is not significant we can probably live with it.
> You have bigger issues you still have to overcome as I recall. Didn't
> you still need to sort out hotplu

For memory hotplug, my impression is that it should
not be a blocker for taking the first step (in case we do decide to
go ahead with this approach). Another reason why I am considering
this as future work is that memory hot(un)plug is still under
development and requires fixing. (Specifically, issue such as zone
shrinking which will directly impact the bitmap approach is still
under discussion).

> g and a sparse map with a wide span
> in a zone? Without those resolved the bitmap approach is still a no-go
> regardless of performance.

For sparsity, the memory wastage should not be significant as I
am tracking pages on the granularity of (MAX_ORDER - 2) and maintaining
the bitmaps on a per-zone basis (which was not the case earlier).

However, if you do consider this as a block I will think about it and try to fix it.
In the worst case, if I don't find a solution I will add this as a known limitation
for this approach in my cover.

> - Alex
-- 
Thanks
Nitesh

