Return-Path: <kvm+bounces-41508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11108A696F6
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:56:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 749AF46108C
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 17:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF32208969;
	Wed, 19 Mar 2025 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YF1KcFdM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ePHdGQ0g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017541F585C;
	Wed, 19 Mar 2025 17:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742406891; cv=fail; b=utAOwr+F9P4t1I1HJY4I0uw0QGFtSAXmeiX5PhX9v6DqgJG8rLZJ5MjuR/uQl9gF5xmEMDLpLzdUG1cz8VUTCkuEPxK9TXoiGEZvggFyclB36Ny5tw9Bk54Gq6FpLtAjdhkVCjR7IORcma33mYsfl/bB+Vco+qYdDath5Tt/AEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742406891; c=relaxed/simple;
	bh=GVcH5IljZIU6oHPf7Sb+0xCJQ77VChDNXZNZf7R0cro=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r1vaU/Wao+URPBRLv4LsTEAXBLZPuIR4Aj1ZOkmeeWNSH5jzRREs6glFcb17wdYV/6TXvuykW1JD+6DEhzhLcLRc9q82S2hHosGrtcbYbTb+PYn0iBnbDEb4w59T01Vs4XYn9yDdz+7dxDKq3DAPw0YslkXV9KYDa6AjZBxkSsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YF1KcFdM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ePHdGQ0g; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52JH0reR014417;
	Wed, 19 Mar 2025 17:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+XwucvK+QClG6jnHSGjdD7lcG19tzJ5IScAbSlzdozo=; b=
	YF1KcFdM0loY+2i37wmjRH4SNyLFr14Auj4hs6BFQ1ETlnadlvXo0TzQ+BBvBwxx
	tFPryBdu7oGfvEJ2l+x0eQYNuTnoqKo9MNB2/CZZWiay4kfXqOYP4XD+3+X/6wh9
	abAZNpJba4MHQcVsPJdvTuD8fklAl7geeVU8aMI3/zDK7NshHoeqpcdzQr4bra+V
	f0mDCZw42DOvOYqYtRvXjmqMfQLVuXkFmS8tjxmVtbQjGsp/3eWxFc6Hg0G9KZIT
	yPZP4nPb8yDewzRHlE2Nn6/4qgs7fQViwcpK0Okj+SmgvXTN3SXQrobLArLzSv4m
	H/QUmE5eq3u6MmJadKyL/Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1s8v3me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Mar 2025 17:54:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52JHg8Yd004504;
	Wed, 19 Mar 2025 17:54:43 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmvvv04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Mar 2025 17:54:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XXN5EdoWjAnrHWOjxBYI9mtwPnk6JP6ptJgIBFfgtdkx5foczpBhqKA5creEuTGgrSnRVVFpNH8Nh5/4M+FmQI5LzKf0SsKpF4SE/w65RV/Q0Ku2GaG+MoyRBMNOm8gB8jG0FR/ddeIhX9ItXYAJMwR6ZEOzr52udVgZaOM5Agbf/q49D6rC4Rao/BnEcS3JTvnsOUlFhyFmvJoJy9Tuj+Kh0bZ+EUvaQV+Orkp1b7z221oh1uRoY1IMnMqu1nxA6wwaK2djDVZtyqhshcrjemgRGxfzzcZOKWi0/FbWxKK8c+c6jiXEU2WXso7UI9971PQZYKc6DgYTon07hnzpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XwucvK+QClG6jnHSGjdD7lcG19tzJ5IScAbSlzdozo=;
 b=KNQI2eszvjVA625a8GXNyGqEReAnxt2nQjzP9jOW8jcsETvQxZl1IrHShvalLHxYXqcGP8T1QwzQ+TPftTnk6FI7eaagwpTv5ukFG9oVHbGIpvyfvy0nzmk8FhdRg633ibekIZua1AzMdVG2PyMlAWQ8MpiS1WYwOxxYde9rlcbVLey6q8S4aRoxxSN4ngyCB3BoKA+Pq23ISBeQ3XRzYfGci4tT6EYMXNHZqBnQx+KlZsLmMEISEDQnWpuJsUfbTj3SJXZgUsrioKpTDRjZoc++gZBpd2zjdLWnxvko8GNFhT2edM+/LDU49i9O/VlxEh6yBXgn/odfCR3Xyw/sjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+XwucvK+QClG6jnHSGjdD7lcG19tzJ5IScAbSlzdozo=;
 b=ePHdGQ0geoMOaHe3MFDDdiN8SsGK0dI7rjIltEHnCFZjYsApHOwfSS8UjQ3NcuhTSB6EvexAJwkN5Big9bd1UVR4NxmhWb4D+tulAZ2rmZGCDIlDevXSX5LKZhJn8Agj64cnSczko3iOYvuKjTsiOOOxcekxc83TYDmOoYLWisE=
