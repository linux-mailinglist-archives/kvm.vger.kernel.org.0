Return-Path: <kvm+bounces-70924-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDpgNsSKjWnq3wAAu9opvQ
	(envelope-from <kvm+bounces-70924-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:09:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F1312B1F9
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 09:09:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 057A230D4EDA
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 08:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E125F2C21C2;
	Thu, 12 Feb 2026 08:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QIdVGzGh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QIdVGzGh"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011067.outbound.protection.outlook.com [40.107.130.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE7B1EDA2B;
	Thu, 12 Feb 2026 08:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770883767; cv=fail; b=DLvDdI6lXFBU6NH6ci5l0Fbh0XXX4irF+UhhWrxnBDKPzMkcpS8bikfhWJgB5Jvn/Sor9jybitoXlkutbsbiRpo2xvD+fQQU6X/f3uVjiUQRiJ5j8OGPfLjJk5FR5gVZ5nIeyXkW4ZoPyH62sbr8sfiUs4h+bg4qoMw4zaCvkwI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770883767; c=relaxed/simple;
	bh=2cDjXtRS/2bcAVkttX/3fUE+0z1GeC0pZYG3r1B6nn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u+9C5RU/zK1d3jAdRj9bE1E75tL1n0MK9QB0tqxgbZlunASYL32GYSdB8dMHeH6digaKkT6/GVRLrQYtdM8wfCAiQ8VZTsd/BubqHMq6xp4FImNrb7bD4w2YF9lAAcVDGV+aVq41lB4BdWmf5zDXHsQ7LjhNOMK7Z41U7XHO/Lo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QIdVGzGh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QIdVGzGh; arc=fail smtp.client-ip=40.107.130.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=pUKKu19TSorHRnYq6gWGtY8qU722CBhaaN17TU+Khz4T+UV3OKWFAshmBLjAvQtqFJ+WZsG9YZCAeFlhqLI3300LaWpDkoacebjtVa4luJn5EeETDW4lFhnEk/9kWWZ96H5GqpxWXGhU8ZWm5AfxO9EI5tf0LLgvnatZOzMYPM48W69tc6+suTnwMTI+gASvk1/UQyQFOwZ5QETqnmSPmT9z5ygPj6U0GT66EKYsU8wEcz6rNcJw8415kFt1SNg/Ssl8AVA6xvLiLqHYIh0UM4qBq0TWkR1YwPduBfkqwdUUhv8LLdAgFYK9TWjsQx/RtWWQ4M7WCCrZK+go4lmZXg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cDjXtRS/2bcAVkttX/3fUE+0z1GeC0pZYG3r1B6nn8=;
 b=lSUgVUFKvTqzhtQJIZ5LLyyiwlYGlK7i5SV2gZlTwzVEzRUkc/HYqMflV0LJL92vkle3Y+HBUVgpfxgTL66qtbmCrl2oBm+7VozWuyaYeRVNuiiDLW9f+L+Oj0AplgmfDZkpkYQR4tTvIFRNqqRqjD9ARHRCPOspi2ipWSM0lLZISIRWZjpeYcFCSPboCOwsPtaeAjjxJdl4mzIhju4b2BxWJRwGTzvebeWBmbDwqfrzX8vIxSIkFJR1Yf72e9dNoNqMC68/z4Xxjii495vaoNR16CDb+TZJV2lpiESrlZhcTGtLLZiuwF4ar+/1C00Tc5eeL/poSk56JXsgsOuQBg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cDjXtRS/2bcAVkttX/3fUE+0z1GeC0pZYG3r1B6nn8=;
 b=QIdVGzGhdO6dIlfppOPC13U2IVox0iubCUUjPQcYRbbZH1DiPEnJn2wmAPrf8wC3ejCpokFV6LqxIQ0hGIA9j9gubDL87M6KLBAIBEz7HvRHhskIQpgxCvkePI7FAra6l+z5kla+y0JZ9xoqMfSjTZqllOw824VGlpBq4tl5SbU=
Received: from DB8PR04CA0018.eurprd04.prod.outlook.com (2603:10a6:10:110::28)
 by DU5PR08MB10633.eurprd08.prod.outlook.com (2603:10a6:10:51b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Thu, 12 Feb
 2026 08:09:19 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:10:110:cafe::ca) by DB8PR04CA0018.outlook.office365.com
 (2603:10a6:10:110::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.10 via Frontend Transport; Thu,
 12 Feb 2026 08:09:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Thu, 12 Feb 2026 08:09:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H6Ucn4Vev60GaG6k0ISDrUI7MZH2qYcuJFBB0dD36ltFQZk6mewDvL0ME0zYueG0zlg1rfBDL1GQMbRd09nomeNdw+C34bi4vrXrU3ueaynt3OH5HeAcEsLm+4d2akYHPx93JfyfjjYuFlslT/prpanntwMKmhCbIekukT784VcbgQ1DZYAEbCfpz3iIBFJZcL3Q9ULEvAfLxh8hJRRyfAGs5MEUAxblLNhh5qeanpCD0wp+hRWh/PPCNdCcfFpZFQlbkOJcJopKgxs5Y9Y3RNNW39halqVuvHWMRLo1vVG8gruh4EKGowcZaRffSZf/uVgMoavbFTveYsK+fE5NwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cDjXtRS/2bcAVkttX/3fUE+0z1GeC0pZYG3r1B6nn8=;
 b=HitYgJHK3YV0TV8dDesNu3xOQyrXm5Nqb43+/S7fe5eeXOjEJfKcP6NCMJ7upOfGs8mpB9mDsaOsdvLkA6wmrct6xjElVzj4OUpC5lb1tiHWBtaBYfE7motkFK6poNdk7KKXMxfzkyng2g6iQol9NPMYtiJVnlXDhcq5eXDRC69xEdtMT0/D8ykdbbexa8Jor0X9kdkV72ganwpnpeuHyEXdbt1MKr0WrOvTvVklYIkZ+Z+4le0n//Byni3JCTbNbOXSLc1RWz67iAF88s/+klYa01Ylzdwer+yPW2dhSGRrCEPYrSOQ0pTTQOY9uqAikIh42EeEhZg3/XRkCXodIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cDjXtRS/2bcAVkttX/3fUE+0z1GeC0pZYG3r1B6nn8=;
 b=QIdVGzGhdO6dIlfppOPC13U2IVox0iubCUUjPQcYRbbZH1DiPEnJn2wmAPrf8wC3ejCpokFV6LqxIQ0hGIA9j9gubDL87M6KLBAIBEz7HvRHhskIQpgxCvkePI7FAra6l+z5kla+y0JZ9xoqMfSjTZqllOw824VGlpBq4tl5SbU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AS8PR08MB9621.eurprd08.prod.outlook.com
 (2603:10a6:20b:61a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Thu, 12 Feb
 2026 08:08:16 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9611.008; Thu, 12 Feb 2026
 08:08:15 +0000
Date: Thu, 12 Feb 2026 08:08:11 +0000
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
Subject: Re: [PATCH v12 0/7] support FEAT_LSUI
Message-ID: <aY2KaxaI+HWwXisM@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <aYWuqTqM5MvudI5V@e129823.arm.com>
 <aYY0h1DtvDpEyekd@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYY0h1DtvDpEyekd@arm.com>
X-ClientProxiedBy: LNXP265CA0091.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::31) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AS8PR08MB9621:EE_|DB1PEPF000509F3:EE_|DU5PR08MB10633:EE_
X-MS-Office365-Filtering-Correlation-Id: dc5a329d-4738-41d7-9076-08de6a0e0621
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?s9zhb0uZDV/AlleW/YrkqaHOt+iU53x/GFFHibfkDiP5a3TSC+OJEhCU0J8B?=
 =?us-ascii?Q?S9vgtq/sN4ucsCpf8TXEEk8DM7uVlnuyIt2k29fWry5NRnCjE4312kRrd6wt?=
 =?us-ascii?Q?ZJNh8da1z4frxDoXcOTekYgGxF7CV5NAOeQNruzx6ouf20k5MzMmgM1pyh+i?=
 =?us-ascii?Q?ecHu65iej6b8KwKbZK3578wtN5kxYV9Yd7w23NFbJPU7sTnepZwQH5PxgF/1?=
 =?us-ascii?Q?8I/6+Cx/NYdFVinHY4C5E47ogg/sG+gAOtjBhB0jSdErEB47yqq/omFMWI0O?=
 =?us-ascii?Q?j1TD84R/cZCv55LP8SvsPHL33MLUY70el6uMYGG/1NMmUBTeFp2VpeaU6UsR?=
 =?us-ascii?Q?ayd8RZAUwCCA8ToE3tqHulsrTyI1OzoLLGQzMSJIHXKgRX4Kmt1Cdx/RZ2ZT?=
 =?us-ascii?Q?wJ7PXMUHIJGswe+79xfpa2CQQ68NyMeg74kxaWIyDKJ35sP7AFbyOE2KQ/pk?=
 =?us-ascii?Q?cvEwhJ/1pacW/QHozmF7wNgrK+11RVWTYbORaPRzxNZrdAcqaE7qTG7wStme?=
 =?us-ascii?Q?/xdmJA8M7XK6gkbxKBRTgZkfNE4/ETI6NJHTBYFe+Gcq2Pf18i1sK7qLBCG/?=
 =?us-ascii?Q?1HaDBJOsApwp64uPIE4WnlkJiM+DuM+qBQISX2XJ//LBtbLk4hkSpuotdU3v?=
 =?us-ascii?Q?shlXD7dT13sM1tYvcyIk0KRw54EsWUqDljBGNikhKT2kmfICfAAX2BYolLUp?=
 =?us-ascii?Q?Qecu6i+q52BPcGg5y5msOx1vsz3tP11Ie/xzrBks2+3Y+yd140nZkFv5jK2M?=
 =?us-ascii?Q?qYfYgdkTyKRFS6guZV2ZZb/aoecbl7g9QShkstmchOqw07atgE1+wGTqQKP0?=
 =?us-ascii?Q?gOjt13VTdoWTSezKBC4y4vw6ISTR96HX7SBLahIse5+uh8XeWGRmhtRS5Oug?=
 =?us-ascii?Q?0Thj4iQJ4k7TE5c5ydDFEzg5fXwaB1FF6gMY/UisCpdhizKkbEx30GNIV9VM?=
 =?us-ascii?Q?wz/bk/JSJoUKOgXWV0xaTE5atAuCChy5GBYbba2V8HiiT2z1CDLgCQWA/szq?=
 =?us-ascii?Q?EvhKikziXyTwzDQ9fKlsUkvfB+mrH0fp2LQ94zsq4j8eS0+rsE+C5i4abHLL?=
 =?us-ascii?Q?XfLPe1tkV5tjUUZ7hAh7R9fQ1Af30Oq2eIpKGJua0FjxIU+V2/A4sGyncE6c?=
 =?us-ascii?Q?Ev4RF5Sn/k73dTi0xdqUzyPCL44dAz9Jk3/2rJVHipRgj67FCLj89e2I0L2S?=
 =?us-ascii?Q?y2ODZ5qBbhAlizePDlEhYCCRL3F58pTuU7zL9P01K1Rno3gW/pq6HDmQdcHS?=
 =?us-ascii?Q?gd8Nm7RW8iQt65tjPjsYIQYmjdYeM0Mc5/OP+9EOEFYJ5TtvyVKFRXtAIQVg?=
 =?us-ascii?Q?yZqJpfbMCr44gDp14feWu/3Grr0aC2oe1ICXpuyXpAXbXHpf9LgS7yfI3OJP?=
 =?us-ascii?Q?Gj1/5n+cv2HGyA5cue3mv2GaDjsUvBDTtRDF/+f2PafNiiaoK/hBjEsBT0vb?=
 =?us-ascii?Q?cAvBYwbzua3xw5NvTpugdhL6RJWpVCcwvT0tO96keHQ1LxzunwZcd9IrBU65?=
 =?us-ascii?Q?9Q30mrwyq5RgG/wLKfSQSM5xSOI3qj357tKJjceL8UMBTGkHgn9qoHS+dCh3?=
 =?us-ascii?Q?gPM4dE4CXR05Vt3JbVc=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9621
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c3156e02-93c1-4b55-91ea-08de6a0ddf71
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|14060799003|376014|35042699022|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mHpP6HDmObtXyRP4PqznBnQ91t6zZnpiHmP1VxxhwkcIB2HutvaMUiq/eoKY?=
 =?us-ascii?Q?c7UMHfIlqXAPjoeFzncxHfxhWNqKfPL+jkFl2w0wO0pmZNVrOEPwFrZuIAWE?=
 =?us-ascii?Q?iSQZgVNIiy7I+p6G62YuHFpa9kFLEOEenqh5a3qpDosFHqiXNnJN80GWtQ77?=
 =?us-ascii?Q?09rFZ1h7jpe1lEESfm5pZ2hak1NX3vftZHat2YL20RoIMHsYgtJBbUaQ615Y?=
 =?us-ascii?Q?pcgpD+bc/9bRmbVnrbxYlBx8M1dwVih4adqV7VmvAdvMwesKWc4Dc90haB6s?=
 =?us-ascii?Q?Psh5uWnNdbkFFnZFPZekWnwwPi9fggH/V0DFO15GzQCgKOBLJl0QkXvQrHal?=
 =?us-ascii?Q?w+wcyAV0dyxJWERenYNreSNBKPN7Y+nI3Zvohz6IjryEB3xKh6G+cTA44H3K?=
 =?us-ascii?Q?/NAP0MZFhv8hKPEE8/N/BXYm2jfEibDml5qGRiRAnKjvRGm4VGg3h555bf8C?=
 =?us-ascii?Q?CKaxd3QubmUTz0zVADdz65kyqJdlYo4gFEvyB0SBOannXfFe0ia09qr7gKIN?=
 =?us-ascii?Q?iQfrO/bZjvtKUhg3pWOKOQHz6TNKJt4OFfouiDmYoBHgb8Bj1rkOSWBHK7dc?=
 =?us-ascii?Q?N6dGLt9GAQHC3jO6WY+1maDAzCnHAd5D7kT7T+48cPa7UgPwB0kKrlq5ZHCW?=
 =?us-ascii?Q?s0+w2YlyF720ulG3lLDn/Vjva86MljcRgnRdmnsn43FOmSNC5p4VdeER6b+Z?=
 =?us-ascii?Q?uvbL3F8NR0gseIOi5N1qMf8stDroxllwOyZCWrfArOuY4OuJONvGuvU4bthN?=
 =?us-ascii?Q?KoKjX/aEdbvUSSq/nMGwQJKMNcynqwbrDrZgDPtMUtS4+9wIhtX03oxZ6gvZ?=
 =?us-ascii?Q?VetaeOvtujoeRfhmE2YUb2DTa6s4hG+yg/qu4jsuZ//sxZsjuMFpWVnHLn6L?=
 =?us-ascii?Q?BWBTgHN2ZG8D1si/MEn1Hu8didm3tX5zN786nymMAwgpBiMyDIxqxLOBBsz7?=
 =?us-ascii?Q?9k8/lHSDKVtdCfvvM1YyBi6TN+Z5pYHgGziG5BZkcg1MZU+QMECkxZGNfdlV?=
 =?us-ascii?Q?jznJjHRkdgGzY5HgNZ0hSx5GCdmPl4xnWxgUJTGsyqjKFXGVRnFcXm2d8g7g?=
 =?us-ascii?Q?V4qCCKkMg7ctQf61NJAybqPL4t8lr4XhwMvMH3kefsJshlwSqdEK6tz8Uikx?=
 =?us-ascii?Q?fNlzpb4X7FxWVncQgphGN5mCNyNERlw8sBhl3ES2ONLdRxFZXN08+j0PCO5E?=
 =?us-ascii?Q?zBaspVpM0GCzmUb34y/6vkApZI5m8YXkOUS500ZFfUOUwmHMe1VsiY4Xlgp0?=
 =?us-ascii?Q?DJSp9iXk0PRdehsTxYQZgYiCs8N1AED4vl683/DC1A2SU/DG7rSqhE4vP1+w?=
 =?us-ascii?Q?3uqqz6QyjGGm7LrIIxv9piceb6NSHEqKICKKLa55V85j0C/w+2cSjWVp9TdN?=
 =?us-ascii?Q?QDeS1JTnKql9ri2OvjxCPQIsoChKU10QuhWHDhhX7Lbtwqk0eNX/ONXKf6Yh?=
 =?us-ascii?Q?qJn6t39l4nnVYzLoR6TTHc1vQxTpTlB+NefywYeU2S8y02rCipgk5r6/qFrS?=
 =?us-ascii?Q?jpQ0ZNHVKi8r/DQTzhmQSXmCX9FYwGiZmC8aq3ugTlLD0Z6bUpkrsCkAFa4B?=
 =?us-ascii?Q?gwazdsY/RYPUdoyyDRxnGM/aufHwfovMogZKfo/Xq2dL/X+SEx9vcS/zDGKJ?=
 =?us-ascii?Q?bc2eWRwWHoIrY73ycI+A0Y4cVTClaX+jPp+rgY/G/Di/?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(14060799003)(376014)(35042699022)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EJc1BKnda3acohtGXkrEQtA7iEim8djsEp3SSG/iAuk3548gH7AfRyrThqBbTvpTXOKZbN+9J0wrI3fhM3DCglgyB0DRymv4o6VOALwrL+xl+9kpnGCpltEBJU563UFYeD3WbmXbVF7ajxlkjmS+2vZoVO48NENspGDOM60hO6hR0mZ0tvhYPgW89+Lf5or1wAr2s71d7v2etxJGLS61jsV+TDPB8LAA8ipbZV6gAEiLHPE/WfHFcXzoi+7r0a0FnI9cG012OkT76c4P6qHQGGQ2lwFr6TO2iy0rn3872QmRmg5OzG89tekQKt4HGblkXfvAJtrZu3yeufB5TDmhHkDVfaoxhRDOpbVZieIiKpBKw6RM4IHR+MRdts1DqVoXyqB9h6ByCukpCsT/iy2VNzxEL+Lre+jamEOUiU1pNQWTTs65lpi8audTxGtpzNQX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 08:09:19.7136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5a329d-4738-41d7-9076-08de6a0e0621
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10633
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70924-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:dkim];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 57F1312B1F9
X-Rspamd-Action: no action

> On Fri, Feb 06, 2026 at 09:04:41AM +0000, Yeoreum Yun wrote:
> > Gentle ping in case of forgotten.
>
> Not forgotten but lower priority given that the merging window is about
> to open this Sunday. The LSUI series is now aimed at the next cycle.

Thanks for keeping this series in your mind :D

--
Sincerely,
Yeoreum Yun

