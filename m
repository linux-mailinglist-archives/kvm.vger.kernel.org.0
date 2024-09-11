Return-Path: <kvm+bounces-26600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD06975D75
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 00:57:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BC3A1C21863
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 22:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3AF1BDA88;
	Wed, 11 Sep 2024 22:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V0K4DhnT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CE71BC06E;
	Wed, 11 Sep 2024 22:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726095352; cv=fail; b=PZvdYPXCeN3b7wOzmu7VAR0mKnAYDhYv6rpPuSCDUnTw6/VLYIBy28mVA8afp0DXt67P0KvQm46VkovJcYrhaP4kyVk27O2wkJsQ+WPnQiVH8rR8+QVUK+Tbv4z8WoW+Gg4RpN3tE9T4WXp311kbYwbQgOEL6QRgt/bqfVDX0wI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726095352; c=relaxed/simple;
	bh=58euDB5bDX1YBTbdErY4IUI7BZpgcn3jNCrqN9v7eCA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nlsLXdtvyK1ntvlizwC0rW3gMOi/2sj7J4ojuM7Jvuzk45TTCgwWCB44Gs28femMX9TYAMskkiYpf/S7Kwl38KOIEsHoiZVDIO7TlCDy4fVV7dzD3TYkhxxZYaGCjxrNLRc1AQ49/qHZDvosO/M2KlvWELAnb+kGYxffGnZVQHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V0K4DhnT; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726095350; x=1757631350;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=58euDB5bDX1YBTbdErY4IUI7BZpgcn3jNCrqN9v7eCA=;
  b=V0K4DhnTQ2PmHglq94tZJ12A03pqzbhwGEPkSjDuGOEUZGPpPiBi47IL
   OTE1wE8tbcr4yEPHFrhzyojQAWetRiNGiksK1YM3c7yCykdjdtEOzzbrt
   x0q3yczXwHUXsKOQayNG9I86Ibxc5zpHXmb5aKN8JwcgTLNeBvnwLnKmh
   SFU9kyvSz2arsIbVjaEchKEq1gUdlMqKYOZ8V7QoyG1hjzCIlBfxTMunn
   mDPi/wv4mR83+xYQAdacYpP/NkUEjklYJK/rG46Alxi0IlTVBptJ4CYp3
   Yn+m2VUtzaeYEFgm1sgY/eHVAd6X/gr7YFLbG3JsD7V+m8bPv16WIuR6V
   w==;
