Return-Path: <kvm+bounces-70438-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPWYNu/ghWn+HgQAu9opvQ
	(envelope-from <kvm+bounces-70438-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 13:39:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 522CFFDA87
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 13:39:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE45D30293F8
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 12:38:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8432D3AE6E0;
	Fri,  6 Feb 2026 12:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D+N3q++M"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011024.outbound.protection.outlook.com [52.101.62.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922783A0B0E;
	Fri,  6 Feb 2026 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770381533; cv=fail; b=ulNoGUuTPuSWHR18JsttDgfwL8l20se/ZlD/zjbgW929RCITKQWW3ux2ShwDm7suk+G6fSNTcUYBGaZVDq63KIC86VLWAQheIcM/Rxjb8ksi/zBjqco8dpXaX+wmzzHkw/1C8OmHdCtxBuRypwxiFBSodHJuPONid1Mbn10pOh8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770381533; c=relaxed/simple;
	bh=ARbkfi9LLOk5e8aaBz1jCamOkECqelELqe2w4pntl3M=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=OB+DYPZ9Oip78jxK1r+Jg20FwHf4BMrYx0WBQwfHhnqbRpkIHW6ztO1dTAFAYsBjM8XCovRB1u+a4yH6zhEzh+ydTY8k0xel0nfSqYe0fIm67cdu6dqfBJaxtO25iPyx3xykkUBIoyREPZCixeFmdhXkAczd4B8TH96hhOgSseY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D+N3q++M; arc=fail smtp.client-ip=52.101.62.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOozCDGoPVQqJ8SdBvZfXcXmPHZE95dYjn4YWO7wtJqQSAT9zYF5kaUApVnz3fVGR9U2vJgZg6/2VCymJnCYYRN1J0u8hOPtuS7LKXEpq3luX+hqDu8fgwXGEi2cTg+XgbEKxhnXuZRYOXwkQSW6MUDMy8TWp5EhFKx4eYAkop7muE/ju+gJuCttEDCf4Yx1E3TyTIb/9RmjcpPGeZHAdFNHiGr55T6yfSwc1PS/oqb+cnHq5M8Yh5k0O9K/QO/4jj0f5AWlRbNUQEOu01NmyDOdSqoXjsqs8QWwUJEgfWuf69Z0FP77gEa8NZsObVGHjbYI5/Qteo5xwOFANm62jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cctYKRtMJ1pFgsyURC1OC79sIMDQOIT1X0V3og7e30=;
 b=Yju4vPk1hzT2+kNzjyZ8ZJOjc6ZfP0DOb9dlPPUbaA78pLlH3h0p/3zW/tLrrAPMK0T18M6GApyrLqEysw1tyj8m00fY+3fsSsl7xMh62ve8glUgdPJ2CwCHPdERXqBps/Y4jsh31VKrbjJdjtQDBTKHoI3lbR5CvSKj+LRD1DrQIP/K+UEtgUj9O4IzJH+JfMDGRAq7kqs76Q/Wwzcu2TpB0KAjy5qMt3kWh2N/8GAvUOss6eMD1ZfmAn9tUuXqYws9Hu0jAQrhi8zrJkDAhbsdhnFesAEy7uJ4yQnK2EicxH9k4OLqeFbiwxmcNRt7wnayiyyxUJbE73H282aZ4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cctYKRtMJ1pFgsyURC1OC79sIMDQOIT1X0V3og7e30=;
 b=D+N3q++MvjVqRHuP0Dxw6g0myH0AhGfTibpGBtkoUx0eMh0hsn4LOSN9REV4flJxwz+wUZsSaqNIVp8fXjDleN1AMKIpKtk0osEwke9Z5X9URBF1oZ2o9E3ymqOCCYGnj8tHV4SdIqQvAoAjEcVcjZjlf1gB9brIpsCeP2isrQo=
Received: from SN6PR08CA0011.namprd08.prod.outlook.com (2603:10b6:805:66::24)
 by DM6PR12MB4449.namprd12.prod.outlook.com (2603:10b6:5:2a5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 12:38:48 +0000
Received: from SA2PEPF00003AEA.namprd02.prod.outlook.com
 (2603:10b6:805:66:cafe::e8) by SN6PR08CA0011.outlook.office365.com
 (2603:10b6:805:66::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.14 via Frontend Transport; Fri,
 6 Feb 2026 12:38:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SA2PEPF00003AEA.mail.protection.outlook.com (10.167.248.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 12:38:48 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 06:38:48 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 6 Feb
 2026 04:38:47 -0800
Received: from [172.31.177.76] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 6 Feb 2026 04:38:43 -0800
Message-ID: <5cf9358a-a5c3-4d4b-b82f-16d69fa30f3e@amd.com>
Date: Fri, 6 Feb 2026 18:08:38 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/fred: Fix early boot failures on SEV-ES/SNP guests
To: Tom Lendacky <thomas.lendacky@amd.com>, Dave Hansen
	<dave.hansen@intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <bp@alien8.de>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <xin@zytor.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<x86@kernel.org>, <jon.grimm@amd.com>, <stable@vger.kernel.org>
References: <20260205051030.1225975-1-nikunj@amd.com>
 <9c8c2d69-5434-4416-ba37-897ce00e2b11@intel.com>
 <02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com>
 <103bc1df-4caf-430a-9c8b-fcee78b3dd1d@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <103bc1df-4caf-430a-9c8b-fcee78b3dd1d@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AEA:EE_|DM6PR12MB4449:EE_
X-MS-Office365-Filtering-Correlation-Id: f70f6ef2-fe66-466f-703f-08de657cacd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c28rVitUQndkQ2hhV3hiZFRzdnZ6QTdCVHZnQ3pWNmVROVRweUU1NXlHZFJx?=
 =?utf-8?B?TjdHRWpSTkxla3NlbnNXbThYS1pRVk85U2xDeG5BU0lxeVM0M3dGNTl2bHVp?=
 =?utf-8?B?d25KVDZYTXdCb1Njeml6RFVIdXBIbVBpYWd1SWVZRWppNUYxc0g1QXlWbTVi?=
 =?utf-8?B?a2VZcHBuQzhzbmZWbWdHaDIyeGg1N3IvV3owL2ltcnR5Y1dLc05yQUFCbG10?=
 =?utf-8?B?Uk92alQ5VWhrai9jOHZLb21Rd29WdGxXc3ZJN0h3OWZJR3F0ZHB5UTlYemRC?=
 =?utf-8?B?UjA5OThhaTJwcFErZjhXVTJBTmRzaEFzSVQwVTNaS2l0QmduOWNpS0dWQzFN?=
 =?utf-8?B?MU53NnNKRGdWcHBPSkxtMUQraE13Zk53MHJmOGh6eThpdmhmQTJGNks0ZVlY?=
 =?utf-8?B?VVVkR0pYbFA4UTZ2TlJJNmNmNi92V0tCWnYwRDNZSmtuNmN2UE9TaUozM0tz?=
 =?utf-8?B?Z2Y1QlFCTkdoeDNmZDRuN2JrYjIreGMvbjUybDMzQkZuQUVrNDlSa1dobnRF?=
 =?utf-8?B?NUtZZnZmdXBrRkM3RnNUbDJWK1J0Uzg3SllVRUhIRFRNMTdsM3hweS9pcEM4?=
 =?utf-8?B?Y3BlT3doZWR4NlhsNTZEY2toVmJkRDQwbXFGZVpqbmFpMVY4ZDg5ZXZwVDRa?=
 =?utf-8?B?SkdjVlRIRTFqbEE1VGg3L1o0VHA5Q0pFQ0Z4RzErakZCM255dmFsNHdnLzhJ?=
 =?utf-8?B?VHA4ZEQrTGZCd2kwZ2tWbldlUDF2M0Ewd04xcXA1cE04cHpvZ1hHTHBvVjhm?=
 =?utf-8?B?NTF4VE5BZWhGRzh6OHVUV3djZ3ZLVWdXY0RzK3UvKzdtUTI5c1phbm9jQXIr?=
 =?utf-8?B?UDNyd29yTzJxWm0xRHVoMTVxWUdwVmwxSHhhMUtSVDZRNXgraTd5dGs0b25W?=
 =?utf-8?B?QlZ6YXVzbExIZGRUN1RXeHV1cEZ5Y3djeVlaV3BCN0FXcnVTTzRXRnNjWlZG?=
 =?utf-8?B?TFNkZnFDNDFPMWlaMEJZbDZpYmR5dTlVb3o1aG1wVDZWMkwweXpNY1hFUGpO?=
 =?utf-8?B?VXd0VkNtS0tXZ2JuK1lZWHZrRHl6WE1SOXdTNVVDSElsNk8xZmFOYW5McDdh?=
 =?utf-8?B?MExqRkZNMDk4S0FkYUJxdjQ4WkxaRXdER3JldUdaTGhUSW1OYUYxbGExQ3RE?=
 =?utf-8?B?NTNMRXN2Mm9ZaWdlSHhtR0I3QUZRNDZEZ0hQY3d6UjdZOENCZkx3TmQ5RnF2?=
 =?utf-8?B?WlJpa2Zyc1lBNk01SWsybldaZHJIT2FjVzdka083SHlOdElrN2ZGKzVTVk1R?=
 =?utf-8?B?R1ZjbzVZemRrUGhhNGViWCtqWmcvb1VOSklNZ1AweENzOWNOUU14Y29FWTNs?=
 =?utf-8?B?eGxBS09HcXlnNXVuRllBSU1OUThZZG55UGZrVlVCOU9xUnFQd2VKWDZibU9p?=
 =?utf-8?B?V1hKdHNNWC9kQVRSd1YvRjRUU2dKYXpmMWk1NzlGY0o2OHJUNFQ0cUY2ZC9S?=
 =?utf-8?B?RGxsRHJ0czRSdUE3aXBGdUI4ZG5BZXZucFRJbTBxUXB6L0RCNDU1TWJublF0?=
 =?utf-8?B?cXpLOUt6NTlhcjFOQk90OHlDZ3E5TmxRaHlsRDlpbUl3cGREdEFOaVhXempM?=
 =?utf-8?B?aCszbmRZQ0dBeUJoNWYrZjZyMzV0eVo1Mk5LSFpFRncybEhhb1F3bmlZRTU4?=
 =?utf-8?B?V1YrSElHVUpBWDVrUytNM3pLVXZQckFEQTI2bVhJZDNDekJ0by9DamVGQnJk?=
 =?utf-8?B?Q3M2aTF3d0wwQzQrc1AvYkllMFU5ZG84cHNoUTBYellqMVc4aTZGZmVzVUl2?=
 =?utf-8?B?RjdyR1BCOHVnaHl4ZHhDdUhwYlFvSmJ4MXhodkpiWnpNRTlxUGZIM3JSNm5y?=
 =?utf-8?B?N29TM3N0SFFYOU01clh1d2xZOXFrU3dtUGtINmVXdjNLZEh4Ky9DOHlsRUlN?=
 =?utf-8?B?Ty8yTWl5ODFoNld1bE1ablVKZHNzQjhvYzdjMGxWQlhPc0xJRnFFcXI4UVJC?=
 =?utf-8?B?RFVPSFZ3VW1pN3BTSjhPdU90eFNzSVNBQU12SkNYNEdLZmdJNWxsUldnMXBL?=
 =?utf-8?B?VHZHTnV1WEtTWkllSG1OM2t5bXZhUzgyYTVDTjdUaEZYM084RlcwMFdubGQv?=
 =?utf-8?B?NmNDN1lJQnM4MlJOUnVsdUtLVldHZzY4MUQxcHVCUm5QL2tRczFaRUVpSUJa?=
 =?utf-8?B?YlJ2cko1OWZUWmZacVhmMkZBSDdMN2NLRTU1dldhem1nUHVUczBIbGRpb2pW?=
 =?utf-8?B?TmlPc0krMzF3ZGI5VDBmZ29VUFZWWlRKSWZSZENBSWN6WTI3ODdscVFGYVNj?=
 =?utf-8?Q?npy/xmHXiqZASIVmeu/kGTWhO8t8A5gw2cBreKRmEU=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HqoCmcOrho2KFcAD8Ql8LmpJi1+iXcZuNIj8Kgtnl9lOmLdnGe1E21ZOCVyWH0y6yQ5Si6wlN07a21sDRa0Ut3W9apR2H3oJhtAgh1yxTxzK83uCVapwQQhbKVFIqgk/x6vH6I2STbrx7UfPtDaeehvHhK8JS0Afd7VB2yzlzfWtVI3TEsEk4bVs3AvOzzqbHgNQ3/CYxEDL++x/TFXAgAN11Mm9+6ugyQr2MyMS+Q78yXK8lnOLfjH7+VuzLtt52kOc8vgxca+QJb3BvYjGMECiHe78wojsUWjvF8Vtu/qpnBzl4G5T8cMPaZ8JN45mnOAEbd+BKRuPnUnGgyBWJwnY9hfMjIh5V29ORr1I86iuFePNd2/OPPVQ1bI27NMYFBDyEWJzbHQGUKDcKe3pHG+HEzhTNzuWpwBrIy4qZbecGarUbBj/Itd0n5vUoXNm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 12:38:48.2737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f70f6ef2-fe66-466f-703f-08de657cacd7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AEA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4449
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70438-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[15];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 522CFFDA87
X-Rspamd-Action: no action



On 2/5/2026 11:09 PM, Tom Lendacky wrote:
> On 2/5/26 11:20, Dave Hansen wrote:
>> On 2/5/26 08:10, Dave Hansen wrote:
>>> Shouldn't we flip the FRED CR4 bit _last_, once all the MSRs are set up?
>>> Why is it backwards in the first place? Why can't it be fixed?
>>
>> Ahhh, it was done by CR4 pinning. It's the first thing in C code for
>> booting secondaries:
>>
>> static void notrace __noendbr start_secondary(void *unused)
>> {
>>         cr4_init();
>>
>> Since FRED is set in 'cr4_pinned_mask', cr4_init() sets the FRED bit far
>> before the FRED MSRs are ready. Anyone else doing native_write_cr4()
>> will do the same thing. That's obviously not what was intended from the
>> pinning code or the FRED init code.
>>
>> Shouldn't we fix this properly rather than moving printk()'s around?
> 
> I believe that is what this part of the thread decided on:
> 
> https://lore.kernel.org/kvm/02df7890-83c2-4047-8c88-46fbc6e0a892@intel.com/T/#m3e44c2c53aca3bcd872de4ce1e50a14500e62e4e
> 
> Thanks,
> Tom
> 
>>
>> One idea is just to turn off all the CR-pinning logic while bringing
>> CPUs up. That way, nothing before:
>>
>> 	set_cpu_online(smp_processor_id(), true);
>>
>> can get tripped up by CR pinning. I've attached a completely untested
>> patch to do that.

Yes, this works as well. And Xin Li's patch also resolves the issue by
moving the cr4_init() later after initializing FRED MSRs.

Regards,
Nikunj


