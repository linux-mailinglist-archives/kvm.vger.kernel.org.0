Return-Path: <kvm+bounces-69392-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PTaEBhSemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69392-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BADB6A79A0
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5280230FAA97
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF13F36F437;
	Wed, 28 Jan 2026 18:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D5wbHqEG";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D5wbHqEG"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013000.outbound.protection.outlook.com [52.101.83.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BEB2FE58D
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623633; cv=fail; b=VdESBulSkC4xcr63uHw7uRvoPBcD+uyPxPVnV8WbovtWLXgGjV1ynEtZEtNt46W3Sb6W9W+F+Yl+bFtafsXNkQJ7pkKaAzZ5TGwh4lV6MqOKVsUivsD9twH0y5taHP/9hb5iyDln3b8St9/N0GKyWxkf3UlU3rlgEyDZxazbEwU=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623633; c=relaxed/simple;
	bh=9ePeH7+mFDUjHUxykOa6qdi58t8N/m+ZoaqmonbzvuI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q9EeTtjSkOhSzHgScGr3zW5naOxNqSnANwT/VdL1inueRjf9pvQMgOSH7pni1KIt1JdMOUt2zFhrwTFm1CZ95+7HREMPfCQmHS4MAZKDtGHXcrSrkLOLDoBPcOKxx1Q5fCw+OUHo9KqPHoH6kniAazA3QXO7axZl64cJ5rhmS7g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D5wbHqEG; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D5wbHqEG; arc=fail smtp.client-ip=52.101.83.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=iCj+Dt0JvBUEKF43wvwBP70b0r8agUQlJJP6/B0gqaFT+9YxdO+9h/oUZkC7EFTiP7QWSsRytNzIpgf0bAuLaeCqyMDbRffdVg8YtBpth0GleyFkmwBTLLfWYIP3SwhpiyHGRtPcG+ZLRU/Jwi0s5kpBR4bKiPrBfbdwOjfOTDFTtRroGgRtOL4rjgpgE66pbmk+xvmKf7FdxfrNOKtGOoi4tPJPx7vrwoWX0kg6DEyPteKk8ILd0gHKxHZl/jtecK+8rreAtJ0J/kVBYkTOeeU/5VPFrm3qMsfEQGlhsxwyodhOaf2VpbVyy3qQTSM2gJz7AryqJmQFHjLXEhFRJw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJKjYoNbjqzAEW18yf6G57TKI3vDwjooqJM7tAhOr6w=;
 b=rrlPPqxwgQXPeFWg5JtA+sULzlji5MHJKynFz2OnTVP8h4Y5PhOYR45KyrDcyplzqKDiHaFHE8y/xMjvSsgKH8j5aEuX/jUN6ZEDP4SPwYK/ht9IKFElDhYGnuiUoueJnZviOjXSbYuzMzvdXXqvP8uv38l1+oXhM1Ly9t3GdBx5QfDGbGOI3W2/IEYaFvsOMYQLzhvCiz/7jIWSYj5KmFb9wR0BbkSOhLxx4pJoxo9fz4gOH34JzNCMV9jIww6OniDaL+rlt5OutEj9THYIFCA1+nn84gWPpANrTfkaLcBZdaP9137AiPHwIuo+U/u7cgv5vxL+ctJcYKJK0CSgiQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJKjYoNbjqzAEW18yf6G57TKI3vDwjooqJM7tAhOr6w=;
 b=D5wbHqEGsVTU4R8UxuXmlZ2Jgra4rHnRAKrJLKMcksJVFHyeRtST/HUzbmibDEK/aNz4INWSCAUyNUK/zf0Lmc2pfckj07V4OFC50oAcbEY2bLEM4cDWwaK2yrrHDSx3pvGlweMjFgGu6agLlTOo3yz6siE7Mn6KceLUFLXKCcE=
Received: from AM0PR10CA0023.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::33)
 by VI0PR08MB10825.eurprd08.prod.outlook.com (2603:10a6:800:201::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:07:04 +0000
Received: from AMS1EPF0000003F.eurprd04.prod.outlook.com
 (2603:10a6:208:17c:cafe::dd) by AM0PR10CA0023.outlook.office365.com
 (2603:10a6:208:17c::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:07:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF0000003F.mail.protection.outlook.com (10.167.16.36) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:07:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=khfahRQsGLkYbn47IJIspL9XQr24gEmjO6RNJHOMxwyWj2KysNR7pEt5ukrG+tptkVggGH9KXR/paNJbFhLxBgwJX/fDwZg7LDIk2H1SOiIgcybMwIuocdYhE7f7c+I3KENkIwQt4jzDwLEK+9BUwYdop2zN4+tHlUQ43DovosKpWzx8x7XN/fmD91K5fck6vJRI6SxpIeSfalOGZ+Fo2GYyU6+es47GFuMYqDE0Mt5DwpYaDFFCYEIjnrbQ0T0NL3P34Nkhh81TIMgWGbJAbBR6xqTJ+bE4ZpL0QWJsZBvveNH5g7/sQ4oQJahY0egCQIYlBPr4QdsHw2V0ijO4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJKjYoNbjqzAEW18yf6G57TKI3vDwjooqJM7tAhOr6w=;
 b=zTCbmewtU2u7I0ylcdJQS050dggNo7jpHGGWSCDSN7zwf8Uh0IwT3cGIccx/dEukxwwehqraISvWcY14nt8jdxdCHsoZxII0AqU4o9y3RpO3KOhoV+3a7uptE2AIhE3ORhXHuLq/I4u6I4/WCptIYkP4/CwjUzHr9QB2otO+++txspRykcbtQTIg1ys+qsmvAH78ZV8j5d0L7fjGfngAyOdAUewEGw/Y226sJ6kDvJ0fVUqvO2CpsP5XlZj0a8Fcwb6Kzro/+9hVlVYi2O2ihAtoX+QOGN8mzRYS2EuXEKzThM/jZCSfBdKphlAThM07niqI1ko3lM8qr/MEeash6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJKjYoNbjqzAEW18yf6G57TKI3vDwjooqJM7tAhOr6w=;
 b=D5wbHqEGsVTU4R8UxuXmlZ2Jgra4rHnRAKrJLKMcksJVFHyeRtST/HUzbmibDEK/aNz4INWSCAUyNUK/zf0Lmc2pfckj07V4OFC50oAcbEY2bLEM4cDWwaK2yrrHDSx3pvGlweMjFgGu6agLlTOo3yz6siE7Mn6KceLUFLXKCcE=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:06:01 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:06:01 +0000
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
Subject: [PATCH v4 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Topic: [PATCH v4 26/36] KVM: arm64: gic-v5: Bump arch timer for GICv5
Thread-Index: AQHckIDCjfzRdIXnPkqJI2i9B6m/XQ==
Date: Wed, 28 Jan 2026 18:06:00 +0000
Message-ID: <20260128175919.3828384-27-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|AMS1EPF0000003F:EE_|VI0PR08MB10825:EE_
X-MS-Office365-Filtering-Correlation-Id: 916ea36d-9448-4d41-a906-08de5e980a80
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?uM1pvaw+cHJqyAX1eDtHkS84BAlFNyFQDIPE/SNCwtBWiSsdJ5k4mmrxgH?=
 =?iso-8859-1?Q?pHP9e93XIZ04ybCu+qGa8J8RtgILU0zf/Tw1Kbtr65wYbNNbbI/NI4DOBS?=
 =?iso-8859-1?Q?mi9vpkax+wO9JVB13eD5SoztwLI1fufVqIjXlUYfLKgQcvOGz7dt2lK7yt?=
 =?iso-8859-1?Q?o5k3rNzD9T1TYxKaZM+vq9rapiG8kkwjXpwGoO1EMlLjuLSSfUiVCEcJaL?=
 =?iso-8859-1?Q?5f112dNHdcZ7tvy8+yFFPzvQvd0BTNeVZ20m0aSLKIUzA1k7bAjK5JCnC3?=
 =?iso-8859-1?Q?QyisE1qU04JGZ9Xp9wHOqX1Wo9rTn3txyr0mx8XbetUU9xFVT40TaVxPoO?=
 =?iso-8859-1?Q?2vHI7U0rzeCVQ3KLpdMgTks4oV5mjFMhPDn/CIVb/xiHm/rTOCpWzhFW4x?=
 =?iso-8859-1?Q?lyDADp5H8G2DyMUOJu4M7UmNKstV4UD4ZgJYRvPqdL4Yuqh6gkNJR7r1DV?=
 =?iso-8859-1?Q?MS8UxScJPWBJ2gBYSpkBoTfl1MFCs8goebxVgPqNGo4y08g/0Z1iFP2WTv?=
 =?iso-8859-1?Q?CzsWnWQB0uLm97lWedCSt19Ii2wHP1W24EMBSSE7PIIXl/HXRcCb6pp5JT?=
 =?iso-8859-1?Q?mwiJUapbIVa/CCRr43gmCUhNPl1FYDFIDzKRIHByFUMXtqXo13BERY70dU?=
 =?iso-8859-1?Q?28RXJDX+ZtMuBBj0BrgZPpnu56QEEDJUltadW+ihg6WTDtyCAG6W50imJy?=
 =?iso-8859-1?Q?OSJIbVgxSV9cn//h14g82y0qUXSKK3L+8jsSq0Iu+qpC0PREX58BPYIZT4?=
 =?iso-8859-1?Q?Az8pUiePYtKGl2F33HmcNuwKyUoiEC6CaQRKAc2bbbEQGIzPvnZ5NHUISI?=
 =?iso-8859-1?Q?yHgfjk6yHbCP75Zs+xlzAVlE57ZDDx/KLIeBZDQeLTL9VDh551IqmvutN/?=
 =?iso-8859-1?Q?zCcMc73+aXGNnbknPt54FZW7cfBZtR/Tl5ZZKJnn0pDoHp698Xe5fbHbvi?=
 =?iso-8859-1?Q?ivC8b9LUZOYXfOcO4hf6asLloatGs0GyolazYZNDddJIx2yuH9w7+UVmpM?=
 =?iso-8859-1?Q?ZAnYPFKOYJTnycLN7+4kApsgS/LP+Wb8ZfphIpE+GSPE4QrYSoGswowHkm?=
 =?iso-8859-1?Q?opk6PFcUziAoOgqnSK1yDTf5s4Rzj1dsF4nR+tOQHZlvMW9BBtF45p1bUR?=
 =?iso-8859-1?Q?Is7fKYnQGYQ99aBKstpNioZimPSLKjnqxz95i7l9cRqyB9LxIwPL2D/ZcC?=
 =?iso-8859-1?Q?OtDfLlLMpmMu/uZV8McHVcURnzVfQTwI2t/NC+mUlRHvqsc+T2RLAxmXkV?=
 =?iso-8859-1?Q?BKOhDNlm9gz3MdagEjyS1G4Ya07B/0OYr77i3Qxfy04KTe/hEjXqoMUvFT?=
 =?iso-8859-1?Q?rs4u5NBMtKERQGQzFoEl2qwhkAyU7vEdr+rCvn7/tQOQKg/2KzYck8YdzR?=
 =?iso-8859-1?Q?TAj/2Dp6S314PLnm8hu4C741+hqXHNiWnhLWsaKFMA4LqBlDUCWo77Ja5T?=
 =?iso-8859-1?Q?atP1WbXWTpzZRwgY7mI/VpEfMggDa6JMWL3wmr0kxGWfHb+L6ZhdjqHkx+?=
 =?iso-8859-1?Q?gb+jGaVD83tXRAeg3EFwAfvAYYHRF4PwujJSLD8zV2I7vgQgMrenbteqFc?=
 =?iso-8859-1?Q?2eeFkt0EFhIvTDXxwoBqqmKaD4Q1xun4zlcNjzdmjt0EGaPwCgQBtZzBID?=
 =?iso-8859-1?Q?sGcCLpuY8lBJNPWfnNX9qcL+FTB5jNJADBkqUFbLxtmoBB3YAXE8+5QvE9?=
 =?iso-8859-1?Q?PhtAQfureFSeROY2Lkk=3D?=
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
 AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	93ebe99d-77ba-438e-fbd9-08de5e97e51c
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|1800799024|82310400026|376014|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?y5pfMikYVpPRPoOCgAB3NvsufRqwZWKeS8Z3iNMetuB+QYhiwTd/OaGlgx?=
 =?iso-8859-1?Q?flFY8tGaqxLGgXy2AQqRdQ7T1POTjUoOnd37zcJqZX7u9O1o6QHJN527kR?=
 =?iso-8859-1?Q?yI/I/FCXEmt/wAMdNikXjEO01S8ih4jp5plqlx4MhRjUKxouoJ4Ezl3RJe?=
 =?iso-8859-1?Q?G/y/I/DH7wW7sS8hjJA2Ox1twFGVcCm9vGzi+S5uCfXp0Y21CHBE3yUKxw?=
 =?iso-8859-1?Q?xRu80EaCP9Srj5gra0L3+ZjUod1++0ay2ks7BrS8nVn/C8tWZJ4CQ1tr8/?=
 =?iso-8859-1?Q?w+YUyW14/HyAj22SYtI7+BhvmUEBnLExhRKQYV0HoOAsR0Aq7l8aQkThzy?=
 =?iso-8859-1?Q?a5fr7XkhGbQ8qH6vZNWfal6IC725mtSF2r2Q0mfMtTUJAozS25VbEq26AW?=
 =?iso-8859-1?Q?Uit9UJA8WV67DwEFaBw3z0IX1jdLr5/IOP1O+jt/5X7diXHoGkrkADubmX?=
 =?iso-8859-1?Q?9q1UXkR6HwSSkOtUxPBFLk/EHbqLl9SvHSIHkgZ63b7o/dwNGRs/4p7zk3?=
 =?iso-8859-1?Q?KGktXh4aekHvYX6C0xI4WkTMduh/xj0/Q1WyE86I5nuEvD5+HSH9/ezMVq?=
 =?iso-8859-1?Q?0LgONAc1zORwli7EctzhGfy2k6xwi+VDgoYPTLWiiJ0YwzDNpZRjQXUwBr?=
 =?iso-8859-1?Q?eGLwvoESd3jdmzBTndDvychtY/xWbaHtW2zHLvo+d42wXLGTs5pnQEF6D4?=
 =?iso-8859-1?Q?CVYzdiaojQ4BOBvQTzwWja8d/BQ0XucRPn5BkW/RqUS7D4HoOjyXfilgIu?=
 =?iso-8859-1?Q?iF3c21uX8rOChJGpdZdp/MWN9byfGCjE4q6PVJjWYP4h4ajS/xLiKZ9Z5t?=
 =?iso-8859-1?Q?APIn8fWlzOdEiNJapziRPDQq6p/cl+FXr0RlxGKzqHVUiopp6fjMY7zhu7?=
 =?iso-8859-1?Q?vTya4MfeaYbzhUvBlVHiiaZfKrWR8zZKoSZ9fLCkNI64UPZrq81lOWzHv8?=
 =?iso-8859-1?Q?xh3Thvx9uuIAj01PDY23+GtEwzR5+TUoTlOONPULqKPWbJV2mmaP8IqYtV?=
 =?iso-8859-1?Q?hM6dE3YSfyOhaSDZd0zhtwyCdqoRXLkV9EAgDaCc0gjdu9/TyWg9dSXTUO?=
 =?iso-8859-1?Q?wL1Ig6QzaUWId6E8Ut0Vhh237RsEu702bOH1F8SsMHckqEhQ6RNFIlXL8m?=
 =?iso-8859-1?Q?9Qb/rMZByrlDr+TUar0n9zrdXEihVjv0sTrl9JaCnUw9gVHI2SRuhYDu+Q?=
 =?iso-8859-1?Q?dQekynhN8sZODD9Mjacm9WYu6xLnOXS0SEwzTpNxSSFxwTrhM92kLdwS5m?=
 =?iso-8859-1?Q?zJ1nVwkaVSTw6J9Wul1sMZ/W7FygMUGSfwfLftMthnnlVMezy7ohvzWH2D?=
 =?iso-8859-1?Q?YGwYqyF7FdgUc9s78nTS6P7NVJ43k0wvM9Uj1qE1zDi9lqBiVBFry4GGYr?=
 =?iso-8859-1?Q?QV7ImHg+C0M+OK06s2SFN5WO02YM6LLL6ajB5mlRlLjta0v528gZWUeKV6?=
 =?iso-8859-1?Q?35+B6XKFKC6t36T/yczLj4i494kDVbooO8ShCxxxmBug1jDjlhM/M0RCFZ?=
 =?iso-8859-1?Q?dCXqn+BzYRZ4pCjlfnppECyIfNHNhXwTcMYbzYPI+mIEv9BIK3EaFNvbE1?=
 =?iso-8859-1?Q?FO87YqeeI5A1kpBfIu8vXyGFj8tqcaYhjCZVD65hzK8GkFOF96qhjCtWQO?=
 =?iso-8859-1?Q?8k/Zc6INJt6jXFGS3vkgYaPM3I7uJS0HASMwl7YBKdWJDAxiYo8UHwHpfd?=
 =?iso-8859-1?Q?zGW6BK2aS7gIe7t2N6TCyPwZZJxB7cic5NygcSRBH9yF9xqkPhnPACy8P7?=
 =?iso-8859-1?Q?mviw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(1800799024)(82310400026)(376014)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:07:03.6500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 916ea36d-9448-4d41-a906-08de5e980a80
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000003F.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10825
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69392-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: BADB6A79A0
X-Rspamd-Action: no action

Now that GICv5 has arrived, the arch timer requires some TLC to
address some of the key differences introduced with GICv5.

For PPIs on GICv5, the queue_irq_unlock irq_op is used as AP lists are
not required at all for GICv5. The arch timer also introduces an
irq_op - get_input_level. Extend the arch-timer-provided irq_ops to
include the PPI op for vgic_v5 guests.

When possible, DVI (Direct Virtual Interrupt) is set for PPIs when
using a vgic_v5, which directly inject the pending state into the
guest. This means that the host never sees the interrupt for the guest
for these interrupts. This has three impacts.

* First of all, the kvm_cpu_has_pending_timer check is updated to
  explicitly check if the timers are expected to fire.

* Secondly, for mapped timers (which use DVI) they must be masked on
  the host prior to entering a GICv5 guest, and unmasked on the return
  path. This is handled in set_timer_irq_phys_masked.

* Thirdly, it makes zero sense to attempt to inject state for a DVI'd
  interrupt. Track which timers are direct, and skip the call to
  kvm_vgic_inject_irq() for these.

The final, but rather important, change is that the architected PPIs
for the timers are made mandatory for a GICv5 guest. Attempts to set
them to anything else are actively rejected. Once a vgic_v5 is
initialised, the arch timer PPIs are also explicitly reinitialised to
ensure the correct GICv5-compatible PPIs are used - this also adds in
the GICv5 PPI type to the intid.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arch_timer.c     | 116 +++++++++++++++++++++++++-------
 arch/arm64/kvm/vgic/vgic-init.c |   9 +++
 arch/arm64/kvm/vgic/vgic-v5.c   |   4 +-
 include/kvm/arm_arch_timer.h    |  11 ++-
 include/kvm/arm_vgic.h          |   2 +
 5 files changed, 114 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6f033f664421..ac3825e7eb58 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -56,6 +56,11 @@ static struct irq_ops arch_timer_irq_ops =3D {
 	.get_input_level =3D kvm_arch_timer_get_input_level,
 };
=20
+static struct irq_ops arch_timer_irq_ops_vgic_v5 =3D {
+	.get_input_level =3D kvm_arch_timer_get_input_level,
+	.queue_irq_unlock =3D vgic_v5_ppi_queue_irq_unlock,
+};
+
 static int nr_timers(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu_has_nv(vcpu))
@@ -177,6 +182,10 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer=
_map *map)
 		map->emul_ptimer =3D vcpu_ptimer(vcpu);
 	}
=20
+	map->direct_vtimer->direct =3D true;
+	if (map->direct_ptimer)
+		map->direct_ptimer->direct =3D true;
+
 	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
 }
