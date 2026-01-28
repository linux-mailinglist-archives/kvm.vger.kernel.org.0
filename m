Return-Path: <kvm+bounces-69370-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPSUOHJPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69370-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:03:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C871A76C6
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 051A9304C94B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC0737105A;
	Wed, 28 Jan 2026 18:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YwU5+An1";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="YwU5+An1"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013016.outbound.protection.outlook.com [52.101.83.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39E732ABCF
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.16
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623294; cv=fail; b=cVsnDCN2yPfvMXQAMis+My2SzYKXZ715dzvIW4KYYTtbr7uikhEyahtevz7NqXJ6EALTv4jXn6H6U/zaxzjRF9HZeVEFiMpGiAjyyzJDw57agW0IeGjg7fRI4qMG3Rs1OJ3aBBrUcCCi79gCeYrVbTbUkfbmC9Lwd6+RJt9XRe8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623294; c=relaxed/simple;
	bh=RHAQ3hgLvbLkslprB8kchM7LxTOMWgs4PPI1fSirraA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q5wMqWCt23AJtQgSnAQ/xHxEmGfJA5rnSCGekjVRDGM+G8VmFLOUtI/lhwKYnZvY/fIwN+d/gjMUaYaOuYgkJSoE3fILgK761NaxKl22egrKtTlOVU17MSmvPaeOWxNI7pP5eJTOph0aJyZHEqRVYeQ3rIC+evI6y2BLHrj9+SE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YwU5+An1; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=YwU5+An1; arc=fail smtp.client-ip=52.101.83.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NgBfg+3sxANy2OxDqgMGx0knubZm+rvr3JG6iFyuBF2pMnzO5TeKb6uDXLP+ZCqCTd9067YOI9V2omkR5UR9IAEa5fE0CAz0BwfswDRjzlWWiQphUJY0Am6M66E/z5U0IUL7McOfO+OMiEeNJQilhrvGwAh5hjDQ0YVvFiLPQu+1q90PAr5SRnYyklPhS2Qy51G8tj1sjDArGLSW9B+08PlnfRbjSd7ZPm9GRBfnZcw/d7K21D17EAPdq09V7JeEjPk5b4r0iRw/w/42thxw3nmZ5DKZgIlRJEx99Jqsf99rXga2bkF3vIhhnAX1aqV7/s3pX5GkB7WJtWzJ71ddMw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdjdPSXSiRZk6kpB6Ddx4lfve6trnH+KtYNNib276N8=;
 b=LvTjzlXgWVBK688pzknhcrbn7yfKZxh9Xw/mne99OkW1xB1VX7pox12ngQZ00VbXuJxZmyBAzdJaIUPp2SUHnEhHMixFjE1/PzqAq9QcSsaDGP9ItHUm3Z73JK9ZiLkn1QnbYhRo3nCA0/yfvq4Z17tYNH6w/HFT1kc/15ldX962nSCTxLtcsbir+Ok2Er3u5J8Rk1APcxjJsxdY9/IhrFrGXmdyCFoD14NmmCYnT9D7t1qA7g+405byHKNiqQpcjAaar+XPVvxOSO0qexwqhJymHqobWBBUfI2BTSB2YiK6bjRokfHCg7kE4Cnt8/BapBt8GZRgEKdX/a+bJFIibQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdjdPSXSiRZk6kpB6Ddx4lfve6trnH+KtYNNib276N8=;
 b=YwU5+An1CwPYSxgFNPlWw+fF7c5xJVMMsUecrn9gUCBAZQqf8kvktSKUVoSAbYG093X26MRARzoEcmk1MOiOVG5ObA1WY5a8cC0iGztiQZp81AQ43osfiNPidx5afoDSRbg1OMQ+ZEPtG7F804Wj3bTTVKE+iCWuuwUnr299Bds=
