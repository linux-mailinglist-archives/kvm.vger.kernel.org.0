Return-Path: <kvm+bounces-72015-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UFXVJfRuoGkHjwQAu9opvQ
	(envelope-from <kvm+bounces-72015-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:04:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 51FEB1A980E
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:04:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F273330A9041
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:59:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDAD6426EC0;
	Thu, 26 Feb 2026 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hSoRnFnW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hSoRnFnW"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013038.outbound.protection.outlook.com [40.107.162.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DF0428837
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.38
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121406; cv=fail; b=TxE8N+74IRx7icGVpRacClordfU1rOJlZBCLhkM323wyk4WBdC4T3P2d2M9axuzqZL7GX80/u1Q5cwhsmFCZJtIluSTSt8C30lZ4MjnUpj/0rTUH3pI5fabmHplcIAP8q1C9Xbyvta1tTCz3fQX9rveGiVnBCgKZeJgBASqqY6Q=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121406; c=relaxed/simple;
	bh=/C2Bhf5Ghjrl+qGOyRM9YZJ1t0+FrGYyV2U4a8e+7E8=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=AFh9VpmX+a1gKtJ64u5FP6M6B22WDiNLT8U03SDR1Ntwe6zKT8rcX8yFXPhsIYQ9MJKwrQePWSgDZT3kUvLU4QTjnkDC4aydZeOSqf/MIMbmV+zHpDgFvNC2ErrJMc3aFBCXFAqK1KgP+3wYdW5LXwCXPIkbxEL3zMP+3PkWBfU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hSoRnFnW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hSoRnFnW; arc=fail smtp.client-ip=40.107.162.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=b4zicsYCgTDFrxe3osZ/hEBqsAU9qzFIFLvfpMgfpDLKTgDKrSPW2Udg5qK+H0aGiQKHh7y4K6JjAvncav4iBYNP+tIgPmHxb5BhIUNr0/gW+mMfNDxSllAxoqUrvr+SofKG4M94VCiSgw2Xhs+0Y/KFmZrkB6W146dMotafuqbeOwGSinX09lF3mtlRZCNf1TedBYrGljzwSPZo8yuUOxTpIuwMOgXgaMaktpu4vINow56uRRuP7S/ZgQD/IceK7i2qKdJ/qxH+YHztzc3fi8CEgnalrix2odDsB5Qu8KB7Wfi/IUVzRS+OwfQV4zzYKWcZ9aM/gB3pZUfWDwP59A==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYBU/M9VJN8cvl2jzZM84GpAkw2MdvoJrIkeRS+LQo8=;
 b=XMkRyuI44gkgsGnOMzEmNO+cuDe+2byqGEJIdGRotS5aAddoC0rmGO6RJJkC5saOw9IBEqrszihcP1XmqUKcsKvkICP2Azc649yK3BTay0g/hU9k8EZu8vCiqeLOms/MtlhyNPPR1wkVyyIA064U7SQtJWYC4z0Dh7iNFwBtdBaBfC2V5TfAWiW2jetWB21RsWfaQk8NLobrddlMWx5JweYq/MKJvUqPdr0N/Oze2MPmKu1ctHhiDYY9irkFJoqGlV8Ao4Hxp60ymtCWmTLS3zEwnzfL7q0OOh87bFs+mG3BG2vOPHT6hh46GPvEF8tpM4da8cR2CtQot8RWNThFXA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYBU/M9VJN8cvl2jzZM84GpAkw2MdvoJrIkeRS+LQo8=;
 b=hSoRnFnWlTqLITjr3SvIIc4DwlehIfzJK6wGFQZGbBHP0RSgqmN6n3dwziq+5b2NGFmNIk9NoLSMER1fbznvKJycIKepU2juhcFEaptx3d6ZQsJwv0svmIJg9j/rmoErjBrMrs4NS35f8wQ6uKvwTmSaryjAn3Y8efFj2uhfKvo=
Received: from AM0PR02CA0133.eurprd02.prod.outlook.com (2603:10a6:20b:28c::30)
 by GV2PR08MB8438.eurprd08.prod.outlook.com (2603:10a6:150:bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:56:26 +0000
Received: from AM4PEPF00027A63.eurprd04.prod.outlook.com
 (2603:10a6:20b:28c:cafe::57) by AM0PR02CA0133.outlook.office365.com
 (2603:10a6:20b:28c::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:56:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A63.mail.protection.outlook.com (10.167.16.73) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:56:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mSJ3vt9MS7yjFB8sz8nxTBFnY9c4WXiCor9Sfb/L8KaZWNKJl0sxCxXI3d7ZHATdF/+G1UnFflAmEDEo+wUXUnRq3mzz5+K5vlqin7dN5/ATrWvB3vGEVagaLpgHQIH+nCqYyuGQ0Gfu9pqwZ/xPsRQFMelvJtqKzAVjhBqjJB9wHcZDCCLW/Ed0QL6+u6pu2Iwa96h2uclL5YkzgIPYKNZ27XXt1ifKCzBD7/xvMjUwfVBRf0Rh5Qk4/Xu4Uu5zME7S5bvhNIjg9g2Obzj/9E+Wpg432x6Vl91/xTRyPCfsr3QOI7wPt/hbMYzn6wFA8eqcEuNf0UFpWDtByg10qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RYBU/M9VJN8cvl2jzZM84GpAkw2MdvoJrIkeRS+LQo8=;
 b=kgVuVj3eYTpRQ849LkGSDrHivU0oZXojDXtQAe+Pd5YZKg8n1idiiENcwtbuxObDcpXY9Kk5LRBoXpH4FlI/Vi9ZdL+ZYC9tdQgJzJpc/DUXQUFx3pV5+T0h8fTHDalZl/7Eer2tdNMfGqx/FG5hBKh33g+8mzJuxyEtTEf2IJ3jmIOM+U0yJng/kyAirD2hN8+UDyNdQyLuaYmzbO1eMagcLHn/S1zJIYvBOtfAAKSWeG6yzrhbdzfn1wc29CwO5pQmdiwnfY8rYB7DM9bQTENXNUpDxXvHM9aCuYeB5LZuDi1ILVE8X6HykKJatlnAKR9y0IlnqdG9cnlJBTh61A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RYBU/M9VJN8cvl2jzZM84GpAkw2MdvoJrIkeRS+LQo8=;
 b=hSoRnFnWlTqLITjr3SvIIc4DwlehIfzJK6wGFQZGbBHP0RSgqmN6n3dwziq+5b2NGFmNIk9NoLSMER1fbznvKJycIKepU2juhcFEaptx3d6ZQsJwv0svmIJg9j/rmoErjBrMrs4NS35f8wQ6uKvwTmSaryjAn3Y8efFj2uhfKvo=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by AS2PR08MB8999.eurprd08.prod.outlook.com (2603:10a6:20b:5fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:55:21 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:55:21 +0000
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
Subject: [PATCH v5 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Topic: [PATCH v5 00/36] KVM: arm64: Introduce vGIC-v5 with PPI support
Thread-Index: AQHcpzhPz9xBH4mvBE+PzHYUZXFJww==
Date: Thu, 26 Feb 2026 15:55:21 +0000
Message-ID: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|AS2PR08MB8999:EE_|AM4PEPF00027A63:EE_|GV2PR08MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: 69cfe6da-4b0e-4954-6539-08de754f98c7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 eqFmjky1d4j7y8jAY4si8dpHD6Qymv/sQv3Ud4SuOizIZQvF6x7nKSgOec87CKWOJLVCpx1DlmKaKy1XqmuPnTrFVbk7V2tNe4FKpl6vLvr/dK7JHOHiJxBbdaLyiUdF7bC+sLcoPC8VJaeTZib+SvHCK1PMJ3J+HrVEqqlAT9c+CVRUIWs1CudYROTLPrzLlq9ixC+5v5GgWu2/UYNs1ca/vUPFzCWEIXSArUz0zFl3COjIbeY0XbVqMoyOEn7WH5tKF3b2BMjDUkB1eqwufnU7BxqvWnsXQXCm3lnoHsi2VmxAcHDHjy0WdBHKFZPmke7ITVm7v+mQ/d0Zw0i9HSW90jfScHdk9kMyBFdXAGeatLeulip3RYSZP9GGElC6ejlsbA4JvSYfaxJIRlhUo6wmsVyge0p80n4BLScpJu3pTKbulMq/3TIEQNCmc0lgPjnSGy0RQMlYZk3jUfGOfMM1nBvMt6K8+4+9bVrzWodLhRj1zshGgAiT10cI7gq/yYx1WBo4ANVBD+5ZKF5ZXxw6m37YZqTc7ugSd7hRoP3VRIOXfoapOcHVsRWZljHqEb8ciGkgNuYcAN5nUYucwckmFG9kU1XgP2mXZpuu0t3FxX80SUyCZZoNm7/tSPLniwGRpHRhHlNC8oqu/8yW9783B4gO9qZHbgXuOLZRUiRPJ89wLmJIUQItSxNWKIQEvpjB44tn1/k2F6OfwTA9gchDV1ez10xio/8p2/TH/DFlJ9ZOF3m0hDLV492XIBZx
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB8999
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2905a737-3638-4d73-f042-08de754f7242
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|36860700013|376014|1800799024|35042699022|13003099007;
X-Microsoft-Antispam-Message-Info:
	ZDk3JBBWf8lCV6IgC0F5OoA7volUoBDJc+L1TuAiNtyrlbX5TmzakP/hbEqBEbLbIgoUR660yjQIUKRteZMhBvoJqXtt2DqZ2tDOr2j4C7fsUEBEHkiSfSg+o1b8660NFPLQjjJUlyn8cRsP7iHVaamFaKxLxxFpSXBDAhTyUrrFbAovUP+Z0B3BhBJaqrCH5s1KS6F2u8qh78a72ahWvZO3ZoFI4LsHRCy05pdN3YY3JLPxyy/Jiu1kWJr9zEs8HslatuS2xRZNjnj5OyTVLGRj4fhVYjp9e13gL0Q3+NzqDpXg+C9/mX4+N9qeimIxMqn/OETueXICVRFBRduFiYsiuVtgOk5naTZ/z7CLkybEBIaPf299eOPUSSY7ttLePiVSLNBfGi30dqqnZvFVPT8bkplBtCu31tqJ9v+n2mw/nYaBduH1s/RaPRpHCYLt31LaOuQKhOwguJdSY6hSqFyUA/O4BHoOBbNGTeyySoxRK3r3t5rlyT8SB4guuoPskb6ofdvrsrPExmzz0SZO0A8qrQ/HbbrSHKv+N80yy9XHDN4Ma8AQ3g2Irce2onA3CLIzq3oGz/9NHcmgaZRMrGpZm6UWKfh4+dCnl6WqrzSQXrTX5BRW3o2hkfGmjEQMFn8xtAF+EP2yU6SEvaFHFUIhIaA/UZ3r4Rzjd4zZTtmoqvVSExYo6eK0+mj9nIeTvjhj1hI/sBSKt5iw+5tF6n051i7Qmb8FOJNO5fAYAvFjTHD2fCSImoqBzATiLUpN5MgHWU6ofRdOBRYLzVtmRlWel1y9r7gsxo16i9giwWc=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(36860700013)(376014)(1800799024)(35042699022)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kuSP+X78W8UXnHY7wQpBSN9g0e65nhg0ZR8nCuuph12B7R9fl8nuTncnFobQPpuLavVejGI8p9oZhJZv8VFS32851ILqvLPHV3VzJJg1xa8xlcQAOOy3Xpq2uf1fAfA5AGZ/hn8zf3EelRJt8lr6JKOT/c2LdgqxbK4YSOoWJKkg6uwrp3L0CxDNbjq1XiDcDd3imvMdLs2l1uRbS1aMEdoZwSlXonpBEWKjz2pphPxUqanpg5CpEQvwqmcfKv6N+h3iRF5t305zPyYAyudixwUnzvYJoAxPVUEXidkm5dbW9Q2ZqSkQ8we3eAhXVwtw11vRB7MWymi7jYsaubrl8tReNQULeRxaCfRVKrGCsOPewoCjPY+w30CJsXc4C7DbbenO/cNV3F7TVHyBs2CvAejHdnyHrUcDEoaT6BSPvukvoCjeUGrS4SYMDoxHeUVx
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:56:25.8290
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 69cfe6da-4b0e-4954-6539-08de754f98c7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A63.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8438
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72015-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	ASN_FAIL(0.00)[1.2.3.5.c.f.2.1.0.0.0.0.0.0.0.0.7.a.0.0.1.0.0.e.9.0.c.3.0.0.6.2.asn6.rspamd.com:server fail];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:url,arm.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 51FEB1A980E
X-Rspamd-Action: no action

This is v5 of the patch series to add the virtual GICv5 [1] device
(vgic_v5). Only PPIs are supported by this initial series, and the
vgic_v5 implementation is restricted to the CPU interface,
only. Further patch series are to follow in due course, and will add
support for SPIs, LPIs, the GICv5 IRS, and the GICv5 ITS.

v1, v2, v3, and v4 of this series can be found at [2], [3], [4], [5],
respectively.

Main changes since v4:

* Split out host capabilities from guest configuration by adding
  vgic_host_has_gicvX() for GICv3 and GICv5.

* Updated the GICv5 trap handlers to check for FEAT_GCIE in the ID
  registers, rather than checking the vgic model. This matches the
  GICv3 behaviour.

* Reworked the system register sanitisation to expose FEAT_GCIE in the
  ID registers if the host supports it. Once an irqchip is created the
  fields corresponding to othrr irqchips are zeroed. Twice. Once when
  the irqchip is created, and a second time in kvm_finalize_sys_regs()
  to work around QEMU restoring illegal state combinations to the
  system registers.

  This is ugly, but needs to be done to keep "legacy" (GICv3)
  QEMU-based VMs running without modification on GICv5 hardware. See
  "KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE" for more
  details.

* Limited GICv5 VM support to 16 bits of ID space for SPIs and LPIs
  (realistically, only LPIs). Previously, we matched the host, which
  would have limited migration from 24-bit-capable hosts.

* Added trapping for ICC_IDR0_EL1 accesses to expose the ID bits (and
  hide whatever the host supports) and to hide FEAT_GCIE_LEGACY from
  guests.

* Renamed the no-vgic-v3 selftest to no-vgic, and extended it with
  GICv5 support.

These changes are based on v7.0-rc1. There's one additional fix
required which has been posted and pulled into fixes separately, which
can be found at [6]. I have pushed these changes (including the fix)
to a branch that can be found at [7], with the full WIP set at [8].

Thanks all for the feedback!

Sascha

[1] https://developer.arm.com/documentation/aes0070/latest
[2] https://lore.kernel.org/all/20251212152215.675767-1-sascha.bischoff@arm=
.com/
[3] https://lore.kernel.org/all/20251219155222.1383109-1-sascha.bischoff@ar=
m.com/
[4] https://lore.kernel.org/all/20260109170400.1585048-1-sascha.bischoff@ar=
m.com/
[5] https://lore.kernel.org/all/20260128175919.3828384-1-sascha.bischoff@ar=
m.com/
[6] https://lore.kernel.org/all/20260225083130.3378490-1-sascha.bischoff@ar=
m.com/
[7] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_ppi_support_v5
[8] https://gitlab.arm.com/linux-arm/linux-sb/-/tree/gicv5_support_wip

Sascha Bischoff (36):
  KVM: arm64: vgic-v3: Drop userspace write sanitization for
    ID_AA64PFR0.GIC on GICv5
  KVM: arm64: vgic: Rework vgic_is_v3() and add vgic_host_has_gicvX()
  KVM: arm64: Return early from kvm_finalize_sys_regs() if guest has run
  arm64/sysreg: Add remaining GICv5 ICC_ & ICH_ sysregs for KVM support
  arm64/sysreg: Add GICR CDNMIA encoding
  KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM headers
  KVM: arm64: gic: Introduce interrupt type helpers
  KVM: arm64: gic-v5: Add Arm copyright header
  KVM: arm64: gic-v5: Detect implemented PPIs on boot
  KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
  KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
  KVM: arm64: gic-v5: Add emulation for ICC_IAFFIDR_EL1 accesses
  KVM: arm64: gic-v5: Trap and emulate ICC_IDR0_EL1 accesses
  KVM: arm64: gic-v5: Add vgic-v5 save/restore hyp interface
  KVM: arm64: gic-v5: Implement GICv5 load/put and save/restore
  KVM: arm64: gic-v5: Implement direct injection of PPIs
  KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate mask
  KVM: arm64: gic: Introduce queue_irq_unlock to irq_ops
  KVM: arm64: gic-v5: Implement PPI interrupt injection
  KVM: arm64: gic-v5: Init Private IRQs (PPIs) for GICv5
  KVM: arm64: gic-v5: Check for pending PPIs
  KVM: arm64: gic-v5: Trap and mask guest ICC_PPI_ENABLERx_EL1 writes
  KVM: arm64: gic-v5: Support GICv5 interrupts with KVM_IRQ_LINE
  KVM: arm64: gic-v5: Create and initialise vgic_v5
  KVM: arm64: gic-v5: Initialise ID and priority bits when resetting
    vcpu
  KVM: arm64: gic-v5: Enlighten arch timer for GICv5
  KVM: arm64: gic-v5: Mandate architected PPI for PMU emulation on GICv5
  KVM: arm64: gic: Hide GICv5 for protected guests
  KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5 guests
  KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops and register them
  KVM: arm64: gic-v5: Set ICH_VCTLR_EL2.En on boot
  KVM: arm64: gic-v5: Probe for GICv5 device
  Documentation: KVM: Introduce documentation for VGICv5
  KVM: arm64: selftests: Introduce a minimal GICv5 PPI selftest
  KVM: arm64: gic-v5: Communicate userspace-driveable PPIs via a UAPI
  KVM: arm64: selftests: Add no-vgic-v5 selftest

 Documentation/virt/kvm/api.rst                |   6 +-
 .../virt/kvm/devices/arm-vgic-v5.rst          |  50 ++
 Documentation/virt/kvm/devices/index.rst      |   1 +
 Documentation/virt/kvm/devices/vcpu.rst       |   5 +-
 arch/arm64/include/asm/el2_setup.h            |   2 +
 arch/arm64/include/asm/kvm_asm.h              |   4 +
 arch/arm64/include/asm/kvm_host.h             |  34 ++
 arch/arm64/include/asm/kvm_hyp.h              |   9 +
 arch/arm64/include/asm/sysreg.h               |   7 +
 arch/arm64/include/asm/vncr_mapping.h         |   3 +
 arch/arm64/include/uapi/asm/kvm.h             |   1 +
 arch/arm64/kvm/arch_timer.c                   | 118 +++-
 arch/arm64/kvm/arm.c                          |  40 +-
 arch/arm64/kvm/config.c                       | 123 +++-
 arch/arm64/kvm/emulate-nested.c               |  68 +++
 arch/arm64/kvm/hyp/include/hyp/switch.h       |  27 +
 arch/arm64/kvm/hyp/nvhe/Makefile              |   2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  32 ++
 arch/arm64/kvm/hyp/nvhe/switch.c              |  15 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |   8 +
 arch/arm64/kvm/hyp/vgic-v5-sr.c               | 120 ++++
 arch/arm64/kvm/hyp/vhe/Makefile               |   2 +-
 arch/arm64/kvm/nested.c                       |   5 +
 arch/arm64/kvm/pmu-emul.c                     |  20 +-
 arch/arm64/kvm/sys_regs.c                     | 175 +++++-
 arch/arm64/kvm/vgic/vgic-init.c               | 151 +++--
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 100 +++-
 arch/arm64/kvm/vgic/vgic-mmio.c               |  28 +-
 arch/arm64/kvm/vgic/vgic-v3.c                 |   2 +-
 arch/arm64/kvm/vgic/vgic-v5.c                 | 531 +++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c                    | 106 +++-
 arch/arm64/kvm/vgic/vgic.h                    |  59 +-
 arch/arm64/tools/sysreg                       | 480 ++++++++++++++++
 include/kvm/arm_arch_timer.h                  |  11 +-
 include/kvm/arm_pmu.h                         |   5 +-
 include/kvm/arm_vgic.h                        | 143 ++++-
 include/linux/irqchip/arm-gic-v5.h            |  35 ++
 include/linux/kvm_host.h                      |   1 +
 include/uapi/linux/kvm.h                      |   2 +
 tools/arch/arm64/include/uapi/asm/kvm.h       |   1 +
 tools/include/uapi/linux/kvm.h                |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   3 +-
 .../testing/selftests/kvm/arm64/no-vgic-v3.c  | 177 ------
 tools/testing/selftests/kvm/arm64/no-vgic.c   | 297 ++++++++++
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 219 ++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 +++++
 46 files changed, 3026 insertions(+), 352 deletions(-)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst
 create mode 100644 arch/arm64/kvm/hyp/vgic-v5-sr.c
 delete mode 100644 tools/testing/selftests/kvm/arm64/no-vgic-v3.c
 create mode 100644 tools/testing/selftests/kvm/arm64/no-vgic.c
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

--=20
2.34.1

