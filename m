Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45446213260
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 05:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgGCDxP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 23:53:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:46455 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725915AbgGCDxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 23:53:15 -0400
IronPort-SDR: Jnwk72BMuANr+Jx1eLNpp/KH3e9hjBc7+v2Yln46jfELkliPxHgEtUQoYfLn4uexZCOR6yPo4O
 gzfczVMnQqsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="127173997"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="127173997"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 20:46:54 -0700
IronPort-SDR: YZZ+R8sVe8k1qFj8KQNvZeXLdifIDr45Mu67IsR7LIMHy6bqcSEax7RDD7ChYIKSpsaSXrFO4Q
 irZvrqPBEQnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="482233378"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2020 20:46:54 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Jul 2020 20:46:53 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 2 Jul 2020 20:46:53 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX151.amr.corp.intel.com (10.22.226.38) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 20:46:53 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 2 Jul 2020 20:46:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kShw9uER5ZK5H5m5CsFor6jUUBDVjwiwDSRBryvtgamDh7AjwZOBYMxOySxMkd+YyNnuGTF34NfCKm3b94S5gEijfPhiVxs3Dq8gSJL3fq0pVCrpN8WLZhXQ0zNgXgDUVqG0OLNHUeUi2E7r2fsX9SlhYqqAdRSPtu8XbNAAWeH88xDhvaoM5U5x/dFILBZKVWRT/pgROzh8qUqbeo5h4ZONHxvdLYJR+wn2OtEh0Dq/sZQrXrAFqQiSkrx4FWAUL6q5CHZtREdaOQYzz+cQRv2OvbBPY+hQ/YOlmWEvzK5bLhXwIvaSGK62xVK+Fv5BSe0OedikfNPvGM+rcmIVLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGHYCZnqILqpEC0fZb3cPCOerWsct4PM7eKLNYBt8pk=;
 b=h0MZRAjJA2r0RbeMa6VPHRASsZajLoZM1hwMEjCDiHKW/O8K6lLo5qcO3/0+HmRzMCI2F9Qhi/wu0KoKWzqqg/3HdRR9EHmyQTy+YUwujXXCeXwHTwPXlHKbJcQHM1bDgZ3TKyDQ7pVQArVC7+/tlQ8LDTLeEQDcKsbq8+6BDXE60Qg2pae4bC0qGWcYLQNpp1ZV+5uE5lpPqviAZaEBj2iwiYKGeQdb169CC8AJL8p3+heykBrYnpBHcHkdAGhpJxTrqcbekWBhM50v5q2G17V63pXsvFJp2AFjs1IiEs1lEyrdLBboD7fNSugnjTeYsqF0kg/loJ33ih7gjT32og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGHYCZnqILqpEC0fZb3cPCOerWsct4PM7eKLNYBt8pk=;
 b=cWy9qNEvjmrOm4wd4+E7fgmyL/9Ml9AQnctaUOC1bhWJjWD3STfUVy/XGwl75teU/WxNIhAFWB/G+2NqAet+pGOHb0NiILtJ0bCTJr+7ySVWMdkXKinOoeYOzb8P5AdyshZyICJ8q8Na9FFykNbsyq2f+Iz6x41MXmKxNpOlsmk=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4076.namprd11.prod.outlook.com (2603:10b6:5:197::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.28; Fri, 3 Jul 2020 03:46:52 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::2c3d:98d9:4e81:c86c%6]) with mapi id 15.20.3131.033; Fri, 3 Jul 2020
 03:46:52 +0000
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
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 01/14] vfio/type1: Refactor vfio_iommu_type1_ioctl()
Thread-Topic: [PATCH v3 01/14] vfio/type1: Refactor vfio_iommu_type1_ioctl()
Thread-Index: AQHWSgRP5alWmuhHv0+o228EmqQebKj02VaAgABmNOA=
Date:   Fri, 3 Jul 2020 03:46:51 +0000
Message-ID: <DM5PR11MB143599F220FA4FCA5492B919C36A0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-2-git-send-email-yi.l.liu@intel.com>
 <20200702152101.7eb1e77b@x1.home>
