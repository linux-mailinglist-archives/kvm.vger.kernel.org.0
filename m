Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 946262133DA
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 08:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgGCGFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 02:05:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:58080 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbgGCGFo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 02:05:44 -0400
IronPort-SDR: flycSxtA5y0HEyvIqAyBWRMkPS2qMDyL802RLCd8bmGXZoE3SuswPoQLLQ+h+SiBhOX2xlEC8W
 VKJZocrcG6fQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="127188482"
X-IronPort-AV: E=Sophos;i="5.75,307,1589266800"; 
   d="scan'208";a="127188482"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 23:05:41 -0700
IronPort-SDR: 9JjE1OBDWY3xGui3+OP5E6PIz9psoM21Yngz+HP0Duceh5UZROnI8GRQthLGC5UYMDNn7zaY4Q
 nP5WdM5M55zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,307,1589266800"; 
   d="scan'208";a="282192419"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga006.jf.intel.com with ESMTP; 02 Jul 2020 23:05:41 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 23:05:40 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 2 Jul 2020 23:05:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3sil0Of3U3N/kISgb2Oxgam9tfOfkyi7PxAzQYm1E6JgBdvT0YoyC6mpu17pvnFfMrS290S9Sp4W7jY728e5R0yw07bfyU2c03HtimsA3lhU3CIeL/ScvnMky+gn5yFf3E2kDzly1H2XAkgy9v0RVJHC5q7tP7q+ZOm5zx4nA4XLdQw26Uqfywh86ZWJb48TBtyV8J9bQrWUvxvKLpuCS7TsU5irPzKdXBEn0Ca/6mhfXXnHh5mFuEoEo+nDTh0ZBDEt6gUbIl3WMe38XhxmGXjvsX+j99jIn0Gv8TQctd+XetcR0iUjo9woHtF5ed5LYYWWsdbHA2G1+Nf7daiPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ov8zp8pcnQup6sewZlsMFKfPoFv0aJXe21yxlX4jsP4=;
 b=ePM6+7SiSHhKSIuHXx82yfAPUd2q07CiJpLrV6N7ZT9IapJ8qPoKJv3g+uV6yGHhnyHNYs7T3OMqMAZKS1xrIbVCoQENa4kUp/qSabY2K/lsIN2xKX6kgc/bSkuAewQO2mk4FgLJQOq7Bc1gynpzESlwCVh1i7Q/givzVhFPOQEHnQJ21R7E5UB/BDL5Av2rdm1LkNFWIuGGZkq4L0Mj8e+A86EtjSlxo+j0WkcHCUvAe3BkBLsOaw4G2CoI0njcmY7LR1AA/sLvgmU/iGGIUi+TKzXBssNwwQIofKTZNYMwNnPzcoQjUDoemHLGAYUqolUFasfSbVrVpHuaNIsfMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ov8zp8pcnQup6sewZlsMFKfPoFv0aJXe21yxlX4jsP4=;
 b=oZ5h2SeNsPqU8hvJYATH8/yVU9+cHFnK6VRyrowxQSIlZG91PJM81rYdkRlbL9EhidFHLI6shEsyaAIfKXTXY3Mnett0bWPAxQEbHETWUkBcqnqpqDLOhdd+CuEx/+8Gf98eHbyD+ttrwRbK0aohqO/tVb5680a8wUhWr3MmogU=
Received: from CY4PR11MB1432.namprd11.prod.outlook.com (2603:10b6:910:5::22)
 by CY4PR11MB1784.namprd11.prod.outlook.com (2603:10b6:903:126::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20; Fri, 3 Jul
 2020 06:05:39 +0000
Received: from CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a]) by CY4PR11MB1432.namprd11.prod.outlook.com
 ([fe80::b46e:9dcb:b46b:884a%4]) with mapi id 15.20.3153.027; Fri, 3 Jul 2020
 06:05:39 +0000
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
Subject: RE: [PATCH v3 03/14] vfio/type1: Report iommu nesting info to
 userspace
Thread-Topic: [PATCH v3 03/14] vfio/type1: Report iommu nesting info to
 userspace
