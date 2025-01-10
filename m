Return-Path: <kvm+bounces-35105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EE982A09CB3
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:56:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC63D188F72F
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 20:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F78215F40;
	Fri, 10 Jan 2025 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z5etBFAL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rYV3O4Dm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832B9214A63
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 20:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736542576; cv=fail; b=hmSZeUg5eTyT+f98H6wlG2BNsx7n/R/nkymZYdasNf5wK7Yl5BGC5BqidSkvouU2ABt1C1JJ2xlNg3QCQinJ6hl4y+bVKi6wjxe7CvDei4xpjPuHWUZ3FhDi/wxlMSEHL2ZwxfBxaNXn8SKCQfL9dD+hznsxhtGik71YUDqfdLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736542576; c=relaxed/simple;
	bh=8KoO3GKrYNxXzsFUa8nQ2tSShJ25LMVrdiKCJHTm+D8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gAV1UrbxnAeGDH+8e2SNmMAI5kMNWt3bgLrRF/X1cTtmWQbpPZGsEhUbgwmbyvgNho8YmBsZLE2HKJAyZl0GDQbtwRc4U5cdDMtVzfboEkWg2mKCnlFREnquYRRsvrVmE5GFwGYw4ArZF4ydLT9de4tPIbHLuruLD5aQ5XRmPkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z5etBFAL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rYV3O4Dm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKtqjL021203;
	Fri, 10 Jan 2025 20:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=G6ynm6pmaprDAqpGrUniNaPK0enEeYQPox19d9wcZWI=; b=
	Z5etBFALYV/tMkAw4VZwLqHRgD3YkS1jpj/Qtq2ENPM2/UUiKjcOqsll59a6sKK9
	pndAlo92nEzhoY66WXaMPKhL/ApoI+bvOIbdD0CYclw6094Y2iPlGRIym101gZz0
	XOVUbEOlIOA8/DPS6OG+lulAl4pOGsPN8XG3VZtFGBtixVTTv8GvFrXOHRxNjXwq
	MN5jHc3D3+4r4Ob1FVky8vwws0JBQHa8sxneyLNNsOBJGMJGiMKTjzQPoeIKN1ou
	kngq7EoIyXUyqymSGRSi+AbSJ8Bvm5MRW83QKaYjymh8p+RxOPtUn2MKWMBnWukh
	qoyrsRSL9mOfUena5sc9oQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my62537-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:55:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKq5Jj008568;
	Fri, 10 Jan 2025 20:55:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecrvcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DVBMEp5llEf0bTVxEkz8K9kzUJvq4VZItfJsLgzsXY6v1W/PmlGoJy+6IqDG+YSvQlsB6tESX4fmwtaQIO78uTKDdPYL+evphx7Lc4XnGo3qQ6n3ZQZhOT1hj4GqIXFBkEmi0twBX32+i/bWWLuFfNFYRT0D6o8bOrabUo+bidYu1jDjf8LfIfy7plOcziTahVhOCNDi1tfgL20sD6E/gHqgP3W84dJGmQCniqyeDa5gjPs94dcBHHpTO46FLqLTEsnyGg2NhB0c3rHPCp3baaTnS2lxpidpbDd3Nkzjgho0rCaP5lsztCrOtXhe78YaAhecEz2Xp5VE9mDqc6g1nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6ynm6pmaprDAqpGrUniNaPK0enEeYQPox19d9wcZWI=;
 b=P9SOcm3vfHywqrqp7xKjp/2n57uTLk98+TxmnZv2RZ9WTtJmNx17fbp5xGAdWCmlBrlMWo3TMcgVkLB77ykwLcKAn+FajSE3GFVy9APZfexWvY//0fdEsnMrbEvYg5ZtQL6m38QU8jk09u84Thrx/0uW2M+qkTJ6CG3ByA+n5NlZFWVVNzFgwWabZk9rLYoeCx5QyRY/VB/YqK0Lb1MHWH6hjvOBn9hA+stORm8GU6P3zCKIJ+r3zxZVhpn6lobJYzfqjCyqHarhB9hOy0e2Jb83UaqiRBOGREZ+cOYTylxo1GhlkGNQ7t7K8l+JvQozs0aQtIrHaK7b49hXbjpn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6ynm6pmaprDAqpGrUniNaPK0enEeYQPox19d9wcZWI=;
 b=rYV3O4Dm2smjYziunECZDZwNKA785INSmHHyk8GD1yMffeiHTz9jjZS9OmpZNOTANGeIirtOX3IFsE9CxkBtgSi78d1gmCygauavS8YCzaMnuVHg0IhBpRyb7wdiRcEmZSl6ZZeLrBA/jUSjmcs//OnV9dcTPree9WKvqio54ZA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 20:55:51 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 20:55:51 +0000
