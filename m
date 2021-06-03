Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE63999B7
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 07:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhFCFUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 01:20:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:46466 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFCFUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 01:20:52 -0400
IronPort-SDR: 4piRnmINQWsUWZ5uD9Zx5PsJSCFV1tRTmVqB2sjXepwzqUjs/nSCQVgwJiGKX/XBxZLffhVq4o
 fZ6PClpEip2w==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="200955170"
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="200955170"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 22:19:07 -0700
IronPort-SDR: dqOd5x+wF1rIiwBqy8/8q3HkNchm8u0kbu4Y68DNnEHmz65FaUW3yFovy9L4Ek3q31glMyL9mF
 o5Pnm5DEYqyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,244,1616482800"; 
   d="scan'208";a="636120854"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jun 2021 22:19:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 22:19:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 22:19:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 22:19:05 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 22:19:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGM1B5MmP6KkAUL8tZ1D22es8Qi3+bi9aFsKbvsw3we7uy5X9HrlRYYCz77slSdxSz+m9WVlLKghX+6e+jSf8fwT45HpPtgrfjasitw9zRzavLnTZ9RnoSHaXYjCHqLE22u15fr/TpbL+2SpQfi6eMQY+g/Lq8sI5A/J+Flc49XW645hFHM86saIowCcKqOijIcGKNBEB7u665kkKuTKPgL8PAgPwxHa7jX2VSnPyScAg/C2VjaVi/eXesOFYtiIggt0dKIHNnvfHq1d9YbdHwPsL4xRplju1jAhHtZ0alS/ZJu8u9IU4obOxPuNtS4k3RVCykf3cRRcXewh+a4LnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGW6U8eKJ5u8dEt078pWpYJQDa8s1Z/GSYTtB3EgAaI=;
 b=cXX292ha96UoIAnGew7XiQtsxfX85niDH7klDN70DgO5gU4uyPZcam2/RrjQhYdIHkv6mxB/isPjodod5ZonkIQ4rNA5C8GqbW2gbVxQAMrzsESo78fLjmVcGBrq4yn9yBS4VHpKszyFVdzSsUIO+xmi6La8rF9CutMkm4OulzAttJkHSGeqCZQqZJ5RKXEM4Zn/U/14jnjZykmblvdLQfTOAXTEqtUNwqhVnwD9q9+dy9zeeJZoVTPb1zAJVyVvsRfaKKvqf8CacV7zQcPlEfdgFpLU+8GnizlTnZMxA8TMUFmRmyZoNoG8meiwBDAtFP6beySDh2eNhQBfdK2L6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PGW6U8eKJ5u8dEt078pWpYJQDa8s1Z/GSYTtB3EgAaI=;
 b=WYiTQumC7BQxcXG52hS7A0qka1Wd0REolq7Oip138kqHziJ+Q/EwmaQmHV4vlMJr6Deb0i5biYE8nFCZpgmVhXBYbkE6qtqVMPivzDfmlnOYVntuejDUYknH7eEunoauXkviXwrCTcKAhJs54kGUkDdNfnYGmQl65eHIFj5wPWg=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1471.namprd11.prod.outlook.com (2603:10b6:301:b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Thu, 3 Jun
 2021 05:18:28 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4173.030; Thu, 3 Jun 2021
 05:18:28 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: RE: [RFC] /dev/ioasid uAPI proposal
Thread-Topic: [RFC] /dev/ioasid uAPI proposal
Thread-Index: AddSzQ970oLnVHLeQca/ysPD8zMJZwBL2ymAAKTbxpAAKSt7gAAHpf9wAB1YcAAAAm5sgAAA1YgAAADonIAAAEmcgAABzCaAAAHbfwAAAYTsAAAEeLUAAAiRJwAAAHcmwAACeAWAAAGoYiA=
Date:   Thu, 3 Jun 2021 05:18:28 +0000
Message-ID: <MWHPR11MB18860BF3C9DA2B8688907D508C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210601162225.259923bc.alex.williamson@redhat.com>
        <MWHPR11MB1886E8454A58661DC2CDBA678C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210602160140.GV1002214@nvidia.com>
        <20210602111117.026d4a26.alex.williamson@redhat.com>
        <20210602173510.GE1002214@nvidia.com>
        <20210602120111.5e5bcf93.alex.williamson@redhat.com>
        <20210602180925.GH1002214@nvidia.com>
        <20210602130053.615db578.alex.williamson@redhat.com>
        <20210602195404.GI1002214@nvidia.com>
        <20210602143734.72fb4fa4.alex.williamson@redhat.com>
        <20210602224536.GJ1002214@nvidia.com>
        <20210602205054.3505c9c3.alex.williamson@redhat.com>
        <MWHPR11MB1886DC8ECF5D56FE485D13D58C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602221455.79a42878.alex.williamson@redhat.com>
In-Reply-To: <20210602221455.79a42878.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.142.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 18fa02a9-59a1-409d-0460-08d9264f0557
x-ms-traffictypediagnostic: MWHPR11MB1471:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1471682955EE29B80B6F01548C3C9@MWHPR11MB1471.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cI+k8obFzjdf7srFSIPBPBvRYpWa9FwYmLJCeUXNEBN/fwagoL24Hd4xba9t4BNBl+lKFD6MarH3HDM8lzOB7s8VXpNV0Rv4CzqQevEujuq2Xspfh/7q5WgmkeOCo7yHXufjg5gM9oP0MmjsBEAVlMMrXoR3U7rELkRzo4M7zY/oihZN2Tl7wQWlPcL+iN7HcYikiMNmhJDEgzephxCx2Op01/sAB8i3KQZLP7RIfzag6IGuu7MYfUeecurwXknmyQqud7rk4yFJgSYyWb5YW7ta3NWRatfRmpsku0Q4JY3rTP31Cg7kk2meXArP4AjsAsIUVbTXM9omcmEUEw6caTXzmY+vzIR9a+XRUCh6DuVZdwPTe6itqlFO8j4CylNkN1p83p4DrIbB/KtSCJ8g9R1EPzmpQooHWIjsBz0szDPvk6bBnB3QRUHUr2G3oyF1VM1Cqqhi+O1i3fux9oMxiThxuX9c6UWLrnlzCkkrSSXqfZMnSsdPS6KLp3SYn2ryq8Odx4PXXRKnOm8KutVuhzJtVE3BtYRXO52YQPaGJwHCpKkVWx6tBxnYsOkkuOm2GUzybmhY25nvpjwiFXXqtCZUT7dXVcqsYa3TNZAIraU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(396003)(346002)(83380400001)(86362001)(7416002)(38100700002)(122000001)(316002)(54906003)(52536014)(2906002)(64756008)(33656002)(76116006)(66476007)(7696005)(66556008)(5660300002)(8676002)(66946007)(6506007)(478600001)(8936002)(9686003)(4326008)(186003)(26005)(55016002)(71200400001)(66446008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DtUHuJOz/FYWuuavxhqlBotvPFtrTF4RVWDjCfgFcLbRT+i+f2zK3wiQauy0?=
 =?us-ascii?Q?52bO0xiSAzUycYk8D0UmrW0mTf+JQvxNLkH6DVGBMDQ31pPjau1wxVdsgE1E?=
 =?us-ascii?Q?s89GKlDK2gWGkd1qFfNA2czZZwktbUfjg0PF7T/FvJXF+Qwy5DiCsa+PC2di?=
 =?us-ascii?Q?WQEZZLSC7p6rPSE5c4/vi1steArb6W8zxwOI4VRy2sYDusMIQYBazW3EV9M/?=
 =?us-ascii?Q?GpEYnX/qvhWQIxGK4XE203cEuy3EJSwKoq2/djKjYYvC3Ubv7SGJtaUvpsc4?=
 =?us-ascii?Q?clBLdtmm6lpPq6O6fzIA08GQ2Y9bRF0mYl8gctWypyDrn1hSxymqXyrkn8N7?=
 =?us-ascii?Q?YxjmSnphu9YQvlV3JsxT/ls9KPQtNGwOPAohO4icI2oTBsanyq4J92NpnSmY?=
 =?us-ascii?Q?LondUX1jJFhanefp1QKwtl/xtmSlkdFzVIrozfwcf4XkZdWmn78j+IhOsx9C?=
 =?us-ascii?Q?o4nKaWI4IjaR6aAAaH0zEtGtwmiN7GxaamV3PcX3gzT+EtTfiw8yps0wpMty?=
 =?us-ascii?Q?yBcHLJdT0bKQHwyGM80glWufZU9Y0ZXgkInaoBmAXEx53DO9uGdJd2DKa1YH?=
 =?us-ascii?Q?Io906bxPOahquWa08sc3EmXfym/8cjOj6q9oLeIBGTRQt0mCX8WSDGMT/Wga?=
 =?us-ascii?Q?QKljpEGCvR9ojJXV5Xowz/FbSFDA8avIQ+oPopFJjkE2lN0G2jwtcIiFdA9L?=
 =?us-ascii?Q?zZ6YSBCdMCpoO77+o61AqBxeFASeQLwGE22uk/7cqlqoneXRG6LV2PkB9gIU?=
 =?us-ascii?Q?6Q4ljpCLVMt9xwkbLjkmjbrU0gHNDj5BaIiICoeVwS04eSBhODASJOAlEY1B?=
 =?us-ascii?Q?ut3HoKKqqd+vZB6OhKDohH55mJYYM4Ku/sUTJ4vQkwIXdgTBw+COFksFz+U6?=
 =?us-ascii?Q?rJk63ED8wICdhSpbifnngaJvWsMkZvPSLuOqA+E95296GS6NSPiMkMcoLr34?=
 =?us-ascii?Q?k5Yi3+TyCYIVM9CXevwWJA3JoA5SvacXa1IdcU9X2jQCAPIJdL5FQ3cJ0+ns?=
 =?us-ascii?Q?WD3nJjA0ogxy1M9Ox8Mb3NKx7hq3gol1hw4IZK0OCdWdge1PPmBlUY0rmrV5?=
 =?us-ascii?Q?TQxPtLprrWfbT6mi4DZQzlFiIzlvuj5Cs1Klruoqf03tbbu1TNH4oi/Z7U0e?=
 =?us-ascii?Q?CKrkZ0rJW0u05hbSdPKcV4DD2+TkZ5XRQr9Vlzce10N0gw7ki+hMljPpShxJ?=
 =?us-ascii?Q?kIfAr5+xLczPtLfNqFBiXjoH2/MA73qwKRmeGNMiKHVZYmLov0o/UiHQSO+c?=
 =?us-ascii?Q?THqM7tfIRneabuuCmghJ9pO6YldhFyzxr7DwLCJr/LyRcwUQ0RNAi6MuEE2e?=
 =?us-ascii?Q?usTqIzPy+WmDut3vaLosODGg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fa02a9-59a1-409d-0460-08d9264f0557
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 05:18:28.2217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wl0dMUtiQ7JDiFSYEC6Ib9IZStxGQ6DC/98ZSqXYERuKooXWXU9Jlubh+/589vwYRgbyeDgH2mxZgX6GkNw1WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1471
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, June 3, 2021 12:15 PM
>=20
> On Thu, 3 Jun 2021 03:22:27 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, June 3, 2021 10:51 AM
> > >
> > > On Wed, 2 Jun 2021 19:45:36 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Wed, Jun 02, 2021 at 02:37:34PM -0600, Alex Williamson wrote:
> > > >
> > > > > Right.  I don't follow where you're jumping to relaying DMA_PTE_S=
NP
> > > > > from the guest page table... what page table?
> > > >
> > > > I see my confusion now, the phrasing in your earlier remark led me
> > > > think this was about allowing the no-snoop performance enhancement
> in
> > > > some restricted way.
> > > >
> > > > It is really about blocking no-snoop 100% of the time and then
> > > > disabling the dangerous wbinvd when the block is successful.
> > > >
> > > > Didn't closely read the kvm code :\
> > > >
> > > > If it was about allowing the optimization then I'd expect the guest=
 to
> > > > enable no-snoopable regions via it's vIOMMU and realize them to the
> > > > hypervisor and plumb the whole thing through. Hence my remark about
> > > > the guest page tables..
> > > >
> > > > So really the test is just 'were we able to block it' ?
> > >
> > > Yup.  Do we really still consider that there's some performance benef=
it
> > > to be had by enabling a device to use no-snoop?  This seems largely a
> > > legacy thing.
> >
> > Yes, there is indeed performance benefit for device to use no-snoop,
> > e.g. 8K display and some imaging processing path, etc. The problem is
> > that the IOMMU for such devices is typically a different one from the
> > default IOMMU for most devices. This special IOMMU may not have
> > the ability of enforcing snoop on no-snoop PCI traffic then this fact
> > must be understood by KVM to do proper mtrr/pat/wbinvd virtualization
> > for such devices to work correctly.
>=20
> The case where the IOMMU does not support snoop-control for such a
> device already works fine, we can't prevent no-snoop so KVM will
> emulate wbinvd.  The harder one is if we should opt to allow no-snoop
> even if the IOMMU does support snoop-control.

In other discussion we are leaning toward a per-device capability
reporting scheme through /dev/ioasid (or /dev/iommu as the new
name). It seems natural to also allow setting a capability e.g. no-
snoop for a device if underlying IOMMU driver allows it.

>=20
> > > > > This support existed before mdev, IIRC we needed it for direct
> > > > > assignment of NVIDIA GPUs.
> > > >
> > > > Probably because they ignored the disable no-snoop bits in the cont=
rol
> > > > block, or reset them in some insane way to "fix" broken bioses and
> > > > kept using it even though by all rights qemu would have tried hard =
to
> > > > turn it off via the config space. Processing no-snoop without a
> > > > working wbinvd would be fatal. Yeesh
> > > >
> > > > But Ok, back the /dev/ioasid. This answers a few lingering question=
s I
> > > > had..
> > > >
> > > > 1) Mixing IOMMU_CAP_CACHE_COHERENCY
> > > and !IOMMU_CAP_CACHE_COHERENCY
> > > >    domains.
> > > >
> > > >    This doesn't actually matter. If you mix them together then kvm
> > > >    will turn on wbinvd anyhow, so we don't need to use the
> DMA_PTE_SNP
> > > >    anywhere in this VM.
> > > >
> > > >    This if two IOMMU's are joined together into a single /dev/ioasi=
d
> > > >    then we can just make them both pretend to be
> > > >    !IOMMU_CAP_CACHE_COHERENCY and both not set IOMMU_CACHE.
> > >
> > > Yes and no.  Yes, if any domain is !IOMMU_CAP_CACHE_COHERENCY
> then
> > > we
> > > need to emulate wbinvd, but no we'll use IOMMU_CACHE any time it's
> > > available based on the per domain support available.  That gives us t=
he
> > > most consistent behavior, ie. we don't have VMs emulating wbinvd
> > > because they used to have a device attached where the domain required
> > > it and we can't atomically remap with new flags to perform the same a=
s
> > > a VM that never had that device attached in the first place.
> > >
> > > > 2) How to fit this part of kvm in some new /dev/ioasid world
> > > >
> > > >    What we want to do here is iterate over every ioasid associated
> > > >    with the group fd that is passed into kvm.
> > >
> > > Yeah, we need some better names, binding a device to an ioasid (fd) b=
ut
> > > then attaching a device to an allocated ioasid (non-fd)... I assume
> > > you're talking about the latter ioasid.
> > >
> > > >    Today the group fd has a single container which specifies the
> > > >    single ioasid so this is being done trivially.
> > > >
> > > >    To reorg we want to get the ioasid from the device not the
> > > >    group (see my note to David about the groups vs device rational)
> > > >
> > > >    This is just iterating over each vfio_device in the group and
> > > >    querying the ioasid it is using.
> > >
> > > The IOMMU API group interfaces is largely iommu_group_for_each_dev()
> > > anyway, we still need to account for all the RIDs and aliases of a
> > > group.
> > >
> > > >    Or perhaps more directly: an op attaching the vfio_device to the
> > > >    kvm and having some simple helper
> > > >          '(un)register ioasid with kvm (kvm, ioasid)'
> > > >    that the vfio_device driver can call that just sorts this out.
> > >
> > > We could almost eliminate the device notion altogether here, use an
> > > ioasidfd_for_each_ioasid() but we really want a way to trigger on eac=
h
> > > change to the composition of the device set for the ioasid, which is
> > > why we currently do it on addition or removal of a group, where the
> > > group has a consistent set of IOMMU properties.  Register a notifier
> > > callback via the ioasidfd?  Thanks,
> > >
> >
> > When discussing I/O page fault support in another thread, the consensus
> > is that an device handle will be registered (by user) or allocated (ret=
urn
> > to user) in /dev/ioasid when binding the device to ioasid fd. From this
> > angle we can register {ioasid_fd, device_handle} to KVM and then call
> > something like ioasidfd_device_is_coherent() to get the property.
> > Anyway the coherency is a per-device property which is not changed
> > by how many I/O page tables are attached to it.
>=20
> The mechanics are different, but this is pretty similar in concept to
> KVM learning coherence using the groupfd today.  Do we want to
> compromise on kernel control of wbinvd emulation to allow userspace to
> make such decisions?  Ownership of a device might be reason enough to
> allow the user that privilege.  Thanks,
>=20

I think so. In the end it's still decided by the underlying IOMMU driver.=20
If the IOMMU driver doesn't allow user to opt for no-snoop, it's exactly=20
same as today's groupfd approach. Otherwise an user-opted policy=20
implies that the decision is delegated to userspace.=20

Thanks
Kevin
