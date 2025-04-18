Return-Path: <kvm+bounces-43676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D166A93C89
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 20:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DCCF3BB0A0
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 18:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6BAE2222D2;
	Fri, 18 Apr 2025 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DMUVmIj8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UXTV3e74"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D351A433C4;
	Fri, 18 Apr 2025 18:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744999515; cv=fail; b=gRgJOi8G2v0gmf7Ziyf+ABHxaQxxRn6tGdEfouALshzV+ur5ZEdJMWim9/Qq4bUGkbO8MsJAD+6BaqD8MYEOt3xulqrmOyXpUPsXpaZqDoS/eCm7WI9yVAC3RRL8ilJ/gESOxM7Rho8uQoGyQ+4loyGNUVMzJv963T7CE5fVOQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744999515; c=relaxed/simple;
	bh=6RM6htqKLqpuhdWskx5FmtUOiFDvAg2dpVY/vi9Gh/c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eQDpxHgifWiS3WHDDEEzdmwGHR2DM/pzethvBUA1g1wvWBfb9VGF+BXKHeowqzl5s/4Dp0Eizs+7BImNkcj3oEluHEKu0MA5MQUnglxIdjWtEbgkYaBfpaaa78Eg/nQYa5GtGF6VPx+aa5dHGwJvA7ZI1Cj85+rQrQ9KmL1mgyM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DMUVmIj8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UXTV3e74; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53IHBgQU010067;
	Fri, 18 Apr 2025 18:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=xesOFUg0i5y/xFlaP0p0rD5YNiboKPJ7g9DEqvkeTiM=; b=
	DMUVmIj8hfYBLeUQIMybzNX4IcaItui3TOlBxUYApf+xLh1Q+qvgZuSnL4uWcyq2
	R8jGrfXPgp2zWFULosQ89KPr7N7INPZC6YvjrDUEJK04Sl3gEEBkm9DGosJkGWmP
	r8fvM3EWQUSkltDlIQHHfjWioZ9JNhIdIGNqzKfI/5O3eddHows9ODUJrbk+5/2j
	AqhC9vm6kZuMdkkM3kN0snASbJ/l9KInBy4f1KU+dJSkHfKa85mh5eiTeZIqV9DF
	+Ctu2qQ+cIWGqzubElYz3yAykjBWCqLNlYL9EQer/ftTj61WeiQLl1VXSGPfdZ6s
	+avhCzZ+95DUlgaaaZmvew==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4617jugqru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Apr 2025 18:03:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53IGBUpm038823;
	Fri, 18 Apr 2025 18:03:27 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013078.outbound.protection.outlook.com [40.93.6.78])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 460d4w66a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Apr 2025 18:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ip9ti8JeoO8nQWTBxnz6EV9NwqpyVXy3kDzE+NK7cyjRZ0801K6E2Cs8yrCoMpqVdBVfsu8kgMfQJHgMftxLAUE+KxEaUL//bFueuxJT8UN3lN6R3nNH/5u56zxlJw6QcsR3lr1fONcxmqoMxzH53cUEESIp4SEEtRHwDOtmoo1+EZ7kLaFuo5xYLcwM11cdRnJ5JQXDarwWEXjs9+9Zddf+ojsyeCYz+fjwgOq8g43djJN3LA1UDZKlLRpguLT3zdSJiduwILhEH2jgAWw2tXP9Qxb1SFYMXlSWZ2J8V04RhM2n1oqWMJ7DFMzdx67kieRiRC1DLhVTiuQf0w2Epg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xesOFUg0i5y/xFlaP0p0rD5YNiboKPJ7g9DEqvkeTiM=;
 b=i3bxYYp8HyWALi2kpbeC+HY5tIDgBmv5FiiuoKpUh1PyvH7bwyIYMvUuipyYk1a+OQfJ8wM6vXWDeEEHN3jX2CfvfNUatTrIohi3aKM0u2jmNT1vTLcrWID2mHNnh8xESYBsQVr4I5TWMrqrJeK78xx0koNyD/i3GvjXM0X4o8nWqBAv1pXGhs8R14Y5I8vWvQWi8oQjaxGX4lofiN8c5bU1+OHEXFy4XUbClxsLx7FnjDQCk2KhX/8Y9C3s/0ZEMX1M6Ut77Jnjb5jNeGeLxI3uy/whdR4+cwpjFEWJWPrqn7r/k+4Uaz118ofMCnS2CHFYp7ixRko9nlUqp+5EYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xesOFUg0i5y/xFlaP0p0rD5YNiboKPJ7g9DEqvkeTiM=;
 b=UXTV3e74B8jZyMqZI9AWroCOL59hUyFf5z1Bdia0vKPxaA8TgCon2f207aK+m6KOSLfcn8e3RVajKl+tG2dFeJGywoi+B6f6ugocn+wDgXoca4fubbkF+XX8dpjA3hkWi+lkY9C6tQ3QTLneU+nI+opuBa5pwn7XJ+oiX4WEZ/0=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.45; Fri, 18 Apr
 2025 18:03:22 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 18:03:22 +0000
