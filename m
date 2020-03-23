Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E32B218FFEF
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 21:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCWU7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 16:59:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:20875 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725830AbgCWU7S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 16:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584997156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y8VQAEc4YAeEN6M257SUREUMwxpCtK02OFut6H/UATU=;
        b=R2r+9TiLILdjAu+01Y+6gg6aYf58+W+5cXGb/DF0powSSegW6uY6Vp0IvnVKOA/cSuExg1
        K4cp8gWT/jbHrRM2lkWAuFHPzBuCfcsnWh1JUS/ROoc1oeeUvPwdS9+DIg3cEfMdxRchb+
        3KrMwo4F5+Fv2U+LAZhQK8PCIxygSZU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-5kjYD_EGPiaTMBUK3siC7A-1; Mon, 23 Mar 2020 16:58:57 -0400
X-MC-Unique: 5kjYD_EGPiaTMBUK3siC7A-1
Received: by mail-wm1-f71.google.com with SMTP id m4so419102wmi.5
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 13:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y8VQAEc4YAeEN6M257SUREUMwxpCtK02OFut6H/UATU=;
        b=KqqFdhlt/Nqrsu1GQLnpB06Ezmlw2knMOBZWE9GRtqa14sICJwTme3vQnjyCkYC0JI
         Kn3PusYA6d6mJx4pU0Ui3tTTJ5q8c+/WbuI+S1oeNOLbBqw59osvz2+V6axKnvy/RVJ4
         XVmFFPG9U9I0g096yO9q5m5L/HD20dUbZPeFLUPKcLUXsLPjIHPEh4H8hMk2KV+pxVFE
         ozUCDoIeG3h0AaC616XNhK++nKXT79n1pnofWhwSGiaSGNxk2i7ZOyZbuv9O0pqPmKJ8
         rzS79JM4aZ714Db45eBTZigzIujknssGttgahiiSchCPKY6krhuP94/Yl+vUsK29cx/N
         Wu/A==
X-Gm-Message-State: ANhLgQ3xD+35U1U425ajvqXNZTEZQ0sz5VfKHm1HlAtMSuZkHTe7dRVx
        zI4Wahv9BRBunn7l3lykVBU8Znt1NRnhFFyHrWLQdx0rI6o7FIhkdQ8DqL5t9vwcB+KNYF/Fiwc
        Ul5J0oBzCocsZ
X-Received: by 2002:adf:8182:: with SMTP id 2mr30982765wra.37.1584997133935;
        Mon, 23 Mar 2020 13:58:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvuHU3mT9WAHbvRL8Qzx//EY6L5u4P+IFx88svQCyb/I96uUzUyTPqPtbdYK4UUZ+KaHUDgXQ==
X-Received: by 2002:adf:8182:: with SMTP id 2mr30982733wra.37.1584997133556;
        Mon, 23 Mar 2020 13:58:53 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id a13sm25859236wrh.80.2020.03.23.13.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 13:58:52 -0700 (PDT)
Date:   Mon, 23 Mar 2020 16:58:49 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        eric.auger@redhat.com, pbonzini@redhat.com, mst@redhat.com,
        david@gibson.dropbear.id.au, kevin.tian@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org,
        hao.wu@intel.com, jean-philippe@linaro.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [PATCH v1 04/22] hw/iommu: introduce HostIOMMUContext
Message-ID: <20200323205849.GO127076@xz-x1>
References: <1584880579-12178-1-git-send-email-yi.l.liu@intel.com>
 <1584880579-12178-5-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1584880579-12178-5-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Mar 22, 2020 at 05:36:01AM -0700, Liu Yi L wrote:
