Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBAB29FD7E
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 06:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgJ3F4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 01:56:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:5947 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJ3Fz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 01:55:59 -0400
IronPort-SDR: 296OBs+nq8l+8GGBq6OV37BPfeIirDW3eSO52prtUgz9iOstY+SIAZWTC2HGkwnl/JQhMqS2Y7
 XFIXEoDMSo2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="155537295"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="155537295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 22:55:58 -0700
IronPort-SDR: AJXmq23mJz5RvhEQ6c+h4TufTspfYQuN4zxcIKDJ+wZbvVg0/GWwHgNYjqdNJG747FoXywKFze
 1bEeTvkqd52Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525792213"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 22:55:58 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Oct 2020 22:55:56 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Oct 2020 22:55:55 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 29 Oct 2020 22:55:55 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 29 Oct 2020 22:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYojaxtvWAphVcKk2PebMy7ZY4ystucPyAtFf3pZTvKoA9gxdi642aOBVPELGgQIh3RPVfS/uIoYY7/aU2xGLT5/8evlCMngfIoiaFrQO85wqFexNDODKRUP9OqEyr1UPQgwbSbICR4bft4xS9QW/xECg6iMa90ome+1IustRc76fUHcuOHV5dFJGvXrKA08Xd6Tf6voZRAB7cVjfsN9M8XALFMnqC5ONwGf5KPvLp3NfAnIwaMv6Hd1Le95V4JWfBKDSG5m9XyJ6aGYGo07K5piqqixpBlQjt4lk8mjFuskintvlZJoj+cKw5UzcGwwyuE54ETE2gC/P7mDdUtIFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVbA02TnATLePQw9CDAcn7TuHKpEdlo/O+nP0VQqdB8=;
 b=iEzPWlX61VfTZ/Ld+1/LHrkwAy7cuJClk4KzIXsqmxodRu+De2s1JD5CVZaHXcUbLGtWshjkDjZHVtTpU4i6NJnI0tZzKd/6bDMmudS9K0oz10GskrstJX1/F9Ve/nGfN5IvEvzaipwy7xjVWxEN3jxnAnK362Wlw3OAkE2Ade1RI2kDjI/XVVVgjcU84bHTgoHew4d0cSBN3L0VfjETh5J3/SCgZS8SlM2t9W2N3GDzh+LdvEttm8TYFM6ylP/M5Ob+Cr6jOrDB/qkfn1QG4yUyGjDg3EPCNL67OKXFy7SOT9nvVPzpdl3EGGWoeXbvg0Y+rMPyDwIejUZ7n8e3pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVbA02TnATLePQw9CDAcn7TuHKpEdlo/O+nP0VQqdB8=;
 b=Pz/uoO8dRIKIMbpzb6Lrk0Fe5MsCn+g9Lwi0Deg1oq5Cwfexqqz75SLLVymF7EhiTOmKyYATuTZ4BDqxHpg/Xz770lXPcSbTxdKGxb3auTwFr7FUuO7x73S4irTssB8aAI8oX25TIE83UNv4An/YKJzIzGWaq6k1zrH5EQnnNl4=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 05:55:54 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::c88f:585f:f117:930b%8]) with mapi id 15.20.3477.034; Fri, 30 Oct 2020
 05:55:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Zeng, Xin" <xin.zeng@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 2/5] iommu: Use bus iommu ops for aux related callback
Thread-Topic: [PATCH v6 2/5] iommu: Use bus iommu ops for aux related callback
Thread-Index: AQHWrnpLcdhjwgiX40SApbaxx6/zZ6mvpLKA
Date:   Fri, 30 Oct 2020 05:55:53 +0000
Message-ID: <MWHPR11MB1645D795F7851F5894CB58D88C150@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20201030045809.957927-1-baolu.lu@linux.intel.com>
 <20201030045809.957927-3-baolu.lu@linux.intel.com>
