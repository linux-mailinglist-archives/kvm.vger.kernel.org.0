Return-Path: <kvm+bounces-35109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF54BA09CBA
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:57:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E570C7A464C
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 20:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34DE215F40;
	Fri, 10 Jan 2025 20:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="icmTzAs4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VuaCfacv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F1C2080CF
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 20:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736542647; cv=fail; b=PuhSiMbrXB+SlSMOPvFuXgMYT7v1q3Vrb/PRCnkQUhPZjnFpQCLhbYsPnBKjn5tQDTwZOuVVi0h0xdnI8JaFoETljLMNTr+iaiBDBBS09agFgtpz62IC7fLd+vmETN7un4nXzIRNWG73QTL1dyfdXodBeQzKjUROS1zyp1ksoxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736542647; c=relaxed/simple;
	bh=wC7K02IYqSc79tKCn3YOOmoUwbGhHQEpYaO85yX53Rk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RlR5IN08Tb9142zlBj5XUHUYYtpFoQqcaxSPlpD6RAYpGgG+XaeZxkW+GJX0i7aVrlKnTM0+RYvPDfdyMBMYm7ttyfy6odQJDHeGP3N/RKdPeKNa8JzWHMYkcUuJH4XvXP/sC7q0HMQUPABr+8CyujoZs0B28qsuKKjbQWzn8Ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=icmTzAs4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VuaCfacv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKuId8022166;
	Fri, 10 Jan 2025 20:57:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kCZ5F1gD4l0efLAjYXxPk6CD1a54or951ymwQIta8K4=; b=
	icmTzAs4Pp/hNNdo7J4Fwq1T7k+6Sll9daU+XT8k6r1s6k+ZskJASkL8/zFcFSbE
	n7iviNe9Dy2eqTN4BjMwfbVAu38KEjjLFGNKo6nSwFHOOEQJwCdMIRCX7aUHljWw
	MAOO0nvROWfRdRBF25tjKP5Gy3wTdvsEfB3o3leS1k7fEFMlLdd5TIrN1JIhRfHO
	8sLOAQNcpLTez+MaCgjaaRG5bnnSfaPYdWV005AKUGCZZOvBaDIV50Z9NutUTI5M
	YeZP3jqBCHOi1yPg2i+X38iCi5x0lvtajSanKTVZDy4F94FufMopV4zSA99mF4VT
	udZ3zpcXEBBpNv3KgJgBBQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1c3pqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:57:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKlmDs002803;
	Fri, 10 Jan 2025 20:57:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecw7ag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:57:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzC8sY4tJv0LWdBQpsXYTgjl4dq5oPqVU+uMDV/k3o8rEn3agF/5T3ILjcOVK3uRnkeOrA5wwnXyfLbJsfxma0P7Q0xJ05hI8WnBg1waePfxRFC/DMbuxayBxihGkmU1mYAlzk3c4KFCq/w50QLC6zNwcxyl0Xq2taqpnj51lEvJ+xwkrCSgM2RFF3TorPxY98adeiwvcjDZfLPNNmRjMGBZbCePIYghqsc8XcmW+S9HB5xovy9Yfbpb4+PlbR15luu/7OQUZnSm1W7csb7Aaqw1zSqhBqfQQGF15Dv+aJAQMX+qrOTm82zDrIoRGnd3vVBt6HAjRJOKPjMSB2k3zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCZ5F1gD4l0efLAjYXxPk6CD1a54or951ymwQIta8K4=;
 b=yjral0M9UW26Ye8FRPA189Hg6c5keLBmNUrgariWp+/iTxDpkfxD9gtOqM7ErHJWUNfHKke1blaAkJ55RE/qCaKxtrQtn0eyRRPVRdtKvoGB8kVyM9XWq2wn5x++VxeJS2wID+BLCwnE++LLRCXhEQDLkFvNLZPAVkZj2awQU3fVs8F3ZwwJP/ChsOYAc1hIuckfTCPA60IPc8QKyyUVeIr9oGwMh8nP7M4yy0H4VasynRgUiq8+GoVtbnFLpHdn1xyqdCHqzwHjDIbAsM9O4vYptqupm6f1a63cfE9Oe3aQb3tx6oird2IOwJRQUNjBmQxzEERyiWF8FP7pJ31thw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCZ5F1gD4l0efLAjYXxPk6CD1a54or951ymwQIta8K4=;
 b=VuaCfacvz6okyVcYtoLHZxeci6KI9NelUUgCjrXIbSC4OBsn6adRe/Uu/M08sJoSzLbjUEjmt2Rk7ev9zhO6dA43mBj7VZUDQhRtVSmSTN/hS43Tzc+r/sIMJGOIizSkhTY/bx3BbEEKMqhXu2MhLcMBOzHMvoOD4KXpl68zbrU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 20:57:11 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 20:57:11 +0000
