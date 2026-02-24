Return-Path: <kvm+bounces-71665-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oOJFACn+nWkETAQAu9opvQ
	(envelope-from <kvm+bounces-71665-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:38:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3DF18C240
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 20:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5117E30F52C1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9FD430F95C;
	Tue, 24 Feb 2026 19:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EjzDJwPD"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011045.outbound.protection.outlook.com [40.107.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5030EF74;
	Tue, 24 Feb 2026 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771961870; cv=fail; b=IJopNauzoj6qZHaDz+pzb9aYc9JdqgTEZuQEBKmlACQGcA+Ec01/wXCb7Ff8DP1Co7FeYx9KB6WG2l3Ddlz8T2lu4Hwpu+LZ6JbQia5288z0UhExsyll4FeGwevES5OjlETLBMA6gP3QdcJiRsRRa2/bQ6tqgXGtJYWRqb1hkAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771961870; c=relaxed/simple;
	bh=6FYagFU+o1pB9ZDrmVW3qqXnKOcAWj2BE5DKeiEf3cA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u8CTOwW2Pn8kpX2n8uJIS0h7VYfNmDL68C+Sp0Zd6x7T8EYxGMNB06TatPgO9J5MnoyOh89AdrqdOxhJCpdmoZOGpNNzJ137NqULjXBzjMzN5qRRib+AXnK2KnI/EWuYIM3M6EWuhF68NT/8HzqtcEIUKnShs5JwIZrflVUbsq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EjzDJwPD; arc=fail smtp.client-ip=40.107.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CCO/Yfzxe5nvHMwL8ZThXg6j3inQ3oCTXtQN/XbUvpSeEQ6JGqNiYeqRbM6Ccm/l+/WdEibuUCcUEVSwfNRzQ81vMFlSSRmGQPlVU+VxOpm4jbRgrkm3X7LSx1R7h8YkdXJ87N41etV3uoCt6qhRCA4HxQa5u3JgHqT4nmA5xPAl79dl7nLOWQYyFC/oB6bem0KP6TltUg6EEc1rJRcW4jyFoVwYfhfSGFDt08/qX+Y7FMfjfcEn+2cM3B+b9e1F9R4RfuEJmtbYq3RcYNGT72BA45HbRLeLoUT6dIkvaNXTVjg2alPnn8xAllrdovR/bq1im1HJyoJ2RLM+fZvKEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qhXQ4Xg50AGAmfAgC4penrkuo24l3aZPh83jTMmxVCk=;
 b=cw70/9yQMKUBmmNA4H26UJtYHnDGnu4XDXANsxuaONDYZRj8aiMBYce88wkojZar3XmYXzuErRChOTHROl6c4zZQlJBQkTc3V48WhqMoR6fSHY+ng+3BFyugNgqFttfFP5Cp4U9T1AQwsTrGWTSTmOPVavJ7+7YNNfoMG5EHk5t0St4+34M3s1Z8aEQ3tQk8RJYR3KucBSZbHpcQGsrV2qCmmaCKJL/6YFV4RW3HZwcWAhGv3+gGlitqqbzVGJX4v4wlXLNw38ygb/7au2EHyDA4BGLsAEuk2y3rnI/EQ/Eyp3Rt4YOwD+c2KB3IyncYJw63cQm7rjLuXuOZHpZIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhXQ4Xg50AGAmfAgC4penrkuo24l3aZPh83jTMmxVCk=;
 b=EjzDJwPDZxXD4P4vNjrtUoUqokyK+ZezlYLgimupcM3F1JOLW6iHNI9W0s0Eo0aBcyiG2j+8KADOLIyed33E/tv345rMkldJNHmFyaLFWJGgnzXjqWrUpoc+n4Q6esCnM4MzZkuCUFRAFLitGX3YOKjQPQFWZ2q5/D6xs0lYJco=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DS0PR12MB8342.namprd12.prod.outlook.com
 (2603:10b6:8:f9::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 19:37:41 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::e192:692b:abba:8c88]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::e192:692b:abba:8c88%3]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 19:37:41 +0000
