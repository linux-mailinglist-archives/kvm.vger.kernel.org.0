Return-Path: <kvm+bounces-53416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 278FCB11447
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 00:59:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04078AC4AA3
	for <lists+kvm@lfdr.de>; Thu, 24 Jul 2025 22:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D1F23D2B5;
	Thu, 24 Jul 2025 22:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNUI+RH2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271A51DED40;
	Thu, 24 Jul 2025 22:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753397979; cv=fail; b=O4bE757nUoiMnOMOt2p/PU0Gu5VAPU9Qrh++Wgc7J2e0HgyYp34Vpx941sh4Wc/LkcgIZTezmR0aBQf6diglQQKX+fPA8ifArDKam5QCjmAJtUwQv6EthapzBzLuzqx3YcJdGWUO2inibNhjnfn2z4cBsNzdUTbwgYSHPc2RGC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753397979; c=relaxed/simple;
	bh=fVlJgkPD+fqWH6atHOplBdtrk/nmtTuzNik/qPekPwM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M08LqX7uFFp5Z4legHI40LOQQTonp5RllrHCfLlpx8fKKV6KLWs09L+0+ndOabgXMGyhpPjZth63lTO6geE7UKL2L087ol77e+fS8QiXoQcg2xsXb6OHWRundEcpuGjkFfccU5k4AYxrzcciHDZUZbpzm7+PDc/krY3axh/QTj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eNUI+RH2; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753397977; x=1784933977;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fVlJgkPD+fqWH6atHOplBdtrk/nmtTuzNik/qPekPwM=;
  b=eNUI+RH2lnomdBgJTBcdm0Et8k0U4TV5HvvHxO0YNUKjEC1E9P2zMWTA
   lRXbK6REhqBg+e0xSDowew13ZTMwcHnrMv/s9iXS6rDf5ro/YXqV0VHSO
   Zw1IdHVEg7N4m/ZAw6QMzMu7vodD54lVic3rhb6BTLQUc/ndS5G9c6P2H
   5vzLhB23HtAV3NE9jvz6hbGnLoDmdxPUcy52DYOR0TD6tRAcRLLj1Fre+
   cEDdSHKw7GlZOf3gSVI/eP9jir9Ad6GLHZxe7YkZCptKWoXO/q8bNqiLs
   Qu08r80JCWRXbTA02IHgcbzvXWbSWbcZ/toDnKZmGexRpyZ01hTlGzcq/
   Q==;
X-CSE-ConnectionGUID: crBhDDMdTBGNuyOG6Ejobg==
X-CSE-MsgGUID: 8l57PbrxQZ6reShvuxbKqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55668347"
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="55668347"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:59:35 -0700
X-CSE-ConnectionGUID: GIxBCBWfRhK+UZcWEx5qVQ==
X-CSE-MsgGUID: MJjdaneqRkaH6zQqXhBRQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,337,1744095600"; 
   d="scan'208";a="164771280"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 15:59:34 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 15:59:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 24 Jul 2025 15:59:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.56)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 24 Jul 2025 15:59:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BASKnawIVjjajrXnkLdLAJr1Y4DMCPC1pkm91oDC4TuzprMiGgxLnpezbuS6NHi/ZKjpvOR3pAlpapvoajwAXK4Gl8MAVcraxvoYZRZ9L97KDtkzlzhKtUWUxV0xfARUl+uYfX6YnChUpWRRkXADaBlAh2BsHW4nI1SKJzRx8Eo3Mm+xTCtr11KgYKmQqepy/yaa6NcxHV9c+jvuZbRVQtDOWDkL9NCT6f+9j4sIRd6bplxNOJU+jVwup766nCfmfoSUkRkqWXjWtJpY+8d6QrasP3/sclcFwWelo+MOjGKYcE7imt9qGx8RnS3SztaWzzlBedmjrTcaiOlrgW7cgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjvmScplIZnqIZGkLGgrLor/3QjOXq4GxqKadrEtwYM=;
 b=W0t2UDM9E57/M1wqNBrInTUd8Zl6HlZ63rEs96Gfy39OXBS3Ughic9nj13DQSVGQoCXf4Fx+d2hwq0huxswWV2dxI6PkQddtgGmmckpEvni7Rkx6LuQC9NQFEKI0rvWpUE7FWU3L1Apqx2MWcJjPuchSn9LM+J2JicoRX884Q5+bIptovYNkraJr+cBaSAg5Q/HqIGAIn6yeDSVHxjpA5TiigD6fcZ9/N0rjGSkCmcX4UEiIee+/p5bVf7gMaqrx4TqCxebnbkf54MVTI3yZN83ksEq1F8EdV/fR2EU0OJp4VRGd/zGLWwNiyjDfAe8d62cmgEv8U6sffjXr0qAi7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by BY1PR11MB8126.namprd11.prod.outlook.com (2603:10b6:a03:52e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 22:59:15 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 22:59:15 +0000
Message-ID: <768d8534-454e-4c3d-a41e-3f82c2347b0e@intel.com>
Date: Thu, 24 Jul 2025 15:59:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/10] x86/nmi: Enable NMI-source for IPIs delivered as
 NMIs
