Return-Path: <kvm+bounces-49962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C95AE0324
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 13:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B34C31BC19D8
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 11:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D68E1226865;
	Thu, 19 Jun 2025 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gk5dLkNk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41790221FBA;
	Thu, 19 Jun 2025 11:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750331585; cv=fail; b=mSnCHdOatTVXx96YNtN7sEYiRH3g8WGuNeNgfHkpX3/r1GQXEH6gjpJrRilQq+/fhJc/rIiSOskGiUqWa4A9dOPqdmgmB1c8t1YTBSZ7j7gKEUDBeCDzS73onfrDhtcoNRfzMN0U6OR0eIOWFmk4wAN2GSehGUA0g+73Ta246Ic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750331585; c=relaxed/simple;
	bh=GFZqmpEPvmS0FaLXMKu3zIu7Scjnc50DmgVksUPJw4U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U6Z65vuvRfPeUDa4veQjoqrGnJDc1ljz1MQ5z5FdmzoBq8CHH95PXi5O2NbwWRxMFwnRHJuZzTcEvCiPlNX/tdNqJU/HeMk5An5+PHYWrGzyiwQqehMVRVd7cucknmbKZ07P4Tl+BoO9pisaIHVDeVm44G2K/OA9QRcx2AN3pJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gk5dLkNk; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750331583; x=1781867583;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GFZqmpEPvmS0FaLXMKu3zIu7Scjnc50DmgVksUPJw4U=;
  b=Gk5dLkNk0ahm7WUvx9TvQ2FXHA3ccccpcGeJRQJuCJVfVTTf+a+0wDD+
   N29EzlhDwrmhnoNGhHJZwTcYVapH9Yy0kYpXtOkhtztkabuiwBOSxhkN3
   2briA/Jc79L8A7dUZoJsvsJmPy4TDcaO0wiRsXIjRFRZJ1wD2Ols2SGn9
   xnwPmrHRhNa8szphbggRRPvaW1+NWl4b55e+pw3QCNsNEDxfKYAxc9AMR
   WAMbKdd+zQtBAJFJzN0oSSyLtpmzDkH4zAV381Vhf/lJcjesDLOKljPQi
   HWnDoLfb5kSQq+3WhsZ5DWp+tVGTTL+oVfJHTikNupS9KZJx3HhnQ/+Cs
   w==;
X-CSE-ConnectionGUID: 3sQ/wUspRYKfUwvg03Gr2A==
X-CSE-MsgGUID: 5D0eo5v8T4yPBcCjOPfc9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="52447289"
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="52447289"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 04:13:02 -0700
X-CSE-ConnectionGUID: a5M1YhsTSHK/Lt1xk184Ow==
X-CSE-MsgGUID: 5v0Uv0q1RUe0G/RdP+15mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="151131905"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 04:13:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 04:13:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 04:13:01 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.67)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 04:13:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WbaJAjwgILMzE2K983E7aJHOFZoD64DcpGPcKLJdqGXaNbnzq3bGgpMANp1xL395jUnmigTtSpOIa05cQxycppsYSW7tnewN997/21G1ctlawLfVJpOtzAXE2zCzpTkYXrTWZUcvMraP+D5DRgaqsNCuw9op/ap0HIaBKPei2T0V6CyXc8WtHacFuIzDV/mCJqdCrcsj0IE1Yls2NR37vu3R5EPc7iyjvte+DXf+SkQJLKzYxwoPb1fR241WxPdkdQ9dtFScSCfFDUnvt6qV9iERN4KuDGNEA5Hb1CJ+cKY3K5rFW0a0RMDBdK48TlDVCEw7JQcs2Y8L4NKdtO41/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d2XzVSHQr5gcOEo2x7ZGCbbKO8GLpK8kQ5q49XNpXH4=;
 b=kiVqz8oMcY6Q7Wrud9I23X20McDRDRdRroQ77QZHcBN9s5WJIh+ir/MFCroknTTh/BjlveF2XMDj7VK+MAH/EvwlbXh1nBaQbKydequAEuM9oU3poY7vaV0kisVr5pruuNMg3jiNzxMuWTU9con4Ndo7JHQdHxdAejR/4lMJptgKpn24erhpgZEA2qBS52V8neW5txVUkDc+cm/14sERMk4zGNldFhMzhG7mPE3NvhYJ+3umo2+bO2FMAEsWkYc28C58a+Tw6VqrHP9bZb2q7B1ItmbjTgMhu8OV2dSXPkU7Og+r6K3j3Nf7m38P37qLtEv+TGyTSWRDsr4BfPMA3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3206.namprd11.prod.outlook.com (2603:10b6:a03:78::27)
 by SA3PR11MB7977.namprd11.prod.outlook.com (2603:10b6:806:2f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Thu, 19 Jun
 2025 11:12:45 +0000
Received: from BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d]) by BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d%4]) with mapi id 15.20.8857.019; Thu, 19 Jun 2025
 11:12:45 +0000