In-Reply-To: <20200702152101.7eb1e77b@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbe28961-be32-49a5-b44c-08d81f03b8ec
x-ms-traffictypediagnostic: DM6PR11MB4076:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4076EC25DA92C0A33EC812A7C36A0@DM6PR11MB4076.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:389;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GgWGPEzEk8s0ZJvLeTDwS9yCrh/+zNdKqbrKUj1CjYgsg8UiiqM+wAc2sDfLQeb5fW7jU06X9EFZxeRizA+czBEVHWxliUJepXPmmRxL5Zd98OdJEXW2zxalC0gTNc7Z+Xsn1YmSNFd1JtW2p8JYWMUgMVJ1rxecZtPorZQK53zsb+E95ibBpIKqBnYSTmsdTmH2wLZzQAUX6s+vM7XmYnz43bwCxfVy0WDcj2pOFz+ZKgQsVn4D+jgVw/G20HyLfTS6k+D2C42xQkAjK0TctKp+chZL5ej9XhYquqTI0DjX/e9h7KVim4tY8+CTis/IXfLPaCLUH4hgq1HGWJB36Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(52536014)(7696005)(186003)(76116006)(2906002)(54906003)(86362001)(66476007)(5660300002)(316002)(66946007)(478600001)(33656002)(66446008)(64756008)(66556008)(6506007)(26005)(8676002)(53546011)(6916009)(30864003)(8936002)(83380400001)(7416002)(55016002)(71200400001)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Jd+cBkStUCfYjmt4vQ1AVLvc+P3XcbTzWzdLif1JZzzqqU2F105xJ7Vb07opwh/uVGILGuNilsr3GyrBUHMcinV1boZGky2HFREY4zmM+lKVhRxzmrOoKY5hb6UOydR15BHjxKJ8/mtGFHqc2UKv0ELNhEXd6GHFMpVxrQzruPE13wCI5jhhGGoqGnXxcwWKD6GMKq7jJNa4qgvw2OXoTrH5kKBBkfvLys7OsebRPNsLSY5X6uoDcIw9+aorqW24SZi2KBrY6JRcvbgEWlBVIeVDrfdZucpx/RtDnSqJweCGM0dKRRS6TECuzkMFWMImYLl2S/OXrE338Vl5288m2WOqMR9bP0RXqH+agy6FMLlvXuqVK96wluMYkxyrBLaNs10SbQyYsoZsy98uVQr0jUdIljlf/xB7kXNPZWk0t8ubpSKaHcm0naWQEAQ9mbtWT1lOnqVqUmAaR//FvoEfiYgmrVjBdggHT4NR3CGe95a8Q0x/Tt0uY+3t49ewMn/L
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe28961-be32-49a5-b44c-08d81f03b8ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 03:46:51.7160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wlx0tm2plMU1YrTDkMpsfF5so7POcFYIr5gPgHaFDajyk96OZYl3lJyU4aPwtbyGdhLk67hNX+1mStOTJ92oQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4076
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, July 3, 2020 5:21 AM
> To: Liu, Yi L <yi.l.liu@intel.com>
>=20
> On Wed, 24 Jun 2020 01:55:14 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch refactors the vfio_iommu_type1_ioctl() to use switch
> > instead of if-else, and each cmd got a helper function.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 392
> > ++++++++++++++++++++++------------------
> >  1 file changed, 213 insertions(+), 179 deletions(-)
>=20
> I can go ahead and grab this one for my v5.9 next branch.  Thanks,

thanks, that would be great help. I'll monitor your next branch on github.

Regards,
Yi Liu

