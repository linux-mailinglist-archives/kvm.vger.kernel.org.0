Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1AB525F88
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379253AbiEMKBV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 06:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354709AbiEMKBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 06:01:12 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACB43FBD3
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 03:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652436068; x=1683972068;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FijZ+igWcM1ovHU6RRcHjI13Zyka9k7y2w+VDgMlpLM=;
  b=Ipm79QeqrU0qntULNqP5LsixVxgXXRgZyadzz2cEoo+jjbJmBgUbc4Cd
   fQo+ulvusiirds7xRCdVl8vLEduu1OtYiUdQ+gLRa+p1WdkujDR+/a2/r
   xLhy7UK7lmZWs5qsbgiY7drpPwia5xV7KH/qfG7+KsIZwArvgJMwAl1ei
   nAFdM4T75nGjCnFL2U0LFLa0A9z6MofDMMgckfSITP/uzAVnIHXtzYSEs
   AZRb8NhqZq1glphU6Z95yHoX4v3hq7WkWVFy7FybVK373tnyeUIPNr42F
   M8mDIKCEYhaBePXUozVyKTUF+H5jlFxjvSEx+9uAS2taU2dzwVBsHtlwo
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10345"; a="295526993"
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="295526993"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 03:01:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,221,1647327600"; 
   d="scan'208";a="603787403"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 13 May 2022 03:01:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 03:01:06 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 13 May 2022 03:01:06 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 13 May 2022 03:01:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 13 May 2022 03:01:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rt9HW1exj8kxHMT1RCqP5iKvZqnpBceoUQiBuHUt3Krj79IDCssQ8DCtNKvHbsI+4i/M7e741WUWVlDEED0STMBqWQR/9COjg5GPyCJPpeey9Hr/iP0GtgyzfCfWrsOwnVKVylwjYnl7qWPy3itCpM/xI93YoWl8ALxNLWMiDf9Tta7/U1DqVB04rKgWemC/d0fqFJ+p131ayyi358CbCUinNY+/BZFE/3htart9HN+sAmT3xlj7L99Lyn/vtRGA6WMb/nwC/BTsx71JynkQ5wh0l55suE1RAA1fvmDjoSNZHLBAFouDx03tlnN/nGrtKv/Qh+21xm/7Uy3ewV8O9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PovfMAfO/xOLPDxJDBVMpC1rNXS0mSO7ftA4U9XagcI=;
 b=CXR5CiixmLEe+TAeurmsbvup7sW05ZN4T3pPjOPPhhSZJ2gOVQ227f/uQ2BVpy6qtCGD/4GreS1Id0m6uCNG3mRm4rU3sw7Z/VmOCLLMeDBnbYYYUYWgd4Ky69irqHJH8U+bWHI9hxX4/CcCBIUD02prWK7oSqcu/Bv0Hyr18LkPNey/q4MvnhTbNfYFIAK/u/vqGN6rv4UXdzBZtF3/BUbUC0OT9N845NCMQCLDA5xbhv7xk5hDFNmdKvPdn3s2f5NUfltVLoaOlIzjhNIiGU1V6hgRtBp8ldgWrOYYU6d8DidU1htO8fViC4p+ODTjiAHL/7e0NR0RUjArR1P18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6121.namprd11.prod.outlook.com (2603:10b6:208:3ef::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 10:01:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::24dd:37c2:3778:1adb%2]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 10:01:04 +0000
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
Subject: RE: [PATCH 6/6] vfio: Change struct vfio_group::container_users to a
 non-atomic int
Thread-Topic: [PATCH 6/6] vfio: Change struct vfio_group::container_users to a
 non-atomic int
