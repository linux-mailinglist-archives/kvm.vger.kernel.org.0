Return-Path: <kvm+bounces-59534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C830FBBEDD6
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 19:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AECD24F0506
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 17:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAC72D7DFF;
	Mon,  6 Oct 2025 17:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h96LInKH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8B22D6E4B;
	Mon,  6 Oct 2025 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759773422; cv=fail; b=IEf3tWWB4Eq4+95hnDP24tmYDVjuKEg1T98V9ZhwXIK1V9cd+6SB6RYYap5Pvxj2uarQdTWZF3k+yRzrrokITU4/fkc2/3X1jnkckYtksbjyXMc1a4YV2l1BbBdtH8pbLF98hQe5ncabCP4rnwxnErwaQxwKC9sEXefyq03Qj9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759773422; c=relaxed/simple;
	bh=v5AE0Si71tyfIHl8p7XqS0pLB7ERf+2sF7PLMABfFzk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J0FIKO5y3RnbVSrvZCroLOxlVtjQf3Kw0djhEzDVOI8b7S0CSHDOi/Obi/UuapTbB95iYd2SrfKfLO6Vn0nVARQi0Hc58VkapIBg4Sjr/tz7Q8OrF6xHAXT8Yg7Eh06wqc4PP/oirnWBs3RRcrVMCzSAsA0aXhvHC5xsMV9d1A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h96LInKH; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759773421; x=1791309421;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=v5AE0Si71tyfIHl8p7XqS0pLB7ERf+2sF7PLMABfFzk=;
  b=h96LInKH30H//zwkSBiOsUzyqAzR64DoCYSlaiX6wVprZGdXiG6opY0a
   QG5Q/IeogOqWCxDPxrgdgs3pDtiOwXMar6KyBBVX6rxplav6eHtNV7j+c
   L2TYBs099b7BiH5qaIq2IJdqAEw8y4NNvJHrG6DO4btDEMpMkglaesil5
   jGmWAi6H2UvBU52mJAIt7cJT+U23DDrLcizpOnx2kKmOVycMLLNPVG7yp
   VVmuTGWjymMPd5rud18w6p+477/b07OyOpfNf0W48a7+MZvtqihfLrfVt
   mlmETYP0+JsULIox6dVnMcGGNrIp8jLWsGUWYXg+eUiunrne98OmZt9CJ
   w==;
