Return-Path: <kvm+bounces-70405-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBNgLIBghWmbAwQAu9opvQ
	(envelope-from <kvm+bounces-70405-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:31:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 221DEF9C17
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:31:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F06E3300FB4C
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 03:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E67331A7E;
	Fri,  6 Feb 2026 03:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NEWA5wpJ"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5DA1F5842;
	Fri,  6 Feb 2026 03:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770348669; cv=fail; b=FcM3VozT5MuWeoM2wadn7GwDwGsFHu4N9Fn/5uautFvtVh2YiSmD230kv9tLam/H0k/trdPND/Xh19OV4xXKS6MzX9rmr4mvDCsE8m6AtYjPqVPuiDrCMzTtR2+zuEP8G9m8dGjCPj0k5RileRZj4e+Qi2hwTKY+XIHrn/d7lxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770348669; c=relaxed/simple;
	bh=w59pCmbcap+/BMQSqEIAHW3J7cjVe8+sbNpnQbDh8v4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QmswKcibULSg+AvNM9KKgGPFINZH2gbP+tSmVE8SI5PGyCK6DZToG0rTIT1u2CgRDTB0IRRTmGXO096Iq7ozJ6cILDV2ofP/KpKCprOMZkqjmkkmdL1hbWHchhfxjv4FWBGUk8Dx7gAvmWZEuC6Jft+bKBG+C47ebBboRYyYnWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NEWA5wpJ; arc=fail smtp.client-ip=52.101.193.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oCYPxPaKGSjaNMZD/NwoXcwp1y9V5Pq1bmu0Uu1sd2c4DlUECLJJAKLq25vbd4ZmFVQVoOrvxp1t96oHxoVMLPxInVsjiERZgvq1SmZvukSjLM30iRjSa3bLtMeGS6Pr5Wc9gBOcJf+vBo0BXsEcigxLGzJyLH6GKPgd0vVu2JB0TD/H85t1F/2FnbEyZZeF49BfUTGgWvy3NJLfaV0L0VIQQGOuLZGXKOIZGG1VDwotzMRG5tPfgCHZBF2K6c8rdTK5bGL8WuKGgr6l0CHsfmhckOCBoYR4yVx0pFEsmdDzaLLOMoTD04XJ2pUaOHVb6arm9pIKewZQmgZUXM0sDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YSJ2ggPnl5H4A1DKI9dUSC4CE5bV/CHbx8Y2Xhddys=;
 b=XXWQhA/UNLMCFsehdPbPq6uoS4+8ikm62gSjvmjsRvEvxqkK7o4lkkIJ6VeAMGXKD1o++fP0usAfV/CPQIBjUaZUWJYFW+hfnQ7gaPKddKfik21rhXljeRL4Hu3JtkhLbSFb0Ar0VHOngsJMulSOt/BDrU3ETMSC/Uy0xYbOWUFGvxdFL/ik22edDRehdnylEywvhBj8MZpVxi+AgACJsN2UZTL/Kz0+sU+4e2O+tKHlYeAW8qajRULNdSjAqYy+O+pyJ5vq8mUcyTqPs0RqgzSLaY9bUfPbNlB2p9c/iKjMFT9phqjn999thpzfop/I+lfDDpPDRVrfdcQaFNLn4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YSJ2ggPnl5H4A1DKI9dUSC4CE5bV/CHbx8Y2Xhddys=;
 b=NEWA5wpJWOrB+yurqlTM7k+4OC6qu/UCNeeyS7qO8uSUfG74Imx3mECmo0DRsRnlmtT9dDjtstwNUwww73Y7v9iugaqJqDnce4qKhgzJIpjuF2AVOvt26XSqwnFTOQ4L6odAKat+0f81DN+lg9kUJQdh0308rrJR64umJFBJgX0=
Received: from BN1PR13CA0007.namprd13.prod.outlook.com (2603:10b6:408:e2::12)
 by DM3PR12MB9288.namprd12.prod.outlook.com (2603:10b6:0:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 03:31:00 +0000
Received: from BN2PEPF0000449E.namprd02.prod.outlook.com
 (2603:10b6:408:e2:cafe::14) by BN1PR13CA0007.outlook.office365.com
 (2603:10b6:408:e2::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 03:31:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN2PEPF0000449E.mail.protection.outlook.com (10.167.243.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 03:31:00 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 21:30:59 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 5 Feb
 2026 21:30:59 -0600
Received: from [10.136.35.67] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 5 Feb 2026 21:30:57 -0600
Message-ID: <714e7541-7bc1-4087-b780-49cb9a52bc69@amd.com>
Date: Fri, 6 Feb 2026 09:00:56 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpufeatures: Add AVX512 Bit Matrix Multiply (BMM) and
 Bit reversal support
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <bp@alien8.de>, <x86@kernel.org>,
	<babu.moger@amd.com>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<thomas.lendacky@amd.com>, <santosh.shukla@amd.com>
References: <20260205042105.1224126-1-nikunj@amd.com>
 <aYSy2fgLe8FaxxQy@google.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <aYSy2fgLe8FaxxQy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449E:EE_|DM3PR12MB9288:EE_
X-MS-Office365-Filtering-Correlation-Id: a2c2636f-a4d9-4d8b-b96a-08de653025ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T2hjdHFzNW5rSXJQM0FCMEZxMElEUzJJTHJvQlBpaFNlSjdrWEhlTnVUb2tI?=
 =?utf-8?B?Y0wrdTBkbXFVVm1ZdWtkaW9hV0NsY2NSY2d3R1AvQ2xET0pWaHBONW9KV0JX?=
 =?utf-8?B?UEMzZ0VkaHViZkoySmZtdjI3cEZkNmRJdFZPalIzYitrdDNzVC9KSUtjQnIx?=
 =?utf-8?B?eVhrZCtKeG01dXNCNDZXcndvVklBcXNSaS9PdHQxbFVzMk5kRWpUeTQ5Q3cw?=
 =?utf-8?B?REVybGJRN1lhU3daanpQWE9JYllnUmhTQU1OU2c1eEdocU1OZUpXNnVDd3Zt?=
 =?utf-8?B?SnZuVzJMY0ZhQnRhQ25mYXJwWmZBTFRKM0JZWlZiU04xK0kvaVZvcGJNdUVT?=
 =?utf-8?B?MDNCSE5hNURQMUhidGNMVTY0SlpkSllGZitHUjdFNDRuMEEweUwyVStyUG5P?=
 =?utf-8?B?R0ZNZHZpTk9UZFFkTVozSHVuUCtYVGZENlBtbTlyYktSOFR1OTAyemdkNjdK?=
 =?utf-8?B?ekhlL0cyTmloUk9Db3NweEVlTE1MeC8vVUFVcVhDM0hPRUdPSWxoOFA0bzF4?=
 =?utf-8?B?TWdaMEMxQ05TZWpOKzVjaWZQQVgyNkVHcmhrQm5KVWMxaU5vQlNNc1lIYldO?=
 =?utf-8?B?SVJqWVppVnljWkJneGpycWFrR3QyUjF5ZVF6OG1UdThXUnpWckpPZUhjT01O?=
 =?utf-8?B?ZVdqUHFuTG0yYkFBNkZ1SHl4a3lhZ1pkVzRxcjJQRFFFa1ZNRkdyemRWT29Q?=
 =?utf-8?B?QVg1RGN5RUVjM3VuWVVuTTdxcFo1b0VMZ2hDRzJYajRMOXdSSjYwSE8xU2JW?=
 =?utf-8?B?aDRJSTlpWVNObCtiZmRDdmt6MENDRDA2bHNIR29URWdsQ0l6akozSHRkRFE1?=
 =?utf-8?B?cSt2aGhDMzV4NzhsOHV1QTdYSEZPdWVJVGdGS1d1OU51WGpGTXpRZVltVFNV?=
 =?utf-8?B?MlgrTXFKVlp0K096L3N3N1lQUk9vUHVFUC9rVURPeUVWTWZyNWVxV0hsZVlE?=
 =?utf-8?B?NDNxN3YvaXR2ZFhqaEVNNnpReTN0WE8veEVKZXIwZFYxcWF1SXd5Yi92ektr?=
 =?utf-8?B?OG45OEhUdUJEak0xUG82dzJkakxFNU1kSHE4V09JakJnbktVTWtrdUovcTFw?=
 =?utf-8?B?c1BuS0R1cUphMVNBT1pmZE56TEwzdlhkQjZMMmZXNm01YmtsckN5Y0kyRG5E?=
 =?utf-8?B?MnpvTzRSVGF5b3Y1RVFQbWg2K28zL1Q0alhRU3h2UEV0YlRyejgwKzdDVmYx?=
 =?utf-8?B?VVRFTkliOHZGWTRtZS9WbkVxWFFtYmVLVkdEZlVnQ0ozVExZOUozUzdyK3lU?=
 =?utf-8?B?N2lVYWI1VGZ2UVczdS80bGxWeXUzOVg1eklQTkhIUUtvbFFvMUJ5Z2ZRZjN3?=
 =?utf-8?B?MWpMcm9PM20vM0puWmdYQVVSZW53dXgwV1Q0ZXVva1lIK3FrWFREeUsxWmlX?=
 =?utf-8?B?NVBTU0ZUa2tzUzhyNFBOYjcxLzdSTVFGTmpyeDAxbmVkK0FCa3YzWTRrMkhG?=
 =?utf-8?B?MHFheXRWbmEzeCtYZ1dlYldjcm9uQkRUMFVxaG5Ca0JmeHNhTlluOENyYzBq?=
 =?utf-8?B?TXd4aVl6UEJPMDYycGJFdEhkd3BpRHU2Q2t4SUpzMmVXdm1xNlI1UkJlaXBD?=
 =?utf-8?B?dFUraXNyZ1RtSVZJZHVZaGFEUGsvajV2QUx4M3IyQlQ4aHltYjVkZllUODAr?=
 =?utf-8?B?dW00Q3JMcnJiMUQ1bDNzaC8rZUR6T25EcEhxWkhwOU5vT1dwMmlIbCtQeXlD?=
 =?utf-8?B?T0MzWS9ZTlNuN1Y4M0lYZXVvWXh5SkJacTEyN0hOQm9sMlZZYWxJUTc5SW8v?=
 =?utf-8?B?d2loT0IrQURIY0E1U1V2RGdJcDZoUEw0VHR5NEJRWmJXTlUwaklLdEhWbWNU?=
 =?utf-8?B?WkhaaWxyMVM1aXBMUmplREdzRFp6TlMwMjlVSTlMb09Uc1BKM21jTFMxVFhX?=
 =?utf-8?B?d2VCQ2owQmlQZmNycWJkWDI1aEEvWmF1aGFSUjVrRDgzb1pFRFF6RStWUmV4?=
 =?utf-8?B?ZitCdXJmd3FpT05wNmNFRW8xbmE2eWFzZzhlcUR3cU83OEcrT1puY0NRUFAx?=
 =?utf-8?B?Ui9uUXZXVXNzVmhIVTRKZXcxd09wSUlrTkxMVFdzK1g3bEFPU1UzTDBTRXgw?=
 =?utf-8?B?NTFzVEhRRnhVQlJlbUl3RFZzNkM0OUQwTi9oVmd6UUMzN1dZdGVOR3hKd2ZK?=
 =?utf-8?B?eHBIekNCMXNSRnFSOTkvRTRDUUc4OStDYmZibm1obG9tVFMwYTUvRGVHaFJ4?=
 =?utf-8?B?NUgzMmgrbkFza0RodDFaNjlhRzhIMm1rTzA5L3VmRGFYdEFxTDNhc3FtOTJi?=
 =?utf-8?Q?1TFz2sfbHgTkO3QvxFG5a+nqBbY8oyN6jN22BtVQaU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	F1qNxYkIrkLNuzlqt1w3mayIrg15Fupdk2KPqRdtUJnQp93f8CwEc+tMBQSmyH1rUxJIMbrgsDyMs8kXIUdJX1THDZg78G6wxdL2PlKy8vwufROsqy0JoScGvtBjK2oZGHduhyRwyyvJvkkX3W0lmEZfRijK+24n/wrMdhrqIw+6x6BlCTEZZE5YAIxQYxcjOqdZEGmqcA1LmCowyFeUun1B9Z/ckd6Xwblbu1OlD7Qslr7LH+knMDb5ZZBGN7bOFhOUL8s8r5ZNN+MXnTolm76+3yBGb6RJaIasCVRiFe5yvOznrqKcx6igZUX5g22Mc8Q3Ocy2tvsQkjBCCHe7peTLX68TKZFBB8dzNdbUJ3M/bT2s0YH7dDrAETODBiHSDudvGCLF6RFUkyYe0B3zVU+ux8Mj/uT7gOm8iPQNMosQrguPTU8Krk13FQKN0YZX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 03:31:00.1937
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c2636f-a4d9-4d8b-b96a-08de653025ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9288
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70405-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 221DEF9C17
X-Rspamd-Action: no action



On 2/5/2026 8:40 PM, Sean Christopherson wrote:
> KVM: x86: Advertise AVX512 Bit Matrix Multiply (BMM) to userspace
> 
> Because the primary focus of the change is quite clearly to add KVM support,
> not to simply define the feature flag.

Sure, will update.

> 
> On Thu, Feb 05, 2026, Nikunj A Dadhania wrote:
>> Add support for AVX512 Bit Matrix Multiply (BMM) and Bit Reversal
>> instructions, a feature that enables bit matrix multiply operations and
>> bit reversal, which is exposed via CPUID leaf 0x80000021_EAX[23].
>>
>> Expose the support to guests when available by including it in the CPUID
> 
> Advertise to userspace.  The VMM decides whether or not to enumerate features to
> guests.

Ack.

Regards
Nikunj

> 
>> leaf 0x80000021_EAX feature list.
>>
>> While at it, reorder PREFETCHI to match the bit position order in CPUID
>> leaf 0x80000021_EAX for better organization.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>
>> AMD64 Bit Matrix Multiply and Bit Reversal Instructions
>> Publication #69192 Revision: 1.00
>> Issue Date: January 2026
>>
>> https://docs.amd.com/v/u/en-US/69192-PUB
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  arch/x86/kvm/cpuid.c               | 3 ++-
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index c3b53beb1300..2f1583c4bdc0 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -472,6 +472,7 @@
>>  #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
>>  
>>  #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
>> +#define X86_FEATURE_AVX512_BMM		(20*32+23) /* AVX512 Bit Matrix Multiply instructions */
>>  #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
>>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>>  #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 88a5426674a1..b36e8f10f509 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1218,11 +1218,12 @@ void kvm_set_cpu_caps(void)
>>  		F(NULL_SEL_CLR_BASE),
>>  		/* UpperAddressIgnore */
>>  		F(AUTOIBRS),
>> -		F(PREFETCHI),
>>  		EMULATED_F(NO_SMM_CTL_MSR),
>>  		/* PrefetchCtlMsr */
>>  		/* GpOnUserCpuid */
>>  		/* EPSF */
>> +		F(PREFETCHI),
>> +		F(AVX512_BMM),
>>  		SYNTHESIZED_F(SBPB),
>>  		SYNTHESIZED_F(IBPB_BRTYPE),
>>  		SYNTHESIZED_F(SRSO_NO),
>>
>> base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
>> -- 
>> 2.48.1
>>


