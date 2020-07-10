Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A559421AED4
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 07:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgGJFkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 01:40:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:25767 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbgGJFkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 01:40:02 -0400
IronPort-SDR: JjWR4c/MBOe10p7js6frsXSzooNubTC4ntDLq5MYW8/jDSZIKaP07xhDdEymrdrQ+HL9sQr4B0
 U8CP2RrVutsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="145648368"
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="145648368"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 22:40:01 -0700
IronPort-SDR: 0zQfPGqDyhjHp5kdSjhADbkGsqhXyi/yoRnR0fGEy0bKTBZOyAaBxaWqLeDnKL2pz9r/YJFVAG
 s7NsZWN+UFjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="458177304"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 09 Jul 2020 22:40:01 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jul 2020 22:40:00 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 9 Jul 2020 22:40:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 9 Jul 2020 22:40:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDaQMPMa9BNYehYmg1MATWmvsPVK0IzqOgAJ02Miejk7dSxEB7jeO1jtd+zEVqg8AtFtcV4Nk6+2HVZS09jwdLmnAEa/uEkmRP82klv7D+FFI/BT29v3HCyxpyE4F07ItZuou5a9VuSS9I6hW2V+2TMnPZvCapxupvYsny40zLtb94bxFPAORUgSaKCm1Zvqvuk25b9XT+sSqCSHCRokkQt0Ox0rHU1omqWzAGe5Z12KnPX+7n1kKx87D9T9ZEnMBPclk3c8yeYfjE127RSIeQ5LSPgxOAPTijA4xWHQvuoWVU0pqyYt8czc2dyaGMr2NWJ81FRMA/XtCAxoYdJbkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1ZtNYnCFu7azqklSuX0z5ZLg1mZJ4vwAuwESYqlLlQ=;
 b=gMa33u8TUs5gn1FkGfhyqRLWBF5wNU1UdHDMCb2oCXku3lNVosQ/FWgV5aAubGaTpYp+1qqshLN5lzxAgNk3pEp9D03RQNKJUf1PFOs+gbbOGKWM7I369x7vw5yA+u6W5Y92T1a/19EsbOYUErlcgFp5sch+UlF1W5fc8lnvY5pqQnCO1/DyIyoNWpwL+1E7iZcaPlsPrsT3lMsYrk76B2xs3gbWP0YOO8znTDWb/DytjewygEvWFeDLa9AgvxrERl92Q2ecg1i/U8OFDu6mUqnnswZmwq4pmT31jJUyTqptCmL2e7CpPOCpWIC62AIxamNJWLsumyUsDVAt06OxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1ZtNYnCFu7azqklSuX0z5ZLg1mZJ4vwAuwESYqlLlQ=;
 b=Kvt+p5W2YOO+913taIUtySBAdQkqKyJlhBytywiQrejZ75ms0mFy2xdCFP3krh7NOS1gee42kPQ1ep3cMxIWr/Df0hZ8J1Tdn5bPy/0uwPrc85WmO1ymAHV9zmo1SIlPWPPR7pt2/zXndgbmEThz5ritHdc3IDH/8US+9QX9RH8=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4642.namprd11.prod.outlook.com (2603:10b6:5:2a2::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 05:39:58 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3174.021; Fri, 10 Jul
 2020 05:39:57 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
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
Thread-Index: AQHWSgRRzB2G/Oy5QEmxCHQWFS0FB6j02KQAgACUCyCAB/5SUIAAxDYAgABLnwCAABmKAIAAAO4wgAAFFYCAAAD78IAASzDwgAB/qYCAAOQrQA==
Date:   Fri, 10 Jul 2020 05:39:57 +0000
Message-ID: <DM5PR11MB1435AA0A724D4A59B56E8CA8C3650@DM5PR11MB1435.namprd11.prod.outlook.com>
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
        <DM5PR11MB143577F0C21EDB82B82EEB35C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
        <DM5PR11MB143584D5A0AAE13E0D2D04B7C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200709082751.320742ab@x1.home>
In-Reply-To: <20200709082751.320742ab@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.206]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e65f010-c4e7-4641-58f5-08d82493ae85
x-ms-traffictypediagnostic: DM6PR11MB4642:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB46420133ABB41480113D0BABC3650@DM6PR11MB4642.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B/XfRb0zs0cg4oiM9qU53h2uufxZSmK952XW/t+2vAB+GrgkU3crGtf+3YseTaHhIN9v7YDt3OLF5eI3GN89xC143KyjA3s7cwhPpYSRczoutpt4AcoLtaXp7+aKgI5ys7hOP5idQJWSYsJsanQV+UistKIWOkoYIeLgVUTWOV9QcDGF10VLLF1DOZVlPvMbC8DfJxYGya7Qr5QYZMhPdzZu8FHR9xYeturMnara7pqGKTquYTGPf3KJdHolzeCS2nNd12fRbSh1prBFFpctwVbYOhGoQh0KHJabsOTesuOVsbIJkvDjqVyp51AAY6xG1OqMKGJAMlcBby2VcYOGzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(376002)(39860400002)(346002)(8936002)(54906003)(316002)(9686003)(66946007)(26005)(2906002)(478600001)(55016002)(66446008)(66476007)(6506007)(66556008)(64756008)(186003)(8676002)(76116006)(86362001)(7416002)(6916009)(33656002)(71200400001)(7696005)(5660300002)(83380400001)(52536014)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: KSSQMjhjiwqmkZpPpqHY4HkVAtR70Rp+hcllknJKetYLMnr9o7Nk6v3sKMGZH0fy9nMZUyZMTv/8iSO+A9TQ52zuxjSk889n+OiU9yKUvhQYZwWlyCYkJpog8BNJAbw9XEfyMshENka3Fn5HQeovWIIjeUBaUeZJqSnMYuvTK2koySMiJuY1U+rnPhjemlBFUG31/TX8tQlJL6mc5fc8VpuNwru6mKqreyIEbW9sGgJA3oxYD/aAf2IC/0kxYCoPP5QdWceFJKfJ75jPa67bFOUuuvprT6HAEXYYsHrC0jMWXHNmhEFr2k497fufKUUrc8svp6VQ+UaNcjTjzgxSajq6xEusZCw2SC/huSD7OxVhuS3Jjxi3PV9hzuh00YeqhS2aM1YGsstYQuePxLqyDfYbkd1ySymmm39SoA2vnEukaRmY4DEVVrgreajpGmuLa0053xLfwrAkk8iCRAQ2utzd/95T9AllxGqBQW3iH9R+TR2oooJ36djKW/DT/Vvx
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e65f010-c4e7-4641-58f5-08d82493ae85
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 05:39:57.8272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeL8kip4IDglF9XPA4hh2E9wxukWgA4XcUPSjm2aJ0BVUuYOhK58D4hBLDl4oeMQYVlRbzEzszQTKmqFQ0JhmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4642
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,=20

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, July 9, 2020 10:28 PM
>=20
> On Thu, 9 Jul 2020 07:16:31 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > Hi Alex,
> >
> > After more thinking, looks like adding a r-b tree is still not enough t=
o
> > solve the potential problem for free a range of PASID in one ioctl. If
> > caller gives [0, MAX_UNIT] in the free request, kernel anyhow should
> > loop all the PASIDs and search in the r-b tree. Even VFIO can track the
> > smallest/largest allocated PASID, and limit the free range to an accura=
te
> > range, it is still no efficient. For example, user has allocated two PA=
SIDs
> > ( 1 and 999), and user gives the [0, MAX_UNIT] range in free request. V=
FIO
> > will limit the free range to be [1, 999], but still needs to loop PASID=
 1 -
