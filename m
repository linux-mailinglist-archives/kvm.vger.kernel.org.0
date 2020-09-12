Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF6E2678D3
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 10:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgILIYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 04:24:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:45442 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgILIYb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Sep 2020 04:24:31 -0400
IronPort-SDR: xAV7gaN4YXu5uB7nQZsSGF6YrJAVUs84WVlfTptgJCmtqZuUM7nohAtaT4/TyjRrkBkJfCNKJM
 2DS4DfzqSWBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="243725352"
X-IronPort-AV: E=Sophos;i="5.76,419,1592895600"; 
   d="scan'208";a="243725352"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2020 01:24:28 -0700
IronPort-SDR: iTSGA3CCWR9rwIv7C7rP8MClxnjGNDif8l6MPO9Kn41yhq77OwclxNpzMy5i15Vmsd+qlyXm8s
 Dy4hd27Pl/yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,419,1592895600"; 
   d="scan'208";a="287114658"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 12 Sep 2020 01:24:28 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 12 Sep 2020 01:24:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 12 Sep 2020 01:24:27 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Sat, 12 Sep 2020 01:24:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhWp8hAlWE/fh5vUpW58bwK88gZnlNqHF8qDnp3F9K70kyz9DeV8v3SjFbinQ9Pz9AYvFACAfJyTo5sOHyIBRdvTzrS5onNKg9QVpT+FKobMEPsmq7yzvO9JqD6hnOzbM4osj4nnaYQ4WneBgQE1gP+6Ax9vKrY3UXTpUOyZ/FYFieo21M/YpFPKTgXU1n5b/vrEABJvL+7rjoBgfwuLk2iiMTPI+6BrheMB61Yxh8vnlQNhIyc5Z+GXGKyxFx5blJgSSNXYgQTo4ccZCwM4mw9FOcqQlqzGCB5CEcTKqxsC2XwYqQUodeZ4XCUtNyx/yfMIeWEQnNcqlEgusSEEcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08jo8aoKVgdgMVjBMu2R+KykKSS9L9XFX7btN6H3Y=;
 b=Pv8+8U4/GjfqsV6tNvYvtRxiQM0vxyl+dCIFH9j0W8JASikWFOAoEhtKKO0XX0zt1nFFRCwuA0YJ2LX/hwko6lEe1Xjx4pHNd9xJJoLQycU0xt5XK/uriAMNvQOIgWPUy9SPfdB2dlTHvSg9mZiCI46zt1y4i8NEzVE5oNmIUdYjRhBIm0WOFpJy9wsepm6XiUM+vrmCiss7H9hIFCgTrUo6DOwHZjrzBs/uKB4cEjQliyfP+hCBukMgF/30x9dox8n74rOdnrL4Km+hpXAup0/AEn/qTPxYpcwQDw8sZwPSnilL2+8Xn7rnQCvP5wu3/749AHkVcFfH9HE8BelCaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08jo8aoKVgdgMVjBMu2R+KykKSS9L9XFX7btN6H3Y=;
 b=m78uPMgKkG320gozQ1rnZxYGBwFAP7FN35hQj6IoDXreqEucvxfo4EHs8rS6dhuIZgjuCz14QZRSYKYsm9OSDjCjqH/qJb1mx31H5kfQCeugqshboUmZHHtUJBSHHEg2LsO+l1NCmfd4plT5N/mzLts0LOzUZMVaXYRXmZvuf3k=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3193.namprd11.prod.outlook.com (2603:10b6:5:57::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.17; Sat, 12 Sep 2020 08:24:26 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::7053:1185:558b:bc54%9]) with mapi id 15.20.3370.017; Sat, 12 Sep 2020
 08:24:26 +0000
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
Subject: RE: [PATCH v7 03/16] vfio/type1: Report iommu nesting info to
 userspace
Thread-Topic: [PATCH v7 03/16] vfio/type1: Report iommu nesting info to
 userspace
