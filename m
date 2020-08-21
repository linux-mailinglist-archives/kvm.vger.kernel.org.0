Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DEB24C93D
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 02:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgHUAha (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 20:37:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:4480 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgHUAh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 20:37:28 -0400
IronPort-SDR: 8yw5mCmqLp4tXKJ+UkIR1lTpuywg6n4RAPEqWXcjHSX6XpO2ne4mk2EuDh7YSLLbo2PEWdP96h
 Z1fAtiiK+aSA==
X-IronPort-AV: E=McAfee;i="6000,8403,9719"; a="240251709"
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="240251709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2020 17:37:23 -0700
IronPort-SDR: kCyYDthlA3mVwQSroXOg1pDcZL97EQJzOio2xICG4GGxXyF7kToVCsqOlQ3EcHPlXLsEc+V0zS
 anEfxWE5o0gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,335,1592895600"; 
   d="scan'208";a="297770135"
Received: from fmsmsx603-2.cps.intel.com (HELO fmsmsx603.amr.corp.intel.com) ([10.18.84.213])
  by orsmga006.jf.intel.com with ESMTP; 20 Aug 2020 17:37:22 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Aug 2020 17:37:22 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 20 Aug 2020 17:37:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 20 Aug 2020 17:37:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dljY6UsTAuotqyaoayGF/nVq4VaIPNXS6A6MjDTpLscH1Ep8tHzBNNqaOiPmvkBBlH0GCKLQqifo15Y1modYU5JqS5WGKuqClZ9OYhftqy02enm1S9a4kT9kPTClbf1vXC0c1Xg/WkmSTkweqaaOGo0tNQeZbXCEHPEF7Jtr1jVG0BjFnthPN13riJe1eH6UL0fucSOCBYabC+U09nfKYSCL9Fiv1t754ceLKnYkSIxRgS7GjDJiXrDzE6W5nEMdlzM0nTknkukrVNOBfRiHdSJqKS8G/n39cXJe97/1Y8KwY/FAbtHnGi4/JIAHC+QxfJkKMGJ6jBzia4juez1xgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jkRmw/aQiPdsZJaqTtzi5hjvUGMdUbCEHAAegKFi0A=;
 b=Y8z4moF2TDvn690fJXw1qLxoJdHZLolgaOjSCg6ybvsnpzDVGhIFCltqtFa2nxyH0k3u6But6dwDCrpoghW2FEvLeH152TyxLU8oOmI9GCA4QfByCo07OEin8n+HSlzIg2wT+eAu6zkqiz8V5ES08u0f+hXE5cq6M3hUSOoIOPSHAZTa8ZjmPYCdelda7G99lqMjWGtPsJwWBbzjujQjr0p7BZmB2si8s49ragk+EeytvPjF4KTcWG9sa9TDFTpx6zwZsncJHE5ubYqSuk0bB3KDO2ETDwotPht5oe2YIWtW46jKNrxVH86+sO4tNOax8uA6cMTh5CHxkHslj9n65g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jkRmw/aQiPdsZJaqTtzi5hjvUGMdUbCEHAAegKFi0A=;
 b=bckDzB+ztbzR1+myfn3umjBF/KXWzEkUYW5kjzk+lQyS4FuYd3aKywP24ysqZMNuBjh7g4TgYdUhTCi9/cUW6iCB6OlhIf47aBmwp+vGcf7ooWcli0uIMzbxd4vgAJeVgTJDE0xGjwd47G+zvCG7uYQxlE1FyWKbpy7nv329Trw=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3708.namprd11.prod.outlook.com (2603:10b6:5:146::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.26; Fri, 21 Aug 2020 00:37:19 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3305.024; Fri, 21 Aug
 2020 00:37:19 +0000
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
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 07/15] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Thread-Topic: [PATCH v6 07/15] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Thread-Index: AQHWZKdG9Cu5qyN/2EiULCi4Ic3bNKlBngmAgAA3G1A=
Date:   Fri, 21 Aug 2020 00:37:19 +0000
Message-ID: <DM5PR11MB1435B790F169ACDFFEA03D68C35B0@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1595917664-33276-1-git-send-email-yi.l.liu@intel.com>
        <1595917664-33276-8-git-send-email-yi.l.liu@intel.com>
 <20200820145127.61ed8727@x1.home>
In-Reply-To: <20200820145127.61ed8727@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.229.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1012cacf-49f9-49b3-3d92-08d8456a5c6c
x-ms-traffictypediagnostic: DM6PR11MB3708:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB37083BD007EF668FA55CBADFC35B0@DM6PR11MB3708.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sP4PHcUcE+YLjn+FEoXaajcUIQkph90im20CmH1jg3Tpw7+Af68xxQ9pEThkEgOvOy1YrjN114pw8VGw9Ag1adt+NgdN0JJhnQoxe0XCH3frLcW2EriVGcr8oNCpxT8y2ujiFPqIo99j2BprmJLgoIO0sPtwBFNGNMFqnYNDqpT5uFaTjYdJRKnDHXb22tvqV5eUDrPWdIFg+p+tMSxYQXIubG7dMuH4hmUVnO9hUibgX9wsuCXEQzYQbjmuc8YAiFUZW7SEsnB1thWOPTycD1BzWrwfojBLkV+PmCZJC2oy3oK+DT4DntiV8CZU+3uWfh6aZvrs4eM6HEloAN5sCwV4Nx5y5YRme6EXcoX3uqDjkkltfDMvoA3dduZDkMqbp25eM71JTReMWWi70ySbrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(396003)(366004)(136003)(6916009)(66556008)(4326008)(26005)(71200400001)(33656002)(316002)(5660300002)(64756008)(55016002)(66446008)(83380400001)(66476007)(966005)(8676002)(86362001)(6506007)(76116006)(478600001)(66946007)(2906002)(8936002)(54906003)(9686003)(52536014)(7696005)(7416002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 65Qczth310gDpiDM0aqSboSktpopqeIrbROah1rxl92lOQjez20kYHpXhdS0BlarN1LpiB4S2lge8WIMuylPi2Pp0g1niaDVm2vz8/xEy1eYl9Xwg80gGfcinibOWHFbIQbG6dE3K5Z1okm/JVJJJfA1gkTdwrhQ2+mQhj1sjpqOY3BUhzFTshch3Zkjpdw7p9NO9Ih7b6vxYeoC8sLYMc+Hg3nbbmEwuXCmQ7IY+7Y+m6l45S/UIWZknQZy3zPhIUb8zP6GX3VP+vrjSbIxZT3HOme36pn0M+7czSZrvNEDeERDwBB8REmexcRmC4jnnjusgx1RsDG+NfHAK1BFlRi/grqhqAeq7zXUyiV1HXlUE7mp39XMY//wW5mYMsxlzDqo3AjCvgmgObiIKN1svbeHqT8Q0uga3m8hVmcwKnYlMoJObapRzOlwrLCxvRBTiGXqqXUdigsyOzjsZXUBETeFuN19cc6o7zRAAPFZPkxf6wX2isZ/3AZJI1g2GJdA+oKOlvuSLsvqSTTk4odg+ynyiaNTy3BsOUfx6yrfQNzSWZv+w1Ulxm0Pk6lw08F6UoVt80ORysW9zALWbD445R1DAp8Y1Zmy72UT3ObGl2vPa1xIRCPMDZ5H25h41k5PInvawm0Xen6f6+iKj7VO4w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1012cacf-49f9-49b3-3d92-08d8456a5c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2020 00:37:19.0203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L3O4jILeMeUcNGoC+QHu61cs6Hn+ofUkurY5mwgeQ0Wuqym6rIwZYNwA4YD6uS6hh8j5tr//mdKBzISF7qw7ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3708
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 21, 2020 4:51 AM
>=20
> On Mon, 27 Jul 2020 23:27:36 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch allows userspace to request PASID allocation/free, e.g.
> > when serving the request from the guest.
> >
> > PASIDs that are not freed by userspace are automatically freed when
> > the IOASID set is destroyed when process exits.
> >
> > Cc: Kevin Tian <kevin.tian@intel.com>
> > CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Eric Auger <eric.auger@redhat.com>
> > Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Lu Baolu <baolu.lu@linux.intel.com>
> > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Yi Sun <yi.y.sun@linux.intel.com>
> > Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > ---
> > v5 -> v6:
> > *) address comments from Eric against v5. remove the alloc/free helper.
> >
> > v4 -> v5:
> > *) address comments from Eric Auger.
> > *) the comments for the PASID_FREE request is addressed in patch 5/15 o=
f
> >    this series.
> >
> > v3 -> v4:
> > *) address comments from v3, except the below comment against the range
> >    of PASID_FREE request. needs more help on it.
> >     "> +if (req.range.min > req.range.max)
> >
> >      Is it exploitable that a user can spin the kernel for a long time =
in
> >      the case of a free by calling this with [0, MAX_UINT] regardless o=
f
> >      their actual allocations?"
> >
> > https://lore.kernel.org/linux-iommu/20200702151832.048b44d1@x1.home/
> >
> > v1 -> v2:
> > *) move the vfio_mm related code to be a seprate module
> > *) use a single structure for alloc/free, could support a range of
> > PASIDs
> > *) fetch vfio_mm at group_attach time instead of at iommu driver open
> > time
> > ---
> >  drivers/vfio/Kconfig            |  1 +
> >  drivers/vfio/vfio_iommu_type1.c | 69
> +++++++++++++++++++++++++++++++++++++++++
> >  drivers/vfio/vfio_pasid.c       | 10 ++++++
> >  include/linux/vfio.h            |  6 ++++
> >  include/uapi/linux/vfio.h       | 37 ++++++++++++++++++++++
> >  5 files changed, 123 insertions(+)
> >
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig index
> > 3d8a108..95d90c6 100644
> > --- a/drivers/vfio/Kconfig
> > +++ b/drivers/vfio/Kconfig
> > @@ -2,6 +2,7 @@
> >  config VFIO_IOMMU_TYPE1
> >  	tristate
> >  	depends on VFIO
> > +	select VFIO_PASID if (X86)
> >  	default n
> >
> >  config VFIO_IOMMU_SPAPR_TCE
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 18ff0c3..ea89c7c 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -76,6 +76,7 @@ struct vfio_iommu {
> >  	bool				dirty_page_tracking;
> >  	bool				pinned_page_dirty_scope;
> >  	struct iommu_nesting_info	*nesting_info;
> > +	struct vfio_mm			*vmm;
> >  };
> >
> >  struct vfio_domain {
> > @@ -1937,6 +1938,11 @@ static void vfio_iommu_iova_insert_copy(struct
> > vfio_iommu *iommu,
> >
> >  static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
> > {
> > +	if (iommu->vmm) {
> > +		vfio_mm_put(iommu->vmm);
> > +		iommu->vmm =3D NULL;
> > +	}
> > +
> >  	kfree(iommu->nesting_info);
> >  	iommu->nesting_info =3D NULL;
> >  }
> > @@ -2071,6 +2077,26 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  					    iommu->nesting_info);
> >  		if (ret)
> >  			goto out_detach;
> > +
> > +		if (iommu->nesting_info->features &
> > +					IOMMU_NESTING_FEAT_SYSWIDE_PASID)
> {
> > +			struct vfio_mm *vmm;
> > +			int sid;
> > +
> > +			vmm =3D vfio_mm_get_from_task(current);
> > +			if (IS_ERR(vmm)) {
> > +				ret =3D PTR_ERR(vmm);
> > +				goto out_detach;
> > +			}
> > +			iommu->vmm =3D vmm;
> > +
> > +			sid =3D vfio_mm_ioasid_sid(vmm);
> > +			ret =3D iommu_domain_set_attr(domain->domain,
> > +						    DOMAIN_ATTR_IOASID_SID,
> > +						    &sid);
> > +			if (ret)
> > +				goto out_detach;
> > +		}
> >  	}
> >
> >  	/* Get aperture info */
> > @@ -2859,6 +2885,47 @@ static int vfio_iommu_type1_dirty_pages(struct
> vfio_iommu *iommu,
> >  	return -EINVAL;
> >  }
> >
> > +static int vfio_iommu_type1_pasid_request(struct vfio_iommu *iommu,
> > +					  unsigned long arg)
> > +{
> > +	struct vfio_iommu_type1_pasid_request req;
> > +	unsigned long minsz;
> > +	int ret;
> > +
> > +	minsz =3D offsetofend(struct vfio_iommu_type1_pasid_request, range);
> > +
> > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > +		return -EFAULT;
> > +
> > +	if (req.argsz < minsz || (req.flags & ~VFIO_PASID_REQUEST_MASK))
> > +		return -EINVAL;
> > +
> > +	if (req.range.min > req.range.max)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&iommu->lock);
> > +	if (!iommu->vmm) {
> > +		mutex_unlock(&iommu->lock);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	switch (req.flags & VFIO_PASID_REQUEST_MASK) {
> > +	case VFIO_IOMMU_FLAG_ALLOC_PASID:
> > +		ret =3D vfio_pasid_alloc(iommu->vmm, req.range.min,
> > +				       req.range.max);
> > +		break;
> > +	case VFIO_IOMMU_FLAG_FREE_PASID:
> > +		vfio_pasid_free_range(iommu->vmm, req.range.min,
> > +				      req.range.max);
> > +		ret =3D 0;
> > +		break;
> > +	default:
> > +		ret =3D -EINVAL;
> > +	}
> > +	mutex_unlock(&iommu->lock);
> > +	return ret;
> > +}
> > +
> >  static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  				   unsigned int cmd, unsigned long arg)  { @@ -
> 2875,6 +2942,8 @@
> > static long vfio_iommu_type1_ioctl(void *iommu_data,
> >  		return vfio_iommu_type1_unmap_dma(iommu, arg);
> >  	case VFIO_IOMMU_DIRTY_PAGES:
> >  		return vfio_iommu_type1_dirty_pages(iommu, arg);
> > +	case VFIO_IOMMU_PASID_REQUEST:
> > +		return vfio_iommu_type1_pasid_request(iommu, arg);
> >  	default:
> >  		return -ENOTTY;
> >  	}
> > diff --git a/drivers/vfio/vfio_pasid.c b/drivers/vfio/vfio_pasid.c
> > index befcf29..8d0317f 100644
> > --- a/drivers/vfio/vfio_pasid.c
> > +++ b/drivers/vfio/vfio_pasid.c
> > @@ -61,6 +61,7 @@ void vfio_mm_put(struct vfio_mm *vmm)  {
> >  	kref_put_mutex(&vmm->kref, vfio_mm_release, &vfio_mm_lock);  }
> > +EXPORT_SYMBOL_GPL(vfio_mm_put);
> >
> >  static void vfio_mm_get(struct vfio_mm *vmm)
> >  {
> > @@ -114,6 +115,13 @@ struct vfio_mm *vfio_mm_get_from_task(struct
> task_struct *task)
> >  	mmput(mm);
> >  	return vmm;
> >  }
> > +EXPORT_SYMBOL_GPL(vfio_mm_get_from_task);
> > +
> > +int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
> > +{
> > +	return vmm->ioasid_sid;
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_mm_ioasid_sid);
> >
> >  /*
> >   * Find PASID within @min and @max
> > @@ -202,6 +210,7 @@ int vfio_pasid_alloc(struct vfio_mm *vmm, int min, =
int max)
> >
> >  	return pasid;
> >  }
> > +EXPORT_SYMBOL_GPL(vfio_pasid_alloc);
> >
> >  void vfio_pasid_free_range(struct vfio_mm *vmm,
> >  			   ioasid_t min, ioasid_t max)
> > @@ -218,6 +227,7 @@ void vfio_pasid_free_range(struct vfio_mm *vmm,
> >  		vfio_remove_pasid(vmm, vid);
> >  	mutex_unlock(&vmm->pasid_lock);
> >  }
> > +EXPORT_SYMBOL_GPL(vfio_pasid_free_range);
> >
> >  static int __init vfio_pasid_init(void)
> >  {
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 31472a9..a355d01 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -101,6 +101,7 @@ struct vfio_mm;
> >  #if IS_ENABLED(CONFIG_VFIO_PASID)
> >  extern struct vfio_mm *vfio_mm_get_from_task(struct task_struct *task)=
;
> >  extern void vfio_mm_put(struct vfio_mm *vmm);
> > +extern int vfio_mm_ioasid_sid(struct vfio_mm *vmm);
> >  extern int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int max);
> >  extern void vfio_pasid_free_range(struct vfio_mm *vmm,
> >  				  ioasid_t min, ioasid_t max);
> > @@ -114,6 +115,11 @@ static inline void vfio_mm_put(struct vfio_mm *vmm=
)
> >  {
> >  }
> >
> > +static inline int vfio_mm_ioasid_sid(struct vfio_mm *vmm)
> > +{
> > +	return -ENOTTY;
> > +}
> > +
> >  static inline int vfio_pasid_alloc(struct vfio_mm *vmm, int min, int m=
ax)
> >  {
> >  	return -ENOTTY;
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 0cf3d6d..6d79557 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -1172,6 +1172,43 @@ struct vfio_iommu_type1_dirty_bitmap_get {
> >
> >  #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + =
17)
> >
> > +/**
> > + * VFIO_IOMMU_PASID_REQUEST - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
> > + *				struct vfio_iommu_type1_pasid_request)
> > + *
> > + * PASID (Processor Address Space ID) is a PCIe concept for tagging
> > + * address spaces in DMA requests. When system-wide PASID allocation
> > + * is required by the underlying iommu driver (e.g. Intel VT-d), this
> > + * provides an interface for userspace to request pasid alloc/free
> > + * for its assigned devices. Userspace should check the availability
> > + * of this API by checking VFIO_IOMMU_TYPE1_INFO_CAP_NESTING through
> > + * VFIO_IOMMU_GET_INFO.
> > + *
> > + * @flags=3DVFIO_IOMMU_FLAG_ALLOC_PASID, allocate a single PASID withi=
n
> @range.
> > + * @flags=3DVFIO_IOMMU_FLAG_FREE_PASID, free the PASIDs within @range.
> > + * @range is [min, max], which means both @min and @max are inclusive.
> > + * ALLOC_PASID and FREE_PASID are mutually exclusive.
> > + *
> > + * returns: allocated PASID value on success, -errno on failure for
> > + *	     ALLOC_PASID;
> > + *	     0 for FREE_PASID operation;
> > + */
> > +struct vfio_iommu_type1_pasid_request {
> > +	__u32	argsz;
> > +#define VFIO_IOMMU_FLAG_ALLOC_PASID	(1 << 0)
> > +#define VFIO_IOMMU_FLAG_FREE_PASID	(1 << 1)
> > +	__u32	flags;
> > +	struct {
> > +		__u32	min;
> > +		__u32	max;
> > +	} range;
> > +};
>=20
>=20
> IOCTL(2)                   Linux Programmer's Manual                  IOC=
TL(2)
>=20
> NAME
>        ioctl - control device
>=20
> SYNOPSIS
>        #include <sys/ioctl.h>
>=20
>        int ioctl(int fd, unsigned long request, ...);
>=20
>=20
> ioctl(2) returns a signed int, how can it support returning a __u32
> pasid and -errno?  Thanks,

yeah, pasid is 20 bits today per PCI spec, so a valid pasid won't use
full 32 bits, so I used it. perhaps I need to add a field in the data
struct to return allocated pasid. that may be safer. do you think it
works?

Regards,
Yi Liu

> Alex
>=20
> > +
> > +#define VFIO_PASID_REQUEST_MASK	(VFIO_IOMMU_FLAG_ALLOC_PASID | \
> > +					 VFIO_IOMMU_FLAG_FREE_PASID)
> > +
> > +#define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE + 18)
> > +
> >  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU ------=
-- */
> >
> >  /*

