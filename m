Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6380B486E34
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 01:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343660AbiAGAA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 19:00:26 -0500
Received: from mga18.intel.com ([134.134.136.126]:56139 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232804AbiAGAAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 19:00:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641513625; x=1673049625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vvVewBGy8r4JdgzAMnyhjGJ1JMDWCqhxEDNwPluOyKg=;
  b=aUx8dMFVzWF557r0fDRKCDGgsJZHUfQneGzh48tzlI21ji0fsAe0RC+9
   kY06RZD5qQf/fNPg2zC+6OuLbfKEhQTJHTJxLpeDLM8QalekeySSSth58
   pCe7s+yvvbNfJ9fKnsO8ddcVZ75GTu8bygJx03QIIuEU5mgExT1xx/YkU
   j+0fi4s7eabprmP9CwzKuyhO6ECtGqjSsezO+6UIvf4bqgrlbrXr8H/H3
   psCh38fcS2ilYORDvBOfDmg25Ao7fSUzGx0k1vNsvn4hTpaLdOC3nI6TZ
   IO6XwJ9uEOWW0zamyiUzVLs9b3OLcKBw3UrVTw+YqrF8j22Pp7TQ0cQ+N
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="229574487"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="229574487"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:00:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="591544884"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga004.fm.intel.com with ESMTP; 06 Jan 2022 16:00:22 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 16:00:21 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 6 Jan 2022 16:00:21 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 6 Jan 2022 16:00:21 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 6 Jan 2022 16:00:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvRTnpAGtZAEPiopoyiAFD0kTt9ir387Zd9507KZg6elD9I4ZES5LN+JhTfnDBoLj/TvfVx9kVv69wJE2Lf2R1qXo1tlorltjQA4TPM4n8CwgZzOjd3Frp5tXKOJzvf8DdhQtk8eqjKudPftHK+X3mN1rNmRNeiJ7q5NC/cSg/y/hH1ObW5GC2/96sUAfUbJegJJGFzpCBs3QOCR+74+uZkArW5R6HiLTzss7yKN4VSJ0UjgV2ZQ7T1cMG4YYDDhiIvGaDK2oqcB60QoQ+km84wjBCnTFGUJhU0wEhGcahsLxpPVuE9cbBa7Qyzt4HJofpZc2zJSlqQzhY6hlnhJlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vvVewBGy8r4JdgzAMnyhjGJ1JMDWCqhxEDNwPluOyKg=;
 b=UEuBgDzUy83Q2l0okUnFzupl6DYP3Xz0EqoqaJxuHe0NKRT0VR3nJ4DPKFW0VIID3/821ngzFFC2p0/DX8MhPFT7pFTaQQIcXRAfdgDbAfT7W09WyldHqLmPoAtG/pbpDBInly3EJ/xClQMDj1ZAK/s2m4ax6CAmzOz17H4hbIP3QI/IPfEDZtgfn/fzDS0j6ymaq8yYnCKoY8YzccOyvcXLii6IAtZd2kOmyHGSAAfejaiydYEeBph/hT/ETj+FB4q8RLAEIEBgIAcSvBczksSV57CyVcEUVnihJL+PLZiuQByPaXMjVlee7Xx25wcjbeyXLPD4s0uSXnuEfYteRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2707.namprd11.prod.outlook.com (2603:10b6:406:ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 00:00:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.010; Fri, 7 Jan 2022
 00:00:13 +0000
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
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IIAAwDmAgAES3TCAALDYAIAAhPxg
Date:   Fri, 7 Jan 2022 00:00:13 +0000
Message-ID: <BN9PR11MB5276E587A02FC231343C87F98C4D9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com>
 <BN9PR11MB527662CA4820107EA7B6CC278C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220105124533.GP2328285@nvidia.com>
 <BN9PR11MB5276E5F4C19FB368414500368C4C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220106154216.GF2328285@nvidia.com>
In-Reply-To: <20220106154216.GF2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cca20dc-2ded-431d-cc81-08d9d170ae40
x-ms-traffictypediagnostic: BN7PR11MB2707:EE_
x-microsoft-antispam-prvs: <BN7PR11MB2707A2A24091EEA6A735B2288C4D9@BN7PR11MB2707.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9k8Icxhv3StGPp2z9J+TwsB5L4qU4k52LC3fBUFuHhsY9AG9n3l3nPzCNrdVoI/Cm/0kBI0Okg0io1ynTYfRwzYqHstG/L4KwvdRiZNa8sKdSBFpsE93pgr4KBbDexofy7wpgSgSRSTAi+74QRtbWH/mTjNctjw/3wuD75ksaOgqo3EwJqX6EHI55M24dwKDteV9W8xDJq7gv8ivkjXp5wWAE0woBKEj7IuX3xNNQLP2RvdpYM3eLrZ/ijiCfdpK6WY/nnoP4o9USM4xk4mXi2LhYkTQ7/TzQGjzWFWs8Qdviiygkfqpm+94kXVryTE+8+oEqOBSpzW8cCIctTiNg+jWe9CMhsqIkx1MJjNOsRqu9mDgVVMc/sE081/kLkE6lUN9JXQCEOnDnP69ftiqTFOlUekbwFUf15SXhD2G4Z0KMyPxdjAkbkURzJyuueesuUCD6R3tgYmeJr559ly62EtuVpnsLrPoPSzCKNiDgJD6T8NLIOf3nWUnD50z0i1USTOr+h93EqpQUXDp2V5/1Ki7JDe8PuhNdv6JfwNRiwlC2TB+0Np4LhqEedHguiPgjxyi7h8qXGhs2BcuhMQBj50JPrkwrhTOseAf3FZ6mEyhA2FeVvKxfxxBKK/E5TMRqKGEU3USJTX33Yv2qhnrGcbJ+/sY4f5/Frzhn/ExVOiktTV2EZNSZ/uza7+LOE02d2etZTkrHkO8e4WlvB835Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(66556008)(8676002)(82960400001)(54906003)(64756008)(52536014)(2906002)(86362001)(508600001)(15650500001)(186003)(7696005)(26005)(5660300002)(38100700002)(6506007)(33656002)(55016003)(316002)(122000001)(9686003)(4326008)(107886003)(66946007)(38070700005)(76116006)(66476007)(83380400001)(66446008)(6916009)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HMFYsMftdfpudA6B9IPFvQ84dTtvmb4zOxRYQNDIQ61FZ8eHulTmwajYdIca?=
 =?us-ascii?Q?81SpH5syHnpW7PkbXB3xFVfQKhoF/hRLcucMx9+jRIYGirSNP778ILVcBJmT?=
 =?us-ascii?Q?Nsj8Dq1Q5G864ffn+QP4ov5HWvlG4JHNCzv0lsO99fWzZqNBfOHQihruQyBx?=
 =?us-ascii?Q?QaAQTlaR3R25dCyaNXyRZRFhN/1X4QQuiq8gydioanEvy0GASTsFoRD8fS6o?=
 =?us-ascii?Q?y/t7OL0NE58Lq33gEDTSgln4kmAhGirlXLPkJQA42lr4cZILKWjCxrcpcDuP?=
 =?us-ascii?Q?Yp31ezMkJemk/0G/hXXnI3mSsfEpR8kvFl379yVUWDC1iFwBiaA7A2492r+k?=
 =?us-ascii?Q?0cldiwzuqwZvmXfJc4yEcbyo5KqOn+mui5zD7YbhF44mHPZnJJM470jY+U8Y?=
 =?us-ascii?Q?9YSDCUB72DnN4twtaYIgLx4TY3DEY8wo6ojfv95HBYX28Ninqi2knWSgsMFW?=
 =?us-ascii?Q?z0HHHGzJjXUMk5rwp8TNkU1pa4lvbiVfd3BDPYtFCzoWObMRvQBCzChJ2bIi?=
 =?us-ascii?Q?2/txoXzVSb4Vee5vc2i1HB8E9zZi93s6TA8fxCQM5gE1BGiHwoE3GERJBHlg?=
 =?us-ascii?Q?ioUDunKoAjU8Exr4fFrR+o+ls0HEqp0LIGcXxv4Gw5kNVs5LkyyrWjsnf/LV?=
 =?us-ascii?Q?RC07W+Q/sZ0lorKjiaaWNNedJpSmUn4dTzn+DpS5vdq7cIQSyO7sNMlzY2Nb?=
 =?us-ascii?Q?NxEXTprSdt///WHHESn2ZO1hO4QP8wWdelgwppqGkdLRqr2ohLBdKF8rW/et?=
 =?us-ascii?Q?YlkS5D4twjYJSrBaUkR7eHMelF5D9nNi8/KpRdfJEIlleO9nf9QjIvM87nbO?=
 =?us-ascii?Q?wAkcz9JkL7yxcXh9gd5zM5PQ0/IC73IYLj61CXD8lKaff/rzMFBSWVSLOHDc?=
 =?us-ascii?Q?uVWbcDPncwt3l8+GK4oAu2Ussh6jMBI+972y5xUUnipaojRffm+Bxak2970x?=
 =?us-ascii?Q?BQ0ZNaGD/82BNEF+MwzYKwHnTHmEUvoBKUvmllCL6fsKOceeRHlRzzksYpD1?=
 =?us-ascii?Q?YM8ZQg/sUCwL2WSRrGovBBqldIHpUpFoRs6IjPQywyUkQ4zcFf5t/T+HqfJR?=
 =?us-ascii?Q?evMZTSDxxkXvEMVfdbdIJZe1ixvWJKqirY6YYK5WErPpu9HoLHgQca5vLnBY?=
 =?us-ascii?Q?9t8tp8M4xEt1w2nTMGtTtwHzwRubD9daWSw1g7ANAFy1WjIRVPexoBrWMVH5?=
 =?us-ascii?Q?01uWg/Q2zSOXJHhWjwV0NBGKStyyUt0nKUomD+TOk4m7n68auq7kyuF3GuHw?=
 =?us-ascii?Q?8RroDpblyQxp8W0y3AAGWPRlXgZH+H+yezuCwhlw62yFqnou2kQxvyi2wJL2?=
 =?us-ascii?Q?MwDoQPlgzMxKb0U5OKyneNOfA/83cjUNYK9kFAWdY/wMAsxPask5o8El7j21?=
 =?us-ascii?Q?DGWsvianMuCcY/+Dg//cIelXTwRjY18/XMwwMHj2UUhRYdxw4lWd6rtFo+Lp?=
 =?us-ascii?Q?0lVCpWR9ta2N04h00KC4dZ32JYEVjSOKJlyur/68y/DfbLiaTfAVpjO04Xlg?=
 =?us-ascii?Q?/m/Ss3Sp/plYcW+xVASwi0WElq5ev1KMVddpFdGQj4dIc1H/mNcYZAChAuBj?=
 =?us-ascii?Q?9GrE18fNN6JECPlcJ7d15DhhcmZgRJUUOEJYkKNmczKZUzWSVcKgjhSUaFiC?=
 =?us-ascii?Q?G8c9Gmzb4Rt0Oe4Cbqpdi58=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cca20dc-2ded-431d-cc81-08d9d170ae40
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 00:00:13.8067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sk/DNnpXkA4FpkcP4AS3tmfU86lwy+BF+zn37d5vykcWUH/uJ8B3No57D8a+juAbxn70WYMOs6aHhxeVKAnRrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2707
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, January 6, 2022 11:42 PM
>=20
> On Thu, Jan 06, 2022 at 06:32:57AM +0000, Tian, Kevin wrote:
>=20
> > Putting PRI aside the time to drain in-fly requests is undefined. It de=
pends
> > on how many pending requests to be waited for before completing the
> > draining command on the device. This is IP specific (e.g. whether suppo=
rts
> > preemption) and also guest specific (e.g. whether it's actively submitt=
ing
> > workload).
>=20
> You are assuming a model where NDMA has to be implemented by pushing a
> command, but I would say that is very poor IP design.

I was not assuming a single model. I just wanted to figure out
how this model can be supported in this design, given I saw
many examples of it.

>=20
> A device is fully in self-control of its own DMA and it should simply
> stop it quickly when doing NDMA.

simple on some classes, but definitely not so simple on others.

>=20
> Devices that are poorly designed here will have very long migration
> downtime latencies and people simply won't want to use them.

Different usages have different latency requirement. Do we just want
people to decide whether to manage state for a device by measurement?
There is always difference between an experimental environment and
final production environment. A timeout mechanism is more robust=20
as the last resort than breaking SLA in case of any surprise in the=20
production environment.

>=20
> > > > Whether the said DOS is a real concern and how severe it is are usa=
ge
> > > > specific things. Why would we want to hardcode such restriction on
> > > > an uAPI? Just give the choice to the admin (as long as this restric=
tion is
> > > > clearly communicated to userspace clearly)...
> > >
> > > IMHO it is not just DOS, PRI can become dependent on IO which require=
s
> > > DMA to complete.
> > >
> > > You could quickly get yourself into a deadlock situation where the
> > > hypervisor has disabled DMA activities of other devices and the vPRI
> > > simply cannot be completed.
> >
> > How is it related to PRI which is only about address translation?
>=20
> In something like SVA PRI can request a page which is not present and
> the OS has to do DMA to load the page back from storage to make it
> present and respond to the translation request.
>=20
> The DMA is not related to the device doing the PRI in the first place,
> but if the hypervisor has blocked the DMA already for some other
> reason (perhaps that device is also doing PRI) then it all will
> deadlock.

yes, but with timeout the NDMA path doesn't care about whether
a PRI is not responded (due to hostile VM or such block-dma case). It
simply fails the state transition request when timeout is triggered.

Thanks
Kevin
