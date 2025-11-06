Return-Path: <kvm+bounces-62246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FE11C3DE03
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 00:42:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DE11734BB36
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 23:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF0033CEB2;
	Thu,  6 Nov 2025 23:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b1GBHuk2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uo94358Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7E02DC797;
	Thu,  6 Nov 2025 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762472521; cv=fail; b=WTAq9NtHMbzIIx+wuK+KcoRyWIXrCTPLSsOJfUdwYuJhyuZXScbztovDRE2PrOmoCDd9ytge/7iV79Wvu54wgOvmgkA+wk9KLGmC6OZavV2jiIWW4qJUd/1vN6j2IBeuHLPgg+8M0hZF/jZKfuI6PF77bIp7Kj5G592CF5yJMrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762472521; c=relaxed/simple;
	bh=JWL/MtpY8V/gmQ9aOG3w4RXhuD3WNPhpQf7ITVJzh3Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cLtql6HE1gdhwYCrCAXJaL9NCILGIkomtfqVGpGMZXaQ0oCKr3GwQKnwzeweCYP7Z7pEkqRgDNa6//5jcftygkWNo05B19E/YLoBg1HtAxy1JO3jxBk2N6sfyVQDNgZsNUVGEv5TJOOFer8HGIEFK79d8v6x2i7R54GET1K8vg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b1GBHuk2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uo94358Q; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6LNn6B008915;
	Thu, 6 Nov 2025 23:41:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HV5LegfSgk9yVu/mu+Xg70FHa+dVePAX0mZWgTnhdxY=; b=
	b1GBHuk2FKkLG0djnQytJdNnb1ATX5Pu1+ReIJRaCwHrUQ61vScbO7Wft9NV1uSP
	DnB7afWPlZP9104JD7pIDKjhH2IGO3Pkdgi2OmJKv6GOFOxmr/WCLXMswW7gIf0M
	IK8nOuliimCQSXCxcchbl5szjnx51w7C0gqh/aw08fbrH36ZVH4IeRpo6xKsFYmg
	OFxu0ilXrpxS67Qul22YqzKziK7y7gJHB+jtEKEg6N/E1p3O1S8oj5uFIfSxW1D8
	ylIzIfiFLri5qaibfGlpFvLU7Uty1jEQAqjJNnF+rYMYtJIItSzDYuxBDlPOwKgx
	M/zwZ8ePD4ZVc3OXNivbXA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj0rqn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 23:41:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6MfCND035874;
	Thu, 6 Nov 2025 23:41:24 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010057.outbound.protection.outlook.com [52.101.61.57])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58npwfgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 23:41:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w6zN2pumpXeMdIUkTpWKg1K14P5Q222csTHfYmM3Ja1lEHH1VDfEdvK/d+YXX81MavRtaMxxEYM76qFHwCRmB65M9f70SMyumX9YAKjIx00Z0D0Aj0S1WtyNcdKqsQ9oiLQTpoGZJW8YnCHH4FxZOZtTjVeKLoUuNsH8IbU34mUxAIoIRpeYjIVItNIRrVhQTzihTJwWkRnB6tg6caZiT+67LCIqit9M3QgKf/jkW9y4RIkQOvgzg58lmHYvNVRtV+oN8bagWwJHc+QoEAqBokWUMhGgvPKpdlNjR5WO0bqxkzZjwrXXf7k3TO8P5r+KA41jPcDF74TVH5POhR62HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HV5LegfSgk9yVu/mu+Xg70FHa+dVePAX0mZWgTnhdxY=;
 b=nVy4FjYxHE6XdFP4jWss0QdDf8BF/m+UJQAuyNf19rHNhlHsWzuJK41coI1xvkisfapvyp8Hc+W5xvaWI91VpBAL9haswz25ajWM3nPxO3SA5Ns/iHJiCi8zXMxcZDOISmlhp/vN9e1N+nQstNs9bbUyRWJ7wDyB02v487eyoBu77ferIYm+1UY/nN6ugXSf1E44odaVyO0lhLWc1nn/UNjn68igTNS+NF9OvhUjNiHq4NVtI/OKW5EEbEjMeA9fIsZpNiz5fI4J/3YXk8FX3BVtlwbk5F6EGhq2KpSRArx9kI5G2lh1x/sluJ2Yf04ZTI76a1Igmkd7zUZmv+hxHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HV5LegfSgk9yVu/mu+Xg70FHa+dVePAX0mZWgTnhdxY=;
 b=uo94358QDOySX89s9Nrnl9t76KJI0giY8vOnuuAeXh6yUrWnYiEAEGd1XJYrlvR1j8g4w7yznB6zRgVvVjNGrB71oqxHn5MjikF2/ZptXNVhG8/P6Iwic2MvekBnpGCeCo+cnziaRWb9vqeByTAMS1kzPdn82VT2qJ4RVGt1Qn4=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DM4PR10MB7473.namprd10.prod.outlook.com (2603:10b6:8:18a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.12; Thu, 6 Nov 2025 23:41:22 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 23:41:20 +0000
Message-ID: <9a54bd8d-ea42-4c9b-afdc-a9ae3c31b034@oracle.com>
Date: Thu, 6 Nov 2025 15:41:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: VMX: configure SVI during runtime APICv
 activation
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, joe.jin@oracle.com
References: <20251103214115.29430-1-dongli.zhang@oracle.com>
 <aQmtNPBv9kosarDX@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aQmtNPBv9kosarDX@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::29) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DM4PR10MB7473:EE_
