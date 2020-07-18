Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6DF224B9C
	for <lists+kvm@lfdr.de>; Sat, 18 Jul 2020 15:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgGRNjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jul 2020 09:39:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52265 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbgGRNjy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jul 2020 09:39:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595079591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=80URiCGOEAgO/63+/ISh7h+yxZnKPojhEpNhvm3SzK4=;
        b=Crmu7c+/BfeprVX7nRXchYzwHXBFPGTerB51haqcSFrtgZCwJ3P74D6P13jjGN+XBQxCi3
        LPdtKdCw5p8/LA7whHlPNx3iMC5bDwuTy722smvBk1GuwgeACka2Pal15L5L6q4T3ksJxI
        vzSuX7gdC/coPNtaYNr3/qxO8Vhp++o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-DNr2txDpNa-2ajYGgKTcPA-1; Sat, 18 Jul 2020 09:39:47 -0400
X-MC-Unique: DNr2txDpNa-2ajYGgKTcPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A14491800D42;
        Sat, 18 Jul 2020 13:39:45 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F1CE675565;
        Sat, 18 Jul 2020 13:39:35 +0000 (UTC)
Subject: Re: [PATCH v5 14/15] vfio: Document dual stage control
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-15-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a97ee4e4-4592-8dd8-fbb1-6c2c5579d625@redhat.com>
Date:   Sat, 18 Jul 2020 15:39:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-15-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 7/12/20 1:21 PM, Liu Yi L wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> The VFIO API was enhanced to support nested stage control: a bunch of
> new iotcls and usage guideline.
ioctls
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
>  Documentation/driver-api/vfio.rst | 67 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 67 insertions(+)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index f1a4d3c..0672c45 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -239,6 +239,73 @@ group and can access them as follows::
>  	/* Gratuitous device reset and go... */
>  	ioctl(device, VFIO_DEVICE_RESET);
>  
> +IOMMU Dual Stage Control
> +------------------------
> +
> +Some IOMMUs support 2 stages/levels of translation. Stage corresponds to
> +the ARM terminology while level corresponds to Intel's VTD terminology.
> +In the following text we use either without distinction.
> +
> +This is useful when the guest is exposed with a virtual IOMMU and some
> +devices are assigned to the guest through VFIO. Then the guest OS can use
> +stage 1 (GIOVA -> GPA or GVA->GPA), while the hypervisor uses stage 2 for
> +VM isolation (GPA -> HPA).
> +
> +Under dual stage translation, the guest gets ownership of the stage 1 page
> +tables and also owns stage 1 configuration structures. The hypervisor owns
> +the root configuration structure (for security reason), including stage 2
> +configuration. This works as long as configuration structures and page table
> +formats are compatible between the virtual IOMMU and the physical IOMMU.
> +
> +Assuming the HW supports it, this nested mode is selected by choosing the
> +VFIO_TYPE1_NESTING_IOMMU type through:
> +
> +    ioctl(container, VFIO_SET_IOMMU, VFIO_TYPE1_NESTING_IOMMU);
> +
> +This forces the hypervisor to use the stage 2, leaving stage 1 available
> +for guest usage. The guest stage 1 format depends on IOMMU vendor, and
> +it is the same with the nesting configuration method. User space should
> +check the format and configuration method after setting nesting type by
> +using:
> +
> +    ioctl(container->fd, VFIO_IOMMU_GET_INFO, &nesting_info);
> +
> +Details can be found in Documentation/userspace-api/iommu.rst. For Intel
> +VT-d, each stage 1 page table is bound to host by:
> +
> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_BIND_PGTBL;
> +    memcpy(&nesting_op->data, &bind_data, sizeof(bind_data));
> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> +
> +As mentioned above, guest OS may use stage 1 for GIOVA->GPA or GVA->GPA.
the guest OS, here and below?
> +GVA->GPA page tables are available when PASID (Process Address Space ID)
> +is exposed to guest. e.g. guest with PASID-capable devices assigned. For
> +such page table binding, the bind_data should include PASID info, which
> +is allocated by guest itself or by host. This depends on hardware vendor.
> +e.g. Intel VT-d requires to allocate PASID from host. This requirement is

> +defined by the Virtual Command Support in VT-d 3.0 spec, guest software
> +running on VT-d should allocate PASID from host kernel.
because VTD 3.0 requires the unicity of the PASID, system wide, instead
of the above repetition.

 To allocate PASID
> +from host, user space should check the IOMMU_NESTING_FEAT_SYSWIDE_PASID
> +bit of the nesting info reported from host kernel. VFIO reports the nesting
> +info by VFIO_IOMMU_GET_INFO. User space could allocate PASID from host by:
if SYSWIDE_PASID requirement is exposed, the userspace *must* allocate ...
> +
> +    req.flags = VFIO_IOMMU_ALLOC_PASID;
> +    ioctl(container, VFIO_IOMMU_PASID_REQUEST, &req);
> +
> +With first stage/level page table bound to host, it allows to combine the
> +guest stage 1 translation along with the hypervisor stage 2 translation to
> +get final address.
> +
> +When the guest invalidates stage 1 related caches, invalidations must be
> +forwarded to the host through
> +
> +    nesting_op->flags = VFIO_IOMMU_NESTING_OP_CACHE_INVLD;
> +    memcpy(&nesting_op->data, &inv_data, sizeof(inv_data));
> +    ioctl(container->fd, VFIO_IOMMU_NESTING_OP, nesting_op);
> +
> +Those invalidations can happen at various granularity levels, page, context,
> +...
> +
>  VFIO User API
>  -------------------------------------------------------------------------------
I see you dropped the unrecoverable error reporting part of the original
contribution. By the way don't you need any error handling for either of
the use cases on vtd?
>  
> 
Thanks

Eric

