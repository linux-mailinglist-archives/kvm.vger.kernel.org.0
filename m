Return-Path: <kvm+bounces-8944-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C1D6858CDC
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AEAE1C216AF
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4381B593;
	Sat, 17 Feb 2024 01:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BO4tjbEz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tisoFuS2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00D0EAE5;
	Sat, 17 Feb 2024 01:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708134344; cv=fail; b=a5PiYciQm2xES3y06Vbjne1kZAbAklx4c/qNCLSIji+NjH+C0srfpsu/r+HpXwQA8uSP4k105aE44XNKXsZIl5mO0p/+yafaoQGkjtOGNYkDgAkDWH6zzTpGaZG9WyntyKp8UR/1DAoj/S/lSIicp0CYpe1TLf2uuKI+KlAwz0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708134344; c=relaxed/simple;
	bh=2jo48XZSAhz04zU9lCzw5hGnTnx56UcMsLr5lWWD3UY=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=T/25QpSmufMpN1RIJHS+B1YLu7t8OLWVCr/ATe/OkmPJ7Z6RLbBK3mG9XuUwwWcKraX55HCVUY/x8qJY678Xzk0FS/rs4YWPmgsAbCOifpNsb5OdMtwnFYyTc5qiuG748E3erNkkeqnH1gimcZvQDP8+dlpvnOYUSq5z8LaiArA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BO4tjbEz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tisoFuS2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GKDkdJ012190;
	Sat, 17 Feb 2024 01:45:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-11-20;
 bh=9VG/ND5ygNkd0nVI/R4sbjSyG1mc87rXXwpPnWDiDwo=;
 b=BO4tjbEzp//8v3Q0AXPYa4G2IVTqkdaoZ2Bt2haATi8Vx4i0fdixbO2zG5X/fZAJ1yKb
 5CFmYswtiqD2dqUjOzQsyDKEe8q44xo/m2jykiu4quawSnwNDjfmTa+yGgLPl8HrIR7D
 Gmg4/DT9F2jbm/Llzd2s9yqzNPYDdOAvIJsydXWd/hvE87nYNDwx5y+llqPgc/cyWAI5
 CpxPHaMlHMo21ttp/ygRNmZGnM9o12iJR5kBKZYZlahoxx/baMfqAJJTxaObLcPBNfKR
 zJZbEFASdT5g7ZHlWMCaVMw8eOROYbsDphZSqh4oYJEwgnZ3TQuMQVu0WAx/KbH00kfx jA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w9301pm40-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1XKT8016632;
	Sat, 17 Feb 2024 01:45:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak83g79s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6oQWAT+oLv1iJ7ihleZ+aaT+DNe0KEXZvmS+/6w82iTHDbi9/RChiWMQQ6LzLRubRs71vuXQx/J1kQYV2o8M+J1xKepzfnGyEkBntmeC4sbOQk+wc+IwND1FsEm+aWAzMvFUTefAjyCUIGhwgHusVX/m3Ks+Z1ln0E8vFEZwj7+Sm7v9lJ+e43kbEcEqBk1QNS2uamc/rvxAIxr7S2BVpnqLch5EZNcOaodCsrwpRi9+NjZUnMdlQWlrNtyYq81P30QRvfrgf3j4FB1+yc0psihLmnNhxYP/VMACpziiT6nLlV9f0s0Lls0gPjhUVn4a7VI4NdkwCt7spMuBuVm8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VG/ND5ygNkd0nVI/R4sbjSyG1mc87rXXwpPnWDiDwo=;
 b=kyiI6SR0Nx5QSbu6UFzn4ySBobCth4eqIJZzH6qn/qaMrjl5uJsprK0557Y8gxI7kYAtvTy23FRdGkQrdZ2QfrHGQ7HmAwmISCQmJqw2aF24Y4V9nFAJuu0IbkfIXh7DxHL1cB2TXreXv02txGC5z8Ee7PaxUKuUelR59igf3C5NrpFzcaFCKzUgVUKzrnU1boAyA/iO+jp/r0+C+89PeScXdmcks9IXhqXBbY22KYZhBveWNDtez9ksFSolNxbnhU1P8MwMhD9yMThrXUamKIeSOnp4pibeDFR6Qis3CrH7hSv0TfY5F+UvH/A97ZnnXmWMsWDhIrf1tFobx01f+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9VG/ND5ygNkd0nVI/R4sbjSyG1mc87rXXwpPnWDiDwo=;
 b=tisoFuS2jCGyK1Btw18AxbgsHGuZoqFTu/vY7LkQqzURxkJVmVSW+WNPfSCg+FUCb+vVrE5NlWTprwie0xykbeHnyZrneZEOlyY85VX8H+2hWNIsGPlj6QQ2FeyRjKpi9VwK8QyMYdWLf1+u3jlF8W+9xbmutVCAcBA437ww/to=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7299.namprd10.prod.outlook.com (2603:10b6:8:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.31; Sat, 17 Feb 2024 01:45:35 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.029; Sat, 17 Feb 2024
 01:45:35 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] KVM: VMX: MSR intercept/passthrough cleanup and simplification
