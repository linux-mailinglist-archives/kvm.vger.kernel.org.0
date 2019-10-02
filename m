Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93450C4B94
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 12:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfJBKhV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 2 Oct 2019 06:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfJBKhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 06:37:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E732B18C427E;
        Wed,  2 Oct 2019 10:37:19 +0000 (UTC)
Received: from [10.40.204.213] (ovpn-204-213.brq.redhat.com [10.40.204.213])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CC575D6A3;
        Wed,  2 Oct 2019 10:37:01 +0000 (UTC)
Subject: Re: [PATCH v11 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        virtio-dev@lists.oasis-open.org, kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
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
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <c06b68cb-5e94-ae3e-f84e-48087d675a8f@redhat.com>
Date:   Wed, 2 Oct 2019 06:36:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf37xAFK2CWqUZJgn7bWznSAi6qncLxBpC55oSpBMG1HQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Wed, 02 Oct 2019 10:37:20 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/1/19 8:55 PM, Alexander Duyck wrote:
> On Tue, Oct 1, 2019 at 12:16 PM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>>
>> On 10/1/19 12:21 PM, Alexander Duyck wrote:
>>> On Tue, 2019-10-01 at 17:35 +0200, David Hildenbrand wrote:
>>>> On 01.10.19 17:29, Alexander Duyck wrote:
>>>>> This series provides an asynchronous means of reporting to a hypervisor
>>>>> that a guest page is no longer in use and can have the data associated
>>>>> with it dropped. To do this I have implemented functionality that allows
>>>>> for what I am referring to as unused page reporting. The advantage of
>>>>> unused page reporting is that we can support a significant amount of
>>>>> memory over-commit with improved performance as we can avoid having to
>>>>> write/read memory from swap as the VM will instead actively participate
>>>>> in freeing unused memory so it doesn't have to be written.
>>>>>
>>>>> The functionality for this is fairly simple. When enabled it will allocate
>>>>> statistics to track the number of reported pages in a given free area.
>>>>> When the number of free pages exceeds this value plus a high water value,
>>>>> currently 32, it will begin performing page reporting which consists of
>>>>> pulling non-reported pages off of the free lists of a given zone and
>>>>> placing them into a scatterlist. The scatterlist is then given to the page
>>>>> reporting device and it will perform the required action to make the pages
>>>>> "reported", in the case of virtio-balloon this results in the pages being
>>>>> madvised as MADV_DONTNEED. After this they are placed back on their
>>>>> original free list. If they are not merged in freeing an additional bit is
>>>>> set indicating that they are a "reported" buddy page instead of a standard
>>>>> buddy page. The cycle then repeats with additional non-reported pages
>>>>> being pulled until the free areas all consist of reported pages.
>>>>>
>>>>> In order to try and keep the time needed to find a non-reported page to
>>>>> a minimum we maintain a "reported_boundary" pointer. This pointer is used
>>>>> by the get_unreported_pages iterator to determine at what point it should
>>>>> resume searching for non-reported pages. In order to guarantee pages do
>>>>> not get past the scan I have modified add_to_free_list_tail so that it
>>>>> will not insert pages behind the reported_boundary. Doing this allows us
>>>>> to keep the overhead to a minimum as re-walking the list without the
>>>>> boundary will result in as much as 18% additional overhead on a 32G VM.
>>>>>
>>>>>
>>> <snip>
>>>
>>>>> As far as possible regressions I have focused on cases where performing
>>>>> the hinting would be non-optimal, such as cases where the code isn't
>>>>> needed as memory is not over-committed, or the functionality is not in
>>>>> use. I have been using the will-it-scale/page_fault1 test running with 16
>>>>> vcpus and have modified it to use Transparent Huge Pages. With this I see
>>>>> almost no difference with the patches applied and the feature disabled.
>>>>> Likewise I see almost no difference with the feature enabled, but the
>>>>> madvise disabled in the hypervisor due to a device being assigned. With
>>>>> the feature fully enabled in both guest and hypervisor I see a regression
>>>>> between -1.86% and -8.84% versus the baseline. I found that most of the
>>>>> overhead was due to the page faulting/zeroing that comes as a result of
>>>>> the pages having been evicted from the guest.
>>>> I think Michal asked for a performance comparison against Nitesh's
>>>> approach, to evaluate if keeping the reported state + tracking inside
>>>> the buddy is really worth it. Do you have any such numbers already? (or
>>>> did my tired eyes miss them in this cover letter? :/)
>>>>
>>> I thought what Michal was asking for was what was the benefit of using the
>>> boundary pointer. I added a bit up above and to the description for patch
>>> 3 as on a 32G VM it adds up to about a 18% difference without factoring in
>>> the page faulting and zeroing logic that occurs when we actually do the
>>> madvise.
>>>
>>> Do we have a working patch set for Nitesh's code? The last time I tried
>>> running his patch set I ran into issues with kernel panics. If we have a
>>> known working/stable patch set I can give it a try.
>> Did you try the v12 patch-set [1]?
>> I remember that you reported the CPU stall issue, which I fixed in the v12.
>>
>> [1] https://lkml.org/lkml/2019/8/12/593
> So I tried testing with the spin_lock calls replaced with spin_lock
> _irq to resolve the IRQ issue. I also had shuffle enabled in order to
> increase the number of pages being dirtied.
>
> With that setup the bitmap approach is running significantly worse
> then my approach, even with the boundary removed. Since I had to
> modify the code to even getting working I am not comfortable posting
> numbers. 

I didn't face any issue in getting the code work or compile.
Before my v12 posting, I did try your previously suggested test
(will-it-scale/page_fault1 for 12 hours on a 60 GB) and didn't see any issues.
I think it would help more if you can share the setup which you are running.

> My suggestion would be to look at reworking the patch set and
> post numbers for my patch set versus the bitmap approach and we can
> look at them then.

Agreed. However, in order to fix an issue I have to reproduce it first.

>  I would prefer not to spend my time fixing and
> tuning a patch set that I am still not convinced is viable.

You  don't have to, I can fix the issues in my patch-set. :)

>
> Thanks.
>
> - Alex
-- 
Nitesh

