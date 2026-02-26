Return-Path: <kvm+bounces-72046-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IBVMKeV7oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72046-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:59:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF161AB801
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 704EC313725B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:25:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C3F48AE06;
	Thu, 26 Feb 2026 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BTF1awcP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="BTF1awcP"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013020.outbound.protection.outlook.com [40.107.162.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365FD481AAF
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.20
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121812; cv=fail; b=U9i15RZltLDgYCen7ST0RBp5j1Q0Vl1h9/8FsCtL8EIpQcGAGWtqFpDqF+6hiAgJ0lRHU05ER1qWtnha6/jlzuHUur9+lxP6GkWLtgcp3dsuyqIdpJMD1tIQBavJg1qOkWWExkHudVnZy/0t0ht3KNrOy4zNwvWdGCXCB1Pywos=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121812; c=relaxed/simple;
	bh=e2o2M2FKNYYrk5UGE6+KM+f90B7zICDXmxN4A1L6xjY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gOV7lkQRoSAm/7Vpce9Dg13s61ZrZHOHSEBMpA1m1VCaGI971g40ORWQ1AmSeK12GoEJqW2c9V9vzHJuMPSC88OCH6EGIOFnw3RidTYlZ52jvk45hmZUwbW+QnPXsbymLDhKYyLF6M4HTwQG8BiWDHbjezxokQ/lAuHwAXNuik4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BTF1awcP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=BTF1awcP; arc=fail smtp.client-ip=40.107.162.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=VYK2JY+m6eQS18nMzg+eWuUU0kdUKWslYSTfFaROAXnDFb/OlUHrR+zVT0jT5XPrO86QDIvZnZBPg4U48Sh5P+6ASclLP8Ipe3aIjhW5rbsmU+CgrjZ2XQvdPhsLIMfWSJbI8660Yju7qLwyEoynK/ubZzGX3DPyxYlAqKG2NFCWMzXS8ZP+285K/Vc2sSqIM8wBjSv04bL6FyJEueLManQgU95qSq6bruEQ7rQ7hTfqPqyR+PQUF63fYfuKoRZwlgiuiERgN5wE78ApC6qo1JvVNXvy/9b4vUJB8te6m0hlK/kkejMx9Hk485G30Hx1t2MymhWEElJSi4pN9itFzQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIkZKz828fw9VGpT3r0gGqmVnEdxbqLUdBv5wUBZX64=;
 b=bkZpfbm3SppLOHtO4/1tU5ka6KryBThwOPjZxv4hjLhJp4G6Pn00WfkQDhqkep/61uK1xVzsl6pmfIyn+qgYEt1aUYtzE7zHrHX6fBymAfP5cnhUnn9jnsO1vx7Ie/KlCWxO5gKH+97ApOo5aglvMDqeHaKB/ZIMr++P2ooYMxFMLlbXavl1LjZXowHBHFpdKgkQGAknplctRhOoIb1EEK0P00j7JcuruGkH1/nwFs0NF5MGx5Uc91OdDKuOCRzChUNrTt5L1doRFmmWPKpqnepuLe2Xbu6PlcovKj0M35AT1r/JAbTlUKCBCPm1NZTM4QwS1wCIUWq0obGJBzhPtQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIkZKz828fw9VGpT3r0gGqmVnEdxbqLUdBv5wUBZX64=;
 b=BTF1awcPstaHbHpkFF+RiXQfN2c2t8in2inDEg6CG9bLK6ULlvBsMH/1bhFzQb6GAz68sBmHp32Lf8952qJErcm0Wd3dkPP7bCTgTrQRS7XvwUURPIUCtve4gIgo/zWVt1QKffowgpAXV7dfuLsvPOlDUszPKDeS6RihZRKgsfI=
Received: from DU6P191CA0061.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::14)
 by DU0PR08MB7689.eurprd08.prod.outlook.com (2603:10a6:10:3a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 16:03:15 +0000
Received: from DB1PEPF000509E2.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::59) by DU6P191CA0061.outlook.office365.com
 (2603:10a6:10:53e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:03:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E2.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:03:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dLjK3GjkVnrxuXCOoTk2BZTzk+c+DvKv2P0egGvut6NPOpI7qOvfjmhf/bHFLXlyzseONJkYLF1liCEjGoQS7liu5MOsWzfVMHi5NgzoO2wrp3wv/AFi3pKrQU7W8xhoa4ih8xRMMYDO/P+eo2vrCOZU6OOWJNwBA1uqNKVX2BXinmPWwRQS+w2XnLiCUXPpxf70RPQU/UwoWSdLz4gIaEVhksl8mEquGSmXFpwq36J9qsEJYiFsHl3+jIgdxbvL1x+cf110ICnPWGBEBmvpbBjlcHpT+GAAiY7n6fpBlFaBr7jPqhb9r2wst6A9iSxDbWGq27dbATO1PFG+dYoh9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XIkZKz828fw9VGpT3r0gGqmVnEdxbqLUdBv5wUBZX64=;
 b=PdK+B+8sl5p5LcywmdZZyASsD/9+a5sry50slodR8DZgJhF3Sn35t3Es0u2EWscoJfF77sQ20HmKuvnpFRFGAv5ms83Lqp0iED5MT1Z8XZVXhsFE2TqSQ8EilzUYKus7nhYFj0/+ZUjofT8GnF8Z18lyPv9sv4JYAN+wK30KuUPIgZFxVDOdyUE4mYvLzDAfAHCC10JsVXzEX2QwaUK5DFgnMiv+YUl3UXXQf8JvKJNcGvyfOTAUtyg5Qrngl0zYvOUitNUXDK4G/syCuuxMoaPLjDMEff0u0fJqKUL7DK9BhbJdsGzeYMsEl8RCMofkWU/Oqs6bnE6W7TBLSuLw/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XIkZKz828fw9VGpT3r0gGqmVnEdxbqLUdBv5wUBZX64=;
 b=BTF1awcPstaHbHpkFF+RiXQfN2c2t8in2inDEg6CG9bLK6ULlvBsMH/1bhFzQb6GAz68sBmHp32Lf8952qJErcm0Wd3dkPP7bCTgTrQRS7XvwUURPIUCtve4gIgo/zWVt1QKffowgpAXV7dfuLsvPOlDUszPKDeS6RihZRKgsfI=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:02:10 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:02:10 +0000
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
Subject: [PATCH v5 26/36] KVM: arm64: gic-v5: Enlighten arch timer for GICv5
Thread-Topic: [PATCH v5 26/36] KVM: arm64: gic-v5: Enlighten arch timer for
 GICv5
Thread-Index: AQHcpzlDbqbHv+l0zEOHndp0YBAc0Q==
Date: Thu, 26 Feb 2026 16:02:09 +0000
Message-ID: <20260226155515.1164292-27-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|DB1PEPF000509E2:EE_|DU0PR08MB7689:EE_
X-MS-Office365-Filtering-Correlation-Id: 44d6515b-d091-4aaf-37d3-08de75508c5c
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 TZAYSWjPilc8wzOo23Fa6CijwiawysTccK8cuImlCk0MvnTj3QxkcbSvi1J5q8XgUezeDtPV0N6YyVLqyDgLke0fi3U0svv8Oh10lVIk4Y2282hyVsqbHgS7uVc6cpG2r0iwxi/f72SSCSREcFYPiIHeCXr2vydQIIr2RDyqBkscPnDrqF1JW0Y+4FtzYnLNtmVAgKqmzxx0FQP2ekvBljtpjhOreUrtwAXpDiROTrb4Vpc048PPasXBCJyIknouf2522HQRMSEFvBqmVcwupY2lSr49QbZE86kAoZWji8rpYutLiizUdbbLmGFEhw2w9v6VpOzH5Sl0dLhIvkuQIk4NuPyIsAPztfmtN1OMiiP+HAoHvIhfEA3THQOtVjfosy7x78PnusAw9yiXSbyIKUmfJjtrs6jK581vgme6V3yjvIhwp5ozxUq9rZu9TiRMlAH6SqGj/+bIHSO+d+6rG4cfNn7nLkkknE/kwnvfRYjTlvQJAxTvnOCjleEmDhUulF94JkfyyCxuQ2wHwlxmtC3NQ8APVqBYwWjxCp3XHVl01vSK8pkzGThldeP0hOG3rOpR7kJK6kLGZkfDkhFxSYSIOGm9fFeCorkrxZ/LgP407Dxss+FXhI25vKAWdOyjntOJ3SKQ+HkSn0J+r/b6k9BDW0zTHD8pJC5Mm+qYEMxtUuxpc9qqfI6ZtHBHT5QngQZcMDmVE2sor/tx6/FAkQLn608eFuLqbo8n8iuTKUU6EAwuB9f1M9OgC6U/jdOmtNBfvrlVRN94OlOwPVVWyRYe+LXlHh7dhCx6Z4jEjpM=
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
 DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	884d808b-16f6-454e-3d9f-08de755065dd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|36860700013|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	z/1sd4PAlKfC/wdTbXF0AAaXvxWbU1zvvamc5iGtBQWHrAmO9OlRwHNa8ytQLFMGH1cCtpQIlU4P/V4XGoN4SC5oLSMEFgjSoEgGcorY4kaYWgq2WQDirIWR5Z2wOJoqC/jBoCKPvNvyN1289JjOa17VB+MGh7heAY/k3qfaYxuHao4SL/XnShroOUFlRDwqZT1i/RiZL8im3zIpF2D56bo14ew/Re1nETpw/xowHBBVHLWciJ84cBOAUp+OvAeHMpVBAmHcvBrf6GUJADpQYVowJC9nO1fTmQcnTv06N5u6aXSXGA3lmpGMmTULEFJ2ynza18oAeyTIcSLzsBPGmMiaQK37DwfZiN9Cs6+q4XcyiEtB39hTPdRJJlDNRDuyFM9Oar9593sEg/DBIfp//IoeRcpmwF3sSn2+psL86Kr3UDaBtK5gaYzIgUSQ9ZSmOPHDbVFLNuvAvDXXmgCBPNfozA7WteVHHOcUYcVUnqpvEeORl5vdRrFS2bwZcezY8NOnwYVZP3jouUD9OVUVh+WxsiZDllY1sP8re+vSyFNhByHiSjTk1a86GVrN025wD4WiYxyx5JEvMc+rbo660gwyEZGdyGvL3Az/K8cRxdps9yj30sw/AR5YuBE+binqs1WCUXzSc0jLWMkN0Vjst6XapREtBPBph+puyWNjA0Xiy5fYdgb/U8gbxD1AP9aCyOv2ZmN7prpqHeWsxJejjTKK7SRVeI6xULkPkvolApv1Py4AxrRedI/Vo7ddvJiZTxM5vwmJWFjFTvcw61+RJiR5/+oa9AwurgDRgGtMTb83MU+mpcxdLIL5H9IRqhJpCazCzmz+Qy0CS32pADtwYw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(36860700013)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0S/FEuIfCdBRlqDkVSGOmA4u+6UpMev0TzAw104pFWfa0QJBDb/2AfUTZ9FVjZgYXCjVoZoVMGobtlj1DGMlJsT5pkKiSYltJWUE4QDdozOypZx1xAH37Q/Omm4bQtWBuokIYHI4xXZY132MFiscJb6POJFglfetzIdED/Zj1u/b4nHySu4mKuDOe2v5vv0gjY3f5RhhZFN12GRjGfiiCWCc1fve/Ms34NXlfz2i/n89wOPDroNfrIhnX/39Iwyqj1QQBhR3rv0AQa8iM9dJk6ZQsXCFoPFAlhQNc9X+k9vV0KfuaKcLrhRKNSgEl+CpzqiVWBB3l/nFvp7DMm5ea6LWvVoizEOgGSA6h1xKKL7NEBylP3Vm7ZGYxFo0qa4P9PDZbcL6lS05r6Ruks2aH/WA9y6aO52+E5jvgNQeTVLV0U3Y763EGzspzYSx8dbW
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:03:14.4747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d6515b-d091-4aaf-37d3-08de75508c5c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E2.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7689
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
	TAGGED_FROM(0.00)[bounces-72046-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,huawei.com:email];
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
X-Rspamd-Queue-Id: AEF161AB801
X-Rspamd-Action: no action

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the queue_irq_unlock irq_op is used as AP lists are
not required at all for GICv5. The arch timer also introduces an
irq_op - get_input_level. Extend the arch-timer-provided irq_ops to
include the PPI op for vgic_v5 guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state into the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has three impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

* Thirdly, it makes zero sense to attempt to inject state for a DVI'd
  interrupt. Track which timers are direct, and skip the call to
  kvm_vgic_inject_irq() for these.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c     | 116 +++++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-init.c |   9 +++
 arch/arm64/kvm/vgic/vgic-v5.c   |   4 +-
 include/kvm/arm_arch_timer.h    |  11 ++-
 include/kvm/arm_vgic.h          |   2 +
 5 files changed, 114 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index f1f69fcc9bb3d..6759d043c70cf 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,11 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -177,6 +182,10 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer=
_map *map)
 		map->emul_ptimer =3D vcpu_ptimer(vcpu);
 	}
