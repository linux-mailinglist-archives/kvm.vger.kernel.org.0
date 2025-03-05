Return-Path: <kvm+bounces-40183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 07701A50E31
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 22:54:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3513C188BC77
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 21:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB28F26560B;
	Wed,  5 Mar 2025 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b3c9s1NC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jIOpYmiR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC5125DD11
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 21:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741211660; cv=fail; b=ELT4aiec3/BMHDR6qxUVlkY2apcBzmJnmzGDGyzNomI7B9K/+WigUDU3pPtjCgenCU1oQdmv/YrEcoZxc0bSJjTZUf7oD/nsyqRbwuCeIt3HWJpwmFtkK7PrRD2fH+KNjkiAVzNYUR37ZJ0ir6fAmQ2uOEEqW8AkQh5tfpmZYxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741211660; c=relaxed/simple;
	bh=95b3xEm1EePQdBycBlgsQm3TYasjPBWwc2WDEc1WY4M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=N3I4ka69Aj6Q5g1pdxqase19qB11hN8C6XEXPKFRrxSl90pMjfd+ztNABuiofyUQwmPawDkzCS53xldc8hHkVoBp0Jgh9UDckA8kzD60GFYUpecI/CpvkD1brPofVxVGI0vUkGVx3VmI2fm0jY/99fwdJFVnOeLDHXFJbRid1zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b3c9s1NC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jIOpYmiR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 525LBmr9032072;
	Wed, 5 Mar 2025 21:53:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=uhlWlJLKZcWQhplQWWMETXjZmn53s9GXxxLBPgtFSJo=; b=
	b3c9s1NCsq+wxQSLKerwIVcH2S9ivJs7xRFKRxXpO/XOL4fRv3k0kmMU+GUxJyH2
	wnKfmCpn4WSUHUbau3ABq3A0/JmM5v2Xh7l/YO3yo55dhXSUq0wZhADtoCj7mlUy
	pEmghWCSE2Vnkr+PyR/9jX+CP1lsW6v9NeBPKJ1OMLOM6J7/9QxjVMel/OZyZmmc
	SJjM4y+It+jtcOZZw0JpjS24QbQz0USGjhQmWxTbtBXSGk5TgddKwHFLfE1SU/o4
	K9P8gKPrHMSBto4yYQo2oeXVgJXnEnHUyFPahSDtMucS+fiWMHcXNhNGAbJZpo7u
	bBA2go/24y/45mnCBq/Gag==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u820wjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 21:53:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 525KfFii040345;
	Wed, 5 Mar 2025 21:53:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rphb6yt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 21:53:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SUGbE/wR/a/3vdiT4TKU7ZkAr82jTkyUoSFI8E9OZyW5cWnKQZ3tT1yEdjBnyujiKfb0n+RRyYOief5jVq+l97EMCB8IpDYvtfLi7gR1cImp4XHTdsCf3Pc4LWfUwWk7fJZ1n3GOprU71dLFhBYDxTi85/szF6XqDH0E5fb00C1iSiqjIFEGv4UqWdVEJlQoA+B0UVysdC7mUUX+avTuSmfICxvjIQuGTFh7CcKumIga/LwRbXIFFjbfBiQLiiPHXoTrsHAnuxPKTa06CDBpBWqdqd7vxkSNSThSxIjPjK8RqvXtIJe7mG4M2OqUMAKAVd9d0MqztQok2XBMhtXmFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhlWlJLKZcWQhplQWWMETXjZmn53s9GXxxLBPgtFSJo=;
 b=G2USF+Htr/vC3bF/tVs5fCLz34t1avAkqk5J63j6BFMOc7ziVOp5uIszgxPKIcuJ6GmadzAJSBr2+62Y1ITuyDyZjYeW6bj15COvN/t4nQsYfZhnk1nbdfszGN6bZLfYF8Kg+yyhY2xmSKMJP93Jqv5OPHSZSTQC+Ge91ZhG8WsK0HCgwZILRqti3ESvEEWxXWpUOZhpR2oK8jhk8WJCa0kIckW0GodJyzCOOrDP3P8kiCwb2r5jcj5+qR15splOeYAjoX2ynXHzP+1vq67xf27P5ydurKDLpVOFtZhlhu12sI4F7XX9eS96uknD69/l5gWh8RR4N3fGu9FAeo/JZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhlWlJLKZcWQhplQWWMETXjZmn53s9GXxxLBPgtFSJo=;
 b=jIOpYmiRFK9jE2zD+uFs9GD3rWpt2YBkUt1J9AJoFa0bDz7YZjF0p4x5BhEUsKTe0QTHPKinM58AkBoRJfvIiwE7VvP8bd6Qgm+qcb1npicJ9qqN4sLVrb3xqI8gBI/rEY9l75KMfhBiSEomYSE7CADtVZNzw6hhCPRO9G35ftw=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by DM3PR10MB7947.namprd10.prod.outlook.com
 (2603:10b6:0:40::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Wed, 5 Mar
 2025 21:53:48 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 21:53:48 +0000
Message-ID: <acef41fc-9eb1-4df7-b7b6-61995a76fcc4@oracle.com>
Date: Wed, 5 Mar 2025 13:53:45 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] [DO NOT MERGE] kvm: Introduce
 kvm_arch_pre_create_vcpu()
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-4-dongli.zhang@oracle.com> <Z8hjy/8OBTXEA1kp@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <Z8hjy/8OBTXEA1kp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|DM3PR10MB7947:EE_
X-MS-Office365-Filtering-Correlation-Id: 888ec9be-3ac0-46bc-9c55-08dd5c303541
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWMyaUgweG0wejlOeVdQNmVLbGwyS1hrVVlXRS8yVWg1OFd2akZGUythR1d3?=
 =?utf-8?B?WkJPTE9BWkFoTGRBc2s1aFV3eFFTYTNEaG1sdDFSSXBPcVpkcS82eVBDakR0?=
 =?utf-8?B?WG1Rb0tMSHpTcW50Sm13OXBZcEJvL3cvSG44dTFVSlhybVY2TnNPRzdKeitz?=
 =?utf-8?B?bkVWRUtyRHd5VmZSbHBidUU0M3lFS1lBMjBxN3Y0WWF3NHF2NWhUMFY3cGdq?=
 =?utf-8?B?YmxYQk1vNW9NZVNOZ2ZxS3c0L0JOdkxnTDBKZExGTnFFV1lFQng2ekV3TzZC?=
 =?utf-8?B?d29lcDk2ZmhJOG9odjVCVTJ4cmZJYTRmNHRqWjBRK0pNZDRBWDNFSnlWQXNv?=
 =?utf-8?B?ZlZ5bHc3MHgzandFN1hFR20vRURTd0ZSbXFwMUVFaVozNGQwNnBZYkVhQnJp?=
 =?utf-8?B?Skg3cSszN1VXWXNlMlZBZEdyVzlSb2ppWlFWU3NGMTlpTWUrdUlnMzdmVWpQ?=
 =?utf-8?B?R1JlSGs4S0t2eWd3N1BRTmJHSGh4anZTQlhZZUNmQ0s1ZG9PUkZIUCtpRXNI?=
 =?utf-8?B?MWE4WGY4anpBV1JMbjcwVUt4M0o2NDRtWmdobFR4bGNyeHlZWWg1cHdDNW9q?=
 =?utf-8?B?OUl3bmt6QXBub3cvVU5TRzQzR1dMUjNibVBDWEJnOWtNSzVqUGU5dVFzQ2Nr?=
 =?utf-8?B?V2E2U0h6MzJ3dmdCaE9QMkx1TkwzeGhRanNDVXRFS0pGd1JCRnlXYTB5TUxI?=
 =?utf-8?B?TUc4bWFyZDMxaVV4YWkwcThNNU8wbEk1UjVkWUxnVFBHTGlTR0JKdktQb0wv?=
 =?utf-8?B?aUh3REZCbHFXNEh3aUVtekVrRmxXZHRGZHNtS1dISEM2OFZBV3dsTVRLejVa?=
 =?utf-8?B?Q0I0RXJQWVliRFFZNzBVM2FJQnZ0YkVtTFZMaDRLT1E2NUF3TzNjbXpXQlhL?=
 =?utf-8?B?RDZTb1g0d2FYVlhMbHErZ3l0VGxJSEh1WFY1Nis5U1Y1YlJIWG81UmgzMHlR?=
 =?utf-8?B?a0RIMVF1QTZGNWNPcGZWUG1PU2xIN2JVT0FJMXRSUXlUZXB3a0hoeUlPL1Vv?=
 =?utf-8?B?QWM0RGl1V0RIS3NJNHBWZDdBZDh1QW5xMkhLTEREUUEzanMvUVpuMFJ1a1dt?=
 =?utf-8?B?YUcvMCtydUdyTDlrNHpzSU5PTTVBSmdZdEhvdXl4eE10M09tdGl2SzRGWDJq?=
 =?utf-8?B?RWQrWk9tRWlQWGZZWmJMRDFZN3lLaTBqOXBkS2duYWxVK0E5T1pMbUEwYXN6?=
 =?utf-8?B?STdnTDc2a3ZkVmx4bGh6emxabjJEUmJPdk1rdjM1ZnowcHN2bm9OL09GZlg4?=
 =?utf-8?B?TFQ1aXV0VlJyTUlMTG14MVU4aXhrZjFIM3FBaFp1cThsdEtETFZOdkFmT2xN?=
 =?utf-8?B?Q29CUXBqbk9jYWlPOU1tL1VkVGRqeXZrbTBjSEJOZ2piMm1aY3MwanZjWE9M?=
 =?utf-8?B?M1dQRWdyWnVjNFpaZE51TTBxdzE5TWtPZGVYUjlybjBrMTJjNWFPQWxRZm1N?=
 =?utf-8?B?RExvT2VRei9Zdmc5NkNaQzJXSlVCY0ZnemZQSENLUE8zTDNWcjkwa2JNSkNi?=
 =?utf-8?B?b2M2Y1BIbjBrdVlvekhnWDUvbFBob2pnczRVcnA5bUZlbXhpem9SME9jREk2?=
 =?utf-8?B?ckVYWWYxYVpYYWpsY0VZQVBnaHNEWG5Ray9zNTd5S0s2eng3SHBrYmdSQ2pr?=
 =?utf-8?B?YXlWdVpkVEd0WlloNkl0NTJvQ0cxak9kNUpkYlR2bHh1VTFaMWJkUWZRTUZO?=
 =?utf-8?B?OTZjeHFKU3hic3cwSmpWdVpWdFBUdkhvUnV3OVZRZlVENXRPTExXQU45M3g5?=
 =?utf-8?B?K0tnbk1DZXI0RG9GT0JBMWJuMkxOb0k1VVNCdkxzV2lMdUI5ZExOWHF6SGV6?=
 =?utf-8?B?RFlyVHlBbTd4NysrbnBEWmVINmlZVnNseFd3L2Y0US9saXFQRlZKakZpQWpL?=
 =?utf-8?B?MEhCcDdZZU05TDBoQWU4bFZKK29JRmtMNkJ1RXZxL0Y3Y0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmpySHFSUU41eHBvSWdIRU5XSitacmIvd0l1K05LQ1ZnNWEvYjRVQmRINTR2?=
 =?utf-8?B?aHdqOVFpa3BMODNWVG95ejJtdWoxS3BzZUFSQndJRWNwYzFMSXNJMVZ1T0VW?=
 =?utf-8?B?b080WnJVRXFBQ21qOURrRWlBSWljRzBLK1VpSG80Z2Fnc0pBU25YdFhCbDl0?=
 =?utf-8?B?czV3aDVoVm9QbXVZMkJZQlBqbUJtMURNRFltTkR4V3oyVXBtK1IybHp0S1Nz?=
 =?utf-8?B?NUNON1FaaXk0V29CbDNiWUFhWUJnSlFaVVpGN1d1RldrQTJjeTN3OEVXMlVL?=
 =?utf-8?B?d3NtUkpvSUNKVDBLS2VQNVU0QVdJNE5OUzBITXIrK3NNUG1HQlVRUHhCYVhN?=
 =?utf-8?B?ZXdrUlRrdTk1UW90UlRUZ0VUd1ZEa1lWM3VSRW9TNU9CS004R0dKTnBxUnBG?=
 =?utf-8?B?K2dteitMcUpBMkFXd0l3ZVYvKzZxMUliRkVWZ2hOOHdJTkNRQTc5MnFpai9R?=
 =?utf-8?B?c3VCSkRvbVNubHVwM0tydnNRNjE2cC8vVzBSZXVmSXFtc3BQOVlZa1RCM0x0?=
 =?utf-8?B?VEhuSXZ1eHBBMk5UK0ZRT2FvZlZkNmtHQWJpOWRHK0hkbkIzS3NNckhLY0h0?=
 =?utf-8?B?NEN6ZjE2b2ZQeXdBLzRkVGZTUm5MbkZjWlBNSkJpT2luSVlIYU1FSjNOd2FZ?=
 =?utf-8?B?WEEycGptanBHYVBHb2UwbkFjakxheFlsc1JJeVdseGM4cERaRGpSTDFvVm9x?=
 =?utf-8?B?alF4UGZYWkFvd1pjNjVZVTg0cVNFMlA3ekYvb0dTeXJOTHFNQTBQR044cFdy?=
 =?utf-8?B?YXJWKzkrazZzb1NhNkpJdUwwYTlscFYxc3NaN0JLQWtJV0dnajBjNU50YVY5?=
 =?utf-8?B?QTNJWXJsdnp1WktQcnJwNjNJeEQra1IrUVA4LzltOVFqYzdubGt4aTQ4QXla?=
 =?utf-8?B?aHJ3QmxEM1FsYmp3NVZ3MjhyeXlwVDJFZndtZitPNW96bnNvUDVKMmVSekI1?=
 =?utf-8?B?K2NKQUtza0lWR3Q3OTB5UVNsbUhheHFVOStKSVY2WC96RUczb1Z1WWlUbmx2?=
 =?utf-8?B?RVVOZS94ekNXQ3ptdDhnZ2c4Yml6RlZzMHdQLytGRFUvUVZ3QTFEZmVtN3Nq?=
 =?utf-8?B?MTZXV0JjNnF4aVBuUWFZZm0yd212YU9hTHRDMXhhWm5EQ0hlNXZkckI3Y0Vv?=
 =?utf-8?B?V25JeWtiY04zWlp4MnVsUjJ4ZzI0NFkrRGh6TGY2a3JyS1ZoaTd0N2x3aldi?=
 =?utf-8?B?Z1piRjdPRkRNczZNR0VrbXpFMDZ6YzVydnhCcllWRDh2dDNnTmxuSnhkcmJw?=
 =?utf-8?B?TTNDc0pmdkVDUmhrQ1J2WUYwcnJaWFBwQ0lZUmozUmpIb1dQcFlPYmtGbjZi?=
 =?utf-8?B?WDdPY3lLeWJya1d1eS9MSXB1OFEzUXRGeVdzL3RqT012clYzR0J3Wk1GT3Fi?=
 =?utf-8?B?NCtzU1ArRDVCRkJ4VDJJaWFyYjQzWUVvaFVRRzJoMG1ISHBCbUIwY21Zd29a?=
 =?utf-8?B?dXBMNUQzVGQ2Q0N0VFV3SHlmejhHTUhaUGhUUXhZVXFDaS8yY1B6SHd0SSt5?=
 =?utf-8?B?NnY2aXNFdnpLU2VxeWw2L0p3UWFNZ2U1MkJxWis0MTU0N0xwRmZYV3RYNlpy?=
 =?utf-8?B?dEtsSHpGeEpqSUJaM3hrUVpGdkhmcDBqVDF4dkZiRFZyY2VaUktqMU9yWUI2?=
 =?utf-8?B?bDEzRFhZNlQvMFpIeDA1eU1CU0JQR2FlVU56TlpIdTRpWWR4TFBBYU5VWGZy?=
 =?utf-8?B?bnJRVStHUGxkcnZ0czlsU0VNVVlORTRIOEpQbFl3bTFYeEVjR0NDQ1l3MUZE?=
 =?utf-8?B?eWNQOU9CRkVGWVlPTkVLcjh2V3VVSlZKWWpaWFptMGFicFBsQisxWVpQWEdV?=
 =?utf-8?B?VXdYMm5DSldzQWpmM1ltWDNEN214L0RoN2FuK2hjQkNXTGJya3BpYm9OV2JG?=
 =?utf-8?B?ZUlvNS9LRUJvY09qY0V6UXdHbUlBMjQ2Y0RXQS83ZytROUROME91RlI4NXJj?=
 =?utf-8?B?aFllUnpXWFRBWXF4a050cFE3RFlxNmxnZXlGUEV2QWtISHhVSlcvUTlSK3l3?=
 =?utf-8?B?R3JGWnZWeWE5L2h5eVpDQ3k5QW1MbUpQOXEyRVppelF4UW9yOEwxenVRSGRV?=
 =?utf-8?B?T3ZwTEJqTXhpcFNTMTA2Y2c1ZjA5K3dxNDJRclN1S3NrWVpjYWlSQWR3aGxo?=
 =?utf-8?B?UXc2ZUdhQmFoZnRiYnAzdTk0UHFZbk5LdlpLd0hXM1ljNk1JNi9nVjJmOURm?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HakV1LsqI2EWGUY+/ZBFaLhZ0PTFzCftjIuLQcdxNnyHPK044Pxe1dVbAjqp6rmBFKPx2F46hdLGdBa2B2gXI9Uj6pGUfJFlxLy0aF4AUBKKuywsiRwLeXrru2PmRdcrcynMPn6ntAF2SRO0/ACoPAonpPWEErolVZHJMSGiSU4i0sqjRcEnt2drsJgCIbBRkDVJsPJE+8UvNq9/l2/fczCi3vqG6wfXGRTzxorwco0CVNz8SFfwJ3SA/nh8AJ8MSsSHlKDMzKOJ0oP4VJXlAK++fmDuenW7ZTeOxn5Vtb2DiLGlVvr1/F11Y34yrP3ZQroH4W3A/Ub2gDeaxPvIfOM0A7ZUCkWnB3aeek/6bThWcoq9LTja8ITKKqHy/9zVLFlOtn7KKczUbfaGeJjwQ0d9hX8cPltlntIImv6c4mICFVq11TDOy+NhzdspG0EbAILxwOjAyiwoiLVsZqMAaxqnMD3TDmaTWqUsWjCPgOmw0qMzwX7WeGBpziCKQUdn4eznJKbspT5PrnHRZ4yg0cgpEsdXXV1TjY0g4R2OFxONoJfK/QG52GspHjMtRdAAy4eaHu/YYnxQA25dDjh/+bU7DNgUZPRFPd5ljFC4shA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888ec9be-3ac0-46bc-9c55-08dd5c303541
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 21:53:48.0205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3qgPsH2ks0DNrOJmqbSI85UPEPvwf3X0kd7aWsXsG/DRAdN3kXOmbTIMyaQ4F3pvjkBTpEOPZuvlbJ5xOA7WcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7947
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_09,2025-03-05_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503050168
X-Proofpoint-GUID: EK6CRI8LbpoiwLAS1KG5HudSNGBz1gnh
X-Proofpoint-ORIG-GUID: EK6CRI8LbpoiwLAS1KG5HudSNGBz1gnh

