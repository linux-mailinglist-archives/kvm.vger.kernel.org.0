Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D446D33CF9F
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhCPIVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:21:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:17582 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234381AbhCPIVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:21:06 -0400
IronPort-SDR: psAQYpxdQe6cvy6DGZMe3zIQxf8cyTffVCK32PAzyic8dMYvK5LQMy1td5LO/ikrqTT6qBOa/7
 FinD8yKn3TOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="250586329"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="250586329"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:21:05 -0700
IronPort-SDR: DvudRhrGp2nBO/qxq0dIPUsHaFOuBifr19PtNoX+4lrAshg0RXt4h2+SIw7aaS9RJ2Lc75dRUT
 wLP2Xp43ZRww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="522430909"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2021 01:21:05 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:21:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:21:04 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 01:21:04 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.56) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 01:21:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9KQ+8MpdcYRWw/PCZwAPbY5R0MnFwlauR263LFaayvYwZdOjCPO3hI8gfeYt+UsejOFUFMLE/tniuBaEQiIUQEGPUtAkugityslOM47RJgIjav3vL6M7N43rJpFE9lv8XEWUReU/5c6pQU/0IUikLfR8N009WILJGxpU4EepvSxe5spC3jX7d8uFSghp1pxOYY27/raAe/AJ/bR6TooPA2OWBl++IsB9+ruTbtseS0nN2+wXsb0qGuX5FRn6KElIzBIxQhVN/fQxCD2NLPikdnkwzKc0Shyu8zNwdoIi904i0RqGDy1RM2IZip5gQ5IAkXqoi8Wx1Y1/Q8RFhISUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wL64BElOI/9nzcVtG7M/JahQXE7Gtmy7AroxemNv06w=;
 b=YazjX+3Mk/xIs2eYqp0UiMvT6Y5r0YeZipHUARdSRLKlZ2NBDlP7+pmWRFhqynXT2qzB5pCdSHLKjMyJlYfinIg73SXLyqDoByPQAf/HEiylxb2FEMQ77juzLi8CxEqgka/FTtic8uLhBkLJSwDzzpXgY/IBRYVQWkCwGXs82dK0pCxBaznk9eWZjcLqgxQ+z7SyiM5Ty1GtftomrlwaS4Ay1n7qYXHUer1N6qZLwLhs8esjA89lSb6sbjD6EcISe02xZUFpkIFLJ2eZptA0L5g6ouNxuGKEKz+m9J5tL5lUQIFFtAAKUAQKZ2NZmPpOXJhgisc5V333ix/KYvTOTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wL64BElOI/9nzcVtG7M/JahQXE7Gtmy7AroxemNv06w=;
 b=Q3q0TKTkz6nm9jS6+5GgrPs9GZzrOcUdPbW2gwbE5VaT61dXgHYpckBotCyX0iQv0a4vTaNQHokFsOjswBJL4Y86FjXFdMK339Jf3n+YSnMJY/W2f//nZCFbaD1xRvnB1R2bzXZQxRNs4ieO+VRtNuKYRpP58IAgc1Qc60jDqFo=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1821.namprd11.prod.outlook.com (2603:10b6:300:10f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 08:20:57 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:20:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 13/14] vfio/pci: Replace uses of vfio_device_data()
 with container_of
Thread-Topic: [PATCH v2 13/14] vfio/pci: Replace uses of vfio_device_data()
 with container_of
