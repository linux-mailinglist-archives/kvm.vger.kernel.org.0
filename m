Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C393349FEE
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhCZCsy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:48:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:3062 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhCZCs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:48:29 -0400
IronPort-SDR: r5tDZJsFoKCBMl/qkk+agln3UPGF4EVxoJfh4zxfXk8gkkKc65PFkDb8dNXM6gJE3PeSPFejRf
 TEV899HGFkuA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="255060942"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="255060942"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 19:48:28 -0700
IronPort-SDR: zLkd668VwgiAq77AuGLiryFOyLZAMePWAlnZBlNtymHSoEwP/Ov4iOG9XGSv4VO/BmtiSspb8Q
 pVPFwU5xTCbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="377093081"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 25 Mar 2021 19:48:28 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:48:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:48:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 19:48:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 19:48:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKGyx82ZoPw1wdgwYOCrA3bojD+wY/Ft9AMjW9OT0bsc2t7Y2ZY4247wjZXlhoPIwyDPYBWueQBBrpBTSxokBYuC1ry+0wowhkl8U8qgAsBhtP9bhMCa01uu6RKbmBCoYTbyR1UihfyN0U1xh+PAcPht7Pw4GhbPi31+ySjC4+9vLVxLP9WxmmTThQMn4qujn5THIeKNWqAhknrspFPhU1qwss875RoJXZ8K123fawyKzErAgRJpdty6qPPE0axmK4oziRkUJnM1cdnsQlvru0zEGFHjsatewDj9ZfNQpV5YwBe1GqxTz94RoXIXo2E4QrZziGY356LrO4zcvAMTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNpK0sedpynHJKnIQZzgpMl0J6PLjk8Iwz1qdlbSfhY=;
 b=EWFxEzmQe8NMJvu8TsQJpJEWcabinmy23z+WK6VMEaHTAHewhdD4Umf1khVAfAeF4h0ycojE6zhmphlSdtPWKYTNsPMLzfrdku1fBdBL/NHi21f8BL+CfGDSuBcljxjaBkoZ1MUpggi/hJvajyC5ndhweUXDKbo0gts84AAPOiRQ4ir9lppwz0gG61LbFa+Ms9XUtcVgr1os3ibBCe5h+QwRUkKmrZD+weYGlxTZNhSW1phKk9l50/L+CUHeP9EZD57Lg+Lwf161DLLbFcmh0T8CChauenyZqhfUlWBz3GwZMBec7r2IssLBn1bHPyf1EfO3jNia8ZvfqlEBpbRu1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNpK0sedpynHJKnIQZzgpMl0J6PLjk8Iwz1qdlbSfhY=;
 b=GCTuOrsHF73eNvh7JyPADcBXGXSMLdaR3i8ROTfWqsS86WSq5FotXlKc/Xq1ZjGf0AkRurouMvd5RSI3RcrXhJucP0Vo3jncqOqbgfl9H+EqxBUizrC5po9EWPlN7SJ70hMXaoa+1QSY/CvimMnWcPwv/QJVm3gVGyEByUMYGa4=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1663.namprd11.prod.outlook.com (2603:10b6:301:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 02:47:43 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 02:47:43 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 06/18] vfio/mdev: Expose mdev_get/put_parent to
 mdev_private.h
Thread-Topic: [PATCH 06/18] vfio/mdev: Expose mdev_get/put_parent to
 mdev_private.h
