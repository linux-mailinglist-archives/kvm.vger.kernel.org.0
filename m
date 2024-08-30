Return-Path: <kvm+bounces-25574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F195966C6B
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:31:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3D701C2118B
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:31:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73B21C4614;
	Fri, 30 Aug 2024 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nM2bZsYB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LQjrSTZk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757FD1C3301;
	Fri, 30 Aug 2024 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056994; cv=fail; b=LFA0BEK4ULf57AsIh87mKokhuIYlqACXFLN9KKu0tPqAP8/xBRV96XBbpLECPQvn10xbIZksYim0esAdPXIDyce3cHnG4/jc93+ScPHpXkBSI6M6W9wS0f/Gc7X/tFZxMtqRLI2aaL9xVm/GTcW8ecMkEElVWYJ+5fAcRHOxwqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056994; c=relaxed/simple;
	bh=ewCaPBhQQ32uszwHppZ6HIbLzyQff8NH3Vs9Cny1pP4=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=cCR7FLeLMQqI7d8u6zAmCDl0aJSZthjkWcg+qdWwi6jixToOGKCCB19YnnvMqbLIEqL/4HlC3m92J73z4W8pgkg/Xtrlk5Bx+YhGp59OxSvXe2JvbSeAV/1xCoLMPupJa4SHsD8wMF97ApTO29AYVUZ4S2j9hZIyTyBstBiySyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nM2bZsYB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LQjrSTZk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMSfex016953;
	Fri, 30 Aug 2024 22:28:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=I7IsQlhh276ZQO
	SYWxWgN1gLRQUKdFUyMlTURekSq90=; b=nM2bZsYB2cD1/UNBSJImy7h7W+k9SH
	MdrN5bMiBSEzAxIcICxurb0B9E5sMj7KFHCUlMy3cMdugOIfskLzkB7mTy212xpY
	JeA34iy/qH6kEE1gayiqoc8lTFB9fHsr+qv1ML+Rx7u/1wCsPSzTwsbL78BW4Pg4
	tokqLLCtHWtmpWmMV/akmXZwgE8ATogcnVuKVNl0ZyHgsw4pj25p8kSyMZGRNyD8
	WF5XcuHlKuYXAvS3+4wmrn4bOTawce5AWDOHPkPWyoyhK+M0zEul2ORyxVpcVyQF
	cLaEjPVtbDY8J8qaqA1Dlu1DoVJAUbIHQWzn20vcRbXZbXAE1HbYsY9w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bpwcr00d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:28:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47ULj9dF009920;
	Fri, 30 Aug 2024 22:28:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894sjakj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:28:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM8MhpEb3nFjd4Zvly835ooXmT/TlmtOn/ZOh1FREmPR1rSilsYGEKzRweBDZd7bdTeWo4OTh2JzV1kTnp7Zk0vFGij2rb6pDN3OuiF1kozgq7qyfkmDGUQ2Li5oAwU++QleKrmwRRYVDGQgy1UQbrBx+pMNBCwF3OhD53/dQqGfCZFXb5uUwD0tdbSgtFTKoTMIzJe69uDXv5vktEknDmEXbdOod4C22jIt4LhVffI7eH5WTYrq824NFED+rt0ZQNBEOniDcfpImdbqyQJ9VMBHDiAuBGsb6H/DhqiPgnd0uY8ZMQD1bJadjvAEdzv81NajG6eaCVmY6OUszkZp+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I7IsQlhh276ZQOSYWxWgN1gLRQUKdFUyMlTURekSq90=;
 b=gXO9HOctY+gG/vTrajsIANOdOatHkmMhdHELyqquDPkbgqYARX15oYjpzKy/Jw53EHQ52YaRpT/2lAaGHH0rY+zHmCGNNa+3eYyGHG4mOwlZP2pAtSvoVF8/FNDi4zX3O6Rr+wnMjpPtwe7pKMlZ9BO/JPoXbsZzPH+UB2wUl2MWbn66Ha99JFOUWJHPRxBjvIBj9HElbFCpigpgTjnIp00PAzn8Jrz+sqMIwhXcfxvEj3cuJMc67fsC87gQYIkUo2aUvth4c2qkVZjGkd+dWikG2O5f9IIJ3Wk82qMbEaoJ4SFtx27ZAGynDDatjWI1LMkTXV6KN2dc1ALdUlMAEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I7IsQlhh276ZQOSYWxWgN1gLRQUKdFUyMlTURekSq90=;
 b=LQjrSTZka8Kgy9JwWhRiQj5PiaKs7x5B5SBY1qc0m/bWwL89HdQzZJfrXbpIXrudoFQpNRqq3WOBG+OMoP/Pi+lzv8BKUuMTZZC/6zqtfGkpJIDeamzxNamzY+2DAxntskFGKhsBhjPvgF2apVJRv8PU7dqWF0J8LlKbcH1EFBk=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:28:46 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:28:46 +0000
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
Subject: [PATCH v7 00/10] Enable haltpoll on arm64
Date: Fri, 30 Aug 2024 15:28:34 -0700
Message-Id: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 04671155-c1b5-40f0-5e5b-08dcc9431c79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OZtfgLKwK/hdjuif5h+QlLWIs/RprHh1Jjg+IVRAMUSKujZb8yrTywaYPOak?=
 =?us-ascii?Q?7SXLTGt29CR3v+dxkvyzD26V9JFiT6JqR9jsJZPA+unTCN5dMXmLiQ1n9UZG?=
 =?us-ascii?Q?qS/JOYGyB+InzYKR+v0pTltqmg99gcdSE80BFX2RbhzUpNzjbKcGsQHJnJX+?=
 =?us-ascii?Q?YmjrOCzqszufF4zLPRxrnxkqgQwTDtRgtFtYXfeAnnDOLCV2NUqHPSPmZNOu?=
 =?us-ascii?Q?4VL5Ng5poPzFcBgK/qRzox3/eJfTErtyHy/inRvll2OipCfZMWoju8Tu2DgH?=
 =?us-ascii?Q?OvwiDzfCCMDs+zTiOASVSYaeW2h/DifQqe0BA2AyaX+lL11u41k5Dde95GI/?=
 =?us-ascii?Q?6/2A0uw2VbH5Qb5lxIeQmJj34M6qXXI3WL1Hzg2AcUoGvOHzN7/WBuwICLPj?=
 =?us-ascii?Q?3w+pZS/mQrGLjA/E9SfOSLDdrOqG5ATpid7LQV8lg/rwOE0vbYtrSK6vgHne?=
 =?us-ascii?Q?l7X6pc5Zr0Heq1Ms7rXPW/9fVk4ZC0P2o6w5BuxZbBmfiBULB2HHDrvV7rBB?=
 =?us-ascii?Q?VM+auD0wQoQz5GXmBsTY/Kdsh3FmHuZn1cFoVTlkUyq9tU3beZIgrMopxuF0?=
 =?us-ascii?Q?oEZClfghVr2koq1Mxwoj4JcybHnnLWjCmrfgjHC3qLBa23AEdv7zC0LtzSwK?=
 =?us-ascii?Q?hkbA96m5tCS1abI4/K/P4pYmPQ6d6LP5sznLKFwxpX4SqBHGbCTWJ/nHpXH9?=
 =?us-ascii?Q?wdL7vb6aaiobcIBor5odXB8yqlWl1l/7HhM+FxMkw89/UqWrFKlIjbWIJAt7?=
 =?us-ascii?Q?Kk7vM0PE4UhQ/OJ7WbxOrA4XfBt2frFyGFeiRlo7YsqaWMjIdkb8O5V2CXt1?=
 =?us-ascii?Q?DViK/I9c1WFYZO16B3cAEG7TyDiFM9ELk67ACy3y/7g4kK5QW+aI1h05j5IU?=
 =?us-ascii?Q?XLLTRYU1CqLfWml22OGgzYqnOUoJR+PMfUzBPseaeuLBJPO/07/91hwJfsRD?=
 =?us-ascii?Q?QpllppZ2AQ+R7PthsxBp8viBj7CduS+JQjJfmDu/18k80FBV/d42Mf8Fggs0?=
 =?us-ascii?Q?ghwm73L21Hw+lZ6iupUPCJvuL7tOE2QKCEXB5uSZ14AIZKMW/SGejf6/FgR/?=
 =?us-ascii?Q?8cRhN+3uOUY8FTLFb0Up/uExs4hk+nxoHux9ofpsE21ZlRzEMJ/5/UmvzdrQ?=
 =?us-ascii?Q?KRBv596xOaMiSeNxupTR/nNPmiIu5sxwyrgY42y6IFyH9hHLFDtoSHudnTJI?=
 =?us-ascii?Q?mQuTL8jSyY7iowfk6JHoeJZWvO4b1xsRD+xDvxmd5eDDqGB3E/BaVvQ2KKKN?=
 =?us-ascii?Q?H1A2OWyxx9xMvPQ7BOshecPPp2dLbVggkZospcHxbDYlWUOcTf2/zzEtwKm8?=
 =?us-ascii?Q?mGpC7iqD8iE62yoZaKhUaAz4GgftwJqAvtqX3ZRvT+PWttr1pe9ud8smM6lu?=
 =?us-ascii?Q?0jhhPAM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2tzgtR01ay8SyN+gUj5JyDu3PkGocYfXrmHXN7O2y114awosDQaudW0ZrUZW?=
 =?us-ascii?Q?5DPAoF7lh/U/mfgEbjk0GVuwaVL3LgyWn+2Winpk0wfHeiClTwp5HqLN6cpL?=
 =?us-ascii?Q?/Ibod84oyJsf1HjS06hvpDe5C1p4vmqrnhNcYD6soSDv7EIXEjM2P/Q1QG3e?=
 =?us-ascii?Q?xcHYOl9pysOMwqo/KTrNMfczJd7IrE0FLU7inFBxvik5QAK/zwPjkFIuAhuf?=
 =?us-ascii?Q?JQAivLEtT13sLkf144akXzPy5LRyzdr6nlDyZ7SAQzs2OuIG0hOHDqe/YVZj?=
 =?us-ascii?Q?JPTN/GrsEfNIUBf8wzJ/M16CCBjDg2j4Tpo+iqzw/5NLNSIS5cIbSJv5/F1H?=
 =?us-ascii?Q?TOPL5bft4CZGXdlgsG6zce2dmXZoaaOfBuhTowDhvUCUYS9/Zng2ZRwuUwYd?=
 =?us-ascii?Q?f5WvQ6m0SQSq0fFsh1Zrp2tW76GAxt+qByIjQqc09q2oaF1FMwmA+kn7Edct?=
 =?us-ascii?Q?J7sf3Dhnyuk6OfqcUTDe6GJ3nsTKGqTt7DXgF+Lk+SyFYVq8Qs7ipj0oJRC6?=
 =?us-ascii?Q?X36E5M1oXjofJuHPScKyyrgIJq5cllMnUqwSGgfrxBUFJU64jQoukn/ZxpPY?=
 =?us-ascii?Q?OPv8knVWBY/YAm40J8zYkNlNnMLqlzJhYzgcRRpG4Zu0JVJfEyEvy2YvBiQq?=
 =?us-ascii?Q?XLQNCWMR7+koQ8MJKx6T4dE/tR5dglooA2xNKNk08VNCEqvY4f2mNGnSAdFG?=
 =?us-ascii?Q?MBUQ5bNVyiyS3COHKO230VB4SXIrsfCrism77aWf5zdESGkKYcCfz3z3k7wA?=
 =?us-ascii?Q?qHo4/sWAfRiP5BJkm+6JktNOWw3FZRIbYSnOeAI7t5mUuLBgzYNLR5z8B7oF?=
 =?us-ascii?Q?TuinuXlBcjxBEZu8QAXmKt+Utj4d/ERuNUWVoLY6757YYcYPcVvGuWpw9d0b?=
 =?us-ascii?Q?Vnkosy518F2Y9oyLj27z5etJVoach4LNXjiWn+5PWsOsaAn4R8C3TGoiH9RP?=
 =?us-ascii?Q?fLdm5sK6iT0QNNZOShKs6ogHbSLFAzRqnl5OxkInZHIIyqOXMiXDhEHl5pl9?=
 =?us-ascii?Q?JZjCE0W+3cl3G+wSv9yVP6hB83h3be3ie4OoXzUxCC+GOv70r6xdp87GufRx?=
 =?us-ascii?Q?9DALWGvWEbYJFYn9tNbvPpqqCVmI7r/zFcGfw/t25m02qMstFDHmh9Q/VZny?=
 =?us-ascii?Q?ne5ok8PybO9V0FJXaZlrgXiOPO97T864dQJmpLKWu+DNiMSqTuANm/hnj+Po?=
 =?us-ascii?Q?jXZDSP2AMkNdeIgC126ptrmbRiPPL9AxT2SYiG+KjodetPFYjXIGZUo91D6W?=
 =?us-ascii?Q?J93B1QxaGram8Bh14VKKp/NHLGfsqxJxH/yFt+aY/B2BP7TsekyqpHmKS+2w?=
 =?us-ascii?Q?+no4T3+bl/1l2h5wT1uClr0GZ4sOjogdF0Tr5CxPTsBJGsJ5xixX4R6cZXTO?=
 =?us-ascii?Q?eyV+1KSu8QLxhC7DqjuFPy12qVIBcx6TCxh7fhto3AHRThgDFyR56Jt8CPrE?=
 =?us-ascii?Q?Llc0223cFlA127UzWTLpQV94hYRERrSRezVXayoV6hvA8eVcbEmRYbeEfpxo?=
 =?us-ascii?Q?dv20FImRxzsfCjrTVbuv8jQp4AzEuuB9sGu6P8uRjykSaesU19WuT2oJYZ1K?=
 =?us-ascii?Q?aUCoiCgWkTOuAHIFoIHayYVEuzARwK0tTDASNgPRcIW+rPLJpl6G29gAghY/?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xtXt/7h+9c2kBVC9BqQaxzRD3QuT60BpJNwxfp8kqik+E9NCOCv7DxAepZzOfiCJ0se1yxYmbdcRYD5sdfgIIv92hmiFOkPhaBTWxMjIkznUuv3EhBhv3j/z0agbLCiH3JmGdevY7dd7L0r10lKmq+osyQDhCuvOMXU8ygrbcD2A4NymzbMlzF4Za4kEZnZvZ3V+0nh2FLJXWT62NsHhvkhPzB5HSAxzVQnSX/zcw+/bIomHuZ12S+EXK7ff2u7IEDvEowkomVwxdZkPyvJw2eNIOUdlS075SDvCUNLX0hkN/P+VCfBYZPdzddsdhhI/AJ01oZMBZfwc2ldKAw/mkz28/DaeFREYlDpBnOGQxga5UrAsiZCEA/zG5Gu3NxQpkXgat4DJ/By3wWrHdlkqqBpBfwJArLqEUwC16wzAO5/9wuWgf7SGw2kLXEsVm+ZEhPA/4S9J9ddDSlbTeQaeQu508Wf6WVTuCn+Y1zx4sAj7XbyGvU1XGuyGHs9KGWfVgKrduB/fHVQJsT4wF0oiKv/9Ugm4yIfYolFvk9LqfftUN71M+7342SXovM1OkxQUg4TWU5ywqeJHL+YUkQvSYLyQedHZTLr3kgWHQaDEN4U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04671155-c1b5-40f0-5e5b-08dcc9431c79
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:28:46.1596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XQpVkxHT3903tGlw2vtrDAQEMC1aTm9BaC7VWbnxFaLEyLsP3eS+wztmGfVqwQS9wjJDjjXpi1+XcTY1gdmcM4X0crf52sfOI/UUCojD/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-ORIG-GUID: ZfpQEY7Yes9q9Xh679S89KlQWcra0JXv
X-Proofpoint-GUID: ZfpQEY7Yes9q9Xh679S89KlQWcra0JXv

