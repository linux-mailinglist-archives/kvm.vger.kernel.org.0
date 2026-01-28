Return-Path: <kvm+bounces-69381-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOhGMyVQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69381-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC1DA7760
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 163EF30583A9
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65DEC371040;
	Wed, 28 Jan 2026 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="drHUVcED";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="drHUVcED"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013000.outbound.protection.outlook.com [52.101.72.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C1502FE58D
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.0
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623474; cv=fail; b=QyOCFBPxqK2hKO12MzWQ5UgfK0BUyGiyysxr8GrqefHKl9Fkc9eWf2jpeuzQTtcBqMhL1VniTqZ9nRpeyMXBWS+k+u0ixNt1JDquqmlitHpGb8mh+y49tgVaiIw4n2op+qlE4yiny1Cb79IjJIv0E6iLk/Tlq0ITO43gHnCJwOk=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623474; c=relaxed/simple;
	bh=dL4WF24vbvcZ6hHSrBJ8iZq/xF+oTUlxF3KdzC/JXV8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=to383QyR2nNNi8/v9/b1ODSxE1VAzSXXERf01yNweNsyhSFdJRY/PMnYWLYGGVJhPWqSB+0MYe8gOaZiSuFu73GvGeRLrtz3oP2d+JDwoXYwzw6shhHIjN62KoI9/Ms8b7CawS3CxU9VR0radaBax+CBrDtZY4Z9hmEHgslt/jg=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=drHUVcED; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=drHUVcED; arc=fail smtp.client-ip=52.101.72.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nFUqhSDC/uZ9sv7CnR1wgAjqiudogyqX0oEX+h6fwxKVb8ThhmGNAz+4UiVH8+61xaSAhXpv3hKXBDrlmVRW8q5IlKRyxHKxm593EgnZ7DH11OGmvwBfG31qRmOr6lVAnovlDeugZjk93ANV2JQ34XEAGMOzCBJw39Tb1cNxKFl+3ov5gndllVyeAy72pghQPZJGFBPJndZhyZHzuYT0sw3DtoZI5vc2ygaU9klucN7XDJYbEGRpKMyyOheAkHR27AXzBRmN5bSLeoWDboGZaEYTcuw3GbPd36ksE0hjFjDafZk0pBr74DoKss37MMdALGqB0UZLvDWEqDFXMIJeqg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLxAHwabITvx6gvSItBICg5bA62jZEinW31cZ3/irdk=;
 b=oMVtUAQOjbulnpFVe9Y6yTzUN0yTOBmaCI3kWpHP/2IGr0GvZKkKVpGsAipdet3UlkYNL4GA/B1l0EA3UoqVRrPSXb5BCrMs8gLRoSNL0DksQ1uDhV6g+PBj/x30+Pj8Diaa1ZGic9e8AV6YzyuGftas6SQYP1cql3YZU9n/QpTAwhlfsklhQb59INvj7DNYh5zG0MnzkWDYIxvS9iJCUtKBPhJdPYyIw1D9HHc4fntn4GitiWKM9LeSnY5wgf0PmCz00F2Om26W1cGlh0r58A/9vn0uPBA5QIHCLN04EtfJaeVrFyT8Rwfi6DQZwt7Jyd/hcpB5Vd1Xs4p3LCaJ3Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLxAHwabITvx6gvSItBICg5bA62jZEinW31cZ3/irdk=;
 b=drHUVcED2qJNXcJ79mlarxBvVNLAkriH2q1xn4dddUdQ69dZLbCxgxPcUQLiTJq95GWstrwGFXHhuAvCWXqsaNotxjthhatf3CApMUUeu91ABHMSJ5qDi2Aj08ffMGn+PToi4OsTeR+0FbHK/1AK8BbDGX2IVBriycn5afEsPlk=
Received: from DU2PR04CA0218.eurprd04.prod.outlook.com (2603:10a6:10:2b1::13)
 by AM0PR08MB5441.eurprd08.prod.outlook.com (2603:10a6:208:17d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Wed, 28 Jan
 2026 18:04:25 +0000
Received: from DU2PEPF0001E9C0.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::99) by DU2PR04CA0218.outlook.office365.com
 (2603:10a6:10:2b1::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:04:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C0.mail.protection.outlook.com (10.167.8.69) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Wed, 28 Jan 2026 18:04:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=re5apvOVpGV1RfsIDJd4iFTVPe7JkLw4OHkCBFLBEw9Wp5xa38ShiDUvC9T/SDB0BwJFTxnysQJSQWGt/9mbBEpWSUelkjA6Fnd+l9T/qW6f2b7Z3zmc+QgCb4nbHaRwTOHUC2n86rqQwn5jaJ+/6zlvyQfOWDulvvvL8Kb3sWAR2cNFWMxSeO4sBddUaZP/a4MrRTDXDVOzV5/8OBpNIMUxGMh3c8kSgNfeb7OzHGGiAcFCkf+mmMSit3wJ0qu4z7Fag6PyErONYns2T2LU6P5ovs6hwEVO9FFEY+RpsFRMojguMevIbznirpi+3A2VqrEAaQ1LTdjM8upznXa8Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLxAHwabITvx6gvSItBICg5bA62jZEinW31cZ3/irdk=;
 b=wfLlvKFllC0i8vqgML3MdCc6XUHa6FPhxCbiqE5Nl/BOjpF0NLDT6agMLBhI3JiVtxC3xlxHMuMQ18zru3CQrIHc7MNnUH5HFWOY8RxEhbaKrn7GVJgeizSWWS052NNaRl98aqbUQauPxKmAorCef0h0NhdXfXfXQ8rEc0JXHarMsXcg2vcX7Yb4HzS6vN7VLx8qShRUIh8Ftv8H5D33e4ujaEC56tMZMUl0+TZB+zYv4f5lXlUf2XpbL0SOXParhVbTpNdyDBBCoQ0bps42gP76u3xOfNDiG2ahIskJ1bdIJQShdn0JlcmPSPUDCyeTAwhTsIygnDCsXThxus8ABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLxAHwabITvx6gvSItBICg5bA62jZEinW31cZ3/irdk=;
 b=drHUVcED2qJNXcJ79mlarxBvVNLAkriH2q1xn4dddUdQ69dZLbCxgxPcUQLiTJq95GWstrwGFXHhuAvCWXqsaNotxjthhatf3CApMUUeu91ABHMSJ5qDi2Aj08ffMGn+PToi4OsTeR+0FbHK/1AK8BbDGX2IVBriycn5afEsPlk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:02:09 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:02:09 +0000
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
Subject: [PATCH v4 11/36] KVM: arm64: gic-v5: Sanitize ID_AA64PFR2_EL1.GCIE
Thread-Topic: [PATCH v4 11/36] KVM: arm64: gic-v5: Sanitize
 ID_AA64PFR2_EL1.GCIE
Thread-Index: AQHckIA4JFetpw4etkOirhfjQwNVww==
Date: Wed, 28 Jan 2026 18:02:09 +0000
Message-ID: <20260128175919.3828384-12-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DU2PEPF0001E9C0:EE_|AM0PR08MB5441:EE_
X-MS-Office365-Filtering-Correlation-Id: f41f9c22-a533-41db-1cfc-08de5e97abb8
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?s9P5N4X7O2R0Tg2DrE3lxUGRK/CyRAvCQq/93VbDwtDn6BrWMx7wEfOKKt?=
 =?iso-8859-1?Q?R1sCUSKB7PAUAYoDkjwdM3B4tWtnxLjD9eFp/RdMGQZ0qEEBjv9NzyBvuU?=
 =?iso-8859-1?Q?HF1/wTHA4FdS5xSZZZP/i338AqyDyBeBRkG/q4B/mEd/ZVpXuEGcCJGjk7?=
 =?iso-8859-1?Q?Zbh0yIck3cdgOlP5nF7L7uVC0u2zFiVvGT52kSMapbwMcObgJpjn7TOo+i?=
 =?iso-8859-1?Q?f1rNBFs82nz6r8DfF1yEh7jQclIUAy1NonyLSp4Chetn7Lvp2wu/MoIm7u?=
 =?iso-8859-1?Q?3K9/sr5/7IGuhT4AcDYp5i9mMDmXT5dm85HKLPztjgyyNSKM9KB/5LXs3W?=
 =?iso-8859-1?Q?dMWxrS60wpn0bUp9GgqiS2vTRLZNEGjdYP8+e5YC9nJo+7srG7XH9g0Kx6?=
 =?iso-8859-1?Q?tm3t7CbPlhCxd9JgOfD8n9Q8Z6pOB2wFDiSUMZcwP90kAdu4OcmdA8YDRQ?=
 =?iso-8859-1?Q?icLzXezvY6lO1Oyy5a/s9oicmt97nhIw4aJ7pVNO4TwHYxd+PCAzHSKObs?=
 =?iso-8859-1?Q?f5udN1JQ3yyMc7gWCci0BIYkR7F04wUFgn8iniKIPKABTjvFctIgCPa1CY?=
 =?iso-8859-1?Q?jsNedg3p7IkmIAd8sQHn70fJzjCP3evk6dOBUDYujiAEuYqq6qhF3PgFCm?=
 =?iso-8859-1?Q?LGjq5J+J3ztVmgdycOJ+jJAezLXkrf6bh4Yqy2CiNfTWyppZ6TFZJ8TJl0?=
 =?iso-8859-1?Q?jJ9e3uI2gEfNKaQhxBKfp4lCZoWgcUKaMagHUhPqv6O595Rxue9lYyZcGH?=
 =?iso-8859-1?Q?Pl6SBQpn+7G0LRD3A40jn2M3+Ak3iH4M7i4SCsiswQzaJzr+A2TywrEWNp?=
 =?iso-8859-1?Q?u/QNQhDV8Q3dmh+LYibIIIZJz+Q4bZNrnIhqAJbzjxGAZWR5L+vA6BKRZi?=
 =?iso-8859-1?Q?iQ5GhYNGXMQef6K5NbpuNsrf6+VmIK/9QhBjSmBlZmadFoxw8dITcPQVI0?=
 =?iso-8859-1?Q?o0WUzHSWjA7wDUO3h66pRKSlPX35HX4NrktpGo4rhiihcu8A9tVydYqThf?=
 =?iso-8859-1?Q?GbPM9yghmqvCrxwK7NLxjNoGAqB6nv1eBIoqHLNj8qC7Ztpx3xSvW6DUOC?=
 =?iso-8859-1?Q?QZwCC2jWRt1Z0wvISGUIC2iSdMzrbumGBgRCpRkYM2XZBV0vZFwk/ulxdK?=
 =?iso-8859-1?Q?B+7ReL9P1WmaTMXNLvGirxU0rA8iw2/BQOYQP7dFKfcWLTM86KwdJmkwaE?=
 =?iso-8859-1?Q?q3rBBZFw3YikAWnE46gNIoBw/k7Yr/pNBf1XDF06c/0ecBsYMtc2oRDB1Q?=
 =?iso-8859-1?Q?7sx5zExWPggwehCSa8fht5iHlMEmNM8hi1cMXQ+Tk1uMA3P0CYCccjLO2n?=
 =?iso-8859-1?Q?Lnlt8rU6BCCxNqkQc/Z0yCc/f3Lm7cg2vDzfPSy7ih5o/4Uh7O2XT1gkk5?=
 =?iso-8859-1?Q?6jD+8igImS31efPqtyS+i1tVOOPTJBRFw9vZGyDBWphRJuEhrECTt3FzzI?=
 =?iso-8859-1?Q?5EHz6Uk5BlgInSYI1/D+6TjdBT8cR5yYJmrQi3F2Fa6SS/Ki1hfuRfQCm3?=
 =?iso-8859-1?Q?bgVqSuGdz8+HgcD5wUnm1MSW1BEVABw6tRI8gLSg9pfmARM31Th22CUaYu?=
 =?iso-8859-1?Q?iMCer4qsc58P9v3txcy6FF5MmXzyxnLdpUuYVO2EzoMPtiKBZkn5iDSiWD?=
 =?iso-8859-1?Q?n8v1DcE8OHhUbt30sop5jiyg7gk28J64yoi+RKkXMFUB8DvXMnjIvsNwQE?=
 =?iso-8859-1?Q?PTS1xp3MQRp9qw19hP4=3D?=
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
 DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	b9af5d28-1944-46b2-5ae7-08de5e975b32
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|82310400026|36860700013|376014|14060799003;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?n8TfkKSh0H269UnzOdgCG3XMuL4bx2wAtry5KMs6QBoqiqugxNi8Ju5wxV?=
 =?iso-8859-1?Q?8SQyukncIQebkCs/CFyMnEf36mth/jSUIqnY2YaLS5ciz5W7kQefP8YWC9?=
 =?iso-8859-1?Q?jK1153joxGjNLdz7RwFoA1fHPL/fEYZVkX82qIM5FJkmuoq63hNeyQxVfm?=
 =?iso-8859-1?Q?rZffNH/JNRKbOfbWXByIk5LPoUwrRtJ+7E+KJFmY6xemA2v05EIUQxcmDf?=
 =?iso-8859-1?Q?JnVW4gbTWfTrzWHnW78dHhgTLmLqVTGjy1ugSapKU0kkxdc8L/zbtV5Lvg?=
 =?iso-8859-1?Q?UhUVfFMR5vV2W6fzd+8sXE79Nz2xBd05ConSpY8BRQuFVGuwqEVv0Xaase?=
 =?iso-8859-1?Q?SKNDm1FXMSAsbzpObpfxK8Wl+vhX5F652Ho43lzwkitqdfET/OoAMBTBHC?=
 =?iso-8859-1?Q?vtvtG9DPkNwUmP2uFxQuNa/Bo+9nEHZ3GJF7f+1fnBKLg06Syln+ImuAV+?=
 =?iso-8859-1?Q?TV17PJLA31apdlvZPashQ412D+6v0bhKZHIkUCOgqLEQzb+TJZU2+PAqG3?=
 =?iso-8859-1?Q?eT2RYqCUuqKXu6UzsKGEuO6whhkxPa3Hc3AHpamIQYo78ctWDvtNs4UzaE?=
 =?iso-8859-1?Q?Sk4z9QroR7ZuNPHT2tV32bAwcmn5k2LZ8BcMBBf2NghThIjEcXnGZpWLVr?=
 =?iso-8859-1?Q?VpY2h183VLv6CTjxGLxjs3DX/J4PmkgMOGpMz+hScnxO2ZjTD/E1CicUQp?=
 =?iso-8859-1?Q?FreDy1hrdIF32rWo/Q4deU0hLiKb2sSlC7RYBOFTpwzRXscp8Jjg/K9SB8?=
 =?iso-8859-1?Q?+FpsMmLhLsJqoPOg5l+C2axdLOrnjlFEv/OO9z0dGBHHJsAA4oVMgb1CvO?=
 =?iso-8859-1?Q?Ak8bcib6VEX+slLEix0fRodkiCRwIf7k4JQhUen66eFWXyrX8Yb4RepQwT?=
 =?iso-8859-1?Q?Hf8h+2ADeORCdc21zz210lu59adG+yxGemSj0PefoYwMm/qlxRyM87PiqL?=
 =?iso-8859-1?Q?thSuja8uTfD9dA8rT9gfGGrVKJu5zaE2EaAaVbPRRPfxODhHjzArTu8qUG?=
 =?iso-8859-1?Q?niIa924kNcD5bdNac+6sC50+h6AE6BsE7ZI5UG/HPiLTo96OF5Pz7soR6C?=
 =?iso-8859-1?Q?mpIZtV74wKuiYY5giW2zMuO+XymvED9r8y+dRAWTJMPjjK+K5mLKTbcD0m?=
 =?iso-8859-1?Q?P/NmmD6CWp4ZpCjr37BLMcLBxb+ApRGY05V6jA8c8Rrpiih6033NDlMMZQ?=
 =?iso-8859-1?Q?gpuKVzgCYZBe7vMOfC87r307ryDkYgj/KF/6Lih+B/1iS8BTWZagr0mYnJ?=
 =?iso-8859-1?Q?IWQWmDk10TqEKD/TL9f/Itplerph9E13wIPYvtltlpgcvAIrQWoaXLI+ve?=
 =?iso-8859-1?Q?VI9JClyYNonxWEzY2uPevq1E3e+mRdW6YLK+hPiM8GGLGQlkSnl9yc82Ri?=
 =?iso-8859-1?Q?RIsleLSWxCz1g+HzokLGr0/2NJ1M+4CnQ0/smnDDWiXRNhaaUcWQh/vG+X?=
 =?iso-8859-1?Q?Xc0wUKuows08xCbjfl/hS7RKh4c+yHl2AHr/Be5S0FKTOj5VOYrAC4rPAc?=
 =?iso-8859-1?Q?lMy7yQpKndfoEgry6JS851S+GAA0IAQRk9Y9M8vYtUloVjnx4MHnKNakA4?=
 =?iso-8859-1?Q?O1HUesxjzvYEk2TkLd8NsWmbRzZR77mHQJlhWAAy8MDZuk7w76WFcwD0lj?=
 =?iso-8859-1?Q?1JinnQYHVPLVXQ6f7ptXJXV0pzUIiaCAPCM/yKoVrnXBl3fnDcrUB5Ym47?=
 =?iso-8859-1?Q?C7GXmcdum4EDEuaoJ3pJT0bX/i4vmGIeX2Tyt7uV1SMR2zMrTh120DbuGL?=
 =?iso-8859-1?Q?gc6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(82310400026)(36860700013)(376014)(14060799003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:04:24.6151
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f41f9c22-a533-41db-1cfc-08de5e97abb8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C0.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5441
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
	TAGGED_FROM(0.00)[bounces-69381-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 3BC1DA7760
X-Rspamd-Action: no action

Set the guest's view of the GCIE field to IMP when running a GICv5 VM,
NI otherwise. Reject any writes to the register that try to do
anything but set GCIE to IMP when running a GICv5 VM.

As part of this change, we're also required to extend
vgic_is_v3_compat() to check for the actual vgic_model. This has one
potential issue - if any of the vgic_is_v*() checks are used prior to
setting the vgic_model (that is, before kvm_vgic_create) then
vgic_model will be set to 0, which can result in a false-positive.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/sys_regs.c  | 42 ++++++++++++++++++++++++++++++--------
 arch/arm64/kvm/vgic/vgic.h | 10 ++++++++-
 2 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 88a57ca36d96..73dd2bd85c4f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1758,6 +1758,7 @@ static u8 pmuver_to_perfmon(u8 pmuver)
=20
 static u64 sanitise_id_aa64pfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64pfr1_el1(const struct kvm_vcpu *vcpu, u64 val);
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val);
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
=20
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
@@ -1783,10 +1784,7 @@ static u64 __kvm_read_sanitised_id_reg(const struct =
kvm_vcpu *vcpu,
 		val =3D sanitise_id_aa64pfr1_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64PFR2_EL1:
-		val &=3D ID_AA64PFR2_EL1_FPMR |
-			(kvm_has_mte(vcpu->kvm) ?
-			 ID_AA64PFR2_EL1_MTEFAR | ID_AA64PFR2_EL1_MTESTOREONLY :
-			 0);
+		val =3D sanitise_id_aa64pfr2_el1(vcpu, val);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
@@ -2024,6 +2022,23 @@ static u64 sanitise_id_aa64pfr1_el1(const struct kvm=
_vcpu *vcpu, u64 val)
 	return val;
 }
=20
+static u64 sanitise_id_aa64pfr2_el1(const struct kvm_vcpu *vcpu, u64 val)
+{
+	val &=3D ID_AA64PFR2_EL1_FPMR |
+	       ID_AA64PFR2_EL1_MTEFAR |
+	       ID_AA64PFR2_EL1_MTESTOREONLY;
+
+	if (!kvm_has_mte(vcpu->kvm)) {
+		val &=3D ~ID_AA64PFR2_EL1_MTEFAR;
+		val &=3D ~ID_AA64PFR2_EL1_MTESTOREONLY;
+	}
+
+	if (vgic_is_v5(vcpu->kvm))
+		val |=3D SYS_FIELD_PREP_ENUM(ID_AA64PFR2_EL1, GCIE, IMP);
+
+	return val;
+}
+
 static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	val =3D ID_REG_LIMIT_FIELD_ENUM(val, ID_AA64DFR0_EL1, DebugVer, V8P8);
@@ -2221,6 +2236,16 @@ static int set_id_aa64pfr1_el1(struct kvm_vcpu *vcpu=
,
 	return set_id_reg(vcpu, rd, user_val);
 }
=20
+static int set_id_aa64pfr2_el1(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd, u64 user_val)
+{
+	if (vgic_is_v5(vcpu->kvm) &&
+	    FIELD_GET(ID_AA64PFR2_EL1_GCIE_MASK, user_val) !=3D ID_AA64PFR2_EL1_G=
CIE_IMP)
+		return -EINVAL;
+
+	return set_id_reg(vcpu, rd, user_val);
+}
+
 /*
  * Allow userspace to de-feature a stage-2 translation granule but prevent=
 it
  * from claiming the impossible.
@@ -3202,10 +3227,11 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
 				       ID_AA64PFR1_EL1_RES0 |
 				       ID_AA64PFR1_EL1_MPAM_frac |
 				       ID_AA64PFR1_EL1_MTE)),
-	ID_WRITABLE(ID_AA64PFR2_EL1,
-		    ID_AA64PFR2_EL1_FPMR |
-		    ID_AA64PFR2_EL1_MTEFAR |
-		    ID_AA64PFR2_EL1_MTESTOREONLY),
+	ID_FILTERED(ID_AA64PFR2_EL1, id_aa64pfr2_el1,
+		    ~(ID_AA64PFR2_EL1_FPMR |
+		      ID_AA64PFR2_EL1_MTEFAR |
+		      ID_AA64PFR2_EL1_MTESTOREONLY |
+		      ID_AA64PFR2_EL1_GCIE)),
 	ID_UNALLOCATED(4,3),
 	ID_WRITABLE(ID_AA64ZFR0_EL1, ~ID_AA64ZFR0_EL1_RES0),
 	ID_HIDDEN(ID_AA64SMFR0_EL1),
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 15f6afe6b75e..eb16184c14cc 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -456,8 +456,16 @@ void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu);
=20
 static inline bool vgic_is_v3_compat(struct kvm *kvm)
 {
+	/*
+	 * We need to be careful here. This could be called early,
+	 * which means that there is no vgic_model set. For the time
+	 * being, fall back to assuming that we're trying run a legacy
+	 * VM in that case, which keeps existing software happy. Long
+	 * term, this will need to be revisited a little.
+	 */
 	return cpus_have_final_cap(ARM64_HAS_GICV5_CPUIF) &&
-		kvm_vgic_global_state.has_gcie_v3_compat;
+		kvm_vgic_global_state.has_gcie_v3_compat &&
+		kvm->arch.vgic.vgic_model !=3D KVM_DEV_TYPE_ARM_VGIC_V5;
 }
=20
 static inline bool vgic_is_v3(struct kvm *kvm)
--=20
2.34.1

