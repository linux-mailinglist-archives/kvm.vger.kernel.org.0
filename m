Return-Path: <kvm+bounces-30055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD2B9B684B
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 16:48:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F06C61F23989
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 15:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFC4213EF0;
	Wed, 30 Oct 2024 15:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y0HQAseI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VZpYsxAQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7E91F4FA0
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730303291; cv=fail; b=nfpTiiUCO7LDWV+MEPhPxoMWre5Naz6ErRtVNzuaPlVL3SlaPL302IeqMxB63He4OE9uS6Dz/epSlE+nL5LkTgqvZm9sc3HfYghzdlpLRtufBus9+lZuOJoMGkTocPWg2pN9/n6Lo8r4/s+IT2koD19H0luDuB+VSdV6s/cwENY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730303291; c=relaxed/simple;
	bh=yvIfh3uO9pOqbslvSCW2Gb92Dp6v/BW4eWUYSnVAPb0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eBXDC4ShwgOYtGuee4oYr3u54D4UNF0wy5V/u8/g+S8mB1vAo52woJ+ylmBl/r3GlX1RdgdeGJcwP9dJTVnOEXVQxt6G4JfNA1VNp7q9cUBVUkcNNm3cr94vnDjR4PMTtHFhc8UL8a77CECs7DhZSErTZU/mYAM272SKAKhUJGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y0HQAseI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VZpYsxAQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UEFADO002730;
	Wed, 30 Oct 2024 15:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=02wxY3j4J4KEpClxtdREvYDKdA4rb0k2oo0n8t7/ogc=; b=
	Y0HQAseInsNADmkqoJAM0n7gXoGVwYK80qd+FwczCQLCLF4VHe/wH7vMn/earWNt
	wLjWfqgNdR8rrfXtKjoINCfpzkTvEjOixymMLIQZylYvpjYEZOTT1aCe+yKZ0cSX
	M4vrTC0KIXh7PtUuabDyDRp5YKynz6O8B6YSUwS04TLCOfP9MJNN65j4pJD6QqiD
	hFjgG2j7QvhruLpNLRX2qR4/xf4w/Wo0O1ldtpa+2DRnYyMcRKDxo7pEr1oM6xNp
	h7WTJY7RuwA3GRHl/O9DhlT+Dm+wZqLQU4aReuEAa/2NyJ/agZIUlcoxVc1iPy3B
	RBLHtKmTNLyMLpzinM1Pgg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grdxrbfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 15:47:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49UEh7WZ004796;
	Wed, 30 Oct 2024 15:47:26 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42jb2vvp4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 15:47:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L8rigYlVf+xscU7ZEkGQA8GzVlS7n5hi1gqw0u70pEt5DtzCv3Vjup5wUwNpa9UxmBxgJuEMW0wwtw3hVpqxsXUXeq6p0psUxgDUnV4sfZt1o6olVeboNOsKNtcZGW3wnYsd+NP3DOyatcLLbkjosMoka3ZL1aCb1Fdv1dNfnZAfUV0eCXIGQdxP11cqsy0WpBUklrFsJBJgnZnTltDrBIEMtWgJ+LL2gD/k5IXxbgxXL8DLbDVT3NFLARmTMl66AsYc5fX+2G20plqT5DqEa3iDNr2YobuJfwwKO+AOqKqBNiFhIf4IuH6ABesFVKO6JvAXPER4kaVWT4T5FJO3MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02wxY3j4J4KEpClxtdREvYDKdA4rb0k2oo0n8t7/ogc=;
 b=nPZEoWtFdUc0tGOB5R3oXJ8Nl50tvknmeDG+QitEAxtGwG1R94ULIQdWF4WIV/4vdqyhLHYk/Wv8Fu69zKKzt1ZxnUf6A0Qqr8/Cu91/YZGbgcxm/K75FJ8LsCzr0N6Y8smt6J2smXb/3keXS8DfLqIFca35Pj4DUA9Txqw12oOtn10uOeGr5Rt0MPH46UCzUOe84F8R6xPc+ZUcfett4Wo4+CtzNOE5OFuKj3IODpetoqUXHy1KtMIkg1POUYoVYw1+5LfUX/EtboS5f48wJTYrlrMfaZbXCdjaEkpmkE04ITIpgRMIesdTT6kXkNqCvArdrxTG15jZUOmBzyt93w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02wxY3j4J4KEpClxtdREvYDKdA4rb0k2oo0n8t7/ogc=;
 b=VZpYsxAQfNNniuA7rFasli8GgmY5avqaalxmxupPZgatrrImkGLq4OyQHZF+vR9cd0kwAcT7e/+2z0TTIzmPe78ALRq0K3x6oGXjOiX/KJ6iM778s3TjIWX/3pinYvYQuA+3hDGX9C5+ccsbc9+hZZq/y7T9Dezb0R9E5Frq5hw=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by LV3PR10MB8108.namprd10.prod.outlook.com (2603:10b6:408:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Wed, 30 Oct
 2024 15:47:23 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%5]) with mapi id 15.20.8114.015; Wed, 30 Oct 2024
 15:47:20 +0000
