Return-Path: <kvm+bounces-70771-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mPS8GsJoi2k1UQAAu9opvQ
	(envelope-from <kvm+bounces-70771-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:20:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0103911DCEE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 18:20:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D5D853055034
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 17:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D7A38884B;
	Tue, 10 Feb 2026 17:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mPyPOXHc";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mPyPOXHc"
X-Original-To: kvm@vger.kernel.org
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011044.outbound.protection.outlook.com [52.101.70.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A20A1DF74F;
	Tue, 10 Feb 2026 17:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.70.44
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770743948; cv=fail; b=eplSWyAyvxKDcAZHR8xlwbLzJRvCtTfyDbQDmma3fJCxh9VlLYxSnL+NGIMd6X6JoNI1LhuuX72iU9q1UN0Y9tGP8Re6/9UL94V/LZFG2cRfRrU8ihkBeGO2uIASQzQhv7jm6xX2/iM3zwyxDunmq7lK/zc5HuYZUuHVU6S3TDs=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770743948; c=relaxed/simple;
	bh=F5Bwe/XbEIYnuAJy3qT1ab3TyVo7ZjXmd6+wAWOMOho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OFF0/ByKQVW7Qxiuyn1awX2BPSnWCAYZVGi2kEVzAATA8+uhx84ElQxeYrGjvQ/9PFeoMyAM8kK7l4/xuyZCMSRYg4Jhunl5jbNHpkbBiO/2jmTqk7tkgBswUWW9XLw+a5m4vIjEtFmWH/MUYPOn/EBG8sWGpvDZGd/5QnvsiFI=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mPyPOXHc; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mPyPOXHc; arc=fail smtp.client-ip=52.101.70.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=Z3h4xRB1nxbhJeiK4/6vx0jEwhzZjxfnE0ygtONVMXxSlI1ubGFbbB4OXa8+dOH3lKfUTgokVAFRJYgLHI+7Pa7Nm8QRKYsCtRkw8n3RqjaduwB7qadQofH4XIVVrd69PkT7n9eFIueiS/RYRce+DC8dmc2h8WE7zxkgwswuulX1Vvk/a0t0pWC+91blhio7Omf5rdulj7Ol0IKgbZ/bv8DPqqpGq/F+0TjGWRnSrgoh/r3DItZkBvli3C1nn9H7g4XjDBzMdAgE8Ndw5VxyJJ2J7wy1y6kPHR+yr6VxMe3anmJYkTt689OMg6JMdQKSkTeyqazitZ1U4WKboC1ZVg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KupQaog4WI7KEJge6zOI6HGPq5nPqw+f9rXhX+JXSw=;
 b=TIdX/sPK6qRQHLJqDNn9Jo05Ec4QcVqaKTcFXZ3fN98uT4O8hTljqcapGb00EMcjocelipYRjnULf9vmqCpo/kFV7yHf6XCJcnQDy2vCnQ6rIXEoL0/u3LFe/Hi5fbZKV195781RAZzVPS80nsmdd/skCXFBFzS4wILADF3lrZZergniK0T1FclN/STzSvC1OQv+mN+tDKv88d7+DzM3EhH66Rf55QhVq+vDwsRTiRME39IVxqKWxS/zWBMQYSrQm1FEGQDoKlRifJl53A+3or6J3PYBkNVblG7QwRYjRymYYgRjkvv914VN2hUFhltBGtjMmydTlPXyCerzcpTNlQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KupQaog4WI7KEJge6zOI6HGPq5nPqw+f9rXhX+JXSw=;
 b=mPyPOXHc0HpnkBbAF8ffJtGEeFbj0cdMjSkrzcc+RsnBtX6YzmtlvFqKUAGGXzRQnnz2RxFC8c425OCG4nJuqo0dG4MtO/nzA8Xgsky1uGWd29jOaxwMIxnmMVm8HnZJNO4rI2QL2no9cVofGYcM94ieXQ9OAOm+WEAtrQ2KIls=
Received: from AM0PR05CA0092.eurprd05.prod.outlook.com (2603:10a6:208:136::32)
 by AS8PR08MB8086.eurprd08.prod.outlook.com (2603:10a6:20b:54b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Tue, 10 Feb
 2026 17:18:53 +0000
Received: from AM4PEPF00027A65.eurprd04.prod.outlook.com
 (2603:10a6:208:136:cafe::22) by AM0PR05CA0092.outlook.office365.com
 (2603:10a6:208:136::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.19 via Frontend Transport; Tue,
 10 Feb 2026 17:18:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM4PEPF00027A65.mail.protection.outlook.com (10.167.16.86) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8
 via Frontend Transport; Tue, 10 Feb 2026 17:18:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A02ICmxS4pq8k+sygJX83R+0vyr90lqJzKnIvIwMzu6A0akZx3vc1HBiqthGIkU7vcmg73nw/fNkpyjl0Jr6BctwS20yhjxtxj78qmtXq0IfDAI135XuIMVK9q0IDDf9tf4VCcMJhtW2N/30ZyUzsIv6FVkmp/zuFYJIjvNNhFwPAlxGJNSBaSAjxvhy5pBJabv5XcgpnBtvbvRuWxq6KN60w5cvA09P8MJLb83wtXXAThK/EDpYXqW+m/pMTKV0QrAAbI4t1c2gecuOMfj/TdZNtXcKbsTP5EdpFFk6J8miEYrPOI6qldGudej9py7hFIhKCF+alqe1gsx1Pfd9iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KupQaog4WI7KEJge6zOI6HGPq5nPqw+f9rXhX+JXSw=;
 b=NyYdqxdAmgTMMsq6L/tIb9SKZicVHRJD+kWYyahEResCzRleD85IbITL14QEHu9gNM0v2SAv2cHUjfzpbYZVVurpq0rqD4q6yaP7MwNA5dIO2Qc2O/j7HI6eccsp0u5Xcf4WoAcL6jHClFXrELVbv1NZtsW+luek0EdCSQv99qI8ckol9YAyM78GM1YTjQQXU95CFXucO5jGl5DJj5okeWlawbW1SiKxEV5qiH8N4CeLKRx46l2MHmvtXzrXXI1I16sIoR+MRUrSXcvz3cWJ1HUmaYsIh3U0lA0A2ANhl2Wv7ZqvcSfvlnNSCqqf0M9UHlSCIuaiYSb+8ug1C0bG1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KupQaog4WI7KEJge6zOI6HGPq5nPqw+f9rXhX+JXSw=;
 b=mPyPOXHc0HpnkBbAF8ffJtGEeFbj0cdMjSkrzcc+RsnBtX6YzmtlvFqKUAGGXzRQnnz2RxFC8c425OCG4nJuqo0dG4MtO/nzA8Xgsky1uGWd29jOaxwMIxnmMVm8HnZJNO4rI2QL2no9cVofGYcM94ieXQ9OAOm+WEAtrQ2KIls=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by AM9PR08MB6692.eurprd08.prod.outlook.com
 (2603:10a6:20b:30c::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 17:17:49 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::8c9b:58d2:2080:eb98%3]) with mapi id 15.20.9564.016; Tue, 10 Feb 2026
 17:17:49 +0000
Date: Tue, 10 Feb 2026 17:17:46 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, will@kernel.org, maz@kernel.org,
	broonie@kernel.org, oliver.upton@linux.dev, miko.lenczewski@arm.com,
	kevin.brodsky@arm.com, ardb@kernel.org, suzuki.poulose@arm.com,
	lpieralisi@kernel.org, scott@os.amperecomputing.com,
	joey.gouly@arm.com, yuzenghui@huawei.com, pbonzini@redhat.com,
	shuah@kernel.org, mark.rutland@arm.com, arnd@arndb.de
Subject: Re: [PATCH v12 6/7] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aYtoOktjE18YNtB+@e129823.arm.com>
References: <20260121190622.2218669-1-yeoreum.yun@arm.com>
 <20260121190622.2218669-7-yeoreum.yun@arm.com>
 <aYtgmZZhAKAvtfaK@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtgmZZhAKAvtfaK@arm.com>
X-ClientProxiedBy: LO6P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::14) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|AM9PR08MB6692:EE_|AM4PEPF00027A65:EE_|AS8PR08MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: f827dc15-f426-4c76-79bf-08de68c876c9
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?AwCjLiQ+OMGUPj03uyS/bosVifpq2YJukWMu+IIFbZx5fBLRATkOc7GI5gUE?=
 =?us-ascii?Q?CfB/jyYuBgF5gR7nHjRmo6HWrc9sYUWDE0hDhZ9booSHlMjhjDRl11C49bTw?=
 =?us-ascii?Q?rJYIvduduYhKL4RrksLN5kaYeXqjO9Nb3EFyqvF64ESTbqMxZXj4r9V5lefT?=
 =?us-ascii?Q?nXxSQD89mBc/KiYPzQZ/m6c0eqY486HVqjnk/hlwN/xfE0F/YDUvawOpTqRt?=
 =?us-ascii?Q?MToGjFaj88XAYc1SAC2+njaZgUSaeXOe6NjJjUsUjFhr2q1C/jGEwQGFawjb?=
 =?us-ascii?Q?lxNzjWPB1zTAUsdH1zjHV7iAW0ZtTzKXTmDv9tI6q/dCesrrV1f4zjR4JjXu?=
 =?us-ascii?Q?cA+YzxBtg7EzxXMb2g4HHEXkedqR8bjPcWNaE9rgTdOZKXqNziWf5zDPxkfJ?=
 =?us-ascii?Q?p68z5vILZum0VThcZDVA7Lcz7ebIS4fXWljB46Pwyy9LZKeHFQbGSpnaeMN3?=
 =?us-ascii?Q?pAJeVoIXuqxX6vPH72oVtCww4PSXfP+pPrNfiDHE8x0oA8auVHoJivrkDrF6?=
 =?us-ascii?Q?mM3N3UkiKKEvPqCMYpyQhPr03QB33nn5qxuZmV1KykjtNHu5RR6/Tjj+p9Rj?=
 =?us-ascii?Q?bx1cYUkoJuMGUm/Q/7vwhxerOJ2zvuJftU802UJm4p/uo1LFkdxMLoTuIESp?=
 =?us-ascii?Q?7tKNVyPxPqUYrAQiQPmP2gd2yWmOp2yX02Q3sx2fsBaMUZY0xiATSij9QnXy?=
 =?us-ascii?Q?qVLqchpZ+FIjVpgirRJFkEkXvue+gaY6dPXDHm/kkdX0DDOw4rUaTYujHRv8?=
 =?us-ascii?Q?giJ8vkCjnqTZFwUuEtILPwRj0ajxt9Qfh+8zVXw1h85CHxAoZpXh/AbHzlfg?=
 =?us-ascii?Q?2PQW6iOhMOG+WH9H8aBZXD8O/zhOyND0IKEWn/gxfNW12YVaHjn2hROooJc0?=
 =?us-ascii?Q?fkRk5ZZi6DxW/SS9lg3Kj3FTqPzq7sycu2Y1x19lFpKaVjHoij18jR3UQL+0?=
 =?us-ascii?Q?R32q5xda562HjK1Z19Ee9mMhielgwkJ1iezCvJYHWl05rinM4GZU6ESHPEC/?=
 =?us-ascii?Q?I+BGmARvUlNQx/5Gpf7jIrWfdoYmjDTYbYDSoVa24LjBSZekcC55hKIf3gFT?=
 =?us-ascii?Q?pMlCCjyw6WuBmsd0zpUeo3TuVrQgHGjWbgya6X5ytTwUmJxfgTTSo+IMGysh?=
 =?us-ascii?Q?QY2R9c8zgnKwEpu0TKHjsfkAckJ+Z4WWK5eoscQ/FmB7dY7Xzi8PV1wtXMx6?=
 =?us-ascii?Q?F96hl5qPafEcOvnTYc0oXOCMLXdMcpuXjMTPvbb3Nl0p0fjSGwi4wYZHVU13?=
 =?us-ascii?Q?vDw1nltwybFdaQM/rM3JgE9PkQZ+c+OKifq0PAFkNUCIzZ0JqiF8zc/pP46w?=
 =?us-ascii?Q?hVQRQTHiG/FszpNJK8W1kYO4SbunZb9Y7b2icAjCNwzgukTKN7wZc4NuJEsZ?=
 =?us-ascii?Q?8HpdFRnLpyYKU21hynVtRg4qFTcM4vkWpqp/yyn7Yp2NB/E0KGclZUHOtQ79?=
 =?us-ascii?Q?DzblclSejml9S7nRQzO2KzpvDNrDXyNW2cKi28Mve37xfu3bv90ixuWSPfP0?=
 =?us-ascii?Q?lZ0/qeCh0mgmSFH5io4CX9H6z7fnZmiCReRhsU3HzSH3QcpHEWrVyVn2nRB7?=
 =?us-ascii?Q?KvfYh70hOtAhdiU4Vps=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6692
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	20d9b0df-6803-4394-e267-08de68c850f5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|35042699022|1800799024|82310400026|14060799003|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CVqeqkX9jXI0Joj3ixWXKtT2vu8TKsbmZd9Oy43qtS8KiPQ0TdWbbwm5pOpS?=
 =?us-ascii?Q?fuhNQ3j7W+/9lFhqPA2CIEmgTU/zHYhRusNrfWbzKgzCe9HZhPkbukAAFY/I?=
 =?us-ascii?Q?fQEhrkhImsKhpuO4xccduowedfFZbPc6uj6/ravG1ol9vnafetMM+ujx0lzF?=
 =?us-ascii?Q?yt6FK7+w6pTvhaNYYUkNQ/HtLvXMPiVayoZ2+5Ea7hcfVMU20DQqnlm2RvDd?=
 =?us-ascii?Q?/ru3cOPl7Y0gk1HbAqrsT6lwvu3o9vUNBGkgAqnKMM603uvh6zuFDBRDg2sW?=
 =?us-ascii?Q?gKu2+ligYDswimXU7gk5YxmC6rWRe1ynCvOt8JEVei9UPw85AC2SVW+rWobW?=
 =?us-ascii?Q?m56o3xJMIRDoIuNLOSI0Av1a+N064VIXPSIByNUxsH5KOUEneMKYkG/jJaa4?=
 =?us-ascii?Q?ov2kmAYUs7T9cvjsLesApxayNtueNXhZkXZ+FRpgQukRWixlT6zT+MfPyEnx?=
 =?us-ascii?Q?xLpIk2yQK2dBioJx4f6se1Uahf9r58YihKY0FLxaExOgP2zZysZ9ZmS2CACr?=
 =?us-ascii?Q?bL6BIuYRpeVReSslPy7EcH94JSsgg1DJ19/tmc0pZDNAA5kIGvwkarD8tzm5?=
 =?us-ascii?Q?3KaSzH+/7IJPX4KSrpDU7xdVhsAgeqWDCxBADwX3bv37DCfeAdDKaWF5cQta?=
 =?us-ascii?Q?I69x4BgW4CVqdvk3OG0JaIMsKzrn8I4r5mFsDtsdrH5ffQiCc7MBiQgpnGnj?=
 =?us-ascii?Q?sZwkyJm/o6nWgy0PGI6PF05sdQk0JrREkRDpMLcsyBid6PGVxrkBIyFF7uhH?=
 =?us-ascii?Q?9mBz7FhG2FNTqW+/P5cixb/Xyv5+9nFSM1OcxGsAG+kGWdlhLgd2ygZeYkLe?=
 =?us-ascii?Q?mIQD8+uphuPhWWfFIEkwUfWiGqTx26mwGG9BPVxnGuzjGjwvvOXP74fZhHZj?=
 =?us-ascii?Q?NGIW2HuKoEUj7xuU4qA8VAQXzNjp229THyo66u/hD92qWsceEYLWwiOvmRYD?=
 =?us-ascii?Q?e/e/4o7yek3x+AzECDFJdSDfJoeuEAcGb1vjBK6qRLIs1War0L1Oeys5NgVR?=
 =?us-ascii?Q?8dqykeBAlAXif76aHNb8hc2H1eLLWwgf5AfodD8Izf2ifAToym62tTUmQhr7?=
 =?us-ascii?Q?LwSrfSsgCCQf/r2YT+58DdlwOJXlPhvdRzCzFcQEUedBO82KZfzOzi3/RyPE?=
 =?us-ascii?Q?Xv4gnE2cWqG7du+HEL6aTrGZetzs8iG1ntcZVC9uMLGuIqAVO4BULk/QTDqL?=
 =?us-ascii?Q?8u+1YkrBE+Txb2GMbV+FpG7LU3Qz4m5Kn7xKOoYipxCBnuuEqnPAMgfTz6Cd?=
 =?us-ascii?Q?UGW0tgiQxblMMsimx+XLqYBpRrT4nziLnsY9DNjQakGrvg5pDp0p2dbNdIb8?=
 =?us-ascii?Q?5+WThC8HM+E2lSLCbGGgO3H9hSusQWBl0O81DgghY+ze6erqI980+Gh/VcUP?=
 =?us-ascii?Q?7QHNyft32hho3TLRRSizj4CT0qyXUmBpJ89HwVCl+IUZSjrs7y6bUvMM/6Bh?=
 =?us-ascii?Q?vQM4fFIuIvlVBkroNsLvUGYLKO/Ree+7yiI4ZvrT2VAAhaElf0HzPLsmCtwi?=
 =?us-ascii?Q?MbFjvLujqh7ACA2LzN+1kKm2J1bg4JZmoynMsts3tG3pNpEMcClW+Ev5lUez?=
 =?us-ascii?Q?rIqOB02O0Qv2871u48OaSGSJ7BtYehB9WrzowFmwk4K3iVpKz76iL+TwfaoJ?=
 =?us-ascii?Q?BBlzoFaU5aYGlTd5szOiS7NRnSdNvKRBo8GKyl9bVmUMNzBv3MTkWPj0RdT4?=
 =?us-ascii?Q?DJfrPQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(35042699022)(1800799024)(82310400026)(14060799003)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qVCn91uvVp3fj6/4MQr4Kx8MsYf7bQ7htP43vYnQ1JMRGPd/c3piF3zXhOgwslKNMoIt2U/B/vz/Siyqn2QPaOaaS+fqUMWOLt0ALuWtcWHKnJhr4lGe96fY8qDWHRS3nw2QqRgjlatJsilcVFv1QzDAQRt4/htVehAFPv7tmeUC1rABnhjdqnh7j3O0McIHHA5ZNY5C0K+9WcUVIlJZPugSy1enD2t/k9kkAzPufXYBQmEd2zkdwm9mByO/wbVFhIPqnFJpKy4aCBwshB9THbIaxCuKjzmqJeUhCRUQI4saNqjGCS0S7XkqbQAFYkJLyK2mMhTOuPNAmXPgdViut8mPvzhMlzhp2JgjN6ZT6SCoJ1JKIogcwl693lZH8bN/6/Mf0RetOizgRPfslIxt33/0flsi5TTq09mti6MBd3FM0kDqUl0AY0YSvDSGAf+W
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 17:18:52.8008
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f827dc15-f426-4c76-79bf-08de68c876c9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A65.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8086
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=3];
	DMARC_POLICY_ALLOW(-0.50)[arm.com,none];
	R_DKIM_ALLOW(-0.20)[arm.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70771-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[arm.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,e129823.arm.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	DKIM_TRACE(0.00)[arm.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yeoreum.yun@arm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[8]
X-Rspamd-Queue-Id: 0103911DCEE
X-Rspamd-Action: no action

Hi Catalin,

Thanks for your suggestion.

> I wonder whether we can shorten this function a bit. Not sure it would
> be more readable but it would be shorter.
>
> On Wed, Jan 21, 2026 at 07:06:21PM +0000, Yeoreum Yun wrote:
> > +static __always_inline int
> > +__lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > +{
> > +	u64 __user *uaddr64;
> > +	bool futex_on_lo;
> > +	int ret, i;
> > +	u32 other, orig_other;
> > +	union {
> > +		struct futex_on_lo {
> > +			u32 val;
> > +			u32 other;
> > +		} lo_futex;
> > +
> > +		struct futex_on_hi {
> > +			u32 other;
> > +			u32 val;
> > +		} hi_futex;
> > +
> > +		u64 raw;
> > +	} oval64, orig64, nval64;
>
> 	union {
> 		u32 futex[2];
> 		u64 raw;
> 	}
>
> > +
> > +	uaddr64 = (u64 __user *) PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> > +	futex_on_lo = IS_ALIGNED((unsigned long)uaddr, sizeof(u64));
>
> 	futex_pos = (unsigned long)uaddr & 4 ? 1 : 0;

Okay. I'll try.

>
> > +
> > +	if (futex_on_lo) {
> > +		oval64.lo_futex.val = oldval;
> > +		ret = get_user(oval64.lo_futex.other, uaddr + 1);
> > +	} else {
> > +		oval64.hi_futex.val = oldval;
> > +		ret = get_user(oval64.hi_futex.other, uaddr - 1);
> > +	}
>
> and here use
>
> 	get_user(oval64.raw, uaddr64);
> 	futex[futex_pos] = oldval;

But there is another feedback about this
(though I did first similarly with your suggestion -- use oval64.raw):
  https://lore.kernel.org/all/aXDZGhFQDvoSwdc_@willie-the-truck/

>
> > +
> > +	if (ret)
> > +		return -EFAULT;
> > +
> > +	ret = -EAGAIN;
> > +	for (i = 0; i < FUTEX_MAX_LOOPS; i++) {
> > +		orig64.raw = nval64.raw = oval64.raw;
> > +
> > +		if (futex_on_lo)
> > +			nval64.lo_futex.val = newval;
> > +		else
> > +			nval64.hi_futex.val = newval;
> > +
> > +		if (__lsui_cmpxchg64(uaddr64, &oval64.raw, nval64.raw))
> > +			return -EFAULT;
> > +
> > +		if (futex_on_lo) {
> > +			oldval = oval64.lo_futex.val;
> > +			other = oval64.lo_futex.other;
> > +			orig_other = orig64.lo_futex.other;
> > +		} else {
> > +			oldval = oval64.hi_futex.val;
> > +			other = oval64.hi_futex.other;
> > +			orig_other = orig64.hi_futex.other;
> > +		}
>
> Something similar here to use futex[futex_pos].
>
> We probably also need to check that the user pointer is 32-bit aligned
> and return -EFAULT if not.

Thanks. I'll respin it again ;)

--
Sincerely,
Yeoreum Yun

