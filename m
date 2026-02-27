Return-Path: <kvm+bounces-72132-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLZrF+FWoWk+sQQAu9opvQ
	(envelope-from <kvm+bounces-72132-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 09:33:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F9B1B497B
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 09:33:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B2EA9305E9C7
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 08:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D63FB36D500;
	Fri, 27 Feb 2026 08:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WZu/L8l9";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WZu/L8l9"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013010.outbound.protection.outlook.com [40.107.162.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB9F28CF6F;
	Fri, 27 Feb 2026 08:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.10
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772181152; cv=fail; b=DJxdcHfHGd8Ie5A9bWa22ylUKmskax2fY1ESnuoXRzcQdjsdNO+Ps3LDrA0STfZ37BsmMu+/QUrr1uFliF9OE3ag175FjvxC46L4dwIVFK8XrMvwtg/JyR6Q7aK0usVL75J7I8FarqJqbz/dvIKO4AO3uaM76c/Xa1mxwDsAJsc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772181152; c=relaxed/simple;
	bh=njB5N0XVHGESgajCZMuAsR6UE172wIF9v+t1oR79eOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q6y8kECkOLbVZALj3sUNFYDtScWO3ckRIYp3elYFrqQW5wyaHB1QPmxmkV+LbwuFsXvJrRnWY7r9m/PljRX5M6u6C4LlUbx1JLpgQV5U2rpXGgav7wjnFIkSJnn7koaaSMpHW8ZrhWY9379ruH79g8oyh7zkyvFqT/ol63vKMPg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WZu/L8l9; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WZu/L8l9; arc=fail smtp.client-ip=40.107.162.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=IzlQ15/+jHsBlPF3MAJ+d9/g+upzmzSkeFhYDivc2UkAC+nOW79WhQVtPv47tZwsfAk2IgA+jlnKM7fVcoyQ0bD+aeubTtpF97oyoiwRrIHxayemikqLeqd3sFuiZIFdnGVxKprAiguRQz2DKI5uJ2aIQ4aCLHEwjD7WKwqdlAdln89LsrNs24Lfveyts8CdxvvaN0ru/94o6AIjpCWVpUHkGRjcEB4M7L1QKjG7N4iogLCC40N02Pjf2UeCXuKx7xyOA+YoiQRGjJijovDLc3NY1xmj1B1F5iGW8Pd8JQaMnbZMpvGaDrL8qJxMCgfdzeNnYSnUuh8FJhhMdPXjpw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5CPuaHe2jaCOINjCuA/OQQaPYQLgWLUbwNHvtaJQKg=;
 b=yAZenjnarQz5gFZoLDuuEeHv/YSScctzz9FMjEPeJfcMLMHS/+gaeH+/kYJUiN5lLTN7yfgCWnqUTfdaThWc55SlwxSSGkbO4dLWui99MGUaddaYE02IJ4iBM9GRpkomUSwaxi1rMWaEF1FeiKdshDaTuFRZ9B1tTv7Lqr49WM7uOlpXb7J7CT5dAoYCR1cLVgNBajeMdPMvarioSpdofx8kDemHZ1M2TOzpS100Ru37t2LlEto5z/QRkQ4WPHivR+r/mA46a408SRgPdVF0wkYeKk3hHz135MWMvPUMAr9YcF/L2H3/Vju1qrYPuAa1fzEfLWhRo/7RDxpyxEz7EA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5CPuaHe2jaCOINjCuA/OQQaPYQLgWLUbwNHvtaJQKg=;
 b=WZu/L8l924L432fXjXhVM9J9XGBcoHdUwqWqh9QYGS2LiZOTZNn/GT6pKPWJmp1bqjJuyKm6P38/a2rSEWuyhZiI2nzvn5D961s6cd/jbJV8rmdyL2CnvAqpCIu3+6cJ/F+OtTD3s1ii1QfAXvsalojWE5jH6Q77DJk/Gyrybpc=
Received: from DUZPR01CA0350.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b8::22) by AS8PR08MB9953.eurprd08.prod.outlook.com
 (2603:10a6:20b:635::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 08:32:25 +0000
Received: from DU6PEPF0000B620.eurprd02.prod.outlook.com
 (2603:10a6:10:4b8:cafe::a0) by DUZPR01CA0350.outlook.office365.com
 (2603:10a6:10:4b8::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Fri,
 27 Feb 2026 08:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000B620.mail.protection.outlook.com (10.167.8.136) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.16
 via Frontend Transport; Fri, 27 Feb 2026 08:32:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njDgguI7eu/Lbvu80d40QDk+3BqZM4GF6YiwrVX3jZd8VKNP+i2qGxRxGBdDaAse8+kvaV8YbBxe6lneIChw+yaMHW8wedUV40pEEsiF6zz9SyQAo6nvkiEMHPjrhL1Y0EFJMsucpFpOT/O+kmG4BgDDVpvtFke4dBcaTkUy+JleVD4+DTnmKoGeDap+C7mrIoFOYxHkCp7ENaaHQ8C41OSFuPZWKxZ/pZ+8KumpxhQPo2lGjw+6kg2yzLPCBm4KKghAgdsD4B6kqKu6v8IkXSPGtYuZuyVSOrKNyBX4gzECnmVIV9aa07F+jg+IB9zs52mwlXbmhyoEuO9PqeypEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5CPuaHe2jaCOINjCuA/OQQaPYQLgWLUbwNHvtaJQKg=;
 b=pnc1c7Da7ySilTaCwX81bVf7gMSrmW+vSUcF5DlrehrGrJkRgtPHj8m7Rt9aQArQ+UGRVVtXK2Fd5JVncKV2QvOmw3U9deNeU7qITWvU443cdhXgjzj/zrUaoyLoTzpRTiSK6ceZEDeDMog/jKZcJK/qqGVZx/pDuIFcfnFasQy9w76nt9hqAO7bdYd1cvfdbLPPlxTiIcXi7otOUQJq6ECVHlO8f5kgpN6n2s8XjxghPw7jyVTcl/zaUTXKsXZV0eVvfJgakYEiUSrHf7mzHcUB9vfixLkrlFxkfyxNCQuaFY5ruGLFLgLi6dBetcDBimrHkcV5kEktaFg1pj4SWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5CPuaHe2jaCOINjCuA/OQQaPYQLgWLUbwNHvtaJQKg=;
 b=WZu/L8l924L432fXjXhVM9J9XGBcoHdUwqWqh9QYGS2LiZOTZNn/GT6pKPWJmp1bqjJuyKm6P38/a2rSEWuyhZiI2nzvn5D961s6cd/jbJV8rmdyL2CnvAqpCIu3+6cJ/F+OtTD3s1ii1QfAXvsalojWE5jH6Q77DJk/Gyrybpc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DU5PR08MB10677.eurprd08.prod.outlook.com
 (2603:10a6:10:529::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.15; Fri, 27 Feb
 2026 08:31:20 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 08:31:19 +0000
Date: Fri, 27 Feb 2026 08:31:16 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, oupton@kernel.org,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, broonie@kernel.org,
	ardb@kernel.org, lpieralisi@kernel.org, joey.gouly@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aaFWVN8FfmB29csT@e129823.arm.com>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
 <867brzah6g.wl-maz@kernel.org>
 <aaBTM3C2MbIvtUn8@e129823.arm.com>
 <ec3fc327-042a-4672-ab39-88cd1ce41065@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec3fc327-042a-4672-ab39-88cd1ce41065@arm.com>
X-ClientProxiedBy: LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::9) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DU5PR08MB10677:EE_|DU6PEPF0000B620:EE_|AS8PR08MB9953:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a1daf5c-e669-4b72-8b87-08de75dabbf9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 eAPiGqN+deDRnOa78qJNF+yHTPsRoXhzOLqTm295Oyv9MUT/pchJ+1MlU9WVC4cqFoh5esW6mVnBCkBghGBcdfR8pGAwQgkUPJe2gyIMK3J3tnGw07BVxNBpndxPfxMLwcFTRrtMJ0rfL/XRA8lI+4epdxG2SZQs7EHJYRWxWmJ9yW8aJ7YvmGJ2AWu29U8BIsr5ZuB9D8QM/GLEAKsE4V1xU3fglByZoNW8ruwpAHvzmeWYLbfvFnsbE4y4ABrqWvcmoGL4VZkEw7q2uI6RYQq6iGPMnVMVyoGheG5JeomY5o9LEi9SJbntRYgVKH1VL9oc35iwiQlSvmLdE/SaJyWmOUEYl0MROQ/QYiw69jbzIEvfunUrXxL9ZdZ0Atq7x4mVC55Bc+9NnXmBMZb6+meVfY6kZqZ4D6uirwdfP9Ff6vcjwBWsmxIUEBPpx7RLBs9oVIWUNr48NiUCu9qNtNdgEW1K5tHGWWQpaZbAbRVQNK40Wkwn1yYwdrcmVErR3u3v6DUZ5q4HrDL5X7mTYQEMeomL/NYzNjv4v+vk1BWZOw5zRrEkCcYp5TzzbDrbPg8zs4sn+bxk+THtp1U8I+gYkS9+UYd2WXtgiM9NflDTRDaynY4zy/TYDLOyPn3gjH05oU0/KYazXorU97xHTHqF2HEi+aEx6qkGGwCwMsuVWk9Oj+ZCNaMgBh2YVHYp
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 U/cHjW8npBdse34IW3P8DIztdiRgkYOcRr+pFn/3WC4S+dFN/SOHMzAWrFH49/We45oO5vgywDo+ENmbXdqC6/c8D7cC+7XlwYYlwxMTtqAkMNPw/ri+l7btpq9VjpSrM/ZrG8PqB59ZEf4wIFe6wxn1Thz/e0m1UhHDO8IqCfXtakKB+qbr/3+3swpmYjIsZgaoKE5AIT6WrD0sKrYLjJtBy+AGg19/6nPzES2kpDaZ67vNMfgNE7PpdRX5DAnxUgCeqR8S+udAh+p3cEAou//Sx3IlfNm1fqWdsRuhlqOTZVo3DjJUSDtVGJbZY4or+MXZQ99H4yeq4c+uTnF2TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10677
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000B620.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5fc0715f-8c39-4e6e-e164-08de75da94f2
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	U7UwiA9Fq99GK3EwFdgQLU2y1UDmCHvLhkcgbw8EahJZQPXFBMSNLx6cq0o5T2CmKJG3mjeJZmJmWsMQMb5eAKK5ZAeAHRL3EKkD1t1q75GkKA3Bmu3tz4y4zLsYPugraBVvHuZNhGxKBOwXYLAzrLuUxVODxMFyNgw7WL9BgZTHUSG7cE6zpsNvmBAVmA7yQyzksih5kIaKjvdgit+bQpCGiUI2UWYgaqUhm9nhBwv3mSQYxm+dJrMokAqto2rFjm7NKyZdsGnLobTYHR58I4iQADQY2wGba2mfg0bg8XOwbXE90jkryi9nOzdR02SWzkPDE6mQ+71JVAQW6PPWp39TnL+gY4Bj8jgX1Wf70tTEycmxG2rA/EOeGbJ8fveVa1SMYOcZC1uRWnp/7CjtUIEKZRUYnbQHoEWwSV4Y3AluTRKwKG9QXmX4NJBDxnBXRuVNLZ6ME9xlYJAjHJTsife2f1Dnj6gccOMR9jn6mCNh04HGUAr8ZhvRZPUEg0u/WIvPJmi+wDgIfayjHfPO40gfGoWZwo4swA8xRJuXArfOrQDkowf5wtKmoHTkodLF3mbCOZuuusoAi79C2sTeRQ9tC4Zh7J1JrFSingfT/ag9CwQ+EQKwrm6R5PK7sarPxOfe4MI59ipkQQDBtzf4vMWZ7C80+3oMYJHoW+AEGLZDW5BNXDsdAOdEQNhMcKAONJak7XtQHXy9FopgUXQ3MY6OkfLpLdtAJ86Dk/SD3EiIoq4djpDXqvzgNNuWgTkpGzIzqjcWGMmzj09HEgNa/7TP4ZmmEQrHydCyqVGBTMFQWJ+yJvgqqIf0xkt54ISMm009BUmjTH/qUdoSemyUxitL3OnnyzXx561V6hfYLEI=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+du0MfI36yOXULGmjqMcJL1vKylCTwt3jlPzBis0iIr4BsajTmKc6FsevlXJGtI45C6Uu7fz7fMj+vrQXs0zSwyt9d3kYWESe+C/Dj2OvxhYl6VmXBoY5gTAYAhW9JBoSnxAnxZ7fVIB/PLaGnYgRghZE63Cadc73AVckSeh47NV4505u6ZIQIbafq5H3075g8+Cpi3XnaRL/ukvUEpVqwrxT4M/g894okq95E9hY6FUH88Q3nfizo7ou/S8kQrFNTKXvMmXxuN+ahVXhESdGxby9Hg9501ai6UeLKnCM4vFqCqjEOhcc0jegghdvnk1/bRhYkcolqmoHPp8UQ6c8j4/MroaO3S1d36z+AbSpYyT0IY98Wb2s+bYjlxj3l7ssPtZTeHkDdF9AWkcghj2WT8ajfFVZ6E5R8kUDqHhBwzsmitzhQTAf7skJgixNpw1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 08:32:24.9097
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1daf5c-e669-4b72-8b87-08de75dabbf9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000B620.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9953
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72132-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: B1F9B1B497B
X-Rspamd-Action: no action

> On 26/02/2026 14:05, Yeoreum Yun wrote:
> > Hi Marc,
> >
> > > On Wed, 25 Feb 2026 18:27:07 +0000,
> > > Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > >
> > > > Use the CASLT instruction to swap the guest descriptor when FEAT_LSUI
> > > > is enabled, avoiding the need to clear the PAN bit.
> > > >
> > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > ---
> > > >   arch/arm64/include/asm/cpucaps.h |  2 ++
> > > >   arch/arm64/include/asm/futex.h   | 17 +----------------
> > > >   arch/arm64/include/asm/lsui.h    | 27 +++++++++++++++++++++++++++
> > > >   arch/arm64/kvm/at.c              | 30 +++++++++++++++++++++++++++++-
> > > >   4 files changed, 59 insertions(+), 17 deletions(-)
> > > >   create mode 100644 arch/arm64/include/asm/lsui.h
> > > >
> > > > diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> > > > index 177c691914f8..6e3da333442e 100644
> > > > --- a/arch/arm64/include/asm/cpucaps.h
> > > > +++ b/arch/arm64/include/asm/cpucaps.h
> > > > @@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
> > > >   		return true;
> > > >   	case ARM64_HAS_PMUV3:
> > > >   		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
> > > > +	case ARM64_HAS_LSUI:
> > > > +		return IS_ENABLED(CONFIG_ARM64_LSUI);
> > > >   	}
> > > >
> > > >   	return true;
> > >
> > > It would make more sense to move this hunk to the first patch, where
> > > you deal with features and capabilities, instead of having this in a
> > > random KVM-specific patch.
> >
> > Okay. But as Suzuki mention, I think it seems to be redundant.
> > I'll remove it.
> >
>
> No, this is required and Marc is right. This hunk should be part of the
> original patch that adds the cap. What I am saying is that you don't
> need to explicitly call the cpucap_is_poissible() down, but it is
> implicitly called by cpus_have_final_cap().

Ah. my bad eyes, I miss alternative_has_cap_unlikely() calls
cpucap_is_poissible().

Thanks to point out this!


>
>
>
> > >
> > > > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > > > index b579e9d0964d..6779c4ad927f 100644
> > > > --- a/arch/arm64/include/asm/futex.h
> > > > +++ b/arch/arm64/include/asm/futex.h
> > > > @@ -7,11 +7,9 @@
> > > >
> > > >   #include <linux/futex.h>
> > > >   #include <linux/uaccess.h>
> > > > -#include <linux/stringify.h>
> > > >
> > > > -#include <asm/alternative.h>
> > > > -#include <asm/alternative-macros.h>
> > > >   #include <asm/errno.h>
> > > > +#include <asm/lsui.h>
> > > >
> > > >   #define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > > >
> > > > @@ -91,8 +89,6 @@ __llsc_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > > >
> > > >   #ifdef CONFIG_ARM64_LSUI
> > > >
> > > > -#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > > > -
> > > >   #define LSUI_FUTEX_ATOMIC_OP(op, asm_op)				\
> > > >   static __always_inline int						\
> > > >   __lsui_futex_atomic_##op(int oparg, u32 __user *uaddr, int *oval)	\
> > > > @@ -235,17 +231,6 @@ __lsui_futex_cmpxchg(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > > >   {
> > > >   	return __lsui_cmpxchg32(uaddr, oldval, newval, oval);
> > > >   }
> > > > -
> > > > -#define __lsui_llsc_body(op, ...)					\
> > > > -({									\
> > > > -	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> > > > -		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > > > -})
> > > > -
> > > > -#else	/* CONFIG_ARM64_LSUI */
> > > > -
> > > > -#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > > > -
> > > >   #endif	/* CONFIG_ARM64_LSUI */
> > > >
> > > >
> > > > diff --git a/arch/arm64/include/asm/lsui.h b/arch/arm64/include/asm/lsui.h
> > > > new file mode 100644
> > > > index 000000000000..8f0d81953eb6
> > > > --- /dev/null
> > > > +++ b/arch/arm64/include/asm/lsui.h
> > > > @@ -0,0 +1,27 @@
> > > > +/* SPDX-License-Identifier: GPL-2.0 */
> > > > +#ifndef __ASM_LSUI_H
> > > > +#define __ASM_LSUI_H
> > > > +
> > > > +#include <linux/compiler_types.h>
> > > > +#include <linux/stringify.h>
> > > > +#include <asm/alternative.h>
> > > > +#include <asm/alternative-macros.h>
> > > > +#include <asm/cpucaps.h>
> > > > +
> > > > +#define __LSUI_PREAMBLE	".arch_extension lsui\n"
> > > > +
> > > > +#ifdef CONFIG_ARM64_LSUI
> > > > +
> > > > +#define __lsui_llsc_body(op, ...)					\
> > > > +({									\
> > > > +	alternative_has_cap_unlikely(ARM64_HAS_LSUI) ?			\
> > > > +		__lsui_##op(__VA_ARGS__) : __llsc_##op(__VA_ARGS__);	\
> > > > +})
> > > > +
> > > > +#else	/* CONFIG_ARM64_LSUI */
> > > > +
> > > > +#define __lsui_llsc_body(op, ...)	__llsc_##op(__VA_ARGS__)
> > > > +
> > > > +#endif	/* CONFIG_ARM64_LSUI */
> > > > +
> > > > +#endif	/* __ASM_LSUI_H */
> > >
> > > Similarly, fold this into the patch that introduces FEAT_LSUI support
> > > for futexes (#5) so that the code is in its final position from the
> > > beginning. This will avoid churn that makes the patches pointlessly
> > > hard to follow, since this change is unrelated to KVM.
> >
> > Okay. I'll fold it into #5.
> >
> > >
> > > > diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
> > > > index 885bd5bb2f41..fd3c5749e853 100644
> > > > --- a/arch/arm64/kvm/at.c
> > > > +++ b/arch/arm64/kvm/at.c
> > > > @@ -9,6 +9,7 @@
> > > >   #include <asm/esr.h>
> > > >   #include <asm/kvm_hyp.h>
> > > >   #include <asm/kvm_mmu.h>
> > > > +#include <asm/lsui.h>
> > > >
> > > >   static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool s1ptw)
> > > >   {
> > > > @@ -1704,6 +1705,31 @@ int __kvm_find_s1_desc_level(struct kvm_vcpu *vcpu, u64 va, u64 ipa, int *level)
> > > >   	}
> > > >   }
> > > >
> > > > +static int __lsui_swap_desc(u64 __user *ptep, u64 old, u64 new)
> > > > +{
> > > > +	u64 tmp = old;
> > > > +	int ret = 0;
> > > > +
> > > > +	uaccess_ttbr0_enable();
> > >
> > > Why do we need this? If FEAT_LSUI is present, than FEAT_PAN is also
> > > present. And since PAN support not a compilation option anymore, we
> > > should be able to rely on PAN being enabled.
> > >
> > > Or am I missing something? If so, please document why we require it.
> >
> > That was my origin thought but there was relevant discussion about this:
> >    - https://lore.kernel.org/all/aW5dzb0ldp8u8Rdm@willie-the-truck/
> >    - https://lore.kernel.org/all/aYtZfpWjRJ1r23nw@arm.com/
> >
> > In summary, I couldn't make that assumption --
> > PAN always presents when LSUI presents for :
> >
> >     - CPU bugs happen all the time
> >     - Virtualisation and idreg overrides mean illegal feature combinations
> >      can show up
> >
> > So, uaccess_ttbr0_enable() is for when SW_PAN is enabled.
> >
> > I'll make a comment for this.
> >
> > [...]
> >
> > Thanks!
> >
> > --
> > Sincerely,
> > Yeoreum Yun
>

--
Sincerely,
Yeoreum Yun

