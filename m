Return-Path: <kvm+bounces-49041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DE55AD55BE
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F414F1685B9
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD5527FD7E;
	Wed, 11 Jun 2025 12:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WszsIebY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rjTDIsSq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B29253F08
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749645532; cv=fail; b=iQu3Qui9DQo5BHbEDnVrNR8ZjWf1BlDH9bQ7AmIuVwOcOa05VGVWQlma8gjYqhpUY6EcXxH4UNY6bKctxeGIrxpRVELoQc8Y9YRtKwe0Or6Z8dP2rqbhgwvUCWjyyZXSWp5fuu2DLuK2qgTZuuZaaJs5gCUbwDQVrVV3i/yesC0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749645532; c=relaxed/simple;
	bh=HunLWkjkd3jb6iEIYL/a0QQ+UaLQMNXsLDaWRQWDdDA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pZIKrrRAsMW6flPCcgUfw0fkK5SOXSI5DzwpEp0XkcY8AtGfPNOAcnkw7QhOo0fVdC0vVGYU+xX/WlrrAJPwQDa1ObWq+RSIndu+IVK6XDSxlDQcfN8vth4hjMDV9errfpRpMjXUzy1QsVPqP1E2KSEsRHWMdEMhoX4yhw+0nUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WszsIebY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rjTDIsSq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BCOqgD031065;
	Wed, 11 Jun 2025 12:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LWTiAS6yvWCxkjD0ee2S6dfy0CutvPR0XImbkWSnX9I=; b=
	WszsIebYX0QNYUlHeM/J6hQP7uSRwkIx5ff5g5qBholo5cTTlX8vgeI4CBYOMoth
	V15S1g+8JEBhWLzD9rOl1K8JDzllzrkodAOFgBF8BUJizvRexnQOF72BJ933pjed
	+xyU47GEPo/ZfkjBRokHl68nAJmyIuDsE+7RR7tRw6RrhBikxn/swRsiPRdtiAKS
	j3jxrtjYhuPc5WHM2oBfhRsfrNiO4HGtfOLXjms7xaKBQFLkxHmAYHTBjJd2Tu8t
	ebcdwMnFtrRy2mlRa7Qy5P8x8/qK/H08UwKVmuTvQSIbMW376jHd5Ksv18SUaLs8
	eVR/2zxg4PHbBn3ik/nGUg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4752xjwtf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:38:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BB77Wv004011;
	Wed, 11 Jun 2025 12:38:46 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bva44y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:38:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkcgkkKuPMXRk98SuvzqleuhfPmS3tHy3AeVHJbLdSu9ieZaCz1uRb5+wJckY76ogoY1qsHSYoOlUp/CdLpHgdc3ijPK1zT4zxAzsnEjLJe8OS51aX7pWd2fKdY/rmscflNDfCA98G0mtU/9Gauo4b5PVknZQ/Gwl3TKvcsvn8mgB3Gcj17YRXxTNYJY91v0Sw9H0lVy+7Ug2nchvpW/k9kP2RLiAxlcCZX4B5hf/8fFc2kWB6WE6l3OhjGhvbT9aB/U1VKbJBaQkjfQU+XoFpi/XAik6vB0kkebuVy3YKGmOhoeafqvlhpLYzabfDx7LWR+vojxN87Xs9rpd2H1cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LWTiAS6yvWCxkjD0ee2S6dfy0CutvPR0XImbkWSnX9I=;
 b=MmNHA65NzA6wvxgVagpv8dAUQEFW5VbSXuWbEYm4YO/1PXpqXbM9O4VNLGkbgT4SIHJhvLuTWXNPRRzQKRgJvf5QyjHXmYG3Zoh0rWI5rJBM6b5+zYRfAetugFeGqa0PIpilJGmPI3ZC8mZsg7hZ8MHmWpYuls9nK9exxa5cwHe6dKd8mHyY1ue023I6qh3cx2aEX2kWBHmLe7KYcD0uSOwchZ4lC2hH9iWc7tVBzY56pr6GzwG/4TRZysYeX02p2/oBt/IlID75ion89nP1A2yYHdNYm5aarfM3TbbWqoynbOW0gup9ah34TgouTIg0xijyZ6HCmDll/9gewMYKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWTiAS6yvWCxkjD0ee2S6dfy0CutvPR0XImbkWSnX9I=;
 b=rjTDIsSqvLd2HoOouNAeflIi8FMcWBptgqIHhA95wXqYT+HxCnZXZuksWKSmz+g4UE8Vf0Z1Gv9K91SsQWIr/cl10G4CQ1dujxmcm5fCbgql1IKvBrabd4MlrbdJ0GicPR5B9fu6v7ifVGlkvvLMGNJI3cz3ElGtn3AbzOIPG+E=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Wed, 11 Jun
 2025 12:38:44 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 12:38:44 +0000
