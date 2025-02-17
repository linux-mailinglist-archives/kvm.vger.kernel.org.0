Return-Path: <kvm+bounces-38374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29F13A38656
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 15:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A8B83BCA07
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 14:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27BF7222596;
	Mon, 17 Feb 2025 14:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IeMn6x0M";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hjYvYcyy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466AB21CC5C;
	Mon, 17 Feb 2025 14:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739802078; cv=fail; b=O2ixIyjkwVHR725ywOpocNP+CxFK1LGu2kvWdmnSGzDGbqQRPV3vpOnbBfO4k0HSXVMmUQrItzDCxjZ/co0MriqdsGu7gO2IWridemJI7r174DmtDWLzkjRojJ089zmCKUZF/oozewlWabfQTBpFdZ5G1mA+HBygwHE2DjHz7Xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739802078; c=relaxed/simple;
	bh=oZ6ZAzUm8uCCdmfveFJwDzo/jObr1lh9Ran/56pv4u0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tuCoY+5oIyDzvXy8O4dxa9vA3BPqF0YIdorHeF4iljkexkUXpsjK+4zTt8uRCO6CzgTHJNPivQtlgZQ/lixrgjBl7tIPoG4Ipi/uWPnW5rPC4/GJoNafh98cvNN/CO4/gOcZiVoPrOAf91HOxF+ZLeIPDKKGsESg8X+23QpTXDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IeMn6x0M; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hjYvYcyy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51HDu4g2030116;
	Mon, 17 Feb 2025 14:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=8o+JOFufCi9BvOtO82PIwWOLlvvn3woHhuoRwSBSRf0=; b=
	IeMn6x0Mta5t31RS6ZYN9kn7Q9AbdSZeDaBDNWOfGikFhEdliOEeF9KiLfn2l3Q5
	abyqbXNpCz2Lwn1MOJHu2m+7eWcXYD4m3abKqD4TVV4wW7tRyLjpTwPnPrk8Y0VC
	XBWNhz6pLabPsRkJOfK/nnZhsals8mv0NhxAgU8o/Xj0kbrFIhjDd9tyRyHBE10W
	MEOkE/6cSKBs0XAIRau2GGD8M5FciRchSE11FlwlOqfLmcDw9qWnNFivOgMYzBki
	BKtQQt/rn+xkZ1AuYMpBHmGGtJSbH7YIXygY1aVd1ZrZjTO5VgrRJDLke2TR+B49
	mhU9zsV9bcr4XYfbnFp5Ig==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thh04d8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 14:20:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51HEI95P004256;
	Mon, 17 Feb 2025 14:20:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44thce7mvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 14:20:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ONn/AYD2p+JTPdaETHFELIMVxhWI4K3cz3s3zPI20QaFdC3RKqb1+nYjTghwZc/73CGGkjdYJshKTcZySqizvDdy5ogwxpqV6KIxj4pOnv3JpQK1fmKpxgES3fO2ZIRNn984x1z21FIglZFLMzRPWxZ0sjQ2SD3ci/HblAvfBwcsCeP+F5C7+W0NufAreX1cZHsMbL9mA4nnomqd0Ufagpck9usSQ2ZV9G+yHraeijH6VBf0MzkmkRT1ovXyTkiziFJnJFvXWx0b5eFd/eFk54p7HlU7vHhYP71l7ahI4mSsXEZXZwrr/zg7kjekp7ne+Ajlg2Xpm94ET1N2HuDc2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8o+JOFufCi9BvOtO82PIwWOLlvvn3woHhuoRwSBSRf0=;
 b=dREPX7Pdtj72a6Ol+sdnVszesSeVlPmSY6AnIpEM4Ks5rh0s+f3Izb/VMUKJfv8kygVo+FXWUs6dpmXVw39g1JQA4dRuiBRmWpJT9/UdumvEXeqrLhIfGHE3jt+MLOpcr6WoZQyAAOVVhCrnXkmtdI0Quk2Vp/E0qV+3UK3ihjfRWkgubRofsHVfxBN8Qhx7hkAw9J0mJBVK3MLHUWghwd8HdPNXcESfaVHm0O2tDdCj+fsz1UHezV673itieABeKraVy/oUfceiM7qeVKlAiQvzy/s/3K2T1jTOdRmARXxleUY7hV5h5u+StPd6OWz7n70GdbE1ypgGxY0qqy1QtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8o+JOFufCi9BvOtO82PIwWOLlvvn3woHhuoRwSBSRf0=;
 b=hjYvYcyy8HDHpPr2ivfaQBEqkKT0nADP2Mlk6T6zjl7jMc01XuW8QuS8AZYtn1iIrwYDO29w6dctGyFiKqPj6QIGPoyxpkfP/ZXapRC4sWz2RqCOoxdydRYHU80+w+XX5WD9T0+EGv3CrsxuM8Wu/hZ1lX1A53J6Q0LF1eB40Vg=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB6325.namprd10.prod.outlook.com (2603:10b6:a03:44a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Mon, 17 Feb
 2025 14:20:17 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 14:20:17 +0000
Message-ID: <abc3ae0b-620a-4e4a-8dd8-f8e7d3764b3a@oracle.com>
Date: Mon, 17 Feb 2025 09:20:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: alloc_pages_bulk: remove assumption of populating only
 NULL elements
To: Yunsheng Lin <linyunsheng@huawei.com>, Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>
Cc: Luiz Capitulino <luizcap@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org
References: <20250217123127.3674033-1-linyunsheng@huawei.com>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20250217123127.3674033-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH3P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::14) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|SJ0PR10MB6325:EE_
X-MS-Office365-Filtering-Correlation-Id: 4baf2873-bd70-407a-a75a-08dd4f5e33d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnJjM2NVUmtYUzJrbGRvWWNnQmFjUjhXWEtuWUFIMnY5WE8vQzBxMUl2eUpV?=
 =?utf-8?B?L2pJZFVGclNGbnVzZ1FrVy9RY1Q0aXVqeU90ME1EbExmR0h2RXVyZ2ZoSDFE?=
 =?utf-8?B?U2tXUWdKNXJLV2lvV3Z4UFNadS9KUzV6OCt4SFRRa1R5WFdQVFVSMlhJVGpS?=
 =?utf-8?B?MEFuUWZHc0I1Q2tCbUFYc2lGREcrMDJoYjkyWnBic3RaUVNxU0E5enVlQWVv?=
 =?utf-8?B?UUl2U2JZSVVUOFA4ZTVqYkFoUGE0ZVFQVDNnL3NYa2tSWUl3ZzAza2M2aGNW?=
 =?utf-8?B?TlloVzVYbVVPaFh3OHdOS2FHa3BEdDl0YmVHcFNUcjRwcHc2WncrY1V5WWV5?=
 =?utf-8?B?bWtsSVNMVUZGNXh2dlNOb1Y0R0sxWUpsVXJZODh4TlZpNnYyQ0dQUStsakZp?=
 =?utf-8?B?VEhYOWZueDBYa1l2ZlV2NnhSYzhoWVpiL3pXS1ZCSjRHako2R1NRdXdLOVl4?=
 =?utf-8?B?ZXZoWlhsRW5iaFhVL1lTWHlKUWJRdmpabmliTTFwelh0elgwWW9CNFdzVmxD?=
 =?utf-8?B?eklmQUIwYXVvWGdMUmZ2YmxsZmVEcWliaGQvSXpyTVkyM2NPMnFyR1pLTXlB?=
 =?utf-8?B?b0NRVlRKdEFmUzExZXBNM2VFR0MrMitseXp2VHJ5SXAxUmMyYnBHMWVmbjl5?=
 =?utf-8?B?VUVzbndFMlp4U2xtYy9nU3YwT0J6WkZMMHQ4eUhoK0lUbkhPSFBRYkVGMnR4?=
 =?utf-8?B?OGREQkJUTDloS0pRNTh4M1hKWXVrUnd5WHhuU3cveVpoVGluL3FmMGh2UlJy?=
 =?utf-8?B?cUNxNm94ZDNXUzNIRlg2ZWNTL1MxazA5S1lHTHJqMndncnVFN3RiVURaTVJi?=
 =?utf-8?B?clpVcyt4WE42TXRmZ2ZkTUoxeVJicldITnFBZjdFdWlqdkJPRkQvUGdvTlc1?=
 =?utf-8?B?R05KSzI1S3hBb2w3Y0NqZ3VtZVBXeTQ0Z1pFTU1FOHZnaWlzRnpRWWdqaUdw?=
 =?utf-8?B?UWFYMkQ4SmxDeXpGYVRIT1NqRlVKYVhlVEYwZkJPdlltb2FKSWw4VEJYVCtB?=
 =?utf-8?B?N3Q3enFFakJJNEJtT2wybTlFUERaYUdvQTRkOG5lTVpWRjVldWxRNUd5NTVR?=
 =?utf-8?B?NWZJTHpWbVptUVlLcndYcUhHQUZESGdkWHJGalJzbFlOaksvNTVmdDdzd1B1?=
 =?utf-8?B?Zm5zMVRjTnNkZGZOUXlDbDAvNFlZTEdlQVd0ZERJQkdRZVc0UEQzUFhUTGRq?=
 =?utf-8?B?MWRJRVRZc1lVMnIxcG1ZMTJwUnBqVlhqMGdCbEVWaUtjTlJNZlNRV09zWjBy?=
 =?utf-8?B?dEJJOFFhenZOQ3QyUGViblNlbmZFMU9wKzBJeTVodElwU0pSaW1sbGFTU0w5?=
 =?utf-8?B?eTJ6dDMzYjhta2ZmcEtTUGErNjloQlV5TUZWKys4b1gxYzBnaUF4UzgranhP?=
 =?utf-8?B?SnVvMFI3SFNOc0xNZGF6TExiRlNLcFpaOThrRGNZOWIvVjJoMHBiQ3JtbzZE?=
 =?utf-8?B?ZVliR2w0SWRQZVR6R0tiQW1oMGFtTU9sVkNxM2NDTGtxblBDdE9tWlp0NnVr?=
 =?utf-8?B?WVhUdXErUkxoM1U5bmtWY2NmREU2V2NBUmpRQUpLNFY5VnBaWEc4Z1pmb3Rs?=
 =?utf-8?B?ck1UTXNJMmZtdGVOMEpYVitBUmEvMTBaOXB1TThyUy9sbWtYYUlUSHVsekQ2?=
 =?utf-8?B?SmpMN0JoOUtGcXFPY28wT2pRbmd5QVpYUzNjbTE0M2t6V1lXVHdPdDRtL0th?=
 =?utf-8?B?R1czWlhFRUxTSGhOZ1BtV1NsR3RlNG9uTW5vNFpEUUwvWjdrdFp1LzE4Yzk1?=
 =?utf-8?B?ZjV3ejFuTVpnUWM3eFlVQ05peUlCTWc3NGxjcldEU0Jlam9Nd3RuRG40V2wr?=
 =?utf-8?B?bDY3QloxdHFZckVQa004NnMxL2Y5L25FeXp2RmtZRndoRVYxczVpZlBtUXQw?=
 =?utf-8?B?VG9uQnJaZWk2UTV4QTlCVmpmRVQ2TlZkalZ5QlhYLzZWTnBwQm1qcmNUOUtX?=
 =?utf-8?Q?nU/4cLR3xBMFPywdJIDqLJG9yt/ksWg5?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3MzQ29YRms4WUpHRGRzTk5tTU8xM01QYzlwaUMrZ2UxNjZSRlpCNENLWk1Y?=
 =?utf-8?B?dHdWUjI2TVlXNXB1VzJ0dnN2NVhCVjdVRWtNeThIWWtmd1p5ZmxpTVkvT0Fh?=
 =?utf-8?B?dFd3cXFlTmFHWGM5REpWOVRaeDY3R0VHbm1qa3hWUXpUZmYrRHAzTHNHRWdG?=
 =?utf-8?B?ODBkeEF3VC82UVpqVDdtZjBrMnZPNlBiNGM1QmJUNHNUZkJCSXhsbFZITHFn?=
 =?utf-8?B?ZDFmYnJraDB6YVBTRG5qSmNYUnM4Yms3Uzk2MHVLYW1waTYrQ090QmNTZlJt?=
 =?utf-8?B?VWlQUGxJbG5Fc1B0K3RqdXNPT2d0ZW1VMnRJTWpZNHJHRTYrempBL2ZldXNn?=
 =?utf-8?B?Sk5jQmRiNnZSTmtLdStZRlZXWEZSc3VyZ1RIWSt2RkpOQUZkZ2xISUZjRktX?=
 =?utf-8?B?bFpKQTJ1enBlcnNUNmlGK0lINEV0SjdEeWZYR0kwdTFBcUlmRmIzeFRMREhF?=
 =?utf-8?B?UC9vRkd1S0l4TTZBN1RSMVF3TDM4OU1KQWpYZzJMaDhTbmdpQ0hjUU5MSUxJ?=
 =?utf-8?B?dDFjeHRqZ0JpZDVTb0JTSkNHckZyTzNUL29VTXRwL1BnUmtveGp1TGUwVHcz?=
 =?utf-8?B?T2JIMnpQK00xcEFKSG9DeTFUVExuNXhnekFEL0Z2R3Jqcy8xYlhoZ2VBVGw4?=
 =?utf-8?B?VUV3dklBelpwdEV0ZmhpREQ1c3VsRkRNQVlGL1lQV0Z4QUlpUkg0YnkxMHIz?=
 =?utf-8?B?K3hreDhHb2pObG13cVZoS1RCbFpha1FuWkcybHhoZ2dkbWVYZEdwM2swazNh?=
 =?utf-8?B?TTdwYkg3NzJRd0NrRWhhcmJKMVJSblpUQmxmNzB2MWxaYmV6N1pIUjlyelJr?=
 =?utf-8?B?azlTMVRRcGY2MEJ2K3BRc0I3ZmRYRWREcEJyVzFHaTdLalNGL1AwZEFlNmhN?=
 =?utf-8?B?aEcwQWpGVjM3NXJhM0NKR2swSHpMOHRQUTRVejFsRkpNSHhNemVGcWRXdFFW?=
 =?utf-8?B?UTVwTW5sYnRpcWptNkNSaTR5ZHdSN3p5YlBoc3ZjOGQ3SmRyMERVcDJUZVNk?=
 =?utf-8?B?eVNqNnZXU0QrTmZhMk93a05LMnArZGs2cjJ1MU02K08rSWhlZnVKN2JkOC9X?=
 =?utf-8?B?RUJ6aEtvcitlUUF0NkNuczg4ck9MWWxFdjNuR3dubndNM1JYcmdPK2ZhdTBo?=
 =?utf-8?B?UGdHSytjM1JMaDRtUmt3M2hEME5YU3dlUGl1RFpETDRnMFdPbk1wcjMzU2wr?=
 =?utf-8?B?VjhTNDBZTW9hMjN1a2x4dFcxSFQ1VDJ6V28yUmJpMGRNRkV4cVFCSHVYcU0r?=
 =?utf-8?B?NDBwdWpqc0NWUGwwK1hqSDVzU3RFdFI1RFRVRisvQk1iVHpKeldaQkREUzhs?=
 =?utf-8?B?eUhXRU1LaEE5ZDRzWklaeG4wcGQwVExSNWRYaDg3NDRHZHo4NnorRDF1N0tI?=
 =?utf-8?B?elFOS0xnb3ZUcXYzYXljU01sQUF2ZmFRaXVaZkFMcVV2MHRmMithamozeGtw?=
 =?utf-8?B?UkVTeXd3RnZPcGtCVmNDa01OOWlFNHIyTlVxVDNJL2FoZDladTB6VmlpODVO?=
 =?utf-8?B?YUhxODFseHc3TGJaVElSaHZKdUg2Y1hHN2FpcWxmczkzZGdpZGdqeU5KQk4z?=
 =?utf-8?B?cHp6MWRBbnRTSzJOdDRXbnhCQ3lTUEtPeWF0Z0VjNmtXTG1ONTBGd0JJVnk1?=
 =?utf-8?B?QTE3dEFvUDlUbDZ2dDh0cmxxby9GalB4M2lQSDU3KzlDa3g0K0piN1I1NmVZ?=
 =?utf-8?B?WlRlczhoVXYxZUNUUmkrM0Y0UTRFcWpjeXpMUmYrdk8zbHJJSkFHdGxDVi90?=
 =?utf-8?B?ZUdSSHdoblg1dDBSZDVpQ2hPOVhFbTVBTHlUUzhKSHM4ZGhCcWdCN0RZTTFD?=
 =?utf-8?B?YXNxZTBuTEFoWk5XdlZOZXlKOURZcmc3TjZVclVKZStwOXBhUXJsMGYzdkds?=
 =?utf-8?B?RVN4d1FQOEloaHI1UVUxUnZESWthY1VGamRuaUhoaEdTUHBENHRXK0VIbWpN?=
 =?utf-8?B?NFd5TEVqM1N6VTJRbDBYWXF4NERZZFM0MkRneTZYVkF2L2VUY0VZN2JsR05w?=
 =?utf-8?B?SGNYMlRDTWY5WWVDc2lKMG5UOER6MkUxdDJtbFE4MEZTbDhRM2wxS3BrcGpy?=
 =?utf-8?B?SWNXWXVnbWtsa1cvL3hhd1FKNXlyMEszR21lbnRHNThJcU5PamFxWnE0QWtJ?=
 =?utf-8?Q?p/pBwNEx85f2csNWGFau637i6?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Md6vCKR/tAtZcFG862lP43jFZ7pIOp6BDoTCtqt4URsed6vnA8L56omPOpVy+3vjnhQ/HsxWRt3UiQ0Vp1/hwgWio3TJaole2kQd4OVqu4h6laZxkdNS4TO1nfupqln5EpDRtVJ+QT647o3I1Apjk8IrFVNjd9YxkmgvXcxLDYQa7bGPJEUowwj+mywKfrwgMcnWl0h9uiWjB4FYcFqfJl/pEWhrM0G3wrod1waB4K6R8doZQ0vVQU57Lrx3DkIjAO40wxbpQrNWR2QDdgfwmFJiqIDlWZwJqcYgTiWgWY9sw5eALy9VRGHdYuKuOMJqObnPM5RFHgEKagW8rnDyloCtEvL7TXFuIlOjItH0hwbIsdk3SNT+CRYU7jzh1kRim6bNUZEBuLvQxnMR03Z3jPJGQXwV1Riv/O0hM78/ucmI7GxD08iIDR54O9cZLbs7UMcTav+k5FwgEjcMlMVHk7I/Nb4dZ5V9C7jduE8od+XRmezl94A9xLBlR236VHEeeiq5tcEh596d3gOHt8V5W2HKtmtgasmLbJU9fvT73/4NMmL0n3I6ENBs4x1FzckV+CVfCTEjQqnUzn9gsVd8UBWwvQ9/qQ93N/ceT6BaIvw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4baf2873-bd70-407a-a75a-08dd4f5e33d4
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 14:20:17.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdwL+TZwQMeY90vsWbrAIEBShMq7ssTHPU6CWUQ7iPl8QPxMk/+isIP25eSEt7K/CdiXln2a4yPUr/hnBhUW7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-17_06,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502170122
X-Proofpoint-ORIG-GUID: zmM-OdinIaLR0Ch7v41eHY-zN0_Dk4CT
X-Proofpoint-GUID: zmM-OdinIaLR0Ch7v41eHY-zN0_Dk4CT

