Return-Path: <kvm+bounces-43383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F21A8AE23
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 04:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CED873B5158
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 02:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAF66192D87;
	Wed, 16 Apr 2025 02:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WDyGQQOe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="srDbjVQI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D68519066D
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 02:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744770331; cv=fail; b=ZseCE2PdWqrPaE6R/WEGp7W9ZgI/2+KsX9jrJWOVcJUwzar1zD1RrOmvsUkPyVaUPC0+GQxhwpUsE7hG3H44xOjB9aFxdvTFToP4knIWKJT+hSrMFPScZPcPXFfEEPi6lNmET6mf4wYlN9kTWkYxfTtIwpN5PTxQQDKuE6WlaIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744770331; c=relaxed/simple;
	bh=WcJsa60voDQW1U7jUSFaGPlFNRzW26i8SrBGFgAaf0g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RrfFlJXsD5uzWw3L+bdkyX5sEOQgS5jiZYTddVxaUgdP13XZ5ws8b+sGssGB3lLBEKW/PyrFodIeS+93EBYqJjCMPW2qmRusgq2RZ4s0LLKg/x+NZb4hmxe4MsOH9KEu7hXvRN73n9tHuYL/kqHr2rP9p3FCX54Cg3vCqKYy0IU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WDyGQQOe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=srDbjVQI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53FMNwpm010317;
	Wed, 16 Apr 2025 02:25:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=xxyy86daiyeuaeMMzPyaNQGD1PQ7xcsCKgk7RsX5Uq4=; b=
	WDyGQQOes6pte9l5p+HcuNv5BpImhybT5vjBUdzu9B881PQDAR7rmkGdXCICbhCx
	31VKn14U5HeyMBwZusJEawlIOwghdLs4yT51+cujp84+Y8zGP7c7UWuSFqzHGsiV
	FhsMjEgBL91fC1aL65Ye0r3PEklkT/Qied3wZVm0vWSYj+HoJl4E4FeCgUAVNzg1
	jMGMzQkXLuirrZ9ggDPKr48kc3obigEXqglcrktLkueF2wO8wLTFcNK/hUq3PiK0
	f6R010YITxUKvv1j40dzinh/XG3/7XMuGRjDBOfMqdwZATQGk8ke64FoakHFPiYG
	70W+uK04kNwQwivF9dYm8A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 461944avsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 02:25:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53G0bLr4024737;
	Wed, 16 Apr 2025 02:25:21 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011027.outbound.protection.outlook.com [40.93.14.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d5169vd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 02:25:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KNXWzj6eLWmtTZ56w48/X7EberKKdOeZ3+pG55TkFKm7tkuMm3i65guYyYPevUwH8mla1bnBbs/75qzi1ON725vilqTV23+TbUqRiVO9QOBtVGHzMEO4dcKEbL5a3kmszceyTEOvNyRfrU5Qdv1uipUx3GgwCONqQriJku/LRNDYZmpCgG06NyYFgaWQVIIo6Yw0sBTc84OSRPe9geYpQGe4G8otW28t0NAVjKFQ8wqDZvvxerJPwzst6pF0t9XQWbdhsVg6gRXv63gfa2Q5EsZqHNGNop0hza5yxEUNoVHQdzSiqPpHsCL+xLL4fPYhdOsZd+N8Ej1YcwUltGMjZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxyy86daiyeuaeMMzPyaNQGD1PQ7xcsCKgk7RsX5Uq4=;
 b=SorzUeBUfwpfA/C0HPLfabu27EtE4FAvHR5ZvwGBAhQy/fdHES+xdyw/gxPPtH72bDlT0B+qUBVs4Kj+IMvUXO8K9XS2SyM2yphTENbzvj1sDf9cjJn4s6nVa+cN8FYfzsrK0PMQ2TsUSnyXMXH8KfmJrEEfBXDl6P07MxA0DHA8MDbg9Ub4q1508q/RYgS7ji+b04Ew9VNgj2+JNRpcYMmdaiHNhgez3VUqagxvzf15SozQNpwWIZZioZ6Eo98GfBnPT9DhkMsvtdhHNxRK+f1g9QEqXFHj4vQUIlaStQCNDsuA90a1txEYuCMSF6/evFzVo7ingchn8yZgay010w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxyy86daiyeuaeMMzPyaNQGD1PQ7xcsCKgk7RsX5Uq4=;
 b=srDbjVQIgf0hC0MsfI+20/pMDHz5di97oC7xt/bSr8yH7+XimaBQ0krqYCCaHmbf2bZVqhAYRpcnx6flsVsNBXqmXUeEmYbljML09qBAWInJ+Zo+gCROXyHJCZ54uzltTRKwe/1lxZ/IlBkR8PPCz2UOXuMNYBlNdxcqR78WNA0=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 CH3PR10MB6762.namprd10.prod.outlook.com (2603:10b6:610:149::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.35; Wed, 16 Apr
 2025 02:25:19 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::da22:796e:d798:14da]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::da22:796e:d798:14da%3]) with mapi id 15.20.8632.035; Wed, 16 Apr 2025
 02:25:19 +0000
