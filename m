Return-Path: <kvm+bounces-43326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F79A893E9
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 08:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C6491776DE
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 06:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30F6A27587B;
	Tue, 15 Apr 2025 06:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mSaNGv9d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JXsa10Ii"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDFB1C6FEC;
	Tue, 15 Apr 2025 06:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744698347; cv=fail; b=WMyY2ojO1qBUk22K1uczNKctJZfv3bXJa+211Y9IJEZj9MXmRSk1b6Ic8zBAgXJ2U32mIdv4nPAAkvxdw2JvoYCH7Zwg7PWPVqYZy+r8W6JWymAB88OQdWqk+xWe8AHzmUcsQtGvhSLnYL04ksDR7SM2wm4Janho6V2be7IgqCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744698347; c=relaxed/simple;
	bh=oimTZSMi+rZ1rxobrycFeYAPnBm73bwmJsafBDQYln0=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=gePG3b4DVWcE7AIqXyjEDcoknGlXvuH99kIkkkZnHVMlOUPve0T5BhQEMIecXWr2aVG8tySJ0dnssk+CYVfNE7IPwXz5vD/QaFMgdycohT4y50UfQ5A7Cydp27EQ/dFNb5yMWX/nsUphozCYmQ//puWu9Lki9eKI+EG7Zzh6udA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mSaNGv9d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JXsa10Ii; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53ELBrXm008172;
	Tue, 15 Apr 2025 06:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IhnfdYoflpdr/qq0yDKxBkqcBnN2g4rJCcbpxDY/MxM=; b=
	mSaNGv9dAvQ11SS3BG6io4oMqcOSeGOQ8orhpmRkAVoM8ElK/38LYjkuU+fkudCB
	z7bFv8QPYwdwpnU0rYnBTaB/qtxWuBWbtPwJjkAPCCLpUQDa4lBxYMU1fnOMB/1b
	IbupYexEShFpcs+JjC+i9mbfqgKGVxxKgk4QQ0eVWGftc2IfOLnp7/xjXKgCRjyV
	tblbtvzezwk2Uu1JU2fpZ9QSwQN/cMHX/tenxQH11VDl1wDSwMxgyQ/6SQIrFXBk
	SioGFtkqVLLbqAycmGG0wkEghSUgLVBGddIFCmb3OBmPnsR0O391qgeJcB4p0VWX
	BXZsckrOPgDrS8ghu1DUJg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4618rd0ve8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Apr 2025 06:24:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53F5lpST038784;
	Tue, 15 Apr 2025 06:24:57 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010001.outbound.protection.outlook.com [40.93.1.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 460d4qta8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Apr 2025 06:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s+vF2NTPb8Plpm4EvGk0xb6rAoo3Hr6CitaocxvpXfOu5hw9MbOU67EQJ3v53Y+JjFbnlAdcLrnHqZlnzvIrIPMWunBvnr7OxwzA0E3ejmHzhfnLDFm3eI+nodd1FPVneS7A3XZdc1GzVRrLPLjhSD4C3SxCkomrktgoALDnHx11hUHTlIdQYIBMREw+GLZYQvpuHo65vXY+so+N+61w3m2bULs5Vmpnor16Hpg6cNmlQdevYyMs7LcDGP4wyc8dkJ3HpWNOVZ5bbzHQbtezSSWjYchbX/KYxNvecNVaAIdqLXQWEd2rYH0srd7w2ywEA4skgKvxIjuKMPyHNmHoUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhnfdYoflpdr/qq0yDKxBkqcBnN2g4rJCcbpxDY/MxM=;
 b=eFhkcv3pVUabt3Jo6oG52+QwTuVufPZyNj6+e1Px/8384szLEm8/JONJYGAbsEpilcQ48qvL/bCvEqixeWO0pigwXiljF8RMJr0J29Pi4O3CU1h2U47S6F5dra8D+6CfLT8Rw0qfmD2GNWJlj42b00rlZ5Gr4fCeEOBmak0daapTb2QLS561TnwChQ7zUTyieSNrwG4sVAcsDlmbMuxiBf7EQPNgPv8GjgsJX60LVZSdYVgd4zUZUM2orFfyuWkloTipAPXt3Y0F6gB6iddW1FcNGmvD5U9jNLL7293nEPFeaOcI0CVtl1FD6wB7qo6SuSNGZDzgnVp5/hlu9ZAsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhnfdYoflpdr/qq0yDKxBkqcBnN2g4rJCcbpxDY/MxM=;
 b=JXsa10IiFf/AxYmKwSJ9imRCkE1gbKR4Vk6AmgNc0MNk26u8m3scM4etcTChyDpQ2rbO6OrEQHmp2q7OABwk408uTgYSIv7Tj8A0b3GeQ73VZ+aqE1RC23sUkOm4f4YSPa2r+Y1VtsrX2bnYrAaXca3wHRuOM6zQKYYFJFKpCfo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB6592.namprd10.prod.outlook.com (2603:10b6:806:2be::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.29; Tue, 15 Apr
 2025 06:24:48 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%5]) with mapi id 15.20.8632.030; Tue, 15 Apr 2025
 06:24:48 +0000
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-11-ankur.a.arora@oracle.com>
 <18875bd7-bf01-4ba8-b38a-4c0767e3130e@linux.alibaba.com>
 <87h62u76xg.fsf@oracle.com>
 <f384a766-d91a-4db5-9ed6-c1ed6079da1d@linux.alibaba.com>
 <87ikn75rrn.fsf@oracle.com>
 <6b313eef-c576-4c0c-8d9f-8ef0bf3cc0fd@linux.alibaba.com>
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
In-reply-to: <6b313eef-c576-4c0c-8d9f-8ef0bf3cc0fd@linux.alibaba.com>
Date: Mon, 14 Apr 2025 23:24:46 -0700
Message-ID: <874iyqyma9.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MW4PR04CA0223.namprd04.prod.outlook.com
 (2603:10b6:303:87::18) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB6592:EE_