> Currently, many platform vendors provide the capability of dual stage
> DMA address translation in hardware. For example, nested translation
> on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> and etc. In dual stage DMA address translation, there are two stages
> address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
> second-level) translation structures. Stage-1 translation results are
> also subjected to stage-2 translation structures. Take vSVA (Virtual
> Shared Virtual Addressing) as an example, guest IOMMU driver owns
> stage-1 translation structures (covers GVA->GPA translation), and host
> IOMMU driver owns stage-2 translation structures (covers GPA->HPA
> translation). VMM is responsible to bind stage-1 translation structures
> to host, thus hardware could achieve GVA->GPA and then GPA->HPA
> translation. For more background on SVA, refer the below links.
>  - https://www.youtube.com/watch?v=Kq_nfGK5MwQ
>  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
> Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
> 
> In QEMU, vIOMMU emulators expose IOMMUs to VM per their own spec (e.g.
> Intel VT-d spec). Devices are pass-through to guest via device pass-
> through components like VFIO. VFIO is a userspace driver framework
> which exposes host IOMMU programming capability to userspace in a
> secure manner. e.g. IOVA MAP/UNMAP requests. Thus the major connection
> between VFIO and vIOMMU are MAP/UNMAP. However, with the dual stage
> DMA translation support, there are more interactions between vIOMMU and
> VFIO as below:
>  1) PASID allocation (allow host to intercept in PASID allocation)
>  2) bind stage-1 translation structures to host
>  3) propagate stage-1 cache invalidation to host
>  4) DMA address translation fault (I/O page fault) servicing etc.
> 
> With the above new interactions in QEMU, it requires an abstract layer
> to facilitate the above operations and expose to vIOMMU emulators as an
> explicit way for vIOMMU emulators call into VFIO. This patch introduces
> HostIOMMUContext to stand for hardware IOMMU w/ dual stage DMA address
> translation capability. And introduces HostIOMMUContextClass to provide
> methods for vIOMMU emulators to propagate dual-stage translation related
> requests to host. As a beginning, PASID allocation/free are defined to
> propagate PASID allocation/free requests to host which is helpful for the
> vendors who manage PASID in system-wide. In future, there will be more
> operations like bind_stage1_pgtbl, flush_stage1_cache and etc.
> 
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  hw/Makefile.objs                      |   1 +
>  hw/iommu/Makefile.objs                |   1 +
>  hw/iommu/host_iommu_context.c         | 112 ++++++++++++++++++++++++++++++++++
>  include/hw/iommu/host_iommu_context.h |  75 +++++++++++++++++++++++
>  4 files changed, 189 insertions(+)
>  create mode 100644 hw/iommu/Makefile.objs
>  create mode 100644 hw/iommu/host_iommu_context.c
>  create mode 100644 include/hw/iommu/host_iommu_context.h
> 
> diff --git a/hw/Makefile.objs b/hw/Makefile.objs
> index 660e2b4..cab83fe 100644
> --- a/hw/Makefile.objs
> +++ b/hw/Makefile.objs
> @@ -40,6 +40,7 @@ devices-dirs-$(CONFIG_MEM_DEVICE) += mem/
>  devices-dirs-$(CONFIG_NUBUS) += nubus/
>  devices-dirs-y += semihosting/
>  devices-dirs-y += smbios/
> +devices-dirs-y += iommu/
>  endif
>  
>  common-obj-y += $(devices-dirs-y)
> diff --git a/hw/iommu/Makefile.objs b/hw/iommu/Makefile.objs
> new file mode 100644
> index 0000000..e6eed4e
> --- /dev/null
> +++ b/hw/iommu/Makefile.objs
> @@ -0,0 +1 @@
> +obj-y += host_iommu_context.o
> diff --git a/hw/iommu/host_iommu_context.c b/hw/iommu/host_iommu_context.c
> new file mode 100644
> index 0000000..af61899
> --- /dev/null
> +++ b/hw/iommu/host_iommu_context.c

I'm not 100% sure it's the best place to put this; I thought hw/ is
for emulated devices while this is some host utility, but I could be
wrong.  However it'll always be some kind of backend of a vIOMMU,
so...  Maybe we can start with this until someone else disagrees.

