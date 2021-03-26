Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6EC349FDD
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhCZCiI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:38:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:46509 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhCZCiF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:38:05 -0400
IronPort-SDR: mWBF4OrbteeEr9AB/dSGRpEGB2HxsHLeWCKyThuAu40WcNjqqd/DMrVfVlhP9eETvYX4QmzWs7
 gBMRhs53LPJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="171045312"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="171045312"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 19:38:04 -0700
IronPort-SDR: aYaX4xvLe1sVUf15MUAIQV9+uzJT46TjcFZJgA0xSoxbLTlLboapEx5H8RjacsNBNfhFS9ECKB
 JmZSGlRjarFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="392038313"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 25 Mar 2021 19:38:04 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:38:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 19:38:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 19:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRv6Rhic0aTJXx4SK/8Ht2GVeuY+ItcWBQ1+5+vD67Et4VHd5Yqe1bJ8IGq/9JSHD5wrO1DqIWtMIyTaT32s3Q5ZXOguknCvRdLl0zwJmpTdon6AaAfo0FhSLi6PRzUp4bf2yrAMv43sgTml4z/qo2j1MPRxOXSaJTvyDtTn5W7ZgSYfqoMKA2WFzoQrXmXoqWQmP0mbas0xWSZ9cizPjIHEbaK3BKM2QXs2jg8LRLOsEAuAZQTUBQOJHQXPWCU03Tfr1HXuMfqORAwOVChqFy0KCEvP2vSmKP30H4/Tmjr1rgHGoyGK51k19qxy7HHnI3a176jCqd2TSq5RgHST1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrbIXbEiYgbgPTiJPC2bXkeh7N+mgeawUy+J6diJdWc=;
 b=M3Jmtk8j8rdOi6hRN8nc7CLfV8q7hh/UefA1eAjbBHRGDqUCaGpX1V7FiFWNwZo5Tl2XbyTUIiAl61l5mrUji53La1xS4pFgqwoba5EdApcz+KPC6zmKaa/M+ao5jvhvYXrC/+43+SC9p/31shvt5ne0put3qR8DE11CToStAI0m8wYJDn03qDTP32UDT2Ty/g6BsKrjVDW+MKzfG8dbonKzd5x7iUAy4ssMZ2HD3280x8oppW5B0ZPkvkJacZm18FyzsTf0AUaRb4JEE7ntSo5xg3+5YmH5kEhvpNMq9sMknKglRk5G+s996trrdjeIySD1k3ue6c+1XA3TRXrN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrbIXbEiYgbgPTiJPC2bXkeh7N+mgeawUy+J6diJdWc=;
 b=IpiOrdqWyrcPWTEL+wsmSt+GYdZIl4mcdG8FODS73cW8vnTgoFJ43cb/JoUy+n18haUhzD7y5rKE85HJfHhu3naUKslcXgEYJx4i/+4t0h0t8FZ9P/OHzB0WiC+knEVbxLhWWm7hmvumvgMNMFWZGGIbKgI/HsR7OeWvXYTkxIU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MW3PR11MB4715.namprd11.prod.outlook.com (2603:10b6:303:57::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 02:38:01 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 02:38:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Neo Jia <cjia@nvidia.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Christoph Hellwig" <hch@lst.de>, Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 05/18] vfio/mdev: Do not allow a mdev_type to have a NULL
 parent pointer
Thread-Topic: [PATCH 05/18] vfio/mdev: Do not allow a mdev_type to have a NULL
 parent pointer
Thread-Index: AQHXIA3pU1QYKQkj6EmXJEqnKkUrpKqVkd8Q
Date:   Fri, 26 Mar 2021 02:38:01 +0000
Message-ID: <MWHPR11MB1886F5B670DED507D80019028C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <5-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: d182b9d7-efe4-4610-f0bb-08d8f0002cc4
x-ms-traffictypediagnostic: MW3PR11MB4715:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB47151355CF04DD3DCA0BC57A8C619@MW3PR11MB4715.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOoxIN9fPXBii9thJGV/10m4GUAuKbBspcWaomWfo72W6ACCF01XkQUg1q313nef5CUteiJErgh7UXSt0YY2OWlqtmhNLljES9iMO/kbsS36A4IpQjho0CaVi4x7Namu9mwmaa5/RxwzS/IZt6mf2FdQVDx+ajNydtnWQ2H5Vat2pLRJzOioVJcHYr7vo2u16PuvO/KQDmD/Fm9mWJa6lUW/pzDkgnW25z+PWsun8MSqI8MktjYl54OzrC4jrVS4B4aqLoNt1xmWc5r40iQZvAw0hfALXKUJv+lVmkTFpnwBaDpyVkYQrvXIuGJi+KMFewys1jH0qqyTq5xPeH+yCwyuRdB8Epo3Urns+l9heDaWQnWK7xdlINXv1GLoklnBLWaE7xKxeDEX+BBNjKXvBEcmdlCNUriGFOpLjqqZOIoKhW2Fgv/UzNpBxEQHdQta/edpeIiTsF5c9BG8VCB1nLU1S6lIfXs1iKw0sFgEAKvEZ5Q7y5r/ssbSYLYrZpsozmKGOCOgVa6lIiiV1mNAw7M17PhBH8T8oKOUnZgpLPiNZZUts2ZzLyKx3EzGJIthHr9NWgHmOhiIyggu8Yk9MEUSDYpMbbwi5ut61vVUGhIMrVwu1cyYHkIcLToizXYdQKxEhjKgKeEDmJtmUyqhj6dh1I3SOaHAwI4T6Bm9wYU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39860400002)(66476007)(66946007)(86362001)(7696005)(66446008)(66556008)(52536014)(64756008)(38100700001)(9686003)(7416002)(2906002)(76116006)(55016002)(6506007)(4326008)(5660300002)(83380400001)(71200400001)(316002)(110136005)(54906003)(478600001)(186003)(8676002)(8936002)(33656002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IkOfWfP8U5NSNpYuYdg69AMXxydB5lrKKjCyePX/AnSyTa60i4uV+fB0QySc?=
 =?us-ascii?Q?yHrEUyh67jNldNcG/G3GpFZKytD4Qcy+I48Eb1YMFmI4wYsbi/ZoB60NB5JO?=
 =?us-ascii?Q?YRQFwygAJiN6YcSK91jNM8AJZLf4c8Ob2fXx7sHDkd9EHmJ3IqZaiL8loIjW?=
 =?us-ascii?Q?iUoFmFjdunp8VyfCvo91ocvfl9OEKAD1mN9Ibtf58dHuFrU+7oFkPWp1VvlI?=
 =?us-ascii?Q?ZOPgshZPY+ZSBdhmYciDMLYzADueZf6iZ+2lsEPFOA8pBQKxNs1bv6NQ7wQ6?=
 =?us-ascii?Q?qy+WVypU+lMgSogy2cp8TAs36o8p9vL6gWoL2/BNW0sELcZ5IU4xmmZ8iFQC?=
 =?us-ascii?Q?HqeKGLy2vYrcuBmMneRd1R0mB2Jj3tvYxH6/FdwZcZ7EkShfG6UTL8R1yOyW?=
 =?us-ascii?Q?pi2lLAJNqJGeAuNsq/7EzKtJ/cT7AHs1iKOLkghfpdTfFxCnE0mlHSQa5x6q?=
 =?us-ascii?Q?9k5FAxj/3GSSafMVKdnjYQ5pkNOgT8b8XzzPqcPaI7G/iMK+/aSONG92mna9?=
 =?us-ascii?Q?0GYa68qBzN2h86bGPD9FlUQBJnhT8+AJc/QjbEEVnf4IZdnYp2gH+yubkD4a?=
 =?us-ascii?Q?EypodKpBBoJWPYp7BCZ4FVraQMCZfWHAi8ouajn+hv27Ims01kg5wqfKPVdp?=
 =?us-ascii?Q?BT6JSzyupYPJNQV0QUx32GY+jTotw09q2kSm/s2iHgSqtw1C9oT/SWw8n8nh?=
 =?us-ascii?Q?nXkPnjGdVYBCCmqpuBdq9SpiwT57QtvHJLzeYWVLEq+ilKMlqmVb1Zo8L6FQ?=
 =?us-ascii?Q?b3l3RLWLhyCPV2oGLFY5E/kIwrl6rWwz7TedNBB6td3IJeD1YdsdHM7bfhxI?=
 =?us-ascii?Q?mQuLFeu7r4FQvZQIEl55iqc7yWAvYjZDxyaR136dWyGSBci+ucja/6JXGzjM?=
 =?us-ascii?Q?BXXl+/8WensGDnFKYNNQ2tlM+JRY3nUDOKNnF0OwgFdj/mf76QeQKUoSQyzk?=
 =?us-ascii?Q?lFhOZ0/smtJLJYaQcbMx2jar+0nSvdecSzM7mbKoXR6V/eWpFhcinlUUzR1I?=
 =?us-ascii?Q?RYkv7yNwVira1YgtUr3b2vzpLHnNd3KrPnXAxJA7Pd4+0j6Y9gNXrW39OyYo?=
 =?us-ascii?Q?sma8jxcBSKFc0tfyCWeg6l52gZ5pUloQIq4c0QazFrj+bWUKFM1SiQ6/VBAV?=
 =?us-ascii?Q?/LUum2IGXB9UL+b3JvQCB9HLcRrQi85ME33eHEsFbxu1R1+AwnFNY4pMqD8F?=
 =?us-ascii?Q?xw800FoOmRWYZ9t++7kgeUT6gLZ54SXIte+zq8nLZSJXyadKsB0UiwICCXBJ?=
 =?us-ascii?Q?zjczElVSoDL9F7+1hzpIEGuxCDZpQ8zP6/nFL+//aCv0F0mXT64OGZlBJ78M?=
 =?us-ascii?Q?LUfMoxFGL2LUsnepzz0aLcxk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d182b9d7-efe4-4610-f0bb-08d8f0002cc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 02:38:01.3096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wtp6vw0TJWcYx8tECibJQiJUoFZylOioNfbNp0z3rSiNynIzkjFKQLZxRXUaVPeB0OpN/G15NhoEiIacqb7jrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4715
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> There is a small race where the parent is NULL even though the kobj has
> already been made visible in sysfs.
>=20
> For instance the attribute_group is made visible in sysfs_create_files()
> and the mdev_type_attr_show() does:
>=20
>     ret =3D attr->show(kobj, type->parent->dev, buf);
>=20
> Which will crash on NULL parent. Move the parent setup to before the type
> pointer leaves the stack frame.
>=20
> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index 321b4d13ead7b8..5219cdd6dbbc49 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -105,6 +105,7 @@ static struct mdev_type
> *add_mdev_supported_type(struct mdev_parent *parent,
>  		return ERR_PTR(-ENOMEM);
>=20
>  	type->kobj.kset =3D parent->mdev_types_kset;
> +	type->parent =3D parent;
>=20
>  	ret =3D kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>  				   "%s-%s", dev_driver_string(parent->dev),
> @@ -132,7 +133,6 @@ static struct mdev_type
> *add_mdev_supported_type(struct mdev_parent *parent,
>  	}
>=20
>  	type->group =3D group;
> -	type->parent =3D parent;
>  	return type;
>=20
>  attrs_failed:
> --
> 2.31.0

