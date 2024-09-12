Return-Path: <kvm+bounces-26752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E79D8976F48
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 19:07:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D3E1C23B0B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DE11BF7E8;
	Thu, 12 Sep 2024 17:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hAmKZA3J";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lhl+fGTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061351BD002
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 17:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726160855; cv=fail; b=fue+5PjTkr4bHfDnda7Wy4K4lWDM6ZoNR5ViDeGZFFi6eIjrGUwv+2+Q9DncpUZlUF3l+pMW0BpQTTvr7pCe99elaU+5kb9hW+JIvuG0hvHgggr4udybs3sr6mr4BUntyu3ojmKkVQsOC4mVJ2UlS37KNsE8i9+uJP2UGLLjavg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726160855; c=relaxed/simple;
	bh=JLDtEd+7UWMnZ3G+BqojULqFONDRKgZFK0s2OlQh9lc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jIMpd1emNRdNV/qPcC9kiD7c7tbwA5YKo0LWqDGgLFM2I+XbfAi9Jy7vSxhX6+flLNdlI0Y+2Uutq1yqqSxm1bOvvKEdq8kgCBT+QSdurB2SjGYqblIOKL9X/g5deM32g7B/zbvY3dYE2mYZdIK2vVvcX4aQBI9cxXcNwWJx5PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hAmKZA3J; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lhl+fGTQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtap9015066;
	Thu, 12 Sep 2024 17:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=CJdpSocsuJOhlA3MPTeCLlohBczjrrDA9e5juNpWwJw=; b=
	hAmKZA3JWHNmlF+ztmJdJUhLeEEkB6/0wmNCXxcz66nSYAA6OmFF8QK4eE9ia234
	+wrZ7XAuJvNX/ZsMo5j2KQn0hmAInfgZaCzMrdrCw+UlazaX8tcVjWKORoswGkC9
	VNxjTJAfNQ4mgv4Lvs2mD+U2HNT0so9AcesMr9U89SfKzhZFo8eY7gU0sxwP6feD
	CTjFhldaNTXOCeUOzBUQTnh7GJ5wMHIdUJjCpGf+QcSc0AXwPBdLy0JrvT8aexPh
	X2neP2J6RWo3c62AK1Z+T50KaZEupskpZSih8t9a/N76DjKFI+nHSXgcWEQRb2CD
	VTlaGG1eRavgzA0Be31AxA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41geq9ubn4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 17:07:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CFtXg3005070;
	Thu, 12 Sep 2024 17:07:15 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9bkqpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 17:07:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=remZoEZhrKxcN8a3Qjc7w8J/8ToswQsNuYrzHj5emjtUNtsDO7zBfNgJPdHcz2i548+J/9pTK8nHAnw5uMbUp5qyPm0HXGNscdaVVIarJJ8mhU0Jb04wVZCxcyoyWA8D4NnVXIiO1sH5iV+nvicoqGWNAWKb7fIPWjNvHKjOaS9Xfq/CHe7NXRAfl3cuqCz+Hx5XtD0HcYqhgTOu0C80wOyfY9c8ACbWsY3Zd39gAml7a1Y8GvzaP8E4f6oe+aWUgs1sFWrPxLZ7JHfiRwniBD7gxJkyA8DZQ0L/hCiKtICR61rNG/fbfqfJH3ozs+/9lzrtFbqTWl9NROqfOy1WEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJdpSocsuJOhlA3MPTeCLlohBczjrrDA9e5juNpWwJw=;
 b=M7q090FLh1hkml6SZnXT9gwddWBUagpK3JyPora7QOCY80tggYHPAVYPtH7JqHxc7xzXzq9eT6/nkOxK3URMajWxafQFu1ddTwI5zo2Wze5eCxtkAIz0vUrvvk3A6f2I37CF4fRwxB9uZSwOMkuQlzUCTIYGh584i85U4WIbZCScY/KHd0ubkiBriFX9xDaQmgKaGGTnNZuqJz527F7YJN/qdmhKO9m/bj5TNhX/y5wNC4TAzn7ddj0rJFX+nuzUkvbQfUkiyTLsXi0Rc4nrupF8zGrDWCQe01mHBjVwv6U0XOm+Bb1EoBx7bChBwonn5efTCEdpvjH9g+QfNnRSUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJdpSocsuJOhlA3MPTeCLlohBczjrrDA9e5juNpWwJw=;
 b=lhl+fGTQghI+FurTAf+JulbGEJCtj06KrCIIZJ8I+25CGLlX9RsXHqnnfC1rqtrHjo4icus8FocyONakt6IPtv8s3fGiyCRAl/ms76W5tWgW2BMhIaZdHKFLu+HF/Aw5oD8xIbeSijqFql46PJJHSE56HSGxwSOL5e5tk7D6nnw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW5PR10MB5740.namprd10.prod.outlook.com (2603:10b6:303:19a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.8; Thu, 12 Sep
 2024 17:07:12 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7962.016; Thu, 12 Sep 2024
 17:07:12 +0000
Message-ID: <966bf4bf-6928-44a3-b452-d2847d06bb25@oracle.com>
Date: Thu, 12 Sep 2024 19:07:08 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC RESEND 0/6] hugetlbfs largepage RAS project
To: David Hildenbrand <david@redhat.com>, pbonzini@redhat.com,
        peterx@redhat.com, philmd@linaro.org, marcandre.lureau@redhat.com,
        berrange@redhat.com, thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, joao.m.martins@oracle.com
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
 <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
 <9f9a975e-3a04-4923-b8a5-f1edbed945e6@oracle.com>
 <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0161.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c7::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW5PR10MB5740:EE_
