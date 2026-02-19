Return-Path: <kvm+bounces-71334-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Zx6+EFKklmlsiQIAu9opvQ
	(envelope-from <kvm+bounces-71334-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:49:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C6EC15C2C2
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 06:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B4E2E3028031
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C142C21ED;
	Thu, 19 Feb 2026 05:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZG3KpxvN"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010035.outbound.protection.outlook.com [40.93.198.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2231862A
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 05:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480137; cv=fail; b=Kxkai6Qxo1MYFkr9TZg/eaCHb/USN7pspFuaeOrFZzCWUL/xFtFhV/94P5YYWYCVL5mf2vmFmgGoeFZpezfHv3SaMOUznJ0Qd1DWRBgIqJVSu2DfMHhe1Af2MPw9nENDlbilt2fk+ajIGjPPImqCn+Gc2K+hwLjfYECnEY8ieXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480137; c=relaxed/simple;
	bh=hcFbDY7Q2J/dPoZUxLDXGxUXJfhNrTgWOy/QZDdpRwM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IofMg2o78AgsdDyI8it1Fugn93iM4ruFsP3PWyxThsYGhxCIaC0wLXGFmaTYF0buKEFBI9neD/L2NgXnOIi9STasHsSoRVRUjU5RAv1qj4kWXJVI5fb/sZoiFDe9kSq5HLZa27m/2bay8aUoTxfBRio9FFMvrZ1fe9QtebN1c80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZG3KpxvN; arc=fail smtp.client-ip=40.93.198.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYWFB5Mn9apJMyoB/M1F9PqxKSK4Ln7gNd+1Cscab2I1Kl+kB1ldXhMkTXbZghFjfjYItqypTatRYamTjvVlDmJaCOegX+d/IrIhrfl7qG39jjF2DvMGwMEvqd7w4HEKLt8KSatmFQqQZY/xrZzDVDdHBJ7aNaD7QHYZMhUVfsYNOP3htHN99p/XidQdpJYYl6EA3Ra3JOZ6obVoYAzFjiJZzsoQCSRqJVwXJIhyuhiQM9K9884V2qSdakK2JhV9P6OcGa61o+MVFYA/J2WVn9f6Nu+WfpB4kSf2QN8rGeeW5ybWc7JSiyl7CHW2RHYVSHb2Sy6RXV0aSlgPNa6OOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+D5BVNCeLnKTeJvbVSE0yhjyvHgKlqD3np3m1CgxDfA=;
 b=rWWQ20qrSGSxjIm3owIjF7CQy7qxll9WXaYSoivN7We+ewSGII5aiGeNyNKpiF8offow4PDBU07lz+2s8mzmioWrw6XkYJ7OUSn+KKvPPAE09Vyn6v5BBscsOZZjBw6dx7a63yrCXqeVELQN19/AEjDS7NpzDXk46SBJQF9KDuBdcS0zkV3Hl1vveXfpTYhu5bIoBrl65MhomXzv/YLlJllKAx3nKnWpGJ0CHFMmD6iClAVx9NQyGd7QCOEzReo0WXuY4dbNatDmRSbSgo43cIe/4V48GlukiQgpp5mwa4USNdB2MI04obGD0u69M/e03ymqHx4c8bFOqIpvHqm5Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+D5BVNCeLnKTeJvbVSE0yhjyvHgKlqD3np3m1CgxDfA=;
 b=ZG3KpxvNDjQqoNALRwKQapGFVBer9PlN+FJ+mN5tJioVY6CghsUtyoMT3ZttPfAAVqxR/84vC5om/0Ws3xVBdbfD3ieyJtEZ0TZv1ZLtPY9Tq3rWyX+bm5zqahSCozboefcYxBu6yAOwFGI/oB2Z+Zc+3P44hNJnXwemNMOLHcM=
Received: from DM6PR02CA0041.namprd02.prod.outlook.com (2603:10b6:5:177::18)
 by DS7PR12MB6262.namprd12.prod.outlook.com (2603:10b6:8:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.15; Thu, 19 Feb 2026 05:48:52 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:5:177:cafe::27) by DM6PR02CA0041.outlook.office365.com
 (2603:10b6:5:177::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.15 via Frontend Transport; Thu,
 19 Feb 2026 05:48:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Thu, 19 Feb 2026 05:48:51 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 18 Feb
 2026 23:48:51 -0600
Received: from [10.143.194.143] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 18 Feb 2026 23:48:47 -0600
Message-ID: <5eaeb7ae-16e1-4877-9c16-40aeb6bd0317@amd.com>
Date: Thu, 19 Feb 2026 11:18:46 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 8/8] DO NOT MERGE: Temporary EXTAPIC UAPI definitions
To: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
CC: Cornelia Huck <cohuck@redhat.com>, Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, "Richard
 Henderson" <richard.henderson@linaro.org>, Naveen N Rao <naveen@kernel.org>,
	Nikunj Dadhaniya <nikunj@amd.com>
References: <20260219054207.471303-1-manali.shukla@amd.com>
 <20260219054207.471303-9-manali.shukla@amd.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20260219054207.471303-9-manali.shukla@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|DS7PR12MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: 08baec3a-7529-4565-bb91-08de6f7a8f8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T3I2SmU3K0pGbXFMVGRCeHlPakkybS9XN3YyTENlMXpGTDFOaWtNQTdCNjBm?=
 =?utf-8?B?eDBOMWNlN3c2YlNlWXNDMHFvQWpTVHlMNStvOWhwaWhBTmF3elFhNTdyTlBz?=
 =?utf-8?B?MzNnbVlxeXRvdkhoalRwSksvUVJsZE1kcWo5V0gwZS91TFRjMlloc1dTcERu?=
 =?utf-8?B?b3BMM3FXZ1hTb1B2ZnJOMzhMN3lUM2lYd09DRkpybGdzSjRrcWJYVHdFM0Np?=
 =?utf-8?B?cVNLUURPemlXZ1IreFd6YnlMSlhJT0Q0UnBvZEFSL2MyMnRWNWRyUUpGaWhu?=
 =?utf-8?B?M1VBUHd4dndJbGlhaCtSYWhpVFFmUjZHakF3bU5jckRjQUFpNGMxSDhYN1hh?=
 =?utf-8?B?M0dHc0hiZUZHbnFIWll4VklnaXAweTBraXd5dTA2RkIvSWhmaXlTNkRtUUxP?=
 =?utf-8?B?MU0wYXV0QjAycTRNelRtV1RibHZQNkZqOUtZZ3BFNDlNUnFNVDloV0Y2RytI?=
 =?utf-8?B?OUxxQ09YVUtWcGNvZVhrMTlQaEc4WnBTb0ZKYTBWaHNVUzF6ak80S2szeTlL?=
 =?utf-8?B?S3VTR3libUpSQ3BqZUhSWGYvQW1zbldJVkJaSVMvMTYveVh5bUFuWHdzWFg5?=
 =?utf-8?B?RFpZSGZzRUtBMFZVL1NEZnNuNE11SmpDUk9KUVozR1oxNDY3U3NNRnBJYWNh?=
 =?utf-8?B?TWM0MkVzRG12RVM5NktzdGI4Ni9zUnppWlpnc3ZzUXpoM3lvSngwdzdzVWhk?=
 =?utf-8?B?N3pSdWVDcjdVeWJkK3NYSTdVTTBBY1VEbDF5bldJeUdibmxlaG16SUFkd2FC?=
 =?utf-8?B?cjVZOU1NOG93dW1QR0tSQ3FYa2tNTHVTN2ZmVGsrdU5xdEUyb3VQWkZKOWFo?=
 =?utf-8?B?TWgzSDJnK3ZiOW9wOU1JQzJiK0JCZGVaVUFDZVNoLzNhUjUrVXhjTGYrRjVG?=
 =?utf-8?B?QjNPNGUwaEtYL21OUUVJVk9qTDd1aGRiOC94akZmcTltZno0eFkxZXQvSEl2?=
 =?utf-8?B?SlJLM1liakNqR3M1RVZoa0NWcTNYTkpVbTBiRjZzZmdqbUl0cDRqZXdIM3Fl?=
 =?utf-8?B?UzBFY3hDb2xhTDlpeDRlZzVNWDYvTndKejNxZW5DTUZIejZSNFRkb2x5SzJQ?=
 =?utf-8?B?UlRvcGxhMmIrRXA1eW81Q0tqZEl0eGNkVi9JNE16V0xmWklyc0tWUlZJcHJ5?=
 =?utf-8?B?MGNpQ3hIajRiam5BRVJnSFhWT1ZuTU8yZ29uWlBQR3lLZWZHNndrWEtIRlVD?=
 =?utf-8?B?a1NTU3krUE5iNldBQVdHVDJocmp3cDBFekZxdmxTVGlyMVF1Y2NEYnc5eHh2?=
 =?utf-8?B?aTl3NnBZSDZHdlA0b1VUNFVWeU52QXo3QzZXTEVwUXJWRWdrL1pLZ0lXL3hI?=
 =?utf-8?B?ekNpSjk1VHNxeU9TUEpReE1hTlpXMEc1Q1FzaUh1bERoSm5yYU1mK3ZOUGZL?=
 =?utf-8?B?d1hsTkoyUSs5SGNSZkcvYjdMeHh4aWtmaDA1QjZNVW9GWWxKYkZNd2RORWVu?=
 =?utf-8?B?cjBpSENoeGtPTXFHRUVxMUV1UlZGN3hsdEREbXNZd3d3ekpsaUdSbDBpRzBy?=
 =?utf-8?B?VldUNmc5cmhoanRPdWFjcHFmM0ZjVW5FKzZRN1dnekhhZGFTYUFJcWhBTWtZ?=
 =?utf-8?B?SmMvU0lDL3Y3NndFRnVTN2RPdm93bEt2QUNaUWE2RWY4ekhvQmprT0ovZVRz?=
 =?utf-8?B?MWlYUURiQXdRbWc0Vi9iRTdkYnYyRU1GSmNKL0Q5SmUwZWRURDMybUN1WUll?=
 =?utf-8?B?eXZOek5wTnIrcEk0SkNuUU1hb21JWDlQdGdQQ3Q4YnNGdFBuM0lhV3JUVlFZ?=
 =?utf-8?B?WHBoQ3NYYkdQR0hFdGFjMEdSdFBScnlWRHVQUUltZ1k0Z1pLR2o0SWFld1A3?=
 =?utf-8?B?RVRlS3NNSWlJTHBqdGM4VTNoVFlNMkQxNitveU5KQStjWHY1dFYvVFlsSjZR?=
 =?utf-8?B?bFhSNDROd1F5ckYxK0oyLzF2cEhlTlYzTlFCNDNDOWdPOHlOTUxOdkR0OUNN?=
 =?utf-8?B?NnpWeTduYjZXTW1kREJiK1B3b2U1dkNWcVdTa2xLbGFZUEdVMi9MbGRJSWNq?=
 =?utf-8?B?dDNjbHV6K0xMT0orOWtkOUNWK1NUWFRybnp6T09OUjh1eXJkN29YU2NPelVh?=
 =?utf-8?B?UnlZQ0JaVW5EN21wanF4USthWFNkNS9aVnpMNXFjOUNrWU83MENmN3lQdmJQ?=
 =?utf-8?B?WDdZQ0hFWk81UzVuVWFuN3lnNDVkVUVYY0prdGVHNWtNbkRmelhvV0tiQVU0?=
 =?utf-8?B?WVY5Y1lNZzBnSlhvK0xvbG5KMHNHSjZKTTE5NzY0dFhtcDdGYjFFNStjSU4z?=
 =?utf-8?Q?ZVfP2hDhh9b3ob/4Yq/1FTYoqpBzlta6kRvO5rt808=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Vl4Ln+Z9hx3kLaapD8DBvG2sdgV/u0CxOuu8oseHkKqhWU+BN2gpqDnqK0bIppudtskEd5KCxDK7ugvQvwtnAHGJhFxgKVQS3smwqBjfFhZL1ouiW3JX6fxDJX6JZZYhhaqhRnLMCIChwmRRjgo+7fLf/vXi5WMpQKiJZEoyVpIjgt38stsmohKIyndNaxvzT68kjHCyYogx7dGrSiN/GD1+taxeWinzJIDl7e931nLtNnqQsSFBAYe4i8uHE7t9luqt5xq9mRKBCGcDn4c0jkSzvVcie4QVOtFfIgbcncxGdhBNKmqEiOBLb+Bm56/0UJgop/w9A7DKoxWZ74sVNG4i7/j2fd+qlcLFPPpl3R47mw7HzkFmXBmMVkJgA21/IfDrZ/2EbhZucDp1MinGWDrS8dseOe1KBlXI1Lih+q2dadv58EXiIE29YUJTnqTa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 05:48:51.7544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08baec3a-7529-4565-bb91-08de6f7a8f8e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6262
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71334-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,gmail.com,google.com,linaro.org,kernel.org,amd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7C6EC15C2C2
X-Rspamd-Action: no action

On 2/19/2026 11:12 AM, Manali Shukla wrote:
> This patch adds the minimal UAPI definitions required for extended
> LAPIC support. These definitions will be imported via the standard
> scripts/update-linux-headers.sh process once the kernel patches are
> merged.
> 
> This patch is provided only for testing and review purposes and
> should NOT be merged.
> 
> Kernel patches: https://lore.kernel.org/kvm/...

Sorry. I missed to add correct link.
Kernel patches for this changes are available at:

https://lore.kernel.org/kvm/20260204074452.55453-1manali.shukla@amd.com/

-Manali

> 
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> 
> ---
> NOT-FOR-MERGE
> ---
> ---
>  linux-headers/asm-x86/kvm.h | 7 +++++++
>  linux-headers/linux/kvm.h   | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
> index f0c1a730d9..04d1a1a527 100644
> --- a/linux-headers/asm-x86/kvm.h
> +++ b/linux-headers/asm-x86/kvm.h
> @@ -124,6 +124,13 @@ struct kvm_lapic_state {
>  	char regs[KVM_APIC_REG_SIZE];
>  };
>  
> +
> +/* for KVM_GET_LAPIC2 and KVM_SET_LAPIC2 */
> +#define KVM_APIC_EXT_REG_SIZE 0x1000
> +struct kvm_lapic_state2 {
> +	char regs[KVM_APIC_EXT_REG_SIZE];
> +};
> +
>  struct kvm_segment {
>  	__u64 base;
>  	__u32 limit;
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index 32c5885a3c..4e67281e99 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -637,6 +637,10 @@ struct kvm_ioeventfd {
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
>  #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
>  
> +#define KVM_X86_NR_EXTLVT_DEFAULT		4
> +#define KVM_LAPIC2_DEFAULT			(1 << 0)
> +#define KVM_LAPIC2_AMD_DEFAULT			(1 << 1)
> +
>  /* for KVM_ENABLE_CAP */
>  struct kvm_enable_cap {
>  	/* in */
> @@ -952,6 +956,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_ARM_EL2 240
>  #define KVM_CAP_ARM_EL2_E2H0 241
>  #define KVM_CAP_RISCV_MP_STATE_RESET 242
> +#define KVM_CAP_LAPIC2 247
>  
>  struct kvm_irq_routing_irqchip {
>  	__u32 irqchip;
> @@ -1308,6 +1313,8 @@ struct kvm_vfio_spapr_tce {
>  #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
>  #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
>  #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
> +#define KVM_GET_LAPIC2            _IOR(KVMIO,  0x8e, struct kvm_lapic_state2)
> +#define KVM_SET_LAPIC2            _IOW(KVMIO,  0x8f, struct kvm_lapic_state2)
>  #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
>  #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
>  /* Available with KVM_CAP_VAPIC */


