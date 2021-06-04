Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE939B046
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 04:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFDCR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 22:17:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:32461 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFDCR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 22:17:58 -0400
IronPort-SDR: GecN2R5WWGAQUaWKy90+iZz1OAwx9slyc9OyjAtcq9WE3P1fPGnNpMXQ3ARUX7YkuJwSGkHWQ5
 z+/UywloxjIg==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="184576755"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="184576755"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 19:15:57 -0700
IronPort-SDR: X7qoygrviGE+hAxgodFdPP+r10OazNH/EkaLgy0W3vHrREHcdZhRg4E9lI62KCkMAqs6HKexKQ
 ecQuhOi/ZGqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="448092657"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 03 Jun 2021 19:15:57 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 19:15:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Thu, 3 Jun 2021 19:15:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Thu, 3 Jun 2021 19:15:56 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 3 Jun 2021 19:15:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYXncpAWKf6cIDA2vEdWqT88VYVOIfGeBKq00CLB1bBZ6DmaDqbPjitUwTS+JbJkRwf+F/4tebJ5U7xZ3IEK3p8TiyezcHYXVCCg09CRO2NRG3nMLYjk8iGINsqjlj4vWcSXelonmsgKZ7KgV2BDLUMUfSfLR8CnVtSpvcvc+e3mECKqy3nNKUJqaP0/6gPCdkhb87zF1IpSJkTZOtKMjdkWhjgsHuRjYVuYZjzSwj3RE4MvaSvGYdttliZi+M7E6mJfSVW7pmTo9lOSSSZ3LnjQAnSr1sdg/VU+dsTbR4+0yQkBNBDCRnbcKG5S9f8dDvyt2BKVJ4PIkrlSfGuNEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0fDHhWKcJPw7ZiU8klSBMnRYye6XpzPSvzo1ZXic5U=;
 b=B8/sFwjqJRWP62Uomtdu8YiGWDPn/6OLVnOR/8s6tTpB3n/eoce60I7aNUIE+0FvsTy0JOx4Osl+MufljJmg4S05Quue5XA2AuxlPRF6WS1n3Gs3fjO/vxn8dQqWAkfvWeEVTAddQAaGBz9LKRHBGaXihi92A99Dy3fvefjzR4a50QzIbo3ZxshruyGIg4BV4Hoy5syMr7MJqXoXd2vjUaXy788/h3er6eSFuD3/xjmhQPSBmtQIg9Ojzjpir32h+8Y9rA7i4vaVJZFVhy4D3GZ/2Ah7hnCppcEIxyN8qxoGJo/g4KmfeL24tJxRR8F5mXEtA8Baz4hUSLFmxQWFfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s0fDHhWKcJPw7ZiU8klSBMnRYye6XpzPSvzo1ZXic5U=;
 b=nv/WkLzpVpB8u6nqk3pC5g7GjiRHO1Ro2ViBpx/Pru0B3w48bswKD7cHkf7Swa3xMwz+bkpZEmQLew/0tupuX4+na7fu6O2Mu0sZ8gJBPsRQvWq7BTc2fpV02X99eldZUujIzev5Jh1BD5pPm+RiNb+E5IRN7WTtAIiiN3LQDBg=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by CO1PR11MB5137.namprd11.prod.outlook.com (2603:10b6:303:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 02:15:54 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4195.023; Fri, 4 Jun 2021
 02:15:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     David Gibson <david@gibson.dropbear.id.au>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Robin Murphy" <robin.murphy@arm.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBGs/UAALTRUxAAFJZWgAAQLFRgAB7cjgAAE0ZXYAAH9s4AAANRJjAACpfvAAAduucQ
Date:   Fri, 4 Jun 2021 02:15:54 +0000
Message-ID: <MWHPR11MB1886BD0790C148E88C5C795E8C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <MWHPR11MB18866C362840EA2D45A402188C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601174229.GP1002214@nvidia.com>
 <MWHPR11MB1886283575628D7A2F4BFFAB8C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160914.GX1002214@nvidia.com>
 <MWHPR11MB18861FA1636BFB66E5E563508C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLhj9mi9J/f+rqkP@yekko>
 <MWHPR11MB1886E929BD1414817E9247898C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210603114728.GP1002214@nvidia.com>
In-Reply-To: <20210603114728.GP1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3d7efe9-7829-4474-57fa-08d926feaec9
x-ms-traffictypediagnostic: CO1PR11MB5137:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB513758B7E24537CE76FAD71E8C3B9@CO1PR11MB5137.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Swx68wr9eK9TMMfBikSxFsPVov3MtIbiAkgFtGR4FkzvFOCzd9q6IwyKG/IzU06hOilRaFxWHHgG6QEGc7tJw9StesMpxEeI/EjQDwxThhbwTgxkR7NW5jxqeH2Wi8nIFatKSX+3b3aMGgZwNgOpD2tEK002MDQvsfXpPypsAmpVmipLWZ7WwvwmSUWSez6Oh+ZvP7Bq9wd3fY4yRJNCg3vdVdIwbwC40CSbddMNE5iNtvGj/BVs3p9+AZhAqNmBTTOW4xCG80g/j0IwL3wzG1nhiTisx0y9jZwajbxs9qFBNg7+aC5SzSC30EFcO8NzCprZHIm1BG2IoAlt75axlUH+HnVkU/gwUwFdNqaZHHhyVPrbbDQq0C2jGn+Jqd85UjlUDX/VjddQ/zGClTUXlEysfh+GQBWcm7WS8dm8LS6tyJO0amevJGV9aHQXpj/GIZmQq7sH1D2ZA0KaxU62pf6BT7gMbmOifRCvB38/MZ0n7bfqGtynyXKm+SqfHXCFx1lF36mI3bRJVdyBkQvW8eDpELCSBbiLR1RqN5zHjMLu8D3c8elh63+8iIV5iixsFgtcuxi5r0Olo4J+dRXB8myLvbFR0aap5KOg3hyHKEM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(346002)(366004)(376002)(83380400001)(86362001)(7416002)(71200400001)(186003)(66476007)(66946007)(76116006)(64756008)(66446008)(66556008)(7696005)(33656002)(6916009)(8676002)(38100700002)(478600001)(122000001)(54906003)(8936002)(9686003)(55016002)(2906002)(5660300002)(6506007)(4326008)(52536014)(316002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bDo8KGJzHXL1sU993AWt/s4HSooigWCeLLX+TZ/GzY+waOrZFTsDYsGK2yyn?=
 =?us-ascii?Q?tN3OIw78zrjoEl9AALm4x3LUafx/wQVKwpI0+WY8OynsJwxCD8pfZ1iR9hpa?=
 =?us-ascii?Q?R2Rbby46VIne0Yf5FKl3p23FYKk5bWhxs3Qg37UjQrpL+U3rxs3m1G/q4bwY?=
 =?us-ascii?Q?w2aMugLy1tBIEN2U0aGXPFrKAFTSJ9nnUtCP+hSXydILPNGELslrt+pgbhWx?=
 =?us-ascii?Q?eiEpDXLv7D3YBEW+zucEEYYTTKreuOdf3jX0pL2Adt85Nc3LSeEH25T6F7K6?=
 =?us-ascii?Q?dJTA3Mrm1VvIjSud6Tk088VJtn9ZipqrIalZkLCzAqOef3YbiDVCiZPiHEga?=
 =?us-ascii?Q?MFdFntqHqNKCKP90oahMBNvp2zjAJs+rsR7a61rBsC2bBKtjsP9UHS+/otLM?=
 =?us-ascii?Q?7RJsFBVmPIXtlh8VH+rMnLmjk2LSACAvOivQcAGmQ7RteMR8Beni8JQmf6mH?=
 =?us-ascii?Q?5pe0dggIhMegumuYjcarZ2fHirV6g0P6IhSpTRHO3lhki90T9v1oNa4HYaIZ?=
 =?us-ascii?Q?ERzi9qPb6DkDpygE64qEyxFypedjuXm2ysFATMEy8xxX4BzMWYf9bMJH9w7Z?=
 =?us-ascii?Q?ygySbDJOl1AygAOnHe74Z4UKOsFlk4PsFI0EeZOkuBgVHSF7KGROkGuffdbx?=
 =?us-ascii?Q?JPY2hKlYcK5DdvfhN7LHhQRX24/gEbyYSY1uBnuXmYqO3MVkjNVieIaaU7+Z?=
 =?us-ascii?Q?itt0ELepuLqxLmgSa0oQLLRDss9RYL074szmtza5XQAKTO1xSoSF7Lqcz04p?=
 =?us-ascii?Q?QcEkKiRvCW4OhJ7o057yFdllDm2bhHNx9Kfg/uhAlvv5F3uATNDQACv/nt3r?=
 =?us-ascii?Q?/nzIOQOBgKMwukREs5Z2MNcvqB93oLzPFLgYJdYWyhOQdUpMWmwLIB4KNBwm?=
 =?us-ascii?Q?CSBFkL52wPAunM/xCMPokMoWMyOCYO7jMmkirn3dhVQZmRAkFjcSehktL7Uf?=
 =?us-ascii?Q?8RyUeFhuyLtiHMTRA6/WCGhFSITXMZ7gn8W56kv+jKIMTuUphKcZFeCKhVXm?=
 =?us-ascii?Q?/0igusZsnj29L+Kx2D2YtOm9WCXP7uYZKjKalQBvFek/2K99RGMBn+z9nDK1?=
 =?us-ascii?Q?M7dlQZ1RVb37eG29BHNQJZtc9hoY9AdFSvBb3CNZ7ofUY7Nom15crxga30Qz?=
 =?us-ascii?Q?VNTLE9BXqlxSmf2kxVY3g5eTXcIXepE6hKC8iKRpxfnBLzEPGO9X2+NgF525?=
 =?us-ascii?Q?JD3HnSoUCJA+qLn6ffsI2xkO75sdEd/CaAXiVu7XdwYAgiQvgVkENsBnuSVL?=
 =?us-ascii?Q?R5251CbqCuEjFT9BaLZpQQL2y321dGKlKwoZvbn0oyUHMW3ocN52lZDy0Kpj?=
 =?us-ascii?Q?laiWSPC6pmxlgI9g485zRQ2j?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d7efe9-7829-4474-57fa-08d926feaec9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 02:15:54.4795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Da3AMmqm1PyFFc8nGyUdeaFoiBsgLa8C1YN+h2OR/NP387DbaHaqoVnJZa/B2OKGsCy62RMBShgDtYOPS53nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5137
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 3, 2021 7:47 PM
>=20
> On Thu, Jun 03, 2021 at 06:49:20AM +0000, Tian, Kevin wrote:
> > > From: David Gibson
> > > Sent: Thursday, June 3, 2021 1:09 PM
> > [...]
> > > > > In this way the SW mode is the same as a HW mode with an infinite
> > > > > cache.
> > > > >
> > > > > The collaposed shadow page table is really just a cache.
> > > > >
> > > >
> > > > OK. One additional thing is that we may need a 'caching_mode"
> > > > thing reported by /dev/ioasid, indicating whether invalidation is
> > > > required when changing non-present to present. For hardware
> > > > nesting it's not reported as the hardware IOMMU will walk the
> > > > guest page table in cases of iotlb miss. For software nesting
> > > > caching_mode is reported so the user must issue invalidation
> > > > upon any change in guest page table so the kernel can update
> > > > the shadow page table timely.
> > >
> > > For the fist cut, I'd have the API assume that invalidates are
> > > *always* required.  Some bypass to avoid them in cases where they're
> > > not needed can be an additional extension.
> > >
> >
> > Isn't a typical TLB semantics is that non-present entries are not
> > cached thus invalidation is not required when making non-present
> > to present? It's true to both CPU TLB and IOMMU TLB. In reality
> > I feel there are more usages built on hardware nesting than software
> > nesting thus making default following hardware TLB behavior makes
> > more sense...
>=20
> From a modelling perspective it makes sense to have the most general
> be the default and if an implementation can elide certain steps then
> describing those as additional behaviors on the universal baseline is
> cleaner
>=20
> I'm surprised to hear your remarks about the not-present though,
> how does the vIOMMU emulation work if there are not hypervisor
> invalidation traps for not-present/present transitions?
>=20

Such invalidation traps matter only for shadow I/O page table (software
nesting). For hardware nesting no trap is required for non-present/
present transition since physical IOTLB doesn't cache non-present=20
entries. The IOMMU will walk the guest I/O page table in case of IOTLB=20
miss.

The vIOMMU should be constructed according to whether software
or hardware nesting is used. For Intel (and AMD iirc), a caching_mode=20
capability decides whether the guest needs to do invalidation for
non-present/present transition. Such vIOMMU should clear this bit
for hardware nesting or set it for software nesting. ARM SMMU doesn't
have this capability. Therefore their vSMMU can only work with a
hardware nested IOASID.

Thanks
Kevin
