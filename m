Return-Path: <kvm+bounces-72021-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eIDyGfZxoGlZjwQAu9opvQ
	(envelope-from <kvm+bounces-72021-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:16:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A88A1A9EA3
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:16:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 46FA131894BD
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:05:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7789543DA4E;
	Thu, 26 Feb 2026 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O44QFqHW";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="O44QFqHW"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011060.outbound.protection.outlook.com [40.107.130.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDAF43DA40
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 15:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.60
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121485; cv=fail; b=CpiJNgg+xnMm7Xcy4wjdLWNHb30QVR+y2rzknwipCgA+QiGytA0ocYlF5DIPL89QPtidfu7Klz6ebQnxVt8e20UN5aQH5lKFIO42l8aP3Qt6XH6x+EkfMgXSnnCaVAdvfi9yx6JrD7b04EGyvifUP+eREuUaP2kWb/qv5Wb9jAw=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121485; c=relaxed/simple;
	bh=+KBjkRPkU1zI3s8Hio3H1SewMKkzcBm1UX3ngKu7Hlo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JLK6DDUZhplo1v0BjSWAxYgXGbliAyifNorj0mW4cWXrrwQPN7skIp768RwvEhu1CoNhM6c6c8S1Pf8zOvR82Op1aJ/pS/fvtO80Fz8i/aHgwSd9cPQAfvQZh7bE44/Q+oSMPInMT/OpgUAAuS3YCt3oWGwhu0ck62Zp9myQmfg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O44QFqHW; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=O44QFqHW; arc=fail smtp.client-ip=40.107.130.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=fxNkN7t1EA2nw9z9vGtkeGsrNpsR7bmiHhkPLjKLvmEb2xdb8i0BdfbFQnfxvY0w1l2Oz70wTE7uTMSVa8oQN5WEVILpPK4gUDueInzc6+KnKDMFnRmdrGDWl22paphpKV9X/V+P2J+KmJ7bsq+vFmMEkYTyo+aymLonk0+7DuPBRZGflA4eaCv93FLWC7n44D2YTvbRdh5H5cLwQr6UAdwHQuaIgBr4hSciZa2yC9c6sz0JuYG+lreyKVlUU6DEkEvOQc7/gruDUkiylA5wi9/8f7g6EE3sq0DcyBDcAeTCGM6CIpGndBzrSQWVVNFlI20/+o7TqmvLASb2HoAjQg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=FUyRBSWbK0RDwI3TH68LPQbbTutIMxMs6sPAyhe+ARyc7hytdru4mGlPuHBqzORefqMFkJUA1sNgGq0/VyKRV4DPnsCYkOQdDl8s3Hag63vDsS11ALIQIA8jjr4nDyJw2QnJ6OuM3Jki2LItV/l9eiebO0KVD9T5Bm947OAQNBVXyWJgwJbYrTg1EMfL609GD0Y3DNRINmQG9Pf/hZjmwg9XYdE+TO4tTVR41OZ6loSQy4JnpK60GM/HbHExudUqOEZ/pZH1QkKq7TL0KjixKiPAu26MQ2ISgIbjSew/fFbJRYABp3qFQvdkcSpqxlNCo2TnXUV9d37f3MZN+6PptQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=O44QFqHWqntdnDNswF0cd530yymdXUDi3tUBCes1w/986BRmYNzRVGrBH5wdYRIlwlA2lxW/SB1eGhcEafwRRhFPPpYqh6aTfnG786Dv6zpy3V4MeQ0jLUYLrc5x5Sax1NL0FPfEcWwfKoEh/2uDg18V983GYVs+PfQPp+J97Ek=
Received: from DUZPR01CA0207.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b6::9) by DU0PR08MB9345.eurprd08.prod.outlook.com
 (2603:10a6:10:41d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:57:47 +0000
Received: from DB5PEPF00014B8D.eurprd02.prod.outlook.com
 (2603:10a6:10:4b6:cafe::d3) by DUZPR01CA0207.outlook.office365.com
 (2603:10a6:10:4b6::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 15:57:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8D.mail.protection.outlook.com (10.167.8.201) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 15:57:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WiAki8h4CjzkfyU/C8xhv+kQ5l8jQ2wSR+PlPTGaBO7LNYk0J3dzl2mC1iTE6PFrwIDuj/4Z+h5Crwjua+gJn2nyGNnGZFoYAcYssHk+8L5sIVXwtMNU2UvmOq3qDBkXI3hfZfL/GC9PBTaRLyJJ9T1dsEDey+B2B3uJeu2jpmwxj3ptkSYJ33speUYcLxCyFUYDXSuQKljMalBpsTgvRl6FmuTkvEeDCXH8TB33TebsTlLW2Ny3K4XcB8yBLnOFkf1it+8A6LQq4aydvnHy7Xf+MYmMuMiUMLYw+FZk+2ac7/BPZss9IKxkEUQCWfmu0FEEHlFYvtUGiD4JIBruig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=YSOkngQvTH+o8M6Fwf1LUEwr9jfBpDrRj9oiiZ8qYnPrpLZ7cdHpHI6luEdPY9Xw9ZbK/fPPEPDBybKISDVd6vfyXj3Xl1d7Qajr2xPkoBmHU4qEpGgEkm6tzHDNIFv9e24RAIwUJiUohZx84IVnydlQyyu8xaGNFXiG1cBiyJr9N4bcc3dxybr6J64OrY4s4kQT4Go8z6d235r+qvbagoHKrr9/pSD32de6vibL+SDyMGjo6UfEQ7Ps5/Ntb4VV+nyuE18hL6xA2gYgtjDWBGT7YJbSFmUNU4l4X3UvVs9cxlyMg1c3K4MTKxHpyoaKXqqhM6GTNS5/8LPuDa+L8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=york12TC09jg+xZot57onhEHAYjf0bmvNPz6jXfjaDs=;
 b=O44QFqHWqntdnDNswF0cd530yymdXUDi3tUBCes1w/986BRmYNzRVGrBH5wdYRIlwlA2lxW/SB1eGhcEafwRRhFPPpYqh6aTfnG786Dv6zpy3V4MeQ0jLUYLrc5x5Sax1NL0FPfEcWwfKoEh/2uDg18V983GYVs+PfQPp+J97Ek=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PR3PR08MB5819.eurprd08.prod.outlook.com (2603:10a6:102:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Thu, 26 Feb
 2026 15:56:43 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 15:56:43 +0000
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
Subject: [PATCH v5 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Topic: [PATCH v5 05/36] arm64/sysreg: Add GICR CDNMIA encoding
Thread-Index: AQHcpziAUvIhzgy05EesGLOwdYLkkw==
Date: Thu, 26 Feb 2026 15:56:43 +0000
Message-ID: <20260226155515.1164292-6-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PR3PR08MB5819:EE_|DB5PEPF00014B8D:EE_|DU0PR08MB9345:EE_
X-MS-Office365-Filtering-Correlation-Id: d2169bdb-9374-4b54-062c-08de754fc8d4
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 PqIccU6QWNc6WVwyf9Jax6hux3CkVRSaiG+erFYf53MxC8/fKy3AUz846dtmdkdxFM/oiaqT4b8sWJyJKkh1XAlBMU2cEBuf8KkBgBJIMMBBAEzJMrzFm8TJVATpLQGHSwFD42tyrpON9S1HO/JmdJ0wxxKvAQKN+UeQvoB8lv1q5kMBTaHgOdqtTztYx7/AaGmpTadbUFth4rhRpSJGyC3RhVIEATzoREDDnhFHiZbfPnlJedJJUhrxc/hBG05zXwEAc+cb5A+KVKIf1z576x/fOH6CkXK9esNyfIbXpED66Qeuahou/sfwSJPMCB9YlXgEdmeAmv+Idp249/H/8G91ylgqQVEEWddGlwAeuCOSuqqc22oRt2in+oymPIkON/I8t4TpvMjns3BmjFMMk8I4WjpiYp/1o6z/Szw3N58sMNGOGjq3YWdB5Y5kksm8DKYiuvaw2d4DYIK4ERqJJC1UKvYeKTUMMJLC2EunoZ/b0BEJUAu5XMKwK7mnZ8yyecbSfxNp3IvoEoBuKk7sjVcl95gXaJBOALOvxYdRZtmk/YGIdjOSyM+ZMRSar9oNNBm2jyWRzIAZs9jVOQ3UF7nt4EUqBxlET4ooZLb4F0zJ4rA0mMXYlMXsBe9HkBe5soHcwklB+bhIGhjUSLtEQ71Cv25MHajaxIr6mNd4EOJ7cKSfGn5S5/mjKY3SCPnnrGRvLhwNC5yXrGN/U1IwQrvo4xtbyLTM5NLyQ3P8fWWdpQMUAtUNILE5xXYZOBgqfs/EbiGJ5A+O0jyqE5r6/VfTTpToJq+fV1g1PQ53OiM=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5819
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B8D.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a25b6ddf-730b-4b50-819d-08de754fa307
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|35042699022|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	zp9zY6g8fPtynlhyLJdkRnXF/MwIWAioCvGXSvaImqjxbu14h/09+OisCma7RNSBJi9zvSrmfRMJsP9IryFQfbo6dUxGCScRWF+nZbjOaNT5fD5cNrJV5D9aWt4SuMqzKF2a/xyo8FNz+DE9YPuHaJDYQOaleua8qd7xdJm+vghn2npCAFDuf9t4ElZksZCDExFPZveNd3d2gDeVnTfInEu3dwb6FB3iu4xO0uxtBFS3lTS2bp0zNyTUUOziCuuSVJFJTFkcKLNkGaDG0cp8pqbiASScBw0eWx4i3nRskQLW3FOg7fFHtRT02RpDeEI2ruKHpyqaJ59wGP4r6IRXoULXG4QvdL0EPw77XroImCTB0ntx4Zg4Q9KBSqOuFZaewiQofg3i/AnP92xuYxmuGMbAilRg9PPxuxkKX8pE397VVLQ0RK5S5+CJ2EFB7kDy5NAg3knonCDFWkT3HIFz6syecm9Zm10CeeVk7Ip4tSXItJ7b8eyMtuVgOKU7RCDIvgAbDNEHbjhRfOHmz1z5b1UoMqXPHhklng/rNJc65z+OItjoOwiRoxx12jd0ax6KsBrDeZYh1YCijteRSWPwNJWXLqyyuDAgK7kXpXsMCEzHdSrnz0U2a2/0Xz1wF8oC+TldKoUMhcJWkZ0GIQLq+HF66U/iq1CQKQ8cu9nTzbHh04UQWqW2pSHZR8mw0Sd22zJ2+2yNtctZyoGVXtkyl0K+e6H3xk0bNfg6lvLX3B+xu/SvbGq6tAP/gDkaJX3199TdMVPoMtOSwEbJCm92U38J5Ac7/7sG4ETuZWtf+w8Y4sZJPZP4iYHoOAi3Jd79UCydgko+jLxfX7TOSSAZIw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(35042699022)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	j3Dx2e3JIapxidOQe5XVJk9NQAE20hxSHsoQTxfg/QLTe0kjEP3eLlnHZh6FB8+X56oksliUuZxkM/jJdt3xeeEb9K8qLRg49v6jvnfIBkqwQBngjATj9cJD/+FDtIm/LVKQaxrSZ8C37BEOVCKEXFG646+C+hgM9XXFChER2lbwm3xjF+1HVZ0RmkqKjjjLpzdESOYNBzrz3AFWGMsbaawLGPT7ISSNFW3hdm4QsK8Iw3uRICtN75/7+G6Xbo5bFDmAnzNaQH1jg3qMduROVDJDDy1EVOIB9ex93fmiSaC2GYXTigOFbY50jP3zzzdfAqnFg+vwaSiE4XHVVkbJ2Cl0EVkLEtFPtdTk8zvdTTTfHb2DKRLhF6LwYm2bcf8YHdZ3m3ka4TDatjUshpxXJd0CfHilwqVUGobsHz1ypE+Y17e9pnypnIVCM9z7oYzu
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:57:46.4324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2169bdb-9374-4b54-062c-08de754fc8d4
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8D.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9345
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72021-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,arm.com:mid,arm.com:dkim,arm.com:email,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 2A88A1A9EA3
X-Rspamd-Action: no action

The encoding for the GICR CDNMIA system instruction is thus far unused
(and shall remain unused for the time being). However, in order to
plumb the FGTs into KVM correctly, KVM needs to be made aware of the
encoding of this system instruction.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/sysreg.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysre=
g.h
index f4436ecc630cd..938cdb248f83c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1052,6 +1052,7 @@
 #define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
 #define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
 #define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
=20
 /* Definitions for GIC CDAFF */
 #define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
@@ -1098,6 +1099,12 @@
 #define GICV5_GIC_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
 #define GICV5_GIC_CDIA_ID_MASK		GENMASK_ULL(23, 0)
=20
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
 #define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
 #define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
=20
--=20
2.34.1

