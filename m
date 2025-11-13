Return-Path: <kvm+bounces-62966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7A2C5581E
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 04:07:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6921A3AB227
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 03:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7D02741C0;
	Thu, 13 Nov 2025 03:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MDuB67Mr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tatCRhT+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EE5C141;
	Thu, 13 Nov 2025 03:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763003213; cv=fail; b=u2dUFjp4Q3+vSvDPWqawI3cc6Ocs4QdBcrI7sT2V3j0yMXib/BPVXlQVyTgr/qir6ngG7x+Q0A+RghB/k3OUkkxsrh5HwA2g+VzhqheIFiCdP/KHCdzvi2fRmTBW+ymnChYt6CgKwJ6XglsAT54AtTP5cvU205QBqduE2RmxORM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763003213; c=relaxed/simple;
	bh=xpjnorQQoJaYvzLh3sZrUy9RHnwt8hHDulYpXc3x8X0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VAhuM2lfuT5RZL8d0EglpfNKkphDgVr5VldAEJK3uC4zpOkwbYLKvnymEoWbJzHG80lMiqnSP1DBAOxn4COuzB6+rmd1eubgIoT0UvFFfK0/UychrcYZatuC5De28LuzpEuYqn9HbRpO1xRYR/01Vr+KNZXAC5MUKr1aJcCJSVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MDuB67Mr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tatCRhT+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gvTY024149;
	Thu, 13 Nov 2025 03:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=OQcQe98jzdenx/FwQtRWSGTfo5CAjQz1AJnwBv5h7HA=; b=
	MDuB67MrNMAdE0RNcpsrVvHFS/uiS8QJpghtZlryX/y5k3EfX0eYDmei32IZvxIA
	jAyNy7xB2Q2GasOcz0hmhFnMPCiZQATNFZeRCnyYDtDfgzLWQL8rRN212EqWUAa4
	VFDxWt1MSkLN1k3qUTIiyj03au2v/N5khg4Tj9W7L4aRrnEPClkEPWDsILzcHAcv
	wPzzCjBGS/VIIOPEoTkosmGO6/cT4QGy+0vvA9QgapteNaxJ3veIeFbgXHhKH+wM
	noyJp0+HwNvLlDQG3PhOjZ9Ao66xF38tIa9i1FKFhWTle2iz09D7MbH9qjypz0pv
	Keb2q9tKAyI1QpT3GKaNjQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acvsss9sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 03:06:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD104il018617;
	Thu, 13 Nov 2025 03:06:30 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vabhmnp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 03:06:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O/4ssXsjDVhotlatB80mgtxyC/hxkyj0Kko8FIiF2GdY27UkQzEe1DQXyLX3jIW0gUPxl33jPtBwYKPaMQGZB+o30g8vTODdAN0lpjMSLNgAaFf+01irLFybfgI6jxrUweIfLl7S44egzhsOx9HZIgOXrCGo3dYdlW8dfICWaxdqbwlsmA/ImZSdMaEgjSNA4Dsx2XOMbpZJgeCU98FQumNrE2ATamidUX418mnwvSC4zlZ0pIaYgfrwuMETxCoA4JSxfv3oJn6wjDMI3CRZHq9TOsoUa61EhihR69pssoXrr4HetqGEYE0H6JNMhF1x2ATlXjwOB2VlAkqqaaRfhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OQcQe98jzdenx/FwQtRWSGTfo5CAjQz1AJnwBv5h7HA=;
 b=IEd9VM22QN+hA9UCOOQqUyjihhI3y6BEzNKm6MCqcIR/gAQE+OG821VrguXEW10QV8bSPRZburpc/BlXbmKp8xQi6vpbSvzt+bB3XXXi2i5VyJ1/nJmxyjY9Ad7181ZZGxZV7T3pAtAmnGhfdtoZaJEVRmP//9sFCcWE+CYW6pv65oqnRr/KZvUOlCS2kH47bpfE0U3iZ9dubMbSfusSuPAGnHLbvG4yMcjHAtBgL6FZfE267BV5p2KjW10KaLIjAM9s8CQlI/ddvkTl2qRRwnikOnh1BRUsXDs9yipBAeNyBkv+fGcO59lGM58YDS6Yr0pmfJMRojVnuylMVaYaTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OQcQe98jzdenx/FwQtRWSGTfo5CAjQz1AJnwBv5h7HA=;
 b=tatCRhT+QuZxeg9BbAwhu0AqWxf7D5Y/cb3WFJKvEKMK9sLL5GPbfWk6+ShZo1Kj7Q3nWe/sktSn1BseDz66tUMMkDAo17AieH3/Gx4XPLblLLPpY5HRnuSG1L7xQbSXhmMvN/5bSFXfx9JaUPQ7Fx+F9y7jmGK8tAL7K/aL7Bg=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 SJ0PR10MB6421.namprd10.prod.outlook.com (2603:10b6:a03:44b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 03:06:27 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 03:06:27 +0000
Message-ID: <72da0532-908b-40c2-a4e4-7ef1895547c7@oracle.com>
Date: Wed, 12 Nov 2025 19:06:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] KVM: VMX: configure SVI during runtime APICv
 activation
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        chao.gao@intel.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, joe.jin@oracle.com, alejandro.j.jimenez@oracle.com
References: <20251110063212.34902-1-dongli.zhang@oracle.com>
 <aRScMffMkpsdi5vs@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aRScMffMkpsdi5vs@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::30) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|SJ0PR10MB6421:EE_