Thread-Index: AQHWSgRR9wDstDmC00qnq2+G1pK7Waj0rAKAgACc8/A=
Date:   Fri, 3 Jul 2020 06:05:38 +0000
Message-ID: <CY4PR11MB14320E069DF2C75131A94DB3C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-4-git-send-email-yi.l.liu@intel.com>
 <20200702123847.384e7460@x1.home>
In-Reply-To: <20200702123847.384e7460@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbff58b4-f2ea-4769-8d74-08d81f171c29
x-ms-traffictypediagnostic: CY4PR11MB1784:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR11MB1784FC839B3F0213F217436FC36A0@CY4PR11MB1784.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k0jIdR/Be3AovwUe+7Bx6ftC+ORwwe0YpNbBr7Svj/TDHOAIk7itRdXNFw1uZKB8fN+T/abBgCW5b1UClQJUk2/SvIUFMLIejb23eRpuTHy0PtZetW+XeH4ZijPDug7k8KQEN9OhqrEVPCg4a1FU9fmg/8TPy/7aXOT+dqYZcUU0fYSEOx3VzkbEPXAvoMJsJFyqEaSRuHgvebGkyGrnHJfPdimeg9AB84vsJdhTD73iAplDoQ7nR6mYH0YDMOQglIqdarOoOzeMMYdJeN4kLKfZtoQhX1qxYTzn0qQYSGnuGa/E8cg31Jvmfnf9Xt07BjPLAo4OnWfbUdlPCsUZHr95eIiOWvKkwPMiuiLAOVB3kantcjFwDLHu/UUsy05ybLRI+FpIySo54AwYa5g35Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1432.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(966005)(55016002)(4326008)(33656002)(9686003)(186003)(316002)(66476007)(66556008)(64756008)(66446008)(54906003)(76116006)(66946007)(26005)(8676002)(83380400001)(6916009)(8936002)(7416002)(86362001)(5660300002)(6506007)(71200400001)(7696005)(478600001)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tWZ1wZ8Qg33hBpqwdRqdCGXcRrd15kR3RljbN26m3fYF9wtRhx9tKc/vvMU1lT5sZzzcFiPNX7fnQ2zThoQqBjbfbunlFUR1QZEYuZa7eLB5skvxB3E4eK3g5OU3xBa+pqZARYM7/XrQtmFn1W9IGmx4bC91ZSKz8wwetoWH+hac6Eg03PB8P3qUaegS82J/tMM1RcywQt0gPpN/eRxDR/i8pBHGopPHz25GaoX6Uxxq64GBKUF4RwcwEz+0SR8q5o7RYqFqkpMjV6M7T/xMomGHbvx0s04a1M62QXldYJ6ye7j7mwqKB+UiVe6cPj6o0MzTeTOQG7mBiwD4nSBoYsU1nuZDaASz3hKSW6JMpAlLjwsQ+TlrpszdkvWzF7UHMl5NhikY4FW3x3aBJGFtTanOhnudg4BXcf2VOCMFJhHJly+riIFb/Dc5R9ZWEboByAxNVNS824lA+4M8aiLawaW/s77M6DQgO1CY4stOkukuWxzMpmblqd8rh6wyjJu7
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1432.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbff58b4-f2ea-4769-8d74-08d81f171c29
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 06:05:38.8180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CjvueAYuE1/XyoS7s5GTjNys7yxTOPXUMBi0poBlN6rCublPI3N8BwJeKc2QIgoshw3HD5AuyUZ4yaloDNGm7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1784
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson < alex.williamson@redhat.com >
> Sent: Friday, July 3, 2020 2:39 AM
>=20
> On Wed, 24 Jun 2020 01:55:16 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch exports iommu nesting capability info to user space through
> > VFIO. User space is expected to check this info for supported uAPIs (e.=
g.
> > PASID alloc/free, bind page table, and cache invalidation) and the
> > vendor specific format information for first level/stage page table
> > that will be bound to.
> >
> > The nesting info is available only after the nesting iommu type is set
> > for a container. Current implementation imposes one limitation - one
> > nesting container should include at most one group. The philosophy of
> > vfio container is having all groups/devices within the container share
> > the same IOMMU context. When vSVA is enabled, one IOMMU context could
> > include one 2nd-level address space and multiple 1st-level address spac=
es.
> > While the 2nd-leve address space is reasonably sharable by multiple
> > groups , blindly sharing 1st-level address spaces across all groups
> > within the container might instead break the guest expectation. In the
> > future sub/ super container concept might be introduced to allow
> > partial address space sharing within an IOMMU context. But for now
> > let's go with this restriction by requiring singleton container for
> > using nesting iommu features. Below link has the related discussion
> > about this
> > decision.
> >
> > https://lkml.org/lkml/2020/5/15/1028
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 73
> +++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h       |  9 +++++
> >  2 files changed, 82 insertions(+)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 7accb59..8c143d5 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -72,6 +72,7 @@ struct vfio_iommu {
> >  	uint64_t		pgsize_bitmap;
> >  	bool			v2;
> >  	bool			nesting;
> > +	struct iommu_nesting_info *nesting_info;
> >  	bool			dirty_page_tracking;
> >  	bool			pinned_page_dirty_scope;
> >  };
>=20
> Mind the structure packing and alignment, placing a pointer in the middle
> of a
> section of bools is going to create wasteful holes in the data structure.