Thread-Index: AQHXIA3vHFR+W4ZyL0KLHgmpUKa/UKqVlJGA
Date:   Fri, 26 Mar 2021 02:47:43 +0000
Message-ID: <MWHPR11MB188639FF07BA22CBDBF3F0BB8C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.220]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 820b65aa-6846-42ee-2e79-08d8f0018788
x-ms-traffictypediagnostic: MWHPR11MB1663:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1663C453E9E94F2D37472B4E8C619@MWHPR11MB1663.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QjPVk/plPd2Y8E6aaUJTo4pbpsVyk7KiVuT21vV29r/i3LFHT2oXG3qhJME3h6cLucG4Uvlk94vv0m838uuKlumlo5Bi/BADhRHCc/6suNGUfKVvIbJLW5xNNUmx+32O2zAgxZ4wYMbjygVNlJeixJ8V5wCYrBRcYCxG6eSnl1rEfy5dIbEEYyOIM4PZH47vXO2IeMVBR2N/nVye0MzRjC8ha2t4yC0abaXs4kDGB9bndOK0rKuRpf6rDKCciRM7xC66S6A8jiNzyDKvrsfVM+cTyD2Hkbj/qSvJkESK7O04NPxs66Hqn3D7M4GCxUwrwNeWlLPeNT+rNZFKX538h9FDeCaExHwg5N7slsbrNZcrxb5jN9rsOl1RVNNWDukqA8tvgn90dp4ABFXEbjquBD9jNMKJtt2nW1X7bkgkRbCa0+w5lzu9leY/1SEpFufsODX9GrbHtUvkhCPVBBMTvvSugrOZJNu+IMMdjDp6TP2eszWcrJ6E4BaYniC+QpT5YnYnevMZ4PAg0uENg37VexIMuR0aofRLFSEIg21KKATqlEahTVfn9uvSwiQ+ThTrN4NK+l0fdRyYPPaR/9aakl2sk6l6pWnzIuhujFs8LDAjeiRMFTYjSQ18YEgoc06IcILxMt8wEVZ21t4DfNkgLuJNjgnyxNeeuomaYJWcKtQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(346002)(376002)(366004)(186003)(5660300002)(38100700001)(6506007)(52536014)(2906002)(26005)(7416002)(4326008)(76116006)(71200400001)(55016002)(478600001)(64756008)(9686003)(7696005)(66556008)(66476007)(66446008)(66946007)(54906003)(110136005)(33656002)(8936002)(316002)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?sadS+xwjdLRAe+G04pz58JblzVp2j98yyvtbhNl4LmbkvEj5wA4Hq1vMVO3d?=
 =?us-ascii?Q?RiXqsWKPErTDiAN6FwNPC0aZjRP5AHD9X0w5UGEWCHXWitTht+R8qXp05uig?=
 =?us-ascii?Q?pI9G62QbXaW7CTFfc3R5B94p4ohcZPcUK2Ea7zv1uCP2Zz8EN8dX834U4bmp?=
 =?us-ascii?Q?s2c/BT8EqWPQCfmvaeTCNudny/9h/fjlQbAyPfrcv0/Y0BmZBC1tTZqnP+Bf?=
 =?us-ascii?Q?vbWglwSFZcQfmfuYElSCBeM5XBnkhHuIyZ5Z9HN6guMVt6MLw19qN2XidjDR?=
 =?us-ascii?Q?FAoawEfqHZ2fUqxQdExcZEEIxJx10MGlGCBr8BpiJAM9DAkGXdOglGevYe5T?=
 =?us-ascii?Q?rid1Kpy6SSv4XmZzKlHZwHUKsVyKmTfXr0eFoyRZZRkNZ6rZ1S0F8eu6ZUc+?=
 =?us-ascii?Q?uLSNg83W4JObEzO7LSIXx/wph698CgXpzVTaU/ARhyPyLYpXzHGNFLWU38Wz?=
 =?us-ascii?Q?3+PQeo60HgMKf9o6+zMhsIKzN9h/y7Y7Jn/pcea0JrhPMwwWseCF8oI/YJlf?=
 =?us-ascii?Q?zGBSNg9QCRfdDHgNapBBX2Vm90iZgPN4bFcZGA9zIXgtL0LhObdhrTb/0j9s?=
 =?us-ascii?Q?oPYWwJwaoCR2t6HLr4bpD5F1W5mH5nMuEA5a8QV5EWiTu3HN/KyK07aK8aeU?=
 =?us-ascii?Q?vKVQXBG7OKRInMKRajoEJQLMjPjtyR+0Y8p2cuTxTmExRsYN66K+ZJP+SQWS?=
 =?us-ascii?Q?v0Ig82wbNzKaQ7DXKTF+uZMg51mv102eF5RH9B5UHIiNojQHo31aN9860nF8?=
 =?us-ascii?Q?rnjsPsAeXKBpiKVYY2nwowX9SUVJDwXtO+3GS7KqTUR9y+x2XSdV99G932hE?=
 =?us-ascii?Q?wWuFwXz9LWFbRTi2cSFmRzv2L893GiRxIOV0/ZN3YCBCs+xp9axKla5vUMco?=
 =?us-ascii?Q?Z/Q+cpdRPDmwxfvf9niIS+4nQJ4GDnjzl03J3Tt3S4kHOK7bNVj0SFKSIdNS?=
 =?us-ascii?Q?gVwhmdjeCTDj6NhgyY6Iod4l2j6H+Rl8YDYnXaGnjVyFv4T9Dwe/8AWL/kxt?=
 =?us-ascii?Q?+lukywNE+PwxsSggWWr4hHedwGsTsW0L0ENhsBuIyVO1oicGt1lhJKjHvRN2?=
 =?us-ascii?Q?Z0+nBTOFXyuD8H9M49guNPu4saFO3WEZOW5UpVS0ZMjtMt3TTd1VbNwI5tWX?=
 =?us-ascii?Q?sQpjhucAmiTO30pmzH3EKuwJsjctEN/fpR50JVJY1ZqghFmLcWblAD1IW3kY?=
 =?us-ascii?Q?RY2zxRvRG+quD0zzhyIL7C4h4ubvc1UxOqz1FMyUuom1pw8W/YeHUPoEvoE/?=
 =?us-ascii?Q?UGFTAWEnlBTCujiydXzrB5FAjPWz7a9NS1jNHPHfREOMjLb4UeXOM5I2+jEp?=
 =?us-ascii?Q?mMnEyb5Ohhep7aaD7DWwlM9y?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820b65aa-6846-42ee-2e79-08d8f0018788
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 02:47:43.1138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vU5P42JbCFh7j+CMVbzVlg5dEEu+X3KWgvvux2sNRI2uOdRYXZ70Kcehfm2/Fhnef6J0Z4CDMdjGiJw7yz28Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1663
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> The next patch will use these in mdev_sysfs.c
>=20
> While here remove the now dead code checks for NULL, a mdev_type can
> never
> have a NULL parent.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_core.c    | 23 +++--------------------
>  drivers/vfio/mdev/mdev_private.h | 12 ++++++++++++
>  2 files changed, 15 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 5ca0efa5266bad..7ec21c907397a5 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -45,7 +45,7 @@ static struct mdev_parent *__find_parent_device(struct
> device *dev)
>  	return NULL;
>  }
>=20
> -static void mdev_release_parent(struct kref *kref)
> +void mdev_release_parent(struct kref *kref)
>  {
>  	struct mdev_parent *parent =3D container_of(kref, struct mdev_parent,
>  						  ref);
> @@ -55,20 +55,6 @@ static void mdev_release_parent(struct kref *kref)
>  	put_device(dev);
>  }
>=20
> -static struct mdev_parent *mdev_get_parent(struct mdev_parent *parent)
> -{
> -	if (parent)
> -		kref_get(&parent->ref);
> -
> -	return parent;
> -}
> -
> -static void mdev_put_parent(struct mdev_parent *parent)
> -{
> -	if (parent)
> -		kref_put(&parent->ref, mdev_release_parent);
> -}
> -
>  /* Caller must hold parent unreg_sem read or write lock */
>  static void mdev_device_remove_common(struct mdev_device *mdev)
>  {
> @@ -243,12 +229,9 @@ int mdev_device_create(struct mdev_type *type,
> const guid_t *uuid)
>  {
>  	int ret;
>  	struct mdev_device *mdev, *tmp;
> -	struct mdev_parent *parent;
> -
> -	parent =3D mdev_get_parent(type->parent);
> -	if (!parent)
> -		return -EINVAL;
> +	struct mdev_parent *parent =3D type->parent;
>=20
> +	mdev_get_parent(parent);
>  	mutex_lock(&mdev_list_lock);
>=20
>  	/* Check for duplicate */
> diff --git a/drivers/vfio/mdev/mdev_private.h
> b/drivers/vfio/mdev/mdev_private.h
> index debf27f95b4f10..10eccc35782c4d 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -46,4 +46,16 @@ void mdev_remove_sysfs_files(struct mdev_device
> *mdev);
>  int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
>  int  mdev_device_remove(struct mdev_device *dev);
>=20
> +void mdev_release_parent(struct kref *kref);
> +
> +static inline void mdev_get_parent(struct mdev_parent *parent)
> +{
> +	kref_get(&parent->ref);
> +}
> +
> +static inline void mdev_put_parent(struct mdev_parent *parent)
> +{
> +	kref_put(&parent->ref, mdev_release_parent);
> +}
> +
>  #endif /* MDEV_PRIVATE_H */
> --
> 2.31.0

