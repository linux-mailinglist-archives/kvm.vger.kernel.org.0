Return-Path: <kvm+bounces-53256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5412B0F57A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:37:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB69D160396
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:37:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18932F2735;
	Wed, 23 Jul 2025 14:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xc5ZRJsy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08072BE057;
	Wed, 23 Jul 2025 14:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753281467; cv=fail; b=bTVkg/bwlyNPO/mOb69AdCv3APOEx61e8vlZUz5tbIr3b60n7e+UrqUvriuWDLBEi/Sbtmoh1pqD2knO5OArdsuDLOz+lpzwwgD98lpSiN3Rj16OE8QjXf1fQTtsTG7/UYALiBLqoBqq7DMVQHCwWguFrDbEwlDwXCAuJVO1ga8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753281467; c=relaxed/simple;
	bh=OoSSANXRN0uuk8Cw5m3g2Swh3FFvMuDoVjjZ0IZWE/Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HviZUhqsCEWZ3Z640gv1X+VyILaGjHpOEbp/aXdIQqi8EfU023wgpW4MksbsQ/8djOMYFun0cuRAq/+aEyKyXOXQimQCRECBhkN8VYHlECtJ2MjHjdoThtd9h5L9YmjDCkJXbkVIVoJq9w4CGVacE5+syUZMetZRpFSquZuvqPA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xc5ZRJsy; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753281465; x=1784817465;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OoSSANXRN0uuk8Cw5m3g2Swh3FFvMuDoVjjZ0IZWE/Q=;
  b=Xc5ZRJsyPiGl+KaHhC05QfOVMdNCJZ7wlL8E/v//vJqQxvm0DJi2Co5A
   rgde3j74vPRlJqgiPnzF/SW+huLyAqjiPC6Dw4iqlHxl9qeoWLOtrOKE3
   GIhzenT//TOKNEAd3lkRCD/r51Lhhty7qz4zsE3Xwz1kwG98oj+llilMz
   a4NRiONrt6mBcmepEq8IuCfhrMLeUcSkW7Nb5iqdyVPnlbhCvQ/stDNi2
   kvRbK93v7QdC4ZTaUIVVGMMhcQd8xjfmKjOYeg0+Zk8+4R+2q+xd+seh2
   3vfOAageCLR3zZiuYWEgkTBkdXAszDQGU7TFOSGf285Nm4C+vnLrTDjQF
   A==;
X-CSE-ConnectionGUID: KwK7+sj0SOyqD5nikEeX5A==
X-CSE-MsgGUID: TsEKbih1RyGOAlbP7vPBYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55718493"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55718493"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:37:44 -0700
X-CSE-ConnectionGUID: otOQSbtFQLKr2A6zJpZFxw==
X-CSE-MsgGUID: VamfLP75T2uUbTLTRwNz8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163797112"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:37:44 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 07:37:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 07:37:43 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.65)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 07:37:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7Mg6DLWlfg2wegMUK+M7/i/No1ddYIWm9sTh+dZhh20mnhfl8UEhGeOBeC8YVHz93jyoEb0qStX/ofrhmHZ1pnnYECm8MbrLZ45xkG2lJN2ue2HeYjrTpbjK0x4bZ+ZPI+4bx6DIESMkcZC16fQssjKJwc7E3CCSrUYL3SfEV0CA+NePiqBfKSDDFtwlh5ts760nX30mluJAudO6j6ROmD8aHMvQN07o6nivOgWgwAGTDFKrDqDUA9ZU+R+7gqfae6pmAYwSViRrx+HsRWo3sd5lnjhSEy2fKrqorTC5QrsvZFfeOzArTIsR+X/ECmK8kAIkFJZAJ71TGE2leq87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pMCqDuF3tb0WPygPoH6B4dUEN7HvMuM3YoCKUgcpF6Y=;
 b=NcjQjqd9bSN+Dwakh2MQiLlqATM+//RvC1yJrvx1ORLJeb3vWab3+YxzyqSAGkxK6HCxfwTShJTMD0wevjOwTxIY7VqsR7CRO9Vkbh08g3sLqqISB+BKUaMySmg5EhMwYTiWIZGoUJyPptuHpeo1jSYlcTbYPhNARqF+sbXJZWcNEAT5P4b4GhKIP4v3fzu8z9wANoG34hZnUHq9XLcdK8V/bCfEGL/nCArMzWz2XWKUVdzqzHqTyzYLyeacIrFCkNlnhrdJ5Ye2hCvAgMNtOvnDdImhufRcxkE9EHXiGeHKP5ZipqLX7zvJVJ03YOXzCpTmZDNLieSLJhClVRqqxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by MW4PR11MB6838.namprd11.prod.outlook.com (2603:10b6:303:213::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.31; Wed, 23 Jul
 2025 14:37:40 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.8922.037; Wed, 23 Jul 2025
 14:37:40 +0000
