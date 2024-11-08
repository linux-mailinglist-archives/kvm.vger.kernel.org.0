Return-Path: <kvm+bounces-31312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BF89D9C249D
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:05:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BD231F236A9
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 18:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DFF233D7C;
	Fri,  8 Nov 2024 18:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IOAawm9a";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="p1LiJjPg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72584233D61
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731089116; cv=fail; b=I19Ht08UM3B1AuU/ylKwCWwWR5951Gvfe4EYlQlSdXEfuHl9LSEIW1d8q8VU3zZQWMYLGJVWNoN4GEvFJLTf0SXG7BcJmfF+eS8PLCGXZKfrq/2KiLSIkbJWTkOn9nOF1DEbZnMZAMvbzwRKU5+pQXLiiuPz2K/RJbVVHg26/s8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731089116; c=relaxed/simple;
	bh=aqvi+O5cBN4QDWgGwOMEGybTGUg5fW/bNwQ48Y3+Ecc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CG4IYT+t6BZQJXKirNWAvvX4meU9Eu7ek2ukUTZKjdDTQ+sXJO7uWAvBHogoZKoCv3PaEBUrRTFak9HJwmG0SYlkEtJkz2SAY30WJ9I6ogoTmApviP7O4Iv2pzsnSM4jFHsRANuGlmP8lNnnKU2m/pbWednzHPBTLSq0oCB0kcU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IOAawm9a; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=p1LiJjPg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8Ftebp002772;
	Fri, 8 Nov 2024 18:04:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6dHeHC9isMXraueVm2Gl15iilx0Co8HpB4Y/bL9OZJ4=; b=
	IOAawm9a2gNGcedN0hoG4eHkBp+qAWdQxyd9Q3SKIRJmp2j+MYhWAbWHvG3Qh2AK
	01MK4jlply/8GjxmqHvtZvhAGVecNdhBWpTU9uKLBDg0v3R8P8ThM2aJPLlDTgMd
	N4MPa3iKUUo3raAUBy8uFIrPMRZw3kivkh/YAjL6uEiNSnTzyX27igclCeDmAg5Q
	v/JM6jeOB8g0M+IdawIzp7onG33rTxNvMFlWgio7LefduKOz4yeyA3fkurPAe6/a
	aw8WNJCWDv36dizLB/UNrzS4oLBJxe+Ql60uv/sXus6SijFvTcIFHNJ7Oq5pcUf3
	m12L8LWcFt6tU3Td4beB6A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42s6gc24m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Nov 2024 18:04:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8H5HRh013151;
	Fri, 8 Nov 2024 18:04:47 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2173.outbound.protection.outlook.com [104.47.73.173])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahj2xyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Nov 2024 18:04:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H4Sj94lhD7uEX4k+C3P4QUhsYi+HWRxuVebD7Vzow85JKyiWk2urwixvOtJM8Kqs5NeWb4ViRp4B3G7qwYrXCiIYRoxtKGIWAt/4mU5U9jVNtpgeNpLN+/8eeR1EHt++iaOfioCFinRexhHDwmSH4/eeBoSy7jSG3vYnqG+fV8BEhyGSNadOkjcItkG+mlMzmivN/1EmSJmFtwYtep3BAUF+Ehl1kpbcUkmmZVBDSveq6u7Y1Qn7pJ+skakN59PWoZmfiZ7U6oVmhkf42seUcI2MhjVpCnXtlTKpWzW0ndLDuSvc1kjNYIQqrn16lsoXzb5t69d2NrTQScSSc86KQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dHeHC9isMXraueVm2Gl15iilx0Co8HpB4Y/bL9OZJ4=;
 b=my197Yyfn3mZSUWVpWUFddGM/1XA4MPPxDcM+rTr6TuQWXEUWdL2CzLPbptHveNCarsLna4VKBkt/80t2DHaCUekJDvJfvyAiZui7kVzYKnqlQpSiE2CqlYhtMEoW+/3GHn2+kF8CSMEofna/JuSFaE78zgyITAekMYbcmmpJbI/QH+WqJJw+2Wl7qJsEI93NoyZorbUvRHL7yuI/utCL6bs3TAOyAg17f2cdpemBgQxHQIOPxwR01sRGO7NuXwFnlJ5snJqad8H/V12CDNCG/Im4l19zw5mg+ZjGGNMRBSrC5U1rFJHqLNBreqMP+P8oTFSmXQsJJXhQeRwpWI5jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dHeHC9isMXraueVm2Gl15iilx0Co8HpB4Y/bL9OZJ4=;
 b=p1LiJjPgld9nt5m3zTK3MW5RSmTrnJaI2rPyeEIhBezq5d0xC0MXNxXNXjRKhNuD6e1dzP+UaCPh7RLBDYVV6A6SYt5jA0QqPl5tqG1uE/Lye0MLRsdILTthBvkoNFxE5McI/uxjD2HHl9MKY1MAof4Q7OULLMglG+BiR0Y+xoI=
