Return-Path: <kvm+bounces-69398-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aJUMFORRemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69398-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EF51A7957
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 350C63077ED7
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03279372B52;
	Wed, 28 Jan 2026 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aV+g2PnK";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="aV+g2PnK"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011014.outbound.protection.outlook.com [52.101.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FAC6371072
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623727; cv=fail; b=qX1YIUT7jNRnudxk3KbQ+WU6VlyELVKEapKKBGF5wSHsxtcA6IKBrDm5IWG0aR4vuA5XY4UXCNd+CAAoAzNNWzBeN8DigaOjJ+3Xk9BzQehaP7ebLYFK904LOPfo84NRKgQEp0NqFhOnmyTAa5Ho51s7qeKlE1C4u5aOd/O6hCY=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623727; c=relaxed/simple;
	bh=PPKkPKKK+LJnYm69XDnq9xBoVAx7V2HUehG385t5MJQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AvzLBiCFNrR28Y8sb80dP3/DqC+YVZKhENCcdcYv68FOwWv3l85gGo/8xdoCxNnepM+CetgtQ1C90ArtAme5Lxsejh5Rp/iRaQLmkd2bT+5Iiu+9SDwTDSQ2c1VDjEEwxLB9ZUx1mV8kZOtKQPd554gVvYjJpjjAVth/v6qqqMw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aV+g2PnK; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=aV+g2PnK; arc=fail smtp.client-ip=52.101.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jPZY1yhOsngUlOvJZlqWxpqBV/Gduti5Mhse/N0HtYkZemJB1tz2k2xaz+F6GRRKTwbeRSnHDqGW15MKJrEH4Kb+LTcfLEHu68lrLXH4L250qMnNIaELwBg62WdrnRsgRh5SjV9P3zmtvGK3f2euWztHIRzv1y7y/IROS9siNYDdCYMkwDXNIHfnf64Tv2qBOpG+itpDUHlcVQSW0p/+cJoDli1TI5MUt+Zlf0M3qykozn9V3DJmPm0sOkRqKy79YHbhl7Q25z0+ZRzy4EHfdgII+uwhIVM7/cmVWwxStCXbEZc0677WmSKGuJglCybpPN9lGpLJpxm9IPI/1iWB8A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytRYidbCkrk9wG1vspfmtbNpy8i7uN15p+arY3D/jKM=;
 b=e/KyMWAStOVbI72lGXW31Wzhv9wUm+WN78W8JdkzFvYLu8c1XsCQHFRd5J81m6Te7USI//Ewkioeb/cXMY7B7D7fBxoYBGXQsSLeoXSsi7NzD3npXzXup4W8z+mbMaMGHeTd34k+1+x57o6ri7fyz4fkSMeCUXamM8utNbEDCLQJqOjwMPN1SJcWotOcFdXEB2ZIhnxo2iCwmkRt0Zhe6q9GaqzqxEfJtx1NoAZNByfOYd6LcgcLTnoq0GdugByjHxTzovFcZZETYrrVZI0iEU08uKIMix0Z6kUxfPq+w1EX/NLP8HOT4cngtNxFRTUbSe4DYIZqLgR9d2bUy0WSUQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytRYidbCkrk9wG1vspfmtbNpy8i7uN15p+arY3D/jKM=;
 b=aV+g2PnK5RQy0Qp2AAQJucK3MML1fL35WgY/SSEqsu2VvfXZHOekgmnzoFS97bbErKUABv3c1AHbNvPtSBb3h4Y+Bq3Zeg538fnzomGC43knYe3bPZIYXhZZFHAPTh1zaj3oU7GdocW7CyFGcD/DeAioMLPHvhTnRPZneVpHKp8=
