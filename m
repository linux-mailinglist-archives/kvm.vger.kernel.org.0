Return-Path: <kvm+bounces-71426-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDYkJPnjmGneNwMAu9opvQ
	(envelope-from <kvm+bounces-71426-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:45:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BAFFA16B4A5
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 23:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 98D333033D3B
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 22:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85631310774;
	Fri, 20 Feb 2026 22:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EeP/XC/M"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013039.outbound.protection.outlook.com [40.93.201.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B1C30FC23;
	Fri, 20 Feb 2026 22:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771627500; cv=fail; b=i9+ujzQdPpcdShzSSTQIABbdFD7T36HKv9SIx+Hb+lXwFzvAl0537/SGk6sKytEV/T+ogc2VM8hIWVdO9aD+Pmys2AYl0E9542liw5R8IzxnuYOZ+AqD4ecN0hj0HKtrW2K3D2npXJDjCkh4IeA7XzE0UO4DQMAHt0P5eNvKFdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771627500; c=relaxed/simple;
	bh=0QiXFBXKbvaQGY0WsAe1dfMIzuHtSA/W3ZYOTswQgBY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TNko88Kg62iB3ocmPoL1/CtOBYx9wxn/9otKEn6hwUX3hRiy5ikrQd6tOI3soYPeT6Khjr4uHqlN6Q8j0cE8HwPkZCpDuOvv80Fq4EarJycwqDQvaVpfQ/IgLf0QMGOTjNgvxmFVP2UB09PKrWCxhTBu1AY5squinKgENsvOp5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EeP/XC/M; arc=fail smtp.client-ip=40.93.201.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N63DL5QhGn3bkxuZHk08hBEbDBcPqM6yaKh8Hp/oQ2E6O3SU1rsp+XGl9F7U5YFa17Om5xkz91ptMHV75FQMVXM6ROh+7Z7NwD/uzhobVhpp3lLwGgo+rihS2ckls2G2oxk8ud2G9CKmHlEdeelsCeFSKEc7ckaCWcGSANjeN2xNWMYQWs2dF5+qxAibMWNTW2dIMmkD5FRvzoj4fdb4GtEAfzPL+Pj6tJKwT1aDAi8yc/anMMq4AaH/o0e/5XqLRIXB0a7KPEFSHsvXfiMeejcQnlr7mVIMnrBDhwWclWxd1FZ9QvE+fpXKhJ/eSgV7ah8W3XR3hds1I76uIADP2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4orHArMAhQT6aDbzBJ0gB9B6AtF6WaANOf71v3Qkh3c=;
 b=JsXEwijdTjhM2d8/l7i0RYa2HKo+Gj5AzzJ9wwTae7f9w6eVtd1h/Vd/9QH//f+cUQpO+MopN6ghxtZGjZgeOE0bnVUb3mo9jMuCUHcHlsOA786bFg1g5c/zHoCZFvRgfj0pEyBL1Nm/yxtekRZ/tN4n2RrZbhpQTq+9K5Eh4RRG8gndLMU7Ptg5VI77RXph+gMLmaIP0C+J/TtdMxf5tSQmYk6UY8xaCuS3P5xVF3qgsglQT21eouzdHX1GvKxOJx/2EbdsGhF1AXEVAXgK3ejoNXfq/SMeT72+JmFiy9k9HWwHg8EjwMAR04FzYQSj0eGGt0+f/yg5CFsCKOqs7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4orHArMAhQT6aDbzBJ0gB9B6AtF6WaANOf71v3Qkh3c=;
 b=EeP/XC/MFHvQh48cW6xaOsgBljBxqJQfJwC3XzsJ+dnRSi4whPtpl6YHUeHlltsC/sUjusTMY9On0ep7f+RsQtXqFzsGCcjtHjzXVGAhjDe5l+H4wmkA9sWhOvLzOZ9M/HwI9UCOP+sN21Ja2FuWJAu7MylwE5acu9FGX6vpjM4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by MN0PR12MB6365.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Fri, 20 Feb
 2026 22:44:53 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Fri, 20 Feb 2026
 22:44:53 +0000
Message-ID: <427e1550-94b1-4c58-828f-1f79e5c16847@amd.com>
Date: Fri, 20 Feb 2026 16:44:47 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>,
 "Luck, Tony" <tony.luck@intel.com>, Ben Horgan <ben.horgan@arm.com>,
 "Moger, Babu" <Babu.Moger@amd.com>, "eranian@google.com" <eranian@google.com>
Cc: Drew Fustini <fustini@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <aYyxAPdTFejzsE42@e134344.arm.com>
 <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
 <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <2ab556af-095b-422b-9396-f845c6fd0342@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0312.namprd03.prod.outlook.com
 (2603:10b6:610:118::21) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|MN0PR12MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b413f25-6345-43be-23ca-08de70d1a9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|18082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnQ4OTYyWEZJQWN1UkVwTmdUdlo0VTZYR09aZmJMV1c2Ym80ZTZGTzR2WG5o?=
 =?utf-8?B?ZWRnMDdKMmxNZDZsMDlPUHo0UDVqdTFJZWtlTnBHeEk2YzU2ZCtNN1ZwSWhM?=
 =?utf-8?B?YVBEOHhUVnA3TE5seG8xc0FxcFFNUWNGZFl0RjI5UjBVb05ncTREeHFFTGNo?=
 =?utf-8?B?RkpCN1F2MkE0cW1oTmc3NHh5OGxMT2NHV3NpNVhkVVlxalpJVHIvc2lEeTgz?=
 =?utf-8?B?Qjg2b0xGVDVOZXJJY2NDazV2RVc4dk50SnRsendoaXJUQWxwU0FXM0RGTGp0?=
 =?utf-8?B?a0ZvckVMYkh5N3FldDRRL09QTFRqMmJubGpLS0dCVTZSWlZQQVhkQjU5NFRI?=
 =?utf-8?B?L3p0VHFOTDVDZjgrTy9ML3lSMEpocklMZ2JmVEdRUWFrY2g0dGQ4M0UwVjlN?=
 =?utf-8?B?cHhhd0g3YXo2Mi9Ic2lRejQ3YlB2a2lmclEyS0twcTZVUkxDSGVTQlUwY2Ft?=
 =?utf-8?B?TVVWSFplRGNETHFGeFhoYWUwYm5ROEg5SVRqSTFWcnlhcUIzQU1tRGxoZ0x1?=
 =?utf-8?B?M2tNYVpaZlYzS2pBY3dGVHNFT1lVZEV0T2xhOG1LTkJmUVU5S3VadkhQcEx5?=
 =?utf-8?B?MjNvR1pEUndPd2M5RnZzRU5vSU14ek84dEVEeVpUMmlwUk5BV1BwblFqRTky?=
 =?utf-8?B?Z0RPRjMvUXlkNDZ0WXc0bEZ4NjdGZUNjZERINHJkUVpiQTVEa3ZtdkplNGpX?=
 =?utf-8?B?STlKZTFxZU1ZcWh0UUdobkxEdDBoUUUxaVZ4SUNSeXhTdEdkNUNaNWk3VUd5?=
 =?utf-8?B?YmdSQS82aHI5c1Q2L1RTY0x4Y1RhSm9vV0tGdDRzV3p3ZlJYQWtTMGJxdGUv?=
 =?utf-8?B?cW9yTDlLTGoyVEgrN0p6R1RaYXBtaDJGdDJGcTlVTHlIZ29DL3JSanZ3WEtL?=
 =?utf-8?B?alc4SFZMdXcwL1dRZ0tuMDZKTTJHVk5LV05xN2lPZDRmWEcxOC9qSFRzRncv?=
 =?utf-8?B?REFOREZ4YzM2OXBFZDZRWnJ6NncyTitNdDhCaURVWGZicDZObE9XUU5jV1pz?=
 =?utf-8?B?US9BNCtBRzF2MUhQdlhQMU5NTFpYYy9zOEZjaTNnTVQ1WXBjM29KMHBBSHZL?=
 =?utf-8?B?RXpGMXRqK3JYSENlbGxpQnBuNy90Z2ttRG1WcTd0TSsxaWZXMjhITmxFV2Rn?=
 =?utf-8?B?RkYwK1gxbTZqVVFqT1VndVVKb3RpRkEyUlJVb0dqMkNFZGJrTEtsZjZybUlj?=
 =?utf-8?B?c0w1M0ZPRkJwYnhsQzBKem1DR3hUTTZ0TlM5STRIeTlFOEtabDB4UWRVTDNk?=
 =?utf-8?B?QjUzSklJNDZhV040YytIb1RRUXByOG9tOFBoMmk2UU9SZjhBSmdwTTNzaERR?=
 =?utf-8?B?MkVvQ1JuT2pEOVlJZkcyQTdOQ0xFUWdtRnNvUVVEWG5GNzdEMG1DbnR3OFNL?=
 =?utf-8?B?enpkZlRMSzdTbEM0dGxtbm01THNFSHdrMmJobFh3QVdBWVBtQmNNUWdoUWpX?=
 =?utf-8?B?TUxzeWdUaE1maHIwUG1XTWF5TVlQeWpBbTJsL0llRDZ4NGtYYkNIelU5UUFa?=
 =?utf-8?B?by82N2w5a0t4TWxJOUJEdWNneURFTS9TdGlqYXV0OStGanh2NWhVeGE4U1BZ?=
 =?utf-8?B?N2ZDY3hHbldsK0xHaitBWWNVSHZXVFdCZjUrVDRxUGc0eTliaThCcVppZlJo?=
 =?utf-8?B?akdVQzVkZVF0ZDZHeWVrRC84c0JsTjB6bUhMTFJuZEp0TkhDRm8wQ1NZRXgy?=
 =?utf-8?B?RStTcVV0bnVKWVkrNDY5R2lXRHYyT1I5cFdrMHNEVzAySENkajh2ZjhWMGcy?=
 =?utf-8?B?NlM1Nm1sYWQ1czArQlhpSlpYTWlnR0xMbHVPcHJ2WXhJTzJDOEQwUHpaRTlh?=
 =?utf-8?B?OCtUR2NvVFJtenIxelhyMFdoUmNqeHFnN3A4T2t1ZmxsQkx3dmFWQXVYVmlt?=
 =?utf-8?B?TkR1dG8rUGZaR3hLQXZ5NFkzS21kdFB5WUxMU045UkhwbVloSlJNWlRhd3ZV?=
 =?utf-8?B?VExBM3p1NSs2NmlKOEk1bFZGYzF6SGFQRjhlaVZYRkhZamNDeVRuMUtEWUdr?=
 =?utf-8?B?WjBUVWMwQXJzUnA4M2pXWlNSdmI2Q3IvNHBmMndSemhwTW5sQkhWNlE2UTVu?=
 =?utf-8?B?ZXpURUM2eGVONXFxUGZxUkhVMGsyY1hwbFpwTm1yVERHb0JXb3Exa2FIbW5W?=
 =?utf-8?Q?lWyFFeLOAKdojuLZWveRMsSyI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(18082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjJiQi9aelFZQm9TU05PTjJPYTJva2ZjUkRUNHNYaU1GUWZuM3RQRk5vM3gr?=
 =?utf-8?B?QUxBLzVPa3pxYnM4UXo3Ym11Q1VmMm1oZ28rSEFSWFBYWFk3dzRqa1RvaFRr?=
 =?utf-8?B?M29KMjQwb29vQXY2VHc4ZUFhYzc3QUEzZDRLU0tRMlJPOXVZWjRIKzFWU0xV?=
 =?utf-8?B?T2JiNG1hekh6MEUwYW8rNXpRYVZ5dmk4VUJGOEtsSTZNMUpBMEJhbFRkTTFK?=
 =?utf-8?B?alg4ckJzY25WWWNzK2podWxQOWR3M29wV05JNTJzSHhyUVVZT2MrVllsWDlY?=
 =?utf-8?B?bFF1TVdRdytDQmJYZzUxWU1XWFFGRDc1VWw3a0tYREllMFF0NGFLNDdjcFA3?=
 =?utf-8?B?V3dzb2Q5Tkdjb3lFQkV3bXlvdTJGRzJnVExNTllvNjk1Q3pVZ0Y2TE9DUVpU?=
 =?utf-8?B?eUswSGQzQm1aMDVsVkVlYmxqWE4xRi9sL2Z1cGZ1OFJTbGhoTGg1VUdycHNK?=
 =?utf-8?B?UGhvNThMM1NsSE1vVFpMVVEzSGlRRHhlbEFTSFZuZ3hQMGx2KzhFNU9ycTkr?=
 =?utf-8?B?Vm5TMmNSb3YvOUNSek13R2F3NjBkUW1aMjMxOVpibW5tcE5tcWxyd3dPaS9I?=
 =?utf-8?B?eHBvdjNiKzgrR3ZjNG5LKzB0WlUraTBGNitQZGgzenJtaW9nTTlxYlJ1SERv?=
 =?utf-8?B?QWtPMWhCdGNuU0tIbDJNQVRJUCs5Z1RpU0tWWC9iazdDNHNkUE5jMmJBQ1Fa?=
 =?utf-8?B?VlVVWldUZU54Y3VodGZualpFOW1XaUJXOHpwSk9IRUpVaVNMY2gvVXkzRXdM?=
 =?utf-8?B?UXF0aDEreHY1UzFtOGp6K3V4QnlaQ0cyREZGWThhR2wyTjFML0tJVlNqdC9W?=
 =?utf-8?B?YXEyWkl3MGRsR2lVRkVQWEFZaUJ5dFh1OVhRWTAwc245cmhTSC9vRDB6aGhO?=
 =?utf-8?B?UDdEaHNYZmtNZ1dvZ2VObWNCVGlKYWd5VWxrQk9DNVppUlk4dEQ4VXZUVlAr?=
 =?utf-8?B?dEdGM3RNNnQzSDBKRlgyUjd4L0srMTZkb1FtYW0xV0pTdUJnNlpYbmdFNm45?=
 =?utf-8?B?OS9MSjhDSElHeHhtN1VDOGpEZzQrMVNiQlVhTHd5NG5qZ0FKYVhUQXNNdXJC?=
 =?utf-8?B?V2VuSEE5OUJPUVJkekdmWUM5UmE1VmVjbkVFT0lCVGI3TG5wWlZXN2xaMXo3?=
 =?utf-8?B?R0FRVDBsY0w5WjBZN3JsWEtiektQdmloTHBHTVN2c2RKbWhraFl5TlRyeVA1?=
 =?utf-8?B?VTVPd1JxL1lSbmdaWHlZOUZOYlNwYzdYWmUrYlM5VE9jK0tmdkxucWRRMm5O?=
 =?utf-8?B?QXhpc1NDQWNJQWFkaDgzWHdDTHdNa1hvbHhFUUIrKzV4b3oreTExZG9vU1Yr?=
 =?utf-8?B?QUY5dkZVY2UvSWM4MHl6MmZHYm1yTmF4VzAyVHRRVlRmNEIxVFBpMkpoUFZa?=
 =?utf-8?B?QnVDV3lhRHkvNU8zM3gwMGYxcllVWjRVNmwxUGRjampKUGwzK0dIU093ajR4?=
 =?utf-8?B?MUxIOEZuY0NveThPeTA2M05WQk9FV1pwaXBESVN1MkpTNHdMcnlETFlsb3Jn?=
 =?utf-8?B?MnVZQXlCTzM5OHFsdFl5NWlFRVMvdWNjbTBXRVVpYlpTc2VMRUxmbTBpdmNG?=
 =?utf-8?B?M0xCTjlVbnBlVkIwNzk4TXk4aVU3OHNUbHgyUHRwaFk1YmREY2xLajYwWGZU?=
 =?utf-8?B?NEdycnprNUFlWmhhckFMZVR1cDhUQWtkcGlkeXN1ODc5NHhLcCtKYjJIMS9N?=
 =?utf-8?B?N0pqY081QlhXaGlQeGNsei95RVpCeXk3Q2tpTy9sNEVEWFR3L2MveGdVeUNF?=
 =?utf-8?B?cFpia2FTTDI3L0x2elRjayt6eFNTczJYdHBNbTUydHFoUUhzWTUvZE0zMk1T?=
 =?utf-8?B?SFZrNkVZT0t2Ymd3Y2EwRUhBWWRySXBxZ1RrQnhhT0t0RzU2TTZ5MXhlOHlV?=
 =?utf-8?B?eWhqcTNnUksycThQZWdiaEhJejEyQ0FOQ01hSHZIeGtuMzg3aXNkVTNkSUZr?=
 =?utf-8?B?QW9Ma1J0cFNjSUF3dGNvcHJlTW9WWlM3WmtJb2d5dTNRdFpIVVNlb1VIMlo5?=
 =?utf-8?B?VXltOVJaZ25EMXJmK2RoNTNXK3F4Sms2N21BQ0hpdDJxVllvbzkrR3AxYU9k?=
 =?utf-8?B?OUdNTWdSYjU5c29jbW5URlVyTE54MldOWkxzUnpIR1FSNUdSSGZldXgrK2h1?=
 =?utf-8?B?bTljMkJjTTBwL2ZZYzQyQkFzOXY5YStta0ZvTW5ZTXFkTGxNTEZpQ2xQWlFX?=
 =?utf-8?B?OGowVmE0UUJqekwvb2Nnd2M3U0xSdlBtVlZTcjJkWkh1UnZpVzQ1NU9lcnF4?=
 =?utf-8?B?bVYwaW5jMmszMWMzMk5Lbm4rUW9EbDZ0UEVFVjQySFlWRVlTWmRMMkY4SVlU?=
 =?utf-8?Q?cURPNuN1fyu2M8CrZC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b413f25-6345-43be-23ca-08de70d1a9db
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 22:44:53.6480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSCOygvURTvv304saAbZlfdtmHJ6LDK+xm5CWPS3aJF1I5pzXRZwocESePyW2L9z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6365
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71426-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BAFFA16B4A5
X-Rspamd-Action: no action

Hi Reinette,

Thanks for the detailed summary and proposal.

On 2/19/2026 8:53 PM, Reinette Chatre wrote:
> Hi Tony, Ben, Babu, and Stephane,
> 
> On 2/18/26 8:44 AM, Luck, Tony wrote:
>> On Tue, Feb 17, 2026 at 03:55:44PM -0800, Reinette Chatre wrote:
>>> Hi Tony,
>>>
>>> On 2/17/26 2:52 PM, Luck, Tony wrote:
>>>> On Tue, Feb 17, 2026 at 02:37:49PM -0800, Reinette Chatre wrote:
>>>>> Hi Tony,
>>>>>
>>>>> On 2/17/26 1:44 PM, Luck, Tony wrote:
>>>>>>>>>> I'm not sure if this would happen in the real world or not.
>>>>>>>>>
>>>>>>>>> Ack. I would like to echo Tony's request for feedback from resctrl users
>>>>>>>>>   https://lore.kernel.org/lkml/aYzcpuG0PfUaTdqt@agluck-desk3/
>>>>>>>>
>>>>>>>> Indeed. This is all getting a bit complicated.
>>>>>>>>
>>>>>>>
>>>>>>> ack
>>>>>>
>>>>>> We have several proposals so far:
>>>>>>
>>>>>> 1) Ben's suggestion to use the default group (either with a Babu-style
>>>>>> "plza" file just in that group, or a configuration file under "info/").
>>>>>>
>>>>>> This is easily the simplest for implementation, but has no flexibility.
>>>>>> Also requires users to move all the non-critical workloads out to other
>>>>>> CTRL_MON groups. Doesn't steal a CLOSID/RMID.
>>>>>>
>>>>>> 2) My thoughts are for a separate group that is only used to configure
>>>>>> the schemata. This does allocate a dedicated CLOSID/RMID pair. Those
>>>>>> are used for all tasks when in kernel mode.
>>>>>>
>>>>>> No context switch overhead. Has some flexibility.
>>>>>>
>>>>>> 3) Babu's RFC patch. Designates an existing CTRL_MON group as the one
>>>>>> that defines kernel CLOSID/RMID. Tasks and CPUs can be assigned to this
>>>>>> group in addition to belonging to another group than defines schemata
>>>>>> resources when running in non-kernel mode.
>>>>>> Tasks aren't required to be in the kernel group, in which case they
>>>>>> keep the same CLOSID in both user and kernel mode. When used in this
>>>>>> way there will be context switch overhead when changing between tasks
>>>>>> with different kernel CLOSID/RMID.
>>>>>>
>>>>>> 4) Even more complex scenarios with more than one user configurable
>>>>>> kernel group to give more options on resources available in the kernel.
>>>>>>
>>>>>>
>>>>>> I had a quick pass as coding my option "2". My UI to designate the
>>>>>> group to use for kernel mode is to reserve the name "kernel_group"
>>>>>> when making CTRL_MON groups. Some tweaks to avoid creating the
>>>>>> "tasks", "cpus", and "cpus_list" files (which might be done more
>>>>>> elegantly), and "mon_groups" directory in this group.
>>>>>
>>>>> Should the decision of whether context switch overhead is acceptable
>>>>> not be left up to the user?
>>>>
>>>> When someone comes up with a convincing use case to support one set of
>>>> kernel resources when interrupting task A, and a different set of
>>>> resources when interrupting task B, we should certainly listen.
>>>
>>> Absolutely. Someone can come up with such use case at any time tough. This
>>> could be, and as has happened with some other resctrl interfaces, likely will be
>>> after this feature has been supported for a few kernel versions. What timeline
>>> should we give which users to share their use cases with us? Even if we do hear
>>> from some users will that guarantee that no such use case will arise in the
>>> future? Such predictions of usage are difficult for me and I thus find it simpler
>>> to think of flexible ways to enable the features that we know the hardware supports.
>>>
>>> This does not mean that a full featured solution needs to be implemented from day 1.
>>> If folks believe there are "no valid use cases" today resctrl still needs to prepare for
>>> how it can grow to support full hardware capability and hardware designs in the
>>> future.
>>>
>>> Also, please also consider not just resources for kernel work but also monitoring for
>>> kernel work. I do think, for example, a reasonable use case may be to determine
>>> how much memory bandwidth the kernel uses on behalf of certain tasks.
>>>   
>>>>> I assume that, just like what is currently done for x86's MSR_IA32_PQR_ASSOC,
>>>>> the needed registers will only be updated if there is a new CLOSID/RMID needed
>>>>> for kernel space.
>>>>
>>>> Babu's RFC does this.
>>>
>>> Right.
>>>
>>>>
>>>>>                    Are you suggesting that just this checking itself is too
>>>>> expensive to justify giving user space more flexibility by fully enabling what
>>>>> the hardware supports? If resctrl does draw such a line to not enable what
>>>>> hardware supports it should be well justified.
>>>>
>>>> The check is likley light weight (as long as the variables to be
>>>> compared reside in the same cache lines as the exisitng CLOSID
>>>> and RMID checks). So if there is a use case for different resources
>>>> when in kernel mode, then taking this path will be fine.
>>>
>>> Why limit this to knowing about a use case? As I understand this feature can be
>>> supported in a flexible way without introducing additional context switch overhead
>>> if the user prefers to use just one allocation for all kernel work. By being
>>> configurable and allowing resctrl to support more use cases in the future resctrl
>>> does not paint itself into a corner. This allows resctrl to grow support so that
>>> the user can use all capabilities of the hardware with understanding that it will
>>> increase context switch time.
>>>
>>> Reinette
>>
>> How about this idea for extensibility.
>>
>> Rename Babu's "plza" file to "plza_mode". Instead of just being an
>> on/off switch, it may accept multiple possible requests.
>>
>> Humorous version:
>>
>> # echo "babu" > plza_mode
>>
>> This results in behavior of Babu's RFC. The CLOSID and RMID assigned to
>> the CTRL_MON group are used when in kernel mode, but only for tasks that
>> have their task-id written to the "tasks" file or for tasks in the
>> default group in the "cpus" or "cpus_list" files are used to assign
>> CPUs to this group.
>>
>> # echo "tony" > plza_mode
>>
>> All tasks run with the CLOSID/RMID for this group. The "tasks", "cpus" and
>> "cpus_list" files and the "mon_groups" directory are removed.
>>
>> # echo "ben" > plza_mode"
>>
>> Only usable in the top-level default CTRL_MON directory. CLOSID=0/RMID=0
>> are used for all tasks in kernel mode.
>>
>> # echo "stephane" > plza_mode
>>
>> The RMID for this group is freed. All tasks run in kernel mode with the
>> CLOSID for this group, but use same RMID for both user and kernel.
>> In addition to files removed in "tony" mode, the mon_data directory is
>> removed.
>>
>> # echo "some-future-name" > plza_mode
>>
>> Somebody has a new use case. Resctrl can be extended by allowing some
>> new mode.
>>
>>
>> Likely real implementation:
>>
>> Sub-components of each of the ideas above are encoded as a bitmask that
>> is written to plza_mode. There is a file in the info/ directory listing
>> which bits are supported on the current system (e.g. the "keep the same
>> RMID" mode may be impractical on ARM, so it would not be listed as an
>> option.)
> 
> I like the idea of a global file that indicates what is supported on the
> system. I find this to match Ben's proposal of a "kernel_mode" file in
> info/ that looks to be a good foundation to build on. Ben also reiterated support
> for this in
> https://lore.kernel.org/lkml/feaa16a5-765c-4c24-9e0b-c1f4ef87a66f@arm.com/
> 
> As I mentioned in https://lore.kernel.org/lkml/5c19536b-aca0-42ce-a9d5-211fbbdbb485@intel.com/
> the suggestions surrounding the per-resource group "plza_mode" file
> are unexpected since they ignore earlier comments about impact on user space.
> Specifically, this proposal does not address:
> https://lore.kernel.org/lkml/aY3bvKeOcZ9yG686@e134344.arm.com/
> https://lore.kernel.org/lkml/c779ce82-4d8a-4943-b7ec-643e5a345d6c@arm.com/
> 
> Below I aim to summarize the discussions as they relate to constraints and
> requirements. I intended to capture all that has been mentioned in these
> discussions so far so if I did miss something it was not intentional and
> please point this out to help make this summary complete.
> 
> I hope by starting with this we can start with at least agreeing what
> resctrl needs to support and how user space could interact with resctrl
> to meet requirements.
> 
> After the summary of what resctrl needs to support I aim to combine
> capabilities from the various proposals to meet the constraints and
> requirements as I understand them so far. This aims to build on all that
> has been shared until now.
> 
> Any comments are appreciated.
> 
> Summary of considerations surrounding CLOSID/RMID (PARTID/PMG) assignment for kernel work
> =========================================================================================
> 
> - PLZA currently only supports global assignment (only PLZA_EN of
>    MSR_IA32_PQR_PLZA_ASSOC may differ on logical processors). Even so, current
>    speculation is that RMID_EN=0 implies that user space RMID is used to monitor
>    kernel work that could appear to user as "kernel mode" supporting multiple RMIDs.
>    https://lore.kernel.org/lkml/abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com/