=20
@@ -396,7 +405,11 @@ static bool kvm_timer_should_fire(struct arch_timer_co=
ntext *timer_ctx)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0;
+	struct arch_timer_context *vtimer =3D vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer =3D vcpu_ptimer(vcpu);
+
+	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
+	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) =3D=3D 0);
 }
=20
 /*
@@ -447,6 +460,10 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu=
, bool new_level,
 	if (userspace_irqchip(vcpu->kvm))
 		return;
=20
+	/* Skip injecting on GICv5 for directly injected (DVI'd) timers */
+	if (vgic_is_v5(vcpu->kvm) && timer_ctx->direct)
+		return;
+
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
 			    timer_ctx->irq.level,
@@ -657,6 +674,24 @@ static inline void set_timer_irq_phys_active(struct ar=
ch_timer_context *ctx, boo
 	WARN_ON(r);
 }
=20
+/*
+ * On GICv5 we use DVI for the arch timer PPIs. This is restored later
+ * on as part of vgic_load. Therefore, in order to avoid the guest's
+ * interrupt making it to the host we mask it before entering the
+ * guest and unmask it again when we return.
+ */
+static inline void set_timer_irq_phys_masked(struct arch_timer_context *ct=
x, bool masked)
+{
+	if (masked) {
+		disable_percpu_irq(ctx->host_timer_irq);
+	} else {
+		if (ctx->host_timer_irq =3D=3D host_vtimer_irq)
+			enable_percpu_irq(ctx->host_timer_irq, host_vtimer_irq_flags);
+		else
+			enable_percpu_irq(ctx->host_timer_irq, host_ptimer_irq_flags);
+	}
+}
+
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu =3D timer_context_to_vcpu(ctx);
@@ -675,7 +710,10 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_=
context *ctx)
=20
 	phys_active |=3D ctx->irq.level;
