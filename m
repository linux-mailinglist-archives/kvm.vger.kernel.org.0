Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843EA3F9246
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 04:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244074AbhH0CSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 22:18:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:36706 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241128AbhH0CSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 22:18:07 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="281600009"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="281600009"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 19:17:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="495463366"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 26 Aug 2021 19:17:18 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 19:17:18 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 26 Aug 2021 19:17:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 26 Aug 2021 19:17:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 26 Aug 2021 19:17:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU0TKNV4rt5ZoM+C/vvnzKJVCVHc/qc7j+eyv7CGeNS/PWbRUdbXp7ouDuqSoIWwuRgXiRX4R1do66wBZ4kbSjkDnahC8m/BKh4Icrf7hS5csQUZcfxAR3LKF6ILjvvuPa8j7tQhLJGngljS1UWTd9gAiNoVBdymDPl+lKyU0HEBr+FdWceX7MSBJzkpGhBOocRKHgd+i9rlI7eMBTeIjsHMm1MouBpvYatRz7uBeCqBXUQzH2sXchjms7MrNkvVzGpSZ+mCT8a6GMxluMZebsYfhsfTMyyLl1MGZrJIrGt+K36LgbFJpMlEhfjmChZW2KkNgXUhXZTMnzuGK206pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbUHtTXgucoI6f6HFfygBqGlTssqJw5i/QwVcwZwvpI=;
 b=ZOp0xtB43tQ8Ar85DWP7mCTNaU5r1sn1OCeiMXepVo/Y42NN+lWhCxc+wz8fVttouG4Dex1jwTNfaXZS2x5o/+VZihWHA38/duN3WtAyRYaVoBQjOztac+7Nz68bGXp9ooLBLBy6INWWdB4RdX9ExuOkxywlYZP8PFRC4XQ4EKGSUEpbnLoLX5rOYyg5zmJiE3QOTSkR2KSguL+EF2AJ7AZDXwpF1FiZbIG5BJpMU1QotiNxZV3DyACpVymCHwySYqJLPn9GCQHrxfB/MfT/XqABJRlDssEh1XYPRHTo092LkFAixvcnMgcgWL5D1oIZXyIQ8u7ru01rtSwE4t03uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbUHtTXgucoI6f6HFfygBqGlTssqJw5i/QwVcwZwvpI=;
 b=l7ansUbopWMc67aFsFF6BY47VoWTU7ODF+TQ6TgiFJEctSJTOFWNnM0r9A2zL0IRIQXQpaAv6T19CIRAGwM27fa+pxx5+5D4caSyKxFvvRRkHalQfP0aCaowmXvQo99I0ysPmFeho9IgP35h+teeE88jYplXVU3z9PgfisLtYBE=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB4097.namprd11.prod.outlook.com (2603:10b6:405:7e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.21; Fri, 27 Aug
 2021 02:17:14 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%7]) with mapi id 15.20.4457.020; Fri, 27 Aug 2021
 02:17:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>
CC:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Thread-Topic: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Thread-Index: AQHXmoBrLDW++wWbGkej4nUR7Ubf6auGZwKAgAA12oA=
Date:   Fri, 27 Aug 2021 02:17:14 +0000
Message-ID: <BN9PR11MB5433CB3FD43C0891E15E20928CC89@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-8-hch@lst.de>
 <20210826165921.3736f766.alex.williamson@redhat.com>
