Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D8E75910
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 22:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfGYUpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 16:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfGYUpP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 16:45:15 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4B3FF307D84B;
        Thu, 25 Jul 2019 20:45:14 +0000 (UTC)
Received: from [10.36.116.16] (ovpn-116-16.ams2.redhat.com [10.36.116.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38902600D1;
        Thu, 25 Jul 2019 20:45:00 +0000 (UTC)
Subject: Re: [PATCH v2 4/5] mm: Introduce Hinted pages
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yang Zhang <yang.zhang.wz@gmail.com>, pagupta@redhat.com,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, wei.w.wang@intel.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, dan.j.williams@intel.com,
        Matthew Wilcox <willy@infradead.org>
References: <20190724165158.6685.87228.stgit@localhost.localdomain>
 <20190724170259.6685.18028.stgit@localhost.localdomain>
 <a9f52894-52df-cd0c-86ac-eea9fbe96e34@redhat.com>
 <CAKgT0Ud-UNk0Mbef92hDLpWb2ppVHsmd24R9gEm2N8dujb4iLw@mail.gmail.com>
 <f0ac7747-0e18-5039-d341-5dfda8d5780e@redhat.com>
 <b3568a5422d0f6b88f7c5cb46577db1a43057c04.camel@linux.intel.com>
 <c200d5cf-90f7-9dca-5061-b6e0233ca089@redhat.com>
 <5f78cccab8273cb759538ef6e088886a507ce438.camel@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <c185af56-0c85-a84a-b7cf-bbb2b0bc6b5b@redhat.com>
Date:   Thu, 25 Jul 2019 22:44:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <5f78cccab8273cb759538ef6e088886a507ce438.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 25 Jul 2019 20:45:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25.07.19 22:37, Alexander Duyck wrote:
> On Thu, 2019-07-25 at 20:32 +0200, David Hildenbrand wrote:
>> On 25.07.19 19:38, Alexander Duyck wrote:
>>> On Thu, 2019-07-25 at 18:48 +0200, David Hildenbrand wrote:
>>>> On 25.07.19 17:59, Alexander Duyck wrote:
>>>>> On Thu, Jul 25, 2019 at 1:53 AM David Hildenbrand <david@redhat.com> wrote:
>>>>>> On 24.07.19 19:03, Alexander Duyck wrote:
>>>>>>> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>
>>> <snip>
>>>
>>>>>> Can't we reuse one of the traditional page flags for that, not used
>>>>>> along with buddy pages? E.g., PG_dirty: Pages that were not hinted yet
>>>>>> are dirty.
>>>>>
>>>>> Reusing something like the dirty bit would just be confusing in my
>>>>> opinion. In addition it looks like Xen has also re-purposed PG_dirty
>>>>> already for another purpose.
>>>>
>>>> You brought up waste page management. A dirty bit for unprocessed pages
>>>> fits perfectly in this context. Regarding XEN, as long as it's not used
>>>> along with buddy pages, no issue.
>>>
>>> I would rather not have to dirty all pages that aren't hinted. That starts
>>> to get too invasive. Ideally we only modify pages if we are hinting on
>>> them. That is why I said I didn't like the use of a dirty bit. What we
>>> want is more of a "guaranteed clean" bit.
>>
>> Not sure if that is too invasive, but fair enough.
>>
>>>> FWIW, I don't even thing PG_offline matches to what you are using it
>>>> here for. The pages are not logically offline. They were simply buddy
>>>> pages that were hinted. (I'd even prefer a separate page type for that
>>>> instead - if we cannot simply reuse one of the other flags)
>>>>
>>>> "Offline pages" that are not actually offline in the context of the
>>>> buddy is way more confusing.
>>>
>>> Right now offline and hinted are essentially the same thing since the
>>> effect is identical.
>>
>> No they are not the same thing. Regarding virtio-balloon: You are free
>> to reuse any hinted pages immediate. Offline pages (a.k.a. inflated) you
>> might not generally reuse before deflating.
> 
> Okay, so it sounds like your perspective is a bit different than mine. I
> was thinking of it from the perspective of the host OS where in either
> case the guest has set the page as MADV_DONTNEED. You are looking at it
> from the guest perspective where Offline means the guest cannot use it.
> 
>>> There may be cases in the future where that is not the case, but with the
>>> current patch set they both result in the pages being evicted from the
>>> guest.
>>>
>>>>> If anything I could probably look at seeing if the PG_private flags
>>>>> are available when a page is in the buddy allocator which I suspect
>>>>> they probably are since the only users I currently see appear to be
>>>>> SLOB and compound pages. Either that or maybe something like PG_head
>>>>> might make sense since once we start allocating them we are popping
>>>>> the head off of the boundary list.
>>>>
>>>> Would also be fine with me.
>>>
>>> Actually I may have found an even better bit if we are going with the
>>> "reporting" name. I could probably use "PG_uptodate" since it looks like
>>> most of its uses are related to filesystems. I will wait till I hear from
>>> Matthew on what bits would be available for use before I update things.
>>
>> Also fine with me. In the optimal case we (in my opinion)
>> a) Don't reuse PG_offline
>> b) Don't use another page type
> 
> That is fine. I just need to determine the exact flag to use then. I'll do
> some more research and wait to see if anyone else from MM comunity has
> input or suggestions on the page flag to be used. From what I can tell it
> looks like there are a bunch of flag bits that are unused as far as the
> buddy pages are concerned so I should have a few to choose from.

Right, and I would favor that - at least less hacking with the
kexec/kdump interface :)

You can then go ahead and add

PG_hinted or PG_reported = PG_*younameit* and properly document how it
is being used along with PageBuddy() only.

-- 

Thanks,

David / dhildenb
