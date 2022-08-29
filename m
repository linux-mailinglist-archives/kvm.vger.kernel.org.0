Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330035A406D
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 02:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiH2Alm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Aug 2022 20:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiH2Alk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 Aug 2022 20:41:40 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA9911C14
        for <kvm@vger.kernel.org>; Sun, 28 Aug 2022 17:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661733699; x=1693269699;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=WrH5eqOyEvC0LgGpqQ7tJsLz/XAzFZYPG+QwPak9nMA=;
  b=G3PNm6AYKQxTEFnAck+6240VVGqNGbkkBK5QjuDP5XxPVwR6aIW7CILK
   8a2e13WYkMaPjYPiZ7vlyLqDUfYR5WCRgjAzv+Sc8Bn2GbLdMBTXNuF+r
   OYmopw6132ozTW4uF/zRZNqwerS055fpZA4DJ49thJDhIrNGCrztPlK1O
   TfZSrDRBgD7xLQLIgRG+xIzZvSnAQasa1AjnAb+hNWqUA8aVDQih4KbuU
   v+lqiiUhafiOraZDf6KocdkluqFvhjfrtF4HY7D7V68vPON7vbB9caDY7
   8TIp9tndnDsfisJ4s6KDW4yd7AxRMHeCICduQL3VdW6jQ1hwsrpHS8ezn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10453"; a="281752986"
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="281752986"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2022 17:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,271,1654585200"; 
   d="scan'208";a="714670478"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2022 17:41:38 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:41:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 28 Aug 2022 17:41:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 28 Aug 2022 17:41:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 28 Aug 2022 17:41:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=haYDM7SK7llyn09DAmoqa37mZXLb9QbMRLsi2uBlWOaWDEbyN+k/t2p6yhrJulTycxvdtzhK35qFBFJV0Yb5cXF77LOusNa/hWNlkrRZ4WT25AL4Sw1kcLnVhBFrLO8noBiEmoQCYiF4KrCfsBm84XPY3YosmOQKj+Rdl8FYZrE+pABtiturdbrcZhgWUX6Mxxw23O6SdyX5WLgcFcpQ+wSx4FEzou9Ty35bYYZcN5JGF/CKI7jj6tnVZmrtK3p7BVVyT6JhkMmti3+vOBO3sDx3Eyk75ptD2jOwFaT9YbjhSBJ5jU2uqcaabmObuANF9fDouweQfsLSvzw8brPXWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bL3fs1toI03utVV6Rj25Pzbv1Rt9Z+azskcah7T8vTQ=;
 b=gwx5Y37Qk0Zdu1tWHLSn8jQMqXTZiQOICT6+nK/y5ZPcB7vIB7XrZL7GRi+1L6FM5ExQw9gEW2oXsz4vqw+edrAvWKLaGIUdnEE5mYYKk0VGWYq0wf7RLCrrKy7a4jXnlgqJcmBuK2qxdJ5oAbh+PEFA2b9EPHHe6fafLvTEadoVgmmIO0eQ/vZjMJTt8yjlm6tuAUUj0b3gz/gJ6tnwB/zXOmntgQF+lAc8/Ov4i963S0zFUcGBtotGCKBbpX232bmg37eBrmSw1TD7EodhUK7dZwho+QZyLDloAk+ROYyOqhaOpCTWjJwGZZq4/bgT4iLlrKJrb049mKzRCfWwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB0053.namprd11.prod.outlook.com (2603:10b6:910:77::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 00:41:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3432:5d61:f039:aae6%4]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 00:41:30 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>
