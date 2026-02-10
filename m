Return-Path: <kvm+bounces-70720-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aO8+HhsCi2npPAAAu9opvQ
	(envelope-from <kvm+bounces-70720-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:02:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BAD311950D
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 11:02:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 353443070DF9
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 09:57:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55F6A342C8E;
	Tue, 10 Feb 2026 09:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eih5sxwC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eih5sxwC"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010025.outbound.protection.outlook.com [52.101.69.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAC734253B;
	Tue, 10 Feb 2026 09:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.25
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770717442; cv=fail; b=aZnzeEhKMMnLG2OZAxvasuK7JwYMpvdY65CiAwSit/hPlxgX+wez14z3LWdDvaAc7K9ZzllXMYnNbciKIXna3Qzq17Eq/dilqa5xTFpVcSO6J9XcaW0gkfalHUNim8oe7oBfhoLVzJLmGQwir4+eQM4G9iLXn7K5r2KxWVByri4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770717442; c=relaxed/simple;
	bh=9NEejRHxqCLBrNoj1D4M5NQo7fPyPjhxIWPoPqBVpWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nRUVtyJjDAcPY2iToLfYEREKQWMzXTpDWzFGuadDa46PVk3P7eNIAeLksdyfk1ohbXsDu6UOn/O+k7+ubRFTOvLbNiaSUWkXqW78q2WfbwtQprZzpZ38bcCrYKbX06Vi9N5ju3G6KgAOEF9gWMx3nfOXnG4sXNvPLE60vShA1b4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eih5sxwC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eih5sxwC; arc=fail smtp.client-ip=52.101.69.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=N5jJzGSB2MDZOJR4l8Ryn/H4ucURVf2Uj2TW/jyokLF69j1vr1YwNr8VTLeeEVPOt+Zou4CmPjNZ1yLzHMeosWErkxvTMJSOIp1j6uSpfc6GacRbQrKBpvkvjgiVUMF9UFTOTWGGXtNlAxYtMcSspF1gg7RTb08g3GhdJELZYa65P2Mh1vS19lbW8FjTl6aJRRTW7ps2B4U6dlR1dD2RlwJRQU/DIVff2K+0hLp3m/0uctm10hoUtZx5xrDC1I0cYXpJIeSmFZ931iT0xa+boeXPZUGekv87zD4qKQ8fm5i8TOaOm2yJMxhGkPoujoPxWgxVJjDwZG9pLwLqR1BLjw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NEejRHxqCLBrNoj1D4M5NQo7fPyPjhxIWPoPqBVpWo=;
 b=YvhAc7MhdR5PFPEg9i5kv9Spnzh1oP2lkU9fL2Qq8v5KeSOW9j1RAJ7Lrme/5zIEAF/2ZlHUSNous2XH54qFzJcSykzdI8UQuyUv6VCQecTNyHhvGOPgUS6i6U4g2iEl5ifvvL/IFyglD0Sltoxh2CvE7jgSjtVYUEGktgdlOXdFIWN570M2xFYv+me/AWaESL6tKzrKvFnloq0T7MRjD7qNWkW5l1P62UiTfHFglOShjX9rm0elVoXnyYl3gLvQ2xNk+c9lnghcvfYfXNnMGWnYAnOIHsSHw1e1ri2nz0ysxnRe8NDBkL7BTgbIuyAaCB2sS4QHNDQej+LnRZc8TA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NEejRHxqCLBrNoj1D4M5NQo7fPyPjhxIWPoPqBVpWo=;
 b=eih5sxwC+Ssk4IzTieebjtvdpcMfC2sMvgqu2J/JFtWyaJhlYv0IUnzyohI2OSu4wHg58Qwcz5AiAsCUGGWUhMQ2CuFKc9jnMAHiSHWUtwzHkiHAoaC/forL8VDuxMI3DkbribHNkRY9Jb3hlgXlKwwhuhKbiuAr4HgWVHmEtCk=
Received: from DB8PR06CA0063.eurprd06.prod.outlook.com (2603:10a6:10:120::37)
 by AM9PR08MB6147.eurprd08.prod.outlook.com (2603:10a6:20b:2da::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.8; Tue, 10 Feb
 2026 09:57:16 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:120:cafe::e0) by DB8PR06CA0063.outlook.office365.com
 (2603:10a6:10:120::37) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Tue,
 10 Feb 2026 09:57:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Tue, 10 Feb 2026 09:57:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DzacTNOvKfMWXtbWNldyJp0xXhCix57OVYuHIbF11pcaYlgXtBGHcJCnmhxGOv3ModsskquEMN4Z+s/83K/KAwwmuE3fe45KrS5uNmGP9N9Y5MfhG/cKizb9jvCs52IARySeokrCGUhRm9hvyJhDes3kcKkcFqyzA5OzAKz8yyS+Il3dmzDxaBfT7zvBzstq6yGVzAyUgoLRFz8gQplJrU6WxyIEv/Fix6a7TbRLtA1faWdxOX2/qDi6WxQIkeOrau7H5XFIXe9thLow3X9FA4XRKnYDbOkJ/Sw7O3vTCEuzALC71QMjQOycnd9JXeIgGxK0s65/t2LRV4wsTqMj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9NEejRHxqCLBrNoj1D4M5NQo7fPyPjhxIWPoPqBVpWo=;
 b=iH3wO8cz9olN40DzC/PEFmP6c3p47jByJRvj2y+Ejnr+48WiLCypMGzl6NcIPI/exmu/ECmXR4+FAqS0zEauiLfhFBR9gczJ4YrElkvfgNHEHxaKmYN5QaCVbRa0lwVbIZ3AkRXQYOISqjl7hzrDGjKxaxwJS1P4r9noYL40zVFOIJ3gxIOuveKNbqp5RhosSkxD5otb0hTIoFCW+O8MywbRqgtphjPa243JrknrFXkLXsF8PbqCWyegqUcR5RdkxciNpw4SoN5AAdhwYlcKSzpLjjSADs4PGT63sON3ARDD2DU/G9GLMnPRktS3lCnjQtoeX3HUZkPjQyw4ol4iHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NEejRHxqCLBrNoj1D4M5NQo7fPyPjhxIWPoPqBVpWo=;
 b=eih5sxwC+Ssk4IzTieebjtvdpcMfC2sMvgqu2J/JFtWyaJhlYv0IUnzyohI2OSu4wHg58Qwcz5AiAsCUGGWUhMQ2CuFKc9jnMAHiSHWUtwzHkiHAoaC/forL8VDuxMI3DkbribHNkRY9Jb3hlgXlKwwhuhKbiuAr4HgWVHmEtCk=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB7683.eurprd08.prod.outlook.com
 (2603:10a6:150:62::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 09:56:13 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9564.016; Tue, 10 Feb 2026
 09:56:13 +0000
Date: Tue, 10 Feb 2026 09:56:10 +0000
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
Subject: Re: [PATCH v12 1/7] arm64: Kconfig: add support for LSUI
Message-ID: <aYsAullgnDShlK5C@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-2-yeoreum.yun@arm.com>
 <aYY0xOdUxn39ZPZh@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYY0xOdUxn39ZPZh@arm.com>
X-ClientProxiedBy: LO4P123CA0683.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::13) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB7683:EE_|DB5PEPF00014B94:EE_|AM9PR08MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: 7beec21d-9db1-46ab-06cb-08de688ac5b3
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?G5r3AewdaBX3OK9AKxTjBHtASy4Yn7MXby96EUNyqqspdwSv/8oPh10K71SL?=
 =?us-ascii?Q?uK0x5XCGnGvRg2KNLcE5kygvvfh7lEge7f/TzDYWg4uzBEenyZaCJDbVJlKl?=
 =?us-ascii?Q?8q+LwRtn76u44JK+vE/dg2SFrl6/TLwDflv3mMKlZj/nSljEcOS9bZ4Atzsu?=
 =?us-ascii?Q?NYiZIfHXMASPgL83jchtwSEujJae56HVtNmNFSCwgHzyKO1+jZ6gx0SX8GDu?=
 =?us-ascii?Q?4IuJJO1Rz14+klHpA/zkXdqTuRtXAiilE0YNv7aHpg2Q17w5/9WheMZNJEo6?=
 =?us-ascii?Q?lNkRx43HSGB0sufywBp6czsg1sSLKH7xRofIwGk31P/liwUz42dpO2e5LKhI?=
 =?us-ascii?Q?ZYuK/gKayGd7WiDjG1gJp6xCXGi2qbeILcVOBXOhBAEBID96j4sCpxz9bxeW?=
 =?us-ascii?Q?efhTem+fzIJfMmVLo/vxN/BC8nhS+8bLTRcCYhsok+1pbaq4dXqqhezSLL0c?=
 =?us-ascii?Q?RXACyTfWmfPc+m04QVRhO7lS/XXnCKxd3+BVd+fj+nYyxhOrRZAZUYG7KN7D?=
 =?us-ascii?Q?N29dFdtJCJBWWoVbnCrDMa7xew4URTiKvnIq9eXQCzRohnQcvAmw8YMbzeGf?=
 =?us-ascii?Q?vNj9miSsGM2k1GuRRCJ1Y0/8qTefSmHvgQEe7quG5B6ldv6xVCzpsiWPPO7t?=
 =?us-ascii?Q?qpGLJSw20p3/CvQotW/Hx/EzAnxRwxCFCdPVtU3lQ2YB1DC0R9d3jSXaO8Px?=
 =?us-ascii?Q?7j52v+UjqrEbXWUYOuvm5hcEFFTqJA4IkNKS0RydqSySNqpdt1zRxArhKbZW?=
 =?us-ascii?Q?2gzW75+3Jt7OAIMp5eoOSgBf8Qtm/7aIINUXBk+Fp4DS2KVk5zUdLv6wP0ed?=
 =?us-ascii?Q?BPHm7YPFaPuCUHM7ERBWdoMaNZbGBEZ5sYo95XIt4DBcIQ4pvvk8ymeW88ED?=
 =?us-ascii?Q?CjbhJGdSW5AoXosbaFd/ZmZnLVh4kApvmanv246L3HnEMo6nP6fbe7LYvqua?=
 =?us-ascii?Q?T257voiADVgu+ia6RQCyUFbKzkOL77BxeIt8kwKsB3cWKHF9QSieLlutiTih?=
 =?us-ascii?Q?yzvsbkcFw6pvaURwChLGt99QqOmbKOr9VlyzDMszO5FGpfUC88vieCSaOGzU?=
 =?us-ascii?Q?7Qcq9Q1S9L7789PbBXy77O7IPGHWBuqSfntqjzOVHZGaT4AK93J4ftVQJjUq?=
 =?us-ascii?Q?CBaguYpWP/43sPBFHjyfNdbMxQbpLu9WL0IIENQ3F/waQcfPW/pHOVPirjr3?=
 =?us-ascii?Q?SrPvHYW96epKuS72TsgESx/iwfTmWU625LphXfqzTgjgfp2u2dTt8vIwr5/L?=
 =?us-ascii?Q?2PrW7mkwrSoYxVWUcffCaRsvHknVal4dzXFktNqm0I9SsbtlShBNMnMRGvGP?=
 =?us-ascii?Q?hOt4oXY//iN+RHDJGNJpj/CNtQz2OG9JIjME1ApHmgwoghhEdEuBCuCVC2dZ?=
 =?us-ascii?Q?vuuWI7CHBHZni433oarrk2+VmgG4NFPnW673OTVKl0WD6FxceVoD5wwuL3uc?=
 =?us-ascii?Q?xRns4F+jdfnt4EiJq9nrfDPJPMoNLblRPTryOPwRwUk8NUUbkj7QvNkM8o78?=
 =?us-ascii?Q?Io9Cf0ZhD/0H1VNbZmO8bex+s6nNJMDXSCAdAmWXCM8+6xM2C/fCbgsVgPY6?=
 =?us-ascii?Q?PzjsGf32G/ZQsX8lvnI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB7683
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fc044d44-a18d-480a-18bd-08de688a9fe4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|35042699022|36860700013|376014|7416014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?edego2hhtD7oA/Rh+P3i192ayLh0cmaYLxAsIVnRPRSqKE6QUBI5EvJzSX/O?=
 =?us-ascii?Q?bOek4/kwoVnPobOxL/OxqYv9IhhDMHI2pe5fzInAbgN76Mp9IJFNsmhCvhJZ?=
 =?us-ascii?Q?TbjESey81RDnZr+2BZAqGln9f2cyHBUdJe4/eDfVRHrC+Bv0VpACo0T/+lsr?=
 =?us-ascii?Q?gn8Udc4LvSMhZkjJIUyKuN6lWJQNehQQqWIXf/QfRDP/PtuMf5DKSlSlS00x?=
 =?us-ascii?Q?5tY1/P9eaK60vM5mFyGqwp09nJIn8qMK2yGuF5vqECqLFLj66fXNL05fp3O8?=
 =?us-ascii?Q?iM/N6rOCZnpnaPoxAFyfcCf8d1qt0eBZ5vAHyFI+zSJ+s0L2tem277ynbkqj?=
 =?us-ascii?Q?Hrfg+pfX1OIfaujEYbd/UX5ByouEgYVxbYRg0CbIi3/tGXVvIx3Tjx7antiV?=
 =?us-ascii?Q?FtKemIjPtzyFMTcZLs9cQZfX3gTy+826eP5Yvj2JMnTueDnulUZXeztao3hl?=
 =?us-ascii?Q?f7ycJZhOOVLzippI5l2wq2K3WbAnM8WsFbburHlG5rfCIkxijVnPN6ZeHI9D?=
 =?us-ascii?Q?rKGSE099yCp9LWkZwtPg5UyvQXESQxNXlTV4XsulB2gWyrJqLsFa+E8U3t0/?=
 =?us-ascii?Q?2cORgUaO0I1/pUFl1qpBSJb9wyKM5V0menFP48azQ+zIJijoykQLbEkvPTgJ?=
 =?us-ascii?Q?kjR2L0wgl84rODhLCZPqUgdu3vsNZ/STA17RVqfSI5vrbaw7ihyvlVus4X8Y?=
 =?us-ascii?Q?1o+/ItVrLmwCgfE0I6p62eFifExBCgMSHdZbIlmfCUU69LJHj8l68KqmDVqZ?=
 =?us-ascii?Q?xpsdfMQzZCpgkFm2LV9whPi4bfeCI8BXAdGRVJInI9ucnYEeKLP/VHC0PJNW?=
 =?us-ascii?Q?DoSns4PZYi/PmH3lD1yEP3zRofA/rej0oVkdOtCHXV7NrgJh0IzPg1fGwjlp?=
 =?us-ascii?Q?LX4wCqHlsM4gmZSJOR+MBB3tuaOmwNxGRa7uLbirF1LYu4cwmmJbQ0CuDzGI?=
 =?us-ascii?Q?qxrci5FoP7kayhHoyY5o3Qc0ovgVvyRVhBzla4dcJviG43Z+5qFhUmHBtUC3?=
 =?us-ascii?Q?7AAkC5wEA5vwwKERASWwmtlXx4uM64rZNE7RRnKVTs5D0Fp+wYC6SYZOk3g8?=
 =?us-ascii?Q?Tiaa6sVoURvPjxFPU/q8JR0bllJjwbtHlja7fklAqnf2HoWU8DoRSw4UwDZM?=
 =?us-ascii?Q?uWfOpCV95NFhaguc0x8zOyIoSWVf3/HeJ42f2d06JIYL4qkc5mDJCXs3hyQK?=
 =?us-ascii?Q?HBnkT5L43ZnlJBI5eeqtGeK8QsA4U5Vwnzn7Jy2PrpDYbTZWspU1saHAE4m7?=
 =?us-ascii?Q?IBAZZpu/g3WDeMzFs48BocHU0HC6q2Jkjd/M4biC4lUVjjVrJNQNdDQnzvz6?=
 =?us-ascii?Q?zWsNlBMjTakyiSEMqV4CRaRmYOBOdIme/LLv6yJ+IOwwuKlKpjRPLKadSdOS?=
 =?us-ascii?Q?jBePmTveHCc2fQgPScPsO2z61tv/8ZC+fDi6k4KOsPcVJi4BVsDyBlMdbviF?=
 =?us-ascii?Q?2GpPc7UnNnR+2K+a+UPrssHJIXEBuy13BTShmpCgRVnDqBk5HU0Hf5ZQIujp?=
 =?us-ascii?Q?WR4gwdXsbHVKZ9bUR3uRB0Gcme7xxSqqFkceWSiJ2oefz2Ni9WIIKtSMyVk1?=
 =?us-ascii?Q?XfaNaEIgOojeMi/yoT2bQ39xmu6PxK0sMgSwUctd5E5grDTwydFHR0mxfmwa?=
 =?us-ascii?Q?AK7Tu4vZgRl4H8JI2YYUeKpeLzXxNTWfnaoZ2HaL5avKdgtHYqcdRZhnGbTf?=
 =?us-ascii?Q?3EIoXA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(35042699022)(36860700013)(376014)(7416014)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2cCS+OwXN63TRpNpZqxZpXwVY8F1+qK+UZwfRa2c0rncZTS5GvpYUic+x11tR0XnCGZWvxmeKD881gpjcOGBhwO9RFn0P8HYs4I9OO99WUE07hk/8aGSuk+KpHY2kaxTVlz42xB3kE2/dw1WLLUSFyUA1lF/9IrQo4PqilLT+JH5aAqOtXFwY+sfRj23lBuaPZrdDQRktEKoY5E61kvjxI/FqUB3QzuA3FUXzVUX3WXiOzYE8ObSroecjYnzorh9u3fsCzYVnQBwqNqoU9BWfd9ECqDouSYAji9eyLaHVGWB2E7Mg0YBqt+FvQN111qnxu5HpD8n3gFQZAaR08QBrGDZhFcbd95ZiaSGvbcjjSfbGNgC2aMGgmsEftbns/ozJUjMGnnQYjYqqTHUox+qGTFQ1CDq5Yc0hJM0wNWD8gvWEspwFckW9MFaSC2y7gOD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 09:57:16.3825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7beec21d-9db1-46ab-06cb-08de688ac5b3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6147
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70720-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,e129823.arm.com:mid,arm.com:email,arm.com:dkim];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 1BAD311950D
X-Rspamd-Action: no action

Hi Catalin,

> On Wed, Jan 21, 2026 at 07:06:16PM +0000, Yeoreum Yun wrote:
> > Since Armv9.6, FEAT_LSUI supplies the load/store instructions for
> > previleged level to access to access user memory without clearing
> > PSTATE.PAN bit.
> >
> > Add Kconfig option entry for FEAT_LSUI.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!

>
> In general we should move the Kconfig addition last for bisectability,
> unless all the other patches introduced are ok on their own.

Oops.. I think I can move this patch as a last following your suggestion
in next round.

Thanks

--
Sincerely,
Yeoreum Yun

