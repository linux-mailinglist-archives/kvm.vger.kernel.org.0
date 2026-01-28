Return-Path: <kvm+bounces-69368-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cN4zLUVPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69368-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:02:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FC49A76A8
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:02:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5963D302DF61
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A908B371059;
	Wed, 28 Jan 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I16lfvCr";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="I16lfvCr"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011067.outbound.protection.outlook.com [52.101.65.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E36284890
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623264; cv=fail; b=k7Dfh0oGtpygX9FhUxGe4+tlfen30yaWG+iwa8hMB+NuUBMOzuAVXTpBv4oVQPXb9VS/4ls6fY8ZOIKhhog8yvoV07aWxOfLlIUBpXO4WzbtUoCKZs+xlpLwSkIwKFdS1qzdUmrlSlbly3OU4s14kzRlnr1jocex8IjRl8sNZxM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623264; c=relaxed/simple;
	bh=KyGPfe6KXEB0P1aukHpULSnNRb0sXONmZsS0pgEIICM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HjAKgU8UOkV6UO3CXvIGI/ij5XIFs/VKN+J2XQjAYcObSm9ceuN/x/xDQolarajGCay+0NodPhYnmy8T9ebBqLqEBYZjr2LZL1eaVvgXDsxOhwRyp4+XdzYafZX3Se5nnG6sjCHeuOWmSnmTSZBX83ZtKhOLfaTgcjQxxTYY324=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I16lfvCr; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=I16lfvCr; arc=fail smtp.client-ip=52.101.65.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=wLl8UkjYJPsaRU01d95WyHByelAe+36URvBzZemhGQNsZ9p+NWIxockPy2+YbJ6D7D2gGR4/sb9jHcrVUO+sQeTMKeGB6Bjzpol27nnbwTmrDVyRSLuLiirCi1DpDY8A6mTIHmwU2pW/iI+Do4puhsrenfnQuZ3JQcT9nDR/dCgb50gpxeVrO84oJ5DWnXXzhPfYPRtQQXlHm558YW5xtllABTf2QGFmDLFb2AZikRe0VJ9RHaXNry0HJSCh55pY9jnLNA85ycJoPW8emhMvSU5ofY5m9oBl3TrKPr94jtWQ0/RlK8F4YAvf8tAd7unqrPgQfY/e48CiH59h79OK+w==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVwFxJstObeZm4hLrlzsstf+CgrSngxKkqzr2SZDJ7A=;
 b=ipXTSiNP4dJg8fN/nhCn/FZTp+Kauxk7Gmw+w++5/OT0fjSxZNy0UUUoBZ6bFNbBj1QoPvMOS/WHiEH5AbS67o3HZPFTye3Z9EuAT/djbuShEuPry4mtAJOZCNQISir4ZcZI9n4iKG6VKKkrZbaspoOGgaWzejOhKOlFuqeyCu06JuhOCGPxZxKvLlexF56xzr8KaByVXH8iIbPaa24cmaQnb4RcxeWVhqijbuFp33tzdRgd/ddbIKRSZ5y2pa9iFUu2f7g4O5hp4v5CPXt2NsYX7nnUR+l6a75O4kIZ7B/cNCYslQpLQz9v2D5tzgEI/UIiLKWhrhv0KD4Mo6tXVg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVwFxJstObeZm4hLrlzsstf+CgrSngxKkqzr2SZDJ7A=;
 b=I16lfvCr4TDIkxC4HxHWHGqfImMKgOlpuoTalhUkZpMtoNo1D3B01Ip1qk7tHXL7kNcx9JzbQ2vBvcBv/GtQGpY32h/SbmadSXr4GNm+cX8ss2GisOkpIEIrv3g9MMZgBOjzv9Yr4hiGJNkte4Wsgpc0wlUBjJ0BFsPevKrqXLA=
