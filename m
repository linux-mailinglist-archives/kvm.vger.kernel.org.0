Return-Path: <kvm+bounces-65644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD53CB1B03
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 03:01:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B9DCE31BA00B
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 01:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2624A238C29;
	Wed, 10 Dec 2025 01:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKbqMYIq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEBB242D76;
	Wed, 10 Dec 2025 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331865; cv=fail; b=RPFiCmWG816SMYllgkN16LUOXikgyDVWGmjbqdR0ZsFEvyc4WA8IvA4nEgGqmHkPgGvGGCAZxiIl12qk+M9ufPBRyK1BlD64YMPpuziB/jcD5tXUuFir7ow5z+qq481IJbcNIiMi/46vKBoIwCL2oue88xtiROB2A/uQN6f2PCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331865; c=relaxed/simple;
	bh=/oJGS1t6+NHsbHF9Sw947aztSbKYpq2iDCfo/SrSv8M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o7Tb+QcRfWUQB3P6vyNxpjR3NKjiUpCO8AlSEg1Saz8utc01HlTKPpufkttbYIr7dXT2BNRd6pfxQ8wyMjU7wO+yc3NZrUuZzrLKaDrxAnuY7pSeh9jdtNhBOXdBjUsQtqKaTKqDjyxpu4zcrvHz52j1KEYAGEpEUh3wCRtVvcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKbqMYIq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765331863; x=1796867863;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=/oJGS1t6+NHsbHF9Sw947aztSbKYpq2iDCfo/SrSv8M=;
  b=aKbqMYIqT8XWMZ7/3dwvu5eGfH9YjvCYZG7adLjKk6cmxldQZ5pTqHjt
   KC2ipoab7wS1j6IO7xUZd0LDWmIOky8D5ncbuOwC56//2fFGw+z49+t9+
   qlymF0gM2n5na9LXCuCeATeAW/WCy269UgKRW2WIQU6vs8Rn7FOvmVIN/
   tXk3TiQp2HiJU+2SO/IjZ9mvZf2urwUU/sJ/e4Jy+L9bjlVld1UhZuc2U
   KHRk3im0ih1p59ynJjAaLtFFSlPWYQGhKmcoG5t0sCM9H96O4itnNilbP
   h73U5W/MmXhxz73I0OatFLTGr19lJtCXsaDfM0fQwXf3jkYGtcQsiFAUv
   Q==;
