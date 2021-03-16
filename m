Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE933CFC0
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhCPIXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:23:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:32443 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234399AbhCPIWp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:22:45 -0400
IronPort-SDR: gxNeuUHE8VqkjjB5TolflMnswGiAaQVwjGeHlJnW079aH48M6Zg2kAXjufVZQIJ+2Dtyple9lG
 Ma+cBLKOKQbw==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="168494829"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="168494829"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:22:44 -0700
IronPort-SDR: V74lCn8xknhTQA6kpQML5ZWrdku4y3799Q9LxxnBP1chL59zyWwUXyKaZWJ77F4/+dB2KfO0ov
 5hQ+NEuHB47w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="373716017"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2021 01:22:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:22:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:22:41 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 01:22:41 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.56) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 01:22:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebtyvJYySxI7JljyGUwKhYryGXrEEO5TQIfiG444GwLtBXGqrjd41HLq4z+srcW/95Zo30ziMe2ZwisC2Mhh24MIM7DgWrninT70DVBVh7xLdjA/XrL0QWIQBTDIgpczFK3ySxKV3YKJJtXIt8QMiwkIObhpChuVBl02yV71OYnr4ESidRedtVBh8VVztfXyhMLn86PDiqLz8q6XvthEBKYM1lwKYpfQI5IvbuO+abE4L5DXPpUdSmcG8obJOaUVTVtYks8yV75pgrk3V+9ErDqm3VyeQb3UP2P4ETiaHe/MAI3aQkWUK969p/mmrNvuH5gZOU5aBV7HZ3iuveCJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ONyZpScGKAYOU0pfz3tUK+d/5HCnsjrhsqN0CwUH9c=;
 b=nAIHx+E4UL4LKur+Q6r0gU050beJqHLCi+3viDvyBpb9mAvBxUKnKdp2MpKGkEDsz9drQacsBWPvVavkf+NO20N3CbQgn53+64I+KPwlvGyeSfoxzdktqvvs2fVRXzpSsTE79/HIse73H2rlWVVVZ2psZP7ksTBMP9CyjkirQeZGtlIZ9+XJuIY38Xk3lLVQVxfn3/ZHwV6eoLoep97xieM/Qu4e3kZXp7WliQBjCbJEqCsRgngpb+3fKa29xK8bKaV9uv2v3mJN/EERBX/HmsZIwoKoNmOcgQ5h4ab4UDDLlhmGIFwV3N1rQeUBol2IwPVzrt6jQBN7pe/iW1WChQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ONyZpScGKAYOU0pfz3tUK+d/5HCnsjrhsqN0CwUH9c=;
 b=uoYP9A8Lq57PhE+asJdr1cRthA9Nsxu4IEbNQQYVXKoPViVvzBkXzMtsUrrDm4XILJ2zXWMsVM2HVJZEAxDH5PScKlfE3ton+AJKyyPRd0CqIov/JRTKF5u3JlnBpYRGWrwMaAAS8suI7kUnXcqCQmxzdRJVeEcBFv359ShLB+U=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1821.namprd11.prod.outlook.com (2603:10b6:300:10f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 08:22:34 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:22:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        "Eric Auger" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH v2 14/14] vfio: Remove device_data from the vfio bus
 driver API
Thread-Topic: [PATCH v2 14/14] vfio: Remove device_data from the vfio bus
 driver API
