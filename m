Return-Path: <kvm+bounces-69388-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDFREgRSemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69388-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69204A797A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C77473043000
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE23378800;
	Wed, 28 Jan 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HZNAFPHB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HZNAFPHB"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013026.outbound.protection.outlook.com [40.107.162.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57CB3783B4
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.26
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623571; cv=fail; b=Ufl7CCyeDuWWeMQbLXlAya3hjgMVDJ6eV+k2JvWfvFpBEPvnwvCEMHW+atsUZxuc02C4L0zJfF+9FS4tYTDMkxO9UGmmohu7HFg4p2uZwSmOnl0sCFA3oVeoFc4U7x7ReiQMzqp0Itx7XsHzcjTuaSIWlHCwzNbc3XmxDfvoU3U=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623571; c=relaxed/simple;
	bh=2e0rZL8viFw+cG2M3SNSa4T/hXO3cYrfKQ/viBbQ1Fg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FVBLzNraPu06UZrh54oYj2gtvjbIBH/0Ng86xdLMDH6drqr/YrVadMEKSnwjZ/vnm9e398K0R5ve1c9/+c66yqzgbhL9G+PBYmhhaw+l6s2UU+0XpBcFLKzSc4Z9qnhNSXhVGBCV98QDrNwHZaQpFaweH/VnLeP94jJl7VpU6uA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HZNAFPHB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HZNAFPHB; arc=fail smtp.client-ip=40.107.162.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=dEyzvTAxCQ7LYMXF5n1aI2mQg7EWEFBaSV7LIJAE+PrVzNj7V9vI1JNIfA31xuxePqjiMQitlq0GBqtmiWNeIngyvZgdo8YVoufJuIikgcJfEQFuezPBqGhOg8nlx70Lit1v4ZE0pEaHVKOHq9CEV7Haerr0plb6eEsSb7ykzqcv5tcQ1XXeeXqV6eDGajrMEd7fZ0MGq/f78T3Qne61MEcyob32w7t2JPMP37kmDlYGGeg7Q0Pp+ZHGzp6yEJEEgGSotFqxRsSmpTgtt+vjaTlq/RzmYVFSINOetmfr4jkllpzTLKwbUF5yRg45U8dRJxZ8zmfBgR7VBTTJ4HXivg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BBu9G5J39iOBGxN0sc6mUXW6N7euUmZIv8Ulpxtm6jw=;
 b=LsZYnrNyShCxZucjA9J+D/Tiit3OMjUWzCXnK8xYphhlZLtaJyShMPIb6e2rZPJTXxFmioZsqODezGoEUAIcTlDbK8YX9y7Br7d0TaHh3aXvxYonOY75TRC3uWEsSZ7Zhj0MirjpJMd61hcIJaDdVUW/EhvYYouJr7QV+CfvO2xcybk9nChUrZGGn/zt3KeE5B8wKJ9BePPxUmT51yAYs11kA3MoCpVHm2DRb/Hmupwm8Zj+WPITi+6hYboBbcWRM/l3feYR7YzX5kng9II01CKxbm4yu5v+KhSc2SRtZWfrw4P2BsLsj9tDzqTUCI1Lm4+h7NkSBX+vWQwnX9ERAg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBu9G5J39iOBGxN0sc6mUXW6N7euUmZIv8Ulpxtm6jw=;
 b=HZNAFPHBhdLP3qquGCvhfvMh+ql3NfEYUZeAhdtPGpMZskiMqaB80Oqb0gLCSmWsA+y44btsKEvyke7rB1+epZ3vJuzipEdbtMhf2B4ocVBvuXvhFhm1uweIqeN3dtlrQoJKIEinZOSkJ1lknCVItPL1wlma+ijuWhRDRQus/zM=