Message-ID: <9a2394ca-fd8d-471b-8131-55f241e9cf26@oracle.com>
Date: Wed, 30 Oct 2024 15:47:14 +0000
Subject: Re: [PATCH v6 00/18] IOMMUFD Dirty Tracking
To: Jason Gunthorpe <jgg@nvidia.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Yi Y Sun <yi.y.sun@intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Shameer Kolothum <shamiali2008@gmail.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
References: <20231024135109.73787-1-joao.m.martins@oracle.com>
 <CABQgh9HRq8oXgm04XhY2ajvGrg-jJO_KirXvfZxRsn9WiZi7Dg@mail.gmail.com>
 <20241030153619.GG6956@nvidia.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20241030153619.GG6956@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0260.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::11) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|LV3PR10MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: 3efa5d25-ec54-4eb9-f948-08dcf8fa23c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L0xuZkdSRGxlZEpYbmJjL1Uxa3h0M1RJTWFta0xBRGhVQ01hMS9OVXFUdi9k?=
 =?utf-8?B?c0ZpbEFKRzRRQWloNFVrejh2TjhkaEtqWmI1ZFlrOTYvdDcxNmEvbG5Ga1ln?=
 =?utf-8?B?SW5zZlBWenNwcHJBc1kvbVptelhuSXdDN1VDT0tQWlA5b2ozUVZDdU9DTEdv?=
 =?utf-8?B?aDdDNDRzeFlRS0VJbzg5UUJndEtpYTNXY2tpU01kRVU5L245Uld5Wm0vZnZC?=
 =?utf-8?B?Uk42bHZoL0RONFpkdGJQc3BkNFplNzJNaGN1ZGJxRU56b3lEY2R1bG9CT1U5?=
 =?utf-8?B?RmRSZFBwc3NBNkhHWHZzM1hENkFTbUFETXRSUVphNTRkbDJKUTRzdWZkdEp1?=
 =?utf-8?B?ZVd4TWFOdUw1Y05Ua3FXc29BZCt4a1E5VDRyRGhkaXJZSlRUUnp6Wnh6S0VP?=
 =?utf-8?B?M2hxSlhManV0ZEpSc0xUeFc2NzBqZ0xnWTlrK1gvSlBKYWc1eGErbGpLaW9x?=
 =?utf-8?B?cCtUdmEvSXJuaHdKbEVVa1oxNGhTNlcrNzI0ZXYvc1VtWDd6QjR2MlpPYXAz?=
 =?utf-8?B?Qm4xMDA3bEpweVdtOFpqY3dzOHlYT3VsOG5ERnFqOWZpWGZYM05XZ2c1OVE3?=
 =?utf-8?B?bnpUbnlpWEtvZk85OUdhS1ZyNHo3Y2hkeEc5c0lmTitteUNsdHd0RU5mZHJ2?=
 =?utf-8?B?YlJDOHZST2JJeWxkS2c4UHhPSVhlK056cFNVK3ZBbER4VFhvZmhnTzlWUm1I?=
 =?utf-8?B?SWMwOENzeWwzRUpLRXhPQ0pjbE02dmtKMVNzZGRzK3RKcWRvdlNOOTlzMnNY?=
 =?utf-8?B?ZGNqeFlXU09mUnhVL1I1cnZHNEhpM0R2V040UmY3d0p1S0ljMkk5VVZmMldF?=
 =?utf-8?B?WHcrbHl2aVJLNFUzZ2lEOTVuU1QyTEpaZXFqc0VlSnNNR3ZOV1FwN2ZRUmZy?=
 =?utf-8?B?YSsvalRHOHZsL05JSGdVK2hJZmpGL3UwU1JuQlpuR2k2cldPRE1FVVdacVl6?=
 =?utf-8?B?QmJHOGhmazcycHI5NzI5NDlIbUo3VEgxaTQ2N2tyWTJYUFRuaHdTMVdSeVNF?=
 =?utf-8?B?c1hPR2MvREFaRzRpSmFvWGZpSUsyKzdyU2xudUNUcHpnTmVJSnB3RGJiR1Yw?=
 =?utf-8?B?ZXJyMW1kTFdvMmNiUlRqMlRPTjN1M21zL2hHemF4RzF1VDBYRFlENXROdjV5?=
 =?utf-8?B?LytrczkxQ1FCWTdhcS85ZHVXYVFoWlkxUDlya3E0ekxzZ0xWZjVRNi9xK2Mr?=
 =?utf-8?B?UWQ5K1p1SVB6SHBTQjlvVTF2bkZPQUxWTHBiV1ZtV2l2ZkJTcjJJWFhQdmNL?=
 =?utf-8?B?Z0Y2cSs4UDhBNU5YMEM4aSs0VFluSStKVndKOUEzckhrODVpaHo0SzRDbDU1?=
 =?utf-8?B?R2ZIMktIK1ZNNTJ2U09pdlZQdTh3ZjF2TkpQRWdaMGZIaEsvUFRnNU53NVNJ?=
 =?utf-8?B?WnB4UjRLY00zSVNka2JraXE4NUFnamJnMzFMYm9YbXFpSWFiOUF5SzN3em9Y?=
 =?utf-8?B?MnBVSVBETWgvaDdHNGdnQ1psajc4YjdkZ2hUSHNZWWM0NVZkL0lkcGRUenph?=
 =?utf-8?B?VFp6OTZkektDeTkrL1NEeTNjMnY0RUNIbCsrcXhBRExjK3BxRHlScENHTG5Q?=
 =?utf-8?B?V1hXRVloeWliV2FtTDVFWW9iYWRIUVhjcGhucE5NWmdsSUZXYThqRTdFYTI2?=
 =?utf-8?B?TFA3T3RQYXF5NXdSQXMxeTJId0pPRVN0VjNXVjJkb1RTTXhGbDBMM3Zaakow?=
 =?utf-8?B?N3NsaDY3YmsxQnZycVY0UHpEelJCNy9qTVJma2xQVFluMVVjYVg5dnlKcHY1?=
 =?utf-8?Q?V90oLN4TzpXt2wKDSPEAmiGoH9zvNuJKg0iZtKf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVZaTFJlRVZBMTg4ZlU0NThnNXIxZEY5cWUxMzNDRHNKWWZlR3JnZEZLUnRD?=
 =?utf-8?B?cDY4WXI3c0NsTytaLzlYZmx6RFFMbFhFdCtwL0Z5eEo4QnR5azlpczlBWTBG?=
 =?utf-8?B?N0dqczZzRFl1c2hlSktJM2N4ZXY3TEVVSmlKVjU5UHJaVkRhMXp6eFZRM3hG?=
 =?utf-8?B?UG42ajF4cWgyWE5CMW1STEpXRHdTRGN6d1c4VHFlSVMySG9jUFBLcnV3VjY3?=
 =?utf-8?B?MlE3TGNrUHppRk5BMmtxYTlPTnl3TWEycFdnZzRDcWw2WkxzWnR5TE9CcVNO?=
 =?utf-8?B?OWNEMWdsWXdTNmo5R1BVYWhVZndlUUxoSHBjZHhWOUlod0kyczBtU0tiaGo3?=
 =?utf-8?B?WGtrcE05TDZFeUIxRytMWks1RE9LSllYTGQxU1lxQ2ZhbWVSRjQ5RFJmQlEz?=
 =?utf-8?B?Z250U1E2QzBDSWRmZk1Mc3ZmUGhveFBWOVdXb0c0SFB0WS9keUoybVNyYm1u?=
 =?utf-8?B?UlVKN2J2ci9ielNEZW9mNGxFYktrYUhMQW9xMWtZVWpKZmtST0RYNHcyeEZn?=
 =?utf-8?B?WWhtUXl0L2d5NDJZVUVCNlgwNlZHcXR1WUVsanNGTjk4RURJbW5ja01QT0xn?=
 =?utf-8?B?djRFTzJRZGhLanVYZElHbC9FTEJEK1pIbU9wbm9zYTNRamZRb3pOcHNDMjJm?=
 =?utf-8?B?YzdZNVBZQjRrUHg2eGplUTdiUjArSEhkOWR0bGt5a1BYM0ZuWnVLbXhzdWxp?=
 =?utf-8?B?SS81c0hLZXFuR0o5WFc3UFNlclNPWWU3U1d0c0pqQzZFbmlFdVpkU2lHWTV4?=
 =?utf-8?B?djNwNndmTnJqRFo4Wkc1KzFEcFU2S1MvcVc2c3VKYW9ncU9RZyszcTNtdHh1?=
 =?utf-8?B?eFBzL25GalBTaEFMNVpJZGg0SDNDZkhYVldDMS9wUmhNZUlieGJzSUtWSkVW?=
 =?utf-8?B?MGZTbGlkMXNTVUVKN3c5SGl5VlhtUlQ4SGRJWnc1ZDVDR0Vyb0RvZ0pDT3dQ?=
 =?utf-8?B?NGFnUHFmYzlpTS9ieGt5SFp2Y3UzSEZXVjdWOWhVTjJDTk9GYWdRZjZPNmN1?=
 =?utf-8?B?cE9QUXIxM3NTU0hIM0tQR3h2UGxIK1Uxbkx3b0VXQW5YMU00WnBZbDBmZ09j?=
 =?utf-8?B?SXAyelBzMWdEYnhzbU1PK0IxZWJmSW02b1p6a3UxN0ZQVWZ6VTVPeFdFZkVK?=
 =?utf-8?B?dEF3OUt4dVJ5VDd2SjR6aUc2Q2hDc2FNc2dQUEQ5cjJ0YWxpVzBNNHdJYlFr?=
 =?utf-8?B?cTBaejlTbmJIN2c0a3hxZFVtNVdYUHJqc2k1aE5pQm5hQ29qQitLbEJjeGJ2?=
 =?utf-8?B?Y00rZ0JSSS9RK21yY1Byd3ZTazhLL0RPai8xYkZ1MU81cGxVZlI2TEFFa3Bq?=
 =?utf-8?B?UVN6bktXUzFGaU85QlF4MXN0Y0RYeG42aUdvdG5xd09KVGZ1WkQveGFSWDZz?=
 =?utf-8?B?cm9PeWFDOEUyK2c1c0hDcGhJWU9EcFplZlZSVm9HY0xhb1lOTC9OREtrYzBQ?=
 =?utf-8?B?QWFWM1phMGZ1ZmhOS3BzZC9LVVMxZ1NRTUxid0dFY1ZjLzRWZ1BQemVVdk1u?=
 =?utf-8?B?cThndk4xSk83ZElVVGQ4VWJ1TXRuR2RhOHZmaUcxYnBPZkFLZ3JCRm9PS2Fx?=
 =?utf-8?B?YlNUUDFqaW1OK2pXZDRUTFBkeG0yQ2NWV1h4cllISVBYTkIxOUtnUkNFVWRn?=
 =?utf-8?B?S1IwTG9KVUdwNWMvUEhtZmNYNy85eHRDc2dLa29TU0RWbnovVWZuZGlFZnA1?=
 =?utf-8?B?UUlScUZNVjVXTCtsSm4zK3NWNmlJU2FEWk9zR3BXL0FuOWg2a2M4ZFgyOG51?=
 =?utf-8?B?Sm1GNkFwa1REM1FtUmU1c1FjRTIzQmpqMUFFaGFSM0YySFpaK2FTQ2g0MUQz?=
 =?utf-8?B?YVFQemV5R2lYcEVoSG5sbUtsWDlZZDlnc05aNCtrWFozajVmdTB6UTA5a3Ju?=
 =?utf-8?B?Z2lpOEdwWndjMDNNOWNLS1dUVE1YZFRaK3NXOThpY0RseitZdzJjSnM5Uyti?=
 =?utf-8?B?SkxFVGt4aStHV09RNFVncWt2VDI1QzloWUhFVHgvSmpONnpiZ1FMbDFlSnUr?=
 =?utf-8?B?TWc3UWhMRDVmOTZ2b01pYXZiSnNObWNFbDJjZXhSWmYxSjFpQmlLN0lnM01S?=
 =?utf-8?B?NFhnUlphK1RBSFB1VUZnMXVkVlBJMHB4ODZSUzZpN3ZXNFZHVjVaR3lobGZh?=
 =?utf-8?B?a2dpS0tYM2VxYjliTnU0bHJiN2EzQ1pWdlJWL0Rqc01iSExiekZZek05YzZE?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DxwCfEVLmKrhD7EkH2Pqq/RDcdB/yHOd6wxY1Vf19kAwKbq1a31eCOX3WGZG73ek99QtSTdb5p7UMaf5MmB3SUGw/wlD6zYXtRXyOCGdT4lT2e9e5W4FmvHZWnb37B545Z/J2vjR5RtpQPJ3pPCxC1fV6MFJxoK0PK2QnhT+WgDptgmEuaFIyjtIzDvDAuJnElfflx9dUdx5eaxV4l4QEls/YzTI4FhrP7mr0vvnTeePszAULinT1F4yy0pCnWLLlwKDh+GEZKPHhmwcEr2+VOOtRZTqVTDnJcZUodGR+7Ayp5ko8EC/j8+NhV+2ae07kNJkC6yCDysCoDYjHSTWNn6H1YEPpOnVCBKVBZiPCpaLo/1+6aU0VFfplRK0Sy3eOpDFushZEdSBDt6m+cY+uSz2arMWY1DHVBFWdouPUT8zK/fGpOt4u7GnNSnI3HZvNym6FHxD/dx+rpBgUaosRUJsxiUS3ujjJ+zgnjO5pnGPH4jSSDgwahLkmWx+OZkoLv8HvMO9kzHPyHANTazXhrEVp3QRy+ca+4N1K7/oN/sJmpMELPJbKd+1JMdOBIccQr4Ec0sMN8uXv24ghPLK/oXvwTawEUarrF2+7Du5Y90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efa5d25-ec54-4eb9-f948-08dcf8fa23c6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 15:47:20.8061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wFDhVniLPzToGElEy06rU+07RlFFBjcnl9Kv424Tfi1mStDVE2YtkFIKumN5waQ79asF3n5fYU9wqrNd9D6KNPsZxjACFOYvQ7j3fhxaN3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-30_14,2024-10-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300124
X-Proofpoint-GUID: l2HqlKJwXI2f7jWNIqa8u2pS-c3jiBL2
X-Proofpoint-ORIG-GUID: l2HqlKJwXI2f7jWNIqa8u2pS-c3jiBL2

On 30/10/2024 15:36, Jason Gunthorpe wrote:
> On Wed, Oct 30, 2024 at 11:15:02PM +0800, Zhangfei Gao wrote:
>> hw/vfio/migration.c
>>     if (vfio_viommu_preset(vbasedev)) {
>>         error_setg(&err, "%s: Migration is currently not supported "
>>                    "with vIOMMU enabled", vbasedev->name);
>>         goto add_blocker;
>>     }
> 
> The viommu driver itself does not support live migration, it would
> need to preserve all the guest configuration and bring it all back. It
> doesn't know how to do that yet.

It's more of vfio code, not quite related to actually hw vIOMMU.

There's some vfio migration + vIOMMU support patches I have to follow up (v5)
but unexpected set backs unrelated to work delay some of my plans for qemu 9.2.
I expect to resume in few weeks. I can point you to a branch while I don't
submit (provided soft-freeze is coming)

	Joao

