Return-Path: <kvm+bounces-23312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 373AC94890E
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 07:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AEA051F2369A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 05:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5701BC068;
	Tue,  6 Aug 2024 05:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nv3XoHOr";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="A/iK8VPY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829E315D1;
	Tue,  6 Aug 2024 05:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722923699; cv=fail; b=tDLkF12M15Er9Gm/7ha33TtjXA6QLOm7z+iPdJu0Q6i1GS1MB08790RKIrSRWIPS31a++5NTENxapflaE7Xxa3TkxxDDf4urIUGhyzv7vgryJYvRZ6tusQ9qkf1YE6nzjTSsXNNw34H+Z/X1fzqx/Iwkkz0UY5n3w7i2hLVzciQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722923699; c=relaxed/simple;
	bh=b6sO1YrZ9uUbO1DVyOm6CLC+Un++eaan3lqi51LRZ6c=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=tea9eKeZF/kByd6kptztkrJu0Pdg0ssiWGOTJ2hqotcHw+Ct6V+eP1pyYSUdFC+xkAyHLqq6497mV9jNC4H4PBdqqRygneBHT/nGqyuB4RkiT5KsE8FXCmVf5ufWZ0j9XafCp4CZuzPCwhFmRNKHRdEJvW7VTY7EuLyJTCJlLhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nv3XoHOr; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=A/iK8VPY; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475MMd5H019236;
	Mon, 5 Aug 2024 22:37:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=jsGdCRk3qmZ5m
	GFt2D8a9karqDAve8CRATdYKcJPfaw=; b=nv3XoHOrtkehfG6DOKtB8ytUn1B5y
	hwytJt9htGoVX0uLoON/lmp00JyaryA6vEWRh++JhmreM4qEDaoZpu9Nq3d9PzdR
	RhGmoy2YuWlUFSfVX1Zo05c4Jq54tx2MltYdzAuGBkhLXQ1lbVRV4MXvYrNx7yN5
	28GIxowLeB9g07ns5jdL34v/XQicGfBVz6Go8tvLqXzU1b50/MTXlZzf4z59Ydjg
	tDqOUFsCMwD1wVHAgf1eCxM9K06Km49CHi6lXcT9qnneDkRE5bNQg4zNv4Y89+eA
	mCk3G0vZPS82lsV9EcQ8Ws8OmCcdTL2K0b+JmY/2MQWHaIKiZXqj8S3Yg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010002.outbound.protection.outlook.com [40.93.13.2])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 40sgvrn3jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 22:37:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AFjcbi9LsXKLWcSjIm7f0TBIc6SajodEWB0uDyc2ST8a7Ftj7cN6VxRoSoFintXc4nZBaBbn01aCvJEOnhVirBnFqrOyDITzCqPUXl+uA0WTOqRZQrGDIb26Y7wtLNTtbpYFgTCqzMcWXM0hLQNboSVUtTNQY5Yd0Bv+tw6vAhWa/zRdeETTqI06zv/EXv0U+AwYIMcexoGjLzBkt1GCrZ7xsJmdpD5awksHSfmbYgty9aY0qTU6F8CY0lbth8i60otXDyQUMT1rYNvlxGSueQGy3ZmNSmo/E78WeuD+ZZMdRrd+Co/S7ZxkUDGPEFNp0czpDsuENnA/3TnTwAiv1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsGdCRk3qmZ5mGFt2D8a9karqDAve8CRATdYKcJPfaw=;
 b=K8ZJn+ClcLZvS2ukBvKEcjUD6SPkRcg5C03s7X6ip/8yPZyhF/dVcNxq+CLkecHJfoKr86K6Y+U8le3C5wX+60xmlqa+Gfl27zX86IBzRyN+YvhJ02PE1Wgqm/6RII4O3ZSoZ4jJWaReboSUIUC4YshKxrQYZTwvnIa8d4tNNZkIaG9YkCbreoQquRmHBp9h5Kp17wQNipr/oicpgVJg/gRx7f6z9f2e0UtrBo7R4QrHDAYDiNE5MYhJiaXTguRgehTSPowwpJUVyw0VPvCIhgP945zxhN/0EF/F2+cnQUIEErEk4ZwgjiBuVKK5BsUNlmwrxW0p0YwzLP7ZJYEk3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsGdCRk3qmZ5mGFt2D8a9karqDAve8CRATdYKcJPfaw=;
 b=A/iK8VPYF1q2AOPWdwZsONHkE6S3NRYPKYQ9EIF774cV5EEoXU+8cQkJW3vLZMkzpGTMio5SdBKj5P0j12zWEdx3iubLy+HQxI7JgJ5imW1Su1FI3+Ew3+PkIsvSb+mk7QHmWWh6DK6dZ8Kw9xa1umcPrmWM4S4JTPeq0FcsyPwHkcpS+bYLTpfzy+4b/LOPxslWGc1sGiFv2IwMCDYkKBtSIhatrzoUtIJo5zpt6dG3YUGZBPBB6YX2aVE517wloZ4YFbjbWeLAekt486lwE7eQ1UUo7r+bnHBTeu6Dqz89HXmpxvzXKuc77RUA+WGpl88jxWpjCb6rRtNeJY0fmg==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by BY1PR02MB10433.namprd02.prod.outlook.com (2603:10b6:a03:5a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 05:37:35 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78%4]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 05:37:35 +0000
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To: chao.gao@intel.com, seanjc@google.com, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        vkuznets@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jon@nutanix.com, Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on SPR/EMR
Date: Tue,  6 Aug 2024 05:37:01 +0000
Message-Id: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::10) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR02MB8041:EE_|BY1PR02MB10433:EE_
X-MS-Office365-Filtering-Correlation-Id: a7df9f12-f829-4caf-1322-08dcb5d9e060
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|366016|1800799024|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ttbr5JCiY5atr0NVZ7CWdBdd415KqRhZ2Yraqwcxr0G75o58aleeDuvM+Y/o?=
 =?us-ascii?Q?KdUqdaq0yYMswedwuc5AwWCjZZN1S12xobPdkeHI5V6BUm+k8ePsjDfyyzYO?=
 =?us-ascii?Q?07CnemU87EmQJCOhKwV1faBqi8aagCa0UxcDSQonMXeL6BKH/XY7p20IQoVi?=
 =?us-ascii?Q?qn1g7etZrsp3V6fJgoc0JOXp++cWicni8mh/8Lo/605oQVg2V+hjsMBKQ4Qw?=
 =?us-ascii?Q?Ih2rEqKpit380Vvlx+jP6UTdhG+UEzfM6ZT+VfIypzzzcA7upGvpJFtfw8d1?=
 =?us-ascii?Q?TIvLP4RmmUiJOj3cCOjxS9GcWLSLOz5gQiznjiTiktrYz1NVjVYj8/7l/r+e?=
 =?us-ascii?Q?pzY/9wWOYwsTqS1nS7nmVtC8SNM6BTI+kNsyDTcZYhiq42sYXxUpUSqnL7N1?=
 =?us-ascii?Q?6lmhZyEduSM4NjntRbfAw3V/4IhTtxxPDC9C1CDOi+RHmNUd0zK9L+1DZb/E?=
 =?us-ascii?Q?GkC//moZaZ8W+Mpx1SaacKFzmshO1LHKXhRrTlbY3FeFtJmaLUqcpdIyce2o?=
 =?us-ascii?Q?9enARJY4GJ8/kqau9hqz34s30KEF2hXu33TSEX+o1fdatJZcd4F2d3z2VDBm?=
 =?us-ascii?Q?YNx1BSKPbPIv1Qag4ACc7zGTXRxpYmMcEAoZYfjmPUwMD1WpO34xvhHmn5Gc?=
 =?us-ascii?Q?QUky372uwl4djd/uAuCnJiWDsncqqj7eMZN99cc/3JSfrCz9o9E+N6mBObi+?=
 =?us-ascii?Q?8BITUCJ58zehYd/+xvePLJl77VDH3aMkZ9FiZg18kON5fDGVSWkB6/NPvOkE?=
 =?us-ascii?Q?c8zfmcAl4H2SKNDQUBKh7uv4eDMWUm9QmZCdzAVsx61+aqmJiAgkzwvkwZis?=
 =?us-ascii?Q?6W2frxmrTxmSd5MLzKK5LrEoFqKxZXzC43Db8pwBRaonlZwA2y3KT296oVg8?=
 =?us-ascii?Q?8anQGQfdBC2hZ7FTlq3676Ymxd/BVizWQS9GoNb0jRr4qPbxMOGQWgm2YiOf?=
 =?us-ascii?Q?aXKnny7QzswpqlBjvIhNeSvDx7OfAZ1l/BQ+dF6hsiFfv1pbGjecByYvoGZy?=
 =?us-ascii?Q?wp1tN6BG6sb7HVepBJ0Kfo3zz3MsCse8biVtgqZkHok6oHgqMGHXNlLTZzrj?=
 =?us-ascii?Q?+xiYHWteFLcZhf+PHiagngTuNamfTBejlLt8UMOMKvo6yk5FIwDUFxv/6KsG?=
 =?us-ascii?Q?cbKDFLm4oIREVIdy2STkkPvZDmdHRe8sUE8DZZ2wfCASXUiSsjk6WSnnGNyo?=
 =?us-ascii?Q?wPj2qLPrJ5wtGwiZAqtFERUTrvH6LuI8LrQIyBumWb5/QCbte+q7LhZ9GP3O?=
 =?us-ascii?Q?gNHguaEQOaEYK/ei5WjLumL/csStznVyCao/rs65L1oPlaPqYLeatUj/3IZZ?=
 =?us-ascii?Q?niQ92s8hT+j6gi1v89nmtG+9238qf1445hvMRPaoOFf6fzF/8ZBZe0NHVfSp?=
 =?us-ascii?Q?hrixOPe1oQbqPNgNak2nIrx8fGHr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(366016)(1800799024)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?965wuK3rNVANau55zLSBj/+ebH3WQ82d1VwyGRWGylX1dS2SSTUPvyUxWgge?=
 =?us-ascii?Q?rOFdxFIhhHX2KCyzsabDw1VTxUxiwbl82Q4qwOqyCuihnhOB8NDeZnmB5+4t?=
 =?us-ascii?Q?8bnKATBIbweriz7sXfIRoRWvUvwrCwa0s5n8JwBE/My1FFYexRrvM+J1glgs?=
 =?us-ascii?Q?6YvmOWgrrjXO3Ju8IdBLscuLudwtda8YVy/lHYfm8CkLbPJ7HxF2k9eqUQhq?=
 =?us-ascii?Q?tO65HUGoKFc6E3IRghPNX1ojVypjWyulrGiW4TwE/iNhK13H0UEDtfIE9E+J?=
 =?us-ascii?Q?SDnfa4/P8/SDIt/P4CIqBVxQICmEql9H7p4VQRYKHUVapwx2yNpdVt87VvPQ?=
 =?us-ascii?Q?kmZRYFL/ZmMSpnjkZtLcAo7aFxJCT3+TRZhMIYe+1PWWXWiDErWbWeYxq+Xt?=
 =?us-ascii?Q?7MZg72jnZu0CAQ28efyu84RfPPmY/2MNPDwAa2l8w56ZZmyxfLZQP58rlRM1?=
 =?us-ascii?Q?tK4F+6P3sSNFsn8hA7ufAyHriQL86Pii9VxTiaUUxdZnkqEncV3NDlkxfh5Q?=
 =?us-ascii?Q?BddnV3EOg4vdLIfLboOW68XO/ndAvGONp4J4nj8slTaIJ1m+5YZV69BSVt8r?=
 =?us-ascii?Q?/Li+5i9fmhm4VXgVdA6gkIOaXqmK4vKh8ILFdRjoBspoG/BuhEqvOyjN7SD8?=
 =?us-ascii?Q?wlbs6SKRmULnRHXeSxBvzm8ZEH1Qrph0gPp5+ykSm+z/ez2q+gUS83HwdcmD?=
 =?us-ascii?Q?UE4wFosm4cUelRSLwQMgUVJ2wbLqvtZOmOwIR+VIV99p2lKipukboW/EYcIp?=
 =?us-ascii?Q?LwN2j5dJhoxAy+XppBT7Z3BAKDooZ8KjWkZoR2+OKNzH+SBDNo+s3iCtoPQp?=
 =?us-ascii?Q?IMByY8ZsNH73Ot0PXIXNCcoNqZzwUKXdgcIFoHXFFi6FAMTKmooheiOEUjx+?=
 =?us-ascii?Q?6pRk0/wUwIKNTmg3xin4T2hY/IyIaVm3/d6szhJ3HXQJUeY1TesRq7Xyk8WW?=
 =?us-ascii?Q?JGkMLF0i5XYIvwEkwgTB7CNBSKZaLRyboJ/+nPkLErrtviBckav0eH5sJRLV?=
 =?us-ascii?Q?BPWBSiXx65bYoKyKrrkq2dPcKyzvSuf2A0ccZtlUq28bNhooR7bNE0MpJIT2?=
 =?us-ascii?Q?iZ0dUcdv+coegL6J9GWow8Eu2pvJsli+4TYcgIPDklC7LGGgCzpvvv8UgDKh?=
 =?us-ascii?Q?j3nl1INgxV+Y5n8Tq9eUEcarc8a5X5vwAWeJ/t/wVnhBYDQoC5lDVdaH9+RT?=
 =?us-ascii?Q?LANGKSmKAUTnjwQr2NgpsU/I6m61sl5ESNDGo9CG9N14ggaHGbqE0Wu6dQRb?=
 =?us-ascii?Q?wL9pMDW3jgaikZjOJRvIZqvvwoFXPVcKQmzMxgs2urM090ovLHv+uZK2Ae1s?=
 =?us-ascii?Q?AgdvdXJwsgth37Y458X674/+4sMPXDdbjisbpGSn2MCwWkCdy6VpZrmpsnwb?=
 =?us-ascii?Q?9vxEkJbGjfm4uFSLAouQ5e4IOGU/0avEBU05vE+2DbeL48TYd3zXEXXUIipa?=
 =?us-ascii?Q?2Dmd6+mDXXmc1OvzzBNRvbSqzo1Ar7EcIFGlxCStylBxAB3phXLfY3d841PL?=
 =?us-ascii?Q?HU8Em9K9a7UCoPt/utNoDk8an989Mgtdl9Xrj2kB7jmRwIYv916o3/MgQGu7?=
 =?us-ascii?Q?5FtjlElkX2/HIIYQueGOMoaD9e2XICPDoNhX3qfXkkhBbHfnBTzyB9KcBeIb?=
 =?us-ascii?Q?SQ=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7df9f12-f829-4caf-1322-08dcb5d9e060
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 05:37:35.7635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijHLMnfOL5fMV0KIphArtj+HDUVkR9Rem3mlq+lQ9FlgiT4u+QuWANg2frTOH3rIdl5uIV3abRlYcUPabNEpgDPvs3WlqLklpIROc9Hz8xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR02MB10433
X-Proofpoint-GUID: W8tq_LdJ4CH9FTL1ACyiM2VU5S41VoB3
X-Proofpoint-ORIG-GUID: W8tq_LdJ4CH9FTL1ACyiM2VU5S41VoB3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_04,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Reason: safe

