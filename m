Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6954A49D702
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 01:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiA0Ax7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 19:53:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:50354 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbiA0Ax7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 19:53:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643244839; x=1674780839;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RNzto7hveYs4rhaAKitJba9ZQGu9ar4QTHQq8SziDYU=;
  b=FxF56E7/e9T8/v59EmJQqRFPrdIooxa2fRJgDrzjRy2E5pHhkxfri/Z6
   U7M/26yoRKM7NiHzBXPaRTOh/iO3GHO0HtIIwXrezAZPvC7izGUMYECsU
   RJhKaCZsnvvvwVNMRCqeANvC8oPfBuccY/JB152p4+NYG/ong8phaBGHE
   rgjFvf2OeNM7nbupRxxSEuxWI7VWNSCwslOL2coMM4kixlHYK0yybeiIM
   dHlA0t78zjlUPFt9DepPP9BQvU0In8WVsUSPs8UtTIdD3emRamnI2Kylt
   Cdl8z3ec/Ww/4HbjvOODDokuMy48w+xd+FfRBIXiP/P/1DFCdgIPWWT+l
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="227378844"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="227378844"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 16:53:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="767320929"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jan 2022 16:53:57 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 16:53:56 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 16:53:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 16:53:56 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 16:53:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlKcr5+jPebuLVUmCj1G39a4cJShoW5F5ds9beCaUuX/LjuKxKoT3ygs8I9cI/vxDIEMX7z3xh41l1XP2h/IHR8iVdWCxPppCSmZyaHZRYX7bMSxhw6lGxO/9ga6tr42+UcML0Hdd5LoOBKzluioD5iYGbBUWet+YFurgzZMIiCDdDxa8mbt2Q5S5cV+qvEA2x7eugyuRBh0Zka90QANxWDNgGluZBQdTQqqBtCyBn7YBr47W8AZnvJE1CHWASHtBwPf50DGL7N65Ch/o3uTfaNZ/UIzDLl5DJV0Liab/KlxrHZ46ITldSxAWvJi6Yw1XyL6vK4yJ1qaz5lryQ017g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNzto7hveYs4rhaAKitJba9ZQGu9ar4QTHQq8SziDYU=;
 b=H4a4B8KtJ0amSkrkRy/ajq5tLmkCRKver1HxY1MCtJoLJCJyXSlh3IGwTNT7xLfDser2yr05AhciJnalUz2Tfhh8WHd7hQ9l13Y/2TDnIj7jlR47T0yGL6zyBZhHOvGTbeLYBXsviRxyNZWiC9v3+2lMujCGcGX25vAGgospiTr1rEdByr8rCm49nXbQBYtjuPe5IBSCKsHVinliokRoVlsNFDDUavy1kyxzeNnQxQPiqgFwUDmwwpAHq11ORDJcCNpxMFhbD6xro4AWVXThGc5UykYInDF8lS47HfBCF5fz1ohbKmokL1GWRC5I5+3v8MoCsj7owxgw9D6jXdyqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:53:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 00:53:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Yishai Hadas" <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4IAABfUAgAAA/XCAALJVgIAAz/0A
