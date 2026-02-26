Return-Path: <kvm+bounces-72017-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0E7SHc1woGk7jwQAu9opvQ
	(envelope-from <kvm+bounces-72017-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:11:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 385791A9BC2
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 01E283092821
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010FB43636B;
	Thu, 26 Feb 2026 15:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ce1jjHcp";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ce1jjHcp"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013027.outbound.protection.outlook.com [52.101.72.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46957427A07
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121438; cv=fail; b=AX1r6buRSaNA7jl5PkYLWrnGthn2cujEzkXWawDw4YoscyL4dAl6MPpPI5c3s/M7awKwuHQm3RV0z4YLyfnW7wmVIWIiad3j+Si8azG2Zkn75pgGvSan/9FphDxMW3m5KYcZM7lxewPTwqJVP7KxVXG+eYJbgN+400MqzQRch7w=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121438; c=relaxed/simple;
	bh=W7PXQy1ZL3XbOv8ffaqrw7zzItFZGbY7SBynxiwIHMo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ed1bjGcItJCCmg0tcX1JGb8K3A/lLOhjnchN1ogStXfAjmQ5D4ySwo3t5hI1Zjll7uXCv6sUb8McI6GU1ivMLAj5GQfoXQRKd0Iflfs7MjJ8I/t7gNNlfSHfQGFmFIKDW2/kdtF24ro9pwR6nh6wwFKgAYIiKchQmTR3vXyAq5Y=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ce1jjHcp; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ce1jjHcp; arc=fail smtp.client-ip=52.101.72.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dgZapdwAqpoGDZ4jctrnqj3ebEmm1lBKNFWoec+yAHvuT/b8yFIzbuVgHV/UqCn9luzIAN/uaIbmOqq/EOCmkTzq7pAu9HuTsTp/ZtsHfzvl9w1eImfvKvIqNNuCoo5aP9LQUhdSboXFqXhsUshciQsmrHBC90vQfzdRofHQB5Zzanpv3qYiNUtlRpckiZQh5tZZHRuPdfQyEP91usObj9fBn04A58qdyjnFUwuJK4b9df6klay9CEqCwObPXVnrXnmfvpzz82dvgxAhRrkscgnIz87fYgQzUGsnYhxTZYlM16aOSfTycVYfIPRulPv7n9VmKkLddeesVvmS9rwhww==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7PhNsvh9tyVgToPnytx03JUdb9I8dMqeG9LcFGLC4o=;
 b=GEr2ToAWsIpNTO3UhNgKUF/R8KUGSD7E1lokeUJAyvdPl5YN1nRvKRyjyZTaLYYHdi/JBt+aEIO+IZLOvv7j1+4YZRvRqE/eGYsuEGrka/prMcA6G2pKrXX+DYDWqx/94FiALAo3cA1P2XEyq7tRuxYsQEuJfeEToJ4QR7cUpxVR+KOrmIYPjOb7g0Tkp5oFsHDhTQR+lPhhC0BwJYNKmk2cgHegtNGZrfqpi4e1/KwOZLyVUymeAjSPwIOcgk48DgMmMdQ9P4u5FuEZ0lIRqzlxkB9QG3HnzOL5dwiictx921O5M6MScSoQ+Q0Dn2Myz3I8vlVpugMdQsEqA0NLSg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7PhNsvh9tyVgToPnytx03JUdb9I8dMqeG9LcFGLC4o=;
 b=Ce1jjHcpJZCVU1XObnYI/txMP3iPenK4sWTSX3UpeTTOgHKq63RlyWTzpw9ofnGuMYnaGqwSVF6s8Z32mCgL/XK6O57nQx1XRl5O42LhBMLp1+xQNYfizbhqn5LvjH63JHOcL1T6WT44mrTibHe2VNZ118NxXylzxPVA2Pkqc1A=
Received: from DUZPR01CA0013.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::6) by PAVPR08MB9795.eurprd08.prod.outlook.com
 (2603:10a6:102:31f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:57:01 +0000
Received: from DB5PEPF00014B91.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::ac) by DUZPR01CA0013.outlook.office365.com
 (2603:10a6:10:3c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 15:56:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B91.mail.protection.outlook.com (10.167.8.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:57:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCEFZ67TreKyKodIfua4x49VmHhRCpfLFQik/HwJQGKylS6BzoXwsRUT8ObpQTIVkU0oqM9W+pC/hy7+j3K9OaP11PwYLWRXsXbI4+V506EKcuufyjUbcQDw+EtshBtcdmBpXULgntjrdvNKeDxaheMybQR3cqTvHL5WBuOUIHYbCQTk+fY1OUJU1NOx6smB0Ca8jn/g7ofHXGypSAz3QQz5+oagvK0kRfRJHIffJ1ABMb7j9ktlasN1yoK7Vn/c+OOt4KjGydnCo0An5Clev6Y1orSY3sYJrYppJ4UkXITKMSXSKOIudZJavqiR4Vz5dgz/uDeYKXhFl9EZ99T2tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7PhNsvh9tyVgToPnytx03JUdb9I8dMqeG9LcFGLC4o=;
 b=ccjwwGRh5K0A10xRrg4o3HW7HmgDiQxgkXPC69GMDt/z025rqZ7WDy7c9bdaKvxmAQ/LaKSWwFZA9AM9M2Bwr9luY4ny9RBPIpBu6MhihnUEoIOC9ronZbDM7gnZLJ56vmOxMv47B1asU7BKBHZ014tzVK8JvjPOkS+2/qyIWuZeDbEJ21HMhjSW8N79Gw85eY2qOhuDFsGMTHqeCoc0+JBox9GI1/RT088ACrBFsNxd2h2BhElMByQy3D2Yx8+9ux7VRFJVgve/9lxznGN2KnVTcE4srF+PKOQrBSaBMrYoY6MkyQeCKmBvYTZaLpsEvCtSStw1QiJE0c1Rcz3NEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e7PhNsvh9tyVgToPnytx03JUdb9I8dMqeG9LcFGLC4o=;
 b=Ce1jjHcpJZCVU1XObnYI/txMP3iPenK4sWTSX3UpeTTOgHKq63RlyWTzpw9ofnGuMYnaGqwSVF6s8Z32mCgL/XK6O57nQx1XRl5O42LhBMLp1+xQNYfizbhqn5LvjH63JHOcL1T6WT44mrTibHe2VNZ118NxXylzxPVA2Pkqc1A=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by AS2PR08MB8999.eurprd08.prod.outlook.com (2603:10a6:20b:5fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:55:56 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:55:56 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: nd <nd@arm.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, Joey Gouly
	<Joey.Gouly@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "peter.maydell@linaro.org"
	<peter.maydell@linaro.org>, "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
	Timothy Hayes <Timothy.Hayes@arm.com>, "jonathan.cameron@huawei.com"
	<jonathan.cameron@huawei.com>
Subject: [PATCH v5 02/36] KVM: arm64: vgic: Rework vgic_is_v3() and add
 vgic_host_has_gicvX()
Thread-Topic: [PATCH v5 02/36] KVM: arm64: vgic: Rework vgic_is_v3() and add
 vgic_host_has_gicvX()
Thread-Index: AQHcpzhk5vrjFJKawEmC1MMqLV3pAw==
Date: Thu, 26 Feb 2026 15:55:56 +0000
Message-ID: <20260226155515.1164292-3-sascha.bischoff@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
In-Reply-To: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|AS2PR08MB8999:EE_|DB5PEPF00014B91:EE_|PAVPR08MB9795:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ab6e3ae-0e36-4585-5624-08de754fadd7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 nTjttJLyHt92XKgCg+q/LblmG50R6NtZCy7C58daLsN9WA277sTemo7QgxD47eP+/rzQlWTRPajCciqVcFDX6OkGtjG2miOqfWo9+NiE6LkfgBw2grIKSdZ2MUbUW15Wp6GAWZbk2kJkOyCpTuyuL+UdE9AZpCKWKKyAg2/jinGsA3FwXPQLIhxoBr5yZnjvJQccfBhmNTA4c6tYjNUkd9cvWRtTccPRo//ARtTjXoDejtwsjcxk409JV1BL0xQTnmetFLvJ7T/YYMyLWediulWAv0foMtsdHHIKCr31dLcZSgTf+uooMg/+pvUrpBZXZzGpygj1WUXWFzxM7zRbK28BrVPUa69zZS+dygOx/D+AZNf2PaLCduzUea9LoQ2Bw8PsUXb5izN7hRunucFxneoBKcBMxK6Z7GjTWdLu1ydC8P16+jJYRdH6O0WoBzyIFBzCNAP8g6/ngzbyl7nHa49hzH6qW/iMvDEaxXnyZja60+fgNRTNAbZmdxoiwIX077I7L8OIQhgypYwjVZSj0qofgbHpFDvDeWzNAh3astE7MEs7y3s+uXgYDHfOYa4rR7OnLdMi0JYJID3Y43z27zWq/wprUecHiLINFe3UzVzWVj0iSfqWWj1B6bZuCk0YijUm64THfHc/2cHjYNnBOuWQpoLOgV6c0tg+wE8sK9Tc0WZA+MYgvrm2U2yQTEKfpZ4gIE5FidKJpPjOZO7LF5lI4zj+MsLxUbHM7NQStnOV7wXrKNCfF9AUVGclrW6ipqhr1ybz+cs/wAbN96NkcNj1mqqACplHQLyV3KSGN7M=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8999
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	267bdfec-d103-4eaa-d3c7-08de754f8769
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|36860700013|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	21WKYHgr+HFSVOHWPihmuyW8lusW4BFxMGjV/XIgGNbdmmjn9olyJjg2xtSxkT5V9UZ/mnf1f6kdiNmWPAVqeR8hA8Rb90t/v6sIecUaiaaZZizolad8HFT6wX5Vpjf9nWTo6+Bc3bSrV04JWRHSQcnoXFwYfAtRHcZXfnpECYBFdVwzYhruMKO1Sb8UqabKHi0XCTFwvREf8rer3sTILXj2QUI+wa4zTGH7wV+gbi897FgkcDspgSKrS+3PyfRU2xpV5bG6y1MhZsK8wsTOvF7ew/xR3HvIPdTG7wlJhQjjAA0/LjfFztRbNFUx+WtIafkzRpvPNifREWAdHcC3UAUfR0P38JUkda1XUiSneQycnCbyPpRjE2JfvnWYmI11Ud76yp3OjDqKqQb/0qKSL6yeOWFgxliOX25sucGeB4nmYv5C4unuNnlZEdx05BO9wSJ+drgni5szpH9N/ljzrui6aIldnaU+TR84g3L8AdOlSpPZkacoTVgniEd3nbcePkQTRu4fPSUmogkTY6Nq7YR4wYGmYnl1F04hqp8DWpD0N5YVJwgpQc5JiE++j8wBP8FCOkTsptpL+GpW/1wSRteVjVzMvzPc0a3CoMR1WFEQ1LHdjRvLsCjc7RRgEh2AuehYfjM7swT/8gnYnXXeodaQzRdnt05b8kR/cLH4yoP1KZwmxzLoee2ZIxQJVlJCksdYJk1YxR29A+wZxrbpHxHhZq0CGrrg399L30v2RLSSok7iiushQnT5if0WUdakVZ6GKWMbY3qz3LGMxT44dUY0LQrQgyIQmkwNyQH+hmW1E9uaFzEydAg1qHVi6t5XRsLoqLmzsddJr+upC1m1tA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(36860700013)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BgAoazghF8HJLaHwIAvCiMrR6n6jcSW9fiyUA8nb0zb5RFFspHw/zqpjiEDpRexTuzGSVV5O2G0XAKiQwDoB+V53b+2Rt947PI4UCcQop3SEX9I1OhIRzH7+mRNnzltRzFyZDNt+F/UwpCuM0wlj8/5DEDepfozzZsAd6grI7PL1YFmotn/djWsyytrcTVTpoAFtqScUafuTTdrZH9HYHVAEyz6U4ZHHwnSomMnvi+2uFYGM68gHiWJDz8zDqJ6knb4QeIeu+98/0auDalyRj3EIZTnkvFA1GHavG+61e+nYrlY4j59tpw8sMRmkMozSMUHeZ6yp8UvFDLMf8c0YQjhapvGPDqDC9Z7HDlb5CMhMbOb/diasFQvDhS+UISZQbXrKnCH6C43K3BWudUYuSgoJdYYhAQ+x3IUOLLCORSzmqjoT3Mv5+wwPcx6lYNEP
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:57:01.1529
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab6e3ae-0e36-4585-5624-08de754fadd7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAVPR08MB9795
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72017-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 385791A9BC2
X-Rspamd-Action: no action

The GIC version checks used to determine host capabilities and guest
configuration have become somewhat conflated (in part due to the
addition of GICv5 support). vgic_is_v3() is a prime example, which
prior to this change has been a combination of guest configuration and
host cabability.

Split out the host capability check from vgic_is_v3(), which now only
checks if the vgic model itself is GICv3. Add two new functions:
vgic_host_has_gicv3() and vgic_host_has_gicv5(). These explicitly
check the host capabilities, i.e., can the host system run a GICvX
guest or not.

The vgic_is_v3() check in vcpu_set_ich_hcr() has been replaced with
vgic_host_has_gicv3() as this only applies on GICv3-capable hardware,
and isn't strictly only applicable for a GICv3 guest (it is actually
vital for vGICv2 on GICv3 hosts).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c     |  2 +-
 arch/arm64/kvm/vgic/vgic-v3.c |  2 +-
 arch/arm64/kvm/vgic/vgic.h    | 17 +++++++++++++----
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b4e78958ede12..270f1c927c35b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1982,7 +1982,7 @@ static u64 sanitise_id_aa64pfr0_el1(const struct kvm_=
vcpu *vcpu, u64 val)
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, CSV3, IMP);
 	}
=20
-	if (vgic_is_v3(vcpu->kvm)) {
+	if (vgic_host_has_gicv3()) {
 		val &=3D ~ID_AA64PFR0_EL1_GIC_MASK;
 		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 386ddf69a9c51..7fc2e0deccff2 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -499,7 +499,7 @@ void vcpu_set_ich_hcr(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 =3D &vcpu->arch.vgic_cpu.vgic_v3;
=20
-	if (!vgic_is_v3(vcpu->kvm))
+	if (!vgic_host_has_gicv3())
 		return;
=20
 	/* Hide GICv3 sysreg if necessary */
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c9b3bb07e483c..0bb8fa10bb4ef 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -454,15 +454,24 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu);
 void vgic_v3_handle_nested_maint_irq(struct kvm_vcpu *vcpu);
 void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
-static inline bool vgic_is_v3_compat(struct kvm *kvm)
+static inline bool vgic_is_v3(struct kvm *kvm)
+{
+	return kvm->arch.vgic.vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3;
+}
+
+static inline bool vgic_host_has_gicv3(void)
 {
-	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
+	/*
+	 * Either the host is a native GICv3, or it is GICv5 with
+	 * FEAT_GCIE_LEGACY.
+	 */
+	return kvm_vgic_global_state.type =3D=3D VGIC_V3 ||
 		kvm_vgic_global_state.has_gcie_v3_compat;
 }
=20
-static inline bool vgic_is_v3(struct kvm *kvm)
+static inline bool vgic_host_has_gicv5(void)
 {
-	return kvm_vgic_global_state.type =3D=3D VGIC_V3 || vgic_is_v3_compat(kvm=
);
+	return kvm_vgic_global_state.type =3D=3D VGIC_V5;
 }
=20
 int vgic_its_debug_init(struct kvm_device *dev);
--=20
2.34.1