X-MS-Office365-Filtering-Correlation-Id: ce8ca2a5-74af-42da-4b0f-08dcd34d57e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zi9KTGk5d2Y2RFZnblYwRjhEaGdYREwycTFlY0xNMnFoZHppTjhDODk1TWQ2?=
 =?utf-8?B?L3M0c3BhTXc4eFJvTFphbHF5eDlDcm1TNWlnVEVRSE9OS1ZuRmwzSHNtK055?=
 =?utf-8?B?OUU3UjNYZll3dm9NbWwyamcwYVBrNmJ6YTF4bXIyaFV5emRsdDl6VktZTXRN?=
 =?utf-8?B?WmNkMkJ4cDZmc1lhU2twQTh3TEJZbXk2Wmo3em8wMzlyZnhoZHlTRGxlNHVy?=
 =?utf-8?B?NjlEMVFLS2x0bFMzYmhuOFBtd08zOTQvemt3MFc1dm9RRFVxZHBMaVhEM1J2?=
 =?utf-8?B?N0h4UlFjckpLTkpqWnJ6elFJZ3lyK2Y5ekJGYVlPOXoveE5PQWQvVVlyaVlu?=
 =?utf-8?B?Wk9qK0srb0t5WXVtL1FGQ2ZCNzhib1hyWWsydWFVYk5ZQkdwTkhmNXRZRmJx?=
 =?utf-8?B?LzcrTjRzT21sNW9UUFNmc2d0dnBROFBIWUQwQUt3SVZ0Z2Y0VkEvcVdhUEMv?=
 =?utf-8?B?UWNHNEFtblpudzJFSk9wa1EvdkkrT3N5WlRyanJscmtYQjczdDg1L2RFc2tz?=
 =?utf-8?B?dUQyUG94cGVaM1ZFNldvZ0tvT1o0UFdmR1ZRK2FvRUhRTjdxbE5LWUV4enBO?=
 =?utf-8?B?dUgrdGNmUFcwMVk3QmEyNi94ZjVpbUZUOXMrK3FRSzNBaG5wR1dJSzUvK3Fu?=
 =?utf-8?B?QVNzRC9FeEdHdENGUnl1clVtdjJaTlR1QnVRb0FtRXQ2UTBVaWdZNDBIWjBB?=
 =?utf-8?B?WUZWSTlWaGxqY0s4NDZIRkFDc0lIZ3VQamlRYXMvWDBOcExzQi8yT2dhejhr?=
 =?utf-8?B?ajFVQVYwYWFOMDE0UWg2dGloR1hFUlUxMm5sYnRaSEFJZEJxQlpiUjBSVkVI?=
 =?utf-8?B?ejFiT2V3clJDZzh5STdFYW5EU1JHYjJ4bytHaC9TbDVvSmFneEdZMmp1VnZn?=
 =?utf-8?B?c3JrNmh3aXArU1lpQmxhdjNacmdkeGtaYkpZbjNOSVBVUU5mVFhrQjVNejN3?=
 =?utf-8?B?SEdNT3Z6L1Y3YVp0emVMM3F6cVBZZWJ3dEVvMUZVY0xkUmdTVnpMMk5Calpl?=
 =?utf-8?B?VVFHcG9zZGZDVStqcVpqSUs3NnR6dm5DZmwvWDAxK2RDd3hOTW52Y05oaHdP?=
 =?utf-8?B?NVV3NGhiTmJjM004N2lGL3RQYk1ha0lkOGVyWittL0ZCVkFxaTcxMVoyci9E?=
 =?utf-8?B?Z1ZDR3d2Skc5YjBsNlY4UERhVE9neHBRSzlzaVZpZzRvMVNXeHRITWQzSFFE?=
 =?utf-8?B?d3pVaytRMWpUQWRJS0d1bnBRWEZvVno4eWNUYjVlRnZJVS9TeUZWZmhmODl2?=
 =?utf-8?B?eU1IWmZ2Y0ZwRm9CV1pKTzhkN2pmald2ZzdGZzJhVVFzZEhRRjZwQysxbzRZ?=
 =?utf-8?B?UzZncXdxRmNKd1MwUlBQR2N5djhyWFlQaFkzWndjRU1DTmFpRUUzM0VWbjZa?=
 =?utf-8?B?WFNaSk9HcElDOUtGZ001WWNVUHN6REQ1UmQ1T0hQZHJ6MG5lY0dBWmxYcGMw?=
 =?utf-8?B?QVE2STVNS05OMWVSRldSZHZad1g0QkxzbTAxdlFMdFl0Z2ZkbTJGMEx1RXpF?=
 =?utf-8?B?WUtoZzdwTG1qbkJYemJhRFhaM1FTdDBkRWRuR0JyOWdTTTd4YkgyRURpSUZs?=
 =?utf-8?B?U01rNjcwOWlDVm5PZThmamNaNVkyckFES0d3dVVUUmk5emp4OG85RUlEODFl?=
 =?utf-8?B?R2laQXFoSnJuNUw4M0YrSzdzbURBczB1NC9RRWF2OUVrK0RMMzcxS3BhSU5a?=
 =?utf-8?B?MHBmQXhxbUpMYU55TXpaeDVGby8yalNmaW9IWFFCQVVIQ3h5OCtUSzU5aTdn?=
 =?utf-8?B?ZC9PR1IwSU5SR2UrcExTdUVaL09YUnYxVGRycUJPejJtakhmZlA2ellCSnJt?=
 =?utf-8?B?K3F3QmRQZmQzWnhEcHBNdmZMbmh0cTF0RThuR0JRcnhuVjFrMG5ueDRTS1Fy?=
 =?utf-8?Q?H9GZsJVUb+I/O?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVF4TERpQXduY0cxV1hERWVUSE1jUUlnbDB0L0MxN1lGYTAyOWNnS3JkTC9m?=
 =?utf-8?B?YW4zYy9MY2J3L0QvclhuNUFSS28zUmswL0VjcUtwUFdmYlNONzBZeDZlTWFh?=
 =?utf-8?B?emJMeFI1K1NlNzVoVEVZaW1jWHNRQlIyRnFDdWY0ZVBoNTNJSERXRHU5RDdu?=
 =?utf-8?B?NVU5Y25PL1VjbVZuQXIzNEpvMUxFVFo3WXVtdTBaR0JIT3BSMzNOelQ2Q3VJ?=
 =?utf-8?B?Uk1UbWF0bndlZWQvU1JLOG5OYUVhVjdQaXBLN3FZWkM4U05uVVQ5MjRBQmhN?=
 =?utf-8?B?bEpQRXlxb1I5em1veUFGSFRCNUM3NmVOZHZsYVFnbFUzN3FPOUo3TmJIRFB3?=
 =?utf-8?B?OElpeVJmZVJGb0lqdDEvMWJZbDFvZXpmajRtcTRPZWFDQWo0SzVTVkErNWVm?=
 =?utf-8?B?aE1VVHE2NnZkQ1BPQ1psRGZPem8yc29UT2sySk55NThmajlpN1JiZzBjcHpW?=
 =?utf-8?B?MWhsTC9WQnY1MFN0Y2czSUN6N2YrbTRKNDFtVm1hNDdtMUovdk5vdWtCdjkz?=
 =?utf-8?B?TFVJYjZyM0NiaXl6eWs3aWgvbWNET1g0OWZRQ01qTE5BVXFDUzMwMk9wbDNR?=
 =?utf-8?B?cC96eVhWbXpHaXZ0VG1wc0NtVnVnUGdQNlZSSkVIcm5tdkdMMWdxbnZoa0g0?=
 =?utf-8?B?Mk4wVjNaQjFRNnh2SlFSd291UThSaDJDR1JsQU9rNmVNOE1uT3YzZXVsenRR?=
 =?utf-8?B?Z3pqSCt3NTUrbUwxRzN4N2xIaVkvekJCNU03S2hTbzJSa2xkTmZnL3pGRGEy?=
 =?utf-8?B?RUI2cWVrZnFsNkxNcXJOTjB1b0FqeEVTb1g0cjVmQmlTSDdINU1rS1g0S2hk?=
 =?utf-8?B?ZDlZa1J0QnZJK1lFYzhyS0VLaDE5N2VoQzhaY2p0K3JFSVdTQVZ6WEZ2V3J5?=
 =?utf-8?B?c213V2RyTVcrNXh2QVNJeXBTZWVuWmJpZGIxcWxOUXZrVVkrQ3hGMTNZc1Yz?=
 =?utf-8?B?T3lCaHVKS1lSLzhwT1VuMnZWbGRhUEpCa05DSzUvN0JkQis1WDJNQ2pVSndL?=
 =?utf-8?B?UDE4RFY4WG9nNjRhaUdjT2N2NC9wKzhCZ1dNMDZLTEd4U2pPdCtKNHE0Zjc0?=
 =?utf-8?B?bldXZjhhTCtUSzJwT0Y4TjN4d0x4Tkszd1dMcXk3WFhLdFFTT24vSVBiL1NN?=
 =?utf-8?B?Wm4vMWNBRGxtL09lbXZEYW5tWWtseSs2VnJKWjl4Nm1sUVNIMWF0bm1DSmM0?=
 =?utf-8?B?bG9hNmlhMmcwS0N6Tytldm5ZTE44angzSktZS1YxU1Y0cVJJSGdZV2VlVGN1?=
 =?utf-8?B?WTloUjhBZXBpYXR3WTYxR1lKLzdkWnNBNGxodjU3QlhwcDJVRHB5QUY0VVFJ?=
 =?utf-8?B?Uko2R2lENmc3WmZUcGZSYzlrMXdFdzgwQmMwb2xPckdPTUh1dkQyTlBHbFBu?=
 =?utf-8?B?SmN3Zms5c1MxQUtjL2QvV0xCa3NvK1NoNmZkbEFyd1FRejl5UWJ1d3VMSDRC?=
 =?utf-8?B?TExxT3Q0N0d5MkVka3YxYkJDSmxrVFEwY0NhMkNGS2tqVy94U0NOTUgyTjVq?=
 =?utf-8?B?WkgvVHcrcWgyRGV5dloyV0hMOURka2tleXYvZURrZnJXbnJTakFUYXVjYVZI?=
 =?utf-8?B?UncxcnJtZlo2d2ZJL1ZwZ3dNMXdyM1JqVCs1SjdUZzlPWTU5MHRseHNzQStE?=
 =?utf-8?B?TlhHNUtDcGNVVWtLTE1waDJJU2N2bGN0YW1MOEV0MDBJSk02Q2xVekd1YXNR?=
 =?utf-8?B?MEozamRBTmZsRHhXdk14eThSUFI3d3JXdTdqTnp1NjFJbzR5RFdYTVczcUhj?=
 =?utf-8?B?eEp4Nms4aUowdjFhbWs4NW52RjVXdHZxdXAwRTVwZ0dLZngxRFNNRFhzaUJ5?=
 =?utf-8?B?bVAzWERzT1BrQTViMEd6NEk3bnlRM1NMdUE3V2s0Y2FjKzJneERjSWE0bHZE?=
 =?utf-8?B?dmNDUi9NUThvaGQ3NEN5S2hEZXAxaStJNTRRVE9EdmYrRW8zb1BhekkySXdO?=
 =?utf-8?B?LzV5Tll6Rm9hM3ZRY3NDLzFoZGYzaitubWVidWt2L0x6L0JwUTVuTGxQeW5P?=
 =?utf-8?B?WC93MzNMVmlJMnpmbUZ0NTM5aGhaTlBNOFpCWWVJNzFxcEcxZW1FSTJMdkZH?=
 =?utf-8?B?eFY0MkZFYnFyTXQrKzFZZFI2UnN0NXQ4S29qQURsMlpiM1JDajhoUzJKTGd0?=
 =?utf-8?B?bkZMdEVyL3lMMUZ2MHd1OWd0Q1pNcmVsL0EzNXBuN1IwRW9LaDdaWDRacmZV?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RVz/ZDtIR1EYKSqnCpIzmPcOnq5yySYsW8zSnEpVCd4Y1HIqiPV35tRY7LdAA4L6cwZVY1DutKHUupJnhAuB5C3KxeDS0Ie9MaRXfjE/JeVYcX5f/MTdr0wQHsMtb1sUZS11bkBJs1uXDTW1ky8kikzH+OSUGhL8Z3WlEnGUWYzY/tIDiZSK75hkPZ83WdscpKOmFTqlmUC1uZHebSP2rABD09XGHhSQ5JR8vSoQ0e/v7LGvlSDsvi8fwunGV65Kd7JhlsLGXqnzGas04cjbHD9my8h4XvvQgfi6F+raWeSVQImpB9leF73OqnctjeXY8Dt2zGEmK+/9I9jS+FzOsX5bruil7lKrCuuGllz8vRfdCVAGhPJarjGQ52Feu4yiDQYeNky5mbKzjISJ1JbHZ0faQYWrYa2ojep2LgEOZQeeJx7i595ef236toOFTyZqZnnM4JURsBC/C+Gd/vjTRmzhMmRPHJUMq6COF7VD5ZvMMcbpeGnjrNdElwSN3+/Lpcc7rLNYy0h6gSkAqBy5xoEcSWKy9CuyLUXZ8H21iHgAWOfDWsr/Suv/zyMVfk8NzLS5vytvfuUBlbdariGCuCYPL460XXrNiZqsFPkODEQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce8ca2a5-74af-42da-4b0f-08dcd34d57e3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 17:07:12.2313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uxs5q9N4jD3N0sp2O6WxATuRHhjHEyL0CqrpHeTLMCoj7/VW7+wzpo3sL19cbV7vrMGZ/mESppRFqNJeARcHbnR0CExVyuikHL+hN7S4NQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5740
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120126
X-Proofpoint-ORIG-GUID: NdCgPGk4L28irvgvJnegSVuEZTViGFKU
X-Proofpoint-GUID: NdCgPGk4L28irvgvJnegSVuEZTViGFKU

