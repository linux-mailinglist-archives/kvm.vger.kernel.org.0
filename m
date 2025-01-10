Return-Path: <kvm+bounces-35116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1785FA09CDE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:15:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 45BBD7A34CE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8D97216602;
	Fri, 10 Jan 2025 21:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hfUJbl5m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h86iv37v"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56C42080DA
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543682; cv=fail; b=quXw6qM2v1jg94vTq/geL+O2d0h1kIAULCiarAevtFAvD72O95MREnATUVjlXEGWMc8PdjHNbxNdai9d3tHrcBOfABat8pMlMfuf3xOMhC42Z2tE/hjHugrVpxAjRxrvd9RqhE9enCc0/3xluYdqUdssMwvChitw70LHcuZN/XA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543682; c=relaxed/simple;
	bh=A0Qmo05f0E3O8ddeZIiUCeSJzvbOxgmhlR1GM8mZZZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VEVOsIosgvmBkfsyzg9J1JDrbUfi2SvqMxfi2k3dFrfUwkldnVxsBDuE0JYdcnrZgcjdDWxs0Z0gS17izh2zRHMjNzsXC7F/xnEjjoilKrhwtPUOrfbA2DRCCl/423hH9imuHwuLcf0OJ9zKDV3q3R9cTe3PuJWGgx8sHvcfqII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hfUJbl5m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=h86iv37v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBwgS022287;
	Fri, 10 Jan 2025 21:14:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XA+YfyyP2ahjv1kQfv3vfVQbur2dA5b4IQFKn15BJe8=; b=
	hfUJbl5mluLKMSW+OQIncuD6qwtJcDWBjNMg7Pkqzl6Cs5H3nWFEQ6TbBH3tbgCV
	xt8RJftlHGTmc3heVscPCcx/G3VT6jFNKLuoZp3gP9SjUVzUAacEdPVXYP4oJXlM
	C+aZ41P1Dxca8cUjM99CzdlwdnJu5IO8G6K3nT/OBwE5mBd4685qkfUgm+a/QWEI
	q0XnTF9WG+2P0FQxTE3kdfGngY4SHnw5rvNjwdpPoMvlauEcxLFZqQ2oz8tLLy0y
	ZuogUV3RSE1lhG1go9LgB0fPDhvKXVuq/kywpeNDE+AkukdvI+Wqz6pJ63nFwC+0
	sRpCHz8ARtX5Q3n8G/z/4Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xudcc0ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKIpL8004868;
	Fri, 10 Jan 2025 21:14:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecwpwk-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lVpnebEMf/Igd405IB8eX1z6R+j1qmZ6yM9bfbyhH0BG0FnEvIJlraPcLvxuYCglm1DKr4twQUd6Ga0Y571z9heZiSvV26hYddIjGVCq0d1KdyyUwQ5JsRkAGoiemWB5Kbs1mfH5aXGmH1AUxVRiOoBtUS2XhVAF6//j8rmElUMmGTbM6O5QWHdeprg2/I73FnLw/cEub4U7PS50Fdj8Q3uWvAtQaK1tZav1x0IwHuRcwYr0oEc1noadZyzuaSaWysLCcrr6Pl820ks28U+FwEhZDHq3F3DP5w1xrfYtbdA0G7OVvKgXprC2y7DvBfBIF4pMCOourn6AuJQ1hYR4MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XA+YfyyP2ahjv1kQfv3vfVQbur2dA5b4IQFKn15BJe8=;
 b=EPqNEriioPt7D7xz7+7QTj2z84p87jtdrvrYFfq77blf4h+EUvjnVFrI0X6gGyXTF1uRUMj3PdMyLQ5jX8SR/+l5H06CMnEnBuy5hlR25TXL09cJnMXN2tVNCQeJR5EURdSduu1uvqi+YrkyllZqlVxH7DLQWmdFnJIDZcSyeN+VTon7gMR2YFddb00giCnKRSYyndssokzBvxw8lRxbtLVRABPEtEdEH5yKydB9VsiSHLor875RR0fXvS7b6FMx7+/muH5+Shh6u0y6YVs7SAW/qpAMNH5Ei3HCPqaDDWH8tHF/JJHRbtahVleERJSCU7Hj4IslgDo+pc/1rtnFbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA+YfyyP2ahjv1kQfv3vfVQbur2dA5b4IQFKn15BJe8=;
 b=h86iv37vaLzCYp1Pc3Uyzji3B0+P1BXGgyBDCaDI1cyMD5ANiMBKF0VdiTPWz5ONLMVni5RnqF7PdhuHkk55lsYLW+huwHjYphFceRjpJM/nyaXfB3omYwqKaNdP01IRszwGGETuta4uAQVpNTKX+k0UXFR+cdIIOgD1vRgF0A8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 21:14:19 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 21:14:19 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v5 2/6] system/physmem: poisoned memory discard on reboot
