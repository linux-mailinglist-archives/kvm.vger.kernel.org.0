Return-Path: <kvm+bounces-69372-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPhgICJPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69372-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:02:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0B9A7699
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A606A3006B7D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE66B36EAB6;
	Wed, 28 Jan 2026 18:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J12HdzdT";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J12HdzdT"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012037.outbound.protection.outlook.com [52.101.66.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA55836EAA7
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.37
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623326; cv=fail; b=M3/7kbOgiymFA3HUO8Z7yXnBDJm+7227cZSKTKrX0wb3O30r4UAZis7By/E+e98HIu2eEyopMoN3xn6GziNmKCJQmoWCRptRhBmUf8KBYma/jQHwAlO4ucZtG53huqBVQIemXdz5IrRDsqTpGOisOEtJHfTwp5VadYY/B3dLdBQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623326; c=relaxed/simple;
	bh=lKJs+GffGvyNzApyQSu6JAQJVww2xDaiFNwcwDYFyOw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UfQCSASDJvSB9XhWCrbUbk4XPpK7zO5A3Xdjbhu4tR29Tnt2VoPso29tX1wcvkqtDYTRxfkBbiP+aXyzFQXx4TUCvAgyu9vhYR8bGf6IyXC25Ib82TXKkYy1rZ6DIU+KGcu93Wmtd2HqTLUxEK9ZSFhUmDyt2kRnVmx9z4Xw1qk=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J12HdzdT; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J12HdzdT; arc=fail smtp.client-ip=52.101.66.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rbSt7S/m8GoMgaFtuzwGXJqfd6DP2400+lNSRNPMuQV+Zx7j+vpXryyRfV5ZR7YM4fNBNwzZ3KIsVbjKjaBFK2rzT0E00HB91tHpAXEOZt2Pr6n4Prc+0bfGxm+HkLeP/T2HLJNbqe7s1nlaPTvmCMWoN67QAnyaq+vJggBSbAuwHK3rWkfmaGD3fkFfrwLkyc/C8bEojsTn67ZSBU1s1qqR2LcBZMMVTjrPuj2Un8YN+mnYtB9s+SoNEBqzoebPSRsqAKSozzfZ5eXZQtJIhlZ65UWT6p7lrk7TihYtwzHQOG3wqiyf9wi/HU0yBZgEoe2O0bWHdnvuTqqG27yNKw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7g7Ra5hjcpbt5gEq95IFdHYM0mNR8uaj2uUg+T3k/o=;
 b=xs16KWvx72tLIGZJ3stuy50+JYBIhMVsqLfEjUfMdMgEFwECYikvbgUVJs44RcmBc6qOG9fSAbw8mKazWnk/cEYWvmrLogM+n6tATKxInqcWLEkzQPnO1kiIryKuM/yMI4mwmnNSED8jUg3spnyZXgJlHoQddPF5vX0HHFtmmFPMluHi/bmeBeqwEYNx1NHLzT56l6D4rHE+qgKWrogvJYf83aqlOmY7m2N+4OqcKDGlB/n9MWrtkJT5FOOXh8tIWPE6S6mYkuSLZ/vjA/947Io55nv8mWvloLTZyihRCqVuKcTIO/qVmU0KFFBRKLBA3Blwwe4E/O1pIBOnDbIJ3g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7g7Ra5hjcpbt5gEq95IFdHYM0mNR8uaj2uUg+T3k/o=;
 b=J12HdzdTB0BJZkCQGqCwyoQieH/2lZvfm20iKPyBq1D/73Uqm2OzOVtHQwiXeVeYFqhjGL6Yp1cJbIebPTnVgmzbC9dsESCbthOe7DuqQ63phMgpQYbmWjWuYAgYEFV41SPHcZq1subRQ7dNQsVXDkz27FrCkdMjMtfItM9a+i0=
Received: from AM8P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:21b::13)
 by DU0PR08MB9679.eurprd08.prod.outlook.com (2603:10a6:10:445::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:01:55 +0000
Received: from AMS0EPF000001B5.eurprd05.prod.outlook.com
 (2603:10a6:20b:21b:cafe::1) by AM8P251CA0008.outlook.office365.com
 (2603:10a6:20b:21b::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:01:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001B5.mail.protection.outlook.com (10.167.16.169) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:01:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZZ96sJZ210GqgojDrmkRTD6HLkY8ZF1hx8Jxh+51HiaUmXsCfr7d25ksBPtofgi53LCrN4So7/XLEgwKCpodXaOewcYeGHu7o0U++SVM+bd9Ic+QxUxmkhLjrLprO/pHANSpQzv1/yDkfbPbiHrzfQK6KRU+oyM38GR35Y9lIUcHFDG6Lj0a8jLoi+VAlVPsPWjl284be0b/QNn+u4UzqeeIZo25xG2KQFPqGJs9Sp8JHNW1EBEzQI5nygDVqNymo5mAgvz/udotnwt++7ut97DYCBT6zQB+NhX69UlphK+z+xSUKtTJgdPhV62RV251aCb5SOv8pEt/cpgYGb60iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T7g7Ra5hjcpbt5gEq95IFdHYM0mNR8uaj2uUg+T3k/o=;
 b=R+S24c36ojCZ5WH7RwZ9FgjUik2jaZVQ2J1ZUtLEHcZ4RO7yIdXANRKM4Eokn8r4xtAKM+rc6cxaiE69/PqpiD0uokIUdqNbktEL/yaiDKUTfDbcJujGnh8FoJMEiWEJaRAdvFrPVYKLtak/2cJBL9Tgb3H/Bc+KuTYLpzz+ObjWkLzEUuE0ETumvW15xB2RR65yMRvTJV4vpmT4dybMtQ7fGCs7vCiA0uF0YkYozytoC1lQTcFr085EnrWN8YYdhuYTGpKN3ftNUNBK84KL0dmsZviazvrOcuZTg1ksebPhngMb/kk3vkufZpa/muyEtuTi3nfxrTQXdV6dj29skw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T7g7Ra5hjcpbt5gEq95IFdHYM0mNR8uaj2uUg+T3k/o=;
 b=J12HdzdTB0BJZkCQGqCwyoQieH/2lZvfm20iKPyBq1D/73Uqm2OzOVtHQwiXeVeYFqhjGL6Yp1cJbIebPTnVgmzbC9dsESCbthOe7DuqQ63phMgpQYbmWjWuYAgYEFV41SPHcZq1subRQ7dNQsVXDkz27FrCkdMjMtfItM9a+i0=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:00:52 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:00:52 +0000
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
Subject: [PATCH v4 06/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Topic: [PATCH v4 06/36] KVM: arm64: gic: Set vgic_model before initing
 private IRQs
Thread-Index: AQHckIAKxmfbuOfPY0qXKTorgXNQdA==
Date: Wed, 28 Jan 2026 18:00:52 +0000
Message-ID: <20260128175919.3828384-7-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|AMS0EPF000001B5:EE_|DU0PR08MB9679:EE_
X-MS-Office365-Filtering-Correlation-Id: e44fb501-76a1-4857-940a-08de5e9752a6
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?4c3Ua+AgxAnyf+q1CRacD+BxZeX2zhrT085zwpSipqYhMdLhGHG/tOREB/?=
 =?iso-8859-1?Q?cRmIxX4hj93ygWDBDKzLLOTiKDMDKFxb0ZVtvQYMrIStikj5Q0Z4nIhbPF?=
 =?iso-8859-1?Q?HNe9zMQj+FGltngKUrPnVP9ddoD3+iyCFrB6O2Pjy+PXPVdBmhzABimhrj?=
 =?iso-8859-1?Q?/6WSgvBzXp48JLva77lQlR/KIvbzfFpOCxwB3VTpntwBP0dfLG7IJ5K9+M?=
 =?iso-8859-1?Q?LT6ZKvZA4zCANVAT3lVuYEn1LFDRR1UY4+A587GcycRFlWqNfXx2ZmXZu3?=
 =?iso-8859-1?Q?1gEGCb5e/gnJYjgZZ2Py7cmm6e5cuJmsQKsPvEvCJH2Av3zURFBJ7nFu4W?=
 =?iso-8859-1?Q?emJjX0X13/v7vKQoMkGbi/cmV88q9SSblsG9IokJjtkhMLz/jNT1Bk8DPH?=
 =?iso-8859-1?Q?EX9eq85SSad33wqx8MlbkoxmgLC05XoJmldwHltOroElzCZHofmu2rlRUK?=
 =?iso-8859-1?Q?vtlQk7ZyeJ/cr170CAV1D45f8RSHl2L6gj3oHAleivtfXs3X3MGmzLQfeY?=
 =?iso-8859-1?Q?xQx510plSTH4rKyanv61w3Vg1d/GN4gQjpsQDH4LedEtE2XPJQJZFD2lTo?=
 =?iso-8859-1?Q?p7Hez1YltvaEbJy4S3r6tRsET6Mt3shJv35Vf/wvjWUXLgjMQubrN1ohhv?=
 =?iso-8859-1?Q?Kfhe99HwBCun6nWj1J/PA7rtNfdztm+/1EJFlyWfg6CJRgcBZNiHLmGqjE?=
 =?iso-8859-1?Q?kklu+phb4wqf+CJYfEW2Qq7yUcGnKI7sTS2vH5drfs1onOko1HE9LaXBGM?=
 =?iso-8859-1?Q?IjEbZA75lO9rd+4RUlyO9afKzb/8fjGi7Rm6kVJZs0WK5yRy+g2IXsqGdG?=
 =?iso-8859-1?Q?7WTFLqJZXINp20lH5PWtjc3Ub8mtkJAgJO0q1toM9Zvp2sqrYL/wusdsO1?=
 =?iso-8859-1?Q?Xg1UiiUxc92D43kxW7OyOe6qCC9IZqRhcr2NgtYsxtV2kKIGDyJ8dtS0QG?=
 =?iso-8859-1?Q?olRlXgrufOVn306VoafFuJkiKD357wYfaePiv0E7wG1ZSy/Zmv+YBsvCZQ?=
 =?iso-8859-1?Q?NouSqSwQtvx+XLdGTiYEzIhbRlC6IKiu1i1cF+Gj8giQgSws8B83XGyg8F?=
 =?iso-8859-1?Q?gkFUKzEpT3PV52NSNvH+boM40OUTaDY1/1kFmOgnng8/KP1hQYLARLiuk3?=
 =?iso-8859-1?Q?gwanGAAiLWuo4XslgzMRYYEj0wrFS8imqSPWWqQdf4YTYdAElrKXarbBQ6?=
 =?iso-8859-1?Q?SXRxaYyN/q5m/5LAbHFH+ngO+lvoJjNeT4ApU2H9PNlOz/qePnKhd+/ttr?=
 =?iso-8859-1?Q?77N1B4zN6kYdowW4+7/Q1YptMYtX2q/Dq9uyebqXkvmS29sNDpj4iMcAxr?=
 =?iso-8859-1?Q?sAWi/oQ4XW1sotQf9yy07jdiXvazHrDIJ+CHkP4xhbIru57opW0sS5ep2q?=
 =?iso-8859-1?Q?KdOrMjRdWFh24MsG4jCD2IS7oq58K5kDgHomo9lw0SMdgLzp/iujVCQhZa?=
 =?iso-8859-1?Q?Th77HhtpbosA0TfSsiI21ULWdb5Kdydzgn3vg95GjDjRhpfsFuBIwHWGNx?=
 =?iso-8859-1?Q?wHU3sN1zOZgHvfkutmDGT3huPXp9sVt6zIvXfQ/FMXv9NZelQ+ai+Xp0xB?=
 =?iso-8859-1?Q?rD+pEJtVTs1LvtzD2eW10nlWa4rJ0rgDof50RRD5l7FHHA7372sWYsGAcL?=
 =?iso-8859-1?Q?3PccEoVApemfRDLWVxqbdaKN3hzr4BPB/ZATZUM4WHSQgqayFJZbpMQGXA?=
 =?iso-8859-1?Q?CF2b4hb3HEd7lhuQU6E=3D?=
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
 AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	f8bef9e4-35c7-418f-e167-08de5e972d2e
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|36860700013|1800799024|14060799003|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?OHZybS9Vur8wmL3XgCESodw8IrWG8cFw9H0bsMlbBabcRGE8ekfVpINbmK?=
 =?iso-8859-1?Q?XPe232wFg9PVgh8L2ybtupanJfh8FAoauixR9ubCaNe+eMu+pTQhxXvpXb?=
 =?iso-8859-1?Q?4gcSW0vO+LjFRxYEJmxDQioQ2pSnv2/SrKmhiTCMQiBVgLvbl1K2B+yFV+?=
 =?iso-8859-1?Q?CZWm0GeXAKQwZskxUhpQhVECZdnJH9trMyIugA5ExNl/zQrIkwUgIlpm6o?=
 =?iso-8859-1?Q?Sg9eXLfQHH6Muy5SP8LR+eBzYeFX+XvR1wB45rUVeLtvu97Gd14yEWrDd2?=
 =?iso-8859-1?Q?luWPk51i0QZNozT0njj0DR6fcYmLKPDj6f5/Jb0hMazakQudNcJddikUcj?=
 =?iso-8859-1?Q?ljSS/sb0Qclo0x2J9bgW6CaJEtiGyq7CIkYa/IrTVq+esHEZ1QzsSNsjqm?=
 =?iso-8859-1?Q?Ta8tKmr/5hL4nGs7AzIYjlcO/+e5iqpeniZhaxH7+7/sTiljCAeifQzGUd?=
 =?iso-8859-1?Q?0m1/sA+kyI06hZqMugwEiqJ8G19ksKUh6m2pkUUp9wnF5Tbz5yTb1vF3Zl?=
 =?iso-8859-1?Q?jXB7xMQ0hRG/k0GL5xIk9ncm7fd24gkv7eeV+LH6Gs7/DNUNNW++h1Qe7y?=
 =?iso-8859-1?Q?y3cb6MyV3z994RTlqqyyqnXvSg2clh+NML4gj+OiD+DufymOTifzOuWMSG?=
 =?iso-8859-1?Q?aoOPCiKRATk7PqJVO//ZgDzrMkjJxjL9fc0kGcIV3dTtIoAu7YocGC9F9C?=
 =?iso-8859-1?Q?BhIaYAwNeZ12yUQpo7+bzBPRDYqCLh+AdUQm0agfTWzfBHmc7wvF0jR0/X?=
 =?iso-8859-1?Q?+u/U9A8p80dd6IwjZ4xT8fN9AF0B+Gb4/wFGW9zGu23WHH22BFNT11cPQL?=
 =?iso-8859-1?Q?R0fol6v0U/5bmskPv5xPYFfNunaH27UREi8qzubkIfCXSVUVDlb3y/bbDo?=
 =?iso-8859-1?Q?ZExRUAjwOT9YM0Oa3Ob1/rSMG2wsI8wyfGIygywqsOTEBgrmCguiWFBQUd?=
 =?iso-8859-1?Q?WG1Eny72cDWTFQKT2z/6k5BCyl2iRZXyG2Y+GOpzaodVVwZvdWB/FmyV/T?=
 =?iso-8859-1?Q?AYOeQFeB01sn5BYQAZiQWA062va5/6G6TSyp4XgE9i90kQglYJkvWwfFJV?=
 =?iso-8859-1?Q?WHIwwy4WZqu+bvvYqzvuSCxGlMFmj0ac2JqRGpa7ynOOdCj+E/QIsX+W6p?=
 =?iso-8859-1?Q?dP5T1T6HI5JGmx2x8VBSWribkfZCx/OdDw5FuWtTfsbhy5N/cXGQmrkTld?=
 =?iso-8859-1?Q?Sz9ExHitRtjAqQod+JMYO9Y3hjPtYjcVrSMoXu3GXM1I36XXcQfWST4MZw?=
 =?iso-8859-1?Q?h52CWgWVeVdhGly0ghycPbF6nz92A4HdtF4uxTYG2c++g79F9mvc03rHgV?=
 =?iso-8859-1?Q?0afrh7EdpPDqUnnki9Op4QtdFLHNGAYeQ/7gJai3CfyZFq7/ngwf7GEGL7?=
 =?iso-8859-1?Q?dJdQKOkuxeYUyKuawWA4se5HZkw6gRaZuX5a+VkOBk5pRz6X8nEfzdzogB?=
 =?iso-8859-1?Q?FNNDXbUTe5jKyW6GB7EiX3FlCz/ZpJfE8LToSQTPbNzee7Aw4ssP5MNMQT?=
 =?iso-8859-1?Q?2Hn9zABq5zc2TZ1lo6OpjXgy6F6l3XzvCdLIraz2z6WIdxWM8Dwg5IQk5V?=
 =?iso-8859-1?Q?Pv2bjlMXULqB5Iv5RFNRBc0L1azMWVTmRzZI/DY2xvW65Q7ZPsbyhl6BD0?=
 =?iso-8859-1?Q?FpUkEphWl5q8m7KNrCOgLeCzd99SbLrbfGYrqPOflzfdYoNdQZUDDljbij?=
 =?iso-8859-1?Q?cUteUiyY3biVHJx4pKfyj/7OHz9CDQhlJXUOLAB3FIO5ynbpJCxLD+w/Ns?=
 =?iso-8859-1?Q?JYIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(36860700013)(1800799024)(14060799003)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:01:55.2041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e44fb501-76a1-4857-940a-08de5e9752a6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001B5.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9679
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
	TAGGED_FROM(0.00)[bounces-69372-lists,kvm=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[8];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,huawei.com:email,arm.com:email,arm.com:dkim,arm.com:mid]
X-Rspamd-Queue-Id: 4B0B9A7699
X-Rspamd-Action: no action

Different GIC types require the private IRQs to be initialised
differently. GICv5 is the culprit as it supports both a different
number of private IRQs, and all of these are PPIs (there are no
SGIs). Moreover, as GICv5 uses the top bits of the interrupt ID to
encode the type, the intid also needs to computed differently.

Up until now, the GIC model has been set after initialising the
private IRQs for a VCPU. Move this earlier to ensure that the GIC
model is available when configuring the private IRQs. While we're at
it, also move the setting of the in_kernel flag and implementation
revision to keep them grouped together as before.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index dc9f9db31026..86c149537493 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -140,6 +140,10 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
=20
+	kvm->arch.vgic.in_kernel =3D true;
+	kvm->arch.vgic.vgic_model =3D type;
+	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
+
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		ret =3D vgic_allocate_private_irqs_locked(vcpu, type);
 		if (ret)
@@ -156,10 +160,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 		goto out_unlock;
 	}
=20
-	kvm->arch.vgic.in_kernel =3D true;
-	kvm->arch.vgic.vgic_model =3D type;
-	kvm->arch.vgic.implementation_rev =3D KVM_VGIC_IMP_REV_LATEST;
-
 	kvm->arch.vgic.vgic_dist_base =3D VGIC_ADDR_UNDEF;
=20
 	aa64pfr0 =3D kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_=
EL1_GIC;
--=20
2.34.1

