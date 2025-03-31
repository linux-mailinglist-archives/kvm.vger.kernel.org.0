Return-Path: <kvm+bounces-42253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE701A7693A
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 17:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 820D63B266A
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 14:57:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8CA2222C3;
	Mon, 31 Mar 2025 14:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ioluxlMX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Z8lyc1IU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21495221F34;
	Mon, 31 Mar 2025 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743432456; cv=fail; b=tZENYW3FIrgTrbUofETTFjVx4va5b1ifI26itFwsLd154h10UyO0XYhJ/hdhqcwJrVAQwwMQ54cdaHDrZP0CYfyuXmFY/iamOQtzowLGVTaWiyWwcT+ZuXfn0m/f3ta0xjnCwQDVE2f6nydO5N806+mtAJ7EAW+dZ8d+BpG/Mno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743432456; c=relaxed/simple;
	bh=I5vHQgylo36qzP9oVUs2lHtV/++sS3HHqwWnHurqhDg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fP3+NtS2TCQtFzF4vD088Wwh9BLyWmjHx/ychxMJaQHJ/ostBA9W/BMpHxJtpriCN2I3cEjEWzNPZvIPUJ2ZbxXzNk5a9oycvY+0exzn8DwOlMXJ2x8kyxI4IDOlu+EvZUifgA8LJBXX6+Du++mSsIXLxmwH6pQFxqx5xNDQW2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ioluxlMX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Z8lyc1IU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52VEC5QT009874;
	Mon, 31 Mar 2025 14:46:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9kLGlLeMnTy0eNJ88C/BQxlewz+G9mEd5GCHpgmV2Wo=; b=
	ioluxlMX5mwVcDBSVadViUODHA/eI8ppuLLdssXgXfx/2bdj3wt37e0WjQCXsSrY
	Zc85V9EElz1yYX9qDwYYbHBL3drR/j/ysijM2XlwwZdoSllG4mn92FPB0pZR6zge
	iNxWSc8VQBtmV1D0uzUon6IeVpz37iGJnsfa7DWcF6MHhaFYZSGkMrdVPauBZmqw
	MRajUGpXMoQ6CwG3uqny5R+ObmwNJI3/mHKFpEX37w2VrQHQQVSjVy027likJvr1
	WO1TYN6/+vS1407tuq6d/EuziXfqu9pu/WhmHsIjWMuyqYpjocJ7obIB9xZQMPSU
	Ipvqoha3MbPxkZE392cnPA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0bd3f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 14:46:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52VDHnEg013590;
	Mon, 31 Mar 2025 14:46:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2044.outbound.protection.outlook.com [104.47.58.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7ae0jvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 14:46:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E0Ytbhf692un1nzT5JfNSEEYh7Ru+Th8c5rlIfXFJEDULBb52wQsy7V7mKR2NOuR0vCysNIxmjfX1hDOmtyBJYaCvaIljsj+u9L40q/8bsmSE4s4hQKT609xf1Bk0ov6BG59Ly/t/9bCOTQlG0VgvfsPyHP5Zjfe+Qr/IksbDwgQZ76pJeCABb7J96ogi6WLgjOllCLSu6jXbvljQiz+MFOf/sU8gIgh1kAVKM1XdmxGD2alhZ+HBT8X63y/LxdJiho0DhvmsfD+JaDcaTmrc07eI6UUVsV288+MBLNYD17SOFZqFTFpziHh0YplpqeAQjMFYZ5HlbfuikFwzNae6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kLGlLeMnTy0eNJ88C/BQxlewz+G9mEd5GCHpgmV2Wo=;
 b=KYe3J3MZczWiPlP7vabnZPhCCivVk2P8+XrZymY73js95qicPHZU2gefXuvv/VHrTuqkHIU9z69vRATrAx1bxL+oT9CWk/aMCqoQzo1ZDzm55hk/OEKlngQ2d7dBaWS4B0xRIGIr760l6jRVyml2qdpKgC/qHe+G7hlX5kN70Zvu5VLUjGKREQeu+m+ln4+t92iRdeoD9q31C16oLk5i1ksNLNAS6puy0wYQ1XS280LGmSs6HrMqYDoqGo4wXmXYMoSmCau4pJtQ8EyZ9FT7RVcZ1xvxn3VfuFHD9JPRWMXJw/H3cUF5tFHxgVgj/zp+aeR7tQkYJnq4GiFcX8L5SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kLGlLeMnTy0eNJ88C/BQxlewz+G9mEd5GCHpgmV2Wo=;
 b=Z8lyc1IU3FPQd9Jpq7fjFnEhc019kycGrZYGBrXOs+BJAWQs6mOzh8ODZjmRoASBjiQCbWcsFTFG1XJ8YEMzkT0WCqlaKzgZnukOdBJGyZ76cgvmqYho5Vui9xaiBLPvnhQyyiUm1wGhYv0rB5BfjPBVT3D7q6Nn0mJoW1gQRco=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH4PR10MB8171.namprd10.prod.outlook.com (2603:10b6:610:242::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.27; Mon, 31 Mar
 2025 14:46:38 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%5]) with mapi id 15.20.8583.038; Mon, 31 Mar 2025
 14:46:38 +0000
