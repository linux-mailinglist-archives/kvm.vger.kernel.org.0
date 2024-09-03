Return-Path: <kvm+bounces-25709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9060E9694FC
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 09:15:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 488902831C4
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 07:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E0C1D6DB6;
	Tue,  3 Sep 2024 07:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ncfav2BX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018E91D61A2;
	Tue,  3 Sep 2024 07:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725347698; cv=fail; b=eLjfy+lvhvWdb4BRY1/SanrKMteun+J9N3uw6SqbSFxQE1mr9VMERJoIe38ZUsREYoUqsVAuCNOUT6pUNZDndQC7AHeKt1wRxn9rpKC2teKLBj3NTCD8+SSWa8ENxo6aoZo2rbP4l/9/euvpkJwQl73MoHaZNFaGRLRdjRgHDRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725347698; c=relaxed/simple;
	bh=Qt+BHuIt4bQiFrH/OsNnap9bmppvdHCqMf0h6G9rqXM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GrqRIirVqhB9Oxev/Udn6xzq0herAM35q181GE4qPzbcj9k9pl7Ku2kw46o66a13p3g15Rc96lbYN5D90XaLVrYDKuN1Eg3UZkv16Ur9t9757kFzOdpDWt1bFWtbLtbEsg+pmu2eEx7A+oClCKJEiYj/SQBFlL/yvpi0gzeWVws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ncfav2BX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725347697; x=1756883697;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qt+BHuIt4bQiFrH/OsNnap9bmppvdHCqMf0h6G9rqXM=;
  b=ncfav2BXFvyFuQVAQd2OefR13OjAKukha2Jkk/vrWEuqNzdSxAuRS7+u
   51UGC7vbp1+YXKyzHXgwgI5qZDK/Yqn8FWBd2PWWk1QBpfCdGSLf584Xw
   DQkysz1B7x2hDaoU7gvkyOCxlNzsJmO06vWiv72/h/pdRQToXcX8jnaSH
   KThs/yTpv7UYJMN8HWNB5dVOfWS+rpuKRuXt/CGa1+cYqEowMDloSZjLz
   qDKzvFRRnwIjjbhB61fmDCDp+3H1ERZjavNjp7j2ybSYV1PskEVbOc1iJ
   Yr/01VaKcotA3v8HaMBxYDjZ9PDRgwn5S+p4Q/hewtyEFjPg9MK8w3t1p
   A==;
X-CSE-ConnectionGUID: 9wxMANBZT+K+0rGBTGJssQ==
X-CSE-MsgGUID: BMRn8TUKT4Sjy3nxklVrvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="26841486"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="26841486"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:14:55 -0700
X-CSE-ConnectionGUID: OAe3txaoSOasqB/lA30aTA==
X-CSE-MsgGUID: OLIkn8SSRgqsyapJ8QqC8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="64822231"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 00:14:47 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 00:14:46 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 00:14:46 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 00:14:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 00:14:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w7c2ZR5zcZnvqVmc3W/jEXVHgI4Jag25yDy+74yZZIHdzxb4jVVIVHUQqIudpeiEyXNT0G2nBJpfJ28BpLS6mPbvoJpMmfvgcOhQhHN+OoAOPGl77JZNJb0Mp20f9R+3gmSQEVXfVWpVDTwvwDC9XtGDOBa+jManpcL0xIOSFQ/qOH62nLV6TtQ4x9pgWPQnn7Wwu0Q5PkP4Ovxd+KxnNN33ic11WbdWN1e6BMn3CSb9P589+y5pEjXhNNOeNb89vOpUCdp+0ZqohHnHTqPmzCEOa0TmoqWjh68Wj8zU0iw+voNzTZjsG3dk6FK3aUXvN0hm1693Hbs/NJ4GkY0nuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qt+BHuIt4bQiFrH/OsNnap9bmppvdHCqMf0h6G9rqXM=;
 b=jKsvHIWHaPiSvVls/GfArkhoK1Gl9JJ3mX+Q/HvKM8jeGKZamsQvA9exY5X9SJg/00TAi1lfTL5jIge/57d56Rwz5yd8RLNd6BgigI45anji4eP06YtB33RY8mYSq4+tgwlcrfIuqesFUJ5wwhSBzCxhsaxllgMpKuEdgQnq25gq7FFhmm7YboKfpZvUgPchZMrh2HvG1MDQA/OXR8xZazTMkptJSNTa680Hpmo85cc9qUnjVd8KVMJHFXKtDg4/8lGVAFbKFU9NkxD3O436swl7DhWMu5xJEmubVGZk8L/CG1kXsvkPfPivVeVGo9QnJninfEcwdkPhT1oxv/dKXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 07:14:43 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 07:14:43 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, Hanjun Guo
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>,
	"Sudeep Holla" <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, "Alex
 Williamson" <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, "Mostafa
 Saleh" <smostafa@google.com>
