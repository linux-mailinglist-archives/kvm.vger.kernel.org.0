Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA61544461
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 08:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiFIG6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 02:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238084AbiFIG6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 02:58:20 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BF33DFC73;
        Wed,  8 Jun 2022 23:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654757899; x=1686293899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xiBCwg9PrEkxJClb+su/Wzz4kHSKj3Ajn3twGgKWRKI=;
  b=GAGGmY/BLgXi+nHV7iVFuS0iATfukl2wZf0QQz+ObEeFzfUIA17T50YS
   yR2C5tZLlXgR4kAX27dgQxcojJlqTqz4g9HBXGzxQsi4wedJ27WG4P1oX
   hSS9G4Nyy88uKUrQUJv3axQtBobFikl48fCrLEeEOvOPZV9u48vDUppEv
   F975iXAisSazxOFkV75G7tYCgcZcHm+r+IYC/+qekUAohMYXHJpF24+Sj
   Bh4asdlOZ89kTlJNIjMk7DHTuupmwb0IIVn54YrZlpxw8LhuDStZlGfAR
   4JmSg/0YXY90z5FZY+6PGF50AaCwHu+e/3XJFnmNm8LydIfRt0Ygxy6Ii
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="341258839"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="341258839"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 23:58:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="533446562"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 08 Jun 2022 23:58:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 23:58:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 23:58:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 23:58:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXbvyWuwz0Z5WO1Ae91YC8ZRS3XfjQ+uY27eu+er4a5xhvUJ9bd21h+p9Dcq2/2kUANAo3Ft7jO3rS1bjfG6TEMJbawCDn6Vc15RYf0ibo7Qh0li/QXr6JBkJeU+RuZc2oG+9qw0IkMv1WFCTakDH2maSfSuaBEZPGc7IrMOED/myOgnXbu8YjcKs2N4Xv2jXn+k8d93M5/aTFNQ9onHArHSMNWpgC5myyEZdFwmI3RbPuxPViy/isTW4ietXu1FzjMt4zSXbXu6duI39HIsr+rLFKxeLaRUGLxY0sbIOVkkPJGFyVxF3YiTJAePXZurBIKVP9ZgA/M1RS+P2MSXIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rpKosQ2aGePxNN1QknGakth+Tlu0T5lGgkI5iz67Hlk=;
 b=PFn/54hem+//3jTyF6KKm9M3+2rMFSWm2rdrAY8XTPKPRc0JcHGM3B1jl+k1EbpO4T4A5FRAfTOTM9YFWHnK0QMDiePhmtT6mg1Z2aK39icV8RS3ZtZjS47shpLI4+9oRuCQ3SS4xbSwuRtzaLa99G187y1U4S93gS9gJHoPZVjL1Qswa9KErrLJgeyoKwtUilggKSPyxNv4KAIhbaz6BKW8do/9vEqBWj7FE6mzx3RNNE7bcNQxDtUCof7fJOuhmu3HRn4APGxZV+rivr2eSbwIZ/+ik3N0yjEBfpC2wjYt0P5OtqfXlblwJA6Gbjj3PbgInAC0LAnXUM4u5FdGgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR11MB0078.namprd11.prod.outlook.com (2603:10b6:301:67::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 9 Jun
 2022 06:58:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::3583:afc6:2732:74b8%4]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 06:58:16 +0000
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
Subject: RE: [PATCH 7/8] vfio/mdev: remove mdev_parent_dev
Thread-Topic: [PATCH 7/8] vfio/mdev: remove mdev_parent_dev
Thread-Index: AQHYdxPsdtsiRZYZkUqbvhKEuNxUe61GrlEg
Date:   Thu, 9 Jun 2022 06:58:15 +0000
Message-ID: <BN9PR11MB5276A6575322E1F8901FC7E28CA79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220603063328.3715-1-hch@lst.de>
 <20220603063328.3715-8-hch@lst.de>