Message-ID: <913df4b4-fc4a-409d-9007-088a3e2c8291@oracle.com>
Date: Mon, 31 Mar 2025 10:46:40 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/17] Provide a new two step DMA mapping API
To: Jason Gunthorpe <jgg@ziepe.ca>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leon@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@infradead.org>
References: <cover.1738765879.git.leonro@nvidia.com>
 <20250220124827.GR53094@unreal>
 <CGME20250228195423eucas1p221736d964e9aeb1b055d3ee93a4d2648@eucas1p2.samsung.com>
 <1166a5f5-23cc-4cce-ba40-5e10ad2606de@arm.com>
 <d408b1c7-eabf-4a1e-861c-b2ddf8bf9f0e@samsung.com>
 <20250312193249.GI1322339@unreal>
 <adb63b87-d8f2-4ae6-90c4-125bde41dc29@samsung.com>
 <20250319175840.GG10600@ziepe.ca>
 <1034b694-2b25-4649-a004-19e601061b90@samsung.com>
 <20250322004130.GS126678@ziepe.ca>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20250322004130.GS126678@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::18) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|CH4PR10MB8171:EE_
X-MS-Office365-Filtering-Correlation-Id: 26303b5d-a97a-4c24-724e-08dd7062d750
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aW10QXpOSjZrSnJLWnVsQXhqbDNpdlJqSVYxVVNQZUJuVVprMDkyeTUvUnEw?=
 =?utf-8?B?YkwwVmllNlE2akhvTDBWZ2NuLzIzVXBySHdEaXkvd0tic2haU2ZqSW5JMFhJ?=
 =?utf-8?B?VTB4RTRoTHRyejJVdGlaRmhiUWpnRGRaTXBzWWtPcmduUTNVR0NCVlNCZmFN?=
 =?utf-8?B?THFlcGk1OGpZQVA0R1d0Z080dndjdG9XbitvSmhjRWluSU5FWmx1bkZzWmQx?=
 =?utf-8?B?SlJpWHhTNXFlTytnOFhaV1I0dGFjTEFvckJ4K2ExYTZqRUgxeThmOFdsQ015?=
 =?utf-8?B?cEJjcHVuSENhendTSGwwcDNQMTNTUUpEUThWbmtuVEZwUUFGWEpEaEZaWXMz?=
 =?utf-8?B?ckFuRmplYmt5L3BMOWRDdXIzQmxieG80eDRuOG05aHBHT2RYZ3pUY3U3R1A0?=
 =?utf-8?B?WjZrb0JDOW5VelJnY2lJMTFIZEtpaHhMRjE3a0Z1Q0dzbjBWeUp5dVJ3djY0?=
 =?utf-8?B?bWg5UDMxN1FhL1laT1Fjc0lMbGxMNWdGalhFS3prSEIrS01tYmJzaHEyNkY2?=
 =?utf-8?B?VzNwT292Q2ZIUHpXbVBZbVJCL1c3d2EwZ3k3ZG95bnk5OEY0cmd5aGFzSmFN?=
 =?utf-8?B?UGt5ZUZYbmVPakFtSm5FckZ6cXJJajVPY0k4ZXEvOUYxVEllT3JxdEtCd0Fw?=
 =?utf-8?B?bkdmRVNCa0g4cjIzWFlIeXRFNVFzTmJCQTY4UTROZXlQK21NYVc4R0s1TU4x?=
 =?utf-8?B?S1RMellrbmZsejlMSUlybnZ0d0ZtckFKajFWK3Y3cDJ6YWVTai91MWE5VXZX?=
 =?utf-8?B?V2E3RTMvc0NGblp3ZFIwYklNYmoyRVBRQk9iUUYzUHZEVXZzcW50SFZ0SU5W?=
 =?utf-8?B?ZjRiT0Z5VlVXWGgwa09zZUxQcUFkaHpZS2FWRG1mN1ArNm5ERERCTU1GMlhu?=
 =?utf-8?B?S00ycmtmdG9Bb3VrYWJ4ZGFPalU5T0NodWcyb1QzTWZpa2IwbHJaaVZ3dVVm?=
 =?utf-8?B?cnlOV3J6UDFJL0hWNzN1cFpFeVJ5ZjJGRG9acnRic1VvdWM5aDRWSmMvL0d3?=
 =?utf-8?B?QjNDQ0M2dmhBaUZya2ZTdlBVbHcvT2laQkhyS0N4RWZXOTFyUUJ1LzNMSkRR?=
 =?utf-8?B?Q3ZGem8zeEtkOThnc2JIYms5aVZ0eXpNOXoyV2VNN0picHEvWks3cmdvNmNE?=
 =?utf-8?B?R3JvSmRwVFI3c1d2bEdQajhURDNRYVBYb2hKcjBTWURHNHBnZ3FHTkttRE9j?=
 =?utf-8?B?cmFsU1hUTzR5Y1JHcjZuZkt0L2hVMjd2aEFYbEV2dzVWSDhnZ3owRVQ0WW5K?=
 =?utf-8?B?bEhITGdtVzF3M2RpL3c4NG50UnB2Vklwc3RqbkpublJZd2dsdDVLS0JFZHNx?=
 =?utf-8?B?U1M0ZEJRMTg1bVVrUGFwQnpSdUx2SGVmSmJ1QnpacmViUGh2MThZSDNLKy83?=
 =?utf-8?B?VmFRSk8yT2dxeGE3RjNMblFDMzVuV2xuZEZKV0hCVzk2UWVFRERaaVhBaUt3?=
 =?utf-8?B?dEdwUE1Eb3dVZ2JhTEZoejYwOUx3YjNtSFR6NmRLVCtoT0Q1L25OUTlnZ05t?=
 =?utf-8?B?ckN6V2Zrd29ncFgyNU9YT2xSbHN3UHlkbG5tU0Zxd0JUdERNcks3akVCL3Rw?=
 =?utf-8?B?djBUY2JZU01SODVKbDU4YVY0QjAwb29Nc2FzWjA3WHBmTHdYa0dUWkJWL0lB?=
 =?utf-8?B?bVl6Kzk0SEQ2UldFSjlBZ0lRNjZWNm1ieXdWN3dVUVIwbEZ4Vm9kbllmWjFO?=
 =?utf-8?B?RnJyc0M2TzkzQnRIMGhSbVVOd3ZaZ09OTlo4Z0FzV1RBTnMxcXdsaFdaeEpZ?=
 =?utf-8?B?bjQzVUpqc3VLR0JKMkJHRW5EWW5ldmlRakg2enozMTBIb1dwajhTSVpYM21X?=
 =?utf-8?B?UnJvUFB0WndERWtKK0Z1QWNERk9YSmV5VW12WTQxU3VlTFR0bXU3TVNpQ2Rn?=
 =?utf-8?Q?yWWTSYzsztBZt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QksyTkk1U2ZRaEZ0ZVZ4RGs5Z1F1eDJtYWphL0lnYW1vM3RBZWR0Y2lDMmxT?=
 =?utf-8?B?cGIzbkNZSXNET3RDamY3WWlUV1RmMTRBY0diSDdRVmg2aU1pTk5tVG9QdnJz?=
 =?utf-8?B?RXl3Mld0cUo2OGJjMjBzOC9OeFFmMGl4VUwxalROZHNCNXdQRDBQTFNvbWpE?=
 =?utf-8?B?UkdEUW93S1dCT2ZyODRHYyt1QmVsZ1M3YzB5TXVTVCt1SzZNVTVrZklXYWI1?=
 =?utf-8?B?ak5takJUeVR2Qm9HcS9CN0JBeXFoOUtELzZBRC9tKzc0VXNabXNmQkorTldJ?=
 =?utf-8?B?Skx2YnFWSUpQQkNXdWgxNU9Jc1ZVVkppSWdaeFNCWnBhbzhnWUtPNGF6WDZz?=
 =?utf-8?B?dzJOa2lLd0N4MkdZOEh2amFLZzhiTWh0RzJHVi9QUU16Vk9xNlBlN3Fxdk9S?=
 =?utf-8?B?U1FUS3pEbjJjQTRwYWxIZXp3TTZwYmVWaFJTZ1hxb2ViNmhDd0lwaFBKa2ow?=
 =?utf-8?B?MmE3NC9hTXRoMllBcDArYW9pRmFvb3VjR01xeU84YWNMWUUzTENRSHdxRlhF?=
 =?utf-8?B?ZjZvNVgwVnU2Ri9ZdE5tV2NPblRWY2hWeUU2ZE5LeU9Mc1QwbU12c2g0VlVW?=
 =?utf-8?B?dnNJamt6NmpjVThDZ0NBS1AwMGpzcHAvb0tqR3NvNktLTmFxWWhna1FnU2Zo?=
 =?utf-8?B?anpRMzdlQ0NLbmtVeEw1T1VGY3Rqand4V1pPYkxFOFo5elhpbzR0V2RQUDdt?=
 =?utf-8?B?NjJMdGlrU1pFZjlLd1Q3SkEwdnpmYkFRVlVGVzBFYkIyQVNLMEVwdkpsdDIy?=
 =?utf-8?B?Qk0xclVjaHlJM3daM1dUWHhJa1lKMzN0cWQ0Qkg1bytvMENoM29XUVBab2Ry?=
 =?utf-8?B?RTJIMHpxeURwam9ON1VmTVMvR0ZqQXdiWVdoS1hpc0R1eUNzNVV5QnlDVEda?=
 =?utf-8?B?Y2Nici93YUNqWGZLamJacW94dFNWRXRKbG5ZMjVTbVlxZExjektVZi9DS1pQ?=
 =?utf-8?B?aWVPWlZLN0l0cUlRZ1F3eGhEM0JveTllc2hFcVJjK2NRbm1vYmtWUFp0VXVE?=
 =?utf-8?B?VzFHbE5ISENJUy9UcDA4OUVwZVNYbVg5OGdGMmNVSUdUbmYwcEIydzhESGtF?=
 =?utf-8?B?dFRRU3RUVmFsYVE0MjBxNVJLNElvaXp2TFJ6bWVmeU1hNTBsY0Fhak5oQnYz?=
 =?utf-8?B?NUk0cm1RU0tOcXI0aHg5cGZLMjBOb0o0MlNqQTBJazlBelNNOU0vK0hpWW05?=
 =?utf-8?B?OUtPMFBIS0ovbjQ0eG5NaGhlcjNoTFdpbGhrcW1EeDhkNFdzNWJ1QnRsVG9B?=
 =?utf-8?B?RERhRUNaZm0vbG5vTlJpWU55aVBBU0JXVDEyUXh1ZFhNRjRENU9naWViZzNB?=
 =?utf-8?B?TzFybU4wY3RTY0NuNmo0WVJ2RXQrN1RUNHdmdDNRRFpuTXQ1VFZwaVdiZ0R3?=
 =?utf-8?B?TVFVQ1lxVEltS1lVN1h0Y2Q5UjF0V1pPUVNlTjVzOFRxS3phbzdGNEFZYmI1?=
 =?utf-8?B?YXVUNFp5dW5SK0hrWTdrLzB6R1ExeVA4MHVjME1Eb2NDa2ZJdFdNUXlnemxk?=
 =?utf-8?B?Qi9zd2VUVU84eXBERmExSWpNWXdxUHBGUFpGeHZ3UWM5b3doQUlHRnhwZ2ND?=
 =?utf-8?B?S0k4d2RVbHlYRWEyTnN3TklJZjZSQlpiNkRDRVhTVk5uNFdia1NXTWV4SFF0?=
 =?utf-8?B?eGxScDIxcjVzSXd1MkJOMEdyTzA0QjgrQXd5dThKbHBVbDBpL0lwVEZZYm1X?=
 =?utf-8?B?RW9vSzlkNWtXemtIVHlMdVhQS3BBV0FGakppWHlpdlhBMXFIM3YrQU5iNU8y?=
 =?utf-8?B?bnhEM3MzVndKOGZoVWE3SDdINUtyd0g1bStScXZKdzU4b0lQZmxIYmlGZi9m?=
 =?utf-8?B?UWF0UVRTK1NaVlFxUDYzM3JHQ2wyK3ZmWU93VGxTempOb1RkLzFHSWRHQ3NK?=
 =?utf-8?B?YnhNK1N1OWxOczJDZXhoUHp2NjBoRnhtNEw5YnZHdVFteHN1d0NvYU02WTdW?=
 =?utf-8?B?VTFaNm1QRkJWRW5wOE5uRzJNQm9Bd0pRTHhZT3dQdEJRR3NHN0dEL2RPa0I2?=
 =?utf-8?B?Z2xldGh4T2xxRDdsVkMrQzlaZTN6Nkl2YWM1NXpvT28waWJOWFZML0U2WVln?=
 =?utf-8?B?alhUc0JjM0hodjRYUndNTmM5YTZlbjRqdzVFdzBWaXhkMm9zc1BLSFAxTE9B?=
 =?utf-8?Q?wnEYjNjQbzq11HU6ntmZj2WyA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JDlzbqO8TZyX7xPc2N+VWhoT9y1TPhE84fis4KNGOppfVqdryUPW2A++3Nzd+RFU5ngKGD7+eUaArPjZwzCkZSOucSCbSQMQ9Kkx+7t7wBh6Hg24g4kPgT+p1GdhV2aajGcLXcoxaG6WlYzPoIEGWW6fSm2Q+/mbQgFLe6x7mG0mXBmcqWMuoLEm6s330jhUOgGMgP+jwfi9IRgywVfkfXveoAy0caYF/SSBv7eA4m6lh00ZAIDBfSctj/7LMmgp9HutV6G81HQYHgLgcTW6d/WxfILMlHqAoZ0ZVnmZc1yJVYmItgB8wTzYG/lT8ETonbB8uq/IpBQNF2FOenZ4k/dTQ2Zt4noVmtIh1MH3EzNt9rT3yi1pvIp9/72ZvRn/jutqOC1mID8bXdVIpyf6SgCzixd60GnbDnsadgLsX/VpAXos+FbBBpXm0VU+7y0cueD8ETPLHyED9o2MJYRdkXbxf3GAnz4iUFmvLx7rfAnC0foVoFEXl+UfBUWg6YDn4m73CZW4qoR1TCujq7UNq3i7JS6hvMln+TKyXIUAA+0ZCnRaic9HSmeXa2kt108Pek6SGxFM4bGIt7Z46wT51/mcD64SxRkg4QQfxk/+dos=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26303b5d-a97a-4c24-724e-08dd7062d750
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 14:46:37.9577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aYxdBOCjQOt49vwHm2MIEBBE6Q/ZWbcAyLkVCi98Eq2+dVymVgGMuuBkCq93n3dgPXZEEvMzUoc4i4D97AxiiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8171
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-31_06,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503310105
X-Proofpoint-ORIG-GUID: lrr1wmFrfmIL4uYN3yPa7RRZCKRRcimE
X-Proofpoint-GUID: lrr1wmFrfmIL4uYN3yPa7RRZCKRRcimE

