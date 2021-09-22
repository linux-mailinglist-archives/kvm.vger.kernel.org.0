Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E98A8413EF3
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhIVB0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:26:49 -0400
Received: from mga06.intel.com ([134.134.136.31]:13281 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhIVB0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:26:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="284507920"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="284507920"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 18:25:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="474337288"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga007.fm.intel.com with ESMTP; 21 Sep 2021 18:25:00 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:24:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 18:24:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 18:24:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlToUBPTc72qB6rG2OqdLP7o3xDwxlIF1fSGxCb4zxCws+MF9BLvAcx/NhPTXPpqCaTeVvRBbhfrnXotMztMdC4opFTHhzW68vRis1MSPprVtcKPQKb21HUrAMwSM+7nprtB0xtL8BSF/tw3Ok9czdUd/aS1TrXM6aiLiBD9jW51dSHf4zeix7omD6RPZwjg0/uY1LFoYPPSRY+vZGersIObJtjMMhAOw4r3F/vUotBAjYOdf/XYMUme4hJLrN9wx8vk4kIgl2geqotSPq//i8V92dKNqzpeu5tqSrujOJkDYiKVQsQy3Y14kgEamDkPBy1kYEgX0tPj3wskhDi98Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=y2KvK4SJntq9vhUXH64zn66Dp6865XlcU6lnVEECIL4=;
 b=K2K1tBs0v2ao2ijQ4EQeHn8VeJ3qb/6YgU5CkFGZb5a2PDBsM6BSsHmC3bz9WKJj/fWTdqarFMsMxqN4EsnQreBEiE7A2J3fH7OX/o4UZUd+ZPAADo1V/Ad2v5M+kWgKttLTfoIKkjSJdoQXlDAQL3RZwIKwECTIhpQQa+ZUAmOx/Ww4liqnOuZJT7/s8ErFMD6GM9SHy9m6HzY5V3JCQ9z90qAz3gvi6XrMdrnxqSXeW8uUNPDM3uKmJIFkC36FCsz3I17WKNE4wzxsvbS1UF6zCaB17WCpCL6ADLRofCFEr3ZE6Zn2ivKqz6rKsc6ayjtWFHKxzS4Wy2cCeWlXPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2KvK4SJntq9vhUXH64zn66Dp6865XlcU6lnVEECIL4=;
 b=JKtGI3sLUbMvDybfiy5mSbeHYfUtcoAanAcYWshvb8Zs7NYIbEfJIbyDtceChqK50HN4Uv6IHijoiAiAPN1nhVj2cDoBzFpExQDWMpEUglv15Ik9GniZjtP1uXQVRT3SCjI43ZdXaaegwEbdaepGeRtuinvnJCBdg7TBhko52DY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1329.namprd11.prod.outlook.com (2603:10b6:404:47::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 01:24:57 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 01:24:57 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
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
Thread-Index: AQHXrSF8PdwE3l0WRkaTif5FzzsyqKuutGGAgABLSoCAAA3FAIAAOBXg
Date:   Wed, 22 Sep 2021 01:24:57 +0000
Message-ID: <BN9PR11MB5433929A6B9F8A2E35612D6F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-6-yi.l.liu@intel.com>
 <20210921164001.GR327412@nvidia.com>
 <20210921150929.5977702c.alex.williamson@redhat.com>
 <20210921215846.GB327412@nvidia.com>
In-Reply-To: <20210921215846.GB327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf2872c2-2d9e-4dbe-be75-08d97d67c9fd
x-ms-traffictypediagnostic: BN6PR11MB1329:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB132955D88CC109D37BB4BEC18CA29@BN6PR11MB1329.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: byK3qEV4fRSm6L85BZwQLRViXMAybwnk/KzCgT7sGSzyZ/dd/pJwdijDDSpN3kMheiAHqHcBHjDkQh/iB+xdSC2wOYBFcAwocfc9s99Nml4KdBmkiBRTxntQJd5s1UwcpLDU5ayi8eb/oxDOx0eamWWyelw1y0E8kKRPlfwo+nr65V2j866ax4zQNb3598xSSLvzqAoTV1an/1h+GzWBsiezB5t3DxQ7bvyRr+YPIYUf79vy3svDDVtFAYBFg5kC9UUnrwYhAUy60thPkIjcvgkrFQHGVG+2PeuZAkqaL5RHqJkTu8gkgcqzfs7sIBhnqJesig03EsnGN7nFpjLHkTjFuZSqKkCRiylalSMw+IIDCPdjBqbcGfonclm/nDK0WPefcGwDuss20yVW4sPc9gS0FixN6NlC8ihJha3PzlkGE4LQbwq+4u/tTBh4fi7D61qGJQYBEmmQQgFvShFuHOUuRXuqpv95oPdfqaF/AF+n9T8XBkf1I1OnurUWXF1VJYQuUxBAH/DFEFN+kvUocMbtj7O8Uyz+PuYj8Qpf6pEIhe3nHxYdwyZDR/B6hlyIVqe2J6IhlasKN3knUdalP2ZPcYdmTZan0iYLNk0hG+Q+0FgGHGgmwG7QFM153uAb9wPLw1vOuN7SH/uYaKwE/smiNfTHWXgqkmf3hU0cNQp1xm+N4v68YOogphJS81AaxrGRab39P4q0Ca9lDsCeMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(26005)(54906003)(66946007)(66446008)(2906002)(55016002)(52536014)(110136005)(7696005)(186003)(316002)(76116006)(83380400001)(66556008)(8676002)(86362001)(6506007)(508600001)(38100700002)(38070700005)(122000001)(5660300002)(71200400001)(9686003)(64756008)(8936002)(7416002)(66476007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FgI6fktnT40Zy1RKqZS7Np2pXh442kMyMtm5BHImxqOagjIOB80dLFtAIJ0t?=
 =?us-ascii?Q?mqbiuBXYIYaMW4CJgM0ujL+4pNQeq2RZQwnuj4v85YS6IK4Yw1B86uHNpgSX?=
 =?us-ascii?Q?+KgZjMzd2nRYwBkPvzkaruRMlSmtyJft8CBUERNdqZcS/M+hNNTuvAUymceJ?=
 =?us-ascii?Q?JO0TwQbFpdLeA3ozW9IExPSeuG5NIEKdP4OLDdBZLeqDbc5ELQbmZjJfiFVY?=
 =?us-ascii?Q?IJsM8LTfd5O1v1gUjqCnM3geU+fGlSjOxmE+prIaDIbjUPL0jOzxKBi5KOUg?=
 =?us-ascii?Q?LdezFw9n6RFAt/LdInVbkGMEg4LItM16JHyOAM4EUtc8Iv78CJ3qFfTntLN4?=
 =?us-ascii?Q?fN3elqMabschdyZkMezDmzlSsE3HK72+5dfesU2bzf8KoLItBj4GJSJtRaUB?=
 =?us-ascii?Q?pJ/EFuFo0tNgN23X5tsvaeTMnrRrmMxCRt6icL59ouIA2KE3lj5obHbuZpzl?=
 =?us-ascii?Q?lIFA8l1XRgekEJlQxwE1f5pOV5/7fwZLjCXwZFoQ+FC7oouzjd84/zkUiTBx?=
 =?us-ascii?Q?Y+bG+OGBOxIIvCo9D4kiCkHI5eVBfKReXBUbAFW7xK5E50tJpn559hJj1z+S?=
 =?us-ascii?Q?1gCQ6RpZChTd/mf0OurlUypMx5k9x8yfO9uTH59LRPU5M4t/gZuHSwMpqYrI?=
 =?us-ascii?Q?vajPm8fbmFgQpI/HDB4oaxBXYyu9etFHc/pW6KMYKYDNCPAJBx28qThplAP2?=
 =?us-ascii?Q?QRTGLeWI2RQDJul+rdHcOkBurow/TI/xAu0D/RtTeMgGpVaQUDnQjo5uFu49?=
 =?us-ascii?Q?Q/o1h8esHfHUbqSJZd/WWZ3AVBN/ta1XGXYe4VzAfwCVMpVriy+0zYngKZFG?=
 =?us-ascii?Q?3a69nKtWrX+LejBrWnuueITpoXBDqsIKFi8TRkoGsdpXmm77roW1IMO7JwjO?=
 =?us-ascii?Q?qAqgBBNDegATLdTbwRUhYkzIwbLXBO0jUgq6Q/KueEejeEuspWk0teWT85tl?=
 =?us-ascii?Q?Mh4KKzVhY6WNCQMZOYB0OTuZJgOffUSHH8MSzAzY2DG7oCxERQi7Qy2STwba?=
 =?us-ascii?Q?wMLsSubvClKD9FqKLKTCIDzwaUD+ppKnv4FvDubAalg5bqNscwxyxJOS+DO5?=
 =?us-ascii?Q?9YCRtCuFRrwmDTooy/F0oT0Z6CgJs7NjyJhGJ2eKkXj1KeOPvMx183dC3+EZ?=
 =?us-ascii?Q?Gtkm2DGqptzS4FeXOBwzJ0ecz0kmQxg59XIz0lrWDvS+/EAU8YWYl+XaNQPK?=
 =?us-ascii?Q?uBGhSiYolOHSDOYTRKb28oEuJ0RcH/luraWknBhl+aT+tHbd03PZkYLNh8Iy?=
 =?us-ascii?Q?s88Yuo3a4yqNwYNKw/vsR8a0rIyStejhTVG+plgtfEFGVKWCx3XfSLEM5VSg?=
 =?us-ascii?Q?07O1X3tHoTXjY21uYk2/TKad?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2872c2-2d9e-4dbe-be75-08d97d67c9fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 01:24:57.2090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VNh6xgPMIS26cgBysgBYDejwdmf1u7qW8/9PVTOd0Jdn9cEkEpQLDg8JKoR5yRFPPfyKimc4VzAfo+eZQZrvrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1329
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 5:59 AM
>=20
> On Tue, Sep 21, 2021 at 03:09:29PM -0600, Alex Williamson wrote:
>=20
> > the iommufd uAPI at all.  Isn't part of that work to understand how KVM
> > will be told about non-coherent devices rather than "meh, skip it in th=
e
> > kernel"?  Also let's not forget that vfio is not only for KVM.
>=20
> vfio is not only for KVM, but AFIACT the wbinv stuff is only for
> KVM... But yes, I agree this should be sorted out at this stage

If such devices are even not exposed in the new hierarchy at this stage,
suppose sorting it out later should be fine?

>=20
> > > > When the device is opened via /dev/vfio/devices, vfio-pci should
> prevent
> > > > the user from accessing the assigned device because the device is s=
till
> > > > attached to the default domain which may allow user-initiated DMAs =
to
> > > > touch arbitrary place. The user access must be blocked until the de=
vice
> > > > is later bound to an iommufd (see patch 08). The binding acts as th=
e
> > > > contract for putting the device in a security context which ensures=
 user-
> > > > initiated DMAs via this device cannot harm the rest of the system.
> > > >
> > > > This patch introduces a vdev->block_access flag for this purpose. I=
t's set
> > > > when the device is opened via /dev/vfio/devices and cleared after
> binding
> > > > to iommufd succeeds. mmap and r/w handlers check this flag to decid=
e
> whether
> > > > user access should be blocked or not.
> > >
> > > This should not be in vfio_pci.
> > >
> > > AFAIK there is no condition where a vfio driver can work without bein=
g
> > > connected to some kind of iommu back end, so the core code should
> > > handle this interlock globally. A vfio driver's ops should not be
> > > callable until the iommu is connected.
> > >
> > > The only vfio_pci patch in this series should be adding a new callbac=
k
> > > op to take in an iommufd and register the pci_device as a iommufd
> > > device.
> >
> > Couldn't the same argument be made that registering a $bus device as an
> > iommufd device is a common interface that shouldn't be the
> > responsibility of the vfio device driver?
>=20
> The driver needs enough involvment to signal what kind of IOMMU
> connection it wants, eg attaching to a physical device will use the
> iofd_attach_device() path, but attaching to a SW page table should use
> a different API call. PASID should also be different.

Exactly

>=20
> Possibly a good arrangement is to have the core provide some generic
> ioctl ops functions 'vfio_all_device_iommufd_bind' that everything
> except mdev drivers can use so the code is all duplicated.

Could this be an future enhancement when we have multiple device
types supporting iommufd?

>=20
> > non-group device anything more than a reservation of that device if
> > access is withheld until iommu isolation?  I also don't really want to
> > predict how ioctls might evolve to guess whether only blocking .read,
> > .write, and .mmap callbacks are sufficient.  Thanks,
>=20
> This is why I said the entire fops should be blocked in a dummy fops
> so the core code the vfio_device FD parked and userspace unable to
> access the ops until device attachment and thus IOMMU ioslation is
> completed.
>=20
> Simple and easy to reason about, a parked FD is very similar to a
> closed FD.
>=20

This rationale makes sense. Just the open how to handle exclusive
open between group and nongroup interfaces still needs some
more clarification here, especially about what a parked FD means
for the group interface (where parking is unnecessary since the=20
security context is already established before the device is opened)

Thanks
Kevin
