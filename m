Return-Path: <kvm+bounces-16779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 797078BD971
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 942481C21B2E
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 02:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9393A21101;
	Tue,  7 May 2024 02:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oK3D8Ott"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C6B23A0;
	Tue,  7 May 2024 02:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715049482; cv=fail; b=E8jz8wbqCnBY9wCk4x85XnUtcmi0QFQTo/pCT7dHDOHLDYqRmGmcrQSnFxWvemCAqmkbo96oKOGe/zfXRooO35ZR87tKhynaGCwcEqFPEEcjkBowM474v9HXPRSHYwmNkotV8NS3lOr+Dfpzlf8I2c8eIobTa4iZQ8X9T7Tim8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715049482; c=relaxed/simple;
	bh=e1t/6S+T9Esi7oYQojEkT8CRNmZlnTMu+J125mhU6nM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WTBvX/14skO7qehC3ZvsS1NB0pMSsuXdu19ZWxQbCDJFdjSbWnutmCbjUEIEraPdxG1pHl5FKvluD1MO+MzyMIF8fU8jsLeAxoNf7RicWGH9PoJCy/JSg2zKD/LHD8ASfektZoE21e/a8HrGKl3EUGfqq1Hrb7q5ncmNVwv09YQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oK3D8Ott; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715049481; x=1746585481;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e1t/6S+T9Esi7oYQojEkT8CRNmZlnTMu+J125mhU6nM=;
  b=oK3D8OttohY2OILrftc41VZrTWicSogeZrk0uA1K6luO0ZaFZrDq8USc
   z35xqFdprD15Ke8HZ9DUwMro7j8Pz6fRfXZIfSIyiZoy3vfPxpXded0/i
   PBimUriRGbs1ZBALZNPrQ6/4JeKb1dW8koZMZznoDWF+7FHjeK01eP7xP
   DrjkZ8UuxJ4tDf1328WGbwXVNR08ZivuLjFpbbDOndkh/yV7La59RPHN1
   im6hZgTLCHmaktB66KrwWpCcSf+izfUAGMecB7M4LrnpWXSoO5MsNu5jH
   mrWPpY15obE+CmYZQtst7/voTg6RGEkrvMUF3mluBlkBcs+7G3JKotjXP
   Q==;
X-CSE-ConnectionGUID: zWYgHhsGQC25LsEYEde2Vg==
X-CSE-MsgGUID: w5+B+2ffTVKbCrjmeECieA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10983044"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="10983044"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 19:38:00 -0700
X-CSE-ConnectionGUID: pKOyQ8ZXShiEIpGailCr1A==
X-CSE-MsgGUID: bdpB0eOmSLKaOlQx9sFsog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="59536719"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 19:38:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 19:37:59 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 19:37:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 19:37:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwrOb3X7iGWE1SEBQdI3SU36VfFsKQakkmsBuZjDU/RS8K6rTbLSD0ugnY7RKnxsqfdtSrGst4e938TuFNv9y8uYgFlmSzCiGYDw5jF3nplqMCeoooksKRcEumx4hOdDfOs9MoTe31Cvw6EJ0bPSgR8lp7ma23t+7eWWeEVLPmMoRboaJoNTDiAj7/uLzGik7dppMqkDm0SRdaDGuJr4eIYyWPLbzhlEuNzKsqd12hs3KigNboEl6SF5Z8ZmJAMiB+g9nK5HevLssOswZPPA4YYXJCE2uGvSAevYEwwdqxFk+Jq1LyPo0FrHu5axt+kLqxaugl6oK707Mk4mmjFn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+Iy9HdDI2BYPyZFa8WM62e1iwQ99rmTesYaON241ms=;
 b=X35Y6MOMM+JtcfVQtZ8QhYTWQ8icEL8qF3w72G5Pd96ucROAORrf9BIStrNC0YtHyCCqnvWZCmw9/roMmLHnfRYA9lFyiC6aiuBEBCv9Op8UPP8/7HsSKEkKvUNQdvxFuMBZXvtjWfYSax1av5WCvRcy/Swtq+S3SixOlUiKZL9jR+Wgr5Pf3+3cNZWJBiYV5zwXQYqkzv+sfdp4naMWkAucBwy0t7x44qYp4MGP3g3VToS6cQEuVvv6VjiuzR3BdKz0S6nnhyW8t08VPzwYZEgEpAqOJMwUbsamFgy4mKA/1Tj22knCdvaSKqyYPWegBHpr4/ckYOIdek9PEBvlPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.42; Tue, 7 May 2024 02:37:57 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Tue, 7 May 2024
 02:37:57 +0000
