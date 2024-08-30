Return-Path: <kvm+bounces-25569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B92E3966C5D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:30:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 715A728460D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C45D21C230D;
	Fri, 30 Aug 2024 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BFbQ6cZs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iB0Yg0cr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604311BCA05;
	Fri, 30 Aug 2024 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056986; cv=fail; b=vAfLakbu8agXg+pmqs6lhx9f9Kcviaeuf1b/GT+xJ4gh4Cx0TCL0mSFX6VoZ8TELRQvFk1tuWElgHd53FqPLZjqTe/UbCYFqyWa8i6qmyx11U1FMLw+j0B1REFyMSwE0kVxrgUw9s/2Pi6qzgMXOJE1MMv81BpLJaZB9exkIOcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056986; c=relaxed/simple;
	bh=3mLsfLAFCO5unkum3XPf+Fc421bTEhPSmgUCUm49wtE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sdk2H+H68yxAiEy3XVql0CwrHVgDI7W3JXLw7aRr/iRnyeTZWiBcBcjV2Ftu1Igo1XTZ4R/vBoiG/aVaKKwY00Nb5YY1iwByKpZ8kIgKDKLVGZCpHvOt8M4ioEXt1eSnz3JkSVH5CW7vifJQM+3FQsVVNiHybnLKLpMLUvoPusU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BFbQ6cZs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iB0Yg0cr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMNDLZ026847;
	Fri, 30 Aug 2024 22:29:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=dvXJ5o8iIvTtz4S/Dd5gnOY5EcavTuSun8qAuwbapO8=; b=
	BFbQ6cZsQTKKts81st1lOTfXZdNY3a13E9GxK9nUkP6p2jRZFxj0WI6oM/MzNDFU
	g8ZNBTwtRsYLqOKSDtDDVxRKmVzFK69Wf+APWU0ZxuWeavB2pSe/6Cx5yVo9Zh2W
	/g+NU2Nz/o+sj53lvMGGw70/GcuH3M2JqDQZ4fJaCR2XprfiuQDYvcoHbn0tE6EM
	YaaE0VBlwxdT0jHJk3hSSkWVMG4HoyKVIeffeDtgSJ8KHXrXjeS/pwq/gGbc0xLG
	o++3nLZKRUaZfaNNuynUsZ6tJsRkrPqZ4uVVT+4K0n+rXjCazeILJBjFFSboJrgY
	IsM8GbTW1GgEE1L4epXihg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bptkr078-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47UJXoQj010448;
	Fri, 30 Aug 2024 22:29:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894sjasm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwZ1pHfCJ9pTJEEVADSwUidHdTpFPoYtekJSx95g0GomXUx2WKSBySQmCHaM0aIp+eiFRprabXkHcroeJpPXu//hKZyalHiS19ZuEKlriJOZAU4Xday00uD0fBdnRaz/tdRCzguslcfRsjazDgR2KeP0sHa+d0w4rh1zW0L9D/dZs5EcwTNRm+KN6NWqCNOQ37uwhG9gZ28kTKaUZOBe2n0C1W+6zj+AI5hsGgFHRIhnDBtf4F3TZ0Xz3R5sYp1ExcP/hLXgervO3NTBNkWvNdNeK5H2+MtgXpwpU0OVdNN4TalvdV5zOKhG12XL8UNiBrEOS6vmWxoALGKm92SpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvXJ5o8iIvTtz4S/Dd5gnOY5EcavTuSun8qAuwbapO8=;
 b=kJW4uZsPQDK3naMnzTmtqxxGQUl94rfNdGyJmLE4ty0AR2M2k3yYpGzIQ6eC/i6y88ErBb9gWLgsfeEDfMbf466DMMew1vjc1ke0TVtxpPc7P8KC7D76E3FowpQADXf8+4kAw87xOT1SLIcSbA6tGeR7hXs9/BO4EMFEOFyMz+khFNBCmlQbhayWBINS4WPO2svBEIJN9japJSPgZyfP/zKTUFMT1FSriaLfkG2fzNSABd81QWVBwbVshqjW3fi64E80DZwQR9R2Si6oNGVSk2IL4P8HMkdRqmCU7utIBEXV17jjzusZp/TkuOBr4Trri7HQcerYPsILossXxYuOXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvXJ5o8iIvTtz4S/Dd5gnOY5EcavTuSun8qAuwbapO8=;
 b=iB0Yg0crYYJhskeN9UaUSiLeSqqca3ExwoDqfGasrUwbcOInyW9Co6MI+s/JNgtCR8FQWkw5Sn5Rt19DthF8Z1+EsZupmZdAEegeGoL+KQorEzSGEMk+W73Z6/0Fir3bJzruNnEdIb5aVJfOQBG1tQaOi16B8YrTULec7YT15VI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:29:07 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:29:07 +0000
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
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v7 07/10] arm64: define TIF_POLLING_NRFLAG
Date: Fri, 30 Aug 2024 15:28:41 -0700
Message-Id: <20240830222844.1601170-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0037.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: aaddf99b-9d94-40b2-3c4b-08dcc94328d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JfYKV4OUWuM2MOcG6GELAEUyXkqM7wjUn9LMSVmXeB8xHZ+/0t5jSirMEdgY?=
 =?us-ascii?Q?TmgWoL0PGbvibFxhh0gWOPwt5eSbVB1b3j2TnkVV7cnMxpJao4X/5fXJyAjg?=
 =?us-ascii?Q?a+rW+/fv83r0tJPhtFfNW7la++LZNdONS0WWPDF2K8cydBkbayUPASQbiolo?=
 =?us-ascii?Q?kUf4VkZfM8Dw5E+bngkKtu6o1yBRGzBD3sTGcqSOs6+5Y3YXTiuEeDnvuSvS?=
 =?us-ascii?Q?iuXIUo/YFXTADnLOLqmBKQ6WJEEM6oriCPBEb20xvcj+zs7ax1IXejo+H9wC?=
 =?us-ascii?Q?xeIGsf7ZbPtrWbG2qn5TCuLZPm8Is5gAeOxW8q9WK54ZD3Nzl3CD/c9Zmsvu?=
 =?us-ascii?Q?rJ6BNoyXYgiAl2r9/sYsE1afbbPtpojSEND94JjZzk3PfNWgarVLwR4AHtSE?=
 =?us-ascii?Q?gGDpBFDf0Q7a6u9ILreE1OOtQcv3DrJcJ/gqJfHPILJsvPUneI/9tC/JVCgm?=
 =?us-ascii?Q?XP+Fs9LIWFjksnE52jDeP98zQxy42m4VfrgB6PpJfegxMnnjcrOzaC/C+DY1?=
 =?us-ascii?Q?ZtURyQcMe82oJ9it6Np8wRIjqe9Zp/rl1O7RwrlJl0SaZ0O8Zt5txaGR9zUu?=
 =?us-ascii?Q?rDbdZzsDh/3jlIbyc9ds5XSy9ONHBSg7cMds2Wy4ePsHEEdrWx3f3RP509M8?=
 =?us-ascii?Q?V13bFyhnKwT3rjelXs9AfwogoZnBWolJwA4fAF3sHesQmeKU8PybKWkai+CA?=
 =?us-ascii?Q?ebfHyrjLCbyVUUjR6fDlc4QhtksyQvsC3raPAisvWj6ZlAKAhCq+hdXgH+I4?=
 =?us-ascii?Q?8mujZ1WE6vVVdLYQC8Ua7JL3JsXkba5GGu5QRHxXfAZy0NQfQ05/yLZnPEVV?=
 =?us-ascii?Q?yeN97p/qaxCqFMDUCbRtK9zfBB3MLxCzE4X2FwYdzkhyhG3CQbisefSAJFod?=
 =?us-ascii?Q?JqKJRJZGnmFp3Gt0NZ15rn+08t243fcTjSpX65zPS24Mi03VbeXApIehhhWT?=
 =?us-ascii?Q?ACQGw1qWgKcQ3k9rV01ipRipvValSJwuLSCNS1lyCpRQX994cMTJBH2+8t/6?=
 =?us-ascii?Q?sP5NCT7gBRs7ejRhZBPpZIBzum+qOjbiwi/dS2PE1s69e9xE61jhmsxJzKb6?=
 =?us-ascii?Q?xs5ttt6GDBPtaLGEKOzozLM8cOpNRhYT6vqRNXDiFctAAWv/AhsIEsxh+jBg?=
 =?us-ascii?Q?XrhAtSxbirDdtZRfRYtqevixpzB8beS6IMtbqkoq7xFllGF9ra7OOKSPSd8B?=
 =?us-ascii?Q?kgjteRgLUk6t+Hb/vTJ0FcWvQg/VhJcbc8y4zv4Z8dNNhN04Cx/Sf1eAvYw/?=
 =?us-ascii?Q?7UJvm4Z4eFHW65D60+5F6MBNBc8m3g9ohTHh0OSP43yu9sXzY5xJbP+6idEZ?=
 =?us-ascii?Q?0dc2gRPSbh//dvn4nPimzq+48QAnZicbko3HiGHAzRT1GQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q6GqcyaJvpN1s4fQ3S3pRBXZXXryvXH7fGryesM0frz8NxL+S6gxDPkyik3S?=
 =?us-ascii?Q?BrGZQfJW0aYHuEN4nBxHaBz0cUKntW3vumm+XGarRQ5l4e7+WofzQ+ZK/br6?=
 =?us-ascii?Q?PzCY2/XLBTMo6KPnL5U9TFuJN2msuHXl7Ow0ZLFFJtATPBMQeyIZEPtFkA1D?=
 =?us-ascii?Q?wcjrJa+tdVaA4dzx1bnvZLBsd6PJRmAtR3MVEts4SaUn6gCdhRDHQTLqB8rK?=
 =?us-ascii?Q?k0TTwO0dQSl+CAi4oTcZfK7HLNABXdO5ifiVCmM/JkR1T7EeIJRS5b2RvRP+?=
 =?us-ascii?Q?HBhbYIsNpT3nzCnIEq0bHVyqpZDKMV9DjYW5leRvMFgmk7hkcKUakPLyekaX?=
 =?us-ascii?Q?RVJ+SN0iTa1qzZcrQWvBOa1MeC1aj50U/ffGZLvivp0UA77BhmzfYDBLHAwl?=
 =?us-ascii?Q?dVdFeqWNUObtkw+2eJE38oAiRUlIvpI0fLouvQbUpBK7UqONSs/LCXKS8nbh?=
 =?us-ascii?Q?gJBY5O/nqUmi8usHrG0mEAZrV/A4vx75HGBiMRXvy03Quy0kgLh7KJYWFr1b?=
 =?us-ascii?Q?SzTsb1HAuFkq/wzQHGCd+ZhnUPq9B5YjyQAyh+Z+fo/91cGJdz+w3hAjMFF5?=
 =?us-ascii?Q?9tTEkGPeNrxQUXoeBLsYDoS1BiRLVjrWAhTpuMpMkrgX4hzrVtksV6xfOwIn?=
 =?us-ascii?Q?1yDAFBvgMk1CP+RauPG9MtkqStHTcrmd7gfre2sbSCctkx7SU42cp4WQiFQd?=
 =?us-ascii?Q?9HcbPf1My2uvfXJPeB9ZvvlrCPcbCAhnWCQ73F+jDJ6R0eZqjM8ODgsE/M5L?=
 =?us-ascii?Q?xGa3bFh55hjHyPEo5mssBnw5xIegJctMemskaJSnDViSUUbwL9csBAEoBPqK?=
 =?us-ascii?Q?w2p+NXgk455UGo1gJNo59Ulw7wase9ptXq+CNqdub1LdPP7pMNfESkuE1mDw?=
 =?us-ascii?Q?HjqHXHPrAv92yp8HUXDfcwFfI2tAcu9iibxt6HGcnztMBtist0/0rz2YsDfu?=
 =?us-ascii?Q?BNj/iZhjJjcCSpwx9R1383DbNON9hnZJJARZ7P1/9d0XUNKd60p/yMoYY6n9?=
 =?us-ascii?Q?Hkx+7mIT839wkcGBllWa9uzYehnGFcYDNrYv0XDyemOq6ergT5lh0BMSXFOa?=
 =?us-ascii?Q?w3sIps0uj2lPJedH/de0I9K1KxvAX29oQYPjFYqLYKleKqcjU1J2xOHSADFR?=
 =?us-ascii?Q?oRXPeamqUSP3HPuKziyhWWXE877/2pNsDkzkklx6B9S2+U6xzAY5CUN3MCFq?=
 =?us-ascii?Q?YztonPq2s8LWDXlZ/iEiTyr/FpPhUcmRloPCgA+YD2jPgH0LDotTmUgVSy/O?=
 =?us-ascii?Q?hXXhrwvuetG10Gc/AtRkMPKykserTTU3lRhuRqAKY5UGrUCH7daGIZqxiKXY?=
 =?us-ascii?Q?JclrCRfc/sxKtOb0dZmObEqhPkuewBjYVv1Wqbl/g3ZQAdj0RV/djEYFMnJE?=
 =?us-ascii?Q?vOL9YBuSwIDBGDO1S1gSWh5bDwdkYonyXs/ZbHn6Tp11EgYod0+YRPihZX3I?=
 =?us-ascii?Q?rV0rfJ6vEw2X2J99JIQ5K0siyjQnultcyeBFLhR77ArXdNy+j4rI3x8F3ixQ?=
 =?us-ascii?Q?v6kDZ9FTiRTCMReIIHKxya4009pQOSNQoBetOrSiZXHu7OlImn7CDlw89Ils?=
 =?us-ascii?Q?vnCrC5ubgIB+/gdPsHS1GRZ/MKtZ+f3+zXiFQtzJME84DduKpt/nzxCQ9aZw?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LKQ8vngf5XKS/EUHctOQTmPtyY8iDNTLZUIUkpr9MXSPCD/DYkM1rVfO5jUdjZVd7FpJHoGqkFQ+EQAuHt9tZ+yB/uP5ruG7BXsVCJhEGzZGaM3hDf09/1BDt5SOBObP08NdB+sbBzkGi0/e05i9BbZQiSyF99BCX7e0PLpjRjw3BIwDnSm16C6t+GFsDucMX3qeuns0+wwJTm0n/dTSAB4DC1M0Yislm6rg9FCyUyRyTaxJKufApB5YvzwNOWB1sMnfaIGV+OIsjVM8oA+2gmUjTjPGJZFHbBlqIiGcBTKyvXC4/uU4wF39pXGdkh3t0s4g9hjixrcLnrwY5qz5/DcrF+pBz8XSMhM8hpJXKAJ5HYxK83e1DkEYOnDrdurQ6ZZoZcqcqATNzgfzdhJmu5xTlWXYSkkOjNXBKmINevyI9pEnhyKdLbuvZocz7lWuESEM1Ks45nLRpSKndm2tgl8dhQPUY25QzlGh25Z+I+NXI62yW0N1j503OTa9Qt3F3YA8gpblGJ+lmsuEe8zRUwQllcJYfqfvr6z9/prOFBOKHGPbIj5BlTDY3MdiwKfWGnLU3MiyUMYTs7GAiKejgnGfgjDpL3cL55qai8ClN/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaddf99b-9d94-40b2-3c4b-08dcc94328d1
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:29:07.2172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fr9O8Oqy/vaBBRMJnNCYWJZjP6sEdc+wGFqJknpuxaW9LQDaj+qAj25PKO66HrW3EySSy7OjgFriQofILBs5uKDKb0F/Y3xqXdnGMsF9lW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: 964dIE4GIsVRMxIkxXXjcBbECLNVktF_
X-Proofpoint-ORIG-GUID: 964dIE4GIsVRMxIkxXXjcBbECLNVktF_

From: Joao Martins <joao.m.martins@oracle.com>

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
cpu_do_idle().

To add support for polling via cpuidle-haltpoll, we want to use the
standard poll_idle() interface, which sets TIF_POLLING_NRFLAG while
polling.

Reuse the same bit to define TIF_POLLING_NRFLAG.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index e72a3bf9e563..23ff72168e48 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#define TIF_POLLING_NRFLAG	16	/* set while polling in poll_idle() */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -91,6 +92,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
2.43.5


