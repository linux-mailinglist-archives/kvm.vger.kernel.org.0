Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5858ECE8F5
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 18:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfJGQTZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Mon, 7 Oct 2019 12:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727876AbfJGQTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 12:19:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 145E510C093B;
        Mon,  7 Oct 2019 16:19:24 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5049F5C223;
        Mon,  7 Oct 2019 16:19:14 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Vlastimil Babka <vbabka@suse.cz>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20191001152441.27008.99285.stgit@localhost.localdomain>
 <7233498c-2f64-d661-4981-707b59c78fd5@redhat.com>
 <1ea1a4e11617291062db81f65745b9c95fd0bb30.camel@linux.intel.com>
 <8bd303a6-6e50-b2dc-19ab-4c3f176c4b02@redhat.com>
 <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
 <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
 <CAKgT0Ud6TT=XxqFx6ePHzbUYqMp5FHVPozRvnNZK3tKV7j2xjg@mail.gmail.com>
 <0a16b11e-ec3b-7196-5b7f-e7395876cf28@redhat.com>
 <d96f744d2c48f5a96c6962c6a0a89d2429e5cab8.camel@linux.intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <7fc13837-546c-9c4a-1456-753df199e171@redhat.com>
Date:   Mon, 7 Oct 2019 12:19:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d96f744d2c48f5a96c6962c6a0a89d2429e5cab8.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Mon, 07 Oct 2019 16:19:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/7/19 11:33 AM, Alexander Duyck wrote:
> On Mon, 2019-10-07 at 08:29 -0400, Nitesh Narayan Lal wrote:
>> On 10/2/19 10:25 AM, Alexander Duyck wrote:
>>
[...]
>> You  don't have to, I can fix the issues in my patch-set. :)
>>> Sounds good. Hopefully the stuff I pointed out above helps you to get
>>> a reproduction and resolve the issues.
>> So I did observe a significant drop in running my v12 path-set [1] with the
>> suggested test setup. However, on making certain changes the performance
>> improved significantly.
>>
>> I used my v12 patch-set which I have posted earlier and made the following
>> changes:
>> 1. Started reporting only (MAX_ORDER - 1) pages and increased the number of
>>     pages that can be reported at a time to 32 from 16. The intent of making
>>     these changes was to bring my configuration closer to what Alexander is
>>     using.
> The increase from 16 to 32 is valid. No point in working in too small of
> batches. However tightening the order to only test for MAX_ORDER - 1 seems
> like a step in the wrong direction. The bitmap approach doesn't have much
> value if it can only work with the highest order page. I realize it is
> probably necessary in order to make the trick for checking on page_buddy
> work, but it seems very limiting.

If using (pageblock_order - 1) is a better way to do this, then I can probably
switch to that.
I will agree with the fact that we have to make the reporting order
configurable, atleast to an extent.

>
>> 2. I made an additional change in my bitmap scanning logic to prevent acquiring
>>     spinlock if the page is already allocated.
> Again, not a fan. It basically means you can only work with MAX_ORDER - 1
> and there will be no ability to work with anything smaller.
>
>> Setup:
>> On a 16 vCPU 30 GB single NUMA guest affined to a single host NUMA, I ran the
>> modified will-it-scale/page_fault number of times and calculated the average
>> of the number of process and threads launched on the 16th core to compare the
>> impact of my patch-set against an unmodified kernel.
>>
>>
>> Conclusion:
>> %Drop in number of processes launched on 16th vCPU =     1-2%
>> %Drop in number of threads launched on 16th vCPU     =     5-6%
> These numbers don't make that much sense to me. Are you talking about a
> fully functioning setup that is madvsing away the memory in the
> hypervisor?


Without making this change I was observing a significant amount of drop
in the number of processes and specifically in the number of threads.
I did a double-check of the configuration which I have shared.
I was also observing the "AnonHugePages" via meminfo to check the THP usage.
Any more suggestions about what else I can do to verify?
I will be more than happy to try them out.

