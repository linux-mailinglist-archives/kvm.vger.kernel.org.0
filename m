Return-Path: <kvm+bounces-64821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 868F7C8CBA8
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 04:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 69F9C4E5F1A
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 03:12:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990EF2BE7B1;
	Thu, 27 Nov 2025 03:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kNcn+2sd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oQesabU5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004C52BDC2F;
	Thu, 27 Nov 2025 03:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764213154; cv=fail; b=lPPqObzPsBSC2vcQEIZu+VSg5hhslycd3dAwSx9jL0rLRsBI6sP8YpqsuiHo+SBj1sbj/+Gs2TR9kd0bp0aOh4SK4c81Ck6L0qY271Qlx39mKkS/xeHAM2wX+SsGXy4h1VeUJ/4eg8Cy4Hwz+WR1EFwlPf1MBkuF1iQmYs70M8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764213154; c=relaxed/simple;
	bh=npV/6skxKn00fGqGMr9apHNZAVI1pJfPCd5DB4CH0ZE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k2BDfkgG48a5NUMPgrMvv4+yWNSKbye+o2Idypgd8DRG/IMO7RtgNGBRjFRBAsBuG1w2eAKPxOhrnT5t9usNG+ZqIq+XiQziEsYEIozwdu0nNNU87OL1oT3RkEclV+35q0W6zuJH7qoHC++NA1uv6MB4Mh5sOYNrtJRPWWLIss4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kNcn+2sd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oQesabU5; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEYA4x1721727;
	Wed, 26 Nov 2025 19:12:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=npV/6skxKn00fGqGMr9apHNZAVI1pJfPCd5DB4CH0
	ZE=; b=kNcn+2sdM6BvNoUU3bd1KKMpjkX+r1yeYFZEbG5SS2AWsLP7GWiNlyUTY
	9am9S0jc5PFM6FoMmzPYwY6F7c50AWIuUdij3VPUuNY9Ru4U24Q5WlR4yYeDyBor
	KoR/w1B3KEkBkrQZWBFSemHrZkDSFkYFnH5g3oj/esf1Lqz0UY3NLxRhWJuDrdUY
	1GsBcsiZI3IQH/7Bp2zgbGEoXL/llppsXga+cYhQ72llSYC28I02cyHa9hI4mtRI
	aEmkzUJ+FLb99eVmHWfT130pI/48JujoUnLyD9X9gKJbEIVz8cGJfuMHauxfTVUB
	HBl7ru+uRV5af3MonLvE+61ZLAD0A==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022073.outbound.protection.outlook.com [52.101.43.73])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap3e617xj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 19:11:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEpsRbbRt9qZ5p/Z3bIytyktRqFYfbT7brL8JhAV9qkQ3Uf1uknYU0g1x10METp+8TxNeTOOYqVUsoIotEUUZyQ8qYDmNSQ0OL3AubdivZo2ItpaUL6p658QEYB6AhMiTkJzRr/+Tn8j1nYJFn+RcJdkJeFvM8iSerACmEkrDIWkL6UxpA/2a9ZAYXgnhRgisgoSJj76t4/fLbA7xLMvok8nEMLiDDTMQ9q7+vIbaHV8USZVbDkRLcZrC027U/s8xuJ5B1fJ9Wt0z2RgQhfVLyyP2Q9Tu4v2SLoUjRdqBk41h2aZ2fsTI2+76t11dWNSFVOMhRAIeh+93pu2a/jn8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=npV/6skxKn00fGqGMr9apHNZAVI1pJfPCd5DB4CH0ZE=;
 b=VTAkS5+7/y35pnilhIjOO/PjknUUbCVlVI12m71fWRwc6c9SOKKZhzmaT0iq7gJa2mnioWl8d5RuWFfIXin2k54dvJWDJdKp6I/xlSXBSAO5DCD0ylbD9F4NgXz2Yl15WaXg7fO+PNrWbxh7bXJI7yo0d7pDzYPrSO3p9aFmf23ql+sVvNSu6zvp5LkUUUVzyM6T8LU63mLTzS73/wGsIu790tUIDHh9tTTRDxXAGANZPKKpmYJdo8nmMHTHCgGVTDUpxyDk6MlYcKoZzfsqIS52QFZBXRamWKzMIr03z7DEFqHwIRKbizgeakCBZeea10TOowWS536V85KE6ttd0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npV/6skxKn00fGqGMr9apHNZAVI1pJfPCd5DB4CH0ZE=;
 b=oQesabU5+xzcXwgA9N4lMs/FgywtGsdKoNjsnPrVawZHWsf2iOI9+zxyWBpQwKH0sDOvVogZhsu6UBeZNKftamAydRVBl0WrEBkNaBMm6Y715JIS0lS3xKKRA/p4f4LfC6a/uakcUDUxUelgLMM5+NAX4O0RiNk731TGDqzZBzN9G1OX+nGDd1FwmouaKVbuDVT0A+AvDEodJG7sDwGExg96wby3m1BPKV4MtGVI0FqY3QrS7mPopcy6IWyeAhNgp6GfOyQIA/G8PoWwv4cg6IFAps4c1NO3wHtJH0oGRUQlPV4ENREnlUl8vFCLCY6tKUG6+lIoQaZiU+v9uzzrEg==