Received: from AS4P191CA0020.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::8)
 by AMDPR08MB11527.eurprd08.prod.outlook.com (2603:10a6:20b:716::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:00:53 +0000
Received: from AMS1EPF0000004C.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::8b) by AS4P191CA0020.outlook.office365.com
 (2603:10a6:20b:5d9::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:00:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000004C.mail.protection.outlook.com (10.167.16.137) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lneMBIPc/1dBOU+tNSr9brzsahyr/P7Acg1Rlg2pYniRXXfypea7yOWwEMPF4Ww32npnC6w/JvI5P9KDnMZVe3OQhWwmEdXYwIZb1+4A92viPYqsAey9G1PZGSugHbQFBDLChV79HFEgzCEZVawRhLyH/yuFnbwbMD9N+eFxiX3fvheH5/c7qiXgjFPCQmITiPEycEBg2T7ACv81ZRZQk0cZHgaYIpGKBbhK/6mFpoFOgH158wSIvo7cNnqeZK3Vxq7JbVMbaukxLJrgy48IlM3fuJrcpPdKAuTHYycfmLDN6IzapQn+aJjKcMnfYrofL4PQlZaeeqzR1PstsF5kgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVwFxJstObeZm4hLrlzsstf+CgrSngxKkqzr2SZDJ7A=;
 b=nVHZwl4UhE1SSrmFCYrBCsF0UvJ5vaKfQp4StJYEZgYLTmsQI6DtjdPRgK5G42QofSLUnG2Vy0/gjpOrJmA7eYkeI0cH3tiktTV2XPDOZBcQH9MTEGq3ervqTwPzElzggGkMPCvWhLPDfVo8z2xXCb+CVZo68gwLE9jM6XuPKzSU8DeZ8imXJpYJz2ZVbthSwBEj14dlobljgsBi4HdJywqgxR2NcS3kWC54Zvlz5UHaoigqJadlKvIhh1Nnb6CngmeBxonzg9JUg1JooXADTXRNZAzg5l1vizMKDCxffWtt6YR8b5T8161PVbSpss/0CG2g3+6kRpyrDChA+jBS4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVwFxJstObeZm4hLrlzsstf+CgrSngxKkqzr2SZDJ7A=;
 b=I16lfvCr4TDIkxC4HxHWHGqfImMKgOlpuoTalhUkZpMtoNo1D3B01Ip1qk7tHXL7kNcx9JzbQ2vBvcBv/GtQGpY32h/SbmadSXr4GNm+cX8ss2GisOkpIEIrv3g9MMZgBOjzv9Yr4hiGJNkte4Wsgpc0wlUBjJ0BFsPevKrqXLA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 17:59:50 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 17:59:50 +0000
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
	<jonathan.cameron@huawei.com>, Sascha Bischoff <Sascha.Bischoff@arm.com>
Subject: [PATCH v4 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use generated
 ICH_VMCR_EL2
Thread-Topic: [PATCH v4 02/36] KVM: arm64: gic-v3: Switch vGIC-v3 to use
 generated ICH_VMCR_EL2
Thread-Index: AQHckH/lxJcBSHpIy06YC6AewwBwJQ==
Date: Wed, 28 Jan 2026 17:59:50 +0000
Message-ID: <20260128175919.3828384-3-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|AMS1EPF0000004C:EE_|AMDPR08MB11527:EE_
X-MS-Office365-Filtering-Correlation-Id: cb4d7ede-0d67-4cdb-f4b3-08de5e972de9
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?35HoCG60E6118obX+ysgRXjuh+5pVXD8p/0HDtlhzL2SVu3xSvMZlDjnvQ?=
 =?iso-8859-1?Q?r2von76mdT038QrYQBZFHFdcxs1agyu1UQ9BWR/9fDc19Vgt4nW9Hyjk3B?=
 =?iso-8859-1?Q?EjHi7YAnuREEGIiiGlSm/u0rPOFDU5Mfs46XUnqtcKl17lvbGVTPTaBTr/?=
 =?iso-8859-1?Q?vNui9AVjjcQTL5D9FAm6jko6Mh3E+2fU0ylqdRgQmoRS0l7DTGzSBT+hGa?=
 =?iso-8859-1?Q?S5SMmtpJYo0jJQBFD7U9j6ubb2tiFec5V5Kfomvl/fcs3J6/WNFAGSs5xS?=
 =?iso-8859-1?Q?bf663Sp+LOAbbx3vwLOd0SUQCqBh5VpFME2N1n8I03MumRXdSWDBgXwBGA?=
 =?iso-8859-1?Q?A7glrX7Xx/bY7shUOS0rNdQ81eIKj1bOImtDrvQ+3W6ZuLbN/scU0hvWkH?=
 =?iso-8859-1?Q?GdaeJ3MzsSHJMFsxwzZ3tX7ndkGKHJg0QEDy3eNBYfmUhS03Fg8NHfLV8R?=
 =?iso-8859-1?Q?UhtP3NXsk5ZwQJ9HAhMnTWzBnUQaFeFSrMbZb/FJJnE4aGf8tSwj1dYcHa?=
 =?iso-8859-1?Q?hIRmdAeAa84HvrGy2qPjSOKKzC9K9apWIb2ypBL1+2g/BiobcvvaSf8b1F?=
 =?iso-8859-1?Q?I+5lim2+tGoJr4igvxxHEyFZ2UmgCuQeWjtaG0nNYQGLrnnpN1OLCTQNed?=
 =?iso-8859-1?Q?4UrcQROj6OLCTbBnkQOashQfQWvOIt4apu6jfbtHgm+S3omEDMyjWVXvDF?=
 =?iso-8859-1?Q?6moXAlsLEpmxnUMkJTxO566m0d86lursajn5YsiXTJ9AeYvHF5tEgE2C8C?=
 =?iso-8859-1?Q?pmKh3QM6HLxLnvSBGFoclWoe7pfbScW5KcbmmaPuTF2Yhe/1MSe6eyRaKj?=
 =?iso-8859-1?Q?Z78BUiRPGEdX3BshecexIr6m4LTzoP+xOOMp9XULupSPhZSgRGz88s5Rnp?=
 =?iso-8859-1?Q?SFW1atbQBZ2+JgTncSo+cw6VMfurls5cuaeXDN4sKteiJKKdnafn6EqUK/?=
 =?iso-8859-1?Q?Z/3OVrGMGCbOI9gw33StTj0sj9y2H7Jk0g3U2l99UVV9qRLcog0BVfzEN5?=
 =?iso-8859-1?Q?1DRBzgIcN3s+4vPpReoGnOjgVpfRAOjj9RAzrv6q2yNWbXAcPG4A3cGODh?=
 =?iso-8859-1?Q?4A0TWqLtiJSa0Ynzaf0fS4x15U9wRUQXPWQPdjUh+XG5wz2zD4Bztf4PsZ?=
 =?iso-8859-1?Q?zZQw/SMRHoFC57tJW/p674VbCODVcL6QJb3ktEnI4mes2CMIv4YS8F0uWE?=
 =?iso-8859-1?Q?jVfmpcMwnV8BOYaKpxjU/r71vFr588H7LicmWRTuPzi3mv6O4FAnL1o6ll?=
 =?iso-8859-1?Q?O+SkscSDALmVIElXkQ5rtHJdVAgUq2ufmyR5/kkNv5bfMqjm3s/nA55jia?=
 =?iso-8859-1?Q?O0Ejjg8md4kwe8Tg1uj9dqSRRwPlnk2u3g83W6UJPNuGgU6EOMYZpM5ra0?=
 =?iso-8859-1?Q?RAUrXWFsufInBzRFt7h7cOpvLzpzb4eJgxcukgL05aCU9Ipy4zsijNlAX3?=
 =?iso-8859-1?Q?tLZUv2eo7G6IqHJogp4/rzJjPW5Lr06ZnfDDM79mScP/ErPCRGGyCbEd8g?=
 =?iso-8859-1?Q?lwfjltQzc/ScBAutJN1xvYO3IoujHAjRjCAEkIQx8aYTIr9+P+f/ypWVK8?=
 =?iso-8859-1?Q?DDK5UQowx3/tvMIGd2T6Pr1n3pYPgkU9cXlDX1PQvgLYHoBEh/XneyXgwp?=
 =?iso-8859-1?Q?3lfzOL/n80dZXxrrqH6oYjrkua+fqhWkixtzEVOWwuMljwGpVeZ+811oOx?=
 =?iso-8859-1?Q?qxM3SFHcWHA0FsxuoV4=3D?=
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
 AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	316640d7-2eec-4cbe-6d97-08de5e970865
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|14060799003|35042699022|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?649ZNfZQu+8pN9fQPu8YhvMwUptlu7CfcTz5T9qiatWs248F/luHpNwaxX?=
 =?iso-8859-1?Q?isSS1nlqJuy1m0coNM9oWdN7zcev5KzAXAWkQ1gcXA8e9MZ06JQHamFlm9?=
 =?iso-8859-1?Q?fvTdNOA8uvyc8HVInosYRrdLtOyEIEzbCYkl8wdthUALnkTzYq5OhXVrF3?=
 =?iso-8859-1?Q?k1ySsglsr5DlWpKaufjFLWuVmoAe6V5NZr0CXbPHvOUL4BUCSwJeCTufiW?=
 =?iso-8859-1?Q?L1kq8L4Jj/JyeD0ojlvIku7i0HwAMwa95zL9Y+xPTMgdUayxxmwkc3pwiF?=
 =?iso-8859-1?Q?9WTNxXQmd6Gt90/NXI1QYreKdY0HfCsYBSseMhMVqgWCsi3Cy+VU9GjSKb?=
 =?iso-8859-1?Q?dqwwztZd4ZfrbrhUYC2d1O4UbSgA+FsN0MoVjpgk33ZHJfBKyDEksCVpx1?=
 =?iso-8859-1?Q?caYcTUEnrIcRL7ZOdEHT6bUHHDcMmyHrRsCbour8EYlx5VmoudsF4Akzgk?=
 =?iso-8859-1?Q?xNi1r+WLiGbNKI/wbZ0TJH3K6iEYxH/qivgvjn6XdZypRClClD4Xl8wUsa?=
 =?iso-8859-1?Q?iMBHirf8JI+N6YbUVbc0YNdtzPcUXrcDLtpd/ssiFd1l6/5uD5E3KUg7ft?=
 =?iso-8859-1?Q?62G/HgENgKHrHOku08jALCAmob1u31QmmpnLYusWVYPfzHrE7uHTfVK86z?=
 =?iso-8859-1?Q?aoL7EteqXM/IN5RGux/q9wr7GULvHW7O7EKWIV3JC8HmAaLw5JSokmwDZv?=
 =?iso-8859-1?Q?2AdlubtqY130zHZwQ/T/3S+fdXiBe6Qf7qS/rWEadzgtBFQORP+at7mgE8?=
 =?iso-8859-1?Q?b64zeAUIF4YPeHCc4syHy0TOBodNvlANKm3j5fwO3faahMsSDlIQlJJnIN?=
 =?iso-8859-1?Q?SOygcgb7pJuO8VN/qJ75QK/Qrz9AXC3bqoKC1XGElLSesYo5sAk4Fe1+rn?=
 =?iso-8859-1?Q?Oa5ozbhg3JdUOqJMQcbENCg+D3WsK3/9XJKsh665Pngh6qPY8Hfxr6TTjU?=
 =?iso-8859-1?Q?GV3r4Ns1vhy4B8SrRKBHrr2jXjXYeRDGYukwcDNQHBOU9nYUmDsbrubzyX?=
 =?iso-8859-1?Q?vITxnxT9hk/xa6uNXIIBFnCHyZcv7GVWTDKA7bRBq3uoRG0jky/9Ulz0Vf?=
 =?iso-8859-1?Q?B2BHVH5ALmHrX7NvSPVlTm0hYaxs3H6OoIORV/LHzTs3tI8y9Zelb4YeO3?=
 =?iso-8859-1?Q?Z/0ya40VQtI6bY/ugi5Ol2Q3Eqfu4cNECy18QXAOx+VUACHPxqbJWqEZuQ?=
 =?iso-8859-1?Q?VS2USUO40So3XXpYR69GJVyGD8QoNEczhkuwKNOysYWf0fQgvLPSkv5fjq?=
 =?iso-8859-1?Q?Qx9wrb8rlQ2BN9QKO0RzpyY5bARZZl0d83WmeXk5rLupwRAk3O9UfQ21Fz?=
 =?iso-8859-1?Q?DKGeKWrNMECVyVeo1RcIdFbhKWOh4Rh6ZiwSTg7hDatBLovJ4z1riIGDr6?=
 =?iso-8859-1?Q?B8Q7e7mG3DgxLQsSQ1sHm+12msYX/eY157zpS6Sx6MaH/JbRQXLP5y0NuD?=
 =?iso-8859-1?Q?lWR9ayiD02DnDpi45/P9wie9UKgHbRwvxeh2cBb5yt/tCz1NJbyA2lQ9Y8?=
 =?iso-8859-1?Q?+cE9pE2FCvlg6D6ovqE6vTElQkLoLYwV2NqUba0jlDshrm7cjALUYhsskE?=
 =?iso-8859-1?Q?QYwvH5PWSypREkNOVvhFJ3doo1Pco/gatENVdu+0MT9g/OGW13UV00zAkT?=
 =?iso-8859-1?Q?QOxzIoh9bYk/EVfepAJu/9taP+uU0l/shDcv3GHY+XCX59RORHw79Ptj5Q?=
 =?iso-8859-1?Q?N6GuTEd4VorHAci9WEsN+VLKQ5069k2TqB5Uq9pbP+SqLVIqSxjF4gE513?=
 =?iso-8859-1?Q?wVsA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(14060799003)(35042699022)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:00:53.5613
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb4d7ede-0d67-4cdb-f4b3-08de5e972de9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000004C.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMDPR08MB11527
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69368-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 1FC49A76A8
X-Rspamd-Action: no action

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

The VGIC-v3 code relied on hand-written definitions for the
ICH_VMCR_EL2 register. This register, and the associated fields, is
now generated as part of the sysreg framework. Move to using the
generated definitions instead of the hand-written ones.

There are no functional changes as part of this change.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/sysreg.h      | 21 ---------
 arch/arm64/kvm/hyp/vgic-v3-sr.c      | 69 ++++++++++------------------
 arch/arm64/kvm/vgic/vgic-v3-nested.c |  8 ++--
 arch/arm64/kvm/vgic/vgic-v3.c        | 48 +++++++++----------
 4 files changed, 51 insertions(+), 95 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index 106b15eb232a..c547a14bb6aa 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -561,7 +561,6 @@
 #define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
 #define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
 #define SYS_ICH_ELRSR_EL2		sys_reg(3, 4, 12, 11, 5)
-#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
=20
 #define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
 #define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
@@ -989,26 +988,6 @@
 #define ICH_LR_PRIORITY_SHIFT	48
 #define ICH_LR_PRIORITY_MASK	(0xffULL << ICH_LR_PRIORITY_SHIFT)
=20
-/* ICH_VMCR_EL2 bit definitions */
-#define ICH_VMCR_ACK_CTL_SHIFT	2
-#define ICH_VMCR_ACK_CTL_MASK	(1 << ICH_VMCR_ACK_CTL_SHIFT)
-#define ICH_VMCR_FIQ_EN_SHIFT	3
-#define ICH_VMCR_FIQ_EN_MASK	(1 << ICH_VMCR_FIQ_EN_SHIFT)
-#define ICH_VMCR_CBPR_SHIFT	4
-#define ICH_VMCR_CBPR_MASK	(1 << ICH_VMCR_CBPR_SHIFT)
-#define ICH_VMCR_EOIM_SHIFT	9
-#define ICH_VMCR_EOIM_MASK	(1 << ICH_VMCR_EOIM_SHIFT)
-#define ICH_VMCR_BPR1_SHIFT	18
-#define ICH_VMCR_BPR1_MASK	(7 << ICH_VMCR_BPR1_SHIFT)
-#define ICH_VMCR_BPR0_SHIFT	21
-#define ICH_VMCR_BPR0_MASK	(7 << ICH_VMCR_BPR0_SHIFT)
-#define ICH_VMCR_PMR_SHIFT	24
-#define ICH_VMCR_PMR_MASK	(0xffUL << ICH_VMCR_PMR_SHIFT)
-#define ICH_VMCR_ENG0_SHIFT	0
-#define ICH_VMCR_ENG0_MASK	(1 << ICH_VMCR_ENG0_SHIFT)
-#define ICH_VMCR_ENG1_SHIFT	1
-#define ICH_VMCR_ENG1_MASK	(1 << ICH_VMCR_ENG1_SHIFT)
-
 /*
  * Permission Indirection Extension (PIE) permission encodings.
  * Encodings with the _O suffix, have overlays applied (Permission Overlay=
 Extension).
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-s=
r.c
index 0b670a033fd8..c4d2f1feea8b 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -569,11 +569,11 @@ static int __vgic_v3_highest_priority_lr(struct kvm_v=
cpu *vcpu, u32 vmcr,
 			continue;
=20
 		/* Group-0 interrupt, but Group-0 disabled? */
-		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG0_MASK))
+		if (!(val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 			continue;
=20
 		/* Group-1 interrupt, but Group-1 disabled? */
-		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_ENG1_MASK))
+		if ((val & ICH_LR_GROUP) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 			continue;
=20
 		/* Not the highest priority? */
@@ -646,19 +646,19 @@ static int __vgic_v3_get_highest_active_priority(void=
)
=20
 static unsigned int __vgic_v3_get_bpr0(u32 vmcr)
 {
-	return (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
+	return FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
 }
=20
 static unsigned int __vgic_v3_get_bpr1(u32 vmcr)
 {
 	unsigned int bpr;
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK) {
+	if (vmcr & ICH_VMCR_EL2_VCBPR_MASK) {
 		bpr =3D __vgic_v3_get_bpr0(vmcr);
 		if (bpr < 7)
 			bpr++;
 	} else {
-		bpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
+		bpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
 	}
=20
 	return bpr;
@@ -758,7 +758,7 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u=
32 vmcr, int rt)
 	if (grp !=3D !!(lr_val & ICH_LR_GROUP))
 		goto spurious;
=20
-	pmr =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
+	pmr =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
 	if (pmr <=3D lr_prio)
 		goto spurious;
@@ -806,7 +806,7 @@ static int ___vgic_v3_write_dir(struct kvm_vcpu *vcpu, =
u32 vmcr, int rt)
 	int lr;
=20
 	/* EOImode =3D=3D 0, nothing to be done here */
-	if (!(vmcr & ICH_VMCR_EOIM_MASK))
+	if (!(vmcr & ICH_VMCR_EL2_VEOIM_MASK))
 		return 1;
=20
 	/* No deactivate to be performed on an LPI */
@@ -849,7 +849,7 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu,=
 u32 vmcr, int rt)
 	}
