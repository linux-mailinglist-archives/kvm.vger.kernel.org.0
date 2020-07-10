Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B571721B5C4
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 15:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgGJNDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 09:03:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:26300 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgGJNDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 09:03:08 -0400
IronPort-SDR: 0lzjiYXp7jzUN5kQqXtpSpyHKtwwWM5kuv+myfXNEAobLlEy8PLH0lzr6sBu/CIFd6bFS5KTjf
 k8QAt/vrgOYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="149659638"
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="149659638"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2020 06:03:07 -0700
IronPort-SDR: Ad9WB9iMZ2mq+eWGxbeLkVTRXDzx78TB5mDNpsuyrEIEzxx38Ubvl+BfCK36SEX5x3agSZTf8T
 yJpo6evtZobQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,335,1589266800"; 
   d="scan'208";a="323540997"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jul 2020 06:03:06 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jul 2020 06:03:06 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 10 Jul 2020 06:03:06 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.50) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 10 Jul 2020 06:03:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cwZG3T6AXiIluWQZwL3Uw0rCHQUqeGASh5Wc03GtwV6oMReiCLAMuSfY+H1c0QWQCUS5jR7SWDVigibyBfE03mVWFyqdSGf/eha7RjewPgHIP60ekkyI41hYJjROLHRMKRfAhJ43NXALic1Za/hwnl7uj4b5TnSVQg725ATOepuGnFmL0fJ4CrLajY+SOnMUqwo5HHbrqqFAJ+MvCsPgZmsnHY0C5hdY0idY9/em48f1dWoxqcgMYolqLu31QW2fF+IBkI3RJGpSLkhXZN8t3QeiNangXyoTqRQcchSROdOJOrEiuZp3aKVgrVP0L5DuGNBXR1WANJrGMsUXAoDzLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aveOQeU0/y9EyLb4Vtzl3wSeC6giGldMyfnC8L0D1eY=;
 b=NOyUFFPD5KsKCnaT12eNGx+1ER/mo9u4OozdFrpVoO9IWhw7MaJvyJ5WdhuZRZxo33Tve9ma0gkDwD+d4Nzu9WqHORWwjOmWYVxMwe/YZthvtMCrPgvU4l+WSxRf8+kPhndJtHZSvYTf5UD4q0Lwxk71yGDkTZOK9v/g/d/hOHDn4HcIhM/dlPIHe9Hqx6Wsv+Myth95mIY7rxfpgKpBgJcx+QHLQIB2sMfonMhGvtoC4x45aEfdl/U9+RcedWEg36sqt02s8l5t8Pmcb3EZUFWSiT3GG3jUV5WAa42iN6sJrbxBvugNm3sg5a7oCd74OzzbA6fYljc7+XcikulRpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aveOQeU0/y9EyLb4Vtzl3wSeC6giGldMyfnC8L0D1eY=;
 b=q51Fyo698moz+ZSm92fI7/j08JmYwiFfZez36n0IlnPzHWhNXjlQobcKw/PAR06pZ3xCFREj7K1ZSIvEn6EmWH1uoSp8Kixn7T59hbd/wSfLpuZcZGwI21/LY6rOPWKPRLkOVYJaGcKmOTCLnIURkQMceDwuYWHffo9wsMrNzYk=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB0025.namprd11.prod.outlook.com (2603:10b6:4:63::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3153.22; Fri, 10 Jul 2020 13:03:04 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3174.023; Fri, 10 Jul
 2020 13:03:04 +0000
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
Thread-Index: AQHWSgRRzB2G/Oy5QEmxCHQWFS0FB6j02KQAgACUCyCAB/5SUIAAxDYAgABLnwCAABmKAIAAAO4wgAAFFYCAAAD78IAASzDwgAB/qYCAAOQrQIAAlDkAgAACCBA=
Date:   Fri, 10 Jul 2020 13:03:03 +0000
Message-ID: <DM5PR11MB1435D0686B10A833A2687515C3650@DM5PR11MB1435.namprd11.prod.outlook.com>
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
        <DM5PR11MB1435AA0A724D4A59B56E8CA8C3650@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200710065500.2478db37@x1.home>
In-Reply-To: <20200710065500.2478db37@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6f97b9f-499f-4768-1216-08d824d1952d
x-ms-traffictypediagnostic: DM5PR11MB0025:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB0025CC13059CBCF01BD6BEB6C3650@DM5PR11MB0025.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 046060344D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LCZxVCRup5N41Sxf4BTFzbxdshdBegFATQ8hB2BJwkOhjSwrTPnpqVfzHj5VR/7q29hxmF0uI6CnG1n3Xi6kqVJxQL49QtSfKIAtwcVgIUJSavllRxNqhb4up6KYqEjmMWy+r/S3W4IaNgeh7CHuUGVAnCaF4BFMZJJe13SQ8YV69OUp9USjLMsanjBeGF/bjvFl7GR8L+Kbs/Gt5+fnPjh0Z5Z14y0z6cci5c2E0/m90KVP/TOhmZaMJOR4rjIM0omzQ9I7OZxZ8QatDigZ8kGjhCa4WKdrhMDfLXZ8jjZ/T4Mu6g4H+goarfsGvRTIPXExg4fHKVRq6luAzhjdQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(33656002)(2906002)(71200400001)(6916009)(26005)(6506007)(66946007)(8676002)(86362001)(30864003)(7696005)(52536014)(316002)(83380400001)(7416002)(54906003)(66446008)(64756008)(186003)(55016002)(5660300002)(66556008)(478600001)(66476007)(4326008)(8936002)(76116006)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: o7izvSx9xZKpUCztUHtOkOQ/QBUj+1fNnherLcHPXxMklR+OYGKgfMBw3rYX9kbHKKGqlf8jEpYeqtcNSKFXf1syYkg7UAXKDdLF6VuDwnnPbISDVshpDjsk40YOkFav2zyBQgVjJ2jrPt0yXfH8OVnwBN/2MwL10SSdnweqOpfZIMZbE4yTTfgjUhL+QRrFEy8r/1oniXe76QGiej0dfdoPMLS+IibJOg98om8+5m+Kte6DMqOZwl+M2tezudqxsoaRiwpCYWisIhiaFikuAKqwYRhFEIOt0sM0Rb1b6UNQqWBE4enK+CPRgFhP/xmWvkltddWR45d7wT6pwNBXrpX1bbWryfOM9WLQgCSJfgXVwhe+ncbc5pmBeZEu0bysWtZlLr/cGOnhKjZg6WahsNbGeFeidMzJnxBxa3QL4irD6bPH/xJ+yg0tBuE/knwAl8ubTv3x0rDBsmXb08K46DE4xgycdjUgxD949tcroiDbkip0SBP+qeeyGXvkflx5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f97b9f-499f-4768-1216-08d824d1952d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2020 13:03:03.9790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J4rjXK8Wa+G/echB5hMfAcoOZr93WffZj+Pt08m+5QNH7jXV7zZ0X1lJ9Rzpe640q/iEUPGCMLxsltqy+gCSUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0025
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, July 10, 2020 8:55 PM
>=20
> On Fri, 10 Jul 2020 05:39:57 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > Hi Alex,
> >
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, July 9, 2020 10:28 PM
> > >
> > > On Thu, 9 Jul 2020 07:16:31 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >
> > > > Hi Alex,
> > > >
> > > > After more thinking, looks like adding a r-b tree is still not enou=
gh to
> > > > solve the potential problem for free a range of PASID in one ioctl.=
 If
> > > > caller gives [0, MAX_UNIT] in the free request, kernel anyhow shoul=
d
> > > > loop all the PASIDs and search in the r-b tree. Even VFIO can track=
 the
> > > > smallest/largest allocated PASID, and limit the free range to an ac=
curate
> > > > range, it is still no efficient. For example, user has allocated tw=
o PASIDs
> > > > ( 1 and 999), and user gives the [0, MAX_UNIT] range in free reques=
t. VFIO
> > > > will limit the free range to be [1, 999], but still needs to loop P=
ASID 1 -
> > > > 999, and search in r-b tree.
> > >
> > > That sounds like a poor tree implementation.  Look at vfio_find_dma()
> > > for instance, it returns a node within the specified range.  If the
> > > tree has two nodes within the specified range we should never need to
> > > call a search function like vfio_find_dma() more than three times.  W=
e
> > > call it once, get the first node, remove it.  Call it again, get the
> > > other node, remove it.  Call a third time, find no matches, we're don=
e.
> > > So such an implementation limits searches to N+1 where N is the numbe=
r
> > > of nodes within the range.
> >
> > I see. When getting a free range from user. Use the range to find suite=
d
> > PASIDs in the r-b tree. For the example I mentioned, if giving [0, MAX_=
UNIT],
> > will find two nodes. If giving [0, 100] range, then only one node will =
be
> > found. But even though, it still take some time if the user holds a bun=
ch
> > of PASIDs and user gives a big free range.
>=20
>=20
> But that time is bounded.  The complexity of the tree and maximum
> number of operations on the tree are bounded by the number of nodes,
> which is bound by the user's pasid quota.  Thanks,

yes, let me try it. thanks. :-)