Received: from DS0PR02MB11138.namprd02.prod.outlook.com (2603:10b6:8:2f7::17)
 by SJ2PR02MB9655.namprd02.prod.outlook.com (2603:10b6:a03:544::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Thu, 27 Nov
 2025 03:11:57 +0000
Received: from DS0PR02MB11138.namprd02.prod.outlook.com
 ([fe80::b514:ca81:3eec:5b97]) by DS0PR02MB11138.namprd02.prod.outlook.com
 ([fe80::b514:ca81:3eec:5b97%6]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 03:11:57 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jason Wang <jasowang@redhat.com>
CC: Arnd Bergmann <arnd@arndb.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Sean
 Christopherson <seanjc@google.com>,
        "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni
	<alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Drew Fustini <fustini@kernel.org>
Subject: Re: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Topic: [PATCH net-next] vhost: use "checked" versions of get_user() and
 put_user()
Thread-Index:
 AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWAgAOxCQCACQYXAIAArPaAgABI5gCAAJ0GAIAAWd6AgAAiVIA=
Date: Thu, 27 Nov 2025 03:11:57 +0000
Message-ID: <5EB2ED95-0BA3-4E71-8887-2FCAF002577C@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
 <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
 <CACGkMEshKS84YBuqyEzYuuWJqUwGML4N+5Ev6owbiPHvogO=3Q@mail.gmail.com>
In-Reply-To:
 <CACGkMEshKS84YBuqyEzYuuWJqUwGML4N+5Ev6owbiPHvogO=3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR02MB11138:EE_|SJ2PR02MB9655:EE_
x-ms-office365-filtering-correlation-id: 1baedfd2-1980-44f1-eff6-08de2d62b982
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?UGg3Q2tSbVhPWGRsaXpwVmFwc1p0dFo2M25odlArWmtNUzMwOXZXTGI1REVy?=
 =?utf-8?B?T1VCOC84K2VDcWlteWo5V05JeXdmblZmRUtRV2VRSU1BNURCR2NvV3ZxYjM5?=
 =?utf-8?B?a1prRzlFa1ArTEkreDRjUWVCcUNoYUp5VlZCYTNuVm9JeXpWMkt2Slk0dmxz?=
 =?utf-8?B?dXQ3ODRpd3ZEWEVoZEJ4KzEzRzdadFJZcjloT1c0dEVVbTNpc25YQkpKUVFq?=
 =?utf-8?B?cVJyVkJqdkxWWUJuUGwzcFlNM0Q1d1h1eU05WVRzc1BPRzdBamxTMGVnN004?=
 =?utf-8?B?NkJjaUZ3TGkyT2E4Nk5GcjNkRFYwQ1Vka09XVWE3TkRqNEJaVnpsWXQ1NWtR?=
 =?utf-8?B?aUZFM3lKSXl2UlM1aVZYTGFyZmwweEtRQTdCRXl3SUdTQThnUDVXZGkzeEJp?=
 =?utf-8?B?aEUwYmpiZklINzZQaUZSSityT3VvQ1owRG9TNkk0V0ZCSHQ2S1p3UitZQlFN?=
 =?utf-8?B?Q0xNOFhVMnZ0V1IvYmFkK3JVdTVOcjVsWm8va1FJSEptYjFjNDcxWnFLeldB?=
 =?utf-8?B?dzByVEgrTENNSWE3NUhCYk9FWmNISDJNSGlVT2ttQlE0ZmJTZDkyZmhWeGtj?=
 =?utf-8?B?ZmdTK21OMW9LbDNHL1ZYcFhPQUxaUC9oQnpIaHErK0c3L2RkNENLeGNRai8w?=
 =?utf-8?B?RHdOcmd6WFFJQm1MTlZieXdtSE44TFBFUzFXWno1UnQzbVVjaFdGVFlINlBZ?=
 =?utf-8?B?cWZydndsV01VNGkvTzZwL3dnWERmeXBLZTdESytWcmc0ODV2bm9tLzdBV1Z5?=
 =?utf-8?B?RU9jVzc0WTJ6NVZoenNzMnBNeGRLWkd0Y3VxYkJmNEJrT0NoS1c0dWtTZCtl?=
 =?utf-8?B?QzNPTi9YYWJ1ZGJqMElpVHBtRGd6Nlc1ZmNqS2lUM0xpTk03ZTAwQmM2MHl1?=
 =?utf-8?B?M21WbFEzWHVTSStyL29YQ1MyM1hFZGdjajZ6cUppQWwrOU11bHV1Z0VHTHZV?=
 =?utf-8?B?UVdYeDNoRnZOVDgwVzA5K1ZkTFFNdzJQcjhNbXA1N2s2ZUx1Tzgya1d5Z1Ro?=
 =?utf-8?B?M1ZkU1AzbnllTU9IQWg1bmJ4L1JwUWVJN1RGYnp5N09ibFoxT2NEaTFEdWZh?=
 =?utf-8?B?eDRPL0dsdjQzbGlpdU9IdnlIT2ZwaDViME9nWVdySTU5cnpRTklqU0Vub2pv?=
 =?utf-8?B?YVhyNGdqWVk1K2FNSG5GRlpCa3dLcXNXcUFrNUxnekxtTU0rZjR2NlhjTWU5?=
 =?utf-8?B?ME1YWXJvKzhLY0RjQ0oxQXA4RDM3RFA2bXhHa2x0WTFXU1IvYWhGcHpuaGF2?=
 =?utf-8?B?Tk5yQjByZzhLUGNINnkvR3dnUEUxNWRJVGJCLzRjQzU1blVUVGRBUzltV2h4?=
 =?utf-8?B?c2JtWDdlV0ZNU2x5YnNuNHVBNGU3OXpZMHdSeTQ3bWxkblVVVGpnUU01OUVW?=
 =?utf-8?B?dlEzYmVrN1o4VWNRTmltQWxEdExMZmN1dEpsNWNacXlvc1Y1RjhQNWsrc2tB?=
 =?utf-8?B?cUdQTllHR3FVTy9kRTMvSkZ5L0wzNVdRM0hkdjRMenFYMll2clg0ZXI3ZEx2?=
 =?utf-8?B?NnhMYlQvcWRQS29RM05IZUkwK0lDdVJ3VEpsZEo0bFBUajdGc1FRS0NMaXR0?=
 =?utf-8?B?eFJlcGxESVY4VEhYWGRkU2c2bHdoWTh5NHRiVnQ4TE9MdFFJM01iWkM2b0Vj?=
 =?utf-8?B?M1V5VzRETmp4bEgrd2tZdHoyNllFeis2RkZzd3RpQnNUN2lrVmtWc21TUHZX?=
 =?utf-8?B?Z2J0cHdicTljcUNiZWxiK3NnYUZsa3V1elZvR2hua1FJc0ZVZTVHYURuRFZn?=
 =?utf-8?B?am9vck1UZTIxbjFBVjRJMlYrZk1EZEJhYlFVWVBQSU5hZTljZVhpZ0QxN3V2?=
 =?utf-8?B?Yi9EYi9veCtNdFRvK0F2SE5NODFtZ1ZKVzdvZFBMMm9kdnNVekp0dEl0OWho?=
 =?utf-8?B?akJNdFdRaFF6UGFFRUlMcWxNRGRGT2R3T05DT2FIbVlEeTBhbTBVN3BWREdB?=
 =?utf-8?B?Vm5hUTJKMUxsNWdsZUxtYThQN1dLSm9rU09UR3pzVVZCNkhlY0NHaWkrSG50?=
 =?utf-8?B?U3pIZmR5Qm1xMmZ4RCtScWR1bURCdjNpYUpCenR6ZnFzSVN4SURCYWoxQ1FN?=
 =?utf-8?Q?2q9h6q?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR02MB11138.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TnJFSHdwK2VWRnhnWVVuMHNRZVM3cXhGdjNRQW0xOHhMVzYwRG5ZcXNUaFlM?=
 =?utf-8?B?OWIya09YeG8xbmdwQXdSWW1oU2Zqd0FNRlVpMjFHUG5TWmRZbE4wK1g0OVVR?=
 =?utf-8?B?M3ZxRldieWpVRmxXblFlc2trRERQeitBdlowMmZ5UC9wM044SEprdWZndkdM?=
 =?utf-8?B?b0psZ24wb3VFWUptRFpFYU1aNnZ5eDFydDlPM2xBbXd6bnViQ1pQUTZkcy9L?=
 =?utf-8?B?SW9pbnBiN3o0M3U3MUJzVU9BTHBZOHNLQks1Mis2Znd1VkRYaEdjbGVBYm5k?=
 =?utf-8?B?ZXQzTWpibTF6RWZzUWdFZXAzQ0ZMcVhQQU5ZeEs5dWw2ZjA2OTczVHNpK0dw?=
 =?utf-8?B?eVU2L3Q1VityamtDVkh0ZVY2dHU1N1hpRVl3RmRXVldRaVJJbXN5Uk82RTlj?=
 =?utf-8?B?MGJyTS85U21WKzRrVWoxMm9FcFRkK2ROUlN3enpFbjBXRVUwZHkwUnpZeGYy?=
 =?utf-8?B?NWJNcmxiY3lhVWVEUWZlc2RPVzF0TUVDb0F0Y1BRTlF6VmxhSkhxRnRBRnhw?=
 =?utf-8?B?RGw5WThaY0VsdVBmODM4aTRsS29uRCtGWlBselB5NUFDQm0xZXZSWEJxdi9V?=
 =?utf-8?B?OG4xWExxelhqTEcweXhVZ2ptdWdrK20xcG5rbnF6elJZRFVyT1BzdzJ2TytS?=
 =?utf-8?B?bEFreDlobXh0QnBKK2pRODQxaGxUUS9TZmxVbTEvZlp5eVl5UmNER0NMUEFV?=
 =?utf-8?B?WjZmbHF5cnROYnloR2xXZ0ZxQmsrRWtJc1d2cURFamhBMENGZUtrMGJXVERN?=
 =?utf-8?B?WllHODVrYzMrRnAxTHFhTitSSlROSXRsYko2SUVGUEt2UW1UTWdQeWdtN2J3?=
 =?utf-8?B?NThSL0dLTjBOVG12NUJheVcxNVNCZ0hrQkU4eUVmcnhGaGVNYkxIRzZiUCtk?=
 =?utf-8?B?ZE8vWWUwc0pSMlM1a1JwRFVWTGcraCtVeUIxMUJ0cFYxWHlHT0hLelEvV1Jz?=
 =?utf-8?B?UlNoZlVYZWpDY2tzMG5rYmhzbEZubHd1MlZxN0oyZC9kS0swZmJIRjBnOFpC?=
 =?utf-8?B?N0Y1V3J0WWlWTHQzdXRWbkJRSHBkQmMyN1Q3YWtjaEhQKzE2VjhadkgwYjR0?=
 =?utf-8?B?ejM3YjhZd21ZckhkQlpsYWEreDQweHZwcjlNVkhhbzR3eWFIVDIzYkgyTm5B?=
 =?utf-8?B?am04a3o4b2IrSVY5K2hzbFdtUGh6ZkpJczNLbHIvMzBBTklESWpVL3lsdWRE?=
 =?utf-8?B?SndrVGZRYXl3WkU1Yk9VUjU4S2FSbFoySkY4SXFEdU1xVmxZcTdBQnBBUVlq?=
 =?utf-8?B?WUtBa2xtekJtbGZ2VzBiek1VaEw2ZGZkRkZUanNWVm9pZ1dYaDROZE1Cd2tj?=
 =?utf-8?B?ajJkaXM0aGZ0YzF2bnNtbGovMzdxQlFHQWtlZ0VZQnRNd2NQRzBuaUt0RXNC?=
 =?utf-8?B?WVh1U1o0UlM0dmw0alduMVFEbUNoSGp1Tm9hWE5rWFFNdUYyRjh2K2xZOHpn?=
 =?utf-8?B?K01ZeTVaNEpUUGZWRHFVVkk3Ty9kSlhtWk5BT0JpTWNoMzVRckVzaGM4VkpE?=
 =?utf-8?B?enRaVGdQc2kvVkZ0WWJqL3o4azlTVkc3MDR0K0Y4WlpsQUZabW9oODNyVi9z?=
 =?utf-8?B?dHl6ekxHK3JMVkJTbld2TW9PcTZHWjExSWkwWk1NK3E3OG9rRmJCWVR5RGJp?=
 =?utf-8?B?MkhVWjNmU3NxeUZWSExoQzlmUEN0dnVtdlNhZkNhLzJTQUZKTjVIWUY1dzda?=
 =?utf-8?B?U1N3MGxjOFkzZGFiVzdCVFU1elVYeGVrUUQxSWI0bURrSGhrLzNVUjZOc0k0?=
 =?utf-8?B?S04vOHJrempjR0xmSkYzN25JYmtlWjFWa2dKQWgvUkl5SjRWbVhsbExKeWxG?=
 =?utf-8?B?MW01RHhjNHYzWDlpbVJVT0FsL1BDVVQ0b0tZSXg3MTR4V1hweXQ0ZjNFK3dN?=
 =?utf-8?B?MklZckZtRm9TU0srOVRmekZnUGpyNHk0N21YTk9xakw3dlE1YUZnNUI4SkRB?=
 =?utf-8?B?RDMrSDNpNjJTM0tXcUE2dkpQR3VIOC8zVDl2ckdQY3owU09wM0JJQ3NCS1lO?=
 =?utf-8?B?SHJCNXFYdGw5WnlxeGNCRVBoeFFEK3ZnWEdjNkdDelkrMzBxbE1acU9jSEdT?=
 =?utf-8?B?Y1A5VmxSRXliUUhBWmNRNDYxV2tWSjRROGd6dDBQNFVEc3YwSzZJcnlaOGQ1?=
 =?utf-8?B?S2NWTDVNYXNLTEt2WXc1MXAzUzZBRitjYVFLMDU5Z2ZQK0ViT2hyYTBPeFln?=
 =?utf-8?B?cnVRQ2ZEMzZ5YUNNNjhoMGp5VU10MFRFR0hvN1hRYzlycSsraHBuK2c3SEd6?=
 =?utf-8?B?UzRoRXhibUFnbjVwY3BpSEMrV3dRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05BB821383FB3A43B5D7E3C45C2299B4@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR02MB11138.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1baedfd2-1980-44f1-eff6-08de2d62b982
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2025 03:11:57.5320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lotitRAU2ZbhWTMO5G0KUbhW3mwHKyxBdemyzeJ9cW5uB4wQGD6mkcPryp3uo9vRN1fQG/GcnJdp+IMg+FSmaFQwinA2lRm1GAMwMwImJvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB9655
X-Proofpoint-GUID: BYXYlCPuMvRANC7MrSJTWFRuI9icevct
X-Proofpoint-ORIG-GUID: BYXYlCPuMvRANC7MrSJTWFRuI9icevct
X-Authority-Analysis: v=2.4 cv=cZffb3DM c=1 sm=1 tr=0 ts=6927c17f cx=c_pps
 a=rss2Ezl/rPWt8HBHL2MHqw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=57ujviyFHw0yrHEfyZIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDAyMyBTYWx0ZWRfX1tMfRzIyp97l
 Pr+XA+qN+6pbC5D9sAHAvjbo2k3X4EnBacoAWvp7pyi0sGngUcIOO1CH4l8Vr8xFmUjK7qsSBc8
 aCcZTOgivTBEt6ez5gHUCTRGvmLGRX/6rj/yJfjLl14QSpeQWZT1RvoeU08YNBwWdliVxRsroze
 H+v7GNyLpGrTYXBd3HOE3pg/SpnWeO4PqAxnBV9+Oy/vMU5X/dSyy4Tc3sL3//MY69SDQ1DUKlD
 3EU+0vjjaWkgl1k82pHGlMxjxrniebd05Au1i+WyLFGEbyL62wLD529VyT7jeGpxLwq8xDNreMh
 cxZGyeR3Twv7k0HawzQCqIbEPgoVQ9Sspl5NUF5ikA0QnugjI30K/CVAtmLURqyDPiOPVDrn4xg
 Xxo4ePIamPNnO1UyFacDXxi04piCwQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCA4OjA44oCvUE0sIEphc29uIFdhbmcgPGphc293YW5n
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1LCBOb3YgMjcsIDIwMjUgYXQgMzo0OOKA
r0FNIEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+PiANCj4+IA0KPj4+IE9u
IE5vdiAyNiwgMjAyNSwgYXQgNToyNeKAr0FNLCBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRl
PiB3cm90ZToNCj4+PiANCj4+PiBPbiBXZWQsIE5vdiAyNiwgMjAyNSwgYXQgMDc6MDQsIEphc29u
IFdhbmcgd3JvdGU6DQo+Pj4+IE9uIFdlZCwgTm92IDI2LCAyMDI1IGF0IDM6NDXigK9BTSBKb24g
S29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3RlOg0KPj4+Pj4+IE9uIE5vdiAxOSwgMjAyNSwg
YXQgODo1N+KAr1BNLCBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPiB3cm90ZToNCj4+
Pj4+PiBPbiBUdWUsIE5vdiAxOCwgMjAyNSBhdCAxOjM14oCvQU0gSm9uIEtvaGxlciA8am9uQG51
dGFuaXguY29tPiB3cm90ZToNCj4+Pj4+IFNhbWUgZGVhbCBnb2VzIGZvciBfX3B1dF91c2VyKCkg
dnMgcHV0X3VzZXIgYnkgd2F5IG9mIGNvbW1pdA0KPj4+Pj4gZTNhYTYyNDM0MzRmICgiQVJNOiA4
Nzk1LzE6IHNwZWN0cmUtdjEuMTogdXNlIHB1dF91c2VyKCkgZm9yIF9fcHV0X3VzZXIoKeKAnSkN
Cj4+Pj4+IA0KPj4+Pj4gTG9va2luZyBhdCBhcmNoL2FybS9tbS9LY29uZmlnLCB0aGVyZSBhcmUg
YSB2YXJpZXR5IG9mIHNjZW5hcmlvcw0KPj4+Pj4gd2hlcmUgQ09ORklHX0NQVV9TUEVDVFJFIHdp
bGwgYmUgZW5hYmxlZCBhdXRvbWFnaWNhbGx5LiBMb29raW5nIGF0DQo+Pj4+PiBjb21taXQgMjUy
MzA5YWRjODFmICgiQVJNOiBNYWtlIENPTkZJR19DUFVfVjcgdmFsaWQgZm9yIDMyYml0IEFSTXY4
IGltcGxlbWVudGF0aW9ucyIpDQo+Pj4+PiBpdCBzYXlzIHRoYXQgIkFSTXY4IGlzIGEgc3VwZXJz
ZXQgb2YgQVJNdjciLCBzbyBJ4oCZZCBndWVzcyB0aGF0IGp1c3QNCj4+Pj4+IGFib3V0IGV2ZXJ5
dGhpbmcgQVJNIHdvdWxkIGluY2x1ZGUgdGhpcyBieSBkZWZhdWx0Pw0KPj4+IA0KPj4+IEkgdGhp
bmsgdGhlIG1vcmUgcmVsZXZhbnQgY29tbWl0IGlzIGZvciA2NC1iaXQgQXJtIGhlcmUsIGJ1dCB0
aGlzIGRvZXMNCj4+PiB0aGUgc2FtZSB0aGluZywgc2VlIDg0NjI0MDg3ZGQ3ZSAoImFybTY0OiB1
YWNjZXNzOiBEb24ndCBib3RoZXINCj4+PiBlbGlkaW5nIGFjY2Vzc19vayBjaGVja3MgaW4gX197
Z2V0LCBwdXR9X3VzZXIiKS4NCj4+IA0KPj4gQWghIFJpZ2h0LCB0aGlzIGlzIGRlZmluaXRlbHkg
dGhlIGltcG9ydGFudCBiaXQsIGFzIGl0IG1ha2VzIGl0DQo+PiBjcnlzdGFsIGNsZWFyIHRoYXQg
dGhlc2UgYXJlIGV4YWN0bHkgdGhlIHNhbWUgdGhpbmcuIFRoZSBjdXJyZW50DQo+PiBjb2RlIGlz
Og0KPj4gI2RlZmluZSBnZXRfdXNlciAgICAgICAgX19nZXRfdXNlcg0KPj4gI2RlZmluZSBwdXRf
dXNlciAgICAgICAgX19wdXRfdXNlcg0KPj4gDQo+PiBTbywgdGhpcyBwYXRjaCBjaGFuZ2luZyBm
cm9tIF9fKiB0byByZWd1bGFyIHZlcnNpb25zIGlzIGEgbm8tb3ANCj4+IG9uIGFybSBzaWRlIG9m
IHRoZSBob3VzZSwgeWVhPw0KPj4gDQo+Pj4gSSB3b3VsZCB0aGluayB0aGF0IGlmIHdlIGNoYW5n
ZSB0aGUgX19nZXRfdXNlcigpIHRvIGdldF91c2VyKCkNCj4+PiBpbiB0aGlzIGRyaXZlciwgdGhl
IHNhbWUgc2hvdWxkIGJlIGRvbmUgZm9yIHRoZQ0KPj4+IF9fY29weV97ZnJvbSx0b31fdXNlcigp
LCB3aGljaCBzaW1pbGFybHkgc2tpcHMgdGhlIGFjY2Vzc19vaygpDQo+Pj4gY2hlY2sgYnV0IG5v
dCB0aGUgUEFOL1NNQVAgaGFuZGxpbmcuDQo+PiANCj4+IFBlcmhhcHMsIHRoYXRzIGEgZ29vZCBj
YWxsIG91dC4gSeKAmWQgZmlsZSB0aGF0IHVuZGVyIG9uZSBiYXR0bGUNCj4+IGF0IGEgdGltZS4g
TGV04oCZcyBnZXQgZ2V0L3B1dCB1c2VyIGR1c3RlZCBmaXJzdCwgdGhlbiBnbyBkb3duDQo+PiB0
aGF0IHJvYWQ/DQo+PiANCj4+PiBJbiBnZW5lcmFsLCB0aGUgYWNjZXNzX29rKCkvX19nZXRfdXNl
cigpL19fY29weV9mcm9tX3VzZXIoKQ0KPj4+IHBhdHRlcm4gaXNuJ3QgcmVhbGx5IGhlbHBmdWwg
YW55IG1vcmUsIGFzIExpbnVzIGFscmVhZHkNCj4+PiBleHBsYWluZWQuIEkgY2FuJ3QgdGVsbCBm
cm9tIHRoZSB2aG9zdCBkcml2ZXIgY29kZSB3aGV0aGVyDQo+Pj4gd2UgY2FuIGp1c3QgZHJvcCB0
aGUgYWNjZXNzX29rKCkgaGVyZSBhbmQgdXNlIHRoZSBwbGFpbg0KPj4+IGdldF91c2VyKCkvY29w
eV9mcm9tX3VzZXIoKSwgb3IgaWYgaXQgbWFrZXMgc2Vuc2UgdG8gbW92ZQ0KPj4+IHRvIHRoZSBu
ZXdlciB1c2VyX2FjY2Vzc19iZWdpbigpL3Vuc2FmZV9nZXRfdXNlcigpLw0KPj4+IHVuc2FmZV9j
b3B5X2Zyb21fdXNlcigpL3VzZXJfYWNjZXNzX2VuZCgpIGFuZCB0cnkgb3B0aW1pemUNCj4+PiBv
dXQgYSBmZXcgUEFOL1NNQVAgZmxpcHMgaW4gdGhlIHByb2Nlc3MuDQo+IA0KPiBSaWdodCwgYWNj
b3JkaW5nIHRvIG15IHRlc3RpbmcgaW4gdGhlIHBhc3QsIFBBTi9TTUFQIGlzIGEga2lsbGVyIGZv
cg0KPiBzbWFsbCBwYWNrZXQgcGVyZm9ybWFuY2UgKFBQUykuDQoNCkZvciBzdXJlLCBldmVyeSBs
aXR0bGUgYml0IGhlbHBzIGFsb25nIHRoYXQgcGF0aA0KDQo+IA0KPj4gDQo+PiBJbiBnZW5lcmFs
LCBJIHRoaW5rIHRoZXJlIGFyZSBhIGZldyBzcG90cyB3aGVyZSB3ZSBtaWdodCBiZQ0KPj4gYWJs
ZSB0byBvcHRpbWl6ZSAodmhvc3RfZ2V0X3ZxX2Rlc2MgcGVyaGFwcz8pIGFzIHRoYXQgZ2V0cw0K
Pj4gY2FsbGVkIHF1aXRlIGEgYml0IGFuZCBJSVJDIHRoZXJlIGFyZSBhdCBsZWFzdCB0d28gZmxp
cHMNCj4+IGluIHRoZXJlIHRoYXQgcGVyaGFwcyB3ZSBjb3VsZCBlbGlkZSB0byBvbmU/IEFuIGlu
dmVzdGlnYXRpb24NCj4+IGZvciBhbm90aGVyIGRheSBJIHRoaW5rLg0KPiANCj4gRGlkIHlvdSBt
ZWFuIHRyeWluZyB0byByZWFkIGRlc2NyaXB0b3JzIGluIGEgYmF0Y2gsIHRoYXQgd291bGQgYmUN
Cj4gYmV0dGVyIGFuZCB3aXRoIElOX09SREVSIGl0IHdvdWxkIGJlIGV2ZW4gZmFzdGVyIGFzIGEg
c2luZ2xlIChhdCBtb3N0DQo+IHR3bykgY29weV9mcm9tX3VzZXIoKSBtaWdodCB3b3JrICh3aXRo
b3V0IHRoZSBuZWVkIHRvIHVzZQ0KPiB1c2VyX2FjY2Vzc19iZWdpbigpL3VzZXJfYWNjZXNzX2Vu
ZCgpLg0KDQpZZXAuIEkgaGF2ZW7igJl0IGZ1bGx5IHRob3VnaHQgdGhyb3VnaCBpdCwganVzdCBh
IGRyaXZlLWJ5IGlkZWENCmZyb20gbG9va2luZyBhdCBjb2RlIGZvciB0aGUgcmVjZW50IHdvcmsg
SeKAmXZlIGJlZW4gZG9pbmcsIGp1c3QNCnNjcmF0Y2hpbmcgbXkgaGVhZCB0aGlua2luZyB0aGVy
ZSAqbXVzdCogYmUgc29tZXRoaW5nIHdlIGNhbiBkbw0KYmV0dGVyIHRoZXJlLg0KDQpCYXNpY2Fs
bHkgb24gdGhlIGdldCByeC90eCBidWZzIHBhdGggYXMgd2VsbCBhcyB0aGUNCnZob3N0X2FkZF91
c2VkX2FuZF9zaWduYWxfbiBwYXRoLCBJIHRoaW5rIHdlIGNvdWxkIGNsdXN0ZXIgdG9nZXRoZXIN
CnNvbWUgb2YgdGhlIGdldC9wdXQgdXNlcnMgYW5kIGNvcHkgdG8vZnJvbeKAmXMuIFdvdWxkIHRh
a2Ugc29tZQ0KbWFzc2FnaW5nLCBidXQgSSB0aGluayB0aGVyZSBpcyBzb21ldGhpbmcgdGhlcmUu
DQoNCj4+IA0KPj4gQW55aG93LCB3aXRoIHRoaXMgaW5mbyAtIEphc29uIC0gaXMgdGhlcmUgYW55
dGhpbmcgZWxzZSB5b3UNCj4+IGNhbiB0aGluayBvZiB0aGF0IHdlIHdhbnQgdG8gZG91YmxlIGNs
aWNrIG9uPw0KPiANCj4gTm9wZS4NCj4gDQo+IFRoYW5rcw0KDQpPayB0aGFua3MuIFBlcmhhcHMg
d2UgY2FuIGxhbmQgdGhpcyBpbiBuZXh0IGFuZCBsZXQgaXQgc29hayBpbiwNCnRob3VnaCwga25v
Y2sgb24gd29vZCwgSSBkb27igJl0IHRoaW5rIHRoZXJlIHdpbGwgYmUgZmFsbG91dA0KKGZhbW91
cyBsYXN0IHdvcmRzISkgPw0KDQo=

