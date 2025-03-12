Return-Path: <kvm+bounces-40859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B88BA5E731
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 23:18:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A749817BBCB
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 22:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBACF1EFFAF;
	Wed, 12 Mar 2025 22:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JtTCYbqk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YvcQiaWT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF8D19E96D
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741817879; cv=fail; b=CpCCO3WnXQBAt899zTGNKhNNLbEQtfyj4fcCcaeoB2FnmsNpH56FpQLkh1kNpR1WhevWYOqrSHzEPpAnxDhX8uGtw/l33hK0FKlt4P0nrw8JVR+4j0Z7e70ixuRB6xydeL1B4Xhvl4N6UMPxlZL7xV3ojvBXJHY+IXhrOdwzM34=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741817879; c=relaxed/simple;
	bh=E0DOPWMo+++4W+gWp+Volqiut1+BmAykJNLHdSSZ+hQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ivYZUx3yQxIjhmNR+s1BlRhavFjdwqUxpRgps6p3UdeicNMKTEn+EV9ESb/3c89S+JKAurxPZoIMKwZ6ltrsw3h2wq4YuLdoffBqDoK7ypycHOItxKF9pkaAjABUJ/OwLm9JzziJy9f7I0B739W7swCnDHIvt26Y+6BtG0DqE/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JtTCYbqk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YvcQiaWT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52CItrtv015513;
	Wed, 12 Mar 2025 22:17:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JW7eDsPO9SzTWCRVtOSSqfOqSO2MiEd0Tv29hfYcKII=; b=
	JtTCYbqkJDhxkYT5RUlKWUgu6ljQOvrzkatS9q3NGhsqo74aBARFGbdDMrhX7ine
	whfso48368uVq5AXw6MOLTcnVx9ZR1+GxAgWXN6YkBCuKqDXKU9rnRRpITn7ZeGe
	ceIvELYhKaYJe+pDZRu9SUWQ+eVp/vycBp4xFLZpRp7cdw+7iYqOL/UQjh2xFQ3k
	JCMKb8L3euq4rN+Nx/+uFjK1214P1Q9bb8D/8qvzagHxDvU7yVZpeiubMpdnivYL
	xskKcUaq/YsDoaEWuzCxcvm+HUCDg3of7VS+GhHZgOmtuqxo+bUmUNRv1V89sbf5
	fVqt40YgIyxAOt6QmgJPbA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4djxw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 22:17:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52CL6FAj002224;
	Wed, 12 Mar 2025 22:17:23 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn7wjev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Mar 2025 22:17:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vOOfUxHi6etN73Vm2P74r5Gxd2h+/YIWa11tbrBV1HJLEHhveu4PnW7/xdHBkjm4vl340nxYBPWqjeC2jrlDhAg/77ILh8zRJwTJ7RtR4Q262ruE8FCCnznL3GHEMevRXCKHaMlfWL80AFVC1uNnqRJ0x55eDVS3Ov1DGla/Bbci82/wPNYdsbJDJ5SjIfZG/Mr1rP4EiMsA6mfjJ1wFf0qUwd21ZkEpiEocAAJjO7cOebqYJB+pbKH+Jcw3ceFT3DPPCsFM4TwR5L1eT1j1NiicLbJCShzleSmEHqjjuqPwiKD2XS+QUdcA/mt755ZMGPQLAIbQKRGPvf139qx1lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JW7eDsPO9SzTWCRVtOSSqfOqSO2MiEd0Tv29hfYcKII=;
 b=bxAmvBbd1bLcrBidlqPPT7ZS94/X8prdPLFhSwc5G4C6H+QxXtdf4TmzBFalv057ao2kq/gj7sNfdYyaeNS9Jbtl2AJ1yGHwVJuU4Z52TcDHbG5GYugoOzAqfDYjrvoHz6bZaNMLNa2dF1KDwLB3SsMspvUIJ57wrv2DaNXcpvd9au8Zf82qFgzD//YMZvD2vFXEmBI2jzb6XswbsAt1kjIeViokEjdNj4DnvuCyGfONpFFKNWdP7732YHCLISO1yvu6h0bLUjm2fXsb+UDsUzps3icOB39m3h74kj1rfbqFw6sZJEaBY9jFHa0LkWIBPYX7MBeGw2MFmnf+/iNxnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JW7eDsPO9SzTWCRVtOSSqfOqSO2MiEd0Tv29hfYcKII=;
 b=YvcQiaWT7xHz8xESl32hQDlVa9xdIUgG4S3BuondAVNAD41PPjkS0cpCsmaXmPweMhy6NSasedCdPLop938SXgeA32v/r0dK5Dxh3lirCV+cKk5JMkiLy7OTiaP2700gS5umrLTlDmXX10Az6J/VFsiDTP8ESG7QdwuSkQOCz7U=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by SJ0PR10MB4496.namprd10.prod.outlook.com
 (2603:10b6:a03:2d5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Wed, 12 Mar
 2025 22:17:20 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.026; Wed, 12 Mar 2025
 22:17:20 +0000
Message-ID: <7b69618d-bec5-48da-a652-44569b0c750f@oracle.com>
Date: Wed, 12 Mar 2025 15:17:17 -0700
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
 <976f58aa-5e14-4dda-ae07-f78276b54ff8@oracle.com>
 <Z9FGDfzqimDo8SV5@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z9FGDfzqimDo8SV5@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0210.namprd04.prod.outlook.com
 (2603:10b6:408:e9::35) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|SJ0PR10MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 034f3fc4-e18b-49f6-4d04-08dd61b3a801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clAyNm02a1pRM0lIUkx2T2pDb1V1SURTaHBlY3FHWTZtek1TRXJUcXoxUUU4?=
 =?utf-8?B?VThneWhYL3ZoamdnTll6bzdUZlJvZnB5cFJLVldUdWJlUzJyRzdjeDJ5ZE1O?=
 =?utf-8?B?M1BzdjZXZEVLY3VTeE9oejViMGUyc25qbnF2OFdZOXh6L2IvUEpqSEVZRE5y?=
 =?utf-8?B?V1Z0TWhuTHpwR0FYMURtaFE5QVl6M3EzY0VjZDdRZm5KazR2QjVwc0h4ekov?=
 =?utf-8?B?UmFCV091S1FCMTFFM1FxS0gvVkQ5MUVOS2NETUFSWThWTlRNK01oSGhjT1lP?=
 =?utf-8?B?czBhQmVDN3B1ODJvQzVlME8vVUhEMUhVdGxMVzFhTk5DR2llaGd2S1RqbU4v?=
 =?utf-8?B?WUw2YVpxZTVtT0o2K1pKdHdYb012eHVTT1R4TisrcnBNdjdrOXd2RWduMldB?=
 =?utf-8?B?c2ZDU2NQVHp1ckptMVVqMmxBWjY0eEh1UFNEMDVobU1uZEhVNmVIYzZRWUxZ?=
 =?utf-8?B?ZnYwRlpNNm04UzFxWUpBWm5wUnNzVkJYcVkzYmQ5R3ZyS2MyUmxQbUw5Zm5T?=
 =?utf-8?B?S3dvQjZlWUJsdE1OWWhadCtud0lwWnRJdWRsaWlnYnZsMEFNRmtIc1JwQVUr?=
 =?utf-8?B?RlV0RG5YWkpoUTVLMzhkOGxuNkZlaWMxamR1ZjdNT29GZ2YxbTRaOTB4b21L?=
 =?utf-8?B?NjJ0bk5vdXZPOC9ScXphWTRFQ2lqQnk3Tlk2KzU4V2cwbkFVRzZqdzlDYWdz?=
 =?utf-8?B?UEVkQXdLOTJNNE4wWkpFWGVLSnk0R1Zwd2ZOSmJmTjhBaEVBRXkraWIwVUFy?=
 =?utf-8?B?ZGgyNE1TUlZudnVjbmNGK3VYMWlLR1RySHJDTElHY21zUkV0YzVaS0VrTjFJ?=
 =?utf-8?B?RExTdCtuOGNqVlk2anFUMWw5ckR2NUY4UmwrVGI3ZVdQZDRwOENqS1F5MlJx?=
 =?utf-8?B?NEY0UUYrSlh5T3JXSGN1Z3ppbjVFaTM0RGxmTVRZOENkb0NYQzMwcjZYM2Qy?=
 =?utf-8?B?NzBqUVlSbDBTSE9Ca0JsUzVudHg0Lzd6UGd5ak9HbTVpMXhYdjg2TU5IbkEx?=
 =?utf-8?B?QmVMWVV6Q21kT1ZmMnc3dE84ZDc2Y1R0cmJ1bzZmWHNjWXIzTlA0QlhMQXZz?=
 =?utf-8?B?TjZ0VUs2SDV4L1AxL0s0QjBmNE9TeHV2dTBIVEJtRmtEeHBHcERxNlhtMlNs?=
 =?utf-8?B?b3ZDa1pqeTBBTERXMS82dmI4Y2MrTWo4RUp5STFtT2lEaXh6aGQ2ZjNObits?=
 =?utf-8?B?WmpzbmNDdXJYZEx5OSt3ZE9TYzViM0xIZDRxVlh0dXQ4eFNaRG05V0Z5eGVT?=
 =?utf-8?B?cUhWMm11VC9FeUdVTjBuWnN1QXFDMjF2cGNMVCtmZ0dZMVVLZ084NWw5SFFB?=
 =?utf-8?B?d0hOVVhxZlJYczBOTlArdG1Vakd4WFk3UUFla25DYmlGNWpSa2tTR1RqTGRh?=
 =?utf-8?B?UlN6ZURuNFR2RmRnaUJhMWVUV0pnNGE4QXdaWURXR1k0WUVPSmVQZk5DOG5n?=
 =?utf-8?B?a2I4RS9qcDJ2b0gyS0VXYkZSOW95dUMrYXJUY1p3VkVyOTZUYnZLWXBCdmFl?=
 =?utf-8?B?QlN6Ti9CcER3ckFNNFRmVFRLd0FJZkpIVWp4dGw2Ky9Ka2JsRmRnWVhyb2lh?=
 =?utf-8?B?cHpMZmVWTHNHRU8rSzhyWStWdnQ3ZmdWYVhBMnhXMWs3cm1KVitIMDVSZUlQ?=
 =?utf-8?B?eDVvaVVTVUdPbVdIS1labm52bkRHczB0SG9RZWJOcyt1SHdFNHhyRTA0OWVF?=
 =?utf-8?B?bFRsM2h3Y0FaM1ZWNGxubGpmQ2ZmUnBBbGNsOFlrMFhFSzkwVXBkN3EvbThV?=
 =?utf-8?B?L3l5OERSZ1JMcVY0cDIwdVh6clJLeEttcUN2U005d2VxejErZ2d0N3UzUzlv?=
 =?utf-8?B?d01EZzhQTktmdlVRUThRRHNiK1FaYXh0S1c0Q3ZMOGJnUTl5b2JVajNMUW9N?=
 =?utf-8?Q?RxE+rEg6RsYU8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEQ3eFpSOS9zQU0xS2lIb2RYaDFkTURaL3hEa1dMRjhwcmg4MmREeXkzVXR3?=
 =?utf-8?B?NUdQMGE2Rld4QlBmczRnYUxsakZndTViVVNFcm14THgxcGZSWkZLdXAxQVZN?=
 =?utf-8?B?VnQ5N1lhdFNyaFZTZ1NzSzZ0LzJRWmV0YUZ2QmhPaDZLeVlESDhOdDduU2lI?=
 =?utf-8?B?SExkcnI0TjQ2aUNUUkhrM0FhVGdrOUwyL0xoRVNQTGt6Z2Z0eGw1OHAxb0N6?=
 =?utf-8?B?a1dXSmQyZUlEOFlCQlZXbUlFSmNsYVhVUlRsRnRKRXNvd3AxZEhOUVBaWitp?=
 =?utf-8?B?NC9BVG52bnhjcTNsMVZBc25JUXhKY2xLbkxRSXJkU0JlRXVtdEgxRlVTOTNR?=
 =?utf-8?B?cjNtV1lTYm9aMVd1VCt6L29LR1BlaTduUGNJd3U1YXJaQ3dIYS9uTlY3SUQ4?=
 =?utf-8?B?Z3ZnbnUwdXpiZ0JKaXVVRlUrYnBlejR0Y25QTERSa1gxa0ZWYkFYM2VYZHVy?=
 =?utf-8?B?TWRIOUhpVHB4b0FKUkVXb3lhMTA1T1YzRUVxczNKR2J4VVZMblhSZXJvUkJM?=
 =?utf-8?B?eFk1c01ueVN4VG1lWUp5eUl0S0JBOG5hdEVYZzZkMXY5bTRxRng5aXprRGxO?=
 =?utf-8?B?Z0xIYUlYYW8zL2lxWDFzTlRVZVpYNCtDM3ltQytZcG02ZVRsU1hkSE1SenFQ?=
 =?utf-8?B?Ly9iN1RxNEV5TUxNa0N0cjhkYkNZcHRqWFlMN2dNUGhNWnMxYlNNaXVFWFk4?=
 =?utf-8?B?MG0vT2dOMFFzRmVINERWZ3hVODJwZWtWdjBmZTkwNEUzZk5NMUhpb0k1a0E4?=
 =?utf-8?B?dDVQOVlqNzBzRFBXMHNpQ3RPTkdaV3Iyd2xyODdFWDlsSDF0Z1RNeExlRzZa?=
 =?utf-8?B?K01FbTdKc3cwb0ZSRmF6c1pPQW82eCs0ZFNZbXY4YVE1QU11Sk9rU2xMVmVV?=
 =?utf-8?B?cEdYb3NuYWYyVUlYMmNDK25nbFR6cTNwOElxOHRYc3ArU0hMS2FlaWhaREM3?=
 =?utf-8?B?ZVEyTUJVaCt2TXBDNXdWdElQK2tlbXFhNEttRnd5Tm8xTEpyQTI5UnlRVnE2?=
 =?utf-8?B?NHhHcG5IV0oxMFdML29PWlZ3Z001dmtlMW1WU3NxTlAzZnl2NXdmZDlqQzRN?=
 =?utf-8?B?WUx5V1owVi9vK043TmJrRE1zQmxTejdDem1KWU5Fa3lvczNzbFBCQVIvQldt?=
 =?utf-8?B?VE1HRlFiRDZyMmxTcTlMNEVTRlVybktscTN2WDJId1hQdlArbmNLSGZmamJG?=
 =?utf-8?B?V2RwRkdvQlFlN3UzSmdsQXcwVVNKVXRTYS9JaklyWThGbEdKZ2lYWmZiUGQ5?=
 =?utf-8?B?ZjByOWVFOWJHRm8rZVF3RDJlbEFURUdvdnVlU0xFSnkzMG5JM2xRZ1pQSzhx?=
 =?utf-8?B?ZnlSczAvQ0JkTkQ2YXBnSWJ3ZjZ3N21nRFgvNzI3aytCRVZhSk5kWjUzOUhN?=
 =?utf-8?B?YTJ2ME8rVEJEMHI4QUdtTndWSnBjT0ErbUlVSmdoZE9tdTBhcm9MSm4zbi9Z?=
 =?utf-8?B?djNRbXFrNVZwL3dHeEtmS0w5aEp3SzNSeGhiMGkrRE5uWngyRGtGaHFTR1Vv?=
 =?utf-8?B?SVdHdWZMcmc1Vmk0bkE3SWhxYTI4bXdVN1d6NGZuQnAzUVJOV05iWFFEc2tY?=
 =?utf-8?B?UjZja1FzSzZoM0xCVXlyTUYyRWxzMlNudHV4UFBtTThNamViT0k4R0VhN2w2?=
 =?utf-8?B?MUwvYmswczNyRXFuUWxCKzZFMVcxNklCcHF5MkNzNkF1ajB0U1BMTXAvRVJE?=
 =?utf-8?B?dlZXdWJvNmlJZ2hLbGhyMW9EVVZhUVlnMFNscDhaTE9oSVlmRWtvVy9BWm9z?=
 =?utf-8?B?eGFZMmI1QXJTc2JsOFBwYUZLSmw0cjdzQjV4RXhPSEdINnNyeUJmd3ZFc215?=
 =?utf-8?B?ZUJneFB4L3o1QkFqZk5qOVlFMTA2eG02OVJSUjJiaGw4MW9Bc0x1Z0dYbEFq?=
 =?utf-8?B?Y2hPd2FVWkphRGR1VGVldHFhbWJ4OEFQMGVXWVlkd1N0VElUVk9nckc0dU5G?=
 =?utf-8?B?MFE1TS9CV2ZYb0NGVnR0cStnYld3U0pVcWx3WXVLQWZQT1hFY2FZWUVnb3V3?=
 =?utf-8?B?L09VT3h0Mlk0cm0zNGhEZDBCLzN4N2FOYlJkbkpyY0JrN0ZGbmU3MUpsbDYw?=
 =?utf-8?B?WVp2a0pZV2hlSW1VdnA0REpndXpoeXdWaW5uNDAyYjhsQkxTVXVCRmtXcVo3?=
 =?utf-8?B?dTkrenRNTW5Gbk5hOHU0Wnh4UktZUDlLYnpVS1RGZnBzT1hSQzZFVzQ4R1RY?=
 =?utf-8?B?MXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fZ2jHZ9EMYYtWBc7z+uXg+BeCBWJV7z/JC8h41oIP+1JVlbIe6/RRyeSzlNaqm5bHr7SynFPZFbJoQkgKmf2au7FFjbLK5rgpX2DwqTBv/al7sYnDqqEuMM9f1qofWRj4r1dnb7eOO8S1voI9AN0Xzh1N28UWiwV+VpMgzzwi3fRlkNGEo4pwyDkUPzphshma8EJs6oKeG+pJU2Si6tLW9XIpMnsZv9lu8ZWkDsSngK8FEvQxHbCiZSdMx8P9Lsev2zCIe8BDG7q78WUu9kJhoqRWcoakbi1kE+XGI49lol+rW5+Jk3ztVbd+eL+ZGwm6MSdK34UadDFvJW6HDAo5tutNJ1E7vl7rAXMvqgNpcqugDYBZeBFqaNCbcyMzYNnoBAh5t6qb+0ct54okEOwHHWX6b0wg3OcQdHrtloF1B3+17hP67UO8Dl8lEUM1T5EW697Q6mTL4AVWooqFxHKlrFEB4lbapEs2UXFrvqsR1HiBvGOjgahJJNydqiVEmoDI3C5E1doD+woqBOxAMLqaL5zGtlX5tuRQ7E2/vXNtC0smHdI8jtSRpUQlvWJCe+lQ0z8kdRoFdTz9fNdpgFcWZILWROnos+u77l2VRZyIcE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034f3fc4-e18b-49f6-4d04-08dd61b3a801
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2025 22:17:20.2952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MIBK4veqQo0+3FkCkmZCv3IrXHoyItTiqhlRu+33awfy7OVogcNxkOeAwBKCWQTvz+ee3W7k4cmgAjJzyPmIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-12_06,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503120158
X-Proofpoint-GUID: qJnVglXQ1bXojfBQX59Y8S8Z1GAmfLhM
X-Proofpoint-ORIG-GUID: qJnVglXQ1bXojfBQX59Y8S8Z1GAmfLhM

Hi Zhao,

On 3/12/25 1:30 AM, Zhao Liu wrote:
>>>>>> +    /*
>>>>>> +     * If KVM_CAP_PMU_CAPABILITY is not supported, there is no way to
>>>>>> +     * disable the AMD pmu virtualization.
>>>>>> +     *
>>>>>> +     * If KVM_CAP_PMU_CAPABILITY is supported !cpu->enable_pmu
>>>>>> +     * indicates the KVM has already disabled the PMU virtualization.
>>>>>> +     */
>>>>>> +    if (has_pmu_cap && !cpu->enable_pmu) {
>>>>>> +        return;
>>>>>> +    }
>>>>>
>>>>> Could we only check "cpu->enable_pmu" at the beginning of this function?
>>>>> then if pmu is already disabled, we don't need to initialize the pmu info.
>>>>
>>>> I don't think so. There is a case:
>>>>
>>>> - cpu->enable_pmu = false. (That is, "-cpu host,-pmu").
>>>> - But for KVM prior v5.18 that KVM_CAP_PMU_CAPABILITY doesn't exist.
>>>>
>>>> There is no way to disable vPMU. To determine based on only
>>>> "!cpu->enable_pmu" doesn't work.
>>>
>>> Ah, I didn't get your point here. When QEMU user has already disabled
>>> PMU, why we still need to continue initialize PMU info and save/load PMU
>>> MSRs? In this case, user won't expect vPMU could work.
>>
>> Yes, "In this case, user won't expect vPMU could work.".
>>
>> But in reality vPMU is still active, although that doesn't match user's
>> expectation.
>>
>> User doesn't expect PMU to work. However, "perf stat" still works in VM
>> (when KVM_CAP_PMU_CAPABILITY isn't available).
>>
>> Would you suggest we only follow user's expectation?
> 
> Yes, for this case, many PMU related CPUIDs have already been disabled
> because of "!enable_pmu", so IMO it's not necessary to handle other PMU
> MSRs.
> 
>> That is, once user
>> configure "-pmu", we are going to always assume vPMU is disabled, even it
>> is still available (on KVM without KVM_CAP_PMU_CAPABILITY and prior v5.18)?
> 
> Strictly speaking, only the earlier AMD PMUs are still AVAILABLE at this
> point, as the other platforms, have CPUIDs to indicate PMU enablement.
> So for the latter (which I understand is most of the cases nowadays),
> there's no reason to assume that the PMUs are still working when the CPUIDs
> are corrupted...
> 
> There is no perfect solution for pre-v5.18 kernel... But while not breaking
> compatibility, again IMO, we need the logic to be self-consistent, i.e.
> any time the user does not enable vPMU (enable_pmu = false), it should be
> assumed that vPMU does not work.
> 

Sure. That makes coding easier, with less assumptions.

Thank you very much!

Dongli Zhang

