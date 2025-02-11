Return-Path: <kvm+bounces-37926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E9BA31865
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 23:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43584167C72
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 22:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAB6268FC4;
	Tue, 11 Feb 2025 22:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yuvk+BjX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b1lwvmun"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC2A267AF0
	for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 22:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739311782; cv=fail; b=lCIibsrJpcDZc/H2K2ae4IjsfAF3nmLg2mrYLkEbxF+Ux+qEaGFuyOFQYVrzNPnikwrRVoZzSX2EC/H+eoZn9O6oPvhzLy+mO6sy7j8k9Cf+xk93/+Xl+HhOqLfLUtSkWvDbDl+OJGKlh6p4PN0qT73+pHCAFjsHjVMTKxGSObQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739311782; c=relaxed/simple;
	bh=94jUKE4kTiPjh+6jzXtDz48uz2xEaFrAW1qLqanX0ag=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CumLg9cn/8ogSRb4ULDcv+R+ado4yMdP4kLYFWxjVroHdrMGO8WrcGj1DCBRmKesbtq49hzU3a8uzGY13QrAFp+C126eh/6AJp2iUd4V59psTex60wUS5/1CFsxu5PTKffrwkLu/KjYDXoTP+1DUWN8wpRvniKhhP0wwNg/vmMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yuvk+BjX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b1lwvmun; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51BLMUhu010977;
	Tue, 11 Feb 2025 21:22:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=uYZAkeV+7iW7Mx3/NW8QJtrcW+aN/wnJSipF356yLgE=; b=
	Yuvk+BjXBDutcoGevTT3LqwG+zpryutznQtoS5FPyD6KrUEGnInvj1+bGT3H0I06
	b7IeqiPzcr1wr5Lj/yLa2SUOG+05vbA742LdA/9g2GTQYQ/KNXP+jAU+ATdf6miT
	zYVQM9Is0ohNsHcfNfS1XD7rGjU6mk4Y/uMg4SNEgqJWtqQGZ2YX3MSCzCMyRFP2
	GFRZniQ/JBZgZFpR2bD/BHWujk1SPo6OaeBPXQ46rFJfU/ShexknElKNA2ryb1q6
	TmfJT7XD05x5gQJyS1cBRMDF9f858vBSP3eIwOhsrK+Q5V77kS1ynd2DZWivjdKk
	F2KItpXI/BCGe2uy+WEvzw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0q2e4vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 21:22:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51BK54mV012414;
	Tue, 11 Feb 2025 21:22:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq9bwt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Feb 2025 21:22:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=emt4VdjqSDORe0k7BA4uUlyM2AUKO03NHQ8xlc6ZcjqS1sjFpikaGIzsQ3jkJuNPMOrp7zBZ8B0lBMON5d/7pb25PPhj2FM55UuWpEOoohVxgRgC64UyEFByD4fm4dyTpajHOidgQsRGqehwwTq8BxiNxT9ZecLLKoxoYMSB2W+M9ffZ4kc53AkTHU+y/F6gd9sZyENbVkSMrWFZ+NTQYplwMhReQHmlzCHBTzySqg7yGuh0FUlYnjE05Y+outffbVswmghJMa5FCrnV0cfOnkiziuuntSOGci9IPxMj3dYu3koteMyAOo/B7ihxwJnNC7plOYzoHut7ni6hRWRMHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uYZAkeV+7iW7Mx3/NW8QJtrcW+aN/wnJSipF356yLgE=;
 b=oCvMpYQIVEZoGg704VqSQ1BO+yP9QL+Rfv5LqxuQCro86q3gy7R6FaPBCqawYLYj2eSmT0MjzTh9oYAaGqG3dFBR3eopDFEk+ORSGwm4HkY5SnTHnLOEPTiXMKnL0fYji3sFlT5+uRDKg0GrW/uGwgEV49R6SSOb1r3XbH39DroeoP5gfTchvVMBXpq8z2Yw+w39nzoVoxbWfclP6dqmpd89uld5qfRN7k/wPQZJ0T6HC6uIg4oVG2M8VnL2nTL/HM2qVgdxgFLHm3p+L2Fv94QdAL1XN8mlZShsQZ5B08gUp2CSIWYFBubwpnQCN/udBdTnJN2SCmIgUuadYCGUPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYZAkeV+7iW7Mx3/NW8QJtrcW+aN/wnJSipF356yLgE=;
 b=b1lwvmunVAg1lUKnRjU46r6nMESRgf5CUs885wzcdC7vyOnC1owO5oXMCrrox8yB2/delz7lgM43cviecbQNGbGIOT+0ufBwN5XyLy5ZGJ5wp0g5rrWzVwvhLzLqKC3i3PwwofvmTHpDajaFZgVWB/eGHNhgI107wXPnvKl3ra8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN2PR10MB4382.namprd10.prod.outlook.com (2603:10b6:208:1d7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.18; Tue, 11 Feb
 2025 21:22:43 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8422.015; Tue, 11 Feb 2025
 21:22:42 +0000
Message-ID: <6c891caf-fbc0-4f5e-8e21-e87c3348c9fa@oracle.com>
Date: Tue, 11 Feb 2025 22:22:38 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] accel/kvm: Report the loss of a large memory page
To: Peter Xu <peterx@redhat.com>
Cc: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-4-william.roche@oracle.com>
 <Z6JH_OyppIA7WFjk@x1.local> <3f3ebbe8-be97-4827-a8c5-6777dea08707@oracle.com>
 <Z6Oaukumli1eIEDB@x1.local> <2ad49f5d-f2c1-4ba2-9b6b-77ba96c83bab@oracle.com>
 <Z6ot7eVxaf39oWKr@x1.local>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <Z6ot7eVxaf39oWKr@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0053.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:659::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN2PR10MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d734e10-6b3c-4413-c3a5-08dd4ae2383f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3I4NHNqcjQ5QkNXbmdxZjNFcWpqL29aNy9nc0ZCSWJkVEYwSVNENFNGMnhB?=
 =?utf-8?B?dTZGTG9ZQzFVR2RSR1NGdTV5RFp4MlEwb2tFWVBsaTRzNVRxY29NQ29TbVY0?=
 =?utf-8?B?NWdvSmRnUC9panplZVBUZ1ZCbFFUMmJwRDRCQWZ6WlpvYlF5TENoaXFNMXFZ?=
 =?utf-8?B?WUFUSzBwV2FyeE03Tkh6cnhtbVhSZVB2SmhUNTNGaUJ4Ym5CeGNCU0F4TVNQ?=
 =?utf-8?B?cU1BY3FFY1psbGNHWkh1Y2d1TUQ5Uzg0N2g5OWx3WDFTM0VUMHNDbFBtcVdH?=
 =?utf-8?B?S01jL0p0TkJ0NHFHSmtwYzR3WUJTeWN3ZGpnYlpmQ3ZNOWVjRkdWRmRZMHRi?=
 =?utf-8?B?K2g3NE50cyt5VFdGVm1BZVZFSnhhWGF2b2NNKzBGT3ZrUGhsUTZQTkNlZW1j?=
 =?utf-8?B?bG1KM0h2ai8vN3NmOHZuSUJSTVU4VlhDYXZnckRPOGNFRUNBSm9KNDRwQWxI?=
 =?utf-8?B?UC9IOTZFRWpqbkJrU2Q2WiswSys4SytSNEtCRG5nMk5JOUdXQUh0N0w4V0g4?=
 =?utf-8?B?QS94NzhWSHFJWkNIYWxHVFhCZ1czcGkyQkl5bUk2amFrbWdMdVFHYWhybW5y?=
 =?utf-8?B?ZTRTL2JwLytjNTdhbzZlbGpobzNVcmNsRUw0RmEvZDV4dXBBQVpEazdQRkFV?=
 =?utf-8?B?eXNZeHdpWUtEZjBMSUtRUkN2b3MzdzV5YXl3SWtZQ3ZmVE04aWJwN09iVWM1?=
 =?utf-8?B?VVF6S2lkQVUzVU1Sa1NoM3BQYlY0UWExNkdkS3lWUkMrMk9RdHRWK3l5MEw0?=
 =?utf-8?B?c1gzZ0g1T1dpajlxWkZ6b3R2b201STdlb1FWVFpPQXRDdU1GNm1SM3lRaFFr?=
 =?utf-8?B?RE1nNGFLR3hTY2N1WlJsMW5vSmRVTnVsSWZBM29aVSs3QjhraWlnMVhPcUNm?=
 =?utf-8?B?NGswUm8zL2VhMTlGOEg3NVZISWVNdmJEazN5bU9pc3kveldNL0JYeW5kUENj?=
 =?utf-8?B?d1dHcXd2UWtxSllOckNDNEtSTXhOUUdRbVI1c00ySEdZWWREVnlqazhZc0E2?=
 =?utf-8?B?YWpTU2IxK0YyQjRIL1hvbVZhNm14Y0toTmcwb3JzbnNYU2piUUFVdVBkN3VD?=
 =?utf-8?B?ekUwcjNJK0FRa2ZUSnVMdWN2YWFEVkFuRmtmdlVjcjl2bTNIUnF3TW5PYjFa?=
 =?utf-8?B?UCtycFVLWDNleWtiSFY1ZmtaSkhKeml1MmluTjM5VGhQZmkvSGY1SzE5UzN2?=
 =?utf-8?B?T1BRWlZPZjc3aE02RkU1SWZ6L2RCcWZlcGh0Qlpxamx6S2xjTlFKQVNNRDhK?=
 =?utf-8?B?ODQ5VlV2cHJXamF4ckZ2eFl5U2Ewd090RUtCRVB4ZVcwb3V3bGZvSzFpeVFV?=
 =?utf-8?B?QlNWR3lFdTlsZUxXbmUyK2w0SE1HMlhmL3lzMEVpQnBPQlNTc0pTckVqTDdz?=
 =?utf-8?B?bEhUU3R4SVh1VXNVOVZhWENGbzRUN3NnV3M5dVhURGtJSXdrenR2UjkwSnNZ?=
 =?utf-8?B?MThIbmdMQjBtU3h6b1F0N1NMcHBPMlNQdVhqSFEvZlliU2lNb0c3MSsyMHRa?=
 =?utf-8?B?NG5qeUh6aW14MjIrUGdnMC94RzlCa0x0N3RIQi9DV2c3QnQxSEZuU1NnRGR3?=
 =?utf-8?B?elBoeTY0eThIRDc5ZHFINzlGLzZpMGxLejExZVoxUzBvQm1tOFVVVmRnOTd6?=
 =?utf-8?B?RGZJbXo2Y3U2SUtDbjgwbSt2ZmxrRTBVdExOUFJSMDFHMjRXL1lWWEU2K3JG?=
 =?utf-8?B?QW5yN3FETWpLb3BJM3FEMFYwam1MN3l3OXkxZ3VZNDBjMm02LzRadGt3MkNC?=
 =?utf-8?B?VXVoQ1JBcDd3djVvUjVqZUM3bzNHUVVKUXczb2tnK1F4VW90djZsUDJ1ZlR3?=
 =?utf-8?B?M3JTdjRQdFQzVXB6dzlzWDVNalY3blJuR0VlL2dsOHA4RTlJUzh5L3M1eTNH?=
 =?utf-8?Q?/F8suKt4mNzPh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qmk4T2FYSyt0dThFNzJqU0dtNURHU29meWJROXkyRlROZGxSSEg0dWNLRHg0?=
 =?utf-8?B?a3FackIrd3gvRG4rZUFJY3A2Z1oyazIzMVRHcTZiRjNQOFE1dWJwa1VLN2Nu?=
 =?utf-8?B?TDJ0dUMrY21Rc0FSZUF0SDIrcGhac0t1Kys3YVlzU09jZEh4aEhleDVwWFRw?=
 =?utf-8?B?QjdydFB4TzF6RngrRm1La081UFJzQkN5aGxEZjQra2I4dnJwb1BUZ1JWYTRh?=
 =?utf-8?B?QWQ0dlhZU2IwZWRVb0N0SXNJMDlKcU1leENmTENxbWNKSFNodGpjSXdFM2Zo?=
 =?utf-8?B?MjJOT1NFRXVkZFlEMVUrbFNsQmZvdXFVV1dQYjMycDhkUCs2NlJ4eHVZckRI?=
 =?utf-8?B?c0drRGI4OE0wY1l2ZFphR0pPMTJRQ012ZnlsV1JFd3F0bStHVW9yQkhJSUVF?=
 =?utf-8?B?R0VUZThXR1ZSSlBQU3lBTkhmN29GT29pd1ZOMk1DOVpwbmxPTG1rakhoaHFi?=
 =?utf-8?B?Y0t2MzVIdks5Vy84Y2Y4ZEZSTzJTZWxxeU9OM2l6Y3pjWjNCS1NLZXpwQzFn?=
 =?utf-8?B?LzQ0bitpNlJzaG1JSEp2SnZKYUNzdTV6YSt4TTE2QWJ5djh4WWpXamx3alZs?=
 =?utf-8?B?N1VLT3NuSXE2amx6SElLaFJPQ01TMFRWNkViamxpakZsdHRFSHBDWkRRejNo?=
 =?utf-8?B?YUx6MEd1eGtDOEhOWXB0TEpvZnFxWDlxZWdtdEc2d01JV0ZHMDhwN045eGY2?=
 =?utf-8?B?LzJsK3dyVUVIdlA0Q2RxS2s1VnBVaHNJSWcwOW5ua2piZEhyU0FoK1lhbTAx?=
 =?utf-8?B?ZmRTVjlVNlpjdG80M3h3TE56eGZMdFVLOEF3Wm52VlV5VFF1UzJYSGtnNUhi?=
 =?utf-8?B?SE52VW5FRDhRVzdkM1RVSnRTVHBUT2FOUUo4L0hhOTlBakEwM1V2VzJONzJp?=
 =?utf-8?B?TktXd1lkb2lTWC85azdORFdYTDN1Z045eFhoMkZFZEdTSFFFRmxOcVoxOTVi?=
 =?utf-8?B?WTFQSDJQKzg4Q3AxNXNGSFB4Zi8zL0hIVDJob1ZlR2kwaU92WlV1QUl6VFVh?=
 =?utf-8?B?b2VLdXRmMWtPZHIyM0NqTE56SEFGdVQ2bG0ybDM5Q0ZkdzJGd0lpYTNzOU1y?=
 =?utf-8?B?ZS9pbnlaUkxOK2hQS2pSQUJLMk56U096NEtCWHNkSks4TGR6SGZiSTJNMTVI?=
 =?utf-8?B?NDhTT21udDQzZTBIR1VIdXlJOVE5aWFlY1hjckRZZ1ZobTVUUmREM0kwcVRi?=
 =?utf-8?B?UEdQQytoRTErWFNSa0JIVkNtTjVOd1dvMFRFVFlWZXpLbytrNUhObEljTDA2?=
 =?utf-8?B?N0FoNXNaZ3FFLy9pUDhPcTkyTGNHRDhObHBtRkhXWU00Y25YY1hPVmgxQ2RE?=
 =?utf-8?B?NHdkLzV2YWVrUzlhMjJzL08wbC9GemtZOGpSVTNONDU1MEtRSG0waGlmSzRL?=
 =?utf-8?B?TlVYWFNUWFlKamJvTHQxcS9JWlFRK0xIOTFmVWxUaDFaN1QwNEo4aGx6bzE2?=
 =?utf-8?B?cklPZmZlc2RBaEk2K3czWWZ4SWlMaUNURkZCZFhFWHBVVWQxbUlGUyt1aGdk?=
 =?utf-8?B?dVJvMkdqZWFXNkxIUUw1N3pkRHE2ZkhyQWVQRkcvSklTWkJKc05teVIxL3Va?=
 =?utf-8?B?RkQ4TElXNkc2UWM4VWpXK3ZnMmVKUm5Cd2N3akRuM08rTkhrK2dna3lQUlU2?=
 =?utf-8?B?RlNOYUYwSDZLZDNyNGtsSGRuV0NVMFRXRFR5L3M0MFRpckFFdTRya1krZGtG?=
 =?utf-8?B?Z2hiSVRjUHpOMjZBT1UxMDR2UnVZNzFEZTRQamt1anYvT3AvYkQ0VEp5TU9t?=
 =?utf-8?B?OXBLTW55alRiSFpiL1hMWHo1M3FYTXhRUVdRbHordUNQV3E3VXdzVVNLa1dw?=
 =?utf-8?B?NytHaVIwLzFMazNSTHpabnhBMS9QMmRKeHU1blpuZkVIdHI3NDF4b1ZNOWIx?=
 =?utf-8?B?WW1kbHlmbDh0VTJnWDlnM29aenhDdmtzRzcycWRlNnp0dzhRbyttVTI2ODRR?=
 =?utf-8?B?bkVDVjY2aCtYUGVrOTJEYkxURmpJcllmK1Q5eEVyUVFUNStzZjl2REVoRmFZ?=
 =?utf-8?B?ZDJ6MURyNm1oWVlHNzhwbytSTkhsWTVROUI0U21jUUZ2RVVVMkt5cGlUUkha?=
 =?utf-8?B?Q3ZmckR3Y29YOHd2c00xb2xEOE82YWZCYzBGd0JxZ0d4RHN3cUx0WDBOOTlT?=
 =?utf-8?B?SkdISG40OU5QLzU1bzZmb1dYZUNtdk54a1UxOFJzc2QwempUellteHNRZnQv?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QTVqyVez4BkbLvjWAzc3mHCI8fKccgQu2FFW45F4POjoQju5zIDXas0tjveOkaE5o36OrYZnMl5sF7gW7rAzDbd1XuvX+I++nzNgxHb3zOyoUeDrEM3TasddaJRg5yAILxASkws5qfnKlQ5siit8epn6uPt4Jyt5L6C4TCjiRwdUER8ozPs0fz1EpIsgiobsslQcOGP+v7WC1anvZ83FTMWyBJq3M77UUf1S4Kwc9jeaMpCUIe1kl+oga4lMISWfbdjzQ0vl7SqGaxA5KU3D0VfNuxx2H+JOTdzfoaWqMsjTfPIyI3GTbqLLyEwpuoybNeEIKkrMPhjWhKV6RiTizDJ0MV7tto3SbH4XjeTnAbZuoqRdVokvYUCV1A/L3X15vDsJ6iisfdw8VWR6RQb91+l1O9fF8K9r4SbxZDcX4Nm0eL/eONJdRaJS/rGrkqTq9EpgNJ+jbIJtbzvV0xSF2T6IadnY9eACHI77RXMDOBtNVY/AKBJWBGXbBAkhbH81ceXsgK6roe7R7S/WD1e1aEjtPktATIsr2bxoHqgVdxJArUUPkAXyppkBiHWMDnjaNEgn7nyp9zOQ6+EMJPzfUCLNgM7VDQYwYAt2Gx75TlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d734e10-6b3c-4413-c3a5-08dd4ae2383f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2025 21:22:42.7514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HnpBIpAGMH1I+PK8UpZUa3QMjet70vk5LG4iSzKqJOGg6Q10uTnrzIA+qNJaZGNMg3ufR6B+em8PJ7IkecXsOnoLtzBqpHRerlpci6SzWUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4382
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_09,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502110140
X-Proofpoint-GUID: omLP9-LGYgMcVwY2x69A5VNP7mPC_PnF
X-Proofpoint-ORIG-GUID: omLP9-LGYgMcVwY2x69A5VNP7mPC_PnF

