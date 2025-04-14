Return-Path: <kvm+bounces-43205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A982FA8764E
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 05:47:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8C08E7A5D9E
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 03:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC2DE1991B2;
	Mon, 14 Apr 2025 03:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NNNjpz5E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nSYSmRTS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32040748D;
	Mon, 14 Apr 2025 03:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744602462; cv=fail; b=nTlkr0tE9oPKxCEU3J6GPhB7FpkM+eoPVAgJywMxyv9oTgET9YANkyhMNtGlN7SdCzQt5M1eYlxE5A/6+xoVs5+mjw/376Lv5t1fx/8y2KcXdq5usNJ9IEHaAJPvoh3/FEHi1s7eQX6UfB6gUfgq0AaSPAArnNOQsvhXHTx/dBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744602462; c=relaxed/simple;
	bh=G1EZWWVOA0mRmK56CWGj7yuPtL9eQo3W4VKjcqnV83I=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=V59y+yxWvOItMgeaP1bWGYGNE3fuZHMBCkySEU++jw8TIZ72VYRV5Oyhkq4wQPdBklo50eMZKYAihCCwdnIFGsPJxznQwF5oEWaThE+FarKedROPx6AsSaCay+LVR94TUrKpcAG6mDvgyMLrvDd936eaoAcqNmMhauFhl4jouTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NNNjpz5E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nSYSmRTS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53E3MKj7000707;
	Mon, 14 Apr 2025 03:46:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=F3VfYigKQBAt8uXuUkn6BnF/R1lIBfpr3SbE/zluzU8=; b=
	NNNjpz5EmbI7O8B3OJPDVqdMW8fBBxQ7QTutcdC9YwEotsFdARVPw9D1i6LVk7B9
	PyZD6ZNhZrDLaf+6iVk698R340Tv+1McQnrrODC5SPhcSn30DbcrMasKA77ZQtLb
	u2aT3fz0H56DbRrRKp3A/oJTKfIaQD8CcHh4UqTMoWBVgpOTf0Y7gL41LXxwhQmj
	HkVC4SzFtqIAWMVag9tYxj1tpgD9JpyZBBxNRX1QVJ1xQChO7Np63ENsEaw63QEE
	oQKxhAD+b0R0XO6XBU6hX8UuCLZokICcqolluP5LngR0fwQEGZ7cXYpkvC71gc2N
	1HVi/559WiMjCja22TbVng==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 460td100kp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 03:46:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53E3Mgx6024687;
	Mon, 14 Apr 2025 03:46:56 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010003.outbound.protection.outlook.com [40.93.11.3])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d4x6ehh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Apr 2025 03:46:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vm62l0sW4EqYxSTi8WiqDbsNrvfT9YYtyKor1eAC7lJVlFEw0GYLc2rTefTSirwG3ho25B2IoxoG+SnwEXEr0U3z1E/L/RSyGUFO/uWuEY6y8n38XJQQyieCyf+JbTxtE1dm3tJ6Bpto1BV7iYsy2HawCzJyC5ImghqIv+2q2NKZgQ0UT948LwYd0OtB9j5nek+vb9z1M6rDeOpfd8w8PwA8S+58/TlJa481jFRVIBW1uKQ6wfyezq0PvRA9Kg46DqTHvJMxkiaORg/Wm/67uvz6F6BQ7X4EHWphDHaEoL7QPSrztGjFQnt+AHrNmQByl8XeA/K1Ndygj9tEqXlR1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3VfYigKQBAt8uXuUkn6BnF/R1lIBfpr3SbE/zluzU8=;
 b=WK8MM64LgA5xXBh0vDqAV+5OETd6oyUdLw4fDYReGYSvYOjRdB/rjbjaknyccQusj2MRZdNkE5SN3TBW03i3Aa8YQlRnu8ul+V7qxyHwXD/yZk8/uBIOGLtz7z7mUrxVuxjcfKqVgHobN+FrWK9SIDX2yBPSDvB1iRcbMzpvGDfmQNIxIyvm9vGato2VIuncXg7JfaMA+3w8/92ZGY81olveI1ak68tzZScXjlFLn+T+W8JvrWR4xHjYFarQ28uwUeZUbp0gS/9ACcfLrXsP7ft2p4nYrFUxXHHuO1TxbkaGe19eyrZwEkqYrSuoPt/fJah8+P6GbhNoDLe7ja3gng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3VfYigKQBAt8uXuUkn6BnF/R1lIBfpr3SbE/zluzU8=;
 b=nSYSmRTS6Lmu/3GfZjl31KA3UcFmIHb8LAz5s2aJaAkm1JTmfY/qi2zt2WbGwE6iWAuRsX52jWYr7CsyKlldAroIA+IPzlyYtV3e0Vsp2BOXTRQGSbgEhsooaSVHBHPr3gk4TdAWxcEUPXpW0HX40Gs+PMy6r22bIEoukQqm/oM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS4PPFDB583D803.namprd10.prod.outlook.com (2603:10b6:f:fc00::d50) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.33; Mon, 14 Apr
 2025 03:46:53 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%5]) with mapi id 15.20.8632.030; Mon, 14 Apr 2025
 03:46:53 +0000
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-11-ankur.a.arora@oracle.com>
 <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
 <87h62u76xg.fsf@oracle.com>
 <f384a766-d91a-4db5-9ed6-c1ed6079da1d@linux.alibaba.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