Message-ID: <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com>
Date: Thu, 19 Jun 2025 14:12:37 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Sean Christopherson <seanjc@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kirill.shutemov@linux.intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com>
 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com>
 <aFNa7L74tjztduT-@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aFNa7L74tjztduT-@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU2PR04CA0232.eurprd04.prod.outlook.com
 (2603:10a6:10:2b1::27) To BYAPR11MB3206.namprd11.prod.outlook.com
 (2603:10b6:a03:78::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3206:EE_|SA3PR11MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 63741eaa-4dac-4eea-fd52-08ddaf223758
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aE4yYm01UHBzUXBBeFd3ZFlBb3lMSld2aUJidWJraUEwUEdRS2I1WENTMUhX?=
 =?utf-8?B?N0tCUkJVOCtBK25STm1Rd3QvbVNtclRSL1Nub010d09ZemZ3eTlaYjhPcDM2?=
 =?utf-8?B?WUx6MnkyRVBBNE1Zb2xsekVueFF5Zml4QVFjR3p5NjRKN0Fjck9LeHF4M0J4?=
 =?utf-8?B?bVFoNk43ai9VNEVGUm5LMTcvRjFjKzViWHNyemZOa1gzd0NWMlUrSWs2Rm5E?=
 =?utf-8?B?cXFYQWhENWRqQmVKeXQ3QUM5azkydkpuanpFY1ArdUpLWUxzc0JuL1pmUWpP?=
 =?utf-8?B?WFZpaElYY1cxTHhkWTFmUUw3U0krMGZ3N05HLzgrcm9IUDhBZUkwdGREWlY5?=
 =?utf-8?B?S1QvUVVCcVpINjlrRnhMVWNIMUkxdzhJOEhTU3lZWEF4MFgzRVI0bGRlMUE5?=
 =?utf-8?B?V3NoNFpmL3dPMWVUb0ptZGxUQVJ4aFgvMW5BcUhsc0Uxb2huNEdIYS9qWmtu?=
 =?utf-8?B?R1EveVNSTmdVM3RYc2VpUVREZ3djUHNOY2tIZS9PL0d2azhZVVRMMldxVW5o?=
 =?utf-8?B?WVJ4N09PODBMczFQU1RCb2ZiR2h2b0FBem5ENXFuTGNJREI4djMvbGZ6aGZr?=
 =?utf-8?B?YUlSTkR4a0JvamxuYW4rUkRWaGFOMFArWmw1YUtQYkkyNE9WMDVCVFB4eXBP?=
 =?utf-8?B?ZVZObjZnckNIdWtmOHliT0RTenZUZ0M2ZTMveFRLRUtlVVRrQzgvTTNxQmNl?=
 =?utf-8?B?RmtueVFuNW8rVUpoUDJ4QmlPOURFS1N0TVFSNWtxNlVWMmFtVm1hWmdrQzBQ?=
 =?utf-8?B?RUFOeDVkc09FcENEeU9zaEtlUm1iVHR6Zi9EclZRd1V4MFBDQzM4SDRrQ293?=
 =?utf-8?B?a0dUSlV6TVdzRm9kTy9lWmQyQ0RxMFVGOTQwSDFsK1ZnSEVTc04yYmxxZkNi?=
 =?utf-8?B?YkZtbnhxVkhKaVJZdDFXNG5ESlluNlZZcndDTHN1REdPUjEvUHJ1dXRPZCth?=
 =?utf-8?B?akg1aWJCSVZwNWF6b21EdmtYRVhzaFdiK3craFhSK2VmUzhLL1BpVnhXVXFm?=
 =?utf-8?B?SjNCK2JEek4reFpqQ1o3emRiang0Z0phNkxRbzQxTlNHYUJZYjY2ZHJVbmxW?=
 =?utf-8?B?bVVYNEVQam1XY3VuVDBLcHRlcjhEUFY1c2RKWUR3cm1Od2cyV1YwWDNpcy85?=
 =?utf-8?B?K2NRSnkzSlhHUFZUaGhvMWgrMnJ6cFAzSEtncjVmbThrZGpBd3kvb0MzaGk2?=
 =?utf-8?B?ajY2TlM0ODFTZXBTdzZ4VzYxNVhaM0ZNbmh6MXpUMk5pYmczK2gyK3RjT3Vv?=
 =?utf-8?B?MXpKUGVzK0tzM011NVBjaW5NOThGOEcwOW9WekYvcVVMVnVxb0t6bjdqS1lF?=
 =?utf-8?B?WUZTQmJwZFRnS3gzRGN3dmttQ29MRUxhV052Yng5QTFZdHowYUk4M0lldlRq?=
 =?utf-8?B?a3NRNWZHNkhObyt6M1V0TUM1WmZFaEt5a1FETHliRDZPQm9kdDh5dzhLRXp5?=
 =?utf-8?B?TkwrdEE3cVJFMnJNT0krOFZDWldXeWtRalJCaStpUmc1WmZQRlNkTmswN3pI?=
 =?utf-8?B?bjkxZ2lOajdpWG9wbEtnKzdobUozKzFaZk4wWmxZSkhVSkt2aUJVYllEd0JU?=
 =?utf-8?B?U1M1MC83YWpUak0vdlNwUE9PSzB1ZGkxV3c4U3cvdEs3clJidi9EcVpUUkdr?=
 =?utf-8?B?RmtMZElHYXIvUVdSTTB3Y1p4UEpNMzR3dUZCTWk1a3ZLMStBOUhlelQ3dGQy?=
 =?utf-8?B?bVc2NVk4Q1pRc0lRK2NFdlpHVGRvWEEvWXFBK1RFYStKcXhIekliZmdhKzh2?=
 =?utf-8?B?bUpNU1ZpSnByU1YxUmc0UHRxeFpxakgzdlU1Y2xSYkVZa2ZMRHlML2JOd0ZS?=
 =?utf-8?B?YUpOdzRBVXozdkVabFM1UjRTZkozdGVOWDJCZElTVGtFYkUzUlNERWZqdVFm?=
 =?utf-8?B?NFNmRlB1QnNRZ0hwQWd0MURmVEQzQTNCMldreDlNM0lROGRlejBBd2xBVEF5?=
 =?utf-8?Q?cXWgKee+0D4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3206.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWU2YzB0d0tWNVdQOTdaUUNkd1FnYUtCVUNyRlJoRU1LR042cHNFbC9oRHZE?=
 =?utf-8?B?WUdXa1kyVWlWWXB5MU5RVnloUU5OT1daS0hQLzJhTWNQK0RZcDJRSGlNSDIz?=
 =?utf-8?B?TllzNW1Yb2o2K0ZuNmtGekFoYVJXS3Z1MXFlOU16cXF6R1lrL0h0UnlJbGxG?=
 =?utf-8?B?Zm1abnhVL1kvOHJ2aWdrVXpVM0Z5N1BtL3lQZEFJcjNycEhLUGgrRGM1ZTJu?=
 =?utf-8?B?Ym0rNG0rREc3dFR3bzdsK1VqdDM2M1VLK0xuMHNrTEdiZEl5VE52cGN4bm92?=
 =?utf-8?B?OHhBS2g5VG9MWXcrRmVaK0V2RlVreEphbFhVOW5kaHU3ZER4anpNM2dpQVhm?=
 =?utf-8?B?L0xhK3Q5Zm81M2FvSjhrdk9MWWpMYjRnekx2NDhRNzN4cUxJZDNHbGdWak5t?=
 =?utf-8?B?dC9NT0RCNER3eVRON3RFSGlrV1phbGFHYlVUd1ZaYTAzYTR0M1RhRElKY2VU?=
 =?utf-8?B?aGkwbFRUdXhYVm8zdkRNQjVMbExxWjFjbU5GdEdFL01CZW5rekhaTlpDWDE4?=
 =?utf-8?B?em10ZnNBbkd3cEFPRld6aHNEYkxUTS9UQzE3UjN2SEl6NC9HQnlwMkRhTEtx?=
 =?utf-8?B?WUFZbEVMVWdFam1LVXRoYXo0SVVaUStBeFZLNlEzLzdka2RTQjZBL29SeXpl?=
 =?utf-8?B?V3dwWXBmYWdtUyt3VWoreWMzeXlYdUJPS2ZaVVhFVHV0SVgyb3BXU1Y1dnlZ?=
 =?utf-8?B?Kys5WXdzM2hPZFN0Y3B6WnluUk9rRXcrT2FQbEVWbnRPMnVxZERUZFlIL205?=
 =?utf-8?B?ei9NNjE3UnN4U29uRW9Xb25xTUVyTnB3UkIwWVBPVnkwREtNb0xaUGNJQWpo?=
 =?utf-8?B?NldTME5KV09lbkZBZW51dkdWbHh5UmNIb0JVTW1lbXhYYXNseDRkWXNxWkI2?=
 =?utf-8?B?ckw3WVFvQWdmMEZ2MzAxWHhhU0FBeHN2a096Y2pzWm91WktuT2t6dzBXODVn?=
 =?utf-8?B?eXY4UlBkS25MT2RGUUxaN0JXZ3FYTG1TeUJqT1BVZkJKRWIvL1AzeFFuZ2NR?=
 =?utf-8?B?NldabmV1UmxTNVp5OWRxazJUaGVueWNRODh6RElHaHhaRlRHbnpvd1NQRzI4?=
 =?utf-8?B?eTN4OC9YQlNtUnV6Y1VKejFRRWNOVnUzcFc4M1JnemJwbDFsSXBENzlwL08y?=
 =?utf-8?B?UWptbGlIQVNQY3dpRnZEM0RjUE5qd1k0YWt0M1FVV1JYaGw0VEltTEVQRjhk?=
 =?utf-8?B?M2RYMEtJR0lWZzcxTlZNWXV3S3BuUzBoOTdrcXZQaHRRTzVGcjVhVHp1d1ZL?=
 =?utf-8?B?b0plZE13ZG81bE0yOUpvdHBGRTBRT2w2OFM5Q3VQS2g4aStWSkFWWGNvaVlZ?=
 =?utf-8?B?U1dmcVIwVWEwczMxV2dLSjE1WGdySVkweUtKaGlEbnlBeGwyM09RQllYdUJP?=
 =?utf-8?B?RklJQnZDRkpGRjM1YlZUTEFrSnN5QS90WFJVZ25rVWVEbUVnemFTb0xXc3p1?=
 =?utf-8?B?MnBGbHNMdGU3KzAwcWpKYkxMblZ5RCt0L2xzbzZPaWtMdngrbVZCaUsvNGl4?=
 =?utf-8?B?UnZ5SFVZeEVER3BNbEVrMXFPSFBHRkFtMVRLN1VESUt4dFJvS0lrc2c4NytW?=
 =?utf-8?B?K05PdzVUMnVPc3hNcU01YTJlSHIzRmVyd1hqUUFmU0VVSUNpRWVLa3g3VElh?=
 =?utf-8?B?UFBaN2ZEWjZxb1drMHg2VW5mYWdTb3FadFBmN2RhVnExRE9BNk9zVFFTUzlw?=
 =?utf-8?B?Uk9UUmRPSmZETm8vdUtyZ3NDRWZUS3U4L09VTnhuQXprTmpTVTN1akxjb2J6?=
 =?utf-8?B?a3hUQ1NvSXBCY0Zma3dEbmsyT3hQb3lLTEwrR2NEemo3dVZnQ1lDRE5Ycnpa?=
 =?utf-8?B?d0t3YkdvY0w1RktrQUVKdVlkZjUyQk5EWVZpS3BhRjRjcFpLSGFydHE1OEZS?=
 =?utf-8?B?aVB4a3V2eEhwWDE1WllNTCtjMWFTM1ovS0F2N2gyLzRSR2NGRktvNUtCTWQv?=
 =?utf-8?B?Z0VjRkhjZ3dvdkYyWjk4WHpkZ1RlOTE1RUQwbGh0aGNDTDR1ZG9YUkIwL04r?=
 =?utf-8?B?ZGVyQmpjY3NXTytNQ0xmbHAxdGFpMWtnTmZ4RXNZcFlHSzBUL0c1WVYxOFBS?=
 =?utf-8?B?eW1rR0VhdWJmbFY1NFcvMzNuTVdJd0trTzhIdVpIWE9TR1lUdDFWUHRURkFT?=
 =?utf-8?B?dWxKVFNtN0Z3dyt2T3dUUXU5TGZRdk5mRkRNUTVnTUFRZ0tuNS9tYVBZN2xI?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 63741eaa-4dac-4eea-fd52-08ddaf223758
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3206.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 11:12:45.1841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfvoZbWBZJmjaRrpJ7W0uT3/ywqBJhFJFNgIwMmEbIXUuei3O801QlYAYXJuabGYtR6S0CChJmpnPwB4p4fXFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7977
X-OriginatorOrg: intel.com

On 19/06/2025 03:33, Sean Christopherson wrote:
> On Wed, Jun 18, 2025, Adrian Hunter wrote:
>> On 18/06/2025 09:00, Vishal Annapurve wrote:
>>> On Tue, Jun 17, 2025 at 10:50 PM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>>>> Ability to clean up memslots from userspace without closing
>>>>> VM/guest_memfd handles is useful to keep reusing the same guest_memfds
>>>>> for the next boot iteration of the VM in case of reboot.
>>>>
>>>> TD lifecycle does not include reboot.  In other words, reboot is
>>>> done by shutting down the TD and then starting again with a new TD.
>>>>
>>>> AFAIK it is not currently possible to shut down without closing
>>>> guest_memfds since the guest_memfd holds a reference (users_count)
>>>> to struct kvm, and destruction begins when users_count hits zero.
>>>>
>>>
>>> gmem link support[1] allows associating existing guest_memfds with new
>>> VM instances.
>>>
>>> Breakdown of the userspace VMM flow:
>>> 1) Create a new VM instance before closing guest_memfd files.
>>> 2) Link existing guest_memfd files with the new VM instance. -> This
>>> creates new set of files backed by the same inode but associated with
>>> the new VM instance.
>>
>> So what about:
>>
>> 2.5) Call KVM_TDX_TERMINATE_VM IOCTL
>>
>> Memory reclaimed after KVM_TDX_TERMINATE_VM will be done efficiently,
>> so avoid causing it to be reclaimed earlier.
> 
> The problem is that setting kvm->vm_dead will prevent (3) from succeeding.  If
> kvm->vm_dead is set, KVM will reject all vCPU, VM, and device (not /dev/kvm the
> device, but rather devices bound to the VM) ioctls.

