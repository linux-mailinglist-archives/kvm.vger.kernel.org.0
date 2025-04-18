Return-Path: <kvm+bounces-43677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5445A93CC4
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 20:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49EA91B638E9
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 18:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD5F22423F;
	Fri, 18 Apr 2025 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R7BIUxu5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R751f31s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F691A5B9C;
	Fri, 18 Apr 2025 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745001028; cv=fail; b=MqScKHwzpgZP4ekp3fpJz2j5g5pWPSSTyzBjBjiOgE7o5GFFfM0jLr8Qpea0jGWOtjXyOz3HkEqvLDdEA+9s0lezhTRw/Sn7aXKFn6Qwc3jptCO3tZtqMaV6sBrGXrtbKKJnorSe0+AvdU/TExdqc0HWWFzANVd3vu3h7jrkL54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745001028; c=relaxed/simple;
	bh=zhKkurJ8bRbJUUPrk2xw+3+SEsEltTAkuK11+zGva10=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YlpPVVth2eRXBPNkkUhlZVFP82kTyhzvgLP3zyB4Wjw+yzGTUsIyB5zq9XVz4S+rCJjqo6+51l4iN6EEVdrLldmv8KDEym/mDjiXmmPFuCWwEHomLx0kPZZjzFqeBFzdN2Tgi5nGNw2GyrVa1nK57TIPJNnfHY0lljWuB95YSEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R7BIUxu5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R751f31s; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53IHBhKE030953;
	Fri, 18 Apr 2025 18:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qrLRdyW615uyYDbW0AeHS4zaeYEFvG8G83JY0s1KzNE=; b=
	R7BIUxu5uCgBs5K0QYbsQ7Ifi6nB2ZQhkZuK38x82lNxFUZlEARHqiKk6IsVVVX2
	9dSj6rAhzFwkSC+V8DU6c2SpCxt7+4H8MGiuY06EM20+vGUPLuMOfIvx4T+fl+4G
	PunBTCOOmVwGr3hbsqMSFHHpCLpbVjocruhz30JWrx1Z4IyAmkaOfFqeBipPKLJg
	QjUxl0g0MRZwB326wD67+OBR2Btwz1y9pD91RZGPJfVyRAd6khXPeO4eEaiT8WJB
	WLpLn/XtnRkQzb3jSSaxcA7fqloDYQ2PAGwR+0Dk4Y/lzGBfpIQpIV2ixU3Fh/hO
	Jiwi06VOiLPtsbG/Di7tAw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46187y0q2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Apr 2025 18:29:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53IIA6jA038888;
	Fri, 18 Apr 2025 18:29:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2042.outbound.protection.outlook.com [104.47.58.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 460d4w6vgm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Apr 2025 18:29:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eOXAs0SZ8z+WDz5HW0YosOdYuX2BMrbI3CFnh+YuKJBmUqz1wQ7lBzV82eXE3vcA2U1nZSsRdVsYOSDC1tGQg3RIbQv6BTy2bRAS2IuattQukEVd6Ss8ixBKsAiQCmf+q1tjjMxfK0CuPW2YGlMNobdDQ8Ex2ZcPkrccKDVLGKz5Z4cwci0OVo+a/vVyJWXUGm8770Jx7DdtBcX2E9AungTMmYIZ1ymQKwRwlj/oiYoqn92CcbOKhj+8JXqbVKdnpexZtrAk0Qy6oKhgdDHcIdAODVY5SW7LGfihRqaGKvQFZB0zXFIfgQZZqc3wMjgkDCDkcjauPuXz3rBpe+hmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrLRdyW615uyYDbW0AeHS4zaeYEFvG8G83JY0s1KzNE=;
 b=oP3BAiaIr1tbfWvLoSxCD3FHOC0AqoGQJhGbchFvXyaWlaGxfOTFqbPauhJlDmFnXmi1pPTGbkv18iSejzerRyTaWEpjpMhZtzlEI3TuSU4QvcKxdUE68RC66zSdBsTHezNYlJn2bopk6ua+qfIjviWb6vbce1RAlUfLJTMGLq6jpF9SG2Q2CvnqKq6CdnzGwS7JIVkDtquChVSqyOoIudUWsv3AYgPzmkuY78WmT/vNh+f7A+IXkfi9UAGQV4Gk0feBLV5BgHF1oLRImrh7Zfv3NeZyVd/5PuHO44LB5XBY2c8ljfiblhhMA0WEzjN+7wSjkcQEN9FrIa5PSZZZ7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qrLRdyW615uyYDbW0AeHS4zaeYEFvG8G83JY0s1KzNE=;
 b=R751f31so9zmY0bqzRdIcp9Eb21W/dX8+Sr5IvtAmin6WusIn+DK+CyKIqZW2zK0T1ka094B81xUvNsE1C9AqerSU9Nt6FK6v2cMAGK+eZjDtgpHurSWhO/AE/FZoNpRcNnWA1W68buF6+Coe9R3Igt87FwvBXrD+FM7ipb8uVs=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.31; Fri, 18 Apr
 2025 18:29:24 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8655.022; Fri, 18 Apr 2025
 18:29:24 +0000
Message-ID: <6bdbb334-5849-4099-9284-ffe293aac144@oracle.com>
Date: Fri, 18 Apr 2025 23:59:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 23/24] nvme-pci: convert to blk_rq_dma_map
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
 <f06a04098cb14e1051bddec8a7bdebe1c384d983.1744825142.git.leon@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <f06a04098cb14e1051bddec8a7bdebe1c384d983.1744825142.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU0P306CA0034.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:29::10) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|BLAPR10MB4835:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de48a61-ec5b-4d56-44c3-08dd7ea6f165
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2pidmZrVERPS2luTTUyODlRREVYNDk0a29hUk1jd3JDa0JBRnZWajJDc3gw?=
 =?utf-8?B?ZzFwN3pvM0RhSVR1enAya1UrZFl2TC9xTk1JM2hQRTZvaHRYdm8zWkw0SXJU?=
 =?utf-8?B?cDJTd3huS0UzZ0V1a1hlWk90d296UHJlcWxSM2taVWp1c0Z1RjJFNENzVXlO?=
 =?utf-8?B?aFpxcEZOSTY0RXVPYU1IMWZ5K1BFeHJjN3BaTlF1WHFXb2xsRTJjT05nRk43?=
 =?utf-8?B?ZUxUZDluSG1XRnhnSVJ2a0hNR1hXcms3WXJOWHhDK0Y2L1B0Q0k1M2RZeUJC?=
 =?utf-8?B?bkdqclhmbzhEcEY5T1VuSUkyMnF0VnRTV25jcDZkdE93T3VnSEVHcGlvbkZ0?=
 =?utf-8?B?VXVUaUt0QkN6bTEvSGU3ZGZBSlI5am5JTWc2MXBCVmIrdU1YYzVIZEMvcG9Z?=
 =?utf-8?B?SlZyVGxIWUJ1SHhkNnFBUlEvVkZiTjZZbXoyUlo4ZmozOHhQTUVqWDZTTTVR?=
 =?utf-8?B?TEIydE4vZXE1eWExNDVhaklHaGkvN1g5NDlYVUt3OFJVdkU1N0dDS0xPRXBt?=
 =?utf-8?B?cUxNZ0trTFdhVWZidzJmaTh4cytmZDNqWDg2dGh4RjU0M0pZbzhaa0lJbTFX?=
 =?utf-8?B?NnRqaXgvbHdGcE0xQlNuTFQrczlFeGtHNVB2dWJKcm01b2pOV3BkSm1MT0N5?=
 =?utf-8?B?Ly9rSU5zK2M3eGpPT0xvdjNmNjBGQ1lDUWtPZ1hha1NXUU40Um1vbzJSNVhR?=
 =?utf-8?B?bG0zRmFIQWtOcG5EWlVWZG91QjU0RHNGTEx3ckJxTkN5L2xRQTIrNGZ3US8r?=
 =?utf-8?B?cGNOZnR6NU5EK2pWZy9WOGc1Mml0aTc1T1ZHTkxOOWZWRVNNNUVtRWgxbHNa?=
 =?utf-8?B?VncxLytpZlZCUDg2T2l5Si84aUxHUjJ0dk01VjdxU3N3TldRMnhJVytjdEl2?=
 =?utf-8?B?U3I4OGhCZzJlZUdhbzRpVDRXaE5BTHgrUVdoMVdITG5hMTZCVkZjV1V0Tzlm?=
 =?utf-8?B?WCtmMTUzU3FneXNkYWhYZnArRTRjaEVuVko0V2w0L08xQm1tUCttVSt5ZEN0?=
 =?utf-8?B?ZStEVFhQTGpLUWdKQVBlMVJKVkFVblI1aFE0TGFIbG53czV3YVRBMGluMkYw?=
 =?utf-8?B?eU9sQ1VyNW13em5IdEZwbFZZTEpnVmtOdTRqdDQyKzFnRnNKTkFZY3kxckpm?=
 =?utf-8?B?c3lSaEpiVzZNNEpYa2g4UEpVU2pKNlExTmtEdDRtV0E4UU5IUXFSMWYrWC9n?=
 =?utf-8?B?SzJseEVodlhJNWE1dUdvK25RcEZzQk1lTGJhK21Eb3o2OGhZbGttT3JORHlt?=
 =?utf-8?B?V0dNa0lKQmFKdkNnU1FUeTBrVzZ2R0FSMlNDRHlDUlIwNUpmZ2kvYUF0ejBZ?=
 =?utf-8?B?UWVzbHdCQW1uUVQ1dmJMMlpwUzUvMHFIb2I4QXYrdE94akt0SmNkUThlbG9q?=
 =?utf-8?B?Vjh1RExhc21oZ21pYmJkUG5wRkxnVkJaWDdMZGZNSUhpUFNncXpySWwvc1BU?=
 =?utf-8?B?TWRJZ1RqazNER1Y1YlhNUENFNklmSDZVdmVuVkJabitnSmFGdGc1Z1grS3I1?=
 =?utf-8?B?cTN0VzBHWXRGTWJrQUNRMzJUS3lORGNKSDFHaGlIMXNGbWpKWVA2R2NTQjBI?=
 =?utf-8?B?dlhBUmg1T3hSTVRvQzE5YTdPc05BSlEvQ0FqK3FkWXhnQ05OczNTdDEvUTYx?=
 =?utf-8?B?OVlPeHc2TlViZ01VQmpzTk13bTQ5dVgyckE2UVpITXVEYWEzNmNCQytIZVh4?=
 =?utf-8?B?TDZDbzNZdGxHekxveERzdm00Q3RuQ3VhS0U0dmRSNWRwdmMybjdOU0V2alB1?=
 =?utf-8?B?eFM2UEppU3Y0a0gxRXBOR3ZJVXJQRTZpWHRQdHZza3UrYnhNMm1zWEEyUWFE?=
 =?utf-8?B?K1VGN0pCMjBnbkRzNFVPRUlIaXVBb1BOdnBDcitIUERTWjNQcExOeEo3VUlJ?=
 =?utf-8?B?Z2xka3VNdjJTRSs0cWd2a0cwaG9kcWNVamVFSU52Q3RtS1BFRmdSWHR3SU9T?=
 =?utf-8?Q?bLm7As/MzYI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkEvY2tOM2huK1dmRTJGanY1a0xNZWdVRTExWmxObC9Ob3NTcytEenJodklt?=
 =?utf-8?B?bmNWRm9xRGRBOStLNlZPdElIQUlLYUs1UUMvSy9xUU8wamsrUUZ0bm1pb2s3?=
 =?utf-8?B?VW5xVENkRFJtUnB1ancvbllyRFgraUNRVU1SZ3pFQ01iY3lhbm5CNFdhbUJq?=
 =?utf-8?B?cGw5NHdtQzlPcCswQnVYNFd6Y0VTbTNiVDZFSXpRWjZWWkZMVTMyejhaRkJV?=
 =?utf-8?B?KzJUNTdLTmtRVU9yNTJGNm5Ub3hlSUVOWXFqemQrdjJ3eVdXSlZxK0cxcDUv?=
 =?utf-8?B?VGdZNjE3RnBaZ1ZCZ3BnWUlrZHZwRjZ0Zk5TUlBtRlAyaDljdWRJZUlQSzhw?=
 =?utf-8?B?OXVOcVNwaklOVFdyU2dmQVZCRlZjc2R4NTdPVkd5Q0VUSlJ6dEhpQzFOVDJj?=
 =?utf-8?B?TWlzZzVxeXo5dU14eU1pTnZJOVRUWEFXRjJyWnRIWlZnL0kzRFdSN0JOVjN2?=
 =?utf-8?B?VUEzRGx1TXBtdHk1QXNSQW1MRmpyMUE1cXNHWEQzZkpvQ0EzUkpRQW1idU9v?=
 =?utf-8?B?c0xJeGdqRDFEUlU4ejA3YW9HR2IwYWw1TkJyQlZKK2M2MDJyVUttK0RkVlBG?=
 =?utf-8?B?bXZiVW16aGR3T1g5U3JRTDJZaS9YSit5NlJiTmVQcjVFbnRTQ3lnUlZ1cnlw?=
 =?utf-8?B?QzBJVkJTeHhhd3FwUHhPT1FGYVd6RmNCQ1dyTGo1Kzg1NEhoWVJGbnduY0dt?=
 =?utf-8?B?U1ZYVnhTaTBhWUhubnM3ZUJoL0MrNi8rY1hGb2x2WTUvSTc5eVQ3MFJ2eW9U?=
 =?utf-8?B?bS9jeVdLMFp0VldvV25uL2s4TVVYLzlBeENCTURDc2VHeXE3SEw3a1B6Wnhk?=
 =?utf-8?B?b0RqZEhFUUtRWng0eFU0K0FQWDQyZXRjYjhDRkhCNGEyekl6QjdReit3UThi?=
 =?utf-8?B?MXFNSGMwc1J6cUxBV3BMZlFrS1pMT2c1M21zSFc2Y3VSLzlHVU45SXowc3ZN?=
 =?utf-8?B?S2QzbHQ4Ry9JMGgvL3BMZjFMUEVOMDRXZzNMUnpjclFaVzJiSkRRQmNucHN1?=
 =?utf-8?B?dllFajdLajJxODRPQ2tjUUwwUWZVWGQ2WG9pOFdJdnFNNlozMDdUa2RjTU1X?=
 =?utf-8?B?cDZKbDNqSW1abis0eG93enlKamErZlViMFJwT0NvTEF6cU9FU0phMlpvTFMx?=
 =?utf-8?B?TDlLa3Nydzd1TjhhZThJWmh0WjJPdUhFK2grOE43SGJvU0d0Szg1bFViNWk3?=
 =?utf-8?B?VTZ1aU44elFrWDdLRnpwQVpvMzc0SFUyVXlOanlMQUxTSE5CMVY3cVJ0Wm9O?=
 =?utf-8?B?Y2ppc2ZMczU5UHhhcVNsZ0xhZTc2MWFmRGs3akh5cDFhT011SktZNmlWMlVr?=
 =?utf-8?B?cmNzYk0wQUpWSUFsaS9hVjEzbEo2VVdremJ6dUtEdWY5aXZiN2tnK2ZLZXhK?=
 =?utf-8?B?STlyU3BIV2Y3MGMzTXpGU1Q3MnZ5MmV3d3ZMVE9BbEJLOEFzZGhZV3lBa2pZ?=
 =?utf-8?B?VzJpNExTeUd4bVFMdm5WbWM4TEhTdUZWcGRUU1AvTTlHUzJ0NGlNS3l6WU5q?=
 =?utf-8?B?aGY2RXcyazV6M2QrVTVHaGxDb3E3cFZnWkVOMDFjbXZvbHl6T2dhTStYV2E3?=
 =?utf-8?B?cHlxMU9mcmdxRWUrQUpuTWVWbEFmRXBOQS9RdzNDZElZZVJ1T0NKVS9rYWRt?=
 =?utf-8?B?aFdGaitmVWtUay8wNFZ0ZVVTUjc5TXZBUGF1bFBRNlJLTjBmTVQyclUwNmlF?=
 =?utf-8?B?S0QwR2dNdzBWRElGRFlpcWlHbXF6Y1BrWlBCS1JPczI5STBOZWVXUWpIS1dl?=
 =?utf-8?B?dTRlc3lvTFZJUVNFR29YaWNXczgzYzgrU0YyMlJEdXBxTXRzeW5nZG8xb3lI?=
 =?utf-8?B?SVMyWHVyd0x1RG9UYm9SaDNadU5GcFZ4TWVrSEVFeW5scW1HS0llUTZ2ZDFi?=
 =?utf-8?B?SVphWjd3V1ZiK3JZN0xhZ2FrY3VoUldkd0x2dnRRYjhMbGg1aW8zTmpDTE1C?=
 =?utf-8?B?dG1Jamo5eGdqNXdxVDRtMDBnYnpuR0ZzT0xQR2xYMU5FeDQ2WFhvRzMwSURO?=
 =?utf-8?B?NHpPbGhTaDk0ZmxEWVRXdU1lZ2hocTAvSFN2dnI2bjd0SkMrQ01FWDJiOVl4?=
 =?utf-8?B?SHdXRVdNdE04WlBaMXJBRXJsYXdDVmliQnhDRVF1THp6TUsxaWNCTVVkenpC?=
 =?utf-8?B?ZVJNRnBCeHNORFJhL09UdTQ1R1A3ZGZQZFhsSW5JdXdzc0hCTDdKOXpDYlpV?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ar5OvEyPtj8uOyViQu9JxFydvxKsl0V6HyAIrCeRT4b+zV1tXrp66q9nRpIde7IyBORt4073lViOZ0jQtt8Cuv4OCdLPAmSRamr2G/g7Ts+I5Z18klc8wxs02LvAg16FkumI5wPqjdTLxTYoXL8tY5jRrsd+S1aZCrsyeAKMYm/VRK0alV/gcCRQAfCX6AL6nh1K8ynsdrGdgxhtU1GzfIE4YpTprnGS+Yw0QtWHmrjt2ReT5hr6rCN+8/5MdUcSfBMnkibQ+6XG2jdUXzrlEB1df6lb131Lt/MovxRoZQGG3cDyHp2xVp4YJuxAUR7mqDwuvyZfoieW7Kj+Menz6qwNiSW7ASjhbf+IxrsDvK7LI+oWq4UFnUpxiN8NM0FnoxZLy2eKSDhf2rOtKl8UNsw4XgFY5atLwi2jfx7sTmtHAp3l4PiPvy8YKVRPYvq21Fe+GjWqSWy5+d4GcWccNLDHw69FTq8Iz3hTmKVLUoFQ38eLxTKTR0uTNH37ZZvT/N5hT0KgBHXnZCz4aookfAouWFOM3I+yqE4JDGjQDHzx3+iwULige9sUnpxSHrzZEltXfZQuf/AD8GnY7fYgj8DaOnETt6kU9Oh9EZbY3UA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de48a61-ec5b-4d56-44c3-08dd7ea6f165
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 18:29:24.0251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMKaRf+Oi3+0WVWsJaPp9ZxxZPZ0k+kmSFuPJ4wtTWxtv9ctPo9/9u3g2iCjvxHzggL/wneRsIyvyaEyc7tUSrf0d4Blql8UNU56sYNABfU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4835
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-18_07,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504180139
X-Proofpoint-GUID: lrY6Twb4YRL1TqIzmeU-GQVNKOG57ilC
X-Proofpoint-ORIG-GUID: lrY6Twb4YRL1TqIzmeU-GQVNKOG57ilC



On 18-04-2025 12:17, Leon Romanovsky wrote:
> +	prp_list = iod->descriptors[desc];
> +	do {
> +		/*
> +		 * We are in this mode as IOVA path wasn't taken and DMA length
> +		 * is morethan two sectors. In such case, mapping was perfoormed
> +		 * per-NVME_CTRL_PAGE_SIZE, so unmap accordingly.
> +		 */

typo perfoormed -> performed , morethan  -> more than

> +		dma_unmap_page(dev->dev, dma_addr, dma_len, dir);
> +		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
> +			prp_list = iod->descriptors[++desc];
> +			i = 0;
> +		}


Thanks,
Alok