=20
+	map->direct_vtimer->direct =3D true;
+	if (map->direct_ptimer)
+		map->direct_ptimer->direct =3D true;
+
 	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
 }
=20
@@ -396,7 +405,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -447,6 +460,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu=
, bool new_level,
 	if (userspace_irqchip(vcpu->kvm))
 		return;
=20
+	/* Skip injecting on GICv5 for directly injected (DVI'd) timers */
+	if (vgic_is_v5(vcpu->kvm) && timer_ctx->direct)
+		return;
+
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
 			    timer_ctx->irq.level,
@@ -657,6 +674,24 @@ static inline void set_timer_irq_phys_active(struct ar=
ch_timer_context *ctx, boo
 	WARN_ON(r);
 }
=20
+/*
+ * On GICv5 we use DVI for the arch timer PPIs. This is restored later
+ * on as part of vgic_load. Therefore, in order to avoid the guest's
+ * interrupt making it to the host we mask it before entering the
+ * guest and unmask it again when we return.
+ */
+static inline void set_timer_irq_phys_masked(struct arch_timer_context *ct=
x, bool masked)
+{
+	if (masked) {
+		disable_percpu_irq(ctx->host_timer_irq);
+	} else {
+		if (ctx->host_timer_irq =3D=3D host_vtimer_irq)
+			enable_percpu_irq(ctx->host_timer_irq, host_vtimer_irq_flags);
+		else
+			enable_percpu_irq(ctx->host_timer_irq, host_ptimer_irq_flags);
+	}
+}
+
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu =3D timer_context_to_vcpu(ctx);
@@ -675,7 +710,10 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_=
context *ctx)
=20
 	phys_active |=3D ctx->irq.level;
