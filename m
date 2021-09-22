Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F11B413FF9
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 05:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhIVDYW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 23:24:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:18649 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230054AbhIVDYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 23:24:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="210743945"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="210743945"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 20:22:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="585238209"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 21 Sep 2021 20:22:50 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 20:22:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 20:22:49 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 20:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwd07bGflKv60/1ei5zzhidscsPS+qBdxvudiiNbTC6ZYzajR9OkKsAcP2zpOjca+PQLIDKRZ8f0qzZDBIBbzAcPLdOdM6AJSwZn7MjyXCvbHnpRfXnE3Ck144sUTgbS9WZuDc9INoc8Jipm4dFbdYqkmrIXn0dFN0ARQttK6bKgBWnPnVbaiQhMbDYAwjoa1oVNdTze0vC0p8hxco1cWUi5QNee9Ahspx+UmQwFqavL8wytlV76Nw9qIy5pUuZvPbtydDBBkyBvlBxB7JVcnvM406jXImPpX7v2XPxBEp9GoCpWXYiia8fG+JZqdypT0THbVr8fRZHNKIVsGBT1mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YNlG21nkx0NHe0X52gCE9cBH5qcdnIdq6JfQkHiKIWU=;
 b=BEMjF6CWvepCvrwecFCy8HUv9uBYGpN/H8fxbfBWEk/cTyT1EfHZohcpDxGntdrEt0zX1Fi2Put5HNV05oSn4KI432EtiroI0T6BrwkjEFxg5v3CcDhuDdi2npBepqrIrHMhsLxQ4JhHWeXuiKYaWdcuGM2w3M747gpiJXUURej6hyzFYPDwWBfp2beFgVgAiCJ7Zu5K4HWWZ8Cw6VMnmsZm6pouitU3/T70lk0ougzJk5vKVT5QUxE/E55c+il/6lDcXzKOSFCMRbAVMVNCRy17JjVd2kGJnZjHYZBW0gmSs0pLKKsOHn/ebIUXR5PXkqcmLW0pPjutmlJAHaQQ0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNlG21nkx0NHe0X52gCE9cBH5qcdnIdq6JfQkHiKIWU=;
 b=H1zCtUmPVLWUZltp2zZ+EoenE9Gh8NGMnHUkoWwsmJSofZwQFORuqmcPpOEUXfqCMt8geh4Al/WEncUTjMUCVIxO9uemJmnvBYFl0kyRVi6zK3F7Z49jOH12ooVt3IX8qKhba+65EccqNtuVfWZ2C9+pchxqwdqHSvpnqzQ8dvc=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1265.namprd11.prod.outlook.com (2603:10b6:404:48::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 03:22:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 03:22:42 +0000
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
Subject: RE: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Topic: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Thread-Index: AQHXrSFvz6zvm2xHBUaW/Kl+BWVvQauuqGKAgACCWyCAABPxgIAAAavwgAAWHBA=
Date:   Wed, 22 Sep 2021 03:22:42 +0000
Message-ID: <BN9PR11MB5433023B883A6EBDE8D80AC68CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921155705.GN327412@nvidia.com>
 <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005501.GD327412@nvidia.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9810a6e-08a4-4226-6a7d-08d97d783d5e
x-ms-traffictypediagnostic: BN6PR11MB1265:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1265BE42D47BF7B6EABE6D918CA29@BN6PR11MB1265.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: paSFnHEPefGPxTm3L5jj6lGuH0U2vPDCcypduPeyqWGOhFsY6i4EdU+kCgSqHimqIXQ3zwwoAamlHT5x5wbLyjOZT67enYncj6fkWF10HA9ZQjno0UR9dFv2q4eJYgOXdmNYOGLQtap2UsOgfqETiiu2H/a6GLho1ZTXvNnmk2j41y1tFWXkq0AhxyJmdF3XxsjR+3WEAvt0v72bS+dSyMNNq4sK00nmK0Jv/A0Pln7/KdDn2pFObBTVTNA/cNHGUR49YNegiTW29qoBur2diEinnW2k+9FgZUqq2A8yQMG/SUJwcLhMRUlxCh5aY0dWDeOaChyxnK9JADTVPX83EXMF0jsvpIKUArX9AFfXVQhurfXPuMYSNRgj8Dubmwfw8vCx+itmH53behr/5HgFzVWeUyI6p4qPq7xkOtElRjSklRXb1pm16TCogPN2qvjAfkHwfvF21wmDvuu7wVFNbMbKHX2SSl3e+jPJeE0Z5CBI9/3dOS0CLx2KgiGYyhYZC+hQzTO2j6Zzdvx4PAmY6jNORopB76j/U9TvabXX8I+B3VgQITURmXPf+zx8/MCzl/z17M9seCr955I6zRKhpm/HR/VPzOsMAiWarUjsQ1pVHE/JEiXxORPQRrnuUd8uBATQnhTqwGY1QvtmlD2DiQC2sm5/eD9AvYom2pF0j6LaN7RDG+sEkra25aQmX6ASGX40NarOb5BJHehzDeczYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(86362001)(38100700002)(5660300002)(508600001)(66556008)(64756008)(8676002)(76116006)(122000001)(186003)(9686003)(66476007)(55016002)(8936002)(4326008)(7696005)(33656002)(52536014)(54906003)(38070700005)(83380400001)(6916009)(26005)(71200400001)(7416002)(316002)(66946007)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0gWI5a8wuna5cPWKBxrMA2OPw5sJBdN3U/GOaYd1emkNt0V/nS/KFTdWJNZY?=
 =?us-ascii?Q?JdtqerVGc2X2GpuQg93gk8O0byf+Ioxnla5D84LyWasQepdBJIy3doLJXu9L?=
 =?us-ascii?Q?T6Hq1vJZSMy0c6IlhRsS5uw4PVRGVO1aXCYHUDBSOqVAcrIE2RX+jYUNzu4Q?=
 =?us-ascii?Q?0LUjsPc0wm81yBmDRPVJ+8Zd26fZq+vbmk/hNC5ewSnjIc4RyGaKI1i/poUX?=
 =?us-ascii?Q?jd181KZRDv1XfqUfqwyaEmNAXc3G8siwkHkxikeiqDPiIWVHsbt0La1IAYVL?=
 =?us-ascii?Q?XwiNI+YaXGLYivsRHAnlfvgz8WTxr/fmaN1GDBUcgARkhaMs/Qpi2+ek2b2L?=
 =?us-ascii?Q?hCJ/CHGYzt0rsWPDPrxO3IBNkvmujhad4Qjq3KVHBX+ZdDpnaO2dzHcpyGjH?=
 =?us-ascii?Q?DAP7pdrFf8yvzFhdOZyHPmZc0VZlxaMYKbOrQBWfiqiX+nb9ESIdIScfbN/b?=
 =?us-ascii?Q?gE+FHH7qyGqIWG7m8mUyVlCRi1sil3i0pZN/4bSkVDGbBqsKxBFQycxRnVnP?=
 =?us-ascii?Q?9x6PH01J615HNWkfx80+X5ND0xk7hWVXk3vfy7sKTk0IxzhpAUWrWsrM3wsO?=
 =?us-ascii?Q?q30OwLPtY98VACLe29MantYNNguIymAdQm0GJ5ff3WDsMHcqT9IX2OHIbzsd?=
 =?us-ascii?Q?2cfMdV2RZH2sFWr4qknkjMPs3gSxW/hTaaZiB7mfP/kmlJf3zIPz9BMOTVPn?=
 =?us-ascii?Q?VY+uddGuM8h8yPMJsAoTuWnr9X+k52hGGh+PMmVXCbZrWWdMm7RHUyiIv/FA?=
 =?us-ascii?Q?VcclH8CN2ycXM72L1mMtzLej/4hrjKVnOGgCcbNy1K1+Lcf/47tgZCIqyyZ2?=
 =?us-ascii?Q?ZdctkqpdWWoZNR+5LHagC87WpRpxztkZ9EKVO3tB/9DIjCR6WbkQ49LRm7um?=
 =?us-ascii?Q?dYN2BaI6AvHFZhGv15p78MvnRPYoW3P3825gBPC1u+JphyQcgPZJDP8XPcr7?=
 =?us-ascii?Q?qZeGHnlAFLiO9eVGkggje3uoYWkUXSaPkZYVYJKkONpEXh6kATAUC2cmINEG?=
 =?us-ascii?Q?xKoDS5nJP2+1DIsA7NWCOodAmsC1Zn07209h6nnS/ts1NH6w+zZVVoZg7tyA?=
 =?us-ascii?Q?TgVP7D4rdRrNgUE8tAeWf4ZPrUtXZDpeEYgxJH0LX9loucteCf0f+o8YViKU?=
 =?us-ascii?Q?h4aEvCoLMtQ9D/9snxEu9Hx2m028oBHBu3jDwKB+GxBhuRpTcNlC3UiBG1wk?=
 =?us-ascii?Q?rUbfMm7cq2DfDbi0ueEQNeKOtceDsN7c58/MvHLPT0qX+hKK/Y2gV14txqVB?=
 =?us-ascii?Q?7hoNbWXlKQ3iwbxujjljtBjHJisncgycWnU+J6XGnZLPxxdNGLHET2hklXfE?=
 =?us-ascii?Q?lCmhWfwLl9aMzvAdDhnO+Jt8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9810a6e-08a4-4226-6a7d-08d97d783d5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 03:22:42.6615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +wezJwzDl3NK4XUq/AmkX/bzNdpzVaI73Bza3Bf6uw4LJ+dvz5+Sdrgpst2/XggXH58glH4tjOFUu/3s9UWIHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1265
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin
> Sent: Wednesday, September 22, 2021 9:07 AM
>=20
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 8:55 AM
> >
> > On Tue, Sep 21, 2021 at 11:56:06PM +0000, Tian, Kevin wrote:
> > > > The opened atomic is aweful. A newly created fd should start in a
> > > > state where it has a disabled fops
> > > >
> > > > The only thing the disabled fops can do is register the device to t=
he
> > > > iommu fd. When successfully registered the device gets the normal f=
ops.
> > > >
> > > > The registration steps should be done under a normal lock inside th=
e
> > > > vfio_device. If a vfio_device is already registered then further
> > > > registration should fail.
> > > >
> > > > Getting the device fd via the group fd triggers the same sequence a=
s
> > > > above.
> > > >
> > >
> > > Above works if the group interface is also connected to iommufd, i.e.
> > > making vfio type1 as a shim. In this case we can use the registration
> > > status as the exclusive switch. But if we keep vfio type1 separate as
> > > today, then a new atomic is still necessary. This all depends on how
> > > we want to deal with vfio type1 and iommufd, and possibly what's
> > > discussed here just adds another pound to the shim option...
> >
> > No, it works the same either way, the group FD path is identical to
> > the normal FD path, it just triggers some of the state transitions
> > automatically internally instead of requiring external ioctls.
> >
> > The device FDs starts disabled, an internal API binds it to the iommu
> > via open coding with the group API, and then the rest of the APIs can
> > be enabled. Same as today.
> >

After reading your comments on patch08, I may have a clearer picture
on your suggestion. The key is to handle exclusive access at the binding
time (based on vdev->iommu_dev). Please see whether below makes=20
sense:

Shared sequence:

1)  initialize the device with a parked fops;
2)  need binding (explicit or implicit) to move away from parked fops;
3)  switch to normal fops after successful binding;

1) happens at device probe.

for nongroup 2) and 3) are done together in VFIO_DEVICE_GET_IOMMUFD:

  - 2) is done by calling .bind_iommufd() callback;
  - 3) could be done within .bind_iommufd(), or via a new callback e.g.
    .finalize_device(). The latter may be preferred for the group interface=
;
  - Two threads may open the same device simultaneously, with exclusive=20
    access guaranteed by iommufd_bind_device();
  - Open() after successful binding is rejected, since normal fops has been
    activated. This is checked upon vdev->iommu_dev;

for group 2/3) are done together in VFIO_GROUP_GET_DEVICE_FD:

  - 2) is done by open coding bind_iommufd + attach_ioas. Create an=20
    iommufd_device object and record it to vdev->iommu_dev
  - 3) is done by calling .finalize_device();
  - open() after a valid vdev->iommu_dev is rejected. this also ensures
    exclusive ownership with the nongroup path.

If Alex also agrees with it, this might be another mini-series to be merged
(just for group path) before this one. Doing so sort of nullifies the exist=
ing
group/container attaching process, where attach_ioas will be skipped and
now the security context is established when the device is opened.

Thanks
Kevin
