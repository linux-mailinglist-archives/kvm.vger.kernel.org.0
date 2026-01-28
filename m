Return-Path: <kvm+bounces-69359-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cAmWGOJHemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69359-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:31:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F3FEDA6F15
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:31:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 60A3F30445A3
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:29:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA7034DCE3;
	Wed, 28 Jan 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FHYfdXYv";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="FHYfdXYv"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011041.outbound.protection.outlook.com [52.101.65.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CA133C53B
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.41
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769621352; cv=fail; b=Jsk+SEKjhX/HQdaYfZ5r9syoe/uvXCLcbk22YQWIvjI8IUGKvdW+4aJs00cAoZogsYZzluEHTRB8DQSmQWcta+2QM+4CZ/IcpFrbNki+8Axl3bS/M4CY6LkLjorz6rQKkcxnCc3DwOIuzot6UOoSlx9ffxKFiCWshrLAFtomfwg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769621352; c=relaxed/simple;
	bh=ZDIdZSi1jC90qMnTvcqZboApw/kBmYS4o71nbuupvP8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uSVnj/E9xn63KhfedzU0k20uSbRKjshSrxN8PL+by3iEoS5pap/LqbWMUUcI0pyNB/vyMACuSWEhuIcUJ4UgKELZCrkur8xnOn+d5SIf6v9PB9cmD/x8TD0dJmZbHoNPEqyEbsApMsUMXHKqBMxQ4VyT1e45ap+owEHrvNOPbJo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FHYfdXYv; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=FHYfdXYv; arc=fail smtp.client-ip=52.101.65.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yChUmG3SHaZCGxFXQ0Z1gCsiDzNgzCO9uW/vYRss2D9pNGKHRa58qh3ruYAAYckQKxKpGh41yirdk3eV8dUGANOKfCnz4hsKfjRNEOhP48uUW5GoWAKT5f2r68pc2Adq3YwgUoR5ikX39FWoWQYIRMVKeTDYHvZsvxMzG4BedbghdZZgi+0RQYBcfcgTHh9n+tdrZ/Q0TCeK0/UtLzKL26CyxUrHFn4bXJvDk061R01nc5umjZZoswrhAqJdT8u6awWt+iKY9lmFXh0+e1sun2xMpe8TBK1HDGkRp/tSOE4kcumLxOX8UGYHs1QZ0GvFikdmlT6bsVmsIUYyvz96gg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDIdZSi1jC90qMnTvcqZboApw/kBmYS4o71nbuupvP8=;
 b=bFVzE8Ba5vglV0b4fqyiVsMCMAMTxz9nQcYXvN+YZdWmEJWSlgVX0D4EIb9VngtkgEd9JRJBktpxgaM9g/P+fi4sZorFno31S5flqO9H3RfkXlMDWsAzIgJj8YHxtEe6bjlff323jAGT9o2Cy90hCqpFHTTljZM1pehhpc74pkjWr4IPb4M/eloSuc4RfncTXEANgB713IhUQ1+cSVGbhm4ZnjWUNnBYhgrLLVErVi6aoTyxy+DJNMBh9l/wgTlDgLZlsZonqd8klBjxJAMmznq7OKaDP/YcXjG2dmfCqAAwuZKla+1uQAnu0C5hRA+LOr1ecbyrBzdRvlGTuY/s1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=huawei.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDIdZSi1jC90qMnTvcqZboApw/kBmYS4o71nbuupvP8=;
 b=FHYfdXYvv718203WrPV+k3SkR2tpJRFKkG4BnIn1TTZvetMrlzRiJsohpNgtZMzVtGnOnJnl4mbdrrfq0fx2DNVv/2cqg7FMYeGDMOtD+jozzntN1N2iAs3Tq1BV7gFf1B8EuoSAgJ+ADcLu0VZ/XE2CSEzIhwLjCLFLQjAJCVg=
