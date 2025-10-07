Return-Path: <kvm+bounces-59555-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D62BBFEFE
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 03:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 244A234C666
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 01:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F67C1F3B96;
	Tue,  7 Oct 2025 01:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EFHdzskn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA721DF254;
	Tue,  7 Oct 2025 01:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759800208; cv=fail; b=VljbQFCGM2l+chIEarJ9lwCTZ70q5RkzhNAwYWkodWqz5Rhl4yetVGaZ0lr8/7i+bjj0ufSWzwsGY+TIgu4X/w6bCTfG/pol2DGJ1nYtG+bgg5Mq4yeaoZFc5GmzFnUqJC/bm5ZMkrtus2kewTF3IqRVLu7Pcr22qS1T+rcjEv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759800208; c=relaxed/simple;
	bh=9UmvSUZZ7vN7aOseFgWa6db7JoESY7085INIaPCjLLw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cxM8Ix/Og8SVBXCYHq4hSNI2SQuEoV1G/lgKCA+oi3ELhuWqtnaSJ70r8/YRpfe5rybd1QxyOitJW9xd9trH+oKuZ0KHwjcykqjfp8RokgHORWvNNbq+XiIqC9gIQfqWrw54ieTBUSDhyBZghT6M+6T7x/DVxHa7nM8p8fR9r4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EFHdzskn; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759800207; x=1791336207;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9UmvSUZZ7vN7aOseFgWa6db7JoESY7085INIaPCjLLw=;
  b=EFHdzsknnvmaW+CQIOeHh4EA4HwxmcRqF/8DHla4y2AL/3WdsFy3mdFO
   7kp39eq+ItkCmWWjlhuu53kHEyuMTAmNBwe63AqSejjraO+a3X4HgdWeY
   IX20l84Ne9tjm8mlGbY0kyAqLYtn+KLPD7PZ1pTPCwLK2E3SjuGvfyBKU
   9BXbWcl8H7SgWfitzElJDjXj9gAgTNzjOqPFWZ9LnJXOZTfpQEsydrMC5
   cUX9AJeYwqODIkKPutGz6eFY7yZBrwl/2Ais0X+/FgkEezE16/II8fKOM
   3xvgehj54D7xeJc+y0TgfHuCNy/947etAvK4cU/iKUF5r3xANpoZSeuuw
   A==;
X-CSE-ConnectionGUID: aJU+begJRMyXWAHSPwgicw==
X-CSE-MsgGUID: Mzw0M3bCQA6twqd0DvYEhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="49535867"
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="49535867"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 18:23:26 -0700
X-CSE-ConnectionGUID: MnSFZu3JQpmNhFG9JA4MdA==
X-CSE-MsgGUID: LRwpZ5vtQkaUw1MUb4wY8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,321,1751266800"; 
   d="scan'208";a="217105996"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 18:23:26 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 18:23:25 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 18:23:25 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.4) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 18:23:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g0hNXWCKjJdkFafWygkJlPsS6Yd1ma37E808ERcof/mhyiYSlwtNjmzEVPZrxlUllMLRAyAR/WhZbQ8QbTzDtZ0PZldJxPhqxUPDmfNt3xon5MgJSc7VJ4Ye6Rip+rfX4O535SaQytfgzENH67tk+Mx54t4RGe3RM4uh/sJc3nrfOMzu3k6LUUc7c95PKEb9a6aLys5d5oknw0zWJ07qqukawh6N+XadivBxCxBRSSfL0akEUSzsSdOcw19CuF1wV9b0B3Rerw85VC1ZbSVhJNW8AaI0MIgWfKcqIGe/Lsk2XWxh/jfu2KU6jmLtxQFgfHNhhT5MEwpadeaEBMb0cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RiOfhTz5DZ6QlZkrdsprVH4siipCs6lSvE2K5JMo84E=;
 b=T6Haewlkt5opphpg77kI1mTh9i0gQMTSw7OJTkRXZTksiP0Pix8BBcq+6Tpf4+jK5SaK7PXFGIuSfxmMFx8sDClqlLcH6LtoE1+7uFSrD7p9aaOmUQcOZQig/92zpC8qg2SXAqjcNUvps67VgmHTgQ2W1332nL2hnnOhKFf0MiDGbMM6xE+kSUBo9OiKIr2wKOICvE6DKOKu8NxbJVlQQkysV/69xytFkutHmt8cBz2uV4/Fh9pTeGdqDF1p+8mczuglMixmnifQ0OD4hxKkfNywYXJTha/XgyeYqJDpuO7osk8H6YwU2O171XqPHSPL+H1p+XaKCbbfWe+gvfKnFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPF7C7D8332C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 7 Oct
 2025 01:23:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 01:23:16 +0000