Received: from AS4P191CA0029.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::12)
 by AS8PR08MB9429.eurprd08.prod.outlook.com (2603:10a6:20b:5ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:06:03 +0000
Received: from AM2PEPF0001C70A.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::b4) by AS4P191CA0029.outlook.office365.com
 (2603:10a6:20b:5d9::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:06:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70A.mail.protection.outlook.com (10.167.16.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:06:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=on+ON1uMlKXb/FcK0azF7Z0risXFg7ifPI59+RBTws2qn7MH2HEzdkkb9Pw3B0QuasPmFR84q3Ha3cyIgURK5ebS+2PfpbE49EoxL5KGKeZMqSBVPldBCzV8i7/voPPI2rplCOKsBoLo8Li8uKdAZxeD2vy4+5lKgxDWevKT+LoOnNvqXLq43W20FabaEx0WaQtcWnSjyEi7IHpEHvAWfAEMYcDjEARZZJZZskwp8D2gvKz63WleD3RP9ewk2WCQUUyeE4otDhqt/BI0igANQRRcChoqKLe6yo5KlcY3SN16x2bwlNpiY0V1NCldqSJ0XjaGc/XVYRs5i3QTVnOh4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BBu9G5J39iOBGxN0sc6mUXW6N7euUmZIv8Ulpxtm6jw=;
 b=HGosecjVpe12+KBdpXtiySQS48kVf37bwASZPi/j2yQS29HjymZZkqsVAu1HJj2iaOiVB8gusc4DNJeDvLhoC8+e1jr+umh0YPoqpKBEJ/ApRNnDBxU+v6SREQsMtMO+UgCLzt245lGBVs2/1beyOUc2JDiWixI4qS0Sd4WvbIpF/h7CI5/vuClFZJDfOixywVk0Emy60v8BZLyRXiy8xZsgCQY0PcVUkXImI50u5NjByNCLhdnBqYz4q5zLXJzheMkItxicmQyPSnfAoZOG2tHtCEo+GBEARS0dy9lYSXc4oFLtalM0UKBBzEbIJH9o1X8m+atyoVsMZJVf0Cm0DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BBu9G5J39iOBGxN0sc6mUXW6N7euUmZIv8Ulpxtm6jw=;
 b=HZNAFPHBhdLP3qquGCvhfvMh+ql3NfEYUZeAhdtPGpMZskiMqaB80Oqb0gLCSmWsA+y44btsKEvyke7rB1+epZ3vJuzipEdbtMhf2B4ocVBvuXvhFhm1uweIqeN3dtlrQoJKIEinZOSkJ1lknCVItPL1wlma+ijuWhRDRQus/zM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:04:59 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:04:59 +0000
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
Subject: [PATCH v4 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Topic: [PATCH v4 22/36] KVM: arm64: gic-v5: Trap and mask guest
 ICC_PPI_ENABLERx_EL1 writes
Thread-Index: AQHckICdkasX1nFvI0+w/dVXtlPPEA==
Date: Wed, 28 Jan 2026 18:04:59 +0000
Message-ID: <20260128175919.3828384-23-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|AM2PEPF0001C70A:EE_|AS8PR08MB9429:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e44945f-5cbe-4656-a8d9-08de5e97e65e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?8EqBZJRGepg0DUpCZtQ24buhT8tRdRawVIjB7tvhTvQcRtRIqjlFORIDgV?=
 =?iso-8859-1?Q?bkxhNLD6cbL7e7yMZ2E3Dct1H51DYA377f5daEfNaOZkKs0NDnMIZH6I4I?=
 =?iso-8859-1?Q?97ziWp+PsMXdzna3dO1JCeubmgZn1xVJvIqBG4g4GkDEwFXaom5OepueQw?=
 =?iso-8859-1?Q?Mrj5xGqVujcZcBchUaB1IGCxrN4uhVbv46APM4Pk+fo0AUdDjqUTA0hUYv?=
 =?iso-8859-1?Q?VXAcL7cs27PaMwvgVnzzK2GQL5aUIIr0FOUrUkQoFhuG0poWsnvdxNirY+?=
 =?iso-8859-1?Q?3iGHXlJptK1wTFq9JG7SuItSuFcXahnbaJfu81+cu3gAlJ7DiZnnnEzoBw?=
 =?iso-8859-1?Q?ZrM3y8tgvff/R98KuyhqQOvhLB+NVgVWXvtIF1iGRxO+5TVZfCURli7vnt?=
 =?iso-8859-1?Q?wpiw/yVr5QxVEguO4W7AYvoZScJ4SbJNtyzZtDVQLyInvD2mr1mjzf8gv6?=
 =?iso-8859-1?Q?Rvc/CYrpkYabSBYugoYFCAJKv2/GuSDxS66Gq0U392Yl9OYZeznYEDdlrA?=
 =?iso-8859-1?Q?7tHEPkCnBSnT9+NZpvMtwcDXJKZKFrDYwYk5sEK1Tx0xivl52zKcYGB0EH?=
 =?iso-8859-1?Q?Q8KM5HlBK37ibp0s8GTN7GSXYaN3OPK+PpaLbXI+7DA2yZ3g63zOULZTKN?=
 =?iso-8859-1?Q?ZuLibHhcQOdTpkDW/73MOyFZaJCqqlMHOzc+U6CF/2K8RbJlfBRxo/YOUR?=
 =?iso-8859-1?Q?wbxmKAy37h7aT6/jZkIgLlzdx9gDsEiiO3aHCyWFjikIJy+QFgg/NnVCFq?=
 =?iso-8859-1?Q?234oliFZii2DEBtT+D/VcxaiH0SUBTgOvjlVWC/a42isyJIMWgkk5ejWVm?=
 =?iso-8859-1?Q?T6SMHOwWsjPl3vEKONJP+LpbYAASOJ4EOv89doE7dNXLF0qItC60VIZkLB?=
 =?iso-8859-1?Q?gj7GVLJDf4mk3DxvFd66TlZ7vcrkVxI4uZijskhckhYgxeXVBN/oJJDjEf?=
 =?iso-8859-1?Q?cOKQqcCainMMpOApz0sZIOcC3qvGgYO5XBsMO59nh6890j6rH8CmZ0Hirb?=
 =?iso-8859-1?Q?zw3hcIT9ThqYbWBEP9K7Gz/6a8wfXKUSK2hAfxZJ487/a3VNfOGsZS+Iq9?=
 =?iso-8859-1?Q?IKmEXpWS55QE0mIHuUnV+Hq1vtH7liELevNRuwZQvbPfef+MXyhAIUOPjV?=
 =?iso-8859-1?Q?AdcHlqX6N1DqDs/fAtxrNRBjF2BOghkWJTFbZ1A+vwJVDfV//GGoyBSTZo?=
 =?iso-8859-1?Q?xV1Ra+d43Bjm46czo86ZgT2nU4WZS3RYX3gTlv6k/eywCocIJymSQ2VH7W?=
 =?iso-8859-1?Q?G0qC6NdqlVBAJj9EzinIrC8COK43RHfaUp4pmxK5mORuHKa/+Zqg5uRGCM?=
 =?iso-8859-1?Q?tP7mOudFfQeSqKerCnxhuls7NHKqGCL6uUaqLMVvxoQQNMxKWmsQJlTifo?=
 =?iso-8859-1?Q?fv1GtLS9JShIs4FUKHJJcV2xCO4keP8kVuz8s8UOpoFItjcM5W270sJ7yZ?=
 =?iso-8859-1?Q?4b0EyrCAEdvW4Yx5Hp0So2mmKkAsYv0FIMomLLv506v+xiHgCL1qNsCGOL?=
 =?iso-8859-1?Q?iWE5enNmd8ii16zTpWQVwC9G39krH6WCA7pYlTkUC/r0cu9BoOonID8L3y?=
 =?iso-8859-1?Q?E53LC+41fQtzyqXHtEaWlnVbWfcma+obqzaCbvms3Kw+f5tw06rQso3Gk2?=
 =?iso-8859-1?Q?Nwr+wor/gfZQtq8024qBTsa2QDPHhoWYvkGzvTpUVGofgOkeAMoJjS0ZAg?=
 =?iso-8859-1?Q?xWtrZcyIIdlMH4sI2G4=3D?=
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
 AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	18b74293-8fbb-46e8-98df-08de5e97c060
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?cidIaxwqAGdXtBBpG5P+/nbS13hs4Y/VZ9Hz5kArlHA54jUuVEJU/Ie+FN?=
 =?iso-8859-1?Q?8hJJdZNZFk1pPcbNfJ+KdhGjxN656bl75zm41pTidgaNdC4GzO1T6gKuiw?=
 =?iso-8859-1?Q?bsjVSzMCHE5ol8YeV2WPxG+qsO14n6uuPu6BSmR30e9SnL0CPExfcuN0WB?=
 =?iso-8859-1?Q?UruqzterPEuJ7hazTCMvBTxdPxElyWJNG346HMBYaPaQVGcrnE2Xa8562b?=
 =?iso-8859-1?Q?QoVpqPiNtzIu7/DS+o5zZjjbY+Y52mpnE7ZfKdkCtzXw6+lkW9sVSBj82b?=
 =?iso-8859-1?Q?uw7tSJxTh3JRX1IaU+iK77+syvfqQ3UEZ7w34S4IuzbWdymuqoB/AZfFLJ?=
 =?iso-8859-1?Q?jIMpF7/wqHsfpT+zeKUfhP0i0qsuwuk2i7LnqWEwt4PrfBtoVQgrMj/nMH?=
 =?iso-8859-1?Q?ff3wnUSlHLQoORP41pwK8oViR6wjJZKJ/T628fMLmyGGVj+RwUYZvuUjH2?=
 =?iso-8859-1?Q?T0boEe9EZ98w8bgBQqbHONo6G9fI9T1eC1V6iaagPX45/AByWOSvF55tcj?=
 =?iso-8859-1?Q?24QU57wRiKQ92dAh/QnX9sCEKtQNWN3GGXffy9KdkK1zHySjlv4K+woe02?=
 =?iso-8859-1?Q?pL4jXxdAVdtAhQBr/LE09t7opWrQkmmSL3rsLpueW6DIC/OQDMZ5tNOTc3?=
 =?iso-8859-1?Q?uLRSr1gYqkagWMqCfBiV+21M3f9SnkgRYmo+VP31xIxji8HSmWw+fSeAxR?=
 =?iso-8859-1?Q?hFz5dW0vAyjKuUqmsK8nxMLWgK/ncnpwFmmjMg2zvUMNxBxN6DbwulwDIX?=
 =?iso-8859-1?Q?BR6Xb4lZ9H5VRAshFW6fSmkdSxZYOZ0Csko5fLOHTpLkgFR1lPTyb6ThIM?=
 =?iso-8859-1?Q?QazvQpXUgm2X5lePTjpBHPELto0vH4IpFmobgmPD6cumYm+LqXFagQoF2e?=
 =?iso-8859-1?Q?skcG0SDi9By3DQsBZrwa7tYz7sEGLEbAa4zrw074uHUDVYrPJlgTjbEbDf?=
 =?iso-8859-1?Q?OKbp5vj57ONQnQdM0E1UYEDfS2aGohnK6jbfG6GsyNbM39oTLGerKn2oDX?=
 =?iso-8859-1?Q?XeF5oC0BX35QkTDie0n7X2o4jAD2rNaCOL+npXZRkfHh+ET2hFASk/4Jvb?=
 =?iso-8859-1?Q?fxXE/YuJOvXPy1p2GC0FaR9xf3U6NZeS8Frd7P/Ji+0BFpPkZm0vvcX8TN?=
 =?iso-8859-1?Q?nXzwKCavIDfZXn/Jh1CcyE+Cm/we5sr43GxHu2Keqdd2LGYG9d1X//ffEb?=
 =?iso-8859-1?Q?JKag0Dn4jYX9BmhArxOMdQOAavmBmkMJtybtJSKxeteO2a8VbSSg2goAqF?=
 =?iso-8859-1?Q?XgM72+o/vMbhSHqyPaR5E2rwnlxqJ417uXPAQoXilEZyTmfrTYRGzvKGd5?=
 =?iso-8859-1?Q?DZ1Cx+Yhmx0+QPPZmy6Xog7N+q4/LOlUwioN3G8FGRhiwIbmN2Q7P0+cnO?=
 =?iso-8859-1?Q?awlfN+s6VIijaUjq5sUA7eO9dTB0zmJLevaGl2MSPJBeKVbK1yVHDFiIjP?=
 =?iso-8859-1?Q?ynU1RyEXhV/Y1nb6LLgaUa0ihyCWguzqHka/Zsg9ScJpEfNeeZcZkX9t8e?=
 =?iso-8859-1?Q?cB1/V23HRf8fksyjeW5r6GrvVXc3MfvLYZEoYCmgThUMuDAAZ5SM+/JQwW?=
 =?iso-8859-1?Q?L5iOOk/Wt6fNF0qsZ0MpC4enib9AYJ3P4pRi7xQtjwu/VnE3yvVmnUXnVv?=
 =?iso-8859-1?Q?jAWpp9aorIAW0yuUhsjcqoxFqW8VISLCW9GTIncmnPvoUG9QdjjJlB0d37?=
 =?iso-8859-1?Q?VC/Mo8vg0kr6ZPiwS+NOGc8T5ex3tWX4yF2F35vCVhsxVZ252jcBDh+mAw?=
 =?iso-8859-1?Q?XA9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:06:03.0197
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e44945f-5cbe-4656-a8d9-08de5e97e65e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9429
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69388-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 69204A797A
X-Rspamd-Action: no action

A guest should not be able to detect if a PPI that is not exposed to
the guest is implemented or not. Avoid the guest enabling any PPIs
that are not implemented as far as the guest is concerned by trapping
and masking writes to the two ICC_PPI_ENABLERx_EL1 registers.

When a guest writes these registers, the write is masked with the set
of PPIs actually exposed to the guest, and the state is written back
to KVM's shadow state. As there is now no way for the guest to change
the PPI enable state without it being trapped, saving of the PPI
Enable state is dropped from guest exit.

Reads for the above registers are not masked. When the guest is
running and reads from the above registers, it is presented with what
KVM provides in the ICH_PPI_ENABLERx_EL2 registers, which is the
masked version of what the guest last wrote.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/config.c           | 13 +++++++++-
 arch/arm64/kvm/hyp/vgic-v5-sr.c   |  3 ---
 arch/arm64/kvm/sys_regs.c         | 40 +++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index b49820d05e6c..0c7ac0f0a182 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -788,7 +788,6 @@ struct kvm_host_data {
=20
 		/* The saved state of the regs when leaving the guest */
 		u64 activer_exit[2];
-		u64 enabler_exit[2];
 	} vgic_v5_ppi_state;
 };
=20
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 79e8d6e3b5f8..29e798785342 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1590,6 +1590,17 @@ static void __compute_ich_hfgrtr(struct kvm_vcpu *vc=
pu)
 	*vcpu_fgt(vcpu, ICH_HFGRTR_EL2) &=3D ~ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1;
 }
=20
+static void __compute_ich_hfgwtr(struct kvm_vcpu *vcpu)
+{
+	__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+
+	/*
+	 * We present a different subset of PPIs the guest from what
+	 * exist in real hardware. We only trap writes, not reads.
+	 */
+	*vcpu_fgt(vcpu, ICH_HFGWTR_EL2) &=3D ~(ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL=
1);
+}
+
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 {
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
@@ -1612,7 +1623,7 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
=20
 	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
 		__compute_ich_hfgrtr(vcpu);
-		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_ich_hfgwtr(vcpu);
 		__compute_fgt(vcpu, ICH_HFGITR_EL2);
 	}
 }