Message-ID: <89b3413b-3e37-49f3-aa50-60d4c5dbc4e3@oracle.com>
Date: Fri, 10 Jan 2025 21:57:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/7] hostmem: Handle remapping of RAM
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-7-william.roche@oracle.com>
 <56c1cf86-9244-4388-abec-d5c48b9217b9@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <56c1cf86-9244-4388-abec-d5c48b9217b9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0009.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dd0baa1-e024-4ebc-cea3-08dd31b95a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGdhYlM3OXp2WkhDSE54eWZsMFJCRFBuOFNqNEJZOGVaNlp6aWF2TEpqeTdJ?=
 =?utf-8?B?THF0cFREU0x0RWRKbjdVV210b1dsRFNrK0JzdTUzR0lVbTQvWGZzVk5DOUJu?=
 =?utf-8?B?bEJHbHQ3VWdDYi9RakNUZk1iZzNNRkY0eit6aWZ0VlpnZVhDTVp4QVFPc2Vu?=
 =?utf-8?B?bFBtU1ZGSlhpQzk3TUtwODJOQXg3M2ROM24vWXVxcktYb2M1aEUzaEx1eThY?=
 =?utf-8?B?N21lMzZ3ckNsMHIrdzNSYzcyMFNxLzg1S2FiRkZUZDJVWENETCthbS8wUU85?=
 =?utf-8?B?emF1eXNvaytDRHE1UTFMdU5BTHNMQlc4TVZlZkJOY2RiNlpTU1ljOG5Eb0Zk?=
 =?utf-8?B?L3JWRUc1NDJFWnJhVk1aVmlXaVpRSHN5UGthR2FjM3JHazdsRWprQ1d1cG9O?=
 =?utf-8?B?NElEcGxiS01iNXVoWnQyS0hreHYvMy9tSkFhejZaUXNScVBObnp3dG5ycnQ3?=
 =?utf-8?B?aFpFVVZUb1ZTa0hEQ0ZHZ3daZkV5a3dZb3pOQWFtcHNMbC9EMjQvV3BsS01T?=
 =?utf-8?B?cG1QM3h0U0RNenVJZFZZZ3NMYStnZHZrOU51dGl3TFpBMmgxOGc1S2tBNXc1?=
 =?utf-8?B?YmczVS9EajMvc3RLazJxZFJFd01XeTdDcTl0aUFpZ0hmVGprVTNDbWZKOVRX?=
 =?utf-8?B?SjVIVDFmTjE0Qy9aU3JWTk82WDRyUkNPc2IxeFVhV2Z2RXNXcmdhNkxqcEdu?=
 =?utf-8?B?M0R2NkwvTVlsa21NT2xKSzYzSTNSVzFIUDQrZUZtWHNBVFQ3NDZDTVNRL3NV?=
 =?utf-8?B?UVZoRk1DNXdOOGpMR0lpcjhxTGh1RkhreDdONEN4V3dqWDRTa0RiajhrbWtS?=
 =?utf-8?B?c0d5c0doc2d5WW1vcm1BcE53T2E3czJsY0R5R25FS0dNY1k0OUhEbHVVRVph?=
 =?utf-8?B?MjJVK1lqOWhSZkQyRStpYUNEbC9BTEVwNnd2VkJWb1NXa1dYOVhXTjFIODdw?=
 =?utf-8?B?V1RrOVh0ZkMvZmFka3VpYnNnTjVKN0FXMUlzWEdWSFQwbU5qb2JJdWljdmlx?=
 =?utf-8?B?WmtucVo0dUh1eWF3M04zSHdtcDBFcWgwbXVuaTY4VVY0WFpMMDRoK3U2Y2pO?=
 =?utf-8?B?QUdEM3c4SnljZzZLM0NkbmVTRWFLN0svYk1RRkwrMVFGWnFjcUplcTVmYy9J?=
 =?utf-8?B?UmhQQlVQWHg3RUxSR3c0TE14L01HcitOSDZrMU9zYUxHMWN5ZHVpK0pScGtO?=
 =?utf-8?B?SXNCbXN3N3NreVVwUDcvbEYrMlh6RnlYRUk4L2UrTWs4VnJ2YWpVYVdKUU1M?=
 =?utf-8?B?aC84SUF5V1NFblVyTUhWWVZqemJCN1JSNmM4ajZVQkFiejlyY2dvazZxTS8y?=
 =?utf-8?B?Zi9WdFNwRTlVNGVqaEpJeHBpYm9ET3V1V2R5WUhRenU4MWt3bFlZNnlQVEFw?=
 =?utf-8?B?Mm9DbUhTMFc5RnpnOVVaRFZMVUJTell0c1ZhdW9OeTJlMEZ6eUdrZ2sxMVM0?=
 =?utf-8?B?bktrMWdUS2srL2lFSVdKWUcwdnp3RWwwNkpnUi8yY3d0bG9odXNoT3JCL0Q2?=
 =?utf-8?B?bnUrU3hYK2d1Wms1TmZtdVFJL0lUeGNIWmxPMjc0czdTcDNoNi80dktJekpQ?=
 =?utf-8?B?SUp0QWRxblMvbnhGcjdBV3Bna2pISE9veWM3UWIrdUpINXVFWG5kek5WVmJ2?=
 =?utf-8?B?b1FsSzYzYTFGMGRyekcySm1EZngwUHQrdzFBK2JqdVJVV2gxcnV2eGtOdDIw?=
 =?utf-8?B?d2dXbHNIUGxNT1pMSHRDRFdRM2RZUEY1T2xkYy9tUTM3aUdSRm1rWmVOcHpo?=
 =?utf-8?B?dUw3a1kwcnYydEMvOXVGbnJGMkp1ZzVRc3hCYStFSlhwK3hFK1RETHpJN0xY?=
 =?utf-8?B?dGxvWUVLVEdYcGx3ZURQNXQrOFlOU1dTTmQ3MVl1dHNqRWJ2VHJBSW4rTXVw?=
 =?utf-8?Q?B38H75tBMSPO8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L2g4ZWt5Z05VYmRmR0RuZWVUUVNka0hVWW00TjVzZEEvbWNzM1FhUlVTb1Yy?=
 =?utf-8?B?NzQrQm9LcUlLUERCTDUrU0N3b2M2aWZHWXVudXFwbXJJQ2pLcGZQMzMxMmJo?=
 =?utf-8?B?SlR5Z1ErQ2NyMlRwakJQQTRMakJnRGtlKzJtT0VLdGlwZkFCeGFMNjF4dXRN?=
 =?utf-8?B?Nzg3cU9pY0lSTHZhRXBIWkt6aUhsL2RSaFh3cHR5bUhmejVncGMyUXFENUti?=
 =?utf-8?B?dUZJNS9Md25YV1MrUTd3ajlSbVB6dGd2azNUQ29HYWtQbWhxdVJLT3dkQ3pv?=
 =?utf-8?B?WnJhN01SNkM1KzdTcDZFUy9RbHlMSjY4b3d2SXdyK2hpSmNDSy8wRjJLZVZ2?=
 =?utf-8?B?YTFOYzZxbkVJOFhVUzM3OGxURDVLcTFpTzlnRnJBYysxUWtmT1dLVU5wNEZP?=
 =?utf-8?B?V1hMTUZCbnhDWHlUNmZiSkdKeW9HRWFKSlpNYXhFYkJDZ1BINUZkRmxqa1Y3?=
 =?utf-8?B?OTVZTWdzaG1qZWhFOU9md2pXMkQ2OWx3SmNoTW5kTzAyb052RFd3UmhvcFdy?=
 =?utf-8?B?ZWZpN2p5Z3lZRG1vSmpYZVE1V3FpYXhGclVDc0NDQ0ozSDFJZzNBZDBaeWsw?=
 =?utf-8?B?VFNKUVFFUlZLMzg3WHltblMwT1dMR1JjSXdZREViN25jU2JFd0dGK0JMNU1u?=
 =?utf-8?B?aDhjMVdLb2dXS243TGc4aGtuNytqQkpMKzVjVm9teHF4QU52bzNFcTJnQ0U2?=
 =?utf-8?B?ZkhCZnZFTnNZTjB2NWdKeVd2SXFSNFZHOVlCdkt0ZTVEWjdlenVlTjByTjJp?=
 =?utf-8?B?MHBLV1lCR1lCRUtCOGtSYWZvSktmdG84NTUwTWFkZWE0ak5DS2I3R2QyVmZz?=
 =?utf-8?B?RXczVS94ZkFEU01CS2ZnWFowWEJvemxsTXNGblRweGNnVUJlT09GNDZna1Ru?=
 =?utf-8?B?dExxeFpLcUlNNnBZd21NYy85NE1TcU1Fa2ZWS3RXbDRYZy9OaGFsSjV3THFw?=
 =?utf-8?B?ZTdYMklQK29LN0NZUjJVTDMwaFFCZGpkQ1FSaFd3eVd0dHJEeGdCV0E3bFNp?=
 =?utf-8?B?cGRyODNqVEVla3NrL2daVmMrSjROSE9SKzV4eUdJeWpyMkxPeXBmdlpySjhQ?=
 =?utf-8?B?UUZkVDhEWGVYZVpLUVlsQU9qL2M3clJoYTNhMlJQMUxCN3FUdUJkdFFBWWFK?=
 =?utf-8?B?OFRRd05lRENobVJxRFRLbDEwTmlGQUt6WFB4TW9lRTVnd0tHQ1F3VVRlczlm?=
 =?utf-8?B?MW9hRktXOE9kcUQvOEJ3cXA0TFh3YStDWDFkN0JqZ0s3VjNJSFBQMFgrVi9I?=
 =?utf-8?B?Qm81bFk1R0tsdXFHMDU3NkxISk9PMWoyV29SeHJvZlJMdlhMejEvL05LK1Bn?=
 =?utf-8?B?WnpOR1I1M3NBTmZKaXZCaHhNRlJjNUtHM2t2WXI4SWlGbndpMDZab1NGMytu?=
 =?utf-8?B?QURCakpWUGhtbVFYVjlZdXVkSGo2OEdFdzVpWjhSMVlYc2FJeEp3K29DWnZu?=
 =?utf-8?B?YlVUNVRMOFdJTUVKcXUvYUlNVTZWaHdiSEpFaE1ZSHlBeWhMVXF5Z2hoejJK?=
 =?utf-8?B?cDFxc014QjN5WjhoR09lTDBtSnd1SFhESC92M2UyeGdkODY2VE91bFh1TW1x?=
 =?utf-8?B?QWR0L1V3VlNFU0h1OFZ2YjJaVmZFbnkrZHZtUllyZFRETkJVZnZxTGV3bmlj?=
 =?utf-8?B?Z0lFdmMwWEEvUFZhRklBZW8vOWo5bU5nblVVRzVJQ2g3Y2s4bWZhbzBnMitv?=
 =?utf-8?B?NDRFdHNrTDNkYWNPOUFKRThFZ1AwcTNBZis3eVZ5K0NqM0xMOTh0N1pZQjA5?=
 =?utf-8?B?bEt3N2xsMGhNc0g1M2ozczZxWHFkUkZJQWxjeU9QMTg3K2thQVVDT0hTZkZE?=
 =?utf-8?B?d25lRnZuYzZwL1duNjJJSW1Ub0NoSWt1WE9QVXlZdXJtUmp0VWFLYjJtbmxC?=
 =?utf-8?B?Mnc0RHkzRm5tMm4xdDF0ZC8xTW9VMkxXaGxrVVFWQWoyWmlNUGpoeEkyaDBD?=
 =?utf-8?B?VzlJbDd2ZDhjRnBRb3RIdjdjUjRZNDBydWw0L1N4anJyRjFTT2hhVnlpMHo3?=
 =?utf-8?B?aDJwUG16NWx6SGVDQ2RneUsyUytORi80bmVwWC9pVEpXUXNVV0ZZMWU5V0cw?=
 =?utf-8?B?dWdXaXlBTWYxUjdHWjJ5VFVUb3A3V0dyczh3OG1iWU5mY1dyNzlkUkYwVEQz?=
 =?utf-8?B?TFY3ZlUyZHlxTVRnMmZ0cDhkdXFUdVBhWDk1L2xsc1d2R1FnZ1g2VzdnLzQ2?=
 =?utf-8?B?T1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qqVN/jpcvp+1ngmIAoZ0x8amJfpF/n/llwNxB/8i+u22/zOCerRwJRqKKAbgKMwRQc/lHsu0O5jPSDCm0sDY1vlH8Dwvehj2GnOGMe+XppMvzvM+2a47c3Y4qeE6A7bSbCphRWCP/48GuzEah6T8/HHlhl1hzdcqpovdDj57i/w1aCTcHX5bXK+Y9g9+SVZpDIihiMVyl9hMw1HtNHHmND9sy3AieKSSEEXurTdm1WcWW3LjgbeXhwrFZiz7/JPZryaOoK8nOzLeMf9SvQw0MO8TLXXFJEC/trbKAo2EHB44KkhZk1M9oqxmut2ToKi/odPf9yvrju2u+PhXKApy4nXtPo0yiR6ngjU5gnmJRDus90WbWbYS5muhIme7C63PFroQhSne9d45tF+1rU7wLznmXlHfxDRY7gnoA7CcA8vf7YVQDQT890YgJW3ExJCYbOUL57vqHtl0T6iXrSqKpNXljMSGeykm0UhaFAAzFYs2FUY4Z5DsPb9l0SB3ZiUjH/sD/cdqNopnfXIj6U9P1ZfRlOwn/t7AhoJ9fQ3WpFdFBSEDWEWOjfMT4twJOJvjPefpnWWk6v/A+UNmts9jfozTRO1OHylVuDeWWDR28Tk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd0baa1-e024-4ebc-cea3-08dd31b95a80
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 20:57:11.5569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MHZhGiLEMORNW4G/O6pQC7AzGJymaDhL89EeOGJOW1aCNEKhIUhU0vwDV2m2mVEoi664mEmwSzn6eR55/seu/CL1vadOBFZ5Blf7AY2+fXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100161
X-Proofpoint-ORIG-GUID: JIs53TrrsQlt-h7ks7HrNYT5ZEQedzm4
X-Proofpoint-GUID: JIs53TrrsQlt-h7ks7HrNYT5ZEQedzm4