Message-ID: <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
Date: Mon, 6 Oct 2025 18:23:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: <babu.moger@amd.com>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <dave.hansen@linux.intel.com>, <bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0015.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPF7C7D8332C:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d744cf5-5b8c-4f24-bb21-08de05401778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UTN3N21wVHlFcVdCZ0lveWFUZHo4Y2FOR2JmMCtqTHBRYWpMMTFpdm5ucXR2?=
 =?utf-8?B?b0I3V212RjBtK3JqYk8zMmVMeGtlZDNBUkxCZnBueUp4S2MvWnAza1lDSWlN?=
 =?utf-8?B?eU5JWlBBVVA3REJFak5DYSt1dFFFMCtBUmdpRkoxMW1jMTUvWGhyMG92NUIz?=
 =?utf-8?B?cUgyRHl1YkNNNno3eU9JUkIrY0U3RHpoTzRPelJ5d0x5SENpZWFrTC96SFo4?=
 =?utf-8?B?UEZEbDJKZzZaSzM5dnBGRE9CT0h0blREV2VBcEF2VmRBVGF3a0k5Y3Y1ZlJL?=
 =?utf-8?B?UFM0SGcvUFVOZzFKYmZZblRwZkFCUktqWmRoL0ZlS2ZhRTc2RWNoaS8vd3lv?=
 =?utf-8?B?OS94NlJDeWplaFpYNFZzWGtYTmlpV252ZG1KSXovK0FZbElKd04xQWhaQzAy?=
 =?utf-8?B?N3MxQWN1T294UG9iR2hnYXp2dWpTY3dJZmlBSUp0TkF3czFKZHBKRVhybjV1?=
 =?utf-8?B?TU5XS1cwVmEyL3FIZzFPWDlrMjZmV0NKbWlmUFd1NjBPQ3JVNzlYMUdjcnlx?=
 =?utf-8?B?dDB3YmJsSFpSWFVXMEh5TFQzc2hucDd2bjRUUWNmQlNkdytwZG9iYmsyaWFN?=
 =?utf-8?B?bTd3TTVVa0creXVVdEtiUzZpYUZTL2Q2ZVBYZjZNV3Fvd3VreW1NUGcyVFpw?=
 =?utf-8?B?RGRLMkc2VzF1MG4xNnFPMW54aHZiNHdpVkQ2cTZlWUFwS0NWWkFlNXhuNFZB?=
 =?utf-8?B?ckJ5S3ZlY0k3Z3U2VXRoTmpsY3pSck9maWZQdEFTek4za0xJNGJVTEJaT1dD?=
 =?utf-8?B?Uk95TFZ4TWc2Q0dsU1lpQlFkaVJRdm5nUnFEV0Frdk4rWGYybmtGelI3QnNn?=
 =?utf-8?B?cE9DbWIwdFVHS2N0SEIvYkwwNTdlVW42bytCVVFNcXFDUDkzUXJsdHd1ZFZJ?=
 =?utf-8?B?MDRoNFZTV0pQMFZReFpNckFUbGZqRmVMcUlnNzBxbHBXMFIwYU5qZDc2ekJ3?=
 =?utf-8?B?UnFDQ0M5NUE3b3gwZGROWmZWREdmUGozWnlGVE1HeXFyTHNxdk5xT005UzZw?=
 =?utf-8?B?Ny9WWTk4alR0ZFYxMEMzbm1DNXdkdlJRQ1Byekt1aTJiUlpOQnpKZWVUT3Rz?=
 =?utf-8?B?cDBJUFFvZ0NJSXpYQUVZTWdXSmg2TExYOTM0bCtQTjB6V25xbFVJaUFrUEpx?=
 =?utf-8?B?bU13cktCbUFkM0o0V1QvOWVQdkkzQ1VyV1BqMjNiSGNUWDBLa2lMeFFCOHhO?=
 =?utf-8?B?TU9tQ2VrZ0NLdGxpczhhZk9OMjVBdkZFUCtvLzVvZ204ejdKVDFOYlFHbTdx?=
 =?utf-8?B?Ly9BczZWRFVXRlNJejRkYnlCcTUweEk0L1pTbFBUNzVQT1BLWHdIcW4xb2VO?=
 =?utf-8?B?VHpNRHQ4U1l2TnQ4eHpQT1VtUVRrcjIvTUxzY3V3LzFYc2hsUnlCY3ZzQ1ZF?=
 =?utf-8?B?QWN0U29ibzNjNkIzV200NkI2WUsyNzFmS2xTdG9KVUxEU2wxVk9ZL3hkaWdT?=
 =?utf-8?B?SHJySUt6SjVoeVBQY3lELzN5czEyaVl3eFA0d0MyV3dCNjVueHpPM09XbldZ?=
 =?utf-8?B?dU9OYmNzUkpGZStHaVp0NUtvM043Y3hCVy9aamFGakJNeTRTTUJZNVdiSGJJ?=
 =?utf-8?B?VmFkcnVEQ2RwTThxVGVhNWlSTEwzN3daajdEYy91UXVrQ1VjUjdNNm1kWkp6?=
 =?utf-8?B?WnVBV2JmSGhjNEtqUjliZW51TFVqaWlwTXpBNzJRZEVkMGMvNXdmVkxOdVN1?=
 =?utf-8?B?b215NmwxNndsTXBDODh5eVByb0Q5c2U4amlMbk92SjRtUC9Ua2hUMjBxcjZ6?=
 =?utf-8?B?YkxPVTk2amVyRmdseUxXR2xXcEtLbDhkWE9vRlZTeGpDOGkyZnRmSVdLTTVD?=
 =?utf-8?B?b041OTlKKzJPYTVsOVZOeVZFQUt5NHJEcmVMZHZiUmRQVmdRNlE4TEloOGh2?=
 =?utf-8?B?OHNjWVovTUI3MDhJK3hvLytwOFBxMm0yYTVXS29iZ2tmdDljaFEzREhqYmhP?=
 =?utf-8?Q?43Usu4wuvqMvo5thNSIBkDxfnFVD4SV2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHZCOVU4aXNXaWc4VVF5OFFpY0RMTW5Ea2RlSjBFN01KMGo1UDYyTDNuTi9w?=
 =?utf-8?B?TXh5UldEUFlJQ0VVVytEZ1cvL1YwY1QwUUxPV2ROZGxZZFozSVIvOHVwVHgr?=
 =?utf-8?B?bzdGN1pQOGxBdlplTDR3akh3UFBDY0RGTnhLWm41ZmoxSXl0RW9VUVF0dWxR?=
 =?utf-8?B?TXZOZlJpOE5tUTJGYStOZ2Y1TGtya2RESjVFdlJibW0zanBGQ08zV0VsMDFS?=
 =?utf-8?B?RWxJUjZmZ3FQMFBxWGJ2VGFnRmVmclk5QytnbVYreGxyRS9wVC9qRDBicGRL?=
 =?utf-8?B?N2c1RkRWUnZhZXpCM2xsRDMwZWR5Z1JmNWxkdkZqdzMvenhqSEVDNUdFTjRT?=
 =?utf-8?B?R2NMalAxaHpEbGhsMjhqVGpta1lhY3N5RUZsNHcxZHdDNEo0RGVvTDRCOWpl?=
 =?utf-8?B?d3dsSCsraGtxNExmZDdvOFFXK2lkdW1zL0tXaXllQ0Uwd08ydVhTNUI2RHg2?=
 =?utf-8?B?bFZrQWdWVFlBd0xCWURIUnZWa21HWTBLM1R4ZU1nM0UxUVFKc3NSMG51Wmc0?=
 =?utf-8?B?eVo2dGpCSDhrS0lTU3JEeEVyQnFHbldiekd4a2VlRlNYTjMvM21IQUh3NTc5?=
 =?utf-8?B?bFBvWGpRUjJpaDhOcGt3a3hwQnBlNlBzYXFKcXpSN3JuWndXaDFXek5hdDNH?=
 =?utf-8?B?R0V1RTIyaGZ5ckgvMTRmT1BkQjF5Z0RIZGpTeG5LTHpIdkxObGJDVTZqd2l5?=
 =?utf-8?B?STVxYUN0Q1FuVU1DSThiTTdaZDJtcU5Sclh0NXN3cngzRjR3cjVSb2pVWTIr?=
 =?utf-8?B?VUZvVmJFRk5ZcnVFSlQ5RVhNUlFLcG1HT3h2SDQrUjhJcTJUNUdacUlxeGpa?=
 =?utf-8?B?R1h1ay85MDZZWDhBdkMxZWZYSzltbTlRTXVVazNGUXJHaEV2VkNJVUJhc1d0?=
 =?utf-8?B?eHhHTURRR2xzTmhuVVVVMFdIOHdNRHZ0M2hWcmVyS2lERmlDMFlkRERGU0kr?=
 =?utf-8?B?SmpMN0VTTWFPcDRwdHJSL1ZZQytKK0FqY3NsakQ0TFYzNkhDM1VlWTVTQTcx?=
 =?utf-8?B?S3NUOTY5MUdxbVNYWVdrWGs5MU5QcW5lRmQ5d3psV25QSUlvZXJWNHB6Rysz?=
 =?utf-8?B?RGtsYnh3NE1GNTdOamhZRGNmL1VIcW1SdHF0RXYzUnYxUTZkc1liRWFlZ25T?=
 =?utf-8?B?UjF1QjhiZC9mK2NJYS9SOFZQVWUvWjBGdmpzOXFmYkliM2VVR21qYXZDS0Vm?=
 =?utf-8?B?Z0lyQTdNMzNJeFBDOENKanJGTGlWVXpFeEVKWDQvQkhha3I3d1pCVUpqWXJs?=
 =?utf-8?B?ZVl4anNLcmVEMFFVZWY2UVY2Nm0zWUxSaktheTBDbUp3c3ZRb0l1VnpUYlJq?=
 =?utf-8?B?aFVSaFRuYSsxaE16MkxHUjZ4K2gzd2RyMXZrRERzTGJ0MkZUbnBON0M2anJW?=
 =?utf-8?B?ejF1UHprdUhkcEIxYnc4bVQySlpubmtsZ3ZLWnNNeXdEQytBYkpTVVFldkJ5?=
 =?utf-8?B?Z2ZQWldMeFM5M1k4ZWR6RUJLVUg5V2dETWpLbGZ6cVdjdCtGbmRMejJoTFla?=
 =?utf-8?B?SGVYa2RMMWNlaG5lS2EwNW5ScWsyVU00cXZRMFo3bnVhNlgzbSs4VVhSZ1Zs?=
 =?utf-8?B?SCtpTXk2Y3ArN3VrTklZb1liRmh6SFZqbjdMZ2dTQ1lkcEZNM2hQM2FxWHlY?=
 =?utf-8?B?dFhNWHl5ZUNnQThvSE90MlA5ajhpazlHY1R6YjlVYjNlS3N5RHBMZjdKZERi?=
 =?utf-8?B?TkpTR3FQL1RkaENGWThvS0FzT1AwdElQYytKeDYrT29FMzhMTnJQM2YzRTds?=
 =?utf-8?B?M2s1WjZhVEcrKy8zaG5ObkNxZmlwM1BnMXhyeUxvSDNRbHpIdjc1bWdNSGx0?=
 =?utf-8?B?bEIxL3AyRFFnRkZid0duOVRZVU1UMnFWcWYwZmRqaGRNeVEvU3NqbmtxZlph?=
 =?utf-8?B?OFRvTWdQYVE3NkQxY25Cbi8vcGljOGZSS1Q4TW02SElobWpQQ0hqdWx2c2gx?=
 =?utf-8?B?b0FkK0JheFFwMTd1b2Zia3ZrNmpmR3BmTm1kek1lWXk1cWI4R0hWYzdqcUJu?=
 =?utf-8?B?c1lzeFFjMFpOVmRmdTZkSVZyVEQ3bVZIUTVJZUpBeWduMEF5NEo5YmVvL1ls?=
 =?utf-8?B?TFQ4K2ZwSUwvMjlNTlNrdzBneU1Rby83TW1paXFHdFEwZDI4b1hxRHNub1A3?=
 =?utf-8?B?QmF1UnQ4Tlg4TVJIaitBMm1GdnMzd1NiU0NaRWcwWlE3OGlRd05jNFhFQ01O?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d744cf5-5b8c-4f24-bb21-08de05401778
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 01:23:16.4393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRmwQDNOdYXSuAW/3vj+3mUyDAKJy6ZT8fUROFzQp9pyRG3mlJKVR1EQiYTLZ3yJHnD+f2NAUhUDhDOEs5ypa1qsHIQTD6kQN6gzcuyl+0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF7C7D8332C
X-OriginatorOrg: intel.com

