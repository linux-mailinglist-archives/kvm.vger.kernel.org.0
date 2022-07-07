Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FD2569725
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 03:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiGGBHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 21:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiGGBHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 21:07:00 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0112CE22;
        Wed,  6 Jul 2022 18:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657156016; x=1688692016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RBAxeKLxMZj5UxEe5L0qC0NZhScEy4i2gd42SklDs5M=;
  b=YelLmRPD7pFmSsYX7XwB3v5tqcFlRLGCyuKndfFJfldpuUIphC6Cf+Uo
   sCWwkq7ieJPcxK2ZZvQ1WYqNfU2xor3gDzgEMdnwcFpfznizUgK9S+4Zg
   jr9mZozH3diLZjH31NQbwwU9bKAdoAiLqhzvOr5kMCDrM3hYBNhB8vEAy
   l0cm6a+qJwbN/BjtMDfOTBueJhH7ihq+uyTn9IRjWz3wEa/PnSVU2FZhz
   IxAA1P1ZaG1XCrj7XKQg7FX6FjxstlnG6Ny/wUto+2MG74wZstEeDahTg
   tnoGsOn1Z8x51CwBixrCrvDKPKJ8qr4unBgUEBkd/+fkOpT3mTDkqNjqP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="284642676"
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="284642676"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 18:06:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,251,1650956400"; 
   d="scan'208";a="620566140"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 06 Jul 2022 18:06:57 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 6 Jul 2022 18:06:57 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 6 Jul 2022 18:06:56 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 6 Jul 2022 18:06:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKZHX3LWXmljreWK3QOuo5phyiaSxyvYPOBNZHSpEKz+omb7mgH1XPRyzJZ1U7DORbUMDfKRK6qO+5V2dmo+wcvbOrPzT8Hc07/diTfJsQGrD0wENWDwM+vNZZuac9gSQws9vvBrJ8nzrWBkOe8eUBmpmjv9XRQl33UEgCOkp2JPszQcjuN3sVBeEpzBLPN60GCDpJOcKXoSK7NwFVkQo8DPgIt1cBCzvao+YBUW1PeWBKcssnhklhyJ0ZRqrLgEj+s+SR35JU6HZns+U97NX5qYhZ8f8KGL5EIM+ut168Jj9pOP6dSy192b2J61IsHxvYxYtSaQ2nXKW1mceq9QEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RBAxeKLxMZj5UxEe5L0qC0NZhScEy4i2gd42SklDs5M=;
 b=OyJf2CaCIc17bDIBE3ZXoQFFuLb2bwt3hiDAvk+8AEYyfy3IClcW1eBK6qlBfhxSQsg65DhsiKB9vD4IN673FZXE2YoW4xLRaGzPhFc8OI3lujr4l9+GO+3pEXJUX0dPXnu3VV9+25mVI5dBLhnvT5eynJi8mAnLrvhVOH0nlCL6Hz/vQQj/ayN88UJUrGQcGiqt+GPaJsQe9gHcuK75t7Vv3WU7DSrVqzWv8M87I+A9gNmTmG5zPonr9Glfp40PUyNdbjwWct9ICVa79xlczqfyVsl9SGezJdvZmdGuXgAqWBay+RhGAAbMpFmtT5RBJju+8ND4FbENShenVtOYZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY4PR11MB1669.namprd11.prod.outlook.com (2603:10b6:910:10::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Thu, 7 Jul
 2022 01:06:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5395.021; Thu, 7 Jul 2022
 01:06:54 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm-ppc@vger.kernel.org" <kvm-ppc@vger.kernel.org>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: RE: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Thread-Topic: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Thread-Index: AQHYjRJW3CSa5JgkkEy1u1YUe1sfEa1pEyjQgAXk0YCAAyljgA==
Date:   Thu, 7 Jul 2022 01:06:54 +0000
Message-ID: <BN9PR11MB5276FB34FE0DAC75DB5D61E38C839@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220701061751.1955857-1-aik@ozlabs.ru>
 <BN9PR11MB527622E1CD94C59829D5CF398CBD9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220705004919.GC23621@ziepe.ca>
In-Reply-To: <20220705004919.GC23621@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40ba5315-ccfd-4d0a-ffd6-08da5fb4fb6e
x-ms-traffictypediagnostic: CY4PR11MB1669:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9YgENrHH4eF6SEwoGeKa+kxdG6fd1SY19Pz0Z4zPon7Ru7r7ERm5VwwqVJoQ4U0fEf3f+hSoPYssyRibYJ7ITyLVfEVqJ4Q/yFP1aPc6tCBgD8FqHykw2dP/OjUM3ggpyfb8OYaCI0twh3eZEHDAkKdaMSpoeDcaxWed8R5zqhMXhywdjovesYVXNxD6/lWFAvBCN1JthRHX8/r3tW5OF3MSNnz8IAq2hevH5v7VYke9sA1bqmIECc3F/OIjT9YCobTHJQojZ3bOxeDg2mVgkoLLVTCCmUus1Y3UmJzuQEfTeyJK22+iKVSLjf83WMuPKaCzXr+G1yiFhbW9mjJtzrv7AVVIPLTOYOSu6sZkjPi1ShwoV2Bk652kNVIM2AMby0h2hRs2op92tgD+xRBbB1mGuKqF3kk0rNQaO3EomV6opOV421EMYbv7VkY7BvF1Hkca11cSSg7OiG87sTIfA0XM4s/lUo3Emzg/Ek90DX1dmJ7QSjDL6P1h/nxT2SRkv4E+OQ0WNTKKjv96ZHoR/GgaSrnIJj3jbEvQHRz95th2MYtAf6PaXscX3WBq+WeieVSRQwC+Epvi73Do6PVOwT8OkBM2aRZsjk7gOev0uMLa8Kf0/VIdaDQlcKcvrdw7ZmYH4gSmY13pzJs2j9GKpABB4/1lXaN0IgbnsUcbflGsQzdBRz1qwwdWCShaoFoNGIOHINBlTNntZhLGl4FAh2U8OeXknHlw+KKYFOqsh7f2u+pMHDdpJyEL1bmxne8mMoJeaFYX25yCTUtpM3cz0TtOe5bClEeGhdgrkXV3jvf9tQI4tUO8D9T4RAqQkHxM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(396003)(39860400002)(376002)(9686003)(38100700002)(54906003)(6916009)(316002)(186003)(55016003)(66446008)(71200400001)(64756008)(76116006)(4326008)(66946007)(86362001)(38070700005)(8676002)(33656002)(83380400001)(26005)(52536014)(5660300002)(6506007)(122000001)(7696005)(8936002)(478600001)(82960400001)(41300700001)(2906002)(66556008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dEyPQTVIBZ70USp99yRj/9y4L1un+HqrfFiTQUh9L8UhhA3E4X2pyPtgVGZb?=
 =?us-ascii?Q?CaKpRSlipQFuAoKwni7DSEZGlN8prT8NKjUE8ynNOgScCLbJe7G6kgGE3aIY?=
 =?us-ascii?Q?ZQHBs3tJOrI9kXqg3pjUe0gPnXdpgKMjWWYhkTniBe+8Nr8b72cEE2lFv8vx?=
 =?us-ascii?Q?nXuvPMIFFb93UQif1AVSYhAFAix9PZgauDqsGdh3IFWmFyjsEZ8Wgs5mFiBq?=
 =?us-ascii?Q?1Q45Gf3M+l4J9HtXj2mln42NKgidVywuD8UhGDRVcCoAReUOLpBsaCj/IxzT?=
 =?us-ascii?Q?LQQtZtOdZrho+Vqfb6tcQLC/N0tEUSPPIUIgxJpaF5Wod8U5c2nUcsemYPsb?=
 =?us-ascii?Q?p6iLWIcbsKl+Oz8ikjDYpaH2z8gMIBi1kxJUz0GVvZ4WdWDJ+rs1LiDBfqsk?=
 =?us-ascii?Q?+AOOvLrYUqRbvhhCiPz5UjK8jwmBVa2T/Y95/bF4mSFu0L8CDBu5oEKqUMEj?=
 =?us-ascii?Q?qQ5a+USI0EdIdL2/g8nq0BhVsbBxSV8S4iETl9QBISuDhaLv3IjT90oNNNmN?=
 =?us-ascii?Q?NwyE3RmmOEdGJqwJueBJLiidECJMpuTdDV07nR7U2TTxlRq/eAvaKtS7YxPp?=
 =?us-ascii?Q?vCFLl1pBtzcW2BSKVaBfI609qr6X7vF9SIinN21bsBsL2fHgyhZ0vefFncgb?=
 =?us-ascii?Q?C/vXOgRHZ/Q7S9PUeL5LpUnX9VUirDZlkCFz96RWQNSNJrFLr76MiTTUqNKZ?=
 =?us-ascii?Q?7VnU5++DxSIXUrCqqwpI0/rUBD83NE6QPyB/c1F84KkBAYO9Pd3gIjI/lT6x?=
 =?us-ascii?Q?1AjULt6BV3eMFuoIIZz8t0MdNB2Bao4NEfotT6+2hw1nbuOKWhCoiOtIA0KM?=
 =?us-ascii?Q?OL5LaH3cN6kPz/GtG8IxOZjSVcReMzk8Z01ScHk3G9AvPxajDT6XQpn35nG5?=
 =?us-ascii?Q?yg7EiCKX8xtiPaKir4MqVlOhkrV22yoVrGQ0LcGAil/YmmIQYyyULZYHqv4r?=
 =?us-ascii?Q?LD2K/L5pr99I91orvam+k+HRWkQ1I5OessrzmJuS5SqU+EvF7md1d7qxD2Tb?=
 =?us-ascii?Q?lYPV29RPKrzJ78420aKmx2Oo42PtRYAZTR6SaJF4YWxQrE4suvylT7O/jIPo?=
 =?us-ascii?Q?sQJYOIZ/2+LbIUc/v3yhgYovQh44iK+TyCvKBEkBYMfU/tK9l2GTslWPhalf?=
 =?us-ascii?Q?rqwIyivbbf6232MYXodDrMvGJdE/4Iffypw9NZMy7qUmtn+K8sfjsQIF0LHQ?=
 =?us-ascii?Q?4HwiObtSMSvH7JFqNFaLcSsvW3ffEJbh0Pa9/kHsvUlgi9TU3bSZEli7UxFu?=
 =?us-ascii?Q?TIBJwDot6r6GU9jXbOYAhka4rXt8pOuvFv8s5AsLGXVQ8kdKYuJU4ol+V8Yd?=
 =?us-ascii?Q?G+uz7rdcga1hGMILIyEwGp25bVWlxz4nVbVDD73nFEpYdZsthYHplCbmWpfS?=
 =?us-ascii?Q?MJXny3QfXquTrFoyKZsnNvzEmenFH/uSUnDnuZjvZZIepVX6mum6OpGMzTFI?=
 =?us-ascii?Q?Hemxm18Q/aP99Uq7xqYsHpiY6KlkKPN6Ixvv0J8MljuvPMMYcIc79/dx3RlH?=
 =?us-ascii?Q?Wqx3oyUEec0YQG7u3Zowtvno30vMmayvpanR2mIDWJPtA2EkbJ+Jn2I1oyOz?=
 =?us-ascii?Q?SlPoXgc0hEQv0yTattK5aaioconGYQculSaGIjvM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ba5315-ccfd-4d0a-ffd6-08da5fb4fb6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2022 01:06:54.3297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SvgNbwxAK+CGk4t4cc8eiLzRdwy3HWYW23Cc8ZgxKHdpjDVD3pmCwbJlF3zVOakBfVHtkQE/QjsOPTd2pm9+8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1669
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, July 5, 2022 8:49 AM
>=20
> On Fri, Jul 01, 2022 at 07:10:45AM +0000, Tian, Kevin wrote:
> > > From: Alexey Kardashevskiy <aik@ozlabs.ru>
> > > Sent: Friday, July 1, 2022 2:18 PM
> > >
> > > VFIO on POWER does not implement iommu_ops and therefore
> > > iommu_capable()
> > > always returns false and __iommu_group_alloc_blocking_domain()
> always
> > > fails.
> > >
> > > iommu_group_claim_dma_owner() in setting container fails for the same
> > > reason - it cannot allocate a domain.
> > >
> > > This skips the check for platforms supporting VFIO without implementi=
ng
> > > iommu_ops which to my best knowledge is POWER only.
> > >
> > > This also allows setting container in absence of iommu_ops.
> > >
> > > Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> > > Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache
> > > coherence")
> > > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > > ---
> > >
> > > Not quite sure what the proper small fix is and implementing iommu_op=
s
> > > on POWER is not going to happen any time soon or ever :-/
> >
> > I'm not sure how others feel about checking bus->iommu_ops outside
> > of iommu subsystem. This sounds a bit non-modular to me and it's not
> > obvious from the caller side why lacking of iommu_ops implies the two
> > relevant APIs are not usable.
>=20
> The more I think about this, the more I think POWER should implement
> partial iommu_ops to make this work. It would not support an UNMANAGED
> domain, or default domains, but it would support blocking and the
> coherency probe.

Yes, this sounds a better approach.

>=20
> This makes everything work properly and keeps the mess out of the core
> code.
>=20
> It should not be hard to do if someone can share a bit about the ppc
> code and test it..
>=20
> Jason
