Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C0A3C6715
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 01:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbhGLXoQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 19:44:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:40181 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhGLXoQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 19:44:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10043"; a="190451000"
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="190451000"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 16:41:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,235,1620716400"; 
   d="scan'208";a="629840996"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 12 Jul 2021 16:41:25 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 12 Jul 2021 16:41:23 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 12 Jul 2021 16:41:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 12 Jul 2021 16:41:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0Is4hNEYxLQlrOOkJhoNzrn9VN5aZC+y5518Yce1Xeo3O9s2aBo6XJxcBn1iqxFgcWHYE+6XRUYcvfCQjDWhJu/8sGOPESQDy4d7s7c8q1in6BCzUwpP8HWHPkMmUfGrPQTW4zHSyrUx990hSLwaKmOuCF/1bYUH4THVLzOfMX02joPC9XkPr5oE3kWFy17ayUHwwfsFyFF3APsplLup3BGPFSvct4ctLthMdhM1DFruN8TzEi73tpKW8kLy7q4pZZ7f+SpVx4I+D2ekzwaGtp3MhCuIkWSBS63lTWFrsCRC9a7z1srbC1vG64o2+osAr7FUHsEJ1ELjhXpxss7Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEKWo4haZbXMU/cl+OyIo8YdOwHXylMtxQ1nIulboWQ=;
 b=PFz3Z8jL2uBF/R740DCKfKZBJProxUigq2Llp2A2JYBZ7uFHh6d+oRh4buTkK9ug9FdQf95JSiFtBfo5HY6RG8UFZaicJPnHE6j4gW+FGX5QO0DTXYYNwsLrfbDDXRiuyGWRpb3WvIoCTMZ/UXBqpJ/oiX1njbU2tY4NBqLUWxpXMMVNGrtIXUXB6wkboTFIXJvuIQd/nZS6q2VxERrJ3KJDm8bTc+Ojo0Mm1Lf/C3V7cQA3d2bct80Bnr2fdtWN3Bhrl2B0xw3TH15p/38JIDM3ATEwDNi9ZtgT5vms3NaX+XDlk8ufFIUkF/RWZZADdI1uOn9ArzeE7FviTuXLow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vEKWo4haZbXMU/cl+OyIo8YdOwHXylMtxQ1nIulboWQ=;
 b=m9+1TJSDu8j2gZQrxZKT8yzaYn4PJ/TQF79eysL9kyTU/ScalGMg43TYD6izuvwwMRuOUseuBRFDbLcHsYpeBSQH+Rd9V+xEoRaWEqQSlV5CMuvAvh5M0Eczj00wYCTsE0GPPS69dZwqEQAjEzoPXxs8ePWc5ZxV9M/XlT2qoxY=
