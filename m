Return-Path: <kvm+bounces-40786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D8F5BA5CFF1
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 06C1E7A31CF
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3269E260375;
	Tue, 11 Mar 2025 19:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yvjd4Gqs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0GLxtEsN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA1215F49
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741722761; cv=fail; b=OgUiuNcT9iQ/02dOFxrzzt+1PTBLwXiSItVOqhb4xMmECWtlCbN0yjqtdfKcLhliMeMOQTS8m4S7n1TO9VPLmtAa2m7vJq0aMdpBVSNBa71qaMRAR+T8ub2NEKfIDNLQMc3Dz+w6xUtIDdxZmScWsP42oNE8As8NQZ/vcQO+NuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741722761; c=relaxed/simple;
	bh=Hy5o8BzPpt2dkeFsv+0wsu2jA8tPbibsHA1ZjkZHOVk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oo/Oe28nMnZ4dBfnpT4MP4P21jbpDIQ0F53C69cgUZe4Z2+/2ODMFi/IorceTUZF2egL2qUDJOOXGbhxHwGbSxV1y3mNyENLIs5iR/ChteCVdu/40DSkj9dNvKwhs5wlKHWr4PtUEfNDBLaBa4hnCCWkL+iF0ANTqpE1B+ixo9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yvjd4Gqs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0GLxtEsN; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52BJMld2018166;
	Tue, 11 Mar 2025 19:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=A3+gpfKOhJbznHB7yZYnELZXy4xn/VnlmEG3bUnJYiU=; b=
	Yvjd4GqsvwpIZEKviopo+l/zCTtglGHQZMyoZRuaHAtLgBuX1G8lCfeYakH7f5MH
	BbN/reinmjicTJ7GecFTe/JY4Kfs7H0s2qYdZhQQGrvuxWWzn1x4YIdsvjNobPcb
	gkys9lkgf6bX7OdtzElWnSxlDDWLefkb1THjlABBxnO+Ke23jARlQDt4uKSggOPK
	Rhy1hufMrqrsCnYBn0gmPuojC+5DONMp4P3XWC0A02e7DWUoYteHv/nNkA0riXdB
	CDLU0av07p6P08Gx9MQngofRhJ8yvLHQNiFH/r9gwAIVXu46sVf2XeeRvtMOVM64
	rzIb4bjFedszF+5fcpwwZQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4cr2w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 19:52:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52BId6sD004179;
	Tue, 11 Mar 2025 19:52:09 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atmyu34s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 19:52:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=shQkmMckCG3l4xNJcJ2agvjvCJqsBmBIWlaVACLI5G3Y3Uex25dejpTExB8KGzov9aSzWVduo/LUr6M+S2JBCsjClP5ruBcEahnh8kmx/v9tnebWKpMtR3bami35SbeolUkK1s7d/pHEj9CTMifc7GIJFVAviGcyOg3O4DEMHpdrgTN0oaxR2sU7ttETeF7bpk8ZfzVKUuzYHBO+jI85aINrLcXseIQrMepnaeWyoMsKRbzZcgQkp0bTzWVOFH8Pqm2huBgVEgU6M7dvISeW4lja9ZQraWj84SfM62r/KzaiyAnpbpS6rmm3aC4AEg/mfeZ/KrdSTGwzK1V0yFK5EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3+gpfKOhJbznHB7yZYnELZXy4xn/VnlmEG3bUnJYiU=;
 b=V1SxB+eeoRcY4HIX8KKCaMi3e5CwJlFbzO93pVfHKxYFjz6Fo1mdXGX5Q943jVmQ7XQ5M0OFL/uRvG6Y+u56qDGZSf/U3IcAT9SwmJEhBXD4z2UON425tOBNU2HgcBLJQF23hoMTQ0wr6OjFye+06BJm3lMSgtk2G1s+WSpppyBNjExAEt/GqZJU8r07JxnNJ0uJiVz8JPUCj5McdQMUtY/LEOE4Z5wyQK1Xg0evc+po1ZnXwfIOoUGKt1moNoZ6woYhv6S2jCXqKIEPrOA2VCTtuHSL0Uv3Bynep6CkWz7u+4xr2er9SSM3gHsaDWHMYltXx+s1VKvS4KOz/gzaag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3+gpfKOhJbznHB7yZYnELZXy4xn/VnlmEG3bUnJYiU=;
 b=0GLxtEsN28US0EeoP14umX30XzerZbHwKgms1Sm71WYwpAHkLv3EK47HLTp584BKSPpeyj2myrhH9VAVoHIfYkP4ZOV/luEF4f/F0IVKYrx7f03fAxU2iXYwO3+XSVfBB69GGMeh5fCbO9KjsGmeyqOBXkyzV5p2+nNoxDmhRFs=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by DM3PPFA9583E3CA.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.18; Tue, 11 Mar
 2025 19:52:07 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 19:52:07 +0000
