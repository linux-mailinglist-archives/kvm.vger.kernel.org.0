Return-Path: <kvm+bounces-69383-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLWGCEFQemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69383-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 780F4A777D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3654E30658DF
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7B536F433;
	Wed, 28 Jan 2026 18:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mtiXYP12";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mtiXYP12"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013014.outbound.protection.outlook.com [52.101.72.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0B72737E0
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.14
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623491; cv=fail; b=HXC8VOOkEHp1M62friNne2eAy8hoBdH3BbgNvthB34gOdicmIJ49i8HgxcAdFX6PCSdu3Uxm5taxnlXo5Vs0zGvdaBrVF5Pq8bj8UNDLFNOBjFM5mIneISdIO87wn5YUcTE1TGVDsvkgx0DPXIc/JE46Anf2n9vMvNcXTOFNN54=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623491; c=relaxed/simple;
	bh=a1Jmqi2BDLAcdGePzFKCzBFLvjJcVmVSxfQhpo427AQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=o7wMR2NKeYdIGiFhOyCJWXm8XYqTKfMbv54zanJDjKMM6BESQXMo8P2+kdRSHFQVtJRLnU/rB9bgthdzAkBfCehAAKu7hgR6Nk9FSuS8czvyKeqmVGnsYliXks0sK1zQQLD49FG4Ll1M1kI1uQJFjtoQnmE7HeptSc2LLwOG0ZQ=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mtiXYP12; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mtiXYP12; arc=fail smtp.client-ip=52.101.72.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=gk128E98txmkA6zZg8d1B17YYVMRCOJyOVWkuNv44LIHzUWZgScUO6jvY9tkFXUCsks8VfseljIOHrOZP8NOcpat7E0pb9DCg5rihjxTaoT18bVmPaQJ1urOEYPqw9NPDTzPwergTZoXO77/ili/fg8SJsHb3MO6YbzoU4y0IP8ww93ZG608bqM/u3PiS68+LF7KMLK3lxHLOXZf2EDG7ur/vmz111DckwZ22hJRsgRH8rThduAqGNVMRLF4JiNmgDlkxPVwMBzMURVTDk/sg/2cm8bYlMJuWDchwKab9ZnbtqhwKqSFkkxYom2uJi57FTANoVRmVFuZUjiWYXxXEA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFt1W2b9XaruEaZj9C9pOM9ByAzrXFNB06vDfv/eHHQ=;
 b=Th8o7MHcYsD8ivvG3EZIHXk80qfbLB0SO7PQilnOjWaZ4Z4i36adSAtLhNux7vNoAZmEqWI8h/Xna7WaWm4WiZm0sQlwoOiXMNgGSdYlav5bcOXf1QOjRTLv/8NMgAW72kjyZ2s2DXIt+t8WQ7W92vscXTx21ap0REvOiFDaC85iggStcgKmuP00OKq/PsZ5m1dr/5a4mlaNHAQkmTHK3iK8mG5RksWL844RmBhpVPWkn6j/7l/0Sc7kM/TY9fjas0lgK4WEU+UFivX2fmGg0VLcvJAIE0Z83z3tF4UFeQJ8WShUarrmurm+Heq8yiTCOpgC3sxhIFs7XK4OBGws2Q==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFt1W2b9XaruEaZj9C9pOM9ByAzrXFNB06vDfv/eHHQ=;
 b=mtiXYP12PZcy1pl0buBsTCo9ZQJ6lV73XcPbiXpKGAvDs2fsTazA/LFtReqc0cxkiSCsCsWm87lbeKMYK+sXzQEGGd5LBhk1pj38B4nt9L1Ex4bJpjRGZDgspVGNVqNcsmLt5x48Vpo2xbBZwx2vevv1e7IAmuMthl9Zk/kas8U=
Received: from AS9PR05CA0285.eurprd05.prod.outlook.com (2603:10a6:20b:492::17)
 by DB9PR08MB6476.eurprd08.prod.outlook.com (2603:10a6:10:258::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:04:45 +0000
Received: from AMS0EPF000001AD.eurprd05.prod.outlook.com
 (2603:10a6:20b:492:cafe::8d) by AS9PR05CA0285.outlook.office365.com
 (2603:10a6:20b:492::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.7 via Frontend Transport; Wed,
 28 Jan 2026 18:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF000001AD.mail.protection.outlook.com (10.167.16.153) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:04:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNYBfizn2JvdKRgiCRNNQ/+ngtD3nUYvkh40voKWxyCW/YFzlO+gdGPaelnjVs0pPt+c3vcBSTeZ3+Z0klURdUnyf9haNrhgDmxSTP2kZxqL2+yqwp0SNVt3a1lMji2DU3P3+FV/t5/F1qnEX0z/c9+y4MKzuA968lAHmkQMQkRstVvQEFDNu7aK6nSZXfYIT+WuG2dd42BFFgVoi7hGld6GwfDYf6mk15WrJjOYD55B7AzLIjvtOed3Dk8DYkdJMV9TcLI7Pd1jVx9CutZXiDQO9LkJWvJTjKz55w167EKwEw0oryp0gcf1+bghuVlPcZj66qN2r6om9LduiaSvzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rFt1W2b9XaruEaZj9C9pOM9ByAzrXFNB06vDfv/eHHQ=;
 b=FC220FOCyD9GygjI4AriPQ1XBIISagd96h/uknYuSfWJsGlrSAy/wiZ9x8LsX9Bs/BlNkMF+DUoEOtyU/6CCmn64VZBdIiqrJy3gw4MI9SuTWbecYaQFr4Gi18SteA8PmwLarW6y25FhkNGmYqpYSbdSc6zjaNhcRQshvxnoWhdhZ5GxCZfd49EIsiKEINdYQXR+py3fyHxvnm/uOjL1MOxqWfBZt4Dc0dXk2mBFKo0QY7GOfQ8Izy2o1QLXr/2Ona71eDCCevr93r18PJ0aiI1+qXy/JAYpnI/whIuWyx4E3K8+3qrFRn3igYJ2XNm4KqKP/O7vpNu6z3GPVBxJVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rFt1W2b9XaruEaZj9C9pOM9ByAzrXFNB06vDfv/eHHQ=;
 b=mtiXYP12PZcy1pl0buBsTCo9ZQJ6lV73XcPbiXpKGAvDs2fsTazA/LFtReqc0cxkiSCsCsWm87lbeKMYK+sXzQEGGd5LBhk1pj38B4nt9L1Ex4bJpjRGZDgspVGNVqNcsmLt5x48Vpo2xbBZwx2vevv1e7IAmuMthl9Zk/kas8U=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:03:42 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:03:42 +0000
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
Subject: [PATCH v4 17/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and generate
 mask
Thread-Topic: [PATCH v4 17/36] KVM: arm64: gic-v5: Finalize GICv5 PPIs and
 generate mask
Thread-Index: AQHckIBv1JZvvX3ADUW/2BvhzYu4og==
Date: Wed, 28 Jan 2026 18:03:42 +0000
Message-ID: <20260128175919.3828384-18-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|AMS0EPF000001AD:EE_|DB9PR08MB6476:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bcaf483-d36c-4374-dfd4-08de5e97b7dd
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?mY7EHY2I4AjNO4sfqjoTDpOmQf4IL9bzjEJxz/GZo8woMoo2Mx+1qU6eti?=
 =?iso-8859-1?Q?xRlj5uuWbwZmWHhRCmjtm0HL8S6gteTo9/JqNSV5jIG7Y+FuAzftV/1CmD?=
 =?iso-8859-1?Q?h5hZ+qo8VScmFDxwbIiT+drmVgdJYzgJV+SIQBK3iy6+L1BU8Bh++Y+SrI?=
 =?iso-8859-1?Q?bv1TegBdZIsR+aVnnR6Xp3dSEF9SuGq4oBLHDWBXewlviKxUxM9BM9gioP?=
 =?iso-8859-1?Q?LcBIuEOAHYFUDsdQIZwqr7ZW2C8h6Qe71rj+ep/2IN2Xnr1A7RzW7tFAbL?=
 =?iso-8859-1?Q?9n/gk7gCYsBySTUfi5aY5/yJRqPIi/Ol1t4Q94bs/2HoSK4QxCWmv5rS1W?=
 =?iso-8859-1?Q?SjD9QfzkC2LsRsbczhjpDJukGILXG7gLaq01yPRj+mqfM/oDciAw/Ie7/E?=
 =?iso-8859-1?Q?qaKqJ92H0lLHlaUEQZoM4nxx8OAy3MfDTqxpPz833H3JQZ6w+wZzLWCDTr?=
 =?iso-8859-1?Q?RZwJAivGTyX+Fxep/arwYHBkkmY1aD+9qyXFHDD/GWfUpizqB6sHMf+iGu?=
 =?iso-8859-1?Q?AEAWMnRlpIrWnq1KMF2WJI7Hc6hNJneT0Ej4mcxex6skrJKHt6vlEV92nL?=
 =?iso-8859-1?Q?z9Oc5tMItxltnDleKsdYyZj99zbPsagy5nodCCkwqUDB70LoqQ5nYcafFb?=
 =?iso-8859-1?Q?aNfSWgmJbkfi4TLmM93JUgy1Q5e0V8nOB5EP4GsONfGxHG7wVEc/3tPVIm?=
 =?iso-8859-1?Q?AgTmZZ+kPqoqabbgFZBwOxjs7aYwYKMR9NDBtyAcz5YCNTqnvDRhhXb+bQ?=
 =?iso-8859-1?Q?M3nTHSrK0pODYUfjkhY3Xdh+DHQ3wchupB2ZeSdKk0XZ9yhY3ABeJCKzlE?=
 =?iso-8859-1?Q?6kbdI1dzh/rRZF9W+JvkhcDU40Qn3J27+gXPgnn3ZsUclox5U/t+GOa/6M?=
 =?iso-8859-1?Q?icyHCix8K627fpiJsVgOjUDZ2GTdKA9qr0fXr1bcXplTGFq0XHdKGVfb5z?=
 =?iso-8859-1?Q?gC/hrE5cdYQxC9lmvWoLNZtJNOqTxT2+JaRnVTQ8EjeC50e0KdL+Ehb1Sy?=
 =?iso-8859-1?Q?lLplilvewXpjlweWIT6LnPVM0WGPzI4TxaSAoqWZ+a6JDppUHFHrUMz+LQ?=
 =?iso-8859-1?Q?lxmOdGihwF0pMi4jfQWNlwA0lwHowBx3Jf43fnynqoDNNAaX3qMeVNHVuJ?=
 =?iso-8859-1?Q?VHZWkh4TLBLwU/1YNydNfyQvRlO2EUx664sbqbg1lQRlxGlNu+91SJy9bI?=
 =?iso-8859-1?Q?92ZmoIlv1rmAPxBnPnl/+WOBSVs3Jt8aYnKnKr60XLKu0fCuu29BwnZ935?=
 =?iso-8859-1?Q?mGvdtmEVDnr5exek9ICZHMKriEE3gvW7E4P+Eh8WDkoVNAhNWzXV3meSY1?=
 =?iso-8859-1?Q?IWy9OQnRrrlVvKjRRUAdBkPJVGJ0rkRwZee2jaImeU7yXqbZFqQDjox6fM?=
 =?iso-8859-1?Q?mju+WTa2NTr148DlLwH6vTfk/otfX03pf+1QG4GkFtbvnJ2hTafqvw37iE?=
 =?iso-8859-1?Q?nnsQMtkHNgV37HrPT/TRFzPI5WHnK+ZH8hw9hkCMrWkwDGkoFTZR2HDueP?=
 =?iso-8859-1?Q?IE/IGNi1zNkhFQ7szVLR7fktYaJOvdPrevsIRBCFAxo1CHuz/RF3uA2NLY?=
 =?iso-8859-1?Q?hGLhi3kZFHDN5w1EgJ+oFY5Faax9Iod/Qxhu3/+ZdAGCVDAOe3qEoaEaX3?=
 =?iso-8859-1?Q?UMT+QizkzubP9nyMQBCF6x4aYBhUQyiVvzm8rFF9mNfAtxeOUN8pHFhrBj?=
 =?iso-8859-1?Q?bgTRnOxOURAGg34StTw=3D?=
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
 AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	5dcfb2f9-b2c4-41bb-baf3-08de5e979255
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|14060799003|1800799024|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?RErnte3DMp1rwWDUWVOqATqUUyOSfAiSoRC13K0mlfG8Rp5FDLjksG4cN/?=
 =?iso-8859-1?Q?E+KfHHd3w6p/uthKmtWpH5knnh7zuAq42uc4GkXsQFUoDx7UY9A7zYcHtf?=
 =?iso-8859-1?Q?O1wr7DgRNow42ru3vSXjcZUArY2vo9k5j2fbmCyR7gKCymz8qBvTYFufZs?=
 =?iso-8859-1?Q?rpfOfKiT2bnuxu6Bt+XOyahEyaOr9EVJVzqv43nKIe0cfRRXqePo77ccyN?=
 =?iso-8859-1?Q?/Jl1LanFIHn5IEz9up6jd0TYB+aJ1/15Q9KRPyXr8Mikofjgtz7y/FWV2Q?=
 =?iso-8859-1?Q?/czil7NEGaM9hALfVc1SEv6V4JB1M7I6ItN9+cjrz73iwbUOaGCTJsOHP3?=
 =?iso-8859-1?Q?OBNsqzZmTTTNXPLzy6UNhq34IIbKV8dTD9vCZ49U18PIdOiYANLduiXf3W?=
 =?iso-8859-1?Q?yZO2KtnotGeqv1Zj7mXyTKDwwhQBL3TwF6/N67GG7asO3MUSzoOqnELNv+?=
 =?iso-8859-1?Q?N8gfDet5KIO35ee+7Y8ZnGpyFAaz3qGE6GoPW0KmVosPyNCIa+ELzijJh8?=
 =?iso-8859-1?Q?YSBO4K/usKfxuuQOmQb30ZvJMfKjZ/Zofb5z/wGAwQaDasL8njsIXNJ2eO?=
 =?iso-8859-1?Q?xBOhA66OBRuR9xPsuJ/UKdH7YOvpUDWufQn+W0IviRcXTYnQz9ibPWoJRP?=
 =?iso-8859-1?Q?jIET5wOognw3C6vd6EHxDocKsXSXt69Dj21henvgKCyYBeZSlp+k//iOig?=
 =?iso-8859-1?Q?2AXBYD/EJ6lFwclK9B0q9K8asY4pahVuEQeser41Ou6EnJ78WonediLu8g?=
 =?iso-8859-1?Q?W9WOMNG3QE6sjtLIyw0PgziwY5lxEftQDTQfbqQHZnUiXyy4NU6wQOfq8d?=
 =?iso-8859-1?Q?LMB1V0kNr68XMF33/yi0fXJ8kyJLGqrlfNvOlT0WA3ZZyvFKWcRwGuQXDg?=
 =?iso-8859-1?Q?60ZidSaQzonAYMeVmiDYFyqGrCNAWI3HDd0OuZF88i4f2PK4CQrE9H/f3R?=
 =?iso-8859-1?Q?5iu3ZrAo3suPgVi8GCT+TF3A5iNfIsKTwncbwRcePN+mNjUJ84JtPCDs5n?=
 =?iso-8859-1?Q?mcLf/YlZlq743KrETEj5kSQ4M0AVgHUSZaJtS1F5VSp0jN3ZEHn1Qj8Je7?=
 =?iso-8859-1?Q?x4ZnEmcPYR09mqCFfmVP7yg2Uk8S3bxzRN11eEpZeeBbcY1J3B7YSQTq8G?=
 =?iso-8859-1?Q?MZqoK7BBtSAAdV3A1zmNoTpGTIphMe7pZnBM5phxwJYnNtTd/AaODYxSAN?=
 =?iso-8859-1?Q?9sbChKJjl8E6LJcwru0JOaXu7L3E/L4/F83TnHe7I8kpNW3S2k0/uNrRy/?=
 =?iso-8859-1?Q?U5EDLim4Umr8P1HN24yTVCWxS7rQUYqUGXVEn7Jhm7IodaSMcCioHjWDk6?=
 =?iso-8859-1?Q?mBhsZpps1yigcIddrLsMvsTUCxG7nyNrOJFrj/1XfXMIDhwNrXOZm7Hzz4?=
 =?iso-8859-1?Q?QhbF93Ufw+SLGXSNG+hhQNXgopRWrIbUrZsbo/0d9dXusdf+ac1VhT2k26?=
 =?iso-8859-1?Q?OtIh4qYAK9k4uRtSejuyqPaxPsTsrl8ocltYOi+dOAl+jDeIJ852/gpqTH?=
 =?iso-8859-1?Q?FDaJoVtpGaBRsGs39pM17B3ZwTC159RYocV8+tJhzxod3mFhlblX1QvG3P?=
 =?iso-8859-1?Q?/1kH/D3RDG3nbnhDMs+8e7IWGb4ZqqLcvCjLH+J5RL6BGvxlJpys7qzGO+?=
 =?iso-8859-1?Q?mh2RyyYkgHxyqyuYrntcIsqR/q365bFCPOaDseiYc2HiAoO8OKL+i8vBHJ?=
 =?iso-8859-1?Q?2rwzi1OKhBod+AVGESm5sG0+mQUu9HzFhJCdj/xbuU7Sbbk2OZu4AunIXA?=
 =?iso-8859-1?Q?rrfw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(14060799003)(1800799024)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:04:45.0062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bcaf483-d36c-4374-dfd4-08de5e97b7dd
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AD.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6476
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
	TAGGED_FROM(0.00)[bounces-69383-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 780F4A777D
X-Rspamd-Action: no action

We only want to expose a subset of the PPIs to a guest. If a PPI does
not have an owner, it is not being actively driven by a device. The
SW_PPI is a special case, as it is likely for userspace to wish to
inject that.

Therefore, just prior to running the guest for the first time, we need
to finalize the PPIs. A mask is generated which, when combined with
trapping a guest's PPI accesses, allows for the guest's view of the
PPI to be filtered. This mask is global to the VM as all VCPUs PPI
configurations must match.

In addition, the PPI HMR is calculated.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/arm.c               |  4 +++
 arch/arm64/kvm/vgic/vgic-v5.c      | 49 ++++++++++++++++++++++++++++++
 include/kvm/arm_vgic.h             |  9 ++++++
 include/linux/irqchip/arm-gic-v5.h | 17 +++++++++++
 4 files changed, 79 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 370153462532..f9458409d50a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -889,6 +889,10 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu=
)
 			return ret;
 	}
=20
+	ret =3D vgic_v5_finalize_ppi_state(kvm);
+	if (ret)
+		return ret;
+
 	if (is_protected_kvm_enabled()) {
 		ret =3D pkvm_create_hyp_vm(kvm);
 		if (ret)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 4c34ac6743d1..b7ff336dd50b 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -56,6 +56,55 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
 	return 0;
 }
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+
+	if (!vgic_is_v5(kvm))
+		return 0;
+
+	if (!ppi_caps)
+		return -ENXIO;
+
+	/* The PPI state for all VCPUs should be the same. Pick the first. */
+	vcpu =3D kvm_get_vcpu(kvm, 0);
+
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[0] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[1] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[0] =3D 0;
+	vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[1] =3D 0;
+
+	for (int i =3D 0; i < VGIC_V5_NR_PRIVATE_IRQS; i++) {
+		int reg =3D i / 64;
+		u64 bit =3D BIT_ULL(i % 64);
+		struct vgic_irq *irq =3D &vcpu->arch.vgic_cpu.private_irqs[i];
+
+		guard(raw_spinlock_irqsave)(&irq->irq_lock);
+
+		/*
+		 * We only expose PPIs with an owner or the SW_PPI to the
+		 * guest.
+		 */
+		if (!irq->owner &&
+		    FIELD_GET(GICV5_HWIRQ_ID, irq->intid) !=3D GICV5_ARCH_PPI_SW_PPI)
+			continue;
+
+		/*
+		 * If the PPI isn't implemented, we can't pass it through to a
+		 * guest anyhow.
+		 */
+		if (!(ppi_caps->impl_ppi_mask[reg] & bit))
+			continue;
+
+		vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_mask[reg] |=3D bit;
+
+		if (irq->config =3D=3D VGIC_CONFIG_LEVEL)
+			vcpu->kvm->arch.vgic.gicv5_vm.vgic_ppi_hmr[reg] |=3D bit;
+	}
+
+	return 0;
+}
+
 /*
  * Not all PPIs are guaranteed to be implemented for GICv5. Deterermine wh=
ich
  * ones are, and generate a mask.
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4234bc686f4e..338bbfec8274 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -32,6 +32,8 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
=20
+#define VGIC_V5_NR_PRIVATE_IRQS	128
+
 #define is_v5_type(t, i)	(FIELD_GET(GICV5_HWIRQ_TYPE, (i)) =3D=3D (t))
=20
 #define __irq_is_sgi(t, i)						\
@@ -385,6 +387,11 @@ struct vgic_dist {
 	 * else.
 	 */
 	struct its_vm		its_vm;
+
+	/*
+	 * GICv5 per-VM data.
+	 */
+	struct gicv5_vm		gicv5_vm;
 };
=20
 struct vgic_v2_cpu_if {
@@ -570,6 +577,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu);
=20
+int vgic_v5_finalize_ppi_state(struct kvm *kvm);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
=20
 /* CPU HP callbacks */
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm=
-gic-v5.h
index f557dc7f250b..21ac38147687 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -369,6 +369,23 @@ struct gicv5_vpe {
 	bool			resident;
 };
=20
+struct gicv5_vm {
+	/*
+	 * We only expose a subset of PPIs to the guest. This subset
+	 * is a combination of the PPIs that are actually implemented
+	 * and what we actually choose to expose.
+	 */
+	u64			vgic_ppi_mask[2];
+
+	/*
+	 * The HMR itself is handled by the hardware, but we still need to have
+	 * a mask that we can use when merging in pending state (only the state
+	 * of Edge PPIs is merged back in from the guest an the HMR provides a
+	 * convenient way to do that).
+	 */
+	u64			vgic_ppi_hmr[2];
+};
+
 struct gicv5_its_devtab_cfg {
 	union {
 		struct {
--=20
2.34.1