On 2/10/25 17:48, Peter Xu wrote:
> On Fri, Feb 07, 2025 at 07:02:22PM +0100, William Roche wrote:
>> [...]
>> So the main reason is a KVM "weakness" with kvm_send_hwpoison_signal(), and
>> the second reason is to have richer error messages.
> 
> This seems true, and I also remember something when I looked at this
> previously but maybe nobody tried to fix it.  ARM seems to be correct on
> that field, otoh.
> 
> Is it possible we fix KVM on x86?

Yes, very probably, and it would be a kernel fix.
This kernel modification would be needed to run on the hypervisor first 
to influence a new code in qemu able to use the SIGBUS siginfo 
information and identify the size of the page impacted (instead of using 
an internal addition to kvm API).
But this mechanism could help to generate a large page memory error 
specific message on SIGBUS receiving.


>>>
>>> I feel like when hwpoison becomes a serious topic, we need some more
>>> serious reporting facility than error reports.  So that we could have this
>>> as separate topic to be revisited.  It might speed up your prior patches
>>> from not being blocked on this.
>>
>> I explained why I think that error messages are important, but I don't want
>> to get blocked on fixing the hugepage memory recovery because of that.
> 
> What is the major benefit of reporting in QEMU's stderr in this case?

Such messages can be collected into VM specific log file, as any other 
error_report() message, like the existing x86 error injection messages 
reported by Qemu.
This messages should help the administrator to better understand the 
behavior of the VM.