how about below? Add the @nesting_info and @vmm in the end of this struct.
I've two questions, the first one is how the place the comment of the
@external_domain; second question is do you want me to move the @nesting
field to be near-by with the @nesting_info and @vmm. :) please let me know
your preference.

struct vfio_iommu {
	struct list_head		domain_list;
	struct list_head		iova_list;
	struct vfio_domain		*external_domain; /* domain for external user */
	struct mutex			lock;
	struct rb_root			dma_list;
	struct blocking_notifier_head	notifier;
	unsigned int			dma_avail;
	uint64_t			pgsize_bitmap;
	bool				v2;
	bool				nesting;
	bool				dirty_page_tracking;
	bool				pinned_page_dirty_scope;
	struct iommu_nesting_info 	*nesting_info;
	struct vfio_mm			*vmm;
};

> > @@ -130,6 +131,9 @@ struct vfio_regions {
> >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >  					(!list_empty(&iommu->domain_list))
> >
> > +#define IS_DOMAIN_IN_CONTAINER(iommu)	((iommu-
> >external_domain) || \
> > +					 (!list_empty(&iommu->domain_list)))
> > +
> >  #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) /
> BITS_PER_BYTE)
> >
> >  /*
> > @@ -1959,6 +1963,12 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  		}
> >  	}
> >
> > +	/* Nesting type container can include only one group */
> > +	if (iommu->nesting && IS_DOMAIN_IN_CONTAINER(iommu)) {
> > +		mutex_unlock(&iommu->lock);
> > +		return -EINVAL;
> > +	}
> > +
> >  	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> >  	domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> >  	if (!group || !domain) {
> > @@ -2029,6 +2039,36 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  	if (ret)
> >  		goto out_domain;
> >
> > +	/* Nesting cap info is available only after attaching */
> > +	if (iommu->nesting) {
> > +		struct iommu_nesting_info tmp;
> > +		struct iommu_nesting_info *info;
> > +
> > +		/* First get the size of vendor specific nesting info */
> > +		ret =3D iommu_domain_get_attr(domain->domain,
> > +					    DOMAIN_ATTR_NESTING,
> > +					    &tmp);
> > +		if (ret)
> > +			goto out_detach;
> > +
> > +		info =3D kzalloc(tmp.size, GFP_KERNEL);
> > +		if (!info) {
> > +			ret =3D -ENOMEM;
> > +			goto out_detach;
> > +		}
> > +
> > +		/* Now get the nesting info */
> > +		info->size =3D tmp.size;
> > +		ret =3D iommu_domain_get_attr(domain->domain,
> > +					    DOMAIN_ATTR_NESTING,
> > +					    info);
> > +		if (ret) {
> > +			kfree(info);
> > +			goto out_detach;
> > +		}
> > +		iommu->nesting_info =3D info;
> > +	}
> > +
> >  	/* Get aperture info */
> >  	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY,
> &geo);
> >
> > @@ -2138,6 +2178,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  	return 0;
> >
> >  out_detach:
> > +	kfree(iommu->nesting_info);
>=20
> This looks prone to a use-after-free.

