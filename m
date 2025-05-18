Return-Path: <kvm+bounces-46943-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BF81ABB233
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 00:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BA691893629
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 22:22:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 269EB20C00E;
	Sun, 18 May 2025 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="S5g5Iv9C";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Ae6D4hhk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E691EB18A;
	Sun, 18 May 2025 22:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747606914; cv=fail; b=rI7uu7BZS8AACB2IDceTGvCPg1QeuuNU4Uy+z1bsFZWlrET7y7UZErvGmLtDfg7SdsFnBhTtxf6mpigUpv+AxcXGhfRVf7+4PouNAMxLDVNP6pJflG7yLe97VQMzdvjCT/3SBe+U1CTd/S64wbL3tRsrKBR/M/zhw1dAfHOzMVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747606914; c=relaxed/simple;
	bh=SIcCIOoqVBg/QW5pCid0IDPN8QtYdzDDkyui7Jo3Jdk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IERiXhBrVvrKtgP8LUhjw1YL5zpAie7ODp9w7v5Z5hUM3/9PwTJfKU5C08M9DkWIICDzNmMN+m5KD82gLF6RfMqSP3qd9JneraOjbanAFGPpttW3u8bAWAwW8vM+FevzD9SLZbApgO/y8haNiWE5didu9ncP2l1YFbj8aiK388w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=S5g5Iv9C; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Ae6D4hhk; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54HJAS9u031126;
	Sun, 18 May 2025 15:21:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=SIcCIOoqVBg/QW5pCid0IDPN8QtYdzDDkyui7Jo3J
	dk=; b=S5g5Iv9CNMs8oOmA6giyA1zZvpfF4MhBb1Wt+Q1OPUs9OGR+i5kopAr7L
	/YGcvL4dH2ViVs0x4EforHfqBy8vtNz+3orGZCexXjBmvXNMh9u6YfS93V54LqLV
	5H4WyW8Lm3IcH0Rx9t3HNc6eXCK1C/6oh/dsbNdqwUx/y0vQ4P1Hu5qu+go+Kj1W
	9eGAR+uDZSidNnBAIvTBuu88fzNtECqTEjR0DFto/Hm2GXb6D4/z5OsiCleucrVy
	gnyswWxSeW68kulhH02KQ9dYUeSKHAoTTfM2K6uLA4fXc8W/q8PqdmBbAyql/yDp
	/O9Gm1o3WfAHZEHCbL0kOklmUZIFA==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2045.outbound.protection.outlook.com [104.47.73.45])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46pt0yhtg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 18 May 2025 15:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bgGdeYZUaWmU4VkgovOuYBT0r27+ijBbCrMDAPr7HhVUyWeOGsR+lSX+eK8uNUkskFeawl5ULf5tYn4Y/CzXdSNLbHkWdLqKrU0kfuo1JFvPuBFz8iA0onUrVatYpIMMnWqowvyxwW7Az8aSxv/HUkvPIlD497pd8nWgTlEoAybYtCisHYU1aZOtsBkI3cUwqEhzKml2n+WbYHsQ67VnBZf3RvHSxn4EqOrTIDT89IDlrdCb7yPblCP03mAAHBZ7eVHLY7/xaEDK/lP9R7kzGtR8JxmeOtLLUMLrKC5+qkO1/evNc2XbUSB7DHPEoKq8qDUQ7f0DiiBd5mqo332e0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIcCIOoqVBg/QW5pCid0IDPN8QtYdzDDkyui7Jo3Jdk=;
 b=Qk1HCelDlpdESLYnQprCeIlSalFbWdQY3ishaaFn+Tiaf+IGdzw1bXLsXvefI7PKd1Tc7ZQxA3dBLz9RPJBBiAA5S5xgKMNEGxIKWsUfMGfRJcGfd/ckwTIz7I9Y7WNQGX7d77t9hYn7xS6vvDRrYGxsPCTcTp5irg7TY+584Qcs/EHsuOu11zsszGwQNwwkYRrbeNQsU3YXhFJu/JRpishqCxU1G/idItE7Zub2orBk81+CZaKv274A+ZVLUEWusjZQUX7SQT/WqxDT5xaMxOjVnsqlqrHPmNIxLU4neU1ZOMv9R/36ZiLBqtvVwKrVjXNTANP9sJPTnTFMMyf98Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIcCIOoqVBg/QW5pCid0IDPN8QtYdzDDkyui7Jo3Jdk=;
 b=Ae6D4hhkEP0mq6pxcEJbZXCPG2dCfX6gC6b5GorH7B2qwXZ+kl21z+xQjMqGRKqBOet+GthiyjFNjZOkWXeN5Ki89H3Zy/dWb2A1SKpIPx0muTezjtCSU/6DnInNMC/zF4IKq2ImAVEzeEbCe8nSPlqMHdZsqJOi9qaJWcTROa9GGBQ3V2e7luynOhQo4ZW6jLHtUQBHvdnJ/qH3Wgn/e7AxohKGHeeOl2CMJt/KSdZ+axXxQ7q8ap7cqMH6LABxKac6DogWq2P/DUPpn8Cxa3FK6ihnJglJVg+tSNh2CUv/VZAWu1RfNx75uQQ0o1sX0XFfaqJt+u10qdUVLidAEQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CH3PR02MB10199.namprd02.prod.outlook.com
 (2603:10b6:610:1d1::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Sun, 18 May
 2025 22:21:35 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Sun, 18 May 2025
 22:21:34 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Topic: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Index: AQHbsYwmjuQam6Y/SEmtlBggg4gnP7PZF0OAgAAMBQA=
Date: Sun, 18 May 2025 22:21:34 +0000
Message-ID: <2C6E042E-7A45-4D07-BE9B-638B61CE5C3C@nutanix.com>
References: <20250420010518.2842335-1-jon@nutanix.com>
 <20250518173756-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250518173756-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|CH3PR02MB10199:EE_
x-ms-office365-filtering-correlation-id: 8e4abf04-395e-47c8-ec2c-08dd965a596d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SDFmaFZQMkVqK3hpa0drUTRyT1JlUEFDUTBrZTB4a2ZLQmRSaXdKNmpJbXZ3?=
 =?utf-8?B?NkNHbkhGVzAvNGhUczFtTHJxK0ZONkdIZVZ4YTM5RHpiY1dCZHNlRU0rWXdD?=
 =?utf-8?B?UTJrS0FFdlhoa1h4RnhKWEhPTHB0YUxrRGc4VEc1aGVYTlJ3NFZpMVhOdy9R?=
 =?utf-8?B?Wnp4b25VVmZYTVZjTU9ERGFISjJPV2RiOXVOYy9PQ0oyZTZUQjJXN2FWTFVE?=
 =?utf-8?B?Umd5WVpSRk1OZ2l6bkhZd2MzUno3cXhsS0h5aU1uM1VacnhnaTJ5eWZ5Ulhq?=
 =?utf-8?B?a2RBcE5BenJXR3R1eXg0RW92RHZTUmI1TEFwV2ttT0ZJYzh2MzJtdGFWY2d1?=
 =?utf-8?B?cUhBRWJ2VW41U21vOWxjZDFTbUZPYW9LSVl0Vi9KRUE4YzUya3ZheDZoV3lz?=
 =?utf-8?B?Nk1jRWJCUEJaKzRlNVdOdlhLd2k1ZzhVeERMWE1KQW5hSGNiQ1RiamFHMVVu?=
 =?utf-8?B?NFNEekQ5VkR5MzcxK0JzTnVUcnBsSDhtV2RVNk0raTJkRVFXTEZoYkR2Mi96?=
 =?utf-8?B?K2ZtNFo0dHBQTE5HMUkzdmZBZ2VDZHVkd0UvNjdFdDRrZVhSbWpVeEkzMzRO?=
 =?utf-8?B?WUZvM01qb3VwT0FhSVltYmZVTU8yNFF0Skk3TFU0eGNPTHE1cmh2d1JpOERh?=
 =?utf-8?B?ZkxWSlRWY0lTVm91WGdtYXY3M1BNY0ZqeUZxL2JMK2RicnBZL1FpSkliY2JS?=
 =?utf-8?B?L2ZTQjFFQ3hKNWc4TjBGbzUzQWpjNFdMQy81M3lCOWR1dVZ4TGdIajF6aWpB?=
 =?utf-8?B?RzBzRU5EZFArUU9tY1FobURXNVc2ZkF1RTE5RTZBYXVFOTNOa1pLOExGay9R?=
 =?utf-8?B?WkZNNDdJc25IUVh1NlhPTGxwMy9ORUZ0YVphcllpYTg1d2lpU2ZPODVrS0Ju?=
 =?utf-8?B?UGtPelQyTWlDM3VzbVlqdnFjUEwwaXdEd3duQW01dlI4VHJYdGo0RUtxZDNJ?=
 =?utf-8?B?R1U1VFNvS1NMR0ZoVFdJWWxoTHdMNm45SHNhY2RTZkFzR2R1Y2xsNG1UeVh3?=
 =?utf-8?B?azJHQXZTclNaYjFFa0QzL0ZQSzVvYUZ6R1FQR0o3RDdocnpMd1N2SVRRUitH?=
 =?utf-8?B?cmhsT2pCcTFEYUwvUnczRXJoZm9hZjlzRTFKTE1kRjU2L2pNaHlvV04xSjIz?=
 =?utf-8?B?TkVkTXRCUWN1ZDZEUHR3bFI3TXBIdmU1cVVXT3JwTFNVNVZ5USt5N0NLanlq?=
 =?utf-8?B?TjhxUTYvblI4anlxOWp0UEdHZTEwZ0UyNEVLKy9CQkI5ZG5ld2N5M3ZOM0lR?=
 =?utf-8?B?cm12WTROb29Mc01ZZWUzQ3R4U2RaYWZ0T09EUiswbEp6Z0F5L2xVa2Y3VFds?=
 =?utf-8?B?S25UREppaEVZYVI0a1oweS9Nb1J2RVpQcy9kVm9Rd0cxa2MzVENhYU9QYXlP?=
 =?utf-8?B?U3I0UXhSWHY2b3JjczU5N1dGS2kzSllpVkJUTlU4aVNBazZ0TzgzaFdubVd5?=
 =?utf-8?B?Z2NJNGZ6N2tIV1FmZytRRjMxN0p3RWk0SFl0L0h1MzhsSUZHekJ6WityTE5H?=
 =?utf-8?B?Q3JuZjh4NStvQi9nSTNtTVg1Y1NrVUJHMXRHblBGNnNLbXRFQWF0ZnRMR3Zi?=
 =?utf-8?B?Q0Y2MTRPb2hjeUpCMGpxQktXOHp5bzIrZ3dzZmoyN3lUMVcrQ1Mzaytvbmdi?=
 =?utf-8?B?TnR6U0hOazJranJndjk3VjgwS29Wa1VqRUptNlFlWGM4QnRrQUpyWkhRY3hr?=
 =?utf-8?B?VUFZb0l6L0tBNWtrYWkzOFpNQkVYRlIxZ3BjK3kzTXhzeFBNZWpkQkd6UG5Y?=
 =?utf-8?B?S1dHSk1HTndBNTNWNFI1VjIwMEdKeVk5WHBnU0JTeGFQNFdrWTd5V1hheDVs?=
 =?utf-8?B?cUwyQTJTQ1lUS0kxWGVIMU1iZGwzaWpwbEtMcjVPUmdNODNGbDBnajY1YUFv?=
 =?utf-8?B?Z2RDcFY2OXFRcDdPYjVhT001ZUcyRzdxbmtNZjFVRzYra1RNV21RSk9oVkVH?=
 =?utf-8?B?V1o4MkVkRmlQaElYb3J6QWZTUHhldnJLTmN2ditVZmlnekdOOWV2OGRZdW9U?=
 =?utf-8?Q?In5d7zmacwyyuBPFgtbyEror8el/I4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YnBrOVljcmNOVnh4QVdPR09JR2d6MStTa1U3cWsvNkJqZmNJUUY0TFNnZFJh?=
 =?utf-8?B?U2R0V2FLeWN5WUVIazhoSmJMd2VxNFlFaUNhS0EyRHh4cUJyNGgyR0NHOWdM?=
 =?utf-8?B?KytqcC9lM0hYaiszdDM1QjZ2REs3dTNhZVh2NTVKNkQrN01zUVBMZ1lxUmZF?=
 =?utf-8?B?ZVVrY2Mwb1dNd3JMMDJCeEhuT29xUXdocWlNdnNQWjBnWEtONkZIdWRleUxJ?=
 =?utf-8?B?b2EvQmdSR0N3dStRWEtYUWhxQS83YmEwbjFvSWdSZUR1LzloWndqRndnK1g4?=
 =?utf-8?B?NndwQlU5eE43ZDdDRGJ3YjVjMDdJUFhuT2ZvVHNVQ3Q4MlpPOEN1QUExZEg5?=
 =?utf-8?B?UTVuWlZuL0N2TFNKdDNLVk1ZN0JUL0VYVUNMdmFTbFpXbDR2VEQrU1lLMzVu?=
 =?utf-8?B?eEpvMTVmcUNnNkdkWm5pRVlwZmp5bmhrdzZHMi9wS3hhRFpxSFdRQjRFUGVw?=
 =?utf-8?B?TngyQmdxRWpnSVlRZ1dCZVRablRUcjVFWkQ4ZFB2SytXcWJ4ZzMwblgyekNI?=
 =?utf-8?B?R1VFQS9Wd3VwS3I5QzNmdU5yc3RJRDJuTk1pRlErYzh4dWNXdk8yK3RhaGtr?=
 =?utf-8?B?OGxadlNGMGkxL3ZvSGFCQTJBeHdtM2liTVM0NzdmRkkreWM2T1c4cFRaZTMw?=
 =?utf-8?B?UXczN0NOZzJzR0VTTzB2ZjdxTzRWeWhBc0RuZ0RIVm9aUEVrMDFsK3hQM1FI?=
 =?utf-8?B?Rm56aDBaTXZaYUJLbkgvdnJLZDZVaG5JbHhxYUZZcjJ5L0s5eWszMDd3NGF0?=
 =?utf-8?B?bXpUb1ZqOWE3WHdCYVczakswM2xCOEN3RFIxUkdGcWlvYVNIN0VqS3Q5dzJH?=
 =?utf-8?B?Z05WNzFiY1JOdEdIc1JKT3cvSzZoVm9VNEFCT0xaQmp3RFdzN21uUER3bnFl?=
 =?utf-8?B?aUJ6NmNXYllOWTVkM2YvY3dLaENuZ3hNRFhqU0dvOW9oUGJ2Z3hFcWptSE1L?=
 =?utf-8?B?a3doclJONW1uK2tScWxqZy9BLzRTUUswaThQd3lUbURPUGxWL0w5cHpZYnNx?=
 =?utf-8?B?bjU2cllQNjlzUWRnNTM1TVcyNXF2ckFSUmhvSUprYjZHdkRxbkE4RlRlQ1Rt?=
 =?utf-8?B?Y25OaGlUOHhCNFdJUnhXWUE2YzRteEh3VjhXcXpiSm5Xd0FQMHVtWFpzeEJD?=
 =?utf-8?B?cTNBblZDMjhteEwvb2E4STBXbml2U2hlSG4rS0d6Szgrc2hJYlo2OE53M2VF?=
 =?utf-8?B?aWd2NWFVck8vN0tneUpsWXMzN0M3NGZWOUZjUVYrcHZtZ3hEakY5YXF6Yk4y?=
 =?utf-8?B?RnF2Wmk0Q1hTVkNYbW5pekgvcDJTZHo4T3E5Y3BhUCtVcHpHaDZuMXVLcHJJ?=
 =?utf-8?B?NXRLN1pzd1JIZFoxK2JoSTJwME92Wm9QMUZFbFUxWTF1Vm5VSGNNR3hVK1JH?=
 =?utf-8?B?b1gxcDdpTjFJWFBZQWlRaUZlQzNzSzVKeTZTVFFLUTBuWERVdWluOGJNYnRU?=
 =?utf-8?B?T2xabmRHTzVkWDFVRFBYcE9LYzFBZmlVcjQrOEVwc1NReEcvdkdmQ1d5R1RU?=
 =?utf-8?B?VWxkcWl1YVQrODJ4YWRub2hjRkhhSEE3d2RXdkpXS1Q3TmNlelY2VzRnOXpC?=
 =?utf-8?B?TVpYTlpJWlJEUHJadENYak0vM1VINC8wRk16c29rM0hJVVp6SDd2dE1rOTNT?=
 =?utf-8?B?LzdvTmErS1krcmpuQUFGWXVDRzRDbHhSTzZaM2c0aVNuaUFEYVNNT1ltR2p1?=
 =?utf-8?B?RnVuWGlWT1FPenZMUStQVG9hOWFjdW1LSUNNNFV5eUFheUFoN0VRZXE4RXEy?=
 =?utf-8?B?VjMwNE04VGlGSDMveVRaeGJjemRJb2VOVWkxN3hBT2VvM2QwRHl3Yk5LZnFy?=
 =?utf-8?B?RnFzM3lxTysxcnJicGljeDFkUVJTUXBzZTBUS2lVblI1SHdSUjU2dDBMV1ZM?=
 =?utf-8?B?eFVyeDBOaFhsNDRwRFNyZEJBZitaZXZCMHovbjFxZ3J5NE5EYXptNVJGcXRM?=
 =?utf-8?B?Z1VLcDFpNnkxU2czZ1EzZnArcVF6TFE3TUN6cWMweFlGMUhFd3ZpREJaSkRo?=
 =?utf-8?B?cTJkVEZ4eDc3VW9ZZjFYYTQyWm44S3ZQak5CcXZMS2xrR2JGa2NlK1VQZUc1?=
 =?utf-8?B?UXRVaGIxekFVREdOU3dRMXZZQXFHaVhwZmQ2VXYxbjh6aitEMjAvK01NenJp?=
 =?utf-8?B?Z0pWTW1qdmNoQ3VIajhNbUpGUWpjTE1XTHFXbEhXTFNXNG5MYk1CamowNjRh?=
 =?utf-8?B?VjVnYjlEMXBBWnFiU3F0VGd3SFBTd0ZubEZPaGZpZ0lpTk4wckdzamgvdEZI?=
 =?utf-8?B?bGFjVkZ6NVV1UWp2bm9IRm9GdEFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F117473540CB0B44B4B47548E9EE80DF@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e4abf04-395e-47c8-ec2c-08dd965a596d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2025 22:21:34.7952
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G7eFLnrw/RIGtCkW14V0blp7TwWAjbSItq8zCDK8MfV4Z3qiQijdPAPMEWhchRSll7HfOjmnaY/tHLA0YFaxZbsCjGRApLmUkd+7tmNKTq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10199
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE4MDIyMiBTYWx0ZWRfX9kINejEB9Vjf kYrMNg7nkefsTsPQJ6wLI3FBR6O0AhgLTkQtL2kUWWQ26N0Ef9UsvHoNaLWd5YQ4UwLloKMlK5o I2TUIcckH1MZvttlMP3U3EqVYYZ53tq6NlDIzhM3PikpxOnTbUM6yJtHDFhyKC7qEr+JrKIe9/K
 pI/hqFSPVvW4OzkpFFZ0+DykKMuh35S+EWPGDOL33ztPkUHT5Ad0YIy0ncXt0yBuob4/DWt4GeH BAW2hrdp+ss8ZoqM//bEzpPXLd7IebYbYf8pjiuZGuN77JfRTh8JLTvU7oyXR2QT7JZV36ESZ4Y Y1c/MgcxnZQFNPPAcRWG1MXQpYLkXwEHKhDfyMCvbHhx5sBGErlOgOsPM7llZzFczGku1+DeVYg
 0Y0AMjYmRyqkAv9cFGxm8xfkVuhstI0pHVStHe1bMboM26CnE2m3oxMpeYb+IyQ1DyjR9JyQ
X-Authority-Analysis: v=2.4 cv=KPtaDEFo c=1 sm=1 tr=0 ts=682a5d73 cx=c_pps a=o99l/OlIsmxthp48M8gYaQ==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=8Q7crdlElA80znR7TPwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: zlOwOZfk2Wu_uiCTUJFoWelIUbabDO_T
X-Proofpoint-ORIG-GUID: zlOwOZfk2Wu_uiCTUJFoWelIUbabDO_T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-18_11,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDE4LCAyMDI1LCBhdCA1OjM44oCvUE0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBF
eHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBTYXQsIEFwciAxOSwg
MjAyNSBhdCAwNjowNToxOFBNIC0wNzAwLCBKb24gS29obGVyIHdyb3RlOg0KPj4gSW4gaGFuZGxl
X3R4X2NvcHksIFRYIGJhdGNoaW5nIHByb2Nlc3NlcyBwYWNrZXRzIGJlbG93IH5QQUdFX1NJWkUg
YW5kDQo+PiBiYXRjaGVzIHVwIHRvIDY0IG1lc3NhZ2VzIGJlZm9yZSBjYWxsaW5nIHNvY2stPnNl
bmRtc2cuDQo+PiANCj4+IEN1cnJlbnRseSwgd2hlbiB0aGVyZSBhcmUgbm8gbW9yZSBtZXNzYWdl
cyBvbiB0aGUgcmluZyB0byBkZXF1ZXVlLA0KPj4gaGFuZGxlX3R4X2NvcHkgcmUtZW5hYmxlcyBr
aWNrcyBvbiB0aGUgcmluZyAqYmVmb3JlKiBmaXJpbmcgb2ZmIHRoZQ0KPj4gYmF0Y2ggc2VuZG1z
Zy4gSG93ZXZlciwgc29jay0+c2VuZG1zZyBpbmN1cnMgYSBub24temVybyBkZWxheSwNCj4+IGVz
cGVjaWFsbHkgaWYgaXQgbmVlZHMgdG8gd2FrZSB1cCBhIHRocmVhZCAoZS5nLiwgYW5vdGhlciB2
aG9zdCB3b3JrZXIpLg0KPj4gDQo+PiBJZiB0aGUgZ3Vlc3Qgc3VibWl0cyBhZGRpdGlvbmFsIG1l
c3NhZ2VzIGltbWVkaWF0ZWx5IGFmdGVyIHRoZSBsYXN0IHJpbmcNCj4+IGNoZWNrIGFuZCBkaXNh
YmxlbWVudCwgaXQgdHJpZ2dlcnMgYW4gRVBUX01JU0NPTkZJRyB2bWV4aXQgdG8gYXR0ZW1wdCB0
bw0KPj4ga2ljayB0aGUgdmhvc3Qgd29ya2VyLiBUaGlzIG1heSBoYXBwZW4gd2hpbGUgdGhlIHdv
cmtlciBpcyBzdGlsbA0KPj4gcHJvY2Vzc2luZyB0aGUgc2VuZG1zZywgbGVhZGluZyB0byB3YXN0
ZWZ1bCBleGl0KHMpLg0KPj4gDQo+PiBUaGlzIGlzIHBhcnRpY3VsYXJseSBwcm9ibGVtYXRpYyBm
b3Igc2luZ2xlLXRocmVhZGVkIGd1ZXN0IHN1Ym1pc3Npb24NCj4+IHRocmVhZHMsIGFzIHRoZXkg
bXVzdCBleGl0LCB3YWl0IGZvciB0aGUgZXhpdCB0byBiZSBwcm9jZXNzZWQNCj4+IChwb3RlbnRp
YWxseSBpbnZvbHZpbmcgYSBUVFdVKSwgYW5kIHRoZW4gcmVzdW1lLg0KPj4gDQo+PiBJbiBzY2Vu
YXJpb3MgbGlrZSBhIGNvbnN0YW50IHN0cmVhbSBvZiBVRFAgbWVzc2FnZXMsIHRoaXMgcmVzdWx0
cyBpbiBhDQo+PiBzYXd0b290aCBwYXR0ZXJuIHdoZXJlIHRoZSBzdWJtaXR0ZXIgZnJlcXVlbnRs
eSB2bWV4aXRzLCBhbmQgdGhlDQo+PiB2aG9zdC1uZXQgd29ya2VyIGFsdGVybmF0ZXMgYmV0d2Vl
biBzbGVlcGluZyBhbmQgd2FraW5nLg0KPj4gDQo+PiBBIGNvbW1vbiBzb2x1dGlvbiBpcyB0byBj
b25maWd1cmUgdmhvc3QtbmV0IGJ1c3kgcG9sbGluZyB2aWEgdXNlcnNwYWNlDQo+PiAoZS5nLiwg
cWVtdSBwb2xsLXVzKS4gSG93ZXZlciwgdHJlYXRpbmcgdGhlIHNlbmRtc2cgYXMgdGhlICJidXN5
Ig0KPj4gcGVyaW9kIGJ5IGtlZXBpbmcga2lja3MgZGlzYWJsZWQgZHVyaW5nIHRoZSBmaW5hbCBz
ZW5kbXNnIGFuZA0KPj4gcGVyZm9ybWluZyBvbmUgYWRkaXRpb25hbCByaW5nIGNoZWNrIGFmdGVy
d2FyZCBwcm92aWRlcyBhIHNpZ25pZmljYW50DQo+PiBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCB3
aXRob3V0IGFueSBleGNlc3MgYnVzeSBwb2xsIGN5Y2xlcy4NCj4+IA0KPj4gSWYgbWVzc2FnZXMg
YXJlIGZvdW5kIGluIHRoZSByaW5nIGFmdGVyIHRoZSBmaW5hbCBzZW5kbXNnLCByZXF1ZXVlIHRo
ZQ0KPj4gVFggaGFuZGxlci4gVGhpcyBlbnN1cmVzIGZhaXJuZXNzIGZvciB0aGUgUlggaGFuZGxl
ciBhbmQgYWxsb3dzDQo+PiB2aG9zdF9ydW5fd29ya19saXN0IHRvIGNvbmRfcmVzY2hlZCgpIGFz
IG5lZWRlZC4NCj4+IA0KPj4gVGVzdCBDYXNlDQo+PiAgICBUWCBWTTogdGFza3NldCAtYyAyIGlw
ZXJmMyAgLWMgcngtaXAtaGVyZSAtdCA2MCAtcCA1MjAwIC1iIDAgLXUgLWkgNQ0KPj4gICAgUlgg
Vk06IHRhc2tzZXQgLWMgMiBpcGVyZjMgLXMgLXAgNTIwMCAtRA0KPj4gICAgNi4xMi4wLCBlYWNo
IHdvcmtlciBiYWNrZWQgYnkgdHVuIGludGVyZmFjZSB3aXRoIElGRl9OQVBJIHNldHVwLg0KPj4g
ICAgTm90ZTogVENQIHNpZGUgaXMgbGFyZ2VseSB1bmNoYW5nZWQgYXMgdGhhdCB3YXMgY29weSBi
b3VuZA0KPj4gDQo+PiA2LjEyLjAgdW5wYXRjaGVkDQo+PiAgICBFUFRfTUlTQ09ORklHL3NlY29u
ZDogNTQxMQ0KPj4gICAgRGF0YWdyYW1zL3NlY29uZDogfjM4MmsNCj4+ICAgIEludGVydmFsICAg
ICAgICAgVHJhbnNmZXIgICAgIEJpdHJhdGUgICAgICAgICBMb3N0L1RvdGFsIERhdGFncmFtcw0K
Pj4gICAgMC4wMC0zMC4wMCAgc2VjICAxNS41IEdCeXRlcyAgNC40MyBHYml0cy9zZWMgIDAvMTE0
ODE2MzAgKDAlKSAgc2VuZGVyDQo+PiANCj4+IDYuMTIuMCBwYXRjaGVkDQo+PiAgICBFUFRfTUlT
Q09ORklHL3NlY29uZDogNTggKH45M3ggcmVkdWN0aW9uKQ0KPj4gICAgRGF0YWdyYW1zL3NlY29u
ZDogfjY1MGsgICh+MS43eCBpbmNyZWFzZSkNCj4+ICAgIEludGVydmFsICAgICAgICAgVHJhbnNm
ZXIgICAgIEJpdHJhdGUgICAgICAgICBMb3N0L1RvdGFsIERhdGFncmFtcw0KPj4gICAgMC4wMC0z
MC4wMCAgc2VjICAyNi40IEdCeXRlcyAgNy41NSBHYml0cy9zZWMgIDAvMTk1NTQ3MjAgKDAlKSAg
c2VuZGVyDQo+PiANCj4+IEFja2VkLWJ5OiBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29t
Pg0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPiANCj4g
DQo+IEpvbiB3aGF0IGFyZSB3ZSBkb2luZyB3aXRoIHRoaXMgcGF0Y2g/IHlvdSBzdGlsbCBsb29r
aW5nIGludG8NCj4gc29tZSBmZWVkYmFjaz8NCg0KSGV5IE1pY2hhZWwsDQpUaGlzIHdhcyBhbHJl
YWR5IG1lcmdlZCBpbiB2MyBwYXRjaDogDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAy
NTA1MDEwMjA0MjguMTg4OTE2Mi0xLWpvbkBudXRhbml4LmNvbS8NCmh0dHBzOi8vZ2l0Lmtlcm5l
bC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L25ldGRldi9uZXQtbmV4dC5naXQvY29tbWl0
L2RyaXZlcnMvdmhvc3QvbmV0LmM/aWQ9OGMyZTZiMjZmZmUyNDNiZTFlNzhmNWE0YmZiMWE4NTdk
NmU2ZjZkNg0KDQoNCj4gDQo+PiAtLS0NCj4+IGRyaXZlcnMvdmhvc3QvbmV0LmMgfCAxOSArKysr
KysrKysrKysrKystLS0tDQo+PiAxIGZpbGUgY2hhbmdlZCwgMTUgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvbmV0LmMgYi9k
cml2ZXJzL3Zob3N0L25ldC5jDQo+PiBpbmRleCBiOWI5ZTlkNDA5NTEuLjliMDQwMjVlZWE2NiAx
MDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+ICsrKyBiL2RyaXZlcnMvdmhv
c3QvbmV0LmMNCj4+IEBAIC03NjksMTMgKzc2OSwxNyBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfdHhf
Y29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2spDQo+PiBicmVh
azsNCj4+IC8qIE5vdGhpbmcgbmV3PyAgV2FpdCBmb3IgZXZlbnRmZCB0byB0ZWxsIHVzIHRoZXkg
cmVmaWxsZWQuICovDQo+PiBpZiAoaGVhZCA9PSB2cS0+bnVtKSB7DQo+PiArIC8qIElmIGludGVy
cnVwdGVkIHdoaWxlIGRvaW5nIGJ1c3kgcG9sbGluZywgcmVxdWV1ZQ0KPj4gKyAqIHRoZSBoYW5k
bGVyIHRvIGJlIGZhaXIgaGFuZGxlX3J4IGFzIHdlbGwgYXMgb3RoZXINCj4+ICsgKiB0YXNrcyB3
YWl0aW5nIG9uIGNwdQ0KPj4gKyAqLw0KPj4gaWYgKHVubGlrZWx5KGJ1c3lsb29wX2ludHIpKSB7
DQo+PiB2aG9zdF9wb2xsX3F1ZXVlKCZ2cS0+cG9sbCk7DQo+PiAtIH0gZWxzZSBpZiAodW5saWtl
bHkodmhvc3RfZW5hYmxlX25vdGlmeSgmbmV0LT5kZXYsDQo+PiAtIHZxKSkpIHsNCj4+IC0gdmhv
c3RfZGlzYWJsZV9ub3RpZnkoJm5ldC0+ZGV2LCB2cSk7DQo+PiAtIGNvbnRpbnVlOw0KPj4gfQ0K
Pj4gKyAvKiBLaWNrcyBhcmUgZGlzYWJsZWQgYXQgdGhpcyBwb2ludCwgYnJlYWsgbG9vcCBhbmQN
Cj4+ICsgKiBwcm9jZXNzIGFueSByZW1haW5pbmcgYmF0Y2hlZCBwYWNrZXRzLiBRdWV1ZSB3aWxs
DQo+PiArICogYmUgcmUtZW5hYmxlZCBhZnRlcndhcmRzLg0KPj4gKyAqLw0KPj4gYnJlYWs7DQo+
PiB9DQo+PiANCj4+IEBAIC04MjUsNyArODI5LDE0IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9j
b3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+ICsrbnZx
LT5kb25lX2lkeDsNCj4+IH0gd2hpbGUgKGxpa2VseSghdmhvc3RfZXhjZWVkc193ZWlnaHQodnEs
ICsrc2VudF9wa3RzLCB0b3RhbF9sZW4pKSk7DQo+PiANCj4+ICsgLyogS2lja3MgYXJlIHN0aWxs
IGRpc2FibGVkLCBkaXNwYXRjaCBhbnkgcmVtYWluaW5nIGJhdGNoZWQgbXNncy4gKi8NCj4+IHZo
b3N0X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsNCj4+ICsNCj4+ICsgLyogQWxsIG9m
IG91ciB3b3JrIGhhcyBiZWVuIGNvbXBsZXRlZDsgaG93ZXZlciwgYmVmb3JlIGxlYXZpbmcgdGhl
DQo+PiArICogVFggaGFuZGxlciwgZG8gb25lIGxhc3QgY2hlY2sgZm9yIHdvcmssIGFuZCByZXF1
ZXVlIGhhbmRsZXIgaWYNCj4+ICsgKiBuZWNlc3NhcnkuIElmIHRoZXJlIGlzIG5vIHdvcmssIHF1
ZXVlIHdpbGwgYmUgcmVlbmFibGVkLg0KPj4gKyAqLw0KPj4gKyB2aG9zdF9uZXRfYnVzeV9wb2xs
X3RyeV9xdWV1ZShuZXQsIHZxKTsNCj4+IH0NCj4+IA0KPj4gc3RhdGljIHZvaWQgaGFuZGxlX3R4
X3plcm9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+
IC0tIA0KPj4gMi40My4wDQo+IA0KDQo=

