Return-Path: <kvm+bounces-20946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83080927221
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 10:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 024FE1F255DC
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 08:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6801A4F35;
	Thu,  4 Jul 2024 08:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B8C3DRT5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243C91370;
	Thu,  4 Jul 2024 08:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720083197; cv=fail; b=hGhM6JM+4TGcGdMKSP3qf/iQmHPSGIsAjXjayVgYQeH8yZyaV4supSV8oZiBgFSYl+zfvq20sVjwRl4Q4S8ZvHObEmxeP/rkRnoaZHulhInLclu2HQeiQ5YONpQbdELZMzc+g0ww4usR0wLIVNaSKXfbXOhYSnEEcU5B3CqsHK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720083197; c=relaxed/simple;
	bh=MmwxgqKKOMqC39qOOvA7ZGtKcPy9vPzwR/Y4did9y3s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bXmxjdce24AnPh/jE+CBy7gacQV/XtAsAwuqEoIuURhlXJznbn0ZWjmSBeYaUEvDiEkjJp0yJwACkJNNtM9YNU3N3TT6kr5Ca076L/hIi6iM6fDnbH0amfxUpR3vJkoancjAuwPPEmkXLJN564QKutKCDE+2pgYN55/xn0uACG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B8C3DRT5; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720083195; x=1751619195;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MmwxgqKKOMqC39qOOvA7ZGtKcPy9vPzwR/Y4did9y3s=;
  b=B8C3DRT5P2N1ujZ59rvIUHOLVmhI5MkSe5HkZ/qXf2OA/DvhjWbEF6NL
   P7AucUXEOJbs2SVvQXfTkqtgLNj6+0wlle3PN529jKPVRJeBbqciQrFYx
   hThFF3bgo1VCd6JdSPQJbNDahB0JrpBJsupdNZtvTX0JY/EZOvFUPdBuY
   cw3pB4EqnoEHKresFIs2pKESdRsW67YcZAGNoHfKJptH8Muwooyewb6h7
   VAgu9Lk6DxYW+GyxAfyaN75dO+BkCAZ+FAWEAW2NrGv3/Xp7ICwYT5TDW
   sVGErjXJE6bmc9ISBA7weGCT39rQpownSiBstelgFse7EOYGTUZlHH2Dz
   g==;
X-CSE-ConnectionGUID: LzcFUwt/QPOQVJhaLA8tGQ==
X-CSE-MsgGUID: IMP1EAPLSiqJ9QeVtsXqGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11122"; a="34797923"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="34797923"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 01:53:07 -0700
X-CSE-ConnectionGUID: wdo75emKQsOeMW1RfFhX1g==
X-CSE-MsgGUID: MMBkf3p6Qg+ViyQ4y4mNHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="46426821"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jul 2024 01:53:07 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 4 Jul 2024 01:53:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 4 Jul 2024 01:53:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 01:53:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLD7VbR0sMIYmp43MnTpeHM2cHPsdx8ejb2ZJEcXgDiPF2q5UJRId7bLqZtl9w3g4wKKkQ7Ukoqwp8hw1CA942cMEBat3UVHJTS1OKIGEwHqiRNuY9RKqwCzVJl+4TZep3xAJY6N72/pqGe/Ukd3mfqvAP5ze5JJjcTCCX4mUx6z9SuwMb5rXJEVWczSw313tn71Zkg3RlptQIH0VnCK5hsDVW7qFqT8uuUPZh0hiGvSI5hiuU9JorYcsfQQ4dB8OijKlSK78mVkRFO+Co/Hnf580bFwY36Hf/RXkhvOypDJXQcZPJspW6h8PNGdpe7gMffcjEMWWy/7zuwurcBBTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mb55jfOS7X90s/FItSekjyQUyhuqR98Bw2LISqpuMM=;
 b=gdQ+dncTPiLk+RK2BLZphxezS9kY8M7A/JbDZfXCcde3HK+Jsmet1q3w5jkguu0KaNxGmYJHPV/bZzL35+st8Amh1BK+ma/OG6OVWVtIXdcW2IgV7rZiv0T01vKMfumtpzdgcbC2UeJDdXgwa4XVxrppHTX6OLI1e3sW/aUZxxknCntFuD6iLLbgkdm3Ve/FMNwcuRoU4wY7m8IMQQEO9gbSPce0zAgteAYJ4O60ziaL9ljWIQXDvUg4idIjtpM21dDbPbj7czdBvO9JW/un8yxtldpN4/eGytdOiefIuDzSh7xYMudIevbP7tuPClU5FPiKHKzR+0tg3dq670mG7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Thu, 4 Jul
 2024 08:53:04 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%6]) with mapi id 15.20.7719.029; Thu, 4 Jul 2024
 08:53:03 +0000