In-Reply-To: <20210826165921.3736f766.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d1fcbdd-a176-40eb-9a5a-08d96900c8f6
x-ms-traffictypediagnostic: BN6PR11MB4097:
x-microsoft-antispam-prvs: <BN6PR11MB4097F92D1C3818A2D7E337998CC89@BN6PR11MB4097.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9Tp+pOf4abwvs9n7sQV8p9jQMUb9pdtSQ/rTzUyj105sAo1tX9gLMVdVtC+EHrR8GVSN1adrphepyOvNxZF931xuP9E9BAlO0TeO+B9iZ/pz4ZGteiTHKwCjJTx+vMZwQDH75gzc6oS9C4iOCaX2zLABVlFS/6R3MNsPtyx53f2ZgLzjBts0VvkV4FdtX3ltHY3gOanRk+YZaKYWgT6H8+a5ftLb9f/+o7KgWBr6DvjxRt96FkelLtGA9bJrZTsJSOAtzUVOTTZqbh8xXAXI6bn4HL51p6S3PAueV+oBiUjOqI3Iua5EFbO8MVH6Wf9+cD3f8B7gpl38lQC1915/rdtVimn5WZ1sjoCbquq3yFk36Gbe1Lk8vLp3EtspfjBo163FVLE0UqyXLOo22XurpHU0mLeWQwb/5seS0fcaGvek1owL94FSIYS7wZNChQPV7nM83/wS1TjhmSmXqer/WX7Cfu5uFZUV+7RGb/AYD2pPEay1hdGSC7rZahNodxAPsWbbndp5FhfEpLU4rHlOyJegYSgvmEXY86cizNM4gxN4POhqqPflDEOyz2lDccWwcI3evjH1o1cjnwFQ/o9UyThddmwt8J+br8MnXxLei7ca+kZERKkEpdvWGRKa0uB3O/ncyKrQEVympZEt2uA6M2oj4fLxZTo2yhHVsYW3a824AutB7ea78UE1b0c+7IRbqbYZUnSrtys7P6VmWNsXTQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(122000001)(38100700002)(8936002)(2906002)(71200400001)(52536014)(33656002)(7696005)(478600001)(9686003)(8676002)(38070700005)(5660300002)(4326008)(66446008)(66556008)(186003)(66946007)(76116006)(54906003)(55016002)(83380400001)(6506007)(66476007)(26005)(64756008)(110136005)(316002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i0HO4w0XCNXsa3eFoBZvLgDo2A5ecwarCLtrD7qF+XKRqVrdTlBoWhpEB6Td?=
 =?us-ascii?Q?sVyCKvNw3xYaOLvuohzL1GLaH7528TCemHz1crm5fOno4SJoBjUPyL/VB4Z4?=
 =?us-ascii?Q?Nr+MtDHMWdeWcyMjn8kVwDW/H8AJ6sfjKeMyRpy/pvVTt6nqDOpHMNBAIy0+?=
 =?us-ascii?Q?tPDLGQPIsMSU0RCtPdguMTIdPL6YQt+eqgLHfxKZI/BwpGTc75UnMVmyLoUa?=
 =?us-ascii?Q?JHD43Rp4EK/NML0+8w0PS0rMm8l1jgHxsYsHK+PtRfOQmjjdnX8m8vieVxU2?=
 =?us-ascii?Q?B3em0vLALxud8Ii6ABC9QrhdYwvD01yJ1V8Fb093qpjKEQOiwvRNp+naWN0x?=
 =?us-ascii?Q?tOmZTwlDAHlSwNVXtE+ygeLpx+CYswlqdHY/PUQq9jK8WpxtRgX1QgPfHnHn?=
 =?us-ascii?Q?Vz9CWD4SlIdCol/5+s/UAkbKI6vA1tlEnLvIfrKbCRDjm9kAGB/dO8AU+3n9?=
 =?us-ascii?Q?qmk0kgUKCv+bQPy7xDjEcL1d4RmQu5yGgAyuLLH/qP9zyn9wXB276DXkuTAF?=
 =?us-ascii?Q?HkbqHHi8yFar6q+nOqBLk+ezzshZQlhRLQxSugQva87pS4QVu9L0A5B79DPE?=
 =?us-ascii?Q?Bh5wDgQfiUO3wHSE5/kTKCXygYIL74I2hNvxOOdPYpxlLXsuIxRZ6aR1aPpR?=
 =?us-ascii?Q?dFEqnRbj0K3Duv2JYGHxlio75kq1BnUEdgcDhZs4vOOSxT19Jdj61yoICd3I?=
 =?us-ascii?Q?qudKrwuhHKpCgemtbhwRWrUWau8IDPmmzl1yOH6uN0PoKhXYeX13Ws51nkuO?=
 =?us-ascii?Q?cA3xazOWrBt7hTsol2E8q/zJQXZAIcV7YGYKttQk/OubGZdc8U74X4SbJ9Hf?=
 =?us-ascii?Q?PZqD+wFGWkm9c90BTgQAzHnDRm8P+PhL2pFgK+LQjd/DPIyoJD1qU8heyBgw?=
 =?us-ascii?Q?bx9RyCjiIWC1SmHG/Io9lTplhEvz4uIPTRAIzkBO/CwBEQsx0RZZ4kxFfkc8?=
 =?us-ascii?Q?ca+rpI5oGNqzpmbnJ3/0PxxA2QerojeW5ohRCHHbP4as1XIT4UNid4NA2EmI?=
 =?us-ascii?Q?6CzICpVBAhDzMkjAdb3QY6kZ2b7+SmDRR/SsH9YQYIwblcxbqFZ1Tw9PjDam?=
 =?us-ascii?Q?AyMKGdr51tnJ1cDKSnHU6dAa3Aj0IkW0E9cBKh1GDSySIJz9PxJxehcvgUu3?=
 =?us-ascii?Q?S4VDXOE5B/mbsHz4R34CuFvo3L9k8lHGuAIiU11zK7z0ZDvjiOO93QEI2AhU?=
 =?us-ascii?Q?is/M8qCBVm8LBAuqS7ZyDT7U2s9p9kK/jRwMJXWqoUg1Xol4ht+FdM2bs0XE?=
 =?us-ascii?Q?q+hKr9Hj8+KxTZAJJQDUb6sfIeYbC9uI563X3j4ljdICmuAkrDj4kVgp/FDw?=
 =?us-ascii?Q?+x5pzUe1dZbN2Z34wL8eVkcy?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1fcbdd-a176-40eb-9a5a-08d96900c8f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2021 02:17:14.0255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yd8Ywj+uUd4F6G1JhZtSBEzYOAY7r8wTqcW/7Nxydnzq0BolIr2ln2owkOSaqK4CfuU4DOqrb3zXovkb/aEf4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4097
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 27, 2021 6:59 AM
>=20
> On Thu, 26 Aug 2021 15:34:17 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 94c5e18a05e0d0..467432379b91ef 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -67,6 +67,21 @@ struct vfio_unbound_dev {
> >  	struct list_head		unbound_next;
> >  };
> >
> > +/*
> > + * Virtual device without IOMMU backing. The VFIO core fakes up an
> iommu_group
> > + * as the iommu_group sysfs interface is part of the userspace ABI.  T=
he
> user
> > + * of these devices must not be able to directly trigger unmediated DM=
A.
> > + */
> > +#define VFIO_EMULATED_IOMMU	(1 << 0)
> > +
> > +/*
> > + * Physical device without IOMMU backing. The VFIO core fakes up an
> iommu_group
> > + * as the iommu_group sysfs interface is part of the userspace ABI.  U=
sers
> can
> > + * trigger unmediated DMA by the device, usage is highly dangerous,
> requires
> > + * an explicit opt-in and will taint the kernel.
> > + */
> > +#define VFIO_NO_IOMMU		(1 << 1)
> > +
> >  struct vfio_group {
> >  	struct kref			kref;
> >  	int				minor;
> > @@ -83,7 +98,7 @@ struct vfio_group {
> >  	struct mutex			unbound_lock;
> >  	atomic_t			opened;
> >  	wait_queue_head_t		container_q;
> > -	bool				noiommu;
> > +	unsigned int			flags;
>=20
> flags suggests to me a bit field, but we can't have EMULATED|NOIOMMU.
> Should this be an enum iommu_type?
>=20

and I wonder whether we should also define a type (VFIO_IOMMU)
for the remaining groups which are backed by IOMMU. This can be
set implicitly when the caller doesn't specify a specific type when
creating the group. It's not checked in any place now, but it might
be helpful for readability and diagnostic purpose? or change the
name to noiommu_flags then no confusion on its scope...

Thanks
Kevin
