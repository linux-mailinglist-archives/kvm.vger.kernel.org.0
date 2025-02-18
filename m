Return-Path: <kvm+bounces-38448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9C5A39E91
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 15:19:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 623CB7A4D7E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 14:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BADF26A0D0;
	Tue, 18 Feb 2025 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kBIJZj/r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sZLB5UsO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8AFF2500CD;
	Tue, 18 Feb 2025 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739888316; cv=fail; b=sNJD0JPDrdOAhbqOW5Ay4O2l3V/YctbIrFygGTwDhY7Y2HqUwchrU1MIKHU2Xs12mPZzAX3RR3TYoIAd0z7rLRUh/jEtKvc5tK+fzNGfa3bXVhAZ4lE/tXIulrKeHZZdlpS1cbU+nuhbvdUTx64NixsupAAzUya5AO7ICwAx+WY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739888316; c=relaxed/simple;
	bh=CW8HCo6D8TJSjrmGPXC7rPtAoNonJ5w6o0B2kFpPrrE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rbXZm6xsSpxORLp1MukKI1Hnm+Um22IIX8Og6FLqzq+z4RRGwT1AENYhAD3LMK9iLhhFc1Y2kdi+vJkkokai1wcJxoA6u6DwN4PMals7m9WDfdiV1QmXgHkj4nraZEgx/3Sl9b0il0naMT/LOOpXTvfRxmPzBEnN3wB0+hccogs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kBIJZj/r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sZLB5UsO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IEHpKw009051;
	Tue, 18 Feb 2025 14:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MRfaKfeufvxkkvqv2d5BGpaRadieW92IjClEVFaoBEY=; b=
	kBIJZj/rhJKfA4ZKGFmMOFPILVJ+tuMYguP8BrVsLi1ehOlBcHSwrBflSjCZSoye
	FjobQKh75mseWs9b05an5NSJ46aiDKU4EH5hkD4bDaJvuX2qEV1RU45zQ+uHLLEN
	TXtkrFtXJ6H60WUoCFnQso5BTm0Ywm2IZBUQ51yQO1RAvhISmtWkelOJ1rDr91r2
	olGvnAvhb2d3GwuykByUEuMWCBMc3Oohw5eA7V3kgyaw1UgaUgptfqnN682PsXg/
	oG1AC+aytFYspMMmXRAwoOH8Ha/wN/dk7Mv3LtAEmapCZx2fa1J6sR+g9wpVkDS+
	IGjZZ1FQPyX0dyTYP5sAOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thq2prb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 14:17:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ICmuBx036727;
	Tue, 18 Feb 2025 14:17:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2047.outbound.protection.outlook.com [104.47.70.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44thc9349v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 14:17:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYz1U77tPRDbVjXjVca23nx5gVd5JxWIlnfbXKKmwMTQkb1gXl2oxo3FNQVF4lbSGoTH8VTx9ZKg7q12/g497spzNcJUCk3wQCRnxXApSOR28lR1uARuqKA2HXkdM+vBItsSw7wS3CEnUgOFD0tyG+mzuofwiLUzPpLNMypAJ48qXd3qOiZ8Cu9I75ufVVO60ldHJWGR/kBww91tGYeZEttTimk+b+E7bJ1DbQHM3hHZttHghhqpIYjz4TmIbZ5ME7LGzJy9Er4CNH1Wp/REEUDjuLHHf1xGWe7ZQ0hV1kcmDSC3ENxACO2CkS9J5/Wt/Wv+PPMjxaZeIZ8oKglxEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRfaKfeufvxkkvqv2d5BGpaRadieW92IjClEVFaoBEY=;
 b=YDRgMRtUXuS/9M5uq2LhdvendzgEHfr9Tqivvfp8Ghlv/VmDGRwEeLtSfcHKO1ow4rtJOb6V9GbFFm4zlQ7ZHX9/7pLV/CIFGUvm9EIh9XXBdWccTjjtmrmZtw8CZHPhHxodh0EtdrbkkWw2yBodVAFzy9b0iruDgumBR2fllc5R4CQa2pytSI7ZsF2Jbf+OWFCh9IctCY0QVeaFFM/AULDCGf9UeC8YhS+J2Lj/5XtTD8oWQwNC9OSh8qWiOD1KaD/4cEVIa3Xjakd9UZJQl2KXebrK3263E0pf6HQ2k+MLHg8qV6ZxrtfLGRNjJrxidDDxoc2hIDaGWmsoxlsOJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRfaKfeufvxkkvqv2d5BGpaRadieW92IjClEVFaoBEY=;
 b=sZLB5UsO/p5Phb+Oz/k/KBFpjEUS3ZLmZq2/Xy7Ctm2P0iNlC3XYwN+4CFZkFv7eyrkU/bWcWoxZ3uRsXwTnpT7kHCUKwlrA/upouSUzBAzuGwLmnwlsofxuxj8holx2N7z/Hhj9lXCv2PSBu+SovJreskTEzEQdrbbCbjL/VOE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MN2PR10MB4175.namprd10.prod.outlook.com (2603:10b6:208:1d9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 14:17:40 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%6]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 14:17:40 +0000
Message-ID: <7b7492c0-a3a7-470b-b7aa-697ac790a94b@oracle.com>
Date: Tue, 18 Feb 2025 09:17:35 -0500
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
 <abc3ae0b-620a-4e4a-8dd8-f8e7d3764b3a@oracle.com>
 <cc6fc730-e5f4-485b-b0b6-ec70374b3ab1@huawei.com>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <cc6fc730-e5f4-485b-b0b6-ec70374b3ab1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::17) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|MN2PR10MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: 657a4f68-d01b-4ae6-85bd-08dd50270086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0pob29vVEFhTjU5YkZXeWFRVGxQZFdrWkpuN1Y0UGZsdG9GRmh0UnRDL1Nw?=
 =?utf-8?B?MFpPbEJhSWo2c2NoK2Uxc2xza3B5bG1WZnV5QVMzeEVQQVlNZVR0c3hYRHhP?=
 =?utf-8?B?V3BuQTB1MjFEUVVzQVBCMlEyTUozMVczVHZpTUV2U3JkUkU3RzNiMUNYS2sy?=
 =?utf-8?B?MER1YWF4TnpTVTYzaGZkb1VvUnRuYjZqWCs0TjM4MGhBNzJXVXVGYVEzdkVF?=
 =?utf-8?B?aTUydUFVclNISjdPNWlHa1B2VnVua1cxakpwSncwUkYxMEZFTUlNNUdOZW9Y?=
 =?utf-8?B?VHRPdkpHN0VHclVoUFIwTlZXSm93VUhieHVkc05ReFc2NWZuVkdJU256RERV?=
 =?utf-8?B?SW42K2Z1dzdaQmlWdVNRRjU1ZlNEUnI0alNqYmZ2TTlzLzBBczh0R09JcXNy?=
 =?utf-8?B?dU81L0h0MlBFWDNhUTRkTHoxSkUvWWhhQlAvSStSeFZKNSsvMk9LRnkzQTdo?=
 =?utf-8?B?eVh5TXNQcWlidlhhR2loOGY1VDNhR2tWb0Z2OW9VWmFmdjE1TG1KUWpVeDk2?=
 =?utf-8?B?M0JOZG9CandOSnJGdVZzbG9YQTVoTmYycnZ0eWNzeUpPd084ZXl0Y2QzNDVa?=
 =?utf-8?B?dWozQ1AxUW01RjlWbzdLZXJmOHh3SkVsU1I1T0EzTWhTY2h6TW1scUtKUlJY?=
 =?utf-8?B?M3pvamFhanNZdDRwVFMrdE42U3YxMkxHTGxMYWJPM1FwVTY0Yk9sajIxVTU3?=
 =?utf-8?B?cVpTd3gvbGw2R0Z4YmEvQ2NKMFNnMjhrYkZUQUFhZkxKeERqR1VEcGp0a2Vz?=
 =?utf-8?B?YlMwTS90bXZHL0RDWGl4Ly8wcWxxY0FwUEdYQUZjQWpZdGhDaEtZTXhuNzZj?=
 =?utf-8?B?RmVMakEwdkZZNEZvMElGZ0w5SmpDdnYwTEFyMHZEMFh4SXBOREdtazBPUjJY?=
 =?utf-8?B?Vjl1Zm9GS2p3RC8rbGNjRkZIL21FY05qV3EySGRiTlFSNHIvZnIvcVJnVFBu?=
 =?utf-8?B?SlYvZ1gzaVlhalUyRkxzM2FyVlNkTEYrQzFKYmJJM2x1TzdBUDl4SXg1NTRV?=
 =?utf-8?B?MU92RFBQUUlOd0FiQzhsVENqTVU2UEI3bnMxNkFlbHhIbjQrWkNUTEpNcXF1?=
 =?utf-8?B?b1EvTkozMWFDN2FTdE9BNWpzbittRlFpYXBaa3h1UjNVZld6bWJqYlpMbWlw?=
 =?utf-8?B?Q01uZEM1a2FSa3ZyMXkvakhjbDhBUWFQNDRzYXhtcnFTR2E5YlFkdENBdThm?=
 =?utf-8?B?Y3p6MkdYSk52eWJybnIrQWoyaDBUN1M2aHlhVmVWN0NieHZOK3crYmJsSXZG?=
 =?utf-8?B?SFZYb3VtQXRtOU9UY05nK1JSRWlDaWVjZE9vWktTaTBRUHhFRnk2a2pvWHg0?=
 =?utf-8?B?aWJNZUhwVEJlYlBJZEpTZ0UyRnB2N2c1ckl2R2FHQ2szcmtRSzBGZEZlc21x?=
 =?utf-8?B?aDE2SlJ5eDV1eXI3OGNKMGZFOVo3NUZrMzJQVDZrc0wzQkprQi9Qd05RejQ3?=
 =?utf-8?B?dU5sVy9mMkxKNzc5V1lFZ1V1bWQ2Tmt3OEF2Tk4zNHBMSUtTTnZEOHVHZjBs?=
 =?utf-8?B?ZTU3UWRub3BPUUNwc0NKNHQrWkM2NTdicVJpSzU0S0JURXFUTmNuZWhTYVk0?=
 =?utf-8?B?TGM2K05xWDBGdkhqNDZzbVlRbG5aS3B3WXJXZ0pRdDRKMHFPSVgxRzhKUklm?=
 =?utf-8?B?S05YbWg2VnJuSHVReVkvTmRsN2tPTVFSQTF2NzVwd3VNNVBIKzFubWF4eFRE?=
 =?utf-8?B?KzVXNGRSYlZXOTRMNkxlYkJnRUZRZDgxWVFweTBteGcxd2lWY0F3bVBCS3p5?=
 =?utf-8?B?ZVdxbzhQM1NXOFlZZVNiUVJiV0xLWVJHYkFIZGVHNVNSMitiQ0xSVFZPeWpJ?=
 =?utf-8?B?K1dLcWRqKy9uZkkwWWdPYmpRS3NGbzR4QTZ1Yk5idWRlcXZvRWt0NWRUdGdU?=
 =?utf-8?B?UW85WUZPemNQcUJnY29OUjB2bzZlTG5zNXBKK0V1Nm50WGZ1bS9yK1NjckZH?=
 =?utf-8?Q?M6IZkcs2BMM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0R1RlYrYW9La3g5MGtEbUpGQnJxYklMV01tbko3Mmtka0h4QlhLQ3JPVlA1?=
 =?utf-8?B?cDg1TndIaXFKUXI1RWYzTW5zaHM5bXp1YjZHRjJNUTduOXJ5Rm1DTlM4Sy8y?=
 =?utf-8?B?c3h4cUNSQ3FkT1YxUEc2Mi9uN3pXQ3ZHeFM3dVdTNTZFeWFaRjZGaGlGbDBJ?=
 =?utf-8?B?U2JaZkRUWG5hS0o2QjQ4TGQxUXQ2NGhZQXhLSlhsQjlKR1FjdTRsbkRSYlJq?=
 =?utf-8?B?bjgwSU10ZXBRZzlaTjhUVHZ6TUowSXVRK3NxZllCako5UEdONUE5VHRkZ1U1?=
 =?utf-8?B?SlJ6K0lRU2R2NjFxeHVwVnpsMEJEbk1LOHBIckF6TUhTMDlaTFJacEh6N1JH?=
 =?utf-8?B?cFdlSXJCWHdlTUVtWVlHUkt3dEtFK1ZlYVdrQ3E0cStWUDRCaURyUzBaa0VK?=
 =?utf-8?B?RzdnWjErcWxqOVBpdit5bEZSN1FER0lFY0gvUEgvVHFXRU9MYllFR25LMitt?=
 =?utf-8?B?ZlNxR0NLMWJwOC90OTUwSzhobFlob3JZSk92OTlteU5oangwRVJ2bVF5KzA1?=
 =?utf-8?B?T3JHTmtmRHNHRFpSUW1hc3JNaXMrYmlBTWtyaTQ3bE1FczVuZGhCYVl0RVZ2?=
 =?utf-8?B?SW4rTTNFZjRjZWZGdXM0cWFDVzBabThsOCtkUktScldlcVMzWlV1akh3Snh1?=
 =?utf-8?B?Q3BzTWY0c2pqNGoyaXU2dTZxb2EyUkJSOE5xOHkyQUluVll1WXFReHphU3Nx?=
 =?utf-8?B?MEREbFRva1BlU2E1cXJ4ZGRQc1paVzBSbGpCTyt3RFlIbTYxMmdVU1FtYVV4?=
 =?utf-8?B?bFF3eCt1ZUVlcDdoc3VKT1ZVb2xpcmx3Rml2T0dIUWRiakpMVHRlTHllUGpn?=
 =?utf-8?B?ZnpYL0ttbXFaaFJ4Tk81Ni9xQmNOQzJyMUY4a1FpY1Y4QVVyYUpONC9lREQ0?=
 =?utf-8?B?VDdCQ1JOVmdOQ1JpbUI2K1JmVTZmOVRzVmxabmtsbjJHYzhTSmw5VjFhTzY1?=
 =?utf-8?B?NGxJbkZKWDFiZndzRktTZGxDRnRNcElKNlFsWncvYzNERjk5NzU4bDVQbSt4?=
 =?utf-8?B?OGNiMXdFVitOSjc0UVViZ042WlZjcHFhandianpGYzNUMlFTaFhyTk5UTGM2?=
 =?utf-8?B?bG9ZTU9ZRThPSlFYbEZBY1EzQzc2aGoxMGxPQWVIaWhoaFg4ekh3d1RwcU9k?=
 =?utf-8?B?RzVqOUhFRmZNVzc4TVFLUjVDZ2pNNCtuUkVkWmJpKzNOTW13dFpyQTJxZHlB?=
 =?utf-8?B?NmZ3cjErT3ZzN0JVampiQXNjMXRHTVdJMXRoVWxZMWxQZGlud3hqZDR1SXp2?=
 =?utf-8?B?OEphU2IwRFdpeHFQNkFJcnZNQ2lHKzA3V3lrclVPc2FMbzZmSWZPZmVyb2lD?=
 =?utf-8?B?OE1vTnJpUzhkOTNrQUxJY05QSkdmVWpPQjdaTGtUT0hnMkg0LytDMkRwRndD?=
 =?utf-8?B?Q0hBeDMycGFDeU5tN3dENFNWYTNCRlZHanRVSVUrR1BFdW9qb1pQV2I5dE5V?=
 =?utf-8?B?eXA4WEJHL2sxZmd1QksvSGNlai9ScGdYMDJtQmNWVk1BRHZQQVlBajJJWG1m?=
 =?utf-8?B?UzhvUGZOa0o5Tnk4Ty92RW1JRCtndnRnWVJnT1pIUzQ2Z0xEWFlvU2MxekZB?=
 =?utf-8?B?aTczVVdnamI5L0FNbzJ0UnBYYVkyN2o0NTFJZm9xWHYzUHQ4QVdoV004cTg3?=
 =?utf-8?B?Si90RytZaFNPbHJFQVRyaGFtcGJsVmtYS21zSE9EZ1BhK3FnVm92UDhzRDZC?=
 =?utf-8?B?Nm1JcEVoMjdPZnl2U0NyMnRlVGJpNjdrTytIREhMQVMvNXZ6SnpialVyU2VR?=
 =?utf-8?B?dVl5MmVvcjdOVE1jUEh4d2RNSjkxL1k3UzdmQWMxY0tKV2poVGFIQWFNV1hu?=
 =?utf-8?B?M0N1dXRTbEM2anVkbXlJOWNoWTNublJ1NW50TUtZd2F3azlXM2J1cnRhakJp?=
 =?utf-8?B?ZXgzZEErak8wS3FXK1ptdFVQUFJ1a2drVjhIZmVVZVpoTlg5YWhXc0kwR2Z4?=
 =?utf-8?B?bzdOTmFMdlBSbWRadFN0M0N5Y3dVbDB1Y3NtclZ0eWJiUFN3bFVDRFNMOCtk?=
 =?utf-8?B?KzVmWU9VWnVsTGFQa0k2czE2Q1RlY0RkYWV4V3htclU5cmozMTV1bExYaUJL?=
 =?utf-8?B?cllCeVluRmVudUV0RzRCWWVHYlAxTjd6NjhsbUdmSXZUZFcrSHc2dG1Hcjlm?=
 =?utf-8?Q?2mlF+MEhNzMiKdTf4lHlktU7J?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zH1rtrLYUO9kfVUlDLACMMIqs7TxmPvWp0y9X82snWEqTTgSSg9Z0mpJwMrbgBE680JUNjLJgJjevu9nE33GEFZeY5ngAWMtbHVetuC7YEPpn3j7ZJSwp6P0p3pfopPcLvm+J3GDG/XDvjfKCqPTwKHZPxKNY8IBPHCRzuF546iipH68Gwr2fR2QigXBJM0CHOOpOTgnRHxZ3wALqgYloFkqUdbXxKh/zP2pzQbQNRgMJB8aUS9PV9thXt/hDsObHPCLBLLOiMv0kN2vt5PK9fRJHDNbrYw4DKnVUdTO2kyswLuZ/9uc+hVVGGOzc/HXBnru7EWsWvIeeQW24Oq/9QhgqSJYQOqM8IhUeEfk8341FCzvebcvkA6nsIfalkNSjctL3si/tzLhtqX0zTTR8q1KYzHbyOF9912Ll97Vo57oNZjnA2ZHdFPix5pUnXvkN3EPb1zRi/fv1P3gGldlGvu/LQntwXWv6+nAvws/KEbgcxf5uc7i4zeRpiAznF681pmtQ7/og/EaJ3hKlnoz7pRZE4g47ahzVaCzVXLJsFlJe46oN07D3juEA/YghLcT+MvWfrbr+vYkvxFgWWuVYVf7n4j96d0uGBiVrEff7Bc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657a4f68-d01b-4ae6-85bd-08dd50270086
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 14:17:40.0840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAjHVCU6oTuoGS8/WcqmWhtj9cXlvIn2MuFVJT4QCQM9ByAXyahiEoADNFKpEjWaa4XCq/7oUev+Fi9iPmpz0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4175
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_07,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502180108
X-Proofpoint-ORIG-GUID: KRjixLD1fAdMJ0NS3dDvWbHrlcF_0kHJ
X-Proofpoint-GUID: KRjixLD1fAdMJ0NS3dDvWbHrlcF_0kHJ

