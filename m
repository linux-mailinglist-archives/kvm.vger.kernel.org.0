Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17A5245772
	for <lists+kvm@lfdr.de>; Sun, 16 Aug 2020 13:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgHPLwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 07:52:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41126 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726022AbgHPLwN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 16 Aug 2020 07:52:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597578729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7OLC89jOoEoJHyExqjmcWiWlu8IwCSnO9Y8nKZy7mHo=;
        b=e6NQQl9YcnmDEa0/j0b8SjN1W3ltUhgr5MiHcxeS1WCqPCWD8PWCib9nxkGJ2NnxTEYV8f
        t4TZzKNlH4zPFJquwq3q2SohmZfu8AdjEs7HOqFmnfAWJDXJrkWnks00KSGMC8Lwq/wex9
        R+ajvqTr44BKEYXWPfeN/+ak8hlgEjc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-AijQ1lieOIqtjUfgma6l5g-1; Sun, 16 Aug 2020 07:52:03 -0400
X-MC-Unique: AijQ1lieOIqtjUfgma6l5g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEFCD1015DC3;
        Sun, 16 Aug 2020 11:52:00 +0000 (UTC)
Received: from [10.36.113.93] (ovpn-113-93.ams2.redhat.com [10.36.113.93])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 227817B9FA;
        Sun, 16 Aug 2020 11:51:50 +0000 (UTC)
Subject: Re: [PATCH v6 14/15] vfio: Document dual stage control
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
 <1595917664-33276-15-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <aa1297cb-2bde-0cea-70a4-fc8f56d745e6@redhat.com>
Date:   Sun, 16 Aug 2020 13:51:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1595917664-33276-15-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/28/20 8:27 AM, Liu Yi L wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> The VFIO API was enhanced to support nested stage control: a bunch of> new ioctls and usage guideline.
> 
> Let's document the process to follow to set up nested mode.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
> v5 -> v6:
> *) tweak per Eric's comments.
> 
> v3 -> v4:
> *) add review-by from Stefan Hajnoczi
> 
> v2 -> v3:
> *) address comments from Stefan Hajnoczi
> 
> v1 -> v2:
> *) new in v2, compared with Eric's original version, pasid table bind
>    and fault reporting is removed as this series doesn't cover them.
>    Original version from Eric.
>    https://lkml.org/lkml/2020/3/20/700
> ---
>  Documentation/driver-api/vfio.rst | 75 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index f1a4d3c..c0d43f0 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -239,6 +239,81 @@ group and can access them as follows::
>  	/* Gratuitous device reset and go... */
>  	ioctl(device, VFIO_DEVICE_RESET);
>  
> +IOMMU Dual Stage Control
> +------------------------
> +
> +Some IOMMUs support 2 stages/levels of translation. Stage corresponds
> +to the ARM terminology while level corresponds to Intel's terminology.
> +In the following text we use either without distinction.
> +
> +This is useful when the guest is exposed with a virtual IOMMU and some
> +devices are assigned to the guest through VFIO. Then the guest OS can
> +use stage-1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage
> +2 for VM isolation (GPA -> HPA).
> +
> +Under dual stage translation, the guest gets ownership of the stage-1 page
> +tables and also owns stage-1 configuration structures. The hypervisor owns
> +the root configuration structure (for security reason), including stage-2
> +configuration.
This is only true for vtd. On ARM the stage2 cfg is the Context
Descriptor table (aka PASID table). root cfg only store the GPA of the
CD table.
 This works as long as configuration structures and page table
> +formats are compatible between the virtual IOMMU and the physical IOMMU.
> +
> +Assuming the HW supports it, this nested mode is selected by choosing the
> +VFIO_TYPE1_NESTING_IOMMU type through:
> +
> +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
> +
> +This forces the hypervisor to use the stage-2, leaving stage-1 available
> +for guest usage. The stage-1 format and binding method are vendor specific
. There are reported in the nesting capability ...
> +and reported in nesting cap (VFIO_IOMMU_TYPE1_INFO_CAP_NESTING) through
> +VFIO_IOMMU_GET_INFO:
> +
> +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
> +
> +The nesting cap info is available only after NESTING_IOMMU is selected.
> +If underlying IOMMU doesn't support nesting, VFIO_SET_IOMMU fails and
If the underlying
> +userspace should try other IOMMU types. Details of the nesting cap info
> +can be found in Documentation/userspace-api/iommu.rst.
> +
> +The stage-1 page table can be bound to the IOMMU in two methods: directly> +or indirectly. Direct binding requires userspace to notify VFIO of every
Not sure we shall use this direct/indirect terminology. I don't think
this is part of either ARM or Intel SPEC.

Suggestion: On Intel, the stage1 page table info are mediated by the
userspace for each PASID. On ARM, the userspace directly passes the GPA
of the whole PASID table. Currently only Intel's binding is supported.
> +guest stage-1 page table binding, while indirect binding allows userspace
> +to bind once with an intermediate structure (e.g. PASID table) which
> +indirectly links to guest stage-1 page tables. The actual binding method
> +depends on IOMMU vendor. Currently only the direct binding capability (
> +IOMMU_NESTING_FEAT_BIND_PGTBL) is supported:
> +
> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> +
> +When multiple stage-1 page tables are supported on a device, each page
> +table is associated with a PASID (Process Address Space ID) to differentiate
> +with each other. In such case, userspace should include PASID in the
> +bind_data when issuing direct binding request.
> +
> +PASID could be managed per-device or system-wide which, again, depends on
> +IOMMU vendor and is reported in nesting cap info. When system-wide policy
> +is reported (IOMMU_NESTING_FEAT_SYSWIDE_PASID), e.g. as by Intel platforms,
> +userspace *must* allocate PASID from VFIO before attempting binding of
> +stage-1 page table:
> +
> +    req.flags = VFIO_IOMMU_ALLOC_PASID;
> +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
> +
> +Once the stage-1 page table is bound to the IOMMU, the guest is allowed to
> +fully manage its mapping at its disposal. The IOMMU walks nested stage-1
> +and stage-2 page tables when serving DMA requests from assigned device, and
> +may cache the stage-1 mapping in the IOTLB. When required (IOMMU_NESTING_
> +FEAT_CACHE_INVLD), userspace *must* forward guest stage-1 invalidation to
> +the host, so the IOTLB is invalidated:
> +
> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_CACHE_INVLD;
> +    memcpy(&nesting_op->data, &cache_inv_data, sizeof(cache_inv_data));
> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> +
> +Forwarded invalidations can happen at various granularity levels (page
> +level, context level, etc.)
> +
>  VFIO User API
>  -------------------------------------------------------------------------------
>  
> 
Thanks

Eric

