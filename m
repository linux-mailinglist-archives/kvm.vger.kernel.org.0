Return-Path: <kvm+bounces-31652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA7AB9C6407
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:08:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19B89B24773
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74CD3215F47;
	Tue, 12 Nov 2024 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TujV+pKd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dHyFPVOY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95312144DD
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435483; cv=fail; b=qOVPRal6fEhaYPoSbMMfyovRpF3PoLbRNeuaXXvXy7gHkHYMNjhUVtRuYdgyFQnOeppa93TRGfXBQVZ2f7a6Iy9CL1yce1bX/39cPG2lVxs/YdxnmnT3/YTI+oBcnGVym6hZfnxUi2xjUc62F/d2n8mWSqJStBEcZVJk7w6ZcDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435483; c=relaxed/simple;
	bh=3bzP365r3xsHRaTy6rBdyxJTjGu7c/1lJWeJO0pBavc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LVi0u3WeB2NfLUF9CO10rKujovQLQjH61qRFah1LhiSN325Yy8iGOmcE1Wp6qHnhNO7sniZErlbyqutQA9so4IYxySyLBV0FTy0eEDAlYhulSMVa2NpbOz1NmF+2Lc/NKXB9hi+Qt5HiWjnJFMNLs3SUNKFvATztBOTBZyJ9HlM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TujV+pKd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dHyFPVOY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHtdSW032325;
	Tue, 12 Nov 2024 18:17:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+L1aHS3/hMxwtV4OC5DzImukzCHpfAAsPb5ao2k+ZzE=; b=
	TujV+pKddknbtLsOqKZBwkBRUB9oacEX/NsmX3OvR251jepPPdwIlKKkCWYUAnpI
	PGcRNex/UEBjA3MeT822ThEMsPxqxaxd9Tl+3AGa472Hti6dja14zGbsWzJ7V0NY
	Yc2U028ObFyujzWCvuSXKmB94cdzqV4muvlBkdtkPZKqPo3aDH0f+JgdqH402jx2
	qXe5FUgzq2ztSUe2kNx/aUDhjZHwelE2we1hal6CjLNxapicH3caF21LeWD+J3wv
	RsM87qxUdZ3b169cjUnDujwLpGK/tVfU9SQ6GeuJJx4yeedhBdv9dsRHrt9OSw+l
	ZasK+8hwAG49xYrojxqhkQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k5d12j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHLCPJ008079;
	Tue, 12 Nov 2024 18:17:47 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68gp9c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=urAk0/3S78SL++cTYAP9Ca/nbP6/J5IsfYNd53Xj/gR+cCh82I+UfcT4gwotugHmesvmzU+j8F/MMYoSTuGZr4e99xVPrkUZNAviGoDsLc7pUTBRtGe9zXj2lDntUvLLreZ8Refe0zg1E0uDBKSTOyVIgpECroHW4T8CcW1DI7YNYx0VF1cItKw0lvh1VVik61u0fAyR+YroXn6F1gli/Dpv/ZH612vU93MkjtDjrPPspyteCRTp6X/FdDpFdloaodT6iObLM06zv33gHNL8wS9CNKmbgOjdFA4XZ84LnMOAEkPq+CWBrTZk23ykMB3Ofr5gGZCn59X/auflpAMjfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+L1aHS3/hMxwtV4OC5DzImukzCHpfAAsPb5ao2k+ZzE=;
 b=Xu9kKIlozUzdYXv9DVM2HL2HRXqt2WcvxRfPRJWu5e/5dVfK5OhVd8wAywP6wntEF/f64oJaenZc3+o0jXLg1nqBxqWKh44rbic4zZ5wbjKt2If0ETJbaDYer34m7AAQTxYMF6azOVGbqaQxLiR3fTzd43t+Q186MJYdbhVvM2tZzBaYcz3wIdkcLi8CIwQ6xyLOmFibwPZyV0M1lZT/4kxAiuj2ulvoP8SfNaaZjLq4pzR3HipvehUyzV8LWVRfStWyo5buWc+9/JG2IseZFgn7gDvrar/jIQQH7oTjiWhRl0Bi1sfKlKrVe5Qfv3JdfGJEHt2zu6UKNiUS0Xb3IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+L1aHS3/hMxwtV4OC5DzImukzCHpfAAsPb5ao2k+ZzE=;
 b=dHyFPVOYSTVzOorfguDKathQDDiBeYIRMtU6hhsYWQ+9JXIZjK3b8L0FBiZflfgCoFVA1rW++ABmPqlKcC47QnRibKRGDNvDRUhJHhSOZVArJ30gh/S3rssXGbHNWo8nqUrDPECUtOQez3Np3WovlYW+JxR9Pg+f/dyKxJAD5Lo=
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by DM4PR10MB6157.namprd10.prod.outlook.com (2603:10b6:8:b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Tue, 12 Nov
 2024 18:17:38 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:17:38 +0000
Message-ID: <08e03987-3c9a-49b2-adf5-fd40e7ede0c0@oracle.com>
Date: Tue, 12 Nov 2024 19:17:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] accel/kvm: Report the loss of a large memory page
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-4-william.roche@oracle.com>
 <f5b43126-acbd-4e3f-8ec4-3a5c20957445@redhat.com>