> > 999, and search in r-b tree.
>=20
> That sounds like a poor tree implementation.  Look at vfio_find_dma()
> for instance, it returns a node within the specified range.  If the
> tree has two nodes within the specified range we should never need to
> call a search function like vfio_find_dma() more than three times.  We
> call it once, get the first node, remove it.  Call it again, get the
> other node, remove it.  Call a third time, find no matches, we're done.
> So such an implementation limits searches to N+1 where N is the number
> of nodes within the range.

I see. When getting a free range from user. Use the range to find suited
PASIDs in the r-b tree. For the example I mentioned, if giving [0, MAX_UNIT=
],
will find two nodes. If giving [0, 100] range, then only one node will be
found. But even though, it still take some time if the user holds a bunch
of PASIDs and user gives a big free range.

> > So I'm wondering can we fall back to prior proposal which only free one
> > PASID for a free request. how about your opinion?
>=20
> Doesn't it still seem like it would be a useful user interface to have
> a mechanism to free all pasids, by calling with exactly [0, MAX_UINT]?
> I'm not sure if there's another use case for this given than the user
> doesn't have strict control of the pasid values they get.  Thanks,

I don't have such use case neither. perhaps we may allow it in future by
adding flag. but if it's still useful, I may try with your suggestion. :-)

Regards,
Yi Liu

