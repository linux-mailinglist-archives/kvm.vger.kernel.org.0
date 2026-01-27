Return-Path: <kvm+bounces-69246-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8FzeAdS8eGn6sgEAu9opvQ
	(envelope-from <kvm+bounces-69246-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 14:25:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5019A94E15
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 14:25:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23700303C02F
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 13:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE90356A30;
	Tue, 27 Jan 2026 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AMAakyJY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="AMAakyJY"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013028.outbound.protection.outlook.com [52.101.83.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92173570BE
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 13:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.28
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769520301; cv=fail; b=XppQWhVH8dadqG0st2qa8lQI/J4kj3lTLW9OT53/UJAz6Xl60uk95g4fKIOkUR5lSJgYEIuo8STi+4DKOTre+v3LSKJynH1mvYhUq1O5FTmdHEFyjXYinkjyEDHon/rzJCu0xqGlTVHgR4y8j4vKFxsNXe2OFPd2gtBXFYr4kow=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769520301; c=relaxed/simple;
	bh=+DSLOIrGKg4jJ3qUtdj6veRkxEKhCXIyd11FqkgzZRw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PRUHDGQRdW/YAUSxppL9zGNtFFnCGVXUIj7e6GJNWUX60rF6CPDS1X8wkcUVm5MqLVdoV3FuLlqO2jX3buvYv0iWq1hOJUChs5ywWU2krHjYCPlq+soUcW+WnxgmvQdhBWE7vgbM2YHFd2q4FI1/0TrXTDfak1u2+Xk/C4V+D9g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AMAakyJY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=AMAakyJY; arc=fail smtp.client-ip=52.101.83.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NBLvaRTcDO+vSFIUO27KvsUlGP+6c/C6YonKN5mqaYSGHsEZsKhVvlk69suSo/N8+VXuJ68RgYvt7OmAQ+owdkIHEDMiGypW11iHhJKJPLYY0MEDt0vDmbxsm8QkdUBIFtXJD1tGBUj30kAo9aiDm87xal+CG5l0NFqml3hxrQxufLnustMMUN8wEIXQIEpKJjKay3kAnglZynPjJ8fpn5qjNClp+HwLdeTeC4ZKEAHes9nwcR0rXf2wnZk6ZHGCuQY8AooRTMTquqKQU/weDjdgJ19yB41II9uYXA2rj8moxecugiTyobkdkaUh4ucuOmy2GJ5gRZJp6rSPvBl0hA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DSLOIrGKg4jJ3qUtdj6veRkxEKhCXIyd11FqkgzZRw=;
 b=TM3ZT9gwzlTAxKYonlb6sIjkECgXeVeG2EwhNHkiCK8lgR2KuVhZEpjvTfxPIch8MOX7sqkABLjdw0Ljch26JqIqNrgmfAr4acjTncoKvwA8BqFDYuKXffzyGHQLOwtfrK5mqqKz/LgTvbsq0/PDkwuAOKXNDQ8gLr7IyjvLeg3EgYiDnS4HPmnaTUVAsoP35YhLCqMFWTTZJwQHV+Rm8ACfnDnAQzTNA64xnYld25Mrw27m0p0Hoj6FBEJmQNHkExxmpWq/9g4p/S63Ee2oS3sMLDx5A5u/5BkmrfUgf3lewgYy86k/cEGEItGS4m82WD74Or81TbX0S6Onia6mtA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DSLOIrGKg4jJ3qUtdj6veRkxEKhCXIyd11FqkgzZRw=;
 b=AMAakyJYEj8FQE2wzMxuVeYxPhmmS61VfjTAVM8aDsk/QEUlKJ6oJizRnE8XGRuCc2WzcJRITZYECjDoTqSmsCgzyue9N4kkIqL51Ehey2J2wwcjLeHZcsdPTZ5QilSMkEg+0O6Ni4+bwGI7LS3kJoC7GtklBdcb8ifedxEXwZY=
Received: from DU2PR04CA0215.eurprd04.prod.outlook.com (2603:10a6:10:2b1::10)
 by AS8PR08MB7337.eurprd08.prod.outlook.com (2603:10a6:20b:444::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 13:24:49 +0000
Received: from DB5PEPF00014B93.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::6e) by DU2PR04CA0215.outlook.office365.com
 (2603:10a6:10:2b1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Tue,
 27 Jan 2026 13:24:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B93.mail.protection.outlook.com (10.167.8.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Tue, 27 Jan 2026 13:24:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hAZFghE9N7DxqAQ4AMXdmdvrX7ffoPe10apW7aFwJGz8zW5POL8QXR9fy4wDOMefuJS9n6ZoltrKaMmSJMBQRr/iT4wgO6htRMhmGV/TxclBbxQztNReIkf2lH7AtuDMBRCZBps4h+WVC5doiQCVUEaTdZJkIWRziyeG95qhxeZkslks2KLGiHmo375SXyyivUJr8VNJaIYGP86Fr9S3A3iZ2OUDE8pGCxekryWwVCNPwQ8CMW0Wq5zJLAqJSE0OYEgIRqC3RXaZamKfz/ynIw8Veb67g0d8r3B9Y244hDYE2xrX4u83VSoWPXJmMs667tTSju9K+yWp6rWfxILO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+DSLOIrGKg4jJ3qUtdj6veRkxEKhCXIyd11FqkgzZRw=;
 b=SgeN+Ct7uRYG3exTjh7hdRHlOMKJ57qB3ntnYqN0cmIVcW/TNNiuH5jy/YvwNN3nfYSvx7nBZ/gGY4LQ/TcfbYZnTGRQ6dRBd84qK3Krhstn3wLaDz4/KrE3WEVRLitTLbJDB5xU7YrPu+WE10IDgg/bVCSMavfPs3M7inVg3+5QepMBuXq0zohTy7op7LstDVmoAGICcX1mGwHa/hlStVfirHKBUDUdmo7bbUFqK4gWI+PSRpF9bTbwqcN7fQfFUrF55CyRQkPlYKe2QsES8Xv2tGM1ppm6rdAkPRXKlmIJeB2Y3ZToX3OiNOcyQi5XieVOJyYwtj5n4mc/SITvcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DSLOIrGKg4jJ3qUtdj6veRkxEKhCXIyd11FqkgzZRw=;
 b=AMAakyJYEj8FQE2wzMxuVeYxPhmmS61VfjTAVM8aDsk/QEUlKJ6oJizRnE8XGRuCc2WzcJRITZYECjDoTqSmsCgzyue9N4kkIqL51Ehey2J2wwcjLeHZcsdPTZ5QilSMkEg+0O6Ni4+bwGI7LS3kJoC7GtklBdcb8ifedxEXwZY=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DU0PR08MB8043.eurprd08.prod.outlook.com (2603:10a6:10:3e7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 13:23:46 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 13:23:46 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>, Andre Przywara <Andre.Przywara@arm.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Alexandru Elisei <Alexandru.Elisei@arm.com>,
	"will@kernel.org" <will@kernel.org>, nd <nd@arm.com>,
	"julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Topic: [PATCH kvmtool v5 3/7] arm64: nested: Add support for setting
 maintenance IRQ
Thread-Index: AQHcjHSJbLhfiNY8DEm9o2xt8kI3y7Vkw1sAgAEusYCAABVegA==
Date: Tue, 27 Jan 2026 13:23:45 +0000
Message-ID: <c3b611b88e47c534ac050d02a8b4706111d679da.camel@arm.com>
References: <20260123142729.604737-1-andre.przywara@arm.com>
	 <20260123142729.604737-4-andre.przywara@arm.com>
	 <86fr7sb69h.wl-maz@kernel.org>
	 <8db77da0-4772-499d-b140-350e4470e30d@arm.com>
In-Reply-To: <8db77da0-4772-499d-b140-350e4470e30d@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|DU0PR08MB8043:EE_|DB5PEPF00014B93:EE_|AS8PR08MB7337:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8df989-5770-4218-da5a-08de5da77285
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?cUFwZGZmMVBoZU9tQk1LcjF2TFhjVzdPenZUNjRYWWRzYjZlWDRoMnFMV3o3?=
 =?utf-8?B?bWxPOGFuN3JrdlI1VU05eHc3eElQdFdlMTNYVkdCNjJvUGMxWElBSFQ3VXB3?=
 =?utf-8?B?M3BGaUE5TFZUZ25Na0tyb3NDUHhSeGhnUFovbTBCS1c4SGVlSkhwTFU2TmxI?=
 =?utf-8?B?VVNPVEFJcjhUMDBreXJyT3NGeGl3YTVheHVlVXBCRDhDaS96ODF3QWh3VVln?=
 =?utf-8?B?RjN5SjdXUkRHM0lWVEhRMWE4UWVGZnU4citRNnNzSnpvUml5TDF3Wm1oQ1N1?=
 =?utf-8?B?L1NuNTY2MENyQkYwM28zMG5RSjI4UUNrM3ViTHVWeEduS3dFYzUvZG11aU92?=
 =?utf-8?B?ZkEyT2tPYUxYSGQxMk54dWVoV2lpUDFwY2pRWnY4ekhPTVBvOEgzWkhJUGt2?=
 =?utf-8?B?V3pTeUNKR3B0Uk91bFAxZ0lIaXEwUmdDb3lKUEFXUitKcnJZN1FnUDY3NHJa?=
 =?utf-8?B?Nm9hWnRZUnVPT3pFY1EyNWVLYm9rVDZ3WnZ1OU50MWJTUHdOMkxsTmh1K0Yw?=
 =?utf-8?B?enc3ZTl6aUg0czJRUndCVkVXWncrd0hVTW1YY2NWaWV6cC9Vb3FKTFZtVnVH?=
 =?utf-8?B?d2VycUJLcVVPU0t3ZUlGL1BiQjN6VGZhRUg1YTMzTEVhSmpuMzlNMUJVNTIx?=
 =?utf-8?B?M25xcUdDa2hOTDRQeDlPNDQwdEwwOG4xSjhBMFY1SkozOXpORW1ISTlZNThS?=
 =?utf-8?B?SDhXcEJDRS9kRGh6cmRLS0FSZi91Rkp1T3VuZlRCME9ZUHN1R1dweEU0NS9T?=
 =?utf-8?B?UWhvd3ZweWwzclBONEwzM1dRamQ5dW1aRHpxbjJGZG1vTDF1SUdUQ0xZZTRE?=
 =?utf-8?B?OW9GUWEySXdLQTRpdCtsWFBwMW1hN1RCTmx5bUl5bWlnSVdUeTBRL0dZNDFp?=
 =?utf-8?B?Znc3dXgrcVordGt6QmtxRm91T2xYTkRvOGlQMmNmTjBmSVh0UTNuM0dsUjlD?=
 =?utf-8?B?ZzFZeHlIOTJ1MG1zYWVXL0libDMvQVpqeEVWdDV0SXd5SFlIZmc5aXFKTURE?=
 =?utf-8?B?Um1qNzNDREo4VEloYmZkblQzR3pVUmR2YzFxa2k2TThjWUMvYi9VWE9tOGVL?=
 =?utf-8?B?YTN5eGdzT2s5QThPOG1aZ0V3UlZJUEo4RGFCZHo3VVVCMUsyeXhnVzVUS1Vn?=
 =?utf-8?B?NmhSdXg1ZE5lRnZ3bFVyT0RFR3JwUmltV3lWNWk0c1dzc2RmYXRLOUZvUm16?=
 =?utf-8?B?UHZzSEV1clRSVmtqWnJuanRsM0pGN1Q1Z1BqY0xrMU1UUEljK0NzSEU0bWxX?=
 =?utf-8?B?bXUxMUwvNEo1Z3NoOEFaemprZjkzM0lwOC8yU2dsUXNlSEFyTlRqN3dSdU1K?=
 =?utf-8?B?VFJGcEJEaG5GN0ZBbjNIUmNueGJrVXMrbW1yZThlbFVUUVh6aittREQ3Nmc4?=
 =?utf-8?B?dGgvSkV5QksxQkZvZ0RpM2FlQXA2TUVNbkovanB6NkxVRXVPdnVUQUFHQWpC?=
 =?utf-8?B?ZWNBM0hHRTQ5QVROakY0ZitodXljc3R0dVB6R0lzUHY4UHNGQ3lEQS84WlpD?=
 =?utf-8?B?SCtxdjN1TjNPenNLa1h5SllOWFYwTjI4WmF5NGZ0b3UzVkJ6Q0xYZkt1cG9E?=
 =?utf-8?B?dXFZM1g0R2gyV1hXbHBrZ1lUN1MwM2N2cXYrcEdGaEdVejJwUzJ2bjZtVHFT?=
 =?utf-8?B?Y2U5clNKdmJ1TnczaUFkQlFoYW1Vb29LRU9mYmNxTHRHRWRKazBRYVRhQ0VX?=
 =?utf-8?B?UGZDUkQ1c2dDdm04U1JrMExDc0RpaFYyZ0U4Z3Y1dXNZUStVVCtaQmpRdFBO?=
 =?utf-8?B?YTdEd3JNNkllbXV0dml4NEJEVU1reUtlS1Z5RVFtUVkvR3RkTnpPY2V0NFRs?=
 =?utf-8?B?RklocXdwbU9lSHViYktxbHY5akJzWUh2Q0VOcm5yRktiaVV4VDN0c2svRUIx?=
 =?utf-8?B?bkw0aFI1bHYxaWo1K1BiK3UrQUFKUk9XcU95OEZuTjdxTGhRbjd1bUVKRVZn?=
 =?utf-8?B?Vi9tc0xWRWlYT0JjenFIM1ZyK2E0SlJhTXFIQmV2QXd4djRvamxJSVY5RVZ1?=
 =?utf-8?B?VThEdmJyWmdwYWYxQnN5M1BMMFpkY2ZER1FOOWZ3a3hyaENPN1NnYmU4cUxD?=
 =?utf-8?B?clp3UzB6UHc2YUlRQjFWMlFRWDBJeERBcjVQVFJySlFEYUluS3M1WlE4SDZw?=
 =?utf-8?B?WFkydi9qcytMK2NCWjMvV1hPL1oyUURabkFBaFlGZkhCREFtbHVqOXM4SVBj?=
 =?utf-8?Q?0xLc/TdB7ELgIlv6INEMGog=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A792AFACE0C1844B8F9A32BD8A57D1A@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8043
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3ac23147-93f1-48e4-43a6-08de5da74c96
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|35042699022|82310400026|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?djRWMUdocjJOV3dDd3lNSU1XMkJUcE9XZHBxbGxBT3gyM09mVkt0MVhvUFQx?=
 =?utf-8?B?Y3YwMndyZ2VRTWlnYW92RkIvVnBtd0VtamNYTDZ4VjJpM3FsaWxCNm4vMXB1?=
 =?utf-8?B?WlBhSDh4L0NFbU9Ud0dBOWZqVFhRSExlZWI4c3JpeEE3K2hYVDJmc2xDZW9V?=
 =?utf-8?B?TFRWd3hweGRhQTNhMXRMelFHQUUzR2dyTkJZbGNCeWxBNGNVRG9sSm8yZ1ln?=
 =?utf-8?B?Rjd4VlJRcVJuR3J0MnNudWQwYUllNWwwbGQ2SlcwNFpGcW1kMngwbGduby9h?=
 =?utf-8?B?aWEzcldLWXo3Z1kreGk1Qm9MQXFTY2ZPZFVNVlNXUlhsTUhFejNGYVIwZWVh?=
 =?utf-8?B?aFg3dHVhSFU3R2Z1cEdJS2xBazdkaXI0Y29ucE10eUdKcVRkcHdJb1l3MWtj?=
 =?utf-8?B?V0k3U2tHeUFWcHlJcEFEQkVDYXpQM2lHWVpKZGMxZC9TOWNFcmdxTklUMndp?=
 =?utf-8?B?VlRjTURrb09ocjdMbkV0NGR2VVF6T2owY3ltU0dsQndXY25YLytJbldLRzZV?=
 =?utf-8?B?TDU4UjR5dTViVmpGOUQyVzZMRkdmR2FmVFVRSy9xZTJBNXkyejVMSU9aNzhH?=
 =?utf-8?B?UlFuMFRHTXhmLzNqMHBhbXdNTE8vM3c1M21OT1dxNFE0SFdEQXhEZWF4czht?=
 =?utf-8?B?VU1oZUtVN0JPM05OV2RyNzdJa2s2bFBDYVlYbmw3dE92OEpibWoyUDlsSVZu?=
 =?utf-8?B?ZTE4N1NpN3Vremh0Q1N2WDE0Y2FxZXB4cWxzNUJ1NUxpYS9jRmFxaVBPQStj?=
 =?utf-8?B?VVYrVTVMc1NZaXJMaUREM0h4MjVhakdKeU5jaWI1UXlVRlpKbGh4THg2U2dp?=
 =?utf-8?B?NVZ5UnRsQ0luVGx2MlpsaTZ3R0dQRkkrcXR0c2NSZEMxS3IvaUtPM0l1ZnBq?=
 =?utf-8?B?TUVzUUJ5alkzYkVHd2NvcSt1cHRmYnhlZDFEd2phNVpJeVh4Q2t0VmtCUld0?=
 =?utf-8?B?U0tuakUzd0VDbGV5VldDWTZ2ZDAyUGlBbXJTRjFpQzJJWWsyd3Z5Nk1HZFNl?=
 =?utf-8?B?M1diRUY2dWhZSGMvTm5iY2JDSFllTEhkVGViVnAyckVOUk1NdlZZc2ZvdVJT?=
 =?utf-8?B?dlQ3SGtKQmJZYlVlTkM5UGxRU2xsZVNmWm9iaHg1WGJhc3RIK1QzSU9aSUdX?=
 =?utf-8?B?cVRYbmVsLzhEOUpMNFpTMTdtNGdwS29YYnVxTDMrWlorbHcvdm1oUmxIczJK?=
 =?utf-8?B?R2pmcVhJUGxiallWTTJpWjRaTytKSEZGK1FYVzkzdUc5UHJvK2Y4UHdjUEM0?=
 =?utf-8?B?TU80VWVLT2RUY0tSVSs5OG5MRVd1QS9aWHo5MmZWd1g1cmJUMzQ0Q2R3Zlg4?=
 =?utf-8?B?eHcwSnpxbGwyYWsvbGhtZC9OSy9RcVBsNGkwdHJhTEdkNkdHa3ZYdWx0a0Uv?=
 =?utf-8?B?K2NsL1ZsV29VUEpIenZQMW0yWEtaMTFmZURJRzJFSDMwMUhvUWFUZDE4Y096?=
 =?utf-8?B?TmNJYWRuRDBBeDUzQUtrcXkzMEVsOGswZWVSNyt2Y0FQM2FJVVJmMHA1UGl1?=
 =?utf-8?B?TzM0WE9wYXVlY3RRVmFvMVRGdkxMQXBBdnRSVk5BOU1nZm12OWZqTVlMQVJK?=
 =?utf-8?B?eGdpaFZuOXJtU1J5K3Z0Q2dScitHMkZKdHRhU2JTbGU3eFNrNDBVVk1kVU56?=
 =?utf-8?B?U05KK0NPREtQSk1KTVl1cEJLQ3dwQ21tOGpWeU9WRTZZc3JsVDZsbEk2OEdS?=
 =?utf-8?B?NUlDQ1pRSGZPZnVpVEl1REVjRnJwWmdzYW43L3Bmc1N1cFNLeVhwM0dMbHZB?=
 =?utf-8?B?eXVhaVFiODdvQTZyNGRoY0pRWXRrU0ZEODk3cGRWU1VNTEpaOHRoK0s1SzE2?=
 =?utf-8?B?MUhTd3dqdFdtampVeGNqeE8zT3F6S0Z5U1lQZVJ1UG5pQUFrdHA5Y3BxVEdY?=
 =?utf-8?B?TW1SaTBNWkkxMXdBckQrZ0w5L1JFV3pwVDU4bWtiUFlLakxjTUF2ZGowc0tW?=
 =?utf-8?B?Vks0YmxzR0xUL1hEdEFJQjVLTGh0RHFpdjJRbkllK05vei9QWUk3eUpHU09i?=
 =?utf-8?B?cEVNM0MvK0ZtMnNZREhsQWZReEI5bGtiRTNCdkVObGk1d01yVW1TK28zc0VB?=
 =?utf-8?B?S0hUSHN5RFF5dFZGOWhUN21QMTk4ZlJpVnZGVUlhVmZvZm5ubGdyV2hDc2Z6?=
 =?utf-8?B?L0F2ZzJhZS9OMnhOdDJuSWtsOFQ0NVB6b0wwY0V4VFk2R2VZVXgrUzZVZ0hh?=
 =?utf-8?B?RmRWeStoSTM1Mlg2RzhrT2h2QUJZOVhuK0ptTjNLTXhTQ2kwV2V3TENsSHhj?=
 =?utf-8?B?dW1BM2swTFV6a3hSSG4zVWIvclVnPT0=?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(35042699022)(82310400026)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 13:24:49.4343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8df989-5770-4218-da5a-08de5da77285
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7337
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,arm.com,kernel.org,gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69246-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 5019A94E15
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAxLTI3IGF0IDEyOjA3ICswMDAwLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToN
Cj4gSGkgTWFyYywNCj4gDQo+IE9uIDI2LzAxLzIwMjYgMTg6MDMsIE1hcmMgWnluZ2llciB3cm90
ZToNCj4gPiBPbiBGcmksIDIzIEphbiAyMDI2IDE0OjI3OjI1ICswMDAwLA0KPiA+IEFuZHJlIFBy
enl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gVXNl
cyB0aGUgbmV3IFZHSUMgS1ZNIGRldmljZSBhdHRyaWJ1dGUgdG8gc2V0IHRoZSBtYWludGVuYW5j
ZQ0KPiA+ID4gSVJRLg0KPiA+ID4gVGhpcyBpcyBmaXhlZCB0byB1c2UgUFBJIDksIGFzIGEgcGxh
dGZvcm0gZGVjaXNpb24gbWFkZSBieQ0KPiA+ID4ga3ZtdG9vbCwNCj4gPiA+IG1hdGNoaW5nIHRo
ZSBTQlNBIHJlY29tbWVuZGF0aW9uLg0KPiA+ID4gVXNlIHRoZSBvcHBvcnR1bml0eSB0byBwYXNz
IHRoZSBrdm0gcG9pbnRlciB0bw0KPiA+ID4gZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXMoKSwNCj4g
PiA+IGFzIHRoaXMgc2ltcGxpZmllcyB0aGUgY2FsbCBhbmQgYWxsb3dzIHVzIGFjY2VzcyB0byB0
aGUNCj4gPiA+IG5lc3RlZF92aXJ0DQo+ID4gPiBjb25maWcgdmFyaWFibGUgb24gdGhlIHdheS4N
Cj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5kcmUgUHJ6eXdhcmEgPGFuZHJlLnByenl3
YXJhQGFybS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IMKgIGFybTY0L2FybS1jcHUuY8KgwqDCoMKg
wqDCoMKgwqAgfMKgIDIgKy0NCj4gPiA+IMKgIGFybTY0L2dpYy5jwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHwgMjkgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4gPiA+IMKgIGFybTY0
L2luY2x1ZGUva3ZtL2dpYy5oIHzCoCAyICstDQo+ID4gPiDCoCAzIGZpbGVzIGNoYW5nZWQsIDI5
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQg
YS9hcm02NC9hcm0tY3B1LmMgYi9hcm02NC9hcm0tY3B1LmMNCj4gPiA+IGluZGV4IDY5YmIyY2Iy
Li4wODQzYWMwNSAxMDA2NDQNCj4gPiA+IC0tLSBhL2FybTY0L2FybS1jcHUuYw0KPiA+ID4gKysr
IGIvYXJtNjQvYXJtLWNwdS5jDQo+ID4gPiBAQCAtMTQsNyArMTQsNyBAQCBzdGF0aWMgdm9pZCBn
ZW5lcmF0ZV9mZHRfbm9kZXModm9pZCAqZmR0LA0KPiA+ID4gc3RydWN0IGt2bSAqa3ZtKQ0KPiA+
ID4gwqAgew0KPiA+ID4gwqDCoAlpbnQgdGltZXJfaW50ZXJydXB0c1s0XSA9IHsxMywgMTQsIDEx
LCAxMH07DQo+ID4gPiDCoCANCj4gPiA+IC0JZ2ljX19nZW5lcmF0ZV9mZHRfbm9kZXMoZmR0LCBr
dm0tPmNmZy5hcmNoLmlycWNoaXApOw0KPiA+ID4gKwlnaWNfX2dlbmVyYXRlX2ZkdF9ub2Rlcyhm
ZHQsIGt2bSk7DQo+ID4gPiDCoMKgCXRpbWVyX19nZW5lcmF0ZV9mZHRfbm9kZXMoZmR0LCBrdm0s
IHRpbWVyX2ludGVycnVwdHMpOw0KPiA+ID4gwqDCoAlwbXVfX2dlbmVyYXRlX2ZkdF9ub2Rlcyhm
ZHQsIGt2bSk7DQo+ID4gPiDCoCB9DQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJtNjQvZ2ljLmMgYi9h
cm02NC9naWMuYw0KPiA+ID4gaW5kZXggYjBkM2ExYWIuLjJhNTk1MTg0IDEwMDY0NA0KPiA+ID4g
LS0tIGEvYXJtNjQvZ2ljLmMNCj4gPiA+ICsrKyBiL2FybTY0L2dpYy5jDQo+ID4gPiBAQCAtMTEs
NiArMTEsOCBAQA0KPiA+ID4gwqAgDQo+ID4gPiDCoCAjZGVmaW5lIElSUUNISVBfR0lDIDANCj4g
PiA+IMKgIA0KPiA+ID4gKyNkZWZpbmUgR0lDX01BSU5UX0lSUQk5DQo+ID4gPiArDQo+ID4gPiDC
oCBzdGF0aWMgaW50IGdpY19mZCA9IC0xOw0KPiA+ID4gwqAgc3RhdGljIHU2NCBnaWNfcmVkaXN0
c19iYXNlOw0KPiA+ID4gwqAgc3RhdGljIHU2NCBnaWNfcmVkaXN0c19zaXplOw0KPiA+ID4gQEAg
LTMwMiwxMCArMzA0LDE1IEBAIHN0YXRpYyBpbnQgZ2ljX19pbml0X2dpYyhzdHJ1Y3Qga3ZtICpr
dm0pDQo+ID4gPiDCoCANCj4gPiA+IMKgwqAJaW50IGxpbmVzID0gaXJxX19nZXRfbnJfYWxsb2Nh
dGVkX2xpbmVzKCk7DQo+ID4gPiDCoMKgCXUzMiBucl9pcnFzID0gQUxJR04obGluZXMsIDMyKSAr
IEdJQ19TUElfSVJRX0JBU0U7DQo+ID4gPiArCXUzMiBtYWludF9pcnEgPSBHSUNfUFBJX0lSUV9C
QVNFICsgR0lDX01BSU5UX0lSUTsNCj4gPiA+IMKgwqAJc3RydWN0IGt2bV9kZXZpY2VfYXR0ciBu
cl9pcnFzX2F0dHIgPSB7DQo+ID4gPiDCoMKgCQkuZ3JvdXAJPSBLVk1fREVWX0FSTV9WR0lDX0dS
UF9OUl9JUlFTLA0KPiA+ID4gwqDCoAkJLmFkZHIJPSAodTY0KSh1bnNpZ25lZCBsb25nKSZucl9p
cnFzLA0KPiA+ID4gwqDCoAl9Ow0KPiA+ID4gKwlzdHJ1Y3Qga3ZtX2RldmljZV9hdHRyIG1haW50
X2lycV9hdHRyID0gew0KPiA+ID4gKwkJLmdyb3VwCT0gS1ZNX0RFVl9BUk1fVkdJQ19HUlBfTUFJ
TlRfSVJRLA0KPiA+ID4gKwkJLmFkZHIJPSAodTY0KSh1bnNpZ25lZCBsb25nKSZtYWludF9pcnEs
DQo+ID4gPiArCX07DQo+ID4gPiDCoMKgCXN0cnVjdCBrdm1fZGV2aWNlX2F0dHIgdmdpY19pbml0
X2F0dHIgPSB7DQo+ID4gPiDCoMKgCQkuZ3JvdXAJPSBLVk1fREVWX0FSTV9WR0lDX0dSUF9DVFJM
LA0KPiA+ID4gwqDCoAkJLmF0dHIJPSBLVk1fREVWX0FSTV9WR0lDX0NUUkxfSU5JVCwNCj4gPiA+
IEBAIC0zMjUsNiArMzMyLDE2IEBAIHN0YXRpYyBpbnQgZ2ljX19pbml0X2dpYyhzdHJ1Y3Qga3Zt
ICprdm0pDQo+ID4gPiDCoMKgCQkJcmV0dXJuIHJldDsNCj4gPiA+IMKgwqAJfQ0KPiA+ID4gwqAg
DQo+ID4gPiArCWlmIChrdm0tPmNmZy5hcmNoLm5lc3RlZF92aXJ0KSB7DQo+ID4gPiArCQlyZXQg
PSBpb2N0bChnaWNfZmQsIEtWTV9IQVNfREVWSUNFX0FUVFIsDQo+ID4gPiAmbWFpbnRfaXJxX2F0
dHIpOw0KPiA+ID4gKwkJaWYgKCFyZXQpDQo+ID4gPiArCQkJcmV0ID0gaW9jdGwoZ2ljX2ZkLCBL
Vk1fU0VUX0RFVklDRV9BVFRSLA0KPiA+ID4gJm1haW50X2lycV9hdHRyKTsNCj4gPiA+ICsJCWlm
IChyZXQpIHsNCj4gPiA+ICsJCQlwcl9lcnIoImNvdWxkIG5vdCBzZXQgbWFpbnRlbmFuY2UNCj4g
PiA+IElSUVxuIik7DQo+ID4gPiArCQkJcmV0dXJuIHJldDsNCj4gPiA+ICsJCX0NCj4gPiA+ICsJ
fQ0KPiA+ID4gKw0KPiA+ID4gwqDCoAlpcnFfX3JvdXRpbmdfaW5pdChrdm0pOw0KPiA+ID4gwqAg
DQo+ID4gPiDCoMKgCWlmICghaW9jdGwoZ2ljX2ZkLCBLVk1fSEFTX0RFVklDRV9BVFRSLA0KPiA+
ID4gJnZnaWNfaW5pdF9hdHRyKSkgew0KPiA+ID4gQEAgLTM0Miw3ICszNTksNyBAQCBzdGF0aWMg
aW50IGdpY19faW5pdF9naWMoc3RydWN0IGt2bSAqa3ZtKQ0KPiA+ID4gwqAgfQ0KPiA+ID4gwqAg
bGF0ZV9pbml0KGdpY19faW5pdF9naWMpDQo+ID4gPiDCoCANCj4gPiA+IC12b2lkIGdpY19fZ2Vu
ZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgZW51bSBpcnFjaGlwX3R5cGUgdHlwZSkNCj4gPiA+
ICt2b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwgc3RydWN0IGt2bSAqa3Zt
KQ0KPiA+ID4gwqAgew0KPiA+ID4gwqDCoAljb25zdCBjaGFyICpjb21wYXRpYmxlLCAqbXNpX2Nv
bXBhdGlibGUgPSBOVUxMOw0KPiA+ID4gwqDCoAl1NjQgbXNpX3Byb3BbMl07DQo+ID4gPiBAQCAt
MzUwLDggKzM2NywxMiBAQCB2b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZkdCwg
ZW51bQ0KPiA+ID4gaXJxY2hpcF90eXBlIHR5cGUpDQo+ID4gPiDCoMKgCQljcHVfdG9fZmR0NjQo
QVJNX0dJQ19ESVNUX0JBU0UpLA0KPiA+ID4gY3B1X3RvX2ZkdDY0KEFSTV9HSUNfRElTVF9TSVpF
KSwNCj4gPiA+IMKgwqAJCTAsIDAsCQkJCS8qIHRvIGJlIGZpbGxlZA0KPiA+ID4gKi8NCj4gPiA+
IMKgwqAJfTsNCj4gPiA+ICsJdTMyIG1haW50X2lycVtdID0gew0KPiA+ID4gKwkJY3B1X3RvX2Zk
dDMyKEdJQ19GRFRfSVJRX1RZUEVfUFBJKSwNCj4gPiA+IGNwdV90b19mZHQzMihHSUNfTUFJTlRf
SVJRKSwNCj4gPiA+ICsJCWdpY19fZ2V0X2ZkdF9pcnFfY3B1bWFzayhrdm0pIHwNCj4gPiA+IElS
UV9UWVBFX0xFVkVMX0hJR0gNCj4gPiA+ICsJfTsNCj4gPiANCj4gPiBUaGlzIGxvb2tzIHV0dGVy
bHkgYnJva2VuLCBhbmQgbXkgZ3Vlc3RzIGJhcmYgb24gdGhpczoNCj4gPiANCj4gPiDCoMKgwqDC
oMKgwqDCoMKgIGludGMgew0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNv
bXBhdGlibGUgPSAiYXJtLGdpYy12MyI7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgI2ludGVycnVwdC1jZWxscyA9IDwweDAzPjsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpbnRlcnJ1cHQtY29udHJvbGxlcjsNCj4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZWcgPSA8MHgwMCAweDNmZmYwMDAwIDB4MDAgMHgxMDAwMCAweDAw
DQo+ID4gMHgzZmVmMDAwMCAweDAwIDB4MTAwMDAwPjsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpbnRlcnJ1cHRzID0gPDB4MDEgMHgwOSAweDQwMDAwMDA+Ow0KPiANCj4g
QWggeWVhaCwgc29ycnksIHRoYXQncyBvZiBjb3Vyc2UgY29tcGxldGUgYmx1bmRlciwgdGhpcyBn
b3QgbG9zdCBpbiANCj4gdHJhbnNsYXRpb24gYmV0d2VlbiB2MyBhbmQgdjQuDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBeXl5eXl5eXl5eXg0KPiA+IEFyZSB5b3UgdGVzdGluZyBvbiBh
IGJpZy1lbmRpYW4gYm94Pz8/IEkgZml4ZWQgaXQgd2l0aCB0aGUgcGF0Y2hsZXQNCj4gPiBiZWxv
dywgYnV0IEkgYWxzbyB3b25kZXIgd2h5IHlvdSBhZGRlZA0KPiA+IGdpY19fZ2V0X2ZkdF9pcnFf
Y3B1bWFzaygpLi4uDQo+IA0KPiB0aGlzIHdhcyB0byBhY2NvbW1vZGF0ZSBHSUN2MiAoaXQgcmV0
dXJucyAwIGZvciBHSUN2MyksIGFuZCB3YXMgdGhlIA0KPiBlcXVpdmFsZW50IG9mIHRoZSBoYXJk
Y29kZWQgMHhmZjA0IHdlIGhhZCBiZWZvcmUuIEFuZCB0aG91Z2ggSSBndWVzcyANCj4gdGhlcmUg
d291bGQgYmUgbm8gb3ZlcmxhcCBiZXR3ZWVuIG1hY2hpbmVzIHN1cHBvcnRpbmcgbmVzdGVkIHZp
cnQgYW5kDQo+IGhhdmluZyBhIEdJQ3YyIG9yIGEgR0lDdjIgZW11bGF0aW9uIGNhcGFibGUgR0lD
djMsIEkgYWRkZWQgdGhpcyBmb3INCj4gdGhlIA0KPiBzYWtlIG9mIGNvbXBsZXRlbmVzcyBhbnl3
YXksIGFzIGl0IGRpZG4ndCBmZWVsIHJpZ2h0IHRvIG1ha2UgdGhpcyANCj4gYXNzdW1wdGlvbiBp
biB0aGUgb3RoZXJ3aXNlIGdlbmVyaWMgY29kZS4NCj4gDQo+IENvbnNpZGVyIHRoaXMgZml4ZWQu
DQo+IA0KPiBDaGVlcnMsDQo+IEFuZHJlDQoNClNlZW1zIEknZCBtaXNzZWQgdGhpcyBpbiB2NC4g
U29ycnkhDQoNCkhvd2V2ZXIsIHRoaXMgbWFkZSBtZSB0aGluayBhYm91dCBHSUN2NSBndWVzdHMu
IFJpZ2h0IG5vdyBvbmUgY2FuIHRyeQ0KYW5kIGNyZWF0ZSBhIG5lc3RlZCBndWVzdCB3aXRoIEdJ
Q3YyLiBBdHRlbXB0aW5nIHRvIGRvIHNvIGZhaWxzIGENCmxpdHRsZSB1bmdyYWNlZnVsbHk6DQoN
CiAgRXJyb3I6IGNvdWxkIG5vdCBzZXQgbWFpbnRlbmFuY2UgSVJRDQoNCiAgV2FybmluZzogRmFp
bGVkIGluaXQ6IGdpY19faW5pdF9naWMNCg0KICBGYXRhbDogSW5pdGlhbGlzYXRpb24gZmFpbGVk
DQoNCkl0IG1pZ2h0IGJlIHdvcnRoIGNhdGNoaW5nIHRoZSB2MiArIG5lc3RlZCBjb21ibyBleHBs
aWNpdGx5IGFuZA0KcmV0dXJuaW5nIGEgc2xpZ2h0bHkgbW9yZSB1c2VmdWwgZXJyb3IuDQoNClRo
YW5rcywNClNhc2NoYQ0KDQo+IA0KPiA+IA0KPiA+IAlNLg0KPiA+IA0KPiA+IGRpZmYgLS1naXQg
YS9hcm02NC9naWMuYyBiL2FybTY0L2dpYy5jDQo+ID4gaW5kZXggMmE1OTUxOC4uNjQwZmYzNSAx
MDA2NDQNCj4gPiAtLS0gYS9hcm02NC9naWMuYw0KPiA+ICsrKyBiL2FybTY0L2dpYy5jDQo+ID4g
QEAgLTM2OSw3ICszNjksNyBAQCB2b2lkIGdpY19fZ2VuZXJhdGVfZmR0X25vZGVzKHZvaWQgKmZk
dCwgc3RydWN0DQo+ID4ga3ZtICprdm0pDQo+ID4gwqDCoAl9Ow0KPiA+IMKgwqAJdTMyIG1haW50
X2lycVtdID0gew0KPiA+IMKgwqAJCWNwdV90b19mZHQzMihHSUNfRkRUX0lSUV9UWVBFX1BQSSks
DQo+ID4gY3B1X3RvX2ZkdDMyKEdJQ19NQUlOVF9JUlEpLA0KPiA+IC0JCWdpY19fZ2V0X2ZkdF9p
cnFfY3B1bWFzayhrdm0pIHwNCj4gPiBJUlFfVFlQRV9MRVZFTF9ISUdIDQo+ID4gKwkJY3B1X3Rv
X2ZkdDMyKGdpY19fZ2V0X2ZkdF9pcnFfY3B1bWFzayhrdm0pIHwNCj4gPiBJUlFfVFlQRV9MRVZF
TF9ISUdIKSwNCj4gPiDCoMKgCX07DQo+ID4gwqAgDQo+ID4gwqDCoAlzd2l0Y2ggKGt2bS0+Y2Zn
LmFyY2guaXJxY2hpcCkgew0KPiA+IA0KPiANCg0K

