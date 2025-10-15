Return-Path: <kvm+bounces-60108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F5ABE0CF1
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 23:26:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A11A405AE4
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 21:26:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B5092FAC15;
	Wed, 15 Oct 2025 21:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y+RaNnwl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lXh8DqZ8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6204303A08;
	Wed, 15 Oct 2025 21:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760563527; cv=fail; b=r1tLlMIuKKP9eHMMmJjFUc4aqFISxoyl13iAwC20OwpMC8q+mkocpsPlQG91dnNdWAZTPS/XZtprEskXYQ3BxLVm2+LC//8nAugxgej2hopZoGki6ct1vxUN9TQG3CBM/8tFLYTY4fePGW0aomS2O9q6VRuA2b5JZU62K2J8k8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760563527; c=relaxed/simple;
	bh=nSm83EzyxF9YMOzxRsZlEz6cLtsFKdHLuf2X+rWLq84=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SvFPI+o8QMmpzL+f40k2oZXp9z8NTHrqEpjSR1/8NLSuLEN8U6OP5r9jv7ze5ycR/iyNXxRy2XlNN39NOqBAAFL7q4G+68thnY6qUsKK85CIfrHtxYNfBnBJWcFwYjEf8uTQSeLEyXzwznPxmSET+zxvLsT2Ui2PG+4GmiNqSM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y+RaNnwl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lXh8DqZ8; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59FJwsei019876;
	Wed, 15 Oct 2025 21:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KBQ0UfTygIFGuZCtC+rF4ojIcw96Djn3rvEQl8ajZs8=; b=
	Y+RaNnwl+bOXNh/pnUQiFvFMtLNSTUK1Hj7EU6P1cnJFQE8jzl2QcR7SrdPl8c5z
	aNWLJ4NflEMEZky3Kg/ZCraYL5ujYgwvlO7kyFbHqzYCYpYAPkCdmjQyPgJagwqy
	/k9xj/0ISaA1EMUvKUiyIsSbrWJ+Do9Axek1mY4ITDAK0Vr3M+WQG8kvDFozFcS6
	SeGuD/oRuFrg+G2S6m1dD1FFP+eoEtGfsMazQYCTj7x+f3QkjbkrRPI43ggpeZgD
	zLWY1wqKuCLHu2jOSX1V4Z4L+npNiFsl8LhC8UkLgBpODSUqfZEL+JieqpC8EWOM
	ovK2A5KE1Onu9+/KfuTy6A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qf47qg89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 21:25:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59FK0VgO037857;
	Wed, 15 Oct 2025 21:25:20 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013054.outbound.protection.outlook.com [40.93.201.54])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpgwbnu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Oct 2025 21:25:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3a8hitlk6BJ8H9uInlBuqyG5RzbUAIve3NOnahzn2jwCswOnNF52OJG4bmHjpqVC6M3uE6Fczj6Ud1lgHkjnrIaewzvzirp3R3xth5H4h2bxmAayy3D2V/Fli//ygTitVRPTNPvwlYX2YBSY6246ZAOV5xM/Yv2bNiPTNIdCes5aYxoSKVM93bp1k4UkEIWfCoW4QyQ4jEmjKvmDMxCBw1+3TN7nSmnxcb5ru2nvgPnD4pC5c/RyI7WnhE4VfHqappbQdU6YFVCAce7HCZViD1vxm3i/ZmFTnWnO3qmazLQ2eJQ0ElKEnXrmgc91VSJ5kmHgvKqvxUyCmacyJy4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KBQ0UfTygIFGuZCtC+rF4ojIcw96Djn3rvEQl8ajZs8=;
 b=Npy58F9LvNN5e4Xc7m5fRRtN652332V8hfu3/kIRIHKHN/5Nym+F63CRj1gAxyfIDwQJKRtZN8pkedQfngbuQCfr8o85PpLFxrOh27Qp2y03XTJhXS80XjUI+9LK/I/VYeE9UiaWEGV9Tc2hyO3GCCtpETzkPnFQFA/Jrln7QkxPJ1VymRYiYSUlhIymGBfT2iG26M7N+KgEGBZiXRN4DQRO2FVbKiDQEFqExnGDdgxzcJm53Qbc2QtwGTCE030ntXdbPKNXG+OQGzWISCLKDUe1ubzOiCpp4HGw69ipuBOmJuP7K/INlbGb6rRbZa+VfB5YllF7+SNPC2XLzlJi5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBQ0UfTygIFGuZCtC+rF4ojIcw96Djn3rvEQl8ajZs8=;
 b=lXh8DqZ8eCm8clmJL4d+Ccpuv/paCSREsaao5F4s/QaELplA6/Xvxj89x/T2ouzQTzGUIg+BstA7XvVMGNQ4BEUHZ0Kght5JZZMcxntmeAiuImeH/9YE62KuLGtV5FZXYDfPTYGqfb2R6xKmkdZj1xHram9cZkV2n9knyiZG6sA=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by CH4PR10MB8172.namprd10.prod.outlook.com (2603:10b6:610:239::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Wed, 15 Oct
 2025 21:25:18 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9203.009; Wed, 15 Oct 2025
 21:25:17 +0000
Message-ID: <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
Date: Wed, 15 Oct 2025 17:25:14 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
To: Alex Williamson <alex@shazbot.org>, Alex Mastro <amastro@fb.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251015132452.321477fa@shazbot.org>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20251015132452.321477fa@shazbot.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::9) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|CH4PR10MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 977db9cd-669e-4e93-8f3f-08de0c31566f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OER4ZzZrT0RUMXFIMkpDR0lQOXV1UkJ0OHJtQXl1U29PeVQyNTVxci9OYTVh?=
 =?utf-8?B?UkdmSVpOVnliNkNyRkU4NXpKQnpYT1N5QUhoMVB1VUlEd2RWcHE5WjFLNUZm?=
 =?utf-8?B?UjhkRTVSbnErMXZKdWdSNHNMbE5qTytzdDlUc0FnMDduYzRnVldhY1BhMHdq?=
 =?utf-8?B?L2Z6V0ltWVcxN0tXQTVPVnYyNXdqd0lFMXFWVXZ6RnpsUnMrNlAwcXFzTUpo?=
 =?utf-8?B?UUkzY3NHWnlNTkJTM2NRWS9YQ3ZIODZLSjVWL1Q4N2FrNzFwZURWWmg1YjVy?=
 =?utf-8?B?NTUyZTU5cnlwUHJWcWFMcFJIRUt1U0ZZLzRQMklaejdBWDR4MmNSQ0daSTlQ?=
 =?utf-8?B?NWNqbWoxQlVkRDQvQTIvd2ZPdWtDTFFscGFIZHhLUHBJSk9sc1NhRmFDci9l?=
 =?utf-8?B?L0xkTytLeUp6ejFRVHQrZkVaa3kwdW1uUzg5YnZRb2VpSjhiaDlEelhUYi9y?=
 =?utf-8?B?ekpNbmtmcVZlQU5VcHM0blBFM2l0Tkc2RTRVUjRsa3h0RzRSeDV5V3pwRDVG?=
 =?utf-8?B?MUJiWXZWYXprdWdwYjErd0o4Yy9KUmUvTXNTSWx5RmkxUlZIZEJLK2dBNHll?=
 =?utf-8?B?Umo2bUh4dFJMczBMSHh1TS8wQWphYXVGR0ZKRlJQNjBCc2VBamtUS0RySVN3?=
 =?utf-8?B?NHZGMjJ4WkZRdHltMFpPYWs2cEkrUExHYkNaNHBqaVNuVmhKMXZiejhvMWZm?=
 =?utf-8?B?ZkdKTDFudzhNTFpibUxEWk9UaW1sVFBVMzl0elN4bUlRV2trRkg5VTB1Ynpt?=
 =?utf-8?B?N2ZEL3QzendvWmJlRzJybGRNT1JzeDNEVkpaME0wdEphK0YyT3BjUGhuMTlD?=
 =?utf-8?B?cGdDQ2R6VnBrOFlkMG81SXBxTVFIa3pTcjFjNStmRE83MEg3dm5YQ1BFalV2?=
 =?utf-8?B?NnN0QmhjNnVKTWxoazZJS1ZIa2VJVi8yVStMYk94Sk03bHZkT3lqTW0vZ2Rz?=
 =?utf-8?B?SU9JVjN1Z2tzelQyeEUvY0F2azVOczV1TW05RkZ1MHVRdmtFZFNNdURORlJs?=
 =?utf-8?B?d3ZibUNHWGhEUlVTZHQzdWxaOGw3K0JtWFkyNEgycjJ1RjRQbitucGlaZGFk?=
 =?utf-8?B?aUN2VVVNdHRpS25WdStRMThPNnd0a0VNemM2ZjA2QjduZXVEMVUrQUxUeEN0?=
 =?utf-8?B?QTNaSUgvUFBYVzJ3SVBCWXdwNXZsdVArZjMzZ0c2dStzdjJnTjIwOTFhZWNS?=
 =?utf-8?B?R0RabTNuREFQbzdtV1p0c0ZhVkx0VTlKMVlvRHhlYk1OWHFKNHkwd2FGdGhD?=
 =?utf-8?B?MHZURERxd2ZnamVXWkJ3eUtiZzVabTRDT2lJWDQ5MVFLSU85YXpCTUFPSEFi?=
 =?utf-8?B?UytzNjRmcE5lV2hRS29HL1NsU0FpYXI1VDJpV0NCTVBZK2swdlEwNk8wN3hy?=
 =?utf-8?B?Yjl1S3Q0ayttZWUxUVpmeEMyN25DYld2c1RTcWt4NzdCTCtYU0hZL2VrSm1C?=
 =?utf-8?B?VlRrRlN0Qlh0YW9vVUhyeUEydkliK0FxYlJ0a2I5OU44M1ZsL2hHWHkyTkI3?=
 =?utf-8?B?dFJqWDZaVkt2SzE2dGpuYXVTTWZiM2w2bU8ybTdPSWYyNExkYjF6ZEpWTmox?=
 =?utf-8?B?OVpZTnVEaTZHczBwUmNSTGxMTFowTDNFSkhiNzhaYWlTa09VVG1zN2QxWWp0?=
 =?utf-8?B?VXVTRHJKeUM5RFZCcXRhMHhCSUVxMXNZTkcvN3NxbmFlTVB3MlFPQnRLcG1V?=
 =?utf-8?B?SmROdkJ5Sk0xVXVRSzl0QkxpM3JIQ3k4a09tVjNWNFFOT05FY2Zjd2xXU2JW?=
 =?utf-8?B?RnREb09lZjQxUVY4Zm8rUGF6T0V6VEVyWE9lOXlDRWdUMjVObC9BWU5DMWxk?=
 =?utf-8?B?eUx0SGljdnRucnQ2NmJVL3U3ZWU5L1NxVkRSTW44QVJMS2dmdk52WHVFMXMv?=
 =?utf-8?B?TUZTN0hPTW1RWmkyZk5QSDc3cEdjdjFzeTYwN1hPMzkweFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ek1iNENQZVlpL2ZGTVBjTXlxU3BNdEZ3VmFUcjE3UERsa29qa2JINlNIQWdw?=
 =?utf-8?B?WFpmZm0zL3hpbnBwWktZOVdwSGROMUUwZTJCQml3cXdEYytHS2JGU0MzQlFx?=
 =?utf-8?B?LzhzMENRQW1WcUpGak5qRlF6aXZiUDByZjVLRUpiTHhvQndRUXJaL0ZvSS9R?=
 =?utf-8?B?VWkvUGdaTzVRaGpYRVR6SGNSUWdiQ3B2UUUzL1VqVVFXaEsxVnZGRmlWWkhE?=
 =?utf-8?B?dUpZSTRLVkpkYUdNTVl1dXd6N2RxdmxzSnBIWnNZWURHNUd4OEdNV3czTXZW?=
 =?utf-8?B?RURUSG9uK1MwOW8zUzhzZUlEZTN2U1pGd0h5RHJBck5pVHBLQklRV2tqTGJi?=
 =?utf-8?B?L29JeXZnYThYZjBhSjJJYTZPNWhncEN5ZnJyOVNqKzhNNzNSeDBYREQrbVNo?=
 =?utf-8?B?L2hpQ2FqZ2M3K21GdHNmbm9XM3NQeExGRVI3b0c4dWcxaTR4NkhqdzNZNC9v?=
 =?utf-8?B?blpqMSt5SUg2bTFWM3B1b21UY28yY0RCWk9zNjhFcXc2dlFNRGVXTnJ1NWRh?=
 =?utf-8?B?K2ZTSmY4ZmtLYkNqbVk3dG1PajdVelhwL1d4RE12VTNJWEJOZ3NMa2RXNDlG?=
 =?utf-8?B?amhWTDR0a05uY21HTTNmOE5GeXBkNlJoVXJ0SU9PaXNwMkxaZTVhY0VRUm1I?=
 =?utf-8?B?cjg5djZLZ2RheVA5aUZNZUVPZ3JnR21TUWtDMWZPODk4aG02bkFaNk55Q1Q0?=
 =?utf-8?B?Z1hTVkpzSjZvN1RubmdvUytWWXZ3TGthOGMxTDBGTEpQYmJCKzg4VytwcFNK?=
 =?utf-8?B?YkEwTUtBSjFpa3Exc2JFZDEzZkJXeGNZOGw0Tm8ra0NvN3pzSVRMQnpoMmVL?=
 =?utf-8?B?UmVrQS9hdE9VdTBJT1RSbjZTYThoY3hkYlBuNXBGdTl6eDR2Z2w3WG5HRkpy?=
 =?utf-8?B?MWZ4R3FlUkIvNlpyblppUHZFWk1qa21WYkt5Yzc2cm01ckROanc4dk5Od0pr?=
 =?utf-8?B?R1MxV0x5UTdlYnVoY0s3c0pkQ0tMdWcvaGxFbTNOenVwazA5MjllMXZEL0dQ?=
 =?utf-8?B?bWJpUVhEOWVaUEJnYi9wQ3NTNHgwUkpvQnZpT1AyNC9QbDRTS1g0QzRCcUVy?=
 =?utf-8?B?dWRZMkh1WDNuRDBaNVQwOFh0bmhCVGxjc3R1RkFscENxUXNFUkRrOUhsQlJs?=
 =?utf-8?B?Z3RtMDd1bDhiT0RSSERzQmFwOTdhcXB3ZThSNWpsRXNIeWNqV2wzOExxWmFX?=
 =?utf-8?B?cll2NU82UlZUODlUVzltWm8vK3JDMU5uU1phWkl0aWtjc1pvMmhvaUI3cTdQ?=
 =?utf-8?B?WEVsaVQ3bkNmejU4eUNCUmlJeGVBSVpuODZPVjdxc1VqbDhFd3B0RmR3MTBV?=
 =?utf-8?B?b3IrZlNqeGY0ZkhQUkZ3M0JSU2tNdmVPZnJSc05kRmFkVlhQYnYrVS92dHFz?=
 =?utf-8?B?RjJjbmE3WVRpU3FKeURiaVRUbEphR3pTcUZveGF0cnA2UzBvbXVKYWt5Q1pL?=
 =?utf-8?B?RlU0cUpTdmc0M2l3U0Z1VDE2VXBwVXg0aVBIY2xIRU5ESy9NekFsWnhxVkR6?=
 =?utf-8?B?Z21EbG04elR2NjZ5YlpPUmIwWXlUYzhhYWhxNFRXTmwrR3ByTXF2V1QrbTZF?=
 =?utf-8?B?T0NoTktGZmxTbDFuVU11N0FKWmZtZncvOWlEaElFR1BPTFlzZTFkdUpzT1hu?=
 =?utf-8?B?aHpQUHJEK0c5YzMybnBqK3ZyRjZ1bGFMb3J6VW44czIrMGFub01tYk9KTjNU?=
 =?utf-8?B?Vlh2K3JlNldybGhiMlhOaFd0VGxyT1hONUoyanhTa1dhRkhSSXE5S0pEVUta?=
 =?utf-8?B?SXBMVkRNM3VYOVMwdVloMmFBeUdMQjJGbTI0NmNoYm5SNEJmUXExeExlU3Vn?=
 =?utf-8?B?eHBXOW04NlEvaDBybTgyd0dUcXEwSFUyeUpybU1sYzl0VStuNHZ3S1hYalRn?=
 =?utf-8?B?aEFVTjBOTnliRjE4TU1nd1lLY0xRdTZxbWRUZ1czbms4ejRLZ0RBRGlTOWRL?=
 =?utf-8?B?OU9odlFlWG1nc05JdTFhU0t3empVSVREL1lxRTA3WVZRSnc3QlFaZ3NPa1dj?=
 =?utf-8?B?RjF5bzI3WkpPREVaYUgyWHJxR0VWanMrck9UcENoNFQ2c29uUGJmUkljL1pj?=
 =?utf-8?B?SFYwbkM3RFRDSG14SkJMZWExK0p4Ny9Na3BZRDVkOWVvd0NnbGdUdTFXa083?=
 =?utf-8?B?eVpsSGRrVFdyVDJveG1GdU11MVltOW5PNmFjUG0veU4wMGp2c1dtd1dzckxP?=
 =?utf-8?Q?qEXxA8npikXXckzH3V06BJ8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jw3dvf5zGG1rsm6X6UTNYNFxY6jo/bOynxpw27p+gPindEydch5CT4xgT2YLQBXixSrKphyVAP+OPaZLAHb2YqZptRN+OA7uphUjR4Vb9woahqQfGiOa/4okXoN1XunlJpRkhx2z38nXams8MxZQi9fnew6LnC4ijGkZ1QB9QlL6nDDmukSqwSaL2dBeeR1V+V5PGB4c07JcqaLMLEjU9I2J9fvSm+SLu1m5VMKOvFEyUf10F3e23klMg838J9WR3BYsGbju8TsGneLhl3U5YAUHe2ynzkJ6DQXcoPFaNygBTcgE0ekQbr2CLB5k5dWWGNiQVRA5tiSxDnpBaf2/8sixr+zvPj9faSsQVAiTWlXRb/m/3qGfKgSGscQ+98IAkw0xPH6pKnp2rpiuNUpG5maGJDBzqPN5mtXSIEyl04Ly5lCiQ4A4eL4J6d91RwYywnCOpbFu2CMPbhmmsFcsnCbM/OqRVrM4Y/pRW+7wTdpO2zbqm9RFDEQN4NX2KcpcIZpPV1ny9KIT75W85Kz4iLE8IlstlHCiJgyimoH6ijdA8dqjDc5V/gQv4aGeRvXs44IpKy4MjWiInJ12NteAtUfeopbBgZwwSUYqwfgX+90=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977db9cd-669e-4e93-8f3f-08de0c31566f
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 21:25:17.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BuWjOs1p15rlzgUlGl3Ghvx2vgyimiEQTFvCoOByFY6PzU0LfW/LdeGp//jRpVuxMtY9kZoG6tcFlf1HbZGPGzxwko2mqdsTMfZKj79TNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-15_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510150162
X-Authority-Analysis: v=2.4 cv=SK9PlevH c=1 sm=1 tr=0 ts=68f01142 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=FOH2dFAWAAAA:8 a=yPCof4ZbAAAA:8 a=elhk0QVJPjkIbxAWzaMA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12091
X-Proofpoint-GUID: 9GTdEwpDe7PT7I5htzkzkCSSulkaBPM_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNiBTYWx0ZWRfX+wvoI1gHlyig
 cIAASuDCkCzpU1xdigq1IKNmOZQHBh3iY3FNT+h7r5QuuIDwD2Qzl4R1g4sOZ2OV3AL4QH7xMnr
 ULAGtYQJW4WOYEBPQKpf2wy0oQCLPFmE5VdpTKmN+pPX/V6mMx2fmOeklag4w9EtHA5PdukCvQ4
 gHoISTUjf9HrW9y2dfPG4Su9DStYmMg4foCyt/nUSF6ZiSliGt4W/U9aL+5GivjjMhisW1rd7Sl
 5PYm6fZdQN1/xmw4jgyPrTV+UPRPgp9/LIbi1vd5o7mRMgiE8wa9xI0VCKIY5Pywt9KNZ1WE5dL
 oer9CCdY9xpPsB1hGrx/yE8xf4/6JF8fUeCT9vqzn+mdJNa8FGfHU6TkfPoX/6zYytFXeLkSA0+
 PBMffM0INnaCkwPAIcE01KVUrrx15ceNXqlJLu//PKKccAp9lDs=
