Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829BE3B2710
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 07:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhFXGCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 02:02:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:34266 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhFXGCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Jun 2021 02:02:03 -0400
IronPort-SDR: dQDZV/i4jdAQK6Ng5DnjxM+yEQ82fONWT9zu5RLJa7O7Fe+n5fgrAenPIbHAucP9hzSVfc/5Zy
 bSsRDLyxBxNw==
X-IronPort-AV: E=McAfee;i="6200,9189,10024"; a="194703133"
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="194703133"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2021 22:59:44 -0700
IronPort-SDR: EL4JMXH1VD35SAykWwNUgCQ/cYly1eh9shBd7K6hU6swXo97f1Rc1m0O/oZacjZtaoJ0RmiWT1
 nc5S6E+9BBcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="454926216"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jun 2021 22:59:43 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 23 Jun 2021 22:59:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 23 Jun 2021 22:59:43 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 23 Jun 2021 22:59:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SiNxsGGP4LprvIAYUfgV0IMHq3pVu5cGlS5Cg1aEDinx0pxDblJieHZojRnmrF4+BeLZj9I2mU3Pew3WjqvDj9XrfPZRIVHWlGROAx8e+I8gHSviSEYbSN6Oro73f1s7MxdRfdSup3pMk5P9Ug/Fr00G10+E+3fdFycGjQldsG3rTE0IBDaPn5R9tp+jOKyl5E78eCVUU18lydWJ21ccxkYwN2IlF1tepI74gC1CkgpAsYHQDn/fqalwrkxJnRTQwSdP6jZPcHDAwMy3J/4VmeZcAdP/cHWo6S/TDEXIoKFOcl/swURIt/YD1GEBUi9AiXnOJTn5Nkh1sR3A5Ks0VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/dg0S5yj1ZUKj6Y+jNk1LEXlLteSTK7rivpeMpmPpw=;
 b=B79qnrylbB+vydB0IusOcsfkGDEpfCXhyvg9WLFGYjMXhvw5HD2VWBF7pxdcBVl3raMe4dTmLTGUxLsuOyxfR1tizlfvU89O0Mpos606y65E489F6o1Q9jGmSIG0Xt7akMd+c5p7m+V/O2p3sBiPb6GtJFamtVlq07nyEZdh+Wk+JGpWLglaTvHXUv/EhDJwiQafiLckdpIPG4TLxnqdJvpqrV5YrENlmaKlGygW836/xGmh4BfzaHuSaHaHyYFpdaLwWahNMyvMPKgfmZY0qx5QFIsKDHAlqgRpxT+6eqeHGLQ78xwlwl0xrtWtEj4VRuHkSVqb9OYsONyiaG3JxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/dg0S5yj1ZUKj6Y+jNk1LEXlLteSTK7rivpeMpmPpw=;
 b=EBZSZ9PqRQhg5lSmpcOQGOEQwwCnBP7vqDfqIinFtySwWfjksTkX6n5LdDCkd+ajk/wpsXQcPE/W7Vp0XaTK1sCiCtQVV1WOyIL9SYI3QUsiZCI3kuvnY0NRCPAH1+/4wM7/TEUnckkS9SVjCR62HaPc40C4l4BxQNLGIRvLvJY=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1549.namprd11.prod.outlook.com (2603:10b6:301:c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Thu, 24 Jun
 2021 05:59:41 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4242.024; Thu, 24 Jun
 2021 05:59:40 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shenming Lu <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: RE: Plan for /dev/ioasid RFC v2
Thread-Topic: Plan for /dev/ioasid RFC v2
Thread-Index: AddbO/WEUAFl3MPnRsG8exiH8bwEagB7l+uAAACIfoAAAdwYAAADDw6AAAHKgwAAANd4AAAAacwAAAT4QwAAK587AAA0n7GAAAYKlwAADDvuAAAgbLGAAF6lSYAABO0WAAATSRtQAB5ymYAAEyKHQAAmZhSAAAo/ocAAK16TAAAGdqAAACJdiVABE/u7gAAC918A
Date:   Thu, 24 Jun 2021 05:59:40 +0000
Message-ID: <MWHPR11MB188674B8CF9690037129236C8C079@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YNQJY2Ji+KOBYWbt@yekko>
In-Reply-To: <YNQJY2Ji+KOBYWbt@yekko>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [192.198.142.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80880f67-2b5b-457a-45f3-08d936d541cc
x-ms-traffictypediagnostic: MWHPR11MB1549:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1549ABDB2A9CF09DDB39A0618C079@MWHPR11MB1549.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dklP/ExdeUKlEJLkBa4gizwF5DCJfpVfxboNr5Jb3q/S0SxB7jXKj4uYDsrJWG/6u6cRuBMVhMwJc7Ac4W2qt01H84y//QlsQYc1Pwn2sg52GxyV9rBZW9VgIVTUyT/01FMy7GSbQIpozf6EevK696QHu2sz66WSm5giis4zSBLGKxdWeR0TQ5LnsAjD2PXLT3y+NHq2vsqQji30Z7ju1XMyTYWNvn8R2IC4GOZbMNBjxskQgDT5uGHo1BpcBj7RMSEMqFKTdi83WO2ZGLWkeHvuBZ2t4fzbrltYrlWEuhFSE8AD+kuMrv4V91Z8/Rb6FJz2MOvis1Dj0j6Fu28IikIJuqhoEs3/F0+lVcRnk6lVvzB4VQJyfyDg9CBFHyngKsavkA1n8FpryX2r1BszEqSHgoLKRWkdJrLy36R97V9mzg1tmWOECNOBgvvA9qrtvIdG4trA5bHZcxZ3zStJrAhW3u8ss7hBNjxbU4wipNl99gMf11QXgc2mYMabdp1rKc6eer8UkilHmvwLDghTGqZvOM+lGGGLPxwCOIAgmW0lAC2Fui2mlujavxyIPjNX+YymXEMtZq6Iekyhe1Qsil6CMPsS/aOewbwmczEnxcI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(366004)(396003)(54906003)(76116006)(186003)(316002)(66556008)(64756008)(26005)(86362001)(66946007)(5660300002)(7696005)(33656002)(6506007)(478600001)(66446008)(66476007)(8936002)(2906002)(6916009)(122000001)(38100700002)(83380400001)(4326008)(71200400001)(55016002)(7416002)(8676002)(52536014)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?UO9fThPtNiUWyexNwM5FY+rTNHJU4nO9DxuEszpVLB5LVYAfKFYAequw2qmV?=
 =?us-ascii?Q?+4jbS4jZbgze4o6dRcfe/QtqRMjDWfkk/dD6UYWH9Jnip47CjIthtT4f3XK7?=
 =?us-ascii?Q?Ev+1Rz/0UlJVQy6rekNHgjqHSPHWXzuymYfZytKewuxZfVRT7342IJTB0Bn7?=
 =?us-ascii?Q?0WvxDnq4rJXw/y78WyYZHjX2F/gMCwEaTj9uuVRKt3GcoQZlbLD1l0OMLWY0?=
 =?us-ascii?Q?5FpFqLrRn4HpWFzD3K3HIDjZk1sb1dD2T4nYb1tXxnqqbhAnvXnRS1EgEPTZ?=
 =?us-ascii?Q?atLMR0r2A5fru9KD6ykpXQS3I+F7CIxSiDlZdLUaFRulvlxvlv6mr4XzhUv5?=
 =?us-ascii?Q?4vbeXzo8dr4NyFMsqqtQfAdfZfg9QmDPH5AdgEIUUHgYRtFfs3/dHxR3qVnR?=
 =?us-ascii?Q?ZLXhvSJbOOkRGkgQ4zQMtDDZYT5eHaaqjFQcKR/Law/MFRnSmnDwyAHc+dsq?=
 =?us-ascii?Q?aZI/h2uWb/SXABiCNa2bBJ5e7Qr2crsd0/C6LDS9S2JPNDUw9C8giC5hkA+p?=
 =?us-ascii?Q?iT0l1LDlUgcksCs7BtiAgl/iAZdplvSf6PsoqUcWn735e+cRPwe06gaKo391?=
 =?us-ascii?Q?HMonEi6kgGP3IXgR7LVRQmchAJy/m//Ja45Oyfe3wfpwCNe4XPS+l/RpzmNy?=
 =?us-ascii?Q?R3ALh92aKLXs62ahHAfRk1FMTsBkSw9KUTTK9VnE7RicwaZYinyCbKYpj05r?=
 =?us-ascii?Q?Y+nAOb8kPi1oupJRD9lKKukKzJUuBCdpOcZ4j2Y5YLGh75ecQF0Ct8p0RxE+?=
 =?us-ascii?Q?Hm8YvZ9jx02dTpfRxPKqrdHS7ZZ8ZN2BiiM7X3EVHspD9sfzYtjVvneOkc9p?=
 =?us-ascii?Q?bkYLmKS5ib8Z4UVuPJgpazVutbh9ssnnBsWMB72ayoeF/+Xa6oyQFzQh4U/G?=
 =?us-ascii?Q?M8B3oOChEZG6DIY3iRE3PAUNaaafBeBdSLqFeg4OSgPa9e+5NcjE4Mh//Wss?=
 =?us-ascii?Q?3wHnMfKZjxnthqQFoudxvoHbqZrHCkIqJ5YZdnfpiiIjn7C35QSbou8kxBrV?=
 =?us-ascii?Q?cWyv+znLzZps6llR5v01z0oimyvAZ7d6ZJ2qbMypqVUPgDLr54sUODu4WaqF?=
 =?us-ascii?Q?+0Sf0OmnFh860FHgd3du1fLn2GM+Geg20izDgBjNPMTPMhoB2XwZXC8r3ab2?=
 =?us-ascii?Q?Ma9Yc8O0I5s7x2MMKglSh3ZcvA0GVUjm48wyMJ1WdEx2GpejFbQUXw7br2at?=
 =?us-ascii?Q?nKH4uCnP8W8hJpiEl4ApawLRrCeMa3GK0kumURkWWLaMH9peLoa/41VDkkmB?=
 =?us-ascii?Q?wL8PDwp+QwBV7/5BkFard0PRw9FUGBcGc2jZC+xThPE5TuDJiGGH6drgSV/m?=
 =?us-ascii?Q?s9KWIuwPV80LcpcIS4yVVu6b?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80880f67-2b5b-457a-45f3-08d936d541cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 05:59:40.7706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cK9GybQSna+uvTYnmXL9yzEd73Fv+/mtepg7wRyx2GJVmtQSt4eQ/ySIcNcGM0IiUZSM0j2A8AVTxq3qE57d5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1549
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: David Gibson
> Sent: Thursday, June 24, 2021 12:26 PM
>=20
> On Fri, Jun 18, 2021 at 04:57:40PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, June 18, 2021 8:20 AM
> > >
> > > On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:
> > >
> > > > I've referred to this as a limitation of type1, that we can't put
> > > > devices within the same group into different address spaces, such a=
s
> > > > behind separate vRoot-Ports in a vIOMMU config, but really, who car=
es?
> > > > As isolation support improves we see fewer multi-device groups, thi=
s
> > > > scenario becomes the exception.  Buy better hardware to use the
> devices
> > > > independently.
> > >
> > > This is basically my thinking too, but my conclusion is that we shoul=
d
> > > not continue to make groups central to the API.
> > >
> > > As I've explained to David this is actually causing functional
> > > problems and mess - and I don't see a clean way to keep groups centra=
l
> > > but still have the device in control of what is happening. We need
> > > this device <-> iommu connection to be direct to robustly model all
> > > the things that are in the RFC.
> > >
> > > To keep groups central someone needs to sketch out how to solve
> > > today's mdev SW page table and mdev PASID issues in a clean
> > > way. Device centric is my suggestion on how to make it clean, but I
> > > haven't heard an alternative??
> > >
> > > So, I view the purpose of this discussion to scope out what a
> > > device-centric world looks like and then if we can securely fit in th=
e
> > > legacy non-isolated world on top of that clean future oriented
> > > API. Then decide if it is work worth doing or not.
> > >
> > > To my mind it looks like it is not so bad, granted not every detail i=
s
> > > clear, and no code has be sketched, but I don't see a big scary
> > > blocker emerging. An extra ioctl or two, some special logic that
> > > activates for >1 device groups that looks a lot like VFIO's current
> > > logic..
> > >
> > > At some level I would be perfectly fine if we made the group FD part
> > > of the API for >1 device groups - except that complexifies every user
> > > space implementation to deal with that. It doesn't feel like a good
> > > trade off.
> > >
> >
> > Would it be an acceptable tradeoff by leaving >1 device groups
> > supported only via legacy VFIO (which is anyway kept for backward
> > compatibility), if we think such scenario is being deprecated over
> > time (thus little value to add new features on it)? Then all new
> > sub-systems including vdpa and new vfio only support singleton
> > device group via /dev/iommu...
>=20
> The case that worries me here is if you *thought* you had 1 device
> groups, but then discover a hardware bug which means two things aren't
> as isolated as you thought they were.  What do you do then?

I didn't get your point. If such hardware bug leaves two associated
devices in separate groups, what can software do? Even with existing
VFIO mechanism they can be attached to different containers before
the bug is identified since the kernel thinks they are isolated. If the=20
after-fact mitigation is to kill the VM and then force two devices=20
attached to a single VFIO container (after such hardware bug is identified)=
,=20
same mitigation can be applied here i.e. the user should fall back to=20
legacy VFIO instead of attempting to use new /dev/iommu for such=20
devices...

Thanks
Kevin
