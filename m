Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02BF0544454
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbiFIG4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238187AbiFIG4W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:56:22 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DC02EB6AE;
        Wed,  8 Jun 2022 23:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654757781; x=1686293781;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vd/3nhIcJb5m5VoufzkyO6OfVbiq1dv9JAQjUkmu3Ho=;
  b=ivJPdHRaMZ8/nZr53UqfqVIbLnXggFNNckfeF8fNLPqWdEtFZbzfl46Q
   6ZSzMGk3pdBmTU/n0LAagpsuEFIpNplsahMXVYCtC/OGt9+FClqpuCcqf
   7lGXRJlD5CMHwUCaAhYh1Mtp/nfSnLVSUafFam8JEk7rNO8Vh1L6Gqb2r
   bBcxndGOND65l65GXeAMg0IpwZ7KR5c9nZLwaPSGq0IZBPqdfYSowI+In
   uiEWb13eNNk4lT7yh28TO5JXAL7B71kLrou0CEyMm3SJuO6KZ0y0NMAAm
   TIRjbrC01AcaCTcel4fsN6hnhiaB3IBBvPDRkJOUFXduQvI3NURoHhc1v
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="265959829"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="265959829"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:56:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="827416712"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jun 2022 23:56:19 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:56:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 23:56:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 23:56:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKkKUheI0TbhTOFCH9Z0gDdpudGmGSJMinzyjg0HBy+GpaCfAUxvt59uJkC2cg7a5EZ3hRrpt04hbuBgL/KwtE6KDl0voJPtwcoLGUe9pwdN0f0X26rRFEk95/T3h1UVb4tfII6TAyXxiwn1HQOorYfOZh3sAMUk6ioTcogLHNiGF4Czg2Iw4ID71wFnTtijCNJDKLOOz4A7czpIZexsx2AIchH6+qU8KznLio2FSdU5pPlSHgkwnJpYyAElGcSz2hlc+nLbh6c/8OU94drMdz3YELp0pn2hCg0qWksfMIF9RiZvWa/jzOpqdE/Dkuc+uGYaxBLLeUUzR1qL+y4Ygg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fdxvgGdkOW1PmiAjEcA/K0jZq1hEmmMJtnrM4IFHDk=;
 b=IHCWWlrvmn8esiG+GFHQ5Zs3dFE3gEuhhcoMx3aQWvLFtXuAvRhzPlTTHiUtQV38V6tnaREvnQ/XtbcXmvX643sUie4zprOT+UDvxgKOR21S39JnasqRC0UJka98qBDfAUANL09sFzj/Ov1suIuwKW+pkxO1+UYM0tjL5NuNMA24659v2k/3FWA3AtNWIVLYanraEEBsHH3ghDxOT/AnBxihjvIXzv8tw8+aO0Ok/At5tc9PA4MPW2qRRjBKU9GDpTf1GylF0fA+22pnQP8bcKHFqB210aspFttMjH/dUGznoW3b67j7y4XqylGdpQqLvgS7PK55/M25TVsTYglv4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4976.namprd11.prod.outlook.com (2603:10b6:a03:2d7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Thu, 9 Jun
 2022 06:56:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 06:56:12 +0000
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
Subject: RE: [PATCH 5/8] vfio/mdev: remove mdev_from_dev
Thread-Topic: [PATCH 5/8] vfio/mdev: remove mdev_from_dev
Thread-Index: AQHYdxPrFSkUbaGaeUmE0X8H4V7gv61Grb6w
Date:   Thu, 9 Jun 2022 06:56:11 +0000
Message-ID: <BN9PR11MB527627010600ED61C002DBA88CA79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-6-hch@lst.de>
In-Reply-To: <20220603063328.3715-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef9a4c7f-c5ef-4153-bc3f-08da49e5238f
x-ms-traffictypediagnostic: SJ0PR11MB4976:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB4976808206479B82C98B925F8CA79@SJ0PR11MB4976.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hzJvr+tXG4JPQJLliyv2gK56GPu0klWoxGowceMUWkiujxefy7rpg4q4/eVkI9e2FOmZpm9zsPVKLKDTFGjgkODCT9g2GDlHaVD3wJ7APugudIvKs1q5P+YQF2PGrwCrqhErEOVKx/6US7TWsx25eQ8U/M9n1H8BRmSW078/LBwN+z5n6GrK9p5xqZcO6zM9FsMDKRnLzEygwSipwWiyWDWPrz8wW4pTp3VbTcVP3Le3yki6em2UG8ZNnnTfmCtqXnIaWAWIJ5aWPpmb8+2hw/tVC8uGkwXY4nICstgvqLcldlHymun7/hcUlvrrAMiWc/7KJr2+V3sxJqDZbZDsKca2S3bDKHncgG+zDM++GwtxxN6kkuArgMty9fAb3YEq3XvStKepocCZK7SEuz4dCb/WQW4ZKAL67niHrcmjDP1/yKCZzX4468Av7TIWOv0OmF7QkauS4kgODSnnFnxzshZuLt327nw+zpncCqm1hfRKGh4nkSGiAuzgVfEp7lu0v22bvxSQ7OOM4R0UyFNedGKbAjxBiICWKr20eKnhA3mZoOiVtYsQCFacFZu5pZOTZNw7Gg3SHJxU9EDD7yNjjhB5Up1AcdYpPBuNf06CyrMmyCY21iZ+hL6f9OGw59C9Az/enR0yQK1cfU1hAJWEVgQSE7/Qu2F2iJOu4/bas/S6NAHJMEwgJAcGMu0u0rv79UFDml6jzjx43LCOKsWlDQvRt6T3KK/S2C4LG9R3ZtE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7696005)(2906002)(6506007)(83380400001)(8936002)(7416002)(5660300002)(26005)(9686003)(55016003)(508600001)(52536014)(316002)(122000001)(110136005)(921005)(38100700002)(8676002)(4326008)(38070700005)(33656002)(82960400001)(71200400001)(186003)(86362001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?abDnudpg1MXW8SN9u24Okhdd81RhlgLOlexuijHCTiIgtx8qFnzoqZJMrP7z?=
 =?us-ascii?Q?+KkbgbZU6lHAGl/XucZODdwX+eBRq45OGd0mUCzlwgvrc/Xay9qyT71Up+NN?=
 =?us-ascii?Q?uJS5aKL4okvXsQ/xTgFfGEjNh/vduqJyWApSqqtjhmA/DMBp1LgTIngbv7H2?=
 =?us-ascii?Q?88IMMxqOA0lwy1l5GJ1DAplGIl+ghno9ap6AAINfE/RbGt5Ym4hK1/sAQ6Qt?=
 =?us-ascii?Q?5jymew9l/0JG4jb+e+qyfXMpzMn57eItj3HnXvUtmt9FdcaUyd7wMw/nj1Cg?=
 =?us-ascii?Q?rDwi8VkqBJ+kwO1T8KlI7I0Sy+Hg5SDa+gKO10DJQWUKbXcnxxkLEfdcFSR4?=
 =?us-ascii?Q?9ZiknGNyuaeBH3LxrolXE6A0krkbw0LgjWIqNMIhSfaJ7KODtz+JcBiI5HOh?=
 =?us-ascii?Q?/i0WCo9PvIBxg16BB0cCvrJTjebL9sp8FJ+vY8PZqry28QRX2CnEssUYp93p?=
 =?us-ascii?Q?YB2JMKi6ovOdmq4jSVYPiYKNxvWd+eDqMA9XtVmXgKeoh2I5vBjhtyc0apkh?=
 =?us-ascii?Q?nIbWhwMsKsikbny9+6hNBq//u6Yc/Vnvq2j1WNTy9yR90vLxM4pggwmAwIbI?=
 =?us-ascii?Q?VcI1uQMTwBLB9RTl/3q8YolIWhp/6JRTiHOeTWjyuAQsKSkUKPYUyCTc1wUi?=
 =?us-ascii?Q?44tfQC8zP7J7eu3B4u6AZz0qeoYN1MNW7rfQ7FxEwo82fCuQihmUBe+92Nlp?=
 =?us-ascii?Q?IyfJfL1HU/da4okllF0y981PLpjccNVozMopCyvKPLnydgsEOK8gsRAkZNOd?=
 =?us-ascii?Q?hdeDwAJMArTDtCQbT1AoZyrHlYbCISgU1JdLRGVXE0x2hyhmNhzytPqBU6wN?=
 =?us-ascii?Q?UcSQf/caZ1WMgrvmruF+mEb/MVzkpmBNBdAmUtodc9Ib9RCBRGt1ZiYQ1urS?=
 =?us-ascii?Q?F1V8cRIrtBrbc3O6GxeFUTu0mU76VJTKZsfzZbGYZ4Hl011Cg3fWfRwffvhK?=
 =?us-ascii?Q?AkWcKV5yGWpDqxkXn9jm0WDLgfsCPW+94Kidta5iArMLrqqXygY/IEh1gtc4?=
 =?us-ascii?Q?+vhcxAs2/KdzZyuUliKF6Lq5XV8ldAGkMxFpdb+Mrlv+fjiu/yURxk29pLxc?=
 =?us-ascii?Q?+s7YVufsOPmLcS2TgpXs9Ifuy1ARe0Pa7hmX21qDbR7aXRMRfQtSx2A8xwzJ?=
 =?us-ascii?Q?+JWD2LU3kJv0Eyiiqqs49KEwSENLEfeR2m/fPHUhH/LKE+2+XalfZvWs/IrQ?=
 =?us-ascii?Q?zidUolSwM4hgOXufAp6o/+3dhHyd5txf3F1rojRy/tKclunku88koDd/50Is?=
 =?us-ascii?Q?oPG9t5NsgvS0erhphtGC7DsYW7PK/M2oOHv6OBQ3wAS4uvZ5tCi5kJSr/Ta8?=
 =?us-ascii?Q?p34vyBPzJXE1DMqmkeA+h/LZbX51HQT39h41+yjBUFeoQ9uXOiLvE6+5S8KU?=
 =?us-ascii?Q?3gHO6Fq5CSmKO/P38HH3lpcV9Y71ZaSPxleq3ZL6TkaxhvsBAdhx8mfu5hxN?=
 =?us-ascii?Q?YjfFf/WN5etL3VLcqDNXAkYwBgQCR0F2sT39ENkYzQvEJ9o6f8NrrXFNcYi1?=
 =?us-ascii?Q?XZXlSWcrf0EgOvPrgdj5zdhHlzdxR2/wrjmCrjN+Ion2mmfFq4RPkkUt2Ucy?=
 =?us-ascii?Q?0fwuRDZq9iFeG1pkCXrkFcsAXgYpSRaMzk+f3KQa4fAb4rDWbVigepbRyUO9?=
 =?us-ascii?Q?GyktehOK+XxokdjlCSPywYJqB2xIqSeIK0AckQo+YjzwBEvz4oQfa9edL7i7?=
 =?us-ascii?Q?L5mY145IZ/NkyuvVcbWqZf7C6V4P/sUMmNxa65b5OhIGLrbz4bYVPW3uszBD?=
 =?us-ascii?Q?FQBjgJWF0A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef9a4c7f-c5ef-4153-bc3f-08da49e5238f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 06:56:11.8682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CO5kWsnMkMwh+M4jBpkl34I6MdSKoRj1/Y/OIQ9u4tQmmGsYPl4A4t431el2l7bz+G9I0jZBskIIToDO2O2RWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4976
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
> Just open code it in the only caller.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_core.c | 6 ++----
>  include/linux/mdev.h          | 4 ----
>  2 files changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 34b01d45cfe9f..3575e893b5e43 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -56,10 +56,8 @@ static void mdev_device_remove_common(struct
> mdev_device *mdev)
>=20
>  static int mdev_device_remove_cb(struct device *dev, void *data)
>  {
> -	struct mdev_device *mdev =3D mdev_from_dev(dev);
> -
> -	if (mdev)
> -		mdev_device_remove_common(mdev);
> +	if (dev->bus =3D=3D &mdev_bus_type)
> +		mdev_device_remove_common(to_mdev_device(dev));
>  	return 0;
>  }
>=20
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index cbb53dcd20d9d..5811b5a52a511 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -102,9 +102,5 @@ static inline struct device *mdev_dev(struct
> mdev_device *mdev)
>  {
>  	return &mdev->dev;
>  }
> -static inline struct mdev_device *mdev_from_dev(struct device *dev)
> -{
> -	return dev->bus =3D=3D &mdev_bus_type ? to_mdev_device(dev) : NULL;
> -}
>=20
>  #endif /* MDEV_H */
> --
> 2.30.2

