Return-Path: <kvm+bounces-72049-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +CkOFsJ9oGlgkQQAu9opvQ
	(envelope-from <kvm+bounces-72049-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:07:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 983D21ABBB1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:07:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 77A1431FABFD
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A619D48C3FA;
	Thu, 26 Feb 2026 16:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YSM9lQJy";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YSM9lQJy"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010023.outbound.protection.outlook.com [52.101.69.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AF448C8CE
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.23
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121851; cv=fail; b=bdZHWbi/XfFCZooUIOzDQs0hk1G4hxMuAH/G7Y6aiEiPV3bxPnlXzJ8+B1i8fhZAWVwLwZhJ30TqCN5YA6ZZADABJmYXHv26Xh8qnu3RDsqxwilxrms4mPic3b6Q+vMrVt3nCio0iBqyGBicHFhiQOQWM0p5WZzAAJu8tRlfzmI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121851; c=relaxed/simple;
	bh=9XFdlBhKhjxaKz39b0UycNkEFecxTzS4+gq3orlyaSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VOLZOZl+1I39DDN3s2K6jKqPk/fVGT1v2MaYcb3IblN8tw6PMrM0zFt/kLYtU2yQqW5Cx25f7114vHuhT5QeJuFr/hCbEleMkJRYm7YHw+bZ9dXjjTIcRfHunedjgAMS7oJTtrks/9N34mZjldPOsKyXdn24mqYksh3KHHLy+8Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YSM9lQJy; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YSM9lQJy; arc=fail smtp.client-ip=52.101.69.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=LQl+iO9x/wutyXms7Nm8EMpwTx7Z0VhwpAHp21TWJuNuFqaMbfk8hOqo1Fi/9AYLgjqucCT/+f4xxTvOTLSFRZ1R4V3KNrP4P705yw7/YyzVqaNrF6Et6txFdYV47cSy2FRizRc4e30vNvtKZ4grxv3ZgtNANJs1/zG3s6IUS8Z0KyFqxiGR42xjopMPDBahIzgfOQIK3IvFpwTl+nATD4FfDbIlBguemxM2rNaqS8ZX1B67Iqnp2SKNS3gpjbpDXeh2Oi7FMGAltGzkQPFkZ7YZdZQ72yvOPTyRQz1dq1Je3/n3V4x1kRneDjdnHWwFioK0PqNNeT9c0IbOdKlQGA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pzqg4UKNiQTFXxht4qREr3QNoiGlM2acusZbVE7RkiU=;
 b=lGHc1pNjoYvw1/k04GeD5uMbwcxHm6txfDzveiJJiSM0KdIQ4wIYW49PkJGxYZ1ivlobjsRlBAhl739FtCRwCg1FSZG2BBLdlvKFZ8Y5QGf8N7G8mIk6sD6mLIk2+GYzN2bYg6k0+BxtIk8JtArI6Dnh7nV9+CKc2mi/g1IU9TcTaYpaI2K5HHnVeikWXw3Up859dYfDUiMhlpdOsKpnFLwNqT0zEBzqa2zPpc6K7RoqmlqXkmPQmWZIm/8vH1veIZXCZmSL13FyUJ4aQfS74hTFTfBBKWenALou9NaogpFRtkQC6O2ljGIl7OvA+55WLKVe3QOg9tGPQB9NkvKg/Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pzqg4UKNiQTFXxht4qREr3QNoiGlM2acusZbVE7RkiU=;
 b=YSM9lQJyqNsAvDz9n6dsH3Dc87e+iqFVfBCVOh8LbmfGofu5bx9+D9frTptT0khtnXUkxNmets4VBYX1Ui9drCNVsfAAH6touRxKCTzoHwHCbF8Ktt2RkgxxN86DRTemtcfOwtstNrn80WD35nUzW1QFpO45L0xQHROGra2G/oc=
Received: from DUZPR01CA0136.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bc::24) by DB9PR08MB7495.eurprd08.prod.outlook.com
 (2603:10a6:10:36c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:04:01 +0000
Received: from DU6PEPF00009524.eurprd02.prod.outlook.com
 (2603:10a6:10:4bc:cafe::77) by DUZPR01CA0136.outlook.office365.com
 (2603:10a6:10:4bc::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 16:03:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009524.mail.protection.outlook.com (10.167.8.5) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12 via
 Frontend Transport; Thu, 26 Feb 2026 16:04:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mSJ2FUrthvZYHttgHmtOKg07wy/kiBW4Gar5btt50n9sdHlTpu9g0wbBFe033gdfwy1kokyB4lT8s2LC84kRitNXzVzUlawbCndNkO4uVqKjA4lBl0f33eL3Tca7PDkZ6lINWS0kofXBi+QTh/3Nk+y8csQBfaNwmync4mfUtqI48tKarNVotVNrMve5GGswvPnvuThJSTx3jbym7cWrtkBC5JDB+jyr8rFlO294T1MEy5r10t66SSLghdWEyAHOevhJSiG8//JQkKDgA6XH8Zydqy9vv26DbkED2aoWuimlQT/PO6eA1ZmktdBj19MkP8roF4sZmdIPuAYngytvmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pzqg4UKNiQTFXxht4qREr3QNoiGlM2acusZbVE7RkiU=;
 b=qOOugaUz/eI0U4BMygx3H7AtyiLunyyXKf/D7ANCilCwG0NG95cW/DpITQrUJXg7Y/jr/RaLFz+uV0ocN95sgpRpuzjhwYGB5kmcc8MktfLP3RTPHtKSmnMpJuSw67LYgHHgwZaP/yNNRw1rVsJiHUIHqEOdBjasAsVF6JrQSaMQTPOP0+1gA6VwhsfoMKL9+eUMf3mhMjekKgOL+GP18/TqqoJh0p6bUBFiXd5hqokzRbzGAsbFsSNKjQG+QSBtKHmHr2Dmsp6lO3KPML11hN3LLgual1QInFjKa/LUFEcu+bNpOU901kiFD5AvqKqN9D6tNYhh4yTuhB5Fb5v+hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pzqg4UKNiQTFXxht4qREr3QNoiGlM2acusZbVE7RkiU=;
 b=YSM9lQJyqNsAvDz9n6dsH3Dc87e+iqFVfBCVOh8LbmfGofu5bx9+D9frTptT0khtnXUkxNmets4VBYX1Ui9drCNVsfAAH6touRxKCTzoHwHCbF8Ktt2RkgxxN86DRTemtcfOwtstNrn80WD35nUzW1QFpO45L0xQHROGra2G/oc=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DB9PR08MB11312.eurprd08.prod.outlook.com (2603:10a6:10:608::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:02:58 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:02:58 +0000
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
Subject: [PATCH v5 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Topic: [PATCH v5 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Thread-Index: AQHcpzlgVw6UGXXUMEa+Imuv4+Ps8g==
Date: Thu, 26 Feb 2026 16:02:58 +0000
Message-ID: <20260226155515.1164292-30-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DB9PR08MB11312:EE_|DU6PEPF00009524:EE_|DB9PR08MB7495:EE_
X-MS-Office365-Filtering-Correlation-Id: 5124c9d3-a8e0-4e43-2fce-08de7550a814
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 Yc/E5AUerJ1If8opeGxrkoSwT+mywZ9pAcBeY9mSDyuYeDIuDNqdFOW42VSoR4k1m5O6IrHCB74zY+TsurzK8dbOyJi3julgwNe0weftQF302aUm55+Q57S2cx+o+5i+cRamPgGZRhmf/L2xH8NUyONmqiKwq/d0DSEcA+QF3OYzkdYl47H2R697WTkIBgq2pNg1eVahXFsax6ZXrBopr2Qb8PCm0ELBRuVezkc7t2a3UQ5u1ExWcsvafxJjwTaotuEpNFIHqPVC1C89XEXy25fwC8S7myBFYEQvugifNDgcv/kM5SQeC92KqTAEBjoK4Dns5PuQtUMbbc/XT7DMO3n6mY1ZECnuiohZFiqo1TaXC/MUWGj//GFoFrtsPgNqTNb8FOKrx/alApzagt4b7o7OBRYQg0N9IU6kR0X2VgjCnk/DbzYOrKe49UJbKC4RZ7ee3f9IcANWV0KJlRQ92bdDJq7z/DkFfPTRZP8OKDXTL5DSUq6XQMf4G2VOVNAUhHJaXuzX0jfWjcFdlplWCIxdwnTwBkzrRbotTKXKpolJ1l6s3oikCTh2m1BY/lz0mC0uVnF7y0WhuS9TR9fNIN2aQ7TAo3tAZE4bd4gHgEJjh28DTBa/fitl6BNOh7tVIpTIB5Gkr2p3fiW3zOeINQCSnQM7RexLp1xHip5gSmBJUMELOgeJ97UO0Pv8cI+N3Mt8/ebTF1JMbClMWFeOFzKqWFXt8HYfVCvi2Dmsui4wEOg48b17/+AFY5GycaBcllL2ZMiwBfXUW+ee4FoDYXKpSFOXMTYMEGQ5rFL0DNQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11312
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7a64667b-6256-4643-89e3-08de755082e1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|14060799003|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?X3joWBug1s9xWq9v/2MkGfYSFSlCOHEEG1Zqg7ATzjyF6w1kNwQkgGDcOH?=
 =?iso-8859-1?Q?W6Sod82o8iTXTaxmIk24aAwGL5beolJeEIrDH7+P0Wtc5m9Rrziq+qkBs6?=
 =?iso-8859-1?Q?uubNwMDt4YWtMVDlRymaKAplrh7/GMf2i6Us9dOZU/yqY6ERBAKc9aLAwn?=
 =?iso-8859-1?Q?bS3KwMJr+Q3eIvmCN+lAGhQ5EOZ1GkZR/nNB6z1/qpJNCTB2hFodXT17EM?=
 =?iso-8859-1?Q?taXJkzfXKAX9TwId8iH+E+rjTQDQ1ALZ8/IA80oXaLthgIU7R/6jDyL/Ue?=
 =?iso-8859-1?Q?F7BwqAyfoELvtFozDlwKpZ1WbkyWxxOlztdlvr6dVSNuxZ3QDoVefjP3qp?=
 =?iso-8859-1?Q?+3fmJhfDCV7TAOkiYj162Tusfwk+F0lgpisdPamhF3KwEj/Zb3zBRGgtSy?=
 =?iso-8859-1?Q?o+voZKY3RgIroSvHm77N2fwPI95Qke+BjZMPEritTChh8DSH8gFKb5TKNy?=
 =?iso-8859-1?Q?p/wS3nsmH9g4gyQs6gROOxqkGGnL2S9SaRukROl/GroFo/DfAYXkazuHWB?=
 =?iso-8859-1?Q?bcX7DksWD6BmyTcLtr9kQk0mAASRmRtHRgn6j7ylNAXyNsk0gSF3WPhrxG?=
 =?iso-8859-1?Q?qqfatU+nng14P6yhN6EkdTA3aE2YwShNXXS7nHs2hMQInlShmHjGwyI0a1?=
 =?iso-8859-1?Q?E/DHQf6skcSn0PouVtxkPO6jOAnRIAVS4rjZD0TZoYpifR0AWdi9kf6+pN?=
 =?iso-8859-1?Q?+hYn/otGIBH8jUr1zbsArS+8wd0eZ6QiJWS0bunMp3FDyFnjpDbwwHNTld?=
 =?iso-8859-1?Q?wmFUdUnPzRlJXqBIoH348bJnNaBVm0Q4BYPEmiONC21s0e3cL6hBnDo6oQ?=
 =?iso-8859-1?Q?Hhj9yHoeCpV+Kv/2dot3kDNz2MmMoZTC6oufHNCE9PPQIcRZyP8ozYm8xe?=
 =?iso-8859-1?Q?lgA38O7/G3SUNZsPoA+gDpzHz97N5oDoLvK5qhrUBmtTxViscUmYyY1FEF?=
 =?iso-8859-1?Q?tIVq1h3sOh5wrW4vdNv0H+wfPvaT3qVoVicDFKz2zrXJuQg9con7GDJxcx?=
 =?iso-8859-1?Q?/fsUGGOV8E/tSOdcwnqqTy9YSXn/xKOhzqewlfqSWZDmDWRzYUw/ATt+jJ?=
 =?iso-8859-1?Q?FehokhSc5qmNYz4iUruSl7FzE5abviYYMeO+mtfIjTFPzNuERj+bve6jSA?=
 =?iso-8859-1?Q?/Tu/1R4Pln+q2SwDAem15I+bIlqv8=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(14060799003)(376014)(35042699022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RZqiWhJew09iRLvmJ1Heaqed2ROt6ywjrKqHASZ3jAiDy+J7VK/UyHGQH/4d0PMg5eVyLqxTU+kyE6LwGmFBmhLaHvgPd2UFfacjqAVzhTkItx2OGdVirxSbWGtlrepoNL/W4B7eT3R7u2wfiK/4AyGTZqb/1EFbI7A2OlMyUO7lTHQdABgW4/Nu8Gyc5e0GCWH2V+58X5uqlG2efA1Iw/CGevXxBDgX80R9JJTd2FGEJngIyFsRnZ33QwSiicYCogr7583FYWlabpSOt3fuT9U2u35ynG89Pe8YKSI51Ccso55VYbNs6gcw+FT1qTBWSvsbmFSZVLnumhla9R1CjY8om/7lSAyXXWaGcjc2CQsM/cTSridHcCunu1NGONtKiJUIgwz+E9G3SwHbMAZL7jiL9i8+rHJ1eI+Ngt2tXj5AqHHYl0AAdFmrh4G7iOzt
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:04:00.9772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5124c9d3-a8e0-4e43-2fce-08de7550a814
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009524.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB7495
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
	TAGGED_FROM(0.00)[bounces-72049-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
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
X-Rspamd-Queue-Id: 983D21ABBB1
X-Rspamd-Action: no action

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 620126d1f0dce..bcafad6f08c11 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1554,6 +1554,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1

