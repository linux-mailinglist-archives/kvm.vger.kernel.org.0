Return-Path: <kvm+bounces-69369-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gNJ2BBRPemnk5AEAu9opvQ
	(envelope-from <kvm+bounces-69369-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:01:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A83A9A7690
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F33C300D694
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B34E212F98;
	Wed, 28 Jan 2026 18:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RG+ac2wx";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RG+ac2wx"
X-Original-To: kvm@vger.kernel.org
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011005.outbound.protection.outlook.com [40.107.130.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BA1330641
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.130.5
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769623283; cv=fail; b=Kt5dHpu5XWYyqPx47eUrjavi1pT49C3NlbNSH2qLVwjm8dXpghNBdfgGi3It2AjDAOMUXEKTlxTe3HMnHUXNoyiBmdh9apZ2NkcW9eOneAoYQ8BVueP4+J8aY5Dlfi0PHuu1c2I+CDj9l8ZP5yGfHisH+pHTB74NjjoYB+9SJjo=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769623283; c=relaxed/simple;
	bh=8mRaKYQyFWNhDNdnLQOFhI9V77iVt03ZgL5p2I0rbPE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZKutwV5RQzz5rA8epQNnNjcvy97sRIaXnhoFFdFWq8lVewwkYL49URNES7SJvDltd1axdMh4T5kM7PAHbD/NIclVHA7pAwuqU5h/6gbXyvrr5ABM6bA0AKRj/E8JThiyfLyh7gR8amg0JFt1RdvRIpXsEXy3F3Dzb1UlB3YxHi0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RG+ac2wx; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RG+ac2wx; arc=fail smtp.client-ip=40.107.130.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=lrWB8Itj44w/g18NPLNXsPQLqlCGAD5HrnDNJcEmWKWa3zP8teIrg3AERsxl/xWIt0V2Hrdu7+uamF0XJdxcGvJ/OQLo0/bI8AqQ8GiEfAiPzAsruvAWDRuMaXnoA08CsPdEycrhSC+23LYeA0qGc/KREOzciyABIF9GByNJqpmAeaFmT+tLxqU2qY7hWdBKY78scvwY+4lLG9BKBi1FozBN13GRghjtI79HaDeE934FuepnhgW78+9xnPJLm14kmW88Ku8ZNfb5xpNO4+mEJd0pxP3o7QDOa5aAK0zOyeKcJCqD3gX39/kDeWqHx84eattB/iUQWZHj5pPeel2moA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLFqdpVoRlsDm9Z0GAhbHLUdidpYQOx2lHsLHtDJ66M=;
 b=HeoQp+UUB3mwpNL3tFnxuL77DxiL/UHFnpEvYa3XtZG/jPbl0MAjGegyRDP+QMWqakaO06crL2DB4nUQB50d22dkukH9VgktWZMcPebx0OpelCp5vtAHcsGMijP7ajP4hKY/yOeYUamu6+oK10AvcxwdV2Ybashpcis3vQ9wBN0H7haCGvCANrOBYZoGzXcHuKvtx5+YSVTmMsiGiHIZDeYVIw9NJrpPLmrnlltuzA2b5Jzb0TEWGTdZ8u7X6ZHgrQjYopAX//jmibvaH7CppeFzM17vk+MPEjwIAvNxbCVAHNOEh0CrkTWtslEhLVp5CfYrZccvnK0m9ufUEk6Fnw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLFqdpVoRlsDm9Z0GAhbHLUdidpYQOx2lHsLHtDJ66M=;
 b=RG+ac2wxBMWcslFEixHnwKsZuoKToyrfHzZVszY2+o3WadRzafXlG717V/AT5S++SJeGx+NKKkk87poj8sAPOuYaLw5KmZtm0yuAOF5CvlQnwpVdz/ipokeck6fRocdwEqKtZCa+8Gj0jn9hKyiMr7wiIgZmEmAk0uWP8t5rYdU=
Received: from DU2PR04CA0241.eurprd04.prod.outlook.com (2603:10a6:10:28e::6)
 by AS8PR08MB6264.eurprd08.prod.outlook.com (2603:10a6:20b:29a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 18:01:11 +0000
Received: from DU2PEPF0001E9C6.eurprd03.prod.outlook.com
 (2603:10a6:10:28e:cafe::eb) by DU2PR04CA0241.outlook.office365.com
 (2603:10a6:10:28e::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Wed,
 28 Jan 2026 18:01:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF0001E9C6.mail.protection.outlook.com (10.167.8.75) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.3 via
 Frontend Transport; Wed, 28 Jan 2026 18:01:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kk63CfjUlZEjir8joAH5YU2LOzDaVeRBmDE21RinM9gMkTFQG4o8T5TGbzmkaY8HDuMzda5Tvnnc/Oy/UdF8cl/evy9tg9UakVIeG4jZUCECiMLfiietHDhLlUxuffQrrOJelaLT5Vg1VtGk8xowCLZkNaduvNvNMxxiW1l43niHD7+jRYKrGA/cMOq2+tyZCJLC4+3F7QIlrxhRrZAIlAySoQ0eL8UmZOdUJlaxumACi/D/P8Vl3mbJ4+uqyKA8gAIM9E5YjLZBftZaup7weOea8/qPNmZbjDNv7F4UYZLp8+/eG5ZBcmONpYQp3wXNL1Jw03F7uiDLsm3hQTrREw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLFqdpVoRlsDm9Z0GAhbHLUdidpYQOx2lHsLHtDJ66M=;
 b=lq9PwkBHtfNBtnosYb23bBeMqhwcZ49zTPvqHczS1uNRiGP2Vw7JlSOgXIzZh2IXDo+XaX0n8FeliUXhwoLlxf57rVCqHMe0lR/HvmGNtI8vlxDm6jMaXvJP0X1NTphJ7S5f9Hs31O1jb7PRMOIpSCiMSsKqxdS5mI7BP6NTNtKbWBo0qHiqQlwNgUMF4GcP5woiNVTusVuJ4aWGdebxJ4LsVTCmKedFrdFX4bgf/t5oqQ3pz+Dv5KjXnb7UV49r0a/0AJBNRXxqsxIYWe8efj3LxPaMcCfHogNCI3oarlovbh1kab6nQ/TFRlfi3QsXfnwnu7fngY1P/eKVAj3eLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLFqdpVoRlsDm9Z0GAhbHLUdidpYQOx2lHsLHtDJ66M=;
 b=RG+ac2wxBMWcslFEixHnwKsZuoKToyrfHzZVszY2+o3WadRzafXlG717V/AT5S++SJeGx+NKKkk87poj8sAPOuYaLw5KmZtm0yuAOF5CvlQnwpVdz/ipokeck6fRocdwEqKtZCa+8Gj0jn9hKyiMr7wiIgZmEmAk0uWP8t5rYdU=
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com (2603:10a6:20b:397::10)
 by VI0PR08MB10537.eurprd08.prod.outlook.com (2603:10a6:800:204::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 18:00:07 +0000
Received: from AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb]) by AS8PR08MB6744.eurprd08.prod.outlook.com
 ([fe80::c07d:23d6:efa7:7ddb%6]) with mapi id 15.20.9564.006; Wed, 28 Jan 2026
 18:00:06 +0000
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
Subject: [PATCH v4 03/36] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1 and
 make RES1
Thread-Topic: [PATCH v4 03/36] arm64/sysreg: Drop ICH_HFGRTR_EL2.ICC_HAPR_EL1
 and make RES1
Thread-Index: AQHckH/v+EHym6BGrEGdUnJQjE+rhA==
Date: Wed, 28 Jan 2026 18:00:06 +0000
Message-ID: <20260128175919.3828384-4-sascha.bischoff@arm.com>
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
	AS8PR08MB6744:EE_|VI0PR08MB10537:EE_|DU2PEPF0001E9C6:EE_|AS8PR08MB6264:EE_
X-MS-Office365-Filtering-Correlation-Id: 8da64fdd-3dfb-4a1c-131e-08de5e97388a
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
X-Microsoft-Antispam-Message-Info-Original:
 =?iso-8859-1?Q?sOXNeqiJTE3MjtGAF570QMsWOe+SvehTFkqqdbLm/kpXIq8RN8JepFCUQO?=
 =?iso-8859-1?Q?nlQlH9iN6a5ylSwy7v6Bw7X3XJ6iJwqdNttVPn97YQMImzrHvK6rxUUyDE?=
 =?iso-8859-1?Q?870k58iUuGu/4izRYzWRWhWw7tVo/bIO31Bqo07T4zLEDqtQZwDnsVS/UT?=
 =?iso-8859-1?Q?aZIPayr+WWQarDYVF5tBQn5p7u+LoYRs5ao0yqsQ4bkJPfsSK4nQYe9dJh?=
 =?iso-8859-1?Q?Z2Lz3jpdGKzoC4hMdOGs51FwDTdpx7sA2J6gJSZGdbGNmQe39p4rG2LUns?=
 =?iso-8859-1?Q?P9R+gItgc3wfyvOGQh5jr//vAFlmb9OiRDMZlZdjxZppDFsEXjE16/YjdD?=
 =?iso-8859-1?Q?91I8VsZYo660dpmWq/GJIoCnNwwggPQtZFzJXOMlIl+aFlNrKhDbicx/AP?=
 =?iso-8859-1?Q?6PdAzYWYiUymV6+piyZd9H7AX8onaaa9xA+903jjEqHB3RABp9fpyJNHN9?=
 =?iso-8859-1?Q?gMrlPy1H4dXqR5TFl+gzcsGnNY1P+YZJ0XPS9pf0BriwECjUgYdPdcDmvq?=
 =?iso-8859-1?Q?0XA8eR3NuDwSi/hrJKVGpt0nVPAEwDWSH8JBkV+fulL34QOS8D5RdII2CQ?=
 =?iso-8859-1?Q?SRFcn/PTgAPKBHUpA2rWSz/sYfAY1rAT1ikvCkMVQZ1XwQxfqv4Lg/XdoZ?=
 =?iso-8859-1?Q?5u3dl+trkRntdJVr53Gcr7Rlka/6E0QdUdjSN25x/A3FGAF4Fphf5QMibW?=
 =?iso-8859-1?Q?K0fGCeTxKUU+sJwO4fNcE2e8JnKRwfkh3MYnGgSyFZwsD9vvfyb3LnEmVo?=
 =?iso-8859-1?Q?qFGcj/xR2N9fMbQtQoWRz0B5UsGal6fvi2Q+k8JZC1G/e0E0kqYVPFkIqF?=
 =?iso-8859-1?Q?l+Xir3Bft9kA3hkOEnSwFoNM7D/yC08hNc80jTG4B8shmyIVlNEe+53BXQ?=
 =?iso-8859-1?Q?/bO5gplNN/O4AB9R56+uuL+0/AteU3nfu6Ze/l9ePDWvK6kW45ksSG+esl?=
 =?iso-8859-1?Q?9BBnoOrG/bE17pR5FKrdLV18rKaQPC2NGE9K4SPylff+Grjl6aqOPUjD11?=
 =?iso-8859-1?Q?+eT+1FV+I1EEJC3+WtGSB/ucbY17Zw3KxcdHNUoeUPLn2YsCv48EBhe47K?=
 =?iso-8859-1?Q?nO9MDjnVt9Qd7BDDztjE2Hq+GtMbUjP8qUS1LfYEPWQb/kLYBa79heR3Ph?=
 =?iso-8859-1?Q?qsR91MKNdQBRf4xL1+2HOQ3S1xKSiEVVo0tulNbF62VY/0FivL+pRLhDW4?=
 =?iso-8859-1?Q?iImuABOXCRK7vGyaoAsowG4z2cA4NOESGzXrB07pqQemnyX6mQK6sZou7B?=
 =?iso-8859-1?Q?C6MIZ39jOlr/34DCaRwRH0Btv+jBp8FJTV/ms9rbwdHaUMIkn18bUYY6CM?=
 =?iso-8859-1?Q?uJFmy9kz7DXBAMH0QNhxqt58HfQfJ2JDjMJeGlr0j/E0JGUSRxQN//KuV1?=
 =?iso-8859-1?Q?+A39QA2DNE4XkLeiukhQrR1NfEBvwg+f/2jinx3A/1dWp6NIw3+Sv6XQ5s?=
 =?iso-8859-1?Q?hYbsvV1ZTl4xtG83qy1opyTlE71o/PKc2nmxNAMwty3l3cfQvom7l1DXU1?=
 =?iso-8859-1?Q?J5dkZafrGRF3bt7VvZmQG+QVz0xr1CHuMBEvvhWdROc/133oPkzrghTUPV?=
 =?iso-8859-1?Q?vHJTvZGA2qjNOP6WTLhPcRFYR1m0Dii4/lpbrV+EO62v79QMCBkd2Oi3ub?=
 =?iso-8859-1?Q?JaiUdnRIrbkPkLArVkHR6wb3fZzZkov2pGBxnDKs4V0yf6ECWK02t7Qo0a?=
 =?iso-8859-1?Q?v+UwLTdymrzskdV4mgo=3D?=
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
 DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1b2b05da-4fcf-4081-a5d7-08de5e9711a4
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|35042699022|14060799003|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?dPjKCgKdC/w6dVxW4fczZ3S3mrAfM9FJ2DqIPenxZWYMzcPr7xqz/dsDzD?=
 =?iso-8859-1?Q?+Z1Qwtz89Rwcv5zptP9qjbcGwytQJx/5GPG7kM2850ldp4waanlFFjLTVl?=
 =?iso-8859-1?Q?YWxc34R/y2U4nMqBIx7WPXOLU5ju2DFyqKNYliYbuhTiS+EszwDB4AFXuh?=
 =?iso-8859-1?Q?HQshCl6zvwGl5QzPFwYugQBPI1SSDGspUIaz2IWD4jyzSNmr8p7rOf2jax?=
 =?iso-8859-1?Q?HC2yZ9+1g2U6tUeuY3MVYskPZl/F73xPyoF8ofTuIRkDx4o4gCNum3uLof?=
 =?iso-8859-1?Q?m/IMJNUjghaBXY4+Ww+N0Ehx6Npb1PeYNrwtHjtPMJN3pWLA6CK7RLhIal?=
 =?iso-8859-1?Q?0cSR3YGrrffKRHA4Ax42mwsHpHi+CM4M1vC0YAuwKB28S6y9oZOi/Uoatr?=
 =?iso-8859-1?Q?FlsCep+L3RxbZFm6weGTxCh80TuY18nM9OmcwNh23gsTeGibJpW9e1w1TE?=
 =?iso-8859-1?Q?Kx/96HHYWU9DINJzTVuc3Cs3s9+L9YFGPWJUD2XHZvh64wynMGoOXGoSII?=
 =?iso-8859-1?Q?uZ03SReEgUaJsJWS+iNcJc7NCt4wdbJKQptnQb5GTxKiVK0w5N3u6DhHpg?=
 =?iso-8859-1?Q?yhUR5TWsxOgYAdlLV74Ixc6Esia7TF6UYUyQ57UuHp/Yjut2U2TUpcyz7y?=
 =?iso-8859-1?Q?fQX+ldPzMqvgfUOI/rU86zZ3PadfAm9KfNFcD8UG5ddtfyErD02sFp+7OH?=
 =?iso-8859-1?Q?s7hOJXkgpMk9EUGoVhBwaXEtqxlrRIq47DQrOHylLKO94zQv9kFHrlFp/I?=
 =?iso-8859-1?Q?3O/bUarxhI+OpIjvAxTT38BPlveXmPvt/lJ61no57pFJ6BIS84YEYW2w8G?=
 =?iso-8859-1?Q?RYbJ2NHd4gzIghrEQQQl+GTqCwmlF+lmKGI29nRGv9al54MWVpNWKDjvXI?=
 =?iso-8859-1?Q?FGITXlbJRQNNkfyotwmTk2cIiwPoLqtSsyEwInCpIWZHo1FfP5UlyMs2gu?=
 =?iso-8859-1?Q?zFfnVVZlmHYBGjfTfB9BQhogsZ8auE/6COwi5Y16txpdPr2HzZVaKr/zN5?=
 =?iso-8859-1?Q?BD8GuqzKyk3vU5rY6simi7UrqH4UQWmJamVGlvbFDb4DcBON5qqk7Jqpym?=
 =?iso-8859-1?Q?JEFGdqJ0GMHxke+b/Nz3Elwxa0XpLIjtlqYDNFxdGfELVr1blucZIcSbIe?=
 =?iso-8859-1?Q?C9fXxbr4CKDs0rJty6DODfU4D248cqdkR2p+LktRWpBuoRNGqtmAnQ8QWw?=
 =?iso-8859-1?Q?qn68F/vKQcBHAXMU6ME6PvEafqzEtXS91sZvkev9AvdYbuDrNqisSrurBC?=
 =?iso-8859-1?Q?o4jVO1vQ2a3+w5j25rLXxJQnBCitBE5wpU1LmgRNCUUAA99vOAXNDRgs7B?=
 =?iso-8859-1?Q?F/XzZ60we6M8D7KtSB3ypLfLcxR2HiBkUY3nwdJV2p7rgA1K7r8ht/mSVp?=
 =?iso-8859-1?Q?GFrCvJoxxHI0xjNAYYBPH7knj4LcYcEDNW1dlk/C9qucdHBRlFtGZ8U+ST?=
 =?iso-8859-1?Q?jzcbocoDi5btuDOqcRTMqiKaBZs0wJeSG2IPhE96EJlylM+hdDAQhxpQZ6?=
 =?iso-8859-1?Q?NXiz3GWKT3LPq06CUWk3xawILEB0mRY2I1yHXmYODr4jRrnfQydHgy21V6?=
 =?iso-8859-1?Q?8OMkr7ZzZLSg/J6B8D7XV+vSe6J+lqxOkWGshZb4IWUbZ/YUGgH45K55cS?=
 =?iso-8859-1?Q?plko44dX9k9d0weu80nc6WrvCzpBrLnJxxdbMnf0uTPqwB5txo/xesnG6v?=
 =?iso-8859-1?Q?gAs2dgC/kVyJqKSjIIT8GgB3ft26b/PQ/Gr+1plfwOaSqDJwDl8mkh2HF/?=
 =?iso-8859-1?Q?K0Wg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(35042699022)(14060799003)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 18:01:11.3862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8da64fdd-3dfb-4a1c-131e-08de5e97388a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF0001E9C6.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6264
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69369-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arm.com:email,arm.com:dkim,arm.com:mid,huawei.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Sascha.Bischoff@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[arm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: A83A9A7690
X-Rspamd-Action: no action

The GICv5 architecture is dropping the ICC_HAPR_EL1 and ICV_HAPR_EL1
system registers. These registers were never added to the sysregs, but
the traps for them were.

Drop the trap bit from the ICH_HFGRTR_EL2 and make it Res1 as per the
upcoming GICv5 spec change. Additionally, update the EL2 setup code to
not attempt to set that bit.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 arch/arm64/include/asm/el2_setup.h | 1 -
 arch/arm64/tools/sysreg            | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el=
2_setup.h
index cacd20df1786..07c12f4a69b4 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -225,7 +225,6 @@
 		     ICH_HFGRTR_EL2_ICC_ICSR_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_PCR_EL1			| \
 		     ICH_HFGRTR_EL2_ICC_HPPIR_EL1		| \
-		     ICH_HFGRTR_EL2_ICC_HAPR_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_CR0_EL1			| \
 		     ICH_HFGRTR_EL2_ICC_IDRn_EL1		| \
 		     ICH_HFGRTR_EL2_ICC_APR_EL1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 8921b51866d6..dab5bfe8c968 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4579,7 +4579,7 @@ Field	7	ICC_IAFFIDR_EL1
 Field	6	ICC_ICSR_EL1
 Field	5	ICC_PCR_EL1
 Field	4	ICC_HPPIR_EL1
-Field	3	ICC_HAPR_EL1
+Res1	3
 Field	2	ICC_CR0_EL1
 Field	1	ICC_IDRn_EL1
 Field	0	ICC_APR_EL1
--=20
2.34.1

