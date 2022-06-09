Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BBD5443FB
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbiFIGoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbiFIGn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:43:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E5A1498E0;
        Wed,  8 Jun 2022 23:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654757037; x=1686293037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LpFX5HYqOze1e2zU1mYIP3BybYHnjnioGZaN43V1770=;
  b=id2E+u+FGrk23R7VeQJH9Uhe5yUofs+UJyJ9xk/4rZtHDaDKykdZRljG
   xnNglPUIaTGOoQanTNGLM2lYGDebNXV4WFAxlBMMb9Tlp8wIq8kJlQLka
   xhd9RNhW0/ujp7d2yUGGZfjpA80HH0UqO0rUbBUupjQ/vTLdZP6Q5iR7D
   4E2Ns6OjBX/iQHYhhCYaMPYUhx4ypKOR5LVhYifWAXla9w0UHdZHADI/s
   +CJOD6sSk2tF1s/W4SKZo1ERWy6J6owiHrbQLR2azlQcx4ukU3YRCB29A
   HiIst2VFRviJGWqaw5ISQDPIUOEeMADtRMC18jvNWQ1Roe7BPirVnu9q4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="302538227"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="302538227"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:43:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="580435852"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 08 Jun 2022 23:43:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:43:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:43:53 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 23:43:53 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 23:43:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5c3jkxgh6C94uPb5jy7tXo7ZhYvvIpBAu7poGiQaRY+nhqUT7jxBxfDF0gUHiBwce4BpnOoJjyFxs8UoIOhMbUfm88FzK2FTtuI4sNrMZAd+nmYvIZi8r7E1eiwePv3aJSqqHKnBhFx5Hvcn2wwSNE4HPR6PlIESuzArUuvzSZlERzUZLIgV5hGhWr2Uvna0cRAEniPobRtTN2U7SZ2rrIzZQO/Ns691IllWZIl5TTCe/5JyVJf2/Ae0FVHL+dQLpKL7Pd52TM+7gnvR19/ZO/5+Q6snXkk0VF4NpFspoP7Vc5ZfjCZTiJYsfwkZS4XEu4Eyjz6zpNi1AKmd4ZFKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77jxmeVSHlbIanbJDv8/Cgxh+4O0ESG06LW8Q/32sCo=;
 b=KFaEfSOmKJDbYyZeYVGfkaL7sf46WTUL2K+4Y/93NaNhlN7dz8mvAK+Ddw2LDdjubAadGFkq62i9/42FNEi7VhHVGHeL0QnKIRwcXcVdHk6aExQXu1hAdZ/gGKZbeOvsiu2ctJ4/DlivyyPMxbYFhV16YAqChwNgHCEsc8YwE9aTCBbQ7jh4Uj+//SAA2VSDshG1T9dTm3eeThe81IKdf5yDFHQd30AH8w40CBvWTBoHfL1UAWATFa4hUmh6mazrYGbvKI+KMW/0hCo/vQ0JavKKspwceg1fwlSB342Cpt6c/9R8bDYewKpU6UJq2asdmQ+8swLR5O6QKxKdXvKjdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3905.namprd11.prod.outlook.com (2603:10b6:405:82::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Thu, 9 Jun
 2022 06:43:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 06:43:51 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Christoph Hellwig <hch@lst.de>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Alex Williamson" <alex.williamson@redhat.com>
