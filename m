Return-Path: <kvm+bounces-62382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A28BC42467
	for <lists+kvm@lfdr.de>; Sat, 08 Nov 2025 03:05:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEF27420074
	for <lists+kvm@lfdr.de>; Sat,  8 Nov 2025 02:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35ED279334;
	Sat,  8 Nov 2025 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RNmvWBr+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w8kXyg9P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C0D1E8329;
	Sat,  8 Nov 2025 02:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762567510; cv=fail; b=gtW+lUtP75KSHQM2Y4uWqXE5vYwvXeujyeHuQ2eSS9fmhdwSxqKeSgRJBJs2wRNEO3EWkTKzG9uKOyN9Rv/N/lx7OyrbC3oBGOT+ywL3rfyOtNB884xcXsTqNavtF+jM947+TsJ/9SsJq646nQ765+tb3vpP7CZqL3T0zSLVtOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762567510; c=relaxed/simple;
	bh=9cTCvSpJN/1b1vY9xyuqL1ULmlFkB3HvfKjoBnDp7ic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VwnCsqkigrlZdUsgO49eNmOHirFZZNXbsVGan3W1CFZ/Q4NG68x/flIMeURbCB1AXckG69KMFuNacjLMWCxyjNwy1KMpGw8SGD+OqkAJRStqLr5Vln4h/NU7TsA6Abl98YRvSnWiIySyWccaHZx3sroTHz5TA/Na5H8rcM8EyU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RNmvWBr+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w8kXyg9P; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A824NcY011042;
	Sat, 8 Nov 2025 02:04:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aookAkIOQuBtX5DxefvENzjzk4OdGYxadD9KIOYQCks=; b=
	RNmvWBr+pl3Q+JP7W6Y9htADABVA17skapK8gqtvzdRBnZXYAjoOHQ7sZC/oKYFv
	H/eI9c97ILl38rhonzksaz8t/vVnJcslap6hvnAYOEDPNzn6ruXWnbSz//bsc2hF
	H1UcaUIYQl9xT4Cm/NlrL5ji/6OccztwiYeGihxgN+iSsi1KASFtP6GsmdTRFknB
	Bv5HTJI0kybbkaffFCgUHmdaw3nsH9sLw/9EQ1XDBZoGimoyTFNEr+aE907HtT3M
	h1DLrhc8ucNGpJSVn1v7Nm/iyK2ZQV6/BojiaEYodUL1Lh7pxCk1aqxx2z38Fn87
	x/3lXXx7+va/fbZaH+R/Pw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a9vex80kc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 02:04:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A81XaWA012556;
	Sat, 8 Nov 2025 02:04:33 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013051.outbound.protection.outlook.com [40.93.196.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va9rmjf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 02:04:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cR3QSmNjZihXgWIpACRgt09nXVD6S+Hv1NxsjoM1EbXHM9y+mx1vfy3fPWiU7GXXEbX9K8ktCRyKj/AWRgxM5J/u9otBZSzpToAiem2wjQ4NapfTU83fBXcJi8tpmu36voM/aoDcRc/6UkTbnNnq4EUZ4qbnpv4kQFsqMJbXEb+p3rN8fYeZCHT9qw8XW7FTOGGGpedRf75fcTLjAKKS4Z8vQFM3UdbWwNcNpJPp98kWQGMSY4K5qtEslnjWgI+7LftOMSm77WjP7JIqHsqlsZdFSV59yrVfgLEtwS2+7QxguCkYU/qi6KualWvInkmCbnRbqAx6cezHxJrFWMukbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aookAkIOQuBtX5DxefvENzjzk4OdGYxadD9KIOYQCks=;
 b=wHVQ1k9LkzxRn+Ll0+C1Rr/GtHEW49WYs5XPAAkO5/qYLCjH1r237zxM3qWuginmu2rXjYQQEMQNkKf7XUz59voGBOp8yQM8NA+bIuYe23sAaHMxg79Y71US4EGpqNi4x8dHNQ8ypFhlRmHY+5LfIf4bYISA8TbvgYIQuySYdenBovI+dXvGaGGQ8pWp+eEqYJ3EKM5r6fDOZuey1jBbVb4dyqw53NjdEUa0Yw0yLo/nUMDsXy40NXefHJRP+H6P0xYpd4TpUQF4ual4m4kbTW4LHg6jTwfyPTV0ZSI29e0ybFUfsfKtoMPj8HtFD//KXwBQBMJxmReR584PqxNQLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aookAkIOQuBtX5DxefvENzjzk4OdGYxadD9KIOYQCks=;
 b=w8kXyg9PeLR3ZzbK5GRxLwvpWbj2BeOnwjItKiwJU0JfchsHt/5X/pT/EARzlYv8VxEVd8/v9s+AhcwOm2vVForvwN0Gx0jECW6GInTrkYuWY8ZA6MKmUvarmACH8A434qRMoOX0EOlrsqQU5hVsWqGuROYqeU7MI69ZyOf58Qw=
Received: from CH3PR10MB7119.namprd10.prod.outlook.com (2603:10b6:610:122::14)
 by SA2PR10MB4586.namprd10.prod.outlook.com (2603:10b6:806:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 02:04:30 +0000
Received: from CH3PR10MB7119.namprd10.prod.outlook.com
 ([fe80::9b03:ea19:7cdb:ef82]) by CH3PR10MB7119.namprd10.prod.outlook.com
 ([fe80::9b03:ea19:7cdb:ef82%5]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 02:04:30 +0000
Message-ID: <aa7c4db3-d6f5-4ff8-8d63-1959d081c9a4@oracle.com>
Date: Fri, 7 Nov 2025 18:04:26 -0800
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
 <9a54bd8d-ea42-4c9b-afdc-a9ae3c31b034@oracle.com>
 <aQ2jmnN8wUYVEawF@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <aQ2jmnN8wUYVEawF@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::10) To CH3PR10MB7119.namprd10.prod.outlook.com
 (2603:10b6:610:122::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7119:EE_|SA2PR10MB4586:EE_
X-MS-Office365-Filtering-Correlation-Id: 505ebd15-e5e0-4184-476b-08de1e6b2729
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VEFTdVdpdFhaT3ZFRHRqK3ViZUFXQkRqT3lSSmZUcytJZkxka0FDVjdMWDRa?=
 =?utf-8?B?cUd3NmQwaHVpeG5uUkxTWEpSbldvcTlJaUZzUGxMdTlvWk1YeFhEU0Z2RWJ6?=
 =?utf-8?B?bFpEOE9tRGxWQ3JMa05DbHkzMHBQS3FielhaQmYrYlZMeGQrVWxmelR6TktM?=
 =?utf-8?B?cWpCWVI4aUV4SzRYQ3l1UGFmQTlESlhLdVV2cldPMXhnbDMxdlVtam45N1k3?=
 =?utf-8?B?K3dzOEl0REZkYi84TTlRUEsrNkpITjFZUktqNnZ5anAycEZqUmJtU09UOFN3?=
 =?utf-8?B?RnlZRzhGd24rb25qb0NFVDNYakt5aER3MVJuZUtrYmxnTWZNMHJnR2tCNTFW?=
 =?utf-8?B?SVdIbXhhYTlJanpUUWlhM1VNdFRRWGJzTWw0SkhIbmVwN2NFVm42QjFvV0J3?=
 =?utf-8?B?emdoeGdqR2Z3c0UyUFdYMlQ2VzRUV1ljLzJsb3FVM1ljUTBKMUNmaFJlY2cr?=
 =?utf-8?B?cTNWT3A5WCtva01rTUJiUUJQWmk0TExKZ1hpRVdXTS9ubmNpNmVPUnFmenpk?=
 =?utf-8?B?SnlTejU5UWlPaXkyaE1Rd2hVc0xNWnB6bkxwYmJIa0thYTcycE9qdGZ1WTlM?=
 =?utf-8?B?S1JDNDhsVzFnTzN0VHcwK0JQdFlReWhkczJ5MmkrKyszMUM4d3JPcWZMMmRM?=
 =?utf-8?B?RFdnRmV5aE1KRWplZU5ReW5BdXpIZDBUa3U3SWhKeTNndzg5VWNpK3FyZWZl?=
 =?utf-8?B?eDhSTXV6MmpDeVY3NUNKZHF1WjUxTWEyOE05THIxNUtKcE1yVmtVUDNqT0sx?=
 =?utf-8?B?ZWcwRUhlOGV2TU1yTWJSNWVaUWRIeFh3eWJMMm1NVmZUdktvZ0cyOURXcjNi?=
 =?utf-8?B?SXpuTUgyaWcyakpKdHR0eWoyR2VBSUhGV2EwbHZMMlExWm9PVGlLYkRTMzZx?=
 =?utf-8?B?cVphOUVzeU04aVNKcUhlSjJxanF4NmxiakVVTjRiSnBOYWs0WXQ4aDI3Z25B?=
 =?utf-8?B?cWhLTHh3ZXVEaDFFTEhteFpSZmZCTXU1bEpaMHdBc1lPUEQyVVJTeDllS2pq?=
 =?utf-8?B?d1liSWZwaGlReXdHQmFyZ2YxWitiRTh5VGYxNHVLOTd5RzZ2OGJXZGRGb0Nk?=
 =?utf-8?B?UkVEbjhwemdCUEUrd252VU5JelZpS1k2NWMvWWRmajR4RVhQS2poL0xETmp2?=
 =?utf-8?B?NHBSVGdSa08vM2Nhc2YrdGYvMlhnSVJmaS96Ym55QjNSampjenIzeWRxSHJZ?=
 =?utf-8?B?UWNwazk3c3RQVXlJcDRMVjI1Q1F2b0FHSnUyOFhVN21pMzVjd1MwUEMrMllS?=
 =?utf-8?B?ZWI4Z3N1dFZ1Y1FaSWZrUWFDcy9ud1I1QkFBczY1QWt2cUY5eUtYUTBFUEtB?=
 =?utf-8?B?OTZybFlVeC9WcVR5bGhBMmJIaVBvV2dmbW9sdHowY3lnVDVCSURKSjRJK3lq?=
 =?utf-8?B?aGx5b3JTbmR4V2JGUmhoQkE5OUNsbmVZdlUyWldBZjVoNmcrSEtuMWx2ZzA4?=
 =?utf-8?B?a0FKMlA1ZzJ3eWhraGlxTWZjMWxQanlGdDJOZk1mUjJqbnBnaTI3Q3F2ZUdI?=
 =?utf-8?B?cUNKMkl5SU5idHBIazBBWHhIeFFwZ0JyRjZDYzhmd3loQzUvb2NDeWxnRnVO?=
 =?utf-8?B?S1hUV3NOZVAzSkZnd0FoalVrMS9GbFdKc3JVd1doNE9wZHJ3MHpuK2lIQnhL?=
 =?utf-8?B?YnpYK2NNSTBuN2ozTVVLYVVtbXgvNjZ2dU9kTTdCWjVZcm81UjdOWnBPd2xK?=
 =?utf-8?B?SG8zQ25meUZZanlMbVFHWTY5Ymljcm8vM05KZFRKK1VjV1VWM25OYmxxVzQv?=
 =?utf-8?B?Y01oY0N2UGc4dC9wWmxwcXEyWC9zaTVNZC9xSWNUVnpaNHA4MFBiZUxQemo3?=
 =?utf-8?B?djU5aHVCODJCaVROeWZXSDEvdjdzcm9ObW5FNzl0WC9lMkEyQ1F2ZE90UWp0?=
 =?utf-8?B?VWpENTExYkxMUzRMUUE3SHJIeGE5aWtnMm1FSlNhTU9lcm1VR3R6TlN6cVY4?=
 =?utf-8?Q?O/H14177EsK80SAj7VSLyV7mHyYAH1RD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7119.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVJkWEhEY09pa1p6T3l4c2tUUWN1L1EwRXBtSU9ZRjdSTHExRXhrbk9Fd0Mv?=
 =?utf-8?B?OU1HZlJOVVYwck1uQnBKUks5Z0cyWGZOM3BLUlc4eUdBUWV4UmJIZlJScXFN?=
 =?utf-8?B?MHJRT2ZUOVZxejRKQ01VMitBZ29GcldFTVhod2UvYkpQcDR2VVphSjNBeUZI?=
 =?utf-8?B?N3U0K05sK3UzVVVmdTJzL1FCSnhwZ1hTSjU0ZGlDeHF2ZU5TUm9YTS9MaVg3?=
 =?utf-8?B?WTFRSGVaRTZVQThlcnJvMVljVXZybVFXYWZ5R29sc21QbFhyUG9hUmlpd1lQ?=
 =?utf-8?B?ejdhNWpWOTJuU25ZWFgvenY1aWpldVA3b3E0YXMwcUpFUFB6REtpSUFDZUxQ?=
 =?utf-8?B?ei82SzBiZGF4UFRlaWhSRDM4TDJ2OHV0Zm8zQUJhSzEvWDk2aDFZazRlTnRt?=
 =?utf-8?B?RDYvai9mT01aV3FYam9ZNktnK3B4LzlKRGxVaVdSWkRjYXRxWTFEZFZSSUJn?=
 =?utf-8?B?OWpqUXNsV0t2bWFQWFFadG5Qd1RrVm4yQjNhQ1RXcFFMN1B1V3VFdXVPSFNF?=
 =?utf-8?B?RUphV0xIaVFhdlhFMlVyczA5eFRLUnZpRWxUNU5jVzNGLzFDMGxrZldHTlps?=
 =?utf-8?B?c2YxOFBQWnlJOEF1dmlYTlRoaWMrS0FTN3ZOSGFWSk1ZTnVNN0Z2c2tmdVU2?=
 =?utf-8?B?dXRyVDdKWHY1Z3hocDJkMDhVZS9EYWNKYXUxQ2VxRlR6QXZyQ3ZSOEVhN3I5?=
 =?utf-8?B?Umc2MzVRQ3R5OWtrV1JkZDZRdEFnc3VoUlU2SCt4MnlabDVVRGJteU0zRHI2?=
 =?utf-8?B?UGNKdTdRUXBaekN0K2t3MXJUckV1L2FtQnN5Y1FuSFZxUDVRU2xPakJlYmlJ?=
 =?utf-8?B?SStncHErbW1lM1JUNjBsUzJwallIWER0ZkRkYzNhYk4yL2Nnb25DTGFSbld6?=
 =?utf-8?B?OU5iaE80SUJEYkdDa2VtWlFQbEswQ3phaHZnNUVjeVUwVUhhcy9JTWNmY3dJ?=
 =?utf-8?B?RFBBSFloVDlFZ09HeC80Nzk1RXdaZVZKVlRlcTJWcmhydll3UXJDNWJKNUJM?=
 =?utf-8?B?R3g5c2gvdlltVTcwRWJyK0REalNGNEdicGxuZ1NjMXRSeW5SaE5WQ3pOWlpQ?=
 =?utf-8?B?WlU1YlAwOWNBWDlyMEZXcUhpY1QxSGQ3VUdBT1JVNDEzcE8xL3R3REVPU3d5?=
 =?utf-8?B?NzB4UGU3SmVuRTE5MnoxdCtDbnk3Q1lVbEFjY1F6eGh4OGRRRXA1Mkc1d21D?=
 =?utf-8?B?YU5kcWlCNXZXbk1IS2U5YzJrMCtiN1FJYTdja3dVckxoN3ZFbGE1dHlwRGRl?=
 =?utf-8?B?QVU5MW9uMFF6eVhMeUxnYTA5VlZDSFd6d3lVUmpBcVJRYmpVV0NnM0s5Z1lu?=
 =?utf-8?B?ZUNYZ1ZHZXZmamVIMHVqckRzL2swaS9jOGI5eEY4NzhzUm85SjFzMDNQMk5Y?=
 =?utf-8?B?ZXh6RXVwN3pFdEN5cUJkbkk5aW5DQXBQZGVCajNxSVR0WTFFRFVqNTZUcnlr?=
 =?utf-8?B?OXRQWDVrNkJ0Q3RQNENTRzkzOUpBK05zUFJDaG5qUmxZTzVKVlJtaTBCN1Nw?=
 =?utf-8?B?Qk1keldXckdFQWpjN3d4d0UyS29DMklscTZSTDYxTTZPbVpiVG5yOWp4VWlO?=
 =?utf-8?B?d0pOTHJtZXJ6cHplaU5ZWEJrTGlEcE5ab0kvTzNiVzFScFdWclZFdlRKK1hH?=
 =?utf-8?B?QWlEeCtCbVJTQ2ZIS1Z3NzE1bytyaTdqN0JnLzhiMThxTG1jWGhiTFRXeE95?=
 =?utf-8?B?SVdDd0gvZENjM0VuSGdBZFllMmlaQm9hZldLTjdldldvV2tpZmpjeTkvWDlD?=
 =?utf-8?B?TDY5L1U0L2F5ZlZsQW1MZEFiZWMySDY0UFBwaVMvbXplb2J3azQvRDcrdndn?=
 =?utf-8?B?YUhUT0VKemVTRm44dXM5ejlkWUJVYU15N2EvaFQ3RGdaTnUxcXAyMzExbWZ1?=
 =?utf-8?B?aHlOaDgzdjRheHU5Yk9OSVpucysvTHBQVTJGLzJ5Q0IzdTl1MkdJT0l6aHhw?=
 =?utf-8?B?NTl0U2RQV2NXVEJKS1kvREZqR3RRdVN2eTJLREhHL3RFV3UyU215Y1RZMHk5?=
 =?utf-8?B?bm9KWEFwbmtYRHBwQkpMRVhwcXFMVVBMSVlDOFVpR0M2YWlKL2hDUStqbFFS?=
 =?utf-8?B?aVRhY2ZmYVBlaHVEZVhXaXVMZWlSamV1Y2VwRmdUMFhGWXRyNml5OHRGVVdS?=
 =?utf-8?B?R0wrQnBGSnhtZmpuTmRkQTMrQlFyYlFhMmlSNWRQNFBmeDMxbVdFYUt4eUZ3?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VmePSncmn7YlV8jCstkFTUoQQ+UAJCtaywOYvyiKPCrXE91kSYjAcpFQf9wV7t0vRYr7RNYSoYLz9OxBP4U1+MfPacAr3RpybX5fr8VEpDLVNNurIEVEeuAYdf1EzcOk5ZhsBT2LTnN5XtY8+qjCiY8Qzd/iJmiWCjLRPILIisL35cFjz5DvfQYnJpxO2QisPBrnKiU7tDWZZwQ/OkSUtXxdR8ZvD2XyllDGtsx7/YocinBidLOBrD6Dsq0euRO+MjKb4zUuPC0hEcBGF92PD6fB9JYT9XXRh2nPlEFmBC1RVwlzntDmFq72KdYtR3eCnbk5za/A06p45TsgSANEO2EHeSIHp+mrCKRtO+HGa3dUI15LePc9YuTFig8MSOioeL3G8iLRl5LHz7uWfNF0AX7S392H61AGMCeLI8kZicl8Uojo+M7IJSpP9Et9Rh7yJOvVf52na6LXu8HgTg9x6cihoFCmqQ0zrooXfXzQDeMricgCqwUzD/K8pxeUo+ck0LVsms8cMcZ3WEOaX10z9ABg0l03hrat6yM7bm6BQQZYmwpthlexbmgtljipQmS5wytraRjN8v/CRBu5gMLBgzAKKQPbAHHY76oEd0iPEdo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 505ebd15-e5e0-4184-476b-08de1e6b2729
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7119.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 02:04:30.2735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEBWNdAXX45qVmaLkSklE3Zrnrzz/uNqrAcUehcAxM/kNwLdRF5KBS5/ZNo1W2kMG7J4vBy9yTsgS4Cv97FGVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_01,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080016
X-Authority-Analysis: v=2.4 cv=Ab683nXG c=1 sm=1 tr=0 ts=690ea532 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=ruhemXLR16m5hBcemnMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12096
X-Proofpoint-ORIG-GUID: StiWU5xHycmRN5j28blXe-4E-7rg2RJy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAxMiBTYWx0ZWRfX55xWRF1yMXK1
 T+jWA3EFQFzHgPfanjMsVcOq0f5B8RCBsk5+rTXJ8qygDNL1QeLthszlV9Thxe15mjJ2qNK8LrX
 VRwWuqteL4iUvgsMENFIzPbiUrUAa3okDMD+6PUAFXDMuDkD/RkMcaRj4hyCyAzaiRI+9H0WlVi
 Ai5960P6/njO7/na6RwWdz15ytjENhEw47inqdN2CER36fArZCd5TNXKeLD9V+EewAwKc3BBeht
 +ZxKBsvPkHnxNTFkYdi58JVgfrcM6LULtFrNg57Pt1knWUI04TkAXrvkZV5wdYc9F8wrOfxHy61
 dL64ES+06KLwjmI1ajhoglXqDs9JCZ7lA3x7inIFgSXh099zgu6oSg0jd9S3mK5iJrOrkoroFUm
 vRtU42k7mjXyeWdaJfzP2uAwAfAKCac5xodPwvE5CyZgggi8icA=
X-Proofpoint-GUID: StiWU5xHycmRN5j28blXe-4E-7rg2RJy

Hi Chao,

On 11/6/25 11:45 PM, Chao Gao wrote:
>>> Why is the nested case exempted here? IIUC, kvm_apic_update_hwapic_isr()
>>> guarantees an update to VMCS01's SVI even if the vCPU is in guest mode.
>>>
>>> And there is already a check against apicv_active right below. So, to be
>>> concise, how about:
>>>
>>> 	if (!apic->apicv_active)
>>> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
>>> 	else
>>> 		kvm_apic_update_hwapic_isr(vcpu);
>>
>> Thank you very much for reminder.
>>
>> I missed the scenario when vCPU is in L2. The __nested_vmx_vmexit() will not
>> call kvm_apic_update_hwapic_isr() unless 'update_vmcs01_hwapic_isr' is set to true.
>>
>> However, can I remove the below WARN_ON_ONCE introduced by the commit
>> 04bc93cf49d1 ("KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2 is active
>> w/o VID")?
>>
>> Now we need to call vmx_hwapic_isr_update() when the vCPU is running with vmcs12
>> VID configured.
>>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index f87c216d976d..d263dbf0b917 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6878,15 +6878,6 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, int
>> max_isr)
>>         * VM-Exit, otherwise L1 with run with a stale SVI.
>>         */
>>        if (is_guest_mode(vcpu)) {
>> -               /*
>> -                * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
>> -                * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
>> -                * Note, userspace can stuff state while L2 is active; assert
>> -                * that VID is disabled if and only if the vCPU is in KVM_RUN
>> -                * to avoid false positives if userspace is setting APIC state.
>> -                */
>> -               WARN_ON_ONCE(vcpu->wants_to_run &&
>> -                            nested_cpu_has_vid(get_vmcs12(vcpu)));
> 
> Thanks for testing this.
> 
> I think it is fine to remove it. The warning produced some false positives when
> added. That's why we have the vcpu->wants_to_run check here. Now that we have
> new false positives; the check is less useful than expected. But let's see what
> Sean thinks about this.

Thank you very much for the confirmation.

I am going to send v2 to present how it looks like for Sean to make the decision.

> 
> 
> A side topic:
> 
> I am not quite sure how vmx_refresh_apicv_exec_ctrl() works for the nested case.
> 
> If a KVM_REQ_APICV_UPDATE event is pending, __kvm_vcpu_update_apicv() is called
> to update VMCS controls. If the vCPU is in a nested case, vmcs01 isn't updated
> immediately. Instead, the update is delayed by setting the
> update_vmcs01_apicv_status flag and another KVM_REQ_APICV_UPDATE request is
> queued to do the update after the nested VM exits.
> 
> So, __kvm_vcpu_update_apicv() gets called again. My theory is that the second
> call doesn't update vmcs01 either because the "if (apic->apicv_active ==
> activate)" condition becomes true and so vmx_refresh_apicv_exec_ctrl() isn't
> called again.
> 
>>                to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr = true;
>>                return;
>>        }
>>

I felt confused when reading the relevant code. This is equivalent to NOP.

It requires a validation whether the similar similar symptom is applicable to
this piece of code. Otherwise, many VMX APICv features may not be configured
properly if we toggle apicv_active at runtime.

Thank you very much!

Dongli Zhang