Thread-Index: AQHWh19Ad2500LZ7hk+RwTlSasj5uqlj4i2AgADKKhA=
Date:   Sat, 12 Sep 2020 08:24:26 +0000
Message-ID: <DM5PR11MB14358D15B31136332DDBD068C3250@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
        <1599734733-6431-4-git-send-email-yi.l.liu@intel.com>
 <20200911141641.6f77f4d3@w520.home>
In-Reply-To: <20200911141641.6f77f4d3@w520.home>
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
x-ms-office365-filtering-correlation-id: 3b3964c9-12a1-4389-7fe5-08d856f542f0
x-ms-traffictypediagnostic: DM6PR11MB3193:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB31931DFACAE77E4A7E514253C3250@DM6PR11MB3193.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nSgqEicMnmZB8fYfFoTn1EiGB3KEpslfd1B9meeATIDEm4jzqnhkGNDmw8F48QG+1KjNl/Ae8id7Jix+dvgenZtFI8At76Dxp51nqwidjy0+W+1eIpDb6TU3M+1/xvHji58mLXqI5V9WMpEfUDSJmljk9MvfyTDENmpem8LhIAaLKJqukWvHIHysltOlFCYvFMgPjC6Jvda9jAiuIy1Dpnt7HGXU/XPBhlraFj9AmDz7dEcbRaer2s9KnPo9tyDEU1C8suSNHHUyqlV6adKzfxPqTV9yisDOw9fGzPQQ4IKziplhDGi9l3gB3mtBIc6W6HU1MIsl8y0zz/MUwUnXLBWRqaDb33knDv1wrdVWiPSNtNx2paTHbAWykK2lAVlFwjnjrLttszp/iTcGXReCDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(366004)(396003)(7416002)(2906002)(83380400001)(86362001)(26005)(66446008)(64756008)(66556008)(66476007)(66946007)(76116006)(186003)(6916009)(54906003)(6506007)(7696005)(966005)(8936002)(4326008)(8676002)(55016002)(9686003)(71200400001)(316002)(33656002)(478600001)(5660300002)(52536014)(30864003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: JQTQLw0HWkIopPOXtcFqb+VA3tCD6F5G91eIK/W/LI0uBp3NyWYOfY0P0Kf54WoaI/2FDld/vFMr/heMOcJd5LV9WytgHBYy+j2/h89hl9VhQ6ljKvJEbacLV4jZu7Ual3Zk+r46Dsiv1mZXhxPZCqc1Y1Tu0/gN2DUkXGePXurucS0O9FX6PlaZ+bXv93pZCuY6UhXjIodPup7R2OlQLz06nUxFsa+TmlYu7ctPopvMV5zKK5/yo7jo84At9sVexk9a3ZXjLMTjNh4flO2oBcxxbtdfSvC9+6/ry9IvKDdQxDD8T7CduVNS2chCNHiuvqCJcMkFLW12zUnmzmAj/gOz2XlVwoqUHuD9htYjluVElnVF9lakDKNeuczZ/Ww3nXNJrS2Mhk4sc4LUCPwo0NKX9SOBwI1FYkskBtw0eFBymbbl+MJ82QKe9vsLmBhkPNjDZyiimDqEVK/AN6KpO67qJ/Mq7RrOoWu4MwHcmsxwktmUXjKyZ4lwQrWJu69lECCxm5SFbR3HBhqm0Ine1e8ncZUytbHTJxW4NteOS6yvqpePo5U9ItV/MPvl0x/1pIoR3+eovHyMFye6cMf67d/JQPTrXbqxKCiVtWHaM5CroBfVn3hNu1UvKjUcAJKi4S8ijT1X36uv4/iLWi428A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b3964c9-12a1-4389-7fe5-08d856f542f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 08:24:26.0650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /PuBxguinYN5czQOBrMQ40IpdoghN5XFow224kNw197Ux8jrvqL07nNJA58X+EzfqPIMg0DI/akqZobN/+ppgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3193
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Saturday, September 12, 2020 4:17 AM
>=20
> On Thu, 10 Sep 2020 03:45:20 -0700
> Liu Yi L <yi.l.liu@intel.com> wrote:
>=20
> > This patch exports iommu nesting capability info to user space through
> > VFIO. Userspace is expected to check this info for supported uAPIs (e.g=
.
> > PASID alloc/free, bind page table, and cache invalidation) and the
> > vendor specific format information for first level/stage page table
> > that will be bound to.
> >
> > The nesting info is available only after container set to be NESTED typ=
e.
> > Current implementation imposes one limitation - one nesting container
> > should include at most one iommu group. The philosophy of vfio
> > container is having all groups/devices within the container share the
> > same IOMMU context. When vSVA is enabled, one IOMMU context could
> > include one 2nd- level address space and multiple 1st-level address
> > spaces. While the 2nd-level address space is reasonably sharable by
> > multiple groups, blindly sharing 1st-level address spaces across all
> > groups within the container might instead break the guest expectation.
> > In the future sub/super container concept might be introduced to allow
> > partial address space sharing within an IOMMU context. But for now
> > let's go with this restriction by requiring singleton container for
> > using nesting iommu features. Below link has the related discussion abo=
ut this
> decision.
> >
> > https://lore.kernel.org/kvm/20200515115924.37e6996d@w520.home/
> >
> > This patch also changes the NESTING type container behaviour.
> > Something that would have succeeded before will now fail: Before this
> > series, if user asked for a VFIO_IOMMU_TYPE1_NESTING, it would have
> > succeeded even if the SMMU didn't support stage-2, as the driver would
> > have silently fallen back on stage-1 mappings (which work exactly the
> > same as stage-2 only since there was no nesting supported). After the
> > series, we do check for DOMAIN_ATTR_NESTING so if user asks for
> > VFIO_IOMMU_TYPE1_NESTING and the SMMU doesn't support stage-2, the
> > ioctl fails. But it should be a good fix and completely harmless. Detai=
l can be found
> in below link as well.
> >
> > https://lore.kernel.org/kvm/20200717090900.GC4850@myrica/
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
> > v6 -> v7:
> > *) using vfio_info_add_capability() for adding nesting cap per suggesti=
on
> >    from Eric.
> >
> > v5 -> v6:
> > *) address comments against v5 from Eric Auger.
> > *) don't report nesting cap to userspace if the nesting_info->format is
> >    invalid.
> >
> > v4 -> v5:
> > *) address comments from Eric Auger.
> > *) return struct iommu_nesting_info for
> VFIO_IOMMU_TYPE1_INFO_CAP_NESTING as
> >    cap is much "cheap", if needs extension in future, just define anoth=
er cap.
> >    https://lore.kernel.org/kvm/20200708132947.5b7ee954@x1.home/
> >
> > v3 -> v4:
> > *) address comments against v3.
> >
> > v1 -> v2:
> > *) added in v2
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 92 +++++++++++++++++++++++++++++++++=
++-
> -----
> >  include/uapi/linux/vfio.h       | 19 +++++++++
> >  2 files changed, 99 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index c992973..3c0048b 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -62,18 +62,20 @@ MODULE_PARM_DESC(dma_entry_limit,
> >  		 "Maximum number of user DMA mappings per container (65535).");
> >
> >  struct vfio_iommu {
> > -	struct list_head	domain_list;
> > -	struct list_head	iova_list;
> > -	struct vfio_domain	*external_domain; /* domain for external user */
> > -	struct mutex		lock;
> > -	struct rb_root		dma_list;
> > -	struct blocking_notifier_head notifier;
> > -	unsigned int		dma_avail;
> > -	uint64_t		pgsize_bitmap;
> > -	bool			v2;
> > -	bool			nesting;
> > -	bool			dirty_page_tracking;
> > -	bool			pinned_page_dirty_scope;
> > +	struct list_head		domain_list;
> > +	struct list_head		iova_list;
> > +	/* domain for external user */
> > +	struct vfio_domain		*external_domain;
> > +	struct mutex			lock;
> > +	struct rb_root			dma_list;
> > +	struct blocking_notifier_head	notifier;
> > +	unsigned int			dma_avail;
> > +	uint64_t			pgsize_bitmap;
> > +	bool				v2;
> > +	bool				nesting;
> > +	bool				dirty_page_tracking;
> > +	bool				pinned_page_dirty_scope;
> > +	struct iommu_nesting_info	*nesting_info;
>=20
> Nit, not as important as the previous alignment, but might as well move t=
his up with
> the uint64_t pgsize_bitmap with the bools at the end of the structure to =
avoid adding
> new gaps.

got it. :-)