On 9/12/24 00:07, David Hildenbrand wrote:

> Hi again,
>
>>>> This is a Qemu RFC to introduce the possibility to deal with hardware
>>>> memory errors impacting hugetlbfs memory backed VMs. When using
>>>> hugetlbfs large pages, any large page location being impacted by an
>>>> HW memory error results in poisoning the entire page, suddenly making
>>>> a large chunk of the VM memory unusable.
>>>>
>>>> The implemented proposal is simply a memory mapping change when an HW
>>>> error
>>>> is reported to Qemu, to transform a hugetlbfs large page into a set of
>>>> standard sized pages. The failed large page is unmapped and a set of
>>>> standard sized pages are mapped in place.
>>>> This mechanism is triggered when a SIGBUS/MCE_MCEERR_Ax signal is
>>>> received
>>>> by qemu and the reported location corresponds to a large page.
>
> One clarifying question: you simply replace the hugetlb page by 
> multiple small pages using mmap(MAP_FIXED).

That's right.

> So you
>
> (a) are not able to recover any memory of the original page (as of now)
Once poisoned by the kernel, the original large page is entirely not 
accessible
anymore, but the Kernel can provide what remains from the poisoned hugetlbfs
page through the backend file.  (When this file was mapped MAP_SHARED)

> (b) no longer have a hugetlb page and, therefore, possibly a performance
>     degradation, relevant in low-latency applications that really care
>     about the usage of hugetlb pages.
This is correct.

