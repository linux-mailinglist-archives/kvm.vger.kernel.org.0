Return-Path: <kvm+bounces-33819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB1C9F1F1E
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 14:46:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFE587A056C
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 13:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 992DF194AF9;
	Sat, 14 Dec 2024 13:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U2bT4TL/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OtlDpJy8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3A41940B0
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 13:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734183989; cv=fail; b=g1qcUQBeEBKjQLCprm29BqWFMzQSeUQ6R7cZcR+GEGqIvyULfIyJoKw+a7US10Tp5FGUJC6h0Nu56aeW4iikgU2CV6YAkiRkFfYyrv2NR2iyN/LAyONoapjLkijf71HdPCL7fy/ITZXaZ7x407Eje7bx75yKVtXrr3d9zlM40jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734183989; c=relaxed/simple;
	bh=oiB/ESeuUgC/Xr5waVMiOY7sQov7/Mh8zMg3E2i/zTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dMu3zmB1OCtU2hgfBIrciJ4bmNYL8zoQcNQgNqTaxyBxApU1X6DHkmrz3902u26+EQd/1XuwpvsiCk7UNV+qxGfUHFgvl2B+EnRcbMApx1eGBoFvq5Uvk5ZyAcqLoN+zwKxEKP3FEYv6CB2piRD/8R19HvsAP8vOZgseHh3Jjzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U2bT4TL/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OtlDpJy8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEAXNPw029756;
	Sat, 14 Dec 2024 13:46:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=U6mctM848n0Yl1rSK24XuQE3Ix9mH32JqdfBFct/Qek=; b=
	U2bT4TL/SVeKUF41rOa+lJYK6cbGaAD0m1quTtOSJYBEicSMOIbeZNkZWVfzxJO1
	rLR/m6Gkyyy5EYz/JwwvnlKHbu/Sbgul5Ny+ypwujbmUhgA+PXhHEzKDPkIvCh2m
	XIw/14oTdyOizDnWnDH8PPrprTYYERsNTCipcAh5yfzvD7rWuq1iUzcGKhvOE/YC
	CDUwGH7dYfFNXTJqN3wxyVug7u7YXm2iOuGx69inPMY5I+71JgQNsiW/tWz/hgDW
	TkXF4oGsUJeSSKp15QqI7JpJr4qQ43DfdB8OAt53UMGXrRTIt54lqhlarNf/0IdC
	dZCGiGDhgGccyLnX5DyrDw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m00gh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEAHq7F032785;
	Sat, 14 Dec 2024 13:46:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fbu0px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bEu1BreJLSeI0zV+S6ysN4wLmUMC3A+Vk2Yw9mxUVlsi8llSeV3yI5AdXF+cQdzH6mUMd+KDk3ZXwH6cCZY0wm68cus1CdNvZ+Lkptrf/c4bpYUwjO6JhLJfvhhFD+qtTBZeU1I6o6tSlIlbMgspGHeuSkinJkdo4hy9pW91r7u5Mar2xD/Zmo9j9N61OXAjw8oTOlTL6q6HZwyuFQURxsMKDs1riCSvw2vDR2toUbNn+fcYoHkfUIYzNBEXFuq8L9C6b4IIxAQ0B8CXE4p/4Zi3vCiOf/obo+edrKW7pziORBFk8E9vPp8U+xWSBZMA2Iciqk+OfLFIdBWyqqg2cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U6mctM848n0Yl1rSK24XuQE3Ix9mH32JqdfBFct/Qek=;
 b=T64nxhzAFx8yrbPsdUe1Ue76eKQSa+lx/3R44jHUjco0UmaqKSCQND8AqDM98h6XFXlZbEU12Dxcy0h7G0KN9W5+X7Go9OXTtJl32Q6hcCHd97SQViBi5Vgm14oW86F4g/SNnZ4z5EDIpTjnpr5ujYNGqYtDgNSakfUU4cLZJuaa5Q3kVN4fozFgNRt/RTjt7/UkDHG4UmBkonmBwheSHCcPfaNdDpOF2T5x1ZI9mpoVW1iz0b5LSokKBfRcMDPpmAYXmPZ6kUsfK34M8qjdYlhERbtEZ+J/7z9zlZn1gdrs6y+ceVK3dV+VUv9zIcmyqS0DOqpFhpKIE57Y23dfSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U6mctM848n0Yl1rSK24XuQE3Ix9mH32JqdfBFct/Qek=;
 b=OtlDpJy8APh861HqmlO/9rfDkn9G2F/EnL6ChqoY3w4ZHyh+SNrNMAPf598aH64ajdt8nHhOMZbj3vJoWl/4QukYR4uLsf56Iyq4AxkS5GRZ1hOQMimIUGf6yqXQr9zYHjVsIG261C1jq5CHjAozISADfv/9wyUhtL0V3Oy8G9A=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.19; Sat, 14 Dec
 2024 13:46:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 13:46:04 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v4 3/7] accel/kvm: Report the loss of a large memory page
