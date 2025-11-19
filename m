Return-Path: <kvm+bounces-63734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 87CB1C6FFEB
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 17:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 994D3503880
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 15:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0787E327BEC;
	Wed, 19 Nov 2025 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JKbjyuon"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2461327BF7;
	Wed, 19 Nov 2025 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763567474; cv=fail; b=E9Ad0jQRaar/Bn6QhH7a8sQvv8OvbOLi+t14FmegqGBr0LY8AZqjAzsTQxAOx+KMP9SeUxWEQ8nmeKoX2EAKZuhvaazwoD4LIOlG8c+8Sm9AD8zSUQmzs113l9FmLQxKFQvRze6wrtsLAuzkH4S0MyqQBgqwLQLwhGViC7soFu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763567474; c=relaxed/simple;
	bh=SDNhV2SFjnxiQ97ij+uYlt7bEWI9pk1P7lGzHa5C1qQ=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=pNjnh0ubuvlqqbZtRg2SE1bp6jZ2VjDtOFBrMRfUyw2CYe5yEtDHwmrXtdYrYJZLd0a9PdZEjvOYJmMr/7T9TYNnXnuvzeacZHz6ZklYVjmfGycvnsm9oqv2ar0Ry41zZTY5wMv08HB0lp0R6+G6blffaIGH2vjmQC9AUxuuq4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JKbjyuon; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763567471; x=1795103471;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=SDNhV2SFjnxiQ97ij+uYlt7bEWI9pk1P7lGzHa5C1qQ=;
  b=JKbjyuonUpqY/eW7+qW881Q3sq4Bv0/adVcd2kivhqRmLMn3nqnKhnfj
   GLhGCuSF1Z5f5Gr7FTOf/wm1SH79KHSCQkX3R6Rys6E6WBfcyYJzUEByg
   pODVWX3oTuFlfwveotnD2/RizkwzbC5mmc9MwFwXfKYffJiqd9QB/yL2o
   Ww3etboCjP3/VxV0+TXYgoZHT0cdNK02V/+DJAqXHpLNTnnhMCovuHKtw
   7Yajf1XEf0dZjV5w5tR8HF57nTbb2J/Ebs4w6JyuQjx2zkU4IdDqrcInv
   STdgnHvUz+Js0dy/C57SCvDIynKuhesxXXDgFdskjIk+GI9XixjIgD07D
   Q==;