Date: Thu, 4 Jul 2024 16:51:46 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kai.huang@intel.com>, <dmatlack@google.com>, <erdemaktas@google.com>,
	<isaku.yamahata@gmail.com>, <linux-kernel@vger.kernel.org>,
	<sagis@google.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Message-ID: <ZoZiopPQIkoZ0V4T@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240619223614.290657-14-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: SG2PR01CA0147.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::27) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|LV8PR11MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 959d0ff4-8b9a-4078-a953-08dc9c06b719
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yYYnmMbHVwf97cfuAGktuWcTG+J8JOJNiUsR2tQGD2kQqToZECh2I0tyiOdB?=
 =?us-ascii?Q?NwbJLkl/PTzp9yVQEHFYIFFu3fVp0lQuEFR61pE89sIU984WVFKkSrHn5Tli?=
 =?us-ascii?Q?FlXevV9Y+iz86Gy4NgJOXsCeYVcQ6JCiQinT7lpuvBO8rmJGo773DV3dOD8e?=
 =?us-ascii?Q?rTdxWoG+7cyUH3azIzTPiQCsqQtNNJYygIUH+SjHxZRGsbPGT8ByVOqn1k5y?=
 =?us-ascii?Q?BwbovgoDzizaUZxsMg2gZLnkEl2/VOaf0/D1aii8aR7Y3rk0uvgoSQCobslr?=
 =?us-ascii?Q?owgrzyTkuELmC+21F90d7/gnZB+lnMCOFOy+SqytSGKWvR0KPg6FJ5NLNI47?=
 =?us-ascii?Q?m8r01RlBK+HjAVrRy4ruf+pux2YMxnbjsiKeq+YC6U+W56Ds9WcB8AAgWs2f?=
 =?us-ascii?Q?lu3XKv8kXfLeHMfNU3Av9bR7YtNedtX4hwKvmwR3BDRvmNMfwy0capk+tYhd?=
 =?us-ascii?Q?SZRb4EgfcpU7ioNitIkKAlrxByF+nJK8s+9oEqab6USLVw/U9jG5j2l8Rkxm?=
 =?us-ascii?Q?EIp4/bxs+/JMKALqU6hNQRPTbJJQBA5NF2bBDHbGV8XJfajb7gBI+Jd9g4Nc?=
 =?us-ascii?Q?SZAd7ZWd33HK8/XQVtvNmdAJeQKhhJ8Q9iidf//3b716ZSzf1NXHpVPGe8jm?=
 =?us-ascii?Q?vnFIMMKKKM2Svv4Vu7k4RG6foX86pVYaKyRMTW5bj3MocropaFBhwjS0jkdw?=
 =?us-ascii?Q?yjOspSEogTVKU6YAHMDA4KBDDJeROn0j4R+CkMAhQcwERRy4bE07Z0y0aEhR?=
 =?us-ascii?Q?8FKQewJYgk2GPwMRSAGJiXY4TJkUHfulDoqQJKoMqz6mdH9R+g2uve0eLGdr?=
 =?us-ascii?Q?boc9bPil1M+7iOy2olGRp9j4JKd3c9/veHb9SOXnzIWF8GgShsUoQ0NmMLDA?=
 =?us-ascii?Q?BRZuoKF8O+eKWQaGzRCF4ZHE3dM+jkxH3+Pzpu3yEdsq+1UfyN5BcVGmGlTY?=
 =?us-ascii?Q?pJUjoMfz1pXSDeA3k1pv+LjBjjwfBk8j7hDGEs0BG+aqu2BVNB7Ps52qsiGq?=
 =?us-ascii?Q?ugyE4DUwjtrXP4Q7klrXrg2PwkBwblycWPCFBrIEjtXtHzgYvi234/+B6/Gz?=
 =?us-ascii?Q?Pf7kvElBeQ/QRELdnLoqMWIWLe7q2gWKFXFOoiYQzU1ucI+cAGxTcdA9GP6I?=
 =?us-ascii?Q?Fpcr0YGWg9w+Omk6EDqmJQTB7lXwDpMqLXR2mD+rEqimlfAxsMsmMJEYK7W6?=
 =?us-ascii?Q?q7mutUKnKHFgqcQnVk3ggUpXnZpzJFHw3wKZ/m237cYZ559cgLMddc/Gxnza?=
 =?us-ascii?Q?uZuFuoD7CpUjDFuvFeV+zJeHar0LI4Djyg6EuS0jKT7bafXBsL+gUrk6OrlO?=
 =?us-ascii?Q?VUWKVFTRWfPTC2GmAMrjEGgTvq6fDT5SPTB+byKhRwqHFQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dXmjuHvKK1rC9oGgGJwpDhyukghleYcAD3k3fqNc3J0ftRy1vODdLy4HRpj3?=
 =?us-ascii?Q?DFLZwNtK8m3i392Hx84NVyGqFujgMrxMWTzmW8vbUEE5rXMUGnYgBUfhPwau?=
 =?us-ascii?Q?gb2uF/vhIvmMuCKvWaYZ5hCPKjZhYVWNZnjR7Y7cEwfomTW1KrU2eqYDuN7b?=
 =?us-ascii?Q?zE2jgd4RSkl9YkeHcax+ivQ4/KfwetPkZw3K2it8Ig/iSSyS/blhgivjm9lI?=
 =?us-ascii?Q?6/Z2pRg7FoiTg8OMu6HPX/G1eWX2GRJJh/L1CF2EkFvPle35mlzHA9ouugE8?=
 =?us-ascii?Q?EnBp6yM3VXhvIIRWQRzby9PTVPUrNtEIiPVf/2pq9A3TjjrhSkyIPWlcBKzx?=
 =?us-ascii?Q?XUjqHYMOiMnONd7mt64OmSSIaI1C7+C0tDjZ4kLSXawqPTiaOoa78vC63gNd?=
 =?us-ascii?Q?FjPHN7ZxQMqexVPLOMm4n5KmKFTGHJHXAi0U8zoVie72uf++cx0nxR/R3ELl?=
 =?us-ascii?Q?5DGxkWGSeeXj+i25ZiVrd9tO9AaJtmYKQ/W7l+juEtlOwA5NgXVEHsfigHU3?=
 =?us-ascii?Q?I1spSw3s7jDJBcvRNEGXANzbjS5lxH/rqEJJOH/sVWUwP4IeliRvilNt7S8B?=
 =?us-ascii?Q?/ScUZ1zIIvWYcHucKX1jMNWE54ymynT3Swsw+Z/hQLac7BWYjMBswXIPhCLn?=
 =?us-ascii?Q?z0TKAmZCyFjqduH0q4tCfKrKEa1kLfNdopquZ0/4ljvxXgvJaiFE090wPaQt?=
 =?us-ascii?Q?7tTUyMZT3iZqBBeZmCBe2YKYficZ6B2cFCbYDFs1b8cYWhbW0GX+cSXhGG82?=
 =?us-ascii?Q?/+Xh68yeQGwxutP6edfLsVfCJCIDNpNDkAlQcfi6Wg29GQhIStNJCdVAOUDG?=
 =?us-ascii?Q?G7bvY9lixYYYK54H0Q2InVUbmOTufBKwPhkEXvyEgGPPlgbzJMPmy64ol0H4?=
 =?us-ascii?Q?L0LUoCWrvJLjUoo6RNvHHzopI9OniXt+UdEO3MS+QaHaXgAT16KkJDE1hZTU?=
 =?us-ascii?Q?gc+/vJDNNeHPM6CcOHX7S0cLzZLU1XHG6Ily544i8o7vrldqquPAH90PHdRe?=
 =?us-ascii?Q?Q955hsiH+aNbLSvxk1bRLUwX7ZIFJJJ/MqI3K1gHb14WlinLBpbt//HXWYwW?=
 =?us-ascii?Q?yqs64FGAGMnY5YlRAKketq7KyHJIBPn4HrxE4I+tGVmjPO+iv0oUrLHHLgOJ?=
 =?us-ascii?Q?Z+zcbloe/tmwUzyf1Ojql45mVNxxvZw+nbAmwc97RgNsmk2vsaOelOG7XE89?=
 =?us-ascii?Q?WBKzQhqsgz571kluiF55jXp7vSqke3q3vtS67qDxh2CScQHwi0a4FlxhcSNP?=
 =?us-ascii?Q?/EKO8XLHt68U5+Ed1hg+kFn2vb0mwIP6kIhKeJhLDy6jZ9edz9jbXe/2zQPl?=
 =?us-ascii?Q?WmaNlaA/LtjC++NvGU/lZFpZbmfwal9z6GLK11Q8Cl67T0h8SCBeiseK5L+U?=
 =?us-ascii?Q?kPb2By+cOS+tmmUj8WGxE6mYUx4NaYtat62z3QQjc9NLaW7ewFpYUgUbh3oe?=
 =?us-ascii?Q?D0xT1HngUgKGslTTEhpdKTxyTYNHf5Q5T3AROEnfx0Oqx99DS4S62Iv085Q2?=
 =?us-ascii?Q?JxK0sNjb1tQVQO6sXvG11HbUxfcVrnyQtnSftvMuz5dXi0xcslGZMriBRQVo?=
 =?us-ascii?Q?GyGJjfLARgx9m/skE/NsCD0TwDHFqA5iTesKUUQK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 959d0ff4-8b9a-4078-a953-08dc9c06b719
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2024 08:53:03.6526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6jbAAuVBMRYIZ7EDSB2NMiAQm8aE+TgWHiGqunnfdkQ/59oTwvrpCgEg4wMXHYp3O4sgP6OVBPBQateCG1sbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8724
X-OriginatorOrg: intel.com

