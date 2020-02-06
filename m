Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD0A815414C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgBFJlw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 6 Feb 2020 04:41:52 -0500
Received: from mga03.intel.com ([134.134.136.65]:13110 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgBFJlw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 04:41:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 01:41:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,409,1574150400"; 
   d="scan'208";a="311644917"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by orsmga001.jf.intel.com with ESMTP; 06 Feb 2020 01:41:51 -0800
Received: from fmsmsx116.amr.corp.intel.com (10.18.116.20) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 6 Feb 2020 01:41:50 -0800
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx116.amr.corp.intel.com (10.18.116.20) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 6 Feb 2020 01:41:50 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.225]) with mapi id 14.03.0439.000;
 Thu, 6 Feb 2020 17:41:49 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     'Alex Williamson' <alex.williamson@redhat.com>
CC:     "'eric.auger@redhat.com'" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "'jacob.jun.pan@linux.intel.com'" <jacob.jun.pan@linux.intel.com>,
        "'joro@8bytes.org'" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "'jean-philippe.brucker@arm.com'" <jean-philippe.brucker@arm.com>,
        "'peterx@redhat.com'" <peterx@redhat.com>,
        "'iommu@lists.linux-foundation.org'" 
        <iommu@lists.linux-foundation.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHV1pyWdXmNxNYiSUCDLwZiDlOrAKgBy+IAgALeXlCACUe2gA==
Date:   Thu, 6 Feb 2020 09:41:48 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1B1B5E@SHSMSX104.ccr.corp.intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-2-git-send-email-yi.l.liu@intel.com>
 <20200129165540.335774d5@w520.home>
 <A2975661238FB949B60364EF0F2C25743A1993E8@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1993E8@SHSMSX104.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODk5Y2JlYjEtZjRjMi00ZTI3LWJjNTYtY2NlZmMyZWZhYjBlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaVZFb3VjY1ZoWEVKd3JcL1F1dEhIamZ3NDE2RzdISUZRdlZ2UzBlbzIzVmpqcDVxa3FSWDE5c3VDRFYxNkRrTVEifQ==
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Friday, January 31, 2020 8:41 PM
> To: Alex Williamson <alex.williamson@redhat.com>
> Subject: RE: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
> 
> Hi Alex,
> 
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Thursday, January 30, 2020 7:56 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v3 1/8] vfio: Add
> > VFIO_IOMMU_PASID_REQUEST(alloc/free)
> >
> > On Wed, 29 Jan 2020 04:11:45 -0800
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
[...]
> > > +
> > > +int vfio_mm_pasid_alloc(struct vfio_mm *vmm, int min, int max) {
> > > +	ioasid_t pasid;
> > > +	int ret = -ENOSPC;
> > > +
> > > +	mutex_lock(&vmm->pasid_lock);
> > > +	if (vmm->pasid_count >= vmm->pasid_quota) {
> > > +		ret = -ENOSPC;
> > > +		goto out_unlock;
> > > +	}
> > > +	/* Track ioasid allocation owner by mm */
> > > +	pasid = ioasid_alloc((struct ioasid_set *)vmm->mm, min,
> > > +				max, NULL);
> >
> > Is mm effectively only a token for this?  Maybe we should have a
> > struct vfio_mm_token since gets and puts are not creating a reference
> > to an mm, but to an "mm token".
> 
> yes, it is supposed to be a kind of token. vfio_mm_token is better naming. :-)

Hi Alex,

Just to double check if I got your point. Your point is to have a separate structure
which is only wrap of mm or just renaming current vfio_mm would be enough?


Regards,
Yi Liu

