Return-Path: <kvm+bounces-65471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 509F5CAB290
	for <lists+kvm@lfdr.de>; Sun, 07 Dec 2025 08:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 292993009773
	for <lists+kvm@lfdr.de>; Sun,  7 Dec 2025 07:45:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 206042E975A;
	Sun,  7 Dec 2025 07:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IeSCyPgc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D3E1EDA03;
	Sun,  7 Dec 2025 07:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765093499; cv=fail; b=crS0hxMppK5f3SoE8xzORLJqpsNgQI96gyAYsjGoTl9J1axwhVStVj9LRvhL4PZo1CK8+uAnqZsKJcE11OUEdM8YLDigeNQW5a7Z0zZPwUPOclRtHawJeT1pMQm7KtKH1HD511Kl+6ZYQ1Jd7cgy9hTh0hX7AsMO9HnrNDbZLWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765093499; c=relaxed/simple;
	bh=f0hNB8kRQd2EFBFhDiEitQuPU8j5KAFZsaGcNlWTKZw=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=q1nRC9RFRV+D58r0XuAlDzuuRI5mPDLOcKtkeoXhCeHBnHAglYpNbi3LnBethNcUsY2ubugMLwi7V0oThq3prP67HBzIfsQ9hknnc79+2h36QNo/i+eJ4FIXN0+jMjUwrl0mgaIEJnrYdaxJ/j/mbDbo2B7MIy1XtzioE931HxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IeSCyPgc; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765093498; x=1796629498;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=f0hNB8kRQd2EFBFhDiEitQuPU8j5KAFZsaGcNlWTKZw=;
  b=IeSCyPgcNmQY3vDbmILx9/ezchuGmFYXtM7cMkYx/+Zr8IwglrlPLbEs
   R6Mhz7/j73zBJOQSlCSMhGSa2D5aPv+rOgUnXtVrJO4q0y1Tgr0fbhZIl
   GwbP121XaYllRSUjSSv0CNoKzqlnkF2R4KIzGWGRdTBmVB2VNLUqodo/G
   B/QIhxJ47DpH1nk2BiVQ4k+K8VVIZFaWop/B3LCaDT1moEALze3L/CUXb
   aWr2zF/UENJfMtAgxJqPg+7XECeyynTLV7hqXJpK5QrxRn9LDHXJtCrXJ
   cQ+NUSwuUmJj6cX+CzyzSUWN/8wMY5SqG7ireFVfqpkVi8qemiPRTuXHD
   w==;
