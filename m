Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7370DD21E9
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 09:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbfJJHje (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 03:39:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733090AbfJJHgc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 03:36:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6D6A980F81;
        Thu, 10 Oct 2019 07:36:31 +0000 (UTC)
Received: from [10.36.117.125] (ovpn-117-125.ams2.redhat.com [10.36.117.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0AB95DD64;
        Thu, 10 Oct 2019 07:36:17 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc:     LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
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
 <2e1cff42-7b82-c0a0-3007-fde79fefcfa3@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <9d8c6fb8-5ba2-9968-bb1c-13f3e92b8896@redhat.com>
Date:   Thu, 10 Oct 2019 09:36:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <2e1cff42-7b82-c0a0-3007-fde79fefcfa3@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 10 Oct 2019 07:36:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09.10.19 21:46, Nitesh Narayan Lal wrote:
> 
> On 10/9/19 12:35 PM, Alexander Duyck wrote:
>> On Wed, 2019-10-09 at 11:21 -0400, Nitesh Narayan Lal wrote:
>>> On 10/7/19 1:06 PM, Nitesh Narayan Lal wrote:
>>> [...]
>>>>> So what was the size of your guest? One thing that just occurred to me is
>>>>> that you might be running a much smaller guest than I was.
>>>> I am running a 30 GB guest.
>>>>
>>>>>>>  If so I would have expected a much higher difference versus
>>>>>>> baseline as zeroing/faulting the pages in the host gets expensive fairly
>>>>>>> quick. What is the host kernel you are running your test on? I'm just
>>>>>>> wondering if there is some additional overhead currently limiting your
>>>>>>> setup. My host kernel was just the same kernel I was running in the guest,
>>>>>>> just built without the patches applied.
>>>>>> Right now I have a different host-kernel. I can install the same kernel to the
>>>>>> host as well and see if that changes anything.
>>>>> The host kernel will have a fairly significant impact as I recall. For
>>>>> example running a stock CentOS kernel lowered the performance compared to
>>>>> running a linux-next kernel. As a result the numbers looked better since
>>>>> the overall baseline was lower to begin with as the host OS was
>>>>> introducing additional overhead.
>>>> I see in that case I will try by installing the same guest kernel
>>>> to the host as well.
>>> As per your suggestion, I tried replacing the host kernel with an
>>> upstream kernel without my patches i.e., my host has a kernel built on top
>>> of the upstream kernel's master branch which has Sept 23rd commit and the guest
>>> has the same kernel for the no-hinting case and same kernel + my patches
>>> for the page reporting case.
>>>
>>> With the changes reported earlier on top of v12, I am not seeing any further
>>> degradation (other than what I have previously reported).
>>>
>>> To be sure that THP is actively used, I did an experiment where I changed the
>>> MEMSIZE in the page_fault. On doing so THP usage checked via /proc/meminfo also
>>> increased as I expected.
>>>
>>> In any case, if you find something else please let me know and I will look into it
>>> again.
>>>
>>>
>>> I am still looking into your suggestion about cache line bouncing and will reply
>>> to it, if I have more questions.
>>>
>>>
>>> [...]
>> I really feel like this discussion has gone off course. The idea here is
>> to review this patch set[1] and provide working alternatives if there are
>> issues with the current approach.
> 
> 
> Agreed.
> 
>>
>> The bitmap based approach still has a number of outstanding issues
>> including sparse memory and hotplug which have yet to be addressed.
> 
> True, but I don't think those two are a blocker.
> 
> For sparse zone as we are maintaining the bitmap on a granularity of
> (MAX_ORDER - 2) / (MAX_ORDER - 1) etc. the memory wastage should be
> negligible in most of the cases.
> 
> For memory hotplug/hotremove, I did make sure that I don't break anything.
> Even if a user starts using this feature with page-reporting enabled.
> However, it is true that I don't report or capture any memory added/removed
> thought it.
> 
> Fixing these issues will be an optimization which I will do as I get my basic
> framework ready and in shape.
> 
>>  We can
>> gloss over that, but there is a good chance that resolving those would
>> have potential performance implications. With this most recent change
>> there is now also the fact that it can only really support reporting at
>> one page order so the solution is now much more prone to issues with
>> memory fragmentation than it was before. I would consider the fact that my
>> solution works with multiple page orders while the bitmap approach
>> requires MAX_ORDER - 1 seems like another obvious win for my solution.
> 
> This is just a configuration change and only requires to update
> the macro 'PAGE_REPORTING_MIN_ORDER' to what you are using.
> 
> What order do we want to report could vary based on the
> use case where we are deploying the solution.
> 
> Ideally, this should be configurable maybe at the compile time
> or we can stick with pageblock_order which is originally suggested
> and used by you.
> 
>> Until we can get back to the point where we are comparing apples to apples
>> I would prefer not to benchmark the bitmap solution as without the extra
>> order limitation it was over 20% worse then my solution performance wise..
> 
> Understood.
> However, as I reported previously after making the configuration changes
> on top of v12 posting, I don't see the degradation.
> 
> I will be happy to try out more suggestions to see if the issue is really fixed.
> 
> I have started looking into your concern of cacheline bouncing after
> which I will look into Michal's suggestion of using page-isolation APIs to
> isolate and release pages back. After that, I can decide on
> posting my next series (if it is required).
> 
>>
>> Ideally I would like to get code review for patches 3 and 4, and spend my
>> time addressing issues reported there. The main things I need input on is
>> if the solution of allowing the list iterators to be reset is good enough
>> to address the compaction issues that were pointed out several releases
>> ago or if I have to look for another solution. Also I have changed things
>> so that page_reporting.h was split over two files with the new one now
>> living in the mm/ folder. By doing that I was hoping to reduce the
>> exposure of the internal state of the free-lists so that essentially all
>> we end up providing is an interface for the notifier to be used by virtio-
>> balloon.
> 
> If everyone agrees that what you are proposing is the best way to move
> forward then, by all means, lets go ahead with it. :)
> 

Sorry, i didn't get to follow the discussion, caught a cold and my body
is still fighting with the last resistance.

Is there any rough summary on how much faster Alexanders approach is
compared to some external tracking? For external tracking, there is a
lot of optimization potential as far as I can read, however, I think a
rough summary should be possible by now "how far we are off".

Also, are there benchmarks/setups where both perform the same?


-- 

Thanks,

David / dhildenb
