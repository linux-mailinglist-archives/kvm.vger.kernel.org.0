Return-Path: <kvm+bounces-53253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0E4B0F4E3
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:06:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 221E018934A8
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4C12F2C4E;
	Wed, 23 Jul 2025 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fnLx2uCo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB4221F13;
	Wed, 23 Jul 2025 14:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753279573; cv=fail; b=VTPLGrKoqSWaZBPl/aP0hU8L+DOFB6ofFesA7VNQP+CK8PcnxPHw93YMiVP2HqyC08Mmqn91K4MtObPJJR7ANvGu3k8PvR3I1U+l2JuGvHVBFBra2dvObOrwkMLELtH7i4taJ+HZ5J2LFGL4R2YzPTo+rpnzIcz4oRpTjH0OFuk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753279573; c=relaxed/simple;
	bh=enrDtxD3BtvXHqTSosMPPLiXRn8aiyChKLQV3BC0roU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uxuQYz6+mTrtaHBP73kEsCcwDK4qWqmAsUGjXmYHFOzXvwl6s3xN6gCOyfsYWiNL/8jnGITIOs3I3efV7KIAmZVI34QDdgPvYUNJrL8EoTFyEBOazWR/y1ImcC5Tv9C8boLivAo+YYz3RVh7twrHD24Lso0IPH+5wJvOkCV2Z/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fnLx2uCo; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753279573; x=1784815573;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=enrDtxD3BtvXHqTSosMPPLiXRn8aiyChKLQV3BC0roU=;
  b=fnLx2uCoBzeqkd14B1Ud+62nIu8iCxslEPqIlVqexnKdSYBcOUTRhx0t
   jQlnHhrsjEsM5RlSkMmcQRlmaOOqTe7hebCtfM8fzTDzArdJDpv2RzSGj
   SMknJ7U95xfwG+KrAnZOErYOwKf9HswAUMntg9RV+Gq9cNI/XC8up4jxf
   bUajNk3wITnU8v1Zqv+8NIfswDILcJCBQFSUieA8sZ8ub2qAbKs+zU6By
   g2aVcmbfXw3d/Yistju8+K0E9VmqLbNXcqub74LVG0L74NfS6hAFvOAjV
   zeWEOAWczR+XiG40ZfJXBpauVLwz+0B95aFLZL/5Sa4+htgq+1Pt65YVv
   A==;
