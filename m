Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C8748A5F6
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 03:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiAKC5S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 21:57:18 -0500
Received: from mga03.intel.com ([134.134.136.65]:10234 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbiAKC5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 21:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641869837; x=1673405837;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=foopIHRnMnb1u5VzK4jeI0/2iQ5qL9q3v2MfDCYWhqQ=;
  b=lTkmE8XMXK2Fw7foS4zYAZ93gBxhnIwoOhKBOH3aLeiP2F0JHOpYVYnE
   XHWNW0kQqfLHCmoWdwIDBa1AmKjuTTvdMsIlX+Vy0Gt92D7fm8ftlt89k
   F/hGwLRApiKkQnkx1EG+PL7GhPXL/WoTfRprbnEuG13hRCzUi9mQ08hsV
   h1wdbp3zvRQIInR1U7Y+ffsM5dePNmo1vjV5iV1UUW4Z+h4KjIANb4a+O
   PUKdDUccVdNecbyf3yjwZniUi8EGCkt2Mjpd8VuZFTVFqPY59l7aCYDyq
   eYsSzx0ka8+TMmlTB/NwKlmg+CthV7/2UCmrZNIUcbIrMLVMndpEz21ac
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="243342192"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="243342192"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 18:57:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="762375239"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 10 Jan 2022 18:57:16 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 18:57:15 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 18:57:15 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 18:57:15 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 18:57:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoR7V9losOc+qSK6Nd/F7Ja24UGyPX6/FnlLdO4+N+uricQ4yTJH/4dfzFUpJVySqa6ZITRECgFEIuNzNfyn2lZRV0ZgOO+pb0mgWS8wWrVGo1PlSvtxXM0VEkwi01vJvWThyPMT90bh2loppR8XFFyxo6nBvBKx1Dk73FYIowkEG/wdnMrBqVDwmolf6pLxdO/0T8SE70jsC5FP81njMI/dCyGckO2QsvMOTnxxrEaHrQTA08T8sC3NECfIiDwBdF72x4yaSyfDJkHhwLGv3nJgGnKDapqOPpZoxmV7TcafyVHIfNF3OyjqmVTD/u3FPnsC6xVVY2PK2GKfHHE4Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eqH79PTIglJU9TtV6rbDVh/YLfm32XF+QGw3JTMG5os=;
 b=b6i5jn5JRikqkZ9LeOrI3KXi/03yzLWI3mteOdeGoZy8+zLmB/3BfKmmfV+X7Eh5cpq7HUAOH9yBqpfGIj2PXUf6RABeGhVKBA7cioHUz0QpLjDvdW4ySfVoMQCgIzXwVRDnnMF0mtUFqXSrZCgLvvEHyIXO5NUkK+ANhVgHQAf9C3ygj4p0s77SPbSr2pt2JQq+2V+2uOsG5pDdbjVgxCJHyw3Eo7O/wSI4BYquQjTbGitiRtc5ulWB05RRWcSClqkt7dfqF4ht+Vdjt9Gd223Ij6Jxb7pTMWrgT0UOrsU7azjKBPpiNDw2krc4RsPocXZspjRFzU02BsozmCNHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB1393.namprd11.prod.outlook.com (2603:10b6:404:3c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 02:57:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 02:57:12 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IIAAwDmAgAES3TCAALDYAIAAhPxggAAOagCAABW50IABBXcAgAO9hLCAAQG/gIAAk7rA
Date:   Tue, 11 Jan 2022 02:57:12 +0000
Message-ID: <BN9PR11MB5276E51A3F65FEF031C649DD8C519@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
 <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107002950.GO2328285@nvidia.com>
 <BN9PR11MB5276177829EE5ED89AAD82398C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220107172324.GV2328285@nvidia.com>
 <BN9PR11MB52766CFF8183099A16DFEFC68C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220110175259.GG2328285@nvidia.com>
In-Reply-To: <20220110175259.GG2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7712f1c6-0b0c-4fa4-e184-08d9d4ae1104
x-ms-traffictypediagnostic: BN6PR11MB1393:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1393C56DBC8E49E009CF21908C519@BN6PR11MB1393.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwkU2IFnPM8zLKKP6+hTN73gPvFHhDVZ6zgeOnv28HdBJ9a3cc7woIlyKLH+w4kc9z6nFW1qtjAixsLoF8G8OW+DKfuCjIqSzDtYdMLIgRvQEm420dKdK7455JgqvL/M6WyrGUI/nwrNPSYOdK81B7FLEnUaL75Go3Ae/nWNHtzCyaPgAL8MT22K4QKZiB9trRMb16Bpd5pwAt+4cx1LXuP/zmdOmQY+XHIigYXGjY0P4Zfy0wtR1NdwLFWFpJsYFEqAG+ODhwr3ly/n4EfZe8/+jszKOH7LOjCxmNtYwbmjiSbrj1CNEQ6zxPwsPXFwTsFeYGRVY8kmiImwcnyxWl4fbTS6mm50JcwU5Nnf3RqXT00IT/BacTKyXbsNw1MLDgryHc+RHDTeB0cemBRTw7aqJ9yYevqdctaNTkiV22hmPotvlHCgmSIVHD+Lw5jqGJ8QUeTLQ+myLNGZqAvDjOl/n+U56R26rcVMuvnn6NTTH2aECm2sx4cLoYsvpGZV7EqBOpxQRrSFm2BMPUjx8UB6MowFbuMyjW88d8Kt6yFdoa+hN+lbcj/Q202CnCdrW5SPL81Ew/Dh1Apf1cRJZ6t2WeK6NHWX60exZm5K0L1lr5ShuPyQSmst4zijmEEzT5a4eltj2+6Sm/RXmPU2wWzxWuiYt8WVCJ2cMXY7KzaM54vxIiAFTcn6ehgeOTGyiqDd595biirT1iJZ1ZgzYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(66946007)(38070700005)(54906003)(33656002)(508600001)(66476007)(186003)(71200400001)(107886003)(4326008)(66446008)(26005)(66556008)(82960400001)(8676002)(83380400001)(2906002)(5660300002)(316002)(6916009)(9686003)(86362001)(15650500001)(8936002)(52536014)(64756008)(122000001)(76116006)(7696005)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yisPyupAHwreI0cVsGpQ8n7/cJgX2olBsuV9LK63I5yykV+lo7tkA4lKKiUH?=
 =?us-ascii?Q?qGokqJ5FtKkrKa9mIEjaP74TLVeKNT8CvbAmkWg5D7/VMFYSd96sfwvhQ26e?=
 =?us-ascii?Q?1xMz8fH3/SIIAChU0RXHfeNtcuGMZZw674v5Kv2DnaS0WM7gxXJE8b4R0P4y?=
 =?us-ascii?Q?n6qCHYLfYDecELtCVJ6+RO91nAkEh7HYL+HjCIRo7Hk2HUMm7uUi64khK2Sl?=
 =?us-ascii?Q?usK9EhwXLqF9vx/sZLy0q9zB9HHvGMNlXeC/Qs0KtaEgj1VpiADaSchKuJUY?=
 =?us-ascii?Q?rrTIVqF6VUdo9FwhfQ7XUf0AyxGqIrkFbt3axKwVnWai2IAjrql+c/AteG0A?=
 =?us-ascii?Q?uNyVlPnvFBbPSG/Mw1eckezD9xap+cHCnqsZWL6svzui/GdYp2onwybOV9B5?=
 =?us-ascii?Q?edgaA0feowyAHCU7gCtswZ+wBjvLcVFgdNyjZWG335JVrs2U6niYd9Ms+Rdh?=
 =?us-ascii?Q?DvqKxDFsjycJBdDMWXNWdGg41TjoocqbCT6i3PpNIygqyvqnVF2qaP2QWAL3?=
 =?us-ascii?Q?XzlgT8Icz4/RxoJ/Buodu2ohfVVjsy5i2I1pZoLTcdidtkAC0SJ6zGVxieU7?=
 =?us-ascii?Q?uFov0AJOMkOXCDAc3rcgcjmcwPB0VGkXy6UuMYnLrb09ip8mengrobFb1uKo?=
 =?us-ascii?Q?2f1Ps/z07vtNtwhfkt3Z4igAC4PJPld2MLqQdTIxGs35EezahrI1bPZJYYR2?=
 =?us-ascii?Q?oYBhbU+1K3REwRq98fj831uEwKVsYlOGJTB3bpRjzg5nc9KEZMT0oBkB+WqQ?=
 =?us-ascii?Q?0dhqXSB0hEIBM7vwVWQm0zLqh3qz7bpaKpmtJc3srh02P2bzcZ8U3izaEZop?=
 =?us-ascii?Q?pq4FEGIL1lJC5jgqHr53ZOzXoX1z8j0SwVn/dSATWZ7gDCcbJwU4AjfUUMXq?=
 =?us-ascii?Q?5oEXe/+eRIoA4Qlj8PzBjRCRTEvTlCLmtM7NI2T556MJyn9vDp7mpxHf3UaW?=
 =?us-ascii?Q?wT13Oymqa2FzNcfwU0dNv18xAWSWA9Kzt7M4lHXOX6nKslNBwfNhBV9Pw91Z?=
 =?us-ascii?Q?K9lzGsw8I2gEt06MEx0Ale1md2Vrj2s95JoFevsi1KSAAEIEVXVHWJeiiQuJ?=
 =?us-ascii?Q?TQ/Zv08NVXWUiwlD0YeaKq+11xvsh/lmql+6VFzjQky4scotrZud/AfBgwjS?=
 =?us-ascii?Q?F7z7DvNIvAnDCzJDjoSFjaFF/1KyM3HZ7lfoo22CmPfLYsawi1pvY3AqzY6m?=
 =?us-ascii?Q?tPomSf9dnGMen4y6cCcHK6YD3z/11otTEGT7p9z9Ztj3tx8F0sQ/yNi+SzpY?=
 =?us-ascii?Q?Dwo1anO8R9ByHosdPylcieIOnTTPLhUPo41ffBA7MrLfIccl6vRoJbEucvdD?=
 =?us-ascii?Q?2E9PvhybqBjRYjYzPejzj28BIaj0zu9nn3B+HjvRlnNEPu5UtnuEAay6QBwe?=
 =?us-ascii?Q?qF7bLYfGs0hyTAv+dR+3oEEVxG4BYEZzFuihLKXp637+wKN8XOoWw9xDBlhV?=
 =?us-ascii?Q?xghz/MvqAc+usmm6CxAEO8LXG01ZJUzdiXl/ucA+r4TJ8vC7/wrRFe4DsAdg?=
 =?us-ascii?Q?EQmpsRdLLbLvWlG9x3NnErmin2TY2PFVPSxfHOKtOE6FlFMAJM6+8CzicZm7?=
 =?us-ascii?Q?YHJMqDs+qdkWDa2fUBwcegbWXTiYUbyMeTRHX2XhrMRJXFhi4A5UqbX4awQ6?=
 =?us-ascii?Q?sxzlIhwDka/re5ClN9TS4c4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7712f1c6-0b0c-4fa4-e184-08d9d4ae1104
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 02:57:12.3431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1pVfx4/fAZl8XFtepy/kN0PWrYNB1ER2Ownc6jDgkhHPwqXmRHZPyFikzqVyPrLxyFFLG/dnvoTDeGK+IKTg1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1393
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, January 11, 2022 1:53 AM
>=20
> > - It's necessary to support existing HW though it may only supports
> >   optional migration due to unbounded time of stopping DMA;
>=20
> At a minimum a device with optional migration needs to be reported to
> userspace and qemu should not blindly adopt it without some opt-in
> IMHO.

yes

>=20
> > - We should influence IP designers to design HW to allow preempting
> >   in-fly requests and stop DMA quickly (also implying the capability of
> >   aborting/resuming in-fly PRI requests);
>=20
> Yes, I think we need a way to suspend the device then abort its PRIs
> with some error. The ATS cache is not something that is migrated so
> this seems reasonable.

yes, any cache can be abandoned in the migration process. and such
error must be recoverable otherwise it would break the guest functionality.

The key is that PRI can happen at any time which implies that the device=20
must be able to preempt and abort a transaction in very fine-grained
granularity. There might be IP-specific factors affecting the final=20
preemption granularity (e.g. complex GPUs will certainly have more
challenges), which is what we need involve IP designers to fully understand=
.

>=20
> The only sketchy bit looks like how to resync the VM that still would
> have a PRI in its queue and would still want to answer it. That answer
> would have to be discarded..

Yes. This also suggests that iommu core needs allow the driver to cancel
all previously-queued PRI requests for its device so the guest answer to
that device can be ignored by the iommu core.

>=20
> > - Specific to the device state management uAPI, it should not assume
> >   a specific usage and instead allow the user to set a timeout value so
> >   transitioning to NDMA is failed if the operation cannot be completed
> >   within the specified timeout value. If the user doesn't set it, the
> >   migration driver could conservatively use a default timeout value to
> >   gate any potentially unbounded operation.
>=20
> This would need to go along with the flag above, as only optional
> drivers should have something like this.
>=20

Agree.

Thanks
Kevin