=20
-	set_timer_irq_phys_active(ctx, phys_active);
+	if (!vgic_is_v5(vcpu->kvm))
+		set_timer_irq_phys_active(ctx, phys_active);
+	else
+		set_timer_irq_phys_masked(ctx, true);
 }
=20
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
@@ -719,10 +757,14 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 					      struct timer_map *map)
 {
 	int hw, ret;
+	struct irq_ops *ops;
=20
 	if (!irqchip_in_kernel(vcpu->kvm))
 		return;
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	/*
 	 * We only ever unmap the vtimer irq on a VHE system that runs nested
 	 * virtualization, in which case we have both a valid emul_vtimer,
@@ -741,12 +783,12 @@ static void kvm_timer_vcpu_load_nested_switch(struct =
kvm_vcpu *vcpu,
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_vtimer->host_timer_irq,
 					    timer_irq(map->direct_vtimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map->direct_ptimer->host_timer_irq,
 					    timer_irq(map->direct_ptimer),
-					    &arch_timer_irq_ops);
+					    ops);
 		WARN_ON_ONCE(ret);
 	}
 }
@@ -864,7 +906,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	get_timer_map(vcpu, &map);
=20
 	if (static_branch_likely(&has_gic_active_state)) {
-		if (vcpu_has_nv(vcpu))
+		/* We don't do NV on GICv5, yet */
+		if (vcpu_has_nv(vcpu) && !vgic_is_v5(vcpu->kvm))
 			kvm_timer_vcpu_load_nested_switch(vcpu, &map);
=20
 		kvm_timer_vcpu_load_gic(map.direct_vtimer);
@@ -934,6 +977,14 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
=20
 	if (kvm_vcpu_is_blocking(vcpu))
 		kvm_timer_blocking(vcpu);
+
+	/* Unmask again on GICV5 */
+	if (vgic_is_v5(vcpu->kvm)) {
+		set_timer_irq_phys_masked(map.direct_vtimer, false);
+
+		if (map.direct_ptimer)
+			set_timer_irq_phys_masked(map.direct_ptimer, false);
+	}
 }