In-reply-to: <f384a766-d91a-4db5-9ed6-c1ed6079da1d@linux.alibaba.com>
Date: Sun, 13 Apr 2025 20:46:52 -0700
Message-ID: <87ikn75rrn.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:303:16d::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS4PPFDB583D803:EE_
X-MS-Office365-Filtering-Correlation-Id: 720a88fa-eab8-4f73-fcb2-08dd7b06ff0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c292cDZiMXRTV1NkNmdHNTRJQ2E3aE4rMnJoK1hWamVkNGlEb2RObXNWUzFu?=
 =?utf-8?B?YVFpY1FzU0lNSlVxUDJnNDM4YlpYTUxURXNlZkg0eDJQZzN4NSszOGtBemFa?=
 =?utf-8?B?ZE43UitjZ1dIS29USFlLNjl2L013eTlHTFNKbkVGZnFzbXdTR3VFUUt6T0lZ?=
 =?utf-8?B?U0lTWXljTjJNVUFoanIrcnJ4U2VhRFV1UjVMTEcrdk5EdUxWZHk0eTVsWVZK?=
 =?utf-8?B?MWMyenRkZ084UzdQMEFwVm5idGJwOGUyK1puQjlXSGM3dTlYZ2thVmJwQlhM?=
 =?utf-8?B?alNFbGZ4OFhhUi9CZzlLYmhsNzJyN1NhbE4rRG5kOU9yU0d0MVZOYlp2UWxx?=
 =?utf-8?B?dllNQjhNWUo3NXEzOFlIdFYyMUtvUk4zMmJWMExaMVdBNXN0eEJ3TXVXVEMz?=
 =?utf-8?B?YUpKZCttRGRDd2tLNUFwUnB2MHJoUVdoNU5kbWNYeFc0UllMNWM1MUJRVm9X?=
 =?utf-8?B?b1JGK01CR3BWbjBmTExPaTV1M3hTMFkybUhVb2hZKzBJWXZNY2lmWCtzR21U?=
 =?utf-8?B?Q1JIZ1ZXbVhndXM2ektNeEwySTBGQ09ZcHNSWXlCZlNKT09MYmRSZFRRdjNF?=
 =?utf-8?B?cWFIUjNwZWVMZU5OSWZNeS8zS0NhTG5FZHRwRHAyOWRaazR4KzhJSzJvTGdF?=
 =?utf-8?B?K1dzQ1prSFhDQlQyMUFyMFphQytqMmlIWEFHak1qWUx1OTExN0M2RFZYT1Nn?=
 =?utf-8?B?K1Q4WDk1MVZjWnZjKzlMZjE2SVRKejNaTUhnY1B2UlB6ZXdEYmZPTWU1ZmVX?=
 =?utf-8?B?dTZFRU5NNHVjWVBIbGQ5SW1tRzdRaHFZMUhJdzJYMDJDeXl2V1Y5VFpRd2x2?=
 =?utf-8?B?aWRWendKSFF6dDVhVGNqYnliQmpsaUREaUJ5c1J1SkdHWEptcjdPRGZrTEFB?=
 =?utf-8?B?QjhJWURlSEtoTkRPTEFJT2dxbGdrcGlaTXVpVGtOU09QN0xjMzhldWFYODkv?=
 =?utf-8?B?cXF2Z2xYWTA0Qk5ZeEVoZy93NzV4Yld6VkpNZS9KalN5aTYvZ3JUR3ZJMXlC?=
 =?utf-8?B?SWV0eG1NUmkyZ1ZwbUJQN3paMkh6NFczM2x6azBOOUxsWFpyUEZsVHpISVFr?=
 =?utf-8?B?aHBmVTBHN3IxVURnS3BubHU3WndzT003MWl2bElmeEJLL2RmNG94RnA1bkFH?=
 =?utf-8?B?VmxQL0ZHYjVrN2lZYlJZSUpyYmxLdFN6VHBsL0xvMURlK01pZUlaOWpJSDY0?=
 =?utf-8?B?ditxMDlkM0x1OUQ5YWRhUU9oSUZyRmwxMVJvU3UvczNockZITDlhdkREckxm?=
 =?utf-8?B?UStURStBK0Z4c1NURHN3QmpKa1EzbjR5NGZHR21FUTZ3a0pPTUl6Y2lwVkt6?=
 =?utf-8?B?TkxxRGsrSG5mRmVWeTNYcG5LYjlpMytGZmEwdmdBL1oxY2dsT0p0R0gzYWVM?=
 =?utf-8?B?UGlCazNicHlSZ3lWVWtEWTJYVFFHSEF4d2tHUHhWZnJRU29wM0p5SjkzaStJ?=
 =?utf-8?B?dW84L3E4S1FkTkprOE1tUk9RbU9NYnVpdHVwQjdLV3paOVRlblZTVjVNcnh4?=
 =?utf-8?B?eTlMNnZsR1dFNUlHUlZFYjdnckZ1MXcyWTNPMHM1eEhsbDJUR1gyamdFT2hq?=
 =?utf-8?B?c2FlOXFjY0Y5NThmbXhqK2Z5U1BLS2tqQjk3U2I5MGliVEtMMGc3M3JiY3dK?=
 =?utf-8?B?bWtmQXhNODMzRWh3eUI3QVpxd0pwWDNkc0ZXSEVraTB0ZVhURmllR04zTHgv?=
 =?utf-8?B?UDhwYU10SW5CcE9KRWwxamlxVmtGc0VWV0dkVWgrZ24zYUhRc2tUSXhWTEpi?=
 =?utf-8?B?aE5TbVlOMFk2N0k1TjR0QlRqY1o1SHhTYVRnS3NPMjNERmU5Ymp5Q0VVSjBt?=
 =?utf-8?B?MGNoQ0MveWJmbHMxeWtKY1dlZkNYK2NKWEhzOVFlUEExMy9rblhTV1AyQnpF?=
 =?utf-8?B?b3Zha0xEcVlpUDdQZnZ1WmR0d09zM3VsTUxEbkVldzlNTEc3NEQyc2daWHpR?=
 =?utf-8?Q?woheLYu/aEQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDIvYjJwaVRReUQvME1YTDhNc0dIUnV1eXo2MjRnMjVOdWlUd29UN2VOSTJz?=
 =?utf-8?B?TFVnUEN6MjB2OGhkb3JrSG5SMUZmWkgxamtzbExHMnVZOXgxZm5UVyt5c3Rh?=
 =?utf-8?B?dWo0QlpXSExiZWJrYjV0OFE2S0I5UFNHVzJ2Z0tHYXBiZDRydWdiVWwrbndP?=
 =?utf-8?B?cStDTFViOHkwZHY3Ykl1NU1DN2kvaVdwVWxIWldzZDhyM2Z4K09OdWVFMEZN?=
 =?utf-8?B?RjFoY2tDdnJUM0xqVXZoNUJRb01uWG41eDZyck9iRGV4eEVscWs5Q1JCbUEx?=
 =?utf-8?B?ZHFFSVI0UXQ0SWJXM2N4bDJkUVY2YVRjSjJibFByMFo2dzUweGZPekpQRXI2?=
 =?utf-8?B?TjhvbmFCZWZEY3pVdkxrUWNocHlmeWw3NVJXTUZBNGM5T0M5UEhjbVh4QjV4?=
 =?utf-8?B?Y3hzR0pUUjhZb2tiTm95MlA3RWJTUnpKN1VKNTZXZGdSSmIyWXVoWnUwRGNq?=
 =?utf-8?B?dFlTL1pydEVIKzBBNE5xRVpXaVAxOWxQUmJRV3ZuNDd5RkgzQk9hMUFZUTBV?=
 =?utf-8?B?TnRqUThjanFON0ZwMmMzZ0E5NmQxWFA1TXB1T1BnbkpwUkJab1FMdEVjaUFB?=
 =?utf-8?B?bzRHU0dJM09jejE3Qi8vcjJQZDI3ZkpEekZOelZMY2U2VlllMURrMTNkNXpC?=
 =?utf-8?B?VjBhbG1Mam1idUhsR0tlaXdXS1ZwUnFlcTI3dGpVTzFDOGJYK0JRdFdoVDVO?=
 =?utf-8?B?eHUzaTBDTjNtMWhQczFZUDF5Zkc2ZHB1N3RHZ1pHU0RBU1V5WGh0VXlOV3h6?=
 =?utf-8?B?ZUIwN2lsQlFvUEtyTUcrdWZaaWUwenVpWnhyZmpqUGNTUVRXUHQyak4rTmlD?=
 =?utf-8?B?V1VFUExnRExzQXhmM2dlaXdFRW1VWTdyVW1YN05JQmJmWGtKdUMzL1dsNGUw?=
 =?utf-8?B?b3VmS1dDWkcxMCtkMlAvSkU0K2JjZXMySjJDc3hubkpibTY2cStmeUhQdm55?=
 =?utf-8?B?bDNjc2RQV2dIRTlxMTVTQitrS1NhREs5YmttZXg3a0UvSEQrbzZjZ1RPUEFU?=
 =?utf-8?B?bVZpQytQa0c1OGpjUjFpaDRhdnVyaUpHMVQ0ay8yM29aazRmOVhXM0RPYTNm?=
 =?utf-8?B?b3NqRFZSdlVCMjZFWGFmcGkxeXNTZFJDYzkyL1RncWVtalIyRTN5UldUL0RL?=
 =?utf-8?B?YWRMZkFZUndkU1JmbDd5R3l3MXpnNGtLYlQ1am9WbVJtdUQyWWxBWmNrQ09F?=
 =?utf-8?B?QmxrOUgxbFI2QUhQOFdiaDFwYWVzNnBtZXVWZXc0aWVVT3lhWHlWTlFsak54?=
 =?utf-8?B?R3NOVFIxWWh2bTdQOHJDR2luODBmTDY1NXRpTUJEaHNscklJaWJqY2krUFQ1?=
 =?utf-8?B?VnQ4UExJNjBQdlA1UFg1aU5OSm5EakcwYjhRcjBEWnZ6b1lwSm5XeE9sTFBJ?=
 =?utf-8?B?cERhYXlFZFdTQ0tsOWIzVXVmYXg4Y0l1ekVieWU5cDgvQkFzOFp4MnMvajNU?=
 =?utf-8?B?UDRYUDF1TlNwZDdqbFk2Wk82WmZIT2ZKcFpRNE5jVGlXcks0UlFLa3E5dEhn?=
 =?utf-8?B?WG1SU29IOWZKU1BWM0pLK3RKTWxwTi84Zno2ZkgwU21ZaktWcmplQnk1L09s?=
 =?utf-8?B?MkR6b0NKWFJDa1VlNG0vM3hNYk5reXZzL0pFR0R2bnhBa0orRHNKSk9NeDBJ?=
 =?utf-8?B?TjRCQitvUUF1eWNlc3BUem5RSWp2V1dNUHdobng2SDhNN3doVjA0UkJzbEtY?=
 =?utf-8?B?QjBqK2Q4VVRMa2NNSldaZjJEcnR0aXFtcXdheS81enNvOWk0NmFqeGZyRTh1?=
 =?utf-8?B?OXB1WXM0OGtaQmxKV0ZUcVZ6SmZOUEtnTnRvaHdzQy9FQ1U5VG9NMDk0WldO?=
 =?utf-8?B?ZEVIYUFlOU1FR2V5NHhkazhNa3Qwendqd0xJRmRPNUNuMnVaSkxKYWovUUNN?=
 =?utf-8?B?VGJ5Q1dVeGR5c3lFN3VmRFJqQVE3NXpFVDNpNnoxbWdQVCtXVGF5OHkwVStx?=
 =?utf-8?B?Y05qUXAyL0RGU3JBUE1veG4yeEN4bzhUZlg4d0lkbzBnVkJrMnQ3SXZsL2lp?=
 =?utf-8?B?VTFTNlZXNFExQmRwMXJHeU1GSjBiOWgvQnFacDhxeDQxUEdWSGZHT3pwQzFw?=
 =?utf-8?B?cTVMZXRxbHBZblRyZENWNGZUTndTTlFzeTVMZTdxT0dPWkhlWFgzdG5oQUxo?=
 =?utf-8?B?VEJKbmM5NDdKT3hDdG5VNGk5UkpZR0R3R1NxYlJaSnhjVW5hQUlVMUljYk1E?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9RvBSaJZBocBknkNfhfldkhlLxBhH4LbOAXJ0fAg7XI2DcTUpCsoiWhu8QLhb1/lcHxw3ZR1GI25uxjCQM0rHQi/+lKDLGLPl79LHrjjtWcAA4pZe2jPNyAXUYeorbDogFRytc5pM0jfwN2UmMi5ZTfRY1WwSx4sT5j3klwxH4L7PIGzloSZEunRk3JNX8Gz6G7ZhIJ6HomyRtkDaEFghlGDKC6coI6GzrAw+Fdt9s4e87AKJWngT4hWwA+vzksLNnRWSrdjooGAQDN6wjw1Klyo/quGPkI9UhUxKIIFej2McdquseC4V35b0Rra7DELvXkejrnZ7RRJbK6Xn2Gz2lfQtHwqsRKvFKuKLaYsigDcbcKbUvETNhKrF2ERq4ZarJqEALwt2kcJOpH+FODoZAVPA0GWEaZxrtdNSsphekfkwCTYvuq++RBYnKocGBNT5R/mhbqHdYSsseqLGnqV3F5zy+Bk6R1cPjRMemrZlSBCfPRMGD1IBL08iNf5+59PVI+tjA42j4iGIbC7SwcmFY1BwMdOUC1FBbtyWAFQCGvzkEqCt5rGyl+Zz4UcCjecHMvCi8xF+CIHHUnCJlnBY5IWpUs4F8iHxVgIhA7fflo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 720a88fa-eab8-4f73-fcb2-08dd7b06ff0e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2025 03:46:53.7457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 07DlYef+wMwzwyNdSqaJnoCuQRjl5hPM8NN80BYSsI582J+FeWHuhGSKF+eCQv1o3wjK1mM1ln3g5hN47AXQ5WhO1jxeC+hon6Jx++h/9Vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFDB583D803
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-14_01,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504140026
X-Proofpoint-ORIG-GUID: _FtVnGp4oxXm0VobQjkVMhU9uV0QZ_5M
X-Proofpoint-GUID: _FtVnGp4oxXm0VobQjkVMhU9uV0QZ_5M


