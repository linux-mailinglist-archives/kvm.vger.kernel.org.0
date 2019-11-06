Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E589F15F9
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfKFMWx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Nov 2019 07:22:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:61598 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbfKFMWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 07:22:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 04:22:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="402339407"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 06 Nov 2019 04:22:48 -0800
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 04:22:47 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.200]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 20:22:46 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 14/22] vfio/pci: add iommu_context notifier for pasid
 bind/unbind
Thread-Topic: [RFC v2 14/22] vfio/pci: add iommu_context notifier for pasid
 bind/unbind
Thread-Index: AQHVims1OZV2XVCCuEyc7KnxOKt2Oqd6t5AAgANrjkA=
Date:   Wed, 6 Nov 2019 12:22:46 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EF2F1@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-15-git-send-email-yi.l.liu@intel.com>
 <20191104160228.GG3552@umbus.metropole.lan>
In-Reply-To: <20191104160228.GG3552@umbus.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOGU5ZTIzNWYtNmY5My00NDlhLWI0ZjYtZTNkY2QyYjFlYzA3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN0VWdlJUYVA1T2lIZ21oeUd2Ykt2Y0JtbjV5VXk1ZVJrOVlTemRkXC82TFZNbWhjblU2ZFJyXC96eUpIWGtWcW1HIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Tuesday, November 5, 2019 12:02 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 14/22] vfio/pci: add iommu_context notifier for pasid
> bind/unbind
> 
> On Thu, Oct 24, 2019 at 08:34:35AM -0400, Liu Yi L wrote:
> > This patch adds notifier for pasid bind/unbind. VFIO registers this
> > notifier to listen to the dual-stage translation (a.k.a. nested
> > translation) configuration changes and propagate to host. Thus vIOMMU
> > is able to set its translation structures to host.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/vfio/pci.c            | 39 +++++++++++++++++++++++++++++++++++++++
> >  include/hw/iommu/iommu.h | 11 +++++++++++
> >  2 files changed, 50 insertions(+)
> >
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > index 8721ff6..012b8ed 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -2767,6 +2767,41 @@ static void
> vfio_iommu_pasid_free_notify(IOMMUCTXNotifier *n,
> >      pasid_req->free_result = ret;
> >  }
> >
> > +static void vfio_iommu_pasid_bind_notify(IOMMUCTXNotifier *n,
> > +                                         IOMMUCTXEventData *event_data)
> > +{
> > +#ifdef __linux__
> 
> Is hw/vfio/pci.c even built on non-linux hosts?

I'm not quite sure. It's based a comment from RFC v1. I think it could somehow
prevent compiling issue when doing code porting. So I added it. If it's impossible
to build on non-linux hosts per your experience, I can remove it to make things
simple.

> > +    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
> > +    VFIOContainer *container = giommu_ctx->container;
> > +    IOMMUCTXPASIDBindData *pasid_bind =
> > +                              (IOMMUCTXPASIDBindData *) event_data->data;
> > +    struct vfio_iommu_type1_bind *bind;
> > +    struct iommu_gpasid_bind_data *bind_data;
> > +    unsigned long argsz;
> > +
> > +    argsz = sizeof(*bind) + sizeof(*bind_data);
> > +    bind = g_malloc0(argsz);
> > +    bind->argsz = argsz;
> > +    bind->bind_type = VFIO_IOMMU_BIND_GUEST_PASID;
> > +    bind_data = (struct iommu_gpasid_bind_data *) &bind->data;
> > +    *bind_data = *pasid_bind->data;
> > +
> > +    if (pasid_bind->flag & IOMMU_CTX_BIND_PASID) {
> > +        if (ioctl(container->fd, VFIO_IOMMU_BIND, bind) != 0) {
> > +            error_report("%s: pasid (%llu:%llu) bind failed: %d", __func__,
> > +                         bind_data->gpasid, bind_data->hpasid, -errno);
> > +        }
> > +    } else if (pasid_bind->flag & IOMMU_CTX_UNBIND_PASID) {
> > +        if (ioctl(container->fd, VFIO_IOMMU_UNBIND, bind) != 0) {
> > +            error_report("%s: pasid (%llu:%llu) unbind failed: %d", __func__,
> > +                         bind_data->gpasid, bind_data->hpasid, -errno);
> > +        }
> > +    }
> > +
> > +    g_free(bind);
> > +#endif
> > +}
> > +
> >  static void vfio_realize(PCIDevice *pdev, Error **errp)
> >  {
> >      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> > @@ -3079,6 +3114,10 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
> >                                           iommu_context,
> >                                           vfio_iommu_pasid_free_notify,
> >                                           IOMMU_CTX_EVENT_PASID_FREE);
> > +        vfio_register_iommu_ctx_notifier(vdev,
> > +                                         iommu_context,
> > +                                         vfio_iommu_pasid_bind_notify,
> > +                                         IOMMU_CTX_EVENT_PASID_BIND);
> >      }
> >
> >      return;
> > diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
> > index 4352afd..4f21aa1 100644
> > --- a/include/hw/iommu/iommu.h
> > +++ b/include/hw/iommu/iommu.h
> > @@ -33,6 +33,7 @@ typedef struct IOMMUContext IOMMUContext;
> >  enum IOMMUCTXEvent {
> >      IOMMU_CTX_EVENT_PASID_ALLOC,
> >      IOMMU_CTX_EVENT_PASID_FREE,
> > +    IOMMU_CTX_EVENT_PASID_BIND,
> >      IOMMU_CTX_EVENT_NUM,
> >  };
> >  typedef enum IOMMUCTXEvent IOMMUCTXEvent;
> > @@ -50,6 +51,16 @@ union IOMMUCTXPASIDReqDesc {
> >  };
> >  typedef union IOMMUCTXPASIDReqDesc IOMMUCTXPASIDReqDesc;
> >
> > +struct IOMMUCTXPASIDBindData {
> > +#define IOMMU_CTX_BIND_PASID   (1 << 0)
> > +#define IOMMU_CTX_UNBIND_PASID (1 << 1)
> > +    uint32_t flag;
> > +#ifdef __linux__
> > +    struct iommu_gpasid_bind_data *data;
> 
> Embedding a linux specific structure in the notification message seems
> dubious to me.

Just similar as your above comment in this thread. If we don't want to add
it there, then here it is also unnecessary.

@Eric, do you think it is still necessary to add the __linux__ marco here?

Thanks,
Yi Liu
