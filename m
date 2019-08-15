Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55C2D8EC87
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 15:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732156AbfHONPu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 15 Aug 2019 09:15:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49202 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732122AbfHONPt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 09:15:49 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A732C08E284;
        Thu, 15 Aug 2019 13:15:48 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DEAA10016E8;
        Thu, 15 Aug 2019 13:15:38 +0000 (UTC)
Subject: Re: [RFC][Patch v12 1/2] mm: page_reporting: core infrastructure
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, virtio-dev@lists.oasis-open.org,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        Pankaj Gupta <pagupta@redhat.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        john.starks@microsoft.com, Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@suse.com>, cohuck@redhat.com
References: <20190812131235.27244-1-nitesh@redhat.com>
 <20190812131235.27244-2-nitesh@redhat.com>
 <CAKgT0UcSabyrO=jUwq10KpJKLSuzorHDnKAGrtWVigKVgvD-6Q@mail.gmail.com>
 <6d5b57ca-41ff-5c54-ab20-2b1631a6ce29@redhat.com>
 <CAKgT0UfavuUT4ZvfxVdm3h25qc86ksxPO=GFpFkf8zbGAjHPvg@mail.gmail.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <09c6fbef-fa53-3a25-d3d6-460b9b6b2020@redhat.com>
Date:   Thu, 15 Aug 2019 09:15:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfavuUT4ZvfxVdm3h25qc86ksxPO=GFpFkf8zbGAjHPvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 15 Aug 2019 13:15:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/14/19 12:11 PM, Alexander Duyck wrote:
> On Wed, Aug 14, 2019 at 8:49 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
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
>>>> +}
>>>> +
>>>> +/**
>>>> + * __page_reporting_enqueue - tracks the freed page in the respective zone's
>>>> + * bitmap and enqueues a new page reporting job to the workqueue if possible.
>>>> + */
>>>> +void __page_reporting_enqueue(struct page *page)
>>>> +{
>>>> +       struct page_reporting_config *phconf;
>>>> +       struct zone *zone;
>>>> +
>>>> +       rcu_read_lock();
>>>> +       /*
>>>> +        * We should not process this page if either page reporting is not
>>>> +        * yet completely enabled or it has been disabled by the backend.
>>>> +        */
>>>> +       phconf = rcu_dereference(page_reporting_conf);
>>>> +       if (!phconf)
>>>> +               return;
>>>> +
>>>> +       zone = page_zone(page);
>>>> +       bitmap_set_bit(page, zone);
>>>> +
>>>> +       /*
>>>> +        * We should not enqueue a job if a previously enqueued reporting work
>>>> +        * is in progress or we don't have enough free pages in the zone.
>>>> +        */
>>>> +       if (atomic_read(&zone->free_pages) >= phconf->max_pages &&
>>>> +           !atomic_cmpxchg(&phconf->refcnt, 0, 1))
>>> This doesn't make any sense to me. Why are you only incrementing the
>>> refcount if it is zero? Combining this with the assignment above, this
>>> isn't really a refcnt. It is just an oversized bitflag.
>>
>> The intent for having an extra variable was to ensure that at a time only one
>> reporting job is enqueued. I do agree that for that purpose I really don't need
>> a reference counter and I should have used something like bool
>> 'page_hinting_active'. But with bool, I think there could be a possible chance
>> of race. Maybe I should rename this variable and keep it as atomic.
>> Any thoughts?
> You could just use a bitflag to achieve what you are doing here. That
> is the primary use case for many of the test_and_set_bit type
> operations. However one issue with doing it as a bitflag is that you
> have no way of telling that you took care of all requesters.

I think you are right, I might end up missing on certain reporting
opportunities in some special cases. Specifically when the pages which are
part of this new reporting request belongs to a section of the bitmap which
has already been scanned. Although, I have failed to reproduce this kind of
situation in an actual setup.

>  That is
> where having an actual reference count comes in handy as you know
> exactly how many zones are requesting to be reported on.


True.

>
>>> Also I am pretty sure this results in the opportunity to miss pages
>>> because there is nothing to prevent you from possibly missing a ton of
>>> pages you could hint on if a large number of pages are pushed out all
>>> at once and then the system goes idle in terms of memory allocation
>>> and freeing.
>>
>> I was looking at how you are enqueuing/processing reporting jobs for each zone.
>> I am wondering if I should also consider something on similar lines as having
>> that I might be able to address the concern which you have raised above. But it
>> would also mean that I have to add an additional flag in the zone_flags. :)
> You could do it either in the zone or outside the zone as yet another
> bitmap. I decided to put the flags inside the zone because there was a
> number of free bits there and it should be faster since we were
> already using the zone structure.

There are two possibilities which could happen while I am reporting:
1. Another request might come in for a different zone.
2. Another request could come in for the same zone and the pages belong to a
    section of the bitmap which has already been scanned.

Having a per zone flag to indicate reporting status will solve the first
issue and to an extent the second as well. Having refcnt will possibly solve
both of them. What I am wondering about is that in my case I could easily
impact the performance negatively by performing more bitmap scanning.


-- 
Thanks
Nitesh

