Return-Path: <kvm+bounces-69400-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OKwIxJSemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69400-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5637BA7998
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:14:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CEC58308C643
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F413371073;
	Wed, 28 Jan 2026 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PeK58yyt";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="PeK58yyt"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013027.outbound.protection.outlook.com [52.101.72.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64D336D4EA
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.27
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623755; cv=fail; b=XR32EYuZjvQi48sZigfJ3cW6KmURkK1XX+hXHJfi6rVW4QJTUjjDHxFrXY0n5vzqH8rrVIp5K5zcSZYFeqeXqTzvinc40wNN3JBxDMoEyDMLD9WQTDFMKiqMA1yBoGEIsStJZn1Y/mE8bTguRqTgNRyYt8cgWA0VmXQ8yL54+kg=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623755; c=relaxed/simple;
	bh=jGjCgC+oSDRgfJCPXPBA155A8+BXfBH6FCw5BpT/zCY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UcoH3Tz7ae4L7sA8KFlh4NS8exX8bFkJUZg1do2gwuQ4TrXCrEMRcrJEAWs50HKW2ts2i6hmbmRioOWucRC1vbib0JTeOe9CeoGbQ30SX4+8H5yOnx/kaXWVdTEl4jjpmaygQ9K3Xqzi9QErlibXcWPjHmALNuVkPOumJ7p5U0o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PeK58yyt; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=PeK58yyt; arc=fail smtp.client-ip=52.101.72.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gc9kG72A9rKl+EyEDmB9ENRGiMXxt/QE2oEsajrU07/BuL5XZF6s5rvGeU+msBngeuYXNKglDtBhIeT5DNeEnAOrRCib6BoPtbVZDBfPgR2wqoA32u0qJWrtAjFC0Ic14FLVpFKzfhWOwC1uHWrdaa5/jQgviJ5coz9SoLCLCeudefFLZS1ysBJn5nM5BE1iKgaUqH/8IQTeCbpGRlNPpYXwZQ3WxDTnzX93+eAu1yNUS7vdJnssQbekh9DI+M+uaWAdv3QHM61gYZJjdjiCHVKTN5GCyp2rU7dhp56M5L6GFskBf5wttTGmR4mQR1I35egXdABox2dW3m058Mf/cg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lR52Bi+Xz0K6v5BZT7hLCKrUJS5lxiGMArv5vn+mNk=;
 b=JPDdn5FvjlUNJS80IWfQomSGThb3lQR/RYD4Rj/PIauzSEcZTnksTrPanpKJLyIGV6izPTLLMOTsp2gHhF7CC+BJbsprxWTNrJzigYEYEMGBZ2u4/XQwBUXjjCrK2rQMuB2bLgQYRswFN3WbQRlNoF0CDlMNqZi/eR7P+HY9WwjcOhpoRbfe0tT7i/hYYWzM31mKajRw+6Mi2wdsdOfRvat6zK8+uGDYmfYfoG14CK5qATUC+W9KrdjpJiD/omg/lrUBDnDMYdq03/UsHW/oNeqc4wNv3AyHDxEf5N8QhlR4A6j4E3PHkJd+GdApUBoVMPr1sCBDF4Dh4p5qACfO3A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lR52Bi+Xz0K6v5BZT7hLCKrUJS5lxiGMArv5vn+mNk=;
 b=PeK58yytRWUrmzvmWwi0swqskD1LpWPw/Q5oG7twBmgALac7RrH/J7+01y6cKbwSUJdVmClMJV5wCxgq/mEwncwNngLi5XujDL6ePSPNWZVLq1D7JKJqcDpCag3965B2LxHGajUpolWorNTZzo/JThCxGJVY1E7FPwOqi6uu3CU=