Received: from MWHPR1001MB2079.namprd10.prod.outlook.com
 (2603:10b6:301:2b::27) by SA2PR10MB4649.namprd10.prod.outlook.com
 (2603:10b6:806:119::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.31; Wed, 19 Mar
 2025 17:54:42 +0000
Received: from MWHPR1001MB2079.namprd10.prod.outlook.com
 ([fe80::6977:3987:8e08:831b]) by MWHPR1001MB2079.namprd10.prod.outlook.com
 ([fe80::6977:3987:8e08:831b%6]) with mapi id 15.20.8511.031; Wed, 19 Mar 2025
 17:54:41 +0000
Message-ID: <f3939e10-3953-4be4-bd92-2ae891f6d67e@oracle.com>
Date: Wed, 19 Mar 2025 10:54:37 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] vhost-scsi: Fix vhost_scsi_send_status()
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org, mst@redhat.com, michael.christie@oracle.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-4-dongli.zhang@oracle.com>
 <CACGkMEsG4eR3dErdSKsLxQgDqBV55NUyf=Lo-UUVj1tqQ-T8QA@mail.gmail.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <CACGkMEsG4eR3dErdSKsLxQgDqBV55NUyf=Lo-UUVj1tqQ-T8QA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY8PR19CA0008.namprd19.prod.outlook.com
 (2603:10b6:930:44::13) To MWHPR1001MB2079.namprd10.prod.outlook.com
 (2603:10b6:301:2b::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2079:EE_|SA2PR10MB4649:EE_
X-MS-Office365-Filtering-Correlation-Id: ab693ed3-4452-4f56-c541-08dd670f1f9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnpKZVFuYWY2Y0R1dnpDaGZaMklFYmZDZGkvMUkyRDVvQUk1alJ5cVRybm1p?=
 =?utf-8?B?b2VWZ002RHF2bjRhQW91Z2NDRmdVYXpBZHQxb0x2SVNuZ2pmdkg1MkpIaVhX?=
 =?utf-8?B?YTV5aURpZlFnTW5yeW1UNDJUR0RCZGQ1Wk5rRUx6TlZPdTFmMktFbFp5YTN2?=
 =?utf-8?B?UWJKWDJhYmlYcmdNUTdsM0dHcXFmTWQrZWtNdWdYZXQzSlNsQ0NmNk45eXJD?=
 =?utf-8?B?MUR5cHNMU0FmQXZhOUg2NTNTRkV1WG9LZm9oM0xIM1BtbittU3F5LytHakZM?=
 =?utf-8?B?a3JnYzVJZ1htWElkc21kMDVYeFJsdHZQZU5LUnBCSytNWGkrWkZHNzF4QjAx?=
 =?utf-8?B?TmhnRU1MWDAxSFpGSFZyYWE0L0MvZnBLMnM2QmV3Nm9rWU0zSVJnQTBNb2ZO?=
 =?utf-8?B?NUhJM0l5R1BKbzBCZ3A5aUpDcE5naXZ3ZEk0ekwwcGY3UG43TzNJd25TMWQ4?=
 =?utf-8?B?cVhURkpGVkY0RGNwU0xWNHlHWksrcU1CWkZOOU4rSW9jOEg3aXNrV3R1M3Ur?=
 =?utf-8?B?RHIrSXVHVytkUkV0djd6djFnZ2wzeExJUkhPeW9IRC9nL2txUWNYVngyS2Ra?=
 =?utf-8?B?MFVCV1FNRi91U0MyazUvRS9BMWtZLzJ3aTVZQ1FucEJ1UndFT2NSUGtabktQ?=
 =?utf-8?B?OEtoSmovQXAxOEs3am93MDVQK2ZxMTkrYTlkSlJrNUJGeStldGF1K0o0Q1Rl?=
 =?utf-8?B?NHRBRWxobkVtOEpjMkROZDhZRUkrQ0VPTVlJZHFTdk1rVjlJUzBJdWNIYnRV?=
 =?utf-8?B?alh2dzhwbm1zK201Y0xrQmp1cWxOVU5zd1U0M3IvM29GK2p6Z3FEZ0NTTDBp?=
 =?utf-8?B?ZURyc0E4Wk5CL1FERWFpcHZQWjkrQWlWMElBMnVZN25FaURucDFhU0V0RWdz?=
 =?utf-8?B?VUkycVdsWmVUbmhzSWwzK0N0SGFJTmNrbVYzYWYvemFQRGx6OHNSMHBYOFNt?=
 =?utf-8?B?N29SbHJTT1BDNHh2T21ENUo2aWEyUlRQaThKV01uSHlrTnViODlUbHZSUzVy?=
 =?utf-8?B?c1BtQ1FaSjVkZGRjQ3V1eWEySk92dUwzTm9DYjM1bkVXazR6OFlNQVo0L2Q5?=
 =?utf-8?B?RENYY1N6WTN2WUd2Ym5ET1pJbFdiZnVlSnNNU1hicVV3bXE3NUsyMC9ET0Y0?=
 =?utf-8?B?VWFrSlRYRVhQcHpRYTVGa0YzU1lmcGNOZ1hCb2hSQ1p0Y3M5TW1KYjdqRTdi?=
 =?utf-8?B?ZVlyRVJMRmhSWlloZFJmU1IvaFNvVW15VXMvaTJBbExkTzA4b2xLTTZkekg0?=
 =?utf-8?B?Q0FLdUNxMHFuTnFDbmZ5MEdRdDU2RmlOaXpvbGtnOFZOaEtLaFM4WVlWS0d1?=
 =?utf-8?B?NUxSZS9vWUcxSkZiZWxiTXhVcmQ4U2NCU3AyZjFmS2lqR3JaanFWR0dvamtD?=
 =?utf-8?B?Sm95RFNmSThhVUlBY28rZ2xBVEc2dnlPNkl5ekdWTHN4YnNZSEh3eVVMUmhM?=
 =?utf-8?B?bnN2UHRaSzJpdWoyTTlub1h6ZTlLSXBPMVJ5RStka2VzR0lYU3NKc1VUZ25i?=
 =?utf-8?B?LzcwWXhiZjAvUE5SR3krbktzd3N6dzltdktsL3kwbzNlbHZGV3EzU1h5MGZY?=
 =?utf-8?B?YWNYb05kN3ROY21oS0ZxTDlHOXQ3ZU1tMFkzQ0t5NXRTSEpZQndZMmpGcFli?=
 =?utf-8?B?WUNBZkJIVFNqazBuL015bEJBSlpWbzZQTURvbDhTZFVoZ3RiU2pGWGVmcno4?=
 =?utf-8?B?SGxrM3VaMkJ5cHJ4MGFrdmFaanZjY1N4NEN5bkNNR3hiME5KaDhTODFVTWU1?=
 =?utf-8?B?dUdMMDhuSHY2NmNETS9wOVZwY1c1Zk16bUFyS0pNR0ZhV0RRQ2UrR3pPUXBu?=
 =?utf-8?B?UTIzK1pvaytSUUkrclF5Q09wZXduZkRXUS9BUkNWcWJ2dUw0dXRvaStSbytM?=
 =?utf-8?Q?8OjAEsAliEXbW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2079.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3JDZ3RtYloxb3gvQm9iYlZwakRHMlpQWFVFL21Db3RqTUNRRnV1T29DZWZL?=
 =?utf-8?B?UHdaT1VFRmE1RGlSbDYvZ0V1bG5PdGlVbUt4enRhb05iUnk4cW5sbHhlbllE?=
 =?utf-8?B?WDR2TmhHYjNHTjRRd3FicGFISW84ZEw1WHNsWE93eTNYNjg0NUtBcERrTitJ?=
 =?utf-8?B?cVlYdUFPY05nc0lRQWZTZFNVaVkzbmhwNFVkK0RDQ0MvM21sUklwK2ZOZWVh?=
 =?utf-8?B?WFhhL09ta05QZUYzYlo2UWVpQlpLNk1xV0x4bDZJUUV2UlducGxOT0VhSk4v?=
 =?utf-8?B?MGVXYW5icS8ycjVjblpYNGtyZGwzVlNxc1FOMWxZa213ZVlNOEVTdVNyb2Qw?=
 =?utf-8?B?UTZ6aXNHMmU3S3Nhcng3ZUp5Y2xLM1hRcU5MSHhkZ25JVzJwZTZWNTI1ZGxp?=
 =?utf-8?B?c2kvOHFiNW5hRWcyWXF6WS9oYWFCWlBlTkZwNVp0VDlQWThEWWxHL0pFVUhK?=
 =?utf-8?B?d3lTOEh4QmdQUjFpQU43YlZhcmtCeFBBZ04xLzJjZTFtVVVSYlE0WmNQdHZO?=
 =?utf-8?B?SXdQYnREY0p4MkNXd3NLaUVyZHJXMEFQaVI4RWpDWXhXNmVQb1pzZUxLQ3ZW?=
 =?utf-8?B?ZHpNM0Q5MlJtRlB2SlBBK0dudjZXVTI1WVlmZlVNRXNMSFA4OUlkMmNJRDlu?=
 =?utf-8?B?RWN5a3FvUDVKWFpXd0FZdWZ2T2F3MzJjVEIrKzBTYzdIaUdaZ3I4VFN3cGRR?=
 =?utf-8?B?a0wzMU5jbkRKaFZtd3Njd3FNSzFHTk1KT09SM2ZjdEM4eWJNa2pFREc1WGRj?=
 =?utf-8?B?eHAzRVV4Vk92ckJvWTZZMjRxb01PU1lvTERESi81OXV5K2JOZnJGcy9hMzJZ?=
 =?utf-8?B?ZG1aQ0VkZzJWdWVrcVNiYWFpVFE0TDFJc1VqRm5JUlZNRnE1cFNzZnlQNWVw?=
 =?utf-8?B?Q3pKa2tXaThNZDdFdUd2dVVORlhDZHBacUhZYmR4NzVTc1R0THJyMVhTTFNZ?=
 =?utf-8?B?a0xYS1FKdzRmLzZHeHRiMTFBZjNuaUw0eWkzQTcvZWFiZ0g2WGlHNUdEV3RQ?=
 =?utf-8?B?NTR2d1ZUYnVtbGlsM2xUaktpYjhKRVNKOU5ha1c0RmFWdFU0SkVCZWJPYVJD?=
 =?utf-8?B?MGVEVWxDWE9LWFRpdXVpbTZBY0RYZHlwSkNlS0hWQ3hrbHowQXZ2S0hkR1Bt?=
 =?utf-8?B?V3l0OFZMc1gyRVJuZG02cGNNeGlyUlJlYjhqZnF3dWZadXlhdFZJeE1xNGpV?=
 =?utf-8?B?QUF2Tkh6VnRmSzY5SkwzSm1NQjNFOVNVUjJOcXh5by9hLzExSVpjVWEralgv?=
 =?utf-8?B?SlkwNVNpTXhKK3RjcTRReVJteUFYbktFTWllam0wQ3FMQUhuZ2R4L2dGNUpX?=
 =?utf-8?B?aE1CVGhYZ1ZWQ09HS0pJa3ZxckZveWlXcGJ3aGRkMlJzK1BlYURITmJ6OExL?=
 =?utf-8?B?dmVWaFAwWkNmSVhQa1FGejh2YTN0ckcwQUx4dElKWnU5UE80WndyZ3Rnc3ZW?=
 =?utf-8?B?UHh2ckh3bWtucisxWUlmWWJnajlkS2hoQzdZNTBFbzAySnhwd3lleDJWNEdn?=
 =?utf-8?B?ZWo4N2hsc25HRlJIMEU3Zk9CcFRveDdjakt3czJkR05SbGt1TjJ4Z2xwMGR2?=
 =?utf-8?B?bGlpSW01RGtaTDZpNE4ydDkrR1EwL3FXUk5hdHM4aS92NE84T01NOGpSb3Z4?=
 =?utf-8?B?cEVCck9tbXEwdzNlQmk3bmhCR2wyVTZpN2NBTTR3em9jTm96bEVXcGdUV20y?=
 =?utf-8?B?Y0FDd0UwcXp3dk84QjkvNm5YeXNNOU5YZi9aOWtEb0EraFNEeXdBLzVxNHlS?=
 =?utf-8?B?cXZWVWdiNEtDN21wQzNOZmgwY0dybjZ2NlZGaThxVjZyVVlsU0VXMGtMY1N4?=
 =?utf-8?B?c25UdjZNN0ZpbUJxQVByU09mdTVGODdFKzNmQXkwc1RKWmhpVkMxNXJEK1pN?=
 =?utf-8?B?c3ZMRlFaWXl1aDJtTzFRc1FqVGtGZFNJQVNYYTRPTmxMY3lyUS83LzQreG8y?=
 =?utf-8?B?aXlMalZKdndlMFpjMHhvRkk0K1JQWnBjVEZYVC9zV0hWdzU3OWJGd2JvU0pZ?=
 =?utf-8?B?V21WRVBnVnJoMFZ4dmROaUVXSng2ci8wTFJrOUdMcFNja2hvZWFEcTRNOUNW?=
 =?utf-8?B?Q2RVRmJJRkN0Z1djc2VSZFlLNk50MlRJb1VGUjVxdlJOZ0xGTFQvTlRCcVEx?=
 =?utf-8?Q?dYdm9wAR1Jo3x1YOErbu7xH0u?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NKAs67WkDhUqCJ1CtyPZe/pX6KXSKDCLikrkmi4bhQ8ed8Wc461RoJXknMN3hXGHdCY7cTQDR9Kb979qzJwjGy/dIF4pEiZilCNEgmcQBPbC0AQibsSmlwtB4IyTtNqgt3jRKIIbg4xy2PjPwQnt6N6RjexLBfZVDCX83ud+cViW/s0j7AWjVhFWxFRtrCven/W8IoFy8n4sVljpEnodRuxoeWQpPsmSL8TVsdc8HAeqHk13LLgKVLhUsEYGb+7kLdr+5k0CWlYohOyT0d3DG/zIfzzFNWrfTU02KbRp8A50nDVRxcGk00QC/BpoUpDoq12TNeeNLkKbxXYas0A2DlNzblSggRxalWy2e5q3HVVAWMcmDVlXT6q6nxyk9VZLkqswJECwe891k2bTpU7m1ewdS4FYIYHFU/3Ea3+IMPYPMPD8BsvfonlISWt4QLWkmWXAk4/CPcZT/AfV5cRm4lq8azyP/ccnKK5KgBNRhL07us/NF32FXYNwpiIOM0lsOW/t/K4fnpQQhVp9ah9lq3g15X4LcfOV6HXRWyXFCBRyniJPMYKeWPh7Q/mxlWY+2aOCqutCm0cqrIqbzWSimFNCkYYBBNNt2KUGJUOZJ2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab693ed3-4452-4f56-c541-08dd670f1f9a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2079.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 17:54:41.8879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAgy+Ev7Le742cAv9NK5UxorsSPP1FGRZEjj4CFUtColgpMr9rU+N1ud28q49pnu08quE9i814Z3YaFu5KMfsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-19_06,2025-03-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503190121
X-Proofpoint-ORIG-GUID: 38YFE7rxPPHLnspXpZIrwZWa8nTVYdTT
X-Proofpoint-GUID: 38YFE7rxPPHLnspXpZIrwZWa8nTVYdTT

Hi Jason,

On 3/17/25 5:48 PM, Jason Wang wrote:
> On Tue, Mar 18, 2025 at 7:52 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> Although the support of VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 was
>> signaled by the commit 664ed90e621c ("vhost/scsi: Set
>> VIRTIO_F_ANY_LAYOUT + VIRTIO_F_VERSION_1 feature bits"),
>> vhost_scsi_send_bad_target() still assumes the response in a single
>> descriptor.
>>
>> Similar issue in vhost_scsi_send_bad_target() has been fixed in previous
>> commit.
>>
>> Fixes: 3ca51662f818 ("vhost-scsi: Add better resource allocation failure handling")
> 
> And
> 
> 6dd88fd59da84631b5fe5c8176931c38cfa3b265 ("vhost-scsi: unbreak any
> layout for response")
> 

Would suggest add the commit to Fixes?

vhost_scsi_send_status() has been introduced by the most recent patch.

It isn't related to that commit. That commit is to fix
vhost_scsi_complete_cmd_work()

Or would you suggest mention it as part of "Similar issue has been fixed in
previous commit."?

Thank you very much!

Dongli Zhang