> Alex
>=20
> > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > Sent: Thursday, July 9, 2020 10:26 AM
> > >
> > > Hi Kevin,
> > >
> > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > Sent: Thursday, July 9, 2020 10:18 AM
> > > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Thursday, July 9, 2020 10:08 AM
> > > > >
> > > > > Hi Kevin,
> > > > >
> > > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > > Sent: Thursday, July 9, 2020 9:57 AM
> > > > > >
> > > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > Sent: Thursday, July 9, 2020 8:32 AM
> > > > > > >
> > > > > > > Hi Alex,
> > > > > > >
> > > > > > > > Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > Sent: Thursday, July 9, 2020 3:55 AM
> > > > > > > >
> > > > > > > > On Wed, 8 Jul 2020 08:16:16 +0000 "Liu, Yi L"
> > > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > > >
> > > > > > > > > Hi Alex,
> > > > > > > > >
> > > > > > > > > > From: Liu, Yi L < yi.l.liu@intel.com>
> > > > > > > > > > Sent: Friday, July 3, 2020 2:28 PM
> > > > > > > > > >
> > > > > > > > > > Hi Alex,
> > > > > > > > > >
> > > > > > > > > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > > > > Sent: Friday, July 3, 2020 5:19 AM
> > > > > > > > > > >
> > > > > > > > > > > On Wed, 24 Jun 2020 01:55:19 -0700 Liu Yi L
> > > > > > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > > This patch allows user space to request PASID
> > > > > > > > > > > > allocation/free,
> > > > > e.g.
> > > > > > > > > > > > when serving the request from the guest.
> > > > > > > > > > > >
> > > > > > > > > > > > PASIDs that are not freed by userspace are
> > > > > > > > > > > > automatically freed
> > > > > > > when
> > > > > > > > > > > > the IOASID set is destroyed when process exits.
> > > > > > > > > [...]
> > > > > > > > > > > > +static int vfio_iommu_type1_pasid_request(struct
> > > > > > > > > > > > +vfio_iommu
> > > > > > > *iommu,
> > > > > > > > > > > > +					  unsigned long arg) {
> > > > > > > > > > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > > > > > > > > > +	unsigned long minsz;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	minsz =3D offsetofend(struct
> > > > vfio_iommu_type1_pasid_request,
> > > > > > > > range);
> > > > > > > > > > > > +
> > > > > > > > > > > > +	if (copy_from_user(&req, (void __user *)arg, mins=
z))
> > > > > > > > > > > > +		return -EFAULT;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	if (req.argsz < minsz || (req.flags &
> > > > > > > > ~VFIO_PASID_REQUEST_MASK))
> > > > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > > > +
> > > > > > > > > > > > +	if (req.range.min > req.range.max)
> > > > > > > > > > >
> > > > > > > > > > > Is it exploitable that a user can spin the kernel for=
 a
> > > > > > > > > > > long time in the case of a free by calling this with =
[0,
> > > > > > > > > > > MAX_UINT] regardless of their
> > > > > > > > actual
> > > > > > > > > > allocations?
> > > > > > > > > >
> > > > > > > > > > IOASID can ensure that user can only free the PASIDs
> > > > > > > > > > allocated to the
> > > > > > > user.
> > > > > > > > but
> > > > > > > > > > it's true, kernel needs to loop all the PASIDs within t=
he
> > > > > > > > > > range provided by user.
> > > > > > > > it
> > > > > > > > > > may take a long time. is there anything we can do? one
> > > > > > > > > > thing may limit
> > > > > > > the
> > > > > > > > range
> > > > > > > > > > provided by user?
> > > > > > > > >
> > > > > > > > > thought about it more, we have per-VM pasid quota (say
> > > > > > > > > 1000), so even if user passed down [0, MAX_UNIT], kernel
> > > > > > > > > will only loop the
> > > > > > > > > 1000 pasids at most. do you think we still need to do som=
ething on
> it?
> > > > > > > >
> > > > > > > > How do you figure that?  vfio_iommu_type1_pasid_request()
> > > > > > > > accepts the user's min/max so long as (max > min) and passe=
s
> > > > > > > > that to vfio_iommu_type1_pasid_free(), then to
> > > > > > > > vfio_pasid_free_range() which loops as:
> > > > > > > >
> > > > > > > > 	ioasid_t pasid =3D min;
> > > > > > > > 	for (; pasid <=3D max; pasid++)
> > > > > > > > 		ioasid_free(pasid);
> > > > > > > >
> > > > > > > > A user might only be able to allocate 1000 pasids, but
> > > > > > > > apparently they can ask to free all they want.
> > > > > > > >
> > > > > > > > It's also not obvious to me that calling ioasid_free() is o=
nly
> > > > > > > > allowing the user to free their own passid.  Does it?  It
> > > > > > > > would be a pretty
> > > > > >
> > > > > > Agree. I thought ioasid_free should at least carry a token sinc=
e
> > > > > > the user
> > > > > space is
> > > > > > only allowed to manage PASIDs in its own set...
> > > > > >
> > > > > > > > gaping hole if a user could free arbitrary pasids.  A r-b t=
ree
> > > > > > > > of passids might help both for security and to bound spinni=
ng in a
> loop.
> > > > > > >
> > > > > > > oh, yes. BTW. instead of r-b tree in VFIO, maybe we can add a=
n
> > > > > > > ioasid_set parameter for ioasid_free(), thus to prevent the u=
ser
> > > > > > > from freeing PASIDs that doesn't belong to it. I remember Jac=
ob
> > > > > > > mentioned it
> > > > > before.
> > > > > > >
> > > > > >
> > > > > > check current ioasid_free:
> > > > > >
> > > > > >         spin_lock(&ioasid_allocator_lock);
> > > > > >         ioasid_data =3D xa_load(&active_allocator->xa, ioasid);
> > > > > >         if (!ioasid_data) {
> > > > > >                 pr_err("Trying to free unknown IOASID %u\n", io=
asid);
> > > > > >                 goto exit_unlock;
> > > > > >         }
> > > > > >
> > > > > > Allow an user to trigger above lock paths with MAX_UINT times
> > > > > > might still
> > > > > be bad.
> > > > >
> > > > > yeah, how about the below two options:
> > > > >
> > > > > - comparing the max - min with the quota before calling ioasid_fr=
ee().
> > > > >   If max - min > current quota of the user, then should fail it. =
If
> > > > >   max - min < quota, then call ioasid_free() one by one. still tr=
igger
> > > > >   the above lock path with quota times.
> > > >
> > > > This is definitely wrong. [min, max] is about the range of the PASI=
D
> > > > value, while quota is about the number of allocated PASIDs. It's a =
bit
> > > > weird to mix two together.
> > >
> > > got it.
> > >
> > > > btw what is the main purpose of allowing batch PASID free requests?
> > > > Can we just simplify to allow one PASID in each free just like how =
is
> > > > it done in allocation path?
> > >
> > > it's an intention to reuse the [min, max] range as allocation path. c=
urrently,
> we
> > > don't have such request as far as I can see.
> > >
> > > > >
> > > > > - pass the max and min to ioasid_free(), let ioasid_free() decide=
. should
> > > > >   be able to avoid trigger the lock multiple times, and ioasid ha=
s have a
> > > > >   track on how may PASIDs have been allocated, if max - min is la=
rger than
> > > > >   the allocated number, should fail anyway.
> > > >
> > > > What about Alex's r-b tree suggestion? Is there any downside in you=
 mind?
> > >
> > > no downside, I was just wanting to reuse the tracks in ioasid_set. I =
can add a
> r-b
> > > for allocated PASIDs and find the PASIDs in the r-b tree only do free=
 for the
> > > PASIDs found in r-b tree, others in the range would be ignored.
> > > does it look good?
> > >
> > > Regards,
> > > Yi Liu
> > >
> > > > Thanks,
> > > > Kevin
> >