Thread-Index: AQHYYN/WttFcKG2ys0ihcKSizAxlla0cnqBQ
Date:   Fri, 13 May 2022 10:01:04 +0000
Message-ID: <BN9PR11MB527608FC89A4B5FC5B2BFAD88CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <6-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <6-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed9ba697-eb19-44aa-6883-08da34c77e15
x-ms-traffictypediagnostic: IA1PR11MB6121:EE_
x-microsoft-antispam-prvs: <IA1PR11MB6121DCFC49DBA4F6627D54CD8CCA9@IA1PR11MB6121.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lj7SqASgPD4fVfDyUOG24XI76wUpoc7pdvn0L+oHStQKCrYJFyXaGgZE5YPqozFVBHYGNOhJyVoTkM/zsGE49uhTpeCEgD16SOOcDdNAE9YT5t2aj2jQWMVAu9cG+GQboq1612NmFAiCcPs/6yx1eKineJK7fSxeJgR3pf09w51HV8aeFSPoz4ZbvRoQb8+ni2vDzvTzlyuzwYOSoxznM13zbwUc5e5swSIQ0KVgb051ZqdKD68cWH6DN/7yzx/T7IBoW1sliMSQkLfxIjivMOrxxELUkd9+O/iNkC9L2RRJswVT2EqtZxqJUvFkK5dQfCrz5YKudNpPzIwv6gx87X1m6luq+dCck2A2b90ytmrXkhBb4842NEeMA7Do0xWKFVFfmznHC7z+cnCb2JUxdYRaTi4AA1x4ogpmylSf1gUXdllaXfhyxktaPwYqSu3aLvmtpsnq3cNMn8jO8NFLd6Ndjgds+TvwJk876agd2HIVrQSAL7qnzJb+S5yeO7RgYACDQPRGwzWirBRURkLR6YSNREO5t3YkxhszOuiJfn3A9wu6dicLBeKzn1XVcgbCYH/jo9GSmYLGN3a0sTLlGXMjuW7x+/3F9x5tmxp38BRdpkxj5cQ2s3VQmdQX+Xq60JSdYnhwfS6Q/0Pa3XPwiFYwIoc+MWeRt4xHussOd4mfGF6w3aK9vmtf/jXAGgasosGKKo6ISWCTvN6rSXqqiA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(66446008)(64756008)(186003)(71200400001)(52536014)(66476007)(9686003)(83380400001)(2906002)(76116006)(6506007)(7696005)(55016003)(26005)(110136005)(82960400001)(66946007)(316002)(8936002)(5660300002)(4326008)(66556008)(38100700002)(38070700005)(508600001)(122000001)(86362001)(54906003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PTYHnNvv5lQofCXonpwJEpzjgNcpJT4yOXSlXdcXYE5CkP0t5hadWzftBQnt?=
 =?us-ascii?Q?kTtJCqGBiEdlchILf+gocBlUqhUX1VrIDuyekUmrf3QweZ3T6FZjgVe8nWSC?=
 =?us-ascii?Q?jLp4KqaiiYzOZfpkpY0aRGfwrr3bTXbyWQEezD9MOYYOhsn4A9HPB/DyTt7A?=
 =?us-ascii?Q?dopE2edHBHpwnla2ecZ+m74crQ4SKd4500r9oA7uQ4tzvTATBKVJUMwgAaD6?=
 =?us-ascii?Q?JP98OV+f4ydLw7AIr+UG1YigIY37aEM+k/yeXre9UxbeJ4hjQIksZY1MiocZ?=
 =?us-ascii?Q?vaCpO8beZKe0+RgYQLo9v1quuTuXxP4M05mDcYQiF+UbrOp22WrW9/gqjS2R?=
 =?us-ascii?Q?y7PAapwQfy049RNhj+efYK8DUB1+jO990WYrZJRSsI9sWm9LZrM/a0RZFFv6?=
 =?us-ascii?Q?Xbh1QYcXMfQAz6reN3DhEDPlDwDbNMPmvhdo8DXoF8mbC8zMwh1hQbWYJXRl?=
 =?us-ascii?Q?I/V2+jgCuudGuExso/Mo3iokB32N281Cir/U8w4OXAIQzVjvX+9G/+0Jellg?=
 =?us-ascii?Q?LU9NxmZbWAU3x/RRnpLxhauMyHHHd24+3UNqYOGFye9Zvjkl/Oicn0JMk1X2?=
 =?us-ascii?Q?LG0nc73vWo2rXiUvz7iZtLTD8Qg8/C91AVCfgoGpa8c2Npm7GcR0H0DI9KXS?=
 =?us-ascii?Q?m1u/WsYLh2PKB1FcNakx2+eUUhqsqp7P2FqnXK+lL5KNE4l0teE0AgreKYlH?=
 =?us-ascii?Q?Ze+2Fhz6g/N354rOakc4SY1lAd0DlgUaies3zYNYqQlp8hdhVkr00jemxJAs?=
 =?us-ascii?Q?DaTY/LFbKsBewNZnnSUPHAzQYzNALLWUtpM1AX+a80ZXgCJkW4FFUPjlLUui?=
 =?us-ascii?Q?oL0JpcDfhGPwO1c/801gus7fHu3dEM8B9MhMjrGQTnV+5neKnik+8KP5co0Z?=
 =?us-ascii?Q?k/jv84p3/XXw3qo/9mUbzDB+ks6/lgBlqX32LSD126ABHF9mPOC8hJfOocfC?=
 =?us-ascii?Q?XpfG5xd1JPkXoYH4CXmPXvDF8K/UI2BCydw63uYGRERWrSkWR1B6ce48aACE?=
 =?us-ascii?Q?yn8UNxeeSzU2kYP0/LkcaKjD4q3rFGl4D35Iki+ihU6ETbRX9RaFxVx+t+dR?=
 =?us-ascii?Q?No3wbr2cgFwl6QELBXVN/whZl/1SBzksXxCoTUw2bqQp0kfEbLzoJqAYl6gq?=
 =?us-ascii?Q?n6to2jlwa02xLPLKqbFangKBx3cqcBEitaiGp3hGT9thHYtrOMtXgbSFhoLS?=
 =?us-ascii?Q?V55kR4yD5j6hYz4kBY5JUmuiNIyAakF7W7DjUt3WQWr9OkhOvG0SdkM57JeF?=
 =?us-ascii?Q?kVBZ8jIr0iHfjdtMTp1OmybRCBe1RRAzniKWf+VnYO9UHChjAynQ+W1FBZEQ?=
 =?us-ascii?Q?rvJsTAKboT3iny9i8logszEOQuJwBsy+BpOwo1Wr5MZE6qLs384TPuVDZklq?=
 =?us-ascii?Q?EWjmGMCqIWk5l3dy0v/h6/q/mRxl13l1wkiB1mhDyzJhlWkTo8EzSqKtubvK?=
 =?us-ascii?Q?10VuC0MQUs5wWyvT0EVUwcarT1qYDqg46aptEnArXvvw+j0vuJZ3Gb9s/8lL?=
 =?us-ascii?Q?TxETJMG96Ls7eJLiBjkEizP3lREa3TtqhCEKYxbrPD8jApFFQb2bExCKHyln?=
 =?us-ascii?Q?IcJ0xEYdbBXPUWOTA7teeZc8+K9lkZ7bQBjvyIpqIXgU85FJj4xKmDoc3xV+?=
 =?us-ascii?Q?6HD0PmmrQE3sMaBxvhFDdXjk1GZux7UZ+RqjcnNGfbvypG2ikaWUqOhHsObp?=
 =?us-ascii?Q?h80OUR/MqffFk5XZP6D0pS3UP6SqG+ByWu6T5VtkDJhp2lv/hsGY7ey7jAz5?=
 =?us-ascii?Q?MyfIpQsVug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9ba697-eb19-44aa-6883-08da34c77e15
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 10:01:04.4190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q9K7LIIxhG7GopCZLJf1RdMbhradx934sAND1JVupivXhULZQlBxPYYkhvwQ6K3mqzdJ3RGuqEY5gIF7d274+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6121
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, May 6, 2022 8:25 AM
>=20
> Now that everything is fully locked there is no need for container_users
> to remain as an atomic, change it to an unsigned int.
>=20
> Use 'if (group->container)' as the test to determine if the container is
> present or not instead of using container_users.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c | 28 +++++++++++++---------------
>  1 file changed, 13 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 94ab415190011d..5c9f56d05f9dfa 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -66,7 +66,7 @@ struct vfio_group {
>  	struct device 			dev;
>  	struct cdev			cdev;
>  	refcount_t			users;
> -	atomic_t			container_users;
> +	unsigned int			container_users;
>  	struct iommu_group		*iommu_group;
>  	struct vfio_container		*container;
>  	struct list_head		device_list;
> @@ -431,7 +431,7 @@ static void vfio_group_put(struct vfio_group *group)
>  	 * properly hold the group reference.
>  	 */
>  	WARN_ON(!list_empty(&group->device_list));
> -	WARN_ON(atomic_read(&group->container_users));
> +	WARN_ON(group->container || group->container_users);
>  	WARN_ON(group->notifier.head);
>=20
>  	list_del(&group->vfio_next);
> @@ -949,6 +949,7 @@ static void __vfio_group_unset_container(struct
> vfio_group *group)
>  	iommu_group_release_dma_owner(group->iommu_group);
>=20
>  	group->container =3D NULL;
> +	group->container_users =3D 0;
>  	wake_up(&group->container_q);
>  	list_del(&group->container_next);
>=20
> @@ -973,17 +974,13 @@ static void __vfio_group_unset_container(struct
> vfio_group *group)
>   */
>  static int vfio_group_unset_container(struct vfio_group *group)
>  {
> -	int users =3D atomic_cmpxchg(&group->container_users, 1, 0);
> -
>  	lockdep_assert_held_write(&group->group_rwsem);
>=20
> -	if (!users)
> +	if (!group->container)
>  		return -EINVAL;
> -	if (users !=3D 1)
> +	if (group->container_users !=3D 1)
>  		return -EBUSY;
> -
>  	__vfio_group_unset_container(group);
> -
>  	return 0;
>  }
>=20
> @@ -996,7 +993,7 @@ static int vfio_group_set_container(struct vfio_group
> *group, int container_fd)
>=20
>  	lockdep_assert_held_write(&group->group_rwsem);
>=20
> -	if (atomic_read(&group->container_users))
> +	if (group->container || WARN_ON(group->container_users))
>  		return -EINVAL;
>=20
>  	if (group->type =3D=3D VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> @@ -1040,12 +1037,12 @@ static int vfio_group_set_container(struct
> vfio_group *group, int container_fd)
>  	}
>=20
>  	group->container =3D container;
> +	group->container_users =3D 1;
>  	container->noiommu =3D (group->type =3D=3D VFIO_NO_IOMMU);
>  	list_add(&group->container_next, &container->group_list);
>=20
>  	/* Get a reference on the container and mark a user within the group
> */
>  	vfio_container_get(container);
> -	atomic_inc(&group->container_users);
>=20
>  unlock_out:
>  	up_write(&container->group_lock);
> @@ -1067,8 +1064,8 @@ static int vfio_device_assign_container(struct
> vfio_device *device)
>=20
>  	lockdep_assert_held_write(&group->group_rwsem);
>=20
> -	if (0 =3D=3D atomic_read(&group->container_users) ||
> -	    !group->container->iommu_driver)
> +	if (!group->container || !group->container->iommu_driver ||
> +	    WARN_ON(!group->container_users))
>  		return -EINVAL;
>=20
>  	if (group->type =3D=3D VFIO_NO_IOMMU) {
> @@ -1080,14 +1077,15 @@ static int vfio_device_assign_container(struct
> vfio_device *device)
>  	}
>=20
>  	get_file(group->singleton_file);
> -	atomic_inc(&group->container_users);
> +	group->container_users++;
>  	return 0;
>  }
>=20
>  static void vfio_device_unassign_container(struct vfio_device *device)
>  {
>  	down_write(&device->group->group_rwsem);
> -	atomic_dec(&device->group->container_users);
> +	WARN_ON(device->group->container_users <=3D 1);
> +	device->group->container_users--;
>  	fput(device->group->singleton_file);
>  	up_write(&device->group->group_rwsem);
>  }
> @@ -1308,7 +1306,7 @@ static int vfio_group_fops_release(struct inode
> *inode, struct file *filep)
>  	/* All device FDs must be released before the group fd releases. */
>  	WARN_ON(group->notifier.head);
>  	if (group->container) {
> -		WARN_ON(atomic_read(&group->container_users) !=3D 1);
> +		WARN_ON(group->container_users !=3D 1);
>  		__vfio_group_unset_container(group);
>  	}
>  	group->singleton_file =3D NULL;
> --
> 2.36.0