X-MS-Office365-Filtering-Correlation-Id: 379d7075-720b-48d5-2c87-08de2261a293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a05scHo1YU5iNUtsWmxHc3VQRVlHK2djazRLVkIrWDlMM2VuL0FOSkhXVXpw?=
 =?utf-8?B?NzhNNlRhQXMwSkdNaVQyVWdXZzFveWh6WWNUV0ZFZWtQbkZHVkFQaWs2ZGRm?=
 =?utf-8?B?YnN6eFdTOVVhN1dYOVBjTHBxY3c2OGJydnVjajc3WEErYXd6c2hRdkM4eHFx?=
 =?utf-8?B?MUZNb1NyUlRVdFdLdlhNRmNrS1dXV2hVRDQwV2VwTUZZYTh0VVhmN3lBZzFR?=
 =?utf-8?B?WThqWjFxQ3dCZkVuYmNCbWhPeDc4NFJhL29RWDhGSHBMa05BY1FiQXhhbFJh?=
 =?utf-8?B?UktTdWlvTUxqRnhWM1JNbjJ4VU45QmtKZ1Aya3FkMDFIemJPcGJ4eEt3UkZP?=
 =?utf-8?B?MzkyQlFIS051YUlpTVIwMHFUMVVxcXFaV2NBK3NGY29Pc2VNOXZhVEZhdTlD?=
 =?utf-8?B?cnpvUHhmc0JuVnZwdHF0YklTVFNTeUJFZmFOamxScjdKaitrc0ErUWozUHNY?=
 =?utf-8?B?ZW9wTmVNU2VndllmQWd0S0hLekdqVGJOQjF0eDhVblRuRlhydHBOWTJCZVJz?=
 =?utf-8?B?MFVDZ3Z2SDY4MEFZNnY1dGQ4SG0vMnJGN3lwN2hiL3VDOEl4N3puNDFFSVJI?=
 =?utf-8?B?c0FRWkVwdmRZc2NYeGVNMS8xV2IydkZIZWdhMWczY0JSRmF0eC8wc3I4cDlp?=
 =?utf-8?B?YVdjenFUN1lxZjlTQldWbGR5dzZ2T1pXL2JVeDhsS28rSUE1SFYyR2VKWmNL?=
 =?utf-8?B?NkdxZFQ2YnNJc1J4cVhnYXIxc0RQQWp3eXFvcFppdUFZNmYzRTZQSWlGbU9T?=
 =?utf-8?B?UFFoRysxL1U3WWxGZDQrc3JNd0szMjVmTnR2aXBIRTdpQ1RRTm8zWTBONDZh?=
 =?utf-8?B?MkJ5Q2plY3ExZDFQaHlZZTFxRXFhUXB2empvVmowcmc0UjZ0MzVEeHlnbUVV?=
 =?utf-8?B?Zm50UXBiNDFCMkFLYll0Qkp5aHlsMEhIUVRHbmpNQXNIanBYdEJqN3ZsL2JV?=
 =?utf-8?B?Z2hwbE14T0JBamo3YUlJVVdQSENZWTRkRmRiQmF2a2M1U2lmVlg3cVc4SkZo?=
 =?utf-8?B?dnFaS1hIc1R0NGFnV3ZWSXhsY0h3dDhockpwWXY5Y0V4NzVuMmg5S2xLcXkv?=
 =?utf-8?B?TGtQQy9xbTV5ajVqRVhKSFB0RVkvMjVzUEFGZCtGL0JtY1VmSDQzcXhYWGlC?=
 =?utf-8?B?ZjdEQmR6cXl6amt0bU5KeThoWFRXOTNXbDZKQlZWdEl4RTRCRzhkd3RuWk0x?=
 =?utf-8?B?Smt4c0M5bFc1Q2lySTZYTDArMnNXN1AyMkUzekhWVUE2U29hUTlFRG5xQVRr?=
 =?utf-8?B?amJ3MjcwbFRKRzhDc2ZxZWFLNjN6eVpnZFNGNmlrZ2g5QVY4di92djNoNEhQ?=
 =?utf-8?B?NEFlOHNkSnRod2J4aFZUakxzQnNBNzBTMXd6dzIxenlRRi9tVVIzcTMwSmpY?=
 =?utf-8?B?bU9oRXFrRlpXcW5DaXF0aVVRSnJRMjduZVJKSEFSRTEzK2dzdU5wb3NKL05V?=
 =?utf-8?B?Uk8rN1ZGcmJXT0tHL2F0TzczQ0tuT3dGV1ZKUjdqQVJhYS9tbnRkU0RQcjg4?=
 =?utf-8?B?YXVwbC82a0lZUE5uZm1DQ2N3WlFHaVExNWlPbEZaSVQwaXJOYWdNWm4yNzVF?=
 =?utf-8?B?TTU0c1VHMjZybnZBSmZxQVJMWTZjTzJCK2YwSGNtY0F4eHpHVWFmdjJ1WTM0?=
 =?utf-8?B?MDlnRStNK2tHL0R6MEp5VU91NDc0eUt3Ujk2MUsxOEZXNll1bUlWdElyWWVu?=
 =?utf-8?B?Y1NnNTdRMjJqWmR0cHo5a1pJcE9jdHMyZHlOQVRpNzg0V3dCQjdnTklHWHI4?=
 =?utf-8?B?QmMxbzVMWTU1d3FiQmZzazJFaGNvOUFwMXNpTWtkVWg3RGlndTlyaDlud040?=
 =?utf-8?B?TnI0Y0t3dVQwQjZVdVg2aHIzSDFWMFd5S2dpZEZvTzUvaGthNXpTNVcyWjFP?=
 =?utf-8?B?OURFSmxGTlFycFRYaFdic2F6Rkw0K3l0QzArTTZ5QXJJNkduZU1mNVR5UFdq?=
 =?utf-8?Q?HLkBaUo4UPdD1zPg3SvC0AtDfsHZ4X86?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlEzWGRKam9nbm1lajh4RVZ2V3lpMkFvMDdPSCsvTkhGYlptdjg0Q3gyNldm?=
 =?utf-8?B?Z1prTENRUVY1U3RXQ24vVlQ4dUY2QVh0czJSWUZDNVllaW44Uml5SWUrL0pB?=
 =?utf-8?B?YzNnbkVhMU4yRVRYcXBDYTRWVEl3REVkajFPNGI2TW90d3JHOXkyWjFEWUNG?=
 =?utf-8?B?dHk3d2psVXJCditBMHJuRTltUytiWU5jQVZLc2t1bU9hakQwMFZHWEx3emQy?=
 =?utf-8?B?ei9tUFpxMTUrLzJ5aGZKaUdYQ1BaYWxNQkpYTzZWUXlHZDExZjU4ODF2NlpD?=
 =?utf-8?B?ZDEwaktJT1VicytRYzExdXFUMU5MdiswYzBHWnhHTUhMWTFSWGtxUnd0dldS?=
 =?utf-8?B?T0xYNDF3R3hUUXZQWk03R2l4UlFlcmI5aTcyRzdaVVVWQzdkVGxSYVc0RVp0?=
 =?utf-8?B?ME40ZktPbjRVeGR4Wmd0NjBzVWQxQUJNV1pZRkhNdUl5cjZ6bDdwOTYrbTEr?=
 =?utf-8?B?WTlDem55TjIweDRwVjE0c0F5cTR6VVplbHJOdGRnY25Rd0JsNGFYTFdOYkty?=
 =?utf-8?B?QTU0Zk4vanF4dG1RRDRZZG9tbWJvME1PankydFJKdFR1VXJoU2V2T0doaml5?=
 =?utf-8?B?ZnZmcS81L1lPd1JuSW5IZVdwQ2RlanNSbnBkeU5nY2VpWG9ualNEaWRjeWFZ?=
 =?utf-8?B?M3AzUVhaK3BEMmJtSjdwaUo5RzFEQnFxU25RVWpIUzNYcHhyOU1DVUdnR0M0?=
 =?utf-8?B?NHZVNWlsb0E1UXBvVTVrejlrUzhpUm1YZGdUTktoR0xmUE9wSWw5WHNNRGtF?=
 =?utf-8?B?bndZVmw5S3pjMmxzWVZaTHNDUnBUMlVoSSszTHJDRVJ0VGg3YmZLNlh1VVha?=
 =?utf-8?B?L09pR3ZKRkRzMTdWVVhNa3lQTXNhOVVlRjBTclBEV2p1Q3ZQZlBiVEFsS1Zs?=
 =?utf-8?B?Qm1EMmRGcDl5UlZFRjBYQ3djUlhZVXNHUWR1eEpmdzlSMVRQTWpwOExMSXlj?=
 =?utf-8?B?TzhLQ25WaUVJM2dCWkRBZklpZ2wrTjNTVDNZbVlBVHA0SEkyeWlYajZUdDlJ?=
 =?utf-8?B?SFozWmpHNTNDVnZocWpZS1U2S2MxcW5nQ00vY0hCRnMyaUdLZ20vSW1ZekUw?=
 =?utf-8?B?ZVRWNUZLWVVhcHE5ck1GUXJvZ1FLRmwwSVQ1NVJJM0VGRG5KdENsT1kxd2Q2?=
 =?utf-8?B?aTNQbndZdEJFZmRjNjduNE9id0VPMEdXMTljNE1YbUVKODJJZU96a1NPM2Qv?=
 =?utf-8?B?WktSeUF6MnR2ZmxDTXhoT3cvSWhwUWVWM1pTakpTeUJIT0xPT1htMXZFSU1u?=
 =?utf-8?B?UkE0Nzh4ZWZHTEE1RUl6QmExaEJlQkpiWlZ4dzJabjhFZ1pBZEVOM1g5cThR?=
 =?utf-8?B?SDZJTER5QjNnek1sT054Y05XM2FXYnpOQXNnZjJUYVpta0d6UzFSUzlkcjJY?=
 =?utf-8?B?Nk8vMTgrM3B2MHc2YjhkcHJRL2F4bWpOVXJpL3d2Rk1Xb3JaeFhMRjhEdU5Q?=
 =?utf-8?B?b0p4QlJCMzNmZFlqS1FxVHhaMzJaY1AxRXVxQ3lra2U4TGZnWmpQMzJROHdx?=
 =?utf-8?B?STh3K2QrSXJHK3hpb3pTU01UYVpkbDB2QUU4bXlnN0xuNUdjN0dFOTV2VlBt?=
 =?utf-8?B?VW0rVkgzRVNsTDRvM2drdHdma3ZpaEFqTnEzbWJXVjBJUmNVbXRqRXBKdnVX?=
 =?utf-8?B?VlBIUTJTVWdvWVdnOEJsY3ZPV1V3MWpSV05DaGY3Y1h1WGxVc3M3emkrT0VC?=
 =?utf-8?B?SGozaXBWeXhpQW1JdGtacGg4UTlQZmdCUHIyOTBUV3ZVYmJ2UW5SWDQ4aUp0?=
 =?utf-8?B?aFdIMktkazdLVm9UeFNINDBUV0Z2dmp0bmFya0VnTnN2L0tEd3ZCRlI2U2dU?=
 =?utf-8?B?M3BRQlZyeVZ3NERVNllKZG9XellDQWNkVWRoZU1YRkRnZ0xxdFFNVm1pRit5?=
 =?utf-8?B?b2lMekxYSUhCTEZRYmpsYjFnQ0JkWHlKRXRIRlFzclJFK2lGVTkzZmtIaDFk?=
 =?utf-8?B?R25oN1VTL1RlbjFzTllNSldsamVsQWFKZzNyVnRLRmlkbjRlaGFlbUF1bDM1?=
 =?utf-8?B?bjc3d3dGRkRiTDdkRnVtaWJId09rcE8rL0RzSjhodmZDaXlsUWtRYmc1QTZT?=
 =?utf-8?B?MWtoekFVT2l5Smw5NnpzWEhwdUl2UTdEQjhqSUF1KzJmc3FHSjFtZ3AxZ3Br?=
 =?utf-8?B?U3BYSTNHYUk1ckVWQzdlNmRsUEtYVGJRVngvRkdiNmFablo2MlNyNER0OEFy?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	N7W6RxDjY8eJ0E2+lBu/EQyrgtJrbeJkJiy4IAigXKehBVzO++4fQIQvtIotA3cAkMtmhBVVU6dV0Oqje+qsJXPyFnLCjI5NDwhtBLVeRyN8me80DtyTATWFJtIpOq6yX32R3/EF1wq1GavJtgklzsC74fT7v3C7QW0qnytCEkgL3fjrEFCQXJXwJfKet/TDGk6SweAuraHa1qHI+HxCoSdRMUsWeFa7nuJjf2vAS8G8Vzg8GBQ+JTWtzEmr3WGGg6OPvdWNwCnL5xLJ8ig4Wi/I/vtMPtRqNY2dpiPMCiCcmtycUD/E907HV0aZqvol10DXQ8z0galTfINKwCigCKjZfXTaL7G5nLQqmKygB2bmto0YVGejPfyfQbN4Fhm74jeO7cTpNj+69d+ypm6N5701xKoM6pVsTUof4427Ci78tcxBfENFgT1Nt6iD1RE+4BPh9YgT0Fry/jy6asP54jR5hwVoA37SOXkDHjoyHYPaaT+seyXawDGd7Rmi6AunEA1pytW6UaiVV12WqX7WJYGjVWMhpx3v9x2Oh5DOmVTpjBFotao2GoeycD3Op3x67vZOzVPSEsTJa7XLX+B5wZTM2m/osjcKs/ki9h0biGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379d7075-720b-48d5-2c87-08de2261a293
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 03:06:26.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ROdI7xMjCC9INCEi0FgkoSfpBjxhFLlrG9/ba9cvaRI98KOcWHnjbk5235rKcbiVV3eJFMu0wMaGYjduwhzupQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6421
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130020
X-Authority-Analysis: v=2.4 cv=bJUb4f+Z c=1 sm=1 tr=0 ts=69154b36 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=smBAJjt_rjWSHzKRwDQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: eQOGodf0R8Sgzce-BtyoNj1-Iizyhusz
X-Proofpoint-ORIG-GUID: eQOGodf0R8Sgzce-BtyoNj1-Iizyhusz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEyMyBTYWx0ZWRfX8f1cCwsuzwpZ
 PzPcTFsUrF20+OxNzIey6TU5TK5jIWx1F2a8PHmUX3dJ4D+qqEFPAIfzqKhYUVjJcA6qjU27UdT
 cJ+hXZhw2EiIE5tARiDwiKo43RAVoDx/hwTe4HWJJzqm16KnHcoKnvLwXaX11JKXxxqe8Q6X8o/
 /yNTZwvioQkooD0N9q1gRwffONpv89Cgt54lqKoi6mcp7j52UusfPid6y6QjTpr4FdvT1tWoWeE
 c+8CvtWnNUSMmYA+kr5+2vODzW9ZsXbs0V1xCZdXGKylwbqKN6iKv5P8yEKpj6yiXvGD7OU1B72
 0SbTAdU6CM4cdMNKkuQhy+bmpHeLySXXmUJrlk9UOJqVPgW6zMlUVdciqC7BXNlRk3qRVuQNu8R
 EcKjB5Kf/+abIFTBtwhsTdEL/MJ7EQ==

