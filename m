Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB7EF15E6
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730103AbfKFMPG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Nov 2019 07:15:06 -0500
Received: from mga04.intel.com ([192.55.52.120]:50828 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfKFMPG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 07:15:06 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 04:15:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="214226967"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga002.jf.intel.com with ESMTP; 06 Nov 2019 04:15:03 -0800
Received: from fmsmsx151.amr.corp.intel.com (10.18.125.4) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 04:15:03 -0800
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 FMSMSX151.amr.corp.intel.com (10.18.125.4) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 04:14:55 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.248]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 20:14:50 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Thread-Topic: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
 alloc/free
Thread-Index: AQHVimsw6XlsA5+cTkCxXGelXmRQYKdxCjoAgA0JSAA=
Date:   Wed, 6 Nov 2019 12:14:50 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EF2CE@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
 <20191029121544.GS3552@umbus.metropole.lan>
In-Reply-To: <20191029121544.GS3552@umbus.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDk5OWNhMzAtNjA3Mi00Y2U4LWE3NWItNTU5NDM1MWMyYmRmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoib3d1cEpFa1NObE9rU0JQMHdXcm1lNDhDeE94VW5QMXY2ZkdGaVlDaTBrVHZMdXNcL3p2NnNBSWREYVJhK1d2T3MifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson [mailto:david@gibson.dropbear.id.au]
> Sent: Tuesday, October 29, 2019 8:16 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid alloc/free
> 
> On Thu, Oct 24, 2019 at 08:34:30AM -0400, Liu Yi L wrote:
> > This patch adds pasid alloc/free notifiers for vfio-pci. It is
> > supposed to be fired by vIOMMU. VFIO then sends PASID allocation
> > or free request to host.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/vfio/common.c         |  9 ++++++
> >  hw/vfio/pci.c            | 81
> ++++++++++++++++++++++++++++++++++++++++++++++++
> >  include/hw/iommu/iommu.h | 15 +++++++++
> >  3 files changed, 105 insertions(+)
> >
> > diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> > index d418527..e6ad21c 100644
> > --- a/hw/vfio/common.c
> > +++ b/hw/vfio/common.c
> > @@ -1436,6 +1436,7 @@ static void vfio_disconnect_container(VFIOGroup
> *group)
> >      if (QLIST_EMPTY(&container->group_list)) {
> >          VFIOAddressSpace *space = container->space;
> >          VFIOGuestIOMMU *giommu, *tmp;
> > +        VFIOIOMMUContext *giommu_ctx, *ctx;
> >
> >          QLIST_REMOVE(container, next);
> >
> > @@ -1446,6 +1447,14 @@ static void vfio_disconnect_container(VFIOGroup
> *group)
> >              g_free(giommu);
> >          }
> >
> > +        QLIST_FOREACH_SAFE(giommu_ctx, &container->iommu_ctx_list,
> > +                                                   iommu_ctx_next, ctx) {
> > +            iommu_ctx_notifier_unregister(giommu_ctx->iommu_ctx,
> > +                                                      &giommu_ctx->n);
> > +            QLIST_REMOVE(giommu_ctx, iommu_ctx_next);
> > +            g_free(giommu_ctx);
> > +        }
> > +
> >          trace_vfio_disconnect_container(container->fd);
> >          close(container->fd);
> >          g_free(container);
> > diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
> > index 12fac39..8721ff6 100644
> > --- a/hw/vfio/pci.c
> > +++ b/hw/vfio/pci.c
> > @@ -2699,11 +2699,80 @@ static void
> vfio_unregister_req_notifier(VFIOPCIDevice *vdev)
> >      vdev->req_enabled = false;
> >  }
> >
> > +static void vfio_register_iommu_ctx_notifier(VFIOPCIDevice *vdev,
> > +                                             IOMMUContext *iommu_ctx,
> > +                                             IOMMUCTXNotifyFn fn,
> > +                                             IOMMUCTXEvent event)
> > +{
> > +    VFIOContainer *container = vdev->vbasedev.group->container;
> > +    VFIOIOMMUContext *giommu_ctx;
> > +
> > +    giommu_ctx = g_malloc0(sizeof(*giommu_ctx));
> > +    giommu_ctx->container = container;
> > +    giommu_ctx->iommu_ctx = iommu_ctx;
> > +    QLIST_INSERT_HEAD(&container->iommu_ctx_list,
> > +                      giommu_ctx,
> > +                      iommu_ctx_next);
> > +    iommu_ctx_notifier_register(iommu_ctx,
> > +                                &giommu_ctx->n,
> > +                                fn,
> > +                                event);
> > +}
> > +
> > +static void vfio_iommu_pasid_alloc_notify(IOMMUCTXNotifier *n,
> > +                                          IOMMUCTXEventData *event_data)
> > +{
> > +    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
> > +    VFIOContainer *container = giommu_ctx->container;
> > +    IOMMUCTXPASIDReqDesc *pasid_req =
> > +                              (IOMMUCTXPASIDReqDesc *) event_data->data;
> > +    struct vfio_iommu_type1_pasid_request req;
> > +    unsigned long argsz;
> > +    int pasid;
> > +
> > +    argsz = sizeof(req);
> > +    req.argsz = argsz;
> > +    req.flag = VFIO_IOMMU_PASID_ALLOC;
> > +    req.min_pasid = pasid_req->min_pasid;
> > +    req.max_pasid = pasid_req->max_pasid;
> > +
> > +    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > +    if (pasid < 0) {
> > +        error_report("%s: %d, alloc failed", __func__, -errno);
> > +    }
> > +    pasid_req->alloc_result = pasid;
> 
> Altering the event data from the notifier doesn't make sense.  By
> definition there can be multiple notifiers on the chain, so in that
> case which one is responsible for updating the writable field?

I guess you mean multiple pasid_alloc nofitiers. right?

It works for VT-d now, as Intel vIOMMU maintains the IOMMUContext
per-bdf. And there will be only 1 pasid_alloc notifier in the chain. But, I
agree it is not good if other module just share an IOMMUConext across
devices. Definitely, it would have multiple pasid_alloc notifiers.

How about enforcing IOMMUContext layer to only invoke one successful
pasid_alloc/free notifier if PASID_ALLOC/FREE event comes? pasid
alloc/free are really special as it requires feedback. And a potential
benefit is that the pasid_alloc/free will not be affected by hot plug
scenario. There will be always a notifier to work for pasid_alloc/free
work unless all passthru devices are hot plugged. How do you think? Or
if any other idea?

> > +}
> > +
> > +static void vfio_iommu_pasid_free_notify(IOMMUCTXNotifier *n,
> > +                                          IOMMUCTXEventData *event_data)
> > +{
> > +    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext, n);
> > +    VFIOContainer *container = giommu_ctx->container;
> > +    IOMMUCTXPASIDReqDesc *pasid_req =
> > +                              (IOMMUCTXPASIDReqDesc *) event_data->data;
> > +    struct vfio_iommu_type1_pasid_request req;
> > +    unsigned long argsz;
> > +    int ret = 0;
> > +
> > +    argsz = sizeof(req);
> > +    req.argsz = argsz;
> > +    req.flag = VFIO_IOMMU_PASID_FREE;
> > +    req.pasid = pasid_req->pasid;
> > +
> > +    ret = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > +    if (ret != 0) {
> > +        error_report("%s: %d, pasid %u free failed",
> > +                   __func__, -errno, (unsigned) pasid_req->pasid);
> > +    }
> > +    pasid_req->free_result = ret;
> 
> Same problem here.

