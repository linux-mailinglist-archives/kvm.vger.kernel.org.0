Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC48AFD57
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 15:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfIKND7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 09:03:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727976AbfIKND6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 09:03:58 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A49701918654;
        Wed, 11 Sep 2019 13:03:57 +0000 (UTC)
Received: from [10.36.117.155] (ovpn-117-155.ams2.redhat.com [10.36.117.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 389E75DC18;
        Wed, 11 Sep 2019 13:03:40 +0000 (UTC)
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
To:     Michal Hocko <mhocko@kernel.org>
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
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Rik van Riel <riel@surriel.com>, lcapitulino@redhat.com,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, ying.huang@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz>
 <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910175213.GD4023@dhcp22.suse.cz>
 <1d7de9f9f4074f67c567dbb4cc1497503d739e30.camel@linux.intel.com>
 <20190911113619.GP4023@dhcp22.suse.cz>
 <20190911080804-mutt-send-email-mst@kernel.org>
 <20190911121941.GU4023@dhcp22.suse.cz> <20190911122526.GV4023@dhcp22.suse.cz>
 <4748a572-57b3-31da-0dde-30138e550c3a@redhat.com>
 <20190911125413.GY4023@dhcp22.suse.cz>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <736594d6-b9ae-ddb9-2b96-85648728ef33@redhat.com>
Date:   Wed, 11 Sep 2019 15:03:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911125413.GY4023@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Wed, 11 Sep 2019 13:03:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.09.19 14:54, Michal Hocko wrote:
> On Wed 11-09-19 14:42:41, David Hildenbrand wrote:
>> On 11.09.19 14:25, Michal Hocko wrote:
>>> On Wed 11-09-19 14:19:41, Michal Hocko wrote:
>>>> On Wed 11-09-19 08:08:38, Michael S. Tsirkin wrote:
>>>>> On Wed, Sep 11, 2019 at 01:36:19PM +0200, Michal Hocko wrote:
>>>>>> On Tue 10-09-19 14:23:40, Alexander Duyck wrote:
>>>>>> [...]
>>>>>>> We don't put any limitations on the allocator other then that it needs to
>>>>>>> clean up the metadata on allocation, and that it cannot allocate a page
>>>>>>> that is in the process of being reported since we pulled it from the
>>>>>>> free_list. If the page is a "Reported" page then it decrements the
>>>>>>> reported_pages count for the free_area and makes sure the page doesn't
>>>>>>> exist in the "Boundary" array pointer value, if it does it moves the
>>>>>>> "Boundary" since it is pulling the page.
>>>>>>
>>>>>> This is still a non-trivial limitation on the page allocation from an
>>>>>> external code IMHO. I cannot give any explicit reason why an ordering on
>>>>>> the free list might matter (well except for page shuffling which uses it
>>>>>> to make physical memory pattern allocation more random) but the
>>>>>> architecture seems hacky and dubious to be honest. It shoulds like the
>>>>>> whole interface has been developed around a very particular and single
>>>>>> purpose optimization.
>>>>>>
>>>>>> I remember that there was an attempt to report free memory that provided
>>>>>> a callback mechanism [1], which was much less intrusive to the internals
>>>>>> of the allocator yet it should provide a similar functionality. Did you
>>>>>> see that approach? How does this compares to it? Or am I completely off
>>>>>> when comparing them?
>>>>>>
>>>>>> [1] mostly likely not the latest version of the patchset
>>>>>> http://lkml.kernel.org/r/1502940416-42944-5-git-send-email-wei.w.wang@intel.com
>>>>>
>>>>> Linus nacked that one. He thinks invoking callbacks with lots of
>>>>> internal mm locks is too fragile.
>>>>
>>>> I would be really curious how much he would be happy about injecting
>>>> other restrictions on the allocator like this patch proposes. This is
>>>> more intrusive as it has a higher maintenance cost longterm IMHO.
>>>
>>> Btw. I do agree that callbacks with internal mm locks are not great
>>> either. We do have a model for that in mmu_notifiers and it is something
>>> I do consider PITA, on the other hand it is mostly sleepable part of the
>>> interface which makes it the real pain. The above callback mechanism was
>>> explicitly documented with restrictions and that the context is
>>> essentially atomic with no access to particular struct pages and no
>>> expensive operations possible. So in the end I've considered it
>>> acceptably painful. Not that I want to override Linus' nack but if
>>> virtualization usecases really require some form of reporting and no
>>> other way to do that push people to invent even more interesting
>>> approaches then we should simply give them/you something reasonable
>>> and least intrusive to our internals.
>>>
>>
>> The issue with "[PATCH v14 4/5] mm: support reporting free page blocks"
>>  is that it cannot really handle the use case we have here if I am not
>> wrong. While a page is getting processed by the hypervisor (e.g.
>> MADV_DONTNEED), it must not get reused.
> 
> What prevents to use the callback to get a list of pfn ranges to work on
> and then use something like start_isolate_page_range on the collected
> pfn ranges to make sure nobody steals pages from under your feet, do
> your thing and drop the isolated state afterwards.
> 
> I am saying somethig like because you wouldn't really want a generic
> has_unmovable_pages but rather
>                 if (!page_ref_count(page)) {
>                         if (PageBuddy(page))
>                                 iter += (1 << page_order(page)) - 1;
>                         continue;
>                 }
> subset of it.
> 

Something slightly similar is being performed by Nitesh's patch set. On
every free of a certain granularity, he records it in the bitmap. These
bits are "hints of free pages".

A thread then walks over the bitmap and tries to allocate the "hints".
If the pages were already reused, the bit is silently cleared.

Instead of allocating/freeing, we could only try to isolate the
pageblock, then test if free. (One of the usual issues to work around is
MAX_ORDER-1 crossing pageblocks, that might need special care)

I think you should have a look at the rough idea of Nitesh's patch set
to see if something like that is going into a better direction. The
bitmap part is in place to do bulk reporting and avoid duplicate reports.

I think main points we want (and what I am missing from callback idea
being discussed) are
1. Do bulk reporting only when a certain threshold is reached
2. Report only bigger granularities (especially, avoid THP splits in the
hypervisor - >= 2MB proofed to be effective)
3. Avoid reporting what has just been reported.
4. Continuously report, not the "one time report everything" approach.

-- 

Thanks,

David / dhildenb