Shuai Xue <xueshuai@linux.alibaba.com> writes:

> =E5=9C=A8 2025/4/12 04:57, Ankur Arora =E5=86=99=E9=81=93:
>> Shuai Xue <xueshuai@linux.alibaba.com> writes:
>>
>>> =E5=9C=A8 2025/2/19 05:33, Ankur Arora =E5=86=99=E9=81=93:
>>>> Needed for cpuidle-haltpoll.
>>>> Acked-by: Will Deacon <will@kernel.org>
>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>> ---
>>>>    arch/arm64/kernel/idle.c | 1 +
>>>>    1 file changed, 1 insertion(+)
>>>> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
>>>> index 05cfb347ec26..b85ba0df9b02 100644
>>>> --- a/arch/arm64/kernel/idle.c
>>>> +++ b/arch/arm64/kernel/idle.c
>>>> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>>>>    	 */
>>>>    	cpu_do_idle();
>>>
>>> Hi, Ankur,
>>>
>>> With haltpoll_driver registered, arch_cpu_idle() on x86 can select
>>> mwait_idle() in idle threads.
>>>
>>> It use MONITOR sets up an effective address range that is monitored
>>> for write-to-memory activities; MWAIT places the processor in
>>> an optimized state (this may vary between different implementations)
>>> until a write to the monitored address range occurs.
>> MWAIT is more capable than WFE -- it allows selection of deeper idle
>> state. IIRC C2/C3.
>>
>>> Should arch_cpu_idle() on arm64 also use the LDXR/WFE
>>> to avoid wakeup IPI like x86 monitor/mwait?
>> Avoiding the wakeup IPI needs TIF_NR_POLLING and polling in idle support
>> that this series adds.
>> As Haris notes, the negative with only using WFE is that it only allows
>> a single idle state, one that is fairly shallow because the event-stream
>> causes a wakeup every 100us.
>> --
>> ankur
>
> Hi, Ankur and Haris
>
> Got it, thanks for explaination :)
>
> Comparing sched-pipe performance on Rund with Yitian 710, *IPC improved 3=
5%*:

Thanks for testing Shuai. I wasn't expecting the IPC to improve by quite
that much :). The reduced instructions make sense since we don't have to
handle the IRQ anymore but we would spend some of the saved cycles
waiting in WFE instead.

I'm not familiar with the Yitian 710. Can you check if you are running
with WFE? That's the __smp_cond_load_relaxed_timewait() path vs the
__smp_cond_load_relaxed_spinwait() path in [0]. Same question for the
Kunpeng 920.

Also, I'm working on a new version of the series in [1]. Would you be
okay trying that out?

Thanks
Ankur

[0] https://lore.kernel.org/lkml/20250203214911.898276-1-ankur.a.arora@orac=
le.com/
[1] https://lore.kernel.org/lkml/20250203214911.898276-4-ankur.a.arora@orac=
le.com/

> w/o haltpoll
> Performance counter stats for 'CPU(s) 0,1' (5 runs):
>
>     32521.53 msec task-clock                #    2.000 CPUs utilized     =
       ( +-  1.16% )
>  38081402726      cycles                    #    1.171 GHz               =
       ( +-  1.70% )
>  27324614561      instructions              #    0.72  insn per cycle    =
       ( +-  0.12% )
>          181      sched:sched_wake_idle_without_ipi #    0.006 K/sec
>
> w/ haltpoll
> Performance counter stats for 'CPU(s) 0,1' (5 runs):
>
>      9477.15 msec task-clock                #    2.000 CPUs utilized     =
       ( +-  0.89% )