Message-ID: <0ec64962-393c-4b2d-9689-c0375d7346aa@intel.com>
Date: Tue, 7 May 2024 10:37:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-25-weijiang.yang@intel.com>
 <ZjLNEPwXwPFJ5HJ3@google.com>
 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
 <ZjkLVj01V4bM8z5c@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjkLVj01V4bM8z5c@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:4:197::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB6504:EE_
X-MS-Office365-Filtering-Correlation-Id: d80f7212-478c-4d6e-f8b5-08dc6e3eb40a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YjFyREhGazltK05YQkdEWlQ4WFIxVU9EenV5NjR0Q0Y4NFFFdms3S0lmUVhr?=
 =?utf-8?B?ckswTlFmdlVWb0lTTkNRU29sa1hJNmZmbTQ0b2Iza2w4M2dDYnJqMDNVSU1L?=
 =?utf-8?B?WHkzNWVaVktBRm14SEhrc2F3WDI0QS9tZVpudnMxUnFkd0RKVGY4eWh6cDFh?=
 =?utf-8?B?dDVmd1MwcnBYNnd4MEg1Q0Z5V2Qxb3d4QnhmTERRVWhWMUlJMGp2WW5LMm1k?=
 =?utf-8?B?eWJxOFNCdzJPT0JnSDg1b0luS1NmQ3hyaUx5WWhEQnhwVzZsVVZ3Z3dpbWlo?=
 =?utf-8?B?MklWMGFPbW04R2xoU0RQTnBadjZoblVhSDFoWjlkcWZaeVRId04zZFkxZjUr?=
 =?utf-8?B?UkdmSGp3MjVDTHBrLzFzcjMwc0lXV00xdk1DQTgwK1NJR1ZYeU5CTStmYW05?=
 =?utf-8?B?VitIQWFQNUtGMkxjU2dmMlZ0cExxUGpvNWM5SkVSNWZCTU5aT0d6UktsaXNm?=
 =?utf-8?B?V0EwUXdTQmQ1N3lmeTJtOEVSTmZTQllXSElJbHVZbWtudzJrTkhkT3h2dENK?=
 =?utf-8?B?YzV6eldMKzByYW9pNnZXcE1hRUhiTUh4TVZtQzFrSXlMM2cxQzhOSm9mNy8y?=
 =?utf-8?B?VitTNXpJYWNIRkFQY1Z0S1RlcG1xNUZpTmoyVGFUeGxMUXNuWnZ4YTNtanpL?=
 =?utf-8?B?M3htZ1dXcWNwT1R0ZEZiSVh2eWRGRzNVT2tKOFNGLzd1eXo5UjlNd3BnVm0x?=
 =?utf-8?B?ZEVTWlRQZEl1K1d4YlNmVUtpRnFDSkptSXlQVEdxd3hrOGdiNitvMU9Zck1Q?=
 =?utf-8?B?NlNuUlhEQ1UwcTFpU3hXZHV1WkxFSFRpVnFDWmtpSFdkREtYRjdjY3NjNDhY?=
 =?utf-8?B?M1N1Q2VnRWJyUFA3bFJ2Q2RnZGdXRFduTkJ2RkRTdG1neXQxQnQxdzNYSXpG?=
 =?utf-8?B?OFlkTXNTYU5Zb1RtZE5YYlUzeDREdndUNDhKWTlkNkFzNkJLb1UwNGs1Q1gy?=
 =?utf-8?B?WjV2cENnNkx5RnltZ2IxS0RnVmxHTjZFbG9LcU5YU3orSUpDNlpUSkt0UWx5?=
 =?utf-8?B?Y1Y4V3VhTitQcDh3eG5qa050cmZid2ZoR280ME9pZ0cySWZ6ZllFYm1GcUVP?=
 =?utf-8?B?Vk5mK2dGSzVlT044bVpkT0ZPdTFpVE5La0FQY1dCZVBQbDFJdVVrZGdhVjJv?=
 =?utf-8?B?OGNKNE1KRVhlalhobC9WRGg4ZXhaeXdhKzFZSC9LN21EenRaMms2aGR2b3dT?=
 =?utf-8?B?eVBQVWo3cUdpUisrUTMxL1F0ZkhaTGJvZFNIbmVDY3YzczVxcG5yZENvaXI0?=
 =?utf-8?B?SjNTclYvRE1oMURNUXlENGJDWFZYQ2xKUkRDb1FkSm9RWDZRY3JrWmF2VDRj?=
 =?utf-8?B?NHBvMUZwcmZRcGZvRVo4anR3UUZRNkZObE04MWhqd3lNb0dZMDVDSisvUXdt?=
 =?utf-8?B?cHJQRnNWcnNDTkFZTThPRE1QTVZ0d240WTZyNTNyeldRbnpPZC9IRTl4RFpJ?=
 =?utf-8?B?UEYxK2V1QjlMZlk5WG1xSG9BMHF4d2tTWTB1NUQxVE01MHZTMy9aWG5ZWUI5?=
 =?utf-8?B?Z3kwcnBSUTRjNGZLbnZVMU1MeldwaFZ5d1lmenE0bFgvd3B1a014Tm9ONnQ3?=
 =?utf-8?B?b3QxQTZZWTlkWElEQTZBa0RqTHh5dUJvREIwRGFGWlRDWFRJeTdUZ2NTWnNN?=
 =?utf-8?B?YlcweDZuK3JacGd0bWxRTVFpQ1YzeFVnV1BHbUI2czc1NERLMzEwVmpNWTQy?=
 =?utf-8?B?MHozUk5YM0hwcjhxMDM4SVVuYWZNeEVCbzh2VSs1eGI2anNLMmNDVHRRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnFvM3llM0ZhVndjUUVpS20zbDEvM3NDV0xUamp0OFNKT3QweFc2WHMwSTNK?=
 =?utf-8?B?MnZBVElRQmJSRzdLb055ZHBtWTlZb3pxY0hmK05wblUzbUJWNkF4YVg2SmRB?=
 =?utf-8?B?MW9hbVI0Y2FvYXFGV0NPeXBoZEFCTWhlUzlQZEhXNDl2V0hkNmFXc09VWW1D?=
 =?utf-8?B?cEdjNTl2NVpiZWt3WHQ1V1BlOHVKWXgzMG4yUVhVU3hDbVRZb1VEcU14SWgz?=
 =?utf-8?B?Mk50T3ZzV2FGNGQxTGdDMVVzNE11bEhWNHNDRmNZVnNnb0xlMnNKdDB2VitO?=
 =?utf-8?B?NEl4WFh2MnZOVlRDdkIvZFJiSXg5SDRndmhvVk1VejVETFQxUUxEZ2U5c1NI?=
 =?utf-8?B?WGo3aWd1bG9qY0lkalpFakxCeTFkZmJKTzZ1bHlrS3hIZE9KczltSTlFWmM0?=
 =?utf-8?B?VHYxekl3SllrTUZRZTJKdjBUeDVQMjhhbTVXTStGbmNyL3ZZZ0tLaWxPTGdy?=
 =?utf-8?B?LzYxZ0haR2JwY0ExS2p0MWV2Nnp4M28xQjY4YUNyaCtxM0N6OG1qSFYxUGpm?=
 =?utf-8?B?MW5MUHdkbEp2aWNzMGpacVhZbk1xbDFPR09NVWlyRzFITXdTcTNieFZ2Y3Uv?=
 =?utf-8?B?ZVVJWElvZ01QTmRQQitmU2s4SWJLRkZtUTJybElCMlJkV0U4UVA5S2xJbE02?=
 =?utf-8?B?S1hmVnNYakdEZlRlMVVJOWlsUmdVeDVwaVJxMVFUVUxnaXprYlVOVHhQYnNn?=
 =?utf-8?B?eGxBZXFhK0N0Y2J4Q1U3dkRFd0ZIL3N3MGFidVpZeTA5RTZjVUdYb1IwTmRE?=
 =?utf-8?B?V3c2c2NPeEFuS2VWU2MwVjFDbFBXaDJrcUJyb1ZUMEpodnYvOVkvVWo5MG5H?=
 =?utf-8?B?SUhXbjJQTEF6TmpvcWRJSFhnQk1hN0x0bnZUT1NubHI3TSsrZlVrN0ZHV0ll?=
 =?utf-8?B?MkRNeStxa2lpK2pETUNYdk13dFRKdnI5WnRkTG9rbWdaTFZQaWNObUJuSUhz?=
 =?utf-8?B?azZMN3JaN0JMSXFDbm15T2JTU0RGUnJXSDBKK20yeVlBaDZjQTJKUUdEOHUr?=
 =?utf-8?B?cTZoM1pkVzJFd1M2dnNNZDNSNnVlVEs4MVpzZnpvSzdyb3JjUHllWE1KYXFz?=
 =?utf-8?B?dVY2andtbGtPUmFHOUgyTG5vdlNFbzN2Qk1HUGE5b1dFTXUwWnZnekNqS1pa?=
 =?utf-8?B?Ynl5MUhzKzJCT21rRmJaMmZUUzZXbE5QaFVZMmU5d3VrYmszZUpoWXB4Z2ND?=
 =?utf-8?B?eVBhOTF0bUdvbVRzYkdhK1c2UFUxMFFadTV4KytORkFpakY1VGY0akVwamd3?=
 =?utf-8?B?c2M3R1FNSkFyOVFCOEl2QnFpT0luVXk4L3dQekt5RS9vWlQraXBGOUhwd0th?=
 =?utf-8?B?OE1MMnI3ZnhPNHBwbFBpTUtwS0M3Sm1ZRXNmcGZTRENtekpYbHRPYVFEV2wx?=
 =?utf-8?B?NXlaaE54U3UxSXVNVWFvS01rUHp6alhwcWoya0pNQ0oveXZZMnIxY2Q2SUZF?=
 =?utf-8?B?QVRyV3QyM1l2cVF4TnI2T0FuelphMHdKTjBMN2h3QW5RUzhFRHBiVVB6bWxr?=
 =?utf-8?B?MjhRa0N4N29ldzdndGkxajNBSmplSkl2TGIwbXdTOU44NURqODc2UG9GaVAw?=
 =?utf-8?B?SGh4UGJRaldBejZqbFJNbXdENTJ6bjMyWDJ4cVg0ck44ZHYrWW4vRXdrbzly?=
 =?utf-8?B?azQxalV6NjhBWmVicHRlRWtHZ1hFa0p0bVJoT20vYWNLVUR0dDFzWlVSQjFx?=
 =?utf-8?B?MnI0clBsdDNOZDd0aGdMYlhoMTdsZHVXQkdYZ0kxWmR5NCt2MitRb1ppOUY5?=
 =?utf-8?B?VG5lS2ZOa1hkVHZzaFBxb25NQjkyV2loMkJqZU5ZK2ovRWlwclNidTU4NWdo?=
 =?utf-8?B?azBTMHhBUXRQQjZxWjVoVjI2Z1NLR1NlOXpabFBGakoyanBBUjY4WmdjcWw4?=
 =?utf-8?B?dG1zcXZROHFkMEZOK0svRXZtNVF0ZVppNFV2R2V0eFBrVVZjSXVSYk9vQTFu?=
 =?utf-8?B?a3RVSUF2TVRPaUc5QlArck9kelpJcHo5cWRNalJ1UEhJRWk1MDd5Vk5KeHdQ?=
 =?utf-8?B?TzQ1MVpuZmFKQzZ3UjFNR3VWbG43bVRqdW5oYmc5Q2dmcjY1TWpVK1RMMG05?=
 =?utf-8?B?OFg1SmtCT1FDZGkzbHlMd3RhdktDOTBndWQvUWp3U1drK0hTM2VqTGtSL2FV?=
 =?utf-8?B?ei9qWnZpeXVxQnR6cFNjSDJEbUlpU2lWMWZxSzN1djRINU9YT2NPakxtVHlP?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d80f7212-478c-4d6e-f8b5-08dc6e3eb40a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 02:37:57.2156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xeo9QczOdjgepbu7K1sCBKOvlEuXzgVEvOT+YagNhpjz+JCruo1nEjouY/YTK+FQwzVj9gCUDpk4K+qEh8WMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
