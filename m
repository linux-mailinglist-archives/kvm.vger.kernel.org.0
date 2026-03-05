Return-Path: <kvm+bounces-72821-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OFBiLvGGqWkh+gAAu9opvQ
	(envelope-from <kvm+bounces-72821-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 14:36:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 15225212A3A
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 14:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 89E6D3038148
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 13:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1DD623E320;
	Thu,  5 Mar 2026 13:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gVFynDtA";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gVFynDtA"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013039.outbound.protection.outlook.com [52.101.83.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C88E17BEBF
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.39
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772717793; cv=fail; b=V+fgGjU2S7Rt80WM9mrIMEvaWvM2Rt9EK8lT0b2QYrizCExfa+aH2PVfi5U6IV+sr7thqBk+ETx4HlLWXoZ+glQvMVSGjfo9nn4jQzXN+AyPTJlXPrPX18okTSsIYRyw/mrbEmfIoEedBJe+BZXYGI4qjBOFaoAZDkdrkZacsVs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772717793; c=relaxed/simple;
	bh=MFhQOT9rbGlBFdCGAmRdj8AMwWgFK90lsscR7mS8CoY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Vw4zhMpbEBrtoCjoNI15wTotoCrWPkUjulFUsdTJZfRjdmdUs3xWg8DSK8wQwtZi0R9rEyjh/mL6cLwsBD9N7b82A5dXCfPru84ZguC81cDSD/OALz31gV6c8ZFUwLS7+FLYfYJueefvZAtvfO9dglZux0s05CpQny3t3L1p2e0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gVFynDtA; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gVFynDtA; arc=fail smtp.client-ip=52.101.83.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=azINagk04Fz7RJH8vGm1yBVbv/AfRM/aC+oEUmJRRb5hlspUzUBxkz4UK2lFtM3+suvZ3v+JakguMj8ySPeXVKW6k01iwntpcDhMNbrZDh8XYGDRh3ZUuBfKKIyEtq9yiO+/h6XbkzeujMQdxGs8wf5qLl9qA2NNet68V2gnAAHJwnk3pDf/DMcX+6OoHQ8O+DSILWcJdo78Tcn4NF0xOhgPSPRFQWtI3my0GRfq9c5XsXozloL3GhqC4ijEBQqBNfrOCZAC8wGi8K07CvX2QFcLYKqe65zsBwkcH8YoxSj3hh92Dfjmq5MqbojOXA+AqGOzf+TV52cYGwTMmlNxbg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFhQOT9rbGlBFdCGAmRdj8AMwWgFK90lsscR7mS8CoY=;
 b=aLSIGezFWhL04i+Fy2FJlwu2/aCk4VhzSO2rx3/6JG+a5ZhDKwItsNcwHHOxBK1+FhnWXco1fauOYfjBH3Y2//r6bNQFTptUpF+ViibGtTUamBD6oi6sLtaBARuHvBLe44bX4y+1FlgwFvEXKRNutnAiQ2IygSg2HezZyX8LJDSMCB1TyKauvLAxJLxIlc3buQxv5tyIoUfR38yn7cbXW4JzH+CSZIqbUozM9+AnGEawBYCB0+kwfuGI/d0Zm+/NautLzd2xkUwzIVJgFff71c0fccyYwSt44xeKaRbtUe+PemI4xpFF9/oomBNuwIVDr2zI3+0Z4PaPuGOaI6pA/g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFhQOT9rbGlBFdCGAmRdj8AMwWgFK90lsscR7mS8CoY=;
 b=gVFynDtAIsN3adHlJg7wpmr1dVxgixQBJVjTRfVGOH03tSry8Vug3MKqij8tOrb2+hwPMznchFso4i5Kr0pY0XS2v7m6p/nV4pRR/+mqBt5ZjaDY1FmkpfOz4kgHnktq/t4igtjLE4odhjKXMRhPODi2LbXR6AkzXSzYpq9F3Zc=
Received: from DUZPR01CA0077.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::15) by VI0PR08MB11668.eurprd08.prod.outlook.com
 (2603:10a6:800:30c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.17; Thu, 5 Mar
 2026 13:36:22 +0000
Received: from DB5PEPF00014B93.eurprd02.prod.outlook.com
 (2603:10a6:10:46a:cafe::63) by DUZPR01CA0077.outlook.office365.com
 (2603:10a6:10:46a::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.23 via Frontend Transport; Thu,
 5 Mar 2026 13:36:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B93.mail.protection.outlook.com (10.167.8.231) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.18
 via Frontend Transport; Thu, 5 Mar 2026 13:36:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLBK1l4kROMLArxNR2WAwErMFaXMI7JdBE30Z2q51OMXx3U1Z/6i9ysGXcR0qgOXFDKmRTxdlTBawK9bJDud2Y922PIHW5peaeK3758oV4PozlYUnujSPZHUOrkL7BJLvWu9zv0vGfhokh+Sh+Q/q1AXoY07raKY09VfgxkbZ4HKG5dGIU28rCmRfPd0HgJ8S2UKT/tR70b/zdfNNQ4SJx84RvbTDYKNfWLs2a9TO2OczYIwTs4Jys7rQyXcG40tNGg365yNxRL89512dTMWYgmxIV6sVYrqO6aWlX9zXG+DhGMbrsVcO7MqyjluLcSFtvhHPikotpMTex0qr0I/yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MFhQOT9rbGlBFdCGAmRdj8AMwWgFK90lsscR7mS8CoY=;
 b=MY7vhenWJlAgCeal+v4Q4lKoZE0mgsf5Lb9piHUihPUbS55bt4p5Fz/1U8++cWiVIF0oj4zLzWO8fvaXjaRJAzEHpzcyZobgK3Krz8RqsJYTgL1VKq0C9JUjyYAuXjmK2bfXdL8nIO+SsruTcWHp8AnxtxMET4ivPI9xGQzMMwxLaArVbDnYGlY8lzVGMrak6QnwhFLEiu5rJJatRo3h5dRibOAroLnPm4qhQLNiGk8zdbWPT5wt0MObzJ8aW3PXHtW0IVQuuJ8qML5IaWtOTJ0ypV1yD2bDzHP+UsA7Mw9adDn0lDk2T2o0rvkMwiUTVYFrdM6VmQtDy9XBCfiFYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFhQOT9rbGlBFdCGAmRdj8AMwWgFK90lsscR7mS8CoY=;
 b=gVFynDtAIsN3adHlJg7wpmr1dVxgixQBJVjTRfVGOH03tSry8Vug3MKqij8tOrb2+hwPMznchFso4i5Kr0pY0XS2v7m6p/nV4pRR/+mqBt5ZjaDY1FmkpfOz4kgHnktq/t4igtjLE4odhjKXMRhPODi2LbXR6AkzXSzYpq9F3Zc=
Received: from VE1PR08MB5694.eurprd08.prod.outlook.com (2603:10a6:800:1a3::7)
 by DU0PR08MB8712.eurprd08.prod.outlook.com (2603:10a6:10:400::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9678.18; Thu, 5 Mar
 2026 13:35:15 +0000
Received: from VE1PR08MB5694.eurprd08.prod.outlook.com
 ([fe80::b739:1366:c5a6:5e10]) by VE1PR08MB5694.eurprd08.prod.outlook.com
 ([fe80::b739:1366:c5a6:5e10%4]) with mapi id 15.20.9678.017; Thu, 5 Mar 2026
 13:35:15 +0000
From: Sascha Bischoff <Sascha.Bischoff@arm.com>
To: "maz@kernel.org" <maz@kernel.org>
CC: "yuzenghui@huawei.com" <yuzenghui@huawei.com>, Timothy Hayes
	<Timothy.Hayes@arm.com>, Suzuki Poulose <Suzuki.Poulose@arm.com>, nd
	<nd@arm.com>, "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, Joey Gouly <Joey.Gouly@arm.com>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>
Subject: Re: [PATCH v5 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v5 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHcpzkLrBJdTlPmXE+QPnFKILOl9rWeddOAgAGFhIA=
Date: Thu, 5 Mar 2026 13:35:14 +0000
Message-ID: <624e9d1306fadd530487455a315bb660033aa0ad.camel@arm.com>
References: <20260226155515.1164292-1-sascha.bischoff@arm.com>
	 <20260226155515.1164292-21-sascha.bischoff@arm.com>
	 <86zf4n7k1a.wl-maz@kernel.org>
In-Reply-To: <86zf4n7k1a.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	VE1PR08MB5694:EE_|DU0PR08MB8712:EE_|DB5PEPF00014B93:EE_|VI0PR08MB11668:EE_
X-MS-Office365-Filtering-Correlation-Id: ebb4e00f-d698-4386-ab8c-08de7abc306e
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 wK8mj6E/n2WxF6EvJGEcg0Jw5r/4YHThmMjQppBAhG0G47HENsqp5MYcjR8w7c5b3vnneIiirYOS5ZyPYuCGAwn0ASVuGlvNlYsmZYFsI9NJUbebGb3ZGsnMA5q69Dcyxf/Ic0yKwu8Uswe5MkRy6YqUnmw6WnvmtDfmJW1vNb0f5aaVM4mJnG1nKEIAjAQmyLUPvTITmiR+gcioY9oMmVnBwwPescswGZ47rLGmS69qpF2v2to8QopG4DzgukfiqCKod3Lm/x32HFC27UoncaWCk1dEOAwIeUsUEXBQoaXARS/NWfsKNjRwIe8RCNmA7tufbpCfs4hj1PdT8c+mhrfl0S2Lb6H1nAulAGVOd7sHvkObVd/O7vJr8SGQgRDCB+JirMrfpy9xkwIZBMfnU7wjjxkq87SrJM8lqaUIlACDZdzi52p5Ea9MyV4Vqg9oGxiUlMzhWghD2RyK/Xa6QmSl76ymrHCyXDmst7PdhFyi2Zxd1yH3VmHfh4aPvHu04u74r1/nCF52m8Fi51BZgCjWHStdgeqF73R5kuf0UIWN8rz6984HuaI6ClZuluwNZdAGBC8+CwWlznr/2zFmGDk6rj0MAJQenBNCx7vXJQa6JLyMWmxqo2f61PUpVFxG86WBJAxgBBKowK+0vcnBpSbns61wydnHDhWJxUWkKRTBmuHpR4WzSvj3ZqJemwIPzOKkuSw4qfzHHj6TVdH4UhESRUnw+qreD6OxUxWjd3s683uNk29MXKGKYzEYS0nUpZtHt8lGeltnogkIEfMek56EXAFPFgZjFiroJo+gky8=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB5694.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F01C83F28454144A7545B8561173930@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
 F5W7nUIUfpfKJi9qxfggWIqdv33mcVVrfl8ugQzMNRBNC+eeLkp/Oj33m3HjXbcQWpAF/IwnH6AE2gEhDKC9zRSsBovHh9FbvcqeP0uhtZ9WyxxrqdMfK1iA9rjcFaZayBGPWt0hu42VzmLYj4sK/zyywIGizK0d+sqSBFlctNt2tpaLZe3rihbRQwwaoUtnTLu65Sf/F7+XoZXPXBd2BZOM3NIkEhm9emFXV3cIK/C5Zp3qVBUZASEyBvxCOcLeu3cnK7gGyGHrcSZiyA6dpZbWXPKLU3GH4GqBmS8RM5YUcXf+j6YjqS9wQKN1Ckz4h3YJwuzNbPGl4SpGsFZ8gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8712
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	25deddbb-5a44-455d-d388-08de7abc0892
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|35042699022|82310400026|14060799003|36860700016;
X-Microsoft-Antispam-Message-Info:
	Y8MApDS6nhqmkr3qo0beSTsSkDKMv5nmeFdF9asfC3RUo7xq2x6tsB2Wc+rgma3dZRTyCOndAPnq3uQw1uz3B/aCzLJljbTp5gDGW5sYQZ+CKbm7LSIdVJ2vxlWLS1VD3OEViycLZ7bgKJskE3+ol+v2BIscuqWdOXv8BEXJmwmRL3+2y0a1vxM1E2RJLFsh3rM34rX5D9sySvNPKGhF/uD/oLlhsqKCuV90qllzFryVeJeh2wWjyRrINMsgAoQPCqInU+Glb0U5fUh+7MTiGvgcAlK7iMwGHeUoX5kfO5Ltgz/vaQ5vHw6PMsvXbn2tiIv+dE006yP1mhqsrCAO3YEqV0D2OMVFalR2WOJHpXwKY3WawBDASl6nW3b//JrX+TO8GrOy3O6LPE8lwbNmnWlfppB3OO6YDz2fOezm6MY2kA1ijxzoDPuEZRICs71Yva6cK1f++tN8oyR0mWK0R5BayDoIlPu9ly79/OsDQdAlZj5Xfvm2ik7fhXAU+czHR67d8CON03i+8v6BfSrI9CAqvrrN+4f03zsGwkKoWVguZH1ORvYnGQhx6+8ScwUn+EdStpCfokqQPLJ53Qrer1yQe9jvND3itkAaHdGGju2ttLiozAyi3f1bfQ/woN00Zj7WRkMXiUPZVb7r4DrfnLQT1GUC7cHpRBN3JO81eP7CibdqPu4Vq62VS/EgxnL4prYMdLQf/A57xY6A1UDmNSQPJvAfEOzjEK1hM5VedyTu/urCN9JSW8ZZ27G7WgbeoR/DFoj32EZq1UjSjUco1g==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(35042699022)(82310400026)(14060799003)(36860700016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ciQpqU74MMxTdRzr8yz/ZmRwnVN/xQR7i6D1xMla5LoIlOJ9P4fmsuzQG1XmRWmMQoaUtAYWCBFlgDweosvuV/TbYJxHUeVm4gC+Twkq4v4k45i+uwYShfIbKhFt0PaYqFiU/p3Oi2YRQSCcHtGYveepR8NoVDVStzu5R9QZpLfmTAfIA+kjUY+RepfUQtVlwvRiXZWu9YZBHQLN4IjxhqY40NdTeEVcjQ3PG+iRv4Eih3T61kVhIFBjs8hW7I/c6CqoI2VYgpAMbVrK+/d/mFNRhTrjs71cqUYC2wGqzaWc2uyX2NkUIHvq2ysZs0nw5yjnN9aHo69SY5D/qESTL9RMU8hJHX6650aVLFrWIlkr+j8BFnsr4i0UDR0ouT/PsSSisobN29w2xNpU4n1ik+IXatxHwUmJ90EqgwBWnNGEU339JfAsNOKnjCdt0vZH
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2026 13:36:21.6348
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebb4e00f-d698-4386-ab8c-08de7abc306e
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B93.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11668
X-Rspamd-Queue-Id: 15225212A3A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72821-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,arm.com:email,arm.com:mid,huawei.com:email];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[arm.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAzLTA0IGF0IDE0OjIxICswMDAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6DQo+
IE9uIFRodSwgMjYgRmViIDIwMjYgMTY6MDA6MzYgKzAwMDAsDQo+IFNhc2NoYSBCaXNjaG9mZiA8
U2FzY2hhLkJpc2Nob2ZmQGFybS5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEluaXRpYWxpc2UgdGhl
IHByaXZhdGUgaW50ZXJydXB0cyAoUFBJcywgb25seSkgZm9yIEdJQ3Y1LiBUaGlzDQo+ID4gbWVh
bnMNCj4gPiB0aGF0IGEgR0lDdjUtc3R5bGUgaW50aWQgaXMgZ2VuZXJhdGVkICh3aGljaCBlbmNv
ZGVzIHRoZSBQUEkgdHlwZQ0KPiA+IGluDQo+ID4gdGhlIHRvcCBiaXRzKSBpbnN0ZWFkIG9mIHRo
ZSAwLWJhc2VkIGluZGV4IHRoYXQgaXMgdXNlZCBmb3Igb2xkZXINCj4gPiBHSUNzLg0KPiA+IA0K
PiA+IEFkZGl0aW9uYWxseSwgc2V0IGFsbCBvZiB0aGUgR0lDdjUgUFBJcyB0byB1c2UgTGV2ZWwg
Zm9yIHRoZQ0KPiA+IGhhbmRsaW5nDQo+ID4gbW9kZSwgd2l0aCB0aGUgZXhjZXB0aW9uIG9mIHRo
ZSBTV19QUEkgd2hpY2ggdXNlcyBFZGdlLiBUaGlzDQo+ID4gbWF0Y2hlcw0KPiA+IHRoZSBhcmNo
aXRlY3R1cmFsbHktZGVmaW5lZCBzZXQgaW4gdGhlIEdJQ3Y1IHNwZWNpZmljYXRpb24gKHRoZQ0K
PiA+IENUSUlSUQ0KPiA+IGhhbmRsaW5nIG1vZGUgaXMgSU1QREVGLCBzbyBMZXZlbCBoYXMgYmVl
biBwaWNrZWQgZm9yIHRoYXQpLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhc2NoYSBCaXNj
aG9mZiA8c2FzY2hhLmJpc2Nob2ZmQGFybS5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEpvbmF0aGFu
IENhbWVyb24gPGpvbmF0aGFuLmNhbWVyb25AaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiDCoGFy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMgfCAzOSArKysrKysrKysrKysrKysrKysrKysr
KysrLS0tLQ0KPiA+IC0tLS0NCj4gPiDCoDEgZmlsZSBjaGFuZ2VkLCAzMCBpbnNlcnRpb25zKCsp
LCA5IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92
Z2ljL3ZnaWMtaW5pdC5jDQo+ID4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+
ID4gaW5kZXggZDFkYjM4NDY5ODIzOC4uZTRhMjMwYzM4NTdmZiAxMDA2NDQNCj4gPiAtLS0gYS9h
cmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+ID4gKysrIGIvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLWluaXQuYw0KPiA+IEBAIC0yNTQsMTQgKzI1NCwyMCBAQCBzdGF0aWMgaW50DQo+
ID4gdmdpY19hbGxvY2F0ZV9wcml2YXRlX2lycXNfbG9ja2VkKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgdTMyIHR5cGUpDQo+ID4gwqB7DQo+ID4gwqAJc3RydWN0IHZnaWNfY3B1ICp2Z2ljX2NwdSA9
ICZ2Y3B1LT5hcmNoLnZnaWNfY3B1Ow0KPiA+IMKgCWludCBpOw0KPiA+ICsJdTMyIG51bV9wcml2
YXRlX2lycXM7DQo+IA0KPiB1YmVyLW5pdDogdGhpbmdzIGxvb2sgYmV0dGVyIGxpa2UgdGhpczoN
Cj4gDQo+IAlzdHJ1Y3QgdmdpY19jcHUgKnZnaWNfY3B1ID0gJnZjcHUtPmFyY2gudmdpY19jcHU7
DQo+IAl1MzIgbnVtX3ByaXZhdGVfaXJxczsNCj4gCWludCBpOw0KPiANCj4gSSBrbm93LCB0aGF0
J3Mgc2lsbHkuIEknbGwgdGFrZSBteSBwaWxscyBzaG9ydGx5Lg0KDQpEb25lISBBbmQgSSBjYW4n
dCBzYXkgSSBkaXNhZ3JlZS4NCg0KPiANCj4gPiDCoA0KPiA+IMKgCWxvY2tkZXBfYXNzZXJ0X2hl
bGQoJnZjcHUtPmt2bS0+YXJjaC5jb25maWdfbG9jayk7DQo+ID4gwqANCj4gPiDCoAlpZiAodmdp
Y19jcHUtPnByaXZhdGVfaXJxcykNCj4gPiDCoAkJcmV0dXJuIDA7DQo+ID4gwqANCj4gPiArCWlm
ICh2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpDQo+ID4gKwkJbnVtX3ByaXZhdGVfaXJxcyA9IFZHSUNf
VjVfTlJfUFJJVkFURV9JUlFTOw0KPiA+ICsJZWxzZQ0KPiA+ICsJCW51bV9wcml2YXRlX2lycXMg
PSBWR0lDX05SX1BSSVZBVEVfSVJRUzsNCj4gPiArDQo+ID4gwqAJdmdpY19jcHUtPnByaXZhdGVf
aXJxcyA9IGt6YWxsb2Nfb2JqcyhzdHJ1Y3QgdmdpY19pcnEsDQo+ID4gLQkJCQkJwqDCoMKgwqDC
oA0KPiA+IFZHSUNfTlJfUFJJVkFURV9JUlFTLA0KPiA+ICsJCQkJCcKgwqDCoMKgwqAgbnVtX3By
aXZhdGVfaXJxcywNCj4gPiDCoAkJCQkJwqDCoMKgwqDCoCBHRlBfS0VSTkVMX0FDQ09VTlQpOw0K
PiA+IMKgDQo+ID4gwqAJaWYgKCF2Z2ljX2NwdS0+cHJpdmF0ZV9pcnFzKQ0KPiA+IEBAIC0yNzEs
MjIgKzI3NywzNyBAQCBzdGF0aWMgaW50DQo+ID4gdmdpY19hbGxvY2F0ZV9wcml2YXRlX2lycXNf
bG9ja2VkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIHR5cGUpDQo+ID4gwqAJICogRW5hYmxl
IGFuZCBjb25maWd1cmUgYWxsIFNHSXMgdG8gYmUgZWRnZS10cmlnZ2VyZWQgYW5kDQo+ID4gwqAJ
ICogY29uZmlndXJlIGFsbCBQUElzIGFzIGxldmVsLXRyaWdnZXJlZC4NCj4gPiDCoAkgKi8NCj4g
PiAtCWZvciAoaSA9IDA7IGkgPCBWR0lDX05SX1BSSVZBVEVfSVJRUzsgaSsrKSB7DQo+ID4gKwlm
b3IgKGkgPSAwOyBpIDwgbnVtX3ByaXZhdGVfaXJxczsgaSsrKSB7DQo+ID4gwqAJCXN0cnVjdCB2
Z2ljX2lycSAqaXJxID0gJnZnaWNfY3B1LT5wcml2YXRlX2lycXNbaV07DQo+ID4gwqANCj4gPiDC
oAkJSU5JVF9MSVNUX0hFQUQoJmlycS0+YXBfbGlzdCk7DQo+ID4gwqAJCXJhd19zcGluX2xvY2tf
aW5pdCgmaXJxLT5pcnFfbG9jayk7DQo+ID4gLQkJaXJxLT5pbnRpZCA9IGk7DQo+ID4gwqAJCWly
cS0+dmNwdSA9IE5VTEw7DQo+ID4gwqAJCWlycS0+dGFyZ2V0X3ZjcHUgPSB2Y3B1Ow0KPiA+IMKg
CQlyZWZjb3VudF9zZXQoJmlycS0+cmVmY291bnQsIDApOw0KPiA+IC0JCWlmICh2Z2ljX2lycV9p
c19zZ2koaSkpIHsNCj4gPiAtCQkJLyogU0dJcyAqLw0KPiA+IC0JCQlpcnEtPmVuYWJsZWQgPSAx
Ow0KPiA+IC0JCQlpcnEtPmNvbmZpZyA9IFZHSUNfQ09ORklHX0VER0U7DQo+ID4gKwkJaWYgKCF2
Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpIHsNCj4gPiArCQkJaXJxLT5pbnRpZCA9IGk7DQo+ID4gKwkJ
CWlmICh2Z2ljX2lycV9pc19zZ2koaSkpIHsNCj4gPiArCQkJCS8qIFNHSXMgKi8NCj4gPiArCQkJ
CWlycS0+ZW5hYmxlZCA9IDE7DQo+ID4gKwkJCQlpcnEtPmNvbmZpZyA9IFZHSUNfQ09ORklHX0VE
R0U7DQo+ID4gKwkJCX0gZWxzZSB7DQo+ID4gKwkJCQkvKiBQUElzICovDQo+ID4gKwkJCQlpcnEt
PmNvbmZpZyA9IFZHSUNfQ09ORklHX0xFVkVMOw0KPiA+ICsJCQl9DQo+ID4gwqAJCX0gZWxzZSB7
DQo+ID4gLQkJCS8qIFBQSXMgKi8NCj4gPiAtCQkJaXJxLT5jb25maWcgPSBWR0lDX0NPTkZJR19M
RVZFTDsNCj4gPiArCQkJaXJxLT5pbnRpZCA9IEZJRUxEX1BSRVAoR0lDVjVfSFdJUlFfSUQsIGkp
DQo+ID4gfA0KPiA+ICsJCQkJwqDCoMKgwqAgRklFTERfUFJFUChHSUNWNV9IV0lSUV9UWVBFLA0K
PiA+ICsJCQkJCQlHSUNWNV9IV0lSUV9UWVBFX1ANCj4gPiBQSSk7DQo+ID4gKw0KPiA+ICsJCQkv
KiBUaGUgb25seSBFZGdlIGFyY2hpdGVjdGVkIFBQSSBpcyB0aGUNCj4gPiBTV19QUEkgKi8NCj4g
PiArCQkJaWYgKGkgPT0gR0lDVjVfQVJDSF9QUElfU1dfUFBJKQ0KPiA+ICsJCQkJaXJxLT5jb25m
aWcgPSBWR0lDX0NPTkZJR19FREdFOw0KPiA+ICsJCQllbHNlDQo+ID4gKwkJCQlpcnEtPmNvbmZp
ZyA9IFZHSUNfQ09ORklHX0xFVkVMOw0KPiA+ICsNCj4gPiArCQkJLyogUmVnaXN0ZXIgdGhlIEdJ
Q3Y1LXNwZWNpZmljIFBQSSBvcHMgKi8NCj4gPiArCQkJdmdpY192NV9zZXRfcHBpX29wcyhpcnEp
Ow0KPiA+IMKgCQl9DQo+ID4gwqANCj4gPiDCoAkJc3dpdGNoICh0eXBlKSB7DQo+IA0KPiBUaGF0
J3MgYW5vdGhlciBwb2ludCB3aGVyZSBJJ2QgcmF0aGVyIGhhdmUgc3RydWN0dXJhbCBjaGFuZ2Vz
IHRvIHRoZQ0KPiBjb2RlLCBtb3ZpbmcgdGhlIFNHSS9QUEkgaW5pdCB0byB0aGVpciBvd24gaGVs
cGVyOg0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pbml0LmMN
Cj4gYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaW5pdC5jDQo+IGluZGV4IDdkZjdiOGFhNzdh
NjkuLjBhMjQ2OGZlZjg2YzYgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdp
Yy1pbml0LmMNCj4gKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWluaXQuYw0KPiBAQCAt
MjYyLDYgKzI2Miw2NiBAQCBpbnQga3ZtX3ZnaWNfdmNwdV9udl9pbml0KHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkNCj4gwqAJcmV0dXJuIHJldDsNCj4gwqB9DQo+IMKgDQo+ICtzdGF0aWMgdm9pZCB2
Z2ljX2luaXRfcHJpdmF0ZV9pcnEoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgaSwgdTMyDQo+
IHR5cGUpDQo+ICt7DQo+ICsJc3RydWN0IHZnaWNfaXJxICppcnEgPSAmdmNwdS0+YXJjaC52Z2lj
X2NwdS5wcml2YXRlX2lycXNbaV07DQo+ICsNCj4gKwlJTklUX0xJU1RfSEVBRCgmaXJxLT5hcF9s
aXN0KTsNCj4gKwlyYXdfc3Bpbl9sb2NrX2luaXQoJmlycS0+aXJxX2xvY2spOw0KPiArCWlycS0+
dmNwdSA9IE5VTEw7DQo+ICsJaXJxLT50YXJnZXRfdmNwdSA9IHZjcHU7DQo+ICsJcmVmY291bnRf
c2V0KCZpcnEtPnJlZmNvdW50LCAwKTsNCj4gKwlpcnEtPmludGlkID0gaTsNCj4gKw0KPiArCS8q
DQo+ICsJICogRW5hYmxlIGFuZCBjb25maWd1cmUgYWxsIFNHSXMgdG8gYmUgZWRnZS10cmlnZ2Vy
ZWQgYW5kDQo+ICsJICogY29uZmlndXJlIGFsbCBQUElzIGFzIGxldmVsLXRyaWdnZXJlZC4NCj4g
KwkgKi8NCj4gKwlpZiAodmdpY19pcnFfaXNfc2dpKGkpKSB7DQo+ICsJCS8qIFNHSXMgKi8NCj4g
KwkJaXJxLT5lbmFibGVkID0gMTsNCj4gKwkJaXJxLT5jb25maWcgPSBWR0lDX0NPTkZJR19FREdF
Ow0KPiArCX0gZWxzZSB7DQo+ICsJCS8qIFBQSXMgKi8NCj4gKwkJaXJxLT5jb25maWcgPSBWR0lD
X0NPTkZJR19MRVZFTDsNCj4gKwl9DQo+ICsNCj4gKwlzd2l0Y2ggKHR5cGUpIHsNCj4gKwljYXNl
IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMzoNCj4gKwkJaXJxLT5ncm91cCA9IDE7DQo+ICsJCWly
cS0+bXBpZHIgPSBrdm1fdmNwdV9nZXRfbXBpZHJfYWZmKHZjcHUpOw0KPiArCQlicmVhazsNCj4g
KwljYXNlIEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WMjoNCj4gKwkJaXJxLT5ncm91cCA9IDA7DQo+
ICsJCWlycS0+dGFyZ2V0cyA9IEJJVCh2Y3B1LT52Y3B1X2lkKTsNCj4gKwkJYnJlYWs7DQo+ICsJ
fQ0KPiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCB2Z2ljX3Y1X2luaXRfcHJpdmF0ZV9pcnEoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgaSwNCj4gdTMyIHR5cGUpDQo+ICt7DQo+ICsJc3RydWN0
IHZnaWNfaXJxICppcnEgPSAmdmNwdS0+YXJjaC52Z2ljX2NwdS5wcml2YXRlX2lycXNbaV07DQo+
ICsNCj4gKwlJTklUX0xJU1RfSEVBRCgmaXJxLT5hcF9saXN0KTsNCj4gKwlyYXdfc3Bpbl9sb2Nr
X2luaXQoJmlycS0+aXJxX2xvY2spOw0KPiArCWlycS0+dmNwdSA9IE5VTEw7DQo+ICsJaXJxLT50
YXJnZXRfdmNwdSA9IHZjcHU7DQo+ICsJcmVmY291bnRfc2V0KCZpcnEtPnJlZmNvdW50LCAwKTsN
Cj4gKw0KPiArCWlycS0+aW50aWQgPSBGSUVMRF9QUkVQKEdJQ1Y1X0hXSVJRX0lELCBpKSB8DQo+
ICsJCUZJRUxEX1BSRVAoR0lDVjVfSFdJUlFfVFlQRSwNCj4gKwkJCcKgwqAgR0lDVjVfSFdJUlFf
VFlQRV9QUEkpOw0KPiArDQo+ICsJLyogVGhlIG9ubHkgRWRnZSBhcmNoaXRlY3RlZCBQUEkgaXMg
dGhlIFNXX1BQSSAqLw0KPiArCWlmIChpID09IEdJQ1Y1X0FSQ0hfUFBJX1NXX1BQSSkNCj4gKwkJ
aXJxLT5jb25maWcgPSBWR0lDX0NPTkZJR19FREdFOw0KPiArCWVsc2UNCj4gKwkJaXJxLT5jb25m
aWcgPSBWR0lDX0NPTkZJR19MRVZFTDsNCj4gKw0KPiArCS8qIFJlZ2lzdGVyIHRoZSBHSUN2NS1z
cGVjaWZpYyBQUEkgb3BzICovDQo+ICsJdmdpY192NV9zZXRfcHBpX29wcyhpcnEpOw0KPiArfQ0K
PiArDQo+IMKgc3RhdGljIGludCB2Z2ljX2FsbG9jYXRlX3ByaXZhdGVfaXJxc19sb2NrZWQoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LA0KPiB1MzIgdHlwZSkNCj4gwqB7DQo+IMKgCXN0cnVjdCB2Z2lj
X2NwdSAqdmdpY19jcHUgPSAmdmNwdS0+YXJjaC52Z2ljX2NwdTsNCj4gQEAgLTI4NSw1MyArMzQ1
LDExIEBAIHN0YXRpYyBpbnQNCj4gdmdpY19hbGxvY2F0ZV9wcml2YXRlX2lycXNfbG9ja2VkKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIHR5cGUpDQo+IMKgCWlmICghdmdpY19jcHUtPnByaXZh
dGVfaXJxcykNCj4gwqAJCXJldHVybiAtRU5PTUVNOw0KPiDCoA0KPiAtCS8qDQo+IC0JICogRW5h
YmxlIGFuZCBjb25maWd1cmUgYWxsIFNHSXMgdG8gYmUgZWRnZS10cmlnZ2VyZWQgYW5kDQo+IC0J
ICogY29uZmlndXJlIGFsbCBQUElzIGFzIGxldmVsLXRyaWdnZXJlZC4NCj4gLQkgKi8NCj4gwqAJ
Zm9yIChpID0gMDsgaSA8IG51bV9wcml2YXRlX2lycXM7IGkrKykgew0KPiAtCQlzdHJ1Y3Qgdmdp
Y19pcnEgKmlycSA9ICZ2Z2ljX2NwdS0+cHJpdmF0ZV9pcnFzW2ldOw0KPiAtDQo+IC0JCUlOSVRf
TElTVF9IRUFEKCZpcnEtPmFwX2xpc3QpOw0KPiAtCQlyYXdfc3Bpbl9sb2NrX2luaXQoJmlycS0+
aXJxX2xvY2spOw0KPiAtCQlpcnEtPnZjcHUgPSBOVUxMOw0KPiAtCQlpcnEtPnRhcmdldF92Y3B1
ID0gdmNwdTsNCj4gLQkJcmVmY291bnRfc2V0KCZpcnEtPnJlZmNvdW50LCAwKTsNCj4gLQkJaWYg
KCF2Z2ljX2lzX3Y1KHZjcHUtPmt2bSkpIHsNCj4gLQkJCWlycS0+aW50aWQgPSBpOw0KPiAtCQkJ
aWYgKHZnaWNfaXJxX2lzX3NnaShpKSkgew0KPiAtCQkJCS8qIFNHSXMgKi8NCj4gLQkJCQlpcnEt
PmVuYWJsZWQgPSAxOw0KPiAtCQkJCWlycS0+Y29uZmlnID0gVkdJQ19DT05GSUdfRURHRTsNCj4g
LQkJCX0gZWxzZSB7DQo+IC0JCQkJLyogUFBJcyAqLw0KPiAtCQkJCWlycS0+Y29uZmlnID0gVkdJ
Q19DT05GSUdfTEVWRUw7DQo+IC0JCQl9DQo+IC0JCX0gZWxzZSB7DQo+IC0JCQlpcnEtPmludGlk
ID0gRklFTERfUFJFUChHSUNWNV9IV0lSUV9JRCwgaSkgfA0KPiAtCQkJCcKgwqDCoMKgIEZJRUxE
X1BSRVAoR0lDVjVfSFdJUlFfVFlQRSwNCj4gLQ0KPiAJCQkJCQlHSUNWNV9IV0lSUV9UWVBFX1BQ
SSk7DQo+IC0NCj4gLQkJCS8qIFRoZSBvbmx5IEVkZ2UgYXJjaGl0ZWN0ZWQgUFBJIGlzIHRoZQ0K
PiBTV19QUEkgKi8NCj4gLQkJCWlmIChpID09IEdJQ1Y1X0FSQ0hfUFBJX1NXX1BQSSkNCj4gLQkJ
CQlpcnEtPmNvbmZpZyA9IFZHSUNfQ09ORklHX0VER0U7DQo+IC0JCQllbHNlDQo+IC0JCQkJaXJx
LT5jb25maWcgPSBWR0lDX0NPTkZJR19MRVZFTDsNCj4gLQ0KPiAtCQkJLyogUmVnaXN0ZXIgdGhl
IEdJQ3Y1LXNwZWNpZmljIFBQSSBvcHMgKi8NCj4gLQkJCXZnaWNfdjVfc2V0X3BwaV9vcHMoaXJx
KTsNCj4gLQkJfQ0KPiAtDQo+IC0JCXN3aXRjaCAodHlwZSkgew0KPiAtCQljYXNlIEtWTV9ERVZf
VFlQRV9BUk1fVkdJQ19WMzoNCj4gLQkJCWlycS0+Z3JvdXAgPSAxOw0KPiAtCQkJaXJxLT5tcGlk
ciA9IGt2bV92Y3B1X2dldF9tcGlkcl9hZmYodmNwdSk7DQo+IC0JCQlicmVhazsNCj4gLQkJY2Fz
ZSBLVk1fREVWX1RZUEVfQVJNX1ZHSUNfVjI6DQo+IC0JCQlpcnEtPmdyb3VwID0gMDsNCj4gLQkJ
CWlycS0+dGFyZ2V0cyA9IEJJVCh2Y3B1LT52Y3B1X2lkKTsNCj4gLQkJCWJyZWFrOw0KPiAtCQl9
DQo+ICsJCWlmICh0eXBlID09IEtWTV9ERVZfVFlQRV9BUk1fVkdJQ19WNSkNCj4gKwkJCXZnaWNf
djVfaW5pdF9wcml2YXRlX2lycSh2Y3B1LCBpLCB0eXBlKTsNCj4gKwkJZWxzZQ0KPiArCQkJdmdp
Y19pbml0X3ByaXZhdGVfaXJxKHZjcHUsIGksIHR5cGUpOw0KPiDCoAl9DQo+IMKgDQo+IMKgDQo+
IAlyZXR1cm4gMDsNCg0KTW92ZWQgdGhpbmdzIGludG8gc2VwYXJhdGUgaGFuZGxlcnMgYXMgeW91
IHN1Z2dlc3RlZC4NCg0KVGhhbmtzLA0KU2FzY2hhDQoNCj4gDQo+IFRoYW5rcywNCj4gDQo+IAlN
Lg0KPiANCg0K