On 2/17/25 7:31 AM, Yunsheng Lin wrote:
> As mentioned in [1], it seems odd to check NULL elements in
> the middle of page bulk allocating,

I think I requested that check to be added to the bulk page allocator.

When sending an RPC reply, NFSD might release pages in the middle of
the rq_pages array, marking each of those array entries with a NULL
pointer. We want to ensure that the array is refilled completely in this
case.


> and it seems caller can
> do a better job of bulk allocating pages into a whole array
> sequentially without checking NULL elements first before
> doing the page bulk allocation.
> 
> Remove the above checking also enable the caller to not
> zero the array before calling the page bulk allocating API,
> which has about 1~2 ns performance improvement for the test
> case of time_bench_page_pool03_slow() for page_pool in a
> x86 vm system, this reduces some performance impact of
> fixing the DMA API misuse problem in [2], performance
> improves from 87.886 ns to 86.429 ns.
> 
> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
> CC: Jesper Dangaard Brouer <hawk@kernel.org>
> CC: Luiz Capitulino <luizcap@redhat.com>
> CC: Mel Gorman <mgorman@techsingularity.net>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  drivers/vfio/pci/virtio/migrate.c |  2 --
>  fs/btrfs/extent_io.c              |  8 +++++---
>  fs/erofs/zutil.c                  | 12 ++++++------
>  fs/xfs/xfs_buf.c                  |  9 +++++----
>  mm/page_alloc.c                   | 32 +++++--------------------------
>  net/core/page_pool.c              |  3 ---
>  net/sunrpc/svc_xprt.c             |  9 +++++----
>  7 files changed, 26 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af9..9f003a237dec 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -91,8 +91,6 @@ static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
>  		if (ret)
>  			goto err_append;
>  		buf->allocated_length += filled * PAGE_SIZE;
> -		/* clean input for another bulk allocation */
> -		memset(page_list, 0, filled * sizeof(*page_list));
>  		to_fill = min_t(unsigned int, to_alloc,
>  				PAGE_SIZE / sizeof(*page_list));
>  	} while (to_alloc > 0);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index b2fae67f8fa3..d0466d795cca 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -626,10 +626,12 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
>  	unsigned int allocated;
>  
>  	for (allocated = 0; allocated < nr_pages;) {
> -		unsigned int last = allocated;
> +		unsigned int new_allocated;
>  
> -		allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
> -		if (unlikely(allocated == last)) {
> +		new_allocated = alloc_pages_bulk(gfp, nr_pages - allocated,
> +						 page_array + allocated);
> +		allocated += new_allocated;
> +		if (unlikely(!new_allocated)) {
>  			/* No progress, fail and do cleanup. */
>  			for (int i = 0; i < allocated; i++) {
>  				__free_page(page_array[i]);
> diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
> index 55ff2ab5128e..1c50b5e27371 100644
> --- a/fs/erofs/zutil.c
> +++ b/fs/erofs/zutil.c
> @@ -85,13 +85,13 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
>  
>  		for (j = 0; j < gbuf->nrpages; ++j)
>  			tmp_pages[j] = gbuf->pages[j];
> -		do {
> -			last = j;
> -			j = alloc_pages_bulk(GFP_KERNEL, nrpages,
> -					     tmp_pages);
> -			if (last == j)
> +
> +		for (last = j; last < nrpages; last += j) {
> +			j = alloc_pages_bulk(GFP_KERNEL, nrpages - last,
> +					     tmp_pages + last);
> +			if (!j)
>  				goto out;
> -		} while (j != nrpages);
> +		}
>  
>  		ptr = vmap(tmp_pages, nrpages, VM_MAP, PAGE_KERNEL);
>  		if (!ptr)
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 15bb790359f8..9e1ce0ab9c35 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -377,16 +377,17 @@ xfs_buf_alloc_pages(
>  	 * least one extra page.
>  	 */
>  	for (;;) {
> -		long	last = filled;
> +		long	alloc;
>  
> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
> -					  bp->b_pages);
> +		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - refill,
> +					 bp->b_pages + refill);
> +		refill += alloc;
>  		if (filled == bp->b_page_count) {
>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>  			break;
>  		}
>  
> -		if (filled != last)
> +		if (alloc)
>  			continue;
>  
>  		if (flags & XBF_READ_AHEAD) {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 579789600a3c..e0309532b6c4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4541,9 +4541,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>   * This is a batched version of the page allocator that attempts to
>   * allocate nr_pages quickly. Pages are added to the page_array.
>   *
> - * Note that only NULL elements are populated with pages and nr_pages
> - * is the maximum number of pages that will be stored in the array.
> - *
>   * Returns the number of pages in the array.
>   */
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> @@ -4559,29 +4556,18 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	struct alloc_context ac;
>  	gfp_t alloc_gfp;
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	int nr_populated = 0, nr_account = 0;
> -
> -	/*
> -	 * Skip populated array elements to determine if any pages need
> -	 * to be allocated before disabling IRQs.
> -	 */
> -	while (nr_populated < nr_pages && page_array[nr_populated])
> -		nr_populated++;
> +	int nr_populated = 0;
>  
>  	/* No pages requested? */
>  	if (unlikely(nr_pages <= 0))
>  		goto out;
>  
> -	/* Already populated array? */
> -	if (unlikely(nr_pages - nr_populated == 0))
> -		goto out;
> -
>  	/* Bulk allocator does not support memcg accounting. */
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT))
>  		goto failed;
>  
>  	/* Use the single page allocator for one page. */
> -	if (nr_pages - nr_populated == 1)
> +	if (nr_pages == 1)
>  		goto failed;
>  
>  #ifdef CONFIG_PAGE_OWNER
> @@ -4653,24 +4639,16 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	/* Attempt the batch allocation */
>  	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
>  	while (nr_populated < nr_pages) {
> -
> -		/* Skip existing pages */
> -		if (page_array[nr_populated]) {
> -			nr_populated++;
> -			continue;
> -		}
> -
>  		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
>  								pcp, pcp_list);
>  		if (unlikely(!page)) {
>  			/* Try and allocate at least one page */
> -			if (!nr_account) {
> +			if (!nr_populated) {
>  				pcp_spin_unlock(pcp);
>  				goto failed_irq;
>  			}
>  			break;
>  		}
> -		nr_account++;
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		set_page_refcounted(page);
> @@ -4680,8 +4658,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	pcp_spin_unlock(pcp);
>  	pcp_trylock_finish(UP_flags);
>  
> -	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
> -	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
> +	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_populated);
> +	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_populated);
>  
>  out:
>  	return nr_populated;
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f5e908c9e7ad..ae9e8c78e4bb 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -536,9 +536,6 @@ static noinline netmem_ref __page_pool_alloc_pages_slow(struct page_pool *pool,
>  	if (unlikely(pool->alloc.count > 0))
>  		return pool->alloc.cache[--pool->alloc.count];
>  
> -	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk */
> -	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> -
>  	nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
>  					 (struct page **)pool->alloc.cache);
>  	if (unlikely(!nr_pages))
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index ae25405d8bd2..6321a4d2f2be 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -663,9 +663,10 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>  		pages = RPCSVC_MAXPAGES;
>  	}
>  
> -	for (filled = 0; filled < pages; filled = ret) {
> -		ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
> -		if (ret > filled)
> +	for (filled = 0; filled < pages; filled += ret) {
> +		ret = alloc_pages_bulk(GFP_KERNEL, pages - filled,
> +				       rqstp->rq_pages + filled);
> +		if (ret)
>  			/* Made progress, don't sleep yet */
>  			continue;
>  
> @@ -674,7 +675,7 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>  			set_current_state(TASK_RUNNING);
>  			return false;
>  		}
> -		trace_svc_alloc_arg_err(pages, ret);
> +		trace_svc_alloc_arg_err(pages, filled);
>  		memalloc_retry_wait(GFP_KERNEL);
>  	}
>  	rqstp->rq_page_end = &rqstp->rq_pages[pages];


-- 
Chuck Lever

