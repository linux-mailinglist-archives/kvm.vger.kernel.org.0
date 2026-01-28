Return-Path: <kvm+bounces-69379-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oHKMGgtQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69379-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CC8F4A7743
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 46C7A302FA88
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9982434F468;
	Wed, 28 Jan 2026 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IBxMlMNP";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IBxMlMNP"
X-Original-To: kvm@vger.kernel.org
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013013.outbound.protection.outlook.com [52.101.83.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BE92737E0
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.83.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623462; cv=fail; b=Q1FJMKyzuLLbReoR1So2bCwjFXkEG1uyeBMY5Ylj+cRxPjX0PXguG5Q1nr9713PUjvgo7yZS4nJcL8zwTlGR6rMcNreoNo+KNtrIdTOOLFC1cj+RdA5JFotyDj31AIysdRjm2YjTz9vYKTlIP8ypzBYItf48ap/2COxYTSHiTV0=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623462; c=relaxed/simple;
	bh=Ed6vWSHYWVomJ76Foy2+93DzKPJ7SAvvvKlcN61IeXU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gPUa2IT9SAXJ3TdkBU2vsIOFXybquqjL4425RxV3qV9dSB5Pj5V8sErVEyJF5LwNBkfr3vjdtz8Fgh2F1mIXlDMt/aprcGOLO2LdDMWbAddAiyVmTfuZZfot3IjJQbcVBHZ9Oj1TxhjgVNOKbtmBC1whA0aj6fijavS/FFi7JuU=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IBxMlMNP; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IBxMlMNP; arc=fail smtp.client-ip=52.101.83.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=qgWJ1TVTrRrQeAmbldjtCdHTlilWIcupJ+nJiUfx1P58bBZmwrc324XcbwMpDEpTO2PcbuGdcdGMtitJ0Q8yTlekkopajD5NRnuBkD8m/KY+3FVP7DPNjKda6zGDbwHJ3YPyhOiOEFOdoqAQ2ljbvwot1fBA3KGZsGzI99P2DWsJ8FvFnSjyJ9cLvppIJc0BlYh7OpxLcMSMgrjRJ+Tuwn93iiZdl+pB5sqah+F08MDwb8LTJNSPEvhX5jkLJBpq5dBR/BpHQjh+Hok9nDCP6PMRDA0RQ69ChPOn6BUXy6qb+FUgvXk53l30eOYsNz2xdILBTi1sIvRoT0aDwsHVpA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDxYIvMVKZiRGtpy/Kj8oSpB+EfKoL8wtt3mCPSm2Yo=;
 b=a6eOtjtUx5p4zYT6aigDlYrIfaOiDBzgKxeY59/YZ5/OMOAIpn5d7zsxkThhluGhBhcwpD5zd8ufH6VSAzmYGHYVKwEJ8tKFMBovobJnv6xKhi4E/t3kjZ597URjRHqlWvXV61dyocKqcp5L2RQzEr6mUDUqoVH0YM42cR1ZS1RlZRieE0FLP6kJU4qzXadVs9hxH4utWuNnjDzumh7mAZuc+mQv2xcJwt15Xmw0Fv+QkP+qeQuguSUILMTH/Ilry6VEA3956e9b2DENnDiLJ/EYwYMlSifatjeEyUiPjpLhC01I0CP/YRZ0p+jwEhliTZ48xsfIeyXnjhc82XJDbw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDxYIvMVKZiRGtpy/Kj8oSpB+EfKoL8wtt3mCPSm2Yo=;
 b=IBxMlMNPNEUa9mlgUuPZqVDP8a4qsysf0KRIpaLNdTO8+Vz+5hyPJWlh77lhi3V7nG2cLMOaxjLRkUvIFyZO7TgeGvJ5+yjtxjPMAlAeVX49Z9z1qQoTupXWLfbjIPEh/D5wNj0JBxzcHGx7VdEQ4OBBd5NlfkfMJZ3UhNRMIvc=
Received: from DB9PR05CA0007.eurprd05.prod.outlook.com (2603:10a6:10:1da::12)
 by VI1PR08MB10241.eurprd08.prod.outlook.com (2603:10a6:800:1be::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:04:15 +0000
Received: from DU6PEPF0000952A.eurprd02.prod.outlook.com
 (2603:10a6:10:1da:cafe::4) by DB9PR05CA0007.outlook.office365.com
 (2603:10a6:10:1da::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:04:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000952A.mail.protection.outlook.com (10.167.8.11) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Wed, 28 Jan 2026 18:04:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N7Gc8QhUvssVOZxLI5aMc7lErak917sivS/NfYUPnk9FVnEoWSmvIar0D+ZR+5Uuf6Jvl4ubnrz2dLUK3SeLGpmvYSLdB9hAduIi0yz8BQznewc9sZ7I/BcAUNkPSJvKSCO9UL4g2h0WbtuoidzcLdZOf/nUYCfaNlZkCaeRDsad7FBgPYRiwvDaRCM+/dx6M/BcCWdB7JaeC+gwomVI/afZamebDP8K05wjuPJssAalxHz48pFtgEfv3JKIVWwSymb6w5zOcsIBC2A0GPaJ88hPNZvsq4usmctjWtaW9a2W/TvLE+ycUe4nigKq783XiDm0iwZMnuc5te+Ux5I5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lDxYIvMVKZiRGtpy/Kj8oSpB+EfKoL8wtt3mCPSm2Yo=;
 b=Rqc3du5joAYQYNXh2dHyvfGmleJqOzS2Buo6zrlglVJ4qqzg5Ehh77Nmf7bj569oz/KyddLtQU9pJ3rUyvfQVSgzglIsX5X7fqsEkvrThCmi2XAbRY6U/13O3aPO0WiVQPZmkRlZbRq9Oz1cRJWvM4kUnyHggwkEXrsf+yXID/+t4MxLbL9j4eQrZTl79i9X5x2p2yiCDm/jCw/KpM6RQXemWf3ph3EsLxSaouBuZBMpCUcBongOKo82FclPVY7zftN2tc6KO/GzWI0csNNcx1CF2/Mty3Kn3me4qR0yyMs0c04Vp9JzAFnu4Hww8ySw+Kr31XI3zj0Mg9K0B2cBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDxYIvMVKZiRGtpy/Kj8oSpB+EfKoL8wtt3mCPSm2Yo=;
 b=IBxMlMNPNEUa9mlgUuPZqVDP8a4qsysf0KRIpaLNdTO8+Vz+5hyPJWlh77lhi3V7nG2cLMOaxjLRkUvIFyZO7TgeGvJ5+yjtxjPMAlAeVX49Z9z1qQoTupXWLfbjIPEh/D5wNj0JBxzcHGx7VdEQ4OBBd5NlfkfMJZ3UhNRMIvc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:03:11 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:03:11 +0000
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
Subject: [PATCH v4 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put and
 save/restore
Thread-Topic: [PATCH v4 15/36] KVM: arm64: gic-v5: Implement GICv5 load/put
 and save/restore
Thread-Index: AQHckIBdv3AlnRSEY0u+kvS7SN61fg==
Date: Wed, 28 Jan 2026 18:03:11 +0000
Message-ID: <20260128175919.3828384-16-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|DU6PEPF0000952A:EE_|VI1PR08MB10241:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c2a0dba-fe8f-4a9b-2ccb-08de5e97a57a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?1tgj43nOaoWUglHMFnsZIhKJfoM5G9xLKuo5RU6ZnB9T9NUpzhuUi1SHKN?=
 =?iso-8859-1?Q?AyGRscDHjaKQepv8zuvTzgnILyz1+Jp7YXwTm0aP9xoGI7ild1zJLlZznM?=
 =?iso-8859-1?Q?5WR87eESSb/DYhR5qn7y0b/F2IPgu19azLEvkHmeY+gE/eClkfWIlHC69q?=
 =?iso-8859-1?Q?WzQ75oM7KC4cISMHtB+4g2MB1VJR6YHwPGNw+8eW9/M8uHMvHd2WhfawOi?=
 =?iso-8859-1?Q?XV+VUWwNqEUKElNdBbte+HKzy/bxlrtP4ZRcECV/QtmS/Q3P478tIO0InK?=
 =?iso-8859-1?Q?gztq2vT1zTU4fCn9GhoF20JUUSnA0l814e7B25lZa/eXef8dy8PetlPw52?=
 =?iso-8859-1?Q?y+Mr2LLJj3KYqwtm8sg8EMrML1E8CmIlvOd/3U0UgPdYpY5w5G55uJSrmk?=
 =?iso-8859-1?Q?PFa0nvrkgTs3jICBancwEu/O8Gt6DFFsPgZ3HHaItkrEroPb6bxK37CTSx?=
 =?iso-8859-1?Q?ix7FgWSz8IGrppXIL8T3H2W77VddlpyoN5OPtj0HggUP1nga9JiQ1tf+Ut?=
 =?iso-8859-1?Q?KMeGPzP1QpMfpYIfe4sJJ7U3VNajfcrwGtseycFDOU+u+BbuEGh/vBfv03?=
 =?iso-8859-1?Q?zz627+QFW2dYcux6JqZ0OcdVcb16mf4nXxTNKOWc0nt9tuCsj+agsmKnyL?=
 =?iso-8859-1?Q?qRlgMwxW4JdvV/kByZ+Wjjo6qgX4ts6IypaoJTLYBi4si84GwT2F03muBy?=
 =?iso-8859-1?Q?4b+hHtBZft2rz5YUTXZPnYgNafZvfTTq846v5Pe3n5I190AA4KJX6ngKX7?=
 =?iso-8859-1?Q?+YYtSjVzp+YVEyHLEK71TlK2oUYGPyjjLgxLlajGJxfl9h5ov7BD3j0OCG?=
 =?iso-8859-1?Q?6k24iy7C/1zlXzqNd2aXDtTaJpRhRGsaEJnttjb58fEeMfzD4ZocVYQRIx?=
 =?iso-8859-1?Q?39bekVDWEFhQ0vOhJoHqP5W+PPG3xwsglcapJ6z1nAWqXaitc0XhCNPl3s?=
 =?iso-8859-1?Q?XZ2kksUmALWigDf11Bjplu9kOkUAqxdgxAi5aDFcVkyF36SPAlDB9YGlz4?=
 =?iso-8859-1?Q?E6EODrGj3oEPlFrlJb56POLtA6Epmd0Wdkfi/FbKLMlsWpB/0OhgtogVIQ?=
 =?iso-8859-1?Q?07an5DpGWWN6MuV8m+NeVtBMuz64lUzTPBiiozCJLy6ECyMZR1cd9gaR3c?=
 =?iso-8859-1?Q?98WJLg0eqeQtOav2vc7CmoP+ctrtZ1AF5Z+TAda0aN2AZkpb6a32YD6MKB?=
 =?iso-8859-1?Q?3H9cKbQuIiLsRy8SR5lg0NA+7KNttZK4BfhoRqNcFzWVy5Ia0PykfW2lKy?=
 =?iso-8859-1?Q?IDg/R6YI8kEQo72G6oGKY+BgL0mNTDicuFkKTN7oAuQubdsCW7GDuCj6LC?=
 =?iso-8859-1?Q?kCFqIXcMSUwMb7hjIklbRe3WOu3xwen+14CdNoQYR/eIqGshJxJLZF9LG/?=
 =?iso-8859-1?Q?+p/bxiIXpjdNWcuk71JlX0hlirQhss3laA/pyXOQrmYtAzDKP09tveE5Rt?=
 =?iso-8859-1?Q?JO8wi8CITaxqjBCWFdLSp74fsZBz3idk6n/7Vy1e8W0v3oYVXeY+ia2MUf?=
 =?iso-8859-1?Q?ArQ9OdJZdPtQpegNx4030Wv3eisaknFYld3xxe4lTircKTV5SoWtzQGpJT?=
 =?iso-8859-1?Q?VkASIBND6SUQ8vferW6YkUizKH8wD5A6HwAn3F7O8pGA1hS33vMQ+McbZm?=
 =?iso-8859-1?Q?0I2uAeeTpEBjHv5ETfFxKpI25s0RHntNd3IPmOSJPuID2T0FnavMwmok9C?=
 =?iso-8859-1?Q?FKb1ermX/Ya/heJHu1k=3D?=
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
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8483
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000952A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f925b290-36ea-4b0b-a753-08de5e978002
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|1800799024|376014|82310400026|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?H/GXo28neZdzosV6Bns6OU9XF6SGN9bApcZpwWFNfKOc0BAA8vtVo7wmnn?=
 =?iso-8859-1?Q?DLth8JSlDQFb8oKMUQBBKwCKlKYSHXVIGGlZXN9ZI4rmN3tDmXOAu5xhI5?=
 =?iso-8859-1?Q?M259fq/71B2N5iJuxmaJEX/CxTqyMM6Rekiqmqe4JYqGbD+wUyGBFJyOUo?=
 =?iso-8859-1?Q?/17JnIzdRdU3rF/0mQZDyDXYmnlsP8nwGtwRUUzoXY2PTrFJpgOPyZ0nnJ?=
 =?iso-8859-1?Q?Ok16naLDU3i9ovsRb1fbP6XqQCCG4Ta+ZKVuZPslQgTg5xu6HS+vYGxcC9?=
 =?iso-8859-1?Q?1y4Tq5XSKbLAc0ZLTjd8OvfzGBLYM9EmAxia8/Nu6EnVTEVXdt6ngfrZq1?=
 =?iso-8859-1?Q?42KoXjLFGmgHMUz4oJ1AnxBTn3ECCZMYOTNzmeCLCcrQ1+TeFdZ+c/aDxC?=
 =?iso-8859-1?Q?bHX7blFK5aVyw5V2aJx5du9eMPqZLdqP+EYkokwKgu9eeVzsq3fFzA6eVM?=
 =?iso-8859-1?Q?PEAkkEEElhXN2KGFeikZq2z4edNrEc5oe1A72+p65MjXcCWtD6/sQ3HeCJ?=
 =?iso-8859-1?Q?zbBtR5Rz/WZ+QHsbvJlqM7IhAsJ48D5KVkU/ZjcGx3Xgl3zifoanZLkrPr?=
 =?iso-8859-1?Q?z8IpO4lh1ThEGNnAeAzNA11H1ZQbmw1v5iwuuUJA/AoW++2Fj5R1/2dEVr?=
 =?iso-8859-1?Q?SdYtq+lucA0EJuNprqf4xDb8zDfFgYVfABRHTrFmjnGYTEfoxbrsdDKOgp?=
 =?iso-8859-1?Q?h8oaX4iQoEMz/1nzEqybSdKHlYx+7HtbRfrYG3d+gRpdJaoO7R/UTPonDQ?=
 =?iso-8859-1?Q?3N7fnCmKXGY9WjsVtkvjnjfljmLHYt0qv7Kfumabb+IveFFixRA8wZ+EJm?=
 =?iso-8859-1?Q?gtvQ1vr2h/gpqhW8D2FPhO/uSO9e0DMvckrek40MYeYF8jPQX2HrWk5e0b?=
 =?iso-8859-1?Q?nsH1XkXvHUef77tMN+cn2D7dSn8C5zUKAbKcVgF+LvncRl4dEvt9C4uKEl?=
 =?iso-8859-1?Q?11gEa+kDD+gRAuZh0wp4ZDL+z1m1lawmq0nsvJzONeQo4ec3Egai6H0o4J?=
 =?iso-8859-1?Q?XUKL97mM2p5iDUopHzGZAyEgizvu7TSyXIbaRRPirxsH0IViVDgpMiY+EF?=
 =?iso-8859-1?Q?a00xyCuxR4/qEzMSEt/4DsgNGudr1CJvMS2gc5tVnJz2DbAWW7c/mx4eD0?=
 =?iso-8859-1?Q?CR0pDWZmzZacKK8OHQEnxv/Qu8bJFJWba+sWLIEyTJYPuIWjJsN5o439Hw?=
 =?iso-8859-1?Q?kPQCOSIfwzBFIeh33d2Kpl1IMuMoAzcaBkEDXHxHHueTJCC6RGqYvz6wah?=
 =?iso-8859-1?Q?m+x2SlIGy0aucOx3d6k2A6NaBaEzQzYi9X7dT6pawmxjtdDOLAkG/aR6tx?=
 =?iso-8859-1?Q?HTmkSx21ukYc8ouQDoIepkBBE3j2TuJ3+gUatgtsHzPugUD48bd+FHCcCV?=
 =?iso-8859-1?Q?1nuKuHxrKxLNQ+ZaMrL0YEhrhUFfB8xPPtBMYRiQr1TE4OEs3XO5uOc/sz?=
 =?iso-8859-1?Q?dsHMr2cAHfmWSrZmTF71qZ5V5clmU7qcfFGAQQxwURXKnLQ+lY4jqr9gAB?=
 =?iso-8859-1?Q?AFeDiMzGO+PztO1kSyUEqvCAQrKoqFHllsC1BgYSYbuRqx9BSUV4mCTiUZ?=
 =?iso-8859-1?Q?4rXXNWAD3wPu9Oeq6miDCb3i8QT1b+g9dRiJsSGj6g0BLLfMRz4G48uhsu?=
 =?iso-8859-1?Q?meIRID6Q0XSimvFgGkHLah0uzKo+yki5WBBxCJ5AojXF7koVdmODj+hAev?=
 =?iso-8859-1?Q?EAIS1i5rYinrx8kVua3JDI/VZygKWrFpe7cnEiyDCuqR5HyWabtB78imO8?=
 =?iso-8859-1?Q?PvgQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(1800799024)(376014)(82310400026)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:04:14.1391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c2a0dba-fe8f-4a9b-2ccb-08de5e97a57a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000952A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10241
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
	TAGGED_FROM(0.00)[bounces-69379-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid,huawei.com:email];
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
X-Rspamd-Queue-Id: CC8F4A7743
X-Rspamd-Action: no action

This change introduces GICv5 load/put. Additionally, it plumbs in
save/restore for:

* PPIs (ICH_PPI_x_EL2 regs)
* ICH_VMCR_EL2
* ICH_APR_EL2
* ICC_ICSR_EL1

A GICv5-specific enable bit is added to struct vgic_vmcr as this
differs from previous GICs. On GICv5-native systems, the VMCR only
contains the enable bit (driven by the guest via ICC_CR0_EL1.EN) and
the priority mask (PCR).

A struct gicv5_vpe is also introduced. This currently only contains a
single field - bool resident - which is used to track if a VPE is
currently running or not, and is used to avoid a case of double load
or double put on the WFI path for a vCPU. This struct will be extended
as additional GICv5 support is merged, specifically for VPE doorbells.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 12 +++++
 arch/arm64/kvm/vgic/vgic-mmio.c    | 28 +++++++----
 arch/arm64/kvm/vgic/vgic-v5.c      | 74 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c         | 32 ++++++++-----
 arch/arm64/kvm/vgic/vgic.h         |  7 +++
 include/kvm/arm_vgic.h             |  2 +
 include/linux/irqchip/arm-gic-v5.h |  5 ++
 7 files changed, 141 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index b41485ce295a..a88da302b6d0 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -113,6 +113,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 /* Save VGICv3 state on non-VHE systems */
 static void __hyp_vgic_save_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_save_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_save_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_deactivate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -122,6 +128,12 @@ static void __hyp_vgic_save_state(struct kvm_vcpu *vcp=
u)
 /* Restore VGICv3 state on non-VHE systems */
 static void __hyp_vgic_restore_state(struct kvm_vcpu *vcpu)
 {
+	if (vgic_is_v5(kern_hyp_va(vcpu->kvm))) {
+		__vgic_v5_restore_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		__vgic_v5_restore_ppi_state(&vcpu->arch.vgic_cpu.vgic_v5);
+		return;
+	}
+
 	if (static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif)) {
 		__vgic_v3_activate_traps(&vcpu->arch.vgic_cpu.vgic_v3);
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmi=
o.c
index a573b1f0c6cb..675c2844f5e5 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -842,18 +842,30 @@ vgic_find_mmio_region(const struct vgic_register_regi=
on *regions,
=20
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_set_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_set_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_set_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_set_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_set_vmcr(vcpu, vmcr);
+	}
 }
=20
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
-	if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
-		vgic_v2_get_vmcr(vcpu, vmcr);
-	else
-		vgic_v3_get_vmcr(vcpu, vmcr);
+	const struct vgic_dist *dist =3D &vcpu->kvm->arch.vgic;
+
+	if (dist->vgic_model =3D=3D KVM_DEV_TYPE_ARM_VGIC_V5) {
+		vgic_v5_get_vmcr(vcpu, vmcr);
+	} else {
+		if (kvm_vgic_global_state.type =3D=3D VGIC_V2)
+			vgic_v2_get_vmcr(vcpu, vmcr);
+		else
+			vgic_v3_get_vmcr(vcpu, vmcr);
+	}
 }
=20
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 9bd5a85ba203..f9f64cc0b58e 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -86,3 +86,77 @@ void vgic_v5_get_implemented_ppis(void)
 	if (system_supports_pmuv3())
 		ppi_caps->impl_ppi_mask[0] |=3D BIT_ULL(GICV5_ARCH_PPI_PMUIRQ);
 }
+
+void vgic_v5_load(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * On the WFI path, vgic_load is called a second time. The first is when
+	 * scheduling in the vcpu thread again, and the second is when leaving
+	 * WFI. Skip the second instance as it serves no purpose and just
+	 * restores the same state again.
+	 */
+	if (READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_restore_vmcr_apr, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, true);
+}
+
+void vgic_v5_put(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	/*
+	 * Do nothing if we're not resident. This can happen in the WFI path
+	 * where we do a vgic_put in the WFI path and again later when
+	 * descheduling the thread. We risk losing VMCR state if we sync it
+	 * twice, so instead return early in this case.
+	 */
+	if (!READ_ONCE(cpu_if->gicv5_vpe.resident))
+		return;
+
+	kvm_call_hyp(__vgic_v5_save_apr, cpu_if);
+
+	WRITE_ONCE(cpu_if->gicv5_vpe.resident, false);
+}
+
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr =3D cpu_if->vgic_vmcr;
+
+	vmcrp->en =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcr);
+	vmcrp->pmr =3D FIELD_GET(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcr);
+}
+
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+	u64 vmcr;
+
+	vmcr =3D FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_VPMR, vmcrp->pmr) |
+	       FIELD_PREP(FEAT_GCIE_ICH_VMCR_EL2_EN, vmcrp->en);
+
+	cpu_if->vgic_vmcr =3D vmcr;
+}
+
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_restore_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_restore_ppi_state, cpu_if);
+	dsb(sy);
+}
+
+void vgic_v5_save_state(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v5_cpu_if *cpu_if =3D &vcpu->arch.vgic_cpu.vgic_v5;
+
+	__vgic_v5_save_state(cpu_if);
+	kvm_call_hyp(__vgic_v5_save_ppi_state, cpu_if);
+	dsb(sy);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 2c0e8803342e..1005ff5f3623 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -996,7 +996,9 @@ static inline bool can_access_vgic_from_kernel(void)
=20
 static inline void vgic_save_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_save_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_save_state(vcpu);
 	else
 		__vgic_v3_save_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1005,14 +1007,16 @@ static inline void vgic_save_state(struct kvm_vcpu =
*vcpu)
 /* Sync back the hardware VGIC state into our emulation after a guest's ru=
n. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	/* If nesting, emulate the HW effect from L0 to L1 */
-	if (vgic_state_is_nested(vcpu)) {
-		vgic_v3_sync_nested(vcpu);
-		return;
-	}
+	if (!vgic_is_v5(vcpu->kvm)) {
+		/* If nesting, emulate the HW effect from L0 to L1 */
+		if (vgic_state_is_nested(vcpu)) {
+			vgic_v3_sync_nested(vcpu);
+			return;
+		}
=20
-	if (vcpu_has_nv(vcpu))
-		vgic_v3_nested_update_mi(vcpu);
+		if (vcpu_has_nv(vcpu))
+			vgic_v3_nested_update_mi(vcpu);
+	}
=20
 	if (can_access_vgic_from_kernel())
 		vgic_save_state(vcpu);
@@ -1034,7 +1038,9 @@ void kvm_vgic_process_async_update(struct kvm_vcpu *v=
cpu)
=20
 static inline void vgic_restore_state(struct kvm_vcpu *vcpu)
 {
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_restore_state(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_restore_state(vcpu);
 	else
 		__vgic_v3_restore_state(&vcpu->arch.vgic_cpu.vgic_v3);
@@ -1094,7 +1100,9 @@ void kvm_vgic_load(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_load(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_load(vcpu);
 	else
 		vgic_v3_load(vcpu);
@@ -1108,7 +1116,9 @@ void kvm_vgic_put(struct kvm_vcpu *vcpu)
 		return;
 	}
=20
-	if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
+	if (vgic_is_v5(vcpu->kvm))
+		vgic_v5_put(vcpu);
+	else if (!static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif))
 		vgic_v2_put(vcpu);
 	else
 		vgic_v3_put(vcpu);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index eb16184c14cc..9905317c9d49 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -187,6 +187,7 @@ static inline u64 vgic_ich_hcr_trap_bits(void)
  * registers regardless of the hardware backed GIC used.
  */
 struct vgic_vmcr {
+	u32	en; /* GICv5-specific */
 	u32	grpen0;
 	u32	grpen1;
=20
@@ -363,6 +364,12 @@ void vgic_debug_destroy(struct kvm *kvm);
=20
 int vgic_v5_probe(const struct gic_kvm_info *info);
 void vgic_v5_get_implemented_ppis(void);
+void vgic_v5_load(struct kvm_vcpu *vcpu);
+void vgic_v5_put(struct kvm_vcpu *vcpu);
+void vgic_v5_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v5_restore_state(struct kvm_vcpu *vcpu);
+void vgic_v5_save_state(struct kvm_vcpu *vcpu);
=20
 static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 64e8349dc0c0..8dfbaf6fb6a9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -432,6 +432,8 @@ struct vgic_v5_cpu_if {
 	 * it is the hyp's responsibility to keep the state constistent.
 	 */
 	u64	vgic_icsr;
+
+	struct gicv5_vpe gicv5_vpe;
 };
=20
 /* What PPI capabilities does a GICv5 host have */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index d0103046ceb5..f557dc7f250b 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -364,6 +364,11 @@ int gicv5_spi_irq_set_type(struct irq_data *d, unsigne=
d int type);
 int gicv5_irs_iste_alloc(u32 lpi);
 void gicv5_irs_syncr(void);
=20
+/* Embedded in kvm.arch */
+struct gicv5_vpe {
+	bool			resident;
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

