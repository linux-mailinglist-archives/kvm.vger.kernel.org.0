Return-Path: <kvm+bounces-69401-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPt6D/ZSemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69401-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:18:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4AD0A7AA6
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:18:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D22230B0ACF
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091ED374171;
	Wed, 28 Jan 2026 18:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rHZWOUby";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rHZWOUby"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010008.outbound.protection.outlook.com [52.101.69.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F6374163
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.8
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623775; cv=fail; b=hMTW8YIb0PSAcBz40f81BG0DYzGRhtZzwdBhcRCT7XKijntnTS/lkk+XfEkgfM2nMlK0h7lV7DDq5/2RIAmDBv+8mA+dDXk882GxXXCHFmlwH/kfe5njIBIhtHrGLiVzZEzYe7LRCdmLD/H1dbeFozhRuhJlQiTF8a5OvNNfhIk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623775; c=relaxed/simple;
	bh=iiHoyJc3eQwygvDjpj74JS9O8KAqKFUsbWviPTW8HVk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oFXj6LGpYKttDdX+YT4bzsQFwh9Z1CB0D9k1LjCd3HOoCOMziMgti34VYHHpJQzFV0iNRGqrbfRpiVPOmVoTPtY8udJjjeBOvxwXnFlXSmYkI/RAJGnn/JTjUog3vHL3Qtu4xe/S5werpgdUbzKO1VfBkuibtGfdzFcY+eahBoc=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rHZWOUby; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rHZWOUby; arc=fail smtp.client-ip=52.101.69.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=zIGGZNtO5v4zDgxJxTQpCqb97hpQGnLJ84cVjGoyQ3pjTpsMjPYedMCQlTmuNJgivtkO/1/wJs0nd4XzVjhsj+ng3+JKzvCe2woDliNMLfcGVjCMeU24dbHyzzvpwK0QzPRFLBw6uU6raUFZJKnP7raSqTX+Sk6ZQEXdBBJPbCENHkbMLIcfcDWcM72v+DGYUKweYm6gStKMkeXpQ+RJ7uMz7P5gmRrugw2eSEaeJWBz7sNSpOAVjRV2kbnbmy+8KydIQbC3atZx1FKA4Svn0+8rI7/vCDl6yjy0bgBv213Ezt+byrXXgOma5iHu8DN9OMwPOeIdPvrCypdhQODOng==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJezKNIszVnwpNLqtJj81Gj7pLPeU1yJtwdgc9m9JDo=;
 b=DHgQXEJez898Ti36j3rX0Jq2sdodklSd+PvQXsRA4lZwV79422YkBsayFmyOVFzPg/E26p+WX966v9Z2268GYEIX+h/7u+e9q553RHB0hIeSyHhKrlmu6kkWlmDE80LlkWdzdR1sa1BVmTEZ8Iqc4Ve3KX1qR5rKVLC1K64h1HG+mc96St0d1YmwYfVObA0/ojGqaL8n5Ex0kbaU3z6N1bnfU8DX4cnbD2e+9ZGxAYkpaC9kjwgUPBFMsyKyRpD69zP5ig6mv/IczuVKukTE8Dptl2t8mMPxBdg53cHXE64ojeMR5s9/5NTN+yyXowlomgBR4M5EGK7vSxbikvgw9g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJezKNIszVnwpNLqtJj81Gj7pLPeU1yJtwdgc9m9JDo=;
 b=rHZWOUbyb01Axk3wVFUmaNC5sQk6oQBTeFNRB7YE2kCI1Zu2SCsSgCs6hmEIaqMuZley9DGFNisldvk30cnQB2reuhyrkMtCiXTArH5MfNgdl0bZry5IA2DNUbH5duyexNkjwa7/IWp9pEzqyNXjYgNY6NUFfSGUgdIGyYUnFVg=
Received: from DU2P251CA0026.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:230::28)
 by PA6PR08MB10858.eurprd08.prod.outlook.com (2603:10a6:102:3d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:09:24 +0000
Received: from DB5PEPF00014B94.eurprd02.prod.outlook.com
 (2603:10a6:10:230:cafe::93) by DU2P251CA0026.outlook.office365.com
 (2603:10a6:10:230::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:09:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B94.mail.protection.outlook.com (10.167.8.232) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:09:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yB8zCvnSJwtp1bQ9/v1f2fV++YU0xKl7q/2J5YuN/IBL/PMrDGDmEjSb158F9mx6Diilu+SAtWu7fEyTXDvORQaMivaHb32Lk80ejaEcNK27a8M46v+wsLw0qxFAoZWYyT6M9dP0wOK0z+v4mxH20nuZl7uyTZvSXoyoR5lU85PBmaIsu6TnoHlLi1KW2KRNCtFNRtG7T83MReDtJCiU/Wr85K8AFkvE9ydW40cOXSDS8Ox0Lj6bt8XEtdZ2rfWcv9LnukumUZXPlp1Q2ikKA8pCIVjvzup/Ash8VpOLZwv1PMjLcrWDbyojWTZXQNqHxMil4Tibu/XJv2b2MtGwsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJezKNIszVnwpNLqtJj81Gj7pLPeU1yJtwdgc9m9JDo=;
 b=FdLLrIQwlDLJ+2rmW7euZ/yQn/rnCcjyp+Mvcb/G3SpP6F8zinzvULUaJng9zWH1eBgv1p4RplfzojnbN815Q0RapOGA6UAh3cDdh0sMrR8vOBvMrKtFoao9WAzHkDYoH6DJoCtIaFNRYMpRvJiYZOgyBn6soo1NxBuBCGH51tcJuJC5kjKsazWr+WhqFrtI7Yv6Ig2LvVtI/SvnALlhK9Kmu938nD3rRiTQZxjE5MBnuygvjIbV3jDfOF5ntAENfSbzH4ZL1b9CUvhpgPNiBbCKzaut4rDtRY6xcwM5arCipM2jAZdawc8TJxD1ygGT+toK0VK9IRYTMpOWz5fK3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJezKNIszVnwpNLqtJj81Gj7pLPeU1yJtwdgc9m9JDo=;
 b=rHZWOUbyb01Axk3wVFUmaNC5sQk6oQBTeFNRB7YE2kCI1Zu2SCsSgCs6hmEIaqMuZley9DGFNisldvk30cnQB2reuhyrkMtCiXTArH5MfNgdl0bZry5IA2DNUbH5duyexNkjwa7/IWp9pEzqyNXjYgNY6NUFfSGUgdIGyYUnFVg=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:08:20 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:08:19 +0000
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
Subject: [PATCH v4 35/36] KVM: arm64: selftests: Introduce a minimal GICv5 PPI
 selftest
Thread-Topic: [PATCH v4 35/36] KVM: arm64: selftests: Introduce a minimal
 GICv5 PPI selftest
Thread-Index: AQHckIEVUJ6BS1gMyECR2J60LDyPmg==
Date: Wed, 28 Jan 2026 18:08:19 +0000
Message-ID: <20260128175919.3828384-36-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB5PEPF00014B94:EE_|PA6PR08MB10858:EE_
X-MS-Office365-Filtering-Correlation-Id: 191bde9d-793a-4f9a-a004-08de5e985e35
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?19E5xkS/+uJ2B9v1Ox1reeP/HRTrsoU4f0R4gPoVmR41MFU5nL+U54TNrv?=
 =?iso-8859-1?Q?sH1GbaArhfrVimYDDlGHWLNcOJ3e063dNalJBOkIzxLctKi2p/WKf9RD2X?=
 =?iso-8859-1?Q?eh55uM3lapSihTDpVSX6jQerIfOZC+yFCVIOixdTvHw4/Da5+4ea1UDhth?=
 =?iso-8859-1?Q?IgN5h9AVJ4Jp9Dlukgaw7rNvZsnusJ2kKdyeiCRi8E8ipLwXvPPzTIjAvc?=
 =?iso-8859-1?Q?cERnfZmb6lIx5LoA+YhGG7kH2CtB7CQn4HxxHJzdWWPgDcTgpcSFaAYVE+?=
 =?iso-8859-1?Q?aa8ZTBkN/IS2JaBe1GnVV/OHxz0Tw6grSF8dFVSEGP6RC/8ka0UPRAkjZj?=
 =?iso-8859-1?Q?WRJ52GSkNSUMP2ihisedxuoPKJQlmMRBOvFpi89Iqs2Ret0dZA/gVRAQDx?=
 =?iso-8859-1?Q?7VFWAq1afkhTUaNDmJMgWstYHdzwAMQB/vesI/4qYmNQIijw6kTtSdPwzj?=
 =?iso-8859-1?Q?cv5GyWhe6nmtaxIe/APJvs7setnxaJAZUYFtyOQ9ABDfeqXqu5Gv4+w3L2?=
 =?iso-8859-1?Q?hVTd7l3mRgHgnjhyL8XGStLY90CuOiXlIkktEtKX1kDPXkJmJk8KtkltQ6?=
 =?iso-8859-1?Q?GVTKd4JUIpRoy+JtD5AWUdnsKLkEoqMMaCbkgZUG+og8pOH/pFiJgNCPzG?=
 =?iso-8859-1?Q?H6hUKojbuFFHEdihGw7jXWy8y3pEjiIy4UULnOoKo+H9zK8mEP2lyullND?=
 =?iso-8859-1?Q?76bfvYD2OIEKUz5FrvfU3tgjWSDDgzO8qoUjyeMAfMLfP3Ux1CeEMK37Sp?=
 =?iso-8859-1?Q?QsDhg+dgyRE6GgEIGPiVYsudsRl/fmkCG8DjoARweC5yw06Wye0waU/H7q?=
 =?iso-8859-1?Q?MRraPbgx1FKil4c4Mi3rDysI2UmlI88bM8INtyP9kXTgEOdvzYBYePTafZ?=
 =?iso-8859-1?Q?R0TUde5EIk1/yVuby6tCAvwswsOH4qjDO9kKlszNvhmQzQiLcpkTc6qg+e?=
 =?iso-8859-1?Q?m5+wEG1vLQP8pwBQQwCtZdLO2MI5xqfVFhI22/O3IVB7TT3tqAjoUXO2K+?=
 =?iso-8859-1?Q?kVk6f85a5kXSGY+XLNvKAlK87NRzGGdDdWPmfbwFfwa75pdPvZ+a9Qu30A?=
 =?iso-8859-1?Q?m9mem3IzVFxRfWQ5NQQKazgo86mTSROY12Grhxe1cRebiYdqMwxcbwHVkD?=
 =?iso-8859-1?Q?xGdVPzQCNHB2AoJh/DaOZO4Gd3uEDdvOlbWGq56vE1Xv0vsVVqziRB/W0g?=
 =?iso-8859-1?Q?ZsD0IavOP8BAIPFkn5pvWnZ2v6SM+47C+/TDBr22vfNKpmOEAVpPNn0iSe?=
 =?iso-8859-1?Q?Etnrhjz9f554zuj+nSs1NACpFxbVFd8widZCn1TFggGakXdWvOpEpb1Cn9?=
 =?iso-8859-1?Q?NV55CDPhp05N5NInVNGEG+oTmC9yr9+FmIdTP2m4oyklukGKEMbpqAda3F?=
 =?iso-8859-1?Q?O/cpJM3iypMuV2Ns0NVISPITiU8zjo+lLKcJg/rGkWrZVTc7ibTU/oK5pV?=
 =?iso-8859-1?Q?t6dVe9Zb5zBgtrLubOtvFCqXn9byJ0vHgM64rKFXT0+MZSwJ4D0UcNHnKD?=
 =?iso-8859-1?Q?wQ55gU1y2WXHxYUQemG0jtLAgyQLN3PtV8FCde5rNo1RlnhIoYSvXvZuao?=
 =?iso-8859-1?Q?fcxdOSLNHx50s7pmpKnciP/rmnEJW0siittHmsZ2YlFhYSKaRDZCfUZqrl?=
 =?iso-8859-1?Q?O9+JRyA4Kd1jazK4kKbOaHePsmz+r5iye4AlLC7CbFOr1FqZ1wxtVaoI8U?=
 =?iso-8859-1?Q?QYt2VB5Uc0g+zgn61LA=3D?=
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
 DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2065de28-e16f-4666-9d89-08de5e9837dd
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|376014|36860700013|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?wssIHbY4V0dxkqtXWbrZ30Ca01b8tVUTBMtOLv8oXAUQTOEuKbHbeD9SYL?=
 =?iso-8859-1?Q?RLzv7APLIPlaRCMYkhJ2SjH+k1E4ldbGX4GZh1PFCDeg2ZkZxIk09N1nR4?=
 =?iso-8859-1?Q?TqzttEnpQXY4K7L6D/S2yveIuoWv+y3CqbuDn23TzLKO9KCe9WNyPn68iL?=
 =?iso-8859-1?Q?UsuZhU9V1gV57AsjlQOHkemdpkTNp50clqaEnlO1y1YADnX7q+hyqkQpep?=
 =?iso-8859-1?Q?HDBTjwmY9XSuGQOfo/sXf/8ddlIWlUo7Ob2903QkT1oSK5U3Zy9I5eVDM5?=
 =?iso-8859-1?Q?RyHo1L0udf3J+TtlZtz7AjU0LnH1dK36t/tfxULZRqWul46HCqrv3nN8Hf?=
 =?iso-8859-1?Q?9fMK7RPtAx1K2mf+ZvVCjJi/48RaK/mUvgeIrOm/zwZTxcnhJGO0/CQmah?=
 =?iso-8859-1?Q?j/w9RiN2+LrE6bEdGvwZ7jrlH49cUi7YZCR/P2l10MFGH8gSL/yIGPepCL?=
 =?iso-8859-1?Q?jcFHXRA41eroLExG9SMnjQKDzIqifHCJq3NZcxLNa8Ch9ChKM0mcRmsEwO?=
 =?iso-8859-1?Q?PprV9qLfGyVsX9Y4sp4KOpceYP/G893CH7eYHvVRjFIv0t9SzQS/AoV+R1?=
 =?iso-8859-1?Q?xskOwLtTAH/sBcHSzeYbJDSQlFi1DNqi9EsuxvrD2ah9L+iDQzjS34o78l?=
 =?iso-8859-1?Q?v6u7tIaPuYL8MsRnIfQyviMHHcrhvtvaDzm6361AtbcJVTvFIJnEIsOuO9?=
 =?iso-8859-1?Q?nczx1nnS51Wxkr3dKtkQxcuxvkQKHmZI2Jy2CUEISTbjQN/+ZPU6Nxhsxy?=
 =?iso-8859-1?Q?N8SCuOy2DEvt62c+j8NsbIH7XZ7pQm/1g4c1sL2roMQR6FHNoF7aIhnhAI?=
 =?iso-8859-1?Q?YADP343Kevp7WgFvu428bI0dB69qVm36VGthON335h0TjytHCfGDQQ1H9o?=
 =?iso-8859-1?Q?Q04ah3zyxYqYMT/Ax4IBQZn3VjH39Y6JPaLK3Kvvb53XT9GzjgkBP88vwv?=
 =?iso-8859-1?Q?RklNz3ZrlMoxPpuxGXG8dW1usRlBwBmboiYhy7sqeLQyB9Yzyiy4u0ALkF?=
 =?iso-8859-1?Q?EZ/gP6bYy/2zB9s2SUwopFNNC+eYr2rntAKNe+OXUrDccUoIimmrkKGFAA?=
 =?iso-8859-1?Q?jbqOtoUj5cRLOgJkTEIoEbFH1NOiDWM+uJVeFFRxFwEDyqXT8rQ2Btn4Qb?=
 =?iso-8859-1?Q?ieBt+p4PEsLUX/1hNVEsLnMNqBkbO6fGnenSzxEv+METLUxw6eg3PImWIN?=
 =?iso-8859-1?Q?1Kpya4lwcdsBNB3KjY+lP7tQ1L67TiKTPw6XBRin51+PQwAkfFrCjuRhq3?=
 =?iso-8859-1?Q?kHTnVdwto+12WRiX0sreyHwEEsK+GtAxqu9Nwdhv1WA8zi+OYDTX7PKHj4?=
 =?iso-8859-1?Q?KCD+Ob3GouVxjozZcQwWGuT7CF4ex5GzeLrNHN9KdwTlTQ+PDk2zU1OROD?=
 =?iso-8859-1?Q?OVlPTDEnyWXwKmkpecTUXuUzjDQi1e+v5r5EA68lewkVvEkWju10zMHe9I?=
 =?iso-8859-1?Q?bAk4MUTx8bCKqnMdz6+nKncLI/gq0bq7d5BFcEeT8p4x5ZQ2zPDLrjkEil?=
 =?iso-8859-1?Q?oorMFWwvd1JkaUaepJxbK4Yeo34yEWyUe5l7TFoiKmASa5nvuZ1tFdWoJc?=
 =?iso-8859-1?Q?MkAZyLUSWZ0Bt3oxea+ETGCUeKUWmjTwcXLyASOVpr9vtgfTrkhi6YKE00?=
 =?iso-8859-1?Q?Ng6PPh6dcisWeHUmWNQBXAMwwlJH2TRMRrY9R1YpnFAuY5ryjy7RBVgbCc?=
 =?iso-8859-1?Q?jOK8GGYEp/rzkC1DkiSHvzaEmfwFTTnCkMvmGl546OsXGB37W0apLiDMg8?=
 =?iso-8859-1?Q?NpEw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(376014)(36860700013)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:09:24.0680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 191bde9d-793a-4f9a-a004-08de5e985e35
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B94.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10858
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69401-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: C4AD0A7AA6
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
 tools/testing/selftests/kvm/arm64/vgic_v5.c   | 220 ++++++++++++++++++
 .../selftests/kvm/include/arm64/gic_v5.h      | 148 ++++++++++++
 3 files changed, 369 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_v5.c
 create mode 100644 tools/testing/selftests/kvm/include/arm64/gic_v5.h

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index ba5c2b643efa..5c325b8a0766 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -173,6 +173,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_init
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_irq
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 +=3D arm64/vgic_v5
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
diff --git a/tools/testing/selftests/kvm/arm64/vgic_v5.c b/tools/testing/se=
lftests/kvm/arm64/vgic_v5.c
new file mode 100644
index 000000000000..34e7cd634033
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_v5.c
@@ -0,0 +1,220 @@
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
+	uint32_t other;
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
index 000000000000..89339d844f49
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

