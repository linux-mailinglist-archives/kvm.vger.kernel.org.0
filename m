Return-Path: <kvm+bounces-69380-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAP0FBhQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69380-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB3ABA7751
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C118304F37E
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCBF36F425;
	Wed, 28 Jan 2026 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JXLhmztP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JXLhmztP"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011042.outbound.protection.outlook.com [52.101.70.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B62737E0
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.42
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623473; cv=fail; b=gIqeckKrnxSQTWfNjAXrrzdu95Kr94hRNyByOqGbhSHNssiGPqXNhgAvu/B0GcW9c7a3aLsA7hdqpyIRIz17F1a9uTDVoeiNQEmeOC3ke+ooyVH64V6hHaRM6XtKFtPo6+UlR53vNShMCDYCgemYqptDgWgcFuOA6I71/M42V4c=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623473; c=relaxed/simple;
	bh=wSTVGqy7rlzXS11DKlrHdaMVjHl1NktKjxqFsGD+7G8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZQlQBy9kd2YOcAbTvoCzoDmF/me0NTpn+T8uDNN4B+scMrTgGq7krLnwXENpyhz46SHkuwxrdYc49PNGj+uiUpaBPfUWJ28yPQiHvHY1UUprjGzHmBpwBiQ8I17TOKR+Os7F9sIWR+f5qbbsknYmVR+xwOdsY7tfqwsdAGKzAcI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JXLhmztP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JXLhmztP; arc=fail smtp.client-ip=52.101.70.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=HhtI6KKyYp2NDdEMZCtjtlduHvmA5jL1ag9unnrWE3x4+zphkWwGfq5Qp8hkwOoxAXcRu5KopHouGvN3pYeTV+rulKHyMlVsULRNJ9R9xzu44+8bSW/pQdpefEVRmmX48j/agnxIOqzV4SFKSmHFq+4V7yIJoW0F0Qywkz8d5co69ySNSHximu4YI9QWXoPWhTddJahmXjZKWwQ3EYUNrP7QWIu23j826tIrLSRYhUpzgcWpof0AH0HpjeJ4AhxyBz7RFyeRuBashDaUMRRIYktPiXLgTuTv+PhwxQeifWfOnKx1bkVOKECA54L0vjj5uoe0LJyDYs5J1S3JTEbvxw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYvXtf9wnEAB3d8ilmUCzXBZAp/WGfSeuqM1eZ+EJDI=;
 b=sru/p03Fnau8puxUMr3Yeqe5UodT3PSeLZ4zj9NWN/THDszrZ6XkQYtB5rf8HHQwfERQRha96sIb6bbSesssD7HqzXBgO0XlJtKPt3HQvugm+LR8E0PbrXdwlU2KCeatcEL7wYwiOKv2HFACNgTRYzGh4+9yI2D6kEJc9jo3ygTB/XhUXAokwYMhoeQLKzPgPBbTqgD0yABn/pQF58M06Kn+dyPdDk8YPQHOmafKkuaRfT8QDZX9IZLRsDbj5OXXcCMOx0OyGabhLErnnz12JtDGGm2eHiI8PUHoutxlZ81WpAFqCI2k3NUfogIv/n3xGTObXvbMedK7evIW2O6Fyw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYvXtf9wnEAB3d8ilmUCzXBZAp/WGfSeuqM1eZ+EJDI=;
 b=JXLhmztP1MuPbdBLWPr/MZffTqDeWgIH88luoxHyHZLv8A4oaDQsH6Iz8mArCw4dyhl1wg1TWKbc8yLXs9yy/mOb426pWySjrGeGltGl4Ddj4tgJOpJ4Oz94JbkuYmd4/+2i8s6NJ6lDSVhNajv30RmS/x/D2UY6qrLes4TsG0w=
