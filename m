Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E4939D4E2
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 08:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhFGGYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 02:24:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:28456 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhFGGYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 02:24:03 -0400
IronPort-SDR: Mr2Zt5K9pIxx9mlEFIAX9Ws03nl5awSMJgC6UOrKzrF6oMFATPh5g8KINdxEeY+FMMJgjBzoCh
 lBWO+5CIAE+w==
X-IronPort-AV: E=McAfee;i="6200,9189,10007"; a="204539128"
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="204539128"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 23:22:12 -0700
IronPort-SDR: RVvKKE5yzIiLskZDMXH5PWpkAQaV4dYUYc68YWCTKxdf2J4EWiyMi+ek0kZHTETPhrh1UbVf1n
 uqLHDVBB8lQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,254,1616482800"; 
   d="scan'208";a="401544201"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2021 23:22:12 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 23:22:11 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 6 Jun 2021 23:22:11 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 6 Jun 2021 23:22:11 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 6 Jun 2021 23:22:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnftCu4T1CIRSvSOL6GZkii9TcK8IypV4WV1hda6EsbQxcMb278W9FRns6SyEwXHRKTKyViWCZwRrRz1+8QDaDTVMuyzM/mv74DQfZrPsLy0qxKxsqvut7HrZnSx2sXFCRfpdMehUAQ4kcqVgSdpiHMQmfmCl3bQT+aHJH5W8+CN+xaT5sp2R+mVoT2TwY92xp2sPbAFCJUC2ccyNOc05N1esPZKGCmB2Q320jAkpzNaFhmoIdz4oofeYst/ZDw6Bn6R2cYTTP3WJdxQRRHsVbyL/xuoEtyTk+8ZtySxj8PeziVHIdlpeGE4DKrTV0kGmVOfmOhFDDEJ5xfA4nRrcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFlf6IKiI4yXq7dKxIqXtDZmMSyLVU5+Lc4RkMhumrc=;
 b=Tt0q7MS3AWg18vbBiiY7fwqQslsqxjRt2pZhkXel0E61ka6uptWUkKPzpdvZL9cbg8Vb9tBlFtj4PUSRZ3NVETTdv/UEuuaTnXSwHwSIpZSfMS8fVbVStDq8E4dZcoUjp3ncaZ7+WBenQsNOKRcLQ7/dATOAvf76ngZZpo41Hd58FOS8K2DYRLn0w44jpqH6QwE2Pilf2Qe78icpkTt/fo+MM6R1U4IYABI93kQpi7lsvcAmA2wXFnI8MJiDeebwLageLy4fApWQ28fv64xe2gZyQ6LB9XvqUnwLMEr1zfvNFfvDrOHEKs3YUaPdXSrvWf2DElIk1oS8lDGXBP8e2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gFlf6IKiI4yXq7dKxIqXtDZmMSyLVU5+Lc4RkMhumrc=;
 b=wMFVQYCOElW388py0meYbiRd5faaaiEqaMSYuFZ0zP+5+mxrOKwrRxmPVQ3UEzJYZDYfAaXmEGHHmV/oQe4e0Eb52m8nDCPZahBAV8l+bXMpEdo2U0rYcr+/oylM/GfNDj3WVI+EdIJxjN3IXM37c3wZkr5njsXcwKOcvo9/n2I=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB4946.namprd11.prod.outlook.com (2603:10b6:303:9e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Mon, 7 Jun
 2021 06:22:09 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 06:22:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vkoul@kernel.org" <vkoul@kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Dey, Megha" <megha.dey@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Lu, Baolu" <baolu.lu@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Topic: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Thread-Index: AQHXTqAZRXZQVBJp50eOXR3CymY0rKrxt7OAgA82YYCAAH+rgIAAHwJQgAALZACAAD0zgIABdAmAgATZcdA=
Date:   Mon, 7 Jun 2021 06:22:08 +0000
Message-ID: <MWHPR11MB18861FBE62D10E1FC77AB6208C389@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
        <20210523232219.GG1002214@nvidia.com>
        <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
        <20210602231747.GK1002214@nvidia.com>
        <MWHPR11MB188664D9E7CA60782B75AC718C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210603014932.GN1002214@nvidia.com>
        <MWHPR11MB1886D613948986530E9B61CB8C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603214009.68fac0c4.alex.williamson@redhat.com>
In-Reply-To: <20210603214009.68fac0c4.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [101.80.65.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67e72391-e0eb-4b38-9346-08d9297c9438
x-ms-traffictypediagnostic: CO1PR11MB4946:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB4946D879595C599C8B58D3078C389@CO1PR11MB4946.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sHriPGflRQlXG9gXRF2nb8r/Dh5SKkfeWSfvs4cMO8oyKI4WowHkBZYK/xhvaEPwCLmsAAIczgg4TWJww1OYsg6c5yw+TY+ROezsmCk0hSJQAkT57ujLL36MD4cX5wK6+5WsR5yh9GWdQyvP0DxUxDjmbznM3dtriGPqVaJQgkWRN8r2wXpcOyCm+jEre4QqyPCEN/bynHoDkCUpqCQl4OS9IAnmDpe9TI350newroW3TA/OfoWM2EEIeFWjVX5sz1MYJP3wzpODMxCM7VnzGvcJQXItmaEIsaizGqZs8GuA+NB4GvjQShLDUilDWVU8oZnYP4w0xdgAimy53FTkVzoT8qv4NMZ42Dk2YcT9xlAYLI9dqTihWQFHIKmdBL2ru2aMIC7kkF6i3tpzEZtaLGn4sTPqHYASdlRubUh92IDDcronxjAvDmGmp2JHqUqk8JZuyzrYF8k/MmZxNtE5Csqw03DmjrjUethcLiMh8yP5YVmBMC93vdN5LQbJNDESCAXMkxuC0o6yMCJ+TNcmGcPOaMeKe8mn1+Ta4zqnU4sk64aV7OqDrElFukYFDOYFxe6WZt9jd0YFfm2kqtRac0cNsNqJEK7B3M3a8s9JhfH7CWo0/A0jhAuKiHQgOAH4iL1v39onQ6q8q1pAmX7qg6Ibk+j1qv+5NsyPCr6TjM3rNarUn/M8YfjHFAv6YrM9fOW1g6hyyhzUKdt/So0iBg/xozowwttEDtNn/0EHpCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(39860400002)(396003)(346002)(52536014)(7416002)(5660300002)(54906003)(66946007)(122000001)(478600001)(186003)(38100700002)(55016002)(71200400001)(64756008)(66446008)(6916009)(66476007)(8676002)(33656002)(966005)(66556008)(2906002)(316002)(6506007)(26005)(7696005)(76116006)(8936002)(4326008)(9686003)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ThuLzBQ3SIbwmpfYeYC/uhYVkoDp/xOSTWq7MbxhtOGn6acb7F4p0thFQCbU?=
 =?us-ascii?Q?iyjFcJeEfD0vbykzOFtTTnEnC4BVPDA75mFUQj72XqCJaLQ2JkvR69xJQ+4W?=
 =?us-ascii?Q?aCHLdfYklilp843A9fS2i417dbluNw33YUTMArbIXmoudYo1HbDUQTSm6aaE?=
 =?us-ascii?Q?kU880BhuCqWFclLKimFJmhqsLeu6VjzP4E+HGV56BSzWCgShYiWDvIMMAvJd?=
 =?us-ascii?Q?6EKK46DzRQ3sbIaytktE3PCB5r1l8NAZ7dF4h70lAwAkoldqToid6uqqoMHd?=
 =?us-ascii?Q?BV371WYvNnjzJ3sQu1gXwu4qz5tBu6ITFpkvan7P0rMcWFUMkYUZLaVSXkoX?=
 =?us-ascii?Q?o3eB30rnvH5v8TDViYKgqw8SDfFhruXs3xz45pftT1n5KUUR2ajpqws3xqP1?=
 =?us-ascii?Q?32A4+nMWuGkXW25k+qCBs3WhhyzWYuhQDhk6mDrrZK57zjCyTWah5fp+5JGj?=
 =?us-ascii?Q?zaRqLmcrTbNfM8qEKjUsUmiGdp0SowmqSoOjn/I79w75DM/UtNpVKpGB7j5C?=
 =?us-ascii?Q?zqS8rsvgAeFfLPW1pR29ch2hGY6zpM7GUiVgRHxwiJMhGlATUBllq5l8JiHH?=
 =?us-ascii?Q?VNl7siNMItnDLBz6JCNvhNHIWGO2J/7tG+hU8gaCEus2O270bDBtjOxeHX0C?=
 =?us-ascii?Q?M7W8h6Eat7lu3tS16YSe0+lsvxWBc0iTDFl/dZnZa9q8PEr+QQLuFlBpMLJ0?=
 =?us-ascii?Q?TLyRw/7966c3pQvLJO0QxAL3kCGEA9O+VyvHeTjSZEiJjzz1TvHJdXfyZgq9?=
 =?us-ascii?Q?1Gk3T2KLqxpGPzLvVq1DxPB1Tk0LoIQ6dA9d32u5YtL/9Am4AbHctDXuOn7i?=
 =?us-ascii?Q?y1buxZ+wCjSCGLItQ8nja8FKNE4w2sZhlRbjB6NVZGSCtlBuUdu/XPzYgVps?=
 =?us-ascii?Q?y8DxyfxvruX7QgqKSaQ8H3LQAHBmsUG2n4OLolUXEaiHM3QMYMUyJWivQCpv?=
 =?us-ascii?Q?6ag3oUSaXLVQ/UjBcZF2POAFv00vzE38iev+LgbafFY0vTEr8NBKDVFJuZIf?=
 =?us-ascii?Q?VOCWM0CK6tkLCnsEZUG/KueNc+BkPcCcLpy2WOpGp7EREAHrOkh5S4itp1VU?=
 =?us-ascii?Q?2V4WtZwG+pljDrvtYwmaARddwv7fIOrahwwoKOA7JIQbBfC9ZYXHyKA//dqg?=
 =?us-ascii?Q?oUv6GdHM3QDsRCKLiJl7fheO1yOnekpBCJKweE9JsSO7iTD3pOQwMfbWuVp3?=
 =?us-ascii?Q?gAw3hktn4FbPp6nCYIyb67kxFlflYi0giAw4h/btALMiQzEFSRb2c+l2u0rB?=
 =?us-ascii?Q?ZwdWBz8ERNviXG+Mee7LWzgDAsRn2naObM6Zw5zOBD+qHc8dFwdqnvZN5LbD?=
 =?us-ascii?Q?G7Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e72391-e0eb-4b38-9346-08d9297c9438
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2021 06:22:08.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xE4c9nSm2yMRiz9ETktZexcCYOQjJFvVS9SSI4UYFFDktt1xdZL1AkpnqsP0VhPMr9W0dK9TAEmrnhUlCKOApA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4946
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,

Thanks for sharing your thoughts.

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, June 4, 2021 11:40 AM
>=20
> On Thu, 3 Jun 2021 05:52:58 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, June 3, 2021 9:50 AM
> > >
> > > On Thu, Jun 03, 2021 at 01:11:37AM +0000, Tian, Kevin wrote:
> > >
> > > > Jason, can you clarify your attitude on mdev guid stuff? Are you
> > > > completely against it or case-by-case? If the former, this is a big
> > > > decision thus it's better to have consensus with Alex/Kirti. If the
> > > > latter, would like to hear your criteria for when it can be used
> > > > and when not...
> > >
> > > I dislike it generally, but it exists so <shrug>. I know others feel
> > > more strongly about it being un-kernely and the wrong way to use sysf=
s.
> > >
> > > Here I was remarking how the example in the cover letter made the mde=
v
> > > part seem totally pointless. If it is pointless then don't do it.
> >
> > Is your point about that as long as a mdev requires pre-config
> > through driver specific sysfs then it doesn't make sense to use
> > mdev guid interface anymore?
>=20
> Can you describe exactly what step 1. is doing in this case from the
> original cover letter ("Enable wq with "mdev" wq type")?  That does
> sound a bit like configuring something to use mdev then separately
> going to the trouble of creating the mdev.  As Jason suggests, if a wq
> is tagged for mdev/vfio, it could just register itself as a vfio bus
> driver.

I'll leave to Dave to explain the exact detail in step 1.

>=20
> But if we want to use mdev, why doesn't available_instances for your
> mdev type simply report all unassigned wq and the `echo $UUID > create`
> grabs a wq for mdev?  That would remove this pre-config contention,
> right?

This way could also work. It sort of changes pre-config to post-config,
i.e. after an unassigned wq is grabbed for mdev, the admin then=20
configures additional vendor specific parameters (not initialized by=20
parent driver) before this mdev is assigned to a VM. Looks this is also
what NVIDIA is doing for their vGPU, with a cmdline tool (nvidia-smi)
and nvidia sysfs node for setting plugin parameters:

	https://docs.nvidia.com/grid/latest/pdf/grid-vgpu-user-guide.pdf

But I'll leave to Dave again as there must be a reason why they choose
pre-config in the first place.

>=20
> > The value of mdev guid interface is providing a vendor-agnostic
> > interface for mdev life-cycle management which allows one-
> > enable-fit-all in upper management stack. Requiring vendor
> > specific pre-config does blur the boundary here.
>=20
> We need to be careful about using work-avoidance in the upper
> management stack as a primary use case for an interface though.

ok

>=20
> > Alex/Kirt/Cornelia, what about your opinion here? It's better
> > we can have an consensus on when and where the existing
> > mdev sysfs could be used, as this will affect every new mdev
> > implementation from now on.
>=20
> I have a hard time defining some fixed criteria for using mdev.  It's
> essentially always been true that vendors could write their own vfio
> "bus driver", like vfio-pci or vfio-platform, specific to their device.
> Mdevs were meant to be a way for the (non-vfio) driver of a device to
> expose portions of the device through mediation for use with vfio.  It
> seems like that's largely being done here.
>=20
> What I think has changed recently is this desire to make it easier to
> create those vendor drivers and some promise of making module binding
> work to avoid the messiness around picking a driver for the device.  In
> the auxiliary bus case that I think Jason is working on, it sounds like
> the main device driver exposes portions of itself on an auxiliary bus
> where drivers on that bus can integrate into the vfio subsystem.  It
> starts to get pretty fuzzy with what mdev already does, but it's also a
> more versatile interface.  Is it right for everyone?  Probably not.

idxd is also moving toward this model per Jason's suggestion. Although
auxiliar bus is not directly used, idxd driver has its own bus for exposing
portion of its resources. From this angle, all the motivation around mdev
bus does get fuzzy...

>=20
> Is the pre-configuration issue here really a push vs pull problem?  I
> can see the requirement in step 1. is dedicating some resources to an
> mdev use case, so at that point it seems like the argument is whether we
> should just create aux bus devices that get automatically bound to a
> vendor vfio-pci variant and we avoid the mdev lifecycle, which is both
> convenient and ugly.  On the other hand, mdev has more of a pull
> interface, ie. here are a bunch of device types and how many of each we
> can support, use create to pull what you need.

I see your point. Looks what idxd is toward now is a mixed model. The
parent driver uses a push interface to initialize a pool of instances
which are then managed through mdev in a pull mode.=20

>=20
> > > Remember we have stripped away the actual special need to use
> > > mdev. You don't *have* to use mdev anymore to use vfio. That is a
> > > significant ideology change even from a few months ago.
> > >
> >
> > Yes, "don't have to" but if there is value of doing so  it's
> > not necessary to blocking it? One point in my mind is that if
> > we should minimize vendor-specific contracts for user to
> > manage mdev or subdevice...
>=20
> Again, this in itself is not a great justification for using mdev,
> we're creating vendor specific device types with vendor specific
> additional features, that could all be done via some sort of netlink
> interface too.  The thing that pushes this more towards mdev for me is
> that I don't think each of these wqs appear as devices to the host,
> they're internal resources of the parent device and we want to compose
> them in ways that are slightly more amenable to traditional mdevs... I
> think.  Thanks,
>=20

Yes, this is one reason going toward mdev.

btw I'm not clear what the netlink interface will finally be, especially=20
about whether any generic cmd should be defined cross devices given=20
that subdevice management still has large generality. Jason, do you have
an example somewhere which we can take a look regarding to mlx=20
netlink design?=20

Thanks
Kevin