> @@ -0,0 +1,112 @@
> +/*
> + * QEMU abstract of Host IOMMU
> + *
> + * Copyright (C) 2020 Intel Corporation.
> + *
> + * Authors: Liu Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qapi/error.h"
> +#include "qom/object.h"
> +#include "qapi/visitor.h"
> +#include "hw/iommu/host_iommu_context.h"
> +
> +int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
> +                               uint32_t max, uint32_t *pasid)
> +{
> +    HostIOMMUContextClass *hicxc;
> +
> +    if (!host_icx) {
> +        return -EINVAL;
> +    }
> +
> +    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(host_icx);
> +
> +    if (!hicxc) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(host_icx->flags & HOST_IOMMU_PASID_REQUEST) ||
> +        !hicxc->pasid_alloc) {
> +        return -EINVAL;
> +    }
> +
> +    return hicxc->pasid_alloc(host_icx, min, max, pasid);
> +}
> +
> +int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid)
> +{
> +    HostIOMMUContextClass *hicxc;
> +
> +    if (!host_icx) {
> +        return -EINVAL;
> +    }
> +
> +    hicxc = HOST_IOMMU_CONTEXT_GET_CLASS(host_icx);
> +    if (!hicxc) {
> +        return -EINVAL;
> +    }
> +
> +    if (!(host_icx->flags & HOST_IOMMU_PASID_REQUEST) ||
> +        !hicxc->pasid_free) {
> +        return -EINVAL;
> +    }
> +
> +    return hicxc->pasid_free(host_icx, pasid);
> +}
> +
> +void host_iommu_ctx_init(void *_host_icx, size_t instance_size,
> +                         const char *mrtypename,
> +                         uint64_t flags)
> +{
> +    HostIOMMUContext *host_icx;
> +
> +    object_initialize(_host_icx, instance_size, mrtypename);
> +    host_icx = HOST_IOMMU_CONTEXT(_host_icx);
> +    host_icx->flags = flags;
> +    host_icx->initialized = true;
> +}
> +
> +void host_iommu_ctx_destroy(HostIOMMUContext *host_icx)
> +{
> +    host_icx->flags = 0x0;
> +    host_icx->initialized = false;
> +}

Can we simply put this into .instance_finalize() and be called
automatically when the object loses the last refcount?

Actually an easier way may be dropping this directly..  If the object
is to be destroyed then IMHO we don't need to care about flags at all,
we just free memories we use, but for this object it's none.

> +
> +static void host_icx_init_fn(Object *obj)
> +{
> +    HostIOMMUContext *host_icx = HOST_IOMMU_CONTEXT(obj);
> +
> +    host_icx->flags = 0x0;
> +    host_icx->initialized = false;

Here is also a bit strange...  IIUC the only way to init this object
is via host_iommu_ctx_init() where all these flags will be set.  But
if so, then we're setting all these twice always.  Maybe this function
can be dropped too?

Thanks,

> +}
> +
> +static const TypeInfo host_iommu_context_info = {
> +    .parent             = TYPE_OBJECT,
> +    .name               = TYPE_HOST_IOMMU_CONTEXT,
> +    .class_size         = sizeof(HostIOMMUContextClass),
> +    .instance_size      = sizeof(HostIOMMUContext),
> +    .instance_init      = host_icx_init_fn,
> +    .abstract           = true,
> +};
> +
> +static void host_icx_register_types(void)
> +{
> +    type_register_static(&host_iommu_context_info);
> +}
> +
> +type_init(host_icx_register_types)
> diff --git a/include/hw/iommu/host_iommu_context.h b/include/hw/iommu/host_iommu_context.h
> new file mode 100644
> index 0000000..cfbf5ac
> --- /dev/null
> +++ b/include/hw/iommu/host_iommu_context.h
> @@ -0,0 +1,75 @@
> +/*
> + * QEMU abstraction of Host IOMMU
> + *
> + * Copyright (C) 2020 Intel Corporation.
> + *
> + * Authors: Liu Yi L <yi.l.liu@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> +
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> +
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef HW_IOMMU_CONTEXT_H
> +#define HW_IOMMU_CONTEXT_H
> +
> +#include "qemu/queue.h"
> +#include "qemu/thread.h"
> +#include "qom/object.h"
> +#include <linux/iommu.h>
> +#ifndef CONFIG_USER_ONLY
> +#include "exec/hwaddr.h"
> +#endif
> +
> +#define TYPE_HOST_IOMMU_CONTEXT "qemu:host-iommu-context"
> +#define HOST_IOMMU_CONTEXT(obj) \
> +        OBJECT_CHECK(HostIOMMUContext, (obj), TYPE_HOST_IOMMU_CONTEXT)
> +#define HOST_IOMMU_CONTEXT_GET_CLASS(obj) \
> +        OBJECT_GET_CLASS(HostIOMMUContextClass, (obj), \
> +                         TYPE_HOST_IOMMU_CONTEXT)
> +
> +typedef struct HostIOMMUContext HostIOMMUContext;
> +
> +typedef struct HostIOMMUContextClass {
> +    /* private */
> +    ObjectClass parent_class;
> +
> +    /* Allocate pasid from HostIOMMUContext (a.k.a. host software) */
> +    int (*pasid_alloc)(HostIOMMUContext *host_icx,
> +                       uint32_t min,
> +                       uint32_t max,
> +                       uint32_t *pasid);
> +    /* Reclaim pasid from HostIOMMUContext (a.k.a. host software) */
> +    int (*pasid_free)(HostIOMMUContext *host_icx,
> +                      uint32_t pasid);
> +} HostIOMMUContextClass;
> +
> +/*
> + * This is an abstraction of host IOMMU with dual-stage capability
> + */
> +struct HostIOMMUContext {
> +    Object parent_obj;
> +#define HOST_IOMMU_PASID_REQUEST (1ULL << 0)
> +    uint64_t flags;
> +    bool initialized;
> +};
> +
> +int host_iommu_ctx_pasid_alloc(HostIOMMUContext *host_icx, uint32_t min,
> +                               uint32_t max, uint32_t *pasid);
> +int host_iommu_ctx_pasid_free(HostIOMMUContext *host_icx, uint32_t pasid);
> +
> +void host_iommu_ctx_init(void *_host_icx, size_t instance_size,
> +                         const char *mrtypename,
> +                         uint64_t flags);
> +void host_iommu_ctx_destroy(HostIOMMUContext *host_icx);
> +
> +#endif
> -- 
> 2.7.4
> 

-- 
Peter Xu