To: Thomas Gleixner <tglx@linutronix.de>, Dave Hansen
	<dave.hansen@linux.intel.com>
CC: "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, "Ingo
 Molnar" <mingo@redhat.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>, "Sean
 Christopherson" <seanjc@google.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-9-sohil.mehta@intel.com>
 <aG1laKXYu7Uc4Tsb@google.com>
 <d7a11ebd-48d5-48bf-abac-317d5da80a6a@intel.com>
 <aHBBdmdMGHbv5lSm@google.com>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aHBBdmdMGHbv5lSm@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::27) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|BY1PR11MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 9107e262-482c-4615-810b-08ddcb05b636
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TkVoc202c1ZiMFdkRUZpWVpFRXNObFhjOUlYd1M3MUNwcnlmTTc1SnRwaFJB?=
 =?utf-8?B?b0J1Vzk3bi9idXVVbDArNFFEU1IzdTdkdlczbXB3ZUlQYVdJZk96dzlXWjFT?=
 =?utf-8?B?WWhrZExZbnM2ejdYdElzNjZlcWt4S3FOam16TGJzTEswdGwwNGtDSU8waE9n?=
 =?utf-8?B?RUtmR09UQktLd2h6WG5vNjFpbkxyNmpZcGQ2b25wcVBVbFhiRi9sZERZN0pX?=
 =?utf-8?B?WStZQ213TTVGYm1vdWtvN3QrVjFzaGpjQXk2aWthcTNWNmdoaUwwZGM4OFpP?=
 =?utf-8?B?dDV4eU5iVGpaeGEyMUVRQUY2blRKVU5QTHR4c1Avcml1UXNoUzBGcFI5Q2I4?=
 =?utf-8?B?N3prRjRxUnhFK1ZsNWROVUVEVmltZ0dpd0M0Mmtqbmltc3hpeUVpUnNmZ3NK?=
 =?utf-8?B?ekhNaGlxYThka05hMGdmcXdwMTNaYlBDTkVNMm0yOUN3a3RYdUZyOTNNVSsv?=
 =?utf-8?B?aEd3YjJVajBOZlc4MmVMeE41eENrQ0x3dE84ZjNSREFLOXFhemcrUmNkSTFa?=
 =?utf-8?B?cytjczhaTWJaRVpwL2dMYzZ5am5ZUG9mQUFUNU9WakUxMklOOG0yZjNFZWFX?=
 =?utf-8?B?TFNZenVsMDBTeGVBV1czSnFUYVRNZWV5dG5sOHpkOW53RlEwRkpyRXNKTHNm?=
 =?utf-8?B?aHRDdDRVS1R3WFZ1UG14eGhVK1lsUVVKT2w1aUhPbmc5V0kxLzc2amptQUtR?=
 =?utf-8?B?bll4dzJZR3lBZDZTSzcrRWQ3cXZYZU1oTzdpVkNydVJVSWpsSGNIWitkRWxm?=
 =?utf-8?B?MVEvK21MKysrN1Mwb1dMc2FVZHN3Um11NkVKODErNnVNWVh0WHdYQlJpWjJm?=
 =?utf-8?B?UUlNUSs0dVVZQjcwMGdxV1ZVRk5tRUFJTWtsYUpJaU1NVXVJM0pZUmdnbGF1?=
 =?utf-8?B?TUdQNmsraGEyZ0pqVmVsR0hGa004bEhOV3FITWNtQXdPWFJBaHBYV2RxMVdx?=
 =?utf-8?B?RE9FRWVNK0kvc0tnLzc0VkhGcHdaWVR2dmtCMFFlaTJlclptQndyV2VIc1Nh?=
 =?utf-8?B?Q0ZCbW1NbGhsUkNHM2VIUDhUV1dOVWlOWnFUZ3l3bkw2YlZGbXZWaEdyMTNY?=
 =?utf-8?B?QVE0VW0yYkJVU0NxeDlsMlF6M2IrckFzRTBRcUZaaFg4TU0zclhOQUNsenNh?=
 =?utf-8?B?VWVwMUd2RVk2Z0NRdDNiN1p4QUVqVHZaVmVxQXloakpTWFNWc3czVDByUTJT?=
 =?utf-8?B?dG43clZGa3VOZEdCWUJ4NGNJZW9wMGFkUkRBWFcxQ3lvdHUxcjVQaTI0U3dO?=
 =?utf-8?B?bmxUbFIwMGQ2dTNHQmVSUm1ob3ZWbHFzRTBpcXQ0Qy9BNFRXU29qRUNJV216?=
 =?utf-8?B?dHlSTEQvRFNjLzd0bUJuQXJQVVlhT01KRy9hdFFLVisrWlNxb0xjcVkyREov?=
 =?utf-8?B?eXBSZ0h6N1Y0Y0VzcDFTYzMwUlhmaTBjMTNjdXdPRGI3RmNnZHRhTVVra0ZV?=
 =?utf-8?B?a2taN2pYTUoyTVd1SG90TlVHRmZTdDNqUXVkdXhFQnJTSktBbXlrNndyOFVC?=
 =?utf-8?B?QklCT2U1TXR0QzFKNDIxRXJPcnhKbXU0eDQ1dW5QQlkyemtsUjA2T29GcVUr?=
 =?utf-8?B?bGczdG1QWW51bVlha2VCb0ljcnozNThUVzhObkhJVllVSWNad0hKRlJ5bkpo?=
 =?utf-8?B?MUNtdTNTZlJ5Y2ZWcmluazMxaVZsb0FGcDQ4eHBkZFM0bVdwenZOOWpqTys2?=
 =?utf-8?B?d2padUNTbGRnQnZhRjJ3ZHIzdlo4VG9mczdyTnBuaG1sWHlWSml2T2w2dk11?=
 =?utf-8?B?MjJJbkpjK2ppZkRoL2pNRktjYTBoZ2ZBWFBTUHVIOGhyaS9WMzczdTdjZnBE?=
 =?utf-8?B?N3djVDVhUFJmcTFpdytzTTdtTVdJekdRMEJHUzF1NU5Pek8yWkVYWVNvaVhT?=
 =?utf-8?B?Qk81MnRPeVJJZWsrNHl6eE83aUVDVjJzL3E2ZjFtaDQvMzNWU0NIb250ajJq?=
 =?utf-8?Q?2p40jBled1k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHhBMHd5MTRlc1RUcm1nV0syRlNLUThKUC85ZUlJL0JMVnNOdFNzRGhMQzNP?=
 =?utf-8?B?KzQ4VzFTMnd6b0taWUIvN2hXSDllajNheEZPdlNBaERYU2ZTU2UxQ1ZOV1RU?=
 =?utf-8?B?Y3lDVGNselp6eFd0eUdKSUFkcEFCdGxpN0k4NW9tWHQzQ1M4SlZ6WXI2S1pE?=
 =?utf-8?B?c1lVQTZzK3c4eFlhM1l3MzJrSkhDNTl6eU8rektjbU0vcVdycUFZL2VCZk4x?=
 =?utf-8?B?UDQvWmszcHk3YTVaK01mc1ZGNHZvN0lNNGhvYVpmZmhIQWkzMjBCNXBlUTVX?=
 =?utf-8?B?WjdMVFRUbDRwMjFhaDFMZFFjWlFLdnh5NThLNDd2blNCZUpPWTliWEV2cXp4?=
 =?utf-8?B?VUtNL2tOTitQemdPSnhZYTZ6ZFlsMW5LL2lTNytuMFRGOGVidHNvUnNRMWtw?=
 =?utf-8?B?Q1M1Y3czV2dYRk5tUEtNb0lUT3FteU1MK2diS1FsZE5TbTB0VThHOUZYVGIz?=
 =?utf-8?B?Myt2anBYbFNFc3ZzWGRjRmEwMDhLblZkQThjb2l6eGNRc3FaZFJ6b3pmK1BK?=
 =?utf-8?B?alpON2tlOVJsM3VhdUE0YzBucEFzSE5temRlWnAzNFVuNHFmN0JCSFZTUmMx?=
 =?utf-8?B?NHpxVEVNbmU5Wm0wMk5xOWV6SnkvdEZTV0tuT1VDdThSc0dwQWM2MThIMk9F?=
 =?utf-8?B?N2NUL2RCdzdCaG84Zk83NFh5WVFuZk9jbytyTHNXTEQ4WHJsdGd0S2FPZDRh?=
 =?utf-8?B?Q0h3QlkrS2ZMVllsb1NTSmwvMFVOcFJkSmZpRnBiY012YzEvSllqYi9SS3dF?=
 =?utf-8?B?dytVRjgwREhkbjZtV3RQdzVENXBFcVVjSG9xUHd2TGNkS1ozUnp4SnhxSVJo?=
 =?utf-8?B?NlhQR08zT3RqUk9JM1ovczFuY3pVYWR6S0hjdzNKeWt6ZWsyQUt6Mi80Lytm?=
 =?utf-8?B?cjFvWnNzU1ByQ1FDeUdBMzR6UFB0ZXd6ZzZCVk1QTUNRTEFQczhSWU9sTWNm?=
 =?utf-8?B?N3JJb2MwZlRIUEIxOGlpcWkzWkVHQlFJT2hoM3J4SjRxcTQvK3RYR2hteWhI?=
 =?utf-8?B?UDRnVEdnNzE4MzdjN3RiaTBUNTZVRkJVQkkwUGdPc0czQlo5OXZwRG9EcHhF?=
 =?utf-8?B?WjhQMWViTTh0Snc2TGpEM2NsVTlNWjVWRzlCR0NKaS9NN0RQR3NwakN6cm1T?=
 =?utf-8?B?SnpWZFFJZFpvaVFORlI1YUxFZ25yaGZXS2ZiTHlCSFlIOVM4U3dIUmViQ213?=
 =?utf-8?B?eVliNjhLdXNQRVRqbjFjQkNwK08rMEpOQWtrVmhjbkRhR29UMEVRK0RYN2wv?=
 =?utf-8?B?bEdwN2FXTWtlYi9NWTR2a1NMWlgyUnQ4YjZTN0E3QVI0NHJxMUxZVS93b3Br?=
 =?utf-8?B?UEpKUTR1TFZmOU1oL2gxenZqWWxIbk11Uk5rVmVieVUxajVrYk5IQkZ5Nk1m?=
 =?utf-8?B?WVdYdWxhRGxmMGZDMGRKMHF5Vy9Ua051VzM4MWR4dGlkeWQxYVZnek1aQTJE?=
 =?utf-8?B?TXhia3Q5dG9na24rb3dHQWxsaXlUWUd1TzhGSUwrejA3bUhVVFBpeTRGY2xi?=
 =?utf-8?B?NU1EYlZYTnZYS0hzOCtUQ093dWtjQVRZcGJvb1FtNDF4V0JYVEVEZUdYTGV5?=
 =?utf-8?B?OWxnYlhjWVdRbHd2TWdKOVBZMzRwdXplUW8xQ202U2J5bnhJc2doL0xEdjFk?=
 =?utf-8?B?MkZhTVh1OXNkc3dZc2tQbXp2emVZVDZwZXUrc3hxTHNMNTdvM3JjSi9LTTk0?=
 =?utf-8?B?Ui9kQjNQZFphZUEwdXdUVldTb29YWWRycTRoRHNBN1M3aGJhWkY1WkxrekZP?=
 =?utf-8?B?UlhDeldnSUxwa05tQXI1czJkUncxRU0yNy9tOFVXZUJnQ21IYXlEUlAveVQz?=
 =?utf-8?B?SWVCa096UHVBWFVJRHlsbUdsNWVWdFhTeW85OUpySkphV3A0M0xZUHpNNUNp?=
 =?utf-8?B?c0tmL1BlOVJvUlFPOVBwT2JKTExTZWVzRkhzb1prcVJZNXVMa243TUpNbXIz?=
 =?utf-8?B?SENQVnBNNFVaa1RraTlMSWd6UnloWEsxcm1sVUVQYmJBKzZDcXJNajE5UDlq?=
 =?utf-8?B?ME42RHl6bExrdXljVGJxVmpPdldEK2gvWmcvTWZoN3krVVlLenFSNUdGMDdm?=
 =?utf-8?B?bEFTcVN5dURIak5QV1ZCdlE2cHdPQThIVGtNbWM0N2JmV2FNSjkzT3NlYWRz?=
 =?utf-8?Q?9F/8kSIckVzzPaUlXtT4xhsa+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9107e262-482c-4615-810b-08ddcb05b636
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 22:59:15.6697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VUjG+HFxpXfO74U0VyRll85llsbIYnCSI26ZalLfv17/z8mn2BY/UqY8VTpUJU6g4/Uig9jWu94PPXXgstpQwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8126
X-OriginatorOrg: intel.com

