Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F7D33CF43
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 09:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhCPIGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 04:06:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:57558 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233792AbhCPIG2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 04:06:28 -0400
IronPort-SDR: q9Y6uiEr3ir6WcPg405amuh9aZKH7Lr4oYFbb54/z2QpG0O50nG7MDmu/NmmvcYl6AMM5TCv0u
 z+kgvq1GGjZQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9924"; a="169136067"
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="169136067"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2021 01:06:28 -0700
IronPort-SDR: 6vPYIGygoITxj4h4+3XCKCMqhWaNyXCgjnX8ToS7oXzHjcVFQbWGizIGWrSq1B1n+tB1SJ8Il1
 yIGnRUgQpaOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,251,1610438400"; 
   d="scan'208";a="440014034"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Mar 2021 01:06:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 16 Mar 2021 01:06:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 16 Mar 2021 01:06:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 16 Mar 2021 01:06:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nM6Re+c2myaiaanR3i1bZ3AMrQloE+Ewo1BSH0RupowSSY+vuDLSky3xOumAsi0UrnafVrzpzIhogxF1dyNY/llAPbTC5zBY5Syc3q8xB2dVnQBJbeYWKN8B2rwaFGPoSyGMuDVIEM09nkq1b2T35joML82MVAUfKtqfKOxRwwnUSiVowklLz05kgpodA+uW2Du7g6LfuDgeoc9hHKm+y3XIrXdYWC04hnXERQSZKUtL4bpnDeyP7z3uSzVdAeHKHVBtoNH9s+gbY8Sy6OD9CNdgsr3v4T17NlcF9Dyc6NaVEU8UCS4g6PsKhKC+N8h9cMvM4un1a8YkQAvXegXtfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMpzxwtGnDjECuATUdz68twSo7SXs/HP4h1XaMgXBRw=;
 b=NZiNIumlr29rNFTM4VogesGzZ28urYeh2jPMet2PVZ4ZlRHboxXObFNJpeF9/oGpcjLhizwsVOXoZHYuz/VkoTT3ZwlcMHQ5pO1euABz/dAnle+au+473RsJmGcpthijOqAhjqcRPkNT3DAZMFGYBi7oHzXkqiuX8BhTr1NyMSJSZmytsVkGDxmFF9tNsX/3FkqEFsy4P9GLAutGzTqJ5kqSpsXsAdsr4v/esci8DmtbEzLvDKcK14x9HkfN73DjJ1BkUOpSgSNivRJCTsB3YsEC5z5cl9DP1j7GSu54d1lyCBKGSJmil/yaNWkhRgSvXr432aeaR1LEHn98dQoMhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lMpzxwtGnDjECuATUdz68twSo7SXs/HP4h1XaMgXBRw=;
 b=xCs3M8PaZDoTh6vADB/X6XeOJT8FqQpg+aXn0iSJ34AehcmnNL2jp//R+hVIW9f3J2ZYD96ucltr8yYKueQtvx0IeiR5OzLat3IgXrTsd4C+7GgVrs451nAaOGueUcOERpphnbc3lFqqHJp6xqcr/nVcjdzGv4eGJxHS45ECOIY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1664.namprd11.prod.outlook.com (2603:10b6:301:c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 08:06:26 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 08:06:26 +0000
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
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 09/14] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Thread-Topic: [PATCH v2 09/14] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Thread-Index: AQHXF6PvzoRkRRB6gEOfXKJ8WqPBx6qGRtkQ
Date:   Tue, 16 Mar 2021 08:06:25 +0000
Message-ID: <MWHPR11MB1886BA597E1F305C7FBA08208C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
 <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