Received: from DBBPR09CA0030.eurprd09.prod.outlook.com (2603:10a6:10:d4::18)
 by AS8PR08MB6360.eurprd08.prod.outlook.com (2603:10a6:20b:33e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:01:25 +0000
Received: from DB1PEPF000509FE.eurprd03.prod.outlook.com
 (2603:10a6:10:d4:cafe::3e) by DBBPR09CA0030.outlook.office365.com
 (2603:10a6:10:d4::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:01:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FE.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:01:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XkywXiS1ceguCH93hYJnl6aoo+jRdUDhzGaXBeHjm87a3zmDFoX2pwo54b89iPl9YetozUEtbop4CnZos43dcp5XOvJIhzyRttll6HbiFsS4d88ZuZRBa/N2vcBisw/NAu7iwFTwNVt9KsjUAXOVgbT3c2+2CVFuG/ICGST0KJOiUD2dzTgmBXnw6nc6ys9ofrTjcwyihHrlkYQkDpx3RNr7BQjSBl0F8obwxOcmVi3rWqF5sEFWep8am38vX6T0xla7pVdSneCa7+uIq+IybH/kxSpCl2kDs42gZsgxC44/C1/aaU+uPHPN4dWQSIx63Up8kraOnlGrrRMxqge5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdjdPSXSiRZk6kpB6Ddx4lfve6trnH+KtYNNib276N8=;
 b=GnTDxN/rMXAvoN1twvluN1rHlIwTADaWu0snRdEJCjYu43ciltfQAcd9aGpeeq/GdARoiqGZLfRLP+u4Ghs7MozZ7pHB/0wGHJU20T1ze202boPnGwuXZHd/VO/6NZfDCnNRdR/2EeLK5tPxC1FzOhE1Zq7g20mAzVzpAvcqDd9HjFAnxmCTdKEmwwcTMmhDGMxod9ppAD2sABRzYhwP2pdiTYoHFv2+A7MCbI22KoDCuEb+ny/jFnvxe3oG5xcUVOMliqjr2QZOimAm1NN0Knp0hD3a0nAFlGRFrkc23wzPkkP4W8Dt02FpH2LUJ7LSXSvZpDdLBib6c7Fpu8nzmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdjdPSXSiRZk6kpB6Ddx4lfve6trnH+KtYNNib276N8=;
 b=YwU5+An1CwPYSxgFNPlWw+fF7c5xJVMMsUecrn9gUCBAZQqf8kvktSKUVoSAbYG093X26MRARzoEcmk1MOiOVG5ObA1WY5a8cC0iGztiQZp81AQ43osfiNPidx5afoDSRbg1OMQ+ZEPtG7F804Wj3bTTVKE+iCWuuwUnr299Bds=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:00:21 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:00:21 +0000
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
Subject: [PATCH v4 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Topic: [PATCH v4 04/36] arm64/sysreg: Add remaining GICv5 ICC_ & ICH_
 sysregs for KVM support
Thread-Index: AQHckH/4oj6b3+2FvkSZOCN6la9s+g==
Date: Wed, 28 Jan 2026 18:00:21 +0000
Message-ID: <20260128175919.3828384-5-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DB1PEPF000509FE:EE_|AS8PR08MB6360:EE_
X-MS-Office365-Filtering-Correlation-Id: 44e72dff-03ec-4a1e-71c8-08de5e974069
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?zSyFzPP5x39gGgCM25s+TO+/iy0piKmhvJQkwAO4UkzO+Y+uwY5g07SvSv?=
 =?iso-8859-1?Q?kOoDN4ZJaMO5Jweq4QUu10ApQ6+BrO6bbZyAsAwGpC85q8H3U95556NNSV?=
 =?iso-8859-1?Q?tzmafa625VlON1qmuvQJEvnhhRbnFJDr1s+w8jop26qIcTgVBpo7zJIV8c?=
 =?iso-8859-1?Q?CKlg0hVj0cbf5taEgeHzjII07SkGiaQyB//SVUbA9GUohjawgTkQUIPRN9?=
 =?iso-8859-1?Q?9Vve5phZTIki1RMSgk7jm1pDTbiVCry40XdTZFcbvO4zFX6gGoP1ZY2Htv?=
 =?iso-8859-1?Q?0JAL535Er4hfLfxGaR5i3q59fYmC4KG6KGgS4GKnPn9mFPYxtn87qsTZ/+?=
 =?iso-8859-1?Q?yYyKMPrJVvb/8uBaUmEFxHfGHdrG6AAInz8WJDRgfnJzgr9eVs3Tq4M4UO?=
 =?iso-8859-1?Q?GA8Giu5UeIjlJcZFPRH5crgBb0eFnrLm5e7C2nWw7IfmEa8kN8YlUDojac?=
 =?iso-8859-1?Q?0rBvU8QD7DzxVY0fT3wp0+LiIWQSZgiCOg2NjqftnTHfAwuGHkquZSNeNK?=
 =?iso-8859-1?Q?4V0qxT7LYEa6D376nRkoziLXr5Qr92MEw87bO67hbc6QJ4U9kyj2rwsgQY?=
 =?iso-8859-1?Q?z6gh0nFwVdEQqV4nayAgTIQu7HBumJeXCqKPPR5tTX+JVdGxbS+ebCLcFC?=
 =?iso-8859-1?Q?G+nd3QmuSDFXAoGruOOCcgpT2385HSr1aYJFQogvhCTVPluweFCILStGPp?=
 =?iso-8859-1?Q?r0QSYZm+uM4Ly67A6yUCDy3XG/+5GAZz46SthGu9qrpnmGbHfktjfGGCyO?=
 =?iso-8859-1?Q?PYNc6/brEq8A4NW3eFsA6G1GQMY1n+0cBQYZzzkenlc+Tqx7RysaPFvOdQ?=
 =?iso-8859-1?Q?xwge1dMbTvvxp+rXBcy10L6dFjbJQQS+2P0lrYK9YB2Av5r9I66y4Y3x/A?=
 =?iso-8859-1?Q?notv4CzWxUi0rXtplM2WVhNrpLk2iuHzCH8Mmfie2Ze+DPeruC70/dLZuE?=
 =?iso-8859-1?Q?V+oRnSELiwDi9JES51hNf8i9aMhbiaxKG8g4khuMEA6Mj8l9C1CY/ewiJ3?=
 =?iso-8859-1?Q?ymCl/lvmt/+4GYgDa1HdxgkhytBlGHJP/AvM61Y+hgyqrtXT2WyMtSHpo5?=
 =?iso-8859-1?Q?7VvLQuVgcRV61Bj/lgHxHJd1rilwLJH6Aa92bBlJ4BDZUz6q9uJQJHghwO?=
 =?iso-8859-1?Q?65wYq4FecG1gdOZooTibXZa4TTLT79pY6GEvnipVfodlqt87Ke139dPRFn?=
 =?iso-8859-1?Q?OR+FsX34/Sm2HovuuMPjCS+Lp/2VFgL5uciGE9JpzVfHL+wJiil85nw1lo?=
 =?iso-8859-1?Q?Zs1EyM/gqUrh6CkKXY4Nltu7sUqEcdljmohnB7A7AeG0tSvVXpaACwMmjn?=
 =?iso-8859-1?Q?zRUFuNrqYr2dQ+HcLMsEAnFtz704CqqTOaYXkOa6tuiCqlob97lwP/88gb?=
 =?iso-8859-1?Q?bUZI7Hy+F7n6oKCtIXNCJIGbW9BAhIFbWC6X501MkBPFxXQXm7Sud+lvCu?=
 =?iso-8859-1?Q?wUozRVUOA/TZIR1D11XIN/WMiXLPFoSubvE/Ug1LxarzjvZ/qDw1Yddjsw?=
 =?iso-8859-1?Q?IUK1dGkUTlMMYoa4uLgTwXh59+zHHlD3Akj4MY1qTpfl4HqT52hca7ozx6?=
 =?iso-8859-1?Q?1qSTiXKU/ExiaE4RK+d4n6ZhY73JkgvGzYI8BBwB8FcGkNwJj6YEfoFt5b?=
 =?iso-8859-1?Q?kJ45N6JmuCGYXWnwQCyhRBv2gv/OyWGrQwMCOVQel4QzdAhzfw7bH5SlFA?=
 =?iso-8859-1?Q?AaRXyEwIujBCjHzHWpQ=3D?=
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
 DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a4119598-d37c-4568-d684-08de5e971ac8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|376014|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?cdQ60aiuVInpmexxWtoK7+Q+DqNr2PHFZRvdsvwNEoW/JS5Q2Vh6l2X75M?=
 =?iso-8859-1?Q?/KLfBIqFTaNfe934maDL9/C8lK20Gzc5vSNNsVuJYN2YCF5/CdbfGWrnya?=
 =?iso-8859-1?Q?+udfohpK03pEup4ak3JzzEIVU97HOISAgZYi0ro3uGpeaXXYL/An5WDSO5?=
 =?iso-8859-1?Q?JjYzZ5XSQgbsaIOiu6TDMti7jgA2hpE2k+1QwX3gAiaVA0j66RDlkNjBwc?=
 =?iso-8859-1?Q?jWZZ72xZvwCXLqONGNH6bbeMZ2cADeDqITNCMWErK2qIUPw1DSeDEpWzPY?=
 =?iso-8859-1?Q?IQR4gYSULjKTBUUYC4UNHzUgZ3a1NNm4r9oJE+GArtGnq/J9Fgr2HB/TUX?=
 =?iso-8859-1?Q?W4hqM/s05xT/yhJOZuEcodJ76rpkDOHf4GUU6Z0i/l1V8DzzkAhhIpOHwP?=
 =?iso-8859-1?Q?ZL2PaQufeOZMpoXmUEGel2WA2XyJo1okSlXaRMS16EInJU8G1qzRc+r62a?=
 =?iso-8859-1?Q?xL47M3k5SweEVvtALhNm+P0Gl69S2TBD7s0btiAjIib6iTewNaQTh5ujkj?=
 =?iso-8859-1?Q?XLbV7fQrk5xE0t7h2+E8hC3jCCRWK7lOjr1/xD8O01CN7Po3caTHhAX3ze?=
 =?iso-8859-1?Q?OGqP7q1ugN5yz8A2pGfwYdcwumiZDLx9rBTQqF9NF5vBrrw6mF9Ht4WOZF?=
 =?iso-8859-1?Q?QlE5AeASmR6j2RUjWL27ZcOdPR/niKXLGQPGPYZyo32X+ULv1uL/51QlEm?=
 =?iso-8859-1?Q?gFME19Qcd88ZjTpAZBFfYNTrohjKMkfHivhaRdWUigLZ93BVRwYLHEn5Wr?=
 =?iso-8859-1?Q?5WhKp0eN0I2krZSOl3CwhmptPOJE2saG0ms1IIXpIWKwmEEXS+KzWWSVpC?=
 =?iso-8859-1?Q?4RcftBk2pP5G4e6qgPmYVoqFFiROFNMeENukleJaXa3a5/zIccPwSFaMPN?=
 =?iso-8859-1?Q?06hoBLpUDkDp99D5NpG20BFhEIABdVAoGKxXp9nyCmTmbteIMP5kyYa1ZT?=
 =?iso-8859-1?Q?ndySRPijjiIvBmDrYBcYVzZUz/edNGGo0UmFTHfptyA3VhxWK5Ke7Tt+Ei?=
 =?iso-8859-1?Q?97D4UlzSu2XnEzjceaE4MGJ2p0YJ7iTYw2zEOXGAB6/wNm84tPPEAXlDxw?=
 =?iso-8859-1?Q?270+zL933BEEfF5VkpVLkSh3h7uJzlZL1JzzJjSHP9382ZF1ECP0F4Q9bc?=
 =?iso-8859-1?Q?Pdv1S4VFJWhWBkkDIVhhKJvnL/Sud6mFMDsgcKEDhtF8EA12F5bC9e9s3s?=
 =?iso-8859-1?Q?pOTw6Gw9Y5IerWhyQFt1uYU/XqOOCKpvVfntlTYHCiDgYcQHbpIBJHtfHH?=
 =?iso-8859-1?Q?ut+SmRtI8xB1gSax/WpbX01s1HSCZ8aj440qUw/WeXK7TfXWf8ypU1B/2b?=
 =?iso-8859-1?Q?UYsClYfU9AdiBBzCvwKRJJBGNgvflGTpBchViaN0a3nj7o2IRb4L5vajhN?=
 =?iso-8859-1?Q?XJQA1IyEI/4xmenVVwvIv3H+6O0TQHIdrR1qcAQAuf2dyf8rF8NzCINyzQ?=
 =?iso-8859-1?Q?pqL8j/HZxezEnBWFVIq2WOX9BSSOQfAc1yddcbxQThepkV4QQGIV/fRlMv?=
 =?iso-8859-1?Q?uaGPru2/k45z+LFXLjKSVlPZF4G1ComaKrmF339xkj6yNtaD7ObRCTfjUn?=
 =?iso-8859-1?Q?IB+ZXLcXAi02UtI4JAbghWLSCgmHmJa0SpBhJygzwVVrHbmlc1lrE+pEx7?=
 =?iso-8859-1?Q?q8VSPk8hF4V0nB9NE8Bkx7x/9MKS4KBh5aKJY8MWFEMpAIo9xQvVOLigko?=
 =?iso-8859-1?Q?Ivy1sbZct+tyliYzu9/oUaWL0xGLece6j2rw9j052TPN2070Wd2tFLVpFk?=
 =?iso-8859-1?Q?8nhA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(376014)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:01:24.5750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44e72dff-03ec-4a1e-71c8-08de5e974069
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FE.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6360
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
	TAGGED_FROM(0.00)[bounces-69370-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:email,arm.com:email,arm.com:dkim,arm.com:mid];
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
X-Rspamd-Queue-Id: 3C871A76C6
X-Rspamd-Action: no action

Add the GICv5 system registers required to support native GICv5 guests
with KVM. Many of the GICv5 sysregs have already been added as part of
the host GICv5 driver, keeping this set relatively small. The
registers added in this change complete the set by adding those
required by KVM either directly (ICH_) or indirectly (FGTs for the
ICC_ sysregs).

The following system registers and their fields are added:

	ICC_APR_EL1
	ICC_HPPIR_EL1
	ICC_IAFFIDR_EL1
	ICH_APR_EL2
	ICH_CONTEXTR_EL2
	ICH_PPI_ACTIVER<n>_EL2
	ICH_PPI_DVI<n>_EL2
	ICH_PPI_ENABLER<n>_EL2
	ICH_PPI_PENDR<n>_EL2
	ICH_PPI_PRIORITYR<n>_EL2

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/tools/sysreg | 480 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 480 insertions(+)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index dab5bfe8c968..2f44a568ebf4 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -3248,6 +3248,14 @@ UnsignedEnum	3:0	ID_BITS
 EndEnum
 EndSysreg
=20
+Sysreg	ICC_HPPIR_EL1	3	0	12	10	3
+Res0	63:33
+Field	32	HPPIV
+Field	31:29	TYPE
+Res0	28:24
+Field	23:0	ID
+EndSysreg
+
 Sysreg	ICC_ICSR_EL1	3	0	12	10	4
 Res0	63:48
 Field	47:32	IAFFID
@@ -3262,6 +3270,11 @@ Field	1	Enabled
 Field	0	F
 EndSysreg
=20
+Sysreg	ICC_IAFFIDR_EL1	3	0	12	10	5
+Res0	63:16
+Field	15:0	IAFFID
+EndSysreg
+
 SysregFields	ICC_PPI_ENABLERx_EL1
 Field	63	EN63
 Field	62	EN62
@@ -3668,6 +3681,42 @@ Res0	14:12
 Field	11:0	AFFINITY
 EndSysreg
=20
+Sysreg	ICC_APR_EL1	3	1	12	0	0
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICC_CR0_EL1	3	1	12	0	1
 Res0	63:39
 Field	38	PID
@@ -4567,6 +4616,42 @@ Field	31:16	PhyPARTID29
 Field	15:0	PhyPARTID28
 EndSysreg
=20
+Sysreg	ICH_APR_EL2	3	4	12	8	4
+Res0	63:32
+Field	31	P31
+Field	30	P30
+Field	29	P29
+Field	28	P28
+Field	27	P27
+Field	26	P26
+Field	25	P25
+Field	24	P24
+Field	23	P23
+Field	22	P22
+Field	21	P21
+Field	20	P20
+Field	19	P19
+Field	18	P18
+Field	17	P17
+Field	16	P16
+Field	15	P15
+Field	14	P14
+Field	13	P13
+Field	12	P12
+Field	11	P11
+Field	10	P10
+Field	9	P9
+Field	8	P8
+Field	7	P7
+Field	6	P6
+Field	5	P5
+Field	4	P4
+Field	3	P3
+Field	2	P2
+Field	1	P1
+Field	0	P0
+EndSysreg
+
 Sysreg	ICH_HFGRTR_EL2	3	4	12	9	4
 Res0	63:21
 Field	20	ICC_PPI_ACTIVERn_EL1
@@ -4615,6 +4700,306 @@ Field	1	GICCDDIS
 Field	0	GICCDEN
 EndSysreg
=20
+SysregFields	ICH_PPI_DVIRx_EL2
+Field	63	DVI63
+Field	62	DVI62
+Field	61	DVI61
+Field	60	DVI60
+Field	59	DVI59
+Field	58	DVI58
+Field	57	DVI57
+Field	56	DVI56
+Field	55	DVI55
+Field	54	DVI54
+Field	53	DVI53
+Field	52	DVI52
+Field	51	DVI51
+Field	50	DVI50
+Field	49	DVI49
+Field	48	DVI48
+Field	47	DVI47
+Field	46	DVI46
+Field	45	DVI45
+Field	44	DVI44
+Field	43	DVI43
+Field	42	DVI42
+Field	41	DVI41
+Field	40	DVI40
+Field	39	DVI39
+Field	38	DVI38
+Field	37	DVI37
+Field	36	DVI36
+Field	35	DVI35
+Field	34	DVI34
+Field	33	DVI33
+Field	32	DVI32
+Field	31	DVI31
+Field	30	DVI30
+Field	29	DVI29
+Field	28	DVI28
+Field	27	DVI27
+Field	26	DVI26
+Field	25	DVI25
+Field	24	DVI24
+Field	23	DVI23
+Field	22	DVI22
+Field	21	DVI21
+Field	20	DVI20
+Field	19	DVI19
+Field	18	DVI18
+Field	17	DVI17
+Field	16	DVI16
+Field	15	DVI15
+Field	14	DVI14
+Field	13	DVI13
+Field	12	DVI12
+Field	11	DVI11
+Field	10	DVI10
+Field	9	DVI9
+Field	8	DVI8
+Field	7	DVI7
+Field	6	DVI6
+Field	5	DVI5
+Field	4	DVI4
+Field	3	DVI3
+Field	2	DVI2
+Field	1	DVI1
+Field	0	DVI0
+EndSysregFields
+
+Sysreg	ICH_PPI_DVIR0_EL2	3	4	12	10	0
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_DVIR1_EL2	3	4	12	10	1
+Fields ICH_PPI_DVIx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ENABLERx_EL2
+Field	63	EN63
+Field	62	EN62
+Field	61	EN61
+Field	60	EN60
+Field	59	EN59
+Field	58	EN58
+Field	57	EN57
+Field	56	EN56
+Field	55	EN55
+Field	54	EN54
+Field	53	EN53
+Field	52	EN52
+Field	51	EN51
+Field	50	EN50
+Field	49	EN49
+Field	48	EN48
+Field	47	EN47
+Field	46	EN46
+Field	45	EN45
+Field	44	EN44
+Field	43	EN43
+Field	42	EN42
+Field	41	EN41
+Field	40	EN40
+Field	39	EN39
+Field	38	EN38
+Field	37	EN37
+Field	36	EN36
+Field	35	EN35
+Field	34	EN34
+Field	33	EN33
+Field	32	EN32
+Field	31	EN31
+Field	30	EN30
+Field	29	EN29
+Field	28	EN28
+Field	27	EN27
+Field	26	EN26
+Field	25	EN25
+Field	24	EN24
+Field	23	EN23
+Field	22	EN22
+Field	21	EN21
+Field	20	EN20
+Field	19	EN19
+Field	18	EN18
+Field	17	EN17
+Field	16	EN16
+Field	15	EN15
+Field	14	EN14
+Field	13	EN13
+Field	12	EN12
+Field	11	EN11
+Field	10	EN10
+Field	9	EN9
+Field	8	EN8
+Field	7	EN7
+Field	6	EN6
+Field	5	EN5
+Field	4	EN4
+Field	3	EN3
+Field	2	EN2
+Field	1	EN1
+Field	0	EN0
+EndSysregFields
+
+Sysreg	ICH_PPI_ENABLER0_EL2	3	4	12	10	2
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ENABLER1_EL2	3	4	12	10	3
+Fields ICH_PPI_ENABLERx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_PENDRx_EL2
+Field	63	PEND63
+Field	62	PEND62
+Field	61	PEND61
+Field	60	PEND60
+Field	59	PEND59
+Field	58	PEND58
+Field	57	PEND57
+Field	56	PEND56
+Field	55	PEND55
+Field	54	PEND54
+Field	53	PEND53
+Field	52	PEND52
+Field	51	PEND51
+Field	50	PEND50
+Field	49	PEND49
+Field	48	PEND48
+Field	47	PEND47
+Field	46	PEND46
+Field	45	PEND45
+Field	44	PEND44
+Field	43	PEND43
+Field	42	PEND42
+Field	41	PEND41
+Field	40	PEND40
+Field	39	PEND39
+Field	38	PEND38
+Field	37	PEND37
+Field	36	PEND36
+Field	35	PEND35
+Field	34	PEND34
+Field	33	PEND33
+Field	32	PEND32
+Field	31	PEND31
+Field	30	PEND30
+Field	29	PEND29
+Field	28	PEND28
+Field	27	PEND27
+Field	26	PEND26
+Field	25	PEND25
+Field	24	PEND24
+Field	23	PEND23
+Field	22	PEND22
+Field	21	PEND21
+Field	20	PEND20
+Field	19	PEND19
+Field	18	PEND18
+Field	17	PEND17
+Field	16	PEND16
+Field	15	PEND15
+Field	14	PEND14
+Field	13	PEND13
+Field	12	PEND12
+Field	11	PEND11
+Field	10	PEND10
+Field	9	PEND9
+Field	8	PEND8
+Field	7	PEND7
+Field	6	PEND6
+Field	5	PEND5
+Field	4	PEND4
+Field	3	PEND3
+Field	2	PEND2
+Field	1	PEND1
+Field	0	PEND0
+EndSysregFields
+
+Sysreg	ICH_PPI_PENDR0_EL2	3	4	12	10	4
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PENDR1_EL2	3	4	12	10	5
+Fields ICH_PPI_PENDRx_EL2
+EndSysreg
+
+SysregFields	ICH_PPI_ACTIVERx_EL2
+Field	63	ACTIVE63
+Field	62	ACTIVE62
+Field	61	ACTIVE61
+Field	60	ACTIVE60
+Field	59	ACTIVE59
+Field	58	ACTIVE58
+Field	57	ACTIVE57
+Field	56	ACTIVE56
+Field	55	ACTIVE55
+Field	54	ACTIVE54
+Field	53	ACTIVE53
+Field	52	ACTIVE52
+Field	51	ACTIVE51
+Field	50	ACTIVE50
+Field	49	ACTIVE49
+Field	48	ACTIVE48
+Field	47	ACTIVE47
+Field	46	ACTIVE46
+Field	45	ACTIVE45
+Field	44	ACTIVE44
+Field	43	ACTIVE43
+Field	42	ACTIVE42
+Field	41	ACTIVE41
+Field	40	ACTIVE40
+Field	39	ACTIVE39
+Field	38	ACTIVE38
+Field	37	ACTIVE37
+Field	36	ACTIVE36
+Field	35	ACTIVE35
+Field	34	ACTIVE34
+Field	33	ACTIVE33
+Field	32	ACTIVE32
+Field	31	ACTIVE31
+Field	30	ACTIVE30
+Field	29	ACTIVE29
+Field	28	ACTIVE28
+Field	27	ACTIVE27
+Field	26	ACTIVE26
+Field	25	ACTIVE25
+Field	24	ACTIVE24
+Field	23	ACTIVE23
+Field	22	ACTIVE22
+Field	21	ACTIVE21
+Field	20	ACTIVE20
+Field	19	ACTIVE19
+Field	18	ACTIVE18
+Field	17	ACTIVE17
+Field	16	ACTIVE16
+Field	15	ACTIVE15
+Field	14	ACTIVE14
+Field	13	ACTIVE13
+Field	12	ACTIVE12
+Field	11	ACTIVE11
+Field	10	ACTIVE10
+Field	9	ACTIVE9
+Field	8	ACTIVE8
+Field	7	ACTIVE7
+Field	6	ACTIVE6
+Field	5	ACTIVE5
+Field	4	ACTIVE4
+Field	3	ACTIVE3
+Field	2	ACTIVE2
+Field	1	ACTIVE1
+Field	0	ACTIVE0
+EndSysregFields
+
+Sysreg	ICH_PPI_ACTIVER0_EL2	3	4	12	10	6
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_ACTIVER1_EL2	3	4	12	10	7
+Fields ICH_PPI_ACTIVERx_EL2
+EndSysreg
+
 Sysreg	ICH_HCR_EL2	3	4	12	11	0
 Res0	63:32
 Field	31:27	EOIcount
@@ -4669,6 +5054,18 @@ Field	1	V3
 Field	0	En
 EndSysreg
=20
+Sysreg	ICH_CONTEXTR_EL2	3	4	12	11	6
+Field	63	V
+Field	62	F
+Field	61	IRICHPPIDIS
+Field	60	DB
+Field	59:55	DBPM
+Res0	54:48
+Field	47:32	VPE
+Res0	31:16
+Field	15:0	VM
+EndSysreg
+
 Sysreg	ICH_VMCR_EL2	3	4	12	11	7
 Prefix	FEAT_GCIE
 Res0	63:32
@@ -4690,6 +5087,89 @@ Field	1	VENG1
 Field	0	VENG0
 EndSysreg
=20
+SysregFields	ICH_PPI_PRIORITYRx_EL2
+Res0	63:61
+Field	60:56	Priority7
+Res0	55:53
+Field	52:48	Priority6
+Res0	47:45
+Field	44:40	Priority5
+Res0	39:37
+Field	36:32	Priority4
+Res0	31:29
+Field	28:24	Priority3
+Res0	23:21
+Field	20:16	Priority2
+Res0	15:13
+Field	12:8	Priority1
+Res0	7:5
+Field	4:0	Priority0
+EndSysregFields
+
+Sysreg	ICH_PPI_PRIORITYR0_EL2	3	4	12	14	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR1_EL2	3	4	12	14	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR2_EL2	3	4	12	14	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR3_EL2	3	4	12	14	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR4_EL2	3	4	12	14	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR5_EL2	3	4	12	14	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR6_EL2	3	4	12	14	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR7_EL2	3	4	12	14	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR8_EL2	3	4	12	15	0
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR9_EL2	3	4	12	15	1
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR10_EL2	3	4	12	15	2
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR11_EL2	3	4	12	15	3
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR12_EL2	3	4	12	15	4
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR13_EL2	3	4	12	15	5
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR14_EL2	3	4	12	15	6
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
+Sysreg	ICH_PPI_PRIORITYR15_EL2	3	4	12	15	7
+Fields	ICH_PPI_PRIORITYRx_EL2
+EndSysreg
+
 Sysreg	CONTEXTIDR_EL2	3	4	13	0	1
 Fields	CONTEXTIDR_ELx
 EndSysreg
--=20
2.34.1