Received: from DB9PR01CA0005.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::10) by DU5PR08MB10493.eurprd08.prod.outlook.com
 (2603:10a6:10:518::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:08:39 +0000
Received: from DB1PEPF000509F7.eurprd02.prod.outlook.com
 (2603:10a6:10:1d8:cafe::9b) by DB9PR01CA0005.outlook.office365.com
 (2603:10a6:10:1d8::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:08:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F7.mail.protection.outlook.com (10.167.242.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:08:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KgYrd64cLbpdTxoFwCMXHQDjnZ/Y7wMxHbi6zC9OjpLZLuHM0cPyUoBw40w3Gq01jp9UYTNF8VWNKGzHZYt9TQxg+eZ/bDCf4K6OD8ZoM4Yiejnbrm/j9hDLCq8bn9IXazA1CMavg/oWtj8zUiZuta2WckTVne2YqVo2KRhkXCTBaHMBPIC2wtVDX8/54BuU74rCjkiPQtYxw/Yw/9zXi0Gre87YR+pF1vyXk4x3B19sv2ANAXcLyH6LPNYUo0C8XqCO0rfANs43t7DZ1Cd3+7BUu1hqaQtLCgw6qdIkyZlX6TcFiezIFEw4Us4lnl+R+8//qCJYvChRd316n+5T1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ytRYidbCkrk9wG1vspfmtbNpy8i7uN15p+arY3D/jKM=;
 b=I1w3Rysc7rEJUAi65w9wcwmAGssuy2gEJzfa/wK7rOOkblz86L4TlaZoV8T/h/UQioENNIhihAT1DFDyqzrTdE7MtteKDDxCFAXYZR/++aSjZzWAPJjAQF3Jd36K52sWcLMCVO++WZTOOn2c3p5LpBog7M6Ir7Io9pTmVC3+qzq0ZLpTEmUY4jMBscLzoB5WELIQUQqOvXggP3zs4KMwTv5MwV4e1GQxgJuhFe7+AZ6FHb1LhU/5kZREmve8oSKtyWLTfbxK5jOr+j9GN9IuD8KARpRnN2JadHIJbTkJgZMSkillAYyINkn5A2JYhzVohiQRTgLFzcPl8/hothJ2Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ytRYidbCkrk9wG1vspfmtbNpy8i7uN15p+arY3D/jKM=;
 b=aV+g2PnK5RQy0Qp2AAQJucK3MML1fL35WgY/SSEqsu2VvfXZHOekgmnzoFS97bbErKUABv3c1AHbNvPtSBb3h4Y+Bq3Zeg538fnzomGC43knYe3bPZIYXhZZFHAPTh1zaj3oU7GdocW7CyFGcD/DeAioMLPHvhTnRPZneVpHKp8=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:07:33 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:07:33 +0000
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
Subject: [PATCH v4 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Topic: [PATCH v4 32/36] irqchip/gic-v5: Check if impl is virt capable
Thread-Index: AQHckID5tQirLkjj/kOXNQEu8G8Q2w==
Date: Wed, 28 Jan 2026 18:07:33 +0000
Message-ID: <20260128175919.3828384-33-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB1PEPF000509F7:EE_|DU5PR08MB10493:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b7120aa-6779-46b8-edb1-08de5e984381
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?irYZh3XebkzLcH3Xjy97fhRfGt4iKeDLXYSe8Py3EGhWEKjtE3keylh2i0?=
 =?iso-8859-1?Q?qjX3MaTlW0/ovfyDWG7HKCgZ34TxVW0z10MpvKyt/uinolyNu2hkJtwbD1?=
 =?iso-8859-1?Q?LMXg8NAchyz64/8/O38QtdlECgnPGe2+cfANMh1HAWwHX3qmi6K++DGb0j?=
 =?iso-8859-1?Q?rzcKBiQvNoqN1ZLf1ZbOPrWsJRT8fR8YrIw3fh7hudM3cqHwN76B2UE8Pv?=
 =?iso-8859-1?Q?WXSQ3rOvRcRMG+E880Bdig2aFuqYJ88H8ErpWTOq90ipIMU7uUR0IFb7nH?=
 =?iso-8859-1?Q?L1iPDOiOs6GV6G/lP3tkpfT52UFZdwDiMDxRol23fEoNQ1zknKtaTAm14X?=
 =?iso-8859-1?Q?eJ1xvgjMIbBIanxU/DjupFn1KpuslJLmV/XTw6pYnfi3CSwOVX2hjDIerh?=
 =?iso-8859-1?Q?xKfrg0HX35wr8MaTzQxfT1Y6fukGxxIiL3TEvIZRyFempdmWlr5MXAidQa?=
 =?iso-8859-1?Q?qHLKIzdP6C0Ex+dqnb8XdwCJAjYi5eXG6e0J5X6iCBwpqs+kwnuS959thR?=
 =?iso-8859-1?Q?yEkhDcr+bYlL3nm4nho0xWLfXXDsYGFXsdB55pAfPE97uC4pGiQ4DsZd3H?=
 =?iso-8859-1?Q?detXvpgj6rFs3lS1Z4qqpXAs0VahZkkV7IcccOnicUWrLf+TJlJiIG6yVH?=
 =?iso-8859-1?Q?wM8Jz46bQiPLCfAluVS9Y2Wysj6VLlKFYZG/PDZf+jy/8sJldXTl9CWYJP?=
 =?iso-8859-1?Q?onau5PGjkObJwcVVXQxkvCYXZSl6wZa7W384glKPQ34PJYVj/XvDlbsfN2?=
 =?iso-8859-1?Q?sfNBcR3cqHW5B+r4ZRJnduLbxmnmBt3t7Z0G+fOpxWJXs4snb7f0mPZEqK?=
 =?iso-8859-1?Q?3oilwzDltyqGTfH0gSs9bw3lWcj+MFjyXkWTwDcDE1gzWBwkg5vw6+e9gi?=
 =?iso-8859-1?Q?46qSlTqqiv3pfbBLne9j8xGdBqAVwTt3Y/RgxQcroAm3STeTuYElSAox5f?=
 =?iso-8859-1?Q?78JT0k76+PTAVNMc4XPHGZN/It2OIBLGh8RKqKBj5dKedhYcn1jiCTSK8D?=
 =?iso-8859-1?Q?j80Bn4ohZJQhxaxJd8KtWbUoIXqcknaJzFG4MgvyFHJxz039K2ExWdHlJX?=
 =?iso-8859-1?Q?VxS7cijeJjglxPV4vcPOWbc/ofIeIFebf0VU93isiix0syvCbBLiJqB2A/?=
 =?iso-8859-1?Q?T49JS+lM8Uh2WkYn4xc9HmD7SepOpeFtcYIyWZYCck0c9+1tC6/fLyaTDF?=
 =?iso-8859-1?Q?n1yo9ONiKZXRcH6owlMDPQEySvBngtzk2SDN+rFUgtsMtItOqW9UsTJwTo?=
 =?iso-8859-1?Q?QuT4cMcNaOdbzuixPWDa8EZ2VfxX0MDDvtWCdVUlXi+NKprfxQ5HIwJSeA?=
 =?iso-8859-1?Q?MoMRgE+RZJDAqVPPzd73G2ZkSW1ZGsT+IUSSsNjwlmxQTwo177twP2w7H2?=
 =?iso-8859-1?Q?8JaL0T/KaUJdQxtiO50IO22gaGQgR7h+D+hGVWMWDlA20DIImokxlUDCS+?=
 =?iso-8859-1?Q?B4Tb48+dEobkA8XBzePfoKJbXpYp6kcFJV+AuZ/rIoRGdR1Lq+VEEeOMZP?=
 =?iso-8859-1?Q?6O1fZ/i9FyHwQG/qUpC1J+Ji2Kq/PWsL6jMiV/krzhbUo9s0/tS17UB+mu?=
 =?iso-8859-1?Q?a1Kyb9AWAu2iIj/ss7Ma8SHzHy6H7N3+37qnnLWrytOHK3502EoN4hpfjS?=
 =?iso-8859-1?Q?9OU6wWv4QyCeOFxjv0tHEiTvRS1qu2cQRGjgDwOVHw7OaitiiEbBPgtpJd?=
 =?iso-8859-1?Q?5tYk64X19sxpbK2ymII=3D?=
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
 DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bfdfd7de-97ea-4876-8150-08de5e981c4c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TYBm/Ax7EjkHWfH28LuN7aaAF87w5mX7KQix5qzCvD7A1/UErZ4S6+r2an?=
 =?iso-8859-1?Q?wutWdfGa93rtITYu0LtVoemekBdhmaGNphcZ+/DeLDlMSduvNAmmDotqwE?=
 =?iso-8859-1?Q?8o9HeNvyrEaYOuJNoMwTkOGM8yYS4aaYNCBATWzNtgTnNE6uvOGxEKGLdd?=
 =?iso-8859-1?Q?siNkLUCURnS1UEBruEXPZGt3jHkpZYp5mmLFUT4WfnR+VWHgCfgx+Bj/4g?=
 =?iso-8859-1?Q?VyvMwnxf6yd16atvYvAJv7MIe01sg80Z8bP5SbWSmwOLckzZXwyCAfiF/C?=
 =?iso-8859-1?Q?DNdJSHPTBWFJhgIFPhtKILl90Q6PY6dGwHB4uugwmCeo2M+gdLeK+VGnfd?=
 =?iso-8859-1?Q?QDtzyBZZW1XT4Te+/BXt5oy/bMOTnL9jmxMjcCyNQAtFA3z6bieVN1k8yH?=
 =?iso-8859-1?Q?AEUjVBwH4BRbYHwDAQplgurbEFcghiH/L2Dk9Qzff3oD2Ke7aKVJtoG40D?=
 =?iso-8859-1?Q?boh4GXFzqmc/0EkjuvNi9208z/dDmurm+AG3vuUiF9XFj6BnKEE8v3a0of?=
 =?iso-8859-1?Q?7+kS6rAlLoaKg5QqNwaD7KaC9ewPsGt1yPoDwYeEWgku3sAExinCF40Xa3?=
 =?iso-8859-1?Q?P8LLK/PBjSnAHL+ARmx/9V3imLAWchJtaUlQRU9yNSoJJql6Dd34S7oTvM?=
 =?iso-8859-1?Q?PR+ooL/Ec5n3A96Czhi9VFqmP2M4d4xRJ3cUi28oaAnZdWhZnmL/w+xD5g?=
 =?iso-8859-1?Q?NIUpkahXeF+iKOxczklAs+MyERqp++BIV4nsY/0SHt98N1G7mAhREIMFts?=
 =?iso-8859-1?Q?zqcYwfNQH2yYQ7v+ZcYn7wr3M5KBx25S2aaM/W4R+2xAU2/SpDhUUfeBSa?=
 =?iso-8859-1?Q?kQ3CrTciFLGOvu69L1WSn3UqqK/e5OdSUkW9drGARxr0WHFarjyN8jF1c3?=
 =?iso-8859-1?Q?LMRXYcUwK/Q2J0ocguOJxvwCxL24oSe1i8Z0OXW2En5g9gGI/AwQQXe33+?=
 =?iso-8859-1?Q?iwMrwvSdmK42Wp6JAlr7Ciu0+lpfYELepohSkpG6YgEuEG8gDG5AsTjzD/?=
 =?iso-8859-1?Q?FgztEOTyqR6h+nSIPvJbDFzXBxlXJsQnNry6FqY/RL3ISYqN30lHhZ6lV1?=
 =?iso-8859-1?Q?Qm8QEqhIKY9S672bOW6QGhUIqSFoz+jLXQZI1FBPR7Shn5GMarYT7N7j/J?=
 =?iso-8859-1?Q?t7D+7q3bw2/Rps1po1vvwe5U5xjgJepyKKcqiBQoA3zPsqwSkrZHDi4MgB?=
 =?iso-8859-1?Q?mNjqCj/H4yVH5WptpIAqRqU9PvF5fdiZwBwXYmPwoSHv6Byo1npPNuxh8F?=
 =?iso-8859-1?Q?Gj7mPOKF6Ka57yFf+2Fbcif8pK3b4XYE/RFzUQwzQLUdvuRhQ7RNBL+foN?=
 =?iso-8859-1?Q?LqjgTJJVhXWTZl9QLCUr+So/5u6VVP6K2sDBNWBx7TbLia1frtrMwI42yL?=
 =?iso-8859-1?Q?0iEAFmS5G6oyLF3MYRaLqbIrPiH8UC5pj2S80kSy9YO/nH34mUZwZg9opF?=
 =?iso-8859-1?Q?noUfQv3GHBqDcKc1EbxfFugFHLcElhI0eUHX8HZpJQvJhOuSuM8HWoysJ4?=
 =?iso-8859-1?Q?Ky2rfyhbdFnHFLXM/6ENiHq1ZQF0fxKtkPq/Wrg+1oMPuZA0l+vkIjM9o7?=
 =?iso-8859-1?Q?/s1iPvlz3szvt1P6axLvxJQPToWUbg+I2eTd+EfXtbQSGCKlskan7+AibH?=
 =?iso-8859-1?Q?C0q6Y5wjrARgR7nIgPRpzfbQj0AqxWooOMjgzYZHfgPaS1evNe/vi5EhjU?=
 =?iso-8859-1?Q?ZGxf+GSSExhGpAgGNh3tmtqvlK9jdbouXDTMfy9hTkRVhg1Ld9YkUcn9nL?=
 =?iso-8859-1?Q?r/Dg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:08:39.2837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b7120aa-6779-46b8-edb1-08de5e984381
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F7.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10493
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69398-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 2EF51A7957
X-Rspamd-Action: no action

Now that there is support for creating a GICv5-based guest with KVM,
check that the hardware itself supports virtualisation, skipping the
setting of struct gic_kvm_info if not.

Note: If native GICv5 virt is not supported, then nor is
FEAT_GCIE_LEGACY, so we are able to skip altogether.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 drivers/irqchip/irq-gic-v5-irs.c   |  4 ++++
 drivers/irqchip/irq-gic-v5.c       | 10 ++++++++++
 include/linux/irqchip/arm-gic-v5.h |  4 ++++
 3 files changed, 18 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-=
irs.c
index ce2732d649a3..eebf9f219ac8 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -744,6 +744,10 @@ static int __init gicv5_irs_init(struct device_node *n=
ode)
 	 */
 	if (list_empty(&irs_nodes)) {
=20
+		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR0);
+		gicv5_global_data.virt_capable =3D
+			!!FIELD_GET(GICV5_IRS_IDR0_VIRT, idr);
+
 		idr =3D irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
 		irs_setup_pri_bits(idr);
=20
diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index 41ef286c4d78..3c86bbc05761 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -1064,6 +1064,16 @@ static struct gic_kvm_info gic_v5_kvm_info __initdat=
a;
=20
 static void __init gic_of_setup_kvm_info(struct device_node *node)
 {
+	/*
+	 * If we don't have native GICv5 virtualisation support, then
+	 * we also don't have FEAT_GCIE_LEGACY - the architecture
+	 * forbids this combination.
+	 */
+	if (!gicv5_global_data.virt_capable) {
+		pr_info("GIC implementation is not virtualization capable\n");
+		return;
+	}
+
 	gic_v5_kvm_info.type =3D GIC_V5;
=20
 	/* GIC Virtual CPU interface maintenance interrupt */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 21ac38147687..c9174cd7c31d 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -53,6 +53,7 @@
 /*
  * IRS registers and tables structures
  */
+#define GICV5_IRS_IDR0			0x0000
 #define GICV5_IRS_IDR1			0x0004
 #define GICV5_IRS_IDR2			0x0008
 #define GICV5_IRS_IDR5			0x0014
@@ -73,6 +74,8 @@
 #define GICV5_IRS_IST_STATUSR		0x0194
 #define GICV5_IRS_MAP_L2_ISTR		0x01c0
=20
+#define GICV5_IRS_IDR0_VIRT		BIT(6)
+
 #define GICV5_IRS_IDR1_PRIORITY_BITS	GENMASK(22, 20)
 #define GICV5_IRS_IDR1_IAFFID_BITS	GENMASK(19, 16)
=20
@@ -288,6 +291,7 @@ struct gicv5_chip_data {
 	u8			cpuif_pri_bits;
 	u8			cpuif_id_bits;
 	u8			irs_pri_bits;
+	bool			virt_capable;
 	struct {
 		__le64 *l1ist_addr;
 		u32 l2_size;
--=20
2.34.1

