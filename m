Return-Path: <kvm+bounces-67690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B74EFD1078A
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 04:24:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F0C2307E955
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3010430BBB8;
	Mon, 12 Jan 2026 03:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PywnBrnD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bXcbTzcH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A636323BCEE;
	Mon, 12 Jan 2026 03:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768188205; cv=fail; b=oChPoGHozYqWRGrXaWz88W+EFK5kO/kqH9obaXmsbT6A/4Yo7JfSMIjrkqoDxY20h7vfePmicDeobEkellTSWSkGWi/M09koNeInViAi8gYBir72+Sd7iUruUyHUY6PTGUccxjGroTReH5UCDwTaC/seRZd7zkBMvA+CGhgJsx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768188205; c=relaxed/simple;
	bh=JejgKoG/c1CS0QPWEcyeH3eQsMoscNRrhrdPM3iVY24=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jJxN8Ccj0QXiJCXDECck1ctNZVeKMcsrO/iTH+7qRXGHhY1Xp/nmomPIKwJb9cYATHexUXde8ADnSAoJWdJz3vIYE4bdYP1V/YJVhtMLQUD2ntjSpf437TSjSse32jZmSewvtA+0pYWRgqpYRvoTPDlqDgXiCVV/dKYT8dVz3XI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PywnBrnD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bXcbTzcH; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C001Pd2272924;
	Sun, 11 Jan 2026 19:22:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=JejgKoG/c1CS0QPWEcyeH3eQsMoscNRrhrdPM3iVY
	24=; b=PywnBrnD1+4VUIpLFWjC4JpKeZd6rmUxpMkRv/RewDcH0KAZ61I0DVmFx
	rkz1Qmv6lKSY3mhy4/1fik0NbQK3rTmcUvFZ9jSLy6ZVEFDBuTKnNlNxqd7hpSly
	yZ8+1HFAzzm3u6PuzYrPGsT2gnz7U90sbLs+DNNjqZtbKtU+Lue+rg26xkmu3br1
	1oLJs10Y/ul5VHDKA/cdujvHECU6u68Xl5anDpBBa12WtGYguQJwHTu8WwRS/Ja7
	9fAj6a/I1h7e1R++gA3n76+AQXCb7Omq2i4ZMABBZt/NAa15j/foZ526Lc6kB0h8
	oihqcejopSjNcec7zr/Zz5U58SFsg==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022127.outbound.protection.outlook.com [40.107.200.127])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bkq62sy5t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 11 Jan 2026 19:22:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ANQoYkydN3RJ9I2wIqaVVrIQtCVymBiJUjxYV92kQa1kz7CDfjb+zwCB/7ULLb5b7fJFH/RurIBFUxv/Efguilj7k3utFHOo9H2X9oYt1Cl95HDvjj4JOeWQqeF/oI842ypKkoz6jQv22G5JYVQoOWTtKZKIptJzEHJ3CsGveJkN9vxoUrI1rcYTPxUnRcFacrFfx0nurzKcYts4cQLzyyNpAMzhjhoaQfQm5/c1IpXaron2+086URdRffXAYeBkz/vfX4JGcL8eUdlArHtp0TbCj9//TdfV5NlGA75gxBuOXlUr4bKvkVvJe/vryaG1dU5G847og5wFZ945S2AtaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JejgKoG/c1CS0QPWEcyeH3eQsMoscNRrhrdPM3iVY24=;
 b=PT0Msk0qTVK+So8jAMn/UzmI+Zadgtuszpn0a54qY//+Es2XB720qVs8MEj6IcfC5/o9z+WCnCQynfAeHH0Hpz/m/oEvZGoS+aoO+497Ur7mH2dsYxIW4w1mpKis4vWlh0WHW0EyFviVfHzyR1Cfs8QhVLLfC72y0ji4UIfgOWZz7NHX/uIZQ+gFIPdGoo686xZ28H/MD3tQyCrsudFYTFP4/p+gKb9nVX2xmx78aXuqthttpjRH+e1y0X48f/YjqIDrK66+2OzLXH0YYMq0nS8sDo8E8p4KfD5yAUslV5ipnuJ20Ezh6532wDNOFLu5UVM4nfLTKvb1UO7elHeK4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JejgKoG/c1CS0QPWEcyeH3eQsMoscNRrhrdPM3iVY24=;
 b=bXcbTzcHxnxz3V4QZpP9vbYj0tTCu47gMDP/28AgX+PGmrVM5fH1dzmvWLJsnF6Ea9M7y5QT1+1WmGGGONpBgGH88nZREurlzsJKC9mI6195jdq4O3fTNQRL/jymSDYU138QvVgeNnyOufKwau2WdEfc35a1PKLmVct0xEZQJPsGYgqrb71bpQV022nd+Fu2UHNc1aiPi4PZ7oeiqiXxZiAXKw7ZP9DteDUnUdPe7oConn3oS7lc1kS6UFSUWmHY+lbvUB2SL8Cdf4QynzxO3owxmjnXHUlLON0cWU1BVInQ8xNI1NEhD/bsEzmkqZRSA/mhuquOw0VYceBaXcfPtQ==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB10132.namprd02.prod.outlook.com (2603:10b6:610:198::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Mon, 12 Jan
 2026 03:22:11 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:22:11 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Topic: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Index:
 AQHceLTEKfxcrcgmBUCGXzBVU4MWXbU4fimAgAALkYCAAAtAgIAAJdKAgAAFdACAAAXugIAGTxmAgA7eioA=
Date: Mon, 12 Jan 2026 03:22:11 +0000
Message-ID: <77E50A19-3DFD-44E9-B4CB-5656AC1078C0@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-3-khushit.shah@nutanix.com>
 <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
 <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com>
 <9a04f3dda43aa50e2a160ccfd57d0d4f168b3dce.camel@infradead.org>
 <BE16B024-0BE6-46B4-A1B4-7B2F00E4107B@nutanix.com>
 <D6CA802E-F7E0-410D-87FB-6E6E5897460E@infradead.org>
 <02B570C0-BEF5-439C-A081-9537489A7FF7@nutanix.com>
 <69c98d8e34fadd14152d625956c3371e8dbb1c76.camel@infradead.org>
In-Reply-To: <69c98d8e34fadd14152d625956c3371e8dbb1c76.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB10132:EE_
x-ms-office365-filtering-correlation-id: 87bd4ee5-d6ed-4d82-4bbb-08de5189c6a8
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Vkt2ekJFTkx6Z1RRZnl2blB1WThqV2x3VUVxVkJLbFRMR29EeUUvWW1Tbys1?=
 =?utf-8?B?aHJrL09QYjJCWGxtK3NKRkpaK1pTRm40eVg1c0hIZHBxazF6R09QQ3cycndI?=
 =?utf-8?B?bjJZQVgzTWNWekNQY0FFWTk4azlLWWJQWlBNMXBrcjA5SG5QUjMxWU9qallq?=
 =?utf-8?B?c3E3UlJETHhkcWlMWVhnbTJMZ1pBNzNNeFgyRGhHRXJlSE1ENk9UazczRmJF?=
 =?utf-8?B?RHlNVXExempEdE5pWSsrTHV5Z3p4amlTWU5HdU1Yd0ZOSzJNd1psbkVxRVVR?=
 =?utf-8?B?UnZqLzV1TnhveGF5azZNcFI1T01HTDRYOGtPRTRmZlpiV1NoWFdJWDdTNFQv?=
 =?utf-8?B?Y2Q5c3ViNnFJblBWcXpFeU9Xem5KZlVOMXNMdTNTMWM5MjJwd0U5Nm5jQlEz?=
 =?utf-8?B?WVU1V1Arak54UnBwRHBielNQYUdZaTEwL2tjL3M1UWdaWEJwa0FveituNWpi?=
 =?utf-8?B?dUQyaXVwaDd4SW52RllnMk1ZWDNiS0VPcjYzS09tQmlzS2hnWEUyaHpkeVZD?=
 =?utf-8?B?NnpyVVplY1g3SDRESm8wTVAzZHk2L3ZjL2dGVkVWNlNZT1NsNW45NVpFTjVK?=
 =?utf-8?B?QllZV1BqWEczUmRkRHNVcEZaVXI1amxuRk4xZVJWL1pJWmI0L2kzN0lwcnJU?=
 =?utf-8?B?OFVLRVdKei9LejVFWEFBaGUxcGlFK240MVZTbEdLWFhEZ1F6VUk0dy9ZK2wy?=
 =?utf-8?B?MnZYRGhTOGxTU3VITjRCY08zSzZaTkFuOUdGUjFHMGc3MExjT2VmaUJRMDF1?=
 =?utf-8?B?bHNjcUtUNStacUM0NkI4V0tFcnlHaUFsOEZDdUpnMFBGYUgxSE4ydUJ1cmo2?=
 =?utf-8?B?Sit6ZFZ1U0piYktHYXBrZkhjNUFESzRmR1FJTEc2cUQ3d3pSZmRHWHhaSUJN?=
 =?utf-8?B?djlEYVlwaG1FMTJsQUhkUWIyRUdEYVp4RXZWQTdvYktZYndKVjc0QTl2NVhJ?=
 =?utf-8?B?czFSNU16UHdnTVdyQkYyZmpzTXJnbmsxdkFzRkk2UnRMYWUyVGQvWTJLU1I0?=
 =?utf-8?B?WVlaTmhYdzY3VnM3Z2NsTncwWmRrTmJVUWRFNjdidmRqL1lOR2hkdzNQVm1t?=
 =?utf-8?B?MHFaaURoU0M3eEFOSXY2TElJYVhkbWorL1YzSU1mQWxTaTI3U0pnMTVzckZv?=
 =?utf-8?B?cTBScjhuSmNHZVRoak5ua0NiR0VHbElyME15VEk5YndCR3ZYaUpJSXRId0ho?=
 =?utf-8?B?SFFRWGd1Sm4vRmlSV1pKcWlmSExjK2owdWtTSWk5NjFjanMzbHM0OXFpeVd0?=
 =?utf-8?B?ZUhqcUVQNXJ3WHBSclN1U0xTVVhqb0tjbG4rTEc0M01FdEFQbXdrb1pHZUI4?=
 =?utf-8?B?MHlMR01lZWU5ZGZCQmlEd0IzcFFRODhkTXlpVTlTeXByaW1oVWNHdzFDRm8v?=
 =?utf-8?B?RmkvSE8ybnVVc3liWFVBTmVoUmMxT3FtbytJeWRHN0FQUEhvVjNSdC9QUVIw?=
 =?utf-8?B?RWNISlEyTHVrVnUzb0xBcmlwSmt5TXdsTmYyRGQ5Q1dQcko2aEtBaWVXclpR?=
 =?utf-8?B?ZXRhL3pPTUkrWTVuckxQMlNYN3U0WEEyQXBrdFFlWjlJYW1POFRhQm80T1NS?=
 =?utf-8?B?Sk5QMTEvL3JENmNWK2NEYWNSWVZWMS9NSVgxdVJTbTVTeG1qUkh6U1EzYU5T?=
 =?utf-8?B?TDNjUlczN2lHZjJ4NG9VR09SZnB3VUJuRFB5K1ZDVmZqOFFVWmYrWFhIRVU5?=
 =?utf-8?B?YlJveHliMDFteThiMWVRL1pqWWhTY2VBR1lhZ0FMOE5zR1hkVnVSWmZMWHc2?=
 =?utf-8?B?UkdnUk9pODRDUHc5aXdYekJuL1lnVFQwRFU4YXdEemh5NXJQZHE2OFVQZVpy?=
 =?utf-8?B?NHRBSE5Jc01JckhTVHZmb3MvQ3NqanJwcnhzUFZPZ0JJUmxMNEdlTHB1ZXN1?=
 =?utf-8?B?bkZtdEt6WWVtRHBlcERaaDFFQUlPekdGUVB6LzR0VDI5azRFZkJHTk81dXdm?=
 =?utf-8?B?blg1N0JPcG9VaU9Jd0w1TWxRMUxmSGJWUlY4SnNWbnZmamlJcWFmYkJpMVVT?=
 =?utf-8?B?ZUhrQmJvZGNXeUlxVmNsR2FRbWFVTVZvVGI0REdrczhHLy83b1NBdXNNVGFW?=
 =?utf-8?Q?Fw0cSy?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K2JFbkdjRVpzM2tVTHp4emtwSlBzdnlnOTVRdVUwdVBvd1Y4QnExQkg4MHdZ?=
 =?utf-8?B?M1ZPQWExdlcyMWwwV1BOYUI0eitmaWZSVHg1Z2srZVdCMXF4NmRPeHNWSjRL?=
 =?utf-8?B?bVpWeHhWVHk3ZUNPOXBGMnloejd6SkZPdmpscnhlL1JWV2VWay9CekNnWThK?=
 =?utf-8?B?anZUNVZQUGZHWmdMaFhrc1MrS2gvcG9QWlN4M3FKWC9wY0ZyODF1QnVJZC9E?=
 =?utf-8?B?QkZHanVHTnp2RVRWWTQ5VmpaRlIwNGtxSHg2Ly9vL00wYVBNMC81em1ZSmpZ?=
 =?utf-8?B?bGlhaTNJZER6Y1dDaGF5bUVUVFlIYXNBVHlwd0FlemZpdG9VOVJLQWU2Qzk1?=
 =?utf-8?B?dEkydGxVUS81dkxQc29GQVJwbDZDNHhCejRVamtpcmRVOUU0NzIveXRueUhF?=
 =?utf-8?B?cTFyZEZnYllIQUxxK2NzOHFxRmpxMlVpOWx0cS96M2ZHeU0yWnJlRnRJVk9Q?=
 =?utf-8?B?cjlzVzV3a09QeEwxbFpXZ0MySUxjSy9hR3pFM2hQZ0pmMk50TEZ6aE54UmVQ?=
 =?utf-8?B?WTVSMFlwVDlCZk9JdHowdWNsZVZyQm5nMm4vZEQxRDJUY2lmZ1grdEtZTEVZ?=
 =?utf-8?B?T1VaUjlKVzZBMTZKV1hjNWUyUFJYY3R4VlBhejhzT3MwTWEwS2JOQ0Qya1gr?=
 =?utf-8?B?Mm9CMElIK3VVMlNnWDBMeUVXSG9KYTdMWERpVlM3QjdScVVhOHZPRE5hcHMv?=
 =?utf-8?B?WjBzbmpCMnpHdkdGZ1ZEZ1pzaVJJWGRIaUNSTTQ4WkFmaGwxaU5NOExEbUlq?=
 =?utf-8?B?N1pQNHdFdWxHd21tU0FtNFJGekFrZGRwSFRhcTlWRTBoZGR5RkJpRUVueVVp?=
 =?utf-8?B?RXZtZ0tpMzd4VGZPbEZvVUhLdWh6dnZMcjBvdmVUY3JaSldlSWJsWnBIUGZo?=
 =?utf-8?B?b0RWbGtWc25xWitpaHF6VVh5Ry9EY3VxSHNYZDJXT3MrQU9SUDRyaXN6b1A1?=
 =?utf-8?B?ODFqSG9MdFNTZG1CeUtHSTFtNkVHZFVsRjQ3Mmh1NU1iUDRuWUpnbjdNT0lF?=
 =?utf-8?B?MWpWSC9GTGdmVzAzWnZmQXdYcHk3Y0dVcVh2aVFBZjh3c3Erd0h3TndYWjQ2?=
 =?utf-8?B?aWhmWUVwL0U0Mmx2OWxQOWhqMUNlRTRlWW1NdkZlT1V3T1NOYXAvTDM1QjlJ?=
 =?utf-8?B?a2xXbnNjeVhCZFN3akFWU2RncFFvYWZ5MHBVWENDL0xFb0VzWVRQQWRYQzZt?=
 =?utf-8?B?dk5HTEw1bVN0elMvME90c2E4elFSTjkwbjh1Ly9LdXJIUjJ6TzVSelVtMlN3?=
 =?utf-8?B?RDdCeU1tVjE0d2s0OHBmSzVOemRmc05XQVU5S0Q2dVRiLzFTaE5mYS9UWXFY?=
 =?utf-8?B?ZjQ0Z2FBbkxQK25vQWFnbGIrdjZtZks2MWVNeTV1T1B3Y3lNUzZyTlZ4d2Rq?=
 =?utf-8?B?c2ZaZkxOK2ZFamZ0QXY3ZHVDUFhJWFVKWHZjSU0ya1BtVUdVNUFNMVhFNHhK?=
 =?utf-8?B?eFZRa2ZNd21mT3FTMFRWdTdZajUxeHcwZGVVZTJ6THNmNnNPbmxnOTByUmFx?=
 =?utf-8?B?ZUlCWTM4VDBFYnVXV2FEWDNCT0p3WE81Z2x6QXdTZ09FTHZuM1phL1lGZWlu?=
 =?utf-8?B?MHhLY2pnWE1rU2lvZUtlNVd6by92bXNHTU45V0M2SXRPdGloeFRkQ3ZJZWM3?=
 =?utf-8?B?NlNSZzZTUXlRTjdZcHZDVThaOGZ2K3NtQmVXckl4S2VtbUVGcVlnQVptN094?=
 =?utf-8?B?enJVekJvUTltaHA4WjRtVHBkTkwrSVBnQTQ2cmx1dWxWdGRjdXp3UUpjZW01?=
 =?utf-8?B?Tk5qeHdWUU9lRUd3RXR5aUdBZEdRMjZiQlhYVlBQdUVuSWJlWCtQTmZUclEy?=
 =?utf-8?B?SFdlaUpDM2tmc2NuVGZSOFRDelpiai9hVEdqMDdLMm1lUS8rSjZBN0tDR1Zn?=
 =?utf-8?B?YWRqNWJkWDREblpnMjlkUHpBcnBoaktScU9qSHBIRmJXaHJaVHdSVERLY3dl?=
 =?utf-8?B?anRPcy9PNVdIZXRzL2hPaDU0WC9INjhzUkN0ZkRXdDVodU1JQjFqa3l2bHBE?=
 =?utf-8?B?Vm9RRE1BRC9iTk9yVmdDaStxVWY1TExKWnBhZTVzc1lqQUtBdnhZNlhGTTR4?=
 =?utf-8?B?Uk5oUWEwbXd0RXlTRVU3cWdncjhIOU9icWkzVnJuREFLQUs0dHFzYlVKblJF?=
 =?utf-8?B?ZytRRmZrWHpPMnJjQU5qY0x0eGh5NE5zTnBnOWZ2S2YyMEdMMVVtbVduamNw?=
 =?utf-8?B?cFFYUlN3ZEFVRS9yb2lWVXpQbmlLK1RBVlhJV3hRQ3dFNTdZNUFFR2laWHp4?=
 =?utf-8?B?bmRtRlIxMGhOcDl4U2RaK2F3eUhEWkRXL1lYUi9TZ2hObzNQZ2Z4UGl4TWdL?=
 =?utf-8?B?bkRsczVrbjJDTXRDSGdBUE5SbzdUY3pUZjc5eG9KTmhmK1ZOcTZqMnlIc3Z6?=
 =?utf-8?Q?Xlrfccz7sfQbMAcs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E94C04EF2D8A3D4A8200925D6E0623E2@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 87bd4ee5-d6ed-4d82-4bbb-08de5189c6a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 03:22:11.7915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eSJ1Evvz87eZ14jSSWWs33U8nD+Ou+HAjiso+s6IeNKa8HjS+11MQi5esAKrWV29wg49LEcgzSGuTqKil7sBaxsE2+6ZAc1OMJLPDdga8ww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10132
X-Proofpoint-GUID: TQkrlOBSRZRrlHIniYGplqNsaaByn7hd
X-Proofpoint-ORIG-GUID: TQkrlOBSRZRrlHIniYGplqNsaaByn7hd
X-Authority-Analysis: v=2.4 cv=fbOgCkQF c=1 sm=1 tr=0 ts=696468e7 cx=c_pps
 a=JUmpB3/3x7NHV7iXOe9JbA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=Uhh5SpYmX29XhMuKWSMA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNSBTYWx0ZWRfXw7P5jw1lPMQv
 WEZRLWqEowbwCRrlCT4NxirXHf47a/Q5fFaoieye49qwKLWRyOlHYJklhIbHUifptOXuTRTGIsc
 5psfHEkKm9/r9p8usiE/sd49Zts3thpkVA834F59ewKPb4vw+ocY59FaX8CbWEoO5pwN93lJ/H6
 p7HMIcfuhjz2dfjwqaIzlsbkchPDKIaXaMzkQ64FHAg0rbsJO3XA9oaf/i5Gol7djFdGZ1NJf69
 haixII7+CGVeQCxynILcBg1uBTI9u6Fs1HaVSI+hFPPBrBV/Jo6RLQhzvHd6swalVSk2furjIVE
 4nneOM+6p22uKxOhbnYt1YCN2jS0EfZiaPUBxfCZBAhIi7nPyfdBK3LxLUkkV/i8kxFcjAJejZC
 uaLZP9jOPS7sSbh1D1haeTezxpgOWd4PHzvkZLF1qUCKHqwXA6Vzfy47QvhgHMaXAMe8GqF9q7B
 qfadka5o8xWMfXK7tdg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMiBKYW4gMjAyNiwgYXQgOTo0N+KAr1BNLCBEYXZpZCBXb29kaG91c2UgPGR3bXcy
QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCAyMDI1LTEyLTI5IGF0IDE1OjU3
ICswMDAwLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+PiANCj4+IA0KPj4gV2UgY2FuJ3QgdXNlIGBf
cmVzcGVjdF9gIGhlcmUgYmVjYXVzZSBpbiBRVUlSS0VEIG1vZGUgd2l0aCBpbi1rZXJuZWwgSVJR
Q0hJUDoNCj4+IA0KPj4gICBhZHZlcnRpc2UgPSBmYWxzZSAgKHZlcnNpb24gMHgxMSBhZHZlcnRp
c2VkLCBubyBFT0lSIHJlZ2lzdGVyKQ0KPj4gICByZXNwZWN0ICAgPSB0cnVlICAgKGxlZ2FjeSBx
dWlyazogaG9ub3IgU1BJViBiaXQgZXZlbiBpZiBub3QgYWR2ZXJ0aXNlZCkNCj4gDQo+IE9oIHdv
dywgcmlnaHQuIFNpbmNlIGNvbW1pdCAwYmNjM2ZiOTViOTdhICgiS1ZNOiBsYXBpYzogc3RvcA0K
PiBhZHZlcnRpc2luZyBESVJFQ1RFRF9FT0kgd2hlbiBpbi1rZXJuZWwgSU9BUElDIGlzIGluIHVz
ZSIpLCBLVk0gd2l0aA0KPiB0aGUgaW4ta2VybmVsIEkvTyBBUElDIHdpbGwgKm5vdCogYWR2ZXJ0
aXNlIHRoZSBFT0kgc3VwcHJlc3Npb24gaW4gdGhlDQo+IGxvY2FsIEFQSUMgdmVyc2lvbiByZWdp
c3RlcuKApiBidXQgZG9lcyBhY3R1YWxseSBob25vdXIgdGhlIERJUkVDVEVEX0VPSQ0KPiBiaXQg
aWYgdGhlIGd1ZXN0IHNldHMgaXQgYW55d2F5Lg0KPiANCj4gV2hpbGUgd2l0aCBhIHVzZXJzcGFj
ZSBJL08gQVBJQywgS1ZNICp3aWxsKiBhZHZlcnRpc2UgaXQsIGJ1dCBub3QNCj4gaG9ub3VyIGl0
Lg0KPiANCj4gWWF5Lg0KPiANCj4gU28geWVzLCB5b3VyIGNvZGUgaXMgdGhlIGJlc3Qgd2F5IHRv
IGRvIGl0LiBTb3JyeSBmb3IgdGhlIG5vaXNlLg0KDQoNClRoYW5rcywgZm9yIHRoZSByZXZpZXch

