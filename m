Return-Path: <kvm+bounces-69399-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGYYN/lRemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69399-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:17 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DCFA7973
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CEC61307EFC0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19012372B3B;
	Wed, 28 Jan 2026 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WbKA6hkY";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WbKA6hkY"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010027.outbound.protection.outlook.com [52.101.69.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A024C372B4C
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623737; cv=fail; b=dxkxU16swh7WIDoBc7u0mJNFhjYBL805tOUXcl2jBrydSngydcGvz3xdCxqwHz3oUv3XVJM+8Zjla02NkHLrujdgw6tj0sOdByVzr3Ol9yqVPouLG5gn8e/XCwylecRsrlg5QIi+eLXMuhciwnSEMZxXUoc79it+0Cq0CMbiRtw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623737; c=relaxed/simple;
	bh=E7gkK9wzEjhlBeobe/zl6TOJkoY1v+BGfaQxQHrD3VM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nAP8Doyw81RCM8imJyNmglj7uM7QrHG0WOc6e6ZSBj8fXegR9qAcw9jhy9+tBhC8rK32GoAPyrCgG7+6OcSXPmI33ITlPqNGfhgll/1iHNBZsHuL/c5hFRLMc30jMACB9rbDXIc+ePHiPP3OSNTTcaQRAp0T46NvO7byS8kCDiQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WbKA6hkY; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WbKA6hkY; arc=fail smtp.client-ip=52.101.69.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=V/mYu6HK5gWnqZNpoRv1TIeOu+sKkFEJd4iIbkO9TOLC1SqMO1Vo+X3XAI3vBDsOzzr/nXphE3Hqk/FMRXHTX/BiaEqc694A4ZBe/xBdgl2nrWV+NEheqyUKvykykFHzZsb9HVn7mWb295tQU6mzAkjjWLMZgZkfDJgOVDCL1ZlNjg6FldOSMy4Btb6GU7pUBkMYt3G0n9Wu723oVo936+WccWsweq3Hx+ymEyehAUJzDRghgSuHZ2q/pVsrqX/esY/jXQpFY1HJ8Wkl22YcrvGk2atYscVeFLnQtGq5/nAteo/U7Q0duErVWYDxOnWLa1p65agI3q+B8VRDazhfiQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=js9UgJe005E4H3lbMh9bOC0Kw7vfZs6vINt1guZ3sdM=;
 b=G7Sn7mkO6zxlvwdW9YoIK7+YLcl9KCi7U/ijVYwG/eqR2/unh49erAhUPKv837z8eG0yZEGqAYX8WaOF/c22OefrsTaaddPjpaomHlFhF9GmdfXNLMTO9/2F9H+XAJizMscpo/pTHe6eFH+Atn+QRQhoTGEwB6wB9LxWgXZ4BQaz6wTnzgVwLFo+60bNdL66GAEYTYyV0TvDfdM/H/f0KpdrTJe8qLvcQT4E9um3w8blo8RQoIUelphTwjNTp3xmWvaFTpCtQFdGcS6vDtXo4dccKwnHSq969jNXB/smVSaTpMdmYlwWmeGKLpFpG8rLsixLqr/zNOyoQ6OTjJaHcA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js9UgJe005E4H3lbMh9bOC0Kw7vfZs6vINt1guZ3sdM=;
 b=WbKA6hkY/enrUYsJQh43hzu2CqLLW6O+1CLvqlBpOGKqzaXHv3ZYAh4enVcrtxcTx7g5AcB5O4P3brYNQKAfzpxfOL8xr05QbY9sVg5BVGFEnfO1p8FcJ1zLEpaAbNe23hiPT+xATgm89DtASk2meFp+Qpxkk3aVqVem34Pz8p0=
Received: from DB8P191CA0007.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:130::17)
 by AM9PR08MB6210.eurprd08.prod.outlook.com (2603:10a6:20b:282::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:08:51 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:130:cafe::10) by DB8P191CA0007.outlook.office365.com
 (2603:10a6:10:130::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:08:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:08:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ibFEPcLkKxDotMW20iGDx72JKAwy7D8Qlroa29Uo1gDpXL3sDRW6ekOfxDFTF2Xb6+eZYOTTVnuBJc8gy+TlF1pwk5hkz2NoEp/MZ3p+kKYIOuRNHwJgwjNclTFf1vpYIjeKTEBcU52FLc1Btq4v/+naGBJ15vaUcsfwu4VAxxt8cU+kdTJpNImq9IIdqM3i3vDPhiptc+pg8AoxBQlzvw4PdgNsa3ZAwYYLinygWM1bnlA4+Mi0WqeQNP+Biv4voainv0UvQ4PZMvhgsuI8dX98d8z9+ycg8zkW1OhjS5nZ2ZWugpQSXi036k7eqZ8MiWddg3KApmL8Gv4HrTmXGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=js9UgJe005E4H3lbMh9bOC0Kw7vfZs6vINt1guZ3sdM=;
 b=fwtAegbld+EF1O3aBFQG0nrYx14i+xXp2kiwsfUKak9sBPFk61zrDyD8ZeXiers+fMeo01faXUDDSNLifb2ZvwDxA2olTv7jpHVVrnz0Kg/9xcZCPLOmieg467/r5MUyKo6LbmOAaIVexHJdb1waSfxtE0BuzAcK2TmqXLhoMpfZii1CAo5np26DYwMtt+hWS6Z69I0WvRDw1o0T0Z7Y1QPm9sls6Q+Cp1neh0/c4VF8ZPgKFCbjqYa1a8t2giEsWHh2UtaTWtwbrF5nVUlY1elDqL+/eJnaXIvnoComMnY8bYSietTb9k0muRld4tvc+nw3TGsyTv28xhO3lB/4Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=js9UgJe005E4H3lbMh9bOC0Kw7vfZs6vINt1guZ3sdM=;
 b=WbKA6hkY/enrUYsJQh43hzu2CqLLW6O+1CLvqlBpOGKqzaXHv3ZYAh4enVcrtxcTx7g5AcB5O4P3brYNQKAfzpxfOL8xr05QbY9sVg5BVGFEnfO1p8FcJ1zLEpaAbNe23hiPT+xATgm89DtASk2meFp+Qpxkk3aVqVem34Pz8p0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:07:49 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:07:48 +0000
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
Subject: [PATCH v4 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Topic: [PATCH v4 33/36] KVM: arm64: gic-v5: Probe for GICv5 device
Thread-Index: AQHckIEC6ZvtU0usLUe/pDWwecPMnA==
Date: Wed, 28 Jan 2026 18:07:48 +0000
Message-ID: <20260128175919.3828384-34-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB5PEPF00014B8B:EE_|AM9PR08MB6210:EE_
X-MS-Office365-Filtering-Correlation-Id: a2b737d2-4857-472f-c2c7-08de5e984a73
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?B/M32rqhrjS+2o24bwCaPaZS0NbDzqi+s9X0Q4E83tJOyabza+fAU3m4wp?=
 =?iso-8859-1?Q?g0WOnUMK0IldZZvGQx9FIFk+I3mAayzv1u0N6wBUkXdIdDp96YeowArR1g?=
 =?iso-8859-1?Q?EJoPNTaMU091e7JOD860nsodUPOZ6EEMlgGxt1E51RZCURA/hDgFcl+IAZ?=
 =?iso-8859-1?Q?ph84Db1B37FFqayjHmabK1k+Dp9VEviLBZBA/zKdEm3jR20XixHtHImdJS?=
 =?iso-8859-1?Q?/hE+S23aazBuoNx9Ewaw03pOfZlEFWc6mXjkHZ7Cnl3B6MgjNq+QcfRijN?=
 =?iso-8859-1?Q?qIrM7a6B94ioTw6AdVxWm1Oq248eMdbymV2p6kizPXkAeIxU/uk9LV3kyU?=
 =?iso-8859-1?Q?5YMn5bwDrQRAgxPfQJEWady2Ykpv+HmIfgFDo5XinXmR+z+Wskt2RxmvqB?=
 =?iso-8859-1?Q?perh2t0KIHrIQ/TwWyAdO6nTGb+4SPIxgBagE4C8wGWujJ+IQkCzAm+Flx?=
 =?iso-8859-1?Q?+a43Jg5EWlD4i7kxXZGtD7hKZLr+qYh1Z00VN96PYNJaB8zFkUCjhJCYKa?=
 =?iso-8859-1?Q?l55i6uHhUekgCeIXYwFVkdm75GgExc6g+qvCrFqS8kgqxLsO+CPQqS9ymS?=
 =?iso-8859-1?Q?TDkkHZ0O3nLkC2pl0OJIkK9+OLYNZP1/vrxgDalr3zBJKBFoSHbmwP2lXv?=
 =?iso-8859-1?Q?SXFGdC6bRI08mYPBQyPzDuTe6vMQrCZaZ6lzK3FmHyDAO63RgC9et0PY2S?=
 =?iso-8859-1?Q?FQfjA5AB5wKP0fbgO5VRuRxV97dimGkSbW+ncjgJj1WV/0YwaccUcLVkEh?=
 =?iso-8859-1?Q?UUYMOaxxt+4fNwXuCwLrZ5UDMZKvhSkd33zYxhSr+CRLy9fyuIMsGHc6rv?=
 =?iso-8859-1?Q?g7iLG8IYEYsU2omliyQvvREQrmh96uqby9vyr/qndc9tnynI/k+LolHeYS?=
 =?iso-8859-1?Q?7lEd09zkq9/ED/yYMmXhE32vRoeYlEzEIvGtX64mHaURnVlXCdXtSqsddj?=
 =?iso-8859-1?Q?jDjoHMzt0rEvxsiCg4ujIu+rik3c7o/vHqGldiOpQp1zKUo+KThMKE1lZb?=
 =?iso-8859-1?Q?P3+zAmjVQGk/BgNo+ki183jG0GduK/Wrx2ixHpkoUQNLyQDXMlJwLmX/8n?=
 =?iso-8859-1?Q?YV3O4VC4/AkKZ3yrc0XyBWgif3CIE4k5F5sQyYr4drFkD+5wnxE+z9pKaA?=
 =?iso-8859-1?Q?lUbp5QN52UI43VEXRWqBBIbm5aVZgoJ7AoRvW1jKCuZav7FBlP1QhdVWdU?=
 =?iso-8859-1?Q?yo/ur0EENRs1leBj5Zr3GuFSAYWfW105fmS5o3BK4k7NhOnuVOvvfBIPBA?=
 =?iso-8859-1?Q?gN5gzbcBP2zfRpe+qDSg7O//7dfC1qI/RzpMoQECEr2vAQI9sdq3i0UCKI?=
 =?iso-8859-1?Q?A6g9/JniEWRQ2rMWbce1qNYmS0XoSOfLEZjXetMyBmggkadI1+mM+2O94m?=
 =?iso-8859-1?Q?bKRWtE9TLw5fDAipu4eS2OIX9Zl8Z90mNhMG7oGIsSxG7ub9qEsjwNB1Go?=
 =?iso-8859-1?Q?HUPo+K/w2ny8KNI9d9wbc8zH1EAF4LMn+xR3SCdMRHJoSRNN6qQ3vMr+1T?=
 =?iso-8859-1?Q?JHQjeiblSPdtAqkJuz0IkOYBf9d+zNs6sHmIj8Q9YC0ZGoHDQUrDLgbm+a?=
 =?iso-8859-1?Q?mPBp63kjNKI1NNkewO/TKc1sHNsUyRa7PJ3ObuBe1zNO3Jt8eEouCvSB99?=
 =?iso-8859-1?Q?1j0tFcxqeErjHasXz2Xjt+Uzw3LGeYEN2TxrLAaJPLNOIQ5woaHVJAopKI?=
 =?iso-8859-1?Q?/TaS5Oxz3bXJuSfmams=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9740
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fd7da50b-f954-4fca-4756-08de5e982572
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|35042699022|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?HAql6j3CznlqqZTuhqRyIN13EFQdeYqIgGglDJ15SBLHMhb/BoI1aEhYl3?=
 =?iso-8859-1?Q?c0VltxG4C+HpK7XMozQ2NyX1w2iS6IASkr9Jbnirc9SjwocO0bgiS1220R?=
 =?iso-8859-1?Q?ffbezV/uZc20KqosQ7rQIczdc6PKWwbVXqBieKGhw1k2q459oILlTM91GI?=
 =?iso-8859-1?Q?Z/EAjGwTaAwPb9fZwrBa7IUmnT3JX0SjnWEhyRdyCnZkbBKJF0E/H6fqeD?=
 =?iso-8859-1?Q?A9KuKvpCB1bDLb8Y7eLPrG5p6cE0YN3KO1Myg6Pi9qw3BQyw7jL8tyEICu?=
 =?iso-8859-1?Q?tUMiomCTDsbGsWO7dBnLmXViwqap1nB18QA3WR4n2kqwV6yfdlmeNDc/2n?=
 =?iso-8859-1?Q?S5lkjotUlsgwMQIBQ4p7PqyTDY1+8lBREtakXiYoJFN6ATo6/7fKV4ENU3?=
 =?iso-8859-1?Q?uNCFph+GoP3B64BZya0rFimzZFU11mavsA7m5Cr/UnLCTzfbt0InPF9pIF?=
 =?iso-8859-1?Q?3UyBbH5+swTPGVpRn0irae2MVDqwsXOu6D6bCJrC0dbuhYeM1B/vecUqi2?=
 =?iso-8859-1?Q?0JATEfyEXBvTdKgnpjzY8gB/3QdmTEfsAOVVZTndwpzaIY4lojo7aN2ETh?=
 =?iso-8859-1?Q?YvCLzk/esWY7xP3jFipNtYcTb1nyaUm3Avevs4I6N6YrysV/vLa2gMJJec?=
 =?iso-8859-1?Q?9oNKrzn3c6wqaoAyIkiajmMRVzvhRftxTeK8xWHZWWnrrSGn8IckaY9+rm?=
 =?iso-8859-1?Q?9Jo9Nekcjay/YWAU3woiePOsdFDKYe508Afle6PV1kIVwa+Zvyc37YRELr?=
 =?iso-8859-1?Q?5G6gRF5HIWAGIRP98ZqntTQ65YwGBxLHqjHF+gb+3xylvYmOkG2tNRSQYo?=
 =?iso-8859-1?Q?uZ8JZ832ZVGoY1iyxhr+8sYHybXCbaDGsxqICgngjSt85Y4EYnDPBUt1Sk?=
 =?iso-8859-1?Q?W//yGwZKjjNa2L0/+L2qSdPvA7WmCRuzFyThmgECfJ9RjpOUnS5F/lZ0iY?=
 =?iso-8859-1?Q?J893YbF6mPfgJemuemMQAt9DLpJck24uwdqEapfhAixip9uVcGwjYnRuJ8?=
 =?iso-8859-1?Q?isBPWWEe6SPn8qTdY0R4rtFtYn5hfJhrcAbfdpv9UOJwc4aBTwLzC9giHI?=
 =?iso-8859-1?Q?TBniawuKlFnKC0OZk7IWHFHbdZlAlpWOTbPWkDEfynbwsGtAuZlidEyUBl?=
 =?iso-8859-1?Q?wroYbwD86HuwsVQku9Zo1u3mHg2ngUs6ltCobrRH9EqvtMmb3l36dyH4U7?=
 =?iso-8859-1?Q?/9FSJ/OZDrHIHa0T9voYFIivI1cpX716IusrIfEeH437k6PnVuHPuDyBng?=
 =?iso-8859-1?Q?p8ox5afAxbRO2kAAT0z8GDg5NOGLqbZuBKF9bwxrd6uAQJvs6XET0qqM+5?=
 =?iso-8859-1?Q?AWCjKjuO5nhSJP4uAuUS+1nUO8flrk4EPhIMDfvoo9+mGFDurjDAJ5iKux?=
 =?iso-8859-1?Q?2a0th6c3dR6TUcipw6nuuX4QMBaHVgvo1YLlggXk89PxqZpF1fjMMTmpyZ?=
 =?iso-8859-1?Q?Av8uhDcF85S7xB9F3qQQKs+Oh7MrXbZ2Ga20vVvk7Bfh4cO+aQIOYlhGMt?=
 =?iso-8859-1?Q?zk80mLNzj6Aoz1hMvmzTSueHKVpS04pwUvHEE4KQFA0WyeBUhuZFalTDX5?=
 =?iso-8859-1?Q?rEhWHTvKiqricNLGfnPDtlxpt4dFa4EQUE89MV5d1EJEkustGgXtJvPs25?=
 =?iso-8859-1?Q?M+YcmlwiTbUDQa7Htq9OnM9dFjbS+ETxJpXrPIKGDl8Epk3Zd2yCBKAvmB?=
 =?iso-8859-1?Q?qrnc8gIcBXa+r1FURY6dZofp+1qvdFWrTEaHODt498Eiwe5KsTbUyenpFI?=
 =?iso-8859-1?Q?tj2Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(35042699022)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:08:50.9142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2b737d2-4857-472f-c2c7-08de5e984a73
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6210
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69399-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 82DCFA7973
X-Rspamd-Action: no action

The basic GICv5 PPI support is now complete. Allow probing for a
native GICv5 rather than just the legacy support.

The implementation doesn't support protected VMs with GICv5 at this
time. Therefore, if KVM has protected mode enabled the native GICv5
init is skipped, but legacy VMs are allowed if the hardware supports
it.

At this stage the GICv5 KVM implementation only supports PPIs, and
doesn't interact with the host IRS at all. This means that there is no
need to check how many concurrent VMs or vCPUs per VM are supported by
the IRS - the PPI support only requires the CPUIF. The support is
artificially limited to VGIC_V5_MAX_CPUS, i.e. 512, vCPUs per VM.

With this change it becomes possible to run basic GICv5-based VMs,
provided that they only use PPIs.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 39 +++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 1ab65cd7133a..b5c9e73007e6 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -12,22 +12,13 @@ static struct vgic_v5_ppi_caps *ppi_caps;
=20
 /*
  * Probe for a vGICv5 compatible interrupt controller, returning 0 on succ=
ess.
- * Currently only supports GICv3-based VMs on a GICv5 host, and hence only
- * registers a VGIC_V3 device.
  */
 int vgic_v5_probe(const struct gic_kvm_info *info)
 {
 	u64 ich_vtr_el2;
 	int ret;
=20
-	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
-		return -ENODEV;
-
 	kvm_vgic_global_state.type =3D VGIC_V5;
-	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
-
-	/* We only support v3 compat mode - use vGICv3 limits */
-	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V3_MAX_CPUS;
=20
 	kvm_vgic_global_state.vcpu_base =3D 0;
 	kvm_vgic_global_state.vctrl_base =3D NULL;
@@ -35,6 +26,32 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.has_gicv4 =3D false;
 	kvm_vgic_global_state.has_gicv4_1 =3D false;
=20
+	/*
+	 * GICv5 is currently not supported in Protected mode. Skip the
+	 * registration of GICv5 completely to make sure no guests can create a
+	 * GICv5-based guest.
+	 */
+	if (is_protected_kvm_enabled()) {
+		kvm_info("GICv5-based guests are not supported with pKVM\n");
+		goto skip_v5;
+	}
+
+	kvm_vgic_global_state.max_gic_vcpus =3D VGIC_V5_MAX_CPUS;
+
+	ret =3D kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		kvm_err("Cannot register GICv5 KVM device.\n");
+		goto skip_v5;
+	}
+
+	kvm_info("GCIE system register CPU interface\n");
+
+skip_v5:
+	/* If we don't support the GICv3 compat mode we're done. */
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_LEGACY))
+		return 0;
+
+	kvm_vgic_global_state.has_gcie_v3_compat =3D true;
 	ich_vtr_el2 =3D  kvm_call_hyp_ret(__vgic_v3_get_gic_config);
 	kvm_vgic_global_state.ich_vtr_el2 =3D (u32)ich_vtr_el2;
=20
@@ -50,6 +67,10 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 		return ret;
 	}
=20
+	/* We potentially limit the max VCPUs further than we need to here */
+	kvm_vgic_global_state.max_gic_vcpus =3D min(VGIC_V3_MAX_CPUS,
+						  VGIC_V5_MAX_CPUS);
+
 	static_branch_enable(&kvm_vgic_global_state.gicv3_cpuif);
 	kvm_info("GCIE legacy system register CPU interface\n");
=20
--=20
2.34.1

