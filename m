Return-Path: <kvm+bounces-72510-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KL4cOZaqpmn9SgAAu9opvQ
	(envelope-from <kvm+bounces-72510-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:32:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 753C51EBE6A
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 10:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0D8030A2805
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 09:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D61CA38C427;
	Tue,  3 Mar 2026 09:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sCJXW1tR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="sCJXW1tR"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013031.outbound.protection.outlook.com [52.101.83.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEE0388E40;
	Tue,  3 Mar 2026 09:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772530071; cv=fail; b=V/z4tJZTP0lFkZ6Gpst3tMEFQKb0f7GpeDtkF37+cSgGqDUNq0xle9JXEFrVHy+eF/Q4oDcHRrfIxD00RIUu2iY18Yrv8Mdk7SV8YiIdgrq1TGJOd3kSKba11kL2ox4mwwjyMXe2jNBRcKiYymKn5QRuhZJFFllGqBUM9UiyF4s=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772530071; c=relaxed/simple;
	bh=HWfLiAFz9zcZ1kyyt454sGPabLYAfx6SKrQwIAF6SuI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mxWKdmmV6TBzg7+2GvS1sElQMr8SJKwr3TOA4Urs/4s8j6EmF3+l6ARjIdC0MPV4FZzyC1jF+OZv6j9+THoJk+ttoBQKzecivqS/INCObhfvN0uvUl66VkyqoiP16068ZP6Fdetho+hMrCp/FoQv2iqkZKIpHhPu99PhexbmfnA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sCJXW1tR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=sCJXW1tR; arc=fail smtp.client-ip=52.101.83.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RKkHh1zn/wWQzvY6S8Tl4+mu8+q4oyVSsHPtRexIjEJvnNi5oxMKESPVFrflWtc4So53BGIQLddoe1u23Pia5hDwYBjFxNcxR2dmR3ac7N97Krten2M68r9FwVaDrXrZJyiNmDVaoWUZNxC824vzhKEDWJ67MFU7jwMMjlxHhtSrtqF1JgXClQFQz7AIYXLZwG3zLfNPqdXoPO9b/PxAe7N9sCQRC7Ns0gKEJWo0/KUS9j8wj5DKd75ejcXs4Bbl2TmQF3vNlrr7OyeDehRYi1Tj/Ktnrtzc6jBzWMONBHF59AGx+ql5iKQsMKbhm9JQtTSaXVJfgQqp5GJSYdm+Sw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2W3F7AANwfXVDP1pQXJZrXkVatr0nzlXFJJ8dLa0uU=;
 b=E2MQ3/WLz3IQGnKlRpicjEwz095ir+DGsm05kgBDmjqAyBgyKM7DLYP+k73Zj1AmBRLBXgsTRIBpQkyIij5q4LXFqBiG2ruFFhAI213hWxcNo+pMF0yemy8JF4JeCOPmiunkbVURcwhPtMiJASQ2PYu8obuGiVda0V6knqLLO/xt+bS6K7T+cTwEaFBLzo2nxiv0L+aIgmNiOSNNEtd9WEbKruCP3k2Hjswg30QiOM9qgIoC0rTSiPutdSyuQRzo0lDQMez6R+8eHUgLyM9sf5CEsDFCbuL9QbqZ3zvyonWg1jiKN1p02+anWamFgdTlu+oFIjl2GUwV74tW0B24vA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2W3F7AANwfXVDP1pQXJZrXkVatr0nzlXFJJ8dLa0uU=;
 b=sCJXW1tRL4FfQD0r6BNuIZL+hZo50pkLKXXSNNxRCV23/13/RoW/6GeqpypmWCjv4Ips0hGJQ4TT3wIEKuffhnUaD/msYsjb1Wj9VSHyatOVthqH5p2MHCj4CAtW6yjmYFkE6D2yMEk+KwvzsjWyb2RkRD0lvvjiyBT3hxF7UMg=
Received: from DUZPR01CA0162.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::10) by PAWPR08MB9805.eurprd08.prod.outlook.com
 (2603:10a6:102:2e6::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Tue, 3 Mar
 2026 09:27:39 +0000
Received: from DB1PEPF000509FB.eurprd03.prod.outlook.com
 (2603:10a6:10:4bd:cafe::12) by DUZPR01CA0162.outlook.office365.com
 (2603:10a6:10:4bd::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 09:27:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FB.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Tue, 3 Mar 2026 09:27:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HKJt69QIBgLhV+GmZCNxwdfC/SM47fpsWBz/9S93albAgfTzT3/tEWCRAsV1fPzJrpewen1wL7i20r5Xu3UyNy1t4O3mT/ELhmdtGr31hxw8pDpxxNfNX5hvi/2huR9YeLnqVX9X4ZsvYU3tqRezHtamYsl5kek2UEgdGyX5Np8my/G1TgkhJ1KFOvS2doMTNeNlBfvaS0tvg5fvjJI45UnyaF3NCjFPFU+TdCodOdrzDU5GMfPu3Yzt+hkChAVTyNMdh/J/kZmB81UrX5Bv+K54fyN8eSP+tAqrFCzeiwmfP0AXmpp3h1vdP15UrtgkmFuryIa08K80EO/JpyfpLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2W3F7AANwfXVDP1pQXJZrXkVatr0nzlXFJJ8dLa0uU=;
 b=rNV78euD9JpoSntL2kRnq4KAAeaTeqxc8RLRaiT4HHZkv4vAHGbEBO0r7CfRfhaAQIziBJnSKumqlaLFM1lyMI4+xrhT5EYfL0raJvZCB+/lNMMR5HCD68TBcx9cfDh/df2DeyjBZep50bzGBqqtepWGv6h6ud66r0/Az93cpULaXeRdqNZqHm7RtkMvnSkFNe2cm/PUommAoYczS51VH3DuhxvGrth7gdZHdVajN2I3/lcsVUnZEop2G6YP3TQIifflaXlntzwtlxJEDKzMxwNwlgI6OFAd/4mabQWc/fXFog8vBaDchdUyH2cgWPXfW6dqSrFpOpl9woxtyFpTKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2W3F7AANwfXVDP1pQXJZrXkVatr0nzlXFJJ8dLa0uU=;
 b=sCJXW1tRL4FfQD0r6BNuIZL+hZo50pkLKXXSNNxRCV23/13/RoW/6GeqpypmWCjv4Ips0hGJQ4TT3wIEKuffhnUaD/msYsjb1Wj9VSHyatOVthqH5p2MHCj4CAtW6yjmYFkE6D2yMEk+KwvzsjWyb2RkRD0lvvjiyBT3hxF7UMg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com (2603:10a6:10:644::21)
 by PA6PR08MB10782.eurprd08.prod.outlook.com (2603:10a6:102:3d0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Tue, 3 Mar
 2026 09:26:33 +0000
Received: from DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f]) by DU4PR08MB11769.eurprd08.prod.outlook.com
 ([fe80::d424:cd62:81a8:490f%6]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 09:26:32 +0000
Message-ID: <ec27e294-0bee-474a-a15b-6be20ee10cd4@arm.com>
Date: Tue, 3 Mar 2026 09:26:31 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 27/46] KVM: arm64: Handle Realm PSCI requests
To: Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20251217101125.91098-1-steven.price@arm.com>
 <20251217101125.91098-28-steven.price@arm.com> <86pl5m89ub.wl-maz@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86pl5m89ub.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PA7P264CA0458.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:398::15) To DU4PR08MB11769.eurprd08.prod.outlook.com
 (2603:10a6:10:644::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU4PR08MB11769:EE_|PA6PR08MB10782:EE_|DB1PEPF000509FB:EE_|PAWPR08MB9805:EE_
X-MS-Office365-Filtering-Correlation-Id: 65fc0ce4-d296-4eeb-720e-08de79071d0f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 ySJ4q5Na58OiWjXasI0Kt+HJEW81x3fs2qB+g3v94XtUPvWCd4bhGLKbU51WpZeSAPGLCvNC4xLL5rxivWhWEAcMyqiWKOpbgge4H5WxkoNdEZgl7FOiE/l+2v3cLDSN1Cc+hywmSyhq3F0vGsrJSz5rRyVKhxfbVgxPh5aGr0HgbGHx7YSynpRzr59PLhGlzuGHwg+4vlG/Xh44WGD7q8fLT9Y7Jo8oCvZg2m1mw9E8y5UlBjp0bGZO2PWA8sT6LVR5RetQIeoDhw8upl4meFNoxjAUdUWoyzRky5pnjYYN8EUDolmLOzm0ThZQ0TEfAQTF/INrw5s3RaJSrhA7b+DM1O6/02TIxejHdcanTLX/yOuJDqz4UjhJi8JECJEYS0lie3pxPARCQKTs44I1iqzBJWi6DRjXTTyKJbHQ69XJ5fgBwCFeiE/4aMTTnzvqJx8L/0kiHTlShoQw/Ef2SJPTQlmsPL2hBNbxcK5puqM+LSyHIW1hXJU5hILaoTdAVVN2j4Bt0VCCjFAc29nBddsuhlubQqdW4uRs7s0PTpnkduRIJuWSKChfNMlMacvOxDd17t9xkfwD7Uzsrs6qE/P2os+Vve38MN56j7LP/53FSQDDJEBmxO80AZofZE9Fy6ryqg4bQk5qL+YCBHP21f1YiqIObdsIDWPQdMA2iZcQvJDCLMSX2VkF9Lj/Yu7uAdZ3RrQ7RXTMc0LF974zbJQrWSVqN5F6AWTKEIIQ3yw=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU4PR08MB11769.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10782
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0946886e-2ca1-4197-b886-08de7906f572
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	C4EpFPcgBMK4BNup9Nllkdmno1WMOvpsKX3Z5p1vShQmvaViz6Rt6hf4m6uuBKc7+5obrcE7MhlPRhHVsxFXNJ5APZYjDmC7/quhR/XZ4ncq4mZdBb2pYW54L1M6pguEv3UkmLU7dSLd8E/XDFbNdta+weVgRBvVv0oeziOPst6bVXsglFVgBCgQZvEiXe0irTwaeyTAh5RK+BC4r/Z7hQXI7CslZtX8L/7X2GhF6gMb51ib/Z7GZOLQOgpZG5x6jdzs+fGowbbd3zdu984drbPWHW7gkrA07Pn3ZtWZW8mIvgnX8CAtkseTRxgM0RQAjWjRWojT2eBMnwVwo4NvDDYuhl7g/Ms8M3YfPBdbVeAPG9QwNiOVc29d6Pz5xnbzDuxOPukBKydQUfckISEAUB2Xtp57E8ofm721KXTWGoFi32rx7X94/5CNugcf5x5+lzVXlx2a/KVZhLzEyUKQLAF4DchlU6IpamZ5pZuN+rfuVjHqfXZAPoKxuX3C8twvR+qTES+JJFRnamxXYIGIO5daF2hJw1En8ZSk3EsNKeTpNimizEx8+Z6CHam9J8SRadQb7siouI+JSmsqVwKUz3OL4rR6UNfd705QU8XLzSUT89iipWRRkOIIOyNbYJmY4t7Krkt3Dh4QF0Dtlbf+3p6IbY56MnpRBqwWG7Pp19owN6ZnTQawjNqtkQXv1UgzB9fNIDYGcZLQf4QpQjPZPUQd0o+bp0hkQjLP6T0a+qk8X1TU8hK3REmReNnJm8CWtqlaLbaksrB0kdh20/MHtIdpbTFoYieRsz4PME5a4h7cIGigTRQ6TNs92GucULRSILJIK4X4zE40RD+dokH9vw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/RL5KmztYlq/om9cK2U7lzorDsmg3CqyKnnEeQ225ijHeiNbJU0zu15QQfDxRY+ExGbMsH9BIen7h9gPyrb+S3aVPHXqs9H866ook6HyyoZGx32FqmO52AoWZxDMrhf4Z0RLxbKhYTvdXmh1baXWqDij/hCInU4agoCqL3QiYCWVtOxP4mnYj09TgrFMZsVSsTYvlL2E39a7bb+lQF6ZELq/Auhjqr11Op7nno/B4cGhNVptqD/CH2oDJVaa8lqbWQKYGThwMz3g/nwiXRx063N+eNBYIY5/xQX0z6ZnVSRDRUy21OnhgZXFlmUIVriNI5pppb8iMVzFfRvrgzMniLHWsJcazznt2vJJUG7lD5YdEdxIQLEBBcCx3kfeUXUc9HHO4u+AK8owqWjUpf3TK0ZVUjOjbuAbUFu8CBHzX3NhAEI3KORe72sUxI6RJKcD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 09:27:39.1395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65fc0ce4-d296-4eeb-720e-08de79071d0f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FB.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR08MB9805
X-Rspamd-Queue-Id: 753C51EBE6A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	TAGGED_FROM(0.00)[bounces-72510-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	URIBL_MULTI_FAIL(0.00)[sea.lore.kernel.org:server fail,arm.com:server fail];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,arm.com:dkim,arm.com:email,arm.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[suzuki.poulose@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

On 02/03/2026 16:39, Marc Zyngier wrote:
> On Wed, 17 Dec 2025 10:11:04 +0000,
> Steven Price <steven.price@arm.com> wrote:
>>
>> The RMM needs to be informed of the target REC when a PSCI call is made
>> with an MPIDR argument. Expose an ioctl to the userspace in case the PSCI
>> is handled by it.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> ---
>> Changes since v11:
>>   * RMM->RMI renaming.
>> Changes since v6:
>>   * Use vcpu_is_rec() rather than kvm_is_realm(vcpu->kvm).
>>   * Minor renaming/formatting fixes.
>> ---
>>   arch/arm64/include/asm/kvm_rmi.h |  3 +++
>>   arch/arm64/kvm/arm.c             | 25 +++++++++++++++++++++++++
>>   arch/arm64/kvm/psci.c            | 30 ++++++++++++++++++++++++++++++
>>   arch/arm64/kvm/rmi.c             | 14 ++++++++++++++
>>   4 files changed, 72 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index bfe6428eaf16..77da297ca09d 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -118,6 +118,9 @@ int realm_map_non_secure(struct realm *realm,
>>   			 kvm_pfn_t pfn,
>>   			 unsigned long size,
>>   			 struct kvm_mmu_memory_cache *memcache);
>> +int realm_psci_complete(struct kvm_vcpu *source,
>> +			struct kvm_vcpu *target,
>> +			unsigned long status);
>>   
>>   static inline bool kvm_realm_is_private_address(struct realm *realm,
>>   						unsigned long addr)
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 06070bc47ee3..fb04d032504e 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1797,6 +1797,22 @@ static int kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
>>   	return __kvm_arm_vcpu_set_events(vcpu, events);
>>   }
>>   
>> +static int kvm_arm_vcpu_rmi_psci_complete(struct kvm_vcpu *vcpu,
>> +					  struct kvm_arm_rmi_psci_complete *arg)
>> +{
>> +	struct kvm_vcpu *target = kvm_mpidr_to_vcpu(vcpu->kvm, arg->target_mpidr);
>> +
>> +	if (!target)
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * RMM v1.0 only supports PSCI_RET_SUCCESS or PSCI_RET_DENIED
>> +	 * for the status. But, let us leave it to the RMM to filter
>> +	 * for making this future proof.
>> +	 */
>> +	return realm_psci_complete(vcpu, target, arg->psci_status);
>> +}
>> +
>>   long kvm_arch_vcpu_ioctl(struct file *filp,
>>   			 unsigned int ioctl, unsigned long arg)
>>   {
>> @@ -1925,6 +1941,15 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>>   
>>   		return kvm_arm_vcpu_finalize(vcpu, what);
>>   	}
>> +	case KVM_ARM_VCPU_RMI_PSCI_COMPLETE: {
>> +		struct kvm_arm_rmi_psci_complete req;
>> +
>> +		if (!vcpu_is_rec(vcpu))
>> +			return -EPERM;
> 
> Same remark as for the other ioctl: EPERM is not quite describing the
> problem.
> 
>> +		if (copy_from_user(&req, argp, sizeof(req)))
>> +			return -EFAULT;
>> +		return kvm_arm_vcpu_rmi_psci_complete(vcpu, &req);
>> +	}
>>   	default:
>>   		r = -EINVAL;
>>   	}
>> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
>> index 3b5dbe9a0a0e..a68f3c1878a5 100644
>> --- a/arch/arm64/kvm/psci.c
>> +++ b/arch/arm64/kvm/psci.c
>> @@ -103,6 +103,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
>>   
>>   	reset_state->reset = true;
>>   	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
>> +	/*
>> +	 * Make sure we issue PSCI_COMPLETE before the VCPU can be
>> +	 * scheduled.
>> +	 */
>> +	if (vcpu_is_rec(vcpu))
>> +		realm_psci_complete(source_vcpu, vcpu, PSCI_RET_SUCCESS);
>>
> 
> I really think in-kernel PSCI should be for NS VMs only. The whole
> reason for moving to userspace support was to stop adding features to
> an already complex infrastructure, and CCA is exactly the sort of
> things we want userspace to deal with.

Agreed. How would you like us to enforce this ? Should we always exit
to the VMM, even if it hasn't requested the handling ? (I guess it is
fine and in the worst case VMM could exit, it being buggy)

Cheers
Suzuki


> 
> Thanks,
> 
> 	M.
> 


