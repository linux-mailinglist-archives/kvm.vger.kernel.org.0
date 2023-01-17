Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A354966D585
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 06:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbjAQFOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 00:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbjAQFOS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 00:14:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E16233EF
        for <kvm@vger.kernel.org>; Mon, 16 Jan 2023 21:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673932456; x=1705468456;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=iIAErg9LmCGbZNuPpeubeoMXFfgSZWZ87g+JWB5WTDk=;
  b=I2wmGbq2tYlk0rKNfFBwUw8bIRb5EXEEUT/iimYuSU4oINoCY4EIr3z9
   w3ukAaFKotZLFp5YM/NjBww59TuFDADRvW2eTCYcbB6NF5DG/WF8sa89N
   7KaJlSI51eV7MP4sTGIzcS3I6wDFi0Ve5DTSzvUXN5oMi4Gt9FM8fo8/d
   +DZYdHj54j/5J4Dmo3cYe+yxykiaHpEvddmhusLgVX+usXvYD/qiet1xX
   7xvC1GvbcyyT3V0LKAOrnJnrzgbte+iJWJPtNTM3/pnSTZbzfM4FZzVWS
   OQwv/LgiNLs0XR1TjLH9/NepDuj3jeNvZTxVqt6N0qVbWcHaQhR31DPS1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="324666205"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="324666205"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 21:14:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="987995654"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="987995654"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 16 Jan 2023 21:14:16 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 21:14:15 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 21:14:15 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 21:14:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJOEP8HgJWJVK+7albdwmX1Ob5+ZbRJ052xWJaLdXcn6/I15UkNDI/ghWNKSo3Si8wMhZxGgUqKpxHhfJqqqu/QUQSta4h913Mb9VsJUdWi4pFw74KGRSJ5kO2LZ0WknWzURuBJTRcJ9qF88+UYKVBZgO/DGcqnG6vwD3GAO/OfVLsGspY+qYgDL2ZjHJZPt7aDtDtWEe7eTnbBIpnZuehWRjV4FOzp7aOdx3cdoBpgAMZi5TV8OvuJPsUp+vD7rNXWDSsnSuqJHaZx4oQeez9/nIMr1v6gNOzwjPBUcbZ0CvpHdEoQtVd1DRsN3HBN7GrBZ6FJhhtoUi9shLmq5bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1sRIpkgLAAjFJ9W6uqAlsQp/8cOuHYHkOT69FULexw=;
 b=nYL8HDIQ+1fM8rOsw9XICKICOZ5Iz/mtHcC7b9Dv7uzP3dqjQlJ3Wa8j7oB5FeEpJaPLnvuAPC1ZbG2xf8DCC8J9j9LK/qZEwTB53qBoF/R3Sk0kAtqxwe4lcvi0yLltcKwoSy/ozDsc32LgxHZYEHPw/bsBQ/HLYamjX8rCtMdM3UKK7kUUrlSUC2XX5Ti7qMWPdvzMMtz/pZJ8lzxI/uZihJIZGdpcIVEEIols7AgCWklgY1pHjg/uUoUmPkesOo72BgEWNLduJ4QzgQJffhrOCmxkwRz5G1H/SRXlaxvuicYJtVuNB/Ag6fTFp+EQZiEpOLfWRxwBiiWvitJwEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH8PR11MB6830.namprd11.prod.outlook.com (2603:10b6:510:22e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 05:14:13 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.5986.018; Tue, 17 Jan 2023
 05:14:13 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Topic: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Thread-Index: AQHZJS8kfO7o6BZcqkmxMznEHHL4Oa6iGfLA
Date:   Tue, 17 Jan 2023 05:14:12 +0000
Message-ID: <DS0PR11MB75292238656F19908C0D0A4BC3C69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
In-Reply-To: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH8PR11MB6830:EE_
x-ms-office365-filtering-correlation-id: 29c3f15c-2860-42e6-47a8-08daf849ac08
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: trz/MAiJvOCF2sDgb9TjhB30848g7v5EPs9WFpqqqFv0Q3Vmcsm0HZFBAFbLszHTsioF2x3jazEGhCslMNh0a8/sOONpUhjYeDdYdxh8WRUdQ0fuZhW1FrO1j9f/92LeLSiNxJpZNo69GjG2KL37ZwS+JpKAGje7CV8P4yCq3iCfZ73MhYQk8pg9q8zrj7Oju2t/xfu/1iVP9lOeec6XF1UNTBy1Ja2eq7F7xjURmpub7y0OX1BgdEkaNLChjFleGq13oteKEoOyzZSsIMGHZDeO4L4FXecxkTYc0vpBMdQ5vSMVqcp4n7Mj3zyz6StXpjA6tfGsyYTWhjg5t8Yv2pjrBUzHjfzu1tGUR7dkL3PTD8kPQ3hHinqCcw3rW3zZe4FqNALv3wLmQzXh3adB8SPn2RPtoJU5Fl48pwZtJYkxOVpTpoHEidsC2mC02cOGs1+ozrznhCFF5M4dk0O4oHPQ44XEYvmcNuDa2jpkPCcH8VMX/18kcr67/w99E8VakJv2crYkrCLA39XhmxSvjq3nXXGUicr1RrUO6aTizgRrHcqHMiEK13PqAo5lM6lFKUq9cPG+ElrErGr6wXixjxceWjOI1UpieLoxvhnAFn/vkE6ERfFKhIJss7Kcsq6gEomakBJblvnz6Sju57ptNPU0cA1w7q2tKqx2OQPOBveeEDDZIo36EvqexS84G3EzQJYqx3m+qRP2p7Bap29oHA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(376002)(396003)(346002)(451199015)(55016003)(33656002)(7696005)(478600001)(71200400001)(110136005)(9686003)(26005)(6506007)(52536014)(2906002)(41300700001)(8936002)(316002)(5660300002)(8676002)(66556008)(66446008)(64756008)(76116006)(66946007)(66476007)(122000001)(186003)(38070700005)(38100700002)(82960400001)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xCaxne9bo0rHVX16vAB+U3i4MnB2ieVp8iBN4648nGR9HzOAl4zaE+GfWqJA?=
 =?us-ascii?Q?DhcGKJPQib00zF0yB2qYFdWscvFRMc91wQ+XhoQ+7TKoL1DnM3NuHaJEleJz?=
 =?us-ascii?Q?FwmeF8mnqobEAhcJsvm8+GcD8ozb3cwtLqd+HrB84HEN4VzLy7qMaTZOuMSL?=
 =?us-ascii?Q?3vGOCFj1Dd/iU+0Uw432ZwCTiy3cdHYWCR8CNlCVEVwxBI/0FaKeSaf+o0jh?=
 =?us-ascii?Q?Rke6sRa9mILy5dsUhC2fXKsG4Lj1ic1y3FbdHzAlo6IfUrUPopE0FDY5DgZ0?=
 =?us-ascii?Q?pFGTVapjtJv21k32jdzkzyXuELkM9D5B1oaxE7RT1IjYu/zlhuZTpIMlZ+1x?=
 =?us-ascii?Q?fKluJ8a5ql7lCTU/eFgEYRp/muPOIQI02f7m3SqgL1Df4Js87QHzezQoxu5B?=
 =?us-ascii?Q?eYuqr3rcC56+vmLNeYim7myLPRIM9AScrPGAV8Hf1b/3tClWglfk9QXKCFms?=
 =?us-ascii?Q?NIlf92y7TSUycJMM+tY+sda3NPIUU6smMi3ZKyWZeljJl9npac0rS7mkue3A?=
 =?us-ascii?Q?MBDb12pKnmea+OFkjUgcPH2mKt0NJ+jTEMTCXpNUWcEBghHGRr/tRRTy4hae?=
 =?us-ascii?Q?xFet0PRolULNuXuGrWueW69xv+Gi6HJwRVx34KcFFVJrGFuuqiYsA/UIgJ7l?=
 =?us-ascii?Q?P8g5HHeqFzNE8Wn2iswSOZVbjamkUHxTI20q4tAebavscqNN6I2a4Z8RDjVk?=
 =?us-ascii?Q?herC5ZktPuhvWVWgB4SFD6vFmWbXOJFbtZItY08kZZkANHBdU8AOUz/64i3+?=
 =?us-ascii?Q?Ml5HVYBXLSr0JvXG85hJI9eG6VI5pgeuvOq0UZafL1q/uFbYw60PX+yRmHIC?=
 =?us-ascii?Q?LbotBq3/UYxARA+n+xPZCVyis+5lPXOwMWdjRZHpA/4v42jrhjZzHX6x32RV?=
 =?us-ascii?Q?qG6bbAYYDv6U+rMrjSRizGxE/VjfGFrAhFXTXnxiEFoLltsT2H+oP+xPQyWK?=
 =?us-ascii?Q?RpsxSgTzuimFo4ERzzdRIvMTCHcLi2M4KkXScaUGJVblC2p6vZ+mn3qSdj3A?=
 =?us-ascii?Q?CJeK/W1b+h6z/zIdF/O8bBvjvacAhVYV3qTB8eFmAJxvwwgyphEaHG6GKLxD?=
 =?us-ascii?Q?5/zvobbbsnKIy+KTLhouHL/LRMQiIhcKlaHuiUd0S6nutxrNhI/LehRmvmnY?=
 =?us-ascii?Q?E63Sf+P6iA1MHmLlpoJDzs4nvC2dpsakM+rHWkBn7Sy1exmkvzUy8PQHHNmh?=
 =?us-ascii?Q?0Keu/HqzZbp//UZpqu3GcBY48SnR1Qdnod7o4tfLYnArZIfTWaCZb+hGrVjy?=
 =?us-ascii?Q?DMBuAPUtU4KEwdDhmqlZVHIIT4W5yE4mGRAwINsiyEgIG46AFVS6SS1D4jL/?=
 =?us-ascii?Q?YBkURUmCfDSyJcL34BcZLGoqWzX4eTNS3n7+bIzNPCt0YaSn7zcjuKur7poo?=
 =?us-ascii?Q?dijq9xnXpFAgn9h5k5o6/mVbedwCfAUqhT/mEqHsdMYM8uOnGotQtCP+FCwS?=
 =?us-ascii?Q?ZjctNYv1O4EfmKQswCxRn0U93aGmr4+0GgdXoQs/t6mjDRAuzUoLm1nXuz2S?=
 =?us-ascii?Q?OywT6hi1Ej2zQfcMqJh3wAdwCW7hLVwOs+DUXfr/x6833cKA6WLCmx9TmjdO?=
 =?us-ascii?Q?yvMC2NwqS7uO3ypd824IHNmyDIxfvdilzWYuIPOa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c3f15c-2860-42e6-47a8-08daf849ac08
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 05:14:12.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aTZdIhUnjyz3Hinof2HrRthE+KNSuOtHWKEFOuV7/xFXoqNP6TwCsEklwMZnW4sKgrkdel89Zr5oDCHNtqQQjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6830
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 4f82a6fa7c6c7f..79a781a4e74c09 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -18,6 +18,21 @@ int vfio_iommufd_bind(struct vfio_device *vdev,
> struct iommufd_ctx *ictx)
>=20
>  	lockdep_assert_held(&vdev->dev_set->lock);
>=20
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +	    vdev->group->type =3D=3D VFIO_NO_IOMMU) {

This should be done with a helper provided by group.c as it tries
to decode the group fields. Is it?

> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +
> +		/*
> +		 * Require no compat ioas to be assigned to proceed. The
> basic
> +		 * statement is that the user cannot have done something
> that
> +		 * implies they expected translation to exist
> +		 */
> +		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
> +			return -EPERM;
> +		return 0;
> +	}
> +
>  	/*
>  	 * If the driver doesn't provide this op then it means the device does
>  	 * not do DMA at all. So nothing to do.
> @@ -29,7 +44,7 @@ int vfio_iommufd_bind(struct vfio_device *vdev,
> struct iommufd_ctx *ictx)
>  	if (ret)
>  		return ret;
>=20
> -	ret =3D iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
> +	ret =3D iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
>  	if (ret)
>  		goto err_unbind;
>  	ret =3D vdev->ops->attach_ioas(vdev, &ioas_id);
> @@ -52,6 +67,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>=20
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +	    vdev->group->type =3D=3D VFIO_NO_IOMMU)

Ditto.

Regards,
Yi Liu
