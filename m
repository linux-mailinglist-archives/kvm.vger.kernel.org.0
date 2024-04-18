Return-Path: <kvm+bounces-15065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C77E88A97A8
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56A381F22222
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 10:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EC815D5B8;
	Thu, 18 Apr 2024 10:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="E96lt+tf";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="s1XfISje"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D29127B57
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713437007; cv=fail; b=MBRJsLvk65QLUjrPTGXsnuElKGVwmxTQSIqMnqn333DsxENEglMPnRSjnH3KtBUcxTZ0SRNz1LLseYnIYS5Z4IJfppSzVSc80TCi+11avw5Im7GPKd7sV6UTWQDvQUbJAQgsmpdrTp+RF4TrAEx3XXuiZz2YzBEGJ8klj7J9sZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713437007; c=relaxed/simple;
	bh=fbZE4TM3qHA3BBWIT1QqYUUVI2Wo2rDHgMDwf4hwWb4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qwCt40XNAkencLJ3ZjaDT4eIrD2ICA1RHQfApYkgE5BNSjpBP9WXU+ckejoXIGd2K50YZta/h9ulzJsZ1yVpomMjU5pQNarOT1sD9JB5jiV+3Pu01fJZdfwgmsalcjUoRPi6mnYqguvv+3CGb7td8TUG91bbcjvkcSGNVLFfkeE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=E96lt+tf; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=s1XfISje; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43I28KAx011082;
	Thu, 18 Apr 2024 03:42:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=proofpoint20171006; bh=fbZE4TM3qHA3BBWIT1QqYUUVI2Wo2rDHgMDwf4
	hwWb4=; b=E96lt+tfVtwPkwGHYJdNHaXPKVW23Ia+ryyVuG9OAGoWNKPqD3DLo/
	B4uE/690IimrRMHH+eUb4CnTppI6vBoa6V/mU+vFwvTdmdVfyv8QgQZH//tjfDok
	N27vKUqOM4VpmnMLkewLqIDaRWLMy8OZg+ShqW0ftL3Ql1f0CAiAt/pKMTuw2/UZ
	L2kXSgqqi9EsKq9f2fSI76VcWn9leJhy8VoQyX5oabpdSRA1GS+SeQ7b8FnSEZ1M
	8eNy4iWxRY5a6ySpzJBtgZIcaqQBwHHW6G3BwVJ/XN5zt/TvaDABhWJp0B/+I/GX
	HCdussNyI66OzDoIAZimL62xc2UBl+LQ==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3xfscdapbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 03:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNm7TFdLtLLGMijKGmRHcI93xqp15pgxOcNC93l5Mxq2+SV97u8a0w1EfPdTWtHjm1utjEdiYpxLjONjGYWl9JR0Hu61maNjZJErni1bd23+N5vMFxTpYhE+J2ifyfC6AxKW7c+VhNuZYHwkxqcxL0VMSrPtFDd5ZGID20eRzgnmEZf8UWBcJ3LIKfbZPQ4IT1NI97K3UdDqlSAYdQr4EnSNK8T0dyZVCLduZ35huLhMsgc3/rRiDxYFdPAGhI0GYlXB34LkuFIKzbGBHwD6pF1p0LxZRKJ9yVPn0GY1mDwaKTec8uPCnkiXPvhbX3MATucnWgE8wYzXJypmwm2Rmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbZE4TM3qHA3BBWIT1QqYUUVI2Wo2rDHgMDwf4hwWb4=;
 b=lRAh0fy8YiM85fS93CS4u7JkVgYefCbdjyblrVFUV9JpKcQ2A4U8/9rEApTQXqBXsJ/Da5Rb8U9XGY2SD305xsCZHqZkI6f+QDvoRef+f6Nmdjl1txCwl437qzOOvNf6gZ+3ne6LlnjLU/ZmE7D2ImXHiRa+GbQ7Wms3ckpP8z87NZ9ycwWvP9bP8zeZ7MaA7LYHhX60GDW0mIaNDIuDHiPZBpPs0xlWN9TBTlg6DLoG0fKupdYwNdUWpGvQTuUpervjZSQUvAjp8n2jwMCMNegDAfJceSInB9fwmQZKXfcy4N1XuccOVAx84YEoV4uiLKNGRykC996GWafAWtH1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbZE4TM3qHA3BBWIT1QqYUUVI2Wo2rDHgMDwf4hwWb4=;
 b=s1XfISjeMJ45ZQHNH64uUp8Ol+ZOG+tZhXQZ9JqhziZfZJFJt1iQYe5id21QpEymv1C84Sko2QlFSKCdAXpRKnra4ohGAc67RGJp/EZG1a3xVM8H9oVCQHO3zTo1okKV5YZhD9mjBTmPMw1jahDlTfr4mzVPATAQBAOIE9Z8D53xy7o0Nc2ABJPfuKd3w6KQjy7d1q8GvvydNNNO6ZpYVnCVYDwX86D0+ugkyHZ9Fvyq1jaU4ntNn/8FrR2OVX3omDXDFWGl4CgHvLFqdHF7HFX04XBzoybAominusoLtHtHiTa/IQtcnySyuR7R/f00y2uSy/gT/Dz82Vx3NMWV8w==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA2PR02MB7612.namprd02.prod.outlook.com (2603:10b6:806:134::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 10:42:57 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::cab5:29a2:97ac:ef9]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::cab5:29a2:97ac:ef9%5]) with mapi id 15.20.7452.049; Thu, 18 Apr 2024
 10:42:57 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Aravind Retnakaran
	<aravind.retnakaran@nutanix.com>,
        "Carl Waldspurger [C]"
	<carl.waldspurger@nutanix.com>,
        David Vrabel <david.vrabel@nutanix.com>,
        "david@redhat.com" <david@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Thread-Topic: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Thread-Index: AQHaZP94vJDynSfMhkS84iipQRUQf7FrgZSAgAKuuQA=