Yes. RMID_EN=0 means dont use separate RMID for plza.

> 
> - MPAM can set unique PARTID and PMG on every logical processor.
>    https://lore.kernel.org/lkml/fd7e0779-7e29-461d-adb6-0568a81ec59e@arm.com/
> 
> - While current PLZA only supports global assignment it may in future generations
>    not require MSR_IA32_PQR_PLZA_ASSOC to be same on logical processors. resctrl
>    thus needs to be flexible here.
>    https://lore.kernel.org/lkml/fa45088b-1aea-468e-8253-3238e91f76c7@amd.com/
> 

Good point.

> - No equivalent feature on RISC-V.
>    https://lore.kernel.org/lkml/aYvP98xGoKPrDBCE@gen8/
> 
> - Impact on context switch delay is a concern and unnecessary context switch delay should
>    be avoided.
>    https://lore.kernel.org/lkml/aZThTzdxVcBkLD7P@agluck-desk3/
>    https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
> 
> - There is no requirement that a CLOSID/PARTID should be dedicated to kernel work.
>    Specifically, same CLOSID/PARTID can be used for user space and kernel work.
>    Also directly requested to not make kernel work CLOSID/PARTID exclusive:
>    https://lore.kernel.org/lkml/c8268b2a-50d7-44b4-ac3f-5ce6624599b1@arm.com/
> 
> - Only use case presented so far is related to memory bandwidth allocation where
>    all kernel work is done unthrottled or equivalent to highest priority tasks while
>    monitoring remains associated to task self.
>    https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>    PLZA can support this with its global allocation (assuming RMID_EN=0 associates user
>    RMID with kernel work) To support this use case MPAM would need to be able to
>    change both PARTID and PMG:
>    https://lore.kernel.org/lkml/845587f3-4c27-46d9-83f8-6b38ccc54183@arm.com/
> 
> - Motivation of this work is to run kernel work with more/all/unthrottled
>    resources to avoid priority inversions. We need to be careful with such
>    generalization since not all resource allocations are alike yet a CLOSID/PARTID
>    assignment applies to all resources. For example, user may designate a cache
>    portion for high priority user space work and then needs to choose which cache
>    portions the kernel may allocate into.
>    https://lore.kernel.org/lkml/6293c484-ee54-46a2-b11c-e1e3c736e578@arm.com/
>    - If all kernel work is done using the same allocation/CLOSID/PARTID then user
>      needs to decide whether the kernel work's cache allocation overlaps the high
>      priority tasks or not. To avoid evicting high priority task work it may be
>      simplest for kernel allocation to not overlap high priority work but kernel work
>      done on behalf of high priority work would then risk eviction by low priority
>      work.
>    - When considering cache allocation it seems more flexible to have high priority
>      work keep its cache allocation when entering the kernel? This implies more than
>      one CLOSID/PARTID may need to be used for kernel work.
> 
> 
> TBD
> ===
> - What is impact of different controls (for example the upcoming MAX) when tasks are
>    spread across multiple control groups?
>    https://lore.kernel.org/lkml/aY3bvKeOcZ9yG686@e134344.arm.com/
> 
> How can MPAM support the "monitor kernel work with user space work" use case?
> =============================================================================
> This considers how MPAM could support the use case presented in:
> https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
> 
> To support this use case in MPAM the control group that dictates the allocations
> used in kernel work has to have monitor group(s) where this usage is tracked and user
> space would need to sum the kernel and user space usage. The number of PMG may vary
> and resctrl cannot assume that the kernel control group would have sufficient monitor
> groups to map 1:1 with user space control and monitor groups. Mapping user space
> control and monitor groups to kernel monitor groups thus seems best to be done by
> user space.
> 
> Some examples:
> Consider allocation and monitoring setup for user space work:
> 	/sys/fs/resctrl <= User space default allocations
> 	/sys/fs/resctrl/g1 <= User space allocations g1
> 	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
> 	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
> 	/sys/fs/resctrl/g2 <= User space allocations g2
> 	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
> 	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
> 
> Having a single control group for kernel work and a system that supports
> 7 PMG per PARTID makes it possible to have a monitoring group for each user space
> monitoring group:
> (will go more into how such assignments can be made later)
> 
> 	/sys/fs/resctrl/kernel <= Kernel space allocations
> 	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring default group
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g1   <= Kernel space monitoring group g1
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g1m1 <= Kernel space monitoring group g1m1
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g1m2 <= Kernel space monitoring group g1m2
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring group g2
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2m1 <= Kernel space monitoring group g2m1
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2m2 <= Kernel space monitoring group g2m2
> 
> With a configuration as above user space can sum the monitoring events of the user space
> groups and associated kernel space groups to obtain counts of all work done on behalf of
> associated tasks.
> 
> It may not be possible to have such 1:1 relationship and user space would have to
> arrange groups to match its usage. For example if system only supports two PMG per PARTID
> then user space may find it best to track monitoring as below:
> 	/sys/fs/resctrl/kernel <= Kernel space allocations
> 	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
> 
> 
> Requirements
> ============
> Based on understanding of what PLZA and MPAM is (and could be) capable of while considering the
> use case presented thus far it seems that resctrl has to:
> - support global assignment of resource group for kernel work
> - support per-resource group assignment for kernel work
> 