This patchset enables the cpuidle-haltpoll driver and its namesake
governor on arm64. This is specifically interesting for KVM guests by
reducing IPC latencies.

Comparing idle switching latencies on an arm64 KVM guest with 
perf bench sched pipe:

                                     usecs/op       %stdev   

  no haltpoll (baseline)               13.48       +-  5.19%
  with haltpoll                         6.84       +- 22.07%


No change in performance for a similar test on x86:

                                     usecs/op        %stdev   

  haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
  haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%

Both sets of tests were on otherwise idle systems with guest VCPUs
pinned to specific PCPUs. One reason for the higher stdev on arm64
is that trapping of the WFE instruction by the host KVM is contingent
on the number of tasks on the runqueue.

Tomohiro Misono and Haris Okanovic also report similar latency
improvements on Grace and Graviton systems [1] [2].

The patch series is organized in three parts: 

 - patch 1, reorganizes the poll_idle() loop, switching to
   smp_cond_load_relaxed() in the polling loop.
   Relatedly patches 2, 3 mangle the config option ARCH_HAS_CPU_RELAX,
   renaming it to ARCH_HAS_OPTIMIZED_POLL.

 - patches 4-6 reorganize the haltpoll selection and init logic
   to allow architecture code to select it. 

 - and finally, patches 7-10 add the bits for arm64 support.

