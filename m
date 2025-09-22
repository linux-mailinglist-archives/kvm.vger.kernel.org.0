Return-Path: <kvm+bounces-58410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6F5B92EB7
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 21:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4F261907226
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 19:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970B22F1FDA;
	Mon, 22 Sep 2025 19:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cv9KxlOy";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Orn1jjTb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D727B320
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 19:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569904; cv=fail; b=YUrpEcAFUt2hDnbYvErftJYRHpnNeSJ2/EFleeo2dr/3tFE26rPI0gYYf1vjbIzwwnrUSGxvNuIIJKlvFDKp1BOhJI3psQV248f2ajAtjL08BX6xQdk0+yUGtE9m97RKa8TJgT3oDbluLnu6l7m1rPqGtpLDUXnS5Z33sIPOFNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569904; c=relaxed/simple;
	bh=qIukIx+DqjG+JLHcEkXNDC7EqumekF4Bjo3Kw3s09nw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dlyRwoDfl/POY3yTwWZURL/k501Hro3m5w822Wvgra3ongstnXR2BstSxEjg1fxHRSqoaL+L1GmEG2AO1cAwqoHlb/RKhixJGc8k9ic8Q2c5NM7QVelT0E3Y3khiTMko778Uu2A2+a76i1f0KkLuc4RI+ZG0szWUvhp42y4FN3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cv9KxlOy; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Orn1jjTb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58MIXsss012335;
	Mon, 22 Sep 2025 19:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=l65gSBFSQoVJlQ3lk1Qar/zUZRhLDn7ZN6JzbmsRSRs=; b=
	cv9KxlOy9XfkOkSIA7qZMwC5iVHE9wWRNNieCvhcYRCTDrPbHzRWKStwhnYXhK83
	+ODeh16xBu/e+UH5FCWqgeWiYoXyCNbyGMDEjfv+GKvoRrMxdvpeqzyvGKEXnFDg
	PapKwm2F9HYLn1djqxPxSTh5FKcx3/1zkEpac6JtN/mgCKVf8BsyLo5tdcQ/c+Ev
	2XUYqnby5JOnCT22ansPcWaITUBOE1SQHvV54Gdtu6vxjL09QeTUEZ3VDfsKF3Gd
	3mk+K8N83qQqgTjnL82BpHzFr9u9yC7fbVtkUODUJusX7wITnggZPkobZyXa2HSt
	AaWMmB0X19UXll1+mM/DaQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499jpdk667-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 19:38:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58MI5GuY013532;
	Mon, 22 Sep 2025 19:38:02 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012000.outbound.protection.outlook.com [40.93.195.0])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq7a7bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Sep 2025 19:38:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmc88D+Eo/ielU+YkfRyM+kN5POJfBcKyCWkjY3vbS8GjXp82c2c8bm7DcC2Co46y0CLZrvDkj1vFubXiCUdRXAJuI5eKNiOWU8XJsdQU6+2FxAiVKUf3oeCofbwsaBkLgUUeEYQyncT7G0bNAqqWxGvSBRKOqLfxkOn542HZViQCeRLkuQswa2iKj1SwcajVJ6BH92zR8BnswYR3s3cltFwIwnEZJcQ2F/1sdyJ1gxGSRugyV+/gZjRRnWDntqurh7VV3SgXV5u+Y9uFjZPSdjO+DdQTBGT48tbSHYvjrC6IM9vjJSOJJvHoX5bOONBkTIFrvpVowBIviCfIzNZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l65gSBFSQoVJlQ3lk1Qar/zUZRhLDn7ZN6JzbmsRSRs=;
 b=or7GpkoBRybHKIEalCJQ3U/hcCk9BmWKPq+8jLpSMP9TPZjnLQherkaTXhrI8u3DUsYu2P7fyfbao3c/PrC0AXnNpVonk6IVjmjnTuJ1cbtZfWDmUdBRLQB/39fMCumMKVqBdkDdKObNUR9TiqFqi/p9MH4x0SrVpyA4wX4BCE2kxoZ2POMOiq+hvw/TbFYVM4qmRUXiYIk2QkvxgV1GsuDw+xOK33HOHV016C0I5cJMyFjYyfkuqKQxb4kLizbNkDVMSQ+0PuxIoqXXjzeXzR7OTpNpycUZY++EnLcnwCYvDddSgCkLbhYsJIYw1ONk8//WFEhztprJoifVA6Y2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l65gSBFSQoVJlQ3lk1Qar/zUZRhLDn7ZN6JzbmsRSRs=;
 b=Orn1jjTbi/tLzKXHFnKQEYojl50I69wPD0AY2UnhR04YYgGHUNv+ml+V1K1VhIg/goZKJRqDpPToRj/4ekZLV+gujB/v/sFChhTJNHoutShM/V/GTzdgDcSJyFBZRntMpenLeE9cgHNuoG68cw0V3almz4kJbhOKd1MTJ0QJ/xw=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DM3PPFA09EE1970.namprd10.prod.outlook.com (2603:10b6:f:fc00::c3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 22 Sep
 2025 19:37:58 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 19:37:58 +0000
Message-ID: <7d91b34c-36fe-44ee-8a2a-fb00eaebddd8@oracle.com>
Date: Mon, 22 Sep 2025 12:37:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting during
 downtime blackout?
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
 <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
 <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:510:23c::29) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DM3PPFA09EE1970:EE_