Message-ID: <976f58aa-5e14-4dda-ae07-f78276b54ff8@oracle.com>
Date: Tue, 11 Mar 2025 12:52:03 -0700
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
 <a52ad0b9-4760-4347-ad73-1690eb28a464@oracle.com>
 <Z9A/0RE2Zc7BKDvD@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z9A/0RE2Zc7BKDvD@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0029.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::42) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|DM3PPFA9583E3CA:EE_
X-MS-Office365-Filtering-Correlation-Id: 531093c4-3a72-431d-cac9-08dd60d633f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a2xwa2hUbDkranB5dTA1bmVVaXBBeWhtT3VJVU9GWUhaRlZCSUkzRkp1V1Ni?=
 =?utf-8?B?Y1ZpMXFxYUZJK1FSbkFFa2MwNDIvTEZyTFV4NW92WjZua3lQUkNVRWx6OGRI?=
 =?utf-8?B?bkR3K3dVc3NIK3pRRzl3NjA2aEJMYnZXcU1ZQlpCYTR2d2pTT2QvY2dlQ2kr?=
 =?utf-8?B?SGtpRHhLaUNCbmVrMk1NeXdWNERQNGw3d0FpOFN0azdPMlVFazlKbTMzZCtx?=
 =?utf-8?B?QkpFYlU2a3I5M1A1WmtsdGE3ZGxpK0E0VDdxNFM4UzVZeW1ibVFUWHdoMURM?=
 =?utf-8?B?cmpRcnk3VXc4bEFvenFWWEc3TTFxRlFWWHA4OEVWVTRBSEU1YW5QbUdaODF6?=
 =?utf-8?B?QUpjOU42WVBQWkdtRzN2c1VXaG5NL0JVTFgzY0NzME9tM0JPNy9ZR1NpcVJT?=
 =?utf-8?B?QktVcFo4RkdDajNTNkZycE8rNG9JWFJqL1NkTGNScXFRWFZ2N2NvTW90VWcr?=
 =?utf-8?B?eElOaDQwZTA2WGlPckp1MkliVlQvMitGQVhNNTFQRVdyalZkT3dXV3pqR3lp?=
 =?utf-8?B?MWpmUlJYa3o2Uk5sZWN0eWh1Z2ZRYm5BR2ZlZGdqdnZZb1dXcVRUdkIzbGZG?=
 =?utf-8?B?a05tbkJMY3J2b3NLRUNQdG9KRnFDNEFvdjVBNkYxOWdVcHFaNHZYM0dGbFBS?=
 =?utf-8?B?cGxRZ2orNEJyUWtZLzQzaklsZjYveXhiZFZVVGMrdm9hVi9YR2cyeENncVcy?=
 =?utf-8?B?MThyNDRIWVZkZ3Njb2pOQ0xudjBaQVE0UlJvQ1gwcWdHTFRUWW5OMVNSMzJO?=
 =?utf-8?B?cjByRG5mNGNkUXpvV2w4RXhMRXE4ZzRENzdxWTI2RFQ4OEVCRkQ1T2lWTDZw?=
 =?utf-8?B?UnpPM29zdHpEOXA1Ynd2M00vdHdRZllJZXpKVmtaSW5lMU82T3QvSzVYWGND?=
 =?utf-8?B?QXdNSlRQTnFQMDRwNTl5RTFyN1Zvak1rbU9lZnBKNDZ4SzB5cnJqYzE3QnJC?=
 =?utf-8?B?Y084KzVWeGtscjhoenRIRlpyMjRpbVNOSnRBZVFsRjJqRFlsNDJpTm1RVkE2?=
 =?utf-8?B?QmdYd1FFdGdBU1lGWkpmSHd1b1NRYmRxc0Q2UDdGU1pRNjB4ckVCODE3NTdn?=
 =?utf-8?B?YmVRdU5CYlU0b0I3MzFEUWkvR2l0WnpISVlLSUc1NndVbmkzbzNVUWRadDlQ?=
 =?utf-8?B?MnpqRjduQ21UMHpSMTlnN2hiNjFEWUNnUmdHTGwrWXoxY0RtWlo0TURrSkdB?=
 =?utf-8?B?d2ZqN0NpOFhrK0pVSGpkMDN5MFgxc3JRaExMeTNOcDlUdkxDTXpCSi83QkEx?=
 =?utf-8?B?WVNKT1NRN1BUaHpla05sVnBSNnZEMzlBaXJaaVhjd3dreFVkZHgvZFEvTnJm?=
 =?utf-8?B?Y21DcXk1RGhSQWpRMHNiRzVDT0MzSG1tYnRPUXJtRU5VVnAwMlJXK1VZNjRH?=
 =?utf-8?B?aS9EbFlSZXRxd2JkWlBTS01xemFYcm5LSmNtU01aUzZhM1NDbjVvaGV1SVd4?=
 =?utf-8?B?bE9MR0wxb2VZd3NEMUhpeE5pR0ZvNWxnQkZSUHVBaEcwUkJPallnWFlvQkhS?=
 =?utf-8?B?RlJUYXRzMWxSQTM2alpUSTlROUFMd3BEUFpFcTBiQzZrTUlneElXN1lVVkZK?=
 =?utf-8?B?eXR0MVNCYXRzRXNMM3F0K0g3KzVJR3Z1WTVwUHBYNXBVZWhPS2U4NFlZZk9j?=
 =?utf-8?B?TnVGR2E3VWIvb21tZkdTdjFDbUtWdnlCUUtSNkhqWkJYajhnTXllVnM4UWpY?=
 =?utf-8?B?alBKQlQ3Y2ZDUkZrZ1NmMnczU3pZWlhQVUhCb2luRm1sVFRGbU13NGZWQmZR?=
 =?utf-8?B?Mk1hTStKQnRyS1N6QzByL0lQU0ttelFTUVJTUDl3NzN6T1VKcTZ4MFpaaldh?=
 =?utf-8?B?clgvMVQwSXcvTkhaNDVFOFpram5pLzFYT3AxQldnMTNLTXJmUk1SMHhhVW13?=
 =?utf-8?Q?7fdc7QDSNXR87?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0dXSTVWWE1rdGNlOTQreXJNN05GbHp5VGZqTVpyOWhNUzFSdlFvZ21RK2gz?=
 =?utf-8?B?NVlaUG8zMWZuSFN5VGJiUjhOVm4vS1V3L24vWnZYMmV3WHRaN2R3ZG9HMkto?=
 =?utf-8?B?UmhYaWJ6WkRkMzBhYnhTblJCRkZPeTFhWjhQQUwzUnROYk9RMnpSak50ZlA4?=
 =?utf-8?B?c0hyU1ZtYm5HMjNHVG9sM2NJcFJGcjE1Z3VNaHNYTSs1SXNjYWgwcHA2OFFN?=
 =?utf-8?B?VER5K3JQeTA1WUE2dG9GR0lCTFNZNGRPNFBKRmZiQWExd0lNYTlIQlBwZldB?=
 =?utf-8?B?T3VyVWNNUzZhaHNOcnM2TVpUOU9BY2JBcTVwVG5QaE8xa2p5dno5YWh2TzdR?=
 =?utf-8?B?ekQxaGhDYngyTiswVTZmOUhMRTFxUEhvUW1nRXZiUlc3OUZIM2JVM210RlQx?=
 =?utf-8?B?Y2VEczd3eERncjV0K1hmdXlYUVVHclB6Wk5hRGtrUzdEeERMT2R5U2o4ckN1?=
 =?utf-8?B?VlplQnQ2emkwSUdJTFRrYzhnTWlqYWplRTBqY2J5VEl5SWprOGkrWDRMNk5C?=
 =?utf-8?B?cEhKVFZqYWMvdHJVc1lqaUMzbDdIVFRaTFE3bkVSd2J2a05EV08xTFJBOHpJ?=
 =?utf-8?B?dDk3TWdXUmx1UmI5YkZ6MkxmbjJ2L3lvZzNGcVEwUFFZWUs2Z0tGUXVFQWlP?=
 =?utf-8?B?bkJ2OGI5UDlEbVo2OS9pbVJpRnFEOTdGOFJHNTdyeXF2MFlmZVZZend5SXhy?=
 =?utf-8?B?amo4bUVUSGtCQzRUU1h0bStMSnY0N3hnQy9ISTQyb1RkbFRtMjV0UTVwQll1?=
 =?utf-8?B?eXJRWFVzMnJxem5wSHZKc0l6T3FhMEh2SFpxSUZxQU8xbS82RXFQTitFZ2JS?=
 =?utf-8?B?NGM5cHRhdXdVdzcxRzVsMk5TWk42WHQrNHJNYXhyK3JEb01tcC85dXZuSzFJ?=
 =?utf-8?B?TzdBRjNvOXdVckFZVndSbnl3VTFWUE42a2xFa1g1bkJsU2JiKzlWeEhDQ0JE?=
 =?utf-8?B?S1NaaWF1WDdBWS9JZzVqZi9MRDc0Z1F1YnFMTUNiYy9aRFpZZEM4dzBjVnNr?=
 =?utf-8?B?SExWb3liQUpJZG56M3dpcUFKUU41UE44OFFrSHhOVExCUXVBUjRrcDljbFEr?=
 =?utf-8?B?MENCUUhzT0VPaHNxdVJKM0pEUXVMYkczTHpGWG9qRHQ5d0gwUFc2bjArMTVD?=
 =?utf-8?B?ZUJJTHh4bWNZMXZ2ak5kak1MM1ArS0NJenVZNG90SmZ0Vk9jQTdUenZ3WHlZ?=
 =?utf-8?B?Y3hxdStxeGVTRnhDbHlZMlVzYzJoQURaSlhlaUZhSThpS3RHeW0wTk1jcjBM?=
 =?utf-8?B?bHlmalhVNVNQelcvdmR6MjVoT2xPZmErQnNaMFMyS1JLWGJ0elhsSlFsNzRN?=
 =?utf-8?B?WFRhQTF2Z2dnSVI1eDAwZm56emJCRFB6U0g3dUdXYlNtZi9UOUpaYVpsTEZQ?=
 =?utf-8?B?ODFoMENKUno4cmxYNGhBOGlSTkZhRUxhTjQvQ2hjdmFyRGFMZlVQS1EreTN3?=
 =?utf-8?B?NjNvYXZSZExUS0ZPYkFJT1htOWxNRzk2ZE1ZYWppNERBSnV0bFNVUlg3aUVH?=
 =?utf-8?B?VDZGd2Z2cTFFMkRoUHl3TE1DbmtVMGR3ekNqeXNRWmk2dEFWU2hUUmhERk1h?=
 =?utf-8?B?UVRCOTZPVjhGenM4aXBPTW00VUwraExsZWJiRmZkeUdSaEl1K1IwZE4zbnNh?=
 =?utf-8?B?czhUbGozdjlQMy9hS1BSNVB6eDhnbEQ1V0toVkhuTTlxRzdTeGRlZ2c0bzNU?=
 =?utf-8?B?MHRrc1ZxOG91VjRpRkd2SDRzUTB6M3ErTzEyYXNwTnNUbzRCV1hrZEZQR1VY?=
 =?utf-8?B?eWw1R01MOExkMEo3d2xyaVlBaDN1MldCVGxQYm9Dem1QbitkNjhzdm5CR2NQ?=
 =?utf-8?B?aERWdmxJNisyWXBHWHEzTUI5L0g0a2hQamtkUmh1NnUzT29LUklhUEdTWCtB?=
 =?utf-8?B?NkhMWFJ3alNUWWVZQlZZTGdabnRvV21MZzZVOFhVTjNqVG9MVXlVaVY1OGtP?=
 =?utf-8?B?Q25oUXltS2k2eVN5d3ErZFREdVF5c0FQeC9DamUyOWs0bGNJeDhKZVNwZEVO?=
 =?utf-8?B?eVdaZ3FFQ2VOaUZsRTRuYVJGZDJTWHY5NVNTTEN2eEIrOCtSSkFIY1RtWFpB?=
 =?utf-8?B?Vi9mNUhQclN1c0VrRUozUU9SMFBTdzJEOUhPU0RKdUZwSmFUZGgzS2pldGp6?=
 =?utf-8?B?YjQ2N1N3ZGM0RDJoSXk1anp4c0VDOHY2cHdpaTd0UkhaWFIveFc1TlZjeS9p?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4W5eZdi3gXBROrJeA6oPzEsktRx+cO8XmLdwRzW6koCTDH1vFoi2SWhd/yyGdoPX2ly01I7c0IkcDAuaGz1TNQKIP9xoBOzo8Xue7ZV9ELtuTOhYCNpzA4eGcFgo5d0b0EZiJn/8055jFQXYXAiZuGEaMG+cFvEvL4XuJqlDaqyHBiJa9PVzUcpxEc1i+x7Gm0gvd6IkyenDPvXnvcC/Vbw8D+ISMHK/OAXFAjKCM8Sw5RqC/7mSohS5kyI7WCkJWEw3IX73u7pdVrhrdYQ5HZ4NlNFFzxkPQi6Ns/LlvR/Dt9byfePi/Zv+9/ZmkfT9DGQorIuC+wvokHbKflYKLVjnnPNQzlDNNR35U2Tq8Y+PU38IAImdt8WAzcUhSzwe5rPUaNTnkuhH+SBO/0Ssiu35MZ/g6jXcoY4D59WcklCObk6FflWiW3kBLfz5mjKdD/kE5JYleDC5oreuGKv/5D1sVtiZ90u1VBBDEZOHfOLPikAikKLORXUQTnOd+kTaWMovLnki35/jsEYXHbTo0ziEYgCMgVrrMhfGwnWp58QpjJ/R/FQlX42nYxO9fzwftuTFoszIbKeLd1BW7doDqZgh3ZnXS5ueu98P9ZMoKyY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 531093c4-3a72-431d-cac9-08dd60d633f5
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 19:52:07.0384
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wafKOsEwzs226/9gFEQv+OltrWHGBE3aDFxesO0rmIDTYL8QHS630WAcqkU4pViQo89Hmsc58ETs1n9bdwW6mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA9583E3CA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_05,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503110127
X-Proofpoint-ORIG-GUID: zyfySWLy3vsBJKA7oVB0sIJYFL5G_hFI
X-Proofpoint-GUID: zyfySWLy3vsBJKA7oVB0sIJYFL5G_hFI

