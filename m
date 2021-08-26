Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187A63F8000
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 03:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbhHZBky (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 21:40:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:63769 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235172AbhHZBkx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 21:40:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="204781203"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="204781203"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 18:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="575558618"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 25 Aug 2021 18:40:03 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 25 Aug 2021 18:40:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 25 Aug 2021 18:40:03 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 25 Aug 2021 18:40:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhSQNYEGk2/GqMVf+I3Sed0aIQK2shSozzK+5GLfcO0iLj/QGYrBuZae1VU21iAkK0omHyI2We1qVRvdQzChvJpB1+83V3YEA31NcCwrXEtiS1Wy3FaaknYFdfnqtX7mRbxHnsWRIrW3yn1O9iFhOXxBKvD4Rj2Vutp/bkRip9+1iTVFoJb0A5EZWdgV+0Z9NrAAwqUQo6q6DsPBcX2Z6Zyvx5BvzwHe4leGx4WBxJG05sxYaY3XxpbTaC4lkVIMxqhuAx6eeIeAW6d5bYPqQqJ0zHl4hgwnAmy/qdtWVM/pRhIJ3SijS/7f9+70Wlg//taNYDC875OXy4c1ZkIikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trigLPyNTdJNiuYqs98X+9umcQDcZycwo0bi1ubiqHk=;
 b=CkWUKbrxe5b4i8S/lAPbvhOBuf/Mh9UDjRpFuzMKSIjQYxFdjnbNO9RDCC6IEk16pWGbd/xsMX6wh6Jr3xdtwBwrAAumLwj/yripm/JTXY4/JBYD3OrveDK6u7W3uA15N+popX+Q8TKmiax8DUrD6/S9/kZipxcPGIyJ8ZeQhmGvP76kjlcR0K+SNOnT89PRpJs7Bj1+arsnslwIa+0A/PON6NvX2iUrmroIC3xuFN+nG/AFrziHP5IaUqjDv3e7lTw6bFHNkqIRbRMcN2BBw206haPW4Bs8dh61AH+ZvXjikrAI35TMDgtaFDzUsJ5rfFwnNdesQXHN3BAgbEpjPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trigLPyNTdJNiuYqs98X+9umcQDcZycwo0bi1ubiqHk=;
 b=aQeUYZTnOATV+JPEG2PhnOZcI4gln88b2vud5cIePxhKPyZ/IK1Doi4739ctNcvZ32Nw9OitBGsxkry+6ccwxnFcGmqJ3v6HfyLNHpRCpW9fxkgv05+gGTgRPM7bApUAokPdNAN4/x6RkbcPS+g7Zue2kNdR71q78+WKVidWjfA=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1332.namprd11.prod.outlook.com (2603:10b6:404:48::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 01:40:00 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::1508:e154:a267:2cce%5]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 01:40:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Thread-Topic: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Thread-Index: AQHXmc20SEGPi2xmuEqyZR+Rgk+1UauFAYAg
Date:   Thu, 26 Aug 2021 01:40:00 +0000
Message-ID: <BN9PR11MB54333E1472046CD30F3EFE5C8CC79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-2-hch@lst.de>
In-Reply-To: <20210825161916.50393-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aeefd8ad-3e03-485b-e66b-08d968326b38
x-ms-traffictypediagnostic: BN6PR11MB1332:
x-microsoft-antispam-prvs: <BN6PR11MB1332821BD58C3113B26774AF8CC79@BN6PR11MB1332.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OX0iPfuF2GWZzyfAsDh9SRwBg2qrQ5+LDxJYINz1LAMMdIrDkimBC1bKqyVBlNMctKstcvmIKDZYDiD1CBMIuY1ZdVIoQC1Ls5GiXyRDa8mEMw7T++j8yQz9puW7cJM5/dO5Ubxkn/KUsmqe4mhvy5000wRdnmGYeeG9U7Td6/q6n2SjekVAVGM/TsOFuYVpQf87rmEprQRyuweFaVbXHSw9qcsJGwHKQlhijwzcKcNkqygU2FMCJHEPV53jsSQKNR/0oNYl9dNcZ49jHGVlINJdaFUwIbATGUqQvDh9k876Wot0jGrWVZ0BSqxA3JBcMrw3uLzh3lrdNehHu8/t/gTDOMkbvE7NVkKxFfmscaDMSVNKGJS+iyKb42wPNrDER/pZ+nptSGJejAoII1NOxFYsCBFkGdNfPRtkyJlh8ZsrLdEctm6BzPTrUijc7/tfb3B3vEb6WZX7StapgzzBhFJiwxhbRV8VWpaD6hfgUsv4BHXinI/gbgwAY0+2wPYt4iQqlwr5zMtooYKvRi5G3UHwP+oUBu5jdGE5dPPyoaeojxQCDEgAcGD2IV0XVSy2OeCXn/ZaCFGB/W2qbNmRi21XkxEO5oi3yEmwLjal3qZEW/rZA6KpLzUBqf2byAn1BP0EulOufcRb/roaV2jR+BPCO/70clSRcZUN3mS5oPwqNjrUMPaZMmu872q6F44D4pKV6kWVf4sRM9A/8L8LuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(110136005)(7696005)(6506007)(316002)(83380400001)(71200400001)(2906002)(8936002)(478600001)(38100700002)(54906003)(66446008)(9686003)(8676002)(66556008)(66946007)(33656002)(66476007)(186003)(122000001)(38070700005)(55016002)(76116006)(86362001)(4326008)(5660300002)(26005)(64756008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U4YGHrg9CeVbt+O9GLw6ELrIyOampjuAqrixCvbIBKAMocIKl3/rhkPEBzRi?=
 =?us-ascii?Q?YBTWIY1ldbYWhZB3sT6nnYexQrfkBfJjwXj4X82JDlzJIspY5xoyirt3GiB2?=
 =?us-ascii?Q?4CQB4ilxLZjzQEdTEv4xlNSkyyl3m8GFOVjXdFFc6rg1Ttvvg9WueKeAz3Xo?=
 =?us-ascii?Q?yJy88tkR+C2MxJfKwo0SYqliuPOdOxCY+rKuGzlQvlmjiiZ5w4uBZGKVu5rb?=
 =?us-ascii?Q?agWYSULnyuVyL308teW67y5JZ9MBFlsAr4Ix3Hr1Kd8l3yNb6rvz6HvDhzcI?=
 =?us-ascii?Q?PG1qYY+8tkzNX6mCr80a9V/qYuRnLjRCiSEz7RIM6PScQqHtpkIhT1mAXvEB?=
 =?us-ascii?Q?ZFQ2VDK16xWFAePflv3iQ/m7DPwg/wQcDnOLF2d2asIe2+GjoETGS/7Q6YOx?=
 =?us-ascii?Q?GK3p16CLuHjxj6ZuHmsVFiQb/+NRqhykYwsO2NvgpvN9Gz4u/gFOxcP/7a17?=
 =?us-ascii?Q?9U/Jj7VnJU8TRxlNh9MhJaK+aYpCbZBAQ9wPFA7qUq/0IpOCjBzxL0TLah7B?=
 =?us-ascii?Q?1DYnswXDdB4+bTgzmuXdh9pd5v85QLuYRDkYZpnLyveiQhZHrXoYYx85nLGh?=
 =?us-ascii?Q?lWnkFubqeEiYs7CGeLEi+WuXxUCo/urBDd33dXAUQLw+p+1VxQfudjexzWM3?=
 =?us-ascii?Q?bP+LZjS2AJzcdupoBJNknX63OKw1knDiIvT0g9zZt3i24Q8wqhZ8emT+Y5TF?=
 =?us-ascii?Q?hanQCeQgyDTFkSD1Eyy600g+M3xrCWZ2LoPeFV75NYAYsZZlM67TVjt6Xy1a?=
 =?us-ascii?Q?ezXdyfIzb1G/schoxWroIOLcAuJUjhtQIWrr9UUUSS72NbcOujUFUVIRC/E2?=
 =?us-ascii?Q?3q35GVv0GJ/jik7Qcr0zbyjWWRmeD4fl0CNthp1/lhlGmmzNbU0bGD4nKlTZ?=
 =?us-ascii?Q?VtR71VwLMXQapKm52bHmz29sPE8rJHUbyX9l9qdGkT9JdMkzLQLQeqGZdSHy?=
 =?us-ascii?Q?ugk2k4I04shzWWKkP/KP/NuQ0z0/Pk+8BENqXGKrtm0ISo2OK+7aVyiqkS2e?=
 =?us-ascii?Q?WktDHctiuUTkMvvKYZ0ZoOvy4Crr8q0+6xE4VkdDjZZpnBR3wiPJ1SkXF9tn?=
 =?us-ascii?Q?mAJU6KneYU0fC8WeiCZZKXZLLPQHaJBLOcM1AhMNBfvw1p5wPmIuBooMbLhU?=
 =?us-ascii?Q?PEYUC9DYsKb2FTWTw0GavVeFKRh7AkwhLYjn7jKh0qYszOhLoPwoXxJb4BiT?=
 =?us-ascii?Q?6IJqoP7THQfmMp2j0foTEKusX6ygi2Rzsnh1KN1K7Txo4HmpTKldgyRK73xh?=
 =?us-ascii?Q?Jn2NsLsmRKZHrBmzpzJc7hs4Eq06vVv2Ku64XXUGrKSIoHOZQOdMO080NJle?=
 =?us-ascii?Q?wmYyyeP6vBf6M/Cnaga2dMOQ?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aeefd8ad-3e03-485b-e66b-08d968326b38
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 01:40:00.4985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qjPlBsO+HPox/fH5iNRF96Oi7yY/b/+qI47jrUFbTCpxcFi9OFTxEdi+i2yHBzrZB/CWfZ7z5fftVwRt9y+Xhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1332
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Thursday, August 26, 2021 12:19 AM
>=20
> We don't need to hold a reference to the group in the driver as well as
> obtain a reference to the same group as the first thing
> vfio_register_group_dev() does.
>=20
> Since the drivers never use the group move this all into the core code.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 17 ++-----------
>  drivers/vfio/pci/vfio_pci_core.c             | 13 ++--------
>  drivers/vfio/platform/vfio_platform_common.c | 13 +---------
>  drivers/vfio/vfio.c                          | 25 ++++++--------------
>  include/linux/vfio.h                         |  3 ---
>  5 files changed, 12 insertions(+), 59 deletions(-)
>=20
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-
> mc/vfio_fsl_mc.c
> index 0ead91bfa83867..9e838fed560339 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -505,22 +505,13 @@ static void vfio_fsl_uninit_device(struct
> vfio_fsl_mc_device *vdev)
>=20
>  static int vfio_fsl_mc_probe(struct fsl_mc_device *mc_dev)
>  {
> -	struct iommu_group *group;
>  	struct vfio_fsl_mc_device *vdev;
>  	struct device *dev =3D &mc_dev->dev;
>  	int ret;
>=20
> -	group =3D vfio_iommu_group_get(dev);
> -	if (!group) {
> -		dev_err(dev, "VFIO_FSL_MC: No IOMMU group\n");
> -		return -EINVAL;
> -	}
> -
>  	vdev =3D kzalloc(sizeof(*vdev), GFP_KERNEL);
> -	if (!vdev) {
> -		ret =3D -ENOMEM;
> -		goto out_group_put;
> -	}
> +	if (!vdev)
> +		return -ENOMEM;
>=20
>  	vfio_init_group_dev(&vdev->vdev, dev, &vfio_fsl_mc_ops);
>  	vdev->mc_dev =3D mc_dev;
> @@ -556,8 +547,6 @@ static int vfio_fsl_mc_probe(struct fsl_mc_device
> *mc_dev)
>  out_uninit:
>  	vfio_uninit_group_dev(&vdev->vdev);
>  	kfree(vdev);
> -out_group_put:
> -	vfio_iommu_group_put(group, dev);
>  	return ret;
>  }
>=20
> @@ -574,8 +563,6 @@ static int vfio_fsl_mc_remove(struct fsl_mc_device
> *mc_dev)
>=20
>  	vfio_uninit_group_dev(&vdev->vdev);
>  	kfree(vdev);
> -	vfio_iommu_group_put(mc_dev->dev.iommu_group, dev);
> -
>  	return 0;
>  }
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index c67751948504af..4134dceab3f73b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1807,7 +1807,6 @@
> EXPORT_SYMBOL_GPL(vfio_pci_core_uninit_device);
>  int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
>  {
>  	struct pci_dev *pdev =3D vdev->pdev;
> -	struct iommu_group *group;
>  	int ret;
>=20
>  	if (pdev->hdr_type !=3D PCI_HEADER_TYPE_NORMAL)
> @@ -1826,10 +1825,6 @@ int vfio_pci_core_register_device(struct
> vfio_pci_core_device *vdev)
>  		return -EBUSY;
>  	}
>=20
> -	group =3D vfio_iommu_group_get(&pdev->dev);
> -	if (!group)
> -		return -EINVAL;
> -
>  	if (pci_is_root_bus(pdev->bus)) {
>  		ret =3D vfio_assign_device_set(&vdev->vdev, vdev);
>  	} else if (!pci_probe_reset_slot(pdev->slot)) {
> @@ -1843,10 +1838,10 @@ int vfio_pci_core_register_device(struct
> vfio_pci_core_device *vdev)
>  	}
>=20
>  	if (ret)
> -		goto out_group_put;
> +		return ret;
>  	ret =3D vfio_pci_vf_init(vdev);
>  	if (ret)
> -		goto out_group_put;
> +		return ret;
>  	ret =3D vfio_pci_vga_init(vdev);
>  	if (ret)
>  		goto out_vf;
> @@ -1877,8 +1872,6 @@ int vfio_pci_core_register_device(struct
> vfio_pci_core_device *vdev)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  out_vf:
>  	vfio_pci_vf_uninit(vdev);
> -out_group_put:
> -	vfio_iommu_group_put(group, &pdev->dev);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_register_device);
> @@ -1894,8 +1887,6 @@ void vfio_pci_core_unregister_device(struct
> vfio_pci_core_device *vdev)
>  	vfio_pci_vf_uninit(vdev);
>  	vfio_pci_vga_uninit(vdev);
>=20
> -	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
> -
>  	if (!disable_idle_d3)
>  		vfio_pci_set_power_state(vdev, PCI_D0);
>  }
> diff --git a/drivers/vfio/platform/vfio_platform_common.c
> b/drivers/vfio/platform/vfio_platform_common.c
> index 6af7ce7d619c25..256f55b84e70a0 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -642,7 +642,6 @@ static int vfio_platform_of_probe(struct
> vfio_platform_device *vdev,
>  int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>  			       struct device *dev)
>  {
> -	struct iommu_group *group;
>  	int ret;
>=20
>  	vfio_init_group_dev(&vdev->vdev, dev, &vfio_platform_ops);
> @@ -663,24 +662,15 @@ int vfio_platform_probe_common(struct
> vfio_platform_device *vdev,
>  		goto out_uninit;
>  	}
>=20
> -	group =3D vfio_iommu_group_get(dev);
> -	if (!group) {
> -		dev_err(dev, "No IOMMU group for device %s\n", vdev-
> >name);
> -		ret =3D -EINVAL;
> -		goto put_reset;
> -	}
> -
>  	ret =3D vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
> -		goto put_iommu;
> +		goto put_reset;
>=20
>  	mutex_init(&vdev->igate);
>=20
>  	pm_runtime_enable(dev);
>  	return 0;
>=20
> -put_iommu:
> -	vfio_iommu_group_put(group, dev);
>  put_reset:
>  	vfio_platform_put_reset(vdev);
>  out_uninit:
> @@ -696,7 +686,6 @@ void vfio_platform_remove_common(struct
> vfio_platform_device *vdev)
>  	pm_runtime_disable(vdev->device);
>  	vfio_platform_put_reset(vdev);
>  	vfio_uninit_group_dev(&vdev->vdev);
> -	vfio_iommu_group_put(vdev->vdev.dev->iommu_group, vdev-
> >vdev.dev);
>  }
>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 3c034fe14ccb03..5bd520f0dc6107 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -169,15 +169,7 @@ static void vfio_release_device_set(struct
> vfio_device *device)
>  	xa_unlock(&vfio_device_set_xa);
>  }
>=20
> -/*
> - * vfio_iommu_group_{get,put} are only intended for VFIO bus driver prob=
e
> - * and remove functions, any use cases other than acquiring the first
> - * reference for the purpose of calling vfio_register_group_dev() or
> removing
> - * that symmetric reference after vfio_unregister_group_dev() should use
> the raw
> - * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put=
()
> - * removes the device from the dummy group and cannot be nested.
> - */
> -struct iommu_group *vfio_iommu_group_get(struct device *dev)
> +static struct iommu_group *vfio_iommu_group_get(struct device *dev)
>  {
>  	struct iommu_group *group;
>  	int __maybe_unused ret;
> @@ -220,9 +212,8 @@ struct iommu_group *vfio_iommu_group_get(struct
> device *dev)
>=20
>  	return group;
>  }
> -EXPORT_SYMBOL_GPL(vfio_iommu_group_get);
>=20
> -void vfio_iommu_group_put(struct iommu_group *group, struct device
> *dev)
> +static void vfio_iommu_group_put(struct iommu_group *group, struct
> device *dev)
>  {
>  #ifdef CONFIG_VFIO_NOIOMMU
>  	if (iommu_group_get_iommudata(group) =3D=3D &noiommu)
> @@ -231,7 +222,6 @@ void vfio_iommu_group_put(struct iommu_group
> *group, struct device *dev)
>=20
>  	iommu_group_put(group);
>  }
> -EXPORT_SYMBOL_GPL(vfio_iommu_group_put);
>=20
>  #ifdef CONFIG_VFIO_NOIOMMU
>  static void *vfio_noiommu_open(unsigned long arg)
> @@ -841,7 +831,7 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  	if (!device->dev_set)
>  		vfio_assign_device_set(device, device);
>=20
> -	iommu_group =3D iommu_group_get(device->dev);
> +	iommu_group =3D vfio_iommu_group_get(device->dev);
>  	if (!iommu_group)
>  		return -EINVAL;
>=20
> @@ -849,7 +839,7 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  	if (!group) {
>  		group =3D vfio_create_group(iommu_group);
>  		if (IS_ERR(group)) {
> -			iommu_group_put(iommu_group);
> +			vfio_iommu_group_put(iommu_group, device->dev);
>  			return PTR_ERR(group);
>  		}
>  	} else {
> @@ -857,7 +847,7 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  		 * A found vfio_group already holds a reference to the
>  		 * iommu_group.  A created vfio_group keeps the reference.
>  		 */
> -		iommu_group_put(iommu_group);
> +		vfio_iommu_group_put(iommu_group, device->dev);
>  	}
>=20
>  	existing_device =3D vfio_group_get_device(group, device->dev);
> @@ -865,7 +855,7 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  		dev_WARN(device->dev, "Device already exists on
> group %d\n",
>  			 iommu_group_id(iommu_group));
>  		vfio_device_put(existing_device);
> -		vfio_group_put(group);
> +		vfio_iommu_group_put(iommu_group, device->dev);

semantics change? the removed line is about vfio_group instead of
iommu_group.

>  		return -EBUSY;
>  	}
>=20
> @@ -1010,8 +1000,7 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  	if (list_empty(&group->device_list))
>  		wait_event(group->container_q, !group->container);
>=20
> -	/* Matches the get in vfio_register_group_dev() */
> -	vfio_group_put(group);
> +	vfio_iommu_group_put(group->iommu_group, device->dev);

ditto

>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>=20
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b53a9557884ada..f7083c2fd0d099 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -71,9 +71,6 @@ struct vfio_device_ops {
>  	int	(*match)(struct vfio_device *vdev, char *buf);
>  };
>=20
> -extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
> -extern void vfio_iommu_group_put(struct iommu_group *group, struct
> device *dev);
> -
>  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
>  			 const struct vfio_device_ops *ops);
>  void vfio_uninit_group_dev(struct vfio_device *device);
> --
> 2.30.2

