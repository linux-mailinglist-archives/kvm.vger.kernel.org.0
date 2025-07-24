Return-Path: <kvm+bounces-53367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C24B10AB5
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 14:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A266D189CD5B
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 12:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 890942D5A07;
	Thu, 24 Jul 2025 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f9cQpsMu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FB52D4B65;
	Thu, 24 Jul 2025 12:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753361548; cv=fail; b=g5D/ksjkksSOJ+HT48WSaYExacChuL5N3uPeSveezk9btJhP9DQ0gx0IwZYLn5nlLi3biF2E/w8DyP/WqE3dYIXm1XM/zLYI5RPUuz+8k2OqHAUJx8EoEo2XiVZADFVnqoYwQrbAVXz+ytG56m3j/iie7+2wocQw9OnBp7N5FO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753361548; c=relaxed/simple;
	bh=12bAPm+Ya4X92TrboVLASIGCHuvRYTg+sJTBcAF8Rt8=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=G3KzuNOlTer/O+FgdfH/xcZ8x0PVW52fmnrMYm4KqJTpHfIKvfMWvNLeExgWwgZhsyCrCFjEWEcs+F+5mDvIwSyyKIr9Rb0xqzIbwATj6+7knzywDevbyeLGwvs7ALujwj6ZOYFvI3Kz0gCDTc22INe2Cm9xwYBk6EmmjOc6cdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f9cQpsMu; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753361547; x=1784897547;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=12bAPm+Ya4X92TrboVLASIGCHuvRYTg+sJTBcAF8Rt8=;
  b=f9cQpsMu8nusr97lSMo3j4v9r8k2iGr57dA7U8mnildsUuxRdx7WRo++
   AESwUq3zu83SQ8rTpka1lPjVUEvpVaXPgvnQNJkAae+RRPOvtau3Hf/io
   xfl5m+/SUn+mYUKJ+8iBrf2UxYm0QHJAGlsBx7Dr1hrpJbwDGQ6Ch4WqK
   X3Ft0ImCD+6KVnmrgkO2zLF89hfmTGdsU4LrAzYFR6N+LYWp4HE65eu+u
   g7Mba5BwXj7f1X0XgwigRC9IXtfj98F4RS4rzMmtBsuubsMFsGc6nbk59
   n5d1Q1RJ5bF8p6vYweHGlpdM/WFtCzdgfdMH9S8P4hvpwoi8/TlqyVQzs
   g==;
X-CSE-ConnectionGUID: c03EHQhXSCexjW1vpAVVcA==
X-CSE-MsgGUID: PL0HVxMjSJmH3f7sZajBXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55824790"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="55824790"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:52:26 -0700
X-CSE-ConnectionGUID: 66PBP41aQ7iHP2PX0brMKQ==
X-CSE-MsgGUID: Le+Bi/CbSEWMDbx+wf3vJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="165759190"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 05:52:26 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 05:52:25 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 05:52:25 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.53) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 24 Jul 2025 05:52:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dj3Jg0YwX6+oYxFASEww9t3EjPNt0T7Sj3aBEsdKoQAEKzUoIRAWcijGAeEXqZMk3lSv33KTYOzcI7oZiM6J3QZCR9L7jF0h2xCq627G7fk0r+Bpo0zR7AX7bgtsLKdjLu7KS0+21WE2s1pFKyxLbhAMoHJwct2IQIFFWEkQLYhNTfZh+NaFMAynTrECXiFrzDiuWNi8r02P//0/luZZqTndFWnDnVm4aiHSuuB2AcA98o43NgpP4gX3fw4nrHTQXa8Pd5nUs22f8NoAhLy+wsdyI5lZthgFWdeaPYbyczaym80EjLiRzPSkMnxmQw/CqFqk3kXgido7r8uAqD9H5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qCI89iMO/RBNKXBfSkEcS84IjNimboHEefUYP9fK+V4=;
 b=gYmWSi4XiZbJlCs1UOssdScEFd7058mCacM/NMaUvi2rayvIy1+IRuQO2y4MA3IaEKjh/vjiVkWEV0B3tbm9c6/gmPoXsgDZl63DKqUJG84eyi7W7hcsoI7loZ25wq97ApEBJZNE5VLd0nuoGCQGf2Cz67kOWqoNSJSR/+NTh/G/BzjzyhmuxGmF/MQjDlPnzPiGWe7/8e52fdLLBNMLDj73VGcDtnmhDr6GD4RY8ZdnMLgez/c9PkuoKcrsfnevSwOELKP2mwnLR1PLVHyhFZxjcRtoyn5L8YBb0NA9YOthxVq2R+5LZlTZYaz0YdWFs5cpjtDuAeeb78XY/MbzZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by CO1PR11MB5075.namprd11.prod.outlook.com (2603:10b6:303:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Thu, 24 Jul
 2025 12:52:22 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8964.021; Thu, 24 Jul 2025
 12:52:21 +0000
Message-ID: <11f1346e-4a23-423d-978a-69e405e76d50@intel.com>
Date: Thu, 24 Jul 2025 15:52:14 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 1/3] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <vannapurve@google.com>
CC: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	<x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250724124811.78326-1-adrian.hunter@intel.com>
 <20250724124811.78326-2-adrian.hunter@intel.com>