Thread-Index: AQHXF6PbtZe/2D3jeEmDyEwZkj49AqqGSzOA
Date:   Tue, 16 Mar 2021 08:20:57 +0000
Message-ID: <MWHPR11MB18865996D930F70395D039B38C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <13-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <13-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b91b1568-456a-442a-8b5b-08d8e8546d00
x-ms-traffictypediagnostic: MWHPR11MB1821:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB18212FDE9522DD229941230A8C6B9@MWHPR11MB1821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TKaWArFgmO9/p98nCu5ReFzeFewAS32JrBmK9yLLk8ZUzXFevzOtMBt/VoH5kQv1V3cI1AlcQ4QHoe5Fh4zxC/RPB7vZyn14GSHKQ/Mh8Me1vu0Q1pHPLjQqG3NPmQgiWoNQykUg1AmJWKriFVm3kCJZkkEJuh63rD+pphWGHhg/8U0KFgLlCkqfWC3pjMzGKmL5Svxj9MH1A470X8Oy/3mspFwTtdc5awFWSwN4aU+z8KcRC7PK0MsDrst6fPiW2HzP0Y57KDOrzqCD/4mqSdLikDVaQv59bH6AjAHMR/JbY6gJWog/MRO8LRDz9uZf/tahp+EmTsmOQvpkeICDclOMOA8c8NBRo+OC219Us0fKW7HcSdqe0jdCx/N6iT8cidU1qC9FRYpHTah7bZ5h0cYKjx0ZcXkigo2uLEKfFcL6qHFsvgXUjzkVwkUTunPn8MBJ7tExKgJ6t6tCGAFHTClzPFAzAIDI8YFPduwmbZmhRYzEH2S8qsPqJ7YJ5DiST+BD6j0UGgJbJusYdhk7p6sBC2ZdQdR0TvWSg9EtiuW3LYR5L2p5hlETP2rbvbPB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(66446008)(66476007)(52536014)(33656002)(86362001)(55016002)(83380400001)(66556008)(76116006)(64756008)(66946007)(71200400001)(110136005)(5660300002)(54906003)(4326008)(26005)(7416002)(8936002)(186003)(9686003)(8676002)(478600001)(316002)(2906002)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?a3PKjScEEJKGlX8QwAdKmLlzB0Bmz06frHo2/rNhyp+8OyeGmTN23JCYl4c9?=
 =?us-ascii?Q?/mxkIyWgZxtHagZRl9jo5cs1aOhfom2lDhJnwdp0tgw8adxHz9e70frK/EUO?=
 =?us-ascii?Q?TA7GoVJlV7+XVzBFsfhumAmO94oTqkAykjaJ+3uAxWA0s4Ivn/tjXIllwAal?=
 =?us-ascii?Q?zUEDPPJJG0nUfuC3lFSmBks+YMO9e/SbvpG9fx/mXpF4/Sv1wnKfZXubK+nr?=
 =?us-ascii?Q?gT5IIJDhJIoNhGAejR8GY/ZgTA3TmGKWqBFVVEP5aD3Jx3yhNyxv5WG+tzCK?=
 =?us-ascii?Q?nVfTjF0THAywm5fwlTMreVGEWMw+avPxtqvnQqPbiH3iZT92z3W0U3+D9Vmu?=
 =?us-ascii?Q?PHnM9v3q89eT4tawhpS1D1Hqh3j3Ai0dNVqJ3kQB6PwmU5UOQ+ACMuMyMnxt?=
 =?us-ascii?Q?6MkQv0AjDz1EOD1VEIJydEKgdX7eSXLGbrJ4pmPYEpnNUrAPdL6y1ZpoMmh/?=
 =?us-ascii?Q?VZ1Bw1RO+HzBPLM/RMTmi3ZUfibO4X9Kyn2exC9cCuRXX1E/q7ICR2K9C54i?=
 =?us-ascii?Q?OZnlQk9Ksg4T/BFpU4UvQnTC2E9jjgUJPU8aLU8SHTqeQBO9UjWg73hAj/qU?=
 =?us-ascii?Q?lj+Q5mzi6kh1ihGPHpaVP66d0nnvcp1n39dxopUXSi3/MPDHCsYXjzHW2paP?=
 =?us-ascii?Q?ijbwiG/eBrc7uJolXdSsULhOniFBJOWoh8L3K44B4YTA7XBxAYQWxO4sbawn?=
 =?us-ascii?Q?jK80Qo3dKDunHxQ6N3lTbzIrRn4SyI54LfCGruKIN/r9rq+iCeQzRHjdQzyv?=
 =?us-ascii?Q?a7AwE2PNoZ9gnPlYou70r1/UbANiWy+heOAimyS0yk7IBPzH7cK9yYo+/nTy?=
 =?us-ascii?Q?RO2jNc8HahE8FQspWXgZd7FdRS2P2daAvjni3db4IfaolkczqekyA5ES0SZk?=
 =?us-ascii?Q?99ZtZByiRztfxCgslyFbn5PUNIdEfqbzT5imkkwWD71UPaOOTdo1DL2XrDm5?=
 =?us-ascii?Q?EVqXcfyoVb4WTvlT1QaglD/sjSnhvZmpOQUlG5ARmvJTtvvlfvwB55rpmYjc?=
 =?us-ascii?Q?qsBbMMCYMciIkCZT3/7g2nGT90ewbANySbFo750sQFNxWhWZb9YcaeSw2mVk?=
 =?us-ascii?Q?ICfEf6f+6VMWun7F+OT9GdWFZvvL9r6HMC+ErPfeIdKBoD/fJbsSosmCsORX?=
 =?us-ascii?Q?c/f4VHxMsjFcwHO+m+CDk76t7FEPBXUsZd3hE6bh3MrN9nYpfHnvkpP9YeNu?=
 =?us-ascii?Q?Fe5jOxv7/03srq0zD8KIMEKfFAZ/GPmDXfmdqvADFLPJZ8F1PP1nXX0PDqjD?=
 =?us-ascii?Q?lXWXNchhlixh2lDv1ivzKMCWTUvq7EKvMQth4RFTzhDJasQWvAYx2UiPfGBx?=
 =?us-ascii?Q?k+Fr4PcncywzjRsEzVd7o70E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b91b1568-456a-442a-8b5b-08d8e8546d00
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:20:57.5284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LCbgwk+ZO/pabqXEDpSichShzuUD/dqVjFZQZh6t3DvjlZK6mPmGwb8u7GryRKR1mFo9Alhd6P3sHZEwGiHREQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1821
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> This tidies a few confused places that think they can have a refcount on
> the vfio_device but the device_data could be NULL, that isn't possible by
> design.
>=20
> Most of the change falls out when struct vfio_devices is updated to just
> store the struct vfio_pci_device itself. This wasn't possible before
> because there was no easy way to get from the 'struct vfio_pci_device' to
> the 'struct vfio_device' to put back the refcount.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/pci/vfio_pci.c | 67 +++++++++++++------------------------
>  1 file changed, 24 insertions(+), 43 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5f1a782d1c65ae..1f70387c8afe37 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -517,30 +517,29 @@ static void vfio_pci_disable(struct vfio_pci_device
> *vdev)
>=20
>  static struct pci_driver vfio_pci_driver;
>=20
> -static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev,
> -					   struct vfio_device **pf_dev)
> +static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev)
>  {
>  	struct pci_dev *physfn =3D pci_physfn(vdev->pdev);
> +	struct vfio_device *pf_dev;
>=20
>  	if (!vdev->pdev->is_virtfn)
>  		return NULL;
>=20
> -	*pf_dev =3D vfio_device_get_from_dev(&physfn->dev);
> -	if (!*pf_dev)
> +	pf_dev =3D vfio_device_get_from_dev(&physfn->dev);
> +	if (!pf_dev)
>  		return NULL;
>=20
>  	if (pci_dev_driver(physfn) !=3D &vfio_pci_driver) {
> -		vfio_device_put(*pf_dev);
> +		vfio_device_put(pf_dev);
>  		return NULL;
>  	}
>=20
> -	return vfio_device_data(*pf_dev);
> +	return container_of(pf_dev, struct vfio_pci_device, vdev);
>  }
>=20
>  static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int=
 val)