Received: from BL1PR11MB5429.namprd11.prod.outlook.com (2603:10b6:208:30b::13)
 by MN2PR11MB4109.namprd11.prod.outlook.com (2603:10b6:208:155::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Mon, 12 Jul
 2021 23:41:21 +0000
Received: from BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::ec88:e23e:b921:65ea]) by BL1PR11MB5429.namprd11.prod.outlook.com
 ([fe80::ec88:e23e:b921:65ea%6]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 23:41:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "Kirti Wankhede" <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lu Baolu" <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQAdcmAAAGvGIGAAJH+YAAAJ2M1w
Date:   Mon, 12 Jul 2021 23:41:21 +0000
Message-ID: <BL1PR11MB54299AF6F55B6055A4E3ABA58C159@BL1PR11MB5429.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
        <20210709155052.2881f561.alex.williamson@redhat.com>
        <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
In-Reply-To: <20210712124150.2bf421d1.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a24f3286-a89e-4b6d-ac1e-08d9458e8d91
x-ms-traffictypediagnostic: MN2PR11MB4109:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4109DE1E151F3D3E0B4281F88C159@MN2PR11MB4109.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7Jlo5dJUSxsBUr+QqH8s3fKQRtxHuOAhIgzLde+3jvevzEHwlxdJWTsw1pIbLni+Lp3sT+kRfuAGah44T6pRXYGdyu9YJkTwjUtLWF6GiDjVW1gwTPgpkkttJe5lgHhPsAg/Ve84woKzwEt3GGVS6JIdEkqgHs5myP99/6VtWFiolBOsm/TqCARfm8g4NPZZX+Nb4w4AexherW8ZEy0RtmjQ2t3viE9Zc06cmR5I27hmpQxbX5Qyb1JUVZU9fnC9rioby9LTi5fyaQ4cPfYV7Adgqv9EL93wbFa2k1lZkXEbfBpPLbRt1TdtuurVkZQpJbUZf9XOQmwm2XwBODVLvP1vjPrufi9sjw9sPfeP/7Aj49Jxo9osFxsWIn1c2tqAwW01T5wfeStL7A8zt80otEi4Xd/bjzgrYOUW68rvCzTGddyBfEBc/sbDJ+JB/COuCsFJVDZ61XC0TgNWbiL2Iw/dWNK9tzjVNMYpHLNFCx0391uJLmFOkjk6mCe3VCXQH9EanpbmpHmbKoymvDDHxy/YPNrBxZuGUCpsYAUlyKHIyP5ro7ZWuNgFMcBo+B6+cHjGeXCiBN8yjG9SMBeqQfdZunAff8Ph4nprW0D2/1K94Qm9DvNDLsMICOExsiRSZZahPHPsXdDymZTd3j78g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(478600001)(7696005)(316002)(64756008)(186003)(7416002)(9686003)(54906003)(38100700002)(8936002)(122000001)(71200400001)(6506007)(66446008)(26005)(2906002)(8676002)(33656002)(66476007)(6916009)(4326008)(5660300002)(76116006)(66946007)(55016002)(66556008)(52536014)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TYVNihxT2MiTzLPI+tczxTiDiPfjk+h+Lw1qXb6hrCUzeIolUh8shnAVs9Eg?=
 =?us-ascii?Q?jsby7gQHduRbRppUAuGdMs6tWIqznL5IkGGh81YvS7DcWxfjKmEVZlyHFcPi?=
 =?us-ascii?Q?vCNMtcxQ1fqixf3+edpRZy1y74rLtUrjqFVX0RYxGAGkkCbZ7gDrtkZ3p0l2?=
 =?us-ascii?Q?1fhlF9yLZehLCIGB4R9HtVVWGFfEYaqpQj62i/wTSYqGoBSDUc3cpDokWKRA?=
 =?us-ascii?Q?B6OabssvFLHEJWNnxSRNQqphh5SaaCz+4kAB6zIBoD902NZGGs6Xk4WMjFmr?=
 =?us-ascii?Q?/z81J9+IxCM/TwIgjOysqvlq7McRcUVBVbr0eplY13Rv+KwpLCrqlcKslfpH?=
 =?us-ascii?Q?mB9A+Tk67yuI7uuqHoJq7kgixp3tENtq0NDI4V28WF23qBgyLBpErQWIQE8J?=
 =?us-ascii?Q?/JTu5pCoXY7SpGnweQLoicv/ndzvf+tPrsJIoqZ84052xW9cFRPBhrMWpoFd?=
 =?us-ascii?Q?tHCar/dQ6/7shfZhBpxb/A6agsWJ1PEnrfAISLiIcvfDr7qeeayPEnvXqn/E?=
 =?us-ascii?Q?BqM6IttCiKZJ0zMju54JeZdd1ZfLsFLjoRTCzCmtzi8NtSvxmIkknCAFXlnN?=
 =?us-ascii?Q?NJNQwhy2pBmI2/pbSTLE7ymE/t+xHjPGxVYwUQXCcxSQuQL2zJl0fYEOZIj6?=
 =?us-ascii?Q?3fUs17IaG719SpdKTa+9TOjfbg21sQEDZxFamMaL5V1ehmxjABHew3Z9ERB8?=
 =?us-ascii?Q?kNLPGPMCR7NFCREHfMZh0vGyaQ0YfNrpNJaQPIu0Jm3hc1YoBW/Ja9Fp18Vz?=
 =?us-ascii?Q?l2N8WxkUdeiD6DG/DZF6faAhV/88zYQUhho7DPplTUmA4jSYHXbQHEMeirn0?=
 =?us-ascii?Q?CQAxrO4VCv03KUp/sZ7hAxv1fgJi6sw6PbA3ifwjfpwi4mToumeVQ0aZ6rkU?=
 =?us-ascii?Q?0bG1Nje8pJqNn5NttjSo3Shd9aYbCWfvbYYNCDX7koO14xG6M1JD3g5nzHFL?=
 =?us-ascii?Q?gMmdptkV7R5vrVG1rt159Mq+WQfifTW0pUwMVWKq0nXG9N1bft7WfpA7C4M4?=
 =?us-ascii?Q?oGKrSl8lKkcey7+pBtDFq58nDwE3jDOkrjxmW4GRn9xFlFPnSu6NMHd2paTM?=
 =?us-ascii?Q?Oz+gHflTCaGi+sINyRxjLqEbZFDGKU+ZhO6wbLiY7BRkfyy2LpXmEVJJrmeg?=
 =?us-ascii?Q?258Y9EUaHeTmamadkU2yiL6g/TnDV50xb+OfV+JKiR+jX/4TabFhhmi62pb2?=
 =?us-ascii?Q?D5zab4/yFWnWLXh6EP4/3zEvXJdMDPCVfvu0qUpjTjfW5wWklfwTIwfxVLaf?=
 =?us-ascii?Q?+SO4fcc/g/4qj2B2V7yP/8Wan+5GgjY7qhItekxXft6Nax9ha6U9RXEcvfcq?=
 =?us-ascii?Q?voprXlc5RseJ6wgjQ96BhanY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24f3286-a89e-4b6d-ac1e-08d9458e8d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2021 23:41:21.1178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQVt+VJYRJ/PlB45tFfNrmEwQc6Gb395/Y+1VuZ9P4m9MNfoYjumGuq8snQc7ocNOL9bpJ5rBynO3s1pwPateQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4109
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, July 13, 2021 2:42 AM
>=20
> On Mon, 12 Jul 2021 01:22:11 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Saturday, July 10, 2021 5:51 AM
> > > On Fri, 9 Jul 2021 07:48:44 +0000
> > > "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > > For mdev the struct device should be the pointer to the parent devi=
ce.
> > >
> > > I don't get how iommu_register_device() differentiates an mdev from a
> > > pdev in this case.
> >
> > via device cookie.
>=20
>=20
> Let me re-add this section for more context:
>=20
> > 3. Sample structures and helper functions
> > --------------------------------------------------------
> >
> > Three helper functions are provided to support VFIO_BIND_IOMMU_FD:
> >
> > 	struct iommu_ctx *iommu_ctx_fdget(int fd);
> > 	struct iommu_dev *iommu_register_device(struct iommu_ctx *ctx,
> > 		struct device *device, u64 cookie);
> > 	int iommu_unregister_device(struct iommu_dev *dev);
> >
> > An iommu_ctx is created for each fd:
> >
> > 	struct iommu_ctx {
> > 		// a list of allocated IOASID data's
> > 		struct xarray		ioasid_xa;
> >
> > 		// a list of registered devices
> > 		struct xarray		dev_xa;
> > 	};
> >
> > Later some group-tracking fields will be also introduced to support
> > multi-devices group.
> >
> > Each registered device is represented by iommu_dev:
> >
> > 	struct iommu_dev {
> > 		struct iommu_ctx	*ctx;
> > 		// always be the physical device
> > 		struct device 		*device;
> > 		u64			cookie;
> > 		struct kref		kref;
> > 	};
> >
> > A successful binding establishes a security context for the bound
> > device and returns struct iommu_dev pointer to the caller. After this
> > point, the user is allowed to query device capabilities via IOMMU_
> > DEVICE_GET_INFO.
> >
> > For mdev the struct device should be the pointer to the parent device.
>=20
>=20
> So we'll have a VFIO_DEVICE_BIND_IOMMU_FD ioctl where the user
> provides
> the iommu_fd and a cookie.  vfio will use iommu_ctx_fdget() to get an
> iommu_ctx* for that iommu_fd, then we'll call iommu_register_device()
> using that iommu_ctx* we got from the iommu_fd, the cookie provided by
> the user, and for an mdev, the parent of the device the user owns
> (the device_fd on which this ioctl is called)...
>=20
> How does an arbitrary user provided cookie let you differentiate that
> the request is actually for an mdev versus the parent device itself?
>=20
> For instance, how can the IOMMU layer distinguish GVT-g (mdev) vs GVT-d
> (direct assignment) when both use the same struct device* and cookie is
> just a user provided value?  Still confused.  Thanks,
>=20

GVT-g is a special case here since it's purely software-emulated mdev=20
and reuse the default domain of the parent device. In this case IOASID
is treated as metadata for GVT-g device driver to conduct DMA isolation
in software. We won't install a new page table in the IOMMU just for
GVT-g mdev (this does reminds a missing flag in the attaching call to
indicate this requirement).

What you really care about is about SIOV mdev (with PASID-granular
DMA isolation in the IOMMU) and its parent. In this case mdev and
parent assignment are exclusive. When the parent is already assigned=20
to an user, it's not managed by the kernel anymore thus no mdev
per se. If mdev is created then it implies that the parent must be
managed by the kernel. In either case the user-provided cookie is
contained only within IOMMU fd. When calling IOMMU-API, it's
always about the routing information (RID, or RID+PASID) provided=20
in the attaching call.

Thanks
Kevin
