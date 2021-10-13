Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D37F42B873
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 09:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhJMHJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 03:09:48 -0400
Received: from mga02.intel.com ([134.134.136.20]:15383 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhJMHJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 03:09:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="214516782"
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="214516782"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 00:07:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,369,1624345200"; 
   d="scan'208";a="460674249"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 13 Oct 2021 00:07:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 00:07:44 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 13 Oct 2021 00:07:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 13 Oct 2021 00:07:43 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 13 Oct 2021 00:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROpxqmuZimSElWhqz2Ptm2U+t65UqfrvBLzcLGZfET+U4yoJNbuLlt9QbiaQ5f1iWULaEeSURcR7fSSgwAEuuWhSlW2W5vF4dSe1kL3WL2ceKQJEqOtGOkBPdBlEZkW+RjsAAfag7QDn1oJ+9uj9HvLszrBkMv/bBlLkXLFOji1Iyt9T3zO+TRgZXrOS/A+4UU4ORdRinG5nLCMG1GGzBVZX5GmUQHwllh7QepFlrIDYqvfEUeNLjuvwAZZ+ZreJlMXTAKHNLU2n7iaaKxATwtZAyjai1i14GeGH7GKDvKMTdSy0QMT7/OhlYKELDe8xxDQQKHC9F62AN2h8FtoCaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wo6hsvSCSMMEfOF6RHsionIX/izHnLmvH7jqKu9ns/8=;
 b=SHeUFqVUQ1bp3Zj9dFBOs4QQ2KJiHBDzFkAs9HIZxDdK8Rp4E7bQSxlm1DfOXGi7qwt7tfwY4u0Sv2Qp1wN/3ONfr/C5e2K/nAmgwQgjBnjUXoMxlio1oHZsY7WkBnnkE5pDjBGGMsLiCBKntJBCx//Ms29b9+hhwqM4NtJnxHsziMsxNRDFPcuXDCdf9zKwaGFgyK3bZMzRmaXbe2HttVyHsL8LNH2Cpe3GLutVB4Qcqxba/vI6Z6JABOtZmpQ/as5BWkVZ/0nqP9wvJdsTrBmxRjp79TiUC/48Jr3BXiUqYs+4la+1UimyBRZxF23omx6OzjagwzxU0UG6N/wpAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wo6hsvSCSMMEfOF6RHsionIX/izHnLmvH7jqKu9ns/8=;
 b=dSOOWKfJkCZ9PvSCY/Z/VNO7oOhjE8LxUstWvcxCtPLaZ52qSbbTBN7AW9rWwe6oA0oOqkiG92QFAqMVSJwSXdJyPRJ1RaFnLzdzi3nLukDSvULcm0QpRPhlg0+ULT+LqQj7EKSkTCzcewKeVG0KjBTqDrlySlWNEPINLzgkbzg=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1938.namprd11.prod.outlook.com (2603:10b6:404:105::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 07:07:34 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 07:07:34 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>
CC:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: RE: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Topic: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Thread-Index: AQHXrSGPLoYXtOF3o0iA7Cse+/LM66uuxm8AgA72WACAAGbxgIAPTQiAgAAu7ICAAwY+cA==
Date:   Wed, 13 Oct 2021 07:07:34 +0000
Message-ID: <BN9PR11MB54333A0E5C7BD4F8996693278CB79@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com> <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com> <YWPTWdHhoI4k0Ksc@yekko>
 <YWP6tblC2+/2RQtN@myrica>
In-Reply-To: <YWP6tblC2+/2RQtN@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29f9d70e-c145-4a3d-c0f5-08d98e1821cf
x-ms-traffictypediagnostic: BN6PR11MB1938:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1938B313240B515DBAD0C7EA8CB79@BN6PR11MB1938.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IaRBoMOFHZ9h3rb3uLohavwz7L2bCiGzrRGlYxX8UTT7XCw/y8lpO9naC7QDVQyqattfZVHeKB91A3eUR9N4PKlryNqEuf4uMsSVjFAgeWTUG0yHiR1AcXckjydrhS0hhoWrxW4dsbzwfn7+F0JhG8ane502nyftD3ftfzMKuYxzXXt7YNc5Fm5IgFQCSMLRY/WEA/iRFwpb0g+R09xj6LkGE4eC59hJo19wl3lU6rsyZrGB6VCjThpSRBJSBBIzD5ZMF55t89Q9aRu5bh1V9zCDSS7WRkzvzfKLXNVAhIjNboMDnHRwtGYMElZOD4RnBjj+u/D8R/+Zzc8bTgVu/fYKdz2VPX37T6JNjr+dAsOf0zTWA+0KAHo1OMzNeiQkwVtx0iyoeIyVUYtW2irSORqgzzVUh9T5hi3OQMRHRYCVglEDfgjvz51UfUxelaQzN7brjqf9bV4FNEvRvJmM3lEel/OAN3knaizSdSFURo22rfBcDVSJG26K+UIFQmWVYfsRfqlFLKjWIqHdBmqLXmihncFnqR9kTyJjm1FK9V4C1OgBUaX9tKYpwrn/5fP2/qYbx0AhGLoWeKjxszWUcbJJykup1HjFkAqct00b0Yhuhk7VOV2EECX5Q3mHUZH5wYSbg/rLvC+VZ7OgLL/Crfi+c+hJLiFekIiEl3Ue65QzIvAdSIwKA3KV5TWT96HKKIBgK4Q8MBZuWwPlnQQAxt7D/3hwKqgwWspxM4x8zCg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66946007)(316002)(2906002)(6506007)(7696005)(186003)(4326008)(71200400001)(26005)(54906003)(8676002)(86362001)(8936002)(52536014)(66446008)(83380400001)(110136005)(64756008)(66556008)(33656002)(66476007)(7416002)(122000001)(38070700005)(508600001)(38100700002)(55016002)(82960400001)(5660300002)(9686003)(84603001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gu6maqNeQZqaGbSSyOtFWTA1bFf+F42iXGI6sTmlxzHCZFySaLVoMItYgR88?=
 =?us-ascii?Q?Ow8+I5rOFFS2wNzK13TwQrf4id2Whw7JkrFS8cNvPBbUvwkFZBOtohgyx38r?=
 =?us-ascii?Q?LKXtHf3JN9K3ekgIX9cY/Z2GhZiIlZDoY65gHnnbZN3xVsoXhjc+Y1E5k3vX?=
 =?us-ascii?Q?VVDubPA4bJynQP2XDa189kddERaK+SeRgKGKZrgblfA5eLaBkBGJIBbnKRmQ?=
 =?us-ascii?Q?5T5VYLxWQwfpezAeUVv3mid1LmqOPAgDoCc0EEZkgozdh2r9HUmTgroIVPOz?=
 =?us-ascii?Q?bp3IPo32A5ahxXmvNZW68ur4eSAPUWU5pKZ6dSH83HdP5E8GRORQBS1NFafS?=
 =?us-ascii?Q?V3TmFWbaiUzRm4b5J8Y1gDcnwP03sI1gW1ZadnanCLGADOx4Am8tbqPLXEd5?=
 =?us-ascii?Q?yZVbFgVlgCZGPgCZhaQocPnbYd7wYzcTUpeGzMJum9vxQtVK8/fgF22GE3Vr?=
 =?us-ascii?Q?GA2JNOg4WpLiDNjERuo2KZ/blshHKrzi0pyWximHZFxA2IfrjpJoNAKl8KrE?=
 =?us-ascii?Q?BjrDJn4n2G9QcX2pfr5QHdcUWI+ZmrpGAgAOEmpSh3PNHb56NjxDgx6qu9Jg?=
 =?us-ascii?Q?XQQrf/wDEKo4X2Xmx1uiNmqIBCYEqLmq51wLjwzjBdx4DzBucZ02396q/Hmh?=
 =?us-ascii?Q?63Kt7pzeVRTlSOdwmh791WMxiqdUky9Khr9Ql3zc1SpRktnBS4qgWjxK0ef0?=
 =?us-ascii?Q?bPB/QCO+N7/UZB6/XgLtYjUOk7YoYf4suz9rfig6Hp7f+TzauG5d2oObPczH?=
 =?us-ascii?Q?/QC0tyZuYhGpctOQfl5g6ZLUyOdQXuwGIQ/qx2O+CkSNYqOHqryBRiPZp8ZR?=
 =?us-ascii?Q?jfs2VcFRZzXh170G29XtL0Nm1sWi1/xqnh11QmtjLOcgLHXIwL0nvaGStTa6?=
 =?us-ascii?Q?5+Jkh6JubQLvmM06dEo+Mggu7X2qPpdBRuwLJI03K1AixCNpU2lIx5fTyQP7?=
 =?us-ascii?Q?alv3Csct+LF0eEEOtrocdM2AJRoBStbXF73h+ElZgT1+cw1gIpcx7zXajnpS?=
 =?us-ascii?Q?GVb3gDo68F7U2wDp+5MTG8oEj0j5v1unHDK8dX/KGmvEwXo29rF0gnJBLdUm?=
 =?us-ascii?Q?fWV/YgIJeu5mB1vCzeomQyMt34ddxr8ILzTX6PiIuwpJzmfr4UFnJg/UZS0C?=
 =?us-ascii?Q?r1uqd988fRx4rgBegWidVc0AVxtXkXcZSVzMMcXRfIrs6mZ41/6oFD3cYKeB?=
 =?us-ascii?Q?x/CXw2iWQuhyaQK9ItRNEF0v0/t2XBUtCwZkpWmD6I3nWo/aaDRva3OjmPaw?=
 =?us-ascii?Q?V70q1tK3GJJoUIx3msbFTbNixshthpqFTQkj61DFOFDyEvtpu0UgBgt94/CE?=
 =?us-ascii?Q?EN6PEAfIeeEUGSaZRzVd5RXR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29f9d70e-c145-4a3d-c0f5-08d98e1821cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 07:07:34.6472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7S1lUVn4eLUR+WjEI62zeN+KPe/vdxVx5WsElOhcu9uEPC92rvJC5lVfNES35BKn99FcK4//dMsgKiBgl9SVJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1938
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Monday, October 11, 2021 4:50 PM
>=20
> On Mon, Oct 11, 2021 at 05:02:01PM +1100, David Gibson wrote:
> > qemu wants to emulate a PAPR vIOMMU, so it says (via interfaces yet to
> > be determined) that it needs an IOAS where things can be mapped in the
> > range 0..2GiB (for the 32-bit window) and 2^59..2^59+1TiB (for the
> > 64-bit window).
> >
> > Ideally the host /dev/iommu will say "ok!", since both those ranges
> > are within the 0..2^60 translated range of the host IOMMU, and don't
> > touch the IO hole.  When the guest calls the IO mapping hypercalls,
> > qemu translates those into DMA_MAP operations, and since they're all
> > within the previously verified windows, they should work fine.
>=20
> Seems like we don't need the negotiation part?  The host kernel
> communicates available IOVA ranges to userspace including holes (patch
> 17), and userspace can check that the ranges it needs are within the IOVA
> space boundaries. That part is necessary for DPDK as well since it needs
> to know about holes in the IOVA space where DMA wouldn't work as
> expected
> (MSI doorbells for example). And there already is a negotiation happening=
,
> when the host kernel rejects MAP ioctl outside the advertised area.
>=20

Agree. This can cover the ppc platforms with fixed reserved ranges.
It's meaningless to have user further tell kernel that it is only willing
to use a subset of advertised area. for ppc platforms with dynamic
reserved ranges which are claimed by user, we can leave it out of
the common set and handled in a different way, either leveraging
ioas nesting if applied or having ppc specific cmd.

Thanks
Kevin
