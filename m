Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88BF9E1922
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 13:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390772AbfJWLgA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 07:36:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390231AbfJWLf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 07:35:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571830557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp:autocrypt:autocrypt;
        bh=J0+fECyzDGyqB0bZcHnQXRPUWcmiKaJrfbBoe0fO00U=;
        b=XlE9Is7Z+j5CmiKvlfMMwZXI/SAp6caMiVnBrXn7fmLR604XCfHoSad6Aiv5FV86hfrTwg
        gkXu+XcK/DW3dkioyWWh7i7oVHTa0Y7AsyH+E/hk2iZxbCrTSYt7G5nbEfItqrRUm/hnc3
        mMS3CE7BPPy71ORLh5NIN/k7e843kkg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-xA37IuFxNAOId5b4ooMBBA-1; Wed, 23 Oct 2019 07:35:55 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84FA01800D6B;
        Wed, 23 Oct 2019 11:35:53 +0000 (UTC)
Received: from [10.18.17.163] (dhcp-17-163.bos.redhat.com [10.18.17.163])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 983291001B05;
        Wed, 23 Oct 2019 11:35:42 +0000 (UTC)
Subject: Re: [PATCH v12 0/6] mm / virtio: Provide support for unused page
 reporting
To:     Alexander Duyck <alexander.duyck@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, konrad.wilk@oracle.com, david@redhat.com,
        pagupta@redhat.com, riel@surriel.com, lcapitulino@redhat.com,
        dave.hansen@intel.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nitesh@redhat.com; prefer-encrypt=mutual; keydata=
 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
 VujM7c/b4pps
