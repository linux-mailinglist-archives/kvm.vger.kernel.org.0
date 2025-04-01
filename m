Return-Path: <kvm+bounces-42391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B229EA78152
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D8093AD9CE
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D1C20F081;
	Tue,  1 Apr 2025 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hedWqD8D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAB9203710;
	Tue,  1 Apr 2025 17:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527866; cv=fail; b=O6UGvL4AwJz1HuU7OX5QalPKeFHFC4lSgqxqbCioKTT1pJ54RfcOGgjQqFmZFh74pMDp2O4vWGjSP0YaDwKKrTSYmMDas4y0IsrfUE8FjLjNtd71BxBVjiMfrV2P54b5OMrYbmaoou3bx+/7X/vQ76Ugul6rSe2gL0tpq+Si0zY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527866; c=relaxed/simple;
	bh=aOfCUGpgqEGWGdedHkQS4Qoe3l9IV5LrO0xweXEz92A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uLzCfbofqjxxAAdzAvQVp/xa4ju/IzZdZdh8lVe02zwXCaLZYMFEDPECWIHvU3xSpk233WFBK0d+lLs2WGNQ3BYBmJCe/n5uy1ISq2i/3vgR7XkISaoRIFxqEHzpTwxjzBRGcyereqW2NyhZ8VuGvmEgbpnVdvYkumiH87HoP7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hedWqD8D; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743527865; x=1775063865;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aOfCUGpgqEGWGdedHkQS4Qoe3l9IV5LrO0xweXEz92A=;
  b=hedWqD8DF0gu/hNxAsLUkOMnFJGgY3gBm05p/N8fmJymVtPBgfBsjpJg
   6f4IagfWpYV8MVUBuqW7iRU2kl+rtVAMeS2iWy/vTpYPGRVy6KO6F1I7j
   guf5LQbNChI7pNN+v2saXmrRzZrQ3w9+r3UAjfpXqBvATCUZBjxaxTtwO
   VB/9AmfnyRd1GtMhEa4RVkbKAyrgMWt2WOHOQauhvZ4/O99cU4WzE//BS
   HhggqbTIO9W1NpvJdb0vLuY9V0F6Oso4t9cPInLzHf6gWFNita/9sgUWH
   EHUKSWaML77XDe+qhF4fkSilvPFGQvDxCLjUW1kOYx4sIokNdcDk/RcZh
   g==;
