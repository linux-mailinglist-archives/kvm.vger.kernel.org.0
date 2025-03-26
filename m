Return-Path: <kvm+bounces-42085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE289A72762
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 00:52:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 486AA3BB874
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C975264637;
	Wed, 26 Mar 2025 23:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AaKE8Ny2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b2LKBIHc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7D71BC07B;
	Wed, 26 Mar 2025 23:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743033106; cv=fail; b=eCXbbdbF9qg5GEmo4wWfrqghZGUdW34ZjV4dCltaelqpdZSusP/FHcy2RcjxvY5xAa7qhG+uSNzS45s02UgsUrJgdrprZrIOFjok4+uBBNtDNvl9DqJwbw3xCV7/kW6zFN3BG3WDsOqjgYLY+u5K7jX3cn/0ULejV+2ZpndY/+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743033106; c=relaxed/simple;
	bh=wt/7Iu/Hg9f3kXFY+ON1fY56sWQRNibP5KT8OvfeqLo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FXi+OkJLRIlumN3jiyR4xlfRjFuaoVOm5YdhzpisPyBKBJJ2KNL39M4A93uk6wrelkR5qnseNHGkdl8+F+Mb7AbwcByzugwxoG7fZKWS+0jrIGEqttu8U8pBmiLVoM4FyzfFtoRqcp+bTbDLZBCh+9djqUbkUe0Dunv6y+OHO9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AaKE8Ny2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b2LKBIHc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0ab8005148;
	Wed, 26 Mar 2025 23:51:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=st0FcgFtCpojJKZV9KVQUkf1UKOUqpNE8b2N7HZrHE4=; b=
	AaKE8Ny26iczp+mkDztBZsI7jnc/zMlLov1wZhUlYGrN0IgfmscwJ9W9QZ3jE0th
	OVZvU/mGR57FAW9LBTSNtRNizfj6uGraHSrv2zIi/34ieUEJHF0oh51rZ0OO+pwZ
	FHw3e+2cWvj08iCu3AZg62t++i0OoUcyqkSG+fRXlubRTP1EMlDj162hzqVP3tUh
	qYd6JMoMEfVq55pu/1vq7d/YjVbMr2gbx2kdTpooc+F98wVHryaram1ldirJyWRU
	akXJUjVr54ad8A6oM3+hqlFlTiotBrQU0PfaHH8OihWdWzG8pQfhA1+JsIWe7jvu
	ZvJkqDJmkgar7H40TZnlnA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnrsk0uu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:51:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QMpGrD029541;
	Wed, 26 Mar 2025 23:51:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jjc32xch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:51:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXbe1vzedShDGpyIdnzEr2YnCfzl2MZPhQKtuEmMgOyNkHIpWTuaV4nTWB/9QdyOAAaG2GZ6haA+T42e7lAgxJErAiCYpacVp55rdU51+hOlnoD2G/6Islm55ZeFFqpJFlIftS/+WfCMf4ZHANjWoaNoHYc2NnBsDKZLy/qtZm8A9Xi+2qzGe62ouGyoGaXqbi+8EcPtm7DfvtMxgdR3A+cR+GZy+AAYA/vR0yLuZ3zjcp0a60buDhsDeDBaXTXuTFRtythy0Vn1vskeI4X+NuZPeJThEaXq3BXCA/utw8xLJcxK6/8UPOuZBEJ+xp7qrPKjjn3JvaOpvswEWXBUcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=st0FcgFtCpojJKZV9KVQUkf1UKOUqpNE8b2N7HZrHE4=;
 b=nuaEQgcT1vS/lOberC3nHmwrBOqa9uFSQlGUtHMMD+ntlW8qXd4kXUKT3vYsNZkYqxg1LS+SiHJ4ZFdJRIG3Qfb0ASMtFj7X0inRpuJQQ6Ehm6BtDwpeKZpVHog60QfFPwW9JtbCKEPT9ZTqXPdzLhKyS/SgvJv3HZdx/9D2CFYwgLonn5QQSQFJFCl94FbhYYHDbaM28qIQvMHPhUSU0357phaMn3Q4PuCGKkAWIwXWUNXoG1kJtFsWykaGBKgm5w3i2KBz6VioozKAZCvpE77d4UTsFDfyzGeRKLqb7ncLgPQHLXM+BnifmVYW7+Uf9HrMZUPz+MHBQBsEGgLDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=st0FcgFtCpojJKZV9KVQUkf1UKOUqpNE8b2N7HZrHE4=;
 b=b2LKBIHcHTBHXY4eZh1QnzSBxH2sNqD6CoLYlyirnRG9H+MbkAEozHKjX8qjybR6uibXuzul/LO0sbm71joQfUQArx/2XAVNmwYWNlxsvn8dm7SPlcjEuJk0U9/OiBmvvYRz72ElWTJ/T4iNqc06f4RqBmojs7sIwH1epxeI1/k=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BY5PR10MB4209.namprd10.prod.outlook.com (2603:10b6:a03:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 23:51:36 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 23:51:36 +0000
Message-ID: <72c5fc8a-d011-4153-b352-eafb065d76a7@oracle.com>
Date: Wed, 26 Mar 2025 18:51:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/10] vhost-scsi: log event queue write descriptors
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-10-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250317235546.4546-10-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0066.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:224::17) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BY5PR10MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: ff8544b0-fd83-4a92-73db-08dd6cc12532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2JUUjlncTNVaUhFWFhzWm5DbnhuZnFXQ1h5UjRTTzlJTnZ1SUtHbzNoMzBR?=
 =?utf-8?B?Kzd4S1BBSi9oaXNWSlFVUGFxN3Z1QS9uNnJoMCtRbmpkemR1dGI0QTdkNjZp?=
 =?utf-8?B?RXI4dTVOTDRQMDl3MFhiWFd1QnZiL3pVdHNwYTQxbE9PRmFjSHdQR0Y0c3cz?=
 =?utf-8?B?UllsdzVSeXlocC90UXNNMDVoZEIvRTVaTTlWK0Q1SytDZUZDSEhuMEtmUTRq?=
 =?utf-8?B?Z3k5MjRwR3dTUG1TMUdVMGFSYkl2cFVUR1hKVjZ4b211SDJJeDczTUlvMGJE?=
 =?utf-8?B?NGZYaEdPcXltVU0zbzB5NFBLV2FZRlRhNVE1QmJ1NCtabjhDM0pFcm8wRStG?=
 =?utf-8?B?Vnk3V2tTTVpCWDNlMGQwdlJTYzV0RzJRcHM4ZGpGbHlPaHVaV042eVFKcnV6?=
 =?utf-8?B?ZXVLQkt2ZjdlaFNIRmxrVWRHN0xvZkEyTkhEeXh6SHVybG1sSWJVRXpYdG5T?=
 =?utf-8?B?cllZK1lUdGJqUEF3bDcxbW1kdC9BT0E1eHNOclp3RVRMS2hSelU0SzI1V2pG?=
 =?utf-8?B?My9FSVNKN2NaZUV6STNva0hwVTF1QzdkSC8zOHdYa3A3T0ZYeUVwS3BiWnI5?=
 =?utf-8?B?UDdqNGZiSHAwZ0lTQnBLK0loMy9sTkZzT0J1NXprVmw2eTFOb1oxLy9UMC9U?=
 =?utf-8?B?NHpJcnZrTWIzOEhkZzZROTF2dU45M1VMNzB5YWZDZkJySkZRNmNPMDZVWnVh?=
 =?utf-8?B?aXMvWElGVWgycmVoWkg3YTBpQy83enAyYWtTbkEydFFYQjUvUHRtSk90anFj?=
 =?utf-8?B?T2g5cUxNSmQ5YXgwaDNEM0F5bWo5NjNXV0p5RUNudmFJUnNTa212NWVuNDM4?=
 =?utf-8?B?WGtOaWtIRWlMWnBjU1dWTDRpa1lNbnM3TXo1Z0JjaXlCU2phWTRPVFYxYmlk?=
 =?utf-8?B?V01tcHNRWmduS0Q4ZkFOaW9iZTNCVTBBNytEVzU5cWtTQWM4NlY3NXRkalNW?=
 =?utf-8?B?a21NbDlvdzZlSFhnazd4VGltYzhNcS9UdFgrK1o0ejFrTWVoWk82RkJEM2Rs?=
 =?utf-8?B?YlRpRTV2dnFNWHlsa2JCQjZ3bXNVMXV1aElDTGd0WWJidkdYdzNPSkxHRnlh?=
 =?utf-8?B?WGhkcm55MktZbDRPOXhMZWdLaHFOTjdjRUpxb2NJVjBZb2NuQWJzbC90bXVm?=
 =?utf-8?B?clpkMUMxdVlEbWVpV0JvRzZJR2I1VzdRc3hRaTQ5ODhHOC9SMG5jOTBaVzVt?=
 =?utf-8?B?Ni9YeVNDQkdBNUNmZDI1MDk5dnd4aHovTU9HVE5IV25VaDNrandxZktLbTFV?=
 =?utf-8?B?S2FjVzRZMFBUNzBjemRNU2xPcStiT3IwV2lvVTRHeE9hNHJzSDBobXZPYWhB?=
 =?utf-8?B?WFJselM4SWVpeVRpb1o2TlIzdTNoSmQrcmQ5N2lEVFgvY3VqZmd0UEV2d2ZT?=
 =?utf-8?B?ZzdOT2YxYnhtSnNDV0F4NmVUT2lSdG1XQzMwYWRuWXNhaDBVMmgrWU1lL3VL?=
 =?utf-8?B?cGZOa3I1T3R6SWNYaGZKM3RPdWhON1dZMHlETXl0MjkwZ2tyQlpFOWUwR0pH?=
 =?utf-8?B?QTk1S3l1SWx2NFhwT0pZQnJtNUpUbXcyc3JxajNYeWNneHZLRTBSNlJ4VXAz?=
 =?utf-8?B?YkFCYzFwWnBWdFhIait2SVM4T2FTZE5FMExLcWRneC9TdjQ0cHZ6SE5SV21y?=
 =?utf-8?B?YnZ2ZEdKQjd4S0wyV01tK3pTWkh4SkpSTGhIejFyK2J1bVl0cEpQSGgwTzg0?=
 =?utf-8?B?b3Fnb2U1SS9ZclUyTmh0ZmhHTld4OThVZFpoNUU2WGJBeW80SlR0VmVLRno3?=
 =?utf-8?B?a0NtdXhhSVoyNUV5OGFCT0hqMHllYXArTDV2RUFzVWcyRXBYVDZCSHJGSUxG?=
 =?utf-8?B?U0Y1ZmJJbHFtcjlhSGFmdHVueHRERzU5QS8rd2tWbTlteG1Hdlo2V1FDYmlw?=
 =?utf-8?Q?ke2jpHqdAj6Cy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjJVZjI0NzdRZTFBeXBYM2l3MmNqb21sTXhEMlVIdkpmbGpEaUhCZEU2MmJk?=
 =?utf-8?B?MVI0ak5OZTVRUDZaNXFrZ0d5WTZTTUdydWJjYXBZSUlQSHhYVGhnbEs4MXd2?=
 =?utf-8?B?T3Z6b05UK3RHcGxwTC8xZ1NIbXA3blVSakdsVEVpd29wZzYyaVBaNmpHTjlu?=
 =?utf-8?B?Qm51V0dFajd0bDhwMUtWci83a0hCT3JqTnoyRXh2R29NQzNwVWp3cjZyUWVL?=
 =?utf-8?B?blQyamhqWEpYMTdyNVUvZFd0MjdUdHQ4NHp1OGFSUFNJTXJBTVRsZUVWTlAx?=
 =?utf-8?B?ckRjMTdIbWZmeENsK0QyeG1JcjAwd05tRU9tSmt4ckQzWWJuZjN5em9hSVJQ?=
 =?utf-8?B?KzV2dk42UGxmMmNWc25HRDI3RDE3a2NFU29BRW94NVVvNm13SE1zRk5QTXdO?=
 =?utf-8?B?QlptRnlDWjVPSFA3N2lmSEFINDJ2RVNLRmxwMWVXVlVtalFmQmh1dnlFZTNZ?=
 =?utf-8?B?cHpyTWRXTjZMWWF4WER0YVFNd2xMRDgrMDdaZ3BEV2w2RG5JdSsyTGFMampl?=
 =?utf-8?B?V0hiN1J3c2hqU1dzVkN1cW9pdjZuU0tjM2tHZWhLZFBHVDZZZlRRSFN2emZ1?=
 =?utf-8?B?NlRyZU5vbzIwZzhmVHRra1hJQUo5MkFabnFYdDVxZjl4L1QyRWRYbjNHTkVz?=
 =?utf-8?B?VU1GSm5JcmZXZHlsU2M0YWZIS3dSeTRoMmk1czlGeG1jRTRTK3o0ZEx2dE5a?=
 =?utf-8?B?WC9lb1cxcVlWZk9tYTdoWVVLQjVPeTNrYTlxWWcrOVB1ZXQ1aVYrN3VVRDRT?=
 =?utf-8?B?aENmbkQwRXFOUytiWG02UGFlUWRyd2JhY0R2OHhQaXhHNUoxb24yVG13OWox?=
 =?utf-8?B?YjJRMFlTd1VKL3BBQm9xanBoZWFSOEZHY0pFNkpiZlBaeWxGaWlvUUNocVJB?=
 =?utf-8?B?UFR6MGxGVzNiSk1TcGsrRVZPWXYvMTFHZHFJTGlmWUlWaHdjUXMybzNKQVcv?=
 =?utf-8?B?TnRLRzgxZ3AyT1hEWmovNk5mM21xYWNyWGJrb1RiNWNXb3QyeWk0ZVZ5QlpJ?=
 =?utf-8?B?UWVpc2l2TEZJMnJTR0xyZ1kvM29lK1AvbktUTGFTZ2twc0dwSXE0cUIvNkRE?=
 =?utf-8?B?RWVRbUF5ek1xSUVoZWlyVkpXYThJWG5pSUc3SHdBcjNoN0djMXlyQXE0Qno0?=
 =?utf-8?B?Yncwd2dqeVlyRjl5SjNSMjdXenZYdmlXbHI0aWZhK0IrQzJLMFdTK2xQWkV4?=
 =?utf-8?B?SU0wa3EzRmNKU3ppSXN0cU9WYkFuWktKWDlYRWlvQnNtQzIrZVM0TG5uODZE?=
 =?utf-8?B?Z1FyOGxveTBaMmZsekExandsU2ZhQ2FXMUdxbmQyOGdwRmhUSk9tYndRZkU4?=
 =?utf-8?B?QmhYaFZaRzlRU0xaK0VHWi9OUGwwZncveFZGUmxkK1c1Q2xkamVYWnZKU0gz?=
 =?utf-8?B?eHZtSmd0MkZCMWpjTlh2clExem1RQ0F6encySkwxMk5FZGdPcU1vNGhQS3R5?=
 =?utf-8?B?NW5sQTBnOEp0Mk9xNHByeWRVNktkWE5JMWJBZDBQUDBTRUFYanhQN0dzTVRI?=
 =?utf-8?B?OWxZcnpidVBvc09GQ3VOK2doekc0LzlQUUlVRzREMDU0Tmd0MC9ZTEdUU3F1?=
 =?utf-8?B?LytEUExBaEwvS21zd005QzVlM0FkT2R0dWVra3FiVkw4RXZnYUFXSXc0RUg2?=
 =?utf-8?B?K0kwUkVlK3lsRUZ3RVNPRnduc1ZTMlpseFpsdFlzM0twV2dSb0pFOU5UN21E?=
 =?utf-8?B?dmRLT0hxWHFCaW9uTkVNQXNqVE9RVGw1MlZoME9nWFlleHpaZDVwVThvUnh0?=
 =?utf-8?B?L2xXMU9jb1duRnQwK1ZSYUxzRTF3OU9kZElkMVFYRXpwdkY0cGlIeXB1dWlL?=
 =?utf-8?B?L2w4blhXaGU4L3ZkT0gwbnNXc2ZYNmJ6NUh6VkpHQ1VVcWd3eVNLSklqdUdp?=
 =?utf-8?B?blFDNkJQR25QK1dBVUFwZTMrVXVialpEWC95ZmpYYlRURHRPVDVRd1FTQyt6?=
 =?utf-8?B?NU00WGR6WWp0S3grN29ETWdLVTNpc1R0dFJ6S210UnhlRnFiK256b0dMVmlY?=
 =?utf-8?B?VVdXNDBXZDdzQm0zM2NTN2VNVkJieGM0RjlTZ2hmTFVocGNDZTdpdk9teGpU?=
 =?utf-8?B?S1NxbDRWWXk5byszanpRTFlwck5oSUJyMWZBLzh1YURrc1NqR2JCT1FWeE5j?=
 =?utf-8?B?RkNST0F2enJ6RC9ueWJab1E3SlVBS21WbFgrUmVYdlNjeFl3MnVGNFBmbU43?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PRbTZf6YER9oYw7huxx2C/ggCsi7EUG1+xBKD+Jmsl/sWBpt/J+TN7AGrXGQOkqOFo9zijIhI4TZuz2FPgvqEnz25FPOdVQKPugQ2M1TW7sGqLilnSt/DjRIlBdrmXLSbqlKvf2ZtFexXOrnFfSropaNwcCiyosBnFWQsiKhg9BjoAPOnYHvqV4iag2a4z/9spuW1AVOPAJCb9PPBeo/0q3qTn0xJDdzZ5KSCabVrYUhnx9hS8nQ8XVcYq+7EcATwcrE4maC81rVyrRX9NNh2cWmduZZb3oO19VGkbNMSp/XcCyB7wP0IAEFi9V00ktaO35wVP2rk+IDeoL+XlZ+Krz5Q68or+2xTq1IndFyft4z2q12nP5FXPPiJp0c+dHZNMRTlsF7l0QdmSnKFa/3+MLLcFtcB7gWD+JJ6IadRZDFSnEE+a52W39fUEGQegDB01On7+1FonctUrCDhc5axAfRKploNT2PK1Ly749URkfMxa4jrkfJOgYK0mrYD+o4QuC1WwTwzhclj0kNK338glnRAyCOs5wlEScRRFx8XfNoiwKyCZCs8Lx0pjUexChRZLfUeEbexu347XdzJ4Ix/k5khutOlmH5O3Iju/dMofI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff8544b0-fd83-4a92-73db-08dd6cc12532
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 23:51:36.7109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Udls2Ei6qXKlH/sEdHo8TeoH4f4EDwd+BjLm7bmZQ8oMrbPOuZO2evHLRlguI8uucQ9VCt0Yb3JI6ntfp6W4uvt/0BnJ5HQbYqh4nmgxRx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260148
X-Proofpoint-GUID: c9v18koqkApx93SoHW39buMAQWtiLcXR
X-Proofpoint-ORIG-GUID: c9v18koqkApx93SoHW39buMAQWtiLcXR

On 3/17/25 6:55 PM, Dongli Zhang wrote:
> Log write descriptors for the event queue, leveraging vhost_get_vq_desc()
> to retrieve the array of write descriptors to obtain the log buffer.
> 
> There is only one path for event queue.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>


Reviewed-by: Mike Christie <michael.christie@oracle.com>


