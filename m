Return-Path: <kvm+bounces-51700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5B8AFBC12
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 22:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17E6B17FF22
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 20:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B22217701;
	Mon,  7 Jul 2025 20:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jnRhlM/L"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFF914A82;
	Mon,  7 Jul 2025 20:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751918469; cv=fail; b=qgchQQtBpjxfXty1LhRWEM5cUm6MsFcBW2ESLxDtm1jfms8+faSZm933c35lwsserrldwkwufFXQrGoZrDxzrF3sSEwPJDJDAhYIaoDXdCyoy2XZWUmEwZK+n/eZNiH3F8RTyVEaNux+QpEkXzceAucLVfyL6C1IN4l5t3/zvSE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751918469; c=relaxed/simple;
	bh=+q7Jjy/S/xXxhpIJUIzw5TQDcImPR2KZWTMnxmq2pKo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CGHNTV7u4BcMV0PzOYSw3dWQWZx9KiFSSIYhsat65TSGDLNyNYD3AOQD16+qZi/+gjyWNLUjmlPojFAZxgNe58+SNSurQqaI4v/lw9hf+TMPtGcQDuKUMQ45H/RUDTH3lFNChjv6Rkhc83Tn33rGLZeRqSkymEvMHrDH9vKjXeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jnRhlM/L; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751918468; x=1783454468;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+q7Jjy/S/xXxhpIJUIzw5TQDcImPR2KZWTMnxmq2pKo=;
  b=jnRhlM/L9u2LuoQ99ajKbcpiJUly4Vc1fIByTHEsT76wh1PBbtKWnywi
   yfxLfD7P4qlxIKitRVFhiEUpi9XqDLaCN0RI8hwAy0Ms/o/0Ru3EDMOs7
   2RMC1++61+N8dTrFH8tnW0j37bZRFHhxajRn2a8obbsMQl+1qYUgQwKpr
   1/S8/sHXH3OMwt+c7PhAhI86QGixeWWHSID/m8XDk7hycrcgjrmwOSx+L
   GQGmq9JjQnSGMXU9p9TaHFRCVssJ2ac3aY9ae5saRgasAfXDY0mHaBG2I
   bcYZFRqI80cJDSVeEDFtUKC6mT1nJg8FUJQpqXBOY7oS6cvhT0DRBByIs
   Q==;
X-CSE-ConnectionGUID: M9lDgtcpT/e2arkRq7/pvw==
X-CSE-MsgGUID: q4ROTv2YS26HI5HQD0sG1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54033578"
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="54033578"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 13:01:07 -0700
X-CSE-ConnectionGUID: kiHFP9rMQWS5zJwfTEbehw==
X-CSE-MsgGUID: 1JizBzdeTHSL8t/cmpto4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,295,1744095600"; 
   d="scan'208";a="155789826"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 13:01:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 13:01:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 13:01:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.76) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 13:01:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFCcaZDG33E4VFgzTjOMlh1N8O3KNViQ7TpUP4UI7dafMaoIn766g6bH7HiPYkAV+Tk1Et1j9SoVNw6reAqG8pJxTVsdIZr24f0fO020x80R3JUsYWHjoDrF/WEKCdDeltoJ8Ed7+hpWWPM7knSbZ011b8Fd/3MEmzuZD5BPGafiaC7HUY3lNeuiHXcgf6awJrdayKpRQhn+RcIDh3XrVOjx6knMpgcTOOcQzOXRnM+tOWlrVpk1FahIz6tPEbJDvPv7zgltmpacX5Fos09CwkuecGRRMyhIfTenLYv6ULlRb9w0N5zkRPEGW3Ey7XoPEQ0O7PjX6iuZfOtBSxE68g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=is4LrvRsLgcII0K1POtgS5zMEcAi6obZkTwxy+yVIjc=;
 b=dQhBQ6xvD+mCFdE6j6KnAKUK+Xtwle2YvTMpIUpc9TVPJfvtq8Mn6NN3z/BifBWFHa8MbSnxSXhVcwqQsSjObIeWzUp01S2ySvUPEGCUfqvB5L48THbcEUvutvW3/Xpo9fceZbtDNl2Q5CT9lLlTnt0w86+VezrjUTvNEajnK/Zuyqaf2CoERSgBx/3hCx3VzjGVw5GUAlkpEPoMsgYfLacFRh93WhsDeTUfq0mmV/T/vYYNjxmzfUf7ku4C/PMF4muko+d/eaXaHiDlfjfzOof1pEULyn71/SseTpxWOqc69Onc8z0LffnRgv6ec/Or97E87gWbaRdNcvXx/VIhcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by DM4PR11MB7301.namprd11.prod.outlook.com (2603:10b6:8:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Mon, 7 Jul
 2025 20:01:00 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8901.024; Mon, 7 Jul 2025
 20:01:00 +0000
Message-ID: <9dd8771d-ce4f-4bfb-8fbd-571f3e188514@intel.com>
Date: Mon, 7 Jul 2025 13:00:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/10] x86/nmi: Assign and register NMI-source vectors
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, Kan Liang <kan.liang@linux.intel.com>, "Luck,
 Tony" <tony.luck@intel.com>, "Zhang, Rui" <rui.zhang@intel.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Sandipan Das" <sandipan.das@amd.com>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-6-sohil.mehta@intel.com>
 <CY8PR11MB71349E0943913F8AE944B3EF894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