Thread-Index: AQHXF6QAn4f1TInXKEKM+B6PaQdrN6qGS08A
Date:   Tue, 16 Mar 2021 08:22:34 +0000
Message-ID: <MWHPR11MB18864B99282D870DB28207BE8C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <14-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: e10e522b-7e14-4543-b50b-08d8e854a6de
x-ms-traffictypediagnostic: MWHPR11MB1821:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1821FD8F3970C3AC12E8B8E08C6B9@MWHPR11MB1821.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8gnmCMwgdgW89pFGAJkBFQA2eUxHomSmFRZJWjkQ5OKiB5R7d/o/FisAguLrrzI1nN1mp42LurUNtKXtM7c4Cdz6+uHNWIgzOnEQZR15zNsvS1v1wg713nqxb1oLgZggQAuYi1rdyWNPgjXYA/XIGg4h0HFC7n37upqUDhcjrUPtO/O//ceCBFeih7CPpWRZEIwv+EP8caKfYZxYgvdRAjdLSbD3NVioXpD5BSuPgWU1s30DLOInUHlaJK8Xv1Yu3SVGyYv/m1PqyHx9tlb0Km0ok4J1F9l6lVCKRza+1vtiRlJcYBUCLbu0Zf6mAiosgYg/Ch5wm653BNoJ+9oX/mT9A+YVB75VhKDd5m2ovUBvl6CmmVXpCbxk8CTki8GLFniBSPJu3Ztsb5uPNdOWXV3BQ9CLuwUWomimwwpe34odvmpadtKX0CzWgeDFvZOUg4MZ7ALaetDktKrVW/SjGsucUddxgCzL9bRIQQqOHSvAvtNT9hudsVBaQ/b5jUjEMtRRmQcRbNdcZIR09yZuFMz615tm70T0Y+0rJLTZ2OAi8JgAPo0Ip9S7H6rm9+Sx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(346002)(136003)(66446008)(66476007)(52536014)(33656002)(86362001)(55016002)(83380400001)(66556008)(76116006)(64756008)(66946007)(71200400001)(110136005)(5660300002)(54906003)(4326008)(26005)(7416002)(8936002)(186003)(9686003)(8676002)(478600001)(316002)(2906002)(7696005)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WvyTG+CigOwxFvM1t7sqy7x/SlGHG7RCGvxFQZVQMLR8OaNbrZv77yLw5QbF?=
 =?us-ascii?Q?nZJ4+oN/OLHebum/8On/D8+2bmRRX2feHmLwdkMu4agmbH6pzOPxoQTlNWBq?=
 =?us-ascii?Q?8G/QmGd4e6MVd6Jc4GNGewTtrKWStW2Z3mxubIwrFrwkXb45Yt7FBqn4to1j?=
 =?us-ascii?Q?UAGHTQgzVxNdsZNVzXENM74mkUOrkxo9rYm2IZ+cplYHpYAj5xTtm4/S2Y/F?=
 =?us-ascii?Q?lXbEx43/F34dAJMoPI23DCkh/Rigsja35LgbrdE6YQU2PQMqAltto84xqVpq?=
 =?us-ascii?Q?2HFVo78PTHn9qS4ilDvVyn+fQnqzWTWRec86O4DLLwIOcMgDRR9pmT/6PQsY?=
 =?us-ascii?Q?WBa/u1fDv94/NZ4jESPklVaL5fUwwAcu3J4KSk1r3D4CtZx/GvDyrp7hIFTn?=
 =?us-ascii?Q?DwRE+c/p613vfpGEknqm/VfQaCKLNC9AwPJNoiNKES2Q+k8aVbmny6z9oBmZ?=
 =?us-ascii?Q?A4MaBLHkOzx+4wYkGDQap9NaOuN/dex8Pn1es2uiXOERUkIa+kxs5KvKzHgV?=
 =?us-ascii?Q?bLwub4KRRNtq7gzRpu5/JrxVM7BF3KJTcAtMl+lg+Fb3c1QauBhzaMcrfgdO?=
 =?us-ascii?Q?FPzHJgiW6N/Gg/49AHGfpGecvqiF2r5ykXKFkspg74DaHarlTUnm8yTh7uTq?=
 =?us-ascii?Q?8wlJoy69yhJt5nNKtPiRq7ACpGpF2QeuB7KIirJc1Gk5aD3vuqO9g+LfXkgA?=
 =?us-ascii?Q?AGRyvgyBuc6HAM6W8ltU2epMoIRfVrWaDwL4SkhMz8t3ehMEJQiariUlm+k7?=
 =?us-ascii?Q?xsfQeh5eNsq5gEIrrq1OwvGvlmfu2UgRw21ct3m2Mg0Qm1r4CgxYjoKwWkCW?=
 =?us-ascii?Q?oosWAoKAce08EU/ckyo/JEjDFxx9kOGwvq2T/0j7UyuGwCSAlJd5aNAf6Afp?=
 =?us-ascii?Q?w/bn9xZ6EEqba9SdG3bV+En+0SGoHYh3KjgqZ0u9RxIv3S5qCJXdyWxyjkC3?=
 =?us-ascii?Q?O5KaOjb1b8cjdf6HM8gegZZ9QQrROtxPou3TbwK/oDhAc+3/zA9w8F/1yCIo?=
 =?us-ascii?Q?4R2RK5ZplFjz+alQOQrVqd+bbycqVFY0Eln5BhQm9FwzNQBp19saNYK/GST7?=
 =?us-ascii?Q?OIvAyGviKYg00VUSUi5/r+Nu7hkoSF2Mdq/jueIAlfkoWIRTlJ5tDRc942L6?=
 =?us-ascii?Q?tAHrWT3AeXVa09y8KwGiXjDYH6Y0U3kpXzRBFfKWkVL9oj2MuMRDlB3Wad41?=
 =?us-ascii?Q?KiSkQOfTSuFs315A6IHcNYqWJ2LPo3FwS5XvNlvPmo2mhdKyNAkyZlNArt5A?=
 =?us-ascii?Q?2kFRTatPLPeAmcyK92gx5cSnWhARe8jf+hVifdccBMgy3RTsGaai0J/55GpK?=
 =?us-ascii?Q?QidbzlTWZy990NuIAGVfpZL8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e10e522b-7e14-4543-b50b-08d8e854a6de
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:22:34.6085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KuMvgW7b75/t9P8o4cvawAFhwoI7NZO5WyTLxeB+nUIqxX7GvsUuxCkiURyKsu931MoHV40Ll4gOAaggAzLzow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1821
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> There are no longer any users, so it can go away. Everything is using
> container_of now.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  Documentation/driver-api/vfio.rst            |  3 +--
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            |  5 +++--
>  drivers/vfio/mdev/vfio_mdev.c                |  2 +-
>  drivers/vfio/pci/vfio_pci.c                  |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c |  2 +-
>  drivers/vfio/vfio.c                          | 12 +-----------
>  include/linux/vfio.h                         |  4 +---
>  7 files changed, 9 insertions(+), 21 deletions(-)
>=20
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-
> api/vfio.rst
> index 3337f337293a32..decc68cb8114ac 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -254,8 +254,7 @@ vfio_unregister_group_dev() respectively::
>=20
>  	void vfio_init_group_dev(struct vfio_device *device,
>  				struct device *dev,
> -				const struct vfio_device_ops *ops,
> -				void *device_data);
> +				const struct vfio_device_ops *ops);
>  	int vfio_register_group_dev(struct vfio_device *device);
>  	void vfio_unregister_group_dev(struct vfio_device *device);
>=20
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-
> mc/vfio_fsl_mc.c
> index 023b2222806424..3af3ca59478f94 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -75,7 +75,8 @@ static int vfio_fsl_mc_reflck_attach(struct
> vfio_fsl_mc_device *vdev)
>  			goto unlock;
>  		}
>=20
> -		cont_vdev =3D vfio_device_data(device);
> +		cont_vdev =3D
> +			container_of(device, struct vfio_fsl_mc_device, vdev);
>  		if (!cont_vdev || !cont_vdev->reflck) {
>  			vfio_device_put(device);
>  			ret =3D -ENODEV;
> @@ -624,7 +625,7 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device
> *mc_dev)
>  		goto out_group_put;
>  	}
>=20
> -	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops, vdev);
> +	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops);
>  	vdev->mc_dev =3D mc_dev;
>  	mutex_init(&vdev->igate);
>=20
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index e7309caa99c71b..71bd28f976e5af 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -138,7 +138,7 @@ static int vfio_mdev_probe(struct device *dev)
>  	if (!mvdev)
>  		return -ENOMEM;
>=20
> -	vfio_init_group_dev(&mvdev->vdev, &mdev->dev,
> &vfio_mdev_dev_ops, mdev);
> +	vfio_init_group_dev(&mvdev->vdev, &mdev->dev,
> &vfio_mdev_dev_ops);
>  	ret =3D vfio_register_group_dev(&mvdev->vdev);
>  	if (ret) {
>  		kfree(mvdev);
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 1f70387c8afe37..55ef27a15d4d3f 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2022,7 +2022,7 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  		goto out_group_put;
>  	}
>=20
> -	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
> +	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops);
>  	vdev->pdev =3D pdev;
>  	vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
>  	mutex_init(&vdev->igate);
> diff --git a/drivers/vfio/platform/vfio_platform_common.c
> b/drivers/vfio/platform/vfio_platform_common.c
> index f5f6b537084a67..361e5b57e36932 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -666,7 +666,7 @@ int vfio_platform_probe_common(struct
> vfio_platform_device *vdev,
>  	struct iommu_group *group;
>  	int ret;
>=20
> -	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops, vdev);
> +	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops);
>=20
>  	ret =3D vfio_platform_acpi_probe(vdev, dev);
>  	if (ret)
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 01de47d1810b6b..39ea77557ba0c4 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -741,12 +741,11 @@ static int vfio_iommu_group_notifier(struct
> notifier_block *nb,
>   * VFIO driver API
>   */
>  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> -			 const struct vfio_device_ops *ops, void *device_data)
> +			 const struct vfio_device_ops *ops)
>  {
>  	init_completion(&device->comp);
>  	device->dev =3D dev;
>  	device->ops =3D ops;
> -	device->device_data =3D device_data;
>  }
>  EXPORT_SYMBOL_GPL(vfio_init_group_dev);
>=20
> @@ -851,15 +850,6 @@ static struct vfio_device
> *vfio_device_get_from_name(struct vfio_group *group,
>  	return device;
>  }
>=20
> -/*
> - * Caller must hold a reference to the vfio_device
> - */
> -void *vfio_device_data(struct vfio_device *device)
> -{
> -	return device->device_data;
> -}
> -EXPORT_SYMBOL_GPL(vfio_device_data);
> -
>  /*
>   * Decrement the device reference count and wait for the device to be
>   * removed.  Open file descriptors for the device... */
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 784c34c0a28763..a2c5b30e1763ba 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -24,7 +24,6 @@ struct vfio_device {
>  	refcount_t refcount;
>  	struct completion comp;
>  	struct list_head group_next;
> -	void *device_data;
>  };
>=20
>  /**
> @@ -61,12 +60,11 @@ extern struct iommu_group
> *vfio_iommu_group_get(struct device *dev);
>  extern void vfio_iommu_group_put(struct iommu_group *group, struct
> device *dev);
>=20
>  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> -			 const struct vfio_device_ops *ops, void
> *device_data);
> +			 const struct vfio_device_ops *ops);
>  int vfio_register_group_dev(struct vfio_device *device);
>  void vfio_unregister_group_dev(struct vfio_device *device);
>  extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
> -extern void *vfio_device_data(struct vfio_device *device);
>=20
>  /* events for the backend driver notify callback */
>  enum vfio_iommu_notify_type {
> --
> 2.30.2

