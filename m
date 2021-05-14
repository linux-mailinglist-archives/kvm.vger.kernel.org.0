Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57393380BC5
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 16:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhENOaB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 10:30:01 -0400
Received: from mga05.intel.com ([192.55.52.43]:3477 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234316AbhENOaA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 10:30:00 -0400
IronPort-SDR: Pu5796+E/hUfsq+ovBsGI3OU5wVXFBnB+DA8gQKDzcuWapv2aoYJidHDGmsZ/hvsywvY4DBkl2
 YlvRL3B8RW2w==
X-IronPort-AV: E=McAfee;i="6200,9189,9984"; a="285708097"
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="285708097"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 07:28:49 -0700
IronPort-SDR: Yew1VVe5mjV0rhDW7L7dkC+00Mf/t4k/U+Gf4ATtHr6Ev91p5WLkm6sA8ac06/PLbAS9Ifu/+S
 MzvkHFju49CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,300,1613462400"; 
   d="scan'208";a="627176247"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 14 May 2021 07:28:48 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 14 May 2021 07:28:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 14 May 2021 07:28:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 14 May 2021 07:28:47 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 14 May 2021 07:28:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeBPR/9tgNSeJm7qeLJ48zG1clRl16nvkK8ImIYuAvycT+Y4jviDHXQcZ9QLhj7sVvNJsHdDWkRj23uUEIC9tCEKlm7v7t1Oqltcz16AeSf9qTGCFeTA4nI7qg9fwokNys8KEmch847qBWmwAj8kbo9zc9CNez9Z+Fj+fOHDY4Z++MQ4bdO1Z2O4uvsn4glhx9dGX+sMdXcj+ReTIjwcbWUJn3lNaycZ4Waf7B5r+n/+ZwoNDtiBCylrhoUOS4QpTwQJqud8RM7Jx/Bly3GMNwfDb4Dcj0TdhYEJ5QDyIwf53p2KIFt0ujVTiSXVb32SDPusk7nsdHjwt2CHaIRJMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pY/sKHrzu+EzhUPob2xvVMLaiwuJeWBHOXhetcVOpYA=;
 b=Ljk6qLShBk9OtxgCqHcs+rcTblek5FcK8UWYl2tjeNPd0I9quOeiH/cqPHAGb/Xl2UiAkl3kMzBnupXiB6gBfZhQry04tO4u7fcbN+TOU3PcHRSiHHvEbgjNsoWw1TEakz4q87mQEuwLTRqQWWnDXBP59vmK6VNpWtl2oN/SrL4pmrSuXvKI3SW42eQOeBHrJrZQVlrQ4YKhMhgZIBYh5wYC1pZDD+mGu7+AHnYP+AEmCFbzgQou7KG6u68CLDbGT1WtR0n41KF8Wwk/VRBxULlx2bG40RJ1+7Kx2C+BlFgb8uqusjCek9m//IM8lcSlfiw/f8ZUOBz0HsTUlyU/+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pY/sKHrzu+EzhUPob2xvVMLaiwuJeWBHOXhetcVOpYA=;
 b=qOT20nLAHWjjfDuLBa4HGeoY140kGNPDhGBQcjX3Qh5gX/DsNmgddha56Z8rtK54gU0ALnHa5VrYX83F+S99q/G6MhZ9OnI5aCCFrIbqjfOH4n5uJ0RxbIMJ5E260sUFrp6YGaWnJm3dWb1/hhCkSn06c/0pi+m6MI6V2HEIGpU=
Received: from MWHPR11MB1886.namprd11.prod.outlook.com (2603:10b6:300:110::9)
 by MWHPR11MB1405.namprd11.prod.outlook.com (2603:10b6:300:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Fri, 14 May
 2021 14:28:45 +0000
Received: from MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1]) by MWHPR11MB1886.namprd11.prod.outlook.com
 ([fe80::6597:eb05:c507:c6c1%12]) with mapi id 15.20.4129.028; Fri, 14 May
 2021 14:28:45 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        "Alex Williamson" <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Topic: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Thread-Index: AQHXRWldX98a1U6w60C1HwYkmNlXK6rc3tAAgAPcBcCAAJmdAIABpYywgAAIW4CAAAW5kA==
Date:   Fri, 14 May 2021 14:28:44 +0000
Message-ID: <MWHPR11MB1886AE36746C8F82553471088C509@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de> <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210513120058.GG1096940@ziepe.ca>
 <MWHPR11MB18863613CEBE3CDEEB86F4FC8C509@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210514133939.GL1096940@ziepe.ca>