>  21486828269      cycles                    #    2.267 GHz               =
       ( +-  0.35% )
>  23867109747      instructions              #    1.11  insn per cycle    =
       ( +-  0.11% )
>      1925207      sched:sched_wake_idle_without_ipi #    0.203 M/sec
>
> Comparing sched-pipe performance on QEMU with Kunpeng 920, *IPC improved =
10%*:
>
> w/o haltpoll
> Performance counter stats for 'CPU(s) 0,1' (5 runs):
>
>          34,007.89 msec task-clock                       #    2.000 CPUs =
utilized               ( +-  8.86% )
>      4,407,859,620      cycles                           #    0.130 GHz  =
                       ( +- 84.92% )
>      2,482,046,461      instructions                     #    0.56  insn =
per cycle              ( +- 88.27% )
>                 16      sched:sched_wake_idle_without_ipi #    0.470 /sec=
                        ( +- 98.77% )
>
>              17.00 +- 1.51 seconds time elapsed  ( +-  8.86% )
>
> w/ haltpoll
> Performance counter stats for 'CPU(s) 0,1' (5 runs):
>
>          16,894.37 msec task-clock                       #    2.000 CPUs =
utilized               ( +-  3.80% )
>      8,703,158,826      cycles                           #    0.515 GHz  =
                       ( +- 31.31% )
>      5,379,257,839      instructions                     #    0.62  insn =
per cycle              ( +- 30.03% )
>            549,434      sched:sched_wake_idle_without_ipi #   32.522 K/se=
c                       ( +- 30.05% )
>
>              8.447 +- 0.321 seconds time elapsed  ( +-  3.80% )
>
> Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
>
> Thanks.
> Shuai

