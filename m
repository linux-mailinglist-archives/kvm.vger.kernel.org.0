Return-Path: <kvm+bounces-40467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 842C7A57527
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 23:50:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C728218983A9
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC2125743D;
	Fri,  7 Mar 2025 22:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IivRPEVn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U3jAstgQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D1B18BC36
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 22:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387794; cv=fail; b=eqopggo49GLFThMcEN7+DmZaybXKaCJ96Dnm2Wdn7VHjcZ0p4MOBY9gkZ86QbJkQo1ytKlkYWGBsM8reDzho/KI8pi841u5U0O4PW5yDNSkFeZsfbX3CX6DswkiA1er+0ERUMGJBqg5tthTCTE7I5ugQLMWMHzUbvJ5fneDKg7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387794; c=relaxed/simple;
	bh=LjTskJDJ12zORNdneDr5YHLP85LQ5Bqj8Ptc9zi8c/0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cPX8lscf+GvFIOhOXmJKjBVvlhDbQj9GUYV81ut6mLDrxGEXWxaPGzUbsjQCRHz4uyVrCqf676w/lOlq0GQr0ADLH1K4r9eaJJVnNz3zB4Efg4N79s+iGtcig94hKdTavqpVrtntbK0XdUNV4xrZMSNS3qCLC9qSAVdKYh9gAhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IivRPEVn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U3jAstgQ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 527LIJdV008149;
	Fri, 7 Mar 2025 22:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3S1hxm+rCvZxTb8S4EWtpdW2jOhnOnzvwaN/F0/hkS4=; b=
	IivRPEVnYbeYC3N3uCfaqyJCVpT7t0p//ww2W4fHqL+nG7Ff+GgVV7szJssI0tkY
	gBqHhKpq+SOgP+J98tIfxgtPvm/1HUUW0SvLdnJnHJxI6PGR2T9ur27hJyU+4nPu
	jfF5fqDUlfTmJsBN0otlk2ze6h9cWWwWFYfhZXPgGDNJ0IardbK2kymIVmeeyNpW
	IYy7US/rhWlIMywUZz/YKWgEKLSco1DJGPiZKLRVQNyWHcWhv5gFcXmrrrDc4s7e
	BoUhzE9Abi4qCxzrpUUCnhhD6OKmnh84eQIAZDW4cA2b/xD95ihK8bY2Ws61SGZc
	FWPC6By0i5wLk+YR2h6i7A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453ub7da0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Mar 2025 22:49:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 527MNQQL011033;
	Fri, 7 Mar 2025 22:49:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpfr301-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Mar 2025 22:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZzvqFmn2Rim04jz0SJuPN8rPVzm+dawP4kHnnB3Kha5aeJF6LixoqUiDvsYc1eFf36Fl+jlnbNYsu1qHt4Z5zupX0fwGhHJgrC2GgT211AMVbJaCYBUWO5rcso9BSfBJ78FC9qd2u48zLLXGi43qrCB0jiKHVKO3lmNavA7cwVVQZF4qoLrhS6W4sYn9Fey+KeDazhDE/H4rmoXJ+AfxnEcaQxxBC4+wU7SLUhmsHocghCjoXCB/I3DMRDRGKqEQvANJpjpxzqoNA7E1OD95IbYYWeeakRFmcYkML/BCIUicaZbWbaP7Ngi6ghQTBo6WWerf8mh+J1z6ptrARXKEBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3S1hxm+rCvZxTb8S4EWtpdW2jOhnOnzvwaN/F0/hkS4=;
 b=fLjEhfSXZfoCuz1s2fUVgZkzEvjAZVdStBxUWHm9Sqwhj6l6d2TgCU+Q+56V4Z+I9lZQng/a1n0EXI5ghsv3tYdQjwU7T0KvPqZWGidCfP78rgZ8idGO1FgvF1/qqQIcdIoKHbDhwPqaMA7NHPnq3JqZ+96sDI/td+aAAsFUTyVBUsC5i5ahr8enL71/gawr21fY4/rtPo/1703oHfzvPBnqIaZvrSV+f2uigM0zV9C+5OyZN+Tpv2CXm8LOC0tXkoKV+tzFruwUNM9IX4cXVQaOgUp6Isi9/I533ITmmvE3FkbsmxB5oLix+WK50h/1fLZs//ND2zir+qwQllyBlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3S1hxm+rCvZxTb8S4EWtpdW2jOhnOnzvwaN/F0/hkS4=;
 b=U3jAstgQcBw5rDm/TfDLbyJ3R2tLIppVmkHk2glhkAKXnTlRRcyUDOjzBZjuJ27d4/DGkBfhINKU+yf6FeL9+aLEN+D1WKjp/eDcjgSdiKZEtFiNkQUz9P7ljU9qeDtUaGSgsbDF97WDFRhJVglLkmFU7lvhv04ROVDiQA3xE78=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by SA1PR10MB6663.namprd10.prod.outlook.com
 (2603:10b6:806:2ba::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Fri, 7 Mar
 2025 22:49:13 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 22:49:13 +0000
Message-ID: <6c330d2b-7bc0-4aab-88aa-aee89a254944@oracle.com>
Date: Fri, 7 Mar 2025 14:49:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] target/i386/kvm: rename architectural PMU
 variables
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-7-dongli.zhang@oracle.com> <Z8q6D8fqFmegi4uW@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z8q6D8fqFmegi4uW@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0093.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::8) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|SA1PR10MB6663:EE_
X-MS-Office365-Filtering-Correlation-Id: f47552e3-fa79-4bf7-7dc9-08dd5dca481c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MDVMdWRaa2hlamdkdXlySVNodHBjdkdEWEY2dVEzVVF5L05nU0thaCszQ2NN?=
 =?utf-8?B?VmJzNUJsZHhUcXM0NG1GeXB2VVN6OHNYOWRrbm5yZ2FldGs3YkdkS2NCMWZ5?=
 =?utf-8?B?WTcweWFvV255OU1lNUhuckFiWXJ3eThiRGpTK1FVZURZTjNHc0FlYUcvSjZ1?=
 =?utf-8?B?REtDeE5qbHlJOEp3NVRkK3RSeTFUN3V1QmM5cXgzZnlQS1krQmpmNDNwYTFu?=
 =?utf-8?B?b2FpNHlEY01xUzR0RkZmRmcwOXdrb2p0REhTUllWZVZ4NmV1cnRBOXVzSXlv?=
 =?utf-8?B?OG1qbmxpaVQva1Y5bHhNQmJ0d1NpRTRVNHZaMVE1SlppM0FMM0lDZUM2dk5G?=
 =?utf-8?B?NWs1bkR2dVJBNGFsbXJObnd0NHBsM3B1VlVJOVhaUnBXWkoxUW5PTURhVzM3?=
 =?utf-8?B?WkduMTVNb1p4K0JuZURrVEd4dDIycjJNbEYrWWswdEsrbHVHbTlHaXp0TU9i?=
 =?utf-8?B?R0xndkJRRnJQZzBCN1llRGJRb0pXQjRuZ3k5MDBWQXgrTUQ2NkFyVUw5MHN6?=
 =?utf-8?B?UXNFMkU4TFdzcXMzc0w1Rmo4WVlrUUtoV1hPOWR5eDI5SDlGY2duRlRWaTlX?=
 =?utf-8?B?dTV0ZmtXSnpVdXJnWTR3OE1aYUZYMFE0L1dVUUdwSjlpK0x3V2l6a0dmdkZ1?=
 =?utf-8?B?WGRMaHJSV1dTRnBPQW5pWXN1ZW1MRUxUV1BwZk92enROT1FxRFZGNU1qd2o2?=
 =?utf-8?B?L2VVNXpWNCtoYXQ3K0V0QllrbzN3VDFRc1IxK29RUHkvUzBpc0dMUkhMQkE3?=
 =?utf-8?B?MlYvTUE1NXdQK293NzlMSkkrRXZyUHVlMjQ1dDllVHo2NkY1ZTdYa2REU0R2?=
 =?utf-8?B?dG10ZkFvUlBmNjNzekRMMnRvVkRhQ3ZnVmk2cDYvMTBGb0dVRTA5SHJVU2ZH?=
 =?utf-8?B?d3FpWkFac253cUNCcHk4eklGL01GK3FucmhSVzk3MDE1b0NCUDJMVkNNc003?=
 =?utf-8?B?ZjdTVmJhTEc0ZDVzL2NHa3NMU0NnVkRIdXZnbXV2RE50RTRGMVdRWDVLLzJG?=
 =?utf-8?B?dUp4bUgxVmdTaHNZck92cGx4NXlrckVJWnE3QlU5amFBVHhiMisrRzN6N01P?=
 =?utf-8?B?WFhRemo2K24reHpqcVBGVWRoVnl5QkVxSzJkeGJuNjV1di9va1MveDNGZ1lM?=
 =?utf-8?B?R1M2MTVPTkw5YlZ5TFh2WjIzL2JsR0dZRkRlb3JlS3QrN0VLNDZ6MlUyZWZv?=
 =?utf-8?B?OGlGbEE3dUdla2xPa1V6YTMvQ2Y2WHVYK3dGQnBlZ28zT29KVmRjTGtyL0NL?=
 =?utf-8?B?cU5yZkF6S1pIYXBsN0UyUDJPditnVTdVYlh6ZE5DaFZ4RGtTdTZUcXZ1WGZj?=
 =?utf-8?B?VmlYMTd3a3paMFhldTRJaXBSckZ3VjFUNDVnVG82SEI3bEN3VDljdVc4M1dI?=
 =?utf-8?B?c0lxM0VWV2JRMElKSmhwZVh0WXhFb252UjVEVmFCSThDV2hXVTZJYnRzTFdS?=
 =?utf-8?B?SmNRaU9aNkJ0NjZXUWpGTjB1MllHQ2NiOVJwQjNaMUhZalAxRGhtZHdGUHF3?=
 =?utf-8?B?S0xsQkU0NG9GM3RibUNFdGptSTRpdkdHSGp4bEhySWh5ZUhOWW1pNWNGcjli?=
 =?utf-8?B?QzdtZno2QzRQcXNwMnpOY3lycE1zcGxONE15UGZQMHhxbDE0Vnc3OVlQVG1k?=
 =?utf-8?B?NnRrbDQyRkJUb0xWdU15NFYzV1hoU1JPSlVyRVRqWUxobW0raFU5bWVieWl4?=
 =?utf-8?B?ek1rbTR3Z1JoV1JVbnhDalNlZW5jeWV6aHJZbXdaZE1ERnQ3Vi9DU2psWG1s?=
 =?utf-8?B?VVV0Ri9lVWFHZG5Ccy9BTGRLL2VGOEZDWlY0d1ZoaytCS2FOeWx3b0x5N0Z6?=
 =?utf-8?B?T1lHcDZpczkvbEMxN05nQXNUOCsrUitJT0lvaFpaZWwrSEwwWXZrWk9Na3hy?=
 =?utf-8?Q?EMagFmL+qhWc4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk90dEVwdzBiNGtsQU02SjFMK1ZCUFNIT1l6Z250QnBBTXVodEJIWHAyZUQw?=
 =?utf-8?B?RitsRi9oTkRnaDhsajNTbUxYQzJWYUxPV0piUTJuQktaWTBsM3g3RTRFWU5m?=
 =?utf-8?B?OVo1RDd2eEFjRVB4VlBlWmFNRkIwajJZdUNOcndjeDJacWo0a1o5Q0pvTHhT?=
 =?utf-8?B?d2IxaURRak9VZURXM3k2MFZMQ0l5ZVVaZThTREExL1RjekNnWkZ3VVpvanVT?=
 =?utf-8?B?VFJIdjlaWmd3RUlaZjNmNUdWY3Vsd0ZHQitWaTdBTHl5SGd6SDdMNXhrd2xY?=
 =?utf-8?B?TDFHT2E4WkVnL2o0VUZ3NHVCb1g0ZS9JWitCeWRvaWhINkpZeVN2ZEhFOXRn?=
 =?utf-8?B?OTBsUERpSjJWRmxNaGxaaEpaUmlaaWZYRXhLZk9VS1ZnV1pveHI0SHF2WE9Q?=
 =?utf-8?B?R1Rtb0JYR2xpVDh6MXpnSXByWGZmclA5VVdsclgvVllPZEUvUzlPb2x1czJq?=
 =?utf-8?B?Q1Eyb0tJRjQzbVp6a0FDZkNhdEVWeTJOSjhCN3RDVzBTbE16cENQZ0k5SUpY?=
 =?utf-8?B?WjlzMXZJbTJxVExQKzVxR20rcjVuZ1ludFVVREk0UzBhTktobmZ2ZE0yd3Iy?=
 =?utf-8?B?UU56bXFFc1BHOFB6WVp1ZEgyYWt0Z1NCd3BxM2t1bWFxTlk0UE5QUGMrdUpK?=
 =?utf-8?B?NjRnNzlPTnZ6WVlGZWZ5eXZHc01NZWNCMGtsQWZhVi8yQVhyelN4b2ZqdDk5?=
 =?utf-8?B?NW1jY1lCbG9GQm5xaXFHaDdZMmxTWml2VGJVQ3lNU090akg1UnVCVnM1bURH?=
 =?utf-8?B?Wit1MStvVGJacmhUVHV4L1hzVk8yY1RPRzYvdWNqTXkrTXp4NGtJWVQrZ0Zt?=
 =?utf-8?B?bmNRYVBnSHBoS2h6S1orS2JEd1h5ZE1XMmwzSzdBM3RCQit0d29qU0dtY2NH?=
 =?utf-8?B?NGNoQWVyNVVHUFhvclVwVjdxeFlFTUY5YklvUkFiclIrRTl6UlpXaDhtcmk0?=
 =?utf-8?B?Sk80ckNRQmZBTE41Z2pVQzhXc2lCWktMTmE3MWkreFhyS092V0tkNUxhMFZU?=
 =?utf-8?B?cWR2WEhtODZIcWdleXZjeXlVTlFzd1RDRzgrdkxUOGllS3BpUVIvSG9GQldw?=
 =?utf-8?B?cm1USXJiU2xZSlZFaHVlcmwzelNxWjVTbmpKNE9xWURpMGNtY0Q5VzRBN3Fk?=
 =?utf-8?B?Y3N4L2w3M3d4LzV6ZnQrZEVVaWdCbDREUXFWeGhmeENoS3k5R1ZCeCttOTN1?=
 =?utf-8?B?dXl2WVhKU0dHenhMVzluMlUyNXU1cnRhaVljblBaQ2EwaGhZa29VTXRYYW5r?=
 =?utf-8?B?VHAwUVFzc0VVWkU0RFRHTzlEbVMvSkZ2TXdZZ2wvMGN0QWVIQU5yNzFzQ2li?=
 =?utf-8?B?YTN0K1crSUhsTC9yQUtnTzVNSDROdmc3U0hsNTd5SllrdkNSWWNGVTNBVXR2?=
 =?utf-8?B?bDFRQlBxeDE1WnhCcjZiRk5pUU9NMTZQeE9kcXRhOUhQWDJjMDk4aXFnOFJJ?=
 =?utf-8?B?WnlTdWRsRWtnejhHMndJaWVqSEtIWnJxZ09ZU0U2Tk1PdVZ5Q0IxRC9Qa25O?=
 =?utf-8?B?TnVTd1pseG9JOHhzSmU2amtxTEwxQ2IrT2I1OVJxYUx3MFc4MW5nVWpIZlR6?=
 =?utf-8?B?QnYrNE9MNytVL1BRL3hwbXhYQWN3ZGNueU5aamwxaEltU2xOdG82MHRKb2Q3?=
 =?utf-8?B?TnI4VE1xUGJUMXhTd2Jtd0lTcTEzOGVtQ1dhalBTaS90Tmxkck9xcS9TV081?=
 =?utf-8?B?M29ZT2NEbzMzUXN5WHpFdTkzQ2luTW5mY2J2blVkbGp3WnBqUWljaGZYdWxN?=
 =?utf-8?B?ZWNGZG1lbXZLYWlJZTk3c0YwVHR1ODY1Um9lSjUrM2pJcmlqSGQ5cTNuNEQ3?=
 =?utf-8?B?WHNJTVJ5S0hIU0VjTHFOK24vMCt6MHNCTGgvZldMQlloZTh4dTNRYVcxVXJQ?=
 =?utf-8?B?R0t0R09wK2lHa2hkMzBlK3gvcDRITWhQY0lqem9DY1ZseGtqVC9YZEVsTXpR?=
 =?utf-8?B?M1ZDZkFiTkgwTFhHTnFYTENpcnhwRXA2M3J6WW5obkdRWERPeGpETm1tUW9v?=
 =?utf-8?B?amNkVjE5dFhGZU9meGg3WDBTdUtGZ2F0eGVHU1JYSDFOaUsva0pDOUZCT0dt?=
 =?utf-8?B?SWZCOHEyRTkrQzA3eTllSlNWMzh5ZlFRYWRxb3JnNXVVZ3pPSHgrZ3BSWjRE?=
 =?utf-8?B?MzhEL09hMFh1dVhML01ROFRFUHVpdHNBdTBKTEhDSHQ0OGc0VlVGcDRmN2tN?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WbrJa+oOhsGCpelq1Sczkj2Z1JC8itxA/FDlVDOXuSd31xQ+0psqxgDA6wLhNM7DZ6L2ooaWFHUdNpa5VxZ+1Tc8sdak5qUv4/UadP7+7ITT7pCVCNFoTmBQuN85tBMTjdiWqmwbZMdy+ZBlm8q9jp9rd6qfKOPdbuHp1S3cBu4cWFqcyChHMvfd0oYbYUkbjB5bwMoatZM9yjCC13IClJ8PrjIcqg3ADgI59hIvXNZ+w1IZ6zXxs0sxC7JmBZETg08WgaElB/PkJp9BjGe9pRr4lPoyN8FG9mQO7JfJaXbaKNG5kNKAfLYxSCpADk0+KEWl/3I/no/ADRkgP9HFwZqU2DaFAnhKP15KQA7XAI90jASizGE2hf1dXJXcLVqe2WIT+abaNNX7DFBT21S9V8Ufmi2CvFEyKJtlJMB7v22RYQUBtISJtDUOc7d2iUOksgG7whYEfXIg0b+EDCaN8B1+Nc05FQtQU+eBMdMc+uwLkaKkl4/rRLW5DVJHFfFNAgmDGdiPnk7E98YkAcbl110c1QiPE00Uaok9DO0X/v9wxPHUpZtuOymW8Z7Unwao9eZLLW8LMcBxGdWZ0w/ns1N6E6b1O0xsuujSRkdSPyQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f47552e3-fa79-4bf7-7dc9-08dd5dca481c
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 22:49:13.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEZXYptb4Cg3sxjhj+lwY/2QTNt5N1YfwzinItxSYlGPXcBf6zXNyaFtk3onBq7pnwIKqFeHvBM1EzRXB1GGFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6663
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-07_08,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503070172
X-Proofpoint-GUID: N__iaG2W9u5UawxF8UFrK7JvRhgOpQsU
X-Proofpoint-ORIG-GUID: N__iaG2W9u5UawxF8UFrK7JvRhgOpQsU



On 3/7/25 1:19 AM, Zhao Liu wrote:
>> +/*
>> + * For Intel processors, the meaning is the architectural PMU version
>> + * number.
>> + *
>> + * For AMD processors: 1 corresponds to the prior versions, and 2
>> + * corresponds to AMD PerfMonV2.
>> + */
>> +static uint32_t has_pmu_version;
> 
> The "has_" prefix sounds like a boolean type. So what about "pmu_version"?

Sure. I will change to pmu_version.

Thank you very much!

Dongli Zhang

> 
> Others look good to me,
> 
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 
> 