Message-ID: <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
Date: Wed, 23 Jul 2025 17:37:33 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
References: <20250723120539.122752-1-adrian.hunter@intel.com>
 <20250723120539.122752-2-adrian.hunter@intel.com>
 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU6P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:540::8) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|MW4PR11MB6838:EE_
X-MS-Office365-Filtering-Correlation-Id: 031cd49e-a489-41ff-329e-08ddc9f679d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aTB5WEJJbktSZnEzYnBLZEM2d2dFMkhBRTZlZUx2MzlPaWQ1Wk1RY2JzelpX?=
 =?utf-8?B?Nmt5K0RlQTJ1MTBkUmVkOGJyRUJ5cEVTYXE2UXE5aGtPYUNFQ3NyNitXWXE1?=
 =?utf-8?B?TmpCWnJ0bEVzS200L2I3UjZmRU1TUk1vbzl0aWwvekJrLzNuTFYwZU5UVFNN?=
 =?utf-8?B?YUpxQU9pMll4eGhGWWVBVTN5eXBLK3NkRkc3M0tpRENQVnYwNGIweXFtVDk0?=
 =?utf-8?B?UEpia1N1dUNRLzF1YlpZM2dQNVdqRFlNcFZLOEpPQXdpNTk4SnBDSnlmQktY?=
 =?utf-8?B?YVJEYXNmdFg1Y3NST1VYZkR2ako4UVpaM1ptRjAvZitrWVNrUzVxVUFPRG9t?=
 =?utf-8?B?enNubEJaUEpyQlUrSkZmM0pwYk1OQ3UrdVlkeFdINEo2dkNOcXlEY1Y1Ylkz?=
 =?utf-8?B?ZlUrVkdscjFEK2tQb0FGaFJma3BGa216YlYwaFZBLzlCTURqUjNheVZ3RkxY?=
 =?utf-8?B?aWFocURybnhneEp3bncxMWwwRzZSUHF0SjRDbVVpdXk2Wm9KSXdpWUJJdWRJ?=
 =?utf-8?B?d2FURWhwcS9LRFloWTUxZ3lJdUdQR3hFM0xNQVBpYVFHNUdqYys4TmlKdzd6?=
 =?utf-8?B?NTRWMkIrRnlWeHV1eE9PdG5Rb3luTFoySlRIYzdVRGM1U1FHNkpQVzNNaVJT?=
 =?utf-8?B?WGhVWWRkcis0MmUzQ0xMaWJsSDhrbG55VzNIQjFQTXdNN2Q3NGNsWkhCL25N?=
 =?utf-8?B?b1BCdDJtOUMwZURDMnVqbmVHNUhvNlRNUVh4RkE2amcwT0pEdmN5WVVPRWFk?=
 =?utf-8?B?ZHBLRm1iOFJZakxYYUxidGdYa1FNMGh0UDFFSkpxWTYxRE83aTZWdXgyR1hR?=
 =?utf-8?B?ZDU3S09RN2QzMHo5WURYU0Q2TnRDQUlJR1VRSkhoZFROYmpXZjFMcTZpejJ0?=
 =?utf-8?B?OU9QNjVTQ2lxaDMzaU9sTm0wemNvZzVyNmxKV05QczdIT0ZOSU5BM3dyYkpa?=
 =?utf-8?B?eG9CMXE5Y3BpVEFWd2h2QWNnZ1dmVmg2WGs4cG8ycU9LVXM5RUU0WjFIUFFQ?=
 =?utf-8?B?VGRPWVYwT055MHJKMUhGSzkyMVpLVFFZSnhjdTFLaG5OcWZOS1BlUDRIaFdX?=
 =?utf-8?B?OEkyRkRGdHU0dDgreVp2Um5VUk8vTEZ1c0FNeW1MNmlyNzczNUpURXU1RzNB?=
 =?utf-8?B?U05kVHFuTUhsVW1oNU1RQzAxSGJ0RGF3T3Yyc2cvSEdUZzdCdUxmRGJoN0Ja?=
 =?utf-8?B?clJPdzI3a3JsdjRrS1Y3bHYzc29HUEVpTXp0SndwbGdIVm1UV3VrcmREVlJq?=
 =?utf-8?B?QVp3NXdsb2c5TkNyVHFtRkRWczV3U2VKbHllSU55Skg0YnY5ZTdqc3c5dFl3?=
 =?utf-8?B?SUJzV1VCSkM2TlBWTC9aa3BXdW8zdFBTN1k1MVdZWUJDQ0srT1FCV0VwNFNw?=
 =?utf-8?B?aTNtdnhmaVNqRzB3ZWdhSXRaSThlUDZSWnN5ZGZJSWdyd2V6T3R3d3V4aFZn?=
 =?utf-8?B?Z1BUWi9XemE1UkVKQ2lxSitSeTBUZXpGdkI3MTFsbHpPcWFGbjFKZng2MlBB?=
 =?utf-8?B?U3RnKzBjZUlJUmJZS25SZmpUdmwxblRuYnBUN0xVMDB5elpORFA0dGYrTk56?=
 =?utf-8?B?QWZzYmpnMHVldG5YdVN5VjVkVXNreTIvV0RNNHVRS3JXUU1GRmlpczJaaFFi?=
 =?utf-8?B?d3FiTE0ycjNXOEtqWTY0K21zZDFhV0VXRDZmcm54ZW0rVEVjd3NZaU5Sa1B2?=
 =?utf-8?B?cDNGM2kzZXBQYlBXdzNtYzdwaEJsMEhna1BBby9jY1k0TTUyUTY5b3VqQVVO?=
 =?utf-8?B?NmFlMHlxNlptWGpXbjNjb3hOZGhMT0h2VEZHN3NxczM0WHVib21aajcwWEdC?=
 =?utf-8?B?OUxqZGp5OVpDQVBtMERybWFVcnlCM2R6SzNGMWpqYlhPK0Y4YWhFb2tKUEJI?=
 =?utf-8?B?Z3Nzb3RGVyttaDBHQ0ZGcHVvaDRWZ1lKNU0xM0d4M0N4M3QyV2dQVkV6aDBh?=
 =?utf-8?Q?rixOCCiSVLo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ull6cGwxTi9jakowanJCU1k5dXdyWWNqSVZsekxwWndBQVdhVFlxU3F6czlv?=
 =?utf-8?B?ZnlSYms4cmFONHdWVEdMM1JnYlh4eUl0NVUveFhJT3E0bXA3OGF2dk4rL3ZU?=
 =?utf-8?B?Nk5XYk5YSmxodTlGSTNra2h5anJpVTRNS0ZhZm8zakN1Q2s0S3hXWUx1Vm55?=
 =?utf-8?B?eU9kazV0R0NzL0ZlWHBRdmxzRVVhR3lQZkhxd1g5YmVnZ0w0VXhPcFlnTTZ3?=
 =?utf-8?B?c2w4N2V1QTFvSDZvNzZ1WkJWYjJZaTlMZEdlTDMxL0hqbU9FTlZGdkpUeGps?=
 =?utf-8?B?bXpaWThOOXpxSkhRUkczeDBZdUZWN3Evd0NLSjRldTd0TFBDeTV6NlRlRU9H?=
 =?utf-8?B?TENVZElmLzd1d3ZMQzJaU1dOSktXOWo3TmlhS3hQSkZKUk9LRFNsYjVWaUs0?=
 =?utf-8?B?N3JTZVp1NGp2elV1S2NXcjFEOUhaOTRhZmRvWnJ4clpIQy9vWWRRdWVVWlhS?=
 =?utf-8?B?WFlVY0puVUVYYUJYRHF3QUdyWFVicDVDZVB1bmdaZjRYalhEZ1A0Nzd0bDlF?=
 =?utf-8?B?U1U1ZzIzcUdiQnl2Ti80T1g2ZzRwZ2psSzZyS3Y1ZFNwTlQ5MXhIckZTKzhB?=
 =?utf-8?B?WHlRMy9yRWxjeDFWclo0cTZOazUrQ0pjM0htNEVyemU4MzlNci9wb2hPMkQz?=
 =?utf-8?B?K3ZSeXdnNitkaXFYNkN2dEgydUcyaVpVeEF5RTVQdVNmK2JwNDQ5bk04b2J4?=
 =?utf-8?B?aEdXcG1QNTNYUUo1K0JqanV2NllTV0xTeGkvMHo1eTd0NHZZZFRERnZYUUlK?=
 =?utf-8?B?TlRVc2NIam5aTFRhR0YzZlBGcXBkeWVSb0lrMVV1aU5Xd0x6SkR4dm5rYVZp?=
 =?utf-8?B?aEMxQ0JuK2haQ0NucDdFZmlVc09tY1FURk5QSGFhUFhqWFBybDdDMG1RMGRK?=
 =?utf-8?B?NlQwNmFnZGdDVXNqdW5KczM0VUxjNy9aYWo1NlM2K0hYUlFKTVJBVUNyTWQ0?=
 =?utf-8?B?VmgyNDAvaHhlWUtKMmJya25UTXAvK29IbzlPWTVseGszRXhoRUFrMm0vd3Zn?=
 =?utf-8?B?OHMzSkhtSGhVV0RmRk00cGRMbjBPbnBFV0dXY2VNNWdXZUEyUys2c1ozSHY1?=
 =?utf-8?B?QkRKbElpcFhMSHRzT2M4dW1laTBSN243blltOVFtUnNUU0dKZTltNmVERUtp?=
 =?utf-8?B?OFBwNmdZa1RhajhzL244RHp5Mk1hL2hhUkZkRGsrSGQ3S2Z2RzFKNXd2bzJ5?=
 =?utf-8?B?SzlSOTVGN1ZBRWhMZ1hhb21sUjhmQ2QwdjJZRDVZYjNuak1ZVVA0R1o2T1By?=
 =?utf-8?B?VTU2TGR4WkNGd1BCZlR0a3loNGNibDh4ZXRoa1RjTFhGbXJJSzFoTEgzLzFh?=
 =?utf-8?B?cVR2VUlkYlQ4SE0yN3B3OG9XRFVoQlFIS3g3K25YWS8xSmlZS1hhazZreVNs?=
 =?utf-8?B?b3ZVMFA0WWc3YkRwbkd0NVI4bTFZUzdyakVGb2JjZ1F1OXo2dllEUVpxTFo1?=
 =?utf-8?B?SkJacHpBNVJPaytLaXdCbTBTMU1SQUdmNlhxYmYrSEU3akdGQjN3eWZFSjBu?=
 =?utf-8?B?YmRmRWM0R1lyYnNldnJ3SnEzaUt2K2tZQmduaWhuSDNWNUtaQjRrK1AvQWM1?=
 =?utf-8?B?a0FCM3FxTEdtRmdxN05UU3FZWjlsd2hGSEZaelZVVituSzhsN3dFNHVIdEV0?=
 =?utf-8?B?aUVyNTBvQUZ4SjVHMUhva2ViQUxLVEQvb1M3RHFJQzdPUkpiT2NFeURLaWdq?=
 =?utf-8?B?MXZvSjJtV2orZU1QOTl4YzVYeSt2UGlhWmdZWXBaM3ZPVUx5a0xQOG1zYzJR?=
 =?utf-8?B?VkZjaUdtQVVnb0N4aG41azhZdE5kdURWRkx2a3R5YmpkNENZcmVvNHF0bkFI?=
 =?utf-8?B?NE9reEpGZDlJS2k0cmlaTkdSUU5xVG8yb0dzYVJxWG9SeFdWN2JadDNUcGkx?=
 =?utf-8?B?N2VXRFBZdmpCaU5YdGlSZithWTAyMWNseHN0MjNqWWpNZVpFN1VnMkRaUzV2?=
 =?utf-8?B?eWlzRWlCcytpeFNQdS9vUHBYcHcranUveVBhMGIzOW1WdW42ajA0QjB0SmNS?=
 =?utf-8?B?N3ZDNG95MDFTRFlpSTBNZnVIZVdtRWtYRm1UeXp5T3o0ZW4yMU9IQUF3MlFh?=
 =?utf-8?B?RU8zeFp6L2phUlRsK3NQN2ZSS2ZnNVMwRmM2VkJGU3RVaC84aEZMdnREREZ4?=
 =?utf-8?B?QWpDTlZWSUlpK1J0UjdPZTc1NVFGOVVNdHlDWCs2My9mb1JRNlQ3V0U0MzRi?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 031cd49e-a489-41ff-329e-08ddc9f679d6
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 14:37:40.2291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zuYH6dHKMohSTCg8PIciE3qHATBhQD9VQ+eRPN7wSvfhwUc58E9x14kXbXUvGHZBEpHtwJOlj68XjCXUQXUiGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6838
X-OriginatorOrg: intel.com