Received: from SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Fri, 8 Nov
 2024 18:04:43 +0000
Received: from SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::a37d:ab3f:9a23:c32d]) by SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::a37d:ab3f:9a23:c32d%3]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 18:04:43 +0000
Message-ID: <659a895c-3c0b-47c7-81fa-6fb73ba1d2b6@oracle.com>
Date: Fri, 8 Nov 2024 10:04:41 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] target/i386/kvm: reset AMD PMU registers during VM
 reset
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, zhao1.liu@intel.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-6-dongli.zhang@oracle.com>
 <a7f9c3c9-09af-4941-b137-2cb83ef8ceb3@yandex-team.ru>
 <4b73133b-1ce5-4eba-a77b-f595e02a942e@oracle.com>
 <94e089fb-4fc3-4320-897e-e8146a226109@yandex-team.ru>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <94e089fb-4fc3-4320-897e-e8146a226109@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0074.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::15) To SA0PR10MB6425.namprd10.prod.outlook.com
 (2603:10b6:806:2c0::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR10MB6425:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: eb476893-e929-4932-9094-08dd001fd23a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEl1VFZkMFQwQkpuazc1aW1lNTNXTkg1Q2VZTVpNQWJWa1BUcmc0NFI1THB3?=
 =?utf-8?B?cSswczBQc3NmT1h1N2lHcGZZL21oQmpyWjJmaVlBYlgzN0VzampkeGk5YnFQ?=
 =?utf-8?B?RmF1cTJ3djBHdHpRMC9UelREWWdPTEM5dUkyK1g2Ty9wc0JHdTRZeVk0b2lx?=
 =?utf-8?B?bjNkeHJGRmNBUWZNQUFIQzUveHh5VTJLTzliUEJGYlNrRW8yQzl6R0RxZ05E?=
 =?utf-8?B?RW0raVJiUGMyZEk3S0pCNjQwZkJESUhuT1lsWXpsMzZ0eG9DN2tzaS80eVVG?=
 =?utf-8?B?WGlJQXpwUEN4K0FxN3VmbzVtQ3VSWWRkOXRWOW44dk5xRHkxSjltd3pVaHFR?=
 =?utf-8?B?eStnci9iMG9jR2g2OEQ2ZkYwZHo1Z1JLMG1ZTjZOT2U0QkU1RTlGUFpDM2lo?=
 =?utf-8?B?anBVdnB6bW5Yd0tGcjR1ZDVrMUtqM1NSRC9wWTk5bitXMnlOSS9mQWIwUnFL?=
 =?utf-8?B?aERnUHBjYmlGZWNMMkNWQzlsMmpybUk5WWJXSGNWaW41SUNkVWRYRkZYQmNh?=
 =?utf-8?B?d0U2eC9UN1NjZUp6alp4OG1xc0ZlVVo5V2tDWmEwdjVoc0syQXBSMDludi9z?=
 =?utf-8?B?R2V0MWEvZkd5bDRCWnI4TWM0MmJHeXBydzhBUUg0VnFmdXA1Y2RMeWF0MVAv?=
 =?utf-8?B?dmNML0JsQUVRZ2pXajByeFFTR0RxY29BMXNsM3lqMk45cC80OUtVTW0xTm5s?=
 =?utf-8?B?NWVpVEZiS3R2aWkwZENSMDgxM2hSTlZnMVZWZEtOcTBRbmQ4dThkNEFuSFR6?=
 =?utf-8?B?R2F6TDZnYnpZVUQzUzFXb2tjYzVvbVNwN1FtVWU2Ym1sV0IyTHFJYVoxbTQ5?=
 =?utf-8?B?M21CQlNPYVdyVEExVnd0ZzNjaCt1WENweWk5bElLcWlWUFhpOCtnMHBNblBh?=
 =?utf-8?B?NmJBakxZZWhrb1hRMnJGenBoNEN1OStmVldZaGlyTnplUHNWM1hEOTVlbU0y?=
 =?utf-8?B?NWZjc2Rra2ZBMzFCakVhZUN4TEZFajVLUzNBd2FxdEFtWU8rRlZ0ZkJHVXBM?=
 =?utf-8?B?Z1g1RnZ4Nm5lMlFaOG52VEMwRDlJbjF3NzJUeGVtY2VtZ2MyeFBHb2NwSXNh?=
 =?utf-8?B?NXl1Y0dELzNpRUZyaXJ1a0NBT0k1QjNpK241U2I4TXBmMGYrRzNIQUtwaEhv?=
 =?utf-8?B?ZjhzaG9EWFUwZUlUWk5BdFd2dzZmenhVbVdxemJnQTlqVUdxMmdaa1FLNkh0?=
 =?utf-8?B?K284elZqWVZKdWQ0RVpVSTZGZ1FtbnV6NndLTE84TEpEMnQzYS8xZ3cwWEhF?=
 =?utf-8?B?cEtxQzBIbHhmdHl3dCsrb2NmV0FadE1HYjZIOURYNGNGUHd3OEE1VFcwZ2w5?=
 =?utf-8?B?TWQ2OVFQK282K1BRRTdGRjRMSzBBV0UwNXp5L2l2eFZQOTluUzFZcFpSR0dM?=
 =?utf-8?B?U2I5Mm92cHhTb2xWL0h2dTBzOHZQMlRGMnRYZjFvL1BMaFMvRGk1bGZySVRE?=
 =?utf-8?B?ajBNS1k4eVJYWkpINytWSmdOcU1lQ21SV0JDS0hxNVBEaXpnUTdzbTVSYWNt?=
 =?utf-8?B?aXc5TXdldHFCSXk4Sm0yNDVrYk4rNDhoejY5NFdPcDduQWdpSHZSVitiSmt6?=
 =?utf-8?B?YnllZjhiMXlzZzNUNlRHeFJ4RXVYSFp6RW0zekw1am45azdyZEt4LzJqek5P?=
 =?utf-8?B?cDNQYzBpTWh6R01sOVFoTWtoRkhZVVc5RUR5QUh0d3dPd0lDb1dRbUFaQUtB?=
 =?utf-8?B?UkV3dGI3NGVjWFh1VXBmSUxPaUw1SDFOQzhHS0NrbytPbmc2TytiVlhLNkVP?=
 =?utf-8?Q?SGDS/Md/f15GyQMdnyXMpkSJGMdrsFYuKf8gzYV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR10MB6425.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUtibG5TMC9JY3gzN0IraHhuYjNKRUZmZk9KT3lpeUV1dFVIRUsyc21zcFI0?=
 =?utf-8?B?WTJFSERUMlE2VWdjYXhSNnA5MW9uOFBTMitpWE1HcEdJYm9JUVRNUDRUWWoz?=
 =?utf-8?B?cklMV0tYK05CUWIyQjNmTnArZ2NJbUpIWTltVnJvTTJnZERsT1BycCt4OU91?=
 =?utf-8?B?ZnRWSnI4NXBFbXNzY083OHFtWDBURWpqa0c5VHhPSVd3cmVMemhBdGV4MUJC?=
 =?utf-8?B?NFNjM2krY3FtRG4zRjg3K09HZ0YrVVJTek00ZkhHV1Z1bmZycVRkbHRXaDFN?=
 =?utf-8?B?ZnRka3dVN2I1YXRjTGUzTnAyUlpuMU1SRHdjcWpYalAyU2pyaTNyRmlMM01P?=
 =?utf-8?B?c2s3QzhNMzcyaDlOS3NrZk82WEtpUitJS1NOZC8ycEtvOUEveDZGSEVzUklM?=
 =?utf-8?B?VFpTQ3M5RXJKMzdraFEvUk9hY2lYUDVZTksvYkt2N1ZVcSs1L0QxZTJRZmtR?=
 =?utf-8?B?aTRUcGpnMG9NcHdMYUtGODRqbktmd3BuSTA1NUxaNjhzbTNwcXI3enRmNDJW?=
 =?utf-8?B?RlhNekVtS2EwWmtseitrUjJVcVMyZ0Nsc3lSNmFSb3BJVkk1WVZ0cnlFY21a?=
 =?utf-8?B?ZUFLU25VMmEzTXVhZy91dkh1NmtQMGgvZzVvYUxJV1IyMmhKTHh3WWI0QXVt?=
 =?utf-8?B?ZFhZRFlseG1LVk9JYlJzTEUxYzdncWlhYkNRUzEzT1dFRXk0ZXFRcnkrZVpK?=
 =?utf-8?B?cUo5dk9MT0Uvd3VCeDRaWDhxWXBmeFhIOEtDbGpsRVR1YWFHNzhpT3FGd3F1?=
 =?utf-8?B?ZnVrbVA1ajB5eTZlYWJaOHhndTczclpqSGQ4Yyt2eSt5R0NORytBYmpIZHVo?=
 =?utf-8?B?OHpyWjdod08zeTRUZE9HRThXdkRYK2NKMm41VXpYTGRFdXlBTjEyU2hBbUY3?=
 =?utf-8?B?UmpZbU9mQkNqemU5Ylh5ZE9aRDJrSTFNbXdpdmwxUDNCQXgxRnVRb2JOdHMz?=
 =?utf-8?B?Uld0c0Yxd2ljKytoY3JkbEVRSENLWWFyK2N4WDdIWlh3TXEwZUlCRmpITitK?=
 =?utf-8?B?dlJDUSszWENIY1hGWXlGUVBVc0VRemlZWjh1S3Y2RXRMRElSY0VyUXdFVWtV?=
 =?utf-8?B?d1B1cFhMK1g2czRucGgwUVBnZmpBc0VwUCtGUU1TRkM5dkRyZlRQMFlDMEdT?=
 =?utf-8?B?SVNwaDlJb1NiWHZXMmg4RlhQaWJFZmc4ZFZtOFMwWksxZU1sd1drS0ZYbHp1?=
 =?utf-8?B?WkpaanFJQS9xY0h5MW14SksrMHJ5THdrb0FRSFV4YzFBSTAyMnVzMTZsM1dW?=
 =?utf-8?B?WFpCMTZidm93MnMwYWFOdy9oeEhScWdSRDRHOFFCZzBTZDZKcGYvdGVCQlpk?=
 =?utf-8?B?aFQ1bEp2Y3RlditVSnpWK1ZkcHMvZUFESzI2TkVCTm9PeSt1YWVUaTV5ZnBq?=
 =?utf-8?B?TGc0V3pMZzFVaUxDL0t6SmNrbmZ1UkJFQmxjTVRYVnJmY3g4YlY5STZXQXk2?=
 =?utf-8?B?dlNuK0tFY0h5a1F2QzVVUG81c2lRZE45TG4wd05hbUpxb0xDWkgwZ2JIUmpV?=
 =?utf-8?B?MVB1OU5kNnEvSitScGZtRElidEczM1lOU0syQllXMXk1RWxCWjJFODJaWS9j?=
 =?utf-8?B?dnZrUWFXUnk1UDF2RE04aGkzY2tSR0VvK1A2Tm9JVTdvSTVGTGFXYm4vVW5n?=
 =?utf-8?B?L2JhRGR0UzZPMG5WTmNvc0lHQXdSNWhzc0hmVzVwUUJXVEcyL0ZzZWYvOVFZ?=
 =?utf-8?B?eC9EeEZaTm9tb29maVVqRTMxdGwvQWdDcVlURjJ2aWp5U2M5b0VQVTlCZUdz?=
 =?utf-8?B?VWt3VFZWNlFWZmxUcnhmVkFLM29JTkJJcGJkYmY4OEdRRkl2YW9LZ29zbXpx?=
 =?utf-8?B?NUZiejFJejJudXhRTk1OaGNQT0M0YmdnMDFMcytUcVFKYm5SZ2syUFExT3Fx?=
 =?utf-8?B?NzZNTUtVZGdmSk14cUtHcFFOb2Jtbmc1WEZDVW5QcEhzbFU2dDUzMVNqc2Zz?=
 =?utf-8?B?TVljWDQ0V09sKzBWSkdVeUZpeTFTVEs0NW9rN3VXVWRUN083MW5LclVFTDB0?=
 =?utf-8?B?RjhyWks2eW9DZzMrbGpNWDl5WGpBWjJIZ3EzNldSa21qSjBZV3Q5bnh1WWhw?=
 =?utf-8?B?T1hNUkNRVXhiMnlpUFF4aXN6S1p0SThvU3lJWWVjUWNvMWtVYnlzZ3pvWCtF?=
 =?utf-8?B?WG5xTXg5NlM5MlVPVllPQ0lyazdBRTk2NkxjNUo0VHhRVXFMYlcvOWVCeE4v?=
 =?utf-8?B?RWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q0e2PjoKIN0gAYOmTJiN18AODk0wbJ4kU8k+EFqbNuy7ebtavjr+6kUeYi0z2J5WZf/d63R0zFv2GlDboR7fdd4LRGVuzYP/Ap0fIXkWtX9Lagh0BVZKBT9SLkbYa6+3vsB0E1Ey9TFygeQ1tAyWcozOQCiSQYskeDGXyHN7Hxvqej6OUCjRlbb1e2JKl34dKLNafw05HVjOmAq7RKLwW13IFHc5fm2ZGfo64b5sW90qRMyVA+15qTc3cHUqldqqjsc1PmZ6n15uns9BbcOAuylknFDT76RwsXdcVrPHV0sgaXV6bLzIUjx1+03mq+SfjbDoo1MLNaW29ESQALLOLmq1IZCcjm9zWyhoS2Iot0NsKTE9LaJX3CliHPAKINEk9ncVl4dKWxQs22Mi7kU1pLPKeOSXhfSiBT0iXS0OJDvmqFx90h/9CAr1IBAz3pL0jB7qTVhJxY9vMz9L+HLx7pBRdGV2dmpFfUYlb/S/b85rDoniF53ti1RHuHw3bYa2UMcONBUvwvifKIPDJhbSmPx276bwPD2qiFWzgkVghK8BF0jgH0OmSF4XRVpVi5AcLlW/J6MUwl2sNiulsq5Ce0TBGHzi6yETXGvRNDxxEBw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb476893-e929-4932-9094-08dd001fd23a
X-MS-Exchange-CrossTenant-AuthSource: SA0PR10MB6425.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 18:04:42.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eOqQfLCrIGLebpCtmNj5XwvngzFxxX+MDMUwn+z5GW+BC7nd48t72Cfbt4Ya0mEEutsbSgj/NCfS34xALrVUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-08_15,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411080149
X-Proofpoint-ORIG-GUID: b4TjNiBG6o_gyF4ldf8h9uCp0u_ljH9l
X-Proofpoint-GUID: b4TjNiBG6o_gyF4ldf8h9uCp0u_ljH9l

Hi Maksim,

On 11/8/24 6:07 AM, Maksim Davydov wrote:
> 
> 

[snip]

>>>> +
>>>> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
>>>> +}
>>>
>>> It seems that AMD implementation has one issue.
>>> KVM has parameter `enable_pmu`. So vPMU can be disabled in another way, not only
>>> via KVM_PMU_CAP_DISABLE. For Intel it's not a problem, because the vPMU
>>> initialization uses info from KVM_GET_SUPPORTED_CPUID. The enable_pmu state is
>>> reflected in KVM_GET_SUPPORTED_CPUID.  Thus no PMU MSRs in kvm_put_msrs/
>>> kvm_get_msrs will be used.
>>>
>>> But on AMD we don't use information from KVM_GET_SUPPORTED_CPUID to set an
>>> appropriate number of PMU registers. So, if vPMU is disabled by KVM parameter
>>> `enable_pmu` and pmu-cap-disable=false, then has_pmu_version will be 1 after
>>> kvm_init_pmu_info_amd execution. It means that in kvm_put_msrs/kvm_get_msrs 4
>>> PMU counters will be processed, but the correct behavior in that situation is to
>>> skip all PMU registers.
>>> I think we should get info from KVM to fix that.
>>>
>>> I tested this series on Zen2 and found that PMU MSRs were still processed during
>>> initialization even with enable_pmu=N. But it doesn't lead to any errors in QEMU
>>
>> Thank you very much for the feedback and helping catch the bug!
>>
>> When enable_pmu=N, the QEMU (with this patchset) cannot tell if vPMU is
>> supported via KVM_CAP_PMU_CAPABILITY.
>>
>> As it cannot disable the PMU, it falls to the legacy 4 counters.
>>
>> It falls to 4 counters because KVM disableds PERFCORE on enable_pmu=Y, i.e.,
>>
>> 5220         if (enable_pmu) {
>> 5221                 /*
>> 5222                  * Enumerate support for PERFCTR_CORE if and only if KVM has
>> 5223                  * access to enough counters to virtualize "core" support,
>> 5224                  * otherwise limit vPMU support to the legacy number of
>> counters.
>> 5225                  */
>> 5226                 if (kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS_CORE)
>> 5227                         kvm_pmu_cap.num_counters_gp =
>> min(AMD64_NUM_COUNTERS,
>> 5228
>> kvm_pmu_cap.num_counters_gp);
>> 5229                 else
>> 5230                         kvm_cpu_cap_check_and_set(X86_FEATURE_PERFCTR_CORE);
>> 5231
>> 5232                 if (kvm_pmu_cap.version != 2 ||
>> 5233                     !kvm_cpu_cap_has(X86_FEATURE_PERFCTR_CORE))
>> 5234                         kvm_cpu_cap_clear(X86_FEATURE_PERFMON_V2);
>> 5235         }
>>
>>
>> During the bootup and reset, the QEMU (with this patchset) erroneously resets
>> MSRs for the 4 PMCs, via line 3827.
>>
>> 3825 static int kvm_buf_set_msrs(X86CPU *cpu)
>> 3826 {
>> 3827     int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
>> 3828     if (ret < 0) {
>> 3829         return ret;
>> 3830     }
>> 3831
>> 3832     if (ret < cpu->kvm_msr_buf->nmsrs) {
>> 3833         struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
>> 3834         error_report("error: failed to set MSR 0x%" PRIx32 " to 0x%" PRIx64,
>> 3835                      (uint32_t)e->index, (uint64_t)e->data);
>> 3836     }
>> 3837
>> 3838     assert(ret == cpu->kvm_msr_buf->nmsrs);
>> 3839     return 0;
>> 3840 }
>>
>> Because enable_pmu=N, the KVM doesn't support those registers. However, it
>> returns 0 (not 1), because the KVM does nothing in the implicit else (i.e., line
>> 4144).
>>
>> 3847 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 3848 {
>> ... ...
>> 4138         case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>> 4139         case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
>> 4140         case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
>> 4141         case MSR_P6_EVNTSEL0 ... MSR_P6_EVNTSEL1:
>> 4142                 if (kvm_pmu_is_valid_msr(vcpu, msr))
>> 4143                         return kvm_pmu_set_msr(vcpu, msr_info);
>> 4144
>> 4145                 if (data)
>> 4146                         kvm_pr_unimpl_wrmsr(vcpu, msr, data);
>> 4147                 break;
>> ... ...
>> 4224         default:
>> 4225                 if (kvm_pmu_is_valid_msr(vcpu, msr))
>> 4226                         return kvm_pmu_set_msr(vcpu, msr_info);
>> 4227
>> 4228                 /*
>> 4229                  * Userspace is allowed to write '0' to MSRs that KVM
>> reports
>> 4230                  * as to-be-saved, even if an MSRs isn't fully supported.
>> 4231                  */
>> 4232                 if (msr_info->host_initiated && !data &&
>> 4233                     kvm_is_msr_to_save(msr))
>> 4234                         break;
>> 4235
>> 4236                 return KVM_MSR_RET_INVALID;
>> 4237         }
>> 4238         return 0;
>> 4239 }
>> 4240 EXPORT_SYMBOL_GPL(kvm_set_msr_common);
>>
>> Fortunately, it returns 0 at line 4238. No error is detected by QEMU.
>>
>> Perhaps I may need to send message with a small patch to return 1 in the
>> implicit 'else' to kvm mailing list to confirm if that is expected.
>>
>> However, the answer is very likely 'expected', because line 4229 to line 4230
>> already explain it.
>>
> 
> Sorry for confusing you. My fault.
> I tested the previous series on Intel with the old kernel and QEMU failed with
> `error: failed to set MSR 0x38d to 0x0`. So I expected the same error.
> But as I can see, AMD PMU registers are processed differently than the Intel
> ones. Also the default MSR behavior in KVM has been changed since 2de154f541fc

