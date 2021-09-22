Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F49D413ED5
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhIVBEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:04:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:51142 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231157AbhIVBEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:04:32 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223138645"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="223138645"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 18:03:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="613210542"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga001.fm.intel.com with ESMTP; 21 Sep 2021 18:03:01 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:03:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:03:01 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 18:03:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 18:02:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2r+rvx/dLloFhGFetEvrGjFoDeH0SepBny3biFhwBI4+hxS+RLP23AI5YjCSb/I0nL8M0Oe1Fk+yIDO7MxT14+kui96XIO+lcfg0iFPdAFsp3Zy+Gl7Mg+McdJfFchlx5Eifs1IBntEqEu3wmNOHCEX2TH10qrrD7Tiwhq3o5ib2QzG7xZfVWOQlZFV696znu5H6fNpE9jKamayaltMo8TVxkPy/BDDMOHmRXSya4Ow4eOIX+XM0Ry+y3y+1rRVdrunpPn/oiVjwoOHbsxJ+xg41FokkNh999yzJvKQ1G/vpOnVuvYirMSq0Bgtv5oB0A1hLQQdeDnbK9FFDnaq/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=oGFKXw0/OVJ46OVJYEL9j3GJ7rU7zf72sZNA60Hr5nE=;
 b=n6vMBovEeG13ViRjAwbXBRJEm/nBjbDqQuPFhj7+AjDxV3IfzXOfAGVnCBhk+6woKZmBGXTP4dYxJy1VHid3EC411BmAlTybhgjeL1CRPoKguPylsXYSVhBKwchwG2Rbt4EfecSNM1NKK2KjiTPhmgULUxoICjzZruVX2PhAazdo0fp4qBiHNE19RqHpdTMSDSS6UfzrG3Ud199Fjh8WcASZ/LVbRafGopX3H4RKkFHcUhL6O3/AvRCcOUgSafZSWWoHbo7TDcJVIn1ft0m1fCIW9dTBPrHwa5r3ChIcFTjANRYZ8H6tFMz6zEMoDTBBVwQaSJqim7RmJn/tmq0wRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oGFKXw0/OVJ46OVJYEL9j3GJ7rU7zf72sZNA60Hr5nE=;
 b=uk8kNtUzA5QLgLhxi71eDHj4uhIFgqsE/4H6X82+dWOl+OYRbu2zrfkPMRU4kNq2rfKmD/Kbsh7r2Eif3gjQoMa5n6BFZ2/JuMGfynMKxXlbawKMwTl7ysgAy1ju9xadU7SJDeBqH1XHH/d3nDcqBPVW4Pbkwog4Vvw57XE7JbI=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN7PR11MB2754.namprd11.prod.outlook.com (2603:10b6:406:b3::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 01:02:56 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 01:02:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Topic: [RFC 03/20] vfio: Add vfio_[un]register_device()
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgACO5rCAAAe5AIAAAJMA
Date:   Wed, 22 Sep 2021 01:02:55 +0000
Message-ID: <BN9PR11MB543319414486E17EE5BBE7D28CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB54330421CA825F5CAA44BAC98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922010014.GE327412@nvidia.com>
In-Reply-To: <20210922010014.GE327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e04399dd-15bc-4c25-b76e-08d97d64b670
x-ms-traffictypediagnostic: BN7PR11MB2754:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR11MB2754D62ACE658168190E378C8CA29@BN7PR11MB2754.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gB2nPaKRdYr75LUhesn7qXZaLYvyNXQGnEBJOToklOlv3ctRtYwyoxP+Bumv3KA6EE2Ah4WH9p3iWqIEpjI5gDM95xJlLAt5Rps1popkRbQ2L1TMtxNOlEt6S8O+TwfwqDtX5U2BMb+NUfKVomZx+tQ2r/mpOr7EQzKVYcKDZVmS4YTByhW6mHqfubEWC5Ftzsj9NT1/teRMhRA8NMKU2W4lsU8gka62+qZYLU4BYHoWQ5/sIrN8wuWZMvIifxWtiMIfZdRjirprvDOOpEJG61xhAjbbHmP9u5a7jPvY8FuUHWJvZOICEe8IEU83uyWdrBgw5VeRp0LWz/rmycBw2uTGCoa4+SUiZ0kEP/9sWIes/3tTwKEWtPqRMsPcyTCHXzx2UAEDKnySlbfbg04PKQktoYynqSGRSbIYj4u5f2G1nNQ7oy4N9P++F8peACbzOOIAdOSOGs4955ACOqccj0Xf3DdoBb/RQKB0dEvulfdG+j8S193LI67voy9bQlx2z90saNkpqTAGBc+5ldq7D7kOuxyRF09R2aBCjZwvVnpMImW9BMJ8cyirByYkoawA3MYnk+Jv1NTbubKUUCZGEjwwSdz66voAtDl4ib67m28V5pj/aYhm6aYNQMfIeoaznxFK9eis+m41v/Vi8iZNoDtRuntILW6ZpfviUliMr1tcnSJP9HHCVDR5c9hGkgKku6NudEAhHxgdqTXCgpYGwEw3LhjUD26rQToW3liazcMHgFnL/h9BIlhzlqHHsxXqa5v2yhCXJfcj1La/tfzHI9SG68dUCwoa+vS5KoEqboc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(84040400005)(66446008)(4326008)(64756008)(8936002)(26005)(83380400001)(2906002)(6916009)(8676002)(5660300002)(33656002)(54906003)(86362001)(6506007)(316002)(38100700002)(9686003)(122000001)(186003)(71200400001)(966005)(7696005)(66476007)(508600001)(66556008)(7416002)(55016002)(66946007)(76116006)(38070700005)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LIBXLL5Vg/JQHstf7xRlpV2NRwI1OOK92tzodS0NAnijnPL/guQSow7i96oF?=
 =?us-ascii?Q?vbeY6TYCTy6vjCfcu5wKKTSmbja4Uvo3RwbM2k4E/fDqTcEzIrmjAOlEdY9i?=
 =?us-ascii?Q?O8rmN/VVnqzZ33rRpQB0fEI9nc1i6KixCQxJxKmyPXTZKAE6fhkOxDfw2bxW?=
 =?us-ascii?Q?mz5LpgSW1BjFj5uF4YIXEFTbiWiKPfPPNESFPbtQFFhQ302PKhObCkG8niqJ?=
 =?us-ascii?Q?/hpabQtNc0Oi8QJJLPRl1CSqpdTH4gQFbyr2eEiwvTnJfJx8+WYpwUvZ/+dw?=
 =?us-ascii?Q?SWoxjtpGeT8FIS7Zb7qLAKQYb4RrQ4Vp9SQMxOZYLpy3GpLswpV1ICv9JUrj?=
 =?us-ascii?Q?y5xq4BSKvQ2isuj/fITWGWUmItM32TLy+bxH4BzavLZF9OeE+6MTJc/A2iHh?=
 =?us-ascii?Q?6HCRB7HXqYsSw8XT6GKPgu3Z3MGIHkjDz3XUl+g3v/q1FaslJ8rRa8FPrsTW?=
 =?us-ascii?Q?0rECdzhiY/2y5B1bdLCMnQ28GAZbuB4EmAwpGUG340YlE40Aho1gNl5IIUNj?=
 =?us-ascii?Q?zDGXigvE4zgr/XlWTOirVQ0xxSx9Nlw0mwgl74CN43wnOhYdvT2YqaHcie/D?=
 =?us-ascii?Q?BYAnpzsPV/m8qID//E6JduYZyAcWbVuNQI9Jip6ov1lswuHIemhWWEx4Zmd4?=
 =?us-ascii?Q?ixK+a8ViqR6DuOSyfSEKzkDT6POkkjl6GUXnKUu/SVwl7T/qiCYI23WsHs7j?=
 =?us-ascii?Q?hWpg4HH7tmFyLwY2uzeZLuRhXZ4wC7rfaN7sH2VhCKP7T21+bUU8Nseo4LUB?=
 =?us-ascii?Q?gRTPnSYcgUW1g12TjOB32rslPe2oySlxr422ahALtHxHovwuQ1Wmt/S3K1JL?=
 =?us-ascii?Q?yPVEVIwFwJ+qlccAt5Cmdc2xdVF3oYTX1Pp0aNAhbth3kEo4rvs+Oc7H1uui?=
 =?us-ascii?Q?drM9SE37IoCjnzpFWNtYds9hI6j/0++3kLvMOR1NWYSwgQKfoDNmFT+CVdkQ?=
 =?us-ascii?Q?nPXiPkjGAlV7m7NgYygDGXnkaKd9uCwjkgKBTApXk/XZw1DcBCVNgkqfYvnt?=
 =?us-ascii?Q?PLyP0C/hQyIx9R/L1gCRiyhj2PshU104GKB0NQjBXjQKo9wSEQV1CzTFvQmz?=
 =?us-ascii?Q?rIMWoVfSt1/qS7jcxNzXpowwPlXQ+PWjfUjMClkVpShdQLCoKfejAKM/IGMn?=
 =?us-ascii?Q?nXyO8HaJqDavZMYVhwvi105SO+4JLkmKrNAinyFOJEW6iXhyUrT836h6QjPS?=
 =?us-ascii?Q?FDbHox6dnM9D89GPcFSupHlCyR/YuPgqInoDH6GF3Fj7M3+yKQ1znO7gmNg0?=
 =?us-ascii?Q?1k1oN8kOuVp0M+166KQym396YNatMEcbR6+gSMrTD+xTURB/5LLDRE1GL1GM?=
 =?us-ascii?Q?Jpg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04399dd-15bc-4c25-b76e-08d97d64b670
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 01:02:55.8890
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MfaBKP6HNA87i1YJ8SoiPIWllNzpydVHVa4yi2MCaL/IcVh9eyh0xrnvexalTmrae3RskNO3LDXr3Le7fTF92g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2754
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 9:00 AM
>=20
> On Wed, Sep 22, 2021 at 12:54:02AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 12:01 AM
> > >
> > > >  One open about how to organize the device nodes under
> > > /dev/vfio/devices/.
> > > > This RFC adopts a simple policy by keeping a flat layout with mixed
> > > devname
> > > > from all kinds of devices. The prerequisite of this model is that
> devnames
> > > > from different bus types are unique formats:
> > >
> > > This isn't reliable, the devname should just be vfio0, vfio1, etc
> > >
> > > The userspace can learn the correct major/minor by inspecting the
> > > sysfs.
> > >
> > > This whole concept should disappear into the prior patch that adds th=
e
> > > struct device in the first place, and I think most of the code here
> > > can be deleted once the struct device is used properly.
> > >
> >
> > Can you help elaborate above flow? This is one area where we need
> > more guidance.
> >
> > When Qemu accepts an option "-device vfio-pci,host=3DDDDD:BB:DD.F",
> > how does Qemu identify which vifo0/1/... is associated with the specifi=
ed
> > DDDD:BB:DD.F?
>=20
> When done properly in the kernel the file:
>=20
> /sys/bus/pci/devices/DDDD:BB:DD.F/vfio/vfioX/dev
>=20
> Will contain the major:minor of the VFIO device.
>=20
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.

ah, that's the trick.

>=20
> in the above pattern "pci" and "DDDD:BB:DD.FF" are the arguments passed
> to qemu.
>=20
> You can look at this for some general over engineered code to handle
> opening from a sysfs handle like above:
>=20
> https://github.com/linux-rdma/rdma-core/blob/master/util/open_cdev.c
>=20

will check. Thanks for suggestion.
