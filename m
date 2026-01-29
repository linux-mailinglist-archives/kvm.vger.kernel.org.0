Return-Path: <kvm+bounces-69600-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFmhMiy4e2k0IAIAu9opvQ
	(envelope-from <kvm+bounces-69600-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:42:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D6D7B40F8
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 20:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8A2EF301915C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 19:42:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6659E329E67;
	Thu, 29 Jan 2026 19:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="t98xmY0N"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013028.outbound.protection.outlook.com [40.93.196.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454EF2D8796;
	Thu, 29 Jan 2026 19:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715752; cv=fail; b=FhkRSMa67EBE9sjLy5IOKKItdXploIk9PoS6Jfes1rTrcqgH4BI+itD2TMAD1AbPoChZDB6uEFEo51MwEKFcSeqSnA/z+auH16puT2c5sTAzk3/NoGx5Dl8HDMbmVz+pwHzVODT3DFCQoCrHDv2s9+W/FjaKHyJ/2eeMP0S5fKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715752; c=relaxed/simple;
	bh=oqmPkVgrKDlsVAD5mGM/mMnrWFZKP2nmw2GtoYK4s70=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e5oUED8UMUJF2DE0enGYJSiKC/foG1iWh+6f0gIiTGNRxiw+oFJjreBxsZ1NQ5yU0gp+MsUp0IsB2PN2Lk1du6i6qe4tq9AAseBejxgHgCEgZIiRjqepH8Ayr2wYIx3C5WWIgQDAqiaohqNieaDFqfVcSLkdYS4OeKOjUXVG/8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=t98xmY0N; arc=fail smtp.client-ip=40.93.196.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qw1LFNotwwQKKSRSa//+iaux+i4L2aezXfPvPYBh/zsolYQ/oN2CEt0hq3e+qHwU7ncNEci/toqgCespJ63PdCNP1FxbVq7AzqB8GWcpN9GIZ8Eebd6X/MTwnLouSN66E9Pfd2C4eGTQplTc4cyLcyZe9AzhqyYim9AsiCFq19gAHbmtaww0hSYLwBaQtvskC6yLHmNSAczXV0oBzYtkt+ZyS4uj8bWAMuWkRdXFe9tSqsnzCzCfmP/FS5/nFvXE7TwW0zRFkyCoBmqF+DhtQD7e4WNxL4HqG1YikX6y8nhyYOuUPeD7e6SZuKcjUJw5hoUchG2tXm5Id2QJTZIhCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q0eO5uV5BA5YJLedvdaE8uDRr2IcYhTp/8PKYVNv19U=;
 b=QaKVXKU69rZii8Oj5AtVsgiSiu/xW/WD82peULvepvPqvTFw8uDOUUKsfWWQh4xuIwViaX0BuzwwVhmHFXpBYcOXt08OVAYVQEgvT9S78Z/z52xvwei0y4kJVM+TZXXJ1vbTAA6EzPtL+S9TSIuSLZ8sADb0kojiq0PYSRt3K6Kp16bUVf/kS9fLpxArmB4yVjy/kfYTr4YsWxF7PAJk9q8WLfbmPety4fuX+Xt574MGVgd3r59ORlitYem606Q95XEGvPbSd0oe+bbfzCo8gZ16FA3Nt2UPuD08R2SXeI2d4bm9BkRDYIlXdFVi8iu9JQPyoUtN7rM2eYK3bxPZ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q0eO5uV5BA5YJLedvdaE8uDRr2IcYhTp/8PKYVNv19U=;
 b=t98xmY0NwaV1T1GEC5ruBk80D6UdsxwSsfFDaxsgvIM8wed7s2NLKSTKyoj77b029jUxYyifWvISuTENAPglCDvNypff0be68Qi5CMoFkIrUEwlUO4b2FbBJMcDqow3QCcmvkzicrkDNkzYRg1K/rpeLojJFX0WCefEaDGMrjqQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH0PR12MB999112.namprd12.prod.outlook.com
 (2603:10b6:510:38c::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 19:42:28 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9542.015; Thu, 29 Jan 2026
 19:42:27 +0000
Message-ID: <57d7a46a-c3d6-4c7c-bed1-ee61d6d690fb@amd.com>
Date: Thu, 29 Jan 2026 13:42:24 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 16/19] fs/resctrl: Implement rdtgroup_plza_write() to
 configure PLZA in a group
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, reinette.chatre@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <a54bb4c58ee1bf44284af0a9f50ce32dd15383b0.1769029977.git.babu.moger@amd.com>
 <aXqHs0Mm5F9_R4Q6@agluck-desk3>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <aXqHs0Mm5F9_R4Q6@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN6PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:805:de::29) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH0PR12MB999112:EE_
X-MS-Office365-Filtering-Correlation-Id: fb76c555-e300-4e6d-e307-08de5f6e88a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|19052099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1c3bDhOM0FtOGJVTituamhOVGU4dzMweC9jdzV4dGtvNDRzNWVnSHJTQ3pF?=
 =?utf-8?B?SWdTaDlhMlZHUlp5dmVuZVA0dzE3UVloUFZhdWRta1VLY3pwN1JIVUtHeGFC?=
 =?utf-8?B?SjI4ejRuNm5USFk2YnAwejdLNXhmQ0RCMUdjeUFFUUFNbFJiUVViWEQyNURM?=
 =?utf-8?B?VjAvYkx0UGdSeEV0Z2YyMjdCMEpWK1lqVnd6RXNmODVNQjd1UmpkNVZZbUpO?=
 =?utf-8?B?TWhQVUxoc0UwMGxmN3VYeWI0SUhpME9RSStEcjNXSDJQWmx2ZnBYcGdDQTdF?=
 =?utf-8?B?M3ZaUng2VGt3cmFtOElEY2tkcy9aRWdKMDJxRjF4VXpuTThsN00vRllHWEtm?=
 =?utf-8?B?a0lRaTB2dHZ3SlNkNXJmeWhSZjVrazVzaHdYMWVydW95MHBkNjRudFlmYVMx?=
 =?utf-8?B?RUo2dmVKM3hkNDJOVm5ZcGR3OW96eTR4Ym5zQ2ZOQ29QSXFYNU1MOWt0RVla?=
 =?utf-8?B?N05FK011YlRCSEdVRUlDN2hvZGR3WXQwVkxqVnNYdHRiOVZYalo0UXowaElk?=
 =?utf-8?B?SThlT1kvRjQ4ZktzNTdUWGpYOERaZWE3YmRjWGZybjgvdXJOTjA1aVBWeGF0?=
 =?utf-8?B?QjhuTUxxSElmZkN4RDVGbUdncDJsMTJ6OGlvcmpuZWRldk5ZclNtcXRSY0Jw?=
 =?utf-8?B?YmNkZ3RBQUZTQWl0eWU0Q0lBc2Z1SFdVbWppVVJLT21QMXMwMFpVQnJFQUor?=
 =?utf-8?B?bHo4TGUyd2Z4VkNwbUZEMWg1V0pGYm1MYUhrUmRFMGV5VTM1ejhLZXYrQXNh?=
 =?utf-8?B?MkZ0QUxGYmdBTExIQkVwaTgrdnJQVW1hcHF5M1ZFTWRwemRRZzZLSGZhWXE1?=
 =?utf-8?B?dUtzZWVTdlB0dUxITmQ3SmJhdXI2K2sraEJaRStWdnRJT09uSXhiVjRpVkxZ?=
 =?utf-8?B?VE1MbVVkUVY0Uzd1cE1RQUJYc1RQV3pyM244UE5WdWRLa0dGRmpQVlVhT0sx?=
 =?utf-8?B?RmpBdGhiWWFYTG56Y1VmYVVtemtOSEdJWU1GT2oyZVVqV3Z3eUtuQVpNYmVV?=
 =?utf-8?B?MGYxajc3ZUpnNTR6S2xseXcyQWg5M0dLc1BhTmlCdmNLMVkwdERvdEgvZzc4?=
 =?utf-8?B?OW5NVGNWL085NlBON2NuQXZGNXRITzRwNmNrbHFEK1FyYUZKZXBqNDY0eVpI?=
 =?utf-8?B?NGZHMjAvZG9QWDJHZ2dFYkFNS3lvajNVV3IzcGMxNFhaMUp3T0RHYzQxTHlr?=
 =?utf-8?B?MUlqMnhqMjRRMXE5S2NyTjJxbGxYR0twUXZxWFNTZE5SUWs4b25sZ0xWaGUv?=
 =?utf-8?B?M2xkcE1CVzZqKzJhaDJyTzNYaWV1N0g2RmZGN09XZElzNkZVeXVIb0RudzNH?=
 =?utf-8?B?Q0FxK0Vsa1pETC8xN0xXMk92OG9Nek55Qlo5RFoyV2tvRmtuTXQwZW1xaGVa?=
 =?utf-8?B?VHZJSndjK1hMK0lSN0lYSG5wQ3JqMEVtaCtycE9OTkNLZUo2amp1czFMUHl4?=
 =?utf-8?B?T0ZoYlhoSjU0bnlHV1o5WmxFWUErNzVQYjYzMURUcWU2NFhzZmpGMkJlZk5K?=
 =?utf-8?B?K0FJZElTNFRYcldSSVpBb1IwY3NkMXVlOFFRdjFFbzY2YmR2aVBYRTFVaDMv?=
 =?utf-8?B?dDZLWHFpdmV5Y2J5Y0Q1MzJQYVJ2NVo3VTNlQnRKRi9Va2hXZVNubGt0elgv?=
 =?utf-8?B?eGNXNEJhWkJBcTR5YVdoNkNMQUlFL1lmMnZyRHpPZDBNRXpqbGt1WWJaTkEr?=
 =?utf-8?B?ZWoxZUVzdHd4OTl0b2tvRGdxcTd0MGdmTDZEcjJ3WUh6b3lMdFBZdy9CYWlO?=
 =?utf-8?B?cnlFQi9NTkRMbERwcWZlOTY4VzMzejJDSFk1dE5xOFo4dXNVZFpsUVpJRDZh?=
 =?utf-8?B?OEVtMURHUzVDTXRFaXJXOG1Nd1hsUDFhV2JVNkUyZDJwM1hUQU40Y1IzK0ZC?=
 =?utf-8?B?NkFIYUh1c2s2djVzVjU2Y0loTlN0R0F1VFEzOWluV1hiOWdiaFdFZVBwdnl3?=
 =?utf-8?B?SG1BcTU1NjU2ejV5OUV6YzkvZ0REZ3NpcnVzY01IeGovVzE2YlE1Uk1XZ29C?=
 =?utf-8?B?aHZ6WVhHcEk3M0xJcUxmTXcyK2syZlNGazh0RzFRcllwSkNJUXlMMzBZQmFy?=
 =?utf-8?B?TlluTnRMUCtSZE9jMEF3cmg1Mmt5aUhidjFacUwyd054eU83ejM0bW1XV0Zq?=
 =?utf-8?Q?A+oY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(19052099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZU9WY1BHdi91K21aRUFBdFZ0R2FHM0JjZ3F0Rkg0VnBxWVlGYXh5Z2V6Rit5?=
 =?utf-8?B?WGFKbUN2bktSZjNOUnZqWUNGK2FXMFNqU2VOa1p0SkQ0TWtVVGJWbDVnemwv?=
 =?utf-8?B?NFdGbzJlUkdHUTJsRFhOTjAxc2ZwUDZsOFdScjhzUGxwNEIxMmdJajVJMUdO?=
 =?utf-8?B?OEZvV3diVlF1L0xKOGdTUjFaZUlIQ3dEV3hqNDJjZ1BhWHB3WjFxenVDcm85?=
 =?utf-8?B?bURJdGF1UU1ZL21vQzhkazMzY3Y1ZjZwVlo3VjNOMStwdFZ2bk9VSVNZcEVX?=
 =?utf-8?B?cWszVWtmR29uTWliVGtiMG1tejRxcGc0NUcydmwvWksxbUk1RzZILzVXM0wz?=
 =?utf-8?B?a2htYW9qSVZaRFo0OTBNSStGR25BOHZQME1hMGtNWkt6dSs5aUNHc2ViZjJm?=
 =?utf-8?B?NnhUUlo1TEpiZ2U5MWZpRC9wRGlsQ2gwd0tmY2Rzd1pISjZkcG16T0UzclAw?=
 =?utf-8?B?bWNuVjhsVjJIMkhxbk81VGhUQk5pdjg1OTFIaUtrUzMwcjhPd1Ftbno0dXRm?=
 =?utf-8?B?VEM0NXgzUEk3cDVqWGVSK0pFY2d5M29lSUdBckxtcDNuNkpEWDhuL0I1cXhK?=
 =?utf-8?B?QlB4YXFoK3VmSXBIeDcvdjluWS92YXllQUFwWTFCMW45WE9XQTBUbnBxTk9F?=
 =?utf-8?B?bFlvYnkzRGd3UDVBSDZGeFliRWhxYVdsbWNKdVdLZDZXd0tXOUtrQWdrM29P?=
 =?utf-8?B?UFprVS9nemFiSFFQbmZPQWxuRllUTUYvc28xWjZLclRNMU1QR21kTmVGSFlh?=
 =?utf-8?B?MlVhdk11WEtWV1Vkcy84UnVhUmxvaWZFZ2RWZytsYmE1eDdTVVp6amxGQ1A3?=
 =?utf-8?B?OE1VL0JGWEVUWVkxUUJUWThpOHF5WERla0ZGNm1LY2ZwSkFsMHNrTzhjaStp?=
 =?utf-8?B?NzNuc211blgrZzAzMmhTWmwwQTZBOGtQSUJzZTRmMTBRWWVKZVRqdWFITW9x?=
 =?utf-8?B?aVNxL0hkenJCZ1ZtaGhhbTRlR0NYL1hnRjVzbkdlcnhaZW9jemROaGVLR2Ew?=
 =?utf-8?B?OElsVk9VOWZudzZRWmhJc1ZENk5kZjRvRkp6b3d3VXpkRVZHZFRvWm5vM01o?=
 =?utf-8?B?aEg5UGxvNzJlVUN4b1VBUDg3bUpSREh1K0p6MStJMnljYXIybmozVVNZR04y?=
 =?utf-8?B?Z2t4NEFJZ09NRnluUGdzZXQrOEhRYmJpWXNpTnMrMEpBazB1a0JoUlh0aWpr?=
 =?utf-8?B?TkcyWC9MVE45Zkg3KytpR29ZWHcxcUtCWkI3Tnd0a3N4ZnlNajgwVVBpK1do?=
 =?utf-8?B?RW5aSS93c2FQQkg4TlZlTndOV2x3ZVp4Ynp6Tk56WG1uSWt4UXV1L2t6cm8z?=
 =?utf-8?B?cFA1MGQ5bXhXRS9FL0U3WE1UbEtBWnVReExzK2VGVzRCZUg4SlpVdGJLVVFG?=
 =?utf-8?B?ZnVqNVplbDkzOEo2bkp2VnNyamJkZzBiRTlMWktkUENOVEdnOGxnbDg5bXRD?=
 =?utf-8?B?Z3ZkNjcrblQ5OVg1b0FDT0l6OVQrblVsY2k4b2pvbm5zZlB6TjkyNW45bE5a?=
 =?utf-8?B?eTBxWnZkZGNuWlZyZkdueXdtUmIwSDFhYjhZYUFzM2UrNng4Q1Ezc1BhU1pk?=
 =?utf-8?B?a3hQWG94RTNDNjU5S2x1emg4WmJUTlc5WThINFFpWE81SnM0ZW9uOXNFWmZt?=
 =?utf-8?B?TnBlWEE1OTJFMzZQUndaSGMvUTMxbll0aHFoa2N3Wk44aTQxdDMyUXhQMXYx?=
 =?utf-8?B?Z3lML1FsWm8rUnc4V2FNOHJzWlpRVlRkRTRWY0FxZ2tvc01SWjVkMGwrY2NY?=
 =?utf-8?B?TU01QzNIczRCTTB2T2lCdE9md0QvTmZBNTNudmo1OEJ1SlF0TmN5NHlCZFNO?=
 =?utf-8?B?N3VpTkhEMHlQSWdkZTh0VWw1cDJydHNzanhJWHQ2a2NTNDlOU0R1WFhGSVA5?=
 =?utf-8?B?azdNdGVQaDRDaktBTDdXUENld0IyeEFzNW5nKzdVRGlGMkdCRS9sY2VXRmo5?=
 =?utf-8?B?MVhZbTRncExGQ2VXY3p1TGU4UnBha29UMUJZZmNlM0d4TWJmbVJlYm5qVWlq?=
 =?utf-8?B?MTBXTGNtQUFmNHozWHkwR2pOQWZZNFdzdlRZSVAzVm9PLzMrekRpWGI2QWZW?=
 =?utf-8?B?dlo0OGRHQnI3STRQeDVKY3J0eE1Od3BsQWlGNFhIcm0xNzRsemRxYnB5eW54?=
 =?utf-8?B?WEtUemFtU3ZzSlJlWVI4YWQ3K2l0UzBxdFd4aUVYNTFXUmdlNTh3SVpmS3kz?=
 =?utf-8?B?dldpM1M5eXBBN0hkaCt4bmhuOWpnTnN3N2FSQTlqWDlabW93ZW02L2NCaFI5?=
 =?utf-8?B?MWZlMVpGN1ZkVU83aUhqYitsclpQNnBCak5PenFlc0lxOS95QndQUWcxSFY0?=
 =?utf-8?Q?1DAABw/r3UW4xFqYlr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb76c555-e300-4e6d-e307-08de5f6e88a7
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 19:42:27.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2GrU9mUtZsmW5IlwlVY5GhtiYvZqD53I19KUoF04tgngE/u7usT3g21TwJuphxR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999112
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69600-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 8D6D7B40F8
X-Rspamd-Action: no action

Hi Tony,

On 1/28/26 16:03, Luck, Tony wrote:
> On Wed, Jan 21, 2026 at 03:12:54PM -0600, Babu Moger wrote:
>> Introduce rdtgroup_plza_write() group which enables per group control of
>> PLZA through the resctrl filesystem and ensure that enabling or disabling
>> PLZA is propagated consistently across all CPUs belonging to the group.
>>
>> Enforce the capability checks, exclude default, pseudo-locked and CTRL_MON
>> groups with sub monitors. Also, ensure that only one group can have PLZA
>> enabled at a time.
>>
> ...
>
>> +static ssize_t rdtgroup_plza_write(struct kernfs_open_file *of, char *buf,
>> +				   size_t nbytes, loff_t off)
>> +{
>> +	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>> +	struct rdtgroup *rdtgrp, *prgrp;
>> +	int cpu, ret = 0;
>> +	bool enable;
> ...
>
>> +	/* Enable or disable PLZA state and update per CPU state if there is a change */
>> +	if (enable != rdtgrp->plza) {
>> +		resctrl_arch_plza_setup(r, rdtgrp->closid, rdtgrp->mon.rmid);
> What is this for? If I've just created a group with no tasks, and empty
> CPU mask ... it seems that this writes the MSR_IA32_PQR_PLZA_ASSOC on
> every CPU in every domain.
>
>> +		for_each_cpu(cpu, &rdtgrp->cpu_mask)
>> +			resctrl_arch_set_cpu_plza(cpu, rdtgrp->closid,
>> +						  rdtgrp->mon.rmid, enable);
>> +		rdtgrp->plza = enable;
>> +	}
>> +
>> +unlock:
>> +	rdtgroup_kn_unlock(of->kn);
>> +
>> +	return ret ?: nbytes;
>> +}
> It also appears that marking a task as PLZA is permanent. Moving it to
> another group doesn't unmark it. Is this intentional?
>
> # mkdir group1 group2 plza_group
> # echo 1 > plza_group/plza
> # echo $$ > group1/tasks
> # echo $$ > plza_group/tasks
>
> My shell is now in group1 and in the plza_group
> # grep $$ */tasks
> group1/tasks:4125
> plza_group/tasks:4125
>
> Move shell to group2
> # echo $$ > group2/tasks
> # grep $$ */tasks
> group2/tasks:4125
> plza_group/tasks:4125
>
> Succcess in moving to group2, but still in plza_group

You are moving the task from group1 to group2. This basically changes 
the association in

MSR_IA32_PQR_ASSOC register,  It does not change the PLZA association.

To change it:

a. You either remove task from plza group which triggers task update (tsk->plza = 0)
    
    echo >> /sys/fs/resctrl/plza_group/tasks

b. Or you can change the group as regular group.

   echo 0 > /sys/fs/resctrl/plza_group/plza


Thanks for the trying it out.

- Babu



