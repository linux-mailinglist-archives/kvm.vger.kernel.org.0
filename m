Return-Path: <kvm+bounces-40879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B16EA5EB23
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DFAD1891113
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAFC1F941B;
	Thu, 13 Mar 2025 05:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JnstH6xV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l7L1VcrQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88F71D5CDE
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843491; cv=fail; b=IIv3FWAKdqxpGdw9aMwZrO22Hc/z9TnbcqCDyqaCAxyvyD/z56Uns/5Momck7NOoUAHH85T77dLhtUkCPD41WmXaz0pcHKT60tUr7QizJvva547HK2LdbN6kHk6DTKa/c69qBJWd63O6qLh4wGNGdg3AiGYkraj1ZOneeINmHI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843491; c=relaxed/simple;
	bh=rVVSQVCzVc/lLYCy6Oi+9zVr3fTLyJ89iS8elMjfmDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L4lJn7HFmbJgmkrxLIif7N67Ts2F7uFgLugaCwztFGBZ6qMRaqARXR3vsB+sSx3eHbzFY1OQzQcinC5XfZC5MFFpX5mheXpLxEgrXftqTEsgPBwMuutaIvsd04UrH/nbc1Z52khjvzmZQd0GyrAKZoSQqjjzF4cfAGN+aUaGHg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JnstH6xV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l7L1VcrQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3txBS021525;
	Thu, 13 Mar 2025 05:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=xhcMxAWxREmkgEGTJLc/YWJ11DsIymV4DfsxcQWP/V4=; b=
	JnstH6xVOW6UxuHXfcy0hqTjMtjRPub0ZSf8jHLrWMzLSCulP2GsgiFdCGFCFaAi
	HSqlwMy+9ugcx6gyrvS4gJ6eDrbpj8v4gb0REw/Dnr9pha/mFp27vVBO3hsaRgKb
	HvZybnm/GVpSmJY1Jr4PeWr8dkt1J1Lkix+meRk2jsre97CXK4ZVYsrFaGeKGkgZ
	NAEhSQaZn1sC4JmajzTohM9ZOd2phyJtGeoaBNi7cxyhrSTe5Jn0EqqoJHwy4aAj
	lI45nErFCXJpYlTWUQAlEq6RDh7ssQPtmi6/NK/XloGjXwDHRf/QdRhMHsFMjqAu
	KpuzsiRse3tV7rKfNw5V4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4h3dac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3YpSe001569;
	Thu, 13 Mar 2025 05:22:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn87qrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ag93Cwq1TBpk80Gu0tJjomNLTYee76zGS3t15tn4DfeVjuD5O3r2HvzQ2iXSkBrn8xL6T6s9dVHiVWRDknuAbvrj+KXWMXmkG0pLDd3b558228LJwUmIgG6AfzYdsCMLn6JAt7RVTGIVCbRooNxl0FTdcpxuecBHRmKgx2a26XBaKOujNIshcVqLgjFAOwx8O7SsRYisUnbAybvS35sTqyqhEhXacOaSqfwyYM+I70jrWdxtnXYf8NxbRdHLvTAF1i3pxqxm3hRFhKM6UbUNPV8yZk4e9R9mTEp4kyfFNV3MdHP5c1dmg/zHAZTYRtzLLB2oxA5kPYCzrPzq4NlDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xhcMxAWxREmkgEGTJLc/YWJ11DsIymV4DfsxcQWP/V4=;
 b=p9bXKEzxVm2s0FKbn07StT+E/F1I4YU9du2Iwe7jOPZ7zRPNCYv1VmUVi0CxKNKfRSTYkur3uAPkg0Vnuxh2Fa5CfaxV77RTlWH2s5tmJ9yHe15wJnpeezWPtGCmqtsCdthDHRBK2yst3IbIGz7NVqdVK2E//3BY/jXqnnL3P814bk/C22HdVbdJr4EE2PcHPeCFrmOlzAktNiBmqWbiwzE4ZKkuy7TCp83PjpUDnuLPeI/85IIt0dJUor2N0/6rkTCmIL21z3WFBfppTYlKWDCtVJy9jrd1//07xsaXw0unm2+qWfSRtV47rodcCYSADehjxqWHwKn8T7a1EYjs/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhcMxAWxREmkgEGTJLc/YWJ11DsIymV4DfsxcQWP/V4=;
 b=l7L1VcrQ49MM/6qvTN5q8CReSlPN3PRjYqz4TYp3L5Ck7j+KPfTT+NAEJmiX9G89tutB7YWVvu9iCZ4RFRBwE3NFW/EwJEUCoiEZco0hvtCXh0JuYASKdRfTfQJrdtxeHaUX6tryaQ3c31kkfcwXSIoEhVB9/enkhRp2DwSDz00=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:35 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:35 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 06/11] nvmet: Allow nvmet_alloc_ctrl users to specify the cntlid
