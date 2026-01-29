Return-Path: <kvm+bounces-69594-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wESUKhKte2k1HwIAu9opvQ
	(envelope-from <kvm+bounces-69594-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:55:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E165AB3BBC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8234C300FF99
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 473C830BF6A;
	Thu, 29 Jan 2026 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c0dx+uPi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E73090F7;
	Thu, 29 Jan 2026 18:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769712903; cv=fail; b=KLAHL1W3dTWK26/kijj9NfVzrp2e0rzkVJO/IWoLeUW1tDTfaegCdBuDoVBwnaAQBwN1Bdg7ZR63FuXmwOljkvyX+idPc/g9bX+0ZixtlYxkC2kH2g8540IhXI+6/sKBW2YiqwxeECBCBkqFhppEHikAcu0M35gJPryE90xXOqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769712903; c=relaxed/simple;
	bh=8sxFDZUEVNl+Txigc3wiflfDtqz78W23mn7Z0e0g5YM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ODErre+I7Jm6FHuD+wIqwECK2MBdLW/krYUjqUbKOM3skDNl72+rnJ8ivcR8ceDRUtruOOvxPnvTSar0QyOp62je3R3t0NtK3Dx/bN71lgjrrnpW7ENCcSFmXseSxvlo/9QEa/6cU6n9eCEUSvNaLtszwbM0rshftogCazY6dqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c0dx+uPi; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769712902; x=1801248902;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8sxFDZUEVNl+Txigc3wiflfDtqz78W23mn7Z0e0g5YM=;
  b=c0dx+uPicevgxoHu05jqeWE27cBvEhhot/xnHpsvaKHcYiWuowu+hpQc
   pVUvxUvI6nHSL3Vj8i2ITj7qtQTzqB1GGdwE3NFQxaxBFx79lJT3Tx3zP
   SewWy0HBA3KvOMF9cFnVf7UXNILDMRc5uLMTP+pBallT0o0kUQvnB9kEZ
   fJvzxVaJ8VQQFEapHH7gd/rWOOIfDfOkpQZNnr2DxGOazNgOvfG9JzYE/
   BakS/k+HY9blKg8bOsCE1TxaLkQRGfqVEldqidVdGjZppCsNCziw4CxBS
   RerOnqBx1fUR3XJrX732yl7agSwTZmDgf5DJCKk/5aHhd+anHvRBeenKU
   Q==;
X-CSE-ConnectionGUID: pFopIEx+TpWK3fmwN/P8Rg==
X-CSE-MsgGUID: sdMz+HMHSye62nI+6s8TpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70857188"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="70857188"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 10:55:01 -0800
X-CSE-ConnectionGUID: 3avqNTZPR5OzyAqZlGretA==
X-CSE-MsgGUID: OdQ7dGoRSuSQWzeon0DyMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="213184797"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 10:55:01 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 10:54:59 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 10:54:59 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.31) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 10:54:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q185bVNZCB03xlai37RWfFAnSHt4zJMoS3WmwUPTiO8TY3nJ+rHbZjOnAv/v7RCyc8Sx1J3BkW7VHcmTTbrYhPXtwJm8OtMztEp8ijDJeTbR2YoEULA2ReNXDsdleIIlWKmDqdxHc5YCXxaxyLG8TmaxipTgiZvDOy47DmlSR4nbeA4fUyCBcFDsteLDlZCtO8VvfAyGuQ81K3hinMADsoQYcUixCyW5SZEuH/UGw/t7T139L9jOJrUD3+fCyNS4/fAEgsIjtqHba3vPsUw0Q7MeCgSmkW5dmPKk8ZvUh81JfWmkt/0GTSDgZyc2vFL30ct+VUzDjgd1Xqn6hSs+gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3NqV/JzG59UgFZpuPW0RshfT3djiF/euB144BPCmmCY=;
 b=OzX1jZQLttI2h4pZuBTO/dXB2s7ln11YZVh0BdozWJQ6zQInt3FrktOWwhWMQay0LGA/z4SZjmo5LCzPHRJ2Eo9wA6j2l1n5uPmt7BMKUBOPfQERWin0DfQrqjrKGEBHs+RNABCpPY8RVDFVYNCRstSgoiH4hd9fTuWoT4epSKcT4izqnluuOvyGKkkh5QExQWHP0NZz5hqN22ANmZNbSqrbOjCCZUsSpUtBxlUaXZ3I44mjtAtMsPYn/BBLsR2PoZIxzS7W7dwtCVhmsLmzQJqeOvVsXDNDSi1u04BXW55oVEnzMl7GUu2TQpVQ1E/J9cbTfhMWabq7ZzWaVio0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB6730.namprd11.prod.outlook.com (2603:10b6:510:1c6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 18:54:53 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9564.010; Thu, 29 Jan 2026
 18:54:52 +0000
Date: Thu, 29 Jan 2026 10:54:50 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Babu Moger <babu.moger@amd.com>
CC: <corbet@lwn.net>, <reinette.chatre@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <juri.lelli@redhat.com>,
	<vincent.guittot@linaro.org>, <dietmar.eggemann@arm.com>,
	<rostedt@goodmis.org>, <bsegall@google.com>, <mgorman@suse.de>,
	<vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to
 configure PLZA in a group
Message-ID: <aXus-rG1BX8QWh_G@agluck-desk3>
References: <cover.1769029977.git.babu.moger@amd.com>
 <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
 <aXqHs0Mm5F9_R4Q6@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aXqHs0Mm5F9_R4Q6@agluck-desk3>
X-ClientProxiedBy: BY3PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:a03:255::18) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH8PR11MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: 3517f7bf-1148-40e0-d41b-08de5f67e2ee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Hi/4Hb4MOd+8oGgVPF72cJM1ziYWLTiL62bgkxxlOOzmNkYO9ecEvB6KwIiD?=
 =?us-ascii?Q?Cmua72nVX0FJ4tW/7muU4l2ChoURQ1R8JVCAJgC/2m75COpK8rhhd2NlKZ1j?=
 =?us-ascii?Q?/hHUvvaHHkk8nOjveee9mHpuWTJQm+VQFUPuLZAXHKsdfPPE29aAbJIzTglr?=
 =?us-ascii?Q?kWMvark03b29kSvbojCuHDakpHvyaNEaHMX3rjo6BXzz04IOffrSb4lagWB0?=
 =?us-ascii?Q?GRtdVFdLZNm8JPSWSY+XLQAvh0HBvWXHuQ88ixnLwXveGWat2pt8K6TETkCD?=
 =?us-ascii?Q?7hEqmGCpkoRoaPOBJ2Ng90qD1WykuRi7iQJUmxCRp+i1YtYlYfVZNjsw67vG?=
 =?us-ascii?Q?vx6rHPc4FC1ZmIPXIXXwpCsbcdeoe8Qvjpl9E/dZfVDRTRsWahGcg5Ihg2mi?=
 =?us-ascii?Q?8BmUNKFEIoRO1/m5wI8zMnJXjAD13iOaJ12UQkU2MLIouHNELYHb4quacwhh?=
 =?us-ascii?Q?g377mbM32c9g4JnfR8rraAbwRRCR9wAn1W7K8zAc1Ts5uFVUwTfDqssoN8BM?=
 =?us-ascii?Q?Hwa/awkcfc5j8SJbTSOgEAUbjRBg1n0YGYJK5d8N4pSyH7MqkEhwqvlqjK1l?=
 =?us-ascii?Q?Jy0DL1a2pPeCk975pVbTZgHPRXPpkvoAvDj+Dx+co9ndlIG/R/QzCfXs8MPm?=
 =?us-ascii?Q?LNEdrBAINnCjyf2XE6oP4FxkJtpOQlvlHxeWEkS68TE8s9cAOxNPaXoI3vkA?=
 =?us-ascii?Q?rngEDl3fNrOWdw/rOXDFS6m8Hgu4BpYSk92+pvWgGzIlNIIvuqjsyXgL++nj?=
 =?us-ascii?Q?NM/QkN2s+z/wCDqVuDM7ONo3b9/MssjOLFDUwV/gVhK84FsPDf//rhPPno4q?=
 =?us-ascii?Q?U+pmYOFPOE/42AqcLgkBOHRjLEjZ8tnjqNDRo5ZdyIrqVPq84Fnd1oG0KYOV?=
 =?us-ascii?Q?kUntkLxj7fSspWY0vEw0d9AUGqAeqDg1TYzXKuWYJWUOiAeDXKQ72rvFYs+h?=
 =?us-ascii?Q?BPcRy4K5/4Kn5m8GMLV6b6JqnkKNLgzrO3VVhiWxPoybEu/DMlWuPxUIXdSi?=
 =?us-ascii?Q?BUJbUV6dt2IN3Ik1Ae26FxCnChYU/s8jhe+vE+BCeXxagnVM+7W70X1IKG1U?=
 =?us-ascii?Q?0BSn2OGCDMXUD4ZMgTc5BWbBAK4QHMibawDEZcYdUMOISOCqKYzry1lIGRox?=
 =?us-ascii?Q?MXm2vOiwcxUxPl/UJdNHGlEDSxGeMGduOhgMTn+c1ITLMATiBSRNIAjMVOtN?=
 =?us-ascii?Q?vcXYqNxY4PSDObknHtYjwqzlFiTbr7OBt92YicBMReO0ru1ffkFXDSh8wjSO?=
 =?us-ascii?Q?J76kuFfZcDWLJSaMLoHkaDv5cvUFJxs/s1QgBsS/Wb6lcgTxxXjKl4Wk6685?=
 =?us-ascii?Q?nwjKPnMTb7YvsKQN1eF5RH2DIHHR7Yg56tvYJTVI2Lk6wLufLiL/P17M8znE?=
 =?us-ascii?Q?WAXkKVCW25uzHs+T0irbJSflciK6Bl1z8XhUSd9rQ2IyJEGR7s8X82S/f7aU?=
 =?us-ascii?Q?DwivQ66J8/gFgfKRNaiNnJ3s6M2cjArjMWnKLwU/R+xfSdAg8yDKDGTrK9iy?=
 =?us-ascii?Q?dnTfU1MgO+TFa+tlg0DVqG696+PDLcmikPa7r6UJYX7h0lnraKGSliIShY3E?=
 =?us-ascii?Q?HhjNHFdsI8tKy3t728c=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?raogRkVmHq66tg9id5wLkoNWFWYD+jVxL0quETuw9sTQSgbisbvmZjESxz/3?=
 =?us-ascii?Q?jQKtynalynGNzPsn7yIq4twIeAqzeb457mtbPsRuDymHwEvNIWACw9gI9YoK?=
 =?us-ascii?Q?NsfLY6rhCw9hw8tq8XAJQ9m/Eg9MO3BLN7ml5bG8TNVF9MnQTiMQuA+DzuRe?=
 =?us-ascii?Q?Ii7lEoIg+7jzjmI2z+huj19qALCpnPgbwInnLe53Y2TAVHMOd0Cq7Ivf1eN4?=
 =?us-ascii?Q?sb8hE+HC25y7AnrFBT9ZHxz5lPYcmXPNUMKRhzf91bjVTsKTFf1fvZLUhiTR?=
 =?us-ascii?Q?RRJqKjKKNiHUiThGI6Bdegy88Mzj/ayDuMRRtTtGq0FFrwbj1Co1KMJrh/tn?=
 =?us-ascii?Q?1BdqrEJ78yIsXw3da7tr8G7fdob4n6KW9B+4RIbQ7p9g5C1G/uibyBTYApAd?=
 =?us-ascii?Q?7zQvRC/ip2m7bTZvpZOwJIn9+F6/0D8f6BwDfkYvC4TAX2k42S9Ct9XaIMzG?=
 =?us-ascii?Q?n9VUmMyt0buMUnpKaxwccYK+BPfNBxGpjMt/2ONK/H8z12EPUzocuY0qPhzp?=
 =?us-ascii?Q?ldsMkerytBs7oCJqtyKPkZ7JwguzVsHehIt1XAFG1Xz0QPB+DnCdxeYpGEgV?=
 =?us-ascii?Q?kQqzfaJKspy3zMP7Cs6xDjo8Oxa/tXd8+R33s/F/GRlrt5X5Ne7TP0G8HYBW?=
 =?us-ascii?Q?O9yotVQHgro2I+1zF/MkqsMFx2xSHhH29nYpOB/HyXhbzWO+9FPrvYVtyTMU?=
 =?us-ascii?Q?COFOu+0RYz1BBassjO1PMr3GmnfkT1B+Caytyb7SmJdjv4toh94pfqX2gDTg?=
 =?us-ascii?Q?9lc7GXzdeEOFyBptomvD4tICm3AuL1jIF+St1+KUcM9hhIC0x3YZWWpRP4ko?=
 =?us-ascii?Q?+DI2mTSGnVRBqewhDJotWsUhwJ20Ylx8oKPJDFYpWOA+HBrz46HemH5EGqKw?=
 =?us-ascii?Q?6XTayYBhh1wnVE/ClIy5yfdQsxXT957eowbjNxcfs+ZOznqc1C6msYpQFDyb?=
 =?us-ascii?Q?vIKnAXAQ7bVItH5BwkYysbMddcWQ7UH2V6gkD058/Ms1w2HZYFv4qT465H2C?=
 =?us-ascii?Q?Ity8RUvfUiv86CajeU/XpZXeFprtgw23zDEuArnes1EXCDjHIhQ2lelT6Saa?=
 =?us-ascii?Q?J0pWdktj+xvlyCkld4/usx4tGrwtoSso/4RU4j1mC+oNGOHIe01fhMM6XY3G?=
 =?us-ascii?Q?RSwVOFbYq2U//Xp0yFgs0s7/flsjJTQv9DlowjgugGGTUJVKMKNWHCW6Y++b?=
 =?us-ascii?Q?xvbiFgDLQpN8/INvd7EUzyLNhIW/SOTlqz1Pkx19M477Yb45YM+jjP87rF+l?=
 =?us-ascii?Q?8xYnePNIimTUDkrRQ80sF2/ddX1R5lc4lYt0O05z2JxBZOKdPJsUR8ulPMkq?=
 =?us-ascii?Q?vivp9U6L0VX9AzFFFg9e+++tIwstEVLViD05WU4zopRanGXBprohMM1EYTXV?=
 =?us-ascii?Q?EVlprR72RsbMWL6rxXrZYTTqlL4rwk8ZPdAeVc2IXqvc6Xsd5q/SIa9r0C3r?=
 =?us-ascii?Q?CRxGHPSage4lO8C2+nbzOIWJY4PR9pSWw1jXdIPG10umNHOZvg1D0U0i2CcA?=
 =?us-ascii?Q?vEc//5jedrr+RifBs/XzE9Dl/Uzo9XFxYVzJa087B6qnuFlV/rfwRo5K9CXL?=
 =?us-ascii?Q?ivP75wm1xPevLNl/nwjLCFyxISFBptDtRwGR0LfFGQtzNhWH+k8jjk3UOUOC?=
 =?us-ascii?Q?daHNCJPHsty/MkNBIf14R6JWX5lFUiC3T8supgFVS6Klukjz42XMCbuPcVso?=
 =?us-ascii?Q?CLPbVPOvjpk0GnaMVZmQbjlOXo7aSreKDKi5cb/M96isX4whaRJfb89UcCGb?=
 =?us-ascii?Q?XTa2U7vBqg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3517f7bf-1148-40e0-d41b-08de5f67e2ee
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 18:54:52.8458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2E4syfZI+3ETm8UjQk6PQMwTOtzs+ni0KOoNtwvABEed4Xsa4maMNHIETxAky9I7ivlG4kF/Jw67KMUnMkd4sA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6730
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69594-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[43];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E165AB3BBC
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 02:03:31PM -0800, Luck, Tony wrote:
> On Wed, Jan 21, 2026 at 03:12:54PM -0600, Babu Moger wrote:
> > Introduce rdtgroup_plza_write() group which enables per group control of
> > PLZA through the resctrl filesystem and ensure that enabling or disabling
> > PLZA is propagated consistently across all CPUs belonging to the group.
> > 
> > Enforce the capability checks, exclude default, pseudo-locked and CTRL_MON
> > groups with sub monitors. Also, ensure that only one group can have PLZA
> > enabled at a time.
> > 
> ...
> 
> > +static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
> > +				   size_t nbytes, loff_t off)
> > +{
> > +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> > +	struct rdtgroup *rdtgrp, *prgrp;
> > +	int cpu, ret = 0;
> > +	bool enable;
> 
> ...
> 
> > +	/* Enable or disable PLZA state and update per CPU state if there is a change */
> > +	if (enable != rdtgrp->plza) {
> > +		resctrl_arch_plza_setup(r, rdtgrp->closid, rdtgrp->mon.rmid);
> 
> What is this for? If I've just created a group with no tasks, and empty
> CPU mask ... it seems that this writes the MSR_IA32_PQR_PLZA_ASSOC on
> every CPU in every domain.

I think I see now. There are THREE enable bits in your
MSR_IA32_PQR_PLZA_ASSOC.
One each for CLOSID and RMID, and an overall PLZA_EN in the high bit.

At this step you setup the CLOSID/RMID with their enable bits, but
leaving the PLZA_EN off.

Is this a subtle optimzation for the context switch? Is the WRMSR
faster if it only toggle PLZA_EN leaving all the other bits unchanged?

This might not be working as expected. The context switch code does:

		wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
		      RMID_EN | state->plza_rmid,
		      (plza ? PLZA_EN : 0) | CLOSID_EN | state->plza_closid);

This doesn't just clear the PLZA_EN bit, it zeroes the high dword of the MSR.

> It also appears that marking a task as PLZA is permanent. Moving it to
> another group doesn't unmark it. Is this intentional?

Ditto assigning a CPU to the PLZA group. Once done it can't be undone
(except by turing off PLZA?).

-Tony

[More comments about this coming against patch 16]