diff --git a/arch/arm64/kvm/hyp/vgic-v5-sr.c b/arch/arm64/kvm/hyp/vgic-v5-s=
r.c
index 47c71c53fcb1..4d20b9003171 100644
--- a/arch/arm64/kvm/hyp/vgic-v5-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v5-sr.c
@@ -31,9 +31,6 @@ void __vgic_v5_save_ppi_state(struct vgic_v5_cpu_if *cpu_=
if)
 	host_data_ptr(vgic_v5_ppi_state)->activer_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER0_EL2);
 	host_data_ptr(vgic_v5_ppi_state)->activer_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ACTIVER1_EL2);
=20
-	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[0] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER0_EL2);
-	host_data_ptr(vgic_v5_ppi_state)->enabler_exit[1] =3D read_sysreg_s(SYS_I=
CH_PPI_ENABLER1_EL2);
-
 	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[0] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR0_EL2);
 	host_data_ptr(vgic_v5_ppi_state)->pendr_exit[1] =3D read_sysreg_s(SYS_ICH=
_PPI_PENDR1_EL2);
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1f347c4552eb..1bcb6178b67b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -696,6 +696,44 @@ static bool access_gicv5_iaffid(struct kvm_vcpu *vcpu,=
 struct sys_reg_params *p,
 	return true;
 }
