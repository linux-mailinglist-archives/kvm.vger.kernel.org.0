Return-Path: <kvm+bounces-8813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE879856C2C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 19:12:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F36A28F06C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:12:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F8141384B8;
	Thu, 15 Feb 2024 18:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IjXoVJj8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Mufruidu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57658136999;
	Thu, 15 Feb 2024 18:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708020758; cv=fail; b=kSpowDT3JS4/agbf5CL+7LGYyKpwsxgnZnEvPfg0C/g1Qp/A5cu+PHrge22U+CPP9R+QEk9D5cU6pPz5lzsbsdKzIgOVOS15J7BX23TKVlBPIcKOV0L8EYfm6sObOBafARW6UY3+C72WiVghVbncmef8PwZN4j/rIkUuFBePjpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708020758; c=relaxed/simple;
	bh=TLYmv4EbSt5SjKEkh1MPUW9uTlt7t7DGNUPbl515BIM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LsoN3L5zb6g1eaDeOZ1Wa4scYRu/6WougouJ91CZoWVjPCBQKQFpQxcwEaryGSjdZdxsSChxqsyg4V4RlY3+K1dCz4yKyD9pDP0/yrZONCoqfBQWOJ07xOOZ0TCYyjcmWCCzGHXGRX1vO4ZebfqcLyOjDTXQ9x3y8RKmoRZ/y/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IjXoVJj8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Mufruidu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFSscx030992;
	Thu, 15 Feb 2024 18:12:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=gr4udBDXu0Jl8YhZS+1qN8pFnpkE8t0sekNPG+jr2Nk=;
 b=IjXoVJj8jqmECze7i62zlx3SnNoxfookPZ712hBHka7FLfjtiE+jROXTdSxYsUix03VR
 +L41Pw2C7IBT9JwLHAhKjhlo/Y8M6kyI5lmP7ghaB9GD+AzXCz+hXvBJo7tPVCU6bxme
 X2LK4VvkXqYVGRn37PGBRuwpXziJsmTfinXFZEdZxJBADnZJYB7oLmrKsQ1CtJav2uuV
 XdTZmmzFYo/c0g7xY8ERfZ9Facxms8s/IczDFeoR6XvLKz/y3rMqcLoMivjCqbxwk4jn
 N+LOHELiNrv+VD892L9bP5gsIjIrLXK7AfGFx2nVWt+ybJHv0O7sbdLMmJ3wsvOMndu8 Yw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w9301jvr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 18:12:32 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FHtPiR015103;
	Thu, 15 Feb 2024 18:12:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykawst2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 18:12:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IO8s3TszH0DsL/GDwyFYELdJo0Z0UDYd/RJ0vPuLcooLauyxqAOUtRPtYI8q6P+QHsUksjjiQPxx9f2g5+H/XbHwk0i5MeiCn/zBxcHRyxs7+n0ENTmSHtPZwNd+VTNoaWbW+3Z6jkMmmy5hT0qENMZsKqI9ztRrLBYyn1WmkkhIoE4ijxHsOZOjz+7ET0EHTRA4Ol0V8sNcbLSknubFQ75aujWaKuLXiM+SPTli3TQv+nzkleKaU7gkwSWjFxFvQntjAUhO7PzkouZJITYZROSKi4bZolBxCrV32JWeG0ZInJQaBYENLUOSLebyGu3TiCd7CcYXTkBLd2cX/LMLJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gr4udBDXu0Jl8YhZS+1qN8pFnpkE8t0sekNPG+jr2Nk=;
 b=aLsRIQeguwkW4cTHK2xbSbgZMXTc4gtt/J3PPa5mOILtAiHNRCY6q0VGhXVGdeyPXjQmJI0EdpBnNIwQg95BysfnyfhLWhGyQJy6ruIQyacedP1NR/2zRr7ou/WLiZLKY6BtINRN/BHZHRmtqZ2U9XUa5EK9bnsTCmJl/6NXo/fyV5BkKhTtRtNF9fi+GZK+PzZfnmBOKecWG1gcrNrd6CLwYPKCkMZzAKoGpcSLlHhHOkUum4/4DjFJYUAJ3JBMbuBliS7crSa8Lf4KI4XTIYfi6hTv2vZD6+sDPgAjwjnIb9urVEf/Ok5X7Sw6AHtiUyIWAGcLTwuoJjeLmXuIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gr4udBDXu0Jl8YhZS+1qN8pFnpkE8t0sekNPG+jr2Nk=;
 b=Mufruidu7LkJYNmzEf9SpJqjTBUMXgeNQ0yVHKxle47pmkjg1jhRXzQXF3XyaimYksqSksRsKfdn79TZ9+w2F3ZZOx1KmRFLKdIBTX9+2HSGH+36QhvDTWqW/Dc9zhfce4mR6nxCkzoeyx7bi4eCmkwEqrHeqqvDcXXNntASH7E=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 SJ2PR10MB7015.namprd10.prod.outlook.com (2603:10b6:a03:4c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Thu, 15 Feb
 2024 18:12:28 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::2067:811a:3ac5:b30f]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::2067:811a:3ac5:b30f%3]) with mapi id 15.20.7292.029; Thu, 15 Feb 2024
 18:12:28 +0000
