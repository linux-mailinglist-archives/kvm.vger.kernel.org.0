Return-Path: <kvm+bounces-22355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1184D93D9AF
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC812284F34
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6325A14D433;
	Fri, 26 Jul 2024 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jMkXtZgP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cpHDYL0u"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCBF149C65;
	Fri, 26 Jul 2024 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025347; cv=fail; b=rsJC3FvYVHb4IFOo7Adto1YiJ828cwK0loQxTjFvmwsvd+ddKQHfgBHyNUR55kdZ5+h9gxxIc/ow3L18S0MJ1y4cYBeTo6ZVQo98cww+wvT2AO8pTe8YYrFHipSvp1EhCXB1k0t6doxfWAWDiyTPv53tJRIpygJtEBUrBLAhzi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025347; c=relaxed/simple;
	bh=kXqtAKyKpXWvBa13Bl/o19PbkTs1oCdWB6MTqVPthwQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lWJdnO67BEoW+F2kO1rH2ghH65H2IbSK9lseltJ8TyKE6ORWWKvZ/LRbtSD7WW0NVeu50Ei+NJ4nvO0Xg+1no5q8NuIEc3UDTL0gyDuZ0GER1HxvFUQupOqtX93GdhpYGya7ifhOMoXvdkQIl6P3VMfOvDmbXyqPMivZtIO2DRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jMkXtZgP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cpHDYL0u; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QJjCaV016177;
	Fri, 26 Jul 2024 20:21:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=qwSDgHOa1l1LP0iLbQEfeSr6irj4/SU4wrBCgZ/JL/o=; b=
	jMkXtZgPZKqemkPcYi6e2JzOkPAbT39Bskawj4C8aPhd3Hb+IAJrP8uh9oTFBQXZ
	9SD4wmTw36PiO7XO4bNDgk+b/6ZU2azEwFCAJqaKoJlVjqoWQ6hjHDuD29wDv8LY
	0TY28iazqbgRFgwiNwY241Ins78OLaAMBDswManGgEdPNlzJhWVr23fnyY1TLIOP
	OnoChBHY4tBZkC1k1hqxmI/DNlmM0loBGrdZDVythZya8yBv+Q1fBCKoccdwENlZ
	tajJup7zrRJZenilhOir9UnDNo9uD7VoO/aX6CIp09pa97Ae40uBr8AqDPcYyLLY
	9tVPvVModxbv+Z47utrQog==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40k7yuvj5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QJ0rDG039027;
	Fri, 26 Jul 2024 20:21:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h29vvse8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6m3BzU8IX62NUPHrGPL480nSbFBvnu5d7s682iXVTCk+Xh4DpGKRh7eOL/eUZJQW37aNIkymrDk0D0IEDH2xrip+J2kqWR1Exo2fWg6wuy/vD/Bqhh+PyXE5l6+OQzZKYrhKIk+WCFhbYi2JMDROc2QRvTlJq3WwJG0mcXJIqd2ujuyFZXjVUBQcOmwZSOpkze34spuRfOwSHPb+k9VurrJPlPEB+mgn9DVcuvqhen1qfqczfZ9HJZdVBAdeSFOTd8USg02Wh0j+lbUrQDEPS1Uyfm8G7XKoYYx/lTLEZJtijlADaIp1nywt6m1nndspFuj7TmkaHEcc2QutjkLaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwSDgHOa1l1LP0iLbQEfeSr6irj4/SU4wrBCgZ/JL/o=;
 b=srUJN7XfkvD02VVkYo1dOFRv+l0puOqnuBxN/8tLeqTxeh3DBa2JLP8tczLh3989MxfwtY4fxLTVXGFsfErFXUlHPSvETAhFI6uSNz4CmR8+x6c9yY0k7OrcITOmy/LFFHP/1AnbJLw4DOmZ1EFOSixymlgI+gOZbX/Lw5CQUUMyHLKO0e4RT0NZ5bipUouWB3utrtQF/yUqWUjEgjiQa4qh3j5Kc1C9ZNsex55nIIFOD5RvVYq3iyopq/ZnsNMrocpY03coXlpceBs1pDQo0QtNpl+AgDrzS+JPmZHrf10kv6lNQBcp83o+FG+Ddg1rC4l3Phe+lH5i+a5kb3KFPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwSDgHOa1l1LP0iLbQEfeSr6irj4/SU4wrBCgZ/JL/o=;
 b=cpHDYL0uGt9eDPPlQK7Tu1/1v8CU/aDGjND70XGgtAgc/7MD8vpd3bG4nvyMi0Fo9xSXzBUBsvAOCgO1nCwhdJ3x7/Tex7KnH5aD/sWGVTry44C9ZxcPC+nAZlJ2H+SjiC2rRbHK510IpVYWH1PptdAZLnv/LiHkEp/cqXWOWoI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:36 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:36 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 03/10] Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
