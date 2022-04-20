Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2004509401
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 01:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349481AbiDTX6G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 19:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbiDTX6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 19:58:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED2510FF1
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 16:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650498916; x=1682034916;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HV/g0+RHThg9zR8IM1AFDf6fCdWzoRwamQuDlMxjo2U=;
  b=GK295pRGFv/QmCuRkgTM9pCBCMz/ErqWDATG2L9vIDWJXfukWhRVXNSo
   XMmezc1WagdFQGt/JKEo54KRjtfBGFThGN33kfNEj/EtSGv4VyFd3Obrh
   mmrxymTIfEdNsNHH0vfxog5051wGNpmVk7dp8WgJ52Rniy9bsZBtHF9Kf
   dlAYWSYyCw+vTuB/48SHSYO33jAlQle+bclMv+oBlBwaLPa1UGtvP1pHY
   L9KZG872CDBxcY+sF5eJFR/j/Q+eY9e2Yq5IB1jD54mmmF3jM7Flt5+U5
   hHdOgkUJFovICO0aJzqoCRtRcFa1aeqApZ0FK3OpCZZd/tDEMKEBZX7OF
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="263943909"
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="263943909"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 16:55:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,277,1643702400"; 
   d="scan'208";a="727718277"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 20 Apr 2022 16:55:16 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:55:15 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 16:55:15 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 20 Apr 2022 16:55:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 20 Apr 2022 16:55:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sniz2QD2pwSD4+eWuv+FUb75Q/MRPa2ERMRvim8S2U6l4CJ6Ohe/84krK9SP7GB+YdTDn5z7HEc9v3wKanD6El+l2DyAq7veSz44ky62pIvH17LoT5kX251Uu6xFC2OPQjmLJEyz7P3xMaVOLtJdBNDy0bjW1vj25vyWzjCQRAuuDGGEcFSKSpFDyFHCtMleVhppfRekyDMZQlYDvQsf4Dmm8GXmywaz56AD7sVfFk5H89hpDmqARWd7VsbMFCA9x7BiwtofZsNi9O4PcL8g1PLOKw+1Y3nYxIoiaitieOS9o7woEj3Iw8aQ9zuV4TH0HFpe9NXsrVyhLb4x3yuzTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=09Wv3ddXAqx2Wl+jQggrLneL2QJX5YyW5L0m5+K+uk4=;
 b=V4pqzU2z0keto9wy3mRiQU/S/jafebMcgrAtitwEA2kDAN1pMkCmTNxv+vn8CwJNJWLAZHMswtbULCw/gNpQIPREEf9BPWSFdRt/spsiNsF1+/SjeJeCnZ4w+ssl8b2dqrQifazgSc6tmZJfuSyZKzdk4Y0ax5Udk73XCiKbtTdoGhl3+fZkUfvo6+IXqKj6b5MtHDh6p4CowydwSCOSHxK9ULOdysHBMnKo/gEQ3+EE2oVAGqaEurEBljpXCM8UbGXe+n9a3/TxqMxeR1kjYqxy1Jst+EBwIhQyhAg1FoHgwdUuDbE7Uf9xqPL6Ovt6IpAYSzdKEdGGQjzX4nPIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by DM5PR1101MB2234.namprd11.prod.outlook.com (2603:10b6:4:5a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 23:55:13 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::3114:d1ec:335e:d303%3]) with mapi id 15.20.5186.013; Wed, 20 Apr 2022
 23:55:13 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH v2 7/8] kvm/vfio: Remove vfio_group from kvm
Thread-Topic: [PATCH v2 7/8] kvm/vfio: Remove vfio_group from kvm
Thread-Index: AQHYVOwh5fnjjaYJXkCTjQBMMwh5LKz5ebKA
Date:   Wed, 20 Apr 2022 23:55:13 +0000
Message-ID: <BL1PR11MB5271D9360B3BC43D6FC07FB78CF59@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
 <7-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <7-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93d037fb-5394-4daa-9f94-08da23293621
