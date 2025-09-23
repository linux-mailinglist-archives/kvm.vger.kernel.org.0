Return-Path: <kvm+bounces-58446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9E4B941C3
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 05:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AC2D7AC1C2
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DA052638B2;
	Tue, 23 Sep 2025 03:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HE7uU4nq";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dG9X8AD1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82022AD25;
	Tue, 23 Sep 2025 03:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758598406; cv=fail; b=uil6p2N3LeCO9oUFlewHAKSnlDL/3PA1/c0QAR1bVKKKTgtOANSdUdkuWcyA0wIMUxtRlFN2K0TNNHGpepYB5VtTKHvCfGCVlwXMWY14ZA3a7et1ZsMCnyMR3B59U1U28zrRFzJF4wzbFfFoOOIBnD4J+Kzot0Wyt6IaEehtgjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758598406; c=relaxed/simple;
	bh=NF5U2F5LTSAyj0Oo5pnm+Zigdf203WVRpRZMJMmAFeU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jUglzE2Z0PjlDkmvYUUpWLWB6r5VUfZR5lqAnEsfLK9rbdO5VRSsWUyRVkF4jhfby5X/WxOhR72YN2gvTpk+BF/uXAmEUGDG8FVS84Bm4OADURQ1PSdr43esbq9RGcuHOXLW0WBG2jipDHSPuPfbSQ/c0bhEX0PljGGbo41vAD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HE7uU4nq; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dG9X8AD1; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58MJ4JrK069601;
	Mon, 22 Sep 2025 20:32:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=NF5U2F5LTSAyj0Oo5pnm+Zigdf203WVRpRZMJMmAF
	eU=; b=HE7uU4nqlZ5zH9QcxRqEVykYKr+ebFV7FyPEz29C3RYwW1djQ3ogWg/R7
	w9XskJpZN0JPAizak6rH+h7CqOX1N1YLnMmxgrMS544LfZJOfSA9toLM67cACn3d
	DA/f0wVkrmXn8/nxPRb4qSVIclZNQJp0vVKHKrgVQJOi4NGJtqOC8XcnYJhdXOY6
	DEVJdHm9+um5c22TTmqkIcuer5LAKVTFReYrEbTh0buj18ebMCGLb/iBA4+QT2wZ
	c5N9RpuOf4B11pmNd+79GLCrhX21BrHuqotS84Uumq3TFqo8111HGFXc2wSJ3749
	owWjhtHPcn8DsdG1GWmlG2sr1x+Rg==
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11022094.outbound.protection.outlook.com [52.101.53.94])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 49bc9vgr8u-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Sep 2025 20:32:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8wWEVXw+4KqLGUIDGI5dIXLKoEJbrGLwBTDqzZmT/4vcRjBJOUJgoTXbDaM0D0fJNE3W4VJf+8qPWyvHR7QpJzYt2xC2dN6gwNO8muPxGu6fa2FV6HS2AgAw4U/F5cudWtH0Q3IrThgnF9ox+LQdjzWYqz6aQguFN/1CkTdlVTSDkAQp3a+gQjo1QheSDi6HtdFFuKrTvsZwoRfi6yu3P+5iZ3S3YeDjRIljj7St0lFB+54Hjo+KGVj3BqYdA/SkF+1Aphfy2TF5OsYMheC7XX9Lh2W8/OIjcFnFY+XNDvEvDmrzOVhWKzuEiyJlyA4iW4llQdncRXsOTFv8NZ4XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NF5U2F5LTSAyj0Oo5pnm+Zigdf203WVRpRZMJMmAFeU=;
 b=eeKsrWF39LM28tuAvXs/99R2J9ELRl19HZKmS8ypITQZBI9+d7OfleAVGHSk4Ps/4BQRkh7m5O/OovDKwIGO64Yoj7H2nUQvvlfHuejGVA8t1XuQKQwYe4IeOsc99jSM1WD0y5ZYJVE9TWkXzezGR9DpUeqa6DnIG1apdbrDy0lzrWGOBKpR6QGu6tcO67pISwwNpe1V5fUO+Zl2xCZo5DH6xkcpq/gsgyvJiJrlPgA11dv7mThtG33qUC7ChjzxTBghVutEIsq4v4xAUM8V+YaB9UDqirEd6Q/nFzHbQJSCIzmryjoVxkBNw5yi7r0Gz9WzA9I+L8Oy2KMNw3WL7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NF5U2F5LTSAyj0Oo5pnm+Zigdf203WVRpRZMJMmAFeU=;
 b=dG9X8AD1gz1/ciKT3zHX5fni0/baS1NNw+9Bje7zFFdjwKcMF/a1sJkHFWnONh/TdXwqEbFWZVScyH+LgPashftuFp5M6IHMk3ik9Dvx4Mp8scrdMOYzH/Mb5BhslYk5YwQoSw01cY7xcUFK8ajTqKhISl1XYuDjuTwT6q9VuhjowigFH1luZRkF5n+qC5YPDGrXi0tqRNYG50zGEy4YQ71676BrcQjaWHjUAeYjDdsWLc3FGs1F3bU5G7hTWeG/wVCetgg62F8M9apItVSJGz24BxEF2lSfCM73FyEU1zUibVy/rSfmnltY3pSUKpxhzyb0iYs7Fu4ikM0nn8vmlA==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by CH0PR02MB7914.namprd02.prod.outlook.com (2603:10b6:610:113::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.17; Tue, 23 Sep
 2025 03:32:31 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%6]) with mapi id 15.20.9137.017; Tue, 23 Sep 2025
 03:32:31 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav
 Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLOgBGqDS4wr/EWm+kbhH0rY57SfxJ+AgABfUIA=