=20
 	/* EOImode =3D=3D 1 and not an LPI, nothing to be done here */
-	if ((vmcr & ICH_VMCR_EOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
+	if ((vmcr & ICH_VMCR_EL2_VEOIM_MASK) && !(vid >=3D VGIC_MIN_LPI))
 		return;
=20
 	lr_prio =3D (lr_val & ICH_LR_PRIORITY_MASK) >> ICH_LR_PRIORITY_SHIFT;
@@ -865,22 +865,19 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr));
 }
=20
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt=
)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr));
 }
=20
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int r=
t)
 {
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
-	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG0_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_ENG0_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VENG0, &vmcr, val & 1);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -889,10 +886,7 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 {
 	u64 val =3D vcpu_get_reg(vcpu, rt);
=20
-	if (val & 1)
-		vmcr |=3D ICH_VMCR_ENG1_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_ENG1_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VENG1, &vmcr, val & 1);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -916,10 +910,7 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu=
, u32 vmcr, int rt)
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR0_SHIFT;
-	val &=3D ICH_VMCR_BPR0_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR0_MASK;
-	vmcr |=3D val;
+	FIELD_MODIFY(ICH_VMCR_EL2_VBPR0, &vmcr, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -929,17 +920,14 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	u64 val =3D vcpu_get_reg(vcpu, rt);
 	u8 bpr_min =3D __vgic_v3_bpr_min();
=20
-	if (vmcr & ICH_VMCR_CBPR_MASK)
+	if (FIELD_GET(ICH_VMCR_EL2_VCBPR, val))
 		return;
=20
 	/* Enforce BPR limiting */
 	if (val < bpr_min)
 		val =3D bpr_min;
=20
-	val <<=3D ICH_VMCR_BPR1_SHIFT;
-	val &=3D ICH_VMCR_BPR1_MASK;
-	vmcr &=3D ~ICH_VMCR_BPR1_MASK;
-	vmcr |=3D val;
+	FIELD_MODIFY(ICH_VMCR_EL2_VBPR1, &vmcr, val);
=20
 	__vgic_v3_write_vmcr(vmcr);
 }
