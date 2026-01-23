Return-Path: <kvm+bounces-68959-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNPFNJZwc2lNvwAAu9opvQ
	(envelope-from <kvm+bounces-68959-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 13:59:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C78076107
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 13:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B00C3044A51
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 12:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE13E2D97BB;
	Fri, 23 Jan 2026 12:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ha4B06Ct";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MMclKq0H"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6608D18871F;
	Fri, 23 Jan 2026 12:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769173129; cv=fail; b=D+VghLelThYTIZ7fEvIt59YdomFcrS0GYU16+Xgi+MSzyE4lUgIlHSqHQ+gO3cURQajSRoQ92scibELG5ejrxGAa58dnElm6uxkgimIgsBk0SVAAPmMn/iyaPD+XO3jeMPuR6crbQnGDppLk7VeKKwNYyiE1V43QVwYCwRoCxRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769173129; c=relaxed/simple;
	bh=6GvRLr70jC3eMlR2g7hHBEqOb/G7De6A4Qlj7FlrJ+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cz2j2ABLPKPYd04yGkEsCJWnKH7ncMU5u0yhdwUmvJpoWGQsXrtYFebTIPIw37J+Xo7F/HKz8yhOroish9j9c99af3dqZ3X5773zpvFuy8bv8zL9gIzlwpS0HxObTbVbTvt/Ke9CCLOlU5gqh5kSE85iW5V+oQZ/oy1abta7CIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ha4B06Ct; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MMclKq0H; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60NBHcWr3765100;
	Fri, 23 Jan 2026 04:57:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=Fq/WcgM2Tf8pT
	ORVJsoBPWzZILhW7UEovYgHZMmRxBM=; b=Ha4B06CtrK0IWbTrMf1gKbNvGfY6v
	Q9QgrjdCEc/9/ZhlaTb3L0JP53yk1LlxVm+HlRXzMU1GDf2E4JTkPGBViWLRv6j6
	SkiHoZ7sqWs4lolzzI7CuKJWZpQBUz5Zdgpl07qPoCFAGsyD9/PvVDnUkDYJRQyn
	eoC/4zkb4boxIUHBLrWd4OSQ/8DKQqqViTRSNjqnZcq7fpHA0f3OX6fQ5KDUrWB6
	BBfoWWbn58xkyFRfSmrBUR6AzteRIWH3cpBrjRmcks/q85Ad5EQt7xbIGx23mnX7
	WC+hIQ/XxDLaXmPTBT3LKR3kb0I7PMzJ2Tkpn7kfQkKWfu0aaWJIZfVdQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020122.outbound.protection.outlook.com [52.101.193.122])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4buqh2ajvt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Jan 2026 04:57:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ne0tzdqlXyBpY2trEvYSlvD5e9UJPKUXriCv5rbbyAJwrthduVLxc1fsSqxx71sLD50qrsOcmcTM3fpKWhYldZhdUgBYJSm9wX+g8AHm7FzBo/e8cZS+t9iP4Si6vDMeaJm0FJ3oVaw1fg9bxSJNYs12rM/4QFrx2G6gUi3QsImuhKAeQ2HENmqnLUflk46Vw1qbNbnWDPPaRqNUfk9zlSYI8r4m/WcXDdavytnPTmugJ/N1jaCBoxIOqJrXCoJ1gqEuVqjkrdstjPO8nJQzp474MTaexUBUHbZfMtreeZKgRwug+LTaX5fsh99LGrhp9Rgc0mCP8uJMnBs+PeyF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fq/WcgM2Tf8pTORVJsoBPWzZILhW7UEovYgHZMmRxBM=;
 b=e69bp3clKxlIUxP0gKPbx4PRrksmEaTtgVnO38Sw3QpOL6uITWzp4+5Z0GtxpaeTJUUmrUOfF8f19cB/HAKCKIX7jovlrysDKMzkPfZczyWypog4sN14v3wknQ4PQ4YDMiLauPJY5SjxYeGdnYwjqrrYTHaLhVgz3bbhN9PrnHCNjkeKBlt9oNjEWizWOiu4KqkbtMjWKaJttikEVjZs/+hhPMQEB2AtTa5zG9AJfyS30OU5Q15nsYRu24KP6x1AIPJdNJrJvinDPcwbgrXy9KMjVHFEhC23lU6iKXAk5wnQ6MEwNMR8JOSy2la2f2bQVhG3cpnqc1KYTCOAgjamiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq/WcgM2Tf8pTORVJsoBPWzZILhW7UEovYgHZMmRxBM=;
 b=MMclKq0HTu1Q8iQRYaYeCYKciijl6ua0KfZrd2dmTDeP1C+ic8uSUVSxaO5LXiu/C70b/DCm/+2EY/pIqAiZD4y3JXl6anaBEquuLxGxfV7Yj9s5VIJLuqVYqgu63SRJmlF6IDcEuPMroe/TXBxd41fHQ86b952yb6t348Fz3YbyrJNdK9GyvU23rTLPW8B4aJZnL+r/i8ZqO95kr22crrV4Q3nlYcVL+1010M1ia0M4flMgpJcp52QFKLtyDdSVa4xBiCzB+b4Z5hRFiJUQkoAxvuLLOb7mIxmzB7kViY0ot1JhLY8DTUjoRQjBeJkmv3pa/kmjB2EBqU1HSdsNVg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB11086.namprd02.prod.outlook.com (2603:10b6:8:28e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 12:57:49 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 12:57:48 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        dwmw2@infradead.org
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>,
        stable@vger.kernel.org
Subject: [PATCH v6] KVM: x86: Add x2APIC "features" to control EOI broadcast suppression
Date: Fri, 23 Jan 2026 12:56:25 +0000
Message-ID: <20260123125657.3384063-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH0PR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:510:e::31) To SA2PR02MB7564.namprd02.prod.outlook.com
 (2603:10b6:806:146::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR02MB7564:EE_|DS0PR02MB11086:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ad27f5e-af0e-4288-d788-08de5a7f023e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZNEL2c7887+XKeTjqnF86Bv7A2fNuYC73UNGQReVllfk0U9Xfw7diAs32LEO?=
 =?us-ascii?Q?+5pTlISt5LWXQq/xhxFR1DqmWr7639lIOhkn6Em7g+thmruyVgF8wp7x9Zmr?=
 =?us-ascii?Q?VshrYAMv99/A7JCslTAJ+9jDaDZhM6hm3KtKeWBqLgTLK7ZLTTGHYP7dTW1C?=
 =?us-ascii?Q?6Tpapq+76bbW871XhjyjUUFXHY7IGtOz3R3CsZLLwp1IPpxCmx6atm7jtBrt?=
 =?us-ascii?Q?ZuXm9Pw8QyXz8Yilg8QeGWKJiKz3OgUI0BvuW9bRlFdi8CvK3xiq98SEud3Z?=
 =?us-ascii?Q?lc73zQHvA8eZu493jXRuJyVp3T/oHaBJBYjdi7NKMxYHwwmtb8405GD6zyty?=
 =?us-ascii?Q?VV4ooVoYe5fT/Q3YVv1aADrihsOfkpn8wSbsnZnHKvBI1UDxTHYRvvo3qxtq?=
 =?us-ascii?Q?wyICCucEm1sbU6EOmvJNbFJF+xq/EgReUqEkzUgdeknfTL2EW7s4U/JdYs1d?=
 =?us-ascii?Q?RBofrWqQn4ieyBolkD76x8iJhD9ApCFMslJJk8P/0J4xbEb8X+QlP0mjnit+?=
 =?us-ascii?Q?EQ90FZJf1T6O6uCEpOWh1+ARUb0xtRFN+5D6UEmgyDPVvRVcu9uOxDsXHWA6?=
 =?us-ascii?Q?0eEiMXHQQfeGBop/BEmFhS4vGg4dWsXAKqI7FPw2jlcYfB/yeyYmq33EVYGj?=
 =?us-ascii?Q?ru4cUQs2KBGpgB4DbbLofthunJ61XE7tHCcm1h0pvohPyG/VSo95PxGRTvNp?=
 =?us-ascii?Q?GzSaAhGzYuem/Bg9MhlrF61MHP/SR647tPFQsyd66hYYlMbbEMf8JwMz6xlq?=
 =?us-ascii?Q?uCCfRARR99TlF6m2FxulhFuLtb0yGWyaYxW+jX5B81sfq73zCDlG45eol3Na?=
 =?us-ascii?Q?4XrdhbCznqgfSKkThvdKm56lqIbr7tTZ8a3R1SCVEmAIPtglzMxLc7NNw5Cw?=
 =?us-ascii?Q?g3+HThTbW9maLTBJVa6XrO4w7Vl9ROGjb4I1FRYLHgGg94mQFt4rbLlTzEc7?=
 =?us-ascii?Q?whKIUZlYUsoLpE7/A7IYE+dnDLmMgHOQt/s8GaxR9Dg8J7sWhkSSGciBv1mn?=
 =?us-ascii?Q?9iAbjyTYJFl1g5/qOeKlQuX3WA7lOZ8kkPnJSuXKPFcMMeSdSjBHqmU3+7yk?=
 =?us-ascii?Q?+D4UiFvyeN1p7rTpXDEaZerd5kXQIWpOFNzWW2QDz1vSnlqYgkdXCUrIM9Hv?=
 =?us-ascii?Q?Nz8HGoY4tiTTDpumaYkdjl53gYNJIiR99xH8V75d/atGwiCE4n0QKJyAe5qG?=
 =?us-ascii?Q?HYz1N+dgp25ayMUDyVt3u7N0kH/2/LRhm2gjUpq1M8zcpryeUdAfzmSJOWue?=
 =?us-ascii?Q?kXOxAGM1d/zn28m5ldczZ83bl5Az2Do6dl7g/2oCMfj0sRnSe3a4okkqwhof?=
 =?us-ascii?Q?gHLTFRBjxAE4gouqQL+F26w/Xi/9jFk8f2nBIi/8ovfP58UGkYEHSnKoBMC8?=
 =?us-ascii?Q?PqlWaNetwyuWeKz7sPbH0rZ5MpA5NxuZVWsnwLdyDa0BPjEI/bFp85JK9n54?=
 =?us-ascii?Q?YQT4luLOgEw664WcyCNxAH2x4AJ81Pc1Erzi9w1y47ZeNd+h5Q9hLwMtgbw7?=
 =?us-ascii?Q?wTx1Td4X7QkSuRefP55lXoEkslgyOU0f1+hhOoI4tdcQhee1QIg5e+2wpnx5?=
 =?us-ascii?Q?lsGc0bj9UKXyyKz8a8Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nnDKhuc/OmGa4tT/3NZHbhAnwDaaANO5NXloTkKcniBDrofNEEbEW/HdnOpm?=
 =?us-ascii?Q?E6rCd3lmd9yk2RrsmOZ40qJjJ24+WiVLy5KcKBNACHvT+y/D1axsr6R/PBdU?=
 =?us-ascii?Q?66BGzpHAoEmLz0QF7TmE2XjWceMggxVZpeHqEQY2t+vxLK4fUue8ARmoVmnx?=
 =?us-ascii?Q?kWueBeNp/FsKs4tM5OHmc4QBaD86b4BNRpAagZnNE7ix126nQdwoHCQtr8Qg?=
 =?us-ascii?Q?Ty0itRka++/AxWyHzn4FC1y3ObEdvyFoOGjM6RGED6uwXsXeIph381cNpOsq?=
 =?us-ascii?Q?BbhyIh3rEW34Tn8AX3g6N5Apdy80SmfLmrLuLYtVrWP8bWQsoM8ybm7E3u8A?=
 =?us-ascii?Q?+7wTmZ+uCRMqe2rqO58k1DeZ5IvmvJ2aSt8blj7d5ZJCY7i1v+BPQ0vEpy9c?=
 =?us-ascii?Q?2sNKDvaVNWKf+VUya22rdjk3QBB/IrjeXkKLbRfqfir5mb/sg4G4AFJXUog8?=
 =?us-ascii?Q?DDqVOnVKf54kkS9S2EN1J5Jl+YDxnZLDwAy+D1AByGO7nUVcJNM8lWIu7eJa?=
 =?us-ascii?Q?migCUrF27/3wbkDeQFjKWtallQ+6hpUIXot6CFP2mh7OfAL9lQUEebjONJct?=
 =?us-ascii?Q?fJiU/9NX0QSsU552ivJqXnbgjYx0eAStPz7e46TecQPYZxIlNiKxMZDoN2vM?=
 =?us-ascii?Q?Mv/8bgjMGjQO0W9ITsDsozTAFPSNL1TCLIemw3RR6aN9fStw2hcEXd9QucgQ?=
 =?us-ascii?Q?aYxRfxEpZXR4H1K2JK0hECVnWB9Ji2AsxhDBIlwxrhD6FVejutuREYuBx1As?=
 =?us-ascii?Q?XVbDDc4uCEGaYbRCC6YLEVJn+0T5y3Jqcj87xcfGjWtQOVBNuOab1Tqh99VB?=
 =?us-ascii?Q?MRtOTqyk6qLdXlxSJkHYo/oBvLPtTAT3YIW6DXb/RJy6CA2SnmliAKb397kb?=
 =?us-ascii?Q?oIE8SQZNUoqU0nzIL84r9ZVrLF95JuAoNOTSzbpgw0ETp4Bb1TB9w9BnXYBv?=
 =?us-ascii?Q?+08UScTkdQSY/9yfmznT/EYAm5Oiupa0B0PsH7dT/D3UwBaCWshmpQcvzVwP?=
 =?us-ascii?Q?QuNoqT02BECZHJ9d0ByXku9WLVRTrUVBbsBJIXdN4x7z60PWSzQhPEwbHEIo?=
 =?us-ascii?Q?PBFWmDaqLocBINOnugeLdjT9nGyBn3KpUclw1XO2b6M0D56HSJ0F2xq+VNhD?=
 =?us-ascii?Q?lekTgq0p4iXuGyFsji05Viu3fa/qIxHzsFzeFSqJ0m9wN4KWXwiaiEGWeYfP?=
 =?us-ascii?Q?mn7H7BH+2mxedSrpG0NYsGd7AY5myBX+rTIsAIBmCsf2xA8RsuB6H6l6g0AR?=
 =?us-ascii?Q?3TXA952eDFDviXFC8xFs9m6Oc0+IqC3+JCcibrRvxMmK71JijOTys2GWXet9?=
 =?us-ascii?Q?YXHIWIKVf4HMDj517ssnfgvbHHablBsDv3cavgdzjzQdpxXKYhxtjecmRYAu?=
 =?us-ascii?Q?BeVKLWauOQTopTbDVytaDI0YaUw91Oe29ZwtLJR4fjGTNMEPF8ia8Hoz9buO?=
 =?us-ascii?Q?448S0tQ8trJ6Q/Hxz90zQ9w38AJRH7uGLE+jehxveIDVIUbq4uffD+ih3GCi?=
 =?us-ascii?Q?kv2V8/3HgDdiRPxgHvaMoD0NAU2ScQPT/xjTKIULWoaSVJ5wVyPWonj3HYoe?=
 =?us-ascii?Q?PghtU0nzHtQDl5WMaQlKSGI0OAOic8YknEzw5vGgbTGTKEvCU3PIy0LfjALT?=
 =?us-ascii?Q?LvjQaV2jGl7gksoWAecbpQHl5c0xdPD5jTDxZSV6Q6mVqalbpX12UCYWNeFo?=
 =?us-ascii?Q?+48JjT1nI4+W3nRJXpbYtvyRMUvwrby5z+EUU/X9+NVOePbh/ic4r+ZCsXfu?=
 =?us-ascii?Q?UzRay18kDcdhjWnZDUJctErnI415LGc=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad27f5e-af0e-4288-d788-08de5a7f023e
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 12:57:48.5780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bb5QqjBrYLwFlPPSuznelG/2VciVA6xeOKty7LTXYYNT0ijzRffMWS/kIZO/iO376nJhsINURkFT17BjYZJbg0m1jN1yha3MOgC1zg0EDQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB11086
X-Proofpoint-ORIG-GUID: Dx8FTtuno95_lz2tZfWi-ew9fXJJUuqP
X-Authority-Analysis: v=2.4 cv=Zrng6t7G c=1 sm=1 tr=0 ts=6973704e cx=c_pps
 a=PcTxMsyy24f1mGF745e4bA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=JfrnYn6hAAAA:8
 a=1XWaLZrsAAAA:8 a=JKTq14bOYbqOxaZm8WYA:9 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: Dx8FTtuno95_lz2tZfWi-ew9fXJJUuqP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDEwNyBTYWx0ZWRfX/CVtfqBEYj6C
 73lEL0q65HUyvLb4MxQeduhJbK5ktFO+giv41DgdWRK0AgHSEulJxHbLFeJ6rhsVIMCaAXqvgkb
 6KedgAzJsXmfHrmcQWzIqpiWVh5AHWo/qnMDnHJgW+0Z+drqs1hPEnf0MRqGVCjHRv58YU/pVZX
 ABygWOBzAdHw4e+o0X4oya19P7SqwWH5nhGQi7+z3aMgMKYL4nqCqfqqC+2SJSVqAcedZKS55Io
 bFjoQCofspkySWt1iGPGqgivTeq+2JpOoZjKRMMpWIG3GLoH81m2zhiwF8QtPdHMZW7Ci6aCcwJ
 /3owMJD2WuhU7/9luamxoa1JguuAZsMRyZC7dUILZz4EAkY+ibeoCqsUMjk8ofW/BHwaVwLodry
 SHxYTixxcyI3DoHBPnPCZwRsVmNNr3XJ+2DytYbynX7C+SnmbUcKSfB3oKBvVuymp7HuQhFrSr/
 9gArS7oUEsm6XQB3WYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68959-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nutanix.com:email,nutanix.com:dkim,nutanix.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 7C78076107
X-Rspamd-Action: no action

Add two flags for KVM_CAP_X2APIC_API to allow userspace to control support
for Suppress EOI Broadcasts when using a split IRQCHIP (I/O APIC emulated
by userspace), which KVM completely mishandles. When x2APIC support was
first added, KVM incorrectly advertised and "enabled" Suppress EOI
Broadcast, without fully supporting the I/O APIC side of the equation,
i.e. without adding directed EOI to KVM's in-kernel I/O APIC.

That flaw was carried over to split IRQCHIP support, i.e. KVM advertised
support for Suppress EOI Broadcasts irrespective of whether or not the
userspace I/O APIC implementation supported directed EOIs. Even worse,
KVM didn't actually suppress EOI broadcasts, i.e. userspace VMMs without
support for directed EOI came to rely on the "spurious" broadcasts.

KVM "fixed" the in-kernel I/O APIC implementation by completely disabling
support for Suppress EOI Broadcasts in commit 0bcc3fb95b97 ("KVM: lapic:
stop advertising DIRECTED_EOI when in-kernel IOAPIC is in use"), but
didn't do anything to remedy userspace I/O APIC implementations.

KVM's bogus handling of Suppress EOI Broadcast is problematic when the
guest relies on interrupts being masked in the I/O APIC until well after
the initial local APIC EOI. E.g. Windows with Credential Guard enabled
handles interrupts in the following order:
  1. Interrupt for L2 arrives.
  2. L1 APIC EOIs the interrupt.
  3. L1 resumes L2 and injects the interrupt.
  4. L2 EOIs after servicing.
  5. L1 performs the I/O APIC EOI.

Because KVM EOIs the I/O APIC at step #2, the guest can get an interrupt
storm, e.g. if the IRQ line is still asserted and userspace reacts to the
EOI by re-injecting the IRQ, because the guest doesn't de-assert the line
until step #4, and doesn't expect the interrupt to be re-enabled until
step #5.

Unfortunately, simply "fixing" the bug isn't an option, as KVM has no way
of knowing if the userspace I/O APIC supports directed EOIs, i.e.
suppressing EOI broadcasts would result in interrupts being stuck masked
in the userspace I/O APIC due to step #5 being ignored by userspace. And
fully disabling support for Suppress EOI Broadcast is also undesirable, as
picking up the fix would require a guest reboot, *and* more importantly
would change the virtual CPU model exposed to the guest without any buy-in
from userspace.

Add KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST flags to allow userspace to
explicitly enable or disable support for Suppress EOI Broadcasts. This
gives userspace control over the virtual CPU model exposed to the guest,
as KVM should never have enabled support for Suppress EOI Broadcast without
userspace opt-in. Not setting either flag will result in legacy quirky
behavior for backward compatibility.

Disallow fully enabling SUPPRESS_EOI_BROADCAST when using an in-kernel
I/O APIC, as KVM's history/support is just as tragic.  E.g. it's not clear
that commit c806a6ad35bf ("KVM: x86: call irq notifiers with directed EOI")
was entirely correct, i.e. it may have simply papered over the lack of
Directed EOI emulation in the I/O APIC.

Note, Suppress EOI Broadcasts is defined only in Intel's SDM, not in AMD's
APM. But the bit is writable on some AMD CPUs, e.g. Turin, and KVM's ABI
is to support Directed EOI (KVM's name) irrespective of guest CPU vendor.

Fixes: 7543a635aa09 ("KVM: x86: Add KVM exit for IOAPIC EOIs")
Closes: https://lore.kernel.org/kvm/7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com
Cc: stable@vger.kernel.org
Suggested-by: David Woodhouse <dwmw2@infradead.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 Documentation/virt/kvm/api.rst  | 28 +++++++++++-
 arch/x86/include/asm/kvm_host.h |  7 +++
 arch/x86/include/uapi/asm/kvm.h |  6 ++-
 arch/x86/kvm/ioapic.c           |  2 +-
 arch/x86/kvm/lapic.c            | 76 +++++++++++++++++++++++++++++----
 arch/x86/kvm/lapic.h            |  2 +
 arch/x86/kvm/x86.c              | 21 ++++++++-
 7 files changed, 127 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..f1f1d2e5dc7c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7835,8 +7835,10 @@ Will return -EBUSY if a VCPU has already been created.
 
 Valid feature flags in args[0] are::
 
-  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+  #define KVM_X2APIC_API_USE_32BIT_IDS                          (1ULL << 0)
+  #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK                (1ULL << 1)
+  #define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST              (1ULL << 2)
+  #define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST             (1ULL << 3)
 
 Enabling KVM_X2APIC_API_USE_32BIT_IDS changes the behavior of
 KVM_SET_GSI_ROUTING, KVM_SIGNAL_MSI, KVM_SET_LAPIC, and KVM_GET_LAPIC,
@@ -7849,6 +7851,28 @@ as a broadcast even in x2APIC mode in order to support physical x2APIC
 without interrupt remapping.  This is undesirable in logical mode,
 where 0xff represents CPUs 0-7 in cluster 0.
 
+Setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST instructs KVM to enable
+Suppress EOI Broadcasts.  KVM will advertise support for Suppress EOI
+Broadcast to the guest and suppress LAPIC EOI broadcasts when the guest
+sets the Suppress EOI Broadcast bit in the SPIV register.  This flag is
+supported only when using a split IRQCHIP.
+
+Setting KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST disables support for
+Suppress EOI Broadcasts entirely, i.e. instructs KVM to NOT advertise
+support to the guest.
+
+Modern VMMs should either enable KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST
+or KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST.  If not, legacy quirky
+behavior will be used by KVM: in split IRQCHIP mode, KVM will advertise
+support for Suppress EOI Broadcasts but not actually suppress EOI
+broadcasts; for in-kernel IRQCHIP mode, KVM will not advertise support for
+Suppress EOI Broadcasts.
+
+Setting both KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST and
+KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST will fail with an EINVAL error,
+as will setting KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST without a split
+IRCHIP.
+
 7.8 KVM_CAP_S390_USER_INSTR0
 ----------------------------
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5a3bfa293e8b..c27b3e5f60c2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1226,6 +1226,12 @@ enum kvm_irqchip_mode {
 	KVM_IRQCHIP_SPLIT,        /* created with KVM_CAP_SPLIT_IRQCHIP */
 };
 
+enum kvm_suppress_eoi_broadcast_mode {
+	KVM_SUPPRESS_EOI_BROADCAST_QUIRKED, /* Legacy behavior */
+	KVM_SUPPRESS_EOI_BROADCAST_ENABLED, /* Enable Suppress EOI broadcast */
+	KVM_SUPPRESS_EOI_BROADCAST_DISABLED /* Disable Suppress EOI broadcast */
+};
+
 struct kvm_x86_msr_filter {
 	u8 count;
 	bool default_allow:1;
@@ -1475,6 +1481,7 @@ struct kvm_arch {
 
 	bool x2apic_format;
 	bool x2apic_broadcast_quirk_disabled;
+	enum kvm_suppress_eoi_broadcast_mode suppress_eoi_broadcast_mode;
 
 	bool has_mapped_host_mmio;
 	bool guest_can_read_msr_platform_info;
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..1b0ad5440b99 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -914,8 +914,10 @@ struct kvm_sev_snp_launch_finish {
 	__u64 pad1[4];
 };
 
-#define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
-#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
+#define KVM_X2APIC_API_USE_32BIT_IDS (_BITULL(0))
+#define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK (_BITULL(1))
+#define KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST (_BITULL(2))
+#define KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST (_BITULL(3))
 
 struct kvm_hyperv_eventfd {
 	__u32 conn_id;
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 2c2783296aed..a26fa4222f29 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -561,7 +561,7 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
 	spin_lock(&ioapic->lock);
 
 	if (trigger_mode != IOAPIC_LEVEL_TRIG ||
-	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
+	    kvm_lapic_suppress_eoi_broadcast(apic))
 		return;
 
 	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1597dd0b0cc6..d2a821420d28 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -105,6 +105,63 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 		apic_test_vector(vector, apic->regs + APIC_IRR);
 }
 
+static bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)
+{
+	switch (kvm->arch.suppress_eoi_broadcast_mode) {
+	case KVM_SUPPRESS_EOI_BROADCAST_ENABLED:
+		return true;
+	case KVM_SUPPRESS_EOI_BROADCAST_DISABLED:
+		return false;
+	case KVM_SUPPRESS_EOI_BROADCAST_QUIRKED:
+		/*
+		 * The default in-kernel I/O APIC emulates the 82093AA and does not
+		 * implement an EOI register. Some guests (e.g. Windows with the
+		 * Hyper-V role enabled) disable LAPIC EOI broadcast without
+		 * checking the I/O APIC version, which can cause level-triggered
+		 * interrupts to never be EOI'd.
+		 *
+		 * To avoid this, KVM doesn't advertise Suppress EOI Broadcast
+		 * support when using the default in-kernel I/O APIC.
+		 *
+		 * Historically, in split IRQCHIP mode, KVM always advertised
+		 * Suppress EOI Broadcast support but did not actually suppress
+		 * EOIs, resulting in quirky behavior.
+		 */
+		return !ioapic_in_kernel(kvm);
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+}
+
+bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic)
+{
+	struct kvm *kvm = apic->vcpu->kvm;
+
+	if (!(kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI))
+		return false;
+
+	switch (kvm->arch.suppress_eoi_broadcast_mode) {
+	case KVM_SUPPRESS_EOI_BROADCAST_ENABLED:
+		return true;
+	case KVM_SUPPRESS_EOI_BROADCAST_DISABLED:
+		return false;
+	case KVM_SUPPRESS_EOI_BROADCAST_QUIRKED:
+		/*
+		 * Historically, in split IRQCHIP mode, KVM ignored the suppress
+		 * EOI broadcast bit set by the guest and broadcasts EOIs to the
+		 * userspace I/O APIC. For In-kernel I/O APIC, the support itself
+		 * is not advertised, can only be enabled KVM_SET_APIC_STATE, and
+		 * and KVM's I/O APIC doesn't emulate Directed EOIs; but if the
+		 * feature is enabled, it is respected (with odd behavior).
+		 */
+		return ioapic_in_kernel(kvm);
+	default:
+		WARN_ON_ONCE(1);
+		return false;
+	}
+}
+
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_has_noapic_vcpu);
 
@@ -554,15 +611,9 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 
 	v = APIC_VERSION | ((apic->nr_lvt_entries - 1) << 16);
 
-	/*
-	 * KVM emulates 82093AA datasheet (with in-kernel IOAPIC implementation)
-	 * which doesn't have EOI register; Some buggy OSes (e.g. Windows with
-	 * Hyper-V role) disable EOI broadcast in lapic not checking for IOAPIC
-	 * version first and level-triggered interrupts never get EOIed in
-	 * IOAPIC.
-	 */
+
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
-	    !ioapic_in_kernel(vcpu->kvm))
+	    kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm))
 		v |= APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
 }