Message-ID: <f7fd4197-2a9d-42f1-97b6-af4710f8ff41@oracle.com>
Date: Wed, 11 Jun 2025 13:38:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 11/14] x86/sev: Define and use
 X86_FEATURE_* flags for CPUID 0x8000001F
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
        liam.merwick@oracle.com
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-12-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250610195415.115404-12-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0011.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::13) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|SA2PR10MB4795:EE_
X-MS-Office365-Filtering-Correlation-Id: 73ec15c0-a7ac-4015-a0fa-08dda8e4e6c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vldhb28vY214RURSeFVINUF0dzBZVWVtYnJEQXQyVHl5NEFwMW15WEc2ampw?=
 =?utf-8?B?TzlwOTMrUFd1SE1CbW5qTWo4VFZTNU1NNGd0MUV6QVJtUFhLNWRjZ21DS3hj?=
 =?utf-8?B?QmNOQktBWnJhVjY4eVVYNjRnMGpPMGJ3NFQzazQ0YWVXcnRFZnRuVnJMNHVN?=
 =?utf-8?B?MUk0NVRrNERmK2xKbUxIV0hOM3pGSndMS0laQ1ZWR2xaWFlhZXpGNDFGRFla?=
 =?utf-8?B?UWdJQ3U0OCtHTlZpUEl3TENoZThFMC9ESlFSMjFHNEJVVWFUUnNmN3JLT2I1?=
 =?utf-8?B?VDZlbDhQa2lUYVBCLzJqa1JlQWV5MlFVZHd0UzJVMkFydDRSVEEzUk5jQWhT?=
 =?utf-8?B?TXMySzJkaEloNm1vVkF2RUVYMmNwYnRyQ3d1Qk1zVzNtbDVzbnV1SmJtcjhK?=
 =?utf-8?B?VmxZS0ZJSnphS0ZOZDBPSENlc0VTUXhSRGxYa21XNUNxdGhydC9Hc0pHdUJx?=
 =?utf-8?B?MEd2Nk45VWJUNEQ2ZFFSellydjgxWTJ1S1psWUk4ZjI1eXAwa1BpN1p1QnUv?=
 =?utf-8?B?amE1RUh5S3VCa3BURjdINVBEcWVEZWRyeGpCZnlQSEtiTEFtbVpGVFRvdjVI?=
 =?utf-8?B?Ulluc2pvRHkyQU1tNVp3cHhpM2FpSjljMExaaXhNaFZOQjJlNFdWa2VKdER6?=
 =?utf-8?B?eXAyVDlwcnBxNkdQY2RVM3JNU0Y4czF4cFBtZDlJOWNLZ2pnVkxoQWU1aVo1?=
 =?utf-8?B?TFRhNGxyMWsxTlE4b3JwZkFjdkJuQ0tOdzg2RTNIcTN2Vjd3RE16eU9pakpR?=
 =?utf-8?B?ZkdHVlFqbE5KQmQ2VGJvaFNZMXFBMGkvRjBBMTZ4MkQxTFVTU2RDK2RZVEov?=
 =?utf-8?B?QWJQNDU3QytpMFpPWlN5T244TGdZTy85RHdmanZuU2YzWVlVNTVyakd6Tndj?=
 =?utf-8?B?aWRubWVKQ2ZEYTlyaUUzMXo0eXFHQjExMURuVUsxeEExS2JzRlYwOEZucHN5?=
 =?utf-8?B?VEJTMTRNTEVyb005WG5IMGhIRCtKbVZlRmhLeFVzWDBsSTVpVFRQTmpZZnRo?=
 =?utf-8?B?NUtDM0tXOWV3Y3RMakRNTzQrWlBXeG5nNmtKaXZoc1Rsc3d5QW9GamQ0UVVv?=
 =?utf-8?B?eVZqeFhWS0dPakY2MjNRaHVOYWVKTlJ1bGRnY1F5T3NLTVFwSmFFMnMvb1I4?=
 =?utf-8?B?OUhZMVA2VzVwdUhmL3JZRHRuUnNtVlB3aTF5SnZjSkNnN1NxcnZvVXBRdHkv?=
 =?utf-8?B?VU1LeWR6a09yNGpwOXdnakdnbkpBSzFPV0dvZDJLVkZVenF1ajVpSWhCd1Rj?=
 =?utf-8?B?cW1tTnhaYS95YUpxblBkdEluQ0JCYjJuL2F6U0k1OVBwbHh0eXNidHV6YTc0?=
 =?utf-8?B?TE81RmplYTlmeUlVN1ZFY1o1bS9JZUNucHR1a1VKbmRPQzFzQ0RZV0NqQ1Bx?=
 =?utf-8?B?Z1J6RGxlR1NXVElnU2pEbFFoM0s2VHp1OEE0RVVUaENZMmNub3NxWkswRnlS?=
 =?utf-8?B?RXJDZ2VxbDA3RDRtbCt0bkZESloxMW1jYVkxbEI3WVVVRndaaEUxSDdwSStT?=
 =?utf-8?B?MW5Fb1lrQWdtVi9kazdONk0xV0RnYVJSQ1JVN05xdFhTUGQzcG13c2RoM1Vn?=
 =?utf-8?B?NURWRzloVTE2YUJQN2xSZ01iaTZaMXdnbk80WlhwZEQra0RONjJvSHg3OUo0?=
 =?utf-8?B?Z3d3RHVhbXdCaHNWVW5kUFVwSFU4OFhEaytYaW0wRGxQTkdNaDlIOFA0TFdE?=
 =?utf-8?B?MFJZU3ZxeVkxaFdSa3Rhc09VbTM1SjJNU3lEcytpbytkKy9jWmloMy9hS3VM?=
 =?utf-8?B?dUcxWldaWmJFRWk2RCtBL05wcW5Eci9jdFlRR0diM2xkcUF0U1lrdjJiL0Zm?=
 =?utf-8?B?RjRxUk5LSlpvYjNYcC95N2tSUUd1VW42R2loQS9YNXBrUzFVOGErTFNZSmNP?=
 =?utf-8?B?YWVHL0xudWZZbHRpOEIyeWRWUUgrV3JVVG9YNEMvMG5TNmNBVUZWQnpoMzJm?=
 =?utf-8?Q?O/gELQ1e19E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjhaajR3N3dUZmg2MklhZmRQWnJlOEV4RmlEYWlvZG1xbTFRbkFNS2s3Q1pS?=
 =?utf-8?B?TVlud2I1TTllb25FZWNOSk91bDRicDM4QnBCUE5vTEVPcUdRem9JcmkweGQw?=
 =?utf-8?B?TDZJcllZR2dtNVNlcFhQNTA3RnFlSGU0S0hOWEF6OE9CNGZxRlJhVHFtSzBW?=
 =?utf-8?B?bnVvaFJHZnpHM05VT3EzdGJDQ1hjeUE0WDFxOFBrZ2NwY05zblhqT0pxeHo5?=
 =?utf-8?B?VWVyVWNsbnVCbEpBZk13SFkrdjl4am9zbjVnYXN6a1FLcW51Q09WYnNiejlz?=
 =?utf-8?B?Q1NLQWJpVGZsTml0enVpRHNqNkZQV2VrTzYyS1J3bzB6blhrZVR6V0l4N21j?=
 =?utf-8?B?VG9NMVFRcmczdWsyMUZ3NkFDOWRwKzAva2lYQ2VVUHA3Zm14cERGQkMzQytD?=
 =?utf-8?B?NGlDSVk3YTJaanU1OVhjV244bEZOcGFHdGdjb0dhVnRHbjFibWtlZ0tkNXla?=
 =?utf-8?B?Zys4d01SQ2lLVzV0bXQ4aHpFU1k2WXRZL2dPT2xRVXZjbjNlaFhDQ3QxTW93?=
 =?utf-8?B?bFpnMkdiM3lKeW5lZ1oyNmhuekZMZEM3VlhSZVMvbndxcHBaTEtHdXpOL0ZN?=
 =?utf-8?B?R1Y2T2syMEdNOG1aYWRPUHprSVoyeXhPdWh0VVBGbkRRZ2R2RE5jMC96YXlj?=
 =?utf-8?B?ZjhvUzJtK1h0ZHpLZWJOblRmTTFYZk9xNzJ4azlFR08yZmtqdlZYSnZTZEtz?=
 =?utf-8?B?Sk1uY2kvaytmZEp1TUlWaUN0MXAxZjVqTE45dWNSNExkM1l4bVM3VmNKaUtE?=
 =?utf-8?B?N1FZLytaRFBWL0RaM3l2cHdJREhvTHpXZkZYRU40NW1GcmNETUJQUnc3cENF?=
 =?utf-8?B?bngzcExmTG8wSXI5NmJWMERsNmVyc09qSUJFNEY1SUlTQXVpbmNqTmtSbXBr?=
 =?utf-8?B?anR1b2ZwZVZKN3pTazhaMzJqNmEyV09BUlc4dDFoQnFDTDhkM3lHUGhMTkpY?=
 =?utf-8?B?aXBKOFdydHlWTm5LRGNVeEVzNTV6dVJpajByajVUWTZCdElOcGwrMno3RVVL?=
 =?utf-8?B?YVRYMis5b05BdE8xL24yL0k2RkJZME9mUHBNb044eXJCQTlaRTVsRThuTml3?=
 =?utf-8?B?c0xUb253VXNQem5UNkt0bUpaeno1Rm9jZnBCNlV6REhKTjR4ZEMwMHRLTnlu?=
 =?utf-8?B?ZmVCcXMxaERUZU5rL25MeFhyZjlzOFJMR1lYWjc2MERLUmJrRlVGK2s4VC9K?=
 =?utf-8?B?OEZ6Y3lwTG5jT200elZuL3ExOEZ1eW5NMFBPNE56TkdtcHhJZ0M2YThzMWNH?=
 =?utf-8?B?RW92ckdTblI2N253R211ci9wODJRMTJxKzAzaGUwYnJmaCtmZEJleEMzaElF?=
 =?utf-8?B?V2ZFN0QzNHhVcE5WSU9SOC9vVVpLTjJ5YW5RSzFaZ2duYzVuZjY4a0wrbjc1?=
 =?utf-8?B?anB6M0dNWDllakU3eGdOaEJ2WVp0bzFSV0w0NCtGSW9EcXRHTzNpaGtJNHJa?=
 =?utf-8?B?Um1YdE9xdmhuTDN6Q1NtNE9xZ1NwOEo2TEpDTGZCRzExM1E1T0k0Vm5yZ295?=
 =?utf-8?B?VHkyZGRGSzZ5UDlVNW4rK1lpc2lpbFloa2V3SHhsV1VjZHFscitBRThOUkZU?=
 =?utf-8?B?VXRGRk1GbUUvTDdDMTlPMHpqbnZITDViVTJXQlo3bk1raS9OMFFQY0JiNTdr?=
 =?utf-8?B?NFRpcTdHR3RQYnRxbnV2NkhvRWUvSXNMQ3ljcHFrcDFnKzZ3dS9rbXg1RjNG?=
 =?utf-8?B?S0dXRUt5OEJCN0x4RjBYUUk2Zm1ETEZzSld3TlZpYlhlTmVMVmJEZ04ycUlZ?=
 =?utf-8?B?eDBwd3Fla0pCMEVFTjVYaW5qenNEYnB6TjNqdjFxMGFRUXFvMi9KbVJDUUdi?=
 =?utf-8?B?L2JNR1VIZ2VDQUljYXlDWkNkdXpnMWdLOEtkQkxpNng0VkUrS25XSWRPZ0NZ?=
 =?utf-8?B?QmdTRFZuMW85UzRYYUlISE1saGxUeGhHYmZVR2tHS0dGWWtZLy9yL3ZkZ3lp?=
 =?utf-8?B?Vmt2OFNzWVBpQzFpdkNSRlprdHh3MEZ0Y1BaUW80OGF5WTZseS9KZFB1T1VD?=
 =?utf-8?B?Tm1BY1E1VWZ3dmFaeENkeEFpRG45d01IZzBvTmlUOHRVbjVxUDRyc3dBYUh2?=
 =?utf-8?B?SXVJKysyRnBFdS9vZFVVKyt4MStaNUd4OGhLZ3BEUTVaaWpnS3Q2d2tsSnMz?=
 =?utf-8?Q?hoJEDDdWCtwCEs77ZLNtiRrAw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o7nZsBg7vQPoTjUwKC3jJAP/Y2frksMAQ+uDI6XZTwhZFb+3H/ZRWhJonX+O5ywIeqzxNQPBJlixLdKEs3m/gL7Ye92Eo/GfaRjLy2vKFUE3d/0wr+7YMGOisu2xUOp0zrhEl9IRVo4Egj51Ac+e4y2u9iqn2T9Oy4Qxc/xzr3x10J3gJtEcp8EhcnSSl/7aDFKJ7WcTcQkE80o1hwO+okyBL+CgvVLKi38CoiD3MVfpwwGS0Bsnux2ANmNBQBaWhv3v8Ge9KeVtiUxmzDQyGE9WeQEXZr5wQYF2ygbKjxiqcp5LXi5oGjuq4jQeg5oNUf47kdFOg62PETqJLVGHO2mCnCRW1lSRq3i/5qzY1kBnlU+ctUIWsl9/N6qNQvRJqHQ1aHC23T9G94ak96gWFboTHWxZavkcsVIHksVmlUF05Xyg00THqo2rPMzn1PI3slc+Pvfr/O/8gsbheTwr1wDoYa04XoWs5p/YT64tCH1Jtz8IB0JSR1/w3sd2J+h3k49VVdlEtaDS6fHU3HH2i2bUKDSoQljskTwqDqRUFNb5zIvg3motSMhQLhqzjq9fJ9Ssf2C+1Av+4rPexFajghY/X0LIlQZcPMY2JEt0DZM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ec15c0-a7ac-4015-a0fa-08dda8e4e6c2
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 12:38:44.1358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+49VBNMM0N0sE+swQlsJBsbNz/wKh0zQlF7GJCXI3IXVi21LLy3QE7UFlbOVBxsymyjvjeIFQjMQbz+JtbbSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110108
X-Authority-Analysis: v=2.4 cv=K4AiHzWI c=1 sm=1 tr=0 ts=684978d6 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=-GwUMSQTRgRCKJthjsIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEwOCBTYWx0ZWRfX1q4jNhsSiNvR W2XCh4Q30P/GA9VY+DmBWF7Sqs6A01iHdrGYuymciAQLR6utZ2s32882Kv9wSSBkluOnVSVjIQn gMvhaqPhKFDgZ4hRx0Lyut2N0fNVhNJxyWrjuK2Grt4RFCwX8GGUq2Uvj6sMrusTY4HUgGV28l5
 9ULVyQiDTye3r5jvnz+zUrIywtumigZnKnu/g4i4850xMk5JLC/ljMkSwHWG6aVOLph/ZAy6sGG z3ZuZQF5HUPsG0v66uq08btmvecaa6z51MgvZvbRWIOawr5yGrJtvNptBNUzojTKrGbnEfL+vWY YTJ5pM5cKdftKg5R56CPomZTsYcSIrGfLkQoohStWju7LwkTGdU2M1xHB0Kw4oT+N9o+3nq0biM
 3n3hsV5RU35th2Emdb1x8kVDKyADJsLmOvFEaVHSPaATUaQTUkPl+NhN31i/eD+bwrG0ZQ3C