Message-ID: <4841de65-2843-41e9-8153-bda1f626013e@oracle.com>
Date: Tue, 15 Apr 2025 22:25:17 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/type1: Remove Fine Grained Superpages detection
To: Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org
Cc: patches@lists.linux.dev
References: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <0-v2-97fa1da8d983+412-vfio_fgsp_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:408:e8::19) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|CH3PR10MB6762:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dd110e7-0383-4043-bf17-08dd7c8dee90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmZ3K3N3WFlJNWhUWFVlUGJ4N3lUdW1BYmZUSW5BUmJtWjhSSmp6Znc5WUR2?=
 =?utf-8?B?OGZrdTZvQkpSYnhKYjA1VzNOZ3FSNEhONU1XK0xOY0VHVWxYVnl0cDE2UG9l?=
 =?utf-8?B?THpaK1pHNEM2bmVFczAya1NkY2hDOTdIOWxSVDdGektpRUxLQklUSXBBcGEx?=
 =?utf-8?B?YzVndlNucU85c2xWbXdraU44elVWZzIvQ1paZjhVSFFqenZnSUJmRG9iMVd6?=
 =?utf-8?B?Qjl3YWQybTk4cVVVa25MODBoMGhJcG5CeFRkM0ltS1gxcE5paThIMEErdndn?=
 =?utf-8?B?cFB6elIzR29KL0hUQ0dHWVFQR09JUjBZdDBmZHFIc2E2dFVRUXlvemV2bjZP?=
 =?utf-8?B?TUkxRXFjSkNpRUpLdlBvTGw2SzJNTFdtTFpXd2N4dXZ4d0ZsUGZZUE5JZFlX?=
 =?utf-8?B?TnI4QWJTNFd6aFhrd3kxUlhsSHhHYXNraGt3ZW5wQnhwQ3hjdkJxMmNjS1hq?=
 =?utf-8?B?MVZKdUhjQXhtQVByUVdQYUJDcnF0NlVTVmRjeWRIL2xtTmNmKzdrQWltS3A2?=
 =?utf-8?B?eFNLRURaT0svUkFGUzlVVDBmWWxNMFBGdlZzOGYvK1dYMk1HUklGRUZpV05p?=
 =?utf-8?B?UGNGZ01GbWF1anR4dStYRktsMEdjQzZMWldzTk0xOVlacWcxMXpnZEdOQXNB?=
 =?utf-8?B?MTRNYU51QkNoL0I0KzdDMFV0WFVHVlFOU2RTS1dqTm1SdEh2Q05zOENhZU9w?=
 =?utf-8?B?YWxjTHRJMjk1eUs5TDJJNTB6SU1OcEFqZHl6MitjdjMrcmdrNnV0N1ErZGli?=
 =?utf-8?B?UEUwYnBFSTIyWU94L2FOd2ZZWTAzZ2ZXc2MrNkYzcmpmWkt1SUJOOFJxandL?=
 =?utf-8?B?eEYrbG5RQWR2VTNQZ3BhWE1iT2FzeU84QlJiWko0ZHJkQTZWNnUwa1ZyR2tn?=
 =?utf-8?B?c2hLa2RBRkY4ek5DTXJCMnArUEZ5SFJZc3hGVStwOGFOdnF6ZjlGam43VXlJ?=
 =?utf-8?B?b3lZU1lwMzFNUG4zWFpVcDJDK1BGTzdmM0VnY01OekpCa2pXc1gwTmVJY2JQ?=
 =?utf-8?B?ZzZMcUFtUDBjVVVCRlZJcHdKK0JkK1FXNDcrNVZCa0FzMDhEcUVTR0ZMdkp6?=
 =?utf-8?B?bTNmWjB1NThYM2k4d2gzT2MyejgyRDNubEZGNXlqR1A3a1NrWlhEMWp5MFlm?=
 =?utf-8?B?SnJSbU9UUzZyTmZTNXgzVDA3eSsyNHJtTEtVWndqK0duTW9Qc1pGSWtzcDNQ?=
 =?utf-8?B?YnN4QnMybWpsQ05pZUxFTmJweUxkVkFDOHpISXJGWFlGcHV1ZERabVgyd091?=
 =?utf-8?B?WUpicmpCNzl6cEtncFBxbmVVaE9zdlErSTRTU2FONzF6bUhkdjJ5eS85S3Av?=
 =?utf-8?B?NVRFeVg1U09PRmNPdi9rellCbVRwZ2ZTdnhGT0d5VWszbUFtb1B4U1lwOG9N?=
 =?utf-8?B?dUxacTZLRTU3YjllNlBmT0hGSUJ6OERoK3NHRTg2Mm44WU1pMld2N1pHeThL?=
 =?utf-8?B?ckRSTmplbXFsYVJBMG1QcnFDbjFnOUs3SzdTMlZjODJuczdqQXloSllPWm93?=
 =?utf-8?B?THB1b0ZXOTJXZm8xOVM5K0hqcks3S1RLcHkzRWVTdGg1aTU5NlFoM1l5WS9o?=
 =?utf-8?B?SDY5bGRwTWUvUytOcktoTlFQVTRWMlgxMXJJZWNCYU00SzNtY0RhalVxbEZU?=
 =?utf-8?B?Q2EzWmZ0SFJTMlpWZWFhWmVGU0g2a3p1QWRoUGlLV2RORzBMb2ZRc2dLdXd4?=
 =?utf-8?B?NGc0SzlGOFJxTHN4djFibktaUUlnbFgwQWgwbDBnMEFpOTVndkI2Q1gyWVdv?=
 =?utf-8?B?eWtuN2ZwVDZrcG0zOEdHVmpYeTRoOHVLaEhMbU4rR2doSHpWVk9ZSFR2Snh3?=
 =?utf-8?B?L3FpNjNhQTFzVE1LZ1FJWWRrMm5nSklCNjVBRkcwR2Nac3lKcG1OVzViZ3JV?=
 =?utf-8?B?UWxsOWRuK2F5Z0l5T2RDb0c2L3RhejRKZklQZHRzT1hXTy9jOGFlN0lGODFj?=
 =?utf-8?Q?gjKSiMA4eNM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RVRzTFR1TFNBN3dFanJwQjM1cjhwZk5WbE1IcTZ4cDducUdTZTFjS1ZIUHJv?=
 =?utf-8?B?bXZWWldWZTFJdGFEOTExYUJ1QUp2eFBHT2lKRnFsbm01bmpEVk9vb1hmaENy?=
 =?utf-8?B?eUZaU2pnaTBXanZrMWdCL3RadEM3RnNiYVFNRmYzUWpvallwNjd3bmN3RzF1?=
 =?utf-8?B?WHlTSmx0YmpoTkF6c0pWNFhXVGZuRzNJU2M4c3dxcE04Mk90UENQQjZiaW9k?=
 =?utf-8?B?UzJrVW9yYWpGbCttUkVPRFZmSSthV2hxNnMvbWZRK2hPQlJyVXRRc2dJT01B?=
 =?utf-8?B?cU1NdDNUcmVRS1pEMCt2QmZNMGR3OVBqa1dVcjNsdUY0YWdzWlNzRTdtZXJ5?=
 =?utf-8?B?VmFTNE9MTWVMTFY5NzlBOU1ESXI0Z1poamt5OTUySnRLeGdGR2F2NkttanNx?=
 =?utf-8?B?WCtuVnU4S2dWNlk5Qyt2eHFtTzR5Y3dpV05ZM3pKU2tuVm1FdkZzSFpTSmpv?=
 =?utf-8?B?eU5qdElYZ2k2cFBxa3lod3U3VGpSTDdpNzVQMjEwWHVQZnBwQ3h0WDJ2Smpt?=
 =?utf-8?B?dzkyZzBiWHFxdWdqVlFSWmM2V29STUdKaDRNMU5PQzFKUEQwSWQyQUVOeU1t?=
 =?utf-8?B?Wlg4MlVYTG9mRWluOGhaNC9TYmdLNC9ta3V3ZzB0dFNSV0xIdVdiUUVVZGxF?=
 =?utf-8?B?cWhUVjhiN1FsZzJwbnkxa1RKL0NhNzhwMUVOR0JHams2anlQVVRWOG16YjlR?=
 =?utf-8?B?S1R5RWdJUGhDMGFNY2RCNENqU2VuMnIrNXYza3U4cVk0Q3l0TFhweVdrN1l5?=
 =?utf-8?B?TnNOMkd1bUg0bGNOcUxnVWRnL1g5V3B2OGRaSHljLzlkUkprZTIrRmI1K1FW?=
 =?utf-8?B?UmprZmhkT2s2ZERjRVZic1dIbEsxOE5IYTlDOG5vMDVXMXFzSUhDTjB2c3RZ?=
 =?utf-8?B?UU9RM3FrYzJWY0N5eVNTcUlScm1CV254ZFRTbkgrNXp6aENzelJoOFVQRzg5?=
 =?utf-8?B?Ti8xYmlMTE9QK094V0labVZ5WVNNc2ZOQXlVOUpxRmtjVFp1emk4OXltbEJy?=
 =?utf-8?B?MENtQTBuN1h5clpwanc4QzMwWXJ0WkFXbkZkVExNWGp2ZFVka2ZwM25NN0dZ?=
 =?utf-8?B?MllEMWc3V1U0dHVkejF5K3dCNGYvTEJ5cC9rdExaZTVmTXVQclNnako2RUdG?=
 =?utf-8?B?VnEvSHRVRGV0cm5HQ1BSUnkzRExscnhYNG55RFM4ZmVIaXZPdFlkQ0o0aDZR?=
 =?utf-8?B?Uk96QmxUOENoanNjcXI2amgrWmZ3ZTlCOXZiaDU5aUJtRzVhV0lGdGdCekZQ?=
 =?utf-8?B?L0VWQVc0YXpkMWFJQk5EZURoaVloa0NXTWlENEpidGZSTUlaOHAyVUFCWEdC?=
 =?utf-8?B?L2orb25MbXFHM2lpR2VoTUdTbXdwUFQrRTFMY2VibWsxS0F4STIzaUVUR1dT?=
 =?utf-8?B?aDQrQ0xNcTVzT3J1Y0pVOWl5Y3hsTWI4VVhQYzNmZTJWRDVISEtBbThnUkVv?=
 =?utf-8?B?VmNkT3VubHFOMWNEM1VVNDZLM2NHSG9mZlpqTzlLcUV0OGRyNFhMbHo1VXpF?=
 =?utf-8?B?aTZGd0lUYUNGaDVtaGRucEdTdW1wNEE2N3dkWkFteVhxbkxzMDJDaE5KdFBi?=
 =?utf-8?B?LzFnRDcxa1QranZPeENhWDh4dG1MMnZ2eW5yclJaMkhHWUlhTzhHckFTT2p1?=
 =?utf-8?B?NGJTVmkrV3JFcWdvZVUxUjI5QnBrYzlhQUxidWFOVXBBM09hMm1DbEc3MVAx?=
 =?utf-8?B?WkdBYndVUGswSkxKSFNaclFhKzVISzhVcnFjQ3l2WmxUZVJPT2dlcXhCdjJy?=
 =?utf-8?B?Sm9DMm9sWmUwQVlsQUhNd3YwV2JJY2dDaUtGcFVqTjY1NHVDRGxQcFhsc1FO?=
 =?utf-8?B?MUtUQ0pGTHVzSjI0ZEVScjBHNExld244Z0ozV0djaUZyTkp5M1dPcU1IRFFx?=
 =?utf-8?B?QWFtNVFvbGk5QjVTT25mb3dqS1RvZ3pKa1pKeXNObnhObWlNam1vTFdXbldy?=
 =?utf-8?B?SnRrbXRJRFBHYm9VcDJ6azNRd0FacUxKMHVlbi9mMkVIdk9wdnZVNzlEanpE?=
 =?utf-8?B?SWkrOUF5N1FpeEVzTWtKOUFWZTE5WlVpSnpyV1laMWNaeUlJSVVoY3VHaXZP?=
 =?utf-8?B?RlhKYU15am0yOVR0clpBclhtTkpWTkNDK2pkRFZzbGgxcnVXanJhTGZzZ2E2?=
 =?utf-8?B?QWJWL0NTZ2RTTUVJaEZVTTcyV0xjZTNHeTJTMTJPbFM0aW5CMW9mUE5GM2ht?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r8Q2TjAuAj+YMqAfVnJlZl/ZQzbpvcpw1syXojm8WdSgiTWZcPl+lwdNJuddntogGZok7dX4udMaZ0jFKgFaISu3xXJfoH+Kbf+w82LiWfIXyhxhxSAqec4U9hVvqetvRKYVaOlr4QmFO1LYTOf268yusrW8/9en8tFvCrG2nEFch/g7oxkY6hUoBED4rLDVQJ36gfjpaIz11UbrR4+Ko8FU1qKtI1Gr26wGcJC42dE+3zeknxisCXto1ALP8HXgTzqWjpghu/otY+mv3vSKFHej8pc9twatVPywqqobmO9yfsl8YwwQp9PN+6zvlHFrN/hlq5mxIvosGohX0WrD34sUzLrVDuJEkqsFmXYH/WU08H0JaMZkz/c3HAuUIud3/DU3JDI5ReSAguBidxfuJbBXOfVqCmcVyVb7mCCz3sjWJvMuE0NWObTU99orK+qRQlIwOnGtoCHCYNk6irnv2F9fgj+u2lMf4iyXvqv4pdI8M/pqpky7D96RhPJXKa/taR/EC8Oq8iXBaA7UDl0JsftnLmNchjMjdo446ibwDXe76FeU4btUQc0Q2yDZ5U2cc/7hWzw8ddKSUBDlQtJasiLaa9Lrhcg84rV7t8H551E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd110e7-0383-4043-bf17-08dd7c8dee90
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 02:25:19.3024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjhWKlNB24P3Mr1ENKu8kV2RQvlzbcOzKrK+cwOcyINWz2H+0YF3X/xUWqCTvSFbnCrfuDXpda89fdrCpzWOvodYITUFiX1iqXm4Oo2pu0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6762
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_01,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160018
X-Proofpoint-GUID: -gq5Mg6-lKaN7TXW3JS2IqM-RmY5_pEW
X-Proofpoint-ORIG-GUID: -gq5Mg6-lKaN7TXW3JS2IqM-RmY5_pEW



On 4/14/25 9:46 AM, Jason Gunthorpe wrote:
> VFIO is looking to enable an optimization where it can rely on a fast
> unmap operation that returned the size of a larger IOPTE.
> 
> Due to how the test was constructed this would only ever succeed on the
> AMDv1 page table that supported an 8k contiguous size. Nothing else
> supports this.
> 
> Alex says the performance win was fairly minor, so lets remove this
> code. Always use iommu_iova_to_phys() to extent contiguous pages.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

Verified on AMD Zen4 host, basic sanity test booting KVM guest with 16 VFs.

Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

