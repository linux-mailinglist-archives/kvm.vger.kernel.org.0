Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E30F1C873B
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 12:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgEGKtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 06:49:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47355 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726464AbgEGKtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 06:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588848547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6TNeBJCWo89yL05TnTjwH8dcSijsVuy4nyFBYGcILew=;
        b=FBZe4OM+wOI6MIyYFkTdnYJB0+p2YrCNBQGjc5nx683M1NsRg1fBL4//3ky5C79HANsPhY
        4jnZNaFPNq427YvQzZQhNMRfYCEJN9V9nK3yunrCEtdSszTGcCEZ5IoTpDwiHLwaF0+pkG
        nntUuwtyXN0BfD5hk8yqjm0vdxfzfb8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-uUPG7D-_NgScLyvsDrb0wQ-1; Thu, 07 May 2020 06:49:06 -0400
X-MC-Unique: uUPG7D-_NgScLyvsDrb0wQ-1
Received: by mail-wr1-f69.google.com with SMTP id a3so3197830wro.1
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 03:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6TNeBJCWo89yL05TnTjwH8dcSijsVuy4nyFBYGcILew=;
        b=OvJr3ZS/9YXnlJi7vhIlCzNMbJ62eLj8Amj3aOEYwhWCrf9G3YUz7rmG/6MkAMxksm
         yrFQfkw3xdE7wYcOrSFguxPMen8K0IdfYCQPIgALhMwfGT250hQT35nTE68ud2Z0btXP
         0AUVJKuJ5o1lewxpbG7x2yH9FkwCm/Gz3Irpl5fa876KIwVrWWJbGnX8d1CCKBqdlWfe
         2L5Mv7IB9ULPc+F67BlHIdnNdmGxXgmM25VAGTQl/OVS/aeOQjoq/aCH1+vgbxRlCFjb
         npGOvTFlUETHzquFGO+gzzWNHTY9tbDURFUycdE8dkeDccjQS7sYAjuwb8Qm9IvNGH8A
         2R1A==
X-Gm-Message-State: AGi0PubTMfVTk8wRU1zZAxwKs5cCDVdANDESq6WLUFQpbg2z0zHjUmyP
        /Pbh6dCjC0PXfyoXJofx+dCIUBGfS5eFd9Fr/FWUYHH7BNY5Fz9FeQdSroy6W4LA85TM91kQOV/
        fyru1C6hjOBmY
X-Received: by 2002:a5d:4389:: with SMTP id i9mr15542888wrq.374.1588848545319;
        Thu, 07 May 2020 03:49:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypJZNIpWHFCESwDQSs7+PMHyNfIcO5F7JwrpmUBB61yG1/h7N4ojiGa6GBHhpnaJfh9mBO8omA==
X-Received: by 2002:a5d:4389:: with SMTP id i9mr15542847wrq.374.1588848545108;
        Thu, 07 May 2020 03:49:05 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id n6sm5623197wrt.58.2020.05.07.03.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 03:49:04 -0700 (PDT)
Date:   Thu, 7 May 2020 06:48:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sebastien Boeuf <sebastien.boeuf@intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        Robert Bradford <robert.bradford@intel.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        teawater <teawaterz@linux.alibaba.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Alexander Potapenko <glider@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Anthony Yznaga <anthony.yznaga@oracle.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Young <dyoung@redhat.com>,
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
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Pavel Tatashin <pavel.tatashin@microsoft.com>,
        Pingfan Liu <kernelfans@gmail.com>, Qian Cai <cai@lca.pw>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Wei Yang <richard.weiyang@gmail.com>
Subject: Re: [PATCH v3 00/15] virtio-mem: paravirtualized memory
Message-ID: <20200507064834-mutt-send-email-mst@kernel.org>
References: <20200507103119.11219-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507103119.11219-1-david@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 12:31:04PM +0200, David Hildenbrand wrote:
> This series is based on latest linux-next. The patches are located at:
>     https://github.com/davidhildenbrand/linux.git virtio-mem-v3
> 
> Patch #1 - #10 where contained in v2 and only contain minor modifications
> (mostly smaller fixes). The remaining patches are new and contain smaller
> optimizations.


Looks like you lost some acks, in particular I'd like to preserve
Andrew Morton's ack.

> Details about virtio-mem can be found in the cover letter of v2 [1]. A
> basic QEMU implementation was posted yesterday [2].
> 
> [1] https://lkml.kernel.org/r/20200311171422.10484-1-david@redhat.com
> [2] https://lkml.kernel.org/r/20200506094948.76388-1-david@redhat.com
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
> Cc: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Cc: Samuel Ortiz <samuel.ortiz@intel.com>
> Cc: Robert Bradford <robert.bradford@intel.com>
> Cc: Luiz Capitulino <lcapitulino@redhat.com>
> Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
> Cc: teawater <teawaterz@linux.alibaba.com>
> Cc: Igor Mammedov <imammedo@redhat.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> David Hildenbrand (15):
>   virtio-mem: Paravirtualized memory hotplug
>   virtio-mem: Allow to specify an ACPI PXM as nid
>   virtio-mem: Paravirtualized memory hotunplug part 1
>   virtio-mem: Paravirtualized memory hotunplug part 2
>   mm: Allow to offline unmovable PageOffline() pages via
>     MEM_GOING_OFFLINE
>   virtio-mem: Allow to offline partially unplugged memory blocks
>   mm/memory_hotplug: Introduce offline_and_remove_memory()
>   virtio-mem: Offline and remove completely unplugged memory blocks
>   virtio-mem: Better retry handling
>   MAINTAINERS: Add myself as virtio-mem maintainer
>   virtio-mem: Add parent resource for all added "System RAM"
>   virtio-mem: Drop manual check for already present memory
>   virtio-mem: Unplug subblocks right-to-left
>   virtio-mem: Use -ETXTBSY as error code if the device is busy
>   virtio-mem: Try to unplug the complete online memory block first
> 
>  MAINTAINERS                     |    7 +
>  drivers/acpi/numa/srat.c        |    1 +
>  drivers/virtio/Kconfig          |   17 +
>  drivers/virtio/Makefile         |    1 +
>  drivers/virtio/virtio_mem.c     | 1962 +++++++++++++++++++++++++++++++
>  include/linux/memory_hotplug.h  |    1 +
>  include/linux/page-flags.h      |   10 +
>  include/uapi/linux/virtio_ids.h |    1 +
>  include/uapi/linux/virtio_mem.h |  208 ++++
>  mm/memory_hotplug.c             |   81 +-
>  mm/page_alloc.c                 |   26 +
>  mm/page_isolation.c             |    9 +
>  12 files changed, 2314 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/virtio/virtio_mem.c
>  create mode 100644 include/uapi/linux/virtio_mem.h
> 
> -- 
> 2.25.3