Content-Language: en-US
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250724124811.78326-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0320.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::16) To DS0PR11MB7215.namprd11.prod.outlook.com
 (2603:10b6:8:13a::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|CO1PR11MB5075:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ebe7f3-a390-4a14-7fc1-08ddcab0edb9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?elFsdmsvd2xHMStibjF0TE9QRVBqbmJiN0pDUDBXQ2xMMTNuL1I1KzlCOXBY?=
 =?utf-8?B?aHgwRER4ZS82MzVmN3dOQWt1RHlTdmZQeVYyOXFsUFREQjJ0L0ZET2d1WTll?=
 =?utf-8?B?YXdBc0kzUi9rUFIyTFN4cSsvUlgvNXBjMms1TDExbTFxRkkwNkNnVDdDWTBm?=
 =?utf-8?B?Q0dJemVtS2dFRmJHVXFNSnVFaEFkNUxiQWI2SG1hN3M0TE5yRjA0bmhLcXA2?=
 =?utf-8?B?TkR3cVArS3dhOGJ3QjluaVptczhFWTJSMHNUWnMyUzdrTTIrNzlPS2pZVHRv?=
 =?utf-8?B?dUZMdzFDSnJPdFIzMlFoYmxHVlJ3TGhhYis1RXVBTkM5QkVadlZlcUF4U0c0?=
 =?utf-8?B?ZmorQStMcVo1Q1JqSmpjQTdPUWtJWDFkWHcxKzQrS294bENFWmQ4eU5DT0tY?=
 =?utf-8?B?YU1sbUhFenRibzZ6WEo5NjBPbzczN0U5eGNROVVIdzV5RHNoelBzQThuK2VJ?=
 =?utf-8?B?ZDAwbjJ4TlRvRC84YXZEeUNhWmMxMHhMY3YxWERRNUxOTXZaazA1N2srNCtI?=
 =?utf-8?B?MXJhUEFwemxnVXcxL0V5bGt0K1NoQnV4aDh3MzJBN3djWHdQMEh6aFFFRDEv?=
 =?utf-8?B?Q2pPcFEveUpPNjBiY1hFallDVzI1YnF5YlQ5M2l5SGo4M2hkTXZYYnB4VXpQ?=
 =?utf-8?B?bkZINWVCM2RaSXIzcUc3aHlGRERjaVRHUG5RMWZZM0Uvc1hwVWhBaU5jdVdm?=
 =?utf-8?B?Q1duMkxBWDVJTEtISU4zNEcvWFkybUtUa0pOeUtWaFh1S3JMckpmLzhQZjli?=
 =?utf-8?B?dFZRd1RibytKbVFOQjh3MEVnVDcrSmRRYVllN0lUU2RzRVJFdFJuV0NvVUts?=
 =?utf-8?B?dnJIcVo2UTRYY1dTclNpNzlYNHp0d1J4M3Z5WmlxVEpsd1Z6QVNJdVJjeE01?=
 =?utf-8?B?MzVEMFdIM2JsQzN0N2t6MXR2Y1FwY1FDbTdnb1FFemI4L1FUeDY3ZlUzSExK?=
 =?utf-8?B?Y3IxZlNPMG01UVMyY3FSOUo4cFBUMUNtQjJJQUlSZ0I0dVJoNG5sK3hLakE3?=
 =?utf-8?B?ZmdRL2psSXExT2ZnVjJ3TUxXR093aFZHMXluZ2hWM0hUUzZlUFc1WEM2VklN?=
 =?utf-8?B?c2ZaS0x4Nk5Odk4vazZNTzZDV01XdGFSaTJsWkE3RldVOXYzbGRBalVUTlls?=
 =?utf-8?B?UlJxVDlRYlVEQW9Uak9YKy9yS2VMU1NvRjlxYjJ6TzNOd094VStrbFpHL1F2?=
 =?utf-8?B?ZnhCVUVrOVRER1N3MzdvY1pZOU1LcEdkS2h6RFZvL0lmVmtJcmNzV2hlcWJM?=
 =?utf-8?B?bjJFdkdIOTZScG1sdDhDQ01salB1cFA2UElJOEJQTitXMDI0ODRvamNVTVVL?=
 =?utf-8?B?WFdOeEltSkFMdDROVWRPUHdoUzJSZFkxU051SzMzL3lkYnQ1anpyL3d4VE5Z?=
 =?utf-8?B?RlFUMEhZUDdpQWNoNVJ3dGJwd0NiSXd2MDk2cXBEcTRvczN5UFdIUDZjMkw3?=
 =?utf-8?B?bEFadmVCNDRkaWRPWE9MUEIzV1h1T1A3ZnFubjlidmFzN0JtNEJBVFZ1WG5H?=
 =?utf-8?B?WU9KNVludnFoWFRIV2F5SlhpQ2RXMjRtSytOcEVrWkJJamZnblFtS2t2Nkgx?=
 =?utf-8?B?K1RVNjNXOVBIeUdwNWZhdzdkZUdvSGJ4VXJlcUpnd20yclp6aXVRMW15SFhS?=
 =?utf-8?B?elNzUy96Rnk2UklIZWJKSzZraGNFSnpHL1pCUzNWREhSREwzL0hUYXZXczZZ?=
 =?utf-8?B?bGMvTHB6SlRLY05NcW1SOXhEWitTcDArSURFZFZ6U3daVG1RVThIdGVFdU1m?=
 =?utf-8?B?anF0bzZxQ3FJLy82Ynl0K0JtN1M2ZHNZcGd0S2VKM3dPTDd1aGxvd3ArNnFW?=
 =?utf-8?B?YnpVUUVDbEVIb3h3VkNIaEdabnhMZnlzMUxqRnNLZFJDM0VwVEg0d1hlR1I5?=
 =?utf-8?B?bUhEbjhPRlo3MWp2MmYzMnZHdjNNWm4wZ0ROR3M4SzVWMmNNa2EvaXEreWkw?=
 =?utf-8?Q?0jdYunj9l48=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmVVTWxYdUFnTDcybXNRYytSMEZldWpXWUdCSzcvbjJ1ejlLd3haOXNVM01t?=
 =?utf-8?B?M0dJdlp3Qk1ta0tFYzJJdmlSNEU0NGdMTkYzeWU1U1VlWTFNYmpyb1ZlZTBs?=
 =?utf-8?B?RmdETjVEOG13TUxsbmpBTGZnQlFDVFdZQzd0c2c3OHFUaC9KaWdzRDUza0lh?=
 =?utf-8?B?NUxzQXVLeFk0NWhNUW5NdjZROVcyb0prbXNVVE4yRmdjSmhoaXN3WUh4blh4?=
 =?utf-8?B?QzVWWWhGL1NCekFENTkzb2Q5ODNINDArMytIczNJOTRsVzc2TlhUZ0kyQ3B0?=
 =?utf-8?B?Nk0rRUVHVy9xcVpjY3hzWVFJc2NnY1M5YXp6NE5nSDlLNjNoVFVhVWpmUGJt?=
 =?utf-8?B?K3c4QW9sUkhET3JBL2taMHZsTWdLdUVwOGJqM0cweWNOTjRGSm9mTEtydGpm?=
 =?utf-8?B?dllNUGFSNkJTdmMyQ3ZSa3UzS1lSOXB5QzN2UDFuVFlxRDM3QkdQaFJ0MCtr?=
 =?utf-8?B?b1RxWkIwTzllQWkrQktWK1czUTJXdjAwNjNuakp5RjNKaElCMUliYmx1MVg2?=
 =?utf-8?B?eCt3MHNNTHRiVlpvUmlpY0hET1dyMi82YTZsMDFRc1h5ZWlOczZ1bDNURlhh?=
 =?utf-8?B?ZlF3UzEwUU5jWnc3MlgxdVZ2bEdXaE5mNTFsc3paYTlxaGY1RnFEU1dmYktj?=
 =?utf-8?B?aWdVNjRkb1pFMlJBOHJuZlJrbE5DZFl3SzFOdmVOQy9SUzlIbjB2VThkcTFn?=
 =?utf-8?B?aFBFYjVtQ0hMeVRnNUJHZ1JtVjIyYlRPOThQeHJQNUs3WjNlSWhEdzFKSTN5?=
 =?utf-8?B?WGtUVG9QdEZsTVd3NnplelFPbFlTbTZpbExLdU5CL1RKS25QSHhFS1U5TE9G?=
 =?utf-8?B?YWthbC9ic2ZESTdDcDlyV1RSckdvayttMGV3M3p2N2M3dU9GQkcyeU9uazNu?=
 =?utf-8?B?N1VmQ1YzWEltU0NDSFhINllRU2c4Y01waEFTd25TUytENEc4TklwMVZJbzVO?=
 =?utf-8?B?MTV6RjQ1WWJ6ZU9qS2Z1akcwWEpxclBtRXg2SXFoeGpwdFRkN0IxOVJ0bUtE?=
 =?utf-8?B?OUhoMFdoSVliQU45M1lJSmNFcWUxT1pHa2hGbVJZQVM4ZE9vNXBxK0s0Q3dT?=
 =?utf-8?B?L29tcFJQc3ZQdzZ5ZWUwMythZUkrdVRYRm5aaGJnK2tOa3d1UEpvZmM2bFZt?=
 =?utf-8?B?MWxLV3Vaem5aeHBPK1FzSE85Rlk4Q1lYS2Y0S3RmM1grdm5GQkxDTzk2QW1C?=
 =?utf-8?B?WGo2VnVtK01lNTF6TEdNRXYvSDVZeWQ0U2NvcnpDejhBOUswVE0ya1llL2Zs?=
 =?utf-8?B?cTVPVEgyR1VnVVdPWVM3MENFS0tWYVhSbGFiRHhHVFh5OUJMakMwS092ZTZy?=
 =?utf-8?B?YUJnUjdiVktpZkdjNG1GT0VuN1U2S0g1ZlNsYU1kd2p2Qkl0cEh4R1JEdHI5?=
 =?utf-8?B?T2ZqbW9CU2ExWVNaMDU3cDVQUy9YRlROOVViYXR2S0pYNVJIdW1VU1hsdEJv?=
 =?utf-8?B?T3VSRC9tSk5kQXJsNTJ1b2JsbkpnZm1XR1ZLT05XUnlqN0k1QlBYd2svUm5S?=
 =?utf-8?B?TGdXVkE4YmpjS2d6cXhlSzZSMm0yakFlSkh1VmtQV2NNYW82ZHNVRHVYYUpm?=
 =?utf-8?B?VmVtMjZMcmErTGlWU05NOUs5YkJKeUphWWY5a044M0U4eFZyRXg4Z3dlditn?=
 =?utf-8?B?aTdIMmpkMUJ2TGhvQjBJRnFQQ0dqempaRnEzbHVyWk5ySkZwSWpBcTFRbXRT?=
 =?utf-8?B?TFRXK3N4c3p3OVUzT1ZmTkU2aCtScG5XZU90VCt1V3lmVUk3dW9JVmJ6cUZZ?=
 =?utf-8?B?VzRZb1NNbFlGU2NGTGdOblkvYU9tcWNtMlJDZnVoU0ZFUlkzd1U3SDJQTVZi?=
 =?utf-8?B?bEpVcWcvUkZUejFncGIxcWVMR0VxSzd1SE1xUEZrU0diREoxZGtZTlNSYy92?=
 =?utf-8?B?aUdEdGNURmxOUVZPMXFSWmFLK0x4V0l2TlhzYngyUndvN3lmT0Y0ZkJQamV1?=
 =?utf-8?B?Q1EwSjc3SVdmcFdUSGhlMDdpcytJZzZwVDFHKzJPbENBOURBZDh1dWpHWlRl?=
 =?utf-8?B?dTVWT2g2K21URG8vT05Yd0xpZDQrZWQ4VUhSNmdSR0V6Z01KdEYweEZxYnhD?=
 =?utf-8?B?Tkh1NEFDdzVQanppL1RwckJ5Q2d2YjlqVmN2bThlRUpYQlFXOU1WbGxCK3Rv?=
 =?utf-8?B?NmZUVVNLaC8wcWdibGlXU1NKaUN6NVpZVDdkN05lRjk4MHNBbDM0dXhrWGRo?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ebe7f3-a390-4a14-7fc1-08ddcab0edb9
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7215.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 12:52:21.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oqgj2LYw3RzLL6OIybMWLBSRXEBCL4iNX6hz9VpXEQgS8sTtvOU+zi13am23xxCXhhC8y2La6SOyqsoOY7QrGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5075
X-OriginatorOrg: intel.com

On 24/07/2025 15:48, Adrian Hunter wrote:
> tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
> logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and create
> tdx_quirk_reset_page() to call tdx_quirk_reset_paddr() and be used in
> place of tdx_clear_page().
> 
> The new name reflects that, in fact, the clearing is necessary only for
> hardware with a certain quirk.  That is dealt with in a subsequent patch
> but doing the rename here avoids additional churn.
> 
> Note reset_tdx_pages() is slightly different from tdx_clear_page() because,
> more appropriately, it uses mb() in place of __mb().  Except when extra
> debugging is enabled (kcsan at present), mb() just calls __mb().
> 
> Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>

Forgot to add Sean's Ack from V4

> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
> 
> 
> Changes in V5:
> 
> 	None
> 
> Changes in V4:
> 
> 	Add and use tdx_quirk_reset_page() for KVM (Sean)
> 
> Changes in V3:
> 
> 	Explain "quirk" rename in commit message (Rick)
> 	Explain mb() change in commit message  (Rick)
> 	Add Rev'd-by, Ack'd-by tags
> 
> Changes in V2:
> 
> 	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
> 	Call tdx_quirk_reset_paddr() directly
> 
> 
>  arch/x86/include/asm/tdx.h  |  2 ++
>  arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
>  arch/x86/virt/vmx/tdx/tdx.c | 10 ++++++++--
>  3 files changed, 13 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 7ddef3a69866..57b46f05ff97 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
>  u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> +void tdx_quirk_reset_page(struct page *page);
> +
>  struct tdx_td {
>  	/* TD root structure: */
>  	struct page *tdr_page;
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 573d6f7d1694..ebb36229c7c8 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -283,25 +283,6 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
>  	vcpu->cpu = -1;
>  }
>  
> -static void tdx_clear_page(struct page *page)
> -{
> -	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> -	void *dest = page_to_virt(page);
> -	unsigned long i;
> -
> -	/*
> -	 * The page could have been poisoned.  MOVDIR64B also clears
> -	 * the poison bit so the kernel can safely use the page again.
> -	 */
> -	for (i = 0; i < PAGE_SIZE; i += 64)
> -		movdir64b(dest + i, zero_page);
> -	/*
> -	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
> -	 * from seeing potentially poisoned cache.
> -	 */
> -	__mb();
> -}
> -
>  static void tdx_no_vcpus_enter_start(struct kvm *kvm)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> @@ -347,7 +328,7 @@ static int tdx_reclaim_page(struct page *page)
>  
>  	r = __tdx_reclaim_page(page);
>  	if (!r)
> -		tdx_clear_page(page);
> +		tdx_quirk_reset_page(page);
>  	return r;
>  }
>  
> @@ -596,7 +577,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
>  		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
>  		return;
>  	}
> -	tdx_clear_page(kvm_tdx->td.tdr_page);
> +	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
>  
>  	__free_page(kvm_tdx->td.tdr_page);
>  	kvm_tdx->td.tdr_page = NULL;
> @@ -1717,7 +1698,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>  		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
>  		return -EIO;
>  	}
> -	tdx_clear_page(page);
> +	tdx_quirk_reset_page(page);
>  	tdx_unpin(kvm, page);
>  	return 0;
>  }
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index c7a9a087ccaf..fc8d8e444f15 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -637,7 +637,7 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
>   * clear these pages.  Note this function doesn't flush cache of
>   * these TDX private pages.  The caller should make sure of that.
>   */
> -static void reset_tdx_pages(unsigned long base, unsigned long size)
> +static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
>  {
>  	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
>  	unsigned long phys, end;
> @@ -654,9 +654,15 @@ static void reset_tdx_pages(unsigned long base, unsigned long size)
>  	mb();
>  }
>  
> +void tdx_quirk_reset_page(struct page *page)
> +{
> +	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
> +}
> +EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
> +
>  static void tdmr_reset_pamt(struct tdmr_info *tdmr)
>  {
> -	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
> +	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
>  }
>  
>  static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)