What is still missing: this series largely completes the haltpoll side
of functionality for arm64. There are, however, a few related areas
that still need to be threshed out:

 - WFET support: WFE on arm64 does not guarantee that poll_idle()
   would terminate in halt_poll_ns. Using WFET would address this.
 - KVM_NO_POLL support on arm64
 - KVM TWED support on arm64: allow the host to limit time spent in
   WFE.


Changelog:

v7: No significant logic changes. Mostly a respin of v6.

 - minor cleanup in poll_idle() (Christoph Lameter)
 - fixes conflicts due to code movement in arch/arm64/kernel/cpuidle.c
   (Tomohiro Misono)

v6:

 - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
   changes together (comment from Christoph Lameter)
 - threshes out the commit messages a bit more (comments from Christoph
   Lameter, Sudeep Holla)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - moved back to arch_haltpoll_want() (comment from Joao Martins)
   Also, arch_haltpoll_want() now takes the force parameter and is
   now responsible for the complete selection (or not) of haltpoll.
 - fixes the build breakage on i386
 - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
   Tomohiro Misono, Haris Okanovic)


v5:
 - rework the poll_idle() loop around smp_cond_load_relaxed() (review
   comment from Tomohiro Misono.)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
   arm64 now depends on the event-stream being enabled.
 - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
 - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.