Message-ID: <e9c74657-b1e8-45e3-9cef-b18a172754b1@oracle.com>
Date: Fri, 10 Jan 2025 21:55:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/7] Poisoned memory recovery on reboot
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <6d771c8c-1ebe-48aa-b74e-6195738a041a@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <6d771c8c-1ebe-48aa-b74e-6195738a041a@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR09CA0014.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: 05c2039e-8038-494e-5626-08dd31b92ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHFiQTRyYTFuVTlhY0E4UkdxZ3NjbTFPTzdHYnlTS3JucG9FYzVZc2JKQmNh?=
 =?utf-8?B?U3NQdTNPQTMrQmRadjhmV0RBUmRYSlRiRTZWVGtuUkFqRStQY25tNStiUEU4?=
 =?utf-8?B?SjRHWmcyMmUxK3VvYlVPOE05YzNKdnJ2U0tHTkQ5VlhYMVFlN3pSbm52VE52?=
 =?utf-8?B?K3I5enlCY1FnR1V2N2dvZE14aXRPT213SXg0dlFQdHFpWTIxMnZUUzN6VHV2?=
 =?utf-8?B?Sk5kR2locGduSjUyckhKckRCcTk0Rzk1bDNSWVgvVUNCMzR6ZXlYSStiZkpz?=
 =?utf-8?B?WXFtN3dEeWtwZHZ0TTEraENrWEdSR0ExbS9VRXo4blV1K1BwbnJpMXNDRGcy?=
 =?utf-8?B?SGE2aE9ka0hVYmdCbkdSYlF0T3NaQllJNU1INUJPNVdLOTlIcEpGNDgyRXds?=
 =?utf-8?B?ZVFEUjVRdTlqbFdoOGhaenU1TnpYakE2cDdRT0ZLVFZoUVdUdUJGOUVqQjR0?=
 =?utf-8?B?bnloQ1l5bVA4d2pjN2ptTjh2WkEwNURXN3BzVjhqMms1cEtrd1draXNwWnJG?=
 =?utf-8?B?ZE5YcTNmWFRuMmFYRnRVRXozQXkrUDBJQ2N1WjlTYlNOclpmNGxYdWZOM0lB?=
 =?utf-8?B?WkdUNDB1K1BCazUyV3VJYXdxSHRNY2NFTE44TFY2V2VpZU1BODhGQXNCUm9q?=
 =?utf-8?B?Nzd4V2IrMTAveUhTMU1NRVBpa3F0RHEyVVpCWjVXWm04d2JBVU42R1JtNG5l?=
 =?utf-8?B?SjVIRDhER0wvMW8vY2Mzbis2RFRsUUhocDE4Y1laQjZ6NEdROGZiMy82elhP?=
 =?utf-8?B?YW1YdUQraERyRHZORG1LeURlSnFuWUxGdGdxa3BiL2F6aGJvOC9SZnVHVmZX?=
 =?utf-8?B?WTJGdnVYbTFtVVFzeXE4SCtoNjVVYjdGY3hiYk9wZS93bndlNUpXTWJkWkl4?=
 =?utf-8?B?Y0Y5STAyS2pjajVqWjlXbmcwL2dWbWlxK0RSWVlYTTRncHA2Ym9TMXJjaFNz?=
 =?utf-8?B?WHhJZnRMU29SMnRMalM5WmtkS1lOYy9JM3Yza0VSdmNpb2dnWi9iRUFsUDNa?=
 =?utf-8?B?NVN5bStRc0xYQXRQem44NFZyVzJ1RlJ5eUJ3RDJybll6b25GSWovK1hGeXo4?=
 =?utf-8?B?L01oM0l3UFN6d1I5Q2hnVDVrMzRrdGxNS21CekQ1dkliMWRWYzZneHN3RHF4?=
 =?utf-8?B?cEZtbDFuQXdSQ3RhWlJTTlFZTGNETFV0OVRLNm9OblJZZ2srZi9BWkcwNHdK?=
 =?utf-8?B?L0dtZXBhclZvSkloQjQya0ZHZ09RYjd5WmI1bVp2STlod2o0NDRCQXdTTDFQ?=
 =?utf-8?B?NkVwK01EcitaWHM4eHM4YStqODAzQzRIYnNTRnVjSHA2UFg4TzE5dExHM1BH?=
 =?utf-8?B?dkJYVVRxVGl2UUtRaGtLTzd0ZERpeUNmWUxpWU02d0RTZEJoTjVlU2pIbzB1?=
 =?utf-8?B?eWw1Lzl1ZmJYb3dFWmxRcEdDck83UTlaU005MXdQYWp4WFI4cjhDRTRXb0lD?=
 =?utf-8?B?bjJJM2xQQmcyOWNCRUM1MUxBM0ExcGZ1dHR6VE53QXZ4cGVrWnJ2allSWWJa?=
 =?utf-8?B?Zk1PZnNrcXRhVGpFMXNOeWN5ekk0QlJSMnliS2VUeWZEanZsREJuSE5YVHJl?=
 =?utf-8?B?TGtOMWowTXA2eERmN1JOeks0UVJ4WG1TdFM1UWJRR1V0YmVKTENWRVdxVXZj?=
 =?utf-8?B?MjV5RC9JRTFpeVJoOWZCdVY5TXV4N0FHbVpVNUk0MFM2Tnp6eXp0d01qOXBj?=
 =?utf-8?B?K1EwUnVVZjQ5a1NWWm9oY3BNMkxRV2luTEphc3ZxTnVhT0hBRzBoYzhlS0N0?=
 =?utf-8?B?RlBnUnpSZ2xXMEhoNFVhemtVTzl0ZjZJbUEvc3VaaHp2cXNsOUdtaFB6WVRK?=
 =?utf-8?B?U1NuNWFnVVdUakJPNk1KK01DSGE5TkFLMVZSUTlpODNob24yc2J3cStOaUtY?=
 =?utf-8?Q?ygz2tOzDbUdwg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ekwzNDhtZVo0MEdCQXEvRFR4bUkwWHlvOHB3TjEvNkozdnhiUlp2S1lRMmFO?=
 =?utf-8?B?em4vQU1ZcnE1WllRNEhRNXprL29sK3Vjd2pWZkpDMDBvZSszL3BsS21xZXAr?=
 =?utf-8?B?OWJqcTJJWE9oSDAyWS9VOUVHcEJZUm52VEhwc0VmNjFmOFBlWUYyeU11bkJR?=
 =?utf-8?B?QndtRlpBd1JTWGlUc01lZkhKQStMWXBiQWYyYVJsd0tlQVBDajFNOXZVZWlq?=
 =?utf-8?B?dzhFUHNHVG0wYmI1amZNWTF4T1k3SDVBd0E3QU9qMmpCTkQrMGlYTnRvOVNF?=
 =?utf-8?B?YlN3MERDcDdHVWE1L2NiRzY0bnJ1R0x4RW9WMCtLeEZSSitha0Fvb0Z3Tm9Q?=
 =?utf-8?B?WWhwSEhaY3g5Qk5aaGRUWVRHaWJGWmQ4RFo1ZGV4U2RRTnpjRTdvWlhlRERn?=
 =?utf-8?B?TUxtQVZVa2l6RnlnL1NsZlgzdUk1RUVPMXk5Tzh2L3JqU1hSa2ZJaDdmcW1I?=
 =?utf-8?B?SU5KbU9PeWN1T2xrR0pDRjZXS1NBM1d4dzJpOHNOUWNCRHhtUFFsZnNlTyty?=
 =?utf-8?B?MGVHQkY5cTZCUm5JYk82bGd5d2I5K09hMG9tVmR1bmxvejZPNHhBdk1DSUo5?=
 =?utf-8?B?YStMWWZVNDN1dm1YZ2dKY2t3aVdiZzExZSthTlJYcm9nNjk3aTFEKzJkenBp?=
 =?utf-8?B?cE94Qk1sR1paWHhYajB6MGlTN25xZTBLYllCYy9rcnQzNmNKWG50cTE5R29Y?=
 =?utf-8?B?a3MzTTNJc0p4RVRGcjVjR2RxZDVuYjIwYTMwWUx1QVlBWi96eVRFdTlHTWZt?=
 =?utf-8?B?QmdwUmVJaTNpYUNjb3hTV2NMV1VhUlEwMDdHUHZqVUdSMC9jcHUyTWU5K0o5?=
 =?utf-8?B?aXRWRXdmSmZYZHdCQ1BESnZQZENEbGI1TEE3bDEzU0poZ203KzR1WTJqdDlP?=
 =?utf-8?B?blhpNlZKWUQ1SXpveVg2bzlORW5Edkx0d1pyU0ZpRHRwR2JzRUxQeG1jOFRJ?=
 =?utf-8?B?ckJkc3NIL09DOVhaUktNNzhZcnUzTFFoSE9hK3gybkEzampVUk5Mc2JicTNX?=
 =?utf-8?B?TElqMmNpczZBTE82RDZpbmZ3OG44WXEvVzhBN3h4SG5YS2hrU05MYTJleWlQ?=
 =?utf-8?B?RVhvUTkzM0Y3RjJjKzhQckh5aW5TTkFRMUx1NlBvQnNZeVlrMXhwL3ZyL1Zo?=
 =?utf-8?B?NWNZWFhGRnRCaUhDRGlOY1FFenIxVDVqY3FZSHBqem1Hd1RqdENVTERZS1ZK?=
 =?utf-8?B?RFJQUjgyMURIVk5mS1A2aE1paUtSNHZtcjBQU3BLMUpSU3JTdDZoREFxdlE0?=
 =?utf-8?B?cUZQT1FSQzJ1c3pWWmNycmowQmVmZWszQ0RYNU1peFNPbDR1c0lUdnZkVG0x?=
 =?utf-8?B?TzU0dTlnQXg0K09XU0czODdJbU1hZ1orb2ozZHpOT1VnWnVtRmM5cGk1ZWQ4?=
 =?utf-8?B?VnZRUWVhQkFoSEZJdUowWTRadngrOEx5MnRKZk9za0tEZU5FZy90c3lJZHRj?=
 =?utf-8?B?T3U4MkFEb3VuMUUrNmlaTnBnRmc5MVh6TTZNVHRlKytLdDFmdHJTZDJEWklx?=
 =?utf-8?B?ZnZ4V1lHTWlSdU1JaVV6STR2RzIrc0krc3ljMFE3UUUweFd0S0grYURYaExE?=
 =?utf-8?B?dG1vZ2piQUR1NGczOUdrbEJzSUlOSE82QzNwZjNOZ3hYSlBVMnpOL1piYVNo?=
 =?utf-8?B?YUV1ajZzdWtncGJQdUMycFUwRFdWaHZjUGhKREljUTRNSHNvclNrcVpWLzYr?=
 =?utf-8?B?eitrb0JCbjZ0WWxscFBZR3lnS21xU0dpTG02QnMwTnZyeDhBZWhCNXNVRXBY?=
 =?utf-8?B?SHc5WGtaMzVKbXBNWjE1WUdmTERROE8wTGFzank3MzdVVUJ0aUViSVRqVDNL?=
 =?utf-8?B?Szk0TFJpQnRuL2I5bWoreGd5UXhrSHFFNnlmNWwwME52bnRjZjFRbk9PZWFL?=
 =?utf-8?B?VTJLdjNFL3RKSkswbGMzdVVQSUJ1bEV1Z0dHTEpnSHlIVFN1MUZDYW1Ja3Ev?=
 =?utf-8?B?TzIwTTNKTTFtSmxweWpudVp0eEtSbUNPMjlSeXIzVkxkZlNYSHA2NW5XZjFo?=
 =?utf-8?B?ZjZBY1J4VWRLU2p0RkhmdFhHUU5MU29pQndPaVRVakNSSTQyWjRFYU9IU1BB?=
 =?utf-8?B?WHByck5qTEFyWEQvd2FmY0JEZWYwa3FBNVpPUnFHKzZYLzMvU2dVWnZPTy9J?=
 =?utf-8?B?UHNjU2FRVUhldVh6b3ZhUUxoQXphdnVTMjlkQ0s4ZGhNdFRNN0twV0hLaHhw?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rU4K05aRvXuhdQB5sXoDRpUYUfOpGIu9gdS2krHbCKCvNyjwtHQVqeGwz1tnYaWyNzIVOKc6NPPCleXjuWLGYPdSavrJ5t6BuSr0Ha5pB4Ny9VFQC0tTn4F28uR7kHir0eyFaz4fXfSQ5nh3lbtELqlTgoi9oGzPYVM08Mnyw977IOitiT04SpfjEwCasP6bkd/9mfNOyPEzQ/WP4eCYZU5ogzg1LtQ6Te6T0wXEhtNrd3v9flfAOPc+c672pm8yqmkfMgY0peKaTrYWikjyo+mAyajwv0CVq4V7N6cfGhTxu/Feh7ApoOn6SUxgnbsqohRSNbjzAtNtiSBNncIaP11goggI1vqgg9oiBiVWiDa9uGYwvKlUautUdNh39H0i3n1D9PZimKRaElrSd0D7coAA46vGzhIbzyw31zK/HV9UT7/pc7O22Rv7TKa/NfccchVeEAeKtzWl9KgLBVrco7SHpnkUq/uHd50uZCDo8o7IMgrtoHVZXvAPp3IYyJOKHb3pBmK1r5WvNnh70puAB0gC1C3ql+Sbh1L0qYD5Z+HzJcVlNnnJvVeIYTC/Nzs6NYikb+8IhkLckQfGsm1r4HF7ArwjAE6ExjMKhYETCv0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05c2039e-8038-494e-5626-08dd31b92ac4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 20:55:51.4770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkR9cEJONfP0zOCLq3mfggT8J9CfF/ZcjTesz+uVP3ap/4xX879x4u+LIT1sQEDyQxbvrSrm1vigPsE8sDNbZ119U8TSF4KPCNo91vt2TsI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501100161
