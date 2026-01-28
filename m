Return-Path: <kvm+bounces-69375-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IITTBUtPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69375-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:02:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 74FE8A76B7
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 39318300290C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7C736F419;
	Wed, 28 Jan 2026 18:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ksQkuY/k";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ksQkuY/k"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013057.outbound.protection.outlook.com [52.101.72.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E45D2505AA
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.57
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623366; cv=fail; b=kjJDFRLU+S90nt2Prqr96qmV8fuTUDCBMvT2gkZw/XyL1y8xnBZeKfvJVCDN9clgTupqN1Aq5TeJM5rBzAKkLEuOzFj/uOEN54KWkwML56t8rdw9ULyP+xEL4hVg9rK7vdRKDmlQIYhm3cVuQq7CgtT5QHZdDYzet4VEvEmkVN4=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623366; c=relaxed/simple;
	bh=bqGnL1VF94s6r0f4qWgM8ko92962Tee2z7hRo11s32Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lNuGeWKOv7vZYUJa9b4AhSTIzkj3pdRvfaQDm0Ry7GuSzSiEtb/1cyXQbcsxPfXJ6tEQ+6RQzEk/6wXp2XV3fNDID1+6JunxwV7p34tRM7Wx8wszNvWjy65rUM3o4+g5RKWWaDpwQs8JuELnhEsPvuRTCsJ0QChYABDspwGF7L0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ksQkuY/k; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ksQkuY/k; arc=fail smtp.client-ip=52.101.72.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=u9WuDVcJFZsTGqQy2mMJTMOtNCELUfF4FbrfKCflhRdiB4XxNqUuj64va6eSdX1L03DLkp/0vhgfCtU3FczIamJWxlXk+RXRovSr01Za+4lg4dMBVPkc9nPA2GM3r1StIEFPJsNOD7irZyepXvUN9dzbkRrnoOdL3dG/PbE5qDunV7IpEeiFms67ZzGVmVWw+KeXFUKxX6WrimxN8pqlSmlZ8s0Uwli3wwLRhyLZx9Og91C8eLJsB+ZRGg0Bc72ijSVPaNYEtuqEBL4mKqlEx8xG3kvQgd6Y6TFHAqtcUGJ5r1ZCyS4FeI+KBMvHlVBPC3J/7Z4c3rWvNRI0AQAnlg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqGnL1VF94s6r0f4qWgM8ko92962Tee2z7hRo11s32Q=;
 b=WKjCol7lNi3xP1AORf7EDzR1cFRq4ivHmjxwCcgg6gb6eqyHfOYzMSQz0pm4/mpHtXkMrdNbbZBYCym57wED8i5w2lGuLcBY/ub8hCTH9IjlJhOx5UOhqu8vVwi1kuAT2qOhdNn5huydbBEA3ilCC/AzF8MPF/pTDEOXRhvzDHRrveeNfEUdN0u2kTDqXOfEoB6hAMdGY32XD0ssllRzALaTSiwy6QWe2fFWDGgbhOBjfdMZbhnIpU2d+cFNmDRiZbc6pIINMyk124LDoVtI+Qwp13lbj33Z09NNEAaNgdmekguIbKdzHZtf5ku8hGvjgc8d8leeQMR3A1y8cCq40w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqGnL1VF94s6r0f4qWgM8ko92962Tee2z7hRo11s32Q=;
 b=ksQkuY/kDjs4BnrTYzAptcb7fMqeSDI1KFDVNoAVmkhthepIUnULaXdS2+XoqbyFhdtRb4eo8LwzxtTkZa0ePV8vLO0ntIoRW5hN4Vf8n84HjnBbLeYY+LxxYd78oVndYzS6UG0jy+E3AHZGYFNngROcmrJrvvltlqLzTujjoLk=
Received: from AS4P189CA0028.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5db::18)
 by AM8PR08MB6578.eurprd08.prod.outlook.com (2603:10a6:20b:36a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 28 Jan
 2026 18:02:42 +0000
Received: from AMS0EPF0000019E.eurprd05.prod.outlook.com
 (2603:10a6:20b:5db:cafe::a6) by AS4P189CA0028.outlook.office365.com
 (2603:10a6:20b:5db::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Wed,
 28 Jan 2026 18:02:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS0EPF0000019E.mail.protection.outlook.com (10.167.16.250) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:02:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a8FsX8m2ra+dYLyRiSXll2C0M66Ame3ef9bvknaRaQ5J6CyJ/GsKCvcBewWLMCv1apxEoSPlmiOY3D8atbgMKidGcGDfK7Mja1FCiZVHZMabo7xTfKJd3tIybcPasK7OEZvRUFqnGXQeTH+aPZi/Qx0OLn1/AMku8ncDqOafm5j424Ms6C2VgdVeDej0Rts/NWJkc9U7htFsuNW7a6fQSnOo3c1Kvj5W1EgCHs5/jEB4A8/KZLAeOjVraalwCJQ4esTOpTuDBMkfTNyWz3RS9XIv3fEv4XhwhMj+BDw0MUdCYxO8UQlPeUJ0MfU0ear9H5lHex6unfNGjsJuEdb1/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqGnL1VF94s6r0f4qWgM8ko92962Tee2z7hRo11s32Q=;
 b=W0u5zvf/XaBncwYNNuyTA2QHjcqopxxhqTZfu5cW1kD2EYcv5ilsU/K32SR827Ouz2+2xkpwIIQw1Yo6Wjt78hvRC2tv4O2ZIBGLRA8YQ3dv78yeRi9jhUs3wp4PuLlF0a9EIYsrYpeqcW6nBadC/nH7XyH7iOrKUruMHEUbDp8yNSarTRNycIFlWNqTfsvIkqhzE1/ftdfNTu01azyjI8Yulnz+Lm3VebaPwS5pOj63Zuozwb+TnhZI+G2elySgU9pPgcDmv8dUjUNz4PpyCq0O6Cc11lZHuWEMuy2NoYga6uVNzvIDYQQ8QkmPwOSjSm9ERRDiPwCEl5U9N9azWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqGnL1VF94s6r0f4qWgM8ko92962Tee2z7hRo11s32Q=;
 b=ksQkuY/kDjs4BnrTYzAptcb7fMqeSDI1KFDVNoAVmkhthepIUnULaXdS2+XoqbyFhdtRb4eo8LwzxtTkZa0ePV8vLO0ntIoRW5hN4Vf8n84HjnBbLeYY+LxxYd78oVndYzS6UG0jy+E3AHZGYFNngROcmrJrvvltlqLzTujjoLk=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:01:39 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:01:38 +0000
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
Subject: [PATCH v4 09/36] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Topic: [PATCH v4 09/36] KVM: arm64: gic-v5: Add Arm copyright header
Thread-Index: AQHckIAmQEJbM0ghHUKs1zS/VYfJmw==
Date: Wed, 28 Jan 2026 18:01:38 +0000
Message-ID: <20260128175919.3828384-10-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|AMS0EPF0000019E:EE_|AM8PR08MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: cb5ff089-dce6-40da-bdd4-08de5e976e44
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?BVHcusMOYgOk8k+rHp4LVvitFI3wCStYk5UrtHMnSZUN61TxzdTY08PAFa?=
 =?iso-8859-1?Q?I9JCXm53xv+802YdoNelYN4CZM50VmSSvx2d4L20L+lVdpo7UhRtrvI2LG?=
 =?iso-8859-1?Q?8UWQyvWBSXsq8xTx6TeJ+QYClI0Hk4Tv2FIiytoEFU3nFowtO2hiwpNA8O?=
 =?iso-8859-1?Q?4ZqkKCShGrxTzQmXEfYogRunuIc7PtcomUULZoGxmfGv//pn/aajHJ24xA?=
 =?iso-8859-1?Q?eIhdQQD6IBW3cm4XWnxD5eKW853Ne7iOSK1NzW3a5pNLphtd5luNWYiL6n?=
 =?iso-8859-1?Q?DnnXq2uH5vQ5ZAoycdQA7g9PCx0XNDiQezMzIaMog5lAgS97QrvIuHOiA6?=
 =?iso-8859-1?Q?WW6qDHYHYbU2/iHZCtdaCYMG97ytaF+VHpyAWbnVmhwuvgxnhIoa1I1PFc?=
 =?iso-8859-1?Q?WeUwojin6CwVgGgTF8mzjXShwqt7Fin78BSoA+WgBXpKWmk3dPs/Hrro24?=
 =?iso-8859-1?Q?hYMAMDAp2JdyGJYJWEj/f42yng4ns/QDJkN2lCyG5qfWza8GO4aWFhUxlt?=
 =?iso-8859-1?Q?ymEIiT5DYPO7USOsVtAE03tx+muc+dZcyz97znAwC5DJ2LBRhdn+3KweNM?=
 =?iso-8859-1?Q?88EPLZvg2+oXv2HTrJmOK7pVTIaLtsZjDJzoVoWzGsOfvB/8gEnyBKStfR?=
 =?iso-8859-1?Q?HEye37Q6zv6gMWjLvafak8y3WjMS5aqFNg8rqZ5yHtABWxAf6oYwX5mx9A?=
 =?iso-8859-1?Q?hTKJBZpPgReulLYFBxm5YBFZ299BeFynU3ICmwnNio5LBHN3Yu8Sum9TAE?=
 =?iso-8859-1?Q?/iHpBFOEE5g0117cvd0FO3ew7390vVQKUnqqW0IC5MvyoHzygvP5JkdTqO?=
 =?iso-8859-1?Q?oubteaGgZW5Bdx784XdO4fH6LTSFSDPsn8m7GJ7PV0b0ys5J5ZfjfjyUoD?=
 =?iso-8859-1?Q?5kuRVqXPYx4r50AGmAv+ijqv/OcJm1nW+spGwLc0ZBv56WRKtwjsVNcDE+?=
 =?iso-8859-1?Q?hAiHoN9SUDNeQx6X4mmrDt/9Wk+ZHNLWm4X13OewfYdw1iJWDpzImLP05Y?=
 =?iso-8859-1?Q?RjkkMEiAJvkpJSebqzbFMkJSth7g4lIunsxX87mQ8DE/nsuxmePysQmmnG?=
 =?iso-8859-1?Q?Gh14PYIJGvxH/7jNQShM2HckOu50C45QthGrvZieCj07lH7PeXDQb56i+S?=
 =?iso-8859-1?Q?cYahaEi1aMqcueU5rAHoS/sgH4mapIMGfeLYjQ7+qCXUUpP5v5rhVMb0CV?=
 =?iso-8859-1?Q?0REvE4FIcxyD7zoA9u4aW2dgS5IktW/kUgWPd5iQpfCrfRHscSnkpAa1PX?=
 =?iso-8859-1?Q?8g/baBqIgoLMA3bL7aYyuZpNthSWqUKJMnxovjsUdpmL19D1wYS8n1+AZN?=
 =?iso-8859-1?Q?5XC5llWLWHkd7dJIu9gZ5uXdq+kDQdFg6k7WgpZLt9xNIolVbn+GmF17El?=
 =?iso-8859-1?Q?SkqynA9tgeCj4d9Duuoa9TfOt8hrFaRoyNTJ4/mkIHOGK9bAPlajnsBaBx?=
 =?iso-8859-1?Q?n+BLZiJSaPdCYw5ClUuer+1e2DfE9Pi8P3r3f3aYsy9s4Lfvsz/RZI6rBr?=
 =?iso-8859-1?Q?aJaFIVbBI6e5sqdeTr1T6VQ/0T+Lye4unPgY/zPanm789q5u/oQO0C99K2?=
 =?iso-8859-1?Q?a1Tw1mrFL5aF77KWzAqiHWi0LoWrsjf4TzHUdA5z1Dla1LB8BdYtvr5S76?=
 =?iso-8859-1?Q?RzltKTrLM78sbgL4ZX4smtn2yeFqqHMmUdpSO4t0WZIaj9UYD2HWboTbyn?=
 =?iso-8859-1?Q?l0XkLe88fYivrjv1jqA=3D?=
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
 AMS0EPF0000019E.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e1dcddbb-edd9-49d4-5d39-08de5e9748e7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|14060799003|1800799024|36860700013|82310400026|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?gHzeol+dZE/doaDLw5UNA3FGvseNJ50mPO1h8t68j52g+QZazZPwntOgfB?=
 =?iso-8859-1?Q?mh7mUIb4/l3DOodOqI92fRALdKF4U1pmcZhZQY3r9pDA3zSD0BERExB40t?=
 =?iso-8859-1?Q?dCrHkGoZ6iC6005QEMnmkgadGn0VkZqhgDYQ3z0Yg7ydrtu3PAfz8UWbUl?=
 =?iso-8859-1?Q?MoC6fvzSOQox1aj7L5WUXvVBqWJC1ygCw7IAOGnt1dcPASeUx7ZYOyknY0?=
 =?iso-8859-1?Q?n0Mof7+nRW37pKHTr8yMyAx0X1VhlKWI6pVNAJ3Kt/3mVOrHxdIcLghUu4?=
 =?iso-8859-1?Q?s1ecztwrxlPlC/7YR81DVl8M+iaNcEFlUwDIJsmewJDSBRQYtDdjwzRMuR?=
 =?iso-8859-1?Q?RbP1YRtX8769gq8wO1ARDXX3+GhD7Hg3IDIi4+QmDmUAtKmwogCoODGKGH?=
 =?iso-8859-1?Q?5r/fmPbH6fhi7NP0JjnBWNJrYc1gl0BLISn1FMaQAbACDzGivFzwckdvWI?=
 =?iso-8859-1?Q?3kuXiEfxJDlA9X2rqw5b8FROAjYcfzVoM+ls/AIASlpRUuwTTDgHKq+/Zp?=
 =?iso-8859-1?Q?RNHQiYz2BlKXu/rZzNdWF9ZuRSmQGAN81E6wKcv1kRr6K3yBpxFKR1OXqn?=
 =?iso-8859-1?Q?yS5KpCpKDmdoPLn6fQtyl+jATtkQS42XkifBxthDoJNcWPx9vR2ZpDUfP+?=
 =?iso-8859-1?Q?l/syFmCSTPjOUYj2gKCc9YU6mxxWQtprm+QxMT2JaiUCyQIJSzByaEpTPI?=
 =?iso-8859-1?Q?Bom55e/4Efi+j4pyST7jHcKnMDcH3BPCZUIBD5v949WR+90BoyNPc27G0q?=
 =?iso-8859-1?Q?+dTuIU2Eym8w9KsG5WQKq8UjhqALTxR4rxWRUxF7uESchmhZZEKJGaXjCl?=
 =?iso-8859-1?Q?lGilbtTJB6+hfv8jS+7gUGWNhOSd4GSVcClmnNhHi4bQ1klKEZoqILqWYN?=
 =?iso-8859-1?Q?OdRC7xg3GhN3+mnGzDwiIcL4EfoUCkkvmFMlt4UdUJVSkgiJ68u/ECoX+J?=
 =?iso-8859-1?Q?KFRgOBM0FAwYEa+iG29/VU/J/iZ8x1Icdw7WdYr1SvsId/bPZjDGXrt0O2?=
 =?iso-8859-1?Q?d/sj8R2oONjHJjkgt2kc5wmJdHr0C+MwTTkiQNz4fyH5hg2gKCihjJFHyh?=
 =?iso-8859-1?Q?+3B+F+h06OEMhZC+zQ9Kn5+lnyzWhP2XpfqHDSBp5+UXqxmyX6cOPbrXon?=
 =?iso-8859-1?Q?WkkfhxKe1tFRk2ZsZuQwrjlCg0S2SeleBbOKE3vYLnSfZisrwHW9qUgtRx?=
 =?iso-8859-1?Q?DL7lP4SDd8YIeN2GqKElGFZo/tsoRBIXrpB7oVFiw8XfGzjvyMrdqxRP9H?=
 =?iso-8859-1?Q?/4haNXJWc+djBnqFF9gz75O5EgjHnV7WrL/luERdiDN+YY0ZmcT2R5dKO1?=
 =?iso-8859-1?Q?xlmem3rV0h7Xgx3y83CPfyec4kRyHmDfvftqv4dJYkVWlIsk5ueBd704cE?=
 =?iso-8859-1?Q?jd+mLGcNrzVDpfCf4ZaILVbhCLQkVA84DvRk6N0Dzz3qiJ+6O2rswSiTq2?=
 =?iso-8859-1?Q?8OK+yPBTJgojrFVpyVQiOdQninutX1jvrDGoVLo6Sh2aaZeNTsr9Plqgv9?=
 =?iso-8859-1?Q?5jPFqDyOZUfBpwEWWwVfgOrHSx/sHAJkonsUvHzsiUOut6o4nw9cS14Oie?=
 =?iso-8859-1?Q?qcmbybgOZWdd/LH1/vYKklyy2EvhbtQQbDWqgiWShdGi/I3GXxj9h9cvyO?=
 =?iso-8859-1?Q?0bhHTs38qV5Kr6jj+F1VMTjgxMES2yxPpDH2uwilWk+c2WlXqP8wDj89oT?=
 =?iso-8859-1?Q?bK/J22k8GyoBnbojob18jGYxYv9AqYalprC9sUF9fU3QiUTxdutG54Lblk?=
 =?iso-8859-1?Q?D0rw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(14060799003)(1800799024)(36860700013)(82310400026)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:02:41.5328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb5ff089-dce6-40da-bdd4-08de5e976e44
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF0000019E.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6578
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
	TAGGED_FROM(0.00)[bounces-69375-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid,huawei.com:email];
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
X-Rspamd-Queue-Id: 74FE8A76B7
X-Rspamd-Action: no action

This header was mistakenly omitted during the creation of this
file. Add it now. Better late than never.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 2d3811f4e117..23d0a495d855 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, 2026 Arm Ltd.
+ */
=20
 #include <kvm/arm_vgic.h>
 #include <linux/irqchip/arm-vgic-info.h>
--=20
2.34.1