> (c) run into the described inconsistency issues
The inconsistency I agreed upon is the case of 2 qemu processes sharing 
a piece of
the memory (through the ivshmem mechanism) which can be fixed by disabling
recovery for ivshmem associated hugetlbfs segment.

> Why is what you propose beneficial over just fallocate(PUNCH_HOLE) the 
> full page and get a fresh, non-poisoned page instead?
>
> Sure, you have to reserve some pages if that ever happens, but what is 
> the big selling point over PUNCH_HOLE + realloc? (sorry if I missed it 
> and it was spelled out)
This project provides an essential component that can't be done keeping 
a large
page to replace a failed large page: an uncorrected memory error on a memory
page is a lost memory piece and needs to be identified for any user to 
indicate
the loss. The kernel granularity for that is the entire page. It marks it
'poisoned' making it inaccessible (no matter what the page size, or the lost
memory piece size). So recovering an area of a large page impacted by a 
memory
error has to keep track of the lost area, and there is no other way but to
lower the granularity and split the page into smaller pieces that can be
marked 'poisoned' for the lost area.

That's the reason why we can't replace a failed large page with another 
large page.

We need smaller pages.


>>>>
>>>> This gives the possibility to:
>>>> - Take advantage of newer hypervisor kernel providing a way to 
>>>> retrieve
>>>> still valid data on the impacted hugetlbfs poisoned large page.
>
> Reading that again, that shouldn't have to be hypervisor-specific. 
> Really, if someone were to extract data from a poisoned hugetlb folio, 
> it shouldn't be hypervisor-specific. The kernel should be able to know 
> which regions are accessible and could allow ways for reading these, 
> one way or the other.
>
> It could just be a fairly hugetlb-special feature that would replace 
> the poisoned page by a fresh hugetlb page where as much page content 
> as possible has been recoverd from the old one.
I totally agree with the fact that it should be the Kernel role to split the
page and keep track of the valid and lost pieces. This was an aspect of the
high-granularity-mapping (HGM) project you are referring to. But HGM is not
there yet (and may never be), and currently the only automatic memory split
done by the kernel occurs when we are using Transparent Huge Pages (THP).
Unfortunately THP doesn't show (for the moment) all the performance and
memory optimisation possibilities that hugetlbfs use provides. And it's
a large topic I'd prefer not to get into.