Content-Language: en-US
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <CY8PR11MB71349E0943913F8AE944B3EF894FA@CY8PR11MB7134.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::24) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|DM4PR11MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a374f8e-fdba-44c8-6426-08ddbd90fecd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b3JHdUJwUXhJOVhjZjBVeHQwclc2QzZKeTI1eG9lcDRMaVpBRDZvZ3BVYkFl?=
 =?utf-8?B?cDE2ODRVVzNsd2FpY2RENUVlc0hibGtLR2tnenNYM1Fsb1FsSTVGT2hyNUo0?=
 =?utf-8?B?c2liS29RWk50djVEZEFqQU4yMkRDM3duUnIzUENDRWh2UUJkNjZBelNYLzNT?=
 =?utf-8?B?MTZlQzhpKzIzekNiOTlVMFExaXFUUkI2aU9NZHQ5eEtBbUJTb2NvNjkzdmhD?=
 =?utf-8?B?R2VxcXREd0NHNDlyZUVoakdVOWRhR2VGdG84VlRMcVpkdCtSQUs1cUgwZ2Nq?=
 =?utf-8?B?UFY1emZjc3BzYWViRGJnUXhDNklHYWJNRVNhRUZOUTR5TDQ0ZzVUczNyTng0?=
 =?utf-8?B?cVVWWEd6OTVkazZRbVdGMG9EQ2J1WVBQc3d5ZVpuUkRWTUk5aU9uMmRydS9M?=
 =?utf-8?B?NThFSzFveEpoYVhNandPWlRpWTFoUDJNNGVJNmxmWi9vQzlPaHhPVFBYemlY?=
 =?utf-8?B?RjJOMUx3Y1ZjcmVMM0FsTzEveXRJVXlpR1A5NDFBRGVEcDhtTkQ5dDJmaDBt?=
 =?utf-8?B?RWZwOUJBOUQwbnozNmZjQzMvWi9TNEVMM2hOYVJ3UHFKdm01R2xXanczZjAr?=
 =?utf-8?B?UjA0UDgxVXp5NVZLOHVNb1ZrdTBTQXovR3B6Wjg1UmhrRlFBdjBQUVlkL1Vm?=
 =?utf-8?B?a3hNU29WU0xZazFhYnJRU0lzTnA3SXJ2ZWdaUGJFTVdUWHBDb0VXTEttbXlR?=
 =?utf-8?B?SEc1RkxYOVBwVXR3SlFiUXd2TDdLNDJUandaVVRCamg0NFZmTkFSdzU0eDdu?=
 =?utf-8?B?cXA2K2QwQzA4eXhrT083U3RDdUVqNlFkdzUzckFaS25GOXNXQ0h6RFh5WmJQ?=
 =?utf-8?B?c2NyN21BSWlOSlBXMW85K0sxVi9pc3c2d1ViMFN0aktqUWJQNnA2cEZGaFpM?=
 =?utf-8?B?RTMyWTFSeEVpZkNLTlEwTzZhL01KMFhNZEhWYzdvMXpZMjFsaTYzZGFBMlMz?=
 =?utf-8?B?Y2xReGZzR2RmZ1pwbGpBNEU0eWcwT2FSenZabHV1QktaM0VIT1ZSd1ZPbHpX?=
 =?utf-8?B?cWdZNW1JUGcxR1J6OFNGU2RZeGVZbDdrV2ZQL25KTURXRnpuZGxRQWNqb0t0?=
 =?utf-8?B?NDNvQkxQRE1jeWkxY2Q0bXhkZVp2blhXTU1mU2VKcXUzS3hmYUdSb3dBVlY4?=
 =?utf-8?B?Mm1GTDkrWDE2K0daSWdWSWQrMVNXRzltakZPdFJQSFF2ZmlLRFFxeUhWeDFM?=
 =?utf-8?B?WDZDZW9HUEZmc0dJR1gwL1NJdXZVYm9mUWJxdXhaUkhMY2o3Q1d0cm5yd2Y0?=
 =?utf-8?B?OVBlbXNZd3c4QmJiYTYwc0pHcVlVRmZhcjhHS29ucFlLRUxZTXR2RGgzMVVH?=
 =?utf-8?B?TEtyN0dveWhDUG5BUUl6U1JNMDc1dWRxT0xuNFZBMmRoVGNoeFlXUTBpQy9E?=
 =?utf-8?B?b0tjQlZ5ZHF5ZTQ0UWJ1VVFEaHpIVjEwcUtoemp1SkRtdWpxZHJ2VDJ6YVVK?=
 =?utf-8?B?OGE2QjlOcXFPbTdOcU5FOUVmR0docFFsZDREQUk1dzBUSnJGL3AzWXc4bUZ4?=
 =?utf-8?B?MGtCZWFDcnVmRE4zR3Z0blc4UDZsL0s0ZTZDdmt5V1ZpYU1QUVZ4bDFYU0o4?=
 =?utf-8?B?QXlBRkdzcU5WWmZqck4rQ3p3MHVkS29IMGlVVHNCVHZRbzRwd0dHeXFNa2hi?=
 =?utf-8?B?cENybGxBY3NvUzJ1SFI1T0lZWURFcEFJdm9CcWd4ampLMDc5QWdlYUlvUnpR?=
 =?utf-8?B?R08xcWhKdmhkUFV1ejRRMWdHS2dUeDRmNkNHK0NOdDhiSCtHWEExWUtLRWtC?=
 =?utf-8?B?SEwvSG9YNUtpV1ZMaXdxckpwWXFnRkhMN2F5THZYdEt1Q3poQWVVR3loR0d4?=
 =?utf-8?B?OVpKSmtJNWxSRHk2YVd0SFBpRXJqeDRPNGxJVFViY2RnYmRBS29JYlFGY3F0?=
 =?utf-8?Q?zo2TW7Wu3r0+J?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1hEcENobkVjQUdSRGZUY0g0TGFadDE4cnlHMjBJZmd1M0h3a1g2VE8ySzNl?=
 =?utf-8?B?QTBURHBZVkl5KzF6V3FVWjFMakg0UGIwaGxzNVJvTzBDc2IvZWhqbHl6Zldx?=
 =?utf-8?B?a0FSeTZYN3B4bHhJbEZ4bG9uK09zV3lKRk5LRkRwblorYjA4b0RtMEkwbCta?=
 =?utf-8?B?anFFRlNYeHBxdllwdlFybytUT2VPWFpVb3J0cVhNTE9LOE9icjB5NVgrME9p?=
 =?utf-8?B?QkdlUTR5TWJTbUdUcFkvVHZuU2J2ckR6QVQ2eE9qNkExM0czZDIwL2d2ZXU1?=
 =?utf-8?B?cG1GWWg1K2tldSticUtuQ1BSZnJ4U1ZVVU1GVUw3dG51NTNSc3pkdW1salJC?=
 =?utf-8?B?V3dzZzBKaXVNL0RaOVJRWW91eDZCT0JJOUNuajc0UzB3bFdRejUzbXVJTmJM?=
 =?utf-8?B?WWY2K1h1d2pOZXR4RmZWSmtLNXpRaHVsZFN5R2tycHgxcVZSbHlpYlpEa3py?=
 =?utf-8?B?dHV5TmpUWUhZUGZQTGJRSzI0NXMrQ0JOV0ovYjdpTWRPVkVscldxRjdzOC94?=
 =?utf-8?B?cHpnNkg3cVplVzZFNlVaczhUSVNwekJCU2VRaE5YVlB4Z3J6dTc5eEhMUGdo?=
 =?utf-8?B?MEREOFgvNWh1WXJCTHZtVTBmaUs0TFNhK1BqS0k1VTZ4c01sMDdwZ2V4Z1E2?=
 =?utf-8?B?dFpTam02dDhpTElFcWVoREg2Snd5Nk5xaFZNNmkvQWkvb3pUMk5iTEV3VmZv?=
 =?utf-8?B?ekVibnJaRnlDWGxMaHB2VDNNdklnUlErRjloZ1o3ZzlzeDhmVWdIamJDYStB?=
 =?utf-8?B?UFpvbHlxbkVoRTZjbHV2azJXQnlUOWxRRk80eDNPWEJtZkZlUFdPNHYrQ0px?=
 =?utf-8?B?eHJxNExhUXUwSWJMck9mbjBlT3lUVDFWclF4TlpxNHRSQlErRUdUTkJWSy9Z?=
 =?utf-8?B?NHU3WXlFdStoUk5lbC9OK0JpYW1FQ0xiNFhWU21zdjNacXp5Umd5dng1UnVa?=
 =?utf-8?B?OTRYZFJRS1QwQnlYVUZ5bzlYMWxVK1ZJaWl4a2VJcVF1T0pFdGNnbEJpaWFi?=
 =?utf-8?B?eXZ6WVBIQXNrN3JBandmeDhpZzY1dThBbEVBVDdmbGQrZ1ltZzFNQVNVSms4?=
 =?utf-8?B?dkRnRW1TZGJvaHZSRjlwQXBiRm1XNzZQVzRTR3ExaDBrcmtjbUhnS1RQS3JY?=
 =?utf-8?B?TC9zL1dFRkR6MkJVanhaVjR4aG0yWkpsWkZCanBzSHV3ZjNsWlRVWkdVOTVi?=
 =?utf-8?B?SzdmWFhDY0dPMUxmeS9haE9DUzBrYkpseDRZZlNKa1JTR1ZYdTErWmhtSlla?=
 =?utf-8?B?NE1nWUFjdjhxK1NzZis0a3lpUUV0NkNyM2tzczdLL0ZKYXBJdllWbTViaGtC?=
 =?utf-8?B?V2RDay9OWFh2aURXOFVDMmhjODZncFQvdlZoWHpDc29DKzFMZFAvYlhOK3Vi?=
 =?utf-8?B?SVJwMi9ScHVmQm15cVlVd2RURlMzcnEwa2xkYnVTbFRBTkV4d0U3eHNJWjJP?=
 =?utf-8?B?dVdveWtjZGRWSXRpUWIvNEltS0ZKUUlnbmkyQktGbkNqRG5ZK2Y5YXZKa1RN?=
 =?utf-8?B?TXFkWmd4S3RROW5qUStkdXRVSnZ4eFlVUmxhWUxzQThqM1haSG1JK2F6QTlQ?=
 =?utf-8?B?VVNmYXBEVzNUaUoyTERnY0x1cWhOc3YxYUJpa2ZUdU02a0FkQjlOMWRTUjZm?=
 =?utf-8?B?aTJ2SjJoTWQxeVZDZHFtZHRVSEQ5ZnBNSVpHblc0aEJ4S1dIQml0M0ppdTE1?=
 =?utf-8?B?UzJXU2tHZ1NYRFRIdXB2cXNDOFhYanFHYVRENTY2SVFXSlp6UmFuTjJ4RGNV?=
 =?utf-8?B?SXRsZ09jcnJTY3B4SGdEVHM2VWVHeUlNSkpsdXc2TU9mYnpJeFNNZ2x4MWpG?=
 =?utf-8?B?clhPNVM5SWdCSERjSk5jZkxRTXdJWkhBc1gzbGFLd2RmSVE3aVhzd1ZReGtO?=
 =?utf-8?B?eGVyc3ZDMDVWUjNFVCs3ZXdWOG5kSnlZYkVHcS9qQ2lkSExVWEd5M0RIcWNN?=
 =?utf-8?B?ZEZGUmJ6dzh6YlBIaitYeFc0dUFHR0trS1QxVVN4UTVGVS9VZFgweXVvaUFM?=
 =?utf-8?B?SG9iWVk1c0tjKzg2YThKdjBPdVhabUVUNzdXMEZFdDkvaEdYNmlzSmFQYnNR?=
 =?utf-8?B?TlhDWDlMZkh1S21IMTg4SmtYVFIzaVdjZHlrVzN4bEUzLzByZi9QQWNwQTZV?=
 =?utf-8?Q?P9krttAK0NTMhsKj/HnEl6aao?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a374f8e-fdba-44c8-6426-08ddbd90fecd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 20:01:00.5792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6KNAqt2Dzw/DgUzIoV9NdQGYW6pVMTGS4SLM+ecqVeMKqpVDGGppk0QNQ+8S0Z6mg1CJ79hsd3fQ8z7olaxOMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7301
