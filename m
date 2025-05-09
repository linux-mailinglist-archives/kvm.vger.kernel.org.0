Return-Path: <kvm+bounces-46050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C119AB0F4E
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:40:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A2064E6687
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CEBB28CF52;
	Fri,  9 May 2025 09:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erapKW1X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6A6201266
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746783620; cv=fail; b=Cup6UyW1KqTrEA8eSi09IJ0noh4UJpWNxGGVo3S5R6VzAnxVmrZVonZKXKq+fJ6EgpApwERl53zxswiz83Fyh49VAun796edtXYbiD8FycmvjB5SW+vwLa9wCNUaZsCnPdoLd7fi0xnbi4H3v+J3mElqXj0tlR0ZCNc342DXb3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746783620; c=relaxed/simple;
	bh=5IemT7bVvckzEYow5M2Pmw68XqPdpIIHAdRNkO+MvdQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WTKiIbz1B+PtujF/zCfh/HCVevX1VpTQHnwxqffHsqTmr79T48g7hjFmjCwUvDHx2pekCcud1eQXCOApEU7Qcr1MWNOahx4cmcwcjVmU/7NmaQS5XrJybsNT+T5siBAfKUniG1q6LO9hjKkylAiFAtOt4pWEgYxfo5XEdy3Lb3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erapKW1X; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746783619; x=1778319619;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5IemT7bVvckzEYow5M2Pmw68XqPdpIIHAdRNkO+MvdQ=;
  b=erapKW1XwPXDJd+w9zCcrTVy9sa4jicQxatiIIrrjl25Ju2JuHth+2Dx
   uFRP/KYxw/9DEeA70Csj3kii+3Bk9zEfDAN/eSTi0irygeVRzazneHJDr
   3Y/iejiSC7JenSdi78Rp0Hbu5CxMiUApCF8apipyzAqkE/jqRDkwAmznN
   jIpCN/YC2z9NACUJGysUUb9sCA71sLdvdx6mfNZ7WDn36PEka0E8BWGFU
   sXPJFnKBU9qEttqUFsS5Z2yfOqQhg6d3r2mS3uTsDMfOeQzDnuOg76agT
   UhEzOkOud7VJX3Gv9M2BdqMaPYib8hwvP1MELuZGkr8dv7UVLPzrMzF0I
   A==;
X-CSE-ConnectionGUID: 3L2/5tfsTx2UzOoH05ingA==
X-CSE-MsgGUID: LG2Pq7kcSdOoNj/EaFOxHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48761898"
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="48761898"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:40:15 -0700
X-CSE-ConnectionGUID: YfW5kVSMTb2wNNik8n2UGQ==
X-CSE-MsgGUID: Wo2azRhOQCCmTmm62sb6cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,274,1739865600"; 
   d="scan'208";a="141780025"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2025 02:40:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 9 May 2025 02:40:11 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 9 May 2025 02:40:11 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 9 May 2025 02:40:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j1RY1OW64bCct6Z04WMHv5Tf9xAmmvpMSTfZrvtuXLYYb+TLkff3YdOpDG8mLw7rFBgkM5iqdOJQohWC2v/0SWIk8CbsBZezGiBd7IOjh8ub0aHuZWXFjxqSdU9yLzHBDvvAC6LDgj021P8nHWZzj3oH8jQ9cRi9q6Rn1cVqAhRQryIFDsst2OCr9ljUhtz0rRo0lkUCwaGxgw3fbxguGBw8IRnfSypb4p915YQ2m/vyqtbWiaEgtg3QNhPEv3jUPa6XSM5HUpbemdeibbUdEiZj96pLZ/10y2RVBJ0ehA4AMv0OxEKhqK/J/WQM87tk95d6TOIgPt3uFXIjsj4NDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tl42NnFfC3ILem+Me6v+HaRkUmSj62ulieVaZUztIhE=;
 b=QOxvG7aA8I8bTVEmPyanam13UR2EPnZe9Vdu2N6RpaOXl0jzccyyeD2HGfZL5ChkfsDriwVh9AJrBsSPHQznMIK7/MpsnpsNtg3s+ywUpZk/Mu8NOfS2nk6kes8yIY1mz2idrkEDDqFRlS3GcfkZRHCjvWWhDQ2sJ47+5C0LmJhHUnxH38xbfvoYAySopaQurxQSoKQrK5RoEkTCagaaFeynL8HdU4HXEY/0EhaV9SYc/tq98xxJNuSPm5Qnz4z01X17ztjGluyNbbMvU4E3eDRgMt4Drt3+XsfnvHnoWDpKf2e1NG3O15WKk8ixfmEM0eSrPwHitX1qBA496srnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB7469.namprd11.prod.outlook.com (2603:10b6:510:286::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.26; Fri, 9 May 2025 09:39:55 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8699.021; Fri, 9 May 2025
 09:39:55 +0000
Message-ID: <326f5ae1-aa9f-4580-9025-352802d28c6a@intel.com>
Date: Fri, 9 May 2025 17:39:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/13] ram-block-attribute: Add priority listener
 support for PrivateSharedListener