>>> How are you dealing with other consumers of the shared memory,
>>> such as vhost-user processes,
>>
>>
>> In the current proposal, I don't deal with this aspect.
>> In fact, any other process sharing the changed memory will
>> continue to map the poisoned large page. So any access to
>> this page will generate a SIGBUS to this other process.
>>
>> In this situation vhost-user processes should continue to receive
>> SIGBUS signals (and probably continue to die because of that).
>
> That's ... suboptimal. :)
True.

>
> Assume you have a 1 GiB page. The guest OS can happily allocate 
> buffers in there so they can end up in vhost-user and crash that 
> process. Without any warning.
I confess that I don't know how/when and where vhost-user processes get 
their
shared memory locations.
But I agree that a recovered large page is currently not usable to associate
new shared buffers between qemu and external processes.

Note that previously allocated buffers that could have been located on this
page are marked 'poisoned' (after a memory error)on the vhost-user process
the same way they were before this project . The only difference is that,
after a recovered memory error, qemu may continue to see the recovered
address space and use it. But the receiving side (on vhost-user) will fail
when accessing the location.

Can a vhost-process fail without any warning reported ?
I hope not.

>> So I do see a real problem if 2 qemu processes are sharing the
>> same hugetlbfs segment -- in this case, error recovery should not
>> occur on this piece of the memory. Maybe dealing with this situation
>> with "ivshmem" options is doable (marking the shared segment
>> "not eligible" to hugetlbfs recovery, just like not "share=on"
>> hugetlbfs entries are not eligible)
>> -- I need to think about this specific case.
>>
>> Please let me know if there is a better way to deal with this
>> shared memory aspect and have a better system reaction.
>
> Not creating the inconsistency in the first place :)
Yes :)
Of course I don't want to introduce any inconsistency situation leading to
a memory corruption.
But if we consider that 'ivshmem' memory is not eligible for a recovery,
it means that we still leave the entire large page location poisoned and
there would not be any inconsistency for this memory component. Other
hugetlbfs memory componentswould still have the possibility to be
partially recovered, and give a higher chance to the VM not to crash
immediately.