On 23/07/2025 17:06, Edgecombe, Rick P wrote:
> On Wed, 2025-07-23 at 15:05 +0300, Adrian Hunter wrote:
>>  
>> +void tdx_quirk_reset_page(struct page *page)
>> +{
>> +	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
>> +}
>> +EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
>> +
>>  static void tdmr_reset_pamt(struct tdmr_info *tdmr)
>>  {
>> -	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
>> +	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
>>  }
>>  
> 
> Up the call chain there is:
> 	/*
> 	 * According to the TDX hardware spec, if the platform
> 	 * doesn't have the "partial write machine check"
> 	 * erratum, any kernel read/write will never cause #MC
> 	 * in kernel space, thus it's OK to not convert PAMTs
> 	 * back to normal.  But do the conversion anyway here
> 	 * as suggested by the TDX spec.
> 	 */
> 	tdmrs_reset_pamt_all(&tdx_tdmr_list);
> 
> 
> So the comment says it's going to clear it even if partial write machine check
> is not present. Then the call chain goes through a bunch of functions not named
> "quirk", then finally calls "tdx_quirk_reset_paddr" which actually skips the
> page clearing.
> 
> I think you need to either fix the comment and rename the whole stack to
> "tdx_quirk_...", or make tdx_quirk_reset_page() be the one that has the errata
> check, and the error path above call the PA version reset_tdx_pages() without
> the errata check.
> 
> The latter seems better to me for the sake of less churn.

