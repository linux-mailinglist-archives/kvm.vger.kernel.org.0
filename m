Return-Path: <kvm+bounces-69386-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJJFNSxQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69386-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 22E41A7767
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 213A53007ADD
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0368A37107C;
	Wed, 28 Jan 2026 18:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HXM6kHsn";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HXM6kHsn"
X-Original-To: kvm@vger.kernel.org
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013001.outbound.protection.outlook.com [40.107.159.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0667C371042
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.159.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623539; cv=fail; b=mlBgwDSs2uvtrlPws104ZleOut7ghpwZPLpYhKykyPoZvCj9iVp7jRWCfAk8ff8daMytlhkFQrRACj9Et8QRKubUH2Cnqt/tKjkPn1qflXGVoX6Kg9Qg0LcMbeHyaPyd7HwjFebsBbGPjoZpwjdCuQqN5mj01JwBFPdkKqj7JOQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623539; c=relaxed/simple;
	bh=So8pMAOgL3n/+uoLL7RgyrpBpk05o+zRP9zV1Q2y6O0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YQ348gXMAcQzwvMvGzWt+n0uNRajqux0Ga/4C7R4hnpVb5u82Mcgpf3CU44CetESmPOMS+VOMpT8Yl8FzvaOcSspVAXgJBEl3KXxVohn5PD5r2OXOek/0WJ9HxvxsHfnuX3NXadTuUkNCLCnKPh1ixdrHGAUfpdWwfZY4eBTh8Q=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HXM6kHsn; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HXM6kHsn; arc=fail smtp.client-ip=40.107.159.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=cTRFaQEs58fiNVAnjOlLY1FCz/t0TYFKAxDSuC4vOvGimSyU6+d2zRknJPYG3cqctqnMbnYgoDuO0kIx7gHGbnSspw39WJJxK/tgMQussA2JvpdnEoKEW7NsR3uBJcwD6Dg9O72NatBzLvxeCDdFYCtpGwBRuw89XKF1br1S4fu84+z8evcbqEn+qspiKwvPlmt3bNZcC3oYiONg2uQsp94rxvpbA3niWqn8PYZrk2Ula8tcqfFBBOaOcfCW8TnwvExG/SqfjXMqc42T218iTS8ZHCmK8rNqfMTVDeO7iuCzh//OBh5UAndGKg4bro7SMN85hHY1WHRvuvkxiYtlcQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLUVnkBJ282SuWFhmOMPhHy2ylR5GfO+lhqACSLAcGY=;
 b=uHLkOScwjvlr2/g6xJaa807PCL0EASPVVZLeQ/RyKzL0+hVekkjscD4tJ9b/LSfXQZN/0pB1KE+Qx9xmvZPEDdMvP4rEjwfRM/4NJfoh+IzFPTZL1hpunWdR/L+K37ZHJUTA4XQ9WR4oCFqMUJL1IMfAv9QwM0gXx6oEtRfdfKQEK2KIrsSM7gRmeXs4W+FbIhVytkTCiHtVhBizwXJ+cLXMAIWI2dLFVAt/w13KB11OXelkbPkPcyKC9rLFtf7qDbVj6j4EFgsnOsMOUCvxsZ6FujSmbLRs8qv0yfg9tBISCgEwj7yA6PC5JFnoSXiDcYosH8UMlB4yV0osZcloEA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLUVnkBJ282SuWFhmOMPhHy2ylR5GfO+lhqACSLAcGY=;
 b=HXM6kHsnatCJfmX2Q9gacNn3GjFi+0WN2rD5ACDVkh6ENZm2d+JQJL+v7cgXJ/JtLXma6cLrTmJF0Zj6PLyjnlY4RJQxQFR/QtzTllWOlrNSEa9cfhh2XyfHopWZwT2RKX8JxMPjY32fT9QgQTCyR5gt1aaKn9YAe9cbjYoOgUw=
Received: from AM6PR10CA0053.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::30)
 by VI0PR08MB11711.eurprd08.prod.outlook.com (2603:10a6:800:312::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 18:05:31 +0000
Received: from AM4PEPF00025F9B.EURPRD83.prod.outlook.com
 (2603:10a6:209:80:cafe::d8) by AM6PR10CA0053.outlook.office365.com
 (2603:10a6:209:80::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:05:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00025F9B.mail.protection.outlook.com (10.167.16.10) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.0
 via Frontend Transport; Wed, 28 Jan 2026 18:05:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jABzY6kFbHwITrg0GW1Q2QtxRjWBjdp4gDiPEpxog392F7JC+Qid0dZFWa+alJTCmKkfFnM5e/AzFwYLwydgQoFjVxM2QVpnfeNxyebz5R8pqTl3I6HXANa3R2392jPi72iHxZ7gk/MAhdRG/mPn+m4ueVHyiSH3VjhN5QKtpd43iX2y3RFDch0LXZ1u9OO+J/tpOUVCw30sX7E6FHsfick5C/V97fZZpJicFV4ZuvNZLlp4acYIsPljooOzCpOgsQ6p8V8i+r3Sp5qpGyAYyIJaQCndayRzxnj2xJ+NGPV7AnGvv9Y7JZe8wrDNsGvDMkaxiUgEFc4p7aq3mn4q1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLUVnkBJ282SuWFhmOMPhHy2ylR5GfO+lhqACSLAcGY=;
 b=koVRqjEPmracat73SD/6UaIjZbmDkffjV6Q+84IsItUN5J9Yu6KA+KOuEJiOISnVHb8MmF4HnixnBVXWk7QOG8kndknGG1S55XJRW0gT10/K0Y6l9W3L6tpFXA5ikgtGOTj/pZIcC1B1X5oGGD+HukWsbbsdQs+tTkNMQMLaP0z/cyd9vsD9GFap8B/26wea5h+3421q7VlIGElLgWAIcjZKmCALOzOzzT94LKqfJ9FY4d4w14Q9amZBXAJzh4CR3zcnz0sgtx6SPdNaqA1MOSIDJxuA9fw2MTCP1CTB6p6/DQwqJSpUpPI3bStguLG9i+mcecDufa1cCVCRI04+Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLUVnkBJ282SuWFhmOMPhHy2ylR5GfO+lhqACSLAcGY=;
 b=HXM6kHsnatCJfmX2Q9gacNn3GjFi+0WN2rD5ACDVkh6ENZm2d+JQJL+v7cgXJ/JtLXma6cLrTmJF0Zj6PLyjnlY4RJQxQFR/QtzTllWOlrNSEa9cfhh2XyfHopWZwT2RKX8JxMPjY32fT9QgQTCyR5gt1aaKn9YAe9cbjYoOgUw=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:04:28 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:04:28 +0000
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
Subject: [PATCH v4 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs) for
 GICv5
Thread-Topic: [PATCH v4 20/36] KVM: arm64: gic-v5: Init Private IRQs (PPIs)
 for GICv5
Thread-Index: AQHckICLEmSeSdRDeU6ZwbM61HJP/Q==
Date: Wed, 28 Jan 2026 18:04:28 +0000
Message-ID: <20260128175919.3828384-21-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|AM4PEPF00025F9B:EE_|VI0PR08MB11711:EE_
X-MS-Office365-Filtering-Correlation-Id: 08b56e97-bb00-4d8c-ad74-08de5e97d328
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?YSh+h/b+Og7wj8q6Clv383Qgn0OoaoVA5dFr8FyWVe7x/Oro5QpFygP1Nk?=
 =?iso-8859-1?Q?xJo4h3f5tVx8Huftl8T3lHTh5EmOo0GQXMsrvAaax5XT2DjpBhqgf9miF5?=
 =?iso-8859-1?Q?ksS6BFpQUU8rZaoLvYvDbtYr6GiXT6IYaC+xq/CfUANH4hA1yxujsPzgfI?=
 =?iso-8859-1?Q?WeRpkcRZ97SXjYhz1qU0lOfClO+V5J4IW5QNnrforBGo6Pnz1le0Rll10D?=
 =?iso-8859-1?Q?ldSazTW2WnOyCPBxKV3AhgWOlbX+8Oq15P/pGRRmB4I0+llOuGP1PlNgM/?=
 =?iso-8859-1?Q?ObyYuXPZfviWmQVL6PZsX9MXrhM1L1GVW1zNC4A9EYiqFmPrOrQVhWWVzz?=
 =?iso-8859-1?Q?Y2983EavAxCrnCeDIcyUpdkmCYC3MB1vgKuoelKI3Kgvj0/MZm7mYV4EWo?=
 =?iso-8859-1?Q?PrSkAGLPH5jhHz22X93JvshNYmdI2TGv2l266T9pyPiH+49Xxxs49fE4fg?=
 =?iso-8859-1?Q?7E2P1aP3NmSsd0OG6XAppIPjaksKaEjybTxBt4Qh0xio2Ej/Zl7O+NE52J?=
 =?iso-8859-1?Q?xp86Fa3P6hM1OMIHMWRLDbccaO89KvnN3StpqP6PaLRF6iSrDcyH8FLorW?=
 =?iso-8859-1?Q?2HvSJLIURdpKBxxIRvOgmznczkd7lCNsEcLFN8qAkMBycRdH4Xpj8jhAD2?=
 =?iso-8859-1?Q?Ajkpnw/dRzxfZ+SfJ2frFkl5Ysit7lI0hB0piEQkjD44AY0vj83ulPuzKT?=
 =?iso-8859-1?Q?Lya8mzKk26rAlHVJ0d22Aq+v2F2eE5dgkV9T+JVyAwudU1PzBkFg574Y1Q?=
 =?iso-8859-1?Q?fWTZwrS5wsGEOpi083omjJQzdVMxDeaAuI6AS0fxaEAjLJ9js/Nv4dfRV7?=
 =?iso-8859-1?Q?g0q/vz1WSOujsrDQSRPZLhUDxUq3lDN8o0qnH1q044Lzir7axLj1v56i0W?=
 =?iso-8859-1?Q?+c1dU4XiCJ3IwDMIDi/dD9jIxFqG1G8UwXcymzdPqKrAGfw2NswkO0Xr6D?=
 =?iso-8859-1?Q?DwJqD9Ek0mu744+f0JGbCg0PJI3T1W5tHc+J+ZlcY/yuUmebi3CI2qp2aq?=
 =?iso-8859-1?Q?VsCtRkHMrA3+KhrtIJ2aSK0UuYIr2FTzjj3rRDTsHoxl4aFBYCpTtHiGgI?=
 =?iso-8859-1?Q?zV6+zuu2iJNDZMF7jE9tCH70ZAeVl6MVD4W5sFa09s6y+KkzRbLcIfVyfY?=
 =?iso-8859-1?Q?RxyJN+wKD2V3QYFiztoVCiN43nmwn5osz+lc/hlc2VEjZwFlyI+rpMRy8b?=
 =?iso-8859-1?Q?03otHkHnMhplFKkiH6RXNfAdIRhb/WLWh+8gTQEt2ItbVNEg+IO9J2lZoY?=
 =?iso-8859-1?Q?DnpsiDKtRqmK4qu8vkGFXIpUBqtHhkV2M+ZpRWYpj4m9Z/ETWfDUWZ29e3?=
 =?iso-8859-1?Q?FXxTHkhxxyQIgKvQ5mc051hAkN0o2v3bi3BlssBI/xbkDzV0cmMvymmNf9?=
 =?iso-8859-1?Q?Rt2jvd+FTZel4ilvx8NYRCWG0fZBpxQZBSMwpkbO+EoUaTP/fXInrGoEau?=
 =?iso-8859-1?Q?p3EQFi6dileVmV4tfh+3cv0bCJrM3u9Q7XhOaj/0SVa3Pa5Mdwwemqrfmv?=
 =?iso-8859-1?Q?RaSuwuL17U/qEi1bRJN5JNAYwR9H9TBAVT/n3kqKmIv9x/qmTTCGMTQSXJ?=
 =?iso-8859-1?Q?oecOconWHUPEQsUsuM+cfTIxtU2jS0sT8E595SXjaUL+xdx1ZQY8stqvrl?=
 =?iso-8859-1?Q?tFskqt/YBuEq/BJFM0vqOuyk+zFDperZ5evgi1Dtsk51GJLXpooX+ZrxrE?=
 =?iso-8859-1?Q?OvYcGVh9TKgsD2ZgL0w=3D?=
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
 AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	72ed9098-b06d-4c32-59a0-08de5e97adf8
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|35042699022|1800799024|376014|82310400026|14060799003|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?CeKvOjG9wCZ/r4jqQipz2VzLS4noCoLufmH772ikZRvIQrwzkY6KMACm5d?=
 =?iso-8859-1?Q?NeZNvN4lEYHHCEYU3Xhm0XbhDc3t7jRk0MubF05OJpqTJp1U0HrpXuS4R6?=
 =?iso-8859-1?Q?UhkafthJIPVAeniJZFlvTGBN3RqzbQ6vK2/rvaqClh8V+FbMe8WCbCBPIq?=
 =?iso-8859-1?Q?vc5eDgITzB9kp2rOUoXm+mPLNUtYpFLtN+b+OffSVA3UHBTewk4QXGkgk8?=
 =?iso-8859-1?Q?VR8W7XnDIhzc35+l/Bb0T6YmsvGrXoiveKJvIDVuNlcQB+amJ66Oo1vGXn?=
 =?iso-8859-1?Q?wMynmS/gPk9I5Uyi6eldS7No2ikMPngZGbIVKBWzFXIc5Gq9q0M6dEy2gB?=
 =?iso-8859-1?Q?F0y7pGIK6GzoHhbem9w3H6eS4ZykMwWo0onqF413i/0ZdXdl8Fk6RMVnqp?=
 =?iso-8859-1?Q?6Nkx0qOGOzVO0FUN8uy3KgLh8Vv+sZKlTEBfLiVjYdDURF4FR6sD29Eq93?=
 =?iso-8859-1?Q?DE+Xmp1gY/spcG1zg+wum8k81F5KRJ6KdtKvjECGz0Z16vWSSqsqQ1ifjj?=
 =?iso-8859-1?Q?F5NaEhCtnGKSHtzLBuaNeXJWcE48NUbtLz49qZ9aK/5J9V2gcCBfexD0j7?=
 =?iso-8859-1?Q?vdVoWpJEtU5UYNWzX+QQDtmsJE6CDahyQtMvS74fVFqKwwx0yZoDm2DE/R?=
 =?iso-8859-1?Q?sfxxO8BdJnc4ReKpM44j7jloadA/ztAFwEaauMcTQ3i1r+r5L7SkOLt5Kp?=
 =?iso-8859-1?Q?JeGsPQ6V72cy/lNQVonJ5BliXh3ZVe5bwJxQ4fZgFZ4TIjeHUovn/rDbpc?=
 =?iso-8859-1?Q?B/5AZcbAdPGdz3dOrbjJo0xbQIe/bR3UYXnfuW/MCdFWaMHujDwVfYNL3T?=
 =?iso-8859-1?Q?86klEaaKMlo7tQCZTkBIVvtbFeW2kZ+Vl/uq0ed7ESYVT7Fv3WeBhd7gkI?=
 =?iso-8859-1?Q?7z+fCwMHiiu1fL/e3JWuSYdE2bilUqrjIpLSGPaa6cawHAeDKjkDNuHDvw?=
 =?iso-8859-1?Q?o3Zakl0sIoGEye7SF30XWuwAmEUsqBurGNMTLnHPCqI7F/EkPNmWoLkt9t?=
 =?iso-8859-1?Q?QQJV44kcTKV9D8UHCH4y/fxszzx3F08sSWD6RbaYXREVKdLwymkaqfS6ek?=
 =?iso-8859-1?Q?enR2oYUMzWk2AO2KkmCNFlTEce0jGo5sDEi3vc1XvxPrzShcN9uiecgOaU?=
 =?iso-8859-1?Q?8Ff0qTnSmiCerNllPvLEnkrTqGQasS8K5rt20hQnOmDyrX0sxCHtCHKT2t?=
 =?iso-8859-1?Q?3uTKTy+ATn5NvDiGCUyncx2F0ErTUKh60QLAt7yGjWzjjSx+90n1y5MEZk?=
 =?iso-8859-1?Q?jvP7Tr23qdHqh0vwlUQ2eGrCUzwfxfpcfnSa/w1DeIeb8ScbdH2yZyeyV9?=
 =?iso-8859-1?Q?/JJdddxwfwlDI1Ov7iWG64j5HSgIYTYe5bEQo35YclXIKNIyaU4CINNtR2?=
 =?iso-8859-1?Q?D3ti3a+AvFigrwTlDPVDIYW8pzeDf3bRJpohHBqWUgbZO/TUtnQRa0/mZU?=
 =?iso-8859-1?Q?7tvb2tcC2ysPgM9zMAngOEmgdFtJmEHn+sD4TmVnyGlFyEHztMbYF1s0bY?=
 =?iso-8859-1?Q?pCvFkCGWi1Kijai8ksG3UaG1XdcJeu3Je9S0MT+j3LG6Ns1oTA1rQRonhT?=
 =?iso-8859-1?Q?DIKQ4hPUacsxPcGv1NcQXa7wZL+wyQZmiedefqmzq/TPvOgvNT+jbZqzKI?=
 =?iso-8859-1?Q?s3X+viRSFcKk//+AcTkJmV3/fk8qK0T+hk3XXwLqcuGQKZQaJZk7AD+955?=
 =?iso-8859-1?Q?ZLNwH2ZT0YU0kKKB2GdgXZ/9jYmCzp/trqaxG7Y8uTzg+U/UQOP0QfMZmG?=
 =?iso-8859-1?Q?GrJQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(35042699022)(1800799024)(376014)(82310400026)(14060799003)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:05:30.8047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b56e97-bb00-4d8c-ad74-08de5e97d328
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00025F9B.EURPRD83.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB11711
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69386-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,arm.com:email,arm.com:dkim,arm.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 22E41A7767
X-Rspamd-Action: no action

Initialise the private interrupts (PPIs, only) for GICv5. This means
that a GICv5-style intid is generated (which encodes the PPI type in
the top bits) instead of the 0-based index that is used for older
GICs.

Additionally, set all of the GICv5 PPIs to use Level for the handling
mode, with the exception of the SW_PPI which uses Edge. This matches
the architecturally-defined set in the GICv5 specification (the CTIIRQ
handling mode is IMPDEF, so Level has been picked for that).

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-init.c | 39 +++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-ini=
t.c
index 653364299154..973bbbe56062 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -263,13 +263,19 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 {
 	struct vgic_cpu *vgic_cpu =3D &vcpu->arch.vgic_cpu;
 	int i;
+	u32 num_private_irqs;
=20
 	lockdep_assert_held(&vcpu->kvm->arch.config_lock);
=20
+	if (vgic_is_v5(vcpu->kvm))
+		num_private_irqs =3D VGIC_V5_NR_PRIVATE_IRQS;
+	else
+		num_private_irqs =3D VGIC_NR_PRIVATE_IRQS;
+
 	if (vgic_cpu->private_irqs)
 		return 0;
=20
-	vgic_cpu->private_irqs =3D kcalloc(VGIC_NR_PRIVATE_IRQS,
+	vgic_cpu->private_irqs =3D kcalloc(num_private_irqs,
 					 sizeof(struct vgic_irq),
 					 GFP_KERNEL_ACCOUNT);
=20
@@ -280,22 +286,37 @@ static int vgic_allocate_private_irqs_locked(struct k=
vm_vcpu *vcpu, u32 type)
 	 * Enable and configure all SGIs to be edge-triggered and
 	 * configure all PPIs as level-triggered.
 	 */
-	for (i =3D 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+	for (i =3D 0; i < num_private_irqs; i++) {
 		struct vgic_irq *irq =3D &vgic_cpu->private_irqs[i];
=20
 		INIT_LIST_HEAD(&irq->ap_list);
 		raw_spin_lock_init(&irq->irq_lock);
-		irq->intid =3D i;
 		irq->vcpu =3D NULL;
 		irq->target_vcpu =3D vcpu;
 		refcount_set(&irq->refcount, 0);
-		if (vgic_irq_is_sgi(i)) {
-			/* SGIs */
-			irq->enabled =3D 1;
-			irq->config =3D VGIC_CONFIG_EDGE;
+		if (!vgic_is_v5(vcpu->kvm)) {
+			irq->intid =3D i;
+			if (vgic_irq_is_sgi(i)) {
+				/* SGIs */
+				irq->enabled =3D 1;
+				irq->config =3D VGIC_CONFIG_EDGE;
+			} else {
+				/* PPIs */
+				irq->config =3D VGIC_CONFIG_LEVEL;
+			}
 		} else {
-			/* PPIs */
-			irq->config =3D VGIC_CONFIG_LEVEL;
+			irq->intid =3D FIELD_PREP(GICV5_HWIRQ_ID, i) |
+				     FIELD_PREP(GICV5_HWIRQ_TYPE,
+						GICV5_HWIRQ_TYPE_PPI);
+
+			/* The only Edge architected PPI is the SW_PPI */
+			if (i =3D=3D GICV5_ARCH_PPI_SW_PPI)
+				irq->config =3D VGIC_CONFIG_EDGE;
+			else
+				irq->config =3D VGIC_CONFIG_LEVEL;
+
+			/* Register the GICv5-specific PPI ops */
+			vgic_v5_set_ppi_ops(irq);
 		}
=20
 		switch (type) {
--=20
2.34.1