On Wed, Jun 19, 2024 at 03:36:10PM -0700, Rick Edgecombe wrote:
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index b887c225ff24..2903f03a34be 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -10,7 +10,7 @@
>  void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
>  void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
>  
> -void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu);
> +void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool private);
>  
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
This function name is very similar to below tdp_mmu_get_root().

> +static inline struct kvm_mmu_page *tdp_mmu_get_root_for_fault(struct kvm_vcpu *vcpu,
> +							      struct kvm_page_fault *fault)
> +{
> +	if (unlikely(!kvm_is_addr_direct(vcpu->kvm, fault->addr)))
> +		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
> +
> +	return root_to_sp(vcpu->arch.mmu->root.hpa);
> +}
> +
> +static inline struct kvm_mmu_page *tdp_mmu_get_root(struct kvm_vcpu *vcpu,
> +						    enum kvm_tdp_mmu_root_types type)
> +{
> +	if (unlikely(type == KVM_MIRROR_ROOTS))
> +		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
> +
> +	return root_to_sp(vcpu->arch.mmu->root.hpa);
> +}
No need to put the two functions in tdp_mmu.h as they are not called in mmu.c.

Could we move them to tdp_mmu.c and rename them to something like
tdp_mmu_type_to_root() and tdp_mmu_fault_to_root() ?

