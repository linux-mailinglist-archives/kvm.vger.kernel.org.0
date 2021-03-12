Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2F338E42
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 14:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbhCLNEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 08:04:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:55377 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229905AbhCLNEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 08:04:40 -0500
IronPort-SDR: Z4gm4X+UPsrhZPmAjBi59rchr60rLeJJObZCBYCh+9/YhmU+6uykPg+7zGqS543bRYWRLUDo84
 qlFwV4SdhBNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188923371"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="188923371"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 05:04:38 -0800
IronPort-SDR: C9rPsNauNX2eAtrSA1Imhnt2VyhkJDGnpaF0nUM+330WxOzJY5/RBhi22m9hp2NFcNXAs/3HYp
 6+sYROcpmjXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="600589805"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2021 05:04:36 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:04:35 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:04:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 05:04:35 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 05:04:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWTqqeP0vtpOFa0yDXV8QsmRilV4XR/r2p58wiejeVYSC4MKxEnz9c4ytyG0CE8fEGQyDbL0XBcmW2dKi2N5RmhZxcE5kzb5mdfb39/NehDVmpngpaxwsoYJTO8d9gv+hXRyiZRikEm7lnQDVDyHUSYcyk3lrGgfQlWRK65uSDc7s1yMHO+zJy5SIYfg4OxATRqGzhFiqzoATkCMeSsr8JkKzK3ZIrWyBKfxXOnS65MqK4JjzXQveWPDjOmW+zXMQ73A2FL1BgGWPrBfzJnNvs+zDR5eIPsbePwiOcl37kz0+Xm11aC96uFDzmPVJXKllSrPhUsR1UvXojQDgK69mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiXCTeNrm1BQSkoHOfuihm3yEXlkFYNA7v3WTl6Olxk=;
 b=SNwpw0w+Viw8mCerFF+NAB4pJeTYlyjOGw4Ra4h5nqsnIs6PExZfa4XptIatMturJPCHHTytS80f7VSM/d2nRk+RaRGXtcryEZnVWcbQArNTYXlLxYpQPba8O3hR8W2tj02zIEl7moLBPUcx6qIXFnh3dRZF1jOBl5DJ1Tvdc2ayMHGaDPhMoBKwfNXOU22nw/gyxNnADbQnTq9GOqRd+PzBwwGUDcaYWyFeB9+QAaFPPnDSwu88sToklpgMph6//NgVkl2O1zd5MT5xanBWW48kcwIyml+uppJBot0IOLblOxpVEs25iVh+iR97eExgaeD0lDlm1185x3WiEMzlqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiXCTeNrm1BQSkoHOfuihm3yEXlkFYNA7v3WTl6Olxk=;
 b=Tsh+YkUt5aKTVg2mBTUbJr83S3eae8W9u/Uzl80WHTNE6do6m4SyDVsINA3lFr4bT8D558Lgnvg6cQMlut34Jr7OSQhSqOv76tAdlO4HEPiUnpMmnTJqkfP0IA87CSqn1DJ7Sasmv3VGYA307PO0dMiwP0mxv0/YVB+E6kd16eY=
Received: from BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31)
 by BN6PR11MB2018.namprd11.prod.outlook.com (2603:10b6:404:4a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Fri, 12 Mar
 2021 13:04:29 +0000
Received: from BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d]) by BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d%3]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 13:04:29 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 02/10] vfio: Split creation of a vfio_device into init and
 register ops
Thread-Topic: [PATCH 02/10] vfio: Split creation of a vfio_device into init
 and register ops
