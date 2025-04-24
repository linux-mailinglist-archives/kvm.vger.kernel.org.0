Return-Path: <kvm+bounces-44105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15802A9A716
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93D5C4452E5
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 929FB22B8D2;
	Thu, 24 Apr 2025 08:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bo0KgR9H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F5221F14;
	Thu, 24 Apr 2025 08:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745484717; cv=fail; b=g5x/Af12lIWmZUYxJacqx9ZY4iEFDxfVigcKF12+0VQcOUnxCTcq/YJJ8NpmAIhw6oZ0QQ9cue8NY2hiQXwJ1xjIXAVqiC8bKDhbth4UCLK//oaKw3fOr8EyEmpt8VXMDbje19U3P9LsBpSE8qazuxNtQdf2y4s/s2hYH2CTYqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745484717; c=relaxed/simple;
	bh=fdsXKLSK/+0VeG0PZOGos2gZjLCXQL/xWoA8IMWE/6I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IwXLpRCcQX7qeqx3Dwd8rDfGt25gfngmr+jJyCG0gqhDxNAI8gq0QdeuKbgAk7oHbblQrSzleWTHXQFw5Azd/2AbQkFPHBZG1d2JYnFVfaZuFLEDfqorkGyk/zPZ83hh/BjfIf42Xr2OXlIEHLLah8DWvFa3UTnSq6qq0+gg8v8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bo0KgR9H; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745484717; x=1777020717;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=fdsXKLSK/+0VeG0PZOGos2gZjLCXQL/xWoA8IMWE/6I=;
  b=bo0KgR9H5KAVChTjw5r72sXAkEH/+Xzj8KjnBzLt9/YQmmyuvwjzfLJ0
   U+CFq2YiHRbPU/Uj+7Hgo7ESfdDCxUp6N1KB3FiEuvIEpat3XvzxdmvWU
   glPd7X9Dpp5tr43xOqwflVvLXHWqFybWhwzlP5B1C7dPh0q+FshytWkCV
   gnr3UxnOdkkVoko9cLbMwoW8y1tJIm7V6mzAdm0LP7xs5mglcWsNMGgjr
   VfpzXEgAuBPqIWQvZJ9o6HkhjvSE0R4zHydrbfQ95p02Sv9B+6PPARrY5
   fWUAqq/uvdaH+eNz5sXl3FxiOKz+JNKecj2ANiw49IL6r0n2LEhRL+N+M
   w==;