yep, as above proposal.

> > +}
> > +
> >  static void vfio_realize(PCIDevice *pdev, Error **errp)
> >  {
> >      VFIOPCIDevice *vdev = PCI_VFIO(pdev);
> >      VFIODevice *vbasedev_iter;
> >      VFIOGroup *group;
> > +    IOMMUContext *iommu_context;
> >      char *tmp, *subsys, group_path[PATH_MAX], *group_name;
> >      Error *err = NULL;
> >      ssize_t len;
> > @@ -3000,6 +3069,18 @@ static void vfio_realize(PCIDevice *pdev, Error **errp)
> >      vfio_register_req_notifier(vdev);
> >      vfio_setup_resetfn_quirk(vdev);
> >
> > +    iommu_context = pci_device_iommu_context(pdev);
> > +    if (iommu_context) {
> > +        vfio_register_iommu_ctx_notifier(vdev,
> > +                                         iommu_context,
> > +                                         vfio_iommu_pasid_alloc_notify,
> > +                                         IOMMU_CTX_EVENT_PASID_ALLOC);
> > +        vfio_register_iommu_ctx_notifier(vdev,
> > +                                         iommu_context,
> > +                                         vfio_iommu_pasid_free_notify,
> > +                                         IOMMU_CTX_EVENT_PASID_FREE);
> > +    }
> > +
> >      return;
> >
> >  out_teardown:
> > diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
> > index c22c442..4352afd 100644
> > --- a/include/hw/iommu/iommu.h
> > +++ b/include/hw/iommu/iommu.h
> > @@ -31,10 +31,25 @@
> >  typedef struct IOMMUContext IOMMUContext;
> >
> >  enum IOMMUCTXEvent {
> > +    IOMMU_CTX_EVENT_PASID_ALLOC,
> > +    IOMMU_CTX_EVENT_PASID_FREE,
> >      IOMMU_CTX_EVENT_NUM,
> >  };
> >  typedef enum IOMMUCTXEvent IOMMUCTXEvent;
> >
> > +union IOMMUCTXPASIDReqDesc {
> > +    struct {
> > +        uint32_t min_pasid;
> > +        uint32_t max_pasid;
> > +        int32_t alloc_result; /* pasid allocated for the alloc request */
> > +    };
> > +    struct {
> > +        uint32_t pasid; /* pasid to be free */
> > +        int free_result;
> > +    };
> > +};
> 
> Apart from theproblem with writable fields, using a big union for
> event data is pretty ugly.  If you need this different information for
> the different events, it might make more sense to have a separate
> notifier chain with a separate call interface for each event type,
> rather than trying to multiplex them together.

sure, I'll de-couple them. Nice catch.

Thanks,
Yi Liu

