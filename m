Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8F3267811
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgILGCh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:02:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:4901 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbgILGCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 02:02:33 -0400
IronPort-SDR: Kis8rNcpW7tyPwL0A22sHJEAlC7QlHoQt6cJiqr2cCn9Ih+Nqjne5XnMAVVtX341gYbr3s1FvC
 lJTSOwOtbYow==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="223080171"
X-IronPort-AV: E=Sophos;i="5.76,419,1592895600"; 
   d="scan'208";a="223080171"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 23:02:29 -0700
IronPort-SDR: 2F74R0g5+fr2QEFW+ej0XLql9d6k2cgRwU6IOBUUgWx9Qg+0WoJF/u1mkhicUi1nvniA/fnk8N
 HjYmTZbpDD7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,419,1592895600"; 
   d="scan'208";a="408340745"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 11 Sep 2020 23:02:28 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 11 Sep 2020 23:02:28 -0700
Received: from fmsmsx102.amr.corp.intel.com (10.18.124.200) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Sep 2020 23:02:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 FMSMSX102.amr.corp.intel.com (10.18.124.200) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 11 Sep 2020 23:02:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 11 Sep 2020 23:02:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSuhZGI6NKs6z5JUxc+N5EZLcEUc8wSeWqj2LqtfQ3Yb+u4TLlKbKWOB84FNjYwtBEK3ovsAHv0ydyf6RQtmj/yS7MpVwLRyr7ihTg6l37CeS/gsfNAPM6eOA3MvYLj9fL9jyFfvc2sKrRD2dqPDPTDQ33GhYcZYe+4uL+r5O/Wuzy4KCH9EX4ER+v1gDUpyCV/fEpPRS+xj+oOJT2VZjLWyKKuZ4M6zo3lpze76nuwmF0o4FgMWe/79Uh6bnbJZZukegV4owTsK+2W7gIc55arvIddizgUS3UgrzNlC3g6HsWznDp5ASudZIzIEOpR+Fl/SjzfJQhc11KRs34iTTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cc+HW0Mv1dLqrXYLqRcTHBQxwdTvD5kLnbh8eLwdcag=;
 b=KYO0zhElHA49Xy5LBx3NQhXQWUfFYWniSiiLwPX9Kz1yJgP85fXAjbGIlxksoxPj2qH/On5AJyhxUoPOLoaCPcA1/LNFujQw4CZ/iZDeN6nMc7hFunW3VSsmRYRofcgr95nlWyi8QDYJvLRi6dlni8GCiJKcp66aJMUH8AssuqVPDtWfLXm+4chNBYtMofCZL1r25lf8he/IdYjC0o3LZguazPOa9OnrWTZooXPYynff1ZBhBR4bP0UGV5fEi5G/40G4QGgnYf0MCwsqoIFWJ97KBOEfHLATLKlIeOhTyjI3hZpKI50WqAVTYkHAzTubaLjCmwCSGT3Yf/nuub928A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cc+HW0Mv1dLqrXYLqRcTHBQxwdTvD5kLnbh8eLwdcag=;
 b=XWPgqOBZawgUrhG5I8TUkdAO/VFwMlchjPc/ti68OcLu5JlonLISJ8mPBRufDrJRtgfBV5qk6KdQHfMCdXCDzQDE/eNpXX828J6pE8beJiLTh8Ub8G2PDCTuapqlrySi0qpHMB5g/MmlVg2EU2CcKS6QpoM5T1X1i/hyD8EM2yI=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Sat, 12 Sep 2020 06:02:26 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54%9]) with mapi id 15.20.3370.017; Sat, 12 Sep 2020
 06:02:26 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v7 10/16] vfio/type1: Support binding guest page tables to
 PASID
Thread-Topic: [PATCH v7 10/16] vfio/type1: Support binding guest page tables
 to PASID