Organization: Red Hat Inc,
Message-ID: <c50e102c-f72e-df8a-714f-a33897ddbb9f@redhat.com>
Date:   Wed, 23 Oct 2019 07:35:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191022221223.17338.5860.stgit@localhost.localdomain>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: xA37IuFxNAOId5b4ooMBBA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/22/19 6:27 PM, Alexander Duyck wrote:
> This series provides an asynchronous means of reporting unused guest
> pages to a hypervisor so that the memory associated with those pages can
> be dropped and reused by other processes and/or guests.
>
> When enabled it will allocate a set of statistics to track the number of
> reported pages. When the nr_free for a given free_area is greater than
> this by the high water mark we will schedule a worker to begin allocating
> the non-reported memory and to provide it to the reporting interface via =
a
> scatterlist.
>
> Currently this is only in use by virtio-balloon however there is the hope
> that at some point in the future other hypervisors might be able to make
> use of it. In the virtio-balloon/QEMU implementation the hypervisor is
> currently using MADV_DONTNEED to indicate to the host kernel that the pag=
e
> is currently unused. It will be faulted back into the guest the next time
> the page is accessed.
>
> To track if a page is reported or not the Uptodate flag was repurposed an=
d
> used as a Reported flag for Buddy pages. While we are processing the page=
s
> in a given zone we have a set of pointers we track called
> reported_boundary that is used to keep our processing time to a minimum.
> Without these we would have to iterate through all of the reported pages
> which would become a significant burden. I measured as much as a 20%
> performance degradation without using the boundary pointers. In the event
> of something like compaction needing to process the zone at the same time
> it currently resorts to resetting the boundary if it is rearranging the
> list. However in the future it could choose to delay processing the zone
> if a flag is set indicating that a zone is being actively processed.
>
> Below are the results from various benchmarks. I primarily focused on two
> tests. The first is the will-it-scale/page_fault2 test, and the other is
> a modified version of will-it-scale/page_fault1 that was enabled to use
> THP. I did this as it allows for better visibility into different parts
> of the memory subsystem. The guest is running on one node of a E5-2630 v3
> CPU with 48G of RAM that I split up into two logical nodes in the guest
> in order to test with NUMA as well.
>
> Test=09=09    page_fault1 (THP)     page_fault2
> Baseline=09 1  1256106.33  +/-0.09%   482202.67  +/-0.46%
>                 16  8864441.67  +/-0.09%  3734692.00  +/-1.23%
>
> Patches applied  1  1257096.00  +/-0.06%   477436.00  +/-0.16%
>                 16  8864677.33  +/-0.06%  3800037.00  +/-0.19%
>
> Patches enabled=09 1  1258420.00  +/-0.04%   480080.00  +/-0.07%
>  MADV disabled  16  8753840.00  +/-1.27%  3782764.00  +/-0.37%
>
> Patches enabled=09 1  1267916.33  +/-0.08%   472075.67  +/-0.39%
>                 16  8287050.33  +/-0.67%  3774500.33  +/-0.11%
>
> The results above are for a baseline with a linux-next-20191021 kernel,
> that kernel with this patch set applied but page reporting disabled in
> virtio-balloon, patches applied but the madvise disabled by direct
> assigning a device, and the patches applied and page reporting fully
> enabled.  These results include the deviation seen between the average
> value reported here versus the high and/or low value. I observed that
> during the test the memory usage for the first three tests never dropped
> whereas with the patches fully enabled the VM would drop to using only a
> few GB of the host's memory when switching from memhog to page fault test=
s.
>
> Most of the overhead seen with this patch set fully enabled is due to the
> fact that accessing the reported pages will cause a page fault and the ho=
st
> will have to zero the page before giving it back to the guest. The overal=
l
> guest size is kept fairly small to only a few GB while the test is runnin=
g.
> This overhead is much more visible when using THP than with standard 4K
> pages. As such for the case where the host memory is not oversubscribed
> this results in a performance regression, however if the host memory were
> oversubscribed this patch set should result in a performance improvement
> as swapping memory from the host can be avoided.
>
> There is currently an alternative patch set[1] that has been under work
> for some time however the v12 version of that patch set could not be
> tested as it triggered a kernel panic when I attempted to test it. It
> requires multiple modifications to get up and running with performance
> comparable to this patch set. A follow-on set has yet to be posted. As
> such I have not included results from that patch set, and I would
> appreciate it if we could keep this patch set the focus of any discussion
> on this thread.
>
> For info on earlier versions you will need to follow the links provided
> with the respective versions.
>
> [1]: https://lore.kernel.org/lkml/20190812131235.27244-1-nitesh@redhat.co=
m/
>
> Changes from v10:
> https://lore.kernel.org/lkml/20190918175109.23474.67039.stgit@localhost.l=
ocaldomain/
> Rebased on "Add linux-next specific files for 20190930"
> Added page_is_reported() macro to prevent unneeded testing of PageReporte=
d bit
> Fixed several spots where comments referred to older aeration naming
> Set upper limit for phdev->capacity to page reporting high water mark
> Updated virtio page poison detection logic to also cover init_on_free
> Tweaked page_reporting_notify_free to reduce code size
> Removed dead code in non-reporting path
>
> Changes from v11:
> https://lore.kernel.org/lkml/20191001152441.27008.99285.stgit@localhost.l=
ocaldomain/
> Removed unnecessary whitespace change from patch 2
> Minor tweak to get_unreported_page to avoid excess writes to boundary
> Rewrote cover page to lay out additional performance info.
>
> ---
>
> Alexander Duyck (6):
>       mm: Adjust shuffle code to allow for future coalescing
>       mm: Use zone and order instead of free area in free_list manipulato=
rs
>       mm: Introduce Reported pages
>       mm: Add device side and notifier for unused page reporting
>       virtio-balloon: Pull page poisoning config out of free page hinting
>       virtio-balloon: Add support for providing unused page reports to ho=
st
>
>
>  drivers/virtio/Kconfig              |    1=20
>  drivers/virtio/virtio_balloon.c     |   88 ++++++++-
>  include/linux/mmzone.h              |   60 ++----
>  include/linux/page-flags.h          |   11 +
>  include/linux/page_reporting.h      |   31 +++
>  include/uapi/linux/virtio_balloon.h |    1=20
>  mm/Kconfig                          |   11 +
>  mm/Makefile                         |    1=20
>  mm/compaction.c                     |    5=20
>  mm/memory_hotplug.c                 |    2=20
>  mm/page_alloc.c                     |  194 +++++++++++++++----
>  mm/page_reporting.c                 |  353 +++++++++++++++++++++++++++++=
++++++
>  mm/page_reporting.h                 |  225 ++++++++++++++++++++++
>  mm/shuffle.c                        |   12 +
>  mm/shuffle.h                        |    6 +
>  15 files changed, 899 insertions(+), 102 deletions(-)
>  create mode 100644 include/linux/page_reporting.h
>  create mode 100644 mm/page_reporting.c
>  create mode 100644 mm/page_reporting.h
>
> --
>

I think Michal Hocko suggested us to include a brief detail about the backg=
round
explaining how we ended up with the current approach and what all things we=
 have
already tried.
That would help someone reviewing the patch-series for the first time to
understand it in a better way.

--
Nitesh

