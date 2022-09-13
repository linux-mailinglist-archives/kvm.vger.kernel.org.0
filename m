Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F209F5B658A
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 04:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiIMCYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 22:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiIMCYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 22:24:33 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246EBBDF;
        Mon, 12 Sep 2022 19:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663035871; x=1694571871;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E/AR4shRJL0fTNPLZVw/S5zyCz0pjRtQvNMPFY3BhwE=;
  b=NEqZxNgVrmoqXgHylfw8lN04HKDoh3JR2JV6kQNJf9m/NoEvlCgW1ckp
   MDf4ivU/91UAS6Gyi+iqjngoqSshl7250O+bkDHO8qlzEjfvLZjRPN76M
   IM+cKNJ+kr4CqIccYP7elh9IwPMtJVSe+IN6NaSEXU8oKrtvo1rRmEVBq
   vGNd4/m8cKfAFN6tYEwbyMvl2Epr09QE8hoLTZnBHDtJm43gXt/5tdEBo
   3W9NO8nEefD7B2LwH0T7HxfRMwLtKJtrRJU2BZZmuFvzfMdPZbrE++/sn
   1/4k6HAeBKY1VUSJJA+yhvKiStta/oB/cGrjMQgnx2f5b3DRzhnmc0ZVW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10468"; a="277751601"
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="277751601"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2022 19:24:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,311,1654585200"; 
   d="scan'208";a="758616087"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 12 Sep 2022 19:24:29 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:24:29 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 12 Sep 2022 19:24:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 12 Sep 2022 19:24:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 12 Sep 2022 19:24:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD0pmxWQ4oSRjzzcQNYWOFbtJIyAicTfljkBBudEIuRIKl79bB1A+tnjBmtrWugt3vOLLWV5ZXG2Fd9UQKqCyDgsS2/3q+edShViZpGa2FUzXc5q9KlA0VcsJTsuzcDfZFSmafriKYc5y4JmouLSSzQaMLhyi21x2I9IgS+ARKVLnVOlSdFhrqeA0a+/DGInbS0tKf7c07LK85UsLOAjE5DhtLRcHyobsxYehbAfJhzT5wvW9v3UCy6MZvn+3hOs7uIuQpwCf0g2hwKBBVHojyOwxRy48bUEiMtJT5nv6OA7F+SZM720+fRuODybJuAlJFra38qhlM1RPnChwf//ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gmr1q4NzilLKb48dz4woCiahxcvqAowjUGdAHN8yQwY=;
 b=Vz+2jJlGEdVaiN+9Lj9yYFNA4GlXqQt6wbqPQLcfxuXNoc3QM2Owc6Oi3Nor9ca17W0ogVjmxTFTdDyn2Tb4O/t3Pf2UzVZKSl7jy/INjxXADw473ZRPROWhNEui18XrQN4uCEEIKz4Ugsil0lsi+lPiKIXeVg9QQNsKBb6ir2R2Cu1ec6zFPbWs4j44Thl5lT99bB2bYOO3CZ0Y7GBDDyE4Wg/BoNEE6jofFC2d3Ny5E0KXjIEYQ4iUGywxABycniZR8gGNlgShsk0KU35aK7wo3jwVTfIIp5Ft2hfVGd715+zmbn39l8jvtFhuhzRJ72Tx0QhbiSizhJW3AEVL0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Tue, 13 Sep
 2022 02:24:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a435:3eff:aa83:73d7%5]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 02:24:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Nicolin Chen <nicolinc@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "marcan@marcan.st" <marcan@marcan.st>,
        "sven@svenpeter.dev" <sven@svenpeter.dev>,
        "alyssa@rosenzweig.io" <alyssa@rosenzweig.io>,
        "robdclark@gmail.com" <robdclark@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "vdumpa@nvidia.com" <vdumpa@nvidia.com>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "jon@solid-run.com" <jon@solid-run.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible domain
 and device/group
Thread-Topic: [PATCH v6 1/5] iommu: Return -EMEDIUMTYPE for incompatible
 domain and device/group
Thread-Index: AQHYsNLwCXoHuSRk00qOEfaHbTrxlq3UDMUAgAASXoCAAAnsgIAALAkAgAAs1YCAAFRzgIAAh2pAgAA4BACAA+SoAIADUzEw
Date:   Tue, 13 Sep 2022 02:24:27 +0000
Message-ID: <BN9PR11MB52761E126D797ED865DC3E8B8C479@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
 <20220815181437.28127-2-nicolinc@nvidia.com> <YxiRkm7qgQ4k+PIG@8bytes.org>
 <Yxig+zfA2Pr4vk6K@nvidia.com> <9f91f187-2767-13f9-68a2-a5458b888f00@arm.com>
 <YxjOPo5FFqu2vE/g@nvidia.com> <0b466705-3a17-1bbc-7ef2-5adadc22d1ae@arm.com>
 <Yxk6sR4JiAAn3Jf5@nvidia.com>
 <BN9PR11MB52763FAD3E7545CC26C0DE908C409@BN9PR11MB5276.namprd11.prod.outlook.com>
 <YxnbRq5vaP/OL0ra@nvidia.com> <Yx0fVJpaojM5RNR4@Asurada-Nvidia>