X-Proofpoint-ORIG-GUID: gLrK3UJL-O4EJ05T5h10-CN1f-lf05PY
X-Proofpoint-GUID: gLrK3UJL-O4EJ05T5h10-CN1f-lf05PY



On 10/06/2025 20:54, Sean Christopherson wrote:
> Define proper X86_FEATURE_* flags for CPUID 0x8000001F, and use them
> instead of open coding equivalent checks in amd_sev_{,es_}enabled().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   lib/x86/amd_sev.c   | 32 +++++---------------------------
>   lib/x86/amd_sev.h   |  3 ---
>   lib/x86/processor.h |  9 +++++++++
>   3 files changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index 6c0a66ac..b7cefd0f 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -17,31 +17,15 @@ static unsigned short amd_sev_c_bit_pos;
>   
>   bool amd_sev_enabled(void)
>   {
> -	struct cpuid cpuid_out;
>   	static bool sev_enabled;
>   	static bool initialized = false;
>   
>   	/* Check CPUID and MSR for SEV status and store it for future function calls. */
>   	if (!initialized) {
> -		sev_enabled = false;
>   		initialized = true;
>   
> -		/* Test if we can query SEV features */
> -		cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
> -		if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
> -			return sev_enabled;
> -		}
> -
> -		/* Test if SEV is supported */
> -		cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
> -		if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
> -			return sev_enabled;
> -		}
> -
> -		/* Test if SEV is enabled */
> -		if (rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK) {
> -			sev_enabled = true;
> -		}
> +		sev_enabled = this_cpu_has(X86_FEATURE_SEV) &&
> +			      rdmsr(MSR_SEV_STATUS) & SEV_ENABLED_MASK;
>   	}
>   
>   	return sev_enabled;
> @@ -72,17 +56,11 @@ bool amd_sev_es_enabled(void)
>   	static bool initialized = false;
>   
>   	if (!initialized) {
> -		sev_es_enabled = false;
>   		initialized = true;
>   
> -		if (!amd_sev_enabled()) {
> -			return sev_es_enabled;
> -		}
> -
> -		/* Test if SEV-ES is enabled */
> -		if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
> -			sev_es_enabled = true;
> -		}
> +		sev_es_enabled = amd_sev_enabled() &&
> +				 this_cpu_has(X86_FEATURE_SEV_ES) &&
> +				 rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK;
>   	}
>   
>   	return sev_es_enabled;
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index ca7216d4..defcda75 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -21,12 +21,9 @@
>   
>   /*
>    * AMD Programmer's Manual Volume 3
> - *   - Section "Function 8000_0000h - Maximum Extended Function Number and Vendor String"
>    *   - Section "Function 8000_001Fh - Encrypted Memory Capabilities"
>    */
> -#define CPUID_FN_LARGEST_EXT_FUNC_NUM 0x80000000
>   #define CPUID_FN_ENCRYPT_MEM_CAPAB    0x8000001f
> -#define SEV_SUPPORT_MASK              0b10
>   
>   /*
>    * AMD Programmer's Manual Volume 2
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index e3b3df89..1adfd027 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -320,6 +320,15 @@ struct x86_cpu_feature {
>   #define X86_FEATURE_PFTHRESHOLD		X86_CPU_FEATURE(0x8000000A, 0, EDX, 12)
>   #define X86_FEATURE_VGIF		X86_CPU_FEATURE(0x8000000A, 0, EDX, 16)
>   #define X86_FEATURE_VNMI		X86_CPU_FEATURE(0x8000000A, 0, EDX, 25)
> +#define X86_FEATURE_SME			X86_CPU_FEATURE(0x8000001F, 0, EAX,  0)
> +#define X86_FEATURE_SEV			X86_CPU_FEATURE(0x8000001F, 0, EAX,  1)
> +#define X86_FEATURE_VM_PAGE_FLUSH	X86_CPU_FEATURE(0x8000001F, 0, EAX,  2)
> +#define X86_FEATURE_SEV_ES		X86_CPU_FEATURE(0x8000001F, 0, EAX,  3)
> +#define X86_FEATURE_SEV_SNP		X86_CPU_FEATURE(0x8000001F, 0, EAX,  4)
> +#define X86_FEATURE_V_TSC_AUX		X86_CPU_FEATURE(0x8000001F, 0, EAX,  9)
> +#define X86_FEATURE_SME_COHERENT	X86_CPU_FEATURE(0x8000001F, 0, EAX, 10)
> +#define X86_FEATURE_DEBUG_SWAP		X86_CPU_FEATURE(0x8000001F, 0, EAX, 14)
> +#define X86_FEATURE_SVSM		X86_CPU_FEATURE(0x8000001F, 0, EAX, 28)
>   #define X86_FEATURE_AMD_PMU_V2		X86_CPU_FEATURE(0x80000022, 0, EAX, 0)
>   
>   /*


