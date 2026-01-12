Return-Path: <kvm+bounces-67691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EF18DD107B0
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 04:28:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A15833018806
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 03:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40CD530BBB7;
	Mon, 12 Jan 2026 03:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PI7rYPx2";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mkxjSGin"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D272A26B973;
	Mon, 12 Jan 2026 03:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768188501; cv=fail; b=K+w1g3FEJ/UYUSPah9gvEynzhO2t4pDGYKcUV2up0WuTQ7tE8/j/VFUwkehb36RG/M6zR5+Cq8309hFBYKx6IXgB27Ky08PExJ8X08twbSrx9TAq4JPqNupR5QpInc6o9tJT2ClOY3QSIavrwTeN4bHiRd2LpIN/88n4e03gIm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768188501; c=relaxed/simple;
	bh=lRlKn/KiUI2gEzD0k/wzZ1ConvKxHt2wwo2XRd5D4os=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QaRg4lh+u5L75ONkAoHrOWqY7z9RMgCE/j79upOKh/CltkTLhyTq+c5KKmE/pfGINZqcstB4/NpjWcmEbjzYEv6BpDERBfEbCxTuX7VrmpUkeuXeAOkc2jQiOftP7b3nAdtFsKiNq5I/m/tBV5uEJBQQM/2zM7lPAQEYMEfwoy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PI7rYPx2; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mkxjSGin; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60BKj2To1968284;
	Sun, 11 Jan 2026 19:27:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lRlKn/KiUI2gEzD0k/wzZ1ConvKxHt2wwo2XRd5D4
	os=; b=PI7rYPx21rwqzZCvNQBpyD89vU9Z8Wf2h7Eh2/89FZPjPFQHA2S4aLCXq
	k1aFXcSMSDC3edGtjbRqXC+b5VElQLXIIZnU5ZVJo1GQQ7yrOs/OgGOrRfh0BOV2
	iDbGlw0X6jYZXIYs0RL9fKW/Wb8otK2G38jMW4jnfrjitukL8RMZwNIdy5kfJ2th
	OdqO3i+7eAP0r3XzoO2b0F2o3p+jvWMfC8SGnUuYsKNzpdj3JlBVW0XI60XzbXSd
	IPp8IyhlYQR1CDO/GsCdE7GwvR4xyzNzVyBpS2biBwEMa+dpYo4CBhz26wIZbpTa
	aMH5U2dSvmKWqyAtkEj93OfF/SQkw==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11020093.outbound.protection.outlook.com [52.101.85.93])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bkn6b227n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 11 Jan 2026 19:27:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RlJEICt+KBl7AMbDwvQzDWkVo7jSUSsrwn+Z6TSXfo1E09d1C2Z1HWf5bc6/8t1P+2sImnBfPZwnK9+Y9UsXkfLrqho1tJrzArVmgN6HVipzy7B0FxXtgH3Icb0daZHFqVUflwEWeMH2r6CDZAiTgJ4lqLx29i/0sP8nYKFH68FrUt8IShTPdBuwskqjP50zFyPS3G21+RjcvlXaTynn04znAFIbqGKmuNtKSZ0COak8axi+C36I2/uigP+BApQ8q3Gm2pX1PewPQvJfa/7UC01Sj4EJed4T0Bib5755wD5ekNGtv4wjgawFw9JGEOBOAph6vCDTQugYDh6Znyx8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRlKn/KiUI2gEzD0k/wzZ1ConvKxHt2wwo2XRd5D4os=;
 b=yCZ0ly9TnfXSDAvPzLe8cXF9LK6T/dBJ+0F5s1va2lHVq7Is7nFpWHQ0uJyWgL8XGT6NiGOb/olyVglfF6A0lBgtX0GvoHr7Ou8SuKO1hY7o0oPFzWu/5L4joviGUvdgvyuGJMBSvi0a0cNgyhJv7vs6/y0IembfVDJj8rEPVAEyb7elyhVTCyTPuNhUYsmySxbiuthe2cTnbMnR2s2wZ6xKeds25+nLzT0ztAxGfX0N68/ysIMQjlifuUuhBzEGoA/qZ1dLlMNCEQJtn+yQQ7pRNXIB1egJL9vLTUGuOVyW3LjapDUrpcKZdhLB8KKrxGp/qGD3sEs3D1WUpW2VfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRlKn/KiUI2gEzD0k/wzZ1ConvKxHt2wwo2XRd5D4os=;
 b=mkxjSGinJP8v5KSnwKnRnHx5mo/o0Q5qmo3i7du5RzebO4RGw4mD7GYyAQ54VJDzqIxdhtYy55GDu7GFK00W37CBf+Lxkk+TVlQ2H6mL+RuENH1yZ1lcww6bM+rBYuNyFfOGhllh5pHwtu/p++zntshDG0oFCD7EFVxtv5mhcWBHTxyZC9j/Qu3SiKYP5Kz/aMOugprOOeoN3vH3QJW9agHZg31xwU5y971rwNsMoyQdWN52hnHfYQDsdmyAJlCDkL/yxa3CZAaqlsAEro1/zH82znm2dBx+y6Tm4JOY33wGKv7i1/9UICiCjNUNtON+HFqljHndmH/w58M7JBST+Q==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CO1PR02MB8668.namprd02.prod.outlook.com (2603:10b6:303:15f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 03:27:48 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:27:47 +0000
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
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v5 3/3] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHceLTEPbw884RhTkay47hca1FKR7U/G94AgA7ZhIA=
Date: Mon, 12 Jan 2026 03:27:47 +0000
Message-ID: <62D036C3-28B4-43EB-9A4B-DFF6A17CB68D@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-4-khushit.shah@nutanix.com>
 <179aa29aa9d5baa698171b884bb6fbe66ad5c2b3.camel@infradead.org>