=20
 void kvm_timer_sync_nested(struct kvm_vcpu *vcpu)
@@ -1092,10 +1143,19 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 		      HRTIMER_MODE_ABS_HARD);
 }
=20
+/*
+ * This is always called during kvm_arch_init_vm, but will also be
+ * called from kvm_vgic_create if we have a vGICv5.
+ */
 void kvm_timer_init_vm(struct kvm *kvm)
 {
+	/*
+	 * Set up the default PPIs - note that we adjust them based on
+	 * the model of the GIC as GICv5 uses a different way to
+	 * describing interrupts.
+	 */
 	for (int i =3D 0; i < NR_KVM_TIMERS; i++)
-		kvm->arch.timer_data.ppi[i] =3D default_ppi[i];
+		kvm->arch.timer_data.ppi[i] =3D get_vgic_ppi(kvm, default_ppi[i]);
 }
=20
 void kvm_timer_cpu_up(void)
@@ -1347,6 +1407,7 @@ static int kvm_irq_init(struct arch_timer_kvm_info *i=
nfo)
 		}
=20
 		arch_timer_irq_ops.flags |=3D VGIC_IRQ_SW_RESAMPLE;
+		arch_timer_irq_ops_vgic_v5.flags |=3D VGIC_IRQ_SW_RESAMPLE;
 		WARN_ON(irq_domain_push_irq(domain, host_vtimer_irq,
 					    (void *)TIMER_VTIMER));
 	}