X-CSE-ConnectionGUID: otJKxBsiTMW7wjV9A4a8mQ==
X-CSE-MsgGUID: 2qOufkHXSsi3ITM47OpN4w==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="24859433"
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="24859433"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 15:55:50 -0700
X-CSE-ConnectionGUID: L4pVycPqT4WXv5C19ad7CQ==
X-CSE-MsgGUID: yrVnAm4DRIyoZuNKd1yzVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,221,1719903600"; 
   d="scan'208";a="90764158"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 15:55:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 15:55:49 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 15:55:48 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 15:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2/bck5S6s1ddu/GIDu0cY2Wr7wafvi8KwExGkeHoaqx2vo5oUZY2nIpkdjw9jUBhQihygEnHlmscafYVPGQPRGB6beEjFt8v1UrXOeq1EWmJDq2cMx03CErIppdtqSE18dqNPigCqi9rpud3Wy05vVz/C9Okm4eVB1qXdRF9Qg5dsERsl1CEuMh9jLa1of6T8opL0cT0okZwxYh/s3fn3C3PQJTYjtl5BvFgdUrGf1zRPSHtTfCz/NMv8x0WtQa1YCvXjrhpDpPLqFR7q/a6+DOqm1zukizKN0Wu6xiyUVEfoh8sHTt8SdK6dv6xnPSqNKx0y0DDAN3FLSOWDLcgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F79Buzr+/5DIp8SvOkJqkRgRcie14+HsFY+hGDh6uKs=;
 b=lVP0p/nBb4nIC7QIVuRLtJs8keo2nvhQLvLC9IoVwEN9HG9UilaMaFoAcmyut1p+4shrTRcxNQ5WVJOSCmfrmA+YU+dMDsKBEAT4vlI3VymecMM+NBJ5CnGLqkjPgFiwUA3SU32FgexcLUe9wnlbkG/eCHuCJXNTmpzOaqQjph/Ay+UIrSsN56bOM+d7Cy1UXBASG66ruSsTVIklEYm7YiRQiVA4jn0HxUMzWXcFeczptMOtaEse1dMHFDGuGhZjXLgLkfE/ttlNNyKaTvhQvN+erOP0lV6ZLPWhyd901XjiQcfTU71lt+dL+gUS/tI0CIyFQ1oAJrLOI1sO7QLz8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB7551.namprd11.prod.outlook.com (2603:10b6:510:27c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Wed, 11 Sep
 2024 22:55:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7939.022; Wed, 11 Sep 2024
 22:55:45 +0000
Message-ID: <abdf8379-1b34-4534-b8c9-d5ef55635bc0@intel.com>
Date: Thu, 12 Sep 2024 10:55:39 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"dmatlack@google.com" <dmatlack@google.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com>
 <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
 <Zt-LmzUSyljHGcMO@google.com>
 <8618bce9-8c76-4048-8264-dfd6afc82bc6@intel.com>
 <5f7ee34ca34bdfcc9bf8644b66d05b10cc2d42af.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <5f7ee34ca34bdfcc9bf8644b66d05b10cc2d42af.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::14) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB7551:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a672c0-6405-4dc0-a198-08dcd2b4defe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?S2E1ZmRvbVIwLzFGZDFsbldyUUUzRmp3aEV4WFU4ZjlQd1c5SWhkTloyRFNB?=
 =?utf-8?B?V3hscWE4YUVMaHoveG1xUXdxNzExckY3QmszRnlSM0JvRms1WjBTVjU2L0ZO?=
 =?utf-8?B?aTA5VjdMb3FSRy9vYjNwaHBka3NVVk4wRDNzTGpDQ1NycVpXK0xxZHhFMzBx?=
 =?utf-8?B?bUVTVjVkelcxdGdDWFVIeUIxc21PTWpIQW52aEhkWGJZQ0dJUWhuSmltcU9h?=
 =?utf-8?B?ZDN6elRyQVJ5MVE4SzFQRis5a1VBNGptVEtxLzN0akRiMVpEamcxUWVuelVl?=
 =?utf-8?B?U3dqaWZsZGs0dmNGZUlyMFVXejJoVDVmbzMwdkJMLzBrVXBHakFoQXVBZmly?=
 =?utf-8?B?MVBEZ0o5OHVQZUcvWHdVYnNyS2VNYVNkcThBQ1pVNXlkdFY1SVNTb1BwVXJC?=
 =?utf-8?B?SUh1Mk85MjBDK0Nqd044akEyazJCelpveUhXNFRvR3JTdEF5cjRXdmtabHpS?=
 =?utf-8?B?c2J5TzIyS2VvaElSR0FWMTVUdTV2T3pZQnZjcWxuV2RwSVdnUXJGLytxdVNy?=
 =?utf-8?B?RVRqR0ZDaTJqZ296alZoc2N5ZGxqSVRnZGVkZWtoei9QVk4zTUVDMXNuVGRv?=
 =?utf-8?B?Y0FVa2pKZnBOTlNzN0M4TUoyanVxMXR1Vmh3S3d0M3BTbUtNTytwbDQyNVp2?=
 =?utf-8?B?T1UwVnRDUXBXZkhMa1VuR0ZHOEQrOHpjN0lMU2IrYmJ5OFNPUW40eXRQeDFa?=
 =?utf-8?B?cUQrZXoyczBFYXNLOFI5UHp2bWwyVTl6Q1BudjBPVUpLTXlTL2dvUzV5SXdD?=
 =?utf-8?B?ZktUQWtPUzc2aytpa3NKeG9abEFIcE9pakpNMnhzK2t2a09ja2M4dHJjMTNM?=
 =?utf-8?B?U2R0azRsTno5TEcxbjF4NDdVN3NKOWt2NnJIWFFmSjZQdTY4Z3JUa3IrUVJE?=
 =?utf-8?B?Z0hNWHF1MElaRk8zRENCRk00NFhiTlhNQnF0RzFRdGQvM3BIUENtc0liN0xz?=
 =?utf-8?B?bzA3R0llNEZYQi90QUsrZnhBWWFaRnBwMk5PMnpMZnBkVjJBRlVvRGxnUGFs?=
 =?utf-8?B?SDFYVCszMVBtSEV1R3dUak8xUzBienlJMXg5R0x2dmJ5b2V0TEhqZEw3WlBo?=
 =?utf-8?B?S2tGNjZQWDMxQXQzeDMrajNBdXNOSmY2VXJHbWs2NC9rV2NmTkxRdDRVekpK?=
 =?utf-8?B?KzlRT3YwYTBBWWFrSGZ5M1N1K2VmU1Q5eEczczNmWFBidDRHWDF1NkFGRSs1?=
 =?utf-8?B?dTcvVXpWNVpSWW83allrUm5DQ0EwY3RDUXdVQVVKNzNyZEh4dDArVFRsOThR?=
 =?utf-8?B?NmtzOUVQb1RPdHZGUHVEMlBaczNNWTllT2M1OUUvUXM0SEs1SVBFbmMzaFlj?=
 =?utf-8?B?R2NEZDFCejBSSTg5UWlWb1ZrL3lEd2prUDJYa2tRRGlpSFhFS3loMGNBS29D?=
 =?utf-8?B?cGQrVlNsNzA2UHNqRkNYaG5sQkxMWlVvYS81cHB4eWFjT2ZlcURsMC9wRmdo?=
 =?utf-8?B?SU12RXZiWng4L0ZyREttRVZEeXlnd3hqaXQwVTZCdUNnQTgrQ2o0MWt2NHA3?=
 =?utf-8?B?WUpTazBkOU5paGJBN0lZRm1wOTUvYmJCdXJsUU5nWm11YW9sN01MSlVlSkxv?=
 =?utf-8?B?U3JJSEttWHNSaHRFTUcwR0I4aWpwTHZVYUF2TUxnWGRjVWRtK1BaV0lPdWVl?=
 =?utf-8?B?ejdhMzQ2cENZYXRROVBCZERsWGowa2s1TjYxTERKbkQxVTV1UE9yZ05XTG5q?=
 =?utf-8?B?UXo2NmhXUG8yNGhvd1FQaE9sbzVUNUg4VnZWalRxcXRaWkNxaXI5a1hFYmFT?=
 =?utf-8?B?eFpBbGYrdjlRNmorVisvSEFCWWhhRXpVdGMvSmltZ21sWnJFUHNQRHlmVzQw?=
 =?utf-8?B?TERKV1dSTlN4QzY5TWV0UT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmVkTGhLOEx1L2VESzRZbmZDcTAxam9qVHlqM3J6eUhXei9tUjYxdTI3TXMw?=
 =?utf-8?B?Slh0U2FRa2hpNjdpQ0VZbUl5OEpzWm1CbkpOU2hHY25BTll3VWx1ZEZ0b0lo?=
 =?utf-8?B?UlNWWkU3M2RHYjVZNEJOamQxWnA2Uk9RWFBCbUVDc1orMnQ2bDVtVWFnNnpS?=
 =?utf-8?B?bFR0a0kzaVg2eUxLbW12YmlDZk40NnJuTUhUNUEvT2xLdk5saEF4VWFWUVlt?=
 =?utf-8?B?TVRkVkJXZkFlQm9pRWF5ZTFuK0JZRkxtM0t1aTFNajBSdEFFMzdkdjVRWnBi?=
 =?utf-8?B?bnhKcW5nU0RNZGZNMEo1VDRaeDlNRkRKbHhQZWpKSG50Q2E1RmI0dWozU3R3?=
 =?utf-8?B?eXNMRTFjUi9UUkpiMG5ZVmJLdDJ0WDZienFBcFFvRXJBa3gxd1B4VnQ2Vjgr?=
 =?utf-8?B?ZWxqc1FlMWR1Vk1qMUpXVE4yS3hTOTNKRWtxUHdhM0Mzdk1uVHVGcG4wYyti?=
 =?utf-8?B?TWxyRnMyZnUzTkxGRE5HQXYyS1FqeFVRNlVOeEtXSzFKZ1podG9laVBsQmNm?=
 =?utf-8?B?dDF6N1RPaTdhb1phZnZVSTlaMlNrQkhkQ0pvWitSTGZaRW9hTDM1WExqWDRm?=
 =?utf-8?B?dkZDU2tXcjNTS0lFaTZLTVpHcWEzdVR2TTg5L1VkU0grNmtsQ2dzckR4WXQx?=
 =?utf-8?B?Ri91YThOYWJDalFuN0dZNG5maDVtemg1aEhCdzd1Y0NRY2xNNlpRLzgycXhP?=
 =?utf-8?B?ODBtR3ZQeEQydGxzMnp3a1FwZFhyU3l1STEwY2txb1h6VmE0Vmk1WnA1b1ll?=
 =?utf-8?B?ZUlEdWF2N0w3M1doR1hqcjhGQ3VVMndjRzFGWXVwcGNmd201R1JOeVZnMnI0?=
 =?utf-8?B?a0dZYVB1ZndaTmtaaC9mTDV5Y3dPVzJSeVJuVE9oYmpUTktDaDloanEwU2NQ?=
 =?utf-8?B?R2NMcWE2MkdhTExDemtnaDFHa3ZSWGhWc0NZa1RUWjJ1ZUt6U1RPRVdGUjdW?=
 =?utf-8?B?cXJQQUZtM0p4dW5Uakp4cGxPTm9DU2dsdHZ4VVAxU1pnWUx3VDJmK2RsdjFE?=
 =?utf-8?B?K2RIcXk2Y3k5cFNWcDM0Mjh5NWthQXpLdDV4T3Y4SUNzVytTMkY3Q2NJZENs?=
 =?utf-8?B?WldTQVdFNU5Dczc1TG1OMnBSK1dMak04WkZ3YlZFdTVzZTlNU3NwNmtWZGM2?=
 =?utf-8?B?Q2RpcStrTDkvMW14QktwaXZ6VUU2NGg5UEcrWDR2dEo1RWFTb3V0RUNBazNK?=
 =?utf-8?B?Qk0wUUxjZVdpRk9XUDBPZGM2SWpaa2RCWEFvY0EwTjRZVmY2S3h0T3J1b1BZ?=
 =?utf-8?B?bkgwOVFwcTFXQkhwNXM1Q05mejRyQlFFNENZVFNQRnl5UUNkWWhXdnJMOGxv?=
 =?utf-8?B?K3dmb0htUHJJcnlESUFaVHI0MWpjZjYzcnZ3aTdkTENNYWxRdnpLMU9EUEll?=
 =?utf-8?B?M0pNdTdMcUZQSndJOGhYRk1YOTMxSXp5cHNlRDhwMUpXSmJqZ3RkdTZ2dDBF?=
 =?utf-8?B?VUxMWG5RcjUvajlrWmY1TWVOblV4MjZ4dTl2Zkx4L3lGSVJ1NGdFdHVFL1N0?=
 =?utf-8?B?MHA1a1Z3RjhQM2ZndDZkOUIzbmJaYS9UZlZaYWJ0emh5WjhSZzhzclU4QzBH?=
 =?utf-8?B?bEtlSkpPVVZuNDVLTExjRUN5RUYwMWg0NzdXM1gvM3lYOUFWbHhZYmd3dHVq?=
 =?utf-8?B?UVZRRy9xdG1idllYVEdBT1JNVFFvbklISWNnd0xhSUt0cG41UTNreEU3d2Fh?=
 =?utf-8?B?UjNEL3BHVlMyR2hHNis2L0NNajltdzk3Q3Zha3RhcTc5TnRwMlJEL2JEY21r?=
 =?utf-8?B?QlVObW82dlJaYzc1RWQ3WUFXUThud3grUXNBUGpZS0czSlVZNmJxZHNPdS91?=
 =?utf-8?B?RkhZV245Q0wzS2d4ZXEyT2psTHlXU00xaXY2aldqV1NTSHVXVHlCaThXc1lJ?=
 =?utf-8?B?UFhUVkl2ZVlmenZ3MlZ0S0lZUzIvRkZNTVVycUN5bWlZbGtBZzJVS2N0RGhz?=
 =?utf-8?B?S01lUWhpUzZSU2s4MC9mbXlFMGFKN1RzdC9vOGJHSUx2N3AwazJhNGNhNEkx?=
 =?utf-8?B?KzF2MVplWXF5TzB2UHdnMGtlWVo3eDd2TEU0QVJVcm0xNDZNb1ZNR2hObjk0?=
 =?utf-8?B?WE4xSGxqeFJzTnVReUhKQmRvQWROTWFjTUhMaTZKUjRHdFZDWS9STGhjWVBI?=
 =?utf-8?Q?lvUb6k6hjx77xpVFuV9fwD/La?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a672c0-6405-4dc0-a198-08dcd2b4defe
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 22:55:45.8434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dvZ2CK59OimzJ3yZEyS0OEdyaXFcyjz0YEwTvzoxVzaf317Uiw8JC5laDdUpnQk2ofT6art7y6KqKHFODxz8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7551
X-OriginatorOrg: intel.com