Received: from DUZPR01CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c2::8) by VI1PR08MB5454.eurprd08.prod.outlook.com
 (2603:10a6:803:13d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 18:09:08 +0000
Received: from DB5PEPF00014B88.eurprd02.prod.outlook.com
 (2603:10a6:10:3c2:cafe::23) by DUZPR01CA0065.outlook.office365.com
 (2603:10a6:10:3c2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.9 via Frontend Transport; Wed,
 28 Jan 2026 18:10:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B88.mail.protection.outlook.com (10.167.8.196) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:09:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RI/evbCg0QyVTKsD8eXG2tvy8sVt0G44zxSnOAutwIJ8tWA2Om+rUABsdJTVDuN9JE7x0+eaaGy4y0QUlj3sDnZuwvHBBft62A0TZb1fFl05KXy8n47AGdjlN2q5z6OHOgH2N4ifce+gGve9xsGx4vvtcLJ3tVRp4WS1ZpZiek21VzEFUmr/h4koAOnD978U0QvoKfGy8+vPmPyCIGXoM9GQVxDgIVqCmvNaK6z15Y253jsx3IstFI+RuQGv97WOR3kPDoSwJIGNpaqYR5ZGUa+fDluihuosDABosenzfwkaL7FceBwu1jMsghqiBv5BezVne22JCd1xU2/TbY3mcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lR52Bi+Xz0K6v5BZT7hLCKrUJS5lxiGMArv5vn+mNk=;
 b=hFPin4G/6DvW8bzAXTZT4PEZ+TH6DxXHaognlXFFqhGy2ZWJzoPuCzKDGUTZvA03FePG74T0ccWWmpXAG59CBiZiKr8unMabYMCzg3tUGL3o5yg2w/OrRQ0G++0EKmqwQTxfPA1Ira5PdonplOa1XemhKktKBYfuZJV1oozDC2iKmJeDO41sha8fB2vK5NgqzeIcH/XFu+sRGPVpnVmRY1Dha801wnYF3tXxS7JhJ2aMUGMVkWQ8uuHTLGPkxvr7uvLdiKBTqE3FHnlOHKiQlaSNUbkmZHFt9BM9Z/jzAsmL+4n3tm4wtfxMysbm2EKBWnO5UZUUxL20Cu5TqtHv5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lR52Bi+Xz0K6v5BZT7hLCKrUJS5lxiGMArv5vn+mNk=;
 b=PeK58yytRWUrmzvmWwi0swqskD1LpWPw/Q5oG7twBmgALac7RrH/J7+01y6cKbwSUJdVmClMJV5wCxgq/mEwncwNngLi5XujDL6ePSPNWZVLq1D7JKJqcDpCag3965B2LxHGajUpolWorNTZzo/JThCxGJVY1E7FPwOqi6uu3CU=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:08:04 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:08:04 +0000
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
Subject: [PATCH v4 34/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Topic: [PATCH v4 34/36] Documentation: KVM: Introduce documentation for
 VGICv5
Thread-Index: AQHckIEMACX8/K6DL0WCDNLT+U6nig==
Date: Wed, 28 Jan 2026 18:08:04 +0000
Message-ID: <20260128175919.3828384-35-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB5PEPF00014B88:EE_|VI1PR08MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c693255-44c7-44aa-1051-08de5e985452
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?rf9M19zbvBfF69oH+ClEEEld4mf2cQQma4uD7vPeSwvOyh5ugQRRUoXsBg?=
 =?iso-8859-1?Q?egVeF/3F7WHN3Kg9hzGPfD7238PafsWm5dYBkFHybSFiW6n7uOrk7C2kCG?=
 =?iso-8859-1?Q?tAplUTBai2dQpSLwDPk1LQYTR1Q6Y4w7+8swepBT0Zlk+b+wVh1MTI7X19?=
 =?iso-8859-1?Q?WTXGfPk0iHFtJPAOljlHfIuSLPGMt5KU9yhgl0oWuS9MIvgH/Ab+ibZ/1C?=
 =?iso-8859-1?Q?3L3KQuHoXQgNiA8A+xspit4K9iEupWdSIBu5YoHTYjmZIowOxgFJMgc7Sz?=
 =?iso-8859-1?Q?wdpzNyHGoOTddsXEWiujPk4+EIv4M0bIz5n1q5ZxayCsIKo8BmDXHxjjc+?=
 =?iso-8859-1?Q?dvWL9pSiNxCFnWYlVKhF0vauFp5G9offXAKhRaSx93LraW3pAk+qs0Pxd0?=
 =?iso-8859-1?Q?lQBtpGbGkjYtiv36JHgHII6Es85Y0zg91Hk2vlQ5EaDGEmC+fLsKJ6jSAL?=
 =?iso-8859-1?Q?f8Tdq0tpgbrVwJrM26qsMGz9Vxx7Nn7ng4nIAd0cl7Zo/lXQzXrS7wHtZf?=
 =?iso-8859-1?Q?r3Y3UsUny4xs3PwYGkG6jt70jNyca40jgL1EMH3wbQe4orXrYxdYoPT5aw?=
 =?iso-8859-1?Q?A88PL6uSsixfOs86oYL4tjZZLw+pExZL/LSNg4h29+12hzCesga9iptDR+?=
 =?iso-8859-1?Q?6bCj9IvMZqTH7AkCTGN+9kvWQo4uhKazF3kLq+SL4M2LN1AUOoShDFI5J3?=
 =?iso-8859-1?Q?6sFB5v/Lj8FS3yuX+6qD2mMGfPw/k+PCQCdWP/jdKPcKn8z4brU2Y3yAUw?=
 =?iso-8859-1?Q?LDWv4EtpRcD3VXcQTT9S9PsIkBAjtywbUp32+gv7dTy1iAdIx+j8L2rHPd?=
 =?iso-8859-1?Q?AF7wDLN8H55om5ovUAT8FkX85S0xtjcHJq9un4/VKzU+D8OImeObKnQmTR?=
 =?iso-8859-1?Q?q4f03591c1mb+48fM2DjwehBF9pz6lZPXdgU+wJnr+mEWSKkiWvKlf9fvd?=
 =?iso-8859-1?Q?MBwjW9hwQbZEWw6AEak4IQxhtJQkn19NUw3QGyMxsNUqphVL7Bp1MR+QAE?=
 =?iso-8859-1?Q?J+3dgGmTaQIIniV0oGhaoYMG74x3h8Eet9N/e/vEoIqSA/sfQDhICY0W87?=
 =?iso-8859-1?Q?aXgCFZmDkE8/ZE65DI4pCKch80Kg2g6pdyieBB1PtHUBqL5RA6zkK5i9gZ?=
 =?iso-8859-1?Q?TCiewZbIaJV9JkG7W7Niajcp3BQ7RALdvYhkCabz+nYDWp1Y4PHjwNbmhU?=
 =?iso-8859-1?Q?CCod0ogbAZkl1il3td8lxvgYkII41ppYwTltMqwX2x3/0SEOhr/S8W9f52?=
 =?iso-8859-1?Q?GxC7xZbxbM13TOaCluv95zmZz5zRt4c+bp9albAIbGm/LfFxTA4YsdmD7d?=
 =?iso-8859-1?Q?K35JLtwEc9QBB1Cd7fBETZks/4gniiPexEmJ1RAAWsjM0U7vjLEttYekwW?=
 =?iso-8859-1?Q?REJ18EUvw32QFeLkeYFOnEFVP7hPQjU8/PAL/Z/p1O232ZhsTlbrbhZGvJ?=
 =?iso-8859-1?Q?tq/XgE/aquB2M1x0ZMVUrvaQ0+6niPMJ9brqe1axKFMKk3nlAV3JKltc+l?=
 =?iso-8859-1?Q?6pk8o6vaPkB690dVsasgfgwHbvrMKszzeo1386vJaOJ1zgFU4ujJ++wmlS?=
 =?iso-8859-1?Q?ZiSGpvbEWax3V92UUTFpFiSRB6QAIH8xal3CAVLVV/KnprwsM1sFVNXQJ1?=
 =?iso-8859-1?Q?cFihBbmuU5FVf6u8KG9Gh+nceQ7dC8YXyqKvlQIWpF07Tvesn4/ZI2TdJb?=
 =?iso-8859-1?Q?+fu2z9LrswtlSursXPU=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6744.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9740
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bdd08b6d-5537-42c4-d1c8-08de5e982ea4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|30052699003|376014|14060799003|35042699022|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?TfBSkw4fXVDzKBp0UUK5ymAGBhCUD2rCB9F8NFU4UAHmMyI1ezUYZNok3b?=
 =?iso-8859-1?Q?cjtviA2YIgLsnYT/HMYPzLjjjnN0ant3HS4/JUo8iAzzJ5886nPGloT99Y?=
 =?iso-8859-1?Q?ur+O9F0VFohCrwkQgJ0Gz1g8wtE0LJo8IDVuD9lpxYJi208mJ+inzrQP12?=
 =?iso-8859-1?Q?XWOpxPJHqcNcycRYIGaGxruPzp+2upobWURjk7NI2cC5K0w55UUPQI5aCi?=
 =?iso-8859-1?Q?Ja/jCJWUs7W5QTThVbeTPwH8e9jSy5ZViqsahS0uqNmTRW+xN36KFv01OU?=
 =?iso-8859-1?Q?T6DlbxnRPAC3Ms7CKF8cIXJrbZ1/bezL27rc6/CpB26UocG7DgJxlbxWTy?=
 =?iso-8859-1?Q?pk+1DHHTM7Xci+0MN7q6QYI6b0TrUfnfHh/L8+LcyVAH9UbyCmuyoYFcTi?=
 =?iso-8859-1?Q?uPRksfXgbpCdov4TjhaJc3FlX6UHZ+e5MmDYXBW7bHoo0hOO8qSfMVSSYg?=
 =?iso-8859-1?Q?cnRyaXD7QygjnC2Sh92yW1SsPA7VsAzTEg2bhpG9fWFtySPartAqxVrw7Z?=
 =?iso-8859-1?Q?wVrzgM6ndBgDsfGtmv2QLP8dJPg5SxSYAB/xT8+wBFNuSe4PE0XLA80b0R?=
 =?iso-8859-1?Q?82fu2eSGL8mvp/4CNT7jNfLAbxxzVlstniKCe8LKoiQNGh7t2BM89sQvuK?=
 =?iso-8859-1?Q?DStonC9KyFSlV2rlX8P+L6V+FbBLGZvOawXWa4E+M2QWES+YcwPML4IkpV?=
 =?iso-8859-1?Q?KF/3HuorCpQvQkyHSui8i7BlWQVI2ZGkSulg6uGkeYPye8w7H61V1M4B92?=
 =?iso-8859-1?Q?n0JjxLF4ZK4gutmcgjl3JmgM6WnPJOf9AuC/JbGh5nuQU6knWE/whu0tzw?=
 =?iso-8859-1?Q?2uSa0OxrhdtsIZIJ18EMOY1Ku4i+1L65nEHzXtdHRUlbc19i5OZ0N6Podr?=
 =?iso-8859-1?Q?kG5A+uaqvd3NGHN1dDIXtgT7+Db/N1X6Ql6XGTZdqW2f28KepCACdvk1fa?=
 =?iso-8859-1?Q?p9vt2WZNeTtpFyfox82tLVpDz3Lu5Q+SPfSJBR6EPAW36tRjChhObCSSuQ?=
 =?iso-8859-1?Q?c16r2KO8B+9f9TGD8pGQR9Q+/Z1+q7SXnw827PMTqx6hANfc+IrcvpxcpS?=
 =?iso-8859-1?Q?X/6LaaOomsfHv4dPCVIdToSe3RudLwC4nWkV9ZPAjefyE713d1N8yN0YpL?=
 =?iso-8859-1?Q?N/NLPGnQTRg2cNQbfKoBYxCqQRG1t9MesHRWMyAUZJd/xSF7XupPt3mxZH?=
 =?iso-8859-1?Q?403jJ/TavQtpNQzNIqvKxr4/ZIpJr67LegcNY43IulDFvGG60wzOml1ewS?=
 =?iso-8859-1?Q?fkEal40P4MaqRKSta4uJJfnMeAcRjq/zotpoYfbDcCnlLQLCILsO7B14z4?=
 =?iso-8859-1?Q?J9jCZdHSmzdS5rEJ46WkQgmBYaN37tDh2kSCmcmrXPEocJe/kPgdii36YY?=
 =?iso-8859-1?Q?O67WcPbku7nOIyqC5rP3YJqb0QGKAw5yF3n6rAMN3qFB8K8aNr+y3hX+dq?=
 =?iso-8859-1?Q?xDHcSlaXjupntuwWTxkFzC3t+pzQPvOugwTHLLGpfkOdiklnfygVSmdYVO?=
 =?iso-8859-1?Q?6QGe2ByTPKpvdxp/86WvF0tMwnrfmFIH4Ff94PJv0TJHnqdJ+DtWo42eXZ?=
 =?iso-8859-1?Q?G/L+2r+dTpLzIhR2Z+Id46CDgAcjhKqVFBGxlYAUvdd2SK6Hz3DuI4nGOh?=
 =?iso-8859-1?Q?BaDuffHM6putAdNrLquJFJgjrrGrgg7en7byrsBmnB5jhW2JZZ+9fHe98N?=
 =?iso-8859-1?Q?lXF0C7pu4axu7lamQ2eEzGDeuHTyXaFUHBttFYTRAwXP4jp9LuPrPlsIlb?=
 =?iso-8859-1?Q?rcFg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(30052699003)(376014)(14060799003)(35042699022)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:09:07.4861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c693255-44c7-44aa-1051-08de5e985452
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B88.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB5454
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69400-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 5637BA7998
X-Rspamd-Action: no action

Now that it is possible to create a VGICv5 device, provide initial
documentation for it. At this stage, there is little to document.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 .../virt/kvm/devices/arm-vgic-v5.rst          | 37 +++++++++++++++++++
 Documentation/virt/kvm/devices/index.rst      |  1 +
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/virt/kvm/devices/arm-vgic-v5.rst

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v5.rst b/Documentation=
/virt/kvm/devices/arm-vgic-v5.rst
new file mode 100644
index 000000000000..9904cb888277
--- /dev/null
+++ b/Documentation/virt/kvm/devices/arm-vgic-v5.rst
@@ -0,0 +1,37 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+ARM Virtual Generic Interrupt Controller v5 (VGICv5)
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
+
+
+Device types supported:
+  - KVM_DEV_TYPE_ARM_VGIC_V5     ARM Generic Interrupt Controller v5.0
+
+Only one VGIC instance may be instantiated through this API.  The created =
VGIC
+will act as the VM interrupt controller, requiring emulated user-space dev=
ices
+to inject interrupts to the VGIC instead of directly to CPUs.
+
+Creating a guest GICv5 device requires a host GICv5 host.  The current VGI=
Cv5
+device only supports PPI interrupts.  These can either be injected from em=
ulated
+in-kernel devices (such as the Arch Timer, or PMU), or via the KVM_IRQ_LIN=
E
+ioctl.
+
+Groups:
+  KVM_DEV_ARM_VGIC_GRP_CTRL
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_CTRL_INIT
+      request the initialization of the VGIC, no additional parameter in
+      kvm_device_attr.addr. Must be called after all VCPUs have been creat=
ed.
+
+  Errors:
+
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+    -ENXIO   VGIC not properly configured as required prior to calling
+             this attribute
+    -ENODEV  no online VCPU
+    -ENOMEM  memory shortage when allocating vgic internal data
+    -EFAULT  Invalid guest ram access
+    -EBUSY   One or more VCPUS are running
+    =3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/Documentation/virt/kvm/devices/index.rst b/Documentation/virt/=
kvm/devices/index.rst
index 192cda7405c8..70845aba38f4 100644
--- a/Documentation/virt/kvm/devices/index.rst
+++ b/Documentation/virt/kvm/devices/index.rst
@@ -10,6 +10,7 @@ Devices
    arm-vgic-its
    arm-vgic
    arm-vgic-v3
+   arm-vgic-v5
    mpic
    s390_flic
    vcpu
--=20
2.34.1

