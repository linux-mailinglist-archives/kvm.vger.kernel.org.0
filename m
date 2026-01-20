Return-Path: <kvm+bounces-68635-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADG9L+3Mb2mgMQAAu9opvQ
	(envelope-from <kvm+bounces-68635-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:43:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8134449B4A
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 19:43:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 611D044E278
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 18:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D744F2D9798;
	Tue, 20 Jan 2026 18:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Aav1Wq7c";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Aav1Wq7c"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011014.outbound.protection.outlook.com [40.107.130.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEDF936213B;
	Tue, 20 Jan 2026 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768932059; cv=fail; b=VFxpLt5sAkezChuOPvmNXyvg9s8C+YstX8TfGBjQCOOMrn65SSF5SDFYUjkVo/m/nUQ/deX6aPlcxGKVSLbQgIIe3LovlxLj+C9Nl51CQakzDHaJqJjZ3L5S18vRHZAjeTdOgt3uSCATLlLuKyDvOk2Qo6XwQCQCx6qL7MOJyCk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768932059; c=relaxed/simple;
	bh=YNuWqjQxSzFDOp06spFohPFnBWrwikXnmruZXPwjzRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EEutXz12DH6hb4Z4IItE4iYUwwLk0JzD3o2KMJOcsd6y43ZQQBsDL9XtgaeQcxNx9u0/sLvf2BmXZQFjUMLeXKo/Vxx3Ihe5CUr4cHkwAI1kAuqWdRNW4Ip3tvt2/OY2OmcAIB+CV1LKAkM5jo5Q5rYcfoDX5EQjzmfYm55QpRI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Aav1Wq7c; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Aav1Wq7c; arc=fail smtp.client-ip=40.107.130.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Z0n2i7S94gfCRzh9zBXEgiB9ika77gvMDMIF0mtA/ZAiWi8d1h/5g0usuGgjpm83wj4ZoZ5LFic+jai8pkoLZbBCMfcyPsLCDoXsAdsfUgNjah+uirfA78m3uligRxbpFwactu5ZwjmovSBKKFmGSEsiN5eZiviTQOhoehdbTa8s3Pv6dc4Uaqy4YCF016EQmPQR47DO8ou3NJaO2hOQoblSoxvFi0taRRdvrfpXgvQ0766jiqvY9NadZ7MeSgaAvK1/D+UjVYi965QJXhhTymq3mvrmz5QPlOKjDhLR1PlmZbEArUXsmws/aVaxRXNlEyg9SYK4fMuquY1FdLQDBQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TpFgnWSCJaNySnxTSQPb9RzYkEc5LDj7PF0vFgP4gE=;
 b=nLLB7j5p0bl14H/4695CBPdKCXpx/xCNz/zAu8ave8FaYPtJaIhiZt/8PW5KH7jRZIrciEaPibEDctlp3N5KJ1KBrY3tdkjgUOhmd6Fqjl7AX7Gd5fp0Tr/HmcZfUpIhckjEWMmom3oCZaTyHEJN5pypTMJGrEnMOMBtWK7KooCBh7kNAdAigPna5U86x+DALVskIBBaRAgZup3Q8U6QGeMQlt/f/TnuNSf0mt3esKYOFv3ICYA0aSfn3Tb5iJaBGJl0DJd4l6TEFMt/07Ae0r6LEFFpVmWezV/ELJpP2yu/UO61Hx13bCJISc2RZ4ns+o1D+IpwVyiPKuJdp7vNpQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TpFgnWSCJaNySnxTSQPb9RzYkEc5LDj7PF0vFgP4gE=;
 b=Aav1Wq7c08td3UgTHEH60aOD5RQ1twwQJ5bkH/Xig5DBeKtU7P2FRR+MGVqsrRPB1iISCxdJcNARaJ963tHW8abOC/fHjYIrUF9KUY4BJeXzQj4LEU9he/nhAwML1C5kcohZ3hQ7nlNZkjN2uW/8u+N0jR2CUQXNOpxn23O0z+8=
Received: from DU2PR04CA0346.eurprd04.prod.outlook.com (2603:10a6:10:2b4::33)
 by PR3PR08MB5643.eurprd08.prod.outlook.com (2603:10a6:102:84::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 18:00:53 +0000
Received: from DU2PEPF0001E9C5.eurprd03.prod.outlook.com
 (2603:10a6:10:2b4:cafe::2b) by DU2PR04CA0346.outlook.office365.com
 (2603:10a6:10:2b4::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.12 via Frontend Transport; Tue,
 20 Jan 2026 18:00:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C5.mail.protection.outlook.com (10.167.8.74) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4 via
 Frontend Transport; Tue, 20 Jan 2026 18:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPlYnMt55hEz9DjAYHhjMVsBcmhQNQekYPN8LPO5FRBMNzAZjbpjUzWr3ziRM89DglorKwwIKwSOA+IsXcHwpp0NkrFjpfS5lCJzuSpY3/bPVCdkkxQAS0vF9aIs/xAssP283/1W60mCxDLHaOJphxhDRyRnXGlPaxqMv/otXTRTeMsPjRconAjzlAYIQDq78q/lNAa2QeirX5qS0imv0vkevJBbz2712OgOO1uRFzc4kbFlp75bsnEvL7KhMU3J+jYFu21K7rBmTtAsJei9I6wcbshrxff2Goe2JKj2pMl55R6Q6zJrnm4FYfv+Tg37raAufQD1VU4VCUYE7emAxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TpFgnWSCJaNySnxTSQPb9RzYkEc5LDj7PF0vFgP4gE=;
 b=KT88QAjx5E+X/1iwHK0sMBvBgRvBJR+nvTYoD+6mQTs0hL5HZ/Qv4UPIcBOoDLvzkB+DH1J6uQQHgzwVKyNcg3hqKl/PpYb2DRH/fA8mA+uyYPN8MIia0Fkc1Csh/GBVAnVK4gQp2kR8g8QFCx6inyeHr/0ndlN76+DszYC5/ZmYqkX17dKcU4UBXFRKXQ3e1oyEiW61OTprmLrFu5lEh7WYAEb68Lx2bDQiytW8LVVyi9HYxKtkOLnFYsl18Hf+SUIlgIZP+EHR7URB3SCZRPTeFIaENf+BYqIS5IGEIQEHbAxlWMJ4SpDXDdsAT8lCFdQU33QCbKGzzrmWqAZ6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3TpFgnWSCJaNySnxTSQPb9RzYkEc5LDj7PF0vFgP4gE=;
 b=Aav1Wq7c08td3UgTHEH60aOD5RQ1twwQJ5bkH/Xig5DBeKtU7P2FRR+MGVqsrRPB1iISCxdJcNARaJ963tHW8abOC/fHjYIrUF9KUY4BJeXzQj4LEU9he/nhAwML1C5kcohZ3hQ7nlNZkjN2uW/8u+N0jR2CUQXNOpxn23O0z+8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM9PR08MB6097.eurprd08.prod.outlook.com
 (2603:10a6:20b:280::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 17:59:51 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 17:59:50 +0000
Date: Tue, 20 Jan 2026 17:59:47 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	catalin.marinas@arm.com, broonie@kernel.org, oliver.upton@linux.dev,
	miko.lenczewski@arm.com, kevin.brodsky@arm.com, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org,
	yangyicong@hisilicon.com, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, arnd@arndb.de,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 RESEND 9/9] arm64: armv8_deprecated: apply FEAT_LSUI
 for swpX emulation.
Message-ID: <aW/Ck3M3Xg02DpQX@e129823.arm.com>
References: <20251214112248.901769-1-yeoreum.yun@arm.com>
 <20251214112248.901769-10-yeoreum.yun@arm.com>
 <86ms3knl6s.wl-maz@kernel.org>
 <aT/bNLQyKcrAZ6Fb@e129823.arm.com>
 <aW5O714hfl7DCl04@willie-the-truck>
 <aW6w6+B21NbUuszA@e129823.arm.com>
 <aW9O6R7v-ybhrm66@J2N7QTR9R3>
 <aW9T5b+Y2b2JOZHk@e129823.arm.com>
 <aW9sBkUVnpAkPkxN@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aW9sBkUVnpAkPkxN@willie-the-truck>
X-ClientProxiedBy: LO4P123CA0368.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM9PR08MB6097:EE_|DU2PEPF0001E9C5:EE_|PR3PR08MB5643:EE_
X-MS-Office365-Filtering-Correlation-Id: 052014af-1f8d-4b7a-3003-08de584dda65
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?sl/zSVH1kIbyd2faSFWxjTVFVrWuifMFy4Gd4mzjucZrbmXOBGC+4pg0aFM7?=
 =?us-ascii?Q?sr0Wsvh2tLVRK4Nxg5n571Og6C3m22IcZajIHMUil4Fh0aLQ1fuFeVV9kVkR?=
 =?us-ascii?Q?vzI+OUvQMtDYIN0NwTnT4rFaT7MUJwgvtx4r2HYDgB1dEIaQhQepbXRNSvC7?=
 =?us-ascii?Q?uy6lJJUNbpQfqQkynvOyAZAKt7Mp0fFjCsdC4ieOjzjWGxCpTnJ2ElS+v0ow?=
 =?us-ascii?Q?qegzBACJivHDBOyFkanJyf7ZgmIxUQIQHDidId8EwVwN67L3MQcVCFPnhuVX?=
 =?us-ascii?Q?Pmd+e/SHzHAZoIqPxZMgpgfFg4ZNQw80bqRTcrh8t9K6vxSdDTe9tuJx5/0X?=
 =?us-ascii?Q?qcf/tG+EWAAeS9q6CnT6Nu/lwE6YhgQvHwn3ktd507+y3V8CrBsAcK4JeE12?=
 =?us-ascii?Q?A0tNjYKbiS4/7blijW6VuwHew/YL06NRvRQ3uyt5Mq02YNyG/LoOjcpo8Ge5?=
 =?us-ascii?Q?NM54Nvb5oJwIkH1AQYj0X0RZwLy67IabZYPuPsVQk6ZxdKmXldhz95/abTAd?=
 =?us-ascii?Q?3s5dV9d/ymsaanRxueLUUzkm5MwaRDv8JUD4FVpmQpDpHxyneP0pojeoISyx?=
 =?us-ascii?Q?ux2FovQDHS7KxgJxFcjWpNeY9baYpLiu/WLEgxg1yVbDe17pTwYX+VJuETkX?=
 =?us-ascii?Q?mIASJb/jwuzLjghKsOVgfyIImGy9+mPlrFUxANeYHr1UnxVs0h8p1e/H5cYT?=
 =?us-ascii?Q?jjFtJbk6ls5hQ9kQNBi5rFgp89r885j7uMsbEPvocvT5BJpJUKkGodIk02qP?=
 =?us-ascii?Q?Bcx8NDpWzVOLbyv7vvtPSBy/OixqR4BgWNZ+EKfw6tnsldruUeP4cDnqEq9N?=
 =?us-ascii?Q?WNaI+uWxQUAF1ypubNRm2vFhV3NSO+MR2RXeyZujh4PWdSpH1YoJOlUyYgNG?=
 =?us-ascii?Q?uMrdTdZqxJZKVdNaj0sXjh1ZxPAzAzaoWM8Ng1/f+42hzJ5KWu3tEyuOKgH6?=
 =?us-ascii?Q?hRE/noSCWaFV3PobbkBQmkMSg7C4gRJGXXDnGH9r2dSC/3V2IZ4MszMPcKXa?=
 =?us-ascii?Q?s/QiFStmK7Ybeyn3ETk2buxRguAMqWbMAlthg2jR111FOeRrez90gMe8uyzw?=
 =?us-ascii?Q?VlIxg8IfxkYWOwuQzuAZ7iVJwt+T4oiIMe474W36KAQ9i9tGknDLePZ7l/aJ?=
 =?us-ascii?Q?HIXb2LmGOgqnZn4kwK1UaMD8imaj1okpDIX42avP2V6EGgL29hXPA0oIjrqE?=
 =?us-ascii?Q?6EzKAeiXVeKroEbPe6dbwXvtgGJmiCVHDHqfFVjDkwH2xijjR6UTKDNfd+M8?=
 =?us-ascii?Q?SkIDD8gT93LLxps8S1w3EIBu6/lB+26K4A5tWAd+rk98w7Kj5L0JEdWWcKO6?=
 =?us-ascii?Q?PgPkcC32hkAAHYBfP6Hf2LFHa/8qvnpiQlsk1d2u7i11e805j+SwbJOwOaAo?=
 =?us-ascii?Q?fBF0Ki28WnBWrHKkX7Dg3+ftUVDFZ20ndsrwj27GbfQ3ML/0VOpmfXskGvpn?=
 =?us-ascii?Q?p/KgzU8NQIqbPHojkrJgMdTM4NK6H4zganD/85uGh29wJOcMO4g/y/6VGin9?=
 =?us-ascii?Q?15lKQbVAvuXMHsApv1jnEM97sLe7JU6P1ai088zHZXuUig2QpkE8iUg7WObA?=
 =?us-ascii?Q?yb2ZODrA495AaKL7D+s=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6097
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF0001E9C5.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	3b172354-3c03-4230-1cea-08de584db511
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|376014|7416014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ahtdhs64qyO6EQ7HiZ7BzliUm9IcK9TFVUr/YZYZh+DjDDXY+12CDAH1nL4+?=
 =?us-ascii?Q?QpJUIk3KcrQWjDUFSZ9dOqjybRVqKx0RRG0/JVvj4+q1hfQuk+N9kkO7PuLg?=
 =?us-ascii?Q?Z4h/4eu5vlEWcYmmn+/YQfd+RqPsEXtsvdiTFOjkj8y/Xz369mvF+yRUwJDs?=
 =?us-ascii?Q?SsSrDG0ITnxlKGUjQltbDuwDHJggAsRtkvJV3SU+4t2S2fWKRmU5lEx3syb+?=
 =?us-ascii?Q?9VdInFF9wTk8ymMB8+ys9pcp4JJdp9+UfV78iBBR8A+fGdzWUvIOQ5laP9aS?=
 =?us-ascii?Q?k9uLXc07Qo8eCH0mySsgzA8DVyhWen2Ow3z6ihgWjhZ9rTZrg/Twoz6mZuyE?=
 =?us-ascii?Q?uA5Ervqr29WHvkRVyp20AvmEdmUzO0dH9zXe1QGb7qfb+NYv8tGKaVQzP4cd?=
 =?us-ascii?Q?29IFcnRRQfdRMzMhbMTklDFpVyX6I764WpO/hOZaC922ckGqKUoh8JRW2Fsj?=
 =?us-ascii?Q?Bsi3VrpnrPf51bVtBmakYbAAOfOxJJpxn45lNL8SDYOYANQGxYUzViXNb45C?=
 =?us-ascii?Q?//mSK0zy14Hj2AJ1cqZUBVm0EaxFzstqOWvnGKmrxqUUNSDstxs6MOCxmTwu?=
 =?us-ascii?Q?eIo4P+9hWrEt/pjlgt9+sqSLRxU8aBCJdn2/95SGApE3Qtkp6NNUGFdTCvPU?=
 =?us-ascii?Q?m+dYRRU5mYcHbU5JrfprGDioEMiToTXE8+TZq/U0gCzmzCxFMVwY+RTjs9aI?=
 =?us-ascii?Q?K4sMdrHMYpA4SHnyoBV6t4VnnjlQVPKb9cD6J2TsM/sWD8SqRxYXU3LW16Tr?=
 =?us-ascii?Q?etjyTy+ojNpe8ZXvY9FdosixhZaLGTZaJzPtE8pP8RnIpVu6KL5/zALj/nOC?=
 =?us-ascii?Q?ZB300cYR/MWGh3BfxMLfMg+T0PyKduObXsd43FF6QZ8j8PPQ0pWGhPAEfd2T?=
 =?us-ascii?Q?TepVmeVNr/duUGGHmKGG3LJJeDHa/YT7EQ6WXBtht/zYeBdv2HVC7PIM+bG0?=
 =?us-ascii?Q?iUtcsy3MHIoVA/zBRT2CfTFJ8xzxz8W08QjxsAXpf459jfZULYHyQ9TW+S9m?=
 =?us-ascii?Q?DtGn8SohwIql4gsYDiIk17CbzXcomuvzdGw7Zrk08jf4r0iGbleCdy+ip3tm?=
 =?us-ascii?Q?PbJXCh+4PXlKaWC/74TmIEiV+AkEPewzT8fwd1ML2U2AnHkXlYVLnPB3UO7x?=
 =?us-ascii?Q?8tt0K9Mxjxqradvhbb5aDjEbDCJFw88+0Vy1w37zhMkOm76hxhkhZv+KwosK?=
 =?us-ascii?Q?b3h9qVwUltPk1jK0KvS6CBSUQbpk3zmEHZpL/uLBlwEsjtmVI1D6RNUM//KY?=
 =?us-ascii?Q?5o/xoeEOREXxOsK4OJJgTFGWePMCq/2LRZldGbCifp30tOoioQwhPigzP7fq?=
 =?us-ascii?Q?ujTShfnqQWhAvS2rKo8VcmR0iCNuswL32T+g9ufTq6oiRRvxouQ83vGHq0Oa?=
 =?us-ascii?Q?hCD5swEPqouKEA9BqrylmqnqX467as/abhfm7A0771/J/C90gRb4ePDiK4RD?=
 =?us-ascii?Q?3IKiUf6v1abjEWfWGzt+WR+2QtNnxhUOnP/0Cz1ARy6cs1ZQ3WfFWHrQ1+Z6?=
 =?us-ascii?Q?Ao8kS9qenyG5pSEg43yqah73bsoCblBZ80tonby04HAP9C+smzlrSbV+TxNy?=
 =?us-ascii?Q?XJ349tyXmILmZGVj80Jmge7tIvqatfuUgqO+BqrW/w02edSFW+7S8mlgXhhi?=
 =?us-ascii?Q?xFaMuIXCdXn9wF2AwZEJezZN/vu1/vMdSaUwc+OuKIF1v/yz5OjkpBIe9tUs?=
 =?us-ascii?Q?wI8/qw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(376014)(7416014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 18:00:53.1996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 052014af-1f8d-4b7a-3003-08de584dda65
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C5.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5643
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DMARC_POLICY_ALLOW(0.00)[arm.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68635-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[e129823.arm.com:mid,arm.com:email,arm.com:dkim,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 8134449B4A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

> On Tue, Jan 20, 2026 at 10:07:33AM +0000, Yeoreum Yun wrote:
> > Hi Mark,
> >
> > > On Mon, Jan 19, 2026 at 10:32:11PM +0000, Yeoreum Yun wrote:
> > > > > On Mon, Dec 15, 2025 at 09:56:04AM +0000, Yeoreum Yun wrote:
> > > > > > > On Sun, 14 Dec 2025 11:22:48 +0000,
> > > > > > > Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> > > > > > > >
> > > > > > > > Apply the FEAT_LSUI instruction to emulate the deprecated swpX
> > > > > > > > instruction, so that toggling of the PSTATE.PAN bit can be removed when
> > > > > > > > LSUI-related instructions are used.
> > > > > > > >
> > > > > > > > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > > > > > >
> > > > > > > It really begs the question: what are the odds of ever seeing a CPU
> > > > > > > that implements both LSUI and AArch32?
> > > > > > >
> > > > > > > This seems extremely unlikely to me.
> > > > > >
> > > > > > Well, I'm not sure how many CPU will have
> > > > > > both ID_AA64PFR0_EL1.EL0 bit as 0b0010 and FEAT_LSUI
> > > > > > (except FVP currently) -- at least the CPU what I saw,
> > > > > > most of them set ID_AA64PFR0_EL1.EL0 as 0b0010.
> > > > >
> > > > > Just to make sure I understand you, you're saying that you have seen
> > > > > a real CPU that implements both 32-bit EL0 *and* FEAT_LSUI?
> > > > >
> > > > > > If you this seems useless, I don't have any strong comments
> > > > > > whether drop patches related to deprecated swp instruction parts
> > > > > > (patch 8-9 only) or not.
> > > > > > (But, I hope to pass this decision to maintaining perspective...)
> > > > >
> > > > > I think it depends on whether or not the hardware exists. Marc thinks
> > > > > that it's extremely unlikely whereas you appear to have seen some (but
> > > > > please confirm).
> > > >
> > > > What I meant was not a 32-bit CPU with LSUI, but a CPU that supports
> > > > 32-bit EL0 compatibility (i.e. ID_AA64PFR0_EL1.EL0 = 0b0010).
> > > > My point was that if CPUs implementing LSUI do appear, most of them will likely
> > > > continue to support the existing 32-bit EL0 compatibility that
> > > > the majority of current CPUs already have.
> > >
> > > That doesn't really answer Will's question. Will asked:
> > >
> > >   Just to make sure I understand you, you're saying that you have seen a
> > >   real CPU that implements both 32-bit EL0 *and* FEAT_LSUI?
> > >
> > > IIUC you have NOT seen any specific real CPU that supports this, and you
> > > have been testing on an FVP AEM model (which can be configured to
> > > support this combination of features). Can you please confirm?
> > >
> > > I don't beleive it's likely that we'll see hardware that supports
> > > both FEAT_LSUI and AArch32 (at EL0).
> >
> > Yes. I've tested in FVP model. and the latest of my reply said
> > I confirmed that Marc's and your view was right.
>
> It's probably still worth adding something to the cpufeature stuff to
> WARN() if we spot both LSUI and support for AArch32.
>

On second thought, while a CPU that implements LSUI is unlikely to
support AArch32 compatibility,
I don't think LSUI requires the absence of AArch32.
These two are independent features (and in fact our FVP reports/supports both).

Given that, I'm not sure a WARN is really necessary.
Would it be sufficient to just drop the patch for swpX instead?

Thanks!

--
Sincerely,
Yeoreum Yun