On 11/09/2024 2:48 pm, Edgecombe, Rick P wrote:
> On Wed, 2024-09-11 at 13:17 +1200, Huang, Kai wrote:
>>> is the VM-Enter
>>> error uniquely identifiable,
>>
>> When zero-step mitigation is active in the module, TDH.VP.ENTER tries to
>> grab the SEPT lock thus it can fail with SEPT BUSY error.  But if it
>> does grab the lock successfully, it exits to VMM with EPT violation on
>> that GPA immediately.
>>
>> In other words, TDH.VP.ENTER returning SEPT BUSY means "zero-step
>> mitigation" must have been active.
> 
> I think this isn't true. A sept locking related busy, maybe. But there are other
> things going on that return BUSY.

I thought we are talking about SEPT locking here.  For BUSY in general 
yeah it tries to grab other locks too (e.g., share lock of 
TDR/TDCS/TDVPS etc) but those are impossible to contend in the current 
KVM TDX implementation I suppose?  Perhaps we need to look more to make 
sure.

> 
>> A normal EPT violation _COULD_ mean
>> mitigation is already active, but AFAICT we don't have a way to tell
>> that in the EPT violation.
>>
>>> and can KVM rely on HOST_PRIORITY to be set if KVM
>>> runs afoul of the zero-step mitigation?
>>
>> I think HOST_PRIORITY is always set if SEPT SEAMCALLs fails with BUSY.
> 
> What led you to think this? It seemed more limited to me.

I interpreted from the spec (chapter 18.1.4 Concurrency Restrictions 
with Host Priority).  But looking at the module public code, it seems 
only when the lock can be contended from the guest the HOST_PRIORITY 
will be set when host fails to grab the lock (see 
acquire_sharex_lock_hp_ex() and acquire_sharex_lock_hp_sh()), which 
makes sense anyway.



