Return-Path: <kvm+bounces-16679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04DC48BC851
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 09:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F09281C50
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292BF137747;
	Mon,  6 May 2024 07:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZKIithq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227FD12BF2B;
	Mon,  6 May 2024 07:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714980409; cv=fail; b=Ci6NyorSyBCipfuQyl4kf9ntY1xfHEcETptgGv42hmuZITiOtIWhFYE5lgMzc1ciMSTmKszvh1U+XvfrykJfPB50F4ck5rkYj06/2orgMgRIljNTgMyq7zuFUEaOsIjtQLXrRiQSykmur2/coc7leny6WScx3pAll+QIRxxdCv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714980409; c=relaxed/simple;
	bh=pgEFPB8vF/C0YK5eGuW7THI2J9GaNDxRbdijc34e5GU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BfVUngpFTxOoN0TNjMZx7Hau/EXeBuaQPf9R5aBlqldkmfLu3B1W0+Ky6SzGLrLGY1Y4hXchh58ps1y9OBwrRVkXzG12kt0+HOeC5P7ya3LrYctW/eV6jDKVX/+Q5lhWxydu/xQ/uKghRiLak2c9P+xaYRQt5V1EMkfOTTTzn/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZKIithq; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714980406; x=1746516406;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pgEFPB8vF/C0YK5eGuW7THI2J9GaNDxRbdijc34e5GU=;
  b=RZKIithqrKl0uKl7oQ7fRCHISDjsUGFgAY+nTfORJXEwEMibqNFmxBOK
   VD4gDKNF+Wv3Y0io2SOqmCXFxDKN/rpayRGt6Y3sRCYHuIZwJeAtHtaO1
   78Yf9EZWl8a7o0OvqIw0tsgt5UXwQC5Qh/a7qAxrJC7QNmA9KaWRvhfvr
   oFElWSH4Pceblc3OpUnaFlH2pACnNoGPd50yyysRwXDI+azvyeIHTjf4y
   JSMMKBhpCqOoF5eZ41QhyZXTv8svj979joFn+MY8fifDWgYygdPxlKSWB
   xAEdRNFR7uH36N69JKS3U3isZ4vMGnucW2lP5qECarwb8KfZh6ohumTXM
   w==;
X-CSE-ConnectionGUID: mCTTUk+6RsSbhaG9QpUEAg==
X-CSE-MsgGUID: 3uMUsh0ETI2om5F+BF+i7Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="11247690"
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="11247690"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 00:26:42 -0700
X-CSE-ConnectionGUID: Dg+azEzOThugcVRA/wroQQ==
X-CSE-MsgGUID: TWczFAhcS0KbB3HrEFA7QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,257,1708416000"; 
   d="scan'208";a="32883542"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 00:26:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 00:26:39 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 00:26:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 00:26:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 00:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fr+fHnvxh77BKT4vD1ywWA7i7cRke6hdgTMAL/QAMvnkoOSiagpjOOn7zCSpIkg/eEdBbj3PqiL1jjv/Lqfpyl/U/nq+m2ZdL/gmt81EoOgytEmMVnjyDmmWv7bn2DZDloyIN+Luxzq0tHu/UVJJi6x9CxvW2TOA/0pLqB3eoSHNaUp7nfbTd0ntyEtk1BjGXHQ1DxUbm3XCVD+GDEm4C3apXIhFHAQaDYEW+06CUXw6q9iBtNWaCAaAFPHbKi8GNqAyaSJ23sF9Rxgmk8796kQQoFIAKceFkX01ugzgH5DaST8Ze2zXm3hyWoRnIwO3OHpJAZkGKRJgUyohToFx7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGgs1Hm+EDp17GATwLzZfnKOWRK0u1YEw3LTC+IHZs0=;
 b=FMAoH0Fm+6xIVC54ykxVTkQ4NdKrdqMnhfwrfedun7h9VbTDZgF2w0npLLZE6Ltm2k8N5Z2V7qSdOmZ6dnN5AiQ5KatZyuARlcBkkJ17Rdcd+IYvsgWEP2+ApglpT3yBTGALgmxk8q2HQVIzLBWOLlZVE93+4+OppZnwdqR8d+0cVeL+PvA13veifCALa2pSJRaFwvwXZZOE/RLIsSbWIe822t7MYcG0zTiXVvokPvnO6pd9AVFPH8YnoMCbvLtJvf4xmoeRZ+emqjL6FRmfy+xPdxltbLacKvrwXq+uUy1PfQsLuDmlLAIcyAFH05z21I9kY2pIhFXZ/r9DfSKVSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4790.namprd11.prod.outlook.com (2603:10b6:510:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 6 May
 2024 07:26:37 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::36c3:f638:9d28:2cd4%6]) with mapi id 15.20.7544.029; Mon, 6 May 2024
 07:26:37 +0000