Running multiple Windows VMs with VP Assis and APICv causes KVM internal
error on Spapphire Rpaids and Emerald Rapids as is reported in [1].
Here Qemu outputs:

  KVM internal error. Suberror: 3
  extra data[0]: 0x000000008000002f
  extra data[1]: 0x0000000000000020
  extra data[2]: 0x0000000000000582
  extra data[3]: 0x0000000000000006
  RAX=0000000000000000 RBX=0000000000000000 RCX=0000000040000070
  RDX=0000000000000000
  RSI=fffffa8001e3db60 RDI=fffffa8002bc8aa0 RBP=fffff88005a91670
  RSP=fffff88005a915c8
  R8 =0000000000000009 R9 =000000000000000b R10=fffff8000264b000
  R11=fffff88005a91750
  R12=fffff88002e40180 R13=fffffa8001e3dc68 R14=fffffa8001e3dc68
  R15=0000000000000002
  RIP=fffff8000271722c RFL=00000046 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
  ES =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
  CS =0010 0000000000000000 00000000 00209b00 DPL=0 CS64 [-RA]
  SS =0018 0000000000000000 ffffffff 00c09300 DPL=0 DS   [-WA]
  DS =002b 0000000000000000 ffffffff 00c0f300 DPL=3 DS   [-WA]
  FS =0053 00000000fff9a000 00007c00 0040f300 DPL=3 DS   [-WA]
  GS =002b fffff88002e40000 ffffffff 00c0f300 DPL=3 DS   [-WA]
  LDT=0000 0000000000000000 ffffffff 00c00000
  TR =0040 fffff88002e44ec0 00000067 00008b00 DPL=0 TSS64-busy
  GDT=     fffff88002e4b4c0 0000007f
  IDT=     fffff88002e4b540 00000fff
  CR0=80050031 CR2=00000000002e408e CR3=000000001c6f5000 CR4=000406f8
  DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
  DR3=0000000000000000
  DR6=00000000fffe07f0 DR7=0000000000000400
  EFER=0000000000000d01
  Code=25 a8 4b 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> 30
  5a 58 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 cc cc cc cc cc cc
  66 66 0f 1f