Date: Tue, 23 Sep 2025 03:32:31 +0000
Message-ID: <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
References: <20250918162529.640943-1-jon@nutanix.com>
 <aNHE0U3qxEOniXqO@google.com>
In-Reply-To: <aNHE0U3qxEOniXqO@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|CH0PR02MB7914:EE_
x-ms-office365-filtering-correlation-id: d61f993b-5a6e-42dd-c02a-08ddfa51d43d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TTYzTzlBRXZFdXVVSlZ3ODB0K2VFaVBnd3Z2NHgrczRQSGV5SUxIblluNlVp?=
 =?utf-8?B?VXZhRkxodURGTDdOTTVuN3o0LzZOYVlETUZ4WitNbWJuRVI1c25Nenp4QWVW?=
 =?utf-8?B?ZTArQWkvcHp0L3ErNjIxRDl4QUJaeHhTTE1pQ2NKLzdxVDc0eUJ6cW1QMGRZ?=
 =?utf-8?B?UXpOWkV5a3RVbVJQN2xxZDVrKzRBMnRmaXlxTWF6d1hzWmNMWjBPcDNBSkNN?=
 =?utf-8?B?Yy9sZmxuUzZlU2sweW5EQlQ1bCtuWkQ0WVJyQTJpYUxwMmVrRFljcGdWdERk?=
 =?utf-8?B?SmRrRnFKRjFMTGpLOUlLUEFxeGVtOTBEcVJyWTZwZ1FDd1FwZU50b0Y4Qmdt?=
 =?utf-8?B?OTg3NStwRG1mU1FwaVVoWEttUEpPVVNRU3BiUFlMS1J0Z2JsME9qbFdaOFpN?=
 =?utf-8?B?ZHdzbnZFMDlTVkd3NS9oRW9sY3pwV2tFYkVuRXF3ZU5XMmlyT2FGYUdjZkNx?=
 =?utf-8?B?S1dTZE9XUjljSDkxdmluR3ZTaGs5eW9oVEV0UEFLakVoWWJ6VGxqWnNYOTg3?=
 =?utf-8?B?NGVteGQ4SHlISndZQ1drM29LWUhON29Wd1NlZDA2NmVBVmhTTUV3NVBLTDNK?=
 =?utf-8?B?WmMvUXYvbTBuaFI2WWJIT0hSTXdOWGJkRjNFRHp5SkdKMDJBcVpOTGUvM2JG?=
 =?utf-8?B?Tnh4MVB0OVptRmNLMXU1ejZheW1FTDFBV1RMckl5OVVTN2lRd1FqNk1uUmtn?=
 =?utf-8?B?M0pNMWNXSDZxRmp2Qi81RVlQT0pQbXFTd3FoY0l4YmFtQzBRMVpMVTVCTU1D?=
 =?utf-8?B?YkxVYmo1WkVHak1qbUVuZW5Ed1A5V1hZSUl5cE85VlF1TFdPbGRpdCttTWVY?=
 =?utf-8?B?WTQ2WG5zQWYwTzN3eFNyeDRSK095eE96WFpRb3ZIeTJCMXRGUHpKdnFhYnIv?=
 =?utf-8?B?OVFsT1JZVjA4WjBoaW9SRmhZY0hMbWQxYkNIZXFjdkw3UndDelFvNHpML0k3?=
 =?utf-8?B?K2puN1FlL3ZCbnp0TmpXTWtkVUVvSTVJWUIveXhsNi9YTE40WmdSenBkU0Jp?=
 =?utf-8?B?NnBzamUrSnhmc0pMR0o2VjBMN2R0MllYUFhWMlJWNWlvQ0xJTlhGWjRDNmUx?=
 =?utf-8?B?TjV2dlJ4bXNxMFAxc0dmMnBWdHlqQ2IwckdNL0tmaFRoRUxlZ3lZR0IxOU1U?=
 =?utf-8?B?RHR0SVR6ZFY5WThlNXFoZFZLYjJwNlpRSnRQM2VqUVZIVENyZ2lneGhVM25E?=
 =?utf-8?B?UjZFM2pLRk9CdkNBNThIZUxLcSsrcTRZZzZnNkdCdXFwalhpVU9PRmdneWVC?=
 =?utf-8?B?K3FuYldKcEdkYTJucUw2SkJJNXRQV0tVb2FEMjZMNEI2UG1Md1RacEV4bmhE?=
 =?utf-8?B?VkxMM0lIUmFEb3pyczZXOFg2SGFvVUU5ZmRaT1NURW45c2RSeHJ0ZVVzQnZq?=
 =?utf-8?B?L0lGWTRzZklBcFdxakFEdmF6Qk95ei9HUit2OXFSZ2dRZFNUOVVCWC9jc3pE?=
 =?utf-8?B?YjNsUy9sZElXdW1qS0daZFE1eENMMksxOVR4QWlPeW5rUmgxK3c0QUs1QWhM?=
 =?utf-8?B?ZmJkQVZHMTJMYXV1b3VhbFFJaEFXMGxaUWVLUEJwSzJ4NVB5QWZhU3VhOUxD?=
 =?utf-8?B?VVBYQjJqWXpidjhHb2hyRDA3dUg1Sno0dWV5b3NEQzZKNHFTcGR0SDd5Zmd0?=
 =?utf-8?B?ZTJQdnd2ck5wamNKTzVsSnFONSt4d3hSR0ROVXBSREJ6elI4MjF2a0tLVGtz?=
 =?utf-8?B?aWp1M1MxaXF6aGJKR1NTbE1nN2JwS2pRdzlSWjYyNDJ1YVVENEVSblJiWXU5?=
 =?utf-8?B?dGpDdkxUVnV4NWczMU5WeThPNEpCeG9ZeVZwai94NFJzV1BRTDJNTHN0dnpJ?=
 =?utf-8?B?QmlHNmthdFNwKzdQL0ZEVURrNER2aGpvT0pIVlRUaUtDOWlFaWVldG5jNlVk?=
 =?utf-8?B?NzNYRllIekZ4alltdkNrZXhFdjduM2Q3dzJqMnREWERwUjBEOXc0dktyVHU0?=
 =?utf-8?B?TWpKdFk3WnJOOFdrVENuY1p4aVhKV3FoNUxmY1ZWMTFHdHhpYTMxcHdnQXc5?=
 =?utf-8?Q?/5RF5Sf5s69vQuuD/briLnMXZ6PUk4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?V3ozTG50T2VsOHhTV0hRd01PbDg2Q1pQTzVUTDlKYnRzWC9vNVRNZUM4ZDVk?=
 =?utf-8?B?dXRMTWNaSW5DdXlrb3ZTRjRQL0ZKQ3BSNXhoeXZ1TCtZV243NUkyUlZqQjVO?=
 =?utf-8?B?cnB2aU5uUWlmaEZ3U3lRSTZ4OG4ycmNQbVdkbFZPZjhLSmtEbUVXcWw1Y2s0?=
 =?utf-8?B?WjNxaFdCSjBTNzJ1UTdIaWxISUNtN2xPQ2xEMTRyeXFGVmN3N1IydTVKaE0y?=
 =?utf-8?B?S1dGdnRVN3lsWFluMndIS2lNM2hDdmtoWFlvbll2UXlSRGRtNm90c2hFNWtP?=
 =?utf-8?B?SVdwZk16RGJBR2owbDgydkxRdUQ0ckkxSUZZSnpBL05qL1UxNC9GT3NpOU1N?=
 =?utf-8?B?L3g5ZkVhZXVNaC9rZVBLZkhaNlMzWmVrSVZGWGR4RWhVNHVmemQxL1d3b2Np?=
 =?utf-8?B?ZGF4YldiSTFEUXhGMlBnN21yYUovTitFSWtqQ0NTenlPenRMUTBEajgzWmJz?=
 =?utf-8?B?eC9aMXAvTEs2bHhUa1lXQmRiSms0YkdTeTdWWk44Wk1NVWdjOTBGS2Q5RFJR?=
 =?utf-8?B?Vk5ZZ1JiMkFnMHoyUGZ6TUhUSDZnTnowc0Q3UWc1ODdNZTNzTWt5MHZ1ZXR0?=
 =?utf-8?B?S1V4K283VWZHRDBoaXRQQVo1aStYQmp6ejNIeTBGemRocU51b1AwblpMOFc5?=
 =?utf-8?B?V1R6ZkFVWTI2ZklhYVlGNVc2bnBMZGRmR3c2aGtvM3BIazVKWURlM2IyZXdp?=
 =?utf-8?B?ekVKMHcwYkJSaS8yZmtNZWZ4bldvRi9adFcvTko1WGI0b0wrK2JaNDR4MEFy?=
 =?utf-8?B?aUprdkdGS0ppYWpCVmNwM2V6anJzaXp6OXQ3SVdqUHBMdFl5ODJNUTVDc1cy?=
 =?utf-8?B?Vmw4ekk3Y3Q2djlhTUIrZ0J4VFljcEw4VDgxbjh2SGhSQ3Q4b1BubERWbzFk?=
 =?utf-8?B?RDRKeUdnaW9jaUJTTFo0TTE4WUlBS3hWWGFQZ1pIVUc1dGdpdGdvb2JRUkN1?=
 =?utf-8?B?d29RVnAvRXJLSlFhUGhNaktaaDcxMWRtTVFIYURJUkJqVWNrYlFOQkcxTi9T?=
 =?utf-8?B?dDloUjJ5Q2dQSjA1ZEkveTV6Q1ZxdmlybDRsTkYyckxuQ1NsR3c2MFd5NU50?=
 =?utf-8?B?NEgvZWhHUXNwQ3BacGZTbkJaUU9lS3NkSThsYnZ4TGlxcFhzSVpsNC93QmFu?=
 =?utf-8?B?S2QrVmhRZU5xNU9MRFJoTHhoYWtKNkd1ZEp0NG9Ta2NmVmVRbXhrMURJR2RY?=
 =?utf-8?B?Z1dVd01jd0hXNUwyOHJpNVN0RnEydmVhN202WkNVT1Uyb1NaMk1JeVYvOHE1?=
 =?utf-8?B?K0gvWWl2YW4rSjZuWGJSbzhQekgyaSt3NjZhZlZyV2JFQXUrTy9rUEZaL3Fr?=
 =?utf-8?B?bVgwbHVwQXRxRWptRU1sWEROQlZLRzhkaUxGUzVUeUR6QjRjdnA0RUFxUWxr?=
 =?utf-8?B?bnNVOGJNY2taV3dOMEU5US9iM1hjWDA4TitSSThJQ0xvSGkzOVg1WHBYYkla?=
 =?utf-8?B?eGNvaEk4MUJZVkVOaWRuS3BFeVJjdW1tdEppa3NMNmdzRWlTc3FWbjB5QVVN?=
 =?utf-8?B?aXl6bWlXZVBWSTRaOEFRaXhmaHZuOGdKZHNXVUVHcWhZd3dXTDFDSjhvMXpy?=
 =?utf-8?B?NlhsNDk0M1ZxdTQyT1hHRkQ3U0luS1BaOVJiTzR0K1VaYXd0eWo4Ym03eWtE?=
 =?utf-8?B?Q1dBL1ZFQm1nZEVjMVV4MnovbjF2dlkzNlEyMmdMTWpjaHd4MzBEazZIOG5O?=
 =?utf-8?B?TWtvcU9yQ0dDSXprTHRoVzRab3NUMVhLd1RBdGVGSUtNbjVGQXFjc3pMNEo2?=
 =?utf-8?B?RDkrTGRmK21zTE5ERmZ1L0FMQWE2NGJuaG1kRGFvUUhRQWFvUEV3cVEzYkdE?=
 =?utf-8?B?VzBiVGxBeUV5VmxRMG5OTkpnajNuaVlQamVFMEFLcnVRT0NJcGdDeGFpTjR2?=
 =?utf-8?B?WVZIeHhEb2lCbUJNTjFnWElZVkVFSGVvaHF6eVVzRzlaV24yQWxQZGpBUGNM?=
 =?utf-8?B?ZDVvckhSZ092SzY0OTZyS09VQzJWSm1xRG9LZGkzWTcvWWFCTjZSN1NYa0tS?=
 =?utf-8?B?dldBYnozaCswVDVEQjVTdk84S0hGZjVsTlp6TWdUdDhHaVJGUzFORWhjNGtm?=
 =?utf-8?B?NENqUStrZUpMWVJwY3pibGZpenhRcUJGSE9kUDV5MEIzYXVsckY3YnRNTE5S?=
 =?utf-8?B?VGJJMTdsbCt1OEVxZ0lVQnpkMWEwVEhVQUd4enVvV3gwYk1QaDlHL2FKQzF5?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D32AD44C2E56CE4882FAAE0D5F337C0C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61f993b-5a6e-42dd-c02a-08ddfa51d43d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 03:32:31.6414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roKrLenqL4pTmHlKDFjCL8Htfy4MWQG+Cq4Wijji/VghFze9i7iLfSuMuiGbAEge5J0cZQH/2LWA4ZHuXka7ui5h2CVOI6GnG2IjVpK361Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7914
