Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929E6484CB0
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 04:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiAEDGl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 22:06:41 -0500
Received: from mga12.intel.com ([192.55.52.136]:60792 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236041AbiAEDGk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 22:06:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641352000; x=1672888000;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5bDN847xfH8p7JkC7JxpDHcPITmzhkXMHwfJ7VX0AWE=;
  b=G3j6m1VPALmWGpYmIfo4X9Mz2+vfcKhPwcnaVQdIbP/+Hlj2Pfq3Wn24
   GXcmEewf0L/Ert1+H7bDC/nJl156jqfDPnAnmwziWAZ2is7vUv7YCTm9f
   WfVZxBIueGFmNXxe++263cAVznN8uz8ZOYGHrjyIhiYmTQlUo0mEvBdbD
   mPBe1//kUNarQIv+XkOFlJqc3HJ3i2rxmkelpP6SOP9e+0Uk0GS9BoeiJ
   cPU7Dh2LeGtUDaQ8Z+6/KbVtkMHQOS3y5087I9GN07TgH+vRXdxZp/PDw
   ogXQAeBb72LqDTgNbD/n3i2FDEIEGinKf5KltmhihXLpmpzrTtKcrQznK
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222349629"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222349629"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 19:06:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="526467784"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jan 2022 19:06:39 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 19:06:39 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 4 Jan 2022 19:06:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 4 Jan 2022 19:06:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AycxZ1TzkL3s4Rzg+gce/v+mTgIBKElCJxMno6SXfMg7iRuvrPC9LfdVY+BdDWFVgDj+YY3J7BltNY4mlPb6BvxPnjQC53tjJAcegf3JgFDcqF3lsWBfljtbXUsmW6WacBb8T7DWWqEG5T52n0GnxmF84A1+gpbigUx/52NyHmUKDhTgiyOkUWBL20IrUeQkkOielhXVXtBHIcmo9NWTOFvR+7yXYGewcy4JzkSbFT3HASeyqXnaemYK+g5ypBJ58U024FAnu/IA0/pz8GbOYMlyAFExJKkUXJPtCkKhZfEIhBwlzWhJAW+Wog2Ja1n0VBwlJi8mFOw1VAfKhFsfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5bDN847xfH8p7JkC7JxpDHcPITmzhkXMHwfJ7VX0AWE=;
 b=hbQDu0VCnOZqnEIL+dKXU32WJcJOGwQLNjh0+EyZimGieCpZJNBxdHPhwvDYz/FPbiIdWE6qimyODr40t5eSd4h3l4sbGPyK+NoPKphbF8ry2tW0P0RzPR3nREkwyVj9tK6hQNZwW3RYxCNg2JpQuQNVNTpfYaiwemRDOt1k8Fz358dzGKZsLeWRlAJqyRNCBbWi/kYns/+oSsa2H6UTbJnoKvuL/6vWvzt5QIUeJ5ci6UAX4xGH4I6wAfWWoM8tMhSS2uohNA62/80/1z4U1QsXgmvtFq0hW/EyiG+UllP7UKUA+/Np5stqwPD/saKxySgMVajSce3PH4kl+xukbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR1101MB2193.namprd11.prod.outlook.com (2603:10b6:405:51::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 03:06:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%2]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 03:06:37 +0000
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
Thread-Index: AQHX7VV0XQcySACwoUuiLSnTAAZEGKwq7veAgAX5vQCAAUtwAIAgHtaAgADdZoCAAJj9IIAAFSdQ
Date:   Wed, 5 Jan 2022 03:06:37 +0000
Message-ID: <BN9PR11MB527657BDE701A25D00BA65FB8C4B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <163909282574.728533.7460416142511440919.stgit@omen>
 <20211210012529.GC6385@nvidia.com>
 <20211213134038.39bb0618.alex.williamson@redhat.com>
 <20211214162654.GJ6385@nvidia.com>
 <BN9PR11MB5276145C1D82FAFBDCF70AEF8C4A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220104160959.GJ2328285@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0619c20-50d4-4e7c-c89b-08d9cff86399
x-ms-traffictypediagnostic: BN6PR1101MB2193:EE_
x-microsoft-antispam-prvs: <BN6PR1101MB2193E537348A7828F1EDC7538C4B9@BN6PR1101MB2193.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +Qb0aOMrzGd0MuIVmbeXI/0vNCNT224fyRxnrJqp43n5exHa9VcCwjfzoNKH1I78AoE/2CG2Pw5s9OFha1pVubfL4VAgtUcvYlKwK3S9CidY5mAoQOgJDAfO9EowU/yiEb5P0t8GBaVyoGLYPQBaXoG5vnIcA9VISdPhzwof13+2QrxYof+RW6aeVMgCO/M5+mUx+PYWX97dwV/wSw27X+N75H3mRASQMmYA9lZr2Z/AF57iMIaXn7y62jAzp5ZEqqeUgLsqDut75w4ayG8CM4ZisUKND3QDpqrYEyfyY8obpQzk/H98w6erkBF2+gdcZq9tDeoY8Wokah7WpASkh9kdG0oayLjVCYkI9bKWl6+ktNE7tCNn4n0SDqNySE7z5KDbxxeV4g30dKpKICU7JOJ0ofDX2c1DRwBhHXb+nFiDMSGGGjvkY0pCVSZMc9l7kEPUYOne1Kcy8pkA6ZwA/Y1HMLbP99SNx4jSwPg8/uYy95zq1oOMDiCS+D2hSEiis+EH7BAeeRKAC3tWWwxO5Z6tgX/Uesn8do4yhagOFDPYBX1E5y+Q0uCRLkRqQmBV+yzjA0Kpd0RqKcUpF1jOCtxHBMy6ZrIkBYleQjhdhBKWHL7mjNnF5jgXiR/NE0BKWSgxPNTfFZ6FVlnJaLcyjc49HazPY0oAQk9k9mZZoNj1yYUnG7uwvZDezpKS+kWp39fFKZHta9bkslZtlZ9GeQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(186003)(107886003)(54906003)(55016003)(76116006)(8676002)(33656002)(66446008)(5660300002)(6506007)(64756008)(66556008)(66946007)(83380400001)(508600001)(8936002)(26005)(66476007)(2906002)(7696005)(38100700002)(82960400001)(71200400001)(9686003)(52536014)(6916009)(15650500001)(38070700005)(4326008)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mIro8/ATHjCFRHhEZ/Al2ZrT0dCRnx589/TtksBhJosqkg5/4Ej5nzkrfC75?=
 =?us-ascii?Q?3GWHuP4Q2xaUyTokJTb0uVlQBpXBjMVolrIW4meq2TytP4N+fl4haj+b74ba?=
 =?us-ascii?Q?S4+0lAQs2rM90s2KQmyeVLrVhr0xWVVOBhiav3Jzzm4qYDSDOzVQ55RDQLaY?=
 =?us-ascii?Q?9gw4npDtLlJ0km1yWFBB8/p3OUnYMLJmCZNvXw04e2DYmibxNcMoRLecG4yR?=
 =?us-ascii?Q?eqMkDcU9rprDcxidImkgUFmwBMgwsDaJhzi371qSM/MrIgM+VrLpybQI90ec?=
 =?us-ascii?Q?2RxAgPiJQg1+wVZR4MeuV0k5FkUnAnJ4XwYvBsFbBa8u5w2RfJLo8k3tXrqR?=
 =?us-ascii?Q?W9AglYHbpM1Camwi20Yy/gA/A7zGQXGN0gf1FEfkoZbnc4B2CJiRBfwzglDy?=
 =?us-ascii?Q?gY+0M77Bm+8UZMGQfrV7XrmhLCLpDsXnDKppKJ8qmp9L5NKxf0aRFkRDMk0t?=
 =?us-ascii?Q?a47t5hiVrdl4axDUOW1UM59Lm58EcJeBp8QD34pese3oP7sm9nl8WtaMxEEO?=
 =?us-ascii?Q?BjlgDzPiWEe+71YA0wYBcBfxZILKCHUvCsmoKeFRrsH8LVXYQSGeG2RHbFfw?=
 =?us-ascii?Q?5JidmkuZJDjodqVE5l3wSZYBziI6OS/DJES2dmF8H4kjjyyVwMjRg4dLcqgz?=
 =?us-ascii?Q?05hKQ4ryx7fwc2jU5yMzbSBiuWemtkIfympCjYOq7BSfyM/w9DzhAtaDeZXq?=
 =?us-ascii?Q?IxKmDhf/zGeNWu0nncpFP5qDBGtjKAYPz2qo3kTm/SJf9oBfWUZcsQu7QyOA?=
 =?us-ascii?Q?W4VhGrc4Xb9ypaeaf9qfNgwSy7cnRhPLgsPWIGSmXLLvHSGYbXhx4/0dYReL?=
 =?us-ascii?Q?KMQSC9GsEwWEKrNTnWpuQ1uz6Kkkqq/rClySPNU6G+8xATFYToEmNExuGtmn?=
 =?us-ascii?Q?Ih9mh/5ioBKxQtaqlNWkO+4sSqHQlxmYdI9MDd82X6oUQipRcADioUsjCjgY?=
 =?us-ascii?Q?Y2kvrFB5SsM0akyWmyKr+xlQyPft3NCcn8CxKEZYIE86s3cfIxncPR1m1ubs?=
 =?us-ascii?Q?Q/+pbRsv5Ifx/lNlzXKIDS0g/zG+RZRID1BwU2Uil1p2EdQkdr84f9tBv4TA?=
 =?us-ascii?Q?2n5RZ5GdtxUeMyTj0dxXIPhyjwpcslMQhEk0liSi1khnRyti3RPUerMYbaKt?=
 =?us-ascii?Q?ksmUP4nZHbyA2+rLB5HX31BjMW1tJS+BdYo0mAEvPxr15yVdTnHF6g3OJRLy?=
 =?us-ascii?Q?ll6dod7/B2hPslpJZpNBUwVrJ9pX33NRAn2LzzDSHkMpsJJgQCVUlrBcDPuq?=
 =?us-ascii?Q?tPL3ymkcAltRePQby33oE4xE4J+XvYw9+9OKG0ge9MzXhP4ogHdpfAImr0in?=
 =?us-ascii?Q?Not/IckIwfKJbE4a09XbMO3USYqyQbO+0M9fNORQNRl8GP3fuMpaWCMUdxZZ?=
 =?us-ascii?Q?wTLJBCdFzTzHdzYb1BkpHs3s2VgzeyD0vrudypOMv0lSbgxsS9qI6D9PbX4G?=
 =?us-ascii?Q?CGkCjnJ+loTFqTACzMwddLCg02sDHuE64j7UNfEG5qPnRAtLZiK2r0Rh2eJz?=
 =?us-ascii?Q?nDxR6GlzqDcNaU1RyLOM0Oz2LZYX+E7BX6yxZ6ED/vE5xeGKTRahtzyhGr16?=
 =?us-ascii?Q?2EMZmcgZeclOvwqHmFJRQ30eZBnI1drUSHuQw3oJEoVirKZsVB7UyYGeO2Xj?=
 =?us-ascii?Q?L6fbT5bKmu6opgZp7BeXkEk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0619c20-50d4-4e7c-c89b-08d9cff86399
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 03:06:37.8770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jI8fYFhZ2Q/NOZBUCDSI41WcwCXVh4LDDkkndzme2qV1ON8kovh0WXJjflgtL3PhiHzCDDn8TV8qPIG2z6uxEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2193
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Wednesday, January 5, 2022 9:59 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, January 5, 2022 12:10 AM
> >
> > On Tue, Jan 04, 2022 at 03:49:07AM +0000, Tian, Kevin wrote:
> >
> > > btw can you elaborate the DOS concern? The device is assigned
> > > to an user application, which has one thread (migration thread)
> > > blocked on another thread (vcpu thread) when transiting the
> > > device to NDMA state. What service outside of this application
> > > is denied here?
> >
> > The problem is the VM controls when the vPRI is responded and
> > migration cannot proceed until this is done.
> >
> > So the basic DOS is for a hostile VM to trigger a vPRI and then never
> > answer it. Even trivially done from userspace with a vSVA and
> > userfaultfd, for instance.
> >
> > This will block the hypervisor from ever migrating the VM in a very
> > poor way - it will just hang in the middle of a migration request.
>=20
> it's poor but 'hang' won't happen. PCI spec defines completion timeout
> for ATS translation request. If timeout the device will abort the in-fly
> request and report error back to software.
>=20
> >
> > Regardless of the complaints of the IP designers, this is a very poor
> > direction.
> >
> > Progress in the hypervisor should never be contingent on a guest VM.
> >
>=20
> Whether the said DOS is a real concern and how severe it is are usage
> specific things. Why would we want to hardcode such restriction on
> an uAPI? Just give the choice to the admin (as long as this restriction i=
s
> clearly communicated to userspace clearly)...
>=20
> IMHO encouraging IP designers to work out better hardware shouldn't
> block supporting current hardware which has limitations but also values
> in scenarios where those limitations are tolerable.
>=20

btw although the uapi is named 'migration', it's really about device
state management. Whether the managed device state is further=20
migrated and whether failure to migrate is severe are really not=20
the kernel's business.

It's just simple that changing device state could fail. and vPRI here is
just one failure reason due to no response from the user after certain=20
timeout (for a user-managed page table).

Then it's Qemu which should document the restriction and provide
options for the admin to decide whether to expose vPRI vs. migration
based on specific usage requirement. The choices could be vPRI-off/
migration-on, vPRI-on/migration-off, or enabling both (migration
failure is tolerable or no 'hostile' VM in the setup)...

Thanks
Kevin
