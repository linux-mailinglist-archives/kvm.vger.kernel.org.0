Return-Path: <kvm+bounces-49442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5458BAD911F
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 282D93BB82D
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4521C1F237D;
	Fri, 13 Jun 2025 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T1PfiWCw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B987E2E11C1;
	Fri, 13 Jun 2025 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749828119; cv=fail; b=MnzNOsUsMFh9T3UrIywOrKubacUG935w5iEgXf7yoAzJNXZKREyMUmThjnqW33/fwovr3SPZ98SHFjUBHOW3Uqlsy0RWOMKLzNgprZmV3EG8sdyBsO5ha9R2AKBO8avxh+CFGUMH8UpiU1ZvekWeeffQDR6rRubZk8eXOE9uPlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749828119; c=relaxed/simple;
	bh=nYMo9jaDRkWcf3Y1gedvkAEF2tJTz4ANBNT4+S816kU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BEU74pVD4dyTL1Il5qDX225YT/1ARZq4vHqh9CdNSSzi1COvJs7421qVxAqaXP8Dlg0H4WhZZyVNpge5+EnEUhXlZIA8N5UDlYVpKIAhO594lm9DHxbIrE5x9dWkr8WWWXg8ddL1EA7B2CxV1b/balQPtg2RY0WwNKXtnmoJjxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T1PfiWCw; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749828118; x=1781364118;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nYMo9jaDRkWcf3Y1gedvkAEF2tJTz4ANBNT4+S816kU=;
  b=T1PfiWCwiY2mPWky7Os0TvxvsZFrLMLPE6F+bW8K80a46rnlLJiq8ys/
   eM0jvk9VXUJbWIk8ElNIAVBAE5b8gIDNYe3jY0bHnr3DPoSO50dbKIVPT
   lkqR5OlYdHiDBANwozMQlhdpd+PbCZudDaACo7xyT13ngIYY2613J/ffU
   CsLxrUxdDQr7tUBVDZH5HvTsOXUk9G/6DWg8Aq73NgYEwXDTPPVVfcqV2
   uRsmN1ZtajxkZMudkr8WpLUowucMMJd4Xkaz6gqwGC7gEFtjTmVISEnT7
   slQ4QZ7kWZYKAY5+dgZUtAk/kV++RqxWAg7JFLADIVu6KYQKCKm6Y5g9m
   A==;
X-CSE-ConnectionGUID: Q4FJLvhKQhewof7XBlzYXg==
X-CSE-MsgGUID: I7l0eT/8R7GfA6ZSary3bw==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51273659"
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="51273659"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 08:21:56 -0700
X-CSE-ConnectionGUID: jzTH7XtcSY6/0OrWbDeX5w==
X-CSE-MsgGUID: 4FdriJZ8TnuugrQYzhE5HA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="151668677"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 08:21:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 08:21:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 08:21:03 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 08:21:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apjIrHpHFVkzz3OCvpVb1cSpwjpt1HlQJG7BbWK+LRbA/E5dRTBLIgozJjWUcMGX2LayhJxDmTptzwmXaZ4vdonM4YHP1AGiCdW3E8r8V/W3vhY6Y1rEDF6ZkK106rZKbcKvtFtWmg8RGR0MGCP8iBsPsP4xW+2yIZB2IfpM0wv5MqKRJ4czZlIqdBxY7rO2SJyAFvRy9zy/GMoRD1bwrMlkNpRMi8wERIcu4fORONLDC2rKcCl2+xn+EuqI6Dz5psmUCyG+6/jNf6Unxn/BHdqU2Y6xJH08wPHjpcSEQq29aUhWjEqNyukVMImxIk9crLFoflkBi9IX2FUkXR8zWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKvB1CWmlhoQnH0Yr8NC8Ok7X3VliveSdjaYfZfnblI=;
 b=x/QBLsWqidxUq2HsYWHlNwdjywXvAALo3iFizuDFFaKx8z67FpNpETmQNbzxE+t5PAEPm0ehlSF3GyguK067BhuZzC66LH3BIkK3M+Yc6OIALbyCDznGN3vnnqLrWRw8Jpnc/LCiORsWRZq/43Gwm7EvONQJ9MxIkz/M00GUD6AzSINhBbmZXkuPBobVZSBIWUVCZUk762U4LWgtInlIDw09ONNOXI2W6fOQVP3SBxWoQWSQSekJ67lFldBxuTXmbgp9mjrt8TzYnx65m/oef6j7nqbIwaPpS7CXBgMJ+GsbRT5hT8xl8QkLzRHsVXpNgXbtvOwq3RHGtUui7gxjbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by LV3PR11MB8532.namprd11.prod.outlook.com (2603:10b6:408:1ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 15:20:34 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 15:20:34 +0000
Message-ID: <a74a3da8-e030-4e6a-b3d8-b13d5f10e4e4@intel.com>
Date: Fri, 13 Jun 2025 08:20:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 02/10] x86/fred: Pass event data to the NMI entry point
 from KVM
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Adrian Hunter <adrian.hunter@intel.com>,
	"Kan Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	Zhang Rui <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew
 Cooper <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-3-sohil.mehta@intel.com>
 <aEtuTrybjLKiNctB@google.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aEtuTrybjLKiNctB@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0065.namprd11.prod.outlook.com
 (2603:10b6:a03:80::42) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|LV3PR11MB8532:EE_
