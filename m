Return-Path: <kvm+bounces-69396-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IZZO0VTemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69396-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:19:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4361BA7B0F
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 645B1302045C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A54F372B39;
	Wed, 28 Jan 2026 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HpDwN4q+";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="HpDwN4q+"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013001.outbound.protection.outlook.com [40.107.162.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF03E372B32
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.1
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623694; cv=fail; b=WeWHII9feQk21pBwwHESjYtR3BJXHDSq0zXXSxr5pFdkJVZkYR23YddrFMOFhsbn3I43dtA428OV48lGBx0zttXTCjOdzQS8oYj0m6w6hwJ407RbA0BEKfwrxI73QaqDO91OD0Bd/4MfMPOe7otdkRezvBllx1/zuTFO3t0jsJA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623694; c=relaxed/simple;
	bh=9lSe/ilmJ1u6HI9mgIhhIgGRZeCJJJaALwBu87qI4tA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GXyG3932aY0WfukGeTYMw7x7OuYJDyF9Rkd22VTd+f1gVDcqKaZahsiNM2MHGIb61Ry9s9oQ0M3zUoD4HI31Yb6JC1nfW180k3EkIPvUEZlL+bI9/m/EcogAC6pl0Hde8+3hqEgGEZzUlvi5SmKtvsuWLH7pUUPTVf5i8jp1XXs=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HpDwN4q+; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=HpDwN4q+; arc=fail smtp.client-ip=40.107.162.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=W2UD2JzGDnTc3qxhR5utSXhHPHkfuugz/Z1/P6bdqxCaF7eEgpv3mdOuFDFiuS+TEpXaO7O0tBTD3tUwxpY6rdF7fE/MjdawueuVG4EfuMswMCFL5b5JtYUubLWAAxYfGIJmGOWKkSetQCCwieOjulJbKFVbGUZaJf/NcS3fRGU+vtk98hedVYTrMXUqWph3mEdMvW4lGnScdEik6a4zFqdyl3Qz0EtFWn/nHDE+O50pJZDAReBg4OmLdc1clDYhPuJt1EYUSHzx5tXFmzA74fnxJxwwC8zk6erJ5a93NDxhYkZGW4Rq4KRk5ArZhCLifRbmpBILSIkPbBRPg1nfTw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R15zibpGzXswrN1TMbW8bpj6W98zC3G5SQ6IhnYmbg8=;
 b=AjXb1sW5zQ8ouDR4hXVTJLFhqVXsHZWxYHkwhwwNnfJNCIpFub79Bu2hZvqo5CNK79uqamAxaYmE0RkKr66UK6v8+AE91i/5nyBVC6F0+l5JwMUzjfrfsQLwQkTRMelWUyNJ5dMaOtsYiGfeJiprpNWg4I2F83lK/lXnGnoNp1yJXu49JrSGF0SY2GuFqlxJMZ9KikXhoe7REVUUh8fdJ/tL4IoDtaNlaK/PR0QhfV6t6CjRkHk40rChF3teujBf/VBjp1VOnBNfD8Fg9ZuC4E+hRkcNAJXlv3IFTvEN6gHT2Jnpx1NqeMhBLlgb3gwfaLwiwKNEZZRXOJkSXkeorQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R15zibpGzXswrN1TMbW8bpj6W98zC3G5SQ6IhnYmbg8=;
 b=HpDwN4q+if3qWWkc6BDKSiA7gB5N/old6ZoN3nnlek0fOMX/3vHzSpXnHw5c467ecjK5ubhzMCrJs4LRQzJ3IQdnCKltyThC1EJg/0l+ntuLFcO3r1l7IupRBL3Qo5IJJ9Wa/bezSM3/r1QS7bP2A95rtDPZ/5eFfeQ/aQXIvZQ=