Hi Babu,

On 10/6/25 1:38 PM, Moger, Babu wrote:
> Hi Reinette,
> 
> On 10/6/25 12:56, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 9/30/25 1:26 PM, Babu Moger wrote:
>>> resctrl features can be enabled or disabled using boot-time kernel
>>> parameters. To turn off the memory bandwidth events (mbmtotal and
>>> mbmlocal), users need to pass the following parameter to the kernel:
>>> "rdt=!mbmtotal,!mbmlocal".
>>
>> ah, indeed ... although, the intention behind the mbmtotal and mbmlocal kernel
>> parameters was to connect them to the actual hardware features identified
>> by X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL respectively.
>>
>>
>>> Found that memory bandwidth events (mbmtotal and mbmlocal) cannot be
>>> disabled when mbm_event mode is enabled. resctrl_mon_resource_init()
>>> unconditionally enables these events without checking if the underlying
>>> hardware supports them.
>>
>> Technically this is correct since if hardware supports ABMC then the
>> hardware is no longer required to support X86_FEATURE_CQM_MBM_TOTAL and
>> X86_FEATURE_CQM_MBM_LOCAL in order to provide mbm_total_bytes
>> and mbm_local_bytes. 
>>
>> I can see how this may be confusing to user space though ...
>>
>>>
>>> Remove the unconditional enablement of MBM features in
>>> resctrl_mon_resource_init() to fix the problem. The hardware support
>>> verification is already done in get_rdt_mon_resources().
>>
>> I believe by "hardware support" you mean hardware support for 
>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL. Wouldn't a fix like
>> this then require any system that supports ABMC to also support
>> X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL to be able to 
>> support mbm_total_bytes and mbm_local_bytes?
> 
> Yes. That is correct. Right now, ABMC and X86_FEATURE_CQM_MBM_TOTAL/
> X86_FEATURE_CQM_MBM_LOCAL are kind of tightly coupled. We have not clearly
> separated the that.