Thread-Index: AQHWh18/Pt2w22JPoUCprMI2O8WM4alkAB0AgACBGUA=
Date:   Sat, 12 Sep 2020 06:02:25 +0000
Message-ID: <DM5PR11MB1435786F302CEFEC0263DE79C3250@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-11-git-send-email-yi.l.liu@intel.com>
 <20200911160350.240869b2@w520.home>
In-Reply-To: <20200911160350.240869b2@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [114.244.141.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e143898-4630-48e2-5e51-08d856e16c7b
x-ms-traffictypediagnostic: DM6PR11MB3292:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB32922748E0D5AFECBB4A9147C3250@DM6PR11MB3292.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +JDHydKz1sFgD+jwYda6jwhgCEh/EKMBp4mVypCZCcVA0+ndVo654vprmTOXj80IRXHq2YXME6aat4DM1ddaVzXNiADY50iWFCjVwa9aBTPjx+GZJb8XMdVidyUk0Wvpfsyik2EOF01HF8Q2ejLKUMVYQL6p2hgpeO2ExShjrlY0W0pJBUCnfQGm4UOSOyiMXCZ1zFCOYaBJ/yOXEevLDzsT/UmFGxJiO2PtvO/SuqmWNw6sYbB3OR+HwXU/QM2WObMrYwKNqrphFKB5eSXsQAP5S5CwDe8rG6XaeUCV9bpKc5o0MKb6ZlnM8Z1yQBgP66otrJDc+Swy8oh05jIQGjILmujwK8YGU/SpZr0s4jusaHFkl9v2+k+j+i2f98somyjDL9VtGR8GpijT5uAMkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(39860400002)(136003)(9686003)(966005)(66946007)(26005)(186003)(83380400001)(6506007)(6916009)(76116006)(64756008)(66556008)(66476007)(66446008)(5660300002)(7416002)(54906003)(86362001)(55016002)(52536014)(30864003)(7696005)(71200400001)(8936002)(8676002)(2906002)(33656002)(478600001)(316002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iNl4RtHBPQ2Jwy2KoGb6Qk8JCIurqXQfzWvvMKiyiPxuJHY+H7SgbxRc68PyCQW8oh4iODX2DOJDW//gZcm6oNUixC0po3cGSg3cR3U6XEeU8VmppYQUb0HynhoASiSiqaXFy15pjUpNkeYv6pGiIF8j9NBwDIORsv+Ru0m+R2wup46zOAWJNvHnBAjkrgOpNiuOhYoIqe2V4FT5hrDd8SLkirTp/W3u98DZwMgbJerfvSGz7i/HJpArguFLQWCEeTu25nZq4lQzdatrbSyehzuWI3LgcdxkD9IeGaBp/tsvGneDpCIx3pjtQ/cUyagAKOE2O9Ksn/rYFge7rq4EVfS2PkhFWCaWxapCt8TtR9WXH8t+gS3+xEfQJeeWWYOzC96lxvQX+yOhOiVK9AMws6thPL2ET2RCaElbnzmCSErisje5ySeQwaN4qYGnrVfFfo8YPubIvtcQgo5VwyTo3fMsd72yYtoqn49MosTtZ9pwFk3IRwNquLG9/GJw75jsbs4JHmpf41D87FwHFFyb0O7511aG7i8eBiq3ci9PZjFUFAJubBe146hUNEN5LQSfLZzu0Ht5jdnIpMQpTcj5idCOo4PwgdP2GD7tb7o/nhqNZn9ZQ/vx+xDcjz/mDs1RnsiYrCa7xmmaTiLBZPHzWg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e143898-4630-48e2-5e51-08d856e16c7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 06:02:25.8151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xRTsZlMeTsGZpDbG6B0iJBsZ7QVFOyvYg7gAtp1IFESkUwX9MQEBUh9EvIwVSBt+MvQB5jaJxK6g6YWJG+uf9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3292
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, September 12, 2020 6:04 AM
>=20
> On Thu, 10 Sep 2020 03:45:27 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > Nesting translation allows two-levels/stages page tables, with 1st
> > level for guest translations (e.g. GVA->GPA), 2nd level for host
> > translations (e.g. GPA->HPA). This patch adds interface for binding
> > guest page tables to a PASID. This PASID must have been allocated by
> > the userspace before the binding request.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> > v6 -> v7:
> > *) introduced @user in struct domain_capsule to simplify the code per E=
ric's
> >    suggestion.
> > *) introduced VFIO_IOMMU_NESTING_OP_NUM for sanitizing op from userspac=
e.
> > *) corrected the @argsz value of unbind_data in vfio_group_unbind_gpasi=
d_fn().
> >
> > v5 -> v6:
> > *) dropped vfio_find_nesting_group() and add vfio_get_nesting_domain_ca=
psule().
> >    per comment from Eric.
> > *) use iommu_uapi_sva_bind/unbind_gpasid() and iommu_sva_unbind_gpasid(=
) in
> >    linux/iommu.h for userspace operation and in-kernel operation.
> >
> > v3 -> v4:
> > *) address comments from Alex on v3
> >
> > v2 -> v3:
> > *) use __iommu_sva_unbind_gpasid() for unbind call issued by VFIO
> >
> > https://lore.kernel.org/linux-iommu/1592931837-58223-6-git-send-email-
> > jacob.jun.pan@linux.intel.com/
> >
> > v1 -> v2:
> > *) rename subject from "vfio/type1: Bind guest page tables to host"
> > *) remove VFIO_IOMMU_BIND, introduce VFIO_IOMMU_NESTING_OP to support
> bind/
> >    unbind guet page table
> > *) replaced vfio_iommu_for_each_dev() with a group level loop since thi=
s
> >    series enforces one group per container w/ nesting type as start.
> > *) rename vfio_bind/unbind_gpasid_fn() to
> > vfio_dev_bind/unbind_gpasid_fn()
> > *) vfio_dev_unbind_gpasid() always successful
> > *) use vfio_mm->pasid_lock to avoid race between PASID free and page ta=
ble
> >    bind/unbind
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 163
> ++++++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_pasid.c       |  26 +++++++
> >  include/linux/vfio.h            |  20 +++++
> >  include/uapi/linux/vfio.h       |  36 +++++++++
> >  4 files changed, 245 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index bd4b668..11f1156 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -149,6 +149,39 @@ struct vfio_regions {
> >  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
> >  #define DIRTY_BITMAP_SIZE_MAX
> DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
> >
> > +struct domain_capsule {
> > +	struct vfio_group	*group;
> > +	struct iommu_domain	*domain;
> > +	/* set if @data contains a user pointer*/
> > +	bool			user;
> > +	void			*data;
> > +};
>=20
> Put the hole in the structure at the end, but I suspect we might lose the=
 user field
> when the internal api drops the unnecessary structure for unbind anyway.

I see. will move @user and its comment to the end of this struct. As it's
used to imply the @data field user pointer or not, I guess it's still usefu=
l
to keep it. The difference would be the @data is a pasid not a bind_data
struct.

> > +
> > +/* iommu->lock must be held */
> > +static int vfio_prepare_nesting_domain_capsule(struct vfio_iommu *iomm=
u,
> > +					       struct domain_capsule *dc) {
> > +	struct vfio_domain *domain =3D NULL;
> > +	struct vfio_group *group =3D NULL;
>=20
> Unnecessary initialization.

will remove them. :-)

> > +
> > +	if (!iommu->nesting_info)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * Only support singleton container with nesting type. If
> > +	 * nesting_info is non-NULL, the container is non-empty.
> > +	 * Also domain is non-empty.
> > +	 */
> > +	domain =3D list_first_entry(&iommu->domain_list,
> > +				  struct vfio_domain, next);
> > +	group =3D list_first_entry(&domain->group_list,
> > +				 struct vfio_group, next);
> > +	dc->group =3D group;
> > +	dc->domain =3D domain->domain;
> > +	dc->user =3D true;
> > +	return 0;
> > +}
> > +
> >  static int put_pfn(unsigned long pfn, int prot);
> >
> >  static struct vfio_group *vfio_iommu_find_iommu_group(struct
> > vfio_iommu *iommu, @@ -2405,6 +2438,49 @@ static int
> vfio_iommu_resv_refresh(struct vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static int vfio_dev_bind_gpasid_fn(struct device *dev, void *data) {
> > +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > +	unsigned long arg =3D *(unsigned long *)dc->data;
> > +
> > +	return iommu_uapi_sva_bind_gpasid(dc->domain, dev,
> > +					  (void __user *)arg);
> > +}
> > +
> > +static int vfio_dev_unbind_gpasid_fn(struct device *dev, void *data)
> > +{
> > +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > +
> > +	if (dc->user) {
> > +		unsigned long arg =3D *(unsigned long *)dc->data;
> > +
> > +		iommu_uapi_sva_unbind_gpasid(dc->domain,
> > +					     dev, (void __user *)arg);
> > +	} else {
> > +		struct iommu_gpasid_bind_data *unbind_data =3D
> > +				(struct iommu_gpasid_bind_data *)dc->data;
> > +
> > +		iommu_sva_unbind_gpasid(dc->domain, dev, unbind_data);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void vfio_group_unbind_gpasid_fn(ioasid_t pasid, void *data) {
> > +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> > +	struct iommu_gpasid_bind_data unbind_data;
> > +
> > +	unbind_data.argsz =3D sizeof(struct iommu_gpasid_bind_data);
> > +	unbind_data.flags =3D 0;
> > +	unbind_data.hpasid =3D pasid;
>=20
>=20
> As in thread with Jacob, this all seems a little excessive for an interna=
l api callback
> that requires one arg.

yep, Jacob informed me about that change.

>=20
> > +
> > +	dc->user =3D false;
> > +	dc->data =3D &unbind_data;
> > +
> > +	iommu_group_for_each_dev(dc->group->iommu_group,
> > +				 dc, vfio_dev_unbind_gpasid_fn);
> > +}
> > +
> >  static void vfio_iommu_type1_detach_group(void *iommu_data,
> >  					  struct iommu_group *iommu_group)
> { @@ -2448,6 +2524,20 @@
> > static void vfio_iommu_type1_detach_group(void *iommu_data,
> >  		if (!group)
> >  			continue;
> >
> > +		if (iommu->vmm && (iommu->nesting_info->features &
> > +					IOMMU_NESTING_FEAT_BIND_PGTBL)) {
> > +			struct domain_capsule dc =3D { .group =3D group,
> > +						     .domain =3D domain->domain,
> > +						     .data =3D NULL };
> > +
> > +			/*
> > +			 * Unbind page tables bound with system wide PASIDs
> > +			 * which are allocated to userspace.
> > +			 */
> > +			vfio_mm_for_each_pasid(iommu->vmm, &dc,
> > +					       vfio_group_unbind_gpasid_fn);
> > +		}
> > +
> >  		vfio_iommu_detach_group(domain, group);
> >  		update_dirty_scope =3D !group->pinned_page_dirty_scope;
> >  		list_del(&group->next);
> > @@ -2982,6 +3072,77 @@ static int vfio_iommu_type1_pasid_request(struct
> vfio_iommu *iommu,
> >  	return ret;
> >  }
> >
> > +static long vfio_iommu_handle_pgtbl_op(struct vfio_iommu *iommu,
> > +				       bool is_bind, unsigned long arg) {
> > +	struct domain_capsule dc =3D { .data =3D &arg };
> > +	struct iommu_nesting_info *info;
> > +	int ret;
> > +
> > +	mutex_lock(&iommu->lock);
> > +
> > +	info =3D iommu->nesting_info;
> > +	if (!info || !(info->features & IOMMU_NESTING_FEAT_BIND_PGTBL)) {
> > +		ret =3D -EOPNOTSUPP;
> > +		goto out_unlock;
> > +	}
> > +
> > +	if (!iommu->vmm) {
> > +		ret =3D -EINVAL;
> > +		goto out_unlock;
> > +	}
> > +
> > +	ret =3D vfio_prepare_nesting_domain_capsule(iommu, &dc);
> > +	if (ret)
> > +		goto out_unlock;
> > +
> > +	/* Avoid race with other containers within the same process */
> > +	vfio_mm_pasid_lock(iommu->vmm);
> > +
> > +	if (is_bind)
> > +		ret =3D iommu_group_for_each_dev(dc.group->iommu_group, &dc,
> > +					       vfio_dev_bind_gpasid_fn);
> > +	if (ret || !is_bind)
> > +		iommu_group_for_each_dev(dc.group->iommu_group,
> > +					 &dc, vfio_dev_unbind_gpasid_fn);
> > +
> > +	vfio_mm_pasid_unlock(iommu->vmm);
> > +out_unlock:
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> > +static long vfio_iommu_type1_nesting_op(struct vfio_iommu *iommu,
> > +					unsigned long arg)
> > +{
> > +	struct vfio_iommu_type1_nesting_op hdr;
> > +	unsigned int minsz;
> > +	int ret;
> > +
> > +	minsz =3D offsetofend(struct vfio_iommu_type1_nesting_op, flags);
> > +
> > +	if (copy_from_user(&hdr, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (hdr.argsz < minsz ||
> > +	    hdr.flags & ~VFIO_NESTING_OP_MASK ||
> > +	    (hdr.flags & VFIO_NESTING_OP_MASK) >=3D
> VFIO_IOMMU_NESTING_OP_NUM)
>=20
>=20
> Isn't this redundant to the default switch case?

oh, yes. From sanity chek p.o.v, it looks to be necessary to put
the flags check here. but it also makes the default switch case
to be a dead code. perhaps, I could remove the check against the
OP_NUM and keep the switch case. how about your opinion?

>=20
> > +		return -EINVAL;
> > +
> > +	switch (hdr.flags & VFIO_NESTING_OP_MASK) {
> > +	case VFIO_IOMMU_NESTING_OP_BIND_PGTBL:
> > +		ret =3D vfio_iommu_handle_pgtbl_op(iommu, true, arg + minsz);
> > +		break;
> > +	case VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL:
> > +		ret =3D vfio_iommu_handle_pgtbl_op(iommu, false, arg + minsz);
> > +		break;
> > +	default:
> > +		ret =3D -EINVAL;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  				   unsigned int cmd, unsigned long arg)  { @@ -
> 3000,6 +3161,8 @@
> > static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  		return vfio_iommu_type1_dirty_pages(iommu, arg);
> >  	case VFIO_IOMMU_PASID_REQUEST:
> >  		return vfio_iommu_type1_pasid_request(iommu, arg);
> > +	case VFIO_IOMMU_NESTING_OP:
> > +		return vfio_iommu_type1_nesting_op(iommu, arg);
> >  	default:
> >  		return -ENOTTY;
> >  	}
> > diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> > index 0ec4660..9e2e4b0 100644
> > --- a/drivers/vfio/vfio_pasid.c
> > +++ b/drivers/vfio/vfio_pasid.c
> > @@ -220,6 +220,8 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
> >  	 * IOASID core will notify PASID users (e.g. IOMMU driver) to
> >  	 * teardown necessary structures depending on the to-be-freed
> >  	 * PASID.
> > +	 * Hold pasid_lock also avoids race with PASID usages like bind/
> > +	 * unbind page tables to requested PASID.
> >  	 */
> >  	mutex_lock(&vmm->pasid_lock);
> >  	while ((vid =3D vfio_find_pasid(vmm, min, max)) !=3D NULL) @@ -228,6
> > +230,30 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,  }
> > EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
> >
> > +int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
> > +			   void (*fn)(ioasid_t id, void *data)) {
> > +	int ret;
> > +
> > +	mutex_lock(&vmm->pasid_lock);
> > +	ret =3D ioasid_set_for_each_ioasid(vmm->ioasid_set, fn, data);
> > +	mutex_unlock(&vmm->pasid_lock);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_mm_for_each_pasid);
> > +
> > +void vfio_mm_pasid_lock(struct vfio_mm *vmm) {
> > +	mutex_lock(&vmm->pasid_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_mm_pasid_lock);
> > +
> > +void vfio_mm_pasid_unlock(struct vfio_mm *vmm) {
> > +	mutex_unlock(&vmm->pasid_lock);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_mm_pasid_unlock);
> > +
> >  static int __init vfio_pasid_init(void)  {
> >  	mutex_init(&vfio_mm_lock);
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h index
> > 5c3d7a8..6a999c3 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -105,6 +105,11 @@ extern struct ioasid_set
> > *vfio_mm_ioasid_set(struct vfio_mm *vmm);  extern int
> > vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);  extern void
> vfio_pasid_free_range(struct vfio_mm *vmm,
> >  				  ioasid_t min, ioasid_t max);
> > +extern int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *data,
> > +				  void (*fn)(ioasid_t id, void *data)); extern void
> > +vfio_mm_pasid_lock(struct vfio_mm *vmm); extern void
> > +vfio_mm_pasid_unlock(struct vfio_mm *vmm);
> > +
> >  #else
> >  static inline struct vfio_mm *vfio_mm_get_from_task(struct
> > task_struct *task)  { @@ -129,6 +134,21 @@ static inline void
> > vfio_pasid_free_range(struct vfio_mm *vmm,
> >  					  ioasid_t min, ioasid_t max)
> >  {
> >  }
> > +
> > +static inline int vfio_mm_for_each_pasid(struct vfio_mm *vmm, void *da=
ta,
> > +					 void (*fn)(ioasid_t id, void *data)) {
> > +	return -ENOTTY;
> > +}
> > +
> > +static inline void vfio_mm_pasid_lock(struct vfio_mm *vmm) { }
> > +
> > +static inline void vfio_mm_pasid_unlock(struct vfio_mm *vmm) { }
> > +
> >  #endif /* CONFIG_VFIO_PASID */
> >
> >  /*
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index a4bc42e..a99bd71 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1215,6 +1215,42 @@ struct vfio_iommu_type1_pasid_request {
> >
> >  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
> >
> > +/**
> > + * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 19,
> > + *				struct vfio_iommu_type1_nesting_op)
> > + *
> > + * This interface allows userspace to utilize the nesting IOMMU
> > + * capabilities as reported in VFIO_IOMMU_TYPE1_INFO_CAP_NESTING
> > + * cap through VFIO_IOMMU_GET_INFO. For platforms which require
> > + * system wide PASID, PASID will be allocated by VFIO_IOMMU_PASID
> > + * _REQUEST.
> > + *
> > + * @data[] types defined for each op:
> > + *
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > + * | NESTING OP      |      @data[]                                  |
> > + *
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > + * | BIND_PGTBL      |      struct iommu_gpasid_bind_data            |
> > + * +-----------------+-----------------------------------------------+
> > + * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
> > + *
> > ++-----------------+-----------------------------------------------+
> > + *
> > + * returns: 0 on success, -errno on failure.
> > + */
> > +struct vfio_iommu_type1_nesting_op {
> > +	__u32	argsz;
> > +	__u32	flags;
> > +#define VFIO_NESTING_OP_MASK	(0xffff) /* lower 16-bits for op */
> > +	__u8	data[];
> > +};
> > +
> > +enum {
> > +	VFIO_IOMMU_NESTING_OP_BIND_PGTBL,
> > +	VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL,
> > +	VFIO_IOMMU_NESTING_OP_NUM,
> > +};
>=20
> "VFIO_IOMMU_NESTING_NUM_OPS" would be more consistent with the vfio uapi.

I see. will rename it if we decide to keep it.

Regards,
Yi Liu

> Thanks,
>=20
> Alex
>=20
> > +
> > +#define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 19)
> > +
> >  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU
> > -------- */
> >
> >  /*

