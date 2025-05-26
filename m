Return-Path: <kvm+bounces-47697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9711AC3CCA
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:29:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8983C175B70
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:29:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D03E1F4198;
	Mon, 26 May 2025 09:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I4z8yba7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6171F1931
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748251736; cv=fail; b=HhBeif9s9wPLXR/QGLlLpV2rs/40azw7JJzpTUV75FA3+YsAsuivOY/0zYr9zbrUGzvdF52dZR55kj9kmbfmIkuQDk8hX3r6IfXl9CS4Nion7kfUzD9lWM+kEFB1AT4mQu15kgoaOq9DZltowFSKPOZIn2Z7S/2ydXrfiQX7pTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748251736; c=relaxed/simple;
	bh=hrLzIbHNq0h+/C0mS+EVnu/TGJ3yRBz1tTKY76Ec2Ss=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=maD2xHJho3Ni8f60xuBxklmyAXozVuNhln0C+xaCvars1EU2EGabsDuekIJK0bgWkN9PMa2RMLkhXZsm2qmGlf7IEi1wDQyZYH32kFxo1uHBDGv+rl7BMVK4Uc1L3E2ad/dH4mITcc9WpyUDIloYzHvpUGNFUGgfrBhKmgcTKAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I4z8yba7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748251734; x=1779787734;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hrLzIbHNq0h+/C0mS+EVnu/TGJ3yRBz1tTKY76Ec2Ss=;
  b=I4z8yba7y0HrMk62U1XDwA1IgXtOxVoiOSvsupgwFdVaUXksyxHgExZf
   O+t6wIabxoFiRjl0E/5p2K1iDypEVWHJdfoyXr7kDl6NARLQQ6hNVbJQV
   ae02Gv61rYMpUZ4orKKNvrHynfg7Y1dpRAs26BxNSFk+LE+lqoRrBKh8P
   uNvrkm94hE9Nwy9+4+/nJWW3l8j4Gorl4g2X9IPg02oM226cha9Emu0cm
   ghx/13lR/qMpFhUFFbFsGp0QeZN1yQJTrQ7l9zh7/y6hYqeAg0qG5tIN/
   GhndQopWiTYGVER1p3TPQiQ9SsbzhcL3woOC1f886Lf8X9+i3jpWztOOh
   w==;
X-CSE-ConnectionGUID: L04EWLn8QH2GRsXf0jYTiQ==
X-CSE-MsgGUID: UQWIT8wXQmqOEbISCWYxsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11444"; a="61576258"
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="61576258"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 02:28:53 -0700
X-CSE-ConnectionGUID: MfFVt/QqTS6HkCOXb1aVxg==
X-CSE-MsgGUID: UQ24e2RhS8+Lm+nrlcW3XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="143243479"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 02:28:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 02:28:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 02:28:52 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.61)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 02:28:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKINnc6Q71s5t9JmxeIZFSmE+BdbvWVIiynxdTyDhMiSz9nd86S7LxB6Xo3G9rpKvvvNdY+Ql9Zk/hNMSlWSd4eY4NW2G4sqinxHQrvUZcT6P7dgCEfakZtlmZdGvEvw6mfTSIDcAtRBVgn410yrcfLQJX0uO1F7fkt+t1nrQz8OqeFuhEzLTtZZoqgyWP+q47UYOUjVqUkHrW5aHakp1r1aObVsCSQ54Zsb6AUmToKuLOtpgAritnosJCQQ3h1UAwJFkyi702HayH78y9zIsNKqwTNxDP1hOuDres6K82kzjCQBodpf07RZ6emN+pFvjzPue/uGxA+2IaeFmXVSdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOYEF+aDU0jMtBkMw5iJY21YsiadEl23iSa/wJbrN/8=;
 b=FKRYit3OYcyz67W12W8pa2pLkSvxYZDXEm74XBz+gODOcDvRHaJrK+zOW0ty9kn5YCazjKsp112BzaOrEzb/mgHLyBGq6CwGMDvDwobWwmmH1o67K6cx0jP9vBOz5Vf59ZgIr6BfrFI1f8wM4adbocpQiGhVWWXpGP/atNjf2fYfggXQDpFGgt7GeerWRxkzYAWHLqq6rwZkp9JpCqY41TZ5SW5yfquFiUea8tHozbASPelI/lqhNzHTe55KRojmbZuVB1mCTTcNwpmfQnCo7jr6fP+q4O0SWY2Y6tUnACm0VRF6iTETV3NvFBGeW6qzxjkfNHy4D3rIGHI3yhCAbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CY8PR11MB7315.namprd11.prod.outlook.com (2603:10b6:930:9e::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.26; Mon, 26 May 2025 09:28:22 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Mon, 26 May 2025
 09:28:22 +0000
Message-ID: <0bc65b4f-f28c-4198-8693-1810c9d11c9b@intel.com>
Date: Mon, 26 May 2025 17:28:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] ram-block-attribute: Introduce RamBlockAttribute
 to manage RAMBlock with guest_memfd
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-5-chenyi.qiang@intel.com>
 <e2e5c4ef-6647-49b2-a044-0634abd6a74e@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <e2e5c4ef-6647-49b2-a044-0634abd6a74e@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::11) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CY8PR11MB7315:EE_