v4 changes from v3:
 - change 7/8 per Rafael input: drop the parens and use ret for the final check
 - add 8/8 which renames the guard for building poll_state

v3 changes from v2:
 - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
 - add Ack-by from Rafael Wysocki on 2/7

v2 changes from v1:
 - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
   (this improves by 50% at least the CPU cycles consumed in the tests above:
   10,716,881,137 now vs 14,503,014,257 before)
 - removed the ifdef from patch 1 per RafaelW

Please review.

[1] https://lore.kernel.org/lkml/TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com/
[2] https://lore.kernel.org/lkml/104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com/

Ankur Arora (5):
  cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
  cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
  arm64: idle: export arch_cpu_idle
  arm64: support cpuidle-haltpoll
  cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64

Joao Martins (4):
  Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
  cpuidle-haltpoll: define arch_haltpoll_want()
  governors/haltpoll: drop kvm_para_available() check
  arm64: define TIF_POLLING_NRFLAG

Mihai Carabas (1):
  cpuidle/poll_state: poll via smp_cond_load_relaxed()

 arch/Kconfig                              |  3 +++
 arch/arm64/Kconfig                        | 10 ++++++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 10 ++++++++++
 arch/arm64/include/asm/thread_info.h      |  2 ++
 arch/arm64/kernel/Makefile                |  1 +
 arch/arm64/kernel/cpuidle_haltpoll.c      | 22 ++++++++++++++++++++++
 arch/arm64/kernel/idle.c                  |  1 +
 arch/x86/Kconfig                          |  5 ++---
 arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
 arch/x86/kernel/kvm.c                     | 13 +++++++++++++
 drivers/acpi/processor_idle.c             |  4 ++--
 drivers/cpuidle/Kconfig                   |  5 ++---
 drivers/cpuidle/Makefile                  |  2 +-
 drivers/cpuidle/cpuidle-haltpoll.c        | 12 +-----------
 drivers/cpuidle/governors/haltpoll.c      |  6 +-----
 drivers/cpuidle/poll_state.c              | 22 ++++++++++++++++------
 drivers/idle/Kconfig                      |  1 +
 include/linux/cpuidle.h                   |  2 +-
 include/linux/cpuidle_haltpoll.h          |  5 +++++
 19 files changed, 95 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
 create mode 100644 arch/arm64/kernel/cpuidle_haltpoll.c

-- 
2.43.5


