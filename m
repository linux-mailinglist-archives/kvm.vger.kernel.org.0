Return-Path: <kvm+bounces-63650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5C4C6C574
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:10:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 74A2334FDC3
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 02:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87450266B6B;
	Wed, 19 Nov 2025 02:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n4srWwif";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jaRFpgAO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0FB2512DE
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 02:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763518133; cv=fail; b=MNw1mI1y1v4Km5r4Y5A50BlGZzLfixVGxnmlgEG7Khn1pU0me12lANSlgbK38xzTm3+PZWC8wjdEhICEXjezK8FT4Ewy13VkTj1Yni4r1OCn+1bFx9tohnu0vkVLFizgt0Iw3gw76X2ieOVYM3itai95j0ab1qYh01kul7rWLy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763518133; c=relaxed/simple;
	bh=EOUpn8OhZLBzE256tVP3u7MWNl0QKmltvlM8uyjPCa0=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nMH6MXjFIC3jfjt1dfeaWpozAtmvoPI58KcVuq2xUh4IrcPwe4khrStDzsZvbFp2tyJoKWlFz1cSDgeKP2dNAcWv+u2pok8S2697JpQLu4Pnt9gSF2eAgGQv244wPdeN/lrNoAZp1yjZ3shN94ZeFBU98uBhUVjYNlMAPc4MXxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n4srWwif; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jaRFpgAO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AILO0xL022375;
	Wed, 19 Nov 2025 02:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rh+f3/l88NrnHEeLMrVNNmFYpvHeD0Oq9AX7GtbhzMY=; b=
	n4srWwifKYSLGFJRWAdYM3JCH5xIS1TYJGhD/RKjBqtEY/usI5pTvod6J4fE9Dn4
	AldhzfV6aIPEp9fdL92IVx+fDtBiQOFY+hJnBzaWWwL2brd2aKDxWUUoIjuuv0/2
	n+nTfg9VCPMid6Vw9dNliDug4LnWpWtySQvOvUrsyo4tcFFhEYcuACOMLJZ00AZf
	e6TqXNtzqkhFlRQZ39kFMTLdwHRISpLmgT6UneJccSbUXBc+yskRJ3OhDB7vTxs3
	UAxEgQ6fLbRNuQZSv2ol/OCOiFkIMGkKWhO2NCgBhIO+Ywd23rHFd91Ol1Y82+mU
	ZxPHUh09e+W4ZAOqeMzXHQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej9068e2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 02:08:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ1twdW002381;
	Wed, 19 Nov 2025 02:08:24 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy9y603-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 02:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2zbhl3x6dRZ/+l/V722Mbx0oVvpqJXUCzwcY7rhJszEsUMthWZUMUh3voTbL3b3pqF2FVyREnAMwQvZXHhFtjblnQSUj3o8hDyxA8Bx27ddrwITZit+dWkBX9OaYzmZrITNjBsNpn8VRsGLapUXZzcC0+5TbavDmgUMxoPG5vVUQzGc+BfmEffAFHZh40UpzDEWcMmia5ZmqVnWvCA3PoWhNWAt2G0CQ4tKG0J30UI2H7wqaWWO98W+T6JNERIrQoWtDNTNAd+C/onNeSZTvwDxpK7yU2flcIRsnZ1PiTrJcL7/jxdCxFtOyS8ORXl7hVNJkrMnzOwbYjqzFGPwhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rh+f3/l88NrnHEeLMrVNNmFYpvHeD0Oq9AX7GtbhzMY=;
 b=e22oGMCJvek9NEOiRHRXorIs2to0WJBD+OAcAiwLL3tKZZCapcPcNhVgmAOVvnDmzzmpfKXOENYqiTFiORpqWdY8P36IbavUnG+a5O7swlw3P+TsA4HkAafyDCieON6r+RWY/JuWp5MEtzBx3S78wRtltLOQmvFViuf+lLADMQ0Km/UcVh8pOj4I/glYmAB8HSJ3HBDNS+fNpJqI26fRmZDfpfS5XpzaTRzq/QHvU0Ua4RB7e05abayfn4GFY/1WlBnYCcDH9Dk8a5+5hyLs6nv5hfaV5J8rKMcH/PWDBAFi7jvq6F/ExwBKQPzVuky0iX7BEPHAXYF8boqO4AlXvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rh+f3/l88NrnHEeLMrVNNmFYpvHeD0Oq9AX7GtbhzMY=;
 b=jaRFpgAONoy6RwZou8Ed4dmPw1frEDiD4hS/PNCzujSDh3+ThIHL5OU4FRSe/1quct9AyduHE3NuQ5mce26WGtyAerHt0yT5KgnLYFsWHC2hqnpT5F+qGG8BYOLOOeBdc3Cx6lmttEFVC2KQ7oUbsfmmyqdzGZPz5tk+fVHwUqU=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 SA1PR10MB6295.namprd10.prod.outlook.com (2603:10b6:806:252::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Wed, 19 Nov 2025 02:08:02 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9320.013; Wed, 19 Nov 2025
 02:08:02 +0000
Message-ID: <e7498cc4-445d-494a-8ca6-5bdb73fe0505@oracle.com>
Date: Tue, 18 Nov 2025 18:07:59 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/9] target/i386/kvm/pmu: PMU Enhancement, Bugfix and
 Cleanup
