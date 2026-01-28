Return-Path: <kvm+bounces-69387-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFZ3E21Qemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69387-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:07:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 361CFA77B2
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 85297301D4E4
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141DB37105A;
	Wed, 28 Jan 2026 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IETEkDYV";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IETEkDYV"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013034.outbound.protection.outlook.com [52.101.72.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA6A371074
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.34
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623557; cv=fail; b=GyENo+KiwVA8Kui1BKZoaeRtCqZYD3o7gKpbsb7nU6AYqWK/ds/oRMSArBLd9RKw1EYYezKNRB2q/teq+mGoNLh8jmDSH4T6chZ0npiNi4f4M3bbXjLpZxDeuHlAJ+5vzau3EmUdxsrlPNJj5f4Sr1B3k08/Ni8AKJI5yDn7TMQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623557; c=relaxed/simple;
	bh=53uN0VUSg7x+5ouRKXaYupeOAGPveTcWv9qoT9GaLGQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rWmJMd6Gd8/VpXjTeVEhM9YKI90Fb29/k1BpvaXyxC4tw4DUrToP/VFikje5jE+1mOfXgRZNQAUp1d7sE5/Ho8kTFGMYnUyeFT9vhLO/08SCpiniJKyyh70nRTV7HUHMzYOo4h2BTPTT6u+e5FcZKpfK0utLGzZXvUnYsD+9oQM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IETEkDYV; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IETEkDYV; arc=fail smtp.client-ip=52.101.72.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qvMPeHBpKsbaBcTlgUJUG+bw7Jei0eKonnpPBSw7P2K6fwjFb7lzEI4AoSxnt1o0fKlGcFHn8v5y78GoLLPD60XktnmbeTitAWGRi4N3Ww5iMWF2beOrrVDQmPECjB+j/39uJfaEGC3ObZCHjvrncvlqx82rk2GB0hwg2y9suti2YiPwRqIWBfzR2bYWr13Gxsf2tQB1aaJaVQ1WEv/5yVq2B3BSl7t8KU7//hZCpLPy8mJySbMu2Xl05ZYNqhGdqfniQE/GS991W6gWKfguai6/B8rUSDybHc0wOv+LcqoW4JWEcoRsi7LPAEI6Ahu661gkbnvQ+nTQOJ2S2ltaZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1lNZwE896mTfZmukm/hW59sx2lf8bcRLGEQaxYj9HA=;
 b=w12cn0Kab7V5w1+FtaJzwA+RlhbcpTCt5KmE7nnP4YD1jy4ZJaKeWtixIQVHaZR7y0Yx6sAa8h7z/bkzEvRcJK1voKRgBZSBcatdxapCEsIvsFMM39Kml1u7CQMYqdHdJOICLRocxgPYaYEnT3pmCg6wLHabWR1hKt18ZVfwVvP/e8dI1knLPhuGPifRyjZVvEtnO3dpM4fAjxrT+nQYyz1oBBuzXn7Rud15VaWr6E4c5lQgdz+m75keSPZdZVM/EiHmIAgi8ADcLHdMNz2vENJ5j4tXN/sf1jYxufkHPWygwvOlPP34YDOvHtlkoOZolZYWaoLU5/8pnrmkSZS7RQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1lNZwE896mTfZmukm/hW59sx2lf8bcRLGEQaxYj9HA=;
 b=IETEkDYVgijZPDaAYGZqB0yPd9t7iarAyvUQyAMZ937WMEvFEQRIZWI0q0xO/jo6HFcReubeE+YeVqFVu/UWCy9rYqQFJ9rmD3CWVk3g9K4t6lrj/MYk7deGdIpIErscG15bpsQoVZITtdzyoka5B8+J77XqvlXmhM5lY0SQs2A=
Received: from AS4P250CA0014.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:5df::17)
 by AS2PR08MB10082.eurprd08.prod.outlook.com (2603:10a6:20b:62f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:05:49 +0000
Received: from AMS0EPF00000199.eurprd05.prod.outlook.com
 (2603:10a6:20b:5df:cafe::b9) by AS4P250CA0014.outlook.office365.com
 (2603:10a6:20b:5df::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:05:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000199.mail.protection.outlook.com (10.167.16.245) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:05:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wdcme1uHQpFzzxdwFuYHPFnorhiAYij1o/ZeM7bYZ/KuSYENoLCDYYk80oaiCm1qkCj+1LxprISmmxu92WcAn5uRp5T0LW18ZVBGGnvP3gijfdJoARRA2T0eBrrPToeD/fhFAtC8JCgTi81Q8YQgMAMbhT9N4VzwVNnq+oeCIjHhpZhZLC3bw6XqiMPyqGUKFNHbsuUXXudA/TJNwjFMa3085jUav42Afy+vwbARIWWoXBsf0pRoIw5/XJeMcg+kYkNh2rojK92mGK2chZsOTKNW4rZUk4ZX45vmP2ddxjV9N6mXLXYfXAKcidcBKFxH7u5C6+uBYLy74muMpHwcfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1lNZwE896mTfZmukm/hW59sx2lf8bcRLGEQaxYj9HA=;
 b=Q6SNs6sdAOiCAWW6H38h3sEYFTPp0pQVgk6NMvxpqH+TU2FtuN2yac57z0zWyAcNyBOiLYDV8tir6fXbzUbHxFKH/enfdQbtNJs288ylMl1JcAoTuYjGmijjAFsVEdyYdkXoRD2SK5UL2qfRP0om8VKFeB5eeTxOqm/EhsfyAIeTfMTXY2k0eoHRjMauvrKtgxC/RSvhNARrJKn5CNGEnQZwnsxuhTbxCW/p2rW8bIVRdRjpl+ErnQ6Yd30BHE74wt3BKdXKdZUABK9vHgebW9jrVHozF1PDBRb7oBJAuqO7iTWsdZ1nE9h03w22YG3HMc3C8z61l89GT6sj8dnpbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1lNZwE896mTfZmukm/hW59sx2lf8bcRLGEQaxYj9HA=;
 b=IETEkDYVgijZPDaAYGZqB0yPd9t7iarAyvUQyAMZ937WMEvFEQRIZWI0q0xO/jo6HFcReubeE+YeVqFVu/UWCy9rYqQFJ9rmD3CWVk3g9K4t6lrj/MYk7deGdIpIErscG15bpsQoVZITtdzyoka5B8+J77XqvlXmhM5lY0SQs2A=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:04:44 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:04:44 +0000
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
Subject: [PATCH v4 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Topic: [PATCH v4 21/36] KVM: arm64: gic-v5: Check for pending PPIs
Thread-Index: AQHckICUTSgUg/z8EkiTx7ZKLhsQwg==
Date: Wed, 28 Jan 2026 18:04:43 +0000
Message-ID: <20260128175919.3828384-22-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|AMS0EPF00000199:EE_|AS2PR08MB10082:EE_
X-MS-Office365-Filtering-Correlation-Id: 75d3065b-9f55-4137-5c67-08de5e97dd33
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?2QVOgQkNYXYe0+Ld17f13UI07m7HYPq5SMzWxthhTuI/LKPrNhS5Po1lUo?=
 =?iso-8859-1?Q?Dmah7tX5+60i9fs615yRtgSPgPlQ9eeWqVpBOA+TQ95LDohUvH5TNgOKME?=
 =?iso-8859-1?Q?5wmrVV+V5/bszYH/bJ3BKkXSb2f1Zp0zQCrH/jYKT1kdF6hBYQgWgrKCIi?=
 =?iso-8859-1?Q?dhiyfv/OOynVs1oLeyMhdZ+I9WSoR/0Ro568/+8q3ju9uKsceBdxFkU0f2?=
 =?iso-8859-1?Q?PC5KfGJYsucZKiwb/cWl0WhaXhoGwQ+funwkkfFOjCAUVBA3mBVO2x4BQ6?=
 =?iso-8859-1?Q?yGZCdXMTOqAikpP72wYKMD84vNtuhyduQv+3ELq9sdlwyZGebCH5Vc5o4u?=
 =?iso-8859-1?Q?T6T6pYwdbc3mDoF71+jb8bTWZb/71gBl8rO9rBL3zwVUzvDItZ+H08hLDz?=
 =?iso-8859-1?Q?87T+Luo2FSKSSHTVGjKRzW8ct0J9a8UdUaqtmAQ6Ec6akmpIAMNpZLcNIJ?=
 =?iso-8859-1?Q?FlX7RTNd/4xOVf/i1pg3I5t+YVzs8TV1q/ndmCrr5Wb0SzjbsvAvJ+grYy?=
 =?iso-8859-1?Q?tEAFzw7tmQnYsMUiI2DgfV2zB5s8u7rXTQ0U1F73jY8BnnF9nocKZ39jQo?=
 =?iso-8859-1?Q?jGeeaqT2uyK3CzX69q2biatNPb1d8+H0dHuCT4mdIHMVf0yWMLdRoQq1Vr?=
 =?iso-8859-1?Q?dqUh5MXNdCxdZ3v0SCgj2rLWPmXLzEqkkPq4+8afBcAZZzJIfQZQdNS8Ig?=
 =?iso-8859-1?Q?MYQTa2Z6R7Y4pLHbHa71sMJHkQuN63mjAjlbclPrFZyEWz+jXfKknUfSeQ?=
 =?iso-8859-1?Q?pmkVWIgs+lTzlXLeL7dVkcEqeuxZJMThyBTxhLz9z6U+U4A7RRDV4KyuH7?=
 =?iso-8859-1?Q?zdB9HwucA1DADUVfCctlN33UIZu6e6AkMx0nENncPNnYF4JEvvf3MfqYgd?=
 =?iso-8859-1?Q?+fmWuM0jRC3DKoIAWCs12KHGLuBYO9GxQPeKVEpD/fR15+I6c1TgY2Qr+P?=
 =?iso-8859-1?Q?MpLTRy3A7WS3Mta+d4haehqKJU6Y0OIXXW1ysJLCcXt4y2KskIDWrWo/OZ?=
 =?iso-8859-1?Q?+MvArQSS7cS2r+x5T42Djqmvarg/Wobtns/DeNWQLokFTkf0W4Zq4FOl4Y?=
 =?iso-8859-1?Q?+i3LRTk5ivgnu0El27L9TQz0BLuvaVwPb7OkPz/xdlUOo24B3zUb40HpHK?=
 =?iso-8859-1?Q?fQfudUVh9HAkzz2oESKNVK5CbeLL/DBvs9wmCIJaRHNEyabBCI9MUZUQGH?=
 =?iso-8859-1?Q?sPV9h+3KC7LWAr5ilYAExllvruQSmXjDHNl2hqs2nTsFzWXqR/1qpcCJqI?=
 =?iso-8859-1?Q?O4+STdLCW9VkOOjeUZDtdOpGh88zY4TKaysvSJoeRZzzPOZn3Uvy4QPSyQ?=
 =?iso-8859-1?Q?5E9BRmjFtOOGGw9gLKcB0wLncknCh+3rFiXYRKiLwbOTcEvTJEP1OaKGof?=
 =?iso-8859-1?Q?bbRKtMYBv79RO86bj3335KFguGI4KWTZuomC4S2YmtmM4nSuYshdz5Pwqy?=
 =?iso-8859-1?Q?jeSIp8U75kS3Hr97fbokUrVi/fo1g7UAt3ja/j3uDmlpu64vGFyryYPOSL?=
 =?iso-8859-1?Q?9NUwwnVaPJujxhpSRIgnmIa/hrp/RHNIP7paMzF952sFe3UIDSkULyP2OU?=
 =?iso-8859-1?Q?4pBrBYAEAIQ/rlsTid15Bn0fL0WRZH8pKggBBqx7KuitDnc/Q0qXBdZ+R5?=
 =?iso-8859-1?Q?hmJVbiBoHQXQOde4VANcdawYzHrd95u1Q6AroL5xDvUxn/19hQlcSooyBt?=
 =?iso-8859-1?Q?d4hOPaZR/I8abx1Ixdo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000199.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3c33edda-e942-45a7-fe58-08de5e97b735
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?g5pSOHy0Mb1hBw4iuRMeKXtfo5STj0UVorCfvr901FPZJk1yxg0YbPqrDf?=
 =?iso-8859-1?Q?JrY6XYwQTyOpDVKNHXLpp+mTjII2I0gZffkdt6vUaCghJUVD4hHiiP0teE?=
 =?iso-8859-1?Q?sbZG2IbNuwFFhMvCI9B1LBdH5IGk50pl0eRrJiOZxjuY8+0/NXzUgAAuVg?=
 =?iso-8859-1?Q?BXyrWSUxCZwlqmd2gE1IeiLwF2Z8Oo3P0LhSwN9QsggZ7Vw/Ll1AjATz8G?=
 =?iso-8859-1?Q?zixLMx/PWkg9+9sNRj9Dm9vcdtSn8cV4GYSWpnW2E3YK/tgKoxW78YIDMD?=
 =?iso-8859-1?Q?ZjJH6KUBJOrFo5itJLO13AJ0DJND6VSQio+1ek+gesMzU8aqCITUr3H9CQ?=
 =?iso-8859-1?Q?jl16LB/Imk/4fo9XFDXrpYCikc2TuVImr5nFZFuzCtb/HD6z2JFp1TWjd4?=
 =?iso-8859-1?Q?q8KK4XL/ndofuu/QvYfOpxTrcMBqp7Yr1f0OXG1/Yp1+koYqZi7BC6YIAm?=
 =?iso-8859-1?Q?wZnQ2H2HMdJ/8QVeo8BhRqIewkHS6Onrmo/MIfirqgw93mTO9TYcRZpOxr?=
 =?iso-8859-1?Q?3SLbGvDs9RBaNTLONYGk1flPlI48VDy2PAdDFbKz9NRintW8IwkpJz1Yyh?=
 =?iso-8859-1?Q?AS0AL7yFgiEjJ5agrkjGhw4f5VTSpHeqH2gAT/3Uc1Shc4MkIalGZHn7Fq?=
 =?iso-8859-1?Q?04s9EeAOTdfGkseF/Ax9MSOb+6PN/bX0W3/T6vDLrDykIopIzvoUy8gxP+?=
 =?iso-8859-1?Q?eu4oeiq8nIw3W4DL7XT9MJymuv/hOuGk0w997F4tmyOvklEJbGefH6/dE0?=
 =?iso-8859-1?Q?69OE6bpuLp0GRTA0pvyOCLn+udkVp/Mah3Dq/byupPkofUoWKUqyZZIEhQ?=
 =?iso-8859-1?Q?JbMG/Irp1slFfGmCSqkQ7kEwm1vH83KPkIRqzsZTtarnuFISJ2SpGkPvV5?=
 =?iso-8859-1?Q?zWofAW6m1iub2h4xfkbjclxz+4m3CNJKRFNEwl7RqjL3SR9BX/g3vZhykw?=
 =?iso-8859-1?Q?B9JPYxbpEk9a2BjRmS64fre7MhbnlfAF+lnxYsJyQjer9f7QUedF+uawk8?=
 =?iso-8859-1?Q?H84dIJraD1a2VXe9qs8mQGctrh+lUaevC7QNi3hxEV7J+eDWOVRoKi43FM?=
 =?iso-8859-1?Q?8lmfF/Z4M6fbX/jqTf47AtZrW7u0+ogVdcO3JGz9q956unLA9suOLbOT1O?=
 =?iso-8859-1?Q?zM/yf7OJ4LNIoRBCSHIHeSTe6grWBv6JewlCCMswDd1a/teuagfh3Jpuh3?=
 =?iso-8859-1?Q?/zTnxnDGnzlIYrFY087iV2MB33caexbTax/Rv0E5Sn257CI9UBDqMZ02sM?=
 =?iso-8859-1?Q?o83zLBD/fqVaUWodzE94ky/ugytHrRZkjWpAhIqX774h9KZGcZC9tpxWhP?=
 =?iso-8859-1?Q?flE+GXpIvNglSooog2j9JT4QgFrNXoHWNOR0gvaBfIrObaE2pCu94KVRRv?=
 =?iso-8859-1?Q?+B4/2EtsoZXJbg0xr9Pr8dCdFdCsk3FZpOu8dt1T2oncfmD8XVec50DnQP?=
 =?iso-8859-1?Q?vnlkZrHL3DplzU+ObXf+gH4UdvItdSr7UdZeYZPGMVXinacyO2DyVm1OmX?=
 =?iso-8859-1?Q?gHZHhTgVJZgSyeIQkg5t5zE3YYrURH0vrLwpXTTcT6vNnwdS9w7RtUeOZs?=
 =?iso-8859-1?Q?pAmPmi1ajZugYdygv6Fy2LA8mI2M4R1onqTEDPxM4PCNxVPNZUdUHrEmL0?=
 =?iso-8859-1?Q?HL5VemoMeqSFCq2a95J1Gl1ZQQuk/CHTS2ZxTNDK3Z018MoVawld6Kwvlp?=
 =?iso-8859-1?Q?17tm8+adMvnVttTK6zwNG8iKfBC55OqWOLgc75HxmMLqTBgwc64SVGgtlw?=
 =?iso-8859-1?Q?dyUA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:05:47.6447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d3065b-9f55-4137-5c67-08de5e97dd33
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000199.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB10082
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
	TAGGED_FROM(0.00)[bounces-69387-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 361CFA77B2
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
---
 arch/arm64/kvm/vgic/vgic-v5.c | 118 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c    |   3 +
 arch/arm64/kvm/vgic/vgic.h    |   1 +
 3 files changed, 122 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 40412c61bd2e..db74550d1353 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -136,6 +136,29 @@ void vgic_v5_get_implemented_ppis(void)
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
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
@@ -186,6 +209,97 @@ void vgic_v5_set_ppi_ops(struct vgic_irq *irq)
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
@@ -345,6 +459,10 @@ void vgic_v5_put(struct kvm_vcpu *vcpu)
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
index 69bfa0f81624..cd45e5db03d4 100644
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
index c8f538e65303..2c067b571d56 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -366,6 +366,7 @@ int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
 int vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, u32 irq, bool dvi);
+bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu);
 void vgic_v5_flush_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_fold_ppi_state(struct kvm_vcpu *vcpu);
 void vgic_v5_load(struct kvm_vcpu *vcpu);
--=20
2.34.1

