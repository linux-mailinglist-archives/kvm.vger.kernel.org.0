Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D6C349FF4
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhCZCxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:53:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:47422 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhCZCxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:53:23 -0400
IronPort-SDR: U/cwRJ8V97opRkzWTy+9e+r6lkyhiX+8V2K9Up1UnIZjySphX1NI3NeHaJPYfRJs107bMeIIih
 cDXDVPGS1VBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="171046334"
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="171046334"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 19:53:23 -0700
IronPort-SDR: jqqUiN6EAyg/WHMJoJcCp41ArOBuD+PI0UAQN0H5Kr5hNGhD/gHs2R3Z1WY1evKsj9BTuKxG6H
 yvHQT69TU4Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,279,1610438400"; 
   d="scan'208";a="409664114"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 25 Mar 2021 19:53:23 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:53:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 19:53:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 25 Mar 2021 19:53:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 25 Mar 2021 19:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvCEdreZFt3c55pmqRqm1w0e6f4w7nBRc4YSSEK4DcWBFCG0/KDjBY/tQdr9hbBvToG3WL9i62zAv5WTA6b4MIUfW6+5XhD9S1TSkZ9d/oOtq9yTW9ZLtg8NLdWU+rSNH6ySVuNF5agYG6kkjzKLxwufz5CH0e8GjRV7+Jj5is9L6ymCUtvmXvDtD/N0dDwErhRCiPdtKUC6MLgPYUuPi/PmVq6IImnzLG9RChvXMwbOl+MwrZls3X2v9FsPdHuK1++C9kNLnz8jARI5IwPXBXoUhe6X9eaa+f/0s1AxQ4CE9VrN7MdDjht6iHZNPzLY/mzKXvv2ZPNy6uo3uMFbog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo+OLz81ufUtz4mln34a1/7fwRRaIk/TauBFXgoiI2A=;
 b=LyUNc0qD1NnRrEbXKw9Rwt1v0elScNs8J/wProrgOlY90j6+oW1/nJQLzxhlIeoHism+kNVwi0ubrZkALab+FUDcGbzQErE1gkii6oejm+MxX/8o2qQYF5njwiHFiOBE9AtpC8IH5nN33p3vGe4yT/xM9ubEsaWTq9CXxwcexN94syTeB1QYnSjwQmovWlsqjJjHig2IRxche85sZ2D5iVBbIbH3e0VTslQ32AVVQmkxA2Pxjh9Ec3NqECZlpbcasXlcmfCb1HCf7t9VVvKdUHk6hHOaS4n35TVyY0ICC3QkbIJEq+88+SJUEa29GYYjXuOMxV/EDf2vvPivMMY9cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo+OLz81ufUtz4mln34a1/7fwRRaIk/TauBFXgoiI2A=;
 b=g6ByxLEpgC+sdiKllmg7dfoiX+x2EvrX4OnMHCbEr4Hvrtn40GvKax0q4Lp39ppUFbiluAR148CCkBdNKzg/wo4Npdmt3yf4sx8BM0/FOo/XpPKRKFHZv1wHBPStsF1cG34YbMZJ8jqrvn4ksWC3Z+cEL9ED8zzpnfD8cEorvnU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1663.namprd11.prod.outlook.com (2603:10b6:301:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 02:52:49 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::75b0:a8e9:60cb:7a29%9]) with mapi id 15.20.3977.026; Fri, 26 Mar 2021
 02:52:49 +0000
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
Subject: RE: [PATCH 07/18] vfio/mdev: Add missing reference counting to
 mdev_type
Thread-Topic: [PATCH 07/18] vfio/mdev: Add missing reference counting to
 mdev_type
Thread-Index: AQHXIA3p05VsE/MZOUSNY/Y0CkZegqqVlgEg
Date:   Fri, 26 Mar 2021 02:52:49 +0000
Message-ID: <MWHPR11MB18866EFA89888D9FE15B5D818C619@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
 <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <7-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 327f870a-a4ae-41d5-ac2e-08d8f0023df3
