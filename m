Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3CFF14D8
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 12:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbfKFLSt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 6 Nov 2019 06:18:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:30880 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbfKFLSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 06:18:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 03:18:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,274,1569308400"; 
   d="scan'208";a="403695178"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by fmsmga006.fm.intel.com with ESMTP; 06 Nov 2019 03:18:48 -0800
Received: from fmsmsx113.amr.corp.intel.com (10.18.116.7) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 03:18:47 -0800
Received: from shsmsx152.ccr.corp.intel.com (10.239.6.52) by
 FMSMSX113.amr.corp.intel.com (10.18.116.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 6 Nov 2019 03:18:46 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.127]) by
 SHSMSX152.ccr.corp.intel.com ([169.254.6.2]) with mapi id 14.03.0439.000;
 Wed, 6 Nov 2019 19:18:43 +0800
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
Subject: RE: [RFC v2 04/22] hw/iommu: introduce IOMMUContext
Thread-Topic: [RFC v2 04/22] hw/iommu: introduce IOMMUContext
Thread-Index: AQHVimsnFZ9HHzIneEOC2B5kT89EDqduQAWAgA/RzpA=
Date:   Wed, 6 Nov 2019 11:18:42 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A0EF1B3@SHSMSX104.ccr.corp.intel.com>
References: <1571920483-3382-1-git-send-email-yi.l.liu@intel.com>
 <1571920483-3382-5-git-send-email-yi.l.liu@intel.com>
 <20191027173929.GK3552@umbus.metropole.lan>