To: Baolu Lu <baolu.lu@linux.intel.com>, David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>, Peter Xu <peterx@redhat.com>, "Gupta
 Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-13-chenyi.qiang@intel.com>
 <e089f11a-da4c-44c9-8553-3492e236d4aa@linux.intel.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <e089f11a-da4c-44c9-8553-3492e236d4aa@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0039.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::16) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b2952bb-3dda-4d85-46aa-08dd8edd7469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MkdpY0Exdm1aWVpLUjdFQ2JpRFpzK0VQbU1vVkFPOFFJQmx2NU1LZnZ1aXZN?=
 =?utf-8?B?RGZzWlh3cTlDZTRQZlplTE9Jb1NoeERsOEJQRlpUN2s1NGl1SzFQUzBZV0tG?=
 =?utf-8?B?bkEvb2o3bFRyM3drMmI4R0E1U0VsWTJrTEZlbGsvSC95ZlBQbHdCdTQvRU1U?=
 =?utf-8?B?dFYxeGR0V1dxRExnSDV3OUJ0Qlh5N2JWa0dLU2hiaGMycGU3aXp3U1pjYjZy?=
 =?utf-8?B?b2FXNnduWnFhaHI4V0Vyc21yMnA5T0RzQkRMOXh2akp2bUpJWHpscE1DOWR3?=
 =?utf-8?B?dXhiV1p2TXpMUGlhdGlOSkdUbU9icmt4WXgxT0NYWDdMMWtIYmJtMzlkWDFU?=
 =?utf-8?B?R0pQQk9HeGtSU01aR0Zib2FPbmlsWDh5ODdmK3NqSXJzUlVzWSt3eTVnU2M1?=
 =?utf-8?B?TFQ3bHJuM0JndVdoenRNVXBOakJlTllCZVFYdHAvTnJLL1JlRTdCUXREekdy?=
 =?utf-8?B?YlJDNGRuSjdFRkVPcUJpKzdhN25NSkk4T25BWGFwb1VpNmdUTlZNbWR5TmVG?=
 =?utf-8?B?QUs1TkxTc3V3VWFpYW1QeDFlTmxmNG5rZmt1cVk3dnd6SjFXZDA5ZldyWGE3?=
 =?utf-8?B?Tjdsa2cyKzI2RTVReTVRM01VcUtPVllyYjNaTWw3UzZReVBjeVhqZnkxN25S?=
 =?utf-8?B?ZHd4RVExK3p5eHpKWnE5NnQ4Z0xsSmIzZlRYYzRsMVVCREo1Y1M1N0tic0VJ?=
 =?utf-8?B?dmlrMzRibUVoZ2dOeWt1K1VqaVZGWUtFUXEwZDJzWThZazBFc254Vko4SzVN?=
 =?utf-8?B?MGFTR3ZUWlozaWhEdlhUVGtWa0pHSEx4NDdRd0ViTThZdTJ6T3VMMFR2WlNF?=
 =?utf-8?B?eTJWK1BQbmQ0K1ZVS3Q4RjZNZi9DSXNsam81TGRoVTRYZWwyai9aU3dmSnNB?=
 =?utf-8?B?Skg4NHpWalBONERON2xlL0daK2VZS1gxVkZJaWdzRkJpV0lxS1NUYXRlbUh4?=
 =?utf-8?B?TDFsYTk4Q3RadGdzOHhQQUc2b2x3SzFYa2dIMkUzaFpseHdRUVRtMG9QU1R4?=
 =?utf-8?B?V0RVUnRuK05vckk2aVFBaGZvOEhJeXRtQ2JEMFB2YXlKK2x1V2R1VGFIQ1I0?=
 =?utf-8?B?MnNoYzhsbHBDSjc4UGdFZmY0NEs3YVMxTWllVWQyZ3FpVUZDbFZMTHpIeTRP?=
 =?utf-8?B?bDRRTlhSWTFwQnhSRnpxeElIYklsdkdVMFduc3I3WUpWcmlqaENkSFEvalZO?=
 =?utf-8?B?SlBFalU1NkF2djhSL3VyM0NYay90bXdpQXMxQXB4QTB5c2Q0c0xFbVhMU2s1?=
 =?utf-8?B?TTBReXR2cTIzeitOWjhKdGpSd2pjbTNkS3lGZ2JoNzhrVnFuWmVTQUNYSVMx?=
 =?utf-8?B?RERnTXVBTWVhOFZFanR1SmhEZXA2WWtTbWx5TDhsVlNRRERuMCtrWGNZZ1dl?=
 =?utf-8?B?bVErbVhpMHVtM2N2UkNEN1MyK1BMNGRKcTZ5TWpOUXlYM25FcFNXUGlPWllD?=
 =?utf-8?B?YUlLWGcxQjBPaEpPV2tja0ZsTWgwemVGS1VhbmszdXJxc2xqMS9mWGVMWVJF?=
 =?utf-8?B?MXRUN2NvRjcyZlJXTmFYK2oxWlZldnV3YlMyZW5xMURxTXYxdEU4bkxxZ0R3?=
 =?utf-8?B?UHp4ODF5NVkwRWRQb25NUFpYZWVjcmpZaVBxMmVCSDM3cnJhTTNLdjhYalgr?=
 =?utf-8?B?c3hkN2hBcWpoOGRWMTdoZE1EaDRDV0dVeFZOZ0Q5S1VmRldNeGZUVzFhanNp?=
 =?utf-8?B?YmZhU096Zjh3c3N6clJtWjZLeWkveTNtZXlmZEdXNlhZaVg5dFJjWm5Nbmk0?=
 =?utf-8?B?UWxqREJsenpnUzlCQWsrNExNdWczMFhqUGZhakVxeEpRenZDVmhsZk5lZGo1?=
 =?utf-8?B?V2FqS09LNHBIelNhSFJIWTRya0FKeXY3MGFzOENlNlhYdEI2WmNVVGpLZTVa?=
 =?utf-8?B?S2JQZ1RxcUx6RUtMOGQrdng0bVJjY0liM1dMV2o0UTBrSWg1OVJxTnNMTDFK?=
 =?utf-8?Q?ZqOmBimqMOw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RVBFVjNYR28xN2QvSGthZENVWFVCL29sSkxwRkMwMW1HL0szS1czejRrcVla?=
 =?utf-8?B?clNaNVBweXAwMEtacWtXSVNrM2JkdDBqem1rR3IwNCsyQll6dVJ1Z1hNQkQr?=
 =?utf-8?B?UmtLenBIYWpJakVCd1Y4SW5ic2o0dndsbHpwbk1ScVJPVFdDSmphN2pVY1dh?=
 =?utf-8?B?QzZSMDZrdU11bCtmdFU1TCtmMGYrTUhaL3FNekh6VWNCSE5oWXZyblc3aW1D?=
 =?utf-8?B?d2dRdXY5ZlNUZUE3aHFvT1FPc2pDNjRZSktCZlcvYXVzVFRRcGIvOXkyUHgv?=
 =?utf-8?B?UU5oN283WjZmdzZCeDZaYTB1SVA2SmsvMVNpLzV5K2Z0VWoxV1FxL29wdHI1?=
 =?utf-8?B?VDBoYng3clZWQytRMGxUUzNJR3NGeGt0VlFyTXJYWjN5ajgxOFYwZk9GWkt3?=
 =?utf-8?B?ejVrNDBZMDNRbTErQXVjSVhPdnFqamR4Z3JBUk8vd2FMcWxsR2JFNWNJcEdr?=
 =?utf-8?B?SmV1NEVmQjJMWlg5Mk00UGxuKy93SVptWnk3aWErU083TlhtbWZVVnQ3UkFO?=
 =?utf-8?B?YWlkQi8xelcxZDJxQU5QaXMvMy95YkR3ZXJXUUFmKzVlV3h3K0FDMVRickd6?=
 =?utf-8?B?U0M3eWxwbXZhSk94OW8zNTVNdVNybzUxc1k4cVh4TDJTQ0VVZlNzR0dTQy9n?=
 =?utf-8?B?TXpJSzEwWmpxdHpZOWV2dXVWdE5jdC95QTZwbUdVOStUZGwvTTJPVGNmUHNa?=
 =?utf-8?B?YUUrdU9qZlNBNG14bG9JemU4VzJ0ZHpyKzdLUHZRQmMxK1ExR1JDcGI2bnM4?=
 =?utf-8?B?NDk3ZFVaeVR2SmppMTRiL3dSb0hHOU5CR08ycDFDZUxIREkyUDVPM0VTcFIw?=
 =?utf-8?B?dkVKR0h5bmJDV28vZGQ0Q3FJMzZ0azVRMUVhSTlCQkhiNm1pa2tUUEpiN1I4?=
 =?utf-8?B?UUlhWFU2T1JLSDhVaHRWbklhMUdPTm1Fc254ZG1YTlpHT0Y5dDE3ZTFjWnpT?=
 =?utf-8?B?c3hZQUZ4OUdCZjdHeDdZcmZEZmsrNGhrYnZ4bzBqTGF1WTNObGZsalN5WVZz?=
 =?utf-8?B?enRTdUErejVFV0VQcVp1ekJsT3N0RTNqNmNuQ2FnQk02ckdWT3drTWc2RitT?=
 =?utf-8?B?MWJsaTdkU2hST0trQTlOaDJISlZzL1J3V1ZBbW9veGxoU3pqVUFpNUJMY3pJ?=
 =?utf-8?B?QWp6QjVsVkxnZnhIOENlMExSNko2ajM3UmMrK2ZBWHFoN0tabW1GUUxMaVdx?=
 =?utf-8?B?WHdkM1pXS2pNNmV3Z3FPLzZzMTV3U0xIb0ZyTG1xWUxsV1JrTmVSenAyR01Z?=
 =?utf-8?B?MkMyT05XRTFLeUNNQitoRGxuMU9KUDdQZnR5emgrMFo4MmdSRnNIWXREZzB0?=
 =?utf-8?B?aTd6aDFUbHRCVmdCUk5pTDNmNVZ1VEowZmxhdldxdngzTlMwMitFQTBSYXY2?=
 =?utf-8?B?Z0RVbXZNTE1GWkhiZTNWK1JOV3pWU2pJRk9JMzhDcnJQWWRzRlFobkw2YUl1?=
 =?utf-8?B?bHVnbGZ1MzNpZmhCOVUrN0Q0MWZzL0NZWmlBUmZvTUZ2MTNSSDZpT1FIc1Zh?=
 =?utf-8?B?TStDTFYzaE1ITmJ0dzc1ZWJpRFRGVlpXeVdNTnFsd2lpZ2VXQ3RJT01zM3hR?=
 =?utf-8?B?Wm91T2RVQ2V1dFFHTkdvSk4yTkp0ci93RHRFVDdHTE1DWnRwdU5xT1k0czk4?=
 =?utf-8?B?b1RJYW5FNG91QWpscFpqY1hpV3diN3IzRkxzMyt4TjUwVkJ2ckNQeFBMNFhn?=
 =?utf-8?B?K0Z4RWhsTlc4ZGgyRzNFTWY0MzFhQTZld21BWDFpL0JyRWFaeTJ5YThCODMx?=
 =?utf-8?B?RUVLVkRMQlRJUmt1clEyakUwKzNGc2hhWHVaZ1Y1Rjd5Ukp0U04wbGJpZVhL?=
 =?utf-8?B?Ym84RGY0SXJvdkFQUm05bUJKK2lOQTNTS0RRZVEyS3o4WGk3WEo5d3FKcGF6?=
 =?utf-8?B?b0NVSy8xdm1zVHFnSVBQQ2ZtZ3RVZ0c4YXF6ZlRPdGMvNjNrME9PZi8zd2t5?=
 =?utf-8?B?bVptdExVK1EyM1puaDlUWi9KYjhzdlJ1R05RYTVnN0RDTHF4SThUT3JZVEhR?=
 =?utf-8?B?MWZUUElMWmxoZ3VVN0lVWkpNY2VaalJXT1ZUbnNEeHplRzk2cEZMSEJuMWRu?=
 =?utf-8?B?aUFMaC91ZHZsWWxEcWJZdFc2RVdRV0RtWHNoZGpUQUlad2k3VjRkNzNTWEFt?=
 =?utf-8?B?NEhnNHpYUzJSb2xSU0ZrNDZCcTJUaUNJaGRXdCs1ZTlid09ER1h3ZFJhNGxo?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2952bb-3dda-4d85-46aa-08dd8edd7469
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 09:39:55.2013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rVE7Oijsxb2H9+PdzNqwu2H/+7bIt0jg8x4qgB/s+q5vbtnmqtmMujLF5YsVq2z7hEsYsICFQJHdVeyU61GNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7469
X-OriginatorOrg: intel.com



