Return-Path: <kvm+bounces-14671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 500298A5618
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 17:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0FEE1F224DA
	for <lists+kvm@lfdr.de>; Mon, 15 Apr 2024 15:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A1776F17;
	Mon, 15 Apr 2024 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ECtzN1Ou";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YQIvGD7n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966407602B;
	Mon, 15 Apr 2024 15:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713194099; cv=fail; b=tC9BNx21RQCtRfo8qWReTQfuPnZtdEsdttpjYSuGzy+c6AcaqYxT8SKJXoEaETL2T2qI/8eVLTKE8u0V77DEa/LhN/aHnjwJpKFmX1WX0WtmUtwgewzk8KhtO9syBaIHGErkHJ809lTGIA4yhJdnspXv21A0NInQPoupN+dvO84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713194099; c=relaxed/simple;
	bh=7KN7R9suh+GzhFjWIQ4fls0b5Zyr6X8s/WFR53/dUB0=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O1Gzu9SYJwGuOgSHSVDQU9qDcFaNiEVZEfmBfj+fRYRSFsCToZzP5MM4IfoVEskAqVWhfE8VXdHvTTBTi8/0iiSpw6Y5iu9UkegiqACqmupqji7wYeO+N+kDS3HyP3rWgniXgb8oWaB4dQYiNQ6ZkC2T1KHhqqL7IcVCAiQDTuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ECtzN1Ou; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YQIvGD7n; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43FDY5JR017791;
	Mon, 15 Apr 2024 15:14:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=mNO6SrKYtu8IiiATnEJDIHkDbFIitOnbZHMB3357QQ0=;
 b=ECtzN1OuO4d58lLAhstg9EszLOP6/Kqjqk34YA6ur8w+qtWIW8ryMM37wpg8mBOOl12K
 hVNRnrSxnut/WWaBUzrEuucJnevCjfwumRahpfW9GbpL8WTV0RHq+DPvTlMAHr/YpTrB
 VRV8TRvsHiukvoU8q036NvYbQjv1V059b4yqysitdrZ8T5uWK3D70oj9HyI0IioWzHvj
 Amma7ux6R8taSdrkvDrDg9+jWxkZvtWQP7L+YF3vXxwzuCfJZwnz2VQovTocbOszUguu
 feAQU/WViI5k9OkbNkM3hvop+gC4hkyTlSI5V4gbIoasNBJeG7H/mPIKt6KZrKBVB/N4 ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfhnub2nh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:14:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43FESgmt014453;
	Mon, 15 Apr 2024 15:14:15 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xfggc5g03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Apr 2024 15:14:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KeySMdnBr+PPTb2Q8/XccGdjmoeVfUFvCKqIUpsZomKoYRRt+VXxpbej16HBTbA34h22WAw1lu2P1eOMjtkx9cmMwjEvYabQjmtsd2vfAPsODMh5IdAuQgxQ8PsI0Tw/6MgKEPpwnbINSw6L5vMljTqcAm50+Qd+e0gX+NubEilHc0yUkohDwNV3YuduMhmFu9qj9v1ZhDBTmTeU2jbsNjgWAEqYgM/JpUmm4wV9p07hwv62PyNbumr0orkrRb/BgfF1T030lv7KF1GlRox1cw91H1d7UfuTMdT2SDqFfQmpiivaSGB8bH+z04DRqkyvA9+kTiO3uYptm7XBKyX84A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNO6SrKYtu8IiiATnEJDIHkDbFIitOnbZHMB3357QQ0=;
 b=HJ57G3pP0OzfRFo+bzRpsdyO+SJFBnLqd5BVl4tJjx3qOsLR8AV0ig1HorwIijVG4pXhYNE4/0w9755I8QmM9wo9gZ6vbCPQQIzG0aLI5pMKHii4xhtsmM32QEUIaphp1tSLh+iXcHmjzzhW1DVqtQN0uj2itQV0ilrx7i86vHBpXtgqp0VyGCIpwFi6UTLfU0V1GDIdbT6C+jwcIopKt08EMlmzYe4K+iNEL2wu1EVSAKaFOi6MvV9fH+DTL605ScNQwAaaEyzetHuNP3HemfSxSvBTxrZJzMJA7JTEU4nX0hZCeIhPf9kOmmDBCjJNjo31Rzcoc+/n+TbNvDOhKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNO6SrKYtu8IiiATnEJDIHkDbFIitOnbZHMB3357QQ0=;
 b=YQIvGD7nCIcUrx84Z6KJjkN8onpD+CR1s1Ux9AGD8QO8Fr2RQ2dTwAMVypZEQ6wV/P8N6Gzt47bbDjKttzW/XP+YvK2LvwSBk7bSk2Gw8c8Ggujl49jcg7o+TNDH+KT/QwqL7w2/VByPYmPfEBpoULPu1mvj4HIpnjB60cKLNUo=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by BLAPR10MB4996.namprd10.prod.outlook.com (2603:10b6:208:30c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Mon, 15 Apr
 2024 15:14:12 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::1481:809a:af18:ac44%5]) with mapi id 15.20.7452.049; Mon, 15 Apr 2024
 15:14:12 +0000