Date:   Thu, 27 Jan 2022 00:53:54 +0000
Message-ID: <BN9PR11MB5276141AC961A04A89235B428C219@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com>
In-Reply-To: <20220126121447.GQ84788@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2019d04-7a8a-4468-a7b5-08d9e12f7e51
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_
x-microsoft-antispam-prvs: <BN7PR11MB267328DDA8EA59EC47915A808C219@BN7PR11MB2673.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cToOuO4zEPEzf+3vIAl5ooCfe/CYUx6Bu/qoVR9jMYbfxOkCEOnMBmAELT17X+jTbUub3k3GHrgEseMWvXfnKNv0DkUOmqP3nv2MuldI3fj6z5tyu9/pqnHWGheKH/TiIRkS5iS31CZWTiBhY5H7eConImWdmD60RmEHCn+hEhNw6SR67W/ipd6t//KJJA45Pk1PJdM/sC8m2OvZMHz3rRiqsBD1fX5Uo1/YhTZxTKUtT2WBmlqkmhzxYfTfWhpIspb8gMdOY5tNNhwUHs5BFACQRStQwCHJwMBoJPD1aitmUBIXZEDZxV5SFYXXpUOzwZYA6CfnjomjmXWJG/NUHMPGNKkvQkwAwORxU922H3rHC3t8xvwxXMangEVDL5B3jjIl2/G9cmRpPXssosf0clmgsBfkCviR35V5MKtKSEQlmDjPBazRAWef/CR4wJdDUrZQ6f9DzK+ZUHDOd0Ks7TJaVi9YnZ3aZOxoBBKHAhY3IPgWjMxjXE8fd5e5AJ7GOaIfQ4+tiVlU62xCmJt5fry1c/giAWP6RYu7KaRmhdWXcoBFLm5VxQp6A0yIJaXC/Nml7u14Re6OCZV1tpzNwEwGcrVliWM6qFa+TL5xGGni2HCqX6JlA6VkWAbYchC1mo2LTZ/CM/WJlE+zAQ9qv4XamzOQrzvpkrYbLMKZvy5PRhPHwOgahEzQv8lBFvMfOmNgIqtVJxrHM8U2nah46Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(82960400001)(83380400001)(33656002)(122000001)(66476007)(76116006)(64756008)(66446008)(66946007)(66556008)(5660300002)(316002)(52536014)(9686003)(7696005)(86362001)(2906002)(8936002)(8676002)(4326008)(54906003)(6916009)(508600001)(55016003)(71200400001)(38070700005)(26005)(186003)(6506007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TcFrrPfBkfzz7wTcHpNf7oG5x6tNKsYvuGBT1d1WHLZAjmwd9tMl757m5K23?=
 =?us-ascii?Q?wu//XDiTOkP+RK4ZfmQy+mUE9h4nRP6YrFGXSy2pYlUnTaHe9YTWECLtUZWl?=
 =?us-ascii?Q?A62PieOfsgXwqegsZzxlt1g6DHqlPFxcu5cHkJALpSOqWsRWSfuSYkC1gnp9?=
 =?us-ascii?Q?dJQM9icqbqL/GSkYlFiOMPWDdGdOtQzOeYiNQygf6y3HG4gqf5vc8+0FZJbk?=
 =?us-ascii?Q?c+Av731Gr0+rOYQfRTyYOd76yWRhCIiczj/3Wb/Amp4pHsdLfr4wLDDJ1EVb?=
 =?us-ascii?Q?a/QfTVsoCnQZR+UMwiRSNlpWKv4tbevUBETTiLno6gmcJFKLly7V1/Wz8VF5?=
 =?us-ascii?Q?YRHKy9U6H7pWYU/FTZwRKRhszZGEHI4Qfb3EaJJazzrm8qp/3ErGOvCLsAXu?=
 =?us-ascii?Q?doSs9Fe0xeW+Qv87fwGbVbaD1rFXKxqSBn0dSIBxY1u6GpQxy8C9dQ7yE40X?=
 =?us-ascii?Q?rKvRpbXkiSqqiln1MK7tnJfBdAVUGR0nE1ZBQD4wdD0FTW/xxTCae8Wm6hHj?=
 =?us-ascii?Q?+SsjPTraVjcrdGzpfl03ajSpZm0FhpABp1IvqNmnLQvRfsF4prRPUdUZ3cwq?=
 =?us-ascii?Q?d1MtoP0fVx126YP2wpGRHguIa2diSs1iYkXZPdHXskn+YWViP153f2UjsFUl?=
 =?us-ascii?Q?bAaPA3oFOkwX9JqGqLBZ3MCVqqEoSmPzgEIti+tfM+WyxnvLqytK4S+qLxAm?=
 =?us-ascii?Q?h8jyF516t/OgMcu163uQpayS5cHr76OXy/P1mcp0vyGCvCdlDlrvz/TIQN1u?=
 =?us-ascii?Q?ZoIRu03Q2JSaU+fghIlmms+BEQJWU2gMNlW6uh+Wk2VK4zNZqfWWanzISbSD?=
 =?us-ascii?Q?pJsNYM7D1bwjg7AVDyBiegg17Ra4aAxYL8vV90Kx7lIp/kCzPb8E7PciSi1t?=
 =?us-ascii?Q?2WUQjpR4w7uPZKFw6PKrrSH8YllTJxPKw9CNIMEkffLUQnxoAcyNFK3ptNsU?=
 =?us-ascii?Q?ub//r0QHG/XDlcHkwbWjFtQVVpLlnsXtYvI2ltNde0ZSum5hwNrCeGF1HH7b?=
 =?us-ascii?Q?/mf4Y2O3pVhTn30RTXEnmkwD3yp1GrQFbiU9Pkur0Lm9lZjkAAuzdY36jmTc?=
 =?us-ascii?Q?5lClFwdPpZ/z6gaJ/xXrpwOJynk3bp1g1SaxqkQGju7eyNVJq3ENY4bjt+SM?=
 =?us-ascii?Q?8fdQv1CxQ0QNhvzCPI+av3D33vc1iJB9Cf1IZraCEgZonPVDfk8Yg25PKEHX?=
 =?us-ascii?Q?WqT8RoStsY+W3yIPTZ1HnZbYNZ/aOgpL+D1fKsfiiK00WB0OPqfu9LUWntBS?=
 =?us-ascii?Q?zPXxSqzXbYonViYRsxQJyGUh4CjVLGVK1yj7NdbxTwQLW199I6WE6vLFsxt7?=
 =?us-ascii?Q?hYQ7Ig47cDC2Vq0awMH/l2srHJp4GLkCK/9LkQtagvzy+MoggMzcqzt0qjCV?=
 =?us-ascii?Q?nkWGTaQdexWS4VfhlN9RLkbG5UjcOI21CpxURYw0dr61LkEls/0+c7Fw624B?=
 =?us-ascii?Q?iPE6dEPlD/zf0w/5lX9EoNiI49++acZuaF8bAH0NUzI1xR8k955XzJu7g7x7?=
 =?us-ascii?Q?Z42VTOqO1wsAMC3B8E4TdJRjeJJCgsdYsdqXHYaNv5n3j4a3liXIith8/djm?=
 =?us-ascii?Q?kUuTKsAK535wvKqfZO2Royn0kcziT1pmP0pAIK2raT9eu3LVExC080x0F8Vr?=
 =?us-ascii?Q?XZo+IGUdffFy/gQwnP+wDG4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2019d04-7a8a-4468-a7b5-08d9e12f7e51
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 00:53:54.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TwYM9+LABtdoxQ0YbO3ZvjIycNrFNcVYQLM41P9n9NgyeagtdiAdRP6mSgQPUlvHbkf45fjCwdrcwecaJU31DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2673
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 26, 2022 8:15 PM
>=20
> On Wed, Jan 26, 2022 at 01:49:09AM +0000, Tian, Kevin wrote:
>=20
> > > As STOP_PRI can be defined as halting any new PRIs and always return
> > > immediately.
> >
> > The problem is that on such devices PRIs are continuously triggered
> > when the driver tries to drain the in-fly requests to enter STOP_P2P
> > or STOP_COPY. If we simply halt any new PRIs in STOP_PRI, it
> > essentially implies no migration support for such device.
>=20
> So what can this HW even do? It can't immediately stop and disable its
> queues?
>=20
> Are you sure it can support migration?

It's a draining model thus cannot immediately stop. Instead it has to
wait for in-fly requests to be completed (even not talking about vPRI).

It cannot support mandatory migration, but definitely can support
optional migration per our earlier discussions. Due to unbound time
of completing in-fly requests there is higher likelihood of breaking SLA.
For this case having a way allowing user to specify a timeout would=20
be beneficial even for the base arc <RUNNING -> STOP>

>=20
> > > STOP_P2P can hang if PRI's are open
> >
> > In earlier discussions we agreed on a timeout mechanism to avoid such
> > hang issue.
>=20
> It is very ugly, ideally I'd prefer the userspace to handle the
> timeout policy..

timeout policy is always in userspace. We just need an interface for the us=
er
to communicate it to the kernel.=20

Thanks
Kevin
