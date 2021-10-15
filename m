Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F95442E5AC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhJOBDx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:03:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:3605 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJOBDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:03:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="225287101"
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="225287101"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 18:01:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,374,1624345200"; 
   d="scan'208";a="492261574"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 14 Oct 2021 18:01:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 18:01:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 18:01:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 18:01:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 18:01:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnA2wlb9ZEJswQxXN6jVp1pzG50hzsSJseTVtBPgE3mX28uNJfkyIuspquW2j9fLs76VWWdW3U2gghKn+y6CTdLDlTas3/1Tm17YUGlkbFEo5MiD2HRAYJIlutwVNpsCpikL3b+noleumVXUXjga/q/gobdsZ91Irl1Cn936997YC2dFYjsDlTR5WZXXlbqgsnByRQcMzlNMBD6KYxqWxw28+Uh+vOtHUJMXkyxbmpaiuoiZdCuRomCBACdlVXnAXNZGq3iXLZpb40Pa3A/PzrK4RXpFrXwvwDgEQHAgzjRcwQU8qyuHKyAELv0OqJikrmioScL4ZGsldZvPowDXCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL9TFklQAwh8In9i2p/1z4WpTjIoBycLOoky+HXMQbc=;
 b=jHbcVJZcpmz6hf8huEMVlkFc5KBgnw+dkTHO/qAgVDYiKOkitmCyTBMG1a5BHAu/6T+b0992wVjVXWDrc3A6zUCCbd5AaIJftkMEWTlGmQgLY+9zv9TaMzuNs/2sGa4JnOOIQo8guuRd769PbQ6syRxqxJIZrhd2JTYesHwjBYdg68j4YUWwdauM6LHwYJiyPbRfZohpoO79+Uap1BSsNvVmWgOUHygWkgletLhgBC1/ItxVMmu69lUsdO909evBP5Da3CK5F9Qkqn+DE7IawdTpG24KBt++GrK+1vMFztjnRVEvMPCCZtF3R52JyHIzlL3jo4ThFn1bVqvbBoBiJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tL9TFklQAwh8In9i2p/1z4WpTjIoBycLOoky+HXMQbc=;
 b=wS2rfBd3Vbu4ftYU7xpiL9aIiX3lmSNayu1EA6aB/iw7iZ0m+UM+j53z58A0NXTszdwL6/NSw70bQ3KP1DFouLEA1U3wv++QacLueoXxPTcdTNOhw5khBHD+acLWlBz/Ab0PJhKDjLbPaIYTmJQCeZzBihD4Dp5wMRFgvHRaJ7A=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR11MB1330.namprd11.prod.outlook.com (2603:10b6:404:4a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Fri, 15 Oct
 2021 01:01:39 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4608.016; Fri, 15 Oct 2021
 01:01:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAEL4QgACKr4CACtdfoIAA3DaAgBUX8GCAAHivgIAAl4Fg
Date:   Fri, 15 Oct 2021 01:01:38 +0000
Message-ID: <BN9PR11MB543328B13905017E11355AC78CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
In-Reply-To: <20211014154259.GT2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 357c15c5-af7b-4da2-35ff-08d98f775813
x-ms-traffictypediagnostic: BN6PR11MB1330:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB13301956E2FC1F621AB915878CB99@BN6PR11MB1330.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qWcrUynbkStYEzYQkdEk6896u3OGErvDXED95Ytyv1jQKyLgMaL6Fz1bs3Ad5eI2Y+vpUKx6OXjG0KnefQkMmKL2JGfKgYnoxkknBGsXw1hcrXzBss1rY9CDbDlGq1bTz57XeYg2At6ny4xSFG6VtUahqvYFeSuUoPIoXJfpxTU/QRCg6rpEgmYoqaFhTgEPyxzEQGKhyvw1GA+3qpfk0Qv8FYNvozA4VGSbtZ/ea+PT1SLoMYGxxB1tGog0cbZvMy8ojRcxDmRA3fK2o1EL23fyvR8z6TI06/DgApBgSAG13+H3QBaDFyAiiNGBcnyBEBex+aGwzhp447MWbK9b8Sojiu7ka/sY79G3SWanetuQZfJD3YGKS99eP5pWpCurdBSyMRXMF1jEsl2yE461JJ7QlN3KcvBV5vQDEEovIBY47IXYuhmm79//9ebEMUgOzkSx1U7p/T88BOs6aOlVij3oiu5FBIACwak4zi+xo+/s1S8yYdtFFR41RY0NzJoApZ01qVmIwtnjpeB4jPPw8ADZ1MfeJS6bIHR82wiLTpoCFz5TfforFL081ZnhWj0Uscs7sgM010/Zy3ialVowecVs7oq6TcGLTJQwzo9qVT5AnL3wdeMY//ZJD3RPAXQNzF7FvYWWadeAbCz8pJ7DfBB1Ndx2hy2UBscxZ1YBtNMyshC16gpYFFaBfT+YkGZp1dQ71B9Xkk+rnTBbGx7Iqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(76116006)(508600001)(38070700005)(86362001)(66556008)(7696005)(8936002)(66446008)(6506007)(122000001)(6916009)(38100700002)(66476007)(55016002)(66946007)(52536014)(54906003)(64756008)(316002)(8676002)(4326008)(82960400001)(26005)(186003)(2906002)(7416002)(83380400001)(33656002)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p6TkiGdl3YPPKN+4gBzEriTAN0x7QVs09PfRVjwuCTJsdFou+RxpcVpikjVR?=
 =?us-ascii?Q?av7JeQjui8Q80Sh3ghfmuRB7Wk3Ii5gUqaKdycf8Ls2e3Q/PPsUheCG/mBS/?=
 =?us-ascii?Q?xYqzGOqAPfOfT4lmBud57pg3PRWWS50nS6q1Nv74WrgMC6zzfNRZoFpq/cWG?=
 =?us-ascii?Q?ZvMHui7r3hqzprO7+GYoIrP5+Kj4zAEpMOiP5k1sVIe0r9nM9SbjoYXgiz0r?=
 =?us-ascii?Q?EmTP62uI9dpMCheiO261/rjKd9q2amTIX5O7bqOkOc/s2d90z0RwrXCeATFG?=
 =?us-ascii?Q?oELrm4f6AzBImnDJJJiCsMM/Jx5u/QNPssilu0a4oVNbRrdN+i3wsukdUtTI?=
 =?us-ascii?Q?mokpuz1yz1hGH8vxBX/kKtddFhgr+Ls23bWm7hWMz/EwjsxLrbRfS8VawRCa?=
 =?us-ascii?Q?kWS9sLe1cYhVHCgOXhF5VyhhvdGSTXIVyluLuSDJejGUJVy4R6BvUxxhrpBF?=
 =?us-ascii?Q?OZrh3WPr/PidgMkbtzDLO7JjP9lTlV4u4hDBVPVbIPE0L7HjpjPZwHhLMfpY?=
 =?us-ascii?Q?weVjGd3PgPpr8ZAS/KnFLVnFVQcQ6t0BCNAGduv8z6wOr4V7YgFljlWSe8ai?=
 =?us-ascii?Q?oJ8MO9Ac8zKru88+GiAK/3KCuXp5Meoeem0mzuTciVJFFvgSLmcSgC6fy8rd?=
 =?us-ascii?Q?9+h9AYSQ1aadN/dLB5IhgDdx5Cze49ahBSOgi6lJ4nT6LoHfsUpWZJaAynjX?=
 =?us-ascii?Q?Hz13EYghupNdy/YqhUB6iJFvPlP7TtiYEP1MneRyEoqSOcNaFTfmM36GjmbB?=
 =?us-ascii?Q?155P05uPfe+WULZcPLas+RT2J1cFpH5ICls1eI3E/I1tn1/50UlAaGV99NbL?=
 =?us-ascii?Q?0mnTzpwLC8iriwL8vCbcYmEjbZSRxtJuRpq6NDc6xTooEcE7F1v9LXlr5OzL?=
 =?us-ascii?Q?ifHLTesEDnITrOBCQy9ADcYv4woMMt4tKGfXIpw5y+j++97C7pdtWYCc2be0?=
 =?us-ascii?Q?rr4hY3TmpZriQNw8NyK72IjAhoMziGvC9WIGFQID12nehSYsop8cXZzcylgU?=
 =?us-ascii?Q?OGh92cOIbTr/4Q8KuTQnRiB0cPG+38ZVR0aSGPnQ0+QO8SgBuv5DrSwpm2a0?=
 =?us-ascii?Q?GQ3dDsXZA3Yh0fInZ/yYVuMGCgtpQNcetj00k+1a/Yfdm0pVwjfVuA63cJAt?=
 =?us-ascii?Q?3tLPEjesBXVw1ELPzbRuLY4cdgee8y0X1sS25EP5ivakg+QIIfzew3hbUAsz?=
 =?us-ascii?Q?hgiolTP6wiExax7EX0FizyBenjzYuK9fc8y0KVaCPpMx/bLqhuCixepdosS+?=
 =?us-ascii?Q?zNPF6R5aY9kNvw/vHW6ZJYQ5tOo+HhaOoPUqIDJn0DF9aTxk6eHJx1XSds15?=
 =?us-ascii?Q?fs7qovaKSV5XmxfFKKqj1A1H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357c15c5-af7b-4da2-35ff-08d98f775813
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2021 01:01:38.9776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ygnrAC+2SCpp6IBkTIESjidHBiH+7n3Amyiu5gq5SKmMpKI/0zMGscWQXlmPRDMHB57PTYN8rhjH3W96gKqWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1330
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, October 14, 2021 11:43 PM
>=20
> > > > I think the key is whether other archs allow driver to decide DMA
> > > > coherency and indirectly the underlying I/O page table format.
> > > > If yes, then I don't see a reason why such decision should not be
> > > > given to userspace for passthrough case.
> > >
> > > The choice all comes down to if the other arches have cache
> > > maintenance instructions in the VM that *don't work*
> >
> > Looks vfio always sets IOMMU_CACHE on all platforms as long as
> > iommu supports it (true on all platforms except intel iommu which
> > is dedicated for GPU):
> >
> > vfio_iommu_type1_attach_group()
> > {
> > 	...
> > 	if (iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> > 		domain->prot |=3D IOMMU_CACHE;
> > 	...
> > }
> >
> > Should above be set according to whether a device is coherent?
>=20
> For IOMMU_CACHE there are two questions related to the overloaded
> meaning:
>=20
>  - Should VFIO ask the IOMMU to use non-coherent DMA (ARM meaning)
>    This depends on how the VFIO user expects to operate the DMA.
>    If the VFIO user can issue cache maintenance ops then IOMMU_CACHE
>    should be controlled by the user. I have no idea what platforms
>    support user space cache maintenance ops.

But just like you said for intel meaning below, even if those ops are
privileged a uAPI can be provided to support such usage if necessary.

>=20
>  - Should VFIO ask the IOMMU to suppress no-snoop (Intel meaning)
>    This depends if the VFIO user has access to wbinvd or not.
>=20
>    wbinvd is a privileged instruction so normally userspace will not
>    be able to access it.
>=20
>    Per Paolo recommendation there should be a uAPI someplace that
>    allows userspace to issue wbinvd - basically the suppress no-snoop
>    is also user controllable.
>=20
> The two things are very similar and ultimately are a choice userspace
> should be making.

yes

>=20
> From something like a qemu perspective things are more murkey - eg on
> ARM qemu needs to co-ordinate with the guest. Whatever IOMMU_CACHE
> mode VFIO is using must match the device coherent flag in the Linux
> guest. I'm guessing all Linux guest VMs only use coherent DMA for all
> devices today. I don't know if the cache maintaince ops are even
> permitted in an ARM VM.
>=20

I'll leave it to Jean to confirm. If only coherent DMA can be used in
the guest on other platforms, suppose VFIO should not blindly set=20
IOMMU_CACHE and in concept it should deny assigning a non-coherent=20
device since no co-ordination with guest exists today.

So the bottomline is that we'll keep this no-snoop thing Intel-specific.=20
For the basic skeleton we'll not support no-snoop thus the user=20
needs to set enforce-snoop flag when creating an IOAS like this RFC v1
does. Also need to introduce a new flag instead of abusing=20
IOMMU_CACHE in the kernel. For other platforms it may need a fix=20
to deny non-coherent device (based on above open) for now.

Thanks
Kevin
