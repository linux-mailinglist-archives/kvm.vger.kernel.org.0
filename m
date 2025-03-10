Return-Path: <kvm+bounces-40687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03997A59B46
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:41:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F30271889B17
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644A023314A;
	Mon, 10 Mar 2025 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MXz91jfZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i3663kGU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C21230D0D
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 16:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741624812; cv=fail; b=eB7Ic3HN29tGzG8OyqGMOvbmxwCfrS/hyLkfxSHabAUIFhvc3B1psVw2bGYRHly1I9+f8+1kTJWEOfPbKO2wh4DoVomOloIFCKVzfFRjNKPmTHyDN+5xdRzC2h1I812CCziutD0lAiu189gLBe7fC1uAp0pnHfTEQFgxbP+tB90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741624812; c=relaxed/simple;
	bh=CFXXGSSGgbAyE2qZKrFPiSWCM2WCkl7XLWjwp94exB0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oZGZ3AitUNTpWha88b2QeOk8HTuxLA91EuctkNYBkYEBfOTOPgQ1J2HdL5MX0ksAoXJGaTDonQAGXlgjnPtUKuz0zvWfqkkUnW5xBdu+8OUpFyb1aEBFydwROu+blLWg/YGxiiQSWLlMIqLOrqV9EEaw+w3SP1ppcZd8w7DTwSU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MXz91jfZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i3663kGU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52AFgDvA012660;
	Mon, 10 Mar 2025 16:39:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qokEhPgwUavT5UYVWzZTDOY51AolKBLNHIsirHlwqfI=; b=
	MXz91jfZAo7YKMt3SHZ5q6HAl9VqDATfoDQ+//rADvOyPjj6NAZHn+GIwhydrSCY
	luRVLSJOpxVMO/ET1neM0XCjr6QCzP8MH2E1b/5o2stTLW8MGjK88OO/96Moc2TP
	w26r6YkPbtUyYCgAMGJjZKsc0R1RWUPzoI/FvAJAVTENsx82AQlCNdWo+5wdswKy
	IC0Gx/aXIZchnxqNBmCnnO5OsqPI1GV1DXQvaxReo4gLRS+3fzS4tsSisugch5mz
	srlcZMVMStFcASTpKpKLtstl94NVs+guw7bE/mUfMvyMrqliDZAww4ZsISWEkpzC
	BQSfwWqV7NWRyhIrH7aHyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cp331w1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 16:39:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52AFNQjl020131;
	Mon, 10 Mar 2025 16:39:39 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb7unam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 16:39:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W019XD831Zs1DwSQ1WHcsfsPzW//f9WAGXT/J4ljmwUlPLKE8on9drDFXSn8FXsKLL/wZh/qJET3ligeZr6k84K3HyBzcXuZhV+Gfqev6zlV+CoFTxhcpLjEOV5srZ/Awsjr8ePXKV69k9aBhhrB8txVaQR4dR3YTQ0iOOq56PIkObL6EFMLeW7N7bZkz/bKZ0xdSpIAXD4994mDF5j1Gu4/Ajg4NKLEMChTBNhI67FRoP0i3vu9nUpbqhn/cNTin9lX1+U0v62w7I93hq9Y6rXwEcRPFRLbIDjoHE1xBGnjJOy2X0J9C6EJEYNLRDoMU34ueX+K9LMihIaoDGsu0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qokEhPgwUavT5UYVWzZTDOY51AolKBLNHIsirHlwqfI=;
 b=PdJKn0xI3LzNQytTCci0B5ZkhdZ1p2UIiFAg9x6jBV4cOKotOfBboYkkJZGC8eeK7/4Ckp+grwDcdBol90Wyznj8BZ4ZkWGWiTdGIe6BCRRfwHulfZEWcER4FknGPZSJ6DtYqcwquZ8eKK88B5RAXIN/ztgynP48rSY2zEEcMUp7ptrJ7uIyLv+ucDBaiuz+/d1xu1diN7ceNGPe3ckXVxmdb+ZarzP3hMLBO/6x/KwdyOJx9tvvrhrIaLl/EJF2fNZxpOFDSM5Y7J8O9ZfkeL1NvF8DR02KuMRP5YJlCD0aXOy48YmfGcsYmC6wEbclcr0/Y7OUbh3TKFkAY22BFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qokEhPgwUavT5UYVWzZTDOY51AolKBLNHIsirHlwqfI=;
 b=i3663kGU1rJz4PBuA/MEn33tbhPSWaGe/9YjK3Xj8a+SVckB11ssPzdHNqrPl1lUrRBwv9kwsu9X+44rAwTkUBBs/ZhEImUPhZpdbUWVO2mB6j5cR7HWUns8t0rtr6pOGr6K0SKwl+p0kebUULj7tT1FAQeU8gAaqUV9dLwQIZc=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by CH3PR10MB6690.namprd10.prod.outlook.com
 (2603:10b6:610:143::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 16:39:35 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 16:39:35 +0000
Message-ID: <a52ad0b9-4760-4347-ad73-1690eb28a464@oracle.com>
Date: Mon, 10 Mar 2025 09:39:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com> <Z86Y9BxV6p25A2Wo@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z86Y9BxV6p25A2Wo@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0254.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::7) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|CH3PR10MB6690:EE_
X-MS-Office365-Filtering-Correlation-Id: e3e17b0d-2a2e-4951-08ce-08dd5ff2246d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkthUDhETGFud0k4SVJFNzVsQWlTUFloMGJNVWw2MUp3RmVJUFVtTktjaGVL?=
 =?utf-8?B?QkRTNTlqVXBDZ2F5QkV4cFYvREw1a2gxYUppTTF6UFp0QVE5WHBFVHB6ZE9q?=
 =?utf-8?B?VDlvMWxiL2VrSXQzUS9sdktCOXBwQ2VVZWNkci9EQ0l6NG90eWtnVGpFNFJM?=
 =?utf-8?B?R3hXOStRMTFJclpRdVlOREFQemZjazltVEM4d3djWXF2aW5OaEZrVFlBODha?=
 =?utf-8?B?UWJsU245d2V4RHYwektCRW9SUExDcHVxSlBxOFQ3Q1JucWorMDNOSitsZFBw?=
 =?utf-8?B?bzZadXNIS1dyOU1LRkptcW1Qd2lDb1A5L2FtTEE5eERRbG1IRkJZSURNc2g5?=
 =?utf-8?B?dXFYYzNLSHVKdVVlYjlXbitnL0IrUkdmNHp0cy9RV2xDNUdicnNhYjZ4dG5h?=
 =?utf-8?B?ZGY1dVlSZCtnUFVlYjZVVEwyRE9UWW02ZFdFOWkvSUR2UWlwcEZ1NXlJZE9W?=
 =?utf-8?B?OXZhaXF4Vm1kWVBYbllFSHFPdEgxcWJWVDhMckNxcUk1R1U3Tm16eGN3Sjhj?=
 =?utf-8?B?a2F4SDF6T2lCaUgybkdJR1RwblozNzVwSnV4L0MwY0xXLzA3ZDE0YVdPakRZ?=
 =?utf-8?B?b3Ura0JXL2krZGkvMDhsNWx1RXg1bFRscTFHRnV4dVZ0anprNGxnTjVDY0ZY?=
 =?utf-8?B?OEpVQXdBZkZ6SVJ6VjVOLzZoTHhaMHExMkpDRHlhY29zSzBpTGVQRUlVWGlq?=
 =?utf-8?B?eEl2WGxmUHhDMGxtb1c3OGNDeHNNaEtnVElaaHpIemkyR1VIZytFa01TOFQ1?=
 =?utf-8?B?dnNISGtjSUJYcFNzaVZFdFlzekpjOTQ0SW94WlNibTA3cjk1OUR0alVZM256?=
 =?utf-8?B?WENKUFdnUmhPaDlLNk5NRE8zNU02K0VrQy91TXd1dkZpZ2M1eGNhZ3BCcGcx?=
 =?utf-8?B?YUkrbzIvbkUrTWtPV2NDZUh6YjBWQmVBYVhkL25NczdZUnprSERGZlVyNENM?=
 =?utf-8?B?TzdPOGh0bllRT0tUblFHZ01mb3c2MUR0aTN3eDJxVVRkd3ZqY2I2Yi9BSWxS?=
 =?utf-8?B?RDZJSU5ZbUl1alliQVJqUEZBK0QxT1dNVUU1YnZZemxIUXlWaGYwR2FjSE1t?=
 =?utf-8?B?emJNTHhUQjlDdnNibFZqeE8vRXcwRERHTXk1K2hyNFZBdHM3aVRGMThqTjZE?=
 =?utf-8?B?ekVoNEpKSWNJYmgxZVBpT0Z1Z3l5VVRpVHdUZWpyanZqNWhhQUluRjNBQXBy?=
 =?utf-8?B?bnQ2a1pwNWU5d3p0R1pKeHBDSHRaUHVHanBsWWU2K3h0am1tSys5R1pPQ0h6?=
 =?utf-8?B?UEU1NlhPNkV5Rm5uSHp2RWdvK05Jd085Z1Zab1BmdjY4Mzk4Qk9udGxNTzQw?=
 =?utf-8?B?SFh0QUc1OHlBd3NVYjcrZENFajk5anJmQmlmV2JjaDlON1cyN2I4SUR4RHZv?=
 =?utf-8?B?NXFGVkNqd3lFTTgrQlZPdVJ2VW4xQkpxL0VXZVJFUHhPRHJabGVRc3FqYTZR?=
 =?utf-8?B?TFZETFU5RUxNdG5FR1kxcmkwNlZFaW96ZVVlcGtWZ1JTVnhNY3JNVEdkcG1W?=
 =?utf-8?B?ZkUvQUZ1VGM3eGI2ek5rNVVoUXM3Wm9UaWJCZjlDYkNxRjlLSmpCejY1c0Fp?=
 =?utf-8?B?VGQ5bFFxYkN6SjMrcG9OL3doUDJka1hvckJWS0h2ZjZleG0yMFhLUXdHMWpt?=
 =?utf-8?B?SEFuZkFNTFhGYUIzU1pEdmZiZXFvS3g5cUE5SE1oL21iRUtOMWlBTy9MRit4?=
 =?utf-8?B?aFd1UEVwbzVRNVM4T3pIZHkxQ3UyT29ucmU4eUpSWEZSR2RaQ21OR3M4T2xs?=
 =?utf-8?B?VWY0N3p5djgxNU03TzdOYnljQTQ2cUQ2cElGNjdNSXBUNDZ0aXdvVjBGc284?=
 =?utf-8?B?Yi9wdDFvbEhMaXBXeEVkR3dOYm0xRHdKcmtxVUJtcmVINXN5d1lpUGtRc2k4?=
 =?utf-8?Q?S2/TL5j8RlMlR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alc3MEg0M0dzRm5EVzVuZnpBRHF0dng3L2pWR1lUekt6RUs1WEp1WDVxRG5v?=
 =?utf-8?B?SWVHaWx4TzJmS1Ira0RUend2R0JDSnVIY3E4dkU4RGkycDZ0SDY2WTFrUWhn?=
 =?utf-8?B?YjBPeENBUmI2a3F2bmlrcUplRWdhVDh0YWFhN0tJcWhqcG5sbWl1V2FreXRm?=
 =?utf-8?B?cnpnTXJ5eE1NbUlocGRibkNYaEt0dTRFTWFPMXloMkM1bnRHYkxSdi9PNkdG?=
 =?utf-8?B?RCs0VFdEd0ltRDE3aExiYzlaQ0s3dGxCVTRKWW9BQVVsQ2RhZDdFTGlsY01l?=
 =?utf-8?B?d3pMSkxMWWdvbnhaK0FvdGVoNktvcmdzSkJ1NVVLZEQ2Z0trVlJjNkZoVEdi?=
 =?utf-8?B?aDVpTkd1c2k1UlhGWFptcDNYRTRGYkhzQldoK3dqYWlWcVdnQTMrSHY3S2NH?=
 =?utf-8?B?V2MyQ1FyNXM4MzZRUERrcHc5TXRMQzMzUzB1Rjc0Wmx5eWdNVnlFOUxpSVJ6?=
 =?utf-8?B?dkhiSTkxZXhHYVUwN2tOaGY5RThOeUZBeXJiL2kvZGR2VGlpS0U0ckJtK2NW?=
 =?utf-8?B?M2NMR3hzUDlqcEJrWGgzcGo3NnJ6T09XKzIwbXBYMEdDTlU0OWZHMHVsVHZ0?=
 =?utf-8?B?aHltalZuOTMyTVJjVncydVhpLytBVEtTbGVwczRqY0RGdGlkWGtKSGsrbVha?=
 =?utf-8?B?WGdWdjc1MTloOGp0NFVBNkZpS0tiUDhkb1ZIYVZRT0pOYVkxMFZSUTR2b29N?=
 =?utf-8?B?NHMvbWFsNXB1Rzg2QXRJRG5namhpUXVUaWppYWc0YlRjOVFvZnR3ay9GME9F?=
 =?utf-8?B?Qm93UUFTNXdjNS92czdlZGt2SVNkVlZ4ait5cDZPVithb2pVdUFFK29Vcyto?=
 =?utf-8?B?TGMzOHZaemJoQWN4OFozUThycms1K3AzUU1saUpmRmFjOFZIcUlWdWZDSC9k?=
 =?utf-8?B?V1p1ZkFwY0NWSG1jT010ZFpIU1hPLzRabHBKN3dsZS85dytURzNQM0pHOUMr?=
 =?utf-8?B?a3ZLV1NrbmdoTFhJOTNPSi90N0Z2aG0vRDdYRkFsSGlDWCs5YkJ0SGhrdjFv?=
 =?utf-8?B?bDIvTjhjWmVzV1dsdTB5Q1FIZit1RTFPRGRxcFR1b05hQ1NQdFVleWZ2eHBh?=
 =?utf-8?B?M2E5VllvaE9RWm9NMmQwSndRbGJNMnd0WVVPVzJnYUFCZy9PZVdaRU1MVGsr?=
 =?utf-8?B?LzlqWWJXNTlyNXBJakE0RC9kT0M0Ym9PMCt3S0hXeDg1UWlPdjA0NkJUNnh5?=
 =?utf-8?B?SHg2TjFxc2VCSFB0R1VkSXl5UHZ5U2NJWkRlL0pOMzNNOXp4SEtNTi9vZE9X?=
 =?utf-8?B?dWFNTEc1Z01qcjI3MWRacExmSkhGNFNPWC9Gc01kMDJSbURLUzJvd2hNcHpv?=
 =?utf-8?B?djNlZWRsOW9aaExCaE95U3RnUlR1TStwZFVoRTFJNzJGR015aWd2Y1U3NGJS?=
 =?utf-8?B?L213T2UwUUY4dHhVZkczVEZmTzgwZzQrZWFCRUcxRkRsbEJZTy83bGxEYkRu?=
 =?utf-8?B?VHRLT0RjYkpkK3Rac3JtVUVhSFMrazVHVllxMEdUNDZxQ2xIc1dJQUVIVy9F?=
 =?utf-8?B?SU5JaStKZlBJY1JPNlM5Wi9YamdDVTczdkpicDU4QVJnMFRPckx2cUZKVDBh?=
 =?utf-8?B?TGQreXRrT3FRbjgvOU94ZnkzMzhvb0c3Q08vQ3BWUGxTTGRLbW93a3RlUDJz?=
 =?utf-8?B?QnE5dG5QTm1xWUFmMlNrc0x0NnliSWdSTTdIY2g0cWJvWG5QSUZLeWo4aTVY?=
 =?utf-8?B?THZmK1VqMXUxbFNVVC8vSVpZeGt2ZWZUOGNaT1A5a2JYNElSUWVBNDhLRzB4?=
 =?utf-8?B?SUcva01zekh5U3JwODlST0xGZzVCYUp4aUNzc0NWTEZLQUUrV2w3Rzg2KzRr?=
 =?utf-8?B?WG13NVNTWTlwY3NKT1JMOXlJdG4vWUE1Qi9vZmxoTFFBNEZwMkM2NGVNUHJp?=
 =?utf-8?B?Qld3bnRxZlhZVXFUczBGWTN6MGpaOEROd3FOb21DblZFdkdHdmg2T0FLQ1dQ?=
 =?utf-8?B?TmEyYzFJb1h4OEVtVFlqVEExa01zVWRZQ2lrcXVzL29NTzNwQ29GUHFUc1ZM?=
 =?utf-8?B?bFBDdjd6NjdCQTRIREZTRFJIVGpFeWNydEFGVVlSNGx6Wms2QVIxWFd5eno4?=
 =?utf-8?B?SFdWZUlBR0tVTTVadi9YUERnR0x2R2dZTFV4RWFOMDY2Z0c3dkU0SGx5cE9H?=
 =?utf-8?B?dVRqUmtNNGZua1U4MFkvYmlKekViM1NNMFEwWHM4RE44a3NhZ3U1REFBZXgr?=
 =?utf-8?B?aEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Cxy0W1dTP8st+2RaWGFv8aomzlc+v6rVVe2y3WXLpzxAbnZXlxSNgRTYLL/X5PptJDBfAfJsSwU+P68FKPQLfwEimd2gZrUnsACZhChD1fFXJz2zDKkNptM2fqdzj2Z/E70J97bnK2pPLSndbvHfXKhsGCBIpJ4C2prmjKGcyz1n+tKfTXFUu1YtSKbgABoZ6cFce7k1tjcXMKR1VEtczNTs6Uji0/ZPqnU4cIh72YR1/iAhRLcIGSKNg21+WNnDp9zSGmEYOstO6vEI4KPa5XrVQrgX7PAbjbyT70Wup2HQIfWjqgRD3+jxS69+ZioMUnZIw+eduoqH9RWlCSjsghCxSFKBl0b21eQOPF2I4X5/wC/H1MU6qj2T6tC8Kydc1UDmgTh9Vv69jaDvhAn/D9jWQdmiJiCtLrpaCpyELV29WwcA6yFX5KDMjfPEI5R0CVIduCmIxdRzPboNYGboGOjz7FycTTsV/FoVDlmxJ9hk5lmpfhyxKka/qOaGsRS6R/PiKli3GeSSLVbp8S80e4je6XjaFAJoQg6BblJm/NylXPAH2lOIXEDnvgINxcDCey5qoZtS0r4DWqmLjKUInLQDAlQ0HUTmoyT5gZ6I0/E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e17b0d-2a2e-4951-08ce-08dd5ff2246d
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 16:39:35.6594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JWw8pANixnNk+zhepzGQFUwnT7j0x0dUNaTWWYnGoOG9IjJoyywwSwRBlWNWxlgBAdwXj/wQkNbcmz5Saq+gOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_06,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503100130
X-Proofpoint-GUID: cIu-krnSuK82fG850jUqgsoTxVZpuI35
X-Proofpoint-ORIG-GUID: cIu-krnSuK82fG850jUqgsoTxVZpuI35