Date: Thu, 13 Mar 2025 00:18:07 -0500
Message-ID: <20250313052222.178524-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:610:5b::30) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 442dc3bf-6d44-4683-0fe9-08dd61ef1016
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hsLK2/O0za8FNE9BEO6A0nKTunxh7epzLxqh3YSpcpHTZiW/QWChAMfYE7NX?=
 =?us-ascii?Q?PEt+Ey/m+jwLC4FMy+BztU/Nj1tY93diRcpUJnx7T+Cm0/7DLClKlDJlL9zJ?=
 =?us-ascii?Q?KTxm93nw5vJdzmZ+vAYUJ2nL5h99de1HqiYfloGPMz0XYfNP6jT6JWKEcK5u?=
 =?us-ascii?Q?VfYQcAjDThPyQBo/kt/YMOy8IuJAIv6tnvGIMsokXLbwK/TCCgiqbyfaoJUM?=
 =?us-ascii?Q?Bsu8C3OAKqxCZpB6dhwPdy4SW1VGJgJG31UqkjUEqgaXdFaUvYDtSpuiYbSW?=
 =?us-ascii?Q?pZmNmHBWvRLAtddbAgimF1IFatiNcUwQ/q3Y5YbujiHIPQtPSHfpD4dgxhci?=
 =?us-ascii?Q?gzyEC7/Zow7en9fyRKVfjQZeZIVTp4g9iIEJTIE+lFx+np6shW2xgmKpLOeJ?=
 =?us-ascii?Q?0ZzENifGCmk4ABvcMxwlf+AsA7mwhI6jJlcgwkzadssUa6eUEthAn1mruA9+?=
 =?us-ascii?Q?1OOk5c2DgtGynnJiy//Kii0ovwYS55BL4UXSQ2pGAQ/YAA6hrev+BYiXtlPJ?=
 =?us-ascii?Q?d5ewT6nFQ4PwEJhCKKOy3WAJ+PZ8ujxNs8ENA1gVa67cLNoh3lbYSldpMMgY?=
 =?us-ascii?Q?vyFyw763ZiviQGHvRDkvZKrTTMxzOeP8rb+VEtp+JaQeTnec5ejyHTkwRUyr?=
 =?us-ascii?Q?Xy8YvORMdzA4hOP4Iiwfc1qLtpHD3tYGPKfxKhoUWYxBL7vgHIEvUMshUfyb?=
 =?us-ascii?Q?3noKt0ayPRUn8D47FPw5vJB1zj20QVdjX81z/BiLqAb28JU61xvt0GIHehTE?=
 =?us-ascii?Q?jxLMp4KZBhGzvjrGU++KA9zFAoAtirWJmC6GxzjoWJZ9+utIpwx1fo/cY3Go?=
 =?us-ascii?Q?ld6sOF/tMqO7K9vr/lT6WULhXrmVx1M5OQn8z4BuEdW2DDPSNHyrzpPllT7c?=
 =?us-ascii?Q?0zwTOwsHmam6jw/84UJPS2PHNdrCIAe+/Z5TcbMAmwaZcHPGfBFrFC4vP+pT?=
 =?us-ascii?Q?YqsuwvgBglEKucdPuwjQkdiyNh02j86mSHG3Nk9PoRnSb0N5kW2Rz4ipzvAY?=
 =?us-ascii?Q?y6TUetqeIg2F5qn+8FQTKYtOuyYQMB0HAmpSRqwp9tVYWGaaW1BtlbHZWJi9?=
 =?us-ascii?Q?bvmwYJGKUB6DQ45+h+OCcJ4v0MCWUNBaxAUa+wOhcJg3q2qPQLfmokTS//ZV?=
 =?us-ascii?Q?vT9tLIcxXpS6GEg6ZH9nKkEw1A1xy2c5wdlTKvHSA2gwKBwAMnuSiE3xXWk+?=
 =?us-ascii?Q?N+1NrGmaAKN9RPuqxsReqC2oBhLkoJHTK8VJCz2nWZ4Q8ETzUqbufXe87MGT?=
 =?us-ascii?Q?PgNaC+BSPlXPwzVayhdMYPGUeyw7DSvt1ItWUlKIEyW+ii3LP+B2hhoPIc8A?=
 =?us-ascii?Q?imiiSq91pp3V0c2bGR0vi9bGmTx+gzg2RS4akanBJvaUR2WaaVMCUwmA616c?=
 =?us-ascii?Q?DiqCGt3thv1zKS2d88c85A4nEbZrp178DaAL2Ir0G9EgH2ptWx14OWqVVH8y?=
 =?us-ascii?Q?r2LX5UKmyns=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vDWlvJM/KNSMBgsgYHSA9OBJf5bcHMyVo5sxCQ6oMa83rhAJP1raAWjCVIGq?=
 =?us-ascii?Q?c/pI3VSXINX3/FvR2wYK3e427ELh1XvYqF49kxM2qNC7QYroRj48x4W9GOfK?=
 =?us-ascii?Q?RRDCMl5AmDJ7OMauLsTQVvtRYGhaiDrqv7DEDWZDfHEUJYvfAE0DG2rL355Y?=
 =?us-ascii?Q?NTbyAey2bKLdhJomuFKa0a3DM3YH1Qed5u726SRwYiObg+dx9whSG7r8yFD2?=
 =?us-ascii?Q?cOMU5IFtyykHuV2hJLRmcqrFc5dNQ5ywsPfWdZbqgOSOMR/We48tyhJ3+0ZP?=
 =?us-ascii?Q?DfcqnDye1k2FM9pS3xJo8PQbO9TyIbzRKOXItPTnJawM+gznnm2IHEV+taPT?=
 =?us-ascii?Q?en1Dyc4ku1bP9/UmCd9TqBUHVEIsLa3bvxYyFHNNzA9fSYmGwfIt31Xt8iGf?=
 =?us-ascii?Q?XDHeQRKlIGLXIqaBfXFFbZGmX9OuwglyjWWTnuIQWVjdRWxbf7kfGM0tYGcL?=
 =?us-ascii?Q?qF71XA9lh0GBaE3cusB0M88NB0XPCeK+FpkMnQgfbYwlugC9nAGUCMRise6c?=
 =?us-ascii?Q?fG2bX/iKHE7l14qmrWrl5ez2oyKcCJu7NbADiRJfiFFDAzNffdXNGqVK2iz1?=
 =?us-ascii?Q?bviZy+bhi5KqVLpBCOeMxRA7b06bb+mD0hYDJh/0fVCmzueKl1A4G7x00MWh?=
 =?us-ascii?Q?OZLqvHg8lXLzMQtnE9/BT7KNrC9ZpZrvWUuxuTNuHAkU2BqPvkYOPKESePP7?=
 =?us-ascii?Q?d+9ITjL+5gsXx/MW8gcFUomesOvO44tS1++lkJAPm80FDWSSaAO+yskWRX2v?=
 =?us-ascii?Q?7Q2Ygpe3rQXqH+Q2I2pNRbQsz5R2Ag/idKD4jm0Pjf5t4Yd4CEvFmllCmMAy?=
 =?us-ascii?Q?WFez3I0/1OCKc/l4g0W/4yYfvhH+4nrvhfEIrKT/eVOQD0R9tREvbaTn2b++?=
 =?us-ascii?Q?L8sfYc/fHiBBCozj3FRRSyPYs1+8F7BFphVHmbmaxk4BpDTM9Jnidv4E2ELC?=
 =?us-ascii?Q?4hlceoBUWUVCbqOQ1VkIDBfxONhgV2vltFu/LVSKQEhbH0LOBO9vUZCE/qEi?=
 =?us-ascii?Q?BrFx+r49/GNpyqbJFBqRO0t3f/EZHyPeDgnhDtfAjxj0qtZmo4z3JYp4651s?=
 =?us-ascii?Q?GYEGtKB/KwU2v9pM0ZA/ngrLEuBQqhvjAamz7TmHBSMNQ1DDVzzybpawOLIj?=
 =?us-ascii?Q?3wN1UHQlb3W58Z+7V/SIqSv4v6J8nm9TXYhfJpMYvFjlm1ezq69oFmYH4WzS?=
 =?us-ascii?Q?sqiMu2+5zdxVHgFo0M+VV2ehy7wcWJ1Gp6rbdt4DwWK1jeKNOK78Vu5vFixL?=
 =?us-ascii?Q?LXUxRIbGT1bp3kqIRls5oXDyOk5AUbWX6t+i+ls2a+kBd4GRHT9D+wdxn5w0?=
 =?us-ascii?Q?mdvUHXdAIpnBZCM2VjPBVWP62CpJEPCQqnAL4bXxemaLE+HO3GSxAHOik2ha?=
 =?us-ascii?Q?aiuOf2Xq+t5XfRhO/HoZQWFe6ZLiGGe4AbKun1fD3myvj15vHiKQUDRVBacz?=
 =?us-ascii?Q?E/bjfpwSNlzL6SSB3/FXw52P559Go62Mjlibtf7CQBBxzPNvfqsLDYAgHhu+?=
 =?us-ascii?Q?wDn5UpXmzuvBhwTLi7AMdkUMZliXXdHhFrDgSgWz8FPB5j+om93wRCcMKOuC?=
 =?us-ascii?Q?1dvANIzX6ZYCTSx5IIpJddjkfdPZHxhbClvAUbxxFMHZkaaYr4NVoN0VapAH?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aQdLo/DssEb1656L3b+GDzemiabK8hdy4PMtsruGDxLqt5bLrcDBA3rNndKV2G5ml1RvUEc4mLC1RGAHTqehx0QQQwj1EFTRK84Yf6Rk1nUoPdNFGCfn8R2FS7v/ImH8KePiuhvwSr2lY2qlUyDq+ny2+Rt20b2AifvZQu7XyNoF+HnEuwDKPXz5geahdEe83D2KS6HBBSdmqMQIfdHjm8lCLCiM3IR2XrUerJ5Iq+S+FXm3TpPSCPdXVewzfbfbGeCeGGDr6FGPJ2yf2ARxd/WAcoxdzAeafSwvhvWONgXw0ObNKzzcI9nujDlJebQhUmjGiotNbw0Jl1iEtfoeYgPjJPSC0ytyr88E7TKdF17px3WpKbFBmf/SNiL5QkRLbJRpQ7crgtzZOOa1Wb+iGx9iimpOiaMjNbneReo4f20lQf8+ntXGUZwCvXTlC6BTht3nFfGmZld3S70FbravONj/qLyfinkDI87iDzhkIkwpI9qrfoYhwO1eYWOF+LjnTZGoIoLS/2lI2yJuPYSIPQ/G8QgDOr7H90+AdFioUVmDLAf2Mclv0mXxnCmlik3q0XuAp74OGCFIMvK0AEXfZPWy/5SBW0x2/vYbyRaYhLI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 442dc3bf-6d44-4683-0fe9-08dd61ef1016
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:35.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XtwRuvbxGiP7QYXCgLJ9xFXDazZbj3OwocFt25aby7anz6Ues4V4noe/2Smf9cj5wXj3tUX046zSix7FNh/IaIPcfcr7kOij0+KQK5DR6uE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130040
X-Proofpoint-ORIG-GUID: PN6r_lSdGSaOFLRIeDx80zwZcK3_nrGS
X-Proofpoint-GUID: PN6r_lSdGSaOFLRIeDx80zwZcK3_nrGS