Message-ID: <2af16cb4-32ed-4b91-872b-f0cc9ed92e59@oracle.com>
Date: Mon, 15 Apr 2024 17:14:05 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.sneddon@linux.intel.com,
        pawan.kumar.gupta@linux.intel.com, tglx@linutronix.de,
        konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Set BHI_NO in guest when host is not affected
 by BHI
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>, Andrew Cooper <andrew.cooper3@citrix.com>
References: <20240411072445.522731-1-alexandre.chartre@oracle.com>
 <7f1faa48-6252-4409-aefc-2ed2f38fb1c3@citrix.com>
 <caa51938-c587-4403-a9cd-16e8b585bc13@oracle.com>
 <d47dcc77-3c8b-4f78-954a-a64d3a905224@citrix.com>
 <ZhfGHpAz7W7d/pSa@chao-email>
 <95902795-0c2c-43cc-8d87-89302a2eed2b@oracle.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <95902795-0c2c-43cc-8d87-89302a2eed2b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0081.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::21) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|BLAPR10MB4996:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a9625c4-54d3-47bc-4bb9-08dc5d5eb449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	B5wgLmSKwUZfVT3CTQtT9vMrSpZG+BBV9tMct9jkbj8wWjcxOEnMqwCoDbSh58SqnVBJzKSEdbN2d7Fy+g+MSAScnNcHMz+PYf9Ml8wMz/SDI/HcIio/bLQXb4sw8q8VAggzFukItHnsX74rjc3lySvknGbAMahCuxeYwhaCjrNIGxFfZTfJxaFVFlN8x41ZKXHKdt7d+xkSGqSLn+IZuPa3kh/9MVVDqa0ZPOb6YR5tNojYZMDydyfdDhDqMo3z3t0HXRjhTHBFz2RPCnCI8yIXgYe6yFD3g4nhammTSdqI7mgfzPh9FSqDZrvMQIkpqT9ayDR0+bJwltrIHbCWjlKS/xlKgRfEM7+NxaxyaC9tPqDumfwJ0nIHUF3NNd4v+iO0g23MRoiR2T4jYyxpUGMcD2OE29xroIPMBA4zSgkrZHjGjRU6GiINNxpmpzlM71AHBCt9CDTKmF8y/y5WImpKOMhIUYSnmUEAUKGU1wkV2LqWcZd1IsJ3M43etx/GjQotSXG3z5RAFX6BmFfdEEEsNuuTvEniJaKc/BKcEF1UbButi+FoYFYZUggsP2UAx9bv1VuJpBN9KAQPICOAnNM8AH125ZzMYmPG30D2PjYeHr5TTZZol5aTFClyLPXzYjuPH8GSyEM03cRQQcc6r/jh1ywBY2VXY4IIZaSgFQQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WmZYQm1NUVFGUkN3dTNmRlBjRDVPTEJ6N2xjYmUrWFhFR3ppN3prSmNhSFph?=
 =?utf-8?B?NDJ4YS9MUnR2WGdxSDdFVngxbVFDS0lwMFhNdlA5MGVNSFFnRUdaT3BSdm1F?=
 =?utf-8?B?SXZWcU92bGVWRnFETDFKcWNrUmk1c2cycFZMMU5NTFBtclI2UFQ2NWJnbHhp?=
 =?utf-8?B?TFBQT2ZvNS9hdXQwRXpyZmhOK1dlWUs5czRoTDl2OERqQk9CQzk4MW1JdkFz?=
 =?utf-8?B?Y1ZxcTJVL2x3M2ZSU1A1UEVIMkRqME9tQmVvbk9uamxudWtMZm5TOXNXMUZZ?=
 =?utf-8?B?Ny9MSlRTajlMbnhwb1FYcTcrZzFGTndER1E5VUVycm9SN09TUTZ6K09QendQ?=
 =?utf-8?B?dExONHZMcDMySzBDWlYyQlJTMTdtWm1xejh2TXNDRWR4cFVkV2liRDN1VWs4?=
 =?utf-8?B?UGRHakpTMWRHcGV5NFhlamx5Y0FiYXdLRm5mZW9xRkRKN0dJT2JhVEtjTE5L?=
 =?utf-8?B?QmNKMVA3V2hzQlozRithc3FRVXpjSXJuSDdUS3grUlY2TkRnY2IyT2xHNlJt?=
 =?utf-8?B?OE9CVjRYQlhTK1Q2S0Q3N3VmVGpBL05PRVN0U3RRSGpSYmRqQ29YMGtYSzZq?=
 =?utf-8?B?MzBBNm54ZnFyaGoyOXhPdGw1Vk1NMkJyYXB5YnoyaU9EblJXb3plbk9TV1M1?=
 =?utf-8?B?K0oveW5Da0xhc2ErMFhPdFliSGs2ak5mN1pyVlRpYyt2bXJ0YXMvaGtJKzAy?=
 =?utf-8?B?TlFiMlpTWjRxMVl5cXNjMDVyRWlrcXY3NGZzazJ3K1FrMDZjU0o2ejVQcG1L?=
 =?utf-8?B?WXNMM2hwNkRIRVV6OUZxNm95dExQaDZudC9VMEx0emVJUGVkUU9WcEZ1NDd3?=
 =?utf-8?B?RlVBU2V3T0d5eVo3aEVJV2EyZ2JhUEV2cEh2aU9NOWEzRVRVTEZ0LzdrbHZH?=
 =?utf-8?B?eEVHVkNCWmcvcHlaai9IN2Fpb2cvVFAzZ2F4WldiNzJCMWt3TnZCMjJiellu?=
 =?utf-8?B?eGtmYUlTd3o0eDBtZjVoTnI4WlR4Y05rekk1a0RtZ0ZFZDFmMGZ0SERyUm53?=
 =?utf-8?B?bTRHUVVIclZQTWhWOTdqMXF1SnBvOGU0alJDbU5sUUs1SDF5cmFiYlRtcmlt?=
 =?utf-8?B?NW9iOTFSSjlBVnRTMUUxdE1MT1NJNStJVk1jNlBHQkJOZER5bWFRMVJNeUhl?=
 =?utf-8?B?MWMrUTYzTXJ0L3M0eUtEbWx5YmFOZHZIcWtsVXdaTCtBaEhOYm9uOHUxeHNC?=
 =?utf-8?B?aWtCUEF3TkRLNGlLcnRGaHpJU0ZreXZscDUwam96ODhHYzFqQS9oVG13MTg5?=
 =?utf-8?B?bDRaSTYvZHFpeWY4djNCSloxVFF5SDIrN2RqSGFmSzJRRUIvaG1pWU1IcWV6?=
 =?utf-8?B?OHdOaTVQc0w1cm5SSkI1bGRaR005ZmpPVVRmMjZ4cnNGZnZNVFpsM0ZnNkpF?=
 =?utf-8?B?c3N5dWtCUXVxNUVMdThOQ0tpUDNBODh4amJYcGdLWEVOalFrcUk2aXMybXJP?=
 =?utf-8?B?MmhWR3FDeXU3Y0pJWDB6aXQwVDlOT21SS2lIc2VXVGhvOXR2MjRMOWh2aWtK?=
 =?utf-8?B?eGtJUDl4ZlFvSWpUNCtQWWxwSWtHWTlIMVVoeDIvOTdZbzdLL0IzYXZBRllI?=
 =?utf-8?B?cWROU2h5WTZHZ2QvcU81enFXcGNMekt4TDRWellDeG9YUjJCM1crcUhaNUUx?=
 =?utf-8?B?NG40ZVUwOW5WQStQelZGNFYyVmJ4cE1hUCtvN2pZQUJkYkVVN0tTMzBDLzVq?=
 =?utf-8?B?dHVtTDRBSU55MFNNSjh3QmZoaUptQ0NYcnZEZHloQUhoYklHZ3NZZitOOVdR?=
 =?utf-8?B?OEdBRHBnckdkbjNRbFRWc2hHZDBMRVcxMDNGNnVxVjNvTGtwbFRHQ2djOWNW?=
 =?utf-8?B?M0VIVmwvMXJPRVRjb1FndkZxVGpHWkRxM3drcXkrbW5wQkRlRUVkL3hCeXFy?=
 =?utf-8?B?UDZiMS95LzkxRXBwRGRIN3FZTTFsdCtxYXUrbUtyMWY5c0tzUE5WU29zaHFR?=
 =?utf-8?B?aUl5d2F3TER3M0hlTTM4aFhBUG1aN296MWxMVVJlSCtyd3JRci92ZnNsbk50?=
 =?utf-8?B?OFcvVGxIVUVlOFI5d2FQUC9yNlVBVzgrNmhQOXRVMGx2TWYvamFwTGloVjhk?=
 =?utf-8?B?RXV5SlpBclV6aXJZS3E4bGlPYmU1YkxDYnY1aGtKcEtVckNPcDl2dERLcFpW?=
 =?utf-8?B?aUlNZi9idmYzYXpJaG5UdDZPcXJZdk4xTVJjZXZ1Z0NLUi9rQW94di9sbkp1?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PIYRj0/bkcWi9Adn6zErub4ZMgCCzkRFT/P6qUa/gpqlngYOXy7wgLjLAmAM21ZzkOyywBhjoxcnaC8zQjTUtCg/x8tmZ+9JfTAigsZAk1gl+S8H9cy7nFwDjCOfgX2r9j9mbWMHjl+VRixBV0KsRaqG2u95OK6iqtfFkpsjup58yWz8BZKWQhmI7ZhaYFvP6M5PncEuvGUwyXzkNJiuntlRcdddI9vmghFjIdvmqZs94z3wGtnFw7/iIUWjTTJy6bMQWgt7xlhasYIgtFe5DjHSiiINDTpjcOVG5NCT/SFqSW1TaTF8PlFHSclrA+9jn3PJiNW/4NmsTEBN4TbLKf8yFmx52NcTshvRnW8JONWCawXeuS4DMq1KI2l3CoZj6+8VzTPFxwOXV0sKWhRYCr04TVhSA+6MtEyNjZP4cSBeC/4t6b+fD0P8B29mILRIsZE5MS7CvmZvQ8lTPpJzpBCvByLbgjbgfmWxr2eu/qrEaUyYjz93nikv/VuPbD7T90uEelm1QUxjSZyoSafSpS5hwRx0Dw54iHtEMlpwbq+g+0L9yTQnlFRqhj9FkCs6QXM0cnePpYGaOZl+oz30Iwrg5NtDQ4HDUgsFSNIsZzc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a9625c4-54d3-47bc-4bb9-08dc5d5eb449
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2024 15:14:12.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0H0TNVGus6lrTHwamrIzB0q8+Z5ahiq/mWKg0v/QW45Az9RjpZlrvYAoRCce7dAP6+h9YeXturwpT+/dbyaj5bwUVbNlOjXCIIpxD9ZwpQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4996
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-15_12,2024-04-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404150099
X-Proofpoint-GUID: PjMT1sC5CcGKWyfxT51DdJJigAZBtWp-
X-Proofpoint-ORIG-GUID: PjMT1sC5CcGKWyfxT51DdJJigAZBtWp-


