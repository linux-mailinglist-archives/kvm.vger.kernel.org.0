Return-Path: <kvm+bounces-72040-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ECGxNv56oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72040-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:55:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 539B21AB590
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0B7C3453849
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E6647D94A;
	Thu, 26 Feb 2026 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MKUecdF2";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MKUecdF2"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012068.outbound.protection.outlook.com [52.101.66.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB56478E56
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121713; cv=fail; b=dzZhoC6dM3T/gSB9qXaQzaRMlaP9yOg1JVm8fHA0FVzXhJEaFkZTioiI560PqLS12ATb2kxM68+Q3bVGhfYBnScJo8QDfoP0E8gzxlDh+Zo5XVt8Qqp2sAGPwlc/Dn1YusBFRN8LI7F55HDMG9LfIfrJ8fXA1dDzPRClaOztAhQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121713; c=relaxed/simple;
	bh=G2KprBITAC66GU8eWUY5+tNCP6ZNT4J+WbpCBO38/1A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AKV6plB9bK5Kw86ydD5ykxh173+lYEL+BO6fpdr0oohQmPVvANAU4kBKUvDa2mr+4PF4e6C0adbrxdiZDloJsO1O3QPePXT1zlF2x2qYgUMmdpIywXkj2sWcfwCs98hjDb8ERbAXo9di4UfI89I3J2XL8MJvu+C+KIL4QctOwAI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MKUecdF2; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MKUecdF2; arc=fail smtp.client-ip=52.101.66.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GlzipxgNPmW633v1ydyEQGm74NDIzOmd8h5A8nEYuwz5CzGi/Ul/iZpJfbs4I04MOtU+lsTWL3BYI+IGo1wHk5GEVsatvw4qpnrCJTgwgB+afjtCRdK0QgyQjrviuwSzkx2AfsqBzBy9LqclWXLjKq1wmtnWRefUfUd8L+K8sq8IXweYmTobVsfHrkP2Z+D8LPM/D9NLqVTyYpKWPeqHrebCG8J3hxv6oeaVH6rpIYE5nd550vh+eQ6GRNv54vy7xOFk88tKyMqHYwqKavqHKZFCCvA8FMcvZkvlyFaAIFOSd2WkZnvuL4sTYc8EY0Z5t3KSV5N1/3z2dKlivEqh2Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2VEght2s9/nDv1gktvGWMuVk2orKeSUQQo2MAYSoNE=;
 b=J/MveHje79vdc+lr3l98YVS+NdOOF72Plhbx3ngc+yhuukNZDyKW25H3W5QqV3HSJ31PJS1uAA/ZxKBOo2kaCpg2U2nIl7bPh/Wt0Q3pQXkUz4ajWYBfl/00PKBPuvcq9CMKuJbEEkXASWQew5N27q0yE/SQitSEFU9LNJIGRDynVwMbgZTz3Ma6YqF7xqkTdBfSijgeHfA9nv+/6xdbGK4+hDXO7YEwisGKDeMJ7hma5QivK77EPCgu5GX0EpprY2zpaz2OCP/cKpmnhZcIE5GpbuQQEqHUqrdhXdSEW5kbXOdurnt61VmTnVGm2GuAAuOGSQtBufRdyjWHm4+HgA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2VEght2s9/nDv1gktvGWMuVk2orKeSUQQo2MAYSoNE=;
 b=MKUecdF29M4h3apr5Gw7pbcqpKBaz6IcRqENpTKt+GUGWzY3ZbVOspAIYmDjCnMM3lBQBkyF0ZzDGYxIfVx/UGI8ehIhHV3gvNfclqaYl49f9NnSvLwKRWZAxTL9r/OhzdAdaqMblPC6onjmajA51+gS1HmDuIjzeOwpzSdVyW4=
Received: from DU2PR04CA0238.eurprd04.prod.outlook.com (2603:10a6:10:2b1::33)
 by AS2PR08MB9941.eurprd08.prod.outlook.com (2603:10a6:20b:550::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:01:39 +0000
Received: from DB5PEPF00014B8F.eurprd02.prod.outlook.com
 (2603:10a6:10:2b1:cafe::5e) by DU2PR04CA0238.outlook.office365.com
 (2603:10a6:10:2b1::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.24 via Frontend Transport; Thu,
 26 Feb 2026 16:01:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8F.mail.protection.outlook.com (10.167.8.203) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=poNG3+Umz2I5sNNEPU3/t/K6Q36NmxK0u5kGpfpRMzM5FuXUeRpOHs3cgm9OXc7aRe5XyGDocj/Wvi47EnPr1VVyHFQiMOsmRQwCOFUsDB5a3sXiMpIzU9Et14ztdcDUOsf8gKpn1wduG9hJStd7/g+mIOLIZz+A2Uf88Vd7I2A1WjJxEQBL6pD3aD2noy0o2F8ggFPHc50jEKdGb8nJoV0kzIrwVyPG4KbTYJYQOA2CwO03DxosBt0+iYjPhV3mrfwOg4tKa5IbrF/zPrTpDO6TbB0qC56XQB1rbQ8F51Gm7uRgASgwQqAWVg2tfpmvQFphuN1UfmTtCNnk5Ad9Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2VEght2s9/nDv1gktvGWMuVk2orKeSUQQo2MAYSoNE=;
 b=pL3XzvPxKX0nTy8cCw4scDD4Irw9R67mTrvxUYBhVM3xmeg6q9a1lc6YII+DsqSL88mFv9V8TIl5aw0dvDCQjNjvAVPJsn3xgJMXHAdf9RuNHDOKPU1JGvD3n7uzydw1ae1BnGEjiHi6UtP8K6S5BkrbYB7rxWB3QSeL2MeSBaLY7oD2nLXnMHoRPA2rkFmSeGDbWlkBDSxyTS2QvkkAiEjodfQoWdQ3pb8CCXtdfGUR1IL8xXcaweT0NlplqjzDXM2NVNvgOv+IbsoImR6ZIQtP+0nYvmCFQD/uEnpWrKWDym0vdkgcRXRPiQMCY7bvcRjcYoRsXmlJMM8qhuJ1yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2VEght2s9/nDv1gktvGWMuVk2orKeSUQQo2MAYSoNE=;
 b=MKUecdF29M4h3apr5Gw7pbcqpKBaz6IcRqENpTKt+GUGWzY3ZbVOspAIYmDjCnMM3lBQBkyF0ZzDGYxIfVx/UGI8ehIhHV3gvNfclqaYl49f9NnSvLwKRWZAxTL9r/OhzdAdaqMblPC6onjmajA51+gS1HmDuIjzeOwpzSdVyW4=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:00:36 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:00:36 +0000
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
Subject: [PATCH v5 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v5 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHcpzkLrBJdTlPmXE+QPnFKILOl9g==
Date: Thu, 26 Feb 2026 16:00:36 +0000
Message-ID: <20260226155515.1164292-21-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|DB5PEPF00014B8F:EE_|AS2PR08MB9941:EE_
X-MS-Office365-Filtering-Correlation-Id: 9567d236-f198-4941-d231-08de755053b5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 ka893qzl6NV90DiTvRRDLZg24FpqZHCFxdoEGCw3p4qJo/OCnsV418gYpXiLPRf44jlkzBOHCxC0FnPFIAOxKTZo1cwONF3k76LpNoizwm1IewSpQN8n7sn9g7h8LhWCdlBKzlIdxghy2vXWNmZ6FMfXr42jjIxW2pPmVMIpRTAF00v6P5zaJaY0R1NrtixA4qrZE41Cd5obElyn14Ys1qlxJKcK7c6SjqmZfysrTRFA1c/wikyyZyse6l2HCjPV+d8075AYDx110/k4VW6KeAXEdJeYevMKowWfCJcWkLJQg6ci/9q/IiFq5rhYmOKgATThhKQ8KltmHhUcJnPSxyv1CL7/hIS8XyBO6lBvXs5fXsLDtT/l0xFjGOBsvcE7Dzb9z0Wr9qD0gX8jSuuKiIqlU+RI5OC9xIW4CjJ8t45y4qrF+lrqtgZM2hd7nFK4W+Lu3LWILUbr5F/4GlL/45GxTUdYk+eanvSBzT8MuyspdNC2hvHmK2Herm4KF8kXZJZqyjehEsAU+5pQg22XulBxOnt5cqmym4YCfJc+wAFUQrnaW9JGVXj9VGiC0N0Vu0K8AUFRXNA3WE/s8ezFoEgA9xB+47t/ZO56td+9w0Sw+NYBi/4DqYme9qSiMYCXBAywimuvH/8YETvWlXFX6Cx2ncmiHtGmZTvX+XO7MGGNSO6N0qnkKqJCjm3eXOKkSReB1UieGb9P1IrxmiMPawuwlqa0a/UVeCiIITQYaByIABZWTKqK4szwbjwKe1xTQLugTUm65Q0mb3P1eRvirIEmIJPDPCKbBm06DZ8gmto=
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
 DB5PEPF00014B8F.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b1d6e51f-9c1d-4b8d-bd8b-08de75502e3c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	rV0RSIcOj+Ms1GQde04xxOF1e5XiJ+MElkPvF3ML2Xo3whHePKcTxKdTCzvYwc6bB6p3I/jEZdThglttKK/3szoohAp3VUqX1dBhTywrFegXdnz4FO6fH8Kfb6uJ7+oo2TYw/qIPFMMK3M5rte6etAk4Fyh+uow/DP7OMcE42D5ZrSoOjOxm3RGESMbADKq0L2PbRt9WHPvZ6GRQSgr28+/V+nD9QHwUr+MqAlK01DNx/38VB2xRuh9s2YZ9Z143HMloe2EJBdp2F9xyAb32lnkSW77nj2VMOwi0cU6aupzXQh0Su2XbaYJbDQkHZTo1TasVcmFMY6F6+H0SJGr1KENCFGeZRXnpqt+zXgf5jS3GvDwRJ9z/Xiu6J901BiCPZSYUyE+YS+XLBunFD9k+AZApbuzq7f+mVJYhh/p1TpnUz9KPYoDPm7+FaVCGmtV7FNjtk4SdCJdK1h1sjSe0Wl9RVrlSRZSqu+i7c5I6kl11R0ZkFoq+fjLxA9WYrvVOiaDayOIghhoy0HhKa/nXoMMNg0j05UqlOBtmvqwsA0UFslavK9bYeUXBI3Nove6Jf035c+X8FuV2S7XPCvYaGPPlcUUmBzE57irldssQnmgakoTYp/kznVoOhjhdKAQxS4jQ30K4SpqG+VFWWr1pQ3g7ft0Wt3g7mNDih9Gm4uOg2ttQeVjwyoCVgEQdlSPy+b/7YBVsMhUdmNicg7pCjJyogPpK+jwD7YznotISHwGpmd3CSqb0IUf+8MQaS7GpVcYd8o757xNDnnurvvkvd3mDJ8Z8j5cQZv9WUvvHZ9DYrLOerRSf1WZajZ749zmnSvo90hq3hHdYWyzyo3rcdA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	wi9hyQX4xXpxP7+iAvcC7IiTwysCOMga0qdy8mcOlgPWwOdF5CLbahAPWDaT8CIvCNTUwF1Xlmt8gi6971a8VunkoU4XAqoes4Iye6K4nOH4llfmJXGiQlOqk9mQDBqdSvwXk/qsuxI9Lq8q6jVpq15tdqtEdp1UTqvOLHlSroHL8tveNLolCHzePclTB0/1uVvegS8md6MZx5zp7ux2gKys9rCRmNWpSpdWHWOVXByvnLzsvMucPiDc84aQSDY+lTxzir8FMm6/7BcLfiRs892ql/GCGpr9ClOCbelqg7pDsJLVVoiXxxzZ91L3QgBtot3BBabwNpbBUYQwuqkPzyhwrjnyummtNmjBOGSL57/9jJP6DVumtUtLfV5L5JPPfcSfNnEMcgJ//E2lew/iWVrFV1pPTIWIUY+yjPvyZIXsHS3qLsBW+i0e4Btr4EAl
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:01:39.4408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9567d236-f198-4941-d231-08de755053b5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8F.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9941
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
	TAGGED_FROM(0.00)[bounces-72040-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,arm.com:mid,arm.com:dkim,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 539B21AB590
X-Rspamd-Action: no action

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 39 +++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index d1db384698238..e4a230c3857ff 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -254,14 +254,20 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
 	int i;
+	u32 num_private_irqs;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
=20
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
+
 	vgic_cpu->private_irqs =3D kzalloc_objs(struct vgic_irq,
-					      VGIC_NR_PRIVATE_IRQS,
+					      num_private_irqs,
 					      GFP_KERNEL_ACCOUNT);
=20
 	if (!vgic_cpu->private_irqs)
@@ -271,22 +277,37 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+	for (i =3D 0; i < num_private_irqs; i++) {
 		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
=20
 		INIT_LIST_HEAD(&irq->ap_list);
 		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
 		irq->vcpu =3D NULL;
 		irq->target_vcpu =3D vcpu;
 		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
+		if (!vgic_is_v5(vcpu->kvm)) {
+			irq->intid =3D i;
+			if (vgic_irq_is_sgi(i)) {
+				/* SGIs */
+				irq->enabled =3D 1;
+				irq->config =3D VGIC_CONFIG_EDGE;
+			} else {
+				/* PPIs */
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			}
 		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
+			irq->intid =3D FIELD_PREP(GICV5_HWIRQ_ID, i) |
+				     FIELD_PREP(GICV5_HWIRQ_TYPE,
+						GICV5_HWIRQ_TYPE_PPI);
+
+			/* The only Edge architected PPI is the SW_PPI */
+			if (i =3D=3D GICV5_ARCH_PPI_SW_PPI)
+				irq->config =3D VGIC_CONFIG_EDGE;
+			else
+				irq->config =3D VGIC_CONFIG_LEVEL;
+
+			/* Register the GICv5-specific PPI ops */
+			vgic_v5_set_ppi_ops(irq);
 		}
=20
 		switch (type) {
--=20
2.34.1

