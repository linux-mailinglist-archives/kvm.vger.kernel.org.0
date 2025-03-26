Return-Path: <kvm+bounces-42079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D426A723E6
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62A681794E1
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 22:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56EAD263F2B;
	Wed, 26 Mar 2025 22:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CEurhMaT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BE4u6TOR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C812459DA;
	Wed, 26 Mar 2025 22:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743027937; cv=fail; b=R6WnfzvqjMH5hh0e91Zs0aU9lgpzkJ1FPUjqzp40PWuzyoT/blRPBaNZQlrtcyc+CO9uoaLZV7Dpa81EfzEBMLeGF0CtKv68KEDcLpzUhlmWTXNJNCNXnpLlMc+SXyJzl/alExE89pWSkXf0rlBbJGSDP7dwShy0/gKwPNChdg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743027937; c=relaxed/simple;
	bh=e56bKaGLNgx3epg+E60bRgDrkG9Shi/vLH9Gx82M+so=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JHN4+tJEp4i0alehg+mS7//S7CtAfx5S6Iw9H3NDLPQqiaqCKMppzUfKUmjf2xRUSdXWhfV+4edoNFWXb7y4HT5EMJyZtj79bjwkyPm1S44Eaj/C3q0/PuV7511pXDYPflvv/akTpHmws0AgMa9GnEqCpTse9cpLSCJflk5ig8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CEurhMaT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BE4u6TOR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0XlV024421;
	Wed, 26 Mar 2025 22:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vtr5pG2TFfkOqq3ufKgbds+k9e9Y4E/JdFvWrd8kgcA=; b=
	CEurhMaTR1nmCBGOafQY/k0h8PmfRn6Iuu7GKdlKAE/KhizREocZFa5GWGOW5eSm
	+3QqJWvXVbF2Xr2l5glbhVBV4k7YViFaI1Dsk7L6qdH3mNrfKLX8q4lth0euO0hV
	r0oJ5YGGrR9rZSh2xPkD1IFrdWYPtWkt3qyeHxc9rSdmMxncXNHNnZuOBOt66Cai
	pIdseSbEddZO29wwCs+s6ViAhIYPP6+F5xsKUYh6GTpKXVnpZcE+ehqDHoPgmjxJ
	qYHveMjIe+wrDmOcjDvuyDIBuqvl7KuiXXvbA29UCdS0oUNVBmJE+NyWfabQ5UeE
	1casN5qAOXwocZPKhpNrsQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hn7dtwfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 22:25:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QLaprx022877;
	Wed, 26 Mar 2025 22:25:29 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jjcfua4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 22:25:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYxGj+fuqCegf08NQ5uF40lGpZ0ZdgmNEHKIzmHWQaW6HAtt0RQK3Mas+xA2+GXS+0wdaDL1dGHu6NysNidKtd5glTDPr9VsBAj4F8n/SYxrHQUfwUEgWBkFaX9Sl5e3PY7JEPcIhIlwE7WgIa3eIkEHqAuBgni/ptcvyvI2tIT7OJOJMEqGDs68aKnDloKP0YoNuFu3NuuZrW/UK+8HuTnN5mNToj3rcEpSvXIzwf+8S+fVaTbo+AIp7qBv6yyugtn+kQJdO0Xnfpfvdg8Lc2wvN/gEk9Jxa/DPUlmV6rfMqxnbgBJS9NuLAHGvwVPK/euNCPklPvTBLPe4VP0Vhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vtr5pG2TFfkOqq3ufKgbds+k9e9Y4E/JdFvWrd8kgcA=;
 b=iRmiJGA9iBL+T2NCVflL367jHNgsXbn++lX5ueZ+OT4QsOzUAn0pBa2h2xiSHZu2Kgvnkw3QrtYxdcEc0wupXvd8d4Rjzbpp2Z4lX2sCG/9H7IBxeVpoZgckm2oaG8uDvCMcJUv5OkQ0wBBqclIg0H/9GnqtzDC14kqcal4qrvTfkS50mJqJo0Af8RnT3UCVTaHle5vu/OhNB77GDGuTn5XswvYSTtD7vp6ZM9kDpIb9rFQtpPi4pV+FwIbFIgHaJwgsYxPozDwPWu5Py/oJIqhHWYmKl5LmUrUtPe82vip/BaAc2t3ad5XDdzDkJgSbHABkgOO/pU/mwrfByHgyBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vtr5pG2TFfkOqq3ufKgbds+k9e9Y4E/JdFvWrd8kgcA=;
 b=BE4u6TORgtIm7E1snCjxksduH2+03trpHldRWd2S8mSI6CxwfOt+9vAWy66L0UBh62xxeS8k4eKijOIfXJ5BASGk06EJIOWfhu9eRjHQuuLhY3dXgfn+/pRkyYzgdHfw9Wp2udimH8IEQu85jt1QKDXNqrfW0dSqrvDNFV1F5bk=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7956.namprd10.prod.outlook.com (2603:10b6:8:1bb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 22:25:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 22:25:27 +0000
Message-ID: <b59b87a7-d492-4b50-aef8-98b8c541cb77@oracle.com>
Date: Wed, 26 Mar 2025 17:25:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] vhost-scsi: Fix vhost_scsi_send_bad_target()
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-3-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250317235546.4546-3-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:5:190::25) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: d2cce957-966c-4964-984a-08dd6cb51bde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGNWaitvODc1Yk15a2V3NWx3WWxuamRUNDk4TE4xeWRvalcvajlvRElMM1c0?=
 =?utf-8?B?ZUpkNUtBc01CNUNqd0hYK2xNanUzM1JCZDBNNndDZzgzcGZQbFlMOUVQd1Fx?=
 =?utf-8?B?UjJWNUo4RGM4Q1A3SUhndXQwaFYyNUVGN1NpaDRYTlZiRG1OSVIzbTdOeDZT?=
 =?utf-8?B?S2dRMVVRYndnciszc3IvZnB6bnV2L3g0SnJZdGpMUmxDR0h1VTFWNlEwaEx0?=
 =?utf-8?B?NXlvSlFVY3FNVGdkYmVhL1pHb3ZMdkwwaWY0dnhsSUV0dzYrL2ZNaEZETm9M?=
 =?utf-8?B?NnlGV2ZIekNpTlNoOFZOY2lDSEVUbVFhcSt3ZDM2UFYwRTY1YmppVDI2dkYx?=
 =?utf-8?B?c0JPU2J6TVIzYXNYRjZJeDJXZXhVTnEvT2JvRUpqZ09ITVZBMHpGMnJNUUxG?=
 =?utf-8?B?NkNFcGE4QkpQZzlTWEE2ekI0emtpNG13Y1JSemRhd25CK2k1d1FMQzV6emZp?=
 =?utf-8?B?WWpqQjBRQis2OFVGTFAyUnE3SzViT0hWei9XZTQ1QUJHbGhxRW42eUFMbXlN?=
 =?utf-8?B?a3ZQak8rOU1LS2IyRDlTWnh4VGhHOWgyUG9wV1BzR2t1V21LN1M2bDNtdmR6?=
 =?utf-8?B?dlJtV1BPMDdQNmZBWFdFWm9yZmJlV2IxUGNFRFg5dmppRk50UnJJM2pXNGlr?=
 =?utf-8?B?endvYk56SW15ZS94ZkRCcWoxT3krMEROS2diMS9YY3ZwRlV5WHVyOWoxd3Q1?=
 =?utf-8?B?bzBhN3BlWWhYdmlIdk96ZzIxYkt0QnBkWGFYSC9VU3VzcU1OZ2NSbDZHOWFk?=
 =?utf-8?B?NjlXellkQWtYWDNyK2EwV0tsZ0xSYis1VEpic0x3OHNkZDBuVmo2YVkrNnRI?=
 =?utf-8?B?cjU5MjcvV2R0akprNGVtWEFDWTFpTmcyQ0hqNEhPTmhkRUQ5dlpab3VzSTVM?=
 =?utf-8?B?WXJ2endMd0xBODg0dG9RaitDeUJGWDJGWXBHYldEbEtHVm5vZHhqbkRRUDlX?=
 =?utf-8?B?em45QmN2c28yWWE2TUNGYmk5NkxtVWNteVNNTXJSRVIyVEp2NHNXL2s1eGJI?=
 =?utf-8?B?a0xTTmdLNVE1MTRhQWZtSUdVVGRTQ3JCS3F1eEpJVnJINGdrbVc1enpSYXFq?=
 =?utf-8?B?VWZsWFZOR2lrM3hmOHVqWlVjWUZVTzRKSTV2VTEvVUFMWjYrRHNQWkVMeWZy?=
 =?utf-8?B?bkhtVGQvRFlOTXRsQm1PN25vRU82Z2V2dTZ1NnRiQUs2SU1iMGo2VXFGWGtU?=
 =?utf-8?B?N2JnMktGMzJCdG9xOTE4cWNwbk1JeGRJeC9Wa2VCdjJZVnpWdnZZTHQ0Y2Vt?=
 =?utf-8?B?dGZMVmlXZ1g0TFAzM1FaTGZQQmM5azY4Z0lHV2d6b0dzbVFXZ3cyaFdUdkF1?=
 =?utf-8?B?c3hNMFNxVDVjNStRbzQ5T2FnNjZXbHYyQjBYM29hS0MwQjVOWU5pcm8zMlMy?=
 =?utf-8?B?SUdFMzBOS1NKZGtFNHhnQWU3UnNQR3pCT05lZmIxc1ZyRGpkZVpzSDFkaEMx?=
 =?utf-8?B?cEswRDVaN2ZBdDhYM0NtWXJMdk11a0EycUtjN1BiK2x0QnlmR1l5ZG1sZDNG?=
 =?utf-8?B?aFdjSWQrajNiZmJvZ0xMT0xZT2RrdEc5SE5jYTQxZUlKQUlCS3hHcW5Ncm05?=
 =?utf-8?B?YjBhUC8wbjcwMkdjbWVFOVBkTWdkYW5OOCs5U09yVkF0SUxUZWNxdUMzVFpW?=
 =?utf-8?B?ZVRqanphOW9TZmdUcGRnL0N1MDZIZHBLTk9WdmFMRVdCeFppd2ZxNmYyNDFs?=
 =?utf-8?B?THpTUjJ0U3FZcFg5WGJldDlycXhJVENWbWNyQ3A2QnJEZFdFdlVBM09zZVkw?=
 =?utf-8?B?Wjc2VlBWMGJQbUJad2cwNnV6QTZzandpK0ZMYzlRbmE1azREcFZzMGE4Mjhp?=
 =?utf-8?B?eHJZOWJxMFltQUR6SGc4bWZZeDU1YVNsWDd4ZjV2N2NrQ3lST05RN2JrbERU?=
 =?utf-8?Q?9d4vjvSpe0Bte?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emQ2dVFFbEhITlpQcUNla3V0bFVseGNJbGR3NmlNM1NBeFV4SmRWd1NJVzhu?=
 =?utf-8?B?cDNzZU9pM3VBZjFlVGFzeHp2QlFTakhuSk1UcnA4eGJUOHVHZFRVVU1JU0dj?=
 =?utf-8?B?bUhITkdyN2ZiNGUzWGlCeGtyYThEY0lVcHNoWXI4V3RCSGF3R3NzcUFmSHpk?=
 =?utf-8?B?NmNxNitWZDJRa1lOalRBSjNKTEF4SmhIRm1zNjF5OWVVRlRiZDJndGFMWmJW?=
 =?utf-8?B?MktzOXhmdGF0UHpUY1NoQXJrSVpKanNVKzZETFBHd1Q2NnYzNjFpOVYrZENR?=
 =?utf-8?B?bFIrYUN6Ykp0UUdRMC9RN2MrbFZxaTZ4TGptTmJzZHB1RjNpcng0N0duSXlG?=
 =?utf-8?B?b2p3YkF5NGVDdmR6NXQrUE1BNHRWeHF3UXYyYmM5RVdKOW9Lc3lNYmhxcUJC?=
 =?utf-8?B?b0R3MDh2aW5DbHRGT09BdXdzNDl4R2dRbkJJYmo1NnJleGM1Wm9laXZMSjVR?=
 =?utf-8?B?MW1Icy9NMVhUcHBwVVoxeFFqM28xN0RlUytvRnIranl0STZtaFRUK2RPUkta?=
 =?utf-8?B?S0dhUTZOWStuTGQ1eVphODI4S01NRTIzek1jZGo0cXE4ZmdQdXZTSnJmT3o1?=
 =?utf-8?B?M2NwNVd6OGU1TW9mekxOOWV3ZHJTdUw0QmlXTkxVdmhIdUYwOGtNTzYwQlJ4?=
 =?utf-8?B?d2NTb2syZ2JNSVMxNG1IcDY2U2RQQnBxTWg2aVM0eHBhYWFma1JRYUpRbTVQ?=
 =?utf-8?B?N3c1REViQkhSRnN4M1YwckNDblZFR2FQT2x3WWdkWjJ1TkR3U3lqU1RCVmhw?=
 =?utf-8?B?QVpsY0VYQkZ6d0hTZzl5Yk9yQnlYN2c0QjNEdm5EbU9jbFhKMjFnZW9oR21p?=
 =?utf-8?B?WGcyK3lPM1cyQ01HZTdpVWVobXh3bytlejBIMnFGQnNYeG9ERHhNTFgweEc1?=
 =?utf-8?B?bTVYdzlva3lOQnRyZlMraW1YL3ZLem50UXNCR21LTjBsQzU4RWl2SnJRcEUy?=
 =?utf-8?B?NlhEeXF1NEg5Mk4wd3JTYjNYc2hxNzFLbTMwUzQxTzkySEg5cTd0VG9SOFRX?=
 =?utf-8?B?RmNVazQzMys5NEpDdXc4QVViZkNmcHd3SXAyNGZNSGE3enpLazJKeHFjWXRi?=
 =?utf-8?B?djdSbTRlM3c0ZjZhSXVjNW56dTRSd1g2bS82Y2NRbkNTUXdmMzF6bzRQc1pt?=
 =?utf-8?B?Z2k0NC9QQVU2YUp6bHgwVnMwRnIxUkp0QTNUUUkrTmNzTEJlWHlKZTNGclZP?=
 =?utf-8?B?RHlsZTJLcFdDL2xrZDlWMEZGTGY5T1FYUDUwazJrZXpTemZSdjZPTWFJT0Y1?=
 =?utf-8?B?OFFFRW9zVW5vN0dqbXNzenlsakJlcldkazc3TjVvODZCdTY5V2EwQ1NKT1Ey?=
 =?utf-8?B?cVNHRFE5N3NhY2pKTzlMdVNuekphYTRPNWdEZElacjUrRStBekJuWGl1TTVB?=
 =?utf-8?B?bXZPNllsZVNVWnJ4eWxGZStwQTVaUi8rUTRIaFpNWmpTYjdVM3ZEaHJ2T1lD?=
 =?utf-8?B?RnRuYzltQmdlbVBXbTRXeXpRN3prZmFSWE9zTlNENnhDakU5bnp6V1ZNZTdy?=
 =?utf-8?B?eTRKejRuRHd1Qm9KQ3h2V3B2clE1LzVrRTJvWlkxejc4WGNSSzZHOFp2aFFk?=
 =?utf-8?B?SkNKQzIzdy9ST0pWSDUvVlZNS3QvMkllSUxsOVh1UUJPMEZGZlptSUM3QmRV?=
 =?utf-8?B?dnQ3WkUza0t4QlNGbGhBeWtiZmg2VzlSL1B3ZllVVWJlQ1pLbWZrRDB0UHdo?=
 =?utf-8?B?S2kvVjZqS3FVNkdYRHNGZXFTVVA1M3B4QjNSNmo1NDB4WWNIZjFQR0JCNk9z?=
 =?utf-8?B?ZnBvZ21nYmYyL3cza25KYnFnTE44WEp6bHd3cEY4Q05YL0l0ZlZRZTZMNjUz?=
 =?utf-8?B?K0FiTjVjOTZDZG13cHhXM1RzMWpwNXlWYUtCRHRHRUdIbi9MbVhVS2JCSE84?=
 =?utf-8?B?NTVmQWMycVA4WUFvTXM2K1QzZmNEbUhGQno3My92Y1VnM1YxNDdUUGVLcVNR?=
 =?utf-8?B?cWlQVWxCa3l5M1N4a0Yvdm5XNWYzZ2lpRWVtNWlRaFpId01sR3c0Q1VmTGtt?=
 =?utf-8?B?anVuZkMyVEhyZlp1R3h2N0FnQmFkMmI5c0pabG1LclJDT1NhcDhCK3lHT0hu?=
 =?utf-8?B?RDQ5VGdKMW1BdCtjVVQvM24xQWVaSEgwbEtvNC8vWW9mc0F2NlpUajJJYStT?=
 =?utf-8?B?eityaXYvT0ZYNHhrcHBmVU9RT3UyMVdKODd6Tkp1c0VlOTR5TVNXTFNqTEhZ?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HRlhf+n3kYooXr4kawJ2wKM+EiLkMt4nQQGJZChYT9+AXnakJ4kG+iVvXSY1HWPNy8Gnna8e/JjoikjRhJFeR9aNp0TrvVdtYA7H+4LWhjVPidxTEyHl1dPVWK4etDO6llkht1r4zbleq69mzJKdC3RjQKyYLj8OwFZTXZwderXxWSD/gKbf08MfKyWkrppbnFkpIBiGToXaRzo2BDRSJzgnUJMSU5SdKcnvIuWZUEiXGZLNxbj9jA4rnnu2s6TjhKLsnbn3bqqw2bQXyMWgm6G2v9bBoHLwneYwdBluAaqSCW3rrIx6b/mn9KrLe/38gnk81c6nNBeG0Iz/6qe0Tn7mU/8lowP5UtKmtRw4rVJiyiwxXtgxVZkQbGF6JuYE4RO9GK074/JCCJDgq304ku1RT8VokDrmaSp43KyjVOO9HXzon/U4Cjd+2LZsHeFGeacNfNkCek8UAaf0miWMOok278rpZVx+lero2zzywmd/uhRJ7Za25jloT79U2YB+Bi5XcBa92lz30ikjNC575Qn4YkXXZR6RDZwUaFbuuMOnARvnSPErqI8D5+GSHmpwqks4QpsX+KSmuMaSg3vpql99qlkow37dayrL159T92k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2cce957-966c-4964-984a-08dd6cb51bde
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 22:25:27.2125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zprG9SecvfyAdHg45UQS4wNQdB0RrIoV2dMdEMo3GKt3OjpWfLfUsBDlB7ZrIW2yUYvjVLZnb+uF8G9IbXVL3iYZX7xQR5ZrIeByA4d+5A4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7956
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260138
X-Proofpoint-GUID: rFWHJTICT8RrX6aAjsCn1Iad6XspQ9Hw
X-Proofpoint-ORIG-GUID: rFWHJTICT8RrX6aAjsCn1Iad6XspQ9Hw

On 3/17/25 6:55 PM, Dongli Zhang wrote:
> Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
> signaled by the commit 664ed90e621c ("vhost/scsi: Set
> VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
> vhost_scsi_send_bad_target() still assumes the response in a single
> descriptor.
> 
> In addition, although vhost_scsi_send_bad_target() is used by both I/O
> queue and control queue, the response header is always
> virtio_scsi_cmd_resp. It is required to use virtio_scsi_ctrl_tmf_resp or
> virtio_scsi_ctrl_an_resp for control queue.
> 
> Fixes: 664ed90e621c ("vhost/scsi: Set VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

