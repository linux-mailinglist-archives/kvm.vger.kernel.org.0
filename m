Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7B7AFCC8
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 14:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbfIKMa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 08:30:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbfIKMa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 08:30:27 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 851E818CCF03;
        Wed, 11 Sep 2019 12:30:26 +0000 (UTC)
Received: from [10.36.117.155] (ovpn-117-155.ams2.redhat.com [10.36.117.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEF2F5DD61;
        Wed, 11 Sep 2019 12:30:04 +0000 (UTC)
Subject: Re: [RFC][PATCH v12 0/2] mm: Support for page reporting
To:     Nitesh Narayan Lal <nitesh@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org, pbonzini@redhat.com,
        lcapitulino@redhat.com, pagupta@redhat.com, wei.w.wang@intel.com,
        yang.zhang.wz@gmail.com, riel@surriel.com, mst@redhat.com,
        dodgen@google.com, konrad.wilk@oracle.com, dhildenb@redhat.com,
        aarcange@redhat.com, alexander.duyck@gmail.com,
        john.starks@microsoft.com, dave.hansen@intel.com, mhocko@suse.com,
        cohuck@redhat.com
References: <20190812131235.27244-1-nitesh@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
 SE+xAvmumFBY
Organization: Red Hat GmbH
Message-ID: <356b752f-7f5c-a6f7-c643-8ffb49c27a67@redhat.com>
Date:   Wed, 11 Sep 2019 14:30:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812131235.27244-1-nitesh@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 11 Sep 2019 12:30:26 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12.08.19 15:12, Nitesh Narayan Lal wrote:
> This patch series proposes an efficient mechanism for reporting free memory
> from a guest to its hypervisor. It especially enables guests with no page cache
> (e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > disk) to
> rapidly hand back free memory to the hypervisor.
> This approach has a minimal impact on the existing core-mm infrastructure.
> 
> This approach tracks all freed pages of the order MAX_ORDER - 2 in bitmaps.
> A new hook after buddy merging is used to set the bits in the bitmap for a freed 
> page. Each set bit is cleared after they are processed/checked for
> re-allocation.
> Bitmaps are stored on a per-zone basis and are protected by the zone lock. A
> workqueue asynchronously processes the bitmaps as soon as a pre-defined memory
> threshold is met, trying to isolate and report pages that are still free.
> The isolated pages are stored in a scatterlist and are reported via
> virtio-balloon, which is responsible for sending batched pages to the
> hypervisor. Once the hypervisor processed the reporting request, the isolated
> pages are returned back to the buddy.
> The thershold which defines the number of pages which will be isolated and
> reported to the hypervisor at a time is currently hardcoded to 16 in the guest.
> 
> Benefit analysis:
> Number of 5 GB guests (each touching 4 to 5 GB memory) that can be launched on a
> 15 GB single NUMA system without using swap space in the host.
> 
> 	    Guest kernel-->	Unmodified		with v12 page reporting
> 	Number of guests-->	    2				7
> 
> Conclusion: In a page-reporting enabled kernel, the guest is able to report
> most of its unused memory back to the host. Due to this on the same host, I was
> able to launch 7 guests without touching any swap compared to 2 which were
> launched with an unmodified kernel.
> 
> Performance Analysis:
> In order to measure the performance impact of this patch-series over an
> unmodified kernel, I am using will-it-scale/page_fault1 on a 30 GB, 24 vcpus
> single NUMA guest which is affined to a single node in the host. Over several
> runs, I observed that with this patch-series there is a degradation of around
> 1-3% for certain cases. This degradation could be a result of page-zeroing
> overhead which comes with every page-fault in the guest.
> I also tried this test on a 2 NUMA node host running page reporting
> enabled 60GB guest also having 2 NUMA nodes and 24 vcpus. I observed a similar
> degradation of around 1-3% in most of the cases.
> For certain cases, the variability even with an unmodified kernel was around
> 4-6% with every fresh boot. I will continue to investigate this further to find
> the reason behind it.
> 
> Ongoing work-items:
> * I have a working prototype for supporting memory hotplug/hotremove with page
>   reporting. However, it still requires more testing and fixes specifically on
>   the hotremove side.
>   Right now, for any memory hotplug or hotremove request bitmap or its
>   respective fields are not changed. Hence, memory added via hotplug is not
>   tracked in the bitmap. Similarly, removed memory is not reported to the
>   hypervisor by using an online memory check. 
> * I will also have to look into the details about how to handle page poisoning
>   scenarios and test with directly assigned devices.
> 
> 
> Changes from v11:
> https://lkml.org/lkml/2019/7/10/742
> * Moved the fields required to manage bitmap of free pages to 'struct zone'.
> * Replaced the list which was used to hold and report the free pages with
>   scatterlist.
> * Tried to fix the anti-kernel patterns and improve overall code quality.
> * Fixed a few bugs in the code which were reported in the last posting.
> * Moved to use MADV_DONTNEED from MADV_FREE.
> * Replaced page hinting in favor of page reporting.
> * Addressed other comments which I received in the last posting.	
> 
> 
> Changes from v10:
> https://lkml.org/lkml/2019/6/3/943
> * Added logic to take care of multiple NUMA nodes scenarios.
> * Simplified the logic for reporting isolated pages to the host. (Eg. replaced
>   dynamically allocated arrays with static ones, introduced wait event instead
>   of the loop in order to wait for a response from the host)
> * Added a mutex to prevent race condition when page reporting is enabled by
>   multiple drivers.
> * Simplified the logic responsible for decrementing free page counter for each
>   zone.
> * Simplified code structuring/naming.
>  

Some current limitations of this patchset seem to be

1. Sparse zones eventually wasting memory (1bit per 2MB).

As I already set, I consider this in most virtual environments a special
case (especially a lot of sparsity). You can simply compare the spanned
vs. present pages and don't allocate a bitmap in case it's too sparse
("currently unsupported environment"). These pieces won't be considered
for free page reporting, however free page reporting is a pure
optimization already either way. We can be smarter in the future (split
up bitmap into sub-bitmaps ...)

2. Memory hot(un)plug support

Memory hotplug should be easy with the memory hotplug notifier. Resize
bitmaps after hotplug if required. Hotunplug is tricky, as it depends on
zone shrinking (shrink bitmaps after offlining). You could scan for
actually online section manually. But with minor modifications after
"[PATCH v4 0/8] mm/memory_hotplug: Shrink zones before removing memory",
at least some cases could also be handled. (sparse handling similar to
1). Of course, initially, you could also simply not try to shrink the
bitmap on unplug ...

3. Scanning speed

I have no idea if that is actually an issue. But there are different
options if it is, for example, a hierarchical bitmap.


Besides these, I think there were other review comments that should be
addressed, but they don't seem to target the concept but rather
implementation details.

-- 

Thanks,

David / dhildenb
