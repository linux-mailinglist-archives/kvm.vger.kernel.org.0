Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3152F109974
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 08:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfKZHHf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 26 Nov 2019 02:07:35 -0500
Received: from mga07.intel.com ([134.134.136.100]:43079 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbfKZHHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Nov 2019 02:07:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2019 23:07:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,244,1571727600"; 
   d="scan'208";a="211325433"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga006.jf.intel.com with ESMTP; 25 Nov 2019 23:07:33 -0800
Received: from fmsmsx126.amr.corp.intel.com (10.18.125.43) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 25 Nov 2019 23:07:33 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX126.amr.corp.intel.com (10.18.125.43) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 25 Nov 2019 23:07:33 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.149]) with mapi id 14.03.0439.000;
 Tue, 26 Nov 2019 15:07:31 +0800
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
Thread-Index: AQHVimsw6XlsA5+cTkCxXGelXmRQYKdxCjoAgA0JSACAFQdKAIAKE4Wg
Date:   Tue, 26 Nov 2019 07:07:31 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A10E709@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-10-git-send-email-yi.l.liu@intel.com>
 <20191029121544.GS3552@umbus.metropole.lan>
 <A2975661238FB949B60364EF0F2C25743A0EF2CE@SHSMSX104.ccr.corp.intel.com>
 <20191120042752.GF5582@umbus.fritz.box>
In-Reply-To: <20191120042752.GF5582@umbus.fritz.box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZGIyZWI2NTEtMzM4Yi00YzYxLWJiYTMtMWVjYjU5NmY2NGNjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS2xaV3pkV0tXeHJQcGlNakdESWZ6S2NOaUtKZDExMWZrNGJ5V0dLRUlFd0l0M0RzMGswaWkrVUl0Vm9lRUxxSyJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

> From: David Gibson < david@gibson.dropbear.id.au>
> Sent: Wednesday, November 20, 2019 12:28 PM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid alloc/free
> 
> On Wed, Nov 06, 2019 at 12:14:50PM +0000, Liu, Yi L wrote:
> > > From: David Gibson [mailto:david@gibson.dropbear.id.au]
> > > Sent: Tuesday, October 29, 2019 8:16 PM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v2 09/22] vfio/pci: add iommu_context notifier for pasid
> alloc/free
> > >
> > > On Thu, Oct 24, 2019 at 08:34:30AM -0400, Liu Yi L wrote:
> > > > This patch adds pasid alloc/free notifiers for vfio-pci. It is
> > > > supposed to be fired by vIOMMU. VFIO then sends PASID allocation
> > > > or free request to host.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > ---
> > > >  hw/vfio/common.c         |  9 ++++++
> > > >  hw/vfio/pci.c            | 81
[...]
> > > > +
> > > > +static void vfio_iommu_pasid_alloc_notify(IOMMUCTXNotifier *n,
> > > > +                                          IOMMUCTXEventData *event_data)
> > > > +{
> > > > +    VFIOIOMMUContext *giommu_ctx = container_of(n, VFIOIOMMUContext,
> n);
> > > > +    VFIOContainer *container = giommu_ctx->container;
> > > > +    IOMMUCTXPASIDReqDesc *pasid_req =
> > > > +                              (IOMMUCTXPASIDReqDesc *) event_data->data;
> > > > +    struct vfio_iommu_type1_pasid_request req;
> > > > +    unsigned long argsz;
> > > > +    int pasid;
> > > > +
> > > > +    argsz = sizeof(req);
> > > > +    req.argsz = argsz;
> > > > +    req.flag = VFIO_IOMMU_PASID_ALLOC;
> > > > +    req.min_pasid = pasid_req->min_pasid;
> > > > +    req.max_pasid = pasid_req->max_pasid;
> > > > +
> > > > +    pasid = ioctl(container->fd, VFIO_IOMMU_PASID_REQUEST, &req);
> > > > +    if (pasid < 0) {
> > > > +        error_report("%s: %d, alloc failed", __func__, -errno);
> > > > +    }
> > > > +    pasid_req->alloc_result = pasid;
> > >
> > > Altering the event data from the notifier doesn't make sense.  By
> > > definition there can be multiple notifiers on the chain, so in that
> > > case which one is responsible for updating the writable field?
> >
> > I guess you mean multiple pasid_alloc nofitiers. right?
> >
> > It works for VT-d now, as Intel vIOMMU maintains the IOMMUContext
> > per-bdf. And there will be only 1 pasid_alloc notifier in the chain. But, I
> > agree it is not good if other module just share an IOMMUConext across
> > devices. Definitely, it would have multiple pasid_alloc notifiers.
> 
> Right.
> 
> > How about enforcing IOMMUContext layer to only invoke one successful
> > pasid_alloc/free notifier if PASID_ALLOC/FREE event comes? pasid
> > alloc/free are really special as it requires feedback. And a potential
> > benefit is that the pasid_alloc/free will not be affected by hot plug
> > scenario. There will be always a notifier to work for pasid_alloc/free
> > work unless all passthru devices are hot plugged. How do you think? Or
> > if any other idea?
> 
> Hrm, that still doesn't seem right to me.  I don't think a notifier is
> really the right mechanism for something that needs to return values.
> This seems like something where you need to find a _single_
> responsible object and call a method / callback on that specifically.

Agreed. For alloc/free operations, we need an explicit calling instead
of notifier which is usally to be a chain notification.

> But it seems to me there's a more fundamental problem here.  AIUI the
> idea is that a single IOMMUContext could hold multiple devices.  But
> if the devices are responsible for assigning their own pasid values
> (by passing that decisionon to the host through vfio) then that really
> can't work.
>
> I'm assuming it's impossible from the hardware side to virtualize the
> pasids (so that we could assign them from qemu without host
> intervention).

Actually, this is possible. On Intel platform, we've introduced ENQCMD
to do PASID translation which essentially supports PASID virtualization.
You may get more details in section 3.3. This is also why we want to have
host's intervention in PASID alloc/free.

https://software.intel.com/sites/default/files/managed/c5/15/architecture-instruction-set-extensions-programming-reference.pdf

> If so, then the pasid allocation really has to be a Context level, not
> device level operation.  We'd have to wire the VFIO backend up to the
> context itself, not a device... I'm not immediately sure how to do
> that, though.

I think for the pasid alloc/free, we want it to be a vfio container
operation. right? However, we cannot expose vfio container out of vfio
or we don't want to do such thing. Then I'm wondering if we can have
a PASIDObject which is allocated per container creation, and registered
to vIOMMU. The PASIDObject can provide pasid alloc/free ops. vIOMMU can
consume the ops to get host pasid or free a host pasid.

While for the current IOMMUContext in this patchset, I think we may keep
it to support bind_gpasid and iommu_cache_invalidate. Also, as far as I
can see, we may want to extend it to support host IOMMU translation fault
injection to vIOMMU. This is also an important operation after config
nested translation for vIOMMU (a.k.a. dual stage translation).

> --
> David Gibson                  | I'll have my music baroque, and my code
> david AT gibson.dropbear.id.au        | minimalist, thank you.  NOT _the_ _other_
>                               | _way_ _around_!
> http://www.ozlabs.org/~dgibson

Thanks,
Yi Liu
