Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13631D4737
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 09:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgEOHjV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 03:39:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:58800 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726604AbgEOHjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 03:39:20 -0400
IronPort-SDR: 2zayjEaaOzaPs6TuH0IQwltdqxNQ7Dog/YB10LnvLFXr9wsYY3Nh3Adie0mW0ZlkwZpAqhz97K
 SG4JU2dLxezQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 00:39:18 -0700
IronPort-SDR: 97SfhJcOCnHcYMl2Y7HksNQd5Azf3M2VsYmHyUdM8xSvEE117l1a+X8Y5Y1XRiPQ+OZHrTzmHK
 cCleYXljs5XA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,394,1583222400"; 
   d="scan'208";a="438220183"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga005.jf.intel.com with ESMTP; 15 May 2020 00:39:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 15 May 2020 00:39:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 May 2020 00:39:17 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 15 May 2020 00:39:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 15 May 2020 00:39:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYprczgcBoAuVL9dO9oKEd/aLXOg3fCNlmog4RcKo45xUtAW0Lqp8vMHzIbIpHHqUtNB+O+so7enzmBPGcR1dz/BJtdnDUkRHFqZQUcnFPR0v40K8YizM1Fn7rt62biN8Roy0K5IhzAODB52JbkPJlsRw3LeNllR1xtOxrlneWBnHrVn8uTE5jHddV+uJQRX6K9DPVBz27v3jtSoIlGwwTFoTPNvQkq7A61ajoYt7ZKy/CuAaX8C4g/bje8Bs8If+Xs0ud3VlMG99czPJOf8rtF4nsmvO/zHMl2riaWOhOFP1CQcf139YFVphLNpA0+btBnVWQBduguvZFeH8mXflA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YmBTm9w8dK7qepCDJgA3O2HBIj9BlzbM8MIE9zZcvM=;
 b=oWZKWmkwwcyW3rGgCMNRNRsZTdInDMqGjxyT+0Ne927V0C4zgrAu8oqOPvAM5tFJz9TGVvzo3kJqAGdMl2mwHU7A40y6cvclalGIHzHcPYNz4UP7DBQyIfo1J5iRnj1ZjONk2cVCOHUw6G/FzdYM0a663wwgRsg1DVX9smC+kSfKPleBZbddi1VAbaGsXsJ+4scT2koFT4rrBf/XawcAolCSAFOQybW0MCLnEac4os90bnEPOHljFLhu7l9skgr7QP1GgAnBR0igrP9VWJpE7R2bTfUG8ZzhBZDAfMqxyu0RMq2U6dQcmwzOI0QyEOfW6nMQ10MX204W6JHrbGVCzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6YmBTm9w8dK7qepCDJgA3O2HBIj9BlzbM8MIE9zZcvM=;
 b=BdHNIhwdLzdAXnY4u8kmaWJHrPOZ3qbNRW4kNmNi2bampZaflFklo1Et1P+mIGxzE6KQbhb9D0dVPuruzC+Ah3ScyrqEuRBRr5owf9erLCDB+T+VTClhtlmwppykc8cQmVMpVFQzNK9paPXpFDRyfWK9dMNOmRj7X2vNQbty0lw=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Fri, 15 May
 2020 07:39:14 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::b441:f6bd:703b:ba41]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::b441:f6bd:703b:ba41%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 07:39:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>
Subject: (a design open) RE: [PATCH v1 6/8] vfio/type1: Bind guest page tables
 to host
Thread-Topic: (a design open) RE: [PATCH v1 6/8] vfio/type1: Bind guest page
 tables to host