>=20
> >  };
> >
> >  struct vfio_domain {
> > @@ -130,6 +132,9 @@ struct vfio_regions {
> >  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
> >  					(!list_empty(&iommu->domain_list))
> >
> > +#define CONTAINER_HAS_DOMAIN(iommu)	(((iommu)->external_domain) || \
> > +					 (!list_empty(&(iommu)->domain_list)))
> > +
> >  #define DIRTY_BITMAP_BYTES(n)	(ALIGN(n, BITS_PER_TYPE(u64)) /
> BITS_PER_BYTE)
> >
> >  /*
> > @@ -1992,6 +1997,13 @@ static void vfio_iommu_iova_insert_copy(struct
> > vfio_iommu *iommu,
> >
> >  	list_splice_tail(iova_copy, iova);
> >  }
> > +
> > +static void vfio_iommu_release_nesting_info(struct vfio_iommu *iommu)
> > +{
> > +	kfree(iommu->nesting_info);
> > +	iommu->nesting_info =3D NULL;
> > +}
> > +
> >  static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  					 struct iommu_group *iommu_group)
> { @@ -2022,6 +2034,12 @@
> > static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  		}
> >  	}
> >
> > +	/* Nesting type container can include only one group */
> > +	if (iommu->nesting && CONTAINER_HAS_DOMAIN(iommu)) {
> > +		mutex_unlock(&iommu->lock);
> > +		return -EINVAL;
> > +	}
> > +
> >  	group =3D kzalloc(sizeof(*group), GFP_KERNEL);
> >  	domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> >  	if (!group || !domain) {
> > @@ -2092,6 +2110,25 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  	if (ret)
> >  		goto out_domain;
> >
> > +	/* Nesting cap info is available only after attaching */
> > +	if (iommu->nesting) {
> > +		int size =3D sizeof(struct iommu_nesting_info);
> > +
> > +		iommu->nesting_info =3D kzalloc(size, GFP_KERNEL);
> > +		if (!iommu->nesting_info) {
> > +			ret =3D -ENOMEM;
> > +			goto out_detach;
> > +		}
> > +
> > +		/* Now get the nesting info */
> > +		iommu->nesting_info->argsz =3D size;
> > +		ret =3D iommu_domain_get_attr(domain->domain,
> > +					    DOMAIN_ATTR_NESTING,
> > +					    iommu->nesting_info);
> > +		if (ret)
> > +			goto out_detach;
> > +	}
> > +
> >  	/* Get aperture info */
> >  	iommu_domain_get_attr(domain->domain, DOMAIN_ATTR_GEOMETRY,
> &geo);
> >
> > @@ -2201,6 +2238,7 @@ static int vfio_iommu_type1_attach_group(void
> *iommu_data,
> >  	return 0;
> >
> >  out_detach:
> > +	vfio_iommu_release_nesting_info(iommu);
> >  	vfio_iommu_detach_group(domain, group);
> >  out_domain:
> >  	iommu_domain_free(domain->domain);
> > @@ -2401,6 +2439,8 @@ static void vfio_iommu_type1_detach_group(void
> *iommu_data,
> >  					vfio_iommu_unmap_unpin_all(iommu);
> >  				else
> >
> 	vfio_iommu_unmap_unpin_reaccount(iommu);
> > +
> > +				vfio_iommu_release_nesting_info(iommu);
> >  			}
> >  			iommu_domain_free(domain->domain);
> >  			list_del(&domain->next);
> > @@ -2609,6 +2649,32 @@ static int vfio_iommu_migration_build_caps(struc=
t
> vfio_iommu *iommu,
> >  	return vfio_info_add_capability(caps, &cap_mig.header,
> > sizeof(cap_mig));  }
> >
> > +static int vfio_iommu_add_nesting_cap(struct vfio_iommu *iommu,
> > +				      struct vfio_info_cap *caps) {
> > +	struct vfio_iommu_type1_info_cap_nesting nesting_cap;
> > +	size_t size;
> > +
> > +	/* when nesting_info is null, no need to go further */
> > +	if (!iommu->nesting_info)
> > +		return 0;
> > +
> > +	/* when @format of nesting_info is 0, fail the call */
> > +	if (iommu->nesting_info->format =3D=3D 0)
> > +		return -ENOENT;
>=20
>=20
> Should we fail this in the attach_group?  Seems the user would be in a ba=
d situation
> here if they successfully created a nesting container but can't get info.=
  Is there
> backwards compatibility we're trying to maintain with this?

agreed. fail it in attach_group would be better.

> > +
> > +	size =3D offsetof(struct vfio_iommu_type1_info_cap_nesting, info) +
> > +	       iommu->nesting_info->argsz;
> > +
> > +	nesting_cap.header.id =3D VFIO_IOMMU_TYPE1_INFO_CAP_NESTING;
> > +	nesting_cap.header.version =3D 1;
> > +
> > +	memcpy(&nesting_cap.info, iommu->nesting_info,
> > +	       iommu->nesting_info->argsz);
> > +
> > +	return vfio_info_add_capability(caps, &nesting_cap.header, size); }
> > +
> >  static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
> >  				     unsigned long arg)
> >  {
> > @@ -2644,6 +2710,8 @@ static int vfio_iommu_type1_get_info(struct
> vfio_iommu *iommu,
> >  	if (!ret)
> >  		ret =3D vfio_iommu_iova_build_caps(iommu, &caps);
> >
> > +	ret =3D vfio_iommu_add_nesting_cap(iommu, &caps);
>=20
> Why don't we follow either the naming scheme or the error handling scheme=
 of the
> previous caps?  Seems like this should be:
>=20
> if (!ret)
> 	ret =3D vfio_iommu_nesting_build_caps(...);

got it. should follow the error handling scheme and also the naming. will
do it.

Regards,
Yi Liu

> Thanks,
>=20
> Alex
>=20
>=20
> > +
> >  	mutex_unlock(&iommu->lock);
> >
> >  	if (ret)
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 9204705..ff40f9e 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -14,6 +14,7 @@
> >
> >  #include <linux/types.h>
> >  #include <linux/ioctl.h>
> > +#include <linux/iommu.h>
> >
> >  #define VFIO_API_VERSION	0
> >
> > @@ -1039,6 +1040,24 @@ struct vfio_iommu_type1_info_cap_migration {
> >  	__u64	max_dirty_bitmap_size;		/* in bytes */
> >  };
> >
> > +/*
> > + * The nesting capability allows to report the related capability
> > + * and info for nesting iommu type.
> > + *
> > + * The structures below define version 1 of this capability.
> > + *
> > + * Nested capabilities should be checked by the userspace after
> > + * setting VFIO_TYPE1_NESTING_IOMMU.
> > + *
> > + * @info: the nesting info provided by IOMMU driver.
> > + */
> > +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  3
> > +
> > +struct vfio_iommu_type1_info_cap_nesting {
> > +	struct	vfio_info_cap_header header;
> > +	struct	iommu_nesting_info info;
> > +};
> > +
> >  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> >
> >  /**

