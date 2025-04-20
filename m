Return-Path: <kvm+bounces-43704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C2E6A94982
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 22:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B94B188D193
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 20:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2C91D63D8;
	Sun, 20 Apr 2025 20:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KcjuZoAw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nQJraCH0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E3215D1;
	Sun, 20 Apr 2025 20:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745179610; cv=fail; b=q9+ZyEd/GwYdpP/yMjIICwGes4NEGl1EXER/wEvcvqJBFBs5WHIHY96CjpVi7uskn7SvStrSM5A94vIqlKMl7Yv5/XwZeakfA4WocNvGHf9Vhg5Krg+Jo3UN2kJfaaQw8ORjCO3rpIhtcefDS4r6hmt8sDowhMefjkLOggcQx+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745179610; c=relaxed/simple;
	bh=NHS+XD+SwbBWP/RgADnV10FeQN9RoInv/QTY+xC7M5A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eXEgfy9jl07NjydayP3HF8Jbn6ZQZi/wgZFp5BV63yftR6g7dHJaHfDbZuEKgr0HPv7grpmKAXOewJaa0G0SWmFTEUtSTkOoErVK4L7Gz4z1uf0+SOTCgPtW07En1tDKT4tFDs7+bDXZAqQUaET+emAoHs5d3tQRU/C97J/4Fes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KcjuZoAw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nQJraCH0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53KJlB99025916;
	Sun, 20 Apr 2025 20:05:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AWdpMUP6FliJSfRcywFxA0TqPrnBiD5MmsQFwnaLf60=; b=
	KcjuZoAw3IFOvGPjbx/8sWjRo9Q1XbxIpfOPDyuUKQ9/vpxyuqYDPce29nqzpIXn
	m7TOvhzkMuD8D51+bRYFZ0yC2Z4xK9RMamoFETitQGoUaac9/umcaC0wfGsgF1zz
	Mudiv/x/Hf3gQob5mcHXSaLwBcewMX7o8Cj6Wm1Xn8J5tEsDJx11U381ayQhJyLI
	FIJffgzQh5wSXTswrjdpH2IlSTqSPHWjKMsYaPcAVmF6O4p64cF6GZaOI7kElmWu
	gEMdl2FPm1rEkXQ3Ay7CXr9kXr94K6zrOHv436HPvXD2PywVl609cV/29gNnpyip
	d7VflhJPKkdaPlRZrOl29w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643vc1hmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 20:05:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53KJctBK005202;
	Sun, 20 Apr 2025 20:05:45 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazlp17012038.outbound.protection.outlook.com [40.93.6.38])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 464297kehu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 20:05:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gvIGexwqvwKW3/b8nJVuAba26CqvO+vJEveHNWx7UEP7Co7E31sFK+8/nfewWu9wxQqQSuRGa3q2EPC4ylUlfmZYhXSTwZZSYUGsnXtdFgxgvdPUIakCcv/r8yqUeIF3+fNO57UfzMdaYF6wKVNxNJ2vBkqpuIRv1pezGz5PFlrAbFKNUi6dRPl95dt2dbHq2a1jhkxIDWd7tRNVgTUt+W8d+ybc2TpJ1j7c/VUmC/ya5JNhnV3CqEzIlQ1vuqGYyqUHodgu8bwNrqnKwAtTT17iXdKqFsXl4SsGnnDdR6D2FQtYgPes3N7wzUNhK+mB7cx2JtidRtQYYhjs/9xNkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AWdpMUP6FliJSfRcywFxA0TqPrnBiD5MmsQFwnaLf60=;
 b=XL19wv9uiedwXLTsW3bB04BHG+7IigyXvafaULlh7Yg9E79+Usu5RAY59Lkq7tSRXa5zQKafVsKIzickMf8DwY+nzmDsU1+u+qs4Af5CQpBdfTkqoz4d3wj5QEIHwlf70BlqOF/S+kMKaXcBsF41mAqivMEoqEOFoDw3CAJ4ONfBz6c3cOQe6L/I5oYJ2FPk8ZzACRvN9l0nnEKW3MiMjEOSBiOtL8AmTCwJOYgGndO6uyUDnZCoPGDSyCxu0d8Mbq9V7rWKX5e06k2vDiXRVI4CRFDRtqLbAC3ASbi5g6ENuKk8yW4/BrVz3yff2YY+GGmrr2oUJLTZlNmQ1oS/7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWdpMUP6FliJSfRcywFxA0TqPrnBiD5MmsQFwnaLf60=;
 b=nQJraCH0SD/r1xqxCJLw801jZwk39efKCTC3TSXESmx5X748yuN1qK+LpfPuA90R9pl/NSOETRhzEAqeSfVbsoFwBEGkQNnWP2kqw/Oxdb7Zn7jr3GPxZNXJKNeNx9mgCTUAO6eMlwENKsUtfz1S5QAYvzEQ2VyX26kF3RCBgAo=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SN7PR10MB6593.namprd10.prod.outlook.com (2603:10b6:806:2a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Sun, 20 Apr
 2025 20:05:40 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8655.033; Sun, 20 Apr 2025
 20:05:40 +0000
Message-ID: <4698ae08-4350-427c-a024-401610b42e5e@oracle.com>
Date: Mon, 21 Apr 2025 01:35:26 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 01/24] PCI/P2PDMA: Refactor the p2pdma mapping helpers
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
 <cdcd9792a4f3f0d59b482c90121fe9b7a8e947e9.1744825142.git.leon@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <cdcd9792a4f3f0d59b482c90121fe9b7a8e947e9.1744825142.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0198.apcprd04.prod.outlook.com
 (2603:1096:4:14::36) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SN7PR10MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: a5652594-7e8e-4705-3c49-08dd8046b95c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dk42OUF1RDQ0VndPWTNadUlBRFVEbGpqQ2MrbGtIN1pYVm9NdUYvNjIzVzBY?=
 =?utf-8?B?YXdzZHd5VG1jcVo2akFUSDRWRThtU1lmYTlBaXVYZTdjb1lld3h5bG53UHI1?=
 =?utf-8?B?RWRYbjZvWk5HejVQUW1LaDZmVUNkNXBkYnloYjg0STFZVFNGOExreWh6NmpC?=
 =?utf-8?B?WHN4RzZFUmFINkFhOTRZUmhWUktFSG9HWG1vNG4rRXJaWTBLN1Vub0p0YWs3?=
 =?utf-8?B?OU91clRjNE5iVWtsa2RzTWZsSTY1RmdnUFIzTWhjbUs1UTg0bjRQNUJFZ1Vv?=
 =?utf-8?B?ZEo0R3dhazRoYWN0WXZ4NHFuaTh6dlZSekltUnQrdTEyZy9Jd3dmdndIWCsw?=
 =?utf-8?B?NGlhclZTa29PWmdiclpXTXMyNWE4NXhqSlJsS2FJOGd6Nm1WS1dVMnQwemNR?=
 =?utf-8?B?SGZmSThzaXQ5aFhJWjFMWitVd2U4OTA4bU5POE9QcEFpamIza1JtbXExSFFF?=
 =?utf-8?B?VytaM1ZHWDVYZHFWc3VqeFRGb0lLa01tc3ErcVF4YXlTOUNWK1diSTZCKzRQ?=
 =?utf-8?B?cWhkWFZrdzZyZ00rS3pDUWlSYXBiallLRWovYitKeEVURU9rVURWMTkxTjRV?=
 =?utf-8?B?eGhNYWhnRFpTTE9LZmJybjJ3cE5haFJzYS9sZlVsNG54dytmbXhIZldtQ1F0?=
 =?utf-8?B?RmpNRzJQSDMvZlM3dCtXZDlFSHVwVm94bkdkc2hTdTZ4SGJTTW1FYkt5eVp2?=
 =?utf-8?B?cC9NZGJkZXV3OXlJOFRCbklZN3dVK1BuY0dZemIrVXZoZFh6ZldnME5DcU4w?=
 =?utf-8?B?aWxwbXVrQmtoZTRyZmdrcThuZGpLTWdOTG1MSXNvRENNcFYwQ2grWWFYZ1Jo?=
 =?utf-8?B?TW1PYUVzblA4R1IxSjFpandQY3Rwb00zNFZtVDhKbEt2NlVFU3p4NWNzOUFy?=
 =?utf-8?B?UkNXeFlmcTN3NUpsMzZ1aHlKSndXeEhCVkIxVWVETTdsZmRqOFZaOHBPOEVj?=
 =?utf-8?B?VmhwU2JiK01yNW81eXBXV3VTZ3NIbEdKbnNEZmZnRjhSZDBWaWFxTFZhZyth?=
 =?utf-8?B?ZHdsRExuQ29NWUZRNnJBUDJtSHJTOWZUVjFjNmlSMDFGcExRc1RITHpzN25z?=
 =?utf-8?B?TXhDQUY3OWZyMXFBb1ZOUDlycFAvc3ZPaTlUR3BST3hkZ1B3bDl4M0Nuc1Fu?=
 =?utf-8?B?VUhzNkdwNVdaN1luTjlkaUVYeTcvQWJYZUdzTWtSTEhaQnlQQ1o0bmh4SHhv?=
 =?utf-8?B?dHpWdi9wRFRaeTAzQ3N0L3Z6VDVtZEswcmJuVDB4ZlZ2dnN2alJmRkhwT0cy?=
 =?utf-8?B?TUhDcDNQQjZzWE5odlhudG9jeVp2YlNTRGREY0tHWEMvRUdqOEltaG81dmZY?=
 =?utf-8?B?WTNHTlZKYmt3TDBxUkxuUm1xbHpRM3pYalFvT3VzR3BHcG5DSTA1RkdGazcx?=
 =?utf-8?B?WEJPMzd2SDFOQ2dZOGpOSE1ocnN0NE9sSnBDR3VjcEo5ZXhyeTVtRzlwNFdW?=
 =?utf-8?B?UjdJRFBUeEZoa0NLdUhwTUlTbW94a3RabXhrU0R6enF5SjVhT2RWYkdWcG12?=
 =?utf-8?B?NkxTN2UzSGZpa0laUlM1cHR5MDk2cXZXMW1QM0p0SGJaekdIbk8rWVFUNHMw?=
 =?utf-8?B?SWJsenpIWkpoalhFM0lZK0dhbVNqREYvY1lRTjJRNFNNVWRyTVg2OFM5R0xV?=
 =?utf-8?B?MkxSQnlxS1Q5S1dHS1B0Vm5IUEh6ZmR5bllxZlBKTE9OTHFEMXRVQnlTb2JF?=
 =?utf-8?B?UU53a3l1N1FndXJyQVhOcXpINyt2MHJicXhuR2M4U2NXUmRHNFpQaURka2ZF?=
 =?utf-8?B?RDhqbHlXdWtBVEl6ZGEweFdyUUt6V3RiM001enVaK2ZPeTJBT1dWZEg5TlVN?=
 =?utf-8?B?REp4d3ZxcmJNaFBSdnVQaExIQktFNk0zbzFZSTdWNjhIV0NDSHZLd2ZDYlIz?=
 =?utf-8?B?UDhnRHRNMkRnT3BlVzdIc1JBUjROVlQrbUZDWXZiRGgrYVFIS2hwRkZPck1k?=
 =?utf-8?Q?IG6tnWPpha8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0hxeW5NQ1R2R3AvNUFXeFVUalBzbzJWemFpcE9BVnpKWmh1ZUxERTNhWFJP?=
 =?utf-8?B?aTBHVnE1TThOQ3A3em1mWDZNMjJEcW9ta3M1YkZFRzJjWkdjdkdtOE05b3BL?=
 =?utf-8?B?ajFyaVdheXh2WEEzOGlhQlBxZ1BIcDN6QXltUklOU0pyaWdHcGJ5NjFpS0RU?=
 =?utf-8?B?cEduSzZHQm9GSGxZbGxTTms2dm1MNm9WQ25YRC9BNkhaQVZXZ1lWTVdzVHRz?=
 =?utf-8?B?N2N5T1o3Mmt0RURkbEZuK215MzUyT05Lcm1JTy9lSG5pRXhUZHc2RHNoeWRx?=
 =?utf-8?B?K1dmb1ZTbUh3YXowV1BwU3J6bmZaU082TzA0ZDRsNDl0WEpWYjlYSkZaM0xn?=
 =?utf-8?B?bUFvQ2dOb2h4MWVqWDRsTXhodERKRTRSRTZscEpZUmFxM0syRm5mSjhGSUhx?=
 =?utf-8?B?RjNjazFDcG90WFNjNjMzeFVmT2plRmI1ekIvSi9VZmtTdk01RUljL01tbHJw?=
 =?utf-8?B?bEhlNkwwakNhU1hGMytsOGVLcHRoeEIxZmpvR245Z3c2Y0U5V0VJay9BLzVE?=
 =?utf-8?B?dXZ5Wk1WcnJ5Q2t3akZqcmVXcndpOEE2L1VSSzhIZlZyRGY4ME90cTYxY2F6?=
 =?utf-8?B?b0hvV1RNODlxakNmOUx3VVVNZjh0ME9VRTRXaFhjMjBzZWJtdGF0N1E5Z2dD?=
 =?utf-8?B?L1BLOWhPWFdXZEFQT2pqZ0FnMHBMM2RDbytFai9HZm9HTVhiVUlnT3NveFN4?=
 =?utf-8?B?cG4ycStuMXZmY1hMQUJRR2U0OXp1YVZDRkdxamw0Z09GK1JrQnIyN0JKMzZy?=
 =?utf-8?B?TXpTZG9qczcrVm5nZk9pQjNUVjcxMHErTG53T1QydHZoTzR1NWpyQnBpQkFz?=
 =?utf-8?B?dzBXTldRNkZHZEFtR3J5aG1OdzRVbm9Id1NOMjArYkZmZHpLSExUUWZ3QjZy?=
 =?utf-8?B?TGowQlFYRTFyZzBmNmlSR3NWVHU3eE5yZEdWZG8rQjdoN2J0Q0NIOHVHTm1W?=
 =?utf-8?B?WmNmd3lJM3g1aE8zNHVTR24yMk05UUlpL2JQQlp4TDU3ZlNxaWFlaDhTOFlt?=
 =?utf-8?B?TjZUcDNxS0JQdnNMNmc4elR2cmV1WGJRcVRJN3BWbDIzM2tEcENuQ2ZJRmJS?=
 =?utf-8?B?MmFiZVp6ck5MSFF0YWFBaU9QMTZMcXllM3F1R2VpQ1V5am11Tk9ndHNUbHRv?=
 =?utf-8?B?QU5FWkoyY1NPWDZwRDZXNXdGTDhsK2VQNG1WeFFUK1A2Mzl5dUJRcE15SmNG?=
 =?utf-8?B?SFhmeTZpRkxtNGZyYUQxOVBEejdKZmdIeUFPU2xGQlZYNGxEbURpbUIyMWh4?=
 =?utf-8?B?d0Y3bm1VVDlNSkF3LytmV1VnbGs2TjFqRGx6NytSbDlSdm1nZlRTRVhpVVg3?=
 =?utf-8?B?WElXOHFZQmwvcGQyWlZCUkxuQ0gyS1pKcmZhSFRvRjdKMVB1WUR1TkFRSUNZ?=
 =?utf-8?B?TmZJcmpTdGxjdnBqc0JGR1I5VExRamNmN3ZtcnFXVmRsK3c1ZXpQZGpHVndK?=
 =?utf-8?B?ZFdMZTdodGRMdUZBaHJYbWUvRmU1akRTRHdHeVoybkx2WkxkZnBjNnFvbTFp?=
 =?utf-8?B?N3JhMWpSVHR0c0w5QkEzbTNZUXNrLy80TGRmTnNWdWpVaDFxcFFrVDFKMkl3?=
 =?utf-8?B?OEFkczI0eHVtUjBSQWxWVHBOeEZWQWl1ZWI5c3BTUzJPcnRYZFY3L2dnQ3pu?=
 =?utf-8?B?WHpZQVBXUkpDeUxBTkp0dllUQkpWaGNtUDV5ZXM1Vi85bHl4TVBzYjZuc0RM?=
 =?utf-8?B?VkFBMEEvN3drU1FHSk9wVkJDenRtRGZwVU1vQ2dPb0JYSmc5T3ltUnBGbXVR?=
 =?utf-8?B?bWVURlhNOHA3eDNHSXNlU1paczluOEtrUUZrSVZmcFFzRm81cExZcjE2Tmpa?=
 =?utf-8?B?NTJ5QnVDWmdsWnVRZnVZVVo1d2JEckUyL1NoUllZYW1mQTlEaFB6S3NaK2dS?=
 =?utf-8?B?dFpqUEFQbGdsNjdqNHZOWC9FY2k2L3JJYklFTmM4aktEOTdzZGg2NWo3T1hS?=
 =?utf-8?B?ZlpJTW5EdHpWWXUxUGNlWnp5cklDd0RCckYvU0tkcnJPRHYzYm1teWtyT0d5?=
 =?utf-8?B?RU9kZURjcFNjR0UrRnA4Mm9Db2Q4eTVPeEpaanVVWlNsejNVNUU0Y1VCN29r?=
 =?utf-8?B?WUllVWxObURXOHFuc2d3YlplWGxuZ2RzZm9hWVBtR055NFE0bDRVdFc2ZWFZ?=
 =?utf-8?B?eDlqbG5OZWl3ak1WRVJkRGFId08wZXJyT2dETWplK1M1WU9NeVRTK0dSYTdj?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k1CxktfgDO/ACDQxuNAB3poPHWHodV0tMLzRrSvPXWBqbw36rinO1P01L9ayYo8Lex8FpHAeFkDbSdQKRSp50udP41d4lG2DkAJ9iqhY+qeadvHIBFklbj6ml2WQ3KPMnipLlYExGlxq0HKbGQwbhHlw3trm+TgFt6+Xbie63fQoO5CscSZpwMENT7lJvRqEPuFGb8KHABtp7C9wtSxMoUIllVofsiEIBo81VbAGDQpS0Q+uoKmDnsbEczlmr3nGVf2ct/wLZDlu2gxgOjGJKCNZYL+n+9Q3duBFoQCbo2HdNGrnX3BFp36l4U59IVmf3YjPlFI0u1XO/1cH4KYiodVXBqi9vdKMN9unXvo4EKgpnebb5hptalYS/W3qsV9JaMR4nnFIlvROJRMKH7b08Q8LBBpakxgSk0qPcYvjI0kIK+pAqTBgVgUVa6m1EmmDgkHKpNTu0ITTf9h6JWESYogu7OX7gOlw85K02AXbbV3+l1e1DHfTw9sVz8PK9YgiWO5j0DRw16EVCLJnlFr1bkmoD/lAC9JYgHlwBgS6jtCKA+R9uIzk+ARV2ZqK+2rIigva5iqFt/F5o5YEQSob19Cidy0G9rg5YtlXJdtO8ro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5652594-7e8e-4705-3c49-08dd8046b95c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2025 20:05:40.5599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0bf2oF4AXZwTu/1tDfaI4gMdwnpMBeZ+IMHaT2W4Prhc+fAWFuGTc/48S1w753eIHtOt5lGEhNUQT+kZaBnBUGNYxgMykGJiJ/3qR5Rtqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6593
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-20_09,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504200166
X-Proofpoint-GUID: O1Ynm3T0kSSU3L7NE3G0KU1I9RhlLdD5
X-Proofpoint-ORIG-GUID: O1Ynm3T0kSSU3L7NE3G0KU1I9RhlLdD5



Since we're touching this code, it might be a good opportunity to fix 
the old typo

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
>   {
> -	return PCI_P2PDMA_MAP_NOT_SUPPORTED;
> +	WARN_ON_ONCE(state->map != PCI_P2PDMA_MAP_BUS_ADDR);
> +	return paddr + state->bus_off;
>   }
> -#endif /* CONFIG_PCI_P2PDMA */


Thanks,
Alok

