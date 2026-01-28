Return-Path: <kvm+bounces-69378-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ImECf1Pemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69378-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:05:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 848FBA773C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:05:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5A8D73033F99
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 720E936F418;
	Wed, 28 Jan 2026 18:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ds/j6+sB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ds/j6+sB"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010058.outbound.protection.outlook.com [52.101.69.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92ABF25742F
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623447; cv=fail; b=nNhaG/2yM0pZEhFOmrlXIi8Cf87VCG0A9duKaUXGU5ov31PF1Odp5HnAPYZci7x0Xn28XPH/clyYNTqnXHViZSx9tFE1mKpci8YD3rZlifKWQ7DvURpUo5/pXau3oXgbLXICBCPC/2St7PwRYpVNR3BUL1DOEYAjQUVRmub73cM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623447; c=relaxed/simple;
	bh=lIpaIfzxWOFQ641hELJtTPzUc9jd9vVUzHF39O2AYJY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zqmo06T2eTlRFvxGXZrn53+133YH4GloRcHd6jUeqqOO7Q5KC52J+1hmJyGMAzavxluHZYaM33lrfGuwz/daFVXFQUi4biUxHrcUctEbXyMMvST2RzN+Gt2rOqNVC8Qha++aAZtEwWavIPrtUFoyvbz+r6P08hIY8R/xNztGu/g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ds/j6+sB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ds/j6+sB; arc=fail smtp.client-ip=52.101.69.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=yAaySOc5VjGkv+bWfkQJ69cpWqYslBiZ91EeN8s+/WjSkvAwqiiQDvM3qy1dfDfzfqcIWq+nblbiOmhNGtDR8ILabODsQ1VRF7MWyNI7feRloEDGXEiKKajkntkCPWQmm1cJUz63aCbuiy3OeY5sn+LHC42Rov29MMrDDMBweVxU7fZZK6Hv6Ak48BABowa+/BaHjHmxcMEOb7W/swP0Qu0eYdrPgInW4T2WMUdwjZIwAu+LYLlkpNVH1TphO/baAIAGAsM1hq/QMwcRiBcoY9KOpMV0bwA8swir4hZTjmHGmYWFuD0bC1aVVKCLIFodtKQ6zBe4tlW3EbSGv7xXEw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a01gMJV06REGN83bhdwrN58+0Ja4C2IKr5OLU/9WET0=;
 b=pLgiC9bK7zY95VsBsKVK+1U9ueaKVTOnF/tlkLjTtGdn2++IyfGcfSaktG6WP3oUtRQTcqv0U3E8oL7w7GFFyDUxnAqt0NJ5xS5E1uxY++nXUxgtWRFKrzjvp0mVoTNdnX2juoDPnveIebzBQs7iPxKQNVIrKpxkFlFsmB7aot0NAwYfGqatcA7HrRax1njmtzBztTUJxBMWojL8tDJCa+SVwCHg8nqQBJk3YjJgxQTFKVB8HYPdq8KoSZXVTf5BlapLWz4wAEfNDjTTAlRzddO3264QuYue6+LGkG1tg2a3lX4TwYQZicYEIYwNFiPnBRTjpKdJNeeJSakFGj6gOw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a01gMJV06REGN83bhdwrN58+0Ja4C2IKr5OLU/9WET0=;
 b=ds/j6+sBR14gVu48kn2AeFubZtpmUNl6FH3qokptXYft/U9peidoCODsLRvTY00iqm+qXSlMEYygxDzZb9l13nYPECoMJTomd2NaZtxlL0N3i4Xbq4Yq/j11Cnfie/gtoriLU/xDBzwTdnX52dcZRQNMq0vw1T8Ns2LmmE9G3Uk=
