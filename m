Return-Path: <kvm+bounces-43706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BCE9A94994
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 22:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D477D188EBCD
	for <lists+kvm@lfdr.de>; Sun, 20 Apr 2025 20:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9011D6DBF;
	Sun, 20 Apr 2025 20:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gT9SbWj9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y8T9vdf0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD3101E6;
	Sun, 20 Apr 2025 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180666; cv=fail; b=QzI+EonJXsJsKLWFiFu6KrSK+/mvAIfDY/hWKBVXEMdZQ1Fh7cvZjoupqXbC7hF3BYuG9PLYF7UVopy5U/2ZykxgnBlEExefIeF4pzcxDLWStNyFkmsfFABfCIc+4CItWtoRIzBjqHRgYy8yP049wDoYv+yzea1EYm3uAn8ppEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180666; c=relaxed/simple;
	bh=DTN/Adpi0ux5E0R4b1tTWm/LYK3zRp+ET55b7InbUEg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fBkw3cevUrZrtEYa64XH77KfP9DWD87XWfVpjxx7Kg5AsJzamH7cWLBHHTTqr9M5P0Fwoz302bHp3cjTrCsnlu44iFWrXdfyIsHFNpp8Oy+6DinEjv6MZAvhC585honPIzX56NdxmTjgFqCBmx20O/Mj8MTH5j8HYqI+v4yTHW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gT9SbWj9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y8T9vdf0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53KKMv2l015072;
	Sun, 20 Apr 2025 20:23:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=AYmvFVERdHJjgF4TsmcxH8aha5VnYTL3Nhr9vfbVAuQ=; b=
	gT9SbWj94SbBrXogBmD6L1JSkspFjHeAWB6vx79yTpJrtP857azXCveq4bf3a2Mt
	Gy/4EqR/+B/9PuGk61SnEr9P4D25n91OWS1g8ztgrMOgMDP5YFAMuegIBMNqnDQt
	hs5hZ5hqZAxivK6EhZHlQrmS35HBW9YoB87O9jeoMBfr+IhPm7MxzJla3fdHJxxB
	LGapPYbJtu7AJVsCR3BBm+HIjUS1sn5HbYrUORKqc7QGG21Z9F7KfCjvB2JqLjh6
	8qScgTbtHoLlTCVqZTnxXk65ZCWOvnaaH6q5LY9viuoszKvUIrmEEXXDcJuZMHp1
	psGtt3YLFcOQwGABQUcEVA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643vc1hxg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 20:23:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53KEw2vF002783;
	Sun, 20 Apr 2025 20:23:31 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010000.outbound.protection.outlook.com [40.93.13.0])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46429e3v6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Apr 2025 20:23:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ddg50hzJXqLnkzcrYIALP8vZ018g1XaWaOd7yMDa3FWs89jpqFdlpOfcmhX0fQeKPt0VP9cbQEGpm1P4BYElzqp9oDdqAXdkWd4Mg3z7R6t3oG87lV0uTPHFkIbidhanitzKYHD1MIMaBAZNwSewpchqKdZglnvjmO3APPUWURV2TZVLPYxcKDPmb0CusB1VFd8T1VrlI3EXF2VGDHomMBaCfKs8YLpx304XxSIz2jxlkKIkqaZspIadlL8mZxCBo4OCqtGMT1kBUWqFCpkmKsVnYhvusAhRFgP4AlXct0+jGnrzMW7sD4WgqDhJ9hmTRDSEpSMoylnAAvCw0tv4RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYmvFVERdHJjgF4TsmcxH8aha5VnYTL3Nhr9vfbVAuQ=;
 b=rSswkgAspuHxkRuBS7z1rd7eNw4N9WsiyWUT3KMx6gb2WZL0YdLjrtnbyvApT3spJ9isKhVxD94/NJglCBJVajMcyiMUcKdvTF3Szaq5ZKmY+OhqNvkL8kDZOxImmZzJWFexImzDCF70iBKjIUlSAkbqOZyvwi7x98lZqvl0vgKTtmZ3sls3O8wwQJpbujPCZFZ+JRjZgokl8IVm8aGbgt7VXG7cI5QHfZGHBXjloqkW8nFkJ9A7bBi9z85GsvqqvWygGLSPylQRZVqcICFqEfVvvVbICxdZdElBC0qh9LCuZdW63u+2BouELe+ap9cMdWqbow0jOp3fsITHP2j9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYmvFVERdHJjgF4TsmcxH8aha5VnYTL3Nhr9vfbVAuQ=;
 b=Y8T9vdf0wZH80n0c7ikmxws3Kz6pb6FJoC/5v+XkgtlEKvvtH3jEeRZFBzc+RKZzTCYta3DK2NWTSDqF1omCHqHXBtnrc6+hGhGha91TVN0C5D8/6oVNpxrO+q/Jfc6aD5qvfKmaeAxcKoistfklhtVuzH6r3t1f8cKV2Foecxo=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by PH7PR10MB6033.namprd10.prod.outlook.com (2603:10b6:510:1ff::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.31; Sun, 20 Apr
 2025 20:23:28 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8655.033; Sun, 20 Apr 2025
 20:23:27 +0000
Message-ID: <76ac1e9d-b309-4553-b3a9-99674981a06f@oracle.com>
Date: Mon, 21 Apr 2025 01:53:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/24] dma-mapping: Implement link/unlink ranges API
To: Leon Romanovsky <leon@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jake Edge <jake@lwn.net>,
        Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
        Zhu Yanjun <zyjzyj2000@gmail.com>, Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Bjorn Helgaas <bhelgaas@google.com>,
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
        Chaitanya Kulkarni <kch@nvidia.com>
