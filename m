Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD81525EFF
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358899AbiEMJxM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347873AbiEMJxL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:53:11 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B2126C4D1
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 02:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652435588; x=1683971588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I5/jl8wGBbrDkjqBd5hGFKck7ZInH7sXMtfYHG/NFlY=;
  b=fG+/qhlU/fL1b9uwFamXkC1Qfq/sy0itWxhGPEToMltsFCLUgW9BgHb+
   i+pfsgmNNbG4e13u7QvuRMw3RBrc3Z20ivo8Jg4f1/aw5t/rNrDP/k8vb
   STbqOeXvema41YIhtScqVRWC0yzfnxd916P9AW08sft5YTpirULeGcrd2
   AjdWZfutfL7VQ3p5D4xP0zOvccX0up8ZKqRBBFBm9CKyrJHqdkrNLUjcK
   Mp9C6+mG97u0R7gH7+sKu4rjduAf/BIE0fx73CCRpdgnbR+k1Tz0mmhDp
   6TiOsOR8XXlcjSJ/oGz83k6DdwVGDlcVDuMOZVJ95TvuSdXy4+nJW7ZCw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="270401374"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="270401374"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 02:53:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="712333921"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 13 May 2022 02:53:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 02:53:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 02:53:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 02:53:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbnO1SEAjZyhX1v5kuIC1S1GdflduNhcXKTfjJRkUHuw1et2yANkQ3UkLHZqYI/sILOuW5Heyq/GhS2TZt6ndIdWVRRt55pHsSKXNEenkMQeNXTAEhpQlpEP5A1hDjEFDvWl2YeZ7NccK650TzBfZqGC+VY3e4foI7AgV0ew2ZLEggUDC3GYWPRLjgxvSkknHBtAJ7WJRr5YiqA0h/oqPshzJcK70fmsgF99k54wcwvVKtYe8IWAO/Yo1zhM7rkvWjZjHtBiYpt5y7naxpaGso0q7jAoFazSGmlWJbf7Dm85dELiX+Hgfg5/JBZpS9fCZr71lAKvW3CQ7arW8P7+LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TkD/1Qt6RHAUAoPD0aaP+oBWVnEqdz7BgK/YDVkWVUE=;
 b=Ga7LlO9QL8v+1Hv6rKWb9uHQ+gapTYJ0iIhxIvkpqRyML+jiiSSCxr0FfjDX7YiJX4J5S2KWtMeZVqtoJddWz5CeP21p6vQKSrFWjqCtF3C8ILYdGtTsh0zVGSFZiSRtPRR853r0MUIGZFjKF9cu/PGg8E5VuWVP6yZTpr0I4+hbTm4RPD7FFQHZSsU8T9h3yzlgji6pJapFTsXQwFoR//NSdNNWwCBM0OIFwzZb/fGl2DDH1nhs3qQrzjXmRxo1inpb5sHSaWxJeSS5z767XqHZZiSd0Cjork/3L8I1qrf4y3PLAgC6jPRJbzicwM0czeQo2LRphrx0QvzcD3Tv7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA0PR11MB4544.namprd11.prod.outlook.com (2603:10b6:806:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 09:53:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 09:53:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH 4/6] vfio: Fully lock struct vfio_group::container
