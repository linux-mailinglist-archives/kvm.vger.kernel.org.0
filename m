Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBE641D56A
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 10:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349132AbhI3Ice (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 04:32:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:41230 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348195AbhI3Icd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 04:32:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="286154092"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="286154092"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 01:30:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="563949438"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga002.fm.intel.com with ESMTP; 30 Sep 2021 01:30:48 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 01:30:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 30 Sep 2021 01:30:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 30 Sep 2021 01:30:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 30 Sep 2021 01:30:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRZ1rU9MQv2XfFnO3B88zIyhs+0hYvvZ2XIxDSkidp4G3vZZAvJhxizmTgRmkTM6/TE8RqppfwVZ+3Aj4P6ijikErKvAmgZTfvO/KFT5j4+4Bt6Mo7nJygDksP4H3dXMzzSRZsgK0Qci7HMLAWrAl7lWAyM58m6BAKNGvK4QlgybauAWGIj09l4ZwzCNHHgJMN1FgUKXvpudkKpFCwTo+tXnvG9frhghbZnpP0Ccm4RnZIdNW7Sm4Q1Y9VRYSHl3/b8g3QG/yvgBOvvKSPx/nXznKwhLp9751eldKanTlDJ6CYdePNttwEiXCs0xm7d+A6vDiauVMsQE4Nh1ILJsTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jc8lkyQdVlsD8ikjJFcZasVXpFY4fVVOMYq7+lThrMA=;
 b=Z8d1+7YrfR9YDRccdRkiKCsBVmxLx87MJ9e5fy8kGxlAjErr2iWTJNK72bscUl4HNz9G5nxYnL2V8RTPia/BIeXO5qQ48AbxV8WkJGOoko17cgveODTOl7Eq8/vqlBiX/GTyJkjlOzFbK5MCxoywsH52cwBQgFwJ+TCepR2dn3Jcz1qFrvrF9n/U+h7tJ0K5KTJf6qEm24Yx18IZRJhgxyKNbjZXQ11dqEdbT8XB1+YqBxshaVgD4zo+LEhtt/YA3Tjm22l/ZsXfJlpSiK96GQLQtY4SYNLr3hk0Uy2VA9xnSERUyf4oWr4H7iC1a4KQL8IfzbI6mO03DNuXw8wXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jc8lkyQdVlsD8ikjJFcZasVXpFY4fVVOMYq7+lThrMA=;
 b=PBdi1xDaPrCj3+z5P5ABmE0haaWOS+OMmWOyXHq+7TUd2//uUxYLv6i7EfE+omGerjoOBBV3DiY3fuFahgCnbIwHGtHwu6tEipRHtkQbwsDwqljxC8bz8Hp7ByKmuHSC4v/LQiu/Py8yhtcwLqGPyTfzuSo5PBQnWjXjfNQmSwU=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN6PR1101MB2339.namprd11.prod.outlook.com (2603:10b6:404:94::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Thu, 30 Sep
 2021 08:30:42 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ddb7:fa7f:2cc:45df%8]) with mapi id 15.20.4544.021; Thu, 30 Sep 2021
 08:30:42 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Topic: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Thread-Index: AQHXrSGNbNtRgavabUSKJjvt8l12BauwlhaAgAAouwCAACufAIAAgyUAgAAUFACAAAdkgIAAB/8AgAkqbYCAAEeFAIABQYSQ
Date:   Thu, 30 Sep 2021 08:30:42 +0000
Message-ID: <BN9PR11MB5433C9B5A0CD0B58163859EC8CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210922152407.1bfa6ff7.alex.williamson@redhat.com>
 <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB543333AD3C81312115686AAA8CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YUxTvCt1mYDntO8z@myrica> <20210923112716.GE964074@nvidia.com>
 <BN9PR11MB5433BCFCF3B0CB657E9BFE898CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923122220.GL964074@nvidia.com>
 <BN9PR11MB5433D75C09C6FDA01C2B7CF48CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929123630.GS964074@nvidia.com>