Are you speaking from resctrl side since from what I understand these are
independent features from the hardware side?

>> This problem seems to be similar to the one solved by [1] since
>> by supporting ABMC there is no "hardware does not support mbmtotal/mbmlocal"
>> but instead there only needs to be a check if the feature has been disabled
>> by command line. That is, add a rdt_is_feature_enabled() check to the
>> existing "!resctrl_is_mon_event_enabled()" check?
> 
> Enable or disable needs to be done at get_rdt_mon_resources(). It needs to
> be done early in  the initialization before calling domain_add_cpu() where
> event data structures (mbm_states aarch_mbm_states) are allocated.

Good point. My mistake to suggest the event should be enabled by
resctrl fs.

> 
>>
>> But wait ... I think there may be a bigger problem when considering systems
>> that support ABMC but not X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL.
>> Shouldn't resctrl prevent such a system from switching to "default" 
>> mbm_assign_mode? Otherwise resctrl will happily let such a system switch
>> to default mode and when user attempts to read an event file resctrl will
>> attempt to read it via MSRs that are not supported.
>> Looks like ABMC may need something similar to CONFIG_RESCTRL_ASSIGN_FIXED
>> to handle this case in show() while preventing user space from switching to
>> "default" mode on write()?
> 
> This may not be an issue right now. When X86_FEATURE_CQM_MBM_TOTAL and
> X86_FEATURE_CQM_MBM_LOCAL are not supported then mon_data files of these
> events are not created.

By "right now" I assume you mean the current implementation? I think your statement
assumes that no CPUs come or go after resctrl_mon_resource_init() enables the MBM events?
Current implementation will enable MBM events if ABMC is supported. When the
first CPU of a domain comes online after that then resctrl will create the mon_data
files. These files will remain if a user then switches to default mode and if
the user then attempts to read one of these counters then I expect problems.

Reinette

