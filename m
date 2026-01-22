Return-Path: <kvm+bounces-68899-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kEpZJtxBcmnpfAAAu9opvQ
	(envelope-from <kvm+bounces-68899-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:27:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE6768C46
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:27:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 788CE7CB9DB
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 14:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D206315D5A;
	Thu, 22 Jan 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4my55+rl"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011038.outbound.protection.outlook.com [52.101.52.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2D2274B59;
	Thu, 22 Jan 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769093624; cv=fail; b=ejklTLpcMdqO0vhJOBZZIT2HeOlygHyZTGZSVPXyN7S1xv/fvo9BZENt50ETs8lxA5b/i0ZMht/V7LNIZENPwejbqkX7I0W407sCbHaCmAImvfzUp2Vj4hzTgnWMs86JepkbVaaL/IGpDxuelWs4TNlKSVcJyvf9B8E1Pj+yLlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769093624; c=relaxed/simple;
	bh=ZF3B8kavsBc7FsGdjrxVOJIHVqLtAedrcK48Pb8Sy80=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=d4CtA9Smrq4YY7MNDwImu84ueDrwA8BVNEkz9fS1zVx4GPGP+3JwTda8Chr1nOdQQEYbO5WX/a/eLP0YUA89IirwBfNyFqSlk5oTdDMbNVg71653vxOpI7pravnzHqcZnU6CVkc2Zfje4vRPAulyEuCZhNh6cKTRJoGPhoUMKjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4my55+rl; arc=fail smtp.client-ip=52.101.52.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9ZPGaQ9h1JM/uf7PghxfM9Ri3D6ap6pScS9+UTIalm0MNI3mGgCxNhgv/1p2mma+j4tWdfLZ/CmFqsrP4IDzmLEj2ZzyomLjeaMdih7WRFRngOnu+BLgL3pZJFsYMGDFIcjubcBnEAV6x8+DGddczXh9V8IScMsepVoT5YxGSjWBhVi5nmom1KT1X0G+xm9cMkXLKHcYadxsgNh/JGcT3E+wgLaF472CmAhEIpc//qCUZSjfWyHtsm56TYBtUSi2nGE3NBLBNa03is2gXwmMuubKPxPPFB2/GKoOd1JrnJ/Re8PS4WxfTG4/wtuOQ6DTv6VfxZ/Ytn0pBNon9859Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdw/HnlBh07SOgXHbjT2oRC6VXHwuVqINg0v3aVacVE=;
 b=eUaVhWX4QdEvES1OnuKlL8o/E+dQdWBQD7QrrRhY7w0SuqYVh8ZSQYd5pbG96GdAFsEnUJaQCfqVeFa95+/KBNWflaThcd2iaYeX0VWEnlqCVs6kJbnk6Wi9G2MZ/lClzzD670E96URVmT09dRln5W+d/8oKMDokECfUnhxx1mO+miWdYVhbFXxFyGfyXIp0gcyyVzWxQ9FTL/xe1d6iZp/y7wqOvnKV+AY7fUqfrwGghbKZIuUFW3Xa0NgTG08V0vdpMnyolvrrf6crAohTHQoVYyjR8VuIKqbr+HH37a9lXa9+b7N5MCmTQg4OpeCXnrgmtn/Gl8m0p4jufcZtsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdw/HnlBh07SOgXHbjT2oRC6VXHwuVqINg0v3aVacVE=;
 b=4my55+rlyMbBzORBvkYBHn3XfNsMtE7An+2wXSmx6RZlDW9CCcpa2jmWX8dC6BCnVE7IbFohbo8k+M5pe1eCCZVH18R38WllOX9ssjZmHgTKJHFTnpbfPBRg32zRrGXq9xmQQnmbKqAXanr4qpJJmfWsXYwzXag/uP/8tz5Buyo=
Received: from MN2PR20CA0006.namprd20.prod.outlook.com (2603:10b6:208:e8::19)
 by CH2PR12MB4040.namprd12.prod.outlook.com (2603:10b6:610:ac::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Thu, 22 Jan
 2026 14:53:37 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2603:10b6:208:e8:cafe::35) by MN2PR20CA0006.outlook.office365.com
 (2603:10b6:208:e8::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.11 via Frontend Transport; Thu,
 22 Jan 2026 14:53:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 22 Jan 2026 14:53:37 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 08:53:37 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 06:53:36 -0800
Received: from [10.252.219.255] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 22 Jan 2026 06:53:32 -0800
Message-ID: <56716e48-951b-4ca0-a411-79dd72da7024@amd.com>
Date: Thu, 22 Jan 2026 20:23:31 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/12] KVM: Add KVM_GET_EXT_LAPIC and KVM_SET_EXT_LAPIC
 for extapic
To: Sean Christopherson <seanjc@google.com>, Naveen N Rao <naveen@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250901051656.209083-1-manali.shukla@amd.com>
 <20250901052146.209158-1-manali.shukla@amd.com>
 <jf2zfqo6jrrcdkdatztiijmf7tgkho7bks4q4oaegiqpeflrkj@7blq6f5ck2hf>
 <aWgRvCdPsAFHRwcU@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <aWgRvCdPsAFHRwcU@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|CH2PR12MB4040:EE_
X-MS-Office365-Filtering-Correlation-Id: 84611941-20e0-43e1-c43b-08de59c60609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|30052699003|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFJXaXhzVGo2OGNWdmVuQlJxOUo4NmNLSjEySGJqYTJGTFEzSjFUN3VxQU5j?=
 =?utf-8?B?ZHlNMHliSXR3b25OV2lZeExmYXFsejlSY050ejJ0WXVEaDVjdmJNSWxyM2pt?=
 =?utf-8?B?alBRMEo4OG52YkpIa1JKc1NjS0JJdnhzWkd1UGVKbWJ4SFdwRVNKU0NUMmt6?=
 =?utf-8?B?cXpuL1c4Y3loUHRzSFk3Qkd4eFNDQ0loR1pMQ0RsTGdLcFJOV1UvVThhUDl5?=
 =?utf-8?B?OUNncmJRclJ0R3J2VEY3YVhUT0l2ZWgyM0xLbWtkY296SnludGRqcFNMRDV1?=
 =?utf-8?B?Nmo4NmZ2clMzKzBtbHJQVzYyYUNQWkFpMmtxOUxSdDRwRytRNkFmeFVHdDZD?=
 =?utf-8?B?eWttTE5CblNvK2l6ZjNlNTEwMUU4TTFlTUFpWXo5SWRoajNSL3lMUFRIek0v?=
 =?utf-8?B?UHV0Vnlhd3BPY1c0ZDZnWUEybmRicmZpQ25KRmhlUzI1dndIcEhIcnpNRExX?=
 =?utf-8?B?QlZ1cEpZK3hjSlQwSjhqTkZaTnVYeUpTWHVxcVg1NlluSm5hUi83cG9yV0lu?=
 =?utf-8?B?dUY5UGVPZE9tczg1K3l3aC9neHJHdlBGdFNZUVh5TG14UDBoTnBISEJQSm1X?=
 =?utf-8?B?QWVJMjdBOHQ2MmRuVWNIWXdYL2FBV3c4U3NBUFdrcFBXZytLVzlzZ0lROVRh?=
 =?utf-8?B?blk3V2ErcDZZc2VsZm9GaUVlY1lVL2dYVXdSNGUxZWNMbnNlU3k4VlJTczZa?=
 =?utf-8?B?bFFoZWVKTlBZMVZBaWtNYVRsZm9QZ2lJa1RKUkFlMGMxWDdoOUR6MVhScWo0?=
 =?utf-8?B?MlBGM25JTU1WV1hlcmRWMEd4ZUdIS3dqVlhCS3d5TFE0SnFlWkp3UVU5dmtJ?=
 =?utf-8?B?N0ZDK1dlUEdRZDBJZCsyKzZtS0xldlNuV1FObWxzZ2x6NmJTQlZhUWZVb0xw?=
 =?utf-8?B?UUt5MlZJeTd1aEU3RzczeDgxT3RMYTRXV3VOYnhoMEJLOVF0aUlTWHp3L2c4?=
 =?utf-8?B?TFJRYURzTFBKQU5zeGpIYVVUNXQxVWhOemlIL2cyS0lSVWlDZUZTU2FtT2Zy?=
 =?utf-8?B?L0JhdjlON2RNNksyZ1J6RnBPeVM4THRkMVhjdGR0SW5wbWFsRER6Z2NxcGVU?=
 =?utf-8?B?endlZzlBR3ZDdUtsUzNOd1FPTFBqK1ZqaEVudDV1VXRnWXo0UFVzOGJSR2pX?=
 =?utf-8?B?d3NuTXViSW0zYzdQcjRhMnR4aSswQXp5RWVKZEJBUWh3azduSlNOR0VVbUhj?=
 =?utf-8?B?QSt3em5ndVRiYm9GWTFnRXJwd1J5d0FhbGpDbVdXbk4vbTZMRFVVSFVVeDM3?=
 =?utf-8?B?cWFhVTh2S1RTc0lZeTBZY1hSMHo1OEpWT0cwYU5VdGhtdk13NGNNeHh0WGlo?=
 =?utf-8?B?WTd6aWRGS01ORElJSWVTY0k0Ty95UGRJV3AzTFhUR0IyVjNReDYxVWQ3VzJn?=
 =?utf-8?B?dGYwRU83enVzaFY3RTBTVUlnSGNBK0JLWmgrN0FLVFU4OGdINjVuRURMbHBX?=
 =?utf-8?B?ZENubHFhSzBhM2ZIZ0FPVnUyR003ekwvMFcwS3BZRGNRanU3UW1RNWM5TFBV?=
 =?utf-8?B?V0VpY042NGtMa1ZjQmVRMkpNY01RT251bjlsMjVDd0pna1VqeVRTNXpaazhD?=
 =?utf-8?B?ODR0WlZoS2d6VHEzVFgxbEpIUnlJMlV1Yy9xOEs0Vzc0UUpMdVRkVWFzRmd0?=
 =?utf-8?B?a0NIWXRqZUY5RlZaSEVlc0lmWGNXQ3lYNHByTkNEVVFzZnFwK1k5cmdKL1Nv?=
 =?utf-8?B?VEtQbDdBbS9zNytsY3pnS3pjQS9oeS8xTVB4ekRYQ2hiUGZtTnRhV3lIVFR1?=
 =?utf-8?B?eWtselBlckd6T1U5eFJRZ0RZcjc3T1laWGlMMnpHUzBiWmoxc01vQUFxejJw?=
 =?utf-8?B?bHRqR0dPUmRpdDZCZzZjWG5yVkl0c3haVGY2WW1ROVh3cmVVeDJnWGVqV3Jo?=
 =?utf-8?B?cWJnaEZjTDlJQkRoYjBTd1ovbEFwQTNwWDF3MWlza3NhWE1zdEFBenI2enBX?=
 =?utf-8?B?WWZhT0YyZXpOdnFDWnpTODVvRVB6T2hUNjNEdElubU1nMU55eXZhRDBYYUtq?=
 =?utf-8?B?eTFHWHp6OFIxUUphYlJsWEEwTWxQSUZwNnBCZG4yNGp5NHIzWllUbG82Nk5H?=
 =?utf-8?B?ZVN4RTkvY2dGaU1qWGlUSURaNkRobDFzc1ZHWm5oOW5UTUV0b0FCcWpYUEFT?=
 =?utf-8?B?aC92cVV3WkJwbXAvYjlFTWNEOGNJYVUzcTdYWHloNEhDTUFuKzA0UmJUNnl5?=
 =?utf-8?B?aEo0alowNXRmQkpuMTdJZ0pGYXgvRjlCdkVwSnMyNmp1WXM3cHJUaHFhQmda?=
 =?utf-8?B?VzRLRFpaNDM3L1VLUEdkM1FDc1BBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(30052699003)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 14:53:37.2450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84611941-20e0-43e1-c43b-08de59c60609
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4040
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68899-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,amd.com:mid,amd.com:dkim];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 3CE6768C46
X-Rspamd-Action: no action

