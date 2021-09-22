Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92F8413EEE
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhIVBUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:20:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:31478 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhIVBUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:20:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="220299336"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="220299336"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 18:19:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="533518961"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 21 Sep 2021 18:19:10 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:19:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:19:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 18:19:10 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 18:19:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OF5DIvsgafmhk2hYuBo2oSRc/oo1bHaHpaJ6gZTGgRjmU9rdB0e7Cs2cYjKSZ9ISHgZn2TCvlz+JkzjlaGVCNQrTyNQofdbRwW67blzKGzL4yvki4J71RTzywg5w28QAJUUE3AjOTAvuGiRFO/SgwCPvjamJoVQVPgTBJkrykALTy0r+rW+eu6nT6VQxMIILNbmPnXr2Jnd+VO016Wxdm4bua2gmY6u6+9VJJXkvMpSGFeq4dhfAiI6sQ/c/XuDBFL8SKPSKvk28k4bwbPtcsQUkZALjtAogO4leYabV4LimYCIo9wDeah2z//rRucYTbnkcIz0el8gJqwDdGXQRcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sQ4ZG/amrHNG4QudsOrGUgaXtgBpR8JjwBve7yL5Xl4=;
 b=ZaT189IeHOtf20bV97f3kzBrAgTwBBdczIYccLaVEgK4Os8qDvIwHcS1e/v++fBDI8JLZ7+saaB0I0kRc2IZ8a5O8Lo1gycJkg0VUt0WslXg/lBDuzW7Js5xshgX7dxLQmSNuPfL8o92MCdabHycrTRqxafrD4m+YC48OS1CIrH2qCw/aJyefzBJKwvSreU7drvjfPjT2z5ud2m0Rklgorsvgh+aliTjHYwmZTvH5/PGS056BLy4/fODbUCbfq0YnOgmVWREXenRsihdvAwfbboUuAjBC+fqrbDoPI5Csq+7LgI+7CC3vbBMYd14wJmnNDab2UDUx6QuZ58NKtNQzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQ4ZG/amrHNG4QudsOrGUgaXtgBpR8JjwBve7yL5Xl4=;
 b=yk4WWZ00eKApm8PkpZ8JDuJbQT+jkt3DAoAXzV+U1iHkJ967bMyTCjoV4/A1KJ2rRALnPpvwhjF8rGHEESXx53Q7KMBVpunEmmxlyc1sz9grdifRxgxyP2ThmkEWctcQn1iLVMt2gEDYxd8Pghyqrdb6sCLw67WrUa7PRjMUF90=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2339.namprd11.prod.outlook.com (2603:10b6:404:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 01:19:08 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 01:19:08 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [RFC 05/20] vfio/pci: Register device to /dev/vfio/devices
Thread-Topic: [RFC 05/20] vfio/pci: Register device to /dev/vfio/devices
Thread-Index: AQHXrSF8PdwE3l0WRkaTif5FzzsyqKuutGGAgABLSoCAAENA4A==
Date:   Wed, 22 Sep 2021 01:19:08 +0000
Message-ID: <BN9PR11MB5433D909662D484EFE9C82E28CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
        <20210919063848.1476776-6-yi.l.liu@intel.com>
        <20210921164001.GR327412@nvidia.com>
 <20210921150929.5977702c.alex.williamson@redhat.com>
In-Reply-To: <20210921150929.5977702c.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e390139b-0f86-4f16-448f-08d97d66f9fd
x-ms-traffictypediagnostic: BN6PR1101MB2339:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2339FCA2396C055CD3D714A88CA29@BN6PR1101MB2339.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ObTPsIxaoIJu0DOY9CIJilxhGUEcPZGcua5tdESB/ObFT4AJD7Gkfhrjs7QYFYMw56yPi9FdLnGReFs/HVP+TY2OTzQxbNJMqTnH445tRNhytI9Mh4uZOMnKFk1EH8rixoShu1YNrOQRlwQepFsVWtcHh0W0qF8ZYbk8MliP7ODkl4qWLXdTc8rIdpbCWkvYkF45WzZTlPAjG4zGkFKVnH5CI41MCO86Df285v88adA/+9cEC4wjPAJFg5UfODC9Ii3/lcfp9Bgq0YvxkEJKOdaOO/6FTaskgmTiMGGLykxPz7Omcb6mANc8+ngCgFmvzeDhF7EnhbtCC6K2js6lK/HhFMrmzQ723sUWRzXAuiv1rDxENvFhdNrSu7Obj2Ckv0EkkpNaVs/i69NVlfRkDb0pi4EXtCf5i6rib/emqJZF7RilPZgRPeQSsfbJ9sT3cCixpMWdJYNqccnYTUDn2tKOWXNFxQRUWh5bvcFpVG+BGlIgdIQU3LEIOvqm7yU2nNReC7WubkTG/3Dm1J+3hBJ9tp50UDNesK2uDhdIlUjLWT/dhnBrsXDXegKaeXT7rqajkKwEbf0rAdepMdP5KBpvHfvRy19c+Cpr2HLD2EP64DK/7NY1cWlBcwzcyrCVDgWgwsTWehD7xuSo6RQVpwYwgHHH2VKFUzAeUzlV/ogbI2hLaP4aTg2kR/Fon3aN8svEZicNmP31/YnXO/6Qlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(66476007)(66446008)(66556008)(38100700002)(4326008)(86362001)(55016002)(64756008)(52536014)(110136005)(5660300002)(2906002)(9686003)(316002)(71200400001)(54906003)(76116006)(38070700005)(8676002)(33656002)(66946007)(122000001)(7696005)(83380400001)(7416002)(186003)(26005)(8936002)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JbSlH8V1xkMnkd2Uh+BLFGaVeGjU3gySoPoRFQsdAlb0e2feDDJYzhxVp9/M?=
 =?us-ascii?Q?ECYNMxFxWHLVLtEVxDGAniVpLZurcd+lAGLXyksIoQmpgVksM++jztysWVvO?=
 =?us-ascii?Q?yxY3HgUhCinrtbed3uECged5IH+SnGG1h8+e3zGbNXLmsSx+wuCOOmpnp+VH?=
 =?us-ascii?Q?BXAQqxqTiKyeZ/2bbjFy7zNRz/hiSJ9fzCZFVb5x4Pq0WkQagGZWV/3XZ1eb?=
 =?us-ascii?Q?aBACppupkxeWr1iPCFlmGPAPTCNtFTT4oa9yqB5O4wb5Cu72IfEWp6gH2liz?=
 =?us-ascii?Q?psafhuP9CqMolBp0BKoJyBHcP1QFzGiuA04RnOLKkyCEpTKa6/+yXEUIL6rK?=
 =?us-ascii?Q?e93Ykj85gdjOCzadj+QQumZnCmWjQKw98eciilx75sUw+s7CG5ndV7bcH3YM?=
 =?us-ascii?Q?ch+AYYCde7ii64UUojqJeZJ6rVHYDSRuR72S25JKkHKNKq4dZMsHYdtiOP/8?=
 =?us-ascii?Q?wfuUs5Pl+SrikaaDD2k7YJs+5yF+vxsDWwGpHHqIS3aY7RAylE1sTysBmJik?=
 =?us-ascii?Q?uJ5EBdfnMCgwJjvYFqJYlDIPRfs/V8Qi4KdLSV4gZwQ48jZY9NML1m4CtXUe?=
 =?us-ascii?Q?a4qi4jRy3VlBUoXwutjLttpe2+trA8dXvtI2a8ASq1d5m4O886hagBeWD9UQ?=
 =?us-ascii?Q?MtejXp4tAYspiApOJPUD4VxrijM9BCJa/dYwpaiATQtvdYIO9l/f6P7ew+5C?=
 =?us-ascii?Q?3vlpuqRmphHEVAPN27MnuDUziKQC20WgfHo3DTTLMRU4PE7+oIaz17nR8Bfv?=
 =?us-ascii?Q?P6CW/PExkbzWgVfJQWNMpPDzodVQ5nY/Ob/ADl73zOmXxovErk6W0tFKCV7Q?=
 =?us-ascii?Q?0LrPYj75Yqa4VXzsbym8EyabjlT2mfyJ2RolqGbtEj2Qa+xo2oePzLNym6LH?=
 =?us-ascii?Q?8lbWtNxK5R6BBcBZ9jBYIaV8JV4aDYqKTuD+x8jTgO4FrVNPPZaWxfPdJgSS?=
 =?us-ascii?Q?4zA+uAWmFOlcU6sByctpN0+J18M0hnLFffOvp/KSyFYjQyV7P4Ma7yBzXSgs?=
 =?us-ascii?Q?2F7sFbpHYdrS0gFctyBfO1fQ7rdel9MFwRCwQGB44rcld+WXi/Pv4e2Fk8Fh?=
 =?us-ascii?Q?rCsphUWcpqIbes9zGkbXq3AXkYGaR4R8wFBPUwAezpZy4XZ1HIQwhuOs187+?=
 =?us-ascii?Q?Yiebx6EqTH6tyU+fXabeZv6NX5VmTQz0zz+uqJclJu5V0bEXhwf+qTlpCPWN?=
 =?us-ascii?Q?2728O3p/ZwVnp2yLuraMsuyhjkj74skuJpu2bJrW0hjo9qg0Jy+JTEo8Iwbs?=
 =?us-ascii?Q?5y6zd7IP85Tz0jalhT3fEXoHJl2niOsgHToPCepRVXpF8tmeEiQ2ZcrcNP7w?=
 =?us-ascii?Q?UhE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e390139b-0f86-4f16-448f-08d97d66f9fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 01:19:08.1855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+BIDJH9FQZ+p1VqZw4e9TvnHnfL75/klROHwPkeqgrvZSsJxJuSYnB/zPNwbYC5bTRUETgXhcFRhe2I7ZjSDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2339
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, September 22, 2021 5:09 AM
>=20
> On Tue, 21 Sep 2021 13:40:01 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Sun, Sep 19, 2021 at 02:38:33PM +0800, Liu Yi L wrote:
> > > This patch exposes the device-centric interface for vfio-pci devices.=
 To
> > > be compatiable with existing users, vfio-pci exposes both legacy grou=
p
> > > interface and device-centric interface.
> > >
> > > As explained in last patch, this change doesn't apply to devices whic=
h
> > > cannot be forced to snoop cache by their upstream iommu. Such devices
> > > are still expected to be opened via the legacy group interface.
>=20
> This doesn't make much sense to me.  The previous patch indicates
> there's work to be done in updating the kvm-vfio contract to understand
> DMA coherency, so you're trying to limit use cases to those where the
> IOMMU enforces coherency, but there's QEMU work to be done to support
> the iommufd uAPI at all.  Isn't part of that work to understand how KVM
> will be told about non-coherent devices rather than "meh, skip it in the
> kernel"?  Also let's not forget that vfio is not only for KVM.

The policy here is that VFIO will not expose such devices (no enforce-snoop=
)
in the new device hierarchy at all. In this case QEMU will fall back to the
group interface automatically and then rely on the existing contract to con=
nect=20
vfio and QEMU. It doesn't need to care about the whatever new contract
until such devices are exposed in the new interface.

yes, vfio is not only for KVM. But here it's more a task split based on sta=
ging
consideration. imo it's not necessary to further split task into supporting
non-snoop device for userspace driver and then for kvm.

