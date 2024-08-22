Return-Path: <kvm+bounces-24840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7348095BC9F
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 19:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBE461F23973
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78361CDFDD;
	Thu, 22 Aug 2024 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cfkhz4NX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BoB0VdyU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893F72C190;
	Thu, 22 Aug 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346080; cv=fail; b=IN/52PyMHaGUDEVv6CG9Rujl8lAJkTNZSOnuIeYA+hHcBTQF0l0Q3JTAPAvYFXbx5CHwx0gacyGZr5jF61esChZvlggJHiySEcUYDwDdpntNy82T860G04oXBSK/vXmDjiGcbpwYmbhZPlkAk7TCwe1EhN60JQhtMeVmUrDfZ6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346080; c=relaxed/simple;
	bh=X3r/JX/WyZk7vA84UpVLrtfyEZiU5RoHDHd/AMYT9UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PyRZZCCSLZAPrpfddtJWMG723MPaKno+WezsPKvcxEKMWDyug3OQHPQU2RQS4cRQ4aN+cUdSboXReY9Z0fQSNy8yEBPIFuLcRj4VcrKwN8h2D1WXHS0Fhpg1fs9FbeActv3QkRWkZE/lqOfnGjlEHap1A6Aqg6s3yUc9iA/qmD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cfkhz4NX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BoB0VdyU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47MEQY8b021315;
	Thu, 22 Aug 2024 17:00:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:in-reply-to:mime-version; s=corp-2023-11-20; bh=t0AlWjAYWJETiEh
	7/13yMxFBHQAXf1RoX9lyZnQLhpI=; b=Cfkhz4NXarGfsCTyr99rHUFqKaJS+lC
	FXBYaJh8fcMRui6YIAwXpTNynXskLtTcru/4Osq9KgLIaNg8DbqZV4sRb6PtBodL
	jtPuSCa/cAYw6qj3NyZwjGQl4XY8iNOhrAbmt2fJl2E3MqociCEJ/oNojmhVeFj7
	EYSKtUYred0mEykQpzE9sFtsxohNBsBl8rEMf3aDScWmc+1TRkE6wy0sduHQO2VR
	2+WLm/8iv9ROMOoM5lsYYd5Is8wQh7pj6NCgLNtiLMu8DPhCWjYuxWVS2rO3w0co
	RTFMFvnzQM52sjNjKUHYFgje+cwRLbbu8VbxhfIjxSlgKL8P1UsXP6g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m45jjw6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 17:00:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47MGx6I8019572;
	Thu, 22 Aug 2024 17:00:58 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4169b4g4gc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 17:00:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qGVqkgoQ6vwcfd6yVRaifn5+TgIz67YuPydHKKfkzgS97LnKjfil3ShZT0NI7o30ilSHlvFbzBsa7GoYsFbfR8cNs8I5BqjCC3Ld4CcS8jUqZDXmpf8bchWhlrXu0xMveNlMCFbtEMyLflIOVHZQtpENZN/4aQ24sjz8IH2bX8VUolghs3hHAvBkBtB7zc3z4Tf9xav6F3/jmRQsS/91mqj/u5p88WTcCu0Yv0dymLflW/kpV+r+2H0pIQTeL8kQHvPawJtNGSrNPlGD/Y//ixt93fWIXTbyYoYmw086IGzsuZ8DTsPaea3VEfK+PPescky77cAMew993NYzfpEavw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0AlWjAYWJETiEh7/13yMxFBHQAXf1RoX9lyZnQLhpI=;
 b=pJRPsRd7jIvakGbM7eMazyOZOFWKQczfijz/VVRMooLLjpzCpy3VFY4CtrPhJ3rkzOfhBcWYW8tQPk/C4OBd2ROcJtPGTrjXVL1akpfEY+CwsYIUQiPIhVFHdxHV8JqPwFZNhSXf2OuF5aT592lE/yZuNCjtSaMpYlSADhI3BytmYVMWEqTzLG7R7+2ck+an+kyBlvP/h38h5UXOnxm1uIaI5dK+iokK/v0cpq2VI26ZvcHFgOdgLOTqdrzS9CXpg/a7gS22We2irPITiAnXPRSromWl8sd5ppsfMvFRiPqUo/mOhFMk6zxCTH91o5lFSK9iwZ47pmPySE17dCuTkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0AlWjAYWJETiEh7/13yMxFBHQAXf1RoX9lyZnQLhpI=;
 b=BoB0VdyUOGiD/PXggLLxUrEXOkxmxYu1xHBZ0/MyiU6gy2GAkMGfPIJul1JH/kdD4lsFJUzMWPWyeXDmxNTf3pjr/YajdWe7br8ZSS29vLaNaEJvQY7Uf3vHXo7JQbvyQWgHKdZehg6RYbjvVr6g/7L0OTRXsFEVPVQDs21Td/g=