Received: from AS4P191CA0024.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:5d9::18)
 by PAXPR08MB7465.eurprd08.prod.outlook.com (2603:10a6:102:2b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 28 Jan
 2026 18:04:25 +0000
Received: from AM2PEPF0001C717.eurprd05.prod.outlook.com
 (2603:10a6:20b:5d9:cafe::54) by AS4P191CA0024.outlook.office365.com
 (2603:10a6:20b:5d9::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C717.mail.protection.outlook.com (10.167.16.187) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQt2C/OAYm1ulWEKYzQVZvz79YO//uj025eAvvtLBA3jlXtW3garpPDq3EKFRiunaMKR/fMjPBlMeh4PRpqQZgrgm1gAXX8MyRvSM6lzo2NZ26dowpx7UmPpXXit/OOE+bUl2oN/31Ekf2N3Y2y7UKPfYxho/15zWEa70Ic55XszzQaEHAEXJxf5HW5LiijbnUjhHwIAZjuzzGXhQGUg/XokUVgiP+k1NR8DzNPIT0gnxNz86h4XkGpuoPkR7AtC8P1m/7dmV20LCQOf4yc1N876VWYOhxNdVi38EBlpajcFrerqoVvMWfi3CU/Ppz8wmTy8q0TSTYtX0DqAB/EJbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYvXtf9wnEAB3d8ilmUCzXBZAp/WGfSeuqM1eZ+EJDI=;
 b=k5xifL+ro9Xg/YhnUJ8fHaVRgxWKvp7YxHyss55k+EDIDOS4AmJo3ZrUOe2+H8JvDTqfxsFdhcVKI9XUXk6Uj3d9hMKWqyp30m1rdaUMO4jDntHXjUFfJfKv/nFnJBSBSIPFpNdjdMwr7ic0YuUcj92bILeQklIVlBxTdEjhmAklcXDhv8rz+bysK9VQGFC28LOzcdYH5nymHjDQKWormWagaPorRpu5pB4JE7aUyeW/JeMdDeskA/7Sa3g3SNsGQzDkfJya0rTKlTjv3lx8wpikVQB8Ruy0bfDQ6UpP7N/1x3a9WOySLDC7OgaaA9K3yqCqJAb6/xy7mF27bfR47g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rYvXtf9wnEAB3d8ilmUCzXBZAp/WGfSeuqM1eZ+EJDI=;
 b=JXLhmztP1MuPbdBLWPr/MZffTqDeWgIH88luoxHyHZLv8A4oaDQsH6Iz8mArCw4dyhl1wg1TWKbc8yLXs9yy/mOb426pWySjrGeGltGl4Ddj4tgJOpJ4Oz94JbkuYmd4/+2i8s6NJ6lDSVhNajv30RmS/x/D2UY6qrLes4TsG0w=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:02:25 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:02:25 +0000
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
Subject: [PATCH v4 12/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Topic: [PATCH v4 12/36] KVM: arm64: gic-v5: Support GICv5 FGTs & FGUs
Thread-Index: AQHckIBBVTWc4BpE/kmw8bTfLidXSw==
Date: Wed, 28 Jan 2026 18:02:25 +0000
Message-ID: <20260128175919.3828384-13-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|AM2PEPF0001C717:EE_|PAXPR08MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: c54e31b6-6d92-4261-6d16-08de5e97abe7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?t/jXhfpA81jsD0Eg4QTg3ZucS/2hjZj6xowzPsPRaFCReEbs7Db/O2TvA9?=
 =?iso-8859-1?Q?prVE2wxcYnEG6GHe3Ax28GLm0aSBcOPWKflmway0sjRyT7NSn8UOah5wnS?=
 =?iso-8859-1?Q?sCstGyjeUUDcCbRFomDCoWEYumE2vo7miIBjxytvx+RLY499BYNgqJiSYa?=
 =?iso-8859-1?Q?MMcotV2D2hwu11XH6Ihfm2cZK8t1Zc3vXIX5VBsmhJrVbeldxe1+i1//zy?=
 =?iso-8859-1?Q?VffDE6sVyCYU8Ymj9g9P+LixLAzTKwdazINFYuYeBAMVif8Bu58FfkFRjd?=
 =?iso-8859-1?Q?ADWrDvG0B0pdPn3HM5wpiVdL0U6V2ogDTQGTAULT5hENBs/wQMgSjHFujh?=
 =?iso-8859-1?Q?G2NHaBgTXB57fZV0qFN6lBLHu15BEmp54LB5WINfSMtwqFcQjQNubsfujL?=
 =?iso-8859-1?Q?Wjdchr1CE92nvNBN6R9W/AyI3Ssm6xFaP9EGPASJ4mK/sRVbzsY+Q2Wf6D?=
 =?iso-8859-1?Q?rghqTAYuWjYVwpinosHt0EilrjXsh55he9byS+UcZ57gOc1m0/PNx1y1gW?=
 =?iso-8859-1?Q?DCAYkgCP7YhHfhgrQN+KzycKtMwLZAWZljc0B9DYka4vUh14/xrwZmdKcq?=
 =?iso-8859-1?Q?mCUoCj08hnWr96LQdg/sZwI5mxXiQyzb8+HUT6QM9PZ0A7KJaN8FHJz5QY?=
 =?iso-8859-1?Q?fEdG3wCMJUocUkpElm244aNRa6HVKeLZ8MP6GGHYisiTo7UnvbKKGeWesR?=
 =?iso-8859-1?Q?lwR7qrx+hzGQyz8TWC1uVyxdI+vJ8Z/5ag/JpYdztSmslOt7c6dLkY1R8V?=
 =?iso-8859-1?Q?ECS7a9YRJTcz7cXq6SqIG6j/yJVCEnjwqbJPWhuz4Nbic7Y/P9XlFG/2NU?=
 =?iso-8859-1?Q?N+otHykMzAXQKWsc8jcEi4/Mp7+DigFwoLMvHBmYRbzx/rV+piFTsuWafF?=
 =?iso-8859-1?Q?iw9mIDcW1GFE36o1aeEYSjRiM1GmcvvXaLGRhPvH0/n38nl6vd6yYmi7w4?=
 =?iso-8859-1?Q?h4eBz6mG/RMfmcV/cYX7njzRmWYH23Vv2L4ftmnHnrDCFg3621WPfv0F0i?=
 =?iso-8859-1?Q?iTElUpeOooQTYlO+us18Za0vHoPViUGC0mtxf4dvEjkPAYHKQ3JhSDWIKb?=
 =?iso-8859-1?Q?0wFRFHKjL1IgUr3c18+IESW1gsZ4ReqHuS0yEDxW+6brotTDfsZfjb1ukG?=
 =?iso-8859-1?Q?w1qM2750EOx/V8xREn+DQ5j1TC5oAN9S9LDN02xieM3D5jT/V7AN03WIck?=
 =?iso-8859-1?Q?0jU590KbokC0ZEKCi/4UvPfoSHXmsvw40Dcev4nKvlaRhLiBfpKv16nBDk?=
 =?iso-8859-1?Q?Ee3Ss0H68fjBsaHbaGYYKlHkF+ojG8if96XF0MOVvNGsXrvp2v9tDPbnyI?=
 =?iso-8859-1?Q?9NLZXSw71L3C75oGB9aKMaF1VLUGAVgVQBjUWOIXVo0sWgW6ImmRulalBp?=
 =?iso-8859-1?Q?d4qtTeUbVuPbYyAhIbSoBMuPIDbABXYrRFM4Zjpgr4FGRKv7kEbel374cm?=
 =?iso-8859-1?Q?fCYoi7a/cjaq28bmBRI+RLZzWlhvNNlUpUcTcSNXzZEWNpB/wOSVtKAjiN?=
 =?iso-8859-1?Q?8qxBw36+10VEI567eiamT/aMffuGeoEVy+2crVkkVLqVNu7L/WaST14ve3?=
 =?iso-8859-1?Q?R7dpuR2sCa4Y5NOwW2pdnKbj3VgzUHR46LtI+bjgdoE8yW95Lky778InEd?=
 =?iso-8859-1?Q?ETfYIOilDUgBPDMohrLC1GPkIBHqQkWxHm+hOCdERKJ8oKUK/SnVzPvbqy?=
 =?iso-8859-1?Q?LzwxNUCHBTlPaFL3Wic=3D?=
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
 AM2PEPF0001C717.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4f24450d-0f40-4b47-21cd-08de5e976469
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|376014|36860700013|82310400026|14060799003|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?3/A5D7pXNgrEg7kcYfolidlPkHieEt29tu2gbJRgY+FmFJzG21IP7Zgz2m?=
 =?iso-8859-1?Q?wSNE5vOZ8VBlnIYyROew5LO7cfE/p+nKuuz6f5eu37emSX37T1dYH6Apr6?=
 =?iso-8859-1?Q?hCtTGPLB78VMRBuvFe8iqo6oywlQXzDlkHrDOwpcFypJbbc+ubJ/VbMuSy?=
 =?iso-8859-1?Q?GfJqhmLLbaxkfPcuat177Eh43R7lUs7o+Z3NPQDTbn7KC2UXYkM6KMNdTn?=
 =?iso-8859-1?Q?HYaDDJeuVvqm7EHD3B7JhA0tmp8sFOZuKoIWo+ikUWdjCP0jU2dUN89rnP?=
 =?iso-8859-1?Q?yHn7oQNvZKMzfkhF3M/JA4uDl5cxxE60SKejw8F4UkBsnmhbgCqogabTst?=
 =?iso-8859-1?Q?76vDkPwGA7AJBxV27jxSLFZ6mabskkNUNa9q/jZmwYJvKy3mT3iLErUrm+?=
 =?iso-8859-1?Q?CWedm0G3GmlG8B5fzqVppzpx1NOShCY1xjuXvitbq7BLI/MAV3cgYqwzbM?=
 =?iso-8859-1?Q?dYNxjd+9AOa/1O6q1ydlNLg07Q/AjEsat5pAT8UVRJuZf1t2weGrlbRZZY?=
 =?iso-8859-1?Q?B81AAOvWLEL4M/9Arny9hEHeDXJE87+mWip2j7pqsy0cuAeokZRZIav0Ua?=
 =?iso-8859-1?Q?BuxbLP6htOHREp83KBPWNk4JuycznJjClHAsx+igsD0yAVMgGoZyvLCZe2?=
 =?iso-8859-1?Q?MTYcZPhiUZ8I5y/YEeTNizlvAmkaqdVl1990N8lKHmN3hUlbU3Y/QQXizB?=
 =?iso-8859-1?Q?90PAv/1WSXKNzMJAuKJ8SMFFWFf8R/ufdq7iNqeN/2Mdf405pDKFOA+MPH?=
 =?iso-8859-1?Q?k7LA/1jZWR0aLdt4IvgJolSFwjPGRIsjJgqMWNZZeoSS4a4axtOvE8hVEX?=
 =?iso-8859-1?Q?GoWzJOJAvu6cuj6W3UlyV8wINcwuS4T5oW51bKp90QqJVB/l/PX6QB0ORH?=
 =?iso-8859-1?Q?uttby/5AICsBnhtnEhO13yWhWBv226JOIkofMkB9gksvOZJDK41i29y6Kj?=
 =?iso-8859-1?Q?CTe+l1wZzlStnQXoP2K7FWNNA0PUu8NKIEf+c+m8DyqQMpYXaQeF6Ol1ZD?=
 =?iso-8859-1?Q?p43OduJ/VmadX9X1kmtOFr7p+GM//jCh0uH0JlF5t1Op5MgwP/z2h8XBK5?=
 =?iso-8859-1?Q?Dkg7T0urBo11UPzChocJCJcdY/siz9e+qqEhENbu4ayFsRz5FrRdC/qGOM?=
 =?iso-8859-1?Q?aIdC9DzLcP+fTVdMgRaVSFqS/in5Q9qJTTx/ns+Le+zLpuFLIor8rcPppc?=
 =?iso-8859-1?Q?yE6LwUMivOLtSCs0Cflr0CKmcVIpojHYJK9Tr5cjBhg4en7QNtnMTUGH3g?=
 =?iso-8859-1?Q?96fEDj7EJ5fmzGbVHB+iwEg/HGcf5DSselESPGCXPsjte0B93F7VbiGRx4?=
 =?iso-8859-1?Q?QnkEuID9A5M7bv30akCrOExwxCk8NS19fI3YV0310S4YcN0QMoOF7sD5f7?=
 =?iso-8859-1?Q?xUwRzZQakoOzzm1CLFsz0a1kNKWuGp0ylNIKagQpShylqezS2l2lY1vQ26?=
 =?iso-8859-1?Q?uWMMiaFRvocf2uJcL/SR6QMms0rtmOzD9dwzJzN+rRdIr9Zn4C0Hey4p0l?=
 =?iso-8859-1?Q?XKuoFVTKsJaV9w+BRP1qhusXmGcXM5i8inFu+RGSLL7evuG3Oe0JMEkTNE?=
 =?iso-8859-1?Q?aO6FBRYNwrSmbQQLSabZJ1NGWLdYd0Ce5fEpdRKxjzYs90PQ7tEwMMqCxP?=
 =?iso-8859-1?Q?29tBWktws5BGyUgNDQsPQNng+hjdgoQNE32iOoSgv73K55MOipGrJqFhs5?=
 =?iso-8859-1?Q?+LX4VHdtEq07pDr2EWzu/2WfMgvhKlp4hCJDdicAenvK4rYAkt2awWzXcs?=
 =?iso-8859-1?Q?LSkw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(376014)(36860700013)(82310400026)(14060799003)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:04:24.9392
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c54e31b6-6d92-4261-6d16-08de5e97abe7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C717.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR08MB7465
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
	TAGGED_FROM(0.00)[bounces-69380-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: AB3ABA7751
X-Rspamd-Action: no action

Extend the existing FGT/FGU infrastructure to include the GICv5 trap
registers (ICH_HFGRTR_EL2, ICH_HFGWTR_EL2, ICH_HFGITR_EL2). This
involves mapping the trap registers and their bits to the
corresponding feature that introduces them (FEAT_GCIE for all, in this
case), and mapping each trap bit to the system register/instruction
controlled by it.

As of this change, none of the GICv5 instructions or register accesses
are being trapped.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/kvm_host.h       |  19 +++++
 arch/arm64/include/asm/vncr_mapping.h   |   3 +
 arch/arm64/kvm/arm.c                    |   3 +
 arch/arm64/kvm/config.c                 | 103 ++++++++++++++++++++++--
 arch/arm64/kvm/emulate-nested.c         |  68 ++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  27 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |   3 +
 arch/arm64/kvm/sys_regs.c               |   2 +
 8 files changed, 221 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index b552a1e03848..0e535ef50c23 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,6 +287,9 @@ enum fgt_group_id {
 	HDFGRTR2_GROUP,
 	HDFGWTR2_GROUP =3D HDFGRTR2_GROUP,
 	HFGITR2_GROUP,
+	ICH_HFGRTR_GROUP,
+	ICH_HFGWTR_GROUP =3D ICH_HFGRTR_GROUP,
+	ICH_HFGITR_GROUP,
=20
 	/* Must be last */
 	__NR_FGT_GROUP_IDS__
@@ -623,6 +626,10 @@ enum vcpu_sysreg {
 	VNCR(ICH_HCR_EL2),
 	VNCR(ICH_VMCR_EL2),
=20
+	VNCR(ICH_HFGRTR_EL2),
+	VNCR(ICH_HFGWTR_EL2),
+	VNCR(ICH_HFGITR_EL2),
+
 	NR_SYS_REGS	/* Nothing after this line! */
 };
=20
@@ -652,6 +659,9 @@ extern struct fgt_masks hfgwtr2_masks;
 extern struct fgt_masks hfgitr2_masks;
 extern struct fgt_masks hdfgrtr2_masks;
 extern struct fgt_masks hdfgwtr2_masks;
+extern struct fgt_masks ich_hfgrtr_masks;
+extern struct fgt_masks ich_hfgwtr_masks;
+extern struct fgt_masks ich_hfgitr_masks;
=20
 extern struct fgt_masks kvm_nvhe_sym(hfgrtr_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgwtr_masks);
@@ -664,6 +674,9 @@ extern struct fgt_masks kvm_nvhe_sym(hfgwtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hfgitr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgrtr2_masks);
 extern struct fgt_masks kvm_nvhe_sym(hdfgwtr2_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgrtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgwtr_masks);
+extern struct fgt_masks kvm_nvhe_sym(ich_hfgitr_masks);
=20
 struct kvm_cpu_context {
 	struct user_pt_regs regs;	/* sp =3D sp_el0 */
@@ -1632,6 +1645,11 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg
 	case HDFGRTR2_EL2:
 	case HDFGWTR2_EL2:
 		return HDFGRTR2_GROUP;
+	case ICH_HFGRTR_EL2:
+	case ICH_HFGWTR_EL2:
+		return ICH_HFGRTR_GROUP;
+	case ICH_HFGITR_EL2:
+		return ICH_HFGITR_GROUP;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1646,6 +1664,7 @@ static __always_inline enum fgt_group_id __fgt_reg_to=
_group_id(enum vcpu_sysreg
 		case HDFGWTR_EL2:					\
 		case HFGWTR2_EL2:					\
 		case HDFGWTR2_EL2:					\
+		case ICH_HFGWTR_EL2:					\
 			p =3D &(vcpu)->arch.fgt[id].w;			\
 			break;						\
 		default:						\
diff --git a/arch/arm64/include/asm/vncr_mapping.h b/arch/arm64/include/asm=
/vncr_mapping.h
index c2485a862e69..14366d35ce82 100644
--- a/arch/arm64/include/asm/vncr_mapping.h
+++ b/arch/arm64/include/asm/vncr_mapping.h
@@ -108,5 +108,8 @@
 #define VNCR_MPAMVPM5_EL2       0x968
 #define VNCR_MPAMVPM6_EL2       0x970
 #define VNCR_MPAMVPM7_EL2       0x978
+#define VNCR_ICH_HFGITR_EL2	0xB10
+#define VNCR_ICH_HFGRTR_EL2	0xB18
+#define VNCR_ICH_HFGWTR_EL2	0xB20
=20
 #endif /* __ARM64_VNCR_MAPPING_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 620a465248d1..370153462532 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2475,6 +2475,9 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(hfgitr2_masks) =3D hfgitr2_masks;
 	kvm_nvhe_sym(hdfgrtr2_masks)=3D hdfgrtr2_masks;
 	kvm_nvhe_sym(hdfgwtr2_masks)=3D hdfgwtr2_masks;
+	kvm_nvhe_sym(ich_hfgrtr_masks) =3D ich_hfgrtr_masks;
+	kvm_nvhe_sym(ich_hfgwtr_masks) =3D ich_hfgwtr_masks;
+	kvm_nvhe_sym(ich_hfgitr_masks) =3D ich_hfgitr_masks;
=20
 	/*
 	 * Flush entire BSS since part of its data containing init symbols is rea=
d
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 3845b188551b..6e8ec127c0ce 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -219,6 +219,7 @@ struct reg_feat_map_desc {
 #define FEAT_FGT2		ID_AA64MMFR0_EL1, FGT, FGT2
 #define FEAT_MTPMU		ID_AA64DFR0_EL1, MTPMU, IMP
 #define FEAT_HCX		ID_AA64MMFR1_EL1, HCX, IMP
+#define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
=20
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -1168,6 +1169,58 @@ static const struct reg_bits_to_feat_map mdcr_el2_fe=
at_map[] =3D {
 static const DECLARE_FEAT_MAP(mdcr_el2_desc, MDCR_EL2,
 			      mdcr_el2_feat_map, FEAT_AA64EL2);
=20
+static const struct reg_bits_to_feat_map ich_hfgrtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGRTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGRTR_EL2_ICC_HPPIR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_IAFFIDR_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_HMRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGRTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgrtr_desc, ich_hfgrtr_masks,
+				  ich_hfgrtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgwtr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGWTR_EL2_ICC_APR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_CR0_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PCR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_ICSR_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ENABLERn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PENDRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_PRIORITYRn_EL1 |
+		   ICH_HFGWTR_EL2_ICC_PPI_ACTIVERn_EL1,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgwtr_desc, ich_hfgwtr_masks,
+				  ich_hfgwtr_feat_map, FEAT_GCIE);
+
+static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] =3D {
+	NEEDS_FEAT(ICH_HFGITR_EL2_GICCDEN |
+		   ICH_HFGITR_EL2_GICCDDIS |
+		   ICH_HFGITR_EL2_GICCDPRI |
+		   ICH_HFGITR_EL2_GICCDAFF |
+		   ICH_HFGITR_EL2_GICCDPEND |
+		   ICH_HFGITR_EL2_GICCDRCFG |
+		   ICH_HFGITR_EL2_GICCDHM |
+		   ICH_HFGITR_EL2_GICCDEOI |
+		   ICH_HFGITR_EL2_GICCDDI |
+		   ICH_HFGITR_EL2_GICRCDIA |
+		   ICH_HFGITR_EL2_GICRCDNMIA,
+		   FEAT_GCIE),
+};
+
+static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
+				  ich_hfgitr_feat_map, FEAT_GCIE);
+
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1211,6 +1264,9 @@ void __init check_feature_map(void)
 	check_reg_desc(&tcr2_el2_desc);
 	check_reg_desc(&sctlr_el1_desc);
 	check_reg_desc(&mdcr_el2_desc);
+	check_reg_desc(&ich_hfgrtr_desc);
+	check_reg_desc(&ich_hfgwtr_desc);
+	check_reg_desc(&ich_hfgitr_desc);
 }
=20
 static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_fea=
t_map *map)
@@ -1342,6 +1398,16 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt)
 		val |=3D compute_reg_res0_bits(kvm, &hdfgwtr2_desc,
 					     0, NEVER_FGU);
 		break;
+	case ICH_HFGRTR_GROUP:
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgrtr_desc,
+					     0, NEVER_FGU);
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgwtr_desc,
+					     0, NEVER_FGU);
+		break;
+	case ICH_HFGITR_GROUP:
+		val |=3D compute_reg_res0_bits(kvm, &ich_hfgitr_desc,
+					     0, NEVER_FGU);
+		break;
 	default:
 		BUG();
 	}
@@ -1425,6 +1491,18 @@ void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_s=
ysreg reg, u64 *res0, u64 *r
 		*res0 =3D compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
 		*res1 =3D MDCR_EL2_RES1;
 		break;
+	case ICH_HFGRTR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgrtr_desc, 0, 0);
+		*res1 =3D ICH_HFGRTR_EL2_RES1;
+		break;
+	case ICH_HFGWTR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgwtr_desc, 0, 0);
+		*res1 =3D ICH_HFGWTR_EL2_RES1;
+		break;
+	case ICH_HFGITR_EL2:
+		*res0 =3D compute_reg_res0_bits(kvm, &ich_hfgitr_desc, 0, 0);
+		*res1 =3D ICH_HFGITR_EL2_RES1;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		*res0 =3D *res1 =3D 0;
@@ -1457,6 +1535,12 @@ static __always_inline struct fgt_masks *__fgt_reg_t=
o_masks(enum vcpu_sysreg reg
 		return &hdfgrtr2_masks;
 	case HDFGWTR2_EL2:
 		return &hdfgwtr2_masks;
+	case ICH_HFGRTR_EL2:
+		return &ich_hfgrtr_masks;
+	case ICH_HFGWTR_EL2:
+		return &ich_hfgwtr_masks;
+	case ICH_HFGITR_EL2:
+		return &ich_hfgitr_masks;
 	default:
 		BUILD_BUG_ON(1);
 	}
@@ -1510,12 +1594,17 @@ void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu)
 	__compute_hdfgwtr(vcpu);
 	__compute_fgt(vcpu, HAFGRTR_EL2);
=20
-	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
-		return;
+	if (cpus_have_final_cap(ARM64_HAS_FGT2)) {
+		__compute_fgt(vcpu, HFGRTR2_EL2);
+		__compute_fgt(vcpu, HFGWTR2_EL2);
+		__compute_fgt(vcpu, HFGITR2_EL2);
+		__compute_fgt(vcpu, HDFGRTR2_EL2);
+		__compute_fgt(vcpu, HDFGWTR2_EL2);
+	}
=20
-	__compute_fgt(vcpu, HFGRTR2_EL2);
-	__compute_fgt(vcpu, HFGWTR2_EL2);
-	__compute_fgt(vcpu, HFGITR2_EL2);
-	__compute_fgt(vcpu, HDFGRTR2_EL2);
-	__compute_fgt(vcpu, HDFGWTR2_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF)) {
+		__compute_fgt(vcpu, ICH_HFGRTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGWTR_EL2);
+		__compute_fgt(vcpu, ICH_HFGITR_EL2);
+	}
 }
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-neste=
d.c
index 75d49f83342a..de316bdf90d4 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2044,6 +2044,60 @@ static const struct encoding_to_trap_config encoding=
_to_fgt[] __initconst =3D {
 	SR_FGT(SYS_AMEVCNTR0_EL0(2),	HAFGRTR, AMEVCNTR02_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(1),	HAFGRTR, AMEVCNTR01_EL0, 1),
 	SR_FGT(SYS_AMEVCNTR0_EL0(0),	HAFGRTR, AMEVCNTR00_EL0, 1),
+
+	/*
+	 * ICH_HFGRTR_EL2 & ICH_HFGWTR_EL2
+	 */
+	SR_FGT(SYS_ICC_APR_EL1,			ICH_HFGRTR, ICC_APR_EL1, 0),
+	SR_FGT(SYS_ICC_IDR0_EL1,		ICH_HFGRTR, ICC_IDRn_EL1, 0),
+	SR_FGT(SYS_ICC_CR0_EL1,			ICH_HFGRTR, ICC_CR0_EL1, 0),
+	SR_FGT(SYS_ICC_HPPIR_EL1,		ICH_HFGRTR, ICC_HPPIR_EL1, 0),
+	SR_FGT(SYS_ICC_PCR_EL1,			ICH_HFGRTR, ICC_PCR_EL1, 0),
+	SR_FGT(SYS_ICC_ICSR_EL1,		ICH_HFGRTR, ICC_ICSR_EL1, 0),
+	SR_FGT(SYS_ICC_IAFFIDR_EL1,		ICH_HFGRTR, ICC_IAFFIDR_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR0_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_HMR1_EL1,		ICH_HFGRTR, ICC_PPI_HMRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER0_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_ENABLER1_EL1,	ICH_HFGRTR, ICC_PPI_ENABLERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR0_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SPENDR1_EL1,		ICH_HFGRTR, ICC_PPI_PENDRn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR0_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR1_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR2_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR3_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR4_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR5_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR6_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR7_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR8_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR9_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0)=
,
+	SR_FGT(SYS_ICC_PPI_PRIORITYR10_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR11_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR12_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR13_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR14_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_PRIORITYR15_EL1,	ICH_HFGRTR, ICC_PPI_PRIORITYRn_EL1, 0=
),
+	SR_FGT(SYS_ICC_PPI_CACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_CACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER0_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+	SR_FGT(SYS_ICC_PPI_SACTIVER1_EL1,	ICH_HFGRTR, ICC_PPI_ACTIVERn_EL1, 0),
+
+	/*
+	 * ICH_HFGITR_EL2
+	 */
+	SR_FGT(GICV5_OP_GIC_CDEN,	ICH_HFGITR, GICCDEN, 0),
+	SR_FGT(GICV5_OP_GIC_CDDIS,	ICH_HFGITR, GICCDDIS, 0),
+	SR_FGT(GICV5_OP_GIC_CDPRI,	ICH_HFGITR, GICCDPRI, 0),
+	SR_FGT(GICV5_OP_GIC_CDAFF,	ICH_HFGITR, GICCDAFF, 0),
+	SR_FGT(GICV5_OP_GIC_CDPEND,	ICH_HFGITR, GICCDPEND, 0),
+	SR_FGT(GICV5_OP_GIC_CDRCFG,	ICH_HFGITR, GICCDRCFG, 0),
+	SR_FGT(GICV5_OP_GIC_CDHM,	ICH_HFGITR, GICCDHM, 0),
+	SR_FGT(GICV5_OP_GIC_CDEOI,	ICH_HFGITR, GICCDEOI, 0),
+	SR_FGT(GICV5_OP_GIC_CDDI,	ICH_HFGITR, GICCDDI, 0),
+	SR_FGT(GICV5_OP_GICR_CDIA,	ICH_HFGITR, GICRCDIA, 0),
+	SR_FGT(GICV5_OP_GICR_CDNMIA,	ICH_HFGITR, GICRCDNMIA, 0),
 };
=20
 /*
@@ -2118,6 +2172,9 @@ FGT_MASKS(hfgwtr2_masks, HFGWTR2_EL2);
 FGT_MASKS(hfgitr2_masks, HFGITR2_EL2);
 FGT_MASKS(hdfgrtr2_masks, HDFGRTR2_EL2);
 FGT_MASKS(hdfgwtr2_masks, HDFGWTR2_EL2);
+FGT_MASKS(ich_hfgrtr_masks, ICH_HFGRTR_EL2);
+FGT_MASKS(ich_hfgwtr_masks, ICH_HFGWTR_EL2);
+FGT_MASKS(ich_hfgitr_masks, ICH_HFGITR_EL2);
=20
 static __init bool aggregate_fgt(union trap_config tc)
 {
@@ -2153,6 +2210,14 @@ static __init bool aggregate_fgt(union trap_config t=
c)
 		rmasks =3D &hfgitr2_masks;
 		wmasks =3D NULL;
 		break;
+	case ICH_HFGRTR_GROUP:
+		rmasks =3D &ich_hfgrtr_masks;
+		wmasks =3D &ich_hfgwtr_masks;
+		break;
+	case ICH_HFGITR_GROUP:
+		rmasks =3D &ich_hfgitr_masks;
+		wmasks =3D NULL;
+		break;
 	}
=20
 	rresx =3D rmasks->res0 | rmasks->res1;
@@ -2223,6 +2288,9 @@ static __init int check_all_fgt_masks(int ret)
 		&hfgitr2_masks,
 		&hdfgrtr2_masks,
 		&hdfgwtr2_masks,
+		&ich_hfgrtr_masks,
+		&ich_hfgwtr_masks,
+		&ich_hfgitr_masks,
 	};
 	int err =3D 0;
=20
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/i=
nclude/hyp/switch.h
index afecbdd3c1e9..c7a5335d80be 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -235,6 +235,18 @@ static inline void __activate_traps_hfgxtr(struct kvm_=
vcpu *vcpu)
 	__activate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __activate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__activate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__activate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+}
+
 #define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
 		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
@@ -267,6 +279,19 @@ static inline void __deactivate_traps_hfgxtr(struct kv=
m_vcpu *vcpu)
 	__deactivate_fgt(hctxt, vcpu, HDFGWTR2_EL2);
 }
=20
+static inline void __deactivate_traps_ich_hfgxtr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt =3D host_data_ptr(host_ctxt);
+
+	if (!cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF))
+		return;
+
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, ICH_HFGITR_EL2);
+
+}
+
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 {
 	u64 r =3D MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
@@ -330,6 +355,7 @@ static inline void __activate_traps_common(struct kvm_v=
cpu *vcpu)
 	}
=20
 	__activate_traps_hfgxtr(vcpu);
+	__activate_traps_ich_hfgxtr(vcpu);
 	__activate_traps_mpam(vcpu);
 }
=20
@@ -347,6 +373,7 @@ static inline void __deactivate_traps_common(struct kvm=
_vcpu *vcpu)
 		write_sysreg_s(ctxt_sys_reg(hctxt, HCRX_EL2), SYS_HCRX_EL2);
=20
 	__deactivate_traps_hfgxtr(vcpu);
+	__deactivate_traps_ich_hfgxtr(vcpu);
 	__deactivate_traps_mpam();
 }
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index 779089e42681..b41485ce295a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -44,6 +44,9 @@ struct fgt_masks hfgwtr2_masks;
 struct fgt_masks hfgitr2_masks;
 struct fgt_masks hdfgrtr2_masks;
 struct fgt_masks hdfgwtr2_masks;
+struct fgt_masks ich_hfgrtr_masks;
+struct fgt_masks ich_hfgwtr_masks;
+struct fgt_masks ich_hfgitr_masks;
=20
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc)=
;
=20
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 73dd2bd85c4f..8d017844ab5f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5636,6 +5636,8 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	compute_fgu(kvm, HFGRTR2_GROUP);
 	compute_fgu(kvm, HFGITR2_GROUP);
 	compute_fgu(kvm, HDFGRTR2_GROUP);
+	compute_fgu(kvm, ICH_HFGRTR_GROUP);
+	compute_fgu(kvm, ICH_HFGITR_GROUP);
=20
 	set_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags);
 out:
--=20
2.34.1