@@ -1029,19 +1017,14 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
=20
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vmcr &=3D ICH_VMCR_PMR_MASK;
-	vmcr >>=3D ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	vcpu_set_reg(vcpu, rt, FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr));
 }
=20
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	val <<=3D ICH_VMCR_PMR_SHIFT;
-	val &=3D ICH_VMCR_PMR_MASK;
-	vmcr &=3D ~ICH_VMCR_PMR_MASK;
-	vmcr |=3D val;
+	FIELD_MODIFY(ICH_VMCR_EL2_VPMR, &vmcr, val);
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
@@ -1064,9 +1047,11 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcp=
u, u32 vmcr, int rt)
 	/* A3V */
 	val |=3D ((vtr >> 21) & 1) << ICC_CTLR_EL1_A3V_SHIFT;
 	/* EOImode */
-	val |=3D ((vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT) << ICC_CTLR=
_EL1_EOImode_SHIFT;
+	val |=3D FIELD_PREP(ICC_CTLR_EL1_EOImode_MASK,
+			  FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr));
 	/* CBPR */
-	val |=3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
+	val |=3D FIELD_PREP(ICC_CTLR_EL1_CBPR_MASK,
+			FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr));
=20
 	vcpu_set_reg(vcpu, rt, val);
 }
@@ -1075,15 +1060,11 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *v=
cpu, u32 vmcr, int rt)
 {
 	u32 val =3D vcpu_get_reg(vcpu, rt);
=20
-	if (val & ICC_CTLR_EL1_CBPR_MASK)
-		vmcr |=3D ICH_VMCR_CBPR_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_CBPR_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VCBPR, &vmcr,
+		     FIELD_GET(ICC_CTLR_EL1_CBPR_MASK, val));
=20
-	if (val & ICC_CTLR_EL1_EOImode_MASK)
-		vmcr |=3D ICH_VMCR_EOIM_MASK;
-	else
-		vmcr &=3D ~ICH_VMCR_EOIM_MASK;
+	FIELD_MODIFY(ICH_VMCR_EL2_VEOIM, &vmcr,
+		     FIELD_GET(ICC_CTLR_EL1_EOImode_MASK, val));
=20
 	write_gicreg(vmcr, ICH_VMCR_EL2);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgi=