X-OriginatorOrg: intel.com

On 5/7/2024 12:54 AM, Sean Christopherson wrote:
> On Mon, May 06, 2024, Weijiang Yang wrote:
>> On 5/2/2024 7:15 AM, Sean Christopherson wrote:
>>> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>>>> @@ -696,6 +697,20 @@ void kvm_set_cpu_caps(void)
>>>>    		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>>>>    	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>>>>    		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
>>>> +	/*
>>>> +	 * Don't use boot_cpu_has() to check availability of IBT because the
>>>> +	 * feature bit is cleared in boot_cpu_data when ibt=off is applied
>>>> +	 * in host cmdline.
>>> I'm not convinced this is a good reason to diverge from the host kernel.  E.g.
>>> PCID and many other features honor the host setup, I don't see what makes IBT
>>> special.
>> This is mostly based on our user experience and the hypothesis for cloud
>> computing: When we evolve host kernels, we constantly encounter issues when
>> kernel IBT is on, so we have to disable kernel IBT by adding ibt=off. But we
>> need to test the CET features in VM, if we just simply refer to host boot
>> cpuid data, then IBT cannot be enabled in VM which makes CET features
>> incomplete in guest.
>>
>> I guess in cloud computing, it could run into similar dilemma. In this case,
>> the tenant cannot benefit the feature just because of host SW problem.
> Hmm, but such issues should be found before deploying a kernel to production.
>
> The one scenario that comes to mind where I can see someone wanting to disable
> IBT would be running a out-of-tree and/or third party module.

Yes, the developers may neglect IBT violations in modules/kernel components and deploy
them, in this case, host side has to either fix the issues or disable IBT.

>
>> I know currently KVM except LA57 always honors host feature configurations,
>> but in CET case, there could be divergence wrt honoring host configuration as
>> long as there's no quirk for the feature.
>>
>> But I think the issue is still open for discussion...
> I'm not totally opposed to the idea.
>
> Somewhat off-topic, the existing LA57 code upon which the IBT check is based is
> flawed, as it doesn't account for the max supported CPUID leaf.  On Intel CPUs,
> that could result in a false positive due CPUID (stupidly) returning the value
> of the last implemented CPUID leaf, no zeros.  In practice, it doesn't cause
> problems because CPUID.0x7 has been supported since forever, but it's still a
> bug.
>
> Hmm, actually, __kvm_cpu_cap_mask() has the exact same bug.  And that's much less
> theoretical, e.g. kvm_cpu_cap_init_kvm_defined() in particular is likely to cause
> problems at some point.
>
> And I really don't like that KVM open codes calls to cpuid_<reg>() for these
> "raw" features.  One option would be to and helpers to change this:
>
> 	if (cpuid_edx(7) & F(IBT))
> 		kvm_cpu_cap_set(X86_FEATURE_IBT);
>
> to this:
>
> 	if (raw_cpuid_has(X86_FEATURE_IBT))
> 		kvm_cpu_cap_set(X86_FEATURE_IBT);
>
> but I think we can do better, and harden the CPUID code in the process.  If we
> do kvm_cpu_cap_set() _before_ kvm_cpu_cap_mask(), then incorporating the raw host
> CPUID will happen automagically, as __kvm_cpu_cap_mask() will clear bits that
> aren't in host CPUID.
>
> The most obvious approach would be to simply call kvm_cpu_cap_set() before
> kvm_cpu_cap_mask(), but that's more than a bit confusing, and would open the door
> for potential bugs due to calling kvm_cpu_cap_set() after kvm_cpu_cap_mask().
> And detecting such bugs would be difficult, because there are features that KVM
> fully emulates, i.e. _must_ be stuffed after kvm_cpu_cap_mask().
>
> Instead of calling kvm_cpu_cap_set() directly, we can take advantage of the fact
> that the F() maskes are fed into kvm_cpu_cap_mask(), i.e. are naturally processed
> before the corresponding kvm_cpu_cap_mask().
>
> If we add an array to track which capabilities have been initialized, then F()
> can WARN on improper usage.  That would allow detecting bad "raw" usage, *and*
> would detect (some) scenarios where a F() is fed into the wrong leaf, e.g. if
> we added F(LA57) to CPUID_7_EDX instead of CPUID_7_ECX.
>
> #define F(name)								\
> ({									\
> 	u32 __leaf = __feature_leaf(X86_FEATURE_##name);		\
> 									\
> 	BUILD_BUG_ON(__leaf >= ARRAY_SIZE(kvm_cpu_cap_initialized));	\
> 	WARN_ON_ONCE(kvm_cpu_cap_initialized[__leaf]);			\
> 									\
> 	feature_bit(name);						\
> })
>
> /*
>   * Raw Feature - For features that KVM supports based purely on raw host CPUID,
>   * i.e. that KVM virtualizes even if the host kernel doesn't use the feature.
>   * Simply force set the feature in KVM's capabilities, raw CPUID support will
>   * be factored in by kvm_cpu_cap_mask().
>   */
> #define RAW_F(name)						\
> ({								\
> 	kvm_cpu_cap_set(X86_FEATURE_##name);			\
> 	F(name);						\
> })
>
> Assuming testing doesn't poke a hole in my idea, I'll post a small series.

Fancy enough! But I like the idea :-)

>


