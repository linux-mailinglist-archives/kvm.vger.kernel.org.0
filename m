Return-Path: <kvm+bounces-69337-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MDFFJ97xeWnT1AEAu9opvQ
	(envelope-from <kvm+bounces-69337-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:24:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 12769A044D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:24:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5E18F300F177
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 11:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C473451B5;
	Wed, 28 Jan 2026 11:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vpLS0wS7"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010015.outbound.protection.outlook.com [52.101.193.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C40344DB5
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 11:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769599446; cv=fail; b=FeIFLMKoXqzxGlu/5qUQzj4H7ddwvDl6nea/fPcPVSNdRYTv464CbF8F8ib0ghcW0QYY4dEM9hDKaoe2BeGmhXbgJnCe58BSmKXT5hqcNFY5lEEqgvf4W04OnpxK5QfbFM8qxxT4mf827mrmmd2NrJsVhJ6MAGd7sd8flSdwJPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769599446; c=relaxed/simple;
	bh=Z+36HqHSg0i3Qm7Crw2OFHkBiQ/aRG70R/3L0iWjFAI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=lJ/WyVycqMtaQDFvDETTA9qxQL32ILhCFpx5LpbU50u/GP6oxWGS2ggdzi5w6BED0BrhNSck4Rx2CEBvn0BS3/NJ5I/PvhIIGfxQqSYrnULyZV2BHHPTucyR4/V1eIlaC5dsN3Vvo6O+f41B1a1EanQfH4uYxNC7T2ZJmvxLuho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vpLS0wS7; arc=fail smtp.client-ip=52.101.193.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zTgq90VTmb5vuajJNGRTdPysLUjaRnR1hwJF/AP7NxbYMZP6aPf1nlz6kDhp9mhNPfsBM9NufOEcMweHxTdD+rVCvLLFi6v6Q4EjkZgIORtFguEc9WmfQyhRaDk4f5BQ//eyWFz3juWlHCqBQ4E9123MxVBHb1eesL66pQmgOyFJcXdkPZl5c5Lv1PWUNeTr01FtEfGzEFx5v+Gh0oFZduZKBLpFr8cfCcD8NREmrW5oYzJm8yMClHAD+nhB8v9VU938XXg2vtAsdaSfW+Nsamg0OLOqvzSthZGo7i+sB+aKYx1s5LR3ParI9OGNP60iPZQ2exvrBpS36FGhBQtDyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K01XKBan2s8SSdhI7tQSzvBSWvGCZ1BqtySh7Ed3NhQ=;
 b=s3rByu7ve+RsVjaow9vjEzTy7Kh+JnbejUfdEkx1GOEz7Pg3ehAyfLXgt4RHx9phZwik8wQXCctBXJgaBMHGSmbJaNjefwPHUOzS/xqsDg1nTV/SI/QSCRjkqGngUUV6YFHgpp5niTJ3NiRDHeA1wp74TiN19R1rmXXdDd73Ft0XZkMd/IkXgWknWar34jliVT1Y2h/RFmFllakwfGnYlXtIfLTueXSZfpDeyqVwDFCwm42EHPIoJk4A6Ts/xRKTw9vaLXNorgmPrbFHxS8IpZIHH8maKHmeiKvpq9PdqkYtpBPyWBISUQfLkCmasEemlRzf22LiTAkskcEb1+JmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K01XKBan2s8SSdhI7tQSzvBSWvGCZ1BqtySh7Ed3NhQ=;
 b=vpLS0wS7ojYaQtAo3KlYtKUNfci0A+Nv8ukWexYJyZ+18feh4L7sKTuFeZ1lPFa5gmPbh2W5HDBxkSNaYgbSFojhDgkdOTDAbhBb2sTf/jeLSk7/hIOJwPBBb6w3ky9E+mqiV5yOOL0I67ia9pgpDGsJVBXMHWrH9nzSOs++CDI=
Received: from BYAPR07CA0071.namprd07.prod.outlook.com (2603:10b6:a03:60::48)
 by MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 11:23:56 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:60:cafe::a1) by BYAPR07CA0071.outlook.office365.com
 (2603:10b6:a03:60::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 11:23:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Wed, 28 Jan 2026 11:23:56 +0000
Received: from [10.252.204.230] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 28 Jan
 2026 05:23:51 -0600
Message-ID: <4bfbff72-aff8-417b-9672-b7a1740e476e@amd.com>
Date: Wed, 28 Jan 2026 16:53:48 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 5/5] amd_iommu: Add support for upto 2048
 interrupts per IRT
