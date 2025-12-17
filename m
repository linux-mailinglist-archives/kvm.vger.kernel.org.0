Return-Path: <kvm+bounces-66167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B55CCC77EB
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 13:08:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7821E3053B3B
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D85733E34C;
	Wed, 17 Dec 2025 12:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="B31ddzXn";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="UDMJbxGr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097BC33CE92;
	Wed, 17 Dec 2025 12:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973266; cv=fail; b=Rq8/kGm1dRiiRdMLyEHgyeMXAgqbvjU7TBfbKijWVnC8UIQUPMK5dtIWMEALf1aCCLXnG0scgrJ+mpZD35hhhmreC2Gs1A/8U6muCtBzzYZ2NJ9QkWTv7gc2dOfmiDbeaTgrGPHfTrjPZ8bbrUNzp43eLgYjl0TrnNR4+mzb7cI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973266; c=relaxed/simple;
	bh=/WF6myMOJ4MVdebTMnYsaneVzT9PReXtClmTIfXIx+k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WNpLtPoElfv550FVWKg941GrR4/9hU3Fq+qHxFXAVD4M2y/mg4lebi5uxpg8u8arAOhNkwVPUpJ+jiHQqGz9t48I5DjHHaYxfrNxXwq4Ac/u2GmbthGC2LRh9H9FPwtwOl3Sfh0L0Tpt4RmAl8w+AoFWTZO5YYrRmNWcAoSgcIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=B31ddzXn; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=UDMJbxGr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BH8V5XG3554790;
	Wed, 17 Dec 2025 04:06:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=/WF6myMOJ4MVdebTMnYsaneVzT9PReXtClmTIfXIx
	+k=; b=B31ddzXnbzj2rJGb//n99tNNmDL471lA+rcj5GnRi/VQ8x5PiiYPUIRxu
	xcVbeu5OOdur75EFy8CoA29e89dUSk7Hc7Jv8k0ZcT5nGnsQq7edSy5oB546Wsrf
	9UT47BKSX/UenB3OcfPDwfTukY32w4+PbTuXFx+2vOTt90VjuJFU22O0DCqO8cLn
	fgyyInuHwZN20lBS51g5pGgXx/9bPB/w1DpHuaEWxg07q49xwf8bmO7gSaoq59pi
	uq7Rpt1/wf6M/BwMo528mQbPyVUuwayHhZN/8x0Kke9DSXW76inGajTLybWqHCMI
	D7Y16TSsSF7Q6dBuLrdjc3Z3VJ5tA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022107.outbound.protection.outlook.com [52.101.48.107])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b3s310f47-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Dec 2025 04:06:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5Wjjvf0wh6VebY/KHC/HTkAv6YcDAYW77sr/2XbyP/craV5f02W2TmlNUzGyH39x4IU2RvRB65Rj5jInXCuke2T8HKmp+Y6Y/K7wYdsxEEYgdsFYZRUoyqivUaDkBY3C+YWXICb+8exO7LmWwdeOionZDKPgmZ1cTfqpq/tCTrLFULlLpK/rXIwRmCTyIpm1QspPTVw9JaFdhlKMMiDHdqViObz43+xPxE1hTLx0zyog4huxMnEASOSCJqQxZKwyDpmEWm4TmIjtVSzz0L+4vV02SYGr7j56cDVdJOpbBky2NyZ8ftJP/7VzrK4jrT1GITJjPmUOr1ud5lUhZDEqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WF6myMOJ4MVdebTMnYsaneVzT9PReXtClmTIfXIx+k=;
 b=HRqSs1NZnLyZlBXvyYWltjYz6+HkB6wut/VhmNrSlm2rf5eXNYJJ7ged4I7wuM/10V3bSo/pYwGXleB5822aY3+HXuLLcZKVc8ISyPG+qmMUrY/NgaUk4CDGN0MnclDOiOzNNluXu8mtd26J5AsRdAgoNiLhHx9lodgadHyRILg5nrZrJEjiW5EwkDfXxoCmCgDhfxMFN1kOftj1aYFOQzshFCWiGsJma4M2o7H+ivbHDIFjC8RCcTMmhw/oVpPSClI6rD3KnpwBKNrIAWD9/9KS9vqGNT4v3ef4+Sl5UJgq22yYhqeWJtcwPHvPfJZlL+8yvK18gJRmT08Th+NAzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WF6myMOJ4MVdebTMnYsaneVzT9PReXtClmTIfXIx+k=;
 b=UDMJbxGrKBYtvGtQAlkTZpq2fbL3ktbouckrrrhdqLNZrHfvqab7IxrKKCvRJJw/2dU41TRQqJY0S+cpHGDVamGF0XmOybld4jAztkwkb1equr9Fz53179EEG0zSJFDQ5eNL4swhQJAi7k7dAF/yqfQXN52oWnAkU3VJCMkocwGhBUoECFAWdX3/IKTWGDxfqjnrvwAspGZCnJkkrzzaJZ8X94ay/N8j90qowh5/Zqm64NAjpEKn77v3323W3/CT89G8i5ZSrDRLaK3Bv9FF3TrVDp8JplfN6S6pl06Gtm63PzPCj70K5aylJR0rKRQFakO0UPa47ZKVcoZ7sRDbLQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DM4PR02MB9166.namprd02.prod.outlook.com (2603:10b6:8:10d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 12:06:44 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 12:06:44 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>,
        David Woodhouse
	<dwmw2@infradead.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kai.huang@intel.com"
	<kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcao1m0m+Je6bySUSdnhU8EZf0EbUdH8CAgAB3S4CACC8FgA==
Date: Wed, 17 Dec 2025 12:06:43 +0000
Message-ID: <9B3CAB86-B3E6-475E-8849-85CE63BD7E36@nutanix.com>
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
 <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
 <B45DB519-3B04-46F7-894E-42A44DF2FC8E@nutanix.com>
In-Reply-To: <B45DB519-3B04-46F7-894E-42A44DF2FC8E@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DM4PR02MB9166:EE_
x-ms-office365-filtering-correlation-id: 4016ceeb-660f-493b-3dba-08de3d64bec7
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?THBHT05yV3pDNGFIeUhkWjFoUzlodFNGbnl1OTVLWjAzdit0S080djJ5V2E0?=
 =?utf-8?B?VWkzUTNaZnpIN0NvQ1JqMW1vSHo5NEw3YldzWmtzcWRmV2Y3RDhIdlJpdDcv?=
 =?utf-8?B?RFArMzdtZVE3czZmOTJzOER2QkErUnpwbGxNTE9TMWhrMFdBM0c1c1pBUnZw?=
 =?utf-8?B?bk1mNzhPeTdrc1ByWGRnajQ1ek12V2JQT0o5OVB0Sm13d0tBc0JMMUd0bGZy?=
 =?utf-8?B?cVAvUmxmMjNXMk5aSFllNFdzZWhLRHd0T29VelpMeXZNc0VReXp0U2pYZnpw?=
 =?utf-8?B?aFp0RTA1cnpOcStsWFlZQVEvSFhPQ2tnSS9tM2lKYnZXYS9zejZlWHM4NEZG?=
 =?utf-8?B?VmlMeGM3ME9KdXZDNnAvU2ZNaVgwdkhIRW1uRGU4NEp0eXRjYVA4MnNJV2dV?=
 =?utf-8?B?T0QvNzRnUmN5bjZaNnFHb0dRUUgrRC9CTGl3STA5Qkl2aDIxUitudHBoZVAv?=
 =?utf-8?B?VE0xNU92Yi8yelFmRFpWL1dpc3VFZTB3SkZ1bVA5WVV5Q1A3d1NUQVZBWFVo?=
 =?utf-8?B?ZGl4a2lMMWZ4eWpSOVhqZHMvdXZ4TGtKUzJXbi9OU3hxcEwxZHlwNWJrT1F1?=
 =?utf-8?B?T3FMWUdpZk1IbUhTdWhuZkYvdjcyNEc1RnN5ckZOZFNVMWdDRWJrZFBleHFL?=
 =?utf-8?B?bWNkK2lnbGpST0lSeEtrMGJvV2t2MzdVV1IzQm9NMDVGTlpkQUhGaWVyVllt?=
 =?utf-8?B?bmdTcjVPRk9IakVRWHFFMVQvQmQ4andzTTBoS09NTllvVXNOa1VFZHJIWnRO?=
 =?utf-8?B?QXlkVHpONlU1WmoxWG4waWpWUFlvdHlkczU4S01nb2xwS3VudytMcUVtQ25x?=
 =?utf-8?B?bTI5WTNaRXZCUFRXWjYyV08zQmRabktpREQ2Umg3bmZtU21ka1oyTC9IaGVm?=
 =?utf-8?B?R3RrNlJNUW90c3lLazFlTlN4Q0t4YWFOSEJ1bjEvSlRoSlB0WHhpa3hCa0Rq?=
 =?utf-8?B?MU1OSkJzaVZMOUYyQ3JQR3F5dkxkUEVXSU9nbmpLOHlrMm5UYjZpRkg4czBR?=
 =?utf-8?B?UzJDWVJjQUsyenhPMXZzQ1gwdUdIQzhwWWJnVkRZZ29URlYwcnBKNGFLNlpo?=
 =?utf-8?B?cXlPK0o1ZFJOUVRFdk9BV2t3czZXT1ZjcGY5cjAvTmlzSkloeTV4ZFBBV09K?=
 =?utf-8?B?V3BHaDZSS096SUVnTyt6ZkxOV0Rsb3lvT3lUNk9ZNGVwTURFS3J6c2RRRHdI?=
 =?utf-8?B?MUFIR052dDI4U0pkTVM0aHFHNytGdWNmamRUVnlGL0JLMTdWYThqcURUdjRa?=
 =?utf-8?B?cS82QndMb3NLR1FvekNpS1lZZVgwNGRULzRFRzlVQ0xEWTQ1ZjVzYitiQjVH?=
 =?utf-8?B?c2lGUmQrbkZXT1A4eFJIRllIakFIek5scUhOVUh3MmtFNCtjQ0wxcnhHbUNa?=
 =?utf-8?B?ZEM5TUJaTjU2Qm9HTHJmUG1TY0ZkaXB5VWRKRGNhK0p4UmJUTllta3orS2pH?=
 =?utf-8?B?cEl3NzhtUTBkQjRoK1R4QlhiSkc0VlVBakFQZVJvamp3UWUvRHB2bmJ0a3NI?=
 =?utf-8?B?Q2xyeTFjYmpBdUxkcHJEeXIrZlB5cVhhSVBaK1lEMmVXK1lqUnhjSXFJNkkv?=
 =?utf-8?B?RWdDc1BBbC9RNG8yWUp1aFNJYzVBYkRmS3kvd3pXK0xxbDc0ZXJXMEdwYW9a?=
 =?utf-8?B?NENDMHp2Y2NkZWw2K2l6Vkh3VmlnVEVTbDBhK2FTVVpuTVJKSVRQWitnbXFU?=
 =?utf-8?B?T2d1aHZpTTdianVLOFhuc2N3SVFSSW9MVDk5cUZmNC9Db0kyVG94cXVsSnZJ?=
 =?utf-8?B?RDhYNkJUbHBGZmxqUHM5WDcrZGN0ZFpyRzRBSVR0WUxqOEN0d3RjdHhZVGMv?=
 =?utf-8?B?NTQ1aUIvcmlNUGE2bUdWOGk0Zm11amNYMkRyVXcrWHFCR3dJVlVEWm5MV1Ri?=
 =?utf-8?B?YlQrTXVOMk9OQmZIUzFPMlk3d0RtTFZ6SndheEVtSW5sR3hMQkRsL1cvY3pW?=
 =?utf-8?B?VUZ4dVhQR1dxZzJDTUswQzk3elZTYmc0RjBNVXhvQ3dwQ1NweENLSWFOU0Jl?=
 =?utf-8?B?T1ZvOGN4emRnNGtzR3FlZ1kzcHRVVUF2NkdjY0RhZTdacSsydkp1bGlUSktK?=
 =?utf-8?Q?XR/Qka?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dklRL0JQRVdYTDVCcjhudTgweXE1V1J5Tjc3cWtieXovQTNoSzFtM3hJOTRh?=
 =?utf-8?B?V2xVcStCNENTc29RKzdCQXFVQVV0MjZLNm9DVUljblBTNzlPK1pvcWxlNnFG?=
 =?utf-8?B?bWlhY1BlTU1kWmhNVVFDVFJQWlhzbTIrYytCNGp4TEZKb1cvREo2STBZSDRq?=
 =?utf-8?B?bCt6a3BOUlJ5ejlueEczVVpwS1NPblJ2aVN5SElUdmt4VjNzVWxJYmJjSFFr?=
 =?utf-8?B?bUMxaWYwdHRJcWNRTHEzOGxhV25mZjRweDNsV0pyRVMxTGl1RXJJc1BwOFU5?=
 =?utf-8?B?QU5idnVpMEZoZDVLVWY2OGQyb05FS1lNUkwzMmlZcWRzcDZQTE1oaStWWXYy?=
 =?utf-8?B?ZmVzbURtWGNXMDNjZ2xNZEdLSFdXK1A1VVFPSVVvVXZlVnpSYzllQ2tsb2Fa?=
 =?utf-8?B?Uk9CTHEvcGNnRzNqdC8rdWJ6MWdGa2JpcDhNY0xsUklPWmMvOUJieWpDVjUv?=
 =?utf-8?B?TVJjSTl2d1B0S2NyajFKbWEvQSs2Z0pIZlNYb0pJMjBER2YxS0I3RHFxSnhH?=
 =?utf-8?B?OU5BOGJzb0lxcm9RWWMxV0xjTEFIUHZXNjlOellNa1kxTWY5T3ZOOUtpWjNX?=
 =?utf-8?B?U2FwSUNqbkhtVnJuMEw5NXlYNmpJaWVHSW9UbGtXYlZoT1FtUDMyK1RPTDZy?=
 =?utf-8?B?VmVabngyd0hnWDdsKzN5d1FiNmMzRzc3a0k0ZlFZOS9FSU9MeDVKRTZWakh4?=
 =?utf-8?B?RUViZ290c1VyTzJVWTFTWlpxSng5eWNnQjdUbkVGa0wxaU9aWDNEYmp3TUtH?=
 =?utf-8?B?Y0FxdjdZa0cyLzRKR3VkV09EVnVBbTVzemxZWDlzYTRIa3Uyb2wxaDI4MUlO?=
 =?utf-8?B?bHFiUFAvb09CVFlQRXlaMk96Uno4eTZRZWF6ZCtxOG9yakh1Y0ZvREFWT2kv?=
 =?utf-8?B?OTJNUFVoWGVkQm91YnJKcDZTcTY5V3ozd0pJUXJhN3l2clhBcHM3WTFWNE1s?=
 =?utf-8?B?Sm9LQ09seXRRQkNNQjVnS2UvYThNcEZ6ZmxwTlRqc21LOE84dDN2YlArdTRq?=
 =?utf-8?B?eWZwTGFwWGV6K3pCQjlqTDdJRm5sUDRqYm1KZzV2MU5qVmE0TFZWckJXNWNy?=
 =?utf-8?B?dUUwLzFSRzVnRkoydmZkVGJiL2pWNXVxSWVRelU0eCtVSkZxT2UwUkg5T3pS?=
 =?utf-8?B?Z2loQ2thd1Y4K0J4a0dyL3VMYThFYjF2MXVhK0VaUjJER25EWm5TZGRXYmVu?=
 =?utf-8?B?bFRnUDY5cWI5bXRZNDU1WTRHR2tHT3hPNEJHSXdUNkhoTXVPdDBkZE5SYWZH?=
 =?utf-8?B?dWhjSU5IRnl3VHNTMWVvNDdHQmcrd3kvQ0pzcE5oVzZYSDQvbTl1RFZUbkg4?=
 =?utf-8?B?akhMSkp0dUV2V1N3NHZ2YlVXYk1GMTg5RUt6eUtjeS9LdDJyR2tWdVhpeGt3?=
 =?utf-8?B?N3FncFhvbitNMkpHUFlSWnh0c1c4OU96d2pHTWhUQ2dNU09la0IwcU1FWTVl?=
 =?utf-8?B?TXppbUFQZ0QxYVIwUFpzc0N0NkcyTjczT29BcllMTy95WWlEYmlCNlBxYlpH?=
 =?utf-8?B?dm5CN21RZUtEWFVhL25MMnU4ZXRVdFFOMW40aG9BcEYwUlZzRkxYZFkzVjk4?=
 =?utf-8?B?dytBaUExMUlBOTR1TEtpQ0lHUFhEV1lEUy9mVVpwVHc3NzZNTXFkQ2JWVDgx?=
 =?utf-8?B?SkhkMkNsRkJjQmxaOUFZaU81eFkzTzZ0Y0RFaVdQanZMT2wvL01sM2xVelhM?=
 =?utf-8?B?dzRXNEYwaUovVWJHczBtYVFrbWFzemFtMC9PejJkSGNyaEFMK0hwTm1VYnUy?=
 =?utf-8?B?K2NIUFpVSjROY0tIcHNCN2hUVTRqSjJvWU9vNUI4cFd5UmNPdTJkQjBzdGJL?=
 =?utf-8?B?RDVGbUlXZ2JHZTJEd2hYM3Zqd2J1WVpXdGxURDJFR3VjRkFDcWdyUFF3ZEhy?=
 =?utf-8?B?OGVjT3g1MHFQTExtUHp5NEZrSEg2SG0vR0h2MUJFTmhRUDNGRWJjUDdybVJB?=
 =?utf-8?B?RGFMK2Q2R0lNVnNhelQ4ZzhZS09pMG5yS2x6QTgvbWNyWUdRRUlPa3lNeGtR?=
 =?utf-8?B?RkdTcmJtY3VLUzRTWmlpMUl6NGtlTU5lSXE0bVZTQzM4UWwrM2VvcHBUS0lX?=
 =?utf-8?B?MmZPQkorS21hVzJ6RU9Ma0VhYkZtNkVUcWRVUTJTZUMxOU8zZ2xkNmlJN0pP?=
 =?utf-8?B?cDhkeVpCZmVhVHFwVTdFWm1Tbkt6dTJpWE1sVHAvaUpHdHM3NDRNMTQwampo?=
 =?utf-8?B?T0dmazg3RXAwRm1tQ0VlSjZLcm9Vc0gwQzEwOEc0dXdPcHJJUldXcENxakRs?=
 =?utf-8?B?UEhwZ1l6L1ZFTWNmbE1tc2pxQ09RPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33BD53A62B3E484CBBC6CF02510B6460@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4016ceeb-660f-493b-3dba-08de3d64bec7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 12:06:43.9466
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PEFPbpOYEwTtkzC9HmEzO+5Mn4CGQILNA/bvd0ixn7a51BcBX2dgGmzwWPruHFTxgSEwnqiyDcp0wU30IV6uW8ZRJPuA5A6d+a0+ZsGlT4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR02MB9166
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NCBTYWx0ZWRfX+Ru4W17JPkVO
 MOU01NoPUivws937uszE0BhMhXSOn+Yv8887jolI4z0HMtVGV4lJLmY6AxZHkotVd7v4RFTIOZh
 Q5Yl9ippZzqOVerAl70PmYkuij4cAPYTwtpIB7+XoYt/QOyFAS01dN9EEjNXGTOX1IEcs2Bdam7
 vMJ/E4Zd5/moZLcCuBxNdKwxFQVEMA1dgQ1QlDCGHw0q+89OIZL9vbBTT3QlssLjaudA3iVVqcb
 PJW8sPD7eNRm9M2er54UO4Wpp2IKUAUPh2j59myisercaLXlYyiQlQRhHbGjgus/GyKI094xVii
 WFa0nBV0Oe0+b+8AFcwsx0Y0RAx++rnhtlg9BTE98+KI4036jclrug3hD0n2v23b/eLHn6Y1L4Y
 B40FKE06mEkNIvZKYIvR6FWm/cq1+w==
X-Proofpoint-ORIG-GUID: D3SKpiZ4KYrdJeTMW0JJiv_ZgSY4BXFc
X-Proofpoint-GUID: D3SKpiZ4KYrdJeTMW0JJiv_ZgSY4BXFc
X-Authority-Analysis: v=2.4 cv=GrtPO01C c=1 sm=1 tr=0 ts=69429cd8 cx=c_pps
 a=ZfDhP9WrRDodUAgXLfoXmg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=e0wmN8nCD2NwXIuBd6QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTIgRGVjIDIwMjUsIGF0IDEyOjM44oCvUE0sIEtodXNoaXQgU2hhaCA8a2h1c2hp
dC5zaGFoQG51dGFuaXguY29tPiB3cm90ZToNCj4gDQo+IEBAIC0xNTE1LDYgKzE1NTIsMTcgQEAg
c3RhdGljIHZvaWQga3ZtX2lvYXBpY19zZW5kX2VvaShzdHJ1Y3Qga3ZtX2xhcGljICphcGljLCBp
bnQgdmVjdG9yKQ0KPiAgICAgICAgaWYgKGFwaWMtPnZjcHUtPmFyY2guaGlnaGVzdF9zdGFsZV9w
ZW5kaW5nX2lvYXBpY19lb2kgPT0gdmVjdG9yKQ0KPiAgICAgICAgICAgICAgICBrdm1fbWFrZV9y
ZXF1ZXN0KEtWTV9SRVFfU0NBTl9JT0FQSUMsIGFwaWMtPnZjcHUpOw0KPiANCj4gKyAgICAgICAv
Kg0KPiArICAgICAgICogRG9uJ3Qgc2VuZCB0aGUgRU9JIHRvIHRoZSBJL08gQVBJQyBpZiB0aGUg
Z3Vlc3QgaGFzIGVuYWJsZWQgRGlyZWN0ZWQNCj4gKyAgICAgICAqIEVPSSwgYS5rLmEuIFN1cHBy
ZXNzIEVPSSBCcm9hZGNhc3RzLCBpbiB3aGljaCBjYXNlIHRoZSBsb2NhbA0KPiArICAgICAgICog
QVBJQyBkb2Vzbid0IGJyb2FkY2FzdCBFT0lzICh0aGUgZ3Vlc3QgbXVzdCBFT0kgdGhlIHRhcmdl
dA0KPiArICAgICAgICogSS9PIEFQSUMocykgZGlyZWN0bHkpLiBJZ25vcmUgdGhlIHN1cHByZXNz
aW9uIGlmIHRoZSBndWVzdCBoYXMgbm90DQo+ICsgICAgICAgKiBleHBsaWNpdGx5IGVuYWJsZWQg
U3VwcHJlc3MgRU9JIGJyb2FkY2FzdC4NCj4gKyAgICAgICAqLw0KPiArICAgICAgIGlmICgoa3Zt
X2xhcGljX2dldF9yZWcoYXBpYywgQVBJQ19TUElWKSAmIEFQSUNfU1BJVl9ESVJFQ1RFRF9FT0kp
ICYmDQo+ICsgICAgICAgICAgICAgICAgICFrdm1fbGFwaWNfaWdub3JlX3N1cHByZXNzX2VvaV9i
cm9hZGNhc3QoYXBpYy0+dmNwdS0+a3ZtKSkNCj4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4g
Kw0KPiAgICAgICAgLyogUmVxdWVzdCBhIEtWTSBleGl0IHRvIGluZm9ybSB0aGUgdXNlcnNwYWNl
IElPQVBJQy4gKi8NCj4gICAgICAgIGlmIChpcnFjaGlwX3NwbGl0KGFwaWMtPnZjcHUtPmt2bSkp
IHsNCj4gICAgICAgICAgICAgICAgYXBpYy0+dmNwdS0+YXJjaC5wZW5kaW5nX2lvYXBpY19lb2kg
PSB2ZWN0b3I7DQo+IA0KPiANCj4gSSBhbSBub3QgZW50aXJlbHkgc3VyZSBpZiByZXR1cm5pbmcg
ZnJvbSBrdm1faW9hcGljX3NlbmRfZW9pKCkgZWFybHkgaXMgY29ycmVjdA0KPiBmb3Iga2VybmVs
IElPQVBJQy4gVGhlIG9yaWdpbmFsIGNvZGUgKHdoaWNoIGlzIG5vdyByZWR1bmRhbnQpIGRvZXMg
dGhpcyB2ZXJ5IA0KPiBsYXRlIGluIGt2bV9pb2FwaWNfdXBkYXRlX2VvaV9vbmUoKS4NCg0KDQpB
bSBJIGNvcnJlY3QgaW4gYXNzdW1pbmcgd2Ugc3RpbGwgbmVlZCBhIGNhbGwgdG8gcnRjX2lycV9l
b2koKSBldmVuIGlmIHRoZSBndWVzdA0KaGFzIGVuYWJsZWQgU0VPSUI/IA0KDQpXZSB3aWxsIGNh
bGwga3ZtX2lvYXBpY191cGRhdGVfZW9pX29uZSgpIG9uIEkvTyBBUElDIEVPSVIgd3JpdGUuIEJ1
dCwgdGhlDQpmb2xsb3dpbmcgY29uZGl0aW9uIGluIGt2bV9pb2FwaWNfdXBkYXRlX2VvaV9vbmUo
KSBibG9ja3MgRU9JIHByb2Nlc3Npbmc6DQoNCmlmICh0cmlnZ2VyX21vZGUgIT0gSU9BUElDX0xF
VkVMX1RSSUcgfHwgDQogICAgICAgIGt2bV9sYXBpY19nZXRfcmVnKGFwaWMsIEFQSUNfU1BJVikg
JiBBUElDX1NQSVZfRElSRUNURURfRU9JKQ0KICAgICAgICAgICAgICAgIHJldHVybjsNCg0KU28s
IHRoZSBjb25kaXRpb24gbmVlZHMgdG8gbW92ZWQgZnJvbSBrdm1faW9hcGljX3VwZGF0ZV9lb2lf
b25lKCkuIEl0IG1ha2VzDQpzZW5zZSB0byBrZWVwIGl0IGluIGt2bV9pb2FwaWNfc2VuZF9lb2ko
KSBldmVuIGZvciBrZXJuZWwgSVJRQ0hJUC4gQnV0IGlmIGEgY2FsbA0KdG8gcnRjX2lycV9lb2ko
KSBpcyByZXF1aXJlZCAobGlrZWx5KSwgdGhlbiB3ZSBuZWVkIHNvbWV0aGluZyBzaW1pbGFyIHRv
IGZvbGxvd2luZzogDQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vaW9hcGljLmMgYi9hcmNo
L3g4Ni9rdm0vaW9hcGljLmMNCmluZGV4IDJjMjc4MzI5NmFlZC4uNzZlNTExYTM2Njk5IDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYva3ZtL2lvYXBpYy5jDQorKysgYi9hcmNoL3g4Ni9rdm0vaW9hcGlj
LmMNCkBAIC01NjAsOCArNTYwLDcgQEAgc3RhdGljIHZvaWQga3ZtX2lvYXBpY191cGRhdGVfZW9p
X29uZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsDQogICAgICAgIGt2bV9ub3RpZnlfYWNrZWRfaXJx
KGlvYXBpYy0+a3ZtLCBLVk1fSVJRQ0hJUF9JT0FQSUMsIHBpbik7DQogICAgICAgIHNwaW5fbG9j
aygmaW9hcGljLT5sb2NrKTsNCiANCi0gICAgICAgaWYgKHRyaWdnZXJfbW9kZSAhPSBJT0FQSUNf
TEVWRUxfVFJJRyB8fA0KLSAgICAgICAgICAga3ZtX2xhcGljX2dldF9yZWcoYXBpYywgQVBJQ19T
UElWKSAmIEFQSUNfU1BJVl9ESVJFQ1RFRF9FT0kpDQorICAgICAgIGlmICh0cmlnZ2VyX21vZGUg
IT0gSU9BUElDX0xFVkVMX1RSSUcpDQogICAgICAgICAgICAgICAgcmV0dXJuOw0KIA0KICAgICAg
ICBBU1NFUlQoZW50LT5maWVsZHMudHJpZ19tb2RlID09IElPQVBJQ19MRVZFTF9UUklHKTsNCkBA
IC01OTUsNiArNTk0LDExIEBAIHZvaWQga3ZtX2lvYXBpY191cGRhdGVfZW9pKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSwgaW50IHZlY3RvciwgaW50IHRyaWdnZXJfbW9kZSkNCiANCiAgICAgICAgc3Bp
bl9sb2NrKCZpb2FwaWMtPmxvY2spOw0KICAgICAgICBydGNfaXJxX2VvaShpb2FwaWMsIHZjcHUs
IHZlY3Rvcik7DQorDQorICAgICAgIGlmKChrdm1fbGFwaWNfZ2V0X3JlZyhhcGljLCBBUElDX1NQ
SVYpICYgQVBJQ19TUElWX0RJUkVDVEVEX0VPSSkgJiYNCisgICAgICAgICAgIGt2bV9sYXBpY19y
ZXNwZWN0X3N1cHByZXNzX2VvaV9icm9hZGNhc3QoaW9hcGljLT5rdm0pKQ0KKyAgICAgICAgICAg
ICAgIGdvdG8gb3V0Ow0KKw0KICAgICAgICBmb3IgKGkgPSAwOyBpIDwgSU9BUElDX05VTV9QSU5T
OyBpKyspIHsNCiAgICAgICAgICAgICAgICB1bmlvbiBrdm1faW9hcGljX3JlZGlyZWN0X2VudHJ5
ICplbnQgPSAmaW9hcGljLT5yZWRpcnRibFtpXTsNCiANCkBAIC02MDIsNiArNjA2LDggQEAgdm9p
ZCBrdm1faW9hcGljX3VwZGF0ZV9lb2koc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBpbnQgdmVjdG9y
LCBpbnQgdHJpZ2dlcl9tb2RlKQ0KICAgICAgICAgICAgICAgICAgICAgICAgY29udGludWU7DQog
ICAgICAgICAgICAgICAga3ZtX2lvYXBpY191cGRhdGVfZW9pX29uZSh2Y3B1LCBpb2FwaWMsIHRy
aWdnZXJfbW9kZSwgaSk7DQogICAgICAgIH0NCisNCitvdXQ6DQogICAgICAgIHNwaW5fdW5sb2Nr
KCZpb2FwaWMtPmxvY2spOw0KIH0NCi0tLQ0KRmluYWxseSwganVzdCB0byBkb3VibGUtY2hlY2ss
IGl0IGlzIHNhZmUgdG8gbm90IGNhbGwga3ZtX25vdGlmeV9hY2tlZF9pcnEoKQ0Kb24gTEFQSUMg
RU9JIHdoZW4gZ3Vlc3QgaGFzIGVuYWJsZWQgU3VwcHJlc3MgRU9JIEJyb2FkY2FzdCwgcmlnaHQ/
IEFzIGl0IHdpbGwgDQphbnl3YXkgYmUgY2FsbGVkIG9uIERpcmVjdCBFT0kuDQoNClRoYW5rcywg
DQpLaHVzaGl0

