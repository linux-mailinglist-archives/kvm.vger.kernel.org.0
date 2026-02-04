Return-Path: <kvm+bounces-70161-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2AXkBpILg2k+hAMAu9opvQ
	(envelope-from <kvm+bounces-70161-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:04:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8DCE3839
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 10:04:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2A477301B438
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 09:02:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568EF395265;
	Wed,  4 Feb 2026 09:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Dm9uAym"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012050.outbound.protection.outlook.com [40.93.195.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BCB52264CA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 09:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770195744; cv=fail; b=HV8Dn+7z36fRpUlZDEhRq9VFZ/iRKxiIaIrvYnsqxlJSaoKD5hVLy4NTEJKWmASTgt7NhToCJa0YuvL406/DAjHQcG/TatzCrmrtafCG8akm7SNHXKL2msBIzcx3DpjSzFNedvyQbzW5V+Mnr0DlwbHiAsloRAbk5cw3pALiw1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770195744; c=relaxed/simple;
	bh=Zd0JMO95Syuwp4rSzkR7PUIBG5GeE4Ukl2ELb5CQtUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JkeXiAZYR3ZnfH5/VfAJCnzVroElvL0yJuYAP8KOYvEfLR+0IJYIoObSb+zZoxF5bSYE24PCiQbo/NZD56THEMM6QXzNA0tVaxBC4xrMyjLDuJrIT8+hNywGddDOSFDdM/sh/VLcXRqIXhTPU6mPBXhT2FzqadEHGZJe1239rjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Dm9uAym; arc=fail smtp.client-ip=40.93.195.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rhH0I4iGcaMhDlS6g1hmBVjqmcMZu4I4kxlnda2/V2VNckG0olHESIavYKxLSFvh6hojimZ/OXbG4Km+CP50JbxH/q5kFR+kHR91g5q0FSgvGvc4t4n1tnbiIuVFg489BXvr5AHNoHHcb/dk3X4qseLXWfDM/Oieb3kDtOKkB+PSfW9MfqF76ciJNYaDKfp3yY8UatNXJdrM3Hx098Aq+l2GGS4yvAFmayCRgIG00fOU+NWXeHxkePFAX8PK4iTRHm6i991EvHby+8YmdimnSU9jABj2ZM3jg9n9mQup2rX3hYW607UHYWc9zWjvHnm9s1ki9q+9sY05LR7obX3NWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaR93bzfy7QQq1feK8HNJYsYg6xGoXybBx6/g/CLpYI=;
 b=ok69f2zbLnaKJy9JGM6HSKe9u18KNfYRr1MJSgl/hw57NQNAbwWillxuYo8hDwI65vN07Oe6CMVKMc0m9WzE1S4xicPgab86tydcMrZT1UTfMaCqelJ9I4oDACS/lrOiH6gp4egcuriD97bAGnzHWHQ7zztrGMBm68TEWyifV4eR7bkliyGmyQ0Ql07wTK4RlvMH/KzIu2cPXtwFU6Qay3bpIh2jtfuScLNBqUP7p2NhG2qnWsO++AH3pSep4fRAINt4JxYJu2dhMyPuwCzrKNOPySSO6IkGlVUaPZ8Q2XhSUV/wO6u9T7HQjXAtrEvynX2AcVe+WupmFFh0XgV/cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaR93bzfy7QQq1feK8HNJYsYg6xGoXybBx6/g/CLpYI=;
 b=0Dm9uAym3wk4L8wvSMDpIv0QwOWdwqdCm1jWm6bTKr2xpUevmIlzBYh6Cudwzbr7LUbTGIcfGwU1UyHvC9EIKKVj7SBYL+7rTnNSuDi0pIryoDcBNgQqLaamTa6a8W40vT3YqTO1L6gIOyEgLMbuTlyNOJE/DLNHpHXfbwr8qOA=
Received: from CH2PR17CA0003.namprd17.prod.outlook.com (2603:10b6:610:53::13)
 by CY5PR12MB6528.namprd12.prod.outlook.com (2603:10b6:930:43::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 09:02:19 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::1e) by CH2PR17CA0003.outlook.office365.com
 (2603:10b6:610:53::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend
 Transport; Wed, 4 Feb 2026 09:02:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 09:02:18 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Wed, 4 Feb
 2026 03:02:18 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 4 Feb
 2026 03:02:18 -0600
Received: from [172.31.180.39] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 4 Feb 2026 03:02:15 -0600
Message-ID: <fe2934f7-0e96-4b76-9993-40b4492e698b@amd.com>
Date: Wed, 4 Feb 2026 14:32:14 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] i386: Add Bus Lock Detect support
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	Shivansh Dhiman <shivansh.dhiman@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
 <20251121083452.429261-5-shivansh.dhiman@amd.com>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <20251121083452.429261-5-shivansh.dhiman@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: shivansh.dhiman@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|CY5PR12MB6528:EE_
X-MS-Office365-Filtering-Correlation-Id: 66095669-e65b-41fe-b6e8-08de63cc19c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkVIckY5V2tWOEdHaFBGTlNhL1g3ekwyTGVNNDR5OEJrUUNIUVVXTVRHbDBz?=
 =?utf-8?B?Q1lBb09nV2l2cXVDUnhGbDh2eUc2SGtINVZtYi9KYnA2bVI4ZVNFSzRDdzZx?=
 =?utf-8?B?anFHV3BzVXUxTnJscm9pbXJ1Q3FlcjVyZGwzMTRXQlFWWHBGVnZyYTJEVWdB?=
 =?utf-8?B?dDNtUDk0bGJNRTdBOVJWZVBZdFphZWREZmoyamZ0N3MreG5CS0llN0M5QzBK?=
 =?utf-8?B?RzNKdU9QekJVMks1elkxUkloSTYvSFBuZ1ZlTTdTNEU3dUdGWHNaYUswcVpU?=
 =?utf-8?B?UDhLVE0yTkxPSDlEa1lOTE1pMWhYcVlXS2l6elcvb0JseHVVa3hodW9MMXE0?=
 =?utf-8?B?MmhvblVROEwvVXlsbzgwWWhocS9QZ2RJNkUzNThOaVdVdzN1UU5aNkRTbjdK?=
 =?utf-8?B?eG9JbFRpUWtPcjVDZThsUUtOQjVwMVlSQklrQkN4aU5CbWxBOUNKWisxVWFR?=
 =?utf-8?B?RGNaTDZUZ1B5Z0ZFdEdZTWR2LzB6WWtZTGR5K2E1K2hRRXAyNmc1b3lWempz?=
 =?utf-8?B?VjlWRmZJYzBtUGJ4ZTJaZndoYVJIdndVQjNoNmJLWGJOdVh6cGxpUEhyYS9V?=
 =?utf-8?B?MXV3S3RlKzVDR3Q0QUt1M3FHU29KOXY1TmwwR1RsRU1IRlRIZk8xeklBYXZF?=
 =?utf-8?B?QVpWRWlRR1JicG9ISWdFcDI2SlpPMnloaHZTTUlSdW4wT1dDUWo4VXpUa1Rz?=
 =?utf-8?B?TGVTdjFOWkpLNjZvdVNzb2thMHYvdnVLeGR6TW4vVVZkaXVFNVd3SmtlaW1F?=
 =?utf-8?B?ckx0QmUrOUdVaEFVQ1ZrTERCWkFRZ0F2V2swTW45VFRSaC9MOFRQVHdzcmwz?=
 =?utf-8?B?dGJjTVNGZk15OFdqRlZXelcyUmptSVgyS2tMbEQweWl0VzZjRktTUWRCQmhX?=
 =?utf-8?B?R2RIRHgxekxMcmdRdnN3ZGpHYVVXaFNoT0JRU2ZpSGVUWHk3VEpzNDMxbU1z?=
 =?utf-8?B?eW9vSjI1WGI3R3hsODY0eGthZjFvUURQZmhVcmpvMlFtSWY2YmZmR2RCQ0FH?=
 =?utf-8?B?UUcyT0JsSkNCZ3BDSUxGVzhJUkFqVU1KVGZHaW5PYTdYNmhtUmVNNFd3Zmsw?=
 =?utf-8?B?dXRrOXZsalhTTHJZUlUrZEtZWllJQTZFd2hXeG95eGNQdVhJbzlsNzJQTUEx?=
 =?utf-8?B?aXNqMWVHNzJxVlBzU1A2ZzZxZUMzVXd0VzBNdjBHYTVIRnEwVU9RS2tLYlY5?=
 =?utf-8?B?WFJ2cGFCbGg0ZnhMd1BHQ3g1VDBna202RVo4aTBLUmk3a0JJaDZOT2Y5WXpz?=
 =?utf-8?B?SjFtVWV6SXBLRUVhWFpBeUhiODZEeStRb25VYXpmalFwL2VRU051TWRmbzVo?=
 =?utf-8?B?VURFMHhXM2RYbHhzUUl2NXd6Sm8zaUhuS05YMUphUU01OWowMmxtcmRlR1J4?=
 =?utf-8?B?ZnJTb25ic1Q3TU9HaHBPRVZveXR2RUVFTXZqVlRiaDZxeWVXSG12Ky9hRkcz?=
 =?utf-8?B?UUlueHNpRTRqekJ6RTVMTjM4Ulk4bkdBUy9NSkk0QTNUVDZQZnA3YXdZbHBM?=
 =?utf-8?B?WStCNzFYYXorMGM4M2t1aVZTNXp5aHZqcVI3ZzlNNWxWNkdHSVNLWWZMb0tH?=
 =?utf-8?B?VjVjREU3QTcxdVJrUnY3Wk5uQnlSenN6cmxoZWM1MWVVTzR1WUFObklRVFJq?=
 =?utf-8?B?MEhJeHZQdU9NdmhVcWNOOUJkeDREcXZjWmRpdW1XMGlRcXRtL1A3dStBVUZS?=
 =?utf-8?B?RTJ2eDFudkFxSWdoYWdBS2haUFBwUDJEVERhR05uQkJ4MXkrNE5MQ0dZcXdJ?=
 =?utf-8?B?QnNlMmRPNTc4WDNna042am5xYTVuYkZjMm56ejJTMVBkNUdVbEVkMkJuelUy?=
 =?utf-8?B?NXlOVkpzYnZtV3BEVUlXM1d2dkthTEhSRG1rL2Nmbm1NRXFHQy9zQVpqNm9M?=
 =?utf-8?B?em45UDVteXJrQUROcDlWUzQzSlRhNFNnR3BQd3lFT2xUdE9UNXNKKzZlZHBy?=
 =?utf-8?B?Wm5MSFhDVm1oRHg2cGdVR00zRGM3cHBZZ1BIb1F6dWE5NUVQRHFhNzNlellZ?=
 =?utf-8?B?eTdOYUVNY3BsZlZBTEQycDNYOTM5STIwR2haMEJUMHZiYVI1NzlYbXNBWWV1?=
 =?utf-8?B?NVdrZTI5amFjcVFYVzBHa09xVEFIWlFwdWVleERzWlhHR25URzNDcHh2aU9j?=
 =?utf-8?B?c2tTNnYvcjZIK1JLbHVjRWlTRkhRaUxRSFo4NFM5d2hwSjIrMEljVkVkdEVF?=
 =?utf-8?B?NzFWaFI5SjZaTTJFaVZmdjJydVovN0N2VzJXNkVyVjlMMENEU21yVGJTS0NE?=
 =?utf-8?B?WjNKK1ZVVC9XeXV4KzFVdTkvM1pnPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xbOb+dYOCFAEHvB2eq7poqcet2A7jHfLrKvKe97VAcDzA4l4bTi2YcqesY9TZi1vPdqdIeuLJUp9HGf8KQAv3iULCUPYErasiR2RG+Mzv37YbaXQewiM1AZKB065YRHRP3LrPQpIEvs0pSDBCok9EicrFlmYzndM5FNXx82oRHelPwoSNv5YxynL9o33FhW2Fi4nllcGnye7B8Hg+Gj+Annc2uuCwTfxeRPMQgMshvtT9erS5nQcgcoVzfBrmIM7kPIaFmXaZmdZOWZ9HfJMEA4qUvyp8fhQU7/LLwnik0+5exKsSrMhGWIHqtGz+OKE4LA9R5z/0RCkI2/S4UxUZf5oUylRptiijIW/IlOSat0tPuY8Z+JPCvjR6pPmA4BUbwg82UqNXcXcolVWyukyEp5iNJLvX1Mh7D0m5VhdD5MHzD7t0AeU4ElyyAu8MDRt
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 09:02:18.9904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66095669-e65b-41fe-b6e8-08de63cc19c7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6528
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70161-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shivansh.dhiman@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: AF8DCE3839
X-Rspamd-Action: no action

Hi,

Gentle ping for reviewing patches for Bus Lock Detect in this series. Would
appreciate any feedback or guidance on next steps. The related KVM patch is at [1].

[1] https://lore.kernel.org/kvm/20251121081228.426974-1-shivansh.dhiman@amd.com/

Thanks,
Shivansh

On 21-11-2025 14:04, Shivansh Dhiman wrote:
> From: Ravi Bangoria <ravi.bangoria@amd.com>
> 
> Bus Lock Detect is enumerated with cpuid Fn0000_0007_ECX_x0 
> bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
> When enabled, hardware clears DR6[11] and raises a #DB exception on
> occurrence of Bus Lock if CPL > 0. More detail about the feature can be
> found in AMD APM[1].
> 
> Qemu supports remote debugging through host gdb (the "gdbstub" facility)
> where some of the remote debugging features like instruction and data
> breakpoints relies on the same hardware infrastructure (#DB, DR6 etc.)
> that Bus Lock Detect also uses. Instead of handling internally, KVM
> forwards #DB to Qemu when remote debugging is ON and #DB is being
> intercepted. It's Qemu's responsibility to re-inject the exception to
> guest when some of the exception source bits (in DR6) are not being
> handled by Qemu remote debug handler. Bus Lock Detect is one such case.
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>      2023, Vol 2, 13.1.3.6 Bus Lock Trap
>      https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
> ---
>  target/i386/cpu.h     | 1 +
>  target/i386/kvm/kvm.c | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 0fecca26dc4a..852b3a33b54d 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -276,6 +276,7 @@ typedef enum X86Seg {
>                  | CR4_SMEP_MASK | CR4_SMAP_MASK | CR4_PKE_MASK | CR4_PKS_MASK \
>                  | CR4_LAM_SUP_MASK | CR4_FRED_MASK))
>  
> +#define DR6_BLD         (1 << 11)
>  #define DR6_BD          (1 << 13)
>  #define DR6_BS          (1 << 14)
>  #define DR6_BT          (1 << 15)
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index ed3d40bf073e..00c44c2de650 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -5864,14 +5864,14 @@ static int kvm_handle_debug(X86CPU *cpu,
>      } else if (kvm_find_sw_breakpoint(cs, arch_info->pc)) {
>          ret = EXCP_DEBUG;
>      }
> -    if (ret == 0) {
> +    if (ret == 0 || !(arch_info->dr6 & DR6_BLD)) {
>          cpu_synchronize_state(cs);
>          assert(env->exception_nr == -1);
>  
>          /* pass to guest */
>          kvm_queue_exception(env, arch_info->exception,
>                              arch_info->exception == EXCP01_DB,
> -                            arch_info->dr6);
> +                            ret == 0 ? arch_info->dr6 ^ DR6_BLD : DR6_BLD);
>          env->has_error_code = 0;
>      }
>  