In-Reply-To: <20210514133939.GL1096940@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7ae1f1c-4dbd-4b61-2a91-08d916e4948b
x-ms-traffictypediagnostic: MWHPR11MB1405:
x-microsoft-antispam-prvs: <MWHPR11MB14054AD8504DDEB72D3345848C509@MWHPR11MB1405.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6quSKBCpV5QnwPj3fMfEgQuH2B4OGouZF38kDC3ROtwmpUfKJCH6BhzFe79ZEFd6mhQU64OWkFXivC9drpzLqM69z/OtWz0DG2PnGubsybkd50sHMKK6wcjUrBH5svLcn36AbZIsKcZfUoBtnwBh/bm732RmR1et7sNSswWNpiuJJWx+iXpwY2I6HW3U7w9B3KOZ/ZnHGS1BJFe1UPyAds95zyUyPfc92tGvMWumIuTMHBo/mk/gySIapj0f6LVlsS1tfMfLyKAMBgyT5I/g6MJYR+W5ELbiePslpzoRVb6VwTkUxU91yLZvG2GtPW2MPpGu83359ZK8G7WNgsYEojeSC3h5sCJp0kF8Or9f8jf7v2Y8PS9xaKXuDQvzvZfSLL/3JsQnLDlFz5IwXdRQIJo5QsLWfA/Bt3SpWB7aHLrEWPa8+AKn3ZqOlAH4U/QR4hMg6m0v7r0/+ScJg2tKYet1Mvr2UHESApydCH8iewqDB85YtTDpwaqH/sgR3YeG5jj2u7uKKntt46DRcB2YsGkgJHkFLUXZ8TzOyo6zBnTCXUyskpWHM+B3OLRtlcdmJ4sB4gUpDWke2zJ13rYpMvoumOTwD0CyZfs6GljmSVM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(6506007)(4326008)(54906003)(9686003)(86362001)(26005)(38100700002)(2906002)(6916009)(122000001)(316002)(33656002)(186003)(55016002)(478600001)(8676002)(76116006)(52536014)(5660300002)(7696005)(7416002)(8936002)(66446008)(64756008)(66556008)(66476007)(83380400001)(71200400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?dEqz3KTF3ylH/l0y/DhJRqM0k9GzKQQZxX/S4gf0heKUNQZA/eGGj1xBdovo?=
 =?us-ascii?Q?LFgY89/inSAHnlfCILr2+fRN13LqIN+Hvimchy6e2gluFfNmvFeHERdPOvsY?=
 =?us-ascii?Q?N1CtsUB9ORHDARIcdfad3ZbII4PLM9qjDaFeF5yEU3IO6L6weRMXEQY76HY4?=
 =?us-ascii?Q?ilAYdYKy9rnjpNN6iFsSJhgApcvSyK7CK6bsWnmwMHU6V5OGN08rjuATSUIQ?=
 =?us-ascii?Q?u43zpGzyAuWommd8Gx9u0xHT4G+N6wD8zGMS1gyvq7m6a97w5XvB+d9ZXiCD?=
 =?us-ascii?Q?Cn4cvzkCXq/W4VnC9ttKZAm/F/RE95Oa0Lcx+HKSDiqD6/PDzQFYf7b81PEg?=
 =?us-ascii?Q?iaKvooDDwNMckOLGUyCUU06CrvZ9NrlR07H3fxTeeeHJb9uVCLq3CvXNDX68?=
 =?us-ascii?Q?rckD6UwKr71lp6ys+a373u4SgWRrYOP+ifz6qodCyy3VFYPgIyX9BbV9sTf5?=
 =?us-ascii?Q?FB5prn07vlYTLGh7vzfQ5uv3GJGltBrcfIq0wbEU/guZPQLUv+lE5Rtb3HPI?=
 =?us-ascii?Q?A0j5Zywo+rDCVSEre2EI7/eDdZvK9upAYFIcBGo7gIkCna44x9w8vQ462GOo?=
 =?us-ascii?Q?ZAIPbBUQHFo+NgZP7a1B26CPi+ShnYgpL4nv0oH4hS5lmmmShk7o2v7ErrR/?=
 =?us-ascii?Q?pt831z80/Amd0n2cBee5N+kOgTePoxWjcFE257WFqd4sWkMILYBYOG0suWoj?=
 =?us-ascii?Q?uydz7XjgNbwNtxLvu6la4B5BusME7AbIiZCBcKo8uVespu9HC6/tXt5PPUgw?=
 =?us-ascii?Q?ja+YjzeywKjlGqpxrV1W/0jR7xxClaFbFdKfzKjiAyBRtL6vs5xS4kBfNnou?=
 =?us-ascii?Q?+IjiyO6TKDd1LDUMVc+A+7kocMpSMp01Xy0E7sVHGi7YuPu0DPX0LDzK7pp/?=
 =?us-ascii?Q?8oNl2Uuvn4O2cyWqhgH5gOAXu53qegv8SjX9e7etpVydp0ff+aaYyNxZTkcn?=
 =?us-ascii?Q?u4JbRiOA15SpVOvXQZegnpGZzryCVm4CADQa4jv8xcnYMY50J0kePcr40k25?=
 =?us-ascii?Q?BwqGEu8T/UCmVI+6XClPEPzem5zfoCTiwVvlfIPKdB4srYhxRkNdu2drE4BD?=
 =?us-ascii?Q?NCn9aNlOLHZeHrrCXt28B2Wbgo0Npvdw+z0s+yPHz0iRpzrI2QQZvdZUwLBe?=
 =?us-ascii?Q?G+j2HoFInobdxu4N3TDelVPtYtckOx3U2g6nfpbekcr3EJ9e97l3iNZz3hW/?=
 =?us-ascii?Q?nPVUjXiteefr3x3p3QyGt6kbH/mNLYffb/23qMWByzFE2rN0kINdMXB9Ap8v?=
 =?us-ascii?Q?IA+QlGf8mVwZbIkyFJcwWjDmPyWCjgZu5qwTehlhW2C8hgUsqMYGGKy4LuTu?=
 =?us-ascii?Q?3h5gPV+jGPjAx9NfBYxgoL/M?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ae1f1c-4dbd-4b61-2a91-08d916e4948b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 14:28:44.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ObonG75CN11r7Mk7SC/jhdCED5Yk5+FTd3sBfH3ey3W9JRLr/KZhld+niNmQ++Id70hSHO+8/ueDyjhmntSVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1405
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, May 14, 2021 9:40 PM
>=20
> On Fri, May 14, 2021 at 01:17:23PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > Sent: Thursday, May 13, 2021 8:01 PM
> > >
> > > On Thu, May 13, 2021 at 03:28:52AM +0000, Tian, Kevin wrote:
> > >
> > > > Are you specially concerned about this iommu_device hack which
> > > > directly connects mdev_device to iommu layer or the entire removed
> > > > logic including the aux domain concept? For the former we are now
> > > > following up the referred thread to find a clean way. But for the l=
atter
> > > > we feel it's still necessary regardless of how iommu interface is
> redesigned
> > > > to support device connection from the upper level driver. The reaso=
n is
> > > > that with mdev or subdevice one physical device could be attached t=
o
> > > > multiple domains now. there could be a primary domain with DOMAIN_
> > > > DMA type for DMA_API use by parent driver itself, and multiple
> auxiliary
> > > > domains with DOMAIN_UNMANAGED types for subdevices assigned to
> > > > different VMs.
> > >
> > > Why do we need more domains than just the physical domain for the
> > > parent? How does auxdomain appear in /dev/ioasid?
> > >
> >
> > Another simple reason. Say you have 4 mdevs each from a different
> > parent are attached to an ioasid. If only using physical domain of the
> > parent + PASID it means there are 4 domains (thus 4 page tables) under
> > this IOASID thus every dma map operation must be replicated in all
> > 4 domains which is really unnecessary. Having the domain created
> > with ioasid and allow a device attaching to multiple domains is much
> > cleaner for the upper-layer drivers to work with iommu interface.
>=20
> Eh? That sounds messed up.
>=20
> The IOASID is the page table. If you have one IOASID and you attach it
> to 4 IOMMU routings (be it pasid, rid, whatever) then there should
> only ever by one page table.
>=20
> The iommu driver should just point the iommu HW at the shared page
> table for each of the 4 routes and be done with it. At worst it has to
> replicate invalidates, but that is very HW dependent.
>=20
> Domain is just a half-completed-ioasid concept. It is today not
> flexible enough to be a true IOASID, but it still does hold the io
> page table.
>=20
> Basically your data structure is an IOASID. It holds a single HW
> specific page table. The IOASID has a list of RID and (RID,PASID) that
> are authorized to use it. The IOMMU HW is programed to match the
> RID/(RID,PASID) list and search the single page table. When the page
> table is changed the IOMMU is told to dump caches, however that works.
>=20
> When a device driver wants to use an IOASID it tells the iommu to
> setup the route, either RID or (RID,PASID). Setting the route causes
> the IOMMU driver to update the HW.
>=20
> The struct device has enough context to provide the RID and the IOMMU
> driver connection when operating on the IOASID.
>=20

Well, I see what you meant now. Basically you want to make IOASID=20
as the first-class object in the entire iommu stack, replacing what=20
iommu domain fulfill todays. Our original proposal was still based on=20
domain-centric philosophy thus containing IOASID and its routing info=20
only in the uAPI layer of /dev/ioasid and then connecting to domains.

As this touches the core concept of the iommu layer, we'd really like=20
to also hear from Jeorg. It's a huge work.

btw are you OK with our ongoing uAPI proposal still based on domain
flavor for now? the uAPI semantics should be generic regardless of=20
how underlying iommu interfaces are designed. At least separate
uAPI discussion from iommu ops re-design.

Thanks
Kevin
