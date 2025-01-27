Return-Path: <kvm+bounces-36695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F16A1FF98
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 052983A258E
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EB81A83F9;
	Mon, 27 Jan 2025 21:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LgN6uex/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GiS/1Hfh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D58D1991DB
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012924; cv=fail; b=rNuETJFwWLQINwMLUmIrpf5ILfKtRk5PmJNnJLNmyWEow36L0/mTvrYeIHadGY+5JsE2i1TVYJl8YE/cqdioh0gKwg5bTO4tUBrUnbixmU44iBynPNdIE+ie5smz5rjOmauxk1zOEaYNjWwlcqi+1lcLvTzdGTkamyl8cTrD0eY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012924; c=relaxed/simple;
	bh=iS5sEOMfYMWbkh07zhsYRYr2yjgFBw+saymEYc0imEc=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JPTrJMwXw/3xuVKsjU5smwUdUclQuoDuAnvBWYcAwiBaAO9fUPncF3CwaEPYjOW/FU51+GuBGMOxEDDzqkfGCnfLUAghhDJk1scDLor+5yYj95eRuOrjw3pP5y3kqSPE7cG7xRE1ZkgsyKHKA9fvFXd6Mf16WWl3LfyHwn5hRhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LgN6uex/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GiS/1Hfh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKBqt5014001;
	Mon, 27 Jan 2025 21:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DCbCLVA1T+a4QhvN1JGcHChkTt0aBzrBo1qGfH8ZLkY=; b=
	LgN6uex/b/vqQGkVSfAXSW6agpHJltgBidwI27i7brywmuPpevMRdzhVeOhte77A
	DlUCFObyMyGFAfNPIiYuE6H/TAmwV6CjM8xHbQfUGhOmunzHmY8qCgcEDfkZiHwb
	KPq7XRCEl3ZQwZhwmJiVuR8WoZandgWt++OfX6fzA8Xur7c3NC9SDexkTpFBkcip
	x4gLu3+ykqG9FD/SI37g1DMXOnPWM93C6rHuFXCIk2Fsb40UzTkpzK/uefSHSZ3O
	Smh+QFyk7HshcZhFnkRcb6aEc+Fsurc1RhYF/D9STIxr4xQ8Euk5x1esFaPD9XZi
	Wmjjaviy+KbmIAykoA5tGQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44egw384cg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RLF9a3036012;
	Mon, 27 Jan 2025 21:16:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpddhhjb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kzpuREOIyIY4A47DQSiewBRHMlbnbxCoBqRIl2DlVuqEA4e9n5DEYJY6zH0woz15ua0e60cIDUm8OL9hBzlktcb0yEJ5vdjk1U1EOIEiQ/BcJtDvBAkHJo72Vj7XELB+7aDygtJkPJci4Pz8IP9eFFUf4w9j0AK2ZmoAnTbSqDojjtMsvM2E/eRU+hrX4RjvDwdKqN4OA1HgQuWaSU/mY89V5eX5FymbHWEAPcQQc334YxEpwbeJSAqGOMMgj2KQbgNbpXH+tD51t5Uf8Z93JWKsjhOWwXJuRHp5/TeE+eehc4BIJFGmBDFBDo9Yqii0MlVe1fvXkIo0Lld/wE2cvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCbCLVA1T+a4QhvN1JGcHChkTt0aBzrBo1qGfH8ZLkY=;
 b=KnzJcBMTcYrVV4kr9U408ZDZR8sf0ggYiePkbSbWtKIpYLUYc5FoOQUw8zgADyoFLrJi/xZmYcbPzkUo128sRudCmjInyvrxeal8vkAzJk6FpRPiugDtHxtQCs/J9ShGUi/Zy+kgnKfLLCLLH1K9NL/t+w+iobEwn2ndl1n0ESBFtrD5oMjLaBpPYxLwCPAG+Q7QCmQUnTwzs2tUWCrUoIVp9mLgFY68pRDxEcL+WbucnFXzzs1u7elsw2Fv26U2Rpw+tHjBEJoMi5Db7qojt8Zx4re20WNMi7rRjR6PGaUrJsXrugFdlapIJR0zPz21FMsG59fYisHXwadUEwRbxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCbCLVA1T+a4QhvN1JGcHChkTt0aBzrBo1qGfH8ZLkY=;
 b=GiS/1Hfh6ui3/MMhEDxnlOMhoAg9D6pzcyEIzmpZydgOV92lOc51/PmmDRM6235tC6ahYuSAlrYvL/LlLQqiPPchthM+y6PK2tOSgRq4YCBC2vQluw+H1S8S/IPeZBCn9Nh+cXrYdsSfJAh9hxct6LYhWCX5QzdrWbSxoqBs0gs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7938.namprd10.prod.outlook.com (2603:10b6:408:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 21:16:40 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:16:40 +0000
Message-ID: <1d331d4a-19b9-43b7-b2fd-5fc35bad70f4@oracle.com>
Date: Mon, 27 Jan 2025 22:16:36 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v5 6/6] hostmem: Handle remapping of RAM
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-7-william.roche@oracle.com>
 <295cb360-b618-4a89-86e2-1630b872fa7f@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <295cb360-b618-4a89-86e2-1630b872fa7f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0047.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::35) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 035fee82-defd-426b-67d1-08dd3f17e3f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bEhSbGl1YVNBc1VKUzQ3K3V3OUowWit6LzgyY0wxbkt5eHVSckJMWmNrTTVN?=
 =?utf-8?B?VWhBcnNzUjc3bTl6K1RVV0NMSGc4VlJEcVN2QVBOQzl5RlhreUZDSW9pV0dJ?=
 =?utf-8?B?c0RTTGFKV2RvS2toRFp3R0V4cXBkRURIdVhRRytFdjA1ZTJtTUxNUEZBRFNN?=
 =?utf-8?B?MlpYRk1DdWprRGE4QTgrQzRDbkVVa2hhN0xsM2R1UWNsa0ttMmp0S1U4VTc2?=
 =?utf-8?B?QUF3ZDlScTNjOGt3WTFEeS9VViswWmFOQUVWUlVUQThXamlqaTAraWdNUlZB?=
 =?utf-8?B?TVhLVVRvaktOUGhJc2ZibkdSYkk0ZlJZa3hpVldjWjJWSVpEdnJNNWVBQjMw?=
 =?utf-8?B?MmswaEFYTGkwT0FXQmQxK2VFWGpMaVFLN0lzZFZjOXBSektvV3M2dmR1MzAz?=
 =?utf-8?B?Y0dsUUk1YVZhbFY2ZjU5SklrYnN3Z1MzRWovaXFHU01xYjhReTZMSFNkSjhm?=
 =?utf-8?B?S1J1Wnc3cEpvbElhZGR1VXFOUVdMY0tjQjF0VGx3aUNDUG5jMlVHVjVzR0Vn?=
 =?utf-8?B?Rk9BRlhYTTFqODlIbzJncXBKR0JPcEJRVExsaTFYWWFnM01McFphcUU0bUVn?=
 =?utf-8?B?NmVna0gxZ3FCMUFNOEM5SlhYSWVpZUk3QmU2SU4zRTU0blBnYmtGejc4WUI0?=
 =?utf-8?B?MThGR3BiSGV3ZlI1QTB3ZXZhNWpHYnZ1SGJLdXdHcktkNDB4R29PbkJxUE9G?=
 =?utf-8?B?SlBlaDBiajdqaTZsanBZY0U1NUgrczZZZVVmaXl3dmtCVzNmbFc3NEFYNGtl?=
 =?utf-8?B?QWZueWpEWTUzK05UeUZIbXFzL1pYN2J3SEhEaWY4ZUhsOVRzY3dUM1FWWElt?=
 =?utf-8?B?ZW9VNlRFTzZmWlFvbks3QXZtMGdZQmt6NG5vZnl4bE1zT1pMTGErU2N3citE?=
 =?utf-8?B?dkNVQzJOdVByOVFQVXVjM1BRdHRnTG1vRHlWaXJURm9oaWk2d0NpcnUxaEkx?=
 =?utf-8?B?WEhWTkJOWDM4MktvbkQ4clptY3ZGTjF1R3h2OEVwRVpyZml5SmZHV2poM3dx?=
 =?utf-8?B?NXdRZzVMdzgxUHhhQWcxQUQ3d1VrMGF2TFM4a0oxZCsxTXBmWjlubUEzN1pQ?=
 =?utf-8?B?SnVSTUg3WkY1R0tDZ1JpQ1BveXgyKzBuNE9RMStoeHFuVzJxandJdExYVjlD?=
 =?utf-8?B?ZnZvNTRONDI0NTZaeDFIekFqQk1vRUJ5VFlFV2VOWGVYUzI1TVZGdEtHUXRo?=
 =?utf-8?B?VEtCaitXN0dvRmloVmZyMXpMdEZ3MXN6Ky9XOHdPNHF2TG95K0VhNHZrTlFr?=
 =?utf-8?B?QzhoSkU5NmFFNTRvdFBDcnJ0ZmdGN3RCYThGeWZtNUdvZ3RzRGMzVlRSWHNm?=
 =?utf-8?B?NjROMm5KRGJLWWZ2MU5MTGd5THFWcXphRTh5MWhNSGVlaE40QlJkcDYzVlFs?=
 =?utf-8?B?MDIxdXcreGM4ZWdoSU5wVVR5RnU0bnRySVFVQ0pNOTFIWlpVM3cyRGNoK0tZ?=
 =?utf-8?B?QTlOUWZIb0ZYRnBacGUxM2tuVkxNcENvWCtLczVWRjZTQm5TaWJFM3ZoM3Qr?=
 =?utf-8?B?TmNnK2hVeDhiVHFudkUwOEg2dGgzQktOVnRISEdYMzZoKzlqRUdOcmltMld4?=
 =?utf-8?B?MmxhNms2YUQ4QllmZE1VV092MkpETk9Sd0ZNOGR4b3ZDUWRRWW5uWkpxcU0z?=
 =?utf-8?B?Z2pIcGVyMTdoTWx2Yjl6WlkyTlIyRStzMkl6ZnQxRU54cGV6WW1XL3YvUExO?=
 =?utf-8?B?ano2QzF0UHNweUEzMVVxU3EwNnJ0THgrQU16M0FpS0JtUDRqVHl3T3BuVUlW?=
 =?utf-8?B?dm80N3cvOU9Cajk1Qy9yeDV5Y2NwRW9OVXlyY25iZkQxMnVaNVoxVUlicTlQ?=
 =?utf-8?B?NWVXeXliUG5UeUlvbDFFRmR1S0VPd2V1YUxIcjJDV1RDOWtqZmZnc0pJZE9I?=
 =?utf-8?Q?vW6Vnmfgjs1mg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QmlLRDR2NEVqRGZJcGVYRnBNSkhzTG95aTNTTnFmc1VpcWNtRW5pbWhONmta?=
 =?utf-8?B?NVIxdUE1dyt1VXVzUmY5MDdieWxtLzg1T2t0RzdUWmpnT3ZwOVNRQ1RraHNy?=
 =?utf-8?B?Ym5weUpIVE5NdGxBaU9EdHFYeFRRZ0x1eENuQ2gxcXI5WjA4RTJBdk4xOXdz?=
 =?utf-8?B?SmhaeUd3TUM2dWtpVG91dXJrMHE5L3JnZnFCU2hld1VOYzgwaWcxZkdMc1du?=
 =?utf-8?B?OWZiSXdEUGxJZC9odDR3NTdDTC9TQ2s3WlhuVno2YU1QTWZQWENsclF4NU02?=
 =?utf-8?B?OEhDRkt3OU1TbEk3ZXVmanZTYjNEOWlmczNOcGM5UnM5bTBobDcrYjFrNUor?=
 =?utf-8?B?ejhudWVHamNETllhWFJnb25sTy92TDY5cndUeUNucGovMlJhYlUxc0J6OFpC?=
 =?utf-8?B?UkRhZ21IOVhYbTcyZnc2eURISzAwY0x4b1JTU1U3bjhuZDRYQkRaTUs2aURu?=
 =?utf-8?B?RlVYRUIxd0pRUzVNUlM1MHU0aFYwK212N2hoa3VJenpzNjdNajYxMDNyb0o1?=
 =?utf-8?B?RTkrYzJrU1ZORUwycjFCRTl1OUpMam5UTmM0ZTdVaDhsTnU1OFQ1ZXpsSlJP?=
 =?utf-8?B?M0dCeVZoTWhBQVZ1Y202dUVUMnNkaExDL05vL1VsUzlzanA1cUxlbC9Pa0cr?=
 =?utf-8?B?T2ErZWMwRUhjb2RYUi9aK3ZnUko4L0MwaVdyWEYzQXYwNG1NSDJTYXRFZ216?=
 =?utf-8?B?QnlISmFwM3lncXNWTllFcmI3VjdnNHJxRkVITGwvcVNFQUlXL3hRWndXbTE3?=
 =?utf-8?B?QjUrbUVpZEZhK25TUWl1bUF1TlRUaW8zQ3RXMUVnR2Z3eEpCZWpidVVFOWNL?=
 =?utf-8?B?dnMwRDVpczFYNWo2c2QxMUpxWTlwZ0x4K09YVkp0UDJ4MHhYbkFFcWF2T3cy?=
 =?utf-8?B?SEdGdlhSbHE1b3dvajc0Tzh6dUhrVzJ5NGY4dzR3Q3NsYm5KSWpMY2NBK0xr?=
 =?utf-8?B?a3A5STdnZjFBWG1nbm0xWm1YcEU0Tk1mTnovR1krd0lTYmRPTVVuMVBZRnRW?=
 =?utf-8?B?dHBXLzdMUGRBTWtTVkp0Vi9paUR5b0NhbzVMa051WGUvblI1NjI0UytBWmVh?=
 =?utf-8?B?MlQ3QmNiMkZ4bHdpdGZibGpTSVo0SG1lUk9GOTgxekUvWUZUeWFpbmUwQXFu?=
 =?utf-8?B?QkZlV3pCS3VqZU8xcGliV0g0TzI5STFMaEZiQ20vSC9PMmtwNlZtQjVIL05I?=
 =?utf-8?B?Yk5IOHpHazBaR3ZaU1V6ZFNMR3A3cGtkNFpEM3gyYk5xcjZKTGJ2K3RvblRD?=
 =?utf-8?B?S1FIb2h5N2VEY011d1k0YjAxOVlWU0l3eWpHbHRDeHNoYlo5NUFOWFlxbWxt?=
 =?utf-8?B?dFpEelMwOG44K3dwRjBUaXRFU0tFMkJXc3NnL0RGdFNFNFdBWWNseHBIM1Ju?=
 =?utf-8?B?Rk10NFU2TWR1d2lyZ2xnbkFmYTk3S0wvVTZuM0kyQnFqeEhJamdSWnJkUzFR?=
 =?utf-8?B?VDJwNDkwV2QxSnZBSjF4UEdtcjU1OHZ3ZXVxcVlIVm05S1hEZ2l2YnN4WDFD?=
 =?utf-8?B?VGJ0VVBDQlpsczBKZXJNcW1jQ0JJWVR1T25hZWdtZ3J1T2RIcWpUc0tGeld2?=
 =?utf-8?B?TFNTc2t1cHNqbVV6MTM3NzVZNXdtemFIK3UyTGdpL3VmTDFaUldxbUFLWGU5?=
 =?utf-8?B?SHRCaU9OWFBiRjh6V2xsbDhGTXJFYW83TGMrdVZHYXVLcmNFNUcyMU9jWm1r?=
 =?utf-8?B?eDVpbnBZTHlJNndSbE1NS1RIQTA0eEN0WFZZd0dHVkhDRjNzYjB0cVJYVnJB?=
 =?utf-8?B?dGRzSklFQ2RoS2drMUZNcmQydDhmb05vYlVzWTVYZlJ3MDJMcGlYaGhVWFl6?=
 =?utf-8?B?cG9tcTN0dDJnTVNZeCtQRFkzL1ZPYzZFOG9XaHFiSW1uOXhZb3hrN0YzYk5n?=
 =?utf-8?B?aFJUQlZxazl1anBjbE9scjdjdkdLemNtY2x4cnBsbWJJeTBkVUtOZnJqTE5V?=
 =?utf-8?B?c3FXQnNQK2YzRXFoN2xoQmFmcUo2MFljNitPbGY3YTkrbkZrWU9iUjZBS3FO?=
 =?utf-8?B?YWZLRDJiVUE1Vk5QZEkrSnlhRkdTYmhlSFlEWXMzL1pkTXN3Wko1TGRyd3Fy?=
 =?utf-8?B?ejRmc1d6cTlaMjcwdXk2aWtFWkNVY3JjblZWZ2I2Vi9OMjdUM1hNY3VBbmRJ?=
 =?utf-8?B?Um9FL3lqZ2RhUkpsTTJrOU9HSFNQQmNLb3UyeVdwa2Z0ZlJkYTNkekhid2gw?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iZxfzPBN+yv7H85ucqpQG1OhyotBzJXCkIJQsL6ctTR6FjEsFXizf832xs8Yt6lOlPmyl+HoPzLMK6b4GeYe5ca98HrlNR5RXyyT5BUJ+0Z4EDuyI6tbbjN637grl1HlhUBr8VhdqcdLVwBzoRyhVPZJ3FjqTeAFnV1E0zAnWNPuGsIbtWW0m+3sPRI7TsVp57eVRQEAqNWwWVZBIPGAx8CpLZQzJ2kbij+r/ad1Gb9vGIE/xc7d67MAwUvopfQtw7LIWV0MyMwL8b+cK7vO0vqSp7YuSedlWDA/KaRfulHtPXZ/N2F3x/OfKHov9fgGEDY1ngw/Ffh4JU5bK0pd0tDGIHwv4+cudkAox7c4n3YhGfr1ZbztSz5vElpOMPZYjZpkSJNbxvKetIX+3UulWT9IeCa/ts3L3cmwk27lL+816Pd2ebpvrE10Znfx74rFu7iwLgj39bej/q8oyzJsQXAjnSWmJSehg7IniMzpI9I4vEQebQOXLh4m1uP0p5yrT6GTECThLa4nJzLNxOgEdR+eQoGSXBv7cdOmhAPVb4KXVTci921/h8msiucFGkQ2kncs/mV7jmG6xi7ZzR4Aw/ZKbLQzc0Gx706vUIM36rc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 035fee82-defd-426b-67d1-08dd3f17e3f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:16:40.1720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AgEMJ37VWdj2QKq99nQuiEzOjLVd0fzuxmUtJfPpwMa+3oJiikXa1dFqa95m3lIahKSKIIYPZSxlQN7HCl0nVZrJ5txNzzr+fPTB0KK9ykk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=873
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270167
X-Proofpoint-ORIG-GUID: kKeXGOrkv9S468AbyhnS3crnxLif7hFL
X-Proofpoint-GUID: kKeXGOrkv9S468AbyhnS3crnxLif7hFL



On 1/14/25 15:11, David Hildenbrand wrote:
> On 10.01.25 22:14, “William Roche wrote:
>> From: David Hildenbrand <david@redhat.com>
>>
> 
> You can make yourself the author and just make me a Co-developed-by here.
> 
> LGTM!
> 

Ok done.

Thanks.

