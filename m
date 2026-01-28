Return-Path: <kvm+bounces-69362-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GIzhFTxMemmd5AEAu9opvQ
	(envelope-from <kvm+bounces-69362-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:49:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBADA7314
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E8B8030ADA68
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:44:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B49EF36C581;
	Wed, 28 Jan 2026 17:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o7nJvKQg"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011009.outbound.protection.outlook.com [40.93.194.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A331E0FB;
	Wed, 28 Jan 2026 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622257; cv=fail; b=s88OWCf3beLbKTwDJ8obf9adt1W6cUudC8yB/ldNEg/RyL86HtRBvaZbBkZVjXLt7+gXFotjhfhxi4ooNW6HKo9HuDyF13s8OvMEK8HCu0lakQwW7CrKUvJ7KD6UN60V5Su37Y1//AJb2qs4eGr37S6NQBjjQ0nEyiS6W2lvo+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622257; c=relaxed/simple;
	bh=W8b0qQJSlmlCQGD/SAAd4ad7Y7dM5cjuHfk0WV5LgLg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DB++RZBSY/QkQYi/+mq4DR1wwf7S44DYP38DwEFdpsxDTVKuntBLbRstJYpO4DaUdaK+LLniyWs0XeVsS1XE+0zsteSEwVk8KqVWJcyiez4RkMQJ9llQZJ6uDJDIo3z+KtZWQYsVaARXc0sM+YlIkZWvUn61p/kXPVcWElYtdsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o7nJvKQg; arc=fail smtp.client-ip=40.93.194.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TbQnhvN2Y3A6LI1mCxQmoSXpDcfcPC0nG7JtIkO6Oht5RDbH5zKX8NAWFzYtdUN+Gm9dMhGoVWZXbI9iYx57o0x1zRjMWPoctTyj0j0q8DaGgvqW6Ht8qh/AyxPCJNb2brVkoggV6hCujThut/Q/pAYqDtGkSk8y1sVF5Ecee4UALR6958zEvPkPyOuUsnyTtxp6sOIlQV9qEgtJ/7ugW308Yzx0HUSalNsSJSQYvAsGpQzZr/WV+FbI9Q5J+3e3MuABFDU+OcgUqKe2gVwZtlKnazqWhH5p6jy8UwxbVL6USMjLONikuUaJ+9erLqN2J2b5sNwFjM10D6TbfyAARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvgKGOTaNnGS4E10PIEwXw0HjeG6rP7c2YApi0vIjIY=;
 b=TMXF0JqizSOighzw38vmwD3T3agtnR+GUnc+nMRhZDLyufEF5tsx3x6Tp6RWbQ/Y12mU7dG5/m1aKWRN0ML/M+RBzwsJaKue5fFQcyGmHS7OGZuUOgLYV8wlfaFTAkeovxvjXY35XNqd28bea3UeFAVS7CQ8F6RhYci/S+47JtIqenC4YrrjcmRXxAHyhztgLa24f+V3ejP+9IXBBgRUIfTddWvRCTkMXJKqPW62NGpdtSHLolVaQId+9kF5AuzSoXUOl3M8ARViHkrAdBY3YsPHFGjLkVnBcV5EYAandL5Mk0LDsnnWlMD2qmvCE3sTQS7Z6HJuncfuxMVRnhuUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvgKGOTaNnGS4E10PIEwXw0HjeG6rP7c2YApi0vIjIY=;
 b=o7nJvKQgECzHHH3KsvttmXfLZgYvJf353JMWlBLaSFKuzl+LzocQAQGxO+hX9s8HIUAkRjaE9m76/Jy2IoP5d3H1A3ucg2YIu3oZS3DJBmkXqYj2G6hbmXwS+HSyxtFPpvAUo+l49NrloXgB27vrLka7xVc/1ZD213i1bBzmNkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by PH8PR12MB7373.namprd12.prod.outlook.com
 (2603:10b6:510:217::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 17:44:11 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 17:44:11 +0000
Message-ID: <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
Date: Wed, 28 Jan 2026 11:44:06 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: RE: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Moger, Babu" <Babu.Moger@amd.com>, "Luck, Tony" <tony.luck@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "reinette.chatre@intel.com" <reinette.chatre@intel.com>,
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
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:8:2a::27) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|PH8PR12MB7373:EE_
X-MS-Office365-Filtering-Correlation-Id: 7468c909-c059-46ec-e4bf-08de5e94d872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UlYzcFpzODZmcmp1TkRONGhoWEhCbDVpZTNIM2kvY0lwMXdMUCtrRFBOMGph?=
 =?utf-8?B?UDA5WUQ2YVZuQzY0ZG1rR2IwV2FSVTFyWTVTdWFOMHVwQkZBM2NpMHByeTRy?=
 =?utf-8?B?eSt6ZUlWMk1hYWR6elErcXo1c290OXVpV2dZNnNDY2VQVm4vVkQ5WDgwZ0FH?=
 =?utf-8?B?blRkc0l2L1U4a0VZQTlNUHZPWmpLRjg1MTliM0pwZm1EWXVWYlk1OTdkQ3hn?=
 =?utf-8?B?V1RodjViME1IZHcwdjJFZWdIb3NUVlp5MVpiY1l6dXNzdmhhQVRlb0hPWURq?=
 =?utf-8?B?ZWpzSzZBMit0SFovbkNVL0JSbTVtUVdIeTdab2hXaU0wYWxvS09pbWRIN01t?=
 =?utf-8?B?cUlxS3JsUlZHQjdqbm4ybVJ1Yk4xQ1RCNUZORVhuRzIwTkl1SURIN0NvNElT?=
 =?utf-8?B?QisvVHRuZmZtVVdGVkNSamlqOTErU0hPRzJnWW1SQWtlYndYTU1aSzZOMGI4?=
 =?utf-8?B?bjZvcXB6NElBcFd4RC9nWVN6c052QnNDOHFHaVlMREpPaXM3d3N5eXJIWTRn?=
 =?utf-8?B?bmFLanVpSXN5UGpkdDkrdG1hRmpOd0RGZkVLL1JXRldQWjFYT0Y2OXZtVC80?=
 =?utf-8?B?cmVHUWxTTGhmSk9zTlNKbGtuODdmYTZ5MmR5S0V6bjBxRmRFTURmU0krZk9i?=
 =?utf-8?B?MmRpTkp2Mk9uQVVyT0hXUUkxNXBaRVZxMjBjK0MwWWMvK2NXRnlQeXN5OHhI?=
 =?utf-8?B?clBiN2syekpwRXFUeWdxK1dmUDRqNmFZdTZ6bUVFL1E3aU95ZVhJM21oeUZl?=
 =?utf-8?B?bXM3OTVDSk9sY3dIY3pHRGgzbDNTSzZZVDFIdUo4Y0Z3SHR3VVJXSGwzMml6?=
 =?utf-8?B?bkVwUk0xZ3lhdnBxUHFVK0NpZEtobi9vaDhjcGo4SHNSdUxDallmTGw1bTJn?=
 =?utf-8?B?aEs1dFBHRmxueU9DRHlrWkJmZ1FlbXdTR0lIUmJqb210blZvVFo3UmdESG1M?=
 =?utf-8?B?cTBhYjQwYXBqdDBqRXBwMG1uMml4emJSU09OQVNRdHhGRTdObmdYMCtjNWx5?=
 =?utf-8?B?aFBMLzRtOGtKZUZYMy8xODJOV1NXSTRCYlc3eVlta0tzSTRCYVI4OUZxTU1t?=
 =?utf-8?B?N09SUXAweEtKWUFRTnZnOFpXU3dMRVJUZUFHV05BSHNwZVJBL1dKdW9JYUZv?=
 =?utf-8?B?cE13MFUrMUZuSzMra3paVnYzVmM4UDRBKzBucDlZNVNBbGh5U2hYVngxVEF0?=
 =?utf-8?B?RStEU25FRDZNdkNOSmxoSTdINFZxNmttbHl3MTZkWGp0SXVGQjNNTjA5NXk5?=
 =?utf-8?B?ZHUwUDhMdDE5UjA0SXNRSGY3Z1EyZmhiSWhkeGhQYnFSWkY5WktnY1RGWlkr?=
 =?utf-8?B?UEhvOWJ1b2lhMkwvRnVSMzB1cy9ZS2Y3Y0Ntd1pUaWdDQnAxRDFBOWZybzZq?=
 =?utf-8?B?UG1PNFdWai9abFZ5VUcwYVpQV29BOXkxdzBVWVpLT2pjeXNMVjN6c3NIaitB?=
 =?utf-8?B?dklXRFhwb2txR1Z2dDV2M2JwRGRlZXErcE5XeWRYVjVZQmVzeFBkZW14UGtF?=
 =?utf-8?B?V3BBMFd4YzJBV2F4R0FaOUhZS1lhU2hWSk5jS1ljdFlXaHdndXdrbUhwZlN2?=
 =?utf-8?B?QTg2N2VWajRNNXI3OVA3UjFJZjhiTWkrVHV0N1RkUnJzS3lpeEMxaHV2cGs2?=
 =?utf-8?B?RTN0MVRrTnc4MkpiLzBDOTJabzlkZmNFWm5pM2VRVm4zR1V2MHlEeG1saTVB?=
 =?utf-8?B?S0VCMDNrWGY3cTBNZk5od2c2K29aTzVEZVZXeG5rdmtKaFM3WUFRa1V0OHZj?=
 =?utf-8?B?Rm9SM0EyUVBvYWlCdUhXSkNWb1VMUVA3emgxdGMvQUdQMElUNitpN0ZjKytk?=
 =?utf-8?B?OHNxdEpLeTlJNEVWUXVkVUgvbTJ0STdYT1RHVGxBTHRzOGhjYW1TS2ZIUDVZ?=
 =?utf-8?B?eEpINFMvVHprM1pDY3NFRFpKYkpPU3BnSTJBMDJRcmdvc0VTclEvb1dsRlYy?=
 =?utf-8?B?QUc5QW9rdDFOOHFzTGx6QTNjd3QxZlkwa0dMUlJubnZyY0EzeHF5TDNDRVA3?=
 =?utf-8?B?YWw5bmVxRWJwTkIrSzFZRkZNUVQ5cVJ5WjNaNis5ZnRTdDE4dXBialFSdUpu?=
 =?utf-8?B?bWV6cTlFdVlYMEEvRGFCZFVHRXc0bUEvajRaVlhqRm9BcERyenJnV2wwdmxX?=
 =?utf-8?Q?eoMI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTJYMXZOV01rLytwS1JFdGVyMTNORGhrYVdZdFlVbHZyb0RDWVNha1hmb3NN?=
 =?utf-8?B?UnZYOEIvRG9HbU5tNXRKT0VCVFlWYWtScy9kWHl0NnY5OTgwNEVuTHowamdC?=
 =?utf-8?B?eTJOVzhYZkNoVFdqRDd0a010S05iLzRCakRyWHg0ZVVHTDNlczNQdjdDbHpr?=
 =?utf-8?B?SnpuUmZ5bXlKNlRkREkrUUxkN2YyZE9pR1NVem5xcGZ5QThFWEtyZnF5ai94?=
 =?utf-8?B?c0hCOGxiRG55U0xaMUpDZjFsZnB6OHZML3NvcXJ6dStIY3V0bncyYXJYTlll?=
 =?utf-8?B?UU5UZnEycFB3aDBqME5UK3BoMVdHcytrWTdRT29hUjRPUmNXbjhOOHdZMU0w?=
 =?utf-8?B?YVdPU1RFeGsvWlZBODBicVdwNVJ0SGV0YitiQSs0cmdVdCt4L2ErSWE2U1Vn?=
 =?utf-8?B?bUxoVFZ6dTBJSUlOZXhwUEhIN0JVTVkraFBycmZrNG4xZFVXVkw1dnZoeENw?=
 =?utf-8?B?K2JxN3VoNkZ3R3hhQXFFbG52UUw5YmduUGJ6NU56Z1oxV0E0ZEp2NzRFSXFN?=
 =?utf-8?B?TlJDY3V4VjFDVzNMRzltMFpiazVaeVlzM3R5ek0xV1g0djljM21CT1c3RGNT?=
 =?utf-8?B?NkFRVmdDUVpzVHZhK2wxTjRDS2xwK3U4UXlRYlRrSUZwUG5DNWdmTWhjZ0hQ?=
 =?utf-8?B?a3NsdnNnanVObC8xbHQ4aWVyTS83bUV1QnBsemUyVU5RRWRVaUNBODhOUWo5?=
 =?utf-8?B?WG44WStGM095cXpueDFrLytwQitDN3FhTitYN1dpT0xYNVdnZzVwYVl4T3FI?=
 =?utf-8?B?TmZLeVhOdDNFTlRnOE1KM042WFFwWFBhV3JsMGZJSmtpRkJtY1IrWVduTHBt?=
 =?utf-8?B?QVRoSHd4QWExRmJvd05oREpSY3RWT1BEUy9kamhyWk9YdXBvODFmOHhqYk1u?=
 =?utf-8?B?QzFTT1VndkNRelZnNkx2UEY3ZVdEaitVMHZYUW9hQUwxSnRBSGswSVp1cjVj?=
 =?utf-8?B?S3pxOGs3VzcvdmtuSUVMb0lWekdPa2lEWnlVNm02UEVQazlCTGVrY1dGdDF5?=
 =?utf-8?B?aVRRNnFtbmF2UU5pSVpjQUdtQXlUeGFDTU9NSGZhRHVSL0hKRWQ2SkpwMmNT?=
 =?utf-8?B?cEY0WCtnRnhHTndUdnFIYVkvL0JoRnFkM05ma1htSTNPWGdrRVhMOGFKd3BV?=
 =?utf-8?B?aUQyWkYwV2ZLaWZ3YmFzZlF5R2QyaVBOZnJCL3BmejlnODd2b2ExaTJaM1RW?=
 =?utf-8?B?S2VtZzl6Vyt3MmE1UXBPbG84UG9MTkIrQmhIT1grb2gvQ0lXSys0N24veFNG?=
 =?utf-8?B?bnN5WWtUTy9iaGg1YlhvR1RLckdUTnpsQ3BTOStmbFl5WFZvQ216SVloUFNN?=
 =?utf-8?B?VThVcmFyREpsRzloSW91SkNqakV0T0V2TXRlV2ZHaCtXQUVOdXNocDBSb21Q?=
 =?utf-8?B?ZXZwVGtCMGNURHBGanNxYnY5R0lSbnh6ZlVvM210NjVCemp3WkhxbTd5dzNB?=
 =?utf-8?B?OVc3Z3l6TTFIWExKWU1RS2REME5zZ01DUzZFNzMvQjAvSGd6YzFSSzNHeTU5?=
 =?utf-8?B?czd1WnV2TFV3S3FyODF1cHpKOHRJeUhZQ2IzalFCeFVNbHFTRitva1R4RG9i?=
 =?utf-8?B?N3IzVWlsWThvUklFSmYrR25aOGF2WDVBU3BYTnhVc3VISmwwbGtpUGNrWVdV?=
 =?utf-8?B?WlBlUFZwQXQ4Z2hncysyV0h0VWc5UmZqRkswRHJXbUhIL2ZmeHhrVnpubVky?=
 =?utf-8?B?bzFDajVkTzRqSkswNVBTSTAzSlozYW14WC96SUp3VzBIRXE5M2RsSnhzM0R6?=
 =?utf-8?B?dndmbEJYUGFuMUNvbk5MRDJicnkrRmc4QjFTWHVFclR3NHhIdVRPdEMzVEM4?=
 =?utf-8?B?TWpFMjRzOWh3a2h5UjJaNnFMTE1aWHZCR3Nid1JaUFBYd0d3K2dveUlFSzdu?=
 =?utf-8?B?K0Q3ekRtZzR1M1RjWnA2YUpiQWVTcmxySmFOOGhWczZBYTZyRkJ0KzFmdWRS?=
 =?utf-8?B?Q2pBaTB4bEhvd001VVdraUErS0FWWnI0Y2VSZWxTcFF6YThyUVlGOXl6TmZi?=
 =?utf-8?B?TGovVTl6K1dtOUpIaGFKeEpSS2ZMZ1JnUkFJMXZtTk41TkQ4cHBLMjZHK3Fx?=
 =?utf-8?B?bnZlVFluYzF4RC9UTlJjVnJpOUZGZ2xCNEpYVXdpM3FvTFJMYjlBK04yUWNs?=
 =?utf-8?B?TFJLQWpmREhnSzJOWHcvYjZULzd6ZVhURVZFL0hRMUpoRHRNWHJBeHFteFN2?=
 =?utf-8?B?NCtwM0YwTHRHRUtTNXpWQ3QwZWY3RFJMNWJNRGtQN2ZWQzg3UkJ4UVhxdG9S?=
 =?utf-8?B?Z09QZEhEcVdia2J5L21ydTArV0VoM09QNHAvWUxEVXFISEVuQ1Jydm8zTENI?=
 =?utf-8?Q?vWTTrXixikzURDXV9h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7468c909-c059-46ec-e4bf-08de5e94d872
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 17:44:11.4247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOh+beLQjs9XiSThn2fCuhoHU+/yI+/rb3E5Sdi9qUinii2bhcTdUUPbUq7agPSS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7373
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69362-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: ADBADA7314
X-Rspamd-Action: no action



On 1/28/2026 11:41 AM, Moger, Babu wrote:

> 

Outlook adds AMD  header.  Removed it now.

>> -----Original Message-----
>> From: Luck, Tony <tony.luck@intel.com>
>> Sent: Wednesday, January 28, 2026 11:12 AM
>> To: Moger, Babu <bmoger@amd.com>
>> Cc: Babu Moger <babu.moger@amd.com>; corbet@lwn.net;
>> reinette.chatre@intel.com; Dave.Martin@arm.com; james.morse@arm.com;
>> tglx@kernel.org; mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.com;
>> x86@kernel.org; hpa@zytor.com; peterz@infradead.org; juri.lelli@redhat.com;
>> vincent.guittot@linaro.org; dietmar.eggemann@arm.com; rostedt@goodmis.org;
>> bsegall@google.com; mgorman@suse.de; vschneid@redhat.com; akpm@linux-
>> foundation.org; pawan.kumar.gupta@linux.intel.com; pmladek@suse.com;
>> feng.tang@linux.alibaba.com; kees@kernel.org; arnd@arndb.de; fvdl@google.com;
>> lirongqing@baidu.com; bhelgaas@google.com; seanjc@google.com;
>> xin@zytor.com; manali.shukla@amd.com; dapeng1.mi@linux.intel.com;
>> chang.seok.bae@intel.com; mario.limonciello@amd.com; naveen@kernel.org;
>> elena.reshetova@intel.com; thomas.lendacky@amd.com; linux-
>> doc@vger.kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
>> peternewman@google.com; eranian@google.com; gautham.shenoy@amd.com
>> Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and context
>> switch handling
>>
>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>> Hi Tony,
>>>
>>> Thanks for the comment.
>>>
>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>> On Wed, Jan 21, 2026 at 03:12:51PM -0600, Babu Moger wrote:
>>>>> @@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct
>> task_struct *tsk)
>>>>>                  state->cur_rmid = rmid;
>>>>>                  wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
>>>>>          }
>>>>> +
>>>>> +       if (static_branch_likely(&rdt_plza_enable_key)) {
>>>>> +               tmp = READ_ONCE(tsk->plza);
>>>>> +               if (tmp)
>>>>> +                       plza = tmp;
>>>>> +
>>>>> +               if (plza != state->cur_plza) {
>>>>> +                       state->cur_plza = plza;
>>>>> +                       wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
>>>>> +                             RMID_EN | state->plza_rmid,
>>>>> +                             (plza ? PLZA_EN : 0) | CLOSID_EN | state-
>>> plza_closid);
>>>>> +               }
>>>>> +       }
>>>>> +
>>>>
>>>> Babu,
>>>>
>>>> This addition to the context switch code surprised me. After your
>>>> talk at LPC I had imagined that PLZA would be a single global
>>>> setting so that every syscall/page-fault/interrupt would run with a
>>>> different CLOSID (presumably one configured with more cache and memory
>> bandwidth).
>>>>
>>>> But this patch series looks like things are more flexible with the
>>>> ability to set different values (of RMID as well as CLOSID) per group.
>>>
>>> Yes. this similar what we have with MSR_IA32_PQR_ASSOC. The
>>> association can be done either thru CPUs (just one MSR write) or task
>>> based association(more MSR write as task moves around).
>>>>
>>>> It looks like it is possible to have some resctrl group with very
>>>> limited resources just bump up a bit when in ring0, while other
>>>> groups may get some different amount.
>>>>
>>>> The additions for plza to the Documentation aren't helping me
>>>> understand how users will apply this.
>>>>
>>>> Do you have some more examples?
>>>
>>> Group creation is similar to what we have currently.
>>>
>>> 1. create a regular group and setup the limits.
>>>     # mkdir /sys/fs/resctrl/group
>>>
>>> 2. Assign tasks or CPUs.
>>>     # echo 1234 > /sys/fs/resctrl/group/tasks
>>>
>>>     This is a regular group.
>>>
>>> 3. Now you figured that you need to change things in CPL0 for this task.
>>>
>>> 4. Now create a PLZA group now and tweek the limits,
>>>
>>>     # mkdir /sys/fs/resctrl/group1
>>>
>>>     # echo 1 > /sys/fs/resctrl/group1/plza
>>>
>>>     # echo "MB:0=100" > /sys/fs/resctrl/group1/schemata
>>>
>>> 5. Assign the same task to the plza group.
>>>
>>>     # echo 1234 > /sys/fs/resctrl/group1/tasks
>>>
>>>
>>> Now the task 1234 will be using the limits from group1 when running in CPL0.
>>>
>>> I will add few more details in my next revision.
>>>
>>
>> Babu,
>>
>> I've read a bit more of the code now and I think I understand more.
>>
>> Some useful additions to your explanation.
>>
>> 1) Only one CTRL group can be marked as PLZA
> 
> Yes. Correct.
> 
>> 2) It can't be the root/default group
> 
> This is something I added to keep the default group in a un-disturbed,
> 
>> 3) It can't have sub monitor groups
>> 4) It can't be pseudo-locked
> 
> Yes.
> 
>>
>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>> would avoid any additional context switch overhead as the PLZA MSR would never
>> need to change.
> 
> Yes. That can be one use case.
> 
>>
>> If that is the case, maybe for the PLZA group we should allow user to
>> do:
>>
>> # echo '*' > tasks
> 
> Yea. It can be done.
> 
> Thanks
> Babu
> 
> 