Received: from DUZPR01CA0216.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4b4::14) by AS2PR08MB9392.eurprd08.prod.outlook.com
 (2603:10a6:20b:594::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:08:05 +0000
Received: from DB1PEPF000509FD.eurprd03.prod.outlook.com
 (2603:10a6:10:4b4:cafe::26) by DUZPR01CA0216.outlook.office365.com
 (2603:10a6:10:4b4::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:08:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF000509FD.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:08:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zKRv6nCn7ojDeumJzlPu3HRXxzERpv9xD/i7/U8WCqpW5DJPF5zu476cSQweDgYpceoNHtdiDCinNYj4bm9KQXnqQ/Zu2sujNaXngr6pO7u1p1JFCwGbOWndMH+VEfIjSgTG1Oo7C6Lfhv+bIvAC+pEkqdS59HE8QNwlnjRiIyBDyJqKB8k4U8ymMy3CR15LUvE+fkzbgUykZgEfROVxfGvZa0qi5GwOS2O6RPJ0C+nQzekuZWJSnmVo9zSvTHXS50mNoqBilcJTKpf+wq2iZmNsb+SGEXuMwVyro9TlKw6i1k8C31T3Y0jqGcVmtZVqO2n9q6+NazAlkrIc1NtrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R15zibpGzXswrN1TMbW8bpj6W98zC3G5SQ6IhnYmbg8=;
 b=s7bdmsQTZx+Rnosk3+WarqeECX+gT0RWdJZMpElgxYDqo3+N/kqEN9sch0XDqV4GZplsHs27L9CGQcPXT++Vlu1/QSbscFokiazrC66SEab7R6X4TxFC+sxe7MBeAhQ0SaEMJICPa4Ch/P25/ngT7xGB9vCxKaxWkGhwBZXtj500mPxASJU512QcO67KpbO5pEqpPeg1PwL1uYPsLiVHgg92M7l0GxzWqqvmNrNORBOBX97FxON5i/S563Qv82Yxgx6665iv9xmeI4cKJ5yY/J0tN9RQCbtDOpcgYsQxUXrvRvngMVL7IWlu8Bj/3I+6lhudG53Of0J7hGOfR5j33A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R15zibpGzXswrN1TMbW8bpj6W98zC3G5SQ6IhnYmbg8=;
 b=HpDwN4q+if3qWWkc6BDKSiA7gB5N/old6ZoN3nnlek0fOMX/3vHzSpXnHw5c467ecjK5ubhzMCrJs4LRQzJ3IQdnCKltyThC1EJg/0l+ntuLFcO3r1l7IupRBL3Qo5IJJ9Wa/bezSM3/r1QS7bP2A95rtDPZ/5eFfeQ/aQXIvZQ=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:07:02 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:07:02 +0000
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
Subject: [PATCH v4 30/36] KVM: arm64: gic-v5: Introduce kvm_arm_vgic_v5_ops
 and register them
Thread-Topic: [PATCH v4 30/36] KVM: arm64: gic-v5: Introduce
 kvm_arm_vgic_v5_ops and register them
Thread-Index: AQHckIDnHqoPQV42ZEuwWIAl2YqT+A==
Date: Wed, 28 Jan 2026 18:07:02 +0000
Message-ID: <20260128175919.3828384-31-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB1PEPF000509FD:EE_|AS2PR08MB9392:EE_
X-MS-Office365-Filtering-Correlation-Id: b46ad1ea-488e-42bc-8564-08de5e982f65
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?AI3/whQhAb7xIfO1+3eChNLyYQNkxoWaRLay9H8feGJ7tqoeloPipkoQZq?=
 =?iso-8859-1?Q?iunRrG9O3i8rjjNRAfCUz+ZqgVJtzSglFwzg5dGxBWmOqyiwYBiWv0amLR?=
 =?iso-8859-1?Q?tT3Rhhvm0uHrD/H0BNfx2uamjIw2PyoqShlnOiPt8f2SyZUp20E9jGGWbj?=
 =?iso-8859-1?Q?w+YPmItHx04L6LK2h5L70DxY/2fBXH5csgL80HtzV6fUHmog12qQcwxj6E?=
 =?iso-8859-1?Q?FaMXnHt3hRCw7MnQ77D7hDXCgR5d1sLt2PLbrUpB/XqUyqDdfbupqmN/X9?=
 =?iso-8859-1?Q?Z74IaL7k0vIWdUaG3PpMVYlcEbp09JGght2zd4nucZwsZTR1DTKEGGxnz+?=
 =?iso-8859-1?Q?RvyyQ5k2U+x9DFYIg5gOVnREVBU+UhsrJ8mXkJ4yA5q+6intMCe3/rDrca?=
 =?iso-8859-1?Q?s4YEmlKBITdwQIW0Saro9Zt39Q3BzP5jjkKa2vwKEYkFnQHGycDJVEtrz1?=
 =?iso-8859-1?Q?0klDTq0sT/KcDJEPM8wVFfZNMCvY2/QyXSKRIxl3zd+M1v92TA/XX3YDHL?=
 =?iso-8859-1?Q?qQAkdeMVM5E/jzoOsblI+w6tbdwiD0Kxp/e9KIKpECMUn7cQVfZ7V16uYI?=
 =?iso-8859-1?Q?U0wrzN56xUxw3G8dCIiWOu25z5nzHd19EW0af6BdP7NAgqERk9hWLu/Ex8?=
 =?iso-8859-1?Q?EjEOnnB/aSWXKBggwzQ7IhNI5yUSdU4Agj5DnnC0J1Qu/SzSCWOcWvRvhb?=
 =?iso-8859-1?Q?E+yyE9dL+lrgu8xy5uE18ooEo8Ev1ctjYMTaf8mMgaBXS8dDHtAwgasoNV?=
 =?iso-8859-1?Q?87UNGnculHUNeWLPpg3LPjWBs4gMA+Rn6GDKnqQBZe8uajsDrRUszmJHeY?=
 =?iso-8859-1?Q?3SAAzo7LqmeJqivT5JLqoPXvwoJQ+KP7uGfNaJ7iJBvyqiy6qLNYvMgbSY?=
 =?iso-8859-1?Q?BpymjYpoIAxpI1xFdGJFaFnGV5VqGTAv4BiZp2EtMzDZAMe9u3ZAKrsCtJ?=
 =?iso-8859-1?Q?u/lG+VH7ejFVC79fUWafnEn+CkLQD27cRuyI7cgKNvV53AI3B4csGW7+wZ?=
 =?iso-8859-1?Q?b03rmA+rWHmcDVcxuzEbkOQ2HJwgXpJ5DeiFgeG9u1l6nHeg8FIh5e5pk4?=
 =?iso-8859-1?Q?HtRG+zAjfcUVUIn7O4yqrfa8wbMCPjg2rOEM8ZwjpLibzxPqBO+t0X55i7?=
 =?iso-8859-1?Q?LBrypLXeUv51aXnS5cv1UyWcYvJDzKvKOe89D+4S+WGrxKw01e0aEOcAry?=
 =?iso-8859-1?Q?USGzONFdRT/9xTl6rHqj35CGBxhbR8/bZEuSdCjU22pNUvWYgrnKyfmyiX?=
 =?iso-8859-1?Q?WmiTgTunfKoPJKaPC01zuUFBx8B+Qo6lwYUcUPntqezqkQOPfqAgiJtVaW?=
 =?iso-8859-1?Q?Xj/bppU1G0wLHZ04jjd99RsocjF2q91e0YGfcKJP+m+SdHYuyZ5hsdR4EC?=
 =?iso-8859-1?Q?YFRUzieZbsnjDrI/GKGGD4OR798ZllzAFrHyA4k2jUq+6CrKI7TykBKNQm?=
 =?iso-8859-1?Q?oJr/J0babVhOVeqYQHdWn3dHRXPauaP95wmSn1BAj7FID32t7kkUy0Oh/a?=
 =?iso-8859-1?Q?c+XQHiWWY2SybuzPF6djjID4cMqVZe/FN1zjTWydE0BiA6bZAnvGPWCyr5?=
 =?iso-8859-1?Q?84RxNLVus5z99n57a0icOuZ5W7UT4dqVMg3XTVWajspRHQR6Ux7V3Rp/WY?=
 =?iso-8859-1?Q?Kze+jZL1VS/CKSsU6vaezq4yiya4yBr4mnOfg2eF8msIgrbWw3+pix7vZA?=
 =?iso-8859-1?Q?pQ1aMC0W/KKrWsjhiC4=3D?=
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
 DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	42721d71-1c78-4379-678c-08de5e9809e9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|376014|36860700013|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?fr7XeYbbyxpTKZNmHOXz0qULsMPjkKn4bx/VOAA9UbU14WLl6HwcOYsRM2?=
 =?iso-8859-1?Q?+KAim+X1RWp7aKA7QPo9dujTMudB8GYiKJAi3kfVGy2YtP/QHoDbTElk/A?=
 =?iso-8859-1?Q?nqxVq2XMhE+YNkd5+184k8ONVL/lmxe91WyH5XDBg5GJZfAUwC+zbw97dh?=
 =?iso-8859-1?Q?mFg/G7iv88AW5vxhJ7dBExxZtzFBdhL3qWtaJ57Zy70876UM2s3tuiVxNa?=
 =?iso-8859-1?Q?y69B+4+MFiePOq4pJfMdvkC8UTpXYbxpJbt6W5IFL4mDuoIEkS5wq70GBt?=
 =?iso-8859-1?Q?SU0yRoweAjzwe8AE3rcT+tuiU+lhycEmPsA1yBxhtdhB4IpgD7EwBtlldc?=
 =?iso-8859-1?Q?7+S4jsoxqp5Zj/Uipa3XGovEMRarTBRwwEQLZhZeglmmuAP/IbZDJtBohV?=
 =?iso-8859-1?Q?NpiRA3Aw9dV08BMgxlSGYVaZFPTrq6agAYSLhI2eTwMCPfKnDv/1I9MXOF?=
 =?iso-8859-1?Q?p6hoNzpIYZrsy4H7slVVUAslXsoIIYvmrxJ7eBsx3FeQ704BXZgBrwigW2?=
 =?iso-8859-1?Q?QcVWhkbzdfBP7SD2tOZmRIy6D8CAhl6fT/FUXZKcPvZdYeGnK82eQqSiSw?=
 =?iso-8859-1?Q?IuryeSwK9/wihbZfVJ33REzyvKurWAKwfGEHk4RLPRf2AIvDPvi7l2KxVt?=
 =?iso-8859-1?Q?B/ajL06nr5jlILO4B6qkFkc2dUfZmNroA/6s1xDO15w1OTq+Hbr8BHhhJp?=
 =?iso-8859-1?Q?Fa/jgHKrXRipJxtm5gjetj7eLTQpwUpW8aeixvY3CGGezqJomm6nyrUddp?=
 =?iso-8859-1?Q?rIDdGExz+HoJCLzJ4iExCJEougBpr5dv41cez91iUNE5jnWGvgWCg92+a4?=
 =?iso-8859-1?Q?6Ln9Z8EmA18j4PEPP+mRe/XUGwbUiEcEJUDmrWJOluneqpOhxdpdU0Q/4i?=
 =?iso-8859-1?Q?ZC9zx+gVFz0IxL3cLnJCKmOVdNUzxkEdlBy3D6E7Ax27Vd4pCR22rnZDy/?=
 =?iso-8859-1?Q?dCsbwxDZnx6I/DE69dVYnJ3B47HERbiQWjVR/nI2K/pRdTtRFmAJu7irW7?=
 =?iso-8859-1?Q?5z2PL0NZH3hjwmo2AESd0lLjq6lMm8DQmzr0Y3avrRKxGPGZM+istjV2bw?=
 =?iso-8859-1?Q?p0Q6NXHdPa+LT2r35LtlDLhHOhSfkz2modzQZ9gypdGokp0rWAHQ5gnzlD?=
 =?iso-8859-1?Q?ir7N1Br0V68BkwVIajLDcKkL3bZgLDQDFpZxogGsyof7y4tBgJlcv//t0N?=
 =?iso-8859-1?Q?4adA23T8OG1trH+dEhYsHkwnL2PWRm1MOHQhXRAhE66DOLulfFVJTKfA44?=
 =?iso-8859-1?Q?F4m8LVp8jTcJAjWOuHWHvTYWVKYKQZix7UBcMYarrhNsbUiyxJU3u9lRwk?=
 =?iso-8859-1?Q?HdH2Vg7D8PHsE6hFFgstz7Q07wiwwXsJ7W4XJOPUsTqf75tCWls2uQN0HP?=
 =?iso-8859-1?Q?ECPYsFUDY2BNbb+rKTlalTpUiji7SoJlALrtBVjrGSvcMa2NBotqX4BBB0?=
 =?iso-8859-1?Q?bYypFtugp3W9OqrC8mpGA5Tr3LgYcspEJXy4D5GEVC4LUPRgYol6sTWhnw?=
 =?iso-8859-1?Q?X+YZBzeiybk+ATlhno9DGXIKZu8kyDDupl1JAE9j/MHkiK07gMmyLWrubd?=
 =?iso-8859-1?Q?H9Ut/afdIGGoDclk9t3g72FzgBUg7APeyjTe+6vJ2oKXrjsTbWebGd+sY8?=
 =?iso-8859-1?Q?csUytsDQcpcbH3wRwR5psQetSXrY44SeIMVrAM/BU71HjF+JkprIZ6Y7v0?=
 =?iso-8859-1?Q?LoiHa1Xsc38DXYf408NHM5gU0A8cEN55pYmBW4ZjVvfEEUInbac+78Nxjh?=
 =?iso-8859-1?Q?GQSA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(376014)(36860700013)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:08:05.5434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b46ad1ea-488e-42bc-8564-08de5e982f65
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF000509FD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9392
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
	TAGGED_FROM(0.00)[bounces-69396-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,huawei.com:email];
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
X-Rspamd-Queue-Id: 4361BA7B0F
X-Rspamd-Action: no action

Only the KVM_DEV_ARM_VGIC_GRP_CTRL->KVM_DEV_ARM_VGIC_CTRL_INIT op is
currently supported. All other ops are stubbed out.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 74 +++++++++++++++++++++++++++
 include/linux/kvm_host.h              |  1 +
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vg=
ic-kvm-device.c
index b12ba99a423e..772da54c1518 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -336,6 +336,10 @@ int kvm_register_vgic_device(unsigned long type)
 			break;
 		ret =3D kvm_vgic_register_its_device();
 		break;
+	case KVM_DEV_TYPE_ARM_VGIC_V5:
+		ret =3D kvm_register_device_ops(&kvm_arm_vgic_v5_ops,
+					      KVM_DEV_TYPE_ARM_VGIC_V5);
+		break;
 	}
=20
 	return ret;
@@ -715,3 +719,73 @@ struct kvm_device_ops kvm_arm_vgic_v3_ops =3D {
 	.get_attr =3D vgic_v3_get_attr,
 	.has_attr =3D vgic_v3_has_attr,
 };
+
+static int vgic_v5_set_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_set_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+
+}
+
+static int vgic_v5_get_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return vgic_get_common_attr(dev, attr);
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+static int vgic_v5_has_attr(struct kvm_device *dev,
+			    struct kvm_device_attr *attr)
+{
+	switch (attr->group) {
+	case KVM_DEV_ARM_VGIC_GRP_ADDR:
+	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
+	case KVM_DEV_ARM_VGIC_GRP_NR_IRQS:
+		return -ENXIO;
+	case KVM_DEV_ARM_VGIC_GRP_CTRL:
+		switch (attr->attr) {
+		case KVM_DEV_ARM_VGIC_CTRL_INIT:
+			return 0;
+		default:
+			return -ENXIO;
+		}
+	default:
+		return -ENXIO;
+	}
+}
+
+struct kvm_device_ops kvm_arm_vgic_v5_ops =3D {
+	.name =3D "kvm-arm-vgic-v5",
+	.create =3D vgic_create,
+	.destroy =3D vgic_destroy,
+	.set_attr =3D vgic_v5_set_attr,
+	.get_attr =3D vgic_v5_get_attr,
+	.has_attr =3D vgic_v5_has_attr,
+};
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..d6082f06ccae 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2368,6 +2368,7 @@ void kvm_unregister_device_ops(u32 type);
 extern struct kvm_device_ops kvm_mpic_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v2_ops;
 extern struct kvm_device_ops kvm_arm_vgic_v3_ops;
+extern struct kvm_device_ops kvm_arm_vgic_v5_ops;
=20
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
=20
--=20
2.34.1

