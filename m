Return-Path: <kvm+bounces-71979-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCQXMMpUoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71979-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:12:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E91C01A7469
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:12:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 69CC030F5564
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99DE3D5258;
	Thu, 26 Feb 2026 13:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qhX8cZlM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qhX8cZlM"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11013067.outbound.protection.outlook.com [52.101.72.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162E13ACEEB;
	Thu, 26 Feb 2026 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.72.67
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114040; cv=fail; b=ce5BYlDDLeDyp7glRhhMJHuSvfvTWLMlxwOGUIXICz3DGmM6dJp/qsDb+RjYWA0BrriMwVle59RS41iPPDONkBTFZApm9HrQx5QQB821523yDKSk+u4N03+pMHeYSoUYHbTl3TBqA0o6Cx9kdhfWJVY8fYcQluJL82TgIdUoF8A=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114040; c=relaxed/simple;
	bh=DGEYwjnSR/bLM4l2UvJeL63pFHWIpht63DlnaaeSs5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=b9AJW2YFYbyOeCBnA2NCCXChYGTCtthHlWgpbs3wyTzwT423HDYwfyJpsmLaEy/09nrIUPyBfe5gtB19IQQ/LK8V0oISsL4e75yZpfISmCwCeDxMG6dMdPc7ULMVS12mlf5uBX5oPgnHANdu/gJoo3jDSJvs8hGKiGQHTky3N58=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qhX8cZlM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qhX8cZlM; arc=fail smtp.client-ip=52.101.72.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=adLmRl/do+9jLtrsVDLOcx+nM5OHgpvSPA86WO3nW0eUwlGYpSspkdE77yJED+xzqGwI4TCspX2FE5+ub+0CaB7xOzpLjM8mkSgQ5QoyxZyh3ZqMIe7uvcEWJLWBJRaNxa3YVaGK8pEyb+tBXYaLV8FfJ9i04cBFNaY+zleFr8E8M1O9LAkvI3UthOWbh6urRZgNTSOR17s5fAxsIjAN2NeVldP5MjgtKCKVIp23N9/zPpRrZBSwlH5OphL2TKxqGJyQNAH+GVliWl7YYmlLlCPVbGx5D6YXPXbHtUD0/EeoJ/ZMfYvBXJsT8WwBm40iBgxbC6mMyx3qRbYTq8/LNA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3sK3jw6CNqK8xtk2NT0JalV2P1QpvpcbQ/HPeUjC8w=;
 b=P5/ZvL0ZStVQoxymNchQmiFfrCizo0N2IByd3eVlUXwcF+nEOiXQhrnjGRmR5VI1l1wR3Wm4cRJx1ZDu+tTOxNg2X1U6Aqmvrr9lk0psAni7qnbjYEy6DukNcJUmvREDj5NrVCK4LQ8h8B0Wr5lJBMvqV11aRGHNgCctY174Wd+W7oD6zKCTeCx/Qrkn4ABZuGesCqrldKTLZNidaNIkatOZtLpC+TFG7063Z3EeKjNSzL8rX+5K5XkYEYHuaAOQStch9U5zP5nPvWuDAIqj5pwshUJVJhh4P+lHC6nFONscdhSwiBkdeN91fMTrzgafdpkUaclQ41uC+reB2dU4eQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3sK3jw6CNqK8xtk2NT0JalV2P1QpvpcbQ/HPeUjC8w=;
 b=qhX8cZlMJGMxLKPtREXmWBRZb5vcG/GYCut9Rx/aZAiJ+m9GcWfnUlXYfGpCsLOkjmfMHbv/AAlRpDEyZ+EKM+LqfQYyV88HHzHzNvBai3ach5MWUtEkMP0MBLejKcpFgcrxtoZHY8IibQbos40yiZgZSHW8RzU4ClLdvaXbloE=