X-MS-Office365-Filtering-Correlation-Id: da715e48-2480-4ffd-2c8e-08dd9c37a874
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aFhxcXZyejJSZXA3Ykc4RGIrUjExTE1HbCtQTzRCdGVTNW9jZjA0dnMvVThS?=
 =?utf-8?B?VE90NFgzK1I2dnBBQnB5eGNhalJuTWt4SEZUcTE4eVBPLzVCalRWYTFnT2JQ?=
 =?utf-8?B?OTk0KzBod1FZd2VJNE1BKysvR0kxb21kTTF2dU52cWkzWU1OcjRzNlNSUnNB?=
 =?utf-8?B?eFpiNWdyQ3ZaTzBpbjgrV2M0RkZPcFZxL3dqOGFiYXNWY1c3b1lKZ2d2OFJJ?=
 =?utf-8?B?dURRK2VsSjU3ZXltbmlIcGhOak5MOTlZZURjY2lSd3VUemdwaG1wMzdTNmdz?=
 =?utf-8?B?R0VJRnFSMmcveW9oMEEwajY0OHZuUUhPU1huc1ZxNmx2R09HVVZ1Z3N2MnVY?=
 =?utf-8?B?OG9NSEt2S28rbVNKYks2SDBhNFE1N3FvMzIweFpVOVhabUh1dnlKVE10K3Za?=
 =?utf-8?B?QnFhT0NYRDJza2NZZTVNb0lsT3ZxNFRDYW9XaVdHMVltVEo0clVzNllwTVZ0?=
 =?utf-8?B?VTg3RCtsOVl4MlRrU2pwZWpKMDFqM21hb2VvMSt5R3JodXhiNHdWWUE1TUgw?=
 =?utf-8?B?cjRoWHYvMThYaXlrR3UrN3NlZ3dDdWxSV1ZFRWxIWU9ZM3h3ZXFZRkF3VGNK?=
 =?utf-8?B?ejFBUUJNdUZndFVRNXNDWUpQMnJFOVFpSExHbDlXL0NPRlljNEFFeVdmb1NB?=
 =?utf-8?B?Z2pDN3ZWVktvY0JlOXJlMHdTRlNzV09HYmtoQ2JaYjdFcU8zWlFXeG9lZkVZ?=
 =?utf-8?B?YnB1MGlnMENxcm9HRk1YT2FlemlUaWd0Y1E3RGpGbm9nUEhITDdxZk5lOHZZ?=
 =?utf-8?B?V1ZZWWx6OHUrWUI3d2lvdGpVU1V5eS9BaUJ0UnpuQWRJamI4ZC9ZQm1mdUhW?=
 =?utf-8?B?MFBHV0N6aTJvTVFvTUZYMXljUkJYTlNaTDlRbk5PRmg3bnZ5SlpwZXB6aHdE?=
 =?utf-8?B?amVtOFVYUzRRZVA4Q3ZVckJsZ20zMnlqQ3huKzJXK1BXamk4VDcwSVExOExE?=
 =?utf-8?B?d09wdXMvOEJWVUJTcm1yMHZoS2hCNTNVTFpLSU10VXE1RHpSR0hyWC9NVUxQ?=
 =?utf-8?B?SVVRQ0lHcUxDMS8rZkpYdVBITzNERDM4RExxbytTV1k0VFREcGF2cHhNUzB1?=
 =?utf-8?B?VjdWcyt1aS9VNDZQR2kwOFZEeTRsQUd3SGxQbGZZeUZoK0FGQVIvRGh4UWlW?=
 =?utf-8?B?Z2tkNWtDNm5PajBveFB4dHMyK2FUUG9mdjhNMTdvYWY0dVNwZ01CQ1BXQkZh?=
 =?utf-8?B?SkF0R0U0NkQ2U2JUZVVCb0JjMThOWVRFSHBRS0pSZzdmRklueTZSV2FaYklm?=
 =?utf-8?B?bUdIYXV1QUVOWTlrR1FuL3M4cnBRK2RBRDl1UGNxZ05ENDhRamduV01SUGQy?=
 =?utf-8?B?dWYvOUdabmFnSjBubGFXU0V2RWhBMmwvT09rellpek9JSTJ5SEhCMHRIZnRQ?=
 =?utf-8?B?RmpvWVFHVklWcU0yN0tQZDlrOC90b0Y2RTZtaWxaMmlualJzNW52VE9TTW1r?=
 =?utf-8?B?azBTQzZORXNjYUtscndYbFdIMWlRbE02YUhpMGs0S1dXMmNXYy9FMkJvYWVH?=
 =?utf-8?B?Wjd3LythZlJrNUN1ZlVIdkFVRTJ0aGJadzhOUjZKcXR1V3haNDhaeEFTaktN?=
 =?utf-8?B?U1l2U0xOZHdvTno1QzEvakdFWFVTd0x1cGlFaTNkMnc4Uy9hc0FLbmQweUJ0?=
 =?utf-8?B?SjV6VFoyRVZteVlKNDE4dzVMcHlFaXhHeTIwTGdHWDAreSt6cjMydjYvalZt?=
 =?utf-8?B?Y1VSTHY0S2ZwQkhiaDY0bUF5aDNDN21CcEFqaTBrZDhTT3NXVU5iV1R6ckxX?=
 =?utf-8?B?eElPcG92OStQTGxtY0doREI2bGcyVTlsZWw5WU16T2lUMkJYemdsL1dnbnlZ?=
 =?utf-8?B?bkNSWHpBVUExZElMNHA2eWhCblRYMjlhb2ZsU3AvZ1RPN1k5RlY0aTFLYU5T?=
 =?utf-8?B?OGw3dXA1S3k1QjAxWnExbjZoMWgycXczT1lnaW5WSXdzYWhSRit0UmVMOHdz?=
 =?utf-8?Q?7kJxxJI8nrw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGhPZC82d0QvcTJJQzBjdzFzalU4U0szZGViTkpXNFhGMGhPQTZya0ZmZDVJ?=
 =?utf-8?B?d09yUHdBUG50dXJ4K3J1T1djdGtiNEIwa0RZWHFtbGFwN1Q2UGRWdkQ4d2Ex?=
 =?utf-8?B?YVNKUmVCdFZpMk5qaFpUeElrT2dhd01xN005RUZicldVK2VDK3l3NDl0eXFD?=
 =?utf-8?B?MVF3Tm4rMlRaREh4MWRPTmcwdmpEWnFOZ28zWDdVdzgySERpMElwbFZUTkJx?=
 =?utf-8?B?UTlQUEJ5TFM0TnVCYXNEYytBK283S1V6UHU4WUgzbVMrWHA2ZDJOMGVmRXc1?=
 =?utf-8?B?S2NWejRJQStEUG1GRHIzQmw4ZElyOTk2UEI5YWMrZE1RdGFiU1FNeDFWN3B4?=
 =?utf-8?B?cWZlczJrUUhrYm9MVDZVV1piNHZWV1BSajJRaDlqODl3T2ZTaXZOY2xwVkZB?=
 =?utf-8?B?M2diOEgxS21aRDB2cWFVelRITkNBbjJPZWwwVThWTHUzTzBUN1EyR3lHNjBu?=
 =?utf-8?B?Y3ZFOGJTYjFlWlovM0xkZ2t3OENDM3pBWFVzN0lrc2VwY0tmVmJ4VEdzazBY?=
 =?utf-8?B?UlU0bmVaZTMvbCt0VTM0d3VNc3JjenJJUW9QNkJXdUtkTVdnamt1aklWL1pK?=
 =?utf-8?B?OWRubEFDbllLWnEvK0E4NG81OEY2aklKbmczMzN2cHNyUlR6WU8wVGQ3Y2M5?=
 =?utf-8?B?VkRHS0IxcExmVDRCaWMrV0R2QXMxQnRzQXZweUpKMzJyZThLTU0zNWUvMHJC?=
 =?utf-8?B?U3VFeDlwSFhvOXY4SWY1ak1HUUxVbFdZYWNJc3FjVXU0RUlKdjJ1VWMyZzFN?=
 =?utf-8?B?WlFUdm8yNDhxcEk3RzBZcUFaUytBbzZhSktJdEVZVzVyblJOeUQydlgxUTNU?=
 =?utf-8?B?QVQ1UVJ3T3FZU3orbUF0cUROeWFNSG1OSzF1WGxvY3NpNldwSDA2TW1BaTRt?=
 =?utf-8?B?NmsrbmhsZFVaNThoNHgySFArS29jWW5hZkNnSVZEWHU2ZDhHS2lwUFBiVFh6?=
 =?utf-8?B?c0x0cXVwb3NYNjhGRW9KVHUwOEZkUjZGcXZCNHAxVXB3OS9ZTDZnZC9iK2lz?=
 =?utf-8?B?VTZ0Z2JYVGNmRHRxeGxZU3RlZjF0K2MvUWYxSWVNYUlyZzZwQmlBWmNHVHlT?=
 =?utf-8?B?R3BVUzdtSGJnLzRRQnNyZFVaMnlsNTdGUTNVOHNqVDhPcENuaE9nM2c1S3dw?=
 =?utf-8?B?dGJ0eFJmK1VxUFQzUVUrSnBETUlXYU00MXNBU1l2MkEwOE9YSzZkaXl2Mm1H?=
 =?utf-8?B?eHJSbTFGeTEzNEdRYUd1Y0pJV1puS2VaN1RvaS9UNXhTeWgybWU4dmxScFlQ?=
 =?utf-8?B?d25tUEhtQVNDZDdQaENINEw5ajNrbmxrcDBHb2M2aEhBeTRVUjJuNzhsYlU5?=
 =?utf-8?B?TEhxalZHTDl3bFliWlpmRWdXSVg2dmc0b0NaQWw0ZDI1ZGFFK0ttMFBIWk5q?=
 =?utf-8?B?Vm1WRFVPVVdoZnRGRldXQk5NckJlSFNZK1haSm1tSmFOdlJ2UUZKNVBXTUVv?=
 =?utf-8?B?ck9wOWZ5RGZCaWcxTEFEOTd4eXEyWi8zVm85U24yaFBaZzlXdG5WZkpnRlFk?=
 =?utf-8?B?NmphRHRtUk93TzRzSTUrSk1PNzFEL0hVLytQUUlnakQxKytIaVpEUUxVYitH?=
 =?utf-8?B?cHA2QnRPRXpBZXQ5R3dYV0dJRi85M0dydHMzdHQyV0F4MVp3blB3Y3hWUUFq?=
 =?utf-8?B?aFQ1K2dRbFlHU3pIVW5JUklWRzNkYklyVjJWQ1JBTkRHMWNSMW94NFMxVnRP?=
 =?utf-8?B?MFdDOFFmbGYrMXpxS1ppdGpuODZMMVRnblA1RmJYYnJ0RHlWbFpXN01VL1ZQ?=
 =?utf-8?B?VTlaRlNFSmxySmZtSzlnRWNzWk4vbElacmIyZlMwWU9JL0lUelY3TzMvUk5K?=
 =?utf-8?B?dCtiUGVzL1R4dE84Q3dkY3RIbUVHbjd3Q05aWENRT3pFNU16NFhEMlFHbWJa?=
 =?utf-8?B?cFRyazdlSTljK3JMeGExRjJNejN0Z0pCbG1TL1hOOVlYZFFSVE50WHhlaGZK?=
 =?utf-8?B?SklteWl1d1hrRUh5SVJVWlg1OXUvdlhLWjN4R3JMQ1JYczVwaHU3b2QxOFBs?=
 =?utf-8?B?V1ZXc2gwV3QvY3BMT2cwMHpqcWVkMXBBazF0L1JkSS83QmZJcDBSNmtLOHlZ?=
 =?utf-8?B?TjdUcFlSL1NNbm4rUnBrdXhyQ1FLL0pTdVdTZEdoMDZyUmljY0NIOFV4SHcx?=
 =?utf-8?B?NEdXVzlTSDNIalp3SngvTU5PdGR3REFMOGIrZU16S1dkQjVnUlhIQXNnSEVW?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da715e48-2480-4ffd-2c8e-08dd9c37a874
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 09:28:22.2937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CscDStKCaC9iHTah7q9U+oYerwMzbsvRBN2u8jjNN6TimXCOVWWqTWiIZDe+ZN6zgGeyqbkqWvFN9Ssvth7E/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7315
X-OriginatorOrg: intel.com



