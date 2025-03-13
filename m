Return-Path: <kvm+bounces-40874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECF91A5EB1D
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D72D166B66
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:23:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AD11FAC50;
	Thu, 13 Mar 2025 05:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZBit9rvl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PwcZeefz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4284B1D5CDE
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843370; cv=fail; b=I7gua2URa2EnEOYx8uKFx4IBYw59LbQ6no1R1CYO/Dk06GT/cTzgUnvL4828IIoRv6ETkgsXFtBCN3/ut8rbdbBszIj5GxEI8ELSPw4FPCfCuCjuOry5g4YuRvXN+tz7Wi3ROufIAgOYASCol7oJuUl4BRE3Hb6NU3YWlHJMhxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843370; c=relaxed/simple;
	bh=HFhZx+GqvP0TlkRrQYFVYTtHlZpasAABhLaeglYRCcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qn0aSM50Vc9xK3IAKC0KKxb8BYt98NbcrLsqIeg3QpWUcXYG9yFVgKKvAcnJ7yADL83eahpxJrRF/h0g33TY/gYuS/niFSM6ZcIuqkapwISUuYmZ/VgSFbfkIiELqeuVgVO+oFQ9XOndpT6TmSYHre7brlEQ170bM0CwdfkJiD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZBit9rvl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PwcZeefz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3tjGr008203;
	Thu, 13 Mar 2025 05:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1ZZ0IZCL1f7yGfGrQOrKQnJntnKYkDGedUQ3OPYpeJM=; b=
	ZBit9rvlqBQBWdqYUxDLHynPOOUXrTMt2QjOS9m1bxvqlji3GzsQewcGLMrRfn0a
	42yNtCA8jsENtNUTPdMLMsRKYwkCGM7DebgiaZghtgkW+8IBYkkmZReWb5IHNFQn
	lSZV5cjdIWXWmfDDXWnBZWC8O5vAEjQ/q1y4cb9/zrOpq9bXS2+L2fYt4Uf3I7YM
	+a7DWoO0mvavBtACeEH4LGoq4jMirFKFGM3IOeImiQ38b6dVWVKMyKAgBhjBf8Pc
	30CErXKy/fCG9oGVsayTfbhXtGEDhK0tpRUq3yYBp3KvocMqqr7nkRSYEeQHBMhQ
	5ZeBGGhWnJ+w47uKsmPtnw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4duffc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D4RGLc022384;
	Thu, 13 Mar 2025 05:22:32 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atmw5mpy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UsMmXEHeOWgnjALvi3Vw6cV18ZImoqZj5y+/XulTnY+iDDXeu7oXzOSPphzI41el5TzLM94P9IW7891wzdma1uqi9/7Ea5/cUue144SVC1Diga3MUI20lD+SJPjOyoir7447Og4f1Wk1nT4ejGoCQgLaNxNna3cKallc8s8m+ZzpE0nH8O3ICLX7rNg5/6uKvDZGVoFeqJFPBNrZ0wfQEqSMblKkerH4Olu6Sgr30wViKuSBBvEF7lfAAvGyHHn8o9YgNqY9rOhvDJlQ0ksi1s9Vph2vIFUuCT4sJAPcGXw8m+wrdR70MBQJmIs1d5A8LVUkoMrczDMc2IyTstfZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZZ0IZCL1f7yGfGrQOrKQnJntnKYkDGedUQ3OPYpeJM=;
 b=d3lTY9oIpq+fvoOnTGG3dWbpe51leYOpDDZHRBOAISozY/VPBjGehJAYUdRXozIR7E9JKP1WAL5piouxDpTZ+gGBlLXL8MQt9JVey3tyClhHgi0GzN9NfhTldNwy6s6GZQIEUppCOvrJS6sEmAm/D5dW04IjM40viGpfpuK2XgYggPHzHEZcCws+XL3YWBDus8ROLLNw6VK7kdJjCTWwz78Y00B6xOuIvFiYpTUi5pUB/T/GnjUWd7sODDmF+DpVTZlhKV1cz5atG/AIu2tNJOVurFWiEmFj2ujzMbQiDqtUREYoP8CxvYkjTCUfg7cEFNgN1fLFCrDYcIFC387O5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZZ0IZCL1f7yGfGrQOrKQnJntnKYkDGedUQ3OPYpeJM=;
 b=PwcZeefzQJGmAXHkmoIiAG9tEbE0lKcnz+GR3KChfNG8kegonSrNciPGSGx1Lmvhmn9F2EZtQapfFXkqNOqWAUtDmhfmYNCipHBY4gz1YRedHUJdiDPCNxsUYaJPiAc+LNf0LVo7s1HwMu3YqQdQCevbVaES4ARcaDewsahkTrM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:30 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:29 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 03/11] nvmet: Add nvmet_fabrics_ops flag to indicate SGLs not supported
