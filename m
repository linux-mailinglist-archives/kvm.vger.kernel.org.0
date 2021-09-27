Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6D941951E
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 15:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhI0NeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 09:34:16 -0400
Received: from mga14.intel.com ([192.55.52.115]:13253 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhI0NeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 09:34:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10119"; a="224127167"
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="224127167"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 06:32:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,326,1624345200"; 
   d="scan'208";a="520040107"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 27 Sep 2021 06:32:37 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 06:32:36 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 27 Sep 2021 06:32:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 27 Sep 2021 06:32:36 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 27 Sep 2021 06:32:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3GUNX7X6iYpeJzVA7OfRaUAe/ABfDo003Ixou7Ivv49PD4+fzd0zA6yme5VOzx8GQdpUCytHFgew3opBL/lU8pCE/U/Rluz2qM5l+nNuXe5Hkk5BNYalmr5iaK+ZwP/pgRFdaJSmgCMpTpSFEa5nJuH8yVWm2jLWpqYxRjynGd9T/xh6HvbYcRFKmT3Mjb0ks67FM70PeQU+IzS84aGlfSXU2CjhRGZR87ntohfqHVJEWMvVEp7R6fL4cv+VZpvG2ZieUahQS0kfQjryvtsni17yKuwehbmFZBror1BgbMUBvJHoyFLJNsFXEnGDjZkTu4Ehtwocxqy8HtmLXfz+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=cfGNUaFs6Kp4+RnfIrPNd2LB/bHuKrAb/yIoEMFstPs=;
 b=kwABna/oWjHRyJ1t+3CFG+5j70kOVCmTAZVsHdDF6uqA6lhuEz8b8TNDvQ2q5fvbwTyNPhvKVI/Y/7No3DMMfZC8fZLGvyePUsNH3ML+dqaacHcgl54lun6m8s6vcC0e91EKBbikC5tWIRpLgIYk85oA5I0KgBLUTVtFCOO+Ss8inckRmNMqdqF/y+rwyPXUtW4syKeE9kYfvtlHnPwTCztUS3OJ4IAvlQ+magCOCo2gtuWpbJJe4mPXx0e1trh9DViX1tooE6Mj/HaiHdc21PR6lj+B7kaX8PySJC7jLL5nN+pqdA8DlPRZjWlZDDP99NmMz8oGfJg7ELEU8mdhHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cfGNUaFs6Kp4+RnfIrPNd2LB/bHuKrAb/yIoEMFstPs=;
 b=df4ybkds/WGuiY4uhWwTcP2r84b2H5KZSaLEB3drvT685/xCbr8u/k0pEuzxocHaMNWNAx7oSdMKhLIQQNmaM6uLOimFh78Ic7wQC7Y2XpVC33ry5WAuIsz9myapduE/PS9zbgCC5dQyI3i1MYdrYHtMoE3bFErjkmpFDssi7MY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2148.namprd11.prod.outlook.com (2603:10b6:405:52::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Mon, 27 Sep
 2021 13:32:34 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 13:32:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Topic: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Thread-Index: AQHXrSF9WDj+Z+DU+UqMJ7tQK2EdmauuvK2AgACKnbCAALw6gIAHYVYAgABthQCAABACQIAABTKAgAAAdqA=
Date:   Mon, 27 Sep 2021 13:32:34 +0000
Message-ID: <BN9PR11MB543327D25DCE242919F7909A8CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <20210921170943.GS327412@nvidia.com>
 <BN9PR11MB5433DA330D4583387B59AA7F8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927115342.GW964074@nvidia.com>
 <BN9PR11MB5433502FEF11940984774F278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927130935.GZ964074@nvidia.com>
In-Reply-To: <20210927130935.GZ964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6a00164-17f5-4d4e-375b-08d981bb4394
x-ms-traffictypediagnostic: BN6PR1101MB2148:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB21486AC948CA24999B5E08648CA79@BN6PR1101MB2148.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y5t8yobHd+hmefoQwg9qTsnXX2k2D/wUUnADpgoRWr1EU/jhQ9JVsJElIMEegj8aE+7o5Nvcd0CY1QkhwrjrhaqmHVgx3ewvy4trgT9OSjcFvGM6S1aHMq82Ru3hhQdnHqFMztnCZ5f7Py4pd+HeE/JyuKzMCtIq9WQGyjA+AmKhFBgD1cr+OBSRzQrKc43Ez7qRyhNzl3xg10pwF8157CL7qEXSe6OVImQf6eP7LHwqoIS1s7gthudbEfs3qEGZgIFoiU2vGkWnr8u+LfKKk5lZEE5iUtzb0OQ7N/ERdqykE3m20rWD8BU2SMAx9VTtUZ6DzdSwUwdaqETPPNVMAXcPOR/ctHZ3ERFbQiaipV2E3mjwXuyUqIfNHFZrqwiWQ/kIocP/uv8zYXK9zX+xEMORCd+NWYs29VO1MC7owOtq/UWijNPc5/S6JBfmlgr5aH/XUyK/J64K213UOa8rMnLmRojqqz86YGjJVjps5KuF1jfafFbcTi8yyCykiZmpnABBWSvtAvSO13Uwa5EL7LvSd6o8tlrEeX6JZ99cxeTNxtgJxFMQXkWzSRVsMCnfEtTpRTScs24zhz1V9bZYyINDIKlxmZ5v3zkMmImdkjxSf9Q72MqgCLVUIjgy3NEdJkUZoXghFEfvQFTqqUO9jHQTolvzAzh/G3bis9L5lRIe2hhstSDeX7iqfNDTljevgC9ey+fy1ugyclqjfZOgrrLUyGUKoCSxmi+yFkCd9M4MpjbV6wnFt98/GIUkYxeUVlSwfI5DbzK0m3spwn9gSswB0+7SUbfMxgZejQqT65KZZmbDdwmHNUz2T/zKbYq7z2hu4r1YBiBGu3u8gAneHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(38070700005)(6916009)(52536014)(966005)(8676002)(33656002)(83380400001)(86362001)(9686003)(508600001)(4326008)(8936002)(38100700002)(71200400001)(66946007)(7416002)(122000001)(2906002)(186003)(55016002)(316002)(5660300002)(54906003)(64756008)(66556008)(66476007)(66446008)(26005)(76116006)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7x/ugAdGWWctv4j/dOWSqpSHMl7f0fRzZ8LwdScvZe4daRZ8qxWXF8YOuAPa?=
 =?us-ascii?Q?rPX9jzeOCzoHq56PSWVrui0Erm/d5mV//p1+btHhEKhVbPipo+8VCA0UfybN?=
 =?us-ascii?Q?4OfI/ErahzPM58cHGUaH2lG2qKQUOf9iH6vgkJRynxueKftiew5MECex+Mhr?=
 =?us-ascii?Q?PATBZ/PYNt11iBBhegOmqBWYq8lL1V1X6rFiKhEIV4tEXWBf+3d47FMyamvb?=
 =?us-ascii?Q?6J9brnb8aD67Sb3zWbnHI+WH9olb+9Bl38Z/YGJaJSa3iGb6tyXxEh91//Qe?=
 =?us-ascii?Q?cX375BF8c+TB05WHy9vAtqq1a9At2iz+LuXu4koT8ZQg+gmGvVoT6RBDAl1L?=
 =?us-ascii?Q?2BCFh2V4MpgWOEoZEhHpceY3vtz4jcu2LrBi3Vor12Qkl+yZ9GjOTnhnFKwI?=
 =?us-ascii?Q?KZmwpvMCkiU5Ptob4DCl1xyA8+Ap25crzPYG6onyfh/wOFMuqKBbTlBOROWV?=
 =?us-ascii?Q?LX2G8keaDuKCmthLTSmPLllDMr0y8VnKClkkA/7aw9+KKroOL9dNmf2nj6hk?=
 =?us-ascii?Q?+o+E2iWwlsB4gHWhxqLSAD2UcnvDMto3XrbcDZsm1PpVbSQBz3TJhZ7aETzQ?=
 =?us-ascii?Q?Cr0vr2LuRfdZsXkVkt9rjZdoXRz2oBU8kknzZQMqik6v7sK81fyVbLYlX+g2?=
 =?us-ascii?Q?qXO73QT8oI8klbnBbz5S1j9YXvzVGM/yvw7Qa27sRtwCwK09dCiQGc1zD/+1?=
 =?us-ascii?Q?T9Mg7POwG3Eiw5D2nVv7KaEpS9hFw1s1aESeXMO4cz5PyzWFKF2xhTbF8fpK?=
 =?us-ascii?Q?i+8xHKUVBOJofl6aVvtHaC3L3wfm3TvcAHwirSxYqNQB+xO9tqCq1QVVWLvW?=
 =?us-ascii?Q?k6bXApXKzDOe8kgjiOYGwmNPNOl39+vL+eNvFaO5G5dGY7qqn8Hw6jdc0lOM?=
 =?us-ascii?Q?jqLN1K+BnaWt9mnn5ruf1w5nEI/fjEbYe4rDjPT4WgfZdpvD7EyQmtE+O7bi?=
 =?us-ascii?Q?G5JYP8KHW2jfAq9844YQmV6VeOJg0M+Q/BW0j0UZJyqRvjZe+xrU3R0PQnXB?=
 =?us-ascii?Q?R1dBUqhrkyfq8E6wMnVdjzss/J4Zhb3W+xrThzUmy3m++gqKS1DrWgAucByn?=
 =?us-ascii?Q?ghFG/ZUDHBRQ6UaDuLIgtV+tvvr96SVyAThodu8q5j11q9Q5xlJtYb90MFrW?=
 =?us-ascii?Q?ciWFouFyi5RHgdk/XjdWxELNoS+Uk0ezRftpvHPtzVbtk7a0dnQKu8ocUi5A?=
 =?us-ascii?Q?SASJSWYeNt5K+IopjPHMa91rQKUIc/MD8M9J8qd9U3eaQBEZxDQ2dPZ/JjHm?=
 =?us-ascii?Q?7NI5OQMfOxPZy4yzh3hSb/NVSLaWnBE0y0NKN9QK1EfOwQKAOQK1Ci+Yt+3V?=
 =?us-ascii?Q?yuceAuiAcPs1e2OnOowfFOwt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a00164-17f5-4d4e-375b-08d981bb4394
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 13:32:34.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K5wcpbFK5YMNzlR7sIE90eqDTHFdkFd4Dg1n/jGTo1C0DbJzZHuVSayBv4qBDj4jQLjYKsJefFdS3JyQg9BFJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2148
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Monday, September 27, 2021 9:10 PM
>=20
> On Mon, Sep 27, 2021 at 01:00:08PM +0000, Tian, Kevin wrote:
>=20
> > > I think for such a narrow usage you should not change the struct
> > > device_driver. Just have pci_stub call a function to flip back to use=
r
> > > mode.
> >
> > Here we want to ensure that kernel dma should be blocked
> > if the group is already marked for user-dma. If we just blindly
> > do it for any driver at this point (as you commented earlier):
> >
> > +       ret =3D iommu_set_kernel_ownership(dev);
> > +       if (ret)
> > +               return ret;
> >
> > how would pci-stub reach its function to indicate that it doesn't
> > do dma and flip back?
>=20
> > Do you envision a simpler policy that no driver can be bound
> > to the group if it's already set for user-dma? what about vfio-pci
> > itself?
>=20
> Yes.. I'm not sure there is a good use case to allow the stub drivers
> to load/unload while a VFIO is running. At least, not a strong enough
> one to justify a global change to the driver core..

I'm fine with not loading pci-stub. From the very 1st commit msg
looks pci-stub was introduced before vfio to prevent host driver=20
loading when doing device assignment with KVM. I'm not sure=20
whether other usages are built on pci-stub later, but in general it's=20
not good to position devices in a same group into different usages.

but I'm little worried that even vfio-pci itself cannot be bound now,
which implies that all devices in a group which are intended to be
used by the user must be bound to vfio-pci in a breath before the=20
user attempts to open any of them, i.e. late-binding and device-
hotplug is disallowed after the initial open. I'm not sure how=20
important such an usage would be, but it does cause user-tangible
semantics change.

Alex?

>=20
> > > > +static int iommu_dev_viable(struct device *dev, void *data)
> > > > +{
> > > > +	enum dma_hint hint =3D *data;
> > > > +	struct device_driver *drv =3D READ_ONCE(dev->driver);
> > >
> > > Especially since this isn't locked properly or safe.
> >
> > I have the same worry when copying from vfio. Not sure how
> > vfio gets safe with this approach...
>=20
> Fixing the locking in vfio_dev_viable is part of deleting the unbound
> list. Once it properly uses the device_lock and doesn't race with the
> driver core like this things are much better. Don't copy this stuff
> into the iommu core without fixing it.

sure. Above was just a quickly-baked sample code to match your=20
thought.

>=20
> https://github.com/jgunthorpe/linux/commit/fa6abb318ccca114da12c0b5b1
> 23c99131ace926
> https://github.com/jgunthorpe/linux/commit/45980bd90b023d1eea56df70d
> 1c395bdf4cc7cf1
>=20
> I can't remember if the above is contingent on some of the mdev
> cleanups or not.. Have to get back to it.
>=20

my home network has some problem to access above links. Will check it
tomorrow and follow the fix when working on the formal change in=20
iommu core.

Thanks
Kevin