X-MS-Office365-Filtering-Correlation-Id: 53062122-6a3b-4860-f4a3-08de1d8dfcc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVNvNTFwRVFIZHpwSDRlOUJPVGJEQldsN0VHYWtMTXUxSnJrVmVNeGF0b01D?=
 =?utf-8?B?MTMvd0ovcmkwZklNMmh0eHZoVFVkL2xlZEptQ05XVW1QbGQ1cGw1enpuZ3p2?=
 =?utf-8?B?R0J5aG5mV0pBMWlJdm5JcEFqVER0a0FHVlhTWHZtOUlnOFJRaGU5UU92NGkr?=
 =?utf-8?B?K3B4UCszREFWTlFaSThlZ1JnVnFScVM3aHA5V0Q1K0Q2NEZ2ajgzYkxWeUVW?=
 =?utf-8?B?Z1d5M28wSGhNS3kxd0kyZmlZci9rUzFCNU45NDV2VWp6RmNjY1I1QzF2MGQr?=
 =?utf-8?B?djNNeUFOVFRZOFl0bnhrQUxuV2FoSmcrVmU0anlTajhROHNxUFlwUmp0SUhy?=
 =?utf-8?B?M29RYUxQOUp5aEtqdG1RN3BDb3hlbit2V1Z6RGlGT1M0YUFRaUlvNDZtTVM5?=
 =?utf-8?B?QmNTRmpKeG1pQ0hocUIrOXpjWXZldnpxT2JOYVozZmI3UTVxajZVK29saDZ4?=
 =?utf-8?B?UkpxU1lUQ3hRODg4cW91QlJJQXg2eUNhYi84aWlYTHNlY1pxblc1UFNJbHZ1?=
 =?utf-8?B?Q2U2ekV5QzZIK2tvSTMweThmUUtzMHFIUFpjVmV3Uy94NjFHcGk0d0VSVFRi?=
 =?utf-8?B?SmFydGpQck9XbTNybEZiandEaHhFTWhGSTBNYnF0Qm1TOHB6UUlkSjBhNGt2?=
 =?utf-8?B?Y0xFVVpxZE91dmFyc3g1NFl3MWptd2NDOFc2c2YwRXNTYjBCUENZdWEybWx5?=
 =?utf-8?B?TmhMSVdCVkhHWHJtT0Y2d241OVhqVFcyaUdadGc0NXRDS1BKdWN4dHdCWFBx?=
 =?utf-8?B?Sys1QWtkNWQ2Nm9mTzFrUzRHazU5NmxLbndPRTd2NUJKK3drWGEveC8wV0tF?=
 =?utf-8?B?OWhHcnZpaFF1NXVZNmthd3JMSmc5Nkx1MTFUS2VOaFBPcVpVWUVKeE8vUEt2?=
 =?utf-8?B?R0EwdFdpcFdmbXM0N0RSWVV3WVhCZVBxU0tLaEVNN3YwdWJPaEFVaVdnTm4z?=
 =?utf-8?B?NW5EWnpySHM3cWhRZEJEMENXaXlxZlRpTld3STczUzlSN09yZjBzcVhOdXlN?=
 =?utf-8?B?U2FIMERUd091anFUK2IyK01PdEJPVG1yWXRGZE5yMkxmU2RWT1MzVkF4ZTIy?=
 =?utf-8?B?Y08rOHNCdXA1elZOU2QzM2FKQXlJMi9zWEtTVlA5SFAweERoekRzSTVEaHJv?=
 =?utf-8?B?d0ZCRStzS0k0UnV4YjR2eEhETkxwZWVLcHZ1QlI1WXFqR1RrUHVIbUY3Wmt0?=
 =?utf-8?B?SlpXLzBKdC9udzJNRHRSa0QyRTIvZFo1NjB2bzlaNWVJYXBLYnZTTENHVnpp?=
 =?utf-8?B?T0tyZ3prNHRDNGxiWEFOWjJtY0ZSRkt5ajBjYnFyT3B4K1hzTnVQTjJSSGhs?=
 =?utf-8?B?WUgxcU5DOU9sTFZ1MS8xQi9SRzQ0dFUvcytYMXdBMytKTDJCbmtPekthRzZF?=
 =?utf-8?B?L3pCL0FmaHF6djZDa3daQTNVU1hvSk1LT2lOcWtJU3JhNjh5TFVTMVUwT1dT?=
 =?utf-8?B?WmZUV21KUC9LdjNMMzhSWG9VRnZReXRzNVhtUWlUcERsZHk4aWZ3OGtNU3FV?=
 =?utf-8?B?UHYxZjRBWFd5Q1NJUkxkUy90OUtMNnVUTTNmcWo3NEY2QzAxRmRLN3Y0M0Fn?=
 =?utf-8?B?cUJGUVVXbzEwQWNOQ0JqSk5zT0wwS0hnZytoR1dXTkNreHdaTjVsM2ZrU0xv?=
 =?utf-8?B?ME03VkdUd1pNbUVnNGJnK0orMkswV2VUOUw0TGduVEsyWXJ4bXg0SGZIQi9S?=
 =?utf-8?B?LzVwR1BUTkVaMmNVaDgyakhCcFNhYW5JK05xaVVsdjJYaWQyYTFmaFJjKzFB?=
 =?utf-8?B?QWJZMktDZkJMYUVUR0I3eHZuUjE4UWFwRnc5ZmR5czZDaGMxY3ptZjI3cGpI?=
 =?utf-8?B?ZkRPajU2Qmplc3RVRGdNbGYrZ25OdG5mZHJjanRIR3IxbmN5aGZsSVRFcEZB?=
 =?utf-8?B?WGhjcU5hN25EU0FxUU1EbHdqMjVsUEd3dG9LOGF3QmxkQlFWc1dzWkJCbGE3?=
 =?utf-8?Q?2N+QcOZZGdR/wLMXQIkhScTSTox2SBHX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTVlNU0ramhrbStNNlRYV1FLUlRFODB5Q0NQK2JJSktVZG9QY1NTQ2dWTGhQ?=
 =?utf-8?B?TkNhcDJiWk5hajZBZnYveDhFMGNiUW5TbVlhd0EzdTNKcFg4SXFzd0locU92?=
 =?utf-8?B?NEx5Z1dsMEk4SXJoZFpOSW01TUpNMDNSczFEa3d0MnRWaHdzTjcrM2lwaW80?=
 =?utf-8?B?cHJCMFNZaUtmTWlSYWRXK3gyMmRDSjBoKzROQzdVZFd1T2NiTFltbkZiajc4?=
 =?utf-8?B?MVRGWlkxR1MrNEU4R0JwczlqTXdqUWh4ZE13QWE5aGc1clZ4TVNZbjYyRVo5?=
 =?utf-8?B?WmQzK2l4dWZ1bWRBemRiVTBTWThBZk9ORDZRQmZMUmRQM1dDcEdvd3VlRWkr?=
 =?utf-8?B?a3UxNDlFZ0JBdHRlcnhUT3c5eE1uM2RVUGZ6dVlGWDZnUTV4L3U5eEp3eDJP?=
 =?utf-8?B?amJPZ3dqem1vaTExTkxpOUNNdDJ3Ym1TQ1l2L3ZaRy9iT0t1dVh0cUtYUjhx?=
 =?utf-8?B?d3JyTDZNdklDMW03RzRuTVZ6UTM0YnlyOFc5eXF0dlJiQ2gyOUhPMFRkb0Mx?=
 =?utf-8?B?cUtwRTlXWTE2cmJnZEl0MTYwbFBPSWxrRVlabUdEYVhaakJHNlZQSjJsSkpM?=
 =?utf-8?B?aDVMbkZQWlR5aDNCbkFzMHJRYWw1TmtkdmFPNDR5em01amMyYURDakdKaHFW?=
 =?utf-8?B?eXVsb3NVUGlYTmUyOE84SzNzOWZPOGtWMlZGWm03OWwwQkx3V1lEM1gzV2px?=
 =?utf-8?B?ejQ5VTkrK0xSOXBXcWswRU83L3RjYlBIZzQvaE9iSjNjOE5pSDZiRkhxMlZL?=
 =?utf-8?B?aGZmS2d6MDJ1R3NvM2g5bzNrWEFseWlJa1YvemdDK3RrY01NTlBSVmhodzZW?=
 =?utf-8?B?SFl4Y2MwWEV3UitLRUhZbXVHMG5nVmlZUmd1L01IaUNpQlFLcmtPaHFUOFZX?=
 =?utf-8?B?Qy9pSWY1dzVxRVhOVndGR1lqZCs5SHk4WFZ4QTNiSDZPeDY1bEFhaVJvam5O?=
 =?utf-8?B?Z25xQmFMY3RVLzBRNzBvQW1JSkxvVTI4ZVkwZ2daTFN1WXJDcTB1M0tYbXBu?=
 =?utf-8?B?NW83ck0zZWVEc2t4MGgzbTZVc2hjVkJneHpITTIwY1N2SnhaZVJKSCs2WUtp?=
 =?utf-8?B?bVBLdVVSa0Y3aDF5MXdqSTlxVkNrcVV2UGkrQTF3SG55Y2xWS1I3b1hZYW4z?=
 =?utf-8?B?d1VWdXVQM0VnUVRQblpTZzBlMlpndjdyZXZGdFNQNmkySnp5dld1Q2ZyeEt3?=
 =?utf-8?B?dFlhWlNsUVpiNlFDbzI2NjA2cFk2QldNOFp2WCtqTEVrM0JMaVRwZVV5b1c2?=
 =?utf-8?B?eDNYSWV2TU9ad2FaRFJUclI1aXNjaEZQYjIxemx3alpENzAxZElOck5CVlN6?=
 =?utf-8?B?RDczLzBFbzV4U09TYmlQL3ZwOFVTU0tkTm5pM2pkeG9ZNjc1UDBKY3JodTBE?=
 =?utf-8?B?alF1UTVmUWhkajNtYTZhOWVodHd4UFVmMndZRTlRRzVYYTRZd0lmSTFrampw?=
 =?utf-8?B?ZVM4TVFEeHJQMmpVZVVoWWJHa25yWW1GNnpucWM5V1dGYzY0cjUwNkJkem1J?=
 =?utf-8?B?aUNpcXMyaGF4cSs0RSt3UmhtVWhQRGpLT3lYZ000ODZnVTI5OWpBTWJnQnJY?=
 =?utf-8?B?L1dBbjdCd0g3R2pjRVg2TDBFOGs1c21XTzcwL0t4NGJyUXdERWkwMkZqQ0JS?=
 =?utf-8?B?TlIycEpmalJoSG9JTDVwYlI4Wks2M1J4emlqSlB0c3FlM0YxdmNMN3laYSs2?=
 =?utf-8?B?V2dBbVUwdWI3bm5PdUJ6bWFYNTlsUldCSjZTN1hsQWptSEVlMjlJTHB2WEpq?=
 =?utf-8?B?R3k0VURVYVhJZnNkeDR0MjZNbHVmVWFNOFFad1lHTmFGWnFET1hXdDlnV2kr?=
 =?utf-8?B?S1NhaHFJUVpyOGpFOGxoMVBtaGxRY2VOWThKVzZsRnYvTEFoYmxKY0J2a1RD?=
 =?utf-8?B?d2dYalRkYUVmSGVUcDJnSjBNTFA1U3pMTHo3dUxrOVp1Q2tTTnA2WjQ5WkZZ?=
 =?utf-8?B?NnRnVnlKTEtmb2xBMFJFcTRlWUJUZmdkS25CY3FIejZtOVlvUGxZV1U1aWlt?=
 =?utf-8?B?V2FzUzhmU0xKZkdEenBTNDZQZTF5VDBCZ1ZTQVhnWU11Tmsrc2VNUkdweWhD?=
 =?utf-8?B?d01hODM0cGRlWWVlNEgwbE1RTFg3Z3BCMzk1SVV0a1Q1OWlVaVpSMXYzbmV2?=
 =?utf-8?B?STlvdkVFQUhCcXFxdDZvc01oSUUzTjRVZFA4M0dRWEZKMXhTUTFCNTRHbTlm?=
 =?utf-8?B?Q2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wyW1LHM6QEvcqZorWXKEmgCPcTIJbIjgzT0wVAAloHILRgmZI76GhvB3EXwixMDRNt3Ue+QkiCZmtkb/hKzy9rNjeM2apB4clvtylipTcZ2mVvFUHHwMQeJ9DzpWT+TtPORCmiVOGOAV4EMmXxB8QVsH41Y3zrqUboXPyF/w9Dk0bnMc1lwhJ1585iuqR2YuGsn/rmlCE3z5u7c+hSo4UWWoWlaZlsOF+/z89pMVd/j3z876g4Vl2zq1+SlUNdVVZnao/kjLeK7NvEb2/Ya8tTqilPoLHcX5ndXIE0gVLizq0ZJX1Lnxpf3rUt83Yrykp530/f1g0fcrpoizWQCpu5u+y/OF6cE3JqY0A60AGRbiu8WKMQ4z3fv4GXUL/65/abcbkpSE6EQJ9gNk1YW4ExoNAdOY18s22UiM0gFTfK/GEwsgbKy6cuGAzqKlaz9uwn86QVI1oU2JD7xHwpkW6epHSd9PxVZjYd5rMgm5NvufAsC8Qu9QY3k1NXLXrGMOjP0CcIBCJNGXqEQWmBU5+nFxqBgsU9clK1qEZan7p41RHLoTGrZCAfDys9TdL5AEY6CKyOkln4lEV/EDQNpqL52RkOehnBZDqaQACLptoDU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53062122-6a3b-4860-f4a3-08de1d8dfcc5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 23:41:20.3511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N+4XDRx44j41q86bWH/pjr5wqmjXALxP8JtO/AoyhKKpd0nOYgIMCrztJdrB0IOXUaGvQRfiQM6QEnieEE9EAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7473
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060192
X-Authority-Analysis: v=2.4 cv=BdrVE7t2 c=1 sm=1 tr=0 ts=690d3225 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=XLtfTrUgiUCvnmaEx7gA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzMyBTYWx0ZWRfX38IWgeGv73Jq
 qW8A3OiDjNkAOvmhy1FhmpPUqcp396SKaUhSWjRC8voBX7d66pq0kPB4qjP9ML1suUn/iQXll+d
 XV/OwUJVe8gn/+GSoMqP9Wz5rGojQGbcnrYURCVAhWC5dR4Q/8brtkMETLghFmYojotd9RHbgAa
 P47IhLOZmdF2HHpeE0QwJfliDeYu08vUGnM7lg++Mn8t0bdbQPYbh/P/2uadZPFCJckJMZgLZWp
 hwkg0DDPrMgqYoyblb9+PoSgRZZdOZ0jOIkSFZRy5mAWcgcQiAviYaoZzraQEO/tXmb20lc0sca
 DbgU6tXuDP0Dx42a9GLxynkz57cZkE7K7Y32iv/xXd3i7FgcobF/Xw6n9n/AYWz8ZoQ5c/21E+C
 E7Nn0KbzmsQj2gErEGccJbk0CtbDMROkzUl6JE8E3gAE/yRli9M=