X-CSE-ConnectionGUID: ni1JmYW4Tcq41bZiCNtDYw==
X-CSE-MsgGUID: lY2SkKh1TMCF+JuSjcM2cA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47119800"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="47119800"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:51:56 -0700
X-CSE-ConnectionGUID: k2rpT463ROGpnWdyR88Z/g==
X-CSE-MsgGUID: +DVKo6aNQJGm9DRuY7aCPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="132396264"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:51:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 01:51:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 01:51:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 01:51:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nTukuRCfSmTMmi/rYIHeqKiCao/3lAW42uIcuRI6xB+bzmdh4oz0jX9DGe/RQ2QsD6zOR7NK7nvTLixqakwINoJMpal4S/AfMUS4rE6gPvRkzmP31+yErrg4nNTcCY/B1pkiNrg/FtAgNm2suhfDczAo4JecO86b3hRaz8Xu06cW45Oljw6AJTYnFmB5CTFpqNUPuMQIDO8ZeE1FGuFJnl8adSLJ/poAcDDUzKnlDq/NksLiyfJ4WkGFfNVlvrTmd1/aILdzCoaoRKYSyBWKpsG6iKA/i7sLuXto94q9AEwHV+8vJHR61gDJlgQGXA56OMOTizYXt83cMarepUD6tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auGt8i526d6wKBgJgEnwZNJMB+JdabVXptml7YnbnkY=;
 b=VMELUx25eUwBHspYA0DCGMrhQG4dIHJebvSqI9hTzBsRC+SCsv9kESXOLH4i428/aOyXl3uX1llPRBfizCNNiLjkCTrfV8bSgDizT6FHRi9pX2RzvCT5gho8SsAFbz9eCoASKAif35mfvxJai6yUoUEUeSHN0EqBtE4KJdgzmETrjS7AzID3GD7nbBt+d7H2tFKtiv4fZHHmANdJynb75pXGA3J4rHGDrrVyBdYrUIKZyvZxe3tc23KFvnO7SqTJuOeEuwmGBD9ytVnkAP0azUfsu9bUpJ7BT4gin/OvfdfPDeBR7MpQN+Brne+xTT7HB2NGU+cUtpDyBlpZ9IsJ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB4826.namprd11.prod.outlook.com (2603:10b6:806:11c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.23; Thu, 24 Apr 2025 08:51:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 08:51:44 +0000
Date: Thu, 24 Apr 2025 16:49:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD
 build Time
Message-ID: <aAn7K9O8GKAvU/nz@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030500.32720-1-yan.y.zhao@intel.com>
 <g3htfhtzg23aynnmv4pqwothiub5ojewvm3xgoyfn7rpfwru5j@fdnrdiz3to7a>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <g3htfhtzg23aynnmv4pqwothiub5ojewvm3xgoyfn7rpfwru5j@fdnrdiz3to7a>
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB4826:EE_
X-MS-Office365-Filtering-Correlation-Id: a0aac3c0-63dd-430b-e9d7-08dd830d3d24
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/NB7TjbbskOv31IAGr5nwn8l1iql+8LwBos42MA652+AZt95szkwqj182Qgd?=
 =?us-ascii?Q?phVC0RbEsOvNQwUlOdkY4NEkqf1ZX92VGKADUUS7fV/NsSkTz3zc2A2Z+YPx?=
 =?us-ascii?Q?0qJM0LV6CZcAPiDXu8nCyrhsR4zpbV0USVUMMhMkBVz544/3DV6D+zQtpp3W?=
 =?us-ascii?Q?kt/u47jFCOuQEPqOj1OUWpUYQXx39MWo+J2FS9zPZqs8MSkGFmJEBwSlnXj6?=
 =?us-ascii?Q?HsmOveeoqCwmuRHYSc+Ukm0HPWoDHHCSmjlLCt8aqX9azat/0KyoW4UVHbFb?=
 =?us-ascii?Q?26Qoe6Jcfl9tXxF5MEIreVSB9HgXaLQuXJa25EIXzXMP9p1mF5qgCULpvh9Z?=
 =?us-ascii?Q?dwjOz16/dEJFdUbov487fMQ87BgA/yIyru5cgdz6sqIs6focgvpokOJJ+02Y?=
 =?us-ascii?Q?noKNmvloiN0P7h6o/A6gnLkpl0oAfXTLrUIcAwwG8NOoN1jE18icNKZL6UWO?=
 =?us-ascii?Q?7PhgDSZ/x0Az3GNyMkBaynZbBU4Z0hdVhWCSisBEXjYrT8wjCXPg63kadDqc?=
 =?us-ascii?Q?aj8hRTF5sKw94iKayQug2qk8spSEnWkDxdMNGPcv5a90ch2ZzTtAjXV+bCY+?=
 =?us-ascii?Q?fKrNGm5LcnwrSCsM6LilzPK5egBvTpoxKpQKLUbUuP+fiQeYG0FEgf9Y0ALi?=
 =?us-ascii?Q?UrkZgZZBtuokHkls0+rXUuQnnBdTmsNtREiMOOoJO6980pgFLTh1wqV2uyCV?=
 =?us-ascii?Q?grw5J6A1MjmcS4WEfKwTYtRwxhlY7DmAKaGRknLru87uflB/JTSf7KPRpjs/?=
 =?us-ascii?Q?978jjULwchQ9t7C9Wn3AlFqFGo7f2HLhOey07qc9bNu2S/78YiX7CbEAm2m0?=
 =?us-ascii?Q?kc9SfhYCo9zs3EKFQcEaUXFg26B5WCdEZQHdeH9eAbB7BKM20lcmwl2pAYKs?=
 =?us-ascii?Q?6+OBWUd4ZRVLGJTFvWzVf247AQNG8UEIlnxdL44X5/BcuWIASpKXeSKMtEA7?=
 =?us-ascii?Q?W8iTcr60fIDyG2qKoh7XSBLu1CyG7A3eFqqxXLnefO7TIPooItYt17nTDLgs?=
 =?us-ascii?Q?ZrsMlv9a7zsZ2uHx/XotqlLjk7i99CPO8YndfopQgsNCwz2xCsDPk3Y+0TlL?=
 =?us-ascii?Q?cHuOiP+chVjlBEsdBrKoEaXSC1WicXthyk3SAKVS4BGsu/jfoqlfiIHoAoes?=
 =?us-ascii?Q?TamFuw87NF9ZY47A07Gho3CsRFL9aBV1EfSzjth3XuuflVmOfM7iZpZwSqJJ?=
 =?us-ascii?Q?3p5kKGUAxQi/kYWn13XwlqJdieRzwj8lgwUd7FY1hz13h4oyIKkdtF/xFus4?=
 =?us-ascii?Q?SPFroOBq0uP/2Uf4nIuOJcLP8ZmHT6zJcdvuzS7BmGufrqmX+Tejft12fbzd?=
 =?us-ascii?Q?ZD1gYjVEWOS5RbqUSpdVpocoHZEKGAmBZ7y8I33Pf7tbbOzlOPv6ooob1Nsf?=
 =?us-ascii?Q?HDjzKcoJrAM6uroBVlQXIcO0deGl1i5T8aoHQK0SK6Pvb8chjSuZkqDsIiSI?=
 =?us-ascii?Q?mYAuGhZ9qOA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3950EqyGAHPrHvZ100Oto+lb1qwXDHSFiy5a976mHmUP6zKEIFyudXWVhDm0?=
 =?us-ascii?Q?QVvOqYG14Ir+X17MFB2mfbbsio/zPsHS52XVDigy5gwEvZNQyfYWcsIrkLAQ?=
 =?us-ascii?Q?vTLxKY8ZPhJdswXk68UybA6E6XkpgMI5MmsZHqZYXPc3VGpFIhii4oiEqSiC?=
 =?us-ascii?Q?8caWBt7C1vHNmyJPPA9slv4eN2RG1BmXzeuchyDhjpjwiZaZLTrwxM2bplrU?=
 =?us-ascii?Q?YQwHPKukQzmYpKxpcKE2z2OGIqGKfPIc/R9k2TTSLkA+Oy56PaFVZLeaUR1q?=
 =?us-ascii?Q?G0xiTTEMdD8za2yRLMfPSoKLuAecI38NurxP0PW+nQafwKFE/7MmaX/njmLA?=
 =?us-ascii?Q?u48h9hlOC+BMLs9KrQ2wFYPPNEY+uW2z8Jssk02CUpXEAuLYUixJ5Nqk+sNe?=
 =?us-ascii?Q?LEwJO9KoJOSTVmp0aO14EosyeTbo/rV9eVuWRiX4VwFLK1JKyGVJILgvM29D?=
 =?us-ascii?Q?7jd1k1gik8/QSssvgaU0buCmzK/5Gp091JM03Jvm6O3MU9MxFJuDNtftVd1S?=
 =?us-ascii?Q?huu/bjT3ZI/FDwaSHhz8lzof+VbhAdSZQHaTenLvUS0rXP1R4JlwPUUcUOYP?=
 =?us-ascii?Q?BEVUPI3SEeJBf6Plix0EUQk5REb0mVJd03x7Q69bGI+SQlDQyftBmubJML0J?=
 =?us-ascii?Q?mEGkm5YNFj70dozMXGDUE8Q/X9VPPh10JF8963rIbZyH1fPziDtKTXVfH62b?=
 =?us-ascii?Q?yPn+kCYtXp2zgCoaaNAGqVR4NfIfaMwLQm+LRm2NgbU6ceh/GXUPvFgYLrNJ?=
 =?us-ascii?Q?RKdK3PrjdIVI7+SL8F8v/ZqRLFu0VDFyHHQKsYtqaABvO4YMabUOHL7XwrhY?=
 =?us-ascii?Q?s7pvuxBIsG710QMP6QZidsBw+NYqNIw92TaGHsttTbPUZtKKTatmo+6uOxlI?=
 =?us-ascii?Q?jpTNXMmW4FGTMTFx+cZHlyi9ED73yrVXfswvygCVnvXyFd7RzhZafS2v4t/n?=
 =?us-ascii?Q?D0FKk3pmLeHBfl1IOstbGV+4DYbF0K+0ENgSNAwDxCJigw6giYt7QtqGBmD5?=
 =?us-ascii?Q?HQGy5aQnkezZx7mgY95upaFks/xOuQeSVj4SAhHDxukI6Q2z9N6iojaP2I59?=
 =?us-ascii?Q?J0KPepvwau0DKX0BJDrE6BZEXoS8qhSmTnWW9/GE7K+JyY6d6mpf5lGT60nJ?=
 =?us-ascii?Q?KJNWE/wOC6ix8ydEgg9ukUfaJkCQhjAQYoBo3ECgtJqp+p6ulMCtFfLuMRNc?=
 =?us-ascii?Q?gHDc2eQR6BnONrU72q3ESeQcjNl1zv4vC0RvCa5GZmwin29FQr3RAJJ0rVf8?=
 =?us-ascii?Q?d1iG2in+3ONxk5klZ+SYRB2T+BGSowzKdthkk1MYRBFs2u3SMfw4wRcLN/q6?=
 =?us-ascii?Q?9rCAT4SbZ3miNILGN9GScn6TDkChQvzyha0iUdNPZ3mXAqrsIFsZGIzEIPh6?=
 =?us-ascii?Q?iSa5yKg5WXNs4Va2cwMTDC+cACpX3QLDv5YB8wR+qziMyRE8OPenZzWjXu/Z?=
 =?us-ascii?Q?GLhtMBt73IuL0fzOF2CqLLK/s9cGOS1V6elN3MLZmO5VpHw0fWwR/g5JAll8?=
 =?us-ascii?Q?kdTqnc57m08VLn5B3vl0iqdOw2u6BNvKrzAwElAOhVdqt13LejbTvlfdNCBU?=
 =?us-ascii?Q?2NgQ6fE+d1iFT+pBDlTMO/l78ByR0Y/kcEyzXxkX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0aac3c0-63dd-430b-e9d7-08dd830d3d24
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 08:51:44.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdG/BeNy4tvN560EhP0qpbkL4ooaQZCv2GB5k9jFnbpfKYeLFg/C0JgKZ3GFwaDUks8lMJrO+0DT1yUbEO0ZUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4826
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 10:55:53AM +0300, Kirill A. Shutemov wrote:
> On Thu, Apr 24, 2025 at 11:05:00AM +0800, Yan Zhao wrote:
> > During the TD build phase (i.e., before the TD becomes RUNNABLE), enforce a
> > 4KB mapping level both in the S-EPT managed by the TDX module and the
> > mirror page table managed by KVM.
> > 
> > During this phase, TD's memory is added via tdh_mem_page_add(), which only
> > accepts 4KB granularity. Therefore, return PG_LEVEL_4K in TDX's
> > .private_max_mapping_level hook to ensure KVM maps at the 4KB level in the
> > mirror page table. Meanwhile, iterate over each 4KB page of a large gmem
> > backend page in tdx_gmem_post_populate() and invoke tdh_mem_page_add() to
> > map at the 4KB level in the S-EPT.
> > 
> > Still allow huge pages in gmem backend during TD build time. Based on [1],
> > which gmem series allows 2MB TPH and non-in-place conversion, pass in
> 
> s/TPH/THP/
Right. Thanks!