c-v3-nested.c
index 61b44f3f2bf1..c9e35ec67117 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -202,16 +202,16 @@ u64 vgic_v3_get_misr(struct kvm_vcpu *vcpu)
 	if ((hcr & ICH_HCR_EL2_NPIE) && !mi_state.pend)
 		reg |=3D ICH_MISR_EL2_NP;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0EIE) && (vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_ENG0_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp0DIE) && !(vmcr & ICH_VMCR_EL2_VENG0_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp0D;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1EIE) && (vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1E;
=20
-	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_ENG1_MASK))
+	if ((hcr & ICH_HCR_EL2_VGrp1DIE) && !(vmcr & ICH_VMCR_EL2_VENG1_MASK))
 		reg |=3D ICH_MISR_EL2_VGrp1D;
=20
 	return reg;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 1d6dd1b545bd..2afc04167231 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -41,9 +41,9 @@ void vgic_v3_configure_hcr(struct kvm_vcpu *vcpu,
 	if (!als->nr_sgi)
 		cpuif->vgic_hcr |=3D ICH_HCR_EL2_vSGIEOICount;
=20
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG0_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG0_MASK) ?
 		ICH_HCR_EL2_VGrp0DIE : ICH_HCR_EL2_VGrp0EIE;
-	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_ENG1_MASK) ?
+	cpuif->vgic_hcr |=3D (cpuif->vgic_vmcr & ICH_VMCR_EL2_VENG1_MASK) ?
 		ICH_HCR_EL2_VGrp1DIE : ICH_HCR_EL2_VGrp1EIE;