x-ms-traffictypediagnostic: DM5PR1101MB2234:EE_
x-microsoft-antispam-prvs: <DM5PR1101MB2234B2581BBFC8BF03BF7EEE8CF59@DM5PR1101MB2234.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qthw56swjFeG+QrUbQnXSRxdRyw4UZ1FNNmeSkgaEscJpbBNy0ZPVGrNJihDkMauc3DI+Lfx5M4rF9yYikS3YeH8GvETRcRataONrRddgtTKrI3cw2DJajq3QoMJk7qbFERGHIPwYGZxGGrF6OshJKfch+HNxvADmXmt8t/Bx4Tngd92Ajvx1738upRaXf+sp5oRlbVGGCQuURwXmFqp2AGVrmzKFb07f8gnjYRfvcLmTCZm+aV8lMxOmLjylwqQBuZvtUsUxs2DFSQRRPlKV0bqh+gQY85K1Vz2r/y+dUlmU0REDS+ubmao/mvVtK+n4E/p7WD1erRz3o/EtXA4YWVboxZee3qj0+NEt7bKXF/LUo6akyiyMwaM4kekHw7DqJz9agcyTgyz5Q8EieOsvY5tMGx/CE2DG2Pkn/+B4y9Ou9Fn6Y4FhKeTjzMn2RG4FkvIBt+9bmfSg9atZMOrFZyenxCFfW+YDiXuOWGrRsmXIK8HhUWWoC9iuEX0y8xQOwdQPjOk0YqqoowUcT76693Xhxpc/xgVqmaOl7wZANd30GW6v/ugc9R+UZhLfwl2qHZJgoejD5UOl/JYysoaxyS+BGT9AG82o+pVEH7/gr9KIMyqBYuF+32x0SBYDtXN9YMoHq9CGTf2AhBo8JyKkDGbiUq22NOm3KYqVs5o/dNtMR3ZA77rKa7r4EmvXRdinCtnphFhJGA51OUONYT+Eg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(8936002)(508600001)(9686003)(52536014)(2906002)(33656002)(5660300002)(7696005)(38100700002)(82960400001)(38070700005)(66556008)(66946007)(55016003)(26005)(186003)(122000001)(107886003)(83380400001)(86362001)(66476007)(316002)(66446008)(8676002)(4326008)(64756008)(110136005)(71200400001)(54906003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JRUTRcN4oF7U7ItiEvG8WqcG9GI4sg++6sGsjknyqIxab6ZKiWucQpimqNiu?=
 =?us-ascii?Q?N3pmjkzfFV1w5Ou0LOFewndZuzBu7rYeOjq9JosQmEnsAsWXKvFOxQoZ5R/1?=
 =?us-ascii?Q?0OBp6HILPf9ZP/mCbfeuNnl0OA53zlfgSy/Xsvrin/ILnJAQodDxFxtUJLEt?=
 =?us-ascii?Q?ILubKpBa66D50aICdd5NeP3sDAkmpghHcXe1Z++G8hCwkoU1v5gCpzq6/3US?=
 =?us-ascii?Q?zH1/glLCruuxp+NjPXr9VmNX1ew82VvzfwZSZE8qCraItimVPWuvbE1jWJOV?=
 =?us-ascii?Q?kcgyGa8VzufxQ3VH0rL8TXB5GDwyvmlj4/YO7nR9mWjSTUOQt2Yvv8yBgQZW?=
 =?us-ascii?Q?FUK0t9XVA4zc1s5DXd8KNYHHLt/TJriB8jwzpUYdgwwkyNfswI/iuhtluwQB?=
 =?us-ascii?Q?OozJUKc2NGx+flTFROh/1naUzhtjAYWFXumiL1Ry2LEuT0lb/gCo8nSVrH6D?=
 =?us-ascii?Q?EJxkQ/Z7jBHOyYeMUGmFBXrrqxb12d/OdWKJnNXmobgOKZTVireczYjfAebK?=
 =?us-ascii?Q?UL9U/DsfKIHrh6zoVN7pcB0sPuBA/21R/a0utTNHapQOuz+0KQGdn9QsPZaK?=
 =?us-ascii?Q?CKB9GZK0xOhbU2Vtu7lDtVbAl34S5PR0zybdPJRS8r2UYRxN95a+mmphafNb?=
 =?us-ascii?Q?Nu06AnCF/2GPLfn+HqYb69vI0txHId4Vc3JgqdWqkZeuYiLeEu3+p/tmCZ1i?=
 =?us-ascii?Q?vAa9NtucAv9qAhH3ue8oO/kuZdDlAOclnHZ+azw0/0Z5qnYuxhCP2Sscsbhx?=
 =?us-ascii?Q?TvKMue/gJzH6KlyRoDJ/x0/ue1u0sm9oWxUAwTKzPPt3KB9RoTlHRxRwmuJN?=
 =?us-ascii?Q?heK3Ce9/ynpOj4u8H3Uto2ROYI9Js7jlVd/H1VFnghYr/6LzoTUE/jyfIByP?=
 =?us-ascii?Q?aBGxbQkFKgjsV9uHA4K3dJEr2lMxV+XA2jS8JbgzOCID6/PzSqnsN4rNdort?=
 =?us-ascii?Q?zjKlOY0OITWu7nxDo1onh1Dh1w4VmjHxsIMMB6czdEoE4lss3hpl+3oGpBNp?=
 =?us-ascii?Q?xad7ed9+ZiPyrqKvDiQXbJ7hxMCr9C/qjyC5DZfZ5CG5PHRVGtkJ5G7g4kH6?=
 =?us-ascii?Q?R1Qq6T5WkS5YmKyLYo7SBUUFVIy0EZ1DymNTgjdigXwTjFUKm8O5Tx0lS8oq?=
 =?us-ascii?Q?kvSV6o4UtCjRzTMsD+BODKoJp9za8f1527rBi68hwfX+0DGPftQTneSN0C79?=
 =?us-ascii?Q?BMzMBnmAq+7RfJXskx17fFKWia8mbooS5I+BIOiT0MgaYbL+xDjKb5kmUZ9Z?=
 =?us-ascii?Q?BHHxE1rWMGGNqrekMg6DL9TGNl/kJfcIuHTGRIkkHNwhbVeOckzRWm4ChDYk?=
 =?us-ascii?Q?DXhNDu89rnbDsk3IGyTt5VLK1pegdYoPUPiPKVEGIe53YpmynI2FZAl1lRmA?=
 =?us-ascii?Q?rjpRxknFexAFvvwChWPXdH+RMvkAMTYJ3NLPydfJW6twNNXmrymHQsi7yppk?=
 =?us-ascii?Q?TMgnGUYKKt2rCVb7XNFeSzziYiIx9IIkvzs3TSXzC9OqrZnsMZeDjPPwnonf?=
 =?us-ascii?Q?rYfEIAlTFwwDqkA5L+GQAzvEnfZ1Pz9H+0PYhSuwDF8izHEpKDVLx8C4leKD?=
 =?us-ascii?Q?l4I7geKKflkT9ZE2/D6wFqRpceVVGKVsYyefZDHkWZ0/TClI0AwjDhz6OIir?=
 =?us-ascii?Q?6i+i5E54y++zi6cgPwSGhzeFerzV6Z34Mc7ajlT91xNwbdaeXzLqNtn1mnFD?=
 =?us-ascii?Q?VhSotomTRc4FJ99IaQ9g9vgq2oQhV0P+4MSdSw64YXv/QD3ef1hWBn4dEK1D?=
 =?us-ascii?Q?clqsRhrWgw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d037fb-5394-4daa-9f94-08da23293621
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 23:55:13.4681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97uLRiz3bDbTf65bpdsYnwqotp54HNFBkk6VERZAtItuiTInSK87G0EUmtDwjQyAEggLmXcFsCMjEF1ErxM/Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2234
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, April 21, 2022 3:23 AM
>=20
> None of the VFIO APIs take in the vfio_group anymore, so we can remove it
> completely.
>=20
> This has a subtle side effect on the enforced coherency tracking. The
> vfio_group_get_external_user() was holding on to the container_users whic=
h
> would prevent the iommu_domain and thus the enforced coherency value
> from
> changing while the group is registered with kvm.
>=20
> It changes the security proof slightly into 'user must hold a group FD
> that has a device that cannot enforce DMA coherence'. As opening the grou=
p
> FD, not attaching the container, is the privileged operation this doesn't
> change the security properties much.
>=20
> On the flip side it paves the way to changing the iommu_domain/container
> attached to a group at runtime which is something that will be required t=
o
> support nested translation.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Other than whether to check error on enforced coherency:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  virt/kvm/vfio.c | 51 ++++++++-----------------------------------------
>  1 file changed, 8 insertions(+), 43 deletions(-)
>=20
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 2aeb53247001cc..f78c2fe3659c1a 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -24,7 +24,6 @@
>  struct kvm_vfio_group {
>  	struct list_head node;
>  	struct file *file;
> -	struct vfio_group *vfio_group;
>  };
>=20
>  struct kvm_vfio {
> @@ -33,35 +32,6 @@ struct kvm_vfio {
>  	bool noncoherent;
>  };
>=20
> -static struct vfio_group *kvm_vfio_group_get_external_user(struct file *=
filep)
> -{
> -	struct vfio_group *vfio_group;
> -	struct vfio_group *(*fn)(struct file *);
> -
> -	fn =3D symbol_get(vfio_group_get_external_user);
> -	if (!fn)
> -		return ERR_PTR(-EINVAL);
> -
> -	vfio_group =3D fn(filep);
> -
> -	symbol_put(vfio_group_get_external_user);
> -
> -	return vfio_group;
> -}
> -
> -static void kvm_vfio_group_put_external_user(struct vfio_group
> *vfio_group)
> -{
> -	void (*fn)(struct vfio_group *);
> -
> -	fn =3D symbol_get(vfio_group_put_external_user);
> -	if (!fn)
> -		return;
> -
> -	fn(vfio_group);
> -
> -	symbol_put(vfio_group_put_external_user);
> -}
> -
>  static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
>  {
>  	void (*fn)(struct file *file, struct kvm *kvm);
> @@ -91,7 +61,6 @@ static bool kvm_vfio_file_enforced_coherent(struct file
> *file)
>  	return ret;
>  }
>=20
> -#ifdef CONFIG_SPAPR_TCE_IOMMU
>  static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
>  {
>  	struct iommu_group *(*fn)(struct file *file);
> @@ -108,6 +77,7 @@ static struct iommu_group
> *kvm_vfio_file_iommu_group(struct file *file)
>  	return ret;
>  }
>=20
> +#ifdef CONFIG_SPAPR_TCE_IOMMU
>  static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
>  					     struct kvm_vfio_group *kvg)
>  {
> @@ -157,7 +127,6 @@ static void kvm_vfio_update_coherency(struct
> kvm_device *dev)
>  static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
>  {
>  	struct kvm_vfio *kv =3D dev->private;
> -	struct vfio_group *vfio_group;
>  	struct kvm_vfio_group *kvg;
>  	struct file *filp;
>  	int ret;
> @@ -166,6 +135,12 @@ static int kvm_vfio_group_add(struct kvm_device
> *dev, unsigned int fd)
>  	if (!filp)
>  		return -EBADF;
>=20
> +	/* Ensure the FD is a vfio group FD.*/
> +	if (!kvm_vfio_file_iommu_group(filp)) {
> +		ret =3D -EINVAL;
> +		goto err_fput;
> +	}
> +
>  	mutex_lock(&kv->lock);
>=20
>  	list_for_each_entry(kvg, &kv->group_list, node) {
> @@ -181,15 +156,8 @@ static int kvm_vfio_group_add(struct kvm_device
> *dev, unsigned int fd)
>  		goto err_unlock;
>  	}
>=20
> -	vfio_group =3D kvm_vfio_group_get_external_user(filp);
> -	if (IS_ERR(vfio_group)) {
> -		ret =3D PTR_ERR(vfio_group);
> -		goto err_free;
> -	}
> -
>  	kvg->file =3D filp;
>  	list_add_tail(&kvg->node, &kv->group_list);
> -	kvg->vfio_group =3D vfio_group;
>=20
>  	kvm_arch_start_assignment(dev->kvm);
>=20
> @@ -199,10 +167,9 @@ static int kvm_vfio_group_add(struct kvm_device
> *dev, unsigned int fd)
>  	kvm_vfio_update_coherency(dev);
>=20
>  	return 0;
> -err_free:
> -	kfree(kvg);
>  err_unlock:
>  	mutex_unlock(&kv->lock);
> +err_fput:
>  	fput(filp);
>  	return ret;
>  }
> @@ -232,7 +199,6 @@ static int kvm_vfio_group_del(struct kvm_device
> *dev, unsigned int fd)
>  		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  #endif
>  		kvm_vfio_file_set_kvm(kvg->file, NULL);
> -		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->file);
>  		kfree(kvg);
>  		ret =3D 0;
> @@ -359,7 +325,6 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
>  		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  #endif
>  		kvm_vfio_file_set_kvm(kvg->file, NULL);
> -		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->file);
>  		list_del(&kvg->node);
>  		kfree(kvg);
> --
> 2.36.0

