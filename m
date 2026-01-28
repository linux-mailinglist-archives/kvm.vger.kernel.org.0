Return-Path: <kvm+bounces-69373-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOyWM5lPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69373-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:04:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 38DF9A76EB
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7426D305E992
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 945E036F418;
	Wed, 28 Jan 2026 18:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JUxZ4Pw4";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JUxZ4Pw4"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010013.outbound.protection.outlook.com [52.101.69.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412F9212F98
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623340; cv=fail; b=sFa+28tXE5t+dhfQQHRPALuoo0ahZ8w9QkLKvlJtEPwwWVgGy3qXt0ABbQcvr7SboM30U57xFkrsXvtZ+oSoZ1hMr6FlwPEkpRG090d2FuKg52XDGy4ccBKw5kI0FD5t20Rb9e9LVC5gFeBIW8vIy1qz7cU2MWDZCGDsp6Cdick=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623340; c=relaxed/simple;
	bh=5gQvfwn0+ULoeUWGuJnIwN4zhCZ+J/TkK1+1fIOmN90=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s+Ba981Sj1Ql0ZbJ+L5KhL46NdtB/Hm9S2GDNErVbWchoTWBKUYGfIIdYbLg/36EPQXF7Zj3HgMPkIB7yVX0YuiAZGuO1vyQzhvwaV8vi2PV879/EX7ToimAxYSUWfCqIEMnuK8XF/SGjicK7PwO/txv4p5XzSaysgIfJD+UHGw=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JUxZ4Pw4; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JUxZ4Pw4; arc=fail smtp.client-ip=52.101.69.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=ENsUQ0+sD57cXBWWtrU2olG1cwiqRoHC09ICpFC/y0N5siFapQmQLm2NcbbtjFzxknU9fWh4eE72bO4/NL/kSkDDdv2AP0C0cOsXcRYWDT+khRLtMznXnjueiWf7yoAxcysHXYysJza26nKZr1hRHB0mnWBjHessHyR8KhQ0cQYWUE84rMdPkEpzuMmSJUcj3KjXS8YJEbtdAs9RVH21wVV5dZjLN5O96mrSlnHt/xDWSJ8Zur3cxiWMn0TXeFohnQHhqG7/pAHuaP+lArcwqUTr5SGwleLwyOjDoRXOBWFTAV4q7ibNkxEhgAEOlpclPcftsJM1yH3cmtD8Vs0Qrw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OazEqTxMb+JM9Dz5dYd6DthiWU7wMbP6Jzp+ttwj1g=;
 b=t9wYgitLVnTBEQ4lrHIM/0Iy9M9Ut4Gt5vNc/zHXQSud/jXtWjDwCUaHKI/HBW9C1SvqhRPB8Z1JBiFpeVPnNQka+LnV1PJCPvCh4FGl88QdDD1dILoEojBWsDN2pt2XfAjKFSkZTT6XJgG1wbPMphHF48r0Ims7QC0ggPhfXiFVIvrX2wOJkCOp5A7NGw4vYboP6PaCm1aK6vmscOPJ7NVFfJ089/dJtTPBIxTQAc8GE6Tcov1bGTNJmlC/M7n/zTYQkI5eRv1tp3A5/NxMpisFBgPm3GXhQtGvuhipP9K8shjkaCX5SiIzdrnwo+3E/TafJj/ArSUrb1dmJKEuwQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OazEqTxMb+JM9Dz5dYd6DthiWU7wMbP6Jzp+ttwj1g=;
 b=JUxZ4Pw4gMJDEXtspNQ6j53Tzy75QJrpEngUMjlBvD4QGqRzpqu93gLd6g7Zq2KeK0W9QfpScB1oqjb2d9VcG5TwusI2NR/HrakkF/ZjTUew1BUk1HI13MdLQmY3dGSrMAZTCV6hTc/Wn5QBYxge8AOW0q0S3XDn/ZX8hNQxFew=
Received: from CWLP123CA0218.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:19d::22)
 by VI0PR08MB10797.eurprd08.prod.outlook.com (2603:10a6:800:212::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:02:12 +0000
Received: from AMS0EPF000001B7.eurprd05.prod.outlook.com
 (2603:10a6:400:19d:cafe::9e) by CWLP123CA0218.outlook.office365.com
 (2603:10a6:400:19d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:02:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B7.mail.protection.outlook.com (10.167.16.171) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:02:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAHnVcpRd3+6++lKPydvSGwaoZij0B6rOnS1ubVvbnVWQK4gq78w1s0UvwbyNIcwAcgqDcFnsmHNU6Ee5jdoQjQQG+FgMMXGAGWOKdnpL2xzn7bnS2x/4oazmBQ9R1mA8qD6B2lzcft81S1rH0VZdsgoFx4zU2EpP2j8Kv+jaO0mCYPkpCu15sc8k/206NuN8fu2CLYZumCukJEMGrwyGH7wjFvx8C6/0d7M6gCwiGMjV/gJ7+7SSpmtcVD7oMmZgFMxg5E7/CNbVvdtMlanrN6aA70YgyQtNISZ/Q55SPt6wyWkPHjVC3QeRkk+1B+ZLjyHf0QQfK1N+j4GuJfz5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OazEqTxMb+JM9Dz5dYd6DthiWU7wMbP6Jzp+ttwj1g=;
 b=i7uLwkbA0ObD8zdZfm5YohO0SP9y20BcIXz1deFKa4erIlmvoJaaRvu2eBZR3s4pq8tSmPqahHKrFirZhN5qBV2+nLTrZ+YjZi5569uVyiek1VgvpjCRzG73lVjXxfE1jzSzwijQl7DLcPFaPC02AR+gynERTCUYb+Q7oPYd0p3KUVGoFA+UmeqhLo9LxLuAVrnCnbSGoiBZ87NdANonZmw2idbIHLGmNHjdhx6uC9tLuad7L2+69wlUARA2QAvfH1xGkv7yr3IVF80Tga232J1VU9Be99jtAoLmLrsiFL7m/dwwClJavHdj+71R3pglW2CCtzIy2nfxPQ7wihSX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OazEqTxMb+JM9Dz5dYd6DthiWU7wMbP6Jzp+ttwj1g=;
 b=JUxZ4Pw4gMJDEXtspNQ6j53Tzy75QJrpEngUMjlBvD4QGqRzpqu93gLd6g7Zq2KeK0W9QfpScB1oqjb2d9VcG5TwusI2NR/HrakkF/ZjTUew1BUk1HI13MdLQmY3dGSrMAZTCV6hTc/Wn5QBYxge8AOW0q0S3XDn/ZX8hNQxFew=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:01:09 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:01:08 +0000
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
Subject: [PATCH v4 07/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to KVM
 headers
Thread-Topic: [PATCH v4 07/36] KVM: arm64: gic-v5: Add ARM_VGIC_V5 device to
 KVM headers
Thread-Index: AQHckIATtaGxjyrdxUSClw6bcVnXaA==
Date: Wed, 28 Jan 2026 18:01:08 +0000
Message-ID: <20260128175919.3828384-8-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|AMS0EPF000001B7:EE_|VI0PR08MB10797:EE_
X-MS-Office365-Filtering-Correlation-Id: b73d32c0-d02f-45b4-1863-08de5e975c87
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?ItYdi/g2dgKKa9mFDlLUx2Wn8VGVSV+rQOQXGZ9ipD++UJyhDB4nRBdHTe?=
 =?iso-8859-1?Q?6rKJjUsjhvo5tqRGcGFi0ec1nFKS76jVkPiZ4GO7nOK89YP5eXhDr9ToLp?=
 =?iso-8859-1?Q?BvFw1DkEtfyG0P18+d+jGI6dqCg3w8oU/K8BCBOCxyuzkik5ER4abUdQjB?=
 =?iso-8859-1?Q?QN/jwCgHmqdVuW8bqPGrgSiltU8Uq+zTvEuCksbImif+gkdTdEvco0FFrV?=
 =?iso-8859-1?Q?T9yvc8GG+0gZsAqpcUe1h2BNOjRQoo4IWE/IRmW0/GGzegT1br59xmSXbQ?=
 =?iso-8859-1?Q?x3e7D19H10tegC/ACgestwAuDDYDwZjrH9x2Hvua5tz+L+dzyPUmbcYDKt?=
 =?iso-8859-1?Q?2zYgeRF9Ev5Kxb9fXIcyTaoV//c7QF1x7/2b0bYkGDjXC7qLVfwU6TKhPE?=
 =?iso-8859-1?Q?7JDwCL3wnPnL8fiERCNFoxsNYGY5zGndP7I01ubVAB/eAfo6lO4HIayJK+?=
 =?iso-8859-1?Q?EejFHXmsxvH7S3Luos/XzqhunrRSRtkQRJwatRcSI0bThehntrlG/1JIER?=
 =?iso-8859-1?Q?1wgJzCXU3y1+5JA2AZ/L0b7WeB10S15LOKq6B0EjxE6wLRj2SwvTYEW5UX?=
 =?iso-8859-1?Q?bSlIY2S8QKfAqNKysbZ6nPaNyz7xIhIaOKcZOP4tRPOFS+fayaLzKfPXJl?=
 =?iso-8859-1?Q?jJSr0ruvL3Ero2kjJ3cnkvoAsm1nPcMJIPyWFDJOULEKFgWHkJ08zQhkQ0?=
 =?iso-8859-1?Q?iOL0MDOlLTDTmGiElov/f0TCi9Xnw7AXEi9gYLPVjIOTHqvYpxQtA3uQuG?=
 =?iso-8859-1?Q?tk8zCRba02/JGcEJ+h/M2hTBph2qimw1JjT0JW8Fv/2OakSJVUpf3nBI0a?=
 =?iso-8859-1?Q?mOYzC18CfALn2FMeXWRY1vSe1/oEcsSWCbsiYidrkUJjspouG3esryE1ig?=
 =?iso-8859-1?Q?TpAJXybnk9R9nog48EKf70ZNm65SfA5as5qW2G7TyQIvmXv+DfNA0nf8Hp?=
 =?iso-8859-1?Q?oszbDBLzAf5TnmLs2wvXhjI+E5cY3W2+LnRGLDrTxw22+3wVDc5VBHwHQ2?=
 =?iso-8859-1?Q?ddHIpDY2zuRivlfQTRlZtZJl2VOURDGSdJDRa56F/423gINvjiyFaUOfc+?=
 =?iso-8859-1?Q?K67UJHCdvh+H2ZMVjKSs7ytwl9BZHjSenhiEVJJWUwRM1q/KD4KifLNa3s?=
 =?iso-8859-1?Q?+1rQWrWGzR8wARgdAsj21VXoJWqetIykixdb9RwOG/4autuvU/oAFzwlj9?=
 =?iso-8859-1?Q?F9XDqON5oibN0tAnGFD3UA0Y4KeBcMqKFlaylJAFyJmbCY8P9pX+c0DPym?=
 =?iso-8859-1?Q?v3xlWVRCp5YA/5M/rC9mWzUrpRN8Fwa3ad4ZoCEoEgllz4zEOMCXrfFCPd?=
 =?iso-8859-1?Q?hsJmwHW8F4oZdK9JxGi3CyNyOBumvhu+RnRdjRhR42ne00w3SueH/sUwJ7?=
 =?iso-8859-1?Q?QPwYhqcmg+AYda6qBE465IlY2fbaC9B4w/dYtspDvzuZjLYJQP0nJzLZEZ?=
 =?iso-8859-1?Q?Ecbcldk2rQAqKqFzQPmnl+nQY6LIGblbUj1Kh0sN8Xz/ee45oMn9mxEMFT?=
 =?iso-8859-1?Q?2I1Kb/xD2hje7j1jpDV0Dh21LDfiaHeZ+fZQ/Is6wZS6eVc0Q2kK/4KI+W?=
 =?iso-8859-1?Q?YiZnUXEYecjvlX+jXYZuk0XXwgkc/+/PyZOiGU4FWmmevUagyorVdmZeJx?=
 =?iso-8859-1?Q?YlC3V0x87lAO0LnXVXhH9y+2hlnrRDvkywPaQCAxaziBrXJN5+biVszxi/?=
 =?iso-8859-1?Q?5iYz7OpbQKOQCASbmY0=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10537
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	21be0e80-b00b-4dcc-3c72-08de5e973685
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?rmMKjP+tfblmjWwuQABAytlzwYD/qU8v53mcKX1PfpNOe+fe7GVgIkOo8y?=
 =?iso-8859-1?Q?aZspMHobiPXKtkvMmzeUPWnseolcQEKOHC3fdZORFFlx2AE4N1malHuDR8?=
 =?iso-8859-1?Q?g0QS+cN3sCEWQ0e13jfwHKKbYnhN/h2FbjJSyJqqSUUXlgpnx0dDq5NduA?=
 =?iso-8859-1?Q?vXiUG+cvHQOTVyZnYvrZFkeJ0avHtMF1CpH+H1UJGhopm9B51soiS2ShlY?=
 =?iso-8859-1?Q?ri8OH9uxu8NQo0cmSx/CmZqfLbr3v7WhFi6S104yPGGuL7ir4u5B8bROpa?=
 =?iso-8859-1?Q?gOV3ftd3Na1OWK61m4f1l75qxptPFx64Ra4BkCrT/V5V+0ghaa/lWSAah6?=
 =?iso-8859-1?Q?qapZLcPyM8k/mTjsvAXJ33sHnvkkcZOMGknIwH0F8wdqXqG+CvMlCadJQN?=
 =?iso-8859-1?Q?F/F2vn1XO5U5/9wzk7qHBl/Uy9Ivq5hSqQR2O8yxSFiOb1E76TCvihUVnt?=
 =?iso-8859-1?Q?btML0d6JZqx/GHoE7KKFnLWLq5FQclSyFF9uMz8iDL6tQkqfiEJ7JbFBbE?=
 =?iso-8859-1?Q?uowv7Gsr+G7GzIV0imR57rk+Z3udJtppNcEbagaYv780v7xbzfxti8VCpX?=
 =?iso-8859-1?Q?8RKY8wYpxjbPGrnPiRqYN/UklJjCgYnQE7WyYsy7/Kv6cMsFltR2lw9RbY?=
 =?iso-8859-1?Q?tbq7/fociXS/PwN1blS+hVWJN4/HdtcWBpl7tyJyfqcyvgB8dPU8yg5BWN?=
 =?iso-8859-1?Q?zmQs7GmPRTNIAlI1bJToK47Ha3gf8oAtn0eMr7plWNP/EIGLZpw2NsDK4C?=
 =?iso-8859-1?Q?MRKgxhDT0HBecDByM6/d2bi83TJM3F0IUcNd/KUCBw7TpCd82PSVGlc/uX?=
 =?iso-8859-1?Q?cxFi/4iGQuDxDr+Arw+iVCGrHxqMixDWtFKK8z5k5tBGvFCSGy7M2DZEaQ?=
 =?iso-8859-1?Q?by8+ihPm+2e8Ny5PXvuk5nI3oWUU5OZTg/cPDAOQmcFIXfBylQH4Pu4hHr?=
 =?iso-8859-1?Q?uYeKS7NpgjTGHxDjs4rfGH+U+rb3sbMDC+IUSlJqPOOm3kFgYhVEZhgkck?=
 =?iso-8859-1?Q?WruxS3NKSd0XZAS9Rg8r77ojMg79Z36kiE0upnXTg7BaTicnZTa+yJwF/O?=
 =?iso-8859-1?Q?JYc+VCHiI1kVqYbR5FCHed0Hkdu/7FsVFq0r3frvLwpiNiSeoHBBEw7xUm?=
 =?iso-8859-1?Q?BUlvGPI76ERseno9Li+rqwK8L5jb7MvCtMNEyekps3CLl0fxdMcZiwEReC?=
 =?iso-8859-1?Q?hN9vPdVUIywj2DAiRPj3ehoixjT9PnXLc9013EjSP5oQaZjoIpoygpJjcK?=
 =?iso-8859-1?Q?X0SUn3WSg2xXJ2LBW4klP8DJ3xqJGVnXXf35ymFToI8iqCbAWQ7rNqxrg5?=
 =?iso-8859-1?Q?ljVKhBtomYHU78mxVB3sv8KQ2kzD7iT0DN/xD61Fj1rEH1BVQioaOFd5io?=
 =?iso-8859-1?Q?Jp4hExmfG5eWTrLN6y8XSl2ttFApOQnHbCUP8eDbsYAQGYSUPtxyiGAGcv?=
 =?iso-8859-1?Q?2sKYXRLdXZ+kjVaTZ00sCfPvTFEmNmRw1dvkXF081lAlLRXpc9PLYNDOBk?=
 =?iso-8859-1?Q?VERkw7NMC8XElmtZfQbA3W+KC5Orn0ASby0LbnC48veiWycaXJfFCvedzg?=
 =?iso-8859-1?Q?pprE2fi+9B7WD3BUhItz/EgkRYB+Y8gX0YTLG/MC7vD4cQ0xZnUrExuy2K?=
 =?iso-8859-1?Q?aUOfrSc2ooVStF5Gtn6VgVF0+s1icKUdFlJ10dMapKlKEzo1amiSoKNyYX?=
 =?iso-8859-1?Q?kwG3GyHIEq3Lrg13s7l6EGrcw9kChPYp+gU/1NXK8WhkG+grUWeRYM3x1P?=
 =?iso-8859-1?Q?3UAQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:02:11.7666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b73d32c0-d02f-45b4-1863-08de5e975c87
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B7.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10797
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
	TAGGED_FROM(0.00)[bounces-69373-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,arm.com:email,arm.com:dkim,arm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 38DF9A76EB
X-Rspamd-Action: no action

This is the base GICv5 device which is to be used with the
KVM_CREATE_DEVICE ioctl to create a GICv5-based vgic.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 include/uapi/linux/kvm.h       | 2 ++
 tools/include/uapi/linux/kvm.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..f7dabbf17e1a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.=
h
index dddb781b0507..f7dabbf17e1a 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1209,6 +1209,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_EIOINTC	KVM_DEV_TYPE_LOONGARCH_EIOINTC
 	KVM_DEV_TYPE_LOONGARCH_PCHPIC,
 #define KVM_DEV_TYPE_LOONGARCH_PCHPIC	KVM_DEV_TYPE_LOONGARCH_PCHPIC
+	KVM_DEV_TYPE_ARM_VGIC_V5,
+#define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
=20
 	KVM_DEV_TYPE_MAX,
=20
--=20
2.34.1