@@ -1497,10 +1558,13 @@ static bool timer_irqs_are_valid(struct kvm_vcpu *v=
cpu)
 			break;
=20
 		/*
-		 * We know by construction that we only have PPIs, so
-		 * all values are less than 32.
+		 * We know by construction that we only have PPIs, so all values
+		 * are less than 32 for non-GICv5 VGICs. On GICv5, they are
+		 * architecturally defined to be under 32 too. However, we mask
+		 * off most of the bits as we might be presented with a GICv5
+		 * style PPI where the type is encoded in the top-bits.
 		 */
-		ppis |=3D BIT(irq);
+		ppis |=3D BIT(irq & 0x1f);
 	}
=20
 	valid =3D hweight32(ppis) =3D=3D nr_timers(vcpu);
@@ -1538,6 +1602,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer =3D vcpu_timer(vcpu);
 	struct timer_map map;
+	struct irq_ops *ops;
 	int ret;
=20
 	if (timer->enabled)
@@ -1556,22 +1621,20 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
=20
+	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
+				      &arch_timer_irq_ops;
+
 	get_timer_map(vcpu, &map);
=20
-	ret =3D kvm_vgic_map_phys_irq(vcpu,
-				    map.direct_vtimer->host_timer_irq,
-				    timer_irq(map.direct_vtimer),
-				    &arch_timer_irq_ops);
+	ret =3D kvm_vgic_map_phys_irq(vcpu, map.direct_vtimer->host_timer_irq,
+				    timer_irq(map.direct_vtimer), ops);
 	if (ret)
 		return ret;
