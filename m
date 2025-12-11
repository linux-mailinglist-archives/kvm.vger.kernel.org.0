Return-Path: <kvm+bounces-65690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 72471CB4917
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 03:40:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C1FF5303524B
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 02:39:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB22A24293C;
	Thu, 11 Dec 2025 02:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9pkWDcG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D0250BEC;
	Thu, 11 Dec 2025 02:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765420744; cv=fail; b=DcYEagKAxRQb9JQ8/zVA1YAJ0KIaNPUp0GWJaBbm51Yle4vMAmPiVaHqlqgJiVH80s5r/kALyn6BgS7Ey+wiqk+RdHHIOCCEkCFhBExA9CvY2RcAKv7hDr7ms4vcGCpSOuUVdaqvEFLdh7Ni18zmOwlm7/obSFucZ7Jz0Cvpg0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765420744; c=relaxed/simple;
	bh=3o1vc5hH5sB5rTx3pQG4zo2gwnK2pkuAlMp7mjI3yC0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BmA81UciHLDauRE8WwO1vgROFEjd94rqgE9jqLVJ8FB1IHGrQh1/+RGOipy1DAso8vYhNOgdylD0B5Mf95Tmcvqsih9s+ljbUrIToEDJqDfvDPOTn8a+apsHYs4UT1UioM+68m5PUIn4Bsm3MDGTh9xOnBFOUsJhEH5I884QSb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9pkWDcG; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765420743; x=1796956743;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=3o1vc5hH5sB5rTx3pQG4zo2gwnK2pkuAlMp7mjI3yC0=;
  b=W9pkWDcGaXmlMdqO71o3Cuy4ST5G86kkIbi+mFad5pXMA/10sRt0Ondx
   rrCVCO2fWE8JGg/kFLc2DqcUo0nKD9jEj43QJDTeajIN6hYrOb/D643EC
   EKspD0E7oVKEcAva+DGg6hOcal25gHzG7Se4kD45Yo0eV6bS0g9t7/Tnr
   7h5oz3fhwg7MUgzfIa4GtH03rA91R5EfgiTzULEDBnhexY9BfIK5DXlsI
   yk+MIDh9HqcZ+p2/pNESh/wJpbWUiPY+7n9oq5RCKb7qPSM1emqe0XhL9
   CCEAR6CR/k4pX1A+CiG4m/DJcOMDSe00P9AyIzA8Amnkc7yvT7eJdNRUQ
   A==;
X-CSE-ConnectionGUID: GiH9iZ3iQYyYD9pg17OcEA==
X-CSE-MsgGUID: 2WeSGI/7S5yo2eSfdVbIVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="67358956"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="67358956"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:39:02 -0800
X-CSE-ConnectionGUID: 9CjGlmDIRi2JWt55wwJHpQ==
X-CSE-MsgGUID: oRoCitqBRmGbw0FubuWDuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="220024656"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 18:39:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 18:39:01 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 10 Dec 2025 18:39:01 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.71) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 18:39:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFd5ft1Kvxz1aiWGUg1Tp7jFBnaY+zvEu0s11zHABBYn0Fsu5rUqXq2AH46OG+/G3RJDCBG7X29FPW4MCkG/IkUEdWGalqud2SI3GOIvgLsm4xL9B3i7BRFSwY7ahbKKwDa8JIAU5Kggw3F5ynJG1qWkeOAlNUslt+23AxCx7koJHmXJmW87/CofqPfp7nzMCeuxcJNiPA/oDjypyT/z4U2qJ2ooYcVcg2/MP6TreGr6Rwo9sn1Hbc8Hnu238nJ+ChINilq01PRNWgkm1Q+1Bx+z6Df2CLwcuwTvxNN0atIPo7EFNt3WaaJ9cED52RmgMGFC/+pXqIX7DW1X4xtV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wXe4QBSOBPzdJ4Kz5WOBQcO/F5E7uKNN31Y6vcY+tE=;
 b=TC0jfeJTatqDdxRxVQEf6cFli6+0NP/lfSrgUHhFm+rztv9h6NDEEDNOWypVQTYftbjqwQWMeNhNONg5RyTGITPRWk6hgMDa4gmpHkNl5lwz92XOQ9WUHQ9cBOkkEkd8/xYZ4RUgiRS78i5a6RzurkNnhc/DFle0JLNhIIR2crLvK6o6uo0QUmu6ZLMKyrV0cZc6IMyP/dvoTL0dTyRayuDdl9AYN/2rxRPi7uRo5jrVMRTLx04eeu7rufIwJNNVSyz0YU5H3xnwvdc4QFdmD0tPO3Mqwgw4TkPqbc/JurCLBWKHJ4eozgty52wpXG6QeUjCYqOR/3ox5Z+9/13HWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7090.namprd11.prod.outlook.com (2603:10b6:806:299::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Thu, 11 Dec
 2025 02:38:58 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 02:38:58 +0000
Date: Thu, 11 Dec 2025 10:36:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: Sagi Shahar <sagis@google.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<x86@kernel.org>, <rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kas@kernel.org>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vbabka@suse.cz>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 21/23] KVM: TDX: Preallocate PAMT pages to be used
 in split path
