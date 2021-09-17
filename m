Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9652A40F17B
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 06:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244714AbhIQEvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 00:51:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:63796 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhIQEvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 00:51:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10109"; a="219534174"
X-IronPort-AV: E=Sophos;i="5.85,300,1624345200"; 
   d="scan'208";a="219534174"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2021 21:49:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,300,1624345200"; 
   d="scan'208";a="509620801"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 16 Sep 2021 21:49:44 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 16 Sep 2021 21:49:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 16 Sep 2021 21:49:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 16 Sep 2021 21:49:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eo6ckcPhGu95m6zzZzDmPSnUt80yzQwyKmpZ4ITEaGgCD/TUZQLS9KfXfdYJDx5Bf4BeTbFXA/Wwyaj1zWYckXEF5dXSHdtSdTIa0fWxKt0bpB/GaNlpQEIZtabkW5pg/N18mZ0oNzIYRIcyfV6kGWnFuW8OwpyWq8/SwA2htYPvk2IYhjlnkrZ6kGJZsDHScroALvkFs0X8ssFJB1esvmMoTx1I9zZanG9zc3IRlazc9OKiun54HDs1yZIAXnvcavTdifr62oGSc8x1HGmxh6WLGFNUQ1AIp0i2+nDv7aWBd+b8Z24I/ltAOsXq/tCsWMijbc9ypWF72gs+/TBlvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pBV5qrRSBDOEQmSlVZpnVkhxX9am6Dyi3dC8MxDXL+w=;
 b=U9QeD4pnUHw0ZO1Mv7Q+xkfo0ROZk5UY1msY9QpQFbg9lD1KvQ5ac93fDJhDVRQqy8ghXw7cPzscuJdWyY8D4+PMJZFEXdPYrsN1nBFBpGS/6mvWWXhdX86T4VjknKVxaYHfzLX/rBf8nfuAYMckF/4EvJvXfWXqbdluhZdrsB+LVLao5NdNuxM31Eh5EBgkqVxQtuNI+jS9hMAme+me0lZgoYx0l3tmXBzC5JpjWj/S+phDpzGxbTNMjFGZGbi6uN4E2jjRQ0tLyDXAuZgAGn8CiDyzHi+sP3kJTICwkV7ton01An9r3EfyIpOUGshD0PBXo0fPl8p7XoBV+RKLtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBV5qrRSBDOEQmSlVZpnVkhxX9am6Dyi3dC8MxDXL+w=;
 b=TVhsdNjsFuLLAxMv3tMegPEasafSoQ5T2CKqDz4Wr7b1z6GlEqZhkHwv+FArH2h8o6rrE9rDPgKXDnB58dOblVJKQiu+1gRCRolewojPKwBMTtKY91VRjU8YZQPQ2WHipsrtlS7AZsOPNYFNBMDe9RuGAvANj2rjPrcznU15P+w=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1268.namprd11.prod.outlook.com (2603:10b6:404:47::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 04:49:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 04:49:41 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Thread-Topic: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Thread-Index: AQHXqHEHQvsvdkF3iE69JycE8ab/86unGNqAgAAn7wCAAEMjoA==
Date:   Fri, 17 Sep 2021 04:49:41 +0000
Message-ID: <BN9PR11MB54333BE60F997D3A9183EDD38CDD9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210913071606.2966-1-hch@lst.de>
 <20210913071606.2966-12-hch@lst.de>
 <c4ef0d8a-39f4-4834-f8f2-beffd2f2f8ae@nvidia.com>
 <20210916221854.GT3544071@ziepe.ca>
In-Reply-To: <20210916221854.GT3544071@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cb64a98-776e-468e-04a8-08d979968ff4
x-ms-traffictypediagnostic: BN6PR11MB1268:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1268BD82DFF3FDB538A91EB98CDD9@BN6PR11MB1268.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TKsRBkirl/a7e6lahYj+WQVhI4gW1D32qvKbIcWBTBGNK+TPqcGe0hr2m1UwQopNxTTeiZhIbhFKdKnHnnIpoUnOJSJsg9RxBm6VEqi9702LyNdFnfaBFpKPE/hxNp5HHcWn68XUd641koR3GgFS8T2mw+LinMxk+MHS2Xl8PY/qptuM+JWE8FzDP4QS5ONI08GLkgoheCfQTZvKXweDqPU4f0RM6yoaEWGCqcf1dx5AG19nCu276eY0lkG3srgEATJ6oKZ8MDlpxBM8f80/bQcjZTNMBMLTZCBThG5tCgr3WI5UxfCGnaCfCgfJks6tJeKosibios47g/qFU3sgqN8emDYu1IJE+CZJEMSEyRMg0D1Q1Rp6iqo8ygtZ7s3UT38FWBXIDjMFyA+/larQYQndzKoYOM6qxz7ZMUKAb2yq3YHgr1VM/iPhgyWV091rkdRVmmLNlJGxnQIk0ZsgQMAPbgfMp+0aYYiDyI9PLyaSsGiengtqo07zxdZ8sdB/fxb/7lO7ffJO71w0lMtHzpseCQsbhlBGaP37frAo8amOB9RWUJg7AmV/uCCWjO/wdQi2fHzGNrkimMxmpVOsghtrL1AprdGJpFBfeHiKFSMLQHf44WtCgqt7/cTtG7myiKd1SsEy+6+/FWsUQwes6r3Lpsxc3C78raaliBUpRyLakP4P0jh2TyxcIyQLbfdGLMqcWYf5V5FSJo5QtJy9VA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(38100700002)(122000001)(86362001)(2906002)(8936002)(4326008)(5660300002)(7696005)(52536014)(71200400001)(8676002)(316002)(33656002)(26005)(9686003)(38070700005)(55016002)(186003)(54906003)(66476007)(64756008)(66446008)(66556008)(110136005)(508600001)(6506007)(53546011)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Xb7PuHLFr5twpITNlJepEvVqzJyjTFlQVvD19HAXhCby5JPjkUL5JIftZyV0?=
 =?us-ascii?Q?5S/7LhDyCqD/Z1qpXzwZY82rylp20ZnjIjYYSe9sHErG4QYeWbbVYQcgCT/k?=
 =?us-ascii?Q?ykPmJ/7fu702WmcWdF9eA7TpOZNkH7Khj99+chKJ6HyXD6fFWvwkzjMg7GTZ?=
 =?us-ascii?Q?tQKBZYikw3Xw+99VExHS91OK868u32BES8JuWEHFPe+vN0qLZQjRqipHRo4w?=
 =?us-ascii?Q?j+xOhoxqrt/abTx4Vy6SSUcOg1xWAig5JXwXMdrdMGCVwEJ4XEzXxgiQIzEq?=
 =?us-ascii?Q?CKgff84JARrgiCji7fH38Cl56RdjMS/WokEaSAdu/IqlhuBTCJGZbDkQAUKT?=
 =?us-ascii?Q?ZGzYSQkLwGLj5tPxjCgPj1Xles2YN7/mux0lxYhxMcpk/cyzW7Kbtrpjsawc?=
 =?us-ascii?Q?RnUKd4SDY0GkM97fzLjJKJo/oqb8ody5uamjy0cCPrwujSxxadOTjV5bx8qM?=
 =?us-ascii?Q?b055jvoxbXTjviHrvefJ1eJHhiH6Jx3W6khfyqNvJkIF+67LD6Cp2nAmmOXf?=
 =?us-ascii?Q?N9F0fYLZ6Tt7QHJgYWKBDtYLqCApSAxN0sk75CBDDDMPurMI4yYk1277aRC0?=
 =?us-ascii?Q?4wYIvttuj7Gi42fFEmgbBdw6R70D1ogdFE3+//scur4HE25t3e13zNF/6Vb/?=
 =?us-ascii?Q?wMx908jLQQQ9SL39NI9CmzMty5nEvyRf92R64SLhaArOV5K4hqu4VEzKsIE6?=
 =?us-ascii?Q?E0BQzm1niVFiZ30MiwM9cKd+V3v9p4qZ5JFZ5mvRN8KaMyAo5nrg1fJ2KlWD?=
 =?us-ascii?Q?8rDKBZStEpVjNkDA2U4DfUkpb9ZqnHBP+C3B8hf4sqvqtFPkyaZd1BsFMv3f?=
 =?us-ascii?Q?dODMxUKgG/UC3PiTtq1yd5P9dR4DKYoKTL19lnyGi46OBkT9DeFBrw1rDTsI?=
 =?us-ascii?Q?BJaacVZZonC4pryv8Ha/N91eW7TrUZTVBXR+mEF7v1RNByJA089/+vugKd2T?=
 =?us-ascii?Q?irhDZQWbdGjIFGvXiZpjw0tnOQ5NR75w9Nj9Nd8hZhlT6yPDyWTBoFLK7R6j?=
 =?us-ascii?Q?fTCD390CsyGHA1ttoI62TaaPkr82q2TOx72ehngRRESpdCdrV6pQpMly7r9f?=
 =?us-ascii?Q?lAk5n+uEViROukT6reob5z1x6mnO8g6gbDcF0b46DVAlhVhsxkmLtp1PlNVk?=
 =?us-ascii?Q?2Xq0V6PZBZwX6BCpMa2/N/TIZlfhLSg+uNVD85JCpw5H2pSwIxXNZ3mfpiGb?=
 =?us-ascii?Q?ZQ08KtALgGeSG5X6biwPkWsAnAJ/vezSTESLnjgn3sf+LN6op5a7T0LTFkaL?=
 =?us-ascii?Q?2a+Vtl4VyEj5ahMMs95pDsMPVV/HxPjuo0tD7keLLABRlxqrI98ZYONdUwdV?=
 =?us-ascii?Q?UXBVyE0VpU6FzIU5oZBgW6Kh?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb64a98-776e-468e-04a8-08d979968ff4
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 04:49:41.6113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PSmChNSLGoOuvLAIlPM+cPZc6zrmr3sCdBoNjLi6xOHucaHrXhSpp8aHegrTvj8LdN2974KzRM7W2ue6O79MWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1268
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, September 17, 2021 6:19 AM
>=20
> On Fri, Sep 17, 2021 at 01:25:59AM +0530, Kirti Wankhede wrote:
> >
> >
> > On 9/13/2021 12:46 PM, Christoph Hellwig wrote:
> > > Pass the group flags to ->attach_group and remove the messy check for
> > > the bus type.
> > >
> >
> > I like the way vfio_group_type is used in this patch, that removes mess=
y
> way
> > to call symbol_get(mdev_bus_type).
> >
> > Any thoughts on how VFIO_IOMMU, i.e. IOMMU backed mdev, can be
> implemented?
> >
> > For IOMMU backed mdev, mdev->dev->iommu_group should be same as
> > mdev->type->parent->dev->iommu_group or in other words, parent device
> would
> > be DMA alias for the mdev device with the restriction - single mdev dev=
ice
> > can be created for the physical device. Is it possible to link iommu_gr=
oup
> > of these two devices some way?
>=20
> You just use the new style mdev API and directly call
> vfio_register_group_dev and it will pick up the
> parent->dev->iommu_group naturally like everything else using physical
> iommu groups.
>=20

For above usage (wrap pdev into mdev), isn't the right way to directly add=
=20
vendor vfio-pci driver since vfio-pci-core has been split out now? It's not=
=20
necessary to fake a mdev just for adding some mediation in the r/w path...

Another type of IOMMU-backed mdev is with pasid support. But for this
case we discussed earlier that it doesn't have group and will follow the
new /dev/iommu proposal instead.

Thanks
Kevin