X-MS-Office365-Filtering-Correlation-Id: f38043cd-6b4a-44e1-b8c5-08dd7be63848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkdrM3JzMUxWKytmSklqa25nZ0J4emQwMXE3OUJCdUFVbExkQk5EN05EZm92?=
 =?utf-8?B?SlkrWlJKNG94bklobnBJSExNZk15TXJCT2xjOXpuSlJMSkhhU2hmUUV4ZHBu?=
 =?utf-8?B?TDVSQVZmb0Faem9YTk1Cemk4ZGUwWElYaFFzbWpja3hFQ1pRTXdJTlV5Y2lJ?=
 =?utf-8?B?dS96ZnBGUnd3elJJNTJSQnVGZExEaktSWmJRNjFxa2JRd1ZNd3dIRGR1RUVz?=
 =?utf-8?B?L0dwU0dveWRIbjhENXNocUk2S2dCS0NmZnd0cUtieVh0aXBwU1gwblNoNXI3?=
 =?utf-8?B?SGI2azN0eXhyZENpdkpkakh0Y1U4ZnlZY21PTFhhZWhLZUlDUEhiRG4rVGR1?=
 =?utf-8?B?cEVHQTluYlRpYWgwSW1rUzg5YXo3RFhiRUtDUyswQkRqWkhBMnJVSlI0YWZr?=
 =?utf-8?B?RGJnWDh6MGpkRlpDNzZZMVMzSlI1YncvTHVNdkVLOElBZ2tWNTlJcU8vTmtV?=
 =?utf-8?B?elhiQjlaWStqV1BINlg3VVdLMG0xYXZ0a2lUbUZKWmNGZWl3WEp6cWpnN2Vs?=
 =?utf-8?B?ZWNVN1owRGxHMDBRTkZqdWgzKzZxUFhoL3Q2NUtmZVc1WDZhcjRLNTlCVjBt?=
 =?utf-8?B?SmRTMjIwbWVGWEZiTHVTMFJMWTlXU0dkV2o5bDlya3VIODgyNnNjbDUybktS?=
 =?utf-8?B?ekNIOFdWNVRZV0tzWXZNQkFlOHBmWEdRSlYrR3BzSFBJeG05Z21aV01Rb29H?=
 =?utf-8?B?bkYyZDNkWjV0ZEhvNFZQdUdJTXdEMUo5ZFBWZVM0MGZUV1FWQ1BmZmVPbVVK?=
 =?utf-8?B?WHVrL0dxTGxJVVdnZmpTTzIzdElBcURrcElZd1pJWVorK0FZK1lWSFFFaEl4?=
 =?utf-8?B?VEg1UkRQRjI5aVNrZHpHUXRteEgwTFRCbk1YNUxEM05MVS85aks4d0toODd2?=
 =?utf-8?B?Z2pSekxScWFQcEdFRmFPeEtsdjR6VUllZDZlQ0hGTmgvOFlDbUZveG5oMU41?=
 =?utf-8?B?MGFkTWFYUHkxVGFOOFN6cGQyUUJIeDY3YXVSRXY1VVM2QXJiNGlTa1lEYUt4?=
 =?utf-8?B?ZFhXVUd2QU1NUkhzRS8wS09DekVKM2h1SHA2YWJBNUt4WGptNGU1aVZtbUM5?=
 =?utf-8?B?N01LV0kzbkJhMWVxcnJRVktnd0YwckRGQ1h2a24wTUtqTXhqaElRRjUveTVz?=
 =?utf-8?B?N01MazBTY3lySGkyWVU4aXM4Y0JISHg3N3JKTUZVd1VROXdTN1FFTWprODYx?=
 =?utf-8?B?c3VBQVVlSmN1ckhOa2RSS3FCN2ZFVTVjd1hMaDZLT0xTQjFXSnBNTGFRb2hh?=
 =?utf-8?B?SFh5N1dmV1JiY0c1Z2R2Z3NjZkg0R1h1a2Q3SjUvTDBOclU3RC9EdWtMclFW?=
 =?utf-8?B?WUhud0gyK1MxVDFaQkkvOGxCcS9hL0JHR3VRc1o3OTV2TGpUVkFkbUkxZEJC?=
 =?utf-8?B?M2xCSVoxRDEwYnJ3c0h1MW1VZzdzMTF1bEVUTkozbXBnN28zekZsR0xDREov?=
 =?utf-8?B?WHg0NTFZZ2VQbU5RVm55ZFZHVW0xaXYxRHUxTy8vVmwrUVNIZldZaFJ3c1Zt?=
 =?utf-8?B?Q2QzSVRxeFZ6dkpKbkdEUWxiSUVZcjBsVHcrWjgxUlR0SnRNbGcweDUrbEN4?=
 =?utf-8?B?Uk9qYzNLV2kwRG0ycHVCK3VBSDVLdjlqbTg2Yjl5YWk0OUF0T1E0TmpOKzNm?=
 =?utf-8?B?cldpQ29wYkFBWUFmdzFYYjkvdlNtOUlwbTVyd1h1OVhjQmJUcFRSRFI1b240?=
 =?utf-8?B?ZW1jRnVsVDB3MU0zWXU0SThDZHhOVmJFeGg3a2FJTHJweTRRT3YvNnRoMTdH?=
 =?utf-8?B?MFZQSjg0aFBjSWhUU1F1MXVGeFROZFZnUjBkZVVlQWJXVXk2SlIzUUtpYVVr?=
 =?utf-8?B?RVROSUZXR0YxNU4rSEw4MlQwa3BvN0hqOVJLYWVvUExlUURGYUFhYnRPQ21m?=
 =?utf-8?B?Y0dHa24zM2Z5Z01VMUd3eU5xSFdCT1N0VDV1SnpPSzNSZ2pCUzdDK2Z4NUQ4?=
 =?utf-8?Q?UayUPqotWb8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THllV1p4Y0czZHBoTDAyNWJUN1dLM1lZM1JvaXF2c0tOWjBKd25uNVNJN0Mw?=
 =?utf-8?B?U0VOMjRqdWNEbFJnWWx3Szl1UERSeU9CNmJNZ1FteWcweWE0WjQ0RG9qNnFq?=
 =?utf-8?B?d28rUEYxVWhaL05NcE9XRUhwUDdRU3AwY2Y1bCtzUmk0dm9MRERUZXAwaFFI?=
 =?utf-8?B?WDRZcVZTYkRxQ0FDOGFkVEJBazNIVzJaakRpaVVXdE5tUnVveFFSeWozMVhF?=
 =?utf-8?B?cGcxNEMxc3FrUENYOEtjSHVUdC96WHVVN1pIU3ZEWjh1a0dPUi8rSS9xclNL?=
 =?utf-8?B?cjBFV2EwTHR4dTdwSW9mOGtyZll1ZkEzcDZhQjdySlhHdE9HdGVDMktVTVpY?=
 =?utf-8?B?elZ2UlErU3J6UkprYUlFYmdFSmh0MU1aVEI4Z2NlSnB6dDI5Y1MvMkZTSXZ0?=
 =?utf-8?B?YVlHQm5sdm5HdmVXSGI2R1dDRWQzUFVoUC94VXFwZFRlMURBVlpObm5BOWtL?=
 =?utf-8?B?bWVTREtSYTQ3MnFob3h0L2JSOXkvMEVRN05vNDR1WmgwT3NxWStsN1pOdjR4?=
 =?utf-8?B?dlRYSFQ2L08wTTVIdmlxWlV6SDFPN1Z1VzRWYWhVMzk5VU94MFZSQzgxRzk5?=
 =?utf-8?B?UjN2NmFGa0NpdnZvTnFxWTNSM09Uc0tBM2VobDRWQkh6Y2tjaDBidnhNSUUy?=
 =?utf-8?B?aVhuYjJXTjBMWlFUMTNVNjk5Yk1BaHV5aE45aXJPa05vdzdmOTU0cERVc0RB?=
 =?utf-8?B?ekZ6empUTG1FZnJNV0U2S0tBQlhnL1pmbGpOSk5jWVE1UkxTSlFaK255a0xk?=
 =?utf-8?B?Nmw4VldwRUZ4UHpKeTZZblRVNWR5eFNxbHAwTXREanRVNkdMSmZ1VmswZTlB?=
 =?utf-8?B?U0huT050Q29ZRXJNMkszbkw0STBxOXJhdEVJbXRqZjUwa1l6MjN1dzAySGVp?=
 =?utf-8?B?ZXZpVmIzcHFRWEoxaGp0dGFCYk1DR2ZBZU56c1JNL3Y3Tlh5cDZTMzdzbWVW?=
 =?utf-8?B?YXlaYml0YkhHYlNmN29MZEduaXBrc0d0d3BlRU81UER1VFlZWlVydFlrc0M0?=
 =?utf-8?B?bXo4NjRXOVRPT0MwTHRBTm1SRkh2aUYwRWhPeXJtWHJDN1Y2Um1TVjcrNTlr?=
 =?utf-8?B?VHoyYUc5dklRYU4vU2JKWDNSWkNIYm9MWmMzblNvN0tLYU5jZlk3TVZWRWVX?=
 =?utf-8?B?bGFrczlCRnFubWJFanpVVlQ3VXdoNEZZMHpiRUxSZ2dMWFlKeDJLSXR0U05O?=
 =?utf-8?B?SU5DajV3WWxBTGUzekZuRHJSNmZESjhpQS8vQSt3dWFIc2JubEZDSXFvcDYv?=
 =?utf-8?B?SWx6RUU0NWR5WDUvK1pzbUo0dytmbWtVTHJkYVpUckxRbFJPblNzaXJ1KzZI?=
 =?utf-8?B?VXBTMUxSUmlha3ZiV1VEU0Y5elU1NXU1OU5yczJ4WVZXZG5pNjJRNTN3aUwz?=
 =?utf-8?B?WHc5YkhaRmJJK3hNRDhZUlRvZzRiaWdXUUhOWE90bUVFTXk4ZjZSWHZjRm9R?=
 =?utf-8?B?VnVVcFdjTVhkdWtsUFZieDVHcUdmUjlLMFZmMnY1WnFSallIMDBoRktZL0F1?=
 =?utf-8?B?Y3pQYktHTlFLd1NRZ3NLdUZWcG9zNmNzTzBGOHR4R1FGR0kzd3Z2T1YyWko3?=
 =?utf-8?B?eTRsZWxRWU01TzZ5cFN4S0FDM0hJd3ZKcTltNDgzdk9CaFZvYUpZK1pqVWFQ?=
 =?utf-8?B?SXlzak41YnFqR0pIZC9UQmV4MXhlMjFMNXFmc041a2szOSs3bHJ2RkVSNkF0?=
 =?utf-8?B?UEZxNUFrdE52enJ3ZFAzcEJ5a1B4S2k1SlgzeS9ZaVRnclZ6U01OL3hOOEEr?=
 =?utf-8?B?Q1hNWDlCSEFGbXNMUkRQMkhuZ24rdmVKOFRON0lXU1dGMWltVGJsbW4xVWpa?=
 =?utf-8?B?NWFiYWg5NVAzZTM1MGJ3azNhU3c4UXNDOC9oL3pqbG9zdlBIR1RQQ3FlZW9E?=
 =?utf-8?B?WDUweXhETml1UU03QVYyY2ZNYmxldUhNSkVERGpCSlQ0dWdKVmlLTWlYWFVK?=
 =?utf-8?B?aXlxbHVyZUxSSDZENHhMaVo5SU5wbS9jR3p0SVorcElMUHdqTnNNL3FFZTEr?=
 =?utf-8?B?djc1dTZ6bVk2bnNZUXZRa2RSMThkeUxVcGpSc2NWUUp1RWlrOHViTW1jVlN1?=
 =?utf-8?B?TDNyYitmeHdiRmMyRGdRWkdFelorSUp3WXUyNEY3V0F1Tm5kQ2FnNEFhbW5Z?=
 =?utf-8?B?Z1phWDFpY1pmc0U5dk9WTmR0TUQyTVllSXR3aFJxQkY2NnFkaWdUZGpBeTdu?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Puqyog079P1RvjBpY9vy/NvuAjsWAhWUjzbBbje/ziyE2vpjPvFlRyNVDX19K2b3mP07A6rpUPbvAmoXsSuz5rKg87e03TTGyZizcPNBJgB6F7ic4ohrupEvIdat0VV8/XkCbRIRoc1a+UBZraSItNjqEeji1wEMLwv9ELga8/cfrPvHQ7mSZPNqpjdv7XHtoixC0IR5F2olUO6aF3gLF9UqUDDo9y29QGbbucrOiL1tscwkQiSLqNIB3RjovTCFXfAHz8uvIU0pLfdJnFHMdOXZmfy1NlpM+jXWBfdH9zvDFFfr+N/zOHVTS4iFJd/5+vzOUVBw+AkYDcgs2Rv5yAM4lHc+RJhcgMoNL8E+DsqbPOwf0KFJU3pKswApIrNvu1Dge5U47mRFf92eNMMEXJAbven2TTzwCCFx5y3j0Vx1C4QgrNcd8gzkzC/M/OHRocsfseh6tv/l9RmsTgeAZCW0TRrtjybM1HsQXo6AcVZLLfbXVAWt5GEmKk00B13cIGdjG7Ka7tifZ/zZZoXqEIevgZBV+wPl4UMrkmLngEip4Lg0PPpWX1kNudoNdLukO36ab0dTZ/+zrPbMKhLWRJODa/tX7L7W9sCtzo/PoG0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f38043cd-6b4a-44e1-b8c5-08dd7be63848
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2025 06:24:47.9699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AfO3Zy+8UeucRngeaE5TLI37K50RXiLCEwmWxp9PfV/m/s+6oytavQnoio6yQwHGHDIxgf6gaMlNXTyPAgcPCw8QN+pI62z4Pv/cSVm9VtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-15_03,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504150042
X-Proofpoint-ORIG-GUID: XpF-pPbrz2LfyGOoofiFGzyvICALlLWU
X-Proofpoint-GUID: XpF-pPbrz2LfyGOoofiFGzyvICALlLWU