X-CSE-ConnectionGUID: vSQbURcPSJyJdc10Vk7buQ==
X-CSE-MsgGUID: f7Y6d+1tSt25vkCek22B9w==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="48656053"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="48656053"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:17:44 -0700
X-CSE-ConnectionGUID: O/ahzw0WRGmMDHWCUulpvA==
X-CSE-MsgGUID: 8ADd9FoDTM2KquPFwj4pVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="126432938"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:17:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 10:17:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:17:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:17:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wroXgn5nlveWhrfUZUuFErbUpPnrAxjSMQlGeVCsXvY4u1Ep8t6L0t+CVjTLctfx0fD1EBEKtLoDfNfTSyeBIRysOL/j5ACKXWHHddYJyDYVJGKoNSOA63eIm9FuHh9gt0eNycVyQLoSVPVBP+h+0I9oKkvbVEzEUrg8T/QvW0Ba4oUQJIPOZahLTEN53oRq5wtwMWXIHENYtgBC7I3FZpzIEdp0h8+ucIwTAR6jeyKV0YTf2ckNEKXJ6O1cbSSbet70eJOabDQnpJReP7jdfjQGScRFKTgQH5nAYkGCtvC/yhjJOH/LJEuEMTyophGTAsfsTrhvV1+kRky4n5uTkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m3CWGA0Z0OMrPBv2J/ywny4CicMW3TqstWDnSKm+hFs=;
 b=k27qc4TCjryki+yR67ha6oYbvZQtbVwVdWpGVwJVW9UyrONtB8vgnu0uBjtcUzDeFNEavK7CxIGmPWruZHK85fBNH4WiXebcOr10ckgDxKS+Wcm6A1nx0Zz2PUCP1bQU2KaqGP2SDcST7AGkIovFwuvMl8d2Z2TuWK0Qq6elX419bCl92r7oXGaku/IXIgna/SHKqeIqnnODb15rbOipcMzGT8sOrE7SQrBhVEtKpccWfnkG1bXjr9ea+nPUOshQiPzd7AuH4o6yZnapLaLHvsorHpCcGLU+abYhvtMqUk+OKLEszs9fPW44p33MLFY1iT1biT1qJkoLM3Rc0A86tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 PH8PR11MB6926.namprd11.prod.outlook.com (2603:10b6:510:226::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Tue, 1 Apr
 2025 17:17:28 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:17:28 +0000
Message-ID: <37b9903a-e8fc-4d57-a1ae-2bd2f26a9974@intel.com>
Date: Tue, 1 Apr 2025 10:17:24 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/8] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Mitchell Levy <levymitchell0@gmail.com>, "Samuel
 Holland" <samuel.holland@sifive.com>, Li RongQing <lirongqing@baidu.com>,
	Adamos Ttofari <attofari@amazon.de>, Vignesh Balasubramanian
	<vigbalas@amd.com>, Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-2-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-2-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:a03:255::24) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|PH8PR11MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d22ba3-2cee-47a2-8598-08dd714113f0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MmtkdEpVMTFGTUN0amM2NUJVUkhFNGd4SmlxODFOR1I3VENoRVAvNU1IQ2lZ?=
 =?utf-8?B?RUR4MDNpb3JmeW1mb2diT015Y2F4YXRxNmpaclZ0YnA5cXNRRzdaY2xZUkxr?=
 =?utf-8?B?aUxXaGRWc1lLdXNyNVZNa3Rlb2xxOC96cXVLamRIamtUWkZKczA3VHkrc3lj?=
 =?utf-8?B?QWNYNjl4NTVDZmdmZGxhb3lUZTRFMUM4VUhGNi9jOHgvNlRUZmpuSnBJNGtB?=
 =?utf-8?B?Sk5Xa2l4Z1VHNUZ3RkxORnNqNFBGdS9xbE5icVBNYzFvL1J0RVNqRnBJOEx5?=
 =?utf-8?B?RUFpd0ZobHhzNXZyS2F5bWVjdm1QQUNqTjQ4aDRmMUNLamtaSjRoelpnTUt5?=
 =?utf-8?B?ZnJWbG5mdlVUVERqTElxRmp1VFhheG9ZdUMwSjRxSEpCUElSMjdDV1p2aC9j?=
 =?utf-8?B?VVpEeE85cmwyQmFjYjkvK2JZNFZ2ajZybTZmbXN6RWRRZmhITVJOTFBGRVVC?=
 =?utf-8?B?Ukx6c1RjS3RoOEZucVBuS0ZvS1ZkbkNtdHkzZUJhVU1Dd01iTUpjRUdRaWxV?=
 =?utf-8?B?cTRjUFdCbExaNmdYSjNqWVBrN2U0UWdoQXJEL25kNE9nUEZld0QxMS93aThI?=
 =?utf-8?B?OUVnTzAyVWRUQVdaeVN4NUIvN0k5Q0UvYzkwZG1hTENEaUZ3d1JzTmhnYUFS?=
 =?utf-8?B?OFVoN3RPL2dZVDJlbmpoOU5uaWx0MjhGNnQ2TnAxUXI0YXBzN1prbTNnTVZt?=
 =?utf-8?B?NHhoRk0rbUNkeXdyL3plTlpES1hMWkdtaGFpY2NYNGQvc280UkpnQXEvZi9h?=
 =?utf-8?B?ZVFQMUxjalcxYm94SjhRUDk4ZTV5T2ZBeU5Qcksra1piNHk2K29rcGpVZWFV?=
 =?utf-8?B?UnI5YVB5cU9vNW5GTU4wc0lMWE82ZFNRaUVzU0xoYmlDaGRmeEtXYmhrVVQ0?=
 =?utf-8?B?VnkvTmtCUDlMOGh4T3V3LzVwZkpMYmozUkcwcDdpeE5mMDNCMG5LVW81OHcz?=
 =?utf-8?B?NWxVdThiRjZHa3daaU5LWFViMytmWG8wbjZyenk1Zk9heXBmZ3hDc05ZMW45?=
 =?utf-8?B?d00vc3Z1KzdqZTNtWlBWUm5NQ05IRkNHOUl5SzJacmxNdEtRRVNjTEp1R1Bu?=
 =?utf-8?B?WDRqd2tLeUhTWGJLY2dvdlpBMHpZR0ZoMVNtL3ltUUNsdkhIUTVxdC94YklR?=
 =?utf-8?B?WGIwbWFMRERacnhGOUFnVGNacEVMcWVNZ29scVVQRk9rRHpjNXp5TTkxMjhH?=
 =?utf-8?B?TFZVOTdxODl5NG0zZVJLWFcxeUdDS2UwN29IYWgvMTlnb1g4RDNVYlVlVTFJ?=
 =?utf-8?B?eDJkNm1yOXlrY3prS3dpSnJmemhPcFVlQVBsZlhXN2ZwZTZ1djNrRHFyQjNC?=
 =?utf-8?B?VlVneDM4b2cwOU55QllVc29xUE1RM1M3ZjB6LzNoU3FIYlcvejRBTlJsRFVa?=
 =?utf-8?B?WWtDUzlBTkIzNVR4RWxtTGdjTVcrd2IxQ2M5SE9yb0pwMzQ3TFN1YzJsSzBO?=
 =?utf-8?B?OTJkMlU2SklHTmpqd2dUSGZCZk1XK2ZkaW0wbDFyMW5zdHF2TUlUR21QYUtF?=
 =?utf-8?B?RkRrQkhNWHprYjhXSUNVZ3NnbCtmUTIvWGFqQUtHNUczSzduMXlRQXlndmZQ?=
 =?utf-8?B?clI5YXo0RDNXTGs2am45bGwvek91ZnFBRWtjUXRiNDB3VytOWitXS0lEcHhB?=
 =?utf-8?B?MGRob01Yb3NtYm9jbmt2RmIrV3ZaQTZGREhUMkVheE00eld2cTdCbmVha0JP?=
 =?utf-8?B?Z1VsQ1RBbUREaE5DOUJPNnA1OFFCRm56ejcxYjl6c01WNE93V0tnL1NHVWto?=
 =?utf-8?B?Sy85ZTYvUENTbXE0amJlUkNCM2pNMkEvdS83OG5BSUs4ZDFRci9leGR4VmxX?=
 =?utf-8?B?d0U5QkN6UHdWK29KL0VlMTlOOGUrK2lFNlZVTy9UeFB2ekYvS1gzbXdhc1ls?=
 =?utf-8?Q?p4pfDWAMvH1ad?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG9yZWJWYlEyM1NFaDhxcEtZU2NRRUo0OE90VWpUa2JCTmNyeHl6ZTNpUEls?=
 =?utf-8?B?RFB0UUgvRExiZzM2R1JZYzh5NEU0ektWOWNndnFxeXViTkZNTENtM1gwZ1Bu?=
 =?utf-8?B?UjZEYXdXb1RCcVNxNG41aStrZ3NGQ2MrdzhmOTl6Zk1Bd0htUXVkRDFZbXNO?=
 =?utf-8?B?MHNTL2NUQkw0YlJQVU1ZejlrWFA2dnNudlFwQXpEU3N1OW5yb0twc2IyR1JX?=
 =?utf-8?B?dFBycytvbTBIWFg2cFJKbHdXeEoyS0xpTDZCcWRSS2daTjdvT0xFNUwxa1Jr?=
 =?utf-8?B?UjZ0ckhSTmhvc1NiRWZ6UzdoUHdqRUZOSmlhaWtCVGhqbGJndFJuY0MvZll4?=
 =?utf-8?B?eDZpbnZvbWQ5RjlxWFdWOGxUdldoWjlzWDNKSzVEWG5zTmxuemFZY1dSa2pX?=
 =?utf-8?B?b1NRbUlmU3hoWUtETFBFS3pLTmkyM1B4bkVmVHRQQVhrWWIvcmhrUStVUmN6?=
 =?utf-8?B?Q1E5SUdLaDZ4ajhINWEra0lHWkNmOXdsUVlJOGYvMUxKQWhVZVg1R0MxYm1V?=
 =?utf-8?B?SkNzME1LMUZWMDZsT214WUhnZmJDTHY5OTZsWUNFRlBTZU1DZW00Sm9ZbGJ3?=
 =?utf-8?B?RnVyNnB0NjVROStZdDhBZGJ1Nnl3OUpDNWZKU0pxdzF4eFR4YVNrcDYxRHdN?=
 =?utf-8?B?SjV4V3BLdjhWSEpSVXVoWDI2WDRCUitXWnNjU2dtdEhMazV5K0pnZTJZK0R3?=
 =?utf-8?B?b0N1M1pFRTduWlgveEVldVhydGhhVm1reFJoaElxWDZIMDBvazRJQXpIaCts?=
 =?utf-8?B?Y3NtR2RXckxpV2JCY0hJU2k0OC9LejBOWUFmN0NqZ3IwNmVHUWFPMkRBcVkx?=
 =?utf-8?B?YzYxd1RUaTZjS3RPZlhxUkx3aFhtS0xjbDdCZW4xL2ZMcmtIRkFXN1ppVjFi?=
 =?utf-8?B?MGMrM2VuSitnVVhybHRvUktYVmhsZXdrcW81MGN0b1NtakczRGxzdE5iUlpL?=
 =?utf-8?B?OUxZdzErT015V21GS1ZXT3didkZva0xLbStTOFdlM2pTMnd6TXVQRW1ZVzlh?=
 =?utf-8?B?ZGtyWHZBQXQ3MUxhenlrdW1xM25QVGN6Y3R4NE5kbGFnWTdMMUgyVW9tcWUw?=
 =?utf-8?B?dVpFdjZYWVNDS1RPV0RBaE1GeWZkYVVleFVGNXp2b1F2cDBCaUFmSHoyWTBI?=
 =?utf-8?B?ZmI5c3FZNDVwTE5hWndKb0dLOXVVNjhselNZUEk0dk96ZldyVjA5TU1jTkVx?=
 =?utf-8?B?bWV5TkNBRVYrWENyMUdNN1VLMllKMWJNRjNFeTQ2WGREYm9mdHRpQlVQOU5k?=
 =?utf-8?B?L2p2OCttVWhrdlBMRXUrRUYzb0hZQmpmTnV2R2hRMlhNTFNMd3N4NjcyUktZ?=
 =?utf-8?B?S1ZmdWVjUmt6UEI5YjJpN2lSR1FzZTRydVJPNnN4Qm9ibEtzUVhGK250Q3Jv?=
 =?utf-8?B?Smg5RnZ5UzJJQkh3VVMybE1ZMW9YRVJWcEdpT25LaVBUTGt3Q3ljdXBSRVlH?=
 =?utf-8?B?dzRmbkt5VUkwMHZra3pKRG90MjZGM09kb3JEODZ4a2pYcDFKS0w2T3JJQUFB?=
 =?utf-8?B?enZqMll6WmJHOE1LU0puSjhiNFZpUE9IQ2dqa3ZNdis2VE0vWFJlQ1VPc00y?=
 =?utf-8?B?eS8vQ1ZQak5pc2E4OE9lUzUvUWhKeHFadmR6cUFZN29oTEpKQ2tnZG9DTmJ4?=
 =?utf-8?B?K0FBRTZ2R3ppTWg2TXk1Z0s1SEc0S0NrREtEczdXVjdiYlMyaEkvN3FtMTgr?=
 =?utf-8?B?cThCb1F3ekFRdCtxZFM4cG11NVY0QXlpKzhmbEcrOGlIS1J4bXZsYkFjUzNK?=
 =?utf-8?B?aVQ3VTNYbHo4ME9Qd0pPclBHby9YRTRMdjJnMGZtdjR2TFloaFo2YmExTStT?=
 =?utf-8?B?T0RFNE11KzllalVhTXU1OC9IeTU1SXkrVFNEcG9IK2lMYzd4VER5a2JKemFw?=
 =?utf-8?B?UUtScEFxNDZsOUV4bG9HcUpZYTdzQ3loa01DZUR3VFd5RDhMaksvcVNJbjJT?=
 =?utf-8?B?Wm11S1R3cUVWb2UyNVRtSEs2QXdiSW04anB4STM3SGErckphNC91ZE4yZzJE?=
 =?utf-8?B?TzBuU1RpQnFDWkdqTkNKR1FOYXIyMjZhbUZYa2N5YWxyZ0RUV1JKKzhSS0Qy?=
 =?utf-8?B?MDhVUjJXYWR6VTFENU1uaTdCSzNqYURMWGhnZmFnK1d5K3RkR2dzeCthUkRl?=
 =?utf-8?B?cEhjQjZja1pmdkNrb3ZLaVJVSU5ZSnZuQjRaZUdyd1R4YnYrT1lGV25HNEFV?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d22ba3-2cee-47a2-8598-08dd714113f0
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:17:27.9374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTxwrVknbzrBZP+7uSv4s5XfhlhBJmWQ7GAMsfd45IwmK8oFZV4GXp0mPbfqNw7f8lUEwTJS5LZs6E7xHNBtbnOm9h8sP/l+Mzmt2FUHPGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6926
X-OriginatorOrg: intel.com

