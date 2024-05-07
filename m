Return-Path: <kvm+bounces-16810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCB88BDDD5
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:13:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFAA51C20B07
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8374914E2D8;
	Tue,  7 May 2024 09:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YJZLHU4x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78B114D718;
	Tue,  7 May 2024 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073210; cv=fail; b=RwqDVhvl6FR42XGQXqUh91YJmT6pCu03tidBRVpUjEP+ocRmLrfxuTS87a9CqBjYKvuSw95RVoAy/2jnPu9ue8J4uIL8R1X0+0WpaZfAi9EbB/Bv1zQqxYrBtPbieESAzhSI/2j8hwckIU6bvGOuRzHblkIn9FuSoueDqa1Upfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073210; c=relaxed/simple;
	bh=tkSdd4vaKS41dABN1xNcmft+6AHm3gB6iQo/olZCqiA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rKGY/ODiemOz4YXBTciFbABX8y+irgAZJ+Jr4Jwi+hHv1krxyTIZjaguuJ4zPJPnwRb+0dS+ibX5wPrRY+XfLu2K+Gh6VOqc44nmva3hXeBHSH/n3zfRW7/mpeAb/WBixq8f2s0Iqy6R0UhIdjbfnw47hd0IB+E/Dl/YlFdSItU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YJZLHU4x; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715073209; x=1746609209;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=tkSdd4vaKS41dABN1xNcmft+6AHm3gB6iQo/olZCqiA=;
  b=YJZLHU4xWYGa9Dnw6gWD2panp3SOeBgJeH7OQ+Nss100MKfpOwXB0CE+
   LSahVkPKnd6jSAhzQjcL9trxbCJqMd9tPoBPCoRoA6Po3XOJMKjp9gMZv
   MPAHiYJdDZfTGtA1bPyDBOym23NkH9ZLjhY1kg4IvyZzpGBHPovVK1dVj
   XDlC+Y5umRpvDgL9FjOcOZtkfRpe/u0BrCAxNamaFqrou5NtJHCs9FUdg
   g7F/ooQOutNOVt9/ZfBepSFvkQEcNVEvcrj3R3JF72Mj3RUScwFgBQnmh
   OtAYvj1uh5P2nf3TZc03NHVjZWyE+yIxV5z3nqAlmDfuIKNZnos1LbFik
   g==;
X-CSE-ConnectionGUID: 2glrbgkqSC6253oxJU7IBg==
X-CSE-MsgGUID: mGStkCdHQCiPF4jJASFNPA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="13807949"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="13807949"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 02:13:28 -0700
X-CSE-ConnectionGUID: /y5oQxUjQV+qcLZksaPTXg==
X-CSE-MsgGUID: 0/3+0TD9SNeyKb9NnitjNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28545228"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 02:13:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 02:13:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 02:13:26 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 02:13:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fpwTExwIYJc3vpQFxOg+qbSNBeZfcLNaOFS9jOPq4Kcj4AjxvQkOTxVqmaF3mwCA/w27/FqTQdDgVrs0FicUCwwSnjprtIYNG0kMSxwP/tMBJREM3ch1vICluiSU3NOsrR9lMtVsldN5O9E1HGzvHfX/FCOvoRxX/4ZiqVN4YLwnQu5A/tvu+eERvA5YwFPo38n7WiXN0a3F2DzLPAYo4eKGDKUKwmDwOqHDV0bUYaslmli4HuYOdRrs5fTfeJXnmoNNxYCsrNYMgc9q5NZo9AinRrTFgwqMlGu1cwPJDtPAndXxi6LyXz7VmA0RXVgqt5GEELqQXTF4IUtTTq2cxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UHfWc7V27EXKUKsg4bFcSahVFdKvvWSVOWeBeHHtW8I=;
 b=iIPVlYw3cUZICCZpPjLGV9M2sIYgRe2SrGWK9pHx8Xsslt2Tl6L4MaNSGoE13TZMD06MjouS75naSZMi40bA3Qvnm3bRc3iWS8PjiBYiTf1ocT1D6DhCcRDcAkSQjYWJmQ1qzewzvte11QfWkIvrtJcmBDCNXzr+ebst61bJmbSA3/OjkDrf71umHiiLOGdUZ0C+o4IhGlfp/4EnhxhzsVCSRTAnKO7bW2U45n1rJMbAyyAWDDOZJFamUTtpnoTi/guN33pxTflNPlspRfOvKEf388ABf2dYP682vyYMO5infB06p6z//iYqJ3b++I7RqCQjrpmMN1LAC9RiuCPg4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB6621.namprd11.prod.outlook.com (2603:10b6:a03:477::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.42; Tue, 7 May 2024 09:13:24 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 09:13:24 +0000
