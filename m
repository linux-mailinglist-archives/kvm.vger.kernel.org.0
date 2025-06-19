Return-Path: <kvm+bounces-49999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37498AE0FC7
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 00:55:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D55173BE83B
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 22:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C1E28DB53;
	Thu, 19 Jun 2025 22:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ipIGyIa0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083F72459C8;
	Thu, 19 Jun 2025 22:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750373695; cv=fail; b=JKcf8YZmsDq1zjs/74xoLGCZSoik8vzY2dYhdUErrbMsa71PwCSwzZAsLRRfwC7ImKZVqh+AEQJdTZBjMEFAPQLv6GlZPMnfL+yuzRksRzlV4uSkUbgtj6X/5AAjIie0N1UA/oVLqFAaPrqXiOyVZRZ3j6bjZMtR1jFOBDDzjxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750373695; c=relaxed/simple;
	bh=0z+be5gcOoM6+mcB+wOHSPHcsPzW0R2DSJOhttlkYaY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UKPYtMKQMYlBtC/SLtoh5Xll0smTli9HXYi2xF+8ZrgQ6ZqdBnzZpgyZFIE3PrX7YrUm047FmNG2BQGK0s+yqTQAxBNyOPhMDDFHd/jAV2QW2uzcSK72k4N8yDGW5hSvPShl5zelhN6PMjs7pjmyIS6fWY1/SYkeWYiwol3ggFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ipIGyIa0; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750373693; x=1781909693;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0z+be5gcOoM6+mcB+wOHSPHcsPzW0R2DSJOhttlkYaY=;
  b=ipIGyIa0EnaWYKqbZ6VOMcqU44tXbluVdBR0bfHAsNowA1nh9E8ss/mA
   ENC4DZZd7ViQEAwbKh9Yh6mJiFdn5cHkSuOg/0iSJXfdhhzQ7xRTpmAgO
   ZqjdavmCY2eRsuYCh9xJOO6RM9fmS1m4WPDtd3Prsh9SyIB0S/r0km7Fg
   MAergyt60DHrTQ229qCMQZA0Wn8+ypaXnzbCrAF67THZUA59Ym04aZRQr
   pWW8Q7WFULd3XZIWUoeCj3RBdrWUYMnbFieAltmLes7lRTS9xWcIHF8VA
   z19ta/loalGYvkCjzsx5vWoGtbLKfsY5jQOddfv6S+kfRtJf7n/hPUCMU
   w==;
