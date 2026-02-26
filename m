Return-Path: <kvm+bounces-72054-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4Au0HsaGoGlSkgQAu9opvQ
	(envelope-from <kvm+bounces-72054-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:45:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EF7AF1ACC3A
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:45:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A2F8734E5D54
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1753EFD09;
	Thu, 26 Feb 2026 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JibgOWbg";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JibgOWbg"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013068.outbound.protection.outlook.com [52.101.72.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7C04ADD81
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 16:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.68
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121936; cv=fail; b=GPL9254VmCrPaxEGuuHvUiXq08KlsMH4FWSnwqyvJl9ZLJ813x13Vlvel9EpTdqK5x0NlDcer7uqI2AsjnF7nldwAHI2ArPbTozlz70EY1q8k5Sy/8fx6TenZJPZKS1q6+2jb9HQgZN0jwg/rXG7EJ06mssM1YbvZ6dLpHkl1XI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121936; c=relaxed/simple;
	bh=8ihNjLtNQLPw5RN056TxhvR7Ejpym3u9u74HY4MwXfk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qQ9/r1DC49AnglwFYD7zbL3WIYzNRRUvyJLC5BAW/D88APUNneFDtMnYLcB41c8gmRLJ40IqplViFJKkjXlWnpnbL5uTIYB3qH+7gPoN7ONot+JOmwPvOVx8CpGdwB6/PEHyNkRn6ug5ZeTt2MrzF0wZ71FbbPxD212rV1qMmjo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JibgOWbg; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JibgOWbg; arc=fail smtp.client-ip=52.101.72.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tTY5mOe5j6wC9u9BJOhPKxlClU9rLrn+LUDcH8C8aQoSp3c+oXgCyvvhBwIf6+X0DKUi3vrASmuVnT5mc/0uY96Tpxl5d6idVAeOBB1SU47V8+Hk08eOAJj2+z8j6swwGTw9/moi6tDZfxDn+shVkvx0YNjOwu0JTxSZbZm+agB9DvlwfqOlwjcAx1i6bcJH8iHG4Rk0/MmukV9T32fUl3u4ZKCxKomMBbKI5ifLlcyzz6QFLcRnTakm+LmnRMer897C1yHKxpkYDlXTp18IhFETite1U45RldyvC0zesf66HQGMvZ5vkgCmQKwD2kzf5TYk0MPfVhssROl/4yK9kg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ltypx7kl4OQkz+AlMF1EqPhHtPSAkkziaOOnsMCNtRE=;
 b=NBMTRo4c/BEZKEFo1c2jZXG3JagQwqz+c04HfBZx51mm9rSSRHOZxdSASqHqv/aEe4iFbUF8gNg/LVjuAOkznOTy/KNGho/4UcF2iQ0REWOTFmECBPNJMGpM3YLlPxLYkuwUjWBs5s4TsB4YBDjf1CDzHa9rN+CaEG9oglwCaRaTPc/QsJFw3aHpDT6JVt58bAWalNya9h9l2ifS1P2FYPlavKcuJeI3ErFCSnX/fiONPoY3D/1tUE+0SeSLL1dYrcQXQY4psDxNDAN3GFJ05tnyg1vzW7nMZY4HKz8SI/Dr9HMOdYoO4neUzFDOcpXI8SbPFUGSZ5KXQLdonSJkuA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltypx7kl4OQkz+AlMF1EqPhHtPSAkkziaOOnsMCNtRE=;
 b=JibgOWbg2uTqzNqUbzPelKltM44Tx6LWGr0oc+xU7FYNA4e9OF0jy6JecLPVAM+9B6zQd58s8ipEfwzuNsGLlbi9Ho7th1Zqs8m2KUuEpvszo7qGbrgu8XJD7kwmFgFZHKWt7LyMUsjcD4Bxtf+1BDMe13CsOPQPjfHYn57DeE0=
Received: from DU2PR04CA0008.eurprd04.prod.outlook.com (2603:10a6:10:3b::13)
 by AS8PR08MB9549.eurprd08.prod.outlook.com (2603:10a6:20b:61e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:05:19 +0000
Received: from DB5PEPF00014B91.eurprd02.prod.outlook.com
 (2603:10a6:10:3b:cafe::d) by DU2PR04CA0008.outlook.office365.com
 (2603:10a6:10:3b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.23 via Frontend Transport; Thu,
 26 Feb 2026 16:05:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B91.mail.protection.outlook.com (10.167.8.229) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 16:05:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLT/kOZF2rL7SzGpLxqIH4MaD3Xin+QZY5p6SH2sco4isOlTuj7HP4gqpiBSlEU+Kn60J2Bf/bA3VEDUJT8AYfBCjOA5M60EBoXLKQnbxralx6SozTkZg9kVwBoZkjfTQXTimXoDvWrDN85/CgPLM+HuDNsxWWfBJu2Nf3F+Naa9UBK+6FN/iXKF8g/Mq6WcnrzekjdhY4luB6D2yPtoBApb/TbYhMdmkpF+5w4LWgC/QL7/kStk+cnagBW0gNCSZR9L1cmV4vJkF8V+FylihZmHE3eVk77pz/PsjjuM4t8HT00CvwS3QxKU9bhyfb4VfEPybt2J7iFmZ26ccKdx1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ltypx7kl4OQkz+AlMF1EqPhHtPSAkkziaOOnsMCNtRE=;
 b=VUyt5QculII6hXJfthpDUhssZfeYvV68pmdBg7vApmGy/5/5/A+HruZ5KzKgD+gHppQjvDw8hqHrV8ivvQjs3sAIRveRCHk9sBhSzRYuBjP0sZi1MgkQI1PSg6XE227MxEEs7BTTUetdy1JuEWGWu/omeSF9tbEL3Dj2qihKc7c9WugKSen8SeSaTV7xEhmmj012YOtTTduUrtEC20b7w9dwWreAC64Xal7YeYcLPd6fxxY5Ua66eBnY/cB0upnbMDQsWVvqB4zxaqt1k06dzxhoKCpLyg6JKls0Jv2LXc+WjI2pNiOVtbRllk/OWfrUb9huB3YHGJNgviGAiQcmYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ltypx7kl4OQkz+AlMF1EqPhHtPSAkkziaOOnsMCNtRE=;
 b=JibgOWbg2uTqzNqUbzPelKltM44Tx6LWGr0oc+xU7FYNA4e9OF0jy6JecLPVAM+9B6zQd58s8ipEfwzuNsGLlbi9Ho7th1Zqs8m2KUuEpvszo7qGbrgu8XJD7kwmFgFZHKWt7LyMUsjcD4Bxtf+1BDMe13CsOPQPjfHYn57DeE0=
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com (2603:10a6:10:1b1::17)
 by PA4PR08MB5950.eurprd08.prod.outlook.com (2603:10a6:102:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 16:04:16 +0000
Received: from DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793]) by DBAPR08MB5687.eurprd08.prod.outlook.com
 ([fe80::7d4a:f17a:4cb0:9793%4]) with mapi id 15.20.9654.013; Thu, 26 Feb 2026
 16:04:16 +0000
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
Subject: [PATCH v5 34/36] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH v5 34/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Thread-Index: AQHcpzmO8NG6Vpm1fEaoAvXc7WEOnw==
Date: Thu, 26 Feb 2026 16:04:16 +0000
Message-ID: <20260226155515.1164292-35-sascha.bischoff@arm.com>
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
	DBAPR08MB5687:EE_|PA4PR08MB5950:EE_|DB5PEPF00014B91:EE_|AS8PR08MB9549:EE_
X-MS-Office365-Filtering-Correlation-Id: 57b7470b-3974-4a1d-e53e-08de7550d6cf
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 HfuJ4dYCiHUnFZ0cWk68Kmr/60ctHOGz/oJKyF8SYm0NxYWwN+zhGgu/hsFNj1awsP/bRu7GabZcx2sON30NOmVqrOwBEzIOa7WkH8XzR5RrFvX0vsq7KL8l79VLa52GZuqePRdZantLYEok83mbUmQzYOb7wPeXKHbfFbIBynJPuIiWSpzuH33zP2u9xTA1g7CeABXlgDAoTXfyaAHtumSXJl9bJlDmNgKdj8jYPm6iwWVC2nyni2obU49XwJBT17D2S3JjHskm3cdFetsT37OF1P9r/mJph4W2w5Tl+RHgLz5BUHAe80v/LSVXRrnJpQF46DWKEqKfSx4KVdVc8wlkddRgRLpT/J2KOProVE+ylMn7CunhlH+job0Er7Y4aZfUdpn6vZ82oaiQ8HlXV5V6EZtXDUR9zUmC941hhBbQ8rW4UIZC9R3tfZL6S1BL8WhztmYJMyzw9TG6VzAazmxLMijFvJgaG3UX4R5QNR/jmnOM260mEkrR6ZWvf+ma/Fy5F8tr9h9Edu94WwLdmgiwINGOfe9+AUr7RMygkQUlHChQaJ1gq6gTJk8JR3lfRCG2uv4udixxSzAZD2uH807NRLtCLxqI3A7OEqVkqroKgZ58c21LOymZRuxAkIesSR7Dq5TilFd0s2qAX8VNRgH47X72oHfk8yt8x/5kMEGRDhml37DVTrhmrYj2z8KLLG9/lixnGzOOXJkpB4uV1hJsJM3YoGyzPp+LSIg1KLlJry3BRgyyD8i07WstEouzFdsvMPWLaQTqWmI+w3uCJDcfQuPA3tZEbfporTRX2MI=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR08MB5687.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5950
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	dcf98171-6eda-4edc-94c0-08de7550b12e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|35042699022|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	x9Uh5hnsSSrIZoov4jMLXYqYaUi9S6fyO8fluOklhVs8ToTeRVqYTaMyDizEbtrA/v+ekphXvOVa2oC6bnfy9JTrwNYBMJ0DZLR2qhsjvcteK8XWgQzksijkfSQ0dBc8w34pSLk4VUrZmbjU8+rW9EvP07SbUKx337KrA9OIFkOgXuEmmlxMo9ld2jan1DW+wNwUUtKw6wovdaJlJv6H34L0zqo/vUZSFlXGE5wgFWLBjDYL3bCfzWOo29OcmHz+tm/0ZnAa7qvH2CCyREutbq03RBd3Bt1fkcvd6jVPH9hOPz+UHkVVo4KXkdx4fKW/LHHzOJcAfsZNedto43QVr2uCOvI40CZv1xfWQ/zNRthQPfeXuMkMNscq3aZsweNC3fKhfwJcAxgvIWuSx6MgG7gxgENZrlC13DyrEgNG/PtmtClqZ7mcx+GF40Yhg6zFxJbr9/iblOaD3dHGDpFbcP/KCDRLLXDH40dj+Wvi202Z26ko0gQnhi/Nt5Ua+cQOlX/eliJIfovVzBRNOTbHBD0rC5lI1xCzpf2BxRakgsrhePEBQpYWVy/g6/GvNNq/nQLPFVlYbtWloZtDC+Xq0m982vs1eQ2I6s2VMLlCGFNkCR4CKj6HGFMJbyz6HhMFKnRcVxpdtbSCRsVlV68PNLvWF34fRzxyZBhZPXt6sKbfyiuJGSdjQlVmmQDEOGInQ59YZDzMdIdzhhNHme1K5Fk+NDsJrsMYOXlCRJccj/L2NOOPMr/kVuZwilGS2Ssh7xlb9uAkGJcTKScaAmvjGcC6Nq3+9ucea233dDc2cLbZgfgopI+ru0XaAPPGHQ49EcbnnUKRt6iy6WJI5bkYww==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(35042699022)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Cqfgef+lj1C1xhbi9WCqrqVMULAjiGnfbv5DV5hubzbBmF81G/FmaJ88R5fuOiFgTb5LHbN1cT7Hynilr4Mp7g0wIaVurcbQvksGxhBNCdJ0e8p5fyScS9TsoL9WAZkaDJKTBw1vzPyBUCINGOKiMMUR5AvhMCLHKH6d4F5NzBEluB2jkfx/AMoJOC9VT4y6vCQgzuWv6uXoFHke8DSeVv1EWYaAm5Jx4XsXB3weiH7LQbhyhtgDqcsT/igoC6G+3mRsPj4rQ66ArK4OcaqAMDASf7gyjrHAuoS1nwxKuhZO/yUIB6hg+ykFjTv0nqPEX+6EctEHpC8zMu/evB7XXLN4NfRM5inwgBdg1pYn8QntGWyhSHPhJw+DtKb5Aw9CrETYc8LQWMjBihQMA6pWoTGT87c0OpM3DCQ52kulo2SEr1xNK38S5GgZOxCE7FsK
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 16:05:19.3860
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b7470b-3974-4a1d-e53e-08de7550d6cf
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B91.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9549
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72054-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: EF7AF1ACC3A
X-Rspamd-Action: no action

This basic selftest creates a vgic_v5 device (if supported), and tests
that one of the PPI interrupts works as expected with a basic
single-vCPU guest.

Upon starting, the guest enables interrupts. That means that it is
initialising all PPIs to have reasonable priorities, but marking them
as disabled. Then the priority mask in the ICC_PCR_EL1 is set, and
interrupts are enable in ICC_CR0_EL1. At this stage the guest is able
to receive interrupts. The architected SW_PPI (64) is enabled and
KVM_IRQ_LINE ioctl is used to inject the state into the guest.

The guest's interrupt handler has an explicit WFI in order to ensure
that the guest skips WFI when there are pending and enabled PPI
interrupts.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 219 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 ++++++++++++
 3 files changed, 368 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index fdec90e854671..860766e9e6a09 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -176,6 +176,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_init
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
new file mode 100644
index 0000000000000..ede171a6b4b2e
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <sys/syscall.h>
+#include <asm/kvm.h>
+#include <asm/kvm_para.h>
+
+#include <arm64/gic_v5.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vgic.h"
+
+#define NR_VCPUS		1
+
+struct vm_gic {
+	struct kvm_vm *vm;
+	int gic_fd;
+	uint32_t gic_dev_type;
+};
+
+static uint64_t max_phys_size;
+
+#define GUEST_CMD_IRQ_CDIA	10
+#define GUEST_CMD_IRQ_DIEOI	11
+#define GUEST_CMD_IS_AWAKE	12
+#define GUEST_CMD_IS_READY	13
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	bool valid;
+	u32 hwirq;
+	u64 ia;
+	static int count;
+
+	/*
+	 * We have pending interrupts. Should never actually enter WFI
+	 * here!
+	 */
+	wfi();
+	GUEST_SYNC(GUEST_CMD_IS_AWAKE);
+
+	ia =3D gicr_insn(CDIA);
+	valid =3D GICV5_GICR_CDIA_VALID(ia);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_CDIA);
+
+	if (!valid)
+		return;
+
+	gsb_ack();
+	isb();
+
+	hwirq =3D FIELD_GET(GICV5_GICR_CDIA_INTID, ia);
+
+	gic_insn(hwirq, CDDI);
+	gic_insn(0, CDEOI);
+
+	GUEST_SYNC(GUEST_CMD_IRQ_DIEOI);
+
+	if (++count >=3D 2)
+		GUEST_DONE();
+
+	/* Ask for the next interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+}
+
+static void guest_code(void)
+{
+	local_irq_disable();
+
+	gicv5_cpu_enable_interrupts();
+	local_irq_enable();
+
+	/* Enable the SW_PPI (3) */
+	write_sysreg_s(BIT_ULL(3), SYS_ICC_PPI_ENABLER0_EL1);
+
+	/* Ask for the first interrupt to be injected */
+	GUEST_SYNC(GUEST_CMD_IS_READY);
+
+	/* Loop forever waiting for interrupts */
+	while (1);
+}
+
+
+/* we don't want to assert on run execution, hence that helper */
+static int run_vcpu(struct kvm_vcpu *vcpu)
+{
+	return __vcpu_run(vcpu) ? -errno : 0;
+}
+
+static void vm_gic_destroy(struct vm_gic *v)
+{
+	close(v->gic_fd);
+	kvm_vm_free(v->vm);
+}
+
+static void test_vgic_v5_ppis(uint32_t gic_dev_type)
+{
+	struct ucall uc;
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	int ret, i;
+
+	v.gic_dev_type =3D gic_dev_type;
+	v.vm =3D __vm_create(VM_SHAPE_DEFAULT, NR_VCPUS, 0);
+
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpus[i] =3D vm_vcpu_add(v.vm, i, guest_code);
+
+	vm_init_descriptor_tables(v.vm);
+	vm_install_exception_handler(v.vm, VECTOR_IRQ_CURRENT, guest_irq_handler)=
;
+
+	for (i =3D 0; i < NR_VCPUS; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	kvm_device_attr_set(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			    KVM_DEV_ARM_VGIC_CTRL_INIT, NULL);
+
+	while (1) {
+		ret =3D run_vcpu(vcpus[0]);
+
+		switch (get_ucall(vcpus[0], &uc)) {
+		case UCALL_SYNC:
+			/*
+			 * The guest is ready for the next level change. Set
+			 * high if ready, and lower if it has been consumed.
+			 */
+			if (uc.args[1] =3D=3D GUEST_CMD_IS_READY ||
+			    uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI) {
+				u64 irq;
+				bool level =3D uc.args[1] =3D=3D GUEST_CMD_IRQ_DIEOI ? 0 : 1;
+
+				irq =3D FIELD_PREP(KVM_ARM_IRQ_NUM_MASK, 3);
+				irq |=3D KVM_ARM_IRQ_TYPE_PPI << KVM_ARM_IRQ_TYPE_SHIFT;
+
+				_kvm_irq_line(v.vm, irq, level);
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IS_AWAKE) {
+				pr_info("Guest skipping WFI due to pending IRQ\n");
+			} else if (uc.args[1] =3D=3D GUEST_CMD_IRQ_CDIA) {
+				pr_info("Guest acknowledged IRQ\n");
+			}
+
+			continue;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	TEST_ASSERT(ret =3D=3D 0, "Failed to test GICv5 PPIs");
+
+	vm_gic_destroy(&v);
+}
+
+/*
+ * Returns 0 if it's possible to create GIC device of a given type (V5).
+ */
+int test_kvm_device(uint32_t gic_dev_type)
+{
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct vm_gic v;
+	int ret;
+
+	v.vm =3D vm_create_with_vcpus(NR_VCPUS, guest_code, vcpus);
+
+	/* try to create a non existing KVM device */
+	ret =3D __kvm_test_create_device(v.vm, 0);
+	TEST_ASSERT(ret && errno =3D=3D ENODEV, "unsupported device");
+
+	/* trial mode */
+	ret =3D __kvm_test_create_device(v.vm, gic_dev_type);
+	if (ret)
+		return ret;
+	v.gic_fd =3D kvm_create_device(v.vm, gic_dev_type);
+
+	ret =3D __kvm_create_device(v.vm, gic_dev_type);
+	TEST_ASSERT(ret < 0 && errno =3D=3D EEXIST, "create GIC device twice");
+
+	vm_gic_destroy(&v);
+
+	return 0;
+}
+
+void run_tests(uint32_t gic_dev_type)
+{
+	pr_info("Test VGICv5 PPIs\n");
+	test_vgic_v5_ppis(gic_dev_type);
+}
+
+int main(int ac, char **av)
+{
+	int ret;
+	int pa_bits;
+
+	test_disable_default_vgic();
+
+	pa_bits =3D vm_guest_mode_params[VM_MODE_DEFAULT].pa_bits;
+	max_phys_size =3D 1ULL << pa_bits;
+
+	ret =3D test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V5);
+	if (ret) {
+		pr_info("No GICv5 support; Not running GIC_v5 tests.\n");
+		exit(KSFT_SKIP);
+	}
+
+	pr_info("Running VGIC_V5 tests.\n");
+	run_tests(KVM_DEV_TYPE_ARM_VGIC_V5);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/include/arm64/gic_v5.h b/tools/tes=
ting/selftests/kvm/include/arm64/gic_v5.h
new file mode 100644
index 0000000000000..89339d844f493
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/arm64/gic_v5.h
@@ -0,0 +1,148 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SELFTESTS_GIC_V5_H
+#define __SELFTESTS_GIC_V5_H
+
+#include <asm/barrier.h>
+#include <asm/sysreg.h>
+
+#include <linux/bitfield.h>
+
+#include "processor.h"
+
+/*
+ * Definitions for GICv5 instructions for the Current Domain
+ */
+#define GICV5_OP_GIC_CDAFF		sys_insn(1, 0, 12, 1, 3)
+#define GICV5_OP_GIC_CDDI		sys_insn(1, 0, 12, 2, 0)
+#define GICV5_OP_GIC_CDDIS		sys_insn(1, 0, 12, 1, 0)
+#define GICV5_OP_GIC_CDHM		sys_insn(1, 0, 12, 2, 1)
+#define GICV5_OP_GIC_CDEN		sys_insn(1, 0, 12, 1, 1)
+#define GICV5_OP_GIC_CDEOI		sys_insn(1, 0, 12, 1, 7)
+#define GICV5_OP_GIC_CDPEND		sys_insn(1, 0, 12, 1, 4)
+#define GICV5_OP_GIC_CDPRI		sys_insn(1, 0, 12, 1, 2)
+#define GICV5_OP_GIC_CDRCFG		sys_insn(1, 0, 12, 1, 5)
+#define GICV5_OP_GICR_CDIA		sys_insn(1, 0, 12, 3, 0)
+#define GICV5_OP_GICR_CDNMIA		sys_insn(1, 0, 12, 3, 1)
+
+/* Definitions for GIC CDAFF */
+#define GICV5_GIC_CDAFF_IAFFID_MASK	GENMASK_ULL(47, 32)
+#define GICV5_GIC_CDAFF_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDAFF_IRM_MASK	BIT_ULL(28)
+#define GICV5_GIC_CDAFF_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDI */
+#define GICV5_GIC_CDDI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDDIS */
+#define GICV5_GIC_CDDIS_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDDIS_TYPE(r)		FIELD_GET(GICV5_GIC_CDDIS_TYPE_MASK, r)
+#define GICV5_GIC_CDDIS_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GIC_CDDIS_ID(r)		FIELD_GET(GICV5_GIC_CDDIS_ID_MASK, r)
+
+/* Definitions for GIC CDEN */
+#define GICV5_GIC_CDEN_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDEN_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDHM */
+#define GICV5_GIC_CDHM_HM_MASK		BIT_ULL(32)
+#define GICV5_GIC_CDHM_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDHM_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPEND */
+#define GICV5_GIC_CDPEND_PENDING_MASK	BIT_ULL(32)
+#define GICV5_GIC_CDPEND_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPEND_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDPRI */
+#define GICV5_GIC_CDPRI_PRIORITY_MASK	GENMASK_ULL(39, 35)
+#define GICV5_GIC_CDPRI_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDPRI_ID_MASK		GENMASK_ULL(23, 0)
+
+/* Definitions for GIC CDRCFG */
+#define GICV5_GIC_CDRCFG_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GIC_CDRCFG_ID_MASK	GENMASK_ULL(23, 0)
+
+/* Definitions for GICR CDIA */
+#define GICV5_GICR_CDIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDIA_VALID(r)	FIELD_GET(GICV5_GICR_CDIA_VALID_MASK, r)
+#define GICV5_GICR_CDIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDIA_ID_MASK		GENMASK_ULL(23, 0)
+#define GICV5_GICR_CDIA_INTID		GENMASK_ULL(31, 0)
+
+/* Definitions for GICR CDNMIA */
+#define GICV5_GICR_CDNMIA_VALID_MASK	BIT_ULL(32)
+#define GICV5_GICR_CDNMIA_VALID(r)	FIELD_GET(GICV5_GICR_CDNMIA_VALID_MASK,=
 r)
+#define GICV5_GICR_CDNMIA_TYPE_MASK	GENMASK_ULL(31, 29)
+#define GICV5_GICR_CDNMIA_ID_MASK	GENMASK_ULL(23, 0)
+
+#define gicr_insn(insn)			read_sysreg_s(GICV5_OP_GICR_##insn)
+#define gic_insn(v, insn)		write_sysreg_s(v, GICV5_OP_GIC_##insn)
+
+#define __GIC_BARRIER_INSN(op0, op1, CRn, CRm, op2, Rt)			\
+	__emit_inst(0xd5000000					|	\
+		    sys_insn((op0), (op1), (CRn), (CRm), (op2))	|	\
+		    ((Rt) & 0x1f))
+
+#define GSB_SYS_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 0, 31)
+#define GSB_ACK_BARRIER_INSN		__GIC_BARRIER_INSN(1, 0, 12, 0, 1, 31)
+
+#define gsb_ack()	asm volatile(GSB_ACK_BARRIER_INSN : : : "memory")
+#define gsb_sys()	asm volatile(GSB_SYS_BARRIER_INSN : : : "memory")
+
+#define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
+
+#define GICV5_IRQ_DEFAULT_PRI 0b10000
+
+void gicv5_ppi_priority_init(void)
+{
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR0=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR2=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR3=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR4=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR5=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR6=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR7=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR8=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR9=
_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
0_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
1_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
2_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
3_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
4_EL1);
+	write_sysreg_s(REPEAT_BYTE(GICV5_IRQ_DEFAULT_PRI), SYS_ICC_PPI_PRIORITYR1=
5_EL1);
+
+	/*
+	 * Context syncronization required to make sure system register writes
+	 * effects are synchronised.
+	 */
+	isb();
+}
+
+void gicv5_cpu_disable_interrupts(void)
+{
+	u64 cr0;
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 0);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+void gicv5_cpu_enable_interrupts(void)
+{
+	u64 cr0, pcr;
+
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER0_EL1);
+	write_sysreg_s(0, SYS_ICC_PPI_ENABLER1_EL1);
+
+	gicv5_ppi_priority_init();
+
+	pcr =3D FIELD_PREP(ICC_PCR_EL1_PRIORITY, GICV5_IRQ_DEFAULT_PRI);
+	write_sysreg_s(pcr, SYS_ICC_PCR_EL1);
+
+	cr0 =3D FIELD_PREP(ICC_CR0_EL1_EN, 1);
+	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+}
+
+#endif
--=20
2.34.1