On 3/18/2025 8:31 AM, Chao Gao wrote:
> 
> When granting userspace or a KVM guest access to an xfeature, preserve the
> entity's existing supervisor and software-defined permissions as tracked
> by __state_perm, i.e. use __state_perm to track *all* permissions even
> though all supported supervisor xfeatures are granted to all FPUs and
> FPU_GUEST_PERM_LOCKED disallows changing permissions.
> 
> Effectively clobbering supervisor permissions results in inconsistent
> behavior, as xstate_get_group_perm() will report supervisor features for
> process that do NOT request access to dynamic user xfeatures, whereas any
> and all supervisor features will be absent from the set of permissions for
> any process that is granted access to one or more dynamic xfeatures (which
> right now means AMX).
> 
> The inconsistency isn't problematic because fpu_xstate_prctl() already
> strips out everything except user xfeatures:
> 
>          case ARCH_GET_XCOMP_PERM:
>                  /*
>                   * Lockless snapshot as it can also change right after the
>                   * dropping the lock.
>                   */
>                  permitted = xstate_get_host_group_perm();
>                  permitted &= XFEATURE_MASK_USER_SUPPORTED;
>                  return put_user(permitted, uptr);
> 
>          case ARCH_GET_XCOMP_GUEST_PERM:
>                  permitted = xstate_get_guest_group_perm();
>                  permitted &= XFEATURE_MASK_USER_SUPPORTED;
>                  return put_user(permitted, uptr);
> 
> and similarly KVM doesn't apply the __state_perm to supervisor states
> (kvm_get_filtered_xcr0() incorporates xstate_get_guest_group_perm()):
> 
>          case 0xd: {
>                  u64 permitted_xcr0 = kvm_get_filtered_xcr0();
>                  u64 permitted_xss = kvm_caps.supported_xss;
> 
> But if KVM in particular were to ever change, dropping supervisor
> permissions would result in subtle bugs in KVM's reporting of supported
> CPUID settings.  And the above behavior also means that having supervisor
> xfeatures in __state_perm is correctly handled by all users.
> 
> Dropping supervisor permissions also creates another landmine for KVM.  If
> more dynamic user xfeatures are ever added, requesting access to multiple
> xfeatures in separate ARCH_REQ_XCOMP_GUEST_PERM calls will result in the
> second invocation of __xstate_request_perm() computing the wrong ksize, as
> as the mask passed to xstate_calculate_size() would not contain *any*
> supervisor features.
> 
> Commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE
> permissions") fudged around the size issue for userspace FPUs, but for
> reasons unknown skipped guest FPUs.  Lack of a fix for KVM "works" only
> because KVM doesn't yet support virtualizing features that have supervisor
> xfeatures, i.e. as of today, KVM guest FPUs will never need the relevant
> xfeatures.
> 
> Simply extending the hack-a-fix for guests would temporarily solve the
> ksize issue, but wouldn't address the inconsistency issue and would leave
> another lurking pitfall for KVM.  KVM support for virtualizing CET will
> likely add CET_KERNEL as a guest-only xfeature, i.e. CET_KERNEL will not
> be set in xfeatures_mask_supervisor() and would again be dropped when
> granting access to dynamic xfeatures.
> 
> Note, the existing clobbering behavior is rather subtle.  The @permitted
> parameter to __xstate_request_perm() comes from:
> 
> 	permitted = xstate_get_group_perm(guest);
> 
> which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm,
> where __state_perm is initialized to:
> 
>          fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;
> 
> and copied to the guest side of things:
> 
> 	/* Same defaults for guests */
> 	fpu->guest_perm = fpu->perm;
> 
> fpu_kernel_cfg.default_features contains everything except the dynamic
> xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:
> 
>          fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
>          fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> 
> When __xstate_request_perm() restricts the local "mask" variable to
> compute the user state size:
> 
> 	mask &= XFEATURE_MASK_USER_SUPPORTED;
> 	usize = xstate_calculate_size(mask, false);
> 
> it subtly overwrites the target __state_perm with "mask" containing only
> user xfeatures:
> 
> 	perm = guest ? &fpu->guest_perm : &fpu->perm;
> 	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
> 	WRITE_ONCE(perm->__state_perm, mask);

This changelog appears to be largely derived from Sean’s previous email. 
I think it can be significantly shortened to focus on the key
points, such as:

x86/fpu/xstate: Preserve non-user bits in permission handling

When granting userspace or a KVM guest access to an xfeature, the task
leader’s perm->__state_perm (host or guest) is overwritten, 
unintentionally discarding non-user bits. Additionally, supervisor state 
permissions are always granted.

The current behavior presents the following issues:

  *  Inconsistencies in permission handling – Supervisor permissions are
     universally granted, and the FPU_GUEST_PERM_LOCKED bit is explicitly
     set to prevent permission changes.

  *  Redundant permission setting – Since supervisor state permissions
     are always granted, the permitted mask already includes them, making
     it unnecessary to set them again.

Ensure that __xstate_request_perm() does not inadvertently drop
supervisor and software-defined permissions. Also, avoid redundantly
granting supervisor state permissions, and document this behavior in the
code comments.

Clarify the presence of non-user feature and flag bits in the field
description.


