Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F91611E15E
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 11:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLMKBB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 05:01:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55494 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726016AbfLMKBA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 05:01:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576231259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=sDfkzegf+YvU6Y6VD7ofOSD/W9ZKRpULuRJ7odfg5Qk=;
        b=ErjWMT1oAUxs6f/EXs2eWbJn5ZVruktT2CsjZHm3ZzgRf+qOAeupVCYDsCQDRPG8O2DrPP
        k6ryOHDqQCV4N+JTKOqcaFoae99xFLYcsCGf20rnR+WDE6/+biysz0aOilyJQSqe/ZmvLr
        SvlwYd0Xw0Rh5kdWpyxhIFFA7Xwdsk0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-BtdW1kXHN1m_wH_pGN9QnA-1; Fri, 13 Dec 2019 05:00:57 -0500
X-MC-Unique: BtdW1kXHN1m_wH_pGN9QnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 423FE1005510;
        Fri, 13 Dec 2019 10:00:55 +0000 (UTC)
Received: from [10.36.117.150] (ovpn-117-150.ams2.redhat.com [10.36.117.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 232B2601B6;
        Fri, 13 Dec 2019 10:00:42 +0000 (UTC)
Subject: Re: [PATCH v15 0/7] mm / virtio: Provide support for free page
 reporting
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
From:   David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat GmbH
Message-ID: <ead08075-c886-dc7d-2c7b-47b20e00b515@redhat.com>
Date:   Fri, 13 Dec 2019 11:00:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191205161928.19548.41654.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05.12.19 17:22, Alexander Duyck wrote:
> This series provides an asynchronous means of reporting free guest page=
s
> to a hypervisor so that the memory associated with those pages can be
> dropped and reused by other processes and/or guests on the host. Using
> this it is possible to avoid unnecessary I/O to disk and greatly improv=
e
> performance in the case of memory overcommit on the host.
>=20
> When enabled we will be performing a scan of free memory every 2 second=
s
> while pages of sufficiently high order are being freed. Currently the o=
rder
> used is pageblock_order so that this feature will not interfere with th=
e
> use of Transparent Huge Pages in the case of virtualization.
>=20
> Currently this is only in use by virtio-balloon however there is the ho=
pe
> that at some point in the future other hypervisors might be able to mak=
e
> use of it. In the virtio-balloon/QEMU implementation the hypervisor is
> currently using MADV_DONTNEED to indicate to the host kernel that the p=
age
> is currently free. It will be zeroed and faulted back into the guest th=
e
> next time the page is accessed.
>=20
> To track if a page is reported or not the Uptodate flag was repurposed =
and
> used as a Reported flag for Buddy pages. We walk though the free list
> isolating pages and adding them to the scatterlist until we either
> encounter the end of the list, processed as many pages as were listed i=
n
> nr_free prior to us starting, or have filled the scatterlist with pages=
 to
> be reported. If we fill the scatterlist before we reach the end of the
> list we rotate the list so that the first unreported page we encounter =
is
> moved to the head of the list as that is where we will resume after we
> have freed the reported pages back into the tail of the list.
>=20
> Below are the results from various benchmarks. I primarily focused on t=
wo
> tests. The first is the will-it-scale/page_fault2 test, and the other i=
s
> a modified version of will-it-scale/page_fault1 that was enabled to use
> THP. I did this as it allows for better visibility into different parts
> of the memory subsystem. The guest is running with 32G for RAM on one
> node of a E5-2630 v3. The host has had some power saving features disab=
led
> by setting the /dev/cpu_dma_latency value to 10ms.
>=20
> Test                   page_fault1 (THP)    page_fault2
> Name            tasks  Process Iter  STDEV  Process Iter  STDEV
> Baseline            1    1208307.25  0.10%     408596.00  0.19%
>                    16    8865204.75  0.16%    3344169.00  0.60%
>=20
> Patches applied     1    1206809.00  0.26%     412558.25  0.32%
>                    16    8814350.50  0.78%    3420102.00  1.16%
>=20
> Patches enabled     1    1201386.25  0.21%     407903.75  0.32%
>                    16    8880178.00  0.08%    3396700.50  0.54%
>=20
> Patches enabled     1    1173529.00  1.04%     409006.50  0.45%
>  page shuffle      16    8384540.25  0.74%    3288289.25  0.41%
>=20
> Patches enabled     1    1193411.00  0.33%     406333.50  0.09%
>  shuffle w/ RFC    16    8812639.75  0.73%    3321706.25  0.53%
>=20
> The results above are for a baseline with a linux-next-20191203 kernel,
> that kernel with this patch set applied but page reporting disabled in
> virtio-balloon, the patches applied and page reporting fully enabled, t=
he
> patches enabled with page shuffling enabled, and the patches applied wi=
th
> page shuffling enabled and an RFC patch that makes used of MADV_FREE in
> QEMU. These results include the deviation seen between the average valu=
e
> reported here versus the high and/or low value. I observed that during =
the
> test memory usage for the first three tests never dropped whereas with =
the
> patches fully enabled the VM would drop to using only a few GB of the
> host's memory when switching from memhog to page fault tests.
>=20
> Any of the overhead visible with this patch set enabled seems due to pa=
ge
> faults caused by accessing the reported pages and the host zeroing the =
page
> before giving it back to the guest. This overhead is much more visible =
when
> using THP than with standard 4K pages. In addition page shuffling seeme=
d to
> increase the amount of faults generated due to an increase in memory ch=
urn.
> As seen in the data above, using MADV_FREE in QEMU mostly eliminates th=
is
> overhead.
>=20
> The overall guest size is kept fairly small to only a few GB while the =
test
> is running. If the host memory were oversubscribed this patch set shoul=
d
> result in a performance improvement as swapping memory in the host can =
be
> avoided.
>=20
> A brief history on the background of free page reporting can be found a=
t:
> https://lore.kernel.org/lkml/29f43d5796feed0dec8e8bb98b187d9dac03b900.c=
amel@linux.intel.com/
>=20
> Changes from v13:
> https://lore.kernel.org/lkml/20191105215940.15144.65968.stgit@localhost=
.localdomain/
> Rewrote core reporting functionality
>   Merged patches 3 & 4
>   Dropped boundary list and related code
>   Folded get_reported_page into page_reporting_fill
>   Folded page_reporting_fill into page_reporting_cycle
> Pulled reporting functionality out of free_reported_page
>   Renamed it to __free_isolated_page
>   Moved page reporting specific bits to page_reporting_drain
> Renamed phdev to prdev since we aren't "hinting" we are "reporting"
> Added documentation to describe the usage of unused page reporting
> Updated cover page and patch descriptions to avoid mention of boundary
>=20
> Changes from v14:
> https://lore.kernel.org/lkml/20191119214454.24996.66289.stgit@localhost=
.localdomain/
> Renamed "unused page reporting" to "free page reporting"
>   Updated code, kconfig, and patch descriptions
> Split out patch for __free_isolated_page
>   Renamed function to __putback_isolated_page
> Rewrote core reporting functionality
>   Added logic to reschedule worker in 2 seconds instead of run to compl=
etion
>   Removed reported_pages statistics
>   Removed REPORTING_REQUESTED bit used in zone flags
>   Replaced page_reporting_dev_info refcount with state variable
>   Removed scatterlist from page_reporting_dev_info
>   Removed capacity from page reporting device
>   Added dynamic scatterlist allocation/free at start/end of reporting p=
rocess
>   Updated __free_one_page so that reported pages are not always added t=
o tail
>   Added logic to handle error from report function
> Updated virtio-balloon patch that adds support for page reporting
>   Updated patch description to try and highlight differences in approac=
hes
>   Updated logic to reflect that we cannot limit the scatterlist from de=
vice

Last time Mel said

"Ok, I'm ok with how this hooks into the allocator as the overhead is
minimal. However, the patch itself still includes a number of
optimisations instead of being a bare-boned implementation of the
feature with optimisations layered on top."

and

"Either way, the separate patch could have supporting data on how much
it improves the speed of reporting pages so it can be compared to any
other optimisation that may be proposed. Supporting data would also help
make the case that any complexity introduced by the optimisation is
worthwhile."

But I was only partially following that discussion.

I can see that there is only one additional patch (before the reporting
one) compared to the previous series on the MM side. Does that comment
no longer apply (I can see e.g., "Removed REPORTING_REQUESTED bit used
in zone flags" in the changelog) - IOW, did you drop all the
optimizations in question for now? If so, can you share some performance
differences with and without the previous optimizations? (just out of
personal interest :) )

Christmas is getting closer, and at least in Europe/Germany that usually
means that things will slow down ... or however you want to call that.
So I wouldn't expect too much review happening before next year (but I
might be wrong of course).

Cheers!

--=20
Thanks,

David / dhildenb

