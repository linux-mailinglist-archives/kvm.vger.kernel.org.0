Return-Path: <kvm+bounces-72041-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GOzuJTx1oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72041-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:30:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC591AA69D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:30:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2DD5E30BE852
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7CA647ECDD;
	Thu, 26 Feb 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZSxY2b7v";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZSxY2b7v"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010062.outbound.protection.outlook.com [52.101.84.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C365F47DF95
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.62
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121728; cv=fail; b=KONYIwG9UxADwQHuiRUXTbvyyuH59cZuPuz4ZcE04CU/2de7WEMeGC+PDrD1U4UX6wjCJO/SzqWYYQdDonX19gtfdFdOtiTx85vRqn+FEMjWF+bPrQQnqX6QzIaukZpH7FedFjUO9ygcWZQtZnitA+aOOmLzs70kkpD9Zok605A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121728; c=relaxed/simple;
	bh=CUOrEEisuZRPECzLwN7DTIpDGWcvxCyeUTqnqpbrwHE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mDqtgPVQ6jY98ILuJvSr7xLiv/dPQ/c+WH6IK1U7J37OG+5obAxYFIFG1k1J1GDirv2FV9whYB9eX8mE+kCCjQER6lOLiignxX/Cx8GLTrW3xckMC510J8O0GgfvBU2q3EdaA2rC1q61003882cqPV7xXx8wZemis/yopY1Eu24=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZSxY2b7v; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZSxY2b7v; arc=fail smtp.client-ip=52.101.84.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tzsvxp3k4L7hGVySF7uu6Z6EcLuh9VCnhZPQah/e30JfFC13zTE1H2LLlHJEhRASfuaG2PKNkHW1T3Y4pEHLhO/FKJ8UZyoP/N3tcxDiWKCk4eZLhPjRI4k6b5rW/6z5hnpYS6vuOOkgO0UQmshTzLeCSC0kyivdYZa3AkJso7dE6g1OvWLd57N/8VfvESBtNERiAxmpF5zcxLWvulM2Qt66vsS8unMR9KgN/aM/jtv8xAQATzvDu/ZqWhw2sR7G/csH02d9RvHVLP3+HvVTdUTT+AXWO+dh1Mha9HTQ4IBCaVn8aT2WPFlXwJz5iLU04tylK6YxHClcNKk5GQ2vCA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjFhe+ijXJaPjdwO5CvSJoA2kM96MYn2uwHV+w45i5M=;
 b=AnPJgfa+goiAAW5l8L0eMep4kteyX7Tr4O8QeKMnz9HHb5uE03qoSQLqI2mNHuVj4ozJR380gAOmYucyN0XTPslheD4PhCRDZ8I6QqUEER0VBDWbnkniJbEX2iaDyyuUYwkpiD7QNH9L4whRGJPtW+w61vL8OsOrn/qytcQU0hQXYfq403fdWBAvQeI3nyXdddxjmtgxJ7nZceXumcGWxtfHwUB45bBlYIQWgb/1mz4xJ9wb65bYqyTbXWzG1eFjGjBzudBgQGwB3YOyizcMwcYWEP8z/PdGXxx12fpVHrQOGKGAzlCDIHm3lGxVLI4Lg8oTokS4AO7fHxqZqeY/Dw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjFhe+ijXJaPjdwO5CvSJoA2kM96MYn2uwHV+w45i5M=;
 b=ZSxY2b7v6bp2DXvs6uzsRvsgF2YyGlH8rghZu8BxGaHVwCFqr5xpyNVgVtYh2rSzsDb5XabinMCZDr5uH3Rkt4Fj3od20p7dpxDUEELfBV7MyCB/tYMVHnNmwpiXefAUi8+AbD+uHYvHdOlDAtuPwt98rFAD/UBWiPAogV+m8b0=
Received: from AS4P189CA0042.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::20)
 by AS8PR08MB9955.eurprd08.prod.outlook.com (2603:10a6:20b:639::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:01:55 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::9) by AS4P189CA0042.outlook.office365.com
 (2603:10a6:20b:5dd::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.25 via Frontend Transport; Thu,
 26 Feb 2026 16:01:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:01:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IAjAAzz8tkvqZAs5THp54yuTGTZhXUdRrupGJKzpxWGlBV9igFNVBnttTQf0h08DurthMpqukx0+mt4PHeQp3rTtGBZ/+p7ri1AR68fZ9M72xHcYFEcPw/LPHHb8i9c07ARaLfBCfSJJ31qWQpqXqQcx28/62L6aOeUELJ8PzChNgYCun7N/KlCGnDAq3piZbfIITrGY78sAgVHrEijf72PlkRAVSyMqhrEIQ54U/QphHRwCHCDUuxi/XhgrI9IR1jvU5pd+WY+n7SDqNul64y0PiiTkgau2cknH+E40td6DbGmxzb8je87lRZQsZDj8XeDNgL3fM5MkD1UAPA51rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjFhe+ijXJaPjdwO5CvSJoA2kM96MYn2uwHV+w45i5M=;
 b=BtulhR0/zCpmyl2YAzEF+pBZJV52BfliPdV67n0BKNPhot0wx0NfQEIU1gKlhsRMtFM+SQ6s9C0PHzYPNpYeuSVh3GE0A5Sf1xLzMoY2hAt3bMCasZQYA8kL4i5vwV7GPy1P1cM2skxyXqjgS4MpnXbo7Z3M0Uykdtz4a4BItrzYUKwcBW6oL2TUAmWl9n/RGRatx9VksLPJqUmVWYWHUi0Me338aGOHbQG7EC2TJKWjxK7IXRifYAEOauxfoR+R5I21zh2kwXnsseQX1cIzsYJvs71PbBEZWK/zH0wDMOU3+tMRrevkyx9DxzjcQ1etZYmMTvucgKBtZG9qrudgZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjFhe+ijXJaPjdwO5CvSJoA2kM96MYn2uwHV+w45i5M=;
 b=ZSxY2b7v6bp2DXvs6uzsRvsgF2YyGlH8rghZu8BxGaHVwCFqr5xpyNVgVtYh2rSzsDb5XabinMCZDr5uH3Rkt4Fj3od20p7dpxDUEELfBV7MyCB/tYMVHnNmwpiXefAUi8+AbD+uHYvHdOlDAtuPwt98rFAD/UBWiPAogV+m8b0=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:00:52 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:00:52 +0000
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
Subject: [PATCH v5 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v5 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHcpzkUzVYoTRMoC0G5+Wu5cRmy6w==
Date: Thu, 26 Feb 2026 16:00:51 +0000
Message-ID: <20260226155515.1164292-22-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|AM4PEPF00027A63:EE_|AS8PR08MB9955:EE_
X-MS-Office365-Filtering-Correlation-Id: 40ec5dd4-9c45-4b0d-d215-08de75505d0a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 a6pubE19KmpO4qag/CF8P9DWYFqc3nZ2bC2qCeihqbEjfH+WQHx2tKQJWL/SCHzthsetE79a8TC9uFFP6+cVoKLslTr6dfpJRVEzXNI/psIx8G6Wg8CdIS0X8jdyC2ByFAHg3Mf/+a0hUVCSKFHiPnEw8K9iqLBl9j/1s+n6nc39rG+T2trGv7oneYn52iY8LXyPAOxXhPVBOB+VN5pv9kE5WKuw4QxcG80yDT8F2kBBRese3DMPTkwNA8dHDoC5xDDFe6KfzZoNQRnwA8f3dr24OIV3j5HmbvgSJEu5vdTvMt/JI6PKXksGIP4P5eJywTtpQFNNf0GWTYpXzkjxItIazQ5LL4Mb21aiE1ddR3IUd/5L+iMpbVwHOSFVRs2XEhOaEFunC8vQZaJhlNnF/XZG+03CeHnY28ELSSpO1raXfLp8mO1exmkfHidFK3OXhCsaO8GisIvYw04U/R7X79VTPTYPPWO2peHlJxMxVbQBJsXVXp4nMPxUNv/hWZJYA6TXBLGcZMpzBcdUKbyglKUHcPDm8hmwilQil6GYk0BKzi49o3knYv2CwiBKYb/cc/5nUjyroj9PZTadZLwqofg0dBI67uL7KAa6/nDZAj21bC9rvLKOUwgF9ZwvOexRha2LxENynyzKT9Xvc2zOC2jUDCA3o8ZI94mErsPvGY2gXowJC9d/sRRkuUBenh84EiGY0HaJAbG/EgdtAULT3eCgi6u3V9NdrRim1fXNtXmRxsTQjpf+FUwPOCJPVirkE+qKOY7vmG+CxqCTtSXNdZA/99G/NiT5+ss0gyfbDhY=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	32e071fe-2400-4fdc-25cf-08de75503765
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|14060799003|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	YOaMRcKIl82WB4BRoHsbPPzgSklb7LZmnaEogRomkJyBjBzNOr76XIEJMkCJeXWTsl+VlLVNeVL8qvpsFA607lA4jGvgt8LJWFHcb7IwgmfvTteKgXQ8uaHqopSZ+abuzj8UN8g5rWsv7zg4cLI6ORA2pyoV3usX5DbNspV39a3w3drfZKEY1ug9xt9snzpZIGvHTmzVLXE9aANqpuO9tbTSnzrEDhyKmSaJ1tdhcW4zNfNcyr/eRxtPXdoU2XWhMQFJNN7XIuo3f0B6d2qErf1L2gTFULRIlSrxBKc6Uk8Xkmw88awZ0BSep1IHIpkkzAlzYbuMU9gCh69mX+tVlunaKc841dmoEQG3jSMwvlKLQeU2tJgMloDzqH+XeWVFdZmN+Ii5RyY6NWm3F8ervo12yJ6/61rav2FgeHn4007V7kG8gb6D5ihfe0rAFeSuFJh5pxI0oCv3C1EHP+bSan4r89Lg/cUTpm4uQppZanqZZgMxs+UFhATLybOPYghD5dicMuoyep9b07bxnAnRT1bNVjxR+Ybhn1VA7yEFZz5DRCj3c0w9b+P5C+8MIlvJmwtSIAQht5CN2ck8mff9DUrYw25rhbdbLbwgHWJMAIvPGcYcVqbDmsKxftcSiwcisCmEoqWnVuCHLfIHsBoAPebLWryZqXaChNfVS8NQbC/P22WYv9XJkpP4xRTz3WszBdpvPNxwWUO1B2JSJeiFSb+zuXhjOBNvm8NoOgPdTc2oYaMfRnrOHjAGkC7LBhYvRK3HI8tjigFFgliwK8Jk+VLw2R8rfoG3h3AfJD2mnaTumbm7LjWLRHMEeKKURSEhpyGEB4K2fWzNUnjxxssY/w==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(14060799003)(376014)(35042699022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	amUVTN4QxEfk8faDIcK9F3MpDyJRj3J6hHkwgyjEdpPLyGrKInYzrpp+eYopULQS+IT0V+2akcWwofRBeXzIQLqKBbnb1baiGYyZH61A9KO8KbJjs9dmr1BHC2AlnXWNuaj+WK1whPPdGsA58gR9rRH5E79DfOBFbWgFTeNqIeWyaxyxQxtaPrRHvPtqXeULqczB4MpDNE9Ii2sxaj3OUdPJLFe/6yvQTO1IU4xjmbFP6Td69YHjtUXpjuI32QXh0jJwc5DsDRdQCeiA0rB3HFyiEcmMs4bALH+T7GlP34cuNlH34s0enPiG18BBOS2Y6BbAvU56gjYXZpqd+aPmZzp4HVVaFYscPkJ3W37HeN5N4ES0eUzD5bJGEwQ9PVb7obsIs6+9j5FQ9w58rik4/804pE69W6L24HikEHsmrI7qIUxuTI7Z4rA14JTcYEFa
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:01:55.1031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40ec5dd4-9c45-4b0d-d215-08de75505d0a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9955
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72041-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: ACC591AA69D
X-Rspamd-Action: no action

This change allows KVM to check for pending PPI interrupts. This has
two main components:

First of all, the effective priority mask is calculated.  This is a
combination of the priority mask in the VPEs ICC_PCR_EL1.PRIORITY and
the currently running priority as determined from the VPE's
ICH_APR_EL1. If an interrupt's priority is greater than or equal to
the effective priority mask, it can be signalled. Otherwise, it
cannot.

Secondly, any Enabled and Pending PPIs must be checked against this
compound priority mask. The reqires the PPI priorities to by synced
back to the KVM shadow state on WFI entry - this is skipped in general
operation as it isn't required and is rather expensive. If any Enabled
and Pending PPIs are of sufficient priority to be signalled, then
there are pending PPIs. Else, there are not. This ensures that a VPE
is not woken when it cannot actually process the pending interrupts.

As the PPI priorities are not synced back to the KVM shadow state on
every guest exit, they must by synced prior to checking if there are
pending interrupts for the guest. The sync itself happens in
vgic_v5_put() if, and only if, the vcpu is entering WFI as this is the
only case where it is not planned to run the vcpu thread again. If the
vcpu enters WFI, the vcpu thread will be descheduled and won't be
rescheduled again until it has a pending interrupt, which is checked
from kvm_arch_vcpu_runnable().

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 118 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |   3 +
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 122 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index a230c45db46ee..adf8548a5264c 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -132,6 +132,29 @@ int vgic_v5_finalize_ppi_state(struct kvm *kvm)
 	return 0;
 }
=20
+static u32 vgic_v5_get_effective_priority_mask(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u32 highest_ap, priority_mask;
+
+	/*
+	 * Counting the number of trailing zeros gives the current active
+	 * priority. Explicitly use the 32-bit version here as we have 32
+	 * priorities. 32 then means that there are no active priorities.
+	 */
+	highest_ap =3D cpu_if->vgic_apr ? __builtin_ctz(cpu_if->vgic_apr) : 32;
+
+	/*
+	 * An interrupt is of sufficient priority if it is equal to or
+	 * greater than the priority mask. Add 1 to the priority mask
+	 * (i.e., lower priority) to match the APR logic before taking
+	 * the min. This gives us the lowest priority that is masked.
+	 */
+	priority_mask =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, cpu_if->vgic_vmc=
r);
+
+	return min(highest_ap, priority_mask + 1);
+}
+
 /*
  * For GICv5, the PPIs are mostly directly managed by the hardware. We (th=
e
  * hypervisor) handle the pending, active, enable state save/restore, but =
don't
@@ -182,6 +205,97 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
 		irq->ops =3D &vgic_v5_ppi_irq_ops;
 }
=20
+/*
+ * Sync back the PPI priorities to the vgic_irq shadow state for any inter=
rupts
+ * exposed to the guest (skipping all others).
+ */
+static void vgic_v5_sync_ppi_priorities(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 priorityr;
+
+	/*
+	 * We have 16 PPI Priority regs, but only have a few interrupts that the
+	 * guest is allowed to use. Limit our sync of PPI priorities to those
+	 * actually exposed to the guest by first iterating over the mask of
+	 * exposed PPIs.
+	 */
+	for (int mask_reg =3D 0; mask_reg < 2; mask_reg++) {
+		u64 mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[mask_reg];
+		unsigned long bm_p =3D 0;
+		int i;
+
+		bitmap_from_arr64(&bm_p, &mask, 64);
+
+		for_each_set_bit(i, &bm_p, 64) {
+			struct vgic_irq *irq;
+			int pri_idx, pri_reg;
+			u32 intid;
+			u8 priority;
+
+			pri_reg =3D (mask_reg * 64 + i) / 8;
+			pri_idx =3D (mask_reg * 64 + i) % 8;
+
+			priorityr =3D cpu_if->vgic_ppi_priorityr[pri_reg];
+			priority =3D (priorityr >> (pri_idx * 8)) & GENMASK(4, 0);
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, mask_reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+				irq->priority =3D priority;
+
+			vgic_put_irq(vcpu->kvm, irq);
+		}
+	}
+}
+
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
+{
+	unsigned int priority_mask;
+
+	priority_mask =3D vgic_v5_get_effective_priority_mask(vcpu);
+
+	/* If the combined priority mask is 0, nothing can be signalled! */
+	if (!priority_mask)
+		return false;
+
+	for (int reg =3D 0; reg < 2; reg++) {
+		u64 mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[reg];
+		unsigned long bm_p =3D 0;
+		int i;
+
+		/* Only iterate over the PPIs exposed to the guest */
+		bitmap_from_arr64(&bm_p, &mask, 64);
+
+		for_each_set_bit(i, &bm_p, 64) {
+			bool has_pending =3D false;
+			struct vgic_irq *irq;
+			u32 intid;
+
+			intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+			intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, reg * 64 + i);
+
+			irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+			scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+				if (irq->enabled && irq_is_pending(irq) &&
+				    irq->priority <=3D priority_mask)
+					has_pending =3D true;
+			}
+
+			vgic_put_irq(vcpu->kvm, irq);
+
+			if (has_pending)
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Detect any PPIs state changes, and propagate the state with KVM's
  * shadow structures.
@@ -341,6 +455,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
 	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
=20
 	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
+
+	/* The shadow priority is only updated on entering WFI */
+	if (vcpu_get_flag(vcpu, IN_WFI))
+		vgic_v5_sync_ppi_priorities(vcpu);
 }
=20
 void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 69bfa0f81624c..cd45e5db03d4b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1171,6 +1171,9 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 	unsigned long flags;
 	struct vgic_vmcr vmcr;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		return vgic_v5_has_pending_ppi(vcpu);
+
 	if (!vcpu->kvm->arch.vgic.enabled)
 		return false;
=20
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 47b9eac06e97a..55c5f4722a0a1 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ void vgic_debug_destroy(struct kvm *kvm);
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1