CC:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 1/8] vfio/mdev: make mdev.h standalone includable
Thread-Topic: [PATCH 1/8] vfio/mdev: make mdev.h standalone includable
Thread-Index: AQHYdxPyXXwIQ/fYZUOQIYCq1hPaHq1GqCXg
Date:   Thu, 9 Jun 2022 06:43:51 +0000
Message-ID: <BN9PR11MB527693365429E4487F8E998E8CA79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-2-hch@lst.de>
In-Reply-To: <20220603063328.3715-2-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9d78f62-61e8-41cf-fc69-08da49e36a0d
x-ms-traffictypediagnostic: BN6PR11MB3905:EE_
x-microsoft-antispam-prvs: <BN6PR11MB39055CCB7D44B5E99A111CB98CA79@BN6PR11MB3905.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: czu2yPOfbS/+VIMcMnVRZ7/dQSXiqc6C/++jskdyQNx5xh4ymG0IVsEncD33tFxx9pjmbFUVAJGYGw9xmu2AfXTA639qI6GiUULOflau1OmGwS3S8pMrML5kBvrfV4PJIgR2HLjiKBZionOFgm722QVuS+oNzp4MrkX4pkwRYBn9UuxzSDbunbOwt9epFPWO1oIBYo350NEH+G4pG5lHUE6mNz7XZzJUUMDkiZYGIE7iJ24uWjH58mqYywIB+ZtY28SncJ7U82MO3UDM7O83rRPECB5vRuaYC82TnSBXUu+QNk2g3Uf0kJgpgxWjZmqoNsiDEYdVxaYguiHDJD+54iVuA8OlqkGtvfsJ0mf3IeQOWDchb+F+g4zsThvNS97/BrGJYAXOfa9o78GyRmjATkF5QgWtt8l+1pNpQ7CJ7jXfVVSOoRSobqm31UfSX3ScE/O5Aqu8/YX7R9GGef2NBRnQ6hcPdv+By4On+ebhusOYiJVp7MoiFtPbP4HUWAHWXastYNExLHi0sUU2Bm6Ttsb1sdK1EYVVRtPXBZMpiBOm0PwsqkM6Oze48esrQASwA1rkb2S8nbi9ej6OPfIir/1kN90uKypWGa8sbCgwayGPv3Kd8Yubse1lMD2XYk4jId788UVOrZQ+oKTQvMKwIfPkzHCeGjx/XryrGV6IhpmaUEfZoY95PDFFa5msHtlWipwRS0Rps8LzXRKJQPKwXVQ1oVTGl3u/sjXeS3uc29Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(6506007)(26005)(9686003)(7696005)(38100700002)(921005)(122000001)(82960400001)(508600001)(38070700005)(71200400001)(55016003)(316002)(110136005)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(8936002)(5660300002)(86362001)(4744005)(8676002)(7416002)(33656002)(2906002)(52536014)(76116006)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8G6OwVGBV10BKByK3/lU03Lqk8aDl6JVfixrgBCE2CTC8PSPTnMLmeOShPhz?=
 =?us-ascii?Q?ladQ2CJhohH8eocsAL+xaoenQmeRnOjdPeB6xnbxDjhFPkBjyBbeaVwZmO87?=
 =?us-ascii?Q?F4cbCux+9RduQY+qEKYwH5FSJk4B3G454ZsXvxCsIVyKHKbjeDsU9j+i/fQa?=
 =?us-ascii?Q?O8NiT04+rFVivdeOpCP0+sEQo8rXoBQHxMXtQrxdljk7I4XDGLNyQg0Q2CPM?=
 =?us-ascii?Q?gnregRi8m5CH8Y2VN6Bxub9qE+KGYOewyQE46be41ziLahMWEJdYpRXVfo9N?=
 =?us-ascii?Q?K5BWLS5DfOiSsh0u0b+ju+wnHP4PLPH3ovFMJEMm8H1a8ZL6BQmx5+RCIr4T?=
 =?us-ascii?Q?WlJxip9GtdmnG3BvMEYCFc5gd0ZA12U33aTsNtYkb+0ctlTG/1CQOVnqmAH+?=
 =?us-ascii?Q?jHTak3w6Nh+QWH6QUDw7+a1PtLMYSAkG6UySgLh0oLp54M50D3878gGK2Jhv?=
 =?us-ascii?Q?tPIwFEIv8hk3int8UlZw7nuJ7ppDI6oEhC6v0D4OjAZtD6jDz4kYr4TyAJ0c?=
 =?us-ascii?Q?LV+iXZ9chKb7FMbJQ6mmIS/XjO3k60uajpYQd8icSDSGHLiWX5U65Ts+Zw+I?=
 =?us-ascii?Q?zf3rONwSsxJh2UsM9+AfRc5gs8+YtsbhdXN3FV+bj9az+LpxBV14zwf2Ospz?=
 =?us-ascii?Q?Kweha6JI45MQKbwH5K54XqxWzm52DEzVsDEqi17gmz1Y+SSxZ+b5xaAUGMnH?=
 =?us-ascii?Q?VKaPYaAZPLVtFw5vSAW3edAmLlTWJzs3rd6XCvD+nhA6fnpGY34eU0mSIL0C?=
 =?us-ascii?Q?OQUBSmlOX4fanhlE+5fl685VIAi48K1lKOh4wkLmESQfwxXAqlheicATmxyg?=
 =?us-ascii?Q?s0lELBXabJCq4cmWnrZSxSX9bwhn1rZ/yeD9rR9JzHfdM6Y4oRd6BMAqEGCO?=
 =?us-ascii?Q?8eb9PeSwev9gLNykW9XmjvKrj2Si/Vo+d2qyKvqFxiylYs4LntCtrQEYpoGV?=
 =?us-ascii?Q?gqKjf8F1HyR1XwibdQC8fz/i0wxjZ1qnsTopEdVXiq6IHUVfm/zgNLgfEuP0?=
 =?us-ascii?Q?goEceACurrNul9cWMxYIYCdbXqku8crzgKEuD14n333GWebrSuGMvHpPFUxx?=
 =?us-ascii?Q?c2SCUWmntybwfW5R7QjZlHBjOmexXcHdd/PX9xwKyIR7+SFQYISrMbPAEz2N?=
 =?us-ascii?Q?yJChyJ6qm02eFlF63lNGye5DHTO8KDF/DyXQQFnWIl2NVLF8M95WKHz9QG2v?=
 =?us-ascii?Q?44qDox++Wz4++CcztYVTQlSEUONtbpo3ONRhAS7LctJZlW6fktOZLWrINSj/?=
 =?us-ascii?Q?1e1p4G85oL7k+CxUNnUTmsx5dWXBJtBq0ZePVRfjl7FadbRam6TWK19R5XPX?=
 =?us-ascii?Q?UixWPfEMOhQTzqs8Bt6tDhZX556sOa/xSfKHOS3PeXqHn8aXYvf2zrDB8hqR?=
 =?us-ascii?Q?ntHdYm96uKPNTo1cn9QwF6k7TcYQm9KD5KsuKknHWwa0uHe7O+A4luSpGqSJ?=
 =?us-ascii?Q?diu188DldgCRnhtthRbW85ok+IULNLsbyoUTbR5065t4EPvxPXD1nwFRxrrF?=
 =?us-ascii?Q?LYnUu04WAqd9iL9KKyDDs3YRhvslU7CsOpXNG3tVYekkdvoN+YO8Vfv3Wse5?=
 =?us-ascii?Q?23/SDGLvwmQOqlgrwTiYml6pXUKW4MHXSuyZuDPgT+USLBu3UFs9rvD7/0RB?=
 =?us-ascii?Q?FPSxNdtxRWVyz/JJLHQ5WqWh4UZTeclunbFfU96GRHWstymmajA4IFhiocfI?=
 =?us-ascii?Q?wiKsW+NrKQK89MosG3BreanCuVXygmFmm/S8gqxUnRLRTVpUIrj5K4kMuPM/?=
 =?us-ascii?Q?d47kW9TEOA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d78f62-61e8-41cf-fc69-08da49e36a0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 06:43:51.1738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLaDCPNDyT4yarvqfkN8w0quED+9NDHZGyOQwBWzoDhrXR7zhCwHfnLCs+DryIOILVV7CXNDOVFm4xyTU+cl0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3905
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Friday, June 3, 2022 2:33 PM
>=20
> Include <linux/device.h> and <linux/uuid.h> so that users of this headers
> don't need to do that.

looks the existing inclusions in those users are not removed...

>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/mdev.h | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index bb539794f54a8..555c1d015b5f0 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -10,6 +10,9 @@
>  #ifndef MDEV_H
>  #define MDEV_H
>=20
> +#include <linux/device.h>
> +#include <linux/uuid.h>
> +
>  struct mdev_type;
>=20
>  struct mdev_device {
> --
> 2.30.2