From: Dongli Zhang <dongli.zhang@oracle.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc: zhao1.liu@intel.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
        ewanhai@zhaoxin.com
References: <20251111061532.36702-1-dongli.zhang@oracle.com>
Content-Language: en-US
In-Reply-To: <20251111061532.36702-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::27) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|SA1PR10MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e7404fe-674d-4780-51fc-08de27107841
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rjk0WTlJaHJRV0lYWks1dWoxZEI3ZVdrbGhnbDhhQlIvekdTVEFqQnlvNzg0?=
 =?utf-8?B?YUJONlZ1V09QVndsVVpuQmZHeURyQVZUMGRFNXJkVHJVK3JPNk1Pd2lsTnFJ?=
 =?utf-8?B?Sy80ZmJVaTI5UlBuRmhPRGszNVpKMUgxb2pwSm9oNWFMNjFNcEwybGUrSDhq?=
 =?utf-8?B?TU5lZVJSbGhkZElmLzdFdkV5UlR1M3NJR240eERxVTZGam5tY0ZOTDk1L2Iz?=
 =?utf-8?B?UHVGSzN0b1FXSmRWUjQzYTJBWGJzWXJpRi94Y0xjbkxDTVVuSUJCUW5pWDVC?=
 =?utf-8?B?YkJiZzlFY3dZVmtIUkdVU2MwS1djdDlmajFrZFg4U29NaWw5czI0L2VjaVNG?=
 =?utf-8?B?QVcvNm5FQ1hOOU9ndStSU3Q5S1d6YW5RTjJ2QmliYmVJdzRsRE9CUUJpM3Fr?=
 =?utf-8?B?NnM0UFJUZXRuc0I0Vzlva2w0R1ZrTjlsVHErVlhhNGRzV25jdTloTDliNS82?=
 =?utf-8?B?ME1DOHkraXZGODBGa2FWdndmTm5Ub0V4R2ZPWnFYTUdKR3NhbVl6MExqSUFh?=
 =?utf-8?B?UGVWczgzdExrWWF6a0pYbm5tYTNSTFg2UlZnazlhZVJuT0s1ZVdyQ0R6TGNu?=
 =?utf-8?B?b2Z4RTBmTFg5RjFwRDd2WEVUdFdXRHVUZ1VEN3pabTJjMUpZdENVQkFoSkZx?=
 =?utf-8?B?RmRUTFIrZ3k0Tm91azBMSnNYejNTRzhTYlQ2SHJORHRUdUVSRTZqL2pIbitj?=
 =?utf-8?B?OUdtbloxbkZnN1NEMVFtdHNnNEdyTTBuZnp5TTN5NkdaSG5WK1N6RlUvUnNJ?=
 =?utf-8?B?ZmJzNGNXbWcwMDRGRnl4QUZ1U245VTlIRnZKOC83MDg3dDZRSTRlQ2dHU0Nx?=
 =?utf-8?B?TXQrSkxGcS92WFJxaG9oY3RjbGM5MkczUkYyWkRhY3NtU1l3cXNaczUybXBX?=
 =?utf-8?B?Q3VuOXptVFUvS1FFMVVkS0lwbW0rVWVlVHhsanBFY0V4R09GZnREYmwyQXhD?=
 =?utf-8?B?alptY2pPN1F4dmFtK3A0KzZrMERhUUhzSzRqYnpqVzdWZnA0Z0J1dFdIOHMv?=
 =?utf-8?B?NGFpd285YWRLVUZkSDdhRS9ibTFmdzlrMDkzNlpINU5wZTk4NjNKd21VWVVJ?=
 =?utf-8?B?N2tJdDlPdUlMZmlOV2R5bU40K2EwQnEzZU4wOC9TTE5zWWVnVGE2Y0FtUWQ0?=
 =?utf-8?B?eCtWTWxZNDQ5VUQyRHIyMW00N003bklSVlprUGZuNlY0SnIvaTZjWVpuaGNQ?=
 =?utf-8?B?eGJpQWN0d1d5RElXeEdZTUJTa0VEZ3BKZFRXb2R4bWNKZUVwMDN3RWVsT05G?=
 =?utf-8?B?b3poenRhOGFjS3lWWExkdFM3R0o5K3pyR051dnRGbVo3TGsrcjQ2aTdwWmRZ?=
 =?utf-8?B?dkRLbGlUMHFuS1NpMU5zUkY0SW9KdzN3QVJiQ1E2dmNCS2RoL3o1ZUo4QmMv?=
 =?utf-8?B?dEFNYm1Ybzh4OU9taDRCc1VBVW1KUjlNN0w5d3hJUG40a2wveWl5Wk5Ddlpw?=
 =?utf-8?B?eHptcWUxQk5GcDlVc0h6cU1iMzJlaFpFZUtZdEZFU2hhYlZZeGhnT2RRM1Ax?=
 =?utf-8?B?M3dXUlYzanAvc205cS9BcmwwVFBtdXNYTVphdGIyVURTei9jZzU0cmRNbVJx?=
 =?utf-8?B?a25PczFuazlpcjFQL3pPbnVNSkxBQmdVZS9PRFNCREFka1I4MDFjOFVMM2J2?=
 =?utf-8?B?dVhaOU1Gczhad0hONWxwNUQwUDZFaGJaYldNSDk3TllycnF5dkdYNVJQTjBy?=
 =?utf-8?B?MEU4VllGMG5VZHAvdkZyQ2dGQlo5UGx3MVloelFseE93N0RPSEkyeC9tQytn?=
 =?utf-8?B?UFVpVkQydG9qSjBkSU5vNnlJZDdPR2xlaUVIanZYNjJhbkZMNENGWTNhajhL?=
 =?utf-8?B?RDhhZ0ZrbFd4RTZiK0pqSlQzZ3lFQ1UzSEdRKzFRc0ljVGZFYjVmZFEweDBU?=
 =?utf-8?B?aDZJSmE1eHhtM2dTVGI1QXRGN1B1d3dlTUtPY2pDMkpPcnhGei9SZGtRVGtI?=
 =?utf-8?Q?WM+c55UywSXiQ2QmNpD/klppPXQB9EPw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGowNkxhWks3eTJsSHVyWGZsQ3Y1NnhsNHpmUGwzOUtnMDZLYUhlVXdpQkJh?=
 =?utf-8?B?OVN1Tm4vdHJtdFgrOEZBTGRFUWVESWozajVKbTR5enJ5dHFtdzlRMEVOSGl2?=
 =?utf-8?B?UVBxN25HUXpJU0FlL2FOVmE3THlQWlFLVndTVjFtYWVyZDhOYS8xZUl5U1Fm?=
 =?utf-8?B?anJxd2VZYUo4SlhPWTJCUTRKalJvbFVDVGtjcFVadDIyNkpNcC9GWXZZbXB3?=
 =?utf-8?B?dlFsbVJLdnZGcFhocjZUWTNIZ1pxYndlZEh2VnRQZmRvdlhHTExNclNYcVIw?=
 =?utf-8?B?eHI2UzlJcFBpc1VJam8vWjZDNElKcG5VN1lTejZuUEVOelFKT1NJR2pqb3Fo?=
 =?utf-8?B?ZThMOG5sempHZXlDZzcrREdsMTlHMy9wemJmR09haG4zNExLc0NZTTZRekJQ?=
 =?utf-8?B?UVlCdlg1dHNDZXZoZTFwSGdONENVMm9aSXBQbEl0enVsZHB2NU92RlZwenhp?=
 =?utf-8?B?ZHk0VzdlMmJIbklXZVZFdWlpTFc4U2U1dlBTN0w5U0FpdEdrR0VqL3RMWm12?=
 =?utf-8?B?MHYrcUl0bTJDaERFV0VJZU41Y1ZZMFphMm1tWUVhZitGbTM4bEcvNitpcGs2?=
 =?utf-8?B?MXczK1pGUlJMZHowRCtjc3paU0JuVDk2UDhyYjgvYyt2S2Z5Q3hJYUtGbkRa?=
 =?utf-8?B?T1pCTzFJZFk1RFRqSkIrUnloQmVGTVk0NnJPbkFvUVUzYXprYSt6SzBwQXJ6?=
 =?utf-8?B?MGNYVmNKNFB5QkVscEtNeDQvdGZvc3lkVFBpTjdyYjRhUmRrQ1JMZktucnVC?=
 =?utf-8?B?eWYyRkNGWENJWHAyU2YzMmVFSG9XSmQ3YVJxT083QWMvaDlKN25FallCVXdp?=
 =?utf-8?B?cDJuQzY2NCtOWGdDWFJjeExZeG1PWk1ZWkF4T292QW1CakxhZTZhNnFDK3Jk?=
 =?utf-8?B?QzJMRS9XY3Zaa3Qzb0pHOWRxS0UxamprdElHN0tqTTNMNkNKKzZHcm56Mm04?=
 =?utf-8?B?UEUyYmpUNzlCSkI4VFlxekFCazUvdFl5OU5ldmh5SDMwWkNmejBab1R1b1BR?=
 =?utf-8?B?L2tFY2loL0Q3UU1KQk94S2MrUExQUjd5blpBTW0zK0VIWFBGaGxoSWVhRU8z?=
 =?utf-8?B?SDFjaWZRb3dTTFZPVmI1TkVRdzl4ekZwV1E0a3RXUmVicGxtYU54d3F1QTBk?=
 =?utf-8?B?SUkrRzVoVUp5MWE4eENra3dESWJSc0JHdjhyWlg3dmZTT1l0WDVaMzd4NkdB?=
 =?utf-8?B?UVVOUjU5YXM0MkxsOUJuekFvYlAweVFIbmtVSFpRTTlJcU9tWmZxVHJzUWJx?=
 =?utf-8?B?elMwczBzK2luT2k0cXl6Yi8raVdoa0FkeUQrUnkrajEzZlpubnI5cjhiaTNw?=
 =?utf-8?B?aWtPTXNySU9IMjVDTUtRWWEwK1Y3bGljNEZPSDYyN0FDZUo0b0l4WEdCbmJC?=
 =?utf-8?B?VHN0bk9RUjM2VDNnN1RiejdoV2psVnNvR2dGUnBHMFJKa242aGJQNkpuRzRX?=
 =?utf-8?B?Z09kWk5HdUFXUG5xanFWbWovbTZoTFFhTHNOUHNNYnBHVjQzdU10SzlBMTFN?=
 =?utf-8?B?UUZleURFcjNNVHd0K24wUGtNU1hHaGxmOGwvelRpKzIvSXo4YkpYVUhGRi9D?=
 =?utf-8?B?eTZ0bFUvQkNxVE5LQ0RZQnYzQndRcWgyRklGUXdINWRkUzRuczhWOHNUQVBi?=
 =?utf-8?B?QWxXbVFtdzVBbDA1L2ZDamNaNm5aTlJ1ZHNJTU1hdzFtVGlhbTJ4YmUxUmxY?=
 =?utf-8?B?cE92allIb0swYWVpbHFaV2ZOOVBnR0VORjhxUkUrUVRSM1Nabm83T2hDOXVC?=
 =?utf-8?B?eFRXRjNNSmhYZ1F2ZlZJajBqUjdmOWdTMGFzcXJUakwrcDkxTUlrbmpLR3Iz?=
 =?utf-8?B?V0xBVFhwNG1aRndrK2RjZkxkbncvZ1c1dTV0N3dGdVhVTjBURU9GUy9JTi9a?=
 =?utf-8?B?ZkZncEdXTnNpMEZKN0N2WVlxbkQ2aENyU2V5NlhrcXczNjEyQWdsTVJhRWUw?=
 =?utf-8?B?Y05Hd2FCdDBvNTRLK3dOYjZMeitHZ0piOEMvYlA5SG13eGNCM3dKcERCdGxS?=
 =?utf-8?B?YnJhdXpkenJIVmpSaGJHN1FLUGVxWk1nU2daN2lQVDFtR1dzZWxkRUhTU2da?=
 =?utf-8?B?Y3FteVFWRVU3QkFTekExT1JFUnZLV1poNUxLYVpBakxDczhyaGllazBSOWd1?=
 =?utf-8?B?U1RkNXh1Y043RllYOWdaN0ZMUUpaQUh6ck80SVBkaWlGOEdzL1pNaW93NFRy?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aWWlZIfMiXqu6/Lpd75S+HSO+dg5B2EsVuU3948O0xz+VqrHA7m4v/8grfd9zacSqJx/CsO1AJ2BTQ5tMEAn3EpDlvOpQoxkdIM/Jst8XAqY5YBDiaNIdPASEdn3+lpk0WI+zyIyU7QaROPA3CxnVup8UGXYshYV8Pz5NGMIuBbxJoIh8/BbCcunfF/DrD/kaIdmq1xgkJfPqbSR1QNjYmtzvtSQfWpd/x2w/zF5boZjJX6dXZyZgPT5tFySPbTok9bqFfO2dOIJDHPBJReWWxsbqcyD4VChIBXijUaZ1dJn1BgC++CEBt+5DbX+wKtipfoV0QIok0+Qgy6N+/vq9o9LS6+9jX8C5HDcXpSl6GkE5NoWgVXXKMKSPabGkhODRGWJ0x8sOqfKUz490FhaMj4GGcCSjkYQ694adp3+qBKvL+E8BBkUn7ezBqis695vJZcJFk6sqp1o/3k5Ci2DCyPR+j/nPeggIMQs8Q3ySuG+vusRNYKX8XdkMMcwPbmQe7ttTAL0r/YW2N7+WdR9zjobpU88kVTuefP4pN1kk6L6YNzZHuG2xVEO1cWj0YCCND8kYcEwyS5DNDjV51TiK3OyqStPnzra3n4RQmcFNo4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e7404fe-674d-4780-51fc-08de27107841
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 02:08:02.5925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkJwq9kzm3hnu4URy5hTc6pl0gC4MAjXsc513e3BdGL753Z46PkklI/vww+Qi30qPpABQx+x1hyvWbmZAoPc4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6295
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511190015
X-Authority-Analysis: v=2.4 cv=OMAqHCaB c=1 sm=1 tr=0 ts=691d2699 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z1coTuTpIt5psuWBCRIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: SMQm9JWDd24pKDUD2NMwt68Ws7Feg2F2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX1nnDtFSClWdG
 8FVt65RHSpikVlqnH1p/rANgMt6Srji4Sgs5+Qr2+WAN4Wu3TfB4DRMsvzkr13+5BuAe+WiqhwW
 s0l5pnduzPEhPD9Te+tqHgjoX+SSGXwPIX0PphTK0QOzaV37hSvxkqU9PnVV/Ip7NQ9t8yxcoxf
 3zARJxpZ9TnpNj/VEbKEw0qR5CWqGkOp6HCjwcNHcJDTQMFL5c3lgyoNwiJnr0UZHGGI8zdnThj
 caoEA/KSt9B7IjqpSCM57RSi4EuFSoHZvQ7JWD88p2JwaAdYQMlAnSW4c/p+JmGnebtTDly0TN+
 BN56ztQ9goz9Nrqd3lXLlbtvY53Aoxf09vkWy9kgpYx4HzDuwAAgd1I6qDoXSC3Zk0ZmMTT9gK4
 AN5WBmO0xx067AaoEaCBYi2DlCmB2g==
