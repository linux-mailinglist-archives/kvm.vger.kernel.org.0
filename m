Return-Path: <kvm+bounces-31650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1596C9C616E
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 20:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE417B64EA6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 18:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FDDA216429;
	Tue, 12 Nov 2024 18:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WEJUeSMj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C4vfj54G"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C35216DFF
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 18:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731435475; cv=fail; b=QR5mA3S5nHuctHhr7shhoSRprIpQLO81zqcWNFCHkTMlKj/DRoFT6l0VT1HnI0gBRDjuRcOuwL8uW34XFgfccFrX0h9RjhUtn0GrWhcNQQ+J6BcetAytVMeLq3p1hxNEvKqwR4czbjJtXS4E1pzaahV5Cq58Y6P1elOyCn0q+TU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731435475; c=relaxed/simple;
	bh=vj1zbhquV0C3+YoelMEzDKc5gtcmiah/Zy0pqyDgpOE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HfhLoErOsVz+bQ64zZX3SdOuPS0wAariRhI/OX2OLnPKWLBzCzcuMsVP4dvkP3p/gTi/ebdg6xqpW3988p7WiL13nCpF28UeR5zijvaZUA6xQfuIhVznNfRjZ9YHcuTt5TpJjPLR0TzbVWxhZVpbzjCostR2azsQ0jMQnMhrETE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WEJUeSMj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C4vfj54G; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHtesW015677;
	Tue, 12 Nov 2024 18:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hiDIbZYNL+T10KFHvld/FF9FwnKZsPsam49vUZLwbZE=; b=
	WEJUeSMjEv8L+qYvYpXMtlreaHTjYozP9S3DnA/gRqKcLGjnGuXUehvMWQ11zxhg
	8wD1s8l0qQ3utkiCQz2Toby8f68PYX+iz2lCIHZaqUDrAamhgNYeGmwe+4Fg9eCY
	JC9a9DkKCqy20+WOpDH6HxgGISFi2IJaqIsuyr7V3Ud+i0fpHZuFP6QSHallM4MQ
	5t0jiV1dLdxCYGYjzYYB0l0uUtOKleC6MiCPPhSWCQWETOxWll5CEC2YwU1rEVxl
	qed5q4mejrxVBtRUexWTOssn3kOFqXNqzy8C57B8QW8mu+dyatzHIMj8mji2MKRN
	5fLLYqkTBylpPtwSgIpx9w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0mbd4c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACHGVDt001179;
	Tue, 12 Nov 2024 18:17:32 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx68hy5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 18:17:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RcsetyC5/9iSjZ9mP94Bumnqs2nbN+avFFjnixz0smGAiwGjKy3pcTCTvNe8qcI09fYt0SJfIp7LCCicIBSyeCXfSyvF1x1RsgrToAmqpNgsCaM7Qf7+31FYPLqqbcqtgMWRTz2ZJK7zsTkDPWuDKHWCEv/T7rGulsFFHJB8pFL6PvhSmMGkEiOxb9lEVfg1hUxnm55IkGp7UXCMsURhMftnYN5hHig8BxZXpmbM/J9Ta5EcQ+20FQLbhHgg5xVSl8h6eMlB0sDJkFI7fZe9lYdL8bOCyUslF1AQ3gdAKeoUY0WODNAcVzK5w7MyZQGH+y7wYIro2gAsA9iqGhMb5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hiDIbZYNL+T10KFHvld/FF9FwnKZsPsam49vUZLwbZE=;
 b=wW/W/0spg7eSKd2BGIIjtgVXLRdXeltA0rJJSR+32zXNKfiyfhXH907oz8+6kEZudSE+AAxGO1BzLsoMLmWRFomZ0l2YiOp0ztOs701IShetqqM5It6COU4EFd6pvjxtxc04DQ+7B8tSEn6ZDxgd1Ji52CIqLHitO4pJfxU2q7ks9mlJwEPVZ61ywEjCc4aL/+25S1cnVmCVWlvmBV0hS5z1263+TZ+9lv485i6Ft/ZBs4N6MSRGu3UgJCRaHbOYEYK9DWH6/o9eUH+IayUlumMHFEywF0sGPVxhyxN4X2Hkl6TI99lW8ZRjS6jKRPPZRGtMwdcDfJ98O/OM2Moetg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiDIbZYNL+T10KFHvld/FF9FwnKZsPsam49vUZLwbZE=;
 b=C4vfj54GwEsJ6I2AxTcz+AeAlWBGoSQNMoyonIdrmjDoLiz8EZdbFDvnx+qUd6C8DPIXb4ETvg71Ls5gWr7418IvSs0Fr0UJeu5DF4qIpQala174K38fRxzY8sKI70W+ZGNUU0Y5Jdoid8VvtTjae84OFhAXx2ZGnn2fFtBso7I=