Shuai Xue <xueshuai@linux.alibaba.com> writes:

> =E5=9C=A8 2025/4/14 11:46, Ankur Arora =E5=86=99=E9=81=93:
>> Shuai Xue <xueshuai@linux.alibaba.com> writes:
>>
>>> =E5=9C=A8 2025/4/12 04:57, Ankur Arora =E5=86=99=E9=81=93:
>>>> Shuai Xue <xueshuai@linux.alibaba.com> writes:
>>>>
>>>>> =E5=9C=A8 2025/2/19 05:33, Ankur Arora =E5=86=99=E9=81=93:
>>>>>> Needed for cpuidle-haltpoll.
>>>>>> Acked-by: Will Deacon <will@kernel.org>
>>>>>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>>>>>> ---
>>>>>>     arch/arm64/kernel/idle.c | 1 +
>>>>>>     1 file changed, 1 insertion(+)
>>>>>> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
>>>>>> index 05cfb347ec26..b85ba0df9b02 100644
>>>>>> --- a/arch/arm64/kernel/idle.c
>>>>>> +++ b/arch/arm64/kernel/idle.c
>>>>>> @@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
>>>>>>     	 */
>>>>>>     	cpu_do_idle();
>>>>>
>>>>> Hi, Ankur,
>>>>>
>>>>> With haltpoll_driver registered, arch_cpu_idle() on x86 can select
>>>>> mwait_idle() in idle threads.
>>>>>
>>>>> It use MONITOR sets up an effective address range that is monitored
>>>>> for write-to-memory activities; MWAIT places the processor in
>>>>> an optimized state (this may vary between different implementations)
>>>>> until a write to the monitored address range occurs.
>>>> MWAIT is more capable than WFE -- it allows selection of deeper idle
>>>> state. IIRC C2/C3.
>>>>
>>>>> Should arch_cpu_idle() on arm64 also use the LDXR/WFE
>>>>> to avoid wakeup IPI like x86 monitor/mwait?
>>>> Avoiding the wakeup IPI needs TIF_NR_POLLING and polling in idle suppo=
rt
>>>> that this series adds.
>>>> As Haris notes, the negative with only using WFE is that it only allow=
s
>>>> a single idle state, one that is fairly shallow because the event-stre=
am
>>>> causes a wakeup every 100us.
>>>> --
>>>> ankur
>>>
>>> Hi, Ankur and Haris
>>>
>>> Got it, thanks for explaination :)
>>>
>>> Comparing sched-pipe performance on Rund with Yitian 710, *IPC improved=
 35%*:
>> Thanks for testing Shuai. I wasn't expecting the IPC to improve by quite
>> that much :). The reduced instructions make sense since we don't have to
>> handle the IRQ anymore but we would spend some of the saved cycles
>> waiting in WFE instead.
>> I'm not familiar with the Yitian 710. Can you check if you are running
>> with WFE? That's the __smp_cond_load_relaxed_timewait() path vs the
>> __smp_cond_load_relaxed_spinwait() path in [0]. Same question for the
>> Kunpeng 920.
>
> Yes, it running with __smp_cond_load_relaxed_timewait().
>
> I use perf-probe to check if WFE is available in Guest:
>
> perf probe 'arch_timer_evtstrm_available%return r=3D$retval'
> perf record -e probe:arch_timer_evtstrm_available__return -aR sleep 1
> perf script
> swapper       0 [000]  1360.063049: probe:arch_timer_evtstrm_available__r=
eturn: (ffff800080a5c640 <- ffff800080d42764) r=3D0x1
>
> arch_timer_evtstrm_available returns true, so
> __smp_cond_load_relaxed_timewait() is used.

Great. Thanks for checking.

>> Also, I'm working on a new version of the series in [1]. Would you be
>> okay trying that out?
>
> Sure. Please cc me when you send out a new version.

Will do. Thanks!

--
ankur