X-MS-Office365-Filtering-Correlation-Id: 324ab9c5-4252-4aed-1a68-08ddaa8dd778
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RHpHK2owMitnUi9SbS9GTUR1N24yS3hMejg3TDF5R08yazBiWkE5Nm9xRS8w?=
 =?utf-8?B?K0NMMDJNTDhNbEE2QXV4MU9vc1JSeUNnQ3dGSDBCSnRURXN2bmIwbW95clhG?=
 =?utf-8?B?QlFTZGttREZ4ZzJqMmJNUFU4VE9RV3ZIMzRlQTMwUHVYYlpyNHdMUWpjMzA5?=
 =?utf-8?B?alBsTm5QMnViMmZJZjRjNXhhZmxQMy9QMTczeXE1Z3dUQkkwK0RBNjY5YUxz?=
 =?utf-8?B?SGNmeTk4ZHFibTMxb2VmYWdnczVDcU5TU0l1TTNNQWFPTkI5UEw0RUtNbXhR?=
 =?utf-8?B?SkdWVTNqSUdud0paL0svSkFkOXpSTTFGaHhXK3c0YWFnaEt4cWl5Q01DbzNu?=
 =?utf-8?B?NEwrcjJEQkQ1OWZwNzI5M3h5UmtqMmZhY2o1ZjE5Z3g3N0FyQ0lNOWxPaUlH?=
 =?utf-8?B?eitjMmRnMEQ2a1h5bEY0cndCNUJTMzVrdHA0RDN6d3hqSVFsTFA0amlXcWRi?=
 =?utf-8?B?VmxaVEppWkFEc2VpVDlTU3BXNXNTaGxIRS9RS0hOOUIvSkhka3lmaHZxMWsx?=
 =?utf-8?B?YjJhZUpRckg0UzB4cERXUm1oYVIyR2M3UkowWkdoclo2VXZtUTR1Rkppd2tw?=
 =?utf-8?B?eTNuKzYrZUdZaHhmUEFTdEMzYzZ4SHFwZlZZdHZremJOL3UzcFI3SmZxMVJy?=
 =?utf-8?B?cjc5VUJDanNPdURkempWN2RxZkYxbGx3NERmY0gyejdvMmxJVXJhL2JBU1p3?=
 =?utf-8?B?NTF6UkVEVHBmc0FxY1dQVklBR3cvMHJ0ODFXcUprUGd5SldjOXlOUkxaYlM1?=
 =?utf-8?B?d2gxNlpoVnJmcCtUWllhMmExTWh3aVRIb1pkd21OMWxUSUx1bkxDa3UxM2RW?=
 =?utf-8?B?eFBmbURSakM5ZzkwL21hR1AyYjdNTnNvTkNGMGFucVFiZTcxRDQ5UFp1cnZo?=
 =?utf-8?B?dHZGcFZRRnk0bC95elVRZFI2YWxsdlV4dURPN3p6c3Z2Y2ovTW5xdjFnM010?=
 =?utf-8?B?OURpN3UyYXphY1A2Ni9LYm1JQXE5NzZSYWdGd2MvbzFiOFdXcW55czZ5MHdE?=
 =?utf-8?B?dXRZazdPTWxQbzBNd3JvNXVWNFlsQzhIV1loNG54V3hudGlOaW1vbWVBWEhF?=
 =?utf-8?B?clppai9wNyttd0JmQTE2UFdVSmlSZnNlRWM1aHpCdmIwWWdCNlNocWFKbGxZ?=
 =?utf-8?B?eFVTYUdFUU9zNzk5WFBZdlZuWk1LWER1MzR4b1JicCtZRERpWHhhT3hVdGpS?=
 =?utf-8?B?eE80MkhPWk5PY2VITUp3eUdVOHNLTk1xWEJDNDR1dU5rNjFSNmNPUDdPQlVH?=
 =?utf-8?B?TiszOExLZEpjTmdZbmlGSG4xZCtmYU13bWoxS1BJaUFxcWFtKyt6SExQaGF3?=
 =?utf-8?B?NmczNk96ZFUwRDJHb21sZXEycy9GQ1gyVG1FdUxwWWpKcmZmQWxZcnJRKzk0?=
 =?utf-8?B?aUVBMFhBczlObFdUUXp5N2VpcXBlcDVwV1hDQ2MwbzdaYVcvME1pOWM4SGxG?=
 =?utf-8?B?aTg0d2VSNTg0UTlkOG42cGg3VHIycXJlVFBHdjhUN2o2M0ZRWGNyQyt4VlJp?=
 =?utf-8?B?V29SRXhZLzdzSFdqSTlCdW5lOVN5alQydFBSK3NWM1lOYXhKaEJhd0x0RVJC?=
 =?utf-8?B?bDdacHRDZjBpTlVJZm5nb1ZwVHIxNXAycERKQW90SSt4T3luc2ZXWE1ENkZ1?=
 =?utf-8?B?S1hLcXo2QUdoUFkvZlQ0RENQM3NmeStzZCs5RkVHcUdDVGtDVERVMEt5KzdV?=
 =?utf-8?B?N3cwWmZtQ3hXeVZ4WjFGN3dML2oyU2tYdlZsS0wrWlpYQjBaZGJpeWdNZnZx?=
 =?utf-8?B?U1V0aDdlWGlqZlBzMkF5RExKemZLQnR5NzZlUm1YMVU3ZVdNN3phcDFqemUw?=
 =?utf-8?Q?hJUNHUVcKVCZBUo/j5gLk8C9UeXEdBVrRXej4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHZYVlh3bDhrTEVkdWozdkRDc2Y1bmZYbnZYSDE0R05TbWNmZ0NheU9DdDcr?=
 =?utf-8?B?aFFHVHkvOUhyOVpXTnR3dHBKR1ZmOUUvM25MajdrUW1xRlZhOXlBb00vQS9i?=
 =?utf-8?B?ZWJraTR2UGZEVTZ2UVZEemNpZ2dFdWtya0ZlZ0lETkorS09JL3lXakZBVWZo?=
 =?utf-8?B?NnZ5VFJKRzhGZWxCajh1anQrZkhQSVUyTk5MRms4L09NU1lUNHR0R1NwZ0Ns?=
 =?utf-8?B?K0Fta01LdDlHbGRjTkk3ZnVvZEJVU29kSjFycHdWWlIzUGhiM1FLdk01Nnlt?=
 =?utf-8?B?VHFKakdhQ01udFMyR2F3ek5uZSsvdU1vdXJ5M0JFZiswS3lSamNBYWVya0JC?=
 =?utf-8?B?ZEo4bFpqRzlLdEtRV005N0R0ODJFSEw5OHVWRVRYZDRnRnZFK0ZNODBuemQy?=
 =?utf-8?B?TEt4Y0ZIMWFHa0l6ajlkSGt3STNJVHVLME54cEdoQ2FUTTBSQjc5NVd0YVR0?=
 =?utf-8?B?OXZTcHg2Ynk3dnBlUHprVHRneGZIbjduV01pcDd4aFpLVVQzWm1pQmJoa2FG?=
 =?utf-8?B?RXdPSUFUT01QUE82SFNia052NzBTVXdpV2VmUXNUS0diS256anRId2ZPS3lu?=
 =?utf-8?B?RnRvM0paSDVJY0piN3docWNUeDNrTUExZGdDSnhLRmlxY2pGYjhmZHNOVnJr?=
 =?utf-8?B?SkpaVHM0WjFwTUJKZ3VZZk5PU2FUQndLRjBzQW05UUZEbmp1aUZVNFRvTC90?=
 =?utf-8?B?bjRZUWUzU0o5U1VuTEFWWElDU2FMM29ZL2RNTXNsc0I2N3lkOGROQ1R5SFJH?=
 =?utf-8?B?ellYKzU2R1lEL2kzbXhwakgxbEp3Y3NZcCtBa2lmanJHa3QwRkEvVWtuM1o5?=
 =?utf-8?B?SkxjbEpVRDNOdm41MWcwSXd4RzhNbE9hWGNEMkFUb3phK0o0YTFZcEhZdzYx?=
 =?utf-8?B?WFNFQi84cGJyS0RheHI0bFBUdHdqVy9pbCt3c0syeFNCMW9CL1A2OHh1c09S?=
 =?utf-8?B?a1pnYnNkQkJpczN3WmZEaUNwVGgrZVBLTDFOUHhBYjJxNnVXS1F2R2QvemVT?=
 =?utf-8?B?cXBTWkV5SExUaUY5Y2NUUWZjQnlDSDJkZmFXWUNqUVVqb0dwb0hTM2hEVHpa?=
 =?utf-8?B?Q253K2JyeVYxZUszM1pkZ1ppb0N2WTYxTkQ3dXhKcktNbVgvMHpDNjVQTkJl?=
 =?utf-8?B?M1ZkSExWMXFQekpXY1FJUkdsc0FvK2c3RHhmMWRscDI1b0p4SEVLRVpCcUQv?=
 =?utf-8?B?amtsdkNxczZLUnNxdVB0SnY2eWxFbWtnVnNMMXNWZFVLQkh3RmVEK1dQTGdj?=
 =?utf-8?B?WDBMNWZXSDgxcGRmNE1pTVVJM2p1QnFCcDYxby9yRnJpZXN1YzU3dCtwdWVu?=
 =?utf-8?B?bWM4ZjRUeFpEQ0VRcXlHZ0tJTk1hem02WWtPdEpPQzNudmtlRkdDNWN1bTB0?=
 =?utf-8?B?cUpTVmRIbHhERmFJUDh1RkZvdEo0dUU2RVN6YndsSDlKZmpSbm5wSWNZOXl1?=
 =?utf-8?B?RWI1b0p1M2JiRS9rQ2YxTFpMTkV6RHpYT3N4VzkzMjBwbStLMmJzL0ZwT3RS?=
 =?utf-8?B?aGtuS3FkbGFlUjRaWSsyQ3VVbitLNUJ0OFZpTHRncTRVT2FkWEhheWpoOUZq?=
 =?utf-8?B?aUFmNzBJeW5Hek1yQnhwT2Y0bXRiejNZL0ZSZXNSLzZrZDV3THhGWXRzZDNp?=
 =?utf-8?B?R1oydWZXL1lTcEp6TUl3eExvRHF4bXBXTWhFMEx0cTBBZG1ldVBQdTkwaE1t?=
 =?utf-8?B?ajQ5Nld6UzZpbFRxbFg3bElYVnJBNjhOT1pnRXhGTmhrbzN5MTd4Ni9oOWFt?=
 =?utf-8?B?ZXJRRE8yekRzSm13REMwUTUvUWJnaTAxUEpTcmV4U3NmTEcyOWlXOGcxRGFy?=
 =?utf-8?B?K1FSZGtyc3RNWEVjVW1kYkkvMlpsaU0vSEdLSzU1ZHhTWmZyRWFYUCs0MEpV?=
 =?utf-8?B?SnZGTUxuNnV5MWxzd2xPTjNydzdkMFRkUEtBZUp5dXRreGFEK1NJeTJ6Ujkr?=
 =?utf-8?B?N3N1c3ZhVTZ1ZTlyeUxGUXJodTVYVTdHdlBHbzdaZWlQYlZpVG1oVnd1c2RP?=
 =?utf-8?B?ZjFiV0lUSldWKzk4K0lGOEZPcFZjVThaY1g4VnNNbjV2UHZoQ2Y1MVlIdmNl?=
 =?utf-8?B?eVNqVlFjS0dqRWNzNklIM0IySnRwRjE2QThOZUdQRDF3eDZzZXp3ZEwxaC9y?=
 =?utf-8?Q?lGlNrsZZ4dqY4H/XPTKAzexGu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 324ab9c5-4252-4aed-1a68-08ddaa8dd778
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:20:34.0421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIzyPxHOZmLiUfblWxX3Sd9rDl+dRAVEEC47JylnVLFSoqN+m/JuA9ihTC3RB8kv1is0qyqg8yjkUxOo7mO0uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8532
X-OriginatorOrg: intel.com

