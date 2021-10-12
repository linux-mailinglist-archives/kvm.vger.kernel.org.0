Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ACF429DD8
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 08:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbhJLGjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 02:39:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:38713 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233215AbhJLGjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 02:39:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="250452481"
X-IronPort-AV: E=Sophos;i="5.85,366,1624345200"; 
   d="scan'208";a="250452481"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 23:37:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,366,1624345200"; 
   d="scan'208";a="591617515"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 11 Oct 2021 23:37:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 23:37:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 11 Oct 2021 23:37:43 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 11 Oct 2021 23:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MlxZyX80vfdC64nkt7eHa91uJzCOoZm3GM4461HQAbmocKU7x1B45A4khuN1YsoItI3G11gqlaXbuMAtlI1EMYNHL2Htic9gGOfuI4DYP2OA31i9BA/DT5Btj1xtl1YkezB7JMe4IMOKrPog8EGywKrJ6i0VqYOo873DE8gagrnyf+9XoqGmnnyHcuw+k/56HJ6dXw9Ku4XRfX5c0FrCuo9C/jfDMT7Sq7DTuTGBGjZ4chR9KMLc6I0kSVGGxE8Ieh2ZMk+bXczT4LXdMeWp7CQCHB9pg879I8GzNGCd/Slm3fpP+s/HOdF1ynqpJbqsGB4bbYznGhsgz3UiBR0wXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhCNje0c2ZyKNkIpofWkCmUhHqeVtEMlJNFISmlZXss=;
 b=QCwkKnahf9E+4c5THaxNoy5kXyL2ZuNu2AFQ1/Q/YH8ky1tIq0WhKYPOI1dXMBo+bGROepmYYQXRbHwiRnx6wtU9DJJMBiJnnVEkVjb/UwZPzPe8ZRKzGS0RSXyjBQ7KIUtEOk7pUQuslhTek6Cu1kxXz4xReJcLgeGNNFEG1cVAy0ShSdhGPFb0If2G9obBwS2A0abSMNWi9utVBMTg+EH1hjE1qb7l8j4XZjSZc6o9x+d2siTvxk3A1F/POy6vSJ6VlE5qdJLhGjySNdoTvixUWKTnm+lpU8J4OQdsPq3sS/cSYQM777aBcgHvqtb3VEiV7Bicsc/cCzmXfKYPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhCNje0c2ZyKNkIpofWkCmUhHqeVtEMlJNFISmlZXss=;
 b=xqRv3GmrSFzCvaJcbSSa5kb8nOERfcrNqlZtaadBTnQ9SMhQx6804zcLCkRxz2X//FS4NrzCIvXkAtlSz7hfVppi2R09z9+xTn6Ojmv8/2AHXpC8xoNluNAN8l8gQtowhOPFi7eri3yHsG5vtRMTsczjHbXhphtUjbiPPGbNGsE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1460.namprd11.prod.outlook.com (2603:10b6:405:b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 06:37:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 06:37:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 2/5] vfio: Do not open code the group list search in
 vfio_create_group()
Thread-Topic: [PATCH 2/5] vfio: Do not open code the group list search in
 vfio_create_group()
