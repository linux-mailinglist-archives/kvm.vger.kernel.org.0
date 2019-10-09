Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1E0D1932
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 21:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbfJITq5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 9 Oct 2019 15:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728804AbfJITq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 15:46:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 880737F746;
        Wed,  9 Oct 2019 19:46:56 +0000 (UTC)
Received: from [10.40.204.38] (ovpn-204-38.brq.redhat.com [10.40.204.38])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AA8D1001B35;
        Wed,  9 Oct 2019 19:46:35 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
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
 <5c640ecb-cfef-2fa6-57aa-1352f1036f4e@redhat.com>
 <22ce946f7a5cf0b7b4c8058c400d8b9b4c63a5a5.camel@linux.intel.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <2e1cff42-7b82-c0a0-3007-fde79fefcfa3@redhat.com>
Date:   Wed, 9 Oct 2019 15:46:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <22ce946f7a5cf0b7b4c8058c400d8b9b4c63a5a5.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 09 Oct 2019 19:46:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/9/19 12:35 PM, Alexander Duyck wrote:
> On Wed, 2019-10-09 at 11:21 -0400, Nitesh Narayan Lal wrote:
>> On 10/7/19 1:06 PM, Nitesh Narayan Lal wrote:
>> [...]
>>>> So what was the size of your guest? One thing that just occurred to me is
>>>> that you might be running a much smaller guest than I was.
>>> I am running a 30 GB guest.
>>>
>>>>>>  If so I would have expected a much higher difference versus
>>>>>> baseline as zeroing/faulting the pages in the host gets expensive fairly
>>>>>> quick. What is the host kernel you are running your test on? I'm just
>>>>>> wondering if there is some additional overhead currently limiting your
>>>>>> setup. My host kernel was just the same kernel I was running in the guest,
>>>>>> just built without the patches applied.
>>>>> Right now I have a different host-kernel. I can install the same kernel to the
>>>>> host as well and see if that changes anything.
>>>> The host kernel will have a fairly significant impact as I recall. For
>>>> example running a stock CentOS kernel lowered the performance compared to
>>>> running a linux-next kernel. As a result the numbers looked better since
>>>> the overall baseline was lower to begin with as the host OS was
>>>> introducing additional overhead.
>>> I see in that case I will try by installing the same guest kernel
>>> to the host as well.
>> As per your suggestion, I tried replacing the host kernel with an
>> upstream kernel without my patches i.e., my host has a kernel built on top
>> of the upstream kernel's master branch which has Sept 23rd commit and the guest
>> has the same kernel for the no-hinting case and same kernel + my patches
>> for the page reporting case.
>>
>> With the changes reported earlier on top of v12, I am not seeing any further
>> degradation (other than what I have previously reported).
>>
>> To be sure that THP is actively used, I did an experiment where I changed the
>> MEMSIZE in the page_fault. On doing so THP usage checked via /proc/meminfo also
>> increased as I expected.
>>
>> In any case, if you find something else please let me know and I will look into it
>> again.
>>
>>
>> I am still looking into your suggestion about cache line bouncing and will reply
>> to it, if I have more questions.
>>
>>
>> [...]
> I really feel like this discussion has gone off course. The idea here is
> to review this patch set[1] and provide working alternatives if there are
> issues with the current approach.


Agreed.

>
> The bitmap based approach still has a number of outstanding issues
> including sparse memory and hotplug which have yet to be addressed.

True, but I don't think those two are a blocker.

For sparse zone as we are maintaining the bitmap on a granularity of
(MAX_ORDER - 2) / (MAX_ORDER - 1) etc. the memory wastage should be
negligible in most of the cases.

For memory hotplug/hotremove, I did make sure that I don't break anything.
Even if a user starts using this feature with page-reporting enabled.
However, it is true that I don't report or capture any memory added/removed
thought it.

Fixing these issues will be an optimization which I will do as I get my basic
framework ready and in shape.

>  We can
> gloss over that, but there is a good chance that resolving those would
> have potential performance implications. With this most recent change
> there is now also the fact that it can only really support reporting at
> one page order so the solution is now much more prone to issues with
> memory fragmentation than it was before. I would consider the fact that my
> solution works with multiple page orders while the bitmap approach
> requires MAX_ORDER - 1 seems like another obvious win for my solution.

This is just a configuration change and only requires to update
the macro 'PAGE_REPORTING_MIN_ORDER' to what you are using.

What order do we want to report could vary based on the
use case where we are deploying the solution.

Ideally, this should be configurable maybe at the compile time
or we can stick with pageblock_order which is originally suggested
and used by you.

> Until we can get back to the point where we are comparing apples to apples
> I would prefer not to benchmark the bitmap solution as without the extra
> order limitation it was over 20% worse then my solution performance wise..

Understood.
However, as I reported previously after making the configuration changes
on top of v12 posting, I don't see the degradation.

I will be happy to try out more suggestions to see if the issue is really fixed.

I have started looking into your concern of cacheline bouncing after
which I will look into Michal's suggestion of using page-isolation APIs to
isolate and release pages back. After that, I can decide on
posting my next series (if it is required).

>
> Ideally I would like to get code review for patches 3 and 4, and spend my
> time addressing issues reported there. The main things I need input on is
> if the solution of allowing the list iterators to be reset is good enough
> to address the compaction issues that were pointed out several releases
> ago or if I have to look for another solution. Also I have changed things
> so that page_reporting.h was split over two files with the new one now
> living in the mm/ folder. By doing that I was hoping to reduce the
> exposure of the internal state of the free-lists so that essentially all
> we end up providing is an interface for the notifier to be used by virtio-
> balloon.

If everyone agrees that what you are proposing is the best way to move
forward then, by all means, lets go ahead with it. :)

>
> Thanks.
>
> - Alex
>
> [1]: https://lore.kernel.org/lkml/20191001152441.27008.99285.stgit@localhost.localdomain/
>
-- 
Thanks
Nitesh

