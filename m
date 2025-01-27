Return-Path: <kvm+bounces-36690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF04BA1FF82
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:16:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D43D918858CC
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559731A8404;
	Mon, 27 Jan 2025 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U1/Pz1Ss";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DX+XAILZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E318C006
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012587; cv=fail; b=sGBNEQ8gEIjtBQu8eqebp84uIU4njzs6Sf3SV7oOLZhk8tSE7mICimI4CcZX8P18yHfORbSiYXvrk0G3p/xeb1g8cmEeLTLzbwB/iCQo74IYZPAbFykk/rsUQc+XL8DF5/b4OBDX/EYfhKkXwwr15ollVW19nCAy0U8FLucaLc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012587; c=relaxed/simple;
	bh=f+cnUfx5zsV3UL3vJ9WYkAv88kowWBi3F9StuRCkrxE=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U/70pv4dLSD9APw4olJw2Z3eexRbSrF0PBn6qmWyj+rPfpR7vSgD49jcIHYxhK+nxFyXewxtXFMkJb8ujXnvsSRDgO0VxYGcnTgjcviOttMgAAc6KBzsK8Xc1hNQldkrih/lS14MrSi5RRt1ExPiad3Or9tnpw7bu3c7TFdb5IY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U1/Pz1Ss; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DX+XAILZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKBkVc017653;
	Mon, 27 Jan 2025 21:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=eJ+dQ2PKGyT3SfxEjmRRKneSGg3oWD9Df1c9Dqievv0=; b=
	U1/Pz1Ss6E2TvbWVIr/tk77Q1vQMb5ztIgGZVrKlHBNNCQ//WohDLBXkEQXw1MS2
	SUgYA8drwl4h1/ixyhs4Uug26c6/c8Q1pKjYv5bvQgXllX/Lxor5Q7WafUbJ+5us
	QNoZHl4w3p54DTuszOidorDOmkAwbvGaid7GtSI2riAVjYgo7earWKEaTccdz9ZJ
	RnN6X1gedyiwrp1ftO5KV7uU88tQ7/Y+++rlQEL/FbqKSll/6bFE2ROqKSVI8kkz
	WzOkkDHjru+urJTJNEUBhZ5OGLYjr2afvZ3wVUmL7s3KBLdBg2v5Jb6pDqg2eb6A
	PbiFPZa3KReoKyGSSx7GrA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44eg5kg88q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKiniw036316;
	Mon, 27 Jan 2025 21:16:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7gejt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YVuhoWTIngqiwMk2/vHZkboEImbhLi0WIqsw5zbDGG3w6KfmFfGovlKpIf6d2zmQcTnkIN6Gjx/DgzAtp0fZan0aocKNcUk7Z9VtwlpjBzwQLu4FCp5Kct0k99i+zVWw2o4lEWaLKbfzOJGSTI16cFzq0epKIsUQ1uw4Bpx7OSFT3vFpKDBgpekp/xGcmO+bFl2f7/SjB8+iIBXR4PIUlT+YwTBuwKNfE0PVRez5DlUNWl5V1SAGIMNmFEn1rlnwldX++NUiG2ePVnAqFK3tnQYjDgHWQ6zNrZGBpArZFVdwmeBRCl6wgczxuXXPTpiqsDhgh87CvhvWvCXF73tpbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eJ+dQ2PKGyT3SfxEjmRRKneSGg3oWD9Df1c9Dqievv0=;
 b=LiDriuGmSktsseK0o2zlGeLNPXhYjGwdvU9Mk2HgGGbELwcD7SDJdDvxYQqCtg6ICDex1pPR0BHFUB7YETGRqO+ugZKOyTjGCbqqZHX5/fbBodBNcJNY4jQS67cxvvdx5/yWYIbcdnlC7Wgbj6aDeuImKmss0zCK/3xZ+f0bjZzzpEGIB/Ovb1PNy4vS9a5H1MEQzEJDkzN9p/B3ud1AgHSFyZMELzeJBYwM+6GG4jATpkitXPZgz/kcJ6WGfXyfx0Q2ocIct3usA2wWyykH5eVSsxrezD9mbo0V5Tc2EwwCA4+Nw20q+cFCHPYenY+RlQDiFPc9wjbiuxR2a5V4OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eJ+dQ2PKGyT3SfxEjmRRKneSGg3oWD9Df1c9Dqievv0=;
 b=DX+XAILZl2kNN1OSlTaYAO461L24u5aLcRlQqDte7dfZdBtlCfL+gW44tt3P+9GRNpokoB35dXX9U1rVrY5NOdTWl0MFmO44hTqvU/8ExRtmeWIpq8HWO30wVYTO+xXgdhOXe/yIdu3hqnCQ48KVH3rRYlfHs7moYryErJBRWVU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7938.namprd10.prod.outlook.com (2603:10b6:408:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 21:15:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:15:56 +0000
Message-ID: <16b036a9-5ffe-42e4-8c9d-f85479b9857a@oracle.com>
Date: Mon, 27 Jan 2025 22:15:52 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v4 2/7] system/physmem: poisoned memory discard on reboot
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-3-william.roche@oracle.com>
 <15d255c8-31fb-4155-83f0-bf294696621b@redhat.com>
 <9d1ed0f2-f87a-4330-bf5b-375e570a74e1@oracle.com>
 <dbdc0f83-5b5b-4104-b850-63c0a4ec795f@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <dbdc0f83-5b5b-4104-b850-63c0a4ec795f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::35) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: ac72e3cd-f52b-4cd6-183e-08dd3f17ca1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXRUTllMUlRqcXBCSzZ3TXNWdUZhZVppSkZvK1UwdEd1ays0Qi92eFJJa1BG?=
 =?utf-8?B?VjhCa1VnOTliR1RWemR2RTZRVHhSaHlXMFJjYXBvYWN0UUovQlBTdkpKU28z?=
 =?utf-8?B?Y0pIc2w2a04wMURBU2JHRVh6UHlTQnFpWmFldXcxa1d5M28zdXpBUTZBdkI0?=
 =?utf-8?B?Rkg1NElvOFkyaVlIQldianZZZFpNTGovNE5oQnE1MFNRYU5TQjArbzliaGFW?=
 =?utf-8?B?VFJTK1QxUXh4UVJCWU9mL0VybXNzRnRNRTFJSTJjcE83M1BGR2ZKeW5RVzJM?=
 =?utf-8?B?MzdScUVtTVllY2YwV0JraTdMSkxKN3k4YTAzaVRQRzhUeHN0OHhvNTU2UW5u?=
 =?utf-8?B?cWIzaEt2Q1pRemZWb0M1SnRBVCsxR01oZEdQQWRwUkJiWkY4RjRSbDViRHpY?=
 =?utf-8?B?YWkxa2Q5U25aQ2l4d3BrTmxlQmhXQVFxVVNNZlRFMUNTeXUwQ0tHVkNjNUQr?=
 =?utf-8?B?ckVyQmdDWlBGbzBCUXJKaWVkdFRvYVNiWGRsb3hPMFFMOGRqV1Bqd3BTTmdF?=
 =?utf-8?B?N1VEU1M4Wmw0Sm5wcnU3aG12enp4SUU2Sm80d2dwVFZnaGtnVk9qZUR3SGly?=
 =?utf-8?B?VHp0dnFydStlbTJHbjkvYVBIa3pBdXR2WGljRmk4am5Qb1lzRUo2ME5pS0dM?=
 =?utf-8?B?MjVXUGVQR3FqZ0JXY25vR0lzeFhZSkMrQXhCSTEzUnQraCttNXRJSE15ZEpz?=
 =?utf-8?B?SEk4dmM2VVkyQzJsSVVqYm1LblluZGY5NURtamJGanZWRDd1RnVHL3pBcHp3?=
 =?utf-8?B?UjlMQ0g4YnA4WTZFeWI3L0lxUkFJbjRQSHc0ZkJCcU9jRjJsMFo5ZWI0VER0?=
 =?utf-8?B?YXBSR0xWbTduTXgyeFlsZGdadmNmSTV1YjNXZGx3d1Nqbkd0YXJLQVNLSTRq?=
 =?utf-8?B?dVhNNmNQSGx2WUlxdEk0ZmNxejJxMUJ1Vnkrbzh3QkFWcDAyY3NGQlExWiti?=
 =?utf-8?B?SGRERFFWa0l0RVAwZHB6VlMwZWRCdTR2dE44YktyQmFzbFF6aElTdExidk5J?=
 =?utf-8?B?NTF2MWtKQWxrSVo0TXArK3ZLZkRxQlNKUE91U3o0aEk0YVE4R01FMEhvRFJs?=
 =?utf-8?B?ZjJnSHRxMHpOSXVnVjRWQm1iQ3Fjc1lFNVNrVWN5UEZLQ1RvMVdtNzY5VmVm?=
 =?utf-8?B?bkRFbjIyMFFMU0oydmovRTFBZzZPZTJRbmZvdHgwZ2NmRE9yaUQ5THpzSk8z?=
 =?utf-8?B?TVVTUVd0ZmdvUWlyMmkwVzBCYkZVVUs0cUsrUXErMW9kQzB6enQ5U2N6WVJZ?=
 =?utf-8?B?a0crdit5VmtaTFlCWXAwcFVxSmdDa3FtajA2RlcrdTR2UlU1eG12ajhnNjVx?=
 =?utf-8?B?cGlESnd5dHVwOWpaMk1WcVEvQkxhbXlMejAvaUlSNk43NXFLWEd0TGFxOUtl?=
 =?utf-8?B?Q2dYbzdCOU4reWRjSmszMmtHSXpOVnlCWmNlaFVIcXBtbFpPQktwbk9HamRB?=
 =?utf-8?B?cy9GVXZiOHVWcDA1SEV6UlN4OUt0cStBNE83R1h1TjlaNDdEdWxVcXNHRjNU?=
 =?utf-8?B?OEpKcXRrVGtXQkhqRHhmK2t6S1Vad1hoV0FBWkdrMnVtS1JuVlBPZ2R0bDVr?=
 =?utf-8?B?N3piNG1XcEZOM012akxoRFRZbE96QU1ramZYQyt3Rk0zdUxOYk0wSktjU1Ra?=
 =?utf-8?B?K21vbzVTckE1YVY5TXd1ZFhtbTRsTDNhZ2VxT1JyVU1VQXQxSVRjeGV0bGtE?=
 =?utf-8?B?dHlOQVVQTTFibjJ5Und4d2MvS3I0MVJVVGsvZ29sMjFKeCtDelZxN0xNV2xs?=
 =?utf-8?B?Y0ROTkdZNFhQN0hWemVtbTFmN2Y5aTN3NG5SUXlXTXo0N2FEUmxpY0hINFBz?=
 =?utf-8?B?cGNmcVhVUmtVSW5iYy9oM1oyS2dYOGtMVUYwYXFYNWRBWmxNQ2lOTWQ0RVJr?=
 =?utf-8?Q?Ich1frKPzmX1P?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dU43SDQwa1VCZW11b1QwU1pIMlVYMjlHS08vL2oyTDFZZjdETFBZb2tEcFNs?=
 =?utf-8?B?Yng2U2NSeDdTZW9tdHFqcmt0cjZWeHFlMFpOd0ZDQ044eXdCZGVVMzNFeWJl?=
 =?utf-8?B?aHhqRktpUVpuWHVlZmJGMEVyeERpZ1R5NFcxbFZmekJaditFR0VGcFBFNkRa?=
 =?utf-8?B?VzJBS3pOOG1idWdFYXQ5OFd0WHg5dCtUdXE2Ulg2L0MyNmNIcSs3ekhpVU5R?=
 =?utf-8?B?T09CdWUxSXAvcXU5eGhTUDM2SmprbHgrWkUyQTloMjZ6b3lOOWxVQjNVTGp0?=
 =?utf-8?B?dEtvMi9mUlRraWgra2VtekFmelVtMEdDRWZlRlhxUkpmNlJXU2R2amYzY1ha?=
 =?utf-8?B?N3YxQk5TNmNCNWtVT2lJRnZxYWJPNkh1TVpHRFd3ZVVHekRUOWltbHBsUG5u?=
 =?utf-8?B?NWQrK2Q2VkFWUktBZlpHUm95QmNaMTBwdEM0eitGSW1ZclV1Tmg2MUpEWWhp?=
 =?utf-8?B?ODZpczdVMmkzWE1Xbm9paXpiOGswQkFMMTNsSzRnMkVodFkzdFdpc0huL1Jl?=
 =?utf-8?B?bFNiUGtIZ3Z3U3JZL3hub3ZmVFBHdEVFQmMzN3BRKzBKRVM1R3VkUW1veWJw?=
 =?utf-8?B?Smp5VHVYcktORUhmTGNaTjloNmU4QW1Objk4bnJBR2lGMkxZLzVhZGFKNjli?=
 =?utf-8?B?M0QxK0R6ZWhTNzJ5d2d2UjdFbGp5NFUzaW4yTkVFN3psSGk4MjZ1NmNNaCtk?=
 =?utf-8?B?dExGcWoybnc4aCs3SU9lTWhOcExmc0hoRU5RKy8yWjRrQ2NvRzBjZkE2bzB6?=
 =?utf-8?B?SlpwcmVLSEdyUncrLzBqK0x3MHFqN0JqZ1FnQ3JVVVpGckk4SVNKOXZoMllr?=
 =?utf-8?B?NG5vc1FYcnBtTmU0T09oZmlJUjdsclMxTmUzQ2llYytld1Mxc1ZiODB1bnNr?=
 =?utf-8?B?S1NibkF2UEVXRXJURXNnVHJ3S0FFUkFibldLendhakNETHU3ZVp6RU11MWE5?=
 =?utf-8?B?WnRnUGxNN25Gc0NkeDB0YVJGM0pwWGdtTnd6aURoZWFmaTdNOElBOHpJVFp3?=
 =?utf-8?B?S3FqS1BSZUZ2bCtJWXVhbzVjUkxRS2xGRE1TZCs2QTNGeHhTazkvUEdYVDJh?=
 =?utf-8?B?dDZocUhPcXV2Z0l6TXJyU2wvZXh3RitGRmZ1dDJxYzIyWUFkSjVrWlBHbm8r?=
 =?utf-8?B?bUYyS0I5eGtrTWI4L2dXUy9uNXBHaDIraG9ZR2RVS0gwV21pdEduM0s1eVNQ?=
 =?utf-8?B?OWFzVG42cVg5eTNjVGJtYzRIOWFCaVBCS2lRNUZxdk84eG94SEJ3MGtvVHhQ?=
 =?utf-8?B?MWdZREFIRkhRNU9XV2p3RWFid0I0YnZUU1p4ejR3YWI4ZHZWZmQ1RzhrbjBt?=
 =?utf-8?B?MGhscEFYbXZ0aVBwd3U4WGkvZjdLU2Ivdnp2c3pxZHYvM1NYekJRaFdUbW52?=
 =?utf-8?B?N1pvOTN0Ny9NOE92djhoSjc4eXNKTC9BNE5PNUhuWW44bkJvNURFbzF6WU1j?=
 =?utf-8?B?UGc0elpGaEpBdlcrcTl6Y0p0a2dIczhmM2pPOTB6Y1IvbkFiK3dITENyQldj?=
 =?utf-8?B?MWZGb1JwZmdNbHJLRlVieFlCSmg3eWVsRE9haXdaUVd3bFdmYUc3U0Z0YUxs?=
 =?utf-8?B?UGNCWWVBOVBEYXNla2Y2SkhTZWxKcllOOVZmblZIOGN0U2hTWkJZZzg1UmQ4?=
 =?utf-8?B?SVgzRS8ram5uZ0tGeUs0WUVFU3dxM2xIbVBSeEFMYWpVVU1aUklaMTFwU3hK?=
 =?utf-8?B?dWhCTzd5dEVRRmtWRXYwY29ua29lNUV6MXlXNmJ0OGNpN1JrUVlqaDkzd2xX?=
 =?utf-8?B?NUljMXpCRjE4YXRoVC9hUklpNWI4aUovSi91WTRpVkd3SVEraHc3ZmdORHlX?=
 =?utf-8?B?WnBNT2NCQjA1VlhoQjQwR1plM3AzQ2hPVlduOUh0VldIZ2ZhSkRjbzhGcjZM?=
 =?utf-8?B?dEdlSWZLeEhnOGVwM2d5Z3ZMelphNVBXSmg4ZlRXSFlWclBWbVZKK2RXYzZv?=
 =?utf-8?B?VG40VDRVbFBRajVwMWQzQStFRitzSWhXREppcjBCK3ZkQzVxeWZzRTBRMWhZ?=
 =?utf-8?B?TFdWYkVNWnFuSmhkM21Yb2p2dTczQzYxWnJzdFFYdCtFcWpXeHpkc0NZbk4x?=
 =?utf-8?B?WGFtZ2x3QnR4OVgxV2JEU1NXL1dORllLZUt2UTNMS1ovZG5TRU5GeFZhd2NM?=
 =?utf-8?B?YWdpem1CQlJiU01hOENvdEZCdXRCTXRYZnllbEFOS2J2cWt1UmZKN0hyV2Zw?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BIAdJ3ka0GdpK+WGESmjVL1FHkeQ5EmEUHzefZrhvyrHTLWExms8peiRBeIzvaPrjjtXP0IX2KXH6SutOnuzynuaptGrRrvzSD7dx89zz2U1qbkE5ZSVnbwEnrPVWbGRDLSKRIGCAanNzLGmQZavAn25wFFQdLdpTb/xjdnHhMWQeiF6/+RsFnwT5/59A1/SIM927jdXtUooOsZ3saZF8C3CuVfcOQ9G2/jiRnRu5GO+eYW+5J5NgtIeVxwVmvIKo2B583kd7LJVD2lilbqMmO/NC+8aqF585s4UN7pKLTsWrWPF3UEiihTgtCiaHuMpuLIWTv+8gF4ZsLYtYNyiq1hxWAFTR6gItTdcKZrebx0Cd1jOA8pgI2PKaFCkr2P5I2BTwgOHijAV96+iFxxvA8Ju5SswmS7PZbgF9q1QXm03xmtIDpX8qmYv5UMKPpdfb/2LAVCVjN4zHFCz54otnSbkpWTZBeSAPdtDkD1zMWjTaWJNWinX2+yIF0Rm5jvepakvDtKNDtALikDbjGd3z0iHEKZaIB7F2sM+6waTq4vb26z/+3Vkjw9AHECBkHz9I2EsnYdNr8cfTCNNjtkIWlVjAA/Dh4K9qh/OHLcpDoo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac72e3cd-f52b-4cd6-183e-08dd3f17ca1f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:15:56.7545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZvsLBEU9Qfy3LaE0KVO6JftauI9YoWOPc8y5EcVl7nnme6Asulzs4RMnplXVUcmqezk0BbfD08vPCV/N4XuY+BPtu0zlmFoKbAT9xDYU7m0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270167
