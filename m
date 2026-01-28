Return-Path: <kvm+bounces-69391-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMf+LexSemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69391-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:18:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B251A7A8E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1BE8D30613C2
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0C9637473D;
	Wed, 28 Jan 2026 18:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oo4YGItB";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oo4YGItB"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012053.outbound.protection.outlook.com [52.101.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C3E2FE58D
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.53
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623615; cv=fail; b=WHkQxteKzDbHQFJsDRobJMiEu7YlFmP7G5EQf1aiHMUpsylAd5WPRc7GNyJG37zeZ0NTVotNU2iFKjbkF6nG7WaxcQVM6DTt4TsBke4Zv4yfcm+4BsGgKMNimdonqJ1yRTSJjYUVZrYSx67oDtnGu2Xn7Z5NFOWtMSYL9Mgsh0E=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623615; c=relaxed/simple;
	bh=pAto8UICBpNAI7u6bU74KBNCXhlei7JOslpsudhZJOc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FclPNJkzZUlKAajZgDBcq8lDWEGrIt4JNI1FfCbw52ipxqfc1Q1Bi2G0VN2QFVRWwZkLTyVI7voyEpy1ST3AoZLXUkVxzBBbGgtbJQyrpwvoopEW+CXhYEyVUAY8E9mbSS+b3yRfRxKzL1zz/lUCCCLGJE+Laz/dLT9C5SXT+yo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oo4YGItB; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oo4YGItB; arc=fail smtp.client-ip=52.101.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NZHEurp7L0H/jeMEE8gHRC2WStb9Qfpf4LyyViiHhHvntU/jleHXPE9hmrbDC5YFHR6sKKv2wFpjFTmn3sMo7H3JzL5PYcB8eQRAgi+C+ZM6cBWly1z03nRxOuBliH4v0J3s+upE4jRwR3mpFddqoZlCTqFncHf7HFTmuKnv4YNPlxQy+iHNxG4RoOF4Q04bMNGdhNe3dROwzLSgxfiOofFmEgWxUL8l+tEreAD8VI+rzS/8vR9gDjtNeWmEibOMGELMgpr152JTq0EIXwukDdkqa6obvuQQSReRYfZ9Gi1ZhhZj1G67lA7Mb4ayC2c/0ieq4KZQM94SZxalOh0vQQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUqv2HRXqzE+JP5KQaeGNkQyliJ9w5O3zxBxaMnUyeo=;
 b=Ko1pvs/Q4m8vH13a76wHkuZwqTdRrgtImpIiiNQTZZBQMBCCVMAQ7agq99Kr3mICXFKq293wV3yqLJD8XDJA6FrtAlRLwLjveYMyYDx12rsqRYwLIsJYkXy7vEVr36AinA++3oiYuqwI0BauwKUopjPeYil1BD7HkKvJdfwY5yQkCgTCeLyXZR9RzuDbqxtWqEbDpPQ4elVaFol/xpukrIg7KoxqUvoFTUALLT7r2niWYQTQZmGCE8CUV9dAf1k49NIBF5DnGKtbAxp68zaQa8SiyUNXjfa/kAfFyVisyzfOGJ556ANzqwRW2hIEyW4yS+bIfxtFKjVkkShyfk8z1Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUqv2HRXqzE+JP5KQaeGNkQyliJ9w5O3zxBxaMnUyeo=;
 b=oo4YGItBrfymw8MJyHmvZjfjjNk4KDH8uNEt4HgMwLestgXCcfIv2qp1pGsukxNCsuAtHE8tU3p2FBYqDXotjdooF3RROXivDBzdwcZzaB47VaS9S8z2cX00jcDuxdi51yJquQf4mm/JJBqyt9MeDW88fdbZeGB132Uy3f/3pyA=
Received: from CWLP265CA0544.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:18d::12)
 by AM8PR08MB5764.eurprd08.prod.outlook.com (2603:10a6:20b:1d2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 18:06:48 +0000
Received: from AMS1EPF00000047.eurprd04.prod.outlook.com
 (2603:10a6:400:18d:cafe::84) by CWLP265CA0544.outlook.office365.com
 (2603:10a6:400:18d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:06:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000047.mail.protection.outlook.com (10.167.16.135) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:06:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B81232XMAAmh+w9HOm9vG/IWZprIwxkdpJMsIBPn3FdI3KW76a1sjQme2AIutQVL9sG6I7jtdsdnMNppp/beFzIshKBCEXxHRnwelD2c9yLrreXx4npnl53nKzrDKgss41VHoehGLEclNgu36YXxhw4zrRVHR0N/wjNXiCfgsvwTKuuRvMNXHKQlBP5DHXlDTqo9bVd8OlKZ4wyLJZpB4JwQzOKiFG9pphg98lBBwDzb1wAtzMrXLdOSJVf2WFTdosN9msGU36iUIvzzPEPFTNRV1gY0qbeCwmngk5QiuxK0PePJyN+Tmr+DL5gj90QAIo7FDm3Xjn+u1cv/TvhpNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IUqv2HRXqzE+JP5KQaeGNkQyliJ9w5O3zxBxaMnUyeo=;
 b=NCNas/skYW4tKf3vzEfVayAR50k1x6Q5/9ihuRMuPyz/q2mydGhA7SJTxwUCaJsUlNKgE/F83mHxf/bGfKk0X8KKnrosVTKy8LC7Pso50/IdYcvPvbYyR7eLjjJ2vPffP7ColceIaiH52yWQAwN0VK7Rh7U/XwrZVEaIIt0uKXqFpyat5jn9C4SEnsHpWq0ihJJK2tXAmlieSZUroMRR2w2ithkFPJ5NV4FVxBNTnyHv8ftKHODwZQfvvKwlUZP5dEPtAgw72U0Ajp2xBfUFKDyeKbzin6y76yC5TII1JmmhRrtJGvCY1SYwb1so1znULQ2E7D3eEQdGS9cyCPJQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IUqv2HRXqzE+JP5KQaeGNkQyliJ9w5O3zxBxaMnUyeo=;
 b=oo4YGItBrfymw8MJyHmvZjfjjNk4KDH8uNEt4HgMwLestgXCcfIv2qp1pGsukxNCsuAtHE8tU3p2FBYqDXotjdooF3RROXivDBzdwcZzaB47VaS9S8z2cX00jcDuxdi51yJquQf4mm/JJBqyt9MeDW88fdbZeGB132Uy3f/3pyA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:05:45 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:05:45 +0000
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
Subject: [PATCH v4 25/36] KVM: arm64: gic-v5: Reset vcpu state
Thread-Topic: [PATCH v4 25/36] KVM: arm64: gic-v5: Reset vcpu state
Thread-Index: AQHckIC5++T8TCJ1YUOZ2DZDpgjOxw==
Date: Wed, 28 Jan 2026 18:05:45 +0000
Message-ID: <20260128175919.3828384-26-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|AMS1EPF00000047:EE_|AM8PR08MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: afa882cc-eed8-4ed8-8393-08de5e980148
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?AOd4RfTE9NYE9xG4VQuwsdqOvsrOSFsJWXuN0SC22HvBMvkqWJr2yJylpc?=
 =?iso-8859-1?Q?02TrnP02VGtKPDsnxZJuRlgXQDS+j/kU8c2B4L9fNo2zWiQx6CmGxa0apS?=
 =?iso-8859-1?Q?KYL6r5GYkpwNgqXmNx0kvntELJvSUzSC2DWHZhEYKXjMtPV+iRVGeBVYW2?=
 =?iso-8859-1?Q?Bn4HTinVSle1E6iS/70te1z6BO3jTZRskXr9qke5hUzaQ73JqRsFQPDubZ?=
 =?iso-8859-1?Q?Oy+t6R1QAnIVK1dhGk4d12/JPqeD1JGKtVzr5sMx/v1hmcFN4T0neTpkIB?=
 =?iso-8859-1?Q?EDsjYeA+YMnhOSIgib6pRS0+qgp7hdD0f5N1NbztqqUSNhZzmltFsGR9fT?=
 =?iso-8859-1?Q?B/MFedKUFvJP2t3jNKqUtHJLrl8iRHO4Emvb4ZqKUufAwxx1jYvKNl6Z5s?=
 =?iso-8859-1?Q?utVEXQxLFQoE5F2IOFeqWUa+Qb+miPv4smu0i2lXzOp8BomtiMFSaCsHEL?=
 =?iso-8859-1?Q?Y5f+rYnlGZX/IuGwCxn9DgwmbsUX+oHymfIZLJCH69IwnsYRVic82BiPKa?=
 =?iso-8859-1?Q?tO3BUDFF3Hhr7QoDPBsOx7CNeoESwK1j5D0KPJEXuOZJAED5VSlVOqFHkD?=
 =?iso-8859-1?Q?mnNgXz1cUI/+4y4w4QsJncIugtdcCUG07Cb72XI+jO8TNy7a6/Q9bEqFNT?=
 =?iso-8859-1?Q?qfOKVujcP9sepFnQND+mbFwtTAKBvZQiL/uJHLs5BIAka0tID6iB2XhhO6?=
 =?iso-8859-1?Q?dxXksWil+wcbd7aiXa2PvTISp0T7oA0DhOtcsJIf3hfwPtM7hq6F9fy33r?=
 =?iso-8859-1?Q?UQmpHCp53IcuKbpMRSKCmZkWThLq/xkSuixr94jEQQ7heQVSBr3K7RKJwV?=
 =?iso-8859-1?Q?D/ev0nzKSPMg3w/4lvnrAwRTZYRiukvsy480abvkTLfRfpm6ZegHR+dTtK?=
 =?iso-8859-1?Q?+fnDLzDIEMFdOdY5iwy2juy5+41+0fS8GzPrEIizSOUgClfSmOHUq7zzh8?=
 =?iso-8859-1?Q?sG+gQKarW7NTEZZqA3uIpb71ocZVbaUreZ7Ixwewyt4gmC0y/tGORYXUdi?=
 =?iso-8859-1?Q?3J0toUUQYlQDR8P6xfYYMWwp5MeHylLLa08uaxkqMHPiIjy1Pjo65O0u6+?=
 =?iso-8859-1?Q?8VHNiI9DRLkMCRnLOzSUxXBUP3iTwuYDS8avPhesnk+QPppFoSnBK/pz6k?=
 =?iso-8859-1?Q?zQPjEZLCT7u+Hv3PbMOK3OV1w4yWf4zhfY/HcXmPuUwmbiahXypjJUSzNA?=
 =?iso-8859-1?Q?MzugTPX9cWJeSKixxcFHxLZxTm/mkRyezDwLfrGCaPvTi/He/Da+GHGBf3?=
 =?iso-8859-1?Q?0NFvqX68ZTQtndK80wxJgqcoSgpC4e8WGO3CJAn0X7psXbfrL6RGMqB2fM?=
 =?iso-8859-1?Q?AVPkEqalgxg1sFUHscFLboAYSjnlCjOnT0KQiJmet9NMzNlu7wH9wjn3at?=
 =?iso-8859-1?Q?MyfwOpt6uH3NXp0uLPBkVuMyCdG4w4QVylTxBEkL1xVn08ZX9YofbsmI1B?=
 =?iso-8859-1?Q?Ve/pWVubbw8MoT1Ydx1hMwGNCjL1VOrJHmt8Bu0ngK4ZIO+VCL6sLohJIo?=
 =?iso-8859-1?Q?diTc4gCbWHbtQxDOePRKwDDvSd5mN1Pwj+VnNCthopyA1qmgqFSaIxloXq?=
 =?iso-8859-1?Q?kIrWuXQ4O7warKtTELjC0VZKXNDe46Df/fbtxrb47dbs/ypt/ncU0toKf+?=
 =?iso-8859-1?Q?IeCK9ksMzZv29TneHwDjHqMvgdfVqk98j8ggheusmqEBelZEq6dw+kv5NC?=
 =?iso-8859-1?Q?soitbPS/0Tw/w7W2dUM=3D?=
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
 AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2c9769d5-bec4-474c-dd2d-08de5e97dbf4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?aBAdcknq9yWK6vdbjCkqIGh4hK49U+Yps/qJjNLvznuuYa/Bc2XeTzmQWn?=
 =?iso-8859-1?Q?QWsjz62sMLTs0WDtKFFikmTao7IHk8g0K2uMpRZbGaup8WTm/qONFqilDC?=
 =?iso-8859-1?Q?Zb9ETSxbxcTcLEd6nK+q4itpqt/cDXWIvvnZAM2L2Ea/UKkXlXYDKVD4Pz?=
 =?iso-8859-1?Q?MvNONg2wE/N5n4cpPhVAkSmdh+SUM7ckwD48HooYailKIYpTJcnxKVKirc?=
 =?iso-8859-1?Q?c9ciMx81gqjQaYQ54fuQhmRevR9HiRbDbJq4IRwu0yIffV51tus33clDQw?=
 =?iso-8859-1?Q?FrjSk36Dq97WRVnJ9eqBBPpc7T1zFlJX8P/RAjAe8MxxdVOGyMw0Ydve5S?=
 =?iso-8859-1?Q?/q4wppBMyf3bhSF1wM9LAvATOn34pGYzVjJFurnFa3kQSiKZsquHWGZzrk?=
 =?iso-8859-1?Q?8CMCRh0DqC5la6QAJrJS1dQrmpzmSymm8ITnJknwUTuKfrxGHWCAr1RBXR?=
 =?iso-8859-1?Q?9RQf2jhZ6jxX3pubCXiIUmVVbsljVqmQUPRz+h29Tg0kdWOH5VZT2PBCgS?=
 =?iso-8859-1?Q?VRkRGVe3v2xTdgTvkfCMAQJxQsnkAJGqBNaW+AXmg9RXCXSyR2k1O4T8sO?=
 =?iso-8859-1?Q?v4ma9TG7jBNUAFkDbatSMT+dvm9JPGmf7/EA0Nb8oBnc9dcWEGzsWb17Q+?=
 =?iso-8859-1?Q?TtFCeTkunfh42Rqz/tObtW6fhMXWdI+YYvm3Lt0gWlsMOTOxjsKCDOXRik?=
 =?iso-8859-1?Q?a4zucputHf7aQcAoxCpq9t+P6++Wto3UlZZMTrLivRy+riTZ+j+Xy7f8ay?=
 =?iso-8859-1?Q?Q8tVYwNX3FAnNQAd0XlYEHA/vADcGH0vBI8NM08V1NIvBSt20kYebFc+QH?=
 =?iso-8859-1?Q?7jQ5LZwz1h7AbE5pKnftDyO21Mmryqlw0WL4YFTKIuY1Yh9zUy//pWoUwc?=
 =?iso-8859-1?Q?pCqrbTCWi0nqTYSjj9PF8tw411Xw2XIQf3JEf++JzJB8GfGeflxkf8TRKI?=
 =?iso-8859-1?Q?WDqjkPZ+ysJtvxNXxJUuUHm5q28lMIclt9mzQezWfFUKxye14rvFreli4B?=
 =?iso-8859-1?Q?oa9U3oxsXyLg8264oE9pxoQy3gQe+tLiLXwhALl/+wJkIxlO2IpWj8vAxs?=
 =?iso-8859-1?Q?u8bdodk8b+QsaTgVLe7oB62/8nXNLQ5LcoFauB9U08aNbJKeldDJ5cJnxx?=
 =?iso-8859-1?Q?0WBZwF21I3LcqR9Yy60+m4hXAXVa0mSiOst5r7hJU7dJNO8VyHbtkb5MHo?=
 =?iso-8859-1?Q?+gXf/2Cv7SXwiluoDdrAg4vDlVgHVR8DPgRh6/+orCRmXOKpThGPaLOPOv?=
 =?iso-8859-1?Q?1d9JOJEbB+OfhEuR65pjow9tvchTAUmc4vgibgez5uiOMfy+MOOSEFMh4a?=
 =?iso-8859-1?Q?fWE/JCvpU5J/3e0w8wHPwZ4mWBuiUjGLL/d2B7fuow0jva+gZtnxz+cNuk?=
 =?iso-8859-1?Q?+MovMY+DvrZE0OmzGha+sQ15gYuqacAYfiEDVdmqT6Sw3MfBMvzAXohxaL?=
 =?iso-8859-1?Q?kE17kaYUOWwAKVub2pfMFWqtoI5JPPzxqvGO5PLf/HWnbp2L+a72Seoc4O?=
 =?iso-8859-1?Q?DXTL1ZeAdQb9ehVlkC8KsI+MKpdqdH7fSgBQRRSPg+VE3dtbJ0zsR94H7R?=
 =?iso-8859-1?Q?94vqy8m5oanlAXkWB1JMEzA93WmDt1edpyjZUOsObZpc2PeYJtCjwMg6WH?=
 =?iso-8859-1?Q?CAj0pSpUrie17OrymAm9sGtU9WLkIdU/gmw7jWmd3e6K9rIhDmt7Y8QFF+?=
 =?iso-8859-1?Q?xwTWTLKg+/9PmaQk3tNK62U2fh1ytSVsdpwDbRSOMZhFlXA+AU4ma4LFcW?=
 =?iso-8859-1?Q?0kRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:06:48.1836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: afa882cc-eed8-4ed8-8393-08de5e980148
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000047.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB5764
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69391-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 0B251A7A8E
X-Rspamd-Action: no action

Limit the number of ID and priority bits supported based on the
hardware capabilities when resetting the vcpu state.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c |  6 +++++-
 arch/arm64/kvm/vgic/vgic-v5.c   | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h      |  1 +
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index c8109dba9807..45fe3c582d0d 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -394,7 +394,11 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
=20
 static void kvm_vgic_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5)
+		vgic_v5_reset(vcpu);
+	else if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
 		vgic_v2_reset(vcpu);
 	else
 		vgic_v3_reset(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 1a0e8d693aa6..4a164ce0f4e2 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,36 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+void vgic_v5_reset(struct kvm_vcpu *vcpu)
+{
+	u64 idr0;
+
+	idr0 =3D read_sysreg_s(SYS_ICC_IDR0_EL1);
+	switch (FIELD_GET(ICC_IDR0_EL1_ID_BITS, idr0)) {
+	case ICC_IDR0_EL1_ID_BITS_16BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+		break;
+	case ICC_IDR0_EL1_ID_BITS_24BITS:
+		vcpu->arch.vgic_cpu.num_id_bits =3D 24;
+		break;
+	default:
+		pr_warn("unknown value for id_bits");
+		vcpu->arch.vgic_cpu.num_id_bits =3D 16;
+	}
+
+	switch (FIELD_GET(ICC_IDR0_EL1_PRI_BITS, idr0)) {
+	case ICC_IDR0_EL1_PRI_BITS_4BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+		break;
+	case ICC_IDR0_EL1_PRI_BITS_5BITS:
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 5;
+		break;
+	default:
+		pr_warn("unknown value for priority_bits");
+		vcpu->arch.vgic_cpu.num_pri_bits =3D 4;
+	}
+}
+
 int vgic_v5_init(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index c7d7546415cb..ba155020ea99 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,7 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_reset(struct kvm_vcpu *vcpu);
 int vgic_v5_init(struct kvm *kvm);
 int vgic_v5_map_resources(struct kvm *kvm);
 void vgic_v5_set_ppi_ops(struct vgic_irq *irq);
--=20
2.34.1