Content-Language: en-US
From: William Roche <william.roche@oracle.com>
In-Reply-To: <f5b43126-acbd-4e3f-8ec4-3a5c20957445@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::15) To IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7349:EE_|DM4PR10MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: d4117506-587c-4918-6ff5-08dd03464a01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVB4cWlhWjJJMlp1R1VkWkNSUFFDN3hKWm5aY3JjSytvZERhK0M5eGNnZENi?=
 =?utf-8?B?cFlNY0Z2bUR0bkV6VUNxMFpSQnJzNDlEZ3ZMczdDMVpxUEpNSnd3YkxkS3BR?=
 =?utf-8?B?WnVkVTJRQkNMVENQMkJXelF4eEQ2azVpM2RDcE9vVlk1ajQxUVNCOXpKOFRO?=
 =?utf-8?B?K0ViMUFtWS81emNZc3RsUnM1RVRsT2x1SnRvYVZKNjJDTmlyM2xURzdncjNN?=
 =?utf-8?B?WVRCTEVrL29FTkNhdHNVc0dLQlFKUytZVGNHMDI4N0ppNDlkNE54Z2o4NTBv?=
 =?utf-8?B?eC9QTDUxZ1h4T0VHOTJJZ1lnR0dLd2pKZUFFTjZsWEc2TmduM2lqbHZmdEFI?=
 =?utf-8?B?MEpTOTlNTWhvWXJ5dmhhdExUMXBmWlJ5UXJLTE9kRjEvV1dNeTZJSExlbHV4?=
 =?utf-8?B?Z1I4VDUvRzc3R05LdzNhS2pYNTAxMUF3RFptV2VndTBwUk1BRUs2UktjUUJn?=
 =?utf-8?B?bGFaRjdrSlFsdS9UbDVEcUhTZHlIbUtXWHRsTzBTVEw5VFJLMXR5dkFVTEZR?=
 =?utf-8?B?Rmh4czY4MHhpbjFiQ0Z1MHRhTVdxZWNucm1sRjdQZFpIWGRUNGcreWU3akEy?=
 =?utf-8?B?RVlQK1duaTEzZW9LK2dTWG16dU9aNzFqYmUzc3NVVGNJTGVnTGVWelU4OWt1?=
 =?utf-8?B?Y24yTjVxWENPTkZFWk1lOWFaVFgydVlkemFBK2ZmYWgrYjZvYTg1T0tvRlBT?=
 =?utf-8?B?R3JyQS9tVkNWemRTZGRycEdhR0c1RzFLVWJnOGZxT21NbEduMXJWOTNKcStL?=
 =?utf-8?B?S0ZsbEluemZnckY2RkZhWVNjd21nVEZ6d1RZUEFmMC80RXZqaU5oYzVqd1hK?=
 =?utf-8?B?NFZubUYxWHN5WEh5OGRMWnZQTjRMM2pnc0JjRGNSazgraFJnbHhCTGs2dytB?=
 =?utf-8?B?NDQ3K05xNWRhOTZHK1RkQU1mUGYwdlVNdjNYZFV6QlAzS0Q4NWZwaGFqTXMz?=
 =?utf-8?B?dVVOZ2FzOW8zdUdNLy9FUXdlRW54MGtJcnk4U3VqVk1ld1d4UHIxRDU3emtX?=
 =?utf-8?B?SFRWTHBmSjlINTh0S3JJT0xmNFZCOVU2NjFhd2p2eU1BbnhXVTB5emJ5VzdE?=
 =?utf-8?B?bjJRNUFELytzbnNINW5uaUMxOS9aOXlVazBUSGpTNVhXUGI0blFGZ2ZETkVz?=
 =?utf-8?B?WlArdW9OdDhTT0ZNN3dTNEMvcTBxMmdYdU13eW5wK0JlOXVjczBzY1FXS2N6?=
 =?utf-8?B?d29sWXBqRk1qamo1T3hMRDlNRFdNRmNJVm1mM2dKNWRVcHY4SjlMd2xMUElG?=
 =?utf-8?B?TEx2MDQzVThCMlJvWnNURHEzNU5Xb0srVUZIcDFRemZIUlI3NUk4TXU1ODJH?=
 =?utf-8?B?T2FZZk9Ock5rQk9EQ2dYVngzeWtaVkJCRnJHNmRmemtLekZoWVFJU0c4MnJa?=
 =?utf-8?B?eVV4Y3U3ZFVGVUJBUW9FeUZWdUlYbFdYYWkySHpIamxhaUsrMW1VaGE5TDJL?=
 =?utf-8?B?VjcwV1RYYUxGeVJ1ankrRnU3OElBVXlQNCtodjJLSUVreG1IbXVzSDhManJj?=
 =?utf-8?B?SVFUeWwrQkZocGpGdjljeUNDUnFBcyttSXkrQi80RXJBRGNvUC9jNERpaURq?=
 =?utf-8?B?aW4xSVp5V3pMbDBua29FMkJOck8xZlJLd2JsdE84dkNLK0lORVdUYjk0K1Zr?=
 =?utf-8?B?UmcxUHRlUnBiT040dDFFSGpiNXg3WnBkQmx0RUlTUEtxRHp5OGJKSXJZYWR1?=
 =?utf-8?B?N0FqTWlLZHNxMWcrTExtcmUxb1lIUThuaEljS3ZYRWNCVkQ1a2szSmdYbGI0?=
 =?utf-8?Q?hsnMePgaqa0xfAgIhnQIG1U0rsMR/FJy5xWX/lF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RksyeHVoeGF3eFd3dmEyY1E4RktyOFlGZ0dMTkEreFFFbFUxNjJjQ1pmbWha?=
 =?utf-8?B?cHI3TE11OXNWWWlPRExYUGNiZ245dDIwR0h4clREaGFBejlnQzRnY0dEb1Jy?=
 =?utf-8?B?dUdsSnJyMkU2WE1Qc3VmUUh1N2VNUXZCb0dkanh2VXlITTNNL0tvZGFxRHBz?=
 =?utf-8?B?NmtCam4wZkwraWtmNFcxTWFxQTF6azhCNDhSSGVVNUNBNXY1VDVBMmM3NnNN?=
 =?utf-8?B?L0poSWd0bk5WekZEVE1UcUhFS3AwRGFTWmxsbzY0SWlkcmpmQlJNNzdMU1Fu?=
 =?utf-8?B?c1lFbGVIK0xJRjRQa2xrRk5UWXFENnRNRVkvY1BXVndKanhodXJzVUNBdFZQ?=
 =?utf-8?B?dHZQQko4NUFVRkNSeXJXUkJPRGZCT0ZDWm4ydElkRUFXbVhLVUZscENyMStN?=
 =?utf-8?B?WVNpOGkwT3NuZmxqWnNSUWtQMFFwZW96Wmd2Y29VSUpNRlRDdUdUZi9qclVL?=
 =?utf-8?B?MmNJTE94N0wxV3ZsS0NDNWkrNGxBUGg4ekh1NVVjeTErTHBlSkJYY01JOTkz?=
 =?utf-8?B?d1lLWjB4NjhyREExRGg2SjhHWW5meEJKcjVreXhjWkR2Q0F4UGRydy9IOXRP?=
 =?utf-8?B?YzdUTWhNU1hUL1hFdGNXbDB6MXJTL2VSQXVUaFExV21nNVhhUkRPcFlJNlZm?=
 =?utf-8?B?QmxEWjFXVVFsbDJDdmszdWMwN0dKUE5abFgxS1dVS1kyKzNKU1FySFVkQXZq?=
 =?utf-8?B?cU1KMTZXcFMvT0lMRW5FeTJkb1ZLUllMRVlUT0NhSUdtU2ltS3dYbEFNZkg5?=
 =?utf-8?B?UzVpQmYyck1zem5iRklObXJZbndWc0t3UEp6b1laWWdGWEd3Ymp5VWhYZ25s?=
 =?utf-8?B?SndRYUdNTWgyZ2VxTGNnNFZZRWl2SzJVUGp4eWlXQnhNeW56MWY1SFVJQmdZ?=
 =?utf-8?B?ZlZrVExiMkRRODRnQ0F5UFFZcis5amI4cm1RUU1NcExENVQ4c1pQcVhzRm1z?=
 =?utf-8?B?WE5tVGJsdWhGUnNNeXI3K1VQSTltSUFDUnhiMUgwRmExWWk4ZGR6c0VlYmwy?=
 =?utf-8?B?aVk2QkFTWEdpK0d5V1ZxM2p6NVJQcjlMYlFWSVFGQ0dkZVFBSHB0WnFJcU5J?=
 =?utf-8?B?N1B6Y21QMjJMRlN1NC9QenhWaDB2RzU3bEZycEh3QWVKaTVLa1pUNFQ4NTVG?=
 =?utf-8?B?Z1VLeUVuUUdqejY5bFZ1WUJxbjNLTms0Yy8vclNLQ1VjaFN2bjd6M0JUMXBv?=
 =?utf-8?B?cXRoblVlT3orS2lVVEpSTGRtdFc4QmNMSEdlVjIreWhHRitraExmdEhYRWdy?=
 =?utf-8?B?ZUtCOTlBV1ZCcXBBcy9XZ2lVWXpMKzRVMTQ1QXJ2QytrN01QazY1dlBBMysx?=
 =?utf-8?B?N2RFT3NBTDRKMnlZK0gvT2tEQm51MEdIVjl2V1NCZU1sdjBwbDZrZjJESnhL?=
 =?utf-8?B?aWM5MGFITWpBVW1kUDNUU0JjREh2Mml2djZKYzVZbXdxeHRBVDZ4d2xMR0Jv?=
 =?utf-8?B?UXlRM2JvdVhPVjE3My9uQUVGZXdYeEd3dEFQMTdUUHJNUERDNEFURDNqZWpG?=
 =?utf-8?B?WmZnTkpPcEFleGd2Rzd3blhYVnA4aTFPYUNJaUFXckNBRUJHcW1RdUFvZEh6?=
 =?utf-8?B?dHFXa3lWVjlOY1FLSVpnNW9YWi9vYXVKMmo2ZnQ3SnpPemlRdlRNTWxkOFpr?=
 =?utf-8?B?ZFgyQStFS2dKYmI5K21rM3lzUXpBSStiMkVSY25rd3pmMHlWTytFeXR6ckZx?=
 =?utf-8?B?U0VuMHZSYXNnd1lBVDdZZDlySEJ2bGFxT1I5NXRUTC9VZ0tQTysvUmpWVm9o?=
 =?utf-8?B?bUdwK0k5bXNHaktrNDRQY1F3Lzg5SVo1R0wzUlBnVGd5ZE9UNHk3am1WMHBm?=
 =?utf-8?B?TlZOeGY2bFMwY1E5SW01YTlaWjBDTThNN0pSQmVFc3ZUWG5CVE1Ga2cxUkNm?=
 =?utf-8?B?OEJxMHlVMjhPa0RpbU5KRWpVK3hYcE56cTB1aXoxbnMwWHd1QTdHNkJZdlZn?=
 =?utf-8?B?YTdoSmZSVVZtbzVGQ0EzWmQzTW9Sbzhxd2pyc0xGdGU0eXNjNEh0eFNZemNo?=
 =?utf-8?B?WGxmNDJWTFdGdUR4aXpjUTEzM2wvSHFKVUZ0Y0QwUWZrUHFTWVc3aXpyd3Nw?=
 =?utf-8?B?WlVQTFhrYVZZbWVUb3ZvNndVdjZ3MFJ4VU9OQmlFRHhuMmw3d0hVdDZOVUxT?=
 =?utf-8?B?NklGVks5RnIybnpNYU5OenQzKzF4RGtZL1YxdHNxazRmMll1MHArOXcvYW15?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vR6Y1n5mVlZbOCpBDqlXwlPsyo73i26yL1lKw0KGeye1cuRJi2Hw0dbcdz+YRrAJCkyeOQY/1Et2a2+0B+cnCuACvmcErdz/dqv/LmaTM2JkxcgHglyaLpTypMDlV7fBQGUb99MgIawREByEIQZCski2pwlC6kYLVHYYLlAmqNfJxtFZJNWCVvlxHlMQJ0X8iFKPLVbi8zn3p+vhcPJVeH6vOD+dqDSDQPiRYGm8i910njRg++LTvqKW74bbIvxEbdVJJx2ZqncHifoTdghMsc7qqZxwHTnP/rtgc2rewpuXNn/s4t56ZiXK+OrCOYOOqwMNIiVTnWlU3w6raAt2SJaaDEHUHYEgGsEmgvvKcU9lfmSF0+Uk+Sne0z4TKkJb3THexAhV3cERJJzZbH7EPjTZ0+cHyUlihVKMf2B9sYAZJHox4ctQqzmOTlegBK4/QGfcyM78iAwdz4M+UecrfWx/bYgvMt55mWnhzsrIEqgUfRnNOl6kmZkTyBab8zl5MDISTBZJDrVHwv7x+jpB5O5xhE55baVPpt7OxmH3VqazWgCPxeTEjDpLnwUAZP8MCWliVAu9jylNZ+/xVwNkK/aSMJ9OkQkS5YfriTgfPdg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4117506-587c-4918-6ff5-08dd03464a01
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:17:38.2061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62PqvZS2XvSo8v5D5RNNJ0VuKbsdFIygeIJW/TS7bcvV8U/T1fUBAaw4xfu8NgrNQi3yPF00oQt+WZoS8CXPYNuvrGmXp1IFghV+voFTGOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6157
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_08,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=964 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120146
X-Proofpoint-ORIG-GUID: xnEqBUztNS0QL1CSYut1jAkvC1K5NfVN
X-Proofpoint-GUID: xnEqBUztNS0QL1CSYut1jAkvC1K5NfVN