Date: Thu, 18 Apr 2024 10:42:57 +0000
Message-ID: <FB733BFE-DFFD-421E-B824-6061A1AF7BC3@nutanix.com>
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
 <Zh65Fbgdcyl6tiGr@google.com>
In-Reply-To: <Zh65Fbgdcyl6tiGr@google.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR02MB7555:EE_|SA2PR02MB7612:EE_
x-ms-office365-filtering-correlation-id: aa63361e-07f4-4b3b-f5ac-08dc5f944f6e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 AXZaH6KbkJV6BzuH05xZ4wuFbLPHp/WHOFhTOYoqZ925zN8/HN+kgA3mCyczY+B1VnZs7Vj2uEiSba8jWpzRSkHQuevVzzxO/TrlT57aWANKX9hcgIP0YdpEZUDniqlDqYMZYMzrhIlyIxS3LbLWQYsnzpzsCFyONSZpbnTRPzi0cJ3CZRUuE72g7J5CbFM355efwvbPiA8KDq4OW9r7d66LRv+vZD7p/zRomu5LXakze1wV0ecDMw0Wg0gBOM8610XT7DtdcyxGHynFx7vM2CTgUqSpAqhzpNcu9YSRY1r3m//R1jmeuYSDrc4aUsl+qy+CtTWFxAPvQfUzlnroosOxfIcRNeDcpNN2RHlBe9zZ+38vSNYAX4Re/rqQZKxt52hKfruaggvGLi9qev1jhD20w2KfLCev8F1JO+Jt64nczcCFz+Okh8TT+C6IsbTCksYEIIXLd3w3P+wvWfAk8BjY4sepPIMza48a/+IuEz00vG7S3Q0Q3JzAt2MH8kjjgD4LGwKUgAigK+gq/CDZ9qZeVOQQxQoGb272L9x9/ltqsnN44XuYrsPPT7zGx0G9AgoeWQ08FNT5yMUfuwXLBsO+cR88kJwrd+6ncYcI0vDcCKZGMod+UaPta4CqwavoESlvtAYo8heJnamMosm9TunZveqfb+woQjse66GnUeYZds7T8yZiQRch8aMLfK6bNLMVs1+3YmkWmFqSfQ9pokiGnvGZHz4QQ7W2gHcBZp0=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?dTd6c2pQalJPS1lJK0RVUzM3YUZyd2JSNXpFV2pNcmEvUW16OU1EczFUNUdv?=
 =?utf-8?B?am9hYmRNTlFsa0hsS1RrLzdaUnY2Z1VkWEtkcmc1bjlhMUZmNTFMTU1ZVXEz?=
 =?utf-8?B?b0JmT0g5aEZnTVMzWlM1WnpNY1dmTTdtbXErd0g3WEYwNURyRGwrVkR6WnJD?=
 =?utf-8?B?YU55bG1ZaHVhQzgzdEg0RDdxWG0xN1NQVGpPeEpraU9SNTd5RG1WbjRkb1dM?=
 =?utf-8?B?clVxQm1wZERkUnZ2alY5UzJxZWRzQTQ1Mysrb0t3YmF4aWFHNFQwVG9nd3dB?=
 =?utf-8?B?azdLUnptcWlLOHhYRkdtY2tBRCtWRml4MVgzOEZMS3FDZjZpUjliZlluOWR4?=
 =?utf-8?B?L3o3NVVEUjRNOFBJZHRKWFNZUWdsTGpMZk1pMHRTYitmRFEwQ3ZTUHg4WnBu?=
 =?utf-8?B?cTloUDYydjQrNm80MGl5czhYQmtiTUY1RGwvRzB5dG5nRHQ4bGt5dEx2S1Fi?=
 =?utf-8?B?ampNUWo1bGptT2EvUnZaN0d4WHdaNWlaNFU1S1hybFBsQVZ6ZVV5NGE2S1c0?=
 =?utf-8?B?SDR3V0hoQldYemQzTUhwdXBjYjNKTlRVR2Zwek9QYi9tbndRTmdHUVFWVG9G?=
 =?utf-8?B?Vmg2VitaZFNkT0E4eVA0dktURlZyekRzNXM2aHlzWEFRak1BU252WFRLbFNW?=
 =?utf-8?B?Vys1dklzY1JKdVlFNzM2ZGU4VkFVcFB1UGU4S1piUk1lWm1TRmdJOXdYRC8w?=
 =?utf-8?B?OGI4SGFpYjl3N3dTRHk3dElOYi9GaUZlL05oU3F2UWhlQXpXbkxZMGZpYm5u?=
 =?utf-8?B?RVIxWTRraU1Lc0NpVHF6UDJiTm9xY1VJZ2Y1c1FaRmgxK0dkMzRzM3N1dzNQ?=
 =?utf-8?B?T3FRaVVFTkErQWF2c0VLKzg0dHRFZVZPSmlRNnEzTGpmTFVXaTFXWVVxVlFw?=
 =?utf-8?B?TWw4Q0R5cTcvK1FaWlpKUDZTQ0VtNFVxYVZxWWVNbloyOThaa0tHcGNhSlY3?=
 =?utf-8?B?UDJQN1JlVWRBUDVpb3JuMnRNSTVuODJacnJhZ1FhdW1ZWHIrNFRHU2FXRWE2?=
 =?utf-8?B?RDYwZ281UUU3cThZVVVVNks0akhZY3ZEbUUyVTRJSVdRWEhXcTFQazNkUzJM?=
 =?utf-8?B?OWp6VVpMeWRjc0dacHE0Y2JEUVJZbkpZVWtQdGUrbVJZQmdWSzl6bHhHZmNM?=
 =?utf-8?B?Y1FMcStxZXpUeGxnOVdWQ1grb0ZOMmVXSjRTcHNLWXRndW81N2NpenN5RDBl?=
 =?utf-8?B?SXMzbzJXOU9pQ210dW5mMi8zNGE5ZmdzbW05UjR0YWt4cXFLR1ZITm5WTlVt?=
 =?utf-8?B?Q3BFYkVWUU40bUpqV2owYjNRcStzK2k3YTRRQThXSkpGZDBzN3k1VGRLTklF?=
 =?utf-8?B?enVuUUNzMXdEL0x1VjZKNlF2VXB1UTY0MVFJMzJERUpMUEZ1TjQ1M3NmR2lu?=
 =?utf-8?B?aWFHR090ZXQ1WE5NaFJQNGpxUTZOQ0I5Z2RqTndMd2NhcjgyUmYrK3NTdzRY?=
 =?utf-8?B?SDA3djRnVEU2UDJ0akJjOVJod0ZjY3J4L1pYbVZjRUx3Nk9wbFdCbjRBQW5a?=
 =?utf-8?B?VXJJSklMREhhdWpHc0c0NW56MzlCZDZ2QVlHYnpxSlNDZjNqWSs4L29USWJR?=
 =?utf-8?B?UUlYcXFnYzc1QlBvRENCRWYva0ZjV0daVmVML0hCRUJ2QWZQQjlYNzIxOEh6?=
 =?utf-8?B?TkUvaHhldmV4dXhtbExYQnpaVkZ4UW5VL3FweEZndjNhTXBRS2V2bEhLRlFU?=
 =?utf-8?B?QXdJcnZTV092OTRnZmRRN3pzQlNIeldWQWpUOXNDTlJaenpSSlR4Y1dVRHFj?=
 =?utf-8?B?WmdvNnZLK0E0ajgyZXJLU3NGQktydWdRK0l3WWhFWVJoZWRQSy9oWlAxaVhZ?=
 =?utf-8?B?MlV1YmU5elVoSjJKRTRQd2NoV2RUWFRTVGlxUnBYU2czdWUvTXYzQ0VrRmk4?=
 =?utf-8?B?NUlDU2RFZnd5aGlEUHJwM1E0a2lSMkwwSzRRcGJtUmc5d2U2VFplQlZkdWNL?=
 =?utf-8?B?VXpUSG1nMTZvdWZ6R0taTnJOVGI1SGNLRVZqUEg0MmhmV3N0UzRGajk0bkQv?=
 =?utf-8?B?dUNrM0xSZVRxNEcwQU5CVThJTElxQ3lQMXg0eFZNTUR6ZnZEM1pHaFRxbXFO?=
 =?utf-8?B?NkE2UTBadXRsc2NHVWtzS1hMMjZ2dHNVcnNUZzBUSWtsRzdZMWxVelRGQVhJ?=
 =?utf-8?B?WkR6WDh4ZW53b05OK2E4UGhVSU15Q3V6K2s0TGtWTUlLZEZuTlpUQVcvaWJy?=
 =?utf-8?B?RHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFCE9FECC802F54CA9A4BF08B3162920@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa63361e-07f4-4b3b-f5ac-08dc5f944f6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 10:42:57.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3sjWSQh9CRcxzWCmcQEl2JZlvgCHDtFVpdA7oOkjdlyX/pofD5Ujmo/4IrPOa4iUzmAz5lKuRPuAB/QhhEJTcmeRqqZ9FULz69SfPAb2Z0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7612