On 5/26/2025 5:01 PM, David Hildenbrand wrote:
> On 20.05.25 12:28, Chenyi Qiang wrote:
>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
>> discard") highlighted that subsystems like VFIO may disable RAM block
>> discard. However, guest_memfd relies on discard operations for page
>> conversion between private and shared memory, potentially leading to
>> stale IOMMU mapping issue when assigning hardware devices to
>> confidential VMs via shared memory. To address this and allow shared
>> device assignement, it is crucial to ensure VFIO system refresh its
>> IOMMU mappings.
>>
>> RamDiscardManager is an existing interface (used by virtio-mem) to
>> adjust VFIO mappings in relation to VM page assignment. Effectively page
>> conversion is similar to hot-removing a page in one mode and adding it
>> back in the other. Therefore, similar actions are required for page
>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>> facilitate this process.
>>
>> Since guest_memfd is not an object, it cannot directly implement the
>> RamDiscardManager interface. Implementing it in HostMemoryBackend is
>> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
>> have a memory backend while others do not. Notably, virtual BIOS
>> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
>> backend.
>>
>> To manage RAMBlocks with guest_memfd, define a new object named
>> RamBlockAttribute to implement the RamDiscardManager interface. This
>> object can store the guest_memfd information such as bitmap for shared
>> memory, and handles page conversion notification. In the context of
>> RamDiscardManager, shared state is analogous to populated and private
>> state is treated as discard. The memory state is tracked at the host
>> page size granularity, as minimum memory conversion size can be one page
>> per request. Additionally, VFIO expects the DMA mapping for a specific
>> iova to be mapped and unmapped with the same granularity. Confidential
>> VMs may perform partial conversions, such as conversions on small
>> regions within larger regions. To prevent such invalid cases and until
>> cut_mapping operation support is available, all operations are performed
>> with 4K granularity.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v5:
>>      - Revert to use RamDiscardManager interface instead of introducing
>>        new hierarchy of class to manage private/shared state, and keep
>>        using the new name of RamBlockAttribute compared with the
>>        MemoryAttributeManager in v3.
>>      - Use *simple* version of object_define and object_declare since the
>>        state_change() function is changed as an exported function instead
>>        of a virtual function in later patch.
>>      - Move the introduction of RamBlockAttribute field to this patch and
>>        rename it to ram_shared. (Alexey)
>>      - call the exit() when register/unregister failed. (Zhao)
>>      - Add the ram-block-attribute.c to Memory API related part in
>>        MAINTAINERS.
>>
>> Changes in v4:
>>      - Change the name from memory-attribute-manager to
>>        ram-block-attribute.
>>      - Implement the newly-introduced PrivateSharedManager instead of
>>        RamDiscardManager and change related commit message.
>>      - Define the new object in ramblock.h instead of adding a new file.
>>
>> Changes in v3:
>>      - Some rename (bitmap_size->shared_bitmap_size,
>>        first_one/zero_bit->first_bit, etc.)
>>      - Change shared_bitmap_size from uint32_t to unsigned
>>      - Return mgr->mr->ram_block->page_size in get_block_size()
>>      - Move set_ram_discard_manager() up to avoid a g_free() in failure
>>        case.
>>      - Add const for the memory_attribute_manager_get_block_size()
>>      - Unify the ReplayRamPopulate and ReplayRamDiscard and related
>>        callback.
>>
>> Changes in v2:
>>      - Rename the object name to MemoryAttributeManager
>>      - Rename the bitmap to shared_bitmap to make it more clear.
>>      - Remove block_size field and get it from a helper. In future, we
>>        can get the page_size from RAMBlock if necessary.
>>      - Remove the unncessary "struct" before GuestMemfdReplayData
>>      - Remove the unncessary g_free() for the bitmap
>>      - Add some error report when the callback failure for
>>        populated/discarded section.
>>      - Move the realize()/unrealize() definition to this patch.
>> ---
>>   MAINTAINERS                  |   1 +
>>   include/system/ramblock.h    |  20 +++
>>   system/meson.build           |   1 +
>>   system/ram-block-attribute.c | 311 +++++++++++++++++++++++++++++++++++
>>   4 files changed, 333 insertions(+)
>>   create mode 100644 system/ram-block-attribute.c
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 6dacd6d004..3b4947dc74 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3149,6 +3149,7 @@ F: system/memory.c
>>   F: system/memory_mapping.c
>>   F: system/physmem.c
>>   F: system/memory-internal.h
>> +F: system/ram-block-attribute.c
>>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>>     Memory devices
>> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
>> index d8a116ba99..09255e8495 100644
>> --- a/include/system/ramblock.h
>> +++ b/include/system/ramblock.h
>> @@ -22,6 +22,10 @@
>>   #include "exec/cpu-common.h"
>>   #include "qemu/rcu.h"
>>   #include "exec/ramlist.h"
>> +#include "system/hostmem.h"
>> +
>> +#define TYPE_RAM_BLOCK_ATTRIBUTE "ram-block-attribute"
>> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttribute, RAM_BLOCK_ATTRIBUTE)
>>     struct RAMBlock {
>>       struct rcu_head rcu;
>> @@ -42,6 +46,8 @@ struct RAMBlock {
>>       int fd;
>>       uint64_t fd_offset;
>>       int guest_memfd;
>> +    /* 1-setting of the bitmap in ram_shared represents ram is shared */
> 
> That comment looks misplaced, and the variable misnamed.
> 
> The commet should go into RamBlockAttribute and the variable should
> likely be named "attributes".
> 
> Also, "ram_shared" is not used at all in this patch, it should be moved
> into the corresponding patch.

I thought we only manage the private and shared attribute, so name it as
ram_shared. And in the future if managing other attributes, then rename
it to attributes. It seems I overcomplicated things.

> 
>> +    RamBlockAttribute *ram_shared;
>>       size_t page_size;
>>       /* dirty bitmap used during migration */
>>       unsigned long *bmap;
>> @@ -91,4 +97,18 @@ struct RAMBlock {
>>       ram_addr_t postcopy_length;
>>   };
>>   +struct RamBlockAttribute {
> 
> Should this actually be "RamBlockAttributes" ?

Yes. To match with variable name "attributes", it can be renamed as
RamBlockAttributes.

> 
>> +    Object parent;
>> +
>> +    MemoryRegion *mr;
> 
> 
> Should we link to the parent RAMBlock instead, and lookup the MR from
> there?

Good suggestion! It can also help to reduce the long arrow operation in
ram_block_attribute_get_block_size().

> 
> 