In-Reply-To: <20191027173929.GK3552@umbus.metropole.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzllYzgxNjYtOWRhZS00NDEwLTk2NTctZmMxYTMwMmNjYTQyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoia0FrVllqaUNUVlwvc2p0aHI2ZU1LdnlBanZ3cTJjdEpwNlwvMGVhbXdQa1lPdngya0VDd1d5Nm5uM2VJWVBrMXdLIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson [mailto:david@gibson.dropbear.id.au]
> Sent: Monday, October 28, 2019 1:39 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v2 04/22] hw/iommu: introduce IOMMUContext
> 
> On Thu, Oct 24, 2019 at 08:34:25AM -0400, Liu Yi L wrote:
> > From: Peter Xu <peterx@redhat.com>
> >
> > This patch adds IOMMUContext as an abstract layer of IOMMU related
> > operations. The current usage of this abstract layer is setup dual-
> > stage IOMMU translation (vSVA) for vIOMMU.
> >
> > To setup dual-stage IOMMU translation, vIOMMU needs to propagate
> > guest changes to host via passthru channels (e.g. VFIO). To have
> > a better abstraction, it is better to avoid direct calling between
> > vIOMMU and VFIO. So we have this new structure to act as abstract
> > layer between VFIO and vIOMMU. So far, it is proposed to provide a
> > notifier mechanism, which registered by VFIO and fired by vIOMMU.
> >
> > For more background, may refer to the discussion below:
> >
> > https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg05022.html
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  hw/Makefile.objs         |  1 +
> >  hw/iommu/Makefile.objs   |  1 +
> >  hw/iommu/iommu.c         | 66 ++++++++++++++++++++++++++++++++++++++++
> >  include/hw/iommu/iommu.h | 79
> ++++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 147 insertions(+)
> >  create mode 100644 hw/iommu/Makefile.objs
> >  create mode 100644 hw/iommu/iommu.c
> >  create mode 100644 include/hw/iommu/iommu.h
> >
> > diff --git a/hw/Makefile.objs b/hw/Makefile.objs
> > index ece6cc3..ac19f9c 100644
> > --- a/hw/Makefile.objs
> > +++ b/hw/Makefile.objs
> > @@ -39,6 +39,7 @@ devices-dirs-y += xen/
> >  devices-dirs-$(CONFIG_MEM_DEVICE) += mem/
> >  devices-dirs-y += semihosting/
> >  devices-dirs-y += smbios/
> > +devices-dirs-y += iommu/
> >  endif
> >
> >  common-obj-y += $(devices-dirs-y)
> > diff --git a/hw/iommu/Makefile.objs b/hw/iommu/Makefile.objs
> > new file mode 100644
> > index 0000000..0484b79
> > --- /dev/null
> > +++ b/hw/iommu/Makefile.objs
> > @@ -0,0 +1 @@
> > +obj-y += iommu.o
> > diff --git a/hw/iommu/iommu.c b/hw/iommu/iommu.c
> > new file mode 100644
> > index 0000000..2391b0d
> > --- /dev/null
> > +++ b/hw/iommu/iommu.c
> > @@ -0,0 +1,66 @@
> > +/*
> > + * QEMU abstract of IOMMU context
> > + *
> > + * Copyright (C) 2019 Red Hat Inc.
> > + *
> > + * Authors: Peter Xu <peterx@redhat.com>,
> > + *          Liu Yi L <yi.l.liu@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > +
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > +
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include "qemu/osdep.h"
> > +#include "hw/iommu/iommu.h"
> > +
> > +void iommu_ctx_notifier_register(IOMMUContext *iommu_ctx,
> > +                                 IOMMUCTXNotifier *n,
> > +                                 IOMMUCTXNotifyFn fn,
> > +                                 IOMMUCTXEvent event)
> > +{
> > +    n->event = event;
> > +    n->iommu_ctx_event_notify = fn;
> > +    QLIST_INSERT_HEAD(&iommu_ctx->iommu_ctx_notifiers, n, node);
> 
> Having this both modify the IOMMUCTXNotifier structure and insert it
> in the list seems confusing to me - and gratuitously different from
> the interface for both IOMMUNotifier and Notifier.
> 
> Separating out a iommu_ctx_notifier_init() as a helper and having
> register take a fully initialized structure seems better to me.

Thanks, will do it in next version.

> > +    return;
> 
> Using an explicit return at the end of a function returning void is an
> odd style.

got it, will fix it in next version.

> 
> > +}
> > +
> > +void iommu_ctx_notifier_unregister(IOMMUContext *iommu_ctx,
> > +                                   IOMMUCTXNotifier *notifier)
> > +{
> > +    IOMMUCTXNotifier *cur, *next;
> > +
> > +    QLIST_FOREACH_SAFE(cur, &iommu_ctx->iommu_ctx_notifiers, node, next) {
> > +        if (cur == notifier) {
> > +            QLIST_REMOVE(cur, node);
> > +            break;
> > +        }
> > +    }
> > +}
> > +
> > +void iommu_ctx_event_notify(IOMMUContext *iommu_ctx,
> > +                            IOMMUCTXEventData *event_data)
> > +{
> > +    IOMMUCTXNotifier *cur;
> > +
> > +    QLIST_FOREACH(cur, &iommu_ctx->iommu_ctx_notifiers, node) {
> > +        if ((cur->event == event_data->event) &&
> > +                                 cur->iommu_ctx_event_notify) {
> 
> Do you actually need the test on iommu_ctx_event_notify?  I can't see
> any reason to register a notifier with a NULL function pointer.

sure, let me remove the check. I may have been too careful here. :-)

> > +            cur->iommu_ctx_event_notify(cur, event_data);
> > +        }
> > +    }
> > +}
> > +
> > +void iommu_context_init(IOMMUContext *iommu_ctx)
> > +{
> > +    QLIST_INIT(&iommu_ctx->iommu_ctx_notifiers);
> > +}
> > diff --git a/include/hw/iommu/iommu.h b/include/hw/iommu/iommu.h
> > new file mode 100644
> > index 0000000..c22c442
> > --- /dev/null
> > +++ b/include/hw/iommu/iommu.h
> > @@ -0,0 +1,79 @@
> > +/*
> > + * QEMU abstraction of IOMMU Context
> > + *
> > + * Copyright (C) 2019 Red Hat Inc.
> > + *
> > + * Authors: Peter Xu <peterx@redhat.com>,
> > + *          Liu, Yi L <yi.l.liu@intel.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > +
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > +
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program; if not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#ifndef HW_PCI_PASID_H
> > +#define HW_PCI_PASID_H
> 
> These guards need to be updated for the new header name.

Oops, thanks for spotting it out.

> > +
> > +#include "qemu/queue.h"
> > +#ifndef CONFIG_USER_ONLY
> > +#include "exec/hwaddr.h"
> > +#endif
> > +
> > +typedef struct IOMMUContext IOMMUContext;
> > +
> > +enum IOMMUCTXEvent {
> > +    IOMMU_CTX_EVENT_NUM,
> > +};
> > +typedef enum IOMMUCTXEvent IOMMUCTXEvent;
> > +
> > +struct IOMMUCTXEventData {
> > +    IOMMUCTXEvent event;
> > +    uint64_t length;
> > +    void *data;
> > +};
> > +typedef struct IOMMUCTXEventData IOMMUCTXEventData;
> > +
> > +typedef struct IOMMUCTXNotifier IOMMUCTXNotifier;
> > +
> > +typedef void (*IOMMUCTXNotifyFn)(IOMMUCTXNotifier *notifier,
> > +                                 IOMMUCTXEventData *event_data);
> > +
> > +struct IOMMUCTXNotifier {
> > +    IOMMUCTXNotifyFn iommu_ctx_event_notify;
> > +    /*
> > +     * What events we are listening to. Let's allow multiple event
> > +     * registrations from beginning.
> > +     */
> > +    IOMMUCTXEvent event;
> > +    QLIST_ENTRY(IOMMUCTXNotifier) node;
> > +};
> > +
> > +/*
> > + * This is an abstraction of IOMMU context.
> > + */
> > +struct IOMMUContext {
> > +    uint32_t pasid;
> 
> This confuses me a bit.  I thought the idea was that IOMMUContext with
> SVM would represent all the PASIDs in use, but here we have a specific
> pasid stored in the structure.

It's added by mistake. Should not be included. No patch will use this field.
Will remove it. Thanks for the careful review.

Thanks,
Yi Liu

