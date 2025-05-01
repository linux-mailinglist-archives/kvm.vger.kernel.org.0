Return-Path: <kvm+bounces-45009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DF1AA5960
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 03:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1889C3B8B57
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 01:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C27181EF092;
	Thu,  1 May 2025 01:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="0FSylQMq";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZC+bdiEE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9A61E9B0F;
	Thu,  1 May 2025 01:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746062503; cv=fail; b=YsvsHSm658TMhXUQJg2VFbbBl4hqPNJl+8Bub3Ri0eO3j4iQjOiFNbimQ39CARVxQB14Ux62vBxpjUbaHSna+802vJtNMAkTwk8X8D95lOa3xre9ADQLhnuaN3Z6Dl5TqsyDhprcSJ88oXeVYBicgjNBIIg/jfLzL6j96o7nipM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746062503; c=relaxed/simple;
	bh=qlJyNDWyhU+KY0bERgHvIpKXQ2cnBP9bmG1/5aaNhjU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CI2a7p4BAWIS1Y/b5KSaSfgvAQ2KyEuNfs6kkZigZ7Dbb+kC/lodyRm3Jr0fUakqzdX5yUtA85pkcSXqoV0swh4wFlMyXFAz6+AITB0Tdzjf6b1SrTdKiqcTSRWyHqhUUbRTM5mo2JtFvMw8ga3GokGoPxTy/ULFg0f2glUCmk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=0FSylQMq; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZC+bdiEE; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53ULWHxf007026;
	Wed, 30 Apr 2025 18:21:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=qlJyNDWyhU+KY0bERgHvIpKXQ2cnBP9bmG1/5aaNh
	jU=; b=0FSylQMqiLjJQN9pFevo32ggsQjTnvdamfjfTikFWqVwDdze7vWgGtXk/
	QXmbcQbCQU0ws0boob0yJpp0YCJlLT0nCZrsPjR2nMMafVemqAJ8UokuV6LsmPfh
	lVmIf0l1lx0QSLsbElhA0jmnGbPESWdLmFuIax+ukS2nTzHGYLBpSmlW1jUePrwZ
	m3tFx2sMnx7XuQaKpHrA8RcalVipavXh3msI3Wd89QUTH1mZM9fMEX3y/Ds2KMhm
	omtjx13Na3PRV8JmTQP/rcgxy7t32geApnHnoRQXFJF+izDRX2BSD/QYoMVSnGBd
	+BEZE+B8/8aivmA5uxP+zffE37+yQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazlp17012039.outbound.protection.outlook.com [40.93.6.39])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46b9g62x9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 18:21:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w+XG1dlp6gP2NBtAhoIfypxbtgAcyuuy55MV00hfJjokNGmn/mnrcaYHi1KdGUP9aQ1D73+uef5B3y0xO9YREu1gdmjIDUFS3Pj65NNStZiaFAEgZVPXChbyG5I6CJrSWyI2EblrEChlg16XFDbhQ7e+lb0Eyqk9KpdVSeC1yEk7+8N+pNroW/LtKVU1s2jYH9F3Vyoc9EedfKWqfsg5ais0bCtsKwwl4Ers/QPBqMWMvh/ghvKsOxVgjZLmGk721uieK1+oYVq7DSM1D1qFvFP2zGprL6q121PqTUKNVEGZFBp3Otzyplv/Jatu6Ll7Ulgs94TVyMW7WZViALHmwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qlJyNDWyhU+KY0bERgHvIpKXQ2cnBP9bmG1/5aaNhjU=;
 b=Cu/v6SnUfyIyFh0mekJvezhJYl8l+S9WxVjzu0kaCjP3APqWiX1VyG6tlOPpP5HYTX4bh88mg0LIC3lTPbsoiHA/mQqqzWOgLOZCAbpZmCh1ANugoKRJBtMYk/rnysBs3z5V+XR5H5GXjR4zs46nYDrGBzpNoJbodNSbuoiH98k8pF32P1WYgnIN07tt7XJ3AWV+1o36qPIVnaokGNKGSjLU+EqHiW8ntF/vir4Eo9YAxVyI+rb22fP6GQsBic6cc6pBcDPbkZ/qLi360ehC4Jb0bW2TrKgUgm+utIGyFLKrwLA/hJvTntv3oNPyDnGjxZ5Yhktkx+X1h8Mhb3RpcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qlJyNDWyhU+KY0bERgHvIpKXQ2cnBP9bmG1/5aaNhjU=;
 b=ZC+bdiEEwuIRkafW2SM1hjfgFUL3qU0KG7qIio0snhTG49naTKXJTLU75lnh0YWh0MZwLGpWiHFyu1pfRkifZurjFG8okCabJakXgz4TREgcpMqthOIB/H2W9cOxqU2RKWKKiWHkWrio5f4P7wf/8NUXYedvEK+cNNgf0TNahBHMMs4Aigq373jdAR6db+xFi64CD8UjBYOIYmi7WzUuFQ1uJaKVOR7hJy6WgMOogR63je+cO5eaavLvjsOxlzQASU7weaIqVvZ0MHgLHoHBsTjSyGHlkly/FXQ/dzCBmr416b3eKDGctvITLL7U8SGo4POROOeAY5GJ7LSikQDsXg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by LV3PR02MB10126.namprd02.prod.outlook.com
 (2603:10b6:408:1a4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.18; Thu, 1 May
 2025 01:21:31 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 01:21:30 +0000
From: Jon Kohler <jon@nutanix.com>
To: Eugenio Perez Martin <eperezma@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
Thread-Topic: [PATCH] vhost/net: remove zerocopy support
Thread-Index: AQHbpW031K1yxtchPk+rB14ra05W57OXetWAgAGCcACAAFaRAIAM0lgAgBb9pwA=
Date: Thu, 1 May 2025 01:21:30 +0000
Message-ID: <92470838-2B98-4FC6-8E5B-A8AF14965D4C@nutanix.com>
References: <20250404145241.1125078-1-jon@nutanix.com>
 <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
 <B32E2C5D-25FB-427F-8567-701C152DFDE6@nutanix.com>
 <CACGkMEucg5mduA-xoyrTRK5nOkdHvUAkG9fH6KpO=HxMVPYONA@mail.gmail.com>
 <CAJaqyWdhLCNs_B0gcxXHut7xufw23HMR6PaO11mqAQFoGkdfXQ@mail.gmail.com>
In-Reply-To:
 <CAJaqyWdhLCNs_B0gcxXHut7xufw23HMR6PaO11mqAQFoGkdfXQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|LV3PR02MB10126:EE_
x-ms-office365-filtering-correlation-id: d7eaf8f4-0595-4a7c-a520-08dd884e80e6
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|10070799003|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N1Q3TjdEQjIvclVIcFpPVVA0SDJsTFFRNThSODlTdmdvbGpJZGhHTlNRSVpZ?=
 =?utf-8?B?dFhkMDFzb1FjdHpZTEdNaGZ3ZDNqZFJRZWhtMmJ3bEF0NFdiUDN1Z1Y2enJ6?=
 =?utf-8?B?QUlheGZkclBsNkxyemJrdlEzV1Y1cGlHbDIwR1RrNG9waDlXQXFGMEd0dEt4?=
 =?utf-8?B?WGthL1VkUU1wc2UzWlJrYWlCZm5CdStVSVhQMWZaSmFmL0E4Q2hNQTZDajVG?=
 =?utf-8?B?bGhYUG1yYTdnbm9maGJGK214STR1VGljS2g2d3FSRWlZSDAzWFRQWTBidm5W?=
 =?utf-8?B?aDhnRlZKR3RyU0ZuOXlHcnkvWnRQcDYxQlBKeVp5TDFGMklQcXBLZ0l1ZE9O?=
 =?utf-8?B?UThteHZwU2hhUU1mMStEaTUyOElYRStpVG0zMEh4dng5eVZMS0tsQ3Fza08z?=
 =?utf-8?B?eHU3OWtxSC9QZFFnclZmNFE3VzVLdHNia0s2dEk5cVVoc0wwUWd2V2dtUUJp?=
 =?utf-8?B?WHRpYk1VVkF6c29qWmIreFFoWDBjaGsyNmgzRTVpeW9URStzSmkyVVd2bnVq?=
 =?utf-8?B?NWpTSXFoU3pNM3NMRndJSjAwSTVMbVF1UmpLTlpWTmxwKyt2bjllWDJNeHBq?=
 =?utf-8?B?MFhpS1pRKzBEUGVFZU15OFVSNG1EekxtbStlK1BLditPd29ISmV1UDlLZlhK?=
 =?utf-8?B?TzYxS3VkQzZNblgxZ3pNRkVRY2J1Zklod2Jva2w5WENsZmVENVExNUl4Tjdv?=
 =?utf-8?B?YmlINjNZNEtYVUZ3YlAyallvY1p3amNMemg5TWkySW1pRzQxWEhMOHZPSnpl?=
 =?utf-8?B?cGhqd01KalorUmxPVmpIWFg4NzZFdko3SUlNQUxzWVVzREFrZjVzcXRkbHhh?=
 =?utf-8?B?czFudGRvUTY5aTdJTDRvNTRBYjBXMm4vbmxFZkdQY1M1TU1RYzhRa29TbXBG?=
 =?utf-8?B?ZlFnRU4zRWZ1U3JHNzFncmV6Ymp2ZVg0SkxTUXdaSllWWERoY3NtTEhmOFdn?=
 =?utf-8?B?dVVaaHI2czZ0cHRWa3FNdUErRHVkK2doakxGSFNvUHBCVEpKVVZPWTlnK215?=
 =?utf-8?B?ZGlMVld4bFYxZ0lkL2ErN0lCcmN2OUZQbVdvNEhlK0VEdlNBbmtkeW9xaHNv?=
 =?utf-8?B?SUdXMmMvbHFodEw3eXhTMXgyeDBROFh6RkFTU0hDUEpqSzhtWWk4SGFjdGda?=
 =?utf-8?B?YVdjbHNRSXdHa05ONXlDZ2NkRkJ2NUZobUdJVElDMGxkUWV0ckJtSVNCcVJm?=
 =?utf-8?B?WmIwLzZYalJ3dCt2Q1BWK0oxaDVUQllaZ01TSFNTUEVDdU81aVBlK1drdHRp?=
 =?utf-8?B?dWRHSVRNRngrM3NidDI0UlNpQnhWOUFWbFdoZzdhSmJ3dVRSV2ZHUG94eTNV?=
 =?utf-8?B?MkJuUTNDZ1V6U2lxS25ZNWFsMHBOOHlFNWs1TmlPWk0wUUEzL2MxYTI5N2wr?=
 =?utf-8?B?eHhHVUJxMHlUcGgrZW9rZmpMOXBIaWlheVRXaGExUVZLQUE1eGtjL3RMOVFv?=
 =?utf-8?B?cUQwVkFVTllsTzByRUxkUU1wMjlVekNENmRld2I2clF1WmhieUVoTWxIWit1?=
 =?utf-8?B?eEZPb1BLeXcwVjE5UjhpYmNZcGFNdi81ZVpIL2NrZ3ozZEtZeEVRVk56RGJm?=
 =?utf-8?B?V0xxK2hJYU1tdUZZbXVaeUErNzk1K0hlZktEM2ZaOFhEZzVOUlE0UkFBVjgw?=
 =?utf-8?B?YzdYbkEybDJibDJKY3dCQUpIdXpzKzlFdDArd3gwODdZWnBLRkVZTUFrNTFB?=
 =?utf-8?B?RWxJdFdIb1UyOGtBb0twS1dEVUJFaUlKQkpYaGRwVlQyL0srK1RCQTF6UlhM?=
 =?utf-8?B?eTkzMXlLZzFReXFJYkZnU0x3MkJqYnZaN1B1Q2E3SXNDRTdoanNJVTQrYlY1?=
 =?utf-8?B?SXdQalNEbE5DQ1U5VzZ5eWxaZW9YdDRnYnl3R1RPRlJYRDNIcmIrdjd5ZGM5?=
 =?utf-8?B?R0c5V3dBTWx6WEpFcDMrbTh3VmM4SlArNnpHY3lMbjRHdUhST1JoS1R1aGJy?=
 =?utf-8?Q?zlnhsyp9B6Y=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WlBnaDNzMmJnNE5uUjhWdFE1VGVwbHlDbCtUQ1Yzb0ZDcXFFQjIzVWtJL1Bi?=
 =?utf-8?B?VjZmL21uMGhRTGZERjViK3puMnJHVkNGRXU5UHIzMXMrSEtCSEUrbXptQUJs?=
 =?utf-8?B?UG9jRDREd2puZ1NnaTQvV3UrNXdGZWsrR2pRUEFPb2lITkZxM2xXU3hGUHU2?=
 =?utf-8?B?RkFYbU5BMHZkdkhEaHMxQ1g0L3FKRTRUK0xEbHBaVzA2Qm9NYXVsUUpFOHJa?=
 =?utf-8?B?djc4aGFrWm0wR0FwRWNnaGdLWGZTanY5ZlR1aFk3T0pxRERkckNucUdIbU1T?=
 =?utf-8?B?eFRXUjZ5bGtZTGxwTktwL21USWVRMjhCMVlHTFB5cTRhTjRGZXNzKytFTSsv?=
 =?utf-8?B?dDFyak8wQUZ2dG11N0o2UG1hSzE3UEVIdFVuNVQ5VXVycVdqZ1JYZE5BQTk0?=
 =?utf-8?B?TWdSTnZ2RS9MeFVSOGN4V0JFc1RiVDdhMTBPNG51V1grQUZ5T3piUzcvQ0ZV?=
 =?utf-8?B?YkJzT052eUgvRUxtL1JTRHdJNCsvNkdGVTZISlRqdDNUZWR6WVFkZWFDMmp3?=
 =?utf-8?B?Z280eisxeTNVZ3lGbWd0eUpyNElJclBYZ0Y3ZDNQRWpIcU1BTTJUcTUyaURk?=
 =?utf-8?B?V3VXTnlDL1QwMm4xckpnMjc0Y3A1cFJuY3llaldUMThwOVNISUU4ZitQSDN3?=
 =?utf-8?B?WWEyclZIQjg2NkhlSkp1YmhDZVoxV0pvYmJKRm9VWTJnUWVHc0pWd1Blck4w?=
 =?utf-8?B?T1hxTFdCS3RORzVqQlpZMjJlWlJxMzYzYStDdEozSXFINUFCaHhXeWgxY0Vn?=
 =?utf-8?B?enNhNmFobVhJYTdIcG9oeWdld1JzRjlRSDBidXV6K3VPVnQ3eUVrY2ZwZERY?=
 =?utf-8?B?eHpUK3pwSWpyM0lGa2cwc3g0dk9FYVMwejdpMUFoK25VU29KR1Z5MXA1dEpr?=
 =?utf-8?B?MG9WcGJPbThZcU5lMDNMeWFUNUpXN0VYTDNxMTBvdDMzL29uZVR3a3BmSVpO?=
 =?utf-8?B?dDNmNVVJZ0pVTjhYVWNTL3lhQ2xJZXFZQnBhWTVoUk52YzJncmhNa2tzTGwx?=
 =?utf-8?B?YUtYVXRwOEkrL3p1QnUzdDE3dnhkMTk2b3I5L1ZHcFl5U2ZWeVdEM0xZUnJT?=
 =?utf-8?B?bTQxeGRzMGtmV0pkNzdCTW9EakVidWs4ZktEVmI5ZWdWUmlacitKeTc1ck9N?=
 =?utf-8?B?NEpoQXdUc3Buc1pNNUlvOGVlRGNvdkpreDVwMHNGc0RpVzlEQnJWYzlHb0dB?=
 =?utf-8?B?MlZtQ2x5ajhIOEJJRzhsYmtTU3RJUEg4aFNMR1hxd3NCNkVNMXZLN3VIbkJS?=
 =?utf-8?B?VXlORkpybkdpbFAvYmIvME9mRVVsV09KWVRrUnp0YXlCTk1ubFQ5NU5oRmhB?=
 =?utf-8?B?dDEzcVZOMHpUdTVpcVB0QUgzRzRTN2dlVXFsb01nRS9SL3dHTlowR0FtZkR0?=
 =?utf-8?B?elUzVGtFQjBNczlVbDU4WGsrM0J6eURPU1J1RVA4Vi9wWVA4ZFZnejBVUnBl?=
 =?utf-8?B?K3cxNXFJV1duZGRCZ1Z3dWhBT1J5ZHFhcE11Q21UYnNYMjRxSU9wYmUwMTAz?=
 =?utf-8?B?Y1k0QXRGZ3NybHZpNjNVcjFsVFl2VTJuYjhOeTd0RlpjR2NBTkgxNXpVSUd6?=
 =?utf-8?B?eTJ3ZXozcGRWQlpNWjErMDgrYnQxRjgrTDQ4MVRvS0NqSW5EVzJHV1VoTEhU?=
 =?utf-8?B?NnlZbHhBSm1vc2hPRzRLaHBZcXc5Yk96Mk1jamYzZnMvQ0tIY09iVVRONEVz?=
 =?utf-8?B?Mms2TW5JRjhoNVRaTGg5eUw2MVpXd3prWWZPdWFnNnp5cEVIUGJieFNVd29E?=
 =?utf-8?B?Q2cwRHFFQzU2d3BxaGNVSjVRVUFScWVLUWpqd0RjOXhEVXhxY1lWcHducmVL?=
 =?utf-8?B?WUEvV2V1RjRlN2VRczYxOFVobGdMdGZBQWhzMDRzakJGNkdwZkNIamxCa2hp?=
 =?utf-8?B?VE44MTZBbVNnSE53b1lDMWFPZmd0TGxWa0ZkQ3VUUExOK0g0bE5oVUZYTHd0?=
 =?utf-8?B?VDRhSHJ2WGxYYmZxL2grQXRrNW9sSVl5azhzd2VqWjNxR2NIVmZueGt4bTZk?=
 =?utf-8?B?TWp5WmR2Z2FzUmFrZGE2bjVIeWtsTUk3YXJXZEFEN0ZpbGcwRHhPbEVDWXZx?=
 =?utf-8?B?R24zS0ZNYysyM2tKRTNLcVhkcGh1cHJNR0N3L2lYZXN0c2lLRlVIc3RueEtz?=
 =?utf-8?B?NDMwNDlNTHFuc2dBNkJLd3lpZTJIZTRhMDBQOVJ6S2g0aC9Cclp2akM1OW5Z?=
 =?utf-8?B?UDBUTVgxdHpIM1N3RXpFZ1pJaEZFMC9obldsSnpuQy9tRFV1R29RSGgxU011?=
 =?utf-8?B?R1o0WWhlaDQ0UU1ITVVlOVRFVDBnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F6FB4B20559D28438FDB5C33D21D4B4F@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d7eaf8f4-0595-4a7c-a520-08dd884e80e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2025 01:21:30.7680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hCsVvu9+E5kFAsKKPncLGVdgQ1wXRQJbwBt7I7oEMGDK/FwCURx17p3vldub9z5+kXF+Al2TFDBTRrVtN7mpAoBxynx0tFqS33iCPIa0EQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10126
X-Authority-Analysis: v=2.4 cv=GolC+l1C c=1 sm=1 tr=0 ts=6812cc9d cx=c_pps a=VIUGDxI8SzY5XGtng4SOXg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=NEAV23lmAAAA:8 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=fDwPaSKcQTzUc2C-LHcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: xSIkmhX7gzS5Go7gDtEr3xdVCHbvmhew
X-Proofpoint-ORIG-GUID: xSIkmhX7gzS5Go7gDtEr3xdVCHbvmhew
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAxMDAwOSBTYWx0ZWRfX/JHjxkAjuDKc LN039juQJln3Xn76s13zEaUF6F8w49uA0UCg4Lqodh4iLCJ+v3ryEJ/Q+l8wmPwujrPxtJcebGq lWezcRqTds0UIDEl7+5b1LyJkfuBE3F/sKj4PIqjPAyq+8ZnGbkiwcxVveD5Ep4xylje8l4Ohm6
 US+Zp/hUFr7R2YF6tpBekvQTFzDiN9x+fOH3grNbGoTrYX2bun3beWD4MX9rF0uz159yUKwZbDS TcJgmOH7HtwVk+o5tEiMhTfrEyXp45FFwV2JhbA8hNlDUTCHvpp1bygDBEMPJrU0acA1lV9Z/6d 2aJAsWCXC2+MD4vMF2Nvl4ot5FYnh1ytFBvj6bJgLp1V/F5qSjI8gUgEtLFTkduryGGqlfyBuLb
 Ss53cjiTHra5g0sd4fhq+FTxU7NfP13Ys94cXWYOlpKcEYmxHMx5k0NFK/faYiSyHMjigN/F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-01_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDE2LCAyMDI1LCBhdCA2OjE14oCvQU0sIEV1Z2VuaW8gUGVyZXogTWFydGlu
IDxlcGVyZXptYUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FV
VElPTjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVHVlLCBB
cHIgOCwgMjAyNSBhdCA4OjI44oCvQU0gSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4g
d3JvdGU6DQo+PiANCj4+IE9uIFR1ZSwgQXByIDgsIDIwMjUgYXQgOToxOOKAr0FNIEpvbiBLb2hs
ZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gDQo+Pj4gDQo+Pj4+IE9uIEFw
ciA2LCAyMDI1LCBhdCA3OjE04oCvUE0sIEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+
IHdyb3RlOg0KPj4+PiANCj4+Pj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+Pj4+IENBVVRJT046IEV4dGVybmFs
IEVtYWlsDQo+Pj4+IA0KPj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+Pj4gDQo+Pj4+IE9uIEZyaSwgQXBy
IDQsIDIwMjUgYXQgMTA6MjTigK9QTSBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+IHdyb3Rl
Og0KPj4+Pj4gDQo+Pj4+PiBDb21taXQgMDk4ZWFkY2UzYzYyICgidmhvc3RfbmV0OiBkaXNhYmxl
IHplcm9jb3B5IGJ5IGRlZmF1bHQiKSBkaXNhYmxlZA0KPj4+Pj4gdGhlIG1vZHVsZSBwYXJhbWV0
ZXIgZm9yIHRoZSBoYW5kbGVfdHhfemVyb2NvcHkgcGF0aCBiYWNrIGluIDIwMTksDQo+Pj4+PiBu
b3RoaW5nIHRoYXQgbWFueSBkb3duc3RyZWFtIGRpc3RyaWJ1dGlvbnMgKGUuZy4sIFJIRUw3IGFu
ZCBsYXRlcikgaGFkDQo+Pj4+PiBhbHJlYWR5IGRvbmUgdGhlIHNhbWUuDQo+Pj4+PiANCj4+Pj4+
IEJvdGggdXBzdHJlYW0gYW5kIGRvd25zdHJlYW0gZGlzYWJsZW1lbnQgc3VnZ2VzdCB0aGlzIHBh
dGggaXMgcmFyZWx5DQo+Pj4+PiB1c2VkLg0KPj4+Pj4gDQo+Pj4+PiBUZXN0aW5nIHRoZSBtb2R1
bGUgcGFyYW1ldGVyIHNob3dzIHRoYXQgd2hpbGUgdGhlIHBhdGggYWxsb3dzIHBhY2tldA0KPj4+
Pj4gZm9yd2FyZGluZywgdGhlIHplcm9jb3B5IGZ1bmN0aW9uYWxpdHkgaXRzZWxmIGlzIGJyb2tl
bi4gT24gb3V0Ym91bmQNCj4+Pj4+IHRyYWZmaWMgKGd1ZXN0IFRYIC0+IGV4dGVybmFsKSwgemVy
b2NvcHkgU0tCcyBhcmUgb3JwaGFuZWQgYnkgZWl0aGVyDQo+Pj4+PiBza2Jfb3JwaGFuX2ZyYWdz
X3J4KCkgKHVzZWQgd2l0aCB0aGUgdHVuIGRyaXZlciB2aWEgdHVuX25ldF94bWl0KCkpDQo+Pj4+
IA0KPj4+PiBUaGlzIGlzIGJ5IGRlc2lnbiB0byBhdm9pZCBET1MuDQo+Pj4gDQo+Pj4gSSB1bmRl
cnN0YW5kIHRoYXQsIGJ1dCBpdCBtYWtlcyBaQyBub24tZnVuY3Rpb25hbCBpbiBnZW5lcmFsLCBh
cyBaQyBmYWlscw0KPj4+IGFuZCBpbW1lZGlhdGVseSBpbmNyZW1lbnRzIHRoZSBlcnJvciBjb3Vu
dGVycy4NCj4+IA0KPj4gVGhlIG1haW4gaXNzdWUgaXMgSE9MLCBidXQgemVyb2NvcHkgbWF5IHN0
aWxsIHdvcmsgaW4gc29tZSBzZXR1cHMgdGhhdA0KPj4gZG9uJ3QgbmVlZCB0byBjYXJlIGFib3V0
IEhPTC4gT25lIGV4YW1wbGUgdGhlIG1hY3Z0YXAgcGFzc3Rocm91Z2gNCj4+IG1vZGUuDQo+PiAN
Cj4+PiANCj4+Pj4gDQo+Pj4+PiBvcg0KPj4+Pj4gc2tiX29ycGhhbl9mcmFncygpIGVsc2V3aGVy
ZSBpbiB0aGUgc3RhY2ssDQo+Pj4+IA0KPj4+PiBCYXNpY2FsbHkgemVyb2NvcHkgaXMgZXhwZWN0
ZWQgdG8gd29yayBmb3IgZ3Vlc3QgLT4gcmVtb3RlIGNhc2UsIHNvDQo+Pj4+IGNvdWxkIHdlIHN0
aWxsIGhpdCBza2Jfb3JwaGFuX2ZyYWdzKCkgaW4gdGhpcyBjYXNlPw0KPj4+IA0KPj4+IFllcywg
eW914oCZZCBoaXQgdGhhdCBpbiB0dW5fbmV0X3htaXQoKS4NCj4+IA0KPj4gT25seSBmb3IgbG9j
YWwgVk0gdG8gbG9jYWwgVk0gY29tbXVuaWNhdGlvbi4NCg0KU3VyZSwgYnV0IHRoZSB0cmlja3kg
Yml0IGhlcmUgaXMgdGhhdCBpZiB5b3UgaGF2ZSBhIG1peCBvZiBWTS1WTSBhbmQgVk0tZXh0ZXJu
YWwNCnRyYWZmaWMgcGF0dGVybnMsIGFueSB0aW1lIHRoZSBlcnJvciBwYXRoIGlzIGhpdCwgdGhl
IHpjIGVycm9yIGNvdW50ZXIgd2lsbCBnbyB1cC4NCg0KV2hlbiB0aGF0IGhhcHBlbnMsIFpDIHdp
bGwgZ2V0IHNpbGVudGx5IGRpc2FibGVkIGFueWhvdywgc28gaXQgbGVhZHMgdG8gc3BvcmFkaWMN
CnN1Y2Nlc3MgLyBub24tZGV0ZXJtaW5pc3RpYyBwZXJmb3JtYW5jZS4NCg0KPj4gDQo+Pj4gSWYg
eW91IHB1bmNoIGEgaG9sZSBpbiB0aGF0ICphbmQqIGluIHRoZQ0KPj4+IHpjIGVycm9yIGNvdW50
ZXIgKHN1Y2ggdGhhdCBmYWlsZWQgWkMgZG9lc27igJl0IGRpc2FibGUgWkMgaW4gdmhvc3QpLCB5
b3UgZ2V0IFpDDQo+Pj4gZnJvbSB2aG9zdDsgaG93ZXZlciwgdGhlIG5ldHdvcmsgaW50ZXJydXB0
IGhhbmRsZXIgdW5kZXIgbmV0X3R4X2FjdGlvbiBhbmQNCj4+PiBldmVudHVhbGx5IGluY3VycyB0
aGUgbWVtY3B5IHVuZGVyIGRldl9xdWV1ZV94bWl0X25pdCgpLg0KPj4gDQo+PiBXZWxsLCB5ZXMs
IHdlIG5lZWQgYSBjb3B5IGlmIHRoZXJlJ3MgYSBwYWNrZXQgc29ja2V0LiBCdXQgaWYgdGhlcmUn
cw0KPj4gbm8gbmV0d29yayBpbnRlcmZhY2UgdGFwcywgd2UgZG9uJ3QgbmVlZCB0byBkbyB0aGUg
Y29weSBoZXJlLg0KPj4gDQoNCkFncmVlZCBvbiB0aGUgcGFja2V0IHNvY2tldCBzaWRlLiBJIHJl
Y2VudGx5IGZpeGVkIGFuIGlzc3VlIGluIGxsZHBkIFsxXSB0aGF0IHByZXZlbnRlZA0KdGhpcyBz
cGVjaWZpYyBjYXNlOyBob3dldmVyLCB0aGVyZSBhcmUgc3RpbGwgb3RoZXIgdHJpcCB3aXJlcyBz
cHJlYWQgb3V0IGFjcm9zcyB0aGUNCnN0YWNrIHRoYXQgd291bGQgbmVlZCB0byBiZSBhZGRyZXNz
ZWQuDQoNClsxXSBodHRwczovL2dpdGh1Yi5jb20vbGxkcGQvbGxkcGQvY29tbWl0LzYyMmE5MTE0
NGRlNGFlNDg3Y2VlYmRiMzMzODYzZTlmNjYwZTA3MTcNCg0KPiANCj4gSGkhDQo+IA0KPiBJIG5l
ZWQgbW9yZSB0aW1lIGRpdmluZyBpbnRvIHRoZSBpc3N1ZXMuIEFzIEpvbiBtZW50aW9uZWQsIHZo
b3N0IFpDIGlzDQo+IHNvIGxpdHRsZSB1c2VkIEkgZGlkbid0IGhhdmUgdGhlIGNoYW5jZSB0byBl
eHBlcmltZW50IHdpdGggdGhpcyB1bnRpbA0KPiBub3cgOikuIEJ1dCB5ZXMsIEkgZXhwZWN0IHRv
IGJlIGFibGUgdG8gb3ZlcmNvbWUgdGhlc2UgZm9yIHBhc3RhLCBieQ0KPiBhZGFwdGluZyBidWZm
ZXIgc2l6ZXMgb3IgbW9kaWZ5aW5nIGNvZGUgZXRjLg0KDQpBbm90aGVyIHRyaWNreSBiaXQgaGVy
ZSBpcyB0aGF0IGl0IGhhcyBiZWVuIGRpc2FibGVkIGJvdGggdXBzdHJlYW0gYW5kIGRvd25zdHJl
YW0NCmZvciBzbyBsb25nLCB0aGUgY29kZSBuYXR1cmFsbHkgaGFzIGEgYml0IG9mIHdyZW5jaC1p
bi10aGUtZW5naW5lLg0KDQpSRSBCdWZmZXIgc2l6ZXM6IEkgdHJpZWQgdGhpcyBhcyB3ZWxsLCBi
ZWNhdXNlIEkgdGhpbmsgb24gc3VmZmljaWVudGx5IGZhc3Qgc3lzdGVtcywNCnplcm8gY29weSBn
ZXRzIGVzcGVjaWFsbHkgaW50ZXJlc3RpbmcgaW4gR1NPL1RTTyBjYXNlcyB3aGVyZSB5b3UgaGF2
ZSBtZWdhDQpwYXlsb2Fkcy4NCg0KSSB0cmllZCBwbGF5aW5nIGFyb3VuZCB3aXRoIHRoZSBnb29k
IGNvcHkgdmFsdWUgc3VjaCB0aGF0IFpDIHJlc3RyaWN0ZWQgaXRzZWxmIHRvDQpvbmx5IGxldHMg
c2F5IDMySyBwYXlsb2FkcyBhbmQgYWJvdmUsIGFuZCB3aGlsZSBpdCAqZG9lcyogd29yayAod2l0
aCBlbm91Z2gNCmhvbGVzIHB1bmNoZWQgaW4pLCBhYnNvbHV0ZSB0LXB1dCBkb2VzbuKAmXQgYWN0
dWFsbHkgZ28gdXAsIGl0cyBqdXN0IHRoYXQgQ1BVIHV0aWxpemF0aW9uDQpnb2VzIGRvd24gYSBw
aW5jaC4gTm90IGEgYmFkIHRoaW5nIGZvciBjZXJ0YWluLCBidXQgc3RpbGwgbm90IGdyZWF0Lg0K
DQpJbiBmYWN0LCBJIGZvdW5kIHRoYXQgdHB1dCBhY3R1YWxseSB3ZW50IGRvd24gd2l0aCB0aGlz
IHBhdGgsIGV2ZW4gd2l0aCBaQyBvY2N1cnJpbmcNCnN1Y2Nlc3NmdWxseSwgYXMgdGhlcmUgd2Fz
IHN0aWxsIGEgbWl4IG9mIFpDIGFuZCBub24tWkMgYmVjYXVzZSB5b3UgY2FuIG9ubHkNCmhhdmUg
c28gbWFueSBwZW5kaW5nIGF0IGFueSBnaXZlbiB0aW1lIGJlZm9yZSB0aGUgY29weSBwYXRoIGtp
Y2tzIGluIGFnYWluLg0KDQoNCj4gDQo+Pj4gDQo+Pj4gVGhpcyBpcyBubyBtb3JlIHBlcmZvcm1h
bnQsIGFuZCBpbiBmYWN0IGlzIGFjdHVhbGx5IHdvcnNlIHNpbmNlIHRoZSB0aW1lIHNwZW50DQo+
Pj4gd2FpdGluZyBvbiB0aGF0IG1lbWNweSB0byByZXNvbHZlIGlzIGxvbmdlci4NCj4+PiANCj4+
Pj4gDQo+Pj4+PiBhcyB2aG9zdF9uZXQgZG9lcyBub3Qgc2V0DQo+Pj4+PiBTS0JGTF9ET05UX09S
UEhBTi4NCj4+IA0KPj4gTWF5YmUgd2UgY2FuIHRyeSB0byBzZXQgdGhpcyBhcyB2aG9zdC1uZXQg
Y2FuIGhvcm5vciB1bGltaXQgbm93Lg0KDQpZZWEgSSB0cmllZCB0aGF0LCBhbmQgd2hpbGUgaXQg
aGVscHMga2ljayB0aGluZ3MgZnVydGhlciBkb3duIHRoZSBzdGFjaywgaXRzIG5vdCBhY3R1YWxs
eQ0KZmFzdGVyIGluIGFueSB0ZXN0aW5nIEnigJl2ZSBkcnVtbWVkIHVwLg0KDQo+PiANCj4+Pj4+
IA0KPj4+Pj4gT3JwaGFuaW5nIGVuZm9yY2VzIGEgbWVtY3B5IGFuZCB0cmlnZ2VycyB0aGUgY29t
cGxldGlvbiBjYWxsYmFjaywgd2hpY2gNCj4+Pj4+IGluY3JlbWVudHMgdGhlIGZhaWxlZCBUWCBj
b3VudGVyLCBlZmZlY3RpdmVseSBkaXNhYmxpbmcgemVyb2NvcHkgYWdhaW4uDQo+Pj4+PiANCj4+
Pj4+IEV2ZW4gYWZ0ZXIgYWRkcmVzc2luZyB0aGVzZSBpc3N1ZXMgdG8gcHJldmVudCBTS0Igb3Jw
aGFuaW5nIGFuZCBlcnJvcg0KPj4+Pj4gY291bnRlciBpbmNyZW1lbnRzLCBwZXJmb3JtYW5jZSBy
ZW1haW5zIHBvb3IuIEJ5IGRlZmF1bHQsIG9ubHkgNjQNCj4+Pj4+IG1lc3NhZ2VzIGNhbiBiZSB6
ZXJvY29waWVkLCB3aGljaCBpcyBpbW1lZGlhdGVseSBleGhhdXN0ZWQgYnkgd29ya2xvYWRzDQo+
Pj4+PiBsaWtlIGlwZXJmLCByZXN1bHRpbmcgaW4gbW9zdCBtZXNzYWdlcyBiZWluZyBtZW1jcHkn
ZCBhbnlob3cuDQo+Pj4+PiANCj4+Pj4+IEFkZGl0aW9uYWxseSwgbWVtY3B5J2QgbWVzc2FnZXMg
ZG8gbm90IGJlbmVmaXQgZnJvbSB0aGUgWERQIGJhdGNoaW5nDQo+Pj4+PiBvcHRpbWl6YXRpb25z
IHByZXNlbnQgaW4gdGhlIGhhbmRsZV90eF9jb3B5IHBhdGguDQo+Pj4+PiANCj4+Pj4+IEdpdmVu
IHRoZXNlIGxpbWl0YXRpb25zIGFuZCB0aGUgbGFjayBvZiBhbnkgdGFuZ2libGUgYmVuZWZpdHMs
IHJlbW92ZQ0KPj4+Pj4gemVyb2NvcHkgZW50aXJlbHkgdG8gc2ltcGxpZnkgdGhlIGNvZGUgYmFz
ZS4NCj4+Pj4+IA0KPj4+Pj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXgu
Y29tPg0KPj4+PiANCj4+Pj4gQW55IGNoYW5jZSB3ZSBjYW4gZml4IHRob3NlIGlzc3Vlcz8gQWN0
dWFsbHksIHdlIGhhZCBhIHBsYW4gdG8gbWFrZQ0KPj4+PiB1c2Ugb2Ygdmhvc3QtbmV0IGFuZCBp
dHMgdHggemVyb2NvcHkgKG9yIGV2ZW4gaW1wbGVtZW50IHRoZSByeA0KPj4+PiB6ZXJvY29weSkg
aW4gcGFzdGEuDQo+Pj4gDQo+Pj4gSGFwcHkgdG8gdGFrZSBkaXJlY3Rpb24gYW5kIGlkZWFzIGhl
cmUsIGJ1dCBJIGRvbuKAmXQgc2VlIGEgY2xlYXIgd2F5IHRvIGZpeCB0aGVzZQ0KPj4+IGlzc3Vl
cywgd2l0aG91dCBkZWFsaW5nIHdpdGggdGhlIGFzc2VydGlvbnMgdGhhdCBza2Jfb3JwaGFuX2Zy
YWdzX3J4IGNhbGxzIG91dC4NCj4+PiANCj4+PiBTYWlkIGFub3RoZXIgd2F5LCBJ4oCZZCBiZSBp
bnRlcmVzdGVkIGluIGhlYXJpbmcgaWYgdGhlcmUgaXMgYSBjb25maWcgd2hlcmUgWkMgaW4NCj4+
PiBjdXJyZW50IGhvc3QtbmV0IGltcGxlbWVudGF0aW9uIHdvcmtzLCBhcyBJIHdhcyBkcml2aW5n
IG15c2VsZiBjcmF6eSB0cnlpbmcgdG8NCj4+PiByZXZlcnNlIGVuZ2luZWVyLg0KPj4gDQo+PiBT
ZWUgYWJvdmUuDQo+PiANCj4+PiANCj4+PiBIYXBweSB0byBjb2xsYWJvcmF0ZSBpZiB0aGVyZSBp
cyBzb21ldGhpbmcgd2UgY291bGQgZG8gaGVyZS4NCj4+IA0KPj4gR3JlYXQsIHdlIGNhbiBzdGFy
dCBoZXJlIGJ5IHNlZWtpbmcgYSB3YXkgdG8gZml4IHRoZSBrbm93biBpc3N1ZXMgb2YNCj4+IHRo
ZSB2aG9zdC1uZXQgemVyb2NvcHkgY29kZS4NCj4+IA0KPiANCj4gSGFwcHkgdG8gaGVscCBoZXJl
IDopLg0KPiANCj4gSm9uLCBjb3VsZCB5b3Ugc2hhcmUgbW9yZSBkZXRhaWxzIGFib3V0IHRoZSBv
cnBoYW4gcHJvYmxlbSBzbyBJIGNhbg0KPiBzcGVlZCB1cCB0aGUgaGVscD8gRm9yIGV4YW1wbGUs
IGNhbiB5b3UgZGVzY3JpYmUgdGhlIGNvZGUgY2hhbmdlcyBhbmQNCj4gdGhlIGNvZGUgcGF0aCB0
aGF0IHdvdWxkIGxlYWQgdG8gdGhhdCBhc3NlcnRpb24gb2YNCj4gc2tiX29ycGhhbl9mcmFnc19y
eD8NCj4gDQo+IFRoYW5rcyENCj4gDQoNClNvcnJ5IGZvciB0aGUgc2xvdyByZXNwb25zZSwgZ2V0
dGluZyBiYWNrIGZyb20gaG9saWRheSBhbmQgY2F0Y2hpbmcgdXAuDQoNCldoZW4gcnVubmluZyB0
aHJvdWdoIHR1bi5jLCB0aGVyZSBhcmUgYSBoYW5kZnVsIG9mIHBsYWNlcyB3aGVyZSBaQyB0dXJu
cyBpbnRvDQphIGZ1bGwgY29weSwgd2hldGhlciB0aGF0IGlzIGluIHRoZSB0dW4gY29kZSBpdHNl
bGYsIG9yIGluIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciB3aGVuDQp0dW4geG1pdCBpcyBydW5uaW5n
Lg0KDQpGb3IgZXhhbXBsZSwgdHVuX25ldF94bWl0IG1hbmRhdG9yaWx5IGNhbGxzIHNrYl9vcnBo
YW5fZnJhZ3NfcnguIEFueXRoaW5nDQp3aXRoIGZyYWdzIHdpbGwgZ2V0IHRoaXMgbWVtY3B5LCB3
aGljaCBhcmUgb2YgY291cnNlIHRoZSDigJxqdWljeeKAnSB0YXJnZXRzIGhlcmUgYXMNCnRoZXkg
d291bGQgdGFrZSB1cCB0aGUgbW9zdCBtZW1vcnkgYmFuZHdpZHRoIGluIGdlbmVyYWwuIE5hc3R5
IGNhdGNoMjIgOikgDQoNClRoZXJlIGFyZSBhbHNvIHBsZW50eSBvZiBwbGFjZXMgdGhhdCBjYWxs
IG5vcm1hbCBza2Jfb3JwaGFuX2ZyYWdzLCB3aGljaA0KdHJpZ2dlcnMgYmVjYXVzZSB2aG9zdCBk
b2VzbuKAmXQgc2V0IFNLQkZMX0RPTlRfT1JQSEFOLiBUaGF04oCZcyBhbiBlYXN5DQpmaXgsIGJ1
dCBzdGlsbCBzb21ldGhpbmcgdG8gdGhpbmsgYWJvdXQuDQoNClRoZW4gdGhlcmUgaXMgdGhlIGlz
c3VlIG9mIHBhY2tldCBzb2NrZXRzLCB3aGljaCB0aHJvdyBhIGtpbmcgc2l6ZWQgd3JlbmNoIGlu
dG8NCnRoaXMuIEl0cyBzbGlnaHRseSBpbnNpZGlvdXMsIGJ1dCBpdCBpc27igJl0IGRpcmVjdGx5
IGFwcGFyZW50IHRoYXQgbG9hZGluZyBzb21lIHVzZXINCnNwYWNlIGFwcCBudWtlcyB6ZXJvIGNv
cHksIGJ1dCBpdCBoYXBwZW5zLg0KDQpTZWUgbXkgcHJldmlvdXMgY29tbWVudCBhYm91dCBMTERQ
RCwgd2hlcmUgYSBzaW1wbHkgY29tcGlsZXIgc25hZnUgY2F1c2VkDQpvbmUgc29ja2V0IG9wdGlv
biB0byBnZXQgc2lsZW50bHkgYnJlYWssIGFuZCBpdCB0aGVuIHJpcHBlZCBvdXQgWkMgY2FwYWJp
bGl0eS4gRWFzeQ0KZml4LCBidXQgaXRzIGFuIGV4YW1wbGUgb2YgaG93IHRoaXMgY2FuIGZhbGwg
b3Zlci4NCg0KQm90dG9tIGxpbmUsIEnigJlkICpsb3ZlKioqKioqIGhhdmUgWkMgd29yaywgd29y
ayB3ZWxsIGFuZCBzbyBvbi4gSeKAmW0gb3BlbiB0byBpZGVhcw0KaGVyZSA6KSAodXAgdG8gYW5k
IGluY2x1ZGluZyBib3RoIEEpIGZpeGluZyBpdCBhbmQgQikgZGVsZXRpbmcgaXQpDQoNCg==