In-Reply-To: <Yx0fVJpaojM5RNR4@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB6287:EE_
x-ms-office365-filtering-correlation-id: cb2e912e-9559-41c5-eb06-08da952f14d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z3CEX4hFUG2Nqb29WpSkXIAXdgK1JEaLh5Qs2MxC492r17qEsu5LySfls3pKhUSdUhynMbF/TM1x7naCcwlpTr8k/buDNnQYTa/1XTtFNBW11YpA4PE4qznnjuYSbpOQH7XSVDgYqNB1zYS4mrjSgTyUwBzfqrJEPntA7C3JX9GGIVqreGvSuFztPJDmb4ZqQfyua6bpOHVnRBQCJ5giM5Ol9kFdym4OuqveLPC1asDqduACfFz0uZIG/fq5T5bTwBir/UlS1z82/vwwwCDl4qbA1UokFNiyEALL7m9fLI1Gi+25POd3aS4clthhGfFcUlPJskdOjmj0VO01j8CZAyAd9xCh+GDkxIggw+7ySLZv+Fx4rvudAYbJn0X3UqU9y4WyyVemkLhh3T0IoGix8VH4V+gzY5tiyhX1J8paDajMHQlvZuaA36zUpC62wu9F8EFr2u9N776P9rz33+KFWF773xQXRnMJJdWG9E1+w11ka55KzaPeB2mPamP+uiIPTutLANAXR8+IMU75zWjLjXIbNQbmgRg0dHHNzzQejHEPpsgsNg9xj7kPexGl0b1AwHfNXKeJrNuQn1l0H8YbBl2CRAZKKxCEnLzLFZX2uuiDMGEfLS9aTWycYOCoIxjDA/hql50PbqqPGz0ERhsL/10wZu7cxIHpLnbNWxB9jhokB9KVSDEWd8uCxoHBqz0DEfpoxBfbGkG/AtQzEvYQaJHHzZeXmi6IrzLImW1CQRW8empi78CaaMjh7A4TJOWg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(136003)(396003)(39860400002)(451199015)(33656002)(38100700002)(54906003)(26005)(122000001)(8936002)(4326008)(41300700001)(55016003)(83380400001)(66446008)(66946007)(8676002)(86362001)(186003)(66476007)(9686003)(110136005)(71200400001)(82960400001)(7696005)(76116006)(38070700005)(66556008)(64756008)(7416002)(6506007)(2906002)(52536014)(7406005)(316002)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nK/dGxhdI4yhOc7aSCKjRuviVayMj9qdSq71WcRXwCfRaxC3JnDRwcyjk7Gx?=
 =?us-ascii?Q?OjF8YKgxGlka3RbZvXWGOeM38xmCWUrOT8jFQ7CTRCrS9iwrZ+8MwBpzv/zM?=
 =?us-ascii?Q?4XtUg9Nkra9KHXc+pemCqJPoZlkFVhDsWZRlCvs2hU2p6trAukPDJeu1SPPt?=
 =?us-ascii?Q?GL+tnLimF/E0g1hP6N1l+LrsTYdkncbH8wsXtaebiYJNCf3k7TueD2I94AB4?=
 =?us-ascii?Q?X4K4mai0n097D5mmj649Z0LUaSuwGJsk6MqidPei2Ma5OvSSlrrmGcovvEM+?=
 =?us-ascii?Q?IJU7Y9ZED6SDgn6fSLinRcs7Fc+dSdyA9pd8UDqc9kCxQMh7F791CN3Kis3Y?=
 =?us-ascii?Q?ZhNv1u/VBRVqhfKbn435ux9sryzy7XY6AsCcILYrOMlzaLHRJiLoV+K60Bn/?=
 =?us-ascii?Q?LKE98gQfKbbu9LTRx/4B0NlYFrik8WQo+w/UMq694/0RuObze5VvQdBuA5eh?=
 =?us-ascii?Q?Ug8DcyZ4O3AoYmiWLtlmTt3Qce9N3lb56ieyJ1dAGfAKY5WJ0ZlEqi/y0e+k?=
 =?us-ascii?Q?lRLURER/W0LOCjo+uYZmtUo0GL5XTy3i2HAff1RS91DOXw+d/Dxksqw55dg9?=
 =?us-ascii?Q?JHXd9TxwqAP0WMc4yNiPbH1I1aQNWBpHo5R9bamhBtT1UZUEQeQzcmUBQlkc?=
 =?us-ascii?Q?3bDlO8mavAa1pqlAMtu6ofM6Hdw7/NCrdo7VHkMr6E8ZpYTVeBVDf4QVr9bw?=
 =?us-ascii?Q?qzFIlNH6KI8520C13lEpP7RttwLfPmlceZZ4KmUs708qKwetz0AdpZF8aVs4?=
 =?us-ascii?Q?IP0pKeu/PiDkn9qW95Rf4UF5reTTt1ty3jDS2dmdV+Va55fvYK9cIZcMQGgo?=
 =?us-ascii?Q?dudmuG2QnGkVPceSJ0ata+oBBR95mQIzV8I4DI9WYa7fnZxeNXDsOcxFrhjI?=
 =?us-ascii?Q?lLFei560UPLXDwdRcViG80PYIUjCHlP80mq6rcN+cDhQYPt1vp8lSs+LwoLE?=
 =?us-ascii?Q?HREl11Ie4s8ZArVKeHAEr4Tz/pAWU4f1GxCbfco4U3ZEccz9oxLY7/4v9Jpr?=
 =?us-ascii?Q?VfRLkYTHmN9CpzR1B7cFQ88/ncfYT02DImykEt7ESZDR54Do2YcxNZbn5xiE?=
 =?us-ascii?Q?Px9Cv6X2heuwYkHeT0KiiaLD3G+eoZ7j9HsIcV5zCyibZ8cjoJ1iQaDlZ+0Z?=
 =?us-ascii?Q?lV029DHYEynRAG2bBzioAh+mFXONjnM1cIvkyrRewSSp4hTlAsNx9QP6yLBt?=
 =?us-ascii?Q?1Btjs0h/3kcJrRBNGUvkLAk4gsb6xpsCR5YVG62ivjih9kegIDEebYBYyv56?=
 =?us-ascii?Q?dBEh5QBDHaAAM6YLcMtiEec89r77jSCThCZMqK6ziF+BxpEgLvCuDHnLsCr+?=
 =?us-ascii?Q?XakpO56TFRoWLV+D60z5GtlonlCbcsweLEvIvh49mv1rIqeb4VThxLS4k4nK?=
 =?us-ascii?Q?WcDW405eM0y6C+wHU6Bzdz7W3CZ/XxG7vdMm7tOEcctOYXadEOCD1atrZNXB?=
 =?us-ascii?Q?YjwSTnllq7zvcXhlnIWt+lxNXkKrE1SISHZQuSN/RTIjulG9iuXJA2ix/SCV?=
 =?us-ascii?Q?VtakZnlI+GuNZImgks8m5DwyI/97zqXrQDHN/cvHDFgjC3Dj9Hl7sWq5rSuD?=
 =?us-ascii?Q?2zJBMgEUzPv5TlvQzvOnOEETy5QaRI2EmZwsWWeX?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb2e912e-9559-41c5-eb06-08da952f14d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 02:24:27.1116
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jWpH54w/Q/t+YH9UwOm4sCykuiP0zukl3n/7cxxat0i/oP7V2Dm0hUjtjzUg4wY7qukqx6VqE6fbJfDkgVUqtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Sunday, September 11, 2022 7:36 AM
>=20
> On Thu, Sep 08, 2022 at 09:08:38AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 08, 2022 at 09:30:57AM +0000, Tian, Kevin wrote:
>=20
> > > There are also cases where common kAPIs are called in the attach
> > > path which may return -EINVAL and random errno, e.g.:
> > >
> > > omap_iommu_attach_dev()
> > >   omap_iommu_attach()
> > >     iommu_enable()
> > >       pm_runtime_get_sync()
> > >         __pm_runtime_resume()
> > >           rpm_resume()
> > > 	if (dev->power.runtime_error) {
> > > 		retval =3D -EINVAL;
>=20
> > Yes, this is was also on my mind with choosing an unpopular return
> > code, it has a higher chance of not coming out of some other kernel
> > API
>=20
> I wonder if it would be safe to just treat a pm_runtime_get_sync()
> failure as -ENODEV, since a PM resume() mostly occurs to the IOMMU
> that an IOMMU client/master device is behind, while an iommu_domain
> rarely intervenes.

Yes, this is a condition preventing the device from being attached by
a domain hence converting -EINVAL to -ENODEV probably makes sense.
But as replied in another we might want to keep other errno's as is.