In-Reply-To: <179aa29aa9d5baa698171b884bb6fbe66ad5c2b3.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CO1PR02MB8668:EE_
x-ms-office365-filtering-correlation-id: 8bb431cc-ffcd-4482-878d-08de518a8edb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VnFMWkNjcVU1bXIyNkFQVVhNeko4bDVoMWp5YXczNDd4SWFIZzN3bWZDYkdW?=
 =?utf-8?B?SnBkeVRWUjljVjJaeXc1aVAxKzBaRU5EbXZ5aVdybEV6WWFLNmdnTjJtaXJ4?=
 =?utf-8?B?dU1YQ0FxWk5XSVdNWFpRNjFmbmJMZ2I3M3BIV2FZM1k2S1lTaVN6QlNpQll6?=
 =?utf-8?B?TGpYSSsyZzJ2OVRUNHJxdUJxVHptbXg2RDFEMjAvdUNPRkV5U1J0enJQdjFK?=
 =?utf-8?B?Wmt2RzN3MjhFMnJkc1RBV1IyNXljSDFqY1RFNDRIS0Z0UDAwR2tGZkNNbVlj?=
 =?utf-8?B?ZGF4NDlyL25jNHk4VzZmWENMSmVlUDVWbmVzZk1qQVd5OHJnUW85MzBOaktz?=
 =?utf-8?B?TXBJTHJQTC8xMGdsdFFZQTY5TmFCL3VUZThoeXJveGNtaHFRcUR3TFhkM01Q?=
 =?utf-8?B?U09PTHRlMmlsQTczUW5uY0t5QWlXQkppNGJ0TGh6bXNKMkFTVkZkUlh0aE5x?=
 =?utf-8?B?dzI1R3BBMDQ5TVdMRVVQTXRCc1Q1RGM5VXYwV3l3YXhvd0Q2WFlUUGZOT1RL?=
 =?utf-8?B?eDBvcHUzREQvRlRLeGVhaXE2VUorTEVwMHFZMVhxN0VZbW9nUWV3TEJKN1gv?=
 =?utf-8?B?OWNwNDhLazRIVTVQdHlCZ01jcTRWblZUMTlFalFZM2FhZzNybDBRRVFCT0hB?=
 =?utf-8?B?R0xuYjFIcXEyS1A3Sm9lNTBpTGs2WkZzRUxUQ2xpUWJzeUZkeDZCTjVVd2tN?=
 =?utf-8?B?QnI2TkpiSWxWYy9OYjhIV3ZaRm50eEdCdjFDWmNRVlVGZ2lBaWE0OGJSdWJ0?=
 =?utf-8?B?QkdmeGFVMWhManNBTTBha3lNRVBHNWhja2xobm5mRU9PWXVmajJGK3ovVGcx?=
 =?utf-8?B?NTlJRVorYVlEdmhyTXd4ckx4bGJ0WUtMaEJRWXl0djlGa3NhVGJTVzhRbENr?=
 =?utf-8?B?V01VV0ZQQU5ubjkvYlpwYm5JcytKYlROYkI5d1RZczZpTUJaU0QyWGk5SHR0?=
 =?utf-8?B?T1IvUUNybjJOYjR3T1UrZXpIYkN3ektqUEVHbHRQdEJwb1h6bkJNT0I0Wm80?=
 =?utf-8?B?ckhFcmN2N2E3eWZ1bmJRd3lDZ2ZBUlcyYzRWVEtZeE1LSGdSN0EvVVFYdXRE?=
 =?utf-8?B?N29GZE9jNFoveGZKVjBDd1FNQ3dpcWRzK2xaVVdmNDVVQUNsMW1ZK0tGQlli?=
 =?utf-8?B?bEdWcDVrczl2VEVjQkNmay9UMDBPWnN0YUtZeHl6RW4yWmt4YjlHenhyYTEy?=
 =?utf-8?B?c05LdVVUNWErN3c1dnVUcHdaeWNteVViNHNRVE5Rd09FaklNZDEzTzBuaEUw?=
 =?utf-8?B?UGVHK3M4dFd6YTRQZHVwNjR2SmZ2Q2xNQWZCRlBZU3RTV2pvY0YxZzBLL2p2?=
 =?utf-8?B?WGUxa3VRRlo5UFBLZ29OVG5ROElUVG43cUJtaHlQeGg5citNM2wxaHRacW0z?=
 =?utf-8?B?RGdvRjlFQllpRkpDRDU5ODdKS2F3S3huYS84Z2Zwdi9WeW5SN28zbWFuR0ZX?=
 =?utf-8?B?ZDJhSlhqRlhYWS9uM3YrNmg4UWhKMzRiVHI0NWQ0RzdYdUpGMEdESEg3NzVp?=
 =?utf-8?B?SkJ2WlZnMmtsSGJKbGRwQ1dpd3FaTzdqb3dqNE5TbVk5MFRRUlFjMzNGUC9K?=
 =?utf-8?B?anE1RnBobnBiSEdpd2szWXdWVUpIRTBuY1RmZDZidm5xWFlRQTRhUnlKWXJT?=
 =?utf-8?B?MHU5WW9MaHpDcjIxc3dBMDJJUG5DTEFJN09DYjVjNDFOaFZ4L2hoWnVXYUdW?=
 =?utf-8?B?NDV0Ui9yclQ3Wi9NZWJHS3VNMzNmamZTd1JocFJyQ2RUSHVWaDNvUVdVMGha?=
 =?utf-8?B?OGd5R1h6TzBoS0w0TjJkSlFNbWg5aUlJbUVaS1dhK1lQRDNKNlV0b09oTlpO?=
 =?utf-8?B?d094dXJzUVRZZ2E1OHk4ZU41SExmcG5heGNNR0lZNHk4ODVvRnpMWnNPN0da?=
 =?utf-8?B?ZlMreVFESEFjaTJndEh2OFVGeno2S1ZTRXMwMy9pQm1pdjNKSVhlZ2Iyc0dL?=
 =?utf-8?B?ODBjY1d3WFRpcCt5UEpKWnAzMWM1YUdVZjhITUl2dFF3U1ppWUxqT25CR0p1?=
 =?utf-8?B?aEpzSStMT2Y5NzhQaDJOb3I1RForbWd2TFJ6aVZ1WjdWdFV1cHhSV0dPWnIv?=
 =?utf-8?Q?5YZsVK?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dWZ5bW1SeW8xMHZxdU1SblJ3ZFhIaE9JMXhMQ1hmSzZvVkJEN2dONXlKTHVw?=
 =?utf-8?B?SlM3QzB2aUpSTHdxQjNIKzZHbk1CckNhWHlPb0lvRE5lM0ZGcXdiRDMrLzBJ?=
 =?utf-8?B?eWVLeGtiQlR0TGxzRjJyN2loaDUwTVRza2xDTU1lK05EVXJWR1JIUWd6R2dD?=
 =?utf-8?B?bXh6M0Z5bStacEg0SkVibjR0clRrZnAzb28wVXlsenV3SElKTXp1K296WW1h?=
 =?utf-8?B?TGdlSndFRjFsSTJMZ2tZNUQvNUl6QmYrbzFzZ2lFNVNoU3ZscGVTcTFJQTVh?=
 =?utf-8?B?QThnQXIrSzZsZzdjazkzamJ3Rlk3RXg3NUw2TCt4TXRHb3JwTmY3dVptNDdD?=
 =?utf-8?B?VWxQakdkR2pwZ0NoV01kaGZUVWVCVGJwSkp0UTExT2NXUTByN0dDaTM2am9p?=
 =?utf-8?B?VlEzRFViMHBYNE1pdWh0SkUwZEF3cWs3U2VIWDRzLzVwZ2lERE8rSFMzWXp3?=
 =?utf-8?B?dURZcEVwV3pSOHB2MUFYeWVSNTVLNWZwOHJnS1ozZ0FWdDlnYUVPbERlTWZL?=
 =?utf-8?B?VTlCRDdUUXpIbmFDNzdKTm03NmpGODkyMlJqa2dvTDBudElEV0w0K0Z1WVBT?=
 =?utf-8?B?S2dLODRuQkh6M25UWlhPQTVYd1FHQmF0NlRDV2lVazlTV0s0NEhOc2EvQnp3?=
 =?utf-8?B?UXp0TkwyUW9hRGd1eGxqVm9mamJZYzJEUUMvZUozSGVPUk5DcWx1cmJGd1oz?=
 =?utf-8?B?ZnlPUzZJNnpQZ05jUkN4TE4xdUVxSjE2SUVUU1duRGtuSkcxOGxnb01tTVE0?=
 =?utf-8?B?MHFUY0lwdUJsUFI2WUVkdDk5SVNRZFJQSEpWL0tEczNITDJ0WW5xZFcxSXVG?=
 =?utf-8?B?eXk3UWxMb3lPbDNRVUxNY1VQdnpVZ3NnMUZiT1VoOTV2NmJmaWxnUlpqdkVG?=
 =?utf-8?B?dUR2YTBlYU1GelFuWkM1ZTZOcWErRVRlM2VnYXNEWUswRWxuRTgrU21lMEFj?=
 =?utf-8?B?ZWlGbSs4MUFteUlmTTFxNmpwTUJPUytvSFdQaDdubU9lL0JUUWZRcGZNRlJY?=
 =?utf-8?B?WmkzZExQQ2djdm9CU0JqaElEQ2NNRmVzSkxGUnphM0lnY2lDVk1jSmNDK2Zj?=
 =?utf-8?B?c3BwbDU3c0dHU1djSE5wanhXSDBIT0JPYkdyWFdUL3VSdU9Vc3hRWmFXM1Nn?=
 =?utf-8?B?dGE1Sk5CN3RoRUZIV21TNjByVDhLdEIxdEl0U0MyS0doOEIwaDZ3V1FpNzl3?=
 =?utf-8?B?UFZmZXFieFpaa2c5bW8zaFppUXRFRFhMNGZ3Z3J1S3hHeE94ZktyWUNkdEJM?=
 =?utf-8?B?NVJrbisrQ0JZaHV5K2wxNldNRnkybXAzbHNtd3AwLzBDRUxBeU4rb1JJSVAy?=
 =?utf-8?B?L2hXZWczR2o4aXF1Wm00V3dhc2lMQ2NQdElyZXNQSE1UNVA4cXZGRVBHbVRi?=
 =?utf-8?B?T2x4dnJ4WjMzYzJXRjlqSDRqT3NNTHBQM25VSTNESWlCWUlncnBGZ1Fmb0o5?=
 =?utf-8?B?QmxQSG5IeVpSUHRhdm40bDdrSnJ6TUpPTkt2bEdYR0xZNmJLSmlYR0drK2hj?=
 =?utf-8?B?N205QzhWbmRHdy9RckVJOUVEZ2t0VHZER0lCY2RzY0oyUXFvOXlHSkFLbksx?=
 =?utf-8?B?RWtOOVZJd1lOYmpMUGFQMGZ4RFFnTmg4R1czS2F5ZktQY0E1cGttbVhvQnJo?=
 =?utf-8?B?VEc5UnhOanI5bXMwYndvRFdCbjFVMnNPWlY5dkRMUS9tcXptaEVlMWxuRzIr?=
 =?utf-8?B?SmVxVXMvZzc3U1BIbEtVbHUvenFjczQzazdRdVNHNzFwUUVrMVMrYlBHZGNo?=
 =?utf-8?B?c1RyVzZFak51S2Fva3ltTlppZXdBWHN5OGE0SUExTU15NFNTZlVlVHJBNGZS?=
 =?utf-8?B?NVNNY05QNW44dU8zdEFtUHFvWE9wTWRtdTJJT0VxcnE2THRTQzBSRWZESGdY?=
 =?utf-8?B?OFVVRTY2MytsUGdPTmd0UjZmRFZBd1BUc3NSclFqWTJLMk5hSjl2UG56S1Vt?=
 =?utf-8?B?cFBMYkZ6ck1TbDVWbG4zbklpcGRGWWpnRlpLRHprVDZMdjVnTHF1SHpneGRu?=
 =?utf-8?B?VGo2cVRHbDJ0RVNxand6T21vTDExWlFhd0pCWHBLY3VPSWFjdENqRSt5SFZi?=
 =?utf-8?B?dmFhM3FDKzI3R2ttVUZsaGhZc1BGLzBmVXpwczdWRGlWWUdwdzNDSXorSTNk?=
 =?utf-8?B?SG5xemxhTEJKQ2RIWFdtTFlPeVpqNzltclRwZlAxYVBZU0ZDRWphVWsxbFlm?=
 =?utf-8?B?OFk1NzhodXNnYktrZ1I4VE9weFY0K1YyQWdmNU5QY0s1Mmw5aUhkeVZiTW5K?=
 =?utf-8?B?V1dWV2tmUW1sYk5WWmFDVitwRHdHTW5zelBDRFUxOEpkMHNPbS82UUVKSm5W?=
 =?utf-8?B?ZzBNY1pvUTdqYkY2SE5aREo3SHVMQ21XajBRL1pKTTdaZjZSVk1pWC9NcUlD?=
 =?utf-8?Q?ojM6Pw1Ya4X1Ze4s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD329F999683AE43A7E180508C6BEF7E@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb431cc-ffcd-4482-878d-08de518a8edb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 03:27:47.6673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R99SUIITfMlTTIqnRYiw50T0k2uEJqXfDo2fMMUlbZzMGCko548vuOIPYGM1M5fIrjzLMl0SjPztCfa9oiqbBXaDOPioaYZFWxkywFqZY/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8668
