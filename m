Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409ED413F10
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbhIVBsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:48:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:21502 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhIVBsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:48:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="223529701"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="223529701"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 18:47:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="474383004"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 Sep 2021 18:47:08 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:47:07 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:47:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 18:47:07 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 18:47:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=be0udcKCpD7V8syjT+VobvG5JBaSjZksjL0YUaN5eGQvAMugN9brzPGwnF4R0wf9QnR2+Q8i0oIyxLnd61KjgyFsPlQ4EuV1C/DkQMmjxiLyv2+gpdwLxNNRaq7zUqPfj4TjylyZUq5uvdkqu3Fhz6lUGqm7/C5URBdImAJeOsY0lZ+5rigmEEVtRV5AIhrxGpOigjVJG+CmnaoAJzXag3tIV+gMvfYOnRpg+CZ4RRVa8B6F3qvt203KtTXAq0CeLKhk0UXeEInQ2Iuv6O71LbXF4qhQ9BjVJ/+7JYt3iReOtxKApkOhe03QozyMC3+RP5APIHH5lVoz/rHNK61bgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=m4TOPmWR8lW/r/VEwSsHVBVCre0YwCYuee4w7xDVgW8=;
 b=ZVCkcjDB4ZF9/Me6K2HNbh8OKg3wW0W5Outa3zMEat8uefks42DgGKVWxBVkqVickq2wSJcWinKtjTDHHrJpyZO0F3aX6Uu6G9WN1Z3DJs5ZYfhkyt8O/VcyGVxgRzmsP3fGUfuoFTqsDkP33brMvEHT3EpwW+7f0pzuuz4fi7BWWseSN7+OtsoVwimGVlePwed+Nzdxq9iuhBJUViysu7sZ26zGeVA+MshPE4ZfcLqWrnhaMuqvL73UAvHBEPmibC+QO71oAAOiTLDfutGJrDz4xUPzZzqAL3xkl4H6yVLyypdkmY3azatfc/b5MzycgS0c4bZ4TDeSU7FGzMy7dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m4TOPmWR8lW/r/VEwSsHVBVCre0YwCYuee4w7xDVgW8=;
 b=A/Cfk21AepuzmWMxmolVeYI113AMiwFwn3ZS5/S5i1rzMNxmr1QIYNzhBXvHsAXikYEgNeusZ7SYP4XGtMcqDAw7N6UjT9p0y4uOAB/RARf/7NN8WfKyVLCKoxorNxeRPsnuVBN5w9jGNpgzXmfoUC8ohv2HPoK2D/7L8HoRPUs=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1332.namprd11.prod.outlook.com (2603:10b6:404:48::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 01:47:05 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 01:47:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
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
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbA=
Date:   Wed, 22 Sep 2021 01:47:05 +0000
Message-ID: <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
In-Reply-To: <20210921170943.GS327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b08020ef-4d3f-45f9-9dac-08d97d6ae18c
x-ms-traffictypediagnostic: BN6PR11MB1332:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB13321FA84522A82A00EBC8288CA29@BN6PR11MB1332.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xh85+bKNnrNJbcFWlplwAv4THcu2XCw1+DmLeCJQui9S/sTkdeXs0EfqxmIv5u33Vnw7Qkj5xYPDRjsZyhh29h8UANMvOBayH4Tie0kt5d2j/QArbNugw/b0OklEVjbrrzF6vGv25hez1CdIGufclKLnab4OQRH7atrGTsQa0ErTPXzWRPHrfetGfZ0DMbuVtwJ/su6kjFO2BN2o7kYybyS33gagvVaqgV5AEOCms/IsgxnBxoV3XDCIwiQHKny87+ohO8QXxWEBaDoi0TjGVs+4sdzxVlo2VKbhIghEzPKHVex0UrzFcLOSDtHaTmHq+YBXhbQd36D3tF/SiJMGC9062ZkEqzpWy2X3N6OXwc7uXB52xh4DDSW5RZKfparY02huWaG1gzcUItMHljwOUODbl/8FGWoTGKKWNShf4E3CEb9PiE/+jHNBvzYlPqOniJxLESPSFUI52E+YWFgo3yq//ETeF+z/UvRGiHycwUeiQDef9fyaAY6Jvfo390bqGN6Qbv0Y4S0/OCEU0+lTt/CH+m4DHLP9J2DOzBz36wMD7PeN+33J85phFAeNULLjHiXo0Hpe9K0QW5IhU71Xmd9R0VA1x3GkWErK5v3ZgZ7WA/S2r2FDTVC+MR5T5xKgjHuYnI63XvYcfbO5tK5tU5nGFOCdWCD8vXfa/z8QusRsHU/Ez6hZq/LWybOwJgw86rkX5EYLl2FV8UF2PMVrbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(55016002)(316002)(508600001)(8936002)(66446008)(186003)(38070700005)(76116006)(83380400001)(7416002)(7696005)(26005)(9686003)(122000001)(8676002)(33656002)(110136005)(54906003)(2906002)(4326008)(66946007)(64756008)(5660300002)(66476007)(66556008)(6506007)(52536014)(6636002)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?r4GBbGiHWWjWUu882pPvlN3jbNY4Yb11MsxEf0n2HZjPkeLyCMCdUsyAKoD2?=
 =?us-ascii?Q?hYD3mrwFeMowY9newYl6gnRPyQ1jnIoh9jHvlXqyi4HjyvPK7anvtaa3TsBn?=
 =?us-ascii?Q?C+xzU3DtSZYq8QNJJft9XSMV7siJcY53wE+yls0++lrei4nb+iwWN0Dz9LRe?=
 =?us-ascii?Q?oZ3UslhrDsoWROPwaC/Wjz/o8mc2TOvp/aVsUhfn05it/TXg118RBQPCFyFk?=
 =?us-ascii?Q?3/Wr8nUeezg6uRJbiCna2tz/dEwZCDnxXx3lS9eOPh7qrjlkF1KIdWr0jwon?=
 =?us-ascii?Q?AHR0d/3Supy/wHaU8oEuENGFeXDQzu15HDizh6x9ep4woqhAGKJrPi7/Tot8?=
 =?us-ascii?Q?EjsFkcDtD85F4O0cFFWg0JkliUB1/dSxmJpMpWpO9s8if9yayI+0wPpbQev+?=
 =?us-ascii?Q?IO+PW/lJOOIgPlzJ6QHSHJCfdPZ7Tnt2TMadQTnxsqEMCuIODZlSPcHIgvhH?=
 =?us-ascii?Q?eW3ZC/kvAZFE2isBrAViTdst2KTbItTIPVNvmw3hO9cn5yD4Yxmyckjw2VSR?=
 =?us-ascii?Q?jap+sBfsdHB6dQ4iulZZY7OIqSuO8weoJzt/xoQTyO3fIFBeYixonIP5x6f9?=
 =?us-ascii?Q?Irzh1mrn3KGfgyK+oo0PBafYzxxR3s9zP7AVwtOY7B3jy/VbzJIYGwU1uN3A?=
 =?us-ascii?Q?JYcaSiPeCp/cQXT+D1fBgl3oFp3Oj8W9ZRlIcE+q7gmKaohm8eKdNzbFiZqr?=
 =?us-ascii?Q?aA5KJSq7mEh4UmC2UHZEJDqIbX+nT1Ors5ndIHlkryf8qHXdSIyEPzmomord?=
 =?us-ascii?Q?U+18VSdhswsIJo0Wc11iA1I96xdVRQYacCklRD/V7un+NHL0n/kYkREdH7fA?=
 =?us-ascii?Q?Mn8W1xneNE2BJ/ASoNinIbtQPUNur4S8MnCjeHgp7ShKTDoYMrzGTXCXJJBZ?=
 =?us-ascii?Q?TisWbsxV+4G/BQ26/g2gh6CMWiZK9xhI+rDffp0Fs0s3a0/6hYO1PsBZdbHj?=
 =?us-ascii?Q?F2QAcMMVDDn6bsYJHLdzhBbgfZq0uMOs10RmxkN0UPtgpxoFf6aLwwJdpUhB?=
 =?us-ascii?Q?flLOJMjnmp1ZG7NGc36OM3m6kU3s4OiZ1eJUrOMM03R4jeESu0g4+8iO1c0B?=
 =?us-ascii?Q?EaxvUp5ytzEvybEqTpUKPn8kkzlZ0Rcu0KH2exKa7fG8ucrrg0FVSFZSKkAA?=
 =?us-ascii?Q?OclapYqBmPoznUTJiVhB+TOAI9pw+betH5gUKemvGCZCUNOpBfR2gE9HO73p?=
 =?us-ascii?Q?FOdnwmS+KDyG9SZAuCVNumK8kJ7cZ8dhOp3BvEdsgEOy6kI5fPLiT5de8M86?=
 =?us-ascii?Q?YCXu22atdi7UkqyFT2ewS+0YjjKiCmttj771dG9ZUAeDyVlJWOXTDijX6Q5z?=
 =?us-ascii?Q?QI/0MG5WtC1DwQyKEO/y7Iye?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08020ef-4d3f-45f9-9dac-08d97d6ae18c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 01:47:05.1485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4EU+hHHlCN5AnswMpEqHqZ9FkFcXmZDvtkF6oYEAVtHfIvBS9CakqY3OSpB1fp2WX9WxKntsZ7BF3TbFk/ZANQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1332
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 1:10 AM
>=20
> On Sun, Sep 19, 2021 at 02:38:34PM +0800, Liu Yi L wrote:
> > From: Lu Baolu <baolu.lu@linux.intel.com>
> >
> > This extends iommu core to manage security context for passthrough
> > devices. Please bear a long explanation for how we reach this design
> > instead of managing it solely in iommufd like what vfio does today.
> >
> > Devices which cannot be isolated from each other are organized into an
> > iommu group. When a device is assigned to the user space, the entire
> > group must be put in a security context so that user-initiated DMAs via
> > the assigned device cannot harm the rest of the system. No user access
> > should be granted on a device before the security context is establishe=
d
> > for the group which the device belongs to.
>=20
> > Managing the security context must meet below criteria:
> >
> > 1)  The group is viable for user-initiated DMAs. This implies that the
> >     devices in the group must be either bound to a device-passthrough
>=20
> s/a/the same/
>=20
> >     framework, or driver-less, or bound to a driver which is known safe
> >     (not do DMA).
> >
> > 2)  The security context should only allow DMA to the user's memory and
> >     devices in this group;
> >
> > 3)  After the security context is established for the group, the group
> >     viability must be continuously monitored before the user relinquish=
es
> >     all devices belonging to the group. The viability might be broken e=
.g.
> >     when a driver-less device is later bound to a driver which does DMA=
.
> >
> > 4)  The security context should not be destroyed before user access
> >     permission is withdrawn.
> >
> > Existing vfio introduces explicit container/group semantics in its uAPI
> > to meet above requirements. A single security context (iommu domain)
> > is created per container. Attaching group to container moves the entire
> > group into the associated security context, and vice versa. The user ca=
n
> > open the device only after group attach. A group can be detached only
> > after all devices in the group are closed. Group viability is monitored
> > by listening to iommu group events.
> >
> > Unlike vfio, iommufd adopts a device-centric design with all group
> > logistics hidden behind the fd. Binding a device to iommufd serves
> > as the contract to get security context established (and vice versa
> > for unbinding). One additional requirement in iommufd is to manage the
> > switch between multiple security contexts due to decoupled bind/attach:
>=20
> This should be a precursor series that actually does clean things up
> properly. There is no reason for vfio and iommufd to differ here, if
> we are implementing this logic into the iommu layer then it should be
> deleted from the VFIO layer, not left duplicated like this.