Subject: RE: [PATCH v2 4/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Topic: [PATCH v2 4/8] ACPI/IORT: Support CANWBS memory access flag
Thread-Index: AQHa+JkhqkLnJjngX0qHXNW/ip5jXLI/cGLAgABmwwCABdlLcA==
Date: Tue, 3 Sep 2024 07:14:43 +0000
Message-ID: <BN9PR11MB52767F630CEC29646A7322BF8C932@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <4-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276313B7EE893B59FBD46F58C972@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240830135446.GP3773488@nvidia.com>
In-Reply-To: <20240830135446.GP3773488@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB8107:EE_
x-ms-office365-filtering-correlation-id: 475ad5f7-14ad-4923-215d-08dccbe815bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?riG2Y8GmdpTfmLJCKjRbhyp/mwt/vcaOhY0uDry9JrELgK2GHQ7bcC3w2s2P?=
 =?us-ascii?Q?GjKIlE2Qf1TdAdIVyZTUh0Gi64NolRzLQZv+gqDEWJCBsp5zi8FaGlJMtpAj?=
 =?us-ascii?Q?fzulyA5+y7GHzu/bFsv7LERv9uJ7CbZX7Gjb2Kbb04Mlqutz5FXrZhI/1Bst?=
 =?us-ascii?Q?PO3vOD44N9fu2YofRC2qYhVcKq4RMeicG7GqZ2IrgXkocv8LBf+71nyN8RU5?=
 =?us-ascii?Q?g+IZ/zpXltIan/pEqCJ7/f9CLHSfzqJWYOVjn6bkWh/BWnoYB7R9yayyGPKO?=
 =?us-ascii?Q?V5QWGa4f4qjrHtxce/d1DRqo0kHX3PLEw/YKql7Y1oPCNkfyPCKAl8mCnuQG?=
 =?us-ascii?Q?1gTjCi2LFY48RVkZS+yV6tA9Mafft39O1VZGfBdlMSNXplMBZmqoJ07WsLj9?=
 =?us-ascii?Q?lCUl+C8GLdB/5qNKbKpXh8wOMMGg5afrCoOayLNxvXL3QEoQEH0+iqmM/WMJ?=
 =?us-ascii?Q?WgKyUkq8odcNnV/5qJ60k3oWk/DMxoUQwIcghUB6S+k3Hcq/ZroDjpATthlI?=
 =?us-ascii?Q?2iGrmRsgW2+qZgPaUaE5WTuxrlk6NKH8Jbfx/JXVCf6bz8xR97yMBrFi5MlW?=
 =?us-ascii?Q?9Hw7XyTdCKNxLzyibzF9rGJYHT8cYWWXRro/ecvpJl7adhfYM1EFH3TliOwU?=
 =?us-ascii?Q?n92ngzbqUKP9Lrr8RaFNYOAU8F/lNxllUSqkeny2k7YO8O6g9GagDbGkDJPC?=
 =?us-ascii?Q?kIlOxdXKifLg8W7nv4OG25B5fltPqehcdKa7Rwgw+opPSqSCCrnCzWOzUtai?=
 =?us-ascii?Q?l571I9V9sz8jL7gQ1aat5gYHo2z6HBMCgFEIVWZwZYxX20+gTxANxHApWANf?=
 =?us-ascii?Q?CopbtQEqYMTGjodoYJj0PteG1LwLggRQ8i+Qtqnyzyg3wgyk5R0YI4zAlKrG?=
 =?us-ascii?Q?35axWVU5qdIag9qxX+l8esxn/l7pirUrigYMvzVBjADQE/KpqzcHGOOO+jYT?=
 =?us-ascii?Q?yChVAJl3QvHHyKQwgtGA1fpnO/GqnHXqy8jf0lqUkvi2UgciJ/uU8exDrgfJ?=
 =?us-ascii?Q?8GyQw2iCv5p+aq4jeXeCKDQfw7Rsy7YIAg/T/YXgdwOko1o0C1KcQdZ9kcnU?=
 =?us-ascii?Q?pgm1d7ZzeMPN++sZMxZHs3BrCQlnpy/K6XCCa49ewb6yLysKVrzra8lWUphd?=
 =?us-ascii?Q?TaWJ1iUFmYlFCKSrr+niy4kgY/c91pSfv72nkfc+hsbYcMKPSJN8WHqxKqcU?=
 =?us-ascii?Q?bcANy72EYMH/wwHzbF9K+y04tRH1te/vCn32jXCktodyVM+JMJRS3f6zWNVP?=
 =?us-ascii?Q?9Q2fy3OrAFQSuTQYJ/HRVXBVifo+cDC9NWfhV3mizMv/afxm2NqeDMci5Ddb?=
 =?us-ascii?Q?qHh+4lgW13sgX+RinmNnOOkmp9+jfNti8I6h6guCf/dVcZN4r0OVLrglU2M/?=
 =?us-ascii?Q?c0LQaZPLFvwKPX3i/lNOMqmWL4BiIx0Ywx+wv0Yn8d+De7SNwg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gRPKz5TPvpnO12+kWhGlM7QtKtsBKOIXpoe68wtJ6KD+XNVZyxWPKTelS0fg?=
 =?us-ascii?Q?EPiozsq3wMJG6u0VWZQy/807vo9bUnVa0lsIj70F8w9pbCv2RSeAoa8rSYWz?=
 =?us-ascii?Q?Bh7IJ4YjVgTbVewG24DVuev0D/IMs2nDoykCJMWbxSP9AzyqEWhm31B4Gsl6?=
 =?us-ascii?Q?ye7ppG/8IpJ7e6wjPaYzL6rsI3bLf1GtQfTn2dlkd6L5e75nIty1iQWqaROu?=
 =?us-ascii?Q?wKNVvBVaJwU/aJWDaCevBuEuLzU4uG3a4N29FMTgStTrRJB81GQAN+8UdRDx?=
 =?us-ascii?Q?1AnvJWSB9Us3EX2gpRExTmJC3608cX8p+V+KKAF5lh/kiuBIf40Q65L3VFs8?=
 =?us-ascii?Q?B/E0z9bjZBmfAITphG08QtxINePD8hJq98F8aMu/aBsPFf6Se+JD7fRQFRWV?=
 =?us-ascii?Q?SSatMjVOF4KjuAUVh489vju5bGv7FXjL5O0XTLrojypqRY3zeUCYLXpbjjV2?=
 =?us-ascii?Q?pFdjuAeH9Qnj72ncNOmkz28Ti0F0zXybCVxoE+vJa+5iNsNWZZxcOXxnxZW7?=
 =?us-ascii?Q?wsVRONOLdW+LYkgzdaK6iZbHvF7x2Mj6DEXh0GeWFn6IToyt49s8N6Mp8Vko?=
 =?us-ascii?Q?fVrcFN2QbyiEpi77shuP1SsWsbppYYUY6wsQ1UABMcledmvXnhFHuDSEqPR7?=
 =?us-ascii?Q?u0otvOqzjJ0r1QJRD08uncjE0oUU6jL2prcHsphgYFbu+7x3DUbzDiVtRAze?=
 =?us-ascii?Q?DgotbCUFyg0WtUIuorr1z3YoakL/D2ZpLFJYlzIsAVdVild7ysb/S4Eww5HR?=
 =?us-ascii?Q?wzkbhs2dwWseCwzwSka3F7Sb5v2f1hohGqgafsM+mWhFlLwZOSRkIl+d6PYh?=
 =?us-ascii?Q?ooc6Q0EvPhBG1pqxjNLxuaeXw59K0AFexMCtDIvELuvapqxOaSOKwW8+nVzB?=
 =?us-ascii?Q?KG+rCC6vET6ifodvVJkokzR0yjyMdqHTaBV86vdteXUfHJDwyJNep7+MmMgw?=
 =?us-ascii?Q?4aRLauZ5QsMJYPYRzdh+/q1ZiFrRYI6VBWfaaN6z9/iZrsRyb6UwIgOamOYw?=
 =?us-ascii?Q?JjGamGdv+tvWoCnELkaQbfydcLao8xVFr9zIMcyMeEczGqSA6nCcVErF7NAB?=
 =?us-ascii?Q?/fDLhvbmE66dBv/WJyeL1Cwg2TfSlY1xzyu5xlzuCfnygFw8oxF5k6sb6pAV?=
 =?us-ascii?Q?WXklN+M8/Taqt5Vu+Ze3w/qoTTUm8+ZpR/uAqMqqbPnH0R9+zQOvEv0XkfAW?=
 =?us-ascii?Q?R7wDGLIessF4GhWcyOd9J1YpywNnq5UINiq4y56nZ1YEcP2u0nGSZWls4vVO?=
 =?us-ascii?Q?6ZpaWmxeNSuhRN54hSyAurzXArWUFBH/I+rPHRbffoWXD4A2CBAnB/L9j0d+?=
 =?us-ascii?Q?KKDaU7XCVwHEy0mjWc+uS8DjF2IfkYcHEbgX8PTyqLjA6E3KACMm40LVaIN9?=
 =?us-ascii?Q?u1K4V2WR6/lC4+tEs85RvD8z+aNqZhcYGnSMJsky3e5eWq993+CHa84RIJUb?=
 =?us-ascii?Q?fTlnId7MTf1rWhITOg9SavNoh30QPs/+IyQSA6Evwl9Iowvx2YmGelCB5V/L?=
 =?us-ascii?Q?7WArvJ9FazlkxI7u+57FjnLmAbUMGZj9ZHzMKzE2E+qzQkEdpAOPi33XvjkD?=
 =?us-ascii?Q?YlzstlFUtuzqKlQPLDhWNuEa+wVOVwg22q0yJagK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 475ad5f7-14ad-4923-215d-08dccbe815bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2024 07:14:43.7061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sXwisxXT6vCI2Mfy1+SHHYWt3uO2Br8h6ovE4rt+2mrYES5FFkN9iEhqOy/sdvTkAge/WCQMPZlLhc7r9o39Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8107
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, August 30, 2024 9:55 PM
>=20
> On Fri, Aug 30, 2024 at 07:52:41AM +0000, Tian, Kevin wrote:
>=20
> > But according to above description S2FWB cannot 100% guarantee it
> > due to PCI No Snoop. Does it suggest that we should only allow nesting
> > only for CANWBS, or disable/hide PCI No Snoop cap from the guest
> > in case of S2FWB?
>=20
> ARM has always had an issue with no-snoop and VFIO. The ARM
> expectation is that VFIO/VMM would block no-snoop in the PCI config
> space.
>=20
> From a VM perspective, any VMM on ARM has to take care to do this
> today already.
>=20
> For instance a VMM could choose to only assign devices which never use
> no-snoop, which describes almost all of what people actually do :)
>=20
> The purpose of S2FWB is to keep that approach working. If the VMM has
> blocked no-snoop then S2FWB ensures that the VM can't use IOPTE bits
> to break cachability and it remains safe.
>=20
> From a VFIO perspective ARM has always had a security hole similer to
> what Yan is trying to fix on Intel, that is a separate pre-existing
> topic. Ideally the VFIO kernel would block PCI config space no-snoop
> for alot of cases.
>=20

Make sense. It'd be helpful putting some words in the commit msg too.