X-Proofpoint-GUID: Rjr-4E9A1dC39w_Jp9kwZc7E-8ki5UAG
X-Authority-Analysis: v=2.4 cv=TtjrRTXh c=1 sm=1 tr=0 ts=69646a36 cx=c_pps
 a=GdPAKRNZCFWq8uDyhvyBig==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=64Cc0HZtAAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8
 a=pBOR-ozoAAAA:8 a=6taAGrqlc7b8ECDbsA8A:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNyBTYWx0ZWRfXxAAuGfoqVEHe
 N+7UXzAokcO0nruwFaeJ2ZQmCk/oFpwCucRKj4yQhCZOZt/LlAQHP8Z21T3xsdv/hzdJJDFpa/1
 7OCASRNAKJJHyP3EVgCKKs2OvJrfPljtD9tunPfD/6cEkbJZk6PJKDiT3HvUWlZqDZhMPtvY6i3
 F3OgNLGaBupMXaVWpeaQUvDH4uGQeolds+SeQugwWML29Xih77Oj+8FRld4iTWn1sY9Ju/7IB0x
 /LVXXBlWH4RGn7tnh4F3ozLhgrXaSvzRdkJaDnKMGNJy+gZkjuoCSzzcc33ixwhzwDSCCo0bxnq
 ViPmI/cxINTOX13fWjGPiCewz/rdn3GuEIzcoizWgTc52bFn7CjSUzBsh9fHhjBt2G5V2y9K18K
 yzV9cpwSMBlA+AGWnPBi0lMKeJbX4DFCXH0jw+P0S6wgc8X4IGXbERmN6GKNBVcmXAA8mOjCP9J
 yeo72L/3ltQkluGUVzQ==