Hi Sean,

On 11/12/25 6:47 AM, Sean Christopherson wrote:
> On Sun, Nov 09, 2025, Dongli Zhang wrote:
>> ---
>> Changed since v2:
>>   - Add support for guest mode (suggested by Chao Gao).
>>   - Add comments in the code (suggested by Chao Gao).
>>   - Remove WARN_ON_ONCE from vmx_hwapic_isr_update().
>>   - Edit commit message "AMD SVM APICv" to "AMD SVM AVIC"
>>     (suggested by Alejandro Jimenez).
>>
>>  arch/x86/kvm/vmx/vmx.c | 9 ---------
>>  arch/x86/kvm/x86.c     | 7 +++++++
>>  2 files changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index f87c216d976d..d263dbf0b917 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6878,15 +6878,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>>  	 * VM-Exit, otherwise L1 with run with a stale SVI.
>>  	 */
>>  	if (is_guest_mode(vcpu)) {
>> -		/*
>> -		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
>> -		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
>> -		 * Note, userspace can stuff state while L2 is active; assert
>> -		 * that VID is disabled if and only if the vCPU is in KVM_RUN
>> -		 * to avoid false positives if userspace is setting APIC state.
>> -		 */
>> -		WARN_ON_ONCE(vcpu->wants_to_run &&
>> -			     nested_cpu_has_vid(get_vmcs12(vcpu)));
>>  		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
>>  		return;
>>  	}
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b4b5d2d09634..08b34431c187 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10878,9 +10878,16 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>>  	 * pending. At the same time, KVM_REQ_EVENT may not be set as APICv was
>>  	 * still active when the interrupt got accepted. Make sure
>>  	 * kvm_check_and_inject_events() is called to check for that.
>> +	 *
>> +	 * When APICv gets enabled, updating SVI is necessary; otherwise,
>> +	 * SVI won't reflect the highest bit in vISR and the next EOI from
>> +	 * the guest won't be virtualized correctly, as the CPU will clear
>> +	 * the SVI bit from vISR.
>>  	 */
>>  	if (!apic->apicv_active)
>>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
>> +	else
>> +		kvm_apic_update_hwapic_isr(vcpu);
> 
> Rather than trigger the update from x86.c, what if we let VMX make the call?
> Then we don't need to drop the WARN, and in the unlikely scenario L2 is active,
> we'll save a pointless scan of the vISR (VMX will defer the update until L1 is
> active).
> 
> We could even have kvm_apic_update_hwapic_isr() WARN if L2 is active.  E.g. with
> an opportunistic typo fix in vmx_hwapic_isr_update()'s comment (completely untested):
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0ae7f913d782..786ccfc24252 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -774,7 +774,8 @@ void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu)
>  {
>         struct kvm_lapic *apic = vcpu->arch.apic;
>  
> -       if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active)
> +       if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active ||
> +                        is_guest_mode(vcpu))
>                 return;
>  
>         kvm_x86_call(hwapic_isr_update)(vcpu, apic_find_highest_isr(apic));
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 91b6f2f3edc2..653b8b713547 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4430,6 +4430,14 @@ void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
>                                                  kvm_vcpu_apicv_active(vcpu));
>  
>         vmx_update_msr_bitmap_x2apic(vcpu);
> +
> +       /*
> +        * Refresh SVI if APICv is enabled, as any changes KVM made to vISR
> +        * while APICv was disabled need to be reflected in SVI, e.g. so that
> +        * the next accelerated EOI will clear the correct vector in vISR.
> +        */
> +       if (kvm_vcpu_apicv_active(vcpu))
> +               kvm_apic_update_hwapic_isr(vcpu);
>  }
>  
>  static u32 vmx_exec_control(struct vcpu_vmx *vmx)
> @@ -6880,7 +6888,7 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int max_isr)
>  
>         /*
>          * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
> -        * is only relevant for if and only if Virtual Interrupt Delivery is
> +        * is only relevant for L2 if and only if Virtual Interrupt Delivery is
>          * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
>          * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
>          * VM-Exit, otherwise L1 with run with a stale SVI.


As a quick reply, the idea is to call kvm_apic_update_hwapic_isr() in
vmx_refresh_apicv_exec_ctrl(), instead of __kvm_vcpu_update_apicv().

I think the below case doesn't work:

1. APICv is activated when vCPU is in L2.

kvm_vcpu_update_apicv()
-> __kvm_vcpu_update_apicv()
   -> vmx_refresh_apicv_exec_ctrl()

vmx_refresh_apicv_exec_ctrl() returns after setting:
vmx->nested.update_vmcs01_apicv_status = true.


2. On exit from L2 to L1, __nested_vmx_vmexit() requests for KVM_REQ_APICV_UPDATE.

__nested_vmx_vmexit()
-> leave_guest_mode(vcpu)
-> kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu)


3. vCPU processes KVM_REQ_APICV_UPDATE again.

This time, __kvm_vcpu_update_apicv() returns without calling
refresh_apicv_exec_ctrl(), because (apic->apicv_active == activate).

vmx_refresh_apicv_exec_ctrl() doesn't get any chance to be called.


In order to call kvm_apic_update_hwapic_isr() in vmx_refresh_apicv_exec_ctrl(),
we may need to resolve the issue mentioned by Chao, for instance, with something
like:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bcea087b642f..1725c6a94f99 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -19,6 +19,7 @@
 #include "trace.h"
 #include "vmx.h"
 #include "smm.h"
+#include "x86_ops.h"

 static bool __read_mostly enable_shadow_vmcs = 1;
 module_param_named(enable_shadow_vmcs, enable_shadow_vmcs, bool, S_IRUGO);
@@ -5216,7 +5217,7 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32
vm_exit_reason,

        if (vmx->nested.update_vmcs01_apicv_status) {
                vmx->nested.update_vmcs01_apicv_status = false;
-               kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
+               vmx_refresh_apicv_exec_ctrl(vcpu);
        }

        if (vmx->nested.update_vmcs01_hwapic_isr) {

Still validating if it works well.

Thank you very much!

Dongli Zhang