=20
-	if (map.direct_ptimer) {
+	if (map.direct_ptimer)
 		ret =3D kvm_vgic_map_phys_irq(vcpu,
 					    map.direct_ptimer->host_timer_irq,
-					    timer_irq(map.direct_ptimer),
-					    &arch_timer_irq_ops);
-	}
-
+					    timer_irq(map.direct_ptimer), ops);
 	if (ret)
 		return ret;
=20
@@ -1601,12 +1664,11 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 	if (!(irq_is_ppi(vcpu->kvm, irq)))
 		return -EINVAL;
=20
-	mutex_lock(&vcpu->kvm->arch.config_lock);
+	guard(mutex)(&vcpu->kvm->arch.config_lock);
=20
 	if (test_bit(KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE,
 		     &vcpu->kvm->arch.flags)) {
-		ret =3D -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
=20
 	switch (attr->attr) {
@@ -1623,10 +1685,16 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, s=
truct kvm_device_attr *attr)
 		idx =3D TIMER_HPTIMER;
 		break;
 	default:
-		ret =3D -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
=20
+	/*
+	 * The PPIs for the Arch Timers are architecturally defined for
+	 * GICv5. Reject anything that changes them from the specified value.
+	 */
+	if (vgic_is_v5(vcpu->kvm) && vcpu->kvm->arch.timer_data.ppi[idx] !=3D irq=
)
+		return -EINVAL;
+
 	/*
 	 * We cannot validate the IRQ unicity before we run, so take it at
 	 * face value. The verdict will be given on first vcpu run, for each
@@ -1634,8 +1702,6 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, str=
uct kvm_device_attr *attr)
 	 */
 	vcpu->kvm->arch.timer_data.ppi[idx] =3D irq;
=20
-out:
-	mutex_unlock(&vcpu->kvm->arch.config_lock);
 	return ret;
 }