Date: Fri, 10 Jan 2025 21:14:01 +0000
Message-ID: <20250110211405.2284121-3-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250110211405.2284121-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:208:335::21) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: fb49d750-35f6-492a-1026-08dd31bbbf5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cep5gbPFmetO5kXbtxDHtSqhIQNXc38TSuuaxqGEdZnzXiBV5c+zbigySA1f?=
 =?us-ascii?Q?ZDXscker2qQrU0GKBwiTTvwa3LrxxOYn7z2GD1RpGhgRPHmIGa25hMytQMYZ?=
 =?us-ascii?Q?yoirGB+ckv2Gyq7Qx6SPoVYpCx2cn1O+LoYS1DG6EBFry+6bry2o/9itm0fx?=
 =?us-ascii?Q?3HUgeWecIaMeIXiTNlqftK1MhmAVdi0ktBuMYNc8KwOs6JRniJRAJGXKjSOV?=
 =?us-ascii?Q?l7EkhDCQ9GWJlbZXAm0snIka1p5/CYG0hf+NDAfgWcgzR9+8k4EEIyTnUpxq?=
 =?us-ascii?Q?Wiv9weheYTIIGWh/WqANn14t62GmukydSzKFv5n63viem6mLI0EKkSdH3j1o?=
 =?us-ascii?Q?YnqYUUcwWZ2vE4ew3AnCwY7yyfcC2X/b4wAtUm3iZAJaNO6w/aOlDYxqoWp4?=
 =?us-ascii?Q?7nz9IRQTzs0gQF/JEdbl1fJxKj+gXHbu35F97FE6xUmECiZcrcplL91O39zG?=
 =?us-ascii?Q?rMf2GO9GvWjDVRbekCSfbh4mZPTd7SIQvuDNa3cgWczxNVjDRkiHSvhxq2Pi?=
 =?us-ascii?Q?5FQLi05ceUzf3t3Kb6OCxtbeySLnCtMzOaCsBIqZ5fpqzjrX0L3pp5LPFsyz?=
 =?us-ascii?Q?ukwlM/oj1d2yKAsZ1r8G1A2DBwAjORYhjgaOIf0pSlgQz7g0nSaE036JCpHI?=
 =?us-ascii?Q?9dGGm1cM+StQJ1x8Zp8VKUbhGhYfDQIVbWkhfD108LQNQ431vvcp9wSyBrxw?=
 =?us-ascii?Q?1KD6+aI+lP4mRIK6KnfDvlHZCQkyUbVBjnPLal4XOcoLspSiTIeUCoy//ykJ?=
 =?us-ascii?Q?Hg3TdIDnQGu/r8CfjhSIjDgK7p5LV4X3sKY0fFPcQFYkobAjvWVkrK6tVHuE?=
 =?us-ascii?Q?pubV6/8CT5b+gUfydSIYJ3tHaz1PAUe9vLqp2e9ansqjdNIBCnLWCrTcdR1t?=
 =?us-ascii?Q?+4MKsK8cPUZ1TX10k/xB1/3D1RZn1qV+dfBRpK3xitsNLUcHBtTMobkq+Qho?=
 =?us-ascii?Q?Dv4An4dkjAAZt90t0lIZ2lWlKtyShbMxoEJckVH9f135FMp1JisqNP/fC7Sb?=
 =?us-ascii?Q?JhItamLgbCidpI+XPZTOTTMPkDaNySXeTmF4qk1wex5g9DYTfl0xJcCNfpxG?=
 =?us-ascii?Q?Fw2KDmTPJOuTzjGbnataY0MNa8FY2tYmp4R+cLMurpdQ3CjbPEfjr3c9VUXR?=
 =?us-ascii?Q?rG+OclKVgx3kU/durye1zWoPv3pohtxEHk9ELTLDuIYTSyOOGsGd7e+NV6jF?=
 =?us-ascii?Q?CV7f0cUAkvzWL9iSaG7hlddrhV760Q+KLcmK7wWMmb7DcKZiSPerq0TkpQ53?=
 =?us-ascii?Q?tDebkucnwj1nPE3bKv0UdPSjvqFmiPmAzXKlmqCugdDzvzf8/PTzWAM7i+oz?=
 =?us-ascii?Q?y05it+rcaJlK/SnJGillKBGBRp2cC80kH3GAeGL+zcxra6IsgT1mPBQyvHkQ?=
 =?us-ascii?Q?AoPIEAs+S0Kphb6EPdUGYJOIguwq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CQNdoDenEgC+z6s/95ebDc/FuKas1O+QhZytiUsQBIExGY7LXcogD6GY9Xik?=
 =?us-ascii?Q?DBHL3ANa8vgcK3pG0fzHI9k9oY6lJz/UYtvtFGOQJsOSi/qx99pa79wC/Pyh?=
 =?us-ascii?Q?ggBXqI9FNdZX46VnDzIBaV2e6/aDl2/S1hKkk5QOn0xXuH/MH6rDg00Wt0IE?=
 =?us-ascii?Q?ClrWFQqr5RN6shFJGR8LYA0IBAnIdRROFLbGc0St3ZWgalNF9LU1bTrhx0HO?=
 =?us-ascii?Q?aDn8BOGR82Hh8QiqBZfGYElb98x2U/cMrAdBbEsWf7vmA22Bng+oWGCh+yyI?=
 =?us-ascii?Q?oKatf2Mdhm31do0SjIydqTyehrp147p2eRw43/mB9gyzP1VfyJ5YN/Cdfd3S?=
 =?us-ascii?Q?ZvgzGvmizhN/pq3jiVnoTHI+uvG+PYS10icSEavkVQbstF9tqfxwqo+fjdbG?=
 =?us-ascii?Q?Oqf+POt7aEll4r8iB8783KOc7tji6HHo7inxEp6UQvGPutEeWjuqvpzLfptR?=
 =?us-ascii?Q?MoNTKZl1WktWYvGqtcAOHfyc33X7XfXOSwfgheeki+OkI8l0198F/xxZW5Xw?=
 =?us-ascii?Q?7dmx+1Ili8nEgNRnN5GFjOdkfJyiq/TaDrKTfXn1SUAqaz0tANITe1dmt1ai?=
 =?us-ascii?Q?wuE6qRU1toERUDWjsrAevKhM6Hx9uz+Id9l0Jq+LHnkeJMjL9S6w3Tg+30+G?=
 =?us-ascii?Q?sueVfpWv1z53xFH1L1W2/HPsnCjdKe/vJBvgJM708/axem2bA/zGxkQCBixD?=
 =?us-ascii?Q?cZfJFlg32Tn1LSq5wgNwjtBbwqYsLHyb3dtg7v6v1guLAxaq2pbI/XQCMDlJ?=
 =?us-ascii?Q?meGogzjVNRuaUrj6YujdR+sTGlnsFueITF1vaMTxT4wt44WPGKisRepSE/NT?=
 =?us-ascii?Q?pzO9pOq98F9x6qmub6yt3ZEuDOJlmmbmEMjqTz0QtfVQ0SeyUqhpO27k9Nkh?=
 =?us-ascii?Q?A4MjTwnixxe3odP0KC/gURYrHnMp1u2E+GCpdagBD1FE0gVZZyvG57WJINme?=
 =?us-ascii?Q?tuIHTeNTYNFDKMgxeMXB9AvzAyCCUXLOG6JQ82EDD2+Ul+J7bX4P7MiR10rU?=
 =?us-ascii?Q?+hBEBnrTmTMhP+n6mqeeJVgyc6hW7aQErHccbe4hncAihDWbWXRHmU5/4EhU?=
 =?us-ascii?Q?xunnWAhGRZxbrMs6lLHTSLYXB+T257dOhtbW3U2cKkVzM7i4NANb3iqs2H2F?=
 =?us-ascii?Q?dR4BA6i4T9d1xY/d9TKIEtINk1Ph3l+Jb/yx/Q+UPt2zR0pBMKpMPP55Rjus?=
 =?us-ascii?Q?ktMBHjl6HDpbGSTKQgDnO2Hull65MgBjq23a3iP6vRgUVR8mQL5qvtL1IQqI?=
 =?us-ascii?Q?RCzHwna68xGFmbrf53aglWxQsOWlh1mndrZpgshbtz5BKRvD0xP6QgZEdxZR?=
 =?us-ascii?Q?xdXuVP7iT1bev/AiICQ3jBcvwSRJuqwtW42Wl1ephxasrP4BDrDvxmBBCPgj?=
 =?us-ascii?Q?Qy0CwM96dUIusQLfSQdUrjXgtqMM675dYL6klEG8rrBth0nt0sOoqFzfrwN1?=
 =?us-ascii?Q?LeG4M2Nk7HcND3DkiG1qdi+5PXeTtrxVFNam+pTPIaKJ6J9TmiXoHC5mDdNZ?=
 =?us-ascii?Q?7lHeuamo8ckZQilHSJTP/4n7DDzC/VDFaHrf92EvcMewBPbBEWTtHPSu0lQs?=
 =?us-ascii?Q?2fo6GlDy3JaRHH2V2ePg9eBYHReQJRwlRZOwJaIr5osT3NA9Gym/AatP3NWx?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zku2ZuCEAj1Wa1JbUzLHWzyRqAghlS7eATkDqepriCJbbeQ59EOpbQlpWkOpaZsmlco+yh8EW2jfipD1XcO6fc6sRn9ilLgBtlKpuw9VAUf6FbvD3KaXoeDnrDlxDaFVTvLNUyfzM/RhnSeXeVxJ0W2LYZ9gLmkdPVhuXvl+u4M0CkcAY6LxcCE6CmBmixrlkQWg/6XJU9LfBvLeg0H6JIezLMVIxM7chkwHhz2V27M8sQwgR0mpRPpxt4kcOxf+RoFuTykF1Jk9u1EQkwtCiKDWDaeI/TstIfdBkI5PvamgUaQ2IahsJL1WZhKKgWsSTHrslZGiyB215Xv8goIlS8hlzDxEuMCNQEmxTKmLvFE3miF/iEq9faBEKIfxRdr4rCYMCpil8yUaASLQdESWlub1X4dcV67rHLm+PpbLOfElj5W1KvpgF6iHfM+j2RDLaJTed9HkMuY3LMspPJpQ2kEiNUg/kCpHljHE3QFsWU1n7m+vBLnL5pfJNyQAxpvvGLj1CCCsFWCvy0/NhA2LUG4ORbgtobNrWw1nWherm4Srls1Uj3pBIt+8QABwE6jHlTUMT3RoLtQfCLrAR2BcOFcNo+VxevyjVQVpZUvda8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb49d750-35f6-492a-1026-08dd31bbbf5f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:14:19.7275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +mxpBrEuvjpudVH+kCCAvNQTmIjD0TXuFYEH0pFSJIbmxcEVTLVT0LYEJfi/jSh5kFjMb/nhBwDa+m3ExA//znRdxpwYRQOys6w0lPeDFgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100163
