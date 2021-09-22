Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC73F415417
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 01:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhIVXsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 19:48:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:6302 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhIVXsU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 19:48:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="223759493"
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="223759493"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 16:46:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,315,1624345200"; 
   d="scan'208";a="435622324"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga006.jf.intel.com with ESMTP; 22 Sep 2021 16:46:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 16:46:39 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 16:46:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 16:46:38 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 16:46:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gPkvpAc+5UrZQoXSL2sLGgHow36V5D0sjGMUOkRtjcKsSMYMzatmadSo9hKGZqI2DycVCHxlUyKraYv3MOllMOAsMHzNRfOo1phkijBexlU+gFDEOCpb9XCvcfKaZqS7MtkBJoUSiS2Hn8z6/XXneueRmNgU9s93k6hZ9wTmNXzlXao0RutKeZKQMIWy80pPVjKvxPRqz6Zp+NynqRVWuMopPhvvdcV1jwUH+E9HDtEEUsc+/w031yxfHLub6E925f5IRhvjQUggJkHzwX0CWUsvgwWMX121b5J4f6bS4PeCk49ZPW9UoHqdiE6QgeLvT4DQEzxGfzfzWcluFkknGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=osmHD2jPBC1MaLmYBm+c67rk/xQNqAeagiXfqg6mmqU=;
 b=M4VIRnSbG+bT5Itu85x8UcfrwZ/fFpMpMDZRAGkXGNmmsCF4V7mR0HmC4vVuOmljSGCtR25+T1dsfejJvc2MWzVLrHFnn7FrspN/JrZGPIw1x8ukfW9ByLVn88gP8d/kMiw1UPIY6zJO9QD38jk8zxNgt9dV7rZEI4ACXYDUaDABlOhZXTJtqKbQ92472J/UqULBTUcF71KOTg6kQcBEquLHIh090hynviCC/Eeb7Kf42iJBPizBRQOCnhMf40yb/Ufr+c4l3A49LYmaFUT2KAtsYDDcWDvun/j4z0s3Fds8B5A6nSbDOAlN+FUpet9GTcT3PvRW3SvTkhNvWBB9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osmHD2jPBC1MaLmYBm+c67rk/xQNqAeagiXfqg6mmqU=;
 b=eDzYs9xHU1zjsrNsSQkRgFE8plRO0xuzwDP80cJHNY1bMq5QJKJxKWTCNSi8vGTvG6s/OiZra50V6EE5TpTto/SROd10c/ZtQGQusFdexR6g1BI8kkAMw4iZwns+qMsNNAG3bGqIbMLXCUYrNR1IPzjXXO3WE005hCMGcm4oaDo=
Received: from BL1PR11MB5429.namprd11.prod.outlook.com (2603:10b6:208:30b::13)
 by BL0PR11MB3012.namprd11.prod.outlook.com (2603:10b6:208:79::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 22 Sep
 2021 23:45:33 +0000
Received: from BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::8160:3227:5fe4:c494]) by BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::8160:3227:5fe4:c494%3]) with mapi id 15.20.4544.014; Wed, 22 Sep 2021
 23:45:33 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
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
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgAB3MFCAAB2WgIAAjDNwgAA0YACAAIKvAIAAJpDggAAEmwCAAA5k4A==
Date:   Wed, 22 Sep 2021 23:45:33 +0000
Message-ID: <BL1PR11MB5429B107D90E3CDE21139CE98CA29@BL1PR11MB5429.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-4-yi.l.liu@intel.com>
        <20210921160108.GO327412@nvidia.com>
        <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922005337.GC327412@nvidia.com>
        <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210922122252.GG327412@nvidia.com>
        <20210922141036.5cd46b2b.alex.williamson@redhat.com>
        <BN9PR11MB543366158EA87572902EFF5E8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922164506.66976218.alex.williamson@redhat.com>