> Alex
>=20
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 5e556ac..7accb59 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2453,6 +2453,23 @@ static int vfio_domains_have_iommu_cache(struct
> vfio_iommu *iommu)
> >  	return ret;
> >  }
> >
> > +static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
> > +					    unsigned long arg)
> > +{
> > +	switch (arg) {
> > +	case VFIO_TYPE1_IOMMU:
> > +	case VFIO_TYPE1v2_IOMMU:
> > +	case VFIO_TYPE1_NESTING_IOMMU:
> > +		return 1;
> > +	case VFIO_DMA_CC_IOMMU:
> > +		if (!iommu)
> > +			return 0;
> > +		return vfio_domains_have_iommu_cache(iommu);
> > +	default:
> > +		return 0;
> > +	}
> > +}
> > +
> >  static int vfio_iommu_iova_add_cap(struct vfio_info_cap *caps,
> >  		 struct vfio_iommu_type1_info_cap_iova_range *cap_iovas,
> >  		 size_t size)
> > @@ -2529,238 +2546,255 @@ static int
> vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
> >  	return vfio_info_add_capability(caps, &cap_mig.header,
> > sizeof(cap_mig));  }
> >
> > -static long vfio_iommu_type1_ioctl(void *iommu_data,
> > -				   unsigned int cmd, unsigned long arg)
> > +static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
> > +				     unsigned long arg)
> >  {
> > -	struct vfio_iommu *iommu =3D iommu_data;
> > +	struct vfio_iommu_type1_info info;
> >  	unsigned long minsz;
> > +	struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
> > +	unsigned long capsz;
> > +	int ret;
> >
> > -	if (cmd =3D=3D VFIO_CHECK_EXTENSION) {
> > -		switch (arg) {
> > -		case VFIO_TYPE1_IOMMU:
> > -		case VFIO_TYPE1v2_IOMMU:
> > -		case VFIO_TYPE1_NESTING_IOMMU:
> > -			return 1;
> > -		case VFIO_DMA_CC_IOMMU:
> > -			if (!iommu)
> > -				return 0;
> > -			return vfio_domains_have_iommu_cache(iommu);
> > -		default:
> > -			return 0;
> > -		}
> > -	} else if (cmd =3D=3D VFIO_IOMMU_GET_INFO) {
> > -		struct vfio_iommu_type1_info info;
> > -		struct vfio_info_cap caps =3D { .buf =3D NULL, .size =3D 0 };
> > -		unsigned long capsz;
> > -		int ret;
> > -
> > -		minsz =3D offsetofend(struct vfio_iommu_type1_info,
> iova_pgsizes);
> > +	minsz =3D offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
> >
> > -		/* For backward compatibility, cannot require this */
> > -		capsz =3D offsetofend(struct vfio_iommu_type1_info, cap_offset);
> > +	/* For backward compatibility, cannot require this */
> > +	capsz =3D offsetofend(struct vfio_iommu_type1_info, cap_offset);
> >
> > -		if (copy_from_user(&info, (void __user *)arg, minsz))
> > -			return -EFAULT;
> > +	if (copy_from_user(&info, (void __user *)arg, minsz))
> > +		return -EFAULT;
> >
> > -		if (info.argsz < minsz)
> > -			return -EINVAL;
> > +	if (info.argsz < minsz)
> > +		return -EINVAL;
> >
> > -		if (info.argsz >=3D capsz) {
> > -			minsz =3D capsz;
> > -			info.cap_offset =3D 0; /* output, no-recopy necessary */
> > -		}
> > +	if (info.argsz >=3D capsz) {
> > +		minsz =3D capsz;
> > +		info.cap_offset =3D 0; /* output, no-recopy necessary */
> > +	}
> >
> > -		mutex_lock(&iommu->lock);
> > -		info.flags =3D VFIO_IOMMU_INFO_PGSIZES;
> > +	mutex_lock(&iommu->lock);
> > +	info.flags =3D VFIO_IOMMU_INFO_PGSIZES;
> >
> > -		info.iova_pgsizes =3D iommu->pgsize_bitmap;
> > +	info.iova_pgsizes =3D iommu->pgsize_bitmap;
> >
> > -		ret =3D vfio_iommu_migration_build_caps(iommu, &caps);
> > +	ret =3D vfio_iommu_migration_build_caps(iommu, &caps);
> >
> > -		if (!ret)
> > -			ret =3D vfio_iommu_iova_build_caps(iommu, &caps);
> > +	if (!ret)
> > +		ret =3D vfio_iommu_iova_build_caps(iommu, &caps);
> >
> > -		mutex_unlock(&iommu->lock);
> > +	mutex_unlock(&iommu->lock);
> >
> > -		if (ret)
> > -			return ret;
> > +	if (ret)
> > +		return ret;
> >
> > -		if (caps.size) {
> > -			info.flags |=3D VFIO_IOMMU_INFO_CAPS;
> > +	if (caps.size) {
> > +		info.flags |=3D VFIO_IOMMU_INFO_CAPS;
> >
> > -			if (info.argsz < sizeof(info) + caps.size) {
> > -				info.argsz =3D sizeof(info) + caps.size;
> > -			} else {
> > -				vfio_info_cap_shift(&caps, sizeof(info));
> > -				if (copy_to_user((void __user *)arg +
> > -						sizeof(info), caps.buf,
> > -						caps.size)) {
> > -					kfree(caps.buf);
> > -					return -EFAULT;
> > -				}
> > -				info.cap_offset =3D sizeof(info);
> > +		if (info.argsz < sizeof(info) + caps.size) {
> > +			info.argsz =3D sizeof(info) + caps.size;
> > +		} else {
> > +			vfio_info_cap_shift(&caps, sizeof(info));
> > +			if (copy_to_user((void __user *)arg +
> > +					sizeof(info), caps.buf,
> > +					caps.size)) {
> > +				kfree(caps.buf);
> > +				return -EFAULT;
> >  			}
> > -
> > -			kfree(caps.buf);
> > +			info.cap_offset =3D sizeof(info);
> >  		}
> >
> > -		return copy_to_user((void __user *)arg, &info, minsz) ?
> > -			-EFAULT : 0;
> > +		kfree(caps.buf);
> > +	}
> >
> > -	} else if (cmd =3D=3D VFIO_IOMMU_MAP_DMA) {
> > -		struct vfio_iommu_type1_dma_map map;
> > -		uint32_t mask =3D VFIO_DMA_MAP_FLAG_READ |
> > -				VFIO_DMA_MAP_FLAG_WRITE;
> > +	return copy_to_user((void __user *)arg, &info, minsz) ?
> > +			-EFAULT : 0;
> > +}
> >
> > -		minsz =3D offsetofend(struct vfio_iommu_type1_dma_map, size);
> > +static int vfio_iommu_type1_map_dma(struct vfio_iommu *iommu,
> > +				    unsigned long arg)
> > +{
> > +	struct vfio_iommu_type1_dma_map map;
> > +	unsigned long minsz;
> > +	uint32_t mask =3D VFIO_DMA_MAP_FLAG_READ |
> > +			VFIO_DMA_MAP_FLAG_WRITE;
> >
> > -		if (copy_from_user(&map, (void __user *)arg, minsz))
> > -			return -EFAULT;
> > +	minsz =3D offsetofend(struct vfio_iommu_type1_dma_map, size);
> >
> > -		if (map.argsz < minsz || map.flags & ~mask)
> > -			return -EINVAL;
> > +	if (copy_from_user(&map, (void __user *)arg, minsz))
> > +		return -EFAULT;
> >
> > -		return vfio_dma_do_map(iommu, &map);
> > +	if (map.argsz < minsz || map.flags & ~mask)
> > +		return -EINVAL;
> >
> > -	} else if (cmd =3D=3D VFIO_IOMMU_UNMAP_DMA) {
> > -		struct vfio_iommu_type1_dma_unmap unmap;
> > -		struct vfio_bitmap bitmap =3D { 0 };
> > -		int ret;
> > +	return vfio_dma_do_map(iommu, &map); }
> >
> > -		minsz =3D offsetofend(struct vfio_iommu_type1_dma_unmap,
> size);
> > +static int vfio_iommu_type1_unmap_dma(struct vfio_iommu *iommu,
> > +				      unsigned long arg)
> > +{
> > +	struct vfio_iommu_type1_dma_unmap unmap;
> > +	struct vfio_bitmap bitmap =3D { 0 };
> > +	unsigned long minsz;
> > +	long ret;
> >
> > -		if (copy_from_user(&unmap, (void __user *)arg, minsz))
> > -			return -EFAULT;
> > +	minsz =3D offsetofend(struct vfio_iommu_type1_dma_unmap, size);
> >
> > -		if (unmap.argsz < minsz ||
> > -		    unmap.flags &
> ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
> > -			return -EINVAL;
> > +	if (copy_from_user(&unmap, (void __user *)arg, minsz))
> > +		return -EFAULT;
> >
> > -		if (unmap.flags &
> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> > -			unsigned long pgshift;
> > +	if (unmap.argsz < minsz ||
> > +	    unmap.flags & ~VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP)
> > +		return -EINVAL;
> >
> > -			if (unmap.argsz < (minsz + sizeof(bitmap)))
> > -				return -EINVAL;
> > +	if (unmap.flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) {
> > +		unsigned long pgshift;
> >
> > -			if (copy_from_user(&bitmap,
> > -					   (void __user *)(arg + minsz),
> > -					   sizeof(bitmap)))
> > -				return -EFAULT;
> > +		if (unmap.argsz < (minsz + sizeof(bitmap)))
> > +			return -EINVAL;
> >
> > -			if (!access_ok((void __user *)bitmap.data, bitmap.size))
> > -				return -EINVAL;
> > +		if (copy_from_user(&bitmap,
> > +				   (void __user *)(arg + minsz),
> > +				   sizeof(bitmap)))
> > +			return -EFAULT;
> >
> > -			pgshift =3D __ffs(bitmap.pgsize);
> > -			ret =3D verify_bitmap_size(unmap.size >> pgshift,
> > -						 bitmap.size);
> > -			if (ret)
> > -				return ret;
> > -		}
> > +		if (!access_ok((void __user *)bitmap.data, bitmap.size))
> > +			return -EINVAL;
> >
> > -		ret =3D vfio_dma_do_unmap(iommu, &unmap, &bitmap);
> > +		pgshift =3D __ffs(bitmap.pgsize);
> > +		ret =3D verify_bitmap_size(unmap.size >> pgshift,
> > +					 bitmap.size);
> >  		if (ret)
> >  			return ret;
> > +	}
> > +
> > +	ret =3D vfio_dma_do_unmap(iommu, &unmap, &bitmap);
> > +	if (ret)
> > +		return ret;
> >
> > -		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> > +	return copy_to_user((void __user *)arg, &unmap, minsz) ?
> >  			-EFAULT : 0;
> > -	} else if (cmd =3D=3D VFIO_IOMMU_DIRTY_PAGES) {
> > -		struct vfio_iommu_type1_dirty_bitmap dirty;
> > -		uint32_t mask =3D VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> > -				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> > -
> 	VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> > -		int ret =3D 0;
> > +}
> >
> > -		if (!iommu->v2)
> > -			return -EACCES;
> > +static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
> > +					unsigned long arg)
> > +{
> > +	struct vfio_iommu_type1_dirty_bitmap dirty;
> > +	uint32_t mask =3D VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> > +			VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> > +			VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> > +	unsigned long minsz;
> > +	int ret =3D 0;
> >
> > -		minsz =3D offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> > -				    flags);
> > +	if (!iommu->v2)
> > +		return -EACCES;
> >
> > -		if (copy_from_user(&dirty, (void __user *)arg, minsz))
> > -			return -EFAULT;
> > +	minsz =3D offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> > +			    flags);
> >
> > -		if (dirty.argsz < minsz || dirty.flags & ~mask)
> > -			return -EINVAL;
> > +	if (copy_from_user(&dirty, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (dirty.argsz < minsz || dirty.flags & ~mask)
> > +		return -EINVAL;
> > +
> > +	/* only one flag should be set at a time */
> > +	if (__ffs(dirty.flags) !=3D __fls(dirty.flags))
> > +		return -EINVAL;
> > +
> > +	if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> > +		size_t pgsize;
> >
> > -		/* only one flag should be set at a time */
> > -		if (__ffs(dirty.flags) !=3D __fls(dirty.flags))
> > +		mutex_lock(&iommu->lock);
> > +		pgsize =3D 1 << __ffs(iommu->pgsize_bitmap);
> > +		if (!iommu->dirty_page_tracking) {
> > +			ret =3D vfio_dma_bitmap_alloc_all(iommu, pgsize);
> > +			if (!ret)
> > +				iommu->dirty_page_tracking =3D true;
> > +		}
> > +		mutex_unlock(&iommu->lock);
> > +		return ret;
> > +	} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> > +		mutex_lock(&iommu->lock);
> > +		if (iommu->dirty_page_tracking) {
> > +			iommu->dirty_page_tracking =3D false;
> > +			vfio_dma_bitmap_free_all(iommu);
> > +		}
> > +		mutex_unlock(&iommu->lock);
> > +		return 0;
> > +	} else if (dirty.flags &
> > +			 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> > +		struct vfio_iommu_type1_dirty_bitmap_get range;
> > +		unsigned long pgshift;
> > +		size_t data_size =3D dirty.argsz - minsz;
> > +		size_t iommu_pgsize;
> > +
> > +		if (!data_size || data_size < sizeof(range))
> >  			return -EINVAL;
> >
> > -		if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> > -			size_t pgsize;
> > +		if (copy_from_user(&range, (void __user *)(arg + minsz),
> > +				   sizeof(range)))
> > +			return -EFAULT;
> >
> > -			mutex_lock(&iommu->lock);
> > -			pgsize =3D 1 << __ffs(iommu->pgsize_bitmap);
> > -			if (!iommu->dirty_page_tracking) {
> > -				ret =3D vfio_dma_bitmap_alloc_all(iommu, pgsize);
> > -				if (!ret)
> > -					iommu->dirty_page_tracking =3D true;
> > -			}
> > -			mutex_unlock(&iommu->lock);
> > +		if (range.iova + range.size < range.iova)
> > +			return -EINVAL;
> > +		if (!access_ok((void __user *)range.bitmap.data,
> > +			       range.bitmap.size))
> > +			return -EINVAL;
> > +
> > +		pgshift =3D __ffs(range.bitmap.pgsize);
> > +		ret =3D verify_bitmap_size(range.size >> pgshift,
> > +					 range.bitmap.size);
> > +		if (ret)
> >  			return ret;
> > -		} else if (dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP)
> {
> > -			mutex_lock(&iommu->lock);
> > -			if (iommu->dirty_page_tracking) {
> > -				iommu->dirty_page_tracking =3D false;
> > -				vfio_dma_bitmap_free_all(iommu);
> > -			}
> > -			mutex_unlock(&iommu->lock);
> > -			return 0;
> > -		} else if (dirty.flags &
> > -
> VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> > -			struct vfio_iommu_type1_dirty_bitmap_get range;
> > -			unsigned long pgshift;
> > -			size_t data_size =3D dirty.argsz - minsz;
> > -			size_t iommu_pgsize;
> > -
> > -			if (!data_size || data_size < sizeof(range))
> > -				return -EINVAL;
> > -
> > -			if (copy_from_user(&range, (void __user *)(arg + minsz),
> > -					   sizeof(range)))
> > -				return -EFAULT;
> >
> > -			if (range.iova + range.size < range.iova)
> > -				return -EINVAL;
> > -			if (!access_ok((void __user *)range.bitmap.data,
> > -				       range.bitmap.size))
> > -				return -EINVAL;
> > +		mutex_lock(&iommu->lock);
> >
> > -			pgshift =3D __ffs(range.bitmap.pgsize);
> > -			ret =3D verify_bitmap_size(range.size >> pgshift,
> > -						 range.bitmap.size);
> > -			if (ret)
> > -				return ret;
> > +		iommu_pgsize =3D (size_t)1 << __ffs(iommu->pgsize_bitmap);
> >
> > -			mutex_lock(&iommu->lock);
> > +		/* allow only smallest supported pgsize */
> > +		if (range.bitmap.pgsize !=3D iommu_pgsize) {
> > +			ret =3D -EINVAL;
> > +			goto out_unlock;
> > +		}
> > +		if (range.iova & (iommu_pgsize - 1)) {
> > +			ret =3D -EINVAL;
> > +			goto out_unlock;
> > +		}
> > +		if (!range.size || range.size & (iommu_pgsize - 1)) {
> > +			ret =3D -EINVAL;
> > +			goto out_unlock;
> > +		}
> >
> > -			iommu_pgsize =3D (size_t)1 << __ffs(iommu-
> >pgsize_bitmap);
> > +		if (iommu->dirty_page_tracking)
> > +			ret =3D vfio_iova_dirty_bitmap(range.bitmap.data,
> > +					iommu, range.iova, range.size,
> > +					range.bitmap.pgsize);
> > +		else
> > +			ret =3D -EINVAL;
> > +out_unlock:
> > +		mutex_unlock(&iommu->lock);
> >
> > -			/* allow only smallest supported pgsize */
> > -			if (range.bitmap.pgsize !=3D iommu_pgsize) {
> > -				ret =3D -EINVAL;
> > -				goto out_unlock;
> > -			}
> > -			if (range.iova & (iommu_pgsize - 1)) {
> > -				ret =3D -EINVAL;
> > -				goto out_unlock;
> > -			}
> > -			if (!range.size || range.size & (iommu_pgsize - 1)) {
> > -				ret =3D -EINVAL;
> > -				goto out_unlock;
> > -			}
> > +		return ret;
> > +	}
> >
> > -			if (iommu->dirty_page_tracking)
> > -				ret =3D vfio_iova_dirty_bitmap(range.bitmap.data,
> > -						iommu, range.iova, range.size,
> > -						range.bitmap.pgsize);
> > -			else
> > -				ret =3D -EINVAL;
> > -out_unlock:
> > -			mutex_unlock(&iommu->lock);
> > +	return -EINVAL;
> > +}
> >
> > -			return ret;
> > -		}
> > +static long vfio_iommu_type1_ioctl(void *iommu_data,
> > +				   unsigned int cmd, unsigned long arg) {
> > +	struct vfio_iommu *iommu =3D iommu_data;
> > +
> > +	switch (cmd) {
> > +	case VFIO_CHECK_EXTENSION:
> > +		return vfio_iommu_type1_check_extension(iommu, arg);
> > +	case VFIO_IOMMU_GET_INFO:
> > +		return vfio_iommu_type1_get_info(iommu, arg);
> > +	case VFIO_IOMMU_MAP_DMA:
> > +		return vfio_iommu_type1_map_dma(iommu, arg);
> > +	case VFIO_IOMMU_UNMAP_DMA:
> > +		return vfio_iommu_type1_unmap_dma(iommu, arg);
> > +	case VFIO_IOMMU_DIRTY_PAGES:
> > +		return vfio_iommu_type1_dirty_pages(iommu, arg);
> >  	}
> >
> >  	return -ENOTTY;

