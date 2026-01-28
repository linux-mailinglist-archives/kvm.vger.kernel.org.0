Return-Path: <kvm+bounces-69389-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ILhIIBRemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69389-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:12:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 493DCA7907
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:12:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8198E305D693
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A66372B45;
	Wed, 28 Jan 2026 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KG+zgnAh";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KG+zgnAh"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013066.outbound.protection.outlook.com [40.107.162.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B06A37416A
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.66
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623586; cv=fail; b=IH3tmc9isqC7O5TL8IZJ7QtOG+kVe3r13PExt0pnNFhkMS1xTRCD9kRrLS7LKaD+o0PlzyGbsfP47QV6s8ryOsBTs5v1b2SPweIfgLPZRN5Td5+UfP/vkz4H8qRWiNShMXZ9Ot0gyBzIsDgxEhK3i0i2pHtXX1XmPoKgr+lJ3OI=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623586; c=relaxed/simple;
	bh=UpTyBFGIU4i/IiPvTH6nI/guLk9VBS1w15x+5idVJIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SiiNKHHopsonKeNb4KQQ8oPUqjM6VPSBe+J7/mAyaw3JUaRrlqR1tQn/Cd4ry+eYB2YweV/PylCEm91JbvDGyUBK8x2IECU7AefaYpPk4s1YuFuo1AmDDRB5WlMM70oo0laUKD/LAdhhLk52DBNQT8EaIQbMhz2xzZ52tE6NpxM=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KG+zgnAh; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KG+zgnAh; arc=fail smtp.client-ip=40.107.162.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=GaZ1kjE2Kg1R8Nowow5GUE5vjy6KfAo8L8mgSRNOu4+DcKgvmCRIld9E5y0t1CFQ1GY5uhStEf6rjNn0Aw+am7dpylWMqwwtbSeTUZr/YpR5LF0qZ5ilAaaXQG1RyUAm+XmK3APFUydhzn3son4sIEnI4lo06zAwR4hRijfAOQaT7+48KYKP9lYOYx0O5ESEzaEE67OccpAilo/hBPRac2gyThlxIx1duzq8RWH58qkMb4CKZIMOc7GsODdMnYktYeRDAQRgEaF20EIG9gNIqn0SgetqDcIHinwY9QRNFtYRQllmVDj3lZBdW25MPR/U+3299a4qmUBLFfinT1QRcg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgeBrZCqS9NgWRtE9JUH2/VU+Y8cqPVsrxYGCU3fnD0=;
 b=NcOVS0fU8Stl1VOXVFBS5JIcV9Rtcim8SiR3TIFWm6pOrF4kNDNObetxzt6IIcUQnPEvux3wObz0Vs6YBhwp/YCyNjfIhPIRHzJbJreM13cdxKztx9KJF1yDfYL+nU/2hGV+kykcfOSgwyRI+V7wXnhIfIXYjJ7k7gQ3ApX40XCoo9UiaSD8pEkGJRZ8MNTJiaws6J7ko5HFFYKBw1hvAunv/qzNk4Y/YAQnhRRFq9T+evjYnGzS6MS21a7WUHgH0FWW1m10tzfljMI4g4FPBDIsBXr/wYfjMcJ9/O53uRP5KHdPeee9b0YTsZPlJ9UNzxVyEhJK6l3iqG+ponHcDw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgeBrZCqS9NgWRtE9JUH2/VU+Y8cqPVsrxYGCU3fnD0=;
 b=KG+zgnAhKSfYdUYvcfAm/W7QNj1uw6AHIN7x5fU00bn8Hk/4IMGu6AWc8RPRD8SwougOJundZi0hpmRnQ14f5YDCsfh1/KC9yaabPNFdKZmI1PGBE63L81GU4uIeQrmPRzCiN6ZUZkbOBzMGIz0qjvmRuwmUH/vZwRu5KHP5TMA=
Received: from DU7PR01CA0035.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:50e::16) by PR3PR08MB5706.eurprd08.prod.outlook.com
 (2603:10a6:102:80::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:06:18 +0000
Received: from DB5PEPF00014B8A.eurprd02.prod.outlook.com
 (2603:10a6:10:50e:cafe::50) by DU7PR01CA0035.outlook.office365.com
 (2603:10a6:10:50e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:06:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB5PEPF00014B8A.mail.protection.outlook.com (10.167.8.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:06:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=upi4ZvbwGFqoIx/+kO6F4Ge3jEPgZctyHyKIqQWsU5LAhcICrJKuQyRgGO8HAr9ZaoikjqQHS27zGnFeKzDnho08fGfDKbhaptl6J7Y1Issq6jJAu0/6XMJahaylvZ6ofjavA5Zjb4xb1ib1RvPT/MT9UyewmBNr0cBFdUuilDdwaSMN0f0PnS9c4D2qK2IXwHVpASvMR7t/D4Zqt/R/fXs+asO2mUaWrl3oq0t0r+27O+XR927/gkBoiTOAQTgg+DcLBqrNKI1BxgDXlQZu0Q5+RA8JK+jGLcUMiu2tPQsKbSqco70lKTQmbkk6vOTJ+YSc4elw25dRULSASf7MtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FgeBrZCqS9NgWRtE9JUH2/VU+Y8cqPVsrxYGCU3fnD0=;
 b=m6OozaqmZLDquM2JBTOZmH6E93NLsjbb/343W36dMmziLrgyscnuEH1VN/4f25/KxGgdLk0pfBlzCEAjpiRrQjCm0r168VpytjNdpvREn4hWssuJ682bzpqhWsR002ZsXz8alGYR2KZRhUe4hPNCSGfUG0xEFf22WPAHEws4DfAXBIUrYvdK45rRar8AVn8MnW52a/Xp/svJlRMVw2CGvXUNwVPBt/5if5Xsexy/2vDvGJGBXNF5mSfpjr6VzJIDZ2yjRhPcNGI3b4ixQqQ6rEvDWJte5lgneOkxukeZ7TGy+xJZbQIOwEHuHLmxHgQhF3OmHL0Qqds2I/A6rtX3tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FgeBrZCqS9NgWRtE9JUH2/VU+Y8cqPVsrxYGCU3fnD0=;
 b=KG+zgnAhKSfYdUYvcfAm/W7QNj1uw6AHIN7x5fU00bn8Hk/4IMGu6AWc8RPRD8SwougOJundZi0hpmRnQ14f5YDCsfh1/KC9yaabPNFdKZmI1PGBE63L81GU4uIeQrmPRzCiN6ZUZkbOBzMGIz0qjvmRuwmUH/vZwRu5KHP5TMA=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:05:14 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:05:14 +0000
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
Subject: [PATCH v4 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts with
 KVM_IRQ_LINE
Thread-Topic: [PATCH v4 23/36] KVM: arm64: gic-v5: Support GICv5 interrupts
 with KVM_IRQ_LINE
Thread-Index: AQHckICnxbCCRJ4Dp0CLD9wVOL1G4Q==
Date: Wed, 28 Jan 2026 18:05:14 +0000
Message-ID: <20260128175919.3828384-24-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DB5PEPF00014B8A:EE_|PR3PR08MB5706:EE_
X-MS-Office365-Filtering-Correlation-Id: 424998ce-1faf-4243-d94d-08de5e97ef07
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?S+YTRHRASM6JXwxwVQ9wXeKndn56F8tJj1jct6Xi7m2Jk9DvfUydtG4aa8?=
 =?iso-8859-1?Q?B+54/ti5K5+IZt47fj+NKvLJLDOK3v7pKsglWAtkNUpPE98BiDKrJ/Oil5?=
 =?iso-8859-1?Q?mB8O48pBCXnwRu8347jvOMn1j1S9qq8cCzDvuWvbX42XLqWuOSovOkJS02?=
 =?iso-8859-1?Q?GnAebSsRTrm9+nFfG5hjRzH79vmfCohNzqoLN6KXsDoB/FAZ1sLeoRrD+y?=
 =?iso-8859-1?Q?kyvZxV0g9oL4y8UGRxXlPgMs/wR78aNh/T21+mEV1nqNwkGoh3iDgYVKsY?=
 =?iso-8859-1?Q?1C1fIHA2C+RC3AlmF1EvzOL+TKSQft3frCxVt9K+Mn+8C+lJJQ9+ZfPIY9?=
 =?iso-8859-1?Q?HpG1HM3l6U3YKFSEwJ8OEA7ZMRVgCh+ljhxwkJT4Qe4BtCrIzZehP88z3i?=
 =?iso-8859-1?Q?uhVXpyCXPxB9mNXEUJdKkoFZrz0h0NHb1GqmzGrdCyULnON76VT5BUdXwh?=
 =?iso-8859-1?Q?R4ut/Yn3Z+lWAbnmJhGU/seiRjN9XsoMaTpNIcBmzu80KE8Ku7iOJ5+Pji?=
 =?iso-8859-1?Q?a0j5n9+DNbKjNX7FpOzbw1D5FD2pCshP0jWOWY+j2qzTgXXoKthgkpCTs6?=
 =?iso-8859-1?Q?Hsn0xmwkvdFcRxCNygynTfQBkw4rm8yVHft14nDln3FC45fGJDAAPXT0Lz?=
 =?iso-8859-1?Q?WjFaty18jh8veFrmL6RMhpmnxa/bQPg9WkZVSmkpt7f8Wyp7Lq+TdyPyp2?=
 =?iso-8859-1?Q?vFFY+3q3xrlT3UzbYvPhYdp7QU+YoD6IA4kA/Tk4xnGODxCsFYgShs9sfG?=
 =?iso-8859-1?Q?Z5BqEvNBGgvSE6I0WhET1hZWzru8EYnOjWFhMHHKvtaR9vaE4Qn4Thgzpb?=
 =?iso-8859-1?Q?W7Kzrv8gfaRLrZ26Hwjc5AidTa8qo0amvLgIv5b3epBdIiy8iQ28qcgZnH?=
 =?iso-8859-1?Q?ed1a5hRKhPRLmwSM1w6voB9AhKWby/xD3jQZZYD8DPmIyVbZQFvITYqxVk?=
 =?iso-8859-1?Q?wnIfvjna2Itc7XiyoAgtI+NcmXzXwWnYdywr+kAMcD3ruDoksagzJQNjZd?=
 =?iso-8859-1?Q?wZmrhB33G0vculTaBlYt2qdIl8xpo7KfBm+3IyV50NPYgbWNq8j5NYk63Z?=
 =?iso-8859-1?Q?M3aLI97R5cf09/H1cwaAZZHI5Rf8m9zde56qeoykk+TnisBDiRhC5jOk3e?=
 =?iso-8859-1?Q?QdUdzBZvT9I5roPK/PacPblqxNI1QBxOHEFNQ/ZqYuI+tUPMXjjfh13zR1?=
 =?iso-8859-1?Q?qbQf2+pMmKBCLsfGYb7Hcf3Tz9p9YRY9UqU1Oe+1do61nlIDllXwgwUoM4?=
 =?iso-8859-1?Q?WFhkQX21pFlQsA+WDyTLH1+HakWUGU4RYCX3mameGDXuX/tgDvNSyxxfWa?=
 =?iso-8859-1?Q?AeNLsEJfzY/df0RyU46rqO8hkvTdUZW0bbBInBoxlPfRsW9r1fVpy0G49m?=
 =?iso-8859-1?Q?WAX1Ro0cSpCdoao0gv9Hh7BA5HkeHUc6mTXh+TEc5U4Xe60RZ/9Pr9HMhH?=
 =?iso-8859-1?Q?pWTL4jIisQcKVwwbqUxwUPCP57iE6AD/yXtby1cB8Vz0if5tiaOG7bkfMj?=
 =?iso-8859-1?Q?cX59CT4Qnz/aDf77Hnr4tw4vtn+TeEWnVN8rMgL6Vu2iluaDwOd6UhiboQ?=
 =?iso-8859-1?Q?h/Z9IaV6BLCpIP1+JzANgFR15yLkPsW2KYuQUqgv71VhyBAxcg9XhGAThf?=
 =?iso-8859-1?Q?2CBAOyPrp+npqzHl+u31Adgg38vVq3Cw8I58Pw4ika2VnantQ0anarP4DA?=
 =?iso-8859-1?Q?g7ioMM5r7N5n64tKviU=3D?=
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
 DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1bf2588a-5647-42ba-48ca-08de5e97c985
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|36860700013|82310400026|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?uroi9GsctJM1Bq2g93rUViXkmj1IyyEIrhWnx8KhGcZZbJpbq/c6+WLK7l?=
 =?iso-8859-1?Q?ipFqdW4NCTzIygh/qSnArmQ/QyTfUuHayMzdxllMMIOfRFn4sFrvmWD/M7?=
 =?iso-8859-1?Q?r5uCopIxvc1h0lfSe/t9832kC4CMTJjTLRzMhR43EfiV+VgdM1uzwWOhv+?=
 =?iso-8859-1?Q?HcpWY55t3VN0RoPQsQC5hpBSWCkjv4fUBu+thtgmwDkRz0i/URj+vkfYWv?=
 =?iso-8859-1?Q?nyUuPB6lxIGhvyOTKCy8QVrxdE2lNGXry5zIB4DB/NHVB6cmkCLpIYX3CG?=
 =?iso-8859-1?Q?cC7N3dA5i7S0cJWdTPWznUS++V8rTO3oXuybveTtROgHLw8a2uruFoTCtj?=
 =?iso-8859-1?Q?acBUjQK9IkatWemueyQem0C49VNHPttyHc57Vt6+ZLt/CIoNmlC9CRkovA?=
 =?iso-8859-1?Q?+ceZBiTm4i8UZ0b7VLwsTnJ9Nt7Gc9OYsNiZUMVw1mGErzB76C+jNGP1nu?=
 =?iso-8859-1?Q?DBrJxhBdTglA4RUub8J5MrKyOOGv1uGuAM2RNHlrMYmjLW6rVSZhKmDx+h?=
 =?iso-8859-1?Q?gWQ1tp6ornTIGF/I2p+CHNCEaE0ZBidKRGihwymZGNKhU9rj6fKHNiua9H?=
 =?iso-8859-1?Q?0oys8GZ8o7IkzuqVCUw8Az4HlGg2a3zo9+5A41OTkC86iSX8njEIVCNl5Z?=
 =?iso-8859-1?Q?VkcmnRogr3Ke9AYNZlPO5OrFRq8rGjiH4M9Ux7sus+B5X+k5fjVW2yFOnx?=
 =?iso-8859-1?Q?niJy68m74BJsIMk4TIKq7+kSXGCxacdsFhGG703H+pmu499eTlDJNE4E9d?=
 =?iso-8859-1?Q?eIQNzX8QM/1N4mm4df4UzJLLNfo5q5SK1fFq03OdtAlgg94hj/6pfT5+GH?=
 =?iso-8859-1?Q?E1TFF5lXj03TX8KmKWv/ymN4UB1QkH8SFYM0hw+kUW4e65CpFrhYDLnx4D?=
 =?iso-8859-1?Q?ejt50lQM1okVKbsSkDBwM66HVnsjpPwuEk2/57FmcFc6ohnH3Dk7NY3Mzs?=
 =?iso-8859-1?Q?1gNGRu72NPju97mzqskoFz+iY/ayP7CiJVROerwbDgxd1QfKrdbBl+DefQ?=
 =?iso-8859-1?Q?fMsoHvkT5Vcflvau29wUndoGgLt9CPh/ARbsBgjS2kpI4sXz4wZGjEvf2a?=
 =?iso-8859-1?Q?XH2fMWZMnQYgJfx6hSU2Ds2U5h4G0+f857uw9cBn/7ITXbvHEi+5aisTOP?=
 =?iso-8859-1?Q?+wsVcwY1+o36z1DO9SWNjSik/3NecMoeF+bvp4Er1unlOeEiF1Ab14RYQA?=
 =?iso-8859-1?Q?VK60subkFs4qGHL/SsYJO7vEMJFL6CvLg1abm4bQMaKTWdxv5dgiHmTvhq?=
 =?iso-8859-1?Q?NdG4fD5uLTV0UMdhFCpVNDQNtqisCIEhLFt7lvmu36t0HfK4QuCwc5aP1a?=
 =?iso-8859-1?Q?9AWthQCdh/rU+FfhCsGRhBtKTEaTmwnLt6my+lanWpWKzLWaySfl5lde/s?=
 =?iso-8859-1?Q?pkZx907D6dOdFjhizmjKRQZb30ZepWwFmYckgnKSS+W9rCVHU3aVLxgwBd?=
 =?iso-8859-1?Q?jFQ5hSMScpKoHhE3c/9SexFnFfo/1te7rZa/ALRFOQAMKn/Hm/FpgVqeJm?=
 =?iso-8859-1?Q?sVdNdvfOyAbVVXW4VwoJES7zMDwhpGGrn5NLp1gAkcEK6IGKJTNrVObNqg?=
 =?iso-8859-1?Q?VUXGmmIAlQUFqjGCZuv/neCKllkrzSnk4bVcfouGRvlq4cmnOT6sWOrMg5?=
 =?iso-8859-1?Q?Uc4E2ByUgbQfTLLE3lNLm5en6ioSsj8seC5HsswelpO/6LL4l9kIWJ38nL?=
 =?iso-8859-1?Q?mBZgfeUnwpYq2fsZeQ5tve6kT7I3jgx4KVLgJg+pcFKCmEsk1A2lD/27dw?=
 =?iso-8859-1?Q?Qlig=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(36860700013)(82310400026)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:06:17.5315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 424998ce-1faf-4243-d94d-08de5e97ef07
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB5PEPF00014B8A.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5706
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69389-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 493DCA7907
X-Rspamd-Action: no action

Interrupts under GICv5 look quite different to those from older Arm
GICs. Specifically, the type is encoded in the top bits of the
interrupt ID.

Extend KVM_IRQ_LINE to cope with GICv5 PPIs and SPIs. The requires
subtly changing the KVM_IRQ_LINE API for GICv5 guests. For older Arm
GICs, PPIs had to be in the range of 16-31, and SPIs had to be
32-1019, but this no longer holds true for GICv5. Instead, for a GICv5
guest support PPIs in the range of 0-127, and SPIs in the range
0-65535. The documentation is updated accordingly.

The SPI range doesn't cover the full SPI range that a GICv5 system can
potentially cope with (GICv5 provides up to 24-bits of SPI ID space,
and we only have 16 bits to work with in KVM_IRQ_LINE). However, 65k
SPIs is more than would be reasonably expected on systems for years to
come.

In order to use vgic_is_v5(), the kvm/arm_vgic.h header is added to
kvm/arm.c.

Note: As the GICv5 KVM implementation currently doesn't support
injecting SPIs attempts to do so will fail. This restriction will by
lifted as the GICv5 KVM support evolves.

Co-authored-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 Documentation/virt/kvm/api.rst |  6 ++++--
 arch/arm64/kvm/arm.c           | 22 +++++++++++++++++++---
 arch/arm64/kvm/vgic/vgic.c     |  4 ++++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index 01a3abef8abb..460a5511ebce 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -907,10 +907,12 @@ The irq_type field has the following values:
 - KVM_ARM_IRQ_TYPE_CPU:
 	       out-of-kernel GIC: irq_id 0 is IRQ, irq_id 1 is FIQ
 - KVM_ARM_IRQ_TYPE_SPI:
-	       in-kernel GIC: SPI, irq_id between 32 and 1019 (incl.)
+	       in-kernel GICv2/GICv3: SPI, irq_id between 32 and 1019 (incl.)
                (the vcpu_index field is ignored)
+	       in-kernel GICv5: SPI, irq_id between 0 and 65535 (incl.)
 - KVM_ARM_IRQ_TYPE_PPI:
-	       in-kernel GIC: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv2/GICv3: PPI, irq_id between 16 and 31 (incl.)
+	       in-kernel GICv5: PPI, irq_id between 0 and 127 (incl.)
=20
 (The irq_id field thus corresponds nicely to the IRQ ID in the ARM GIC spe=
cs)
=20
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f9458409d50a..08e255cabdbc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -44,6 +44,9 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_vgic.h>
+
+#include <linux/irqchip/arm-gic-v5.h>
=20
 #include "sys_regs.h"
=20
@@ -1431,16 +1434,29 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct k=
vm_irq_level *irq_level,
 		if (!vcpu)
 			return -EINVAL;
=20
-		if (irq_num < VGIC_NR_SGIS || irq_num >=3D VGIC_NR_PRIVATE_IRQS)
+		if (vgic_is_v5(kvm)) {
+			if (irq_num >=3D VGIC_V5_NR_PRIVATE_IRQS)
+				return -EINVAL;
+
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_PPI);
+		} else if (irq_num < VGIC_NR_SGIS ||
+			   irq_num >=3D VGIC_NR_PRIVATE_IRQS) {
 			return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, vcpu, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
=20
-		if (irq_num < VGIC_NR_PRIVATE_IRQS)
-			return -EINVAL;
+		if (vgic_is_v5(kvm)) {
+			/* Build a GICv5-style IntID here */
+			irq_num |=3D FIELD_PREP(GICV5_HWIRQ_TYPE, GICV5_HWIRQ_TYPE_SPI);
+		} else {
+			if (irq_num < VGIC_NR_PRIVATE_IRQS)
+				return -EINVAL;
+		}
=20
 		return kvm_vgic_inject_irq(kvm, NULL, irq_num, level, NULL);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index cd45e5db03d4..58a3fc66f2ce 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -86,6 +86,10 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u3=
2 intid)
  */
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid)
 {
+	/* Non-private IRQs are not yet implemented for GICv5 */
+	if (vgic_is_v5(kvm))
+		return NULL;
+
 	/* SPIs */
 	if (intid >=3D VGIC_NR_PRIVATE_IRQS &&
 	    intid < (kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS)) {
--=20
2.34.1