Message-ID: <b7177278-2a39-4fe6-9690-573b70e2ed0e@oracle.com>
Date: Thu, 15 Feb 2024 13:12:22 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/3] x86: KVM: stats: Add stat counter for IRQs injected via
 APICv
To: Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-3-alejandro.j.jimenez@oracle.com>
 <56130d48-706f-d1d0-bd23-69544298f353@oracle.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <56130d48-706f-d1d0-bd23-69544298f353@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0123.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::20) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|SJ2PR10MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b83bf1-4975-419d-fd5f-08dc2e51ab9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	wR+dePb2h3KopxC14IoI633sy5u2u81ME4XrpA1L/p9IurA8w0+db01bUjSKhzYmWbhWtXDa2V4wzsmIgKlUr76HqBJOfEAjrRekqNAIUDRXWVaejqTbXYjOrA9I7L/S9p4j40HhsnB7rweY2sSXW0Rrk+cAZhMe7SxMx+ayYQ0GMSRkmWLPnnBG1aIk/OKZldldO4k9edE/abDQA/uviEF9Jc/ANnXDJ1hdNxiS/DNPTeN4eff1bdbej60hOvk542rLPnDCwsZjcgsnPDzNj8OaRRaMc3vtxXrlkQfMXm8wnlucD84yE62/dNtpVaXn2d/ILVE3DKuXQqrtlWEHx8sLmq/j4mLfTjySc93sbvwwbwryuMxwIMibdFRWA3OHHQGUHkEIErHsTOpHMzID5SfFQJgh+KNmPX2cbAljWIUhtEfzv3D3lH66R27Uz2VsQ/faTfD3ZTkeixeNyzjM+R5PefN0zJSV8i4ACWSOur2kUv7MYJdRxDeeaSaXWHc5t6WIVG1GC52y0m46hKSS8whiJTekLq3wWuLIc+xa/0msJXVcboRTtdM8agWX7iWP
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(376002)(346002)(396003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(31686004)(86362001)(38100700002)(31696002)(2906002)(4326008)(5660300002)(8936002)(8676002)(36756003)(66476007)(66556008)(66946007)(6666004)(6486002)(6512007)(83380400001)(6506007)(53546011)(478600001)(316002)(2616005)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UUxVY0l0bjRGMVlYaUZBWk9xcU9OWEkvUDl6QVQ2dnFWdW5vMnZlMXZLeDEv?=
 =?utf-8?B?a1FyYkZvNUlFQXNyeGxiY1dJZ0VuTHVlUFZRNlMyRnhJYkg5L2UyaG9tVDBo?=
 =?utf-8?B?VmN6Um1VZ2Z2ZXZBdFhJbjdkcXpEYnFWdEgydElnMDhiTy9Tbis0L0dIczl5?=
 =?utf-8?B?dWV3TlpGUCtiNGxOdWZ2QnJjSDVSWjNHaVdtWHI2UXRiWFBOSExBendkTkdJ?=
 =?utf-8?B?b0pSRnlPcGtxdmpocTZ6SDIxMWo5YzNaakFubThXOVMvcVJScFF5RlVqb2E2?=
 =?utf-8?B?WlZqVVlJcUxURVVidlBZaktZYnVPbG4vRWtKTThRdnZUWENpS3pMWmxkOXBl?=
 =?utf-8?B?c3lRQkQ3UjYrZjN5SUJNekpmRWpZS2I5QW5IUDNwajQybW5qdWRwdUtNK05i?=
 =?utf-8?B?cFVvWE1hcWZXeE5talJNcmhLaXJ0RTZqOUs3OHBXT0ZBK29jelJEbTYwWGpD?=
 =?utf-8?B?dmNhKzY2Qytkd2o5eVRCbVRXOU5rZ1JSM0ZaMWpOSDFDL0RWS0dacWVpcWFr?=
 =?utf-8?B?d3FvdE9YdFB0MWtZbmEwWXZET3A4WWoyVUZzbEpmZXRZQ1ZlaWtXblFzWW9O?=
 =?utf-8?B?QmVLNFZPTDh3cjlDMGUwZW9LVnJKRkMxY09aUUN5Vnd5Z3RyK1k5UVU5YXR1?=
 =?utf-8?B?TlViZExqd1phWFE3VVpVREdNOWxSUHpNZnBhcmxxcXRWZ25CNXNoTEFoK3U0?=
 =?utf-8?B?UXFFL2tINi9lMUUzbWhra3hFN0c4UU9qY3RyeE1jQjEwbG9FMWpiRzllQ0Rj?=
 =?utf-8?B?QkRrYWE0dGR1TVcwV1RHZUhsbmF3anVqTHpDUG1yRGVuVEl5bEEvZTBmbjFl?=
 =?utf-8?B?bFR2WElJZXJBbHMzWlJNR1lWcHh2SzJIa01uNEk4bldkMjAyWEpmREhvVldr?=
 =?utf-8?B?NkxOMWdVMitsZDZkN2k4Z3IydFdFSCtPenFUUGVYUExkVDJJKy9sUUE1eits?=
 =?utf-8?B?RnlZTUE5R0kwSTlXM3JkSmdWOFlzK1YxRjZoWldwbnM0Y0wvNUU3Qlc2R2hp?=
 =?utf-8?B?aWM4ZTFlRkVteDZYUFdCNGd3ZlFnVHUwNWNKd2VJSHAzbUVwQ1UwS1VNTGRp?=
 =?utf-8?B?SktWOVQ1NGM0UUFyMSs4TDlXb3o4empUNEdCZjQ0Wi91dGtvT2NKdkk4T2hy?=
 =?utf-8?B?bDBCZmphTDBxWloxZEI3ZUxob1dLSGorMmRubFpwQmFFTm5Ta1dGTlM4MVVs?=
 =?utf-8?B?UDNRb25WUUo1b3NoRXRVc2Y1YkNRdVkxUjdMR1JJTjVwNWY0T0psVXp6VVdM?=
 =?utf-8?B?UklUN2xTeEluMzZGalFLZGtlWmF0MUt5NEhnOHcxMUtLcjZIenFJTjUrcXZB?=
 =?utf-8?B?VlFjanQ2MkVOalEyTFlqaktVMzM5bWdKQnpJcHJPSGxtTTFiTGNGdnRQSFZX?=
 =?utf-8?B?Z1l4M0lhODhUMnFMMGM1WUZ3WHNWWHQwMEVFWmNKVTBsQ1BMOWl2Q0tXOXZp?=
 =?utf-8?B?Y1VJMEx4OUtNYWdZNjVDaUJKZ0I4UkJ0dHpBMytrY3M0WFVxeXNrQ0Mwa0Rx?=
 =?utf-8?B?bnI5bXhvQ045OVF6NXpRcmJWeWpNbWRrbk8vZm03UjNYbCtPRVZOcFZDblEx?=
 =?utf-8?B?YWZTWnFiYVcxZk5SaUlQcE9CT05OYStVaUN3SWYxQmF5UlA3RzdSa1JqYXF6?=
 =?utf-8?B?S1ZmdWk3Y3kvMTMxVlFpYmovWTVnZjhxajFGcUMvRVp6Z1N4QUhndWI4dUdP?=
 =?utf-8?B?ODNlVVB1R21DaFE1dllGbGFzWlNKNlZkS2RLbUYvREpiNVA0c01WSGo2YUFI?=
 =?utf-8?B?SzdpNEFuR3FySFNQMlZYRzlmd3FpTGxuMXA3dE1ZMFA5UVZieGVIcHFQamVB?=
 =?utf-8?B?bnNpYlhrYXZMV3VPNi9BWi9tUkFYWDhyak1XWnNId0k5cEt1eVZEUzVZV3Iy?=
 =?utf-8?B?MCtKNFJJNE5iYXpYU3hpc1pIcUhGbkMzV2FPbHFGSFczQTlVemswaHFDcTBu?=
 =?utf-8?B?YWFUU2VlWGtZZkpyV2E4dEdQZWZTWWVkYlNZeEtRV2I3SXhUd3ZIQytEaFNX?=
 =?utf-8?B?aXRBbUVUSklkdVBRQmoxQWNsQllDZ0E4WDFiTEpCUzRUb3I5RzNhOTVlNnpu?=
 =?utf-8?B?YnZwOU5YNWQvVHYzRjZ1RGorc1piK2RCRmFVN1lrRkpoODErQVhlaFB6RERm?=
 =?utf-8?B?QzlvT1ZFNDlOUUprdEM4VVBHM3hUaXRSMUp5MHNEdy91Vk8wU0l5Mkt4QTZj?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	DZvOs2SqClw7Y/n+nV56TEXaTlafUzpG3T1EpVkguCE+dcOS1OxDWYxU24ul+8WCqAKkuNs0JLAccRW6VH/10ld1l8PPC8YvpPfIKPLEFAUha+4+PsX+X0ymnDEdLqvaV2cc97YX7uam1JY1wpFYpbr29Ru264B4b6nh2T+B1EU7VJbmXQk0mBa92wbsSh5qDf3P0vLKKh1Jal3y8q0FYS87tGf82rEvdrlI+QM1M5AKBmsszuSqlGFJNPkzK6nmxgBwe3hZGNH4CeQuzhit4819A29ZIeWie7iAfH0QUWxu+h9d8ANCtdzoU82JEjdvmfO1ijW3jCnHJP5/p4cgm1sFs9Ay//FlkQHBhvxSsKHpbjhV1cyqn4RgVnYppI/CNA2QkMFuwMy1w1KvjVnJcd99C2L/zB2OU65KokwTCH5ZojIy5NtYvw7NVKPIdQvrW95Cs4apiGN8eesbTTnO4kRDti3nCBKejTYHtKqVmy9cSSWc6ZHESUZfKZ7qj0n0ioobl2m5diU0BegVxnV9IN3Ws2aZCYmvegcuvdj8Na+LQ98y+s2R50umMT1LLJki34TfViCPLS9Cu8zU7sqpzXNxmp0BSrKQYVDsi41XE44=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b83bf1-4975-419d-fd5f-08dc2e51ab9a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 18:12:28.8211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFzT429hXzEydnubdpJEE+tKTVzJ1R4oe7sC6T3JJPRg08t09SRap552x768gwDE2zn55QKjoMmrgzFpkKXPtqRSBs+38v89SXeXYLV1obg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_17,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402150147
X-Proofpoint-GUID: 0eIwmYp9TH_42nlpt1MF6TRn80V2AqNy
X-Proofpoint-ORIG-GUID: 0eIwmYp9TH_42nlpt1MF6TRn80V2AqNy

Hi Dongli

On 2/15/24 11:16, Dongli Zhang wrote:
> Hi Alejandro,
> 
> Is there any use case of this counter in the bug?

I don't have a specific bug in mind that this is trying to address.  This patch is just an example is to show how existing data points (i.e. the trace_kvm_apicv_accept_irq tracepoint) can also be exposed via the stats framework with minimal overhead, and to support the point in the cover letter that querying the binary stats could be the best choice for a "single source" that tells us the full status of APICv/AVIC (i.e. is SVM and IOMMU AVIC both working, are there any inhibits set, etc)

> 
> E.g., there are already trace_kvm_apicv_accept_irq() there. The ftrace or ebpf
> would be able to tell if the hardware accelerated interrupt delivery is active?.

Yes, the tracepoint already provides information if you know it exists AND have sufficient privileges to use tracefs or ebpf. The purpose of the RFC is to agree on a mechanism by which to expose all the apicv relevant data (and any new additions) via a single interface so that the sources of information are not scattered across tracepoints, debugfs entries, or in data structures that need to be read via BPF.

My understanding is that the stats subsystem method can work when using ftrace of bpftrace is not possible, so that is why I am suggesting that is used as the "standard" method to expose this info.
There will of course be some duplication with existing tracepoints, but there is already precedent in KVM where both stats and tracepoints are updated simultaneously (e.g. mmu_{un}sync_page(), {svm|vmx}_inject_irq()).

> 
> Any extra benefits? E.g., if this counter may need to match with any other
> counter in the KVM/guest so that a bug can be detected? That will be very helpful.

Again, I didn't have a specific scenario for using this counter other than the associated tracepoint is the one I typically use to determine if APICv is active. But let's think of an example on the spot: In a hypothetical scenario where I want to determine the ratio that a vCPU spends blocking or in guest mode, I could add another stat e.g.:

+
+       ++vcpu->stat.apicv_accept_irq;
+
         if (in_guest_mode) {
                 /*
                  * Signal the doorbell to tell hardware to inject the IRQ.  If
                  * the vCPU exits the guest before the doorbell chimes, hardware
                  * will automatically process AVIC interrupts at the next VMRUN.
                  */
                 avic_ring_doorbell(vcpu);
+		++vcpu->stat.avic_doorbell_rung;
         } else {
                 /*
                  * Wake the vCPU if it was blocking.  KVM will then detect the
                  * pending IRQ when checking if the vCPU has a wake event.
                  */
                 kvm_vcpu_wake_up(vcpu);
         }

and then the ratio of (avic_doorbell_rung / apicv_accept_irq) lets me estimate a percentage of time the target vCPU is idle or running. There are likely better ways of determining this, but you get the idea. The goal is to have a general consensus for whether or not I should opt to add a new tracepoint (trace_kvm_avic_ring_doorbell) or a new stat as the "preferred" solution. Obviously there are still cases where a tracepoint is the best approach (e.g. it transfers more information).

Hopefully I didn't stray too far from your question/point.

Alejandro

> 
> Thank you very much!
> 
> Dongli Zhang
> 
> On 2/15/24 08:01, Alejandro Jimenez wrote:
>> Export binary stat counting how many interrupts have been delivered via
>> APICv/AVIC acceleration from the host. This is one of the most reliable
>> methods to detect when hardware accelerated interrupt delivery is active,
>> since APIC timer interrupts are regularly injected and exercise these
>> code paths.
>>
>> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 1 +
>>   arch/x86/kvm/svm/svm.c          | 3 +++
>>   arch/x86/kvm/vmx/vmx.c          | 2 ++
>>   arch/x86/kvm/x86.c              | 1 +
>>   4 files changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 9b960a523715..b6f18084d504 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1564,6 +1564,7 @@ struct kvm_vcpu_stat {
>>   	u64 preemption_other;
>>   	u64 guest_mode;
>>   	u64 notify_window_exits;
>> +	u64 apicv_accept_irq;
>>   };
>>   
>>   struct x86_instruction_info;
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e90b429c84f1..2243af08ed39 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3648,6 +3648,9 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>>   	}
>>   
>>   	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
>> +
>> +	++vcpu->stat.apicv_accept_irq;
>> +
>>   	if (in_guest_mode) {
>>   		/*
>>   		 * Signal the doorbell to tell hardware to inject the IRQ.  If
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index d4e6625e0a9a..f7db75ae2c55 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4275,6 +4275,8 @@ static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>>   	} else {
>>   		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
>>   					   trig_mode, vector);
>> +
>> +		++vcpu->stat.apicv_accept_irq;
>>   	}
>>   }
>>   
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index f7f598f066e7..2ad70cf6e52c 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -304,6 +304,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>   	STATS_DESC_COUNTER(VCPU, preemption_other),
>>   	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>>   	STATS_DESC_COUNTER(VCPU, notify_window_exits),
>> +	STATS_DESC_COUNTER(VCPU, apicv_accept_irq),
>>   };
>>   
>>   const struct kvm_stats_header kvm_vcpu_stats_header = {