X-Proofpoint-ORIG-GUID: 9GTdEwpDe7PT7I5htzkzkCSSulkaBPM_



On 10/15/25 3:24 PM, Alex Williamson wrote:
> On Sun, 12 Oct 2025 22:32:23 -0700
> Alex Mastro <amastro@fb.com> wrote:
> 
>> This patch series aims to fix vfio_iommu_type.c to support
>> VFIO_IOMMU_MAP_DMA and VFIO_IOMMU_UNMAP_DMA operations targeting IOVA
>> ranges which lie against the addressable limit. i.e. ranges where
>> iova_start + iova_size would overflow to exactly zero.
> 
> The series looks good to me and passes my testing.  Any further reviews
> from anyone?  I think we should make this v6.18-rc material.  Thanks,
> 

I haven't had a chance yet to closely review the latest patchset 
versions, but I did test this v4 and confirmed that it solves the issue 
of not being able to unmap an IOVA range extending up to the address 
space boundary. I verified both with the simplified test case at:
https://gist.github.com/aljimenezb/f3338c9c2eda9b0a7bf5f76b40354db8

plus using QEMU's amd-iommu and a guest with iommu.passthrough=0 
iommu.forcedac=1 (which is how I first found the problem).

So Alex Mastro, please feel free to add:

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

for the series. I'll try to find time to review the patches in detail.

Thank you,
Alejandro

> Alex