Message-ID: <bcd577f7-89e7-4e53-8462-8038386af3f3@amd.com>
Date: Tue, 24 Feb 2026 13:37:37 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <bmoger@amd.com>, "Luck, Tony" <tony.luck@intel.com>,
 Ben Horgan <ben.horgan@arm.com>, "eranian@google.com" <eranian@google.com>
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
 <427e1550-94b1-4c58-828f-1f79e5c16847@amd.com>
 <37bc4dc5-c908-42cd-83c5-a0476fc9ec82@intel.com>
 <53be07ff-75c6-4bd6-a544-e28454b4f6b3@amd.com>
 <0645bba3-6121-41d4-b627-323faf1089b7@intel.com>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <0645bba3-6121-41d4-b627-323faf1089b7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0218.namprd04.prod.outlook.com
 (2603:10b6:806:127::13) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DS0PR12MB8342:EE_
X-MS-Office365-Filtering-Correlation-Id: e60d2b15-9ca3-4c33-6bc2-08de73dc2cb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M3BHWVExK2NFRVo3cmpGMkI2VEM3RkEwNHBUamJQMUxIVmYzNUpGVkJqYUkv?=
 =?utf-8?B?Uy95V1VaVmsyZG0wZmVHY3kxQmlDZVJQYmdBR2VMbHhQMFVab0FXcGNyUE02?=
 =?utf-8?B?OHZTSzNEMjlCajVpVGVZcG5GWEVHRkttdnJCZnFiYm1DaERFb2hQWmliWjdv?=
 =?utf-8?B?anNEY05EQWdsOXlQNlRIUHp1WUhTd0djTFNMNTFla1hwMGdyUVVLZ0x6K1Jt?=
 =?utf-8?B?SmpEeUtLcGltZjhzeDRmYmxPdmNQaFlMMTVsTU5GdVdLbGRLcmhXU3J3akRr?=
 =?utf-8?B?RnhXZEl3VE1udWdTbjhhSEg2WDJodGdLS1k3NEoyc0JMOExSUElQNE1EU0VP?=
 =?utf-8?B?eVZxYVdST0NYeEEwakU0YXFpdU5hRHpwRFhZTUZzWFBNRVdUNzF1cmgvU0hD?=
 =?utf-8?B?Y29JU24xSm01dlhsZWtEZGdRbUwrWWh3UUZJREk1T0dPQUlvSFhKNUFaZzIx?=
 =?utf-8?B?SnhKMUxNbmFtbmVaOU5NUmVRSlQrdXFNWDEvUzNoL1J5OVZPakhwVGx1TnIx?=
 =?utf-8?B?aXBodTUraGk2a2gzZGFFWXoram1zeWFaUUJzSldxRTBULzlPNk5iNE5zbXEy?=
 =?utf-8?B?YXhmRUdpaXFMUGhTdjY2aUpQOCtidnBkaU9GdlFDZzRRUElmVmtiV3FDZXdM?=
 =?utf-8?B?TXlkV0pqbzhIU2hqUFpVakc4UFdXR0FkOWdUekFkc1VkRXV4SG9jMlA1VlVL?=
 =?utf-8?B?Wmt3VG5VbjNSckFhNGpQVDViaE5sN0FtUUk1OEZYNWxCUGpqRmxucVRucWho?=
 =?utf-8?B?VW5xMzdlbXB0eXYxOWZzOElDbjc2ODZ0R0wxa0NLNGNlUDk4SER3ZENqSGFi?=
 =?utf-8?B?RWErV1pmSXZoVmlNYkIwQlZ0OXJKYlZDaDdicVhoRmFqekozMHlYZnEzcXpw?=
 =?utf-8?B?bDkwTnZKU1pCRHBRSEQreGIyaDB0RXBMcmFiNk4vK1RoR0o1a1RoVldTSXNW?=
 =?utf-8?B?MGdkS3YrdHcvYjRkekhjc1hkdGRKSEFJVU9rcU5tRlJhRy9KNk1GL1dxNk8w?=
 =?utf-8?B?aGhzNjNIRVgzc3FFUHhMTjBOelBUYUpmdzhTNkFHNXo3ZitkYUh0UWlIT2JJ?=
 =?utf-8?B?R1ppTDNrZEVVaFUzcUtUZHBiZENwcjlyWW9DcDlpSDQ0VTRIbkZCU25HTk84?=
 =?utf-8?B?VXN2YmR1RG5KRGp6U2luakxsVGc2cTNGZy85RHdFVHhHWUpwRmlpY290bXJv?=
 =?utf-8?B?dGdFZnE5d2hJb2Y4eDF3Vk5pTDhmdTFVSkd3YWJQd1lPM1ZmTytPTHdxQzI0?=
 =?utf-8?B?ejErZ2NBOUlqaWdERU5mdWZ1R2x5aFhzMzVLNDIyNVR3RmN4MnM1dkVKNGtV?=
 =?utf-8?B?eElKelZnT0srTVhmVktmbUpzalE3VWZXT1RRTTNsODYyZ3MzNEw0eUpCT2Ji?=
 =?utf-8?B?bm1BZjREQ3dvd0lxdkwvazV0UHc0OHZDdEZvZXU5NW1yYy8zbjBQQkJwSXNF?=
 =?utf-8?B?SHVNVXJvTGFhUUFvMk94NEN2UGJBN290VU5pLzZVOWJFSmZ0MmZYNWI4VlZB?=
 =?utf-8?B?TVdKdTBxMWtNUFY0VFNEaDlZdzJlbWRIaUpGa3JybFU2c0hJSG0xZVRDbTZR?=
 =?utf-8?B?WDNiUmU1bFhUekhGVFBSdjMzUmY4VWJJdlU2ZnpTM0RhQ05JS2RsVWE0V2JI?=
 =?utf-8?B?bGN6elpuUDF0aTZXV1UyNG51Zjg0czJmMmZuOW9MSi9vRlJvZVNHMzk1NnNS?=
 =?utf-8?B?QjA4M1h2TFMrQVBtS3h5UEdpREV1YW1mK3FOdHdzdlVNNXl2VXNFcDVCd3lW?=
 =?utf-8?B?cTZKUGVYVGNJZkFUbDFxWXFVbWZhU3E3NkpGQ2luVVFGTzJnNzdKLytHOTl4?=
 =?utf-8?B?S1Z3TnFtYWE2QU1OZHBvZFU4Q0crOVJYYWhqbmY0LytIaTZxNXBLRmcraS9X?=
 =?utf-8?B?VzNSZVg4dXpwc0NHUThxYzkwV2F3WENOOW1hRTRGZStPNDV6RDNoRGwrRFlZ?=
 =?utf-8?B?MldqUE01aW51MUxsb3o3V1B3eHFkM1RzbmtuN2pVaDQzeFhqRVg2R0FwSUVh?=
 =?utf-8?B?cDJMMERFcEJzYmFJNzVzYktWMnJQNUtDY3lzdEoxRHNKVG82YVRUYXpVN05n?=
 =?utf-8?B?bzBEalFnZEZjWVFYMVpocDA3aFR4QkVmZ0UyQjdMY0lkWWJGSmEzejlJMzFB?=
 =?utf-8?Q?t2L6zFMHgDkNCFUcFcg+clsJN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlNvQVl3TUZoYUFmTThHUkFZRUdobzVCOHlobTd2TGZCWUEwcEg3cXZFNWJP?=
 =?utf-8?B?VmF2eUhsU3g0SDVlZDNjdzJwNkJCbnpIRFhqb2ZZWkVqNnlKd1hGelA1MEl0?=
 =?utf-8?B?UlhCaEZEZzhCL3lCM3M4MkM3RE90anhEV3E1UkoycU5SYVdtZGM0M2gyREtE?=
 =?utf-8?B?RHYzUGFnUEVsam8zZHpXd2FUUVNvemVpTG56WThaL2tqUTVDalhsUzdoMjND?=
 =?utf-8?B?b0xMbEJkckpvSnJzMm9xYWFDc1ZVM2Q1ZlRzRWtJSE5xcTRIa3NJY3c1NUpH?=
 =?utf-8?B?ZEF5Umhaalg5ZFI3L2Q1SkRnL0xkMXhWSXNXbWRRTXNpMTNUNEpOWWNJN0ZS?=
 =?utf-8?B?OHFxdmhaZVlTSk1uMUFxODVKd2NsaW9OYitac2pRT2wzenZQRldRTG96Tk5J?=
 =?utf-8?B?ZTFrRDgxc1o3d255QmQyVElWVy9oK0Z0a0tTNi91SkVRZlQwSW1EVTUrS250?=
 =?utf-8?B?YmdETHZhanFpOThVK0pQYmh1VENacTJUb2dEeGJjQk9FMXREUlR0U0QrdTJt?=
 =?utf-8?B?VjNiM1NiV3FSbnh4RG9RN09ESFlZTnYxTTlhQ04xZk40TWxRYXhlOWxXbXFH?=
 =?utf-8?B?ZVdtVTJ0aGRsY2x5UWpSTklOOEllckNYUXY5NzZTVXZ4UFBGVXdJUG9DV3NY?=
 =?utf-8?B?ZzByWndGeXNQTE9razJTODZhWFNnUlFpSUtHais1RlhJdDV2ZS9BY2lRN1hz?=
 =?utf-8?B?eUdEZktwbEIwY0N5YlpBc0wxYjdpVW1YZFAyMnAxeHhIWTVBd05WZHF1OHc5?=
 =?utf-8?B?b3RSVUlGUE5XSmxVQTNpV2lvN2tNRmIzQnJiTkRabVBmZVJTei9OUSszVkxJ?=
 =?utf-8?B?bUJkOUNoNWMyNGFsQ01yeUl5TjNYWHRHemtTT3ppNTdpb042WnBRNW16NnZq?=
 =?utf-8?B?bFVZNG01TTNyNnZpZGJ4SmJlNW1QUlNpNmR0Sk9FUi9kaEQxRnB0VWZtY1dH?=
 =?utf-8?B?N0hqWHZOam15YmplNXp1elJnNDg3UzllQTNDZWlmditKYjVKeHRTVzlNU1gw?=
 =?utf-8?B?b3VjZjB5NlIvZTdzOEM0VkFRaWVIKzY4WStZWDcxSkV4aU43MS9ORDRSMTBu?=
 =?utf-8?B?OUhsZXNKbWJQb2JvTng1VVA5NjUwM0xubGpEbXE4MmZ2WTczYUdkbWRJWEVi?=
 =?utf-8?B?dVorSS8rRWtlRTlTeTU4M1ZpMXdIQ3N0aWNyMmwyNkgwUnhvakpHZi9xNFhn?=
 =?utf-8?B?dnp4b0sxcXkxaUp0cXNucWtWbFp3cVRWYW9SNEIzeXBMQy9kVzFZZXFtRTlh?=
 =?utf-8?B?K055NWdodzloc0NqMWtTTDUreThaV1FEUW9XQVFpUFZqWUJYakg0WS9Rek1L?=
 =?utf-8?B?aXlqWCtyQUZyanZxY29USG5iNGcrR25SdVB4THVyZVBBRkFKendhUWxIRUhG?=
 =?utf-8?B?VnJYYWJTWERyUTZEWUN5aWdsTTF3c2tHUHJQdkVzT2ZQMVNIT3VYNCtKZ3ZV?=
 =?utf-8?B?b3EvVFovb1g1MHM5RGlJOEkvSDRHVkt3dXlDMDJ2bVhtREJnT2pwdGFmeEc0?=
 =?utf-8?B?dlNBLzBkbmx6V1V1TTVmSVhrWHk5SWtFTUdscWE3QXFjeHgwVE9vTWdrbjhx?=
 =?utf-8?B?ZU9DT09lMEJmVWFHbmx1SE8yeDJEWmNNb0x4SE5OMlRjakZvZ2wreEh4Q1VK?=
 =?utf-8?B?V0hNbjBMWW53R2YrcTBsOUkzZDlpOENkay9qN3RLKzBDRmhQSlNjV3gxcHM0?=
 =?utf-8?B?bnI0Tzd4WG5jaENjbXRDcHVlVEwxMm5sYk9rNkNlYnBQN0ZKYXdkc0VkUnMr?=
 =?utf-8?B?V2s2Wmh1dTA0SEZ6R1VkSzEyMkR3NCtnb1pnREZLUHBkd0hET0N1YldFS3JH?=
 =?utf-8?B?Y3pReGdCNkt4TGZUVHFzOGplU2h6aTRIbXdpZEVYZFBzVllBaDVtbno2NzZN?=
 =?utf-8?B?QVNiazNqckdUK1U5Z2J4bWxwQ0p3RXVPdXJEZEh4Tk9uK29Md2RwOERZWm1r?=
 =?utf-8?B?MFJ2TGVKVFMwRng5TlVTbnlwREgrZzhKWXVxVDVkckxpUzVUR0thMVdZQ1FF?=
 =?utf-8?B?dEZNK1A1bnRpelBkeVRWa1dDa3FRWk83WlU3eHVWMFlnSDJMbDVIOEU1dnQ5?=
 =?utf-8?B?SnhGK1l3WHB4ZElVUkJSWlhkWlhwZ0NyYXkzTlNacGNsZGVxMFdRY3I3ZEdT?=
 =?utf-8?B?V1lvWUFWSFFGNFBZVzg4UTE0SFJuU0U3Q1dDTTk4U1lQMW5GWWQyclg2VFp0?=
 =?utf-8?B?WlZhWWZ3Y0pSQjRJazFHeU5NdHk0MjVoVDF1em81ZXFBUElpNEkrV2x6VHF3?=
 =?utf-8?B?SUc5cjIyZXJuYXhUdjFCd2owRHhxZnBNMEtSTkhYaDM0RnVXSVpsR1Q1cXpo?=
 =?utf-8?Q?tvA36ZMUglE3zJY8XS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e60d2b15-9ca3-4c33-6bc2-08de73dc2cb0
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 19:37:41.5923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tanp7Nx6eH3wWwqWBNARsJ9vJ7ju5n6aV1lyr2DJE061WjZpxMhrfa0Naf1Io1bR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8342
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71665-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 0E3DF18C240
X-Rspamd-Action: no action