Received: from IA0PR10MB7349.namprd10.prod.outlook.com (2603:10b6:208:40d::10)
 by BN0PR10MB4871.namprd10.prod.outlook.com (2603:10b6:408:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16; Tue, 12 Nov
 2024 18:17:28 +0000
Received: from IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608]) by IA0PR10MB7349.namprd10.prod.outlook.com
 ([fe80::8940:532:a642:b608%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 18:17:28 +0000
Message-ID: <1f59ca33-4861-406e-9490-af3e4df08efc@oracle.com>
Date: Tue, 12 Nov 2024 19:17:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
 <20241107102126.2183152-2-william.roche@oracle.com>
 <b4f07c74-4240-4b07-a8ce-7cd765d954e9@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <b4f07c74-4240-4b07-a8ce-7cd765d954e9@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::15) To IA0PR10MB7349.namprd10.prod.outlook.com
 (2603:10b6:208:40d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR10MB7349:EE_|BN0PR10MB4871:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5e1f34-ff53-4cc0-66cd-08dd0346440a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUd5RE5zTHVqNlhybEZwMi95d3JNWmhlc3VLR0RWUGcrbUloZkxpcEhOd0Mw?=
 =?utf-8?B?SkNVMUxOZGU4MjJnS2M1YmpwY2pBbmsybGJPUXM0QjB2aHp6SXZ2dzFXNWE2?=
 =?utf-8?B?dHZzRU9RaWk2U1M1dmtFM0xVdGswS1ZhYjlHUk4rcnVjUXNXUnJROE91UStW?=
 =?utf-8?B?U2VldVNtbXo0M0ZzamFvUlFOSUFjdWJLYVlrcm9RaGZFN3MwU01IYVFCUDVQ?=
 =?utf-8?B?YzhFaTJzWTdMQlVEMzFGcG5XMUl6NU0vakd2MUdFZklqOUt0ZmtGV0RLL0pk?=
 =?utf-8?B?blNtSnFTRUFBNFcrNFV4bXdpRnZ1MWkzTUgrUGI4eXRZVldPV1Z5L1BUekZm?=
 =?utf-8?B?V0ZnZWx6b1pzbDRWMXU3bUdkM0hCak9sK1ZXcUI5RE9ZaHhUUi9IZFY5SlRJ?=
 =?utf-8?B?Qmt0OXI0UTJlWHVVcmV6SS9rd3B2NDB6MkxPVC9Edit5ak9KTStQb2FSa21N?=
 =?utf-8?B?Y1FXdE9jTW0yeDNUTFRCR1ZpT0VSejBiMGYwcGtGd3RKT1pEL1lySUJvOVlG?=
 =?utf-8?B?VzdGZ1hsRmRHQmJzdWFRUlVyL21xYlBOeHlvYmhycExDVmhhR0hOVHZacG9u?=
 =?utf-8?B?NGNTRGNGSFU5MEU4RFRtSzZTQXpFNFJCVmlGK1ZaQ3JLamowZjI2Y0tVdWdN?=
 =?utf-8?B?Z0xWc2RNUi9nQUxmSE5SeHFvMXk3VnRuY0xOWmRSS2VrUG5KRnFCTGVCSVAr?=
 =?utf-8?B?Z1I2TDIzNVg3c1dQT0ZZUDUwb2ZWRFFLaGtGQWN2eUlDVDRXeEFabjdDMFpM?=
 =?utf-8?B?YXV1ZGlKMlFWakhESmp1ZFFWODBkdDZoa2M5eWEvS2phZzVreDFhRFBGL01Z?=
 =?utf-8?B?eXdVYkRmMXdRU2JOWVBLa2F4UGRZSHU0SVZUMGYvWjJOUmswRjBGZTFQVXZ4?=
 =?utf-8?B?V1BaNXdZTFBsWUQrWnRBWG9PNjFNUEFRQWNpRmJzNmswTXZleU9QdXNtZGU3?=
 =?utf-8?B?azdsNU9GeE1CdXZaVTh6VU1OSVc5RW54bG1jdFJjSWx0bGg2UXlFTzFKTG5w?=
 =?utf-8?B?cnZTVDhBOTdzMjhYbGhaUEp2cnZxZWsrcUtiTUNWaGJjWHdCa2dabko5VHIr?=
 =?utf-8?B?K3ZJQmNtL3NtTnlOWHFoV2JxSERyWGRPZ21SdFBwcTlReld1Wlh2M0d4MVVW?=
 =?utf-8?B?OEZuUndzY1RBMlBVeHNtRklpd0UzMU5pNFQ5VjJnZWxIWk0vdkcyQXkwMDRS?=
 =?utf-8?B?NjhWVzY3RXNFNTM0OWhkOXh5YmxiRStqZElRejB1UXJndWo4VWpCMmc1dEY2?=
 =?utf-8?B?cDVPRFhBOFJnOUVHQTFVU0xjVmJjMmlxZmhCVmVRRi9MYTlmbVhYZTErSS9D?=
 =?utf-8?B?WGZ5RkpKeE5CS0lOY1A4bEloNTc2Q2tFZnVqY0xmMTJ0NXNvRVlSSFF1L3p2?=
 =?utf-8?B?RDk5d2F4VFRmV1E3VE0xMmlabm83b0w2aTNYZjJidlpRaTVCQVlVc0QvR0No?=
 =?utf-8?B?cjMrQXhxLzY5WUpxbnNKdnY3Y2xKNVdiNXdWaHdOYktWekg4T0k3ck4vam5s?=
 =?utf-8?B?NnJCMVRINk1GK1NFNVpJSDRGQXBBZEhLUzZjL3llem0xdDRxNmtlUGVuYkFN?=
 =?utf-8?B?SUNueElQcnREZUZoKzhhOWNuYkVHUmN1K3IyYmZ1NnlMcUNKUm55V21GWU5u?=
 =?utf-8?B?NFg1d3RqbEMyamVuVG1zNThTRGVHVnRZbFptMWlRdElrbVlQVlNFZUYyRG4w?=
 =?utf-8?B?MGtUZmR2YVRiK2QwQ09pWERnYWlHUytYRWkwNGJndjAvS1ViOHNiK25qNm9k?=
 =?utf-8?Q?WqleSxAZP1XBanYpRw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR10MB7349.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qm9KT1QxVGtwRE54dkZTVUhEZVJWMkFaK2p1c3VxNFRJcTFxRGorWktCcXor?=
 =?utf-8?B?TC9zRCtSODYwOCs0L2d2KzFKK3Y4RXZ6V2R0alY3bWFQRHVUMFc3NUg5Y0lP?=
 =?utf-8?B?c2xQWWdjR2JyVTNvQ2lzVmNGbXlDRUlvVmMvT3g3Um8rSE0xeFFoS3RFRjdU?=
 =?utf-8?B?aTZ6d2JhcGFtN2NaMWdIbHlrcXlBTEk1U0Y5T2FLOUdaVEtEVi9ydHNSMCsy?=
 =?utf-8?B?QzNMT2lSOFIrNGNPRmgweUZXWWVHd2JEZ2x4T3d5azhiSlFpVko1ZkxJb0ZZ?=
 =?utf-8?B?UzE3aE84V2F6WEc0MmxHejFFSHZ2Q1hNYThTT0JKY2tVRHNFblk4NnBqeUtx?=
 =?utf-8?B?dlI3M1B2eXhmbCtrV1h1VFFIdVBwcUU3M09lSkJLa2czcjh6NElYMEsvY1A3?=
 =?utf-8?B?aTJMZjlvcTBEVyt4dHhjMWFlU2tIMHI1SHZXUVVIUklhSmpjNFJjNHpoQ09p?=
 =?utf-8?B?UWkrTTYvb0tWZGpMQ3BJYjFYUlM4YmV3NTM4SkV0cVlGZS81emZzKytncjk5?=
 =?utf-8?B?Zm93a2c0VXBsZUl3MHpqRWxTdlFxRlN2cGdpUVliOFFlV2wrY1NSRm96czhD?=
 =?utf-8?B?dExmTXZYVWN5bEJqWXlzZzBsQVFlRFV3UTdablV3MkRmYjA5eFNnekdsTFBp?=
 =?utf-8?B?V3BiejV2enNITjBhMGlrL2ZIam9aSXErMVZDTDh1Y1dDek1SaUtMN0tsd0ZN?=
 =?utf-8?B?VW5BcHFmanM2cSt5eDBib21uTXZMWHZTdEtCeVg3djJmdFduTHV3WEt4QXN0?=
 =?utf-8?B?bGVKSDZsVmZIOVFXWHh4Lzc3dzFFZ2M0U1hRTWQvV2F2czhUNXA2bU5oNlZQ?=
 =?utf-8?B?Rks4WWpyck1tck9wQm01Z2UxTDJlUG5VL2UySFBqU1RmN24xaGRiYlRRRXMz?=
 =?utf-8?B?UTEwSFFrci9QQVdLUWw5UHNkQWtZNmtkUWlGdy9wT3M1TUdEL1g5TzNodUhz?=
 =?utf-8?B?MCthaW96VVdOamk2Rm82SFBqYkcvb0xJazlnNmpZbVk5Y2JnemVYUHhCbU1T?=
 =?utf-8?B?YVdWUlljNzJwNDc5b1hZbmxNM3MzRUQyWjZPaFpucHdGSzF0em9YWmhWWURG?=
 =?utf-8?B?VWtYRm9ZOGlGZEx5TVZScXNkdUFiTkNmOFplekJFR0d5T0UrMGtCd1N2ekdo?=
 =?utf-8?B?ZjlFOGNsWDk3R1FZMnFhNFRaeGZsZGFuTG9RMHlxVmxvVzRJQUJXYytBVUV0?=
 =?utf-8?B?K1NuUUZodHAxOXBxRmVLMkRPREdQcDZ3bHNoblBBK3A2cmNoQ3VzdlVzbGtU?=
 =?utf-8?B?RTd2cVp0NWt2c2ExWDQvTjFaelZlWFArNnhtN1VIV2RNaUg1dWtqa1IyRXg0?=
 =?utf-8?B?ZWJGT2dpU3VBQUpPMHUxZldDMkViWmcyZDhrbFRHYXpNMzl6LzAzZXp4c1F5?=
 =?utf-8?B?eTFIWXFTaWZ6eWs4WS95bzdpQ1ZjaDcrdTlQQ25NSTBNOXpTYk0zY3FxVkhF?=
 =?utf-8?B?emdhVXQ4UDBJN3p6Vk04NjdqZTlmZlM4b3UybnRyMFJkZFhOVnczcW1hUGho?=
 =?utf-8?B?ckVER3FidHlGaTFaY0QxeEJwbHJPVWVGNFBlM2I2aERlV0J3b0xLMzBLYmcv?=
 =?utf-8?B?R1U0TENOczR1cjR4RUoveXQ4N0c4Y0p0cGNDWTd3S3g3cmhINm9KUm5iMHlR?=
 =?utf-8?B?dmtxa2poa01mdEpJSjZBQm9iaC81R3dYdEpuUkYzTUFEZ3RwYW5mL3dDTzBO?=
 =?utf-8?B?M3dyL1g4ek83ZDRuOVFhQWV2N1dUR25Xc1Bxc21qZEw0TTNyQVN1VEhLczlN?=
 =?utf-8?B?WDZiMWRka3V6NWtpdTFwT0V5em52M0dQd1VuODhwb3I5M2xsWVloOFNJeVhU?=
 =?utf-8?B?aFFCbUNRZnRJd3dXYkNrRElqSzg1ZWJySWlWVWxKa2lWMFA2Y2ZSL01RZTcy?=
 =?utf-8?B?ZmdHYUMrdmpRd0puYnZYaDNOM1ZSY2JJVnVsVk96bjFVT2tZQjZrcmpqUXZl?=
 =?utf-8?B?UjBnWUtYUjZ5c2lURjc2REtqb3JUM3pxdmk5TE56NVVLVmQyOGNhclhvQVpl?=
 =?utf-8?B?SVdkTks3d3JVekJ6eXNWVys4SktBcWlkcTVnMmhLbGhVdVJCL0xhczBid2F3?=
 =?utf-8?B?cDluWEJWRldkWER0UExJN3BqL0FOMFFUbkRDaTUxeUswQnlpRXBjQk03QlZm?=
 =?utf-8?B?NzVTTmlRYVRuaGsyMjRxVGdHMjlkVEs5UHBheUNpSThXL3ZCSmluekJ0b3d3?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ndNR2kTb22WWbEfOUK/5/wJMor9gEO5Xh6mDXxFIZNUFdxPjcFVzQ/IPVS4Ux4ESksd1PAYk/jp/gQ8brrZ0t+aWHEs/ofMnCqTUzEiHPaKSRjaT4Ae0DAsBwehFaqQOwDsjew3WGcDcqbV1x+o8BVI/iwViD7Dy9n5+jPcF1VvYa/sC8xRkdx2SqnTMxwLKvQapBTtNHw0IDXlQzS1HVWlWXAAxh9dtgbJH1i4276fgrEOMCDe0DqZ5rLJLPYjXCxJbS+3RB8NdxdusQkyQWREM+sAlp63GAYL2yj/Jb+61dArzX2SilCt6sRsjozDgkSc8024NNmblEt6ZA10UU+4j+yM7KaX5TrK+0hjHVGRGBrcZ0WRfFL+7EpM1HMYsKlRbO5L+BvOP40EF44ceyn02bi8gkUYO953H9miq7xrobiqM0yffJvfS/o7HLm79/wjDfKf0mUHBjEVeUTVNqWtqCuuqYBpa8F1bt/u2nFFTyablFghixDxpYogekOcaLCJJsmVXbKq5mC33Kk/c8rhO3VKyjnKcsKAvFmV0aGs7ma83yZ78wMmrDc+rm413j53dq0ai2pYp+DAncNWgVG10iKfCiQcJ0v+x/re357k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5e1f34-ff53-4cc0-66cd-08dd0346440a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR10MB7349.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 18:17:28.3393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPhmmSF2YrLG+0MlEnI6/EmC39rJTGEBWo8fMQUh5KT9V98Yzh91fVxSYcA/SOU7aCQDzaTckd1viGIN9ZMgwXoIyHrKpjV43MMj2cdo3kA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4871
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-12_08,2024-11-12_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411120146
X-Proofpoint-GUID: 9P3T0cYTqFjArZDc5XJ3J7KznW9qenjj
X-Proofpoint-ORIG-GUID: 9P3T0cYTqFjArZDc5XJ3J7KznW9qenjj

On 11/12/24 11:30, David Hildenbrand wrote:
> On 07.11.24 11:21, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> When a memory page is added to the hwpoison_page_list, include
>> the page size information.  This size is the backend real page
>> size. To better deal with hugepages, we create a single entry
>> for the entire page.
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   accel/kvm/kvm-all.c       |  8 +++++++-
>>   include/exec/cpu-common.h |  1 +
>>   system/physmem.c          | 13 +++++++++++++
>>   3 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 801cff16a5..6dd06f5edf 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned 
>> int extension)
>>    */
>>   typedef struct HWPoisonPage {
>>       ram_addr_t ram_addr;
>> +    size_t     page_size;
>>       QLIST_ENTRY(HWPoisonPage) list;
>>   } HWPoisonPage;
>> @@ -1278,7 +1279,7 @@ static void kvm_unpoison_all(void *param)
>>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>           QLIST_REMOVE(page, list);
>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>> +        qemu_ram_remap(page->ram_addr, page->page_size);
>>           g_free(page);
> 
> I'm curious, can't we simply drop the size parameter from qemu_ram_remap()
> completely and determine the page size internally from the RAMBlock that
> we are looking up already?
> 
> This way, we avoid yet another lookup in qemu_ram_pagesize_from_addr(),
> and can just handle it completely in qemu_ram_remap().
> 
> In particular, to be future proof, we should also align the offset down to
> the pagesize.
> 
> I'm thinking about something like this:
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 801cff16a5..8a47aa7258 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
> 
>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>           QLIST_REMOVE(page, list);
> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
> +        qemu_ram_remap(page->ram_addr);
>           g_free(page);
>       }
>   }
> diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
> index 638dc806a5..50a829d31f 100644
> --- a/include/exec/cpu-common.h
> +++ b/include/exec/cpu-common.h
> @@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
> 
>   /* memory API */
> 
> -void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
> +void qemu_ram_remap(ram_addr_t addr);
>   /* This should not be used by devices.  */
>   ram_addr_t qemu_ram_addr_from_host(void *ptr);
>   ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
> diff --git a/system/physmem.c b/system/physmem.c
> index dc1db3a384..5f19bec089 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -2167,10 +2167,10 @@ void qemu_ram_free(RAMBlock *block)
>   }
> 
>   #ifndef _WIN32
> -void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
> +void qemu_ram_remap(ram_addr_t addr)
>   {
>       RAMBlock *block;
> -    ram_addr_t offset;
> +    ram_addr_t offset, length;
>       int flags;
>       void *area, *vaddr;
>       int prot;
> @@ -2178,6 +2178,10 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t 
> length)
>       RAMBLOCK_FOREACH(block) {
>           offset = addr - block->offset;
>           if (offset < block->max_length) {
> +            /* Respect the pagesize of our RAMBlock. */
> +            offset = QEMU_ALIGN_DOWN(offset, qemu_ram_pagesize(block));
> +            length = qemu_ram_pagesize(block);
> +
>               vaddr = ramblock_ptr(block, offset);
>               if (block->flags & RAM_PREALLOC) {
>                   ;
> @@ -2206,6 +2210,8 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t 
> length)
>                   memory_try_enable_merging(vaddr, length);
>                   qemu_ram_setup_dump(vaddr, length);
>               }
> +
> +            break;
>           }
>       }
>   }
> 
> 


Yes this is a working possibility, and as you say it would provide the 
advantage to avoid a size lookup (needed because the kernel siginfo can 
be incorrect) and avoid tracking the poisoned pages size, with the 
addresses.

But if we want to keep the information about the loss of a large page 
(which I think is useful) we would have to introduce the page size 
lookup when adding the page to the poison list. So according to me, 
keeping track of the page size and reusing it on remap isn't so bad. But 
if you prefer that we don't track the page size and do a lookup on page 
insert into the poison list and another in qemu_ram_remap(), of course 
we can do that.

There is also something to consider about the future: we'll also have to 
deal with migration of VM that have been impacted by a memory error. And 
knowing about the poisoned pages size could be useful too. But this is 
another topic...

I would vote to keep this size tracking.


