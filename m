Return-Path: <kvm+bounces-45816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3D51AAEFCE
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 02:03:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 676B81C24115
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 00:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AFD1BC5C;
	Thu,  8 May 2025 00:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="npnKYtX1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E950B136E;
	Thu,  8 May 2025 00:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746662575; cv=fail; b=jfqyPqqR0Gp0FcTk6GlmTur0V8dzaCcpIlsKQUyEh1NfLaZ9L+XMX8BqmKPAckB9+6B+2JEfGnDMp6m94bUbGuHvdDrYteBTcXRStJ0X92j5RQb3T1g/agfejiUPmjvkx3Ws4+nIIkP/SoWXp3t94phjLicQBvztPl+uEloae+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746662575; c=relaxed/simple;
	bh=DiWPrY8wZKwRJ2eIBlD+ThLiwSvxx0GOBDgH2WsLk9o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bvKz5759cFXbp6HlybP0z9r2PofHhOb/ll08gk0eyi3KiGMfqpQqaEhfl8dpNRHw6dVgM0DxUnyqW8dNnYCGqToVKOmTzRboIIHNj4p5SJNIqYRnGxjuO0h+3QnpDVPhusr+Qvi/2o9KoftIQ5jexLinZXezZQn3dA8bWdO9rNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=npnKYtX1; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746662574; x=1778198574;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DiWPrY8wZKwRJ2eIBlD+ThLiwSvxx0GOBDgH2WsLk9o=;
  b=npnKYtX1ZHbtsBRr1fuTQQ9qA3rwtlhsDPPKjYkBwtKVCTT6yh1FMWQD
   0j6nmIbSRrox+rf3/Z+R9BF+BU0q2kJ2prHf7rqakuzTwOs3eAlkp99Gz
   IolE5KNkZ5CPz5N9y88F0gyRPfCmxcIJ35CwqKkXqmM8mbrTRECJ7Aode
   KGXBDLBe+We2xdJk4Sv0f5aKqEr1BAn2XD8FOltaerrKl84dHa17fbf0y
   8QU7KmcZR6KJCJyupBIJA8g555F4/w+qDHvKnFNYuO0Rg4KmYDzgBup0p
   7sAADdIBk0kzCj+vrL19v3bwvTGUDnWz8HT7IGY4PQ/orzY5ePy0bKcma
   w==;
X-CSE-ConnectionGUID: 9VqIZZCTTo2ViRZEHgJHog==
X-CSE-MsgGUID: 7XUi7DDBSdaK2gKMKXybFQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="73809949"
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="73809949"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 17:02:52 -0700
X-CSE-ConnectionGUID: yiUr0XcjTTeVU+oFtxfmMA==
X-CSE-MsgGUID: 7x9hjDY/Q12YLPTKyhjIrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,270,1739865600"; 
   d="scan'208";a="136513053"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 17:02:50 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 17:02:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 17:02:50 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 17:02:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mTjNgl0FD+CZrAwjE2WzPgCgEK87uAYnZ+cdEubvqGdemYdIre14U5EVoIFpmntW9GWptErEJSOpiFt+FC6xriHDPmlH7pExX7fxemsO/6K7uzIRJ+wH4wHlu9eSHoITZIlu/I67MYpmftchk1l6Fm2ASe76NWnaZJyW1N4jtioOK+W5IRqHabP3lnJHLnOp9Z/MbF6s2t05DFTW0wudOGxgHfKJaTRC0OkEmUVT9BD4nyGEnrjEqKiAML7EJPp1ZSoFR8HuGyzIhNGsyB9rfwEnRzZTUsXjzuF0Juwelqxg5Ccjcz9Da01qGZEZnWgJekuTuruKSVL51iT9858OSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UbUMv5i0955SnTJdycs8UUCkiVxRg6GTuamwFCM7jMc=;
 b=hZQ0XCEcCP3IBC7jch4jjWXpjLNfOMqeOwh3O1jAb3DI5I8EYp8STe/w6KuwHA8XRE/VfESGy1DDTQXT7FHaZHULCMLg+YGVdCVJsKyINGAXIrItiUviKvWrWymkrw0wei3BR260nHoxy9oDRKBw9r7o5AMKd0s5YG8Dibeba3dMOr+mDwBFfAAvnJZE0Hyv9TLfUr3e+yMf2fnK1LFPdWK13P6UnLGea+LXyIrqIYiTcMRRGdzIAodNnF6uFj3lqvLDsRL7uH/yi1It5QamAhOz+QYVPVsriJXOFmRRr8Zlbat4RlWmKGH7hKVQnHTwO8hRic5NlzvrgjUpeYQb8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by BL3PR11MB6507.namprd11.prod.outlook.com (2603:10b6:208:38e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 8 May
 2025 00:02:45 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%7]) with mapi id 15.20.8699.019; Thu, 8 May 2025
 00:02:45 +0000