X-MS-Office365-Filtering-Correlation-Id: 03ed0e4a-0b08-4fa7-b1a1-08ddfa0f8882
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b1dQaXRjb0pXVXZCbDlITmMyKzJjUTJZSjRoY3FQbllqUzV4S0VoZGVia1BG?=
 =?utf-8?B?MVp1SkVWNW14VVBPNDZlZmp3eitEQ2tOOGloNEJCbytPNUw1dWhWeDY5S0F2?=
 =?utf-8?B?QlhiWFl3L0NXU1J0dUhxNEs1YzJzSy9rNlpmaUcvQTcwYmRnVTF1UW9uSnh1?=
 =?utf-8?B?UlJyR1pWYmVnTGhVSCtWVzNsRVM4VkdsbWdkZXBGcWx1RHZRS0pSMTNuOVVS?=
 =?utf-8?B?QkxvZGVlaFZZc0hDNldxTmJWMEVCaURsMWV6dS9XVVdPN0JQenNqQVFyNTE2?=
 =?utf-8?B?WkVlMmliNkJXS2I3S29GM1luK3BVeERiZWRBK0tIWG13cTMyQXhIa2JMRzcz?=
 =?utf-8?B?WFZOY2tLbW95MTdDRm82UDBTYXBpSUozZmd0K2RGUGhpbmVnamh0YUJ2NXgv?=
 =?utf-8?B?NExnbURoNk1PMzc1WVRTNWZDNURXNURhVEk2Nkh0b21EM1AwOWFuMkFLOUg1?=
 =?utf-8?B?R0o1MW83bDAyQlVRR2l6MU9EN1RHZWZDMGdNMTMwWFJ1M3ZXdFdrSEpYMU5t?=
 =?utf-8?B?U2g5Q3RjYXZtREVybnIza1lzZitZbEFkRGZmc0ZaL29vdjVqTllmTllCTy9o?=
 =?utf-8?B?Qm0wRHgxeEtiOVl2eFNON0kzL0R3WENicVhwQ0NhNThJTURUYzdEZG5qTUdZ?=
 =?utf-8?B?bktOY1U2VmdmUFR0QjNub1RHUVRyUG80eDl3cWJZdnhxb25aRkNkaEN2MDBJ?=
 =?utf-8?B?K04vVWx6N1psUEVxdUliM0prei9ETTV2c3NwZXpTR3R5TlRsaWRxZmNUOEdu?=
 =?utf-8?B?eWpEZ25nZmR6Si9UNk02TFY4QkRqOXdoOVRObHJIVFpuT1M4Uk1Lcy96TCsz?=
 =?utf-8?B?RmFxbmRiNWVqQkE3UTNmTjZmTkgrVHhoRVorSjA1TkhUZDg5Ly8xSlRYZWZp?=
 =?utf-8?B?Yzhia0dRcGhPV2w2cmVZMlRSMG5CcjlYZzJxMWNJUDQ3MngwWXZVRzhCR3Fx?=
 =?utf-8?B?cDJNSERIS3BQZnNUejZKNFNwUG5FVVRpWTNBTkV5SjZXQ1B2a3JTT3UzRW5k?=
 =?utf-8?B?MXpadi96VmZ2T1Fhb3YwRFZqUlNjS2JpaVN3SW9yMWJEZHNPMDhsZy95VUZ6?=
 =?utf-8?B?Zis4MVZ2TkIrb0NPQ3IrYVlQN1dNMEJkTHRPUUg0SDduMmdJMkswZnVmK29P?=
 =?utf-8?B?Zy90M0ZpU2piU2ZFNVZKN2lWVm43eEZBcDdtVU94bmdBcC9HOU4xdzJuRHNv?=
 =?utf-8?B?REgwOXdYODMyaWhlS3RMbllKWmY3STlsMnFGYmpDRXBYNzNKZ2xiWkFzYnZp?=
 =?utf-8?B?OThLL0xkZVJlUm11eTUyU0VSaUZnajhTMFdGWHowVmpIWTJLQjdzaHQyWCty?=
 =?utf-8?B?c1A2NDgwdnNmNi8veUpaL1VWMnMzbGR5WlJ4VStlcm1SVmtFOXVBVmY2bGU1?=
 =?utf-8?B?VzVOMEpjWE9MeWk3dElkYTY1OFloVWw2SnVoU1FISkw0VnlJdFJGcDJCRzR2?=
 =?utf-8?B?RDZzdXAvOGgxc2Evbnpwb0VpQllFTlh4Zkpnc2ZLREtlak1NUGxFSzlYeXNv?=
 =?utf-8?B?eDRaUGlPYTBpZjBzeWpTWko2eXZEbkMveS9BenhUK2J2Q1lBWEJ1ZE94NWtE?=
 =?utf-8?B?Z0dYQXdJTmpxZEIreGR6bVk4dHI4OVhsVGQzQjRzTE1TeW1GU0xGTEFWaVdh?=
 =?utf-8?B?OWt0RENZZ3NxVHM0K0RXcHRvcTJZSldtQjJUbDdKQnQ4djRZbC82a21vZEYv?=
 =?utf-8?B?bU9xNmlBTEFNRWJxRnhWdXVubzFadStWM3lpN1djVHgvVE5kR2dKdHdXZ1d0?=
 =?utf-8?B?Z0FOZ3lkMzczVm0yTTVPa3V6aUFqMGl2WlRqbDRZLzVWdEFRWXpjZFFiTW4v?=
 =?utf-8?B?NFlGRlVzdlpscnBLR2tsaFVYR2RXMENIeHRRanlzMUU2UTE5cWR3Z3pXY05J?=
 =?utf-8?Q?r3vrBNKg8PGiM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHFDODJkSmJaT2FaNDVjSmFVNFNJN0hYeUVYZkUzNnFRTlYrTW5qU205Sis2?=
 =?utf-8?B?WkptcXNlQjd4V3VpV0ZiOU5hNGVkZWdzeXlxZXdPUHA0eHNSbTNYUDc1cGpM?=
 =?utf-8?B?ZUlYdnZkSXJlM1drSGNHc1BVOWdMQ1JKUmsxVTNad1Fsd2lKdy95REE4Lzkx?=
 =?utf-8?B?Vnd4NHNIMFNzS0JpejlYR3dxdFliRnZBU3JDUndpeHVMZmNoSGxpblp5TXpk?=
 =?utf-8?B?eGJYcjVHU2pDVEVGVGdmVnZJVzE2OXBsR0MzTEdHT3lUM2xYVE5BV0FzenVk?=
 =?utf-8?B?bFpncFJjcUlJWDRCYTJrYjdlaGk4T3liaDRLc0ZPZkxFSDhJWi9Dbm9BdFZH?=
 =?utf-8?B?UzczckFTbnRFMHVmZlYrdFlMdlZkSjEzR1Fkc2tYVGxDNUVSMTZmSWtBaGVr?=
 =?utf-8?B?cWxOTmo1czNvL2FnNGdMNmZuRWIxQVRXbzEwQ05WSm4rbGROTzQ4b0Y4TzV2?=
 =?utf-8?B?VjkrZXQvdVF1RlFYVVN2dDdGQlkvZnlVeTdac3cxSzdncVRxTzdMZG1pT2w5?=
 =?utf-8?B?R0pmdmE0MEtTMXp6cG9HclMrdTZRQ1pMcnpBQ1dIQ0ZvckU1UnQ2Wk9MWVRO?=
 =?utf-8?B?OVR6NVZuaFN2bXFxUisvOXBxbWdsdEVIWlNPTkNDc2xpRlhidXJTTThjaHFP?=
 =?utf-8?B?Zmx0YlFSTmsrb2VoYXpOYUdSMHEwL2JFVG04QW1VRTZNTDFreEs0a0ZpcFBC?=
 =?utf-8?B?SFRBaGFLdDZYY0oxdEMzUlROUUlKeEN2WUh3akZpaVdxdURPZGRFTjdOOXp5?=
 =?utf-8?B?QXpiN2hhRVVqM2xQYjZYSStVZVhJbWFsajEwOWsyVWh3TW9lOURSNzNSc0h1?=
 =?utf-8?B?VTdJU3d2TmZkMXNtMkJnLzN4WXd2KzNreGJqcWNCYzBIZ1pEcUtLU1VPNUdO?=
 =?utf-8?B?MmQ2QVQwaER1K1E5OVJDMDNWRkg2ZE9OUGRucDk5YWIrMzhkZU5nVGFFQlll?=
 =?utf-8?B?akhLUnFHQjBpU2p6ZE9PZjY4MHd1c2R5azM2WllBMWdBVjZ3R3JuZXJVb0Rq?=
 =?utf-8?B?QzI3V05CR05Kd1FQZkVMOWMrUUZ3SHVWYUd5bVpjUkVSN3QycTRZTDhvRnNJ?=
 =?utf-8?B?Wnd3QlVwSHRZNlU5MHJuUTlMVkpOMkNCTGw3QjEzakhnNE1qY3h4UStEWjNh?=
 =?utf-8?B?cUxPQzhiYlVEUzlkbkNhUHBtdWZWQTY4Qk9EVk9vb2ZqazZIZVp4SUNwelJj?=
 =?utf-8?B?UnRUV2k0N0VSSW1oaWZNK0VwNEhyZEtrK1l3TnE4OGZnVEQ5UzFpcG9kKzkr?=
 =?utf-8?B?TlEyWFFYV2ROVW15NDZEeDhaaXlJV0dpbytIUkh5MjJNZUQ3OTA4bm04aHJR?=
 =?utf-8?B?WTJsTHpvRE5pTUlKRWJjWW1kMXdXS1k2WXRxemE4VWtYZndoTDFwYmd6VldZ?=
 =?utf-8?B?aHpqc0I5WldVMHg2aTRuNXpqcjNHRDB6N01lR3FZTjRYNmdRbTRPL2U4SWRz?=
 =?utf-8?B?dzJzVVFrM2lHQ0RLTCtJM3MrRUNBSmtrYktmNUxzZllkNUsrZDlNRFBIQVBq?=
 =?utf-8?B?Y1FFVCtObFlOaUQ1SXVpSysxMkNpZTdtU21DQmNJM1c2eVlNVHFEcU0wTmJN?=
 =?utf-8?B?K0ltUzNXbkNtdUFwQ1FKbmVZeVcyMk85WDY1cHlNdU0vMEQ0bnZueG1OcHJa?=
 =?utf-8?B?NTdWWEZlOE9YTXNzVmtiUEx1L09URVJhMCtpeHkvVUgrQTFBV3ZpS0xQZlFj?=
 =?utf-8?B?TkZ2N1R0dUdqUjliWGE1ZEE4Qkp4MHBZWm10cXBybnF6bXNaemdiYnN6cTZI?=
 =?utf-8?B?ZXc4YkpWZTZPdUpKeFBQUUxOVFh0d245VXUvT0twSjcwT3hwdHpXOU5sTFVz?=
 =?utf-8?B?VTFzL3Q1a3JoTEpQOHJEV2hyOTRTK1kyNnhFLzdBVlkrZEVBMG5wTlc1NGpr?=
 =?utf-8?B?NlhLWHNpQ2M1ZmVYU2tjZ2EwdkU5Z3ZMU3J2bVU5czlVMVpUOHRTV1A5Lzc2?=
 =?utf-8?B?MW56RGQxb29sZWZLdU1yclV4dUZrd1hxS2t1Y3FKdUlTRlp0K1FWNkE2QWxy?=
 =?utf-8?B?ODJ4Tm1GdEVVZWprU0hqWmVscXJlTEdUcGpmTW1xYjhvTEk3b0EwNnB4WjNS?=
 =?utf-8?B?dlZSbDd4T0RCYU9uSUFvaE1ZbmJLbjZIa252RTZJUzYwbkdQU2RuMzFqZUR3?=
 =?utf-8?Q?YeXa8kZ+2tb4razsW8g3BTAUW?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iJ7tmy3VVfkBLcau+2tCCveIHbEj2wKM67wuVPf9T/hLTXCHkpLDoHZ8wjyuJiN/73b8UxEDjDkwDJsQZbr/sSwW2G3ibNqnXISW1SdTBoQ3odfLcJoeiOX5yB+ri6pfrjaOU1xeAsvAf6uKO34Fd5oR7mqQsBIGT58x+i3pWgwqf6r7NsEJudAZbfCEGhtB0l44F6Tbi5THPmm4ZboCGJjWPAJz/U+VwtxExMZ3iTMlaw6SEl9IfTAYHEJJZQHroAp/wWMyiuF3FoUT2L2t4KzaGAT5TDu+FEDKTazhL2LOmVqUkw0jJ5W39/9HhWexPzS00lX6k3HTod2KZz9Iv8/vZmvQdU4txVS9+KAH/Zjma4tnDCTkjQhUh1lwGgKMD+VkARH/BOkPomu+UP3/6qq/Wc4B5PGtREPoAG0HThNlWnKheOhpLMyqFpVxFp1W3J9qpzjknYrphCD5HHHbl1w+9E14tlY0pOiia3rVgYn9SbztFfIsnrwYr9t/UlG1c4qlzCkY/O2g/pHUxjxh0p0P9sTyQl1DEqFbQ+vW5C2/tU9yQtUD2f+q4qpsGVwNn5f4IGmkisr3ZU+XEIXYJheRmx2sTvfuSE4dxRGUSNQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03ed0e4a-0b08-4fa7-b1a1-08ddfa0f8882
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 19:37:58.0574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PEuIw8MSqj2tYBw1TKWsOMSgw+DswQsSDoDRPUcdpEIoUyl71fzuIOIZ/Qo9sNCw5oIGh7Pcj8SjXl58X+Yfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA09EE1970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-22_01,2025-09-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509220190
X-Proofpoint-GUID: fqQoaxe67WvYGBvuzXGdYxCRATzchD_d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMiBTYWx0ZWRfX5j7f6Sg4nlKC
 hwKZDWGgRGUvVz/W8kW6dI269X7hnuJWz6wjba4Hf4Un+VgoIxsNECzBExs2727QebPkCH/5FpA
 jocMudo70XlaGJ5mEJTKmMxBvi/DbIE0vHqLLBJAdGtowHSCYKOedsPwIMtmbxNw+KRwWt+8C+R
 m+nxR97YowbDIMeGLjuLnNc8I8Bj7LfJCn+7pCNMemrJY43STHKGkxhacX5rsSGIMzoW+S3rEeq
 xBWfdCv5qR2qpD6i+OnN5ZIBgynNaUhjIIz3HGrE1kbIpMywH1/ShWm9TN+GZCJPSKpzPeTOJD2
 ACyyrYQrMSM3WwUL4eLsNOPlTCIRcn3BdGkbcMRKItXF4plt09OCuzqulqn8vQ3wt1FKd7ecki9
 B0zDZivk0uVFwV1SuZxYP6u0bGETng==
