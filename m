Return-Path: <kvm+bounces-64744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 342ADC8BB12
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id CD1F234745B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 19:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6711340A57;
	Wed, 26 Nov 2025 19:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kF1bGxPw";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NIK0w0Nl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31C333A03D;
	Wed, 26 Nov 2025 19:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764186509; cv=fail; b=BZsNuULC9EDV8f0zZ6jYdUWtfmvDVKyIq6WAAgkto/D46+HRzjq7l6Ljlw+bMexc77hdylcUan9YEH/TZtyu2pBlrPPLVMeThbyJgjZ42l2EjVg8CMPWUTnXJQdj2P8JFWt4hq1wMZ8h1JxAAGoEAI/nAKgOq3UnJQFM+1q8GYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764186509; c=relaxed/simple;
	bh=AVYOaihAo+L4VZV3gL+xuu1qC8BnG5ThVsLtvrGNnMg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KVQDtv1YvPG7/gCXNB/OBl8y9/TsxM8dvB/luGTAuIXfhMFwQ7nQnqml276GyECKbQ+0IrbVjzHxkdJ4e4fKXa396Lz+4Y0GhjU/WTmv4TLNgrDQooIteGq485ndQiH8TiXR3rkKrNA9sNb6j698K0pmcELJ1bB5EzuFWeKtGJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kF1bGxPw; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NIK0w0Nl; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQEmWem956483;
	Wed, 26 Nov 2025 11:47:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=AVYOaihAo+L4VZV3gL+xuu1qC8BnG5ThVsLtvrGNn
	Mg=; b=kF1bGxPwRqIBffOAlcxenorKqcOaCDwtUfTaRWQ1zLFBuvIkInfwAab+c
	WJgrF7RgldQ/Wd5Y9MHI9NURXjk4Uuz88l9bQNIQA18LRLX7iMetI237m0FW/Wmy
	r9yvFBb1cUbQOG0XtwQ9QlhQMGW3JUBVv1ClXGxmoT6VGtNzLTI8tjQIbKs+kdWQ
	6mnNi80rwnb2Ye9gzC78T3UT693mGkmY1Ka2WFd5bUTr2o0LaX5TXoyNMGne+7D5
	ju3MmUPw5yEzWdDwJbb80ZeGOxep9Cw187wXYhbddnwIQjdD83j7Mj/qvdzmMRXd
	zMbA2Hmw61P1KwnYUTP6QgpylgfBA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11020136.outbound.protection.outlook.com [52.101.56.136])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap3my8k25-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 11:47:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ej12o+0E/R7uuFO8pAKFVnUpyTVh26hrU8ej4a47w4a7ZhLgkeU50WGZ4XcKrY+24npgemn6esVwRGjo/LKqlMSJypdzOgdUul5+8+/M8H3ToDLte24dFF0VlEW4/ucOo01nsZho4r1184IEyj3wOKNQxgGaHLgezGSRRub+gIZywn/0FgCsy6+JTiwlP6+bJK/8lZR9qWgan+5U3/v+Yk5w/xLFWgrG08rDgd6j8gpbnd+C4p7Jxy/JoEDGh7c1PNz761aL3MrKiBFL9sqYutsOK3TuSsAPHCVvNsALlRi4fquEIvIpDZUeDSci1jI50YyeYel4h8WXPwDfvqrGnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AVYOaihAo+L4VZV3gL+xuu1qC8BnG5ThVsLtvrGNnMg=;
 b=gni/ANiOYlqi+2fNDi263h64WmK80cXAiFhEGD4l/2/rZL1eQqv5n5StXinDHoTCpWFB6VU+lVfEipYWtOnqtx6cveNjaDaRwN0YedcHfk5q4dQPplbJqERI1t061WVc/EjfnN7lTFzeewumnuV4UX9K86qnohIQjKlOSsUGt9LeDLvTtJryin3psPETt09zCCLbO3M08HxfQOPCfEpYgsjnJpB+IgJj3cxQ43S4T/mnMYoYIu2jO8LoHf1BbazV2V8nGb/0f98/VeH3Vt7NtJiBm8ciDRYiSx/bKqgSVqxDoU4kzwCHYm1oSRAbzWyzZCk/Z3had3yUllgeoVanTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AVYOaihAo+L4VZV3gL+xuu1qC8BnG5ThVsLtvrGNnMg=;
 b=NIK0w0Nl/++wgj2a0AektIlLBLsOajb+QjGdKpgqM/WTBDR/2WP0VxSLiEQ1lsDNOSW2CWGRHntizE6/qh0dV3ucibbZ4U4qrbJPq14ADrR7VfUgCuhCPx4gmrk4frldfvqhUalokozTjd7IDbr/xAYVwuI//NSGpxbqhz+/1YcTFNModuZT7Txee8rdsBqvEbYTjOe9LWeilDQv1WNKf/W57wDCVmz4tt8nnqyQAnXMM+JKjHgoVNUr/ViXFbFU9+5MxOqXOw5G/YgZVCJhmKPPAwTR2kS1mIJMQVujyurNgPYVYi8E5La127ANU5utDwsucww1ODjBrZVfeeYuMw==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by DS4PR02MB10796.namprd02.prod.outlook.com
 (2603:10b6:8:2a1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Wed, 26 Nov
 2025 19:47:27 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 19:47:27 +0000
From: Jon Kohler <jon@nutanix.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
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
 AQHcVDJryQXjlObInEG9J4YkYYZKUbTvzAyAgAJ4RQCABAmigIAA2pWAgAOxCQCACQYXAIAArPaAgABI5gCAAJ0GAA==
Date: Wed, 26 Nov 2025 19:47:27 +0000
Message-ID: <02B0FDF1-41D4-4A7D-A57E-089D2B69CEF2@nutanix.com>
References: <20251113005529.2494066-1-jon@nutanix.com>
 <CACGkMEtQZ3M-sERT2P8WV=82BuXCbBHeJX+zgxx+9X7OUTqi4g@mail.gmail.com>
 <E1226897-C6D1-439C-AB3B-012F8C4A72DF@nutanix.com>
 <CACGkMEuPK4=Tf3x-k0ZHY1rqL=2rg60-qdON8UJmQZTqpUryTQ@mail.gmail.com>
 <A0AFD371-1FA3-48F7-A259-6503A6F052E5@nutanix.com>
 <CACGkMEvD16y2rt+cXupZ-aEcPZ=nvU7+xYSYBkUj7tH=ER3f-A@mail.gmail.com>
 <121ABD73-9400-4657-997C-6AEA578864C5@nutanix.com>
 <CACGkMEtk7veKToaJO9rwo7UeJkN+reaoG9_XcPG-dKAho1dV+A@mail.gmail.com>
 <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
In-Reply-To: <61102cff-bb35-4fe4-af61-9fc31e3c65e0@app.fastmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|DS4PR02MB10796:EE_
x-ms-office365-filtering-correlation-id: 941276bb-7458-4980-d22f-08de2d24a0b7
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|10070799003|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?cnBnRE11d2Q1M3dudExwaTRKeVpzY1BBbVdnU3N4UVgrWmpTeFRjQkRCL0tJ?=
 =?utf-8?B?cTRicHlhUzhIRW4rVHBUWFA4T21UM3JxQkg1WHRwMWxDRTlwdW4xTTE1cGNS?=
 =?utf-8?B?eGg4R29vbktRQk9KWUhIbUJBaldXVjdacHY2MUVWSzJOUzhsREpYMzRKOXZ2?=
 =?utf-8?B?YTZsRUFlb2R1R0Rqa0U3U01Qd242UDBVKy9LdDU4MDJjTWMxZis5WjBWdUpD?=
 =?utf-8?B?cCttb0dkN3ROeVFqWHd6UmR2QkJCVW1xaFBoUFpUbDBSdGdkOS9XMVJ6K2JZ?=
 =?utf-8?B?NXNtRUJuT05XTkk0cElyWGpFZk1wUEdhdFIzRWZnSDdkYkRjWkJFZDg5dTI5?=
 =?utf-8?B?NTBLVkVjRUtvV09JSmo4NnY2bGE3TWM2TnhXeXpoWmdnMlRSckxYUEhTS2pK?=
 =?utf-8?B?czFNU1pOQ3JUMy9lSDBybm5kMnlqcGdGM1RLdENNY1h0QXN1WHlKWVRRRzIz?=
 =?utf-8?B?aC9xQVpYbVpLb3pKaFFpeHp6bHd6RzcyMnhPcEdiQzZta3FjcEQ3MFhpWlVO?=
 =?utf-8?B?ZExic1pIZzZ2akVBVUpKZWlaYjFDcGlIczZYTWdMVnJjd1J6eU9hc2tyaldl?=
 =?utf-8?B?U0dBeXR1WEhlT3FQV0hpazZPK3VLMHZlVVNGbnJaQTJKUktaNXZWY1NTeUo2?=
 =?utf-8?B?Y1Z4VG1JSElYMnpZdW1VRzBBeEpKRStJOWI0eHRlRVFvRVRhWXZkQXBYbWtO?=
 =?utf-8?B?T00xa1o0RlppQ3E3NW9tdEhWWnhZYW5UdWNsMlRsNi90L0xXVzBNZm9ubTYv?=
 =?utf-8?B?N25XZWFxc3R3dzRKc1VIODdZVXg5RFlDaVV6aGYvREpPdTl0RUFLZW5ld2JY?=
 =?utf-8?B?V2VMcXQ1VHlnZWUwMGs3OTRFSjlFSjY5emcra0IrMmU2NWhTU05NZHovNStY?=
 =?utf-8?B?R1VhQzFDUlE5T2FZUUlIaW9ualVvZzdaamxXc1lrK2pxQzJQQVhTc29rY01P?=
 =?utf-8?B?M09ENXA1M3RoZkpRWjlNcWlRbEkzZ2RtV2sxNElnd0JGL1F2N21lOEFaUEpK?=
 =?utf-8?B?bDV6SjBCZTVSYmRDdHFibGluM25lRHBJSHlTNEhxSHNsZmJwUE45TzJpWEo0?=
 =?utf-8?B?Z1Bqcm1RS2l4TVQybVZyaWNPdzIzcXU0N3N0cG9NeS9uK3pWMUVES3lDaDhy?=
 =?utf-8?B?SzZsVitGMk9WMjZNQnVpS1FFS1hURkVKSzBOQm9QdEdObVA5T1dwejBaUEhK?=
 =?utf-8?B?QUNEVmRTWTFHVWV4bTc5Y1BNRU93MjhreUswT2pwNEpFZnlHTU5udThPdTNm?=
 =?utf-8?B?YWovRmdvZ3pVbFBsbXU2bkFLd0l3aEUwVjJKdUtsdWpxRWV4eFR4S2gxUXdQ?=
 =?utf-8?B?ZVJkMk5FWTloazVaWDljLzZjTGV3MUhZemxvbjRHclFNNjlDY3NzVk51dlBl?=
 =?utf-8?B?NTdHdXFnM0UyY3pVQkJsU3RsMFdNeUR3azJLSmdIOHFxcmlLQk1Mb0w2Tlph?=
 =?utf-8?B?UzU3VUc3QWM2WHErbmFwUXR0aVluOHBSRkFqQ3FIMmxWUHUvdmczYmpWNlgy?=
 =?utf-8?B?THNBd1d3ODF4TERWSTJCS3VQRjVuNjdkV0tFUkpHbWtGSFRwVUZrN1ZzTWgx?=
 =?utf-8?B?dHJ2VGFzbW9uM2RySmtxYXU4elpuUUtLeUdUd01MSy91TGRSWnE2b1J4WDUv?=
 =?utf-8?B?VmVnRDdNUlJqOGdWNWVEYTk2Q3NsZjMvODJLaGdjOG9qenVtMC9YbHhDSS91?=
 =?utf-8?B?amJicGNLQkhtclg5Y2gxWkNKLzdGV3hEaUtqUUs4am94bnRQSHg4Ym5iMU1Z?=
 =?utf-8?B?MkRHV0JWQnVOanJVV0MvcWtjT1d6L0psOWhSMndlZlRJY1dhUEhRRm1ta28x?=
 =?utf-8?B?SEhYaGVDdEJEZTRBUmhFWWJmRGl1VlBpaW1YdlViMzd6M2ZacVpCZ0tGaGVl?=
 =?utf-8?B?MWwrYndZU3RJTCt2eG0xalQ3UFFWektraVNQRE1jYUJMUGl0azlRRDkwcFhY?=
 =?utf-8?B?d3R3SG9Uc04wczdSQUdhNmlFNVhpQzRjUlhSMjZjQ29SYTZJQTAveXl3N2FK?=
 =?utf-8?B?czlNTytpblpNc2ZiQlpYZE5CejNUaWViOHBVVWVicWNWSDZQSkQyMDZZVW5L?=
 =?utf-8?Q?RQJi3v?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003)(7416014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aEpNTXFxMWwwREpPMTRQamdKU25UZlMrRWRqVUNYSStZWXFzUmRNR1cycEQ5?=
 =?utf-8?B?VklBL1JSbUt4MVZtd2Q2N1AzM1kwYmsydk1UUGhnZEd6NnRFdWFSeGxUZGhq?=
 =?utf-8?B?blE3WTlicXFVbzB6dUYzSUx3VVlsZTZZNk1hS2pTZStqTlFhVkxrOXdWRWRK?=
 =?utf-8?B?TCtlaGw1SnowZy9iVlJOL0xaN0Y5bmMrVlNKNTlnb3ZhMHB1QmtjcSswL0Qy?=
 =?utf-8?B?UDA0TjB2WG1TWHlQdDBpeDZNb0Z3b2llUU01K0JaRjd0TWdncnlhdmVER3RN?=
 =?utf-8?B?MmsxL3UvcENLM08vQmV4RTFvUEE1RHNuTTRjem5yTmNBajZ5cWJEK1REbXZC?=
 =?utf-8?B?K0dCdk5XaVc3WjBMZk1Ib1F6dVpwelYxQlRlYUUzTU9peDhwTG12NzBVQkJ1?=
 =?utf-8?B?Sy9PS1U5d3RoODFiTlJjeEo0ek9JQzk5V1VWYVNRU1YxcFZDdW4vSXNvL1JI?=
 =?utf-8?B?bWVNdUR3aXlmVklpbUM5NEFncWNKZkRlK0VhQWFTUW1IQ1krRzI0QkhSeTR3?=
 =?utf-8?B?MmUrOG05bUhSVFpRbGRyWHpzeDlGVXFZbUhqN010Z055d2htNTk2UEx4Z0pm?=
 =?utf-8?B?S2VRaXpmNXNOZTJRQ2NyK2tVcU1mcVlGVExlNCtiK2JuWi92aGhWbm1QMDdh?=
 =?utf-8?B?NlRVR2pDWnc2UFplQmVua3hlaHh1WGw1WkRQbTNlQm5zdDg1emZlbmxmcDJn?=
 =?utf-8?B?cE4vMWRhdFVXTWYxOUlQRGZpUkFHWGJTalF6WXRCcjNUVVZLOEJCRGFHVzhm?=
 =?utf-8?B?djFSVVowenlWNWtBSWxyRmNqMGlRTlI1YjViOGRmK0QrQ2Jnam5CNGdPMVRI?=
 =?utf-8?B?NERHZzAxMnMyRkFUWDVRZjROcTAvbVpvaUUydWhnb08xRmpNYUFENGdVMEwy?=
 =?utf-8?B?M1lER2dhdCtidGkyMmgwS0M3ZkNQZUJyNjVmdEVGbytNa0lqQlB0NEJZY29l?=
 =?utf-8?B?MExXVzdQQnVTN0w1RE9CQ2xtd1M4QWRLUHlWcmk1Z2Uva2djTVNXUGVySG9Y?=
 =?utf-8?B?dEhVcnQ3OHkyTDE5WTUyR2p3ZE5UQ2s0TlZBVHAxL1U3VnRFMEkvSkVnYTls?=
 =?utf-8?B?eC9ONUR1U2sxT3hGSHl2WTRrSVNqb243U3RNVnUxdlRJcmdIQXphWlNKMStI?=
 =?utf-8?B?czJyd0U5OStmMWc5YXRUeU5rRkhOaHdFQjNTVTE2QU5rOGJWa0xSYUcvQlVL?=
 =?utf-8?B?bVdUVmF4SzVTV25teXRxU0hDRGVVdEljRyt6S3FUa2xXQjh4ZDJVNlBwdmhQ?=
 =?utf-8?B?bllZZ2puZDduQ1BHRmhJV3BDYTluaVlOY1grL1N4TTlUL3ZIOXpSc3RGQVFT?=
 =?utf-8?B?NWE3RVlDM01CbFNyVkoyeXVOdjFQM0NJS1hFblBwL2x1ZC9pS1pvdEUwVXBh?=
 =?utf-8?B?blNCR2pxWmc2VWg5b25HcWJMN2dTaElsSlYxcUhIdmJSdm4rRy94dVZWS1FB?=
 =?utf-8?B?cyt2WmZ4YVlCbW5HenBpcm9WeFZxaURqbmFyVVBiYWxMK0RwVTZqV3B2T3hm?=
 =?utf-8?B?a0JIVTAyTDMrcGN1Ynk0SWc3Nzg4c20wRE9kc0dRVWx5TE1SbHFxVTk0ZXZ5?=
 =?utf-8?B?cml1ZmVITG5aNTN0R1pyTDdKVFZoelE1ZUUyZCtlQUdLdGZNbnpxOEdTZmZm?=
 =?utf-8?B?M0s4T2tzV1hXV003Z0N3NHVGQ3RZMEhuREc3UUxCVVRqUWMyMHE5cDBZcW5t?=
 =?utf-8?B?dWhSWDE0azVMN0JXeFpseWdwUlZObjBJYkx1M3dGc0pSTzM2U1ppN0NUNHhI?=
 =?utf-8?B?cXk1QWQ1Zk1FZFJMbG1xQ3dZdTZxMko4UC9DVFhvUlcxbkNrY2JvZnlXRmZT?=
 =?utf-8?B?cm9XVGo2UVJySEM0Q0pRU2tsZ0JwMmJNd1hGdTZ2KzZRbUtVOG1DR2Q5bWRv?=
 =?utf-8?B?dzhnOEJkNUI3TFlQblZCS1J6RTJRY09EZHplQkpXQmNqUjEyMHI0SUlqV0o5?=
 =?utf-8?B?K24xSTdpVGhYZUdQUlZsN2RqSzhPSGsxYldobThOREwzdG5pYk9QKzI1blNB?=
 =?utf-8?B?dzc1MmhlMEo2NjZwSWJ2VldSMzJYYmRKRFBhV1Y2Y2dPYk15VmVaVE1HNUMz?=
 =?utf-8?B?NmxuZGIzTHV2MGF2ZExCRUFmTUswMDZiTDNRZ05sOGNwL0VFU2F1Z0RXVDZx?=
 =?utf-8?B?ZmZCZ1MwUzUvNDJ2NlJkZUNPNSttM0loQ21CbFk1L0gvQzFOUGN6OVdpZFdl?=
 =?utf-8?B?USt2bGVPd2dWRkFNeEwranA0NDBWVnBTL2tWYUNqaE5IdE5sSFdYTWpwalNi?=
 =?utf-8?B?d1d6M1NUeVc3M1k1YW1mZ0I2NkpRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5559BC732E75F04DB98975ACA701FC13@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 941276bb-7458-4980-d22f-08de2d24a0b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 19:47:27.1132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 553yZwNWiczX5F2FxZUsPaAp5fpkz1foaPgOTyvcv/JjUXogxGSV0nz2zRGCcPTOkKm2xyA9n1QAVC1bpbIAaLQk6yvw5jd0m8niVKkFvO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR02MB10796
X-Authority-Analysis: v=2.4 cv=b8+/I9Gx c=1 sm=1 tr=0 ts=69275954 cx=c_pps
 a=fuZeKWo3Wg5M7x5zI0EODQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=KZv23IMG96AzpEOYFaQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE2MSBTYWx0ZWRfX66frrIE/KEOg
 ONflS9DjV67Dh98u0oaj7HdFrgljxFMJjMP7rIXitpkmyBOGc1IIvGrlzXOx4bPzHTQ+5Iuowoo
 rV1wGjGkOFPiYjJSVRuDMZ0gQuwYhC3d0R+pVVmoHSLsZgXzqvjinAFk3/NOwXgEH5HmH5wwUbR
 JhC9jrCu1x/KpqDmtD4I64EMxT6pcs1HVV/5Q7cUVbMDhyKEO7j0o9dMDw3gu+JsHbrQ08vVK8d
 A/xKO3fA1bxur5TNEbVXULxIJ8G2xV5uLaBfNrrKhE7eWTg6+L4oc2/eFXJ7h9gA0QMnjJBaxQo
 ca8H+tXP1Ppc8+bTvFMokZF7cyIjb4nhYgL3OrRIAikK3uX1BjpBgLqOaTRkvj01mTtzPg2vr1L
 TrXS3fQPmABF/+3ssEf2ydpy/bgc/w==
X-Proofpoint-GUID: rccczYN6Sd8DA9oQhB89vwLLEuhJZPrf
X-Proofpoint-ORIG-GUID: rccczYN6Sd8DA9oQhB89vwLLEuhJZPrf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCA1OjI14oCvQU0sIEFybmQgQmVyZ21hbm4gPGFybmRA
YXJuZGIuZGU+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBOb3YgMjYsIDIwMjUsIGF0IDA3OjA0LCBK
YXNvbiBXYW5nIHdyb3RlOg0KPj4gT24gV2VkLCBOb3YgMjYsIDIwMjUgYXQgMzo0NeKAr0FNIEpv
biBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+Pj4+IE9uIE5vdiAxOSwgMjAyNSwg
YXQgODo1N+KAr1BNLCBKYXNvbiBXYW5nIDxqYXNvd2FuZ0ByZWRoYXQuY29tPiB3cm90ZToNCj4+
Pj4gT24gVHVlLCBOb3YgMTgsIDIwMjUgYXQgMTozNeKAr0FNIEpvbiBLb2hsZXIgPGpvbkBudXRh
bml4LmNvbT4gd3JvdGU6DQo+Pj4gU2FtZSBkZWFsIGdvZXMgZm9yIF9fcHV0X3VzZXIoKSB2cyBw
dXRfdXNlciBieSB3YXkgb2YgY29tbWl0DQo+Pj4gZTNhYTYyNDM0MzRmICgiQVJNOiA4Nzk1LzE6
IHNwZWN0cmUtdjEuMTogdXNlIHB1dF91c2VyKCkgZm9yIF9fcHV0X3VzZXIoKeKAnSkNCj4+PiAN
Cj4+PiBMb29raW5nIGF0IGFyY2gvYXJtL21tL0tjb25maWcsIHRoZXJlIGFyZSBhIHZhcmlldHkg
b2Ygc2NlbmFyaW9zDQo+Pj4gd2hlcmUgQ09ORklHX0NQVV9TUEVDVFJFIHdpbGwgYmUgZW5hYmxl
ZCBhdXRvbWFnaWNhbGx5LiBMb29raW5nIGF0DQo+Pj4gY29tbWl0IDI1MjMwOWFkYzgxZiAoIkFS
TTogTWFrZSBDT05GSUdfQ1BVX1Y3IHZhbGlkIGZvciAzMmJpdCBBUk12OCBpbXBsZW1lbnRhdGlv
bnMiKQ0KPj4+IGl0IHNheXMgdGhhdCAiQVJNdjggaXMgYSBzdXBlcnNldCBvZiBBUk12NyIsIHNv
IEnigJlkIGd1ZXNzIHRoYXQganVzdA0KPj4+IGFib3V0IGV2ZXJ5dGhpbmcgQVJNIHdvdWxkIGlu
Y2x1ZGUgdGhpcyBieSBkZWZhdWx0Pw0KPiANCj4gSSB0aGluayB0aGUgbW9yZSByZWxldmFudCBj
b21taXQgaXMgZm9yIDY0LWJpdCBBcm0gaGVyZSwgYnV0IHRoaXMgZG9lcw0KPiB0aGUgc2FtZSB0
aGluZywgc2VlIDg0NjI0MDg3ZGQ3ZSAoImFybTY0OiB1YWNjZXNzOiBEb24ndCBib3RoZXINCj4g
ZWxpZGluZyBhY2Nlc3Nfb2sgY2hlY2tzIGluIF9fe2dldCwgcHV0fV91c2VyIikuDQoNCkFoISBS
aWdodCwgdGhpcyBpcyBkZWZpbml0ZWx5IHRoZSBpbXBvcnRhbnQgYml0LCBhcyBpdCBtYWtlcyBp
dA0KY3J5c3RhbCBjbGVhciB0aGF0IHRoZXNlIGFyZSBleGFjdGx5IHRoZSBzYW1lIHRoaW5nLiBU
aGUgY3VycmVudA0KY29kZSBpczoNCiNkZWZpbmUgZ2V0X3VzZXIJX19nZXRfdXNlcg0KI2RlZmlu
ZSBwdXRfdXNlcglfX3B1dF91c2VyDQoNClNvLCB0aGlzIHBhdGNoIGNoYW5naW5nIGZyb20gX18q
IHRvIHJlZ3VsYXIgdmVyc2lvbnMgaXMgYSBuby1vcA0Kb24gYXJtIHNpZGUgb2YgdGhlIGhvdXNl
LCB5ZWE/DQoNCj4gSSB3b3VsZCB0aGluayB0aGF0IGlmIHdlIGNoYW5nZSB0aGUgX19nZXRfdXNl
cigpIHRvIGdldF91c2VyKCkNCj4gaW4gdGhpcyBkcml2ZXIsIHRoZSBzYW1lIHNob3VsZCBiZSBk
b25lIGZvciB0aGUNCj4gX19jb3B5X3tmcm9tLHRvfV91c2VyKCksIHdoaWNoIHNpbWlsYXJseSBz
a2lwcyB0aGUgYWNjZXNzX29rKCkNCj4gY2hlY2sgYnV0IG5vdCB0aGUgUEFOL1NNQVAgaGFuZGxp
bmcuDQoNClBlcmhhcHMsIHRoYXRzIGEgZ29vZCBjYWxsIG91dC4gSeKAmWQgZmlsZSB0aGF0IHVu
ZGVyIG9uZSBiYXR0bGUNCmF0IGEgdGltZS4gTGV04oCZcyBnZXQgZ2V0L3B1dCB1c2VyIGR1c3Rl
ZCBmaXJzdCwgdGhlbiBnbyBkb3duDQp0aGF0IHJvYWQ/DQoNCj4gSW4gZ2VuZXJhbCwgdGhlIGFj
Y2Vzc19vaygpL19fZ2V0X3VzZXIoKS9fX2NvcHlfZnJvbV91c2VyKCkNCj4gcGF0dGVybiBpc24n
dCByZWFsbHkgaGVscGZ1bCBhbnkgbW9yZSwgYXMgTGludXMgYWxyZWFkeQ0KPiBleHBsYWluZWQu
IEkgY2FuJ3QgdGVsbCBmcm9tIHRoZSB2aG9zdCBkcml2ZXIgY29kZSB3aGV0aGVyDQo+IHdlIGNh
biBqdXN0IGRyb3AgdGhlIGFjY2Vzc19vaygpIGhlcmUgYW5kIHVzZSB0aGUgcGxhaW4NCj4gZ2V0
X3VzZXIoKS9jb3B5X2Zyb21fdXNlcigpLCBvciBpZiBpdCBtYWtlcyBzZW5zZSB0byBtb3ZlDQo+
IHRvIHRoZSBuZXdlciB1c2VyX2FjY2Vzc19iZWdpbigpL3Vuc2FmZV9nZXRfdXNlcigpLw0KPiB1
bnNhZmVfY29weV9mcm9tX3VzZXIoKS91c2VyX2FjY2Vzc19lbmQoKSBhbmQgdHJ5IG9wdGltaXpl
DQo+IG91dCBhIGZldyBQQU4vU01BUCBmbGlwcyBpbiB0aGUgcHJvY2Vzcy4NCg0KSW4gZ2VuZXJh
bCwgSSB0aGluayB0aGVyZSBhcmUgYSBmZXcgc3BvdHMgd2hlcmUgd2UgbWlnaHQgYmUNCmFibGUg
dG8gb3B0aW1pemUgKHZob3N0X2dldF92cV9kZXNjIHBlcmhhcHM/KSBhcyB0aGF0IGdldHMNCmNh
bGxlZCBxdWl0ZSBhIGJpdCBhbmQgSUlSQyB0aGVyZSBhcmUgYXQgbGVhc3QgdHdvIGZsaXBzDQpp
biB0aGVyZSB0aGF0IHBlcmhhcHMgd2UgY291bGQgZWxpZGUgdG8gb25lPyBBbiBpbnZlc3RpZ2F0
aW9uDQpmb3IgYW5vdGhlciBkYXkgSSB0aGluay4NCg0KQW55aG93LCB3aXRoIHRoaXMgaW5mbyAt
IEphc29uIC0gaXMgdGhlcmUgYW55dGhpbmcgZWxzZSB5b3UNCmNhbiB0aGluayBvZiB0aGF0IHdl
IHdhbnQgdG8gZG91YmxlIGNsaWNrIG9uPw0KDQpKb24=

