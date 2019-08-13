Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E701C8B59E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 12:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfHMKbB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 13 Aug 2019 06:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfHMKbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 06:31:00 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88385C015C30;
        Tue, 13 Aug 2019 10:30:59 +0000 (UTC)
Received: from [10.40.204.186] (ovpn-204-186.brq.redhat.com [10.40.204.186])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE1C786BAE;
        Tue, 13 Aug 2019 10:30:45 +0000 (UTC)
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     David Hildenbrand <david@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
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
 <ca362045-9668-18ff-39b0-de91fa72e73c@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <d39504c9-93bd-b8f7-e119-84baac5a42d4@redhat.com>
Date:   Tue, 13 Aug 2019 06:30:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ca362045-9668-18ff-39b0-de91fa72e73c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 13 Aug 2019 10:30:59 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/12/19 4:05 PM, David Hildenbrand wrote:
>>> ---
>>>  include/linux/mmzone.h         |  11 ++
>>>  include/linux/page_reporting.h |  63 +++++++
>>>  mm/Kconfig                     |   6 +
>>>  mm/Makefile                    |   1 +
>>>  mm/page_alloc.c                |  42 ++++-
>>>  mm/page_reporting.c            | 332 +++++++++++++++++++++++++++++++++
>>>  6 files changed, 448 insertions(+), 7 deletions(-)
>>>  create mode 100644 include/linux/page_reporting.h
>>>  create mode 100644 mm/page_reporting.c
>>>
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index d77d717c620c..ba5f5b508f25 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -559,6 +559,17 @@ struct zone {
>>>         /* Zone statistics */
>>>         atomic_long_t           vm_stat[NR_VM_ZONE_STAT_ITEMS];
>>>         atomic_long_t           vm_numa_stat[NR_VM_NUMA_STAT_ITEMS];
>>> +#ifdef CONFIG_PAGE_REPORTING
>>> +       /* Pointer to the bitmap in PAGE_REPORTING_MIN_ORDER granularity */
>>> +       unsigned long *bitmap;
>>> +       /* Preserve start and end PFN in case they change due to hotplug */
>>> +       unsigned long base_pfn;
>>> +       unsigned long end_pfn;
>>> +       /* Free pages of granularity PAGE_REPORTING_MIN_ORDER */
>>> +       atomic_t free_pages;
>>> +       /* Number of bits required in the bitmap */
>>> +       unsigned long nbits;
>>> +#endif
>>>  } ____cacheline_internodealigned_in_smp;
>> Okay, so the original thing this patch set had going for it was that
>> it was non-invasive. However, now you are adding a bunch of stuff to
>> the zone. That kind of loses the non-invasive argument for this patch
>> set compared to mine.
>>
> Adding something to "struct zone" is certainly less invasive than core
> buddy modifications, just saying (I agree that this is suboptimal. I
> would have guessed that all that's needed is a pointer to some private
> structure here). 


I think having just a pointer to a private structure makes sense here.
If I am not wrong then I can probably make an allocation for it for each
populated zone at the time I enable page reporting.

> However, the migratetype thingy below looks fishy to me.
>
>> If we are going to continue further with this patch set then it might
>> be worth looking into dynamically allocating the space you need for
>> this block. At a minimum you could probably look at making the bitmap
>> an RCU based setup so you could define the base and end along with the
>> bitmap. It would probably help to resolve the hotplug issues you still
>> need to address.
> Yeah, I guess that makes sense.
>
> [...]
>>> +
>>> +static int process_free_page(struct page *page,
>>> +                            struct page_reporting_config *phconf, int count)
>>> +{
>>> +       int mt, order, ret = 0;
>>> +
>>> +       mt = get_pageblock_migratetype(page);
>>> +       order = page_private(page);
>>> +       ret = __isolate_free_page(page, order);
>>> +
> I just started looking into the wonderful world of
> isolation/compaction/migration.
>
> I don't think saving/restoring the migratetype is correct here. AFAIK,
> MOVABLE/UNMOVABLE/RECLAIMABLE is just a hint, doesn't mean that e.g.,
> movable pages and up in UNMOVABLE or ordinary kernel allocations on
> MOVABLE. So that shouldn't be an issue - I guess.
>
> 1. You should never allocate something that is no
> MOVABLE/UNMOVABLE/RECLAIMABLE. Especially not, if you have ISOLATE or
> CMA here. There should at least be a !is_migrate_isolate_page() check
> somewhere
>
> 2. set_migratetype_isolate() takes the zone lock, so to avoid racing
> with isolation code, you have to hold the zone lock. Your code seems to
> do that, so at least you cannot race against isolation.
>
> 3. You could end up temporarily allocating something in the
> ZONE_MOVABLE. The pages you allocate are, however, not movable. There
> would have to be a way to make alloc_contig_range()/offlining code
> properly wait until the pages have been processed. Not sure about the
> real implications, though - too many details in the code (I wonder if
> Alex' series has a way of dealing with that)
>
> When you restore the migratetype, you could suddenly overwrite e.g.,
> ISOLATE, which feels wrong.


I was triggering an occasional CPU stall bug earlier, with saving and restoring
the migratetype I was able to fix it.
But I will further look into this to figure out if it is really required.

> [...]
>> So as per your comments in the cover page, the two functions above
>> should also probably be plugged into the zone resizing logic somewhere
>> so if a zone is resized the bitmap is adjusted.
>>
>>> +/**
>>> + * zone_reporting_init - For each zone initializes the page reporting fields
>>> + * and allocates the respective bitmap.
>>> + *
>>> + * This function returns 0 on successful initialization, -ENOMEM otherwise.
>>> + */
>>> +static int zone_reporting_init(void)
>>> +{
>>> +       struct zone *zone;
>>> +       int ret;
>>> +
>>> +       for_each_populated_zone(zone) {
>>> +#ifdef CONFIG_ZONE_DEVICE
>>> +               /* we can not report pages which are not in the buddy */
>>> +               if (zone_idx(zone) == ZONE_DEVICE)
>>> +                       continue;
>>> +#endif
>> I'm pretty sure this isn't needed since I don't think the ZONE_DEVICE
>> zone will be considered "populated".
>>
> I think you are right (although it's confusing, we will have present
> sections part of a zone but the zone has no present_pages - screams like
> a re factoring - leftover from ZONE_DEVICE introduction).


I think in that case it is safe to have this check here.
What do you guys suggest?


>
-- 
Thanks
Nitesh