On 5/9/2025 5:23 PM, Baolu Lu wrote:
> On 4/7/2025 3:49 PM, Chenyi Qiang wrote:
>> In-place page conversion requires operations to follow a specific
>> sequence: unmap-before-conversion-to-private and
>> map-after-conversion-to-shared. Currently, both attribute changes and
>> VFIO DMA map/unmap operations are handled by PrivateSharedListeners,
>> they need to be invoked in a specific order.
>>
>> For private to shared conversion:
>> - Change attribute to shared.
>> - VFIO populates the shared mappings into the IOMMU.
>> - Restore attribute if the operation fails.
>>
>> For shared to private conversion:
>> - VFIO discards shared mapping from the IOMMU.
>> - Change attribute to private.
>>
>> To faciliate this sequence, priority support is added to
>> PrivateSharedListener so that listeners are stored in a determined
>> order based on priority. A tail queue is used to store listeners,
>> allowing traversal in either direction.
>>
>> Signed-off-by: Chenyi Qiang<chenyi.qiang@intel.com>
>> ---
>> Changes in v4:
>>      - Newly added.
>> ---
>>   accel/kvm/kvm-all.c          |  3 ++-
>>   hw/vfio/common.c             |  3 ++-
>>   include/exec/memory.h        | 19 +++++++++++++++++--
>>   include/exec/ramblock.h      |  2 +-
>>   system/ram-block-attribute.c | 23 +++++++++++++++++------
>>   5 files changed, 39 insertions(+), 11 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index aec64d559b..879c61b391 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -1745,7 +1745,8 @@ static void kvm_region_add(MemoryListener
>> *listener,
>>       psl = &cpsl->listener;
>>       QLIST_INSERT_HEAD(&cgs->cvm_private_shared_list, cpsl, next);
>>       private_shared_listener_init(psl,
>> kvm_private_shared_notify_to_shared,
>> -                                 kvm_private_shared_notify_to_private);
>> +                                 kvm_private_shared_notify_to_private,
>> +                                 PRIVATE_SHARED_LISTENER_PRIORITY_MIN);
>>       generic_state_manager_register_listener(gsm, &psl->scl, section);
>>   }
>>   diff --git a/hw/vfio/common.c b/hw/vfio/common.c
>> index 6e49ae597d..a8aacae26c 100644
>> --- a/hw/vfio/common.c
>> +++ b/hw/vfio/common.c
>> @@ -515,7 +515,8 @@ static void
>> vfio_register_private_shared_listener(VFIOContainerBase *bcontainer,
>>         psl = &vpsl->listener;
>>       private_shared_listener_init(psl,
>> vfio_private_shared_notify_to_shared,
>> -                                 vfio_private_shared_notify_to_private);
>> +                                 vfio_private_shared_notify_to_private,
>> +                                
>> PRIVATE_SHARED_LISTENER_PRIORITY_COMMON);
>>       generic_state_manager_register_listener(gsm, &psl->scl, section);
>>       QLIST_INSERT_HEAD(&bcontainer->vpsl_list, vpsl, next);
>>   }
>> diff --git a/include/exec/memory.h b/include/exec/memory.h
>> index 9472d9e9b4..3d06cc04a0 100644
>> --- a/include/exec/memory.h
>> +++ b/include/exec/memory.h
>> @@ -770,11 +770,24 @@ struct RamDiscardManagerClass {
>>       GenericStateManagerClass parent_class;
>>   };
>>   +#define PRIVATE_SHARED_LISTENER_PRIORITY_MIN       0
>> +#define PRIVATE_SHARED_LISTENER_PRIORITY_COMMON    10
> 
> For the current implementation with primarily KVM and VFIO needing
> ordered execution, the two priority levels are likely sufficient. Not
> sure whether it needs more priority levels for future development.

For the priority levels, I think they can be classified. Subsystems like
VFIO don't require explicit order and can be put in the same level. The
primary KVM responsible for changing attribute should be classified
separately.

In addition, since this priority support mainly serves the in-place
conversion. I'll drop this patch temporarily since in-place conversion
will likely change the path.

> 
> Thanks,
> baolu