Yes. That is correct.


> How can resctrl support the requirements?
> =========================================
> 
> New global resctrl fs files
> ===========================
> info/kernel_mode (always visible)
> info/kernel_mode_assignment (visibility and content depends on active setting in info/kernel_mode)

Probably good idea to drop "assign" for this work. We already have 
mbm_assign mode and related work.

info/kernel_mode_assoc or info/kernel_mode_association? Or We can wait 
later to rename appropriately.

> 
> info/kernel_mode
> ================
> - Displays the currently active as well as possible features available to user
>    space.
> - Single place where user can query "kernel mode" behavior and capabilities of the
>    system.
> - Some possible values:
>    - inherit_ctrl_and_mon <=== previously named "match_user", just renamed for consistency with other names
>       When active, kernel and user space use the same CLOSID/RMID. The current status
>       quo for x86.
>    - global_assign_ctrl_inherit_mon
>       When active, CLOSID/control group can be assigned for *all* (hence, "global")
>       kernel work while all kernel work uses same RMID as user space.
>       Can only be supported on architecture where CLOSID and RMID are independent.
>       An arch may support this in hardware (RMID_EN=0?) or this can be done by resctrl during
>       context switch if the RMID is independent and the context switches cost is
>       considered "reasonable".
>       This supports use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>       for PLZA.
>    - global_assign_ctrl_assign_mon
>       When active the same resource group (CLOSID and RMID) can be assigned to
>       *all* kernel work. This could be any group, including the default group.
>       There may not be a use case for this but it could be useful as an intemediate
>       step of the mode that follow (more later).
>    - per_group_assign_ctrl_assign_mon
>       When active every resource group can be associated with another (or the same)
>       resource group. This association maps the resource group for user space work
>       to resource group for kernel work. This is similar to the "kernel_group" idea
>       presented in:
>       https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>       This addresses use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>       for MPAM.