X-Proofpoint-ORIG-GUID: OJ23SDPUFEfSvnkoRMxyDH_RAEA0Siye
X-Proofpoint-GUID: OJ23SDPUFEfSvnkoRMxyDH_RAEA0Siye

Hi Chao,

On 11/3/25 11:37 PM, Chao Gao wrote:
> On Mon, Nov 03, 2025 at 01:41:15PM -0800, Dongli Zhang wrote:
>> The APICv (apic->apicv_active) can be activated or deactivated at runtime,
>> for instance, because of APICv inhibit reasons. Intel VMX employs different
>> mechanisms to virtualize LAPIC based on whether APICv is active.
>>
>> When APICv is activated at runtime, GUEST_INTR_STATUS is used to configure
>> and report the current pending IRR and ISR states. Unless a specific vector
>> is explicitly included in EOI_EXIT_BITMAP, its EOI will not be trapped to
>> KVM. Intel VMX automatically clears the corresponding ISR bit based on the
>> GUEST_INTR_STATUS.SVI field.
>>
>> When APICv is deactivated at runtime, the VM_ENTRY_INTR_INFO_FIELD is used
>> to specify the next interrupt vector to invoke upon VM-entry. The
>> VMX IDT_VECTORING_INFO_FIELD is used to report un-invoked vectors on
>> VM-exit. EOIs are always trapped to KVM, so the software can manually clear
>> pending ISR bits.
>>
>> There are scenarios where, with APICv activated at runtime, a guest-issued
>> EOI may not be able to clear the pending ISR bit.
>>
>> Taking vector 236 as an example, here is one scenario.
>>
>> 1. Suppose APICv is inactive. Vector 236 is pending in the IRR.
>> 2. To handle KVM_REQ_EVENT, KVM moves vector 236 from the IRR to the ISR,
>> and configures the VM_ENTRY_INTR_INFO_FIELD via vmx_inject_irq().
>> 3. After VM-entry, vector 236 is invoked through the guest IDT. At this
>> point, the data in VM_ENTRY_INTR_INFO_FIELD is no longer valid. The guest
>> interrupt handler for vector 236 is invoked.
>> 4. Suppose a VM exit occurs very early in the guest interrupt handler,
>> before the EOI is issued.
>> 5. Nothing is reported through the IDT_VECTORING_INFO_FIELD because
>> vector 236 has already been invoked in the guest.
>> 6. Now, suppose APICv is activated. Before the next VM-entry, KVM calls
>> kvm_vcpu_update_apicv() to activate APICv.
> 
> which APICv inhibitor is cleared in this step?