>  {
> -	struct vfio_device *pf_dev;
> -	struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev, &pf_dev);
> +	struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev);
>=20
>  	if (!pf_vdev)
>  		return;
> @@ -550,7 +549,7 @@ static void vfio_pci_vf_token_user_add(struct
> vfio_pci_device *vdev, int val)
>  	WARN_ON(pf_vdev->vf_token->users < 0);
>  	mutex_unlock(&pf_vdev->vf_token->lock);
>=20
> -	vfio_device_put(pf_dev);
> +	vfio_device_put(&pf_vdev->vdev);
>  }
>=20
>  static void vfio_pci_release(struct vfio_device *core_vdev)
> @@ -794,7 +793,7 @@ int vfio_pci_register_dev_region(struct
> vfio_pci_device *vdev,
>  }
>=20
>  struct vfio_devices {
> -	struct vfio_device **devices;
> +	struct vfio_pci_device **devices;
>  	int cur_index;
>  	int max_index;
>  };
> @@ -1283,9 +1282,7 @@ static long vfio_pci_ioctl(struct vfio_device
> *core_vdev,
>  			goto hot_reset_release;
>=20
>  		for (; mem_idx < devs.cur_index; mem_idx++) {
> -			struct vfio_pci_device *tmp;
> -
> -			tmp =3D vfio_device_data(devs.devices[mem_idx]);
> +			struct vfio_pci_device *tmp =3D devs.devices[mem_idx];
>=20
>  			ret =3D down_write_trylock(&tmp->memory_lock);
>  			if (!ret) {
> @@ -1300,17 +1297,13 @@ static long vfio_pci_ioctl(struct vfio_device
> *core_vdev,
>=20
>  hot_reset_release:
>  		for (i =3D 0; i < devs.cur_index; i++) {
> -			struct vfio_device *device;
> -			struct vfio_pci_device *tmp;
> -
> -			device =3D devs.devices[i];
> -			tmp =3D vfio_device_data(device);
> +			struct vfio_pci_device *tmp =3D devs.devices[i];
>=20
>  			if (i < mem_idx)
>  				up_write(&tmp->memory_lock);
>  			else
>  				mutex_unlock(&tmp->vma_lock);
> -			vfio_device_put(device);
> +			vfio_device_put(&tmp->vdev);
>  		}
>  		kfree(devs.devices);
>=20
> @@ -1777,8 +1770,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_device *vdev,
>  		return 0; /* No VF token provided or required */
>=20
>  	if (vdev->pdev->is_virtfn) {
> -		struct vfio_device *pf_dev;
> -		struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev,
> &pf_dev);
> +		struct vfio_pci_device *pf_vdev =3D get_pf_vdev(vdev);
>  		bool match;
>=20
>  		if (!pf_vdev) {
> @@ -1791,7 +1783,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_device *vdev,
>  		}
>=20
>  		if (!vf_token) {
> -			vfio_device_put(pf_dev);
> +			vfio_device_put(&pf_vdev->vdev);
>  			pci_info_ratelimited(vdev->pdev,
>  				"VF token required to access device\n");
>  			return -EACCES;
> @@ -1801,7 +1793,7 @@ static int vfio_pci_validate_vf_token(struct
> vfio_pci_device *vdev,
>  		match =3D uuid_equal(uuid, &pf_vdev->vf_token->uuid);
>  		mutex_unlock(&pf_vdev->vf_token->lock);
>=20
> -		vfio_device_put(pf_dev);
> +		vfio_device_put(&pf_vdev->vdev);
>=20
>  		if (!match) {
>  			pci_info_ratelimited(vdev->pdev,
> @@ -2122,11 +2114,7 @@ static pci_ers_result_t
> vfio_pci_aer_err_detected(struct pci_dev *pdev,
>  	if (device =3D=3D NULL)
>  		return PCI_ERS_RESULT_DISCONNECT;
>=20
> -	vdev =3D vfio_device_data(device);
> -	if (vdev =3D=3D NULL) {
> -		vfio_device_put(device);
> -		return PCI_ERS_RESULT_DISCONNECT;
> -	}
> +	vdev =3D container_of(device, struct vfio_pci_device, vdev);
>=20
>  	mutex_lock(&vdev->igate);
>=20
> @@ -2142,7 +2130,6 @@ static pci_ers_result_t
> vfio_pci_aer_err_detected(struct pci_dev *pdev,
>=20
>  static int vfio_pci_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
>  {
> -	struct vfio_pci_device *vdev;
>  	struct vfio_device *device;
>  	int ret =3D 0;
>=20
> @@ -2155,12 +2142,6 @@ static int vfio_pci_sriov_configure(struct pci_dev
> *pdev, int nr_virtfn)
>  	if (!device)
>  		return -ENODEV;
>=20
> -	vdev =3D vfio_device_data(device);
> -	if (!vdev) {
> -		vfio_device_put(device);
> -		return -ENODEV;
> -	}
> -
>  	if (nr_virtfn =3D=3D 0)
>  		pci_disable_sriov(pdev);
>  	else
> @@ -2220,7 +2201,7 @@ static int vfio_pci_reflck_find(struct pci_dev *pde=
v,
> void *data)
>  		return 0;
>  	}
>=20
> -	vdev =3D vfio_device_data(device);
> +	vdev =3D container_of(device, struct vfio_pci_device, vdev);
>=20
>  	if (vdev->reflck) {
>  		vfio_pci_reflck_get(vdev->reflck);
> @@ -2282,7 +2263,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev
> *pdev, void *data)
>  		return -EBUSY;
>  	}
>=20
> -	vdev =3D vfio_device_data(device);
> +	vdev =3D container_of(device, struct vfio_pci_device, vdev);
>=20
>  	/* Fault if the device is not unused */
>  	if (vdev->refcnt) {
> @@ -2290,7 +2271,7 @@ static int vfio_pci_get_unused_devs(struct pci_dev
> *pdev, void *data)
>  		return -EBUSY;
>  	}
>=20
> -	devs->devices[devs->cur_index++] =3D device;
> +	devs->devices[devs->cur_index++] =3D vdev;
>  	return 0;
>  }
>=20
> @@ -2312,7 +2293,7 @@ static int
> vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
>  		return -EBUSY;
>  	}
>=20
> -	vdev =3D vfio_device_data(device);
> +	vdev =3D container_of(device, struct vfio_pci_device, vdev);
>=20
>  	/*
>  	 * Locking multiple devices is prone to deadlock, runaway and
> @@ -2323,7 +2304,7 @@ static int
> vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
>  		return -EBUSY;
>  	}
>=20
> -	devs->devices[devs->cur_index++] =3D device;
> +	devs->devices[devs->cur_index++] =3D vdev;
>  	return 0;
>  }
>=20
> @@ -2371,7 +2352,7 @@ static void vfio_pci_try_bus_reset(struct
> vfio_pci_device *vdev)
>=20
>  	/* Does at least one need a reset? */
>  	for (i =3D 0; i < devs.cur_index; i++) {
> -		tmp =3D vfio_device_data(devs.devices[i]);
> +		tmp =3D devs.devices[i];
>  		if (tmp->needs_reset) {
>  			ret =3D pci_reset_bus(vdev->pdev);
>  			break;
> @@ -2380,7 +2361,7 @@ static void vfio_pci_try_bus_reset(struct
> vfio_pci_device *vdev)
>=20
>  put_devs:
>  	for (i =3D 0; i < devs.cur_index; i++) {
> -		tmp =3D vfio_device_data(devs.devices[i]);
> +		tmp =3D devs.devices[i];
>=20
>  		/*
>  		 * If reset was successful, affected devices no longer need
> @@ -2396,7 +2377,7 @@ static void vfio_pci_try_bus_reset(struct
> vfio_pci_device *vdev)
>  				vfio_pci_set_power_state(tmp, PCI_D3hot);
>  		}
>=20
> -		vfio_device_put(devs.devices[i]);
> +		vfio_device_put(&tmp->vdev);
>  	}
>=20
>  	kfree(devs.devices);
> --
> 2.30.2