X-Authority-Analysis: v=2.4 cv=dYSA3WXe c=1 sm=1 tr=0 ts=68d214d2 cx=c_pps
 a=TRl0foosKS0XhiK7bTG47Q==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8
 a=mlmyKJN3RvQ9QNC_GxUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 1sM_pnHmSKazUMuRxasxxgBNN4waGtyw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIzMDAzMCBTYWx0ZWRfXwM8BdWi+tdZi
 0X+QL9UIFRpwT7PXZSSwuvhTtil87TCHPfNjFS1g6mwEBNjHZoe3X/TnL/Na6WSYgiwFqazXVIs
 y4bdcaXqzRXtxOt4UNItVy7CQe5e9glDIQjSadZF9Co0NJ57axCfMBzfqL2fmgBYXGgxdYhX1Zc
 volF8rGi5+LtVWTMzfzq99tFjQTOn/Ql3g9JK2HcW7neqxFPpRhE1sAQllv4YcmjdkDrYgmeA3B
 Mb+qrIARyrkCe1i/MVB/giIrcTCKoSDrs0dPPA3p/sT1Nyc3hIqm0NxiJMPvpv5UuTutP14o/dk
 tXNKpYvTx/OQFVZWeBOkmE+jB/oyZ7tOgmWtvGWPr00QnkDwwVrkNREIGeG14M=