Message-ID: <65b0070e-3386-4725-8e8a-15b0409b8368@oracle.com>
Date: Fri, 18 Apr 2025 23:33:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 20/24] blk-mq: add scatterlist-less DMA mapping helpers
To: Leon Romanovsky <leon@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
Cc: Jake Edge <jake@lwn.net>, Jonathan Corbet <corbet@lwn.net>,
        Jason Gunthorpe <jgg@ziepe.ca>, Zhu Yanjun <zyjzyj2000@gmail.com>,
        Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dan Williams
 <dan.j.williams@intel.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
References: <cover.1744825142.git.leon@kernel.org>
 <87b151a3791d71e58ec6f1b42bcf5fe06304cf80.1744825142.git.leon@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <87b151a3791d71e58ec6f1b42bcf5fe06304cf80.1744825142.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|PH0PR10MB4662:EE_
X-MS-Office365-Filtering-Correlation-Id: ff9bab3d-e9ea-4191-165b-08dd7ea34ed6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UDR2YVQ4SlRKT2Zqb1J6SkR1VFc5VW5wd25oRU1BR3RLTk96SG1JcldDVVg5?=
 =?utf-8?B?c1kxT2pTT3hhVjhXMVFSM2tKaElobXRsRHlJNFh5MGJZY0xrUXEvakxYdUQw?=
 =?utf-8?B?djdnc1A4dE50aTZuMHZEMEQrQ0VDVmZuL0xNTm8rTHM3Q2NSalk1UlV6Y3Rx?=
 =?utf-8?B?V1dtaE1Da2UybGRuYzVKSnJ4c1ozOVJRUmNrbjFaTWFyME1TYThRV3M2azFz?=
 =?utf-8?B?S2ZHQ2dtSzZhU2xUWjNKMmZtbmdia1RVN0s1MmpVYWdiSWR2anFJVncrMk1X?=
 =?utf-8?B?dUJqNExHRkhUVnYrSytXL2wrRzNNVys1dDJRcnVpVWZyMSsvQ0JPYXAzSVQ3?=
 =?utf-8?B?eTk3RkNNeXBkQkdCbnZKVUN6ZlY2bXdUcDhqdUVZdDNqU0JXVEJOMEZNam9I?=
 =?utf-8?B?ZDljbGMyb0FOTGh1NjU0ZnlONktFSG1FZUxlVWdDVXVmaW5Pck42UUZndFBN?=
 =?utf-8?B?M1U2UEkrNDA3djd0ako1eElwZ0RnR2Nhd0t5T2hEUE12ODVYNFlJRFNSV3l6?=
 =?utf-8?B?OUpudTB1Z3VMRk1xTkcwT09mVVRqbnNxZ3VrZUc1anRSUTU4b2x2Y0ZmeEJQ?=
 =?utf-8?B?SUJrYklQTWZuMCtKbWtyT2dvR1NmaUMvc3NwRTNKZG02QU9HVDU0d2c3Q0lp?=
 =?utf-8?B?Qm9XZVlNRmhXc280bnRFeFlWZjlhL0NaazR5WG9SRUM4YWR5OFlzbkdsQUJx?=
 =?utf-8?B?VFVwMHZtNXNmcUNtMzl1ZEVONU1qOGt6eHRyUjNFK01mVUEzNGxjbFZ5N210?=
 =?utf-8?B?TTU0UmtMM3p6MFo5UWNNSXpsTk5lYS9tRnBsVEcyUTlNdmh6eWRRUEhad2VO?=
 =?utf-8?B?YUszUHRwai8xRFN0QnBxQ0dOdFZvMjNGdUpIeUhPKzltOE93VzBrajZhVHVR?=
 =?utf-8?B?ampqM0FSQTB4UFNCeGs2UnRnSTdmTzQ2bXRzMFRWTE5ibXVRaVkvcXRHTThG?=
 =?utf-8?B?WFRBUUIzRnRmeWFHRmg4WWR6K01wQ0hMYXpPZXluZXVudk5LMTQ2VDN6VjUv?=
 =?utf-8?B?THBZWXkxNVVWV0FOSXgvV1FnVjBwdXdUMXJQd0JkVHJzK2Q4OGM5ajJuV2Y1?=
 =?utf-8?B?eUp6UVFCOEl6aWpPNW9RZFJ1czl5aFFTK1J4Z0FKSTNMMkI2MytlbURITHlL?=
 =?utf-8?B?RkNvNnRxVDNsM1VsMXZLN1ZxNXpQZFBoZmFJYjBrSkNSMldNc3lUY21tTTFJ?=
 =?utf-8?B?WktHN01Cb1BHTHNPWnBqRmZ3WXBXZFBqZGlsNUhNWVRSc2JZS29nWkZWT0hL?=
 =?utf-8?B?RGJ1Z2IyWUtCSXlxdERvUEk5b25nSmZWMklYOHFwT0hJVVQ2akdEZ0R2Umpr?=
 =?utf-8?B?UnRHa3FZTjlUMVBBMHprUnNMazdBUGpsZmFOeTQwN0JDNVJ4MXcycTM0QXZU?=
 =?utf-8?B?SjJPTVdIalRMbzNiNDNPNkpZOVllMDJTUUZxck1CVkV2NUdpZE1SalRUQjAr?=
 =?utf-8?B?c0dWZ1piaW50b3plcE9lMFVLN3FsT2EzWVpiTTh3RlBvRWVldWthOWN0RmNK?=
 =?utf-8?B?WHZhMUgvYXFRRm8ranlUSmkrYXZBaGVXZlo5T2w4a0tSOVZlQ1hmTXNBV1lQ?=
 =?utf-8?B?ek5icnl2czNsQ1VYenZLdENlYlhPWWgwOVhOcXQ3dTRZbXQ1T0VReXFjZG9Y?=
 =?utf-8?B?YXJIZXRnSWN0OCsrYkMyUGgwVFJnemxOSU1nZm14Zk1sSjZCNVpoRkpmRW15?=
 =?utf-8?B?ZUwyRWEvU1luTExLWkdSVjh4YzR2WisyZlcrdFZ2QVRoMDBQQVNBMGRzbEpM?=
 =?utf-8?B?UEdTbzE5eWdXQjNDNXhXS1VLdkI5aUV1aWN1TEtSbFlJcEdUK2xGWjdtMlhX?=
 =?utf-8?B?Njg0MTB1YXlEdDRQVm9NTXBWYlA3MHRlMXFTZWVBZ0E0eVNDcEpFVmp2Y1ZM?=
 =?utf-8?B?MStmQ21SSmxQbHRGUGk2bzBreGxhVHd0UkZabGVmZENENEZCZjBWNlNseklZ?=
 =?utf-8?Q?giCkTJO6MsU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUFhMWtlWU45aDNSUGdpNGh0bzFsdXdXRUlUQ1NhLytLOWhEU3hDTVNKNVdn?=
 =?utf-8?B?L2ZlcDNOZ3N6VlFOU3Y1ZmtjSll4RzhtT0syMlV1TW8vS2s2aW5hTFRVcWRK?=
 =?utf-8?B?eUU5dFJTV091azdkOHBNQzY2N3N3cHdDUzJDTXNRS1Q1VVFFeTA2bk82VTNw?=
 =?utf-8?B?Q2J6VXBTUXo2RmxqbFhWRDVMSFloeDllckc2VVNtbHkwWTFEVkVrZHYvU3Nt?=
 =?utf-8?B?cG9DZmVJT09GRlE5b3E1K3RWYlVTUUZlM1hSRnl4K3pjTFdTbUhJcWZNdEJl?=
 =?utf-8?B?V05adEhOZGMyVkNTRkhGV29oYXdBaC9wSmh4d1ZscGJaUUVmK0dWeWphVkVw?=
 =?utf-8?B?Y25GK1pzS0dGN09VMnlBYkR3MjRsSnRMa2FZUmNTQWRtRDg5WGJUdmJXVDRR?=
 =?utf-8?B?NURaVFRpMmQybzNDeXB5MEpqVDdic1VXZ0ZwOHM1d1R3U1JqeEtMT2txMUY2?=
 =?utf-8?B?T2duSnFLQjhxbnpWem9JdWFRYWRGNTMraUxMVjNPdElMcFJib3g4Mk14WEpL?=
 =?utf-8?B?UlAxamt1MjhaNWZCaTNBc0FRZXVPb0VhekhPeEQ5RXd4ZjRUVHkyZk4vSmVM?=
 =?utf-8?B?OXVZT3VkRkM2ZncvcWhoeEo3TTNESFVhM3Nuamx6ZEhlTHl0V0dmZjV2bE1w?=
 =?utf-8?B?WjZscGFFeEV1RExrS2MrNnFFbXlRcWQ3UmFISDg5dGlSWjNHaUZXdlRDckVU?=
 =?utf-8?B?aWFiWWU4NnprczQwc0gvQk1aZ1U0QWR3WjRVZStMMWVyVk8wZHZaVjZWYWk0?=
 =?utf-8?B?WlhhVkJ0bk43SU01c2IrbXBBalJjb1FORDFDQVZWRHNPRDRqdjcvZ0xQbGlE?=
 =?utf-8?B?OHllNTJCbjd4ajBJR2p0SHBUQTJKYUxXTFZNRTNXVk5BTjdUN253d3dHSTBE?=
 =?utf-8?B?Y3RZMWttMG5kaHB2aEoxQnh6dXF1Y1dNT2dJOHpQQU5YbkdjSm9LZXBEZm94?=
 =?utf-8?B?T3BKZkg5RVdPbmkwa3oxN3R3V1F6RmJqeWpLa0d0NkF2TEl1MHZtRGkxdmg2?=
 =?utf-8?B?bXpRbFIyWlpIQWp6dFMvZlJ1ZG1wNGhLVWhQTE1FUFBMank3K0pocG0rcUJF?=
 =?utf-8?B?Z3dVNWpsMitYckFqSzBLZ1NGRW8rdzBobnBmcHFWbmN3b1dmUXpONERUTm5y?=
 =?utf-8?B?UmNpY1V3cWxYQlJHR2Q4QkIyV2NSOFBTUHJrcGM5bjNxK1NhMHN3RVQvOWVk?=
 =?utf-8?B?bW15clZydzRUZmxUYldpQ3lzRkg2R2lrT1ROVjd2VTE4Smhva3NxeHVxOUpp?=
 =?utf-8?B?M0RVWTZDSG1ZdlQvOU9PdmhGVzMxZnhneFR3ODVMaHlBYUpKRm45TnVPQURO?=
 =?utf-8?B?YXZwUFJZWmhCQ3VFUDFuMzVpUm41MVlKRkw5SnBiQ2g5YUVFcWtIMUZUVncv?=
 =?utf-8?B?NE5GaUxKL2VrcVlmY0JNd2VvYmwxMGt4aXJTK2FIMkFwZkxvN0h6RTB0Mnd3?=
 =?utf-8?B?NEx3RUxzZ051Qnp4ZTh5UjBweTQ0SXFJOSt6NDFKS3hyWCs3WkZyK3prbjlQ?=
 =?utf-8?B?enZrTk1RVVYwOHJnYWkyS2xNVXJtVHJrTkwvYUxLRzlucjUzenM3MHZkTmRm?=
 =?utf-8?B?UkVLMUI5Z0ZtcXlFVUpvSnZISDBjQ3VSOS9OUkE2VDBFaStwWlNGKzVzcWxD?=
 =?utf-8?B?b3o4Q25JZ1A2Sk8wbm41RkhsQUhJNXkzRE9BVGdrTUdVWHdRYldzRzJKcEpR?=
 =?utf-8?B?eFl4Wlpvczd0cWhKR1JlVG1MT1g0d2lzekFmelVuYzRmalZBV3hxRnNTMStV?=
 =?utf-8?B?VzRNTmEvOXJxSWJWNzluVGR0WkJaZ0RBZU94cU5LRTF2OFp0c1EyRHg2NVlN?=
 =?utf-8?B?c3N0NEFKblpkTEpUODNUWFNPYktORmFwRjJGZXRLQlJ2ZmNwSXV4TlZTVGRQ?=
 =?utf-8?B?b0R1V3JDenVWNWk1eHlNUXFFZXMwMzUzQkhidEFSdlFLZlpTYzA3bHZDY2lP?=
 =?utf-8?B?YjJpZlEzaVdTVzNjSFpXQnlyc1N3SGd1QjlUZVZGUmxScy9ZTUppWTF5QXlU?=
 =?utf-8?B?V21aSWJGbC9sU1dIQmhIUlIyU0dEUVNHL1kxeWVOS3FhU2dLeUkrZ1BwcWtK?=
 =?utf-8?B?UklnU0duaUpiSTg2azZ0aHpOZXVNdlNwV1RFaHl0Z1NMdTUzZE45WDdvdWg3?=
 =?utf-8?B?WWhGTndhMUhyblZMSGRZbWRaN1NxclU2bUdFN2lWZnpsQ2t4SlJKYm1XU0h0?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qyN5IQizv++LrOGPNbRJz/OcUDDaUFSB4EWgo8fFBpQeHeiy5jXFRlzVqNxaG43031C7V0fsbdjR3V12SdKmT18EFHdbs0nr8YGpeGw47Q3xBnVQRPUV19j1e2xFHeNhuzI1QPfAfmt8uHMOxCpcloe1807DzL3X3NEbn2XFwUb7JElX0XnGF/BOLYYCaGCxT53XkZLD0HKW2/5ofmF9GdLLN+bfoAgumRbiqcPLyb1OiTJexQwQhIbHtmYhjm7BwKonOQXP3AsVicM8hQwdv2YI3Vss54M70qRYf4xy3w4Nxo6TzCnvJabTew14S0klNv+yPFZJn/KeyRlry37FG1sSE5dsYLyJhN9gQqs0IDGgiqTDG8Zi1eW46Rn3ejhuglpX6Fs//LIuyf++1fuUUOkI/jn9PRyd8ygJTu1GREuNa+KOf+OSKZ0S4sqY7eS2mO4DXRVavg4P/g7JVRMbVgciW5eSEZpfxg+X+1OdA36KqjIBl1kNyaVVpQnEcWM2QSRThEHr6BcQoD6T8UNXB4VU6Apud/swJtwLXNIwS83PMlr70HpdXJj2ZDknHWBeqUtCjhVZ+TWudxeAIE1zWv/X819RdfMOpLfjO8ZKexs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff9bab3d-e9ea-4191-165b-08dd7ea34ed6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 18:03:22.7318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nsC1bamzw06dm67ZcVuP84wPTwOzdyYnbKFOuuQHNYYD9qomcbrnDyyhuBHJFpncyHmce8oO/5YvaDQ+pVRLUI0zyN0PZyrJeOvohn6p+HM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-18_06,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504180136
