Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B1CB0E6C
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2019 14:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbfILMAw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 12 Sep 2019 08:00:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731106AbfILMAv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 08:00:51 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F289E10DCC8F;
        Thu, 12 Sep 2019 12:00:50 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 75FC05F9C4;
        Thu, 12 Sep 2019 12:00:46 +0000 (UTC)
Subject: Re: [PATCH v9 0/8] stg mail -e --version=v9 \
To:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@kernel.org>
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
References: <20190911113619.GP4023@dhcp22.suse.cz>
 <20190911080804-mutt-send-email-mst@kernel.org>
 <20190911121941.GU4023@dhcp22.suse.cz> <20190911122526.GV4023@dhcp22.suse.cz>
 <4748a572-57b3-31da-0dde-30138e550c3a@redhat.com>
 <20190911125413.GY4023@dhcp22.suse.cz>
 <736594d6-b9ae-ddb9-2b96-85648728ef33@redhat.com>
 <20190911132002.GA4023@dhcp22.suse.cz> <20190911135100.GC4023@dhcp22.suse.cz>
 <abea20a0-463c-68c0-e810-2e341d971b30@redhat.com>
 <20190912071633.GL4023@dhcp22.suse.cz>
 <ef460202-cebd-c6d2-19f3-e8a82a3d3cbd@redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <880cb776-a5c0-026c-6c50-3d8d3c2bb2df@redhat.com>
Date:   Thu, 12 Sep 2019 08:00:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ef460202-cebd-c6d2-19f3-e8a82a3d3cbd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 12 Sep 2019 12:00:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/12/19 3:47 AM, David Hildenbrand wrote:
> On 12.09.19 09:16, Michal Hocko wrote:
>> On Wed 11-09-19 18:09:18, David Hildenbrand wrote:
>>> On 11.09.19 15:51, Michal Hocko wrote:
>>>> On Wed 11-09-19 15:20:02, Michal Hocko wrote:
>>>> [...]
>>>>>> 4. Continuously report, not the "one time report everything" approach.
>>>>> So you mean the allocator reporting this rather than an external code to
>>>>> poll right? I do not know, how much this is nice to have than must have?
>>>> Another idea that I haven't really thought through so it might turned
>>>> out to be completely bogus but let's try anyway. Your "report everything"
>>>> just made me look and realize that free_pages_prepare already performs
>>>> stuff that actually does something similar yet unrelated.
>>>>
>>>> We do report to special page poisoning, zeroying or
>>>> CONFIG_DEBUG_PAGEALLOC to unmap the address from the kernel address
>>>> space. This sounds like something fitting your model no?
>>>>
>>> AFAIKS, the poisoning/unmapping is done whenever a page is freed. I
>>> don't quite see yet how that would help to remember if a page was
>>> already reported.
>> Do you still have to differ that state when each page is reported?
> Ah, very good point. I can see that the reason for this was not
> discussed in this thread so far. (Alexander, Nitesh, please correct me
> if I am wrong). It's buried in the long history of free page
> hinting/reporting.
>
> Some early patch sets tried to report during every free synchronously.
> Free a page, report them to the hypervisor. This resulted in some issues
> (especially, locking-related and the virtio + the hypervisor being
> involved, resulting in unpredictable delays, quite some overhead ...).
> It was no good.

+1
If I remember correctly then Alexander had posted a patch-set
prior to this series where he was reporting every page of a fixed
order from __free_one_page(). But as you said it will be costly as
it will involve one hypercall per page of reporting_order.

>
> One design decision then was to not report single pages, but a bunch of
> pages at once. This made it necessary to "remember" the pages to be
> reported and to temporarily block them from getting allocated while
> reporting.

Until my v7 posting [1] I was doing this. We did not proceed with
this as blocking allocation was not recommended for reporting.

>
> Nitesh implemented (at least) two "capture PFNs of free pages in an
> array when freeing" approaches. One being synchronous from the freeing
> CPU once the list was full (having similar issues as plain synchronous
> reporting) and one being asynchronous by a separate thread (which solved
> many locking issues).

One issue with asynchronous + array approach was that it could have lead
to false OOMs due to several pages being isolated at the same time.

>
> Turned out the a simple array can quickly lead to us having to drop
> "reports" to the hypervisor because the array is full and the reporting
> thread was not able to keep up. Not good as well. Especially, if some
> process frees a lot of memory this can happen quickly and Nitesh wa
> sable to trigger this scenario frequently.

+1

>
> Finally, Nitesh decided to use the bitmap instead to keep track of pages
> to report. I'd like to note that this approach could still be combined
> with an "array of potentially free PFNs". Only when the array/circular
> buffer runs out of entries ("reporting thread cannot keep up"), we would
> have to go back to scanning the bitmap.

I will have to think about it.

> That was also the point where Alexander decided to look into integrating
> tracking/handling reported/unreported pages directly in the buddy.
>
>>> After reporting the page we would have to switch some
>>> state (Nitesh: bitmap bit, Alexander: page flag) to identify that.
>> Yes, you can either store the state somewhere.
>>
>>> Of course, we could map the page and treat that as "the state" when we
>>> reported it, but I am not sure that's such a good idea :)
>>>
>>> As always, I might be very wrong ...
>> I still do not fully understand the usecase so I might be equally wrong.
>> My thinking is along these lines. Why should you scan free pages when
>> you can effectively capture each freed page? If you go one step further
>> then post_alloc_hook would be the counterpart to know that your page has
>> been allocated.
> I'd like to note that Nitesh's patch set contains the following hunk,
> which is roughly what you were thinking :)
>
>
> -static inline void __free_one_page(struct page *page,
> +inline void __free_one_page(struct page *page,
>  		unsigned long pfn,
>  		struct zone *zone, unsigned int order,
> -		int migratetype)
> +		int migratetype, bool hint)
>  {
>  	unsigned long combined_pfn;
>  	unsigned long uninitialized_var(buddy_pfn);
> @@ -980,7 +981,8 @@ static inline void __free_one_page(struct page *page,
>  				migratetype);
>  	else
>  		add_to_free_area(page, &zone->free_area[order], migratetype);
> -
> +	if (hint)
> +		page_hinting_enqueue(page, order);
>  }
>
>
> (ignore the hint parameter, when he would switch to a isolate vs.
> alloc/free, that can go away and all we left is the enqueue part)

Precisely.
Although, there would be a scenario where the allocation will
take place for a page whose order would be < REPORTING_ORDER.
In that case, if I decide to ignore all the remaining pages and clear
the previously head free page bit, I might end
up losing the reporting opportunity.

But I can certainly look into this.

>
>
> Inside that callback we can remember the pages any way we want. Right
> now in a bitmap. Maybe later in a array + bitmap (as discussed above).
> Another idea I had was to simply go over all pages and report them when
> running into this "array full" condition. But I am not yet sure about
> the performance implications on rather large machines. So the bitmap
> idea might have some other limitations but seems to do its job.

That's correct, I was actually trying to come up with a basic framework.
Which is acceptable in terms of benefits and performance and that can fit into
most of the use-cases (if not all).
After which my plan was to further optimize it.

>
> Hoe that makes things clearer and am not missing something.

Thanks for explaining.

>
-- 
Thanks
Nitesh