References: <cover.1744825142.git.leon@kernel.org>
 <550511a5397e9964ee753134e702eb5c00b01336.1744825142.git.leon@kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <550511a5397e9964ee753134e702eb5c00b01336.1744825142.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::24) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|PH7PR10MB6033:EE_
X-MS-Office365-Filtering-Correlation-Id: ffe9fec5-26ed-431a-176f-08dd80493575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEdJMlZ5NkJMMVpwUnlCeWwyRFNnODJONkVKOHdKUWYxTUNmMG9mdHdQTEVH?=
 =?utf-8?B?ZGliam5MMW4rbFdwWlhXWXhFYklOOWRmVDlRSDNvdWdhV2dLZWUweE53MEhx?=
 =?utf-8?B?YmdydDI1VVhJODhJNXRQU2FLbnBERFBxV3NaRHoxeXprcE5PYWNNTWpESms1?=
 =?utf-8?B?ZDA0WlNmR2IzZW9MdDAwZ0ZrMjhIQ0tkcXVUdTF3Vk40Y2E3ZXRCaFI3Z2dz?=
 =?utf-8?B?T2EyaitlZlZyOGYzK0QxYThWV25JeHdQSmRDaTgvcnMzdG9CdGdjZnViK00x?=
 =?utf-8?B?RnFIaDRtdVJRQmtncGtNUnQxUE9kK3g1blpKVGxzZm11N3pXY0xRRDg4M1F1?=
 =?utf-8?B?alFRVnBhNFF4QUlySndRSi9NOFNPV0pPY0VGZ1R4RWt5bFZvOFRXaVVCSkV3?=
 =?utf-8?B?YkV5dlBvSzllY2Z5bFV0Umo2dnEzTDhQNHdEMjFoYmdNdXN1R2hQUjZpWEhP?=
 =?utf-8?B?ZElyNmVlN0pZYXpiMVg3bDFYTFZySDlKNzZoSU5ybHh4L25wdFZuZVcra040?=
 =?utf-8?B?Z2dvWTdwaWRUTjNUZFZYZ1E4SW1XaG02amtEWU8wQzFYc3ZuZmpadmxkQ3Fo?=
 =?utf-8?B?YWtUUUVLUUtGaGcwNmJ1OUlkL1g4RjRJUExYTmNFSlk3OUJFQzhzcDZGVldX?=
 =?utf-8?B?b0tBbm8rMnJQdEJVVlpoYVA4Qm9CTm4zSkFNekJOT0ZxL0NwVmZvbzdwODBB?=
 =?utf-8?B?MUFPaDFWQnZvbmk0NkdwaTJRZXcvQVRrSnR1NXBWR2tzZ3NJdzgxUUtMVEpx?=
 =?utf-8?B?ZTZKSXJXZEE3ZGwvMkYrYXdzTkFXQldSanNObXBpdTc1ejhUNzlMOEtIU2dZ?=
 =?utf-8?B?cGM5SDJJU1VvN3Jhc0NaMU15dkN2U0MrSGZaWmdETXRwTURORW56dVlrQUN2?=
 =?utf-8?B?eHFPWlpQd0M0anpxaGRPMjVSQm9JTjNtV1J2TkxOaGFPRkYvMjZsNHZEK2pG?=
 =?utf-8?B?bjlPblhsUWl3ME53YnN0UEltYUVuZWpQZWVESktOMElCcjJYVGxKZGlXR0Zh?=
 =?utf-8?B?dytQSHNmZUx1c0tZNmwweXcrTU81VkNtQTgyRXdubmFHMGFnQnNjZ09QRjJp?=
 =?utf-8?B?cjMzOE5IelNHVUE0Y2FwYkdqZW9CQVI2VjkxWWt4Y3d2UVl0SVd2dHZsc0E4?=
 =?utf-8?B?TzNScWFTNHhzcWhyUXhlWVhSUlkwWFB2UlVVT3llODQyTFNtd2NHMVRHaWNW?=
 =?utf-8?B?aGtEdFJTZ1FZSEVQNDBIRXh6RU0rZzNZbVpFeFI3bzJ2KzNWc1pIVVp1V1pZ?=
 =?utf-8?B?ZldIRHpGRVMwbTdhak1vMVRsZlFWSWFTOVNBRVBybFJuWUVTalZXSmQvSmVu?=
 =?utf-8?B?UXRNSldDTWExTnUzczZoL3RGNUtmTXZsVkFVbnNvWjJIek05c0hQUWRKb0w4?=
 =?utf-8?B?MTBiTDZMRUQ5cUt0eVFPK1cvRis4cVp5NVBOV0JvWG82YXdCb0VSczVlZzJw?=
 =?utf-8?B?NDlMQ1MwSE9zcHhxdlVXQ0dKQkVsczB1Z05mMnRHY25lL240RE01MDI2VUZ5?=
 =?utf-8?B?aFVqcGd3R0xMSjZjdmo0SnFCZ2pLeGhwNzlzd1NyYm1ZZTZYRW1FTStIREpW?=
 =?utf-8?B?SUxTSTJaRFlJMmVzcllyaUJaKzdOTVBtM2JhZHpGdFdTUlI3enJhUEFSa3dj?=
 =?utf-8?B?QXk4RFVheDl1eXVWMnBSSUEwNE5SOUlqdDZWK1dzUnZhRklGWTN2YjRUTm9Q?=
 =?utf-8?B?My9VQ2RLQ1kzT3gxVnE4ZHZwdEhmbjc4UHNWR2lnRkFPMDczbWdhOHVrZG45?=
 =?utf-8?B?cUVhMXpQZklZZkNodDdPVHhwQmJ2a1plTWdsVWtPd0VOMm9tQkRIQmhWRlMz?=
 =?utf-8?B?d25FM2Q2ekRJYVYxS2lrYWNPZzBhMkZaMmdmTVhGcWxJVnhRWm44bU5zUmw3?=
 =?utf-8?B?WU1LTDRVV3ErODlMZklSYWI1TTVIS2MzYVRlMXZ1UEtPL1dMTTdjOHRiVVZT?=
 =?utf-8?Q?7eZBKffS09k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U2V2WHVsMUJiUWpLTTUyWXhycGdWaUF0SDBsbEc3NXp4MTRMbEtIek5rVWFn?=
 =?utf-8?B?Tm01NEVISFJuMlJqWnBZNWNEcS9teVZlVWNOZ0hEZUxvdXhIUEFicmZaVkto?=
 =?utf-8?B?VE5CbXc5Mk96ZUtKV1QrTCtLdTAyNXBKanYwUEJDUWlpeWtNaTJhUTlVUVFk?=
 =?utf-8?B?K1RDYk9MUWJoNnVvbWphbm1aekYxeFBLb2tGcE5FS1hjOTY2WS85OFl5ekl5?=
 =?utf-8?B?aDFkWDEvT0JJclNWUDRMWWRuZGZZWmx6ZU1CYWJpVXk0TkdDSWhPaGM5TE8z?=
 =?utf-8?B?TEI4bEY4dzYxdDRRWTE5MG51cDJjM0tXSEo0cnFSbmRvUXVDTkpET29WUk1R?=
 =?utf-8?B?anZUWCs3K1hmbytKME1pdVozcXdWL2E2bjVRamhQanAydUxyOXNjdVhsM1B0?=
 =?utf-8?B?MTAyZENPUklDK0hOWk9sVU00QXo2ZDJlOVhCdGNqZGx4cVA3Q2o3TWwzUE9I?=
 =?utf-8?B?WjlVWnhJWG9HYmowTmxIWDcxZlpHRThpQjBrL2ZNbzlwSTh6MVJ1K1JwVTVi?=
 =?utf-8?B?VDREY1B3V3ZTODFEY2pGTnYzTTNxcis4Qk1uMWlPTE9sRjNvNzNtNzRzV2Zk?=
 =?utf-8?B?elJ3TGhWQXFFRGtNem1ucUYrSUVYc0w5dDR0T0c5Q05ub3lqTE9OdnZJbExI?=
 =?utf-8?B?S0FNdDBiQVptL0JtZk5Wd09vMDU5Zng3T28za21zUHJrNWZkOXNmNUhWWjNV?=
 =?utf-8?B?VkN1LzhsUkdUZUlOejc2TTBCSW9EVUlxM0pqWkJTWnBxQkhQT0dyMGNkcDhV?=
 =?utf-8?B?R1VSTGNMRGVwME5OTzBCZ1NsQ25sTnI5RlRTbmJTZEhOV0p5UENkL0E2ZXhV?=
 =?utf-8?B?MVpXSFhPUzJidUFUdkRBNnB2b3BOakV2aUhPTG5DQlNDc3o1cW51ZUhLSzJ4?=
 =?utf-8?B?RDAvK0lHQmdmRXMrS3lGWUZzaHVZR1k4WnZ1WlNuRFh6bUNyOTdoSStwamtQ?=
 =?utf-8?B?ditRQm04ZWZneUhTaE52R1JQNmFBVUtCOFo5UE5sUGpuSlNKZk5pYkg4eEFo?=
 =?utf-8?B?QVZDS2FkSGUvcHdhL0pIb085ZXU1K1BwdXNFc3d3c0pBZktqMVdCWEdHVDZh?=
 =?utf-8?B?bkNOazA3QTdnSURDR3NmbkExSlJrVVVJeHM0VmQ0WW9HeERBMk1Ta0VQRHNo?=
 =?utf-8?B?ZWwwOWcxcGQ2bjdid3JlKzRqQllKQWFrNkpPYTg3UE5MSzlLYUMzMzdaUk0x?=
 =?utf-8?B?ejRMSVpEWUV0OXdsYXBLWEQya0JLaFczWFkvd3JwSWlEckFGaU8zTGd0MzFa?=
 =?utf-8?B?eE1kU09sU1NORUhObEZNbGtUeHNFaUxYU3RrNXdDbmpwZ28yekZvMXJHeDBi?=
 =?utf-8?B?T1hiSnk5Qi9TNitIZGdvU2h1ZHMydFhRaTlsRVNldUVMcUhUYUgwZmNsNmdH?=
 =?utf-8?B?OWNVdUtCV2YzUERCcDZqWXM1R0ZZQTZQckNtbUtzSWJHdUtTY0ZSVXJiNlll?=
 =?utf-8?B?UTRtdTI3U1dOL0srSUwvQlRvKzRlaXg2RWNJaDVZVEJYdjB6SCtHODFBNTlx?=
 =?utf-8?B?T3RndlZPSW54anV4dTdvcEYrTVBnVnFSZk9uTnMvaFJvcU5kSzBicE40cWZk?=
 =?utf-8?B?OHpiVms5d25ZckI0RUY2dDRIN3ZhZlVlYWdydno0dHM0aTZmKzFXSzlIVm1F?=
 =?utf-8?B?aXgzN1RrMzBPVmdKK1pwalFrN3p1bGhaOWtaVTJEUmExb2F3bnZ6YmRvSDE2?=
 =?utf-8?B?OEdpWTQ1SThvbjc0QmRsZWVrVm5FWjZtQmpHUW9hYTVueFpuS1B4cG8wQ1Zr?=
 =?utf-8?B?NHNmRXRNWXlOSmlPTzB2Ylp4d01tL2dpQUNqZGFkdEJ6ME4rUHFDbS9wbk0z?=
 =?utf-8?B?bmxaOHR1QU1oc3VDMHNhSzlLTTNwYVhyUGNac29uV0tZWUJ4cjFCZU4yVmxE?=
 =?utf-8?B?VlBmVmlrS2F5cUFsbzE0ZkUwUGFkbmtYQWVHcXljNEoyVzdkeWlzWk02VGZi?=
 =?utf-8?B?VXh6Z3FkdWQyS2d3RUgrci8zdUdNRmZGV3RsbGJyY08xNGF6WkVZNXRZQjRG?=
 =?utf-8?B?QmNNeSsrSWlSbW11cjJBUmVHY0FNb3BOdU9wSXZrTE1ITVNiQjQ0eXp6SEdY?=
 =?utf-8?B?ZmtQa3pSeHk4bkVFQVlkVFhhWGExbGd4ZUpEVk5mMUNPTTRaK00ra0haamJM?=
 =?utf-8?B?SmlIT2ZmempjcTBOYWNMY0RDNXdOY2FPUnhSUzlocUsxdEpGbW1HV1gyN1FH?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SZ+/z3NgU1ZmUkhpQHqFvprKa8VCqfvbD8QkrBKDNimm2DmYXJCQi8LZHlIgKUgKlmfNZEanUCTJ5AHr61igWKDOZTiQ+Qo/7fe3lerU3dHfHC6Sg0iIuZdTI7mVpCB5WFaTOT/gxI44mZtm/BWtbp4f6nvrzKU2b52DQu6QVOaeiuSYXKBNrNd0sNxWpEquiF5z9aiZ6dxU/DfJ9khYSF8Lel/4fx/3bG8Jz8OCTnb0oRTfzsvE6b9e4vmJYzlVzrQnSWW1BcKZDqh6W8kcnE0uJY3Ugral3Pa2N4Erx+hVlJNRe80DMjUxEPzb4gnOno8c6bX+dHkzevhPkA6ivuGg3d/sbuGi5gwERnrF4g/OE7FjBpU9QXt+dNW3lqYGpHplILdGZhKEXx9XjkfScDkDH10O4fuaNBnArR2M0cW1VzkSYyqV6YqusCj9SIzetqTX+4KqVbnGFkkpfsjwmdH+3L0bnJcefYGv5+C6FOB8NL3sytvxWgTYv9KsPF0BGeAaWsouLnFzhp28dQx9DG4EqYH82v2a7kY8laNYvfNdDrjHZv0X8APvir6HLD+7gt7+J9TIPsvz0zflUNrNq7OvRKwNPUnvXa1Ru89MAQ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffe9fec5-26ed-431a-176f-08dd80493575
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2025 20:23:27.7971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XQxan4kpmbbJsbeKY+8E7yqspek398H5oM4eTqzTLUM14ut/7Xx0xTr7oHyUqVj6nxxf4JL3saqXz5aKwDOAETbXTOU00/IkBTw2ozJZQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-20_09,2025-04-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504200168
X-Proofpoint-GUID: ZW_NGJ7A8Yf_A4mbB0680Gz8fwbK-vgz
X-Proofpoint-ORIG-GUID: ZW_NGJ7A8Yf_A4mbB0680Gz8fwbK-vgz


