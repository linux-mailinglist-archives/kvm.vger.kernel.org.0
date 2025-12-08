Return-Path: <kvm+bounces-65488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 53156CACA15
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45EA130480B0
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:18:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810C92E173F;
	Mon,  8 Dec 2025 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b9S6Q3vp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A682D3750;
	Mon,  8 Dec 2025 09:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765185492; cv=fail; b=F3Rli1PTY8UhObxPZsEHH8XUPKk46MOpyBxbRO8csYKbyd6p8fUDRUBTfjkyamnwtmWE2G2hlKCcQQwx8E1a6HFQrCV5PwiwWnXg0xmQaWf4UnwEArxUnu3HKtguebLvxJuoENrGHn+ZsZvxOiWMSKEPtI8d3RZYijTOo2BonQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765185492; c=relaxed/simple;
	bh=tr6hJsOw6tOdJS8gQZtVtXPVjXDKawqJruXDyOfPbnQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QS7MYZB2qPfQm7mt4I5BFp7m57mfV4BFRT2UXrI5ucmF2mKzy30j3fGjn4ns2IWwi3c5u/o3Gd6SfBdA9syRU/Aoilw5jmPBykGExWXFHZ9MjCdFrOqz/M0ogQ4hPm6DCJv3C00mGh6dsnMGcRi56AwZBn28tZULxl5R9Eoh4ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b9S6Q3vp; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765185491; x=1796721491;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=tr6hJsOw6tOdJS8gQZtVtXPVjXDKawqJruXDyOfPbnQ=;
  b=b9S6Q3vpJVh81e/xNljMCn73KwCJ1sWURUHzllYKCFejO0baoFomWWfF
   3Mi5gR9SpRisNQTYOomqvGLgyXUvq6Q1R4LCVQV05+RCOpaJWe/mO/3XO
   DlPiJHQU8HnzsRKUVeyIpR0TfYK1o8YZbXbbKXmrB3KAJBuSTRg+yPap6
   tCz6zpb4aWRvP9NnM8BD0d8VVFDxPhLojtNi6e99htHgEeDKx/pFJ3gxt
   ysTaO7nnEOSdGA1Pl28rQng2A1mETo7Dz7nDzPR6LgJnudZSWTSkF70SA
   GUIm1B61pkUlX/sv7XLkRRM/3LKVucl1zDQkk+PuWA2Wt5wk/eotJOuSs
   g==;
X-CSE-ConnectionGUID: T1yifhCFQY++JoWJNJTGvw==
X-CSE-MsgGUID: Do7mPeZnQ4OVzNqe48v+Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="70978432"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="70978432"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:18:09 -0800
X-CSE-ConnectionGUID: RFn007l9T66+TTYnzR6aCQ==
X-CSE-MsgGUID: yfwmC2H4T+Sw1tWg7lk7sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200065866"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:18:07 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 01:18:07 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 8 Dec 2025 01:18:07 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 8 Dec 2025 01:18:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LGG8u0mwn3Ev0N285j2NlD74bI0Dz0YxsgW4wPEwSJ3KkktF2deRd0aoUNeX1xm1lwxesbylaW1fGvHgm+/vcOHvpH6NhMLjOEGwteKpVPOT74ImfinSjDHPWb9sDWCdvWKl0mJkRWvCOiz/dmmpktB0G/NQ06T55SjFfG0RgJwf63gLDVF9K/L2HYUo3tDeeTp6irondx43a3zLRZio9QmS8wUOmvbeX3zz7mhiSAPO5AI+D7yAIM8LDD8s3ZzkIfnfr+vWzS85lQM/Jsh38Ye03pEhjZmmZhLgzxSrJ5Fc4JD6njzczFpBuCJeRMbrZxj1cuyCCGy0kzW/AkX/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQ10ggRKZhJd8q+ZmPx1MoeQ7YiaDlHJpPLGpjc2QTI=;
 b=NzSY9BFQfSs8rPV6yfvKRnpkuGWPOCyzYF1G+mLVu/69+GoE/daq7wccz+lWfGqxCC3x5WazU+injzYF0kkssVRZ4UwlPH4uk5oRuteC7QYJj+9aYPofT44LPtewdoa2UhR1BoifHfNq/Yw4rwuToGOm434fTVkkJ1xMQgRYrId6ik6aA1L8gsMRHItkfqH+sDzeNTvhrw8xSKh+wfJ7pXzhDli894/TwDri9P/N1gsltuUzM0g9crWeOiWYs5aBfeVjrfxW9+4M+7n/N0xxQ4jfO+p1GEEt0mxoyAzbanPsi+8bEmqBHxHSU6Fy3cLqJBslwgkuSMlGjEf5cty+dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPFBA72E12AE.namprd11.prod.outlook.com (2603:10b6:f:fc02::48) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 09:18:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 09:18:04 +0000