Thread-Index: AQHXFSzE0DWacZhUBEy/dcqC1aTD7qqAU7VA
Date:   Fri, 12 Mar 2021 13:04:29 +0000
Message-ID: <BN6PR11MB4068BDE65D5AA2A3E0A1200BC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <2-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <2-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bde8d0b7-eede-4fcd-6e6a-08d8e5575f4b
x-ms-traffictypediagnostic: BN6PR11MB2018:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB20181C1617B8ED8EBD177B9FC36F9@BN6PR11MB2018.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wvNQl6AXjtgmIcGHfKizgDxrKOEwSefOvCwsnQobIpedNSQQ2QzfB35mZOkug0pDt4YhOsPMSISWCpLuhmpPNGQycyNNJgVjYzq+9M1Kgrj/rbkEGig2Pfq2yppmG5p3OwVJmB/dGnzmJZZp6s3IYQygS3oy7YJUUfm4aqsoqLiL9dTOZJXk/KnARaQPhzlDT/5PwkpbXu7ITtcg+rZlxfek1h1o0/ZxalqFhJa4wXulWUnKLzq1vC649OLUThJiCe4P9qV2SQ+2pHttSzCtQ7LN0Ff7ifyvAMnoiec0tpqdVbP65xgJGeOSdDTTMy6w76+7go4ndDpYQPkQysnSl4JwwHozMo3IR9HQCKzbJBfqM26vfrZuABvRkDrp3GJvo2m+GLD5GZXTg3z9HZdl0rOXW1aBCaLZkFIFyVNjwXcu9l5yxYceI1FUhy4F2C/llYauEhYYdR0As7/IXHi5ExNozmayKmj9ihIRyz94/cHva50f7LVonLMj18WowlIBI2eecROBnLP0/It9NPrPvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4068.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(136003)(366004)(346002)(478600001)(2906002)(5660300002)(8676002)(7416002)(7696005)(4326008)(52536014)(6506007)(33656002)(71200400001)(26005)(8936002)(4744005)(186003)(66476007)(66556008)(110136005)(66446008)(64756008)(76116006)(54906003)(66946007)(316002)(9686003)(55016002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?uAa8bgrK/po0C+NViKKLlnXlsbfL11dqqq5tA02UFHsaS0AMCnNbYyFVCSag?=
 =?us-ascii?Q?cGFxdNZ34lJ3sHp9rAX9BKc+e44LIUhgOgG4lcYcmfl2pIKI7zGi8rW7Qxa3?=
 =?us-ascii?Q?vtRAdRlqqj6yvWteocXIexFDF5YV+hry4r0lcmXZYTHaf6ejAgmxVVOAFWfs?=
 =?us-ascii?Q?H0BXuZmCnAXQSgzlsOI9XjSM6p2WvOzggiGZNip7dWrWjasdfd0fxXN/rYMS?=
 =?us-ascii?Q?0XVMpI7Dd0ZaFuynr0hqNZN8CVdsgTIPmiP166mkG0U/1ndeliQFim47DO4U?=
 =?us-ascii?Q?JPbk18QZwb5lAH3/ynp6WrjseNi8VXy1XF9s9yaGH6XMleNewAlQ+KMMGANh?=
 =?us-ascii?Q?WLJKlz+A2TjCN4vU6qpmXsCYLU1mDtxAY8eJuswERGLvtyViIvJicsd3ECsZ?=
 =?us-ascii?Q?0JAr35xojMHcW+zqOWGF1I3l/tOFaiz1Jb5UEEOySe7/FVL3pqR0Sa5KxAqY?=
 =?us-ascii?Q?o0+9zGlRNabrEITNQJjHYjAkWB8nxt1Xlz/XbH0+qg4Tz2RznwWIC4mHKVTe?=
 =?us-ascii?Q?w0JmLhs/6DhN7cDRka9bY7De4m+s+2eKsgqsDdVGzDFIxwZVshPlqb3vTyKe?=
 =?us-ascii?Q?3XVjDLEGEeys+kYlr57aGQjv0NMumh6SfK7s9WGMeEw7N8Y7Bwg2OD13SsSI?=
 =?us-ascii?Q?exd57DGiSr/6YKytxbNdeq2bB+OxiMZonu+7IkOVUl3hKoWHCoQtD4UgYUBx?=
 =?us-ascii?Q?ZY8VcUGNv61N1jH+WjVTov2DxJx40Y2W+ygNdJ4nqdXl0GmlieCIsO2RvDfA?=
 =?us-ascii?Q?BCpqnE8R/YmmidCwcToFVmidMLwH7pyeaE5uTmgs8UtZj0F/MGb0cJ5oDmmo?=
 =?us-ascii?Q?66IUivF5FW0aPQHMlABZdq+0haMyoVT7rjWO/NBQ1Hkw/tLLvs8ZUa5xlqgN?=
 =?us-ascii?Q?AhrySD+UboVD5HEqqUHsdjEqYLbdWm6abevX3gpAN2yJMpz0CCROCVUSAeZ1?=
 =?us-ascii?Q?15l/vAP6MUKPogrWe4K3VQESyrfHditqrUmnvoORZsdLsSTvg8gGRevrxeg9?=
 =?us-ascii?Q?omZZ01tHMLfSDMCZ9X8Ds1mZnOlOynKCJtYyR5PMv/izhwfsyvmiV45nCANl?=
 =?us-ascii?Q?PNIjMuBzocbu3KhDxLGo0OUgQvMs4rxiTFoowXxUntR5EPCZy2NPOYz/gQZg?=
 =?us-ascii?Q?nQxUlKzxxKQjH9eaF+I/XrgTECwMsfHYjKX4wxnfmbCSkjAHWABxUFBhj/rs?=
 =?us-ascii?Q?nOSR224GgjgPnf06h1LgTgbA6sUsw5AINOjPfPwWXu5dqCsFZvfYKrPeZ2UY?=
 =?us-ascii?Q?Z5qGRG4zrUFokM8ggtdlVywnSasPSeUz7FwZbeS3B5cnvspofWsOsx2BR3lx?=
 =?us-ascii?Q?kHEVR1Ky8B6tfAL1fUvhyJA2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4068.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde8d0b7-eede-4fcd-6e6a-08d8e5575f4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 13:04:29.5310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ik/umjh8DvjSMg+iO5FFTdqKykYjKqgIDpOwWlTXETG1jjPh6XCShba4FwSkCI1/bj3Q7kUPR+v91s9nYvuaSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB2018
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 10, 2021 5:39 AM
>=20
[...]
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index b7e18bde5aa8b3..ad8b579d67d34a 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -15,6 +15,18 @@
>  #include <linux/poll.h>
>  #include <uapi/linux/vfio.h>
>=20
> +struct vfio_device {
> +	struct device *dev;
> +	const struct vfio_device_ops *ops;
> +	struct vfio_group *group;
> +
> +	/* Members below here are private, not for driver use */
> +	refcount_t refcount;
> +	struct completion comp;
> +	struct list_head group_next;
> +	void *device_data;

A dumb question. If these fields are not supposed to be used by
"external modules" like vfio_pci driver, how about defining a private
struct vfio_dev_prive within vfio.c and embed here?

Other parts look good to me.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>

Regards,
Yi Liu