X-CSE-ConnectionGUID: 4zrkWrujSX+N3aYVnAz9GA==
X-CSE-MsgGUID: ooG7ln6lQvSYd2eUF81H4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59366548"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="59366548"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:06:10 -0700
X-CSE-ConnectionGUID: ftJeimhCSGyIE98FtEbS7g==
X-CSE-MsgGUID: jrZA7xjtT1+aj2lrBpi4/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="160073742"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:06:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 07:06:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 07:06:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 07:06:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/kLAjnxvpnb0Lfc8bSyLqTxH1XiSpXh67PrkvMBXIZ+dS1D75c7E9ytgEUnIK30xaaAgaY1cqDADtQ1yN/vEKm4sXKpRC5FCeRTCmzjQ66LDHZuVtpimo0Rf5+XJZQbf1PamEoyUq0M6pj0LE6y5j74nydXbZraADkKpHYHiJr7JDO7C1cdnMM7kdJfWCEsaMVyfyWtr5jUOkMgfLA2CwCrXJy9eAMSifjTUhQmx21oe5o7CL4o716kSlOTmznwsaaJvfoLCL1I1PsOqAK8UYbtlEHNGQFrx4Jc/KxGoN7gF0Zk8Xqev8NEnCzszrgeq+/XKDUjDXLWjOgbvMoWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enrDtxD3BtvXHqTSosMPPLiXRn8aiyChKLQV3BC0roU=;
 b=Hho8T6bVl/9proVp9LFoIcNCq0fRkwp2uX0l7j01aJVrtzR3SoY1KmaEkMkTSgEFmr7jCbXVgDsRl7yIs4nNOJhiBmUReYt1g55BWc1yXYygSRyfryp49Sg7JqNNSrZ/LfSTQgk7UuixlMswa0e78CntXBk9BFuAOU+ra9lSpaCC1yRQNrIWrtRFxQ+o5tcNMllaa2cTtvhn0y1AOlKHcze5rzoN1a47MNrnTaDDP7Ymasgx62+bfLvOU/xtNBfGW9uhfbUXWZPwqg3LuYAUnn9OUEkbHX0FYhX6PA4ETTnjibrlgxG6sfVaQ2hd9H7joQi2DmNYBMyP5/DgRULfNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB6789.namprd11.prod.outlook.com (2603:10b6:a03:47f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 14:06:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 14:06:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovx0yLPSIy6USdKkSakZSGBrQ/vkCA
Date: Wed, 23 Jul 2025 14:06:00 +0000
Message-ID: <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
	 <20250723120539.122752-2-adrian.hunter@intel.com>
In-Reply-To: <20250723120539.122752-2-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB6789:EE_
x-ms-office365-filtering-correlation-id: 9c43bfed-28cf-4c88-718c-08ddc9f20d91
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cDJReURUVklaZ05IM2NyUkxpS1BFemt1dHpWOWJxbU5ISmpsSjUwWWIrdU5I?=
 =?utf-8?B?Tk9PN0M0enpMMFVPbWxXTjhrdmFReWNmQythQUFzeFpTRDVrRTg2bzZnU2Jo?=
 =?utf-8?B?eTNtQlhGY1NUQUs4bnkxSjU3QzNqMFVIeVJXdGNhdjB1SkozeFNvSDNhWnBP?=
 =?utf-8?B?QWJlb0tBeXdOVmQ4ZUVXY2ZvK2xXNm5yekF3aFkvOEZEVFNUYTgrdG9ZUmcr?=
 =?utf-8?B?eE5VVHl2cTB5MzB0YVV2eVdVeURRMzR3bVV6NGNXSHc5TjkyaW8wOVlZakJa?=
 =?utf-8?B?dUZ0WEhEL3kxNEtUb2JhZVZ0MFhqWnM4b25uRmc2QXJabnVUMjJsdlZCU3Vo?=
 =?utf-8?B?aURxVWpibmNra0tvdWRESjdPQ3Brd29jZ1hFZXNBcFMwNHkrZWR4RjhsR001?=
 =?utf-8?B?SUN1aGZwVDlGa05uYjBGRDdxNk40RGVuR3BlSEl4TE5zY1JNQUU0dEQzREdo?=
 =?utf-8?B?RHRYRXJpL251UXNscisybXkxUy9SSUovS2s2RTAzMVRtVUdDYUhDTHNyWk56?=
 =?utf-8?B?eG03ckpITDZpdGVsdWlkNnF6SU1qVEFZYklaNGJwZnFhWGFWNUtLd1pWaVhy?=
 =?utf-8?B?UFcyNE5YdWsvazltbmY5QWhKb2NGSmE5Z1FnVFl2U1g0SzFZSTFLc3UxTzdG?=
 =?utf-8?B?RXJ6WCt5S0tISm5HT2xhUDlyekRocW1FNmhsUklVRWNMS3BON01HRmVyZkI5?=
 =?utf-8?B?SXBPWkllYU0wTk1FVXdpK2crb0ttZUhFMXdJbVhna3F6cVErcmZhZTQ3eEpD?=
 =?utf-8?B?RDlVSVdqSllPcEZPMmQ5YWVuQ0E5WDRtYUhDNGhDZnpGYVRyZ0I2bGNyNmts?=
 =?utf-8?B?N1J5SHh4YzRoVHc2clFUQVpKd1lFeTdqMGVpVFY3S0FnU0ErVWdpTDkwbUtO?=
 =?utf-8?B?c1NqalE0dVdYNEk3eFBOV3hPRmdiTTdGYUlSdWJsNndscjhCcnZSV0hHVzRt?=
 =?utf-8?B?UUdjT0FEZGNxRjR5RFJFUUgzTGRvalFXZ2wxbE1HWEhQYWhLbHpRb2FVOCtN?=
 =?utf-8?B?WFdFaTNxNmVIbnAxM2tOYnp5ZG9pL0lmamg2Wlp0SW8vRjE1LzdWZlp3aGZZ?=
 =?utf-8?B?OFVEdnRjaGduOUxiUWI3aTVvQzRWdDNVWVFQOGdRMWZkcU5mWGxnM0hITDR1?=
 =?utf-8?B?RzlBQXBVVmtWWjBkRnhsU2FPR2ozUlMyaTdHandzRUtHb3lPTHhlNUNIZGtl?=
 =?utf-8?B?OVJwUWROZmZGVGc2cUsyUi95QjNXaENRWEdZeWpWSXYzS25sMFROcHBWSW1h?=
 =?utf-8?B?bFRnRzhQS1lVMnBndWRiY1l0R2w1MUFLMXNoSVNXNlJUK1YxWTlvS3l6MmF4?=
 =?utf-8?B?SUwyS0RVSFQ3QW1QNUdxbGhmMjZmWVZqN0dJZ1NqWmlqaWZMWWd1cVFvOFBQ?=
 =?utf-8?B?MHo5d1hGUFJYMlM0bHczTFMwQU91VXVEOEVwek5QL1RlNTZlN3VLWGVVMVFB?=
 =?utf-8?B?Zk1ncHU3dFpoNm5vL2VOaFNzK0JpQ0x1Q1IxK0NNOTVLN1EvekRzVm10U2N3?=
 =?utf-8?B?YkR2ckJId0FqTDFkcjFaOHFKblphSWpnWXd6RkV4cEE1Qk9IQVllSVJhT2xY?=
 =?utf-8?B?aXFwa1hobG03RFRLVEx4UDMwcWhWUjBtUFpBK2pzSFJYRXY5bVRUK29YQWRO?=
 =?utf-8?B?UFg0cVpleCtpMGhPVG02Mk5lbGRicUZLbEUvRDFvMUc3bHFlVUdoTkdLb1pK?=
 =?utf-8?B?aGsrWmNubUo5WHJDSHR5UTUzNE8wd2FudHlQUGRLc3pydFM2akY1Z05DNHRX?=
 =?utf-8?B?WlEwVlk0Y1RBNHJDMHljOUpZY2FrWFZPY1NQSm9scXhVVWVtS2w3alc4Szdk?=
 =?utf-8?B?aE9kVkVVMHB0L2lwNExtOTZNNE1BUGdOOE00OGRKOGREOVlYUkQ5VTJkZWtp?=
 =?utf-8?B?aGtCOElRZzl1dTFULzVRMG13eVNzV1p6eTF3TmozVTJTWk1YVytadzBXbXBr?=
 =?utf-8?B?RUpCNjAwYTNYNXdhTWk1bkJlYjkvVXZoRGd1aVF3VTM3NXNFNWJ2UlpNTUo2?=
 =?utf-8?Q?54UAcV6sksdmWTww0UaZj7WCwrkcFE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eklETTFISUtPbWh3ZEtNVis0ZG05c1hURHhjU2FCVE9lcVRNdGcvbmVUUjZh?=
 =?utf-8?B?QitVdFZodWJySFlvNUx1TlBrcVFUU3NUaXFGdDNGWlh3MjhQVFArVlJHOHF2?=
 =?utf-8?B?enBoL2hWQXhnTzFiRjM0VlZrK3NxM0NyejRaWmdGeVpIdzAvWGxodGgxZXJN?=
 =?utf-8?B?ajM0RE50dTh5Wkp3VXRHR1VwQk1JT2h6WVVEQkhXbnc1Y3ovb3BmSEwrLzAz?=
 =?utf-8?B?L2hJYjdsY2pjckVsWDNINFpXRUhjMG10d3Y0S0M2QXZIV2RPN3FQVVRMTmxV?=
 =?utf-8?B?QXAwbkhzL1ZyT2tSYURxZTJ4anZlSWJwcmpyQTJQRTlRRHR5TjJEUWlUU1dt?=
 =?utf-8?B?M1B4QVZJSmtJUzlJNTU4QzNmLzMyQTgzSFkwU2wzRnl4TlEyVDJMNFFwaXJl?=
 =?utf-8?B?c3JIRnFlSDFOa09Ta256V3QyLzBicG93cUtSQ29kYlI0aWhNejlOQUgxYlR0?=
 =?utf-8?B?QlhLajBkcGFFZm9xbE03YzBxODhLTnVxcDlaL0dmV09UR01ORFJhcEJGSlh0?=
 =?utf-8?B?cVQwMCsvTXJQaTFEc0xHdlQ0S2pLUmMxMng5ZHc2UkhBTUo5U2U1dHBVUGZR?=
 =?utf-8?B?cHVlMTNqZmVUSFlsQWsvYXByb201MDN2Zy90bk1lNENJWWFGVnA0SDh6WnJn?=
 =?utf-8?B?VkRsaFBsODRxalVMMStUVkhYKy9pNWkzZ21qOWFjZVN2VloybTZWdFRHb2My?=
 =?utf-8?B?Wmt1blZLWnFMT2w5NjVEZXIrZ1FPRzF5Rk5OYmJ3K2dzanA5b3pCaVg1RHNw?=
 =?utf-8?B?MmZETHI0bWlqNDd5L2t3OVY1bzJZUGJ0dDh4My9RKzg3UzVSQWxRekxvLzR3?=
 =?utf-8?B?VVBSamE4MDdOcWszTG9uUndlc2dBZkRUcmRKb3A5V2oyQ0twODFSQlQ4WTJi?=
 =?utf-8?B?cVVnZy9XRk4yWHhHWUVWQlQrT1BiRmtsTk5XcVhKak9lWHpGMUtXWFBGQXhB?=
 =?utf-8?B?aDJVdzY4K1pPenJna1RHYm9xdWNTVVpBa2VxZGh6bHgwbi91SnFHbVE2NTI5?=
 =?utf-8?B?dGxIMHdvUjhzYjVWT2RmNXcvcThLWWZ1QzhqM2VvUUx4YktsSTNZbWpnWVQ5?=
 =?utf-8?B?UytQMU5wWlhjcHVLUUpjL3lKTFVTNHRkd3hTcHhMYVVqbVZUY0NWb1RzU3E2?=
 =?utf-8?B?WU42OUhUMHZMUWx5bW1lTzQrYWJDVUtKaXZTZEZEV3hTaEhadTA1eGdxYXZP?=
 =?utf-8?B?eVVDM3VnbUNQOGJpcWdwN0RsYzlUcS93OG1pV1VSZW4rcjVoTUQ4RTFldnFJ?=
 =?utf-8?B?UzAwdzYzNnRGeGdMVDB6d20zMlRTVmYrc1FUNmpwSHpJclpIbVBFNEtjQmNl?=
 =?utf-8?B?bitNT2cvbGpUNm85NGdMNlNBQ0cxWkFjcy84WHlsZVpGWjBFMis5UWkvSysw?=
 =?utf-8?B?WjhWZnZ2NEFxaEVzbjVDS0hHRnlOeGU0K2o5dUFuZUxhUUoyeWJ1dGJEOEIx?=
 =?utf-8?B?cGVlY3ZzdWc1bW1YbGEwaEV6QkZDdUUzZjU2NWNGTzA2bFYxMmFtTy9JN3Bx?=
 =?utf-8?B?SDZaY2sreGs2enA4UFpKbkF6UzU3TjFBY2J4QVlqMCtEekFjN1N2a1AxTG90?=
 =?utf-8?B?WkRXSUJ2Y3RpYU94V0VnTmpTYmxWajUxODFxTFlSTmRzakw4MWt3Wk1PWUJH?=
 =?utf-8?B?SFliQTBxMys0dkZBOVdTUUFzV3FVOE1RanR5Nlg4dU82d1FpVlJZWmlWMnJ1?=
 =?utf-8?B?eHNUMmxDbWRYSTJGME9tNjg5elprS29sM3BqUFAwcndxU1UvSS9rZTJQNzln?=
 =?utf-8?B?ZFM1Y1N2S2h5b0F3RW5ybW5hWnpCQ05YVFI1dFhKZjdwbHFjdjFYOCtWWk9Y?=
 =?utf-8?B?SnNmNUUwajg5NE16bmQvZFFrNE40UHlsZndYbW1xV1VWUkczaVJjaDFHQlYv?=
 =?utf-8?B?bVRjbmNsaW1Tdk1pZjNBdksvQXB0alNTT2pDUUJuWGs2VSt4ZkZkWVNKUFpC?=
 =?utf-8?B?dXg2TXRDQ05xY1dDVXVVN2FKUS9CcmE2cXd5c0F5cXNiY3Vib2xkOEY0bDFP?=
 =?utf-8?B?b2VJSkdZTmViYmtmZDFCWjcwYjF3SVhiOEhhSXhzQUl0ZHB1bmU1UE9sM2lk?=
 =?utf-8?B?SVFOSUxRNmFnSlJ0M012SE4xZ21LbW9pa1RSTmJkTUlZMHo5Yk5MQmdhZS9L?=
 =?utf-8?B?ejNJbDY3TERRSm5FZHk4NW9Vbm1vUXN6Z1Z0MHptSXduWFE4OFhWeWM5dC9B?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1FB228E2252E1642A9F47404FA62E3D7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c43bfed-28cf-4c88-718c-08ddc9f20d91
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 14:06:00.2868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jucjLGM4frkrk/kTssPLp+XUJz3vwWVlRhYOu4M683gIhF+YpNm9gSN8ZC9II7jCrW2ix0uy4OmBECBw72hfBFAC0ndYO9KH1OKaYWzztKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6789
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDE1OjA1ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiDCoA0KPiArdm9pZCB0ZHhfcXVpcmtfcmVzZXRfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4g
K3sNCj4gKwl0ZHhfcXVpcmtfcmVzZXRfcGFkZHIocGFnZV90b19waHlzKHBhZ2UpLCBQQUdFX1NJ
WkUpOw0KPiArfQ0KPiArRVhQT1JUX1NZTUJPTF9HUEwodGR4X3F1aXJrX3Jlc2V0X3BhZ2UpOw0K
PiArDQo+IMKgc3RhdGljIHZvaWQgdGRtcl9yZXNldF9wYW10KHN0cnVjdCB0ZG1yX2luZm8gKnRk
bXIpDQo+IMKgew0KPiAtCXRkbXJfZG9fcGFtdF9mdW5jKHRkbXIsIHJlc2V0X3RkeF9wYWdlcyk7
DQo+ICsJdGRtcl9kb19wYW10X2Z1bmModGRtciwgdGR4X3F1aXJrX3Jlc2V0X3BhZGRyKTsNCj4g
wqB9DQo+IMKgDQoNClVwIHRoZSBjYWxsIGNoYWluIHRoZXJlIGlzOg0KCS8qDQoJICogQWNjb3Jk
aW5nIHRvIHRoZSBURFggaGFyZHdhcmUgc3BlYywgaWYgdGhlIHBsYXRmb3JtDQoJICogZG9lc24n
dCBoYXZlIHRoZSAicGFydGlhbCB3cml0ZSBtYWNoaW5lIGNoZWNrIg0KCSAqIGVycmF0dW0sIGFu
eSBrZXJuZWwgcmVhZC93cml0ZSB3aWxsIG5ldmVyIGNhdXNlICNNQw0KCSAqIGluIGtlcm5lbCBz
cGFjZSwgdGh1cyBpdCdzIE9LIHRvIG5vdCBjb252ZXJ0IFBBTVRzDQoJICogYmFjayB0byBub3Jt
YWwuICBCdXQgZG8gdGhlIGNvbnZlcnNpb24gYW55d2F5IGhlcmUNCgkgKiBhcyBzdWdnZXN0ZWQg
YnkgdGhlIFREWCBzcGVjLg0KCSAqLw0KCXRkbXJzX3Jlc2V0X3BhbXRfYWxsKCZ0ZHhfdGRtcl9s
aXN0KTsNCg0KDQpTbyB0aGUgY29tbWVudCBzYXlzIGl0J3MgZ29pbmcgdG8gY2xlYXIgaXQgZXZl
biBpZiBwYXJ0aWFsIHdyaXRlIG1hY2hpbmUgY2hlY2sNCmlzIG5vdCBwcmVzZW50LiBUaGVuIHRo
ZSBjYWxsIGNoYWluIGdvZXMgdGhyb3VnaCBhIGJ1bmNoIG9mIGZ1bmN0aW9ucyBub3QgbmFtZWQN
CiJxdWlyayIsIHRoZW4gZmluYWxseSBjYWxscyAidGR4X3F1aXJrX3Jlc2V0X3BhZGRyIiB3aGlj
aCBhY3R1YWxseSBza2lwcyB0aGUNCnBhZ2UgY2xlYXJpbmcuDQoNCkkgdGhpbmsgeW91IG5lZWQg
dG8gZWl0aGVyIGZpeCB0aGUgY29tbWVudCBhbmQgcmVuYW1lIHRoZSB3aG9sZSBzdGFjayB0bw0K
InRkeF9xdWlya18uLi4iLCBvciBtYWtlIHRkeF9xdWlya19yZXNldF9wYWdlKCkgYmUgdGhlIG9u
ZSB0aGF0IGhhcyB0aGUgZXJyYXRhDQpjaGVjaywgYW5kIHRoZSBlcnJvciBwYXRoIGFib3ZlIGNh
bGwgdGhlIFBBIHZlcnNpb24gcmVzZXRfdGR4X3BhZ2VzKCkgd2l0aG91dA0KdGhlIGVycmF0YSBj
aGVjay4NCg0KVGhlIGxhdHRlciBzZWVtcyBiZXR0ZXIgdG8gbWUgZm9yIHRoZSBzYWtlIG9mIGxl
c3MgY2h1cm4uDQo=