Thread-Topic: [PATCH 4/6] vfio: Fully lock struct vfio_group::container
Thread-Index: AQHYYN/ZgRx8wmw7lUe1q6b66zPdGa0cmSwg
Date:   Fri, 13 May 2022 09:53:05 +0000
Message-ID: <BN9PR11MB5276CE4C4C01A3D34F8DC48F8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <4-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <4-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3394c528-9f45-4ffb-4bb1-08da34c66059
x-ms-traffictypediagnostic: SA0PR11MB4544:EE_
x-microsoft-antispam-prvs: <SA0PR11MB4544936BB8527B2B199A571A8CCA9@SA0PR11MB4544.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDqS7BKIlpSnu0iAOOxXk9xPRUYrGQBs68aHh7L63ny1rtNdw3JIaE3Np08nJecoc9sdmaLW99cf1YtPT4KVJ0vDkV79zO3rptSFTRHhnuL93plWgfTP2FZ1IqS4EQV9Hdy8f4xuxyk2/zdgMLDhInjRaWkIEi0Pmh/Ky4DVzEb22gkRWHBawq+P5NNIopGiIf9qb6KrGT4LHnm6rWMESusgYeZUfRo58w295U7OcpWZdLugRaZGCNbC7QtirrgNFvGGMmT91hex0PLqQyrXSsSgjcH9MMjFjmW5I9lO28BI9H4/en67RHuhM6xdNaKUP/5lAL0ch7QmKDMffVHVhPtTeMARjaaz19EBMoNVWVBdABZ2YVs1cNQ/Yy7HMMsnz/kMgDw/XRgIIwtvDwCmdvvZHEJdY2WhCcL9Q695s1VsTs0yqXDiwcn+OdMAbU7LO6CmfXCQqLnpJ/ZnFHDNEiVncgyeZgtL6456nXLx0NRQEAL0Gz7v4JLlK9qOOuoEZ58DKnxEF1yvTuv4h/t2mCcioIPfWqJPVWN+GRfwUuM1xI/RRNfd4V9Vh07HtC67uO8HeSLT2zxc0dO1Lm4d9ZDkeADNP1gNOUf+kc36Yh+TALnG8QxcT0bhbc2sodxhb8mIT/Yjg1bE5PNtYvj2HjIrA1NK9gDABazD9qEOTMuzUGaCAcW2PjoJ3IIyJ61Hx8yyL01AahTC0at84o4OqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(71200400001)(55016003)(86362001)(33656002)(2906002)(54906003)(110136005)(508600001)(83380400001)(66946007)(66476007)(38070700005)(38100700002)(76116006)(82960400001)(52536014)(66556008)(316002)(8936002)(6506007)(66446008)(64756008)(4326008)(8676002)(9686003)(26005)(7696005)(122000001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uADZtZIzaeFGU1L8jGlPidQAwU+PdxJHVZro56seEo3NPO74ajmNWjgmI+lS?=
 =?us-ascii?Q?J1t04/4QX4LQsL5ikiAx9t9PwVs8WLrzjA2LT+LCd01AFotzon02f+VxhVcv?=
 =?us-ascii?Q?h82fId6qFNKzNy5w2wa1N1f4Jl2BTs1E6K1tfFVfLAMqmxQ9slfPTZDN8R4m?=
 =?us-ascii?Q?fkMYQAauL1Cz9Uv2XrxBYAL8/3fJVdGVlheeP3U+FjBYhu/yoCPOqtuMFZsv?=
 =?us-ascii?Q?OcZTItjc/oWbTzAP8mkfrtkP6WMGtYKlQPJ63H/ZfEugSOsP4b7laE7RHbjw?=
 =?us-ascii?Q?jzXkeNOvg7uWLuiN0O1FQHlZYIcCTLHKBdp8QnYVYQLPnoedYiklFCQ97ttr?=
 =?us-ascii?Q?QQVgJ8z8Oepea4qfGYSSQKnFRVBZmg6vX1VM7vUrJHJKhBIVACN4U1bIWob6?=
 =?us-ascii?Q?E8A64CJd566zkksjIopk/hYZDREy2jgREoD3eSF4XyzzjqXoMlcBwsWLdEZp?=
 =?us-ascii?Q?bLXBo6GdbEbrB4pUI1CyMclZJ11mzoZRCsI2B/SLeGazzi2HlNRXLhysYhwz?=
 =?us-ascii?Q?e1z5eVQx8Mh63NRTq7qonZa1UEt9GspNVDA3s2azeKYJjW/p4yXeXuMspMD+?=
 =?us-ascii?Q?tpFhn5vrW2ZU6Og+28BsNbtaT8QSlFE/uhB/f+qKvYsH+8G0UXEHudlo4SE3?=
 =?us-ascii?Q?drzUnSvPS1N3MlNuSbyMnTn4E2WfkPFC3FG6lAzLHReIbwF18/9FIjnaHb+U?=
 =?us-ascii?Q?5MjdcZT6A9C8N8u9QrR+tSBXBwbGD1xBe2u3Qdyejnr4fXL+Z+F2aY0B0SI6?=
 =?us-ascii?Q?DQryMFfLE+V5uhRGeY0xTvx5g1vCHU22AMEJ0KYnngSUgJ90ilrF5KqyUV0f?=
 =?us-ascii?Q?bkyYFlH1psGLsyRapA4ZM9agRySyCbkzNhn6PqWOegv20GYXvmwTZs5zn3F4?=
 =?us-ascii?Q?PagGqoEtS6iSPa9nW+ad3byQdUwOEX4ye7ACFAy9uhlbHoafGa+yoHHC4ZS0?=
 =?us-ascii?Q?O6IoDW/GaTIi63oj4MIsy7paFjIHYkMmamwVuwnLsaY/4OoEjBuTZ6rr0Kw4?=
 =?us-ascii?Q?+RWw5PwjdwC0SvaE1vCIjQX+zQpTiWg9J02MOFUcpqqNyROv87S0+EN8dRYZ?=
 =?us-ascii?Q?78dOujJLFnTYlp53Fhq6In7KBFHsYwiDq3sy7ow/rvI5YAq7DJyB+k5cc44E?=
 =?us-ascii?Q?PaoOzdj/2QYNySFv+L5xN+/jtCEZqNjnkzjsjy4n1tMF2dF+8I2sLyCfFLcC?=
 =?us-ascii?Q?OXEqJy9mL5Gv58uzv/NcpAQ2ttrUUdSyCvffCuRqEdtFc/ho2I0XQdogmgPm?=
 =?us-ascii?Q?q5JRmJ6V6CbCLdgxKm1fDnd6kr09+aC9LJ8u0P4AC8jSPckS62cpAi7kzNQF?=
 =?us-ascii?Q?sEYs0K3WcuGmz3lz+j/UAOFDprFSzBAsf8nlCmv/GdDlwOfL7UYe1I8hAf0M?=
 =?us-ascii?Q?qf6UDqEPdWH7GpPN1yssmNun8n3fiy3IKkRuFCiORH9T6ZhJGlO+kTQVH2zI?=
 =?us-ascii?Q?d2/GxWZtdkTfNSpi3grDvJkUoRVGZsoh72kQsuxRTiVVHQUkMzYbAX3WuKc6?=
 =?us-ascii?Q?jP6y1c9H1ivS8Yg1DCsbbC0ECBWsUFUkDi6J+hxTUbOseqCDp3sosrjOMja8?=
 =?us-ascii?Q?9Fkn+uaA9UcmlfeA1VGHwuxPgnB4rSJ4IzPI5lzBopzg8BwGVlOUuBSdt+c0?=
 =?us-ascii?Q?4/0qQU5SriA02nUrXAmdntzZFr/iiSuhReJA1w08dMYlVLrqqRgrhafd5w81?=
 =?us-ascii?Q?jaXfwUB0lycfwD8fGkFHw5RuJAwq7Q9UZtcYhKWODSpUJyQ+K6D3y0l1wVOk?=
 =?us-ascii?Q?niB1qzVUmg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3394c528-9f45-4ffb-4bb1-08da34c66059
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 09:53:05.0667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a35ffUlcxkn9pMTZPK7qk5AquETMU+NBPg0pQltVlb03hBPrVP4xsbGPARCe7GMqKAUAUm2Ev5z1OcL9HYAXlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4544
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, May 6, 2022 8:25 AM
>=20
> This is necessary to avoid various user triggerable races, for instance
> racing SET_CONTAINER/UNSET_CONTAINER:
>=20
>                                   ioctl(VFIO_GROUP_SET_CONTAINER)
> ioctl(VFIO_GROUP_UNSET_CONTAINER)
>  vfio_group_unset_container
>     int users =3D atomic_cmpxchg(&group->container_users, 1, 0);
>     // users =3D=3D 1 container_users =3D=3D 0
>     __vfio_group_unset_container(group);
>=20
>                                     vfio_group_set_container()
> 	                              if (atomic_read(&group->container_users))

	                       if (!atomic_read(...))

> 				        down_write(&container->group_lock);
> 				        group->container =3D container;
> 				        up_write(&container->group_lock);
>=20

It'd be clearer to add below step here:

       container =3D group->container;

otherwise if this assignment is done before above race then the
original container is not leaked.

>       down_write(&container->group_lock);
>       group->container =3D NULL;
>       up_write(&container->group_lock);
>       vfio_container_put(container);
>       /* woops we leaked the original container  */
>=20
> This can then go on to NULL pointer deref since container =3D=3D 0 and
> container_users =3D=3D 1.
>=20
> Wrap all touches of container, except those on a performance path with a
> known open device, with the group_rwsem.
>=20
> The only user of vfio_group_add_container_user() holds the user count for
> a simple operation, change it to just hold the group_lock over the
> operation and delete vfio_group_add_container_user(). Containers now only
> gain a user when a device FD is opened.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 66 +++++++++++++++++++++++++++------------------
>  1 file changed, 40 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index d8d14e528ab795..63f7fa872eae60 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -937,6 +937,8 @@ static void __vfio_group_unset_container(struct
> vfio_group *group)
>  	struct vfio_container *container =3D group->container;
>  	struct vfio_iommu_driver *driver;
>=20
> +	lockdep_assert_held_write(&group->group_rwsem);
> +
>  	down_write(&container->group_lock);
>=20
>  	driver =3D container->iommu_driver;
> @@ -973,6 +975,8 @@ static int vfio_group_unset_container(struct
> vfio_group *group)
>  {
>  	int users =3D atomic_cmpxchg(&group->container_users, 1, 0);
>=20
> +	lockdep_assert_held_write(&group->group_rwsem);
> +
>  	if (!users)
>  		return -EINVAL;
>  	if (users !=3D 1)
> @@ -991,8 +995,10 @@ static int vfio_group_unset_container(struct
> vfio_group *group)
>   */
>  static void vfio_group_try_dissolve_container(struct vfio_group *group)
>  {
> +	down_write(&group->group_rwsem);
>  	if (0 =3D=3D atomic_dec_if_positive(&group->container_users))
>  		__vfio_group_unset_container(group);
> +	up_write(&group->group_rwsem);
>  }
>=20
>  static int vfio_group_set_container(struct vfio_group *group, int
> container_fd)
> @@ -1002,6 +1008,8 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>  	struct vfio_iommu_driver *driver;
>  	int ret =3D 0;
>=20
> +	lockdep_assert_held_write(&group->group_rwsem);
> +
>  	if (atomic_read(&group->container_users))
>  		return -EINVAL;
>=20
> @@ -1059,23 +1067,6 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>  	return ret;
>  }
>=20
> -static int vfio_group_add_container_user(struct vfio_group *group)
> -{
> -	if (!atomic_inc_not_zero(&group->container_users))
> -		return -EINVAL;
> -
> -	if (group->type =3D=3D VFIO_NO_IOMMU) {
> -		atomic_dec(&group->container_users);
> -		return -EPERM;
> -	}
> -	if (!group->container->iommu_driver) {
> -		atomic_dec(&group->container_users);
> -		return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
>  static const struct file_operations vfio_device_fops;
>=20
>  /* true if the vfio_device has open_device() called but not close_device=
() */
> @@ -1088,6 +1079,8 @@ static int vfio_device_assign_container(struct
> vfio_device *device)
>  {
>  	struct vfio_group *group =3D device->group;
>=20
> +	lockdep_assert_held_write(&group->group_rwsem);
> +
>  	if (0 =3D=3D atomic_read(&group->container_users) ||
>  	    !group->container->iommu_driver)
>  		return -EINVAL;
> @@ -1109,7 +1102,9 @@ static struct file *vfio_device_open(struct
> vfio_device *device)
>  	struct file *filep;
>  	int ret;
>=20
> +	down_write(&device->group->group_rwsem);
>  	ret =3D vfio_device_assign_container(device);
> +	up_write(&device->group->group_rwsem);
>  	if (ret)
>  		return ERR_PTR(ret);
>=20
> @@ -1219,11 +1214,13 @@ static long vfio_group_fops_unl_ioctl(struct file
> *filep,
>=20
>  		status.flags =3D 0;
>=20
> +		down_read(&group->group_rwsem);
>  		if (group->container)
>  			status.flags |=3D VFIO_GROUP_FLAGS_CONTAINER_SET
> |
>  					VFIO_GROUP_FLAGS_VIABLE;
>  		else if (!iommu_group_dma_owner_claimed(group-
> >iommu_group))
>  			status.flags |=3D VFIO_GROUP_FLAGS_VIABLE;
> +		up_read(&group->group_rwsem);
>=20
>  		if (copy_to_user((void __user *)arg, &status, minsz))
>  			return -EFAULT;
> @@ -1241,11 +1238,15 @@ static long vfio_group_fops_unl_ioctl(struct file
> *filep,
>  		if (fd < 0)
>  			return -EINVAL;
>=20
> +		down_write(&group->group_rwsem);
>  		ret =3D vfio_group_set_container(group, fd);
> +		up_write(&group->group_rwsem);
>  		break;
>  	}
>  	case VFIO_GROUP_UNSET_CONTAINER:
> +		down_write(&group->group_rwsem);
>  		ret =3D vfio_group_unset_container(group);
> +		up_write(&group->group_rwsem);
>  		break;
>  	case VFIO_GROUP_GET_DEVICE_FD:
>  	{
> @@ -1731,15 +1732,19 @@ bool vfio_file_enforced_coherent(struct file *fil=
e)
>  	if (file->f_op !=3D &vfio_group_fops)
>  		return true;
>=20
> -	/*
> -	 * Since the coherency state is determined only once a container is
> -	 * attached the user must do so before they can prove they have
> -	 * permission.
> -	 */
> -	if (vfio_group_add_container_user(group))
> -		return true;
> -	ret =3D vfio_ioctl_check_extension(group->container,
> VFIO_DMA_CC_IOMMU);
> -	vfio_group_try_dissolve_container(group);
> +	down_read(&group->group_rwsem);
> +	if (group->container) {
> +		ret =3D vfio_ioctl_check_extension(group->container,
> +						 VFIO_DMA_CC_IOMMU);
> +	} else {
> +		/*
> +		 * Since the coherency state is determined only once a
> container
> +		 * is attached the user must do so before they can prove they
> +		 * have permission.
> +		 */
> +		ret =3D true;
> +	}
> +	up_read(&group->group_rwsem);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
> @@ -1932,6 +1937,7 @@ int vfio_pin_pages(struct vfio_device *device,
> unsigned long *user_pfn,
>  	if (group->dev_counter > 1)
>  		return -EINVAL;
>=20
> +	/* group->container cannot change while a vfio device is open */
>  	container =3D group->container;
>  	driver =3D container->iommu_driver;
>  	if (likely(driver && driver->ops->pin_pages))
> @@ -1967,6 +1973,7 @@ int vfio_unpin_pages(struct vfio_device *device,
> unsigned long *user_pfn,
>  	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
>  		return -E2BIG;
>=20
> +	/* group->container cannot change while a vfio device is open */
>  	container =3D device->group->container;
>  	driver =3D container->iommu_driver;
>  	if (likely(driver && driver->ops->unpin_pages))
> @@ -2006,6 +2013,7 @@ int vfio_dma_rw(struct vfio_device *device,
> dma_addr_t user_iova, void *data,
>  	if (!data || len <=3D 0 || !vfio_assert_device_open(device))
>  		return -EINVAL;
>=20
> +	/* group->container cannot change while a vfio device is open */
>  	container =3D device->group->container;
>  	driver =3D container->iommu_driver;
>=20
> @@ -2026,6 +2034,7 @@ static int vfio_register_iommu_notifier(struct
> vfio_group *group,
>  	struct vfio_iommu_driver *driver;
>  	int ret;
>=20
> +	down_read(&group->group_rwsem);
>  	container =3D group->container;
>  	driver =3D container->iommu_driver;
>  	if (likely(driver && driver->ops->register_notifier))
> @@ -2033,6 +2042,8 @@ static int vfio_register_iommu_notifier(struct
> vfio_group *group,
>  						     events, nb);
>  	else
>  		ret =3D -ENOTTY;
> +	up_read(&group->group_rwsem);
> +
>  	return ret;
>  }
>=20
> @@ -2043,6 +2054,7 @@ static int vfio_unregister_iommu_notifier(struct
> vfio_group *group,
>  	struct vfio_iommu_driver *driver;
>  	int ret;
>=20
> +	down_read(&group->group_rwsem);
>  	container =3D group->container;
>  	driver =3D container->iommu_driver;
>  	if (likely(driver && driver->ops->unregister_notifier))
> @@ -2050,6 +2062,8 @@ static int vfio_unregister_iommu_notifier(struct
> vfio_group *group,
>  						       nb);
>  	else
>  		ret =3D -ENOTTY;
> +	up_read(&group->group_rwsem);
> +
>  	return ret;
>  }
>=20
> --
> 2.36.0

