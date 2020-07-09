Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1868219503
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGIAZa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 20:25:30 -0400
Received: from mga03.intel.com ([134.134.136.65]:51589 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgGIAZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 20:25:29 -0400
IronPort-SDR: BoFjfH487WOSE3uWY5QodZM5viEaRcnHNRbTkociKsVUBtEoDf+jpJWmFS/Z5LSNPpH4J8Y9zw
 vGYEA5x2vOhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="147914120"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="147914120"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 17:25:28 -0700
IronPort-SDR: Kr5B9Tdnqi+cRaF1YwtsgSftIM5OrSE7ar0qI1ai1u3F9SscXCwt9Z6krC07i3NCDAz2AYlgWm
 mu3T4+I0pQ/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="484070057"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 08 Jul 2020 17:25:27 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jul 2020 17:25:27 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jul 2020 17:25:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 17:25:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJ3w7homGaaCjsrxC4GevIjVaMnav/5cs75/3+e/ReAsJ1TGpQ8Z4ghVOFhyTr2UM1UkWBp2PX3qNDKU8p8vbpxVohFdsvF/W3RzAN8Qx7XkR/wDCy5NKh7cUGOhdS3AET0ShsOclwqvOsFMfnQ5HCMUZSaMpklwnlKPgfsnWsmu24vGFJ1nnPC3l0Qvqwuf4dTr+irt6jNIqnCqvgSy1LnRNE/r9iRgklCvuAHVmP4jYlqQtDJE/rgG1A0mfx45EA+UcYeFZ7oXEDSqdfS36J9f8LGwxMIv+0vfzKS5XLx04QFLZxAae/nVgoL9cUPoy6gV3iM5kc0gxPTRGrWlgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkTC9Dvi2fktYC9GiqF4Keg85CwM2UCbqvKfttq0NEw=;
 b=bQkpfJpdNcArg6SjudYkL25w97TwTIf82Nf8HGFMhacXprGlwrR0bLCvB67rqd1axeztadtV7u+WOuyGmg3Ju+DM9+s2SN+vwQfQ8vdN6e65E5lluLR2RzTlQ2Fn/nNVuKJUTJYO1UGnJt04uTUcWqLbuvAS1/8W97kcuxyqz+gG01ubrgKq2df2GiGFOFLQaxEW1ztrzmeMQzkTDcg7I+KxJQ47fLesOzJlP4ynosFhpeosGT/bBXAFI7zQDx7W+q03TfZkJq5a/AvMy8WJkNj9QwXy2d9WvxiijlFhoOGaMh/IcoUcgRO/QGkGqGcVwH3bmMpFZOiITdRGIyOmew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkTC9Dvi2fktYC9GiqF4Keg85CwM2UCbqvKfttq0NEw=;
 b=ZjtPLADESNZ5E7y/82z9x1wIdno7BVfIpdXtTiCglzN9RctYMocI6FMuQGHMKsx/VgZqBU3iG1HyXk4t5+b9fBViRnoeMWJCbS0Yue3mykwARi0OeJe5S/1Kql21chUJXIe8VNUVGXwt3Ui2PViW5MvwABnnkWlPxD2GyCTttTI=
Received: from DM5PR11MB1435.namprd11.prod.outlook.com (2603:10b6:4:7::18) by
 DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Thu, 9 Jul 2020 00:25:24 +0000
Received: from DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364]) by DM5PR11MB1435.namprd11.prod.outlook.com
 ([fe80::9002:97a2:d8c0:8364%10]) with mapi id 15.20.3174.021; Thu, 9 Jul 2020
 00:25:24 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Auger Eric <eric.auger@redhat.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 04/15] vfio/type1: Report iommu nesting info to
 userspace
Thread-Topic: [PATCH v4 04/15] vfio/type1: Report iommu nesting info to
 userspace
Thread-Index: AQHWUfUbywl8Q+WBl0+9l/PlGyuXiKj6XuYAgAAkWACAABBDgIABSlsAgAF6DCCAAMB1gIAAUfiA
Date:   Thu, 9 Jul 2020 00:25:24 +0000
Message-ID: <DM5PR11MB1435130A8C66F625F0F34C79C3640@DM5PR11MB1435.namprd11.prod.outlook.com>
References: <1593861989-35920-1-git-send-email-yi.l.liu@intel.com>
        <1593861989-35920-5-git-send-email-yi.l.liu@intel.com>
        <d434cbcc-d3b1-d11d-0304-df2d2c93efa0@redhat.com>
        <DM5PR11MB1435290B6CD561EC61027892C3690@DM5PR11MB1435.namprd11.prod.outlook.com>
        <94b4e5d3-8d24-9a55-6bee-ed86f3846996@redhat.com>
        <DM5PR11MB14357A5953EB630A58FF568EC3660@DM5PR11MB1435.namprd11.prod.outlook.com>
        <DM5PR11MB143531E2B54ED82FB0649F8CC3670@DM5PR11MB1435.namprd11.prod.outlook.com>
 <20200708132947.5b7ee954@x1.home>