On 4/11/24 15:20, Alexandre Chartre wrote:
> 
> On 4/11/24 13:14, Chao Gao wrote:
>>>> The problem is that we can end up with a guest running extra BHI
>>>> mitigations
>>>> while this is not needed. Could we inform the guest that eIBRS is not
>>>> available
>>>> on the system so a Linux guest doesn't run with extra BHI mitigations?
>>>
>>> Well, that's why Intel specified some MSRs at 0x5000xxxx.
>>
>> Yes. But note that there is a subtle difference. Those MSRs are used for guest
>> to communicate in-used software mitigations to the host. Such information is
>> stable across migration. Here we need the host to communicate that eIBRS isn't
>> available to the guest. this isn't stable as the guest may be migrated from
>> a host without eIBRS to one with it.
>>
>>>
>>> Except I don't know anyone currently interested in implementing them,
>>> and I'm still not sure if they work correctly for some of the more
>>> complicated migration cases.
>>
>> Looks you have the same opinion on the Intel-defined virtual MSRs as Sean.
>> If we all agree the issue here and the effectivenss problem of the short
>> BHB-clearing sequence need to be resolved and don't think the Intel-defined
>> virtual MSRs can handle all cases correctly, we have to define a better
>> interface through community collaboration as Sean suggested.
> 
> Another solution could be to add cpus to cpu_vuln_whitelist with BHI_NO.
> (e.g. explicitly add cpus which have eIBRS). That way, the kernel will
> figure out the right mitigation on the host and guest.
> 

