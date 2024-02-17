Return-Path: <kvm+bounces-8947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D653858CE2
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24411284DE6
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 386971CD0A;
	Sat, 17 Feb 2024 01:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gtjkk76W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Yal9I9Be"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F9B1BC57;
	Sat, 17 Feb 2024 01:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708134348; cv=fail; b=B+uyiNg2dLINbJVu6GzOSX91Z3lQCMGCRp+V5GHlwSgkC/G0FqcqMO1g6w4vtYB0ytw078j7MqAbKfMF/GbLxYkKolg10EmUdVNvmxl3KGuL2y9Wb46Mi2rD2YtGP3icgOixoTyFt+E4oG9jQWj3HpHXpF5T+UvNYRx3/68cK9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708134348; c=relaxed/simple;
	bh=TDg9o7ZBGMT60pvLSYHzcUMQsX/F8kkBF8RK+ncQfOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H5/zBC0LQhhTI/mKt7HZ2BXbw+4cyzHutsHVO9yK+vHsydeU8Q6gWRIVwvG9q5BzeIOtoi8pUDRY4WgD74eBvzllLphWvhCDAZhE+rTbQkb/zcim8GuAbI2cGDRJrl1LUGJdK01B9PhJ00L/AuLzekRElb3UFeQOTN4+iRSp6QU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gtjkk76W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Yal9I9Be; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1VtBj024446;
	Sat, 17 Feb 2024 01:45:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=Ntb1Scx9w4nhtLNCmMClIWIzCRRNq8fIE/TMjuQ1RRM=;
 b=gtjkk76WXeVFPSZCpOXSbw+ty5VtKEQRTbMeaytE7GXvY/1OEzOHnEHMpWADGWZmU5sR
 ZoVNra6rxO/k3BFRcoar3+1T4fqDiE/UAqcMT+d5NlNHd1fPUWV/ml8zfYB2CgPontWM
 NBB8FPdBsJ0qt/chXNhd+7Yz3O8kMheKpOb7cZDsI6wY4UTrfVWyl/X6JcHCa9YcfFUq
 SCVsdvL+RHNPd2mi8f7luPJ0LAZoe2cXQ7eaoUMWhBt3A5w+vLyTRTBk5o04qoinJoS9
 mIeELyEksTJK/Vp0CE+t17dPFM0hkHkC1yFmuLZAloKuiPLKpn7Ml5Y5kCn3kx50oNme 0g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wak7e80h1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1X7MG007693;
	Sat, 17 Feb 2024 01:45:42 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak83g6ms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MstMeC1KFyiEBMyDzQPf2wyrMFvaaB8GplayZibqN7AKHoq4VokeuqoDQYkLCwQWepGUDyHYFEMiOXZ34ipbshpY4jJMXGD9mIabTYHBIwEFr64cfW56YFfBG/f7o710LpIoKF4uNs1DQ7OWQK7bkyhyDLuJdWFNzXJx7ZhiSTnriiUlHS6NCDNWr7DSuo9W44PpckzRQRkZlgtA2EFTSVImC5/i9vMiT5lgIkFmXfXGUn4sZb+knPQ6tTU8UKFiL8bCHY9HE9t6o7lpiGOpLZ0ptHZYRaNDmHvl61YaMEu+R+Dl8RopGagkicd0vjgBvrjMkADOauTqEI1x7A3YVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ntb1Scx9w4nhtLNCmMClIWIzCRRNq8fIE/TMjuQ1RRM=;
 b=OmVj32kOCBGoOV0XgaCuQxYuaSWZaej0Il415qR2pZPhSbYYTMM1j6/NeS8qs9y6pNN7Y77tK295pocDr7+J3I9thAWe2s5uh6yXqyp7TuamoIjMWNK2znuRQ8lrwes7ujTk9HyT8WNEPUv3ZZJDco4cm9GzowSs8/nKF+TEHeXbYrpRXG90sJMTPSBQV8BxIzxrJaP1D/3NQvwymIhFhTeZbb9xrfOsSzYLd1/vwLk8zd3N+B465vsEV4xE6kmFTxAZ+wbhibi+XV/quFS3V/v7Uf3rTmaIIAwmKhYvUwlUI3j1fBqfLKJyd3teN+FHJv8HQdOxq63WBTPkBXsbqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ntb1Scx9w4nhtLNCmMClIWIzCRRNq8fIE/TMjuQ1RRM=;
 b=Yal9I9Be9/UBM/JQW7pR5QvxN2+hyzAFZwQXE3zdJaIXbqFFroFMs3hx0xxzJCkH7Ii62D0EFPoNiDQYW2mceRL6bpFlIu9iidQaJwEfv/zfzxaPhWPZyKcgwN5RlPd1EkXsIQE3A+4BU/7DGAuD55kdnqlkviYIAYKhEU/o97M=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7299.namprd10.prod.outlook.com (2603:10b6:8:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.31; Sat, 17 Feb 2024 01:45:40 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.029; Sat, 17 Feb 2024
 01:45:40 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: VMX: simplify MSR interception enable/disable
Date: Fri, 16 Feb 2024 17:45:13 -0800
Message-Id: <20240217014513.7853-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217014513.7853-1-dongli.zhang@oracle.com>
References: <20240217014513.7853-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0145.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::30) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 405664a2-0ce1-42cd-d523-08dc2f5a2588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nU41jD1ms6WeHeC6p9O5Dg6BN5LEl+8BlFwrWl0RZpezGRXD5GlSiQ0TL9aDL83QqdhrWMW20NqzAcRamGbPHHwI00pWpXVuFmDyZDQj6BN3jVOnXit2CEOxAOE4zLOgaESAJWIDppDDP1C2ewi0yMkTNipbQHlHVs4hhroeyhAN94znUd5ndshpRPeWZrf9zk9zb8G2wrk1Y96AjhG/lrou/P1LPB3kHNiYBjOlpcFMoDHozpdMmfdb5GnI1IiPn4PUg/Txz6F/X3WxyyJ6YyTak8JKXLIhl3H5OF8+Ula8AphajygMFcYv593vRuCa4LiE1TLqDyAIuXBVu6cl7Z1L/qv9t+D/IfkdfzLXTT0nZCKO1bihbPX7tXPGqekbGr+apF0GYihH0O8dOgnskUm3kTIV/Gjwl6W3r1Ey+qFjBsQv/Lg8ITXCIyNME5okIjv5TsgAYSHstOskgLl9Bq6pHP740rmwQeWF7wwek1iUKcr13Rgv3aTED8/avQvodhLluN3S6z1WaQpqthNHXcRenfUv0T2M9FLdM7LgT3s6uDc37tZrT4k0JHCE1bl8
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(44832011)(5660300002)(2906002)(83380400001)(1076003)(8936002)(41300700001)(66476007)(4326008)(8676002)(66556008)(6916009)(478600001)(6666004)(66946007)(2616005)(316002)(26005)(6512007)(6506007)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?oe//3QP3H/zXrte2FPOH0McuwimFSldxLAHu+WVCgquA3WZdXwGlMM0+av/d?=
 =?us-ascii?Q?AcSpv1iaSe1uaLiUdxzCezo+FU+sZqLj4PR5brbZgsYKlCidUN192LEN48eo?=
 =?us-ascii?Q?6a2rJsS61sIcHP8Nm2BGYxhwGK7MmaYuPrE8ru+f/N8iL4bC9XJUxRWAI2is?=
 =?us-ascii?Q?mCcI2Ixh2KgXoupcFggbhcc8Bm6V9mYEQ01ElmxZLP+SoYeSu98sJg9DfsLi?=
 =?us-ascii?Q?b5LNU0AP+fJO8T5/WVWLkw3a1mEf4y2QWTwmVum0qZFmQuxCwo0DuZRhwAEn?=
 =?us-ascii?Q?fa3Oti6VcsxZ5SfiprFAVmFVKTosrbApIlOx1xNgqOteCfA1xfHFhemmLnwf?=
 =?us-ascii?Q?ULh8ob4id3VGI0AOb2OEmfMqYTYfJdClEthTXThO/9nSr1Y7QbcgfTrqDsZP?=
 =?us-ascii?Q?RO0nYL7OmF4iyk6dlBgoDFgxhlhQmww4orVv6vT6wi0C4jQKsC2EjOufe0gx?=
 =?us-ascii?Q?RPfpcXEtIX0SA/pmXFc7DBsZOQoXLZMj0pOoAWMy00sdiNlc9X3F+j8Kx+M2?=
 =?us-ascii?Q?LKsyHg3pJGbp4JNM7JR4p/Mxuzetm3xG2B/lM1DA0yzEw/BiMtLg7Ek9X+pp?=
 =?us-ascii?Q?y0HtC630VW4ptAgkD1AVOB5gPP0qEWi5Y5SW2q5Hwf+y1ftY1ZnbFFNueeWr?=
 =?us-ascii?Q?iXyjJhXEzhtqjyzWk6eTBYk+4H8vmX6iZz982si1nNZ6mx8QTEiZaGXMOwCb?=
 =?us-ascii?Q?K8p+lqUfVdhDoEMrZME9spWQETmY+JwGp+ZbIRKeZum03d9db5KP5WuRXwoL?=
 =?us-ascii?Q?VVal2UWUOcWO7FDt7+KWKrC2HbRxxcPEvurJUJsfqc5Di/7ej/4JQX0EcLzG?=
 =?us-ascii?Q?lrMBUxbnnFGbX9TjuWvGtBYwuCngE7NU1LUnBhPD/8EEWJrQ3QqjkeFchVyI?=
 =?us-ascii?Q?IslHgvF9P8rshNAwBbibe1u3w8b4pNTl6I2ncFJoxfqfXK6m+/u/a4N9DQ3R?=
 =?us-ascii?Q?/aZvmVdeyMsgns1cXyW4exgOf5y+58RjTVJBVe4+B7nyy8M+PZ4j0bYALWCl?=
 =?us-ascii?Q?/PLhubWu2TdDF+3F3RjasY785ejSPJCPEJAO9ZHH/fiyua1k4uG8E9ubjhDC?=
 =?us-ascii?Q?QIvQWzVnmG/EEA8WugfCMQ1sTwSrSnw9/mC9KDjylLdby7oYmEyEGTgFby5j?=
 =?us-ascii?Q?KeT0b0vPQ64Nq9wMuD3jGMTmDf1/4A9hWzeJ0+EYR3g5yyMb0zZ6KJ8CGDDf?=
 =?us-ascii?Q?SDkcXcFAVuV/wzDncNkV4T2nUHd7HrwoK9V7xsasmge+fBQ9VQVWAuUIkSXE?=
 =?us-ascii?Q?/RDDccr/7v4kfED5weB86joXLFVMT7gKYd703JKy6symxNikIbGDo4ZH2+Ns?=
 =?us-ascii?Q?zcM55llcVd/QDUZICxWvcIKXve4I0rZ79ouS0GAXEuhkfduAjAFXJypSFO+m?=
 =?us-ascii?Q?v8NTZSJwp7BATycv6sSQHOXEH+1ps8o8+YeQTMIujWkzCkIJZ7tfDbdPWH6p?=
 =?us-ascii?Q?zVQglShUOi9KiBfCatdMKPsGinc3fFMEnXRKeKOdNXOMAOkziQCxWTn+In4j?=
 =?us-ascii?Q?qbleZ7disuHbxb/W03LBMs7OYIggwmd1JnDMb22eAK4A7iX4WFuxmPg/HlBb?=
 =?us-ascii?Q?EGJwrwqtapTNCAnqhG0ZG0eoRQalmLBOKc99DypGhi5xM28fOM8kPmp1wZcZ?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	M1yzI4qFxRC9yEHuT4ejhCKSnd4Jz6SaymCBjvwR0MI1SFfxa6uhAdx6p2CFJrfxBUC7mnUmRkuZ2HZxSZTRcDiub4sLNjTvn1nSL4K3WRrljvnx5mF8N0lXLyMiyr8kiDp7LDkbpTnaUpcTwC0B2cFx8ppx93Q+yhARXu0DNVwOxmdPTvxzAB9OWJVleG2eHqC7SB8I+58nNvZC3ryg+C73DVTc0aylMEzibMIe0fBrWmeKY4h9CL6j2cUD+tU+PNWEFthQOkwQvdnfGc5XaBJGPPck2UZ4zQXNz7S/8H6+VlNXeQJMopnlu+dKpOLvQI2FrhFJU1uHhAQXPwV3wDF9hcGwhxudfAcog4K4bbRWdQyB74Dd0+dR3YXBhNZju0iUbgJjwrWvsTZKU+f50PxcMKhjAdP23zEAJ6ad/Dznr/xK2YNZXKF3t3IPyWQjC2br5reqbi4t6y1PqMKkEAliUnw/8B63HwTMEkVMT13QIy2QWhyZ2RXuOfVJKgmLK18qgLczjMbFpiaPCA5GlrNkUmnzg3k16MvcRZGxtIZzbaJf98CyGqoY/rSH6W7DWx1kWIdDVtK/KbQb4ypIzSHTaVUQxkET8QvEjwrU6Y8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 405664a2-0ce1-42cd-d523-08dc2f5a2588
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 01:45:40.4225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bk1Y9pX0s5cfKOkg8QXWR+Ruf91JjMsRSEPF+qY4bqUjBsxdsVPXX1a8/Xw9qkXZipaVN8CiJ9DzvrjuMU9VWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_25,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402170010
X-Proofpoint-GUID: kEZkD_tMTGZ-ZqBLiZyHCrfExOPczk3P
X-Proofpoint-ORIG-GUID: kEZkD_tMTGZ-ZqBLiZyHCrfExOPczk3P