On 2/18/25 4:16 AM, Yunsheng Lin wrote:
> On 2025/2/17 22:20, Chuck Lever wrote:
>> On 2/17/25 7:31 AM, Yunsheng Lin wrote:
>>> As mentioned in [1], it seems odd to check NULL elements in
>>> the middle of page bulk allocating,
>>
>> I think I requested that check to be added to the bulk page allocator.
>>
>> When sending an RPC reply, NFSD might release pages in the middle of
> 
> It seems there is no usage of the page bulk allocation API in fs/nfsd/
> or fs/nfs/, which specific fs the above 'NFSD' is referring to?

NFSD is in fs/nfsd/, and it is the major consumer of
net/sunrpc/svc_xprt.c.


>> the rq_pages array, marking each of those array entries with a NULL
>> pointer. We want to ensure that the array is refilled completely in this
>> case.
>>
> 
> I did some researching, it seems you requested that in [1]?
> It seems the 'holes are always at the start' for the case in that
> discussion too, I am not sure if the case is referring to the caller
> in net/sunrpc/svc_xprt.c? If yes, it seems caller can do a better
> job of bulk allocating pages into a whole array sequentially without
> checking NULL elements first before doing the page bulk allocation
> as something below:
> 
> +++ b/net/sunrpc/svc_xprt.c
> @@ -663,9 +663,10 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>                 pages = RPCSVC_MAXPAGES;
>         }
> 
> -       for (filled = 0; filled < pages; filled = ret) {
> -               ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
> -               if (ret > filled)
> +       for (filled = 0; filled < pages; filled += ret) {
> +               ret = alloc_pages_bulk(GFP_KERNEL, pages - filled,
> +                                      rqstp->rq_pages + filled);
> +               if (ret)
>                         /* Made progress, don't sleep yet */
>                         continue;
> 
> @@ -674,7 +675,7 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>                         set_current_state(TASK_RUNNING);
>                         return false;
>                 }
> -               trace_svc_alloc_arg_err(pages, ret);
> +               trace_svc_alloc_arg_err(pages, filled);
>                 memalloc_retry_wait(GFP_KERNEL);
>         }
>         rqstp->rq_page_end = &rqstp->rq_pages[pages];
> 
> 
> 1. https://lkml.iu.edu/hypermail/linux/kernel/2103.2/09060.html

I still don't see what is broken about the current API.

Anyway, any changes in svc_alloc_arg() will need to be run through the
upstream NFSD CI suite before they are merged.


-- 
Chuck Lever