Message-ID: <6eb40c65-d9f8-4615-811d-6c9139a0e626@intel.com>
Date: Mon, 6 May 2024 15:26:29 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/27] KVM: x86: Refine xsave-managed guest
 register/MSR reset handling
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <dave.hansen@intel.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-11-weijiang.yang@intel.com>
 <ZjKouS2ZyH7cXOqM@google.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZjKouS2ZyH7cXOqM@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYXPR01CA0043.jpnprd01.prod.outlook.com
 (2603:1096:403:a::13) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4790:EE_
X-MS-Office365-Filtering-Correlation-Id: 47dba287-9896-4071-58ce-08dc6d9ddd0e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WFNVUUNWa1lOUEFuc0FLcVZDTDFkNkZvN1M0M1RPQTFVUTRSK1RJbnRDTTVS?=
 =?utf-8?B?MEdUOFRweWFTa1JtNFBZRjJXbDA4emJKcG1hQ0cybnYvckM4WGt1ZE9mR2RR?=
 =?utf-8?B?UXc0UkRPUTY5amMzSmNQdjl2R3M1RFJCVUx1d0JYeXprYnlCQkRQVGNWSFM1?=
 =?utf-8?B?ejlUQVg3WlBUNy8ram9BUEFLalM5aWhVUWo2T0FrYXVsZGpVVDVXY3BITjVF?=
 =?utf-8?B?amk5Z0crdzFLbmlETGpKaG5yOWxTWjBSdEhtclJ2a3dueldqT3haSU02cnIw?=
 =?utf-8?B?aUJpcGpybFhvNk1ZSEQrOW9BVDlpeENnU2dKMW1WcGdiajlFblYzMXQ1MG1Z?=
 =?utf-8?B?MEpCbG9xd2NYbEU1RWw4QjdwOGRQUzNmUDFHdm8vVy9ObW01S3M0ZENyN0RL?=
 =?utf-8?B?TXJ2TGNmdlJkeXo1UkdWUFNOcjJHVUhWeXZ6TGtjbDBtcFdxZkJ3Sit4Mkdm?=
 =?utf-8?B?YXpJaGF1WTA1VnhMMExGN3N5V2ZKTTJETXVXbFNOYkl0ZWtrMDNKRFgxMGNV?=
 =?utf-8?B?NUpPSmpDTld3bG5XTnJUN0JONnowNmRhMFRqR2x3ajdVajFqbnQrdDgzc2sx?=
 =?utf-8?B?dGQ4bkZhbk91L2tFaW9yYUVSdjg5VVZ6Sy9rdk00WjF2RDAxTVdxMUZFUG9m?=
 =?utf-8?B?ZkovRzFNendlK1A0UTIwUk9WV2VTTVJEQWVIWDNHbVM0SmZIVTFsTUNsL3hI?=
 =?utf-8?B?TFlsYUI5TUNuMDVDbkJFVVNwemZDVHN6ZmRxV1JIeTRCamhiTVhlWUU3ZkRZ?=
 =?utf-8?B?Q0xlVldJT0J4dHhRMXBwNTF3YjJQdmhsd2NqNHZWbTNrWWd0L1RHL0RYbDNk?=
 =?utf-8?B?VC8zK1dnVkxQcTJUbWJZUUZIb2NTODBpbVBkQXBYU3FMOVZZSWpuS2dJSnln?=
 =?utf-8?B?Q1MxSzMybkRqNzk0MlNLMW85YXl6UEFPTnV0Ukc4ODBNSUhMcmczWnZCNis4?=
 =?utf-8?B?U0toOXNhQlh4dDNQeW5YODlIMk1JS20yVVVMZndEWmpacDFGSXM3dHlSdEZz?=
 =?utf-8?B?dzJZenhaNjF2WE5GRldveEp3Z0JuQ0FQVTFrbWg2WnUxb2FvQ3IzUWhCeXRa?=
 =?utf-8?B?QzM2YzdRc3pFb2NScVduM2s2ZVpaUEtTRDlrZTU1c1R2NmVBQ0hvWWVtdE8w?=
 =?utf-8?B?RnlxTW56MFd2M0JwczdOREVNTDBUY1dYL0dzdG11cnIwZElFZTR4bGRTVkc0?=
 =?utf-8?B?NS90R1NvSFBnT0pYc0lnYzZJUHY5ZGkzMk9MOHhSNjlzWm5rQTRpMHVTbGty?=
 =?utf-8?B?ek9kL1N2MEF6K05zL3dlUE9UY3dNVjRLcVhwSThYb1UrMVRTUHduaW9wY2RX?=
 =?utf-8?B?cnFXS2dSTnZiQzNlQm9CK0ZnallJaTdPeUxPR3NUK0ZBNno5UXdib2lnZFpB?=
 =?utf-8?B?eWpNR08vSG53Vkh1YnFpMFlKOHA5aTFwTHh5WGR0dU5YWjJOemFqSWx6dDNt?=
 =?utf-8?B?cnVpRFBYZGJ4SmszSm1wTVJUd2JlOWQ2MnIzM2w2S3NWTzdZRlpKcSt2WFlS?=
 =?utf-8?B?azVIaWZnNnB3STZLNTZ4dG44RXQxRWpqSThhTUlFamxtL0ZHaFBXdzU1VHp2?=
 =?utf-8?B?YWR1SmdhMUFQSmdmeGV4eWYrS3ZYWUVWdmtacjRHTTNlVnFFY0JqKzU5MlNE?=
 =?utf-8?B?azB3L3cybVZLd3BkekdEYnEva3gzbXoxZ2p6TjFMaFVadTJJMW8rSSs3K2d0?=
 =?utf-8?B?RzM5eURTWkJyQW5wWXVwbFdJQWN6WTZPdElJUlhDRklDRjgvQ1B4cHR3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFBaZ1Y3UW5hVjk2dDFiSGVZeS84aGx5SUZtRHNQMVhNTHpQK3o2OVZIaXQ1?=
 =?utf-8?B?MmpYcFJialpzUXJnZENjZmZ1QTBHbWxwV2pVMzFEUGpVT2dhVGovZWgzbkVh?=
 =?utf-8?B?SVBXcUN1dVlOOXZVNHRMRXlWSlR3OXMrUTZYVksvK08wSlBQT2ptQTFoYkN4?=
 =?utf-8?B?MCtlM3ZaZHVZajZBZkJpNFNzc2lwRGVreFhoM0tNK0Z2Rnd0VmlkK2VLeThx?=
 =?utf-8?B?cnhpelZ3UzdIdFFTMlV3d25icHFyaUd5YVZxUXhQVXU5bGVyRUtJWFpyZTVr?=
 =?utf-8?B?TUsveC90S2lDRng5SGZiTlJsVjYxSkpPdDc0a2llUUh4Tjh1MnFndGJJamhS?=
 =?utf-8?B?cVBlbTNXb05PNWdCR2JWYVhrQUdZVHRGYTFGNyttenNyRmU3cHhlY3c3WUZa?=
 =?utf-8?B?aHZSR1Myekp1cGRJMFJEcWlRTTlVemxyQ0E4K2FRWVFvVXRheFpBcCtZck9v?=
 =?utf-8?B?UGU1MTVNNGxkaUordmt4c1N4cFJmWUJoM2l6V1o5SU5LaTIzWGdKQlNHTnFz?=
 =?utf-8?B?c3V1LzdYdno1eHBaTlc0Y3pWTWVHTlhIbnV2cEhZN3FkVjQ5bWNLQU9EMjg1?=
 =?utf-8?B?aUltYzBudXIwL3JKVGVqYmdlQVYyRjM4Y2dxSXdVOXVEaXlFVzQ1UlIwOWlY?=
 =?utf-8?B?R2dzUGNkK1F4L0V3b0xkdTdqUHZGWkwyZlMrR21yMHdvSWUrOExTZXNXRnFz?=
 =?utf-8?B?R1E0MnVZRnZqWEZwUDU5L2p1RERTZFJmb05pYW1WK0VIU0kzRW5mbXZzaEJs?=
 =?utf-8?B?MGo2eC9walhYRksvajJ2RXlqak95Yzh3RXJrSGpkTEVWNG5SaWpEakY5UXBu?=
 =?utf-8?B?dk00YUpOSmdGbisyRHE2Y1RMSHc3cXNyZGlQWGJvdmwzYnVrSmdiWGFaS2ky?=
 =?utf-8?B?T21rUHp2a2dVZU9FenJwU1YxS1BSOUc2TGtRR3Y4NUNmZDl3VjJSbjZMRlZz?=
 =?utf-8?B?T3NYYjBYTHNTRFNNOVFtVHRraTdSTi9Eam4yY2kza0hSYXRHUnBDZEZOY1R0?=
 =?utf-8?B?NEhPZWk2bktGYXlpOXdmRHV6YXBPaXRPcDd5andxNG45TDlXVURnbTJXajE3?=
 =?utf-8?B?ZmdnYW81NlBsQ0RyUUhYWDkwYmdSbzVlZmxmUHlJRGJOS2NBTXZaRFdhMy9X?=
 =?utf-8?B?dy9EM1lEc0ZIWVVoZ2Q1b0pLa0N6YnkyemN4SmV5Z2JGNUxvR0h4V3ZaOWVx?=
 =?utf-8?B?YXVMZ2FncGpaY3A1R212SC9ZVkxFc1MxWlV2M3dqQzNXREs5dHB4OW8yMzha?=
 =?utf-8?B?anU0V0FPOU53a09hcjZnTXVxMXBKNGhhWWg2WGwyVldvTFdieC9ybFJXdlZD?=
 =?utf-8?B?a2VqUytjYVRlRjNua3dLWHd0VzBza1pwTi9zNWJQY0JSQkE4SXp0ZXI3dlZU?=
 =?utf-8?B?M0IxZmZ6UTlzUTJUd3RFUnBSdi9ld25ESmJ1emZsMmZQRUFTZ0Y1dG1NS3NC?=
 =?utf-8?B?UGF4Z0tTN1lkdWpxWDVBcENoekF5bFN2ak9ycTh3QTZqajNWa3YzNEp4aURz?=
 =?utf-8?B?YWxaNGhLQ3VXR2drbGRHRVVFMnBoN21UelRKbkYybXdLSE5xcnp0VkJzZDRB?=
 =?utf-8?B?REZUNlB2U0pmS3VSQzM4Umd2SGU5RzhrYm9sZWJZRVBTb2U4OXJnVEZ1MWla?=
 =?utf-8?B?cGx6SlVZd1B0R0dlNk84Z1ZaQXMyU1dHeE1pWFJGYlRSL3ZTSWoraXFKNnFn?=
 =?utf-8?B?VjJiK0RoaFVTbTN3UzE0d1YwY3g0QVRnSnhHdU1Ldkw1WkxNeHJNZkQ4T296?=
 =?utf-8?B?YlVlZHMrMU5mTzZrc3NnTFVyYWNIazJJQk51V3dmM1pHLzAyZ3ZxS0t4ZFNt?=
 =?utf-8?B?dXkvbVZNWnFIQ2FWUGFCVlU3RW9mdDNNRzJGSkQ1Rm9mb1JmcGI4dnJTdFVu?=
 =?utf-8?B?VmhuTUJ4OUd3SC8wY1BxM0R2d3BFOTYrUkRycElJRW1haTdIR0E4WXVzUE5S?=
 =?utf-8?B?dkZFSHM1d0pVdzVtVE4rdEJQQ3cyM0dPaTIzcWFaNHNwWFg3ZWFNUXZrRzMw?=
 =?utf-8?B?aW5RTnN4MnFUTlEyUXArQVFHbnV0QXVMd3lBbWxhbFBGRzIzWVIveUQxTlVI?=
 =?utf-8?B?THJ1MTlGU041T0JlUGQvMWNkd2ExS0pkaVEyY21PZ0dXdjFZT2NtbEFuNEVs?=
 =?utf-8?B?VlZHYkl6d0gxektLdVBFa1FDb1dJTGc1ZU5zOWpHeUdYdmZPb1hNK3hRUStG?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 47dba287-9896-4071-58ce-08dc6d9ddd0e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 07:26:37.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysPgH1d1ubFW1Xg2wJHw5BO73GqAZRiOTH/w3S0uS2trrC+TuucLYLlXo4S2b3XdwtWgYoWPlvIWqnpBd21dSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4790
