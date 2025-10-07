Return-Path: <kvm+bounces-59575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ECB72BC1C6A
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 16:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 911E63BC802
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 14:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49002E1C55;
	Tue,  7 Oct 2025 14:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D6UTiQw7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DMQZ2blf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458334BA35;
	Tue,  7 Oct 2025 14:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759848077; cv=fail; b=Z9016kJcSBI4aqHkP/DS21Ojjy8PyYOWswzO/+5p0PBOiPPZf5Jrigl818k9yb7bo3fOYrL04BzIB5vwOdZabQr7aWSNsmuVEQcesNG7DozHVePMBB6PGjz5B6ESeuDz7hhInJ/mGNOlCAb+1QovcefvB+NoFyatrrZlpeV1/hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759848077; c=relaxed/simple;
	bh=vnqtdoGfY/QCAmOYeT0dfD/5NJln2PtpFsnP6vug5t4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FMGREDEMVhRef78TxpL9EakOL//9CFckoyoagzrGjgGEyJt9VAb7x15HBvClz/CuM167CAZBf3lUnK9m6PFkzEniwQWrYQ/ZzIWCTFcJ4AaXr7dR41ooRu1LUKoPvrFovI9PEMjzNH8SCuqasnDBg2zi0eTdr70pSvRMG3Tj8wQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D6UTiQw7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DMQZ2blf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597ECGtu031170;
	Tue, 7 Oct 2025 14:41:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T8P6+ivV8bRo3hR78pNqOiuUXlouUX/U4wrhBy6k/lQ=; b=
	D6UTiQw73MDhshyxTp33S1cecZIkfdGc4DTBxRTgCM12RY6Gnkt72kwxDNNEOyUk
	R4Gitu6viMo7Kqdd5L6fnaMZ2iRTD5MRnhVuV7r4g11I5Srcj6KQeNwpi966nL+1
	g/+eEaTcY4z/PWXhvimyoTRwfPwK6e3WUeCXpsDGescVYhNsph1gu66ihTE+e/UB
	bGVY4MAwuPDqpgvDpGWvCEX+5sjwzXGB4BpNGfntLZ8sClDHLbwmeGyAaEChU3wJ
	yB8EBBIrqlGgaYuGK3Cmdf3dlLqPcU2qEpCHizLLouTengb0q4OreKQzH0VGhTga
	BElZ4OhVxmAgTIVkyC8wnA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49n1vv8e6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 14:41:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 597DDNsP036001;
	Tue, 7 Oct 2025 14:41:09 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012043.outbound.protection.outlook.com [40.107.200.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt18aea0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 14:41:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fyW0bq3QwwQ0fytd9id5OF0iIfqHk75k6vlIlTyZdWeMPcd3pI89ssN2WZNryFhmDsLjBnkPD6O/yk7Bab6kjqbI69USD28ms/vc4uTmxHqYOvQm2diNq7ZBkdJ6xOumSsY9WHeWLaPSHp+TRiGrIW6IJ5DLmO/vRVzW96I9qTW2kxQFtMKuzkjIskQXPcpfJszyt2GklXaRR7s78ocZwWqd8d2TgfzfTcSt2lpxjgwZ3ZDFo6ta17PxuNGBvjI66K62Sbnk0pgNaVQzppPrPe/Hu12vU7kAR/FjhuX5KrPUNlEUFLW682HR1oPrUI+w3P2fAi2nt10k8heu08qjGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8P6+ivV8bRo3hR78pNqOiuUXlouUX/U4wrhBy6k/lQ=;
 b=SPX4dk+xD1V6Jds8bKHerBhkKcLUNZQWoi4E3TsJq/s6S0PGxZukSDaRMiLYkkC/ZWG9AIl5roAlwW1/+yE0GXYCEr3M0aPgpkxWMTb71XVEAA9gHJwYP8D3zx125rAk+kbJPRGiiPP992Lhbm9F8fnRKzuwntJVHdpspUa9M2LNCgb5+ptwIMM91OPDDAx64qsPXW8M/TB4RHIJfCqLT9AzkTY/RCScg6E18Gg2/1sFkdYVzqOoHhTpLzqkTF8fdQPMVZt/Lt2pUAaN9FyALoWf1Eg39ADyy8XMokC6IUvaYmV3eYr/snkX5CJ9AqfsB+pQKG+DS2YhxiGbN5Bi1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8P6+ivV8bRo3hR78pNqOiuUXlouUX/U4wrhBy6k/lQ=;
 b=DMQZ2blfh9YEWcVAc94E7CfAcB2HHiO2fIwONAO09p7O60zWpdwnN8kt8Fmjnck7dLc7za4N+YRFhtrpmkuDydMoBsd0JLMKnAGlB4vuelpWHpSqAJwZ2dZnzbDy+ZLBp55dBflgtSBkSvEgIVI+Hw3Xspw7cVukRNesE4tLzlI=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by BY5PR10MB4178.namprd10.prod.outlook.com (2603:10b6:a03:210::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 14:41:02 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 14:41:02 +0000
Message-ID: <ddd39c66-81f1-44bc-95c7-832d5aff8a85@oracle.com>
Date: Tue, 7 Oct 2025 10:41:01 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
To: Alex Mastro <amastro@fb.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
 <20251006225039.GA3441843@ziepe.ca>
 <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
 <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
 <aOSWA46X1XsH7pwP@devgpu015.cco6.facebook.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <aOSWA46X1XsH7pwP@devgpu015.cco6.facebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:408:e6::19) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|BY5PR10MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: 776fea0d-0c27-4d87-e827-08de05af89cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVNwWmNGbVpTV3RxN3krSk9kQUJ0SG9yKzlVVW9RdEoyS2hZa0QzY1NXM3pl?=
 =?utf-8?B?WGMwZjJ6Snp1ZEF5ZGpJSGJVMmQ0eTl5TGJNRGVwVEZhVWJxQTlaTERKMlAw?=
 =?utf-8?B?MzJqVWhhL09WdFVrUTRXN21EN3FZODNnMWdTT0ZXTUlnUjVwUFRZbDdmZEYw?=
 =?utf-8?B?VDhMcjVxRHBJc3gzU0xvdEdidkhQNW5ybHdndjlmUWxxeE9qL09RSVVzWjk4?=
 =?utf-8?B?cytnMFd0YlFUUXk4QVJIMG1YVU1icTErRWgzbUZNV3RTbjRKYmVZeUFwa1JE?=
 =?utf-8?B?MFE4ME9hNmpjT2RjQkpuUWl4ZE9wN1lZWVN6KzUxSUE4UERIOFM3Y3BnOUJw?=
 =?utf-8?B?Q0JZaVdWVEpXWERqL3RaRWpIaEpZYy9JdlJtZmwwTnZ4K01qR3piMW15Q2pW?=
 =?utf-8?B?SHlRbnJPNHltN3BRWm1TQnVtWDdpV281bUxPSXZkUE51VDRFYkdpenMveGZP?=
 =?utf-8?B?WEpLWkVUSUVRV2tJblBvVCt4T0VacEM4VGVUeFIxKzVpQXVyelhCQm96cDZ3?=
 =?utf-8?B?dzZBcEY0MHJYVlFaODZBM0tlQjVOQnlmbXVlc09QZ1dvRHpPY3pubEtNa0dJ?=
 =?utf-8?B?TDJpcDkwUHJQc0srUk81ZWhBQmpSN0JtWWw4NUhxNnlkQ3drZTZyK3VzN0VV?=
 =?utf-8?B?TFVVeHlQYmwvWk1YZDFIMStLQjJGUzR2WFAzTjFWZ3d6aWdvTHlIWW5xekZy?=
 =?utf-8?B?bjVQaHlLTi9UQUdpYWZiTUNHaXhaVmZ6VGx1Q2xsNDJLWEZZRFk5eW82VGww?=
 =?utf-8?B?am9nc0NiNW1tZzBIN0psQktWbE9pa0VGcTdWVmdWUU5xaGhwLzhCa0xjWUw5?=
 =?utf-8?B?bUFlNXh2RDVvWXlWcDk2TVVIRDAyVVl3S1FYdVVNLzA3aUhvYmlTK0R6bk9N?=
 =?utf-8?B?OVI5TGdFZWZhUEZ4L2J1OVB2LzdGOUF5dE9LdzFKeER1bXRTRDN4VzR1YkFE?=
 =?utf-8?B?N0Nqc29WYUdRc0tBQ3ptaG9iWGFDWnVNWFc1c0dWZkc0emtlR2JsZ0xuZkNk?=
 =?utf-8?B?NU1OeWhFUDE1eDJIS0drSVFUMjJNcW1kYWZJeU1NNEh6TUI1RTZOMSs0Ujcx?=
 =?utf-8?B?Ri84U25jcW9BVFgyZmdlcDQ2NVllWStvSVV1TmttTklPamRiVWhCUU1DWC9D?=
 =?utf-8?B?Wkpjb0VBd2s1L2NnZWx3TGxhMmZqYS9yN2V2SkRPaysrU1RNdUZZVWljb2Vh?=
 =?utf-8?B?RVB6YkNPZkpWTUFCOVZITndSWG9vb3lxVWpYcXh2WTV5eUpNcFhBd3lmTXFi?=
 =?utf-8?B?ZGdOQ3Y1SzhpZmQ3ZUREdDBPQW5JbVVMNSt6ZEVxTWNqa2lmb2c1WG1lSnNi?=
 =?utf-8?B?QWNDNG1oWEtTTkhYRHllMW9Ka3d0c0JQdUs5RG9GcEkwYzBJTHV0SFpuYTU5?=
 =?utf-8?B?VGVNVzE3VHZuQlRsNThpR1ZwL2hSYlVJM2lZTDk3cUxrVUJmTmpDOS9raTlO?=
 =?utf-8?B?MFhVaVgramd6cGRxVmtNNVZxTEVHT3hxWm93NEF4WG9VSCtlS0E5SHJoaDBs?=
 =?utf-8?B?dS9zdXJ5aHo0a0lLa3VUU3B3dlp3aTNQajByREVMRlJ0UEljcC96ek9aaUdI?=
 =?utf-8?B?YXNmYzZqYkRISXdkbGFNVVFkN2wwMFh4MXZiWE9QZ2xuemRZc05pZHpnMXk3?=
 =?utf-8?B?bnJwdDU0Q2N4Yko1cUxIRXR5cmJadG41SzJNbS9HSDZxV2NoaWRKbmhCazds?=
 =?utf-8?B?NXhDYXZTMWV5SEtZMThIaDN4WlBJTWREYlZZTHc0MVBWQzJwUnNSK0ZaRVJG?=
 =?utf-8?B?a3N5Z3RpbkNEZ1Zjbm9GUmt0OG5KU0xpdVl2cGYvOGpLK05laHRIV1UzbFBT?=
 =?utf-8?B?U29xWDUySENVR3lQU0JIOUVsRWtFdXRIZjNqWUZHcG9IdzhFdkRXSTNpM0gw?=
 =?utf-8?B?ZHFQbkhBZjRMN0ZZbjh5eDhTQUc5T0M3SzV1ZEp1WW1sQkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3hNbllPb2EwalZ3bk1BSFZPNVQ1Qmh4NzI0QU5aRzlGaUM5K2NudXFoTURu?=
 =?utf-8?B?MW1xZUpRazl6amNBdWtsSktiaGs2L2NLL0J0MmJSWjV2U25PcVhxSkF5QmdQ?=
 =?utf-8?B?Yy9mVkNpY1NydFY3Q0ZlWmt2UVpNY1pvd1Z4SFpYZXFUcmRHdDBLaEVrZmpl?=
 =?utf-8?B?bTFCbUJETmFsTUlwMTcrZDBFYVY5RmV5NFM1VWFPTXdIU3N4QXZWd0YydEl6?=
 =?utf-8?B?SVVqcmFVdW5BZ0xsVTFiMmFnT1YwcXZEamFlSSt5T2VlZ3B0cWJ3UGdwdzEr?=
 =?utf-8?B?OWx0U3lFdzg3V2UwVXZ5Y1Ztd3JLcEI0c3lMb2ZMbFMrbDBPSmJtSm9oV2NT?=
 =?utf-8?B?STR6RDNzcTliSHdmMXdNU3ZVdzk3WGpxbkllOHA2TUt5OFZYUlhZM0k1VjN3?=
 =?utf-8?B?NmQzbFlJcFNnbzBDWnJtdTZJdnlGS01xbDh5QzVuZ0RIdnFxOEN0R29abEU0?=
 =?utf-8?B?TEVYcDRZTWt4aHlNVFl4Y29wYktHV2oxVldvS3JPdDN2SnJIS2lqcjZPSWJ5?=
 =?utf-8?B?MHdoMW9oOUplMG5uQ0tLSVEwYmFDeUo5V005UmlHem9Pc1pFdkxNRTBLMXNE?=
 =?utf-8?B?TXBNZ29ueGhKNTdyNnJoVTJ0L3hqVWRIMFNKRDVkWUpGa0J2aW1NVHR1N1h3?=
 =?utf-8?B?MUtwL3RYWGRiencrVFRRcXRZSTVyWkc3ODBDc3czUVlwSWxRZ0FqdXVqQWx2?=
 =?utf-8?B?amVCdDRmSjQza2VtRW0yWjdnZ1NGN3ZOUzFBd2F6SDVSNnhFUFk2Ym5IY3BU?=
 =?utf-8?B?WDREVnJ4NG15U1RMOHJwZUVoTGlualJIVWprOXZJTzRQYVZjNXUzUUtIem9w?=
 =?utf-8?B?aDFyNjVCTzFvd0p6TkJ3NURFRmtFYlB4YzdFSVN2eEZPQUxWd1lIM01NbFdV?=
 =?utf-8?B?YTRYU0NtS3I3UjZyWDRKLzhDWGU1ZkVteXFxL1NNMDB5OEg2TCtpUUsvWVRR?=
 =?utf-8?B?ak56cCtjQVh3cnFLOERZaUJLcGY3YkNYcGJ4VEJLR01TMjhzWEpBUkkzajNi?=
 =?utf-8?B?K2crdVpGQUZVWDZpQnpUbGpWd2tNR3pLcC9idU9BczI1Y1N6U28rckhGTnNJ?=
 =?utf-8?B?ek01TG9OcFhTYTFybU13bm5aRVFiNFRwNFY3VzlJVzlFci9GL0tkOHVsTnpE?=
 =?utf-8?B?NXA5NXBzYmJ2bGhMOVVVVzNKR3FvcUpyWWdMUVhDQ2JrYjNZL2F4ays4bXU0?=
 =?utf-8?B?cU5XTGUxSElUNUgzcU5JZVdQTDRobTVjRmQ2OHNRMXM0VEptZERBQUtWMU9V?=
 =?utf-8?B?WlJYelkvb1NkVzNIQUhDREtmellqOXZBdUQrMmRwTTVFSzl2a2VHWmdMSlM3?=
 =?utf-8?B?QVB3WXFtWWxsODdLL0NaSHcvaXUyOUg3eVk4MU00NEFZb012aytnVjMyaGU1?=
 =?utf-8?B?U2pkS1ZKalE2SmVxR2E3WXRCc1VYWHVrdlEvVHdiMm9HK1hvUHFYNkZEanli?=
 =?utf-8?B?bjl1R3lwc2dFSzhrUHNyNnRld0tFZGVaU1BPeGRVZ3B5VXJWZ1NyNkRWOHQz?=
 =?utf-8?B?RXA3S1d1azJRWUtjNVlDU1dZTTFHV0tWa3ZPNFFFZHA4Q1ljM0xseWV5ajVV?=
 =?utf-8?B?bDlYeVg5ZjkzUGhJQVhkR3NSVUMrVGVJaUcrVnRxVkUxc0RqSkY1OEFEcG1a?=
 =?utf-8?B?N3lJYVZwQmtncUdWS2IvOUxwZzF0dUlaNkJEdFd6dFBvMjJXSzdROFFYN09M?=
 =?utf-8?B?SFVmTWZZT2VGOWpWU2VXZ1VlbGpBTi9LZkE3TGtGRk1zb2pkRFRJVXNSRWdV?=
 =?utf-8?B?OUp4MUJaamM0Ty9qeUxRaVVIcjN0NTdVeDJLT1BwV1h5MmJsSGZWcEthMFJj?=
 =?utf-8?B?Y3FDdVh1Y2w5VE5MVkZOdXQwd3lyL1prS1k0SXZ1RzN0bUlYL0lkYVVyNUdV?=
 =?utf-8?B?RjhEQXQ1aE5XdXB6dzFtRlpSZ1ZsQXpNdWFwQUtYZkdTb2VSR0hmRTJTUDlw?=
 =?utf-8?B?cS85d1NoNnk1Vi9HcVhxM3IvZ1dnTDNIcnBTbXNxSC94N0daZzZQRnpSVFVS?=
 =?utf-8?B?RDF0Mm9Mbjh2RVovc2lqby8zc1U3aVhCbEVud0l4aEdzRnJkV1JSbFJ0dDZk?=
 =?utf-8?B?V0dWSXIweERHVkpQV3J3QzByeThIVGZRWFlpMm11UXhMTmhVYkEwTW1kbmJI?=
 =?utf-8?B?bE5uc3VEOWNWdlB1TmlwWnZEMStndzc0SW55UTFDM0RoZWtoZk9JT3pETW5M?=
 =?utf-8?Q?FZvFLfmq0N2mQcf21Z77fWU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O9duJwFvQKdg43m9rByE/jKmxMw78tXVj7TApQwBP9SyYzPBSi3tbSw5Xvu6i/sY8BA/hq28Nk+IX3zGVeeHDEsHbnhbf9UtOL+PikIlL+7n1XwUAsRjsjDNbK4gWjXr0qdCHuS+fsqo2bmCoRvFljL47fM098ykkk9OeHBhRDS35JDq8ZKpKE4S5iBeAcZIjDaKgVWQk2aXD3EzyDWjOEcvk76iEqCGceqRI7ThDf0bqP5J7dIJEUE84o9qu9h7G6HhIob6QeFEjE58+rYqcN8vf3/W7S8dwQRCBrUiQDuIP4SBjFgaimyXg2oOc1ZUazbphXOzpxcswkP/xm2xHtU3ONHHJwBxi5vForDdeQhdsZxLEPgSrlVo8TtIM0bprJgSVLcKQlIuZfing8i6Mo0+KcFfHN1gBZxxvGJpnYpsrHhMsRNalNI4FQj+W7nSU/abmDpKZqxiZ0kiO5qFFuDTUaVYLRsc53boMGyZr91/0LutKaHPZ2Kc/XakApaE0dG5T+GtJbKse0g69a5zfMHC2z6w29iQEZiTQ4HV4Y19HO98+Wd7hlWEaPh5+COFKY39FbmHyLfli9P2OKd7hRbejuCcfE/wxF5vIhmjQMU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776fea0d-0c27-4d87-e827-08de05af89cf
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 14:41:02.4061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KO8YribSselicyeBLcLSDZxNdAHsOPOHj+gDq898ufcrO40ehLjU3GAbB0sQfrW0/279GKS8OdBSip/RQoW8OxLete8oT0uizol1aqBtyY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070116
X-Proofpoint-GUID: ahsrDNcFwIEJ7zBylupB2C1cXralugQx
X-Proofpoint-ORIG-GUID: ahsrDNcFwIEJ7zBylupB2C1cXralugQx
X-Authority-Analysis: v=2.4 cv=Cseys34D c=1 sm=1 tr=0 ts=68e52687 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=wcqnmwa6SIbGmbAN9OQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDA5MSBTYWx0ZWRfX8hr92yiTd8sz
 oA+L7a6OKK/+E+ChFhb2I2O0/KwsNeZ1GBuJHyFloNIZCYRNC4NxIminhpmCakvcxznU7Bt8lBF
 KZ/d/nk2E2GA6QD6//SiwNJJHxzkocBHxaEPcbmn6o5r7ynVOQQ3pdk2Ye/TDcXvHsKzBVoU5r7
 eSfBbBlvqyKMuLm9JlwqTFnV8FnRfgATQUu8csQL9yd9FsP6LB4VH628uqVBlocsYSTV3VNWfV2
 y/eWXFMxYghvVTfL7P5bPZ2irqvZ1j6p+ixh5QtBYh4bJy4MX6mIDTWTHZh+Q5yZtDWabUI+blH
 jIH5VeUYGFc4WHFO+AvyNs2KyPrRsx2AfO14w1zKFFEp8Vn8gOGqMYzIbwdHfgDQX+QR/N5XXHN
 AT5qOSGCgDlQtN4KW8B/JMeQ5buh27ets60WxKre2YEnt87jPZg=



On 10/7/25 12:24 AM, Alex Mastro wrote:
> On Mon, Oct 06, 2025 at 09:23:56PM -0400, Alejandro Jimenez wrote:
>> If going this way, we'd also have to deny the MAP requests. Right now we
> 
> Agree.
> 
>>> I have doubts that anyone actually relies on MAP_DMA-ing such
>>> end-of-u64-mappings in practice, so perhaps it's OK?
>>>
>>
>> The AMD IOMMU supports a 64-bit IOVA, so when using the AMD vIOMMU with DMA
>> remapping enabled + VF passthrough + a Linux guest with iommu.forcedac=1 we
>> hit this issue since the driver (mlx5) starts requesting mappings for IOVAs
>> right at the top of the address space.
> 
> Interesting!
> 
>> The reason why I hadn't send it to the list yet is because I noticed the
>> additional locations Jason mentioned earlier in the thread (e.g.
>> vfio_find_dma(), vfio_iommu_replay()) and wanted to put together a
>> reproducer that also triggered those paths.
> 
> I am not well equipped to test some of these paths, so if you have a recipe, I'd
> be interested.
>   

Unfortunately I didn't find a good recipe yet, which is why I delayed 
sending my patch with the fix.
I tried a few things to trigger the code paths, but the "easy way" 
methods are not enough. e.g. vfio_iommu_replay() is called when enabling 
the IOMMU model on the container i.e. when issuing the VFIO_SET_IOMMU 
ioctl but at that time there are no mappings yet for the domain so there 
is no dma_list to traverse.
I also tried attaching a second group to the same container that already 
contained a group with mappings, but in vfio_iommu_type1_attach_group() 
the new group is attached to the "existing compatible domain" that was 
already created for the first, since mappings are per-domain, so there 
is no need for replay.
Just mentioning this to give an idea, I didn't have time to try 
triggering the paths involved with dirty tracking...

The basic reproducer I linked on my original patch:

https://gist.github.com/aljimenezb/f3338c9c2eda9b0a7bf5f76b40354db8

is only exercising vfio_find_dma_first_node() and vfio_dma_do_unmap(), 
which is enough to verify the fix that was causing the AMD vIOMMU failure.


>> I mentioned in the notes for the patch above why I chose a slightly more
>> complex method than the '- 1' approach, since there is a chance that
>> iova+size could also go beyond the end of the address space and actually
>> wrap around.
> 
> I think certain invariants have broken if that is possible. The current checks
> in the unmap path should prevent that (iova + size - 1 < iova).
> 
> 1330          } else if (!size || size & (pgsize - 1) ||
> 1331                     iova + size - 1 < iova || size > SIZE_MAX) {
> 1332                  goto unlock;
> 

Yes, that check properly accounts for overflow, but later 
vfio_find_dma_first_node() doesn't, so it won't find the node in the 
dma_list. I agree with the approach of sanitizing the inputs at the uapi 
boundary as Jason mentions, but the code should be robust enough to 
handle overflow anyways I'd think.

>> My goal was not to trust the inputs at all if possible. We could also use
>> check_add_overflow() if we want to add explicit error reporting in
>> vfio_iommu_type1 when an overflow is detected. i.e. catch bad callers that
> 
> I do like the explicitness of the check_* functions over the older style wrap
> checks.
> 
> Below is my partially validated attempt at a more comprehensive fix if we were
> to try and make end of address space mappings work, rather than blanking out
> the last page.
> 

In my opinion, the latter that is not optional. Ranges ending at the 
64-bit boundary are valid, and not accepting them will break drivers 
that request them.

I'll test this change when I have a chance, though I'd really like to 
have solid test cases so I am hoping there is some advice on how to 
trigger all the paths.

Thank you,
Alejandro

> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 08242d8ce2ca..66a25de35446 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -28,6 +28,7 @@
>   #include <linux/iommu.h>
>   #include <linux/module.h>
>   #include <linux/mm.h>
> +#include <linux/overflow.h>
>   #include <linux/kthread.h>
>   #include <linux/rbtree.h>
>   #include <linux/sched/signal.h>
> @@ -165,12 +166,14 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>   {
>   	struct rb_node *node = iommu->dma_list.rb_node;
>   
> +	BUG_ON(size == 0);
> +
>   	while (node) {
>   		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>   
> -		if (start + size <= dma->iova)
> +		if (start + size - 1 < dma->iova)
>   			node = node->rb_left;
> -		else if (start >= dma->iova + dma->size)
> +		else if (start > dma->iova + dma->size - 1)
>   			node = node->rb_right;
>   		else
>   			return dma;
> @@ -186,10 +189,12 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
>   	struct rb_node *node = iommu->dma_list.rb_node;
>   	struct vfio_dma *dma_res = NULL;
>   
> +	BUG_ON(size == 0);
> +
>   	while (node) {
>   		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>   
> -		if (start < dma->iova + dma->size) {
> +		if (start <= dma->iova + dma->size - 1) {
>   			res = node;
>   			dma_res = dma;
>   			if (start >= dma->iova)
> @@ -199,7 +204,7 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
>   			node = node->rb_right;
>   		}
>   	}
> -	if (res && size && dma_res->iova > start + size - 1)
> +	if (res && dma_res->iova > start + size - 1)
>   		res = NULL;
>   	return res;
>   }
> @@ -213,7 +218,7 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>   		parent = *link;
>   		dma = rb_entry(parent, struct vfio_dma, node);
>   
> -		if (new->iova + new->size <= dma->iova)
> +		if (new->iova + new->size - 1 < dma->iova)
>   			link = &(*link)->rb_left;
>   		else
>   			link = &(*link)->rb_right;
> @@ -825,14 +830,24 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>   	unsigned long remote_vaddr;
>   	struct vfio_dma *dma;
>   	bool do_accounting;
> +	u64 end, to_pin;
>   
> -	if (!iommu || !pages)
> +	if (!iommu || !pages || npage < 0)
>   		return -EINVAL;
>   
>   	/* Supported for v2 version only */
>   	if (!iommu->v2)
>   		return -EACCES;
>   
> +	if (npage == 0)
> +		return 0;
> +
> +	if (check_mul_overflow(npage, PAGE_SIZE, &to_pin))
> +		return -EINVAL;
> +
> +	if (check_add_overflow(user_iova, to_pin - 1, &end))
> +		return -EINVAL;
> +
>   	mutex_lock(&iommu->lock);
>   
>   	if (WARN_ONCE(iommu->vaddr_invalid_count,
> @@ -997,7 +1012,7 @@ static long vfio_sync_unpin(struct vfio_dma *dma, struct vfio_domain *domain,
>   #define VFIO_IOMMU_TLB_SYNC_MAX		512
>   
>   static size_t unmap_unpin_fast(struct vfio_domain *domain,
> -			       struct vfio_dma *dma, dma_addr_t *iova,
> +			       struct vfio_dma *dma, dma_addr_t iova,
>   			       size_t len, phys_addr_t phys, long *unlocked,
>   			       struct list_head *unmapped_list,
>   			       int *unmapped_cnt,
> @@ -1007,18 +1022,16 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
>   	struct vfio_regions *entry = kzalloc(sizeof(*entry), GFP_KERNEL);
>   
>   	if (entry) {
> -		unmapped = iommu_unmap_fast(domain->domain, *iova, len,
> +		unmapped = iommu_unmap_fast(domain->domain, iova, len,
>   					    iotlb_gather);
>   
>   		if (!unmapped) {
>   			kfree(entry);
>   		} else {
> -			entry->iova = *iova;
> +			entry->iova = iova;
>   			entry->phys = phys;
>   			entry->len  = unmapped;
>   			list_add_tail(&entry->list, unmapped_list);
> -
> -			*iova += unmapped;
>   			(*unmapped_cnt)++;
>   		}
>   	}
> @@ -1037,18 +1050,17 @@ static size_t unmap_unpin_fast(struct vfio_domain *domain,
>   }
>   
>   static size_t unmap_unpin_slow(struct vfio_domain *domain,
> -			       struct vfio_dma *dma, dma_addr_t *iova,
> +			       struct vfio_dma *dma, dma_addr_t iova,
>   			       size_t len, phys_addr_t phys,
>   			       long *unlocked)
>   {
> -	size_t unmapped = iommu_unmap(domain->domain, *iova, len);
> +	size_t unmapped = iommu_unmap(domain->domain, iova, len);
>   
>   	if (unmapped) {
> -		*unlocked += vfio_unpin_pages_remote(dma, *iova,
> +		*unlocked += vfio_unpin_pages_remote(dma, iova,
>   						     phys >> PAGE_SHIFT,
>   						     unmapped >> PAGE_SHIFT,
>   						     false);
> -		*iova += unmapped;
>   		cond_resched();
>   	}
>   	return unmapped;
> @@ -1057,12 +1069,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
>   static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   			     bool do_accounting)
>   {
> -	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
>   	struct vfio_domain *domain, *d;
>   	LIST_HEAD(unmapped_region_list);
>   	struct iommu_iotlb_gather iotlb_gather;
>   	int unmapped_region_cnt = 0;
>   	long unlocked = 0;
> +	size_t pos = 0;
>   
>   	if (!dma->size)
>   		return 0;
> @@ -1086,13 +1098,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   	}
>   
>   	iommu_iotlb_gather_init(&iotlb_gather);
> -	while (iova < end) {
> +	while (pos < dma->size) {
>   		size_t unmapped, len;
>   		phys_addr_t phys, next;
> +		dma_addr_t iova = dma->iova + pos;
>   
>   		phys = iommu_iova_to_phys(domain->domain, iova);
>   		if (WARN_ON(!phys)) {
> -			iova += PAGE_SIZE;
> +			pos += PAGE_SIZE;
>   			continue;
>   		}
>   
> @@ -1101,7 +1114,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   		 * may require hardware cache flushing, try to find the
>   		 * largest contiguous physical memory chunk to unmap.
>   		 */
> -		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
> +		for (len = PAGE_SIZE; len + pos < dma->size; len += PAGE_SIZE) {
>   			next = iommu_iova_to_phys(domain->domain, iova + len);
>   			if (next != phys + len)
>   				break;
> @@ -1111,16 +1124,18 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   		 * First, try to use fast unmap/unpin. In case of failure,
>   		 * switch to slow unmap/unpin path.
>   		 */
> -		unmapped = unmap_unpin_fast(domain, dma, &iova, len, phys,
> +		unmapped = unmap_unpin_fast(domain, dma, iova, len, phys,
>   					    &unlocked, &unmapped_region_list,
>   					    &unmapped_region_cnt,
>   					    &iotlb_gather);
>   		if (!unmapped) {
> -			unmapped = unmap_unpin_slow(domain, dma, &iova, len,
> +			unmapped = unmap_unpin_slow(domain, dma, iova, len,
>   						    phys, &unlocked);
>   			if (WARN_ON(!unmapped))
>   				break;
>   		}
> +
> +		pos += unmapped;
>   	}
>   
>   	dma->iommu_mapped = false;
> @@ -1212,7 +1227,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>   }
>   
>   static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
> -				  dma_addr_t iova, size_t size, size_t pgsize)
> +				  dma_addr_t iova, u64 end, size_t pgsize)
>   {
>   	struct vfio_dma *dma;
>   	struct rb_node *n;
> @@ -1229,8 +1244,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>   	if (dma && dma->iova != iova)
>   		return -EINVAL;
>   
> -	dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -	if (dma && dma->iova + dma->size != iova + size)
> +	dma = vfio_find_dma(iommu, end, 1);
> +	if (dma && dma->iova + dma->size - 1 != end)
>   		return -EINVAL;
>   
>   	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> @@ -1239,7 +1254,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>   		if (dma->iova < iova)
>   			continue;
>   
> -		if (dma->iova > iova + size - 1)
> +		if (dma->iova > end)
>   			break;
>   
>   		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
> @@ -1305,6 +1320,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>   	unsigned long pgshift;
>   	dma_addr_t iova = unmap->iova;
>   	u64 size = unmap->size;
> +	u64 unmap_end;
>   	bool unmap_all = unmap->flags & VFIO_DMA_UNMAP_FLAG_ALL;
>   	bool invalidate_vaddr = unmap->flags & VFIO_DMA_UNMAP_FLAG_VADDR;
>   	struct rb_node *n, *first_n;
> @@ -1327,11 +1343,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>   		if (iova || size)
>   			goto unlock;
>   		size = U64_MAX;
> -	} else if (!size || size & (pgsize - 1) ||
> -		   iova + size - 1 < iova || size > SIZE_MAX) {
> +	} else if (!size || size & (pgsize - 1) || size > SIZE_MAX) {
>   		goto unlock;
>   	}
>   
> +	if (check_add_overflow(iova, size - 1, &unmap_end))
> +		goto unlock;
> +
>   	/* When dirty tracking is enabled, allow only min supported pgsize */
>   	if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
>   	    (!iommu->dirty_page_tracking || (bitmap->pgsize != pgsize))) {
> @@ -1376,8 +1394,8 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>   		if (dma && dma->iova != iova)
>   			goto unlock;
>   
> -		dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -		if (dma && dma->iova + dma->size != iova + size)
> +		dma = vfio_find_dma(iommu, unmap_end, 1);
> +		if (dma && dma->iova + dma->size - 1 != unmap_end)
>   			goto unlock;
>   	}
>   
> @@ -1386,7 +1404,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>   
>   	while (n) {
>   		dma = rb_entry(n, struct vfio_dma, node);
> -		if (dma->iova > iova + size - 1)
> +		if (dma->iova > unmap_end)
>   			break;
>   
>   		if (!iommu->v2 && iova > dma->iova)
> @@ -1713,12 +1731,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   
>   	for (; n; n = rb_next(n)) {
>   		struct vfio_dma *dma;
> -		dma_addr_t iova;
> +		size_t pos = 0;
>   
>   		dma = rb_entry(n, struct vfio_dma, node);
> -		iova = dma->iova;
>   
> -		while (iova < dma->iova + dma->size) {
> +		while (pos < dma->size) {
> +			dma_addr_t iova = dma->iova + pos;
>   			phys_addr_t phys;
>   			size_t size;
>   
> @@ -1734,14 +1752,15 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   				phys = iommu_iova_to_phys(d->domain, iova);
>   
>   				if (WARN_ON(!phys)) {
> -					iova += PAGE_SIZE;
> +					pos += PAGE_SIZE;
>   					continue;
>   				}
>   
> +
>   				size = PAGE_SIZE;
>   				p = phys + size;
>   				i = iova + size;
> -				while (i < dma->iova + dma->size &&
> +				while (size + pos < dma->size &&
>   				       p == iommu_iova_to_phys(d->domain, i)) {
>   					size += PAGE_SIZE;
>   					p += PAGE_SIZE;
> @@ -1782,7 +1801,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   				goto unwind;
>   			}
>   
> -			iova += size;
> +			pos += size;
>   		}
>   	}
>   
> @@ -1799,29 +1818,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   unwind:
>   	for (; n; n = rb_prev(n)) {
>   		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> -		dma_addr_t iova;
> +		size_t pos = 0;
>   
>   		if (dma->iommu_mapped) {
>   			iommu_unmap(domain->domain, dma->iova, dma->size);
>   			continue;
>   		}
>   
> -		iova = dma->iova;
> -		while (iova < dma->iova + dma->size) {
> +		while (pos < dma->size) {
> +			dma_addr_t iova = dma->iova + pos;
>   			phys_addr_t phys, p;
>   			size_t size;
>   			dma_addr_t i;
>   
>   			phys = iommu_iova_to_phys(domain->domain, iova);
>   			if (!phys) {
> -				iova += PAGE_SIZE;
> +				pos += PAGE_SIZE;
>   				continue;
>   			}
>   
>   			size = PAGE_SIZE;
>   			p = phys + size;
>   			i = iova + size;
> -			while (i < dma->iova + dma->size &&
> +			while (pos + size < dma->size &&
>   			       p == iommu_iova_to_phys(domain->domain, i)) {
>   				size += PAGE_SIZE;
>   				p += PAGE_SIZE;
> @@ -2908,6 +2927,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>   		unsigned long pgshift;
>   		size_t data_size = dirty.argsz - minsz;
>   		size_t iommu_pgsize;
> +		u64 end;
>   
>   		if (!data_size || data_size < sizeof(range))
>   			return -EINVAL;
> @@ -2916,8 +2936,12 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>   				   sizeof(range)))
>   			return -EFAULT;
>   
> -		if (range.iova + range.size < range.iova)
> +		if (range.size == 0)
> +			return 0;
> +
> +		if (check_add_overflow(range.iova, range.size - 1, &end))
>   			return -EINVAL;
> +
>   		if (!access_ok((void __user *)range.bitmap.data,
>   			       range.bitmap.size))
>   			return -EINVAL;
> @@ -2949,7 +2973,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>   		if (iommu->dirty_page_tracking)
>   			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
>   						     iommu, range.iova,
> -						     range.size,
> +						     end,
>   						     range.bitmap.pgsize);
>   		else
>   			ret = -EINVAL;


