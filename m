Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675C51DA9D9
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 07:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgETFZi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 20 May 2020 01:25:38 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56870 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726503AbgETFZi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 May 2020 01:25:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01419;MF=teawaterz@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0Tz4XaVs_1589952329;
Received: from 30.30.208.9(mailfrom:teawaterz@linux.alibaba.com fp:SMTPD_---0Tz4XaVs_1589952329)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 May 2020 13:25:31 +0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH v4 00/15] virtio-mem: paravirtualized memory
From:   teawater <teawaterz@linux.alibaba.com>
In-Reply-To: <20200507140139.17083-1-david@redhat.com>
Date:   Wed, 20 May 2020 13:25:29 +0800
Cc:     LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        virtio-dev@lists.oasis-open.org,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        kvm@vger.kernel.org, Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <2603F9B2-17D0-4A05-A82B-2D3B9671A96E@linux.alibaba.com>
References: <20200507140139.17083-1-david@redhat.com>
To:     David Hildenbrand <david@redhat.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

Thanks for your work.
I tried this version with cloud-hypervisor master.  It worked very well.

Best,
Hui

> 2020年5月7日 22:01，David Hildenbrand <david@redhat.com> 写道：
> 
> This series is based on v5.7-rc4. The patches are located at:
>    https://github.com/davidhildenbrand/linux.git virtio-mem-v4
> 
> This is basically a resend of v3 [1], now based on v5.7-rc4 and restested.
> One patch was reshuffled and two ACKs I missed to add were added. The
> rebase did not require any modifications to patches.
> 
> Details about virtio-mem can be found in the cover letter of v2 [2]. A
> basic QEMU implementation was posted yesterday [3].
> 
> [1] https://lkml.kernel.org/r/20200507103119.11219-1-david@redhat.com
> [2] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
> [3] https://lkml.kernel.org/r/20200506094948.76388-1-david@redhat.com
> 
> v3 -> v4:
> - Move "MAINTAINERS: Add myself as virtio-mem maintainer" to #2
> - Add two ACKs from Andrew (in reply to v2)
> -- "mm: Allow to offline unmovable PageOffline() pages via ..."
> -- "mm/memory_hotplug: Introduce offline_and_remove_memory()"
> 
> v2 -> v3:
> - "virtio-mem: Paravirtualized memory hotplug"
> -- Include "linux/slab.h" to fix build issues
> -- Remember the "region_size", helpful for patch #11
> -- Minor simplifaction in virtio_mem_overlaps_range()
> -- Use notifier_from_errno() instead of notifier_to_errno() in notifier
> -- More reliable check for added memory when unloading the driver
> - "virtio-mem: Allow to specify an ACPI PXM as nid"
> -- Also print the nid
> - Added patch #11-#15
> 
> David Hildenbrand (15):
>  virtio-mem: Paravirtualized memory hotplug
>  MAINTAINERS: Add myself as virtio-mem maintainer
>  virtio-mem: Allow to specify an ACPI PXM as nid
>  virtio-mem: Paravirtualized memory hotunplug part 1
>  virtio-mem: Paravirtualized memory hotunplug part 2
>  mm: Allow to offline unmovable PageOffline() pages via
>    MEM_GOING_OFFLINE
>  virtio-mem: Allow to offline partially unplugged memory blocks
>  mm/memory_hotplug: Introduce offline_and_remove_memory()
>  virtio-mem: Offline and remove completely unplugged memory blocks
>  virtio-mem: Better retry handling
>  virtio-mem: Add parent resource for all added "System RAM"
>  virtio-mem: Drop manual check for already present memory
>  virtio-mem: Unplug subblocks right-to-left
>  virtio-mem: Use -ETXTBSY as error code if the device is busy
>  virtio-mem: Try to unplug the complete online memory block first
> 
> MAINTAINERS                     |    7 +
> drivers/acpi/numa/srat.c        |    1 +
> drivers/virtio/Kconfig          |   17 +
> drivers/virtio/Makefile         |    1 +
> drivers/virtio/virtio_mem.c     | 1962 +++++++++++++++++++++++++++++++
> include/linux/memory_hotplug.h  |    1 +
> include/linux/page-flags.h      |   10 +
> include/uapi/linux/virtio_ids.h |    1 +
> include/uapi/linux/virtio_mem.h |  208 ++++
> mm/memory_hotplug.c             |   81 +-
> mm/page_alloc.c                 |   26 +
> mm/page_isolation.c             |    9 +
> 12 files changed, 2314 insertions(+), 10 deletions(-)
> create mode 100644 drivers/virtio/virtio_mem.c
> create mode 100644 include/uapi/linux/virtio_mem.h
> 
> -- 
> 2.25.3