>  If so I would have expected a much higher difference versus
> baseline as zeroing/faulting the pages in the host gets expensive fairly
> quick. What is the host kernel you are running your test on? I'm just
> wondering if there is some additional overhead currently limiting your
> setup. My host kernel was just the same kernel I was running in the guest,
> just built without the patches applied.

Right now I have a different host-kernel. I can install the same kernel to the
host as well and see if that changes anything.

>
>> Other observations:
>> - I also tried running Alexander's latest v11 page-reporting patch set and
>>   observe a similar amount of average degradation in the number of processes
>>   and threads.
>> - I didn't include the linear component recorded by will-it-scale because for
>>   some reason it was fluctuating too much even when I was using an unmodified
>>   kernel. If required I can investigate this further.
>>
>> Note: If there is a better way to analyze the will-it-scale/page_fault results
>> then please do let me know.
> Honestly I have mostly just focused on the processes performance.

In my observation processes seems to be most consistent in general.

>  There is
> usually a fair bit of variability but a pattern forms after a few runs so
> you can generally tell if a configuration is an improvement or not.

Yeah, that's why I thought of taking the average of 5-6 runs.

>
>> Other setup details:
>> Following are the configurations which I enabled to run my tests:
>> - Enabled: CONFIG_SLAB_FREELIST_RANDOM & CONFIG_SHUFFLE_PAGE_ALLOCATOR
>> - Set host THP to always
>> - Set guest THP to madvise
>> - Added the suggested madvise call in page_fault source code.
>> @Alexander please let me know if I missed something.
> This seems about right.
>
>> The current state of my v13:
>> I still have to look into Michal's suggestion of using page-isolation API's
>> instead of isolating the page. However, I believe at this moment our objective
>> is to decide with which approach we can proceed and that's why I decided to
>> post the numbers by making small required changes in v12 instead of posting a
>> new series.
>>
>>
>> Following are the changes which I have made on top of my v12:
>>
>> page_reporting.h change:
>> -#define PAGE_REPORTING_MIN_ORDER               (MAX_ORDER - 2)
>> -#define PAGE_REPORTING_MAX_PAGES               16
>> +#define PAGE_REPORTING_MIN_ORDER              (MAX_ORDER - 1)
>> +#define PAGE_REPORTING_MAX_PAGES              32
>>
>> page_reporting.c change:
>> @@ -101,8 +101,12 @@ static void scan_zone_bitmap(struct page_reporting_config
>> *phconf,
>>                 /* Process only if the page is still online */
>>                 page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
>>                                           zone->base_pfn);
>> -               if (!page)
>> +               if (!page || !PageBuddy(page)) {
>> +                       clear_bit(setbit, zone->bitmap);
>> +                       atomic_dec(&zone->free_pages);
>>                         continue;
>> +               }
>>
> I suspect the zone->free_pages is going to be expensive for you to deal
> with. It is a global atomic value and is going to have the cacheline
> bouncing that it is contained in. As a result thinks like setting the
> bitmap with be more expensive as every tome a CPU increments free_pages it
> will likely have to take the cache line containing the bitmap pointer as
> well.

I see I will have to explore this more. I am wondering if there is a way to
measure this If its effect is not visible in will-it-scale/page_fault1. If
there is a noticeable amount of degradation, I will have to address this.

>
>> @Alexander in case you decide to give it a try and find different results,
>> please do let me know.
>>
>> [1] https://lore.kernel.org/lkml/20190812131235.27244-1-nitesh@redhat.com/
>>
>>
> If I have some free time I will take a look.

That would be great, thanks.

>  However one thing that
> concerns me about this change is that it will limit things much further in
> terms of how much memory can ultimately be freed since you are now only
> working with the highest order page and that becomes a hard requirement
> for your design.

I would assume that should be resolved with (pageblock_order - 1).

>
-- 
Nitesh

