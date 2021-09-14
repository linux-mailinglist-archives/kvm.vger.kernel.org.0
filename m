Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD17C40A384
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 04:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbhINCYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 22:24:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:15712 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhINCYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 22:24:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="221888998"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="221888998"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 19:23:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="507641836"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 13 Sep 2021 19:23:12 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 19:23:12 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 19:23:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 13 Sep 2021 19:23:11 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 13 Sep 2021 19:23:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yl4JdXM55vC950k6h0IF8P9usKPMkjApn163OmwMXqX2Lr/8rzmAkbXsLFLSq+vOONZ8Wdd9Ko7YdMtYe+XEeXrtbT3oXDmpcUhUJB4ZY54TMEHvRqIrmgQHF1rRnfRLedz/C8ZjfIfqs6Jfmx68Ze/o1XfxHMt3nkqekKI1JUq8H9Q+2RiUuE5on3J/h5H0pnBPpS02moL6EwtKFjFMkW4gNP+dnqV7fUSJHCwAa9Pod5Fp59f76JYJJ0ti+ozPnkq15Q/+9KEDrlSGFqCET/DuyudoZD/DKzJj8VkbXPCPvfQ1If3cx5KcaTTxtXfgNjsdn+WLCzDPxnxoWR93AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=B7x0c2cPnnwZg1HQ1GTL4eff8MwdUoRPGb2a1sPPuJ0=;
 b=O2plk/k/Ll5xKcGGEI+D9DtbKPEYC4QUS5YWOre42mZQ0xrMMu+8bWipVCZN44r5rY9Dt2uhzNhbb1VASDK5svNXPP34wDBx9JH89TiWPYW1OvcX1JAwrd0B4e9VTI9a+asp8jNDp6TYs0Nu32WF28kEfI0WuXlcxgxO41kxaF43pzncjUuwn6LTqscxAXRXpDN8pM+mjS5ERvWojwWk3Jig1BvBHDhtjbO9QMi1xDYzRPCH5HAQ4i65mHBAtg4zKeVb81JNW3AVIthDVt9ohgj8YvOQlcz8MqVq96nlOdqnJF7ZTs8E5HfX3WoD6A/QqhJvoPpAXtbK16fi1fakKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7x0c2cPnnwZg1HQ1GTL4eff8MwdUoRPGb2a1sPPuJ0=;
 b=oQgmifwUzQ4XRX76cfyE/Efuk/CnpkCfstLJ91LqwPxA+/ONVJfv7na48w5pdrB+0TRY5U4LwgRsE4WmuG+EseKFvim4vZuIAF5pNkXt4RuiorEqoZh1zIFNe3im0rVXjzRh3nTP8Ew1SHCjKqFveqnecjhygPzpoa7aphwU2zs=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2147.namprd11.prod.outlook.com (2603:10b6:405:57::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 02:23:06 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 02:23:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Thread-Topic: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Thread-Index: AQHXqHBt42JHIRb5qECOMO4Ff4GViauiybjw
Date:   Tue, 14 Sep 2021 02:23:06 +0000
Message-ID: <BN9PR11MB54338BF12E425FBC335D320E8CDA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-8-hch@lst.de>
In-Reply-To: <20210913071606.2966-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bda9bfd1-bab4-4d13-ddce-08d9772696a7
x-ms-traffictypediagnostic: BN6PR1101MB2147:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB21478DF9BAB959D6667BDEB28CDA9@BN6PR1101MB2147.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gZtkW86L8hhWSvEBBdEE8BJpGy2NMHZj867gFXXa+vANIUdY0A3nqxEb9R/xNvtqO0Lr8bkw7ltNwzhFTKbBzjMwAqevcxdpqln7KPxkZJ8Ft1cAnPq6ATn7brX0DT6mUsWWlmyyUfvCbB4yY2PCQqN6TpTeR7zTKo0645Y/gzY+eyVT6SS7Bj2wcZm8wt3KfxTmpGZ0uCZJnrzSp182pudqkqqlFkF1Vzs/hLRN5uXuzwrnAIiSMZhrO1bj95GxYnLE0Ey8tGWgH1PksKHFd+PUvOGuTttP+PzO/IBa2WYH/7LbPVde0y0MtlWo2UC1QSvaUU3YdQA189/p6fqz4SVKqyEfqT/PAc0O5cKIwHfCdN/+TvquteujA3miuLABF4BJzdwcDeKHWlEj8mNHckMppIzGv6QMu1ZN6JrCpWH7KBP3nR14cQxyXai7eogvIdj6B7Ful4koczzSfUrXdUGQYPPdI+jFFi33pnK39C9yVpfx4ZjDi1WaJ6JXF5XUnsscnLK+KX+obNb6NxYDYWrfzI5gWsJRLJC6FzWNhv8P0QpMtUHjBIjTf+zvt4HcRIjAsgaji+I7A1XegAaovBQduy9um470RrfeXtMNeeJI+NbUUznPziDPv/lBqO6LHavj+g+HlKV1mwUp0kssyRLKLjfj9ujx+ttEma9JOlQ2+0IAP/U6ZiNlC/D9mSokicJitVt8JzQQDKO3z855OA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(86362001)(71200400001)(66446008)(110136005)(38070700005)(6506007)(33656002)(76116006)(55016002)(478600001)(54906003)(26005)(186003)(316002)(64756008)(66556008)(66476007)(8936002)(8676002)(5660300002)(38100700002)(7696005)(122000001)(52536014)(66946007)(4326008)(30864003)(83380400001)(9686003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vwr5UGnkA5b+D7Oy8DK+B8hUqjMqGhIwamqkH0dcrT0yyymfo3pt5cSrvfGn?=
 =?us-ascii?Q?SFNv+6ELUFM60hYGuexgPGtdoXO+n+rYCtsnmrNKWN1Pb+lXdck6sKHsxEnJ?=
 =?us-ascii?Q?G8WycFHPPyaOBdJU8Qo2xwfV3eVf6QrIAiDO2BECqvOIlayec6N22nfmyUZG?=
 =?us-ascii?Q?1YOvqfUmx7wsoUcLTd76ja1TJ5sfB3uuu34dTOcG/I11ero5sjH81wO3Bbvl?=
 =?us-ascii?Q?biZTyglGNTzoO7NMueDzZNX+mFx36ssLtHNr73F0BcSWQJZam+hac5MI8+7M?=
 =?us-ascii?Q?7xPCKfhiOp5TbBZW6YPw15L3PuinM/MnVbY1Abx1zIQHDPY3+mM1Zz+3hV9a?=
 =?us-ascii?Q?D4LnTRGx/xgLvvVSBJBhqwBABnIhbqJpl1cibW85AKBKQq03R5EAOEq/sAFc?=
 =?us-ascii?Q?MuMFJjf4WjrI94j22D53cNrWJ2oD6Jvi9lY7boecdlmxTYF0KiaHUDsvMCCw?=
 =?us-ascii?Q?EVwh3fLzXiyL2zZnQ17QY/r1hBwOShZ2hQWVTziwyApq5nGqNRhI7YLk3Pg7?=
 =?us-ascii?Q?dQhHBDAMuNy2Av387fd8e45VCggelftWZy0Il6KAXAuWTr/kTAGnSnp5Osti?=
 =?us-ascii?Q?wtYQ1vfx7Y9KIoOF4wpXlTX1yJdr8Ssz8l1TurkWuhDHTqnmGzJJmeVJvsDW?=
 =?us-ascii?Q?1/bN3m+7ofIda8KPSYnL91yCzFWsiQdNJR8+rnM1HUB9aZ/FXxbuhodqZ4uE?=
 =?us-ascii?Q?YWBw/gH0Ckvw6Q+8bHwCntpEcOeAUZpV+Y8EwJnqN8OYltEiU6yseSOF76TA?=
 =?us-ascii?Q?fWTh/eUs2maq+DMEsxFXhfp4J+ELcneH5rWM2h0o5ZepBLytGsL6Ke8tmBat?=
 =?us-ascii?Q?pWxph3JY0qIKTauiNPvBxd2G/9elPJ0s9pJnVgyUR8cbpKL8us2Mkw3U47Cz?=
 =?us-ascii?Q?TuubwAbAoSsjKFrm9WBjz2ZLnVREl2J5cXLObFNBfOrIxt96EDBkGUaprHPh?=
 =?us-ascii?Q?X1FwvUlQPltVSRA6LMQG5WHNNWtvSxhghR07bOEhv/vEhZUP7Mxv5F7BJO8N?=
 =?us-ascii?Q?YCdF7p2K4lp2yADL3nJejzUT3H5FP2uADO27XTZgTkEoxpA3RlRQj2TUkR8F?=
 =?us-ascii?Q?DwcUjuzHNUoHOxJ1/DOJfr1vYCEHTOQIrbvcNVfH/Ui/US4rr7AXD9gWgs6H?=
 =?us-ascii?Q?4EGtiFUamu6Fc5ewi8M3ae4XdaK2iLdMqMSJwkZc54lEidrxrSXYwwV3evvx?=
 =?us-ascii?Q?KwKcBVujhMEeB6q99IwUvVoVtN2Ky4qBqGhbQW5uyWlfOXxgb09vyGG4zK56?=
 =?us-ascii?Q?bZHcVty4mp4V+kKZYVVEfM5WPyM1GMMqOlmHa8gRXSRqpRW2dmqvXCwQlNbB?=
 =?us-ascii?Q?OmjrIXErtmwYghHwDTsnakQa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bda9bfd1-bab4-4d13-ddce-08d9772696a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 02:23:06.8487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J96H4bTp0vWY+5pEn0fgeZjlMN78hU7YBTuW+IXFK9tCMsO4R84p/+//iLHi5fH+JOkyzcftq/SYI7zN28gtVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2147
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig <hch@lst.de>
> Sent: Monday, September 13, 2021 3:16 PM
>=20
> Reuse the logic in vfio_noiommu_group_alloc to allocate a fake
> single-device iommu group for mediated devices by factoring out a common
> function, and replacing the noiommu boolean field in struct vfio_group
> with an enum to distinguish the three different kinds of groups.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/s390/crypto/vfio_ap_ops.c |  2 +-
>  drivers/vfio/mdev/mdev_driver.c   | 45 ++-------------
>  drivers/vfio/mdev/vfio_mdev.c     |  2 +-
>  drivers/vfio/vfio.c               | 92 ++++++++++++++++++++++---------
>  include/linux/vfio.h              |  1 +
>  samples/vfio-mdev/mbochs.c        |  2 +-
>  samples/vfio-mdev/mdpy.c          |  2 +-
>  samples/vfio-mdev/mtty.c          |  2 +-
>  8 files changed, 76 insertions(+), 72 deletions(-)
>=20
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
> b/drivers/s390/crypto/vfio_ap_ops.c
> index 118939a7729a1e..24755d1aedd5b0 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -351,7 +351,7 @@ static int vfio_ap_mdev_probe(struct mdev_device
> *mdev)
>  	list_add(&matrix_mdev->node, &matrix_dev->mdev_list);
>  	mutex_unlock(&matrix_dev->lock);
>=20
> -	ret =3D vfio_register_group_dev(&matrix_mdev->vdev);
> +	ret =3D vfio_register_emulated_iommu_dev(&matrix_mdev->vdev);
>  	if (ret)
>  		goto err_list;
>  	dev_set_drvdata(&mdev->dev, matrix_mdev);
> diff --git a/drivers/vfio/mdev/mdev_driver.c
> b/drivers/vfio/mdev/mdev_driver.c
> index e2cb1ff56f6c9b..7927ed4f1711f2 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -13,60 +13,23 @@
>=20
>  #include "mdev_private.h"
>=20
> -static int mdev_attach_iommu(struct mdev_device *mdev)
> -{
> -	int ret;
> -	struct iommu_group *group;
> -
> -	group =3D iommu_group_alloc();
> -	if (IS_ERR(group))
> -		return PTR_ERR(group);
> -
> -	ret =3D iommu_group_add_device(group, &mdev->dev);
> -	if (!ret)
> -		dev_info(&mdev->dev, "MDEV: group_id =3D %d\n",
> -			 iommu_group_id(group));
> -
> -	iommu_group_put(group);
> -	return ret;
> -}
> -
> -static void mdev_detach_iommu(struct mdev_device *mdev)
> -{
> -	iommu_group_remove_device(&mdev->dev);
> -	dev_info(&mdev->dev, "MDEV: detaching iommu\n");
> -}
> -
>  static int mdev_probe(struct device *dev)
>  {
>  	struct mdev_driver *drv =3D
>  		container_of(dev->driver, struct mdev_driver, driver);
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
> -	int ret;
>=20
> -	ret =3D mdev_attach_iommu(mdev);
> -	if (ret)
> -		return ret;
> -
> -	if (drv->probe) {
> -		ret =3D drv->probe(mdev);
> -		if (ret)
> -			mdev_detach_iommu(mdev);
> -	}
> -
> -	return ret;
> +	if (!drv->probe)
> +		return 0;
> +	return drv->probe(to_mdev_device(dev));
>  }
>=20
>  static void mdev_remove(struct device *dev)
>  {
>  	struct mdev_driver *drv =3D
>  		container_of(dev->driver, struct mdev_driver, driver);
> -	struct mdev_device *mdev =3D to_mdev_device(dev);
>=20
>  	if (drv->remove)
> -		drv->remove(mdev);
> -
> -	mdev_detach_iommu(mdev);
> +		drv->remove(to_mdev_device(dev));
>  }
>=20
>  static int mdev_match(struct device *dev, struct device_driver *drv)
> diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.=
c
> index 7a9883048216e7..a90e24b0c851d3 100644
> --- a/drivers/vfio/mdev/vfio_mdev.c
> +++ b/drivers/vfio/mdev/vfio_mdev.c
> @@ -119,7 +119,7 @@ static int vfio_mdev_probe(struct mdev_device
> *mdev)
>  		return -ENOMEM;
>=20
>  	vfio_init_group_dev(vdev, &mdev->dev, &vfio_mdev_dev_ops);
> -	ret =3D vfio_register_group_dev(vdev);
> +	ret =3D vfio_register_emulated_iommu_dev(vdev);
>  	if (ret)
>  		goto out_uninit;
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 23eaebd2e28cd9..2508c8c3984091 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -67,6 +67,30 @@ struct vfio_unbound_dev {
>  	struct list_head		unbound_next;
>  };
>=20
> +enum vfio_group_type {
> +	/*
> +	 * Physical device with IOMMU backing.
> +	 */
> +	VFIO_IOMMU,
> +
> +	/*
> +	 * Virtual device without IOMMU backing. The VFIO core fakes up an
> +	 * iommu_group as the iommu_group sysfs interface is part of the
> +	 * userspace ABI.  The user of these devices must not be able to
> +	 * directly trigger unmediated DMA.
> +	 */
> +	VFIO_EMULATED_IOMMU,
> +
> +	/*
> +	 * Physical device without IOMMU backing. The VFIO core fakes up an
> +	 * iommu_group as the iommu_group sysfs interface is part of the
> +	 * userspace ABI.  Users can trigger unmediated DMA by the device,
> +	 * usage is highly dangerous, requires an explicit opt-in and will
> +	 * taint the kernel.
> +	 */
> +	VFIO_NO_IOMMU,
> +};
> +
>  struct vfio_group {
>  	struct kref			kref;
>  	int				minor;
> @@ -83,7 +107,7 @@ struct vfio_group {
>  	struct mutex			unbound_lock;
>  	atomic_t			opened;
>  	wait_queue_head_t		container_q;
> -	bool				noiommu;
> +	enum vfio_group_type		type;
>  	unsigned int			dev_counter;
>  	struct kvm			*kvm;
>  	struct blocking_notifier_head	notifier;
> @@ -336,7 +360,7 @@ static void vfio_group_unlock_and_free(struct
> vfio_group *group)
>   * Group objects - create, release, get, put, search
>   */
>  static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
> -		bool noiommu)
> +		enum vfio_group_type type)
>  {
>  	struct vfio_group *group, *tmp;
>  	struct device *dev;
> @@ -355,7 +379,7 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	atomic_set(&group->opened, 0);
>  	init_waitqueue_head(&group->container_q);
>  	group->iommu_group =3D iommu_group;
> -	group->noiommu =3D noiommu;
> +	group->type =3D type;
>  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
>=20
>  	group->nb.notifier_call =3D vfio_iommu_group_notifier;
> @@ -391,8 +415,8 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	}
>=20
>  	dev =3D device_create(vfio.class, NULL,
> -			    MKDEV(MAJOR(vfio.group_devt), minor),
> -			    group, "%s%d", group->noiommu ? "noiommu-" :
> "",
> +			    MKDEV(MAJOR(vfio.group_devt), minor), group,
> "%s%d",
> +			    group->type =3D=3D VFIO_NO_IOMMU ? "noiommu-" :
> "",
>  			    iommu_group_id(iommu_group));
>  	if (IS_ERR(dev)) {
>  		vfio_free_group_minor(minor);
> @@ -778,8 +802,8 @@ void vfio_uninit_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
>=20
> -#ifdef CONFIG_VFIO_NOIOMMU
> -static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev)
> +static struct vfio_group *vfio_noiommu_group_alloc(struct device *dev,
> +		enum vfio_group_type type)
>  {
>  	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
> @@ -794,7 +818,7 @@ static struct vfio_group
> *vfio_noiommu_group_alloc(struct device *dev)
>  	if (ret)
>  		goto out_put_group;
>=20
> -	group =3D vfio_create_group(iommu_group, true);
> +	group =3D vfio_create_group(iommu_group, type);
>  	if (IS_ERR(group)) {
>  		ret =3D PTR_ERR(group);
>  		goto out_remove_device;
> @@ -808,7 +832,6 @@ static struct vfio_group
> *vfio_noiommu_group_alloc(struct device *dev)
>  	iommu_group_put(iommu_group);
>  	return ERR_PTR(ret);
>  }
> -#endif
>=20
>  static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  {
> @@ -824,7 +847,7 @@ static struct vfio_group
> *vfio_group_find_or_alloc(struct device *dev)
>  		 * bus.  Taint the kernel because we're about to give a DMA
>  		 * capable device to a user without IOMMU protection.
>  		 */
> -		group =3D vfio_noiommu_group_alloc(dev);
> +		group =3D vfio_noiommu_group_alloc(dev, VFIO_NO_IOMMU);
>  		if (!IS_ERR(group)) {
>  			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
>  			dev_warn(dev, "Adding kernel taint for vfio-
> noiommu group on device\n");
> @@ -841,7 +864,7 @@ static struct vfio_group
> *vfio_group_find_or_alloc(struct device *dev)
>  		goto out_put;
>=20
>  	/* a newly created vfio_group keeps the reference. */
> -	group =3D vfio_create_group(iommu_group, false);
> +	group =3D vfio_create_group(iommu_group, VFIO_IOMMU);
>  	if (IS_ERR(group))
>  		goto out_put;
>  	return group;
> @@ -851,10 +874,13 @@ static struct vfio_group
> *vfio_group_find_or_alloc(struct device *dev)
>  	return group;
>  }
>=20
> -int vfio_register_group_dev(struct vfio_device *device)
> +static int __vfio_register_dev(struct vfio_device *device,
> +		struct vfio_group *group)
>  {
>  	struct vfio_device *existing_device;
> -	struct vfio_group *group;
> +
> +	if (IS_ERR(group))
> +		return PTR_ERR(group);
>=20
>  	/*
>  	 * If the driver doesn't specify a set then the device is added to a
> @@ -863,16 +889,13 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>  	if (!device->dev_set)
>  		vfio_assign_device_set(device, device);
>=20
> -	group =3D vfio_group_find_or_alloc(device->dev);
> -	if (IS_ERR(group))
> -		return PTR_ERR(group);
> -
>  	existing_device =3D vfio_group_get_device(group, device->dev);
>  	if (existing_device) {
>  		dev_WARN(device->dev, "Device already exists on
> group %d\n",
>  			 iommu_group_id(group->iommu_group));
>  		vfio_device_put(existing_device);
> -		if (group->noiommu)
> +		if (group->type =3D=3D VFIO_NO_IOMMU ||
> +		    group->type =3D=3D VFIO_EMULATED_IOMMU)
>  			iommu_group_remove_device(device->dev);
>  		vfio_group_put(group);
>  		return -EBUSY;
> @@ -891,8 +914,25 @@ int vfio_register_group_dev(struct vfio_device
> *device)
>=20
>  	return 0;
>  }
> +
> +int vfio_register_group_dev(struct vfio_device *device)
> +{
> +	return __vfio_register_dev(device,
> +		vfio_group_find_or_alloc(device->dev));
> +}
>  EXPORT_SYMBOL_GPL(vfio_register_group_dev);
>=20
> +/*
> + * Register a virtual device without IOMMU backing.  The user of this
> + * device must not be able to directly trigger unmediated DMA.
> + */
> +int vfio_register_emulated_iommu_dev(struct vfio_device *device)
> +{
> +	return __vfio_register_dev(device,
> +		vfio_noiommu_group_alloc(device->dev,
> VFIO_EMULATED_IOMMU));
> +}
> +EXPORT_SYMBOL_GPL(vfio_register_emulated_iommu_dev);
> +
>  /**
>   * Get a reference to the vfio_device for a device.  Even if the
>   * caller thinks they own the device, they could be racing with a
> @@ -1019,7 +1059,7 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  	if (list_empty(&group->device_list))
>  		wait_event(group->container_q, !group->container);
>=20
> -	if (group->noiommu)
> +	if (group->type =3D=3D VFIO_NO_IOMMU || group->type =3D=3D
> VFIO_EMULATED_IOMMU)
>  		iommu_group_remove_device(device->dev);
>=20
>  	/* Matches the get in vfio_register_group_dev() */
> @@ -1368,7 +1408,7 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>  	if (atomic_read(&group->container_users))
>  		return -EINVAL;
>=20
> -	if (group->noiommu && !capable(CAP_SYS_RAWIO))
> +	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
>  		return -EPERM;
>=20
>  	f =3D fdget(container_fd);
> @@ -1388,7 +1428,7 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>=20
>  	/* Real groups and fake groups cannot mix */
>  	if (!list_empty(&container->group_list) &&
> -	    container->noiommu !=3D group->noiommu) {
> +	    container->noiommu !=3D (group->type =3D=3D VFIO_NO_IOMMU)) {
>  		ret =3D -EPERM;
>  		goto unlock_out;
>  	}
> @@ -1402,7 +1442,7 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>  	}
>=20
>  	group->container =3D container;
> -	container->noiommu =3D group->noiommu;
> +	container->noiommu =3D (group->type =3D=3D VFIO_NO_IOMMU);
>  	list_add(&group->container_next, &container->group_list);
>=20
>  	/* Get a reference on the container and mark a user within the group
> */
> @@ -1426,7 +1466,7 @@ static int vfio_group_add_container_user(struct
> vfio_group *group)
>  	if (!atomic_inc_not_zero(&group->container_users))
>  		return -EINVAL;
>=20
> -	if (group->noiommu) {
> +	if (group->type =3D=3D VFIO_NO_IOMMU) {
>  		atomic_dec(&group->container_users);
>  		return -EPERM;
>  	}
> @@ -1451,7 +1491,7 @@ static int vfio_group_get_device_fd(struct
> vfio_group *group, char *buf)
>  	    !group->container->iommu_driver || !vfio_group_viable(group))
>  		return -EINVAL;
>=20
> -	if (group->noiommu && !capable(CAP_SYS_RAWIO))
> +	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
>  		return -EPERM;
>=20
>  	device =3D vfio_device_get_from_name(group, buf);
> @@ -1498,7 +1538,7 @@ static int vfio_group_get_device_fd(struct
> vfio_group *group, char *buf)
>=20
>  	fd_install(fdno, filep);
>=20
> -	if (group->noiommu)
> +	if (group->type =3D=3D VFIO_NO_IOMMU)
>  		dev_warn(device->dev, "vfio-noiommu device opened by
> user "
>  			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>  	return fdno;
> @@ -1594,7 +1634,7 @@ static int vfio_group_fops_open(struct inode
> *inode, struct file *filep)
>  	if (!group)
>  		return -ENODEV;
>=20
> -	if (group->noiommu && !capable(CAP_SYS_RAWIO)) {
> +	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> {
>  		vfio_group_put(group);
>  		return -EPERM;
>  	}
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index f7083c2fd0d099..bbe29300862649 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -75,6 +75,7 @@ void vfio_init_group_dev(struct vfio_device *device,
> struct device *dev,
>  			 const struct vfio_device_ops *ops);
>  void vfio_uninit_group_dev(struct vfio_device *device);
>  int vfio_register_group_dev(struct vfio_device *device);
> +int vfio_register_emulated_iommu_dev(struct vfio_device *device);
>  void vfio_unregister_group_dev(struct vfio_device *device);
>  extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
>  extern void vfio_device_put(struct vfio_device *device);
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index c313ab4d1f4e4e..cd41bec5fdeb39 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -553,7 +553,7 @@ static int mbochs_probe(struct mdev_device *mdev)
>  	mbochs_create_config_space(mdev_state);
>  	mbochs_reset(mdev_state);
>=20
> -	ret =3D vfio_register_group_dev(&mdev_state->vdev);
> +	ret =3D vfio_register_emulated_iommu_dev(&mdev_state->vdev);
>  	if (ret)
>  		goto err_mem;
>  	dev_set_drvdata(&mdev->dev, mdev_state);
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 8d1a80a0722aa9..fe5d43e797b6d3 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -258,7 +258,7 @@ static int mdpy_probe(struct mdev_device *mdev)
>=20
>  	mdpy_count++;
>=20
> -	ret =3D vfio_register_group_dev(&mdev_state->vdev);
> +	ret =3D vfio_register_emulated_iommu_dev(&mdev_state->vdev);
>  	if (ret)
>  		goto err_mem;
>  	dev_set_drvdata(&mdev->dev, mdev_state);
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 5983cdb16e3d1d..a0e1a469bd47af 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -741,7 +741,7 @@ static int mtty_probe(struct mdev_device *mdev)
>=20
>  	mtty_create_config_space(mdev_state);
>=20
> -	ret =3D vfio_register_group_dev(&mdev_state->vdev);
> +	ret =3D vfio_register_emulated_iommu_dev(&mdev_state->vdev);
>  	if (ret)
>  		goto err_vconfig;
>  	dev_set_drvdata(&mdev->dev, mdev_state);
> --
> 2.30.2