Date: Tue, 7 May 2024 17:12:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Message-ID: <ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507061924.20251-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SG2PR06CA0238.apcprd06.prod.outlook.com
 (2603:1096:4:ac::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB6621:EE_
X-MS-Office365-Filtering-Correlation-Id: 67a31a43-01f4-4c7c-f56b-08dc6e75f28e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fjAUhEAgAmbPCdqt+k7Y4hkEhLCIvYHau+/iZfYliV7xd/oo5ArywhOLPbEA?=
 =?us-ascii?Q?8fDC7FdYxM3l0ETiVdxE47KqGwcdr7TdLxVxZuCFBynBgg2YPR4DhHW9R5WX?=
 =?us-ascii?Q?4xw48xn5j5oX0aQqqF2xYOK34NMgsRVOkxwKdirXZRCerNK1eT546W2Ib3BN?=
 =?us-ascii?Q?qOckYkfwVwEBKRFHY6IslV/MZqLNfMdfZbTQoMgaZDlmstz0LQClz2JK+Zjo?=
 =?us-ascii?Q?kHa751fav7vPIV7+CGv7fdh2pABZgiaVDbbZkQYPMPrd0EMFZGqw9GJ089VK?=
 =?us-ascii?Q?8KApNrtjtM1F0DmjINgoTorCviU1dxVR0VIMORr0nI3Er9kxJ646FN9s/Ayw?=
 =?us-ascii?Q?UjCwl8cFcezuY9xJZW3o0ASkSDF1gjgyrV2KI3rccYdKlkAUcs51fAovYi17?=
 =?us-ascii?Q?W/Yq90sGZmuTkiMXLDGkTgiRrehoC2WGCdmZkKK9vIMByg0JM1iw6pMH4a+3?=
 =?us-ascii?Q?ZB2hdKFJ/53m2ybMf9ssGu1xyyQZaiKE9xEeWKFtc9hnSN9b3CVsgewZbTdO?=
 =?us-ascii?Q?WLKTqhbzqQnEIe6YkJ0gAjelod2f/iY3qjddbTyNp+D9gVAhYiiH3LJZ9X7z?=
 =?us-ascii?Q?uSuseXkJpcduEzdyY5ysHuxKgjqRS5b5ehmGmk5gzat72ctig4E9nxeqDRZU?=
 =?us-ascii?Q?F/sMZ86iropjKyka8AVloJf1u/uZqPDN7IXPEQkhpM7Q5xq4llulnlmQF9AF?=
 =?us-ascii?Q?DKQIj7rAYK+W9/YY/ShvrOG0D6ndDFWRNFLq+HNRpNga3N6yKvShuMkLlGgh?=
 =?us-ascii?Q?nnClNxIN5Rx99JOX4fTSSJiwn7sRwKKfuuz7Ivd2q63vwsqC4/4yEnDH3vGk?=
 =?us-ascii?Q?WzWTWUMuOaiFWC5cTp1mPjv0a3HeAeyQgjyVutdryrs+fqazGy7h9DDSofbj?=
 =?us-ascii?Q?l9fAkHuHRvyGO7xaTy6EktUh+psJwsGpR9V+ljCdTyyAPhEtsW4J+FTXy0md?=
 =?us-ascii?Q?nDKRwboGedrlZEgNt/9eiU2rBhditNDQqXEX5TY3U4UCUklioy2LC8iFYrSU?=
 =?us-ascii?Q?thMu8usiuXk4AV6LB0vql8/S0tvyBZOnxRRgwTeBnMnEEn32aDSQY92z1H75?=
 =?us-ascii?Q?48K//CMKlJkGKR7+atxbldsahGw/SdueJP4LbIC499LkQwfKjZlfVAY1xiWk?=
 =?us-ascii?Q?DIUqv8iqA7Iy9cyJ4X6Mk+9k26UosVUpL1JTZcNzgaYp3HtT7LsnOWJLR22S?=
 =?us-ascii?Q?ShYUcDVUZfd7i820bCH9d9ugt3XklIoXsfDSn61bw60Qgk1xwYlxBdDu4iIE?=
 =?us-ascii?Q?I8fuQhpOwHcy4UwzI9mfVVUOmNtD3i+stJbVDfkfVA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ilg+FHYBYRMB+jN3NUjfleDcUJStNx7srnn9+yqLpsPAQWg4+mlf+Uke58SJ?=
 =?us-ascii?Q?S+oJ0CFSpfI3+Vtii4gzVg9SUp2HMCBSJgqNQB8VQM0I+YqP3JUsVDDvmvV6?=
 =?us-ascii?Q?SrxVdA/qSchwPwMZC9ieLRudXojkbTMTT4KIVqx7Sa71DEgJRDj90LcAUE/G?=
 =?us-ascii?Q?5ABEKQsbaU8tMV2J0HgMbqvUsBWLzvnisw527kl8Z7GrnZ48UzkWHSqTskCt?=
 =?us-ascii?Q?Z9pMZtPom4U6bPkTJE69kpiaGRCErurESN+MN7HYTR3NtDjpP2NNQyXEZH0R?=
 =?us-ascii?Q?TNpoGA941bweuFgyAn2jBcirsmZMfN14uGXCURR6ugu7SeYZFT6gQOs/qJvv?=
 =?us-ascii?Q?x0XLJ6mr6uM5bGZulAEpMGDm4maX10V9MywUBZAygXnlQZFRD4R1jZOf1aeB?=
 =?us-ascii?Q?Uq9G03UBf6p+xGCG3uYDlUx1t5yl9Sw2W75d0v4O9w1AHgxgWWu9zvkCnYkN?=
 =?us-ascii?Q?gusAHM9EmJjHRvmyt9iOUNapAHcyseSyDofaxIboZ9gLODiegbjw0fJEY0E5?=
 =?us-ascii?Q?mE1zdTD0ygf771kW/R8ZINJ0TutVAz0IIUIKvTM8TwRNTQDNvVFMsLoZCPVO?=
 =?us-ascii?Q?cPNau+aaPi7JaNXg5b39E05iDNwClyySwGGyufEOWUbJhz7CioN6UVK/UtVR?=
 =?us-ascii?Q?swgLXnZqvoaALBOYl7uB8Ou7+k6KyXKze5ieWDs4OGqe9orSAX0Qa5PQj2oR?=
 =?us-ascii?Q?L8zdtoeAms4aP3xEdRJxO9/bTzH+PcDcpTzfl/W9Htflk4aT8aToAHA7ILe1?=
 =?us-ascii?Q?BxqR66OGsiwdTWtwHAaFu0T7NQoRr86jdR2b6lsApA42LX4N/p7x232OTvl6?=
 =?us-ascii?Q?2kocci5SoqLeVTSuZrZdGZRNTBwUbnUpVJ8Vk7eqH6oQIceUWxwAoQQge3hV?=
 =?us-ascii?Q?VSaR0kXdBgjlnT/zo2/ptY9fSQh8LjcW7oemCuVfqi3NsHpDq/OtBmJ6B4Ah?=
 =?us-ascii?Q?o+2E6K9gxq1GC+3HM7JnFv4L9orBJYpyYzNbxHdpqtJModqSVOJsTTyVUeoY?=
 =?us-ascii?Q?/EKBXfDA1/0hdC9eHPv2Pp/1M7v1WjOq1R+OU4TQp/xOtjGClwV3TGKhXOTX?=
 =?us-ascii?Q?PNKlVgSGXk8WQ9SOLEaFKwaRAamuL3jP24Mf+3xy3in65QHimdqfswNZNumm?=
 =?us-ascii?Q?spiIh61eNaHRFKIkwJW8197kZ0EwYfZ0Lyw10gyuqgu2dYESzfDCWcpdbbxR?=
 =?us-ascii?Q?pU5IxFe2NgEZ9i46oNErik87cXl/rA5ELrktqqSF9VfDDZKWzpurxM2q+isL?=
 =?us-ascii?Q?C3lbAXPo/T1Cn/aH+CLNsvW6mcHfIzM4B1rM09UXv+zTPC/5cs52aY0I7crm?=
 =?us-ascii?Q?O0TobUIQ70mXNBLq6H2eCOwwqzX+v/p6vOo3QHsphGYlngk66INfoD5O1MfE?=
 =?us-ascii?Q?XJKYh3Mp81K7mRDOVjs1eCAdBGLl2B+1/7rPpxaEX8Y5DXB0RxNdau0kw32N?=
 =?us-ascii?Q?gQjUI6xAJS6ZemzVMEsu4NkiT2BiinSP33V9JmqW4P6KPdH4JlOsmqJqyiyP?=
 =?us-ascii?Q?Q6ruxvX+w0M9HalYMK2uLreAi0Gcb+JEL3YbWvEtOlLYcD0hSlxi0m7pq75G?=
 =?us-ascii?Q?ObfXYk6BVGGh3CG4DcFeWHD68gKZAgdhu3xsxmdF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a31a43-01f4-4c7c-f56b-08dc6e75f28e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 09:13:24.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OCnSwAlYDgevrxyrAIJgrtmWOG+6GlKkkXj8r/gPCVCFlrGUnRQ8yhjNWioccitsjA3YgFmsoOLucKjcSQ/cvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6621
X-OriginatorOrg: intel.com

On Tue, May 07, 2024 at 04:26:37PM +0800, Tian, Kevin wrote:
> > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > Sent: Tuesday, May 7, 2024 2:19 PM
> > 
> > However, lookup_memtype() defaults to returning WB for PFNs within the
> > untracked PAT range, regardless of their actual MTRR type. This behavior
> > could lead KVM to misclassify the PFN as non-MMIO, permitting cacheable
> > guest access. Such access might result in MCE on certain platforms, (e.g.
> > clflush on VGA range (0xA0000-0xBFFFF) triggers MCE on some platforms).
> 
> the VGA range is not exposed to any guest today. So is it just trying to
> fix a theoretical problem?

Yes. Not sure if VGA range is allowed to be exposed to guest in future, given
we have VFIO variant drivers.

> 
> > @@ -705,7 +705,17 @@ static enum page_cache_mode
> > lookup_memtype(u64 paddr)
> >   */
> >  bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
> >  {
> > -	enum page_cache_mode cm = lookup_memtype(PFN_PHYS(pfn));
> > +	u64 paddr = PFN_PHYS(pfn);
> > +	enum page_cache_mode cm;
> > +
> > +	/*
> > +	 * Check MTRR type for untracked pat range since lookup_memtype()
> > always
> > +	 * returns WB for this range.
> > +	 */
> > +	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
> > +		cm = pat_x_mtrr_type(paddr, paddr + PAGE_SIZE,
> > _PAGE_CACHE_MODE_WB);
> 
> doing so violates the name of this function. The PAT of the untracked
> range is still WB and not immune to UC MTRR.
Right.
Do you think we can rename this function to something like
pfn_of_uncachable_effective_memory_type() and make it work under !pat_enabled()
too?

> 
> > +	else
> > +		cm = lookup_memtype(paddr);
> > 
> >  	return cm == _PAGE_CACHE_MODE_UC ||
> >  	       cm == _PAGE_CACHE_MODE_UC_MINUS ||
> 