=20
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 45fe3c582d0d..6e887fb6d795 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -177,6 +177,15 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
 	} else {
 		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+		/*
+		 * We now know that we have a GICv5. The Arch Timer PPI
+		 * interrupts may have been initialised at this stage, but will
+		 * have done so assuming that we have an older GIC, meaning that
+		 * the IntIDs won't be correct. We init them again, and this
+		 * time they will be correct.
+		 */
+		kvm_timer_init_vm(kvm);
 	}
=20
 	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4a164ce0f4e2..1ab65cd7133a 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -221,8 +221,8 @@ static u32 vgic_v5_get_effective_priority_mask(struct k=
vm_vcpu *vcpu)
  * need the PPIs to be queued on a per-VCPU AP list. Therefore, sanity che=
ck the
  * state, unlock, and return.
  */
-static bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq =
*irq,
-					 unsigned long flags)
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags)
 	__releases(&irq->irq_lock)
 {
 	struct kvm_vcpu *vcpu;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 7310841f4512..a7754e0a2ef4 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -10,6 +10,8 @@
 #include <linux/clocksource.h>
 #include <linux/hrtimer.h>
=20
+#include <linux/irqchip/arm-gic-v5.h>
+
 enum kvm_arch_timers {
 	TIMER_PTIMER,
 	TIMER_VTIMER,
@@ -47,7 +49,7 @@ struct arch_timer_vm_data {
 	u64	poffset;
=20
 	/* The PPI for each timer, global to the VM */
-	u8	ppi[NR_KVM_TIMERS];
+	u32	ppi[NR_KVM_TIMERS];
 };
=20
 struct arch_timer_context {
@@ -74,6 +76,9 @@ struct arch_timer_context {
=20
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
+
+	/* Is this a direct timer? */
+	bool				direct;
 };
=20
 struct timer_map {
@@ -130,6 +135,10 @@ void kvm_timer_init_vhe(void);
 #define timer_vm_data(ctx)		(&(timer_context_to_vcpu(ctx)->kvm->arch.timer=
_data))
 #define timer_irq(ctx)			(timer_vm_data(ctx)->ppi[arch_timer_ctx_index(ctx=
)])
=20
+#define get_vgic_ppi(k, i) (((k)->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_A=
RM_VGIC_V5) ? \
+			    (i) : (FIELD_PREP(GICV5_HWIRQ_ID, i) |	\
+				   FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI)))
+
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
 			      enum kvm_arch_timer_regs treg);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index eb0f2f6888c7..3cdefc424fb0 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -588,6 +588,8 @@ void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
 int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
+				  unsigned long flags);
=20
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
--=20
2.34.1

