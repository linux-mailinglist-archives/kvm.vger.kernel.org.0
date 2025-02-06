Return-Path: <kvm+bounces-37536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A667A2B42F
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 22:30:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A622E168CED
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 21:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C127214A92;
	Thu,  6 Feb 2025 21:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l5NwW5Kn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7DF20CCF4
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738877423; cv=fail; b=B9u7cf7m51WkwpP+yHpST9zCT0/c24GFNrPv+MY3I2xnCRN3oWzdyh3gudUzhMv7pTUF6B9PgO3+XHXeNJrtuQF4vsgfsdVgZRhQC+Bv4Mm9pxlXzraVplrxDk6Mj5WiqcUGr8fnW4GVTwLRzUKOf+lk6W9e6WqHzJk+Ogzryc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738877423; c=relaxed/simple;
	bh=1qZTCnPfzHEMTvRL8K7WzXXQTI5QYhVpj2XjH3QIEkY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SzGzr2qt3TbCe5p1L6Ra7EumCQZ+62//IhQe2F2vl2DxNYoJaSZe2LIKUlZblv8m70UToJaBMFYAVrcqEs4CB/pYBR5Bko11xYqr0E4ceLs1zbZdA+qdIbg4iZzJrVB8cnPSXu5PjfCZ9KAHFBvS9v+kcgr+dhLVVBT9GsODyGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l5NwW5Kn; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738877422; x=1770413422;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1qZTCnPfzHEMTvRL8K7WzXXQTI5QYhVpj2XjH3QIEkY=;
  b=l5NwW5Knp2MlHJzEzMlKNrUbXn8B7Eszwc42a11VKUN3MgQCf166rQop
   GamGLWAv5w8Cd06mO1WuhqR2B0db1VZGHDW6GO5+GUMMhWX9/L7d3X2mr
   9aXXQBr/peICYJ/3wRVqPU7B+FPUIN+62otvvVmMXqyl/R3Dd/L7X7+qJ
   UsFJ9LVuTzmk0luIRRXetk/n6hYIv33pUFdmkPxng+GA2tVI7hY1oi93o
   azfkqP+0OLwVRJo55MX/fr1/9Zr1pSVBtcnw1jnUwZfwclsR3PnQKCpva
   5RPSvpfSY+35iQKJRhz8DX7rVwC3wMRuUJYQIppgsk/0DfFzXSbaVhsUu
   A==;
X-CSE-ConnectionGUID: OiRYLJgaQYCKz4jDBGV7ww==
X-CSE-MsgGUID: iT58OPOTSNCJG1sKHuehMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="39414662"
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="39414662"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 13:30:21 -0800
X-CSE-ConnectionGUID: VqY8M1YARBiSaKt/Q8ytMw==
X-CSE-MsgGUID: R30uzxPTS/Wtwr/ctm/Fdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,265,1732608000"; 
   d="scan'208";a="111165374"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2025 13:30:21 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 6 Feb 2025 13:30:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 6 Feb 2025 13:30:20 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 6 Feb 2025 13:30:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBL5fmVmmeR0K0PGJjAdbhRIcD0LLbmatNoG/bqCY25E1mGZe9PFz8YJlAKHYTBvG49WLs/rzxG6XRvmVlaQQ8tty+uui4NVb28D/lr2TsJwTksGauACkOg66M/pvg6yB7sx/ZJCOTktkOKDJc9IfTKdMia26Oo4mNCLrLnu37KAp5ekqJY2D2ifydT7oObsbBHvk7GJ5Ql5FDCjUWwz9A0GmsdssGF3SNVqQVIety/haQQIReUKcG/AjBYZhcvouMH9OETNhj5Jnuf5iel169P1PVgAGsugimxy+k9Vx7jr+1+Xqggv5AEqxveSO2v80svmQM3BBHzvIHVugsv53A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35Pq3tE7fhxraLGKi/v9Khwv7V0G4c+ULQ2i2+rql1I=;
 b=f08Y8OYRoVRxhAZdC4rstVVtU2xQ6pVlWM2pyBEIrqXxbwaLotF7PnALjSOz1vxY31BznL4f5br8IURhPOV32O5zSUBum+dS5E6nLcmDfawwgOn9/E0GLqddFAP0crU6WLNhmrrWQLzw0Ic+Vkjyaaem8wjAfmGe/8AJR3k3phBrZmvdWb+M7nY6SoK8iYm3/qkp/ViQebSFF/qUYCoeV0s3Gqsuh9UrZZbhrOkqRGN2j6OejkJUgDcojEFljerawHMcT3xX85bjSXaAoxI68A8kSxDUqgDSNajo0sO6aim51qFCH+K1s6FLhcdTBYIMi4qy7VqQGQuJxWWy9GVl5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4637.namprd11.prod.outlook.com (2603:10b6:806:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Thu, 6 Feb
 2025 21:30:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.8422.011; Thu, 6 Feb 2025
 21:30:12 +0000
Message-ID: <22e0e826-27f0-4988-bf22-1e8c327928ea@intel.com>
Date: Fri, 7 Feb 2025 10:30:06 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm:kvm-coco-queue 39/125] WARNING: modpost: vmlinux: section
 mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit
 (section: .exit.text)
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, lkp <lkp@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "llvm@lists.linux.dev"
	<llvm@lists.linux.dev>, "Chen, Farrah" <Farrah.Chen@intel.com>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>
