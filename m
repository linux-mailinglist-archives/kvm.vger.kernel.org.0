Return-Path: <kvm+bounces-70719-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BJ5K8kAi2nJPAAAu9opvQ
	(envelope-from <kvm+bounces-70719-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:56:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E03E81193AA
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 10:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C891B300E470
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CAEB342CB2;
	Tue, 10 Feb 2026 09:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cKAL//r3";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="cKAL//r3"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013032.outbound.protection.outlook.com [52.101.72.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC7342538;
	Tue, 10 Feb 2026 09:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.32
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770717373; cv=fail; b=QfTLwQDa5fETjac/F+rtS6FuBF+hJ5OeUA+9L852yCHQIW1rJm2CAbpAMEmZWKO3pVcbDF205znSj7gP3wme6mxwGcGHbrd1dYW9K/+shHMLL0dN+IdaugDfcjq6Vf3vtEbucubI/u4AWcWyucbRgK9Osovpwf+X7e5FXDmSC80=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770717373; c=relaxed/simple;
	bh=c7sOzzdw4RF5acABWpvwSOGTA5Ey5kwmEFOe5igcU6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NB7Hm2Br1XrW8VNVeu63u2Jm6fcORX8XdAVGwepF+cPZ43s0GPEanyfjD0y5w3qoBFeqn6yURUUPBGrqYzsd4ouSIDL56EX1pciMyL41zW53BhcwcU0sTNXnmV/RJiAm8Q97d7c9yfCbwhn9jZ0AIdHD1E2b3TWGWuTsh048Mp8=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cKAL//r3; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=cKAL//r3; arc=fail smtp.client-ip=52.101.72.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=l8AyhUddva+QXMGWovpPmuMbUB59QJTqYunLVha3DRGBcaF7r+ClmBqq3aLikqvD50wPa6DDI+00Igt1rQ6YYu/9iaW+wUYrs6jDckNqpI/OMFdRZjTNpsalTpfMMzofsqhonjZBHtk58mkBEATTWGZoHFq3RJ1tlWLJBzKn5r1I0JeBfRncbvVaxXGiW+RcxpJX3JfDZXT25+aOnmLVo+H6FZMsxzpJ4THhT3rk/JlupdpeaslwBQF28gKPUqnXgIfWyAkBBY5DKZa1v9MYtcPGNqV4SsH5a84w8gJyADSJzL773e+AcT5obht9FCsPnNefOoPduufkBEhKQ1zTXg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcmcR0YK5LUm5B3XkaaL6727t2drJukhXIcADbgYmIg=;
 b=yOxAtlkL5YhrsdFa9PGESKGRNy8usGQTr1U5sZ57597sdiMO5i7ImtXUKO/BKngMZiOkjMqDPoi+HyyAMj4YF46TMZCdaWi3+fMDFWdh4Qb0uqcNUKt27WkhzPvYzYomb6JmcHvSV5q86EpmKL9RagljMjpEStI+hoHAn2Nguu3RrvrpztgVXNCYJIp4lWlLKlZX0d49Sqn5INjR4F9vnFWTKrGMjWaZah4GReur4/fqiyWjHpZbNJLRrOZ0ygmrWOhlaP9/iPrcboEne5M4CLdIdzexKuJfTR5rDdlQZrD2R1ZM9bD85yeAXvUPTuCHTNOJ/Lp5valUnM+vHj+QBw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcmcR0YK5LUm5B3XkaaL6727t2drJukhXIcADbgYmIg=;
 b=cKAL//r3x42KPNYlfpwDsCNW1apyFaBw0VAjrXUmzGSpYBJvG42eO87YY6WyhgzWXH7Yzd/+JH/f2/RRXqJkSG3/ixuq67rooJKZxzmQYSchobSVHzjewAMC+GbYTHE/0UmRIQ2socdnd+luPbSLfklAca/vdqpwa/Z/P4N1aoY=
Received: from DU7P194CA0028.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::12)
 by VI1PR08MB5357.eurprd08.prod.outlook.com (2603:10a6:803:12e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 09:56:02 +0000
Received: from DB1PEPF000509F6.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::6a) by DU7P194CA0028.outlook.office365.com
 (2603:10a6:10:553::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Tue,
 10 Feb 2026 09:56:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F6.mail.protection.outlook.com (10.167.242.152) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Tue, 10 Feb 2026 09:56:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AWcB/1y8E/hPUVqE1AI5LdkiFk+vP0EsF2Ot8w9jEr39A5kBfY8LiT2zup6N/nN5b0debrIGNThSuULa4t1o6T/WM+PQX+Wf4vuE2o+0vTGwLS68lfRJbFkfFKIHtIHxk1n/Lp+xe+H1FW215grN1skksDPwwisuO/ai34ISHPU45/g4bEp5dYF2P0XQK628xqjma3mcV1XN82L1XLfyAmLkLF9YJcA4N+AG7YBFiZ2xsJGSpdLx0XXyOwVbi3bqh/Ap1YcWSg/H1kN12QYdLRqwEVZpQmituynzBtWpJQ8W/Kx2blmKF9QT57IiC8YfXMPHZKbamGvjY7kBlDt0ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZcmcR0YK5LUm5B3XkaaL6727t2drJukhXIcADbgYmIg=;
 b=QmlFwvzO2/C/b7iZcehjkmW2cDpTAmVTMZ5izysjtL+XIM7kbQ0schsQg2ev4atLxl5qA7Wj8kCTU8uYQ1BL8miGHq9MVD45t0p87YDN51rBTXYcuxyXtjngnS11tM3ge6OUcqoxTxlvp+TZcZGfHrKX1tJ2983VZTX5FPPvQSIOAsTphfCELNuwIokL/Mms3Xa8DvvrvrANIOuvT9suz8OzLlARh4wSnz1QnMbrMu5iWdL8i8uNcDDiyX+irko76UXnlguwREigN6D51qg2pkv14uaMiiyGEQHyQCAUMGKKAlcaz0p2tJfiuiCkakV5bWrwp5zgcExYz5b6MbxNOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcmcR0YK5LUm5B3XkaaL6727t2drJukhXIcADbgYmIg=;
 b=cKAL//r3x42KPNYlfpwDsCNW1apyFaBw0VAjrXUmzGSpYBJvG42eO87YY6WyhgzWXH7Yzd/+JH/f2/RRXqJkSG3/ixuq67rooJKZxzmQYSchobSVHzjewAMC+GbYTHE/0UmRIQ2socdnd+luPbSLfklAca/vdqpwa/Z/P4N1aoY=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB7683.eurprd08.prod.outlook.com
 (2603:10a6:150:62::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 09:54:54 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9564.016; Tue, 10 Feb 2026
 09:54:53 +0000
Date: Tue, 10 Feb 2026 09:54:49 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 2/7] arm64: cpufeature: add FEAT_LSUI
Message-ID: <aYsAaaQgBaLbDSsW@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
 <aYouAv_EjICIN8oA@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYouAv_EjICIN8oA@arm.com>
X-ClientProxiedBy: LO6P123CA0006.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB7683:EE_|DB1PEPF000509F6:EE_|VI1PR08MB5357:EE_
X-MS-Office365-Filtering-Correlation-Id: dfaac6ad-cf9b-448a-ed6a-08de688a98b6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?QXB+j59v0nFRRLPlNJyKg+iBXUQ3A/PewEdYqt7LR8rrgbNMTVD8LlVSuylF?=
 =?us-ascii?Q?WPQeXCb3I3nEXW7pPgroo4CBgOalxXj8HwaLKoVBu0fnIu0fOLQau/CPd3Zi?=
 =?us-ascii?Q?8+cafjrG6J1DLW2GRuIzWxxBqOq0gzvdg0wWyR8JnIAxFGxrovsNc+wQ633+?=
 =?us-ascii?Q?Kzo9tD7eHsBGH17oUSuUP/wMTDT6HKy7fqFGRX/d1GNpoKLhGZBuZYmRhmcR?=
 =?us-ascii?Q?fEaI6AZRkQ0nBqCbQrzLLu3Og9Dtv4bQ71OA6zeXbqHLRMvJTtKUb/nfPcmh?=
 =?us-ascii?Q?WHrF4isD2alyjCsf4oQ4nE9TPbFFzqGkOKvj+Xo0EmlMnRH8iy1y867rL4BW?=
 =?us-ascii?Q?WfPtwHD9qhVCyCQXnSTaanc1ZWNgmrRQop40ndagMzEjmkjDX7zey7lFcuVU?=
 =?us-ascii?Q?Qhn6/LhuKIpwnqdjq5Y+VDHdgIyBZqEAjPsmkfI5LkeHZATMb9xRy3CiD+PB?=
 =?us-ascii?Q?F0LgbcWRguPdDqcKZjSP+FviQDaFIf74gJ9CPDIv0UROZHirCwuNBeQ0H1YH?=
 =?us-ascii?Q?Bmw6wBqPgkLHTfWYdmyhfGfmcsfzObhxcaOlatyEWB1hWNBHBvM4MjxKTMy/?=
 =?us-ascii?Q?QvrbdWV92yijnjUPmnfsipu/o3yktldyotVY7L+F7S9QOiX+DTh9YptHDOmw?=
 =?us-ascii?Q?V/ebjKftE9aThw9CFlw/4A9jcMuR5yB4rFoZR/VssSmEoIvx7nbwN8KtkkEr?=
 =?us-ascii?Q?dV780gvVdP+0RVdZrKWc9ya12WesC2oWFNX+tGPXCeMCtXJXl+/DfKOYeD6j?=
 =?us-ascii?Q?zrVB6hkZE8b5Qy3ci48oTeg6vNuwskgrvSiOlF1wLZQFIaa2d/y9xeUmk6bR?=
 =?us-ascii?Q?e9tu/NGPQDnoV9K7WpLF9BeOgSUtS7ykSOxs8vIrut48T5dtdAO2AUkcUVe0?=
 =?us-ascii?Q?U7UEs4bTy5L1SkvfW2QtfLYvUEALq0BzjN9Gekkebf4WkqnvCDLm7XIJmjUO?=
 =?us-ascii?Q?tZ7jIv8UwVIr+3paCbDqmRsqF0eAEaghc7r0Jt5vrShJVeH3rRzOh1n6KuAx?=
 =?us-ascii?Q?rN0wY16KOPDCO39cYgZ50bBvdLyJO6m5c0NZbjtBmCEQDFwduM/kwP33+5oi?=
 =?us-ascii?Q?T29BMjvqsPCjuT4ixu7c+9rpcX1TU61sx6THmc2R7N8s035xekV6oHNmCDeY?=
 =?us-ascii?Q?wno8P5A5N/beUSHUs8Go5LIOomDpvAHgtTmxow5f0Ymo1Z6Owf7zL9s8CCbX?=
 =?us-ascii?Q?ZrnNUuGPrEWTbHLKzewFh2S1dMTFsXBaVJI56T/Fa+vqjsJhlOdNqloiR5Y7?=
 =?us-ascii?Q?K0SD8hP1jMqoeQ4QqmTj0CB01O0TCTA7hzB8kLKPfKT+CU44sygpxEYtf7Ae?=
 =?us-ascii?Q?SpYCBuRpv+mXUzo9A+4Cwj7c+BhY/JVgkn42VEzBX9Z2tbf5QgClgN2malsf?=
 =?us-ascii?Q?4cmG8ffpX++ONBE/8x03d3rk7X6v/pZO7hVTtAIzus+LUV79zBqm6TbThQLa?=
 =?us-ascii?Q?lMANPWetRAM/9NbTf51DrHtwtWPL3UL+aQWKY6F1kp4WzdRUnCYtP4oVDtFM?=
 =?us-ascii?Q?hCywTsmLEVloPP478M9/ulXq/y4aRwa0gk1AQKvBCfnc1EZIqjOI/Vt8XnBH?=
 =?us-ascii?Q?ZG5cK1A13DZYWYLXxbo=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7683
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	be8a04fa-eca1-4115-e807-08de688a704e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|7416014|82310400026|1800799024|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0cw7INV+lyaN4zwCgnAXCxRriYG4sG0JBZ/xL2vMBhl7OLJ770NdHThPMChe?=
 =?us-ascii?Q?2qYaLHBnP/Z92R0nkiV716XPNJUavsueoDtMMnpHk/ntUroDdGbpg7U3iNDt?=
 =?us-ascii?Q?qSghZSum2g5dYGNgfoiG8U4NLWwzrnaNcbLXr9d8ADhSiXdWR1ABMQ8Ovdo3?=
 =?us-ascii?Q?o1u0Hl5WXGXq8FIHBOpdiEbzO1Z13i6/MbVhlHEoEVT/zz8EItcCrXDc9Ob9?=
 =?us-ascii?Q?E73Cucl3FrDmAce2RIUQ1WnTPNV2+jyJt2ZRYtoscUslU9YH5+28EGZNy7WJ?=
 =?us-ascii?Q?+KHPfrqCL9bKIjTvrgsDFvtzFPW4M/cQbuV1DR46X2zmNjJepyQ2KEMahA4b?=
 =?us-ascii?Q?+xpn+QpuBEYey/xEsrfcAc5PGybihE7/UOz30yYAtZdQT7WAVooj7sOUb48x?=
 =?us-ascii?Q?z/YDgFODKPKV2FTNm3j+0KwmOUYLU4Td3njDNjggGqreDgGDiuDlheqTGhNP?=
 =?us-ascii?Q?2NwVdhEynAUowZ9UjYUYAacXqa8k9KI35xQmiyIPrBI1bIompnQ3clSFCxib?=
 =?us-ascii?Q?V5PrHSQcyJWgRvfzDG0selSh0+rM+/SRI0Uzgy/qEjCICDlmUR4xC3UfcsxT?=
 =?us-ascii?Q?A6GbBboZGyt5sZvFWZkK8J05QD55jZaSsi3GL9I2+UWnDx0OV1FRq2ZJ1FM5?=
 =?us-ascii?Q?FRObeN68GZ5XtHt5ObuK5hTG9T2STAMoaS/NU2gkOVccewyfZ15YIjZEY7dC?=
 =?us-ascii?Q?rIf1AOv4sPDS2alc5GytQOVg0diCz0XgrbumkDRBgITiJe+zJKgkcVSzbvv/?=
 =?us-ascii?Q?x5pIrpWaSvR5Bcxbk08K4jSm12KVbDid6oHW5M/4pglXPR/h/0KJVLzwm3xN?=
 =?us-ascii?Q?B7phYuXQBBfHqJoTw2y2qrdzfVNfyGqj8t2yWs+ufZ6eX8/mEh7h8kRzJLab?=
 =?us-ascii?Q?yY0oYRqbpF+Y5KqCYs3rTz9gA5wXarBiAZhhBO1wgP7T9ZX01N5a+rzUfrmb?=
 =?us-ascii?Q?MOfCTNfKujRjJQFc4YCxVnN+MN1IQ/ZtdUxRFZyLBsqlsWY1jeqzJUtpaSfc?=
 =?us-ascii?Q?TqL9tl/RytYRfp7AWbPmuMN4w9j6spDZXSHQhcwWhAzNzvMttWZ5+tUIsR5S?=
 =?us-ascii?Q?P/mREdXPuvrX0K6cmSjCDx5j1SdVmO4z4KbG+FP1Ju7BtB0YlIQasgqBaA5I?=
 =?us-ascii?Q?U7kzg5LzPIhf/S+tEbzN+8lD0iS+vCOiqo6ucdoiLAT4G2zWdieZZ8GuS/GR?=
 =?us-ascii?Q?1JOwM4sf1aGJTn6J0Ij2t/WNXoKpEBYV/PcDBE5H7NIGwfSpNQhJ5LnnwHGP?=
 =?us-ascii?Q?JAgUehIRuW1lRvHE4V2Fn9ANs2rZ/GekWTfwQmQNdenHCErJqodzIFIn5A5w?=
 =?us-ascii?Q?DBUHnFITJc1Alzf/tWGaIfdZuu91oQ2VNqNJOWbCF1Z2tQkqm7FLOY3/n9uK?=
 =?us-ascii?Q?cV4iCz2rzfPnAY4kSh5g6Lf18E+lgxZDKZ8LwAynThW7Zw1yX+uGhzGGv8Bf?=
 =?us-ascii?Q?8legrbljMSNwWjKQDubQt/v7tcovw1vWkg+WspUiLBjw+wDOWGVZ65kET6WV?=
 =?us-ascii?Q?RLbTSXcxxSilOANcGWZOWtC6MsxuOTz1v2PVXioYjUFZs+OvdspfPrikhs7E?=
 =?us-ascii?Q?W7CCQRWQyCnHyUw7qsQezwn+Bty+ZvCqDMqFkZsolegIPyz23vODMecyjDtY?=
 =?us-ascii?Q?IsvQldTPvwT054SuujxEN3XuXnvDCeDhgQGLyuDXOqQfS2znTtWb9kffF1rR?=
 =?us-ascii?Q?EvuerA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(7416014)(82310400026)(1800799024)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	611a9Slp1V02zJIoiWWokYWNj+3vlxet6J86XPPcScX7mR7DhPHKQesMEeIENBhStK4cpNFpwClc94gXPTisLmX5GxTL0x93hcjCpqUXRuNgwWGsO0F5r3sMlBf6thvWtbbg7i54K/E17SItQLjTKdibFK6ied6Fvxp1Vr4XEjWJ/mtYIDHWYQnbiVVHNmdOJcGRnLEAbWRfwBSPgDazVojkLYOriksfid6ehvSscGMdvHOkMfIz4hIKw7hDl0mWmAMX86o2RK4wMm1WNtuORnkWEVGLIATeykl13TpEg/MdXU4wEk4fz9LTD11NERJ7wcbAAmoAdqxgtxNLSAJx3SxlJ/Tvne3yQo570a0QCGXCDV1agAjNaUXXz0kKTlHj51mXtByRORDV9D2B1IYjlbaV6YEMtVN6HwKjPc2QpnhBsO8pEhmvnWfpodMyAzTM
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 09:56:00.9108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dfaac6ad-cf9b-448a-ed6a-08de688a98b6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F6.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5357
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70719-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: E03E81193AA
X-Rspamd-Action: no action

Hi Catalin,

> On Fri, Feb 06, 2026 at 06:42:19PM +0000, Catalin Marinas wrote:
> > On Wed, Jan 21, 2026 at 07:06:17PM +0000, Yeoreum Yun wrote:
> > > +#ifdef CONFIG_ARM64_LSUI
> > > +static bool has_lsui(const struct arm64_cpu_capabilities *entry, int scope)
> > > +{
> > > +	if (!has_cpuid_feature(entry, scope))
> > > +		return false;
> > > +
> > > +	/*
> > > +	 * A CPU that supports LSUI should also support FEAT_PAN,
> > > +	 * so that SW_PAN handling is not required.
> > > +	 */
> > > +	if (WARN_ON(!__system_matches_cap(ARM64_HAS_PAN)))
> > > +		return false;
> > > +
> > > +	return true;
> > > +}
> > > +#endif
> >
> > I still find this artificial dependency a bit strange. Maybe one doesn't
> > want any PAN at all (software or hardware) and won't get LSUI either
> > (it's unlikely but possible).
> > We have the uaccess_ttbr0_*() calls already for !LSUI, so maybe
> > structuring the macros in a way that they also take effect with LSUI.
> > For futex, we could add some new functions like uaccess_enable_futex()
> > which wouldn't do anything if LSUI is enabled with hw PAN.
>
> Hmm, I forgot that we removed CONFIG_ARM64_PAN for 7.0, so it makes it
> harder to disable. Give it a try but if the macros too complicated, we
> can live with the additional check in has_lsui().
>
> However, for completeness, we need to check the equivalent of
> !system_uses_ttbr0_pan() but probing early, something like:
>
> 	if (IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
> 	    !__system_matches_cap(ARM64_HAS_PAN)) {
> 		pr_info_once("TTBR0 PAN incompatible with FEAT_LSUI; disabling FEAT_LSUI");
> 		return false;
> 	}
>
> --

TBH, I'm not sure whether it's a artifical dependency or not.
AFAIK, FEAT_PAN is mandatory from Armv8.1 and the FEAT_LSUI seems to
implements based on the present of "FEAT_PAN".

So, for a hardware which doesn't have FEAT_PAN but has FEAT_LSUI
sounds like "wrong" hardware and I'm not sure whether it's right
to enable FEAT_LSUI in this case.

SW_PAN case is the same problem. Since If system uses SW_PAN,
that means this hardware doesn't have a "FEAT_PAN"
So this question seems to ultimately boil down to whether
it is appropriate to allow the use of FEAT_LSUI
even when FEAT_PAN is not supported.

That's why I think the purpose of "has_lsui()" is not for artifical
dependency but to disable for unlike case which have !FEAT_PAN and FEAT_LSUI
and IMHO it's enough to check only check with "ARM64_HAS_PAN" instead of
making a new function like uaccess_enable_futext().

Am I missing something?


Thanks.

--
Sincerely,
Yeoreum Yun

