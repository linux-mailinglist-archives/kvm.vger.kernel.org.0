Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6155D48A626
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 04:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235695AbiAKDOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 22:14:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:14815 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239786AbiAKDOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 22:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641870848; x=1673406848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qUiNMxCeLuOzDqvuRi2mTuOAjbXdZYFCR9jzJSy0pic=;
  b=l8jQeyKQgPr0U2aVXU9gTDX9JMj/3zyRQLFlAfyMAOl77ZOSeheaNM1O
   JKR0Ym+wY4sAXn8q629OgqB6Wu7VlX6ch/355ylVa2KOYJOqGkEzgGOvZ
   MPsO6MMarbQdaroLZ3bKLdSWNrAu0y2h+NH+8N4JAoGyes+j0h4DoK1K4
   Eue+ok2vA+NLI2+YiE1NiQFrZk/1PlpQlL20/LTp/ml69M7ZlRll2tyTt
   Li/gxN+o7ngZUKRDu+TGlomxqgL5h887z8NeBkx6ZNq6iND3XsD1DfBvL
   AM7HEKN3hSv2+805fCf61SmVupPybmPw0r72t1+Oca6eXqQOKTkoHGvtw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="267725003"
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="267725003"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2022 19:14:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,278,1635231600"; 
   d="scan'208";a="474364016"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 10 Jan 2022 19:14:06 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 10 Jan 2022 19:14:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 10 Jan 2022 19:14:05 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 10 Jan 2022 19:14:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBvtXd7wxXx8h71G0VcObM6fqr/DY7p2uH6M7vDo6pgB0RAxM/Czs8uCIhisRYXhE5RH8WkiboxlKeYjVbIXwNXrEGMAf4tZcC1fD0yCZpL8A7cJMm+HC4swz4JiQ0VA392XcVm6bYgURlEXpU6GcT5eoLJeC02N8wZF5U5XGcpfFM0ZQQQU37V6wsXZ84xyBGvxvt9JWfL1cUZapx0lHLjqVbdVBoQDDdSa4u+FMImaS30OoIufNbXr5xa/cqavHJi+tbQ+DsJaxyvpaPUHnXdIZFKEPTVPbu7sHlyvzi6kaRSEvx2IHaYo4tZs5XsxsLEP/BaSlPFooj0haYkpAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cFs0dWAc+UmjlPvwksN+b/4ke57UN+uF3BWPgMeW4RQ=;
 b=CPXzOCphPeS9t1ir1YPmvCLqb6/eVag6DgzUBPxbyJHJqdEX8D13Ep77nYSy89/T21/uh04HmW6xJY7SzcUDRZ/NGAXLmsoUR3wrlBdG2YFDRQa1MkWSDQP42CEcPG9PCBsHDtl1lh/kd6tRGjwrw8mE6KBRjI+lj9JPLb8Xaoj2kQI5ANeFwoIYcQFJslp6IcR3FGU+y1uFJs8Z2f3N1wrgdeVNghXf9cvjO06lwUjeKUN4E6CZbdrcrYOUxfqjkgAUx762OT27+DTJebQTatQgGfWBfegwiw4NZR2/n/BAyW6IvK0JMn1Iw+I6y8eNvVSOvIlNkS0ADcAEeqMwBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN7PR11MB2868.namprd11.prod.outlook.com (2603:10b6:406:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 11 Jan
 2022 03:14:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 03:14:04 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>
Subject: RE: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Topic: [RFC PATCH] vfio: Update/Clarify migration uAPI, add NDMA state
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAJ0m2AgBdyDgCAAv/9AIAAM0+AgAVWcQCAAL4AAIAAkuCA
Date:   Tue, 11 Jan 2022 03:14:04 +0000
Message-ID: <BN9PR11MB5276CD4004B789D004C8A1488C519@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <20211220152623.50d753ec.alex.williamson@redhat.com>
 <20220104202834.GM2328285@nvidia.com>
 <20220106111718.0e5f5ed6.alex.williamson@redhat.com>
 <20220106212057.GM2328285@nvidia.com>
 <BN9PR11MB52767CB9E4C30143065549C98C509@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220110181140.GH2328285@nvidia.com>
In-Reply-To: <20220110181140.GH2328285@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c3f3702-cae5-49fb-d222-08d9d4b06c0e
x-ms-traffictypediagnostic: BN7PR11MB2868:EE_
x-microsoft-antispam-prvs: <BN7PR11MB28687ED5B32541AE69B6ACAF8C519@BN7PR11MB2868.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGrH4Seb+yG28NNblFmR9yW5LUYDenDG5nHoDt3eyXnx0dogU/nyObm7Kwlp73q80JjVtwRDTIbO9sxyIPAA2LaLiafjrOx0rWecpnJdaMkE1Z4jKQPkK7C9Mam0Z4uEJrl4I1TMJkyCL5YqdtFas9BXKWa7gvfL9zR29Sx8fGczQ4ACLFedICo0eirCauy+I7RMU+SF5dG4sYESVleOrL6kubrhp1W84yD4+6Oxa0KmLhDlKFKikry7C2r9oIobYaHYQPML6Fe690UAY8DvtSOLhfTqypLALZReuDoEHw2AoyXKhNO2nJgKpON8YvIWTyEwVWnzLkO1ff7PGpuz0658gL7z2Iqs59+jBXIGXvjHM8/7gFFIHw5S932hlI7vK+jHEn2JcFuKBR7FORZ0NDySZC3Aslq310KdUZ59S9FLtj4ckre5MSTDiXXzEbt2skksvxMzPmf+7M19fywoTiSdvCrTnIem6pKRyLD3wiP9z6/0JKybrZN7R8C1NmPrnEq1EpBKfd1ox3mOoRNS+mnHMhnfBH6TyrjmEY/jAFZbk1T9Zq1y8JFZmOScunQS7LGbkQIRcZ1RR+c5fANURoBg8CHHoQJrUZovVEV5iQoz2sL1cz4vgz9YJ1Mgl5fk2of50snrHXaU15u0B4Jp+gBYbZOBUysM4i8X9xt7L8igM1sYGLrHBXkX3GLUh7Vjsan87sXgCRs0BGxIWZsm9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(66946007)(86362001)(6916009)(76116006)(66476007)(186003)(508600001)(66556008)(82960400001)(64756008)(66446008)(2906002)(8676002)(54906003)(8936002)(5660300002)(122000001)(4326008)(316002)(33656002)(26005)(38100700002)(55016003)(6506007)(9686003)(71200400001)(38070700005)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6PT3THBSL2it+MT48dC+zF+LvjgSOSom/sK5SvEeb/qtjkGWzVUJP4CtO/rT?=
 =?us-ascii?Q?kciumN1AvuxJ/Ghx8LzHHBIDoOvGXTE7lQmLBeuv/h4JhbmiBqKptCnMp1L6?=
 =?us-ascii?Q?Kod/5v/xyRFepzNhlVxJTVmIkSXeE1ARNJ5hAfUtuhcE/AeXEguNi/6XNNTt?=
 =?us-ascii?Q?0LFpPLIr8cvROUK+01VdTayOOuIKxmSurE9niBYgo5Q2TntNnqi5PTsFXFyd?=
 =?us-ascii?Q?oVxtJRxF2FnmwXIDMcN4VxIc5t1nRXD5E+1YGSwlAJ5DGENdSAqSFu9JO5AY?=
 =?us-ascii?Q?GzmbcRkXv4T65WX+JsUPax5hoLWAc1AV2utlJ2pjFMlZMTROQEP/46nMrSr9?=
 =?us-ascii?Q?goRR3gfWTXkqPUQkeI5aCKkTMcAOY6Qimgorjn+y/toPfDE/0ARy1leR3Hv4?=
 =?us-ascii?Q?+8s8SZ5cypoQSRpeU78qrfjzBwFTprD0E8pHntqIJojfw7r0/Em1yaAVNg5i?=
 =?us-ascii?Q?HDvUXKjyVYXIb/l8tCaeb/JmMia7os51bfgbKOE0La/RKVlUKHRmNtPk61T/?=
 =?us-ascii?Q?MPmK811ChzL6t3gdFQxr2r88sOMB4k8+dlO0nGVxAvYQqVFnkfR4Cbi241Yz?=
 =?us-ascii?Q?OoMTLZmePpXXhdRF0yUSUzb+VrwAN0thpMt6KhK9bidB7jVsaEVUpP31tV93?=
 =?us-ascii?Q?YR0eIO5LyoEhQZ3MtKFCoblnB6L1JLj+ajhKNt3ztd4iWi6Z9qnKYFGWE+xz?=
 =?us-ascii?Q?zf8wUgRgeDZxY5uqnN5HqxFMDOTXpRj5Ptb015PAfROreTSRouE1SNE0VHYZ?=
 =?us-ascii?Q?bOT1nUAJT7wcaXRIaWlAgQ++j2lwQezjNK2C9ep0sFtUgh4Ow7ywrCA/k0qR?=
 =?us-ascii?Q?6LxZ4zO35ST4nIjEO11GHaA1Iz8sUd1fZSPKu75sE0Q6Z9lhyG6TveH7+7k3?=
 =?us-ascii?Q?vP9pYBJNS41aKpRVvyQWZsv0kt8Wq3x/qO0uskqqYpU90QfLKmKDi8qdGMBV?=
 =?us-ascii?Q?Z/3zQRox3I/S82dSjxmY0ZQElYSHy76ceO1hhDvMdjqVaHucOkUnxHERdAzS?=
 =?us-ascii?Q?/Ogox5zYJo18QJh0U3+ej0gRavQeFFjf88P98G1F5rRKXFZkhglfiSQIzFMh?=
 =?us-ascii?Q?T3OAQA6d0uJXe4rl+nZp+fI67fga64reZ/3RhRBqlC5l2zWzI8bq4V9WzKFD?=
 =?us-ascii?Q?cfBZSRnX+6spirYZv07rf6tNnFUHws2KldmB5xJYOwSjRxYvUSvKq1ikfrR5?=
 =?us-ascii?Q?KHFX6P3mwELn70EJEc2tIZoGj4GxLre2FhpuWPHTUyoqob93kTA1RNB+AZ3h?=
 =?us-ascii?Q?asUim8R4qvKJZe+Uf7d6uur6UzS7SCErSH5VaA2VBCsu3ekH6736NJGFqJ9S?=
 =?us-ascii?Q?CEcWuiR+10PdPNLNVDEBClYqYRGM9OsZRFvNWvZPEwxpeE5Euzhtp5a3loUp?=
 =?us-ascii?Q?J8Pdco4JD3PPwSpCkG/Ljk/UsnMDrSyg9TWKPhFOd/zqxt/dfi7HYyjjys6S?=
 =?us-ascii?Q?sV5ogC/9Kr9s31SKk2UWlE6V2QACitvcHG8hFfIICISEooKQzwwnXCwHc6kd?=
 =?us-ascii?Q?v7MwD+TXJuRjk8J/++1ZMSby8jx/M8D65C0ltokURlkbsViliAjfOEgzzOcO?=
 =?us-ascii?Q?6G2tBnhkN+2hdU/pDuPld3yVauV0UgBaBAcggTAGBzuwQhubSu+UhRrNo9a2?=
 =?us-ascii?Q?RuFBl1WhPl7KELMO2Cu3hpU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c3f3702-cae5-49fb-d222-08d9d4b06c0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 03:14:04.1182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Q1Pbo49RUjzUAn01wOzOyennRU5eDR3UDzvJudaZR8IzuMt+OqcBUNcFea2JZc78nQa25hrfdQg4zORidUoww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2868
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, January 11, 2022 2:12 AM
>=20
> On Mon, Jan 10, 2022 at 07:55:16AM +0000, Tian, Kevin wrote:
>=20
> > > > {SAVING} -> {RESUMING}
> > > > 	If not supported, user can achieve this via:
> > > > 		{SAVING}->{RUNNING}->{RESUMING}
> > > > 		{SAVING}-RESET->{RUNNING}->{RESUMING}
> > >
> > > This can be:
> > >
> > > SAVING -> STOP -> RESUMING
> >
> > From Alex's original description the default device state is RUNNING.
> > This supposed to be the initial state on the dest machine for the
> > device assigned to Qemu before Qemu resumes the device state.
> > Then how do we eliminate the RUNNING state in above flow? Who
> > makes STOP as the initial state on the dest node?
>=20
> All of this notation should be read with the idea that the
> device_state is already somehow moved away from RESET. Ie the above
> notation is about what is possible once qemu has already moved the
> device to SAVING.

Qemu moves the device to SAVING on the src node.

On the dest the device is in RUNNING (after reset) which can be directly
transitioned to RESUMING. I didn't see the point of adding a STOP here.

>=20
> > > This is currently buggy as-is because they cannot DMA map these
> > > things, touch them with the CPU and kmap, or do, really, anything wit=
h
> > > them.
> >
> > Can you elaborate why mdev cannot access p2p pages?
>=20
> It is just a failure of APIs in the kernel. A p2p page has no 'struct
> page' so it cannot be used in a scatter list, and thus cannot be used in
> dma_map_sg.
>=20
> It also cannot be kmap'd, or memcpy'd from.
>=20
> So, essentially, everything that a current mdev drivers try to do will
> crash with a non-struct page pfn.
>=20
> In principle this could all be made to work someday, but it doesn't
> work now.
>=20
> What I want to do is make these APIs correctly use struct page and
> block all non-struct page memory from getting into them.
>=20

I see.=20

It does make sense for the current sw mdev drivers.

Later when supporting hw mdev (with pasid granular isolation in
iommu), this restriction can be uplifted as it doesn't use dma api
and is pretty much like a pdev regarding to ioas management.

Thanks
Kevin
