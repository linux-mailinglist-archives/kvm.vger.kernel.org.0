Return-Path: <kvm+bounces-72029-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AF0RBXtzoGlZjwQAu9opvQ
	(envelope-from <kvm+bounces-72029-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:23:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EDD41AA296
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:23:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 117CD31F545F
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C14042B737;
	Thu, 26 Feb 2026 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c38BQDcF";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="c38BQDcF"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013037.outbound.protection.outlook.com [52.101.72.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428B344D010
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121562; cv=fail; b=fUvJ6LDsvme8mP5aWdlyuBKPLP5FOVER1ceHyrajw9lhGhiNA0kLmVlZhGmix3cws5l1YXZiytQGE6tyLeLm36DXPe7aBhYEET5UCU0EMgrXzuhCk+x07Tcnr/z5rvK4ekR0AUszKcysuBJMVP18N6hd9UK31bBaLCzvsLXB8Qc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121562; c=relaxed/simple;
	bh=TJnfTSyazNPr5I85faCUV92l0/2wOiBrvCW4LmMLJTA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HSWUZKhgf9IvkYCo7R8Etpy1h73ZtwCYNUbMoa3v/tTJlKCwg82baxlqeeaPimHxsqXrQEO7WVlT+9YK8VbAGDPIzJzYosjL8ZyXdTARXiEw0Mn1Sw0sUDf723meOZO7he5e8TIxZllJ3+z8X9nGRj8FYmHNdU611oRVemcgBXg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c38BQDcF; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=c38BQDcF; arc=fail smtp.client-ip=52.101.72.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=INsy7Z6OvbMYCLqrusMGMxLPsS2xbj59UU45UpbBEArDA41C8hPs1Z8b7JAycFeR1B4PqYqeW23RlFINa7y0sYRGvbRBrnHFTBD1ibUdHEZEjSkwkKcxFa0I6LoPO7X1bPX3Z1GTQVeSmXiuWQtMwIAFDO5Pc1ZfJisxBGOk1k3GpSp86Ee9IAOyux6IftNXYlGSREUF9aeaLzcFZOBS5e7vCUzvohUtx089Q7BX/p5/7RBtAd0w5AFJxvQSoHvW8Fkttc8uvFMal6i4etw3hBXvO4kPvScXvpTPQaPMGyMTlIJSKP5gksFrLXdur3iFWfnccmnekKd4RquLRpe8mw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxzCbWBTB6rk/FfdE4lnoFMA1qq4hi+lRpkzSyUqgbE=;
 b=GA8tAAdSSLsjgQ8mktChCN3nXkBr2wbLEpB9oxm9OwFhTIpXJDEN0J0rXRGHPEuS4pwOeTGr/EFuKKd9g5mYeipB+kepqyfxRUX4fZAUDoyPE1hUxKqR8io0JvJt02MVofmZONJRYxh1UaV2kOZxfhYz8AytFnm+ek4GKZUWJonPuZ4Gm05aY1kNN3FuffVbQgy7mlGH8duyJApKEKPFawnrnKwAHF8a3vlBuRY6AQ8FBsEKZxMZFoTe/IZhT9+K2aMcIs00ixxGkV8RtHsKptbkNOhxOA1V2uSxmrqHkhNCb6g/HYkto2yaxSDLpUmQu9uK8GF828R3RciJ/4Jb/g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxzCbWBTB6rk/FfdE4lnoFMA1qq4hi+lRpkzSyUqgbE=;
 b=c38BQDcFCcBpBplbqrc/12JEdjyvwPM9cxrFFLDiCQ5IiXhU8hka/v6MzcMfWNU3HZjFmAJ7zQsgt/bhVw3Nwmn0UEW+UVL2V+EerR5iBGc4Cv1wMSxnAWUuB9H+vwqlBSYsWB1G50zZLtpZUggRgrf6ixa5VZZUmgwC9fBIG0s=
Received: from AS9PR05CA0275.eurprd05.prod.outlook.com (2603:10a6:20b:492::13)
 by DB9PR08MB9804.eurprd08.prod.outlook.com (2603:10a6:10:45f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:59:04 +0000
Received: from AMS0EPF0000019D.eurprd05.prod.outlook.com
 (2603:10a6:20b:492:cafe::71) by AS9PR05CA0275.outlook.office365.com
 (2603:10a6:20b:492::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.24 via Frontend Transport; Thu,
 26 Feb 2026 15:58:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019D.mail.protection.outlook.com (10.167.16.249) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RjtBwg6fFQ8tg0xnxIf5k+4W0RDGHqOkMX9T9UZPoR99o1ShTRw7d6hKFmM6CCi4Ph30S7uslBVCVnPHL8PEcrjWII3m3X2ND+2h+c+mNZQNz8Z7Wum19RdvsrrRlNgBWymCqlEiBhpACwqlCuuwLoqlOBPV0IpiSLq1hkcFY12QuvyvXXFoHtCfILuhePbKOHOzjqlsEHsSmVRrvoLzy724cCyqkdGIrIZ7hlYqU2wSU4uofZKssxAUzMCzY6EnHJ/jQJUaPFnRaCKimFoDVbPreGwqbg0FEgNMUqjZpAoSTXAXUDD4ZBaCQxzKsAH5kg45Bkyg86GTuczFZV7Szw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxzCbWBTB6rk/FfdE4lnoFMA1qq4hi+lRpkzSyUqgbE=;
 b=qw7tnsJRAoQq+ecfu6RYYYWy+Pc4j23OxmNKGT0wja2Mb2DyqEjwk/OmAVBW+gMiIo1T5XEcYUcf5Sdo+JocQ4RLj3FFFmjvwCprWhOfyL4ZaBY9ndOGZSHR6wnCUyuCcf2PftD7CaYhSCO9+TCoBmeLZLCaSaVZZe1GMybR3ZQB+Chei2FD1/mGC3uV7XiWuiIKsuzYCJBMrsHRLwZSN/jL9OWzDlIdC0vvvRqB/3vbYcAd1MO9P7m4QwlmRVSzfida+YsNtHqCqoINGR6RLztRs2vIuHZ4hoMGtI+G4uNmyWRr0tGXihGdsEWPqZ9E2tHgMfTU2CGjj8+AHpgtww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxzCbWBTB6rk/FfdE4lnoFMA1qq4hi+lRpkzSyUqgbE=;
 b=c38BQDcFCcBpBplbqrc/12JEdjyvwPM9cxrFFLDiCQ5IiXhU8hka/v6MzcMfWNU3HZjFmAJ7zQsgt/bhVw3Nwmn0UEW+UVL2V+EerR5iBGc4Cv1wMSxnAWUuB9H+vwqlBSYsWB1G50zZLtpZUggRgrf6ixa5VZZUmgwC9fBIG0s=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by DU0PR08MB7486.eurprd08.prod.outlook.com (2603:10a6:10:356::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 26 Feb
 2026 15:58:00 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:58:00 +0000
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
Subject: [PATCH v5 10/36] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v5 10/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHcpziuo/7/0mB0SUe2eEbqwtZsng==
Date: Thu, 26 Feb 2026 15:58:00 +0000
Message-ID: <20260226155515.1164292-11-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|DU0PR08MB7486:EE_|AMS0EPF0000019D:EE_|DB9PR08MB9804:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a6ffb76-e251-43cb-f392-08de754ff6dd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 xZyxt7+coBxDn/Dhjngn0xOd8SfLVHeVDK4zDuFF27qvdP8AMsvGwb37gKoe1/R8qLTnCy6SVxOmDymYYF06tKHtiMn+jQyoKWCd0lxcp6do3uJol/6fjHaBz90Snmphu3kmPxfFO69xQauN3f6WFFXBmYJKjeDqP+yvayOAzNh1ptJs01aLnA6Ss1VazuFg2JLPlK2otkImtkRWfd3Abn42YMu8eGTw7BPbMvGM+pghwC5FAV8CSH9W67g/UbCsIz6Q8lUx6rz4h7LXM9Cw+5fXtuctzpoBkBsrxWncB3hmShx6Y0cYmoMP7RG6w+OyxXiwNB1BESSkQx3M25t2CfBDaFTL9DFAkpC8Um5bRKlzG9A5sCX+pGaLUX1YT6AZdR0bypowmbbQfaDCB73kfgsXEFABRSRS9OspETlCJ/D2/CGADJpwKsl3i5Jh9wnJqJrkD2GG0AKcBAKdQvqzllRJ0RKuUuFaWJa09VPbeNIols30HnjuFTNTGgc0NVQ3VtHpm2nE6qk/t5QyrN4TAiKTV8STL+rT9AhGdJLXSMwQshYYXO2Sa7N7QMyjE1/INiybJT3NQBhqssjCZjUAPJLZLCakn1i0yAl8j6JrhxkbJx3uSqtxKubKj5zqYdbKvTiVx1FD4giH4IOnkdGpLb5Bg4xmO8lEIC1KmsVr/5bdqtrh76g545/O9ikFfeSKd3xHCJy7H9FxnIjCpdAkiI8yvRgE4KIqVYRagf5Jyvg3QT3Ew5dD7y1CFEhOdpDf5fINo1X2GeH0zgJN5KvUsYJy+J/uzG2JP6ygOO9Bql8=
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
 AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ea06a30d-b9a0-492f-5f24-08de754fd131
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|36860700013|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	KqdlPQF9BOiWHF5SrbC/2io8JAKJURMcIIpjazQg0HTwIoPNQnxTMDEntD2cAUaNXKi7RCsG8JK5t2J0rHWZyXHVvaHFUQvd9qdZxvE9gT79cUHS7pdC4EPeFKI3196tQ6QUJupY5+yx3jWwxWW3BGFZfkNa0QyiagiJpmMbiHVsXDeEiIlULlNCISNrkDKa2xbFuXfOJhlYdj5y60L+7QbME5o1MoqAlp1tXCjG0d7wvYTpULMRmCXpBTm4sXE8KjCYYxyuQhd1VTnfGklZe0GEjN0blHlfEL8Fde/Bhd5EkLemdhjvDoAFd3KVOiR1WSKqAmkBusPZHwmUrynjLyWz9cuEbUkLbzsIUugoygg1WlBgLdkhiA/FFe5o87No9Buk0kqWf7qkTANKE7x/eWYW5ozNUCS8Ypo/p7sBzYAYayd4vRUqeI9mq2gfvKwHXFLWvrhJyuj4GSEUHz2VKc9uTozgucwenKJIGplLi0EMT8+pRj964FfZaBhCW6J8WheB+e3uHvRlX/VIQpv2a6vBTjhektiiAHJRmU2GrAUqZMmu+ArKL6yEPo6HgEKZlhD3rZYCn0qAa19Q+2Qyem2VtCAIfs7h13kzBd0rkfAhaiyAuSoy0UydE+laqXwN8a++UjWkfq+4FuSM0wu5hHnka+kU0Al8B+8tUM3cQav5J2jFJ6QGQlv9ocfV0xTI0eJGBShlE2BzWAfY6+nlLbKZM2oiSTKA8uHsil9gI3mMnMI4gOXhJJgwN50a+jxym37qMr57qeAEF07bwL6OV360117ULdXTCyOHCXKi7c1xRNqkM7mngjk4lRl3o1Cv1SrQzMPYBHZPT6b8MyNylw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(36860700013)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	w4EDSGvKcwRiPlM6XrAMt9py886Gb5tpf926xmK+eW0apd+4x7fZfgNfsI1FzAJRV/4oisLpiZM+R3GOQ6BVVFCRNtAIL+sUqEj+aM4opDSMLXaffSFEQpY0XVBh9wPRM9a3/EAdE25Cm30ruiEQ64RbfUiyo/fylpHlBj+/U2ZhItWk98Z8wNQu6szmA7J0SgYMlwJBpwdyxam6PfjlxfipMspFEw89ltfI/twa+uLujk3VPCL0nPy5oehY2dFuWRVO9Qtl0DilV8Iskcn2lihcwinb8yMyqrteGU4I5GyYftVcuOu2M66TyuKwekhU+N88DIdcSs50TA0+JIR/9u/szxz4mnoTJwWVe2gyVe0tUK2GZM/m287D2J7K+P0wTaIlfJ2ovDUVAcjirkwhvNxKYGfkrEjpxx2awbmZ2Cu0Dp4i/rOm9x3llxHMZ5b1
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:59:03.6874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6ffb76-e251-43cb-f392-08de754ff6dd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB9804
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72029-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7EDD41AA296
X-Rspamd-Action: no action

Add in a sanitization function for ID_AA64PFR2_EL1, preserving the
already-present behaviour for the FPMR, MTEFAR, and MTESTOREONLY
fields. Add sanitisation for the GCIE field, which is set to IMP if
the host supports a GICv5 guest and NI, otherwise.

Extend the sanitisation that takes place in kvm_vgic_create() to zero
the ID_AA64PFR2.GCIE field when a non-GICv5 GIC is created. More
importantly, move this sanitisation to a separate function,
kvm_vgic_finalize_sysregs(), and call it from kvm_finalize_sys_regs().

We are required to finalize the GIC and GCIE fields a second time in
kvm_finalize_sys_regs() due to how QEMU blindly reads out then
verbatim restores the system register state. This avoids the issue
where both the GCIE and GIC features are marked as present (an
architecturally invalid combination), and hence guests fall over. See
the comment in kvm_finalize_sys_regs() for more details.

Overall, the following happens:

* Before an irqchip is created, FEAT_GCIE is presented if the host
  supports GICv5-based guests.
* Once an irqchip is created, all other supported irqchips are hidden
  from the guest; system register state reflects the guest's irqchip.
* Userspace is allowed to set invalid irqchip feature combinations in
  the system registers, but...
* ...invalid combinations are removed a second time prior to the first
  run of the guest, and things hopefully just work.

All of this extra work is required to make sure that "legacy" GICv3
guests based on QEMU transparently work on compatible GICv5 hosts
without modification.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c       | 70 +++++++++++++++++++++++++++++----
 arch/arm64/kvm/vgic/vgic-init.c | 43 +++++++++++++-------
 include/kvm/arm_vgic.h          |  1 +
 3 files changed, 92 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 11e75f2522f95..1039150716d43 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
=20
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
=20
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct =
kvm_vcpu *vcpu,
 		val =3D sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		val &=3D ID_AA64PFR2_EL1_FPMR |
-			(kvm_has_mte(vcpu->kvm) ?
-			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
-			 0);
+		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2024,6 +2022,23 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+	       ID_AA64PFR2_EL1_MTEFAR |
+	       ID_AA64PFR2_EL1_MTESTOREONLY;
+
+	if (!kvm_has_mte(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_MTEFAR;
+		val &=3D ~ID_AA64PFR2_EL1_MTESTOREONLY;
+	}
+
+	if (vgic_host_has_gicv5())
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2213,6 +2228,12 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
,
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
+static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent=
 it
  * from claiming the impossible.
@@ -3194,10 +3215,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1,
-		    ID_AA64PFR2_EL1_FPMR |
-		    ID_AA64PFR2_EL1_MTEFAR |
-		    ID_AA64PFR2_EL1_MTESTOREONLY),
+	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
+		    ~(ID_AA64PFR2_EL1_FPMR |
+		      ID_AA64PFR2_EL1_MTEFAR |
+		      ID_AA64PFR2_EL1_MTESTOREONLY |
+		      ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
@@ -5668,8 +5690,40 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
=20
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_=
GIC;
 		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
+		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_EL1_=
GCIE;
+		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, val);
 		val =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
 		kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, val);
+	} else {
+		/*
+		 * Certain userspace software - QEMU - samples the system
+		 * register state without creating an irqchip, then blindly
+		 * restores the state prior to running the final guest. This
+		 * means that it restores the virtualization & emulation
+		 * capabilities of the host system, rather than something that
+		 * reflects the final guest state. Moreover, it checks that the
+		 * state was "correctly" restored (i.e., verbatim), bailing if
+		 * it isn't, so masking off invalid state isn't an option.
+		 *
+		 * On GICv5 hardware that supports FEAT_GCIE_LEGACY we can run
+		 * both GICv3- and GICv5-based guests. Therefore, we initially
+		 * present both ID_AA64PFR0.GIC and ID_AA64PFR2.GCIE as IMP to
+		 * reflect that userspace can create EITHER a vGICv3 or a
+		 * vGICv5. This is an architecturally invalid combination, of
+		 * course. Once an in-kernel GIC is created, the sysreg state is
+		 * updated to reflect the actual, valid configuration.
+		 *
+		 * Setting both the GIC and GCIE features to IMP unsurprisingly
+		 * results in guests falling over, and hence we need to fix up
+		 * this mess in KVM. Before running for the first time we yet
+		 * again ensure that the GIC and GCIE fields accurately reflect
+		 * the actual hardware the guest should see.
+		 *
+		 * This hack allows legacy QEMU-based GICv3 guests to run
+		 * unmodified on compatible GICv5 hosts, and avoids the inverse
+		 * problem for GICv5-based guests in the future.
+		 */
+		kvm_vgic_finalize_sysregs(kvm);
 	}
=20
 	if (vcpu_has_nv(vcpu)) {
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 9b3091ad868cf..d1db384698238 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -71,7 +71,6 @@ static int vgic_allocate_private_irqs_locked(struct kvm_v=
cpu *vcpu, u32 type);
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
 	struct kvm_vcpu *vcpu;
-	u64 aa64pfr0, pfr1;
 	unsigned long i;
 	int ret;
=20
@@ -162,19 +161,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
=20
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
-	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
-	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
-
-	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
-		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
-	} else {
-		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
-		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
-		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
-	}
-
-	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
-	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
+	/*
+	 * We've now created the GIC. Update the system register state
+	 * to accurately reflect what we've created.
+	 */
+	kvm_vgic_finalize_sysregs(kvm);
=20
 	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3)
 		kvm->arch.vgic.nassgicap =3D system_supports_direct_sgis();
@@ -617,6 +608,30 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 	return ret;
 }
=20
+void kvm_vgic_finalize_sysregs(struct kvm *kvm)
+{
+	u32 type =3D kvm->arch.vgic.vgic_model;
+	u64 aa64pfr0, aa64pfr2, pfr1;
+
+	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
+	aa64pfr2 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1) & ~ID_AA64PFR2_=
EL1_GCIE;
+	pfr1 =3D kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
+
+	if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V2) {
+		kvm->arch.vgic.vgic_cpu_base =3D VGIC_ADDR_UNDEF;
+	} else if (type =3D=3D KVM_DEV_TYPE_ARM_VGIC_V3) {
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
+		aa64pfr0 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR0_EL1, GIC, IMP);
+		pfr1 |=3D SYS_FIELD_PREP_ENUM(ID_PFR1_EL1, GIC, GICv3);
+	} else {
+		aa64pfr2 |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+	}
+
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, aa64pfr0);
+	kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR2_EL1, aa64pfr2);
+	kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, pfr1);
+}
+
 /* GENERIC PROBE */
=20
 void kvm_vgic_cpu_up(void)
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9e4798333b46c..25e36f8b97a1e 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -467,6 +467,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_map_resources(struct kvm *kvm);
+void kvm_vgic_finalize_sysregs(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
=20
--=20
2.34.1