In-Reply-To: <20201030045809.957927-3-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37a9c63a-a2b0-4583-e931-08d87c9876a9
x-ms-traffictypediagnostic: CO1PR11MB4835:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4835379DD09AAD922395CEAE8C150@CO1PR11MB4835.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NHLTTmZGheoKExgrNjk4CCuo5PXOozyUk2eU/0nkYFhRuNA+saSxtLBZSVMK0YWKkpEF/k/Lj0IxS06OO1CCZOIfPa8YA8zT7GNqa/OAUxPahwfzWZf8b6NtKQ0ZKzia/vDzEs677dhTI60UPPJbP/cz66qUswuMhGyUzfEkVsf4HDJ4I22LLJKDYQD8GdKm1vfAcrNudmjDCLB7/IgjSz6gXcB4CgLy2SLcvySHfCWMT17vj+fakW+CK1//+zdLLy4uarMHGjKRO7ZiGwulX4vrGHN/360vgqoWY8/5YK/3s0St1pQqK61odm/e6fjhuzj71ADKK4Hzks9hmd2FrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(39860400002)(396003)(66476007)(26005)(66446008)(478600001)(71200400001)(5660300002)(55016002)(86362001)(186003)(4326008)(2906002)(316002)(6506007)(8936002)(9686003)(54906003)(33656002)(66946007)(110136005)(76116006)(8676002)(52536014)(83380400001)(7696005)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KLvD1RYs3QFeH+H427anY/5F9YrbafZ+MZnHv37o06YC4fVtxpjEcx2hoO21Iow+mDbYgZAZxm7SCUG9nxLjRnnche8syqHJ0ikgAfIP/Xfe2SMe49O04+luFEFCoFunaEd3mGqfrWDEHO+GfuN8v10GUVaDYyCubiV6n1Gke/LPUKPmxz4E1Fz2kIMZ23+b/2NMFCDql3DNBRugLALie3U25L7bCUSXMEeJAZ+5Bu0AG6avNLXT3BHcraI9LxyGD9Bjik9tTbVt0Y5Y9a0bwie2+i0FBS72R8I6DwzAHLnNd+7iFGtvVQq53pawzoaRUlcph+rOUodP7HvgNmf4O/pYJE21ZwQv9kyCy2c4L3NtZF+D8B25Wse+4ziylgPKG5MXINaIygZdk6RPPgTopXq7nGOpnCB26iOq4VZwH0vK6BW8Qsw0NqNPz37nh9jnxPsz4YlEus+NwkVzc6hxcFYDQZcwESMHglw/zlom5Q85fhMCw3QK9Hx+rDmnYxKVipbFCnsDRUum1QxUZSdQIVMQn1WFvtMbT5/uBSIcAgdUDXD7Xg9qPVyyIUJQS6+fc9TKdHKQIs0th/s2JHhaV8DZQdMZ3JiAJGYD04zjVF+S486zt+kZ5dCwkJvHSiG5NwBB2+0dX3blfHjGJVGoIw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a9c63a-a2b0-4583-e931-08d87c9876a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 05:55:53.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hMjfjf4FVpzD78J3wipNEF2b5oAH8RQDSeb7lgCJz/iJ6dVePjQGFTQgf3MvdxpQtByhnbKFY0wDYgv/DqBRpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4835
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Friday, October 30, 2020 12:58 PM
>=20
> The aux-domain apis were designed for macro driver where the subdevices
> are created and used inside a device driver. Use the device's bus iommu
> ops instead of that in iommu domain for various callbacks.

IIRC there are only two users on these apis. One is VFIO, and the other
is on the ARM side (not checked in yet). Jean, can you help confirm=20
whether ARM-side usage still relies on aux apis even with this change?
If no, possibly they can be removed completely?

Thanks
Kevin

>=20
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/iommu.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 6bbdd959f9f3..17f2686664db 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2913,10 +2913,11 @@
> EXPORT_SYMBOL_GPL(iommu_dev_feature_enabled);
>   */
>  int iommu_aux_attach_device(struct iommu_domain *domain, struct device
> *dev)
>  {
> +	const struct iommu_ops *ops =3D dev->bus->iommu_ops;
>  	int ret =3D -ENODEV;
>=20
> -	if (domain->ops->aux_attach_dev)
> -		ret =3D domain->ops->aux_attach_dev(domain, dev);
> +	if (ops && ops->aux_attach_dev)
> +		ret =3D ops->aux_attach_dev(domain, dev);
>=20
>  	if (!ret)
>  		trace_attach_device_to_domain(dev);
> @@ -2927,8 +2928,10 @@
> EXPORT_SYMBOL_GPL(iommu_aux_attach_device);
>=20
>  void iommu_aux_detach_device(struct iommu_domain *domain, struct
> device *dev)
>  {
> -	if (domain->ops->aux_detach_dev) {
> -		domain->ops->aux_detach_dev(domain, dev);
> +	const struct iommu_ops *ops =3D dev->bus->iommu_ops;
> +
> +	if (ops && ops->aux_detach_dev) {
> +		ops->aux_detach_dev(domain, dev);
>  		trace_detach_device_from_domain(dev);
>  	}
>  }
> @@ -2936,10 +2939,11 @@
> EXPORT_SYMBOL_GPL(iommu_aux_detach_device);
>=20
>  int iommu_aux_get_pasid(struct iommu_domain *domain, struct device
> *dev)
>  {
> +	const struct iommu_ops *ops =3D dev->bus->iommu_ops;
>  	int ret =3D -ENODEV;
>=20
> -	if (domain->ops->aux_get_pasid)
> -		ret =3D domain->ops->aux_get_pasid(domain, dev);
> +	if (ops && ops->aux_get_pasid)
> +		ret =3D ops->aux_get_pasid(domain, dev);
>=20
>  	return ret;
>  }
> --
> 2.25.1

