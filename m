Return-Path: <kvm+bounces-72034-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIxRCMx6oGkakQQAu9opvQ
	(envelope-from <kvm+bounces-72034-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:54:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1C61AB51C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:54:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4DA73331DC5B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34A993D3CF7;
	Thu, 26 Feb 2026 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Sq27bAkP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Sq27bAkP"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011018.outbound.protection.outlook.com [52.101.70.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FBB389E06
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121635; cv=fail; b=gzPc9V7SO6FDtUYRXdFEEqvGNwNqR8mqpVmmNDQQHzlipmWB+1XL8SmVkljeDMJlodkXe2bziR9yu6ii2SUWJYXkRHStBrTI6/wXSF4U1trGMD++5g6UDJEzheTviYOAMViCiq64rWnUzAm2AMD0LJpip1mGzBaPR+6MPvB0gOc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121635; c=relaxed/simple;
	bh=+aBdfsAq+296XefMtd+2djIyen7t+UJB4VFg1L6E81Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qo1RMFJIjZXz2V2DpJ6zVDoPNICzCvYKdB/C3TypMzSbCXHTDdQDNAJw1mriRHCRopZby/PvWkSCWQciZ1HZ6PrwyQZggz3EyJm1nGz7LjizrKnd1jndAXu7bkZfM/igilJs87axAXd+mdcMuVkulEY/BrATv/h2qQU3hnfcZrM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Sq27bAkP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Sq27bAkP; arc=fail smtp.client-ip=52.101.70.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lqP7jaDywXHEJnarCcZdgzTlFR/AiHnwUGixH4EvPvpe9EKuJApxxmJbDBUxGYbJbm6XXBmukfLWcEmmaOUx3I6yYVV91ZWMLiCpQCgFmU+xtG9lbby/a1pkj/K8DkDN4CQtIEzZY9LH7qixuAQZvO5N9iJ7FQvpKlf3AKln+yYrERvjaQcKCOsfEIOI1HxRPnZUn589bIr9iR5m3MNlFhey7+yEzJ3kn/Ps0QdVqnxpk6GXmle//EfI4ppFErnsvAupg6BuFfrfse6z1OeWe9Y+fGwO7bbqwfWk20//uliEaGiWGoWtwu46/55OnJrMoIA3tBwEyXmuCfjyCL3Msw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfNnuzR6GU/03nWKOjkuYjU5pV2f7rBHTaFFdmEuM5M=;
 b=eNs7ETfp/QQF/54jQVtAJPuaPxdKv1FcI9tbRjrXASrxALzCHuJL0QQeQy3TZRqEbhGa8fKT9PFUKT9aTRP0bi27JA2fy6rGvfaAZ+7TmxxyJyvs9+J2F54aa4VuCbbLMVZ6gk4jr7Rmmu4kM6eIouZmErqrPqe5qjb3MgI55+NPeyx7AW0C66xq5q0OwBu8ogVaor4Ik/pTH7KJFJSh9KQbmhhU51U2ipiy9pPK93yq6pgx+fMuABZ8Fl243WwCNoQcMOi8r1/g9Gf5Z+ypuCbpBvzyn3Pv0XvKUKO6eD7+emNnu2JaSd6j3BzOB6bVzJp0D06Jj0AwPcnWBgiRug==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfNnuzR6GU/03nWKOjkuYjU5pV2f7rBHTaFFdmEuM5M=;
 b=Sq27bAkPH3/JDRQ9B06M4AqChxdvfCEwhEQICc5jhftI8dsn1/+wZeQz+8c6xYleuFZpUouAzddLPUu8nPwZ5kCn83YVOR9CD6SOk+LRmypuQKuzngZSxXbQFJ9hgYab292MJJDv1Y9ZmwOinq0AGMONKHdgWHTVcWccKOhP3Ug=
Received: from AM0P190CA0007.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::17)
 by VI0PR08MB11843.eurprd08.prod.outlook.com (2603:10a6:800:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:00:21 +0000
Received: from AMS0EPF00000197.eurprd05.prod.outlook.com
 (2603:10a6:208:190:cafe::be) by AM0P190CA0007.outlook.office365.com
 (2603:10a6:208:190::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:00:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF00000197.mail.protection.outlook.com (10.167.16.219) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:00:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xPe9JMEOTyvGEnuoeSz5mK123uI+jcDnjadbPi7Mww1OifeORnMC7j+G1u8JB8y6jaYv4O5Ivcp/riyU9oTd5P4Y3ssyvdmIK1AbKbwRClkdhN/Nr4Vml/uXgkQZsmtyzLlhlZJpWoliPZ99lJy18a1qvmTbb/DwH6d9BASkwgylWEdcbEqPo29Mb63e+nHMdp8z2s+gzYdJCBCfbBa61S8s4VDUHgW2AliI8hxpX3+olKEy6vyyp0a5n7PMFvk78wVmDi05L6VhF2FB9nWLAuz5VO0LfWlNSZnkyLyiC+wwr4OgjU/QOFxSG33XBLOx3o7XKwF4lCzjFvvAGoAp6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RfNnuzR6GU/03nWKOjkuYjU5pV2f7rBHTaFFdmEuM5M=;
 b=fHOEn7xWeGl3v50FREA2JUFB4j/Rfg4I1zxY2B7Ma3VJSxGu3GJkcX64haDEitIAcRwEl7thnCH05Zj7PsuxJtBm9SZo9RDkVyQ3+KWgqze2TA0aeST94Prx2mw4k1qJ4gCOPWjM8fKIlxsuH6UZueP2Z2yxE8ynHtQRZ7zN9gg8cIfentMW1Njb3kHR5FY7+nq+/nnlbc7U6GV2sX2lOoe3gNMIDMzPxYLynb1ia1p/ueI6iiIB4TxcHty8k9n0I+QFmclgucbQNvUyEYiK02kP1bbmM5FRTuY2Jf0rI4U6ZHM3xZsBYu360vDJ++W4KtiNf9E5dRRV3ujQC3GOEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfNnuzR6GU/03nWKOjkuYjU5pV2f7rBHTaFFdmEuM5M=;
 b=Sq27bAkPH3/JDRQ9B06M4AqChxdvfCEwhEQICc5jhftI8dsn1/+wZeQz+8c6xYleuFZpUouAzddLPUu8nPwZ5kCn83YVOR9CD6SOk+LRmypuQKuzngZSxXbQFJ9hgYab292MJJDv1Y9ZmwOinq0AGMONKHdgWHTVcWccKOhP3Ug=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:59:18 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:59:18 +0000
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
Subject: [PATCH v5 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v5 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHcpzjcwC8br2vVhUybONFHVD5cTg==
Date: Thu, 26 Feb 2026 15:59:18 +0000
Message-ID: <20260226155515.1164292-16-sascha.bischoff@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
In-Reply-To: <20260226155515.1164292-1-sascha.bischoff@arm.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: git-send-email 2.34.1
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|AMS0EPF00000197:EE_|VI0PR08MB11843:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d6c3c25-3321-487f-29de-08de755024cc
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 /TrIV/6vka0tv9DTMlzoqNf0CY455AMWLfL7KYltjDZ2muPl4LOaEIKiLjlEncr6H9vhvYyiXGwP0dmRC8u1eUNYpYNZzjR5+MSoTgHVygcifRIFXkLTY7Wy43PUQNxDzxQ4VvTue1prcywbDrd3HHInJXycHJzmX0hZrMsLj/wOZNemTlBO2epASmadNL4Zp27tOuQoo87+6IClEN+Ws33Np4431be+ex+yl9boTGMIxyiFLQY/XLgatv/MPukktq3UPBpvb13Xn4IRLXx/0fIDJRLlUBArUzUEH3tP6taupu2TwznnZeZPZxxKf/apiQuo+n0/e8BP2FDOzj/opqoKDgJLymsH5FZZp2Uxca3Sq2yC5cny6AH9qvQVHQQsh5lXITaeY6HH+HVVmylfJYUAz3oGgi9iNz//UHKerQHgUYpUmLNFPIi7bM7WUFpEXTrTMHWxO1axQOrIosYGj3Y8cOiIbmzT+qrMXbEFT3T4CUH83ee1P+Pu80pLnm/713kHr1NnFBmYsYl4m3UHFmc74NV6BSfoj1u/Qu+JxR0ATM1vd4otZgh1NJ34ObAp56tUHghnWbAawelkDhVvyxU9K/pPwH8htDt0xiaPldpNtza7/babr5aLDRaHKWwXwQiYGBiZywxtPRovce/8kTP7Fe4no6WojhSBsedU4Y1V0JJNThHQsoaIluMpLSakxomxAue17kZvh1gLOIaRl2sUMy0p5rz5QQB4jcZJV8G0CmFrWb00MWI47SGZA3qlRuhpymHNr7AwEIpgts3qS4uOGjX2o05hyiddQMJnnKk=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB7486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	7c6ffb6e-1b0a-47b2-b8eb-08de754fff5f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|35042699022|36860700013|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	2NeIXhWWU97YXGjzNXepzYqKv0m++Hz3PPH1g78J6Rd5hUSMTFf5N3L/WL1Lw9ShNyczZdnljzDHPh5VD6xoXJEonJv/k7r1cCRK1UJIpb+8GJhElgbsuWW7LWqW/EbhO5M1oikmJ8ONki+uDXhwbG04qSEMzQ6oPaLBcjrirvPBDUhrFJFj5cF4qnF30Rl5+B60vf2G0RqCGnUwUD2pgYqmSgxNNaipFGYkw4TzRZTLynBSZk/df8sRMMSnsRlbXZhKdFjtsD/X2CjfvP1p0FB6y90lW1ZRyjQrvs4Us2v42dHdTM+8bNQVoCzt4sdtJdHmBxH6kE1XhEuO1ex3qrD4QnJXgRuhn4csUzfoDED+v3iNgfxGciJi62gptsLPJcWazos0/XnM9jGWinHU6kqVa4piOWPN9FNePwfUcnf+tnaI8fNCZuy2liq6kC2vQ3H1VHS656a2dOEd0UOv4SWrcz92w750rjGYXDsUptvSve31tuX8K11sx0XHTJ/j7JjKXwBYVzW7u1C5NCTsE65uUvUkhLjYMvWDVb7GRoHTHSEFxug0NtJvBerdZeij8/+PypdvHmcWp+LVoXUjqi8cbgbK31ZiHlax+5iaKZulZb8Np50RcFx93bWHpa+2SlL7XTRX3EjhUbzpGa+4nnXotxI8lVDRfpOi536aPkbCb8MORLET6USbgPl4ZsAU4xo65QSGP9op+64h++ZNtchV+x1Ya/DUiTxUZhTMOwyr+6LEOBYgzdmB01hBMIt5yFYH0P+CIOJv657coqgLrnHOgriQT2yGr00dk6e9LUP/J0Ax83k7PK2+B42lI5xDglGrYd8CD8po1slS/JZu/Q==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(35042699022)(36860700013)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0EtkljU+38Qotj2Chm5WOKTJ6XP4m5vbxPnplvfuMQXdI8QgK+KuxWh6liBEz1qpnv/tB98xd0g5mNTnLZY+kNB/Mntya7n8ObcYxOU70jsm7yobiiWiMAHcPGNRJxfIIxYsFo2C+IY0vujSmNiUcV543po2UCIhf87wHY2+J0RAgdMewRu6WFoZ0fUO1yhzR3O6E5fsjzAwD9WBBO9/w44NWCI6irT2yMpg6YVfO+v6sCIQ5c+rOO8ceU4oZSWZYqgZm6PeXgB4nNdzwWhURcie8IEvXx/dz6vJCx2vB38RkXh2g9imPFos7eO3Q7d/htTO4jWIgt/98yXFPGSTonTHHAaojHB4C09AQh1/y5vRgtwmrwRP8UbQfWdzm14eJ7Y67GoKa23bAtSJeA9oZK5YEO6dmvQd/GRoM+Fx/5EC3I3rbYfie7FE9ildvFqw
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:00:20.7184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6c3c25-3321-487f-29de-08de755024cc
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000197.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11843
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72034-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 6D1C61AB51C
X-Rspamd-Action: no action

This change introduces GICv5 load/put. Additionally, it plumbs in
save/restore for:

* PPIs (ICH_PPI_x_EL2 regs)
* ICH_VMCR_EL2
* ICH_APR_EL2
* ICC_ICSR_EL1

A GICv5-specific enable bit is added to struct vgic_vmcr as this
differs from previous GICs. On GICv5-native systems, the VMCR only
contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
the priority mask (PCR).

A struct gicv5_vpe is also introduced. This currently only contains a
single field - bool resident - which is used to track if a VPE is
currently running or not, and is used to avoid a case of double load
or double put on the WFI path for a vCPU. This struct will be extended
as additional GICv5 support is merged, specifically for VPE doorbells.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 28 +++++++----
 arch/arm64/kvm/vgic/vgic-v5.c      | 74 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 32 ++++++++-----
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  5 ++
 7 files changed, 141 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index b41485ce295ab..a88da302b6d08 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index a573b1f0c6cbe..675c2844f5e5c 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -842,18 +842,30 @@ vgic_find_mmio_region(const struct vgic_register_regi=
on *regions,
=20
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_set_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_set_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_set_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_set_vmcr(vcpu, vmcr);
+	}
 }
=20
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_get_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_get_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_get_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_get_vmcr(vcpu, vmcr);
+	}
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2c51b9ba4f118..5b35c756887a9 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -85,3 +85,77 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
=20
 	return 0;
 }