Regards,
Yi Liu

> Alex
>=20
> > > > So I'm wondering can we fall back to prior proposal which only free=
 one
> > > > PASID for a free request. how about your opinion?
> > >
> > > Doesn't it still seem like it would be a useful user interface to hav=
e
> > > a mechanism to free all pasids, by calling with exactly [0, MAX_UINT]=
?
> > > I'm not sure if there's another use case for this given than the user
> > > doesn't have strict control of the pasid values they get.  Thanks,
> >
> > I don't have such use case neither. perhaps we may allow it in future b=
y
> > adding flag. but if it's still useful, I may try with your suggestion. =
:-)
> >
> > Regards,
> > Yi Liu
> >
> > > Alex
> > >
> > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > Sent: Thursday, July 9, 2020 10:26 AM
> > > > >
> > > > > Hi Kevin,
> > > > >
> > > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > > Sent: Thursday, July 9, 2020 10:18 AM
> > > > > >
> > > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > Sent: Thursday, July 9, 2020 10:08 AM
> > > > > > >
> > > > > > > Hi Kevin,
> > > > > > >
> > > > > > > > From: Tian, Kevin <kevin.tian@intel.com>
> > > > > > > > Sent: Thursday, July 9, 2020 9:57 AM
> > > > > > > >
> > > > > > > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > > > > > > Sent: Thursday, July 9, 2020 8:32 AM
> > > > > > > > >
> > > > > > > > > Hi Alex,
> > > > > > > > >
> > > > > > > > > > Alex Williamson <alex.williamson@redhat.com>
> > > > > > > > > > Sent: Thursday, July 9, 2020 3:55 AM
> > > > > > > > > >
> > > > > > > > > > On Wed, 8 Jul 2020 08:16:16 +0000 "Liu, Yi L"
> > > > > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > > > > >
> > > > > > > > > > > Hi Alex,
> > > > > > > > > > >
> > > > > > > > > > > > From: Liu, Yi L < yi.l.liu@intel.com>
> > > > > > > > > > > > Sent: Friday, July 3, 2020 2:28 PM
> > > > > > > > > > > >
> > > > > > > > > > > > Hi Alex,
> > > > > > > > > > > >
> > > > > > > > > > > > > From: Alex Williamson <alex.williamson@redhat.com=
>
> > > > > > > > > > > > > Sent: Friday, July 3, 2020 5:19 AM
> > > > > > > > > > > > >
> > > > > > > > > > > > > On Wed, 24 Jun 2020 01:55:19 -0700 Liu Yi L
> > > > > > > > > > > > > <yi.l.liu@intel.com> wrote:
> > > > > > > > > > > > >
> > > > > > > > > > > > > > This patch allows user space to request PASID
> > > > > > > > > > > > > > allocation/free,
> > > > > > > e.g.
> > > > > > > > > > > > > > when serving the request from the guest.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > PASIDs that are not freed by userspace are
> > > > > > > > > > > > > > automatically freed
> > > > > > > > > when
> > > > > > > > > > > > > > the IOASID set is destroyed when process exits.
> > > > > > > > > > > [...]
> > > > > > > > > > > > > > +static int vfio_iommu_type1_pasid_request(stru=
ct
> > > > > > > > > > > > > > +vfio_iommu
> > > > > > > > > *iommu,
> > > > > > > > > > > > > > +					  unsigned long
> arg) {
> > > > > > > > > > > > > > +	struct vfio_iommu_type1_pasid_request req;
> > > > > > > > > > > > > > +	unsigned long minsz;
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +	minsz =3D offsetofend(struct
> > > > > > vfio_iommu_type1_pasid_request,
> > > > > > > > > > range);
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +	if (copy_from_user(&req, (void __user *)arg,
> minsz))
> > > > > > > > > > > > > > +		return -EFAULT;
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +	if (req.argsz < minsz || (req.flags &
> > > > > > > > > > ~VFIO_PASID_REQUEST_MASK))
> > > > > > > > > > > > > > +		return -EINVAL;
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +	if (req.range.min > req.range.max)
> > > > > > > > > > > > >
> > > > > > > > > > > > > Is it exploitable that a user can spin the kernel=
 for a
> > > > > > > > > > > > > long time in the case of a free by calling this w=
ith [0,
> > > > > > > > > > > > > MAX_UINT] regardless of their
> > > > > > > > > > actual
> > > > > > > > > > > > allocations?
> > > > > > > > > > > >
> > > > > > > > > > > > IOASID can ensure that user can only free the PASID=
s
> > > > > > > > > > > > allocated to the
> > > > > > > > > user.
> > > > > > > > > > but
> > > > > > > > > > > > it's true, kernel needs to loop all the PASIDs with=
in the
> > > > > > > > > > > > range provided by user.
> > > > > > > > > > it
> > > > > > > > > > > > may take a long time. is there anything we can do? =
one
> > > > > > > > > > > > thing may limit
> > > > > > > > > the
> > > > > > > > > > range
> > > > > > > > > > > > provided by user?
> > > > > > > > > > >
> > > > > > > > > > > thought about it more, we have per-VM pasid quota (sa=
y
> > > > > > > > > > > 1000), so even if user passed down [0, MAX_UNIT], ker=
nel
> > > > > > > > > > > will only loop the
> > > > > > > > > > > 1000 pasids at most. do you think we still need to do=
 something
> on
> > > it?
> > > > > > > > > >
> > > > > > > > > > How do you figure that?  vfio_iommu_type1_pasid_request=
()
> > > > > > > > > > accepts the user's min/max so long as (max > min) and p=
asses
> > > > > > > > > > that to vfio_iommu_type1_pasid_free(), then to
> > > > > > > > > > vfio_pasid_free_range() which loops as:
> > > > > > > > > >
> > > > > > > > > > 	ioasid_t pasid =3D min;
> > > > > > > > > > 	for (; pasid <=3D max; pasid++)
> > > > > > > > > > 		ioasid_free(pasid);
> > > > > > > > > >
> > > > > > > > > > A user might only be able to allocate 1000 pasids, but
> > > > > > > > > > apparently they can ask to free all they want.
> > > > > > > > > >
> > > > > > > > > > It's also not obvious to me that calling ioasid_free() =
is only
> > > > > > > > > > allowing the user to free their own passid.  Does it?  =
It
> > > > > > > > > > would be a pretty
> > > > > > > >
> > > > > > > > Agree. I thought ioasid_free should at least carry a token =
since
> > > > > > > > the user
> > > > > > > space is
> > > > > > > > only allowed to manage PASIDs in its own set...
> > > > > > > >
> > > > > > > > > > gaping hole if a user could free arbitrary pasids.  A r=
-b tree
> > > > > > > > > > of passids might help both for security and to bound sp=
inning in a
> > > loop.
> > > > > > > > >
> > > > > > > > > oh, yes. BTW. instead of r-b tree in VFIO, maybe we can a=
dd an
> > > > > > > > > ioasid_set parameter for ioasid_free(), thus to prevent t=
he user
> > > > > > > > > from freeing PASIDs that doesn't belong to it. I remember=
 Jacob
> > > > > > > > > mentioned it
> > > > > > > before.
> > > > > > > > >
> > > > > > > >
> > > > > > > > check current ioasid_free:
> > > > > > > >
> > > > > > > >         spin_lock(&ioasid_allocator_lock);
> > > > > > > >         ioasid_data =3D xa_load(&active_allocator->xa, ioas=
id);
> > > > > > > >         if (!ioasid_data) {
> > > > > > > >                 pr_err("Trying to free unknown IOASID %u\n"=
, ioasid);
> > > > > > > >                 goto exit_unlock;
> > > > > > > >         }
> > > > > > > >
> > > > > > > > Allow an user to trigger above lock paths with MAX_UINT tim=
es
> > > > > > > > might still
> > > > > > > be bad.
> > > > > > >
> > > > > > > yeah, how about the below two options:
> > > > > > >
> > > > > > > - comparing the max - min with the quota before calling ioasi=
d_free().
> > > > > > >   If max - min > current quota of the user, then should fail =
it. If
> > > > > > >   max - min < quota, then call ioasid_free() one by one. stil=
l trigger
> > > > > > >   the above lock path with quota times.
> > > > > >
> > > > > > This is definitely wrong. [min, max] is about the range of the =
PASID
> > > > > > value, while quota is about the number of allocated PASIDs. It'=
s a bit
> > > > > > weird to mix two together.
> > > > >
> > > > > got it.
> > > > >
> > > > > > btw what is the main purpose of allowing batch PASID free reque=
sts?
> > > > > > Can we just simplify to allow one PASID in each free just like =
how is
> > > > > > it done in allocation path?
> > > > >
> > > > > it's an intention to reuse the [min, max] range as allocation pat=
h. currently,
> > > we
> > > > > don't have such request as far as I can see.
> > > > >
> > > > > > >
> > > > > > > - pass the max and min to ioasid_free(), let ioasid_free() de=
cide.
> should
> > > > > > >   be able to avoid trigger the lock multiple times, and ioasi=
d has have a
> > > > > > >   track on how may PASIDs have been allocated, if max - min i=
s larger
> than
> > > > > > >   the allocated number, should fail anyway.
> > > > > >
> > > > > > What about Alex's r-b tree suggestion? Is there any downside in=
 you
> mind?
> > > > >
> > > > > no downside, I was just wanting to reuse the tracks in ioasid_set=
. I can add
> a
> > > r-b
> > > > > for allocated PASIDs and find the PASIDs in the r-b tree only do =
free for
> the
> > > > > PASIDs found in r-b tree, others in the range would be ignored.
> > > > > does it look good?
> > > > >
> > > > > Regards,
> > > > > Yi Liu
> > > > >
> > > > > > Thanks,
> > > > > > Kevin
> > > >
> >