All these new names and related information will go in global structure.

Something like this..

Struct kern_mode {
        enum assoc_mode;
        struct rdtgroup *k_rdtgrp;
        ...
};

Not sure what other information will be required here. Will know once I 
stared working on it.

This structure will be updated based on user echo's in "kernel_mode" and 
"kernel_mode_assignment".


> - Additional values can be added as new requirements arise, for example "per_task"
>    assignment. Connecting visibility of info/kernel_mode_assignment to mode in
>    info/kernel_mode enables resctrl to later support additional modes that may require
>    different configuration files, potentially per-resource group like the "tasks_kernel"
>    (or perhaps rather "kernel_mode_tasks" to have consistent prefix for this feature)
>    and "cpus_kernel" ("kernel_mode_cpus"?) discussed in these threads.

So, per resource group file "kernel_mode_tasks" and "kernel_mode_cpus" 
are not required right now. Correct?


>    
> User can view active and supported modes:
> 
> 	# cat info/kernel_mode
> 	[inherit_ctrl_and_mon]
> 	global_assign_ctrl_inherit_mon
> 	global_assign_ctrl_assign_mon
> 
> User can switch modes:
> 	# echo global_assign_ctrl_inherit_mon > kernel_mode
> 	# cat kernel_mode
> 	inherit_ctrl_and_mon
> 	[global_assign_ctrl_inherit_mon]
> 	global_assign_ctrl_assign_mon
> 
> 
> info/kernel_mode_assignment
> ===========================
> - Visibility depends on active mode in info/kernel_mode.
> - Content depends on active mode in info/kernel_mode
> - Syntax to identify resource groups can use the syntax created as part of earlier ABMC work
>    that supports default group https://lore.kernel.org/lkml/cover.1737577229.git.babu.moger@amd.com/
> - Default CTRL_MON group and if relevant, the default MON group, can be the default
>    assignment when user just changes the kernel_mode without setting the assignment.
> 
> info/kernel_mode_assignment when mode is global_assign_ctrl_inherit_mon
> -----------------------------------------------------------------------
> - info/kernel_mode_assignment contains single value that is the name of the control group
>    used for all kernel work.
> - CLOSID/PARTID used for kernel work is determined from the control group assigned
> - default value is default CTRL_MON group
> - no monitor group assignment, kernel work inherits user space RMID
> - syntax is
>      <CTRL_MON group> with "/" meaning default.
> 
> info/kernel_mode_assignment when mode is global_assign_ctrl_assign_mon
> -----------------------------------------------------------------------
> - info/kernel_mode_assignment contains single value that is the name of the resource group
>    used for all kernel work.
> - Combined CLOSID/RMID or combined PARTID/PMG is set globally to be associated with all
>    kernel work.
> - default value is default CTRL_MON group
> - syntax is
>      <CTRL_MON group>/MON group>/ with "//" meaning default control and default monitoring group.
> 
> info/kernel_mode_assignment when mode is per_group_assign_ctrl_assign_mon
> -------------------------------------------------------------------------
> - this presents the information proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>    within a single file for convenience and potential optimization when user space needs to make changes.
>    Interface proposed in https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/ is also an option
>    and as an alternative a per-resource group "kernel_group" can be made visible when user space enables
>    this mode.
> - info/kernel_mode_assignment contains a mapping of every resource group to another resource group:
>    <resource group for user space work>:<resource group for kernel work>
> - all resource groups must be present in first field of this file
> - Even though this is a "per group" setting expectation is that this will set the
>    kernel work CLOSID/RMID for every task. This implies that writing to this file would need
>    to access the tasklist_lock that, when taking for too long, may impact other parts of system.
>    See https://lore.kernel.org/lkml/CALPaoCh0SbG1+VbbgcxjubE7Cc2Pb6QqhG3NH6X=WwsNfqNjtA@mail.gmail.com/