I think the AMD PMU registers are treated equally with Intel ones as by the
commit 2de154f541fc. Both Intel and AMD PMU registers are in msrs_to_save_pmu[].

The objective was "to avoid spurious unsupported accesses".

> 
> I think that the current implementation with additional parameter pmu-cap-
> disabled does what we expect. The guest will see disabled PMU in the same two
> configurations:
> * pmu-cap-disabled=true and enabled_pmu=N
> * pmu-cap-disabled=true and enabled_pmu=Y
> But in QEMU these two configurations will have different states (has_pmu_version
> 1 and 0 respectively). I think it should be taken into account in the

Although the unsupported MSR write doesn't trigger any issue (thanks to
msrs_to_save_pmu[]), I agree this is the bug that I will address in v2.

Thanks to the reminder, indeed I have noticed another issue to be addressed in
v2: something unexpected may happen if we migrate from old KVM to new KVM
(assuming same QEMU versions).

Suppose one user never notice "-pmu" doesn't work on old AMD KVM, but still add
"-pmu" to QEMU command line.

old AMD KVM: "-pmu" doesn't take effect, due to the lack of KVM_CAP_PMU_CAPABILITY.

new AMD KVM: "-pmu" takes effect.

After the migration, the vPMU won't work any longer from guest's perspective.

> implementation without pmu-cap-disabled (which was suggested before) to save
> guest-visible state during migration.

Yes, I am going to revert back to my previous solution with "-pmu".

Thanks everyone's suggestion on "-pmu" vs. "pmu-cap-disabled". To finalize the
decision helps move forward.


Would you mind clarify "without pmu-cap-disabled (which was suggested before) to
save guest-visible state during migration."?

Would you mean the compatibility issue between old QEMU version (without
"pmu-cap-disabled") and new QEMU version (with "pmu-cap-disabled")?

Thank you very much!

Dongli Zhang

