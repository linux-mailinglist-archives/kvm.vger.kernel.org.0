Return-Path: <kvm+bounces-72047-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHX4Lgl8oGmMkAQAu9opvQ
	(envelope-from <kvm+bounces-72047-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:59:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BCB361AB83C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E94A03147312
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85339481FA3;
	Thu, 26 Feb 2026 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="d0ZXxtt+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="d0ZXxtt+"
X-Original-To: kvm@vger.kernel.org
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011021.outbound.protection.outlook.com [52.101.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA0A481FB9
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.65.21
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121822; cv=fail; b=Fprll3BxRHrfyosE4TGgtX//wRuKO18HTeNWxk/TaSITkl3OSTl2cYGZRnD1FykE6wnAuq4LFstuKt8TiO7DN0OY2ulejgVNtjKE1Kv4qW2jVX2JNwtKAoVwQ4OQbXa/81aTNiSSdha7gsyoXAVI5+inNqvoQ/sGu1A16aK1J7g=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121822; c=relaxed/simple;
	bh=+MHIF5c+2vRDKKGrJcQFZrxNJW1Z2TEyEwmeZseogyA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R/HZRcK8rI+tq87GqLugAeclCD7F765Gm2UwpHB/3vz7spFwpouCwoihBGRJJSUgOAsdICFIJ7LADqL4zA721fD1jQeLwxRvcnof7gh2RaWqZqQTdPVvTXcIf9JqwoCkAu+pNcC3IeoAEn0J10/a45YFRRzIR7sSTXdj6YzdY6g=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=d0ZXxtt+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=d0ZXxtt+; arc=fail smtp.client-ip=52.101.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Y7mGc/cl9yxP7+Z2KOzpu6ydv9xy+MRwb1RYDuXToGWN15Djoh/bLvLpJa3zhp4xGYrK/4mzKrJyWFbwGOM6t6h6rITTvuKM/+lgBwlkB5ePOIPYCUT0Bi1IfKujyr2Kg65tqwgNEBEcHp0l4Sp/BNaGEiCrrKNrMNUn51+LAh2qy6G79wjyXLxEDAsf1yaaxDve5GEJ3pr9VUQxn9S/dA5G6OvMlMHj54Copxsn8MsudM3FJY/+SrpI5jhDV4zLb6IfYqJOnk3MwhtBtaKosf1vZbCJla5TvXV8pLcS7FllMu7wJvrWDEDWE7twWSMa9vIrH6Q8szqThDXOiYKEMQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=P9A2Cf+kwCaU3vmNj8jhfGuKubsDwLsdfVDye4J2/nNSBj8iQzYDsGEzi6jfAc+lWu6s+bLWlMyiLZOsTjHVNbX8wRFNGx02uFsdE5ybhwBM4Gq3ckMQlI/7sV/Pb0tQhwne8gXLkqcAmDb6MVEUy0Xt35l+8mg/9lSlOGcZGb2iAi9SbvJeDvWxAqtc/k1cm3x/dpYX/l3Hghr3QJZ+fD2GDPU1ORgpIzqaq5zqWmTcz+lsKcrCxarO24gCkqSzOfA9MUEMxz77l8x9iPwfWCFlvF5KjgG//JEhVZfPR2Svq1zsu8b+nRmlH6FT6e+MjiNlciGPYs+niQ7Nb/phqg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=d0ZXxtt+JZdBeDiJvhQKRHb7bdmhmQfxWHPws2bVd8APpX73yT0tM2dW9xs49oW770/8UfH2a8UTstkQnM0EPHxCOzFuu7970PXlVpdQkrFeqmGiE1ZuUl4PQ74Tk/UWnmOBcNh4EMJoKW/ei7U5zwOgoQR1AlmPUi+tsd9Nxjk=
Received: from AS4PR10CA0014.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5dc::18)
 by DU0PR08MB9933.eurprd08.prod.outlook.com (2603:10a6:10:413::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:03:33 +0000
Received: from AM3PEPF00009B9B.eurprd04.prod.outlook.com
 (2603:10a6:20b:5dc:cafe::ec) by AS4PR10CA0014.outlook.office365.com
 (2603:10a6:20b:5dc::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 16:03:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9B.mail.protection.outlook.com (10.167.16.20) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:03:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mC+bIdfNntxSN6el8yh40JJ8qOq1wLmYE6E+6TArkzOswFLFU5rugTbhOAfSwK6wjqOfvDJT1ubzX2LPwH/bPGvIFyPmnYBYiujYggavtCOxMTvnPqUF4psSGkGgtCDPZyjqhSFAhN/qczC3Hc4IZSle0qtB5TdIG/v2kyKMtiuibsp9XPybebwZG58c2W1ucYweEswwdAmWMynDroWXrLyngRjVZTb782zvEHC0y8rjCzcLerYy/dZg8a5VJslchkBtunHi7eGUGVJfNfkDPDodMQq/sdDMcuTSTcFDCiXCLkcX/3j/9ZtCt/hI10XkIuk/8/CsM0yqXnqnsh/qUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=oBm4DvMnwiSlWichzUr54RMxPCggSUHGCRPUSitxeRAWIuOnY/r0TxbTiTYxQH6iSVugtKPIrC3hkoPVfuxdKJiS7W/au7m50G7myz/Ex5+5yLgLzGO8d8bpk5oo1Lkey0iB5vBampaUxmVWtgepC+BfD1Ejb7LjLL6w8NV0yYpV4H9/QTsO6llGcLCiu5wfpnFJUN9d93pR7PYrwb4F2ZhJd3eKPpQTZSnnCEMhpAJiZQA/zw6arLule93n4nnePcgAjVy45oYeVSpLtmGSl6jf7LEb0IUo4V10vkvSQbCs4go/JkGWewYrIzfJGp3TMGXrTx3EyyY0A3wLoeIw8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=94le2e5AG7+OHLdV7IRBhQl5LdK4lkqGHlEEQ6MWqyU=;
 b=d0ZXxtt+JZdBeDiJvhQKRHb7bdmhmQfxWHPws2bVd8APpX73yT0tM2dW9xs49oW770/8UfH2a8UTstkQnM0EPHxCOzFuu7970PXlVpdQkrFeqmGiE1ZuUl4PQ74Tk/UWnmOBcNh4EMJoKW/ei7U5zwOgoQR1AlmPUi+tsd9Nxjk=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by VI1PR08MB5486.eurprd08.prod.outlook.com (2603:10a6:803:13b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 16:02:28 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:02:27 +0000
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
Subject: [PATCH v5 27/36] KVM: arm64: gic-v5: Mandate architected PPI for PMU
 emulation on GICv5
Thread-Topic: [PATCH v5 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHcpzlO7UDrXHzwn0G2bqlgzoy/pQ==
Date: Thu, 26 Feb 2026 16:02:27 +0000
Message-ID: <20260226155515.1164292-28-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|VI1PR08MB5486:EE_|AM3PEPF00009B9B:EE_|DU0PR08MB9933:EE_
X-MS-Office365-Filtering-Correlation-Id: 212ece52-7621-4f8a-019c-08de7550974b
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 bQIJjcxrL4XmR/dG01B2ZHprn/vIC9MajHggdKZCRlTJ8tN6VjsxkfanoPMUTsWf4evjtgu6sTBlidMgnRH9HWAe7dDGXVQndau2UTP0IrnD/S7tK/TMEQJDtf+Tnb6+ZQpR1KDh6IvGItm+CZPsqpFToiBD1SzM2buFjRXY6pTrtAcih4Beg7M+zpHdLDyUXaTrAm7THWWtGDNPU1B7fA2JhyLLLOLs2r1Uz+PtaSB2ag+rHsR5qKU/fa3iM7Xk4em1CsGrB0lf/h0p3u+XX8SAd532WF8KMhyitRjdCmY602mjVFKYGUVorSVEg8lOM14xR54UMWopUsNohXhGqmIPtxzbdlRFl66h/0LlMd2HKDgSitqLqUf46UO/8OOn7BWr5S1cNNDnldt+q3i6XAs0zrzjuy/q1YXBAzii+5LKDmo+WzZXd6tYSpf5TdbgjgdSZAfO7EYYnsz3gNBdpdr6uXmcjtyzVhndcETDAVXorHcGRoRzkGM1H3w2Y+MPViD87bT2vjxH+irK0rvJvc8USbBe9xiW/VH9yGq2U5xKdsNynHYzV20Xug76tMB6OxemSh3eAowLQkeGzNjW2aIWGm2mXjgg4m7lfmEgO9bKFTFp/KHZyltN5qElS10I3fhIhp4ONb9w4MK4/MHGGjnVGA09YgkYYvTXSVM9gP/sIMhQnYVRp8XRWufsRe7nclKwFWqZAMZr96/d3/qmQiHO2ZWMGplFun0ga8vuEO71UTQkptOuc78+t7XQeN0a/rO8qVogfr+HUOJ9uSXcxQnu9PK/LQUzi1CgBSZYXJA=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5486
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	9cababe3-a5e7-4bb8-66fd-08de75507084
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|36860700013|82310400026|35042699022|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	cqoWxYjJknfRpZJyffQbSwZGWEQBxEjhYnAJyPl8pG1Q99NNYDJZg7DvdiZZ2j28zHVBPxwFjxfcvCNfQz40hVvMjJE82u1d3swuTx5fqZjQg+trk8jsrvvPzEVZfQHNnMp06zk227tBawukNJGeqQwF/6UC3FQp9CzifeJ3Kp0YgzCTjUOWASSsiSq0QowWyAuiL+pcBWCkUsvhh2IarLJT+uvq6cW8xFZIPuNBRyb7LnohabI89i4tpop/QmzxTe3qD7Sc3gkKP/mD0jA4nzj38pztRVuWy905aEPbveMezfDsZwDy3rK+dasDHbGsNxArtVpwShoKfekLsGJeyDSB8TS/FeY+1W1otNGzC05yFAcao9LiIQKcdZn+F5kMJ0Kq123aeM1QR370upMD7cvAVsrTUplY+82N0CV7jwc7nJsUqcCeqOndoUaVIO9j3NL32CXjcJgycat4R2sZcBkQkjX6G/1FYo/roNitykkvQQdWhcnQ2FHo9l4AEJUCsM1DKua9MqBywBJXyq3S1437v5ArWdVyE2o6UbUXnoftexwBHFPPa5C52zaXTYRqAPKq69EJyY84HqZieebcywMVb1PEDFLjw4+0Bv0Uz1p++q/g/JzwsQFB4N0Xt0r4xmtcs+3rY09XMgobuZtCBWyjcKt3FNxeLK/sJOiaeTftUjpCs8LcHXAHmmImw0qbUi+syzue0Vb1sZOdt4jY2mrEinrrtryOQy6kxOAgcQd3Cx6ZMCI9GJtmBDweHUvzTJd0vW4hFMKXxpc1AdRxsqgT+Ki8R6QGtPrnAoASgDUJiBN0Kb2RjTZS5WKSzDN39CoZHWgosphUsOF4eewnLQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(36860700013)(82310400026)(35042699022)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	MEzEMLUg42QK6QzrzaxiudgfFlbUR7UhgkRIs3kTDrvhAdZbKc+R4CDuqDJ2S2+mTJYOnj9edfC4SMPrXS+gGK1tZV6ncXcd3sZppE/4Z7cCiqbae05eeOFzWJ4PLSD1lIgZ4dfBPo7e+9GJgdKUT1uteRN2ptW07NvILYr4onIZPY9hfeZmzCE17RwbYAif748I/P8eN0bLEsq3uQLFfDb/gyl6XGUWtXtPHzQs8lKoPWPPBZsURJNfnND4z2H0qPCWH1H9VKTEhYO73orfhPGcsFVzLR/Ozhgo3vUP46Iawp+fugwMqm7qcypqk59iYlBnmdcDim0WXxzyd2PgQxnH/e1I/eeSgHTPv3wg6GfQw1KGxZsJwyvG4d0/ldtpjuTnogVkY4pv+kxpLP5/pGnFPTWLvCSUS4sYw/QNYI7bTqT6htkgWXeefDfIcgzA
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:03:32.8415
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 212ece52-7621-4f8a-019c-08de7550974b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9B.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9933
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72047-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:mid,arm.com:dkim,arm.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: BCB361AB83C
X-Rspamd-Action: no action

Make it mandatory to use the architected PPI when running a GICv5
guest. Attempts to set anything other than the architected PPI (23)
are rejected.

Additionally, KVM_ARM_VCPU_PMU_V3_INIT is relaxed to no longer require
KVM_ARM_VCPU_PMU_V3_IRQ to be called for GICv5-based guests. In this
case, the architectued PPI is automatically used.

Documentation is bumped accordingly.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Joey Gouly <joey.gouly@arm.com>
---
 Documentation/virt/kvm/devices/vcpu.rst |  5 +++--
 arch/arm64/kvm/pmu-emul.c               | 13 +++++++++++--
 include/kvm/arm_pmu.h                   |  5 ++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/k=
vm/devices/vcpu.rst
index 60bf205cb3730..5e38058200105 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -37,7 +37,8 @@ Returns:
 A value describing the PMUv3 (Performance Monitor Unit v3) overflow interr=
upt
 number for this vcpu. This interrupt could be a PPI or SPI, but the interr=
upt
 type must be same for each vcpu. As a PPI, the interrupt number is the sam=
e for
-all vcpus, while as an SPI it must be a separate number per vcpu.
+all vcpus, while as an SPI it must be a separate number per vcpu. For
+GICv5-based guests, the architected PPI (23) must be used.
=20
 1.2 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_INIT
 ---------------------------------------
@@ -50,7 +51,7 @@ Returns:
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
-		  number not set
+		  number not set (non-GICv5 guests, only)
 	 -EBUSY   PMUv3 already initialized
 	 =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 41a3c5dc2bcac..e1860acae641f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -962,8 +962,13 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 		if (!vgic_initialized(vcpu->kvm))
 			return -ENODEV;
=20
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
+		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
+			if (!vgic_is_v5(vcpu->kvm))
+				return -ENXIO;
+
+			/* Use the architected irq number for GICv5. */
+			vcpu->arch.pmu.irq_num =3D KVM_ARMV8_PMU_GICV5_IRQ;
+		}
=20
 		ret =3D kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
 					 &vcpu->arch.pmu);
@@ -988,6 +993,10 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
 	unsigned long i;
 	struct kvm_vcpu *vcpu;
=20
+	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
+	if (vgic_is_v5(kvm) && irq !=3D KVM_ARMV8_PMU_GICV5_IRQ)
+		return false;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			continue;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b4116..0a36a3d5c8944 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -12,6 +12,9 @@
=20
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
=20
+/* PPI #23 - architecturally specified for GICv5 */
+#define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -38,7 +41,7 @@ struct arm_pmu_entry {
 };
=20
 bool kvm_supports_guest_pmuv3(void);
-#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >=3D VGIC_NR=
_SGIS)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num !=3D 0)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 =
val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx,=
 u64 val);
--=20
2.34.1