X-Authority-Analysis: v=2.4 cv=aJPwqa9m c=1 sm=1 tr=0 ts=68d1a59a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=9cMxIclmabjHjWAk3mIA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf
 awl=host:12083
X-Proofpoint-ORIG-GUID: fqQoaxe67WvYGBvuzXGdYxCRATzchD_d



On 9/22/25 11:16 AM, David Woodhouse wrote:
> On Mon, 2025-09-22 at 10:31 -0700, Dongli Zhang wrote:
>> Hi David,
>>
>> Thank you very much for quick reply!
>>
>> On 9/22/25 9:58 AM, David Woodhouse wrote:
>>> On Mon, 2025-09-22 at 09:37 -0700, Dongli Zhang wrote:
>>>> Hi,
>>>>
>>>> Would you mind helping confirm if kvm-clock/guest_tsc should stop counting
>>>> elapsed time during downtime blackout?
>>>>
>>>> 1. guest_clock=T1, realtime=R1.
>>>> 2. (qemu) stop
>>>> 3. Wait for several seconds.
>>>> 4. (qemu) cont
>>>> 5. guest_clock=T2, realtime=R2.
>>>>
>>>> Should (T1 == T2), or (R2 - R1 == T2 - T1)?
>>>
>>> Neither.
>>>
>>> Realtime is something completely different and runs at a different rate
>>> to the monotonic clock. In fact its rate compared to the monotonic
>>> clock (and the TSC) is *variable* as NTP guides it.
>>>
>>> In your example of stopping and continuing on the *same* host, the
>>> guest TSC *offset* from the host's TSC should remain the same.
>>>
>>> And the *precise* mathematical relationship that KVM advertises to the
>>> guest as "how to turn a TSC value into nanoseconds since boot" should
>>> also remain precisely the same.
>>
>> Does that mean:
>>
>> Regarding "stop/cont" scenario, both kvm-clock and guest_tsc value should remain
>> the same, i.e.,
>>
>> 1. When "stop", kvm-clock=K1, guest_tsc=T1.
>> 2. Suppose many hours passed.
>> 3. When "cont", guest VM should see kvm-clock==K1 and guest_tsc==T1, by
>> refreshing both PVTI and tsc_offset at KVM.
> 
> Assuming a modern host where the TSC just counts sanely at a consistent
> rate and never deviates....
> 
> No. The PVTI should basically *never* change. Whatever the estimated
> (not NTP skewed) frequency of the TSC is believed to be, the KVM clock
> PVTI should indicate that at boot, telling the guest how to convert a
> TSC value into 'monotonic nanoseconds since boot'. If it ever changes,
> that's a KVM bug.
> 
> It should be saved and restored in precisely its native form, using the
> KVM_[GS]ET_CLOCK_GUEST I referenced before. For both live update (same
> host) and live migration (different host).
> 
> The TSC should also continue to count at exactly the same rate as the
> host's TSC at all times. No breaks or discontinuities due to any kind
> of 'steal time'. For live update that's easy as you just apply the same
> *offset*. For live migration that's where you have to accept that it
> depends on clock synchronization between your source and destination
> hosts, which is probably based on realtime.