Hi Zhao,

On 3/11/25 6:51 AM, Zhao Liu wrote:
> Hi Dongli,
> 
>>>> +    /*
>>>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>>>> +     * disable the AMD pmu virtualization.
>>>> +     *
>>>> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
>>>> +     * indicates the KVM has already disabled the PMU virtualization.
>>>> +     */
>>>> +    if (has_pmu_cap && !cpu->enable_pmu) {
>>>> +        return;
>>>> +    }
>>>
>>> Could we only check "cpu->enable_pmu" at the beginning of this function?
>>> then if pmu is already disabled, we don't need to initialize the pmu info.
>>
>> I don't think so. There is a case:
>>
>> - cpu->enable_pmu = false. (That is, "-cpu host,-pmu").
>> - But for KVM prior v5.18 that KVM_CAP_PMU_CAPABILITY doesn't exist.
>>
>> There is no way to disable vPMU. To determine based on only
>> "!cpu->enable_pmu" doesn't work.
> 
> Ah, I didn't get your point here. When QEMU user has already disabled
> PMU, why we still need to continue initialize PMU info and save/load PMU
> MSRs? In this case, user won't expect vPMU could work.

Yes, "In this case, user won't expect vPMU could work.".

But in reality vPMU is still active, although that doesn't match user's
expectation.