Message-ID: <6a7165ac-2df7-40ae-af68-f4e16cc04fa0@intel.com>
Date: Wed, 7 May 2025 17:02:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] x86/nmi: Include NMI-source information in
 tracepoint and debug prints
Content-Language: en-US
To: Steven Rostedt <rostedt@goodmis.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	"Kan Liang" <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Paolo Bonzini" <pbonzini@redhat.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>, Daniel
 Lezcano <daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, Lukasz
 Luba <lukasz.luba@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Brian Gerst <brgerst@gmail.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Nikolay
 Borisov" <nik.borisov@suse.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250507012145.2998143-1-sohil.mehta@intel.com>
 <20250507012145.2998143-10-sohil.mehta@intel.com>
 <20250507174809.10cfc5ac@gandalf.local.home>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250507174809.10cfc5ac@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0023.prod.exchangelabs.com (2603:10b6:a02:80::36)
 To BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|BL3PR11MB6507:EE_
X-MS-Office365-Filtering-Correlation-Id: b26e3d29-da24-47c2-e3d6-08dd8dc3a906
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnZFRUJDTFBMMzRHTjdHOHhoaHF4ZG50VURlNkp2T1RORmthK3VqeW85ZmNs?=
 =?utf-8?B?Nm0wYzFUWEx0Y0R0d3VDeUFRZmZFcVZUaEt0WEtMMjErTDFVZmdwQVNSK0pn?=
 =?utf-8?B?TDBOQkxJa3M5ZzVxbzhtT0dmdVFJamNJUXB3TGo4U2o2czFGR080SUtKM1RQ?=
 =?utf-8?B?bzVVVVVzc29VTDZQYTJNd2pUQXdmVlh2SytNT2pOYTUwSGVJWU5tOG1WaU9R?=
 =?utf-8?B?YzVwOWl3cTZ1aFBEU3EzSzUxMFNDTWRFNGRKV2NyU0ZvZWduMnVMSWZUREFI?=
 =?utf-8?B?MTQyemZNOGhXYTZIOXVDVVFVbUNaaHY4N291OWtLanFEb3hpOGdoMXo4NFBV?=
 =?utf-8?B?WGNhelYvOUhxR2lqaEsvZEdsYUNHUjZRR1k3RWw5UVcvL2c3ZHkwN0dTQk90?=
 =?utf-8?B?Y2pZWDNUUTd3OXRuUGdrWEg4VHBhYkJDQU5uZllDU1QrZFBXbUh0YllxeUxp?=
 =?utf-8?B?SjQ2OEUzZEoyYlRMNWtQTnNlczVNYWtSVVNnSmo3UVN2K3haUEZ0T2NYQytL?=
 =?utf-8?B?ZVFaamIrcnRDaCsxZEZpQ3JCRStLZG45OGVWNGx0SnFXVmV1U1EvcEthVyth?=
 =?utf-8?B?Umo5eXd3cFd1bmVmb2t6ZXhmT1UyMi9IaDRPT1VLTHBHQWpkSTVYWDd4Z3Rw?=
 =?utf-8?B?VFkyR0RZVDNwaG9EaGJlcnlIMy9EbHBXSmxsdWN1TU9vbnExZ1hVVW5oMTV3?=
 =?utf-8?B?UzZ3MGkyRTF5dVEwT0ZwSnBGYTNGUHJXSlkrbE9NVS85Y0ZXVEtuRG1HSWo0?=
 =?utf-8?B?TStObHYxbTROL3ZiditWTTcyK1pJaDBDdlhTdlBabDkzc2NjaXFDY3pXUjls?=
 =?utf-8?B?cVB0WGFoOEloNFgyNWNSMWptdUNsaU8yak82dU1EdjZvTk5saCs1MjFiR3E5?=
 =?utf-8?B?cG9wOFA3ZWJaRWdMSklHRXp5eVcyM0YzNXFvR1luWUplMlR0WXo5dm81enhB?=
 =?utf-8?B?UnBhaFpsMGJJMEN0VUpqYUlBWjFwVzVTZHRYMjNQZ2VydTBkRjlqZVkyVmJL?=
 =?utf-8?B?bU9sS1l1YXNXMGx4ZHFaMHBabnJLazNkNHBFZGpXVjZOclQ1U2kzTGsrNXo1?=
 =?utf-8?B?N25OeVpxWk5ibEpYNktYc1N6SnArUUs1eG9SQk93RTVleHk5YUlJM01qcXZY?=
 =?utf-8?B?VVVNcXE1MG14Q1FXd0dTU0tjYjJGd0piZlRrVnJWeHpMWDlVdTRrYnpHRFFH?=
 =?utf-8?B?aEo1UHZhTlc1MG9YekdQenoxaVFnem4xWExLNklDK1hrZEpUNDBuUzl5aFQr?=
 =?utf-8?B?cDk5NGU3YUlxTUh3MGJDd2N0RzgxQ0thZHYvN3ZnVy9Ecnl1Q2xRYkxNS3V2?=
 =?utf-8?B?WGZ1RHdHWGthaUpGMWxJaS9zRm9YZk52OGFOYXFTOE4rUlpLcTdReGhncGRk?=
 =?utf-8?B?eHF6b1V4UHp0VHZ2M2RNa1ovUHJtNWhRSE1NTlc2TEtPMmNCYnBJOFhDY2kz?=
 =?utf-8?B?NS8zZ0ROSVdReWtwTk1QZ29kajQyUFo1WHVkQ2NNS01vS1BncXlmcXRoUjEz?=
 =?utf-8?B?Vjd2cCtRZDJkQWpGRThBRVRHTktCMnRLdXpsWFNqVVRjdEcwSjE3WUx2VCtU?=
 =?utf-8?B?dWdwOXhia0hIVDRkekFna1RyVzB4eWNWTjI0TXladVplUmpjeW1qWjRMM1hs?=
 =?utf-8?B?Rm1qZ241K3loem1lOS81SnFCTExrODZvSGpZWEtmVnFiU3lSVHJRUDdZdytu?=
 =?utf-8?B?dVRlalF5eVdiQjRVUmdxSTAzZFAyQWdmaU1ybUZmM0xHK2dQWXVDSlI4dldm?=
 =?utf-8?B?SU9ldmhNVXhMemNEM1A4SkVHYjV5ZDlMQThpRnlIQWhKOXllblNBR3duMW5O?=
 =?utf-8?B?UWRyMmEvdmRXa3Zsb3hpTVliNi9PclpqdE14aGJmUjFXT1hKR3VVR3RheHBR?=
 =?utf-8?B?TmhtdHl6eVVLN3FuNTdxbWxKVlpJVXI1QkI4OENqcEt6bW8rT3RnaHEzMi9q?=
 =?utf-8?Q?ftVtkHZrmac=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUxIV2Zmd1I5ZmFQSzVVaEV0bEl2empDWmZzYVdOZmsrYVQyNkR1YlFQajVj?=
 =?utf-8?B?N0duc2FpekkrQnhPZytlQlRIaFpNeUNkVFZnUlJ0VGFROVJ6cnp5d0pFTlBD?=
 =?utf-8?B?MytlUEdaNmgxQ2RWdnRRWTk5eDhncjlQekd6b3ljdURxQzVpdUZuN2UzMmNZ?=
 =?utf-8?B?WEJxL2UzMDBTcFl6ZEVxTVR1T2ZSYTFCUTNwZFZWektJbWt3bzduTkdMWlBv?=
 =?utf-8?B?bG9BRGN4UHVwbWtQWTVqU1Ywaml5Z0M1clZlNjlRc1pGUVZMUTRwclBsWDBk?=
 =?utf-8?B?NytBTmk2UXQ2Nkh1VGxCL2NtQ1FJNzg5aXJCQ2hqM0l5akpNV2ZXc2NRNWlv?=
 =?utf-8?B?QTNVc3Z1NTRUSksvdHFVbnlJL3lEUkpseHE3Q1JnTkFZT1JkaW9kVVh0ZWFF?=
 =?utf-8?B?TlgwN2E4MWlWcGh2eGR2OE1pRit6bE1ZTE5veDZXcWIrUWplN09EWmtRZ2tq?=
 =?utf-8?B?N3hCUlhpV0IxSnBvMHcyeWxaWDdWS3kxeG16NEpsVmZVVUl4bTNPNXJ1cHNP?=
 =?utf-8?B?TlJsZSsxUUNMcG1GOUJjNEY4QVdNdWUwcklkVml2Ykx6dDUxZHcwRkdESDZl?=
 =?utf-8?B?UEMwT3hrci8wOTIvbEFpckpDTW9GRzlYQWVidURmOFJ4ZVY1amJkaVlUY1NE?=
 =?utf-8?B?MnRHeEFlTFE5TUZYMWJvVXVjVWl5UStFUWY5bzl2QXI2UlI5ZUR5V0c0dUs3?=
 =?utf-8?B?Nit6YmJCZmhDN3ZhdTkxWVpyQ0dwK1kraVBCMGQ3RlpBbXZNNDRMMzJHVDlF?=
 =?utf-8?B?eURHRU93TnkreTBSRVZFRVdWUVA5SFFBOWtPa0tLUjBqVTd5Qlh3TU9Ua091?=
 =?utf-8?B?VEFsUzV2SmpXcWk0TXZpL3hnMHpYb1pyWTFBQktlck9zNnFRdXBWNW5VSTBi?=
 =?utf-8?B?MUJnSlliaFIzQmVyU1ovcUNSL1JEelJwRGhzNjlJbCtSL1BMSUpKUkJEVHlI?=
 =?utf-8?B?U1ZkN2M3VFFsVUMrM0Y5bXhURU0vNkY5L21lb2ltTXNvNUMvUWZmL2VGelBa?=
 =?utf-8?B?cUJtcFEvZTgwQXlhakQrOGxRMGdHRUp5cVBhbWRNeklJWnBOeVNucldNRHhK?=
 =?utf-8?B?di9POE41RkJIbFo4M0MwS2RUamxCQ3puYkxNSjRNU1ZYUVRYSVNTV2tGNHNT?=
 =?utf-8?B?b2t0a2pCQzFBaVZwZHVyUVowQVJjZnpMWnlaUjN2NEY3OEVoZkFsRlNkZjVo?=
 =?utf-8?B?cFU2NlFiU3VxdDBaaE1Uc013QkZBTHl4OVlRSXFNVmtickF6MVA1anRtRDNT?=
 =?utf-8?B?dnJqRXlPMU9iajFUbDNkRE5URnIwUkhoSFpjMGlsN2dFblEzNGNaQnVRc3JL?=
 =?utf-8?B?U3plUlcxUlBvUDVTLy80TTRiU0p0Q1Q4UkxZQkg0Y1hRc0I2ODZsV2RiYXpm?=
 =?utf-8?B?T3FXa0Z2MnJaSE1ZVXVFQ3hzT2FuNFlEU2FaVDBjNDRRS1pzTzlqOEx4dmZq?=
 =?utf-8?B?RTB5NVVQYytMNng3cmRIUGliRU9kS3JnN0dyVG81eHI0VmZDQUlhZ0hzdkgr?=
 =?utf-8?B?ZmlrRUJhdjRuelpCT2xHcm1NL1lYbmJpNTV3em94ZU5qd2F3RFFDcFUvck9x?=
 =?utf-8?B?clVJVW1hVkdJMEs2elZaaFNIZ3JqRHM5K1ZkL1NyQSsxTnd1K1JTUnNoNGRp?=
 =?utf-8?B?THJ6ZHRBQjYxVHhZUmN6a1JOWkZIRURRUjgvYVBZOHhmTzFUbGhIaWpPZDZ1?=
 =?utf-8?B?SFcyWThMcm9ZUTNrSHo3eGUvN05YelRLYnhoY0t6MWdMN0hoYmppSEZUZkJV?=
 =?utf-8?B?Yzh0OHptMUttWE93R2NSWUxlN3BPaG1samxweEpSbFg1a0VnaFVOR2tzdHU0?=
 =?utf-8?B?Q1lMcmkwakVERTl3NFE2RGNrdytSWGs4QUFBS2hickdPM2tlN0kwekhWamJa?=
 =?utf-8?B?TmtWWDFlVVZHZ2ovSDJteTM1bzRzUG40QzJaTTduNFJGU081b254Yk1mR1dO?=
 =?utf-8?B?YTdoQWkzd2loWUpOellXZ3FzY1JzUFE0d3IrOC9xbklCaVpLMXlmVW1La2Fq?=
 =?utf-8?B?ZzN6Q3I0Vkt5VGgvOW5qS3RtY3F4cmdhemxPM0VFWFdveDg2aCttd05DdFkx?=
 =?utf-8?B?V2FMaDduaW43aWwwSUhvaFFidFpmWEQ0dWNLN05lT1l5c3NoRzlmTUV2VTF3?=
 =?utf-8?Q?heKTCaOzsB07oie6+ey1BLiX3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b26e3d29-da24-47c2-e3d6-08dd8dc3a906
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 00:02:45.2586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1rSZWkeXXrqibw7+NBEYtiKZbSEpGq43ob8KiD6msuQCHHwmlfoTsaSyGpR++7dVvOAO5qoYK+xjh0wR+O9zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6507
X-OriginatorOrg: intel.com

