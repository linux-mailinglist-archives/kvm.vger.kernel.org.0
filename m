Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 271C615263B
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 07:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgBEGTh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 5 Feb 2020 01:19:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:52004 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725385AbgBEGTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 01:19:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Feb 2020 22:19:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,404,1574150400"; 
   d="scan'208";a="343167986"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga001.fm.intel.com with ESMTP; 04 Feb 2020 22:19:34 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 4 Feb 2020 22:19:34 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 4 Feb 2020 22:19:34 -0800
Received: from shsmsx102.ccr.corp.intel.com (10.239.4.154) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 4 Feb 2020 22:19:33 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.5]) by
 shsmsx102.ccr.corp.intel.com ([169.254.2.126]) with mapi id 14.03.0439.000;
 Wed, 5 Feb 2020 14:19:32 +0800
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
Subject: RE: [RFC v3 4/8] vfio/type1: Add VFIO_NESTING_GET_IOMMU_UAPI_VERSION
Thread-Topic: [RFC v3 4/8] vfio/type1: Add
 VFIO_NESTING_GET_IOMMU_UAPI_VERSION
Thread-Index: AQHV1pyVzTVYYyC090Ow388f+bA35qgBzDSAgALuTFCABInhgIAC5JFQ
Date:   Wed, 5 Feb 2020 06:19:31 +0000
Message-ID: <A2975661238FB949B60364EF0F2C25743A1AAE53@SHSMSX104.ccr.corp.intel.com>
References: <1580299912-86084-1-git-send-email-yi.l.liu@intel.com>
        <1580299912-86084-5-git-send-email-yi.l.liu@intel.com>
        <20200129165649.43008300@w520.home>
        <A2975661238FB949B60364EF0F2C25743A1994A2@SHSMSX104.ccr.corp.intel.com>
 <20200203110045.1fb3ec8d@w520.home>
In-Reply-To: <20200203110045.1fb3ec8d@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDljNmJkZDgtYjc0Yi00MGNhLTkyZWUtOTIwMmI0ZjY2OWIyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiakkxU2NRcEg3R3NIdEM1d1JhblhWZTc5UVZqSTZaU0ZCUFFHbHlrSnhaMlc4SlBGQWFhWmZHOVFIaUliQUc5ZCJ9
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Tuesday, February 4, 2020 2:01 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
> Subject: Re: [RFC v3 4/8] vfio/type1: Add
> VFIO_NESTING_GET_IOMMU_UAPI_VERSION
> 
> On Fri, 31 Jan 2020 13:04:11 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Thursday, January 30, 2020 7:57 AM
> > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > Subject: Re: [RFC v3 4/8] vfio/type1: Add
> > > VFIO_NESTING_GET_IOMMU_UAPI_VERSION
> > >
> > > On Wed, 29 Jan 2020 04:11:48 -0800
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > From: Liu Yi L <yi.l.liu@intel.com>
> > > >
> > > > In Linux Kernel, the IOMMU nesting translation (a.k.a. IOMMU dual stage
> > > > translation capability) is abstracted in uapi/iommu.h, in which the uAPIs
> > > > like bind_gpasid/iommu_cache_invalidate/fault_report/pgreq_resp are defined.
> > > >
> > > > VFIO_TYPE1_NESTING_IOMMU stands for the vfio iommu type which is backed
> by
> > > > IOMMU nesting translation capability. VFIO exposes the nesting capability
> > > > to userspace and also exposes uAPIs (will be added in later patches) to user
> > > > space for setting up nesting translation from userspace. Thus applications
> > > > like QEMU could support vIOMMU for pass-through devices with IOMMU
> nesting
> > > > translation capability.
> > > >
> > > > As VFIO expose the nesting IOMMU programming to userspace, it also needs to
> > > > provide an API for the uapi/iommu.h version check to ensure compatibility.
> > > > This patch reports the iommu uapi version to userspace. Applications could
> > > > use this API to do version check before further using the nesting uAPIs.
> > > >
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > > Cc: Alex Williamson <alex.williamson@redhat.com>
> > > > Cc: Eric Auger <eric.auger@redhat.com>
> > > > Cc: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> > > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > > > ---
> > > >  drivers/vfio/vfio.c       |  3 +++
> > > >  include/uapi/linux/vfio.h | 10 ++++++++++
> > > >  2 files changed, 13 insertions(+)
> > > >
> > > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > > index 425d60a..9087ad4 100644
> > > > --- a/drivers/vfio/vfio.c
> > > > +++ b/drivers/vfio/vfio.c
> > > > @@ -1170,6 +1170,9 @@ static long vfio_fops_unl_ioctl(struct file *filep,
> > > >  	case VFIO_GET_API_VERSION:
> > > >  		ret = VFIO_API_VERSION;
> > > >  		break;
> > > > +	case VFIO_NESTING_GET_IOMMU_UAPI_VERSION:
> > > > +		ret = iommu_get_uapi_version();
> > > > +		break;
> > >
> > > Shouldn't the type1 backend report this?  It doesn't make much sense
> > > that the spapr backend reports a version for something it doesn't
> > > support.  Better yet, provide this info gratuitously in the
> > > VFIO_IOMMU_GET_INFO ioctl return like you do with nesting in the next
> > > patch, then it can help the user figure out if this support is present.
> >
> > yeah, it would be better to report it by type1 backed. However,
> > it is kind of issue when QEMU using it.
> >
> > My series "hooks" vSVA supports on VFIO_TYPE1_NESTING_IOMMU type.
> > [RFC v3 09/25] vfio: check VFIO_TYPE1_NESTING_IOMMU support
> > https://www.spinics.net/lists/kvm/msg205197.html
> >
> > In QEMU, it will determine the iommu type firstly and then invoke
> > VFIO_SET_IOMMU. I think before selecting VFIO_TYPE1_NESTING_IOMMU,
> > QEMU needs to check the IOMMU uAPI version. If IOMMU uAPI is incompatible,
> > QEMU should not use VFIO_TYPE1_NESTING_IOMMU type. If
> > VFIO_NESTING_GET_IOMMU_UAPI_VERSION is available after set iommu, then it
> > may be an issue. That's why this series reports the version in vfio layer
> > instead of type1 backend.
> 
> Why wouldn't you use CHECK_EXTENSION?  You could probe specifically for
> a VFIO_TYP1_NESTING_IOMMU_UAPI_VERSION extension that returns the
> version number.  Thanks,

oh, yes. Thanks for this guiding. :-)

Regards,
Yi Liu