Hi Zhao,

On 3/10/25 12:47 AM, Zhao Liu wrote:
> (+EwanHai for zhaoxin case...)
> 
> ...
> 

[snip]

>> +
>> +    /*
>> +     * Performance-monitoring supported from K7 and later.
>> +     */
>> +    if (family < 6) {
>> +        return;
>> +    }
> 
> I understand we can get family by object_property_get_int() helper:

Thank you very much for suggestion!

> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4902694129f9..ff08c7bfee6c 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2106,27 +2106,22 @@ static void kvm_init_pmu_info_intel(CPUX86State *env)
>      }
>  }
> 

[snip]

> 
> @@ -2197,7 +2192,7 @@ static void kvm_init_pmu_info(CPUState *cs)
>      if (IS_INTEL_CPU(env)) {
>          kvm_init_pmu_info_intel(env);
>      } else if (IS_AMD_CPU(env)) {
> -        kvm_init_pmu_info_amd(env);
> +        kvm_init_pmu_info_amd(cpu);
>      }
>  }
> 
> ---
> Then for consistency, kvm_init_pmu_info_intel() could also accept
> "X86CPU *cpu" as the argument.

Sure. Will do.

> 
>> +    has_pmu_version = 1;
>> +
>> +    cpu_x86_cpuid(env, 0x80000001, 0, &unused, &unused, &ecx, &unused);
>> +
>> +    if (!(ecx & CPUID_EXT3_PERFCORE)) {
>> +        num_pmu_gp_counters = AMD64_NUM_COUNTERS;
>> +        return;
>> +    }
>> +
>> +    num_pmu_gp_counters = AMD64_NUM_COUNTERS_CORE;
>> +}
> 
> ...
> 
>> +static void kvm_init_pmu_info(CPUState *cs)
>> +{
>> +    X86CPU *cpu = X86_CPU(cs);
>> +    CPUX86State *env = &cpu->env;
>> +
>> +    /*
>> +     * The PMU virtualization is disabled by kvm.enable_pmu=N.
>> +     */
>> +    if (kvm_pmu_disabled) {
>> +        return;
>> +    }
> 
> As I said in patch 7, we could return an error instead.

Sure.

In addition, as we have discussed, we are going to pass cpuid_data.cpuid as
argument, so that we don't need cpu_x86_cpuid() any longer.

> 
>> +    /*
>> +     * It is not supported to virtualize AMD PMU registers on Intel
>> +     * processors, nor to virtualize Intel PMU registers on AMD processors.
>> +     */
>> +    if (!is_same_vendor(env)) {
> 
> Here it deserves a warning like:
> 
> error_report("host doesn't support requested feature: vPMU\n");

Sure. Will do.

> 
>> +        return;
>> +    }
>>
>> +    /*
>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>> +     * disable the AMD pmu virtualization.
>> +     *
>> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
>> +     * indicates the KVM has already disabled the PMU virtualization.
>> +     */
>> +    if (has_pmu_cap && !cpu->enable_pmu) {
>> +        return;
>> +    }
> 
> Could we only check "cpu->enable_pmu" at the beginning of this function?
> then if pmu is already disabled, we don't need to initialize the pmu info.

I don't think so. There is a case:

- cpu->enable_pmu = false. (That is, "-cpu host,-pmu").
- But for KVM prior v5.18 that KVM_CAP_PMU_CAPABILITY doesn't exist.

There is no way to disable vPMU. To determine based on only
"!cpu->enable_pmu" doesn't work.

It works only when "!cpu->enable_pmu" and KVM_CAP_PMU_CAPABILITY exists.


We may still need a static global variable here to indicate where
"kvm.enable_pmu=N" (as discussed in PATCH 07).

> 
>> +    if (IS_INTEL_CPU(env)) {
> 
> Zhaoxin also supports architectural PerfMon in 0xa.
> 
> I'm not sure if this check should also involve Zhaoxin CPU, so cc
> zhaoxin guys for double check.

Sure for both here and below 'ditto'. Thank you very much!

Dongli Zhang

