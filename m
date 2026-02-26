Return-Path: <kvm+bounces-72033-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6AUbM7h6oGkakQQAu9opvQ
	(envelope-from <kvm+bounces-72033-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:54:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FEC1AB4CE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:54:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84B2B34321CE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:15:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95AF466B67;
	Thu, 26 Feb 2026 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PutdMMdR";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PutdMMdR"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011022.outbound.protection.outlook.com [52.101.65.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D74C4418E0
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.22
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121629; cv=fail; b=EvlT7hBrTc15uuMgiWWQ6aSuozin4d3X59cSKfkZcpEqBw4lpKlKPKLyoIhuBuap4v8nX1NZBk33DXuW1oyteRvYCweQ+jiHtycw6GaNKi99pqLXK9zEdLqXDTTjmnJ2eA6CWu3CBIEcPaCJqnCXuyz/cH+irHZMUbP7CRcaEIE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121629; c=relaxed/simple;
	bh=d99CCICQCTVK6dhKqz305KPateWFlZ4b2P3Ld9D41Jg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fxmf1O2aq+dtJSCRnx1bedZ4vOaMXRd2hIye/m0t0z8ZhArirD9GWvnQ6c5DdQToHawqgJZiWdg5yhchX7o808dQPwFYCgRpgGMkdyGM7IP58AaKwbP/3DNoB5ma3Jy8OCLZjDFHVZ59gVDiiziD5fpJ61IoHLUd6gBKSgmmmxk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PutdMMdR; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PutdMMdR; arc=fail smtp.client-ip=52.101.65.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=OhItdrcetuLimMQdPQcJb9ne6gWtG1Z1fGRu21Zg6VcqGMJjL6JNMnM0KaEWDE8UaZFn45N/PXyvjvwCX1a2dbRhwRGgQ26Wd4ibaxblHoShtd9aRnK2VU93M/Qgk9qEXPTYXrRqS2gIrCHaDZ0MmkrYC0Y+wb2NADZDbYy9/UmsIVN0bsg+cqx3S7A5yn+pRvR980F05VJuQPC8faggtS8/4vO+HpKupbRC2xc2HfFIWc2WvXYob+DroGrEalj29W+9XuFvCSffFNSyE9bErJOFBreMdKMIB6nIw1dGtHheis2BVOqxpvBrPU8OiwhXuTcdMBQFD6g97KY1ybOi5w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WllajhSIXaOylbE0q0GTPvILmJlhw3r5pd5BrzMBn6g=;
 b=JyPpBzAphB1rc3PX2s1eRcGLqdSOYdB+aYmkG4pfaQpbm8Ovto5f2n5kCMYvxmuwaMzy5KhI6fL6zr9yV1Y/e3iRZ+7jXXmO0jGljRBKVGCfzCZSg2lwynPz8tl8zykHV51M78lE3BsZU18FkhaMRsz+LI8QrahKa7upOP7R4b6qmF5hfKoFhfXDPY2Ei5t790bbHJRTU0elUqPvw33nq0pA3WjZkofppblcR01oLTyR8yhq7PoOr59yjW/ZLufoP6OvV2JaJI6uhQYC9/EyBsH4PPDetsS8LpWbVrFGgB0Ku334If+1pVvmEMpFqCO9JNkLkeC4HDo625ZjE1a12g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WllajhSIXaOylbE0q0GTPvILmJlhw3r5pd5BrzMBn6g=;
 b=PutdMMdReTeq1GngAxbVaZdRP3uy8/pthsWC8qvHwqGK292slc1xG9iGjTyKkm710ELcG/a5UTmpLzhn8BFxko4AhtPtXiFiuwM2Jp4ODa0SufnBLkHuitJyjEnasDgoFfyNetlRMC/QF9OZLc/hyvpy79RGFtrHSBiSP+h0KfU=
Received: from DUZPR01CA0293.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b7::7) by DU0PR08MB7389.eurprd08.prod.outlook.com
 (2603:10a6:10:32d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.23; Thu, 26 Feb
 2026 16:00:05 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:4b7:cafe::e5) by DUZPR01CA0293.outlook.office365.com
 (2603:10a6:10:4b7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:00:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12 via
 Frontend Transport; Thu, 26 Feb 2026 16:00:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzSIdV8IYCpEi39EvDpE6lH6p3huzyAvUpUa74eI40F01QEIEQG7K73+IanPHVUtG54bJNtU1AoWiKEpyuPIPm1An2Cc2PS4v9gxaVFkJe4cKq7afn2kyWKQ5OuFD65ItU0kqN4OMe/pidPYzZgmEMTATC72dN61MJU6WuPGsLP2NGBAkMEN+s+QnkY1yxMdSy8v7j6FdkK6Epm0bqtcacasjxvsdPEykVut/UL5Cq/qF2AfQ9NOEgmTTQU9LsJxlQL47i7ZKYOMFXkphPx5pcZbK42ViXygAsJJI85R7qoMdVUW/CD7Y4H9kbmsalpQsRnPTVxm7t+kOjspGK0Klg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WllajhSIXaOylbE0q0GTPvILmJlhw3r5pd5BrzMBn6g=;
 b=wBxgzEU4jep1eptusmBfNcnhoBIrxVhz+b74D49ZvdGT3rzEx8nztUxZByt6rD29iBOdBGu2OmnNGI5snfRXy6uwsCyJglIkmLtGN8vNu+/4vtPpQljgIZmVwzoRFUJ6T/4s8lPhA9wsUWbryD/Y5fsAaCrDZSDiu9P4wr/HtXXm+Cv/5b0ChERHUYHAnRUrb1E7N7r/lPtqHLjWJppcdFMRaVKQ7WZIv9SIHh2RxT5x6T0Hwfptyyu72JvRsuj6RjGonxodGkVPxxJUv/YJGfNLSR8qL33Omoyn/nubmmRC4HFpnEwwarYIEtiBZovpRWWB+ZrCAh9/NxMFngPa/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WllajhSIXaOylbE0q0GTPvILmJlhw3r5pd5BrzMBn6g=;
 b=PutdMMdReTeq1GngAxbVaZdRP3uy8/pthsWC8qvHwqGK292slc1xG9iGjTyKkm710ELcG/a5UTmpLzhn8BFxko4AhtPtXiFiuwM2Jp4ODa0SufnBLkHuitJyjEnasDgoFfyNetlRMC/QF9OZLc/hyvpy79RGFtrHSBiSP+h0KfU=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:59:02 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:59:02 +0000
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
Subject: [PATCH v5 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH v5 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore
 hyp interface
Thread-Index: AQHcpzjTRj8blBECPEqYX+39W8/2XA==
Date: Thu, 26 Feb 2026 15:59:02 +0000
Message-ID: <20260226155515.1164292-15-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|DU6PEPF00009523:EE_|DU0PR08MB7389:EE_
X-MS-Office365-Filtering-Correlation-Id: b00a2529-b388-4d51-4229-08de75501bb5
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 insw2ajCOKUhEM2ynZP4J3EFbaCvIzlZqwt034xfKT/d0nY5X3byFFGdV5C7h2Hq1R71wdyoN6ZhpPSD61pt79yt51ISCOFnPfgYvQrKmdbYPaTg/nr6VBKtBcSjIlSgz1uhRf+ITEPN7UEMlLViewS1BXXGvct8e15Gydw+du+VBDMiYrrpem6PAAeJIkYT6u326vB0RrDTSiubrnCnPFYKZk4m6oUljQHc7q0AUfVARlz9bxZmST4KM1OeTS52VMuEl0p3Es1lCSpZU51/iY9TbaxVonEpkuKNAfWvZQCJ4Xm9DM9cJQDIYkn5zvFDHIbkh7PMPVncbRpa7+P4VPGfHMx7B2LzuDjUvNP+257jW8022w4LkOScMr039pd+wNQmFbiAcXGbcQJdtmb5lY2bO01NhEQti/iJRL/FpGNuWZ/VHJyQdvM06d/1iCdkNppOArQBT57aZbLjKkxa3Gp60eTxwAAhE1Jc3KBr9WqPlQGnHtdMCCf2ZYOIKC+E3FblzbZSWB0gg8rN4u95krEiu7+6NIJSzmCXDkFzKGMl7MnyvEFAuCcWi3PMcCUx1BwjWyJwBz4eLA6Ei3BF6r1gu+28ZPnd8xrjAObx1DWEiNsiQpuuAVfZiLFeLVf+7xcG+b1zevDeOgixpy8mI+NrIddkgY4VjxMCVd4h7Gi3Z4gaKzG0UtWjtlfKW+s26nLouvzBuxc2NIgBlf6mTggZ0bGcceHzDl2oVnqynklm+xZhZqxNduDxaq9WFjXxaKl6KxG4tMZ1KBI5RHM4ywSNJwMLAmigBkmsTANaAjg=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f237de81-781c-403a-7ffd-08de754ff630
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|376014|82310400026|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	eTpQNsEaMrjvKEwyvHs10rnqAnezg+KNvLXqhnHsRUos2tXTKglWELweSgJKQbVqc6JyHyWvV9nvAEwnnqr+n5rmJj9caKXTQ1Gu9AHA/4Wn6x3Y95pe6F0eom0JdMPVrp7UPnv1vmxm3014+8w5gTYu/llckR0ZSrkfshjVSspFLCxzaw29Y3Se8fYszXV7IBW7GlxZ6SO7w+QZe2NaJrFcWbp0Ye+iPpNlIeSw4OzJKzYq60YzmRqNkAs8dXl0c8peQWXAY0fkzhU50BhLAfw0a4wmmoSTaGrQixP2zMtE/gJgrp2Q4otwqclCa+poaPpo/9ZTAbon0Ig1gpNPBNyEKLoy1Dt9QMkef8aFQknHDzhvD9HhPHbD8JKhKg4lrQlxhspux5XmeeT58fv1/0GjzfRtKIH4yQI7NRpiUBgH2l2j7lnRTk5yGjoKdi4WrCqkEXEp7Hc1Nam3jufLJXrlnZTLuvMjE3t5pabReA7MIbK17Ce5evFVUGB0WCsgjhM5qOP6spd6wj/z84cMPysHjRQcSjndwfv5w28mSS7M9EmPtWg7+igYh2fuVdQxMJpvzsVvn4HWal2VirUCuMKG6wR/wG9hyhFYreCYNs5hxU86mqA5KdoN1Z4rj2rU208ft2T7bmlhmhxzoLhU/tuIRXbAupMzm/ltGU68Ag88xv9erFzIMLkBCoXHb6Lk+2FQQvXfRULsfd2RjfRjEWjjOWEcqFwSIIhY8pcyv4T83JXuJkG35HfvoORGtahDa4aCclGrgkzLXXxDBKlm09rrLu3fJYnBtf6mrDg1FjyMZQBt3G6gFqRknmmPTOewjS19n9oJmGRekR3OKV5IZQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(376014)(82310400026)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gth/44hG0OzkfQGhD1jU4FVEDLv43cK1al0uGRZNCofUkaBXSdqVOKU7Z4VsX10CsPRtpsZDg0eMy0vHY3t3a8aBA6GAmVG8d9p8QfIBiC+EwMVoT7g40/GbakBFi6hBtQlMCs58LAOjEhpacGBrkorVlTHzKcubeWU1/HaNnVKS59mXcjKzaDa0bfNMot44o0C9jZ/QBUVo+NRsJ84+CtEcQFhPdSSEnS8GJ03qIASBmaZNTn1CxH8BMsRN5zWcnqHz6hIOPFCzzCc41coz2SgIaRN/Z2iI+uBmiD+PSWv/tJfXLUquIbV8fA1s8QRdUPrs5XmaH0BaVN/PBA4fPau4YAk9/dRyGD/Ml3LijZ45sZ51IgnvQkU6w+NiGpVFNzLRQeIkyYSoHaFEhmzzrGZHGqw8eIZsODdDdri5CrIkcMD6j+DyQy4fc9AoPt1t
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:00:05.4757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b00a2529-b388-4d51-4229-08de75501bb5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7389
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
	TAGGED_FROM(0.00)[bounces-72033-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 50FEC1AB4CE
X-Rspamd-Action: no action

Introduce hyp functions to save/restore the following GICv5 state:

* ICC_ICSR_EL1
* ICH_APR_EL2
* ICH_PPI_ACTIVERx_EL2
* ICH_PPI_DVIRx_EL2
* ICH_PPI_ENABLERx_EL2
* ICH_PPI_PENDRRx_EL2
* ICH_PPI_PRIORITYRx_EL2
* ICH_VMCR_EL2

All of these are saved/restored to/from the KVM vgic_v5 CPUIF shadow
state, with the exception of the active, pending, and enable
state. The pending state is saved and restored from kvm_host_data as
any changes here need to be tracked and propagated back to the
vgic_irq shadow structures (coming in a future commit). Therefore, an
entry and an exit copy is required. The active and enable state is
restored from the vgic_v5 CPUIF, but is saved to kvm_host_data. Again,
this needs to by synced back into the shadow data structures.

The ICSR must be save/restored as this register is shared between host
and guest. Therefore, to avoid leaking host state to the guest, this
must be saved and restored. Moreover, as this can by used by the host
at any time, it must be save/restored eagerly. Note: the host state is
not preserved as the host should only use this register when
preemption is disabled.

As part of restoring the ICH_VMCR_EL2 and ICH_APR_EL2, GICv3-compat
mode is also disabled by setting the ICH_VCTLR_EL2.V3 bit to 0. The
correspoinding GICv3-compat mode enable is part of the VMCR & APR
restore for a GICv3 guest as it only takes effect when actually
running a guest.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_asm.h   |   4 +
 arch/arm64/include/asm/kvm_host.h  |  16 ++++
 arch/arm64/include/asm/kvm_hyp.h   |   8 ++
 arch/arm64/kvm/hyp/nvhe/Makefile   |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  32 ++++++++
 arch/arm64/kvm/hyp/vgic-v5-sr.c    | 123 +++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile    |   2 +-
 include/kvm/arm_vgic.h             |  21 +++++
 8 files changed, 206 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index a1ad12c72ebf1..fe8d4adfc281d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,6 +89,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_ppi_state,
+	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_ppi_state,
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index 332114bd44d2a..60da84071c86e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -797,6 +797,22 @@ struct kvm_host_data {
 	/* Number of debug breakpoints/watchpoints for this CPU (minus 1) */
 	unsigned int debug_brps;
 	unsigned int debug_wrps;
+
+	/* PPI state tracking for GICv5-based guests */
+	struct {
+		/*
+		 * For tracking the PPI pending state, we need both
+		 * the entry state and exit state to correctly detect
+		 * edges as it is possible that an interrupt has been
+		 * injected in software in the interim.
+		 */
+		u64 pendr_entry[2];
+		u64 pendr_exit[2];
+
+		/* The saved state of the regs when leaving the guest */
+		u64 activer_exit[2];
+		u64 enabler_exit[2];
+	} vgic_v5_ppi_state;
 };
=20
 struct kvm_host_psci_config {
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 76ce2b94bd97e..3dcec1df87e9e 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -87,6 +87,14 @@ void __vgic_v3_save_aprs(struct vgic_v3_cpu_if *cpu_if);
 void __vgic_v3_restore_vmcr_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
=20
+/* GICv5 */
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if);
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if);
+
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __timer_enable_traps(struct kvm_vcpu *vcpu);
 void __timer_disable_traps(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index a244ec25f8c5b..84a3bf96def6b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,7 +26,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
 hyp-obj-y +=3D ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index e7790097db93a..fb056f6e8b2bb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -589,6 +589,34 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+static void handle___vgic_v5_save_apr(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_apr(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_vmcr_apr(struct kvm_cpu_context *host=
_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_vmcr_apr(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_save_ppi_state(struct kvm_cpu_context *host_c=
txt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_save_ppi_state(kern_hyp_va(cpu_if));
+}
+
+static void handle___vgic_v5_restore_ppi_state(struct kvm_cpu_context *hos=
t_ctxt)
+{
+	DECLARE_REG(struct vgic_v5_cpu_if *, cpu_if, host_ctxt, 1);
+
+	__vgic_v5_restore_ppi_state(kern_hyp_va(cpu_if));
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -630,6 +658,10 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
+	HANDLE_FUNC(__vgic_v5_save_apr),
+	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
+	HANDLE_FUNC(__vgic_v5_save_ppi_state),
+	HANDLE_FUNC(__vgic_v5_restore_ppi_state),
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
new file mode 100644
index 0000000000000..47c71c53fcb10
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 - Arm Ltd
+ */
+
+#include <linux/irqchip/arm-gic-v5.h>
+
+#include <asm/kvm_hyp.h>
+
+void __vgic_v5_save_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_apr =3D read_sysreg_s(SYS_ICH_APR_EL2);
+}
+
+static void  __vgic_v5_compat_mode_disable(void)
+{
+	sysreg_clear_set_s(SYS_ICH_VCTLR_EL2, ICH_VCTLR_EL2_V3, 0);
+	isb();
+}
+
+void __vgic_v5_restore_vmcr_apr(struct vgic_v5_cpu_if *cpu_if)
+{
+	__vgic_v5_compat_mode_disable();
+
+	write_sysreg_s(cpu_if->vgic_vmcr, SYS_ICH_VMCR_EL2);
+	write_sysreg_s(cpu_if->vgic_apr, SYS_ICH_APR_EL2);
+}
+
+void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	host_data_ptr(vgic_v5_ppi_state)->activer_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER0_EL2);
+	host_data_ptr(vgic_v5_ppi_state)->activer_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER1_EL2);
+
+	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER0_EL2);
+	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER1_EL2);
+
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR0_EL2);
+	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR1_EL2);
+
+	cpu_if->vgic_ppi_priorityr[0] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR0_EL=
2);
+	cpu_if->vgic_ppi_priorityr[1] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR1_EL=
2);
+	cpu_if->vgic_ppi_priorityr[2] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR2_EL=
2);
+	cpu_if->vgic_ppi_priorityr[3] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR3_EL=
2);
+	cpu_if->vgic_ppi_priorityr[4] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR4_EL=
2);
+	cpu_if->vgic_ppi_priorityr[5] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR5_EL=
2);
+	cpu_if->vgic_ppi_priorityr[6] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR6_EL=
2);
+	cpu_if->vgic_ppi_priorityr[7] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR7_EL=
2);
+	cpu_if->vgic_ppi_priorityr[8] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR8_EL=
2);
+	cpu_if->vgic_ppi_priorityr[9] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR9_EL=
2);
+	cpu_if->vgic_ppi_priorityr[10] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR10_=
EL2);
+	cpu_if->vgic_ppi_priorityr[11] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR11_=
EL2);
+	cpu_if->vgic_ppi_priorityr[12] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR12_=
EL2);
+	cpu_if->vgic_ppi_priorityr[13] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR13_=
EL2);
+	cpu_if->vgic_ppi_priorityr[14] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR14_=
EL2);
+	cpu_if->vgic_ppi_priorityr[15] =3D read_sysreg_s(SYS_ICH_PPI_PRIORITYR15_=
EL2);
+
+	/* Now that we are done, disable DVI */
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(0, SYS_ICH_PPI_DVIR1_EL2);
+}
+
+void __vgic_v5_restore_ppi_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	/* Enable DVI so that the guest's interrupt config takes over */
+	write_sysreg_s(cpu_if->vgic_ppi_dvir[0], SYS_ICH_PPI_DVIR0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_dvir[1], SYS_ICH_PPI_DVIR1_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_activer[0], SYS_ICH_PPI_ACTIVER0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_activer[1], SYS_ICH_PPI_ACTIVER1_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_enabler[0], SYS_ICH_PPI_ENABLER0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_enabler[1], SYS_ICH_PPI_ENABLER1_EL2);
+
+	/* Update the pending state of the NON-DVI'd PPIs, only */
+	write_sysreg_s(host_data_ptr(vgic_v5_ppi_state)->pendr_entry[0] & ~cpu_if=
->vgic_ppi_dvir[0],
+		       SYS_ICH_PPI_PENDR0_EL2);
+	write_sysreg_s(host_data_ptr(vgic_v5_ppi_state)->pendr_entry[1] & ~cpu_if=
->vgic_ppi_dvir[1],
+		       SYS_ICH_PPI_PENDR1_EL2);
+
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[0],
+		       SYS_ICH_PPI_PRIORITYR0_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[1],
+		       SYS_ICH_PPI_PRIORITYR1_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[2],
+		       SYS_ICH_PPI_PRIORITYR2_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[3],
+		       SYS_ICH_PPI_PRIORITYR3_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[4],
+		       SYS_ICH_PPI_PRIORITYR4_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[5],
+		       SYS_ICH_PPI_PRIORITYR5_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[6],
+		       SYS_ICH_PPI_PRIORITYR6_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[7],
+		       SYS_ICH_PPI_PRIORITYR7_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[8],
+		       SYS_ICH_PPI_PRIORITYR8_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[9],
+		       SYS_ICH_PPI_PRIORITYR9_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[10],
+		       SYS_ICH_PPI_PRIORITYR10_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[11],
+		       SYS_ICH_PPI_PRIORITYR11_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[12],
+		       SYS_ICH_PPI_PRIORITYR12_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[13],
+		       SYS_ICH_PPI_PRIORITYR13_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[14],
+		       SYS_ICH_PPI_PRIORITYR14_EL2);
+	write_sysreg_s(cpu_if->vgic_ppi_priorityr[15],
+		       SYS_ICH_PPI_PRIORITYR15_EL2);
+}
+
+void __vgic_v5_save_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	cpu_if->vgic_vmcr =3D read_sysreg_s(SYS_ICH_VMCR_EL2);
+	cpu_if->vgic_icsr =3D read_sysreg_s(SYS_ICC_ICSR_EL1);
+}
+
+void __vgic_v5_restore_state(struct vgic_v5_cpu_if *cpu_if)
+{
+	write_sysreg_s(cpu_if->vgic_icsr, SYS_ICC_ICSR_EL1);
+}
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index afc4aed9231ac..9695328bbd96e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -10,4 +10,4 @@ CFLAGS_switch.o +=3D -Wno-override-init
=20
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../vgic-v5-sr.o
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 25e36f8b97a1e..ba227ca98c233 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -410,6 +410,26 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+struct vgic_v5_cpu_if {
+	u64	vgic_apr;
+	u64	vgic_vmcr;
+
+	/* PPI register state */
+	u64	vgic_ppi_dvir[2];
+	u64	vgic_ppi_priorityr[16];
+	u64	vgic_ppi_activer[2];
+	u64	vgic_ppi_enabler[2];
+
+	/*
+	 * The ICSR is re-used across host and guest, and hence it needs to be
+	 * saved/restored. Only one copy is required as the host should block
+	 * preemption between executing GIC CDRCFG and acccessing the
+	 * ICC_ICSR_EL1. A guest, of course, can never guarantee this, and hence
+	 * it is the hyp's responsibility to keep the state constistent.
+	 */
+	u64	vgic_icsr;
+};
+
 /* What PPI capabilities does a GICv5 host have */
 struct vgic_v5_ppi_caps {
 	u64	impl_ppi_mask[2];
@@ -420,6 +440,7 @@ struct vgic_cpu {
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
+		struct vgic_v5_cpu_if	vgic_v5;
 	};
=20
 	struct vgic_irq *private_irqs;
--=20
2.34.1

