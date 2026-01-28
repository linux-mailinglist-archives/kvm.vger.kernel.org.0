Return-Path: <kvm+bounces-69371-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MEHqEoBPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69371-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:03:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8DFDA76DC
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 69DD8304F343
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF7836F425;
	Wed, 28 Jan 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EIOvkbaz";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EIOvkbaz"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012005.outbound.protection.outlook.com [52.101.66.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BD736C590
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623306; cv=fail; b=sfwS3FFmesER3Th8rAuppcsbM3Huz4vqiyaJ3pDEklIKG/+NKXfNrL5jz9F59VGf0WnRsSV77O6YE3PoFx8LmJhRKjg6dPP5d/wSg2SwFaZTl5S3H/0sD8/mvZduqaVwG5ZlcQWsacpgeXKRWaPsNSQUw1FqdDaW5A7RzGKayDA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623306; c=relaxed/simple;
	bh=k2CJlf3a4cqyhCzzgq4eIymnY7NlEysZzQMzxxdf95s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EHZzmVomwhvHNdmiCS3D/AV35PKEdyyIGUb/TMCJ+IdJH1stBbFrR0FA9p8gscDG0Gqztcm7DVKneRVBWTICOSi2ovUezGBM7dVa5CvmWhu4VkbtfG3aEguIJRZILDf/8KtxLTZBJO3iT8grOV72DDAGhjYKLr08YaXvNeifLrQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EIOvkbaz; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EIOvkbaz; arc=fail smtp.client-ip=52.101.66.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=aSFoYbs2bdeSKCcLM+YXCSbN9EXnTPmH4uCIhnc/IkL0Wap5zeBkGdZmbxfrdxrovBTN29BA9rfFAEdltHuvceZg0M7B1Iq1dadSmATwVQXZDf/NP6rlE0TP8pB8dN+sR/H/St3tKkp90tYBP/e0lNIJHnnQl+X+1E5W9QnERqDDfhVdPs+bDkQqEBeVAl88QtQOzanwAwTLbCONpcyayKBRyB0PMwnvBZNJZVnQ7n/431okdpmq0ap2mcIhWA2XjU13mOozRfE98wt0zGTGPtjrTHEIKqeqPIZsjFLSe0uV5/QSZ+djG1fwGHaY5f0wvOFGqYXQL8BNOY4zhQm02Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1rxtWW/SMDDKppqjVnqyD7p0A5S30WPLwBCbr2KvmI=;
 b=coCUPkmhLCGWN7fcyYntnF0V9Wk8CApa9+OCXM8is4X1kaWUIcJmapsPKw3/GKOIvC77DVfbM26PMvb70hxOQvF8YCairE+pV7kJyg27461XU+wASutTO0p1QuApkmYsESIl3oQkm6xVnlQYBlXEtgyxzXGTb8WxV6ZS82DdTMiT2mf++hsyhJIEB542rqqx+7eF3g1ilJZzS0eTt/j+BZ7e3qILs+TsDbJ2vQv3nL+w2C2LQgjVgAT+GAIaJEBKGog+Mhw13cv85rwmkn4npxUIB7pd+0GT+m9NMagoe42V1VaV+0BZ47DT2kZq0JrBvbOBXbdeHqGl/2IacspAag==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1rxtWW/SMDDKppqjVnqyD7p0A5S30WPLwBCbr2KvmI=;
 b=EIOvkbazqDfyiVfmM4S27vQ1fdCnws0GSz2Fk/AuFikpYY5gzpMCl3RSP8BECx9UAMBt1Ob4fYQZHoVfHrus4Gxiovp2D0EtrT+XGJpqTTvlStgGd979sL+nLGurn4rAyEc7ixPaaDXgYDqbClb9aqmTcit5GUdHlPuuN5pNzoM=
Received: from AS9PR0301CA0032.eurprd03.prod.outlook.com
 (2603:10a6:20b:469::30) by VE1PR08MB5808.eurprd08.prod.outlook.com
 (2603:10a6:800:1a1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:01:40 +0000
Received: from AM2PEPF0001C70C.eurprd05.prod.outlook.com
 (2603:10a6:20b:469:cafe::94) by AS9PR0301CA0032.outlook.office365.com
 (2603:10a6:20b:469::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:01:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70C.mail.protection.outlook.com (10.167.16.200) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QtK63Udpfj3AR8mwsFLJhXuwQeGF8u9jaiRDgTgG1/e7akaifAAR/eveECH6hxs4sajVubcPc6mMjAy6KhwnjNoimbUKVkdB4ExJRZhSs6PcyJyz0kbCg78DjnKpmYUHNBDoc38J1ofZSBmBo0hLstjQ0i/GQ1nJHpZRrA1sbqxiekcnkJ6qcU/2+3gSgehE9FSUTJE+s7IK4JDLwIRVoR3lEqpkQoqDPwIyfyIxMGT8HkoER06h4GxTKTlXdq2nd/lzzQI2BUHw7EKBWn99aw6tiQv/oE6/Z3MKQbify+YC6Rehgu1IX9qexflrJ64MkCCdV6Qci/2Ah6wEbwj6LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1rxtWW/SMDDKppqjVnqyD7p0A5S30WPLwBCbr2KvmI=;
 b=Ej1H5QEwsIu8mrTVr4i1Qk9NdTCMoOON3t3U44LQ0121RnnWr0ODERDa/SnpQBzweYlmpZUyndGCnOh0zTRByhnMLcw888tD/8nl1Tc697MJMlKTK3Eyz+/UIQRCGbpSocs9pw/rpNTCVsH8fU2iQGvkAE7yvXlHBVXE9zu1pf3fIrfLs/YrlfQmK6vk++EbZorQQwt98RiV9HHQPh53hW6nredNYOLJeDGeQJVsveta49WwMldFbnNbT+V1uCb+mWRP8ucdxsKxgq07rpkeTQd08eRtdyQqUcLX0SEW4J29/BU+3Ri4lo4d6hi+KFbKLAfwXs2rhmBGsDsttalRqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1rxtWW/SMDDKppqjVnqyD7p0A5S30WPLwBCbr2KvmI=;
 b=EIOvkbazqDfyiVfmM4S27vQ1fdCnws0GSz2Fk/AuFikpYY5gzpMCl3RSP8BECx9UAMBt1Ob4fYQZHoVfHrus4Gxiovp2D0EtrT+XGJpqTTvlStgGd979sL+nLGurn4rAyEc7ixPaaDXgYDqbClb9aqmTcit5GUdHlPuuN5pNzoM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:00:37 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:00:37 +0000
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
Subject: [PATCH v4 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH v4 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHckIAB3JGf16rszEyuMrrg22N47A==
Date: Wed, 28 Jan 2026 18:00:36 +0000
Message-ID: <20260128175919.3828384-6-sascha.bischoff@arm.com>
References: <20260128175919.3828384-1-sascha.bischoff@arm.com>
In-Reply-To: <20260128175919.3828384-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|AM2PEPF0001C70C:EE_|VE1PR08MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 593f7cb2-2660-41bd-895a-08de5e974986
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?szoFPv81IKyf5yJ1Np5o2wMqxm5FHllmPP6DImD41MV/KnwBRo3K7XGvyz?=
 =?iso-8859-1?Q?1YcuXWTKLEUUeSnoJXgzbQggfHuSIWKd+VmOdnMU+6DFkdrZdva+P4m4i6?=
 =?iso-8859-1?Q?Zwj54PwQBMbSUrxaMUKvp0JfigVNDkkdyEntk7qXqOtZXabt8x8YtasCIe?=
 =?iso-8859-1?Q?Hj1BLD0a6Kocd72Jue86D5QfiimlZHydIjZNdW3rKkigcdfgr+fjASI1va?=
 =?iso-8859-1?Q?4fMKIAC4efWYYklI8U5KBLH1uz7mJ1PDExZxg1pnMN7bCk2eOpuPN5FRyI?=
 =?iso-8859-1?Q?5ysOhKH08CMpxxVlJUuo8pbMvq7UhvG5nTxa0IEhfGUlkSF51XC7FHEjGE?=
 =?iso-8859-1?Q?PKIgaesBvUc22E8Qj2dmX5u/HywMUGLcdSqdohvJmIXsNRtHaokYrY1/zi?=
 =?iso-8859-1?Q?Qh4FN6qwD0l3z8lkd8cfvbN2fcBFZX3guTLppuaUfuLpwEUyzAszkrbt1+?=
 =?iso-8859-1?Q?bWTqlFSX2ZwyKn/CrVNGGzPtU7/sgDu1wopmaE7bzEYYc//YltWaQo82fR?=
 =?iso-8859-1?Q?7wS2ijxzmn8UmIiUN8VqDhQ0vFqdNqeRImq3xcwz4BcshknmO1STDTSzHG?=
 =?iso-8859-1?Q?yAFllE20rmAGHgN9ORlhdzgfarA5HNRoJApxzRyNHEejOp2Smfai5PjkRn?=
 =?iso-8859-1?Q?55MEPFqTy+7bSJ+oS6xbVRzJPQX2ehlRsE+JGH2Lj7a11gLxG13KFxhxoY?=
 =?iso-8859-1?Q?Vxk89gFB43ECb/4FRN28+IzSV4gTWunsTktXRUHFS/yrDp3+aKL8HeMYxU?=
 =?iso-8859-1?Q?bZtXIbw/MgbvzvB+vPk2HpDjQ9r4meumpKuu9kADNiXBHYT2GJoY/xakHy?=
 =?iso-8859-1?Q?iAKaEMyL+RjTkZTIF6tgOHWNGZQW0juLMDT47OSgkgD7+htBgKzrPrXkHW?=
 =?iso-8859-1?Q?BvDDcRCbmJjY5cpvq0dvqrKC5vg0/KeToRJpLiiBHH0ilgVdYrb35ZvQAp?=
 =?iso-8859-1?Q?ouM57sIuRSKUIkkV6vBCxRoiIzpdOT1/TWL6d8+LTW2Q0gpPS8hGI1HKKH?=
 =?iso-8859-1?Q?2jO4gk5qlo5hK1y3XYRnastkc8mx6hVkrApFLabr/ct5M4gRDuhb2EKxBT?=
 =?iso-8859-1?Q?UqBxNAuvP788DLvn1tWGpAzwQIYj52z0ry9OVDPfXAVJy8KVuoOVrholbY?=
 =?iso-8859-1?Q?fM7ulBLJJkLp91mjq7Cc0cvg4epyZXso2E9MygedZs4hHA57oRXdzgzVa1?=
 =?iso-8859-1?Q?O/0sSueCDHoc07odrkzEl6F/nlsArEjfz5rKDHtXZBhExmebp5syQPfGCb?=
 =?iso-8859-1?Q?E8wY+TJl6FTl2K/0AflVQ0s7Op1JqxsxB+45ia4vgMykBbmMV5Pq9VcVvW?=
 =?iso-8859-1?Q?U+4lSGk+WSkwWI5c8Mqq1sxoAR2w0Rd/dFs6zJ0BvXObTQqDzjhm9t9SRL?=
 =?iso-8859-1?Q?PfS5BVCKO3PqTc2vCGfCeg1coDMcI8ro5FV9rWmBA5AqT1dpSyoAsDkCAi?=
 =?iso-8859-1?Q?UOTURXB8HlNvypzerQqaC5siwJ/S+D0RD8HTEqemyNoXo3jzIOSsfv0Z5f?=
 =?iso-8859-1?Q?EY7Onx7H40Ot1qnqOCPCPyQnM3Z9lnuvFzMIJ4EHVyONFmBS3M+zP7vYIK?=
 =?iso-8859-1?Q?/guwbEQqnOQUSnXpBlNFXkF/e/UFn2aPLLLLrVY/gnAY8/ZfTF5Xf9LKYY?=
 =?iso-8859-1?Q?uQmhaFS167gxd0UM4YhXNSYEolYUI7pevyd+VDzJfd9n0R8kL22MfMoyVN?=
 =?iso-8859-1?Q?HfzAD886coBpd1KSlAY=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10537
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70C.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	78d003ed-d3d7-44bb-790c-08de5e9723fb
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?CXT0kCh/kSPmw7S2lPsxb9k1zz8fjy4yXyi+emXKbceBQWf6/8q1cuZ3iO?=
 =?iso-8859-1?Q?q8kl4/tqXHXrlh6G9tPICzffin7PNed8s58+PlarI5zqWW7Gs4g5jfzNU2?=
 =?iso-8859-1?Q?KPxynjmWy1InLE7QcGrKYY0rGsaNoQdHTLmaNoBnOlMEq6YSjt+AoIC67u?=
 =?iso-8859-1?Q?qI9hfE6unHDYGNq/Yuy0ejp154PoD17luwFwiHftBKrkTpXrIujX+uakAO?=
 =?iso-8859-1?Q?WrIfUsPwAUj8wJWKgIDI7OO+3uucM1pZy+HnTAJ2yJQUFmwshZy2w9e+VH?=
 =?iso-8859-1?Q?2m8l4e6yAcDDmOZGysA8FIRwL6y+a4n5Ygo2r6JvpcMND7xvoGb9lWUhPl?=
 =?iso-8859-1?Q?896mYsWr1Dk2t8DMfOMlEQunSLFxDW1YmGGLIHeKa9nJBTS4Lkl32Xffjf?=
 =?iso-8859-1?Q?AVF/2s+T15qQS1wgXh4f7klpdkNxHa/eDdlt+Q2nNGfGfUk3B4IDWQyb74?=
 =?iso-8859-1?Q?8NxnXPvsaYypjuPWRaLcLQH782LpjAaBBX/kY8JLxnjOwhXW3qMOMXI41C?=
 =?iso-8859-1?Q?oOtqpitV8VgVa5b8RVJMIOOJse3M5KRePfJUMv4uxjr8O++wRMMg1E+J/Q?=
 =?iso-8859-1?Q?KvqlrBQmh+Nq1Z80OxNwiYC6DPu0Lb/8By2pfQmdnhZdHhSExve89qdEpl?=
 =?iso-8859-1?Q?9ztg0gnKrx2vDfY+4kqCY/Imx3TL0zUqoX4HHEK6bEaA+cQbbAKycARlGo?=
 =?iso-8859-1?Q?Ja94DTe6FBrvBTWFgg0RQOoR/NvNnTXvozJd7PpgUIf5xcQzU0dauGQRWy?=
 =?iso-8859-1?Q?QHzFvXoToqyQ9z0yZhzx8DbUxxkEktVXpBmB2OzE1Pp62ooWxZsTWZeLOa?=
 =?iso-8859-1?Q?76pWZPAvjwlu6pikKpGrdernfbQMJqsQ0zRk6Jb9Nb3joYdCYFsijaGQel?=
 =?iso-8859-1?Q?CBgfJLYzVFVuRNHRoCMZOdRxkYpmHkW2urARvpvCdb4xKXfCSyoKluk3bt?=
 =?iso-8859-1?Q?yK2Eeadodort7HG3tbpaD6gA5bL2iYQSFIqPxLxK9gFeoyuVMzODNxaPZV?=
 =?iso-8859-1?Q?GrnvnKksAV+xWzsqMqv6DZPtIZAXgmDcfpkaSFcmYi7DOjmXIhk9IoJTyV?=
 =?iso-8859-1?Q?WjVpUeHdW4H2AqyqYtGaZ4TWD8RBPgyzPAFr1e6tvngnmuaWyZf2LCIuwy?=
 =?iso-8859-1?Q?z/Tx6HNle/EsVIZnqzHj/ie85PGc3YDheuM5f+z0zDopFqOAC5eBcoQ9es?=
 =?iso-8859-1?Q?AcqMcEDIu8ltiE9gITCZHvzpAdiNSPzsnhS7Bt1X5CBVQUDdUt+iouhEC6?=
 =?iso-8859-1?Q?ZorwmEr+JnIm2/d4Dqwr2ziOqVhBly+kTEs4wyYXVJ+nZKSx8gkeCpVF0p?=
 =?iso-8859-1?Q?5sTHKxCKUPxL8mBRcfe8O937PYMMjvfKgJuUkT6t0G8Z0hUew4635nE6Kj?=
 =?iso-8859-1?Q?noS1w3qtbtccriTG1Fitcn4jZCP2aaTO34AJAhnBK0MHt8KNGkyl4lhaAT?=
 =?iso-8859-1?Q?UhC3e20BXgASH3Ki6NmHsfELm4TzTUmmBYE8MzyR7UknN10/HK4El0Kgyl?=
 =?iso-8859-1?Q?9JeICM8ocMk/InwP6Y9WJkrY/ODcI2Ot3Po6cBPsb+yYenCa1DKI/EpbX3?=
 =?iso-8859-1?Q?Nq+MtyJRWGQh7jyNrTbmZDCMzSdxojqWPsutBdFX01bYY5aZoWC1i0zT2L?=
 =?iso-8859-1?Q?JnHpniKx+XMU63KRujP+3LpIu1NeZKS/5HvWXBLCJDpELAxY85+s+Ldt12?=
 =?iso-8859-1?Q?dzdy7OYKG7tml3pl7+US2rgWSbN84voawfPtsKZLH/GQEirr88R91Wyc+0?=
 =?iso-8859-1?Q?StLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:01:39.8610
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 593f7cb2-2660-41bd-895a-08de5e974986
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70C.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5808
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
	TAGGED_FROM(0.00)[bounces-69371-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email,arm.com:email,arm.com:dkim,arm.com:mid];
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
X-Rspamd-Queue-Id: C8DFDA76DC
X-Rspamd-Action: no action

The encoding for the GICR CDNMIA system instruction is thus far unused
(and shall remain unused for the time being). However, in order to
plumb the FGTs into KVM correctly, KVM needs to be made aware of the
encoding of this system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index c547a14bb6aa..0d05a8b882a4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1060,6 +1060,7 @@
 #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
 #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
 #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
=20
 /* Definitions for GIC CDAFF */
 #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
@@ -1106,6 +1107,12 @@
 #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
=20
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1