X-CSE-ConnectionGUID: DJHmIGV4T0ai7WMGqIEMng==
X-CSE-MsgGUID: RUPLX9vQSQi9UFFAIYJVpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="61985948"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="61985948"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 10:57:00 -0700
X-CSE-ConnectionGUID: 9+dUma92T8GNEVDoHTdFHA==
X-CSE-MsgGUID: gHbS7BfzTnWxNMjKZPNVyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="179604918"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 10:56:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 10:56:59 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 10:56:59 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.56) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 10:56:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stXXltSXPH4MJMl0mMOf4ew7YUNQOfQbtbDn7YnoANB7ajaV3oeylf0/QOmuA7CXJB0dlJThfIWzmlYCQ5Vp8yq+4LUhk3R7BtTbsSEu6t5Jjsv1LumNN1cs0A62oyZ55aBjRu28slaN++hvZC47TNncl+DLuz65S+8iHN0j7aBsQIsNq2h9Jvb4FB/DoV65zbUMc6BzpSKHQSNVLwS2sBeExyIdQiQ6cfSf9QKYFtoA6WgRQXsd5NXq3fnnvtp/qdGyeh3nwFA++FsQcLwnAKSvt+Xl17x71CV/0o1rBww7+Hj0wHFkDTf4pUR2j6sfKgl/y2EY943qhsee6Inm9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/46LSYm04HXpdksuX8BAgmAwepZm7mv2BJAbc2kd8SE=;
 b=JL4Y9aCncMYqo5ANuPCqjmwpvkfY/qW0KDYiaMv4RZkePKqTFg/zEtskMl1fydOHBLxtPXJSrNwMcgWMXNSmgqnimiup3Bs36BeEeigzQtecn+qABsG2xuuCWlcUJ1Nawq1SC+npSCJLN/rlDrFTtFaijCagOOW66Gf8v5cLRRIj9Dl/sBbQ442JdObFbfkZDcSiv7kqPTM5ES4Swg/sa81NylgZmY7w1dURU0CVuM8h/3QZeOrBWc6tDI+ASvY/YBbhSlFqRPs5AeXw4iNPUX9/s28Sp2pQjBWvZ2AL33Q2cjFgl7UiSrT4bCpXw1TuglbYlax+YBeHFvbvCXqybQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB7769.namprd11.prod.outlook.com (2603:10b6:610:123::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 17:56:49 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 17:56:49 +0000
Message-ID: <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
Date: Mon, 6 Oct 2025 10:56:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: Babu Moger <babu.moger@amd.com>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <dave.hansen@linux.intel.com>,
	<bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0344.namprd04.prod.outlook.com
 (2603:10b6:303:8a::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB7769:EE_
X-MS-Office365-Filtering-Correlation-Id: 9afccecd-1f33-4219-c1e7-08de0501b937
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dm9jeXQ5VGovb1Y2VGI2aUNnSlNLdGk2ejlMdWNRRXhoUVV1VzAvZVJsK01j?=
 =?utf-8?B?NVlxdW5maEZBamJuQUZhSUVhWTZlZ01wZDhtcUZLMjd1cFBJeXJpa3hwaFlj?=
 =?utf-8?B?K0FVSXNRS0hWbGVLTFo1WkNWMG9CVmtIK3F1am44ekpJeFBqcUR4OVJ3aTdo?=
 =?utf-8?B?eVhqeDZkQ1JTckVQQTBXcGpsbTFaeTFCM3lQVjQvaFpDZG11Zi8vZFNiRWpz?=
 =?utf-8?B?bEphZUVENWVEWHU1cFZEN29wU1F3dGtHT2hjaWl2MWEzSVE5VkVncENCOEFs?=
 =?utf-8?B?azQyOGVpV2VUTnFQQlR4VG5MYVZZSTNFM3FPV2lEZDNPT3ptb1M1Um5RSDlY?=
 =?utf-8?B?aGNzdWZMUmpER0p5V0VvUHBkVEN0U0FUUTUxRVBQVGlwbk9DeVJIYVpYcVVF?=
 =?utf-8?B?T0QrK3RKRlRidFh4MlFtck1lZmxhbWNRd2JHWHQxTlNKM3RJY2dtOEpXMm44?=
 =?utf-8?B?MzZJRVFOU3BoZnV5T1JKY1pSWWFDNU1GVWo1ZEo0T1VDSkF0UkdLSFFWQ3Ny?=
 =?utf-8?B?UC9QS2d4M3FLWFdDRWpYUlZ4bUlveXJjNmxKbFdUVWdoTlRKWnFQRlNiYXNL?=
 =?utf-8?B?UmdUcjFUM2ZPNWR6aGIvMDVSbTJTMy9LemdMV0FGcHlQc1JsNE1XcDg2K1ho?=
 =?utf-8?B?TW81bnRIOFlYMkg5T0lkSllRWDRKVUJOUC9NQmtsb0prY0JqdkxJb2pGS2Jz?=
 =?utf-8?B?dWFiK1JwZTZXVW80bmtoSlEwb091SHlLYmY1ZExlQWlDYTAzUGtwWkg2Vk5I?=
 =?utf-8?B?QUl4ejNCTWJXbWh1bHJsY2tPN05xUGZXSzllNURFZU1qQVEzL3drMGFOejEw?=
 =?utf-8?B?c1E2KytIbkFMeDZNb2lSSDJYNGU0WlBJNGFIaXpjS2pmQXRBSlVDNlhoRnoz?=
 =?utf-8?B?U1NQbEkvVG5XS3ZUNkNiMTluSVczNm8rM1R2RG9WckRBbWJNVjl4bjJEcWcr?=
 =?utf-8?B?UnFNcVkvbFZJbTVUK0tTUG10NUNkamFObjJJb1JpL05wR0ZoTDNoOGpZNXNU?=
 =?utf-8?B?T2xsSndhL2ZJRDJxWjBRaVg1R216dkt6Y0dWUTFRdVhLWnlGLy91V2xLVzlx?=
 =?utf-8?B?L2RBTnFRUlJlOEdnTi9YL1VoOEo4RHV3Z3cvOCtCUG5CcGdnMEptWEM1b1hT?=
 =?utf-8?B?UUVkRGZMTjBhb1AzUWFvdzVmZDZKUGJoSmN4dEhld2VaZUkreHhlbGdKQmdI?=
 =?utf-8?B?a0RLaHA2VjBKS082d3lBUnZ4di9lTHUzRyt3UmFCb3hJKzFIQnpTWFFLak1r?=
 =?utf-8?B?by8yRVJ3eHdBenkzKzhSRmZFV1lhdFNoVnJzOGN5bFg3aGlleGNvdXhJaVNY?=
 =?utf-8?B?dFltLzdPZXVhOW9uVTdLUGxNUVpsVDlDWUdWbTBBVW5xK0FGSkpCeDUwT1Vv?=
 =?utf-8?B?YU9FZGJkVkcvSEc1T3BxM2RKZDJzUzU0enhvTjFyS0dLRmMyaG1FYlZHOEFK?=
 =?utf-8?B?N2NmMXN5WEo3Ukw5WmpVbEJmMkJ6WEw4Vkd0SUhzVlhYZVBrd2lCRXN1RjFE?=
 =?utf-8?B?UUx1Nk5TTExYRG4ybmNha0t0Vk13SmVDTjNDdWxpYVZieG4raXNkNnQyTE9i?=
 =?utf-8?B?R0h4ajdWejBmU3JDNU1LZlNVd0laMU1wNVdWdmMyTEtjQkhJMXRYUjJKc01S?=
 =?utf-8?B?aEtOUWZTS3M3RDFLZlRxSmFEMkRvZks4VFFoTk9GdU5abUVlQ1N3V01Wb0Vs?=
 =?utf-8?B?Y0tjaWo2NlR3ZDVRVnRSRTFkY0lKL1NSNXJUUVh4VEsvbUVCeFJ5Y3dobzVF?=
 =?utf-8?B?WEdYR3dTWTJFZ3NIMER3ZkZsZTIwU3I2KzNGM2s5VTN3elJNcjNXUGIyelNH?=
 =?utf-8?B?ZUlGNE82SCtiaVhOSkJkTGhydVkraytCN3lycGpUT2VYZkR0QU5ON1lWaitN?=
 =?utf-8?B?QS9rdkRxb2ZydjJLTXQ3WFJQaUlwWWNVZ0wvNTRyb0s4b1ZIZGlYdUY1OWVB?=
 =?utf-8?B?RnRLcVJCNGtRU3V2M2RvZVBvaElDUDFYenZNSnlTSlM2ampVSE5sSHZpTnJa?=
 =?utf-8?B?Qm1hWksycHRBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWdlUXBKbzhHV0ltcGlUdDBIM2RBWDZhQ1VpUzh6T2ZtdGI1NHN0K2dnRWs3?=
 =?utf-8?B?TkFaZE9SWjRYMUh6aGdQaWk1L0thbXFuTFpYMkl4NkpBbENXSjZmRXRXcFNT?=
 =?utf-8?B?cEExTCtlS1V1MTlnaGxPVkVCZWhuY2dxNFNxdndzZGRkRW9Hb29ZL1JtT3J4?=
 =?utf-8?B?clVKU2tKaTAxbTVzczBYUmlqSmhsRVRiZ1g5RFVMTWJ3dytDMTVJTFljSzRs?=
 =?utf-8?B?VWtRb0RaajZyQTNtLzRWclZzdDVZMzhyOVVkVnduVFluVUkxLzVSSGZDVzEx?=
 =?utf-8?B?TDUvT1FSMDYyYnlaTDdrdFB3WExOblUwc2RSdFpCWXJnUFVWdFJETGM3R0NR?=
 =?utf-8?B?cEVCSC9ucm4zaUtvckNsNXRZTkZCdG5tWTh0Z0VvamN6czExc3RjYVpQUndO?=
 =?utf-8?B?NVgyRUdpUmpyVjZVNEdGL2VuN3p5VHB0K2NoM2Jmb2UxcGJsUDBObUUzMzAv?=
 =?utf-8?B?OWNCVE5RVlUxR3I1b1ZvVVVyaHp2cHRodUxTOVp6SWM3OWtOM0NJTXR0RUdT?=
 =?utf-8?B?Z2IwSXNwUzBUS3VvbUdZMUp6eFo4QmJwczRHQzN6U2xrQXYxb2RmOWs2RG1G?=
 =?utf-8?B?VVVNTTBSVlJyZVdlR3M3SXhRL3FZb0EvamxoZWE1L3Z5NHZHMW5ndUxqRTJG?=
 =?utf-8?B?dXdheGVQOHcxQ3FCTHQ0RWNocFBLckR0QmUrM2ZpSTBnRUZyQ0dwNkNxM2l6?=
 =?utf-8?B?TkR5Rzc3S3dReUdPMFVLeDVOSWRydVZFUEszRWVtRFY0WHlwYktGcTFJaldU?=
 =?utf-8?B?dXRIOXBNVk1UdFBsdUEzb0ZGbVhzSElnbDYyQ29RSXdLSFRpNUlNclZ3NDlV?=
 =?utf-8?B?YkJMR3ZDbDhwcStCbnhlSUlwQmdQd0lvc3RpazQ1THRLQzk3Um5iTjdRNUEv?=
 =?utf-8?B?Sko5QWpHSnNlM2g3S2N6a1RzVFF6dlJRcjVzVDZrVVkwMmQxcjFtS2hwUmsw?=
 =?utf-8?B?Qm02SCtWU1RPTW9kZHQveE43S3pLOEV4aXMwbUt5UzRyZ0czYmZySnV1dWVx?=
 =?utf-8?B?dTRsOU11SmpuTEF5YU04eURLN2tQTngyQTN2T1lHVmZWdmNXcllPMEdIU05l?=
 =?utf-8?B?S2VGb2Q4QnFWTGdHMzc5MjZPNDlLL1plS1phTGNyS2RYR2hOVm9aTitENHlT?=
 =?utf-8?B?T1dBVDdFWDQxM2NJNXBNcGVaRTZucmhPa09WVmV4VGJ6d2UwUDRDQmIyUG5S?=
 =?utf-8?B?ekFhMzVZbjk1NFBvRTI3K2w1OGJsMkVtVlQ4b0VmRTJGeDAreGZhMmMycXZD?=
 =?utf-8?B?U2pGeTUrNEtzbGJMMk52aC84MDE4Vk5VNExmNzFkKzJHTGlwTS9IQnVPMUVT?=
 =?utf-8?B?VE8zWURuWmtIZ3ZJbUI5ank2ZVpYV0FmalhvZis3N3JwV0ZwZlRwR09kZndk?=
 =?utf-8?B?ZWMwckNLdktYT2k2dVNkQ3lHR2paeUxHbEFTeVVYT2wvNXFSOXJzYWVNaTlN?=
 =?utf-8?B?NWQ3a3psamJLaTBldkpEbDdxMTFtdFdQWUUrZnRGU3J3MURuL2JUc3VFQXNw?=
 =?utf-8?B?eklWenZKMXhjeWlzTjhya2EyaDRWWWdTcXhBSUJlU2Q5RHlNZzgzRGpCZXJO?=
 =?utf-8?B?VWdNekNWNjZac1RxY1U0bThIZmFIOWx0Y1NPWWRNN0YrdFplMy9NelFzTlVu?=
 =?utf-8?B?aTdzWTFuSWc1VTcrSnVwSHA1azZ0c1lUUkVBbi9zYW9jWlM4bUZQYndEOGlX?=
 =?utf-8?B?OS9BQ21xVU0wckd6UllDcHNSRTBoZGhBZC9QaTc1aWpEWFdrTmtscTE1ckE2?=
 =?utf-8?B?cGhsRW5DWXcyaTRiVkI4aFJYNS9wUmNWNjdNamcySXRlVm1CVmQycE5PTGJx?=
 =?utf-8?B?a2piUFc3UlpmVnBKYUYrOFd5amdxY3cvSEVybVVVRmYzeFd5bVpxQVRJa1lZ?=
 =?utf-8?B?NVI2VmptdEFUUVE0WFh0N003RkFHbkdtM09DdGVmR2xTa3YwWk56a3VwcDRm?=
 =?utf-8?B?cGo4a3AyMk85d3ZLQldTdS9PLzZjMXZEZ0FwVUkrMEJuM1AwdURCUCs0cXg2?=
 =?utf-8?B?aDIzd0wxcEZBOFBqVGY3bEphQzc1YjdZditFc3FmN0JXY2oweUV2NEJHYmxz?=
 =?utf-8?B?bExWMWxySnNtQzhrdHFhQjFLTTB4SThWUXFkYjhLcjNmSXV4Q2ZQYVZVSGhv?=
 =?utf-8?B?U1JIZFp0NTVsM1pTdHpMbmZzM3FkZ0thalJTMWhPaFJGNmk4bzUza1c0U1ll?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afccecd-1f33-4219-c1e7-08de0501b937
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 17:56:49.5209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WvdJQztVCvBw/Bg+pkFWIlZXUhRKR0Q+Mir2t1sQhyQ798O3a82bpbYSxzBdhV02CZyy4AMKKyh27kz/dmTFLgfeL0GkxA6VSpNGoVSsCqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7769
X-OriginatorOrg: intel.com

Hi Babu,

On 9/30/25 1:26 PM, Babu Moger wrote:
> resctrl features can be enabled or disabled using boot-time kernel
> parameters. To turn off the memory bandwidth events (mbmtotal and
> mbmlocal), users need to pass the following parameter to the kernel:
> "rdt=!mbmtotal,!mbmlocal".

ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
parameters was to connect them to the actual hardware features identified
by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.


> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
> unconditionally enables these events without checking if the underlying
> hardware supports them.

Technically this is correct since if hardware supports ABMC then the
hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
and mbm_local_bytes. 

I can see how this may be confusing to user space though ...

> 
> Remove the unconditional enablement of MBM features in
> resctrl_mon_resource_init() to fix the problem. The hardware support
> verification is already done in get_rdt_mon_resources().

I believe by "hardware support" you mean hardware support for 
X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
this then require any system that supports ABMC to also support
X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to 
support mbm_total_bytes and mbm_local_bytes?

This problem seems to be similar to the one solved by [1] since
by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
but instead there only needs to be a check if the feature has been disabled
by command line. That is, add a rdt_is_feature_enabled() check to the
existing "!resctrl_is_mon_event_enabled()" check?

But wait ... I think there may be a bigger problem when considering systems
that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
Shouldn't resctrl prevent such a system from switching to "default" 
mbm_assign_mode? Otherwise resctrl will happily let such a system switch
to default mode and when user attempts to read an event file resctrl will
attempt to read it via MSRs that are not supported.
Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
to handle this case in show() while preventing user space from switching to
"default" mode on write()?

Reinette

[1] https://lore.kernel.org/lkml/20250925200328.64155-23-tony.luck@intel.com/