Received: from DU6P191CA0017.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::28)
 by DB5PR08MB9969.eurprd08.prod.outlook.com (2603:10a6:10:48d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 28 Jan
 2026 17:29:05 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::ac) by DU6P191CA0017.outlook.office365.com
 (2603:10a6:10:540::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 17:29:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Wed, 28 Jan 2026 17:29:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5BnHr5Hv33LGAmfV2skGr1NXeAyyEPWYlHp5MsbPod77ClrRidXo64pNobqgsUZu2FfOt9A/YSCKJXbHvPLzUalVBOZWYLKqPbfbeuNu+1hIu6CHOnSWPPJY7YvGnbsWRtQPPMpC+LKuRGTjdtnVUE2eTExWhbOyZUxN69txRXs/mxu7lobeUatlXP7xWJNNYoWqlJ6UsbMDlBsRmQU12fQfB70p9e9OmPMGh+m5nLtSHr7nPYcGgmNHuEz37gNzbHgoL28ogsgbdjud/FEEGnRdjVCZLxcqRdDgE4CcJpmiOm4MWqSfoH3P25zRdkv/xzWrxSLhwLwp89jp/tjyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZDIdZSi1jC90qMnTvcqZboApw/kBmYS4o71nbuupvP8=;
 b=m4H6MzYTNMCXoXbuH4LBqTMj4JvK6Jue1mrZlAIvzTs1I0W5zzRISuGXwVqXkAmY7QIu4mSDAtlM5XcKbhn8dz/6R/R/OOMOwZS869FYd/ZE1iiKoxz3vDkTNfGh+4exKOBeB3Fz5v9S0X+2lG7NdYsfn7fvyG2jnoCnllHznCdl6cOOGbkOzZae46M0vDsIhqrRjPoc8kqS+ZtWpxzTh1njObZrCMTNq0AfhlSNbr/KJ6GzQ6FiuJ+l8lG4pNjHKpwh9hmybs3ktP6ORO+AscOMVeAZck5ltEOozTsOxXvvyB1CGegD0ZaeRdumeM5UK1DunMfESg6sWiz3JCZqdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZDIdZSi1jC90qMnTvcqZboApw/kBmYS4o71nbuupvP8=;
 b=FHYfdXYvv718203WrPV+k3SkR2tpJRFKkG4BnIn1TTZvetMrlzRiJsohpNgtZMzVtGnOnJnl4mbdrrfq0fx2DNVv/2cqg7FMYeGDMOtD+jozzntN1N2iAs3Tq1BV7gFf1B8EuoSAgJ+ADcLu0VZ/XE2CSEzIhwLjCLFLQjAJCVg=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by PAXPR08MB7334.eurprd08.prod.outlook.com (2603:10a6:102:231::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 17:28:02 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:28:02 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "lpieralisi@kernel.org"
	<lpieralisi@kernel.org>, Timothy Hayes <Timothy.Hayes@arm.com>, Suzuki
 Poulose <Suzuki.Poulose@arm.com>, nd <nd@arm.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>
Subject: Re: [PATCH v3 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Topic: [PATCH v3 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHcgYoMHBJ9pbE75U+CUudUFu/FEbVOovuAgBlQ2IA=
Date: Wed, 28 Jan 2026 17:28:02 +0000
Message-ID: <bd4338e11afbcae934667ba16f3a9c9524a6eaf3.camel@arm.com>
References: <20260109170400.1585048-1-sascha.bischoff@arm.com>
	 <20260109170400.1585048-11-sascha.bischoff@arm.com>
	 <20260112145211.0000333c@huawei.com>
In-Reply-To: <20260112145211.0000333c@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|PAXPR08MB7334:EE_|DB1PEPF0003922F:EE_|DB5PR08MB9969:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b5110e5-4150-4498-53ff-08de5e92bc5a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?bGdHeEpMRDdXdmduYXJPTHAyWmNYSDFGVzQ3dTVUYUM0OVpoTmR1ZlZlQ05S?=
 =?utf-8?B?TGJlWEx4QmFxcEZwNkd5UDdJM2oyYXpzWVlPWVluOVprdGxXbSs4WXZPK0ha?=
 =?utf-8?B?QVdMWElJSWhrVXNSaG1xTVNwS01OYmJKMGZMSmdUdmNmWEpQYnVBV1VnR3U0?=
 =?utf-8?B?TjNHVGcwWU9QdTZKeTVIQ0Y5aEVENVpNVGYxcUdyNGRFZWpSZDFyYmFMUWVY?=
 =?utf-8?B?ZXprSzR4U0Nkelo2eGpCRnJlZ0k5TEozTE95SWJsS2JEcWpEeEgxTVJteTd0?=
 =?utf-8?B?Wk1wYzdmazdFS254NGZZeWRscmU2dTdBdjNVRGJvbFBnNGpsc3pmRlNQam94?=
 =?utf-8?B?ZlBKZlJLTDhXdWI4M2tBSy9HdS9oT3N5UjI1bTNwZGhSNlVIZ2w1TzAwMEhO?=
 =?utf-8?B?cE1UM0Z0RXFTNEtVa2R4SkF6WDZQK1lmOWpaSE9GTjZ0Q0lBSDBKaGJsWGU3?=
 =?utf-8?B?ZkhjR295ZlV3bGZHSTFpRWJYcTZhcGx1aEFJQ1NvRExSd3dST3FQMkpBTis2?=
 =?utf-8?B?Y2c1NnlubndQbEoyUFNMMGovbUFVQTlQVU85d2U4RHVtRitnQkNYMW9TOXlG?=
 =?utf-8?B?UCtBbHF1b0I0SFlpL3lJaGZET2ZvWkErU2FaQngwdHZ4aHFVazRaK0JzYlFp?=
 =?utf-8?B?eWh6M3hmVE9HNGhNQjd2cHZlNk5lNVZlZFFkMGx4TzNUSEF1VVllQnRpTytP?=
 =?utf-8?B?QXhNKzgvWGdCVVErT0xCR1dHckpWS1BTbmNDaFlpdS9WTWE5Uk5NSUxSd0Js?=
 =?utf-8?B?VENoaGFvY29nMFJJeU80WXpBK0x4ZjAxQUg3b2RFUTQ3dklWeG42QXk1Wmc2?=
 =?utf-8?B?Q3RwVm5rbTNiTVZ2blNsTmdZMk9LN0ZIbUQ0MzFSc1lmNU05enQrcjVKRHB6?=
 =?utf-8?B?c0Zqc3pRRmNzd0h2TytEVkpqL2pZMlRXWDZtLzFJRGRSVEViRjMxYi96YmpM?=
 =?utf-8?B?Zm5jNDMrOGNiNGUwWWhrMlhJcGpXcjdrdEN4TmlTdHhnRGYxVGxhem1DMzI2?=
 =?utf-8?B?ZFBlN21LWW92Vlo0WHNIcWhrUUwvakF6RUVYNW4rbnZDdzVldGhNajFGQUdW?=
 =?utf-8?B?d0hjelpIQXdqaTBLUVdORTlrNGdOMXkyYjJZUVV0N3JnWXNhbk1IdlpWL3pn?=
 =?utf-8?B?ZEZZRHkvemxLWFlORlNSM01VQWdodWVwN0VwUWEzQkRZYWhoNWd4dktaaGJ2?=
 =?utf-8?B?NzYwVllpNyszbEc1ME5seGd2NTRJUFRyTFN0VWdJRUN2Szc0T2ZjKytlbnVI?=
 =?utf-8?B?bkxnSHRrWVlSZjVhY1RmY1hkSTV0U3hVZThIWTRNKzVCWHhxYnZ4WG95aUdr?=
 =?utf-8?B?bWEwZWNDYzU1c3ZMMllsb01aczczNFRsUHA4dks1c0toVGRuVi9Ud0w3Ylpw?=
 =?utf-8?B?ZkUrblRzL2h1SVdBVmhkSmFkUFhFNW1VZStLOFpSd2pnZmYyQkhlNEY0WEZ0?=
 =?utf-8?B?VFljZUl3K1dEMk9NRWVlaEtsNXRMakZwR2srY3JTQ2NOa25RTis5V20rV2E2?=
 =?utf-8?B?ZEovWGw0S3VjR25aSFlEeXRadm11czljK3BFcHNGTitOalRIUE9KNDVVc3BJ?=
 =?utf-8?B?S0pubnJrekR3eFNjbEJ5S2hYZWpHbEVxNDYxOVpSbGc2Szc4SXJUNmZjR2xv?=
 =?utf-8?B?ZTkwU28zZDRNVnUrRVE3Wkt4TlQzT25wbFd3UDFjZysxNjU5TVZ6amZjVnBx?=
 =?utf-8?B?RUZxenZpbmVVMlh4T1BWVkhaWDdYUEdsbCtUcHd1YU81ck5BMlNNVHNKcCtQ?=
 =?utf-8?B?UW4wZmJhakNVZVlCbzY5VTlDMk5BNnllTWJJRnk2V3pWQnQwdjVlWUg4OGxJ?=
 =?utf-8?B?NURUTU8xbUkrWlJMOEVOUWNDRTI2N1BJT3lDemlDbFJXS294eTdRdkorME9w?=
 =?utf-8?B?ZEtaQTI1Vlc3VDBRVks3VUhjbU5wRGtsN1UrTndkS3JqQVBxS2QxSVRRZW00?=
 =?utf-8?B?RGtiYzBGaW9aRmd4SFFid1pQRXZLdzFqM3BOVlNDWUg0aEJFdHd5Um1OY1A3?=
 =?utf-8?B?b3hEVGJDQ3B2aHQ2RHExRU9JeGRaM0ZnWkRXamZlNTdlcTQ5UTBLa2Mxazdj?=
 =?utf-8?B?UEQvSVZDQnNlVms1Szhxam9xZDZyTHR4U0FhQ1NoeTduOVNhblhlUkN6VWJh?=
 =?utf-8?B?dXl2d0pKWTZJUGQ4Z0p3N3ViQ1VOT2Rhc25Pb3E2eVBKM0hncmExRjFXMld2?=
 =?utf-8?Q?uCO6cUo0C4mJ9RJM9hZSSe8=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <3AEFF2075E544541887B4B5F38EA9F2C@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7334
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1b02456a-a72c-47d4-81a0-08de5e9296ef
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUprelluTndRcVRzaVk3Y1pHQ2xPMGs1VDlUcnk4NDh0Q3dNeXNHRFRNS0lt?=
 =?utf-8?B?V0p3VmtXdndyYnh1ZjRmSHFFOTgzMEhMMnl3RStUN0c3ejJWTzlVcWJ0ZDRs?=
 =?utf-8?B?TWJHNmRzTHYyRmpscWFuaUpVb244YVhIS2RhUlBPR01GQU9PMmE5a2R4WFgx?=
 =?utf-8?B?elJuR2ZEY2pFc3MrT0QrYlVMZ2Q2WFF6cUZCMDc0Z0dnTnpaWUxiZXdCNmhz?=
 =?utf-8?B?Lzl0MW56NllRTmlyQmIxRWJleEFjUm5jdlR4SHdHbTRFYkRMVHlnYTgxa0du?=
 =?utf-8?B?WmlwV3ZaSUdEUUkxTW0xd1NJVWM0QktLbnZOSGRlWEJXZzdhTXFuZzhVZGRt?=
 =?utf-8?B?RExTR2RpdUYxbzFPUSt5UmRZc3YxUE5XNTQ4Wjd4MW9INGd5SnZ3S3JaT2J6?=
 =?utf-8?B?YzB2SldGMDR5cllQdUxuaUVGc29NVlJVeCsybDFIRG9zcnRHanAvREFjYktV?=
 =?utf-8?B?eGloTGl5RmJZRWxrblJMd0VNWjRFanZ1UzltUXA4U0RTTTlRMTFpdDNMaTBw?=
 =?utf-8?B?c0VQRmlHaFlCZmFWNkdhRGIwUEpkRmVxZVJKK0NodDlCL1ZTaDQ1eXAxNTFr?=
 =?utf-8?B?VHdrL3d0RU8zSDhnaFJVUGlMcWsvZm9SSVhGNjBKNTBQeWxHUFBKbXEyMUh3?=
 =?utf-8?B?Mm9QQmh1ZFA1ZnFvcXZVYjVtRkJLY1JDK29QRVhPUGwzNFBRSHFvcWlkanNU?=
 =?utf-8?B?Z2NTbUlFbFB1YmVxMkpCTktpeTVmNC9DYW04UERPUWEwMzRWNlJxdm45MHN3?=
 =?utf-8?B?d1h5YzA1T3AremFCcVI3NEY0TVZCU0RjWkFpd2RtMmZadGNmWVdLdEFINktV?=
 =?utf-8?B?QUJEQng2YmpoM1Nnb01jVEM1MDN2cnA3dTFwRzhjK2tHUDUrQUExbUdjQnNH?=
 =?utf-8?B?aWZaOFVhZDVOQ1QrWXlxcDdsM2lCMERZVGp3dHJhekxCQ2psdTNkYnE4VnVN?=
 =?utf-8?B?TlpHeE4rM1BFSWhIRE1nUDRIdmh6UzVxaGcvZVEyVVlHVWF1UUpKTWJPSWcw?=
 =?utf-8?B?dXlQaGE2ZHROT2ZrNlRqSnhRNG42YlU2V2VPM3ViN0UrV1B6NElrMU1VcG5W?=
 =?utf-8?B?RXp3eDBmVWN4ZGZ3QVJ0RTB6dmRhMTJmcDdlRnhMRHZmNklWYURpTVRPdGJS?=
 =?utf-8?B?NmJ1ZnhDV1RRbTVGbjBQbkZTSXRDUWNMaHpZd0pzMWQ0L2p0WDVVL1M1cjl3?=
 =?utf-8?B?NDlLM0hFbUFRZXNpU21HcHJqZUFyM0RjQXJrSXIwbjYxb3dQMGFScE5HL0ZJ?=
 =?utf-8?B?WUMya0h2TVE5VUF3YTQ1b0hyTTFWMjU3V0puWTJZWDNKYWNJckt2RzhGNDRm?=
 =?utf-8?B?WHBIb2gxMlk4YlZnRE5sQ2VNTUZOU3J2Vzl4clR2ek5KZlQzZFFVaHRkYWNU?=
 =?utf-8?B?Qk4zUTNtVUxhampxTjRmODRiVHgwamh5cXd2ZllCcjVkd3FubUorbWNVQlIz?=
 =?utf-8?B?N0JrN21jbzdvZWZHQlhXQ2tCVTJiNHZNVk1PcGI2LzErcndDLzRuUC9SZ1dl?=
 =?utf-8?B?WkVaOUFlWlhyZlRSRkFCVGx0Q0hKZnJ6dUJBK1VDWVdXa0h3Nm1rTTE0RjJ5?=
 =?utf-8?B?M0piUU5BcExDa0F3a1NidlRhMXRtVEtiMkhSMFc5SkFrSDUrcXRER0JhcXRQ?=
 =?utf-8?B?dlIwR3pLVEo2YWVucHlRSTFPcFpubzJSeXdpRGE3Y2F5QWNHTFV3NXF4ZFZJ?=
 =?utf-8?B?QkI5WkMxMjVhRi9lNDQyK3dscm82OXVjYmdLeHgxNW9CWUNWMTJpUnBaZmxE?=
 =?utf-8?B?Y0U0Z0FLaDB2VGEvdEJHUzdKWDZSTUkvSHd2aTk4S1BQVXdTWXQ5cjY0RmRa?=
 =?utf-8?B?ZitTUmdwNjJja3RIOURnWE9INTlqTkRUS2dJWG1NVkpmbUZHTllBeXFGbmNj?=
 =?utf-8?B?YnlTZzE4MUpwR0RrTDMrMnk3ZU1tVUJheDNWK3U3cFladzFGeUVwemdEVitz?=
 =?utf-8?B?aGxBVDZiNFFJMWxMeHE2clk4amxwTk5sOGk5T09XQkhFV2YrSFh4YTlZU1Vs?=
 =?utf-8?B?VEhRVjlNU3ZtMXBTUE5TOWpzeDBtZm1jY2M0dURYcVowZkhuVnp3ZFNvWmla?=
 =?utf-8?B?MEIwTWltSVFWa1Y5UHd3ekVYSHZibGZPdWR0RDIzRFdibkZ5MitRVXhmRDdV?=
 =?utf-8?B?SGIvUnltVUlCdTdoNVdEcDFWOXR6dzZtSkxRWEVGTVF5S1BCTFpyWU1RcHdX?=
 =?utf-8?B?d1BiZXVoc0pEYWI3bTZOcmpqNmUrbWZXUTFGd1BvR1krMVd2eHZUZGxTbktu?=
 =?utf-8?B?bHFkOCsvazc5aHE4S09VbGY0d21nPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 17:29:05.0338
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5110e5-4150-4498-53ff-08de5e92bc5a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB9969
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69359-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: F3FEDA6F15
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAxLTEyIGF0IDE0OjUyICswMDAwLCBKb25hdGhhbiBDYW1lcm9uIHdyb3Rl
Og0KPiBPbiBGcmksIDkgSmFuIDIwMjYgMTc6MDQ6NDIgKzAwMDANCj4gU2FzY2hhIEJpc2Nob2Zm
IDxTYXNjaGEuQmlzY2hvZmZAYXJtLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEFzIHBhcnQgb2YgYm9v
dGluZyB0aGUgc3lzdGVtIGFuZCBpbml0aWFsaXNpbmcgS1ZNLCBjcmVhdGUgYW5kDQo+ID4gcG9w
dWxhdGUgYSBtYXNrIG9mIHRoZSBpbXBsZW1lbnRlZCBQUElzLiBUaGlzIG1hc2sgYWxsb3dzIGZ1
dHVyZQ0KPiA+IFBQSQ0KPiA+IG9wZXJhdGlvbnMgKHN1Y2ggYXMgc2F2ZS9yZXN0b3JlIG9yIHN0
YXRlLCBvciBzeW5jaW5nIGJhY2sgaW50byB0aGUNCj4gPiBzaGFkb3cgc3RhdGUpIHRvIG9ubHkg
Y29uc2lkZXIgUFBJcyB0aGF0IGFyZSBhY3R1YWxseSBpbXBsZW1lbnRlZA0KPiA+IG9uDQo+ID4g
dGhlIGhvc3QuDQo+ID4gDQo+ID4gVGhlIHNldCBvZiBpbXBsZW1lbnRlZCB2aXJ0dWFsIFBQSXMg
bWF0Y2hlcyB0aGUgc2V0IG9mIGltcGxlbWVudGVkDQo+ID4gcGh5c2ljYWwgUFBJcyBmb3IgYSBH
SUN2NSBob3N0LiBUaGVyZWZvcmUsIHRoaXMgbWFzayByZXByZXNlbnRzIGFsbA0KPiA+IFBQSXMg
dGhhdCBjb3VsZCBldmVyIGJ5IHVzZWQgYnkgYSBHSUN2NS1iYXNlZCBndWVzdCBvbiBhIHNwZWNp
ZmljDQo+ID4gaG9zdC4NCj4gPiANCj4gPiBPbmx5IGFyY2hpdGVjdGVkIFBQSXMgYXJlIGN1cnJl
bnRseSBzdXBwb3J0ZWQgaW4gS1ZNIHdpdGgNCj4gPiBHSUN2NS4gTW9yZW92ZXIsIGFzIEtWTSBv
bmx5IHN1cHBvcnRzIGEgc3Vic2V0IG9mIGFsbCBwb3NzaWJsZSBQUElTDQo+ID4gKFRpbWVycywg
UE1VLCBHSUN2NSBTV19QUEkpIHRoZSBQUEkgbWFzayBvbmx5IGluY2x1ZGVzIHRoZXNlIFBQSXMs
DQo+ID4gaWYNCj4gPiBwcmVzZW50LiBUaGUgdGltZXJzIGFyZSBhbHdheXMgYXNzdW1lZCB0byBi
ZSBwcmVzZW50OyBpZiB3ZSBoYXZlDQo+ID4gS1ZNDQo+ID4gd2UgaGF2ZSBFTDIsIHdoaWNoIG1l
YW5zIHRoYXQgd2UgaGF2ZSB0aGUgRUwxICYgRUwyIFRpbWVyIFBQSXMuIElmDQo+ID4gd2UNCj4g
PiBoYXZlIGEgUE1VICh2MyksIHRoZW4gdGhlIFBNVUlSUSBpcyBwcmVzZW50LiBUaGUgR0lDdjUg
U1dfUFBJIGlzDQo+ID4gYWx3YXlzIGFzc3VtZWQgdG8gYmUgcHJlc2VudC4NCj4gPiANCj4gPiBT
aWduZWQtb2ZmLWJ5OiBTYXNjaGEgQmlzY2hvZmYgPHNhc2NoYS5iaXNjaG9mZkBhcm0uY29tPg0K
PiBPbmUgbWlub3IgY29tbWVudCBiZWxvdy4NCj4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NS5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjUu
Yw0KPiA+IGluZGV4IDIzZDBhNDk1ZDg1NWUuLjg1ZjllZTViMGNjYWQgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY1LmMNCj4gPiArKysgYi9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjUuYw0KPiA+IEBAIC04LDYgKzgsOCBAQA0KPiA+IMKgDQo+ID4gwqAjaW5j
bHVkZSAidmdpYy5oIg0KPiA+IMKgDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgdmdpY192NV9wcGlfY2Fw
cyAqcHBpX2NhcHM7DQo+ID4gKw0KPiA+IMKgLyoNCj4gPiDCoCAqIFByb2JlIGZvciBhIHZHSUN2
NSBjb21wYXRpYmxlIGludGVycnVwdCBjb250cm9sbGVyLCByZXR1cm5pbmcgMA0KPiA+IG9uIHN1
Y2Nlc3MuDQo+ID4gwqAgKiBDdXJyZW50bHkgb25seSBzdXBwb3J0cyBHSUN2My1iYXNlZCBWTXMg
b24gYSBHSUN2NSBob3N0LCBhbmQNCj4gPiBoZW5jZSBvbmx5DQo+ID4gQEAgLTUzLDMgKzU1LDM3
IEBAIGludCB2Z2ljX3Y1X3Byb2JlKGNvbnN0IHN0cnVjdCBnaWNfa3ZtX2luZm8NCj4gPiAqaW5m
bykNCj4gPiDCoA0KPiA+IMKgCXJldHVybiAwOw0KPiA+IMKgfQ0KPiA+ICsNCj4gPiArLyoNCj4g
PiArICogTm90IGFsbCBQUElzIGFyZSBndWFyYW50ZWVkIHRvIGJlIGltcGxlbWVudGVkIGZvciBH
SUN2NS4NCj4gPiBEZXRlcmVybWluZSB3aGljaA0KPiA+ICsgKiBvbmVzIGFyZSwgYW5kIGdlbmVy
YXRlIGEgbWFzay4NCj4gPiArICovDQo+ID4gK3ZvaWQgdmdpY192NV9nZXRfaW1wbGVtZW50ZWRf
cHBpcyh2b2lkKQ0KPiA+ICt7DQo+ID4gKwlpZiAoIWNwdXNfaGF2ZV9maW5hbF9jYXAoQVJNNjRf
SEFTX0dJQ1Y1X0NQVUlGKSkNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJLyogTmV2ZXIg
ZnJlZWQgYWdhaW4gKi8NCj4gPiArCXBwaV9jYXBzID0ga3phbGxvYyhzaXplb2YoKnBwaV9jYXBz
KSwgR0ZQX0tFUk5FTCk7DQo+ID4gKwlpZiAoIXBwaV9jYXBzKQ0KPiA+ICsJCXJldHVybjsNCj4g
PiArDQo+ID4gKwlwcGlfY2Fwcy0+aW1wbF9wcGlfbWFza1swXSA9IDA7DQo+ID4gKwlwcGlfY2Fw
cy0+aW1wbF9wcGlfbWFza1sxXSA9IDA7DQo+IA0KPiBZb3UganVzdCBremFsbG9jKCkgdGhlIHN0
cnVjdHVyZSBzbyB0aGVzZSBhcmUgYWxyZWFkeSAwLsKgIEdpdmVuDQo+IGl0J3Mgc28gY2xvc2Ug
SSdtIG5vdCBzdXJlIHRoZXJlIGlzIGFueSAnZG9jdW1lbnRhdGlvbicgdmFsdWUgaW4NCj4gc2V0
dGluZw0KPiB0aGVtIGhlcmUuDQoNCkFncmVlZCAmIGRyb3BwZWQuDQoNClNhc2NoYQ0KDQo+IA0K
PiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBJZiB3ZSBoYXZlIEtWTSwgd2UgaGF2ZSBFTDIsIHdo
aWNoIG1lYW5zIHRoYXQgd2UgaGF2ZQ0KPiA+IHN1cHBvcnQgZm9yIHRoZQ0KPiA+ICsJICogRUwx
IGFuZCBFTDIgUCAmIFYgdGltZXJzLg0KPiA+ICsJICovDQo+ID4gKwlwcGlfY2Fwcy0+aW1wbF9w
cGlfbWFza1swXSB8PQ0KPiA+IEJJVF9VTEwoR0lDVjVfQVJDSF9QUElfQ05USFApOw0KPiA+ICsJ
cHBpX2NhcHMtPmltcGxfcHBpX21hc2tbMF0gfD0NCj4gPiBCSVRfVUxMKEdJQ1Y1X0FSQ0hfUFBJ
X0NOVFYpOw0KPiA+ICsJcHBpX2NhcHMtPmltcGxfcHBpX21hc2tbMF0gfD0NCj4gPiBCSVRfVUxM
KEdJQ1Y1X0FSQ0hfUFBJX0NOVEhWKTsNCj4gPiArCXBwaV9jYXBzLT5pbXBsX3BwaV9tYXNrWzBd
IHw9DQo+ID4gQklUX1VMTChHSUNWNV9BUkNIX1BQSV9DTlRQKTsNCj4gPiArDQo+ID4gKwkvKiBU
aGUgU1dfUFBJIHNob3VsZCBiZSBhdmFpbGFibGUgKi8NCj4gPiArCXBwaV9jYXBzLT5pbXBsX3Bw
aV9tYXNrWzBdIHw9DQo+ID4gQklUX1VMTChHSUNWNV9BUkNIX1BQSV9TV19QUEkpOw0KPiA+ICsN
Cj4gPiArCS8qIFRoZSBQTVVJUlEgaXMgYXZhaWxhYmxlIGlmIHdlIGhhdmUgdGhlIFBNVSAqLw0K
PiA+ICsJaWYgKHN5c3RlbV9zdXBwb3J0c19wbXV2MygpKQ0KPiA+ICsJCXBwaV9jYXBzLT5pbXBs
X3BwaV9tYXNrWzBdIHw9DQo+ID4gQklUX1VMTChHSUNWNV9BUkNIX1BQSV9QTVVJUlEpOw0KPiA+
ICt9DQoNCg==