>>> vm migration whereby RAM is migrated using file content,
>>
>>
>> Migration doesn't currently work with memory poisoning.
>> You can give a look at the already integrated following commit:
>>
>> 06152b89db64 migration: prevent migration when VM has poisoned memory
>>
>> This proposal doesn't change anything on this side.
>
> That commit is fairly fresh and likely missed the option to *not* 
> migrate RAM by reading it, but instead by migrating it through a 
> shared file. For example, VM life-upgrade (CPR) wants to use that (or 
> is already using that), to avoid RAM migration completely.
When a memory error occurs on a dirty page used for a mapped file,
the data is lost and the file synchronisation should fail with EIO.
You can't rely on the file content to reflect the latest memory content.
So even a migration using such a file should be avoided according to me.


>>> vfio that might have these pages pinned?
>>
>> AFAIK even pinned memory can be impacted by memory error and poisoned
>> by the kernel. Now as I said in the cover letter, I'd like to know if
>> we should take extra care for IO memory, vfio configured memory 
>> buffers...
>
> Assume your GPU has a hugetlb folio pinned via vfio. As soon as you 
> make the guest RAM point at anything else as VFIO is aware of, we end 
> up in the same problem we had when we learned about having to disable 
> balloon inflation (MADVISE_DONTNEED) as soon as VFIO pinned pages.
>
> We'd have to inform VFIO that the mapping is now different. Otherwise 
> it's really better to crash the VM than having your GPU read/write 
> different data than your CPU reads/writes,
Absolutely true, and fortunately this is not what would happen when the
large poisoned page is still used by the VFIO. After a successful recovery,
the CPU may still be able to read/write on a location where we had a vfio
buffer, but the other side (the device for example) would fail reading or
writing to any location of the poisoned large page.