X-Proofpoint-ORIG-GUID: o-WhwhIeqytQxQo6qSpdqpr6WlZqD6pl
X-Proofpoint-GUID: o-WhwhIeqytQxQo6qSpdqpr6WlZqD6pl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_08,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYtQXByLTIwMjQsIGF0IDExOjE0IFBNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IE9uIFdlZCwgRmViIDIxLCAyMDI0LCBTaGl2YW0g
S3VtYXIgd3JvdGU6DQo+PiB2MToNCj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNv
bS92Mi91cmw/dT1odHRwcy0zQV9fbG9yZS5rZXJuZWwub3JnX2t2bV8yMDIxMTExNDE0NTcyMS4y
MDkyMTktMkQxLTJEc2hpdmFtLmt1bWFyMS00MHh4eHh4eHh4eHh4XyZkPUR3SUJBZyZjPXM4ODNH
cFVDT0NoS09IaW9jWXRHY2cmcj00aFZGUDQtSjEzeHluLU9jTjBhcFRDaDhpS1pSb3NmNU9KVFFl
UFhCTUI4Jm09bnBmMmJOZWl2SHU1QlhjeTY2TTgxa2hkVzBzeTRxRGg1ZDRrQ19WVGhsenIxWDJK
dllWdURITUJZbU5ZelhNTSZzPWJ1TGpLc2ZlQzItTmhUT2czR3E5YlFKZzlYRlVNbHZKc2k2dllJ
aVZJOWsmZT0gDQo+PiB2MjogaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3Vy
bD91PWh0dHBzLTNBX19sb3JlLmtlcm5lbC5vcmdfa3ZtX1lkeDJFVzZVM2ZwSm9KRjAtNDB4eHh4
eHh4eHh4X1RfJmQ9RHdJQkFnJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPTRoVkZQNC1KMTN4
eW4tT2NOMGFwVENoOGlLWlJvc2Y1T0pUUWVQWEJNQjgmbT1ucGYyYk5laXZIdTVCWGN5NjZNODFr
aGRXMHN5NHFEaDVkNGtDX1ZUaGx6cjFYMkp2WVZ1REhNQlltTll6WE1NJnM9VVVVSXBqWWlLajZH
M19TbFI0MFI5S1M2VW11SWxMVTA4OUFpNlNkUHJDOCZlPSANCj4+IHYzOiBodHRwczovL3VybGRl
ZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xvcmUua2VybmVsLm9yZ19r
dm1fWWtUMWt6V2lkYVJGZFFRaC00MHh4eHh4eHh4eHhfVF8mZD1Ed0lCQWcmYz1zODgzR3BVQ09D
aEtPSGlvY1l0R2NnJnI9NGhWRlA0LUoxM3h5bi1PY04wYXBUQ2g4aUtaUm9zZjVPSlRRZVBYQk1C
OCZtPW5wZjJiTmVpdkh1NUJYY3k2Nk04MWtoZFcwc3k0cURoNWQ0a0NfVlRobHpyMVgySnZZVnVE
SE1CWW1OWXpYTU0mcz1vUXFPWk5IZERPTUFFa0xFS1Bqd2lmZkthUWRLM1Q0a1pmX0RSUlVUdXhv
JmU9IA0KPj4gdjQ6DQo+PiBodHRwczovL3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJs
P3U9aHR0cHMtM0FfX2xvcmUua2VybmVsLm9yZ19hbGxfMjAyMjA1MjEyMDI5MzcuMTg0MTg5LTJE
MS0yRHNoaXZhbS5rdW1hcjEtNDB4eHh4eHh4eHh4eF8mZD1Ed0lCQWcmYz1zODgzR3BVQ09DaEtP
SGlvY1l0R2NnJnI9NGhWRlA0LUoxM3h5bi1PY04wYXBUQ2g4aUtaUm9zZjVPSlRRZVBYQk1COCZt
PW5wZjJiTmVpdkh1NUJYY3k2Nk04MWtoZFcwc3k0cURoNWQ0a0NfVlRobHpyMVgySnZZVnVESE1C
WW1OWXpYTU0mcz00ZkotRHp5N2dzRW5FeHFtR0YwblA4SzQxWWRWV1VDM3Y5dXJDTW44UlFJJmU9
IA0KPj4gdjU6IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRw
cy0zQV9fbG9yZS5rZXJuZWwub3JnX2FsbF8yMDIyMDkxMzA1MzIuMkJKd1c2NUwtMkRsa3AtNDB4
eHh4eHh4eHhfVF8mZD1Ed0lCQWcmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9NGhWRlA0LUox
M3h5bi1PY04wYXBUQ2g4aUtaUm9zZjVPSlRRZVBYQk1COCZtPW5wZjJiTmVpdkh1NUJYY3k2Nk04
MWtoZFcwc3k0cURoNWQ0a0NfVlRobHpyMVgySnZZVnVESE1CWW1OWXpYTU0mcz01R1h2U1FuZ05l
cVg2Mm5TLTNZdmUwLWJDdEh4S1lMRmZsNEFaaUZPLXUwJmU9IA0KPj4gdjY6DQo+PiBodHRwczov
L3VybGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xvcmUua2VybmVs
Lm9yZ19hbGxfMjAyMjA5MTUxMDEwNDkuMTg3MzI1LTJEMS0yRHNoaXZhbS5rdW1hcjEtNDB4eHh4
eHh4eHh4eF8mZD1Ed0lCQWcmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9NGhWRlA0LUoxM3h5
bi1PY04wYXBUQ2g4aUtaUm9zZjVPSlRRZVBYQk1COCZtPW5wZjJiTmVpdkh1NUJYY3k2Nk04MWto
ZFcwc3k0cURoNWQ0a0NfVlRobHpyMVgySnZZVnVESE1CWW1OWXpYTU0mcz1TOG1xSzcwWkVUUkFh
UTBwbXBZejlmem9KRFljRFZNU2dNdGNVbUNMNGZFJmU9IA0KPj4gdjc6DQo+PiBodHRwczovL3Vy
bGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xvcmUua2VybmVsLm9y
Z19hbGxfYTY0ZDk4MTgtMkRjNjhkLTJEMWUzMy0yRDU3ODMtMkQ0MTRlOWE5YmRiZDEtNDB4eHh4
eHh4eHh4eF90XyZkPUR3SUJBZyZjPXM4ODNHcFVDT0NoS09IaW9jWXRHY2cmcj00aFZGUDQtSjEz
eHluLU9jTjBhcFRDaDhpS1pSb3NmNU9KVFFlUFhCTUI4Jm09bnBmMmJOZWl2SHU1QlhjeTY2TTgx
a2hkVzBzeTRxRGg1ZDRrQ19WVGhsenIxWDJKdllWdURITUJZbU5ZelhNTSZzPVI5bUN6OWs4N1Ni
djFRWVJFTWV1RDRsOWZILWR1cWIxUkluTjNsbVJCZW8mZT0gDQo+IA0KPiBUaGVzZSBsaW5rcyBh
cmUgYWxsIGJ1c3RlZCwgd2hpY2ggd2FzIGFjdHVhbGx5IHF1aXRlIGFubm95aW5nIGJlY2F1c2Ug
SSB3YW50ZWQgdG8NCj4gZ28gYmFjayBhbmQgbG9vayBhdCBNYXJjJ3MgaW5wdXQuDQpFeHRyZW1l
bHkgc29ycnkgYWJvdXQgdGhhdC4gV2lsbCBmaXggdGhlbS4gSSBkaWRu4oCZdCByZWFsaXNlIHRo
aXMgd2hlbiBJIGNvcGllZCB0aGUgbGlua3MgZnJvbSB0aGUgcHJldmlvdXMgcGF0Y2guDQoNClRo
YW5rcywNClNoaXZhbQ==