Why make tdx_quirk_reset_page() and tdx_quirk_reset_paddr() follow
different rules.

How about this:

From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] x86/tdx: Tidy reset_pamt functions

Rename reset_pamt functions to contain "quirk" to reflect the new
functionality, and remove the now misleading comment.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index ef22fc2b9af0..823850399bb7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -664,17 +664,17 @@ void tdx_quirk_reset_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
 
-static void tdmr_reset_pamt(struct tdmr_info *tdmr)
+static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
 {
 	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
-static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
+static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
 	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
-		tdmr_reset_pamt(tdmr_entry(tdmr_list, i));
+		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
 }
 
 static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
@@ -1146,15 +1146,7 @@ static int init_tdx_module(void)
 	 * to the kernel.
 	 */
 	wbinvd_on_all_cpus();
-	/*
-	 * According to the TDX hardware spec, if the platform
-	 * doesn't have the "partial write machine check"
-	 * erratum, any kernel read/write will never cause #MC
-	 * in kernel space, thus it's OK to not convert PAMTs
-	 * back to normal.  But do the conversion anyway here
-	 * as suggested by the TDX spec.
-	 */
-	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+	tdmrs_quirk_reset_pamt_all(&tdx_tdmr_list);
 err_free_pamts:
 	tdmrs_free_pamt_all(&tdx_tdmr_list);
 err_free_tdmrs:
-- 
2.48.1


