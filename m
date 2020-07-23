Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC56422ABDE
	for <lists+kvm@lfdr.de>; Thu, 23 Jul 2020 11:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726737AbgGWJkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jul 2020 05:40:47 -0400
Received: from mga03.intel.com ([134.134.136.65]:64244 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726127AbgGWJkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jul 2020 05:40:47 -0400
IronPort-SDR: qKt5CTzkLXPDsFSIHDAmPs8qBHQbqNkk2RhIZXbF9gqYUvDlWfrTmER9dFw0GK+oqvo/OzgchO
 YeK7/FzM8gtA==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="150476717"
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="150476717"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 02:40:44 -0700
IronPort-SDR: +xtQR/r0uRc1gHsVvOGLj6wxk5U4ad/sqHAPs0PrDQQpFUDNoCNuumw5WCVjqNZN1RV2K1Anfo
 h0AyWnQXqzEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="392946921"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga001.fm.intel.com with ESMTP; 23 Jul 2020 02:40:44 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 23 Jul 2020 02:40:44 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.59) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 23 Jul 2020 02:40:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PadLGx9TvR+zjhLzUOEcpTpo6TpTb44k6wAmx4mM2VwS94X6Xj7O5KhsPpUedBAuasIUqerakpnehxFEX1tNjlyXj9VeNVl93g78XvRO2HMtQn3Jhdxbv68thcg7MJtknhimapLgCKFZgcvY8IhNvEMAO74fXOXTHLQ4kNCLOiBfzYN5JDpiVLz5M2Po72MXzbko3VGHNN66ZyHPrVZJ9LBNHmwyjAMm6W8+3zzBahTtQUzncz9xSKgWI3KHT8yAsaJ8MnGOItqsY9UhaBQa8KQSLT9GxZcwQ2gF6AGmG3fuKI864+XxtZc8nMyT44dtMh9Jsw1ZbijEIbhDbcVHaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rtlCqbDyLxswE0OFeouNvuxjzC7AFhLEZ2qzaaRMTo=;
 b=LvIkh+4i3RvEqMEx4VqG5mCCpZoEahgIRi2zcu/TFAPnos70GvcUUL56BmMEig7/oodAbn76aO3NktcxmK3EKNWCpoYJzb3YTbBFvsEu66kUT2hPzEOIiehyiexZ0tUDbMllBNUiObBUPOZYE2aw1p4XBUR89P/sV++LJHPDDACjizASPnWCVlVX0oQToUJ2uX6+MIFQKdAYa2gdMjG3rOAaPVizq0O6JLIPumdfhskcw6OL9YGDhMzZ6o+W0pVyDWNZpVb9g8G2JYhqe8ONIpL1mp5gXvzFEbXxc20B7ueW+mA3AIYUjDWxzHvRcwQzI70aS+WnQDmtiA/7pTnJew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rtlCqbDyLxswE0OFeouNvuxjzC7AFhLEZ2qzaaRMTo=;
 b=E0t7zBFcn3O2np3okAiFfipQpVwRrnvhXAbBKWP0hx15Pst2xTiS+/O3I8fNOJAjAsapxFHLl/Qk6rxlnrA7VKTQeRIjNiK2FFi56BlWxf1b8Hi39OGlSudQ8cXKZ5jWzOfZ/HTZQrPW2dAGYnTk5rkIRqSQiCE7Z0Kq9PQMQcg=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM5PR11MB1578.namprd11.prod.outlook.com (2603:10b6:4:e::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.23; Thu, 23 Jul 2020 09:40:43 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3216.020; Thu, 23 Jul
 2020 09:40:42 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Will Deacon <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: RE: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Topic: [PATCH v5 03/15] iommu/smmu: Report empty domain nesting info
Thread-Index: AQHWWD2lVc+q/avNRU2WMQZyTvsTFakFfrYAgAFdguCAA4IGgIAKm0cw
Date:   Thu, 23 Jul 2020 09:40:42 +0000
Message-ID: <DM5PR11MB1435B0B62ABD24F06A4D5BF2C3760@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-4-git-send-email-yi.l.liu@intel.com>
 <20200713131454.GA2739@willie-the-truck>
 <CY4PR11MB1432226D0A52D099249E95A0C3610@CY4PR11MB1432.namprd11.prod.outlook.com>
 <20200716153959.GA447208@myrica>
In-Reply-To: <20200716153959.GA447208@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebfddcf2-44aa-4e82-b9b6-08d82eec77cb
x-ms-traffictypediagnostic: DM5PR11MB1578:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB15783542EB99DBD3859045DDC3760@DM5PR11MB1578.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ljRiQpH5KwTeY2+FM8syk7IiC01BWLrB3ewgTCJP9L3zjccrYm+w5ds3fAv1MJruQ1D7o/5kV1jQ0cXPcRpaqFVgtn5mwsx7fa60RnFduuhCzeThHehuVsMiaF/2+am0iK2WZoZxaQh3mfDOx5dvBSnOKeJAFBs1CqMIlYQvd2048xD5U3LFsfV0XLPOoYaW3qrkpHebygdfjDk5Kta98mTc/QUiAlmueNaWTD/4vI0qUBzkXBsetkXN9KH1RomYouPcxbX/srKOBuF2UTS3GizItcstT7BGQsqIGRKiv2//shg/+cOSw66xAu7WmXHkzWFQCbpg1JdpBULvIj1GXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(7696005)(26005)(478600001)(6506007)(186003)(71200400001)(83380400001)(66476007)(66446008)(64756008)(66556008)(5660300002)(33656002)(76116006)(55016002)(8936002)(8676002)(6916009)(4326008)(316002)(54906003)(86362001)(7416002)(9686003)(66946007)(2906002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HzFJA4JlNZUIq05gvRmvla34bC1SV5oPsxX3SVpqwnTMFcvTKSViWrPscOZGijaXR3N+kzVBq6ksYCuNBSKyo8sGvOPkn+dffjMcCzsSYo/M3OMXsm2u7ITJJX1kr0/L3gfrq31jF4szYxYnka08uR31naCI+qC0ezbVbhZUSoKEGLWrLHCm1eb+nTy0b2oyKglVIW59GonsKdmwoTfK1lN2vTCOU3sDgQveo2qXKMvXdGLrxhn+iIlASLWDWRz4IKvqTprbkWKOvHtIypBGIcDZRFeGuWzR2ItDtzNTrKcSCKNDgaQZDXq4r9BqQUXfLEOqNKlrEpIVBqRJCjIjsAR5fznJAmoXAlwo13NXca2ORxbUuNKjMDGLY1nXKxLEbe1awp9jkvLd292PlGikRrL73EUvT5vvFyUbjQLDACfwFh+b3TU7yh+uCk3cDD29cJFqJK1kHJVOtWhbNRa/chm3+X/zxMvXA2E0/PUVRUT1Je3lPNymbXzVeJEBbQyG
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebfddcf2-44aa-4e82-b9b6-08d82eec77cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 09:40:42.8035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wW/WRxdANI2+4htiJXflxa+gn7O3qu0hEJ/YfWaphRTMxIt2k4xLZTVpLjbLDckn5XVgYCjZnzmvTfTvGxmjrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1578
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Thursday, July 16, 2020 11:40 PM
>=20
> On Tue, Jul 14, 2020 at 10:12:49AM +0000, Liu, Yi L wrote:
> > > Have you verified that this doesn't break the existing usage of
> > > DOMAIN_ATTR_NESTING in drivers/vfio/vfio_iommu_type1.c?
> >
> > I didn't have ARM machine on my hand. But I contacted with Jean
> > Philippe, he confirmed no compiling issue. I didn't see any code
> > getting DOMAIN_ATTR_NESTING attr in current drivers/vfio/vfio_iommu_typ=
e1.c.
> > What I'm adding is to call iommu_domai_get_attr(, DOMAIN_ATTR_NESTIN)
> > and won't fail if the iommu_domai_get_attr() returns 0. This patch
> > returns an empty nesting info for DOMAIN_ATTR_NESTIN and return
> > value is 0 if no error. So I guess it won't fail nesting for ARM.
>=20
> I confirm that this series doesn't break the current support for
> VFIO_IOMMU_TYPE1_NESTING with an SMMUv3. That said...

thanks.

> If the SMMU does not support stage-2 then there is a change in behavior
> (untested): after the domain is silently switched to stage-1 by the SMMU
> driver, VFIO will now query nesting info and obtain -ENODEV. Instead of
> succeding as before, the VFIO ioctl will now fail. I believe that's a fix
> rather than a regression, it should have been like this since the
> beginning. No known userspace has been using VFIO_IOMMU_TYPE1_NESTING so
> far, so I don't think it should be a concern.
>=20
> And if userspace queries the nesting properties using the new ABI
> introduced in this patchset, it will obtain an empty struct.

yes.

> I think
> that's acceptable, but it may be better to avoid adding the nesting cap i=
f
> @format is 0?

right. will add it in patch 4/15.

Regards,
Yi Liu

>=20
> Thanks,
> Jean
>=20
> >
> > @Eric, how about your opinion? your dual-stage vSMMU support may
> > also share the vfio_iommu_type1.c code.
> >
> > Regards,
> > Yi Liu
> >
> > > Will