X-CSE-ConnectionGUID: //Bu4Z9fTH+r6R2JHc8EIA==
X-CSE-MsgGUID: SDJKPahUQn2GTyv2BQbDxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="63674281"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="63674281"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:54:52 -0700
X-CSE-ConnectionGUID: NzpZN2TkTie8Av/U95BhCA==
X-CSE-MsgGUID: gwLk7nX+RwiBaQd2Wrx/CA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="151440215"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:54:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:54:50 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 15:54:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.79)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:54:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H2374R4AfRxeyhH3XiaK0fTSeEJy6yd/wuOxTMgALmjBiwJ9DlRAoTUwTJKCoxqGJXBLByA4jeds4Tn7sqi+cBFizm2MvNuQ4pVuqSeFV0CDUNmsUsGQFQAfZ5fksyP6+Mp+8zzSbVP/QKoNTXmiVynN3y1osbDgLVd22wJjAK27Ql6USqRSkmXS/NObgokviv69athkeFiLcNC+M2Qt0IBpJ0SkgB58JzFxPWFJ6t0CBGV1GlZXCH+1d7B7fg2wzihGexdmgVtx/Luv0WMvfUFIBtr+O2J91P9Vf9kljnK3E0QoediuiNFUwb5yZvQS/Ja1GVREBGP6spJB8VhCEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UC3/wioSgbX1P1EvCo6b+neeB4EeKJFHXCbKIHRhvLM=;
 b=BjPrOOyza2Gh/kI7dzRKH+v1dQazeILWYHQCveYM8eZkWtYRsQ7NFKnh+LKNuyklqy0EHgUZbkUZsCjU/SCe6LiKdov+tQohs5mmCxcKPd3L7jUZ0sA/VgmtwOGq9xsvOA/04TGPiK9nb8gncKcYWU5elezp2mrQTstBTDXHZT/R8+iOo8YaxAbyueMRAtSJwO5OrCBwswHoQjpgkfGkdFPsiF5MimLYxA4eK9KXija5dhmgBAjySObwP2Qvab8S09P5a2ByxLZZdblVwNgewxxdXIngytRf9OW1rjdSKQDfpX0OXnjwCr5gAsocHAlZ6WLFzuSMzg+WXAuTupde4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3322.namprd11.prod.outlook.com (2603:10b6:5:55::19) by
 IA3PR11MB9327.namprd11.prod.outlook.com (2603:10b6:208:57a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.22; Thu, 19 Jun
 2025 22:54:42 +0000
Received: from DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e]) by DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e%4]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 22:54:42 +0000
Message-ID: <77266075-e90c-4620-a95c-f302be8d0267@intel.com>
Date: Thu, 19 Jun 2025 15:54:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/10] x86/nmi: Prepare for the new NMI-source vector
 encoding
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Adrian
 Hunter" <adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>,
	"Tony Luck" <tony.luck@intel.com>, Zhang Rui <rui.zhang@intel.com>, Steven
 Rostedt <rostedt@goodmis.org>, Andrew Cooper <andrew.cooper3@citrix.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Jacob Pan
	<jacob.pan@linux.microsoft.com>, Andi Kleen <ak@linux.intel.com>, Kai Huang
	<kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
	<linux-perf-users@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<kvm@vger.kernel.org>, <linux-pm@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-8-sohil.mehta@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250612214849.3950094-8-sohil.mehta@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0014.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::19) To DM6PR11MB3322.namprd11.prod.outlook.com
 (2603:10b6:5:55::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3322:EE_|IA3PR11MB9327:EE_
X-MS-Office365-Filtering-Correlation-Id: c7517142-3952-4c5c-8d37-08ddaf84473d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Z21RQWxzZWJkZ205dlNQR1BoRjNXRXBLOWs3Q3U1QUFqd3RVQXFReUhwSDlM?=
 =?utf-8?B?K2FxMG9kd2ZJbDRESlZ5RHV0MDhqV0lnNFIwcjVpWjNpYTJjYjhtcFZsZS9t?=
 =?utf-8?B?N01IRFhqNTJ2aUg5S0NpcVV2MnZDVTg4MHVwTUFjNnd2RlMrUGdkY2ozMjhQ?=
 =?utf-8?B?ZmF3N1Y1bEFmRXYyTkxQN0MyL3pOY3VOaFJVV2dyVmY5TFdMVmhmamJwK1hZ?=
 =?utf-8?B?NytJSktOWTlNSG5jQkdJaUhtOHkyRnR2cnl2Q0U0M3hpSis0Q2w2M001MnA1?=
 =?utf-8?B?LzZPR25jU3RDbm9ENlcxbUdaRTBOYkE5cmQ2aWpPb2JFVHZnSVk4K2QyZ2hn?=
 =?utf-8?B?KzlRSnl2T3c2V1ZKY2tpUmt0eWcrcU40YWo5V2NlWHprVUdVcUlQY3EzQXBs?=
 =?utf-8?B?a2ptV2VhMEpRTE10Z1pETXFrTWl1UHRkY1B1Wm04UGVFRmFHRWZ5bVBWYVJH?=
 =?utf-8?B?M1J6b3g0SzdnNE1wd211cDRSZEJ1ckFFK2lnUEN1QmNOaEcxcHdhWWcvZGdG?=
 =?utf-8?B?TmFmUmJpTnRUZE1WbTR6bWM5NTU5UGczV0NBNXhZZXc0QnBSMDREbmQ3eHlY?=
 =?utf-8?B?ekQ1b2pIL2JZMFpVZ2g2UUI1eUV4UlBIdkZlT3VqeEJDNnJBbW1CL1BSL2RR?=
 =?utf-8?B?SU9MTVdUU3oyQTYrbWo4c3RTYkVIRWlMR1F3SWgzMW83ZHlsalQyNkdBa2Vs?=
 =?utf-8?B?S0ZoQ0RUZjlIVXpldXlGS0tybGdSdTZrcGZaZlJENzNxSTV6bFZHZFlYR0xT?=
 =?utf-8?B?QzZ1TldlTXRBVjFNNlNhTHMvUUlpNmRidndkcDByV01FMHZCRFhMTjRja3lo?=
 =?utf-8?B?RHNxUTFoem5seUV4emx3T3BWek5Bbm85ZmFLTWRhNzc4OWFFS29Yelpick1p?=
 =?utf-8?B?eFAvRDRsTkRoSHArOTBaUWZwczhlaHdKQzdOVjJMeW1xMnlGeWpQREZHOXRj?=
 =?utf-8?B?UFhrVEw4dlNVK0s3YktZbTVoZzdEOVQrYzJBT2RiU013cUx0M1hkbjc0WE9R?=
 =?utf-8?B?M2FUbGN6U3NaeGpVK1o1L3BsVU9paUUwYWNna01iWWowd1FlNG5jWkVEUy9x?=
 =?utf-8?B?Z0tUMVMwditkYU1CU3gyeXB2U2JaREF5YUU3S25zU3lEL1Izbm1JM29WTm1Q?=
 =?utf-8?B?dDkwVXo5NlBLWXZNOG1QV3hNaER4dEhRVXU2MTBvMmE1ZmN2dHNlTHIxWnBl?=
 =?utf-8?B?TWJ2RUJ1c2J3aTJVQVp3b1ZaMXlQU3NyS3ZxMDMyRDZLQy9CdVhEcU1QaFVI?=
 =?utf-8?B?TC8zS3hUQ2kzelBJUGtUYnN6QkZRb1Fpdy9oRmtjSDFxN1RFNmtPQmtQK2xr?=
 =?utf-8?B?ZTYxdXFkZjRCN3hObEhlTTdDVEF2cXRXZVVaZ1V1WTFHM1llclk4RnB0cFoz?=
 =?utf-8?B?MTc1K3pGcTY1UFZwc0ViYm9YYTFERWIzY3ZYOXc1em0vNXJWRHJOdFRxRk9I?=
 =?utf-8?B?ci9NVGhsWWJDSS92OTV0RUxOc25OVCt1UStFbUJXVU92QnRpVTJKMWpHY09h?=
 =?utf-8?B?RXNpUVBxL3VDdFQyTDFtSU8yb1FNb1BwK2ZvSlR1bFNpSjlkZjNINStUb0F5?=
 =?utf-8?B?cnJ5OVBOTWcyNUxLK09VNUN5bGtYVTg0TlEwMTZYdmRmLy9yZENZaTFmbE8x?=
 =?utf-8?B?KyttM1RhUmpMamU1blFVdWE3Yy9nbkRlMTdMcDUxSk9GbVljdVA2SzY1OWgr?=
 =?utf-8?B?S09SSG5hUi95MWo3NzlOVWVGWWRIeEkzcDJocGVVa3JRd2h1WkduL3ZpRVM1?=
 =?utf-8?B?WklKNGxuRGpUeTYvOVlqWU9OM2VXREQvUkhjL2V2eGlBR3lxR1cxd1BKZTNt?=
 =?utf-8?B?TkZodnU0YmIyQWNFQUYrVGUvWGtodmZtcFZtRGw2SkhPUGlncG1KRGhJVXRq?=
 =?utf-8?B?U1RWUVhZbWF2U2VDaWx2MTZKNWtYZk94dlhjTXppbWwvSE9IZEZaMnRaK0Vs?=
 =?utf-8?Q?51T+/wr8GZw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3322.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkthUmVGY0xOd0JPZXdEQ0JWbUVhL1Fyck0wWlAyZFhWSk52UnRaMkhYb1o5?=
 =?utf-8?B?TklCeWx3Q0FnNU9oVkVuaTBuV0RLOGRWUWs1WFlMVUI3UXQ0dW1ERjcrdHR0?=
 =?utf-8?B?clBjM1QzSW1DQW9JZWxGZTR0UVlCcHRDZTllcFBCZTVtRHdLZkNLWlI5NUVS?=
 =?utf-8?B?bG9hYXhBK2Vlc011SDd4eXlNdDFXa0VMd2cxQ25mNmt4ZUYvRjN3TzdENGp4?=
 =?utf-8?B?MGp6ZWZrSGt3UE9kUzFYVVpkTlhCZldERnBzTDFEQ1dleGRuOEFFdUErS1dE?=
 =?utf-8?B?MHZ3a0Q2ckp3VVduK2p3YmQ2eDR1SjgyVjk4UjR0L3hCN2ZQWE5VV2hRY1Jk?=
 =?utf-8?B?MkYrSUx3OEJKRlBvb1J5bGd5S1BMY2RhL2xJdjVacWI3aHh5MVFUb0lXVmFr?=
 =?utf-8?B?aGFFVGRRK2NFcVMyNjNYMmY0Z3MyenV5Y3h1Zkh5ZXQ1MFB0K0lNNk9MTC83?=
 =?utf-8?B?eDhoVDRKd1VleFBRN3pXaEp4SEgrUVhnYXk2NUNMTmVEM1VhTTdyZVpPMmY5?=
 =?utf-8?B?bEVySXJYdVBZNllzRHhWTy90dmFQSE5zU0FBUmdtekdudGtqWnhMYnFMYTRU?=
 =?utf-8?B?WUhudDkxWThpc0xwUEM0NU9WRDR6QVo2czdjLzNRV1Fhd0FCRE56NllDT0VT?=
 =?utf-8?B?SGtaVmNGaitJWUpWRHh2c2VSZGdzemNYNjg0Nnl3ZVVTa01lQVRPU1JGOGdl?=
 =?utf-8?B?cWFFOWxjTTdCNGp3N3ZrdUprSFFiQ0ROSjh1eXpjZTFxRnFkdHdEY3dsbHNH?=
 =?utf-8?B?aDlPbGJoSzNJZDJUbk10MENwRTVYc1JtKyt4M0w0NjRZSW1ndDRRNmFiNFAr?=
 =?utf-8?B?d2ZySFhvNjExblk0bkI0S0d5Z0JyczJsVldrbXEzSzg4OWFvNU9MV2xyQXNz?=
 =?utf-8?B?eG9Dd2VJbTNTN3ZBZFlHWjM0QlFVWStldUh1ekZrZVlPUVFjUXVrWC85Tlov?=
 =?utf-8?B?dzZySjBOb0NHWTloaVdQemtMWUlOSWhKVytJeEovVlRDeUdjenB4TGhXNVVY?=
 =?utf-8?B?VUo2eHFleW85UFZKL2FSMDFQbEQ3OEtTa0tNekhjR2VVTXZTVzJJOXJCQ2wz?=
 =?utf-8?B?YlpoSWVhVXIzTEd5Y1JjakZGRjZIbUNRYktIYXVjV0w5WUREdkxCY1VGRWRE?=
 =?utf-8?B?TTg5a0VESFFrN2szMWZoNjhMaTV1eEswNmlRWWpJWlpka3YrVnlrajA0YkRR?=
 =?utf-8?B?ZitiS2M3M2YwTkFCR1ZtTE84b05iMDNsaHMvQkVtMjZKenN6elZBNy9wQmF4?=
 =?utf-8?B?bEVxQkk2UmlGTzVhdDRRTEV4b29KcnJOUUxYSjJ5UzF0UTc3cHF1bjVyV0Jr?=
 =?utf-8?B?VTZqRC9hVmFJUFRxdVB6OWJFYlJiUWVKRE10MXpNYXVLd0FUSjdWcktSNEZv?=
 =?utf-8?B?S1FTZGNXWnhGWmtyKzZ4Z2hueE5LV1V6WFk2Q2hLbzZHNUVxVnRORzQxR09u?=
 =?utf-8?B?ek5EYTRTaUVuVk12aytIYnE4Zlk0bVNNeGtwUDVkY29LRXFKSVEwZVFXS1Iw?=
 =?utf-8?B?a2ZjZE1CREIvTW9WcGxWWm5IUlliZ3RaUW9JR3dYVnZIaS9sQ0NoS0ZUeFc2?=
 =?utf-8?B?VXZyVXpTWXc2bTBmd3hXemNSelIxdExCNVhQOHIrWEtYc0wxTUh2eUFycEtC?=
 =?utf-8?B?NklsWnc0RU1BdnJQUGZRa3FvbEhxMUVybFFDMmh1U3BzZ2V3WHhMcUxrT3VM?=
 =?utf-8?B?ZHlLcFJVUDlGRFh3MllsUlBrZmw1UjJScXc1ZG1od1JwZFFrbEl3dnNzWGhw?=
 =?utf-8?B?Nkt2Q2xRb0FWekpjVVlIcHBoOUF4anVTdVR0a2FMWHlvVnVObGNpUFVSVUMy?=
 =?utf-8?B?ZjhzZEQrSUFTZkNGNS85Sy9MeldHd29BdUlrcmc0K2ZrbkNCWW9DUkJaVzhC?=
 =?utf-8?B?a2pIaDlRSlNaNGNFbjRJNy83VWVCS2dUaVdMRGRvb2F0SFJZUzhEREZEWU9j?=
 =?utf-8?B?VDQwZ3FIc0pwTUlRMk5renNnVGVubTFuT3VxRk1zRDFQeTErQlRrZnE5eml3?=
 =?utf-8?B?T3RkbVRsMVVtcGlmRUhRS01XZk9SY3NHYTFDcVMyUDAzMzZnWkFxMjNBdGJH?=
 =?utf-8?B?N1RKcisyR0ZyMmkzTFFDQVFWOFZEQWgzWXhDdzRSeTRVZHBScjRHR21pZ2dF?=
 =?utf-8?Q?AhZgfHSwwYlnG6fx8efIsCNwj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7517142-3952-4c5c-8d37-08ddaf84473d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3322.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 22:54:42.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXnKeiWCF6IqCVxxn2tpTS/IYvts311BC0/AtELs02RQW+l+nXpN0D01ANkeFWw3mCI3RwiLxydaiMSohOwSAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9327
X-OriginatorOrg: intel.com

Hi Sean,

Thank you for helping shape this series. Please see the request below.

On 6/12/2025 2:48 PM, Sohil Mehta wrote:
> When using the send_IPI_* APIC calls, callers typically use NMI vector
> 0x2 to trigger NMIs. The APIC APIs convert the NMI vector to the NMI
> delivery mode, which is eventually used to program the APIC.
> 
> Before FRED, the hardware would ignore the vector used with NMI delivery
> mode. However, with NMI-source reporting, the vector information is
> relayed to the destination CPU, which sets the corresponding bit in the
> NMI-source bitmap. Unfortunately, the kernel now needs to maintain a new
> set of NMI vectors and differentiate them from the IDT vectors.
> 
> Instead of creating a parallel set of send_NMI_* APIs to handle
> NMI-source vectors, enhance the existing send_IPI_* APIs with a new
> encoding scheme to handle the NMI delivery mode along with the
> NMI-source vector.
> 
> NMI-source vectors would be encoded as:
>     APIC_DM_NMI (0x400) | NMI_SOURCE_VECTOR (0x1-0xF)
> 
> Also, introduce a helper to prepare the ICR value with the encoded
> delivery mode and vector. Update the guest paravirtual APIC code to use
> the new helper as well.
> 
> While at it, rename APIC_DM_FIXED_MASK to the more appropriate
> APIC_DM_MASK.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>

The changes in patches 7 and 8 are based on suggestions you made almost
a year back. https://lore.kernel.org/lkml/Zr9X-08zsOKFlvkB@google.com/

I am wondering if the implementation seems appropriate? Also, there is a
minor KVM change in this patch. Eventually, I am hoping to convert the
suggested-bys into acked-bys in both the patches.

Thanks!


> Co-developed-by: Xin Li (Intel) <xin@zytor.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
> ---
> v7: No change.
> 
> v6: Remove a redundant else statement. (PeterZ)
> 
> v5: Use a simiplified encoding scheme for NMI-source vectors.
> ---
>  arch/x86/include/asm/apic.h         | 30 +++++++++++++++++++++++++++++
>  arch/x86/include/asm/apicdef.h      |  2 +-
>  arch/x86/kernel/apic/ipi.c          |  4 ++--
>  arch/x86/kernel/apic/local.h        | 24 ++++++++++++-----------
>  arch/x86/kernel/kvm.c               |  9 +--------
>  drivers/thermal/intel/therm_throt.c |  2 +-
>  6 files changed, 48 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> index 23d86c9750b9..32cdd81e5e45 100644
> --- a/arch/x86/include/asm/apic.h
> +++ b/arch/x86/include/asm/apic.h
> @@ -470,6 +470,36 @@ static __always_inline bool apic_id_valid(u32 apic_id)
>  	return apic_id <= apic->max_apic_id;
>  }
>  
> +/*
> + * Prepare the delivery mode and vector for the ICR.
> + *
> + * NMI-source vectors have the NMI delivery mode encoded within them to
> + * differentiate them from the IDT vectors. IDT vector 0x2 (NMI_VECTOR)
> + * is treated as an NMI request but without any NMI-source information.
> + */
> +static inline u16 __prepare_ICR_DM_vector(u16 dm_vector)
> +{
> +	u16 vector = dm_vector & APIC_VECTOR_MASK;
> +	u16 dm = dm_vector & APIC_DM_MASK;
> +
> +	if (dm == APIC_DM_NMI) {
> +		/*
> +		 * Pre-FRED, the actual vector is ignored for NMIs, but
> +		 * zero it if NMI-source reporting is not supported to
> +		 * avoid breakage on misbehaving hardware or hypervisors.
> +		 */
> +		if (!cpu_feature_enabled(X86_FEATURE_NMI_SOURCE))
> +			vector = 0;
> +
> +		return dm | vector;
> +	}
> +
> +	if (vector == NMI_VECTOR)
> +		return APIC_DM_NMI;
> +
> +	return APIC_DM_FIXED | vector;
> +}
> +
>  #else /* CONFIG_X86_LOCAL_APIC */
>  
>  static inline u32 apic_read(u32 reg) { return 0; }
> diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
> index 094106b6a538..3fb8fa73f6aa 100644
> --- a/arch/x86/include/asm/apicdef.h
> +++ b/arch/x86/include/asm/apicdef.h
> @@ -87,8 +87,8 @@
>  #define		APIC_ICR_BUSY		0x01000
>  #define		APIC_DEST_LOGICAL	0x00800
>  #define		APIC_DEST_PHYSICAL	0x00000
> +#define		APIC_DM_MASK		0x00700
>  #define		APIC_DM_FIXED		0x00000
> -#define		APIC_DM_FIXED_MASK	0x00700
>  #define		APIC_DM_LOWEST		0x00100
>  #define		APIC_DM_SMI		0x00200
>  #define		APIC_DM_REMRD		0x00300
> diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
> index 98a57cb4aa86..4e8bc42f3bd5 100644
> --- a/arch/x86/kernel/apic/ipi.c
> +++ b/arch/x86/kernel/apic/ipi.c
> @@ -158,7 +158,7 @@ static void __default_send_IPI_shortcut(unsigned int shortcut, int vector)
>  	 * issues where otherwise the system hangs when the panic CPU tries
>  	 * to stop the others before launching the kdump kernel.
>  	 */
> -	if (unlikely(vector == NMI_VECTOR))
> +	if (unlikely(is_nmi_vector(vector)))
>  		apic_mem_wait_icr_idle_timeout();
>  	else
>  		apic_mem_wait_icr_idle();
> @@ -175,7 +175,7 @@ void __default_send_IPI_dest_field(unsigned int dest_mask, int vector,
>  				   unsigned int dest_mode)
>  {
>  	/* See comment in __default_send_IPI_shortcut() */
> -	if (unlikely(vector == NMI_VECTOR))
> +	if (unlikely(is_nmi_vector(vector)))
>  		apic_mem_wait_icr_idle_timeout();
>  	else
>  		apic_mem_wait_icr_idle();
> diff --git a/arch/x86/kernel/apic/local.h b/arch/x86/kernel/apic/local.h
> index bdcf609eb283..9a54c589a4bf 100644
> --- a/arch/x86/kernel/apic/local.h
> +++ b/arch/x86/kernel/apic/local.h
> @@ -24,22 +24,24 @@ extern u32 x2apic_max_apicid;
>  
>  /* IPI */
>  
> +u16 __prepare_ICR_DM_vector(u16 vector);
> +
>  DECLARE_STATIC_KEY_FALSE(apic_use_ipi_shorthand);
>  
> +/* NMI-source vectors have the delivery mode encoded within them */
> +static inline bool is_nmi_vector(u16 vector)
> +{
> +	if ((vector & APIC_DM_MASK) == APIC_DM_NMI)
> +		return true;
> +	if ((vector & APIC_VECTOR_MASK) == NMI_VECTOR)
> +		return true;
> +	return false;
> +}
> +
>  static inline unsigned int __prepare_ICR(unsigned int shortcut, int vector,
>  					 unsigned int dest)
>  {
> -	unsigned int icr = shortcut | dest;
> -
> -	switch (vector) {
> -	default:
> -		icr |= APIC_DM_FIXED | vector;
> -		break;
> -	case NMI_VECTOR:
> -		icr |= APIC_DM_NMI;
> -		break;
> -	}
> -	return icr;
> +	return shortcut | dest | __prepare_ICR_DM_vector(vector);
>  }
>  
>  void default_init_apic_ldr(void);
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 921c1c783bc1..317d585ff3d0 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -518,14 +518,7 @@ static void __send_ipi_mask(const struct cpumask *mask, int vector)
>  
>  	local_irq_save(flags);
>  
> -	switch (vector) {
> -	default:
> -		icr = APIC_DM_FIXED | vector;
> -		break;
> -	case NMI_VECTOR:
> -		icr = APIC_DM_NMI;
> -		break;
> -	}
> +	icr = __prepare_ICR_DM_vector(vector);
>  
>  	for_each_cpu(cpu, mask) {
>  		apic_id = per_cpu(x86_cpu_to_apicid, cpu);
> diff --git a/drivers/thermal/intel/therm_throt.c b/drivers/thermal/intel/therm_throt.c
> index debc94e2dc16..5c0d2de2986e 100644
> --- a/drivers/thermal/intel/therm_throt.c
> +++ b/drivers/thermal/intel/therm_throt.c
> @@ -740,7 +740,7 @@ void intel_init_thermal(struct cpuinfo_x86 *c)
>  	 * BIOS has programmed on AP based on BSP's info we saved since BIOS
>  	 * is always setting the same value for all threads/cores.
>  	 */
> -	if ((h & APIC_DM_FIXED_MASK) != APIC_DM_FIXED)
> +	if ((h & APIC_DM_MASK) != APIC_DM_FIXED)
>  		apic_write(APIC_LVTTHMR, lvtthmr_init);
>  
>  