Message-ID: <aTouJ0SaFp9pluUN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094604.4762-1-yan.y.zhao@intel.com>
 <CAAhR5DF=Yzb6ThiLDtktiOnAG3n+u9jZZahJiuUFR9JFCsDw0A@mail.gmail.com>
 <aTZmY1P6uq8KWwKr@yzhao56-desk.sh.intel.com>
 <CAGtprH8hk0akN1pbxO95O_AyHf-BDN5tOH-Lbxg-qcTMg-27UQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH8hk0akN1pbxO95O_AyHf-BDN5tOH-Lbxg-qcTMg-27UQ@mail.gmail.com>
X-ClientProxiedBy: SGXP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::17)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7090:EE_
X-MS-Office365-Filtering-Correlation-Id: 78675599-b4f4-4701-58ab-08de385e6f61
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dHYvOVFFSkJjVEQ4MFlRNzFIWjhwM0JIdDhqdko3VzhvZmpIcEZwRVc0eFgy?=
 =?utf-8?B?YzhXVmQvOFo5eWtaemZDU1FaY1Fobm81UGFiNWk0T01XVUVrUENwU2hJSGRB?=
 =?utf-8?B?Q0dETDFlcklaYlhHT2pRVm1SMVNGUTd5YThDcU92aWNzOW5LbVl5YitpanZJ?=
 =?utf-8?B?a3lQSEY5eGxWSWk3amxXYTVaYktvemNaSmRERHpkUkJtNHY5ekFqUGljdHFC?=
 =?utf-8?B?c0pyL3FielZLUGEzbUR0dzJWSEh3SSt6eXFZTVBmdHZEa0xIWXFmeVNqbE12?=
 =?utf-8?B?TGs4dmhqTjhqcHJVSkoyQXppRWZUWTJTWEJTL0tUK0xmTUFVR1RjNWkrRms1?=
 =?utf-8?B?OXZSNjViSXpPcjM1anBOd0FmbGpiQURxUU9HY3RsYlZpREc4d1NOdmUzU0Fs?=
 =?utf-8?B?Ny9QazVHamUyZlYvdHFlNlZFMW1GbGxqc29nSldZd3ZVWFVuR0d5RkljSjNt?=
 =?utf-8?B?RUpkTFgyem9Hc0xKajhRbEtQOG1iRHZuQ05OWnFuQ2xaczArakJCRGNZc2hH?=
 =?utf-8?B?V2l0MDJKNkxKVkg2VVk2dzhsWnk5VnZtWEhVM0hXeExtUzBtWERzN0pGdGtY?=
 =?utf-8?B?SnIrcG9mUFMzNUlpNE5sa0QyeU5kb3hOR3VoMDk5c2VscnFJMlA3UjdTSkRW?=
 =?utf-8?B?WGIvaGNyK1BCRDhzSkJHSUdYOEdrbUVqQVJhS3V4dHoybloxbmxwcjJGZ3Zu?=
 =?utf-8?B?OWVCdEU2QnB0Tk5MbmErd1hkSGVtblNGcEtkRzNkVnZSbDU2Mmh5eXpOdHBx?=
 =?utf-8?B?TzFid0hseVZhMngwK0dlTm1PZTRSaE5qTzRPTG10OE85NHROWHJoaXZzTHYw?=
 =?utf-8?B?dE0rYzFKbm0zSG5DU1E5Z25DNzlrdlNMdE12MXpmQmd1cmYramhMUEd6MTlY?=
 =?utf-8?B?TkMzRXNSRE5LQ09HakJ1NU5tM09raFE5MWNsejVuSXdhTGtMS0tPQVcyem1o?=
 =?utf-8?B?ZTVUTkl5T25VaXBtOThKUTl6Z2Nkc0pyWndxRHNFOVB3K0kxSzR6NjZwRmQv?=
 =?utf-8?B?dlV0czhvcmlJTHVaZ280cGlJd2xCdXYwYldDa3NtQmVGMlZrUVJ1dVFZRmNN?=
 =?utf-8?B?STgrVTJxd0dsK09IMG9PbVF5ZzlqR2NqZVpaZCtWVkY2L0VDRnFacUJYSXVL?=
 =?utf-8?B?VktsSWRXdXF3dFNDb3E4T09YVU1RQit1RG5BbzAzRkhqVTRMWjR5US9tc1hl?=
 =?utf-8?B?Z0huWGhkUEJpSnVlbkN4Q0ZBN094V2FCcnRtT0ZxaGJFQ2ZzQ0VaaGtIbFBa?=
 =?utf-8?B?VFNoS0hZRDhyWUtTQk9md1pPQTl6L295Q0pxcUJ6T3VDck5CZkRuekpTdm1Y?=
 =?utf-8?B?R05sbkEvcVZ5Z3R6RjNXN0F0WlRtVk9TNUYrMldMQ1VIdFlNV21QUDY4R1R4?=
 =?utf-8?B?QzVDdVVYVGpSeEI3VVFManMwL05xNy8xZkFvbldjbk1ISUd0c3BnOHRZQ3RT?=
 =?utf-8?B?SUQ3ZGVoZm5oUVlTY0xWRWg5YkU4TTd3RzMzR1kwMHZJVm12WnN6cnlOaG5Q?=
 =?utf-8?B?b0RVZEFsUGVzcFl0NEJIWi9ScGdZWktnN3JVY091OWhjK0I3QXh6bDNPWlpy?=
 =?utf-8?B?NW43SXJBcUJVa3VTNjF1dndPdXB4Qis0S1Y5VWxRTUllUlBjajZ5VmJuc3Ew?=
 =?utf-8?B?aUYvd2tlSFVHa2o0ODRSclRwRzR0T3Q5YWMxYTkvTHA5MG1sRWsrMjUxeTNU?=
 =?utf-8?B?eWNwRUpaUUp4M2tOb2hjYkE4RXlvaXNFMUk1K0YyUGxuWVFnTUNCb0g2NTRR?=
 =?utf-8?B?OFBPMEpYZlA3VkpLVmdISlkzR1dXSWZpVmpiMndIOFVXVEhxT0w3QW9LRlg5?=
 =?utf-8?B?UEpLQmtEU3ZXcXZVaElxdDB3RTZyNmFQempEUXh1TDIyN0lPOXJOYXJHMGhT?=
 =?utf-8?B?eHEwNVlUYkoyQTkxeG43TTNxUENtU3U5cTR6YkpOcHdVZkw2ZEN3TDEyZFFT?=
 =?utf-8?Q?9uZDGFh+nXWG4PXUIhSDQOtDvZs2oHcr?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djJCSVNIdE5iajBlZ3NIbDdWOXZZVmVnbE5jUjJ4UDhEZnp4ZmxwcDYzb1NI?=
 =?utf-8?B?NWtHZDV3cTJKL0RJUHVlbjlQMG96R0N4cjhtQnJFOUNiaWQrS0VIbnBzazNH?=
 =?utf-8?B?dklJMnVBNkt0VXkzL1JFd05IV29FT3RaQnlFK3A3T3FjcGhZcUx6bzAreUVm?=
 =?utf-8?B?T3dFYTZ0dElHUDU3MjR4VEN0RWNJU3ZCaXprL3JkNG5abXNpQVFIWHhUQnFs?=
 =?utf-8?B?SFNOMXlISDBNVFpQeFdiNFpmRy9ybktHUTFFUGF1VDAxZkEzRk5RYlMrUG0w?=
 =?utf-8?B?U0pzYlp0REViUmtKYzZ0MzV4S1BsNHFPeU04bVpEWXhZLzlMdGkwVVhObWpO?=
 =?utf-8?B?blhqUW4zSWJ1Um15T2lUd1RSRHJOUGMybGxKVEo5WU9wbnBrWFdBUktDd05z?=
 =?utf-8?B?bkh5STV3eFRjUUdSNVpUeFdCZmlVUXVVZWpvVEdGNHU1TFBrOENxM1JBUERN?=
 =?utf-8?B?RUc5b2JwN00rR1RnVS9ZUFhHbURqbys3YmNYMVJOZGwyRkNWbVAvMDlzZmwv?=
 =?utf-8?B?YUVYYkp5OS9JUm9MTnI2bEJ3c3JZamlpcnZDaHRKRVpLNHZobHFXUWtjbWxH?=
 =?utf-8?B?Y200OTZtUmpGMjZJRVE1RE9IRHJRdWkvVkJwQVluQy9FWUJVZUg1YldQdkph?=
 =?utf-8?B?cjNIdStRc0JqZ21tV2I0S2svcEFJeUhsYnlBdEdtMFdzT0QvNExteFdmZmVv?=
 =?utf-8?B?cmxWWUpYREFMWW1iaU1qbm5lNnpVc3VkTzVkMTNjdThVMmphOVpLRVg5eUtR?=
 =?utf-8?B?dFNldEpZSTVaUkJYMm1Yc3c1TC9UUXJIdTIvL0hxOXJmdHdXK0ZpTDZzdUdN?=
 =?utf-8?B?UGdpUUt2SXlaM0ZNK0F6YWdWVG9KVWE3a1lsV1NTYi84dDhUODZvT1dzdytP?=
 =?utf-8?B?REJ5U21sZ2N2YVZZOE1MQW9kM1o2dWNPVEJCVEhuQ2I0WTNybG8zYTBPbHpB?=
 =?utf-8?B?bWFjQmNqMnBGaHdmell0dWpITmVuYXpZbXQ4OVcyOVF3VzByK1F3SFBZR2tR?=
 =?utf-8?B?ek1GaCs1RzVLRXBGZUZudlJQWkh5RGdCUzRnSEN3cHhwL2lpOS9IWHd4a3VC?=
 =?utf-8?B?cjl2a2hINWVnb2JlcCtpRHRPU3NSbDZHWXg1cUFza2QyVFhnbEQrb1B4aDZH?=
 =?utf-8?B?MEt1TG04NmVTUUt2SkJWYkd0R0JndzRqa01iMXpHUEt0Vk5nc1U5RWJzUXdz?=
 =?utf-8?B?WWZldW1wTTVTU3NRMHFMQWJ2WVNwb0tMb1hZQUxkbWlKY3dqdmhrV3FvQjBX?=
 =?utf-8?B?N0Q4S0poaEk1OXl2YzN6dmE1SFU2dHBjQ2lrSXQrUGJWZ3lPZERWdDFSOVo1?=
 =?utf-8?B?OGdtK28vMzVZeWxuWWN5UnF6UGdxSmp0b0VCQVAyYm9qbUZBd2xPQVVjS2l3?=
 =?utf-8?B?QzhBQkZEWXJ2MDdsano0NjRsWGlmd1BORDBHSGZ0ZkU4MWtUb1hNNXdiNlhn?=
 =?utf-8?B?SXZpS1p3dFZ4c3NwdnZqKzJZREZMdnFuNTc5TUg4bnRQVGFiV3RMcVJGbmJh?=
 =?utf-8?B?MUg2dHQ4KzFKUDBjOFZXdmtKV2VhTkNsOUNHM3J0dCs0SjhYYWdIRFMwTEFZ?=
 =?utf-8?B?Tll5aVU5dXNManJzVDE3QXpzejl3WUg5aVUyMFZZL0VZeEhMQ1hTOFU3NFJl?=
 =?utf-8?B?Ym03WXRZL0NMbDg3a1g0QW81ZmxMUDhGM1BXMjIyM0tHcGdUVWg5ZmM0b3hL?=
 =?utf-8?B?OWRJbTFFb2pQVk8zQjA3OUFkRFAxVnlMZlBxTEVQb1cxa2ZOQ1pIS1o4cTBo?=
 =?utf-8?B?Z3ZweTloMG9VZ2I5YzREVmlQWE0ramdEOEhyTHFUU29Tb1FsYzNLM20yUnVa?=
 =?utf-8?B?UGVYWFIwd1pOM2w1NTBOWGZzYjljUzcvK3dpQ0VLb2k0djVJaTd5RUNnM0I2?=
 =?utf-8?B?T0IzcENqZmtYUnZzMCtLQjlSaThzNzJTVThYbnh3VUc5ZWI0VVZkdFFjMGkx?=
 =?utf-8?B?UHArUi9Lemo1UEg5SlZpTTN4dzlBeHBCZ0Qremxpd2NBWk1jZSsxWDFkYVZJ?=
 =?utf-8?B?OW5ITnAvSEdmV1NwSXVqd2kwSkFCYy84YUpzazkyTTR4NUlaM3FJb1UwbkUz?=
 =?utf-8?B?MFBiaEQxVnlHR3k4VVd5OFdlOXFMVmVRNlNuZHArdzhtTlRqWTJoR2FGdnND?=
 =?utf-8?Q?GyN20MaHPBynEVXpltpexJq3A?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78675599-b4f4-4701-58ab-08de385e6f61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 02:38:58.1487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: moS1PbnvBuiRIUZTjvD7J2R1hS9SXY6mQNxCAx/3BFXpdHAT29hroTF+4ubjwqurAZL8isbepU5UXMvStzmzrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7090
