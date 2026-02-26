Return-Path: <kvm+bounces-72051-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eBcfC/h4oGmzkAQAu9opvQ
	(envelope-from <kvm+bounces-72051-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:46:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A45641AB031
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D362D32215BC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DA214963BF;
	Thu, 26 Feb 2026 16:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aa/3dm3s";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aa/3dm3s"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010035.outbound.protection.outlook.com [52.101.69.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F83494A1F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.35
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121886; cv=fail; b=s6+JcDjf0BefqmMEEj9lahcope5ApmlTwT3+fNPONOFJ/sfBxd0rEb1mfZtWg63R9ZLdkfIlnfuZatcU1pYc/UkOoSjpk1ChaufharARElhheEUlrzlUfk2j3gD3DW9p8uRmmP6N7kTMV/g4RYxXGZsBt53s3hyuKdZy0biB4JA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121886; c=relaxed/simple;
	bh=ETz9emsfBVfXnRBcxNTO1j6W4mII5tgpoyFRRjnGH9Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MKb3++oaQrp1j/LTKXTmnGw/LL78rHc97r6GpBY3wOj1FO3TRzpkmaGB7NoHXy7Q7HaF25vUerUvRZMyjn+SORUvTcgbwXwiY6QMgeh7zzHZpC2S6Zp9yUGYlrgq4O9ZIjOGKXSIr98tE24zkQ31U9xV4b62Qw8mxGzK+lN1drw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aa/3dm3s; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aa/3dm3s; arc=fail smtp.client-ip=52.101.69.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kcRycVI1syMgNvm2BTS+Yft5jMjVmcb67e/Bijs7QL/exT1Jcpus+QDZ4xJn1/x1jX6DLCTNlRhS6J/NIud21zDIDF4+Ub/VwKphiHYZ5XjNTKxaCDHTqe/onQUA+JtyFGxlRH3uE3/Ogdk5nx4WoX0J23iO6sm5KaJzyxSp7VROw8VMoa6ec/1NVDUvsHIen+Um34omb3Y2u53gz5+jN9BncFR2LY+AoWIrURWSkSVZlRqRfZhqDOh8KGVz2qBaftHKhOLKmSMsmwSdvrxCtW8QjdwWvfgrV1OIW1wpLH0tus06vyoB0sFSm8L2tDfFL2Ape2LVWqMc0Ey6DbY81g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=NKsGv1bbcc3DL92maKNt+u4GCGnhd3u4Pm3uSmTy4QiNVufq5NMt+7/7xKLI03Ep4c5k1XPVSBQBZcsamrY3l8Ui0dQHtryGBg+aTUVFN2aeTE74JtS4GcqMtyYEm1hettm/2nGkdZszA92xN/j5oScLDmApgOQD26p5YSV/kby9qM7/j2XrrP9QGkxtMR7U5Bu8I5jcCLDVpItKOBXWvfXXW0F/R/Wenh6GDQVlfQfzMsNXEngAxvHJbojouQ2LyBQdCKUaIYuj99TrkqhiN/kj9H9NzpGQrZMsoHuAdq9m1to0UNQ3lK/LpQTUStLmwwIpYbD8DGrF8ReIt0yKdg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=aa/3dm3sfAn0uug1lkTQZz4t2j6GxLLZ7gfyH7H+XSENdaS9d/OYY2I7e0IY4LdM73Br8PUr+lLGgy8o1NtLXbqL+AwVvbcXOD4iS/z3mSiqWM5kS89Ocv7QZV8OofLH+H1CJXPgG9K0AHYaxjxwNCRXpd8QwJaD4/1f1zJtDIM=
Received: from AS4P189CA0027.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::16)
 by VE1PR08MB5725.eurprd08.prod.outlook.com (2603:10a6:800:1b0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:04:32 +0000
Received: from AMS0EPF000001A1.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::10) by AS4P189CA0027.outlook.office365.com
 (2603:10a6:20b:5db::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:04:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001A1.mail.protection.outlook.com (10.167.16.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:04:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XlmFMnaHaN8FKlEmiSo8Kj1VRMlzovK9URMT4728qErI+G9sRqGLp50hHNKbgMYGTaKRbU1PDfoLg8KS5CO/dx7Dz15qkoDlne9aHaQCq44hBS1zuO18G7ZmBRwvQ4jVlEkCthr6pZDMMgzWrCCJ2NtJUCgrYEzPgNfR6D69MUmDn4YS8/t6Me3jWIVI1XJtb9e3xm3zGUs1ubvsaeb+8Ftnfyga9+ufMeYh9BYZdpsZT8MIv9OC4m9ZFoxnmKlf85nI3IRNH7yoEn9auRj/p+Of/dxBso4+esscGEPQqEryVInxFIK/nPmH064vBv98H94GRLXwWXTA7+Z2XrTS7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=jVUjv76sNCX34UbFXgBRSGeIYRnw22pO76YQb3wBpt/asqUJvu7LckrWGKEMV2a9pzT+wPMnegBjjDQqHe8U/S4Wer6DQcu/JoV2xH7D9QIc8JHlXTklhrOJSzFeuouslIy4B/b0P2IHAEFWtR3NRE4NzZhDtiQFqsOIzdM4P+G3ClRROC26EzJbjHdLXkqqpVuBxB3DZYLnuqvaXbFryCo4u1+KtLipDulPc4BUyEA7JR19VDpOzMzp0trq0oPPl/72oj2eFBP8vc/wn/rnO9J2L8hEOJy2LwbKlG/O/SLHnXZF1UECBrUlIJn8XhBpMu1xKLIdYJPym1c+JY4J0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vgCkTG8eZDabbYo+b/p6DgRLZTdFmhd6KADxzqC1HA=;
 b=aa/3dm3sfAn0uug1lkTQZz4t2j6GxLLZ7gfyH7H+XSENdaS9d/OYY2I7e0IY4LdM73Br8PUr+lLGgy8o1NtLXbqL+AwVvbcXOD4iS/z3mSiqWM5kS89Ocv7QZV8OofLH+H1CJXPgG9K0AHYaxjxwNCRXpd8QwJaD4/1f1zJtDIM=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PA4PR08MB5950.eurprd08.prod.outlook.com (2603:10a6:102:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:03:29 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:03:29 +0000
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
Subject: [PATCH v5 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH v5 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on
 boot
Thread-Index: AQHcpzlyb7nMyIrC0Ei44tqNzaPZjA==
Date: Thu, 26 Feb 2026 16:03:29 +0000
Message-ID: <20260226155515.1164292-32-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PA4PR08MB5950:EE_|AMS0EPF000001A1:EE_|VE1PR08MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: 00cf5798-bf16-4eb0-d825-08de7550ba7b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 L5d2xAZMJbXWqPctQlddHKjfR4w9zBdjetCkTCJqpmTKDGbL5rRKIM6TiDo98s33yZXhgVTGpjnKxzw11fc/IjHJussOk3HSA6Y3f4FbdpdRhjSXzUJU6XCCCS+TqHvJuBoD3oO9VIZZfHq2zzCo3yC9RqAP+gbGGZC/kCN2rgSI26R3JMUZO5nszsqfDeU1OAA+aXCrfwPAvgFANsP3jNgXldfM6ZO+BYehrWaU+EJYa3YSE0XOX7m+chfR1oKSBjPKQTWg5shEBgl50296PoTTWpPwaGoKIwVQhynyAP9dtChNh2HeoxNldhh9+ddoe4VNp06e9PcLuBEKc8v8C1O4J3KNUdukX6pwYS9H3iQqCZaBwBOVaBMWjkqxTk/ZlM+BKQsjVP72r6LDhyEcxlEx2MTgAhz2B0jqBUKZ0XlOyrprgnA8jfUGJWFECCi2pVDHEBhrDqRK5RYiDSr7ODFZjJWGQTR+a3Rq2jk7t2Yv0IetCt2mnBU6gSK0cG7dIXQe/6ktcuHqgED+XStCEypianJC3+1AF2ZOt6ZnInlixmBv+Ls2esw8556Sq1bkcuX9oDf7nOGynXRYnOzyThLJ763NJZidvW7o10pidwEQgiObqOrQiFgmemSD+CyHyvLlkt5qpfTVgpxtXf1Omsd/Nxjulb6RLlLEmi3ekOwQ3Qol8e7rFEDnnpUYfvjLo8l44zYKtltuq3p0Xco6gOHBGNAMHeBKFu9iyybXMKdBkqf8PHstvdPvHlWgktI6nDVpQ3VJSZMVHayVdwmeHg+NxnvKJLjVpaJK9MExhVI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5950
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001A1.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c573d8f6-1588-4781-3fe7-08de7550953b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	1OFto29ttqq9v8r+kabcO7nAa1Cuo6+H9ijx6mDXY4ugHMSr+Own5jBElILVx4e0vMPRCqE3JxGo0pfaXJv6znaDbpy4BWCVVkHm0vkSo5L1IYNTW0m/OvJ44Rl2COUcFTJj9k5vXUP1mwwRc+8K4q3fBGRn45q0PsYz0Re+pj9l75Df1gzpVeZE6HSLjASzXodDuWqSw/6DqI3XSekls8781TVK5Fu9pFMX+ZEDmUMBzGypowU9XeJ5+9unFDXEYj10ClZDOvCKlQwQsR9fVnuRanMPDsZAsFFyCCgMsptFmJRsO0+WS4WQLwP/07CDGoMQbhRyQKCEuXxnEosKXx6WQhndk3lzyv6ol+WoggR0sOVAqhV+bITn0fBPxPd6/rGdpZ/8wIF4Hq1B33d5+zL+WadPpunRcrPoZeSuuoUS9j0sNnNv+UIc18zB4gtru4ybEsGF4FFU+6dp9pQsm5LX8afB+9RrSJY2JRxdY+0JKzOqj9J1buSRxB6QnZbZItln+1iVsREzJpsG1eO37WMuDCBHS3WB3OZdmNkHPhxnyH8huSl9RZBTbpVyLtsRuBJ57uYOwrZN35SHSfRq6g8Ge0hWtH2vYuSCsFqPCFjeOqRYKY9lr5xCmk5hD+B0PqXlombhALYCT+rfDTU9ID1AdzPrm6lwjnxkZmHRcxhVuIZPJVywuTRhUeq+Zw7fyqKiB8gd21cZB8fGWc/5Yg5y8SPlX0zp2rwCwpy8LHPq/nHB1sOLgvFNhmbKwIEFBlcuFqEcCeoQlSk3Mhto0x1r42btOpjX0Y1ZrqTHsQSO8M9ySMsfHqPnBnM5I+0gN8Pcq+ck3gv/OyaTC6UNPA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kH6lnftmmR33LaY6OETM+vRTqr2YEvLalIETsoTv0NIUaSwufsxq2JPBlVReoSlk/VdkC5kw3RH/SiEP3ADuHS27UGM/+Xj+15V5TGSY+Aajh5eFetTQsKqKVqSYWzOpbR+4hV58wd/JOzvV0N+mvuvSrJj/z9kXm0QJwwxMTtcP36pOci+Q85PY6rVE+7VQ1pNk2zi/0JXu+wnpIFrjjTEVDOhUa4i72/rkIIIc+erIHiCU7nq++TLhJw/QKT52i4jYr0DI3xi5ZjmtaN3dPHMjpdoU+qEYE/O30Q0f88FJpCFVwXDgykX3POKaIcmOrkfkfYzqpLyE96cbWB+bjwfuM5f2bzn8q/dWDmar5YtNV/6Vce8cqHCGpf4fKkcZfbHsdJLdEE5V7Ec8V4do0SkUuAOQzpIbGBqZjp2zp/lczRzBGXgcQHW8pfuU14ct
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:04:31.8667
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 00cf5798-bf16-4eb0-d825-08de7550ba7b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001A1.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5725
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72051-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: A45641AB031
X-Rspamd-Action: no action

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 85f4c1615472d..998b2a3f615a7 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -248,6 +248,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1