=20
 	/*
@@ -215,7 +215,7 @@ void vgic_v3_deactivate(struct kvm_vcpu *vcpu, u64 val)
 	 * We only deal with DIR when EOIMode=3D=3D1, and only for SGI,
 	 * PPI or SPI.
 	 */
-	if (!(cpuif->vgic_vmcr & ICH_VMCR_EOIM_MASK) ||
+	if (!(cpuif->vgic_vmcr & ICH_VMCR_EL2_VEOIM_MASK) ||
 	    val >=3D vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)
 		return;
=20
@@ -408,25 +408,23 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 	u32 vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcr =3D (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
-			ICH_VMCR_ACK_CTL_MASK;
-		vmcr |=3D (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
-			ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D FIELD_PREP(ICH_VMCR_EL2_VAckCtl, vmcrp->ackctl);
+		vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VFIQEn, vmcrp->fiqen);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
 		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
 		 */
-		vmcr =3D ICH_VMCR_FIQ_EN_MASK;
+		vmcr =3D ICH_VMCR_EL2_VFIQEn_MASK;
 	}
=20
-	vmcr |=3D (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
-	vmcr |=3D (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
-	vmcr |=3D (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
-	vmcr |=3D (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |=3D (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
-	vmcr |=3D (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
-	vmcr |=3D (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VCBPR, vmcrp->cbpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VEOIM, vmcrp->eoim);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR1, vmcrp->abpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VBPR0, vmcrp->bpr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VPMR, vmcrp->pmr);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG0, vmcrp->grpen0);
+	vmcr |=3D FIELD_PREP(ICH_VMCR_EL2_VENG1, vmcrp->grpen1);
=20
 	cpu_if->vgic_vmcr =3D vmcr;
 }
@@ -440,10 +438,8 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vg=
ic_vmcr *vmcrp)
 	vmcr =3D cpu_if->vgic_vmcr;
=20
 	if (model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		vmcrp->ackctl =3D (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
-			ICH_VMCR_ACK_CTL_SHIFT;
-		vmcrp->fiqen =3D (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
-			ICH_VMCR_FIQ_EN_SHIFT;
+		vmcrp->ackctl =3D FIELD_GET(ICH_VMCR_EL2_VAckCtl, vmcr);
+		vmcrp->fiqen =3D FIELD_GET(ICH_VMCR_EL2_VFIQEn, vmcr);
 	} else {
 		/*
 		 * When emulating GICv3 on GICv3 with SRE=3D1 on the
@@ -453,13 +449,13 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct v=
gic_vmcr *vmcrp)
 		vmcrp->ackctl =3D 0;
 	}
=20
-	vmcrp->cbpr =3D (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
-	vmcrp->eoim =3D (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
-	vmcrp->abpr =3D (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
-	vmcrp->bpr  =3D (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  =3D (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
-	vmcrp->grpen0 =3D (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
-	vmcrp->grpen1 =3D (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
+	vmcrp->cbpr =3D FIELD_GET(ICH_VMCR_EL2_VCBPR, vmcr);
+	vmcrp->eoim =3D FIELD_GET(ICH_VMCR_EL2_VEOIM, vmcr);
+	vmcrp->abpr =3D FIELD_GET(ICH_VMCR_EL2_VBPR1, vmcr);
+	vmcrp->bpr  =3D FIELD_GET(ICH_VMCR_EL2_VBPR0, vmcr);
+	vmcrp->pmr  =3D FIELD_GET(ICH_VMCR_EL2_VPMR, vmcr);
+	vmcrp->grpen0 =3D FIELD_GET(ICH_VMCR_EL2_VENG0, vmcr);
+	vmcrp->grpen1 =3D FIELD_GET(ICH_VMCR_EL2_VENG1, vmcr);
 }
=20
 #define INITIAL_PENDBASER_VALUE						  \
--=20
2.34.1