More precisely we could something like this (this is just an example, obviously
the list is clearly incomplete):

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 754d91857d63..80477170ccc0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1182,6 +1182,24 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
         VULNWL_INTEL(ATOM_TREMONT_L,            NO_EIBRS_PBRSB),
         VULNWL_INTEL(ATOM_TREMONT_D,            NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
  
+       /*
+        * The following Intel CPUs are affected by BHI, but they don't have
+        * the eIBRS feature. In that case, the default Spectre v2 mitigations
+        * are enough to also mitigate BHI. We mark these CPUs with NO_BHI so
+        * that X86_BUG_BHI doesn't get set and no extra BHI mitigation is
+        * enabled.
+        *
+        * This avoids guest VMs from enabling extra BHI mitigation when this
+        * is not needed. For guest, X86_BUG_BHI is never set for CPUs which
+        * don't have the eIBRS feature. But this doesn't happen in guest VMs
+        * as the virtualization can hide the eIBRS feature.
+        */
+       VULNWL_INTEL(IVYBRIDGE_X,               NO_BHI),
+       VULNWL_INTEL(HASWELL_X,                 NO_BHI),
+       VULNWL_INTEL(BROADWELL_X,               NO_BHI),
+       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
+       VULNWL_INTEL(SKYLAKE_X,                 NO_BHI),
+
         /* AMD Family 0xf - 0x12 */
         VULNWL_AMD(0x0f,        NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
         VULNWL_AMD(0x10,        NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BH


alex.

