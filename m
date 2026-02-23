Return-Path: <kvm+bounces-71482-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DyWMxt5nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71482-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:58:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E3817932F
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 129313119BA0
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 15:56:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B55CF30E84E;
	Mon, 23 Feb 2026 15:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xwku4fud";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Xwku4fud"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013030.outbound.protection.outlook.com [40.107.159.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C65E308F1D;
	Mon, 23 Feb 2026 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.30
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862146; cv=fail; b=PjTcmCXqcyHiaw6SGukjI9nslIS19+uOOtMv6lj1HPJT0S7ij0ULFK3XFhd/MxkS+ca9DR4iAKLR/Ci2i2XFR/0jfB4M0Y1PmdjHBPvJ2nORJdQpJyBOPUdfOab5UDT1CKwZ8Z0tA6Vn5465Zt+vIEtpcCjS87WY9Z8CJ9LHceo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862146; c=relaxed/simple;
	bh=MDSbCN9Fcx3OQCNTKoHB9HCJx4y0b142pU8kYKkJzRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JLD76EkFMscn+3olYJJMSCDrOS7+sqCIFMYkRWKuiFz7ts1trB68KTn/xQcPVLJmoJ42ht+9HfrhDQOY/l/gI1kp921I4WN8vvOFovongjqiqwodj5l5kz0A8Bv8pX7czc73ydr+mneW+CzvAER3iZ7vCHCzmQrzVmfKfW9yKUE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xwku4fud; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Xwku4fud; arc=fail smtp.client-ip=40.107.159.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=YXjmdO8BYbmJZTIUHr2nlhvKgXQ+kqMMnsRPLDi2iw4SEI0baNsgfHg6YpQQYbVt/qrCIwtJV/8mTKHtu+bv6wJAMEWdPJaO0NlkNHWO7FEt75k+abpPoZHcuvlMPv0O7GB2IxwR0iUGKpshGXV+jVskuqo7NCBwviC4ynnXEpZOmjUlx6FOexlSQn1d9QyKTRJJfUjuWjo5SRoU4Ec/kqcqsW8NoDUucxWYSMoXeyfTWVAn1f35Q2ktUsfeoEDLZ1SbwTgEnmDnvR6wL9uxM96hr3LqfMYokIeGgf+1eZ36e/ywV9pAErp20CqIiRf6Cutj1U5TCyGSme/LydS/cg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpLO/y4S3Z633BipIAiGf0ekQ8rZy6AJu+PxT3WB4ZU=;
 b=NxnB0kJRQrrQNjFV7r/RmkTxDHMZbRI8yXRsDrJv17TwDL3RFJZm3I8M/BcqiT5PElQMxp1rsU/6IVaFoXJeggRHt2liQ3FpBP6raXJAaM6tif3eXsr8UwT7YWWubvoXMUemnBN4hTBvbw+ZeIzBwLVQBXODTuXpKQWigO+5bWH1So/WNG4M3sT5hmaZoUVcia7uAtp2pFK7T50CWQ6phlPy6pKq2TvjkjCe8vEW3VMer9NSQRoOeriWRCIjEjgCM8t6JoRRSO9dt42dS89drjICv7Neuzu6VWKtjBU/zO8kOj9xMhUD4uQcDI3jY81H83R708q1iTfHF90pHIEvDA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpLO/y4S3Z633BipIAiGf0ekQ8rZy6AJu+PxT3WB4ZU=;
 b=Xwku4fudOeQnJw83IGkYjdBFZEXwtuthPxVJSrkAoTMyrVKP5697Ldy+BK86NElChfgaAsia4A2D0ENSX31lsDyqPnvFvQ1evF90DrafO/dbzyovTfOSBZv8kAx/4Z3teQr05L9C6dCUykZcgzeXqHKkCrk3v9B9Wq3yQmHut3Y=
Received: from DUZPR01CA0006.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::13) by GVXPR08MB11761.eurprd08.prod.outlook.com
 (2603:10a6:150:335::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:55:37 +0000
Received: from DB1PEPF000509F8.eurprd02.prod.outlook.com
 (2603:10a6:10:3c3:cafe::63) by DUZPR01CA0006.outlook.office365.com
 (2603:10a6:10:3c3::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 15:55:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F8.mail.protection.outlook.com (10.167.242.154) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Mon, 23 Feb 2026 15:55:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vJJH3giYlPlc4KkQP1CYMJlkJoOlfWHtn8guq1jcFv+wcFh+fy3+zKyx26Oi8U69dXSy1tf+22DTGB90O+v+/s1uM+3S+Fr2ReRwlXtkYJ6cfFAJYS6HysoOjadQs9JYjewQDBJdpXw/y6f1k9hl33XtB6srK/f1ZKJxgfefNKiqbjMdqKLEpp+GNm0vjREVczamcjbvitwdQDbiz1keu8H9+hMw7Nku5K2xCEskv/2u9xOzr59/0etHHJLappYgtlGZJJct/EdNWzV0BlBxTBXrHGduw4QYdl+TK+MfhMDDvycDFeiMWJCF4GHYG7UV4PmP5IQBmsq70WjmZgYM2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpLO/y4S3Z633BipIAiGf0ekQ8rZy6AJu+PxT3WB4ZU=;
 b=mmMh2jrnKbemclO7vGqUFOjmfSjYVcVwZayJEHjAUK//tMDofN7pRHcZpc5oLai5+KSDjNRsbRErkOwEcwWXLYQClf8GVrGzph7tePFLTzzwP85YL9a+2YQsKEej7Sp5gS5qDROyJnPClSt/3NKfdnE0Wvr5xbaedjouefv0PpeBt3fcTk2DEqgP7LX0UjwWkvuM6T1Ker2OknGc3XAWKUjhvrdSDC1Ifv3GDsOs4Y48lA6esD1eBO8Wyc4FdmDzg1t0Ae6Du5Pg0XTvbu1233pdXzgBN4P5ZQv4IG0XP44Izq13PXxEYOIlfcd18ER1Tad4tLZYzu1Dop3K4Up0oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpLO/y4S3Z633BipIAiGf0ekQ8rZy6AJu+PxT3WB4ZU=;
 b=Xwku4fudOeQnJw83IGkYjdBFZEXwtuthPxVJSrkAoTMyrVKP5697Ldy+BK86NElChfgaAsia4A2D0ENSX31lsDyqPnvFvQ1evF90DrafO/dbzyovTfOSBZv8kAx/4Z3teQr05L9C6dCUykZcgzeXqHKkCrk3v9B9Wq3yQmHut3Y=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by GV1PR08MB10572.eurprd08.prod.outlook.com
 (2603:10a6:150:169::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 15:54:31 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 15:54:31 +0000
Date: Mon, 23 Feb 2026 15:54:28 +0000
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
Message-ID: <aZx4NDiArOfsEXYQ@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-3-yeoreum.yun@arm.com>
 <aYY2CyHWtplQ-fuS@arm.com>
 <aYouAv_EjICIN8oA@arm.com>
 <aYsAaaQgBaLbDSsW@e129823.arm.com>
 <aYtZfpWjRJ1r23nw@arm.com>
 <aYtkbezCx9vW8SHz@e129823.arm.com>
 <aZNgR6prm0Exzar0@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZNgR6prm0Exzar0@arm.com>
X-ClientProxiedBy: LO2P265CA0486.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::11) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|GV1PR08MB10572:EE_|DB1PEPF000509F8:EE_|GVXPR08MB11761:EE_
X-MS-Office365-Filtering-Correlation-Id: edcfc1a1-211c-4ef0-4de0-08de72f3fb0e
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?uGRjRauXuJdSn5UkafUj4NUJvDvvLTgHccVejuUNR668bK8/FN2/N9YSyOw0?=
 =?us-ascii?Q?NlgrrKBBZvwrpvList5Yb3/fuPY0ViZUa/XH0WB7d7WjJZmXni6dJZNh9xzG?=
 =?us-ascii?Q?9YIusFcmL58TQVM8MxonzyHRoyMcHEXI7NlVZuEPh3HuadG8q/w3aqKV8D6X?=
 =?us-ascii?Q?5zsiSFtHgCtUevgw4hzo3SKaeZzs1QMQCvdoI7WUOq4E0ntTH0RVErYGiQwg?=
 =?us-ascii?Q?dNuWxlkxxyQO/5QugTomQId1ZWOSHwe5bSrmpr5IEqwPBiBXRTKxDRe/LBGo?=
 =?us-ascii?Q?ot7B7NoEhovgUSxMFqGHJqSf7esmoZ6ghXrnS+FuAbUjWAIMe3iNhxSBdtcT?=
 =?us-ascii?Q?T7YJRVYPCkBiMSvZhZ8Y1J1tPPMymQjkGAtSWzUc1L1uP/ABrsRHUUBcDmaJ?=
 =?us-ascii?Q?B+ReLoR6Ytto1OjLGJd1IeYO7B0VBAq8xbO7FOp1samhhnS5indh+deJ2fHL?=
 =?us-ascii?Q?IyaeNhoVTrxyrCXK9rmQYHK6cx7Ke2v2tzfVCLfujUV7v2dmKiiVDVZ1O5n7?=
 =?us-ascii?Q?P9kEM5/3z8/FkH/J32AQZdTNyKyq4YblqbyC4UxRFSoTtMF1OZFMiEhS10Zv?=
 =?us-ascii?Q?rCR0Yu73U6fRq682jJNYZO1aG++1A6ORKPIoADF4TwyAz03cnDZGlfc3O4sw?=
 =?us-ascii?Q?Qgk3+ZLlU3wBWaXASEanuEciFnQ7a3PT9BVIVypolTP2NKK9ErPKW+JmWWN2?=
 =?us-ascii?Q?FrfVmW8/NwbWaTlKfVs3QIT2Hb99lMAWDE9NeoiF0QQENXOVqTW6n8e21iIe?=
 =?us-ascii?Q?5rek6KrkXo5vQZ+h2EJqzuyfTIRZwC6QqPeJQ2LYqQbQ+yyMZUcJVxo0lRn1?=
 =?us-ascii?Q?yDgCer+QgGClzkMHH2zGpsi1zhuU/37Flichkp+3exGTxRbnaYyakTvaHW/9?=
 =?us-ascii?Q?10+W8ig5xJhSAH1GOHYbv1QZ4Phu3qAqeZmLHVoCeqAplHzZngqFKokK21dA?=
 =?us-ascii?Q?XEZGZUuuGC6+23F2pmBUUO7IVKW3i8NFLqXkcfdSbSs7QUPZQ9l8FoD/TkSP?=
 =?us-ascii?Q?/rSkDvG6ZixP4sbXbcjCiT16NKufjKtHEVNPjbvXUJCFv3mHEOMHF0rPNlFG?=
 =?us-ascii?Q?oZoqWrGLpiZ/4V7SW8VH4fDyNHPgm/PMzTWOlgAJa5E2IH113/zHQsE8zH8M?=
 =?us-ascii?Q?ynKyddCD5panD5z+yOun3qu273D125vF6LF5SAd7RXGL8X5ZlvgrB2RQFIPx?=
 =?us-ascii?Q?DaU2Kxts2sE+e8hfGULlC8pZJ76MCifeWkqaPAiRpRvfS4PkegChIpwQYQx5?=
 =?us-ascii?Q?Qh0mxt8cl7F9ApJ3D9Ce/KuJMHlSTsSEjz0jxkEYGggyQN/Rz/hVs2HXpgOV?=
 =?us-ascii?Q?j0ifMmzVB9L/9xjm6PEMZf15BrwNg0p5no413wMLKEPgIOUgR1hEuBFEZc8C?=
 =?us-ascii?Q?nxu5JtCGqoqhg0vY5uHO2JrV1ML0SLgN0PSCnsUmAOTl8bHhH6qOTd94GDhA?=
 =?us-ascii?Q?4kP3wTBGWCnu3yqfrKBagL4LOHklTb7YdO+LBKO4zGPwn35aG/+nPHBMx549?=
 =?us-ascii?Q?BvFnFa1nHRbvQx+L6iupVhgiTOILfrpD4OTmJADhq8Zy72evBTUxjxLzd9IH?=
 =?us-ascii?Q?IKuEFMBouwQP8T+u8mw=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR08MB10572
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	fe9d510d-f320-43cc-1ac7-08de72f3d525
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|7416014|376014|36860700013|82310400026|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?recUBsQaiGHkxf2XDi9mZ5RrquKPb1g0TKTQs6OJPGFDj/s59NVJ0/fwuSSp?=
 =?us-ascii?Q?hM2tubCxCr73nhBtDCTjTFbypMJdccZt/cqsdaj5eBbqkbJGZ4uDedKMW4X5?=
 =?us-ascii?Q?ZxB5iZEKXboOdomfeTbYdIZXXvl+3E1BXxcpaT6XOpxSFWT5fj67OFTKIKcA?=
 =?us-ascii?Q?NZd2IjE7jKP7uftxJed1vmBxau2t01+/d/xY7g2EPhB9LTIEGeRYeBpGfnyS?=
 =?us-ascii?Q?VR2syoFbwQvR0R6Q7I1WNe74DblU6Oh78KLFkz/JDat2AUyuSNhHsWuxrwo0?=
 =?us-ascii?Q?Rho+ofn6YO/zf7fna+BKUWfwlCpCRqoRashPukge4SKKsaM1HkTYXvgVzLri?=
 =?us-ascii?Q?bs+rf0nofiL8GZl+eGf0HeGdSx2anhVLun4/yhyxogA3PbW8ku8+X1IIj7qQ?=
 =?us-ascii?Q?cDq6zTtSyJa/K9gvp7uBNpciCVrCbU37dVM1GZau+oXYZ2PD3FEQqy5cuQMY?=
 =?us-ascii?Q?a2uYolTDjDalXTgb+rU1lVnNnNVurP5efwWX1J2kqO7Ld7FWuLTOr2K9Ta4s?=
 =?us-ascii?Q?pCqauOZlheyQtcthchzJSR528u9mV67BpRa5/G2ldrQSZJuF/0ApgTNDMwn3?=
 =?us-ascii?Q?KKxlUjKiIWWu91xFmeSz7xsXOvaDjJIE09yXas52fWdvswb3eZX2tycIlGQm?=
 =?us-ascii?Q?b2dYHFIvjziW256erPRW1MzdI9Ki7/n+gW2Aw7fhaMyi7Hl8SMYPj1zvOoWg?=
 =?us-ascii?Q?XjXaYHO9VoUdOeWRrKh3fRuN1C9TzGI3eDyB5A22ySWHv6qwL2oIB57S39dp?=
 =?us-ascii?Q?zhyu5kPhVAhfFm/g6ZS+ATrzgwEWDlLVs4QcfY8wYP5Gawp7xUZ20ucwg1f3?=
 =?us-ascii?Q?4lsiuPo0ZLnAJbouFUvw4IllCSwgtaDLTSh/h12qPAGx/dFccfF9g0yxoL+l?=
 =?us-ascii?Q?uvVP2cnYDev+s1IuYpKmeP/8/JCLL/jM8HLnyiwEjHh9MNb6lyl8zaDM1Los?=
 =?us-ascii?Q?1j4jPkHfxJX2ioQii5ouvm85wFDXxT6sENGeLpjeiYtMpsEvwmtvp2YjM/wk?=
 =?us-ascii?Q?QHKuzxj546/YpT0YtNqd8JsunZEVFYYn097A4Dfrj15Dct+tROKXmrtpc3mn?=
 =?us-ascii?Q?XBBhBW2H3bAqLjvmbqHXKW3bo7HALqKwf9F11Wu7jm2vZ7iUa3y9Q6gxA0dz?=
 =?us-ascii?Q?9bz+Wt1idnB3gBoPimllmN9l7dC5mg5dudLOLea8ymunFxkl+j6n2dM4zn/s?=
 =?us-ascii?Q?DnrHWgauvxDh84+dtnfsHnIfS1Lk/42Ps1/3FUCf6sXaUwhH08a4r8Fqz5T9?=
 =?us-ascii?Q?rUtiodKOf/3p1G4nvhznzyOn2d56VhdTT0gCFDogbSc6EPmR3+GiDhdYUnd+?=
 =?us-ascii?Q?9l4N63ey+QN7x1ncVTbWAQW5aCxkYU3DK1p3ay5d+1SyB+pB9wDnuIVZYy0q?=
 =?us-ascii?Q?9zd/dgl8571ssQuUq4SamwkbkviGp1uEatsV0vC2djd1IYBUlWGdoeF2yOQy?=
 =?us-ascii?Q?xuuNek5/kt7Jp9Sj5NJqnrPGdGRb9K4n9D2IEMyTswpezVZcTkjoRX/SMGlQ?=
 =?us-ascii?Q?cbrMB8a4wCJbsurhnWaHVemUovfAm3u/Rx/0Le169EQJ8uI2il32hjYepWRJ?=
 =?us-ascii?Q?hwpnxb3S8Q5anlkWvtoP2/wWYeUXJHYlB4gl0a5hm1UYvMJn6c15xKwWovIK?=
 =?us-ascii?Q?xnxUa5hbpX+gBI1nWojw2D5Jre25wdtp5SaCe4ghlpNdHxAq+4a8FU3dUeFC?=
 =?us-ascii?Q?VHdlMQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(7416014)(376014)(36860700013)(82310400026)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+w3x+wYLp5IKplMgMWmFzakF/YuwvK9E+Og7sH7f1gNGEW/umDqBjhEwFiqjSM9ni9CWh05hng5uqYfelnUjmNBZPcRWHp2C2J0KK5xKQZwFXTHMdlOPApFFjewrdMiYIwKx324/axHsGldxUKjPxzdLXlEWhSIEyVoyHa4J8yKfIEj4Dv4RPGno3+oTtrFuX+3N9KxbXB14+pxqCRNDXJQtIsbKzW07duVH9J+iddXhC2nx82cRRscgN4TKd2F5LUxK3HO4/Vv/uLiOBG8wEaaR+8u+3wcXa5h3Jo1WzRjuNiEGCIMVAt8XSbA0EebtaYE/f5WRkLZgiZ5xpDS39m1v829saY0ByuVZVHjocFquJCL9FLJIeMdZYinjN9yaAZCaQJqdlICsFFQgzd3G6l5r8oajU5zuI4Kdeuw1YDUARcy8df/mCOahUU0u3RDU
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 15:55:34.6803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edcfc1a1-211c-4ef0-4de0-08de72f3fb0e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F8.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11761
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71482-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 44E3817932F
X-Rspamd-Action: no action

Hi Catalin,

> On Tue, Feb 10, 2026 at 05:01:33PM +0000, Yeoreum Yun wrote:
> > > Why not keep uaccess_enable_privileged() in
> > > arch_futex_atomic_op_inuser() and cmpxchg for all cases and make it a
> > > no-op if FEAT_LSUI is implemented together with FEAT_PAN?
> >
> > This is because I had a assumption FEAT_PAN must be present
> > when FEAT_LSUI is presented and this was not considering the virtualisation case.
> > and  FEAT_PAN is present uaccess_ttbr0_enable() becomes nop and
> > following feedback you gave - https://lore.kernel.org/all/aJ9oIes7LLF3Nsp1@arm.com/
> > and the reason you mention last, It doesn't need to call mte_enable_tco().
> >
> > That's why I thought it doesn't need to call uaccess_enable_privileged().
> >
> > But for a compatibility with SW_PAN, I think we can put only
> > uaccess_ttbr0_enable() in arch_futex_atomic_op_inuser() and cmpxchg simply
> > instead of adding a new APIs uaccess_enable_futex() and
> > by doing this I think has_lsui() can be removed with its WRAN.
>
> Yes, I think you can use uaccess_ttbr0_enable() when we take the
> FEAT_LSUI path. What I meant above was for uaccess_enable_privileged()
> to avoid PAN disabling if we have FEAT_LSUI as we know all cases would
> be executed with user privileges.
>
> Either way, we don't need a new uaccess_enable_futex().

Yes. But like raw_copy_from/to_user() where use ldtr*/sttr*
when MOPS isn't enabled, It seems better to use uaccess_ttbr0_enable()
instead of making special handling for LSUI in uaccess_enable_privileged().

This seems more consistent since ldtr*/sttr* are similar function of
LSUI (doesn't disable PAN) and doesn't enable mto.

>
> > > BTW, with the removal of uaccess_enable_privileged(), we now get MTE tag
> > > checks for the futex operations. I think that's good as it matches the
> > > other uaccess ops, though it's a slight ABI change. If we want to
> > > preserve the old behaviour, we definitely need
> > > uaccess_enable_privileged() that only does mte_enable_tco().
> >
> > I think we don't need to preserve the old behaviour. so we can skip
> > mte_enable_tco() in case of FEAT_LSUI is presented.
>
> Just spell it out in the commit log that we have a slight ABI change. I
> don't think we'll have a problem but it needs at least checking with
> some user-space (libc, Android) people.

I see. Thanks!

>
> --
> Catalin

--
Sincerely,
Yeoreum Yun