X-Proofpoint-GUID: T-KUc3d4T_z3zO7cE37Cd6OPxQrsdQgM
X-Proofpoint-ORIG-GUID: T-KUc3d4T_z3zO7cE37Cd6OPxQrsdQgM



> + * Start DMA mapping @req to @dma_dev.  @state and @iter are provided by the
> + * caller and don't need to be initialized.  @state needs to be stored for use
> + * at unmap time, @iter is only needed at map time.
> + *
> + * Returns %false if there is no segment to map, including due to an error, or
> + * %true it it did map a segment.

typo - it it -> if it

> + *
> + * If a segment was mapped, the DMA address for it is returned in @iter.addr and
> + * the length in @iter.len.  If no segment was mapped the status code is
> + * returned in @iter.status.
> + *
> + * The caller can call blk_rq_dma_map_coalesce() to check if further segments
> + * need to be mapped after this, or go straight to blk_rq_dma_map_iter_next()
> + * to try to map the following segments.
> + */
> +bool blk_rq_dma_map_iter_start(struct request *req, struct device *dma_dev,
> +		struct dma_iova_state *state, struct blk_dma_iter *iter)
> +{
> +	unsigned int total_len = blk_rq_payload_bytes(req);
> +	struct phys_vec vec;
> +
> +	iter->iter.bio = req->bio;
> +	iter->iter.iter = req->bio->bi_iter;
> +	memset(&iter->p2pdma, 0, sizeof(iter->p2pdma));
> +	iter->status = BLK_STS_OK;
> +
> +	/*
> +	 * Grab the first segment ASAP because we'll need it to check for P2P
> +	 * transfers.
> +	 */
> +	if (!blk_map_iter_next(req, &iter->iter, &vec))
> +		return false;
> +
> +	if (IS_ENABLED(CONFIG_PCI_P2PDMA) && (req->cmd_flags & REQ_P2PDMA)) {
> +		switch (pci_p2pdma_state(&iter->p2pdma, dma_dev,
> +				blk_phys_to_page(vec.paddr))) {
> +		case PCI_P2PDMA_MAP_BUS_ADDR:
> +			return blk_dma_map_bus(req, dma_dev, iter, &vec);
> +		case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
> +			/*
> +			 * P2P transfers through the host bridge are treated the
> +			 * same as non-P2P transfers below and during unmap.
> +			 */
> +			req->cmd_flags &= ~REQ_P2PDMA;
> +			break;
> +		default:
> +			iter->status = BLK_STS_INVAL;
> +			return false;
> +		}
> +	}
> +
> +	if (blk_can_dma_map_iova(req, dma_dev) &&
> +	    dma_iova_try_alloc(dma_dev, state, vec.paddr, total_len))
> +		return blk_rq_dma_map_iova(req, dma_dev, state, iter, &vec);
> +	return blk_dma_map_direct(req, dma_dev, iter, &vec);
> +}
> +EXPORT_SYMBOL_GPL(blk_rq_dma_map_iter_start);
> +
> +/**
> + * blk_rq_dma_map_iter_next - map the next DMA segment for a request
> + * @req:	request to map
> + * @dma_dev:	device to map to
> + * @state:	DMA IOVA state
> + * @iter:	block layer DMA iterator
> + *
> + * Iterate to the next mapping after a previous call to
> + * blk_rq_dma_map_iter_start().  See there for a detailed description of the
> + * arguments.
> + *
> + * Returns %false if there is no segment to map, including due to an error, or
> + * %true it it did map a segment.

typo - it it -> if it

> + *
> + * If a segment was mapped, the DMA address for it is returned in @iter.addr and
> + * the length in @iter.len.  If no segment was mapped the status code is
> + * returned in @iter.status.
> + */
> +bool blk_rq_dma_map_iter_next(struct request *req, struct device *dma_dev,
> +		struct dma_iova_state *state, struct blk_dma_iter *iter)
> +{
> +	struct phys_vec vec;
> +
> +	if (!blk_map_iter_next(req, &iter->iter, &vec))
> +		return false;
> +
> +	if (iter->p2pdma.map == PCI_P2PDMA_MAP_BUS_ADDR)
> +		return blk_dma_map_bus(req, dma_dev, iter, &vec);
> +	return blk_dma_map_direct(req, dma_dev, iter, &vec);
> +}
> +EXPORT_SYMBOL_GPL(blk_rq_dma_map_iter_next);
> +
>   static inline struct scatterlist *blk_next_sg(struct scatterlist **sg,
>   		struct scatterlist *sglist)
>   {
> diff --git a/include/linux/blk-mq-dma.h b/include/linux/blk-mq-dma.h
> new file mode 100644
> index 000000000000..588dc3c1ad1f
> --- /dev/null
> +++ b/include/linux/blk-mq-dma.h
> @@ -0,0 +1,62 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef BLK_MQ_DMA_H
> +#define BLK_MQ_DMA_H
> +
> +#include <linux/blk-mq.h>
> +#include <linux/pci-p2pdma.h>
> +
> +struct blk_dma_iter {
> +	/* Output address range for this iteration */
> +	dma_addr_t			addr;
> +	u32				len;
> +
> +	/* Status code. Only valid when blk_rq_dma_map_iter_* returned false */
> +	blk_status_t			status;
> +
> +	/* Internal to blk_rq_dma_map_iter_* */
> +	struct req_iterator		iter;
> +	struct pci_p2pdma_map_state	p2pdma;
> +};
> +
> +bool blk_rq_dma_map_iter_start(struct request *req, struct device *dma_dev,
> +		struct dma_iova_state *state, struct blk_dma_iter *iter);
> +bool blk_rq_dma_map_iter_next(struct request *req, struct device *dma_dev,
> +		struct dma_iova_state *state, struct blk_dma_iter *iter);
> +
> +/**
> + * blk_rq_dma_map_coalesce - were all segments coalesced?
> + * @state: DMA state to check
> + *
> + * Returns true if blk_rq_dma_map_iter_start coalesced all segments into a
> + * single DMA range.
> + */
> +static inline bool blk_rq_dma_map_coalesce(struct dma_iova_state *state)
> +{
> +	return dma_use_iova(state);
> +}
> +
> +/**
> + * blk_rq_dma_map_coalesce - try to DMA unmap a request
> + * @req:	request to unmap
> + * @dma_dev:	device to unmap from
> + * @state:	DMA IOVA state
> + * @mapped_len: number of bytes to unmap
> + *
> + * Returns %false if the callers needs to manually unmap every DMA segment

typo needs -> need

> + * mapped using @iter or %true if no work is left to be done.
> + */


Thanks,
Alok