=20
+static bool access_gicv5_ppi_enabler(struct kvm_vcpu *vcpu,
+				     struct sys_reg_params *p,
+				     const struct sys_reg_desc *r)
+{
+	u64 mask =3D vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[p->Op2 % 2];
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	unsigned long bm_p =3D 0;
+	u64 masked_write;
+	int i;
+
+	/* We never expect to get here with a read! */
+	if (WARN_ON_ONCE(!p->is_write))
+		return undef_access(vcpu, p, r);
+
+	masked_write =3D p->regval & mask;
+	cpu_if->vgic_ppi_enabler[p->Op2 % 2] =3D masked_write;
+
+	bitmap_from_arr64(&bm_p, &mask, 64);
+
+	/* Sync the change in enable states to the vgic_irqs */
+	for_each_set_bit(i, &bm_p, 64) {
+		struct vgic_irq *irq;
+		u32 intid;
+
+		intid =3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		intid |=3D FIELD_PREP(GICV5_HWIRQ_ID, (p->Op2 % 2) * 64 + i);
+
+		irq =3D vgic_get_vcpu_irq(vcpu, intid);
+
+		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
+			irq->enabled =3D !!(masked_write & BIT(i));
+
+		vgic_put_irq(vcpu->kvm, irq);
+	}
+
+	return true;
+}
+
 static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -3430,6 +3468,8 @@ static const struct sys_reg_desc sys_reg_descs[] =3D =
{
 	{ SYS_DESC(SYS_ICC_AP1R2_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_AP1R3_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_IAFFIDR_EL1), access_gicv5_iaffid },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER0_EL1), access_gicv5_ppi_enabler },
+	{ SYS_DESC(SYS_ICC_PPI_ENABLER1_EL1), access_gicv5_ppi_enabler },
 	{ SYS_DESC(SYS_ICC_DIR_EL1), access_gic_dir },
 	{ SYS_DESC(SYS_ICC_RPR_EL1), undef_access },
 	{ SYS_DESC(SYS_ICC_SGI1R_EL1), access_gic_sgi },
--=20
2.34.1