Date: Fri, 16 Feb 2024 17:45:10 -0800
Message-Id: <20240217014513.7853-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:91::14) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: ebacac4d-0af4-466f-077f-08dc2f5a22b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	c5yzq7uPf8psEVmGG8hQMZwCgyat1tJNbUa6+M5Nhs1SwnTAO8qjhDGkiGaqOOTKz/SqqBMyK6qC+BF8OURMtrbdoRdeDWs1/Gide3tA44jWDVtBa5d+2NEh9WtAcjRrMQn4AqvBz5M/ICBBhGoeTHBeYT6XyFQ7skTrG20WMpMhyU3T6JkYmvvGO87U8AKXTGMtWExdxYnV40r6UQId7mcf5OVA/k8fkn7MVu2g069/bYXAxE0KWeiKIBQQKJPjvQA1gsL8+0yrOvS3Ws3yFUylSLRJZi+uN1VhlVO1gGdwFO76vbY2EDtfOKiQmHG3oDL8yuKO4AVWJ+RsWwvb+jmRNFhDVcgzPi2w+b+kLmZyeAXs1Gl83KlQSp/RuVMRs2bkA3kOnUKij9an16GL8TNtJiXKZiAdrIRMuC4qIIhRsKcRUY65iJ/H3JybTPqNP+oaEBR9ybuxH32MktSdXzYRprbLar5Y8g8y6vhqrHmy5yH79Cf+aAZ0cfNQwA9gke1WlVELCo6qYvw8XiwcAONAR1nnWq3lQ7xjzGZ96FebXY8PfwIMBvBLvWnz1mI5
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(44832011)(5660300002)(4744005)(2906002)(83380400001)(1076003)(8936002)(41300700001)(66476007)(4326008)(8676002)(66556008)(6916009)(478600001)(6666004)(66946007)(2616005)(316002)(26005)(6512007)(6506007)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?jitBoEUGkT+5zZ6OA+eXOKpjBVqh+dOVJ5eO08a+0sGPXTOnrgNeKTpXne/o?=
 =?us-ascii?Q?N4cHTedGMuHNqVdD3UI0lLDik6Ka8cUVjkHWqjs/JCQBqCz1DIF+Bw6gohQa?=
 =?us-ascii?Q?nvk6BgzpJ541llkyyexlW2zW9yFOYyV/WdcrLJfbCNT38RsCB/H/yE5fPwwj?=
 =?us-ascii?Q?NL/bB3SP4KHlpioE4yYaLgNxGEpdlKFNyAZBjMdQVFELgjsi7EKAAj+MT+O/?=
 =?us-ascii?Q?9e2THDjyAPVZTHAHsj61ZutowjIDqNrgt5kJfBQvN8qQUSDrlNx17tsuTiYy?=
 =?us-ascii?Q?+5NA8ezdvoBVgKYfjsNa0K++AEfjM9T+zA8abJzKH5t8qyOp2d9RyATpMChO?=
 =?us-ascii?Q?HA46+RphX6OTnFDvPJDfPSG1xI1RxFGDB4jrHONR+vDvxS69V+dfVYysR7rh?=
 =?us-ascii?Q?3AfhICC5DPp7xQS50T5RCI/Z8Vbx8ROGfamlzppQnpVGuf8BT72FzZc1bCtu?=
 =?us-ascii?Q?l4sYnFl+5Z6N+kHmiJt7GGn5hDD0pINdn1MXMfPfL/sKWjuZIk3iDOtoW4JM?=
 =?us-ascii?Q?u0WSgQIR10KmWQYSVCYrvMzFrZNMH+02/ofkFi5byEgfzcwpdxYOJK55H0WH?=
 =?us-ascii?Q?8xjr57QFIL0dLpx9SJsBXVATYLp2c+6Dv4vSOveMzFwsoYSaiI61DZ/E/uzz?=
 =?us-ascii?Q?y6mKGY0hFvbGoAA6hfKKCTJd3D+zzNk2ojV9AgRCEkNTdzr1odm5uf8yXcQi?=
 =?us-ascii?Q?NsFR5YJ9msity4JeZUBJOEVVzwuk2h8yv+/X9+FH4X7Ad+8kbg1rvUwjTn5+?=
 =?us-ascii?Q?8UKBBeyxaD4IfPdUyGsm9ZuMmjme/q4Qk9dBKWApeuEl4zf1Clr/vFJqXUl7?=
 =?us-ascii?Q?n/JtXXMSSZSkyZLfs4qTPiCbOSk+KF4OfZg3Mlrmd3mVd18n/CqRLPbGyn4M?=
 =?us-ascii?Q?VNWpae9RrUnO+mF9/O2zb4LT6n8mxR4tNyIgAkX7PS8D+vXHnBHEUDhoDRlj?=
 =?us-ascii?Q?WG6N/k6pGSXoyiTi2u9xGUakaPl+OFIapeHvhpmxQffBEpYbtOggAbeJjgGb?=
 =?us-ascii?Q?ENVyaeV+J7ogPskMMRIhb37eeByYZ8EinZ4m3ywR0RirUGUs8rILB3NWiPT/?=
 =?us-ascii?Q?KcJnvloGxLVaXL0aJzd9eCkK1Uu3aptcGvoXH5y/vXJAjUXJHRbvWajImDNm?=
 =?us-ascii?Q?fNiXpHGSlemY7ltwZ2l9ZW430BZyHxBUbE5KCcKiSGiurhOxVVUEctfvUEPB?=
 =?us-ascii?Q?Sx4qjE82Wv7wpazyZ9u4lVHNnF6S4dW1iFTNkcyUhWJTvhOYZca5psokhHwf?=
 =?us-ascii?Q?VsmJ5X31j2yBqWbURoLHqO4ANYBjJM0IcfynG8T97+cA6cMC987DNjMfq7Z5?=
 =?us-ascii?Q?atFrPvPYfDbmd1VsagsAhc8MhtLVe0/tzpFcm5crfa2jxXm6YnB5W3EyG7Gp?=
 =?us-ascii?Q?2xIourrDIIN3PRGKjipICH8XYCxfGKj8FnXpQ50k7tT56tcNj81uohYP1Yzi?=
 =?us-ascii?Q?6ucVnXMuGhu85SbjU6OLIuHkmYveo/7igx7UFU8pkEXCx0Z80RIs5AGIgvSY?=
 =?us-ascii?Q?Qn8ZJRLQGShCa+eBKpbcKk03YAiG1Iy7yg8xQoRDPCkeHDUuN0eF/mVELQdm?=
 =?us-ascii?Q?6sbS1FGebQmJ6Drh9nsIKAoDB7hYV17/LE0SlQ+DGUyMumJMAqYb3qSj3AiZ?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	iE+ojRtuT5zJiLAKLGHdPd1fWI9YXWyeOEB6ERI3tIOSbRwKyktNuacVSfGdCd+DIqkwebA7bGS/OpXKO+QyoKbAMXikr0oNpbi7n1v0TWqEFT0YpaOT6hJR25tE+35ioEHJiBi6WjZ9/Bu8pWeHXS34U/2pk3Krnl6V6/lrqplNZr+6EL+v19gvGmdpzgmfrgN+cfmvNKsELTCxYQE4gLJQ8ZdsMROtXUYZHE7E7x4Uwai11ymIiHnqnh3AbQxP1YeZSBooLq89jtzbjy6yISgafzK4fU/j0UWLcee1c7T/duFYz4CZ4P9ef9iHVLNRlRcbodLJzAlwFMg2YGw74m8D7zG5ofX2XRRNgpOq/mUkj//MH/LxxU/7Gq26kIm5pxUc28oh4hTjgItibJqotnYTQF30bTA10h8u/0UcVxq99Yx3QXqQYRDBOnoMoDH2z/YTw5IvipGNa5DskB4lo5lDuvk7RxD2i+sqYaglPCJZqDxKMilFBMeFzxRx/NevEDrYfbqfxeioJ5BdYiGvVIAVzJMjxPHriiVDz5+6RWsllSoKDBt0kHKFVH6qS23ccswdTkhgJJ04twxbP90rjhJuqoeZFoy3VM68SvTNsVk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebacac4d-0af4-466f-077f-08dc2f5a22b4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 01:45:35.6340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbp3RFvX8WakvgemILBy67T/KJG3UalB3FAwuSQe/2uw9sdKPGnPJNHEHAUG/vlvbb5utWSbCWN0WyCHu/HvKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_25,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=951 adultscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402170010
X-Proofpoint-GUID: CwgY3w-U9Il-WcCKOYy8gY0nASkwdsSh
X-Proofpoint-ORIG-GUID: CwgY3w-U9Il-WcCKOYy8gY0nASkwdsSh

The 1st patch is to fix a comment.

The 2nd patch is to avoid running into many vmx_enable_intercept_for_msr() or
vmx_disable_intercept_for_msr() that may return immediately, when
vmx_msr_bitmap is not supported.

The 3rd patch is to simplify vmx_enable_intercept_for_msr() and
vmx_disable_intercept_for_msr(), to avoid calling
possible_passthrough_msr_slot() twice.

Thank you very much!

Dongli Zhang (3):
  KVM: VMX: fix comment to add LBR to passthrough MSRs
  KVM: VMX: return early if msr_bitmap is not supported
  KVM: VMX: simplify MSR interception enable/disable

 arch/x86/kvm/vmx/vmx.c | 60 ++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4