In-Reply-To: <20200708132947.5b7ee954@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [117.169.230.114]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36b34070-84d4-4276-317e-08d8239e92a4
x-ms-traffictypediagnostic: DM6PR11MB4202:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB42024D1DA1245083ACF1639FC3640@DM6PR11MB4202.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AMduDzg8PjFi8/IEAgxC7aEhZSDgYtFZnaSaA3j39s1gRL2r3rW+s91HN+ZJ+SzFMs4YHSh5UsYI6AgkTLgHiomcGi7IV0MjKuksLhOLx2PEMZF5DptcQrvIsRSFJycxtVqgv0FqlyWbF31Sf5QAbrFtIwhRwftii11ybsbNbHKQtI1jgibMtWx0CicEKTulNwzGMzK2dM0DUS3CWJK+sz7ta6hgjKE7WvLaP0vFMbGs3J2qttR24sSCWs7xVtfEy7D2sOC5oHAxdSC5JonK2j7aipVxkc00RlDKp4giNZMt2HVDulB3vWEvBJzrvzZXxXtZomlNmnrB5pGdi7tOVQ2ISUffYl1V/iIibksWAMUwINVqJPVB+FvdImYz25EgOaiY1gMfszbF20I+ky7lEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(8676002)(86362001)(66946007)(33656002)(7416002)(76116006)(54906003)(316002)(478600001)(4326008)(9686003)(8936002)(7696005)(52536014)(186003)(26005)(66446008)(64756008)(45080400002)(5660300002)(2906002)(66476007)(71200400001)(6916009)(66556008)(6506007)(966005)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ll6I4Adm6LQTVXqiKDW3RYDLvj3IfOZhCFgZWbD8e4Erx+aklOa8mTqpTv5BUx6W41PEvDG7pKecPfYZnjabPzJuJ2oO9lMF/3Vx7ZADzX8cenUEkeTmcAoaisMnCw4WLrJVnWPn5HaLg6Uiju6gom8TassmYdJrYPaosBA9/+Twjm9xE7Fn4WQHpcu+DwwlCP/6qCCOT79+uaWKqAbouxTmtwfWNvWi+CqieqFa69N4Y5pdI/1iO3r66SI1WcdiOrMziazyh9AlTvdY1paHWuteMwJ6nWe7koq7Qvwhukfb17hmHYFPAZxdkSRnKnCT+cWKWh8Dqol5a0xsBOQq3h4SuaEP5sJwmGfDutQoDToxev63y4D8VFvdZKj7in6QynrZ7XnBLCBi6o3CO38DiGHni4DA/J3hkF22aVOX5xbvq+JrTE0njo8Ik7veG+nIneRqgdBgahEoJ/pwnOv5GgTTXo5cHQ3YKwCqipyjj7lO9ip3LWwbQxkFRJYT0idr
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b34070-84d4-4276-317e-08d8239e92a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2020 00:25:24.3834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i2J2MFqjLy70aN9SEiNBZCAlyojVbBjmo/EJIl/TrBJq7Z4+wGS5g6CH/qm+rcRLGX887rvGET3RViX78mQtfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4202
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, July 9, 2020 3:30 AM
>=20
> On Wed, 8 Jul 2020 08:08:40 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>=20
> > Hi Alex,
> >
> > Eric asked if we will to have data strcut other than struct iommu_nesti=
ng_info
> > type in the struct vfio_iommu_type1_info_cap_nesting @info[] field. I'm=
 not
> > quit sure on it. I guess the answer may be not as VFIO's nesting suppor=
t should
> > based on IOMMU UAPI. how about your opinion?
> >
> > +#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  3
> > +
> > +/*
> > + * Reporting nesting info to user space.
> > + *
> > + * @info:	the nesting info provided by IOMMU driver. Today
> > + *		it is expected to be a struct iommu_nesting_info
> > + *		data.
> > + */
> > +struct vfio_iommu_type1_info_cap_nesting {
> > +	struct	vfio_info_cap_header header;
> > +	__u32	flags;
> > +	__u32	padding;
> > +	__u8	info[];
> > +};
>=20
> It's not a very useful uAPI if the user can't be sure what they're
> getting out of it.  Info capabilities are "cheap", they don't need to
> be as extensible as an ioctl.  It's not clear that we really even need
> the flags (and therefore the padding), just define it to return the
> IOMMU uAPI structure with no extensibility.  If we need to expose
> something else, create a new capability.  Thanks,

thanks for the guiding, then I may embed the struct iommu_nesting_info
here. :-)

Regards,
Yi Liu

> Alex
>=20
> >
> > https://lore.kernel.org/linux-
> iommu/DM5PR11MB1435290B6CD561EC61027892C3690@DM5PR11MB1435.nam
> prd11.prod.outlook.com/
> >
> > Regards,
> > Yi Liu
> >
> > > From: Liu, Yi L
> > > Sent: Tuesday, July 7, 2020 5:32 PM
> > >
> > [...]
> > > > >
> > > > >>> +
> > > > >>> +/*
> > > > >>> + * Reporting nesting info to user space.
> > > > >>> + *
> > > > >>> + * @info:	the nesting info provided by IOMMU driver. Today
> > > > >>> + *		it is expected to be a struct iommu_nesting_info
> > > > >>> + *		data.
> > > > >> Is it expected to change?
> > > > >
> > > > > honestly, I'm not quite sure on it. I did considered to embed str=
uct
> > > > > iommu_nesting_info here instead of using info[]. but I hesitated =
as
> > > > > using info[] may leave more flexibility on this struct. how about
> > > > > your opinion? perhaps it's fine to embed the struct
> > > > > iommu_nesting_info here as long as VFIO is setup nesting based on
> > > > > IOMMU UAPI.
> > > > >
> > > > >>> + */
> > > > >>> +struct vfio_iommu_type1_info_cap_nesting {
> > > > >>> +	struct	vfio_info_cap_header header;
> > > > >>> +	__u32	flags;
> > > > >> You may document flags.
> > > > >
> > > > > sure. it's reserved for future.
> > > > >
> > > > > Regards,
> > > > > Yi Liu
> > > > >
> > > > >>> +	__u32	padding;
> > > > >>> +	__u8	info[];
> > > > >>> +};
> > > > >>> +
> > > > >>>  #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
> > > > >>>
> > > > >>>  /**
> > > > >>>
> > > > >> Thanks
> > > > >>
> > > > >> Eric
> > > > >
> >

