Return-Path: <kvm+bounces-69395-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Pb/ONJRemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69395-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB72A7949
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:13:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 347323071029
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3748B372B30;
	Wed, 28 Jan 2026 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gp2nLzHC";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gp2nLzHC"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012013.outbound.protection.outlook.com [52.101.66.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E8A37105C
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.13
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623676; cv=fail; b=rdLrV/IMlw3USvlGvWJHUYOkyWOHWw3sGXLkpXn/j0/zO7mkKMmpKUMqyIyNQhL7RWEXDp3bP4Aa8zE959aZ1wdxclkgDwaZUFETvIkecbYWRqCC+TBYVnon4F1+6u5AtsHzS1KeWJYlpn6ZD0ENW7Nl117nbSH7bLT+18gOJLM=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623676; c=relaxed/simple;
	bh=UpL8zbBNabGKR7LUEI0EvK5sJyUZATcw1t17XhcYpyk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=M0FKr8sjFSOMUgQ/v6jX4ioQz0hc9CrTAcc+YC1KfrJRg6QUqD0J9RbddZXTPhRhVIUhCMNSmabjKwZZfiJX0zi0nlm3HijALaezQskI5IdJw9gOJ6QIE0r5No1FfVGBWnTBrqYWHgqyK4VS3lC4/peyizrR0Om67YugI6FIBdE=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gp2nLzHC; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gp2nLzHC; arc=fail smtp.client-ip=52.101.66.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bLtH9SVZs5NOvfLz7s/jxqAFxV3kjt5MaEuRGYtPvtWDJBIvCOlcq7ULPbroqrOckIHWweGwXZ4axyV2ShFuSzCODuxg1N+imOKlf2M5S8fJ6M1KupPneub8FWYzXd2j9l4RwQ9JBXTqaT95Dy9SJ10pGQJPRscwdH1HRqYsjN2+lLarJnv/1bMnHnmj2dw6t05f16uff80mFneQ3IV5yVph0MCqg7+0H1XY10NGPG0FQeTuzr4UeoMJht/Gs6h9rgbu9014Pmvsy1JYEd7QXzSid9yVO6UkJp+EDYsZv7WNLydSFKuEqIGmwlSdbem/w7F0WkqV+HWae8RBopNDyg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EedL2iCswphU3GTYo45jvpb9x7D40pY76QR4T9FABQw=;
 b=pZgh2ZP/XNuhEAfbGXWhd4tenIg1vcXwoJNpiTBA4cqCstNTkXS8mXXs6HVRTJYSz1cSbxJw8Sosi7fIYtq0bXuGq8vMAiBiceA8E0fgD4x06g1xkzmJzF3ga/mYH4a0utor9DlB3Y8DKmZ+WeRVXCM7mpjFg7PwTksWDWsBssW67fRM1OogF80bNnq0s/omQs+ph+PKKJgewpcB2bwsOCV/HdNeiXJTCxkfGpLp7kdy9q4nlSZhTEP/zXSHZxKlsx6Q4pKHfjL4bwMUkq3kYJLzf4Y5CZ7TDuOO3V76XZ0UpBt2p9QAeO4hjjuF+AGATMo/SYcKtmjtgiU/BRxR0g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EedL2iCswphU3GTYo45jvpb9x7D40pY76QR4T9FABQw=;
 b=gp2nLzHCJgitku/yTrNaiNIgLwi4l+r1/eCqx7DQ8Kg79ES79A/9r+wIEsXGu79RjA1WkmyuKJOYBAe+SaZcIjkU7KXpcHuJt0HeGiuhsfM/ZyhhyvJOCZ5kLEm8HbWYRZdynu6lRZ+o1E9yNI7dTJ/+Ce0gYtyqshLbVx7/Eoc=
Received: from DU6P191CA0064.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:53e::24)
 by VI1PR08MB10073.eurprd08.prod.outlook.com (2603:10a6:800:1bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:07:50 +0000
Received: from DB1PEPF000509E3.eurprd03.prod.outlook.com
 (2603:10a6:10:53e:cafe::c1) by DU6P191CA0064.outlook.office365.com
 (2603:10a6:10:53e::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.9 via Frontend Transport; Wed,
 28 Jan 2026 18:07:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509E3.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.4
 via Frontend Transport; Wed, 28 Jan 2026 18:07:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=My3XKkdGZxT1d3Sw0fei3LCh4rcP93UB95nm09j6qLrayUz03hcM4o3f6Gp7qz1J4VvM6myDlA/h9iZKc6TX3NA+AslGXB0/ayr4JBZb+BqJkVBzFPeM5WYNW/Xqewg/IN1YDHPTVWPkM9hfkriWIbx3HtEmLC58Gpqxtd7RpKOrGvhtB1XuxwXcibdNv6RzKLUuKpTjFbY8hvvTqbSy73+OIT5LGcTGcfxSwWwltGkY35VrRlJNFpIrhmMzF6gG/PhpFDI/tVVrlNeHb+pYT7BE6utlhoepj5jw/a0/NQGpu5gZnapwACMf9vzTw2aMzVuGcXXJJFWqgTA4Ql7ZRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EedL2iCswphU3GTYo45jvpb9x7D40pY76QR4T9FABQw=;
 b=AVtFXF1sly92tz32PVeXH+cgLo8P8e+OmHAFZ9H96tjU389K7ahF4LX97/VaPixQ1AT3a3X5ViwCLXgiRyA9lKDHxcVjvusn5KhnpSWSoHwGm8NPHvNGlRZe6pr96R/c9WBxYCGfUpL9GXSLqc+vuZuPC5FUnZxAtGHIcuCTMyEQtVM2YNwQHJECDLBcgYY+XKTvgCxqM8qlgVsk9SOCJubR3yjSsOMftG5zT2p41cyzVKMoGzyvpvFw+ZZPfKdrexef5h5LJU7CEpNQRYjOcOR/HaY9374iAS8kYpEETkOcqFFOwrdaMd9hzUEclQSrAG9MGirlJZAYomcJ7kJaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EedL2iCswphU3GTYo45jvpb9x7D40pY76QR4T9FABQw=;
 b=gp2nLzHCJgitku/yTrNaiNIgLwi4l+r1/eCqx7DQ8Kg79ES79A/9r+wIEsXGu79RjA1WkmyuKJOYBAe+SaZcIjkU7KXpcHuJt0HeGiuhsfM/ZyhhyvJOCZ5kLEm8HbWYRZdynu6lRZ+o1E9yNI7dTJ/+Ce0gYtyqshLbVx7/Eoc=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:06:47 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:06:47 +0000
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
Subject: [PATCH v4 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV GICv5
 guests
Thread-Topic: [PATCH v4 29/36] KVM: arm64: gic-v5: Hide FEAT_GCIE from NV
 GICv5 guests
Thread-Index: AQHckIDexwvHCIf1oECFIaLud/xXkg==
Date: Wed, 28 Jan 2026 18:06:47 +0000
Message-ID: <20260128175919.3828384-30-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB1PEPF000509E3:EE_|VI1PR08MB10073:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c74a31b-9da6-4d77-3528-08de5e982621
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?6IR1De/BYdHtwlXBlyUBUYEcCHIWr63IvF6se1jzyg2+tXkcCrUfjWFGZh?=
 =?iso-8859-1?Q?YEihfYDmbSvojTzBQQfzeorebcsKk9vQ36knBGa98bE7KeKiyYz570cOhz?=
 =?iso-8859-1?Q?CnMGW2baSE+YDpcK2QpXxEKgOX/4TKW+B6WNHkXJX36cGiFb40h2Z7kVOy?=
 =?iso-8859-1?Q?uTYyyQcn81A+hBqtyhVS6A2dw0xzmgJunadgt3qtoJEZ8tR2waZ3+/sY8e?=
 =?iso-8859-1?Q?88BOvYm/4UpNYcoPoQavSOObHgJn5KRH/I//Uaw1j+vF0eqlLq3F9choJF?=
 =?iso-8859-1?Q?tvkWiRVmLyDs9nR9Q/3CvrP21X0TSTBTKB7yqFIBKhuhOWr6QY3440zFxW?=
 =?iso-8859-1?Q?IpNYCYsfGlvGRQTMUmFkRfB+AzOUO7CBuVaoXO5Ylnlha4JXh8sYWwx8qZ?=
 =?iso-8859-1?Q?bBjOgAmRoISdWaxOL7xv5FS6dlbI6+6OAs4LlW6Ar+Ct5mjUgbAo2wR8kh?=
 =?iso-8859-1?Q?jZHX4XJhvHrdv9un6iqA7iKfCn9XGN6duOYeVSjw0cxTiSkL6KQ3+B4zAV?=
 =?iso-8859-1?Q?1yVkraaY+s/h+CtV2KkAlaB7EzY8mCI1I7KPb4ShgvYBrC9h+9E0tzZDX7?=
 =?iso-8859-1?Q?p/FuN39lRtE19zxoDtXAHuGO4zXFZ65c5KC4Q42fAmaowyD1/xfHYjh8dB?=
 =?iso-8859-1?Q?V6usNjiBBKKY7iE2OZSjrQbCwARTJ5CvwlsiUprKdvjAlkXxvqvTPesMYt?=
 =?iso-8859-1?Q?kLZn/WQcNnaVUVGRLX/DH7yUCOqh5mLBBhf/wsdf8lE0OMrk7NW3EJ0IsA?=
 =?iso-8859-1?Q?3FUK2zQg9G82wkCt/IvmS6LwPz7sFNgtvKiWEAlQXW7wEePNMuKhjTyYGv?=
 =?iso-8859-1?Q?ZzWCNoiGFqG3xLnfjoSfHsaFoQ8iDNxAeybCz/1WuETHdiBF4E3HvOwfI1?=
 =?iso-8859-1?Q?+d01/h3O7dP3cjap3Kq52Fi0zHaCD0f16tLvlIiq6mmnL16kIY9Id34hLR?=
 =?iso-8859-1?Q?isaCUcJZ90+3Aitu+3e02FWA1h4SMvNCrTVFBd+jxEtED/zqr0DqrAJEK0?=
 =?iso-8859-1?Q?lsYK6Qa45l5NF7KmGCPLxs5lXKsvKnNimQGa9S8gduHtwB2InFZn4HaBOI?=
 =?iso-8859-1?Q?YZt8RasSJP/ZWt2bWpUNnEkUX9Le/eMvSmbBhSIYkSOh7shcn+dUjdcwxh?=
 =?iso-8859-1?Q?NGZrqvKPa8xXT4yljpLrVcTL6Mmc/3LHckgFgLoYikK49jFJXqGtEuTpuW?=
 =?iso-8859-1?Q?vr4cZZe4+z47m9LjNuJeWlZf3gopoRSAnjW7PlcN4avaP/wLlqU83POrnU?=
 =?iso-8859-1?Q?h+bxkglTJTsPEqXFGxllpl2n5MdvXmpheUGnBCYl2815p36cBrb7ZNcSbL?=
 =?iso-8859-1?Q?4yEL0e2WDSLqjmSvrVUQGT7CWyCfPN8rrwCQ/n2WnV5+oQIFe8W8kiYGtg?=
 =?iso-8859-1?Q?+3zMtfgjeM6Z+pgiUIqNQS71dPWbeWzcCap8dgojBkUq/TkRiC+mrd1xgM?=
 =?iso-8859-1?Q?dGnACOib7XqXmTsH/CBm01W5a8ItSpbBPkbTV8PsE6/nt5RoesqKqq0S3W?=
 =?iso-8859-1?Q?CCgRcfwPwpP16ozeIt8b3rzDN/0CcOncQDVhtYnItn4hrv+QJtVeQqdpmc?=
 =?iso-8859-1?Q?mdHNNdqpAiFQBt0zjM5oOIiyyaezbFVVWzxMfXULXWYDXTZfCEIUBtmnps?=
 =?iso-8859-1?Q?qpxI3cfNNDm1cUFYTBCbvLfOIxUrNUAWCs5BE7nOmOe3odybz2yMZ9SB9b?=
 =?iso-8859-1?Q?/EEPcudyv5h09gO2IIU=3D?=
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
 DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5cdff44d-a1a4-4a94-ec6d-08de5e9800b1
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|376014|14060799003|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?y1QJLf58GzLQK/h274xNscdyj0tHTeh0480jUVY+mWrAUsqChCeSwMGQ6N?=
 =?iso-8859-1?Q?KVfTB5UPlVNniBEIXmvbuJ6QIi85KQTXvSN9ieVcA3vPXn//nUXQab7JlC?=
 =?iso-8859-1?Q?g66ASKq50HPzQs4+I8PoBzO+RrsGm6NnUYr3wFQoSfRnnRLV0F9x0J8xZ5?=
 =?iso-8859-1?Q?oYJLTJqrjNEXrRLeEncAIvVhN6J0HU/HLAF+PWM6E9tcdoQinKXMiF6B9i?=
 =?iso-8859-1?Q?+3SofDwn8kdb0FbokIM3K7XU6+i29dDr7s7fgbNwXKQ7lOEufsc+LzVgZN?=
 =?iso-8859-1?Q?PoY1mAQVQi8t4RBOYtzoStteQ/yHZ9vhinnYgpSOdIVvuYeCL3LnJh+pAD?=
 =?iso-8859-1?Q?BHuMsLIsFl08DgNFCobC3O96/X8t/c9PkADeOLk45XbEAT2D91XFnmNRNi?=
 =?iso-8859-1?Q?Eed1dDWkKHMEDpdL41e5Co1p76aVT5SKkLBPGJB0Jqu4FmDZgT+5lUsxSc?=
 =?iso-8859-1?Q?ckcN52cLzkWL+F9yXbdp5g+RpbapT/1sBsYXTq08FlE4myo8yPoriPkECV?=
 =?iso-8859-1?Q?wnMebOuiQhAsPXGA/GGLfetlhBrh0lSCyMebmh73eBfSbxvRCVZQYJhaMj?=
 =?iso-8859-1?Q?I7d4qRrmgT7yd7e2/BeI3DxkrbVdTDERrVfvuPHNUPCxiXRXgYRnHGz5gl?=
 =?iso-8859-1?Q?dY8jxgGB5l5eebh9UHrsEeGM/0M9Oanm1WHxiDgOtcKViNZsQUpCsVR0rt?=
 =?iso-8859-1?Q?G4IbNG8Lbk5PM1BPToWpMYaryDklGBGvPswPzYhAe5D68NVc0DUcaFctHH?=
 =?iso-8859-1?Q?hSjodY9s20iqB2xYELHbOZcFJm6bMqsQRe98/9I9dhTphAOp5sF38waELU?=
 =?iso-8859-1?Q?FtH+a7WYxR7z7sB+dDPLGSFEk1BypwucpmpOuXWpPbuwDeY0ExMHMwLtfu?=
 =?iso-8859-1?Q?eXqDb+WL+JQCjqB/wRWSg4+NOgw5CSCkHo/BPagUrezijSzekkNyNj1RS3?=
 =?iso-8859-1?Q?m7xQcyQqLdapNMauYZC+kczGdR41lqxjMny2CWsQp0SNOcoZccRp77GLbK?=
 =?iso-8859-1?Q?+LT+4AdyHgme+qLppsN3m/vm1WdJ03LebCQKtSFihsgcbbXiCySy8ccIkV?=
 =?iso-8859-1?Q?+tWGQV74UJyyupj53nKMKpIJPx5xd87sVraiHNnwIGZTbiX+0W+7fbHk57?=
 =?iso-8859-1?Q?t+l1dQoAjo85MutN+VOsUGsqZeuywTdlluEFBmxtDzj8V3/LzpnkNce4zr?=
 =?iso-8859-1?Q?3r8r9pMPC41qsrgcO9p7OAJhVpjI55KuBC7EBYTk+sbqcDOcLxLIDhyLiv?=
 =?iso-8859-1?Q?crbXiOFfhu2lkptxColMCaRcvqi/PU1ZapZHRZgayFSCCl0O/okpK41LN0?=
 =?iso-8859-1?Q?F1NSF+pgldXAmbxqdHG4MwCLPcm+WGi3sYSP2fq/jSLWwPqhq/Y8XD8oHj?=
 =?iso-8859-1?Q?BSeRV29JGj0VW8wkTLHYbz8PJJfCxcSX8w0vqGtRHE1sz/X/8CAnGDNaHg?=
 =?iso-8859-1?Q?QDci10OCGz9Dwp6OcmaDnHgkF7nA+UCJsn8RABTEa+ZwWN5xavTkC/BvjA?=
 =?iso-8859-1?Q?GQ+UucUAlYm3TEWaJAXkyw15xao2AICq6ClBbEnf3RbSxYjPA8pE3DQv/K?=
 =?iso-8859-1?Q?uC9XmtOOYBWx8K0IEPjgI6aUxzOW55Pnso/gfVupRKAMHvu/7BOMFja2vr?=
 =?iso-8859-1?Q?WNgEYHoR4LRVE/QrhcJiU+NBSmeEDz5DigL/9nuQxPyxudUDg7YoDrXwoG?=
 =?iso-8859-1?Q?VIde/WN0gSvfNBALIuY+Exrj4TMVqrZmfZdL2pfRXiytj58aYlQ+cLsZI+?=
 =?iso-8859-1?Q?kMNw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(376014)(14060799003)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:07:49.9915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c74a31b-9da6-4d77-3528-08de5e982621
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509E3.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10073
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
	TAGGED_FROM(0.00)[bounces-69395-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 8BB72A7949
X-Rspamd-Action: no action

Currently, NV guests are not supported with GICv5. Therefore, make
sure that FEAT_GCIE is always hidden from such guests.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/nested.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cdeeb8f09e72..66404d48405e 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1547,6 +1547,11 @@ u64 limit_nv_id_reg(struct kvm *kvm, u32 reg, u64 va=
l)
 			 ID_AA64PFR1_EL1_MTE);
 		break;
=20
+	case SYS_ID_AA64PFR2_EL1:
+		/* GICv5 is not yet supported for NV */
+		val &=3D ~ID_AA64PFR2_EL1_GCIE;
+		break;
+
 	case SYS_ID_AA64MMFR0_EL1:
 		/* Hide ExS, Secure Memory */
 		val &=3D ~(ID_AA64MMFR0_EL1_EXS		|
--=20
2.34.1

