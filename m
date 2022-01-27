Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540AF49D6E0
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 01:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiA0Ai3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 19:38:29 -0500
Received: from mga12.intel.com ([192.55.52.136]:28516 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbiA0Ai2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 19:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643243908; x=1674779908;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3q/EPLTi3QIZG4b0kcZT0wfKKBVD/NtnqSftrcjxs98=;
  b=OWXbT/fP8a4Fv4+TXi+ihy+c7FYbO65sHTGEMM7Oec3vexMkNrryXwHD
   80oxul3Pzeu8k//Wjdp1rBl52bt3dQeisnOz0EvOsCAtkuGKiIavtTUU5
   HhY+HxpE19QBqoYMjtV7Re32K4yhJCpPXQ8hp+vkYcdBiMHpIVkQzpyek
   sDN6aRa2QfiZAOI2QxbaJZduLZcuxWf6wgLyHYKdF8Y/SeoOKwp0X4+GP
   M+NHbYUGk1kwUWL4a5RDAcRRH+bI1XJK4nWYxFMjfaOUy0lu1HbGM/fZm
   fBSr9oSMBvyUZKOtldW8lKBZxMEHKWOE+i6tkc3d6pytMEjA8P4PQ5uKs
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="226678864"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="226678864"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 16:38:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="477667683"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 26 Jan 2022 16:38:27 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 16:38:26 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 16:38:26 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 16:38:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNlX+v6wMRWD5MB6+IDxxUZY/7Pg45+3XjGPUfRj1qybmTz1GIjvvrNUKTTYb9WjpnMPqnOxBy09kuk2Kugu/iuaNRlZZpvXseNV1PCZXBVqq1e19oDtOw0InW0JLK/MXIpKF7NyNW/WoNie248RG9zYiqbPCwyEzRq/gxpTBhJybh3+dI8F9G7SiPsQgLotSFsnPDZewfR0au7pzJ6HERNc5doTGHHIUEy/RPFsEIKjgE2sx0zD+hhH5mmpgRCEp3Uhw5WEWdySQnt/nyw3E4LrCfdnEKmpVlcttBxOAtQVHzgD6WaJ8MIRURIMOGiD9JCw0AsG/3mvsIjUr5ygTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3q/EPLTi3QIZG4b0kcZT0wfKKBVD/NtnqSftrcjxs98=;
 b=Djk4+nJZOPezwhUrMLBkTN/mPc1DFKJq9uOkhZGL/rl8wv+vtnS1XcS9cV43dZwaaPOZxPfqTkdZ3AvjrbU25aFiMa+lsTS9qyxbMWCGj+zhdr6XXgoQamia+h6l4Y95UawDwgQS9anDKch3tSowlCfkCgl9MgS1vyO8oATNc/8D/aMArr9cJYmrkf4acrWr5etIlj4fKW2c2DiMt30WllbcZwHcWC06GJQSxzRCLJR2dkH28vpRD8ovL3Ms7GgQxChe1dhpESacPyzhFQn/bAapdcis0rJQrRy8LEXp6di/BNglMcPe9C1M/ett3mZFl6AgsQ5y1of8nqWymdyC0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3705.namprd11.prod.outlook.com (2603:10b6:5:136::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:38:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e46b:a312:2f85:76dc%4]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 00:38:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: RE: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Topic: [PATCH RFC] vfio: Revise and update the migration uAPI
 description
Thread-Index: AQHYCX3pQbl/KJiueUy+Ou1rwdnoq6xzKCRggACfIwCAAMkU4IAABfUAgAAA/XCAALJVgIAAN2OAgACThvA=
Date:   Thu, 27 Jan 2022 00:38:24 +0000
Message-ID: <BN9PR11MB5276826AC416E13B62AD99568C219@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <BN9PR11MB5276BD5DB1F51694501849568C5F9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220125131158.GJ84788@nvidia.com>
 <BN9PR11MB5276AFC1BDE4B4D9634947C28C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126013258.GN84788@nvidia.com>
 <BN9PR11MB5276CC27EA06D32608E118648C209@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220126121447.GQ84788@nvidia.com> <20220126153301.GS84788@nvidia.com>
In-Reply-To: <20220126153301.GS84788@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 4d8b7f84-013f-4f33-fbf6-08d9e12d541d
x-ms-traffictypediagnostic: DM6PR11MB3705:EE_
x-microsoft-antispam-prvs: <DM6PR11MB37058E22A42351756CFCBC178C219@DM6PR11MB3705.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EItl97qFvgt5WQa9zzNT640/hV4EgoTDRofB+HNucbbe7YjTrx9/s9zSBOZXDpAmNQ/JPRB8Bt1OA+WytUl1HN0K0vAwlAqIh5CtxQ+QCTipQdh8LjomZdx4ScB99r0uF6hMVTtQxgN8fG2IltBlPpGAd4P+6vqf4GDQon0EANtU7njxWBAaK9+CUkdC+gxnLUZI87dWZW/+zS0AdfMa3FXt92le35GDX86o0QHHKF7E5OK/K22lCmEL24d+jznBoKAdj8/jrkAWHck4ZD8vl9+TZTnq71IjTBFikroF/r8WLHQJ9nleITS+K/rF74ekiVF5c4DqomhRBx6QyULd+pGTFcrc0xhiWWJR4gTduKmPRPo4oaglKNx+EAP0ynTyqne/c++dqoJCFrMxv+9xHPZz4f6EZOPek3WI9v+3wb/aN/L340iDO6Tt4A5s3oe7/WJ6bjjWAY79s5fXybR/0g7ji8YQyAi4/dYD4BC1zM9I6MxhkdzhFm5lF4IDyrVbyD7cGTtPKqHZQYeY4VseYJZSKyIySoQeqifs63lMudxnFMKspHCE553K7GKFlF3/ozvFdVY6RqSWJv5/EYhVxsf1pFse7MbTVClksjxdE+fyNXvIzYzbicLiDIPGUvOIAtUCXliJ/eDcfOsRsQM1od1E4FYoi4yOMsbG9rniHCOq6k0phxvirtRDNCa0Ay5etRPkDJYL0FMOIVRcbdKc3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(66446008)(66476007)(33656002)(4326008)(8936002)(8676002)(64756008)(52536014)(7696005)(6506007)(5660300002)(9686003)(83380400001)(66946007)(66556008)(76116006)(86362001)(186003)(26005)(71200400001)(54906003)(15650500001)(2906002)(55016003)(122000001)(508600001)(82960400001)(38100700002)(6916009)(38070700005)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zeOdHtpIMvUy5/VlvrVQJM9mt33+mxGdJzzzhPjYMPY36t1fAcnztWvH2ekZ?=
 =?us-ascii?Q?zZTW7ASmHCqTz+Hf4qR0gJt7J+cT39hyNKtjWYbNAMevxz0irpNX/1012RCN?=
 =?us-ascii?Q?f2RCmwLknSFFHWqlwwU4a3TzUOmStMSAup+uGkkO64K4xjbQhQAzttbAmLdY?=
 =?us-ascii?Q?IshIpyQWXnGXI+7eMeXNV2sv1bEkZZmCoOe/NraB1hvV1uJT3+OGwY7W7WJ5?=
 =?us-ascii?Q?mhWge3zHTHFCeYp3FKjEQHkknVp/A2bPfCIUjbp6Wcm3l95JLfe3r29blXqF?=
 =?us-ascii?Q?9hhw/Jt7T6vWkMiKnP0I3imZF9MuRBzJTC0PFj9Lz4ID5vB45lh72CeYAQAY?=
 =?us-ascii?Q?qmA4XV8hQHfw5Eq9HQTTZhcZSCVcUvVVnONzZQDOBVGaqv9Qvt5Db0Kt2adv?=
 =?us-ascii?Q?JJqiP10lrnvSV+NyYM3mKIB1DxfLOJKQb2dnyFIhfEP2EBYtG97bSGoUQ5rn?=
 =?us-ascii?Q?h32JNZ2K8SV+VaoQ5+i4IN9VRI06XvCzuhizTE/Leg8U0t4ygOeMJ7/wYSTD?=
 =?us-ascii?Q?RlsLNxr/BvZdFPFkEWI5F+pB24mdeYNkfD73oK9RC5KDWi/oqr/xubiNKosn?=
 =?us-ascii?Q?/qalwtcgZ3f74ssRWpmjq0g5XKe1Vzf1DmjH3I2JgvFC4x7Jg09V9W7I7eFi?=
 =?us-ascii?Q?Y2altaK8rMCo9sWaJnaeVHc9zKJsjESHgexBIXFLpL7TUwDMEld7YVik2OAt?=
 =?us-ascii?Q?b1JnGY8uMrD/Gy39LInRMoGTKg//k3tD/PzjJ3zbXcSNT4O59APXe2AXSLWR?=
 =?us-ascii?Q?/rcR37z0JdNwOnQ22/deuS8Y2rl+4T3zRjX4pgjEjpDvf8aeMyvk7yiu1m3P?=
 =?us-ascii?Q?d++F3UY1GrlG5oNxkekn14wIO/7ZqmU+IjHauz7CE4IIaIOdBKt434vY0cOu?=
 =?us-ascii?Q?eKyn/FfPp0LvQcgD1hIjzMdgwzV0YQWZbIdIATWL7gjVXfqRaLGMcJX8+/S9?=
 =?us-ascii?Q?kigleT8YG5sfu1Lt/9DyMMOhK9KbXghPxfv8gCpO3oNxWh/DfvVZ+dLhZwhy?=
 =?us-ascii?Q?aChCW/mzSeNoWhEGEMXeawtAHj2gqaIyDLGp7PxlLwjIbd1oWtGWJwdAjPYJ?=
 =?us-ascii?Q?oHcWEMEamFOgHaT7lkcT4zg6QkU+hx0AjXgv/hBLN8PPWnYd/vKzMrcsZtFr?=
 =?us-ascii?Q?ZOqlLXzAPPUjLil8oEMsAfaVaKCabtZnItn3BJ8rkctIAkK+XqH5i3/tfBve?=
 =?us-ascii?Q?FmfQaFxJS+vhUprQ4UpWJ4i4JOtjv0a+S094sialEQH1cHNzSEpDBL9graEI?=
 =?us-ascii?Q?cgAc2rxkSFCCsrq5LPZrUSQ1wgTw/eghFtczZ2jYeCXYA/5+84tDnDSggGVP?=
 =?us-ascii?Q?Fw37XHyYNxe56QZx7oKn8xX+rakO9d5Msrmc1OeeT4JRYOiLzOkawazpH/nb?=
 =?us-ascii?Q?3TMCSAB8Q8B8Ag9fDR5cfOkcg4bXrF6wYML3y03Oq82l7UjBRkn4rNL//hl7?=
 =?us-ascii?Q?AF4Nofeo/xWEyFsD8rpm90FjmpTpR8j639mcm41x0f0IRlf2P68sg65c7CTE?=
 =?us-ascii?Q?Ye0T2sIk1Qj3hW4HV+Fn7leg6gD9wYSeCftaQ/GdCpng8esqqiFMRqfo8R7U?=
 =?us-ascii?Q?1SmzCkvg5W4IT3DlcJpBW5dZPrVb5eh0sM4pJlrpGN5qKwnZRrWLhMnPm/oq?=
 =?us-ascii?Q?7h0BCQN29KR8mNd2Mj9dmZU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8b7f84-013f-4f33-fbf6-08d9e12d541d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 00:38:24.9571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JR+XdeynnZbyxybpQRfFUfFgKBaT6lH+49diFl102mJnoEgHn/rdscHaOPCMCMR0/dTrHrQqjbTFVzelvizsLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3705
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, January 26, 2022 11:33 PM
>=20
> On Wed, Jan 26, 2022 at 08:14:47AM -0400, Jason Gunthorpe wrote:
> > > > with the base feature set anyhow, as they can not support a RUNNING=
 ->
> > > > STOP_COPY transition without, minimally, completing all the open
> > > > vPRIs. As VMMs implementing the base protocol should stop the vCPU
> and
> > > > then move the device to STOP_COPY, it is inherently incompatible wi=
th
> > > > what you are proposing.
> > >
> > > My understanding is that STOP_P2P is entered before stopping vCPU.
> > > If that state can be extended for STOP_DMA, then it's compatible.
> >
> > Well, it hasn't been coded yet, but this isn't strictly required to
> > achieve its purpose..
>=20
> Sorry, this isn't quite clear
>=20
> The base v2 protocol specified RUNNING -> STOP(_COPY) as the only FSM
> arc, and due to the definition of STOP this must be done with the vCPU
> suspended.
>=20
> So, this vPRI you are talking about simply cannot implement this, and
> is incompatible with the base protocol that requires it.
>=20
> Thus we have a device in this mode unable to do certain FSM
> transitions, like RUNNING -> STOP and should block them.

From this angle, yes.

>=20
> On the other hand, the P2P stuff is deliberately compatible and due to
> this there will be cases where RUNNING_P2P/etc can logically occur
> with vCPU halted.
>=20
> So.. this vPRI requirement is quite a big deviation. We can certainly
> handle it inside the FSM framework, but it doesn't seem backward
> compatible. I wouldn't worry too much about defining it now at least
>=20

Now I see your point. Yes, we have to do some incompatible way to
support vPRI. In the end we need part of arc in FSM can run with=20
active vCPUs.

Thanks
Kevin