On 11/12/24 12:13, David Hildenbrand wrote:
> On 07.11.24 11:21, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> When an entire large page is impacted by an error (hugetlbfs case),
>> report better the size and location of this large memory hole, so
>> give a warning message when this page is first hit:
>> Memory error: Loosing a large page (size: X) at QEMU addr Y and GUEST 
>> addr Z
>>
> 
> Hm, I wonder if we really want to special-case hugetlb here.
> 
> Why not make the warning independent of the underlying page size?

We already have a warning provided by Qemu (in kvm_arch_on_sigbus_vcpu()):

Guest MCE Memory Error at QEMU addr Y and GUEST addr Z of type 
BUS_MCEERR_AR/_AO injected

The one I suggest is an additional message provided before the above 
message.

Here is an example:
qemu-system-x86_64: warning: Memory error: Loosing a large page (size: 
2097152) at QEMU addr 0x7fdd7d400000 and GUEST addr 0x11600000
qemu-system-x86_64: warning: Guest MCE Memory Error at QEMU addr 
0x7fdd7d400000 and GUEST addr 0x11600000 of type BUS_MCEERR_AO injected


According to me, this large page case additional message will help to 
better understand the probable sudden proliferation of memory errors 
that can be reported by Qemu on the impacted range.
Not only will the machine administrator identify better that a single 
memory error had this large impact, it can also help us to better 
measure the impact of fixing the large page memory error support in the 
field (in the future).

These are some reasons why I do think this large page specific message 
can be useful.