Hi Reinette,

On 2/23/26 17:13, Reinette Chatre wrote:
> Hi Babu,
>
> On 2/23/26 2:35 PM, Moger, Babu wrote:
>> On 2/23/2026 11:12 AM, Reinette Chatre wrote:
>>> On 2/20/26 2:44 PM, Moger, Babu wrote:
>>>> On 2/19/2026 8:53 PM, Reinette Chatre wrote:
>>>>> info/kernel_mode
>>>>> ================
>>>>> - Displays the currently active as well as possible features available to user
>>>>>      space.
>>>>> - Single place where user can query "kernel mode" behavior and capabilities of the
>>>>>      system.
>>>>> - Some possible values:
>>>>>      - inherit_ctrl_and_mon <=== previously named "match_user", just renamed for consistency with other names
>>>>>         When active, kernel and user space use the same CLOSID/RMID. The current status
>>>>>         quo for x86.
>>>>>      - global_assign_ctrl_inherit_mon
>>>>>         When active, CLOSID/control group can be assigned for *all* (hence, "global")
>>>>>         kernel work while all kernel work uses same RMID as user space.
>>>>>         Can only be supported on architecture where CLOSID and RMID are independent.
>>>>>         An arch may support this in hardware (RMID_EN=0?) or this can be done by resctrl during
>>>>>         context switch if the RMID is independent and the context switches cost is
>>>>>         considered "reasonable".
>>>>>         This supports use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>>>>         for PLZA.
>>>>>      - global_assign_ctrl_assign_mon
>>>>>         When active the same resource group (CLOSID and RMID) can be assigned to
>>>>>         *all* kernel work. This could be any group, including the default group.
>>>>>         There may not be a use case for this but it could be useful as an intemediate
>>>>>         step of the mode that follow (more later).
>>>>>      - per_group_assign_ctrl_assign_mon
>>>>>         When active every resource group can be associated with another (or the same)
>>>>>         resource group. This association maps the resource group for user space work
>>>>>         to resource group for kernel work. This is similar to the "kernel_group" idea
>>>>>         presented in:
>>>>>         https://lore.kernel.org/lkml/aYyxAPdTFejzsE42@e134344.arm.com/
>>>>>         This addresses use case https://lore.kernel.org/lkml/CABPqkBSq=cgn-am4qorA_VN0vsbpbfDePSi7gubicpROB1=djw@mail.gmail.com/
>>>>>         for MPAM.
>>>> All these new names and related information will go in global structure.
>>>>
>>>> Something like this..
>>>>
>>>> Struct kern_mode {
>>>>          enum assoc_mode;
>>>>          struct rdtgroup *k_rdtgrp;
>>>>          ...
>>>> };
>>>>
>>>> Not sure what other information will be required here. Will know once I stared working on it.
>>>>
>>>> This structure will be updated based on user echo's in "kernel_mode" and "kernel_mode_assignment".
>>> This looks to be a good start. I think keeping the rdtgroup association is good since
>>> it helps to easily display the name to user space while also providing access to the CLOSID
>>> and RMID that is assigned to the tasks.
>>> By placing them in their own structure instead of just globals it does make it easier to
>>> build on when some modes have different requirements wrt rdtgroup management.
>> I am not clear on this comment. Can you please elaborate little bit?
> I believe what you propose should suffice for the initial support for PLZA. I do not
> see the PLZA enabling needing anything more complicated.
>
> As I understand for MPAM support there needs to be more state to track which privilege level
> tasks run at.
>
> So, when just considering how MPAM may build on this: The PARTID/PMG to run at when in kernel mode
> can be managed per group or per task. In either case I suspect that struct task_struct would need
> to include the kernel mode PARTID/PMG to support setting the correct kernel mode PARTID/PMG during
> context switching similar to what you coded up in this initial RFC. MPAM may choose to have struct
> task_struct be the only place to keep all state about which PARTID/PMG to run when in kernel mode
> but I suspect that may result in a lot of lock contention (user space could, for example, be able
> to lock up the entire system with a loop reading info/kernel_mode_assignment) so MPAM may choose to
> expand the struct kernel_mode introduced by PLZA to, (if kernel mode is managed per group) instead
> of one struct rdtgroup * contain a mapping of every resource group to the resource group that should
> be used for kernel mode work. This could be some staging/cache used between user space and all the
> task structures to help manage the state.
>
> I do not know what MPAM implementation may choose to do but as I see it your proposal
> provides a good foundation to build on since it establishes a global place, struct kernel_mode,
> where all such state can/should be stored instead of some unspecified group of global variables.
>
Sounds good. Thanks for the clarification.

Thanks

Babu


