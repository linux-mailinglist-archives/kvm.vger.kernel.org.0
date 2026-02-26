Return-Path: <kvm+bounces-72016-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CH9wNU9xoGk7jwQAu9opvQ
	(envelope-from <kvm+bounces-72016-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:14:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8951A9CCF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:14:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E994B31C75E5
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:00:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51C742EEBC;
	Thu, 26 Feb 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D57EIcz1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D57EIcz1"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011033.outbound.protection.outlook.com [52.101.65.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE51426EBE
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.33
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121419; cv=fail; b=UK/EDkmW2pM+z64W3qPVJSZBjLj7TuAXtY8yXVDXn+NM2R/svsmqOSEJUtXFYVtA9cUloBjZErdDPhzV6aoLMwYzxghq+DGCCaKEm6bJi0zDPJuYyNyd+8DTcqmVT6XD8W6oWi8bhXzjXy/MB0Wk9T3WzlVmiCD7wrRyXXlSmNc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121419; c=relaxed/simple;
	bh=vItVsDlAxh44BkIc33y2pO+rp/GhjD5bkNagqjWQ5ys=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HdDmZBMshTzu9Nv0k6jXiJ130VmJU8HQwQQXqisojIqNb+gsd3s9gS4/J8OnOTkuctIHQJgzjacyzScDoBalAiSOY5ypk59i6uRzndBrN+hUqu7D6Vo273YEI8EnXh3yb9Xcp5R+ljVGd8yGdERBNKjdjlczEOIvoljVNn1u6VE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D57EIcz1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D57EIcz1; arc=fail smtp.client-ip=52.101.65.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=eaRr1ijtRkQUv8YogICNrTSa+aq+M2wp4Zyleh6ULzrlnHuQ9laAazFgWe9sRN3vVxQ+y9CPSGwwV3m46afl88Qlz+dWwu4dICVxkmUWAxPBYKP/BziPsG1LvNDbDQWcIoCKAFhpSFwVHp/jbxl1bbuyE/Dxd0xDuRBi5wmpKsywZFl03kqRkB4fg9kZpN0L4gkslakl4wEE1atx+f17zo7TiTtKojQrHPLc1BONTiS/Au8i5u01LZWJsie7FhxJaDSfWVOyZXELYTfqxs/fDQosuWMNUZGN6BNI2XiVzXZnC5T1syJShja9c+jPX9DMyrcTD/zh6eqIqu+Acs7Gdg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBRDcriNciVtOJ4epG86Om9U4T1lcvDUV1hAU+2H6eY=;
 b=XTsfFbV2+WHhNp508QgE1SivPCs5AyBAsO4NIlSSBb+7jHCsmysFYRdWGpg4Yu71I5xK26gCpPIZhyfvjBBAyIYVOa6W0MDXET7bV1c6bL66YTssM81mytcbxI1LKTVrATlKWDxjPThXmE0If/eJelY0DInr0UXbQSifp6jLx5DjZSHHYQjo6/W5n8wjCFU23ruHd3BdwQtuhgnNBoiZL+d4OWXhI3K/cgq45ufIPOpdqCQse0e+mBb5sNcBOspPBue2IX6mvsK+tmkDjNO/F/mWO46ThAoEGmHowwRYi5hbUjTpw/c+lxc1SmeJcpJq77e8JLhcg5L4x1qruQkmDg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBRDcriNciVtOJ4epG86Om9U4T1lcvDUV1hAU+2H6eY=;
 b=D57EIcz16pijyuEWDyE5WKioKCT7IXuXy6zufmNpzCdQVolHzg5tMLiE4B/Au7RmoHJ73HvxcREDLLbCQ1e3epE4lubP+iD1FgEAM4Jl+jTfXBEigm0A129a89GzkUciXVY9qNMyYPcl6m8SNETICQfi5XufacxD+BV1R56qadw=
Received: from DB9PR01CA0022.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:1d8::27) by DB8PR08MB5420.eurprd08.prod.outlook.com
 (2603:10a6:10:11a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 15:56:45 +0000
Received: from DU6PEPF0000A7E4.eurprd02.prod.outlook.com
 (2603:10a6:10:1d8:cafe::35) by DB9PR01CA0022.outlook.office365.com
 (2603:10a6:10:1d8::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:56:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E4.mail.protection.outlook.com (10.167.8.43) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12 via
 Frontend Transport; Thu, 26 Feb 2026 15:56:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gL1ogztyPWMioQFnOjkGaJLhcdN/0u4wySasyzmNQBUpGiOnsUASXibfxilQWJFCOwj4X6dAFg0ho6lS1EONrLU+vvBp17Tda/k5XMddlYSBJctFcFP8oMiB7jckrOKnt5+A3ONpWsVpqcHTux0fBDk6niZGEbwcycZOfQhG9NPXDr5P6imPMcX4uxU+Qm36ttYRZy8/6LfmsgBPZ0eEZDOqnSA0ffNyIrOrSomAu+AVJ9tabDN2c8x81SRip3qtPaWTwEBl5Wq/OqKZe4Nz4pxS6W+CPifhh4CmD+1x6mVsVgnQbXLtPntKwJ4SoSQmZ1g5J+t/2Ko+xwgUZ4obYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iBRDcriNciVtOJ4epG86Om9U4T1lcvDUV1hAU+2H6eY=;
 b=RYsKmgpcrCnzMfL5FOtHkSoNqOySLU+cRo5WGoyevkKK+whdgu50OoClmJpm78OlGyAxbqmlLJhbg39fAs5s8pzwP7LBzIkHkIVF4X/Osqq/0Mv1EjWb+sBY0+RuF/sBTLaH77IVxV/tWeMalURGxKp+mzhXJ78+O0Ifct/9kx0i51se6tBFDYZz1eqoH7EAfeD9EmE7vCySDne3YVZAjR7AD9T3KZUzVRhrz6y7s/XZ/GQJKj5tRDJcta31NKPmJXIAXOvlXUl8C+m29Y6WxpNdvC8KF7zk8y4dAeuCuy4NPUJRnkGuUdiOGqqmmegfeDXML1357cDCnTSFns/lOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBRDcriNciVtOJ4epG86Om9U4T1lcvDUV1hAU+2H6eY=;
 b=D57EIcz16pijyuEWDyE5WKioKCT7IXuXy6zufmNpzCdQVolHzg5tMLiE4B/Au7RmoHJ73HvxcREDLLbCQ1e3epE4lubP+iD1FgEAM4Jl+jTfXBEigm0A129a89GzkUciXVY9qNMyYPcl6m8SNETICQfi5XufacxD+BV1R56qadw=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by AS2PR08MB8999.eurprd08.prod.outlook.com (2603:10a6:20b:5fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.13; Thu, 26 Feb
 2026 15:55:41 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:55:41 +0000
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
Subject: [PATCH v5 01/36] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Topic: [PATCH v5 01/36] KVM: arm64: vgic-v3: Drop userspace write
 sanitization for ID_AA64PFR0.GIC on GICv5
Thread-Index: AQHcpzhbLSJb4DWqCUag58X38HbOHA==
Date: Thu, 26 Feb 2026 15:55:41 +0000
Message-ID: <20260226155515.1164292-2-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|AS2PR08MB8999:EE_|DU6PEPF0000A7E4:EE_|DB8PR08MB5420:EE_
X-MS-Office365-Filtering-Correlation-Id: 42b0cfab-4d71-4e02-7003-08de754fa425
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 q9PGWX17RkMUtzOxGojS5iznOoTBVfks4GGc45McjBRPvTvWOyvgb7C1DD42Omf0RGi8StrKbYOoE5VNTVtfb8cC28LrvqgFwAiavhgQtom5ILJP91pwyB9IqAWGOgk7gC2tC82l/anBfdLcx/0fuc2HsbTh5u5XKs56WDErxFFFuEupehHEOQs4qSDCL6y4imDDHikTDNV0/2euH+JhKQd0/rqtb032uTCeHlkVQXGe/n3EUm3VjolrXkWtBSyOtIJwfOqNzwHQ8AcRSBhrVIH2BIIG1XEorfro63hY0PuJhJdytT1+4sXyldmqVd+Pho04Io/O0HHNPilt+ozgye7a/4Y55h+KpkkvVH4//owQkZwMSSlh7E80VOmU8Jwde4u5y+94+gE5EY2n/x+3/WMi5uJvEUVghuKWZjqkwOwqh1LgrtvxgMQoHp3H+Oz7EzDoaCgrEqZlZDcqkUdGe548KvNL3eOlgsY9aWuzGPBnd96J31d09JM4FzkczR5LiGxpLkqZ8K3n7QWN+GoQdnP7r6btEoNhjjZWERAADrk87kq9T7s6lpDUE0Zw07Dp0ocmWW2JScIRZ3QruKE6/lKcwI2ZYY3l3WLXuvnaH5g99I9aWRJ1Tsyl9AwqRCOPfk6kppaaSgGHKCa3L3+Ha80kZvMLtYPbhc7+BFKnCfEkoeHqrR2FUcdwfqfzoLDqlSj/D8KEtxmf2VXlSbt/nIUjmzEwf8fnT/0Z3g63WcAtSqEcsDLV6yp6/4P2LQPYB+ODJXNmHH52KcXum6xk1DcLS7hQk+yD5wGDFuKrXOE=
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
 DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	81df4779-fb76-4d9d-0778-08de754f7e39
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|14060799003|376014|82310400026|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	BdbQ0qwGxuG9LQGbfBUxUGG6a7eecFvYKz93z/S/cu9ozV8XaXEFIgmI0lg2KsyMSXo2AExjrltiuGVVB4UoS7s/pd62Li8QZhlTx1vis+7DCp+crAG6sbJH/lwoHAPn6DDTaX7UKZ+TlKR+86j0VlzzXKBnKwvCTw5NOE36VlcFao+c68Rff/6Dtx+v0w4vPNKDW8uuR+g7qBFXNhOz8ee44vUhvVYHJz6dCo7nQTTb1fqD4MB+W+tCiX8HKeGwmtT5YkFMBgy0LIbFnHCFMEZk+1ouAg0IsiMUtiMSQAixyktCqn8vlhG+D8dzeuOrc20hMRUvIC1//jscFKxRdkfiQ5xyxOCzz3X1SoMgaMFa4gwNLJuxciz0uyJniQHloJUvpLamswLZDkY463m9xpWOGE0l4LIfRO3h1mdMGU0w7DmY+7Ou3cmC4bOp/y+qbR99vx5qm114o/GmCBUooqupjQSxYcKs6k6F9fSh7yj0RU9CQk5JKFcQczDhHmuXvePUhMDeetKOeac/2kzkYY+RpappKWKmbSIwUn1JFeXSENdhfzdw0fme9vcv/6hvfJ//8kzN8kYlkuGyveR0Zpk7rHFaSTGESwdLUm8bUm3cwDg81drb38+o31YATn5+aGhNGSlzeuwWXRAdWaWq11k1+Op7VBIryFxF/2AONaL1yfrJokNOTGFL7ejElow95Qc7A+ik7kkeAVAyo7se4yh7GBxhf1KCUlHyXf0uPihophId0psmg/eEh8NN5qyO2nM6iwtAzN03wnZDNTEaaDOxCUgTZSDxRqDFFZal1xvboGU6PnoxG6GW1iqs70V5FiQjbjqVq73yvB8eeLEVsw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(14060799003)(376014)(82310400026)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Tggx69Ea4t6BfjUcyTeHTf69XtEnDVfqeQ7JREo70dYn035E8V7YycydyHX7mdwGCCQ+Fc3H6LT3jEkOIrHJyLIj/fYbna78rDQBYBekQ2w6wN9Z+tTtDWuXusTEuCvIDeQ9Pd83xj331j4fFbAjxNFB69AZMamJCEEjEwJwRpQLLbwYNv0X8IWCsGry9gBUiURBGjoZh0XIamX/a++ZxkRBOP4PhpQOJ0jaiwEAOwbX4W1uiVaR9s2Y13pmEQwPtAzNdkP6yNtsu0tNSACmBmaUjDd9UKXwLrjtr1P349my2h/nujkuk9i+wdIxNP/ts96oGBtHEwzLKubi9w4SFH/X9JkZk8kmEMd/XkZ76cYhZfa8g76dmGUAmWc1+AkFOiAhqYqMcKx/UGh+fihshnhbE1Gn/uT5OrzvWfV8qZVKi4SDyO56g2vSkr2UIA+B
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:56:44.8866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b0cfab-4d71-4e02-7003-08de754fa425
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E4.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5420
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
	TAGGED_FROM(0.00)[bounces-72016-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: 4B8951A9CCF
X-Rspamd-Action: no action

Drop a check that blocked userspace writes to ID_AA64PFR0_EL1 for
writes that set the GIC field to 0 (NI) on GICv5 hosts. There is no
such check for GICv3 native systems, and having inconsistent behaviour
both complicates the logic and risks breaking existing userspace
software that expects to be able to write the register.

This means that userspace is now able to create a GICv3 guest on GICv5
hosts, and disable the guest from seeing that it has a GICv3. This
matches the already existing behaviour for GICv3-native VMs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a7cd0badc20cc..b4e78958ede12 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2174,14 +2174,6 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu=
,
 	    (vcpu_has_nv(vcpu) && !FIELD_GET(ID_AA64PFR0_EL1_EL2, user_val)))
 		return -EINVAL;
=20
-	/*
-	 * If we are running on a GICv5 host and support FEAT_GCIE_LEGACY, then
-	 * we support GICv3. Fail attempts to do anything but set that to IMP.
-	 */
-	if (vgic_is_v3_compat(vcpu->kvm) &&
-	    FIELD_GET(ID_AA64PFR0_EL1_GIC_MASK, user_val) !=3D ID_AA64PFR0_EL1_GI=
C_IMP)
-		return -EINVAL;
-
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
--=20
2.34.1