X-CSE-ConnectionGUID: ldfWYKJkSLqqY+kdrZq+GQ==
X-CSE-MsgGUID: GZkzxL65SM68ZjGXPbjZAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="78535978"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="78535978"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:44:57 -0800
X-CSE-ConnectionGUID: GYIwsh0pSHKZz3XvIj6W2w==
X-CSE-MsgGUID: Fu2zeO9hRfyrlG+mIvqH8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="200143945"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 23:44:57 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 6 Dec 2025 23:44:56 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 6 Dec 2025 23:44:56 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.64) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 6 Dec 2025 23:44:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qBS7mibAfVxsD9ZT4sntCz9oyBy0vbpLRmQ33wfifesjzBLDP/5kuZMZRN3PobhD9dDmrdXruIE7mvCULZ0b9/KejPl6pPCGs2lBJH4Jo/iVE9FKTl1ibLapkzB+0HH+KPsdH+sPKc0KPUofunivm27srEc0K2sADwhdOMlAqEbXnmOQF5SLpU3DwRNtTe1IurC+EurI2B3M4a8eg6Y0q54v+Xw1br6ZRDI3ImRIgI3Vqdhz6FG9gahh9Cb8Ne9qtKHzO0qIj1ZDgHjpijyaSHL87zyhc2H0mMtPevCwintwwP4cBBfG8EtqvpntIP26Bt6i8ihq/XLDazF1/C2zoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZXI/jX7mqDo/tfaN1uRXkeMRMqFxWLFSriD03TzhO8=;
 b=OSzFrWYwJC/GO/CN384/uR87BRwSmFpjPHEepODzRutfvjRNfk17F1ZYSu8k0xmAnkXqbjPgbd3JJ3tpA2/6+tpqsd3+cOv7+VZOiliNYhIx/jGkIJeWCCf7JQrF1ALEnvqoSvxmdBEmJupMwlFwNQkmmR6r2RdZXTEOePFnil6r7t16RjQEb0ThMkF6sspRAwGbT6wkaDgn1AgYV4w1r27cPuYWNaulbEz2P21r9BbhoVwIXagLN1aPWVSg7+5s2Viuir+YCKzSMbkGQtZYPMPpvIO6Hhp39tBpeM8M+ZyIYDogF518PhcDj4tDTiB4BXlcHXQk/WIzWoCQSbnJ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA3PR11MB9206.namprd11.prod.outlook.com (2603:10b6:208:574::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Sun, 7 Dec
 2025 07:44:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9388.012; Sun, 7 Dec 2025
 07:44:52 +0000
From: <dan.j.williams@intel.com>
Date: Sat, 6 Dec 2025 23:44:49 -0800
To: Xu Yilun <yilun.xu@linux.intel.com>, <x86@kernel.org>,
	<dave.hansen@linux.intel.com>, <kas@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<dan.j.williams@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@linux.intel.com>, <yilun.xu@intel.com>, <zhenzhong.duan@intel.com>,
	<kvm@vger.kernel.org>, <adrian.hunter@intel.com>
Message-ID: <69353071424df_1e0210079@dwillia2-mobl4.notmuch>
In-Reply-To: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
References: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
Subject: Re: [PATCH 0/6] TDX: Stop metadata auto-generation, improve
 readability
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA3PR11MB9206:EE_
X-MS-Office365-Filtering-Correlation-Id: ca13bc0d-1ac1-4663-2de0-08de356481bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZUpxWHhqYTRxMHBoMHNrbjdwQlk0L0haZ1Q2NmNuTEF4eGs2bzJkSjRBanJ0?=
 =?utf-8?B?eGY5cncrekVOdnF5eXAvNVVMd0szNm1HNVhPSmswZmROUmpQRDBlUkZGSlVu?=
 =?utf-8?B?Tk4zRGNlaUNlTFhyZGRIREs4LzB1VCtNSnRCV2JLaWN6MERmdkRlR0lDZjZw?=
 =?utf-8?B?YVRYN09DdEFjd0FmbERsNzBrVUZ5ZlVEcmp3ZWsyazkvOEViM0FYc3M0SjJw?=
 =?utf-8?B?RGtBem5wTEJtMHVoMy9uczkyeWhITkhPMjZiV3JUMDdiRFJHaG5JeU00QTVB?=
 =?utf-8?B?ejNOREh5R25ybGovZ2dtb0tKKytvZWRPQTZoU21ERGZTU3BmdlRXVStEK2Jm?=
 =?utf-8?B?SHBvazVEYlRkQmdqelRVcE00ZTFJRVdYVTVjZlBSZHVOOWpCZ2RMVHZIdkpw?=
 =?utf-8?B?cVY4WmphZFVPRzJydXY1Q3hVUzZWSFd3SHJYcjZBL09SU1J2dGJ0N0lHZ3Vp?=
 =?utf-8?B?MUVpZnBYVE85cWxkRWlNTmlrYzY2aUE4cEc1ZWt5dWtlUXRyRU45bzNPNi83?=
 =?utf-8?B?M1haa0IrZGVyQmVPeU5HTTJqNDlDWnA2NjZST1NyRi80UVYwT2ZRYXBSSmZR?=
 =?utf-8?B?Wm05bG00QXFFWEhTSVJWQ21JTXlzc1I1QWdXb08rWlBtOTRHODNsejdZYjFy?=
 =?utf-8?B?MEhxZHFFUHdhNXRkaTdKclpxdWI3TmM1WUt0MGRSbXZDMmhMWGUybk9QYTc4?=
 =?utf-8?B?WTVLZ2pOV2xBWS9IRVUrZHd2U25HUnl0RDlJaXd6NVN2UklQUm1NZXpUc2JH?=
 =?utf-8?B?MXE4V0U1VVVnemEvT0MwYWFWL3ZHME5SUkxLemRNYTBISllQQjVQdHBOY0gv?=
 =?utf-8?B?c2kxalN6MnRHQUtMeXdLZ0RmTE5lcENKcElHVzJZc0l5a1hoMFBUKytHMHJK?=
 =?utf-8?B?MjE5cWFHV0F2V1FnMXh6bzB4TTBnRHlYcDl6SERtUlFFcmRwVm03emYrN1ZV?=
 =?utf-8?B?Z05PMzB0b2MxYmxCbHlEWUtHL1JuQmhmWWhKd0p3dmE1L1o5NnFUUVdsZ0xV?=
 =?utf-8?B?UXdITU9acXRUWGNOdzh5Y2lqNnQ5VVF1UHpxWlE3Rmh6T1dxVE1KN3BPeWlw?=
 =?utf-8?B?UXZFNU50OEJQSGorb2Yza29sNDJDcWZuVE5lZVhrL3ZGVTJJdzV6R1JzNDQw?=
 =?utf-8?B?cTJCblFMUjVHSVltWWNFTERsL2dTbnIvbWtoUmhvUE9SUlo5dDI4eXRjclo0?=
 =?utf-8?B?SDJyQ1ZieTAxeE9hWHA3MjFMdm9SZm1KSFNrUlZXTGlKaTJoWEZablpIMjha?=
 =?utf-8?B?R0puTzJSRnltbVBwZlcrek5VVDhjVTBWQ2NjbVAycVlZLy9qQmFCaWc3dkg1?=
 =?utf-8?B?amxuMVYrTzQvOHpRQzdKcFFVREFQa0VoZnlRSXV6QVEzZisxT2xQaTJHQm9Y?=
 =?utf-8?B?NTlXK0ZTbm1YSGZhWWZETXFUK09TeUJGT2hEdDIxUllDeXVlYTAydXMxR2ZN?=
 =?utf-8?B?aE1MdDZUZFB0RWFSOVlHaDNyZWd3bkdxczJYKzhLd013bTN3eWlVa0RSY0pz?=
 =?utf-8?B?clUvYTNsTStBQWFBYmpwNTVyRy9NTWwzUHg1SGk4dVRhN0NxWUFNTTArM2t0?=
 =?utf-8?B?Q3E5Vjh4VDA1SW5kaVFDZFpkUmNDNVhPR09zRVhuTFZjdGNFM3BUMjJ6VUZB?=
 =?utf-8?B?VzZaS2JHMS96L0NOWEtTSnZPVStqR2huRDQzSmlEVUc2OGdWNHRBTVFONzd2?=
 =?utf-8?B?clAxSDFkakYvUnN3YVpLdHVUZGtmM3dadU9NY25ETldWYndWY2xBbEZ2eW90?=
 =?utf-8?B?aFhBQ28rK3lDWUI1N3c2bFRHa0Zia2Mya09ROGF1QlpXYmE0aERRS2pvRkVt?=
 =?utf-8?B?U3JyMytpSEJmMk5KdlRCZC9sR3QwZHcrTUdaQXN0WVU4VWRlL0dQQ21VaHpU?=
 =?utf-8?B?ZHcycHZVdk05Q0s0UENyb05FT0RmTGR5bHlkMk5OaHRrTkZCVGFVZ2U2TEJ4?=
 =?utf-8?Q?9htL9+aiYuTxu9gx46Ig09QM3rU9g6Ht?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjFmaU5INUtPZzdVcUJvOXE3M1R6NDljSnpLNnFBQUNpU2NIdVltNWd6NXpx?=
 =?utf-8?B?NlhtMWk5SXFMdFZ4cTd5dEdSMVlsRkIyYXhwVUh6MWFDS05zUGhVYzMybjFK?=
 =?utf-8?B?UW01WlBvNnN0K281cmozRTFTM2d4ZFUwdWpHbDlQUnF2SlJUd09OVTlxNDhD?=
 =?utf-8?B?eEFIL09UV0FtQjBrZnZwRmp4MFZhSElEcnZoWGF1NEZhMmoweGxTalg4YkRQ?=
 =?utf-8?B?bTRoeE1qM3R4Y1NlM0xwY1FJUmIzQndlN1lYQWt0VEQ2aEdXYk1Mbk9XUWpj?=
 =?utf-8?B?MThMUHU5RzdZRkZiYnVDK2FSK3VWTW5jeVk2K2FJQ21ubmFLTmpyVzZUWlNn?=
 =?utf-8?B?UFArdmV4TTVPUCtaYXowcDVMNDY3ZDAzUTUyU3V1WVBtbWlJak9HRUtIN0hK?=
 =?utf-8?B?VXcyYmdzaVkySk55YmNCZ2pTYm8vT3MzSmM4eEtQVHJPcmpYUFovak5obldq?=
 =?utf-8?B?UGo2dG01S3lESnNBTEJtN0tFMmhMWXY4SCtQM3VGWjU5RW9GYzRMNEUxc1dF?=
 =?utf-8?B?Y04wSGdUVUF0aWZlSGZxRUZSdHZseUpQTUtiQ01laEUvbUFiaDJ1VStSQmVp?=
 =?utf-8?B?MlNXblFMd01tQU9IZnc1eThwMmdBc1k2S2hWRzlJN3Ayb3lWUWlzWVN5Zzc2?=
 =?utf-8?B?aGV6dXlMZmt3S3hPVDJLc3ZTbDlQVGJJMmc2VWFJQit5NHkrSWtaaHNEODA3?=
 =?utf-8?B?SG51elRWeUMvY3FqL3F2TmxWYitJeS9aOHJkazRlcGdBY1pJZi84akozZmxW?=
 =?utf-8?B?SFpKVFJlZnArVmNrVVZiZVRYelVzNFJrcGY3VDg2akEwN0Z3MGw1OHBzMGtq?=
 =?utf-8?B?MjY3Y0lLU1ZrWTAzWnlvcG1GT2tNQkw4UzJjZkNSbUh4ZDZkdXczTFlRdDZa?=
 =?utf-8?B?aEpVQXFONk5ORFJEQktCOHRxZWx5bXAvVHg3aDAwODc2SEFqVWxwbXlLakVF?=
 =?utf-8?B?dFA5SkJ2SzB0Z25jNm5ObXpiUjBPQytYamlXMUlveThjNE54eXJ1LzRPZXY4?=
 =?utf-8?B?YTFGaFAyYld4ZFpaMDlnKzk0TzJWR0lVaHRtZEdnQUM0SG5xYVA2L2hQWWhW?=
 =?utf-8?B?UlZ3bHZCb3k1Y3lxdmZIeTc2anFpZTF3RHRzdmcxRDU0Y0NnSFFXemhiUUNl?=
 =?utf-8?B?THIzSDZocGFBb25pZGVVY3Vja3RMQitJdkovMXltUmlSMCs3RVBjZ3BabWds?=
 =?utf-8?B?c01BRWVEbWhXN2k4b05wRktvY3IrdnMxZkQ0RUR4cCtBTERJNkdPakhTZVdC?=
 =?utf-8?B?NzF0Q0RUZ04xVlg3SG95U1ZWc0VpOWZQaXllMEEvMXNzZlFnL3ZQMUg0M1pD?=
 =?utf-8?B?dmdJZlFMZkFUS2s4Q21KR3ZPNTZaS3JOV1hVSFcyS2pOQVVlekoyWEpqVlNw?=
 =?utf-8?B?TWdpcUM0bHkybDVQbVdWZGpYOUJqa3JnOGVNOFltd0Q2TTFXMVFKWi96bzQz?=
 =?utf-8?B?dlRseXpMTjBud1libldnMEQrRWpYUnFGbzg2T0o1aXVFVUhrUnJGK2lzZmN2?=
 =?utf-8?B?VXdGNHo4OFZvOGhIQURUUlZJK3ZRTmkwNzRybnMvaUh0RnUyRXVlQkFlMHBJ?=
 =?utf-8?B?UGFVa3dlUlMvVTBORFo3eGVubTB6cW1nTzFNSEdwbk91ekxkVnZpZC84WE5p?=
 =?utf-8?B?T3Y5SnFpYkhTaldXRERCQTBseDNKMlZHOVhMTG9jYVo4R0pUM0ZQWW9sSUVS?=
 =?utf-8?B?Z2c2RWRabHZJNy9DNkdDMGF4YldSdzdwNnBVeStDanJxSm8wai9BWFNhOVlK?=
 =?utf-8?B?OWl3Q0daVXlkR2Q1UWlmSEZtU1hSdUZDL29wWnU5a1lyQmJQZWhpdmw0bDVn?=
 =?utf-8?B?ZDNrdGp2SzkvL21VZm1rS1JLM0lKTnExVXREeWVkMHBZR01Qd3dSMEZkYVZH?=
 =?utf-8?B?eS90ZWhsaXlmOVdHMnl5bGcram1pSGltUmswVmpOc2RGcjZUUGZMcTdBdUhx?=
 =?utf-8?B?M0YwTm53NUVCSWxsT3hwZzNFY1RBY0dPZmhoVVNDOHUrNXFtWTIvT3FCUzI1?=
 =?utf-8?B?SXRTU25JT1hDWnQ3ZDROUjdUckZiNW9KS2pya0ROMXp4c3M1dWRsZEQ2YjlE?=
 =?utf-8?B?Rnc5cmc0U1ZFTTFTNE9KS3M1UDdGV0pzS3JOQ2svU0xSNXdoK3U4SFBhdDlE?=
 =?utf-8?B?M3VDNko4YXZQbnFvcE5KZlZLYTI3TjJRdnhyTGk5S2krWW9SSTAxTStSVzZK?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca13bc0d-1ac1-4663-2de0-08de356481bc
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 07:44:52.5319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2e53c5jtjWKSkjILvbJ6aCm4ML75r7KIF6x8Df6h5rV4e+4EyIL+mn6qdLESonfcILEorc3kBQDrlkOeyNG6UNalkMhAlAtkUnSMZ990Tps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9206
X-OriginatorOrg: intel.com

Xu Yilun wrote:
> Hi:
> 
> This addresses the common need [1][2] to stop auto-generating metadata
> reading code, improve readability, allowing us to manually edit and
> review metadata code in a comfortable way. TDX Connect needs to add more
> metadata fields based on this series, and I believe also for DPAMT and
> TDX Module runtime update.

While the writing is on the wall that the autogenerated metadata
infrastructure has become more trouble than it is worth, that work can
come after some of the backlog built on the old way has cleared out.
These in-flight sets of DPAMT, Module Update, and TDX PCIe Linux
Encryption can stay with what they started.

I.e. let us not start injecting new dependencies into in-flight review.