This mode is currently not supported in AMD PLZA implementation. But we 
have to keep the options open for future enhancement for MPAM. I am 
still learning on MPM requirement.

> 
> Scenarios supported
> ===================
> 
> Default
> -------
> For x86 I understand kernel work and user work to be done with same CLOSID/RMID which
> implies that info/kernel_mode can always be visible and at least display:
> 	# cat info/kernel_mode
> 	[inherit_ctrl_and_mon]
> 
> info/kernel_mode_assignment is not visible in this mode.
> 
> I understand MPAM may have different defaults here so would like to understand better.
> 
> Dedicated global allocations for kernel work, monitoring same for user space and kernel (PLZA)
> ----------------------------------------------------------------------------------------------
> Possible scenario with PLZA, not MPAM (see later):
> 1. Create group(s) to manage allocations associated with user space work
>     and assign tasks/CPUs to these groups.
> 2. Create group to manage allocations associated with all kernel work.
>     - For example,
> 	# mkdir /sys/fs/resctrl/unthrottled
>     - No constraints from resctrl fs on interactions with files in this group. From resctrl
>       fs perspective it is not "dedicated" to kernel work but just another resource group.

That is correct. We dont need to handle the group special for 
kernel_mode while creating the group. However, there will some handling 
required when kernel_mode group is deleted. We need to move the 
tasks/cpus back to default group and update the global kernel_mode 
structure.