Currently, the is_valid_passthrough_msr() is only called by two sites:
vmx_enable_intercept_for_msr() and vmx_disable_intercept_for_msr(). The
is_valid_passthrough_msr() is called for two reasons.

1. Do WARN() if the input msr is neither x2APIC/PT/LBR passthrough MSRs,
nor the possible passthrough MSRs.

2. Return if the msr is a possible passthrough MSR.

While the is_valid_passthrough_msr() may traverse the
vmx_possible_passthrough_msrs[], the following
possible_passthrough_msr_slot() may traverse the save array again. There
is no need to call possible_passthrough_msr_slot() twice.

vmx_disable_intercept_for_msr()
-> is_valid_passthrough_msr()
   -> possible_passthrough_msr_slot()
-> possible_passthrough_msr_slot()

Therefore, we merge the is_valid_passthrough_msr() and the following
possible_passthrough_msr_slot() into the same function:

- If the msr is not any passthrough MSR, WARN and return -ENOENT.
- Return VMX_OTHER_PASSTHROUGH if x2apic/PT/LBR.
- Return VMX_POSSIBLE_PASSTHROUGH and set possible_idx, if possible
passthrough MSRs.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 55 +++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5a866d3c2bc8..76dff0e7d8bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -669,14 +669,18 @@ static int possible_passthrough_msr_slot(u32 msr)
 	return -ENOENT;
 }
 