X-OriginatorOrg: intel.com

On Wed, Dec 10, 2025 at 05:42:44PM -0800, Vishal Annapurve wrote:
> On Sun, Dec 7, 2025 at 9:51 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> >
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 6b6c46c27390..508b133df903 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1591,6 +1591,8 @@ struct kvm_arch {
> > > >  #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
> > > >         struct kvm_mmu_memory_cache split_desc_cache;
> > > >
> > > > +       struct kvm_mmu_memory_cache pamt_page_cache;
> > > > +
> > >
> > > The latest DPAMT patches use a per-vcpu tdx_prealloc struct to handle
> > > preallocating pages for pamt. I'm wondering if you've considered how
> > > this would work here since some of the calls requiring pamt originate
> > > from user space ioctls and therefore are not associated with a vcpu.
> > I'll use a per-VM tdx_prealloc struct for splitting here, similar to the
> > per-VM pamt_page_cache.
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> > index 43dd295b7fd6..91bea25da528 100644
> > --- a/arch/x86/kvm/vmx/tdx.h
> > +++ b/arch/x86/kvm/vmx/tdx.h
> > @@ -48,6 +48,9 @@ struct kvm_tdx {
> >          * Set/unset is protected with kvm->mmu_lock.
> >          */
> >         bool wait_for_sept_zap;
> > +
> > +       spinlock_t external_kvm_split_cache_lock;
> > +       struct tdx_prealloc prealloc_split_cache;
> >  };
> >
> > > Since the tdx_prealloc is a per vcpu struct there are no race issues
> > > when multiple vcpus need to add pamt pages but here it would be
> > > trickier here because theoretically, multiple threads could split
> > > different pages simultaneously.
> > A spin lock external_kvm_split_cache_lock is introduced to protect the cache
> > enqueue and dequeue.
> > (a) When tdp_mmu_split_huge_pages_root() is invoked under write mmu_lock:
> >     - Since cache dequeue is already under write mmu_lock in
> >       tdp_mmu_split_huge_page()-->tdx_sept_split_private_spte(), acquiring/
> >       releasing another spin lock doesn't matter.
> >     - Though the cache enqueue in topup_external_split_cache() is not protected
> >       by mmu_lock, protecting enqueue with a spinlock should not reduce
> >       concurrency.
> 
> Even with the spin lock protecting the cache topup/consumption
> operation, is it possible that one split operation context consumes
> the top-up performed by the other split operation causing failure with
> the subsequent consumptions?
The sequence of check topup, topup, and consume is like this

1. write_lock(&kvm->mmu_lock)
   check topup

2. write_unlock(&kvm->mmu_lock)
   topup (get/put split lock to enqueue)

3. write_lock(&kvm->mmu_lock)
   check topup (goto 2 if topup is necessary)  (*)
   get split lock
   consume
   put split lock
   write_unlock(&kvm->mmu_lock)

Note: due to the "iter.yielded = true" and "continue" after the topup, (see my
posted diff in last reply), consuming does not directly follow the topup. i.e.,
there is step 3.

Due to (*) in step 3, and the consuming is under write mmu_lock, it's impossible 
for splits in other threads to consume pages allocated for this split.


> > (b) When tdp_mmu_split_huge_pages_root() is invoked under read mmu_lock:
> >     Introducing a new spinlock may hurt concurrency for a brief duration (which
> >     is necessary).
Let's talk more about this future potential use cases (i.e., if there're
multiple callers of tdp_mmu_split_huge_pages_root() under shared mmu_lock).
The sequence would be

1. read_lock(&kvm->mmu_lock)
   check topup

2. read_unlock(&kvm->mmu_lock)
   topup (get/put split lock to enqueue)

3. read_lock(&kvm->mmu_lock)
   check topup (goto 2 if topup is necessary)

   get split lock
   check topup (return retry if topup is necessary) (**)
   consume
   put split lock
   read_unlock(&kvm->mmu_lock)


Due to  (**) in step 3, and the consuming is under split lock and read mmu_lock,
it's also impossible for splits in other threads to consume pages allocated for
this split.


> >     However, there's no known (future) use case for multiple threads invoking
> >     tdp_mmu_split_huge_pages_root() on mirror root under shared mmu_lock.
> >
> >     For future splitting under shared mmu_lock in the fault path, we'll use
> >     the per-vCPU tdx_prealloc instead of the per-VM cache. TDX can leverage
> >     kvm_get_running_vcpu() to differentiate between the two caches.
> >
> >

