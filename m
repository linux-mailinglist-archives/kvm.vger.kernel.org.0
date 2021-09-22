Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4964413ED9
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 03:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhIVBIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 21:08:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:25828 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230469AbhIVBIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 21:08:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10114"; a="203649438"
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="203649438"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2021 18:07:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,312,1624345200"; 
   d="scan'208";a="585211863"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 21 Sep 2021 18:07:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 21 Sep 2021 18:07:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 21 Sep 2021 18:07:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 21 Sep 2021 18:07:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZ56FG5hHoW/U/JkQDdJzEuncjFukhdgdR9RvedVs1IXhDavsdJDW+c+116NYzOUcimZ8jDkTU+5X2nin2JFHsh3hDEt1etuYarx0X563J6/qZgdD1B3G0oRmbVqFt2IVXAsbBqR9VCbCUjIFqRey9v7z09oSgDJWiLG9FBBLr5RS14cA9HJ1vgVihH26LH7b7pvBPXiOpNOytE2G6RGxPuLJwdfjwQi9nqpdgfLLNN5LacWsiTK2HvvfB6D/EkBSPeO7JU+B2TR+9nYFqupyRQDQx0I/9QviHmdpT3AXuR5bzmnpNaf59Y6HEKns6amAwM90tU8mIkePzV9kD0/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SdLpnkzIbrg/eJsnOOsI0SFib9oNLwwtG88pz1OZ9QU=;
 b=E5wRj+NVdVCAUCEsCp3/gV6bWhMyqODXLDzlqoH6ybnyHdWC/QdL1KU+ABS9SQl831mDlP1CC9rnPUd/ohGRt/ablmREYIvsYR7/YNQkUJjiCNCSZHWehJMK7FMkjarJN0GGtGBy9Z/YsoGa4wWpIwCHI+atfD/U8HuXtkr6NqztV4jfwzZ/IKp/FwwpqGjPgRyfw/LIqIsfPz8e68fQ+26gKMgQlQ58u8THzadWLZmkEC4ycAhZJnG+fF4HafxfCmqM/IHipthOhs90AB4ZODhaCTSZQA9XMmCcSe4QsYxC6WLD4rEXcAoaAI8jqwTzHPu/5ANgalPwDxoHrNlYBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SdLpnkzIbrg/eJsnOOsI0SFib9oNLwwtG88pz1OZ9QU=;
 b=TPXtNgm0ybnpiOMClI+zPMIrTEaISkRWTwDgC+gepbyMRCFJeU53g/2TnKBZmcXHukTFj0Zcd87kBIUvttJVCxxz8nlSAowBuWKFb0HvoTD6wcutdQyebIYac5XVOzwQkyXtlbv7u4UJtarbGKV0Z7Fuk7X/bjFXbz/5EiXLjlY=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB0051.namprd11.prod.outlook.com (2603:10b6:405:65::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 01:07:11 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 01:07:11 +0000
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
Thread-Index: AQHXrSFvz6zvm2xHBUaW/Kl+BWVvQauuqGKAgACCWyCAABPxgIAAAavw
Date:   Wed, 22 Sep 2021 01:07:11 +0000
Message-ID: <BN9PR11MB543322943B84EFAC88AD25438CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
 <20210921155705.GN327412@nvidia.com>
 <BN9PR11MB5433A709ED352FD81DDBF5A68CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005501.GD327412@nvidia.com>
In-Reply-To: <20210922005501.GD327412@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b4ee719-bcfe-4047-bfe2-08d97d654edf
x-ms-traffictypediagnostic: BN6PR11MB0051:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB005140BCB89419D399C102CF8CA29@BN6PR11MB0051.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E72ow9MK6I1tWrBloyaCbqzta73YQiqgrAm+7WIu5WOmiW8c6/XtvInmnsH0PanJmXwwlVXcAh26r8Gfih5M/4+g5kmbqIACq9+LfE59w3EVjbERW/6i7l/FTI+IfjGQ8RUiOifh7QMUv5avst8gw4gOefiu/NGxM++XajzhoLB59mvpqDzG77FMDvPcsi/48xiahH0Tvee66Ils1ORNEry5xurmGu+5g4sNYvHc6QxoTWq2jbI9rhjCzjAX0uAdiFpbhscp5VB0kV5JTmVjKwI5/0cWF5g5bZ5nVNUZuzOqQ0z2h69lrm5a9F28qx4gonYLwG+0ynsuBaC0locSba1coCn8HUKdxY022PmL8sskJuqLQkIAGNXh8o6B0MwaN4YY8BQorYFAOrt7Oul+IX4wZDVjN5PmOAOKO0E4DMwKkB9kr9gWlDDPbJzZtBtiHlA8VfaPctyiY+jsb8DOnSNX3k6FTTEQMniNylbqx9vkI4WvLhPkHFHvC5nEgjXHWconNSdP+VixP1npompo74VAlor4q3rcXCSN0AIoZ74/2fNI7704Y857Vu/TRiReVgdNKgItSlVhCb6f2zPK5oNzZQ8XV6QHKJfVqURLAqLsYqFTW4sRTriF7nMm7PEaayYMxeWa0x5mDXwpxrFU4XdkhUwup8vbz6HuUaIqtnFyT2Zx5geBvUEd0MDahfwb+NrsWiqbUuuFsqx7YQEGpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(66446008)(54906003)(66556008)(64756008)(4326008)(66946007)(86362001)(7696005)(122000001)(186003)(33656002)(76116006)(83380400001)(6916009)(9686003)(8936002)(7416002)(38100700002)(8676002)(316002)(26005)(66476007)(55016002)(52536014)(508600001)(2906002)(38070700005)(71200400001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?y2nRsRqREUuu/UdODhZYrOAh/4XELuhyX1OI6QyssbaWXXIl2G4MUbxuwdLZ?=
 =?us-ascii?Q?dhoPfPUjgEkMPVHq/c2MtOBEsben6ZcOoZTI8hBdSMlvpf2WIJlIdlsKOiPm?=
 =?us-ascii?Q?q492tIMkEOrutT9rKZrMfBsQERrIXMMfNvHodb2VGLZeWwjTvemQNfsv428l?=
 =?us-ascii?Q?rbFHWclvKlr05amdnDXOQpWIcK5/Uvtpzz6joTZrGrZ+IP8AxVl/EpOSmeaG?=
 =?us-ascii?Q?KC9SkHxo7K7d4BQ142ctdreXY2vyOfZAavuLyVHYfD2cSRreEkMkhTONu1RC?=
 =?us-ascii?Q?c0GUTeNmLThhbLGFofpxNV8oqHXgsFzDQd5jbLI2xgdeUBamHAxQBny57HUu?=
 =?us-ascii?Q?vyE6dudlIiGBrghFQfB0Fk1CQpzBZecCpIrkN2nrwPIQgro5Axq2xgD/+T3Q?=
 =?us-ascii?Q?Uc07eNa14W88ZPmivljQbQvl31V+2GSccrRpXa39sUtJe6kt0cwpyxdXDXPD?=
 =?us-ascii?Q?qosWsFdaYZkIfAMduGRtsWGhZvwhABl+qJgULadZbBYVOlENT5rr5tmhxMoK?=
 =?us-ascii?Q?eCG/50EoNI2fd3/R6/BhbOpU+5CLfF/JGUSkmW9qFYq1+06BwnWTRL5aWxxA?=
 =?us-ascii?Q?kObU2TfUey1GQaVLqgL5RyfwetPxh+7AL4LWJiWp6HScxW4wqoxJET1FvTbH?=
 =?us-ascii?Q?sFsgK0AMh68v/CUs2gMAa4Li37jwEtWj5VqO59M5c8WrfIKy+UHodvM63StX?=
 =?us-ascii?Q?9sBO6M5FZsn48i/F1LUhOS5cWpbcoqsK68KGuxXtwcByWGDSzJTHbLBVKpbX?=
 =?us-ascii?Q?KAaqTXbH3Isi239BG2SWxcE7rqBIJH5COMXFJSfTwKHAknMRBT3FU/oEUvep?=
 =?us-ascii?Q?H4bsOcPi2lkN2uR8J/lB4FEN1qJwLPDnEy5n0+KC7iw1PjB2Z37GrffvO+Y0?=
 =?us-ascii?Q?U2kyddK0qMLjP0RZVmgQreTGskHhioWtT6hWXVCCmt0QQEV2TgrNxy/AO/Yr?=
 =?us-ascii?Q?NWZJ3/9sAnXuW12CgdJ0sE/duJtSdDVBSJm6OGz8qf83QxFx1C+FsyI4xq+j?=
 =?us-ascii?Q?7eSKuX5wYFLYHtNzxiEaJRwoQ6Hq8/8ySKsaKUY7SjQ7speEScCDbpku9LpV?=
 =?us-ascii?Q?KaJOfk7n0dZBM1rYlHsGHymZZu+Wqwx9UVkszNYDPqw1/wdoxsfGp7hxMXrq?=
 =?us-ascii?Q?CMH3xyggkdW1TV7QItgkxLbhfHxwyAH3PW997mq9Lv8AF85tOZb4A8Q4/Qm7?=
 =?us-ascii?Q?oUCKVosPtN9StvoecxXVlCe05PcdWyO/nT4eLR3Jtxbve6RT4EGe/Dz85mir?=
 =?us-ascii?Q?8KNIZ0uUJx2aZBC0Vypa2+vQ3reGrEqBJf4OOLzBo31L7+bI6XmMBK549rnD?=
 =?us-ascii?Q?H/c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b4ee719-bcfe-4047-bfe2-08d97d654edf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 01:07:11.6269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Raf3uSqVBfaura95SDrxKuY1GxwEVLxIvo5F/nU6ulvtDfJ9/4vsdl+fkzI2pUykbHYuo2RmwEogrUWQxwuRFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB0051
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, September 22, 2021 8:55 AM
>=20
> On Tue, Sep 21, 2021 at 11:56:06PM +0000, Tian, Kevin wrote:
> > > The opened atomic is aweful. A newly created fd should start in a
> > > state where it has a disabled fops
> > >
> > > The only thing the disabled fops can do is register the device to the
> > > iommu fd. When successfully registered the device gets the normal fop=
s.
> > >
> > > The registration steps should be done under a normal lock inside the
> > > vfio_device. If a vfio_device is already registered then further
> > > registration should fail.
> > >
> > > Getting the device fd via the group fd triggers the same sequence as
> > > above.
> > >
> >
> > Above works if the group interface is also connected to iommufd, i.e.
> > making vfio type1 as a shim. In this case we can use the registration
> > status as the exclusive switch. But if we keep vfio type1 separate as
> > today, then a new atomic is still necessary. This all depends on how
> > we want to deal with vfio type1 and iommufd, and possibly what's
> > discussed here just adds another pound to the shim option...
>=20
> No, it works the same either way, the group FD path is identical to
> the normal FD path, it just triggers some of the state transitions
> automatically internally instead of requiring external ioctls.
>=20
> The device FDs starts disabled, an internal API binds it to the iommu
> via open coding with the group API, and then the rest of the APIs can
> be enabled. Same as today.
>=20

Still a bit confused. if vfio type1 also connects to iommufd, whether=20
the device is registered can be centrally checked based on whether
an iommu_ctx is recorded. But if type1 doesn't talk to iommufd at
all, don't we still need introduce a new state (calling it 'opened' or
'registered') to protect the two interfaces? In this case what is the
point of keeping device FD disabled even for the group path?