Received: from DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15)
 by MW4PR10MB6533.namprd10.prod.outlook.com (2603:10b6:303:21b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Thu, 22 Aug
 2024 17:00:52 +0000
Received: from DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490]) by DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490%3]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 17:00:51 +0000
Date: Thu, 22 Aug 2024 13:00:50 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: pbonzini@redhat.com, chao.p.peng@linux.intel.com, seanjc@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH RFC] KVM: Use maple tree to manage memory attributes.
Message-ID: <s4ln7kgzj3jlpaei2e7j2n3w3xq3bgeed4kgm3xwadlxu56b5b@tgmxd4psomda>
References: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT4PR01CA0426.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::10) To DS0PR10MB7933.namprd10.prod.outlook.com
 (2603:10b6:8:1b8::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7933:EE_|MW4PR10MB6533:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff09304-407b-4311-ba74-08dcc2cbfa71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fjaZoW5rz5Mk0vbrmxzye2QP9zGkWq05/5uonJ/9f9NTir+SQEOBl9ZzQnz2?=
 =?us-ascii?Q?eslzfkk27M5RRAH65gj2P9r0yf5ZV6eIRT6xn+xSmVlJL+AOT7bRWX7MpTas?=
 =?us-ascii?Q?ModJIbwvqFGRMJXXOkFspnrIs7JruusOJ2Y4du6IIJNlse3jpmEFcQgnqAEd?=
 =?us-ascii?Q?hRv6TvyKqQ1vVcgODPeOz3LGygkoGa2oQt9nptKCwPEl6RtIYAmn3LANHnhX?=
 =?us-ascii?Q?5cGdp2iItCCQD+wlScGQA2liX+i5N3ImwpzS3y7sMjKHaMxKzFrvKAqdgdV0?=
 =?us-ascii?Q?t0w5gOkW3vvQm8S54Lmoapd3WH/FAII6BfxtaTMyRY3MMP5m66BSJ4cZ0HfV?=
 =?us-ascii?Q?g18+NUBmudZth7QJz+0UWfmXNkDHCLFUGxaYzVxTqjE9ecHNA8LOb0j8a/aH?=
 =?us-ascii?Q?UfkUMLFN+W6y8Vvd0kzZfNNUly1/4j3spQ7DWdAgzR1gqGQgbhjS4susuZtU?=
 =?us-ascii?Q?t4goX9Um/nLsTvd0/nux/F8/WckqU1PKEuuEWDvP3LEY0deun0q5iZukCilG?=
 =?us-ascii?Q?caICMghY3VtexLWYLR9m4fdGhxohOU3pztgtksja9AfVWkLwvILajgkwqhtQ?=
 =?us-ascii?Q?CCK2D/9d1PvKwXhOdmNO3zFmAT8FSvZ6OJzd1X8uSi5nOAl9d84FxgHFlJI4?=
 =?us-ascii?Q?iJ+8ZoygHn70Qxw9TP6W9duKexZLo4W3CbFRahIRJJ7yIFIlRMnJQL2Xi8Nn?=
 =?us-ascii?Q?JKd2UZw3kBLvNpbNhp3gaEt5SaHyG1kW9MsjQa86K8WjXjbci4NJeUgM/d0S?=
 =?us-ascii?Q?fE6bbLCT2kN9Yi51LrlQ0FRgS7HqkL180gUeKlCoVUWErqh2VOTDLD98gNIx?=
 =?us-ascii?Q?iToQHyaxjxzwdadBLh87EnWs8RXIcRRRb0MZ4xHB2ZVBbHfTNn9R6ON4N7jL?=
 =?us-ascii?Q?K1FWp6taNBJ4bfINq6AN/fxh+etk0858U3Ch2sCaw4v8z5n4WDJqnROlVjyo?=
 =?us-ascii?Q?ncGtzanqbo8OJBiKb4MougKa7ie1KE+k8qriBmtOc8eSFxsWlwyZDK5lcU9F?=
 =?us-ascii?Q?76QSD5n6J9QLmh1/Wjjlltt4uzWgGNEn8yk2gDaoCyEgl5nH5o+aVPJ299Tk?=
 =?us-ascii?Q?L2nqHQgf4dCMwHv0XFNug3tIm8Rr5c1eZxbpPq86pvEjw/t0qAw5FkkFb3Og?=
 =?us-ascii?Q?2BkH6ul4B6z+TWnevJEaizGFGyuUCCnglh7X8Njbd2DPOZ88cZTyLNoqs0Kc?=
 =?us-ascii?Q?lG44Ceh9fkhjPWYgqDY1YdwwYUxCpfhVvaJ6UhDeLYxF+8gO8Mvh5jpIdx8y?=
 =?us-ascii?Q?CmgBCFmKaCQkUNNhn70vs2FBcBKMF6Cd3s7sekW20uT2+McIsfLYvq0nbzCF?=
 =?us-ascii?Q?EdI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7933.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4HKAQljNNYybhjw1dMSiraU991eeJW64koqspId48VS7GDktCDlS69VXlsYI?=
 =?us-ascii?Q?tZBiMMFUzpMHGUt7VGa4h+e9OgyY93891cAjAfdD5uuGuQrKrBZu+xT+9wFq?=
 =?us-ascii?Q?pjEGwDNqOryDAxWL5crivFTMsAMux29E3t8kRd+LTXdoyE+BYLTCbXjy/omj?=
 =?us-ascii?Q?uepwit/VcuDOWvfpEmCURki2CJuxtL90lk8JKbl8Cg19nlmbaYpX4dr7zrA0?=
 =?us-ascii?Q?REL5M9HdbpL1EPtYV7ysIXJpTIiGG8dcHxxLwGBVlxc1onBbST6qRl/x3SEm?=
 =?us-ascii?Q?3C4tu2CIlXtaWrmBsnPrcjSjDVvBfeLNueDFJhYUAiOnxBah4TUHq4je5RZB?=
 =?us-ascii?Q?UjxGVBqzZgUzjhIDVD+OhoaLSHJ8qgQhOK5+MKPgkfZShRZZIIkDMqgrq3fY?=
 =?us-ascii?Q?ROGoi1fUU2rnlyPlSpnM1p0jGKaN1SpbOwtMyQ0vT880reGODbirWeVHq3ad?=
 =?us-ascii?Q?NV0UC0cDu0h9u7dxcigzsHTgic7fPK0h1WQ34cKgHhkDxMSuUt2K61aZtCf6?=
 =?us-ascii?Q?6H6ihzSO6aDMgIds425TFy1ik8Cc/U5QSCPY9MkN0ZFydp2gjRhr8PWbg06e?=
 =?us-ascii?Q?Y5Ps82Z9MU1Zm4f9SgGpMiJX9ytSXiYnco3v7YO12esJFQpMcu8PJwUUGiza?=
 =?us-ascii?Q?qJgN2PQhKtfbw6NuE2pa5Rdkv6cymjWjhxTxx/jW2Os36iBfFctCpmvLrDTt?=
 =?us-ascii?Q?mW/ed6sqOS6bmqJQolWw13qbwwOVFc/QWSrGMby955YWQ8mLckzpZyg3ptOo?=
 =?us-ascii?Q?ZiZagyB4RB9YMl+MX83hd7aDnID0BWZWFMc7L2v8sTmA1HtX1eGmtG/S2KMF?=
 =?us-ascii?Q?YdVLCPcUM+J5KR8zW4iwUF+NLmXV4mDT1Pkqw51Eynm7mD/YxMeRb/tsYlh7?=
 =?us-ascii?Q?1lIxU8LAffdHaOgc9lSFgBIkWUjLFNXECTEsyHpLxb9O/8OBptFIgwlRLodt?=
 =?us-ascii?Q?fmuhJbdrnv1MtirfoQliA2xFdY2cbzaKj0xqt6QhznSNF2jTdGAETqoOO9l9?=
 =?us-ascii?Q?RPpFU9MfKTxotsBbVyJjC1j3mHvepiQayeZJfiRz8kzSMxGZwGcJoZbddBJI?=
 =?us-ascii?Q?QPHJ+Ukmiccl7ytlmO4Kv9SH4Z/YjNy9ndW7nqoDUF/EtAc5018QjIZxU1Ks?=
 =?us-ascii?Q?g5+ObDZ1c7MfAIhKrK7A53WRMVfbRXOYggjgHN1+KpCEWYmwuDNLvqFwLd8e?=
 =?us-ascii?Q?m9P1aLe5n5CObu6clrRC0JFt+i1iIvmGfVTBC1KOd2WrzXpTI3EvCGM1prZ8?=
 =?us-ascii?Q?GeOQwIf7SkBD0PYgIbzhMqGvi3CHhP+ICouMp/eOx0ySqdS27YuCeImO5zd+?=
 =?us-ascii?Q?MLLSl6otU1JhzbO23RBYjpn+y80ZLYzMNxjF6z+auTVWeeZj+V4Eda5Dka4Z?=
 =?us-ascii?Q?asxQQ55c9FbmMEYCqj1ZX5lI6NC1bIvYOGXjucpanonphczub+hLKOMOCfhJ?=
 =?us-ascii?Q?TgoV791vMzUMXzcBfF1XjHW0RIGIBDlPUBoB5opSRi544uNjx0SqpBX0xbNX?=
 =?us-ascii?Q?Eypv0DpzYK4UGX8qz2fgL1ceMjfak/AWRRw7yWgWR8lT1DfAkQfkTsFtUhwK?=
 =?us-ascii?Q?2tWGwCxg85TXjQ7F06oZcVtEXOz/KYtwk32INlio?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wUi0JLNwxoaFnTtRpuhjsMLiL+mMUHDw0VZQuy6q1fzvi6rASVEpSBP3LUu/DMwtQS2fXVqHucUlVQx5nZIxP634Wh6LKZzuERNS1PaC1ZZpsJZ1p5WR00U0Di56M4zzR8/eIFmgAOPpVdpwq+RYOsq0sV1SZVsrUfjUsYDyF0WGQ1Td3x2ujVUKx8MsqTYxrCaE706nG43fIQ81q9d0AVQv9UPDIWAcvJRqIk2TRhLPV0ZtWdb1eL6nneX0sV1+uTvst7R/4xGlS+fSgshzj6zHp5AI5qWDUXSpjHfYVARdpX/gj3/C297a7hBQDSAqdFOiguyehYaJw/Uam/LR902bjDU6LrDmC1pUAQi8jn3FofQ9DKLd8MRjQ6RrFi48ebXBEWlYJna8L/huOcXnsssBWUgkAgTQerDRKSj9zyEOFWiQIlP/fb0Rnm22lSGOX6C7sdLG4lzzGYRZzVV5J8SMmct/HmAuBFbHyD+6x5XC0k9cFVex2hixF1B3f3i+IDHyCBTEACRfAhaZLfsRwV5qT+AzuUDiFUlr7t17BrIhvPl5I+DqrbLJJxhz9fNbyhnFUybc+cKDP/xrsl7Us+4wb+QDC4OxIwDZUOw3guU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff09304-407b-4311-ba74-08dcc2cbfa71
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7933.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 17:00:51.7619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VaAaIOHi0GCKj1FwUi5eZDtaFbt29ZCQZAju50lSJDYB8/1oSIY0ZBn/jPLrf6zoJbKBFIs0g49ambWSM1OyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_10,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408220127
X-Proofpoint-ORIG-GUID: kf1YFSWnlzyQ_3kEKvleFAXELqIZ2RXu
X-Proofpoint-GUID: kf1YFSWnlzyQ_3kEKvleFAXELqIZ2RXu

* Peng Zhang <zhangpeng.00@bytedance.com> [240822 02:56]:
> Currently, xarray is used to manage memory attributes. The memory
> attributes management here is an interval problem. However, xarray is
> not suitable for handling interval problems. It may cause memory waste
> and is not efficient. Switching it to maple tree is more elegant. Using
> maple tree here has the following three advantages:
> 1. Less memory overhead.
> 2. More efficient interval operations.
> 3. Simpler code.
> 
> This is the first user of the maple tree interface mas_find_range(),
> and it does not have any test cases yet, so its stability is unclear.
> 
> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> ---
>  include/linux/kvm_host.h |  5 +++--
>  virt/kvm/kvm_main.c      | 47 ++++++++++++++--------------------------
>  2 files changed, 19 insertions(+), 33 deletions(-)
> 
> I haven't tested this code yet, and I'm not very familiar with kvm, so I'd
> be happy if someone could help test it. This is just an RFC now. Any comments
> are welcome.
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 79a6b1a63027..9b3351d88d64 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -35,6 +35,7 @@
>  #include <linux/interval_tree.h>
>  #include <linux/rbtree.h>
>  #include <linux/xarray.h>
> +#include <linux/maple_tree.h>
>  #include <asm/signal.h>
>  
>  #include <linux/kvm.h>
> @@ -839,7 +840,7 @@ struct kvm {
>  #endif
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  	/* Protected by slots_locks (for writes) and RCU (for reads) */
> -	struct xarray mem_attr_array;
> +	struct maple_tree mem_attr_mtree;
>  #endif
>  	char stats_id[KVM_STATS_NAME_SIZE];
>  };
> @@ -2410,7 +2411,7 @@ static inline void kvm_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn)
>  {
> -	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
> +	return xa_to_value(mtree_load(&kvm->mem_attr_mtree, gfn));
>  }
>  
>  bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 92901656a0d4..9a99c334f4af 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -10,6 +10,7 @@
>   *   Yaniv Kamay  <yaniv@qumranet.com>
>   */
>  
> +#include "linux/maple_tree.h"
>  #include <kvm/iodev.h>
>  
>  #include <linux/kvm_host.h>
> @@ -1159,7 +1160,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>  	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
>  	xa_init(&kvm->vcpu_array);
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -	xa_init(&kvm->mem_attr_array);
> +	mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN);
> +	mt_set_external_lock(&kvm->mem_attr_mtree, &kvm->slots_lock);
>  #endif
>  
>  	INIT_LIST_HEAD(&kvm->gpc_list);
> @@ -1356,7 +1358,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	cleanup_srcu_struct(&kvm->irq_srcu);
>  	cleanup_srcu_struct(&kvm->srcu);
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> -	xa_destroy(&kvm->mem_attr_array);
> +	mutex_lock(&kvm->slots_lock);
> +	__mt_destroy(&kvm->mem_attr_mtree);
> +	mutex_unlock(&kvm->slots_lock);
>  #endif
>  	kvm_arch_free_vm(kvm);
>  	preempt_notifier_dec();
> @@ -2413,30 +2417,20 @@ static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>  				     unsigned long mask, unsigned long attrs)
>  {
> -	XA_STATE(xas, &kvm->mem_attr_array, start);
> -	unsigned long index;
> +	MA_STATE(mas, &kvm->mem_attr_mtree, start, start);
>  	void *entry;
>  
>  	mask &= kvm_supported_mem_attributes(kvm);
>  	if (attrs & ~mask)
>  		return false;
>  
> -	if (end == start + 1)
> -		return (kvm_get_memory_attributes(kvm, start) & mask) == attrs;
> -
>  	guard(rcu)();
> -	if (!attrs)
> -		return !xas_find(&xas, end - 1);
> -
> -	for (index = start; index < end; index++) {
> -		do {
> -			entry = xas_next(&xas);
> -		} while (xas_retry(&xas, entry));
>  
> -		if (xas.xa_index != index ||
> -		    (xa_to_value(entry) & mask) != attrs)
> +	do {
> +		entry = mas_find_range(&mas, end - 1);
> +		if ((xa_to_value(entry) & mask) != attrs)
>  			return false;
> -	}
> +	} while (mas.last < end - 1);

Oh, a contiguous iterator.. This is what mas_find_range() was written
for.

This should work with the guard(rcu)(); call with the internal lock.

>  
>  	return true;
>  }
> @@ -2524,9 +2518,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>  		.on_lock = kvm_mmu_invalidate_end,
>  		.may_block = true,
>  	};
> -	unsigned long i;
>  	void *entry;
>  	int r = 0;
> +	MA_STATE(mas, &kvm->mem_attr_mtree, start, end - 1);
>  
>  	entry = attributes ? xa_mk_value(attributes) : NULL;
>  
> @@ -2540,20 +2534,11 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>  	 * Reserve memory ahead of time to avoid having to deal with failures
>  	 * partway through setting the new attributes.
>  	 */
> -	for (i = start; i < end; i++) {
> -		r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
> -		if (r)
> -			goto out_unlock;
> -	}
> -
> +	r = mas_preallocate(&mas, entry, GFP_KERNEL_ACCOUNT);
> +	if (r)
> +		goto out_unlock;
>  	kvm_handle_gfn_range(kvm, &pre_set_range);
> -
> -	for (i = start; i < end; i++) {
> -		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> -				    GFP_KERNEL_ACCOUNT));
> -		KVM_BUG_ON(r, kvm);
> -	}
> -
> +	mas_store_prealloc(&mas, entry);

I think you can just leave a spinlock and take it for this
preallocate/store?


>  	kvm_handle_gfn_range(kvm, &post_set_range);
>  
>  out_unlock:
> -- 
> 2.20.1
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

