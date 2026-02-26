Return-Path: <kvm+bounces-72025-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8Fx9JrdyoGlZjwQAu9opvQ
	(envelope-from <kvm+bounces-72025-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:20:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F0F1AA090
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 371B9308C563
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3262428831;
	Thu, 26 Feb 2026 15:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k643k2uS";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="k643k2uS"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011019.outbound.protection.outlook.com [52.101.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D4444B683
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.19
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121530; cv=fail; b=TXxgdzyOMvSK6Mm46utH1qdnvW1EcOqtEAI9fsMt5idihA5svXwOgBK2+yXWFRmoHWiDffOJAGnHFdDZaKuAN+T17+mWjlK7JafxfjtQ0d3l6f/x7y+7C3iL0PYX284m60cCRDfkaYyF8ivSuORdnJPkYPCAJgF3NqW/oA3AJKM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121530; c=relaxed/simple;
	bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pd9tT1SPiRp9AN73dngJD3Y77A1XJt1hKIn9Z+fPPuOZNwfTvx0kRXqcuJKwNOGL0u6zj+AZcrhki+UiC7n/YKsKAttnlFfZIhirI9ur9+KHfhxug68WN9SQMq5zSGbc8t/KO8sDY/WHOs2Wl3vuBKJsQgxKnL/ONG15+silS/w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k643k2uS; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=k643k2uS; arc=fail smtp.client-ip=52.101.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sn2fxW1CvsKw7HSQGaxxy9IfBB+0Pmg9bxmffnzTIQ0mhZxZwKMiL8HvkX5l60RjxjswB5FRamJwrhhaxaqSOcvqOSG4Vp3xZYY5L4+iRdGe/4yjRnxiQmp2vJ3Ik6CBk/CQNz1cgQNjT2yEyXbKtVYqPFVNnY0eNQSY3p+ruAVnRMQUfAtcT7mRd+9/jBjraU+DIQfXrHYDa1Iq9trbp9WHHJArwVMtFINlDN2ZXX1rjXLtyFuCRF6+AL3OwX+8s8dni4Q9+wQyGb/STkEO1PI/L9UdHWKCIk1AHAiwUKIwJVvQbpAgSRnjZjqEnkAFQcKQJl/koVXOF5h6/kOmBA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=aaJUH/zzDmXSgEwWSbqRHebFMkId6iz67GzeA/xi7KbBbrRJlMewnzvtrd67FZOiJ+k0gUtxOjNJqqVYuVuEsWZB/Up9+HmJQWeslsljuFoMf6aaQMfGQCyPzqQcDyG9+F1ovdxR4SniuGpKDEcBJ4mNQTn1pRRU6sRfrBToTocG9FZu8jfMcxDnbkjjArqwe2Q/yBWm8nQol9eBGda6EJXgQZklP3TPcoTYvWG2UW5EjzmYThW57Ijs2iOWDRWTIDlu+5+XqGM93GunEOPvGRcpoGQelv48apPZbBET5RIEYqMgN+ZP34sRlCc58Opgx5wFevxRJmzFVb2ySfS0nQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=k643k2uShsK0cnE09gFxE9gMAclRfdOScX1qZLXdfidFxxKpxkztDRrjxEpvseRj1HDIfIstJyspVH1X1KiSa6+9NG3dF0fY2w2YAu8W61WYCGD4XN3g8QgkRGmlWpL8G9ddLyNhcQcINNf+UT+M2Aur9CCBskwfM0JIzQ1f+w8=
Received: from AS4P192CA0027.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:5e1::17)
 by DU2PR08MB7328.eurprd08.prod.outlook.com (2603:10a6:10:2e7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:58:32 +0000
Received: from AMS1EPF00000094.eurprd05.prod.outlook.com
 (2603:10a6:20b:5e1:cafe::94) by AS4P192CA0027.outlook.office365.com
 (2603:10a6:20b:5e1::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:58:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000094.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:58:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OCqA35A9+Omtj6J53cOw9CJ2mDLOOyY4R8buaT1tULjy1RTa3Xp2fiYyKwvqAid+7KpqUx5/y1nuNqUfXk3h16QrEtP8BhJanH2OWzt13q8qI3TqT48yTbL8370OUrbGY6etzmlbYVqtMWX8PPlnmpUSpJ7Z+4b1pYBr1L50t0bpjrmoAxWSkkThZCyMGhDMmfpLpxixMz23IxprdjK1G7pOmT/zVYBaCjlOmInoOrn/HWsV+39moVv30HaJ6zaGmgybq2jARjwLjK9qZuQgTApn2sOEJYFNDwxwkrYQMux+oNbQ8eG02wziF8ma4+W8KC6+xRz0xgc//Awq2nsvQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=Cwlge2CpLSByx//C928cxAOIOOJRYj5551HiIW6jGE7Zreox208g1f/TNoGlMtMo0gGTP9X8TTyOz5cUXOv8UgvRmUgswNPdoqY+KQ8gn2Erh5WH4JCGkDa6kmy6iTa0FZmdeRys1s/5AN4BbxvzexK6xEugLH072ILSEhiou9iAukf1U9KoBIsUwdI4HHFnTYe0LW7XfSQpE3mL+pPrMcMe2lc9NLT0U9IIiJusJBGGf6zvRN2z+3zSM3nmG/q5mTKxfpM4YmkMYr4auS8RwmW5DOBgIzmIL4qGbKz2Uh86spPBQtYXV+kS61auzeJFCaMZbhJJJ9kARTX2Mrh71A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+zmQ/A7nIMx7lQmUAVOGVaENY5FcsJgWie0+wHSzlA=;
 b=k643k2uShsK0cnE09gFxE9gMAclRfdOScX1qZLXdfidFxxKpxkztDRrjxEpvseRj1HDIfIstJyspVH1X1KiSa6+9NG3dF0fY2w2YAu8W61WYCGD4XN3g8QgkRGmlWpL8G9ddLyNhcQcINNf+UT+M2Aur9CCBskwfM0JIzQ1f+w8=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PR3PR08MB5819.eurprd08.prod.outlook.com (2603:10a6:102:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 15:57:29 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:57:29 +0000
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
Subject: [PATCH v5 08/36] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Topic: [PATCH v5 08/36] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Index: AQHcpzic+wCtL/DSV0+bcxKYY+17/A==
Date: Thu, 26 Feb 2026 15:57:29 +0000
Message-ID: <20260226155515.1164292-9-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PR3PR08MB5819:EE_|AMS1EPF00000094:EE_|DU2PR08MB7328:EE_
X-MS-Office365-Filtering-Correlation-Id: f8e4c1cd-84c8-4fb6-20cb-08de754fe3e7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 xAtnInl158jbx0N1mbK+JHqOsAuCdK+vfavn46tms1nlSpzNCz8W+0hlVyfClrWjbZtbfMjWLm28/IsktiousCc+RJn9/V0BCTnb0fMBE8wHTl/7WU7O6JDBNjGDCw7fxd3/bbgE8COhQHnXbb/otCK8X/0zwz+rR0ImuXFgSXqqip8GbUI/Rr7fzhMKN1Zi8RFwQYpf3kOTozcSFiulgLyUnNradilCHalydnypplfe/5D/ZU8ZuYK1Ui6eU+vpSa3jybADoBMHi6h3kd6hcWpDNaNxYwYSj3fXYp0eBM+GkW4ZDdXkxoFzkhnD40NT+1kQpSv1Q5mDv9Biz46MQTdORWXQqB8oLdFDYS3HULuV0qS0HHZCIvVUfid5+zfW4wGtZuwErh7YVApmIn5dOksGscv+rOq/Y5+k+JhPtFPf5PX65srDYU+KbRh4j4GR+3CwljmGvqeI6cU2B3AFhgFPmfzN5q0nubFnDOcKoOYMkeXtfksi64e70OIbBqkTnQexUIhbS10wUi2LpAKDpCx4c/AtYHREnTeAWeN5JSLVm9nIS7d89l3FIjVY/wu0n1gZglgYhmVF0ny3AIMfR3vQnEBHXIY9K+N9eat274ZWMIlyOSjg1GX4LBFlf2tWFCRMSzyQeyHRoYLdb6Oq7z56wPlKONRmNbhov1DFrS4WdxR4R4AqhXtps81NLZ364+jNFJPXduE0hwMyM2yKEF6cz75hiuXrIE1RV3B5DfeC2nLQhbtYozOpqyeSqhynSAFVvLiWb3eGeRKavGCz1jAOhPrTnZQxTnFKNsjta48=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5819
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	26573da6-12dd-4210-10bb-08de754fbeb9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|35042699022|82310400026|1800799024|14060799003;
X-Microsoft-Antispam-Message-Info:
	Ho/Ha9OqOet0Ifp2GaompG8Q9w4M0QzzpB0PnUbGJUFF3r2dE1o93AzetMB2uzgTlGe0zedOM/wwujpJz8ySq3GEmKDe9ge79NdKjKwH7T5nmWdMgG2BAvNQGewiCo+qnJ5A0eeufiLBD6G1eSyH8amDV+TgI9C2nwcd6uz79F2f8oSE4vk3Fh9KfdOp96YpZnVFmP20f4BLIlRTVE1oERai/ff0/udkoWcaxcOMd1MDj3x93528UdO5/QJcRfs4/xG6gIbip7b9yZvFGxyfyNY8rkYoYIJSQRd5vyKIWLAz1Xy0HqmMU3sxFc3uRPAJ/NhEEUF6IGDFlI93E/zACSBWjLqeCdgV3GJ4KnYJU6RPQCy6gX5l12+Q78dMQII5vtIYXTCeGHW2cCBcuKC7ElTqzptB0q6prUCrzLMmqzo73yE69lUnlfGhJ7wCus8USaDAqtMVLUJNq8lRB4CZaX0m2So/ysDoUleYvqmKHupfy55nJPb/bDE792YzIryG7iHRKpx8ZIxAV2IfALz9+dX/ScstmPr9AyoKBGD9CK63CLxAyn+5Dd8RKcCeOGuTa4+WolIZK+IFtcf6mF6SoS27K9cJBcHRRaYev2EILPGioTEbjduz4CYZ3e1NqgV92sWiqDDuonFIXwVYFsiiquHLdRLVUxIlTPsuXyzmnKfwsr3iEvr2NSi0BRT4QO0ffaTbKFKCx8Zg6WZfefYRyMT7pP8G3bE+BApRxhnVZlAa1icsG7UsO7EbzShSdmETxzVjNwHnuXeuv3sMLCm6ZHUFOvabLAo6jR/5xXhszIK1zMfLM0VAnX6NOx5SJou+9hH83hV+FzQn0nre7ZS3qQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(35042699022)(82310400026)(1800799024)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Aesz14wp7fcp+isAEJr9fihS3kRfsP+5W/+jZSNnP8lTdVTCTimgMC41I0cL0D/7H0drNRoAAjX0uKElcEbARPHr5q0hA/Kq5LMk+Vb166RM0acqUD5FDr3bt5lR18YPNH/znFh/AcMKDf3b2JM5YV5QMSz/ztH4ZslN+47PY0tFluFJnaw2DBQIHHd7r6Q6L2FdRf4Of/M7kAAbUOTrOjLNnzpyLx93EiQcRMmHep6CUNxo2ezn+F5Alzwrex3Y+Egzsny+vwy/HoZuxfsV+I58hQPChbarBJBgkl/9dgyC/t5Fq+AirC8eezKKr9XxJukndu5fMkMHiH0a8w6Yam0cHwaRrJkkQgLkoXahANJ2u1TYFu7N8mwva/aB6UTzWS6/iuL7MNI5k5QiXLSh7nh7T5933jjBBlsNucyV4WFJ/uJBhAbehYwMvlpiRB7/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:58:31.8733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8e4c1cd-84c8-4fb6-20cb-08de754fe3e7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000094.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR08MB7328
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
	TAGGED_FROM(0.00)[bounces-72025-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 65F0F1AA090
X-Rspamd-Action: no action

This header was mistakenly omitted during the creation of this
file. Add it now. Better late than never.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 331651087e2c7..9d9aa5774e634 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
=20
 #include <kvm/arm_vgic.h>
 #include <linux/irqchip/arm-vgic-info.h>
--=20
2.34.1

