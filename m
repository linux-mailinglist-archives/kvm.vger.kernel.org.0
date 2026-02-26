Return-Path: <kvm+bounces-72022-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QA3BCvd2oGmtjwQAu9opvQ
	(envelope-from <kvm+bounces-72022-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:38:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6E21AAACB
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:38:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9AEEE3405E93
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399D542846F;
	Thu, 26 Feb 2026 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Nz9TK/b4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Nz9TK/b4"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013038.outbound.protection.outlook.com [52.101.72.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE023D3324
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121499; cv=fail; b=V7FA4OyG7+gZJ+JhTqINSpMvXQU0dTUMrkArXVAU+MQDNIyOeVj0xahhZj3wAigG8nmY+a+TGFw2K7zeUucfy6cSKfO/6BAwAUrcIsuJeFmub2sdGl+V27keMFQMCP4e/XWt7D2LQC9Muy+3mjqc1KdR2/riI6l7fI6xS4c+FzY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121499; c=relaxed/simple;
	bh=UHfqq4PDy1j1arxX0gKtKLHNuAbA21tlYIcTf0tZk3o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HFUVNz4QwT5WZXSyEN0u/rHUBa6mS/Ajt+m7vQ+KHNV0d7jzJshVIGA1SsTI5KV+e9+b2S4R6O12j1+Iw/do8N5JebHDngZA5k3kaNrmFtD43xL4DVcHZMTIUqR0YQSWYPh+wn6BsJpaWyf95MxGjUI28pfeSdWmSTH/oiq1D8E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Nz9TK/b4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Nz9TK/b4; arc=fail smtp.client-ip=52.101.72.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=MZCXZXIA7GH4JFqaLFVxmV91CQi1fOD/YASNg61p7sWj350P02ne6kD62Nt5P5YsVLKTdIsPFOTcLjFtJhRYMC9oT1A9PAeo2dOaje3eBLq1OlNXz3KOVbiJLM7z6TuHxBRNmMLdQFLUmp/tGM+XXvzCQ8cHMNDlpMLgEMbkGI69UkWCXl1/266pa/PpR7iszHTB4rKH8GIMATatN7ViPMv40zLMWeiunvcbZdj7T6Wj9s6Qilz5VfmAg/xLnB7YaDrIrBFq6IqR/Lan1m1okXAIOLANzEACGcpxF607Ny+jZ20n31M4vGFI/H78vVepRDrNNj/W6ERoiNmlGfzm7g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOgNniO5vtSwW8eTXOZvUPPQOjQ5+DW85CljVpz2plI=;
 b=CInK4qGHQ9S6BpVHA4bD/5sx3T2v+uB70d96ZpYI0F9nL+HYwZ96Gu669Ir7XmG2odQ1Imsk/FVx2GMzQ606IsH20c0YErUfRo+0odutIoXHO5wp38nM8HVx3G6lQ1uIyKBol0Z7mpM+aJRdx+aw1IBNGvHCzm1eVBL5tMn4J/2bzhbIc7zftIVhTs2kiv0h6A6n+wS6fvkW7t8tZ5SOe8CxK69jNM5TsRr/G/NjOc1RR7OBIfiXuTl7f6Ep1mK074dryR96WQUvVz69Y7oekWzLg8woHoz4JiSoUxdJi0JHXzpDU9CyaYk8s63tC+0Ml5jccyp7r5ujfR/Hy5R7OQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOgNniO5vtSwW8eTXOZvUPPQOjQ5+DW85CljVpz2plI=;
 b=Nz9TK/b4pygkG9+cPEcUIQFLb/Ik94kNgi402XitsQTTG5UTYH7k1f+3akhv5PT4uwpnjU9Q6Cktjz395A4aVmW/tJtKHqKfQ+272zbvJyb/cKnBBavCtAVHEDzlG62J/oZwE4I15lFemXPWEZMh52JN+b7cOETEh0AQWVQVUhw=
Received: from DUZPR01CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::12) by DB9PR08MB11379.eurprd08.prod.outlook.com
 (2603:10a6:10:60d::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:58:01 +0000
Received: from DB1PEPF00050A00.eurprd03.prod.outlook.com
 (2603:10a6:10:469:cafe::87) by DUZPR01CA0058.outlook.office365.com
 (2603:10a6:10:469::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:58:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF00050A00.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:58:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u+toeNXIXEK+DJx9hgsj4IzM85PzF1NW92smya6UtGis7bOb6ja8407IaPtsgubst7PZiXzw2+V86SdiVbKPgepUl5pBMX1wc/p2FUpk7j4IeSwnjkzxqKaBosAMBmtHX5XXD2Ja78+E1NKt0QYtoDIKOloEN6uicr+BMTLUTyKmWgWFU6jN2jeeyV6UOMqeCeSybefI2CUj5HBnQ47z8z8MBVTpSYznXNRvzEX2QsfV1j/bc2qgNGZgpImhN1VhaoJnYUqNXRvPKia4Lud/loR6tcXJzbEQb9lUz001G/cdUI/A1YC5pERQF+Ik6KqjujwxSpAzOXZ9S8WdQiVTvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOgNniO5vtSwW8eTXOZvUPPQOjQ5+DW85CljVpz2plI=;
 b=iSafvzjElpLyPGS92O1EFo3N0gU5N6t9LostFcNTdU5C5vKSVtH718RzkkerdEqMQF0ZeO9SNDNjJ98uf1Ue0fxIjFSIW9B9Lkieqar8rNSSuwcrbevdjwTNV47EGSIBgAu4y5DARMvF2G6jCT7rJY0jq4dAkAnSjVFUDeGo7cacWUvNvNPTynZNfj9dJzQtoXCfuBEUIgEOiBuVu7PifPFKjU7uOsoLXhZ16dqS01aVPzFFkoJwaP47jxtQ/So4FjC7PqvaNWE3A0tb39D1H+JB4e485wwAF2W8oKNsU3B7GZCm9HYypwAk5UGLxWii/VHYZJcc9JNf3D21M30TYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOgNniO5vtSwW8eTXOZvUPPQOjQ5+DW85CljVpz2plI=;
 b=Nz9TK/b4pygkG9+cPEcUIQFLb/Ik94kNgi402XitsQTTG5UTYH7k1f+3akhv5PT4uwpnjU9Q6Cktjz395A4aVmW/tJtKHqKfQ+272zbvJyb/cKnBBavCtAVHEDzlG62J/oZwE4I15lFemXPWEZMh52JN+b7cOETEh0AQWVQVUhw=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PR3PR08MB5819.eurprd08.prod.outlook.com (2603:10a6:102:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 15:56:58 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:56:58 +0000
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
Subject: [PATCH v5 06/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH v5 06/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Thread-Index: AQHcpziJi4f1hT/O7EmMolhi1nXpgw==
Date: Thu, 26 Feb 2026 15:56:58 +0000
Message-ID: <20260226155515.1164292-7-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PR3PR08MB5819:EE_|DB1PEPF00050A00:EE_|DB9PR08MB11379:EE_
X-MS-Office365-Filtering-Correlation-Id: 385c3e6e-735b-4069-02ab-08de754fd185
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 fOevAFEVHlb/4IxRz5PP1iP04oNAQIzQKg6ZHw2JJWogFHzZvYW6d3GcaP3NkpFluIITPuznkwebdAQG8wFe3NsRSBlGZW8GHI+QoUnOad9FsLP9a3bqsBR8P/6UJYwOrEpdupGsSyx8aqSLzUyGANWjqgyDT0dr6/GD/nx+0lUABP0nbmyzVjYvlzZzkFC6slYttrtQe+9IS2f72eiNFlBdC9rGG2w9qydLHd9hLnUAenSUX1rv1r1dhVNTIG6RzX2LM5GIZdsA8wRDDexsrqZ5fiaDTo37vzAEKTF5TzCEdtKIValjeXtWVwTL0mfa2X7llueZ6D5Zv7KeAMF+AwKYP4Qlgn+fpZ7AHCzI5TVwnQVXU/DiGzJHU/MYSWxzcDB38TYEYh4rPRMxkgop0sX6GrAGGsSOpxlXHjhPmxaC7GSL/Xr78D6DpFrVgZVjFfJqY0ZF348i7emU0vzsSXu5lwRjrr4wribYM+L/OEkWVzcZuhr4k6GlsJ+uFp2OfsH7HPShfp2Av+4PAX7TPr9PYS+Jmx6hgwtwBppU8ME4hsEZqFCHBrPD1bbm3asuAXE9i0DfNfg4TwfnqAKAw5Z69labHJ2LeixX117OLwkxRX2NgkBWBW1LzxJqHOR5F9L+rYETOenstaYEck0fouImFgZxqWXJooGhANkY989E6PZ4GqJuqC3AGD2TvVi19z4aubedfPxdZ05FrcwStnI02hSTxjRIij/aSmpu5xci9y22/nZS8Tns+rJ75wL/vlFn+2Z0hk/niC+fTI1r/NYsuoIgebCtKmMldlrMUpg=
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
 DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ccf9e29a-8207-48c6-fb57-08de754fac47
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	yS/93xxMWifyQ2rfDq3XDGdrl1uaJ6UPfkCU40XPozo9iHPt1IKdWymB+yTFvsyhYPbZ4dDZDscC/ANOZcMQlOn2l01ZB3ul0+D0g6N4NYs3BuFJ9PdWtvlYOKPSjUhjhEwPgD38WjN0nmMM6qvSOXkkopJ1EpYOUa/2taUwBKJRkHGVLc2xnG2gVBYmVKBWYvj61ATRLvtwQDGbGBnUxnDc2dAJ5a8vbF6fkq5X+VLXjTh/7fgnTZgwmdirXQrKeS3Urto/2JKaI8GiQkJtAZupGs4Vu/wfrcNO/+IrGhjEIIHio+tYT7VzozWrkYMKpkvhdGIMiD0FVpBYaJ9e82DwCoOq4Ms2Cxse+YIKJhvL242j85yS7ytgEGwQQvjko9EQgaJ44+uwtuKtbAQI71bt8hUjiTzU2y982vqtp6JhdaMeOdIkIWGIOzegOAqDkgnLj6jG2tCYmlDRKtZ9wVq/d3F6sUbdMzerhXYGbs5FtFHCG6ruI1posMNhyNMAABXCD3tq3eG+ifY7n+aWxzQen/iLTM/oVJyQl/WdyOhyLWq8y7x8lNO+kOL0gjEhQUa+6XKNcKJMcPyVbV+aAlxGuGqDNtVhtcoMWyxSjDm5gBZjJIfK4ChypNr5xWOfx5YgBCpHSZ4VsYaF7rU7wVRG7BmWBT+Q0FqMMrUVEx2O3JZklAj6i53uipwIujso8OHVanlcL5tN9WB57eM71jtey+7Zp8LTQfp1B8qMX+dmFM+XnFZGn8hy+sFxmUttHnZ0c2kl3+NWLapG0E3r8n9jXYszYYQxfs2JjJfwZkydJvs6vY9oBU3U/1D4MfvPhjqklmozx9yHsl/tq2QrNg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8tOLBAB4s3u+yHKzvKkVFXSffXQJn9Ry8Z5ml/++ttjj70cL2KuWgmm1mpHen0BQLIoCqCx654hnF+pmLERCSH5T3K4e01wCbTbfxwHQowKtlqv2WcwqzZGbJ42CmrPbTJ9xLt/CqkMuNBCeER+VZ/RfkHVmsf6p7H9Z19Eh/6aHmMv3jwYXFc2AYRWTRvsxVNGBzYHbrbecoaScm38xT7LaTwwvEFfq9S6TL1Y80WZAXUz5SjVr848AlKIGVzd71VU4z9Vx0MCmOaakMGysaH/68SDgJZ2qAa8w+12P5eX+GEtXFrArkvoE2WE7XiG/59LWXSDXt6s89L5PTF58yDWhq2kCwX+MLSgoKZoKt/IAfKgb71NVi3iO2hhpU32VjUQCd6KWMXJweZKjBO1hbZd7u4c6miW3xid1T9aIiPN7AdszHmZwW5+xJu6idTe7
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:58:01.0090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 385c3e6e-735b-4069-02ab-08de754fd185
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF00050A00.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11379
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72022-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7E6E21AAACB
X-Rspamd-Action: no action

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 65500f5db3799..713e4360eca00 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1220,6 +1220,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index dddb781b0507d..f7dabbf17e1a7 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