Date: Sat, 14 Dec 2024 13:45:51 +0000
Message-ID: <20241214134555.440097-4-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241214134555.440097-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::31) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: 86686eb3-118b-4f1c-3b70-08dd1c45a72f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?I6+E3mFqhmPdSjssLFS0YzI6YIaiwqIeOji0m+ptCltUXoykUDmEaLtbQ4oB?=
 =?us-ascii?Q?5a6mhszDQHVhX3lHgLLfZGFm3PuSKD64EKUDk+lhoy9BzgUXiINzk+OJXKb4?=
 =?us-ascii?Q?1+pRwRngZrdTiSu9gQzA2XTlvxTUv4HBvIl8CJnoiyqiXAENWgKpiewpCSz5?=
 =?us-ascii?Q?tCM93iooH09RRszkuqLsPacs3SQxm8JP4046KiWnKOIdKvAyZ92/UCT/smDV?=
 =?us-ascii?Q?vm16wL0GR6ELjimojggYF62a6xs2U/5BGkELMAovOQPLiFkvuX6AEenNj+wt?=
 =?us-ascii?Q?T4496+NweK1w0JokydoprgLIb7ba1na7sefvKg93V9gr6/SpDFMZ+oJFveGQ?=
 =?us-ascii?Q?VNarkcM3km+baYEgo2b8UtxDJvF+NlSAjrH9W+a81sb0DeBnxn63LqZKfZC1?=
 =?us-ascii?Q?wlDv7gWYBGM9vtZ1AHTF42HBQIEmBsUfN1nWmbdIqimlYM2WXMUyLKBhYQ3K?=
 =?us-ascii?Q?KkEu6S2n99SjjKf73v8y5YxlgllAyFp5c1gX+huLoNoLHJf+RuZZKsVO1TnM?=
 =?us-ascii?Q?MOVdzVW8O7deOyYKdVNE7h3ECzVffAcJWpOOmz3KutlQWAlE8gXIZCa7ek0C?=
 =?us-ascii?Q?413O1EYJy98LplEtYFpysvlig8SWZ3AKzVrkamQPh0OXFxwWAWqEwFMMl82i?=
 =?us-ascii?Q?gAh/+jXFoTdQ19Otz423FUOgMK62nHsxulhA8RT8DKY1mdaO/FCRO1IJfDfe?=
 =?us-ascii?Q?ZNKLmzHM9ZQA9zXZhpXD1ITRKqPr8fn36sjjHVyq05Q2oaNUoGkfD22W2n5i?=
 =?us-ascii?Q?PDfqlrzvD2cV7JSpIe+qMEigYr+11E2gqfQ4gGkTQ4ZkqGueOvqJ8slQ5lZl?=
 =?us-ascii?Q?ZciklBRt3ZbCjYyBxpkbtoLa7i90Ftnge+Qhp7u799h27w+IEvzCe0EOl6xe?=
 =?us-ascii?Q?hADNKDOdp8YZYp2bI4vfE4HbGy6JmXqRFKIQdc3KZK3I1rPOGb0gKj8mWd+H?=
 =?us-ascii?Q?2kvDqdJOdQrsasLynwKPKc6T5HBMHLpAP5mqDFLYrfZfNZLE/THREwUpMdLW?=
 =?us-ascii?Q?FOle1gAa711YiW8prmzPbkum7G1vs9514FzgIVvyzphQQbfXqFBEw9qDkdwF?=
 =?us-ascii?Q?Iau/rlHR/15jEnkRPjo0DLun1UgK3XkIGByQbmGOoA+Yz6ICvtoP5WEjOE9s?=
 =?us-ascii?Q?h5ABamO4fiHdNgkJp+kITHk5Phsah/3osq8HYaCmBc6oOCXqGc/6mk89+OVl?=
 =?us-ascii?Q?pRSFHCpEzy0QSYomkk8wjb97TeNQUQ9Vdf2LLONZgbvTYSuxyjzyl2g0WBSF?=
 =?us-ascii?Q?/1PaJi7eZoPluMBTTDjrqIuUT14gyFmu9yu2dsfbbHRT2aJgpuDaf/LuYooC?=
 =?us-ascii?Q?HhhQp0uwDWtw3nf+Pp/ZGUH2r+OnPLvGDTxuoH9zjjaQ7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s2606bq3duWUyoQSVAdj1lqGYJyiX9ufiL1vzF1NSft7aXo0JU2P/mrj0ngl?=
 =?us-ascii?Q?x5lSVIRbCOzSPJQSg9yOG2f8qy2AWAG73kFGAPjiHQnEWNw6T/0ccI3BMgoT?=
 =?us-ascii?Q?s8RpUjCDhqt+J3UrzJ14oko3LE4vcgHkFE30YgBWMtMVdcz4uQhRysbzi1jC?=
 =?us-ascii?Q?LOW82N5KhTCBOzLKcslYH2hKf5/zQ+btXZzbXdt2F9uoViSq5RRLEkudicKc?=
 =?us-ascii?Q?lieEEPobPbwzM/vhpkslS+rQkx+YKqp9ThxUCjybCkl6Hf4zBYY/t159YoiQ?=
 =?us-ascii?Q?Ahy2yedINwh6YTeFDAV/JHbugUuW3GhFP4d6vJYWn+bYysL3sL6qc1gAf00I?=
 =?us-ascii?Q?d8Q2WrRD8AKEa+ihmqxpRLnTm69W2iv4VkdYZmLfu5v/j2yEy3bJt0uyNiMu?=
 =?us-ascii?Q?flZ0yjp1mRPjE8tit6GweO/KLnE4RwHFHn8zAOanuaIqkRdze8kyCNXg/6oU?=
 =?us-ascii?Q?2THWtU5pYg8PdKcWq1Kap6SQ9eeDOG3CKFtM2r8UoekrYYdAT5XZBrh4dYoa?=
 =?us-ascii?Q?JAYnGlUgXttywHWd+wL58R0K0N+R7CijANiOL5lFWOgTNuxzRSM+VXs/HyZg?=
 =?us-ascii?Q?PLXdNbRJKZt1zmE+NY17bD7SC1qTqtlVHyK2gmXvFIVtQdhTJ1B93tIphn2Q?=
 =?us-ascii?Q?fZB2Uloyp65QEK4AHbMof7jeupu2ElEZYDf1+wNu3NyEfrcKJM36aDkMXq6V?=
 =?us-ascii?Q?vxrGAfNjlDIww0A7pUSnW3Bi11rWXYPbcDP0m8EG10TxUHPBgoew0bWaV8gK?=
 =?us-ascii?Q?YCH7UP0BBHHAF0tGOSWwsx1XbSgSB7gX0NLdAQO8daoxYEaNj18WyCeGEt/f?=
 =?us-ascii?Q?Ed/3axpuRN1dla/8BXDGojkscxJYcjVlez8v4dZoHfssNEEG+eIsudyTi8Q/?=
 =?us-ascii?Q?zRqLEZ3pIln2Gc+6RXJK7no3leKC9aTzbf0+Hm4cEsl0CmnrCiWXNPWf6CZP?=
 =?us-ascii?Q?vX1HcqvmNf240J8DQUmwMEx23V+bp4R41K4YPLuWDRAtZ4S4buapAHhE+QP8?=
 =?us-ascii?Q?HJmYU6lf44QZbfYp6RRieZ9MczDopas2dX5h3YKGvLWelZJOHo6H/lYaE1es?=
 =?us-ascii?Q?eYylXZT+RBKoU8TC9ZCMQiwV4UQx92MJyrLc0/f988e/X7KfAvuUDPotuLej?=
 =?us-ascii?Q?wBumbaAGZsaLWhdGN0+EsR1M6LNDu37ecY+wRWZWJ8CGTOV18YM4jFxIhgmT?=
 =?us-ascii?Q?bmX+OF2Km86S1Uj8GR6gv2wznp9e+IXEyafw0bq5k75SQCGzg4qj8+12MbbH?=
 =?us-ascii?Q?Gxaj4waEOPKljvFnn89+v6TTVx0dM9r2Rx/Hs7ncKD7qoJmkz9hraoO0ivPp?=
 =?us-ascii?Q?6NBLBNNtbeiyWortiO39qxBrflVDrAhvnw1PenSZ718Cv5/qFB6Zsf0eGjGY?=
 =?us-ascii?Q?mqTrHxCOV4K96azUxesXVBydcjEV5/avrOxHlDv6kRclN4p6pFyF8daXhFOa?=
 =?us-ascii?Q?r+NrXhJkxJPhwO8g2iHYE/vDiZ8q88fWuySe5r+Dr3YRghNrbg2g9zJ//VV5?=
 =?us-ascii?Q?WxhfmHLMy7RhqzlDWNjIBlFnWHlOxpxqCaQyKbAdj4VsL64cZZdcecRx3yOq?=
 =?us-ascii?Q?YFuBgNU9apaRdYPGWGN/gvA7jnJbEi4JhA3yDg4XN4Fmlz3sWNAodERSgzaM?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cLqo+3WHmw2BsqE+ZuuQe4V1jde8SI0jJaY0CXJZ0cVX2hK31UvOF3TtJWN6RFc3rW/feenC/z1ggjm8w/arikCL96mHR3nTY9oDj8CWFc9LJDIJCHOuP4m1Ely/PTzycekqvrjCg/0VqrP9+pAz/P2UzpoQrNHOJISF6EC/L9vV7xGMAwIWfLtftI8GIqSrV/js/plJ+gms874cJ7+lz2ZT5yMBHhvxobfSIPxuCNcwbR58yC9ggjN5u9K8ZeY536puYURh7Czwi6KSPm4FVBTAzsSVl+V2lGeHedrcoEhl0WZS9x2gTWZRsxXNFxv+ABDjMzRrEVbSoDtJlcGlCmNBQcRj+M9qOFmxYmCPZeZtUcOe4XrtsCtsB0UWqV2bMEM8S3p6zXNeRvPrMc2FIfSiYdMiIrCB7Pl7y+EQFD/9F6LSIaLTN/hOlFNDeUnb3PFU7jJWkfIMspb7s0IF5vuKJygYHGWqXIh0kyhjtrGKoSq9A0WrsnwXmdLHs8+Dtmg+DbOvTVwibhTrs22/pBRohsaTF7mmd2oGeK9RhMKqWpcZgmwAIhlOSKvUZwMzcayIacL3hCG9OBxZ/MNCNqDz/ExYsiurIzbj3+MA6OE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86686eb3-118b-4f1c-3b70-08dd1c45a72f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 13:46:04.2055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8t8rWoRFOyiIcNQUTo3VHb4fGC6eS5EGLapPl91Lj34+AY+db5LHfIPORZBpyR9vit5e5x3oSWRyiQN4OlKjiGjoWBEOMxwa7yJ5yEbl/68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412140112