In-Reply-To: <20210929123630.GS964074@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4087b062-7bac-47a0-a7a8-08d983ec9787
x-ms-traffictypediagnostic: BN6PR1101MB2339:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB23396AF92A43DB35F18BE1078CAA9@BN6PR1101MB2339.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EMf5dCDW355JlzDYAwX/pFdjvT0fJj618wXR+HINXUZr4gUvRPhkwqq4rdmAuMXZ9gb5wd0nOVlkm8zNe3vPj8xj6oiQdZ0/P4+G3e5Erz9Mls7VrDtfnCYRltBrJW1n/6t1way0kGQ2usrjOV+nNw7ca/ILXECFc2bcRe1lb8CYDTeRLYniWZEjNTe70vQZmB5k7iXce8UiwovidfnvL9545gmGIn3QdXdNyUSayvQG42bOQxasHL21OnxTsiqY9SnLI7HBzT/C0claz0McpyCc7IMlogS1+/wkyV/0a8eyZm4CSEY7Du0nUor6nl1kFgi8nJmOZbx63eK7LP1KvPPx4vIC+eb7YgNdSxSh6AU+8kWH0WmS7ZiD21ucQ5cTlrHJd6IqOBrZLfUwq4neimQhQu+yUdeqRlnrHxXGbs0WEhpZi615+01IHUqLKowJWxLgkznJuhFhWjLn4eJE1hA/PQzZnLsLlxP6128BtBa1eBImBjJd9H0JgtZk7Ayo1eIWzcMR0vzp0+xp0kv+mHdQqgLpYALUfyw73Mt94z+8ws3UD4XX1VaS+Yr+EBc2IE+4HWoBuZX/v0Wma/eKeqE9mwN8lOb5YLBjWvKd6YRFrDC86+WmQKXCjc7+tUA9kYGpov2MOumvUMD7eSk1c+YUvMO6zgqlMtJAMVExgCckWpT3Ni6vUvfW1RycaJk4gS02y7AfE3l9tZECTKiMbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(54906003)(71200400001)(4326008)(7416002)(122000001)(86362001)(316002)(6506007)(6916009)(38070700005)(83380400001)(7696005)(76116006)(66556008)(64756008)(66446008)(33656002)(52536014)(8676002)(66946007)(2906002)(26005)(9686003)(55016002)(8936002)(508600001)(66476007)(5660300002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CztRSlScnZZXTdPM5vqtYaDCn4tGY+MoabF6eNa1Sei1I/kIj14d8aMyySHW?=
 =?us-ascii?Q?6yQzzd1yxoYyjiw2MP6KoMQ4dk6FE9oSHaCqzXW7hSSvBFWSB3DxVQWHdFaS?=
 =?us-ascii?Q?cmHGNv+zwcA6yYGgqWpP+EEVn0GRxF1kDvd6SQiP2Eiujvrmua8J8LB7Hpln?=
 =?us-ascii?Q?XLrtrG27pmwVNaPhzD7dOCUtiWuneNvQW6+5YTAtLib4pl9vfPQa/DLVt21S?=
 =?us-ascii?Q?FWIIYAW9LA6lJxanO1RRvqhOjNkM66G+gyPmRFjOVW35jGfr63HJb/Pd/bXr?=
 =?us-ascii?Q?sR0B/ywdUZbam+Imq3TM5gUK+uuzC8sqjch6CsnkRAOs66PF0sKCR5sHLyiN?=
 =?us-ascii?Q?0CDvGrJbpxjhK3vSumtWDAGArjSePVxjUddik4r/7oQcSnKTWBC1wI4GPtpU?=
 =?us-ascii?Q?WI3aOJrh2zE3hDUod7nIrj4V7+Y/qyQzAAhrycwndD0otggVWyYVlesShdmP?=
 =?us-ascii?Q?1BskHSucre4CJwrbXMHSjVU2U3vH4pI7uRJrpk3PlnkDFnY2LbVrJJJaQmYA?=
 =?us-ascii?Q?t+aD/TaLVMKnu38ZeBTP9NQTq17Y5ZW99F/py6GDbSHV5TFliCS3alxcIAuA?=
 =?us-ascii?Q?DFavze3Bk81ycxPQj6Ti37CsTSWSiqZxWel/USiCizbj1c0kQKTgwA6VoyQc?=
 =?us-ascii?Q?jex3UCm3Im+CDIWHy0s4qY0YRjI/uwLtLicj6bT7UOJzdAZQeMixqqyDaJR5?=
 =?us-ascii?Q?YP0ooRm0H9K9o1aBJVXY61czGRYrTO38mKrBZnlOUczSMxdW09IJrl+q1ERw?=
 =?us-ascii?Q?88lfrUHklsFZXH77f0efCiCqWXl+WLKiqt7OfnyNJ5txe/cyVDH9H8DfCiyy?=
 =?us-ascii?Q?jyJNielcsRRAYUjHWsOs9V36D2769CARHYRObiTpKtCMAA0ZiZ5z9e/VrOYJ?=
 =?us-ascii?Q?gBzARdb+eu/eubKS5MR1FwMegghPM0GdZeAStZsT6pYWqNgSJaasTlImogOF?=
 =?us-ascii?Q?CqYm7X/H7r6eTXWJjhcxLTVZe1Oko6/OtwHw57QJe/IapHHm9uAR4JDQt7Wc?=
 =?us-ascii?Q?C4w9Z8Z5ex3B/Flpqb2UhX1jT6SI47GSEewo+3wY4AUhRI6k6oTevAbdEpzn?=
 =?us-ascii?Q?Z6+EiZTOGmFkuVoVzuTsrQF3BxkM5Klg+gOiybzNMHhxZ0++1Q9/410FlNh4?=
 =?us-ascii?Q?5jPjIuI4AbqsO9b2kQBiC513+Im5w4WWkXDEIRnU4Zw/f4ueCLTLsbuDwQTF?=
 =?us-ascii?Q?larjkWdHFURKVNyKVhqeG/yxbvs64YEQyFOqejKJykpTDaJwzcHXQGIcsSt+?=
 =?us-ascii?Q?7cEQv2rtlSQbaTrEGC7L+7W6u9sF/+rLiNIplLmnUQR2KZV0r7765ob0jAKi?=
 =?us-ascii?Q?9HAXY26eUKvWW0wS5dNltQTL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4087b062-7bac-47a0-a7a8-08d983ec9787
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2021 08:30:42.6609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /wAFMQ/7cNayD3zMjnpO0wxf86LvwWbsonVMEWyRYveUsO+Rq2s8gZ9g32u+XDNTECu0Qo59VowG3hqMPDfJgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2339
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe
> Sent: Wednesday, September 29, 2021 8:37 PM
>=20
> On Wed, Sep 29, 2021 at 08:48:28AM +0000, Tian, Kevin wrote:
>=20
> > ARM:
> >     - set to snoop format if IOMMU_CACHE
> >     - set to nonsnoop format if !IOMMU_CACHE
> > (in both cases TLP snoop bit is ignored?)
>=20
> Where do you see this? I couldn't even find this functionality in the
> ARM HW manual??

Honestly speaking I'm getting confused by the complex attribute
transformation control (default, replace, combine, input, output, etc.)
in SMMU manual. Above was my impression after last check, but now
I cannot find necessary info to build the same picture (except below=20
code). :/

>=20
> What I saw is ARM linking the IOMMU_CACHE to a IO PTE bit that causes
> the cache coherence to be disabled, which is not ignoring no snoop.

My impression was that snoop is one way of implementing cache
coherency and now since the PTE can explicitly specify cache coherency=20
like below:

                else if (prot & IOMMU_CACHE)
                        pte |=3D ARM_LPAE_PTE_MEMATTR_OIWB;
                else
                        pte |=3D ARM_LPAE_PTE_MEMATTR_NC;

This setting in concept overrides the snoop attribute from the device thus
make it sort of ignored?

But I did see the manual says that:
--
Note: To achieve this 'pull-down' behavior, the No_snoop flag might=20
be carried through the SMMU and used to transform the SMMU output=20
downstream.
--

So again, just got confused here...

>=20
> > I didn't identify the exact commit for above meaning change.
> >
> > Robin, could you help share some thoughts here?
>=20
> It is this:
>=20
> static int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
> 		     unsigned long attrs)
> {
> 	int prot =3D coherent ? IOMMU_CACHE : 0;
>=20
> Which sets IOMMU_CACHE based on:
>=20
> static void *iommu_dma_alloc(struct device *dev, size_t size,
> 		dma_addr_t *handle, gfp_t gfp, unsigned long attrs)
> {
> 	bool coherent =3D dev_is_dma_coherent(dev);
> 	int ioprot =3D dma_info_to_prot(DMA_BIDIRECTIONAL, coherent, attrs);
>=20
> Driving IOMMU_CACHE from dev_is_dma_coherent() has *NOTHING* to do
> with no-snoop TLPs and everything to do with the arch cache
> maintenance API

Maybe I'll get a clearer picture on this after understanding the difference=
=20
between cache coherency and snoop on ARM. They are sort of inter-
changeable on Intel (or possibly on x86 since I just found that AMD=20
completely ignores IOMMU_CACHE).

Thanks
Kevin