X-Proofpoint-ORIG-GUID: inDfXU8Bkcs1TytTvnJbBFvMWcL-7DJh
X-Proofpoint-GUID: inDfXU8Bkcs1TytTvnJbBFvMWcL-7DJh

On 1/14/25 15:00, David Hildenbrand wrote:
>> If we can get the current set of fixes integrated, I'll submit another
>> fix proposal to take the fd_offset into account in a second time. (Not
>> enlarging the current set)
>>
>> But here is what I'm thinking about. That we can discuss later if you 
>> want:
>>
>> @@ -3730,11 +3724,12 @@ int ram_block_discard_range(RAMBlock *rb,
>> uint64_t start, size_t length)
>>                }
>>
>>                ret = fallocate(rb->fd, FALLOC_FL_PUNCH_HOLE |
>> FALLOC_FL_KEEP_SIZE,
>> -                            start, length);
>> +                            start + rb->fd_offset, length);
>>                if (ret) {
>>                    ret = -errno;
>>                    error_report("%s: Failed to fallocate %s:%" PRIx64 "
>> +%zx (%d)",
>> -                             __func__, rb->idstr, start, length, ret);
>> +                             __func__, rb->idstr, start + rb->fd_offset,
>> +                            length, ret);
>>                    goto err;
>>                }
>>
>>
>> Or I can integrate that as an addition patch if you prefer.
> 
> Very good point! We missed to take fd_offset into account here.
> 
> Can you send that out as a separate fix?
> 
> Fixed: 4b870dc4d0c0 ("hostmem-file: add offset option"

Thanks to Peter Xu and to you for your reviews of my proposal for this 
separate fix that should be on track to be integrated soon.



