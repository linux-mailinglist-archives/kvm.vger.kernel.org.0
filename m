Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C43F19948C
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbgCaK7p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 31 Mar 2020 06:59:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:43384 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730403AbgCaK7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:59:45 -0400
IronPort-SDR: hmIyjhHQCf5hCPs8xIu38TX19e12vEuBfA7k3spg/d5alME1HMh9t2RMXgwlIYdXj1uylpT+j0
 bOW8IukWdreg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 03:59:44 -0700
IronPort-SDR: ohgEQWK6TSy042e2SG4MrfKhUh7JE/FFXx35AyVj+KNmbrke2Yr30O15MRT8a+DXAtx5H6T/78
 KIzwiOKL8Tuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="272704772"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2020 03:59:44 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 03:59:44 -0700
Received: from shsmsx107.ccr.corp.intel.com (10.239.4.96) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 31 Mar 2020 03:59:44 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.225]) by
 SHSMSX107.ccr.corp.intel.com ([169.254.9.191]) with mapi id 14.03.0439.000;
 Tue, 31 Mar 2020 18:59:40 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Auger Eric <eric.auger@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [PATCH v2 08/22] vfio/common: provide PASID alloc/free hooks
Thread-Topic: [PATCH v2 08/22] vfio/common: provide PASID alloc/free hooks
Thread-Index: AQHWBkpiGmk8cmt3gUmACGVeg+XtIahiAOgAgACGbQA=
Date:   Tue, 31 Mar 2020 10:59:39 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A21AD6D@SHSMSX104.ccr.corp.intel.com>
References: <1585542301-84087-1-git-send-email-yi.l.liu@intel.com>
 <1585542301-84087-9-git-send-email-yi.l.liu@intel.com>
 <e6d9a5bc-fd54-c220-067d-0597ad8e86fc@redhat.com>
In-Reply-To: <e6d9a5bc-fd54-c220-067d-0597ad8e86fc@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> From: Auger Eric
> Sent: Tuesday, March 31, 2020 6:48 PM
> To: Liu, Yi L <yi.l.liu@intel.com>; qemu-devel@nongnu.org;
> alex.williamson@redhat.com; peterx@redhat.com
> Cc: pbonzini@redhat.com; mst@redhat.com; david@gibson.dropbear.id.au; Tian,
> Kevin <kevin.tian@intel.com>; Tian, Jun J <jun.j.tian@intel.com>; Sun, Yi Y
> <yi.y.sun@intel.com>; kvm@vger.kernel.org; Wu, Hao <hao.wu@intel.com>; jean-
> philippe@linaro.org; Jacob Pan <jacob.jun.pan@linux.intel.com>; Yi Sun
> <yi.y.sun@linux.intel.com>
> Subject: Re: [PATCH v2 08/22] vfio/common: provide PASID alloc/free hooks
> 
> Yi,
> 
> On 3/30/20 6:24 AM, Liu Yi L wrote:
> > This patch defines vfio_host_iommu_context_info, implements the PASID
> > alloc/free hooks defined in HostIOMMUContextClass.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/vfio/common.c                      | 69 +++++++++++++++++++++++++++++++++++
> >  include/hw/iommu/host_iommu_context.h |  3 ++
> >  include/hw/vfio/vfio-common.h         |  4 ++
> >  3 files changed, 76 insertions(+)
> >
> > diff --git a/hw/vfio/common.c b/hw/vfio/common.c index
> > c276732..5f3534d 100644
> > --- a/hw/vfio/common.c
> > +++ b/hw/vfio/common.c
> > @@ -1179,6 +1179,53 @@ static int vfio_get_iommu_type(VFIOContainer
> *container,
> >      return -EINVAL;
> >  }
> >
> > +static int vfio_host_iommu_ctx_pasid_alloc(HostIOMMUContext *iommu_ctx,
> > +                                           uint32_t min, uint32_t max,
> > +                                           uint32_t *pasid) {
> > +    VFIOContainer *container = container_of(iommu_ctx,
> > +                                            VFIOContainer, iommu_ctx);
> > +    struct vfio_iommu_type1_pasid_request req;
> > +    unsigned long argsz;
> you can easily avoid using argsz variable

oh, right. :-)

