Return-Path: <kvm+bounces-69397-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNbLGd1Remnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69397-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 44708A7950
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BAEF43037011
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E047372B34;
	Wed, 28 Jan 2026 18:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kur9LVS8";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kur9LVS8"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013066.outbound.protection.outlook.com [52.101.83.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E21F34F468
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623710; cv=fail; b=lyrdCPIYYL7LimdxWLZv+Ifx4vz4HYIVoB2HpNc5KvbBTAUGRbLorAtijxQDMzUzOVOnukR5PLdXnADhfoN+VM8alkv7D7bZ4AVwW95odJdSLOk6u+Eu2iC+5Sujrdh+mULevi/ChcdBThwFpPiY00CYa8+6zRgarHTgCN4diuI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623710; c=relaxed/simple;
	bh=4M+5Dv1h9RBs//B7yAHG/J6ASsp/Zr7GIhPJSUBBGas=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LalBFYAzCL51CMhN/JD4jOHQRGVshxs3Y8WSm0m4z92AyRCQIgSv9o68M2KcmWzqQfhAIn0ClC1/DCDETLAoNnqNsCoREtHvF+SqVCI6Qv5ob84lAPaIHxK7MypkNh25NFQuvgkr4NraT0IfwmXLtRuxG6rhMOtft/UllZzzBgw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kur9LVS8; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kur9LVS8; arc=fail smtp.client-ip=52.101.83.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=C3nPyA8OPIGmiRS4Mef/77bxncDm8cURCQWHu3euMQi9vTNloowNNu4bo7GEo44pUK3RChD/DI+6Vxt6cskMef6mgxE6TSfVTf56jqY1gw6i3MSofUZFQp0NomrZViihTbRkoWuJzNmn4ZGdl/ElDjB6e2l7RfDr5vI6tcypBEVO6cL96krLHXBfpks5dP8/2LhaW8V8DOcWQHvwEjcQ78FtO1l86scxi6MYOo1MZEr6POa1iiLalw7CZBcR8K4lcmY/v6jbc/uaoYlCV4Ipr4qFzYQJYLFe0wf92s46uqy1Fp0niaTUMFjkDM1/KQ6/wT69bzQEs77kjDErvyws0A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhZa+6Up8OPeboUHqShiejGD4D1cU4fptTEzLtcZc6M=;
 b=kg9xS0bi12dM8Cpd2U4nYWH1LYjD73VFbGtPsQ8lWRa6vdnlwOHI6LFbr9sFkfmmaRo3PPoiY2yuoE6IxnA1h55/6NtQi2+Q6061bER7Vy+qjLTddp+tELu5a+5UtSTCgMXozVcMt+pNRGt0qMDc7Yvz5+tUDEeWVPyv3dtq00VVr8q8Rx/2YaurdjG+R7Y8rk3OBq7im/kRcmEpeyKNwFJWuitPSZeYExhihyYwETIkQ7P8GuoarZo4oW9Y+acJ2YDT50fKKWXRtCwIwJrELNKb/ScSg4jM3EigM12RBO6n7uqCsa0PSUtE9iHzL0HoWWr9Ph7CHRZSkBNUPV6ECQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhZa+6Up8OPeboUHqShiejGD4D1cU4fptTEzLtcZc6M=;
 b=kur9LVS8svRReCpvVJkETZPQRrTiqKx66Xz+et03cLlL4gN8iuzGW1fMzJlAt5tCHQQdSdkbQGkMoQx8Eh3q1L7k4wiEcQsROeHUwoFA/l2XHnh33nDTX3QzLmvon1N73iXEf2p33mbvvadM7xE+wArVuft+pExzX0knzMyiWT0=
Received: from AM8P251CA0002.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::7)
 by DU0PR08MB8205.eurprd08.prod.outlook.com (2603:10a6:10:3b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:08:22 +0000
Received: from AMS1EPF00000040.eurprd04.prod.outlook.com
 (2603:10a6:20b:21b:cafe::dd) by AM8P251CA0002.outlook.office365.com
 (2603:10a6:20b:21b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000040.mail.protection.outlook.com (10.167.16.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:08:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmFURLWxhg6O/VHPP5p9WRw/6m196qjtjndH5pEtq2zb+Szww4t+m8gjIv20Xt+OhDGUT89YEXN3D02x7h4uAmwKigjWkjGrODAKi7qEfXY9kh+nseURMX7OXav5SUccxR5aHV/qeZmGksDm87j/1T7fZ1ZXDLVlRMlU+1d6RaZpXWDFtGjPPNKn7/I+fkH9PE7W+hAF2JMQ4PrZr1bh5L5WGcNHNCI4HEPfiuJHN4ag+yvsYcTkfMRsbw6QKQzS6k3Dj3KoI+Vj1ySgKhyO0tagw6FUklKdhIV4KEfM6xSm8Rdg95Z/vHWDV/4HaCm3/gkeo+yVzpHCv8rwcGy83g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhZa+6Up8OPeboUHqShiejGD4D1cU4fptTEzLtcZc6M=;
 b=BBCNiKje95fuNyTJB60o1Q1HlViYuHDlmAd7l0+EG6sVyLV6lXde7MhJUbL6e032GCY2Wsw4OxJlCqrCcVU1fZdPYkNrwK33ukWy7DzsryL/VXWeBdMzhXxa2nW/ZQv/G4ay1e8Mo10x8Q/QGNnvrliCkjuI28MTqNQZoroAR/I2aprg/9HFf0WPY/X1sY9sKHQk150ZTkgT+Cq74yreeTDToaVtRpdZxKsy5Z6fCoY2hjOTptWDMoa4NMXHpnKgJfPDuDycz3XTw7jB/Nr+dbE8qAH7lrYIvq1Lx2+M+K9uJYCJ4ioJFQ+e+jMCQqE42PIMFd5BdCINPXhA2KUHOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhZa+6Up8OPeboUHqShiejGD4D1cU4fptTEzLtcZc6M=;
 b=kur9LVS8svRReCpvVJkETZPQRrTiqKx66Xz+et03cLlL4gN8iuzGW1fMzJlAt5tCHQQdSdkbQGkMoQx8Eh3q1L7k4wiEcQsROeHUwoFA/l2XHnh33nDTX3QzLmvon1N73iXEf2p33mbvvadM7xE+wArVuft+pExzX0knzMyiWT0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:07:18 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:07:18 +0000
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
Subject: [PATCH v4 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
Thread-Topic: [PATCH v4 31/36] KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on
 boot
Thread-Index: AQHckIDwayO+sExB30G4NrQVLTpoEw==
Date: Wed, 28 Jan 2026 18:07:18 +0000
Message-ID: <20260128175919.3828384-32-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|AMS1EPF00000040:EE_|DU0PR08MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c751065-9c83-4baf-61b6-08de5e98387e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?8/9OxmVooIiNA7IK5CexLsPyYEYo8SkMPFjxW1ZJvptMjwFCzm/mYSABs1?=
 =?iso-8859-1?Q?++tbFD1ijP/QAq75K3czUo0TRjrJKhEumXsHXSgvVtjrS9CwaK0oYOZgwN?=
 =?iso-8859-1?Q?Vg8IvpjsJ5ePx370DcYU8KRwNXFdlH9JHqGecINvEd7oZaCUxgrwLg8KaK?=
 =?iso-8859-1?Q?uF/6FPpn0+aCMd6IerEtNzx/xuX6V53gk06RK9KqE5XvS1wQHOLQk8Wo4F?=
 =?iso-8859-1?Q?A3hCkQ/k53VTOg6sx8YfM1lenGPvpss6HlaMC4pz1L0I0xYimHV9W/UW+l?=
 =?iso-8859-1?Q?pZ1IDFqhy74KpV8m0aWiiaSn8G9BoKM4uATD4gMtmBAaZaqvNe1FYfgah0?=
 =?iso-8859-1?Q?GQChPNddGD/jmCaykPt6F7e683+JxdwHCEJWci72dS6ZFJdnvHHDn021Jl?=
 =?iso-8859-1?Q?/kIgt6efOx9BfgRAW5TVr1vW4dQ03YecgS+LxXFx3uDEYwmj/EhLDdkNy6?=
 =?iso-8859-1?Q?YDQjMAsxtM7bCLaQ5Jda6fEfpqq8S+n++N+Jvvgshv00pyLi5zjM53/CIn?=
 =?iso-8859-1?Q?tLcAA3MGMFR2Bfq8bUd3MSojgik0uHzJSQNSWAkguG3xqUXqR8jkkxCvch?=
 =?iso-8859-1?Q?xp6xW93rWGoIXa8MMt02s67vNa9BYarzDm7QTFM5K5Kjw6sa8vPtiFdwVn?=
 =?iso-8859-1?Q?ihVnVcvntUexWk7VVqjyf639by1YTds5GtfL8DbLv90mPYZKNdM/fBWJsz?=
 =?iso-8859-1?Q?VLcmoCCjpxmaaIUVAReftclwm9LwJE4Mwvb57gv1uOpuOjOMA1TPgCGsNR?=
 =?iso-8859-1?Q?haeBP6FLCZ27sUMgWeBEnVrEOiJqIF1+T0nUTRaeiYin0B56JLpqpx81oE?=
 =?iso-8859-1?Q?OXIdTTGCtxN2S9EYrl1bglxy1aVYw2VyBx2MX+dlgqxQAgsOsQYaOPFBRC?=
 =?iso-8859-1?Q?X1lkuR+V6UMczbvTdYWDfdHUJOqQXbw3NssBkpQWBOfDTtvGU/mSxQpiCp?=
 =?iso-8859-1?Q?nXaN4CyHMi+qDveb1oLb9dFlI50GXt4wpY4PCFooYk3rkNFjPpsI8+v5Sv?=
 =?iso-8859-1?Q?NdM8TrAA0XHZGlvFjmQxMRgsTntkRtAGRHEtRxOVBGb0nuXttJFnZtnmt3?=
 =?iso-8859-1?Q?h9oGI2tkiYu97vhGNP+H8oIMz6CDKXhCK/ZsgVNnyCECW8jRTx9LznBXNL?=
 =?iso-8859-1?Q?6Og0Labv+3OYCklV3VbrzAH+4u7oiCW/Sh8RvZLlDBDrDrr4YsfM0O4EFU?=
 =?iso-8859-1?Q?/gfUF7YrB3S0OfTWsXhXe2s1H7r7TuY+1vYz/K+uOcbB5D3zwC0GFvlMOp?=
 =?iso-8859-1?Q?slb7viwL/xPX4MQxQ8lI6GMQRMVsVKhmSu3j6ha33agGXp4y7naDmiulck?=
 =?iso-8859-1?Q?FGQyOPZFVfB4nyOcRa7qJ3Iux7PuG+f6sbqVC/UKBcMXdvg/5/zeD07K0r?=
 =?iso-8859-1?Q?YP8zdS4MlF7vfj/RDO3s06YkCwwVr51avyv4+0Z/qZlO6jW/TEWvDDERlq?=
 =?iso-8859-1?Q?J9EfZX4yQzYiNn02n5Ry6Y4DZ1fxt+403lcjcx+Qk05qdHpw+T9nzxxdLy?=
 =?iso-8859-1?Q?sDcODVGlk6bdNZGTKXc+iS9bs6la6Kyx5ljJo2lKQdQG7VBiY2gmzjECms?=
 =?iso-8859-1?Q?+HJvT4eGcxexRJjOxdnaxyKtkUY4C5YmBTWcMebVlDmTvusQO1M2NcAlL5?=
 =?iso-8859-1?Q?MN4zyZUVt2FfEKhGxVnwex9m8UZJNl0MsSMwK16S+aGlcagd0FnwgYu43P?=
 =?iso-8859-1?Q?PP1gnzj4k3fcjy/L6B4=3D?=
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
 AMS1EPF00000040.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5b357ac2-38a3-4968-8fd8-08de5e981318
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?bY+at1qSmP9mlrVtX7O7ieqSVRJTLZMT8Opxg7A7Zwx+38UCg3twjLgikF?=
 =?iso-8859-1?Q?oajzLB9V3558IGUbsLwQ39qXLk7qvhS2P9PNIkOX5Ekk5cNBl/g8Go1V42?=
 =?iso-8859-1?Q?IPHrsxTHuGcdqxsO/6TMhy+a4DLlAwCcj1+Uz41Dw57YBEl6IG+d0lvJYe?=
 =?iso-8859-1?Q?K1ivRj4fB6YpUHnfVvNWmeM2wjuA3nPyKebLy71uZUKp9ZFRnkX6KhWorI?=
 =?iso-8859-1?Q?BI3dQ8OENrHDpBD3wFdlXnFbv1eh29ngojh7CQtj6eBcY8wg7H7s4zqV8Y?=
 =?iso-8859-1?Q?7LjXizsMG04/EenD/RxGF9Bxc/yscVdDQGc4sFhYEGCWgQEIX8eT8E3L9c?=
 =?iso-8859-1?Q?bS1OPZTTIKi64O58u1jqPwzqIEgET71YOiqdOSC//7UZvSy1Jif9x6rgX9?=
 =?iso-8859-1?Q?CukdEfyOTViEwy7Qidt3ZS/D5/h6uCreZpq/6VYxU6QDbIhNj3rW2/Zyl2?=
 =?iso-8859-1?Q?ia41XeECdhF5NnPPkBW+Sd7ETu47aGZQAKBbp2PqN9/DswHOmHl3DluuS5?=
 =?iso-8859-1?Q?yMGMqgt+G3C6DRXF1y1KPBYuRaoS7EvFPzUcd4dxp090/QPcQoMJqIT47y?=
 =?iso-8859-1?Q?nWZYt0Cguwy+99tggYuB3loJyY1dAq9cvlwOzHq6yPTinLm7A2fwreDIFs?=
 =?iso-8859-1?Q?b/Q/eTZf1nc1UupB1VwEZTLhf6kV3QuGuO84+wGJ0fk/K6CCO5dGZjYqXp?=
 =?iso-8859-1?Q?m2N7LnzFcnkbDRpR2w5w8054GgKGqRpSa0UKFHqh7ydgUyv2kZHlFjyWFu?=
 =?iso-8859-1?Q?md3CHTYym1V1Bw/mCJxu8LAc9LYX29kKlyvnOTcmZcSsa+sBDLWHbXJyd6?=
 =?iso-8859-1?Q?4Kmc3ctp1HzCznvw0dFbR+bSYkrC5/bxioDCXRqZjl2BcmGxyRlIsK7a0J?=
 =?iso-8859-1?Q?oaMdKo+G0rUMBxu3D2zZHLDnSx5JnNC2ninDGzh/3f4xX/wQEki+7NlQ1R?=
 =?iso-8859-1?Q?av9hfOcq81go2BRV6mZJcqM0c0XkYOQ99c5eS+faOJ3oV9FoLSEt53jF5O?=
 =?iso-8859-1?Q?GWpXmqa9PivhkjR5y+G9BsNvNuhR1XQ5pnvARxkNXZKs8/t0AJiYCGyx4M?=
 =?iso-8859-1?Q?HirMplb89y8firRhgrJ1jDQGwx8CImVXAwYFyL538Twp3rQGyIabH6gaWs?=
 =?iso-8859-1?Q?2evlDZrsikcdnTBblFr4PeGZ2svrI9UODqVFgkUv+fQ9ahmgw5xEoCYDk6?=
 =?iso-8859-1?Q?d/85/i+d5qgJFWhaPpI7vS9eOX3NRVWggUc2aGhAuAGkomWJSZ04uPy2rB?=
 =?iso-8859-1?Q?++vZAhLB3gvuSttZjuxyjW+AVVe/uoJn3V9YdDwdUVGcOSR3L7Ir9YpZB3?=
 =?iso-8859-1?Q?6JUYgfWMiy56k/pu20oMwetTYUePeews8WcnJtD+N4HWyf3BEbhosZZOfk?=
 =?iso-8859-1?Q?dX+f817DjawdWQRE5Ise/Rq940GQliKxWbP//KTy8hQv+AZDffYzFyE1ol?=
 =?iso-8859-1?Q?EYx8AN2Wq5KB9DgWYBShWVhOqUAx6krNFBpQBLFWgjTtHgTmkx9K7uxxsL?=
 =?iso-8859-1?Q?L0CvdHbGqa9MzcKkVzkDZUoqKW/P70/l8vLspeSkm005HFIBJOuvn4arhW?=
 =?iso-8859-1?Q?vqhjplHRvDkSieg6k1xqPTutVgrChxG+1CKOudQKO4rrWLqZD8Hu9YFWnu?=
 =?iso-8859-1?Q?8MBj6gdnaMTpXkes7P7owwyVIBLXcC8jGTjC4gsU8+a+5yNxG4d8tJ2f8T?=
 =?iso-8859-1?Q?NfpNZYb852UVVSQEoIfLc3h5eDU0b7zIEgfRPwQMdbXxLIJWtvdKnbBYF9?=
 =?iso-8859-1?Q?gbNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:08:20.8119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c751065-9c83-4baf-61b6-08de5e98387e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8205
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
	TAGGED_FROM(0.00)[bounces-69397-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 44708A7950
X-Rspamd-Action: no action

This control enables virtual HPPI selection, i.e., selection and
delivery of interrupts for a guest (assuming that the guest itself has
opted to receive interrupts). This is set to enabled on boot as there
is no reason for disabling it in normal operation as virtual interrupt
signalling itself is still controlled via the HCR_EL2.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/el2_setup.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index 07c12f4a69b4..e7e39117c79e 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -238,6 +238,8 @@
 		     ICH_HFGWTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGWTR_EL2_ICC_APR_EL1)
 	msr_s	SYS_ICH_HFGWTR_EL2, x0		// Disable reg write traps
+	mov	x0, #(ICH_VCTLR_EL2_En)
+	msr_s	SYS_ICH_VCTLR_EL2, x0		// Enable vHPPI selection
 .Lskip_gicv5_\@:
 .endm
=20
--=20
2.34.1