Received: from DU7PR01CA0033.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::11) by DU0PR08MB8661.eurprd08.prod.outlook.com
 (2603:10a6:10:403::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:03:58 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::f3) by DU7PR01CA0033.outlook.office365.com
 (2603:10a6:10:50e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:04:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:03:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w2ymqb2wB1eFobFDTOOHj+LYGyBccMDWDjWw/i+itKbCEgpEGBxP+8jZja/yCC9kNckGSDcyO3N7oxKuyQD0nlSKgCKgpFG9w3DwuBwmfq/mbVp7jQpyLfdssJk5WiFdD804a9fVLX4yrNXWrxQGWoWuKmc8JoZAU/jQ3hTAgm6nzF1EqvXlkGHG96nEdCZyi2B6ysfIVYdBx+CRxU+2HLAFHeX3bHvcyE1NfF1WUD0jc/8cURdXJNVVzk9tjyzpdKIs3rVkhDvRsRLQmOOeO9TNDpZUd2SKQwEDvDxHNv2r0J8QDKDJ0ryYmBLsjcEqudjohSDnfwQvDBK/BVE84g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a01gMJV06REGN83bhdwrN58+0Ja4C2IKr5OLU/9WET0=;
 b=PG0ZiZTWysgIv9Vr3bQZTUE/CnMkCr/dXChzO9tv4z/LOlft/9TP8N4zG7PJS1tF0wH50LFlan1cJaJeIqe48LcfxQLP9OmI2LCG517gmLis6EQ5g9QPH2CDCngKcKIVtqKcokaiiUtJMEDUFFMevy9Kr5v4pNxAkFpEAUy1Z9hhaPXzYSM7JohckilIh7onJteV0b05TSwDjQ30ZdZbvfX48bTBDYBX8cyRq7fJ4ibSGKSu+n2GwjP8nklLFEYYZ6fP59SD2+cvdODTWpJMWeAfSiADYXpk0r+Yc0pXnhAzTTvortMLtsTtLNVauGvOxCIZKB8i6Ln/7ofi/IgCSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a01gMJV06REGN83bhdwrN58+0Ja4C2IKr5OLU/9WET0=;
 b=ds/j6+sBR14gVu48kn2AeFubZtpmUNl6FH3qokptXYft/U9peidoCODsLRvTY00iqm+qXSlMEYygxDzZb9l13nYPECoMJTomd2NaZtxlL0N3i4Xbq4Yq/j11Cnfie/gtoriLU/xDBzwTdnX52dcZRQNMq0vw1T8Ns2LmmE9G3Uk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:02:56 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:02:55 +0000
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
Subject: [PATCH v4 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp
 interface
Thread-Topic: [PATCH v4 14/36] KVM: arm64: gic-v5: Add vgic-v5 save/restore
 hyp interface
Thread-Index: AQHckIBU9Jpdmu30+kqgBNnZnwGnlg==
Date: Wed, 28 Jan 2026 18:02:55 +0000
Message-ID: <20260128175919.3828384-15-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|DB1PEPF000509F3:EE_|DU0PR08MB8661:EE_
X-MS-Office365-Filtering-Correlation-Id: f79944a9-28b7-4f8f-dc9a-08de5e979c08
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Aqs1bFknBUIia4dMpupjgEkRU25MF6afxQbze5AQW8v699Oucwe0augNZc?=
 =?iso-8859-1?Q?ne6Etofo+hwl8e1LvMV5V1FyaWFZ0GLR5K6vM97P6BbKnO4fAJvRUvThwl?=
 =?iso-8859-1?Q?iYr/9AP3JhakMa7U38togDLN0P1Ga04f3FdXHWxMdquGnRvWu80wX/7vb8?=
 =?iso-8859-1?Q?8GSfilGg+jyfKRQce2GAvE7XtEMxF5Mrm12NSUqrYDi+2tb0GKJLUNPwGX?=
 =?iso-8859-1?Q?HTvIbBeZLI8UvVlNo5M9XivSJ0FaAnwEhfM6p8jHWmCmnEhvzYD4HYImtU?=
 =?iso-8859-1?Q?PrJ5ZhzL/dvRq5yxf9yVVcSrD0oQ4jgVbH0CinrqGPmYvg+DkDvZrY0j+r?=
 =?iso-8859-1?Q?3SnT13OjXIMMJ9JGe330VLvH6BREGyq1x6iWx1nfmF/52spblSGnHyGNpp?=
 =?iso-8859-1?Q?FGYB/PqmUKwHNDx06j4AyyMv6bknzSabtb2Zs9wzokiDedVrhLGQjpUAv6?=
 =?iso-8859-1?Q?pOYyvKsUlGHTZVv94Gz3tScdaFylHfGPhq2JZOw2tDh0pn1yVKDb9JDAOZ?=
 =?iso-8859-1?Q?bMN9GSnEE/1q0g6ElYySUB8OLvtrIm4sA8UxgeHEPu7dtnhwJ9AxrQzIh/?=
 =?iso-8859-1?Q?UyLrOM4qbJ+RQdTLCOOGkpH0Tt9RIT1y9hIjEIW3kSK8qQf2OHluh80Gzv?=
 =?iso-8859-1?Q?eSHAMEVcmFXsxuGFpa0LsbtwZbs3AmiqyZUkMMUqxSy3Bd9XEcfJV2QG7g?=
 =?iso-8859-1?Q?i1chfjJP2PZKwwEF8We5qaMWuVt4xp/6ac/xR8iZlONp8wdCqU3JFnq3Vr?=
 =?iso-8859-1?Q?w+nj/Fs+xDUbamHo4eSrc9U5wWmCk0gZcUU0NfnjAkSer32Vwu/W044Lov?=
 =?iso-8859-1?Q?7nQqzdXrlUjuucDcKNFuEu1AkL1gumasioux3Zt0l7DXOaygFgUoDIEpoK?=
 =?iso-8859-1?Q?Y2mu5Ub2+3bBF/PzEa26iZzU69PeCauqXIrzZa39xj4YzZWAtsk7ke/R7X?=
 =?iso-8859-1?Q?EFRL+Va++Hc+cN2RkF8fNUCPIA/sTuuvVEhaGMfi67guRMi+/ysSqtGNSP?=
 =?iso-8859-1?Q?5OLtPTJ39Yr24n3dWHpmy8VbqjOrSe/M5VqVYkyi+bCI+HdVhKB8x1pDO1?=
 =?iso-8859-1?Q?Mi5kSHkI/XlwA6s98XoqiJqFTcVZrMvaWRdInSzi6xsFsL+eouFONu8O95?=
 =?iso-8859-1?Q?Zjyoa4RGB3MX9taJZDExwRtd475UAzAs5/aW91ogDltWyUgReTsmTfaW3C?=
 =?iso-8859-1?Q?MhPfEO5s/dcgcrL9kPNekY+VGcgogTuNw/KPSKE2NctQB9MJGczXC561Ic?=
 =?iso-8859-1?Q?KFxJtim1YabuGTyWkmO5vcQQfIo9v1OD1L8LssNI2xwQYXEe6IrCOBgzNS?=
 =?iso-8859-1?Q?TpKpPglaMwoJQbbxQPOnk56PG2GtvpMUxilMEORoHzHiAsscem5qsFDXnf?=
 =?iso-8859-1?Q?0NrJBQE3ns5BWbFf89ERQGRkcGQlqSZOhO/5YKy1ieIRNA4VG03AZTolyd?=
 =?iso-8859-1?Q?TW0arJ79BDZgDvaIuL2h1w2Fv0UMR7jG8meHX8x2RwED47ktLWrxY/W0Y+?=
 =?iso-8859-1?Q?Ve5bKVKjEK1utZE1S0H7+ziNtRkDv9EnpAH6D7FfX1IuDzczm88ks8V6HL?=
 =?iso-8859-1?Q?gMj5TU6ILYjIhwQrzBPNyxz2Ts8OterquaOeTp7oRK6LDvESv5t0J+t3yN?=
 =?iso-8859-1?Q?ZlbUgpsPI9z8TO3Tv/z6JjlxDptXIX/r6Eog0yMSxNvGSRIv13as2yxQAg?=
 =?iso-8859-1?Q?BkjnQdNJrdKGUEIaoNk=3D?=
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
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1377d668-1645-4cbc-8632-08de5e9776c7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?RDEjOsY/GU6Bsg96BpDweA5CTtSzcnBHsF2FphP8ErfC7fi7LifyIQrvj6?=
 =?iso-8859-1?Q?JijgNiBGpwTK593MUAqrFAdEn/VhPgqaK1lUc6H94iT5pPgwi15OGMBZgR?=
 =?iso-8859-1?Q?bnZtkrwHN92J6JBbU/hwNqKaVBDxpcrRznjIR4tX1W8gayyAqF6sUNT8ww?=
 =?iso-8859-1?Q?LVlKfH6bDAol9e/Hrlu9svk6y+Ns1rhiCCNL+e7XIwq5ayCB2qROECsW6N?=
 =?iso-8859-1?Q?0T3tAxcwgbNlLkyLgrmbe8XGZf7pSRzWZsunY/uBPulYvJiCi8jkEOkTc0?=
 =?iso-8859-1?Q?RR7KAg04i5tjI1wlgMqObwUl1vfEf70r7iZESGNIueOEhh2HuPzTGD8IYZ?=
 =?iso-8859-1?Q?o1+rPfl7WbKwvg4nawHLbKwm5LthzPTERpp0zuZpuE1rvN0veYsEc88V03?=
 =?iso-8859-1?Q?Qf7ryABZW0WlLzODMFj3XS18XiqaroWIwx8dZKiw83UNOLabs2VbkGhNv+?=
 =?iso-8859-1?Q?OnWH3rat+luelbAmaruOqWIRRbFrfFurGajzFpy/cn9xNWuepuzfD/Gl2v?=
 =?iso-8859-1?Q?2reT6QVUXlkfsjXPOOxnaSa04tsQjjxP52H8t9cM8kjYTZQK/IY2l5IWQ/?=
 =?iso-8859-1?Q?LpDxWfa3YmTlPJmqpOiuohP1ZfAnqtYSNxOMCGae42nCoiF8Emru3LDdKd?=
 =?iso-8859-1?Q?EZxJlhEp9QBPv8gZGfkFRTs8KvKCp3MiHcZJLZekvw6O7237qChOXplxbE?=
 =?iso-8859-1?Q?Nzx0eyL/mMFTW8666Twn/cN37xy2gkj/KdD74KLKWPECbxpPf3zmupb3b8?=
 =?iso-8859-1?Q?d/lXObk9Iozewunapn0qnCDdCy8zcMq6YJYstVYgZmibPY/F8mCyAAdjBi?=
 =?iso-8859-1?Q?2oj0g0vsZZzgWGFvpfhJf3Up1eUyVc5hMTYlR/EuZd2iaDiMEsbM+8RnsM?=
 =?iso-8859-1?Q?tE19W5rbL2SdI+1smHrWNGdFUDEbpBoFOJ+QSBTW6nQryE+Xepb7E/u9Ya?=
 =?iso-8859-1?Q?Uu0dq/zwUsuJ0aslGnO0a4g74Ts2PBkzVPYyvZMwvq97rrZuxbUTvIC/NQ?=
 =?iso-8859-1?Q?Iz9GsKetBAOS5cd2/SrJvlGtGckqd21jxTeRMOTXTphk6Cp3AsqDIFz6K0?=
 =?iso-8859-1?Q?lTHTEiVh9RXT24/9/esD1bDv+qXLQuuVMvAbOOIW+Rj5we3VcS26w7lHJF?=
 =?iso-8859-1?Q?Hx2jCxy+/G/e2f//B5P1Wr1NoLVEEhmzufTaOdX/7EzDEmipBsXlTOTd6g?=
 =?iso-8859-1?Q?WKZHtfPYsQnxr9FAqhOjjBckoldcSv1zm0aLWy5jStFleZnkWPoRfQOEo1?=
 =?iso-8859-1?Q?usw0vqIjuiYMXOndQ+VDpI6vEw6wF1triPpPksBwZ1NmJS1nC/I/OxxOJT?=
 =?iso-8859-1?Q?VpokBw7APCXdX04zomzfMP345JnJps5Ym/gYeFa5TNHmi0x0Dn/pD8JD/N?=
 =?iso-8859-1?Q?PWI9As/TOBpuAv7xJ9rGDPYJdIh8rS5E7qKqq/Kniuk1mhYshD/agOpYVh?=
 =?iso-8859-1?Q?bLSOHWaSwWR/mZScUAau2e6rgj+QL3lXm6jvmmzv4kOmajYE7qaq/fMkj8?=
 =?iso-8859-1?Q?eD0f4Laltt2P3531lrOdK9b/hefVd2QYIkJulcXtfl0DPkblJoQbPDR2/S?=
 =?iso-8859-1?Q?l+wmIDjCF6CrvXzF0rnk1MUnaNwLoCRsaWmsPJh3bIxWQwpmoWj6qhoIwE?=
 =?iso-8859-1?Q?momxoaVbgJpJz7bZKSVLFWHls9S6GAqvWEf6KVbE185wLGLAlveUozUGLm?=
 =?iso-8859-1?Q?5hgcOCjdFPlBkd2wSj8W+9u429Ad7LbdUcgiFwKnUTewciO//+h9KuDyHS?=
 =?iso-8859-1?Q?b0nw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:03:58.3005
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f79944a9-28b7-4f8f-dc9a-08de5e979c08
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8661
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69378-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 848FBA773C
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
index ce516d8187b1..0de49331428e 100644
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
index 0e535ef50c23..b49820d05e6c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -774,6 +774,22 @@ struct kvm_host_data {
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
index 76ce2b94bd97..3dcec1df87e9 100644
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
index a244ec25f8c5..84a3bf96def6 100644
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
index 8ffbbce5e2ed..244e22b0ec50 100644
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
index 000000000000..47c71c53fcb1
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
index afc4aed9231a..9695328bbd96 100644
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
index 8529fcbbfd49..64e8349dc0c0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -414,6 +414,26 @@ struct vgic_v3_cpu_if {
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
@@ -424,6 +444,7 @@ struct vgic_cpu {
 	union {
 		struct vgic_v2_cpu_if	vgic_v2;
 		struct vgic_v3_cpu_if	vgic_v3;
+		struct vgic_v5_cpu_if	vgic_v5;
 	};
=20
 	struct vgic_irq *private_irqs;
--=20
2.34.1