-static bool is_valid_passthrough_msr(u32 msr)
+#define VMX_POSSIBLE_PASSTHROUGH	1
+#define VMX_OTHER_PASSTHROUGH		2
+/*
+ * Vefify if the msr is the passthrough MSRs.
+ * Return the index in *possible_idx if it is a possible passthrough MSR.
+ */
+static int validate_passthrough_msr(u32 msr, int *possible_idx)
 {
-	bool r;
-
 	switch (msr) {
 	case 0x800 ... 0x8ff:
 		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
-		return true;
+		return VMX_OTHER_PASSTHROUGH;
 	case MSR_IA32_RTIT_STATUS:
 	case MSR_IA32_RTIT_OUTPUT_BASE:
 	case MSR_IA32_RTIT_OUTPUT_MASK:
@@ -691,14 +695,17 @@ static bool is_valid_passthrough_msr(u32 msr)
 	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
 	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
 		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
-		return true;
+		return VMX_OTHER_PASSTHROUGH;
 	}
 
-	r = possible_passthrough_msr_slot(msr) != -ENOENT;
+	*possible_idx = possible_passthrough_msr_slot(msr);
+	WARN(*possible_idx == -ENOENT,
+	     "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
 
-	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
+	if (*possible_idx >= 0)
+		return VMX_POSSIBLE_PASSTHROUGH;
 
-	return r;
+	return -ENOENT;
 }
 
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
@@ -3954,6 +3961,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -3963,16 +3971,12 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	/*
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filters change.
-	*/
-	if (is_valid_passthrough_msr(msr)) {
-		int idx = possible_passthrough_msr_slot(msr);
-
-		if (idx != -ENOENT) {
-			if (type & MSR_TYPE_R)
-				clear_bit(idx, vmx->shadow_msr_intercept.read);
-			if (type & MSR_TYPE_W)
-				clear_bit(idx, vmx->shadow_msr_intercept.write);
-		}
+	 */
+	if (validate_passthrough_msr(msr, &idx) == VMX_POSSIBLE_PASSTHROUGH) {
+		if (type & MSR_TYPE_R)
+			clear_bit(idx, vmx->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			clear_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if ((type & MSR_TYPE_R) &&
@@ -3998,6 +4002,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
+	int idx;
 
 	if (!cpu_has_vmx_msr_bitmap())
 		return;
@@ -4008,15 +4013,11 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
 	 * Mark the desired intercept state in shadow bitmap, this is needed
 	 * for resync when the MSR filter changes.
 	*/
-	if (is_valid_passthrough_msr(msr)) {
-		int idx = possible_passthrough_msr_slot(msr);
-
-		if (idx != -ENOENT) {
-			if (type & MSR_TYPE_R)
-				set_bit(idx, vmx->shadow_msr_intercept.read);
-			if (type & MSR_TYPE_W)
-				set_bit(idx, vmx->shadow_msr_intercept.write);
-		}
+	if (validate_passthrough_msr(msr, &idx) == VMX_POSSIBLE_PASSTHROUGH) {
+		if (type & MSR_TYPE_R)
+			set_bit(idx, vmx->shadow_msr_intercept.read);
+		if (type & MSR_TYPE_W)
+			set_bit(idx, vmx->shadow_msr_intercept.write);
 	}
 
 	if (type & MSR_TYPE_R)
-- 
2.34.1


