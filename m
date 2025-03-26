Return-Path: <kvm+bounces-42017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AD8EA710B9
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F59C3B1EC3
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 738EA18DB19;
	Wed, 26 Mar 2025 06:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BgnQUUsQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kcvSJXZI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34EC2E3370
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742971635; cv=fail; b=BcZMr/WwTZ7SpFUJZv8ZsFMA4pW0tQpS50jOAZlZy3h5viS6kFY34WvAcZhC2vD0anM4QqPP4Xa53tB/hR8OPgR8x8avc8kTNhdS1a0XXHSJxsdDXDsWbMswSBFpJiiz3FT3S5H3ThpeeaWyKLt7qq7GEGusy4wXAwt/1pEbhxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742971635; c=relaxed/simple;
	bh=fAs5aaHU0dg7D3YR8u72rbx8WxHUgZ3JS51hEnxMI8c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qgygBawtmi86Qs6oycS3Cv4yowH8O8ZHqMKoqzTaToWTRAsC4bJFTd5XOvNvIwoV6beZ7oKtU1BYuYIu3C3h1ZEhEhbkVs0ad9kpGU44UpHY2+zctCAlXmr9+nhgK+2DAfYdyPyzRb4fg53Hh/mzif8+/mRuiYhbHoK1KA3JV00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BgnQUUsQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kcvSJXZI; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52PLtsiX020322;
	Wed, 26 Mar 2025 06:46:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1zLVZrhUDWanVGxNbx76LRKRZDpQbIqzifR/nJb/jIw=; b=
	BgnQUUsQPtrazbfsV001R8lEi5+UFzHAgMTX9nhOs5tAmJvKD+brkkQiL6nXpgXn
	unTV/u3KB7MYUE/0CPz0TUCf0csE5Y3FnTZBa1vkUXS3CjjoaVDrBzZpO2D0GtiD
	8DnCMWdO8d1MBMXYsUX2DPD4O6kLMzvimaQuznzXkNybE74rWpOSEddQXS67nkon
	Zir44VWQjrHQncm4a/ibiRWG7RL9+qOKGPfV1odTgxmZByCtgWleCn/wanU0ZeQV
	IhU+Y9KjDs0J1PN+m3N02Rpy7GW5xjOJI1OcCShIplzIszF0L0Kc4bO2hOPWv/76
	zk76pwBx2CSQ7eG/O/YNAQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn9c0rqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 06:46:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52Q6V0ho008700;
	Wed, 26 Mar 2025 06:46:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6v647s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 06:46:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lofgBBQm4+izOUCAXShmZuMxLGBYhoj8FK3YAOOyAHiv10ZGzgicW6RbtJHnT0ofBcLnmCq0m6n4l3IAVr2mFEavO8KETh1Px7+Yg+MZEMhhwjDldBLTjbeKy8hr10xZGx1bWoJi/AVjeN8XT9svd0TCfSmQu8FOa06f5xWk/z1mwYe1iZVp51gUHITP3MiuNVJ2FLcHkBo8kDwptCUenYMgBNgZpQScRUEuN6cNabxK9hJyuY+8N+Vzq2Zew6gQZG3nGkHpjn2Xw+XDp45IKS32MJN/ncXYWk1xnGrxqMebSOLW1OnK//9oQByOPZxOIT0RAXFc8uyuCebrZJ+PkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1zLVZrhUDWanVGxNbx76LRKRZDpQbIqzifR/nJb/jIw=;
 b=XFt8Rt3CQK4JPXsAxybj7WEreYnqxvF8iYddkJ/7DcyJV3crU2C0MfykpHL3y0HpQGH7mknZC1BGCB9ggOemZWyu88ZcO3vln7QPzM0DDyd9JmWf3qgZAPMdJ6XQ0IUKq+iWxbowIen+GVi7ELvXuEVbD+4Y7NEDSZ5Q+6Sxdd46P40h0tZUzQW5nvN5APuvN1eawCSKkhv9GLwsU0IeAuue6D7XOYsb/UY4RYmggVFhDxEQNApSfN3TEzmxJMxfeqrJ0u/PpMcKhoYyL7W1OJwsPuWy6xg70lQW04fGk9UUxapWTBqSo1P1DhdLHjMN+6oaW1OTZj0CrI3eEgeKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1zLVZrhUDWanVGxNbx76LRKRZDpQbIqzifR/nJb/jIw=;
 b=kcvSJXZI0VvPs3/wOQ34Pslr7XGEbXWPDM9un9igyX8iMtRJyF3DjQbTVpmTtiRhVgn4aaKsLnwxO3d5ej1t9TxJa93u6Eap+GGwdiEp2VPGoQ86ecmmh3IRuXV8Ft16xgfG6OK9zc2OFKyD2fAOHIULEfP1S0ZnS74HOmQvH2Q=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DS0PR10MB8029.namprd10.prod.outlook.com (2603:10b6:8:1f5::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.44; Wed, 26 Mar 2025 06:46:52 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8534.040; Wed, 26 Mar 2025
 06:46:52 +0000
Message-ID: <3a01b0d8-8f0b-4068-8176-37f61295f87f@oracle.com>
Date: Tue, 25 Mar 2025 23:46:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] target/i386: Call KVM_CAP_PMU_CAPABILITY iotcl to
 enable/disable PMU
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Zhao Liu
 <zhao1.liu@intel.com>, Zide Chen <zide.chen@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, Mingwei Zhang <mizhang@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Das Sandipan
 <Sandipan.Das@amd.com>,
        Shukla Manali <Manali.Shukla@amd.com>,
        Dapeng Mi <dapeng1.mi@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20250324123712.34096-1-dapeng1.mi@linux.intel.com>
 <20250324123712.34096-3-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20250324123712.34096-3-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DS0PR10MB8029:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b7e5a1-fb18-4dac-c362-08dd6c31fdb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzBjSy9yaDFMb0Njc081ZHFhYTluK3hySStJcjR5LzV3K0gyV0RzbU1pQXVv?=
 =?utf-8?B?MEk2SWJVanF1VUgzUHFFL1hsUEdlb2JwSTRycUgrajNNMXQ5cmxNZ1VrR0lH?=
 =?utf-8?B?dDVURWRHWlhMQW1sYk4zWC8yb200YnplSzEvbzhqVjR4ZWx2M0JSNmNoWE0r?=
 =?utf-8?B?ckpqUEVqRVJkWXlwVEZDWlY4YlVlSmYydG9jVndrSEExcGFGTE1MMmErMzRP?=
 =?utf-8?B?QkthSk1mbFB0aDh2b3RIcFhVeXZXaXdDandudHNKSWI2clY3Ull2RkIvQmVu?=
 =?utf-8?B?YlIzdkVEUDhrcVRmSXFkakdHdzFUN1ZPVG00SkxEVnF4WFN4NDdGcm8xVG9t?=
 =?utf-8?B?NG01U2xLbWhRUzF3eVRqQUR0UGdWckVpZVgra3pCck1Rb1h4Mmg5SjVCNlZ2?=
 =?utf-8?B?bTR2U3RwQ3pLaUdxbTNad0NHMitjK041dnpnOVBOTHlKV1VEOStxQTVieGpB?=
 =?utf-8?B?MHpYaE9FRitzRUFDaGFsK1ZEc011bmhGYmxhNWo0VjU2UWVjbjdZUVdyeDhs?=
 =?utf-8?B?cXQ1MVJnUzJueHJwLytyd0RNZW5lYXRZQWh5OTFlMnQxSVZuVFBjbUxzZ1JC?=
 =?utf-8?B?aXB6SG5OTk5LQjcwalY0NERIQUFMR0VDL1VJT0pCRU1xbENoQTJaNmZrcmJT?=
 =?utf-8?B?QUZvcjdKbHkzWnU3Q21LalBFM1R6ZTI0S3BRdTYxUnRickpMdnZtd0lqSGkr?=
 =?utf-8?B?eXJEbWJvSjV2MHUwZ2UrWmw3THlWZDByaEhTSytvRytQZitkYTZXM3BuRkpD?=
 =?utf-8?B?ZXhKZndVbTFMUm1NTnhreTFCTllqa0FEbUdLZER2eTEyendNS1BuMEQ0VGRh?=
 =?utf-8?B?ZG9qZW1teGhxMnRXZXpmdmpvZU5Kb3lqRG0xYWRucno2ZHR4bTVNQmUxUU9H?=
 =?utf-8?B?bFJlM3JWNUkvaDlOenluVXJra202WUpnKzFXdWpaUFFBdCt5NXlKNk1xRjdV?=
 =?utf-8?B?bzdyWlB1SG1oVFdQQWg0dU9xSzY3dnM4YmMyMERuVjlQVFJWdnRYNDlFaG1Z?=
 =?utf-8?B?U1dST0VsdGNZSVlJVkIzbmpBU0F1WUU2Vkt4K0JWZWsxOU1xSTNxYXEwTWJP?=
 =?utf-8?B?dUNoMDVnWldBTjBjNTJpd2tWUFEyWnFTVisrSi9WNTNSRy9pUHVodkhiMFRS?=
 =?utf-8?B?M25RWEpLeHJRbHg3MXhTR250S2lPakJ2dndaY0NoOUhXRm9IZGhNaGZ5am1o?=
 =?utf-8?B?VVlwYWpYUHhPdmE5YnN6T0lZRUJLZStOMHkyZUd6Q3dxK2ZTSzRBTTJncW9F?=
 =?utf-8?B?emI0WEVDS1JpaFJocEdWUncxclllMGFlUDlOeUpwcU9VVGptT1lIRFd2TXZ3?=
 =?utf-8?B?cnpXMDROSlZrZ1dEU2F2ejl0Ny9kcFV5bnhQbmQ3SEhpMnBNSkdYUzRmMktW?=
 =?utf-8?B?RGR6Vm1vbzBNdGhaNUJLWE9xVWJZSlo0bmx1RS9sVEtnWFlSV3JiMU01Vk50?=
 =?utf-8?B?UThhdy9uVDBmTy9IOGg3dVA5WTd1SUozM29OaW1EMlRYWHBZQ3lhS05UV3hQ?=
 =?utf-8?B?WGpmWi9OOEdyR1JsQ3NUNjFZdkt2aFRocVd6UjdrN2ZrOUozQXRtWS9CTUZu?=
 =?utf-8?B?eWlpL1JVdktJa3Urd0laU2JuZEhNS3M0WUhzc3oreGx5TEw5Z0Y4d1hVOXlj?=
 =?utf-8?B?eXhoS2pMVTB2ay9ranlyeXBkTnN1eGIwMVZCRlZaSXh2cDFsYldWRUptd2I1?=
 =?utf-8?B?SXNrYVJacHF4cko4WWRwWDNnNUhTc29jMGd6SlcyNTZTbjA1KzdQMHJ6Tjlu?=
 =?utf-8?B?VklVb2hQNVVqYkVoL2U1SC82VERBemlnZklTUko5aExlNjNCOEZHOGh0Q0U0?=
 =?utf-8?B?ZExsQ2FvZUNJcjJPeEJUdSt1RmE4anRBMDgwUjRrbUM4cTg1OVVGM3B3VWNN?=
 =?utf-8?B?TmJmQmxFdjZLNVJsMzZUMzJrRTNwbkIwYWROZllteDZLRlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RC9ZSVlZMTM0QVREVE9kZGRUUnpkc0RXUHhYM05RUXprRU90STlsbE03V1NZ?=
 =?utf-8?B?SEVicVJlMDd3ZWsrOHdVWjBCazZlU2tNS05lRTl5YnlwZnhGM2VuVTFYU0p2?=
 =?utf-8?B?SjhOQ2IxNFJwdXhtRzBIWXdPTWFTb0laS0hpcG5LRmJKSGhRNFdiZm9vM21z?=
 =?utf-8?B?VVdZSGJvQUo3cmt3OW4veVRwcFJ2OEpyeVc4OTArcTlWRXpIYm9lTVZOTlRB?=
 =?utf-8?B?T0RoRUo4REw4NmszbnJaVU5lQnNwZnBsQWNpQitwOWFESFhGMy9DWjN6OEYy?=
 =?utf-8?B?NTczbTZVeWVJUlUwajFZRUdGRmUxbFgvSFVQZ2lkOXFHTzg0SlNJdmxQeVNH?=
 =?utf-8?B?SHZmV1JGUmFtdjRzY3gyb01ZdUc3czRmbXNYM3lYY1FvTE04czhEa21mRzh2?=
 =?utf-8?B?cDM5dkpXK2R5MG5XcVJ6SkJHUm1Gd2Nvc3kzeTB4ZVoxUnVkVzh0cDZiUDFB?=
 =?utf-8?B?NlZ1cE95cGZRanhtZmhPSzdYck9ZRzVkeC9Nc25EZ2Z2YjI2OHozREg1Z1dG?=
 =?utf-8?B?di9BZ1JGRzh4ZDZLd0VreHNDcHVudkgrMXRZOTZnVTQxckxkSy95bDBMSHhi?=
 =?utf-8?B?SWlSQUxseTZyV1lsQktDSXBnOGN6aFFIOHEyNmVneTl6bTltVkNVUm9jZ01Y?=
 =?utf-8?B?TFdEVXFjNDJGYTZLcysrTjJwWFIxTjdiMHRlbnh2Q3JnMytkNk12NndnS0lX?=
 =?utf-8?B?UGpSMXhRM0wzNDVpT09kS3AzTk8zTldCWmZtNkVqRFV4eDVCb2xvK0V3ZHI1?=
 =?utf-8?B?NGtqU1pHelRGS0ZCZ3ZEN0pSM2N0WTAwNTlzUW9rbitYR1FqMEExbDBSNnlZ?=
 =?utf-8?B?cnRsS2UxU1NtekFuem9Xd2ZCMU9ob3RyZHYrQXZ2UHF2WTdrRXYzcDRpT2Jq?=
 =?utf-8?B?V2l2dEdFK2lJVy9Wc0EyRHovUjc5NUVnQTNhSnF5dWtRdXJNelJQSE5lNDZS?=
 =?utf-8?B?UTFhRkVZM0FCUWh4Um9IY1g0QVIxbERia2gyNkVBc08zN2dDbGR0eXVQSlg4?=
 =?utf-8?B?QWRhcnJkSzRkQ0dodlFaUzd1Mjk1NFJuZVV2dld6RGV1ZkRPY01iei9IaWFr?=
 =?utf-8?B?bDQ3cmNOcHBVNFZLbTQvMG80QXQ1TWREL0hxeUh6dDcyaVlCcklRdzFiMnE5?=
 =?utf-8?B?c1NVcnlaL3ZUSHRWc3Zvb2diR0NBUW5mZUtEUEo2VW1RR1R0U2MvNWh0K21C?=
 =?utf-8?B?dTlGcjVDQjRZWHg0QjBNSThBUVRJVUdwZk81QmI5N2pVY3pTcnUwSkRrOWNK?=
 =?utf-8?B?eHVvSklPdmJIVHVyaUpzQzZ5U3dwZ0VSZTcyV3A4Zm1GMlpSUVVzb3dlV1hO?=
 =?utf-8?B?T3pYcFpYNklJcldiMGpGUDNJNEpjZm5DOHdManU0NHhtNXhSUWFqNHdiYzNO?=
 =?utf-8?B?ZTFhTnd0ZHJxQjRDakVSdVc2THNNTmk1NVdyeG1NeC9uc0g2ZE1GUXZUajZ5?=
 =?utf-8?B?ZVRxZzBkMWU5Ni9RbFdwNkJmL0MzN1FqYjI0VCt3a2lveTUrQXdvWXloRkxL?=
 =?utf-8?B?YTR4NzFWQnZVVmcvTXUxNGN2UENqQ3BQZVhHUXFHcXVHeThKbzdLZHNGcWl2?=
 =?utf-8?B?MUJjY1BEQVgrc3hmc3BCUTUxanJLcElGOUZvTmpCaHhiU0FIRVdyZFpMaEFZ?=
 =?utf-8?B?ejFVT0x4MlRHcUlpTDRtNnBZWkhzcjJsRDg4WGRtaWR4VWpNTkhUTmxld1hl?=
 =?utf-8?B?MGk1S2U1VitCdEkyRlA0RDMvbDdNNWJraklJMWdZVUZlWVgwZnRqeDdZYkRE?=
 =?utf-8?B?MWVUMUpPWTdhemplL2dGZG9SOHpEYnFMS0JWRWZOd0JzNkI4ZlJvK1RZVGE1?=
 =?utf-8?B?OGxiUHhXTVdTM0ZEb05FL3Z0MFYxQzY0MXFCQ0dQV29LeUpVS3hKb0Y2eXVa?=
 =?utf-8?B?aTluUVdmR09WQTVIR3ArUWJRSzQ4UXNPVFpYbUx5K2J1K3NHWHUyUDdCRHF4?=
 =?utf-8?B?cDZYUDFiKzhseHM4K2VMcmtjYmRjM0hLd0V4NlRoYnVRZElEcmZOK0dHbG0x?=
 =?utf-8?B?SUsvNi9PZFdrcEdRaHN1N2NRVlFnWEtIOUptUnk4WStsYVJ1R1FQSi9ybkZH?=
 =?utf-8?B?Y1RMM3l1dXJNNjFkL1VpNW92MmJYbWx4cEE5ZjVRZXNiR2p4SGh5d3MzMDdS?=
 =?utf-8?B?NVVMWkozblpDRXdWWWxRME1KL3FtNnBkWXRQTTNsN1JnZ0xyR2drVDVidTBM?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QcMZg5UZgLsJzu3ZVs+JNQwnpSgWUMFQKCRmMK4F/dMROV3ic4ghlktdhNNffpGeuVzXdCC3dJwLyQB38r5C3HuwLPswGPqfFfrnzY95ymmwdJhV5Mx6wqncj8n7ctnieG74DzdUPzIao6uPdtGQySlaRk9PUZmYm4RgXGHCL/vnTXXVoynSoH1z/NIt3AfLTLoq7zpCv75olEGY3SlsUGkS386I2YccPUzNy4/jpTkvZkwu+vXmjLLOmrj4VLGl/LLV2u9PIq3moJ3NVP3jWe8oAxMR7VSB2TD6JOTpqxMIEqgVlfdHmdBWE7cZJlZ34Vx81pDdCt4jdKgyLYzT3dwf+akIt1Up7YU1K8VEV7E7Lu7runJ7oQ9oEw9P0MS1F+d6S2YbLnN7vD94R/MK93OmNXvlKmlKmtM77oBwDrxXLBI9EhL6tKI87LK28vY+LIN8h6oTznMAQEuQuytmhNW6oiAhCJR2a7TfLc3wAEKD97gY7/ccEpqyIyrgpB44gnRkW5YZh6L5gMm2nKpcOPHc9H7KZgb+yWXMsF7PPoweJswqpVO7SEORtcRnr3XgdcAQizDKXvfK9htLLPvvr+1SK82Kl5sRiYXt2ayZGuw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b7e5a1-fb18-4dac-c362-08dd6c31fdb2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 06:46:52.3852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yj20Nhqy749YesbDOhEzcmPe1Ib0kh/gJyVUyOonZ6Gq6UlkZaP9np/vzqlBfTOdDE6AtjbnIqO8M4f5PwqP0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8029
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-25_10,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260039
X-Proofpoint-GUID: 7tW_TiIn7TtyJ2RTehpkBHkHmjML92EW
X-Proofpoint-ORIG-GUID: 7tW_TiIn7TtyJ2RTehpkBHkHmjML92EW