> For example, how should we consume the error reports that this patch
> introduces?  Is it still for debugging purpose?

Its not only debugging, but it's a trace of a significant event that can 
have major consequences on the VM.

> 
> I agree it's always better to dump something in QEMU when such happened,
> but IIUC what I mentioned above (by monitoring QEMU ramblock setups, and
> monitor host dmesg on any vaddr reported hwpoison) should also allow anyone
> to deduce the page size of affected vaddr, especially if it's for debugging
> purpose.  However I could possibly have missed the goal here..

You're right that knowing the address, the administrator can deduce what 
memory area was impacted and the associated page size. But the goal of 
these large page specific messages was to give details on the event type 
and immediately qualify the consequences.
Using large pages can also have drawbacks, and a large page specific 
message on memory error makes that more obvious !  Not only a debug msg, 
but an indication that the VM lost an unusually large amount of its memory.

>>
>> If you think that not displaying a specific message for large page loss can
>> help to get the recovery fixed, than I can change my proposal to do so.
>>
>> Early next week, I'll send a simplified version of my first 3 patches
>> without this specific messages and without the preallocation handling in all
>> remap cases, so you can evaluate this possibility.
> 
> Yes IMHO it'll always be helpful to separate it if possible.

I'm sending now a v8 version, without the specific messages and the 
remap notification. It should fix the main recovery bug we currently 
have. More messages and a notification dealing with pre-allocation can 
be added in a second step.

Please let me know if this v8 version can be integrated without the 
prealloc and specific messages ?

Thanks,
William.