Hi Thomas, Dave,

Seeking your inputs on the below direction.

On 7/10/2025 3:40 PM, Sean Christopherson wrote:
>>> One thought would be to pass a small struct (by value), and then provide macros
>>> to generate the structure for a specific vector.  That provides some amount of
>>> type safety and should make it a bit harder to pass in garbage, without making
>>> the callers any less readable.
>>>
>>> struct apic_ipi {
>>> 	u8 vector;
>>> 	u8 type;
>>> };
>>>  
>>> #define APIC_IPI(v, t) ({ struct apic_ipi i = { .vector = v, .type = t }; i; })
>>> #define APIC_IPI_IRQ(vector) APIC_IPI(vector, APIC_DELIVERY_MODE_FIXED)
>>> #define APIC_IPI_NMI(vector) APIC_IPI(vector, APIC_DELIVERY_MODE_NMI)
>>> 
>>> #define IPI_IRQ_WORK		APIC_IPI_IRQ(IRQ_WORK_VECTOR)
>>> #define IPI_POSTED_INTR_WAKEUP	APIC_IPI_IRQ(POSTED_INTR_WAKEUP_VECTOR)
>>> 
>>> #define IPI_NMI_BACKTRACE	APIC_IPI_NMI(NMI_BACKTRACE_VECTOR)
>>> 
>>> static __always_inline void __apic_send_IPI_self(struct apic_ipi ipi)
>>
>> I am fine with this approach. Though, the changes would be massive since
>> we have quite a few interfaces and a lot of "struct apic".
> 
> It'd definitely be big, but it doesn't seem like it'd be overwhelmingly painful.
> Though it's certainly enough churn that I wouldn't do anything until there's a
> consensus one way or the other :-)
> 

In order to accommodate NMI source vectors, updating the send_IPI_*()
APIs seems like the right thing to do for the long run. But it would
introduce some churn. Is this the optimal path forward? Any other
options we should consider?