(3) is "Close the older guest memfd handles -> results in older VM instance cleanup."

close() is not an IOCTL, so I do not understand.

> 
> I intended that behavior, e.g. to guard against userspace blowing up KVM because
> the hkid was released, I just didn't consider the memslots angle.

The patch was tested with QEMU which AFAICT does not touch  memslots when
shutting down.  Is there a reason to?

Obviously memslots still need to be freed which is done by kvm_destroy_vm().

> 
> The other thing I didn't consider at the time, is that vm_dead doesn't fully
> protect against ioctls that are already in flight.  E.g. see commit
> 17c80d19df6f ("KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation
> is in-flight").  Though without a failure/splat of some kind, it's impossible to
> to know if this is actually a problem.  I.e. I don't think we should *entirely*
> scrap blocking ioctls just because it *might* not be perfect (we can always make
> KVM better).
> 
> I can think of a few options:
> 
>  1. Skip the vm_dead check if userspace is deleting a memslot.
>  2. Provide a way for userspace to delete all memslots, and have that bypass
>     vm_dead.
>  3. Delete all memslots on  KVM_TDX_TERMINATE_VM.
>  4. Remove vm_dead and instead reject ioctls based on vm_bugged, and simply rely
>     on KVM_REQ_VM_DEAD to prevent running the guest.  I.e. tweak kvm_vm_dead()
>     to be that it only prevents running the VM, and have kvm_vm_bugged() be the
>     "something is badly broken, try to limit the damage".
> 
> I'm heavily leaning toward #4.  #1 is doable, but painful.  #2 is basically #1,
> but with new uAPI.  #3 is all kinds of gross, e.g. userspace might want to simply
> kill the VM and move on.  KVM would still block ioctls, but only if a bug was
> detected.  And the few use cases where KVM just wants to prevent entering the
> guest won't prevent gracefully tearing down the VM.
> 
> Hah!  And there's actually a TDX bug fix here, because "checking" for KVM_REQ_VM_DEAD
> in kvm_tdp_map_page() and tdx_handle_ept_violation() will *clear* the request,
> which isn't what we want, e.g. a vCPU could actually re-enter the guest at that
> point.
> 
> This is what I'm thinking.  If I don't hate it come Friday (or Monday), I'll turn
> this patch into a mini-series and post v5.
> 
> Adrian, does that work for you?

Might need some more checks - I will have to look more closely.

> 
> ---
>  arch/arm64/kvm/arm.c            |  2 +-
>  arch/arm64/kvm/vgic/vgic-init.c |  2 +-
>  arch/x86/kvm/x86.c              |  2 +-
>  include/linux/kvm_host.h        |  2 --
>  virt/kvm/kvm_main.c             | 10 +++++-----
>  5 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index de2b4e9c9f9f..18bd80388b59 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1017,7 +1017,7 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
>  static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>  {
>  	if (kvm_request_pending(vcpu)) {
> -		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
>  			return -EIO;
>  
>  		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index eb1205654ac8..c2033bae73b2 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -612,7 +612,7 @@ int kvm_vgic_map_resources(struct kvm *kvm)
>  	mutex_unlock(&kvm->arch.config_lock);
>  out_slots:
>  	if (ret)
> -		kvm_vm_dead(kvm);
> +		kvm_vm_bugged(kvm);
>  
>  	mutex_unlock(&kvm->slots_lock);
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b58a74c1722d..37f835d77b65 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10783,7 +10783,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  	bool req_immediate_exit = false;
>  
>  	if (kvm_request_pending(vcpu)) {
> -		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
> +		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
>  			r = -EIO;
>  			goto out;
>  		}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 3bde4fb5c6aa..56898e4ab524 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -853,7 +853,6 @@ struct kvm {
>  	u32 dirty_ring_size;
>  	bool dirty_ring_with_bitmap;
>  	bool vm_bugged;
> -	bool vm_dead;
>  
>  #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
>  	struct notifier_block pm_notifier;
> @@ -893,7 +892,6 @@ struct kvm {
>  
>  static inline void kvm_vm_dead(struct kvm *kvm)
>  {
> -	kvm->vm_dead = true;
>  	kvm_make_all_cpus_request(kvm, KVM_REQ_VM_DEAD);
>  }
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eec82775c5bf..4220579a9a74 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4403,7 +4403,7 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  	struct kvm_fpu *fpu = NULL;
>  	struct kvm_sregs *kvm_sregs = NULL;
>  
> -	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>  		return -EIO;
>  
>  	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
> @@ -4646,7 +4646,7 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
>  	void __user *argp = compat_ptr(arg);
>  	int r;
>  
> -	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_dead)
> +	if (vcpu->kvm->mm != current->mm || vcpu->kvm->vm_bugged)
>  		return -EIO;
>  
>  	switch (ioctl) {
> @@ -4712,7 +4712,7 @@ static long kvm_device_ioctl(struct file *filp, unsigned int ioctl,
>  {
>  	struct kvm_device *dev = filp->private_data;
>  
> -	if (dev->kvm->mm != current->mm || dev->kvm->vm_dead)
> +	if (dev->kvm->mm != current->mm || dev->kvm->vm_bugged)
>  		return -EIO;
>  
>  	switch (ioctl) {
> @@ -5131,7 +5131,7 @@ static long kvm_vm_ioctl(struct file *filp,
>  	void __user *argp = (void __user *)arg;
>  	int r;
>  
> -	if (kvm->mm != current->mm || kvm->vm_dead)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>  		return -EIO;
>  	switch (ioctl) {
>  	case KVM_CREATE_VCPU:
> @@ -5395,7 +5395,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>  	struct kvm *kvm = filp->private_data;
>  	int r;
>  
> -	if (kvm->mm != current->mm || kvm->vm_dead)
> +	if (kvm->mm != current->mm || kvm->vm_bugged)
>  		return -EIO;
>  
>  	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
> 
> base-commit: 8046d29dde17002523f94d3e6e0ebe486ce52166
> --


