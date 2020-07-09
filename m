Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC58421963E
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 04:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGIC0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 22:26:44 -0400
Received: from mga12.intel.com ([192.55.52.136]:41429 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgGIC0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 22:26:43 -0400
IronPort-SDR: w3pgnTQuUb2vQg0YWdYtjBWwhJfK19cs5OW+ftLwQr7csngVrBvVhoZKahPT2m4ek6zyFHSt7q
 69rxw/9PcHag==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="127514365"
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="127514365"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 19:26:30 -0700
IronPort-SDR: gwuSn3Pwpce2WIOHzygJlWmUvO2/0+xcqFtQT9jpyen83ODtbIg5VNePPXeJW3AgEihJzI7cLR
 5tuYptC5D54A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,330,1589266800"; 
   d="scan'208";a="280136501"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by orsmga003.jf.intel.com with ESMTP; 08 Jul 2020 19:26:29 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 19:26:29 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 19:26:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dG0vpOs/+iOBev509u/BKO1TcM6QJ1VIv2sLFQYz7DHmyByZwzEmVaxQlu90kbVPn89Ny10LXcV3WIDybeXlRo13W+pqV5ievzt4uas8LjUP1r/nCpL/B30elV9ZM7ASGAXOpghx1pvaCBvX3GDz2qzovirR90rnVoqWajw0euzppkzoKMYuFufyC3jdrqLh6OJUVIIViYS9NVQ1iYUyDbNChkI4hLO5WUciYiaDoEEKgAUgrSM0nOdO9WkXH5jQyk+e5sdSSGlJmeoDgv1AjUudY9097D4knt90p6lgj96ROvZDYqDJuEBZ67ib6OrUUx6B3FlFtyYwEQZ6ZORaww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y66Vvd4b91mstNByeV2FEknLewHNVUkeNcCHHOszvHs=;
 b=bET5C0qs04TsCkjI8zuz4DYMUmTKL9ZwvGTvWY/ESB4yQgcVCvI0Ljk+rRMqR3SOGtPp7euvAHZAftnn7D9NVAy35w/qL4pa2uiq3+8PzZOlbQcWPanv20nHH4+mkeRhMnB+sF9DsO4GyOcR/NclNQUtcnFwrX4Ob1LhZoiOS6Rf4ANNsB5qnAAu8/ERYiz6PP6DUTCRM4mlqKamE2nvjFWXuOg2IfqJPKdMMI8IoWcPUnd4cKkiKrT8oe19dchdDeCGiWsKlnrnEYInzXqLRaUQeK0TNomzOTuf7cakpj3RPiVuBLwNkvhJF06XoTuH35z6GMNLqFEbWEdlS/7VzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y66Vvd4b91mstNByeV2FEknLewHNVUkeNcCHHOszvHs=;
 b=bByA7ZYIUA91xUJe/OFwwTt+SaMvxUULiO7MH/CQHd6CoC+mTqv2AtJbQ+LqihbosNYuCLAdVXmHSpHlMB59xYnK1MXkYGBkRmDFy6wgaMYhlzWYVZYmTCNRm0ap5EtAQU3ptbj/pKfRMLPhJBcTNQ8DhlULEn9lAbKTQuvzG/U=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB3994.namprd11.prod.outlook.com (2603:10b6:5:193::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.20; Thu, 9 Jul 2020 02:26:27 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 02:26:27 +0000
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
Thread-Index: AQHWSgRRzB2G/Oy5QEmxCHQWFS0FB6j02KQAgACUCyCAB/5SUIAAxDYAgABLnwCAABmKAIAAAO4wgAAFFYCAAAD78A==
Date:   Thu, 9 Jul 2020 02:26:27 +0000
Message-ID: <DM5PR11MB143577F0C21EDB82B82EEB35C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
        <1592988927-48009-7-git-send-email-yi.l.liu@intel.com>
        <20200702151832.048b44d1@x1.home>
        <CY4PR11MB1432DD97F44EB8AA5CCC87D8C36A0@CY4PR11MB1432.namprd11.prod.outlook.com>
        <DM5PR11MB1435B159DA10C8301B89A6F0C3670@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200708135444.4eac48a4@x1.home>
 <DM5PR11MB14358A8797E3C02E50B37FFEC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB16456D12135AA36BA16CE4208C640@MWHPR11MB1645.namprd11.prod.outlook.com>
 <DM5PR11MB14357DC99EFCDE7E02944E2EC3640@DM5PR11MB1435.namprd11.prod.outlook.com>
 <MWHPR11MB1645F822D9267005AE5BCE528C640@MWHPR11MB1645.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR11MB1645F822D9267005AE5BCE528C640@MWHPR11MB1645.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: a815442c-2bb1-429a-c856-08d823af7b98
x-ms-traffictypediagnostic: DM6PR11MB3994:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB399494EEEAA835DDA3C621B6C3640@DM6PR11MB3994.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04599F3534
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jbnRle7eYJNc6jl2UuENzvCmEHtSa+tbaroimVUz0nEGO1eQ9s43OXPQW00my/FftwqbTb6KYPno37XtzeEGB+C1u5aDaps2VPBXQTj73OFSp+pkBCQloVT2yd1XOGnGb0GkKckmim/z/WpS5P6TFrnkkDp11WCIvg9FHBToCVagTEoGxjpnaFlO3mi0aKpuMCIWZHmA7XiOXkBm3DLavHU56qeTiNdyPKs8O6blLbaiAkPAklwUMfFynZ2kufB9eJHUvNSwRbI4k1k5p/7DDMeI+21Uf6/6SP5RVT9eyeobRg/WFsZQNJqGpjn7X6zTidDLv04ViCPY/IqF3tf3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(4326008)(186003)(54906003)(86362001)(110136005)(2906002)(8936002)(8676002)(9686003)(55016002)(316002)(7416002)(76116006)(33656002)(6506007)(26005)(478600001)(83380400001)(66556008)(64756008)(7696005)(66476007)(71200400001)(52536014)(66946007)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: rUU6cAC1nCz6+2K/cNWtzZ+DOCYL7zTgVMgyE+cuNWYDUT/yMSz7NRGgywbX0Iq/0IGPRWdDCDoN8u+p0YzQRg8jsq/3KT8gDiGt4DCs26SmuPr6yLG/UoCut72qHHpGrNPMxeQPOVojz07Od511QIDh2e7naBxAt3Wr/OqQPgUEL6rZ/cYcU6AmlWM9armi5b0dFAfh58mdH+h062ycKfhfL2Q5/rEfStD/0/VPkio0Khl4S4eVDSbSwjUHiski+m31pr3X5RzLJTxhfQQkTyQ6KGQwlI0X51OadRhsQdfAFhmk974lc6iBAxXLHF8VWU9hczYU4fcq0SB0+LmF0OJuT/Xj7bdDstvEDEJhnuf1PqsRnsADQPwhVH1MqeGOKBsvBbwiyYLRcycCLR1X7z1jve5H3f1yhd3wkwrb7GPlked5kbWRKpW8D03mzL8jh3b+gFRmMpMH/YmQDm6A+7/iwn7BUjW3+n1yXUtYWoF3ss1Nj7LhG+4Hshpg2rIl
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a815442c-2bb1-429a-c856-08d823af7b98
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 02:26:27.1385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HiZrSvREyEPajJdFQTWEpvlxpZF4V2Z30oshBkGOiDcEIB5r9FUSjcpbqwNYG/2rLi216inLB/bMwik5+jagcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3994
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, July 9, 2020 10:18 AM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, July 9, 2020 10:08 AM
> >
> > Hi Kevin,
> >
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Thursday, July 9, 2020 9:57 AM
> > >
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Thursday, July 9, 2020 8:32 AM
> > > >
> > > > Hi Alex,
> > > >
> > > > > Alex Williamson <alex.williamson@redhat.com>
> > > > > Sent: Thursday, July 9, 2020 3:55 AM
> > > > >
> > > > > On Wed, 8 Jul 2020 08:16:16 +0000
> > > > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > > > >
> > > > > > Hi Alex,
> > > > > >
> > > > > > > From: Liu, Yi L < yi.l.liu@intel.com>
> > > > > > > Sent: Friday, July 3, 2020 2:28 PM
> > > > > > >
> > > > > > > Hi Alex,
> > > > > > >
> > > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > Sent: Friday, July 3, 2020 5:19 AM
> > > > > > > >
> > > > > > > > On Wed, 24 Jun 2020 01:55:19 -0700 Liu Yi L
> > > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > > >
> > > > > > > > > This patch allows user space to request PASID allocation/=
free,
> > e.g.
> > > > > > > > > when serving the request from the guest.
> > > > > > > > >
> > > > > > > > > PASIDs that are not freed by userspace are automatically
> > > > > > > > > freed
> > > > when
> > > > > > > > > the IOASID set is destroyed when process exits.
> > > > > > [...]
> > > > > > > > > +static int vfio_iommu_type1_pasid_request(struct vfio_io=
mmu
> > > > *iommu,
> > > > > > > > > +					  unsigned long arg)
> > > > > > > > > +{
> > > > > > > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > > > > > > +	unsigned long minsz;
> > > > > > > > > +
> > > > > > > > > +	minsz =3D offsetofend(struct
> vfio_iommu_type1_pasid_request,
> > > > > range);
> > > > > > > > > +
> > > > > > > > > +	if (copy_from_user(&req, (void __user *)arg, minsz))
> > > > > > > > > +		return -EFAULT;
> > > > > > > > > +
> > > > > > > > > +	if (req.argsz < minsz || (req.flags &
> > > > > ~VFIO_PASID_REQUEST_MASK))
> > > > > > > > > +		return -EINVAL;
> > > > > > > > > +
> > > > > > > > > +	if (req.range.min > req.range.max)
> > > > > > > >
> > > > > > > > Is it exploitable that a user can spin the kernel for a lon=
g
> > > > > > > > time in the case of a free by calling this with [0, MAX_UIN=
T]
> > > > > > > > regardless of their
> > > > > actual
> > > > > > > allocations?
> > > > > > >
> > > > > > > IOASID can ensure that user can only free the PASIDs allocate=
d
> > > > > > > to the
> > > > user.
> > > > > but
> > > > > > > it's true, kernel needs to loop all the PASIDs within the ran=
ge
> > > > > > > provided by user.
> > > > > it
> > > > > > > may take a long time. is there anything we can do? one thing =
may
> > > > > > > limit
> > > > the
> > > > > range
> > > > > > > provided by user?
> > > > > >
> > > > > > thought about it more, we have per-VM pasid quota (say 1000), s=
o
> > > > > > even if user passed down [0, MAX_UNIT], kernel will only loop t=
he
> > > > > > 1000 pasids at most. do you think we still need to do something=
 on it?
> > > > >
> > > > > How do you figure that?  vfio_iommu_type1_pasid_request() accepts
> > > > > the user's min/max so long as (max > min) and passes that to
> > > > > vfio_iommu_type1_pasid_free(), then to vfio_pasid_free_range()
> > > > > which loops as:
> > > > >
> > > > > 	ioasid_t pasid =3D min;
> > > > > 	for (; pasid <=3D max; pasid++)
> > > > > 		ioasid_free(pasid);
> > > > >
> > > > > A user might only be able to allocate 1000 pasids, but apparently
> > > > > they can ask to free all they want.
> > > > >
> > > > > It's also not obvious to me that calling ioasid_free() is only
> > > > > allowing the user to free their own passid.  Does it?  It would b=
e a
> > > > > pretty
> > >
> > > Agree. I thought ioasid_free should at least carry a token since the =
user
> > space is
> > > only allowed to manage PASIDs in its own set...
> > >
> > > > > gaping hole if a user could free arbitrary pasids.  A r-b tree of
> > > > > passids might help both for security and to bound spinning in a l=
oop.
> > > >
> > > > oh, yes. BTW. instead of r-b tree in VFIO, maybe we can add an
> > > > ioasid_set parameter for ioasid_free(), thus to prevent the user fr=
om
> > > > freeing PASIDs that doesn't belong to it. I remember Jacob mentione=
d it
> > before.
> > > >
> > >
> > > check current ioasid_free:
> > >
> > >         spin_lock(&ioasid_allocator_lock);
> > >         ioasid_data =3D xa_load(&active_allocator->xa, ioasid);
> > >         if (!ioasid_data) {
> > >                 pr_err("Trying to free unknown IOASID %u\n", ioasid);
> > >                 goto exit_unlock;
> > >         }
> > >
> > > Allow an user to trigger above lock paths with MAX_UINT times might s=
till
> > be bad.
> >
> > yeah, how about the below two options:
> >
> > - comparing the max - min with the quota before calling ioasid_free().
> >   If max - min > current quota of the user, then should fail it. If
> >   max - min < quota, then call ioasid_free() one by one. still trigger
> >   the above lock path with quota times.
>=20
> This is definitely wrong. [min, max] is about the range of the PASID valu=
e,
> while quota is about the number of allocated PASIDs. It's a bit weird to
> mix two together.

got it.

> btw what is the main purpose of allowing batch PASID
> free requests? Can we just simplify to allow one PASID in each free just
> like how is it done in allocation path?

it's an intention to reuse the [min, max] range as allocation path. current=
ly,
we don't have such request as far as I can see.

> >
> > - pass the max and min to ioasid_free(), let ioasid_free() decide. shou=
ld
> >   be able to avoid trigger the lock multiple times, and ioasid has have=
 a
> >   track on how may PASIDs have been allocated, if max - min is larger t=
han
> >   the allocated number, should fail anyway.
>=20
> What about Alex's r-b tree suggestion? Is there any downside in you mind?

no downside, I was just wanting to reuse the tracks in ioasid_set. I can ad=
d
a r-b for allocated PASIDs and find the PASIDs in the r-b tree only do free
for the PASIDs found in r-b tree, others in the range would be ignored.
does it look good?

Regards,
Yi Liu

> Thanks,
> Kevin