X-OriginatorOrg: intel.com

On 5/2/2024 4:40 AM, Sean Christopherson wrote:
> The shortlog is a bit stale now that it only deals with XSTATE.  This?
>
>    KVM: x86: Zero XSTATE components on INIT by iterating over supported features

OK, will change it.

>
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> Tweak the code a bit to facilitate resetting more xstate components in
>> the future, e.g., CET's xstate-managed MSRs.
>>
>> No functional change intended.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/x86.c | 30 +++++++++++++++++++++++++++---
>>   1 file changed, 27 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 10847e1cc413..5a9c07751c0e 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -12217,11 +12217,27 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   		static_branch_dec(&kvm_has_noapic_vcpu);
>>   }
>>   
>> +#define XSTATE_NEED_RESET_MASK	(XFEATURE_MASK_BNDREGS | \
>> +				 XFEATURE_MASK_BNDCSR)
>> +
>> +static bool kvm_vcpu_has_xstate(unsigned long xfeature)
>> +{
>> +	switch (xfeature) {
>> +	case XFEATURE_MASK_BNDREGS:
>> +	case XFEATURE_MASK_BNDCSR:
>> +		return kvm_cpu_cap_has(X86_FEATURE_MPX);
>> +	default:
>> +		return false;
>> +	}
>> +}
>> +
>>   void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   {
>>   	struct kvm_cpuid_entry2 *cpuid_0x1;
>>   	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>> +	DECLARE_BITMAP(reset_mask, 64);
> I vote to use a u64 instead of a bitmask.  The result cast isn't exactly pretty,
> but it's not all that uncommon, and it's easy enough to make it "safe" by adding
> BUILD_BUG_ON().
>
> On the flip side, using the bitmap_*() APIs for super simple bitwise-OR/AND/TEST
> operations makes the code harder to read.

Make sense.

>
>>   	unsigned long new_cr0;
>> +	unsigned int i;
>>   
>>   	/*
>>   	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
>> @@ -12274,7 +12290,12 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   	kvm_async_pf_hash_reset(vcpu);
>>   	vcpu->arch.apf.halted = false;
>>   
>> -	if (vcpu->arch.guest_fpu.fpstate && kvm_mpx_supported()) {
>> +	bitmap_from_u64(reset_mask, (kvm_caps.supported_xcr0 |
>> +				     kvm_caps.supported_xss) &
>> +				    XSTATE_NEED_RESET_MASK);
>> +
>> +	if (vcpu->arch.guest_fpu.fpstate &&
>> +	    !bitmap_empty(reset_mask, XFEATURE_MAX)) {
>>   		struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
>>   
>>   		/*
>> @@ -12284,8 +12305,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   		if (init_event)
>>   			kvm_put_guest_fpu(vcpu);
>>   
>> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
>> -		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
>> +		for_each_set_bit(i, reset_mask, XFEATURE_MAX) {
>> +			if (!kvm_vcpu_has_xstate(i))
>> +				continue;
>> +			fpstate_clear_xstate_component(fpstate, i);
>> +		}
> A few intertwined thoughts:
>
>   1. fpstate is zero allocated, and KVM absolutely relies on that, e.g. KVM doesn't
>      manually zero out the XSAVE fields that are preserved on INIT, but zeroed on
>      RESET.
>
>   2. That means there is no need to manually clear XSTATE components during RESET,
>      as KVM doesn't support standalone RESET, i.e. it's only cleared during vCPU
>      creation, when guest FPU state is guaranteed to be '0'.
>
>   3. That makes XSTATE_NEED_RESET_MASK a misnomer, as it's literally the !RESET
>      path that is relevant.  E.g. it should be XSTATE_CLEAR_ON_INIT_MASK or so.
>
>   4. If we add a helper, then XSTATE_NEED_RESET_MASK is probably unneeded.

Fair enough.
For #4, I still prefer to add all relevant xstate bits in a macro so thatxfeatures_mask initialization line length keeps shorter and constant.
>
> So, what if we slot in the below (compile tested only) patch as prep work?  Then
> this patch becomes:

Thanks! I'll replace this patch with the one your attached.

>
> ---
>   arch/x86/kvm/x86.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b441bf61b541..b00730353a28 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12220,6 +12220,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>   static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
>   {
>   	struct fpstate *fpstate = vcpu->arch.guest_fpu.fpstate;
> +	u64 xfeatures_mask;
> +	int i;
>   
>   	/*
>   	 * Guest FPU state is zero allocated and so doesn't need to be manually
> @@ -12233,16 +12235,20 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
>   	 * are unchanged.  Currently, the only components that are zeroed and
>   	 * supported by KVM are MPX related.
>   	 */
> -	if (!kvm_mpx_supported())
> +	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
> +			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
> +	if (!xfeatures_mask)
>   		return;
>   
> +	BUILD_BUG_ON(XFEATURE_MAX >= sizeof(xfeatures_mask));
> +
>   	/*
>   	 * All paths that lead to INIT are required to load the guest's FPU
>   	 * state (because most paths are buried in KVM_RUN).
>   	 */
>   	kvm_put_guest_fpu(vcpu);
> -	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
> -	fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
> +	for_each_set_bit(i, xfeatures_mask, XFEATURE_MAX)
> +		fpstate_clear_xstate_component(fpstate, i);
>   	kvm_load_guest_fpu(vcpu);
>   }
>   
>
> base-commit: efca8b27900dfec160b6ba90820fa2ced81de904


