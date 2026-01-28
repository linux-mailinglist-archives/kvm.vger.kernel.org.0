Return-Path: <kvm+bounces-69367-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GE+4IQ9Pemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69367-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:01:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF7C7A7689
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:01:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9AD4F30405C0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D3736F43C;
	Wed, 28 Jan 2026 18:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PrMLShHK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PrMLShHK"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011052.outbound.protection.outlook.com [52.101.65.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D39212F98
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.52
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623245; cv=fail; b=cXnY0Jq8WJhO4tkmd91CEmf3PuqlwNW3R2cAhU5xuTHm0Qv77cwxqW2S2FdGIaHUXU/NSHwbpx+eqh5aKRrfp7SFiBE5K2L3p/jHrcrUxcUlJkOcRpockRNKN2qaSpQ+CrU9P1rBUkX7ot7ZgOxtNgnsikUeWL9/mqmoS10S9VU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623245; c=relaxed/simple;
	bh=cXBZo4AEF0PJemmyuTjBQcrXdhNAAgVbwDgiz5oOKMI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=upB8tQStFvSgLd+1RmPzit3pk5j9ZiT+4YRmRu7FZ72218ZTyJmfOYWQ4p7jUQeLJwgBPw6SoS5XrWJbuVzMjNUHeati/83HsmpuSfcHO9lZkJQymBZkaZPJRZduiMbcPr3B85Y9u0r6ehKMN87QEsUxhn/hGv4W3nBmxW9IMc8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PrMLShHK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PrMLShHK; arc=fail smtp.client-ip=52.101.65.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=RG/L4RAGXLOkmx7f3bKfd4PlyDqI2A99EYi7o4lpx51lZzufcitq3ZtP9H+gafunoM+iCnl1j17i1tV/JyOM+Bl5UVig0bZzsuOTky8PJ68rHU9e4ta1X48VrOIrOOlVH7OwiRJqhlopkR01KZ0qMM/c21DIiCzyuQCZ5JCh2jqruUSlw/kIyvvaMv+XAXg9GbYz8cTtKMQDay/Y2TbC/TEfygplrQHAyXxlyo9YcNt8DxCPjNUuDvDAZp+Lr7rxPUZ+/XivvWq0ONOlSrORjTgJFWXNkGvcheggTvJzpF33n9QAJBc7QjFy8RBazlLfckyHJ3TvQC6Dg2rPkCJ84w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPZRfy7Q+wPFRd0rxvCxyctlcdMjxDg3w9/sXvmxR/M=;
 b=EWmefRwbHOdpTX4IthNkyhj2Yjv+ZSqkzf1HTUbqfDE++ls0lfQfwKTgK6WAOsjp12Oxrhdlar9I7G2h7vKj0MhtI34VntFZcYeqWrzgM134y4Bn3AivomMfBktGtGFQO1R/mBbJWFk9UQaNpWASjTQRjwi/iDOfJJhDv6EdAjQvn0l0PmKUqN7rWs/M7nO5zBdFQIokyxZTljrK0kDP1jveqgbBB72LOFCZo6wbmqk4Ojwab5LdZ30wNh6x1rhd17YobfRLVUBAEmNCotdoktgh6EAdb3oCcOCTeRD+W1/wNojQ7hBIAPygYgWh5krUEw4zCRyDoZnT38nYtALiqA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPZRfy7Q+wPFRd0rxvCxyctlcdMjxDg3w9/sXvmxR/M=;
 b=PrMLShHK7M4hXf32Gpf46yibfs5zkCD+qXZq9TzDvI2LUdFcgHmqgeVwYpsMh/RfS6kQMROG8EG5AGkbKyD+7rbGliuyMj9v05ykrLFzg1Icjom/mDbcy+ol3x+3ax5gvw1V2ewWtUro3ckzn5hj+eNdq/gFT3utM2ov+LVfyQQ=