APICV_INHIBIT_REASON_APIC_ID_MODIFIED.


      vCPU X                               another thread

__kvm_apic_set_base()

-> vcpu->arch.apic_base = value;
   X2APIC_ENABLE is remained from
          prior vCPU hotplug
   Now X2APIC_ENABLE is removed.
   APIC_ID is still in x2apic format

                                       kvm_recalculate_apic_map()
                                       -> kvm_for_each_vcpu()
                                          -> xapic_id_mismatch
                                set APICV_INHIBIT_REASON_APIC_ID_MODIFIED

-> kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
   set APIC_ID to legacy format

Any further kvm_recalculate_apic_map() can clear
APICV_INHIBIT_REASON_APIC_ID_MODIFIED.

There is more chance to encounter the racing window without below commit:

KVM: x86: Reinitialize xAPIC ID when userspace forces x2APIC => xAPIC
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=052c3b99cbc8d227f8cb8edf1519197808d1d653


I can also reproduce by customizing QEMU to edit APIC_ID and apic_base on purpose.

To facilitate diagnostic, I just expose inhibit reason via writable debugfs, in
order to enable/disable apicv on purpose in a bash loop script.

> 
> <snip>
> 
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b4b5d2d09634..a20cca69f2ed 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10873,6 +10873,9 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>> 	kvm_apic_update_apicv(vcpu);
>> 	kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
>>
>> +	if (apic->apicv_active && !is_guest_mode(vcpu))
>> +		kvm_apic_update_hwapic_isr(vcpu);
>> +
> 
> Why is the nested case exempted here? IIUC, kvm_apic_update_hwapic_isr()
> guarantees an update to VMCS01's SVI even if the vCPU is in guest mode.
> 
> And there is already a check against apicv_active right below. So, to be
> concise, how about:
> 
> 	if (!apic->apicv_active)
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 	else
> 		kvm_apic_update_hwapic_isr(vcpu);