In-Reply-To: <9-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 265008db-ef68-479e-54d6-08d8e8526587
x-ms-traffictypediagnostic: MWHPR11MB1664:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB16640EB49B52FE53F4E79A9C8C6B9@MWHPR11MB1664.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VeX93Xl5b1eY5hRqcbgbxG9biu/8/dnW+mCw2t7azZteNXkzy+drjudkXF+Lf/gAXlpJHNhhYO3X4IiYqv0JyV+AnLVNcUSv+611nNPkYt8YMBu+Ym5INNB4JmEkC0Z+Na+GE3JBvtq3MJLZ3o9eAYZ77wvqIWTPEV0pRswORf16Xo7IgF2dzzhXwdtArFhkhAMzC2vBEDzy3oTP1ZV09j9wrZcDcUGrINqA9IQ3/iGhB/pyaV8jn0MCxsVCGiLLve+V4uuPxR58rUtSSW4wfV8kF7OXxRL+XAMV7SXjKwqPRCjyYfFuZ+kbppj1+m29cF7C9PlSyQHq2l+i2z0JLJ34wg6tqXKRRQcCVnj348IZXh+ryLZLqjpppV70J38ec577VrsUlAxXyS6HbNItOajyVN9H6TnEkOWi/Z9xU46r/seigzj3Gr6saiHWuHk0dZw26vVHqvRnGLyi4+woW7sqqwDPxQHv7Zdx7wWp0ezLgFXGnselyJpSnVzxyOogVT38dEdN5lHuou+YEvbqyyYbamIh1FMI6HDH+28jm9wdlc7quCY9TWsh+BW2m8Mw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(346002)(396003)(376002)(66556008)(110136005)(7416002)(478600001)(2906002)(66476007)(71200400001)(54906003)(8676002)(316002)(76116006)(186003)(64756008)(86362001)(6506007)(66946007)(5660300002)(52536014)(83380400001)(4326008)(55016002)(26005)(33656002)(7696005)(9686003)(8936002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?z9p3SA6ht8qip4XuSyjlE2p5I2WRAqy7l5NMOzBniwW+vHe8MgjKRwuax/c4?=
 =?us-ascii?Q?/3Jcr5SADQPqhl6ohGw2a/Eq1nWZtRTZFyEDsZ/O3pw8XRGDSExgRwzuz5vQ?=
 =?us-ascii?Q?xHEf2nH3QderNRseutHA5DTUbcS0WGRv4nk7LB+Y+fRCe3SXOnGqSPxb+Es/?=
 =?us-ascii?Q?Yao5GnMSlU3UmJmdlgBjpJcCooFqYspszNLeysEcJq2VTKsdh1zzEE1EZj1q?=
 =?us-ascii?Q?nEcMRHWw0lKPBbPtKK7ML8eDklet6LpHUoTvQp9KzPPrj58PVTG0kcsAgKO1?=
 =?us-ascii?Q?ShyYCaPHTBEbn19tCzE28o3JQyVAd04IWVoxnkr/aEIe566Db1qHzS0YzTgi?=
 =?us-ascii?Q?1f/EJ5A8Se5WptI79bWAnflRJ6YCSAJy1WqiTw7TglO2jTKThebUR4oTyb7o?=
 =?us-ascii?Q?TZffySvtkCdIZ4OUaWRtZvnU1/rb4oeFhAFWt+f30590+2f2XMV7QGwj7uOU?=
 =?us-ascii?Q?SdUUhjgY6wAAZGK97BNwhs46i8my4uVa7/LQaLFMon5drA4rs2pt73sxR6Pq?=
 =?us-ascii?Q?dlejQ338hnbTj7AX2zR5eawLPHzgzGA1jXBRkGvgHyYmYQEor2rzvw1IsbE4?=
 =?us-ascii?Q?Gb9RZ+WWa+tkdiuiJdlojJbicA6ujoNbLUvMdv23nNIa5GrUT2Dsc70WYCsN?=
 =?us-ascii?Q?HUhLWgGB5TWqBDAr5SlhnBNhuuAhW+/LYxU1l2V5ZzAUUizlY1woixRN8De9?=
 =?us-ascii?Q?Rr5YPmO0SSNQxFOM68IUOI4wCdNvIo8dcPtnuOnZNmxUMOo+TKu9U8/WVcHl?=
 =?us-ascii?Q?+H/OOo+2df6PYen8bvA0z8kqqK+AzkPl1lfPqYoaemOaIUQso/NVzPk2SKoT?=
 =?us-ascii?Q?lwBZ6jTVbp2OJRlEH0getFRan82SE0vVnhzneUnmVtPsstiBdCBfFs2BruC1?=
 =?us-ascii?Q?t09nRKz8qNIWqgCA5p73U+6pkDvRa876i0dYkknz7UY0ByNubm4g28Le9KMn?=
 =?us-ascii?Q?j6TuBztG5coerOaXDw4HxfLZ6ugOIWcLyOX4HKNdUvep/rBWl0nZWhqXr1wp?=
 =?us-ascii?Q?qmSpBTkY2gYHcQfhv+eFGn+bDWaAea/dum1g82f3YHMW9SwgSmM0tQ3Yypfb?=
 =?us-ascii?Q?gp0qTz78tz99Yp/7ZotFe62QMCR6jaKEVuKVchSlS2S6exXbt+mkeDH4KWHq?=
 =?us-ascii?Q?wu1cQzn/tVfPFBLtelCh8DkJrsf41jVtEvqv3lnfJwl+GH8E0Ou7HUTrWYvf?=
 =?us-ascii?Q?j96OH/xYByvV1yTpYNA56YUpIBr8WN60b74l/PqaSl/GOPJNZfPgfKMUT0X8?=
 =?us-ascii?Q?dCPS9QnNmtI6FlJwkYdKnr1wAe8sKmq9ehuG+go8axRrWqkrnt3d8IgU/kC3?=
 =?us-ascii?Q?neXKjjZKGn5qU6UDDgzXwQzN?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 265008db-ef68-479e-54d6-08d8e8526587
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 08:06:25.9905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4JVmDoTjel7fntcGXPzPqF3yieqI4mXdfUnI3mBA4UX51A/s1RIxFEvCvfAanPcI7M3LuyhT4Zdqa+rrONmJxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1664
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, March 13, 2021 8:56 AM
>=20
> pci already allocates a struct vfio_pci_device with exactly the same
> lifetime as vfio_device, switch to the new API and embed vfio_device in
> vfio_pci_device.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/pci/vfio_pci.c         | 10 +++++-----
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 0e7682e7a0b478..a0ac20a499cf6c 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2019,6 +2019,7 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  		goto out_group_put;
>  	}
>=20
> +	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops, vdev);
>  	vdev->pdev =3D pdev;
>  	vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
>  	mutex_init(&vdev->igate);
> @@ -2056,9 +2057,10 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  	}
>=20
> -	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> +	ret =3D vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
>  		goto out_power;
> +	dev_set_drvdata(&pdev->dev, vdev);
>  	return 0;
>=20
>  out_power:
> @@ -2078,13 +2080,11 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>=20
>  static void vfio_pci_remove(struct pci_dev *pdev)
>  {
> -	struct vfio_pci_device *vdev;
> +	struct vfio_pci_device *vdev =3D dev_get_drvdata(&pdev->dev);
>=20
>  	pci_disable_sriov(pdev);
>=20
> -	vdev =3D vfio_del_group_dev(&pdev->dev);
> -	if (!vdev)
> -		return;
> +	vfio_unregister_group_dev(&vdev->vdev);
>=20
>  	vfio_pci_vf_uninit(vdev);
>  	vfio_pci_reflck_put(vdev->reflck);
> diff --git a/drivers/vfio/pci/vfio_pci_private.h
> b/drivers/vfio/pci/vfio_pci_private.h
> index 9cd1882a05af69..8755a0febd054a 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -100,6 +100,7 @@ struct vfio_pci_mmap_vma {
>  };
>=20
>  struct vfio_pci_device {
> +	struct vfio_device	vdev;
>  	struct pci_dev		*pdev;
>  	void __iomem		*barmap[PCI_STD_NUM_BARS];
>  	bool			bar_mmap_supported[PCI_STD_NUM_BARS];
> --
> 2.30.2