Content-Language: en-US
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	<qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, <vasant.hegde@amd.com>,
	<suravee.suthikulpanit@amd.com>
CC: <mst@redhat.com>, <imammedo@redhat.com>, <anisinha@redhat.com>,
	<marcel.apfelbaum@gmail.com>, <pbonzini@redhat.com>,
	<richard.henderson@linaro.org>, <eduardo@habkost.net>, <yi.l.liu@intel.com>,
	<eric.auger@redhat.com>, <zhenzhong.duan@intel.com>, <cohuck@redhat.com>,
	<seanjc@google.com>, <iommu@lists.linux.dev>, <kevin.tian@intel.com>,
	<joro@8bytes.org>
References: <20251118101532.4315-1-sarunkod@amd.com>
 <20251118101532.4315-6-sarunkod@amd.com>
 <c22ec7f4-4f49-4c39-89cf-be20429bb387@oracle.com>
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <c22ec7f4-4f49-4c39-89cf-be20429bb387@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: de03a3ed-35aa-49fa-2d1b-08de5e5fb996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHJQc1QzL29Jd2RjbSsxOXkrV3J1aFBHRUJzMkJlQkRHZmYwZ3ljSkpBZjZw?=
 =?utf-8?B?eHFKamFwYVBxaFd5eEhhaTVjYkIySHRaOUZBTm9VZXc5NDAwZS9qUWdxYTlw?=
 =?utf-8?B?WEVVTFd3MUhHQ2I3RGhpNGovaDNKTEhMLzdydkNBb3JOWS9qdG5FUlVaM09u?=
 =?utf-8?B?WWFSSmhMQk1UMlVyZ2JUVTBCN1Z2eVNhQkE1Y1NuTUpCMlVFL1F0b0lCNnpD?=
 =?utf-8?B?bUdQODA1N21lWm1yMjE1Rzd1WGZ2UzBJM1lqdm1MSlJLZFIxUE1CN09ocWdx?=
 =?utf-8?B?ZVRZcGVSMWdZVlpTSXR2OFJ6dW9oZWhtRkF0cERzTW83QlFrbG9YNFF2RXlB?=
 =?utf-8?B?ek5lcE1QYlM5SUd0WGRNeU5CWmRXUTNJQ1BiNEd5ZFYwcHVVOUpNQnlvRERi?=
 =?utf-8?B?WmdsR3hoOHJQNXdaVXJNYSs4L0FrdHduT3pCQXJWd2N5RWpFZ1dJUlEya09O?=
 =?utf-8?B?ekVRM0dIYVpldWxUdzhrVy9rS0ppVFZOT1Q3MFU3TnVOZmNQSUNqcXNqMU1G?=
 =?utf-8?B?OUprRzlxN214NnB5WmZ5Z3E2SGh5VTBxR1luaUlXNWpSR0gwZTZ6RDVFdHBL?=
 =?utf-8?B?cTVxeWQ0cHZQV1lvMTZNbVAwenpHWkd0N3N5Tm1GQWpLK3pCbUNUT1VTZ0ND?=
 =?utf-8?B?U1BuR0JlMVNZNitpWkNlV0dTRTJyQU1ucVdHcXRacnJXMW1qblJGcDZDaGoz?=
 =?utf-8?B?cWZ0ODhpdlBWU01aVnUxZ1JpYlY5L0ZMNS9rc3AvY0hGcktJZWJqdkFhVExs?=
 =?utf-8?B?My9UQjloaWszMFlNUElPRUNVUzY3TnBGYktPczJXZjVwYy9RYnI3bm85dzhG?=
 =?utf-8?B?UUhSdFVrUFMvT1liR2ZKTm1UcnVGWnRtU3NDbVlCUEkyUXNSa04yMS9pQi9L?=
 =?utf-8?B?WERkV0gyRmNick93NytsSVRWOUlrU0dPaEVZYi9IczI4SjlxMU5UZjJUYmJS?=
 =?utf-8?B?TlorajhNeXFJRWxtUFF4aHVQS1c0WmR2YStxdzkyYzJVaEtQUU5ZcjVVNjJi?=
 =?utf-8?B?RGFETGMva3BQOHNzNHlUVE1VTG5GME01SGhDd3oyZmNvQXBxc0l2RzVOd2V5?=
 =?utf-8?B?STJrT2JpNFRjT3Y5L0RxOXpQaTdjcUt0QWtJdTFjdXRwSGxMUHExZmU5aWNM?=
 =?utf-8?B?TTVkTUNBbmZWSVd0M1g5c01PWExFRFd2cmtBOGZPV2hZTTRJc01icGpHbEhM?=
 =?utf-8?B?cDFiNnlBTHJvT2xiTGF5NzVBRVpHN0wxY3lTeGZOWjRudWFHK0tNbWpaang4?=
 =?utf-8?B?WlYyQVM2NUlqM2JZWFRzZE83RGppc1ZPQit4RlVkMlZiV0lmTWFkTDh3d1ow?=
 =?utf-8?B?UmorMXpoYlNaUFF4ZTh6UE1NdUZZdkdVMUh5ejlJM1I2L0pVamFqM3BRM0FI?=
 =?utf-8?B?ckxOUFVtQ0V2bWI0NlFZcDJJZlRESXFKNHN0SXVCQTlDTzgzWEdwYzFsQTRK?=
 =?utf-8?B?S1hPMHpCL2hqcTZ6ZHE3eW1LbTN4TjRmZ1RUbTBZeXlsWWpKMWMzdmN5SzNG?=
 =?utf-8?B?amIzTmxJTnd1c1JhdkhPUUN6K1RRclpLSk9SNGxXcEpFYmU5MkV0aTZZenB3?=
 =?utf-8?B?ZjhDdXA2RjRZNmNOVkpRVzVGcmR0aERUZG9LQmI5UEZLS1JIR2Nzbzdya1Vh?=
 =?utf-8?B?dFR5WVR5QVBtVWF6TEU5aEZGSFNwM21vUDVaNVFkaGo2bDVyMkt5TS9id3Mv?=
 =?utf-8?B?MnpyY1RWVWx1VXZVV3R5S3h0MjlsUjdnbGpzcHUrT1dqb0JNUlE3clovdFhO?=
 =?utf-8?B?WVFDWGpMVjlxeDB5VEF0cjBsdkRUbzNDOFc0STRGSXpGK3ZOSzczSjlzMHRx?=
 =?utf-8?B?VWlwVFp1aEw0bER5M2dPVVJyczBwY2FvREd3Zk1ZREJQTW5hWlpHRFB1STNQ?=
 =?utf-8?B?eXU4b1J6ZGoxZmZXRE5CejRLTURkRHI1em43L2VrK1Iyb1kyMEtwekFRblF5?=
 =?utf-8?B?WjlmTzRmL05YSFNXUlVKUFlMYk92bDhPbU5ic1NlK2V0Ym1rTkJDdTBPOG94?=
 =?utf-8?B?dTRaYUpoNmJnMXkyL2d6eWJmMnRjR011ZDNZcmUvbjFWMEtWVlRvT3hsWjJl?=
 =?utf-8?B?UHcwclpaMGNFdmFWTDRYZnRmWVV2bWgyR01MdVNwTFlKZi94eWN6NUVlZ3By?=
 =?utf-8?B?aGN1TFFCa3dQZTd4elY3WDhpRzFIMXR2YkFoYlMwcWl2ZlBSMVpQdlF3LzdM?=
 =?utf-8?B?T29xeW9XZCtrMm00UzQzcURFWTVMMHMzNy9TYmsrdWR5UndNZGRYR2xNMHFK?=
 =?utf-8?B?RTQxL3RKQWdRRXEzRkhRZW93RDJBPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 11:23:56.0704
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de03a3ed-35aa-49fa-2d1b-08de5e5fb996
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69337-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,google.com,lists.linux.dev,8bytes.org];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sarunkod@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 12769A044D
X-Rspamd-Action: no action



