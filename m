Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A722A162007
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 06:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgBRFHz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 18 Feb 2020 00:07:55 -0500
Received: from mga12.intel.com ([192.55.52.136]:8794 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725263AbgBRFHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 00:07:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Feb 2020 21:07:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,455,1574150400"; 
   d="scan'208";a="282689196"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Feb 2020 21:07:54 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 17 Feb 2020 21:07:53 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.126]) with mapi id 14.03.0439.000;
 Tue, 18 Feb 2020 13:07:51 +0800
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
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
Subject: RE: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Topic: [RFC v3 1/8] vfio: Add VFIO_IOMMU_PASID_REQUEST(alloc/free)
Thread-Index: AQHV1pyWdXmNxNYiSUCDLwZiDlOrAKgBy+IAgALeXlCAG9SJ8A==
Date:   Tue, 18 Feb 2020 05:07:50 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1C0D93@SHSMSX104.ccr.corp.intel.com>
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
> > > +static int vfio_iommu_type1_pasid_free(struct vfio_iommu *iommu,
> > > +				       unsigned int pasid)
> > > +{
> > > +	struct vfio_mm *vmm = iommu->vmm;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&iommu->lock);
> > > +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> >
> > But we could have been IOMMU backed when the pasid was allocated, did we
> just
> > leak something?  In fact, I didn't spot anything in this series that handles
> > a container with pasids allocated losing iommu backing.
> > I'd think we want to release all pasids when that happens since permission for
> > the user to hold pasids goes along with having an iommu backed device.
> 
> oh, yes. If a container lose iommu backend, then needs to reclaim the allocated
> PASIDs. right? I'll add it. :-)

Hi Alex,

I went through the flow again. Maybe current series has already covered
it. There is vfio_mm which is used to track allocated PASIDs. Its life
cycle is type1 driver open and release. If I understand it correctly,
type1 driver release happens when there is no more iommu backed groups
in a container.

static void __vfio_group_unset_container(struct vfio_group *group)
{
[...]

	/* Detaching the last group deprivileges a container, remove iommu */
	if (driver && list_empty(&container->group_list)) {
		driver->ops->release(container->iommu_data);
		module_put(driver->ops->owner);
		container->iommu_driver = NULL;
		container->iommu_data = NULL;
	}
[...]
}

Regards,
Yi Liu