how about setting iommu->nesting_info to NULL? just as the next comment
from you.

> >  	vfio_iommu_detach_group(domain, group);
> >  out_domain:
> >  	iommu_domain_free(domain->domain);
> > @@ -2338,6 +2379,8 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
> >  					vfio_iommu_unmap_unpin_all(iommu);
> >  				else
> >
> 	vfio_iommu_unmap_unpin_reaccount(iommu);
> > +
> > +				kfree(iommu->nesting_info);
>=20
> As does this.  Set to NULL since get_info tests the pointer before trying=
 to
> use it.

got it.

> >  			}
> >  			iommu_domain_free(domain->domain);
> >  			list_del(&domain->next);
> > @@ -2546,6 +2589,30 @@ static int vfio_iommu_migration_build_caps(struc=
t
> vfio_iommu *iommu,
> >  	return vfio_info_add_capability(caps, &cap_mig.header,
> > sizeof(cap_mig));  }
> >
> > +static int vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
> > +					   struct vfio_info_cap *caps)
> > +{
> > +	struct vfio_info_cap_header *header;
> > +	struct vfio_iommu_type1_info_cap_nesting *nesting_cap;
> > +	size_t size;
> > +
> > +	size =3D sizeof(*nesting_cap) + iommu->nesting_info->size;
> > +
> > +	header =3D vfio_info_cap_add(caps, size,
> > +				   VFIO_IOMMU_TYPE1_INFO_CAP_NESTING, 1);
> > +	if (IS_ERR(header))
> > +		return PTR_ERR(header);
> > +
> > +	nesting_cap =3D container_of(header,
> > +				   struct vfio_iommu_type1_info_cap_nesting,
> > +				   header);
> > +
> > +	memcpy(&nesting_cap->info, iommu->nesting_info,
> > +	       iommu->nesting_info->size);
> > +
> > +	return 0;
> > +}
> > +
> >  static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
> >  				     unsigned long arg)
> >  {
> > @@ -2586,6 +2653,12 @@ static int vfio_iommu_type1_get_info(struct
> vfio_iommu *iommu,
> >  	if (ret)
> >  		return ret;
> >
> > +	if (iommu->nesting_info) {
> > +		ret =3D vfio_iommu_info_add_nesting_cap(iommu, &caps);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> >  	if (caps.size) {
> >  		info.flags |=3D VFIO_IOMMU_INFO_CAPS;
> >
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index eca66926..f1f39e1 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -14,6 +14,7 @@
> >
> >  #include <linux/types.h>
> >  #include <linux/ioctl.h>
> > +#include <linux/iommu.h>
>=20
> Why?  We're not directly referencing any IOMMU UAPI structures here.

oh, yes. will remove it.

> >
> >  #define VFIO_API_VERSION	0
> >
> > @@ -1039,6 +1040,14 @@ struct vfio_iommu_type1_info_cap_migration {
> >  	__u64	max_dirty_bitmap_size;		/* in bytes */
> >  };
> >
> > +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  3
> > +
> > +struct vfio_iommu_type1_info_cap_nesting {
> > +	struct	vfio_info_cap_header header;
> > +	__u32	flags;
>=20
> I think there's an alignment issue here for a uapi.  The header field is
> 8-bytes total
> and info[] should start at an 8-byte alignment to allow data[] within inf=
o
> to have
> 8-byte alignment.  This could lead to the structure having a compiler
> dependent
> size and offsets.  We should add a 4-byte reserved field here to resolve.

got it. or how about defining the flags as __u64?

>=20
> > +	__u8	info[];
> > +};
>=20
> This should have a lot more description around it, a user could not infer
> that info[]
> is including a struct iommu_nesting_info from the information provided he=
re.
> Thanks,

sure. BTW. do you think it is necessary to add a flag to indicate the info[=
]
is a struct iommu_nesting_info? or as a start, it's not necessary to do it.

Regards,
Yi Liu

> Alex
>=20
> > +
> >  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> >
> >  /**

