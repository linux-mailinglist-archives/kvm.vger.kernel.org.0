Return-Path: <kvm+bounces-69393-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFGkK7lRemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69393-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7352BA793A
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 79EB3306AC58
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57514374752;
	Wed, 28 Jan 2026 18:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VJewWNEk";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VJewWNEk"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012022.outbound.protection.outlook.com [52.101.66.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B8B1B4257
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.22
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623645; cv=fail; b=T3q1qUf8ZZP7iJFkvb0TBExO1pcfbBNgWiHZbuzo08QR68Vtd1p3ms4fy36E1YmRmkYdJeFMh7aXpVr4HdxQDm6P5VrOv/rK1tn7PbC2HuiWzxnE2pIc5S/1fraZWFLixPETOvhaB/4kD24+W7mNAEXCLIfSrrnNTeVUYVzxWtQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623645; c=relaxed/simple;
	bh=d26r+TxEYBwXEl4mUbEWNv5E8c/37a3mvu7dWvxei2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qkICxDoMMzhKdfVzZ1ViXkUYsiKf0ZAm1PmXdbz4jUyC+MUhd0DKSTHS06gh/mfWp7L9uHPwTlDtIPYQzhmHSBtRYpo7WIAnR3irlaInsZCJV6N61TbmIUy2dQUrRvO7YjseB72wqcdhNIgDkBCvf8hyxvl9gfNKJOPlkSSQhR4=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VJewWNEk; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VJewWNEk; arc=fail smtp.client-ip=52.101.66.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NlKsaV76YhZUWcQXsy7Vr6f2B+IlnsRX033EE4SC3y8OK36tUc731iOOCElZfKynFkg2cfKadGEr14/jC17o/qOcDc6/LybFJoPzjlm+9NZH1YvLYuR+bljO+QYocKuAcnbs3Ih07XNBSlxPIKZho0sCgGqf+sXtLktIfX6wb3xMUesRgUb0KKbM1l16vnotQym4VEXRXKbILKmrXAcOQizyzRHFCE4MPLLvzGzMpUzAkkkr3KZoAnsjeXyFSNXy+kTriAXes2CUpo7fi1rA4OarL2qA4EgzWhHfxCo0WbdcLEVdAarc6OxUHN/NVU8AtTqIcll7AUXlvcLYFnhkKw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjZThB9eouKgVFO87mG/lxHbicaENo32ZKY/Qo8i83E=;
 b=XaygSSAI6KEaEmbHdFysoBnV9nRxpa/b6UubkZbKK3ZGGV/wTaywPvBby3gNBM+xIXt4xSVkoNFkXC/vbzSYcpJHsjqea07akl+YQWiILgE6oxVgcgdRwubYvT6QI0MLSeKcI+rvxhadlDleOIKoJSGqEDnNkpn+hyMxvhDsoQJdSX6o3OOUgtWsWlgI1uvBa42LfPV2A4paGgK3RoEZsdNdHQSv1yXU6ycO5W4C41ZRZcBdhUHMB3Z2mf9WfmWvB4LlmGHxeUeeBL1V4or8NsxfTkuRf2ev1x0BdFg92IiRgCWk/gNd8D51xTQ9GWI/xKmoGHKybO/6GqR0VYh8Rw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjZThB9eouKgVFO87mG/lxHbicaENo32ZKY/Qo8i83E=;
 b=VJewWNEkLcBUelra8X+2BRA8GlqnwsVId0XNlTE6BOfpJEqjj2pwmHo7Zln82TvRgpxTNrFZa/0uDDcs63LyhNgubc0zBugb56Bjhdsf4U6p5POQdAsoU/mVBD7a1vz+aYz6Uyj1mxjUDiOFyNcbAqReX3NdcDQbZnPFYrLSc3Y=
Received: from DU7P195CA0014.EURP195.PROD.OUTLOOK.COM (2603:10a6:10:54d::25)
 by AS2PR08MB9200.eurprd08.prod.outlook.com (2603:10a6:20b:59f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:07:19 +0000
Received: from DB1PEPF000509F3.eurprd02.prod.outlook.com
 (2603:10a6:10:54d:cafe::e1) by DU7P195CA0014.outlook.office365.com
 (2603:10a6:10:54d::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:07:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509F3.mail.protection.outlook.com (10.167.242.149) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:07:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXC3nGMyo7QjNGURztv6CbTgjekdTvf8/luPSGq4Yz9/5LUoqRZtY18RUtaFCsxRHzYx6upR6Kys+JXDIntXwoefYEMrsDRfEHhaUpXXmH5RfHcVcp8o6jjEJpBCgsF39NoiXvJsGYs8cnoam8UWZ5+0HPgtEAou36J3VU3Tvcr9LjTGosgPuHaOdpf3T/1NU8KzDI2rQW3rT67TuHdIK/XuP0e5ClwN6zBN+hMoFfvqf5XPsEINPF+cYOqN0c/ah8aFyN7LKsTrAr9v+OOAXxSLYL4qPeg45WYbinbRkPfkI6487F1n7tCBmeQVPrH2QV+UixmrUzdQ1dwaee7rNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EjZThB9eouKgVFO87mG/lxHbicaENo32ZKY/Qo8i83E=;
 b=OvlKD7VkNwdj0yJ7qwaDzL5eO14TQoAFe2lr3FvQpx6CUVDTv5Izi6OskUvwjnpZT6mQ/jE7nIfvagvHY7NQtT/G/VSGpzaJFQS0mm6h8OdenbUE2a9oRxFQGE+KrOerbuMZ4v3LJmVeg5/qeybiIO7hwcttCVhj9jyDP4kmwqQUuPcDFqRDX4Pl5S5d3rRCt47tQ36k9ouKzHaqg7F2Q09cXIScyN3pr+hqKS2uQB4mW2ZfXTOIUgMOWiDMxwfKDwtTFFB19hRdrYkclLPIJGlCNWHY5pa3aBG8Nno/pKZvUG+D98T4OWTH42Kfa80GnBswaaH+jrP1AZPOwoaAVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EjZThB9eouKgVFO87mG/lxHbicaENo32ZKY/Qo8i83E=;
 b=VJewWNEkLcBUelra8X+2BRA8GlqnwsVId0XNlTE6BOfpJEqjj2pwmHo7Zln82TvRgpxTNrFZa/0uDDcs63LyhNgubc0zBugb56Bjhdsf4U6p5POQdAsoU/mVBD7a1vz+aYz6Uyj1mxjUDiOFyNcbAqReX3NdcDQbZnPFYrLSc3Y=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:06:16 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:06:16 +0000
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
Subject: [PATCH v4 27/36] KVM: arm64: gic-v5: Mandate architected PPI for PMU
 emulation on GICv5
Thread-Topic: [PATCH v4 27/36] KVM: arm64: gic-v5: Mandate architected PPI for
 PMU emulation on GICv5
Thread-Index: AQHckIDLVHxT9eZSK0yPuiOucFHmHQ==
Date: Wed, 28 Jan 2026 18:06:16 +0000
Message-ID: <20260128175919.3828384-28-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB1PEPF000509F3:EE_|AS2PR08MB9200:EE_
X-MS-Office365-Filtering-Correlation-Id: 83771684-627e-4c44-b8cd-08de5e9813c7
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?adg3oWy+EeCnZHGi/MxOCU2TlYKesN/MKj12sY2bNWfHLyhXkS6736n+yG?=
 =?iso-8859-1?Q?DIAYQ9c/ZPB2Kp69/iyBoCE2mwK7T5aU57RkD461VlLMR4aGrBbE/hzowL?=
 =?iso-8859-1?Q?n1lOWbuoPSh6KZTVNLmUbZl7kBHX2++kTK0vHDJGMszw1bspQOHQ13b6cx?=
 =?iso-8859-1?Q?1hTO9S58QrGIJ86Wz/ai8ehCiUC1edb5tzuEfDCcp26YjwYE6WkvG4gsql?=
 =?iso-8859-1?Q?suKLPK+5GqR+3X65cB/Rp1orwHQYBfIErudGbECa1gVhcvDrOyuNYmpdHY?=
 =?iso-8859-1?Q?5rukK9Y8Th+R6PiawRvTCA0Jwce55y6kf6/jl7vtPSkaA/lkaTOv4g9yUQ?=
 =?iso-8859-1?Q?Kc8RcqPAzRODC6jZkG43dGU3gnQyfzdd2oD1MhJtuzYfmd4fU9KPbcbd7Q?=
 =?iso-8859-1?Q?OiN9EQSBlXhK8Cbg/5fDCaRDloMoFYXnn16wFPQvVQ5rqUu76z/PsZ5ZQX?=
 =?iso-8859-1?Q?UEMvorwpsFJ/psmN1eVZOFc6c5Rsunk+rNdG/uWkFTEfDQawPdNW2eoQAZ?=
 =?iso-8859-1?Q?KeKHGALHBaD8DeYJuBa47votPbMX+VrdKQSVwXWia3h3Dlio7XRVWu7kvz?=
 =?iso-8859-1?Q?Wld3EruOMlFtwI6iXZzlv8oQ2F7zptEzm+77N8y4vplTch0iDhp1qpo7sf?=
 =?iso-8859-1?Q?4yPh4KFjfa0NEb6TnmLlV2arfuN1vFSAKO4xyJP/WcVNCFjcrr7ighkBJo?=
 =?iso-8859-1?Q?UR7CRIt1Ach9zMaplO+ULb2G+fcWcuRqoI/q0/ecB6U/UzgPwngJlx47eR?=
 =?iso-8859-1?Q?vANHe8IOr8IAQbW9Ql1mf9wk83cPsWiRErLki8jDLCb9k7xU6K88mPW3gY?=
 =?iso-8859-1?Q?D9MCbGT+HT9t91n3y/vRKPUBeghvWprmWgkOKUy12joCIUCF9WsNsBA6/L?=
 =?iso-8859-1?Q?ZLHF9GKYKA+5h3krTtvab/bPJpA9i4T/z6RFf4sAb+f9Aej5Lh9I8fM0FI?=
 =?iso-8859-1?Q?DyxmjGWbsYuwkeXV+QPWdRJxFr9ZRbUmHfYqLaraYmHBYw8KpsOsQQ/xzQ?=
 =?iso-8859-1?Q?BZZB17XvL+K42jnBpE3V78xWX0tLgi9sUTF0f5TYytFlgYXsRUHeUANi2X?=
 =?iso-8859-1?Q?MxR4R50J+HztNzHjaWzIH8NNvsHXl8qTf/hLfsW98sxxqRgRJgMs+LlywV?=
 =?iso-8859-1?Q?8HuXD4IU5KlK7FE0eGW/YXNA7SWL5y+TUEhIk+IVtypd7TNGy6XwcZnGlf?=
 =?iso-8859-1?Q?P06cXuw57vZjDeD9VqH3XbjLxk+kLB2d/UNoUIGFvw+NWcNhgi3RXupTNB?=
 =?iso-8859-1?Q?AcwKvhKPQ0VAb3RKvckjS6AnmI9djnvXgmUWA6+zSQa6gNbQB/BfuGOgG2?=
 =?iso-8859-1?Q?j79stP0mZIllxye3eJX1nYehY8thATNrRFyP7MoAsyM5UT8yzqYHybR+sy?=
 =?iso-8859-1?Q?BIcOvnA0khYU6stUwr+sKDbwtj60nm3ESL10yNbzKaQl8f0sCiy6jLO8t6?=
 =?iso-8859-1?Q?7V5Pb72mjjnZKzLp8gIFbnamL0TfyxbGJy2YHdtMKGTXzrZfUE2tRk35nG?=
 =?iso-8859-1?Q?hUPOqLV+hYBmFRKmpsFmTAQ87JdjNCPy9C5ZfvwwS1jXCteU9D0zFnC3+4?=
 =?iso-8859-1?Q?oROa4LfySCdOb/hXnHh7Aa40TWgnNRYsxQiVQygOcpQBBnFCLBi1YsNntV?=
 =?iso-8859-1?Q?73i53a/pSelKjVP0X4xu9jSAOBrm9QZwKeecAYJjO5sPIwsU1c6cmG812f?=
 =?iso-8859-1?Q?skX8d12mPF3MWOOJinU=3D?=
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
 DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	16e84b76-cba8-4a7b-63fa-08de5e97ee5e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|82310400026|36860700013|376014|35042699022|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?4zQ8IDstRwwpM4hTa876RBqbHARtJEpSHsMfXMufoZNI9kNi2I5QNY43Or?=
 =?iso-8859-1?Q?1Xnh3jWsbWBKjIamxE8kW/lkICwExO1N4GPXG9zfzvPmU3bHQsK/2Da3oI?=
 =?iso-8859-1?Q?aVT2PEO7bdjmbcU1Hs2gTkWcbYu714kr/TtX7QUFTLFliIVH75lcRpgevv?=
 =?iso-8859-1?Q?UNLeKJGuQGaY0PpQ2x4DcS58YK5RiW9CAD+Aolf8hQHz6u2UZtDRdqfXLt?=
 =?iso-8859-1?Q?DSR9ANOoKGCpwfmnRrpbImRu/tuMTCt8Th99ypnNGx9DXO2IF6ex3yFz9p?=
 =?iso-8859-1?Q?oj09vyXYkPXwODu0vUysBZCBiAPmi40uM+fv0TqxmmdJ9VKg3OT/3JO/NH?=
 =?iso-8859-1?Q?qX5AEj2PoiZviY88oL4N+B8aU9S5x8NPJsPhNVSKPk6HTzLv0YFR4K52//?=
 =?iso-8859-1?Q?WWUETIzi+r0IzxtsyGprjgQYsAuFDu318KuggTQH6yr0rvAwTyJhTj6HDi?=
 =?iso-8859-1?Q?wfS5LB08WcUy7B0cyWYXi0NW4Zcs5hoQiGmquVW77UqDkmYAaMa/k2O9u1?=
 =?iso-8859-1?Q?KWqPET+Bck35ADFfRkzWLep5y07UzAFeUYF7puKvIEz1mxYc9GqraYU1PK?=
 =?iso-8859-1?Q?idZ1eoTMBpoMCpNMp2o6W9NdkKt+iTjTCqldcxlIaBEKVfbgMSfL/8Guy8?=
 =?iso-8859-1?Q?c80ZgMe8B3UlW6nEUjSEFn+x8WvnRaRA0UZaan8nASgoI+ou4x+VYGQUs1?=
 =?iso-8859-1?Q?2ONMN1vOiQxK02pk52rvwFbhhDhpwbFGDjPx/x7lUONQK0ebt8CbLObKqG?=
 =?iso-8859-1?Q?bP3DePyCWIpa0YoS8SzJFQ4YFKusCYuw35ap9OnohcgF4temEOp+40e1hX?=
 =?iso-8859-1?Q?2zRRy7X+y5JXUQlgwrjZfKoet+iFrSmIs93jSB4XlMppO/2wBBv4Jpazz/?=
 =?iso-8859-1?Q?2sNAhK+Nh+Tvz2iKbI3q7QBoxraJiSKuGsQoCXed3gAaNXCFqYrLa+1vY5?=
 =?iso-8859-1?Q?sMl54PL80vFX0yfUNpGlOw1pYq7mADPMsDzQ4RQY7heBha0WH6dARA6m3T?=
 =?iso-8859-1?Q?ZeuWdWIJ3C1VF3Yxd4PhipUmg70z1ZQbSVbdRomzQWh5OjgzfMFWfa8lIt?=
 =?iso-8859-1?Q?ma4Fjlm09ZGBP2nDC3MK2yHCe9oC1z3moN7qimhQPQHiCt2qQ+jBYYV2DH?=
 =?iso-8859-1?Q?ECpnb8R3L0+EASy7d8yKL6l0Up7eIYTg1mR34SyaoEDjmL3iwzBWNzaOv7?=
 =?iso-8859-1?Q?3Lca+m9Cajeab+Orq480bUV817GVENX5sW4ngZwob5ziNhhX8thiZRp0eq?=
 =?iso-8859-1?Q?Pso3jfLIOZIppir8qwJeIzuA7//wJjJzJ9ngylNFxBgIcHc6/V+ijWfY4j?=
 =?iso-8859-1?Q?sjuoXm+JrZkmLrIDWqnUSj4g9FkhQcONoMZx948EM9ro9IXrfTUQIzbqc5?=
 =?iso-8859-1?Q?XwA1qafWyxDt4rvydfVrXL6r8xMB5DVIHLvfNsVmNkRVBqI1XfUudk0a1j?=
 =?iso-8859-1?Q?nf2jpUVH8XetzSDqin3X1iVX7JQNQLG2RJfawqkxUiQihT4Rwyv/t/OWNx?=
 =?iso-8859-1?Q?s96qMiBCl3rdY9qKmm06EQfXvyxRH8GFvzAnll7xmMHkUnBCUrgK6iyGcq?=
 =?iso-8859-1?Q?j5Zz2n5nSULPA/R0jCk2D0Zxh6voSHGo/K41thXNSpLrbX9SiAWM17+sq5?=
 =?iso-8859-1?Q?5Lf3EJdQWZ2RfrLGWu7zcrMvVvvS5TpDVdxH5YukYuWsiFJh8Ey/S13alJ?=
 =?iso-8859-1?Q?NPCdJGYssY/B9Uhl56GC+VuY63BuHPaZmqJYu7H1Drv5fKyjM/JK8wAP8m?=
 =?iso-8859-1?Q?pqGQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(82310400026)(36860700013)(376014)(35042699022)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:07:19.2004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83771684-627e-4c44-b8cd-08de5e9813c7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509F3.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9200
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69393-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 7352BA793A
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
index 60bf205cb373..5e3805820010 100644
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
index afc838ea2503..ba7f22b63604 100644
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
index 96754b51b411..0a36a3d5c894 100644
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