>>> In general, you cannot simply replace pages by private copies
>>> when somebody else might be relying on these pages to go to
>>> actual guest RAM.
>>
>> This is correct, but the current proposal is dealing with a specific
>> shared memory type: poisoned large pages. So any other process mapping
>> this type of page can't access it without generating a SIGBUS.
>
> Right, and that's the issue. Because, for example, how should the VM 
> be aware that this memory is now special and must not be used for some 
> purposes without leading to problems elsewhere?
That's an excellent question, that I don't have the full answer to. We are
dealing here with a hardware fault situation; the hugetlbfs backend file
still has poisoned large page, so any attempt to map it in a process, or any
process mapping it before the error will not be able to use the segment. It
doesn't mean that they get their own private copy of a page. The only one
getting a private copy (to get what was still valid on the faulted large 
page)
is qemu. So if we imagine that ivshmem segments (between 2 qemu processes)
don't get this recovery, I'm expecting the data exchange on this shared 
memory
to fail, just like they do without the recovery mechanism. So I don't expect
any established communication to continue to work or any new segment using
the recovered area to successfully being created.

But of course I could be missing something here and be too optimistic...

So let take a step back.

I guess these "sharing" questions would not relate to memory segments that
are not defined as 'share=on', am I right ?

Do ivshmem, vhost-user processes or even vfio only use 'share=on' memory 
segments ?