For the configfs controller interface we will want to pass in the
cntlid from userspace. This modifies nvmet_alloc_ctrl so the caller
can pass in the cntlid or allow nvmet code to allocate it like it does
today for dynamic controllers.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/core.c        | 9 ++++++---
 drivers/nvme/target/fabrics-cmd.c | 1 +
 drivers/nvme/target/nvmet.h       | 3 +++
 drivers/nvme/target/pci-epf.c     | 1 +
 4 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 06967c00e9a2..f587ec410023 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1621,9 +1621,12 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	if (!ctrl->sqs)
 		goto out_free_changed_ns_list;
 
-	ret = ida_alloc_range(&cntlid_ida,
-			     subsys->cntlid_min, subsys->cntlid_max,
-			     GFP_KERNEL);
+	if (args->cntlid == NVMET_MAX_CNTLID)
+		ret = ida_alloc_range(&cntlid_ida, subsys->cntlid_min,
+				      subsys->cntlid_max, GFP_KERNEL);
+	else
+		ret = ida_alloc_range(&cntlid_ida, args->cntlid, args->cntlid,
+				      GFP_KERNEL);
 	if (ret < 0) {
 		args->status = NVME_SC_CONNECT_CTRL_BUSY | NVME_STATUS_DNR;
 		goto out_free_sqs;
diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index eb406c90c167..b26e60d41e8c 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -288,6 +288,7 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 	args.hostnqn = d->hostnqn;
 	args.hostid = &d->hostid;
 	args.kato = le32_to_cpu(c->kato);
+	args.cntlid = NVMET_MAX_CNTLID;
 
 	ctrl = nvmet_alloc_ctrl(&args);
 	if (!ctrl)
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 052ea4a105fc..990dd43df5c9 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -582,6 +582,8 @@ void nvmet_ctrl_fatal_error(struct nvmet_ctrl *ctrl);
 
 void nvmet_update_cc(struct nvmet_ctrl *ctrl, u32 new);
 
+#define NVMET_MAX_CNTLID 0xFFF0
+
 struct nvmet_alloc_ctrl_args {
 	struct nvmet_port	*port;
 	char			*subsysnqn;
@@ -590,6 +592,7 @@ struct nvmet_alloc_ctrl_args {
 	const struct nvmet_fabrics_ops *ops;
 	struct device		*p2p_client;
 	u32			kato;
+	u16			cntlid;
 	__le32			result;
 	u16			error_loc;
 	u16			status;
diff --git a/drivers/nvme/target/pci-epf.c b/drivers/nvme/target/pci-epf.c
index 565d2bd36dcd..b0e14e8aae7b 100644
--- a/drivers/nvme/target/pci-epf.c
+++ b/drivers/nvme/target/pci-epf.c
@@ -2031,6 +2031,7 @@ static int nvmet_pci_epf_create_ctrl(struct nvmet_pci_epf *nvme_epf,
 	args.hostid = &id;
 	args.hostnqn = hostnqn;
 	args.ops = &nvmet_pci_epf_fabrics_ops;
+	args.cntlid = NVMET_MAX_CNTLID;
 
 	ctrl->tctrl = nvmet_alloc_ctrl(&args);
 	if (!ctrl->tctrl) {
-- 
2.43.0