Hi Dapeng,

PATCH 1-4 from the below patchset are already reviewed. (PATCH 5-10 are for PMU
registers reset).

https://lore.kernel.org/all/20250302220112.17653-1-dongli.zhang@oracle.com/

They require only trivial modification. i.e.:

https://github.com/finallyjustice/patchset/tree/master/qemu-amd-pmu-mid/v03

Therefore, since PATCH 5-10 are for another topic, any chance if I re-send 1-4
as a prerequisite for the patch to explicitly call KVM_CAP_PMU_CAPABILITY?

In addition, I have a silly question. Can mediated vPMU coexist with legacy
perf-based vPMU, that is, something like tdp and tdp_mmu? Or the legacy
perf-based vPMU is going to be purged from the most recent kernel?

If they can coexist, how about add property to QEMU control between
legacy/modern? i.e. by default use legacy and change to modern as default in the
future once the feature is stable.

Thank you very much!

Dongli Zhang

On 3/24/25 5:37 AM, Dapeng Mi wrote:
> After introducing mediated vPMU, mediated vPMU must be enabled by
> explicitly calling KVM_CAP_PMU_CAPABILITY to enable. Thus call
> KVM_CAP_PMU_CAPABILITY to enable/disable PMU base on user configuration.
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> ---
>  target/i386/kvm/kvm.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index f41e190fb8..d3e6984844 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2051,8 +2051,25 @@ full:
>      abort();
>  }
>  
> +static bool pmu_cap_set = false;
>  int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>  {
> +    KVMState *s = kvm_state;
> +    X86CPU *x86_cpu = X86_CPU(cpu);
> +
> +    if (!pmu_cap_set && kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY)) {
> +        int r = kvm_vm_enable_cap(s, KVM_CAP_PMU_CAPABILITY, 0,
> +                                  KVM_PMU_CAP_DISABLE & !x86_cpu->enable_pmu);
> +        if (r < 0) {
> +            error_report("kvm: Failed to %s pmu cap: %s",
> +                         x86_cpu->enable_pmu ? "enable" : "disable",
> +                         strerror(-r));
> +            return r;
> +        }
> +
> +        pmu_cap_set = true;
> +    }
> +
>      return 0;
>  }
>  


