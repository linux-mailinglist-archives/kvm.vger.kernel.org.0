Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F060E338DC9
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 13:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhCLMy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 07:54:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:23655 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhCLMxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 07:53:55 -0500
IronPort-SDR: j8wgcGw1pC/GIRi+Pw8WEByiwsHq6sNEoR/61HOquARmvMBtKeaQ+zuPZetBG4jnUlmvRp2Cyq
 P0irVCGXPx1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="273870591"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="273870591"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 04:53:54 -0800
IronPort-SDR: HjTeGUTFx6QLSzaTWf15AYfpaPFGbNXQvDWg6c9laI3Fpy40QMXpL/xAa6lJQnLJyaX5ohTKpZ
 n7Wa/ojlVyuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="377700272"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga007.fm.intel.com with ESMTP; 12 Mar 2021 04:53:54 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 04:53:54 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 04:53:54 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 04:53:53 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 04:53:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVd5UA6q3xGWn7PMPNLTvIRvCNCNy3dirvrnjC+Z77cR6CqkIBmOk0X5q9XJnBatNLPV/hECSRqR62qBEBj0UZD2oqLSsB67uGKE6xmF+LEo3Px5olbqXszE+/D9FoO+crcHjYX+Q+K8hdrUdh0krwH01amLswPsvzdklNmG3y+6/v6tKflnNMa7HTtYt/fgOaOd7AbpbQGqIPUqYdayKv+e29no1d+iChZQ3L7vJArLGpc8GG1lxn7Hr0pWvnW/xUKg4Ybz/UPOgIx1rJAwkHtyCIe7rvXtfvxmNsL6QHXrxq+q0XIyM1RDgjeNwvCWVw6793ErDi+dL3u9Ln9Hbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+atiSAUtWTltOG0rNmGW2x1G7mcdYZzUcIJwhDyjLMI=;
 b=Jy8GqbpXb5oWYOGfsTlGNjqFEanvrq0+DpD9yNEfmMHxiMiCY2THLcLCuBe11/HT03t7VXySXaQfA8VHetSU8ewBeynm9LB/wSOnzOmwAD3y1pBkaS9cY5HG2h5T2WAfkGNpwh0oNA3m9Ma6q9thu7N5m/2bRU9gs2I/a9v8F6Emtuz8tdyDD6lkL2jtIGAGkm0sW4qJ12JDJ/qJyqa/uycQbFqNMff1eFS9juKi7JAg1O9z2n/EeNBiygYk93aggqvcXXEsOzzE8ejBsJip5hfCjzL3aaDf+rM4GvPzFGU5DvGPrlxn34a7OmWo2SjCOa8dzrHrY/TYwg6G+UuVug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+atiSAUtWTltOG0rNmGW2x1G7mcdYZzUcIJwhDyjLMI=;
 b=ChxzxH+IjCT42LkgNJZXZIlsJO4MLzGbO5DntzckXe7DMtds//xtVy8QcmGgAyXmhlr2OzW+uk3/PeZvisWet4EJTV2YNgVo05AJ+xA1bsZlnowzPsiKNz0dO2PWAbs4B8wzU3Zl2KYX2Xb2pZhN064fL8uSE3Sy6kLl03mTKzU=
Received: from BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31)
 by BN8PR11MB3698.namprd11.prod.outlook.com (2603:10b6:408:8a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 12:53:19 +0000
Received: from BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d]) by BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d%3]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 12:53:19 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
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
Subject: RE: [PATCH 05/10] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Thread-Topic: [PATCH 05/10] vfio/pci: Use
 vfio_init/register/unregister_group_dev