Date: Mon, 8 Dec 2025 17:15:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <bp@alien8.de>, <chao.gao@intel.com>, <dave.hansen@intel.com>,
	<isaku.yamahata@intel.com>, <kai.huang@intel.com>, <kas@kernel.org>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <vannapurve@google.com>,
	<x86@kernel.org>, <xiaoyao.li@intel.com>, <binbin.wu@intel.com>, "Kirill A.
 Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Message-ID: <aTaXQSu0j/9Y0bsY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251121005125.417831-8-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: KU0P306CA0019.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:16::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPFBA72E12AE:EE_
X-MS-Office365-Filtering-Correlation-Id: 1336afd4-331a-47be-49fd-08de363ab15a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CQUZXP0fQa/QigVavjdq5v9r3nCWSgdKMSmYm/LdGfCNajHY0rjRx59Z5Sk2?=
 =?us-ascii?Q?rOzVSgjyA36SjwrRK6BbRtYUFlwl3D3BjkewwvxIgZ7nHUsd+IztRjA1Q+wN?=
 =?us-ascii?Q?RRhOwTxIqhSgg+/0KEuty6lJkuhQW/CTJ/4q7PYKn4xFgxx6gx7Qr20mGKST?=
 =?us-ascii?Q?21zomTcB5TZ92Jza329SDErbM4WaUz84lWL9Lz3mnVsFbpxFH/qDeN9fV+3e?=
 =?us-ascii?Q?6hMIuxjguwJdBRs0GQEI9FHGpZ9Vwjfq4fIOhRSt7ay8Y9JrHq/zJAwyEutU?=
 =?us-ascii?Q?t39rubPFf3CCh3ZwEIJDqqj4R9oM2owb4MF4IUPBDSaO6yiEAvQL9Hq9FPOW?=
 =?us-ascii?Q?GxgoVGfGNgj+KkPsZcrUn9ZcRjJD9BxNbUJCZfNGtSY0MldGx/StLsIwciwh?=
 =?us-ascii?Q?m8bEwOJqpxxOlnpjb1IJhxFQisw2x1U3O2PnYiUhSFYebDIh6jlQGHK3EpMh?=
 =?us-ascii?Q?Olie08dYi3jPIPHsz3djDp9O0pJtB9h3wOa7Dzy81W0Tp1rZLODW03fHHE1F?=
 =?us-ascii?Q?uCMy4yrX6aF616ygNteCU7UQ+KXLuV/AfENaEDn9yOn9ncq+JwQe6SNNZjJh?=
 =?us-ascii?Q?NBtJYUBUKogJpY/Ek3Dmtl6kv3oxPfSE5aRnlN3I+976K+SghLdS6o+JXGbX?=
 =?us-ascii?Q?w8AxNuW3/jk+dYqf9eP0c4TLEHBCdrd/OU8me29FQgz+KVpLzEDoQxoxUHRY?=
 =?us-ascii?Q?ciVrvGA66m7Zikx9o8HDuV1NntD0MIqvRE896/WRJGHarNVO7gh4uPe4L3qG?=
 =?us-ascii?Q?JvlHKYvWc5fbS3+HIBmlu9K7ZDM2pzft87xJyDci/LY1qE2p0yZrJAiIkz/R?=
 =?us-ascii?Q?/eBndQqY90HRE2NawNRn3VGpexozzsDmkY37sWXZpks6aMZZLo0DlHrZJdp/?=
 =?us-ascii?Q?5moymlYyeY5vxpbVtx/ZBhsSYQtURgB9xtvhXJb2vbQcv0BSPbG3bKhMHNoI?=
 =?us-ascii?Q?Xh3pKk8Qs60su/J1epm5bKI8JVrsVsLlbmUWI52W8iWYb6CDitf7I+rpYFQ8?=
 =?us-ascii?Q?5+CzgoSyEjdEit8GNyXK2MOjP8ZNgApdmTeUAPD8DDluOV5IXI2Iu5LmbEKM?=
 =?us-ascii?Q?HM4p6xIR10Im2i3OpjmMfXA97yDY2n0FeVOB6i3k9p4AgIgcVUqagsnHB2BY?=
 =?us-ascii?Q?ge9jMdlysBJ12h80qRNrWOf880JxhNZa2nUZF2W2rqr6dkNGoztNx0ZoBvjV?=
 =?us-ascii?Q?XEClx795kQCbRnw/c+YydQZcyayoNePH8QgEoqhXOzAubGY0BNKwCzS3DsjS?=
 =?us-ascii?Q?LzS/5cu+7RUdMeN+Wfabeu1Nt7KrZwTcYUkVObL0Fhxo0qYDPv4MVxiKZ2x0?=
 =?us-ascii?Q?DxgcxBGZIV4ADEonu6xCP8f/eCGHmJDk2IqD9naOk4sHXl0Hiy+3AXmtvpli?=
 =?us-ascii?Q?LlN4JgwjaqCMoNQl5kQJQKZFed6Nu+CKfqF+Pdpuna2PyFlQ8P+XPXDmTld1?=
 =?us-ascii?Q?klPCHmum6BuJchicwqnh2xDNpD0Xi7/p?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pj7+g0chkotx8dlNA4nQY8XsPyIZD1MD6ptHjOwS8VfXTxoOFIlofC5Qo+vD?=
 =?us-ascii?Q?eOVgy1RIoO07vOKfgyK2UQT05WAoraP5BXvqJmM+TGs3q8A4ucI9Hc8k33Fp?=
 =?us-ascii?Q?Kx2K/fEJ+5hiMGU595x1tza4IDnNq4vxBNXRE1fGpmmKy3m8o5LnnH6Lae+l?=
 =?us-ascii?Q?Uip1fp9H6MKeY3s5iKpXyapsqRND6kFm1So9biyYIonDtpQB0zh0bqhFXR5P?=
 =?us-ascii?Q?geiEc65GcoIm1NQh1tHmdIN4fGqyZ1KFWm2WiCIe18Kyfqan/V81hRX/IaLx?=
 =?us-ascii?Q?D2x1qyHbPbmAAmGENw5BsAAtk7FqCndvhKKKfbezfEjoZrmDfIMGZ+rXg8dC?=
 =?us-ascii?Q?+kOHPbvRnDJh5XSYZCgiYB2P0NgH8yjUf1Y0E+ty7j7hI+r6+7ZEQo3PQchi?=
 =?us-ascii?Q?f8HuYPG3hNp1tEIgPc7uOiILgWdirvUftxcIXJITiAgcCPDlaA0tNjyZ6QOZ?=
 =?us-ascii?Q?0f1ieD+YlRbeylofImNfukv/UEQPcBD5GloA+lZoj0LFIIEBaULO3QGMLRNy?=
 =?us-ascii?Q?xuLZj+LGdbvWRhFu96e2SoWeQdXY/dfFDuuM2qQRD0AKnHSlFFelReuzHGLf?=
 =?us-ascii?Q?EzBJy+vCLGV16OoT+KbEtl2Bb632G6PImUtO0v9u6AorWL+vF3jlba1uwynH?=
 =?us-ascii?Q?yRpyZGS2/bzXuFQINsbSwQKBAGdEyHsPG+oHOnARsp5YJH2av8+VX8JotrK4?=
 =?us-ascii?Q?ZFD6XhlzEatoEMnEUGztXZOxNznGEXDd/SVEntkz/9TwmyKQLRsZeHr4f4DY?=
 =?us-ascii?Q?FfhMQtp0t62ekNP5iFSReGDLUKUFtGrER9J936sP8Gy2Wc9lIKMCHAA4FhPf?=
 =?us-ascii?Q?u5xelhJYjBNTTb9Vtkkho3D7owO7g07NA3yy2ucNEPOKP6os50EqPSqWCiyV?=
 =?us-ascii?Q?kF7oKifkOL6oW0/2K10E/zrkmXa8hDhxQVGFCGYq+jU9mwlWT6gZ2ptT2ZcK?=
 =?us-ascii?Q?Y8er7iVocPGUOe0htrbm9eHKhfNxECnxbo9w7vuJsueaCubmsIQysltRGAXI?=
 =?us-ascii?Q?8NSNh6tJ96ze0zzo45U7BHmtASEsMiJ9xiF4ffqV/cI4nVT/3oT++gtRaNkT?=
 =?us-ascii?Q?crLbVV7Wzs2tsq+Qe/Roomhg3woHeWCUzy9FfLtWTk6cXlrnalWxmb8U9gT2?=
 =?us-ascii?Q?HooAZBcTi5Y17uj3yFFXgjVRyugqyrruHZ99auEE5o7/o5x8Dk2TSDPFd5w3?=
 =?us-ascii?Q?QDb2Knsi6hMHd8KgxmWz5Q7GuMZUbYyWWJcb1ovdiFlH0A26wGiYt0g65tot?=
 =?us-ascii?Q?lzxyQFrODvdv1FAeCXHDUkOeKmTkBS/cJv2YnwUFMzT/ijJQ1F6tZ/bej2CL?=
 =?us-ascii?Q?i02XQMVFO/Ynuwk2kCcZbYifwFyEg2iladrH6AE9qzf2pYXrjDAy77Bhtw+l?=
 =?us-ascii?Q?ipPirTvdpG4586AycIwW0Q6vgowPkiU/Zmj3GTt8ry/vx22JN6O4hXILMR9o?=
 =?us-ascii?Q?v+3C3jVJShyo1rMbjvZ0JpLuwIRuFKXHdBAMNnSLaFsqiVlaL1N1Vil8vEM+?=
 =?us-ascii?Q?hMxdaxVxX/kw07ueEAVpZBG64ELwilHvGf9hL5Wrhs4+Xlb8Myrh1fKMcZwN?=
 =?us-ascii?Q?/jGAzkWWGeVu5lAA0HX656szfr6ikL8DJgFQLKhz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1336afd4-331a-47be-49fd-08de363ab15a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 09:18:04.8355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9azmeeYhozDSwaBdX3ytm0TA+HybVzfyz4e1+guIgUyaDIvcmeahT1fX3Dowb4XxKWH8NSz9VtSqwhKFCABSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFBA72E12AE
