Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AE5D14F3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731824AbfJIRIp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Oct 2019 13:08:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730546AbfJIRIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 13:08:44 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B4AE49B28D;
        Wed,  9 Oct 2019 17:08:43 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 833A660C05;
        Wed,  9 Oct 2019 17:08:29 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
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
 <7fc13837-546c-9c4a-1456-753df199e171@redhat.com>
 <5b6e0b6df46c03bfac906313071ac0362d43c432.camel@linux.intel.com>
 <c2fd074b-1c86-cd93-41ea-ae1a6b2ca841@redhat.com>
 <CAKgT0Uecy96y-bOj4TpXBxSwJhn3jaCtGjD2+Zswh9gN7i+Otg@mail.gmail.com>
 <9bd52b8e-fa9e-a5ad-de39-660684757cdb@redhat.com>
 <4b6a9bda0a19c20b04338fd1d9b4f96086480355.camel@linux.intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <90ab549c-2155-7a57-5dc9-f5a785049e8c@redhat.com>
Date:   Wed, 9 Oct 2019 13:08:28 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4b6a9bda0a19c20b04338fd1d9b4f96086480355.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 09 Oct 2019 17:08:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/9/19 12:50 PM, Alexander Duyck wrote:
> On Wed, 2019-10-09 at 12:25 -0400, Nitesh Narayan Lal wrote:
>> On 10/7/19 1:20 PM, Alexander Duyck wrote:
>>> On Mon, Oct 7, 2019 at 10:07 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>>> On 10/7/19 12:27 PM, Alexander Duyck wrote:
>>>>> On Mon, 2019-10-07 at 12:19 -0400, Nitesh Narayan Lal wrote:
>>>>>> On 10/7/19 11:33 AM, Alexander Duyck wrote:
>>>>>>> On Mon, 2019-10-07 at 08:29 -0400, Nitesh Narayan Lal wrote:
>>>>>>>> On 10/2/19 10:25 AM, Alexander Duyck wrote:
>>> <snip>
>>>
>>>>>>>> page_reporting.c change:
>>>>>>>> @@ -101,8 +101,12 @@ static void scan_zone_bitmap(struct page_reporting_config
>>>>>>>> *phconf,
>>>>>>>>                 /* Process only if the page is still online */
>>>>>>>>                 page = pfn_to_online_page((setbit << PAGE_REPORTING_MIN_ORDER) +
>>>>>>>>                                           zone->base_pfn);
>>>>>>>> -               if (!page)
>>>>>>>> +               if (!page || !PageBuddy(page)) {
>>>>>>>> +                       clear_bit(setbit, zone->bitmap);
>>>>>>>> +                       atomic_dec(&zone->free_pages);
>>>>>>>>                         continue;
>>>>>>>> +               }
>>>>>>>>
>>>>>>> I suspect the zone->free_pages is going to be expensive for you to deal
>>>>>>> with. It is a global atomic value and is going to have the cacheline
>>>>>>> bouncing that it is contained in. As a result thinks like setting the
>>>>>>> bitmap with be more expensive as every tome a CPU increments free_pages it
>>>>>>> will likely have to take the cache line containing the bitmap pointer as
>>>>>>> well.
>>>>>> I see I will have to explore this more. I am wondering if there is a way to
>>>>>> measure this If its effect is not visible in will-it-scale/page_fault1. If
>>>>>> there is a noticeable amount of degradation, I will have to address this.
>>>>> If nothing else you might look at seeing if you can split up the
>>>>> structures so that the bitmap and nr_bits is in a different region
>>>>> somewhere since those are read-mostly values.
>>>> ok, I will try to understand the issue and your suggestion.
>>>> Thank you for bringing this up.
>>>>
>>>>> Also you are now updating the bitmap and free_pages both inside and
>>>>> outside of the zone lock so that will likely have some impact.
>>>> So as per your previous suggestion, I have made the bitmap structure
>>>> object as a rcu protected pointer. So we are safe from that side.
>>>> The other downside which I can think of is a race where one page
>>>> trying to increment free_pages and other trying to decrements it.
>>>> However, being an atomic variable that should not be a problem.
>>>> Did I miss anything?
>>> I'm not so much worried about a race as the cache line bouncing
>>> effect. Basically your notifier combined within this hinting thread
>>> will likely result in more time spent by the thread that holds the
>>> lock since it will be trying to access the bitmap to set the bit and
>>> the free_pages to report the bit, but at the same time you will have
>>> this thread clearing bits and decrementing the free_pages values.
>>>
>>> One thing you could consider in your worker thread would be to do
>>> reallocate and replace the bitmap every time you plan to walk it. By
>>> doing that you would avoid the cacheline bouncing on the bitmap since
>>> you would only have to read it, and you would no longer have another
>>> thread dirtying it. You could essentially reset the free_pages at the
>>> same time you replace the bitmap. It would need to all happen with the
>>> zone lock held though when you swap it out.
>> If I am not mistaken then from what you are suggesting, I will have to hold
>> the zone lock for the entire duration of swap & scan which would be costly if
>> the bitmap is large, isn't? Also, we might end up missing free pages that are
>> getting
>> freed while we are scanning.
> You would only need to hold the zone lock when you swap the bitmap. Once
> it is swapped you wouldn't need to worry about the locking again for
> bitmap access since your worker thread would be the only one holding the
> current bitmap. Think of it as a batch clearing of the bits.

I see.

>
> You already end up missing pages freed while scanning since you are doing
> it linearly.

I was referring to free pages for whom bits will not be set while we
are doing the batch clearing of the bits.

>
>> As far as free_pages count is concerned, I am thinking if I should
>> replace it with zone->free_area[REPORTING_ORDER].nr_free which is already there
>> (I still need to explore this in a bit more depth).
>>
>>> - Alex
> So there ends up being two ways you could use nr_free. One is to track it
> the way I did with the number of reported pages being tracked, however
> that requires reducing the count when reported pages are pulled from the
> free_area and identifying reported pages vs unreported ones.
>
> The other option would be to look at converting nr_free into a pair of
> free running counters, one tracking frees, and another tracking
> allocations. Then you just need to record a snapshot of the nr_free values
> when you do something like the bitmap swap, and then you would be able to
> track churn, but it wouldn't give you an exact count of unreported pages
> since it is possible to just alloc/free a single page multiple times to
> make it look like you have freed a number of pages even though you really
> haven't.

Yeah possibly. I will think about it a little bit more to see what
is the best way to do it.

-- 
Thanks
Nitesh