X-Proofpoint-GUID: Lp4OnKD73M0MaYLYg2G1uVd282d_a7My
X-Proofpoint-ORIG-GUID: Lp4OnKD73M0MaYLYg2G1uVd282d_a7My

From: William Roche <william.roche@oracle.com>

In case of a large page impacted by a memory error, enhance
the existing Qemu error message which indicates that the error
is injected in the VM, adding "on lost large page SIZE@ADDR".

Include also a similar message to the ARM platform.

In the case of a large page impacted, we now report:
...Memory Error at QEMU addr X and GUEST addr Y on lost large page SIZE@ADDR of type...

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c   |  4 ----
 target/arm/kvm.c      | 13 +++++++++++++
 target/i386/kvm/kvm.c | 18 ++++++++++++++----
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 24c0c4ce3f..8a47aa7258 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1286,10 +1286,6 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
-    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
-
-    if (page_size > TARGET_PAGE_SIZE)
-        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7b6812c0de..db234f79cc 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2366,6 +2366,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 {
     ram_addr_t ram_addr;
     hwaddr paddr;
+    size_t page_size;
+    char lp_msg[54];
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
@@ -2373,6 +2375,14 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            page_size = qemu_ram_pagesize_from_addr(ram_addr);
+            if (page_size > TARGET_PAGE_SIZE) {
+                ram_addr = ROUND_DOWN(ram_addr, page_size);
+                snprintf(lp_msg, sizeof(lp_msg), " on lost large page "
+                    RAM_ADDR_FMT "@" RAM_ADDR_FMT "", page_size, ram_addr);
+            } else {
+                lp_msg[0] = '\0';
+            }
             kvm_hwpoison_page_add(ram_addr);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
@@ -2389,6 +2399,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                 kvm_cpu_synchronize_state(c);
                 if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
                     kvm_inject_arm_sea(c);
+                    error_report("Guest Memory Error at QEMU addr %p and "
+                        "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
+                        addr, paddr, lp_msg, "BUS_MCEERR_AR");
                 } else {
                     error_report("failed to record the error");
                     abort();
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3b..336646ed61 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -741,6 +741,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
     CPUX86State *env = &cpu->env;
     ram_addr_t ram_addr;
     hwaddr paddr;
+    size_t page_size;
+    char lp_msg[54];
 
     /* If we get an action required MCE, it has been injected by KVM
      * while the VM was running.  An action optional MCE instead should
@@ -753,6 +755,14 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            page_size = qemu_ram_pagesize_from_addr(ram_addr);
+            if (page_size > TARGET_PAGE_SIZE) {
+                ram_addr = ROUND_DOWN(ram_addr, page_size);
+                snprintf(lp_msg, sizeof(lp_msg), " on lost large page "
+                        RAM_ADDR_FMT "@" RAM_ADDR_FMT "", page_size, ram_addr);
+            } else {
+                lp_msg[0] = '\0';
+            }
             kvm_hwpoison_page_add(ram_addr);
             kvm_mce_inject(cpu, paddr, code);
 
@@ -763,12 +773,12 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 error_report("Guest MCE Memory Error at QEMU addr %p and "
-                    "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
-                    addr, paddr, "BUS_MCEERR_AR");
+                    "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
+                    addr, paddr, lp_msg, "BUS_MCEERR_AR");
             } else {
                  warn_report("Guest MCE Memory Error at QEMU addr %p and "
-                     "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
-                     addr, paddr, "BUS_MCEERR_AO");
+                     "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
+                     addr, paddr, lp_msg, "BUS_MCEERR_AO");
             }
 
             return;
-- 
2.43.5


