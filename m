Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D849F544011
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiFHXqx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiFHXqs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:46:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B4F1E3F1;
        Wed,  8 Jun 2022 16:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654732112; x=1686268112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q2tMDw5/kuFY0X+wc9fNYRE9hUgxtUd6HZdsCctJjhk=;
  b=d5fBTGiWnYtamjgZ0cqd0jy5XEzGlEL9ZxokIv18m0W0Jvcf1Q6/szRG
   6vtPwXlszcAXlk/UMsoz/zWeAIeRRypuWJTs1H0d6WIcPQhSQqcjm7WMu
   4EraYZdJ59ew4sHAzFkKcu/gQg1+VlN6/3KaTevZDY7xC0eqYRoSX527D
   ThShescHx4iwjJvrWMLdfjau6R9/hpifuXpDnJkhtsVP4CNMThZLVv2cv
   A1M0Rp5As+1FaGx/jmYRpS0Jew+9plo2poo8r08VVw0+eI3aSnMRmwe/N
   SOYTQD9GzQURoJlShKXL1gSL21ltNy0yumpJ2MQ1A9lPrCYmhnAaR9g7n
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10372"; a="278249152"
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="278249152"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 16:48:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,287,1647327600"; 
   d="scan'208";a="637130451"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jun 2022 16:48:30 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 8 Jun 2022 16:48:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 8 Jun 2022 16:48:30 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 8 Jun 2022 16:48:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIdp5lG06MBwZ1Jk8hDP9DlRv8QIXMm2RQnJo+VyluIDYT6HdesTx/fEOVnnW2QYx/i0QKq/uY9SswbKPJAcaRbHW+Pfl5lwv0CB5+7dL673erJwWFMMT2t+0Jc0gi/sgd4ypeFryJqPwdf1a5Bv/Cgezuikq3J+KCMHZCsx4tt17gWjgVKsIarUea8fWLx8k4z1xJRSYTvJxgoxunUk+CQbazyuJnNLTkSZUVVh9BTpuWn5u/apG+OtoSMLsVchdlKMTCk3CilTqBDmkybr5RjNvrCyrNakOaHXJ/X5yId3X/bdS3xp33KgjPxlS/ipykf+VOrcnyt7bkvYVVXFKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2tMDw5/kuFY0X+wc9fNYRE9hUgxtUd6HZdsCctJjhk=;
 b=f1hlCMgvzZErpoU4+KBi6dYrDbatapz7d+zQGksvv22AytHZBpHt09PPp3iPe3wNcxXsR5YysJ5C4gTiw7+bBVlbDWJ92phuwqDSGOZ/XmpC0598qUt8Q4bnfyEz8lnleBcTT6AHbpPVKejjXQrQVJmxTmwAUdW1foSIxWbA5zafq5dVYy3+qD5ddR3WhJd+gfW/esHPDSUbatmK/7dKo/ccruc33+8CQHxzVBhSKZe8XPBDWVdVcgMvQV3ZU3GhT17gHZlVAdaEeWWrj38dGDUbHiuvM0he+gnAzxigDc3ItkUYEXSF7UZ4KmfB5FpUBZmcN620bYA3cKppSo1ZwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB5278.namprd11.prod.outlook.com (2603:10b6:5:389::19)
 by CO1PR11MB5076.namprd11.prod.outlook.com (2603:10b6:303:90::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 23:48:27 +0000
Received: from DM4PR11MB5278.namprd11.prod.outlook.com
 ([fe80::c5d1:fe18:c2f1:2885]) by DM4PR11MB5278.namprd11.prod.outlook.com
 ([fe80::c5d1:fe18:c2f1:2885%6]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 23:48:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Nicolin Chen <nicolinc@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "agross@kernel.org" <agross@kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wens@csie.org" <wens@csie.org>,
        "jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
        "samuel@sholland.org" <samuel@sholland.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: RE: [PATCH 3/5] vfio/iommu_type1: Prefer to reuse domains vs match
 enforced cache coherency
Thread-Topic: [PATCH 3/5] vfio/iommu_type1: Prefer to reuse domains vs match
 enforced cache coherency
Thread-Index: AQHYeW2KrRlTv4MQ5UeMm5INXClL961FJamwgAA6IwCAAMkn0A==
Date:   Wed, 8 Jun 2022 23:48:27 +0000
Message-ID: <DM4PR11MB52781590FB8FB197579DEE848CA49@DM4PR11MB5278.namprd11.prod.outlook.com>
References: <20220606061927.26049-1-nicolinc@nvidia.com>
 <20220606061927.26049-4-nicolinc@nvidia.com>
 <BN9PR11MB5276DC98E75B1906A76F7ADC8CA49@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220608111724.GL1343366@nvidia.com>
In-Reply-To: <20220608111724.GL1343366@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 22ff9e2a-f85e-436e-03c7-08da49a96266
x-ms-traffictypediagnostic: CO1PR11MB5076:EE_
x-microsoft-antispam-prvs: <CO1PR11MB507697CE93091D6E7F3B4A9C8CA49@CO1PR11MB5076.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zMi6L8nCfPjRbZpA7/0OpRfQjw78DQwKtrECuPw9cTZyJ6O3NkeoYN2sLZK3ZOhMP+v7ojObI//C6KjKYBafI5a0CbSTTvmEDt6TjC/tCt5NEsJDAWcTBTdBR+r8j35TZus8Z3PQ+7nMzrAcX906+E1XNjnYaatziq7ktsxb8WFiKop8S4N8KMjqhf7fmDPST8j0wqf55rW8ptBPNRkj6e7A/uyowhYzIaBYXtzpDpGr3SLILFJHuw0IW9KYgp/4yAK4SqIsP/i4qgSLFDB5g/QyW0VPaLQjYCzvKuZVmREBPatP1xQ5udMA/+o9STH09Ptcp1XTBTF+fmMiWyUalXc3XGwC8f0gjCp6U0O7ZD5nDuYgP8S+TLwT+w2IYBbTqakBe2h1qOn2PaBb3lCMX4FfocJWPKFvE3cFVZ26kCPnBpmcCjUAviVKKcQNz5fuNieEJv0DU9Yb8a9hsjunArUHOWTaM556+YxAiWJlbG9/h/WdmCnXhkXo5wSXpdwyu73MYh4Bg64turr8/KPnre3Rlw2EG2U0H5uEwNYfijLIpOvTmLZySl5w5m7wJHsGs61keyeFRxyDYBYgez72RBSHWp2LYdKeRFoqasvN/m2nd+ZSBe2pCV2SGdvadE/pNteWk9Clm4LbenFnXZ94FSImYcuJRE30zI53yCz3OTIQ5uQo5Ph8I6t8+CB5fT0sOpD8rjOTy27c+N+4lZfXdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5278.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(5660300002)(38100700002)(508600001)(55016003)(6916009)(7406005)(64756008)(33656002)(52536014)(76116006)(66946007)(66556008)(66476007)(66446008)(4326008)(54906003)(8936002)(71200400001)(8676002)(82960400001)(38070700005)(122000001)(86362001)(186003)(7416002)(83380400001)(7696005)(2906002)(6506007)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SNIBvjsNvOVuYLVgL51M8N9TM04WggNUa4Y5iORUglk+TSDU7n9X+rzUgPTJ?=
 =?us-ascii?Q?P+KVFBmhfR27/XCZ5W81jYK5qU4ETfHobi1l/xySD2qZqF4uL040MriKzpNn?=
 =?us-ascii?Q?fPZtrRPwF6buSaBFz1pKiIGZQXgbRVcfl65IAbrqGng/pP9qR7R+y5SxHJB/?=
 =?us-ascii?Q?UjXFRflqpA62JTu9Dwkpsl/Mc+1EFfohtg9MWGPORbnmuKxHvvcvSus7VGiG?=
 =?us-ascii?Q?7mO3sUWRLKeb4a7KK3ahEDnhMt/2PvtVuvgKMKddJYvpI/7NpEXtz4kk5rF3?=
 =?us-ascii?Q?mgFbUCHgzRm+o8jFN+u0JlTqC7eMeOL43E9dUmIEvXyudxGU3IzFIzorITJ/?=
 =?us-ascii?Q?SDjfY/SFGJNVT14r2zE+0VivRqZgth33vKCNg4FxJZgUReXcWPKGJrKO3lpM?=
 =?us-ascii?Q?GTONcVFeQwpcHQO15LlDi6GV/boS2hk7RHsbb7h0HxP/QFA4Z2ZHqT16REzp?=
 =?us-ascii?Q?vJAuAud5M1gXMwwL0DO6Ph9CPONpOa512pmq8dFne6z3SjaifVCDLcGoofjK?=
 =?us-ascii?Q?I1M4H1bDbyovN4CTwWlcKXTJ0oK7dH8JLNk2shyaobxDmzfd2zYo2Cg//hoX?=
 =?us-ascii?Q?TTcIw+hCwqadJgcOjdcfOrIAYxeLKjPTcE/dEQRAnOtKtl5OZhmZ+yEANClA?=
 =?us-ascii?Q?FKrKUl8bzoCzOpHz+1xy/8juUkTiF1VDupi8bFXpDnB6hxUWZ6sWGJQq0W21?=
 =?us-ascii?Q?q1eujJublee2inNdliDkXsFzzoXAUYpnIz7tc1aFDb9rD+nZrZmxuU+kyOfg?=
 =?us-ascii?Q?V3Waofve1ZLdt3rACVVC5tf2bRorgjj/IyY1i8ScA20FVvA7ad1iBtdjoj6N?=
 =?us-ascii?Q?bhM0VxicJRSf0PX5QDKdMAfjr9XPgIlgJJErMjjYvHIYOA+hNIwTWtWweiRK?=
 =?us-ascii?Q?qkFxJ04tdePm7Xrt4ERe7zbexaHwNrVG/m+zyL4qAkueo6czdZDLOyiw8SzF?=
 =?us-ascii?Q?SY+iyEICNh2VvGpK7FoCGpL0Wk2WfFkELUMjbg0z5ktthlYyqgSBxapUdapT?=
 =?us-ascii?Q?SwaiEKGydcfUn0Xje2RrhspKUERQlqB/kzndaOXBuEKt3P0yj8f5wixH2Plq?=
 =?us-ascii?Q?qzsZXQETIBdUxivZ94dATNrTPr0rm1FwL+zFm1CWBEMwfUrL2625PCuA2juO?=
 =?us-ascii?Q?HTOuw7Z7QhgATGRk7/2/V2NCiJv32NxeuAr3EElK1CjJVT8cyvcPEbURX9Le?=
 =?us-ascii?Q?xBQDsqaZxf/eNEZPktVui+0ciz/iuY8DwJWWDegWRY/oAu/ydxQlfKCzSHYS?=
 =?us-ascii?Q?/rYHZSYkqZui06ciNoyg1Ij265BQ7fI0NnXlWPpNKX4FxzWscFH2hFnWFvTs?=
 =?us-ascii?Q?lFDq1RF5VkfN1unRK2vsICEMqrl5fLYyV8DWo0C7Mzx9ZtxvSuMpjkWdebCt?=
 =?us-ascii?Q?6SP48gJkGdy8uPzYoL+ub3MAqdvRJzWrgUsNhTYL7u2/HiY9Y3F9NvOivA9r?=
 =?us-ascii?Q?1kSxpNpG4MgANXHKv2uIreX4RKnQ1WwBnTtqfxdv1NCAb8Hp6ikqPZ+3gRO8?=
 =?us-ascii?Q?H7y4MAhT8kHEfTrP+KSaxkxAY5reM4Nrk4YTadzAD99GZSHrZcW1h7dej5Oo?=
 =?us-ascii?Q?mwL6U9kKaxjqGv47E+BSYEXZylFwaYsQ+2HXrAb9v7sb7kHX/UTjXFZBJnrT?=
 =?us-ascii?Q?SpXSVKAwL6km1knOFmJTWgVJiorC964fwyHW6GfiPKhaIUP4TZFiaD9L31BK?=
 =?us-ascii?Q?MaPAgCnf2I6eTznmlKW9qHG8FGDKLfN8Jlt5bIGcMewDoA1oyje9Ni45uTYt?=
 =?us-ascii?Q?xN8l+bYK3A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5278.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22ff9e2a-f85e-436e-03c7-08da49a96266
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 23:48:27.5343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MFwcP/ZEW+ip9MeDEiNbeRV/+fo4ilZ7uGtf5Y33Nrd/OedK9nAAarAMgLStqaS3dN7WllGhwi0H7oGUwn3bzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5076
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, June 8, 2022 7:17 PM
>=20
> On Wed, Jun 08, 2022 at 08:28:03AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen
> > > Sent: Monday, June 6, 2022 2:19 PM
> > >
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > >
> > > The KVM mechanism for controlling wbinvd is only triggered during
> > > kvm_vfio_group_add(), meaning it is a one-shot test done once the
> devices
> > > are setup.
> >
> > It's not one-shot. kvm_vfio_update_coherency() is called in both
> > group_add() and group_del(). Then the coherency property is
> > checked dynamically in wbinvd emulation:
>=20
> From the perspective of managing the domains that is still
> one-shot. It doesn't get updated when individual devices are
> added/removed to domains.

It's unchanged per-domain but dynamic per-vm when multiple
domains are added/removed (i.e. kvm->arch.noncoherent_dma_count).
It's the latter being checked in the kvm.

>=20
> > given that I'm fine with the change in this patch. Even more probably
> > we really want an explicit one-shot model so KVM can lock down
> > the property once it starts to consume it then further adding a new
> > group which would change the coherency is explicitly rejected and
> > removing an existing group leaves it intact.
>=20
> Why? Once wbinvd is enabled it is compatible with all domain
> configurations, so just leave it on and ignore everything at that
> point.
>=20

More than that. My point was to make it a static policy so even if
wbinvd is disabled in the start we want to leave it off and not affected
by adding a device which doesn't have coherency. 'wbinvd off' is not
a compatible configuration hence imo need a way to reject adding
incompatible device.

Thanks
Kevin