Thank you very much for reminder.

I missed the scenario when vCPU is in L2. The __nested_vmx_vmexit() will not
call kvm_apic_update_hwapic_isr() unless 'update_vmcs01_hwapic_isr' is set to true.

However, can I remove the below WARN_ON_ONCE introduced by the commit
04bc93cf49d1 ("KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active
w/o VID")?

Now we need to call vmx_hwapic_isr_update() when the vCPU is running with vmcs12
VID configured.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f87c216d976d..d263dbf0b917 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6878,15 +6878,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int
max_isr)
         * VM-Exit, otherwise L1 with run with a stale SVI.
         */
        if (is_guest_mode(vcpu)) {
-               /*
-                * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
-                * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
-                * Note, userspace can stuff state while L2 is active; assert
-                * that VID is disabled if and only if the vCPU is in KVM_RUN
-                * to avoid false positives if userspace is setting APIC state.
-                */
-               WARN_ON_ONCE(vcpu->wants_to_run &&
-                            nested_cpu_has_vid(get_vmcs12(vcpu)));
                to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
                return;
        }


Otherwise, we may encounter below WARNING.

[ 2510.134035] WARNING: CPU: 16 PID: 43475 at arch/x86/kvm/vmx/vmx.c:6889
vmx_hwapic_isr_update+0x1bf/0x270 [kvm_intel]
... ...
[ 2510.293290] Call Trace:
[ 2510.296090]  <TASK>
[ 2510.298509]  __kvm_vcpu_update_apicv+0x1c4/0x230 [kvm]
[ 2510.304432]  vcpu_enter_guest+0x3a1f/0x48a0 [kvm]
[ 2510.309827]  ? __pfx_vcpu_enter_guest+0x10/0x10 [kvm]
[ 2510.315612]  ? vmx_get_rflags+0x21/0x180 [kvm_intel]
[ 2510.321313]  ? kvm_cpu_has_interrupt+0x7d/0xe0 [kvm]
[ 2510.327047]  kvm_arch_vcpu_ioctl_run+0x8ce/0x1d70 [kvm]
[ 2510.333060]  kvm_vcpu_ioctl+0xabb/0x1060 [kvm]
[ 2510.338156]  ? __pfx_kvm_vcpu_ioctl+0x10/0x10 [kvm]
[ 2510.343746]  ? __pfx_file_has_perm+0x10/0x10
[ 2510.348625]  ? futex_wake+0x14b/0x580
[ 2510.352800]  ? futex_wait+0xc4/0x150
[ 2510.356877]  ? __pfx_do_vfs_ioctl+0x10/0x10
[ 2510.361640]  ? lock_vma_under_rcu+0x282/0x5f0
[ 2510.366648]  ? __pfx_vfs_write+0x10/0x10
[ 2510.371126]  ? do_futex+0x16c/0x240
[ 2510.375099]  ? __pfx_ioctl_has_perm.constprop.76+0x10/0x10
[ 2510.381366]  ? fdget_pos+0x391/0x4c0
[ 2510.391262]  ? fput+0x24/0x70
[ 2510.400552]  __x64_sys_ioctl+0x130/0x1a0
[ 2510.410858]  do_syscall_64+0x50/0xfa0
[ 2510.420872]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

> 
> And the comment below can be extended to state that when APICv gets enabled,
> updating SVI is necessary; otherwise, SVI won't reflect the highest bit in vISR
> and the next EOI from the guest won't be virtualized correctly, as the CPU will
> clear the SVI bit from vISR.

I will add the comment.

Thank you very much!

Dongli Zhang

> 
>> 	/*
>> 	 * When APICv gets disabled, we may still have injected interrupts
>> 	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
>> -- 
>> 2.39.3
>>
>>


