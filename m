Return-Path: <kvm+bounces-69384-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SPzxD09Qemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69384-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:07:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF7AA778D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A25C303FA93
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC98C27FD4A;
	Wed, 28 Jan 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lTLIwW9f";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lTLIwW9f"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011058.outbound.protection.outlook.com [52.101.70.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FCA1B4257
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.58
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623505; cv=fail; b=HxN2SSNtLVt0oi+O26Gqpnz8oaYhN4EOEj+oW0TVoMqnEZas+Jv8QitC1WV8iBiKldL3kQfFIeLsdyHDK6mvsR0p6lpdXv/i+swTZy0A9JTd52KIqNHbtnmE3NdpKH/V8q1v44Q7Gmrhc7aflEe511IeIySPq9NVkLahQ13HvMQ=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623505; c=relaxed/simple;
	bh=WehF22nVYkZ6336HaCdWuryA/A4Kh6X7ul5ISYbf42w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZG+mkxjwn8d3JAKkkPxEf/lQ+lJVzsIDwKfvGLi2xbg1KCJ6fdluKGHR4SLMUGAR2J6SksBfXWcLyLc25dpKeKaiC9FnELgAqytEBxrkjxZ+nyhdvikTW6wvxRAeIWV493NsSyrZu2fjq7gI5cRhYGaFGTb3/XITTlkX9TFKP+o=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lTLIwW9f; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lTLIwW9f; arc=fail smtp.client-ip=52.101.70.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=h0Rvw+fv4hVd2n2lEBzqj0nez88bs9FsjT0VETAykZcqItvkWwOFS9PocvB2kiiqb753nFOepIznqYPoVg4KHL4Q+W+DhVAiboLnYY8ffBu1VkwT50y0Ti1GDdps0cQPXQLAehZHcg1mEQ51dlD1sXRTCPuPTzR0Ns607yJOiRuHaHCdgkd495JMLVNAeEMHG+0j8JxLJauwYJmTtjA9YpDRfvlpcgDVXbK82RdjgkkPvdaNMtvEmkRFaN3DoFXL01faMANB3544PP39Cj8TS3vo9Q+7hdfafN1bGbjnrL3GTsPEsEa+RYGAhDCozh48hAeWuWe12u+oP43YiQdA/Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsbsAyNtSo7s/njuaigZimjGbc5FxEprI9AZdWM8RrQ=;
 b=xTZHQZx1rwJNunXU27DCoO79GhOuw8iM/3arEboi6sdBdGQwIkautY6uFnc6SU+RUplAiqOH53wYAHb4Hap+XiNXZh/hTU4thRQXf62VMTBIz0IS96YjX1J/FNapL4bI57N/oyf7usWG6ucQZaUyiq62cF1n/mV/c6tAtCRq0rFw8Qyw5I0TV+a61LObpfbDCzR74ZiX2quGFBde6mq/cUK6L1LC1aYBqSE0jvUML2A6cwzitncjvJAtm6Xr/FkiH55KHfPJkouN86carEfVxhIzfMzmS67Bt/49qw9xVRJYliQW6B8HxHTqUP3I3qG8ShY4+8Jo6Ug+XeN/z4nJmw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsbsAyNtSo7s/njuaigZimjGbc5FxEprI9AZdWM8RrQ=;
 b=lTLIwW9ffjrLjV00JePw8yLJTfKjeat0341zc6KvhACk2kBCgUjr8EgUcqqJzZProX1q1K2xi+NBxHAr1PBNSp91kmzDiPW5d8V6pvbjXMws7lNG89SYduiscZN8eXzrYIOgG9q/aj84rmaAffri6xcxPLIryorXacN2gkJAFPM=
Received: from AS4P190CA0068.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:656::28)
 by AM0PR08MB5410.eurprd08.prod.outlook.com (2603:10a6:208:182::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 18:04:59 +0000
Received: from AM3PEPF0000A799.eurprd04.prod.outlook.com
 (2603:10a6:20b:656:cafe::c0) by AS4P190CA0068.outlook.office365.com
 (2603:10a6:20b:656::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Wed,
 28 Jan 2026 18:04:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A799.mail.protection.outlook.com (10.167.16.104) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3
 via Frontend Transport; Wed, 28 Jan 2026 18:04:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DnhLLylCXCE36oD70IOR7cQsPEL7IWsN2g+6larJQPrfgLUg13yJxJM9bE5r3Hn3QLm0wFKP7gv3Esb4uqphheJ7ZZgzaK4ocvN+1NIZ03BYTM97P7MWBCdVRAdBQXkQta79e8+9AS1nCHzcPyzHXcl2/8Kza5yIbTwV5Carf7zl148F2mTYkduhgXfbhzu/dUC540EHW7oAHVXXETWwgozs1yoB03tvC28evlxowjYejnZgAiuXGrVOH7dcS1svM1ivjBP8cjL8z1ownUJyV7sSf1kTMCUGhEsEBTHmqvvke/0Tp+r8z6MxB4A5s5Z8Wd91XXoFUdCTwC5ISnJ4gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsbsAyNtSo7s/njuaigZimjGbc5FxEprI9AZdWM8RrQ=;
 b=OwlLuvADyJXSgR6WcHrPiCKoMhATbE9FLxWRECua60wnGF8ySkVMvaIK+VJKgtWNE4tl7DcKQEI+tP/M2iC9ATDdjUBNDwLrWzsIqLhQJA5i7jLc0LuoneLEo8GUxaLp5+UMwsJps9wVrxpIADujYHt7sldt/vspXO3wvBxbF1bthU/0JnVnN8NJoA6l5yxsouJlDbucro7QudZ09BBeuT6fwGo2VDGf6PnFgeets8vsH9CfZsEd4rTpifJ2l0XzbMkzvXTyhkY63Jhc5yBgqwyX3br53HPw8AkDV4yNL7hRWCnFz8Md1hA7/xVQt+np/5MjNUKKmG8GpQChDnLRDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hsbsAyNtSo7s/njuaigZimjGbc5FxEprI9AZdWM8RrQ=;
 b=lTLIwW9ffjrLjV00JePw8yLJTfKjeat0341zc6KvhACk2kBCgUjr8EgUcqqJzZProX1q1K2xi+NBxHAr1PBNSp91kmzDiPW5d8V6pvbjXMws7lNG89SYduiscZN8eXzrYIOgG9q/aj84rmaAffri6xcxPLIryorXacN2gkJAFPM=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by DB9PR08MB8483.eurprd08.prod.outlook.com (2603:10a6:10:3d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Wed, 28 Jan
 2026 18:03:57 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:03:57 +0000
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
Subject: [PATCH v4 18/36] KVM: arm64: gic: Introduce queue_irq_unlock to
 irq_ops
Thread-Topic: [PATCH v4 18/36] KVM: arm64: gic: Introduce queue_irq_unlock to
 irq_ops
Thread-Index: AQHckIB5ffTHwZUXpUi5k96sPYpAZA==
Date: Wed, 28 Jan 2026 18:03:57 +0000
Message-ID: <20260128175919.3828384-19-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|DB9PR08MB8483:EE_|AM3PEPF0000A799:EE_|AM0PR08MB5410:EE_
X-MS-Office365-Filtering-Correlation-Id: b8faf9bc-aa5e-481a-09d8-08de5e97c0b2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?B0nenjZGEvZrbRUROGKZZTsJWW3WMDaxM5V/5YxnHEa8DSUg9lPv8hgVRk?=
 =?iso-8859-1?Q?S03GEu82EzteEYZ49tGF4u/23dGLYGcMikQgredj9IihAgRTJdI4e92WWI?=
 =?iso-8859-1?Q?4xJpyDz1W/8LA9ncoCmx+wBZ3i6HfI2Ez+9LX8l811PmztWFFS4DYPPiwy?=
 =?iso-8859-1?Q?a4+R23nm9sKRquy0a0lJTSp8Gdk5nTOSRRbaD8YAsSSNmfIPCzwUAymlnK?=
 =?iso-8859-1?Q?fFxZMp7RP9aTIUoeXd+cHR3LCoJojzMJAAH7yzhxnM2bybGS6aQYnOMgbs?=
 =?iso-8859-1?Q?qWBEzMcvKeYM95PdC8DgXL5JP7OPm+xvStBP4A8LqmZZA9f65Z4kBVANw1?=
 =?iso-8859-1?Q?9AnAhJ7dqNwz2GyLaEDNoGT8Rqu3lkGq6bYPr/1v4TJ2MCFtHg59fB7ciL?=
 =?iso-8859-1?Q?2G9GYAbxwo5/us+aOrwrHoaGjvN1EQkFf/iGyonl08zIas28/EvOXVeeW7?=
 =?iso-8859-1?Q?09u/NCb6xKRObgCScnImitfS9g/dGXbCUGl7+fgcTwtOM/pArgtNmHFuc+?=
 =?iso-8859-1?Q?7Un0dqZZllQNI45cy6K+5MVEg35o5NXklbF9gkhFaOAvK1mJGFYAST/iau?=
 =?iso-8859-1?Q?5wQeyw2UiMIEkfT0D9cFcMxgAfBSPaenxZUp6jjHurW8lMLx9O/Equ64jM?=
 =?iso-8859-1?Q?Mv+0C1cKM1kUbS/ZPHxolD2ClX9ltNpw5dLAoIyJmpZuXPXyytAGceSepj?=
 =?iso-8859-1?Q?ayXIt4Ym+Tyl3lakox/30DU7n/+749rTB92DBUu9Vr9hKCo6FuXhZXGfHw?=
 =?iso-8859-1?Q?onXX8FFYYjcNBcpgM3r1Xf/4Ju8yGysTQLF5GgbNySa2DkJhBjvADmRWZh?=
 =?iso-8859-1?Q?5HeQIygvwzHbOdJZg/yZSZ2nXsg0GMPt5lHBS1gBmBA3/FsBtxW4Tlk4xn?=
 =?iso-8859-1?Q?gML2L4KF35LBH3xxZnGYUCEOTxBaTTADxCmn71QROiM3FKpShI2pq3M+m9?=
 =?iso-8859-1?Q?g5uSRVd/opNcNe0PyMLyktW0iAwLrpr1fPbEwrb8G7yRXKf/Fjl8nTGc2i?=
 =?iso-8859-1?Q?gcdvQCpN5QA4vEddkHTsT2AOqFSa1PfwIFN1MqvT+J6pQ6sfmkbRo7RYDa?=
 =?iso-8859-1?Q?oxGCaPvpOoQsV6zw06ZqYNG8PG+MtW7+83XewsjLrlq1DA3k7zi0rhFMkg?=
 =?iso-8859-1?Q?M8Lu873v7TKLgGdvuqus0fLaHWDx6VNa1nR7XrAPUddx5Vwy7/7B27Rotm?=
 =?iso-8859-1?Q?L/n6bDtEWko7BOb9sh8HNj5zgnlaskbpJ3Nr71K3UKmlNZCo4OUYv/2oIn?=
 =?iso-8859-1?Q?3ZQgYFf0wSekKiLwz+NUi2vDx+7IGtQYnbqYrsBNY48M1TK1r75A9hiLt2?=
 =?iso-8859-1?Q?ZoiEmm9p8TiMU6Uv/LPNsu1A+k1S0pk1641crxjwyf3xzE7VLOZ0lsJOxY?=
 =?iso-8859-1?Q?ultQr9Nzh1mJptT49g0JbRw+dxVWb+NE5BGbZHHtOMIJWUaUbvCx2sF/FV?=
 =?iso-8859-1?Q?FXWMLV/w3+7Mll3E7tkyKn3HUaXf9hyvjI4ud2Kgf9irsR1KGodEYGBA+S?=
 =?iso-8859-1?Q?Gs0ns5GPs/aURTYYKljOA84HoMnDzW0EmcOkdhCJjTep0cwxdjOwqze3WP?=
 =?iso-8859-1?Q?I6msXZ2mY98uILi/gipWpdYfef3c2rY3ct5XCX2EwNaaL8Wn8LZr1X4TU5?=
 =?iso-8859-1?Q?zvBYZ1BfKA+G03WRpkDUNzQFNlnzxGN4XCLS9rWl7RU7wRS1O0778srlUU?=
 =?iso-8859-1?Q?fK+CtVGqalKssvzGL04=3D?=
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
 AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	bf55c68f-052e-444e-ab33-08de5e979b8d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|376014|82310400026|36860700013|1800799024|35042699022;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?nuXLBAjN682CrUcRlnMwdS+Lf/uWbib1LJEASnk0JosKlOEgI4ugRoqdPm?=
 =?iso-8859-1?Q?fb21U8WlCrgn4LfSaLeIMI08HwIkXqLb+kJ/zCAGUM5BUboz+NldWKZPxU?=
 =?iso-8859-1?Q?llxigNZ1NjrZ15ungHEtrMU7CRxCFDjGAH0yGEmSg8KNnSI2tyM+whP0+0?=
 =?iso-8859-1?Q?2rMxS8+1ncuPwnJa3IGqVzbbrBSmTkm7Sjf2WITEOHxpSd2Qg5Gy+nPK/t?=
 =?iso-8859-1?Q?buuASC0rfDQhJUql+C+f5sKslg9ZtSRolWiW8L+uGaPxd3Rt1TLfs8mLmi?=
 =?iso-8859-1?Q?a/SVnO1bJcW9wid2v16lJKg1VxEuOD0MkTf2i8bgtm9oTYuFrQR2lS2RuV?=
 =?iso-8859-1?Q?cF2MobiH96u02aU1lF9751KgHiFW5rBN7hnrNbHV9Dv4xoctcduf1sKrEV?=
 =?iso-8859-1?Q?fTvCtEmTeNHDBa556QyLZOU0vRTlLpAJUszog+uV0xPzcfLhsatUTh+8pM?=
 =?iso-8859-1?Q?P22O2C3p0I5YIybLxznZ/W23TbGoOnRHheAwCNDdZkv26NRI9GV0gWWP58?=
 =?iso-8859-1?Q?/Ysns4LlIKH6tdXR1aWRRyYLo7BSD1UVhthy3f/9XrnhwrwX3bKjzbI8S7?=
 =?iso-8859-1?Q?SA7NngBrkbfvoDLgTreB6sPYeZaesZpllNU/X1XKHCf8ai33BFEl3YZa4m?=
 =?iso-8859-1?Q?FT3nvLa6d+MLsBnP4JaG3UQEmEa2UUNnktEwU0y1p6F6gZlVKdFVi4ifLX?=
 =?iso-8859-1?Q?HQOmK5reCiNIhUL6VPoB/gKUt2zvGSw74JslXA+WfNBLGeQdEDUj6vnZj3?=
 =?iso-8859-1?Q?rRhhMx4AbxtoLfXWHZDDEswmLr2e9FgQLXWXf2/DbUJZE18V8ClGF2ZRMb?=
 =?iso-8859-1?Q?XMT2rx81lHCuh4cas9DepApbCABdCcFz94IEMefS2+iCXKFQjAmFWSYsup?=
 =?iso-8859-1?Q?3O1Uda3GmAVzsfkLoYTpVVayoUM3FWGiEI6rx65HgtVPkpPolV9OVBybLn?=
 =?iso-8859-1?Q?E+XPXDRxg1Y+8ndcJk+4M1leI4aHsS0ckRoNsL4/gvjaDa4HJbug1ejw9v?=
 =?iso-8859-1?Q?luW/JKj1UrsxZslTRFgGkniFF3Ac/qb/rK9gPrIGWidR3+OfKRsIeFPF/G?=
 =?iso-8859-1?Q?EtfICfNe2OLdNtchdzP3NTEXQyzeSKj785w5g1RPvlvld+p3FrEPW00eMh?=
 =?iso-8859-1?Q?9j/BCLcN6TGbAYwI0PanY+CLZOifsHDwR1GMT6Et+v2fZ+pZGELAyhaMu3?=
 =?iso-8859-1?Q?0yx3YqDUSAEnKxGCGbcXQc0zp8j1roqaObCwaOiRDuSmgoQWrs60mg2+Wd?=
 =?iso-8859-1?Q?ZFTL8Oy2Ttn+uUBwnAxrRZkUMj9mWZcSx4A/SZR0n37rNidGLk3R+I3IXn?=
 =?iso-8859-1?Q?xyOgluf/33j70Ioh65d9bxJ7udKa98rWkYG1fy5841RO0fjBdC6yEvOQPQ?=
 =?iso-8859-1?Q?TZlid9uwLgvu75aQ49XjHUFB0FUNrBjRfUgcIsbn4nEb3uDaC86ChSS8B/?=
 =?iso-8859-1?Q?cezfA7KAtolNRPEYBo6aVWtDnnfb2q8bGl+ibD1+J4PlRiWNLUnzeMWR28?=
 =?iso-8859-1?Q?mfK47N9bp1SNkojUWE8f2pgt/wq3WIuFQv7JoVuUhxzDQPj9GbimrvYCxU?=
 =?iso-8859-1?Q?jNxg5j4oHHo2ythZYFmA0siPhaX+gNVkBL1HNFdWVc2nv1mFbkOqJOHsKI?=
 =?iso-8859-1?Q?lSAouzsTvJTikxv3rrVTEyO6WBdwldX2t5fJVOPtk30L8aAh0QcQzbDdTk?=
 =?iso-8859-1?Q?AfXajRJogl2/yrKY8xwubwJ39rWpNNGwDmQGnagQoUlTgvB5u9qlQOUAun?=
 =?iso-8859-1?Q?JU2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(376014)(82310400026)(36860700013)(1800799024)(35042699022);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:04:59.8096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8faf9bc-aa5e-481a-09d8-08de5e97c0b2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A799.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5410
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
	TAGGED_FROM(0.00)[bounces-69384-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: BBF7AA778D
X-Rspamd-Action: no action

There are times when the default behaviour of vgic_queue_irq_unlock()
is undesirable. This is because some GICs, such a GICv5 which is the
main driver for this change, handle the majority of the interrupt
lifecycle in hardware. In this case, there is no need for a per-VCPU
AP list as the interrupt can be made pending directly. This is done
either via the ICH_PPI_x_EL2 registers for PPIs, or with the VDPEND
system instruction for SPIs and LPIs.

The vgic_queue_irq_unlock() function is made overridable using a new
function pointer in struct irq_ops. vgic_queue_irq_unlock() is
overridden if the function pointer is non-null.

This new irq_op is unused in this change - it is purely providing the
infrastructure itself. The subsequent PPI injection changes provide a
demonstration of the usage of the queue_irq_unlock irq_op.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/kvm/vgic/vgic.c | 3 +++
 include/kvm/arm_vgic.h     | 9 +++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 62e58fdf611d..49d65e8cc742 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -404,6 +404,9 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic=
_irq *irq,
=20
 	lockdep_assert_held(&irq->irq_lock);
=20
+	if (irq->ops && irq->ops->queue_irq_unlock)
+		return irq->ops->queue_irq_unlock(kvm, irq, flags);
+
 retry:
 	vcpu =3D vgic_target_oracle(irq);
 	if (irq->vcpu || !vcpu) {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 338bbfec8274..113b3fc7fd43 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -173,6 +173,8 @@ enum vgic_irq_config {
 	VGIC_CONFIG_LEVEL
 };
=20
+struct vgic_irq;
+
 /*
  * Per-irq ops overriding some common behavious.
  *
@@ -191,6 +193,13 @@ struct irq_ops {
 	 * peaking into the physical GIC.
 	 */
 	bool (*get_input_level)(int vintid);
+
+	/*
+	 * Function pointer to override the queuing of an IRQ.
+	 */
+	bool (*queue_irq_unlock)(struct kvm *kvm, struct vgic_irq *irq,
+				unsigned long flags) __releases(&irq->irq_lock);
+
 };
=20
 struct vgic_irq {
--=20
2.34.1

