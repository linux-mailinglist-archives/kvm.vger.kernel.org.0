Return-Path: <kvm+bounces-57115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D24B50210
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 18:03:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E32D01C27424
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 16:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80922338F32;
	Tue,  9 Sep 2025 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eCZBuJ3I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226562EDD52;
	Tue,  9 Sep 2025 16:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757433807; cv=fail; b=NyWca3pR3jtzQUeu14DbBkxeAhJK5bjCiqAcvGfFPml5ZU+9lbMWhlO7NpEHNJP08v9vteYX9bn2cgZLlqcZwpQARfWRuWM9YDpu4RawUY0LeAb8n0bVLorXCPBOC/O3swsZEpQ/vaKEz3Vyx74/E+szDjegiMEcs+vFBb8Kj50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757433807; c=relaxed/simple;
	bh=gj7/Jez64aSpCvEBFwYkY9QFz8tzU1nUOabMSTBCf20=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZTHXTJnvElb/NO7HS1s/etNLoH7DAyyliIK6Jv3o4O1Z/8/Y7K0oHN4RdHnywkW14DsO1DEfKka534MvlhWYh2KksK3Vda4bDFThjMKv6Azj3anXOIXnNIfVPkLlgJyMahUXeNyFlIvPCPFD1sCfM2jkrMcyxrbjvwrxziLbcIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eCZBuJ3I; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757433806; x=1788969806;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gj7/Jez64aSpCvEBFwYkY9QFz8tzU1nUOabMSTBCf20=;
  b=eCZBuJ3I5MfeFoncgl0cLu5kw35NvnAmVZn4Kk4sIN2ApO9KyazLyW7V
   lKeror83hkaTGqNrSEpB1VoBymgTeh8BSaTK047JOdGCRMHceBStImU/G
   6GOUrBTUvJD9HmkNNKcruyNHkTjc2bS2E/tEB/OwR8Bn5X9+bSOMpS3so
   nEtxtrz/DuuA4lUAq+1WxJVvIeSY5l5O5P0KaZzFqd/AJ8G5AxrSn8gZv
   1igenntGNUSUF2dwhHAWh6Z+BWyQAaCDLRs8SzpswMbDq5rPl6rVswhOG
   csvcXSO888lRPVF9x/vTarRG9V8xkV1KjrNQPV08vI6ry5958heRalrhB
   w==;
X-CSE-ConnectionGUID: FEcN8ER4QL6cw/JSEHMqqg==
X-CSE-MsgGUID: d2vt6f0RToOFOnDjtny9JA==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59419959"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="59419959"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 09:03:24 -0700
X-CSE-ConnectionGUID: PhYVp2uDSh2KiYzy5Q0svQ==
X-CSE-MsgGUID: +PPvyWY0TACTx86/RFLS8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172699689"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 09:03:25 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 09:03:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 09:03:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 09:03:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TSpZ51MyoHPnemu/usJ6t8k6qwHB3kzAzjvokwNo6DvpTcD//ejFJK0F5qFkJeAO0wiFYBC9CbFoMn8LvG9Bqgn0j/iK6SPm3koBG8YZPpV8ThDAQUm7DKfEsmeZGL8dlCuc8Y69cqsu3ZBvLQfA8HJfNXIzPMweqnwUD/OXmzspxxZ4A25P2iQ798jvoVjZbrj9gKqpPIjQ/UE7Gh1j7p2SUSFx1wGUW8RA8m10h/F2FSCXg5vr65sPJcQPzWHpmT9bFqVyDG7k+sFKWjVWHSl+azWzJc/CiDx5SB8ndBbNC0DrOtYV52aCVvvGA0uERo5x7/6nUjDKyuNMrrx1rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6T5QWROox8Bs7MGRuXLK7efnSQKPscK/NqeJfjiouTk=;
 b=xRW9IHB8ve6KaQMjoFK7BvTGOJxfa4a48JcaaXJbd7qN6lywfdZvLsfVVEUCw6L1+klXAk+EOjR9ltX8iSVw21Hbng8Ci5BIZLKj6HUJfNLqDaRIoT0TriGyhqzOeLQn5jC+5ObjEx5sRxwTURUXQnUwDFt7Eif841bP1qCUQntTcYIN3fcv6aOSeecQ37lluKBIgN7upl0j//Hic9iMBwH44GTCiuh7GY2sI+LOnT3pIumEurEwbkpWlLxdQzcK0TXNJK03rgSkE40/Dis+G/O6u79ofxbhxCKIl7eio7l0aqNLdOVx70hpC10wlPjIWsNCCCRujMMW2cGNnxKKoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7862.namprd11.prod.outlook.com (2603:10b6:208:3dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 16:03:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 16:03:17 +0000