Subject: RE: [PATCH 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Thread-Topic: [PATCH 7/8] vfio: Follow the naming pattern for
 vfio_group_ioctl_unset_container()
Thread-Index: AQHYslOMkSICI5vzG0+Dhd4l81RyGa3FGtMw
Date:   Mon, 29 Aug 2022 00:41:30 +0000
Message-ID: <BN9PR11MB5276B0A8F6DD36C6482F37038C769@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
 <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
In-Reply-To: <7-v1-11d8272dc65a+4bd-vfio_ioctl_split_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8fd36231-7146-4483-71f4-08da895736ff
x-ms-traffictypediagnostic: CY4PR11MB0053:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aDL14i+/vFscyu5Lto0lIGrFJ/sU2dK/xBAuOuLtlAv6EcayTs9aCT1FVKwnxcYNTlDsSOF7yvY2CbgIFm2JLXJmhsEa/UnF4MANksnipCDVsOflIUjpE7/Qa6ot31nGeavA+HrEATnWY3OIGsAfUOMtSZZHI98RXU4pESkmyZGhUncTEKOheyJgdKu/2nn5fHbXBh4iaZobKK+NHj78TcQvLCacv1fXha4A82Wb1Q/qyXZJLN9nZKkA5QAQKkD82FYRdQcUuzqDqnCGgBOPrG7rlpJC8E6Qa8uwh4dYh+00xHV8uWM8FXQYFYGjn/5HQ+XwiYI3BJGulk0ftDSrDAbehaEmHDSNqYjhWKXlYqQ0oBO7QJlBaU+dWcmx5ORHu0KkQ/aKayYbolFlXoANmxQe6FyRRin8yOEL5mTiouax6hWvebSQ7Gi9RRaEsUQQzDAZci22R2jYdaAPoDFl3tVp/sjir60Ztf0B0VjrZuag5VCNe3F3L+VIs0OaTdQdEKEaFJ7LoVKUOWB6cEMwo5it9B9H27a0IuOMxvBARnFl/0HdVWlCtlVG5vEVcfauU9mr9D7or72d9Ro7BbjfUsy4KpCY7Wuqx9fMaTAXF+qq4AKCZ51teDtoe1p4+8c+U8oXITVhmGT8Py90RhiG2qiWGyBNooTJmPasZ45oKx7gFMNZgBzJCR54npS8HEsNrsQZ0PSmARAwaYbHi/4WFnN2hz7hbfbUTVLdITvglhVPoD6SdW8yFg6HXZ7MoHEcaxWmdjc5yxBR9cTPCKbXFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(396003)(39860400002)(346002)(41300700001)(8936002)(5660300002)(122000001)(52536014)(110136005)(66446008)(316002)(38100700002)(478600001)(71200400001)(64756008)(66946007)(66476007)(66556008)(8676002)(76116006)(6506007)(186003)(33656002)(7696005)(9686003)(26005)(83380400001)(2906002)(38070700005)(55016003)(82960400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q6ojoJy3JxPct66pgVzjOynpkJGFTmBq7PP5X6Z+JYrkfM/OkV0n+pUgDvn7?=
 =?us-ascii?Q?xQAMPO+B/7GoZpicMc7Kzeru1wlDO85gD66XzaEz8LyUtqcjrsy7YlemIyJ/?=
 =?us-ascii?Q?tp1w6vnmpFXwvjg7x0S82KwWTp0rm+1cn753jVjNFEr3HrrvPvJIGmOwCL9H?=
 =?us-ascii?Q?uyjau20tcu8RlhQkQZEJdPIg+hcBfXtO9LwM4hwp/OKSC04p0+YKFX2OxlSI?=
 =?us-ascii?Q?OoEKEDaPADuylWXCqbhjPZA6OUVE44d3XFa5GqAXnmRgBmpgyxoriX+BcysU?=
 =?us-ascii?Q?4M2WZKUDKaR671b6IDjFwHbb9itlHnm9S1NK1NN5uFUAJ4LAAz1WPTIX+PRH?=
 =?us-ascii?Q?dlPQZBzrUuQCspi7GOpQmvuXOq3Uj8tGG4rv+8ZehqKL6Kg34oD8T+i4KYZj?=
 =?us-ascii?Q?Be81iJsbqJq37bIM/Tauk5+557nFxHRV9HehHaWLv3yhiZbG9peIaYPQF4/9?=
 =?us-ascii?Q?asOR1LsTp85wuFFx7t3e1D2VatOYGdFHrv/lBDx1Mws043Jm3eSSbSsjTW2H?=
 =?us-ascii?Q?iCk4yjhEO/HnARCzw9eFZUOm/J451tEp93T4DDeIhjhwkD4z3OI2VSUqEHOj?=
 =?us-ascii?Q?FpXPnjZgnYK074TlvR3pRhB4oyKkKXCgbK6UOXsGkRO3VBVTHCOYjwog8TTy?=
 =?us-ascii?Q?Jfc3xbbfPzTOscW9JM4sTZXwSf4UsnosNx+m4iuevRc/soo8fVtjdcIoF/8r?=
 =?us-ascii?Q?ssxcXbPbMkZEMwqWGJv+RKE/xKgigsaP4tvnpyEbtavnbROXVtOK5yWj2prN?=
 =?us-ascii?Q?YsA0z3wBoPmgDWTcbP8ImcKAu6ky9DnhNWUnlLQyXVmZDhZmJcsALGAB5LVT?=
 =?us-ascii?Q?yu+2b+mBCSjGAQ2GensLpS9lwhCOxcFTUMg3L9T5Yf74XVQyq3A1TOmxUuTY?=
 =?us-ascii?Q?3m6eHKkcXiOWu9iih5OM4VN+DkdmPYmY/K4FXucxAPzeD5fy1PIaVBq3KZm8?=
 =?us-ascii?Q?Sh0UM+VcRNH1MNcrpgr+al+IYeJsu4SoAif18/u7Xe0S8M41WbhzRptREsuw?=
 =?us-ascii?Q?YoXikrbEpASroDqCX4CocchTXXw7pZgdz7JdMvnUF5JtS4Xb0agDVVT0cFbR?=
 =?us-ascii?Q?7ywkneHoQSFAZRuulwr6CF825UKuL3d1JjaA8x3sJEJtitI/waIbl11/AbxW?=
 =?us-ascii?Q?Kel0ftRdt87pRio53CagDla4rZf0gQRPOThHHaRVkGMInXjRyaJpuK+RdwUX?=
 =?us-ascii?Q?R38XSJGYEuAMiB3qB5cID9qt4MGR2JCPJexZcT8EZ81hY6DiVNhIXBzZ1Gkk?=
 =?us-ascii?Q?JEdn8SIyxDX1PhSflUvge2T9xhhpdviYsBJuJNzwbhkMCCLNVnZrXqU7pw4+?=
 =?us-ascii?Q?ynqEuz1nNPg/FpeK/edrMnNDQji+5j5Z0Z3F+dt8ZWLGcCr+ocz0r8aYqr0G?=
 =?us-ascii?Q?AHOKNbaqk3mvcBWcCGNoI35NbGnArMNHrBVjwIomKAVr29iXFG+PgtNDJvgY?=
 =?us-ascii?Q?0RTghqL38cPhcOe5xyo76uVBmtecsBGmbSI+c9QE9NhiaD8oF9npbw7r6nNc?=
 =?us-ascii?Q?3t5U/WlL3AQbWDTuSGkoh3AFz7YQW92GnihNw7NjQb3IYMTrM93DWmKvEALg?=
 =?us-ascii?Q?2HCu3MEcE0675fXDtZAI62eKsZRHFTdCDXpRTeux?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fd36231-7146-4483-71f4-08da895736ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2022 00:41:30.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HhOJUDW3tZYlf9/rt5QVJsZuXWFJEgvpb+4aF5LROZ9sJO0piea6VJ4bOqKZsZgKPLkYLkXOtcb5FWpwwwm8SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB0053
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 18, 2022 12:07 AM
>=20
> Make it clear that this is the body of the ioctl - keep the mutex outside
> the function since this function doesn't have and wouldn't benefit from
> error unwind.

but doing so make unset_container() unpair with set_container() and
be the only one doing additional things in main ioctl body.

I'd prefer to moving mutex inside unset_container() for better readability.

>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index f7b02d3fd3108b..78957f45c37a34 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -968,7 +968,7 @@ static void __vfio_group_unset_container(struct
> vfio_group *group)
>   * the group, we know that still exists, therefore the only valid
>   * transition here is 1->0.
>   */
> -static int vfio_group_unset_container(struct vfio_group *group)
> +static int vfio_group_ioctl_unset_container(struct vfio_group *group)
>  {
>  	lockdep_assert_held_write(&group->group_rwsem);
>=20
> @@ -1271,7 +1271,7 @@ static long vfio_group_fops_unl_ioctl(struct file
> *filep,
>  		return  vfio_group_ioctl_set_container(group, uarg);
>  	case VFIO_GROUP_UNSET_CONTAINER:
>  		down_write(&group->group_rwsem);
> -		ret =3D vfio_group_unset_container(group);
> +		ret =3D vfio_group_ioctl_unset_container(group);
>  		up_write(&group->group_rwsem);
>  		break;
>  	}
> --
> 2.37.2