X-OriginatorOrg: intel.com

On Thu, Nov 20, 2025 at 04:51:16PM -0800, Rick Edgecombe wrote:
> +static int alloc_pamt_array(u64 *pa_array)
> +{
> +	struct page *page;
> +	int i;
> +
> +	for (i = 0; i < tdx_dpamt_entry_pages(); i++) {
> +		page = alloc_page(GFP_KERNEL_ACCOUNT);
> +		if (!page)
> +			goto err;
> +		pa_array[i] = page_to_phys(page);
> +	}
> +
> +	return 0;
> +err:
On failure to allocate the 2nd page, instead of zeroing out the rest of the
array and having the caller invoke free_pamt_array() to free the 1st page,
could we free the 1st page here directly?

Upon alloc_pamt_array() error, the pages shouldn't have been passed to the TDX
module, so there's no need to invoke tdx_quirk_reset_paddr() as in
free_pamt_array(), right?

It's also somewhat strange to have the caller to invoke free_pamt_array() after
alloc_pamt_array() fails.

> +	/*
> +	 * Zero the rest of the array to help with
> +	 * freeing in error paths.
> +	 */
> +	for (; i < tdx_dpamt_entry_pages(); i++)
> +		pa_array[i] = 0;
> +	return -ENOMEM;
> +}
> +
> +static void free_pamt_array(u64 *pa_array)
> +{
> +	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
> +		if (!pa_array[i])
> +			break;
> +
> +		/*
> +		 * Reset pages unconditionally to cover cases
> +		 * where they were passed to the TDX module.
> +		 */
> +		tdx_quirk_reset_paddr(pa_array[i], PAGE_SIZE);
> +
> +		__free_page(phys_to_page(pa_array[i]));
> +	}
> +}
...
> +/* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
> +int tdx_pamt_get(struct page *page)
> +{
> +	u64 pamt_pa_array[MAX_TDX_ARG_SIZE(rdx)];
> +	atomic_t *pamt_refcount;
> +	u64 tdx_status;
> +	int ret;
> +
> +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> +		return 0;
> +
> +	ret = alloc_pamt_array(pamt_pa_array);
> +	if (ret)
> +		goto out_free;
> +
> +	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
> +
> +	scoped_guard(spinlock, &pamt_lock) {
> +		/*
> +		 * If the pamt page is already added (i.e. refcount >= 1),
> +		 * then just increment the refcount.
> +		 */
> +		if (atomic_read(pamt_refcount)) {
> +			atomic_inc(pamt_refcount);
> +			goto out_free;
> +		}
> +
> +		/* Try to add the pamt page and take the refcount 0->1. */
> +
> +		tdx_status = tdh_phymem_pamt_add(page, pamt_pa_array);
> +		if (!IS_TDX_SUCCESS(tdx_status)) {
> +			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
> +			goto out_free;
> +		}
> +
> +		atomic_inc(pamt_refcount);
> +	}
> +
> +	return ret;
> +out_free:
> +	/*
> +	 * pamt_pa_array is populated or zeroed up to tdx_dpamt_entry_pages()
> +	 * above. free_pamt_array() can handle either case.
> +	 */
> +	free_pamt_array(pamt_pa_array);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(tdx_pamt_get);
 