X-CSE-ConnectionGUID: 8nh/X1TpQ/ancJEJ/61jcA==
X-CSE-MsgGUID: IdGIMVd7S9Ggqi9ww41GYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69466275"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="69466275"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 07:51:10 -0800
X-CSE-ConnectionGUID: 8nlJeXngT+WwrcEdwUw0Lg==
X-CSE-MsgGUID: fftLgo2xRo+BMGLDwu4JsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190760088"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 07:51:05 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 07:51:01 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 19 Nov 2025 07:51:01 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 19 Nov 2025 07:51:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W9e5it6YznZbnjvGs9MMkvj+UknCXdbjWbWqLZ7xkzR1H8Pn5IS/fi/8tJLoAjjKJPDZzvjplPHSzxdgO9Nc68Mroh8JfU/R+aWXGHCHslGKR+enAu/3ebRp5sAzNdbqGfL2w4jKzqMfYF0eCXFlyXSgOex2x/TbZlyB1n0VAqg0V66nOfxUGidYzp4bfkcJFK6twWMwsddeoErSGA8qZZDBF10tCEhSPMlOpUoAKStJ+Ggq/a+KT9741mEYARYMgwuRDT9vgpBrIPIJyDKCTQhVBH5rXj5K6LgsdWsN0uAFJwZPyWEF+ww7dGh8GCtzgt4hYJQtrywQw9YuETJJlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34XXOoIZsRKFhU5hJicJSBqG5be69hOhkOEEBYpX0Zg=;
 b=TX/Dc2SutqfPWlwD8SP35W5UaYuNRWSu+diiOAm7fA/rsuyR6Dk550TUzE1TOlI51A08/yfxgcncSisidup7yWvlu6W1TyPjLIabCppWe+AKYWiweHpetrKgvfYQApxWf4NoejMv4wDDmCjuOICJMDtXtf3HRWThVFhr4S9vd2ql4+Cu3YGdEU8jVLNoOQ4AqGEOaVQ4nB3UOlRMv2o6zcL6SYOPFSyxLnnpy/saxm6vpDBnWttTv24qeOSUM2S0VuS+nmabjI7PURsRgczkKMAUkdNhpFybpvIeZ5QlypHYK/VbXT4hHJh68dFqQhUa0NoOlceGaLWkUpYA+ZyBJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH3PPF5D8CD6E8B.namprd11.prod.outlook.com (2603:10b6:518:1::d25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 15:50:58 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 15:50:58 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 19 Nov 2025 07:50:57 -0800
To: Dave Hansen <dave.hansen@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	<linux-coco@lists.linux.dev>, <linux-pci@vger.kernel.org>
CC: <chao.gao@intel.com>, <dave.jiang@intel.com>, <baolu.lu@linux.intel.com>,
	<yilun.xu@intel.com>, <zhenzhong.duan@intel.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@linux.intel.com>,
	<dan.j.williams@intel.com>, <kas@kernel.org>, <x86@kernel.org>
Message-ID: <691de76151967_1aaf41001e@dwillia2-mobl4.notmuch>
In-Reply-To: <3c069d9f-501e-4fde-8ec7-7ea60e4159d0@intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
 <3c069d9f-501e-4fde-8ec7-7ea60e4159d0@intel.com>
Subject: Re: [PATCH v1 00/26] PCI/TSM: TDX Connect: SPDM Session and IDE
 Establishment
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY3PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:a03:254::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH3PPF5D8CD6E8B:EE_
X-MS-Office365-Filtering-Correlation-Id: c226396e-35a3-46c0-3ece-08de27836ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OUo5WTlnaXFWQmprQVhiODZvRm1GYmFkdEpBUEZMa1RGczR3Q2xHdUI2Mllt?=
 =?utf-8?B?N0x0UlJVL0p1d25WQjVlWHZNR3hUdGliMVh4T3ZUby9mYUtZY1RNblRpWklp?=
 =?utf-8?B?NThsc096OUhxRTZlZDhjbDk3cDQxTWx5ZCtvZS91dHhDWVhkaVdSU3F3cXJO?=
 =?utf-8?B?UjFiRS9zOEVIaVMydW8vcWhBb1ZPajBHa1Z5RVZLN20yRk1ONzA1aXhPUWFk?=
 =?utf-8?B?UXEwVTl1ZWJFWWNPam9za3gwVExyeHNQZVJodE9nUjJuK3lSQmt3RjF0ZUc2?=
 =?utf-8?B?am8xMVBucFNHZ1ZYRFJHZ3loUElwT0JCY1h6MUl6SHFXRnUzc0dPWEpOTnVL?=
 =?utf-8?B?cklucGN3eEd1WjNoUGlLb2IyYTBzbWZJT0hqb1BXbHJ5ZUs3TExUQWpjQVZi?=
 =?utf-8?B?ZWViTFFOV3NZNHFRTHRmYVA3MmtZSUdQM3RLSmxjUVkxVk9PS1gyTWJWNjR6?=
 =?utf-8?B?bk9OOHhUdEI5eThQNmFxc3BuU3FOL3dwQk1UZm1ocjZ6OVo1Z0lONmtVa2M1?=
 =?utf-8?B?MGQ4WGphMm5yZk9sMVhrUy9ZS1U1OGd2UGtsUjFKYmlYaGhleTFSb0xDQ0E5?=
 =?utf-8?B?TTlmREtXWEJ0MVVDT1ZwWnpHQ1NGUnlRTWozdEQxU21ObWNHbnFMblpXQWRh?=
 =?utf-8?B?SEFCS0MxWWRsanFYdWlyZlZjSEJ6emRyamdIbUd1Vllwa0Nsb1ZWeEpPM1Vj?=
 =?utf-8?B?N2VTVnliZVpQeHM0SDd4ZWpIcWpWRXFPOU51REtUbkw5ZFlXV1Yxa2ZJRSt3?=
 =?utf-8?B?aWRrTFhVamxjLzBmY0xoeUg3MEYwbE9pajRKRVA5a2NJd1RTRVJIcHdVNHNM?=
 =?utf-8?B?UTJOa2lhZ3hockhjOGVqS2xPcHNTa2IrY3pwZUl2bE1zanAvc0diSTltRENH?=
 =?utf-8?B?Qk5uTXRIa3NZc1ljK3hXbi9FeHFYUU16RFVCd3VJcDY4cUF1RHNsZUdhK3dN?=
 =?utf-8?B?ckFOSmVmbEhFTTI4RThsTU90U3Q5VUxxaW5TbzZrdkg3eGtnd1R1Y0d1dGhC?=
 =?utf-8?B?VFdmeTdsUld3Z1pYRUk1Z1RtU2ZTQVhUQk9pL1VnbEpBcG9Ib2t6ekszNURN?=
 =?utf-8?B?cG9sS3Q3ZVl6T2dnYWZ3NGpMSkdkc1pnNndmY2w4aUJjRUVUbVYvc0VPNElI?=
 =?utf-8?B?RlpEaEFjTnUrU3ZRd2xFdVZGdkt2cUpkbnl4WHNBMDNMTHRia0V1ZVZUZ1lH?=
 =?utf-8?B?OENLRlZhTFdBVXNNQXpoWjB2ek5qZjdmbjNYOUpwKzZZRU1BTWUvNUJ6aXI1?=
 =?utf-8?B?VFN5dHJpaDJGL0NOWkVqdy9LcFp5ZzdEUkxKNm1nb2dzOTNmeFZzRGFab1FI?=
 =?utf-8?B?dkdhUTBIVnJQUjdaTEtObXhZaE1QME1Mb2pPR2l6RUdjL2xMK254TUk5Um1M?=
 =?utf-8?B?aTZUVE84RkJxSGFtczFNbXBlY2xBZ25pK3FuTGdQcHF5OGVteHhFRVpaaXFP?=
 =?utf-8?B?K1FjbDQ4SGpZTERNcXJoNWdpR0JiaG1NOENVMTB0M0xVOWxDcTV5cWlxSnEr?=
 =?utf-8?B?NlVvZm44Tm5mY1VsUGpiT2VxbUZFSk9FdFVOanBiUHJZUWdiQWdEMmNNQVMy?=
 =?utf-8?B?dDd1emZvSy9kc2trSklUMU8yUkNyRkpRc3EvY0JUZE9iamNtdWQ5OFVPQzM3?=
 =?utf-8?B?QXNXSjVSdndpOEprQmtza2I3MVcvZFR6ZjNaaStzT0FQN3h5WjVxWlAyZVkz?=
 =?utf-8?B?YnQ1UnltamRiSzNyelg4MHNrRWU3R2E2TzBTL3dnK3kvVXZ1dVlIc1hSc2dy?=
 =?utf-8?B?b0ZJVkVsRU81eHNGa0RCbHdDbEVBUnd2WXpmRGdldnZEdW9Ybk91SzVvUDdD?=
 =?utf-8?B?aGlwQkNHejlhNXh4R01Idml2ZGZLb2N0VS9wSG04MTB2cUc5RDBoelZiT0ZR?=
 =?utf-8?B?UlVMbzMwYjlIS1ViUkVncGFqK3B3b0c0YmtnVWZMVjNQb0s0V0hUbTMxSDBx?=
 =?utf-8?B?eC9YbFRJOWFYMjk2R1FSYi8zclZrT01iRDNKUW9BSk5vUTNSaVVqQjRrWmVi?=
 =?utf-8?B?YzJ3eUQyYWNRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUl6RUg2MGgwV2JUaVhYcGp2dFlYaU9iK3NRT0VYSytpUlZqMG9pQUpuTVZN?=
 =?utf-8?B?RGF6MWVrc2tHWVBxWFVxU0pPdFFNWktNbFh5T1lUV2VkU1ROTFE2WlhndjBy?=
 =?utf-8?B?cVg5Zm9WZG5iTEdKN01sK21wM2ZXZkhsN2ExWjgxcWFTK1NVbWwwSy96T2lX?=
 =?utf-8?B?d3pmVWhUMmxSR0pBRTE0WHZibWJVRm5xMkNGRCtFNzJNQS9Dc04vUHVCM21X?=
 =?utf-8?B?Uk93NFJFbDd2Q3M1NCsyZkY5VHBHWnlUMGkrZU9rRzZyZVBTT0pxV3VhK3d1?=
 =?utf-8?B?QVBMQmdmUGZNc2h4R2oxNGhjOUtIc3ZEYTF6TGpIV3NRaEREbU5qeis3Uk15?=
 =?utf-8?B?UnZGdXFiNFhGbDVHVDdaekVNUVBwU3ZTLzVQTENuaXpIWVUrNWNJUDF0bjBF?=
 =?utf-8?B?NXNqZ2QxWGZCU3pNNTV3TG1ESG8wV0RpMXVTSXArRThJMDU3RTNoNnlJZ2lx?=
 =?utf-8?B?UitFTTRQUnlTRjJKUUJtSkxLaXlnTlQ5V3ZsUmdUUDljUitUcExpWjY2amZ0?=
 =?utf-8?B?VzFhRGN2M3J2RVFpdlBWWVp0TXRsZDZLN25DN1A5ekM2OEVQeXVUYnBCY0hx?=
 =?utf-8?B?enBLMEJZSm9VS3lWZkNqaWtFcGk2OG4yZU5YY0dtenJMam9mYVlRVStTdmVq?=
 =?utf-8?B?R0Q5anV4TmVQeWpVU2phRDFxTDdvUFdaL3FwWHJJUkdvME1HS0F3NGdtdHFn?=
 =?utf-8?B?bVpCUVl1QXR3TWNtTGhNWFFLMHk5UHU0Y0VVcXdsa2R3Zkh5d1Urbi9vTVdq?=
 =?utf-8?B?N3BxWUgwMndHN2pLTkNXVk93enJDc2xmN0Z4bWZFSFY4RWtCWWtHOEt1QXoy?=
 =?utf-8?B?K3RaTDBmQ05mZlYrY2FZaUFNS0R5SkgzTmxCWVZWY1hyYi9ndnhvYWJPY2Zw?=
 =?utf-8?B?bWdlL2FoQlRiSjNWMStSSEh2TXRUK01ScDVTb3VxM3luS0JMV2NDMWN5Yzc2?=
 =?utf-8?B?S2p6NXpNV1h1Z2F3VW51UUtMWEh5Sk5taFI2UDRHd2JtNHpJaDl4WEx5Y0Y2?=
 =?utf-8?B?RGYvWXA1d2ttc0xjV1hhcUFLYXU2MTQ3Z2o5SnJEcnV4ZFM4NVl5eUpxOE00?=
 =?utf-8?B?QzZaQ09FTjF0enhUK0pjemE3Q1VnVUxqdUFKRXRkSG85VjBFcEJneEMyVlN3?=
 =?utf-8?B?Y0hGMWJrWjM4MlVic1FHQWx0aGVVaHA0eEtKREw2Q3JSRGVTdmg0YzJGK2FU?=
 =?utf-8?B?UkVndlZXb3Rsd1NheTRzYVQyRC9qdlkrdmozVGV5bzdPbkpVVTcrekxMbVhC?=
 =?utf-8?B?NXQ4M1dTejROWko3UWxVeVEzVDQwQWdyT0RvYXNBdGFFVUVMTUhyeXZ1RVJJ?=
 =?utf-8?B?VTJmcGxENjNEaVo3cThzcit6d0o5MUhsMEkxLzFhNjVFbURQTm5NOFB3YlZV?=
 =?utf-8?B?WkVMTTRnenQ2VjNBTnByTTZheWpWUGoybm1pWndxUWRHK0xNckRjMnlWQXNB?=
 =?utf-8?B?WG1hVWk1U0tYY3FvelBNZ29KNzVYN2VVa21QWXNxc25SNlVqUnB4RkZCZnVs?=
 =?utf-8?B?MTg1bXl2cWpWZXk1MU8yOUlNK0YyMk9lOENCZitMLzN4KytPVVhCSUVsTFBW?=
 =?utf-8?B?cWJKSmZaVkFMU2JTZ2pNZEo4MXFNemZ1WlNBOG5rejdQcFp2bzhoSU1yQis1?=
 =?utf-8?B?Q1VWTUcvMGUzU1pjWXJJc3l5dVUvS2Nwd1l3aWdJS1ozVUJnYTJaampLMGw1?=
 =?utf-8?B?TFJKUDc5QkxFbTE0clN4aktzeENMOFRMVjdQc2h4OE55U1pMamxnc0JlKzVv?=
 =?utf-8?B?bFBNSmlnN3VjVzlZek1USXRzeGF5QU1rZi9ibkhQYXRtTzhSdTdHcnhLT3hS?=
 =?utf-8?B?UGlTVTZPUnE0Ri9tV1hIOEJUZ2t1SklUNldOeXJTU2hBTWIxUHNNQ2pSdTV2?=
 =?utf-8?B?ZjRxOW43UDZNTkdYZXlhMGhSYlJyZGY5QkM1WVI0ZnphQjFNNndybG1pcE45?=
 =?utf-8?B?QndLaXAxbm5UeDQ0Q0pQbVdlYjYreDhadE9jTSt2Z0drbmdSK3dzOUJ6QmNp?=
 =?utf-8?B?OGxIczJHT0VIY3NxY0dRUkpCbWk3TVhpOTZnREN0UnF3RUdaS2RpZEhINU5s?=
 =?utf-8?B?ZWlrYml4US9SRXNock9MRUVaaGw0VHd2UXVEbzBwM1IvZ3NzQklubEdOdEs2?=
 =?utf-8?B?a2o4eTFRdlM5RHZzbFFLZVlpZ1VTQjg5dHoxeUVIaGdDWjNEaE5scjgwZ0JD?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c226396e-35a3-46c0-3ece-08de27836ea8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 15:50:58.5958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KO1SNTDVNZHfSBAH4TEYgx1sHj5CfExgb5GYV8Vap5/gi6Vy7GyU517GbX9qy9HHcvcsFMJEaZW7LfvHHOgu6bp6575wI0d2BwPdKrTaZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5D8CD6E8B
X-OriginatorOrg: intel.com

Dave Hansen wrote:
> Any chance we could use english in subjects? Isn't this something more
> along the lines of:
>=20
> 	PCI: Secure Device Passthrough For TDX, initial support
>=20
> I mean, "TDX Connect" is a pure marketing term that doesn't tell us
> much. Right?

Note that I generated that subject for this series during the RFC.
Yilun, apologies for setting you up for this feedback.

In retrospect, a better subject would be:

"PCI/TSM: PCIe Link Encryption Establishment via TDX platform services"

Most of the plain English description of this topic has gone through
multiple rounds of review in the core series to introduce and
re-introduce these acronyms [1].

This TDX series is one of many low-level architecture specific drivers,
and no, this phase of the enablement does not touch passthrough. It only
implements initial link protection details which are this acronym soup
that the PCI community at least is slowly learning to speak. It is a
pre-requisite for passthrough work.

The ordering of the enabling staging is detailed here [2].

I will add more decoder ring to that. At some point the coarse English
breaks down as the need talk about fine details picks up, i.e.  specific
acronyms used by the specification need to be invoked. Granted, maybe
not in the subject.

[1]: http://lore.kernel.org/20251031212902.2256310-1-dan.j.williams@intel.c=
om
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/devsec/tsm.git/tree/Do=
cumentation/driver-api/pci/tsm.rst?h=3Dstaging

> I'll also say that even the beginning of the cover letter doesn't help a
> lot. Plain, acronym-free language when possible would be much
> appreciated there and across this series.
>=20
> For instance, there's not even a problem statement to be seen. I asked
> ChatGPT: "write me a short, three sentence plain language paragraph
> about why TDX Connect is needed on top of regular TDX"
>=20
> 	Regular TDX keeps a guest=E2=80=99s memory safe but leaves the path to
> 	physical devices exposed to the host. That means the host could
> 	spoof a device, alter configuration, or watch DMA traffic. TDX
> 	Connect closes that gap by letting the guest verify real devices
> 	and encrypt the I/O link so the host can=E2=80=99t interfere.

None of that is implemented in this series.

> That would be a great way to open a cover letter.

I think the break down is not reminding folks that this is a low-level
incremental implementation supporting core infrastructure that has
described the "first phase" problem on behalf of a class of these "TSM"
drivers that will follow. English is needed, yes, but I do not think we
need each submission to recreate an intro essay from the core
submission. Yes, we lost the link in this case, and that is my fault,
not Yilun's.

> On 11/16/25 18:22, Xu Yilun wrote:
> >  arch/x86/virt/vmx/tdx/tdx.c                   | 740 ++++++++++++-
> >  arch/x86/virt/vmx/tdx/tdx_global_metadata.c   |  32 +
>=20
> Let me know if anyone feels differently, but I really think the "TDX
> Host Extensions" need to be reviewed as a different patch set. Sure,
> they are a dependency for "TDX Connect". But, in the end, the host
> extension enabling does not interact at *ALL* with the later stuff. It's
> purely:

I feel differently.

> 	* Ask the TDX module how much memory it wants
> 	* Feed it with that much memory
>=20
> ... and voila! The fancy new extension works. Right?

Right, minor implementation detail of new ABIs. What does a "TDX
Host Extensions" patch set do that does not introduce new ABI? Linux
should not merge a patch that gives resources to the TDX Module
independent of a intent to use the ABIs.=