make sense

>=20
> IIRC in VFIO the container is the IOAS and when the group goes to
> create the device fd it should simply do the
> iommu_device_init_user_dma() followed immediately by a call to bind
> the container IOAS as your #3.

a slight correction.

to meet vfio semantics we could do init_user_dma() at group attach
time and then call binding to container IOAS when the device fd
is created. This is because vfio requires the group in a security context
before the device is opened.=20

>=20
> Then delete all the group viability stuff from vfio, relying on the
> iommu to do it.
>=20
> It should have full symmetry with the iommufd.

agree

>=20
> > @@ -1664,6 +1671,17 @@ static int iommu_bus_notifier(struct
> notifier_block *nb,
> >  		group_action =3D IOMMU_GROUP_NOTIFY_BIND_DRIVER;
> >  		break;
> >  	case BUS_NOTIFY_BOUND_DRIVER:
> > +		/*
> > +		 * FIXME: Alternatively the attached drivers could generically
> > +		 * indicate to the iommu layer that they are safe for keeping
> > +		 * the iommu group user viable by calling some function
> around
> > +		 * probe(). We could eliminate this gross BUG_ON() by
> denying
> > +		 * probe to non-iommu-safe driver.
> > +		 */
> > +		mutex_lock(&group->mutex);
> > +		if (group->user_dma_owner_id)
> > +			BUG_ON(!iommu_group_user_dma_viable(group));
> > +		mutex_unlock(&group->mutex);
>=20
> And the mini-series should fix this BUG_ON properly by interlocking
> with the driver core to simply refuse to bind a driver under these
> conditions instead of allowing userspace to crash the kernel.
>=20
> That alone would be justification enough to merge this work.

yes

>=20
> > +
> > +/*
> > + * IOMMU core interfaces for iommufd.
> > + */
> > +
> > +/*
> > + * FIXME: We currently simply follow vifo policy to mantain the group'=
s
> > + * viability to user. Eventually, we should avoid below hard-coded lis=
t
> > + * by letting drivers indicate to the iommu layer that they are safe f=
or
> > + * keeping the iommu group's user aviability.
> > + */
> > +static const char * const iommu_driver_allowed[] =3D {
> > +	"vfio-pci",
> > +	"pci-stub"
> > +};
>=20
> Yuk. This should be done with some callback in those drivers
> 'iomm_allow_user_dma()"
>=20
> Ie the basic flow would see the driver core doing some:

Just double confirm. Is there concern on having the driver core to
call iommu functions?=20

>=20
>  ret =3D iommu_doing_kernel_dma()
>  if (ret) do not bind
>  driver_bind
>   pci_stub_probe()
>      iommu_allow_user_dma()
>=20
> And the various functions are manipulating some atomic.
>  0 =3D nothing happening
>  1 =3D kernel DMA
>  2 =3D user DMA
>=20
> No BUG_ON.
>=20
> Jason