On 1/15/2026 3:29 AM, Sean Christopherson wrote:
> On Tue, Dec 16, 2025, Naveen N Rao wrote:
>> On Mon, Sep 01, 2025 at 10:51:46AM +0530, Manali Shukla wrote:
>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>>> index 6aa40ee05a4a..0653718a4f04 100644
>>> --- a/Documentation/virt/kvm/api.rst
>>> +++ b/Documentation/virt/kvm/api.rst
>>> @@ -2048,6 +2048,18 @@ error.
>>>  Reads the Local APIC registers and copies them into the input argument.  The
>>>  data format and layout are the same as documented in the architecture manual.
>>>  
>>> +::
>>> +
>>> +  #define KVM_APIC_EXT_REG_SIZE 0x540
> 
> As discussed in PUCK, just go the full 0x1000 bytes, and do:
> 
> #define KVM_GET_LAPIC2            _IOR(KVMIO,  0x8e, struct kvm_lapic_state2)
> #define KVM_SET_LAPIC2            _IOW(KVMIO,  0x8f, struct kvm_lapic_state2)
> 

Ack.

>>> +  struct kvm_ext_lapic_state {
>>> +	__DECLARE_FLEX_ARRAY(__u8, regs);
>>> +  };
>>> +
>>> +Applications should use KVM_GET_EXT_LAPIC ioctl if extended APIC is
>>> +enabled. KVM_GET_EXT_LAPIC reads Local APIC registers with extended
>>> +APIC register space located at offsets 400h-530h and copies them into input
>>> +argument.
>>
>> I suppose the reason for using a flex array was for addressing review 
>> comments on the previous version -- to make the new APIs extensible so 
>> that they can accommodate any future changes to the extended APIC 
>> register space.
>>
>> I wonder if it would be better to introduce a KVM extension, say 
>> KVM_CAP_EXT_LAPIC (along the lines of KVM_CAP_PMU_CAPABILITY).
> 
> Please figure out a different name than "ext_lapic".  Verbatim from the SDM
> (minus a closing parenthesis)
> 
>   the xAPIC architecture) is an extension of the APIC architecture
> 
> and
> 
>   EXTENDED XAPIC (X2APIC)
>   The x2APIC architecture extends the xAPIC architecture
> 
> There's zero chance I'm going to remember which "extended" we're talking about. 
> 
> KVM_CAP_X2APIC_API further muddies the waters, so maybe something absurd and
> arbitrary like KVM_CAP_LAPIC2?  The capability doesn't have to strictly follow
> the naming of the underlying feature(s) it supports.

Thank you for the feedback.

I'll rename the capability to KVM_CAP_LAPIC2 and the new ioctls will be
KVM_GET_LAPIC2/KVM_SET_LAPIC2 as you suggested.

I'm planning to send the extended APIC register emulation as a separate
series rather than bundling it with vIBS.

- Manali


