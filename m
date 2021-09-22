Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749DC414507
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 11:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhIVJZI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 05:25:08 -0400
Received: from mga12.intel.com ([192.55.52.136]:47753 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232258AbhIVJZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 05:25:08 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203049108"
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="203049108"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2021 02:23:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="474492100"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 22 Sep 2021 02:23:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 02:23:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 22 Sep 2021 02:23:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 22 Sep 2021 02:23:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 22 Sep 2021 02:23:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JrROQQWnTAg712eGuwr85y0NhvClGqzjup7D2OHkdUWzD1X8y21prIwvULA0r/wzGxthHncdeNTDCVX/WMJBlGx0rw6jBX9Br2D5z/1OWGb/BWsBM3w2l4GFF2hVwH+SADuStIAk+Sge4oRxEjYYQ5zd8RQjtdfVVxZC3BqaAwF48iJOn+hqjkPzSHwulnYOf9LPUFdKggteL3NU/ryo5I8aw9KUrncrUgqhckNlo3U7+OokxH9Vb3UYZhZI1QldABgpAJNlKAGomMPhQz9QO2WHQ/4EKzEIKRRfRGliUV4L+N2G0hcPhGenmEe9c1+uBR6WZwMYUh0jqL/dodExEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Pvo9xW0CC8yhO3PAbapJ/vRQTnAlsJf/VtlwXcCKazU=;
 b=hFXMJjwH0gceku662QwPFgVaWrc2UaGj4ZjAZfEDebHt+xQqxQjdy0ClpIP7HCglW14vABCny1Vl46chKZzKZqROqgGBX383uRg2lcGVynlcKCI9ptNcWSfsX63p+BO7lZbe93FveA4gVFdBMh85NHvEgIbNdkam6viPFXgLLZ6U6U0jriepJqXdRE79B3D4Unx7tSohqX9TlX4cOA/tDz5LhXRXqS99uFshHa4HkEzS2F6OuVrUE+XpetLYw0pLikn94vdpymiQe+rHsV/t12WVuAyo2e/zTVBSt7lOYCJcnqzotJLjgVopdK30hgGWKpF0M+fwfR58IapcP1sbBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pvo9xW0CC8yhO3PAbapJ/vRQTnAlsJf/VtlwXcCKazU=;
 b=JfqQrU5jQ2/IqZgOE6qtELqQl8k7UyAYQUlaxlukYmvimDZM81Kv5utajh09mfGrg6xd0M+/EXBs9/kns9gDG2lUotLXoInQFHYyLVWa7IVqyaf7gEZZOd7YKIox92m8OvAxkW57+lJ5Xw33Mn0FiGixrj6FtpiZvvhgPNpiZ5Q=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1460.namprd11.prod.outlook.com (2603:10b6:405:b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Wed, 22 Sep
 2021 09:23:34 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 09:23:34 +0000
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
Thread-Index: AQHXrSFwNP3/pIcrZ0iM9X/cSoy0lKuuqYQAgAB3MFCAAB2WgIAAjDNw
Date:   Wed, 22 Sep 2021 09:23:34 +0000
Message-ID: <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005337.GC327412@nvidia.com>
In-Reply-To: <20210922005337.GC327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98c6a88f-44b9-47bd-a6a3-08d97daaa6ae
x-ms-traffictypediagnostic: BN6PR11MB1460:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1460007AA4F281AFF983593A8CA29@BN6PR11MB1460.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2GH6UaoOfEs3CyouWvvuebjKKQhPVubSzZlf9tgxAPeyUEuzglyB76BF4MESmJ0zEtMW7XcvC7nhhiLgIRueAb3yv+N1pGfU8/mcgaIzCG4gFRPRV1CzU0oJH2xlHcjmlsZPlQR5Z32V2Zg017KaXQ4CRiH4t5DPhwMNdiO2EZwl9zEcXDTsHnz/xudNug2tABbNl8g4cygRDwdkHMnTXXU6vNOsnOIqmEgsUK+raRNLYvKvEvzJW5ySpl0QdvcCrERtYhDqcH+2GbF9/YM4uk0iSdz+pOVolDuGYU9zB55bZ1CFLzTZKivD2AOHlaWXceqZIqPNBpam9o2x4WnX2xCUuFux35MhRgIRFLABRYccfcMI1EX1M9Hj5gaTmDkThd/H+MQE/Bxhzor8kjEAr3n13oCgyR8qxZEy8BSNLq6+ZrFQHMrsCCZ2enKOHM3n7rCiD0QIXpZoJEDrUFCbDyPQ4vdGRkPQouLY5uM41K7evXR9aQ6YHFpP9HCOjVkyckojuUhSt8WsdduWic1h5TMSxRilIDg5V8Eu/2dnUym22pE3wggOTBL44lg2/KwhqvfT9P5AC9Y+pfPqwo2RFUEtnG5VpT7GWMb3/lGlSgPxsAkt3FQyeWIdcv8F247cGcMDZtYnieFODkyOvZ5BnakFRszURR3wKzptOqme68ZWhYmduFwvW/yJSpPTDQxBf0x90/pR+oa5q1r3rJ9EJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(55016002)(6916009)(8936002)(7416002)(38070700005)(122000001)(4326008)(64756008)(66446008)(8676002)(66946007)(66476007)(6506007)(33656002)(508600001)(76116006)(316002)(86362001)(54906003)(2906002)(38100700002)(5660300002)(71200400001)(7696005)(186003)(52536014)(66556008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?90/+I7q8lQBjcU3I3AsYWDgTlWP5HO8+upMhpMI6UmASHvpIVbHgnyMZNsIs?=
 =?us-ascii?Q?yjfUwKi5rBV4HSodYho0Lb/bcqTB94TvUlpsKKCtm/Nl9o6PbNuGZLgiTHFN?=
 =?us-ascii?Q?lVdvBZ00p/pIRhEkcndb5IlbTA3r7O6iyxT3uVJh7jZUlbnsOqEfxpt3WT9q?=
 =?us-ascii?Q?VzA+NSoEBAGpHIviircLj65VkONHYNTIRIHzrerSrnU4QNlTGgFm0x27+Yty?=
 =?us-ascii?Q?l8fh5HB0MG4D5p9ak1RHM+qqztWXfMYNsVUzHrCUzecS6XtWMZGHK2bfEvO+?=
 =?us-ascii?Q?Vyn7Q5Xs7StT7hFuqMATGCwguZzom5LcDUdeIgjhopoxept1DbLjFppBf1gg?=
 =?us-ascii?Q?TtInmEDgo+fIDdXjHGUZF+MrvJupwnNG99igfzPJrCleRcsg2gUzatsHlPh7?=
 =?us-ascii?Q?GjOdhwf8jIC3pK+3Nrnzjd1XLB3ZFxbJL+qzKSyZaTsa15Y1/R7c16B7JelZ?=
 =?us-ascii?Q?98ugkaBm6TcIMlLFxYyyerlpZ42adINM17MgkufzurZIQeKURRr7wQx1PbHy?=
 =?us-ascii?Q?kFSJdgBnmAwHFXGIqBiMIByG71gLtLbrwpEWV7Je+BAto+J2lSSlhJCvR2C2?=
 =?us-ascii?Q?PfDJhnTa8LXsxGg9TXThA0UfUc1zx9ZK69xTtO2qe6kwS3WMILMqsBX/nHeA?=
 =?us-ascii?Q?y53HJDp+4QPdr78UoOqQ5zvdFhdsjx1N+o/Uk9IpOq0MAFMaodIEm68xFgwO?=
 =?us-ascii?Q?CcwZM8+v14S78GuBYAlN3MfUwNVHL7smm1SLnO+HBgdfh6egw25ItkukUfYb?=
 =?us-ascii?Q?LENFmtea6VQBCeafE7VlOcqmuQ8HE0MDJu6l8T123AInawsRag2jqh3Ua+T1?=
 =?us-ascii?Q?5twZjOZXMD5kGddIjxMTJ/3PBD6oHg9qOahiCx1Fa6maKt8jCYR/a97V1h07?=
 =?us-ascii?Q?4MnQDS5zEGUcoDmCV94+hL1JyN18PUWZDYrL5IODGNf/AfZzfh4XR6JFOmMI?=
 =?us-ascii?Q?Nqrw2rXbsQz0SuvZrQDXnx9D20PYxctDoQssoFtpC2lTmHZ9WaFUskotbtP+?=
 =?us-ascii?Q?6xNaWwNF2m61VU/PxAbJ1PilzIR5A90k7LSSf5p9sHKJtaW2Fkq3taqC3KF5?=
 =?us-ascii?Q?Wq+80GksfM2ovY4hzZzQfSfnGCVyP/OxD+muXb7rGeRvqsc22xq1s7OAmDvH?=
 =?us-ascii?Q?9Ri4ByNuiUO+gaATFFAle/vjPmU61IfXWAV+Yl5k1pl70fkFu4CNRVoFreFr?=
 =?us-ascii?Q?H24XtLPavAjzyv+yy0aPGv2aLlTGl5b4QH9+SXCZ86YbnoQgdCyuB2dvRtrs?=
 =?us-ascii?Q?Uphjlo2/YN0Q/G+UtkdG5V9id8gMzmjEU8IYsnisyCK+N6JBjc8s5nMMnWc3?=
 =?us-ascii?Q?QKwahC8M9yxvIEMqHf1oToSf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c6a88f-44b9-47bd-a6a3-08d97daaa6ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 09:23:34.2334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N+5oIMEby2Mq6cQpiBvvYkDdcvUV7zQCtCDSObRpY/yfKZHgPlK/aB61dy9A5JnJ8qiiX/s0/RRN5Jsu/m8XfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1460
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:54 AM
>=20
> On Tue, Sep 21, 2021 at 11:10:15PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, September 22, 2021 12:01 AM
> > >
> > > On Sun, Sep 19, 2021 at 02:38:31PM +0800, Liu Yi L wrote:
> > > > With /dev/vfio/devices introduced, now a vfio device driver has thr=
ee
> > > > options to expose its device to userspace:
> > > >
> > > > a)  only legacy group interface, for devices which haven't been mov=
ed
> to
> > > >     iommufd (e.g. platform devices, sw mdev, etc.);
> > > >
> > > > b)  both legacy group interface and new device-centric interface, f=
or
> > > >     devices which supports iommufd but also wants to keep backward
> > > >     compatibility (e.g. pci devices in this RFC);
> > > >
> > > > c)  only new device-centric interface, for new devices which don't =
carry
> > > >     backward compatibility burden (e.g. hw mdev/subdev with pasid);
> > >
> > > We shouldn't have 'b'? Where does it come from?
> >
> > a vfio-pci device can be opened via the existing group interface. if no=
 b) it
> > means legacy vfio userspace can never use vfio-pci device any more
> > once the latter is moved to iommufd.
>=20
> Sorry, I think I ment a, which I guess you will say is SW mdev devices
>=20
> But even so, I think the way forward here is to still always expose
> the device /dev/vfio/devices/X and some devices may not allow iommufd
> usage initially.

After another thought this should work. Following your comments in
other places, we'll move the handling of BIND_IOMMUFD to vfio core
which then invoke .bind_iommufd() from the driver. For devices which
don't allow iommufd now, the callback is null thus an error is returned.

This leaves the userspace in a try-and-fail mode. It first opens the device
fd and iommufd, and then try to connect the two together. If failed then
fallback to the legacy group interface.

Then we don't need a) at all. and we can even avoid introducing new
vfio_[un]register_device() at this point. Just leverage existing=20
vfio_[un]register_group_dev() to cover b). new helpers can be introduced
later when c) is supported.

>=20
> Providing an ioctl to bind to a normal VFIO container or group might
> allow a reasonable fallback in userspace..
>=20

I didn't get this point though. An error in binding already allows the
user to fall back to the group path. Why do we need introduce another
ioctl to explicitly bind to container via the nongroup interface?=20

Thanks
Kevin