@@ -1517,6 +1568,15 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
+		/*
+		 * Don't exit to userspace if the guest has enabled Directed
+		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
+		 * APIC doesn't broadcast EOIs (the guest must EOI the target
+		 * I/O APIC(s) directly).
+		 */
+		if (kvm_lapic_suppress_eoi_broadcast(apic))
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 282b9b7da98c..e5f5a222eced 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -231,6 +231,8 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
+bool kvm_lapic_suppress_eoi_broadcast(struct kvm_lapic *apic);
+
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
 
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63afdb6bb078..e64b61091d2d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -121,8 +121,10 @@ static u64 __read_mostly efer_reserved_bits = ~((u64)EFER_SCE);
 
 #define KVM_CAP_PMU_VALID_MASK KVM_PMU_CAP_DISABLE
 
-#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
-                                    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
+#define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | 		\
+				    KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK |	\
+				    KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST |	\
+				    KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static void process_nmi(struct kvm_vcpu *vcpu);
@@ -4931,6 +4933,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_X2APIC_API:
 		r = KVM_X2APIC_API_VALID_FLAGS;
+		if (kvm && !irqchip_split(kvm))
+			r &= ~KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST;
 		break;
 	case KVM_CAP_NESTED_STATE:
 		r = kvm_x86_ops.nested_ops->get_state ?
@@ -6748,11 +6752,24 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X2APIC_API_VALID_FLAGS)
 			break;
 
+		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
+		    (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST))
+			break;
+
+		if ((cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST) &&
+		    !irqchip_split(kvm))
+			break;
+
 		if (cap->args[0] & KVM_X2APIC_API_USE_32BIT_IDS)
 			kvm->arch.x2apic_format = true;
 		if (cap->args[0] & KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)
 			kvm->arch.x2apic_broadcast_quirk_disabled = true;
 
+		if (cap->args[0] & KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode = KVM_SUPPRESS_EOI_BROADCAST_ENABLED;
+		if (cap->args[0] & KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST)
+			kvm->arch.suppress_eoi_broadcast_mode = KVM_SUPPRESS_EOI_BROADCAST_DISABLED;
+
 		r = 0;
 		break;
 	case KVM_CAP_X86_DISABLE_EXITS:
-- 
2.39.3


