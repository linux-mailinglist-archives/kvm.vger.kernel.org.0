Return-Path: <kvm+bounces-69394-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uPmtIipTemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69394-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:19:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CCCECA7AE9
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:19:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EF2113069036
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6EF2376468;
	Wed, 28 Jan 2026 18:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lt7uxuho";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lt7uxuho"
X-Original-To: kvm@vger.kernel.org
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013047.outbound.protection.outlook.com [40.107.162.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544FE371070
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.47
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623659; cv=fail; b=BAm0KxHBuMzxEm7cOSho+zb/3VKYteUG2V3JjbMMf0HM2nADCIG5FR83C1K1q+kYGKaXfyA8cybslfBkLaLD/0C95gQlxFy+F1VMvRpRzVJ7tqMST6ipipLQDdrtUrQdHqdjQ4wRqr6WVF7UHeaR36vNWWPWpehMd1R7B+glBUc=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623659; c=relaxed/simple;
	bh=RJOjCEFtVoo60tpEZ9kIcId6q134HcdWxjRjCW6A7+Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LvvSpdYNiXaIu/hSAH+7MAlc4fJXYkb1YLphnK8gu6lGP/nGq0T3gc4Sx3VEHp/0TbjrWWGBVmXvGjC5LD9obPT1aMXEGXC+Cp5kQnMGjQ67DCtWH5hAvkeD9lkz9e7xdsf/6kcmMJl/0fPG7kXflBxbiJNGExdqaWRwbXI3k0A=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lt7uxuho; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lt7uxuho; arc=fail smtp.client-ip=40.107.162.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=N6U3nAGZPJjz3moSoFf1NR6FzHj3CSj+xqyerwQXJ+ZGCmCsLRoupIXAXwxgH72fBRnix3ylXW9q1xobWzMP+HMR9Yh/1ytywHgQF8qN4uE9HDvJwPYpuMxMEXyh9J8PjreDpB1sxt7cUS4XYr2gVtllGm6moKzRr3HdwKDZL41JAJMwxa7GfJPSDsjQkpsNQbTn15VId5neEfxKlt5QX+IZU/WZrnit7TxyUxm0hn+j10UQSfpq3JuUtTRqY7cy4jkzSPgE5H7hPVIIYdkjg+0S2zSKoSQG0ma2CNCskAx3o8T4sTjj509jkPUoxm9AwUtGqQYwBQ/q3/ArRILQvQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykZuPcq3KqGUBBYDUBpSY2Zykuu44RSy8qJ7VpO99FA=;
 b=WME4JGRQQeOczl3ExnjjLkUtIXAuDASgOIzcFxPxI/wn441u2NZjxO5b4TzTtwLD4xrA8qxmDW29QOPw1bUZA3+jbqm6cKOkoUfGiSdzuivaoXwMfnuDXRG+WCZjyuaeNXFQNa9k+01ogYQT5AEgWTi0zCOcXd3klFv/IqAKn5FrKs1SdK1DJzhI6I8QyzljQF6GDLdbGhT0vvEGDBZmTd+qwSFKEaTSZ7HyUSp/tZ4J+tau2aMhRIZafZEMSH9hgRDBzJBJSd7HS5bFQls3mszoyqMGzArPCzYUfrM6ob8QPeyDrgH/AQDKKLY+7Yit+kLfbEtvY8EQteHFT1YLvA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykZuPcq3KqGUBBYDUBpSY2Zykuu44RSy8qJ7VpO99FA=;
 b=lt7uxuhohdb8Pg8kX3W6KXgvGbC1UGspU/wLD5tzboHFDhE2YKqz5hz3+mTQiy/vm0VvgkZZNwl/lRZxR9bRfjfeNlFhzJVIVD1WBuO7AMjKM63CI4HtePp3mj0mxyOQj8GrFzCkRPogaqd1/I1knVpfrZ+KE/WPi6FusfiFm7M=
Received: from DU2PR04CA0276.eurprd04.prod.outlook.com (2603:10a6:10:28c::11)
 by DB9PR08MB8227.eurprd08.prod.outlook.com (2603:10a6:10:39f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:07:34 +0000
Received: from DU6PEPF0000A7E2.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::5f) by DU2PR04CA0276.outlook.office365.com
 (2603:10a6:10:28c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.16 via Frontend Transport; Wed,
 28 Jan 2026 18:07:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7E2.mail.protection.outlook.com (10.167.8.42) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Wed, 28 Jan 2026 18:07:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fnu04Bo7iIx0jFeYiAGeptLUUG31i5r1fRXt4JlrgyuX3jG6LUGmXBX5yyM/sHQyTbc5/RtwjTYrJgacyqv/I0rzNQvnM1vkCtltAfzUPvq6TioQzYM+X3bzaUlRZaeBHmr8f95gxxM8W/5W9Cvvv+Q5JYNv0FXXGBFbeN1XlrkVxIWCP79/RfDxSEGYPf+Zk2umz8SQks7RYch651lPrQ+YJ6JVLdOf8Qg/dFr/JhNHMoWY6Wc5t9zAOTnNurDIkBnRJK1uQPBb1z08enpRMqRuBCVpmhUf9ghycxMTPuOheL4qWeFUeUOY/so/iCThK6obm8LDJqIheEq5kiiXKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ykZuPcq3KqGUBBYDUBpSY2Zykuu44RSy8qJ7VpO99FA=;
 b=AAk6h4dJDYx9CQ/IGL1YVCxGJCjuzfNOnE6rsTLu+hGW9ukIOwwKmh/RQwSZPXOCLa7Cru8Tb9ezs/X8CBtbmn7L+FUXQRLV6utkRLctTVOobPAi7LW5PTqd2SSV6JBXUj+vgQdXW1ZqUFRjL4Nk8gDUWBQq49RnPA9n8Q/6i1nvOhCCveyMv7cNkXmBneqLDpYfFeLnHPIUS7LK7klebTKCsHgA5uFDoSx2AzhiO76ijlZmrFD42V/hWVAweyum04MsRSIIRGuQrtbaKGuhVPNOTVj6exPcwQdKQGE/wpAGR2LLEmTpgBYnQEIpZXOrVagbCBfk8kUUG0SJBJ6NPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykZuPcq3KqGUBBYDUBpSY2Zykuu44RSy8qJ7VpO99FA=;
 b=lt7uxuhohdb8Pg8kX3W6KXgvGbC1UGspU/wLD5tzboHFDhE2YKqz5hz3+mTQiy/vm0VvgkZZNwl/lRZxR9bRfjfeNlFhzJVIVD1WBuO7AMjKM63CI4HtePp3mj0mxyOQj8GrFzCkRPogaqd1/I1knVpfrZ+KE/WPi6FusfiFm7M=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by AS2PR08MB9740.eurprd08.prod.outlook.com (2603:10a6:20b:604::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Wed, 28 Jan
 2026 18:06:32 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:06:31 +0000
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
Subject: [PATCH v4 28/36] KVM: arm64: gic: Hide GICv5 for protected guests
Thread-Topic: [PATCH v4 28/36] KVM: arm64: gic: Hide GICv5 for protected
 guests
Thread-Index: AQHckIDVELeFy0/YCkSgsbpKh/KXng==
Date: Wed, 28 Jan 2026 18:06:31 +0000
Message-ID: <20260128175919.3828384-29-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|AS2PR08MB9740:EE_|DU6PEPF0000A7E2:EE_|DB9PR08MB8227:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fcb600a-e94c-4508-5f9a-08de5e981c8f
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?Y1ceUjqo6YjgQeuHt/JnOnLpTkhO4CZEk21fTBJlRHcXcB8EwWcYqKbdVs?=
 =?iso-8859-1?Q?4tQ+ZKgOoIJkA6THo/ZspykMllA2pXtHihtsqFVQcL+l5+rnGKXIaYmJ++?=
 =?iso-8859-1?Q?owYSsLwH4amo4SJ3E6dmzNWjgCXpUW81YW05yNyQN3NUl66K1Fz2Qt+lZ7?=
 =?iso-8859-1?Q?830vrr2n89eHSt+NovB/XwFVZXGWuEIR7KOU2e1ghrLbCeJSgXIvFmF4pk?=
 =?iso-8859-1?Q?l4lXSl1v73U3mWPUdcFgFcoODvgK5/delyvrrxVkKu+GikmfCeTq5P8XZ7?=
 =?iso-8859-1?Q?4z1bqAggV/2jOPN4vjwUYFtsU6+Z5YCLBh4s46VP7fTDmGE+sgwR6zGvkD?=
 =?iso-8859-1?Q?rddSs20N4NI89cqQhEALkqmdbj1IaPPQo0fuX3U3L+1EMpD2HbviSRX5W4?=
 =?iso-8859-1?Q?FJaIYxgqCW8JA0ocDGnfalQUn2nM9ItrjKFpNI2a1i+JzNaU07INJnpeF7?=
 =?iso-8859-1?Q?0boLah7k7KnBpGX/QBmLMMpXC2IxwUYVpoTk2ppR2oOw8gqU7IY8GH4rRQ?=
 =?iso-8859-1?Q?qgj0kDNW0QVdDy6SisNQIACikah6ZAjNxOj++vVLvVDKrqqncDwaXdUS6+?=
 =?iso-8859-1?Q?D/c4eQyndZe5ILEXC8eb8b8oKj8aFI8knsEIa4D1xy0zy6QreL6CY6UJlA?=
 =?iso-8859-1?Q?Uok6ckjYsqxwXOLm+Mhr5r+/2TbSyNT3L3Eg1P2BjuWBB5qgPl8MoivvfQ?=
 =?iso-8859-1?Q?td5255yLMELgtcKj68ERVUFcF0CB3z/X/vP3Zqn18HwHrntX9Xt08YecUU?=
 =?iso-8859-1?Q?9iqkpn12uq8pImWwmDLwqKYLDwXNmUAgw5QeuLK/6EYaXj6vJz+5RAXrB3?=
 =?iso-8859-1?Q?L+U84pRUsBADs3h2fbUKElb9l+j6gq5DK9SGIDMBREKx6mS6Iu44JiAVT9?=
 =?iso-8859-1?Q?aTBlsEVJd/KiY37cb7H+BRoQAw69yOoy0O4KiC10kKyFnzh/tK7ophF2po?=
 =?iso-8859-1?Q?9aV6ihmWgziVCa0dXbdQRSCpZnBJ32VQVESvagj0N1VQP3eU7xVI/vOZGH?=
 =?iso-8859-1?Q?DhiqiB1+SDKAAPap8IAFLvR2EjxnDRCtH77nQf46Wto7DvyGnesETyHuK8?=
 =?iso-8859-1?Q?kjdPYa19ZmF61UbwU2egiaIqzGzWwRsmCur85a59BZQu9OCBqFCBqY5A0Q?=
 =?iso-8859-1?Q?3j+H4sFh42JBuJCnJd+jEwYzC+hyssIbZBzqnGuCpWsgtK/n/0VUMAypGX?=
 =?iso-8859-1?Q?1Osh0wYdYJULoSKgJ9ER6XMpjwqYb0oabj99eHgS7aO6k0V6bBEd+wj6zc?=
 =?iso-8859-1?Q?gzIWE9oVaT1gRuBdD56PLxIxqi2cMxafOS31H2ir5YRIciZFsOrgnaGB0j?=
 =?iso-8859-1?Q?s3VMz0uj8mfHG6XOSJEAzV1cMvvF9b8uV0uumg51jl7fr4tYXKr8SlDuEK?=
 =?iso-8859-1?Q?6Vnrojr394OFxPSc3VIZJqVMlgGLqafAnd9lVbXX+aMcXW9YiMfT4X4LvY?=
 =?iso-8859-1?Q?CAOvwAlfd0g1a/ULEtapA0QMzv3OpuPxqoPAGTf/c1hNj/aikrpbSq1pCe?=
 =?iso-8859-1?Q?nUp/zgUaveRMy/YOyvGoaEzQuAMB08tehx1aJDZ5NLfyckvYbkd8USrl9j?=
 =?iso-8859-1?Q?3Wrtu5VFMMKjUFtQL06pEbwZlrVfuZho08wTPxtNl/o8WPsea0sgkKFZGZ?=
 =?iso-8859-1?Q?Mm4KrQ5IH55J2juIJW7nKbQXmTVpYs+HvxtTlubPiDBb4Dq4NL+FTUNt+t?=
 =?iso-8859-1?Q?Xq8WqhEXP2xEbsG5s9w=3D?=
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
 DU6PEPF0000A7E2.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	76135a34-94e4-4df6-7927-08de5e97f783
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|35042699022|82310400026|14060799003|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?o6a4tw2Vg/qu2/0lr5ydhMbwr4zfEtwBuAFb4aWJDdbD3Zq0EiPzfCpjEr?=
 =?iso-8859-1?Q?Y0wDkCg7ftAIfPocdL3xHQG0sz9ExKOLIJUZ8ru4s6g0LFoh55QpjgpqHX?=
 =?iso-8859-1?Q?rElViMEAgEhKsZ5++TUGQWdzuRjs8MzDizf8EZM/317Ppc1ULZ3Ul5mRgc?=
 =?iso-8859-1?Q?X8OOKFFgRvDrUdawgMLUAdM80O7E6LYYVA8EGyIoH0/pi8x67jM1PRbVeO?=
 =?iso-8859-1?Q?AcoD3qAu94y18Jrg5OY9fu1oBSTKuGHGLobUCinL4Cg1f3FxU+3ImN4qAq?=
 =?iso-8859-1?Q?nEn+s9fH+4speFmkJ2lATz7kHHLkYweDL7Q0fNp38QJT2HDvxrOsVaz47E?=
 =?iso-8859-1?Q?8ACZSmKad3mF7GHt20QXaWjZT7KqkQDJiZCc03YtKnmypGsY+ECJqVbN8C?=
 =?iso-8859-1?Q?yVfFXWTf69rfoQeARG9GJg+K25TtM2sUx1HIm9O/XjrO8bCx8Mo16f4mLh?=
 =?iso-8859-1?Q?dBTm61yN9dt+05wVnDfUmlvdRK038YlHp/CsrcMV1QTSN5NzsRxvgeR2EL?=
 =?iso-8859-1?Q?0OIHuVDvPlY4yYywqaEHJ7WusIDsPGqZsw/qQN5/RyV6eJUnaxqvlGen4o?=
 =?iso-8859-1?Q?i5ZZO3uvnMl9QFtautZGBi71Y2UuWlpMiCTfnD1JcGwePlIdb8eVcR9Qlx?=
 =?iso-8859-1?Q?4Vm1t4epNsinYqlGUYwmBUmvfVA/twDa+CpF4/WgjRM1twU8mdBTcC7GvE?=
 =?iso-8859-1?Q?nudEnj8eXccI17wB+vcw5QaEqJDxrnEDQ6LEslxmLGjF5+PbEtI0zvGHl+?=
 =?iso-8859-1?Q?Do14rkch+XP9VOOA7PaL11t33HiAmo/TfWXVLYWp+oVJzfiJzGns22yYHN?=
 =?iso-8859-1?Q?Xlrj5d+4Pf0fhaBDrz0+3AxEazlfyW+X4aIr4H+8iRSD9gLc8USzrxH7St?=
 =?iso-8859-1?Q?xk1ucUWaLzql7zG8en8KJ8nZR5qBzQhCCmu3tY8jv9T2b6XOXRSa52qjyt?=
 =?iso-8859-1?Q?vKJ5LrKNBWTBQADkZQoTEv+yK7JZm9G9jLqssvnkmv0DGYxSjV/a1od8Xe?=
 =?iso-8859-1?Q?X+JPtNunXoG2MmCLT5KqXyqpIG5MbWA59tXLr1S46WZHnEIIpOUTQ7Z2QV?=
 =?iso-8859-1?Q?1u8X4HHEi8sQvL6TXxsvhnyBEsiv7G+H1ryMzMzunVwrseN9rYyhODGscB?=
 =?iso-8859-1?Q?KvYzmwR5ua4OJeAp+soo1OLngmze2Xhkcak/zkiQ432K3nmcDkwbRutEBn?=
 =?iso-8859-1?Q?nzsugngCzEQG0BIWp+V66EsDioLciwdujY653gBoI+wH3hYqM5YlJrBW07?=
 =?iso-8859-1?Q?0JDPnQ7hE/kTHxhZ/MVZunZMwPtWWoscxzh0MlkMnmX0IG4cBqe4p0sg+G?=
 =?iso-8859-1?Q?qg8Efd0FSbLvuJ3AjlR3vvnG9+8FjW2z3ikWkctMCFnz/2RjY0NitxsEPu?=
 =?iso-8859-1?Q?cmxbnu+W4dnI7iFLmk5mXZY0XLqkjmQXzJTSeeUkmsAiiIo1ZC/G/RifZZ?=
 =?iso-8859-1?Q?ElxyTabPhtGEwzoZURR3HlbRUPIOJWFKuKZTD6vRI7PUf4UB2ZlhmzJyZd?=
 =?iso-8859-1?Q?3c1qEdo9wgRpmX3/2xUTRH++2GSWpUUKh7aibmlmfa8xHforL3+PSNHC68?=
 =?iso-8859-1?Q?qpdntze9crMq3oiNNCNLffT6FZBoC6Nq1XQpYn0gCz9njSE9Hj3hzy/J11?=
 =?iso-8859-1?Q?scrwKlS5ZBdggxtKUq37yDZUuuKt3rA4Zp8yjONJ/tDUBE2fc/Y9P5Pfq3?=
 =?iso-8859-1?Q?lhwsngWutLyimoK0SC8fZHHDHhhdaJy1nd5MD5HEf/pPcCtuQBYNqm4Cy0?=
 =?iso-8859-1?Q?/6IQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(35042699022)(82310400026)(14060799003)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:07:33.9388
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fcb600a-e94c-4508-5f9a-08de5e981c8f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7E2.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8227
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
	TAGGED_FROM(0.00)[bounces-69394-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
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
X-Rspamd-Queue-Id: CCCECA7AE9
X-Rspamd-Action: no action

We don't support running protected guest with GICv5 at the moment.
Therefore, be sure that we don't expose it to the guest at all by
actively hiding it when running a protected guest.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 1 +
 arch/arm64/kvm/arm.c               | 1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 8 ++++++++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3dcec1df87e9..8163c6d2509c 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *ho=
st_ctxt);
=20
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 08e255cabdbc..e1acd16ed213 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2473,6 +2473,7 @@ static void kvm_hyp_init_symbols(void)
 {
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) =3D get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR1_EL1);
+	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_A=
A64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) =3D read_sanitised_ftr_reg(SYS_ID_=
AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/s=
ys_regs.c
index 3108b5185c20..9652935a6ebd 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -20,6 +20,7 @@
  */
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
+u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -108,6 +109,11 @@ static const struct pvm_ftr_bits pvmid_aa64pfr1[] =3D =
{
 	FEAT_END
 };
=20
+static const struct pvm_ftr_bits pvmid_aa64pfr2[] =3D {
+	MAX_FEAT(ID_AA64PFR2_EL1, GCIE, NI),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] =3D {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -221,6 +227,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu,=
 u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64=
pfr0);
 	case SYS_ID_AA64PFR1_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64=
pfr1);
+	case SYS_ID_AA64PFR2_EL1:
+		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64=
pfr2);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
--=20
2.34.1