Thread-Index: AdYqhFEO5GgnrItYSbi06NduB/9LVg==
Date:   Fri, 15 May 2020 07:39:14 +0000
Message-ID: <MWHPR11MB164538B052C3C6BCFE22D69E8CBD0@MWHPR11MB1645.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c5a7dcf-ef18-47e7-0041-08d7f8a310f8
x-ms-traffictypediagnostic: MWHPR11MB1792:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1792DC82B38861C3AA29E2988CBD0@MWHPR11MB1792.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04041A2886
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A6PtOivEybg8P+Ifgnu7EcWxCZd0lAnGJJoHBmJlWG3bo+DFFdzGnDUJrFW4vIcT4MO/V7RjJ872At585cHESTw5VmhBPbLN1/CM95B2xYLO1kfbGojBnJ/NVGYFUkfTZXv7wyJTDllyQEXedGv0ZsI5Md2ybvaLELV9dwiA/tBsbJcHZ6zJfV2PDLuevm9WcQy8IT1cild6/jmBghfgfil1QKcSqTOnNLU0mY/Tck7hg3pMF/7mT1dRJFkyMii8QnkCm6BBmo2PiIqQjUGYiHTmj1r4IOEdkTS13rF9FUzR+mmr3WcITeqnFhJtOMw5D7yaaUMt8AeEeLLVtp/G9DcZW5v3PO4RfnKhYVDFHFCU9Wnn3o8ehG+cXxxJhqkCOTB8ZyX2zDzCCU2TaRF42fa1PiBcVb5/kKLsdkJgtQ/x0ECS6oalu+KD23AnFnxO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(136003)(366004)(376002)(396003)(33656002)(478600001)(76116006)(86362001)(4326008)(6506007)(66556008)(2906002)(8936002)(9686003)(8676002)(66946007)(30864003)(55016002)(26005)(64756008)(66476007)(71200400001)(5660300002)(7696005)(66446008)(53546011)(54906003)(110136005)(316002)(186003)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: XQCmeBlZWKYB+ExnplV9x8ZfuCgtuiEufKVVinOozR+ervnn6wPrgeRUVXJqppgP9CweU9PQsHCm4e556lSo/vSjJZ4x9ovltBn7FSlief5I23tcO5n7VGHCbQOWAGUwGhE/rz9G3bxsFQEeZSSw7n4urYkH9whzTTn6vq2HR/5Wt4hTk6tfJjzc8Ei34ziJXX9bS6lKqPYNc9OConiOdkdXsjRlsuH9OUBce1Z0t3SvGWxjpItnSottaq65GMS4AJsTrzIz09PVseitV9V0ofCIx7tFP5JNoJVsb6IWdmYm2RFPKpGIPRDXHbk7itgRX7G0d5pJWzjdMWcKGuR5/d3RDUCi33HxLvBqkWZbV3qsXFN4TDdstqcNEPv7w3sGQwDOiGeu8JZWbBLDQRyu9fZyl4RZ9tWE1ouRSzaN/XaWKa9YhL9c2N7cH9rYvCqFVVfS2nL0ES3kEM2X3hGW3gDqFPyXLw5KU7DhSfXdJcJP43KI66DsYNaFKTGCl8m3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5a7dcf-ef18-47e7-0041-08d7f8a310f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2020 07:39:14.3550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Owx00R5aAOV/J82xpa2m13ZO2l794NM9wtZ7h1xrSglnMwKBI3JD60DzFlC7rITEVNjGZ/Aj2hZheJ4EVEI3EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

When working on an updated version Yi and I found an design open
which needs your guidance.

In concept nested translation can be incarnated as one GPA->HPA page
table and multiple GVA->GPA page tables per VM. It means one container
is sufficient to include all SVA-capable devices assigned to the same guest=
,
as there is just one iova space (GPA->HPA) to be managed by vfio iommu
map/unmap api. GVA->GPA page tables are bound through the new api
introduced in this patch. It is different from legacy shadow translation=20
which merges GIOVA->GPA->HPA into GIOVA->HPA thus each device requires=20
its own iova space and must be in a separate container.

However supporting multiple SVA-capable devices in one container=20
imposes one challenge. Now the bind_guest_pgtbl is implemented as
iommu type1 api. From the definition of iommu type 1 any operation
should be applied to all devices within the same container, just like
dma map/unmap. However this philosophy is incorrect regarding to
page table binding. We must follow the guest binding requirements=20
between its page tables and assigned devices, otherwise every bound
address space is suddenly accessible by all assigned devices thus creating
security holes.