On 1/28/2026 7:29 AM, Alejandro Jimenez wrote:
>
> On 11/18/25 5:15 AM, Sairaj Kodilkar wrote:
>> AMD IOMMU supports upto 2048 MSIs for a single device function
>> when NUM_INT_REMAP_SUP Extended-Feature-Register-2 bit is set to one.
>> Software can enable this feature by writing one to NUM_INT_REMAP_MODE
>> in the control register. MSI address destination mode (DM) bit decides
>> how many MSI data bits are used by IOMMU to index into IRT. When DM = 0,
>> IOMMU uses bits 8:0 (max 512) for the index, otherwise (DM = 1)
>> IOMMU uses bits 10:0 (max 2048) for IRT index.
>>
>> This feature can be enabled with flag `numint2k=on`. In case of
>> passhthrough devices viommu uses control register provided by vendor
>> capabilites to determine if host IOMMU has enabled 2048 MSIs. If host
>> IOMMU has not enabled it then the guest feature is disabled.
>>
>> example command line
>> '''
>> -object iommufd,id=fd0 \
>> -device amd_iommu,dma-remap=on,numint2k=on \
>> -device vfio-host,host=<DEVID>,iommufd=fd0 \
>> '''
>>
>> NOTE: In case of legacy VFIO container the guest will always fall back
>> to 512 MSIs.
>>
>> Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
>> ---
>>   hw/i386/amd_iommu.c | 74 ++++++++++++++++++++++++++++++++++++++++-----
>>   hw/i386/amd_iommu.h | 12 ++++++++
>>   2 files changed, 79 insertions(+), 7 deletions(-)
>>
>> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
>> index 3221bf5a0303..4f62c4ee3671 100644
>> --- a/hw/i386/amd_iommu.c
>> +++ b/hw/i386/amd_iommu.c
>> @@ -116,7 +116,12 @@ uint64_t amdvi_extended_feature_register(AMDVIState *s)
>>   
>>   uint64_t amdvi_extended_feature_register2(AMDVIState *s)
>>   {
>> -    return AMDVI_DEFAULT_EXT_FEATURES2;
>> +    uint64_t feature = AMDVI_DEFAULT_EXT_FEATURES2;
>> +    if (s->num_int_sup_2k) {
>> +        feature |= AMDVI_FEATURE_NUM_INT_REMAP_SUP;
>> +    }
>> +
>> +    return feature;
>>   }
>>   
>>   /* configure MMIO registers at startup/reset */
>> @@ -1538,6 +1543,9 @@ static void amdvi_handle_control_write(AMDVIState *s)
>>                           AMDVI_MMIO_CONTROL_CMDBUFLEN);
>>       s->ga_enabled = !!(control & AMDVI_MMIO_CONTROL_GAEN);
>>   
>> +    s->num_int_enabled = (control >> AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT) &
>> +                         AMDVI_MMIO_CONTROL_NUM_INT_REMAP_MASK;
>> +
>>       /* update the flags depending on the control register */
>>       if (s->cmdbuf_enabled) {
>>           amdvi_assign_orq(s, AMDVI_MMIO_STATUS, AMDVI_MMIO_STATUS_CMDBUF_RUN);
>> @@ -2119,6 +2127,25 @@ static int amdvi_int_remap_msi(AMDVIState *iommu,
>>        * (page 5)
>>        */
>>       delivery_mode = (origin->data >> MSI_DATA_DELIVERY_MODE_SHIFT) & 7;
>> +    /*
>> +     * The MSI address register bit[2] is used to get the destination
>> +     * mode. The dest_mode 1 is valid for fixed and arbitrated interrupts
>> +     * and when IOMMU supports upto 2048 interrupts.
>> +     */
>> +    dest_mode = (origin->address >> MSI_ADDR_DEST_MODE_SHIFT) & 1;
>> +
>> +    if (dest_mode &&
>> +        iommu->num_int_enabled == AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K) {
>> +
>> +        trace_amdvi_ir_delivery_mode("2K interrupt mode");
>> +        ret = __amdvi_int_remap_msi(iommu, origin, translated, dte, &irq, sid);
>> +        if (ret < 0) {
>> +            goto remap_fail;
>> +        }
>> +        /* Translate IRQ to MSI messages */
>> +        x86_iommu_irq_to_msi_message(&irq, translated);
>> +        goto out;
>> +    }
>>   
>>       switch (delivery_mode) {
>>       case AMDVI_IOAPIC_INT_TYPE_FIXED:
>> @@ -2159,12 +2186,6 @@ static int amdvi_int_remap_msi(AMDVIState *iommu,
>>           goto remap_fail;
>>       }
>>   
>> -    /*
>> -     * The MSI address register bit[2] is used to get the destination
>> -     * mode. The dest_mode 1 is valid for fixed and arbitrated interrupts
>> -     * only.
>> -     */
>> -    dest_mode = (origin->address >> MSI_ADDR_DEST_MODE_SHIFT) & 1;
>>       if (dest_mode) {
>>           trace_amdvi_ir_err("invalid dest_mode");
>>           ret = -AMDVI_IR_ERR;
>> @@ -2322,6 +2343,30 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
>>       return &iommu_as[devfn]->as;
>>   }
>>   
>> +static void amdvi_refresh_efrs_hwinfo(struct AMDVIState *s,
>> +                                      struct iommu_hw_info_amd *hwinfo)
>> +{
>> +    /* Check if host OS has enabled 2K interrupts */
>> +    bool hwinfo_ctrl_2k;
>> +
>> +    if (s->num_int_sup_2k && !hwinfo) {
>> +        warn_report("AMDVI: Disabling 2048 MSI for guest, "
>> +                    "use IOMMUFD for device passthrough to support it");
>> +        s->num_int_sup_2k = 0;
>> +    }
>> +
>> +    hwinfo_ctrl_2k = ((hwinfo->control_register
> We need to check that hwinfo is a valid pointer before attempting to access
> any of its fields. The code in the line above causes a segfault in the
> common case where we are just using the default VFIO legacy backend and no
> new options.
> Even when trying to use the new feature (numint2k=on) and iommufd backend
> in QEMU, if the host kernel was built with CONFIG_AMD_IOMMU_IOMMUFD=n
> (which is currently the default), the ioctl IOMMU_GET_HW_INFO will always
> return NULL data and hwinfo is also NULL at this point, so we crash and burn.
>
>> +                       >> AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT)
>> +                      & AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K);
>> +
>> +    if (s->num_int_sup_2k && !hwinfo_ctrl_2k) {
>> +        warn_report("AMDVI: Disabling 2048 MSIs for guest, "
>> +                    "as host kernel does not support this feature");
>> +        s->num_int_sup_2k = 0;
>> +    }
>> +
>> +    amdvi_refresh_efrs(s);
>> +}
>>   
>>   static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
>>                                      HostIOMMUDevice *hiod, Error **errp)
>> @@ -2354,6 +2399,20 @@ static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
>>       object_ref(hiod);
>>       g_hash_table_insert(s->hiod_hash, new_key, hiod);
>>   
>> +    if (hiod->caps.type == IOMMU_HW_INFO_TYPE_AMD) {
>> +        /*
>> +         * Refresh the MMIO efr registers so that changes are visible to the
>> +         * guest.
>> +         */
>> +        amdvi_refresh_efrs_hwinfo(s, &hiod->caps.vendor_caps.amd);
>> +    } else {
>> +        /*
>> +         * Pass NULL hardware registers when we have non-IOMMUFD
>> +         * passthrough device
>> +         */
>> +        amdvi_refresh_efrs_hwinfo(s, NULL);
> This call with hwinfo = NULL causes a segfault as I mentioned above. The
> code in amdvi_refresh_efrs_hwinfo() needs to be hardened.
>
> Thank you,
> Alejandro

Hi Alejandro

Good catch, I caught this but somehow forgot to fix.
Thanks for pointing it out

Thanks
Sairaj

>> +    }
>> +
>>       return true;
>>   }
>>   
>> @@ -2641,6 +2700,7 @@ static const Property amdvi_properties[] = {
>>       DEFINE_PROP_BOOL("xtsup", AMDVIState, xtsup, false),
>>       DEFINE_PROP_STRING("pci-id", AMDVIState, pci_id),
>>       DEFINE_PROP_BOOL("dma-remap", AMDVIState, dma_remap, false),
>> +    DEFINE_PROP_BOOL("numint2k", AMDVIState, num_int_sup_2k, false),
>>   };
>>   
>>   static const VMStateDescription vmstate_amdvi_sysbus = {
>> diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
>> index c8eaf229b50e..588725fe0c25 100644
>> --- a/hw/i386/amd_iommu.h
>> +++ b/hw/i386/amd_iommu.h
>> @@ -107,6 +107,9 @@
>>   #define AMDVI_MMIO_CONTROL_COMWAITINTEN   (1ULL << 4)
>>   #define AMDVI_MMIO_CONTROL_CMDBUFLEN      (1ULL << 12)
>>   #define AMDVI_MMIO_CONTROL_GAEN           (1ULL << 17)
>> +#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_MASK        (0x3)
>> +#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT       (43)
>> +#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K          (0x1)
>>   
>>   /* MMIO status register bits */
>>   #define AMDVI_MMIO_STATUS_CMDBUF_RUN  (1 << 4)
>> @@ -160,6 +163,7 @@
>>   #define AMDVI_PERM_READ             (1 << 0)
>>   #define AMDVI_PERM_WRITE            (1 << 1)
>>   
>> +/* EFR */
>>   #define AMDVI_FEATURE_PREFETCH            (1ULL << 0) /* page prefetch       */
>>   #define AMDVI_FEATURE_PPR                 (1ULL << 1) /* PPR Support         */
>>   #define AMDVI_FEATURE_XT                  (1ULL << 2) /* x2APIC Support      */
>> @@ -169,6 +173,9 @@
>>   #define AMDVI_FEATURE_HE                  (1ULL << 8) /* hardware error regs */
>>   #define AMDVI_FEATURE_PC                  (1ULL << 9) /* Perf counters       */
>>   
>> +/* EFR2 */
>> +#define AMDVI_FEATURE_NUM_INT_REMAP_SUP   (1ULL << 8) /* 2K int support      */
>> +
>>   /* reserved DTE bits */
>>   #define AMDVI_DTE_QUAD0_RESERVED        (GENMASK64(6, 2) | GENMASK64(63, 63))
>>   #define AMDVI_DTE_QUAD1_RESERVED        0
>> @@ -380,6 +387,8 @@ struct AMDVIState {
>>       bool evtlog_enabled;         /* event log enabled            */
>>       bool excl_enabled;
>>   
>> +    uint8_t num_int_enabled;
>> +
>>       hwaddr devtab;               /* base address device table    */
>>       uint64_t devtab_len;         /* device table length          */
>>   
>> @@ -433,6 +442,9 @@ struct AMDVIState {
>>   
>>       /* DMA address translation */
>>       bool dma_remap;
>> +
>> +    /* upto 2048 interrupt support */
>> +    bool num_int_sup_2k;
>>   };
>>   
>>   uint64_t amdvi_extended_feature_register(AMDVIState *s);