References: <202501231202.viiY8Abl-lkp@intel.com>
 <BL1PR11MB59780AA56D67068C906A40BAF7E02@BL1PR11MB5978.namprd11.prod.outlook.com>
 <9a9fbef8ce874f15a5c8fdd24f2958a4f76c6080.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <9a9fbef8ce874f15a5c8fdd24f2958a4f76c6080.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SA0PR11MB4637:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ea129b-8bd2-4043-3304-08dd46f5707b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QlVSdkUreUZTUDMyNDlsajRadEtFSytkY2lMc090Y25WeENkdXdsN2Q0UGRk?=
 =?utf-8?B?bGR5aGhaakdEQm9GYWR5aHExdDQ4UTJMTGhCTGZBYitXNmQramdiMlA0ZGRq?=
 =?utf-8?B?alIvM295dlp1cG1TWGoxL3lJNk9iTnYrNGJ0clRQS2VhczFGd0luSU1ueUx3?=
 =?utf-8?B?KzVqWVpjdVl2WU5EdDRJQUFDaXBHZjR3OEd0ZFhDdkk0Q0ZjdXljNDVQN1Ni?=
 =?utf-8?B?MTRGLzM3YkRLVnZoSFBuUlRndmcrWGFjVU8vSVVlZ25Gc1E2YkhDRGE1WW4x?=
 =?utf-8?B?dmpZV1lIKzgralBNL0J6RE5ZWnNtbk9Db1BJYWpVMkxseDJmTTRqZDA2c05G?=
 =?utf-8?B?L3BGZlNOYk5MVWVMcWNXNXhJOXRUbHpveWpSekNUS1Z6cXBHRk0vWVN5NXF5?=
 =?utf-8?B?MHFLTms4U2VJSFNHOWtpRWIxRTUyWnBRa2lhbXU2Z2F5UXJtSjRmUU1tWnVv?=
 =?utf-8?B?OXBDN0FaSE5MbXY5RlBBN2hmM0k5Tzc1dG44eTdzZmNrUVB5dnVxeml6bWRJ?=
 =?utf-8?B?NGs5ZGU4eVpJYlF4dm1lV2o3Z09zZjJ1YlNGQVVJSzd0eTIwNVpkdHZGeVZk?=
 =?utf-8?B?cVI3Q3hwekhkVUMrUU4zN0FtSDgweVF1VjNMcFdpeHhwdktwZDY4UUFjZUo3?=
 =?utf-8?B?aHpIRWlRZzJpTlVlcnBDaEFVcTRkczVZeUlkY2hRRTdIeEVRdFV2NEtVTWlq?=
 =?utf-8?B?V2lFbXIwQ2RWSzh0Wk1Uekk0UjV0ckhDcWl1YkdJYlFNQXFXckxNQ2tLNkZV?=
 =?utf-8?B?clJXNWhUb29ERjBGeEMraGVaaHQwOHdJNGdka1l3NDRvNGRPUmkzY2IvZi9n?=
 =?utf-8?B?d3cyVzVlc2dTakZ0Ymo2bStxQU9paFJHS1p3Zm9YTGtZbzZjUXFVaWRqMTdM?=
 =?utf-8?B?VTFHUktVbzJSTFVCMDgzMnA1Mlo5by9hZHNONjRzU1d3cURUNFh4Y0F3aG4z?=
 =?utf-8?B?VDRueW1ydlRVVGhVMnhnZXRkTWE1OTdVREE5aHpDWmVTODg3NFVpL042YjNo?=
 =?utf-8?B?VTJjeVRtckFtL1ZpT3RrdzJMSWc3a2ZLWFRFbW5iQmpKK0tpWGNOcTNGRlFs?=
 =?utf-8?B?bzgrem9HQjZCaHBTWDFuMVNsZ2xzclR3TmtpU3liM0I2Q01pamk4My9GWmYr?=
 =?utf-8?B?VXdvMkNUSmptV2VFOFN1V3Avc2dXbk9LSFZGRTgwWmp3emxXNkhZQ3l0S2dV?=
 =?utf-8?B?TmFoWG81NC9LY1BjR0JaMUhNRHErRzVYdytGc1NXaW1VZ213M0ZKMSsrLzcv?=
 =?utf-8?B?a2tvWUF0M29vTmU3NkpoYnNaL0hkaHN4ek54ekFFT25Tb1UzR3hnSVIwQnJs?=
 =?utf-8?B?KzhFOUtrUGNJVTBpOE1LWjYyUy95cVg3SytvZzAvZTBHUllTRzlVdFErZnF6?=
 =?utf-8?B?U094c2s2VHp5MGM0VFFXbTBIblArc3pqaGROdXAxZ3BDVlJPMTFqUnZ3cmw2?=
 =?utf-8?B?K09qd0hsQlZ2SXB4OHB3eWgxK2VzY01UUmtqQVJQNEdjTENSY3BtVEN3ZmRB?=
 =?utf-8?B?c1BMbFVmcDZ2Tk9BUHBJYnhPU3VLN0FZbkNycXVqMmxYMGptSjA1dm9tWlBU?=
 =?utf-8?B?RlYwTG9ZWnc3Qm5hRCtaMnErOUJpRnpKZ0YxUjRaMWxSb1djbTE4Y25qeG0x?=
 =?utf-8?B?WmV6WmRDZlU0Y2lZMUhieWZRUEwxZE1RTG9QVGFwUGxPYWJXMS8xYVE4UElH?=
 =?utf-8?B?MTB4L3NqSGJhMjBLV1M2TFRFbnQrL2E0am9HOGRjdXdXRXRGcVF1MndVL2k3?=
 =?utf-8?B?TzU3UjM0V0t5VmtsYmsvR0VhT2NxaW1qc2ZzYStFSG5SZFlZWmZnalpKalBy?=
 =?utf-8?B?WmZvdi9oTDB2MnVBY0ptcFlHWFkwaGNETmplN2ducW5nMTBTMnlyYmVCc2NR?=
 =?utf-8?Q?R7e5Hyixp9tgd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OFZudWNraHJGaFAzSjhra1hwUEtTVVBtMlRMSit0UUVpTmFkU3pGcVdKMVVl?=
 =?utf-8?B?ZkxqMm8yVTJFVjl5Wi9lcG5XVjhpZjloMVJJUTR3b01lS0haVmhoS3NCdCtu?=
 =?utf-8?B?c29PUlVIMU1PcDkwUHZMazBXVEhQRG0yU3VsTU0zOU5Gc3FXeW81dTdhSWFy?=
 =?utf-8?B?SXVDM1VQdk4vVERYRk5yaDFOcW1TVXZTT3A5d0Jpa1BnRjBIS3R5WVlHMDZG?=
 =?utf-8?B?cGZsb0ZwbUU5OUk2eHE1cW1DRENLZWh4NU81RFF4NFQwV1JnUk92U0pHYXQy?=
 =?utf-8?B?czcrWlU2NFhqTWFxYjVHa0ZsQ1FmUzV4R01PR3lLOS9mc2FBclVtVTVSdzBu?=
 =?utf-8?B?d2hISWdqaGxtemdyNXlCa3NRZU9HRkU4M25iRXc5MCtQRDJmY25NN3R1aE4r?=
 =?utf-8?B?UHZEOHp0L3RyZjhxUDNiYVJYMkd6cnladkpoQk5FTlJuRUxiME5mdW9TOTRM?=
 =?utf-8?B?K1kzazN5OWdjZFVEcWwwZEpLM05UY1dxd0VORlo1TUM4RkQxU0NKb3BxdTBT?=
 =?utf-8?B?eThlcGRGZnNlZXd1VUdSTnAwOEJRTmFJQjJSdjBVWHJBL0JJNEpPV214TTJ2?=
 =?utf-8?B?U01wdWl5QXlINmRZZHdsb200bVRuVHo2ZncwekhFbjJwYTJiQVpSL3JJS1hu?=
 =?utf-8?B?eGNsNklnMHM5ZXpXaWhwVzlJSUhXblhqOER3MkJLeTd2THNyUHBnampVU1Ft?=
 =?utf-8?B?OHNCaDl5SjF2aUxKci9YSE9wZ3dyU3dHVFhDMndGMHVaQzJGVVhVWnB1ZDA4?=
 =?utf-8?B?MnFDYnVteFE4dHVOYlE2S2wxQ25raHVZRDF4UW9TZzNaeE5FQlZ3QjlNeVBD?=
 =?utf-8?B?aTlFandRNld6NThHL3JLU0oySU1kZGRBUFpjZVdQNG9iTTlueTRrQ2ozclYz?=
 =?utf-8?B?K1hTd25IS1pSRDI5Uk50NnVCVko1ZDZXeFlQWTFkQ2hCUU1Cc3FreWFRNjQv?=
 =?utf-8?B?SlNRZ2IrZTU2SmxOT3IvK0pac2ZNMnZwa0lFekxIazNPOWJkWUFxaFpQY3ND?=
 =?utf-8?B?enFodWtMK1draG9MZWlQV0pzOG5oeWU1ejhEZzk4dXRoYlQ5RTB3Q2RJYkQ1?=
 =?utf-8?B?dE84TWJQYmcxSnRNSVlmajRwamp2QjFFU2VCRU9NNUVQZVBlWk11bW5xODJK?=
 =?utf-8?B?OEFiKzBqTnJSSFpUMFFMaTFpanBoV1BEeHhIaGtVM1laZlh4MUgrNzhnTHpD?=
 =?utf-8?B?c083dkEvWFFyR3JUeEF6V2Y3MWNwSm5pMi9LTThHSmowa0J5STdjVVZQWE8x?=
 =?utf-8?B?Y0V0Qm9QYVIyKzdVdTNMUGZVc0R1Ry9WZ21VcTZrSTNYTlBMdHdmbWp3RVJX?=
 =?utf-8?B?Qk5UemN6U01Wbkc0RlZ3Mzh6a294ZkNTazZGYzJ3Y0tCdktuQmRuQmVUcjJI?=
 =?utf-8?B?WHZjWVo2Uk11bVo3Q3VsVE93c2xCYlcrWU13Q0h6bnNGc1dvRFVXcm0rRUtD?=
 =?utf-8?B?dXZuOUNSWlpnaWNvVERUcGlqRnNJZEllOGRzZndWaitYbzRjUUk0WE1jelJF?=
 =?utf-8?B?K2h1Z1hPVE9vRGFQVHhyTWk4ak1CeEQxN21sVFRCeWJVM0tsa09OYWNTK2NZ?=
 =?utf-8?B?cXJnV09RSSt3NnBNeEUyZTBKdHBXYUtqempMaE9WRkFtN0l6MVVMY1B5TkdF?=
 =?utf-8?B?b2loUWlZK0ZwR3c4Kzk5Y2dLaDFZaXltd1JuQ3dEMWRTVEcvZmdRZUVienZq?=
 =?utf-8?B?WTl3K3c4QVhqandMcWZ4dTNDYXJZOTVwNmZ5T0ZnYi9icVZlRXBycGZWMFEz?=
 =?utf-8?B?aWkxcURwdW1iT01SUHlRRjlGWDlWa0crL2xSZ2RWdWZrZ2FVeFg1RzM1cmRt?=
 =?utf-8?B?SFhvTjMvcWIycjBId1pLTWlkS0Z0L0V1S2sva2xqWWd5ajh0d1lMM2Vzbjgw?=
 =?utf-8?B?YW04ck1oMTFkQXNSQUhGRGRxWGVyc21zY0YzVGdnY0doVi8wS2VHdEhPdUFG?=
 =?utf-8?B?eW82Z0NGc0M1cjh0VHQ1ZDVBMlpyZ0JuY0pRUUI5UnoxTkNxK3hMMmpFamFl?=
 =?utf-8?B?TEdQSlE1aWhTK2xDTFluWmlOUnFvRXZZTlhvRTc2L2luWGFNdExMS01XQWpE?=
 =?utf-8?B?cWZiK1U2YWVwZC9CVWd6RDBtR0ZyZjJGQWJPS0ozd29GRHlnMmlBUnRIdjdT?=
 =?utf-8?Q?Gv2V4hhpHg/M37ex9kzyo2OTy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ea129b-8bd2-4043-3304-08dd46f5707b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 21:30:12.6295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v24IbvR31MMDrdpNz35Gsh0l8UzmQQoIOIwT8S3UWbbdnC2nUh/0X6P4zHL623VeN5xvLnWEVAb/httkugPZvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4637