If yes, we could also imagine to only enable recovery for hugetlbfs segments
that do not have 'share=on' attribute, but we would have to map them 
MAP_SHARED
in qemu address space anyway. This can maybe create other kinds of 
problems (?),
but if these inconsistency questions would not appear with this approach it
would be easy to adapt, and still enhance hugetlbfs use. For a first version
of this feature.

>>> It sounds very hacky and incomplete at first.
>>
>> As you can see, RAS features need to be completed.
>> And if this proposal is incomplete, what other changes should be
>> done to complete it ?
>>
>> I do hope we can discuss this RFC to adapt what is incorrect, or
>> find a better way to address this situation.
>
> One long-term goal people are working on is to allow remapping the 
> hugetlb folios in smaller granularity, such that only a single 
> affected PTE can be marked as poisoned. (used to be called 
> high-granularity-mapping)
I look forward to seeing this implemented, but it seems that it will 
take time
to appear, and if hugetlbfs RAS can be enhanced for qemu it would be 
very useful.

The day a kernel solution works, we can disable CONFIG_HUGETLBFS_RAS and 
rely on
the kernel to provide the appropriate information. The first commits will
continue to be necessary (dealing with si_addr_lsb value of the SIGBUS 
signinfo,
tracking the page size information in the hwpoison_page_list and the memory
remap on reset with the missing PUNCH_HOLE).

> However, at the same time, the focus hseems to shift towards using 
> guest_memfd instead of hugetlb, once it supports 1 GiB pages and 
> shared memory. It will likely be easier to support mapping 1 GiB pages 
> using PTEs that way, and there are ongoing discussions how that can be 
> achieved more easily.
>
> There are also discussions [1] about not poisoning the mappings at all 
> and handling it differently. But I haven't yet digested how exactly 
> that could look like in reality.
>
>
> [1] https://lkml.kernel.org/r/20240828234958.GE3773488@nvidia.com

Thank you very much for this pointer. I hope a kernel solution (this one or
another) can be implemented and widely adopted before the next 5 to 10 
years ;)

In the meantime, we can try to enhance qemu using hugetlbfs for VM memory
which is more and more deployed.

Best regards,
William.