Received: from DU2P251CA0016.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::18)
 by AM9PR08MB6243.eurprd08.prod.outlook.com (2603:10a6:20b:2db::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 18:00:38 +0000
Received: from DB5PEPF00014B8B.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::34) by DU2P251CA0016.outlook.office365.com
 (2603:10a6:10:230::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:00:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8B.mail.protection.outlook.com (10.167.8.199) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:00:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkCZ+CFo9EWa1mpUx0yetxHTMC49KKAXhHlfVHnnNYGPbTuL3rY879Yo0UDKeBQVIYww275iyTZZva8rpmONjF7vzWKfbm9rDDbCM2d//E2QJip90dwieROA4zOKLbU8BNSdkqZWK1MFe9XK8Svj8KIeeuy3BpVWfTSEW9O/JuqUumwn2Uf9XEk6hw0PgtwN7vbqOJWhjd85XiDGX0Ja/1LzPpr7l8n1ZM+TW1blcvyVLdfHHE8FrYd0Urzel6ufTZZs8YR+kkZCXLbzO0L5XBTgcZIfc2Q8NRsORvjbbqHpg9XviACZgXOdZ/FdA7NppciLspGMpykHQnkLndL1Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPZRfy7Q+wPFRd0rxvCxyctlcdMjxDg3w9/sXvmxR/M=;
 b=la+sTS9JpIwxVHGKAh8ZdiT/j2GLAwTzw2TzRgPVGMpmctbtS6ukbWkpHAOWFLbyHqyY/3Z+CnAZSX+6k64CeHD/Rl/umV09Ku2Sw7dmgu9W0ASRfzK8B3kDztp4lhklrCy1ld28ZP0qPa0KGb1Te8hGDCkyLJBX74+AdaEUg/RUZd5tQihn121tT8w2R/a1YoGO204Nrytk2a996F6LojpDeHwE+/8wkpyDEMbYjxaGqAOej0+5/v1XSHWnpwAFTRYIde3djXNJgjxpZKD0IrfuNSTFwqC3fO61vUheYYVE4cz5FFX9+Tn2Zk7SQ9sNX7jaBJoNeLhD/HglDzGNsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPZRfy7Q+wPFRd0rxvCxyctlcdMjxDg3w9/sXvmxR/M=;
 b=PrMLShHK7M4hXf32Gpf46yibfs5zkCD+qXZq9TzDvI2LUdFcgHmqgeVwYpsMh/RfS6kQMROG8EG5AGkbKyD+7rbGliuyMj9v05ykrLFzg1Icjom/mDbcy+ol3x+3ax5gvw1V2ewWtUro3ckzn5hj+eNdq/gFT3utM2ov+LVfyQQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 17:59:35 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:59:35 +0000
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
Subject: [PATCH v4 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Topic: [PATCH v4 01/36] KVM: arm64: Account for RES1 bits in
 DECLARE_FEAT_MAP() and co
Thread-Index: AQHckH/c0Uv319w4HUO4T1cOSM0ljA==
Date: Wed, 28 Jan 2026 17:59:35 +0000
Message-ID: <20260128175919.3828384-2-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DB5PEPF00014B8B:EE_|AM9PR08MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd7b4b1-6c5f-4541-69ae-08de5e97247e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?fAzrznG/k1PMj+hWUQbeJb/SGjppK8BYXK+Xle4LTwpmvSYOrhx43j+qzH?=
 =?iso-8859-1?Q?Bc+oixa+dbP8X/bOqRT7VrAxpZuLfG9uvavXOi942KCCe7ivlOTsnuCSqj?=
 =?iso-8859-1?Q?F0Mmsmm6xk1Eu04h/N0hlg4GD/q44OlERUfJzUZpjycuFQe+J8wgA3ZnzA?=
 =?iso-8859-1?Q?AAgR9NS/qJl75KGNJyy1JL2XT7iVu39FQ2mtTx7PK5xk1zgsIMiX9Ir2+y?=
 =?iso-8859-1?Q?VlPSAnySOxwk516RQekkGgcL1sKLJ8owvKgCBjJXYt7GbNx6AFa4/9ogg4?=
 =?iso-8859-1?Q?h9bCNNYdJDNdlCw6eNtK/UhTq4j/b+pgNfH8mSmzqo+jYw3bAHsOgm56F8?=
 =?iso-8859-1?Q?UvvORCkt5ZKIVTLMVx+YF8HpyEV1v+wKoW4fR6gBpz59Bu1dpJ4zogBhGb?=
 =?iso-8859-1?Q?Lx9upaGaITb+55ToEJ7GdIcTebGXSa5mfVsCzDEZeGhkFvPmTkySfehU2+?=
 =?iso-8859-1?Q?UKGiB5+ttHpgtQqYhoy9uXB9y8GpZ+C3zIo4y7Bh6C+iiG7uI4yxRszGSm?=
 =?iso-8859-1?Q?9wz4JGjokvA8C1p5iSSW78bqIk6OioPUKc5pFgXa+D7am070A2+4IUaXF0?=
 =?iso-8859-1?Q?d3tysi8wefJaqmIVkJl56ZTTdSdBXt/FwmTw/Pgz+d4IMgSytWS4/ZJfNR?=
 =?iso-8859-1?Q?MceF13qJxG5bzamtENsN6jnrOG8Vg5QiC7hb4LkMyablY5d+SDZk8OFpeo?=
 =?iso-8859-1?Q?3a3NQvWaYMuprMtUFoPM6UQyZfqVHeT3ZnDPhA89DFUQMa0E7/m/BxNsvT?=
 =?iso-8859-1?Q?e3nnWgEM/TZMNzjmpy6z6vAL1ILQj4d0CSHvU59+B8NLrkuzcljUJ7RDiy?=
 =?iso-8859-1?Q?6r+kqp/Bc9s8Gf0/ZIp600FXYe98WWgSPDT9/WI0yR8MMXzkpgR+FrUtj5?=
 =?iso-8859-1?Q?AGMG+dCQekmTY7PfvXneZPDZmjnvw+ub5a+8ZUl6YJKrJez8qGfULp1SzP?=
 =?iso-8859-1?Q?pfiYnRg1P3NfxRby7Zwkl+0+BeHePxS4fjfeOygC7uicwgp0cQ+fT9RZ79?=
 =?iso-8859-1?Q?uI0QnAT4dgBaGd3v+PYzeYQdff4yKVSHphn+UYChmDnLfNBLUfqseT/t3A?=
 =?iso-8859-1?Q?+niHlHfA3UCh34N0yljXnmU7YJzGjSpaDn6500LIWy7O3vUEQXV7cpWm3V?=
 =?iso-8859-1?Q?4wRoPTmFzE0V7bRrWoy8w0vtAH5BJGCIKfj4Ao0J6bw3YizNcElWd1P7Hl?=
 =?iso-8859-1?Q?ZtnjSpYduQN15nviPv4SLkHC6YKIO9Y0QI9piG4kxcIMrs0+Ov6GSeqy5J?=
 =?iso-8859-1?Q?NxIu7LhZtA94B9rnUFeubO1DFlPBrGD5ETkN/SYXfcNar0d55V7z/bnWym?=
 =?iso-8859-1?Q?839Tun2EBKSf9AoEBu6ShaY1VWP/ALGIi+LLgDjpAi8eZDixAwQ2OD5u0h?=
 =?iso-8859-1?Q?tloomR4OBjH2gv/Fgkro1/dQyD0VUZP4aNkWlJ0G2UKD8GSF89+nbQ8X3c?=
 =?iso-8859-1?Q?KHBGJcyy/fuDZc2xxwUeDtwJ0VlM4QeQAgS4bRBqwax0pOX8gQHpfJRMlQ?=
 =?iso-8859-1?Q?pir8xnllW6mmwWP5VtX2X0Gjht1VYIwND4gJKcxWcjm5r3zmNnCYq0qaQ9?=
 =?iso-8859-1?Q?NjWDo7ql72birWhqqj3xIR5WvVMtw4rl9SyBZN1rGgsrtkqryoyd0EKReA?=
 =?iso-8859-1?Q?ZBJgD5AW6b9LOvdHYsEGORH6fbenCBD5C9+pWt7eTqP5dbrLENiKAlC1nx?=
 =?iso-8859-1?Q?dPfqzEZts8Mm6+VEzzc=3D?=
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
 DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a41ffd3f-65b6-4cf3-2bcd-08de5e96ff3b
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|376014|1800799024|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?/avoJQuKx2amQG72RKTNzTHPx3kh82Aiqq+B8Jt79QmFRf1axz5NnCyPph?=
 =?iso-8859-1?Q?F9nfOIMKAOpZmrClPJlrFwXLEfavBSjNUGqyDqhiMpmr19jtbAROEGbKe4?=
 =?iso-8859-1?Q?23TRC2AlMVLbsiZCcKucrud9uDf/4bI0S3zH5qCzAhifj72JYiMMCLAcC5?=
 =?iso-8859-1?Q?njHarTVExmgfBbex/tQwD9yvifwQ7r/bPDntf+xGuWdkhGJmvxEVTd4fcg?=
 =?iso-8859-1?Q?hm8LgqPF4yaqRpWZZIqt5WqsgfKNmQ+lJYuOICNWrTzJcVzIstf8B1jIGB?=
 =?iso-8859-1?Q?7D+obvIz/npmBnH5+QSj4RBYbCiYQsgC/1fY+aqMN/2AAlSiQ05Cf9owao?=
 =?iso-8859-1?Q?dJ1N7y+GGter9g4PCnUdnUXr+/2WiQHpzRM2gp/hmYdRt7rDUTOCIkdIp2?=
 =?iso-8859-1?Q?8p8p2ZdTEZRvRNdusiXWw1PcAyZGwzXQeWgeyLyDeXVSzz2pN9BUCJ8gMy?=
 =?iso-8859-1?Q?9I3ousNl/9SfRbFJ+5zaREIJCz3tJlWycyoV70p+1et3OaF7IYNiSqPq1V?=
 =?iso-8859-1?Q?MAj/GhVxmhhNveWwgraRf2dm8AAqwFWWR5GZSCy+B+3Knnk7mKJNdHz9ar?=
 =?iso-8859-1?Q?BJO/JjK5lJEdykTs7LhxYdH0Hj0HTwCaN0TlnDoinFLl2C/ltujaC6uPu6?=
 =?iso-8859-1?Q?uSDjT2XoUa18v2Q3+MjzBM5lHzLopK6sCnb9jsdmKOhPWhlyoCFT1c1Tl0?=
 =?iso-8859-1?Q?GIym610T9xnhYm/6hmNp9lzjm6YSRiSlKf8mJ5m93LbSKFK7I+f4gmmXy/?=
 =?iso-8859-1?Q?rFO98y8E/14YTy2Fs9LjFzILIgXlsxMWxxtQXRx/dpYMtX4wbWAQdGDxPU?=
 =?iso-8859-1?Q?zOoKZ9Ozpf7Z48Zz/fDhSBIQUMtsr7Can6Uk8QpbmaLom3xntZ3VnmHFOJ?=
 =?iso-8859-1?Q?+IgZSy8xfviHptIImcJlkR4erC5ULkMCMi0YEFwdZ5ez4tJ6zN3siN2Qw0?=
 =?iso-8859-1?Q?wZ/hqhoOeJKSD3UUQnjOAivg6D5jMt9kSDpsYo21cgfzjh90gvbe8kUhEh?=
 =?iso-8859-1?Q?bpF7v6tnLnsG67tKxsSSaVuUrM7ckNni7yb/TfFr87//7loprQ34d5nxx1?=
 =?iso-8859-1?Q?XE9Kq/eSZWFYU4BaB3XS/PBkinYyfH+2AjjCb6KuPqlQ907cgUzkK0d2lm?=
 =?iso-8859-1?Q?S7rZoPibayW1lQicAtOpPSqDdaVqhta2dxU7YBZIBQ+Ev2zExfseV6SmTn?=
 =?iso-8859-1?Q?1sQsqUylq8ca/jZcTh075M6HzD/cZmCjNigmGodMtbmz4/0ZhyOXgwjmDn?=
 =?iso-8859-1?Q?kuliPvzGA5gYZGGgwdxd5ZEqUcKJJn2Ao/8V6336cCKiGRn1J5gUzo0+E+?=
 =?iso-8859-1?Q?oBb6x3+nNvWny8XQc/v6H4L3w33fA6J57Ii97DHvrGSEtg1x/1xGehjPav?=
 =?iso-8859-1?Q?4NoVkZ0VoznWTfQYzTR0ujd9OQETRdL8I27Hoa7R2ZAJUKufajqvkYlQe9?=
 =?iso-8859-1?Q?gWiJsNVYRnifs490cvP6ksLPXgZi12mc/pSMKObjn62Ebm3cA+bT15HSuK?=
 =?iso-8859-1?Q?YQl7PFBCSZuFm9Ogo6GMZXciOiywFjbpVdZFapTpMOLPrzqsFgA13Bo01x?=
 =?iso-8859-1?Q?izgo0i3s0WAbMvMY70nWxrOpUeY79JM0BKg6CMKccMXHWT+QQnbXiYF9TS?=
 =?iso-8859-1?Q?odcAGKMEHrRILyWsMZufehU53A7iV6DIUv7TW9CKVxkTDUafHwMjYkbZZ6?=
 =?iso-8859-1?Q?A0+3Ig5LhpseHUOziBSBJMO99I1txxsBYlYr1k74HEIxpFUw/8uPsBiJKx?=
 =?iso-8859-1?Q?UdqQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(376014)(1800799024)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:00:37.7449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd7b4b1-6c5f-4541-69ae-08de5e97247e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8B.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6243
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69367-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: DF7C7A7689
X-Rspamd-Action: no action

From: Marc Zyngier <maz@kernel.org>

None of the registers we manage in the feature dependency infrastructure
so far has any RES1 bit. This is about to change, as VTCR_EL2 has
its bit 31 being RES1.

In order to not fail the consistency checks by not describing a bit,
add RES1 bits to the set of immutable bits. This requires some extra
surgery for the FGT handling, as we now need to track RES1 bits there
as well.

There are no RES1 FGT bits *yet*. Watch this space.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/config.c           | 25 +++++++-------
 arch/arm64/kvm/emulate-nested.c   | 55 +++++++++++++++++--------------
 3 files changed, 45 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index ac7f970c7883..b552a1e03848 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -638,6 +638,7 @@ struct fgt_masks {
 	u64		mask;
 	u64		nmask;
 	u64		res0;
+	u64		res1;
 };
=20
 extern struct fgt_masks hfgrtr_masks;
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 24bb3f36e9d5..3845b188551b 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -16,14 +16,14 @@
  */
 struct reg_bits_to_feat_map {
 	union {
-		u64	bits;
-		u64	*res0p;
+		u64		 bits;
+		struct fgt_masks *masks;
 	};
=20
 #define	NEVER_FGU	BIT(0)	/* Can trap, but never UNDEF */
 #define	CALL_FUNC	BIT(1)	/* Needs to evaluate tons of crap */
 #define	FIXED_VALUE	BIT(2)	/* RAZ/WI or RAO/WI in KVM */
-#define	RES0_POINTER	BIT(3)	/* Pointer to RES0 value instead of bits */
+#define	MASKS_POINTER	BIT(3)	/* Pointer to fgt_masks struct instead of bit=
s */
=20
 	unsigned long	flags;
=20
@@ -92,8 +92,8 @@ struct reg_feat_map_desc {
 #define NEEDS_FEAT_FIXED(m, ...)			\
 	__NEEDS_FEAT_FLAG(m, FIXED_VALUE, bits, __VA_ARGS__, 0)
=20
-#define NEEDS_FEAT_RES0(p, ...)				\
-	__NEEDS_FEAT_FLAG(p, RES0_POINTER, res0p, __VA_ARGS__)
+#define NEEDS_FEAT_MASKS(p, ...)				\
+	__NEEDS_FEAT_FLAG(p, MASKS_POINTER, masks, __VA_ARGS__)
=20
 /*
  * Declare the dependency between a set of bits and a set of features,
@@ -109,19 +109,20 @@ struct reg_feat_map_desc {
 #define DECLARE_FEAT_MAP(n, r, m, f)					\
 	struct reg_feat_map_desc n =3D {					\
 		.name			=3D #r,				\
-		.feat_map		=3D NEEDS_FEAT(~r##_RES0, f), 	\
+		.feat_map		=3D NEEDS_FEAT(~(r##_RES0 |	\
+						       r##_RES1), f),	\
 		.bit_feat_map		=3D m,				\
 		.bit_feat_map_sz	=3D ARRAY_SIZE(m),		\
 	}
=20
 /*
  * Specialised version of the above for FGT registers that have their
- * RES0 masks described as struct fgt_masks.
+ * RESx masks described as struct fgt_masks.
  */
 #define DECLARE_FEAT_MAP_FGT(n, msk, m, f)				\
 	struct reg_feat_map_desc n =3D {					\
 		.name			=3D #msk,				\
-		.feat_map		=3D NEEDS_FEAT_RES0(&msk.res0, f),\
+		.feat_map		=3D NEEDS_FEAT_MASKS(&msk, f),	\
 		.bit_feat_map		=3D m,				\
 		.bit_feat_map_sz	=3D ARRAY_SIZE(m),		\
 	}
@@ -1168,21 +1169,21 @@ static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_E=
L2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
=20
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
-				  int map_size, u64 res0, const char *str)
+				  int map_size, u64 resx, const char *str)
 {
 	u64 mask =3D 0;
=20
 	for (int i =3D 0; i < map_size; i++)
 		mask |=3D map[i].bits;
=20
-	if (mask !=3D ~res0)
+	if (mask !=3D ~resx)
 		kvm_err("Undefined %s behaviour, bits %016llx\n",
-			str, mask ^ ~res0);
+			str, mask ^ ~resx);
 }
=20
 static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
 {
-	return map->flags & RES0_POINTER ? ~(*map->res0p) : map->bits;
+	return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask=
) : map->bits;
 }
