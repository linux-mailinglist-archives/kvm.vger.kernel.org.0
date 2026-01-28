Return-Path: <kvm+bounces-69376-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAhdOMxPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69376-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:05:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52681A7708
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F928303CC10
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AFAA36EAA7;
	Wed, 28 Jan 2026 18:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yicp5A3K";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Yicp5A3K"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011053.outbound.protection.outlook.com [40.107.130.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADED12BEC2E
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623387; cv=fail; b=jDziFkADaYrjtrw1opVNKeHFkfL4Lw2/D6LthQ8g6QFqvu/ffBxx96XZrrnha7g1mbJ0D17PIPMhVNYlp89w6KGTOcHYG9+1bf4eZnMKPBOKuxCiKnBPMFj3d9oIo+XjPU7goiwhQKZlpFAUDgHCrk8z/5v690Kmvx4IixjU+Vw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623387; c=relaxed/simple;
	bh=HxLnOeExXSdZ0AWPxP2rZ3gXx37SEg92xnvoy7vWI+M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M8fwSB1GuDUatDDSBPCLxlnFKzt8wH67xuabKwdnY3+EpxsJjzeupd9vzeh8ShxE6+IyznfJTWuWFq7dxhRbu54OY0edYdcC050rIY/NEycx0McjX/oxvfl9KvfBj9DmWX+C8SZstHaNVOjyrThwqPNepPrz69VFkDJEAnaSu7E=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yicp5A3K; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Yicp5A3K; arc=fail smtp.client-ip=40.107.130.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=WOyR/hcc81zhgPnKyXj3jMpYIQTrFw/2lScEyxAAbZ0Y8dVzKydGeZhamxUCnYjPB3YUmMJFCrck3W04Ycun0BQUZ/xVBn6iXWarnvj47RWWhN87eeqr/k6Iit7sxAome+reECk/WGDZkTqYy2uDobOKCM6auOVipV+TAQ78eMYWt2NMHgx0qmhvNUoG5zjGGqgQoryiIGeiV898gNXA/e+XFElFFisJzgXNYTGf5ij6QwWy2b3atlSyaB8q6InJxokkv+6V9rLDTT/k5P2K9QUYooucb8ZP7M5t5lPtHMpKvar9B8RYPWdOvqyLnh00Ebt1IUaFmgy38vMUdumcnQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2j9K6TSglyYVVsDtOKOF3r9QmrXHewRUbUnhQkHVJag=;
 b=Jcx8qidkvtkQeDPhvq+Pbnq51sUmUbcOiMIDJA9WJvvWF9b418xdx7FxwTvu942HAomdwx0rU3mABoQHGWUuN7DtMsniFJe87V4HLcGZ5344BAOpfUlwKDCWpD9AXXtbARB9RkIL78PX8d6as9WSuB4fx8uy1DD9hcbd4RLT2K+KRMdnuenMdkuG0iWCufFCnW+PRUrErpVDELASsYk5zYKrY9J5TVKsuWPi4X7KeNiUfj67x18eK87qO9pTArECezoJTgN39T1Jg4VkBXbcfivKB3dH5QNV3zsAPx9kAwHNNzoF0kV9+hcBtIW17B8nRtRDAH8s96lLkjBb1I0toQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2j9K6TSglyYVVsDtOKOF3r9QmrXHewRUbUnhQkHVJag=;
 b=Yicp5A3KAA9GrINVFQTJ6I4T6lArj9gA1bAGJNLH8Ye9RlZ46mdXqKqzSTSA9n1ZtoDWorXUs8bgW2vcAODJxdnZ+KTgfso6m1e+vXE4Xvh9qWfg6ktUS29wmT1G1C1nkbSVmecqgQBab+7Ke2btAXmbKP131mQpvjgmutMmHMw=
Received: from DB3PR08CA0036.eurprd08.prod.outlook.com (2603:10a6:8::49) by
 DU4PR08MB11174.eurprd08.prod.outlook.com (2603:10a6:10:577::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 18:02:59 +0000
Received: from DU6PEPF0000A7DD.eurprd02.prod.outlook.com
 (2603:10a6:8:0:cafe::55) by DB3PR08CA0036.outlook.office365.com
 (2603:10a6:8::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:02:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DD.mail.protection.outlook.com (10.167.8.37) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Wed, 28 Jan 2026 18:02:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=thgK2yKYsPUxDB6IpD8jdbPr1m3zPAC7hYK6X/R2PaPDdgKIdhCgrIAcGlu3Gp0YsfHVHndK6K8zWyOTSPp5WE+hQwznHBCwbvWaqafTE+j30aoUDNMGyTsR7xhAOGSQPUWI7p96222C4FiTgb6IQiaGxCuza+xJf5lqi5fuFlEWtTYszCa7qSEfPeB7JqtbcR8PFQ0eo4qA0IMUiV5cAJnaI8bVjMIJeyS2sxDdQSHFIXbGZsFKIw+M8ykOcN1trAuIWNJVZbtW45yoN87uo0M6GD8XpIt3KH8xbWsL+1NxOvjxK+NOtwh2mcnTTjam/w4bH0M9QHkNgr8qFULOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2j9K6TSglyYVVsDtOKOF3r9QmrXHewRUbUnhQkHVJag=;
 b=GUqlucD87yOUxEH6LgbzWYu4iH3N71Gs/yFJn0X14VTSasPtQlVGcMhZZ9+zU/bbsMrOhTP0lK7AkC7JINpaeKt2XlwdQq3iq7NV8Vc7d60hJVAgXJergM8sSn+iBB8MM+Cccd5vEhTTR2aybteT7szJShH6XT3zVvH1bRKRyYqYyCGaj090HuRYjhT/J6a6gXpwuAI/2G2rsIEHHbU+MIYf4DkhapNqRUgP518M3AvlSSijnEvjtZSMk59R+66qMM5fRFhFunBFkeiHJVQvZ/3V843u5ZL79jqiVfHpteJTo7I0dLCAMZIqLPCAdEd0TydWF4sTHFfdBHp/nH2UBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2j9K6TSglyYVVsDtOKOF3r9QmrXHewRUbUnhQkHVJag=;
 b=Yicp5A3KAA9GrINVFQTJ6I4T6lArj9gA1bAGJNLH8Ye9RlZ46mdXqKqzSTSA9n1ZtoDWorXUs8bgW2vcAODJxdnZ+KTgfso6m1e+vXE4Xvh9qWfg6ktUS29wmT1G1C1nkbSVmecqgQBab+7Ke2btAXmbKP131mQpvjgmutMmHMw=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:01:54 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:01:54 +0000
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
Subject: [PATCH v4 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on boot
Thread-Topic: [PATCH v4 10/36] KVM: arm64: gic-v5: Detect implemented PPIs on
 boot
Thread-Index: AQHckIAvBjx53nWlSk2vj3nt/XdlPA==
Date: Wed, 28 Jan 2026 18:01:54 +0000
Message-ID: <20260128175919.3828384-11-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DU6PEPF0000A7DD:EE_|DU4PR08MB11174:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a638b9-e237-44f9-22b8-08de5e9778ff
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?DDcEEg61H4zfJ7+4g2pWt5kS97rJ2PZQBQTsmZnB5Tm5Gw9lI3fZA1tkWs?=
 =?iso-8859-1?Q?+04uGHjCSiM6i+nWOr0GYJt1yghmPyk5HOj6b9NB0Nb9yV3f9brCmvYe/L?=
 =?iso-8859-1?Q?4tefGKJGS3oa23w1+KAZgtK+8DgIKwtYjcBIJf+E52Rnl+FuU1FTMM3L4W?=
 =?iso-8859-1?Q?wcJ8l72QiZRQQuCBoOWKYXlpqxD8T8kMDGMmJWBqD5Y99wX8oCvyxNHdr3?=
 =?iso-8859-1?Q?WiMZjH3ZdlmigGcw0Et31sGF6Xz475ofYeYML46mdkim5khcn6+TJu/nsA?=
 =?iso-8859-1?Q?HvwOa3cra7kTzSvaC0G0s5cNMKfjJl4BQ+4X3gO7P+mkWm8nnYX5u8q9aq?=
 =?iso-8859-1?Q?M90Feg0IOqD5Jzm+LgsbULyWPz9IwHzuefaiTcYsRE5YK4IkfDbPE9C/uk?=
 =?iso-8859-1?Q?lnM3HTqpl53RoOwk7UwCeoIJ6HQBQMqcPRBEQr0TyD2pW8ATq60Jw4Uixe?=
 =?iso-8859-1?Q?uczrWful6Ug6PMFi2upbQWPOvPm+lWKya2NZwQl64rUPTLk6701i004rHq?=
 =?iso-8859-1?Q?zVLQPFfEVT+WqwyLK7YDpM6xJkeZlzfff0SOBIOy0HAYyRUoVRka0fuDZ7?=
 =?iso-8859-1?Q?suFRITtaSzSoE2+UmX2BUBu+tBsq2L8Xcoo18IX8/LgI1HZCh1ZYbp2tck?=
 =?iso-8859-1?Q?tVNbOYDB+BULRwMP3gbIJwZPliE5j2xYqfP2aPnd7iuCa6F7aKikaa19t+?=
 =?iso-8859-1?Q?rJN+ncp9qAQQFYXX820XM3o4viP+tT7WVm1C7++X88Kw3DIWS7HrdbfO/O?=
 =?iso-8859-1?Q?0Co90XkMcUw9lhqOoamKPbelErKaHsMA5vcRQDa7z3zsgQdm2o0g7iF/uK?=
 =?iso-8859-1?Q?ACsFpn2Hks4/xNYabqKQQh6JNd8sOMi+0qkWVkXrgzoAwTUuYA8m1fNOmD?=
 =?iso-8859-1?Q?BevDbJkCUU8uOLJBkexGilhRGl8d9j1SHU+L/diIcWvjy9I0tfYlIvmMWC?=
 =?iso-8859-1?Q?VLFI+c2L7+kuOPhGcY1ZfQkOOJPdnEu+Dim4pipFqNjb8LJ5f/ZQI5d6eR?=
 =?iso-8859-1?Q?QEBlqv2VIv5wBj7J4V+go8m6wHOzWH9hB+3O+Bf2ltetQDnx7lmw+lNqGV?=
 =?iso-8859-1?Q?EXkC3lkfLYJcuC0QAYWGhvTqFdMPY3hQtLzx2irn08PItBxPXaWiCOzAXc?=
 =?iso-8859-1?Q?gi5O9fE0oGkEV1iJ/ZUZX7uLfI2PM3Vw9mgo05Zr3TOvUz1IKKR4car2/7?=
 =?iso-8859-1?Q?h/v0JUpUK/LsgEsjG7MjI2i605pcVZlA+GZwfYYoq9Um0DdkmjQnL+JUPq?=
 =?iso-8859-1?Q?elsoDYIiX8Giow6EuoqYKZBiTtbrJ9I1pdV2KjfvrUw9kbhONG3YnJLFRC?=
 =?iso-8859-1?Q?MDt5KHLm5pcCEXHTD5ZUxN5Y3fj9g/5gK0PXbZkMlGAamckTUuYWmMKdQp?=
 =?iso-8859-1?Q?7iISLCYaSw15IlnVvLZfQyU2DAmYTP1Z2FCC+5kwmcmZhEoGz7YLDcfn1W?=
 =?iso-8859-1?Q?R7Xo/70Zz83dLqbEnuu3xw0qY/V7xmA2687XEIlMoqhWBBslHro8WayULq?=
 =?iso-8859-1?Q?8gLVmwgiDYauq9KyyM5NxbDTwFXXLN2yS8dX09eo6iQxd+psq1HkI7ycXq?=
 =?iso-8859-1?Q?F2q/lAog8GE4YOlty5Sy2aaKhq3RR8uMnqJUqniQCc52OJcynW04wuCnnk?=
 =?iso-8859-1?Q?XyvAAQvGfax7Q58/VRFL7vkZImbn0ERgWB2HTO4YwDb6u+EtSdLoVKKLnW?=
 =?iso-8859-1?Q?yfdUJtoFgJdVFPUlmhE=3D?=
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
 DU6PEPF0000A7DD.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1be6e304-3e5d-43c6-487d-08de5e97520c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?1HtvOEkqMdO97oiKq09ft9yqidVBCKaN/lhz5hIze2WDy23yWbMTGrk0SZ?=
 =?iso-8859-1?Q?4eNgA5Cjmtj4UOKjmjpMGdVKdAcoH+98vzpSd2wR6S6qC6QjLf1mm/6ljp?=
 =?iso-8859-1?Q?+KUB8krenRM1eEpgvr9ruwS/I/dGzq32R+6Y+zEwUkQBerDCDlN7SnXeuP?=
 =?iso-8859-1?Q?k61LG7ZTKXvgYoJLyCnz0pTy9tdUeYO6GrssWKwMxeOWowfsc4QRjswG2A?=
 =?iso-8859-1?Q?4WatsOUsDd0RVxkiK14o3xXQmNzVaBI4CI2jr9CwwlAf/Ddur3ArZE37CZ?=
 =?iso-8859-1?Q?YeRh2kmzB3XZDS64qeEcFtRiUawh9dVDrH9IDFhWX5xvDWgRDffHqSo8RB?=
 =?iso-8859-1?Q?AbUYyCZ7BYXn+n/AlX2h70eaveNspkIzzzgmh+Wm+RsavUxre9ujSoTUWs?=
 =?iso-8859-1?Q?LD1ZOUNV7CZzwKRaAL7d9NMYJI1giSv0SALAI1QLs7bqGZJBA85g2aS89e?=
 =?iso-8859-1?Q?dv7Jn6IlSBh3LL1HRhWJuar7rdrktWLy9fvrfgt+n6QnL+jT2snkIwFXmv?=
 =?iso-8859-1?Q?fU4bhzItCtWnuRrzqRjsD1L5dla0dZqtkJ+OsrRe2gkwpphzrOkjEKGh+C?=
 =?iso-8859-1?Q?zQnuaFhyFebJO7ujgMzHhngXQSX2Sh62AlmgzIfCac86U8meAUdYajvQop?=
 =?iso-8859-1?Q?VD/JahjKz/nJwFILfpRZq3kK7feZhlf5wM1Uy9cx5+XFUaOzORS5z9/400?=
 =?iso-8859-1?Q?NKo9eMnD5056v0x9ovKkqY7o+3xsZP7rTfDrxJxbeAdARtxO8cbd9Z53gA?=
 =?iso-8859-1?Q?ctI7jE89rXWJbRfrfR5Y920yBCBSJDqoca/z/Vr5SR+GNvLI5IZg4nSPGF?=
 =?iso-8859-1?Q?RGSVlYsz2DtilQlR78YjjNzrOUDcjlRy84PLQ308aQ2W34vZnMEJ1cgQNW?=
 =?iso-8859-1?Q?td54E+6WeRQQHMwxnywAHnSuVC2aJfzUdiixQ+PDM/8xnq50JzcxW4awAC?=
 =?iso-8859-1?Q?DNmVVR4KMgnHD7mMIqCQijIyH+YWTv6AiEo1cOOZF2McBDpeLLG8yK5GWY?=
 =?iso-8859-1?Q?7eNE1Whn81VNGhr4aNs5ciZ0YKlekWQZIwi/2rR8xUY+OvDN6rD53q1phj?=
 =?iso-8859-1?Q?CEcPtFSX+mP19bZ2tVQyI85Ykxw5V3ku+Y+hglQBzr1AQZOoPf406kb5IZ?=
 =?iso-8859-1?Q?5vJy4elqQe0JQyCZiglg4gGiFQk9ccqa/Nq87I+CRSMlnWFJ9huA1nKkOf?=
 =?iso-8859-1?Q?GzsJzifEW1KbLxCpjuNgJqs22jIGpILbeFYHX9c7HYWifchnR/eZ3cFW6v?=
 =?iso-8859-1?Q?hRhDqxPlpsBmO1HSpnT2AuDBjY0RVKiPXmAvfeiAuDK1uVHMzugRbO1CWj?=
 =?iso-8859-1?Q?NXbr9VF9Hg0uJwuRlQh/61FOLaVu/lPUps6U1x72uyBU8KR9N8oPnj0Dfi?=
 =?iso-8859-1?Q?wh9F9eoFeN7qTCMnVJOXoOZHgvr4puJ2g8Qt5Q7pEgkYxLLt57/mMXnWrr?=
 =?iso-8859-1?Q?2Klb1fj17Fem4zEDhQ+MPgfv1syqioY/dTNIl0tkHm+ewPMLM8x4DD8ZU4?=
 =?iso-8859-1?Q?ysfAfIJCCR9Mc2a1WN9x3+5VdDqCllfUz6Pxf7ZVDCq5sNrjvbRlcNxAjt?=
 =?iso-8859-1?Q?BnRuiEpB7u1paQcw/9GCsL5Zckw3SkF0fCYXInM6+wyxc2AXw0PKA/UMQL?=
 =?iso-8859-1?Q?J2sEV/UvAPvG6Z87vbR0vGW150eQJamRCr/Ltjm+EXlope1Q2YWUpCqhDA?=
 =?iso-8859-1?Q?ckq3yA1/w9H3ITddoQOCdCnw5ShhokHgq2MW4b36BSIhgC5e0YcT8dQOyu?=
 =?iso-8859-1?Q?0ZEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:02:59.5151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a638b9-e237-44f9-22b8-08de5e9778ff
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DD.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11174
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
	TAGGED_FROM(0.00)[bounces-69376-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid];
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
X-Rspamd-Queue-Id: 52681A7708
X-Rspamd-Action: no action

As part of booting the system and initialising KVM, create and
populate a mask of the implemented PPIs. This mask allows future PPI
operations (such as save/restore or state, or syncing back into the
shadow state) to only consider PPIs that are actually implemented on
the host.

The set of implemented virtual PPIs matches the set of implemented
physical PPIs for a GICv5 host. Therefore, this mask represents all
PPIs that could ever by used by a GICv5-based guest on a specific
host.

Only architected PPIs are currently supported in KVM with
GICv5. Moreover, as KVM only supports a subset of all possible PPIS
(Timers, PMU, GICv5 SW_PPI) the PPI mask only includes these PPIs, if
present. The timers are always assumed to be present; if we have KVM
we have EL2, which means that we have the EL1 & EL2 Timer PPIs. If we
have a PMU (v3), then the PMUIRQ is present. The GICv5 SW_PPI is
always assumed to be present.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++++
 arch/arm64/kvm/vgic/vgic-v5.c      | 33 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h         |  1 +
 include/kvm/arm_vgic.h             |  5 +++++
 include/linux/irqchip/arm-gic-v5.h | 10 +++++++++
 5 files changed, 53 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 86c149537493..653364299154 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -750,5 +750,9 @@ int kvm_vgic_hyp_init(void)
 	}
=20
 	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
+
+	/* Always safe to call */
+	vgic_v5_get_implemented_ppis();
+
 	return 0;
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 23d0a495d855..9bd5a85ba203 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -8,6 +8,8 @@
=20
 #include "vgic.h"
=20
+static struct vgic_v5_ppi_caps *ppi_caps;
+
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
  * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
@@ -53,3 +55,34 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+/*
+ * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
+ * ones are, and generate a mask.
+ */
+void vgic_v5_get_implemented_ppis(void)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	/* Never freed again */
+	ppi_caps =3D kzalloc(sizeof(*ppi_caps), GFP_KERNEL);
+	if (!ppi_caps)
+		return;
+
+	/*
+	 * If we have KVM, we have EL2, which means that we have support for the
+	 * EL1 and EL2 P & V timers.
+	 */
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTHP);
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTV);
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTHV);
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_CNTP);
+
+	/* The SW_PPI should be available */
+	ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_SW_PPI);
+
+	/* The PMUIRQ is available if we have the PMU */
+	if (system_supports_pmuv3())
+		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5f0fc96b4dc2..15f6afe6b75e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -362,6 +362,7 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_get_implemented_ppis(void);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 67dac9bcc7b0..8529fcbbfd49 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -414,6 +414,11 @@ struct vgic_v3_cpu_if {
 	unsigned int used_lrs;
 };
=20
+/* What PPI capabilities does a GICv5 host have */
+struct vgic_v5_ppi_caps {
+	u64	impl_ppi_mask[2];
+};
+
 struct vgic_cpu {
 	/* CPU vif control registers for world switch */
 	union {
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 68ddcdb1cec5..d0103046ceb5 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -24,6 +24,16 @@
 #define GICV5_HWIRQ_TYPE_LPI		UL(0x2)
 #define GICV5_HWIRQ_TYPE_SPI		UL(0x3)
=20
+/*
+ * Architected PPIs
+ */
+#define GICV5_ARCH_PPI_SW_PPI		0x3
+#define GICV5_ARCH_PPI_PMUIRQ		0x17
+#define GICV5_ARCH_PPI_CNTHP		0x1a
+#define GICV5_ARCH_PPI_CNTV		0x1b
+#define GICV5_ARCH_PPI_CNTHV		0x1c
+#define GICV5_ARCH_PPI_CNTP		0x1e
+
 /*
  * Tables attributes
  */
--=20
2.34.1