X-Proofpoint-GUID: SMQm9JWDd24pKDUD2NMwt68Ws7Feg2F2

Hi Paolo,

Apologies if this causes any inconvenience.

Would you consider this patchset? It resolves several QEMU AMD vPMU issues, and
each patch has received a Reviewed-by from at least two reviewers.

Thank you very much!

Dongli Zhang

On 11/10/25 10:14 PM, Dongli Zhang wrote:
> This patchset addresses four bugs related to AMD PMU virtualization.
> 
> 1. The PerfMonV2 is still available if PERCORE if disabled via
> "-cpu host,-perfctr-core".
> 
> 2. The VM 'cpuid' command still returns PERFCORE although "-pmu" is
> configured.
> 
> 3. The third issue is that using "-cpu host,-pmu" does not disable AMD PMU
> virtualization. When using "-cpu EPYC" or "-cpu host,-pmu", AMD PMU
> virtualization remains enabled. On the VM's Linux side, you might still
> see:
> 
> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
> 
> instead of:
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
> when "-pmu" is configured.
> 
> 4. The fourth issue is that unreclaimed performance events (after a QEMU
> system_reset) in KVM may cause random, unwanted, or unknown NMIs to be
> injected into the VM.
> 
> The AMD PMU registers are not reset during QEMU system_reset.
> 
> (1) If the VM is reset (e.g., via QEMU system_reset or VM kdump/kexec) while
> running "perf top", the PMU registers are not disabled properly.
> 
> (2) Despite x86_cpu_reset() resetting many registers to zero, kvm_put_msrs()
> does not handle AMD PMU registers, causing some PMU events to remain
> enabled in KVM.
> 
> (3) The KVM kvm_pmc_speculative_in_use() function consistently returns true,
> preventing the reclamation of these events. Consequently, the
> kvm_pmc->perf_event remains active.
> 
> (4) After a reboot, the VM kernel may report the following error:
> 
> [    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
> [    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)
> 
> (5) In the worst case, the active kvm_pmc->perf_event may inject unknown
> NMIs randomly into the VM kernel:
> 
> [...] Uhhuh. NMI received for unknown reason 30 on CPU 0.
> 
> To resolve these issues, we propose resetting AMD PMU registers during the
> VM reset process
> 
> 
> Changed since v1:
>   - Use feature_dependencies for CPUID_EXT3_PERFCORE and
>     CPUID_8000_0022_EAX_PERFMON_V2.
>   - Remove CPUID_EXT3_PERFCORE when !cpu->enable_pmu.
>   - Pick kvm_arch_pre_create_vcpu() patch from Xiaoyao Li.
>   - Use "-pmu" but not a global "pmu-cap-disabled" for KVM_PMU_CAP_DISABLE.
>   - Also use sysfs kvm.enable_pmu=N to determine if PMU is supported.
>   - Some changes to PMU register limit calculation.
> Changed since v2:
>   - Change has_pmu_cap to pmu_cap.
>   - Use cpuid_find_entry() instead of cpu_x86_cpuid().
>   - Rework the code flow of PATCH 07 related to kvm.enable_pmu=N following
>     Zhao's suggestion.
>   - Use object_property_get_int() to get CPU family.
>   - Add support to Zhaoxin.
> Changed since v3:
>   - Re-base on top of Zhao's queued patch.
>   - Use host_cpu_vendor_fms() from Zhao's patch.
>   - Pick new version of kvm_arch_pre_create_vcpu() patch from Xiaoyao.
>   - Re-split the cases into enable_pmu and !enable_pmu, following Zhao's
>     suggestion.
>   - Check AMD directly makes the "compat" rule clear.
>   - Some changes on commit message and comment.
>   - Bring back global static variable 'kvm_pmu_disabled' read from
>     /sys/module/kvm/parameters/enable_pmu.
> Changed since v4:
>   - Re-base on top of most recent mainline QEMU.
>   - Add more Reviewed-by.
>   - All patches are reviewed.
> Changed since v5:
>   - Re-base on top of most recent mainline QEMU.
>   - Remove patch "kvm: Introduce kvm_arch_pre_create_vcpu()" as it is
>     already merged.
>   - To resolve conflicts in new [PATCH v6 3/9] , move the PMU related code
>     before the call site of is_tdx_vm().
> Changed since v6:
>   - Re-base on top of most recent mainline QEMU (staging branch).
>   - Add more Reviewed-by from Dapeng and Sandipan.
> 
> 
> Dongli Zhang (9):
>   target/i386: disable PerfMonV2 when PERFCORE unavailable
>   target/i386: disable PERFCORE when "-pmu" is configured
>   target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu" is configured
>   target/i386/kvm: extract unrelated code out of kvm_x86_build_cpuid()
>   target/i386/kvm: rename architectural PMU variables
>   target/i386/kvm: query kvm.enable_pmu parameter
>   target/i386/kvm: reset AMD PMU registers during VM reset
>   target/i386/kvm: support perfmon-v2 for reset
>   target/i386/kvm: don't stop Intel PMU counters
> 
>  target/i386/cpu.c     |   8 +
>  target/i386/cpu.h     |  16 ++
>  target/i386/kvm/kvm.c | 355 +++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 332 insertions(+), 47 deletions(-)
> 
> branch: remotes/origin/staging
> base-commit: 593aee5df98b4a862ff8841a57ea3dbf22131a5f
> 
> Thank you very much!
> 
> Dongli Zhang
> 
> 


