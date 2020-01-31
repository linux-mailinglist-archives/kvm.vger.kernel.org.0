Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B6214EC9B
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 13:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgAaMmd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 31 Jan 2020 07:42:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:55551 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgAaMmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 07:42:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 04:42:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,385,1574150400"; 
   d="scan'208";a="402646272"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga005.jf.intel.com with ESMTP; 31 Jan 2020 04:42:31 -0800
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jan 2020 04:42:15 -0800
Received: from shsmsx108.ccr.corp.intel.com (10.239.4.97) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 31 Jan 2020 04:42:14 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.197]) by
 SHSMSX108.ccr.corp.intel.com ([169.254.8.39]) with mapi id 14.03.0439.000;
 Fri, 31 Jan 2020 20:42:13 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v3 3/8] vfio: Reclaim PASIDs when application is down
Thread-Topic: [RFC v3 3/8] vfio: Reclaim PASIDs when application is down
Thread-Index: AQHV1pyX9vSsvffLj0+to6Wf6wB5HKgBzCoAgALuD6A=
Date:   Fri, 31 Jan 2020 12:42:11 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A199412@SHSMSX104.ccr.corp.intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-4-git-send-email-yi.l.liu@intel.com>
 <20200129165640.4f1d42e0@w520.home>
In-Reply-To: <20200129165640.4f1d42e0@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzIyOWFiNDUtNGE5ZC00NzcwLWFjMTgtYWRlYjRlMWE3YjJlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoic3hPXC90Smc3VTdYTUIxeDFCWFVRbW5xRHljeVlmTlwvWFJQbjRLaDdRcEZna3VnN01HSmg0MG1qVUtHazVSNjRkIn0=
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Thursday, January 30, 2020 7:57 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v3 3/8] vfio: Reclaim PASIDs when application is down
> 
> On Wed, 29 Jan 2020 04:11:47 -0800
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > From: Liu Yi L <yi.l.liu@intel.com>
> >
> > When userspace application is down, kernel should reclaim the PASIDs
> > allocated for this application to avoid PASID leak. This patch adds a
> > PASID list in vfio_mm structure to track the allocated PASIDs. The
> > PASID reclaim will be triggered when last vfio container is released.
> >
> > Previous discussions:
> > https://patchwork.kernel.org/patch/11209429/
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio.c  | 61
> > +++++++++++++++++++++++++++++++++++++++++++++++++---
> >  include/linux/vfio.h |  6 ++++++
> >  2 files changed, 64 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c index
> > c43c757..425d60a 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -2148,15 +2148,31 @@ static struct vfio_mm *vfio_create_mm(struct
> mm_struct *mm)
> >  	vmm->pasid_quota = VFIO_DEFAULT_PASID_QUOTA;
> >  	vmm->pasid_count = 0;
> >  	mutex_init(&vmm->pasid_lock);
> > +	INIT_LIST_HEAD(&vmm->pasid_list);
> >
> >  	list_add(&vmm->vfio_next, &vfio.vfio_mm_list);
> >
> >  	return vmm;
> >  }
> >
> > +static void vfio_mm_reclaim_pasid(struct vfio_mm *vmm) {
> > +	struct pasid_node *pnode, *tmp;
> > +
> > +	mutex_lock(&vmm->pasid_lock);
> > +	list_for_each_entry_safe(pnode, tmp, &vmm->pasid_list, next) {
> > +		pr_info("%s, reclaim pasid: %u\n", __func__, pnode->pasid);
> > +		list_del(&pnode->next);
> > +		ioasid_free(pnode->pasid);
> > +		kfree(pnode);
> > +	}
> > +	mutex_unlock(&vmm->pasid_lock);
> > +}
> > +
> >  static void vfio_mm_unlock_and_free(struct vfio_mm *vmm)  {
> >  	mutex_unlock(&vfio.vfio_mm_lock);
> > +	vfio_mm_reclaim_pasid(vmm);
> >  	kfree(vmm);
> >  }
> >
> > @@ -2204,6 +2220,39 @@ struct vfio_mm *vfio_mm_get_from_task(struct
> > task_struct *task)  }  EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> >
> > +/**
> > + * Caller should hold vmm->pasid_lock  */ static int
> > +vfio_mm_insert_pasid_node(struct vfio_mm *vmm, u32 pasid) {
> > +	struct pasid_node *pnode;
> > +
> > +	pnode = kzalloc(sizeof(*pnode), GFP_KERNEL);
> > +	if (!pnode)
> > +		return -ENOMEM;
> > +	pnode->pasid = pasid;
> > +	list_add(&pnode->next, &vmm->pasid_list);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * Caller should hold vmm->pasid_lock  */ static void
> > +vfio_mm_remove_pasid_node(struct vfio_mm *vmm, u32 pasid) {
> > +	struct pasid_node *pnode, *tmp;
> > +
> > +	list_for_each_entry_safe(pnode, tmp, &vmm->pasid_list, next) {
> > +		if (pnode->pasid == pasid) {
> > +			list_del(&pnode->next);
> > +			kfree(pnode);
> > +			break;
> > +		}
> 
> The _safe() list walk variant is only needed when we continue to walk the list after
> removing an entry.  Thanks,

Nice catch. thanks, :-)

Regards,
Yi Liu