X-CSE-ConnectionGUID: SdjwsJk/S7yHGtGCYNP4/Q==
X-CSE-MsgGUID: I8p1c2whTvi7p2bwQSXPSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="67374504"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="67374504"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:57:42 -0800
X-CSE-ConnectionGUID: xs8UDiNvQjqSMQjfjMLozg==
X-CSE-MsgGUID: XIV2gCEZRTi4vh1uqV++kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="196131488"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 17:57:43 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 17:57:41 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 17:57:41 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 17:57:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TyR9t9+r7+oXZQ1l0YeCeUkb5+oTZUW7p6FIggEtdRt4o2zmVePAp02gquLoFvzlshlrYT521MaZvNvZygiYrJ1TVjiaT61/3qjW7it1gVSAQQX7Xb93ZOdM2mUN2GtIPBJrd+JzvWwL+hd3vGwTnHaRQNDCtTJYFFEfVsD8EEeLHCAOWfXSdYpndsanNAEXSlCAcup9uu0UF5VJlRk2rKgW9VSc0ljHiGHIQVkZH21wGHc2cunYm8YAmUsqgvr+OufIKwSPIxYIfNC+N9WeC9J9mXIpRjPrIhCycRURL00VYC5mwDKjawiSO+NI9lbOlwCaPdQek4/+RwmFRWsmIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BNi6V36jQaujrTZ9XdsR+vudu05bFEqz0cvCLhf2o4=;
 b=HMSKQHF4EZbnE9CFOgKMzOnABoZf6r0r6VI94zfRgqIqT2z0rnGZkKL5wa2ut5+gOFquQpeGPk/p0BzdsEZNcd1LpZB6Td9SW5vrLCIMyRhln/LeFMWoVT+Bj/OpjHBfqP3SpLBH2iRfGl6HtR+CdtrOKLHpXDFLmHJPEN8+880vkx3rq9QEP3SP0LDR6JpPcWYYSvinebOoSaLF3T3EGqgc3kVsRDpJopsgf6iuZ4zCDtEFVGSjr0IY9Q/TInnNbMRueqJCOnKtqDFo7Oc9J5G/+Ag+92oLyXi5JCQpUGjE4/10LjuGHCrMc9g+yJQahs2mEcF06VLy0cdqx1QUMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6430.namprd11.prod.outlook.com (2603:10b6:8:b6::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.14; Wed, 10 Dec 2025 01:57:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 01:57:33 +0000
Date: Wed, 10 Dec 2025 09:55:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aTjS/c8c5wNZcSgO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <CAGtprH8zEKcyx_i7PRWd-fXWeuc+sDw7rMr1=zpgkbT-sfS6YA@mail.gmail.com>
 <aTjKV/hAEO4odtDQ@yzhao56-desk.sh.intel.com>
 <CAGtprH9foQx=XLXXMqYnga27jWjCSkqj5QHVnAM_Akv7CLNmbw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9foQx=XLXXMqYnga27jWjCSkqj5QHVnAM_Akv7CLNmbw@mail.gmail.com>
X-ClientProxiedBy: SG2PR02CA0060.apcprd02.prod.outlook.com
 (2603:1096:4:54::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 38c7dff6-4d84-4e01-f8cb-08de378f7ba5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OStQVnFvNnR4eHZuSkdsMitJeVhySjdlaU1BUTNhT09CK2ZzVExQbEdkNVVC?=
 =?utf-8?B?YVd5UisyS0RnU3VaTHBxeTR3dEpxQ2ptMkQrMFJBd1lHMVE2emFJVXRNUzhK?=
 =?utf-8?B?VlRoYkM5ay9EWkgwQXhnY0tydW0rRDRJOU90eFhEWExJU1llTHR1aG51ckhK?=
 =?utf-8?B?Z2NWeVpiUnlsZmhYbmNpcHFCK1Q5L2UrVEhOYkRheGZzaWRPWTZ1M2l2NVl5?=
 =?utf-8?B?bW04RVJnQW5HTHQxQkJTanFGVGpuRDllY3pjNk9WSFIyTFNYY2RxRUtOSHN4?=
 =?utf-8?B?TlJEVXJQNW1uSmh2YUc2cUhFWDc3R1lqK2ZkRlpyekFqb3NCWmJYN0lzb3Jv?=
 =?utf-8?B?RUgzQllWYm5USzRFQ3lzRk1XWkgvZWExVWprTGRUYXYzVlY5dnAwNTZ6ckkr?=
 =?utf-8?B?cldrQ2N1MFVvbFFndnR2UDArWDh0QUdGL1dkMGh3Z1pUaEFLMnlaSitTNlhE?=
 =?utf-8?B?V25ZbkNHM2JCUGs4R0NsaTRsaERGY0NKVE1vcml3WGR1UUpiMXN2WnZBRy8x?=
 =?utf-8?B?VXhuMjUvTUNRc2Z4VkR4Tjdxd2RhODJGdm5hTEVjT1NxVVBOQ2NuTVJabEVm?=
 =?utf-8?B?eWl3MGszWWR2S1VnQUNaMjN6UUVyb2FyNGhEREpJZHMybUU5RmdGQkZHTlNk?=
 =?utf-8?B?NVh1UTRpRTNpRVFuaU9DZG81YlNib2ZaZDRNYmFWM01MSVlraFRaSlQ4RGUx?=
 =?utf-8?B?NmpQV1Uxbk9kazVLQ0V6LzZpU0ZJNmZrdjZ5VXRsQlI5NWU4VTMwTi9nZkMy?=
 =?utf-8?B?UlF5T0FGK2R2Y1p0TVhWKzBYMHMyM29QZzE3N2ZvbHh0VlJiZEg1d1Q1YUtj?=
 =?utf-8?B?R2hGbSs4bXl6UXp6TU9QSHVPRTUwTW9rd1F5MFNZc0VkdWVtSkNTNHNaZU1o?=
 =?utf-8?B?Z3RaU1k2ZGI3OUpmY0dPaGFmNnNmOVdlRzNIQm9HMlM2Rk9MWnJNd3JaUHdM?=
 =?utf-8?B?TEFoRG9WK3hMSGhhYzd3ZGNBbURVRmgvN254ZlNpY2NkWUlYWXlnb2FNT2hp?=
 =?utf-8?B?RDRUZmM2ald3QmU2WGlJRjJuRVI0ZWFscFV2YTdKaEg5RnpKWjhIajlsdXhn?=
 =?utf-8?B?Vk1Ob0Q2SmZJdTlaOEl0K3gyays0cHFWV0JXOVBiVnZISGlKc083K2J6MG1K?=
 =?utf-8?B?WEU2WkFvcm5XRGs5Zkh1Y2VFZUxaT0NqMWtCejdPZm1KK0VPejZRLzJlbXJh?=
 =?utf-8?B?VzEzVk94MVpJTmd0QUEwRVQ2THFKQ09ncFZtaTBlbmJ2T0NGNCtXRGhUNS9C?=
 =?utf-8?B?cjAzUkpoVUZpWUF0UHY1MlNxSHFDbnVoSWRoT0lCTzNxNmhXS09pbnQxZ2pO?=
 =?utf-8?B?U0h6UUptRVZST09YYWEzWm9Wc2hrWVdXQndXWDFtcGF3STRlZFM5QjVGNDdJ?=
 =?utf-8?B?VTloUVNXcGc0a2oyVnkvRnRHOE1TTVV5allWUElwZFE5ODNsVW5Gd1RwVWFm?=
 =?utf-8?B?eVFSNGJjTFlsVVdWdWs3TnM3Y1RYaW5teHFDUXMvM3RoMlZ1ckRGNzlaZ2pt?=
 =?utf-8?B?Tk9DazdSdUZtYXhUYmhhMlBwdTZ4dVZBQjBCN1lnN1ppRXBaRXVNNkhvRjU5?=
 =?utf-8?B?WGViOXUxVnlBazZhamcyMGk2ejFveVB2VXpZaCtvYk5hTU0wUlNzN0prNTZn?=
 =?utf-8?B?Y0VSSDAyY0g0YXl0WDJDSFlJTjRXb2s1UWNsZEF4Z3lUT1haUm43aGZ6bjRQ?=
 =?utf-8?B?ODFjY1pOMVdBVXk4MkFFSFVsRXJBK1RuSjFoQWNIKytJcHlXTFZ3UWxUcnE5?=
 =?utf-8?B?bWdPQkp1d3JYZlpOMURoRVVrWElwakMwcytmYlR4RVVicllkR3JzNGl4cFhi?=
 =?utf-8?B?c1JvY040VXhEMldvSEk5b2xqU0JsQXQ1RDlPVHBreWVvaUZMM0xuTFdkdFVz?=
 =?utf-8?B?a3M3Y3Q2TTRKenNJOVZndmdidHZYOXA2UExrODNnRzlaQkpGRjBRUnFzY29E?=
 =?utf-8?Q?xmtza7Qp3wua9tL/ln3cQKa37y4yNoh/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejcrdXRGZS9WSnZIRmpBaEV0OFhmQSs4YjdZNFFqRTVOUVd1S3grczJ6dmNT?=
 =?utf-8?B?NlhJbGM2cDN2bU9QRWNYeXlPSkhSeEZGSEl2eHF4SU9rNkVZajg2OUdHL3RG?=
 =?utf-8?B?bEVyRm9hWi8yWDUzekJFT3AwSjdORms2L1EwcTVCd2UwNGtTdFdSVVAyemVB?=
 =?utf-8?B?RWlSMGxqanFtT3ZNM1Q4dlkxRVlrZit5eS9iejhiZk5wN2gxY3NSRHJyYS9v?=
 =?utf-8?B?SUNvNUU0M0ErYWl3elluekNOM2YxN1k4RnI1VWlxQjJQN0Qxa1dyUEdtdDdO?=
 =?utf-8?B?RGQyc0cwaHFvbW9PNWVtV0ZTcG1hdGg2anpDRDRZTVFZQVBHaFBmYkQ0TFBv?=
 =?utf-8?B?bFBubTVoTGw3TU1rcW1pamJqNmZxU2t1SE4yQmVUT0Uzb04zSXByZWlXWFpV?=
 =?utf-8?B?emxaWmdCUUlZb1FhQXRvWUMyVlM4YjZob0VJa21jZVF2NHF5cFU3c1JZYkp3?=
 =?utf-8?B?SlBXWEE2Z0ZFYzFxc0VTaENpYmJmem11Vk8vZFdHeUkwSEpKaTlpUW03SjZo?=
 =?utf-8?B?SkFnNEgyOE8wT2lJcWtQcWhsSjliTE15SnoybTc0N0RtZ1N1djZBRE1PaG9J?=
 =?utf-8?B?N1pMU0RDSkRtWU44QkM2Q09yUXROYlNEMStobFl6U3czWmQ0bmgzRmI2TEI3?=
 =?utf-8?B?VWZ3c1lubFRnZENtZ0t1MEJQV0U5dEU3RXUwYWxGbVRDU0NXbTBCTVpUZnZw?=
 =?utf-8?B?Y1RVRk5vR3JNV25KV2xOVVdRbUNlbnJ4Y3VZYmtyczlyNk9VUi9RNU9DQXlW?=
 =?utf-8?B?Z0Nna2kyNkl0TGpoUHVxVFp0eFVWbEJRYURkdkVVditZa25HQUtHK0hlWmhS?=
 =?utf-8?B?UmtsT20xMjBzL3ZZUDRxL1U3QnlOWG1wR3QwRjg4dTlLd2VsdjRVK0l6MzJU?=
 =?utf-8?B?MDZSb2RqTEhlNm5zV3VJd1dpOHlJUUlTcmNHV3JmMHpuWEc1ZElEU1V2cjVY?=
 =?utf-8?B?UUdZcmF3U2ZPayswLzUxdFg1RmJIU2tuYUZsSGMxWTNQL1RUWFZiTW5YUHZk?=
 =?utf-8?B?Q1JqOHc1KytKR0VtQ1VhcTB4aVk5VUgyc1VpUUROT3VZdFU4eG9sNWdOSnZq?=
 =?utf-8?B?S04yck1YWU84L1RZS0xSb1FoQU51STFYTU8wZElWWmtxbFNiMjBqQTF0Wnd5?=
 =?utf-8?B?a2Zyd3Y5NFlHWDN0VHBjQ0xTMlpoY0pOTFR2SlZkNUlKQlRoZDlseStHcVRz?=
 =?utf-8?B?d3BLLzAvMFhMaE82MW0yK2V6VWx3WXdUQ1hkZzNrd1pOYjg2NVQ4em8wcG1h?=
 =?utf-8?B?WG9NbE8xdlVMTFpJTWNRYklxcE4raHc1VmE0ZTduVTBUVGJ0M2RjUnRLc2oy?=
 =?utf-8?B?eUYvRytwNzNSTFVpY0tueXlPSEphS1psajc1ZTVwVlpUa1EwZzdBbFBSZUM4?=
 =?utf-8?B?aWUvY1JlRFVOS0dhRFBMdGxaZldYbHo5aVp2cTZLRXZkUmZIdkZRYWNrQ1Ux?=
 =?utf-8?B?WUtBam1LTTdZVytFWnBJQzFmaDBMYm4zbU1YZ0xLWHNWdzh1RHlqeUhWVmxl?=
 =?utf-8?B?U2pVQ0lzcm9BRDZCNEdPVjJrUCs2VnBycjNnalVYSzQwZTV4MzhnYlpCV0F1?=
 =?utf-8?B?cHpvbm1ORDR5QWZxVDZnZEM2Y01JSEora2VMYnBsYTJqQlp6OGpiSWJuVFQz?=
 =?utf-8?B?Z0lBbXR2TUdzNTZEMzAvTFRrYUxHdWlsSmZOR1pYT3dYZ0FoSFE5bDR6d2x2?=
 =?utf-8?B?d0ZlWUM2OHNGbHZqYnp2OWVSMnBIbmZYYWVtaUxzTUk3MUhtSkpZNmhjbVQ1?=
 =?utf-8?B?a1ZZMHVUNVVlK3VBbkhUTmlSeVJsWnJTNEZ6QzMvbmZkNWpTWE1JeG1yM1hr?=
 =?utf-8?B?d1RwMlErcHJNblcvUjczYnU3ZUwrc2xZY1BIaDlNWE82bE5ubkJYWHcvWjNZ?=
 =?utf-8?B?QXpSbHlJU2I2RG1PeFFibFprakRTTlh0elh6SFhKMFRHbW9IZUY4eEFFV2Q4?=
 =?utf-8?B?TTArTXVxNVhlMGxRNGZFa0pGaE44dVNFSWlicnphZ2dmeFp2RGU2eXNZVUkx?=
 =?utf-8?B?SjFIUTRiZmN2ME0wVEtsQjEvaTh2NENtNVZFVEFyRkxYVHBRbnV0bUI4WTZJ?=
 =?utf-8?B?aFdST1BtVzhiRW9mNWkrUnpZQ1Y3dkJkL3ZFeE5UOGlEZnVtQTJQbjVvMXla?=
 =?utf-8?Q?8WBg4T/FxIQZk80LCENF10hR9?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38c7dff6-4d84-4e01-f8cb-08de378f7ba5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 01:57:32.9449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yZ1kFg0QGxDmctYSuAkb9hrCiNv2gctK9MSmplwLRlwYPRhbOjK3WhhmfvR45cVSMZRmM2X+xPR0THST86whw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6430
X-OriginatorOrg: intel.com

On Tue, Dec 09, 2025 at 05:30:54PM -0800, Vishal Annapurve wrote:
> On Tue, Dec 9, 2025 at 5:20 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > On Tue, Dec 09, 2025 at 05:14:22PM -0800, Vishal Annapurve wrote:
> > > On Thu, Aug 7, 2025 at 2:42 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > index 0a2b183899d8..8eaf8431c5f1 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > > >  {
> > > >         int tdx_level = pg_level_to_tdx_sept_level(level);
> > > >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > > > +       struct folio *folio = page_folio(page);
> > > >         gpa_t gpa = gfn_to_gpa(gfn);
> > > >         u64 err, entry, level_state;
> > > >
> > > > @@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> > > >                 return -EIO;
> > > >         }
> > > >
> > > > -       err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
> > > > -
> > > > +       err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio,
> > > > +                                         folio_page_idx(folio, page),
> > > > +                                         KVM_PAGES_PER_HPAGE(level));
> > >
> > > This code seems to assume that folio_order() always matches the level
> > > at which it is mapped in the EPT entries.
> > I don't think so.
> > Please check the implemenation of tdh_phymem_page_wbinvd_hkid() [1].
> > Only npages=KVM_PAGES_PER_HPAGE(level) will be invalidated, while npages
> > <= folio_nr_pages(folio).
> 
> Is the gfn passed to tdx_sept_drop_private_spte() always huge page
> aligned if mapping is at huge page granularity?
Yes.
The GFN passed to tdx_sept_set_private_spte() is huge page aligned in
kvm_tdp_mmu_map(). SEAMCALL TDH_MEM_PAGE_AUG will also fail otherwise.
The GFN passed to tdx_sept_remove_private_spte() comes from the same mapping
entry in the mirror EPT.

> If gfn/pfn is not aligned then when folio is split to 4K, page_folio()
> will return the same page and folio_order and folio_page_idx() will be
> zero. This can cause tdh_phymem_page_wbinvd_hkid() to return failure.
> 
> If the expectation is that page_folio() will always point to a head
> page for given hugepage granularity mapping then that logic will not
> work correctly IMO.
The current logic is that:
1. tdh_mem_page_aug() maps physical memory starting from the page at "start_idx"
   within a "folio" and spanning "npages" contiguous PFNs.
   (npages corresponds to the mapping level KVM_PAGES_PER_HPAGE(level)).
   e.g. it can map at level 2MB, starting from the 4MB offset in a folio of
   order 1GB.

2. if split occurs, the huge 2MB mapping will be split into 4KB ones, while the
   underlying folio remains 1GB.
   e.g. now the 0th 4KB mapping after split points to the 4MB offset in the
   1GB folio, and the 1st 4KB mapping points to the 4MB+4KB offset...
   The mapping level after split is 4KB.

3. tdx_sept_remove_private_spte() invokes tdh_mem_page_remove() and
   tdh_phymem_page_wbinvd_hkid().
   -The GFN is 2MB aligned and level is 2MB if split does not occur or
   -The GFN is 4KB aligned and level is 4KB if split has occurred.
   While the underlying folio remains 1GB, the folio_page_idx(folio, page)
   specifies the offset in the folio, and the npages corresponding to
   the mapping level is <= folio_nr_pages(folio).


> > [1] https://lore.kernel.org/all/20250807094202.4481-1-yan.y.zhao@intel.com/
> >
> > > IIUC guest_memfd can decide
> > > to split folios to 4K for the complete huge folio before zapping the
> > > hugepage EPT mappings. I think it's better to just round the pfn to
> > > the hugepage address based on the level they were mapped at instead of
> > > relying on the folio order.