X-OriginatorOrg: intel.com

On 7/7/2025 6:21 AM, Zhuo, Qiuxu wrote:
>> From: Sohil Mehta <sohil.mehta@intel.com>
>> [...]
>> Vector 2 is reserved for external NMIs corresponding to the Local APIC -
>> LINT1 pin. Some third-party chipsets may send NMI messages with a fixed
>> vector value of 2. Using vector 2 for something else would lead to confusion
>> about the exact source. Do not assign it to any handler.
>>
>> NMI-source vectors are only assigned for NMI_LOCAL type handlers.
>> Platform NMI handlers have a single handler registered per type. They don't
> 
> From the current NMI code point of view [1] or [2],
> a type of platform NMI handler may have multiple handlers registered. 
> 
> [1] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/nmi.c#n199
> [2] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/kernel/nmi.c#n201
> 

We have warnings that should flag any time multiple handlers are
registered for SERR or IO_CHK:

	/*
	 * Indicate if there are multiple registrations on the
	 * internal NMI handler call chains (SERR and IO_CHECK).
	 */
	WARN_ON_ONCE(type == NMI_SERR && !list_empty(&desc->head));
	WARN_ON_ONCE(type == NMI_IO_CHECK && !list_empty(&desc->head));

>> need additional source information to differentiate among them.
>>
>> [...]