+
+void vgic_v5_load(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * On the WFI path, vgic_load is called a second time. The first is when
+	 * scheduling in the vcpu thread again, and the second is when leaving
+	 * WFI. Skip the second instance as it serves no purpose and just
+	 * restores the same state again.
+	 */
+	if (READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, true);
+}
+
+void vgic_v5_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * Do nothing if we're not resident. This can happen in the WFI path
+	 * where we do a vgic_put in the WFI path and again later when
+	 * descheduling the thread. We risk losing VMCR state if we sync it
+	 * twice, so instead return early in this case.
+	 */
+	if (!READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
+}
+
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr =3D cpu_if->vgic_vmcr;
+
+	vmcrp->en =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcr);
+	vmcrp->pmr =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcr);
+}
+
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr;
+
+	vmcr =3D FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcrp->pmr) |
+	       FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcrp->en);
+
+	cpu_if->vgic_vmcr =3D vmcr;
+}
+
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_restore_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_restore_ppi_state, cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_save_ppi_state, cpu_if);
+	dsb(sy);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2c0e8803342e2..1005ff5f36235 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -996,7 +996,9 @@ static inline bool can_access_vgic_from_kernel(void)
=20
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_save_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1005,14 +1007,16 @@ static inline void vgic_save_state(struct kvm_vcpu =
*vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's ru=
n. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	/* If nesting, emulate the HW effect from L0 to L1 */
-	if (vgic_state_is_nested(vcpu)) {
-		vgic_v3_sync_nested(vcpu);
-		return;
-	}
+	if (!vgic_is_v5(vcpu->kvm)) {
+		/* If nesting, emulate the HW effect from L0 to L1 */
+		if (vgic_state_is_nested(vcpu)) {
+			vgic_v3_sync_nested(vcpu);
+			return;
+		}
=20
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
+		if (vcpu_has_nv(vcpu))
+			vgic_v3_nested_update_mi(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
@@ -1034,7 +1038,9 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu)
=20
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_restore_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1094,7 +1100,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_load(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_load(vcpu);
 	else
 		vgic_v3_load(vcpu);
@@ -1108,7 +1116,9 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_put(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_put(vcpu);
 	else
 		vgic_v3_put(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 851b37ccab84d..81d464d26534f 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -187,6 +187,7 @@ static inline u64 vgic_ich_hcr_trap_bits(void)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
+	u32	en; /* GICv5-specific */
 	u32	grpen0;
 	u32	grpen1;
=20
@@ -363,6 +364,12 @@ void vgic_debug_init(struct kvm *kvm);
 void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
+void vgic_v5_load(struct kvm_vcpu *vcpu);
+void vgic_v5_put(struct kvm_vcpu *vcpu);
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
+void vgic_v5_save_state(struct kvm_vcpu *vcpu);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ba227ca98c233..3d34692d0e49c 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -428,6 +428,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 /* What PPI capabilities does a GICv5 host have */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index 1dc05afcab53e..3e838a3058861 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -375,6 +375,11 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