x-ms-traffictypediagnostic: MWHPR11MB1663:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB166317E3AB6E80A1E06096988C619@MWHPR11MB1663.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EGhOZzjDYsJukkxLRraF6RqtOXRYJztinfJF0qoTDlpbL//xTNl1wGFMlVhPuKCNf/otcKU+Mm6UVKTcDG0NALq1R4MPpe4bzKSqkpUuF/YMiVK45tgIJ0vH7+MZwmlJg4uH6T8TMS7FS+VNtFUmrD13Ozd4XCZH8vw+FCHA+bEzz+k3TxTAgcrSXgFPzduvOFCoQhT3I+DCG8Fy64BofbCDMmJcqf6ld4ENOb4997Pdjuncpucw2gAG8XFxETojZYhgClv0ffrMBvR88oHzM9r1ZJrCksLwULtfdzxnWAl9Xlo68NuhUvZl/1f3nU1jdHCTZiCVhQAEha7zItLp8H7aprHyV58P1wt/3Hh92LMdUI0bLv5hk07NJwaxjlMkIImBQFRTgTsCvBIDHoy983vGH+jFDjKvRxDvzjSG+wgRsBKKiWkxJH3F3Xsl0IA7VIYkVMuw4XTa7uRcJHZdCm4bSQOQhAkFWv1O83oGV0PV09Bha7gMc0oLjTE9KbRi9p6dOE4c0G8JXs5rqvBXGQMJWRsO9qobgykUrD2k4iqA2tcRLlZyJbBszNr48BHXTM1UtJWz5RvR3TFgLz2IwuKhWpacnLVhQwqQvKT6rOhjsDEm5ZZkSyGn9Z1lXszTGQ6/wben5JiG5H4rpnq2g3+2E9iUtRB/JL5qQCz/EJc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(346002)(376002)(366004)(186003)(5660300002)(38100700001)(6506007)(52536014)(2906002)(26005)(7416002)(4326008)(76116006)(71200400001)(55016002)(478600001)(64756008)(9686003)(7696005)(66556008)(66476007)(66446008)(66946007)(54906003)(110136005)(33656002)(8936002)(316002)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?o7I8it3M108dMxMZr2p+dt0C9RsQyJAM+u8xXgX0gZbP87A1eVbMnTF9y9Qk?=
 =?us-ascii?Q?qI+/DsXKoGKJOek6+GFTjGa/WfCKykuo0oqECAfSTc3NzmTegiO1an+7Coy5?=
 =?us-ascii?Q?+vgooDi/kAdT7hAkoUD03xVG8+xPH1e9b/61StM7XE9IRRojbosQmPQ/NHGW?=
 =?us-ascii?Q?iTy6XzOu2vPkofRSEyR14218VxIiakiQKA4HBGlcLdclwkzhprPlGcdF4tKT?=
 =?us-ascii?Q?JlLaG8Slm2eJlviWbyq5nHGQzxTDKHi2+Cv8flzhxOXcAKCK2ylhCemkvWGt?=
 =?us-ascii?Q?rJM3ScFpZx6EYaLRptrPCwcfL3DSKDSlpr7hCN5T5AmAG90Du/PWJWiIw155?=
 =?us-ascii?Q?kJu/YSb+JSzpQSFOPeszz0yjbDqY+lJqZFJJdhqSJ4CjOTAEZtiOTIygo97d?=
 =?us-ascii?Q?wJBRbPYYHN/CS2oZv+9AAtF2UkyVMqmRQR1LFOI2awv0SMQsJsul4k+28/l2?=
 =?us-ascii?Q?f+t6HpRDdQT+f0W5LksxrioEIs9DcqNNCwX9ARP/tu3E+53ZKv+xyqxum3v0?=
 =?us-ascii?Q?otwdGDnx7gLS+LueUcvDBpF/zVaGJogfiZL3WbpWx8YSmwg9lzLpDhww5CjO?=
 =?us-ascii?Q?gACmdoAPJJW2mN2aIZgxiRE6DGhJAsbdIFwOvv6QF50lh47htDeF9I2QHV8D?=
 =?us-ascii?Q?EcT+fbwt1ft+somxpLIjpbrD+C+Jfs7tFjIcmnIerxpmBfQubNjhc9LZO5ds?=
 =?us-ascii?Q?uwW6fTwYZ1yvC+/Khpuep5y83Mhb09sQIPJT1OgV3iuCOUGnMVbQ2OHp6ql+?=
 =?us-ascii?Q?enZLGKnFOfKZC5pcoCjHtboGbv+XrD/hmiGp+e2E26oVpxmeNCByyxuV1obK?=
 =?us-ascii?Q?+1XOKZBmbJzDYS9PDKIn8A+NRVFiiTkFdsDFVG5nMg5GsksFRypecYeH1Cnv?=
 =?us-ascii?Q?RPh6Slc1Awye9iLbL7iUZimWYQBZ85JUKkgk8m7ftBlfEA/1GDNh9dhsIZ6X?=
 =?us-ascii?Q?a/FK156EDRPCeITUULuYsbLMgT5syjwzirC/2lu+u/TJdj5d5sJfMkJPTYYZ?=
 =?us-ascii?Q?KBlRfZYD93n+0X5xbbnhfqdSbfsu7r6B7SZSJbsx1R3xuL4Pxiw58ShteQaM?=
 =?us-ascii?Q?uaVATCFk5LKxFsVt08eKDTZYoXir0PggTSMtzaKmVbX/NBgTM4Va6ULW5EJk?=
 =?us-ascii?Q?gRrzrl7RwsTI4+dqR5d51RgmXO/N603UqsEwX37FwYPTsUPlGI0UZ/d7C7pt?=
 =?us-ascii?Q?J8sPvJJ9Zku9iHtD2+cVkJrbTlTkTrMuiI+mJa6Z6TO4qvm7/T45kOcUoHJZ?=
 =?us-ascii?Q?2DEQZ3djoY2kYbHG6+1T2GFaRUOBA97dwMyoMNs8ZuWZ+IlvDVpdJuLQtihV?=
 =?us-ascii?Q?C9PebarguAxDrzZuzi3d4MZt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 327f870a-a4ae-41d5-ac2e-08d8f0023df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 02:52:49.1596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SKrS3fdii+vz5q/1UP5gr8Fb2OOhLYoefnom8nW1nhDojzMhF7hTX28Xgnbs4oea32ySzsbPqbiysnGarGQ1HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1663
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 24, 2021 1:55 AM
>=20
> struct mdev_type holds a pointer to the kref'd object struct mdev_parent,
> but doesn't hold the kref. The lifetime of the parent becomes implicit
> because parent_remove_sysfs_files() is supposed to remove all the access
> before the parent can be freed, but this is very hard to reason about.
>=20
> Make it obviously correct by adding the missing get.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/mdev/mdev_sysfs.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c
> b/drivers/vfio/mdev/mdev_sysfs.c
> index 5219cdd6dbbc49..d43775bd0ba340 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -81,6 +81,8 @@ static void mdev_type_release(struct kobject *kobj)
>  	struct mdev_type *type =3D to_mdev_type(kobj);
>=20
>  	pr_debug("Releasing group %s\n", kobj->name);
> +	/* Pairs with the get in add_mdev_supported_type() */
> +	mdev_put_parent(type->parent);
>  	kfree(type);
>  }
>=20
> @@ -106,6 +108,8 @@ static struct mdev_type
> *add_mdev_supported_type(struct mdev_parent *parent,
>=20
>  	type->kobj.kset =3D parent->mdev_types_kset;
>  	type->parent =3D parent;
> +	/* Pairs with the put in mdev_type_release() */
> +	mdev_get_parent(parent);
>=20
>  	ret =3D kobject_init_and_add(&type->kobj, &mdev_type_ktype, NULL,
>  				   "%s-%s", dev_driver_string(parent->dev),
> --
> 2.31.0