Thread-Index: AQHXFSzNnBPeZmVVh06KE1FtEQHnR6qAUSew
Date:   Fri, 12 Mar 2021 12:53:18 +0000
Message-ID: <BN6PR11MB4068CC82B20352BF15A9C75EC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <5-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <5-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 639308c1-c364-4efa-12a0-08d8e555cfa8
x-ms-traffictypediagnostic: BN8PR11MB3698:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3698A90A122107501A055D18C36F9@BN8PR11MB3698.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HPWiClC8GhFKqC/Ogb/4OfdMWkGZYTJCxR4qv7gBoNMQ7zwe8a5kqAY1iR3odx8ZjOvO4mf7kshvG1/5OJvgmd00gl67iFXnlXpTuJ9fPDshU33AuTmTVKBKqRuu/miRQfbEldNVKZIT6rEqpuReM/YIy9pBHZd6lU51ANTBe0IuTSBrNaNkaa7HhddxM8HY4Wi/OuRnK/DiSRtoh+LgcjBhBv7AHcmmngxPHIU9k+jDtPkfE1R0POIUEdTswmFf+O/lqdp/YF34Xn3496LinXa4smAhqs0OjewBbbXGPawNMl6RG/quIHlSDwTatVZIKcJ7b4jaxMaK7T4iOKfLcB7i7CEn5Wc/yBDGOLRuNb+38uJEvARUXKVtUt6if7h3Ca8WSmZlWigr5kTtNk/AlVnTj9cAIcwXw9IhLY+xOl3YR2+udpg5vNFy1EGQvpo32MDuaa/UjvfalG89PP+hsnJJlUHpFgkKON5cxvjWmbRiNv7rg7V59cf1XM+zddMUR+c6dJnOJUwpfg/bTVyZQyDuZw66JXXqP416+ezEWoE2O7CWSsZHSlPSlwldiYmJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4068.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(4326008)(66946007)(7696005)(5660300002)(478600001)(76116006)(66476007)(6506007)(8936002)(66556008)(54906003)(52536014)(66446008)(64756008)(110136005)(7416002)(186003)(33656002)(8676002)(26005)(86362001)(71200400001)(316002)(55016002)(9686003)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TBBsuhsIanJ8XheZTvWHsSAL0hcHhu+vtt4Yz+p/uMIg/tQUHSYMoRdqYZ64?=
 =?us-ascii?Q?KYRBH0kCttbJSrng7OPFJiRyLuV+1yHhmL5SBMwlUm1ci7AtDmi9l7L8XVtP?=
 =?us-ascii?Q?I9TikpOkHe4qHrgD0PCH4RTuKNbkFRMje9T5gTZm4naYn3/czQZqyleLX0zI?=
 =?us-ascii?Q?Jy/N+5J2zNU11adyst97j+18bevO4libpQTkT9uL0KiHOadJnCnWt/Bb+YeW?=
 =?us-ascii?Q?FEy0X0CEeWlwy8KVdlXKFw2BTltgn7D0vKQRMazsZIjU5mFtQy2TlR3HLy1S?=
 =?us-ascii?Q?9ip6OrQHBcoJcbhmru1RUrszYDbYsjbIR+yaJWaXhT7ZbCKiVcPzxnYCuKxE?=
 =?us-ascii?Q?RzvYAiggASkeuTK6nXdtYoUuf7oHo/uFQcmH713+1B1gy8PwzUdSp2UM/31B?=
 =?us-ascii?Q?fjT7XAY7f/7ANJAkSRTGqhjcFznaIxNCZcrwngveYIC60ZtXIvRSvTafO3A+?=
 =?us-ascii?Q?/2ekYna3rgjK6iuwn7w7r1jMFMm/rZoD5ENOPSWI1zlRnSTfqY40MBPhnaQU?=
 =?us-ascii?Q?8EtdVhhTBiGTGX4A128S6vgUo+gDEyVwqtZEKkSxzpqHpxPUwwzFSG0Caot6?=
 =?us-ascii?Q?iVgWQfqE153yoZGkqhgW6FTNn6EJnE+TtsAB2I9ciZht7iqT5EKBO/uRjXRB?=
 =?us-ascii?Q?OjXxyBmQfPJ5MTq2i64Bx8g07OLDUmoRBUHAUCEZH3ncucBfbccsRVa9SbP8?=
 =?us-ascii?Q?e3Bn3iGG+VTwaVdbM7dthRer7lK45HD0n84GyOyYGAee7buw8F2sRymR3wL0?=
 =?us-ascii?Q?HfAjfG9rBqK87SczE2M0gVwKv93JuM64gELHk0lOBoks3J+R+pBbeBnhyb3+?=
 =?us-ascii?Q?6/c+K7UVdbxEQ5+wVQMB2Im3E8wIxFGTLChlZcLJRsBzQ/jn3CJ7ciq5bOfq?=
 =?us-ascii?Q?LuJzDhOCVZXyPodDThIa4qCuv8n5LaAGo4gp1hwAiTz7vJqD64qW1ipE3dru?=
 =?us-ascii?Q?+ZqtIIkHDWk4OlhKnb30/+oTCRYS15n4GGiE3MxmibAKoE41XsFBa8zmzK6k?=
 =?us-ascii?Q?gig28T/Y53c+vQczbkTjcHwHchcP2Hqw2EYMewMd4VZrJa3FYTOXKkHW/LVq?=
 =?us-ascii?Q?U+gArNYxRYa9Q7Zy7s3r2MJg2iCjEGkn2HwRgZpSapbFdNK9ajRkh6IQkuXo?=
 =?us-ascii?Q?SfbTFTDeS6Ar0FQwoR5jufKbI2zFOhMcCdgV2AjcO4aP3kOL5UwGDFai+qx6?=
 =?us-ascii?Q?auiq0ZdKMe6Zxgt7hzPCQNP3zzWuiPbaS3b4mCG+WtG43xvgcNvUxqpmnvrk?=
 =?us-ascii?Q?WviTRnXhVH6wRRdUqD8K7WdApvP9v7qoJNeI0EgZ9pc2vwqkKctkrxBUgSNI?=
 =?us-ascii?Q?bNpRjP7K+rgt2xN7A1YY7cMb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4068.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639308c1-c364-4efa-12a0-08d8e555cfa8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 12:53:19.0345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 743VOF//+0dR37SGJgD3vwy2VVK+8nontKtfNwfIJc8YUybN7fGFGSVbjHsdikXfW2exwtToDD/W2O2KmAIFAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3698
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 10, 2021 5:39 AM
>=20
> pci already allocates a struct vfio_pci_device with exactly the same
> lifetime as vfio_device, switch to the new API and embed vfio_device in
> vfio_pci_device.
>=20
> Add a note the probe ordering is racy.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 17 +++++++++++------
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  2 files changed, 12 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578c2..fae573c6f86bdf 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1957,6 +1957,7 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  		goto out_group_put;
>  	}
>=20
> +	vfio_init_group_dev(&vdev->vdev, &pdev->dev, &vfio_pci_ops,
> vdev);
>  	vdev->pdev =3D pdev;
>  	vdev->irq_type =3D VFIO_PCI_NUM_IRQS;
>  	mutex_init(&vdev->igate);
> @@ -1968,7 +1969,12 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  	INIT_LIST_HEAD(&vdev->vma_list);
>  	init_rwsem(&vdev->memory_lock);
>=20
> -	ret =3D vfio_add_group_dev(&pdev->dev, &vfio_pci_ops, vdev);
> +	/*
> +	 * FIXME: vfio_register_group_dev() allows VFIO_GROUP_GET_DEVICE_FD to
> +	 * immediately return the device to userspace, but we haven't finished
> +	 * setting it up yet.
> +	 */