=20
-	set_timer_irq_phys_active(ctx, phys_active);
+	if (!vgic_is_v5(vcpu->kvm))
+		set_timer_irq_phys_active(ctx, phys_active);
+	else
+		set_timer_irq_phys_masked(ctx, true);
 }
=20
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
@@ -719,10 +757,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					      struct timer_map *map)
 {
 	int hw, ret;
+	struct irq_ops *ops;
=20
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	/*
 	 * We only ever unmap the vtimer irq on a VHE system that runs nested
 	 * virtualization, in which case we have both a valid emul_vtimer,
@@ -741,12 +783,12 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
 					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
 					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 	}
 }
@@ -864,7 +906,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu->kvm))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -934,6 +977,14 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/* Unmask again on GICV5 */
+	if (vgic_is_v5(vcpu->kvm)) {
+		set_timer_irq_phys_masked(map.direct_vtimer, false);
+
+		if (map.direct_ptimer)
+			set_timer_irq_phys_masked(map.direct_ptimer, false);
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1097,10 +1148,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1352,6 +1412,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 		}
=20
 		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		arch_timer_irq_ops_vgic_v5.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1502,10 +1563,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are
+		 * architecturally defined to be under 32 too. However, we mask
+		 * off most of the bits as we might be presented with a GICv5
+		 * style PPI where the type is encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1543,6 +1607,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
 	int ret;
=20
 	if (timer->enabled)
@@ -1561,22 +1626,20 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	get_timer_map(vcpu, &map);
=20
-	ret =3D kvm_vgic_map_phys_irq(vcpu,
-				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+	ret =3D kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
+				    timer_irq(map.direct_vtimer), ops);
 	if (ret)
 		return ret;
=20
-	if (map.direct_ptimer) {
+	if (map.direct_ptimer)
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
-	}
-
+					    timer_irq(map.direct_ptimer), ops);
 	if (ret)
 		return ret;