Do you think whether it's possible to extend iommu api to accept
device specific cmd? If not, moving it to vfio-pci or vfio-mdev sounds
also problematic, as PASID and page tables are IOMMU things which
are not touched by vfio device drivers today.

Alternatively can we impose the limitation that nesting APIs can be
only enabled for singleton containers which contains only one device?
This basically falls back to the state of legacy shadow translation=20
vIOMMU. and our current Qemu vIOMMU implementation actually=20
does this way regardless of whether nesting is used. Do you think=20
whether such tradeoff is acceptable as a starting point?

Thanks
Kevin

> -----Original Message-----
> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Sunday, March 22, 2020 8:32 PM
> To: alex.williamson@redhat.com; eric.auger@redhat.com
> Cc: Tian, Kevin <kevin.tian@intel.com>; jacob.jun.pan@linux.intel.com;
> joro@8bytes.org; Raj, Ashok <ashok.raj@intel.com>; Liu, Yi L
> <yi.l.liu@intel.com>; Tian, Jun J <jun.j.tian@intel.com>; Sun, Yi Y
> <yi.y.sun@intel.com>; jean-philippe@linaro.org; peterx@redhat.com;
> iommu@lists.linux-foundation.org; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Wu, Hao <hao.wu@intel.com>
> Subject: [PATCH v1 6/8] vfio/type1: Bind guest page tables to host
>=20
> From: Liu Yi L <yi.l.liu@intel.com>
>=20
> VFIO_TYPE1_NESTING_IOMMU is an IOMMU type which is backed by
> hardware
> IOMMUs that have nesting DMA translation (a.k.a dual stage address
> translation). For such hardware IOMMUs, there are two stages/levels of
> address translation, and software may let userspace/VM to own the first-
> level/stage-1 translation structures. Example of such usage is vSVA (
> virtual Shared Virtual Addressing). VM owns the first-level/stage-1
> translation structures and bind the structures to host, then hardware
> IOMMU would utilize nesting translation when doing DMA translation fo
> the devices behind such hardware IOMMU.
>=20
> This patch adds vfio support for binding guest translation (a.k.a stage 1=
)
> structure to host iommu. And for VFIO_TYPE1_NESTING_IOMMU, not only
> bind
> guest page table is needed, it also requires to expose interface to guest
> for iommu cache invalidation when guest modified the first-level/stage-1
> translation structures since hardware needs to be notified to flush stale
> iotlbs. This would be introduced in next patch.
>=20
> In this patch, guest page table bind and unbind are done by using flags
> VFIO_IOMMU_BIND_GUEST_PGTBL and
> VFIO_IOMMU_UNBIND_GUEST_PGTBL under IOCTL
> VFIO_IOMMU_BIND, the bind/unbind data are conveyed by
> struct iommu_gpasid_bind_data. Before binding guest page table to host,
> VM should have got a PASID allocated by host via
> VFIO_IOMMU_PASID_REQUEST.
>=20
> Bind guest translation structures (here is guest page table) to host
> are the first step to setup vSVA (Virtual Shared Virtual Addressing).
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 158
> ++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h       |  46 ++++++++++++
>  2 files changed, 204 insertions(+)
>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c
> b/drivers/vfio/vfio_iommu_type1.c
> index 82a9e0b..a877747 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -130,6 +130,33 @@ struct vfio_regions {
>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>  					(!list_empty(&iommu->domain_list))
>=20
> +struct domain_capsule {
> +	struct iommu_domain *domain;
> +	void *data;
> +};
> +
> +/* iommu->lock must be held */
> +static int vfio_iommu_for_each_dev(struct vfio_iommu *iommu,
> +		      int (*fn)(struct device *dev, void *data),
> +		      void *data)
> +{
> +	struct domain_capsule dc =3D {.data =3D data};
> +	struct vfio_domain *d;
> +	struct vfio_group *g;
> +	int ret =3D 0;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next) {
> +		dc.domain =3D d->domain;
> +		list_for_each_entry(g, &d->group_list, next) {
> +			ret =3D iommu_group_for_each_dev(g->iommu_group,
> +						       &dc, fn);
> +			if (ret)
> +				break;
> +		}
> +	}
> +	return ret;
> +}
> +
>  static int put_pfn(unsigned long pfn, int prot);
>=20
>  /*
> @@ -2314,6 +2341,88 @@ static int
> vfio_iommu_info_add_nesting_cap(struct vfio_iommu *iommu,
>  	return 0;
>  }
>=20
> +static int vfio_bind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data *gbind_data =3D
> +		(struct iommu_gpasid_bind_data *) dc->data;
> +
> +	return iommu_sva_bind_gpasid(dc->domain, dev, gbind_data);
> +}
> +
> +static int vfio_unbind_gpasid_fn(struct device *dev, void *data)
> +{
> +	struct domain_capsule *dc =3D (struct domain_capsule *)data;
> +	struct iommu_gpasid_bind_data *gbind_data =3D
> +		(struct iommu_gpasid_bind_data *) dc->data;
> +
> +	return iommu_sva_unbind_gpasid(dc->domain, dev,
> +					gbind_data->hpasid);
> +}
> +
> +/**
> + * Unbind specific gpasid, caller of this function requires hold
> + * vfio_iommu->lock
> + */
> +static long vfio_iommu_type1_do_guest_unbind(struct vfio_iommu
> *iommu,
> +				struct iommu_gpasid_bind_data *gbind_data)
> +{
> +	return vfio_iommu_for_each_dev(iommu,
> +				vfio_unbind_gpasid_fn, gbind_data);
> +}
> +
> +static long vfio_iommu_type1_bind_gpasid(struct vfio_iommu *iommu,
> +				struct iommu_gpasid_bind_data *gbind_data)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret =3D vfio_iommu_for_each_dev(iommu,
> +			vfio_bind_gpasid_fn, gbind_data);
> +	/*
> +	 * If bind failed, it may not be a total failure. Some devices
> +	 * within the iommu group may have bind successfully. Although
> +	 * we don't enable pasid capability for non-singletion iommu
> +	 * groups, a unbind operation would be helpful to ensure no
> +	 * partial binding for an iommu group.
> +	 */
> +	if (ret)
> +		/*
> +		 * Undo all binds that already succeeded, no need to
> +		 * check the return value here since some device within
> +		 * the group has no successful bind when coming to this
> +		 * place switch.
> +		 */
> +		vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
> +static long vfio_iommu_type1_unbind_gpasid(struct vfio_iommu *iommu,
> +				struct iommu_gpasid_bind_data *gbind_data)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&iommu->lock);
> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
> +		ret =3D -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	ret =3D vfio_iommu_type1_do_guest_unbind(iommu, gbind_data);
> +
> +out_unlock:
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -2471,6 +2580,55 @@ static long vfio_iommu_type1_ioctl(void
> *iommu_data,
>  		default:
>  			return -EINVAL;
>  		}
> +
> +	} else if (cmd =3D=3D VFIO_IOMMU_BIND) {
> +		struct vfio_iommu_type1_bind bind;
> +		u32 version;
> +		int data_size;
> +		void *gbind_data;
> +		int ret;
> +
> +		minsz =3D offsetofend(struct vfio_iommu_type1_bind, flags);
> +
> +		if (copy_from_user(&bind, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (bind.argsz < minsz)
> +			return -EINVAL;
> +
> +		/* Get the version of struct iommu_gpasid_bind_data */
> +		if (copy_from_user(&version,
> +			(void __user *) (arg + minsz),
> +					sizeof(version)))
> +			return -EFAULT;
> +
> +		data_size =3D iommu_uapi_get_data_size(
> +				IOMMU_UAPI_BIND_GPASID, version);
> +		gbind_data =3D kzalloc(data_size, GFP_KERNEL);
> +		if (!gbind_data)
> +			return -ENOMEM;
> +
> +		if (copy_from_user(gbind_data,
> +			 (void __user *) (arg + minsz), data_size)) {
> +			kfree(gbind_data);
> +			return -EFAULT;
> +		}
> +
> +		switch (bind.flags & VFIO_IOMMU_BIND_MASK) {
> +		case VFIO_IOMMU_BIND_GUEST_PGTBL:
> +			ret =3D vfio_iommu_type1_bind_gpasid(iommu,
> +							   gbind_data);
> +			break;
> +		case VFIO_IOMMU_UNBIND_GUEST_PGTBL:
> +			ret =3D vfio_iommu_type1_unbind_gpasid(iommu,
> +							     gbind_data);
> +			break;
> +		default:
> +			ret =3D -EINVAL;
> +			break;
> +		}
> +		kfree(gbind_data);
> +		return ret;
>  	}
>=20
>  	return -ENOTTY;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ebeaf3e..2235bc6 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -14,6 +14,7 @@
>=20
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
> +#include <linux/iommu.h>
>=20
>  #define VFIO_API_VERSION	0
>=20
> @@ -853,6 +854,51 @@ struct vfio_iommu_type1_pasid_request {
>   */
>  #define VFIO_IOMMU_PASID_REQUEST	_IO(VFIO_TYPE, VFIO_BASE +
> 22)
>=20
> +/**
> + * Supported flags:
> + *	- VFIO_IOMMU_BIND_GUEST_PGTBL: bind guest page tables to host
> for
> + *			nesting type IOMMUs. In @data field It takes struct
> + *			iommu_gpasid_bind_data.
> + *	- VFIO_IOMMU_UNBIND_GUEST_PGTBL: undo a bind guest page
> table operation
> + *			invoked by VFIO_IOMMU_BIND_GUEST_PGTBL.
> + *
> + */
> +struct vfio_iommu_type1_bind {
> +	__u32		argsz;
> +	__u32		flags;
> +#define VFIO_IOMMU_BIND_GUEST_PGTBL	(1 << 0)
> +#define VFIO_IOMMU_UNBIND_GUEST_PGTBL	(1 << 1)
> +	__u8		data[];
> +};
> +
> +#define VFIO_IOMMU_BIND_MASK	(VFIO_IOMMU_BIND_GUEST_PGTBL
> | \
> +
> 	VFIO_IOMMU_UNBIND_GUEST_PGTBL)
> +
> +/**
> + * VFIO_IOMMU_BIND - _IOW(VFIO_TYPE, VFIO_BASE + 23,
> + *				struct vfio_iommu_type1_bind)
> + *
> + * Manage address spaces of devices in this container. Initially a TYPE1
> + * container can only have one address space, managed with
> + * VFIO_IOMMU_MAP/UNMAP_DMA.
> + *
> + * An IOMMU of type VFIO_TYPE1_NESTING_IOMMU can be managed by
> both MAP/UNMAP
> + * and BIND ioctls at the same time. MAP/UNMAP acts on the stage-2 (host=
)
> page
> + * tables, and BIND manages the stage-1 (guest) page tables. Other types=
 of
> + * IOMMU may allow MAP/UNMAP and BIND to coexist, where
> MAP/UNMAP controls
> + * the traffics only require single stage translation while BIND control=
s the
> + * traffics require nesting translation. But this depends on the underly=
ing
> + * IOMMU architecture and isn't guaranteed. Example of this is the guest
> SVA
> + * traffics, such traffics need nesting translation to gain gVA->gPA and=
 then
> + * gPA->hPA translation.
> + *
> + * Availability of this feature depends on the device, its bus, the unde=
rlying
> + * IOMMU and the CPU architecture.
> + *
> + * returns: 0 on success, -errno on failure.
> + */
> +#define VFIO_IOMMU_BIND		_IO(VFIO_TYPE, VFIO_BASE + 23)
> +
>  /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU --------=
 */
>=20
>  /*
> --
> 2.7.4