On 5/7/2025 2:48 PM, Steven Rostedt wrote:
> On Tue,  6 May 2025 18:21:45 -0700
> Sohil Mehta <sohil.mehta@intel.com> wrote:
> 
>> diff --git a/include/trace/events/nmi.h b/include/trace/events/nmi.h
>> index 18e0411398ba..6e4a1ff70a44 100644
>> --- a/include/trace/events/nmi.h
>> +++ b/include/trace/events/nmi.h
>> @@ -10,29 +10,32 @@
>>  
>>  TRACE_EVENT(nmi_handler,
>>  
>> -	TP_PROTO(void *handler, s64 delta_ns, int handled),
>> +	TP_PROTO(void *handler, s64 delta_ns, int handled, unsigned long source_bitmap),
> 
> Even though x86 is currently the only architecture using the nmi
> tracepoint, this "source_bitmap" makes it become very x86 specific.
> 

Sure. Will move it into x86.

> This file should be moved into arch/x86/include/asm/trace/
> 
> And that would require adding to the Makefile:
> 
> CFLAGS_nmi.o := -I $(src)/../include/asm/trace
> 

Thank you for the detailed instructions. It makes it a lot easier.


> diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> index 183e3e717326..b9ece0b63ca7 100644
> --- a/arch/x86/kernel/nmi.c
> +++ b/arch/x86/kernel/nmi.c
> @@ -202,7 +202,7 @@ static int nmi_handle(unsigned int type, struct pt_regs *regs)
>  		thishandled = a->handler(type, regs);
>  		handled += thishandled;
>  		delta = sched_clock() - delta;
> -		trace_nmi_handler(a->handler, (int)delta, thishandled);
> +		trace_nmi_handler(a->handler, (int)delta, thishandled, source_bitmap);
>  
>  		nmi_check_duration(a, delta);
>  	}

Also, I just realized that the source_bitmap information might be
incorrect for !NMI_LOCAL. With the new changes suggested by PeterZ in
patch 5, the source_bitmap would be significantly different from the
original one received from fred_event_data().

I need to figure out a solution to print it accurately in all situations.

Sohil