On 1/8/25 22:51, David Hildenbrand wrote:
> On 14.12.24 14:45, “William Roche wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
>> Let's register a RAM block notifier and react on remap notifications.
>> Simply re-apply the settings. Exit if something goes wrong.
>>
>> Note: qemu_ram_remap() will not remap when RAM_PREALLOC is set. Could be
>> that hostmem is still missing to update that flag ...
> 
> I think we can drop this comment, I was probably confused when writing 
> that :)

Note deleted from the commit message

> 
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   backends/hostmem.c       | 34 ++++++++++++++++++++++++++++++++++
>>   include/sysemu/hostmem.h |  1 +
>>   2 files changed, 35 insertions(+)
>>
>> diff --git a/backends/hostmem.c b/backends/hostmem.c
>> index bf85d716e5..863f6da11d 100644
>> --- a/backends/hostmem.c
>> +++ b/backends/hostmem.c
>> @@ -361,11 +361,37 @@ static void 
>> host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
>>       backend->prealloc_threads = value;
>>   }
>> +static void host_memory_backend_ram_remapped(RAMBlockNotifier *n, 
>> void *host,
>> +                                             size_t offset, size_t size)
>> +{
>> +    HostMemoryBackend *backend = container_of(n, HostMemoryBackend,
>> +                                              ram_notifier);
>> +    Error *err = NULL;
>> +
>> +    if (!host_memory_backend_mr_inited(backend) ||
>> +        memory_region_get_ram_ptr(&backend->mr) != host) {
>> +        return;
>> +    }
> 
> I think this should work, yes.

Good :)
I'm just leaving this unchanged.