X-OriginatorOrg: intel.com



On 24/01/2025 11:54 am, Edgecombe, Rick P wrote:
> On Thu, 2025-01-23 at 08:35 +0000, Huang, Kai wrote:
>> I checked the code, I think it is because vt_init() calls vmx_exit() in the error path when kvm_init() fails.
>>
>> vt_init() is annotated with __init and vmx_exit() is annotated with __exit.
> 
> Yea. The __exit was just added recently:
> https://lore.kernel.org/kvm/20250102154050.2403-1-costas.argyris@amd.com/

Yeah the __exit was added (back) because vmx_exit() is no longer called 
in the __init path.  Now with vt_init() for TDX, vmx_exit() is called by 
vt_init() again in the error handling path.  I think we should just drop 
the __exit again in this patch.

I tried below code change and the warning disappeared:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 58915395da8a..9ab3507248c6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8586,7 +8586,7 @@ __init int vmx_hardware_setup(void)
         return r;
  }

-static void __exit vmx_cleanup_l1d_flush(void)
+static void vmx_cleanup_l1d_flush(void)
  {
         if (vmx_l1d_flush_pages) {
                 free_pages((unsigned long)vmx_l1d_flush_pages, 
L1D_CACHE_ORDER);
@@ -8596,7 +8596,7 @@ static void __exit vmx_cleanup_l1d_flush(void)
         l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
  }

-void __exit vmx_exit(void)
+void vmx_exit(void)
  {
         allow_smaller_maxphyaddr = false;