As is noted in [1], this issue is considered to be a microcode issue
specific to SPR/EMR.

Disable APICv when guest tries to enable VP Assist page only when it's
running on those problematic CPU models.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=218267 [1]
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++++++
 arch/x86/kvm/hyperv.c           | 13 +++++++++++++
 arch/x86/kvm/vmx/main.c         |  1 +
 3 files changed, 22 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 950a03e0181e..9ff687c7326b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1213,6 +1213,13 @@ enum kvm_apicv_inhibit {
 	 */
 	APICV_INHIBIT_REASON_HYPERV,
 
+	/*
+	 * Using VP Assist and APICv simultaneously on Sapphire Rapids
+	 * or Emerald Rapids causes KVM internal error, which is
+	 * considered to be a microcode issue.
+	 */
+	APICV_INHIBIT_REASON_HYPERV_VP_ASSIST,
+
 	/*
 	 * APIC acceleration is inhibited because the userspace didn't yet
 	 * enable the kernel/split irqchip.
@@ -1285,6 +1292,7 @@ enum kvm_apicv_inhibit {
 #define APICV_INHIBIT_REASONS				\
 	__APICV_INHIBIT_REASON(DISABLED),		\
 	__APICV_INHIBIT_REASON(HYPERV),			\
+	__APICV_INHIBIT_REASON(HYPERV_VP_ASSIST),	\
 	__APICV_INHIBIT_REASON(ABSENT),			\
 	__APICV_INHIBIT_REASON(BLOCKIRQ),		\
 	__APICV_INHIBIT_REASON(PHYSICAL_ID_ALIASED),	\
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 4f0a94346d00..8d5a1f685191 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -36,6 +36,7 @@
 
 #include <asm/apicdef.h>
 #include <asm/mshyperv.h>
+#include <asm/cpu_device_id.h>
 #include <trace/events/kvm.h>
 
 #include "trace.h"
@@ -1550,6 +1551,8 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 	case HV_X64_MSR_VP_ASSIST_PAGE: {
 		u64 gfn;
 		unsigned long addr;
+		struct kvm *kvm = vcpu->kvm;
+		struct cpuinfo_x86 *c = &boot_cpu_data;
 
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
 			hv_vcpu->hv_vapic = data;
@@ -1571,6 +1574,16 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 		hv_vcpu->hv_vapic = data;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
+
+		/*
+		 * Using VP Assist and APICv simultaneously on Sapphire Rapids
+		 * or Emerald Rapids causes KVM internal error, which is
+		 * considered to be a microcode issue.
+		 */
+		if (c->x86_vfm == INTEL_SAPPHIRERAPIDS_X ||
+		    c->x86_vfm == INTEL_EMERALDRAPIDS_X)
+			kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_HYPERV_VP_ASSIST);
+
 		if (kvm_lapic_set_pv_eoi(vcpu,
 					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
 					    sizeof(struct hv_vp_assist_page)))
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 0bf35ebe8a1b..a1e7007133a1 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -11,6 +11,7 @@
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
 	 BIT(APICV_INHIBIT_REASON_HYPERV) |			\
+	 BIT(APICV_INHIBIT_REASON_HYPERV_VP_ASSIST) |		\
 	 BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |			\
 	 BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |	\
 	 BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |		\
-- 
2.45.2