X-Proofpoint-ORIG-GUID: QdJLtNskk4yLg79v5g9Jj7kdyjpkcTbL
X-Proofpoint-GUID: QdJLtNskk4yLg79v5g9Jj7kdyjpkcTbL

From: William Roche <william.roche@oracle.com>

Repair poisoned memory location(s), calling ram_block_discard_range():
punching a hole in the backend file when necessary and regenerating
a usable memory.
If the kernel doesn't support the madvise calls used by this function
and we are dealing with anonymous memory, fall back to remapping the
location(s).

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 57 ++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 7a87548f99..ae1caa97d8 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2180,13 +2180,32 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
+/* Simply remap the given VM memory location from start to start+length */
+static void qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, size_t length)
+{
+    int flags, prot;
+    void *area;
+    void *host_startaddr = block->host + start;
+
+    assert(block->fd < 0);
+    flags = MAP_FIXED | MAP_ANONYMOUS;
+    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
+    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
+    prot = PROT_READ;
+    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
+    area = mmap(host_startaddr, length, prot, flags, -1, 0);
+    if (area != host_startaddr) {
+        error_report("Could not remap addr: " RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                     length, start);
+        exit(1);
+    }
+}
+
 void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     ram_addr_t offset;
-    int flags;
-    void *area, *vaddr;
-    int prot;
+    void *vaddr;
     size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
@@ -2202,24 +2221,20 @@ void qemu_ram_remap(ram_addr_t addr)
             } else if (xen_enabled()) {
                 abort();
             } else {
-                flags = MAP_FIXED;
-                flags |= block->flags & RAM_SHARED ?
-                         MAP_SHARED : MAP_PRIVATE;
-                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
-                prot = PROT_READ;
-                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
-                if (block->fd >= 0) {
-                    area = mmap(vaddr, page_size, prot, flags, block->fd,
-                                offset + block->fd_offset);
-                } else {
-                    flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
-                }
-                if (area != vaddr) {
-                    error_report("Could not remap addr: "
-                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 page_size, addr);
-                    exit(1);
+                if (ram_block_discard_range(block, offset, page_size) != 0) {
+                    /*
+                     * Fall back to using mmap() only for anonymous mapping,
+                     * as if a backing file is associated we may not be able
+                     * to recover the memory in all cases.
+                     * So don't take the risk of using only mmap and fail now.
+                     */
+                    if (block->fd >= 0) {
+                        error_report("Memory poison recovery failure addr: "
+                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                                     page_size, addr);
+                        exit(1);
+                    }
+                    qemu_ram_remap_mmap(block, offset, page_size);
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
-- 
2.43.5