X-Proofpoint-GUID: 1sM_pnHmSKazUMuRxasxxgBNN4waGtyw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_01,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

VGhhbmtzIGZvciB0aGUgdmVyeSBkZXRhaWxlZCByZXZpZXcuDQoNCj4gT24gMjMgU2VwIDIwMjUs
IGF0IDM6MjHigK9BTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdy
b3RlOg0KPiANCj4gRG9uJ3QgYm90aGVyIHNlbmRpbmcgYSB2MiwgYXQgbGVhc3Qgbm90IHlldC4g
IEknbGwgZm9sbG93LXVwIHdpdGggdmFyaW91cyBmb2xrcw0KPiB0byB0cnkgYW5kIGZpZ3VyZSBv
dXQgdGhlIGxlYXN0IGF3ZnVsIHdheSB0byBnZXQgb3V0IG9mIHRoaXMgbWVzcywgYW5kIHdpbGwN
Cj4gcHJvYmFibHkgcG9zdCBhIHYyIHdpdGggYSBDQVAgYW5kL29yIHF1aXJrLg0KDQpJIGFtIGhh
cHB5IHRvIGhlbHAgd2l0aCB2MiENCg0KUmVwb3J0ZWQtYnk6IEtodXNoaXQgU2hhaCA8a2h1c2hp
dC5zaGFoQG51dGFuaXguY29tPg0KVGVzdGVkLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hh
aEBudXRhbml4LmNvbT4NCg0KPiBPbiAyMyBTZXAgMjAyNSwgYXQgMzoyMeKAr0FNLCBTZWFuIENo
cmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiAvKiBSZXF1ZXN0
IGEgS1ZNIGV4aXQgdG8gaW5mb3JtIHRoZSB1c2Vyc3BhY2UgSU9BUElDLiAqLw0KPiBpZiAoaXJx
Y2hpcF9zcGxpdChhcGljLT52Y3B1LT5rdm0pKSB7DQo+ICsgLyoNCj4gKyAgKiBEb24ndCBleGl0
IHRvIHVzZXJzcGFjZSBpZiB0aGUgZ3Vlc3QgaGFzIGVuYWJsZWQgRGlyZWN0ZWQNCj4gKyAgKiBF
T0ksIGEuay5hLiBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cywgaW4gd2hpY2ggdGhlIGxvY2FsIEFQ
SUMNCj4gKyAgKiBkb2Vzbid0IGJyb2FkY2FzdCBFT0lzICh0aGUgdGhlIGd1ZXN0IG11c3QgRU9J
IHRoZSB0YXJnZXQNCj4gKyAgKiBJL08gQVBJQyhzKSBkaXJlY3RseSkuDQo+ICsgICovDQo+ICsN
Cg0KTml0OiBzbWFsbCB0eXBvIGluIHRoZSBjb21tZW50ICjigJx0aGUgdGhl4oCdKS4=

