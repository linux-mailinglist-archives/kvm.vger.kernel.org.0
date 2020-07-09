Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E1E219604
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 04:08:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgGICI0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 22:08:26 -0400
Received: from mga17.intel.com ([192.55.52.151]:15646 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgGICIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 22:08:25 -0400
IronPort-SDR: DTtfqZG6jb/EgO1Avxnt+J7Q0nXwXCITsgs6KCA3qoiSI3oOnZccAXhicL98AH1K/IWmon1GUC
 ktpU4PPCKeQg==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="127996405"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="127996405"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 19:08:23 -0700
IronPort-SDR: cOJdczbpWduFj0S+DuPb8p3NayuUmw4/Ff/ys0tORgBvs24nJKdYVpB5kgmswsIWjxy7hTEUgu
 3aCYnEW/sVrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="484093331"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jul 2020 19:08:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 19:08:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jul 2020 19:08:22 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jul 2020 19:08:22 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 19:08:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLzdc+Dtq9+V9EM7wAdE/7Qa1TKFPZ4/03sxWQvaMdG3mRvBXAymljx3HX4+6HuB5D+D6uLxLjmFP//G+J1wYs4Z7x++9cHAoVYjuu0zRm8UhvDObP2qH/BZ40s5Kbgb74gAnuYBDo8/0obIo2nHgvLi/e1l31wPNwhXmvYF4PzFVz2B804eEvwLGLeDG+t4zE/CEwv1d1AuMqnWGFuuIftAVrexhlh0KN6VP2mTW2dr+KtT52EoshCidi2VFX3IhHrY37hevozZr6GP7ce1iQdIxGudTvmU9agXTuXCSjPwbKb0qJtuDN0LHvB6+U9D/27euTIrSw2ZE31spTB2Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vFStrjVMYLHRM5mIpJ64o+QaRQlx8weva2fvgbvLkU=;
 b=CbfwmTDx27HQQ+VJqxRG66msf4avTo5KMuSJalMu85sgipf94BWrcV5NZ2IvH+aB42n/Q4c6ZfPfE1jF+uSBvBrDDSn2EnHcrjKfimUo1eApEGxyh7+IpqMl0amKQ9gx+2YGzRkhsMr6s0BvaoPWp/OZO7ytmm9KDSCr01ayqCw2/CCt5UXDExnEC27j6KyObNVcPEYJWaXN2F0LvQMg1qc16sU6de1rlDviRJ6oQvVk+ND6sRpp5dvw2t5M3FH7lJSNp817ArNuLqoYatEshYxT/XauOFwKFgWFImAn+gTTT+JJd8RVdHmlyqcUvfUraVisHwojuO5WCppCkSaLBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9vFStrjVMYLHRM5mIpJ64o+QaRQlx8weva2fvgbvLkU=;
 b=mZpwmLco7XHxpDgbmghTK7HL9XjFO04PfuMF6wTcxp/nQzHgEJOLuKjtgHGY3sYqs/hJpe6dNq/y7mHKEcFBfGM2UdUa8G4lSXt/yb8nyKVkMMD8quK0SjxNDSOQdlyGW0RIJ3TlwVxhGHkbxkbooqbgcjnWCIBSY/RUFl5yZDc=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4233.namprd11.prod.outlook.com (2603:10b6:5:14f::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.27; Thu, 9 Jul 2020 02:08:20 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 02:08:19 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Thread-Topic: [PATCH v3 06/14] vfio/type1: Add VFIO_IOMMU_PASID_REQUEST
 (alloc/free)
Thread-Index: AQHWSgRRzB2G/Oy5QEmxCHQWFS0FB6j02KQAgACUCyCAB/5SUIAAxDYAgABLnwCAABmKAIAAAO4w
Date:   Thu, 9 Jul 2020 02:08:19 +0000
Message-ID: <DM5PR11MB14357DC99EFCDE7E02944E2EC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
        <20200702151832.048b44d1@x1.home>
        <CY4PR11MB1432DD97F44EB8AA5CCC87D8C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
        <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200708135444.4eac48a4@x1.home>
 <DM5PR11MB14358A8797E3C02E50B37FFEC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB16456D12135AA36BA16CE4208C640@MWHPR11MB1645.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB16456D12135AA36BA16CE4208C640@MWHPR11MB1645.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.230.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2b53f2f-4b3b-4562-d0e1-08d823acf324
x-ms-traffictypediagnostic: DM6PR11MB4233:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB42334D49C6A0E856B3D9E014C3640@DM6PR11MB4233.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04599F3534
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wH4kRd83jZu70URtmGS7ZtagtgFo5prEC+HPasr/mw54tPkS9/ZIWm+G/YTXgyjb8nh16UzGYAQHYiVOywJLIBZtErF0G0m8X6rdgpD4VaZQLaJegXHUuPlz4nzLLXKsfpgKJrXr91xJnqGixRm+Lc1rxyyH1sndx5Ikl57DGNIwvdJlLtjUstwxMts/7i+d4B65U4mi3mQ6E7dFWdFC0CbnTVCE6WnQIrA7ZBjexPBbWIUGmBzJbiPzX+8fU1l24f/WxT63/PL4GMubgjoVrsco4/6hxq8Fl/IaEW3i5Ox2SjOzMs7dr2C3+nHJTuyEuvrXmmYeSV9/tdEEj2rssA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(5660300002)(110136005)(76116006)(8936002)(86362001)(71200400001)(478600001)(186003)(66946007)(33656002)(52536014)(66476007)(66556008)(64756008)(66446008)(26005)(2906002)(9686003)(55016002)(7416002)(8676002)(54906003)(316002)(4326008)(6506007)(7696005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: NcKgiQPhXS/TCX82jKRwonxL4RB0OiqaSOUoh/2L5btokN9jIk4r+YXiqtc3K13EYNr+SMb7w/tUDz3aEU6EdmQ/rhtHHf0Mj5/GPOyb36kMo0QpYSIOs7P/0LKZ6wh67ByVvcgzirLXhcEdnVY1Gpd6T/Ewlqwwgscqo3zlhd4uwDbD5ujBNNREbRKWNliOsYPB4PBg1RuOCp7JRqar+ViUZJ/xKazXk2cNcgru46WHVIlt3xTC+QLPtpCR3E04q+ybx5VRcLL9kkoTDYW9MTFMN8Xc4o9mrIpBungrnfHmzPYg0ElYx6OMPtvT6GPXI742ogNMsRtZEZDTOuaYaoZGsDHMYyQucv9VkTr5UyR1o4kyzdps4Huas4YgTygd/6mxGoeahmArR0Mj9Pqp6R+ejc9friSdEFzBPifUpVV9daK5vuoaAfiLG7z1QcigXxo3+/pZH//juCQwAyMUcvb4SJON+QtF6fn1eflWTA7tEk3MciGZPxlyMKa5CWWc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b53f2f-4b3b-4562-d0e1-08d823acf324
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 02:08:19.2329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlVJE7W7ID8z4wodTGXuFNZqRYPuFlWmVESMBwXl8KqfRSyr3TbHIG4TL3MCagREItcBUChXNXrwCdtzqpbCLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4233
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, July 9, 2020 9:57 AM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, July 9, 2020 8:32 AM
> >
> > Hi Alex,
> >
> > > Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, July 9, 2020 3:55 AM
> > >
> > > On Wed, 8 Jul 2020 08:16:16 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > Hi Alex,
> > > >
> > > > > From: Liu, Yi L < yi.l.liu@intel.com>
> > > > > Sent: Friday, July 3, 2020 2:28 PM
> > > > >
> > > > > Hi Alex,
> > > > >
> > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > Sent: Friday, July 3, 2020 5:19 AM
> > > > > >
> > > > > > On Wed, 24 Jun 2020 01:55:19 -0700 Liu Yi L
> > > > > > <yi.l.liu@intel.com> wrote:
> > > > > >
> > > > > > > This patch allows user space to request PASID allocation/free=
, e.g.
> > > > > > > when serving the request from the guest.
> > > > > > >
> > > > > > > PASIDs that are not freed by userspace are automatically
> > > > > > > freed
> > when
> > > > > > > the IOASID set is destroyed when process exits.
> > > > [...]
> > > > > > > +static int vfio_iommu_type1_pasid_request(struct vfio_iommu
> > *iommu,
> > > > > > > +					  unsigned long arg)
> > > > > > > +{
> > > > > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > > > > +	unsigned long minsz;
> > > > > > > +
> > > > > > > +	minsz =3D offsetofend(struct vfio_iommu_type1_pasid_request=
,
> > > range);
> > > > > > > +
> > > > > > > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > > > > +		return -EFAULT;
> > > > > > > +
> > > > > > > +	if (req.argsz < minsz || (req.flags &
> > > ~VFIO_PASID_REQUEST_MASK))
> > > > > > > +		return -EINVAL;
> > > > > > > +
> > > > > > > +	if (req.range.min > req.range.max)
> > > > > >
> > > > > > Is it exploitable that a user can spin the kernel for a long
> > > > > > time in the case of a free by calling this with [0, MAX_UINT]
> > > > > > regardless of their
> > > actual
> > > > > allocations?
> > > > >
> > > > > IOASID can ensure that user can only free the PASIDs allocated
> > > > > to the
> > user.
> > > but
> > > > > it's true, kernel needs to loop all the PASIDs within the range
> > > > > provided by user.
> > > it
> > > > > may take a long time. is there anything we can do? one thing may
> > > > > limit
> > the
> > > range
> > > > > provided by user?
> > > >
> > > > thought about it more, we have per-VM pasid quota (say 1000), so
> > > > even if user passed down [0, MAX_UNIT], kernel will only loop the
> > > > 1000 pasids at most. do you think we still need to do something on =
it?
> > >
> > > How do you figure that?  vfio_iommu_type1_pasid_request() accepts
> > > the user's min/max so long as (max > min) and passes that to
> > > vfio_iommu_type1_pasid_free(), then to vfio_pasid_free_range()
> > > which loops as:
> > >
> > > 	ioasid_t pasid =3D min;
> > > 	for (; pasid <=3D max; pasid++)
> > > 		ioasid_free(pasid);
> > >
> > > A user might only be able to allocate 1000 pasids, but apparently
> > > they can ask to free all they want.
> > >
> > > It's also not obvious to me that calling ioasid_free() is only
> > > allowing the user to free their own passid.  Does it?  It would be a
> > > pretty
>=20
> Agree. I thought ioasid_free should at least carry a token since the user=
 space is
> only allowed to manage PASIDs in its own set...
>=20
> > > gaping hole if a user could free arbitrary pasids.  A r-b tree of
> > > passids might help both for security and to bound spinning in a loop.
> >
> > oh, yes. BTW. instead of r-b tree in VFIO, maybe we can add an
> > ioasid_set parameter for ioasid_free(), thus to prevent the user from
> > freeing PASIDs that doesn't belong to it. I remember Jacob mentioned it=
 before.
> >
>=20
> check current ioasid_free:
>=20
>         spin_lock(&ioasid_allocator_lock);
>         ioasid_data =3D xa_load(&active_allocator->xa, ioasid);
>         if (!ioasid_data) {
>                 pr_err("Trying to free unknown IOASID %u\n", ioasid);
>                 goto exit_unlock;
>         }
>=20
> Allow an user to trigger above lock paths with MAX_UINT times might still=
 be bad.

yeah, how about the below two options:

- comparing the max - min with the quota before calling ioasid_free().
  If max - min > current quota of the user, then should fail it. If
  max - min < quota, then call ioasid_free() one by one. still trigger
  the above lock path with quota times.

- pass the max and min to ioasid_free(), let ioasid_free() decide. should
  be able to avoid trigger the lock multiple times, and ioasid has have a
  track on how may PASIDs have been allocated, if max - min is larger than
  the allocated number, should fail anyway.
=20
thoughts on the above reply?

Regards,
Yi Liu

> Thanks
> Kevin