Since we're touching this code, it might be a good opportunity to fix 
the old typo

> + * dma_iova_link - Link a range of IOVA space
> + * @dev: DMA device
> + * @state: IOVA state
> + * @phys: physical address to link
> + * @offset: offset into the IOVA state to map into
> + * @size: size of the buffer
> + * @dir: DMA direction
> + * @attrs: attributes of mapping properties
> + *
> + * Link a range of IOVA space for the given IOVA state without IOTLB sync.
> + * This function is used to link multiple physical addresses in contigueous

old typo contigueous -> contiguous

> + * IOVA space without performing costly IOTLB sync.
> + *
> + * The caller is responsible to call to dma_iova_sync() to sync IOTLB at
> + * the end of linkage.
> + */
> +int dma_iova_link(struct device *dev, struct dma_iova_state *state,
> +		phys_addr_t phys, size_t offset, size_t size,
> +		enum dma_data_direction dir, unsigned long attrs)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	size_t iova_start_pad = iova_offset(iovad, phys);
> +
> +	if (WARN_ON_ONCE(iova_start_pad && offset > 0))
> +		return -EIO;
> +
> +	if (dev_use_swiotlb(dev, size, dir) && iova_offset(iovad, phys | size))
> +		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,
> +				size, dir, attrs);
> +
> +	return __dma_iova_link(dev, state->addr + offset - iova_start_pad,
> +			phys - iova_start_pad,
> +			iova_align(iovad, size + iova_start_pad), dir, attrs);
> +}
> +EXPORT_SYMBOL_GPL(dma_iova_link);
> +
> +/**
> + * dma_iova_sync - Sync IOTLB
> + * @dev: DMA device
> + * @state: IOVA state
> + * @offset: offset into the IOVA state to sync
> + * @size: size of the buffer
> + *
> + * Sync IOTLB for the given IOVA state. This function should be called on
> + * the IOVA-contigous range created by one ore more dma_iova_link() calls

old typo IOVA-contigous -> IOVA-contiguous

> + * to sync the IOTLB.
> + */
> +int dma_iova_sync(struct device *dev, struct dma_iova_state *state,
> +		size_t offset, size_t size)
> +{
> +	struct iommu_domain *domain = iommu_get_dma_domain(dev);
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iova_domain *iovad = &cookie->iovad;
> +	dma_addr_t addr = state->addr + offset;
> +	size_t iova_start_pad = iova_offset(iovad, addr);
> +
> +	return iommu_sync_map(domain, addr - iova_start_pad,
> +		      iova_align(iovad, size + iova_start_pad));
> +}


Thanks,
Alok

