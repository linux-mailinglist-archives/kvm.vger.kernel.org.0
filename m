Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2B430DB4
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 03:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbhJRBya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 21:54:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:20427 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235368AbhJRBy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 21:54:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10140"; a="314349919"
X-IronPort-AV: E=Sophos;i="5.85,380,1624345200"; 
   d="scan'208";a="314349919"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2021 18:52:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,380,1624345200"; 
   d="scan'208";a="628974319"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 17 Oct 2021 18:52:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 17 Oct 2021 18:52:17 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Sun, 17 Oct 2021 18:52:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Sun, 17 Oct 2021 18:52:17 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 17 Oct 2021 18:52:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aotrD4xFWBu8MyKn94iQ8bmEYIWqxw4i2rB85R1JRaujR3JkB9f0uNQRHAUcPF3Ktd0/FwYZCa1ce+XxvPweoAKITxycfOQaLn4nrLvsR5SBzeWUDEZ+MLzMkIzqAP8bOMbrpRDSVV6wksTusXUhPRNCvtJs3Mhusem1Wf5O2NNcpA9y8LKoTgEviErcOZf6x0DzZ3NTMrPmk83nCKCYSx3rzRCDGvVyOktw1P0EsZtO/nv7muKpVfFVkAdqVd+KSn2ccV0L7pwxhuM6zFiXvYiA/Me92xFK0Rhmy1Cdc4w4ezy4R3cHpq9WGLt8SF/RkyAVWVBL0qLwJB/4zCT8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgSM4lCcdHGLcFKIXIjEdE45ppt8/vxF01pZiXGp5VI=;
 b=XpNx1wGrI23jGQP4B6zQgcqfEAp1Xckt7uGcL29pKkLjvkiLSJFo1EzAZe6EKg+jIhJMv/OBOhldr41qShGV5Ed+7w2kTVMmh2TH/ndEbv+IXKxzamRm7tK1DN9Wc8tRmDonY5U4KnqSNfMCnLPORpeVOQg30OCYjXW4VPFXqeLxFiHc/hULvpv/K+d23Upv89NFlk17Yt//JKwYOrvDKJwsB6dxLRGYcJjikzF2Zo2nyUe8lJ0ngHUObwJ2oPVQFTMl5VSEs0lwRwR6uSv3fHXKsuuZLFgt75wnJVL5WfdVimwf0eXwlb44G6VkpWcaD1RCNGRKfi5BhtBVwnwhnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgSM4lCcdHGLcFKIXIjEdE45ppt8/vxF01pZiXGp5VI=;
 b=nfPL9LbKhTfq56JtGQZx1j0Zwk0uXESXRic77IUkacPvOR+4CZxPrV7pscNUSCXjZefFoIQvchnFNEHij4GYTbTjjcR9f/aK1Rsj0FKIS7qNiqTf91N5hiDGJnV1N44al9WsbU08lI6sM8cNeWcoAf1e793TX2Xu3YTrK/tZPLA=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5465.namprd11.prod.outlook.com (2603:10b6:408:11e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 01:52:14 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 01:52:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgACkNwCAAQ1OQIAAT36AgAAbKoCAAAj5AIAAq5rggADTsACAGGANEIAApsQAgAQYyPA=
Date:   Mon, 18 Oct 2021 01:52:14 +0000
Message-ID: <BN9PR11MB5433AFF410582D59E8566D198CBC9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115751.GK964074@nvidia.com>
 <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
 <20210928140712.GL964074@nvidia.com>
 <BN9PR11MB5433B8CB2F1EA1A2D06586588CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929125902.GU964074@nvidia.com>
 <BN9PR11MB5433C616093C8DDA5A859C2F8CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211015110956.GC2744544@nvidia.com>
In-Reply-To: <20211015110956.GC2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b8cfa27-4ccf-4e7e-d799-08d991d9e88a
x-ms-traffictypediagnostic: BN9PR11MB5465:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR11MB5465D116040DC119CD97D1488CBC9@BN9PR11MB5465.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z69DyolK/Ozo6oWLPExAnL/lX1ToHnzq6vMDdCocEOVFtR8DrRTFAyBFNKQexCIDI6ou7p5m9VOopEQYkXYK9rhqhONLFkfYfdz6Ok5YURHIorquIN5h854+cCHCamKMvHi7ywHy0g+d9NAQqIbK+bhuKmxjRNaHBi6ZyUBBjWMPot2qNMjxX4HI6T69M5KJSxMuclME78+TGGrC8c8x/NWbg5QHLazX7qr9dbUy9lrNtJo2JKjPtPNwjNQtmXCkXYt3pSb2Zsy4PBMY3u/kMWUD4mrwFKvwsYIiUSJyPG0rZGdtf0Z9jJ70dXGJoOKQNJuq4hsWCvkRJ1JQLA3mbEngoXCyOlHXywRZ5WggXs3XEjMSVPK5R0u8kFkLXYfPn1R2dZCKIn6eDGT2DcpZ9XS5rkLpaLZrkKoomkfGQ3foqXF3Z8kSbMlUMAl3N93DdcCOvcfgThcnNeotyeKXAEe8gHJpLoL0Jkh7mhFhetVA+nQrzneMY/FBh/TgjY1CsoPxffb61m3rTV5v/+vbjBzOZoJ05sF7NqUFQgK0hAXLeIeJeqp+CrpXwneUd4WrYlzU16SgPfk7QQ+kQCBwbBwbdh64Ob5hTkr1/grEf9C76pQBcfWyPkpn3+nB+HomvL7FD45EdvEgzoB0o+FaDIZDR1Uxgbb4Dd5SlEYp2jVGQE7gnHA9yMenz8dwArZmc/uPAhDW6/Xq6SVNst63LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(86362001)(2906002)(7696005)(55016002)(38100700002)(9686003)(8676002)(5660300002)(122000001)(508600001)(7416002)(64756008)(316002)(66556008)(66446008)(26005)(76116006)(6506007)(66476007)(52536014)(8936002)(54906003)(71200400001)(66946007)(83380400001)(38070700005)(4326008)(33656002)(82960400001)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CZnfAOa7n1a1xS7/jE/ON4yuvSWmXvwfdeQVxOuE8/wqxiFWa29ikBwo7rOK?=
 =?us-ascii?Q?H9IHdx8b4QWnn5LGWAtClFN5zLk5l2naKQCIfpeHunjfJHipnfFBT7VEPg90?=
 =?us-ascii?Q?xFkPG42ggzsiDq1nazJ99dDwj2QsD1fAha+UXF4pNx4Cd3oN8gacviaro3qu?=
 =?us-ascii?Q?F+KCCiOs5XXdQzrbJyG+mEiFTjo4Cufe+YzfXhAN3GV7A0ezEsFyI2tiUXPR?=
 =?us-ascii?Q?0r05ydVk/rKCSqmsWpw4V7Abpf2bnR5gtXZxGVXZGEfs8zIyez4VtTu+bKh6?=
 =?us-ascii?Q?yktsvaou38nKbQlbUpTn4mNoifws4BvAnJqaS4J1E3beSNF2WweX+l1EHszF?=
 =?us-ascii?Q?B6lqDuhvjrVINVeiJlceidi5oUe1hH2QQzUEjewtHTX4g/sLaLOZWhK8eRTf?=
 =?us-ascii?Q?ns8MYbejR77/2EQlv01LoJ+00+EtPkhdPagoo7mvpUCrgT7NrLrhf9npLJwp?=
 =?us-ascii?Q?JnxGNVKVQT/2tKNdOr+4ux4VVHv6Nwk/kmB6g/kxky+eYRsYBwNq67TALJUo?=
 =?us-ascii?Q?F8HAj7MBNP2jvqsU+GL5pLytZ7io7wFB+VvyO598Uqmmg00E0oiO8x7l+i8x?=
 =?us-ascii?Q?W+StkC1bMP5TqlNJ6oLpC7INJKQeooTWFyNPYubaQTOTIrf/0FXqgaEZdlSc?=
 =?us-ascii?Q?RbDJcFVoRS2VOBXPwz8TC0dLqUOoyVIlseo5RCitAGbsaCA+5WB3f1fD6w9y?=
 =?us-ascii?Q?PP5WJjULLVngFL+2GEgn2DW3Jj/+b30G57Oblc3EzmOzOxCuk303lCriMOfp?=
 =?us-ascii?Q?mcFq8mzbeYKEenTCs4KoP8rCOWwCa/6nc11N8dhpTOyxHEmJhtKsLdcnCYCE?=
 =?us-ascii?Q?tXhEtTFkAjrek8iXGxasI6/N0qJ/Hk47XlRDFdYiqnxpIDYB2jATQCuvuCsU?=
 =?us-ascii?Q?vLorrKKxjxQ1X+aYgobJBuQfAdi38ouaLhukS7/VdiTGSapkg6afQIRcHUuv?=
 =?us-ascii?Q?XzepVhaSqCBWhA3Fk3u9AibB3ESi+u1lQ2+f2x4XdyRO9isms+4V9Abm9idm?=
 =?us-ascii?Q?XrSmqfo7AHLRKR24CYqdlWxQ3b/kejqL9qlBTBvYCyDVdHsUjJtS03P61TZX?=
 =?us-ascii?Q?UFozGRSL3W03AaFXMINSB7hTJq/J6gvxz5vrszY48zhBuhkby9uTJRbYrqvS?=
 =?us-ascii?Q?MTFNguEQpvQabwQ4vmHacoI/kliuYXPnnqTNDxQaldb8z+cIQKUoT08myN/S?=
 =?us-ascii?Q?ZPSHloJxN9zfRPxlX4JmzvqbIkCGPqEU1ShoWMzNp6f9QaWGEsYB3007eTW6?=
 =?us-ascii?Q?1V7Tep3SSquBn5KaoxG87xRYV9mOKLjvIIjargydTCJNx393TMnnt1G2bYRH?=
 =?us-ascii?Q?BIgIhd6w+iM8dh31QAhSssIr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b8cfa27-4ccf-4e7e-d799-08d991d9e88a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2021 01:52:14.3824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vwFnfi5nefz6OtuJUqlbtWojMmZlo5X5nOYbT7bpKeWusJb9iKecvOZBxXQchHliw0zQt12D5v3Y8pV+NXbLpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5465
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 15, 2021 7:10 PM
>=20
> On Fri, Oct 15, 2021 at 01:29:16AM +0000, Tian, Kevin wrote:
> > Hi, Jason,
> >
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 29, 2021 8:59 PM
> > >
> > > On Wed, Sep 29, 2021 at 12:38:35AM +0000, Tian, Kevin wrote:
> > >
> > > > /* If set the driver must call iommu_XX as the first action in prob=
e() or
> > > >   * before it attempts to do DMA
> > > >   */
> > > >  bool suppress_dma_owner:1;
> > >
> > > It is not "attempts to do DMA" but more "operates the physical device
> > > in any away"
> > >
> > > Not having ownership means another entity could be using user space
> > > DMA to manipulate the device state and attack the integrity of the
> > > kernel's programming of the device.
> > >
> >
> > Does suppress_kernel_dma sounds better than suppress_dma_owner?
> > We found the latter causing some confusion when doing internal
> > code review. Somehow this flag represents "don't claim the kernel dma
> > ownership during driver binding". suppress_dma_owner sounds the
> > entire ownership is disabled...
>=20
> If in doubt make it
>=20
> suppress_iommu_whatever_the_api_is_that_isn't_called

ok

>=20
> > Another thing is about DMA_OWNER_SHARED, which is set to indicate
> > no dma at all. Thinking more we feel that this flag is meaningless. Its
> > sole purpose is to show compatibility to any USER/KERNEL ownership,
> > and essentially the same semantics as a device which is not bound to
> > any driver. So we plan to remove it then pci-stub just needs one line
> > change to set the suppress flag. But want to check with you first in ca=
se
> > any oversight.
>=20
> It sounds reasonable, but also makes it much harder to find the few
> places that have this special relationship - ie we can't grep for
> DMA_OWNER_SHARED anymore.
>=20

It's probably fine. People can just search the suppress flag and filter out
drivers with DMA_OWNER_USER. Then the remaining set is about=20
drivers in SHARED category. Less straightforward but should be fine
for a relatively small set of drivers.

Thanks
Kevin