this patch looks good to me.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>

But I have a question on the FIXME comment here. I checked the code below.
Even after vfio_register_group_dev(), userspace is not able to get DEVICE_F=
D
until the group has been added to a container. So perhaps you can give more
details behind this FIXME.

static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
{
        struct vfio_device *device;
        struct file *filep;
        int ret;

        if (0 =3D=3D atomic_read(&group->container_users) ||
            !group->container->iommu_driver || !vfio_group_viable(group))
                return -EINVAL;

...
}

Regards,
Yi Liu

> +	ret =3D vfio_register_group_dev(&vdev->vdev);
>  	if (ret)
>  		goto out_free;
>=20
> @@ -2014,6 +2020,7 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  		vfio_pci_set_power_state(vdev, PCI_D3hot);
>  	}
>=20
> +	dev_set_drvdata(&pdev->dev, vdev);
>  	return ret;
>=20
>  out_vf_token:
> @@ -2021,7 +2028,7 @@ static int vfio_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>  out_reflck:
>  	vfio_pci_reflck_put(vdev->reflck);
>  out_del_group_dev:
> -	vfio_del_group_dev(&pdev->dev);
> +	vfio_unregister_group_dev(&vdev->vdev);
>  out_free:
>  	kfree(vdev);
>  out_group_put:
> @@ -2031,13 +2038,11 @@ static int vfio_pci_probe(struct pci_dev *pdev,
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
>  	if (vdev->vf_token) {
>  		WARN_ON(vdev->vf_token->users);
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
>  	bool
> 	bar_mmap_supported[PCI_STD_NUM_BARS];
> --
> 2.30.1