Date: Thu, 13 Mar 2025 00:18:04 -0500
Message-ID: <20250313052222.178524-4-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0012.namprd13.prod.outlook.com
 (2603:10b6:610:b1::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: a1baa92c-73aa-4239-ca59-08dd61ef0cf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7bhBDHF/mp82v+b72ERQwI0yooNOn6brD7IjVqJ/6x6bQIZSpoh1tnkdeYNe?=
 =?us-ascii?Q?BTOMXm0oLZt1WgLHdVesNlsTUSQ/97Rh1FNY54y2BQSuhErti8VdzT5+xWY5?=
 =?us-ascii?Q?pHaJt3D5U8vcd/AgC2i13gZNZMFwyz2BnOt4eCGt0uz6/ZmoVbe4SgTTZVKK?=
 =?us-ascii?Q?bwfPdeRVp7JaZDyTRtuTt62tdh6ptkQx0x14dbStpoX926anzSIYLuctlxfL?=
 =?us-ascii?Q?WEExulkh5PjNAocgXrTxAM1Y56VeXipYATVPIOoEvLhaRIhXQTGka4zXsOYS?=
 =?us-ascii?Q?bFqLft/3emN/WyLxmdNjbqDLZhUSCimMAYL31qghim1gCY9jpDZh9RrDsAFo?=
 =?us-ascii?Q?N4+1Zt9oEKkazWHHd5xivm/0Yc7Bnm73ETbL6v4FKD7Dhs1K6mhpOqaaW9a/?=
 =?us-ascii?Q?mhktZobEts6euSH3eFqG4psVAcRRe6FutR60NLcWbDmzGE199oRVE7zfBvyv?=
 =?us-ascii?Q?DdMlnibEOH2BiATIm8O49Zt7HQxzT08J3YOgJVItVOfHQF/1uYpZ+eU8lwNk?=
 =?us-ascii?Q?bQkvIeOfvRmpqPVBJPTnHMlY5HQnMpphohx/Ab6KCq8zBkJ6LhSTIpLyaUPd?=
 =?us-ascii?Q?nPBWJioOx6LwCZD7XAblT6yZTONd+Qk1cBw1vOfTUBNxTuLHD0yQ5YYjGbNo?=
 =?us-ascii?Q?4KhkCNocEW1wYk1Sj8ai3VyTkzbJeOB4dfE6PqX9FVqQzJtBNWOzVjanD4Wr?=
 =?us-ascii?Q?fWgYMJn+MBAXlwGheO1AdfgQynrsBKN59nQY1lv7qWSszjliFGtNPRI0dyt/?=
 =?us-ascii?Q?2YgV77dYSRugf7ocxj/6MMayxp50M/+Q+jaVJFw+mGSY3uwPROTlC9orHZ7m?=
 =?us-ascii?Q?QFEjrEuJXKTTkO43vAxof/12o54QCMH48ggmZD8m6pfyVjtr2P5jqr7UVczI?=
 =?us-ascii?Q?CPeijn7VgNxko9lwbrOC/2azpti1dQQrtLOY7wi9Jqhh9webgbAghajFjeTv?=
 =?us-ascii?Q?AM3sRl/7aa8/j8Ps1nL4eV8wGd9mMsEq+2IlIvcydpM6Glmt7RBYfK671vdJ?=
 =?us-ascii?Q?HPDQbPC6EYCq9Wz78lNw6vCFAvZvVMz4IXNbLiIc3uynM3WG+mxLXMJGw0Tc?=
 =?us-ascii?Q?+yGKIaztHY7Nk6GBmVglLsi2f/4FJm4NOPe6F6q38OA5rENxsKZov+rFpV1y?=
 =?us-ascii?Q?NfD3lEDp2CTgeqlPGaZ9EzzIvreEZZqILLA75NvdWlMHZKm0Y1S+F1zgEx0R?=
 =?us-ascii?Q?ObwCKpPgFyuoKSoe5pQS3aDTYNrGe3RN70epLagMAhqUqZZthEWizTr3Fpv+?=
 =?us-ascii?Q?Cc+QD3N2q+1Knr5nkzvFB4TpsDzIqbICW9l1KYK+wnP3MDIKXur0cdMuXPpI?=
 =?us-ascii?Q?Hirc1HpBswdw7qJn25A2rzTn/r15n31JK9nzbdC/cHmGiAzXA4T+8ypRS36a?=
 =?us-ascii?Q?Npmu8oZkWvMcCNewICxKxk/CKWyzX4aOQ6eBzSayvECWcosW5VM9soy8D3at?=
 =?us-ascii?Q?sUSz3s48Gbs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XfZPkBQVlDBlSuRePhL+9rVZs891eM1IF4AMqiVbehWzvyT3Yatbd3grCw0/?=
 =?us-ascii?Q?FD3h6WH0XZUfO04ZH89RC5rALRVHUJizdUCH0NvACMEoY9sCWx+tSmPUAAnM?=
 =?us-ascii?Q?0YbeyhH8ZNE0vFJ3FBzlTfGYzLBC81QSA9B3oEXbfPmBo/gX+HnL/GQAaBwL?=
 =?us-ascii?Q?8jPdW8NHmMmgI7b4Mv7a8S8WzPQz685v0uNiK9VBDZnd9VEAJ5ErMkzB2qn3?=
 =?us-ascii?Q?bjcEhdzhsI/X4su97o/QVJoUDwahdddtOdjloGU/yvgYuQO1fc0ASl/qdEBz?=
 =?us-ascii?Q?XlSTMMZMYGIsLQe0N1SJLWDdbc9FFSECM49kbY0Dk4vhGKQRnSc96r75FBL6?=
 =?us-ascii?Q?mz1XQ1R6MxjCG1gR6Tv4tI6rnNcntIqIu/sRHC9I07SD94MhfC/TVDIU8S1s?=
 =?us-ascii?Q?a74ZjjEWCX9G8r+NbVXtsPiGDgU5BPupbns7+mM8fsMEuC3FfvC7uqDa8dCZ?=
 =?us-ascii?Q?H1UYyST7uM71K80eRHAY+oh4t4AZti71IJSpzZNUPMOvSUh3wyqg/v7/NwKo?=
 =?us-ascii?Q?ZkTjlwg1r4/vsKbKpW9TUdRK2ntZW7L4VTYJTRGpkbLXUpVlZxyHCWpYH24E?=
 =?us-ascii?Q?gS6nhJOLfvm5XdNpfVWDRdJVNvbQ2C1bn0i2d3TcHSPXEGB3qTtvHrtZdXEv?=
 =?us-ascii?Q?3nRy02PrM0pwU1heRlwndTh3W7hca+9d+mE9x1cItOQXkxJpdILTfGJSdBjC?=
 =?us-ascii?Q?hytWSX7MIiTC4TmKLWj8Pd2ILKDxu9Ul8oT6XKgtsufAAzITB0oIVIFs34tS?=
 =?us-ascii?Q?U50T6P0az5CD6e2JCssriNQiDmG9VCA6TPtOLJ1yxUHkCLH9gWs5lULGaFkU?=
 =?us-ascii?Q?G6faAGBsgLn1PsfbByTuetOZBtdCiBVjJIalwV329/tdg8ETevsmKZ/mKEaL?=
 =?us-ascii?Q?LIW5w6isPXiMjlqLBOGq0X12lQOYlx8XdNCyGYp3RKaYoAhUfVKviYNTXWXo?=
 =?us-ascii?Q?3RxBHK4zFNYK4Fwx/GQQFifM2Zw7edtPGDl2FXnKS095pKZLUKIh+jNqMU+1?=
 =?us-ascii?Q?Y0KPkmwl8VOB2DbgLOSgn1JIt353pq2FDF2USgYKoNXEh8F+SHrTfN69s7cT?=
 =?us-ascii?Q?3Av/v3aN1ZsaffXIPF6LZsnVT0HZAEd5pp6muVRC4taGoTmMCAHrQygWy6kR?=
 =?us-ascii?Q?yk/gOM89vlw61yDOGjCcrmIxD1Z+OAyM+fYuSEFCF/v66TBrsNFWXk67o4Ez?=
 =?us-ascii?Q?eOHe6NrLzKwMbdIV2KQT7F8kXkz33cFNC9zpkV4BeMWdl+CUsQzmt+mXEdqR?=
 =?us-ascii?Q?SEf5fVAOLOzRvdp+ikWGNqJwDTJXaM3lGGwPRW8iCy8RZN9lzxzdJ99DbKht?=
 =?us-ascii?Q?Jk4UhOGw8Ruwc6/3E7ukQ9KB5+MxmTvTn8VUWSPz6u6HzjBWWCikeoXl3UNk?=
 =?us-ascii?Q?bu8RiibUgcoznv9AzrYQPQrC+yaFg5tXCeGGGlvswlYvMtZuW5C2XSlENIoz?=
 =?us-ascii?Q?YcEspVZ02Z3oBUfeg6r3/JQBFiSjB+Q4ewC9f47A8BSrToU8rVUQmUJnGJxb?=
 =?us-ascii?Q?/FB9D1ukwe61UCHO6vsBcNPgbfrIpGWXsThsIKYgEYRowu9IWW5vXaKFw1/F?=
 =?us-ascii?Q?onm2Ffo+Bo+dDA8XXFPFd+vVxq76tFQB/b7EiuZSuJvRzrZduFadYrr8Fh9d?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bNclBdoLqpjavORqnRCSJB2HgwLfrNIgJjwf/eyPFNhg0pPE4RJIaNQWYL8qkRwFN7ZyW8ITCZSVhWO2ihcgSeULizaQdESgpPQNYXA4lho41UK4RP72SBu53MccP2FYYhU5K/L+H6hMhHrxY3Colnsxomi0JCsz3kTwsY1ogSH37MXsbPOGwfxDYiyiK1mYVtqkGVH9MHU+r0LGzL6qOwqcPnsduxG5onFaHGpDA9ZlhPh3PTTDm2Fa5JQEzBxS/Yjef7To21PRJO+mD5q1pg0j3YXmAlOU5qLZiZVVbMRbVJ8fUzBaKkZ/gFRtcIzZ0M83zUX2gL4bbfAlJIzfLg2lYAJlZH9Lft729ztE1ZJc87nfGObxP4QkX1sm9+6/AlkageVvi7c3aMrekxVfPSqKnNrTyqCXBcuA7cZp5ZMaTdD0sfpA/6BcTYO2yosAXaG1TaLnC2Mw1gGlT1GgUw9fwXZA7644kTpq76FG/wviqzaeINzrhgdQhAf+NNfG1tdI/KUdj6W/zVvoytXHOqnq6991hi06gByl8stSzYBJ0bPtiRbfeYFuKSMWJs2g9AwoH2Y91xQYtX8PE7LprNIEHE3TXy/kRhqFUmUyJkI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1baa92c-73aa-4239-ca59-08dd61ef0cf0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:29.9494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 99/MjLhAJe5Q8dCI2YdFSk7vJmvW66Nwx9cfoEc2Zp8K0gLl3SB+D8jZFKJ14BzFpM3WbnLkiawJabLRY06mvgXhE3h4XbNOdhC3oflX40c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-ORIG-GUID: 8QU0jSUWpEU1ruOegEw8jGFCnz43NgtW
X-Proofpoint-GUID: 8QU0jSUWpEU1ruOegEw8jGFCnz43NgtW

The nvmet_mdev_pci driver does not initially support SGLs. In some
prelim testing I don't think there will be a perf gain (the virt related
interface may be the major bottleneck so I may not notice) so I wasn't
sure if they will be required/needed. This adds a nvmet_fabrics_ops flag
so we can tell nvmet core to tell the host we do not supports SGLS.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/admin-cmd.c | 13 +++++++------
 drivers/nvme/target/nvmet.h     |  1 +
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index acc138bbf8f2..486ed6f7b717 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -755,12 +755,13 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 	id->awun = 0;
 	id->awupf = 0;
 