X-Proofpoint-ORIG-GUID: Rjr-4E9A1dC39w_Jp9kwZc7E-8ki5UAG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMiBKYW4gMjAyNiwgYXQgMTA6MTHigK9QTSwgRGF2aWQgV29vZGhvdXNlIDxkd213
MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IE9uIE1vbiwgMjAyNS0xMi0yOSBhdCAxMTox
NyArMDAwMCwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gQWRkIHR3byBmbGFncyBmb3IgS1ZNX0NB
UF9YMkFQSUNfQVBJIHRvIGFsbG93IHVzZXJzcGFjZSB0byBjb250cm9sIHN1cHBvcnQNCj4+IGZv
ciBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0cywgd2hpY2ggS1ZNIGNvbXBsZXRlbHkgbWlzaGFuZGxl
cy4gV2hlbiB4MkFQSUMNCj4+IHN1cHBvcnQgd2FzIGZpcnN0IGFkZGVkLCBLVk0gaW5jb3JyZWN0
bHkgYWR2ZXJ0aXNlZCBhbmQgImVuYWJsZWQiIFN1cHByZXNzDQo+PiBFT0kgQnJvYWRjYXN0LCB3
aXRob3V0IGZ1bGx5IHN1cHBvcnRpbmcgdGhlIEkvTyBBUElDIHNpZGUgb2YgdGhlIGVxdWF0aW9u
LA0KPj4gaS5lLiB3aXRob3V0IGFkZGluZyBkaXJlY3RlZCBFT0kgdG8gS1ZNJ3MgaW4ta2VybmVs
IEkvTyBBUElDLg0KPj4gDQo+PiBUaGF0IGZsYXcgd2FzIGNhcnJpZWQgb3ZlciB0byBzcGxpdCBJ
UlFDSElQIHN1cHBvcnQsIGkuZS4gS1ZNIGFkdmVydGlzZWQNCj4+IHN1cHBvcnQgZm9yIFN1cHBy
ZXNzIEVPSSBCcm9hZGNhc3RzIGlycmVzcGVjdGl2ZSBvZiB3aGV0aGVyIG9yIG5vdCB0aGUNCj4+
IHVzZXJzcGFjZSBJL08gQVBJQyBpbXBsZW1lbnRhdGlvbiBzdXBwb3J0ZWQgZGlyZWN0ZWQgRU9J
cy4gRXZlbiB3b3JzZSwNCj4+IEtWTSBkaWRuJ3QgYWN0dWFsbHkgc3VwcHJlc3MgRU9JIGJyb2Fk
Y2FzdHMsIGkuZS4gdXNlcnNwYWNlIFZNTXMgd2l0aG91dA0KPj4gc3VwcG9ydCBmb3IgZGlyZWN0
ZWQgRU9JIGNhbWUgdG8gcmVseSBvbiB0aGUgInNwdXJpb3VzIiBicm9hZGNhc3RzLg0KPj4gDQo+
PiBLVk0gImZpeGVkIiB0aGUgaW4ta2VybmVsIEkvTyBBUElDIGltcGxlbWVudGF0aW9uIGJ5IGNv
bXBsZXRlbHkgZGlzYWJsaW5nDQo+PiBzdXBwb3J0IGZvciBTdXBwcmVzcyBFT0kgQnJvYWRjYXN0
cyBpbiBjb21taXQgMGJjYzNmYjk1Yjk3ICgiS1ZNOiBsYXBpYzoNCj4+IHN0b3AgYWR2ZXJ0aXNp
bmcgRElSRUNURURfRU9JIHdoZW4gaW4ta2VybmVsIElPQVBJQyBpcyBpbiB1c2UiKSwgYnV0DQo+
PiBkaWRuJ3QgZG8gYW55dGhpbmcgdG8gcmVtZWR5IHVzZXJzcGFjZSBJL08gQVBJQyBpbXBsZW1l
bnRhdGlvbnMuDQo+PiANCj4+IEtWTSdzIGJvZ3VzIGhhbmRsaW5nIG9mIFN1cHByZXNzIEVPSSBC
cm9hZGNhc3QgaXMgcHJvYmxlbWF0aWMgd2hlbiB0aGUNCj4+IGd1ZXN0IHJlbGllcyBvbiBpbnRl
cnJ1cHRzIGJlaW5nIG1hc2tlZCBpbiB0aGUgSS9PIEFQSUMgdW50aWwgd2VsbCBhZnRlcg0KPj4g
dGhlIGluaXRpYWwgbG9jYWwgQVBJQyBFT0kuIEUuZy4gV2luZG93cyB3aXRoIENyZWRlbnRpYWwg
R3VhcmQgZW5hYmxlZA0KPj4gaGFuZGxlcyBpbnRlcnJ1cHRzIGluIHRoZSBmb2xsb3dpbmcgb3Jk
ZXI6DQo+PiAgIDEuIEludGVycnVwdCBmb3IgTDIgYXJyaXZlcy4NCj4+ICAgMi4gTDEgQVBJQyBF
T0lzIHRoZSBpbnRlcnJ1cHQuDQo+PiAgIDMuIEwxIHJlc3VtZXMgTDIgYW5kIGluamVjdHMgdGhl
IGludGVycnVwdC4NCj4+ICAgNC4gTDIgRU9JcyBhZnRlciBzZXJ2aWNpbmcuDQo+PiAgIDUuIEwx
IHBlcmZvcm1zIHRoZSBJL08gQVBJQyBFT0kuDQo+PiANCj4+IEJlY2F1c2UgS1ZNIEVPSXMgdGhl
IEkvTyBBUElDIGF0IHN0ZXAgIzIsIHRoZSBndWVzdCBjYW4gZ2V0IGFuIGludGVycnVwdA0KPj4g
c3Rvcm0sIGUuZy4gaWYgdGhlIElSUSBsaW5lIGlzIHN0aWxsIGFzc2VydGVkIGFuZCB1c2Vyc3Bh
Y2UgcmVhY3RzIHRvIHRoZQ0KPj4gRU9JIGJ5IHJlLWluamVjdGluZyB0aGUgSVJRLCBiZWNhdXNl
IHRoZSBndWVzdCBkb2Vzbid0IGRlLWFzc2VydCB0aGUgbGluZQ0KPj4gdW50aWwgc3RlcCAjNCwg
YW5kIGRvZXNuJ3QgZXhwZWN0IHRoZSBpbnRlcnJ1cHQgdG8gYmUgcmUtZW5hYmxlZCB1bnRpbA0K
Pj4gc3RlcCAjNS4NCj4+IA0KPj4gVW5mb3J0dW5hdGVseSwgc2ltcGx5ICJmaXhpbmciIHRoZSBi
dWcgaXNuJ3QgYW4gb3B0aW9uLCBhcyBLVk0gaGFzIG5vIHdheQ0KPj4gb2Yga25vd2luZyBpZiB0
aGUgdXNlcnNwYWNlIEkvTyBBUElDIHN1cHBvcnRzIGRpcmVjdGVkIEVPSXMsIGkuZS4NCj4+IHN1
cHByZXNzaW5nIEVPSSBicm9hZGNhc3RzIHdvdWxkIHJlc3VsdCBpbiBpbnRlcnJ1cHRzIGJlaW5n
IHN0dWNrIG1hc2tlZA0KPj4gaW4gdGhlIHVzZXJzcGFjZSBJL08gQVBJQyBkdWUgdG8gc3RlcCAj
NSBiZWluZyBpZ25vcmVkIGJ5IHVzZXJzcGFjZS4gQW5kDQo+PiBmdWxseSBkaXNhYmxpbmcgc3Vw
cG9ydCBmb3IgU3VwcHJlc3MgRU9JIEJyb2FkY2FzdCBpcyBhbHNvIHVuZGVzaXJhYmxlLCBhcw0K
Pj4gcGlja2luZyB1cCB0aGUgZml4IHdvdWxkIHJlcXVpcmUgYSBndWVzdCByZWJvb3QsICphbmQq
IG1vcmUgaW1wb3J0YW50bHkNCj4+IHdvdWxkIGNoYW5nZSB0aGUgdmlydHVhbCBDUFUgbW9kZWwg
ZXhwb3NlZCB0byB0aGUgZ3Vlc3Qgd2l0aG91dCBhbnkgYnV5LWluDQo+PiBmcm9tIHVzZXJzcGFj
ZS4NCj4+IA0KPj4gQWRkIEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1Qg
YW5kDQo+PiBLVk1fWDJBUElDX0RJU0FCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCBmbGFncyB0
byBhbGxvdyB1c2Vyc3BhY2UgdG8NCj4+IGV4cGxpY2l0bHkgZW5hYmxlIG9yIGRpc2FibGUgc3Vw
cG9ydCBmb3IgU3VwcHJlc3MgRU9JIEJyb2FkY2FzdHMuIFRoaXMNCj4+IGdpdmVzIHVzZXJzcGFj
ZSBjb250cm9sIG92ZXIgdGhlIHZpcnR1YWwgQ1BVIG1vZGVsIGV4cG9zZWQgdG8gdGhlIGd1ZXN0
LA0KPj4gYXMgS1ZNIHNob3VsZCBuZXZlciBoYXZlIGVuYWJsZWQgc3VwcG9ydCBmb3IgU3VwcHJl
c3MgRU9JIEJyb2FkY2FzdCB3aXRob3V0DQo+PiB1c2Vyc3BhY2Ugb3B0LWluLiBOb3Qgc2V0dGlu
ZyBlaXRoZXIgZmxhZyB3aWxsIHJlc3VsdCBpbiBsZWdhY3kgcXVpcmt5DQo+PiBiZWhhdmlvciBm
b3IgYmFja3dhcmQgY29tcGF0aWJpbGl0eS4NCj4+IA0KPj4gV2hlbiBLVk1fWDJBUElDX0VOQUJM
RV9TVVBQUkVTU19FT0lfQlJPQURDQVNUIGlzIHNldCBhbmQgdXNpbmcgaW4ta2VybmVsDQo+PiBJ
UlFDSElQIG1vZGUsIEtWTSB3aWxsIHVzZSBJL08gQVBJQyB2ZXJzaW9uIDB4MjAsIHdoaWNoIGlu
Y2x1ZGVzIHN1cHBvcnQNCj4+IGZvciB0aGUgRU9JIFJlZ2lzdGVyLg0KPj4gDQo+PiBOb3RlLCBT
dXBwcmVzcyBFT0kgQnJvYWRjYXN0cyBpcyBkZWZpbmVkIG9ubHkgaW4gSW50ZWwncyBTRE0sIG5v
dCBpbiBBTUQncw0KPj4gQVBNLiBCdXQgdGhlIGJpdCBpcyB3cml0YWJsZSBvbiBzb21lIEFNRCBD
UFVzLCBlLmcuIFR1cmluLCBhbmQgS1ZNJ3MgQUJJDQo+PiBpcyB0byBzdXBwb3J0IERpcmVjdGVk
IEVPSSAoS1ZNJ3MgbmFtZSkgaXJyZXNwZWN0aXZlIG9mIGd1ZXN0IENQVSB2ZW5kb3IuDQo+PiAN
Cj4+IEZpeGVzOiA3NTQzYTYzNWFhMDkgKCJLVk06IHg4NjogQWRkIEtWTSBleGl0IGZvciBJT0FQ
SUMgRU9JcyIpDQo+PiBDbG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS83RDQ5N0VG
MS02MDdELTREMzctOThFNy1EQUY5NUYwOTkzNDJAbnV0YW5peC5jb20NCj4+IENjOiBzdGFibGVA
dmdlci5rZXJuZWwub3JnDQo+IA0KPiBEbyB3ZSB3YW50IHRoZSBDYzpzdGFibGU/IEFuZCBpZiB3
ZSBkbyB3ZSdkIHdhbnQgaXQgb24gYWxsIHRocmVlDQo+IHBhdGNoZXMsIHN1cmVseT8gDQo+IA0K
Pj4gU3VnZ2VzdGVkLWJ5OiBEYXZpZCBXb29kaG91c2UgPGR3bXcyQGluZnJhZGVhZC5vcmc+DQo+
PiBDby1kZXZlbG9wZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29t
Pg0KPj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5j
b20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBLaHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4
LmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBEYXZpZCBXb29kaG91c2UgPGR3bXdAYW1hem9uLmNv
LnVrPg0KPiANCj4gQWx0aG91Z2guLi4NCj4gDQo+IA0KPj4gLS0tIGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20va3ZtX2hvc3QuaA0KPj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aA0KPj4gQEAgLTEyMjksNiArMTIyOSwxMiBAQCBlbnVtIGt2bV9pcnFjaGlwX21vZGUgew0KPj4g
ICBLVk1fSVJRQ0hJUF9TUExJVCwgICAgICAgIC8qIGNyZWF0ZWQgd2l0aCBLVk1fQ0FQX1NQTElU
X0lSUUNISVAgKi8NCj4+ICB9Ow0KPj4gIA0KPj4gK2VudW0ga3ZtX3N1cHByZXNzX2VvaV9icm9h
ZGNhc3RfbW9kZSB7DQo+PiArIEtWTV9TVVBQUkVTU19FT0lfQlJPQURDQVNUX1FVSVJLRUQsIC8q
IExlZ2FjeSBiZWhhdmlvciAqLw0KPiANCj4gDQo+IEkgYmVsaWV2ZSBpdCdzIGNvc21ldGljIGJ1
dCBJIHRoaW5rIEknZCBiZSBzbGlnaHRseSBoYXBwaWVyIHdpdGggYW4NCj4gZXhwbGljaXQgJz0g
MCcgb24gdGhhdCwgYXMgd2UgcmVseSBvbiB0aGF0IGZpZWxkIGJlaW5nIGluaXRpYWxpc2VkIHRv
DQo+IHplcm8gd2l0aCB0aGUgYWxsb2NhdGlvbiBvZiBzdHJ1Y3Qga3ZtLCBkb24ndCB3ZT8NCg0K
DQpBY2tlZC4=