X-Proofpoint-GUID: 8Rf_vO4SYXmzXQ9t8Qvi4V5KSDLGP0Ms
X-Proofpoint-ORIG-GUID: 8Rf_vO4SYXmzXQ9t8Qvi4V5KSDLGP0Ms

On 1/8/25 22:22, David Hildenbrand wrote:
> On 14.12.24 14:45, “William Roche wrote:
>> From: William Roche <willia.roche@oracle.com>
>>
>> Hello David,
> 
> Hi!
> 
> Let me start reviewing today a bit (it's already late, and I'll continue 
> tomorrow.
> 
>>
>> Here is an new version of our code and an updated description of the
>> patch set:
>>
>>   ---
>> This set of patches fixes several problems with hardware memory errors
>> impacting hugetlbfs memory backed VMs and the generic memory recovery
>> on VM reset.
>> When using hugetlbfs large pages, any large page location being impacted
>> by an HW memory error results in poisoning the entire page, suddenly
>> making a large chunk of the VM memory unusable.
> 
> I assume the problem that will remain is that a running VM will still 
> lose that chunk (yet, we only indicate a single 4k page to the guest via 
> an injected MCE :( ).
> 
> So the biggest point of this patch set is really the recovery on reboot.
> 
> And as I am writing this, I realize that the series subject correctly 
> reflects that :)
> 

Yes, I'm sending a new version v5 taking into account your remarks after 
answering each email you sent on the different patches.