Thread-Index: AQHXtxtG/mhi+UKy2Eirl6qm+soMg6vO+Qbg
Date:   Tue, 12 Oct 2021 06:37:42 +0000
Message-ID: <BN9PR11MB5433C450FA286BFA7F42AA918CB69@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <2-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <2-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4758af3-9d66-41a0-c9f2-08d98d4acb6d
x-ms-traffictypediagnostic: BN6PR11MB1460:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1460D8F5F84977F383E5BE048CB69@BN6PR11MB1460.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AfYmwlvmrPUycjSPRPNIbLgUOwBy46ceS7zHQiPwHKEAf+cxz+eE4keBiXTEFhq9ivubI8b/wMnq19MdfBqByWOud2mNYVrtkvF3TFt26GQPNpbLL7WgkAqy8HVZvvPSyeKu3ryLaW6sHKXyuN5IhWbQlhK3Pp5Vy2BcR/GmFGGGFOs9ceOYzGrCHQmHp2JnvoGr2g3yJYzGuSifaK+3jVSNh1NVD8kitySmCjx8jeowce6+SXtkoka93DukRxfBqARixB+cA6d7uLOnJD8SeUInf8v1bfOvq8vVkvERPbfK8BTrg+bisFO6OLRtkf90OEuRz7ZLoRCobw+QmETi/ggn/9NOvF77Rz0MOC1wF88WBw/VOscJzoi0UbzagqOGpeplWCX1+kDFy6j1hqLyjO6fJf2cQtHb70Sy//gSSQp1lElDtddMhMfc1GSFNrWgCi+GlS5ycpQsbN96eny3SHY/ETV76KadHFBh3YQOJ8AgKrSdqg1JinWesbz5ifas0w+IhMZe1toV+c8AkTeCLHfBHaXvXiZAiL0GMFr5CJnFkbjDYLPG1yA8gAY6aWFn3iiDmFrjT0QfYx3MZvljbYYMVy8/dtlO0omYE8kfypIVph2JfxmEQj6DGtPT8VcCiBO1fSBfoBFEPybSyRTS8Zwd7By6SoSGk2ZkyCFp40kS87JUR6AfGwIOsnibkQYjoZmZWlSN0iWeYjDscLDHRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(4326008)(38070700005)(7696005)(2906002)(52536014)(186003)(8936002)(107886003)(5660300002)(86362001)(8676002)(122000001)(6506007)(66556008)(66946007)(55016002)(38100700002)(54906003)(71200400001)(66476007)(66446008)(33656002)(83380400001)(110136005)(64756008)(9686003)(76116006)(508600001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UkzAYks10jMghGkSzr6Oiaoy9EN/9qhERSasksiI4uNrQ9nAGqG1DfEur57K?=
 =?us-ascii?Q?LvEcydGB8QK6uSkREpiWQplI7LoH9apTnbTw8iUfYZKvQ6EXKIVd5I/FD/fU?=
 =?us-ascii?Q?u0Bl4eJNpzjdNDHCQ2H1GtgdAw8+GVM1RLCh6Q0lR470RkAj4YrY4OOA50si?=
 =?us-ascii?Q?LPfnB6GtApEuF0LQG1vi6m89UvKVF9xZT5FAFnDbKZzdB0UykB9foHVure3O?=
 =?us-ascii?Q?JTb1qLFOkJXv3AYNPddd0zGtlLb2SDlBmURgnBzpseDtVqkcoxScHhBmi3tK?=
 =?us-ascii?Q?Oo9g/K8sk7OCB1srXr8w8cog2kSPYvNNA+L78OXXQIFxZUqmu0fNx7g8b2DP?=
 =?us-ascii?Q?fmzzVFbTlHd/A3UGW+mrZDtIMWmEZYNrCDKutvmMXeOCg1v/8aF5KX13kXg8?=
 =?us-ascii?Q?SG/wkfyEaR2Bb9jKSqmlNJBhlJaFxzGxY/y9WvOl4Yp4elLFFsPE0LtXMPzp?=
 =?us-ascii?Q?dJqbSTmy1Gz53t88IK0YPl2Psg5pJ0E1cBuE/w2dzXwhH5+a+mugGIcVaMRG?=
 =?us-ascii?Q?QW3PU2NzK2edwzZ1YkXtyxpk2RM0d+R/oFlvlzQMsNGI6Z3bwFpKD0Nm/HqZ?=
 =?us-ascii?Q?TilGpLhnyv62tttxmzNBezyTTZrlFkfOpwAfV0kIw70gkkSeBmQhNOdQl1Z3?=
 =?us-ascii?Q?bubcM44OLM0mWYFS85mkam2CI/3uTKOTJ8FAYp0bGZ9clrBCXjALbW/S+UiX?=
 =?us-ascii?Q?XFlJtQ3jG4MoNLfa6xIavZagwvBgwTE6YdOE+EcXKNH0Zvg/tilfEMYOG71n?=
 =?us-ascii?Q?+ikHbc77CN2T9ZgEiHyDXj/bK4f5dLsgwmOqYp/XOQ+osJuF01Bf8UfGXT2C?=
 =?us-ascii?Q?yDxyNBAyJXUY/eA8C7/2J4buYpDRpnEP2R4MaTzXvk83SCzLjdJdtgQOOANf?=
 =?us-ascii?Q?eA/jEewP2zWxbWqdL8xZJMYIgvO92HStp/9BwE8Koiq/7GhoPpu5nHTH80SQ?=
 =?us-ascii?Q?SCnuUIhOf1kBUR3tSL5kZk8zB6jnaBs3RRIHgVPSda+TVyDna28Aa1ArdvnX?=
 =?us-ascii?Q?Z72JFe8ITs2EXk1cn7VjJRQVlKvuwrbjLWjgBLgXmPIbKULE2vNR/Lqv/D8J?=
 =?us-ascii?Q?l4oerUO0S5UzKaR3x2WyNZS4R3CJB8iYQHzS0JieaRM4jlzJ8Bt5TO/fpMsr?=
 =?us-ascii?Q?G32lk2WzhSl7qiYSigfuzCr8S7CXhqA4lhcpHB4NadbrJwFHN/1txifL7hqg?=
 =?us-ascii?Q?pcYk2tRRd7Jid0a6w2FPWTNOPlkhW+9WE3ZN99opXyb6QzWghNM/+HN/QTm7?=
 =?us-ascii?Q?eHxbO8Yx854FQO0VfsvLVV5EeXQfNwi2g4Jn71N5ID+dF/z7u6OdKcDehXWo?=
 =?us-ascii?Q?6eYgPS3wknJTmIWCaeWUoP/A?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4758af3-9d66-41a0-c9f2-08d98d4acb6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 06:37:42.9343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k/FHvya99zze3rBu/SnC/ftpNHO8Tfe8CQHJcwvUHqMJ6cmNIp0xdXkGc71Dek3GaAAvOFfd36Cx6UVUCXeBZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1460
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, October 2, 2021 7:22 AM
>=20
> Split vfio_group_get_from_iommu() into __vfio_group_get_from_iommu()
> so
> that vfio_create_group() can call it to consolidate this duplicated code.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 55 ++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 32a53cb3598524..1cb12033b02240 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -344,10 +344,35 @@ static void vfio_group_unlock_and_free(struct
> vfio_group *group)
>  /**
>   * Group objects - create, release, get, put, search
>   */
> +static struct vfio_group *
> +__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> +{
> +	struct vfio_group *group;
> +
> +	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> +		if (group->iommu_group =3D=3D iommu_group) {
> +			vfio_group_get(group);
> +			return group;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static struct vfio_group *
> +vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> +{
> +	struct vfio_group *group;
> +
> +	mutex_lock(&vfio.group_lock);
> +	group =3D __vfio_group_get_from_iommu(iommu_group);
> +	mutex_unlock(&vfio.group_lock);
> +	return group;
> +}
> +
>  static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
>  		enum vfio_group_type type)
>  {
> -	struct vfio_group *group, *tmp;
> +	struct vfio_group *group, *existing_group;
>  	struct device *dev;
>  	int ret, minor;
>=20
> @@ -378,12 +403,10 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	mutex_lock(&vfio.group_lock);
>=20
>  	/* Did we race creating this group? */
> -	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
> -		if (tmp->iommu_group =3D=3D iommu_group) {
> -			vfio_group_get(tmp);
> -			vfio_group_unlock_and_free(group);
> -			return tmp;
> -		}
> +	existing_group =3D __vfio_group_get_from_iommu(iommu_group);
> +	if (existing_group) {
> +		vfio_group_unlock_and_free(group);
> +		return existing_group;
>  	}
>=20
>  	minor =3D vfio_alloc_group_minor(group);
> @@ -440,24 +463,6 @@ static void vfio_group_get(struct vfio_group *group)
>  	kref_get(&group->kref);
>  }
>=20
> -static
> -struct vfio_group *vfio_group_get_from_iommu(struct iommu_group
> *iommu_group)
> -{
> -	struct vfio_group *group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> -		if (group->iommu_group =3D=3D iommu_group) {
> -			vfio_group_get(group);
> -			mutex_unlock(&vfio.group_lock);
> -			return group;
> -		}
> -	}
> -	mutex_unlock(&vfio.group_lock);
> -
> -	return NULL;
> -}
> -
>  static struct vfio_group *vfio_group_get_from_minor(int minor)
>  {
>  	struct vfio_group *group;
> --
> 2.33.0