On 6/12/2025 5:18 PM, Sean Christopherson wrote:

>> Read the VMCS exit qualification unconditionally since almost all
>> upcoming CPUs are expected to enable FRED and NMI-source together. In
>> the rare case that NMI-source isn't enabled, the extra VMREAD would be
>> harmless since the exit qualification is expected to be zero.
> 
> Nit, instead of "is expected to be zero", something like this 
> 
>   harmless since the exit qualification is architecturally guaranteed to be
>   zero on CPUs that don't support NMI-source reporting.  Per the SDM's
>   "Exit qualification" subsection of "Basic VM-Exit Information":
> 
>       For all other VM exits, this field is cleared.
> --
> 

Looks good. Clarifying it explicitly reduces ambiguity.

If this patchset gets applied directly, I am hoping the clarification
can be included while applying. If we end up doing another version, I'll
add it to the log.

> to make it very explicit that reading the exit qualification on older CPUs is 100%
> safe, e.g. even on non-FRED CPUs (see https://lore.kernel.org/all/aBUiwLV4ZY2HdRbz@google.com).
> 

That's interesting. Thanks for the link.

>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Originally-by: Zeng Guang <guang.zeng@intel.com>
>> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
>> ---
> 
> Acked-by: Sean Christopherson <seanjc@google.com>

Thank you!

