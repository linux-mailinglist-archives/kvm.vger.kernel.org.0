Return-Path: <kvm+bounces-35831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFB6EA154D0
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 17:50:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36B521698D1
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 16:50:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCF7319E97B;
	Fri, 17 Jan 2025 16:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UqftVW2p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RUaFhKSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04BA19924D;
	Fri, 17 Jan 2025 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737132616; cv=fail; b=XvWPlWGGUiGoxHIVQt0ph1wBqvapx4OXf7sDQiiM52BVFWyVt0CliL1ad/hZdyO8rlvPo43de4Kr68y9bxyyq4EfZjxX3xvFadbMDwogzsxAil6QhWpbsBX1V3bjK5KJXiWqky1EDi4jo8NbGLqw1tYdfAvDH3c+P6nQZwA6ovQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737132616; c=relaxed/simple;
	bh=kRowOKZRyxvzsrgt8MHrOK4s8VqMLbvk9R2iY/qSyVE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F4GBMCklFkNpA4tTWAB8DAUXUxEx+49NGd0oDZsGgJVcTA7CZlysVQQGqOr1TTvXktzMIvP3W3pyz6kxhp7yQQWgsCT7s0ZQdM+1N++5YBqB3cvVWAp332MWD3ICOg7kusILijzhDIN9NIWnYoPNfcaqDzzK2YizUmFQjTPVyvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UqftVW2p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RUaFhKSZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50HEfnK8026592;
	Fri, 17 Jan 2025 16:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BEnTuZXFOxmAo5XUrVu2jkrYQCRufr/E2ws31q3m2HI=; b=
	UqftVW2pP8RxY64ccJW3Cj0vwSsRv/gTLmI1W860UkK2aHh12CQEeMivwLC/BOlU
	hjejB0K6YyIfknFYEwg+IbrOaSRmSyRY9ltBZ6Nov+3fThdPFLYZ5KFfgDythwDD
	0UHINwvyEjqtVzX3SdsUUpvzBTZqAqLM86ox/2iutu6koj5yw56sHQUcbTw1jfPJ
	PVNSCSQHoFlnf1zigv73Swt3q5JXH4FUAAOUz4eRZGvCQm0dJQPqwLUg+uVimUY8
	xQhcP+kpTWJg1fPF4WbuAjpykixKKTnjvj5+XlDblcdJnaxYFRklf4fh1pQFbCCj
	cv5axymPyqeqnKrzkgxu1g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443g8sn07n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 16:50:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50HGCZtY032233;
	Fri, 17 Jan 2025 16:50:08 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f3cc9kq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jan 2025 16:50:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eH3N6iajOnmJ+rG0gdo/y+BhvwXHUm+QaPRhAAPY49FNqVh+TWS37RI60PXFts9BUE/+A6R88oZ5hDMeFZQPewTbYzfP8BVD40Hv4IlRXt2WHvIHG8Xon34ovZqpfpfZ/QoaAVFonDSFkb2wEwfxt9jZ+Y5KGFQd5/94tjM/bNGPkQZG7Cp9PSj8AncEMnleUQ9+wtVkwKhffciATHvNzO4+rWT9ZI5LDkV4iHf2Sqw2iquTlg/si2vNc2r/CCRnBxmwUFH3u8DwLzFR851hdoafIFt9EeuJ6cSu2kxUKgg1Hd5CRx0TWD/cmsNDkOVPDZnoL9uAouqwpuoGAIv1eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEnTuZXFOxmAo5XUrVu2jkrYQCRufr/E2ws31q3m2HI=;
 b=kfsIfmwloVM0c7yNZtzCdGW2iUufF6X0BtGo7oj8DTrHY15BhTHgGhddIAlghIwAmuVwdKPtysAObQ+O9487h7S7pqxob3tVV2KjYEDl2cCdnUsPsdum/wEWG0UGan9lKhyUw5r/uWAC0sQd/thRJyAcXGSouMn0teprAgIWX4Lc0Y50832ZP5BQWHx4J06DLxbfJVEOnhtiuQVFKg708bG0KZbSo7MjFPimMaxW+NHZxxwyqWrZuyUDs40rn1N3HT8rJAYcmFmSNJBTpZTTtqOFvgi5ER/R5zNy/5Clu8twGkDvOsw7EuLmPimlxc0WxTboOO7Awnx5egm8PzItdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEnTuZXFOxmAo5XUrVu2jkrYQCRufr/E2ws31q3m2HI=;
 b=RUaFhKSZsPY/XwtLSNaV/mNbbI0T3j1c1SI8Xg5dqkvy5Fj86hhxodU0VkWrjur2rTIMSF0ROZOCfqBgs6COUg6R3JtYuwJUM+nkwHarel9q4a43+gMME7BFTRnKhW5R8IwFKZr3HL73A18xVZ7Tl6XDRaGBFRwl/GGK83kKT3U=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB7988.namprd10.prod.outlook.com (2603:10b6:610:1c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Fri, 17 Jan
 2025 16:50:06 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 16:50:06 +0000
Message-ID: <d00be9fa-364c-4b9e-a14e-a3b403e7bd6c@oracle.com>
Date: Fri, 17 Jan 2025 10:50:04 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
To: Haoran Zhang <wh1sper@zju.edu.cn>
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com>
 <20250117114400.79792-1-wh1sper@zju.edu.cn>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250117114400.79792-1-wh1sper@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0157.namprd02.prod.outlook.com
 (2603:10b6:5:332::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB7988:EE_
X-MS-Office365-Filtering-Correlation-Id: df026ae4-e6d9-4950-3374-08dd3716feaf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UW1rUjVteDFlOUhqNlBXK2lEZGlNMXZrcnNpM0FCcU5tdEdJVzJ6Ry8yQk1v?=
 =?utf-8?B?dXVGSENrRTZTbkpEL2oxUnowQk1wVm83LzF6SFM4eU9NdU9YbXdxY250U1B3?=
 =?utf-8?B?Z2ZkSnRMUWpWVTBhZFJHTWpweEU1eUtvOE9LYTF4aUlqeHU2R2dhbWNLKy8v?=
 =?utf-8?B?NEZna1o3ays3bXVrbjhicHV1bmd3Si92bXhuaTErWFpMWXpob016OHZ4QWFy?=
 =?utf-8?B?S1NmdzdaL01NdVR1T3FtbHRyejlENGtEbkJ4b2U1aHNpNGY0RzZqZnBieTUv?=
 =?utf-8?B?UC83RUp6VHFuamc5amdEb1lDZnZVTXdvMkl6d2Q1cGVqVmVVc3BpOExlakZu?=
 =?utf-8?B?SGg0b2lsSTlDWUt3c2UyUDlKWE96UjNESlpwamN3RUxWMVZCWEtDWGRza21z?=
 =?utf-8?B?emdKc0twMldkbHhhalpHU3lhcXU2YWd5TGtwaDJJRU5JWEFBRFIzMytVMFFh?=
 =?utf-8?B?WXRmTUFIN3VRdnZ0RlQvM2hRVHNGdUx3KzBvekpmZVh2WkVZWTlvODFRZnR4?=
 =?utf-8?B?dGhKUjZjOW5IclNjYXBpdzZRMGNWeXZKUXFFWmFGNHpsMXJMSkRnWmZCcWo0?=
 =?utf-8?B?UnBHam5yTjFYaHIrUUROTE5kakNNYmxsZENURENPRi8xQk9DdHdwSXlvYUYw?=
 =?utf-8?B?ZEhzYVd4a285NHVoSWtFalpVQ2xpTDNJNHY3NDFuclFHQktHY2tHRkJZaUlO?=
 =?utf-8?B?c2Y2Nzg4MVlBbUJudHQ4VW94M2l4TDdaOFM2Vm9UZmhUSDNGdDkvNisrc1ky?=
 =?utf-8?B?aW9mZHdqVzVIZWxLZ0FhWFlzTHlROGR3VXU0U2ZVdzZlK0FjTDlJd1A1T0dI?=
 =?utf-8?B?UXcrcjZIWXRsT1Y3bWszNHRUL3hXZHN0dENQMTRmVHVjMkQyaTE4cndYNFVS?=
 =?utf-8?B?OHd4QmJqU25RbS9XWitMM2FaUGNocnZYNnFLWHZoYnYrQjlYaDZ1bXJWTmFs?=
 =?utf-8?B?SWs5ajVZdnUrZ2YvcU9nTHpSTm5KMzFjbDArQnhDRk1KQjVtRHRwQ0JsdnlG?=
 =?utf-8?B?a3MxYy9udWdsR1lsQU1mRnNoSXA1ajZhK25ldEwvUFc2NlRGUk9icGJCT0xS?=
 =?utf-8?B?dzM5VnI4K3p6TnZkQzYzam42ZEI5RVo4U20vdUVqV1g5WnR5Rm4yalA5T2Ey?=
 =?utf-8?B?dXo5L3BiVnVnQ3F4VXN1TkNzVENqOVUwa2RPZmJpbjNXaVJ6ZlUwZy9SUmtx?=
 =?utf-8?B?bDF3MldTQkRoODdmSlcwamZpZ295NldnZStsUHE4WmdvTHNwazVla21LTmR4?=
 =?utf-8?B?WXVnRXJLMUVRSVllaktFZldqS0FrMkYwSnF5U0V0QVZFL2NGTURRNTUwQ2pw?=
 =?utf-8?B?NzBvTGk1cFhoQ1FsK1JlRGJLbEJZcUtqMWZVR0hqREthVXdUdDNHL2hhZzNl?=
 =?utf-8?B?SG4rWFVhYytmNW9mT2J0V21YSXBueHd5MC95eEo5SkVHMFp1MmJad3FUMnNr?=
 =?utf-8?B?c1RRZ3NDU1ZzTk0zSVFZMXUvNUVSQXg1U1oyU0lDS21yUFYzcTdNLzlDMm51?=
 =?utf-8?B?dHBvaWlDci94V2JBUGwwcmoydU5yUUhoVGhVYUdlcTM0RXBzU1JEVnMzZVlk?=
 =?utf-8?B?dWNONGdBMGI0ZEZqYklKczFOdGhoQkVJUE5kK2dnRlhCY01xeTRqTGM2SWMw?=
 =?utf-8?B?ZTZCV1lOa3JrZ3B4MjVCMjkyRVJrN01FZkJIMnh0S1ZjWjRNRFZjNWJWeWN6?=
 =?utf-8?B?bnAxSVdqeFRqME9scDJOUXY2VklnUVFnMXdRVkJaTDBWVTVaSitjZU1aalp1?=
 =?utf-8?B?R0w5bzB0RVk1ekFhcVRlMit5ZjViSzZXQ0FXNzkzOFpxQlRsdEF2RHc0Mkhz?=
 =?utf-8?B?elZ3SkhaUHo5R09vVnZOcDNjc3J4THFkUGN5b2VLdlpKZ3JOTTAyaDBjd3pG?=
 =?utf-8?Q?IXbKrvvG1k3Xf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVBWVUNscCtxNTBBWUlVNGxVRzBBR1hGcGVPZzlDTlN2L0k3ODlmbkFkci9H?=
 =?utf-8?B?YUtESk1iMmZDdWpodUtMUWFIalE4THZEK2FlTmcxSU1mbmwxWmpEdkJIcTM1?=
 =?utf-8?B?aDlnL3h3RmtaZWVENEs3S3hFWVJjaWNPZlduOXpZY095YnRzYS9GWFNTaHU0?=
 =?utf-8?B?L2pjTWNCUVJaRFF4MFlXT0lMUHp1aE1pSkhrOVJOaDVadldrVWVwZ3FzMjUz?=
 =?utf-8?B?RVhrRFU2UWRnMWp1cVF2NDBwM0JFWXpDVEZXeVhSWEUvRmozUWVrRktJdmR3?=
 =?utf-8?B?aXpWa2pJYnpza3g4K01MSzRTQXN4YUc4b0l3eUtUU2cwL3pwUW1qRUVBUnNw?=
 =?utf-8?B?UXdrdTBBQlJXdkZsd1BiOE5LWnp1TThsaFBHRGNJR2UzenlBZlArTGV1b1Ju?=
 =?utf-8?B?ZGRlak5QUlFKZjBSYlZ3dzlUK3VFMGg4MURXTTNBMVlNeVVSS1ZPSFBUUTJX?=
 =?utf-8?B?RlBPL2h0N3BvU1Rialh0Ykc4MFNHOGYwZDBZZi9PaGp1bndnRnBnWVBSMkJU?=
 =?utf-8?B?V2ZNdERKaUhIRmkyV2Y2R3JveXpLMlFETUZrVFFKb3lmRWRMaXVKQmljTTVP?=
 =?utf-8?B?RmRwemQ5aWsyc2x0VW9qUGlBaGoyWXRYTGt6M0s2aDEweXJHZjlQcUp1bjls?=
 =?utf-8?B?dERQU0ZWQkdrQWo4Y2h6WDFsVlBIRXBwdjlGSndiTnRpcDZqeDArcjF0R1dB?=
 =?utf-8?B?Sll0K2pVUEZOMFQ4alZRMnVCcUcxL0YzdGUvbUFiYzkvWmtzWWhkTHNYNmxa?=
 =?utf-8?B?KzVqSm81MHV4SnljNnJzRUFra0s5MkRDQ3o5U3FSZ29RMkgyc1V3SFdpblN0?=
 =?utf-8?B?R1ppRjBRdDJZVkF4ZXNCVUh4YmNwYk5uc2IrT2hkbWlmc1crUTZnUmlsNCti?=
 =?utf-8?B?eTlrSWExWnRUZklURy9yVEk5b1g1ZitEWDhVMml5K2NhZ3h2bEcrWGVEYkk2?=
 =?utf-8?B?WVMvaGx3UVdKNE01NXpjSFRoOTR3K0lBQUJqQjhvcXhLeUxrU1h4bjVjZWNH?=
 =?utf-8?B?MkM5bEZzTEx2cnhMbkdGbk5BOVRjOFlHb0w4MC9xZ3Blb0RNUDh4OCtjNldy?=
 =?utf-8?B?eUhHY2pBZFJZUEduYmdROFN1OVJpdVNFMEVrNHQ0cnlhaHdxdFNKZmdlSkhX?=
 =?utf-8?B?QmlhaFlWSldSVW9ETGxtV2U2QUdGVUNGbDJpT3B5dnc2bDdONEZIeldYb3Vp?=
 =?utf-8?B?d202ZW1iS3JyR3lBaStXUmZpSm1OWHhpbmNsWWR3blVjbGFOTHpvSWpKQUNu?=
 =?utf-8?B?Q3NRWjFZY3VOVmxNbFdWcEh1U2VEbUZRR2ZlL3RqRUdGcDZ0cG41V3VmNkY5?=
 =?utf-8?B?QUlwWmVrWXZXa0FCUEtLS2ZEZTVFNTRvamxrOWxNeUdRVWZvZGN4RllvUy9P?=
 =?utf-8?B?VVptd0V1ZTI1WkM1bVF0STRPZGZ1UUp0dkx6QXZIQ2d5aTJxZ0k5eGRvbTM2?=
 =?utf-8?B?Yko0VHVEQ0FGT2tnaUNwTTNtYkc5T0VOVGtSZXk2Ym8wZGpOZDFDL3dqUWhx?=
 =?utf-8?B?NFN2ZnQwdFhYL2V3WUttdW1rRXBlaSs4OWF2L2lXZFZWK2RybU52bUVWbmVr?=
 =?utf-8?B?MWRqNnM3WGZZRFM2YjJmNTRtM05CMy9pT3U2QW9DNXFReEt4MGVWVFVxMHZX?=
 =?utf-8?B?citlcWxqNnhWaHpBY3cvWnEwa2dxTW5LdXpBS1RMaWVGUiszeXZFbE5EbElk?=
 =?utf-8?B?aXJpZk56Q1NTWHJiSzJDQkNmUVVFcS96Y2ZPdlZ2eWpmTUw4bEMyMzZPdzcy?=
 =?utf-8?B?LzRUc0JoQUJBdWxyVHpNVW1Ka0lqSnBaYjdzcUJqMU9MRXFOckhmaUFtbURK?=
 =?utf-8?B?dmRaczVaU2pTU3c2bDNYTzZvTDhwc01iZVdMT1JBME9lSENoY1MyMTdtbUpT?=
 =?utf-8?B?WlhhdW9jblptSzU0cFVLcC91S0lOckVKMllOa2JTRVBkVnErM0UrTUhwcnZG?=
 =?utf-8?B?SjRoWnU1c0dFQVhXK3BWdXJHeC9IRFo4RWs1STdFampWdkJoTVBlL0NOTHhD?=
 =?utf-8?B?aUpockNEYzFYTjJnM0dsNnArUVJSOG1rWUdQZHdMUEk1dTdjSlArR1Z2c1pF?=
 =?utf-8?B?aVIybkJZdTdOTDRyTTJmdlZjWlQvRWtPWkZJL2ZrbFV4MWMzZklLVldpd09H?=
 =?utf-8?B?SWJvUUIvWUV5ODNhSWpRWGk2REtLRWZQYkZZaytzamh5eEdpOG1teE5tWGg0?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OtZO5zVO8/lXdgR5YZXk52vxAiH1oSxVMZpxrR//9BQzlZh96nadS0jkCCo5xDSJywTyp3YhYO3yl6K4AsOMThZ1keLqfcesScttYDgD31Vll4rhcNbZt6juSTsmniq9edQNNe0LMDELG6PVYWWLIsqlMgaagp93awoFvcpePNmv1ik/PQBMTrOvNB5+kUIUqcvU7cgOcjSj0GXxAaRIshH6OyRheJTngnTBYExsSptlmeuwzOw+pIhfzMTz358/3GllkSGQ5IybpNBW2wf9FnWilEp6WShXpa3hOO/dfr3J88M13JOpJR5nIgth6f8wLtnhlwXbmLDDSCVF3CtTZ5g9qD1NUV09j6WypdmccoUH0oyWtNHJ3SvWEbo8O+Do4sRscC2a5MzwcKTD7HMyYM7uxsHSddOiYsfvUP7IpyFT6Rgo0CRggH9ehM3DoHEiexZNrRe2dfuB7gGzSqVYscCpVttkzn8Fy/r0tqeUOTPIrl/BVDe0kGnvzWMA8gIbMv1qcD/3YImiS9TeHrfuSr9BnFjyugHus2zLTdQwDzOxM7zBcsJYAnJkdXDfDIV6GO0Hu8hi0j+89Pf8+5x3xwCGf8QZcQsKh516W413Itg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df026ae4-e6d9-4950-3374-08dd3716feaf
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2025 16:50:05.9594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vIvVKb5EEvZCsK1bZXIdHgXFs7yINFd08ja5KU8gonCF1f7QaKwA5tkEd30rtVhB1mjRhQ1M11WG9H+wIRi1SfIRjZt2ya0ccRJsDt9OvUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-17_06,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501170132
X-Proofpoint-GUID: AHg86DDKptFO2A7vX44XZe8zu5ULe611
X-Proofpoint-ORIG-GUID: AHg86DDKptFO2A7vX44XZe8zu5ULe611

On 1/17/25 5:42 AM, Haoran Zhang wrote:
>> I see now and can replicate it. I think there is a 2nd bug in
>> vhost_scsi_set_endpoint related to all this where we need to
>> prevent switching targets like this or else we'll leak some
>> other refcounts. If 500140501e23be28's tpg number was 3 then
>> we would overwrite the existing vs->vs_vhost_wwpn and never
>> be able to release the refounts on the tpgs from 500140562c8936fa.
>>
>> I'll send a patchset to fix everything and cc you.
>>
>> Thanks for all the work you did testing and debugging this
>> issue.
> 
> You are welcome. There is another bug I was about to report, but I'm not
> sure whether I should create a new thread. I feel that the original design
> of dynamically allocating new vs_tpgs in vhost_scsi_set_endpoint is not
> intuitive, and copying TPGs before setting the target doesn't seem
> logical. Since you are already refactoring the code, maybe I should post
> it here so we can address these issues in one go.

Yeah, I'm not sure if being able to call vhost_scsi_set_endpoint multiple
times and pick up new tpgs is actually a feature or not. There's so many
bugs and it also doesn't support tpg removal.

> 
> [PATCH] vhost/scsi: Fix dangling pointer in vhost_scsi_set_endpoint()
> 
> Since commit 4f7f46d32c98 ("tcm_vhost: Use vq->private_data to indicate
> if the endpoint is setup"), a dangling pointer issue has been introduced
> in vhost_scsi_set_endpoint() when the host fails to reconfigure the
> vhost-scsi endpoint. Specifically, this causes a UAF fault in
> vhost_scsi_get_req() when the guest attempts to send an SCSI request.
> 
I saw that while reviewing the code. Here is my patch. I just added a new
goto, because we don't need to do the undepend since we never did any
depend calls.

--------------------


From 0474c5d41968095ea911d48159e4f6a129f1a862 Mon Sep 17 00:00:00 2001
From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 15 Jan 2025 19:05:22 -0600
Subject: [PATCH 1/3] vhost-scsi: Avoid accessing a freed vs_tpg when no tpgs
 are found

This fixes a use after free that occurs when vhost_scsi_set_endpoint is
called more than once and calls after the first call do not find any
tpgs to add to the vs_tpg. When vhost_scsi_set_endpoint first finds
tpgs to add to the vs_tpg array match=true, so we will do:

vhost_vq_set_backend(vq, vs_tpg);
...

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

If vhost_scsi_set_endpoint is called again and no tpgs are found
match=false so we skip the vhost_vq_set_backend call leaving the
pointer to the vs_tpg we then free via:

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

If a scsi request is then sent we do:

vhost_scsi_handle_vq -> vhost_scsi_get_req -> vhost_vq_get_backend

which sees the vs_tpg we just did a kfree on.

This fixes the issue by having us not reset and free the existing
vs->vs-tpg pointer so the virtqueue private_data stays valid.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/scsi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 718fa4e0b31e..143276df16e2 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1775,6 +1775,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		ret = 0;
 	} else {
 		ret = -EEXIST;
+		goto free_vs_tpg;
 	}
 
 	/*
@@ -1802,6 +1803,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
 	}
+free_vs_tpg:
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
-- 
2.43.0



