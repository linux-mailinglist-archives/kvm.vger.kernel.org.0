Return-Path: <kvm+bounces-70424-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMjADfyuhWkRFAQAu9opvQ
	(envelope-from <kvm+bounces-70424-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:06:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A51FBCD4
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 10:06:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 18E233032966
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 09:06:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC3F3559EF;
	Fri,  6 Feb 2026 09:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pCZb/w6X";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="pCZb/w6X"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013031.outbound.protection.outlook.com [40.107.159.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F42355023;
	Fri,  6 Feb 2026 09:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.31
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770368757; cv=fail; b=rY7RIxf4fQsGQYp4h/8FFBeqIYqvAYmNmijnrhkKtJDvhbSCYDqt6Sd9c9ot4D11b20qpv6cIaN8Lnd2hn1T2xiyz/SbUJ59O+OdQ98ZblOZsjYimsnFOzka0nAcUra8mHI+/NurP7vAvmF7bH9gteHeT0A8iLiWi0qI+De7A/8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770368757; c=relaxed/simple;
	bh=XIoRrU/l13aPVLYAspNOY6Q5EB3j/0s63tJgQaKj9j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tLd5ZIsdtbjAMI2jrG9KW4GVK41UBu9MkXURuebBSlzUK2BcNMKL8+URDVdD02ZJFHq+YP6A6AmofmljI+4Yq9G8VYFsi6qSlt5Nmtd9zgvXP8gvwB/q7CQj/yCLuC7aV7fFb7OLMczrbpSCugWy5kOEL74afkFxw2PfTDh4GuM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pCZb/w6X; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=pCZb/w6X; arc=fail smtp.client-ip=40.107.159.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Cle2zyMcEMmihGXbP6tuX5RQpgQBMaAqT4wCIXoYXcEFDTFzu2fmlU/w6bDwhNp/Ts/Q1fBtZeKK950DYmLxAI0+nBk1+NJ3YboIMGUfCinQ/yf/B4ymsbg2gb7jC956yselsDNUL0laRDsRs9osTovULFi+pZNNUpFBPU6TuivT86b5epvgSnw5Fr7NH8CoGGn6p0DoetRPtLA8Wj5BAqyMFbC2jgGAyKMwYiZqrI6LcvsZGBOg/zQuiIRnn2PMrftSGSFYeHxkzKxb1pNiXP3kV3qam/wALauinV5sPZf7BOHyGA0Bm1wiSFNTO7jbE9pS75BxkUfdgn0XxoQjKg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2nCGDmSB5kxFeYZKwYb/bVPCanKnDnSu7RuP4rgChs=;
 b=Frq5JLbfAROFVMVrex94uGDyfjf46W8DpBcv5f8n2f5ShwzFVrCDbHC2HuGaNi6/HFhUzgswbL+1WdMRgNwI7yC073F1FgxDoyeXGtPIgICexQSTrO+fnQ6H+0HRhe8QMs1bUGSOwSTF/WkC4Bs00hvP8UQ1NIThXY/8GKcHwc8M+gBudZhoCa2EwCLTziEtyi4KPL4KkRzcZC6xf9FkuIbgINtmXqMymHdL3jcCpaqP3X0VL75d9JqbNyjIBKaSSOsYZw0jQbzBXMJJfghmDxBSANg/A4s9Kmiz4Ti9fuhgxVugP2KiPthTgI68TIRhRzaPGo7KK3S58djE+aqBaA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2nCGDmSB5kxFeYZKwYb/bVPCanKnDnSu7RuP4rgChs=;
 b=pCZb/w6XUZEMV00mAQlv9HvwDqbUSzhkqaexdJRv845KpgPrZWjpqz9HNnSzcEL4rHUSrtzqcBPByIw5ZdsHqdDX76n918hok56DznS8hh2IPrhYvcB3HUqRbBXGMtaaXmz/RAAUP6C5NVn42b5skkwC+DwvcmOp/Rk3TM4b8tA=
Received: from AM6PR01CA0071.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::48) by AM8PR08MB6436.eurprd08.prod.outlook.com
 (2603:10a6:20b:365::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:05:51 +0000
Received: from AM4PEPF00027A64.eurprd04.prod.outlook.com
 (2603:10a6:20b:e0:cafe::f4) by AM6PR01CA0071.outlook.office365.com
 (2603:10a6:20b:e0::48) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Fri,
 6 Feb 2026 09:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A64.mail.protection.outlook.com (10.167.16.75) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.10
 via Frontend Transport; Fri, 6 Feb 2026 09:05:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pWG8ViwYrdH8Zy9is2rt7fqnT12bnMw70NVHx4KTA3riUO4c5i58xqBWw1m2FYoMtoIMMG1xHYZdgyi1pcbsfLQKs3nRS4GXqHETd6jA/eqIjERQpJrdccbOvnJqTsummvv+NbXYthzof2XGQ5iZCn3qfBrVE2nYGMso+i7XbvghJvxm14R8WYG6XnJyEoBMfO/CQAAZS8CaWnsOm39A7HzwwbCJY6uqwFaTiR8kDSH2Ux7LOa5J/HRXrNGAYF7cx91b+qf2axJ46/mHHF2ULp8fIQVKtYXfjLIQuavweKD6+YrmYCbLVbHYF+q9kWuFCcUrret1Vc6MQi9OD40wOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q2nCGDmSB5kxFeYZKwYb/bVPCanKnDnSu7RuP4rgChs=;
 b=beHU18XO+poAPorW4hNDlpkRpXkJ9zM94HVna5gLH1S6ib1wHgdW5EwasDbDrzvlts5rI4pWROKgLkRWsVv8oTsH2cx0Maeod/f55BB+ihhT3CBDG58U18NV4ep+lmgS4g1S0l8cBRzDF+oCOQB0z1KIoLDaX/EQ6iVy/AKE689j3c9PgDnDmP3etxRqWhtOHYWP/OEIzTu+YfxcTa1rwA5mmI0J1GSjL2fJggaNybSjS4DFH1W3if2ot7ptIqu3lakMOdd/VUyi7eLf5RGfvtACtgxJP02De9H/rFJg6WkBHGlAuGaFAiomqAUYtwQ2WsqZAYmbxu5H7bv8IXyvDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q2nCGDmSB5kxFeYZKwYb/bVPCanKnDnSu7RuP4rgChs=;
 b=pCZb/w6XUZEMV00mAQlv9HvwDqbUSzhkqaexdJRv845KpgPrZWjpqz9HNnSzcEL4rHUSrtzqcBPByIw5ZdsHqdDX76n918hok56DznS8hh2IPrhYvcB3HUqRbBXGMtaaXmz/RAAUP6C5NVn42b5skkwC+DwvcmOp/Rk3TM4b8tA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB7338.eurprd08.prod.outlook.com
 (2603:10a6:20b:445::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:04:45 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9564.016; Fri, 6 Feb 2026
 09:04:45 +0000
Date: Fri, 6 Feb 2026 09:04:41 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 0/7] support FEAT_LSUI
Message-ID: <aYWuqTqM5MvudI5V@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121190622.2218669-1-yeoreum.yun@arm.com>
X-ClientProxiedBy: LO4P123CA0454.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::9) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB7338:EE_|AM4PEPF00027A64:EE_|AM8PR08MB6436:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d7cdf86-2404-4b1f-d09c-08de655eec44
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?H85BW84MyFAWWvwMCVK+LtedMiTgsEALHlGTa8G5NWIZ4tWzaL8DN9kX9CWo?=
 =?us-ascii?Q?TBp/wQumGlPCKRPq+dZ4NOq4iqxHJcdy8ip0UIzC4KvPecDzjYFQtio4wHm5?=
 =?us-ascii?Q?dz8tWMH2Ds83Yzq3l7xVldehQa7YYu2UBtKy8G0ZnSorgPZ4/psvYL5K4O/o?=
 =?us-ascii?Q?VpTmxqbOsYc+/JTrA8HoJBISppICpQLi4KB+tywzInfHV3yrJ9j/YQQNYrqz?=
 =?us-ascii?Q?sj+Y62mxBdRK13qPxBb64QLYTWr9mNhsWIU33lj6MwX80q/+5Pz3lMzmRoJj?=
 =?us-ascii?Q?xlJ7MSROGiQnllo516zk+AVpRb9B9EPcNFgyaFZjFrntARDguHGgXI/iqx+p?=
 =?us-ascii?Q?L4YqP6SEukTHr3qCgczCcF9FKUEBIeW2SU/cg7nG5gobHz8aUSktGvpjK3Tm?=
 =?us-ascii?Q?m3aVXpcXS1xSdSFZuOrrfjVtnniEJTH8Z7MTXJuAMefuIGp6Uz2spcyVA5+T?=
 =?us-ascii?Q?C2G0QNcgqND+Rd8nlZjpeYxmNz0Np+cV3GWKMNSVUwSoFlAa002qyZ954x/d?=
 =?us-ascii?Q?9RkZHkqW3fk88jndaQ04XAXETylnZbTdAULWZODGBDzcH6v94M+u0AM5V8gx?=
 =?us-ascii?Q?4nkbrhwTbiljFtPvhuOmoC7s5xkp3BL57YHI+cruvBsiU2ybfRkLJ38vbl8g?=
 =?us-ascii?Q?JNnapWTQuTBnhNPak+rYikG0b5BqBtDIb41Wu9nIZ6EqEKtBzxKJ+vH+KkHp?=
 =?us-ascii?Q?Umqd39umfMV0bgBBX4Tn7ZqIud6kp0RiWHhlZxKoPaE1zpJZgh9I5b6a5cn2?=
 =?us-ascii?Q?jj16wjtqsc2RahvEJ6CJ5RLLkE/JQX9weti0nuDo/s3tkQbKk84rMwvmQVAU?=
 =?us-ascii?Q?Rw/vX+6e7/xY/fAYRCDvBXe9hU5pNm486y5AuwP2uFX9M/DV90f0uMzp+aKo?=
 =?us-ascii?Q?VKuyYO7peeuP7mVQfEXCQMRYTp1Rl16M5PcKja5E51lmw/hB/8qLNY4eo+wK?=
 =?us-ascii?Q?0nwYcBtMGUyGXT3JFukdk4rLWp6gk42cIusvZsFc/PkASn4geMctCVsdnbKG?=
 =?us-ascii?Q?oYB453XxSI55RtwWbvWzye15+uBe9DxhlpLHUiseCT/DomO+KEE+LPvPhQ+o?=
 =?us-ascii?Q?Dnr3umw6xSj4/y1u3ASoeJsgSzRMR4keLvJo5RylRj0PU0yLb//ceKvVB6hw?=
 =?us-ascii?Q?rxK+mQJ7s9OnIACvpZo58GkZAtjGmO01oqYPcTBfJJL47gGBFPeKJpj63tT1?=
 =?us-ascii?Q?6NKwiVz4PedshGys0BZlo81HIlIpW2alfy9T1y9yogIWx30MgyrzPHPF2kvB?=
 =?us-ascii?Q?ZYdiSfZlA5IxGXWhTxaGIi/7/YlpyDwBlUAHFXKciqefOYjU6AWAqFEHqmNe?=
 =?us-ascii?Q?3p0HMTETQnq2wlGQshGb/nhmHDvaHeWu9w0raZK2n9iQVN24MqUY4d/YTDu9?=
 =?us-ascii?Q?+c6U+TjXnhkuo6ZG/CVPZ+L49z/6e3L580oy+gTWcDd/LiIl59IBnBHbkq5Y?=
 =?us-ascii?Q?/vYgKW2S0RPeF7AY0jsqw9COx2Sf1BwCd4J00FsXq1WfJdOVntuiECW3Om2C?=
 =?us-ascii?Q?qC99Vmg8w362MxTE7bwP3gzfE61B360VK9t4H7jdwRuTIFPaFZDapXhk9eVf?=
 =?us-ascii?Q?omM9HshnipPkFjPtEk5537JcwnKIic4zsgMqhTDE?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB7338
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	513d1646-f7b5-43ab-4896-08de655ec568
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|82310400026|1800799024|14060799003|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gi//4bNvwUI2sKlm4S7JqwKh1s3vkENwxFH+HZkeYntIBlkkZMpdFFhCZmG7?=
 =?us-ascii?Q?GFmFD3NfHVaRmM/Q3JCnNLIj8v6yTqAWq0U/F+ysfkp0c32kLCwZO+zBE+8n?=
 =?us-ascii?Q?o0MgiTEyXD9OKWY33WLRcwyh/tX71e0vPhKfqNBmNRCeDcMfk1ThE+ERzGhP?=
 =?us-ascii?Q?8OsjJsxHptfT4kttdexQ2YSdBX7tHTfmCntQNq7iuaXJjGrbLhbGSn8fhxvx?=
 =?us-ascii?Q?Cfwd9wDDeZIgk6jX9ojnXE98GeR8gaKmAcXTJhp6wuirLEuHVaBly9ADgNBE?=
 =?us-ascii?Q?N7q7GkFXEn7XJMw+Iyc5vtAWe4pDR/DhHVuonDISK53ZquvlfKHQLeh0onLo?=
 =?us-ascii?Q?b+ttaBWk7oD1D0PPLXBC6LB/JzaS7Qc4VPcm7G1vXbgPXvMzQPnggtn7JIL2?=
 =?us-ascii?Q?4zaAAzqcu/NR7F0hl9ZPFrbsucNOzIYpSfx5qYlffixw8MeCjo+RYbWKCYm/?=
 =?us-ascii?Q?wz7/6AVXqXgkLCRkEibLSQBud+Rn86cDUHxH+GIJFzDEGSKPf1nGbgOcEyLs?=
 =?us-ascii?Q?bqtuDdsRCNrGa7ahHXqPuU9Dk+N/HA1tGnuKnrLUnRi7r2/C/Mr8+NmfOw18?=
 =?us-ascii?Q?/8/NcHjHG6/4swt1QZs/GMqXNpOvZ6j574D8XPl84XsYO01PGCdQ3utdVRMy?=
 =?us-ascii?Q?pE0QsZIiQEpf+PSC8/28Q8xyZNEmBv3cry1ks5bUuD9twrMBihlJkvXhA4gN?=
 =?us-ascii?Q?KS8vYpgQM8pYA6W32zvt3edP6vcyBY8wPoZOZr35hHWJhoc7i6bOQxElygMY?=
 =?us-ascii?Q?fNRL3j+q/mjnw33KnlZILO9iJqYmphMCNcyvUjiuLUHxbBKzqkt94ISzSay8?=
 =?us-ascii?Q?8WkxEPD27SlucsGmYdUttw9OIkdqDz0o7hwerG0T7yX/eeK0e0D2LyJlD2IC?=
 =?us-ascii?Q?FhevuwF7miRc3csq9TER9nAUpPg/qCiVyx0gNjArAoMqE+IMy4vb4g2eZTiJ?=
 =?us-ascii?Q?RdreM6dE2gJasqDzXrPtScIcpBdQ8Il++LmRmv6K5wDByfpS5AP69I5LnjSt?=
 =?us-ascii?Q?DHZCFzy8PUz5LyDE5+sgr+hBuXjdHSOAgFbP849aNrKXFhSdZvfysMv3J34h?=
 =?us-ascii?Q?Mpw2u3Iwad/YoUN8JcMCMBXOyuI6owGHOZPMa1m6WXIq4gOvKWnOLD5Yvd5G?=
 =?us-ascii?Q?oOzVJVNIwDkZKz1ruahJ1YVI27r2gKcdvyN9pxgNU53kgOmSIvvPSOlBpnMG?=
 =?us-ascii?Q?P4hlQveN/c44lXeustH48F680p2jhkd9113GstMqIUGfyYPp24Yj3eI+cWZg?=
 =?us-ascii?Q?90Ykn7NxkFo583sZTh9jm7qUE3fJVI17vlKmYGDiGtZdD0ELaNFTemt7zN4J?=
 =?us-ascii?Q?iS1+Dm/HsFkj2Lin38zsw+zh5UbhLl47gZ87ufEIQ36A62cpVQVEZ2S9jIqB?=
 =?us-ascii?Q?vhKmFlaun/dJmfZMknKuuu7UgAAEaxQA+6eAWEN/H5uczR7mzEIldHq5TKB/?=
 =?us-ascii?Q?Ddq64QDX+vMQ57hCxT/mu7KJeTfBfYTIvw8ezQJ+R5IACugM1kO/7ZQ1OQ/p?=
 =?us-ascii?Q?4Bul9xTYV4rSIXTof+gqUR1N6EqwIh8iMfOBQvFE8gqhw+tPZIQGAZK3Q3qR?=
 =?us-ascii?Q?9YigX40YWn4/Nch5AhDpX3U5n82qOks6M9NJPkrI96PngWBSrCb/HaObRPjZ?=
 =?us-ascii?Q?QRbk2tf2rh2diq7bcrvPzR4+U66DK9mb5DHkwhVsXVrD2MpVovc5b3n2hxwu?=
 =?us-ascii?Q?WoBhvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(82310400026)(1800799024)(14060799003)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UzlVToVb/q9xagyhR2+pwVl8PVXVcVVTd2/+LvbtHFOcamIVTD+Hpkc0X1v46sEFrmBSm+M11gEeoCag1ynFy+Ikm8XNNh1yWpZ4rzxz5juwWK6Bh3dMbzmuvLygn5vZsRRIvecG3Xu1CjTPPPeJIU0fHOzRGAA6K13ns+lc/XbatSJ8cE9PzR70OSivKUX5ezOcTOOgcgoGJpYccy5W5Hh3Xl4Pf3WeOm5xFkGOv45Jrl21T5jzPPczcBGdIzbpwksJ7zmURluPUc8/p6qix9P6jKyemuGWooblQ+hyeNNRfr1eJahDZ+dShnP1e/1lbbqul9ocVIPfNGBWfWr99JZQUpz1uu9Yxq99lBi9JH893nLX2gVLjgR/tbIDKWc5Ghdf9Gs6hxZ1wlBPwWZBIf7+otwBZOITXHPKKqguwMXh7PZcvLnXSP76Vl4h2Tom
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:05:49.7569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7cdf86-2404-4b1f-d09c-08de655eec44
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A64.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6436
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70424-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[e129823.arm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[22];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: D9A51FBCD4
X-Rspamd-Action: no action

Gentle ping in case of forgotten.

On Wed, Jan 21, 2026 at 07:06:15PM +0000, Yeoreum Yun wrote:
> Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> previleged level to access to access user memory without clearing
> PSTATE.PAN bit.
>
> This patchset support FEAT_LSUI and applies in futex atomic operation
> and user_swpX emulation where can replace from ldxr/st{l}xr
> pair implmentation with clearing PSTATE.PAN bit to correspondant
> load/store unprevileged atomic operation without clearing PSTATE.PAN bit.
>
> This patch based on v6.19-rc6
>
> Patch History
> ==============
> from v11 to v12:
>   - rebase to v6.19-rc6
>   - add CONFIG_ARM64_LSUI
>   - enable LSUI when !CPU_BIG_ENDIAN and PAN presents.
>   - drop the swp emulation with LSUI insns instead, disable it
>     when LSUI presents.
>   - some of small fixes (useless prefix and suffix and etc).
>   - https://lore.kernel.org/all/20251214112248.901769-1-yeoreum.yun@arm.com/
>
> from v10 to v11:
>   - rebase to v6.19-rc1
>   - use cast instruction to emulate deprecated swpb instruction
>   - https://lore.kernel.org/all/20251103163224.818353-1-yeoreum.yun@arm.com/
>
> from v9 to v10:
>   - apply FEAT_LSUI to user_swpX emulation.
>   - add test coverage for LSUI bit in ID_AA64ISAR3_EL1
>   - rebase to v6.18-rc4
>   - https://lore.kernel.org/all/20250922102244.2068414-1-yeoreum.yun@arm.com/
>
> from v8 to v9:
>   - refotoring __lsui_cmpxchg64()
>   - rebase to v6.17-rc7
>   - https://lore.kernel.org/all/20250917110838.917281-1-yeoreum.yun@arm.com/
>
> from v7 to v8:
>   - implements futex_atomic_eor() and futex_atomic_cmpxchg() with casalt
>     with C helper.
>   - Drop the small optimisation on ll/sc futex_atomic_set operation.
>   - modify some commit message.
>   - https://lore.kernel.org/all/20250816151929.197589-1-yeoreum.yun@arm.com/
>
> from v6 to v7:
>   - wrap FEAT_LSUI with CONFIG_AS_HAS_LSUI in cpufeature
>   - remove unnecessary addition of indentation.
>   - remove unnecessary mte_tco_enable()/disable() on LSUI operation.
>   - https://lore.kernel.org/all/20250811163635.1562145-1-yeoreum.yun@arm.com/
>
> from v5 to v6:
>   - rebase to v6.17-rc1
>   - https://lore.kernel.org/all/20250722121956.1509403-1-yeoreum.yun@arm.com/
>
> from v4 to v5:
>   - remove futex_ll_sc.h futext_lsui and lsui.h and move them to futex.h
>   - reorganize the patches.
>   - https://lore.kernel.org/all/20250721083618.2743569-1-yeoreum.yun@arm.com/
>
> from v3 to v4:
>   - rebase to v6.16-rc7
>   - modify some patch's title.
>   - https://lore.kernel.org/all/20250617183635.1266015-1-yeoreum.yun@arm.com/
>
> from v2 to v3:
>   - expose FEAT_LSUI to guest
>   - add help section for LSUI Kconfig
>   - https://lore.kernel.org/all/20250611151154.46362-1-yeoreum.yun@arm.com/
>
> from v1 to v2:
>   - remove empty v9.6 menu entry
>   - locate HAS_LSUI in cpucaps in order
>   - https://lore.kernel.org/all/20250611104916.10636-1-yeoreum.yun@arm.com/
>
>
> Yeoreum Yun (7):
>   arm64: Kconfig: add support for LSUI
>   arm64: cpufeature: add FEAT_LSUI
>   KVM: arm64: expose FEAT_LSUI to guest
>   KVM: arm64: kselftest: set_id_regs: add test for FEAT_LSUI
>   arm64: futex: refactor futex atomic operation
>   arm64: futex: support futex with FEAT_LSUI
>   arm64: armv8_deprecated: disable swp emulation when FEAT_LSUI present
>
>  arch/arm64/Kconfig                            |  20 ++
>  arch/arm64/include/asm/futex.h                | 322 +++++++++++++++---
>  arch/arm64/kernel/armv8_deprecated.c          |  16 +
>  arch/arm64/kernel/cpufeature.c                |  27 ++
>  arch/arm64/kvm/sys_regs.c                     |   3 +-
>  arch/arm64/tools/cpucaps                      |   1 +
>  .../testing/selftests/kvm/arm64/set_id_regs.c |   1 +
>  7 files changed, 339 insertions(+), 51 deletions(-)
>
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
>

--
Sincerely,
Yeoreum Yun