In-Reply-To: <20220603063328.3715-8-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22c06827-824c-415e-5e99-08da49e56d8d
x-ms-traffictypediagnostic: MWHPR11MB0078:EE_
x-microsoft-antispam-prvs: <MWHPR11MB0078AD98E5F97A773DB748C98CA79@MWHPR11MB0078.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O8G13CkWvtdeCNU5Hb5cFDvB39yG28UUmBa7G42X4i/RgLvk6EPvl5St4mO1X9jxm4nQ9UpMbaY9z3H0gEIqWjmLYZC3Qiz8xW6hGyppftkLJWj7Y/HyXxB8ErN9I1+uF2unofYqV4wxyIfu6Y8TaPvnoH1p+5Xx44m1kfUgJhz9vVP1VMzXaC64V59WsIS9xYBJetOgMA9vziqmlzv4YiEuiFHSYbuWFhgjL+xfMUYjSBQ69FpGtUY+qPPZweNde92zO2z3F/5ane5FFF4pDTL3Ze23G07Ik4LYxMJwyE/P154JNzXTzTuR+/eft9S4a9bpwJ1eWUyWbw5fZKTYnDWe1sP2Wss2HokUbfJC9f5veGdrSGRJusRF4aksAU2r3UHWQVgjHJEgFBktwg6fXvT8Rr0XILYKY2i4T70V4u8OwYh6TII3ys3M0JZHaUtT2o+bSVze4DYWL+QOrVXJXMXi50MMAX3eN7N7KiDHL8DiadVQ5S8cP+XURq1SvPA6qxRJck0XvkEGMbmCMtXkzKZGDeAJC6DwZSK2EsyKj1HUhyH+9DpYKWb8vMNDlmjQc/bBbaWQy+L4AjuouKkOLPoQzFZKE6ZDLOXZyZg4HJJP+A1uyir2bt/qPIPH7YCXERHGuVtUr35ziA8Ayjlx6EfEzueEA4MiScLWJl0JHyfwqQFtAptQlcq2mpT8X6/dYT09ol5YVBwjHnrOluGcV8z8rUQNlvqeh7RoWBlt6g4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(9686003)(508600001)(71200400001)(26005)(6506007)(7696005)(122000001)(186003)(38070700005)(83380400001)(921005)(38100700002)(82960400001)(66556008)(8676002)(66446008)(66946007)(4326008)(64756008)(76116006)(8936002)(7416002)(2906002)(33656002)(52536014)(86362001)(5660300002)(55016003)(316002)(110136005)(54906003)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2VESXXsJBon2AAwvVKICRpaWd70D3VCOaNRlF6NyE0gXvYtNTvDNwcIMDMN9?=
 =?us-ascii?Q?g4OO6lXwCKF1icSq13T2wR8f7ScRoVq83VyglXxUVWdhntehzwUL25ExApTA?=
 =?us-ascii?Q?fQd2v0yx4RLoAJMgCrZjmj23oKzTW8xuFUvyUSbTjqymYEvI0HAtBWG8uFeo?=
 =?us-ascii?Q?VM21LaPCbXwrXkIIDCLSnOkPKEPLhH9ACFNVWiAqnEQODZx25q3YuHAPSwGv?=
 =?us-ascii?Q?MH7bW84xunl/3pk9NPSZZgmDuk4RcyBROT5R6SMOkNMXRkGqwdo9xbkzEjjU?=
 =?us-ascii?Q?B+Bq2bcxsgyfkuLCgUtlDSohN1yOj0HaZYizYmxbqsAwtMfx0ItJ1KIKiWR1?=
 =?us-ascii?Q?YmUkJeXA4S+hXDwCSLxJnJJ5y1sk1ibS6wxB6IsodgHXJdoDsqnXxV6muBeI?=
 =?us-ascii?Q?S8WxmEfk/CnGU6DTc6fGJb6Alqkp68DSyxupMgEMbVWtvrnZsG2sTm9Lv5gd?=
 =?us-ascii?Q?Rv1Ay+GKNmQgt8Df29a0v97oBxUubOjG2bDW37oYsRNeIVd23ZwIpMW9wipr?=
 =?us-ascii?Q?TOka6DagSW8Eee6YO/Un7GyeC2iF8y4DwqkUfhNp4QUOFcSXbyFWQypjWhtp?=
 =?us-ascii?Q?JaYtjOMn7o+kLdC8aWHd3dhOuc6HNjvFOIt0Rv008erpPGF6ZWdPYZ1Okyk8?=
 =?us-ascii?Q?h/Lxpf+25oU/910BkbnhSymRBnI8LNIkNxlv7dRyBcy2ltEVGugYy4MuHA7V?=
 =?us-ascii?Q?yPpHReKzKpkDcKerm1GsMrIgEdvIkBEQIVlN5VkZgjHzp7vhVc+Y3J42V2+E?=
 =?us-ascii?Q?ijR/X++hwxqIyyPM462Wm1DmUicP7hCKX5pYtPg9R2fFJkt6Absk+YWgITTS?=
 =?us-ascii?Q?KIbjXkxFGdnMWOBCyBAyNMu0IzAyNMaONPHw3v3EQEh/WwNVOiQjDwX7z84F?=
 =?us-ascii?Q?CfbY5vrEpZa3kdYndE60/de+FespUt6/mLVQi9aN8XQG7SMGjsAY+yCog6xG?=
 =?us-ascii?Q?41U44mdRrv53VYrHoromFQ6Uq+qd7OYNY+8ISzSkF4AFzy35nK/9LUxwOgYy?=
 =?us-ascii?Q?XuwK48GxcaDMkw/k7YL5O8OZ6mvNkV3sUVxfVCmyXlzuxfS7UIH4pcpA+scj?=
 =?us-ascii?Q?by1nXeOadTVDgaoB3hmVEhyZ8LegN7jPblY4CVLiECz00eeTUQ6zGvTarmCP?=
 =?us-ascii?Q?yC8a4vuShu6C0Dwly7k33PZOdpIoMw/K6NdMvN7jnJ/ZT189FUsQMylaFI3+?=
 =?us-ascii?Q?GZEvwjBu4mk5rozAw17CX7S82BJ+wIUkIDnZHF43FGA1Ag58YloIqjNCfgJG?=
 =?us-ascii?Q?eFljUsDx06UQlBEJvYdjCcz5SxI89oFSMUwogIcDIuXk02cOHe733+h//ojQ?=
 =?us-ascii?Q?DsJogiHhQbr3+psRstiSkN1/x030jc02eHtdWmXxFXNOzwrIfqgJydy1EdNJ?=
 =?us-ascii?Q?OsrYIYvcP7QDcadUtLlANIsMjjoejgJwij4XFOmH4Uv7rey8oDX/u/5kEpEA?=
 =?us-ascii?Q?4r6JAA07rSf/xik6wSwXJ0kc6u4ZfwrlhHiuQQCUTSSW12ILCFGzsPetkV4b?=
 =?us-ascii?Q?Uq7Z0G219dAbqUeMi7FYFv5WIN9JjxiUhkIzoHVvTGY6wxIybQVnROoQNTE7?=
 =?us-ascii?Q?L3Fpy2A6RnYQh7IBqmHG9HI21iohJCVYdvumEINDKfDjNMyJeL2DSTm7VE/n?=
 =?us-ascii?Q?N4HTtD3HvCP9KtSa9n+dssZHMnei4oDnLgFtGTFEP7PCVL1hm5ebPVnheH9S?=
 =?us-ascii?Q?O3c24CQP82GJ8Z4063a0HvrDyhaNPdSDMU3AyyWGa/TP8KQxkdCPtldPl7w6?=
 =?us-ascii?Q?eFeu+I7fpg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22c06827-824c-415e-5e99-08da49e56d8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 06:58:16.0041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SrVU/9eTsK6J6hFhmvNIoM6W0diWl5FjinR8LTZRsx/RPT/T051ucIigiONtoxf6sMPkcSMF95XaMTrNhenm5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0078
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Christoph Hellwig
> Sent: Friday, June 3, 2022 2:33 PM
>=20
> Just open code the dereferences in the only user.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  Documentation/driver-api/vfio-mediated-device.rst | 3 ---
>  drivers/gpu/drm/i915/gvt/kvmgt.c                  | 2 +-
>  drivers/vfio/mdev/mdev_core.c                     | 6 ------
>  include/linux/mdev.h                              | 1 -
>  4 files changed, 1 insertion(+), 11 deletions(-)
>=20
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst
> b/Documentation/driver-api/vfio-mediated-device.rst
> index 8ff463aa9e2be..0d74ac2a218f2 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -201,9 +201,6 @@ Directories and files under the sysfs for Each Physic=
al
> Device
>=20
>  	sprintf(buf, "%s-%s", dev_driver_string(parent->dev), group->name);
>=20
> -  (or using mdev_parent_dev(mdev) to arrive at the parent device outside
> -  of the core mdev code)
> -
>  * device_api
>=20
>    This attribute should show which device API is being created, for exam=
ple,
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c
> b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 06b8acc6a995d..f3c4ce475ce86 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1554,7 +1554,7 @@ static const struct vfio_device_ops
> intel_vgpu_dev_ops =3D {
>=20
>  static int intel_vgpu_probe(struct mdev_device *mdev)
>  {
> -	struct device *pdev =3D mdev_parent_dev(mdev);
> +	struct device *pdev =3D mdev->type->parent->dev;
>  	struct intel_gvt *gvt =3D kdev_to_i915(pdev)->gvt;
>  	struct intel_vgpu_type *type =3D
>  		container_of(mdev->type, struct intel_vgpu_type, type);
> diff --git a/drivers/vfio/mdev/mdev_core.c
> b/drivers/vfio/mdev/mdev_core.c
> index 3575e893b5e43..3bdea77d506d9 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -25,12 +25,6 @@ static struct class_compat *mdev_bus_compat_class;
>  static LIST_HEAD(mdev_list);
>  static DEFINE_MUTEX(mdev_list_lock);
>=20
> -struct device *mdev_parent_dev(struct mdev_device *mdev)
> -{
> -	return mdev->type->parent->dev;
> -}
> -EXPORT_SYMBOL(mdev_parent_dev);
> -
>  /*
>   * Used in mdev_type_attribute sysfs functions to return the parent stru=
ct
>   * device
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index f92b4d8edf0e8..6d0a9b45a9eb6 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -95,7 +95,6 @@ void mdev_unregister_parent(struct mdev_parent
> *parent);
>  int mdev_register_driver(struct mdev_driver *drv);
>  void mdev_unregister_driver(struct mdev_driver *drv);
>=20
> -struct device *mdev_parent_dev(struct mdev_device *mdev);
>  static inline struct device *mdev_dev(struct mdev_device *mdev)
>  {
>  	return &mdev->dev;
> --
> 2.30.2