On 3/21/25 8:41 PM, Jason Gunthorpe wrote:
> On Fri, Mar 21, 2025 at 12:52:30AM +0100, Marek Szyprowski wrote:
>>> Christoph's vision was to make a performance DMA API path that could
>>> be used to implement any scatterlist-like data structure very
>>> efficiently without having to teach the DMA API about all sorts of
>>> scatterlist-like things.
>>
>> Thanks for explaining one more motivation behind this patchset!
> 
> Sure, no problem.
> 
> To close the loop on the bigger picture here..
> 
> When you put the parts together:
> 
>  1) dma_map_sg is the only API that is both performant and fully
>     functional
> 
>  2) scatterlist is a horrible leaky design and badly misued all over
>     the place. When Logan added SG_DMA_BUS_ADDRESS it became quite
>     clear that any significant changes to scatterlist are infeasible,
>     or at least we'd break a huge number of untestable legacy drivers
>     in the process.
> 
>  3) We really want to do full featured performance DMA *without* a
>     struct page. This requires changing scatterlist, inventing a new
>     scatterlist v2 and DMA map for it, or this idea here of a flexible
>     lower level DMA API entry point.
> 
>     Matthew has been talking about struct-pageless for a long time now
>     from the block/mm direction using folio & memdesc and this is
>     meeting his work from the other end of the stack by starting to
>     build a way to do DMA on future struct pageless things. This is 
>     going to be huge multi-year project but small parts like this need
>     to be solved and agreed to make progress.
> 
>  4) In the immediate moment we still have problems in VFIO, RDMA, and
>     DRM managing P2P transfers because dma_map_resource/page() don't
>     properly work, and we don't have struct pages to use
>     dma_map_sg(). Hacks around the DMA API have been in the kernel for
>     a long time now, we want to see a properly architected solution.

The in-kernel NFS stack, for example, already has a mechanism for
receiving and sending RPC messages using arrays of bio_vecs. The stack
can use bio_vecs natively for communicating with both the page cache and
the kernel socket API.

But NFS's RPC/RDMA transport still has to convert these pages into a
scatterlist so that they can be mapped and then handed to the RDMA core.
Instead, having a DMA mapping API that can take an array of bio_vecs
directly (and then, a similar API within the RDMA core) would make
NFS/RDMA a lot more CPU-efficient.

The lack of a bio_vec DMA mapping API has held up a full conversion of
the in-kernel NFS stack to use folios. That's the reason I tried my
own hand at adding a bio_vec DMA mapping API last summer.

Leon and Christoph have provided a clean step in the right direction
and it looks to me like they have thought carefully about next steps.
Robin pointed out some areas that might be lacking in v7, but IMHO
there is a plan to address many of these areas in subsequent work. I
don't see a reason not to proceed with this first step.


-- 
Chuck Lever

