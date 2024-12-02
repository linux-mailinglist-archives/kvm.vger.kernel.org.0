Return-Path: <kvm+bounces-32824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4769E0A58
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:46:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 64DCDB2BD0E
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 15:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E22F209F4F;
	Mon,  2 Dec 2024 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dq4NRwm4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="n+jG7uBX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963CE1F943D
	for <kvm@vger.kernel.org>; Mon,  2 Dec 2024 15:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154144; cv=fail; b=NTqWEE0C/7komHPT41c0l32W/Gn86ch2z0GCOitSu01LaSgqdGP0Bp3pUZWs5rCnd10xrjNYQ0xB/AiORnmNMaOQiLDNkmaX1y6JFAl4WV47s2W4itBIvbOIHVDbzJZsxOlBhkPd51UjMElGOdS263CUM3DflXdsWlebSXKrQs0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154144; c=relaxed/simple;
	bh=orepvF7hUWCMY05KHzHIQhROqNYxmLzenPGmzh8Im3g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nT2vARez/Ewxs2ooqpFveYwx9a3Ko64pIpX6tJ9SwW6VR5CsP/BOj+EicXKPTWgik2Yc/+LWGj68wUJIo0h1quEWwL+FQ49eG8gtIwLKqJhlk1gFRuCy794x0N0w+kKX/MREGbJkZWDc/4aWZHyxLmdNZO/io6Ck+Lzyceu8EvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dq4NRwm4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=n+jG7uBX; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2DZhbH015184;
	Mon, 2 Dec 2024 15:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Wx2OkKxDOaHj0jZw+UC/DqrrHec5q+PD10kPOz0OGzg=; b=
	dq4NRwm4NXsTN276TpxiwWmiiDI5LHEIo3+dY14FMx3PT+pEjf6ZT69KVImaF0We
	Al0xbDUxD4P7Crj+uYL2bdqbLtjujr4ASgn+Sp4PaiGwrslt6dgnoPkTtmXFvc7I
	7GD5bp4PST0au6vFaXrb7DhKjcUMUcLksQbZyGF1vl8z8XBI6q3053KJvy5ILxA3
	xGS0+UkGFvnlCiK8q10HsuxVkuetKFZsAkxovx65Loe3wejglQ2Ujf4MPOKEsIh+
	vUxT58SRyIoifq6dT4mH+KtSbq1LYdPyWeY8n4oEmwcyS9Gusw/YWnraSDqreRLX
	2OSk8ZnboNzvhJI8HohkcA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437smabpw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 15:41:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2FOijc030975;
	Mon, 2 Dec 2024 15:41:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 437wjb6p1x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Dec 2024 15:41:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciklhC5sb5OBh+jwfxgYHS/vLapHN0QDs94Tx5WdImUHtbcgydEGBhg/hSClVnSNEckECnzA1WUXXMoIGUkSCWSRPCtW5I7gJ0d9HqThIKc6Q+GHyzqHmGuyvvWM0XgoiOQQBb9SgLs5wObdYOypsANdQiVbQRNcr6myLSS0OX+u03eJfYSJYRZfwtS3MH7ohri7hj5+Jf+GO1UN5N1JUyZqlcXYeUnaj3NF6/oa79OOC3oUQvPNuReHOYXgeABQmOqqjp5bJrH8O845IzmZSkcTGLoQu/JKg5eFlJx7gjMoZoyBSGw2D4qXgKjiyxGDlou1boJnP7E/vGZfUl8tuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wx2OkKxDOaHj0jZw+UC/DqrrHec5q+PD10kPOz0OGzg=;
 b=aB4OAHzVHTTPX/mHsPgeWU8QuibIPnn++dURwjDG4DYqSdl/64vzaC1yIh/FlBNBN71bK3n8BnyH+ZolBqJh5e1C+g1P2klElleBs2SKSt8ayYlP4T9DmX6mvkxumcWP7G/Z8xsqlSyhTyPt3lW4MayXHvZDCaD/W4YcXfOiALhyOWJhZyPj5H3McA8ZUIwZxUMbEjEpgi9mMbKxVGxCefFs8wW6r7HcIM1QOG82LNwX4j3X4sIU2eJSOwrIIz0gurTgrc6fn+ZzSbzyVXyDmqLWug4paRUoJsZOrJDIeaikM5lLAFKB6U8jv94Togqx7dCkQxQkFyOmew6Nn9qABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wx2OkKxDOaHj0jZw+UC/DqrrHec5q+PD10kPOz0OGzg=;
 b=n+jG7uBXosxM7WDQvjxtYRf1Erkxm3NIk5+UblIQTF+bMQ84Wu3OyK0fwHHIi3YQqlEZSh2i7/J+IkLVSZf9azqBA+xNWbBNB+7EDgilpTVySvecJX662eqIDoj1HMgyik6gzziYQnzXfUwUNR/Ze+2oYtIcNbmnEpt2+G+8XxI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4288.namprd10.prod.outlook.com (2603:10b6:208:1dc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Mon, 2 Dec
 2024 15:41:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 15:41:55 +0000
Message-ID: <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
Date: Mon, 2 Dec 2024 16:41:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0038.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4288:EE_
X-MS-Office365-Filtering-Correlation-Id: 4da623da-388a-47ef-fbc6-08dd12e7d99b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnNXM0hCNFlhRmdYRnZSTElJd29pdEJlRmkvWWdQVVRYNjRRODBoc0VzdjlD?=
 =?utf-8?B?cFdQM256N1RpeWZYTGxUYkNSVm1jVlp6REY2S1hIUzlUV3ZYeXd0V0s3L1Rv?=
 =?utf-8?B?YlNzNjdiRjkyb1NBbE1KTmI5NjNtTEVWVHFpUFNPUTNFYy9yRnZHWE43UCt0?=
 =?utf-8?B?MmVneGR1RkYyWUxKWCsxcUQ5VEUzbnZQSzRhNFZ5Y2tkZE5mRE9BNDAxS043?=
 =?utf-8?B?N3dLV2ZWNkFlYVZoeDVabC92V1NkTW5keDdYcWFpdW04VkM3NXpNNjZFRi94?=
 =?utf-8?B?UUdTTTVJZkJadFFnbXFkQ1pCZk5NekxOOXprUzYzTmdUVUxpNUFydlpqSktx?=
 =?utf-8?B?alY3RTE5dmRSVmJFb2F1RWVyZkRlRVZpNmt3dmFqbFE1R1JlV3VGWEdwZVgr?=
 =?utf-8?B?OTE0T3ppVlBkNXY1d2h5dFdHWUxidGpMRnlrTDdPK2hwTnI3M0lWNlVBSGFk?=
 =?utf-8?B?cHJYTHU5VVBMSXMwMFo5VzVOd2NkT3lRWHVWZnlIRytKdjdFMmpzRG14QVZP?=
 =?utf-8?B?Tk5IS2pQd0o3L3JaNXJwNjB2eGxlQVNSWWJhbFRXdU1kMDhXakZsWG1hekZw?=
 =?utf-8?B?MGdRYVJIWkRldjNhbmNSek0vU3FIM2JRc1BaNDN4V3lSd01WbzlWTjJTRG9X?=
 =?utf-8?B?SnptaXhtUUVwMzFmbHJyZUZlUlNjOVM0YnIwMUN1aFF2UDA2NkhoSjVROUJH?=
 =?utf-8?B?cVBjUzdteWg1U0dEbjIyOUZIbXZrdXF2WlBRVGY2elJFWVNRM1VVZm9rdGkr?=
 =?utf-8?B?QXlVUEF4VFVpWnBYZDVpZkpNUGpwUDFMWTVEei9EWVpzUG1YejJHTHZ1VVUx?=
 =?utf-8?B?M24vWVNMcGdWVmdSUUdOc3R6YTk0QUljVVZxb0NsZHdtNExZQ3FlS1hLUlZM?=
 =?utf-8?B?SGpLU01ST3p2eXh5WlFXM2MrbE5WU0V5NGxZQ1kvOUVpSmdqUkhjQWNpcVVG?=
 =?utf-8?B?U29ReUR3d0RxeERDb2Nxc0doQ3FvdUlNa0dMdVhKa1Y5UElqK3h4ZG41bkF0?=
 =?utf-8?B?VVZJNStCTGtZcGU3bWhKc0tBbk9HWW9zYmkvRTB5SjBXTDJ0N1c2NVF2bk5N?=
 =?utf-8?B?b2VJYTRnWjk3bC81WkxvOHhqUmgxTTYvOVVtZUpxSG8rVHZoV2o1a3RLbmY3?=
 =?utf-8?B?ZkI5U3V3QUVRaTJ3SjhKK3pKTmV3L2szWGk4RHZKZkxPZGs0N2ZHdlNTMm9Q?=
 =?utf-8?B?bHBGZTF5RzFQOEhlcHBRekl5dHp0WG85cXhwT29GeHdibUp0TmlnVm1OMEly?=
 =?utf-8?B?c1ZFdzA3M3dhUXIwZ2thYlRCMXR1dWVDTjlYOVpjQXRBNi9MZ1U5Yk40YlZr?=
 =?utf-8?B?Q1JCSUVhcFp2cG9lYmVZQ2ZwcmJBY0tpKzFRZEROM1hRUE9vNFpxdVdSYWE5?=
 =?utf-8?B?MUxSQk51Z0p2SjFXRU4wMzA5R3pIRzR0eGE4Y1RHRy9Db244c3ZpNXBScHIy?=
 =?utf-8?B?SG9xa3pYQjVpSVpYTTZZYkFhdVBoZU5MREQyYkR2YlRSVmVBYkkwSXN4S2FF?=
 =?utf-8?B?OCszSHJiMU1ZeEdKcklZMWtMTm8zSU5YbUhYT3JEdWxiSjBlajJUZFJVaTRX?=
 =?utf-8?B?Z0VjVzV5bjVvemltNGQvb0VCYWxCMHBxWVYvcndIV0EvRkdvcW0zb0JHaFpj?=
 =?utf-8?B?NExpT3BINXlGZUNwb3hSQk82RlBuYW1zNWl0T056UllQNVpUaDlycDFsNHZk?=
 =?utf-8?B?RUxzOFBXNkhhd1BnNlRHKzRrWnFIQ2IvT2VHQkRabzNJc0tES3JRR01sUG9u?=
 =?utf-8?B?MDVEZFZNTFcrYXRmb3ZxZVp5ZVgweTRIbEhRMUZ6MEJrSHcxWFZjaGVIbGZ6?=
 =?utf-8?B?eEFxcUcvVFMrUHZjV21Gdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1VVMXpCanN6c09qYjI4RG95TGdHN3YrRTJ5eHM3dU5EdFRvaVJrRkxGcDJS?=
 =?utf-8?B?TndIMFhmT3Y1R1VESWVZTWdjTmtOSi81NmdRejZMazdrdWRlSGpqQ0pGalNY?=
 =?utf-8?B?SWxmZGFPRFQzeko5eGhWdFlzdC8wWTFHQ1dIMVFBbDhvdW9MRDBkVjhqQklD?=
 =?utf-8?B?aFdwOWkvK1pyUGhnOXlTNnZVVTI1aS9JMHlOeGJXL1hrOEVPNCtBTkoxUVAz?=
 =?utf-8?B?aXc2QUEvWkdiakhnM1ZUYW5hcnZ4NFlja1ppM0lQQ1NWTDY2Z2dRWGxCTitQ?=
 =?utf-8?B?dFltdzdkano1MG42RVFDMC9KUy9jN25pZlI5dEhSOWY0NW5RWGE0K0Zhekox?=
 =?utf-8?B?Q09xYis3TGYranFpZUN3Z0NEeGk3bWJBN240WlFlRFQrWlJnQUR5MVVFTGJP?=
 =?utf-8?B?ZjNML0dWL0EzaGhvK216Z2dhMExvQTBTODd3eFE3MGNRUnV1aTdreXlvSDFD?=
 =?utf-8?B?S3hJazE0NjdMQXVRbjVncGRwQlpPWmdKZXpJcVB2UlVxYW0wU2VPKzZOc3RC?=
 =?utf-8?B?QTd4MGY0bE9RRFhtS1BJeDdnUkdZdmxJaFRQOTRvMEhtalZrcXBqOW0vbURl?=
 =?utf-8?B?YUFkTElUdStKVjFuVVd2dHZNOFgrdUlaTEtTYU9vSkVNVzMzYVF6UG1SQ1BO?=
 =?utf-8?B?NzNscG96azdZeWV0TXlpNHcwVG9VY0s1azN1akdZL29RSFdLWENMdHREUGc5?=
 =?utf-8?B?QVZ2WHVRQUVXN3Y2THhLNG00clVaSUtYcGdiRThoSmlyYndQWW83cjRTeUc5?=
 =?utf-8?B?MDJ6dEtCL1lPN1pZcCtBaWxvRk1KMUFQNmpwdjRXSHUyUktKSGJGN0JEb2h4?=
 =?utf-8?B?L2F6UXR5RHpic2doZHJna0dXbzJOVTUrK0V1NmljRjdHbG5PeG92WU54OC9h?=
 =?utf-8?B?enhpdDZMNDhMNUVzVXlnQ2dJaFNVVzNodGVzNUwxQUY3ZTVZaWpXeDJ0Nlc3?=
 =?utf-8?B?VGs2K1RYVmFWTTlHaHdOdTRlSUJxQTlpWVJpSWU2N3UyZytQck01VlkraVB6?=
 =?utf-8?B?ZUh3aDZuemNKY1hvQjZsQW90NnJoMS9LYTk5ZFZuRVFGNmhFSlJwUGlUMFFv?=
 =?utf-8?B?VWZQMk1aQU1rQ3duUVdsQWtaVVJPM3MycUx1Q0N1WjVlQ2puY2hxMnRhTGhM?=
 =?utf-8?B?YXZaSHF1cTc1N085YzlOQTIvVW91M0JiOEc0ZytseG9Lb2EwWHlvODIrelZo?=
 =?utf-8?B?ZVFwMEVnT3A0U202NlgxUlN1Tm9WWG9ZR2RTNWV0YXJ2NC9IMHZwQUIvdzhE?=
 =?utf-8?B?aW52M3p3WUhDOTBycm8xNlF2c2dzU1dWQ3lsZVJqa2JnUzB4RGFMemxDU1ZE?=
 =?utf-8?B?VVk3WFJrWm0zRXplU1N2VG42NlgxZWkvbUlGbXRid2E5QTk0OEEvWlNFaXpp?=
 =?utf-8?B?eE44UkhiZ1ZSRDFyOHNBb1lVVG5lTjRzRUFlcVBBR09mSFFjb2FPa2ZTSXNK?=
 =?utf-8?B?eCtLckt0aVpweUxncE8zMlprSmVnZ3pVd2JpNGlYWk5YNThEd0xWWGlUaXpq?=
 =?utf-8?B?a1FEM2QxYzRjTXNJUnZOV0liVlFweDlyTUdvazRNQ09ncElPdEJGRGxpQ1F2?=
 =?utf-8?B?STJjaDJkeHJ3MWZrYTdYUG1KWDdqcm8vVEJrbTF6UTYzRGpteVROc3E0eXdQ?=
 =?utf-8?B?dG03bTFwODBFc2dwOUx4WEhyRjh6ZHpsak52SitUSUppa3JvcnJwOTJ6Skho?=
 =?utf-8?B?LzdwWjFyZzVtbGlzQU16VDFOZmJacnZ0RUZETFFOQ1BxM25uZkNCMGNlcnFR?=
 =?utf-8?B?YUtUUDA3UnVqWE43YmhYcjEvaXZoQUk4V0dQRGNVeU9tNHhQNUVHZVIrMHNO?=
 =?utf-8?B?RVpxZFJhN3dvbnNBK21abTRra2pyNTlpTkF3Vm9uSzQvUldocUFqS21keGc1?=
 =?utf-8?B?MHA5ZFVDYXpDelkwWkQvZTJab2hrZnIvcDdMckFnWlBaUFk3VjRYTlRlRXZs?=
 =?utf-8?B?dkgrWHM4VUY1STdkRHVXaVBRNnNQb3h6NDdxSE90ektqdE8rM3RLL2svTGtY?=
 =?utf-8?B?QjZNUWx6ZVdMaXZBK0J3dlZKQ3dRYitaQllDMjI3cFplaHhFcjVUaFRuWVV4?=
 =?utf-8?B?TWRDN3NXSHYrcWIwSnpMNXNkb1V5dXVyWkszM0Zqa29SemhFTTB2N0NURzU1?=
 =?utf-8?Q?XHPx7log+OEoU0atUX3MnRhGV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7OKmxAKoAW020TxisytGKZaLjNln7ozBV9jS6nlUMFZXZt39VazBjOYGlXHROH+B9OYNR8QrOeDyRpqtnHT57J54XfUd/7kmpCLruvxGgW4xdGVnlEao/Z4DbiQm1zEM80gw3mJga2by3YFYHJygYX7IqDOVKLzDqX/3mQgrFVxY5YYqIjzYTh04w+KA9kgsifaG310+ivibrwYgvsES4lgD0qKbaJ/G31H9Zu29nxeay648ANEdS89zD8gstKmFBYvrEFY2nB+yURu6Gd+TG6Uzrc2Co2cRfomR7fVUyr45CVqk82CtiqN66mHIUcH271WYDt2Dua8rELIuJP+DsYMpuuOmfnDlRm4xJcyKxtEKzOZ4Tde1L3tMo7UN3c+hAshIqubEs+77032jURM8F9EykCsbPDmDWWPNeR2wtNsFflcNhTlq+Q9ZoiFmEAg2Q0puJw3Nj5cpjF6KHrEhVp9mLGD7nUIToIZz+ELCYbOx1cFSDcXRWge/i6owbRskei7LYAsb7FWRVFlZn3dDCTfhqMFzJH0g8VlcJuYs/airb8ljcoyr1lxCvy1sFCnHu5Yr5zVEX95jiWabnK/3XcqgHrj4i8LJOj89haipy8I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da623da-388a-47ef-fbc6-08dd12e7d99b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 15:41:55.6101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vBroyJKudIMmUrXyquN4C4nJazKo5vkg/LZ/Hayj0ZYhGFAALcZO6sB38phg1zgj8iZgz/BW48j2pwxun0vkh1vjrIL73UkGVVcJxVhDvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4288
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_11,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412020134
X-Proofpoint-ORIG-GUID: rA5VUoyUH9Z7t6GZZ4vXVUH_XcAXTcRb
X-Proofpoint-GUID: rA5VUoyUH9Z7t6GZZ4vXVUH_XcAXTcRb

Hello David,

I've finally tested many page mapping possibilities and tried to 
identify the error injection reaction on these pages to see if mmap() 
can be used to recover the impacted area.
I'm using the latest upstream kernel I have for that: 
6.12.0-rc7.master.20241117.ol9.x86_64
But I also got similar results with a kernel not supporting 
MADV_DONTNEED, for example: 5.15.0-301.163.5.2.el9uek.x86_64


Let's start with mapping a file without modifying the mapped area:
In this case we should have a clean page cache mapped in the process.
If an error is injected on this page, the kernel doesn't even inform the 
process about the error as the page is replaced (no matter if the 
mapping was shared of not).

The kernel indicates this situation with the following messages:

[10759.371701] Injecting memory failure at pfn 0x10d88e
[10759.374922] Memory failure: 0x10d88e: corrupted page was clean: 
dropped without side effects
[10759.377525] Memory failure: 0x10d88e: recovery action for clean LRU 
page: Recovered


Now when the page content is modified, in the case of standard page 
size, we need to consider a MAP_PRIVATE or MAP_SHARED
- in the case of a MAP_PRIVATE page, this page is corrupted and the 
modified data are lost, the kernel will use the SIGBUS mechanism to 
inform this process if needed.
   But remapping the area sweeps away the poisoned page, and allows the 
process to use the area.

- In the case of a MAP_SHARED page, if the content hasn't been sync'ed 
with the file backend, we also loose the modified data, and the kernel 
can also raise SIGBUS.
   Remapping the area recreates a page cache from the "on disk" file 
content, clearing the error.

In both cases, the kernel indicates messages like:
[41589.578750] Injecting memory failure for pfn 0x122105 at process 
virtual address 0x7f13bad55000
[41589.582237] Memory failure: 0x122105: Sending SIGBUS to testdh:7343 
due to hardware memory corruption
[41589.584907] Memory failure: 0x122105: recovery action for dirty LRU 
page: Recovered


Now in the case of hugetlbfs pages:
This case behaves the same way as the standard page size when using 
MAP_PRIVATE: mmap of the underlying file is able to sweep away the 
poisoned page.
But the MAP_SHARED case is different: mmap() doesn't clear anything. 
fallocate() must be used.


In both cases, the kernel indicates messages like:
[89141.724295] Injecting memory failure for pfn 0x117800 at process 
virtual address 0x7fd148800000
[89141.727103] Memory failure: 0x117800: Sending SIGBUS to testdh:9480 
due to hardware memory corruption
[89141.729829] Memory failure: 0x117800: recovery action for huge page: 
Recovered

Conclusion:
We can't count on the mmap() method only for the hugetlbfs case with 
MAP_SHARED.

So According to these tests results, we should change the part of the 
qemu_ram_remap() function (in the 2nd patch) to something like:

+                if (ram_block_discard_range(block, offset + 
block->fd_offset,
+                                            length) != 0) {
+                    /*
+                     * Fold back to using mmap(), but it cannot repair a
+                     * shared hugetlbfs region. In this case we fail.
+                     */
+                    if (block->fd >= 0 && qemu_ram_is_shared(block) &&
+                        (length > TARGET_PAGE_SIZE)) {
+                        error_report("Memory hugetlbfs poison recovery 
failure addr: "
+                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                                     length, addr);
+                        exit(1);
+                    }
+                    qemu_ram_remap_mmap(block, vaddr, page_size, offset);
+                    memory_try_enable_merging(vaddr, size);
+                    qemu_ram_setup_dump(vaddr, size);
                  }

This should also change the subsequent patch accordingly.

(As a side note about the 3rd patch, I'll also adjust the lp_msg[57] 
message size to 54 bytes instead (there is no '0x' prefix on the 
hexadecimal values and the message ends with a zero)

So if you agree with this v3 proposal (including the above 
modifications), I can submit a v4 version for integration.

Please let me know what you think about that, and if you see any 
additional change we should consider before the integration.

Thanks in advance,
William.