Received: from AS4PR09CA0029.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::18)
 by AS2PR08MB9920.eurprd08.prod.outlook.com (2603:10a6:20b:55a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Thu, 26 Feb
 2026 13:53:51 +0000
Received: from AM4PEPF00027A6A.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::37) by AS4PR09CA0029.outlook.office365.com
 (2603:10a6:20b:5d4::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.26 via Frontend Transport; Thu,
 26 Feb 2026 13:53:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A6A.mail.protection.outlook.com (10.167.16.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.12
 via Frontend Transport; Thu, 26 Feb 2026 13:53:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MiCttE/AE+f4wQJyZ7IoImv0tLzVgyvrmJq/HB44Gcl7tX2yO9Bta+8PR7YjOdv/SsdptVe5GKZn/rbXVqcMYqNQxTs9PCE+fp7DILMsSmyMHMSjy5+9TR7Vc/IPC/+FqwLTX4AwVCLXpDU6Dh6eIKyCQp7I3qfdhT2NCu+wAP5NqALDJuAnm9VU8HBxQEc9f24WuQTeTaMpMGqE5pHC7noA4a5IbLYZwV5OJXFR3hBx5HvOL6BPJpna50N74Busy0A9gi3tGrxxK+3JvRlsKfV/XYewESQL9SSzd3hkkPS+oWUYTof2C1S+gkeceZj88+eB5Dy5tNzA4YDuDV4puQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3sK3jw6CNqK8xtk2NT0JalV2P1QpvpcbQ/HPeUjC8w=;
 b=fEbdIdkTEZVvZMI3RMxnc+/wRVEbKRuH4k/qe9V5037yRIK5dvkph+KH4kBkOqE8viIz+q+UhW1bKjxdy5IrpK3S+3Wtvlvxa/DmzdU5+fjJ3/JzuYe7E2ifNXggEAf+LZfd3kLohUsH+h4PDG0Vxhzqo6m7EjDeTN7l5+biLCLgr+nZQq+ci3W5x3r9XP2WzjmLN9ymxzKxcBPSo1GEdennPLPbR15JupnCKeAGWqvS3N0bzJit8e5C7DLShGGqy8he4xLhaoQYF7wbosdIDHGZ9Iqm5xwaX6ZIQgsJ4/VFInxbaXGam9dMw7kSDTxR+FOBfBJYu7f4ruw9oEVMIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3sK3jw6CNqK8xtk2NT0JalV2P1QpvpcbQ/HPeUjC8w=;
 b=qhX8cZlMJGMxLKPtREXmWBRZb5vcG/GYCut9Rx/aZAiJ+m9GcWfnUlXYfGpCsLOkjmfMHbv/AAlRpDEyZ+EKM+LqfQYyV88HHzHzNvBai3ach5MWUtEkMP0MBLejKcpFgcrxtoZHY8IibQbos40yiZgZSHW8RzU4ClLdvaXbloE=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB9PR08MB11312.eurprd08.prod.outlook.com
 (2603:10a6:10:608::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 13:52:49 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 13:52:48 +0000
Date: Thu, 26 Feb 2026 13:52:45 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, broonie@kernel.org, ardb@kernel.org,
	suzuki.poulose@arm.com, lpieralisi@kernel.org, joey.gouly@arm.com,
	yuzenghui@huawei.com
Subject: Re: [PATCH v14 7/8] KVM: arm64: use CASLT instruction for swapping
 guest descriptor
Message-ID: <aaBQLTOe2NwoVZf8@e129823.arm.com>
References: <20260225182708.3225211-1-yeoreum.yun@arm.com>
 <20260225182708.3225211-8-yeoreum.yun@arm.com>
 <aaAwtrrJ-qFrqktX@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaAwtrrJ-qFrqktX@kernel.org>
X-ClientProxiedBy: LO2P123CA0036.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::24)
 To GV1PR08MB10521.eurprd08.prod.outlook.com (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB9PR08MB11312:EE_|AM4PEPF00027A6A:EE_|AS2PR08MB9920:EE_
X-MS-Office365-Filtering-Correlation-Id: ca665ad6-b434-4a3b-24ad-08de753e7964
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info-Original:
 guHKZ5zTsc4WaPOrv65lbTeMde9hqcu1aixiVmhxv0FurLHw+oHdn/eR4eB/CGNbza6SvNnD21bmKpsJOT+UMBHnhvXwyindWwp9c4u4w6Z0l9mUc0yjV9nZjmj8P+af5Guie/cgc4AsadZ/fhPdyW2ECAiBbxc0xiTRN1nQb7nBbIrF8a0wwaiE/07z/0sxxC1RwkvpjAdCBgAF1rNSrV9ba49tRXjvk/308BMKP0dBzugXhrKaROw+Esj80D+MOz13n1VxOIAAamK6VNX4HRnuwHZSADKUuzdLIT10CEI1nylovnLpXY34kcCuMnuXB5sJF7L7N97jCn/X9R2emn1Dce09XOZU5a41nUJ1kShhvErHmfQEmy7NaEV/MW+IDgdIMWSteY1izHqbdNTPPSfSN9wiT8k/VYEsvgO6wqTToCBgu/NbOQd8tblr7H+YTIMN7F7u2l9huEEq/yiQkYfcQ+E0MRkOPAkBE1Ins5q0eTNdBPpRZ7bhBCopVll0QzqQy1qBuxSapD3fwIcAM9o0rVnvXuSPUUJViaTbkpML7xV851DqmiswELxt2kgaz1XMowwHMJbRWKABzgY7gsmcpYqCEttL8LcxZOWaEL60qzmySxmaNFF+OCiE4nHEuyKZJ239p5O+0KzQQ5HsQHbRgjRcZZJwIZNgSC+tDJyQdrTJ7FD5wm21zFITkPcdlqDpt++06hN1iESVZ2CF9B0ym4VTVTtJsmqSIl8y1PY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11312
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	1d1b3a04-798c-4227-ab8c-08de753e5381
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|35042699022|14060799003;
X-Microsoft-Antispam-Message-Info:
	ylbvX6RMNfERNUeNbCApGhFMRB5UsMVQ9/V5LpdZtCVPQHdfXXW+JMW92JIDJjAXYYzmDFhLSouIBc8q7UYk2siYn1rwfE7X7+KjaVdBKViOMwC/ExHbBl5rdKMVhXXUrlnlyMCwDc9LuY1GthpwFWDWwXiIhchaRkcslUkjoGIUdiVu1F3Ttq24uMjYjHIZqHhc0WrqmeWiadJfcjH0+MZrYgT4SVODausc2oqmSoG0BdDdZkkRVK+OJ4qacXCLMPbHiw4NTEOHKcgZeFPh7qrpzoEgZ8OgWPOn6YJGSa6zgCXcEFvSnmwUU/sDsFZGcbAXr3Gan4ZXheX1UQFxfYZqjp7whCTwKe26RdIgcKiR+LtaIx4rxK+slT9SOucz3P4cLAwaPRTzGaH38JVujb74xUmgfBytcrVtMcxAR0oXj/81mosb70YcgvUGDG6xf1oDKajQHqSBM4nD2PolvkUG8KaZ84efA1FjomsZEAtwC54s0ghUN1EyZCuR0Xgj400uJ38cg7JCrvhHfgwG99DgU8ZGkZ/YBv4TJI0KaQR3pQFcW62w6JGbvT4zQP38XQREyvauJ6a7PrhhyHDXpMfjNsXOW51gG8+KkHkGTh55xU/HNh8337rcANL9n4tMafYjxMlBE8bGdSThQ8ACh1DL8gFefxn1RimvkZsThXsTLKkk0pmQsk+nfv88mI/MyO6yhikjSsPg0sqBmhMUgJn4Jhi+JHMnxCRMkvSjFOPN4FJhxYO/UKAkQa53f87LjL9gUWD2a0X2VHHnwtVen9e8UoWfek3lP3l/eGnfMT+nDlsPX/yQKXStvc6ELdu4qXJS/Sb1bjyHMDsOuW6+qg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(35042699022)(14060799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DjpXNpg1p0XTBiReWARXM1vS0EdmNl8RprYOnUkP1dw3dYZ1zWb76rTVxg822mOSDiWvkU3sgTQB/fmPjDN2G0YFdzX/YPUlSBjUejmYu9Jw4eJAUc51LXsrlObqJibmpq+DCdGt4+lAhTKVWg2w4PLeq897myUz2Pkn9SiSIfd+O79j+Uite+LdfwRSVgKpMsyKB2q49+kd4i86tpZlpudTREWcVTAa41GEfgxOWCuqG+EvZGQ0pJC/pXGvawAzvJ/vhYFnyfd7dPhgarB1g1mcfjs751fUi7V8/qIrxqpelm6t2INMpAX+uWpQs3gAi8dwGBduXMLDfI5rBQWForpVcbX/rpDjkB56FzGoIdTGsGkE+DL7VF3ZFit+W3sHH3dzCvEz3Wwk4tuk9QWLM2Him9YUCwemhvnXEYn+UdFmrbNBcDRxSi+w06h9Za4j
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 13:53:51.7278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca665ad6-b434-4a3b-24ad-08de753e7964
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9920
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71979-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,e129823.arm.com:mid,arm.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: E91C01A7469
X-Rspamd-Action: no action

Hi Oliver,
> On Wed, Feb 25, 2026 at 06:27:07PM +0000, Yeoreum Yun wrote:
> > +	asm volatile(__LSUI_PREAMBLE
> > +		     "1: caslt	%[old], %[new], %[addr]\n"
>
> The other two flavors of this use relaxed ordering, why can't we do the
> same with LSUI?

Right. I've misunderstood caslt is relaxed symantic.
I should change with CAST.

Thanks!

--
Sincerely,
Yeoreum Yun