> > +    int ret;
> > +
> > +    argsz = sizeof(req);
> > +    req.argsz = argsz;
> > +    req.flags = VFIO_IOMMU_PASID_ALLOC;
> > +    req.alloc_pasid.min = min;
> > +    req.alloc_pasid.max = max;
> > +
> > +    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
> > +        ret = -errno;
> > +        error_report("%s: %d, alloc failed", __func__, ret);
> better use %m directly or strerror(errno) also include vbasedev->name?

or yes, vbasedev->name is also nice to have.

> > +        return ret;
> > +    }
> > +    *pasid = req.alloc_pasid.result;
> > +    return 0;
> > +}
> > +
> > +static int vfio_host_iommu_ctx_pasid_free(HostIOMMUContext *iommu_ctx,
> > +                                          uint32_t pasid) {
> > +    VFIOContainer *container = container_of(iommu_ctx,
> > +                                            VFIOContainer, iommu_ctx);
> > +    struct vfio_iommu_type1_pasid_request req;
> > +    unsigned long argsz;
> same

got it.

> > +    int ret;
> > +
> > +    argsz = sizeof(req);
> > +    req.argsz = argsz;
> > +    req.flags = VFIO_IOMMU_PASID_FREE;
> > +    req.free_pasid = pasid;
> > +
> > +    if (ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req)) {
> > +        ret = -errno;
> > +        error_report("%s: %d, free failed", __func__, ret);
> same

yep.
> > +        return ret;
> > +    }
> > +    return 0;
> > +}
> > +
> >  static int vfio_init_container(VFIOContainer *container, int group_fd,
> >                                 Error **errp)  { @@ -1791,3 +1838,25
> > @@ int vfio_eeh_as_op(AddressSpace *as, uint32_t op)
> >      }
> >      return vfio_eeh_container_op(container, op);  }
> > +
> > +static void vfio_host_iommu_context_class_init(ObjectClass *klass,
> > +                                                       void *data) {
> > +    HostIOMMUContextClass *hicxc = HOST_IOMMU_CONTEXT_CLASS(klass);
> > +
> > +    hicxc->pasid_alloc = vfio_host_iommu_ctx_pasid_alloc;
> > +    hicxc->pasid_free = vfio_host_iommu_ctx_pasid_free; }
> > +
> > +static const TypeInfo vfio_host_iommu_context_info = {
> > +    .parent = TYPE_HOST_IOMMU_CONTEXT,
> > +    .name = TYPE_VFIO_HOST_IOMMU_CONTEXT,
> > +    .class_init = vfio_host_iommu_context_class_init,
> Ah OK
> 
> This is the object inheriting from the abstract TYPE_HOST_IOMMU_CONTEXT.

yes. it is. :-)

> I initially thought VTDHostIOMMUContext was, sorry for the misunderstanding.

Ah, my fault, should have got it earlier. so we may have just aligned
in last Oct.

> Do you expect other HostIOMMUContext backends? Given the name and ops, it
> looks really related to VFIO?

For other backends, I guess you mean other passthru modules? If yes, I
think they should have their own type name. Just like vIOMMUs, the below
vIOMMUs defines their own type name and inherits the same parent.

static const TypeInfo vtd_iommu_memory_region_info = {
    .parent = TYPE_IOMMU_MEMORY_REGION,
    .name = TYPE_INTEL_IOMMU_MEMORY_REGION,
    .class_init = vtd_iommu_memory_region_class_init,
};

static const TypeInfo smmuv3_iommu_memory_region_info = {
    .parent = TYPE_IOMMU_MEMORY_REGION,
    .name = TYPE_SMMUV3_IOMMU_MEMORY_REGION,
    .class_init = smmuv3_iommu_memory_region_class_init,
};

static const TypeInfo amdvi_iommu_memory_region_info = {
    .parent = TYPE_IOMMU_MEMORY_REGION,
    .name = TYPE_AMD_IOMMU_MEMORY_REGION,
    .class_init = amdvi_iommu_memory_region_class_init,
};

Regards,
Yi Liu