>       User space can still assign tasks/CPUs to this group that will result in this group
>       to be used for both kernel and user space control and monitoring. If user space wants
>       to dedicate a group to kernel work then they should not assign tasks/CPUs to it.
> 3. Set kernel mode to global_assign_ctrl_inherit_mon:
> 	# echo global_assign_ctrl_inherit_mon > info/kernel_mode
>    - info/kernel_mode_assignment becomes visible and contains "/"  to indicate that default
>      resource group is used for all kernel work
>    - Sets the "global" CLOSID to be used for kernel work to 0, no setting of global RMID.
> 4. Set control group to be used for all kernel work:
> 	# echo unthrottled > info/kernel_mode_assignment
>      - Sets the "global" CLOSID to be used for kernel work to CLOSID associated with
>        CTRL_MON group named "unthrottled", no change to global RMID.
> 

Ok. Sounds good.


> 
> Dedicated global allocations and monitoring for kernel work
> -----------------------------------------------------------
> - Step 1 and 2 could be the same as above.
> OR
> 2b. If there is an "unthrottled" control group that is used for both user space and kernel
>      allocations a separate MON group can be used to track monitoring data for kernel work.
>     - For example,
> 	# mkdir /sys/fs/resctrl/unthrottled <=== All high priority work, kernel and user space
> 	# mkdir /sys/fs/resctrl/unthrottled/mon_groups/kernel_unthrottled <= Just monitor kernel work
> 
> 3. Set kernel mode to global_assign_ctrl_assign_mon:
> 	# echo global_assign_ctrl_assign_mon > info/kernel_mode
>    - info/kernel_mode_assignment becomes visible and contains "//" - default CTRL_MON is
>      used for all kernel work allocations and monitoring
>    - Sets both the "global" CLOSID and RMID to be used for kernel work to 0.
> 4. Set control group to be used for all kernel work:
> 	# echo unthrottled/kernel_unthrottled > info/kernel_mode_assignment
>      - Sets the "global" CLOSID to be used for kernel work to CLOSID associated with
>        CTRL_MON group named "unthrottled" and RMID used for kernel work to RMID
>        associated with child MON group within "unthrottled" group named "kernel_untrottled".
> 