That means:

- Utilize KVM_[GS]ET_CLOCK_GUEST to avoid forward/backward drift due to the
change in PVTI data structure (by adjusting 'ka->kvmclock_offset').

- Utilize realtime as reference to keep clock/tsc running.>
> 
> 
>>
>> As demonstrated in my test, currently guest_tsc doesn't stop counting during
>> blackout because of the lack of "MSR_IA32_TSC put" at
>> kvmclock_vm_state_change(). Per my understanding, it is a bug and we may need to
>> fix it.
>>
>> BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to re-configure
>> kvm-clock before continuing the guest VM.
>>
>>>
>>> KVM already lets you restore the TSC correctly. To restore KVM clock
>>> correctly, you want something like KVM_SET_CLOCK_GUEST from
>>> https://lore.kernel.org/all/20240522001817.619072-4-dwmw2@infradead.org/
>>>
>>> For cross machine migration, you *do* need to use a realtime clock
>>> reference as that's the best you have (make sure you use TAI not UTC
>>> and don't get affected by leap seconds or smearing). Use that to
>>> restore the *TSC* as well as you can to make it appear to have kept
>>> running consistently. And then KVM_SET_CLOCK_GUEST just as you would on
>>> the same host.
>>
>> Indeed QEMU Live Migration also relies on kvmclock_vm_state_change() to
>> temporarily stop/cont the source/target VM.
>>
>> Would you mean we expect something different for live migration, i.e.,
>>
>> 1. Live Migrate a source VM to a file.
>> 2. Copy the file to another server.
>> 3. Wait for 1 hour.
>> 4. Migrate from the file to target VM.
>>
>> Although it is equivalent to a one-hour downtime, we do need to count the
>> missing one-hour, correct?
> 
> I don't look at it as counting anything. The clock keeps running even
> when I'm not looking at it. If I wake up and look at it again, there is
> no 'counting' how long I was asleep...
> 

That means:

- stop/cont: clock/tsc stop running
- savevm/loadvm: clock/tsc stop running

- any live migration: clock/tsc continue running (equivalent)
- any live update (including QEMU cpr): clock/tsc continue running (equivalent)



However, there is another scenario that we 'stop' target VM on purpose before
any live migration. The 'autostart' is disabled.

After live migration, target VM won't autostart automatically, unless we issue
'cont'.

I assume this is classified as "any live migration" scenario. We still need to
keep clock/tsc running.

Thank you very much!

Dongli Zhang


