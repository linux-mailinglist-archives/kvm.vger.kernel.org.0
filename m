Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096E7AFE45
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 16:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfIKOFJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 11 Sep 2019 10:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfIKOFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 10:05:09 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F223DC08EC17;
        Wed, 11 Sep 2019 14:05:07 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E9C0601A3;
        Wed, 11 Sep 2019 14:03:56 +0000 (UTC)
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
To:     Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oscar Salvador <osalvador@suse.de>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Pankaj Gupta <pagupta@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz>
 <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
 <20190911080804-mutt-send-email-mst@kernel.org>
 <20190911121941.GU4023@dhcp22.suse.cz> <20190911122526.GV4023@dhcp22.suse.cz>
 <4748a572-57b3-31da-0dde-30138e550c3a@redhat.com>
 <20190911125413.GY4023@dhcp22.suse.cz>
 <736594d6-b9ae-ddb9-2b96-85648728ef33@redhat.com>
 <20190911132002.GA4023@dhcp22.suse.cz>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 mQINBFl4pQoBEADT/nXR2JOfsCjDgYmE2qonSGjkM1g8S6p9UWD+bf7YEAYYYzZsLtbilFTe
 z4nL4AV6VJmC7dBIlTi3Mj2eymD/2dkKP6UXlliWkq67feVg1KG+4UIp89lFW7v5Y8Muw3Fm
 uQbFvxyhN8n3tmhRe+ScWsndSBDxYOZgkbCSIfNPdZrHcnOLfA7xMJZeRCjqUpwhIjxQdFA7
 n0s0KZ2cHIsemtBM8b2WXSQG9CjqAJHVkDhrBWKThDRF7k80oiJdEQlTEiVhaEDURXq+2XmG
 jpCnvRQDb28EJSsQlNEAzwzHMeplddfB0vCg9fRk/kOBMDBtGsTvNT9OYUZD+7jaf0gvBvBB
 lbKmmMMX7uJB+ejY7bnw6ePNrVPErWyfHzR5WYrIFUtgoR3LigKnw5apzc7UIV9G8uiIcZEn
 C+QJCK43jgnkPcSmwVPztcrkbC84g1K5v2Dxh9amXKLBA1/i+CAY8JWMTepsFohIFMXNLj+B
 RJoOcR4HGYXZ6CAJa3Glu3mCmYqHTOKwezJTAvmsCLd3W7WxOGF8BbBjVaPjcZfavOvkin0u
 DaFvhAmrzN6lL0msY17JCZo046z8oAqkyvEflFbC0S1R/POzehKrzQ1RFRD3/YzzlhmIowkM
 BpTqNBeHEzQAlIhQuyu1ugmQtfsYYq6FPmWMRfFPes/4JUU/PQARAQABtCVOaXRlc2ggTmFy
 YXlhbiBMYWwgPG5pbGFsQHJlZGhhdC5jb20+iQI9BBMBCAAnBQJZeKUKAhsjBQkJZgGABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheAAAoJEKOGQNwGMqM56lEP/A2KMs/pu0URcVk/kqVwcBhU
 SnvB8DP3lDWDnmVrAkFEOnPX7GTbactQ41wF/xwjwmEmTzLrMRZpkqz2y9mV0hWHjqoXbOCS
 6RwK3ri5e2ThIPoGxFLt6TrMHgCRwm8YuOSJ97o+uohCTN8pmQ86KMUrDNwMqRkeTRW9wWIQ
 EdDqW44VwelnyPwcmWHBNNb1Kd8j3xKlHtnS45vc6WuoKxYRBTQOwI/5uFpDZtZ1a5kq9Ak/
 MOPDDZpd84rqd+IvgMw5z4a5QlkvOTpScD21G3gjmtTEtyfahltyDK/5i8IaQC3YiXJCrqxE
 r7/4JMZeOYiKpE9iZMtS90t4wBgbVTqAGH1nE/ifZVAUcCtycD0f3egX9CHe45Ad4fsF3edQ
 ESa5tZAogiA4Hc/yQpnnf43a3aQ67XPOJXxS0Qptzu4vfF9h7kTKYWSrVesOU3QKYbjEAf95
 NewF9FhAlYqYrwIwnuAZ8TdXVDYt7Z3z506//sf6zoRwYIDA8RDqFGRuPMXUsoUnf/KKPrtR
 ceLcSUP/JCNiYbf1/QtW8S6Ca/4qJFXQHp0knqJPGmwuFHsarSdpvZQ9qpxD3FnuPyo64S2N
 Dfq8TAeifNp2pAmPY2PAHQ3nOmKgMG8Gn5QiORvMUGzSz8Lo31LW58NdBKbh6bci5+t/HE0H
 pnyVf5xhNC/FuQINBFl4pQoBEACr+MgxWHUP76oNNYjRiNDhaIVtnPRqxiZ9v4H5FPxJy9UD
 Bqr54rifr1E+K+yYNPt/Po43vVL2cAyfyI/LVLlhiY4yH6T1n+Di/hSkkviCaf13gczuvgz4
 KVYLwojU8+naJUsiCJw01MjO3pg9GQ+47HgsnRjCdNmmHiUQqksMIfd8k3reO9SUNlEmDDNB
 XuSzkHjE5y/R/6p8uXaVpiKPfHoULjNRWaFc3d2JGmxJpBdpYnajoz61m7XJlgwl/B5Ql/6B
 dHGaX3VHxOZsfRfugwYF9CkrPbyO5PK7yJ5vaiWre7aQ9bmCtXAomvF1q3/qRwZp77k6i9R3
 tWfXjZDOQokw0u6d6DYJ0Vkfcwheg2i/Mf/epQl7Pf846G3PgSnyVK6cRwerBl5a68w7xqVU
 4KgAh0DePjtDcbcXsKRT9D63cfyfrNE+ea4i0SVik6+N4nAj1HbzWHTk2KIxTsJXypibOKFX
 2VykltxutR1sUfZBYMkfU4PogE7NjVEU7KtuCOSAkYzIWrZNEQrxYkxHLJsWruhSYNRsqVBy
 KvY6JAsq/i5yhVd5JKKU8wIOgSwC9P6mXYRgwPyfg15GZpnw+Fpey4bCDkT5fMOaCcS+vSU1
 UaFmC4Ogzpe2BW2DOaPU5Ik99zUFNn6cRmOOXArrryjFlLT5oSOe4IposgWzdwARAQABiQIl
 BBgBCAAPBQJZeKUKAhsMBQkJZgGAAAoJEKOGQNwGMqM5ELoP/jj9d9gF1Al4+9bngUlYohYu
 0sxyZo9IZ7Yb7cHuJzOMqfgoP4tydP4QCuyd9Q2OHHL5AL4VFNb8SvqAxxYSPuDJTI3JZwI7
 d8JTPKwpulMSUaJE8ZH9n8A/+sdC3CAD4QafVBcCcbFe1jifHmQRdDrvHV9Es14QVAOTZhnJ
 vweENyHEIxkpLsyUUDuVypIo6y/Cws+EBCWt27BJi9GH/EOTB0wb+2ghCs/i3h8a+bi+bS7L
 FCCm/AxIqxRurh2UySn0P/2+2eZvneJ1/uTgfxnjeSlwQJ1BWzMAdAHQO1/lnbyZgEZEtUZJ
 x9d9ASekTtJjBMKJXAw7GbB2dAA/QmbA+Q+Xuamzm/1imigz6L6sOt2n/X/SSc33w8RJUyor
 SvAIoG/zU2Y76pKTgbpQqMDmkmNYFMLcAukpvC4ki3Sf086TdMgkjqtnpTkEElMSFJC8npXv
 3QnGGOIfFug/qs8z03DLPBz9VYS26jiiN7QIJVpeeEdN/LKnaz5LO+h5kNAyj44qdF2T2AiF
 HxnZnxO5JNP5uISQH3FjxxGxJkdJ8jKzZV7aT37sC+Rp0o3KNc+GXTR+GSVq87Xfuhx0LRST
 NK9ZhT0+qkiN7npFLtNtbzwqaqceq3XhafmCiw8xrtzCnlB/C4SiBr/93Ip4kihXJ0EuHSLn
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <7a83df34-3d0b-31c9-6b6d-aea62024a7dd@redhat.com>
Date:   Wed, 11 Sep 2019 10:03:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911132002.GA4023@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 11 Sep 2019 14:05:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/11/19 9:20 AM, Michal Hocko wrote:
> On Wed 11-09-19 15:03:39, David Hildenbrand wrote:
>> On 11.09.19 14:54, Michal Hocko wrote:
>>> On Wed 11-09-19 14:42:41, David Hildenbrand wrote:
>>>> On 11.09.19 14:25, Michal Hocko wrote:
>>>>> On Wed 11-09-19 14:19:41, Michal Hocko wrote:
>>>>>> On Wed 11-09-19 08:08:38, Michael S. Tsirkin wrote:
>>>>>>> On Wed, Sep 11, 2019 at 01:36:19PM +0200, Michal Hocko wrote:
>>>>>>>> On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
>>>>>>>> [...]
>>>>>>>>> We don't put any limitations on the allocator other then that it needs to
>>>>>>>>> clean up the metadata on allocation, and that it cannot allocate a page
>>>>>>>>> that is in the process of being reported since we pulled it from the
>>>>>>>>> free_list. If the page is a "Reported" page then it decrements the
>>>>>>>>> reported_pages count for the free_area and makes sure the page doesn't
>>>>>>>>> exist in the "Boundary" array pointer value, if it does it moves the
>>>>>>>>> "Boundary" since it is pulling the page.
>>>>>>>> This is still a non-trivial limitation on the page allocation from an
>>>>>>>> external code IMHO. I cannot give any explicit reason why an ordering on
>>>>>>>> the free list might matter (well except for page shuffling which uses it
>>>>>>>> to make physical memory pattern allocation more random) but the
>>>>>>>> architecture seems hacky and dubious to be honest. It shoulds like the
>>>>>>>> whole interface has been developed around a very particular and single
>>>>>>>> purpose optimization.
>>>>>>>>
>>>>>>>> I remember that there was an attempt to report free memory that provided
>>>>>>>> a callback mechanism [1], which was much less intrusive to the internals
>>>>>>>> of the allocator yet it should provide a similar functionality. Did you
>>>>>>>> see that approach? How does this compares to it? Or am I completely off
>>>>>>>> when comparing them?
>>>>>>>>
>>>>>>>> [1] mostly likely not the latest version of the patchset
>>>>>>>> http://lkml.kernel.org/r/1502940416-42944-5-git-send-email-wei.w.wang@intel.com
>>>>>>> Linus nacked that one. He thinks invoking callbacks with lots of
>>>>>>> internal mm locks is too fragile.
>>>>>> I would be really curious how much he would be happy about injecting
>>>>>> other restrictions on the allocator like this patch proposes. This is
>>>>>> more intrusive as it has a higher maintenance cost longterm IMHO.
>>>>> Btw. I do agree that callbacks with internal mm locks are not great
>>>>> either. We do have a model for that in mmu_notifiers and it is something
>>>>> I do consider PITA, on the other hand it is mostly sleepable part of the
>>>>> interface which makes it the real pain. The above callback mechanism was
>>>>> explicitly documented with restrictions and that the context is
>>>>> essentially atomic with no access to particular struct pages and no
>>>>> expensive operations possible. So in the end I've considered it
>>>>> acceptably painful. Not that I want to override Linus' nack but if
>>>>> virtualization usecases really require some form of reporting and no
>>>>> other way to do that push people to invent even more interesting
>>>>> approaches then we should simply give them/you something reasonable
>>>>> and least intrusive to our internals.
>>>>>
>>>> The issue with "[PATCH v14 4/5] mm: support reporting free page blocks"
>>>>  is that it cannot really handle the use case we have here if I am not
>>>> wrong. While a page is getting processed by the hypervisor (e.g.
>>>> MADV_DONTNEED), it must not get reused.
>>> What prevents to use the callback to get a list of pfn ranges to work on
>>> and then use something like start_isolate_page_range on the collected
>>> pfn ranges to make sure nobody steals pages from under your feet, do
>>> your thing and drop the isolated state afterwards.
>>>
>>> I am saying somethig like because you wouldn't really want a generic
>>> has_unmovable_pages but rather
>>>                 if (!page_ref_count(page)) {
>>>                         if (PageBuddy(page))
>>>                                 iter += (1 << page_order(page)) - 1;
>>>                         continue;
>>>                 }
>>> subset of it.
>>>
>> Something slightly similar is being performed by Nitesh's patch set. On
>> every free of a certain granularity, he records it in the bitmap. These
>> bits are "hints of free pages".
>>
>> A thread then walks over the bitmap and tries to allocate the "hints".
>> If the pages were already reused, the bit is silently cleared.
>>
>> Instead of allocating/freeing, we could only try to isolate the
>> pageblock, then test if free. (One of the usual issues to work around is
>> MAX_ORDER-1 crossing pageblocks, that might need special care)
> OK, cool that I have reinvented the wheel ;). Allocation is indeed not
> necessary as long as pages are isolated because nobody will allocate
> them.
>  
>> I think you should have a look at the rough idea of Nitesh's patch set
>> to see if something like that is going into a better direction. The
>> bitmap part is in place to do bulk reporting and avoid duplicate reports.
> Let's see how much time I can find for that in my endless inbox whack a mole.
>  
>> I think main points we want (and what I am missing from callback idea
>> being discussed) are
>> 1. Do bulk reporting only when a certain threshold is reached
> Is a time based approach too coarse?

I haven't looked into it yet. One situation which I would definitely
want to avoid is to unnecessary invoke bitmap scans when there are not
sufficient free pages available in the zone.
I can take a look at it if required.


>
>> 2. Report only bigger granularities (especially, avoid THP splits in the
>> hypervisor - >= 2MB proofed to be effective)
> the callback has supported order based scan in some of its iteration.
>
>> 3. Avoid reporting what has just been reported.
> Is the overhead of checking a pfn range in a bitmask that much of an
> overhead to really care?

In most of the cases No. Similar to Alexander I was also running will-it-scale/
page_fault1 to analyze the performance impact of the patch series and haven't
noticed any significant degradation.
In some specific cases, we may see noticeable degradation due to the scanning
overhead.

>
>> 4. Continuously report, not the "one time report everything" approach.
> So you mean the allocator reporting this rather than an external code to
> poll right? I do not know, how much this is nice to have than must have?

Not sure if I understood the question completely.
But yes in my case any workload which is allocating and freeing pages will end
up initiating reporting requests based on the number of free pages in the zone.

-- 
Thanks
Nitesh