=20
@@ -1606,12 +1669,11 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
=20
 	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
 		     &vcpu->kvm->arch.flags)) {
-		ret =3D -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
=20
 	switch (attr->attr) {
@@ -1628,10 +1690,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 		idx =3D TIMER_HPTIMER;
 		break;
 	default:
-		ret =3D -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers are architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq=
)
+		return -EINVAL;
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
@@ -1639,8 +1707,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	 */
 	vcpu->kvm->arch.timer_data.ppi[idx] =3D irq;
=20
-out:
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 59ef5823d2b5e..7df7b8aa77a69 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -173,6 +173,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
=20
+	/*
+	 * We now know that we have a GICv5. The Arch Timer PPI interrupts may
+	 * have been initialised at this stage, but will have done so assuming
+	 * that we have an older GIC, meaning that the IntIDs won't be
+	 * correct. We init them again, and this time they will be correct.
+	 */
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm_timer_init_vm(kvm);
+
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	kvm_unlock_all_vcpus(kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index a0d7653b177e2..60fda0694bdd1 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -202,8 +202,8 @@ static u32 vgic_v5_get_effective_priority_mask(struct k=
vm_vcpu *vcpu)
  * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
  * state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f45121..a7754e0a2ef41 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -74,6 +76,9 @@ struct arch_timer_context {
=20
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
+
+	/* Is this a direct timer? */
+	bool				direct;
 };
=20
 struct timer_map {
@@ -130,6 +135,10 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+			    (i) : (FIELD_PREP(GICV5_HWIRQ_ID, i) |	\
+				   FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 2ad962298bfa9..0a5c2810ed3ad 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -585,6 +585,8 @@ void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
=20
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
--=20
2.34.1