User doesn't expect PMU to work. However, "perf stat" still works in VM
(when KVM_CAP_PMU_CAPABILITY isn't available).

Would you suggest we only follow user's expectation? That is, once user
configure "-pmu", we are going to always assume vPMU is disabled, even it
is still available (on KVM without KVM_CAP_PMU_CAPABILITY and prior v5.18)?

> 
>> It works only when "!cpu->enable_pmu" and KVM_CAP_PMU_CAPABILITY exists.
>>
>>
>> We may still need a static global variable here to indicate where
>> "kvm.enable_pmu=N" (as discussed in PATCH 07).
>>
>>>
>>>> +    if (IS_INTEL_CPU(env)) {
>>>
>>> Zhaoxin also supports architectural PerfMon in 0xa.
>>>
>>> I'm not sure if this check should also involve Zhaoxin CPU, so cc
>>> zhaoxin guys for double check.
>>
>> Sure for both here and below 'ditto'. Thank you very much!
> 
> Per the Linux commit 3a4ac121c2cac, Zhaoxin mostly follows Intel
> Architectural PerfMon-v2. Afterall, before this patch, these PMU things
> didn't check any vendor, so I suppose vPMU may could work for Zhaoxin as
> well. Therefore, its' better to consider Zhaoxin when you check Intel
> CPU, which can help avoid introducing some regressions.
> 

Thank you very much!

zhaoxin_pmu_init() looks self explanatory.

Dongli Zhang