-	/* we always support SGLs */
-	id->sgls = cpu_to_le32(NVME_CTRL_SGLS_BYTE_ALIGNED);
-	if (ctrl->ops->flags & NVMF_KEYED_SGLS)
-		id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_KSDBDS);
-	if (req->port->inline_data_size)
-		id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_SAOS);
+	if (!(ctrl->ops->flags & NVMF_SGLS_NOT_SUPP)) {
+		id->sgls = cpu_to_le32(NVME_CTRL_SGLS_BYTE_ALIGNED);
+		if (ctrl->ops->flags & NVMF_KEYED_SGLS)
+			id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_KSDBDS);
+		if (req->port->inline_data_size)
+			id->sgls |= cpu_to_le32(NVME_CTRL_SGLS_SAOS);
+	}
 
 	strscpy(id->subnqn, ctrl->subsys->subsysnqn, sizeof(id->subnqn));
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index fcf4f460dc9a..ec3d10eb316a 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -403,6 +403,7 @@ struct nvmet_fabrics_ops {
 	unsigned int flags;
 #define NVMF_KEYED_SGLS			(1 << 0)
 #define NVMF_METADATA_SUPPORTED		(1 << 1)
+#define NVMF_SGLS_NOT_SUPP		(1 << 2)
 	void (*queue_response)(struct nvmet_req *req);
 	int (*add_port)(struct nvmet_port *port);
 	void (*remove_port)(struct nvmet_port *port);
-- 
2.43.0