In-Reply-To: <20210922164506.66976218.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23c23023-6e36-45e1-421a-08d97e231188
x-ms-traffictypediagnostic: BL0PR11MB3012:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB301276D380926A03413861CD8CA29@BL0PR11MB3012.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OAeF3lCIPUYux2NKdWe/mW/NA0bmqA5fopCI7Z0GGgrtgWcnYocT3KthZJQg30GVd6M3CMUZBVI1XTQVGwpxIZpMtKS0G2JfLlQWTdHS0XZBr/gTJrstijXqhgUr2cK7NS0oV/xf1tcDDumTbUjxVHr2lB4lM3symS6T6AZ6R0Y7/g5dTUbD6G3T/agH4NtgfzZZ4pflK4Zdn9eljmIVmCJFVCkQWiaxV4kvw5ABfLdUr1Zc9ZMow1mYl6pg3zSWPrgt/PxUrn5YNIlwt6zY37VmqjgTScUR3MtSCWb8Wpw8l9X9jdP2CqE/ahwCSp5VOeh5yQiC9tdWgEXtfG2KX66mII6NTnngS6aH9RztxbuBafWlQYbpTZi/YqedY+d9fvaGg2BpAScxfIi0024oRKV48SUKSiMbrrU8d7XtScumUajXWP4BkPmvY7rHTLaM8aoLUk6+HFstGfhNYOnPTyaUKv185FVgXg5O6/C+sLjdd80F6+scvPG8pTbWjWzcSYZZoxrCzpacrPGAeOIhnmAHjqJTe4s2H30SO3F0mQIEXna2ljHKxMI3/qwBdqA0U/LWDvyzxjjXFpJMvaLklag9TCDXESWjfa38Ixm9+2KYHiMt7pyW5cK+a4WzDZb7XE/UH9YDFfoyGD0/Xf/6NxQ+ztdyE87w8jmEj5WR2IAkj0nJkHb+HXCP0xSbc4HQUCoD8zbzpnBDZYkqf056fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6506007)(66476007)(76116006)(66556008)(64756008)(54906003)(66446008)(66946007)(55016002)(52536014)(8936002)(6916009)(8676002)(4326008)(38070700005)(2906002)(26005)(186003)(508600001)(71200400001)(38100700002)(122000001)(33656002)(5660300002)(7696005)(7416002)(83380400001)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VGgCCvw8mZ/AYOC/9QO3pv7IlGAfWbXDlYcxYTq6Bp93NhpL29Pdz8HJHlpP?=
 =?us-ascii?Q?Xb89rxSzNFnmLWgrB6IYXUjoqUgtv7Ba/+FMiqpXDxq5JYVBUGriHOBhAwvO?=
 =?us-ascii?Q?DhtFq6KPu9DLjz850MTXW1u55h/RL/FisNOj/vB+IF3JiNecdMv24hkgRaJv?=
 =?us-ascii?Q?qzXa8Jzd2MhH0OtthUNeE/8+IaB0rVaDitOzCjemZeJFXK0dCoNdu2M12/B/?=
 =?us-ascii?Q?dK9JjAnS2ZDi3WMwTaAC1cEtPynNCg067zGInx0+N6WR1l2/uQPSFIgQozjq?=
 =?us-ascii?Q?4+V8I/S9pqZJQ29yr41QBujWWU6XIOxkMEI6KlpgW9nqtn70PmlPfz9NiWUj?=
 =?us-ascii?Q?XEFvPRRd2cipAEgNZ45IxLFGQoEyzANFO8vsO8WPxMe4W3rDoWd8kiVrmvEq?=
 =?us-ascii?Q?Uy3zlHCZx/6PZgKasWm7p0xG0w75dxG605GtPS7vxEkJ6IhN5BE6buzF2GTn?=
 =?us-ascii?Q?yZcYhncv6sr/UEofrnGCRo7mL2EbuRtxJDZIYtk/99Oxy3/FBZKvsAYPxdgk?=
 =?us-ascii?Q?3BYs+Hh+rm9R2B4FBCW4kZSwpuGD/gSPj/d7NBsx/IMSTWxfipRGPZZcnaLA?=
 =?us-ascii?Q?bcNW/qjSGoxJwfrLwqBP3pD2MibBgVGTyEXIe1p5IJKzUwHKQ9ePaehwHgXH?=
 =?us-ascii?Q?wsiiWV1aRlEWa/OrmChOFBhqYaURDka4O1JHYxIbbv9+nK/cyqNfUJXlWHM0?=
 =?us-ascii?Q?03YY1Jfwe0OPuaWLH1nc5PCyIv0bk+8ZbrgOQL7XZekz4XuUKwV15scZrEjc?=
 =?us-ascii?Q?hde8g31YnhfxDzBV8szMrSDNgQmoY2RlqLN3BCdgujQEY/x1WFp4xD6v7iWx?=
 =?us-ascii?Q?CjcbZP8DzOoupy73o/TuEgDCVYHN3gL4A3AypnXKcz5+uvEhzTK8ntQgGCOf?=
 =?us-ascii?Q?o90DfbHL8QTTUdXlXk6d2JYqhJvbBgUXgvq/cxNU2Ao6+MvHKGuepS/3JZZ0?=
 =?us-ascii?Q?V2+cjqwO2MIota9N5uIZpJi3ilMzsWqfyN0Gil4mfYufdvfLZmwanEFxNE2f?=
 =?us-ascii?Q?eBAf8JzonJV0HKi1S2bDyjNkHruIsy3U+Ppnm1MUkM4aIBHv7FCLrhFBviSP?=
 =?us-ascii?Q?ixVjGQZGP4VS4ULmFWAT5uoU7xmFasGouz2cyWYvzdsRXXSolqbiQ5dYD/Vx?=
 =?us-ascii?Q?u59RO8CRAms4OfSzmRz8TnnT11HtsBCHQeD0yNJuSnWiRgqffntMkSun2kUh?=
 =?us-ascii?Q?Q4s5SMlaUM68Hdyr98MqgrdWHFyRf2CoTO/kvPkvY+EHa73I8mJfY/d3BLOd?=
 =?us-ascii?Q?98fWz9MJ2GxiRlJBkrUswCo5+hgoeihgRB4VMTT3GIsoDped7wMIeUzbxex/?=
 =?us-ascii?Q?mmca7wEprfim9f3HXMDHG0G9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23c23023-6e36-45e1-421a-08d97e231188
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 23:45:33.0224
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f3Lom9n6tc6sku1WO55nksdmshU3arLW6qihFlp0SC1J3dGb7E72CrwWpCwc3LedmauL4A5lMQ52ky8bCorkzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3012
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, September 23, 2021 6:45 AM
>=20
> On Wed, 22 Sep 2021 22:34:42 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, September 23, 2021 4:11 AM
> > >
> > > On Wed, 22 Sep 2021 09:22:52 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Wed, Sep 22, 2021 at 09:23:34AM +0000, Tian, Kevin wrote:
> > > >
> > > > > > Providing an ioctl to bind to a normal VFIO container or group =
might
> > > > > > allow a reasonable fallback in userspace..
> > > > >
> > > > > I didn't get this point though. An error in binding already allow=
s the
> > > > > user to fall back to the group path. Why do we need introduce
> another
> > > > > ioctl to explicitly bind to container via the nongroup interface?
> > > >
> > > > New userspace still needs a fallback path if it hits the 'try and
> > > > fail'. Keeping the device FD open and just using a different ioctl =
to
> > > > bind to a container/group FD, which new userspace can then obtain a=
s
> a
> > > > fallback, might be OK.
> > > >
> > > > Hard to see without going through the qemu parts, so maybe just kee=
p
> > > > it in mind
> > >
> > > If we assume that the container/group/device interface is essentially
> > > deprecated once we have iommufd, it doesn't make a lot of sense to me
> > > to tack on a container/device interface just so userspace can avoid
> > > reverting to the fully legacy interface.
> > >
> > > But why would we create vfio device interface files at all if they
> > > can't work?  I'm not really on board with creating a try-and-fail
> > > interface for a mechanism that cannot work for a given device.  The
> > > existence of the device interface should indicate that it's supported=
.
> > > Thanks,
> > >
> >
> > Now it's a try-and-fail model even for devices which support iommufd.
> > Per Jason's suggestion, a device is always opened with a parked fops
> > which supports only bind. Binding serves as the contract for handling
> > exclusive ownership on a device and switching to normal fops if
> > succeed. So the user has to try-and-fail in case multiple threads attem=
pt
> > to open a same device. Device which doesn't support iommufd is not
> > different, except binding request 100% fails (due to missing .bind_iomm=
ufd
> > in kernel driver).
>=20
> That's a rather important difference.  I don't really see how that's
> comparable to the mutually exclusive nature of the legacy vs device

I didn't get the 'comparable' part. Can you elaborate?

> interface.  We're not going to present a vfio device interface for SW
> mdevs that can't participate in iommufd, right?  Thanks,
>=20

Did you see any problem if exposing sw mdev now? Following above
explanation the try-and-fail model should still work...

btw I realized another related piece regarding to the new layout that
Jason suggested, which have sys device node include a link to the vfio
devnode:

	/sys/bus/pci/devices/DDDD:BB:DD.F/vfio/vfioX/dev

This for sure requires specific vfio driver support to get the link establi=
shed.
if we only do it for vfio-pci in the start, then for other devices which do=
n't
support iommufd there is no way for the user to identify the corresponding
vfio devnode even it's still exposed. Then try-and-fail model may not even
been reached for those devices.

Thanks
Kevin