=20
 static void __init check_reg_desc(const struct reg_feat_map_desc *r)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 834f13fb1fb7..75d49f83342a 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2105,23 +2105,24 @@ static u32 encoding_next(u32 encoding)
 }
=20
 #define FGT_MASKS(__n, __m)						\
-	struct fgt_masks __n =3D { .str =3D #__m, .res0 =3D __m, }
-
-FGT_MASKS(hfgrtr_masks, HFGRTR_EL2_RES0);
-FGT_MASKS(hfgwtr_masks, HFGWTR_EL2_RES0);
-FGT_MASKS(hfgitr_masks, HFGITR_EL2_RES0);
-FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2_RES0);
-FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2_RES0);
-FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2_RES0);
-FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2_RES0);
-FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2_RES0);
-FGT_MASKS(hfgitr2_masks, HFGITR2_EL2_RES0);
-FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2_RES0);
-FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2_RES0);
+	struct fgt_masks __n =3D { .str =3D #__m, .res0 =3D __m ## _RES0, .res1 =
=3D __m ## _RES1 }
+
+FGT_MASKS(hfgrtr_masks, HFGRTR_EL2);
+FGT_MASKS(hfgwtr_masks, HFGWTR_EL2);
+FGT_MASKS(hfgitr_masks, HFGITR_EL2);
+FGT_MASKS(hdfgrtr_masks, HDFGRTR_EL2);
+FGT_MASKS(hdfgwtr_masks, HDFGWTR_EL2);
+FGT_MASKS(hafgrtr_masks, HAFGRTR_EL2);
+FGT_MASKS(hfgrtr2_masks, HFGRTR2_EL2);
+FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
+FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
+FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
+FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
 	struct fgt_masks *rmasks, *wmasks;
+	u64 rresx, wresx;
=20
 	switch (tc.fgt) {
 	case HFGRTR_GROUP:
@@ -2154,24 +2155,27 @@ static __init bool aggregate_fgt(union trap_config =
tc)
 		break;
 	}
=20
+	rresx =3D rmasks->res0 | rmasks->res1;
+	if (wmasks)
+		wresx =3D wmasks->res0 | wmasks->res1;
+
 	/*
 	 * A bit can be reserved in either the R or W register, but
 	 * not both.
 	 */
-	if ((BIT(tc.bit) & rmasks->res0) &&
-	    (!wmasks || (BIT(tc.bit) & wmasks->res0)))
+	if ((BIT(tc.bit) & rresx) && (!wmasks || (BIT(tc.bit) & wresx)))
 		return false;
=20
 	if (tc.pol)
-		rmasks->mask |=3D BIT(tc.bit) & ~rmasks->res0;
+		rmasks->mask |=3D BIT(tc.bit) & ~rresx;
 	else
-		rmasks->nmask |=3D BIT(tc.bit) & ~rmasks->res0;
+		rmasks->nmask |=3D BIT(tc.bit) & ~rresx;
=20
 	if (wmasks) {
 		if (tc.pol)
-			wmasks->mask |=3D BIT(tc.bit) & ~wmasks->res0;
+			wmasks->mask |=3D BIT(tc.bit) & ~wresx;
 		else
-			wmasks->nmask |=3D BIT(tc.bit) & ~wmasks->res0;
+			wmasks->nmask |=3D BIT(tc.bit) & ~wresx;
 	}
=20
 	return true;
@@ -2180,7 +2184,6 @@ static __init bool aggregate_fgt(union trap_config tc=
)
 static __init int check_fgt_masks(struct fgt_masks *masks)
 {
 	unsigned long duplicate =3D masks->mask & masks->nmask;
-	u64 res0 =3D masks->res0;
 	int ret =3D 0;
=20
 	if (duplicate) {
@@ -2194,10 +2197,14 @@ static __init int check_fgt_masks(struct fgt_masks =
*masks)
 		ret =3D -EINVAL;
 	}
=20
-	masks->res0 =3D ~(masks->mask | masks->nmask);
-	if (masks->res0 !=3D res0)
-		kvm_info("Implicit %s =3D %016llx, expecting %016llx\n",
-			 masks->str, masks->res0, res0);
+	if ((masks->res0 | masks->res1 | masks->mask | masks->nmask) !=3D GENMASK=
(63, 0) ||
+	    (masks->res0 & masks->res1)  || (masks->res0 & masks->mask) ||
+	    (masks->res0 & masks->nmask) || (masks->res1 & masks->mask)  ||
+	    (masks->res1 & masks->nmask) || (masks->mask & masks->nmask)) {
+		kvm_info("Inconsistent masks for %s (%016llx, %016llx, %016llx, %016llx)=
\n",
+			 masks->str, masks->res0, masks->res1, masks->mask, masks->nmask);
+		masks->res0 =3D ~(masks->res1 | masks->mask | masks->nmask);
+	}
=20
 	return ret;
 }
--=20
2.34.1