Date: Fri, 26 Jul 2024 13:21:27 -0700
Message-Id: <20240726202134.627514-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726201332.626395-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0275.namprd04.prod.outlook.com
 (2603:10b6:303:89::10) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: f7249169-6d45-4e10-5dbd-08dcadb08c84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZjH2i9Pg+m1uoz4va3V/UVxkoCOHC1dyfTk1IY1Z+BFCW2BWq539/ENdaZm+?=
 =?us-ascii?Q?xpM458mSPQWnWXZBDHZTswxm+uWyEfv6ssB0QmpsyFHGrFibDUYtD5BF1bWe?=
 =?us-ascii?Q?tvyt3GlqiEkMi+sgs7QPLraiDD0nONVdOeQsK5MYBaR/Us7hOUGwKvekC8U9?=
 =?us-ascii?Q?somG6ALCKlsamtN54YxuBbtQqNIdA5BsboZDvN17IgyepyQYtXb5t8ITqAp0?=
 =?us-ascii?Q?sJqL6SwoBYZKDZMQbaUazWlPI3baksHS21F4P+2IyRfIDc4iTgVTulLSiQHi?=
 =?us-ascii?Q?oo0c+3mQ+xkcaE2v2xApO1jT3SZCkamWY6gwYdG7YeD1W0xo4rOmwL9HY20l?=
 =?us-ascii?Q?J1gYdQlbv3DQw1eb3vBjWnxk7yI3wt84ycfnY7no+aJZlIsNwxtZclvEdQhM?=
 =?us-ascii?Q?ioM2GD7bkkLYJk8EFGPF7L1xKTxXcYGFstofeaH+QNsjSZ08TgoNMsAZOLFj?=
 =?us-ascii?Q?JbMN5y17as8K1uKsg8VmXspaYVqR+7HS9rViJ9HrNYBqCmjQEA0bCeqD61kS?=
 =?us-ascii?Q?Clx1BnrRBdrnrEPfFmsGAbUUvHtBb+BmNnSF3fxljm3HdqbN1wCCihFGJnAy?=
 =?us-ascii?Q?jgmhqwdEvk4c7GhunileUpArR43AiGUybORu9gPVZZwkBUpaTa+R/6Zjl73y?=
 =?us-ascii?Q?kWFIqGNlH5YeK7CmUjhTuxc61qck8p83BTjdmjqlp8kEdowALj0cE2OOL+SL?=
 =?us-ascii?Q?/Daj7DRszA68MD04vwcQw4s7MiloT68qVL/F6nKbJKwebdXQyZhCi6zAn+IY?=
 =?us-ascii?Q?jFewQKqjtnpfegQNYP2c04Ijjlr7eOm9i788FphJ9T+zBDX9vrq6WOZJgTzZ?=
 =?us-ascii?Q?eXL0AaZRomvVja46q2rgMMzPPPhlBNzqeRQRtLU5KkXTvPNh1myfMLIAS8lD?=
 =?us-ascii?Q?85DKu66NRTUvI/wEDRMIbQHRDeEmNv+k1cBjGpmTEeOLjux+W0NM/2ZlJ2pa?=
 =?us-ascii?Q?L14BB6xx8YKBgW7stgkH9QXY2NTN4wCFkK3MVdzMDAVfoOYACDi6e7gAL78t?=
 =?us-ascii?Q?Wy3D37GChm6ZWJQId/22b/uRumN7nfeNbBeg1/ZXYbiYJZLJitpN8Wd5CljS?=
 =?us-ascii?Q?ZlDbfdB/ca9NlLnTMRDvt9Vhjn+BUb/EnsszCh5lS05GjiivOOM+tjYL7ILE?=
 =?us-ascii?Q?XvexgQe5jINCEUEX3QTNxjx+T7oNorBhtUI5c5NCLaSrg9DU3bK4wd/jUR7U?=
 =?us-ascii?Q?xgwsLtPAZt1nRN7Sy/VT4Nyc9metwQgQnm545mgZlM+L8ra5C4xb5Oq00wDB?=
 =?us-ascii?Q?BXJlcDcB9NIDAcYB/yC5JS4A1nUjQ4BcB3M/u9FasbrpwNjOYyEFFSXUBrdU?=
 =?us-ascii?Q?EdjMJrTYRjjh3qCXP+rTLTC1iJsqplwer3NBiB6ou2gMEg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MpTvoi2J0ysyE0r/B8dcKxzVhoSDQtpTFkMmNGSNjg5LYkj3EyBWtOe0VTFj?=
 =?us-ascii?Q?YP1p5Vg6FMdTdSWOCU+/daZprSO+fU5PHRg5jSxIDIxXOQDiKV+sMp8/PcJj?=
 =?us-ascii?Q?9JTA8SByPUPpQElsEYQjzPppurYbBBNeOAIeQCx11EcZRFDs9QFQ9J1uUawZ?=
 =?us-ascii?Q?e1CBoyg5KK37Qi74bx3pvj7vQLlm8MfoEFWE2jIFeorZsbknjZ00GIliF6JF?=
 =?us-ascii?Q?TpQojAmITvUTOVGd5aIltY4YB0R+fDi+63ZE24bUpGeBbtMQ0Vqr1T7C11DV?=
 =?us-ascii?Q?Dc/OdtNPmOMm7oAQzqiuDI881INnbSNZl8L/i8qdmpFaTLcYUzyuqAbr0pvO?=
 =?us-ascii?Q?lOueb9edfOoV5oHp3JhEduPA86mo+VnmbeXSRENx5uKZDAvTyPXQNy1MX65L?=
 =?us-ascii?Q?elSVH/J5HgYoeEtgDL/fCgNjE/e+vjCA4dj3h55RUlgPxG9lbEFT+IaeIgd6?=
 =?us-ascii?Q?PZrZwNFqBN617CL42wSQEedFu2LGYr7O9aadjQXNcVSJXjj/J+UCuFBaoxE/?=
 =?us-ascii?Q?09sHq1yrWamBionj7Pg1W+HR3aQvzH7lI+fR3EKBUR65nHl8ExGM4b3JI6Sk?=
 =?us-ascii?Q?GwCvBiILZEps1/EpHfZ3Ak0pEYYli/sKxoAP60cCqMhd36iRsjSdT+QDlbEy?=
 =?us-ascii?Q?wmE2aEil/oktZMcwmAs9+YzgNP+N18YFxzIrIEdo5/2rEWRzcWvz6fnBZyKa?=
 =?us-ascii?Q?IFOSOa2zF+puq5D92+GzZgQl/GZcm5w03K+71AVcMHlLWuz+LhF7+Mv6hXWP?=
 =?us-ascii?Q?gshu0MCRrkiQxqyA44tEKHb87fqzCA+3H5jBZaq/1R6KFvmHvV5B08RJn5UM?=
 =?us-ascii?Q?lf9iPtURP47ABIn57t/njag5sZM7fxPV1G961ewdUe/NUgC9isjFIjtUgDsk?=
 =?us-ascii?Q?tvOAHE+2Hh7NugXZ8DcgbRtp1q0KU81bm4DtNuD8t1q79pnz/o9k8fE5oomr?=
 =?us-ascii?Q?NQSj1oYvqO0/LLFf8aeJ7QnyatydAmwZM1sfbJO5x1Bw7CHjz0lto+DpSDSS?=
 =?us-ascii?Q?Wd5FzoTgIgKaC8t+DjSXTXR1l2CAh8nccjO9IqNxaYR8yifacbQzB31HwUEc?=
 =?us-ascii?Q?jddFmniQSHcte7uUvvaKhKAdzkGUKuROMU3tTgjdv2+CW5Nf1t/LO0oPtJDe?=
 =?us-ascii?Q?szuCG4AlO/xVcEZC5OfmPB/XUA21qq0QutLWKkEGkRbz7EHutjdVb3ou+86T?=
 =?us-ascii?Q?tIKr+IiSYiB8+LDTQCkXC6bBZYNRQDCowZoGwfkWUZiQ971y2u7GjqMUFRJz?=
 =?us-ascii?Q?PN8io/xsoHSBnsl8zmTVKKn0z9iPj4/jSHTSKgCuuW4JoE/J4WNx+668siJg?=
 =?us-ascii?Q?YQ83IrmHh5r+vZ9bNAbBLf0trcE6MmYft1U/9G2KVfAlk5zkJenItukg5Hyc?=
 =?us-ascii?Q?BQKMSCpSzRrN4piaqpyVMRpQyFSEewUoHdNuowhIxe3E7H0hyffd8M5txW7K?=
 =?us-ascii?Q?k2ASWuAfg3R8SeGvELbKSGHcih8qp9Y/qBYDBniAr529AClPywDMMip/x4HK?=
 =?us-ascii?Q?GkKRIfx2OcDeLaP6sE0gYK2tsb/gMeKbnFD8kEVmDugZrCduWc9dtpRkfm1l?=
 =?us-ascii?Q?xbeSJNDdAM+mlwZykuQYnSPISBOpebGaVXCjiv2juYvrraowuIquws1ecqat?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y6TS8sB7Dsj/u7/ww3ykE/hp2t7hgGuoTuxLxNK6bYITHBX6lPpbxi37gPjKSuXaEjJ86JPxtvkYxTQQ80VODBHWFo2PnrocLgc6LouCCajEh3dT/8rYGK7Pux7a24KJjwQEAvO0ylIwn6p0oqjGR9OHZ2lVKrWIAmCZWgS956YHLJYztTDEQNOqZ8Un6lLS/Wxd9Sq/3g7CBMpvMxV3rQzgnau81g6AE3Xz1lRMfvos2MQmT3NV49l8aOJNKGOLI7PyfXLn9+9PW0mV/G1brg181GFm97N9pHJl+NnUrtKCgY/fRRt8Sb9JwIvFo8IFYTa7gCkIcL0TyzeOWd3gbz7hk16VyVzCwAU4nIP/Lb1X31+oAA7+3tpQlk5f/9d3tn9977L2RLzySUyNRWZcsvRk2PJUp3SDWLnOg0vTUsMndsbBltTdLaLZ0eLC0XBprSIrCeqkdqmNYrH8vrq5kwfc/w/OwPw4Pb7RF7UBi9yJSC31RCi24+u+p28ur34e8Xy/QcpJWlLam+TNlzBIhPACa4jeMudG4He3VtME1kV64fObf3C6NXaK2GNJ744V1YDQqJepz4Cbdeh7erMONzwOAuXks8hR8ORc1REvGKs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7249169-6d45-4e10-5dbd-08dcadb08c84
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:36.4527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRrmaWJALA/S0K/43susPq66Pe7iCGp99EqlREet1zxWPWiYRNKXBtWzMBwyHYjlSK7YGgUIKzCkvWRafb9IhYOV+SXpMyxf2VCwD9Oh2kU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: swFHH1trryiba7FJ6l-WEI-duPfGEXhr
X-Proofpoint-ORIG-GUID: swFHH1trryiba7FJ6l-WEI-duPfGEXhr

From: Joao Martins <joao.m.martins@oracle.com>

ARCH_HAS_OPTIMIZED_POLL gates selection of polling while idle in
poll_idle(). Move the configuration option to arch/Kconfig to allow
non-x86 architectures to select it.

Note that ARCH_HAS_OPTIMIZED_POLL should probably be exclusive with
GENERIC_IDLE_POLL_SETUP (which controls the generic polling logic in
cpu_idle_poll()). However, that would remove boot options
(hlt=, nohlt=). So, leave it untouched for now.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 975dd22a2dbd..d43894369015 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -264,6 +264,9 @@ config HAVE_ARCH_TRACEHOOK
 config HAVE_DMA_CONTIGUOUS
 	bool
 
+config ARCH_HAS_OPTIMIZED_POLL
+	bool
+
 config GENERIC_SMP_IDLE_THREAD
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cf78da2ba8fb..efe59741dc47 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -134,6 +134,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
@@ -372,9 +373,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_OPTIMIZED_POLL
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
2.43.5