Hi Zhao,

On 3/5/25 6:46 AM, Zhao Liu wrote:
> On Sun, Mar 02, 2025 at 02:00:11PM -0800, Dongli Zhang wrote:
>> Date: Sun,  2 Mar 2025 14:00:11 -0800
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v2 03/10] [DO NOT MERGE] kvm: Introduce
>>  kvm_arch_pre_create_vcpu()
>> X-Mailer: git-send-email 2.43.5
>>
>> From: Xiaoyao Li <xiaoyao.li@intel.com>
>>
>> Introduce kvm_arch_pre_create_vcpu(), to perform arch-dependent
>> work prior to create any vcpu. This is for i386 TDX because it needs
>> call TDX_INIT_VM before creating any vcpu.
>>
>> The specific implemnet of i386 will be added in the future patch.
>>
>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> 
> Your Signed-off is missing...
> 
> (When you send the patch, it's better to attach your own Signed-off :-))

Thank you very much!

I didn't know if I would need to wait until this patch is merged into
mainline QEMU. That's why I didn't add my signed-off.

I will add in v3 and remove "DO NOT MERGE" if the patch isn't in QEMU when
I am sending out v3.

Dongli Zhang

> 
>> ---
>> I used to send a version:
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20221119122901.2469-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!P5Ki_gsFsvAUNjV4-CNmMcDAJA5QRyzJ5ufGtNqeH6Ayt2ZUxwoPde3VQVer_o9Y2xRSVTwCN5fdjO-Dyerp$ 
>> Just pick the one from Xiaoyao's patchset as Dapeng may use this version
>> as well.
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20250124132048.3229049-8-xiaoyao.li@intel.com/__;!!ACWV5N9M2RV99hQ!P5Ki_gsFsvAUNjV4-CNmMcDAJA5QRyzJ5ufGtNqeH6Ayt2ZUxwoPde3VQVer_o9Y2xRSVTwCN5fdjN17lCxG$ 
>>
>>  accel/kvm/kvm-all.c        | 5 +++++
>>  include/system/kvm.h       | 1 +
>>  target/arm/kvm.c           | 5 +++++
>>  target/i386/kvm/kvm.c      | 5 +++++
>>  target/loongarch/kvm/kvm.c | 5 +++++
>>  target/mips/kvm.c          | 5 +++++
>>  target/ppc/kvm.c           | 5 +++++
>>  target/riscv/kvm/kvm-cpu.c | 5 +++++
>>  target/s390x/kvm/kvm.c     | 5 +++++
>>  9 files changed, 41 insertions(+)
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 


