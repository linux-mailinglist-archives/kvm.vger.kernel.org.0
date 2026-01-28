Return-Path: <kvm+bounces-69377-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBPLNJNPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69377-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:04:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 079C3A76E4
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:04:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8B2753002D09
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF93D330641;
	Wed, 28 Jan 2026 18:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mG/zRo/+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mG/zRo/+"
X-Original-To: kvm@vger.kernel.org
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010048.outbound.protection.outlook.com [52.101.84.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E7927FD4A
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.84.48
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623434; cv=fail; b=qdqaK8cqJhTVgxR+bnWxyNc1J5H8gRMRFDTe9N55wrt6aKp8ZZEKmTKDHr3n3D7ivshxnLisZ+IAjEu1JPNjx9Hdt6v9Ascs0QTR2W+fuI97TJYaGiI29adycJbsIDV+GTCkgcDBANQ/9kumQV/cCn8Wfy8gdZzdvSdwl8Ml4m4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623434; c=relaxed/simple;
	bh=FsCbp0WkGBTwAk+EgYJSZXKH7xGzxLdxUaEzo1MK4SU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mpaoI7k2PfigUNeOFyom1d4fv5HpO698x6x2pom50jtO11VK2VaJd7EBBfq+6mXbmSRvfIN0XCwj9wM1wPV1PA+MC52EOFTEz6EtKHUIx4MMVAEyBxFOEVF8VtpuIENKcpxWwansxoZCgMcpabOSDKvz4Lqk56acOm/rbeog4ZU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mG/zRo/+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mG/zRo/+; arc=fail smtp.client-ip=52.101.84.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=sNQLpB/k2SwPFSJftWgkz7OQaN7E5m6dtEb27Xc7boULscZgVCBgA62GCRdvxUbgka2wAL6SzkK/FHFskqPiV5nYuz0Oi9bH2ecii76qz9LOuMXoGMimAcnxbQRPjoc8hUNSCwbhQqm1RZZrUOd3Lg5omsKYlU1VpWPwSetTHbmd+Gns33uo9FrplUPGj9tDPZji7+gk+yFW9bDEuQeT/O6F/o1ZW0ZfYYvKRBgdqarSqTBO+rhQ3lhTU0PehnZ55N7QipC4N9tm8kCgoXU0ji6DWX7bRpGbrxlrxcbTnQnL/looHZNATDUUqQpUmIu2/fsSACpXz3/87sQN3kGdjw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jBgjITv3Up4PUzYVp6ueJSAxbAW4wNG/cGvaGPKNZ4=;
 b=iCwX3jBq9lL3VNkDq0JiHhAhPo6jc3kIbvf+T1kQ3IqsEf+TjtvFEZ0FvVIrxH46q4vNsuEGuRVPI38qHM6gOZRfwhkr90p2RVojCvIIYynXfHMsBrmUd0x6R1B+HDgA5+AQzOdoMleoqaZxf9T15Tm+KAuVnsJJVqsJ1s+lOBN3ZhySCEWpKn3sbO4w9z0TWKmvCNkIFExL0v1vNIIZVtVoOFnK9XdoGi+o5URUid9heZOOMWukPMJpOTr60cj6psNCH+tsbKP/KTHRoJRvD3p8qYx3D1GcKyZXCPG5IEXHjF0B28et5n45VezUY23kEBj9CrP7e620byuog0k9CQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jBgjITv3Up4PUzYVp6ueJSAxbAW4wNG/cGvaGPKNZ4=;
 b=mG/zRo/+3n5JEiAEgfwTMe0W3C/2SeiWmwZFPhD99Nk5SXBYX2qkErfZG6H7F0PsSXQcY3xRzFcRExrgOVB8ZVPw/nwpZo9zIoCU3v0O7rWZ636gcDeo4awMekUalTLPM5Uzq71dJfeBVahKd3hiw/mjXmToo9duu47nUjMQ1nE=
Received: from DU6P191CA0041.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53f::21)
 by GVXPR08MB10517.eurprd08.prod.outlook.com (2603:10a6:150:156::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:03:45 +0000
Received: from DU6PEPF00009523.eurprd02.prod.outlook.com
 (2603:10a6:10:53f:cafe::ce) by DU6P191CA0041.outlook.office365.com
 (2603:10a6:10:53f::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:03:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF00009523.mail.protection.outlook.com (10.167.8.4) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Wed, 28 Jan 2026 18:03:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w59q5nz0B+cQmE1PYHp0i5xomt7uGPgNTuYxdZDwhU73s4weg0mBdZfOYNwpaJv8SITLaD0InOflyugQQQKxf5Yquw04pRVawG44LHNMk6SkxsOiq3D8RFsODyoutVYueCpohuIEmyK/F8l3atVNZc+kp9V1iLMJ18ghRsxCUqU2gcom2TfZjnv+6BSlqKP02MlatTCMH5XmUHvN9Vztp0eDsTsDdJdjw69bE6yMpwQ19Y9MQJV9+d37IlGZ1Qpvzj1M9qnugEaPXsehn76KXnWonbRGwKEyfzLz9sY9736o6PNdgBxFipvzUKBM5R5LZnOO3M6azulgpGN9x88Vzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jBgjITv3Up4PUzYVp6ueJSAxbAW4wNG/cGvaGPKNZ4=;
 b=YAW/Xgci8HtNFnnrb8URESdk/r/VDhiKY0ECD4PXrJE5safeco+wiUj69Bctw9U9oz5/PfUBGl31aP5e9dOI7GYst7YkOEkMRYyMBH4zKBYoxzgWks1CLnAtVCPJmmHgis3sfxbh+UrnikzGbx4Grz5xQArMuCN6h1LjfSP1iRF3Wgdg2bPejQDpSMoGgckoyB+aQW2XgNVE4qbDZ/lPtl4aPj31wTEH0ELBhTTzhsniRKyJd8/lkgl5QDHjZRykZM+H2X4fpsXAUpVTRKc4ssR1Stfl9oMmQ5vxjSPCFv9WaSvmVAvSSt2Lmpsgy7ayXrOVNVcaOW43y8OZf51mkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jBgjITv3Up4PUzYVp6ueJSAxbAW4wNG/cGvaGPKNZ4=;
 b=mG/zRo/+3n5JEiAEgfwTMe0W3C/2SeiWmwZFPhD99Nk5SXBYX2qkErfZG6H7F0PsSXQcY3xRzFcRExrgOVB8ZVPw/nwpZo9zIoCU3v0O7rWZ636gcDeo4awMekUalTLPM5Uzq71dJfeBVahKd3hiw/mjXmToo9duu47nUjMQ1nE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:02:40 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:02:40 +0000
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
Subject: [PATCH v4 13/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Topic: [PATCH v4 13/36] KVM: arm64: gic-v5: Add emulation for
 ICC_IAFFIDR_EL1 accesses
Thread-Index: AQHckIBLm5n00kvFXEaQ0mTPmBjTAg==
Date: Wed, 28 Jan 2026 18:02:40 +0000
Message-ID: <20260128175919.3828384-14-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|DU6PEPF00009523:EE_|GVXPR08MB10517:EE_
X-MS-Office365-Filtering-Correlation-Id: cf6329e3-b83f-42ce-b2f3-08de5e979402
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Z4MTIU5GJO85NUK4BqfW31lRpxpIYxDoCW97vuNf8k9/6VtUL5M6bCzGwv?=
 =?iso-8859-1?Q?sWpEAs3QdmidCG8d/Mv1BfhaJsqUx0/ARua563fVt3b1M+CFhzONiOEGmh?=
 =?iso-8859-1?Q?hBs9NhxJOrBs5ME5IuQ5JUYwy4o9AmNe9bc2TCWcRK0DcfLVNiCNc7KZS3?=
 =?iso-8859-1?Q?jFo4mAjFrT9Z99COfokhY4zeUqikWiDhOiJPLj/H/FI2lp5L2u/yKpj3Qj?=
 =?iso-8859-1?Q?Jm+x86au2jGHF41P0UWDI0SSdj9P7Oagg1/go4HrkTNR1muo87YXcex6fH?=
 =?iso-8859-1?Q?5m7RS8mpYNGIHGGpS76MQzojqH4yIi8xYioaK0kpbQGO5qYNebDuOkRQxN?=
 =?iso-8859-1?Q?GQm9QILx/WHv5qYOdqTwxNv94QUQv7nMKGqvjcxutohZI2DfDJsbX+pTef?=
 =?iso-8859-1?Q?hPwbsw4CPVJUrjEmw8uJa1eepSgVdVkC16frN2Ei7gKxE3NEVjeLP0EBbQ?=
 =?iso-8859-1?Q?DJ4ClnJCDDeJhz0XflE4+60ACGbbxfvKaDcEtYFe9KG3gKRcciJpCMsRQh?=
 =?iso-8859-1?Q?H+4evMem4PWL4OGM2RXsasCAeIMZ3Od6pOPXtGsZI/BTfSYclIxJY9lGKv?=
 =?iso-8859-1?Q?RMLYHoZgvhYrYT4BzvnLaCsHpYJ8uexSURSFIMy8c8iUXIDgHe/ljjDgqt?=
 =?iso-8859-1?Q?6dct951mybbiGL2eQKGrid+oHTC5T9eJGyl2GlQEqZ+gTQHPLSrGx3SUOf?=
 =?iso-8859-1?Q?o+c8763hnxGGAMxYBBl4BxDB9+1NPGbqOQcj5BD4sEm8DTLlr5boReDDpK?=
 =?iso-8859-1?Q?MCwSHsIDixkFYsywTWeR7Av/kxaKEZ6+8W1TGTpyijurjkF6rJwUby/Aoa?=
 =?iso-8859-1?Q?k2PiBGWYpsKwZ6svdV7GLpc/uqi2q1BzrzzrsGd2nxGTCUQhexEPx1gCbC?=
 =?iso-8859-1?Q?2FtCOm1ZsbalkgWQG5Zeou+xWXRGxb1ZFbnqlGCtrqEFF3F+O2wSTUKdY7?=
 =?iso-8859-1?Q?OC6vXd8rqbrSYSFBJfDyA2wU///5FqUzM/lWP0SQhEQU8GOga0ZY83ZYOi?=
 =?iso-8859-1?Q?sLS/iEH3sGNQ3MBB/koqiT6j77Nxuco36jhk9GkJmeINAONqvLegE6J69i?=
 =?iso-8859-1?Q?hyOTKfRZGFdDP2sYoHQFFRgC0t2IPsxE6tSWyCStsOqoSR0f85XL1c7yYX?=
 =?iso-8859-1?Q?uIDlktjvJvGXeAVirieENR4BZiwlOjeTTjhd1OcxyHpW0M0IyxZc4wHlwO?=
 =?iso-8859-1?Q?cZsss61Np3OZywRhnHLT6esAhGZUau7jn+R8kcFhoz5uUcW5Ed6SpeiVzN?=
 =?iso-8859-1?Q?S753T/q2+3Pp8kxzT6szn6Df3sliDGSGmbRLAzgQF5WsNOSYbG9+6Q4RAF?=
 =?iso-8859-1?Q?5GzA3qbcQK7xQJP6f6qq4PgfT6yFCXw/2EAMdEf1FomPruknPtULTHXld6?=
 =?iso-8859-1?Q?BXojvXdyPYmVMKAgSJ1gfC/zXS18ojqWzIALRtkTRB8hPHB1eZVTxosQSC?=
 =?iso-8859-1?Q?uR8SikneobNPR2bxJg851zVT6KUuFGk7rW6NJnXE3NK168XENml5B/7pZb?=
 =?iso-8859-1?Q?wOxEIYyfHi+1//lYEAxKMAoeWBfVBCrOQ6hWrzeAcUWRACXdzUwTjbRwer?=
 =?iso-8859-1?Q?lRybrfOjATCK0SVeXbW5jaNmq0DZ2PgUwAF3+BL1ZetBAAL5xuCS1BCtr2?=
 =?iso-8859-1?Q?lDuYNVY0AIpXDgz5O2uy8weXh8wB837sD7lZz3tjLV59CSuga2CFu7qJQL?=
 =?iso-8859-1?Q?bvJf5tjT+PCXOkmDZO0=3D?=
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
 DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a623ce60-9798-4691-3434-08de5e976d92
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|35042699022|36860700013|14060799003|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?+X4K5zZ4V3e0qofwhftLJNQWlDJTFOYM2QJMn508LbclJDceJ2v61kdH4P?=
 =?iso-8859-1?Q?hviXFa8D4uUuywEVRWFZsKsC8rUaOvTMbHwZp6+5YHtKxXLX/53Kg8YgKu?=
 =?iso-8859-1?Q?/gHwKHzXakogvnt7T6dxdoFNDIhMeZAzbG4GI44OAuTRlKzz5ad8YY+xVQ?=
 =?iso-8859-1?Q?YnU/5SJEbj2CYnLXGN3Cwz+hyXtumzvg4XAJkaT1flIkwAJA9YLtrigTsK?=
 =?iso-8859-1?Q?MsugGRP6IUlWCbZVlwCpwxS7iMuK4JAtNrg3V6SclT0divc0uVzU6TS0r1?=
 =?iso-8859-1?Q?u6/9Oiv2t8wu9ZGb/atu8nBcyspznKtJs2eGz8mbqk0IEpGIoKd2Pnq2pN?=
 =?iso-8859-1?Q?KjxBhwYDUQQW2E5qEDT8VSQ3poiOprWQW9Vz7d8dBgY3h06FzjZv0cQoU0?=
 =?iso-8859-1?Q?Fl/Z+RD4+FZ4PFlfqSI+MmBnWXMdiURCv/JsRS5D093qMWcTRY4QY0c736?=
 =?iso-8859-1?Q?08fOZyZXMygnjQq6xGNKxKD79FLKXJB6V3oq/Zv3Miyk86ug6dAshMzD00?=
 =?iso-8859-1?Q?nqxIB+XIrycW28wzzd4Qo62Rj5rG5tJwYO3PX6Mfp0pJCN00cVR6VQiaW5?=
 =?iso-8859-1?Q?oVSsbiI/Z6K5RGdKIsikgxCc9IbhsZWQrppO/R497xup1bkji0zK+rj6yq?=
 =?iso-8859-1?Q?td/LcJED3ZiiI3OnN7o+HAZYezGOqVhg2WZ+ppKEmmGeicnA4jbGTFykoC?=
 =?iso-8859-1?Q?bwqsmyHoIdaBSlBimKB2832/yWnG5GC/X3hzkFimoLjDT4rxAN3xWazxQc?=
 =?iso-8859-1?Q?8+VdXGt6gWxhhyjwkjBAuXOvFgu3q762pSy2CUN0QNE7Ar5spA/vBPv/At?=
 =?iso-8859-1?Q?iPaqK2E7BzU+tvELpZFSWVGI6VGHkl+ys1e991O+cMYwgt9TLjj16o0r4P?=
 =?iso-8859-1?Q?6M0ZGiSY6iG3fujtG1yEdXsYIQQ8N8qGfN67DO0BNWBGYQLBN+fI5oEFrn?=
 =?iso-8859-1?Q?MiGAxYHioDxbP420sCpTkkOvyG7rlBOgN6a4s65mbTtNlY/Y+xQQStrMQp?=
 =?iso-8859-1?Q?D9cB9P+o1gls8O/aNe0W8Sbn1iLuUMDwXiMR8k9Cc/woAhneyVEdjpoGgC?=
 =?iso-8859-1?Q?3RL+wAQZoVhy8p55ohRF/lGsRz2yhUJ32ukWufxJWdwZ7YpWjsHFJm0TJ8?=
 =?iso-8859-1?Q?tSx+LK99221vG/3bT/opy/PEyUT4dfFYgX9/sXzkjdT/BGkAaJPN/U55kz?=
 =?iso-8859-1?Q?XQtOkOdKfB30ymbfWU/zqAt+bizHv2XgHV1GXEXEPKiYYyM42aJG4GZxu7?=
 =?iso-8859-1?Q?ujIHfTMDol4AAqKxGImHox17OIRrUJlwd+xc5MIE1HDybCASAZwlN2p5EZ?=
 =?iso-8859-1?Q?Ssm73l7xhOVxXyA1DXTCGwhxTZhQ/kgNUvMOWszukR9wMzBxJB/M1SRD3X?=
 =?iso-8859-1?Q?wItOZXcvGMiCJcaP1rmlMCdcJfUqEG+VeqflcaVq9aht1/gA1KcIkbA3Gk?=
 =?iso-8859-1?Q?apV+NJZDJNDA9cR8G+b7POj7Nq6GVhNUUkiJHlD5rCCzz5S4XqGS6oPw7r?=
 =?iso-8859-1?Q?S9oWgh7W8ryUT0XA9hGI7eYHWRqavvtvH3a6rGakd3Hk5ta+NqMXIKnAv9?=
 =?iso-8859-1?Q?4/SWTk+tLDLI2RIzsJk/Wo4TLQ99hi9KWhbNqbxtLSN5M4zOQNbEjMDjYZ?=
 =?iso-8859-1?Q?fHrO6+5YmuA96kwWClASl6eJ5NrL5x+d5jyUiWuYYij+X0Tfvz11WTVsik?=
 =?iso-8859-1?Q?x8bW5DWoxVM3mokjasYMG9TUE5iLLKLxY0+aSJXmTNP6C95tAdoeoz4qFY?=
 =?iso-8859-1?Q?m2RQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(35042699022)(36860700013)(14060799003)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:03:44.8478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf6329e3-b83f-42ce-b2f3-08de5e979402
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF00009523.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10517
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69377-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:email,arm.com:dkim,arm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 079C3A76E4
X-Rspamd-Action: no action

GICv5 doesn't provide an ICV_IAFFIDR_EL1 or ICH_IAFFIDR_EL2 for
providing the IAFFID to the guest. A guest access to the
ICC_IAFFIDR_EL1 must therefore be trapped and emulated to avoid the
guest accessing the host's ICC_IAFFIDR_EL1.

The virtual IAFFID is provided to the guest when it reads
ICC_IAFFIDR_EL1 (which always traps back to the hypervisor). Writes are
rightly ignored. KVM treats the GICv5 VPEID, the virtual IAFFID, and
the vcpu_id as the same, and so the vcpu_id is returned.

The trapping for the ICC_IAFFIDR_EL1 is always enabled when in a guest
context.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/config.c   | 10 +++++++++-
 arch/arm64/kvm/sys_regs.c | 16 ++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 6e8ec127c0ce..79e8d6e3b5f8 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1582,6 +1582,14 @@ static void __compute_hdfgwtr(struct kvm_vcpu *vcpu)
 		*vcpu_fgt(vcpu, HDFGWTR_EL2) |=3D HDFGWTR_EL2_MDSCR_EL1;
 }
=20
+static void __compute_ich_hfgrtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+
+	/* ICC_IAFFIDR_EL1 *always* needs to be trapped when running a guest */
+	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1603,7 +1611,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	}
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
-		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_ich_hfgrtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8d017844ab5f..1f347c4552eb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -681,6 +681,21 @@ static bool access_gic_dir(struct kvm_vcpu *vcpu,
 	return true;
 }
=20
+static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu, struct sys_reg_para=
ms *p,
+				const struct sys_reg_desc *r)
+{
+	if (p->is_write)
+		return ignore_write(vcpu, p);
+
+	/*
+	 * For GICv5 VMs, the IAFFID value is the same as the VPE ID. The VPE ID
+	 * is the same as the VCPU's ID.
+	 */
+	p->regval =3D FIELD_PREP(ICC_IAFFIDR_EL1_IAFFID, vcpu->vcpu_id);
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3414,6 +3429,7 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R1_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
+	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1