ok. Sounds good.

> Dedicated global allocations for kernel work, monitoring same for user space and kernel (MPAM)
> ----------------------------------------------------------------------------------------------
> 1. User space creates resource and monitoring groups for user tasks:
>   	/sys/fs/resctrl <= User space default allocations
> 	/sys/fs/resctrl/g1 <= User space allocations g1
> 	/sys/fs/resctrl/g1/mon_groups/g1m1 <= User space monitoring group g1m1
> 	/sys/fs/resctrl/g1/mon_groups/g1m2 <= User space monitoring group g1m2
> 	/sys/fs/resctrl/g2 <= User space allocations g2
> 	/sys/fs/resctrl/g2/mon_groups/g2m1 <= User space monitoring group g2m1
> 	/sys/fs/resctrl/g2/mon_groups/g2m2 <= User space monitoring group g2m2
> 
> 2. User space creates resource and monitoring groups for kernel work (system has two PMG):
> 	/sys/fs/resctrl/kernel <= Kernel space allocations
> 	/sys/fs/resctrl/kernel/mon_data               <= Kernel space monitoring for all of default and g1
> 	/sys/fs/resctrl/kernel/mon_groups/kernel_g2   <= Kernel space monitoring for all of g2
> 3. Set kernel mode to per_group_assign_ctrl_assign_mon:
> 	# echo per_group_assign_ctrl_assign_mon > info/kernel_mode
>     - info/kernel_mode_assignment becomes visible and contains
> 	# cat info/kernel_mode_assignment
> 	//://
> 	g1//://
> 	g1/g1m1/://
> 	g1/g1m2/://
> 	g2//://
> 	g2/g2m1/://
> 	g2/g2m2/://
>     - An optimization here may be to have the change to per_group_assign_ctrl_assign_mon mode be implemented
>       similar to the change to global_assign_ctrl_assign_mon that initializes a global default. This can
>       avoid keeping tasklist_lock for a long time to set all tasks' kernel CLOSID/RMID to default just for
>       user space to likely change it.
> 4. Set groups to be used for kernel work:
> 	# echo '//:kernel//\ng1//:kernel//\ng1/g1m1/:kernel//\ng1/g1m2/:kernel//\ng2//:kernel/kernel_g2/\ng2/g2m1/:kernel/kernel_g2/\ng2/g2m2/:kernel/kernel_g2/\n' > info/kernel_mode_assignment
> 

Currently, this is not supported in AMD's PLZA implimentation. But we 
need to keep this option open for MPAM.

> The interfaces proposed aim to maintain compatibility with existing user space tools while
> adding support for all requirements expressed thus far in an efficient way. For an existing
> user space tool there is no change in meaning of any existing file and no existing known
> resource group files are made to disappear. There is a global configuration that lets user space
> manage allocations without needing to check and configure each control group, even per-resource
> group allocations can be managed from user space with a single read/write to support
> making changes in most efficient way.
> 
> What do you think?
> 

I will start planning this work. Feel free to add more details.
I Will have more questions as I start working on it.

I will separate GMBA work from this work.

Will send both series separately.

Thanks for details and summary.

Thanks

Babu


