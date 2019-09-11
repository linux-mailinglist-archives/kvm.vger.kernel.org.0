Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5D8AF97B
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 11:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfIKJvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 05:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726702AbfIKJvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 05:51:08 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E7DF4197BCFD;
        Wed, 11 Sep 2019 09:51:07 +0000 (UTC)
Received: from [10.36.117.155] (ovpn-117-155.ams2.redhat.com [10.36.117.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC2526012A;
        Wed, 11 Sep 2019 09:50:54 +0000 (UTC)
Subject: Re: [virtio-dev] Re: [PATCH v9 0/8] stg mail -e --version=v9 \
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
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
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20190907172225.10910.34302.stgit@localhost.localdomain>
 <20190910124209.GY2063@dhcp22.suse.cz>
 <CAKgT0Udr6nYQFTRzxLbXk41SiJ-pcT_bmN1j1YR4deCwdTOaUQ@mail.gmail.com>
 <20190910144713.GF2063@dhcp22.suse.cz>
 <CAKgT0UdB4qp3vFGrYEs=FwSXKpBEQ7zo7DV55nJRO2C-KCEOrw@mail.gmail.com>
 <20190910161818.GF2797@work-vm>
 <f74117db-225d-92cb-9476-22c0f752659d@redhat.com>
 <20190911051819-mutt-send-email-mst@kernel.org>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <8923b919-af67-367f-9588-7f0c26a16831@redhat.com>
Date:   Wed, 11 Sep 2019 11:50:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911051819-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Wed, 11 Sep 2019 09:51:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.09.19 11:23, Michael S. Tsirkin wrote:
> On Tue, Sep 10, 2019 at 06:22:37PM +0200, David Hildenbrand wrote:
>> On 10.09.19 18:18, Dr. David Alan Gilbert wrote:
>>> * Alexander Duyck (alexander.duyck@gmail.com) wrote:
>>>> On Tue, Sep 10, 2019 at 7:47 AM Michal Hocko <mhocko@kernel.org> wrote:
>>>>>
>>>>> On Tue 10-09-19 07:42:43, Alexander Duyck wrote:
>>>>>> On Tue, Sep 10, 2019 at 5:42 AM Michal Hocko <mhocko@kernel.org> wrote:
>>>>>>>
>>>>>>> I wanted to review "mm: Introduce Reported pages" just realize that I
>>>>>>> have no clue on what is going on so returned to the cover and it didn't
>>>>>>> really help much. I am completely unfamiliar with virtio so please bear
>>>>>>> with me.
>>>>>>>
>>>>>>> On Sat 07-09-19 10:25:03, Alexander Duyck wrote:
>>>>>>> [...]
>>>>>>>> This series provides an asynchronous means of reporting to a hypervisor
>>>>>>>> that a guest page is no longer in use and can have the data associated
>>>>>>>> with it dropped. To do this I have implemented functionality that allows
>>>>>>>> for what I am referring to as unused page reporting
>>>>>>>>
>>>>>>>> The functionality for this is fairly simple. When enabled it will allocate
>>>>>>>> statistics to track the number of reported pages in a given free area.
>>>>>>>> When the number of free pages exceeds this value plus a high water value,
>>>>>>>> currently 32, it will begin performing page reporting which consists of
>>>>>>>> pulling pages off of free list and placing them into a scatter list. The
>>>>>>>> scatterlist is then given to the page reporting device and it will perform
>>>>>>>> the required action to make the pages "reported", in the case of
>>>>>>>> virtio-balloon this results in the pages being madvised as MADV_DONTNEED
>>>>>>>> and as such they are forced out of the guest. After this they are placed
>>>>>>>> back on the free list,
>>>>>>>
>>>>>>> And here I am reallly lost because "forced out of the guest" makes me
>>>>>>> feel that those pages are no longer usable by the guest. So how come you
>>>>>>> can add them back to the free list. I suspect understanding this part
>>>>>>> will allow me to understand why we have to mark those pages and prevent
>>>>>>> merging.
>>>>>>
>>>>>> Basically as the paragraph above mentions "forced out of the guest"
>>>>>> really is just the hypervisor calling MADV_DONTNEED on the page in
>>>>>> question. So the behavior is the same as any userspace application
>>>>>> that calls MADV_DONTNEED where the contents are no longer accessible
>>>>>> from userspace and attempting to access them will result in a fault
>>>>>> and the page being populated with a zero fill on-demand page, or a
>>>>>> copy of the file contents if the memory is file backed.
>>>>>
>>>>> As I've said I have no idea about virt so this doesn't really tell me
>>>>> much. Does that mean that if somebody allocates such a page and tries to
>>>>> access it then virt will handle a fault and bring it back?
>>>>
>>>> Actually I am probably describing too much as the MADV_DONTNEED is the
>>>> hypervisor behavior in response to the virtio-balloon notification. A
>>>> more thorough explanation of it can be found by just running "man
>>>> madvise", probably best just to leave it at that since I am probably
>>>> confusing things by describing hypervisor behavior in a kernel patch
>>>> set.
>>>>
>>>> For the most part all the page reporting really does is provide a way
>>>> to incrementally identify unused regions of memory in the buddy
>>>> allocator. That in turn is used by virtio-balloon in a polling thread
>>>> to report to the hypervisor what pages are not in use so that it can
>>>> make a decision on what to do with the pages now that it knows they
>>>> are unused.
>>>>
>>>> All this is providing is just a report and it is optional if the
>>>> hypervisor will act on it or not. If the hypervisor takes some sort of
>>>> action on the page, then the expectation is that the hypervisor will
>>>> use some sort of mechanism such as a page fault to discover when the
>>>> page is used again.
>>>
>>> OK, that's interestingly different (but OK) from some other schemes that
>>> hav ebeen described which *require* the guest to somehow indicate the
>>> page is in use before starting to use the page again.
>>>
>>
>> virtio-balloon also has a mode where the guest would not have to
>> indicate to the host before re-using a page. Only
>> VIRTIO_BALLOON_F_MUST_TELL_HOST enforces this. So it's not completely new.
> 
> VIRTIO_BALLOON_F_MUST_TELL_HOST is a bit different.
> When it's not set, guest still must tell host about
> pages in use, it just can batch these notifications
> sending them possibly after page has been used.
> So even with VIRTIO_BALLOON_F_MUST_TELL_HOST off you don't
> skip the notification.
> 

I don't think so

VIRTIO_BALLOON_F_MUST_TELL_HOST     0 /* Tell before reclaiming pages */

commit bf50e69f63d21091e525185c3ae761412be0ba72
Author: Dave Hansen <dave@linux.vnet.ibm.com>
Date:   Thu Apr 7 10:43:25 2011 -0700

    virtio balloon: kill tell-host-first logic

[...]

    But, if the bit is _not_ set, we are under no obligation to
    reverse the order; we're under no obligation to do _anything_.
    As of now, qemu-kvm defines the bit, but doesn't set it.


Old code simply told the hypervisor afterwards, but only for little
performance gain. It is not strictly necessary.

> From hypervisor point of view, this feature is very much like adding
> page to the balloon and immediately taking it out of the balloon again,
> just doing it in one operation.
> 
> The main difference is the contents of the page, which matters
> with poisoning: in that case hypervisor is expected to hand
> back page with the poisoning content. Not so with regular
> deflate where page contents is undefined.
> 
> Well and also the new interface is optimized for large chunks
> of memory since we'll likely be dealing with such.
> 
>>> Dave
>>
>>
>> -- 
>>
>> Thanks,
>>
>> David / dhildenb


-- 

Thanks,

David / dhildenb
