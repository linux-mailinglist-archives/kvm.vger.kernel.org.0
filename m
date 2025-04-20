Return-Path: <kvm+bounces-43705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CDDA94987
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 22:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0301817011D
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 20:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AD41D6DBF;
	Sun, 20 Apr 2025 20:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="l27Jk68c";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PLwHG7mJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2EF647;
	Sun, 20 Apr 2025 20:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745179813; cv=fail; b=V8Y+6gMMXL4bMRX986oL9tpFRzzCEfsk5bIsEiej/0GIg5HTbw3+3/ju0qvc9bPyknCvpLU0Fj7t9FdKxgJ7CHe4CniehxduQB+Q+VV6x1EwgjgZ3GwCcNK9CAnYrMncUXS8ZwaMDHY5mAhV56LNtD0Nd5WbgK2vYL9zBOTBUDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745179813; c=relaxed/simple;
	bh=6RxQZcq3aDtaOgYP10lhsjs9j/GPp0PzxSyOaIArbSk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G9rK/9767R9YGwYRDIhsFckfmeWnl9lrW0oy/r93hbJbdC5zXMuDkwzse2THlLLuQ0zbp/QCzKwzq1Zn0BRdDsZTD2Wxbnie8XFIFdA0soyCO/vtwH4fojd6kgp7kuPsqsPN0Sld4BTkjlqPS2Pe0VDW+3vCD5rfNbfoOIULK/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=l27Jk68c; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PLwHG7mJ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53KJw604016555;
	Sun, 20 Apr 2025 20:09:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=j9SIsDHCqhNKtv/aEKBM/ZUF8urEi/kc6V171FNMA6s=; b=
	l27Jk68ccwmOrO7NLu9BWqo2MwIKiWGW8EeUHEyo8lrczMeqjE+c7Ig9DN7fPidy
	gMLzqDKXVu2wpXzJI+f6WGIAMlGsvz22BB5m4yfqJtPOwC50MB/IFhTznzcRrjhQ
	aPuJQ39tNhUms02WiOMo2MxQG1wCu+mJDye/E9R2poF3Xt2A/ewoZTcBIRdCxtXT
	34T5hFO9ZJaZlsuBpQQ5tYhMxxGvks55I9sT9b1nViLFNOc9Ze4PZkV7/UtvyMy8
	+ArCNmnAAHRZlRxAVUTIiLNt8rbCZlh3lOjuNyjhs2kpZIAs+aGlhqALeRJkudFN
	edX0AUGIv18oNKZA7j064A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643es9hrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 20:09:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53KJp3wE005766;
	Sun, 20 Apr 2025 20:09:20 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013062.outbound.protection.outlook.com [40.93.20.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 464297kfnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 20:09:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vD4CLzxjJjM+aC5c/+2mXRDh9K9ec68kqaKw0eT+Z89suXgmvChwgR2P3KdzH25O/YWphaHRUb0DFaoYUE9KJSuT8zq5mMCDlTAS+3euFRJ7aTdkV3dFx8FzttaxnZ3yQfuklPuyHjZdgpHZMijGebLdlBS8TULxdkDWb5l9KPN4fMXZSaPAlbhHMr23i4e1fKYr7N0caN1dDMJA+xdwkGVgXKUrvXVnNbEtIKecriRzLyf0T+S44BT1pmHnRNh57TgktaB/IJLafYyvsuamEPqyVXFnI6w7XTwWVs0Y18gwcquU+HYRVFeDmDn8qB/7NVxRVNxz9HSW3UCPRaDAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j9SIsDHCqhNKtv/aEKBM/ZUF8urEi/kc6V171FNMA6s=;
 b=ctW5bhJEbsl9lVORCYchnFAUkTubsAsDGtks3HDIpZtAksHnXRLAtmnAQWmVX1IDQbPIY5zJYrtHpYwkNIJXrVtXjrvDubY2D/11VPmvOqiWB/ThCjm+HtQJ0sQtGncMA5pzN+C543QI+/Pj58dKi069eNryzchwePFbuSJ1YgCyf8m8ddn34NavkcpwK7cmEgXErE8DmdZH71Rmyz+/jiEIvVYuZa433HnMBjjebqIXhJvjsYWlFWtlY7bBcGriAs3CTP2Lx6NMrxHa/H5nUCt/X1yux8sjSlhoKEIpWy2F2FI0lCSdo+Oh9GxLxv6lAnmtopu/X4+ZJetnH+vYOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9SIsDHCqhNKtv/aEKBM/ZUF8urEi/kc6V171FNMA6s=;
 b=PLwHG7mJMODHm2ntBBLGxnW9E5HW8l4tErDfJ/KU6dfd+nDdV8Iqxx9+pIb9zP6giHh8k78EOqpclVgyhsrq16pPkNFk3uaVITNd0/1W+Af859jkcIwoXoJwyrg9W46n1CBL0FpEdr8EKX0ICDA7p6CV5HAwKv4YwA9rVEkGNM0=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SN7PR10MB6593.namprd10.prod.outlook.com (2603:10b6:806:2a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Sun, 20 Apr
 2025 20:09:17 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8655.033; Sun, 20 Apr 2025
 20:09:17 +0000
Message-ID: <2f2874a9-b3cd-46de-b81c-d46ed7aa7039@oracle.com>
Date: Mon, 21 Apr 2025 01:39:01 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/24] dma-mapping: move the PCI P2PDMA mapping helpers
 to pci-p2pdma.h
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
 <b27ea9fab66fddac256266f44b9045949f265b47.1744825142.git.leon@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <b27ea9fab66fddac256266f44b9045949f265b47.1744825142.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:820:c::13) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SN7PR10MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 02f83495-de30-435c-744a-08dd80473ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d0FRS1ROelhsa05MYzJiRTNLc2NqRlBZNWlGNlRRWm8vS0Q0alVZVXJ4MHY0?=
 =?utf-8?B?djlyVzR3SW5NS0tqczRMTWZsQmNHb0pxSVJTUXpJbVdjU09ndElGVmcvM1JI?=
 =?utf-8?B?bUR3WWFRTmNDS3JVN3dWNjh5TlBpdXRVV1d0OHQwUVNjcTcyUzMrSThOZ3F4?=
 =?utf-8?B?YzZKdlg2STR5VnVPZFZyNitHdGo5K2VFb29ScE8vNGlsVlIycHF1M2tsMmRV?=
 =?utf-8?B?NGdlVTBFR0JvQUVJdXA2YWVOYXgvekZoaG1aTUpwRk5ETDE3TmRUVEFqSW9o?=
 =?utf-8?B?RFlTTEJhZjV3RUtoKysvQndoVlpqVmN5cWdGMnNoVkMxMWYzT1o2RlBGYkl2?=
 =?utf-8?B?OWxHZktsbmpXN3NiUFUxOG9mRTR3d0ltUDdYbitUekx2TFRtK1o2YUR2TTEw?=
 =?utf-8?B?K0Mram9uUElNbDJIYzlHS2VJOFNRcGpLdTZEbXhiQXZsOHFyOS9jL29xeGFs?=
 =?utf-8?B?V2NaWjRLVytlZTRMc2hnUDNOZkhaNFdNUThHbHMycWpJOE5vVUl3bTJXQjBP?=
 =?utf-8?B?OThHWldBVUs5dXA5SFg4U3RGblRCSTFkdjIxd21VUk1HamJwRy9BZHpSS2dx?=
 =?utf-8?B?LzhOQkQzZG8yV1p0UkNnYTZvZDNjU1BFN01pbjJvNHRwSmpRV1dTTzcxSldD?=
 =?utf-8?B?cGVsNnNDeUJOUnp6WEVIS3dPd2NnSHV2UjZCQkRRWmpJVm50dm53UVBLTVh4?=
 =?utf-8?B?eHZsSituSTIrQ1MxUjNTRThXM1pkamtPSm1RL0pLMUNoYU5NRm5nb1pCRXN5?=
 =?utf-8?B?VFNuSEJLY3p6TXpYdUtrd3Z0dEhOaFZwT1NqQ1ZMdkswS2o5Yy80ZDJha1NI?=
 =?utf-8?B?azFFNzd4WXk1NmFJOHZ1OWdCb1FmU0lIUHNpYUE5WnQ3YmRlVnd4TVBtaGR5?=
 =?utf-8?B?aG0xaW95UVZVeDdrVnM0dVVCeGxFVXQreWtyemRWYm93SlIyZDFQYlBzMDcv?=
 =?utf-8?B?cXVMaitSMFlYQVVBQzcxWXRLY0FjQm5mOTNtM2tpNnlHWHNiWGFRdUhYTUF5?=
 =?utf-8?B?RnIxMEdlcVZ4TnNJUTAySm8vdWRMNk8vNHhMYURsa2x3V3A2N0lVM2MvZ3pQ?=
 =?utf-8?B?Mm9YbjNPeWdEelA2Ym5qN1ZRZjZCRVVSTnYweDFqeWV3R2pmcHI3SWJKRlZl?=
 =?utf-8?B?UUJQNU1ZUVMwYS82b2RBNVZiaVRGZU9va1JpOTV6QzNSNUpkVlVYWlprbVln?=
 =?utf-8?B?Q01WUzN2aERPaVBXa0l3eWg4c3NCeUVRUzVhVXlqazdQS2NVbmNPdkVWSSt2?=
 =?utf-8?B?QlRJOS9FMVRMQ21KSVp4UEZWejRyUFh3NzBha1g3d25xODlUR1B3cU5uUlB1?=
 =?utf-8?B?WTZZS28zTUNQM0JubHZ4Wm83VTQzYjN0QVVGdS9LbUlORzEyTEw3T0dlcERF?=
 =?utf-8?B?ay9hRmx6OFFyUXVtSWQ5VUNqOFdneXVpUXNVcm9vaTVvZmR1WHptamR2VWhh?=
 =?utf-8?B?UWdYRTRDTUpKYUpzR2loUFFybDhKY01aR0o2MXgvRWxoNGhUYVNsckUrcEM5?=
 =?utf-8?B?Y0h6WEFkVnJ6LzJYVUVEVmVPODNqWmw0dDk5bXV3b0ZUZ3VQL29lYkxFYkFp?=
 =?utf-8?B?b3hlYnVhMHJLWndUejFTUVdvMVZHRlFsQnozc3ZVNXplUC8yL2VETVVENkZS?=
 =?utf-8?B?NnpnK3gvcUUyaGE3VW9BQXpqektoZWk2Ykh2SkROdWpVV3hvSVh0RG8yTFZZ?=
 =?utf-8?B?UDdUbEhCcEpNZ1hVYVdWT0VDQUxVMXZ2c044aVp2RHFHcUY3eFFaVUpvd1pY?=
 =?utf-8?B?MVRnWkZPbmdHQmVOcUZoWnY1NS9DNzNKdW1EYi8xUFNjb3M1OXc1Z2daTzEv?=
 =?utf-8?B?Zk8zUjhaMnU2T0VVSzUzV3JuL2ZWODl1bUFIRlRDbENzOFU2bEN3ZzB5aUgx?=
 =?utf-8?B?c3dkdEp6SktuazI1N0FRRy9SelgxRmVKL0MrUGhUVURqQTZYK2M0OTYrTk9B?=
 =?utf-8?Q?sQwLpTfeAVM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YnZGS2FNOHRMZ3pXdTN4bE13WjVyTDV6RTBSa1BobVNCQzlxTUxQQkFzWHJk?=
 =?utf-8?B?K1M5WUV4cEpyVm56M25sdS80bUJXU1d4dGc5bE03K0kweGNQcGNuQm1UZWJu?=
 =?utf-8?B?eU5LemRQNkw5MlhvazQrekNzRC9nMEN0b2kxS0hWV1FMemtBaThSM0RKRmFs?=
 =?utf-8?B?YkNUOWJKQlcxazFhQTZjYWVZNDNjUDEyNUhic1g0eVNBWmdKMVR4Q2ZiY1Ex?=
 =?utf-8?B?TjNaRTdydmZHVjQvblhJT3ZXT1krYnNzQnlTMWRhaEMyS2lWa2NKeWtGQWEx?=
 =?utf-8?B?SW5naVN0R1o0V2FkcithMHFKRXRLTzRGTzBwLys0N0YvY3JHQjk0SmtCUXRO?=
 =?utf-8?B?cEVvWkxpYU9KaGt2QzNHOHlvN3VDU3gxY3JkRS9vU21oR01RTTk1cHpvRW1U?=
 =?utf-8?B?S1pScmIzT21Bc0NGRS83Rmg0VVJza0pDcDl5ZWxBcUEwUG9hUm9pQ1ZjTkNV?=
 =?utf-8?B?SEVRNXJhbG5qdkkrcGlGOHp5c2lkRjNOVk1kL2JiOTROVUNWODFGc25DL1BM?=
 =?utf-8?B?RkNZR2srVXNTTE40M0l4TisrNmJQNWg3bjlrVmoyWDRhNXJZY2xRS2kzeWY5?=
 =?utf-8?B?dkZ2S0NlWU52YjR1UGNhRkVwcldndjU2VFhuZjFCRTQvYTA1dGtOK3JYUkxW?=
 =?utf-8?B?L0t2b3owdDNTWllOWTFUOWNtbDAzZ1pBNUUrcE0zRUdiMUwrQ0tzVTIzT05p?=
 =?utf-8?B?ckNHZ29sNHhHMFJtR3F1cyt5cmhvekl0aFFoM2lzR1pKZTZEVlF6cDZEYm4y?=
 =?utf-8?B?S3FuWWk4WGhoR3ZBcjJCNDVFbU1HeXNaRVR1MFIwMnVOQnVEdlNrSlQ0SUNa?=
 =?utf-8?B?a25oSmsyeHZjMnREZTFyWnRzaXVDdG9oOGU0T0xMS1BuZXRhSnZNMWU4d3Uv?=
 =?utf-8?B?akNEWVJxbGRuQjRHSjY4aU1aVDB3MW5rNUlleCtLL1grWk5acklIb2U3WWt1?=
 =?utf-8?B?V25zMVM2a1kzc3pwenN0VTQ1dkhtb2VEWWkxc1NJRExaejQrajJPVThaMmQz?=
 =?utf-8?B?OGFRUmtBcXZVbDBnRUNoUi8yK2NNR2x1bnRWRXdIWjlSTjBiSDkyQXhzMkRH?=
 =?utf-8?B?RmlxSklhM2RFUTNJK1Z3NXY1Ti9yRnBTWnpleCtibEV0SG96TXZkWGNMNGhT?=
 =?utf-8?B?eWs1cERycFhLcXgxRng5YldJT2hGcmZCZkJmaU1qYXB0ejVpQTVOMnpUYWV0?=
 =?utf-8?B?bjk2NDQ3R2tPeGRYTnlNYUFFcWxHdmlDVWtmR0Z4bFRSbW5SODc3T09OY0Na?=
 =?utf-8?B?bk8zVU9DakVsSyt6TmhTWms5dU91dS80UlRHWm1sMC83WHRsZ1dBQzRqS3lK?=
 =?utf-8?B?N3d3dkdIeW5lSStTTEJOcUM0QjNsNmc5WEE0bzRVK0lEMGlUa29FQmhCOHZL?=
 =?utf-8?B?RTV3cllXNUFEZjUxK0FFU0VIdjR1R2FtZVBpTktUVXo2V2lOeDdvR3lFbi94?=
 =?utf-8?B?SWtCc1JNMTV3TExBcEgwdEJvR3VCNDhCaUt6NUY5cFYzMk9Hc0lVRW9WcnZl?=
 =?utf-8?B?Y3VGeENzZ1RTWlZHakRMU2thYi9tOFl6dTdzc1J3byszQ0FLZ2FHcXBxTGxL?=
 =?utf-8?B?ZXU5dE9nSGR6K2RLMEJwb0w1amF3VXc3NnRtSmVCQW1iMHpkYi9tazdKUG44?=
 =?utf-8?B?RW5mS25OcVh6bCtUOFJ5UkJ2cnRSQnczM3dHdVlHQS8xUnhGbXJUUjBvOE0w?=
 =?utf-8?B?STlHL2MybG1iYzlrSXFCVUV0TWN6d3VVMkdYckJQMEhCa2FYb1IzQUdWaTNI?=
 =?utf-8?B?d2kvMnI1YXpqUzdYNFIwYm1UMFVzMzBHdldTSzQ2RFR1RURpYlpTOS9NTlpp?=
 =?utf-8?B?cVlPc2QvUnlabkJ4ZzQxOElxanUvRTduQzcyYk5qSHNhZjRVbmxBZUU0T1U4?=
 =?utf-8?B?cGNMVmMzdkNCT0kxT2xWdDhENHVxdUJFbTZpUnpKL2JycmtPc3ZyeWUraEJC?=
 =?utf-8?B?c1NOcjAvR3Yyak5zckg1Sksxc3l0ZVdBT3FiTTBwNWpRZklqVFd2cVg1UDNH?=
 =?utf-8?B?L0VnK2VmeWJMajZDcmQrNGRGclhENUY1SnViOXlMMTgwaitkb1pnd0ZVdFJG?=
 =?utf-8?B?T3UydlgwMSt2Qnc3d3NseDRsclpaUjBWZUtKUVc3aDI0Z1RYMzNuQjRPeHRr?=
 =?utf-8?B?OUVrNFlOSmhmaFZVUUdtQ2lBVURIdlgrYVZnUGFrKy9MeXowYWFtVjJHcE9D?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8c6z2mYxBjE09myS/uCzSSek9bG35pb4TwZMTC3hopQYxg9NMbD/253xjOfogSx6lFkEOqMfXP+4vGEq8t/g9or44UWEqudJJMfbFTPrmXp+ISsaOUUOzamNepYTt2SULfVcREGOqA+NB4dl7/VSDo2Rd1VUPtdNJrPi9ZIidbiP906i8MERN/4Cdea2DkvUVaf6drrdOybdACm8LjLIxwWh8wyxchiiMZwrbZFH4BFVmbAZ21L10SOlRbXz3Etv4HlLU4hPMBbHlXU7zhCK34pyx0CmGvAOPgyoStkbEptNkTjfLBaPSUbA8DC6o4VEU5vqh9LrzPXhu7y16/2jjrcqq0OwQrd+ax7FJDbl1CyCiUWaSXwfCgDJCPRwTwXZbN8vqf9O/C1Z9+NegxP6M7DQXh3d8Kd7P9aeJotQMEMuaAicfSKweqsJB5dCuR9qTa7TudwNL5P8eEL9h9Zg80onnxbHNixfVn/O6NumZpHwutjjeAVpGxm4rZ1rqFDATGQOLQ0c6kZfVgMx6qlgYqlKagkSfu6j0TCONog5mwy5pj3MSMN8dFkv0p8dMXzDcsTBPgIwhmstDSBhLMq5G5pjloc9SE7ZpvJPH7zEk6Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02f83495-de30-435c-744a-08dd80473ab2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2025 20:09:17.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2Yyj4yASKlwYiHBR/26ZAgZn+Ug8hyxmWR8LJIVMe6yK6RRGOjgmkQG28ro0TLg0ppN8ODvp5pNs/NWyNzTjTryr45ThuzME79HZ7HFn7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-20_09,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504200166
X-Proofpoint-GUID: cq7UbdgJiaqkzJNFdkU1iU1UbrjlcrI-
X-Proofpoint-ORIG-GUID: cq7UbdgJiaqkzJNFdkU1iU1UbrjlcrI-



On 18-04-2025 12:17, Leon Romanovsky wrote:
> +/**
> + * pci_p2pdma_bus_addr_map - map a PCI_P2PDMA_MAP_BUS_ADDR P2P transfer
> + * @state:	P2P state structure
> + * @paddr:	physical address to map
> + *
> + * Map a physically contigous PCI_P2PDMA_MAP_BUS_ADDR transfer.

old typo contigous -> contiguous

> + */
> +static inline dma_addr_t
> +pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t paddr)
> +{
> +	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
> +	return paddr + state->bus_off;
> +}
> +


Thanks,
Alok