Message-ID: <107058d3-9c2d-4cd4-beba-d65b7c6bd9a0@intel.com>
Date: Tue, 9 Sep 2025 09:03:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0197.namprd04.prod.outlook.com
 (2603:10b6:303:86::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: a783f4c0-1496-4260-18de-08ddefba63e9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cTFsbGxBck16OFFJTmdkS3Ric2FicmpPWm94TEhKMVk1NDdWZFVqWHRocVZN?=
 =?utf-8?B?WFJSRGVSRzdqU1c4S01xY0RaOWg0STJ3dXIwVmxoQlBOdWN6QzlTd0Y5MFlK?=
 =?utf-8?B?VFhONXRHY3MxUGFMMXVSNUhsNDZTV3J4MkJCSzc0YitNcmkvamRDRS9TTDho?=
 =?utf-8?B?OGU1R0hPL1crb2VMWXNrNjFKNEZaZkNzU1VzN1R1cUdxd1lKRDRZQllYSWJE?=
 =?utf-8?B?K1c0MndtWDF0RzEyTnlBVnljcmVubStxQVd6QURLQUgwYXRXeHVYQ0NrMXgz?=
 =?utf-8?B?TG0vTHdtK1ZiWTFZOC9qdzZBRThuRGR1ZjVGcVlGVWduUUJ0bHoveGdMSXcy?=
 =?utf-8?B?Z3RDNlpQZlJoenlMSmFObmxObUpmQXNxTmF5K3BSeDl6b3dkWURYY1FNNXJP?=
 =?utf-8?B?aXd5cFAxd21sQytNakVNODYyelhqdWkzN1lGQ2wyczRNcXNoem50TUg0UldZ?=
 =?utf-8?B?UzJxZHcwT3J1MVZvMk9ObFMwL1Y4SHNPcXpwL081OVV0eXFZZmNNZGVkbWVE?=
 =?utf-8?B?eVFHRlk3dVZSN0JDZ3k1VHkzT2Y4TGFwSFVQL3htdWRENkJKaDBObDVMRFNS?=
 =?utf-8?B?SzUvR2I1aU1iQUtUTnREMWZjbTVIZlZaTFA1TzgwbllOOXFldUJrTXErU2tD?=
 =?utf-8?B?KzNIMTEweDJ1TkZCdmJwVTdqWmlPdFBqMlkxUW9aS0NMZkN5a3BNcExZR2Z3?=
 =?utf-8?B?OWN2OE9leTBLV2dVcmorZkRsRmlXR1ZuakxNQ0JXbUt4c3BPZVUzTEprTk1G?=
 =?utf-8?B?ditlcmxhSnk5NDhueW50R3EzS3lUMUZtVGNpbHNqVFh5Sm5KT2VNWWtMa2t3?=
 =?utf-8?B?V2UvVjhESThYOGR2M0ZvVHNrQ3hhZHJlYkoxUTBsTnFrc3NoNmlTTGdTVTZ3?=
 =?utf-8?B?elVGTDBTQTY4dExnVklIUmtoUHY1R3FkdElYRjViRGZTUG0rRlF6L2FLQktP?=
 =?utf-8?B?dVFxRzlPU2F4UnVyS3NOSDRGVUFzUnprSmVMb2NzOUh1NEVTVGp6YkJHaWZm?=
 =?utf-8?B?VGZzOFlYZ2NDeFZocWR3aTdvazhOYjh0alFUNjZJcGVGT3orM2J0YU5yenhF?=
 =?utf-8?B?cW8wcU9kREc2NWtieGl6T2lkREJ3R1JTR3dsSTBMNU1waS9Mb1g0ZDRTZHl4?=
 =?utf-8?B?VU5mL0lpbTBGTmdtWi92aWJaVFVRVXVSeWlWcUxkYVNLYlhMcUJmQkQ2VFRK?=
 =?utf-8?B?TWRhUkQ3RkRubXA5anRWNGUyWGlrR092WUFsQTliSEVNdkdJMGZEaDhSdHNv?=
 =?utf-8?B?cDg5VHZwNGxvcVhJT2RMbnBzb0pUL1ZTL3BkeVl4b216RGZsWHNxd0FLSmJ5?=
 =?utf-8?B?dm5rLzlYdmxBVUpZOVVUQzhOOXFlTU8reldYWWRjVEhrZTFTR0lZT3kyeTlj?=
 =?utf-8?B?L2QrZjFGSUU0a0hWUWcyRlRDNnloOGhEa3RxQU43VEpmTXdwank1YXpMWFdG?=
 =?utf-8?B?YlNndG1pWjZsRktOK1hsTWt6RzFGK1ZvQW1oZXRzTUI4OHFyMVhSRHJVYlRp?=
 =?utf-8?B?dHhEMU9taTB0MGdoWnBoVG1ucGM1R2JXTE1HTldyRGMzZ2lKQStDMEZ3NVhs?=
 =?utf-8?B?OHRFTnpOdnhNZ2dlNVN5V3hSYmN0alJlWFZOUzhzd0NNOElPZ2tZQ3FCcmdQ?=
 =?utf-8?B?aWFybnM3K3N6K3JsV0NmSkd5cFVyd3M1RmNOV0JlbmkzMmRNSVhHTGozR0FU?=
 =?utf-8?B?WHZoRFpYREFTSHRheVdiK2VOUCtKR1hmeWZEQ2pVN0k4OCtUNUNxWWpKRG0v?=
 =?utf-8?B?cll0RWtJN285NkMvbTg1TmlHNW1DU3lpaW9kUzUrS1htT05uS3AyWkVzTEVD?=
 =?utf-8?B?V2RpZ0N1QlZmZU1PSFB2SzJNeTJ5bEFFdXQ4eVQwS0hIZ3hmZk5la2xxcnJH?=
 =?utf-8?Q?K2abMNwFE2I8H?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXJsblJKUlRRelQwVUhjT1ZmVmMxdU42S0l4ZDE5YnZvSkNwR3RTTW5xZlp3?=
 =?utf-8?B?TU91dDhVamVIWDc2YzJEQzA4dHhSS045Y09vU2MwTnFVdURYOC9rU1FqNWd1?=
 =?utf-8?B?WHowUklMZmcyZnRzaWtobkxLMlhOR2lXUG1hNEpIY08xU05OS1pGY1FXbVAx?=
 =?utf-8?B?TjVIeFhGUzdRUEY2Y2Y3ZWszZ215NDB4ZzFmN0FmbXZVQTExMVF1OGRYeTVR?=
 =?utf-8?B?cDhkbC9PUHNJWEtjZVFVVmovMEJXWFJpMEZoZEpDSTRvYzNTWjlHV0MreGll?=
 =?utf-8?B?RjB3SngrK3lMYUJ5aWNVaHE0NnBrUWo4Q052eGNYbE5YVmZ2cGhnNlMxVEZJ?=
 =?utf-8?B?bTlXZksvVTlxajU1TXQ1N01lNERZajZ0dmc2bTVmTTd6akcyRkVjdTd0cWVh?=
 =?utf-8?B?aGZiZUkvNFptbm1QZDVtQ0VmT3dZelBFMG55QURIRy9GMlNWNzRzNmorc21K?=
 =?utf-8?B?aWxod3JtOE1LSC9rQ29UeS8wMmJ2TVQzSDhMeDZWeStkZ1hZTFlDUVBkMlAw?=
 =?utf-8?B?R0JRclpUby90TU1NZHk3ak9hL0pFWkpSMGNJVkhkYU5peHZLWGQ1cHdlWG1r?=
 =?utf-8?B?Y09CODVQWHJkQUU4VUdvYmNZTHdicnRhcVc2OFRLN245RndhSFJVeFVSK3Jv?=
 =?utf-8?B?d1ErME85eEF5WEJCUlYrWWw1bGFPSFpQZkNwV1A3VnArYXFnb013L0kvMkha?=
 =?utf-8?B?Y3UwSkk5YytRRm5OeTU4NU9PSHBPNXo1M3RRTXhzSW9Yay9SZldFbTFWb2hJ?=
 =?utf-8?B?ZzFLUjNSWGl2em5ESyttb0FPZHp6aklLNEhRK3d6a0YrWjBKQmRxUjlXU21q?=
 =?utf-8?B?NTJ2STBCclQxdUxXRG1OL3dHcDk3dUNQRlVKd1ArMmxQOWh4K1dDTkkwcFE3?=
 =?utf-8?B?dUhYNXRFS3paQS8wdmpxcWdtRDJ1WnRCckdzZWE4a3RwejVMN2t0ZFAyejU4?=
 =?utf-8?B?dCtWNE94ZXhMWWd4SzZDWERNR2doaVkvQ2dYdHQySy9OY1RoVjhXSmdsWndw?=
 =?utf-8?B?bDY5Q0FhQmRMcGtWSklXS2hqM2Q5TWJaN2hYeHdGU0lpd01KdGh2amZ4OFNh?=
 =?utf-8?B?R1NETUxxaHU3cXFCSVBGVFZQYXVaNW5QQjR3NDA2ZENLWWR5WjFqZHJjMzdz?=
 =?utf-8?B?cGVkTUpSMThhVnVnNjdFQTBrek45UnFHcEdaYjgyU2c4K3hicC9kdEY2UlBT?=
 =?utf-8?B?cmQ0bUJET1NlVWxLRTdkTXlMd201U09kaDMwZDlaalZwTVNOVW5DY2Q3bUN0?=
 =?utf-8?B?ZERGTklhakxNR1RNaVMwQk5ubnBmYVdtMEwxL290MG5wbUxuZ3czSXM4RlMv?=
 =?utf-8?B?eTJSZUV2cmF4L3pEZVQ0T0xXQnovZTlITGh3bzE2OGN6TG9LTy9DY1pWUDgv?=
 =?utf-8?B?K0I2bUx5eTBhL2dtdXhUQ21OK01KZUNBNUNPTHVsWklORlA4RkRHeDVEY2NO?=
 =?utf-8?B?NXhZSjlCb0tNbVpGZ042MFd5dmRkVlcySUJqTnhER2QzcHpoWU5iZFA1TkZE?=
 =?utf-8?B?dEVNMGdOemk0bnJ6QmR4ZEM2WW45cGlrWG85V0VwNGtvTFZNUVZib3NvMVdS?=
 =?utf-8?B?eUw1MDViNDljN0s2eWRPb0JYYXdoVC9oZ2lENGk1QVRrMTY0b0RhWVQ1Z1Yv?=
 =?utf-8?B?YW1wb1hQVWQ1cjVwUjBMTXVGbk1pZFlrTFhadkhraEx2UnREUTc4Tk1yem80?=
 =?utf-8?B?THl2UGRiL21EMmdWcS9tMld0OXIzc2ZaejUyT2I4Ny9zcHRWTlZwZGdqZnAr?=
 =?utf-8?B?RzRaNlR5UXZFYW5uTEw2Q3piWUxxcXRQLzFyWW13SmpEdXplVXpDamc3U3NK?=
 =?utf-8?B?UWNHMldvczRiaEh1ZVBwb0FVSzdwWlVVY1dUUjVDUkJoaHEyVjdwdEU0UFZh?=
 =?utf-8?B?RVNTWWVtUmhOMHUzU1E0bjBPN1pqWnowdWdCYmVwL1BUVjNMZ2ZacnlLeEI1?=
 =?utf-8?B?Tm9rUnRPQU04V1JKYjU1d2dmL1gxUFFFb2lUNFc3eE9kc3hQTjZnRkNKbUpv?=
 =?utf-8?B?K3lZSUI1WXVkWS80WkMyTm84R2Zxc3pHdko1OU5qOEU2VUJBU2E1c2hvYmFT?=
 =?utf-8?B?YUgwM0R6Rm9ySXAxZHJsSFk5QVM0bmk5Q1VVNGdCTmhIYk9DVlMvQ1Z3QmJD?=
 =?utf-8?B?VWJ0ZjF0a2J4U3Y2K280QmFJWDlaVk5PUjZMTFNDU0lybE9uZkpXejB4Wkx6?=
 =?utf-8?B?WWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a783f4c0-1496-4260-18de-08ddefba63e9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 16:03:17.8072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9nbh5NTyEYVbm0TFy5KuuezEGgLDhyDwYweo6e1p5rdapt/3aXjrwJzdL0RSx9g1z0pISOOwbcKWxx1HjZcD2HpBU/IZm/dXEIX5YHVCuYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7862
X-OriginatorOrg: intel.com

Hi Babu,

On 9/5/25 2:33 PM, Babu Moger wrote:
> 
> This series adds the support for Assignable Bandwidth Monitoring Counters
> (ABMC). It is also called QoS RMID Pinning feature.
> 

Heads up that [1] was merged to x86/urgent and conflicts with this series.
[1] is a small patch and fixups to this series should be clear.

When I checked tip/master did not include x86/urgent yet but when it does (and
tip/master thus includes x86/cache and x86/urgent), could you please
merge your series on top of tip/master to ensure all conflicts can be resolved
cleanly and ready to provide conflict resolutions to Boris if needed?

Thank you very much.

Reinette

[1] https://lore.kernel.org/lkml/0819ce534d0cb919f728e940d9412c3bab1a27c7.1757369564.git.reinette.chatre@intel.com/

