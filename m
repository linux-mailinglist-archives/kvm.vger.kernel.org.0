Return-Path: <kvm+bounces-64691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B70DC8B04F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77B1C4E3914
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52CE33EAE3;
	Wed, 26 Nov 2025 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="i3iH2CoD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="fcE1Fx8a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6E1E231E;
	Wed, 26 Nov 2025 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764175398; cv=fail; b=eCFh5BSCoOAsaJh4WWjU3FfANxBEDohj1XwxBsE1Gq1QXoxjRD+1Lp0hlgDoQZTe9rJf0AcmFe9YA3+RQCnePxI3pdah4RxlgTpGfMcbkqb3LPNZxUgfPzfXL4OwjOP6jyfCrTEhrAgclJa4aB9VZf+8ub0cxhPeuYj9NIQMyv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764175398; c=relaxed/simple;
	bh=CsMwCS3Hie1jRfdRIkFUgD/JOXmS7EG+oPRS+LGqs0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ayx4u2kL87qgwP7FBTAhLoxANdWqdP87VUT/kW7yDQ8GzEjlzGtWYTDjt36ejcc14ajaoZXABWwIrNjfLq41X/NM6KQOfQwU24czzLC6yGZO6MTcyrjiac+QIXFsc1cZ3oWnRzXMT6IjpHgZAZYvKAzRP07ID+NMTw51bpgi5as=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=i3iH2CoD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=fcE1Fx8a; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQDJSeB1710395;
	Wed, 26 Nov 2025 08:43:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=CsMwCS3Hie1jRfdRIkFUgD/JOXmS7EG+oPRS+LGqs
	0k=; b=i3iH2CoDs+wJil5FzwkpvJi0nPboqVUnApf1FvsxeJw4y6nTHcuRlbPrt
	Rw/Vz4R5oITCjgxTsQuq4kmYkbXw6R9ccMFj4jEl3dUdsKTORTMp/nQUcRsC80xD
	WbDbo+lqhD8YudgaKVRNWxxLWutS7MX+EVr2LqUQC1xduck5aCBx7uJ0xm8R2Wxw
	MskZ8iYPsHJfhUp232NKlIwX8r+ejr5nvZiGeqoC/AOCv3rkrwW/kkvklzrmKa/D
	a13jKziKlCfpNEcjL8j67hNrxHfuQVyPswf8Ld0jR5OfMQlFen07UpppvvL9I758
	qVjIHMT1fXynMKlCq08bGlkik2u9w==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022084.outbound.protection.outlook.com [52.101.43.84])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap2b78ecc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:43:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d14Yr/vLF2UyT7Dn8M8yI8g15K/Rtfsihseqqn9YzfLOfbh/QpNmxdEmv0bQV4XFPYfhAWoBx6qraGduvFFwt9Fk69o8jzOBtPWiQihQ2yQVrUmlTa5lIkddaYpFnJFZh2agkw/2yFYkZd5DcGj1bvPb4sKNGa3ZzcuzIno0iEZMTkuIp04GlufM56IHZ9cehFrh1XJj3mhgW3nOSx/Y50CeDkT+d7ZtJTmHkZdP7NUCB27rZw3kBs5ivh2vwZAswSRufQi/3fEjJJrobhZ36fPg7Ov1yakXRYGOkNy5icpYV1Ce0arVyVucG7ZqKE3+weSqOK7WtvSFDsr0kWjtyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CsMwCS3Hie1jRfdRIkFUgD/JOXmS7EG+oPRS+LGqs0k=;
 b=ElBBy0bIsQm4yFoWJTtWJuRzuuCksEt+CRowF6i960Rab7Hk2izpGskNepxrsECjv4VybKcBPp8D/HdXlbf5kXlXOOAqn5TaOZeSynxsXkH252C42AexEafBAtZ/FVN0lv1IPsGROfrKD8f01FXKGDJE6uaEfxLMeF0Bw+fuxU06mT0fGJ1Q8v4exdlb4lIOIyyQyH3h//OiCwtpoLhFyfIzypD4//XPUwBK6zE1J9ltuopoVpqcbVbwMogG9j+E56EMIYU8JGO3w8RP7VQtEwGI7r9kCib1iCt5mZF13uvYkX+GoUfBn49F8WNoHqe4CjanrhaNtP9ZbIPueglm5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CsMwCS3Hie1jRfdRIkFUgD/JOXmS7EG+oPRS+LGqs0k=;
 b=fcE1Fx8aj63LDxpsHRQ5Hpp8rcV/6hEnzJtXz7yttKfaDn5pS7w/M9sHaVULjyBtZRtXUVZpM0JPBoGJCosZ2d3FsQ3hMLmY477V2LwKxI3N46s1rvDtWKrYm/sytOFuAnSkZUwjLGGI7EDhNuo4KTLVOF7843nI2js7K6nzmWvZ0Nc+sRZuN8CDg6lMHsxTQg4AH6hYXBVVuJ36YuaurOsuzJ6V3Xqhc4YrX0C/9zTASGiA1t9O/KDGfCNfJOcC/5uwOgB2f6PZ96ptLb6owmPS9BGGID+KtPvzPGR1VyV/b+x2XI50uHWlR+ZXJLgtQ/I9UZ2T+ZZ01lpAhrzAbg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8576.namprd02.prod.outlook.com
 (2603:10b6:806:1fc::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 16:43:09 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 16:43:09 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Topic: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Index: AQHcXi98HPUjRK7uJEmyz5eQdWvl9LUEqNSAgACCP4A=
Date: Wed, 26 Nov 2025 16:43:09 +0000
Message-ID: <05620625-AB73-4645-97C4-3CC07022049D@nutanix.com>
References: <20251125180034.1167847-1-jon@nutanix.com>
 <20251126035449-mutt-send-email-mst@kernel.org>
In-Reply-To: <20251126035449-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8576:EE_
x-ms-office365-filtering-correlation-id: 582b151c-8a78-4b0d-78fc-08de2d0ae1d3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?a3VDZ3NiTE9kUHkyQkQxQTROdHZoeUdOTENsTUNra3RtT20xczA0TVVla2tC?=
 =?utf-8?B?Y2FFNndrcDF5NVJtZ0tVOXZQa3ppTWRsa2MzWXlObUJid1VLbmZINVZHWWk0?=
 =?utf-8?B?bHJ4dXZYbTRZK1o5L3VYbkEwdkJ4TzdwbnlIL25tb0JGWHh3NmNyNngzbEgw?=
 =?utf-8?B?dzhkTVIvTDJva08zSWxEekE2ZFJGL1ovaGFUUFIrMXFlMDR3MTViVDFUbW9p?=
 =?utf-8?B?T3IzM1FQWGhHREpGaitVSEdCdS96NWtLc3ROWXFBU1R5Q3dvMzJ6S29xQUlw?=
 =?utf-8?B?ck9jYmFHM09ZVFMrbEZVdUg1LzJKdzlqaFUvNDNpeDhzT05DRkpjRjY5SVd3?=
 =?utf-8?B?MHdqaHZKWFJuSmNuVEVBcmpWZklhcUk1NUhNNWJheERKK1k0ZlJiK2YreTlF?=
 =?utf-8?B?dTl0QjVkL2t3YUtGYkJEak0rZWI5Q21CK1ptSHVOT2xVSDJUb0xSVkM0d0lm?=
 =?utf-8?B?bVVJcTE2OXBYeG9HL1hYVmJIV3RmNW9rc1FMZkN4bGc1U0pLelZrcG5ONm5t?=
 =?utf-8?B?ODY3MFZuNGl2Z1RPY1NER0xsdWtKZWkveVZ4bjdTbDJQOXZWa3AwWUg1dXpo?=
 =?utf-8?B?dHVObjFBQTd3TmRPRVliSnNtRy83OG1iaWYwWXVsZ2VVMnRydHNGM1VIZEE0?=
 =?utf-8?B?UC9Geml5MGxmS1pGQjBRSUdiOFJHQVNJMGhFUkJvVnNZbG8yekR2MW1kSVor?=
 =?utf-8?B?ZGRpVlViRS9oMDMwRnVxc2dKWUhVblJyRnhWT1llUTV4WHNpVk1Qb1MyL2hJ?=
 =?utf-8?B?Y29xZmNYSzlmR1gxQmRGcUZJNklrbTJheFlVd0I0SUd0VklzNkhZWER5WGpS?=
 =?utf-8?B?L0tOS0tVMjNSTmFrUG90bVA1Y2d4MWJjeTI5NUVnamVldFAxdnErWWhIWis0?=
 =?utf-8?B?WG42KzI5TS9Na29IUXhqL0NlRXkrSk8wZklZb3JwZDNmcnNPZE5TUjNob3ZZ?=
 =?utf-8?B?VFJyVGd6ZFh6R2IvaW9wWURWWWovdXFSU1BubU44OXZoZEJmVUV3TzhJTXRK?=
 =?utf-8?B?U0ppNjNEekgzeW5ML3J5c3cvdjBVSUhReEJaMzdBalVSRi9HNVhIOVZHaW1o?=
 =?utf-8?B?YUMrd0VFbW1vNVU4cnFjbnU0RGdwWWhnQ0xSSis1VU9tQjlIamtJMTlMeXdx?=
 =?utf-8?B?eGJhOFN0NCtzbVQ0VUtDclhUYzdCSGVRRTIxT2QvVmFBTTBGNkIwa283L2Ra?=
 =?utf-8?B?TTZ3U0gvTUQ3SkRTci9RNjZGYy9zTy9FQW8xcXpjR1dIbkxmekc2MFI5VWoz?=
 =?utf-8?B?ZElzMXJ5VTJ5ckNSZWFBSEx6VFhTRFRVU083MlEyaWRUU3NJVklZeHc1RGNl?=
 =?utf-8?B?WXhqVWppczJYVEJmUENWbWEvU3M0ME00QlJyOGlGenhmWmdDMnIraXN3YjlW?=
 =?utf-8?B?K0krNGZyOVBHMFpNd0lkYW9iZExxbGFEWXRLUTdsME80K1pGeThOcGdva1ZY?=
 =?utf-8?B?emllSENGUEFKV0F1SXRqL3Z2bkJ2TDlJcWsvcFJudkE0cVhOb0RsVUhiREEw?=
 =?utf-8?B?REdhWFExNGRaRVJSSDBmRGdzWjZ3cFZLdmg0MGRHUXcwd1pnQU82dG80YVNV?=
 =?utf-8?B?aE94eTl6Z0h2bkYweTVqUDVHMWR0eHptOWQvTHVRb0R2aDA0VWova1dxUFR6?=
 =?utf-8?B?cGpCZTVUcjh3aFA1TytneDc0bVVzVXRjYk9HQk8xaG4xS1pGZDQzL2tHRXpq?=
 =?utf-8?B?UnJQSzFBK1JlUklKR1pHUHl1d3JocFZEMkg5WEE0REQzRDhrVlpYcEx6QnJV?=
 =?utf-8?B?dmRiZFlmZHY2Y1lkWTc5UUl3WWg4MnV4Rkx4WDAvT1BDcFFWQnE1Q0UxZGNv?=
 =?utf-8?B?MkdWYTE5TVNMUjBUMU1mVVUzaGc3OXFIcE80U0Naa0ZrN0JkTHRIUjhsLys4?=
 =?utf-8?B?UGdKNFRoMldueUlLQ3dRanF3eHJ3b2lGa1RBcmlMTzlQb0F6bGFmQzhMVjVP?=
 =?utf-8?B?RTh1WlZ4TVdBeDZGTHV0QXRnQ29GWVJyUTdlRkMvWDZDRXNhNm9BZ0UxMnZJ?=
 =?utf-8?B?RDRtZmhrQ3E4NVpsTjBEeUNTWVp5NVZDajExRE5pTThPQis1UkUxdU1qbVZY?=
 =?utf-8?Q?29MbvW?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Q3I3elk5c1JBN3F2QVAzVXBHNEpSSnJsWFdKSXdLQmVnZG94U01BRGpsd2gv?=
 =?utf-8?B?YmZvcFZWZ1JXckdpODBSTWIxaDlUaThPeG5VdWNWS2tiZkVLeG95bDBteUJ6?=
 =?utf-8?B?Smovc203MUtiZlNza3pTV2VmOVJWSlN2MlkySERCWTBHZ3U1cDFwNmJvdkRy?=
 =?utf-8?B?SHVBaXNoWDNqbFVSNmh4UGN6WkNoRGQzazhSSGVOenhrNHJGdk1US2xwN1Ry?=
 =?utf-8?B?aVdaRTdJVElwMDdRdDFvdktJOVdvRXYrRXJoYUpDb3NBL1ZJZjVjY3Fxc2ow?=
 =?utf-8?B?WXZCYnlUOVNRbyt4OGN6a201azNMVlFYV2FjTmNHNFY4em9FSnA0b0hTY1Rk?=
 =?utf-8?B?YUwrNXd3eUpxNGtPeG14NVBvb0JabnZLeVVvck5wR2NKbGNOMEMrdHlWbm14?=
 =?utf-8?B?eDVIQzdveURJNDY1VFRVOEkzZzZBb1QyQm5zSnBBcmlkM2lCaEtQNHhFRkVR?=
 =?utf-8?B?QXI3M0tHc2NKR2J0eDliaCszcWJVQS84L2lHbHpwTERNTjU2cUlvWVlzME4w?=
 =?utf-8?B?T0ZOY0FLMFFPczl4aWUyVElHeVF5SzEzZmUyTk5QMjlJRDBEZ3ZORUpENHpm?=
 =?utf-8?B?ZkEwNnFRcEZyaDVvazB1cFNPd2JXQ0ZKcUVzRHNVVFV1SVMxZ3ltUFllY2s0?=
 =?utf-8?B?U0VWeWRwVWZFSUlFMnhMc2kweS8rR0ZhT3RIbUxORnVZcVBlQkNleDlmUzVF?=
 =?utf-8?B?VTBrejBsQkNWbndYeVV2UlhmMGZUZTVxLzQ2NUNSK0ZZc253OXNCaVdLQlMy?=
 =?utf-8?B?dFd5elZpeUVSM1hOZVEwUTMvK0ZQcThtK042cjlnc3BCQnVOTStjTVhRbDlZ?=
 =?utf-8?B?Y3pyRXFWOU9aM1J4WVhSZXFrcTA3VzNBZGV6eGZyV2dxY0hiYXZGOXJuNklE?=
 =?utf-8?B?VkY0Z0dZUlFnZFgvV084RVoxWFlhT0RYTjlMcVdoeEZvb0tES2poald1dnJy?=
 =?utf-8?B?ai9icjUzR1U1VW1ZNjNFdEg2Umc2dHFkY3NYVHhUWGt3aUNnMmwrQ3Z4QUV3?=
 =?utf-8?B?WVVNUTNnTVA3Y3RKdEVOUnorV3ViQW4rQk1MS01IbTI2VXROeWRyaVZkdnAy?=
 =?utf-8?B?UXdnS3VPOGVFNGJDd1FQalN5OVNUc1JtL2gwczhlamtnQkVmeE5tMVJaejZI?=
 =?utf-8?B?cUNpcGE2UUpmc2tpbkZXaTViTU1lVG94Z3R5Ri9BdFVkS0VuN1FQdnQzL1RL?=
 =?utf-8?B?UU1QS1VQN2JXYnRmVDU3M09FVlpRZkdyUVBOdVNJcEZYemtaakt2MGprakxt?=
 =?utf-8?B?cDc5bXVOcFd2SksvYVpUSzhHU25TSXdxVWJBYzRjMHVwSjg4YkIxbkFtRFZV?=
 =?utf-8?B?cUlwbkhuOVo1L0xZWklJdFFVM2pNOHFUaEtRTDNWdnBsWnJxTmRFSVAvaitJ?=
 =?utf-8?B?V0pyRThpT0txa3p0bGZHNnBNVnZHZHhPS1A4d3V3aFJLYVo4UjFOOC9peWtK?=
 =?utf-8?B?RDRtaEFIMmRPc2lwb3dqQnUzZHhVRk5vSDd2Mnl5NHlXM1MwZmFvWE5LWkIv?=
 =?utf-8?B?Z29HSTI0TGFqUVdONmRKbUorV0JsUHczRHNJN1BrTHNaZzFkQlFiMXVuWTlz?=
 =?utf-8?B?RUFJNWl5clAraTRnZnV2b0JjWFRNby9ickhlcDh2YjM0QjYvc0RYTUJtc1FE?=
 =?utf-8?B?Y1BvSno3cXAzbi9ycGJzblVmMW52TDJMemE5MmtYd3RpUFVkdGdIQVN5OEFr?=
 =?utf-8?B?ZTBMdUhsZ1BRTXdQOHR6QkxYVnJFZXRwVGE5cU95Y2Z6ZkcrbkVsNE9Za3FL?=
 =?utf-8?B?amRtNGFSd09aOG1BTDQzQzNnWlBpczlteUJGWWxuWlo2VVNzamZSYkEzL1lo?=
 =?utf-8?B?QjIxbjZUTEJ2WDFNS05UbTN5V1E0RGZtaUx0OTNXZTNTeHkrSENqenkxT3or?=
 =?utf-8?B?TVpnQ2RhaE5uQi9BZmF3MnZUd1JFTEZZSHU5eVFPTm1ENElxcmZKTjUvakZ5?=
 =?utf-8?B?Zm95S3lLbXptTkd1STAzNnA3MCtJNU5kOEpYY1MxUkxwaFNkVW01cHJFTy9F?=
 =?utf-8?B?WXRWMjFlQmZ4OTVpODdlVm1zK2xaRDExZnlmRVBhVzUyckxRck94QjR5YWRa?=
 =?utf-8?B?d3M4WTR5LzFHR0FlSzBKRituNktQUEtudmRQQThrSTJ2MGpqczlYUmJQZDBw?=
 =?utf-8?B?WEZEQjRyd0doalR1OGRWcUxBK2xFck45ZHQ2bjE4dWQwcVREVi9zc3RteDNj?=
 =?utf-8?B?aXNuN2g2Vk1zOE5ldW5ycVdwcnFFN3hrY3hXdmNTMzlHbXU0TjYzalRQS1ZK?=
 =?utf-8?B?T1dGRnEvRklIcmdZTmpRNDZTTERBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A6539344AD80F4784068654172C3232@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 582b151c-8a78-4b0d-78fc-08de2d0ae1d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 16:43:09.4436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zLEpzCACm5GyEY/Saw7iem6O30CQcy8MXTHCt2hM3NUG3xDFDcBkp10udHuUDdbAvQ/7nBjJFJMxSIt8bSOIL54PcPs0i1DRI/V0ZtCwCEs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8576
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzNiBTYWx0ZWRfX+gNps1b81JmC
 Bzevf9HRHw3VPRMW8o5k5NiJwIGPHcn5b2VeKEVoAATYkMZwVEU5n0MyUyWFvru9rF0Meo/xXHp
 SK0Gyf5PWGRAUBXdCYBcMwME/iR4adLpI2QIIUNe4gJR/T+agYc2e92T+7hyDMNkYJl2M1vXu72
 hkDPBMX0zS9yjWrHoa8VOSq6LI0putpPqof4eMo9bsUT7bhDYyPT9ztx/X4Hhr7oV98kjn6WjiX
 1O3ndeqzytRWTA+kjpG9OUkFhA4hZzsQhsGrsXUV9Mj8kMFRt0QiOyl+s85q2WE7nIJ/1I6vRWU
 YcwWqotVpFXIdvKFry53t2gB/i3nxMKHZ1Vo/11/t+BmCW+wQIFNsG9gsdSJ0i1bCu4ECKNieT0
 bueNjLw+TeZLGg5ACLlDiRAIANVDzg==
X-Proofpoint-ORIG-GUID: z3u4QdvIQoGb5HNi4i0Vc0cqry0OAMOy
X-Authority-Analysis: v=2.4 cv=SpadKfO0 c=1 sm=1 tr=0 ts=69272e1f cx=c_pps
 a=2dB2vq+C98fl+yZq5En5IQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=-VqCQdr6Eiy9pGN_JrQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: z3u4QdvIQoGb5HNi4i0Vc0cqry0OAMOy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCAzOjU24oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8
bXN0QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBOb3YgMjUsIDIwMjUgYXQgMTE6
MDA6MzNBTSAtMDcwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IEluIG5vbi1idXN5cG9sbCBoYW5k
bGVfcnggcGF0aHMsIGlmIHBlZWtfaGVhZF9sZW4gcmV0dXJucyAwLCB0aGUgUlgNCj4+IGxvb3Ag
YnJlYWtzLCB0aGUgUlggd2FpdCBxdWV1ZSBpcyByZS1lbmFibGVkLCBhbmQgdmhvc3RfbmV0X3Np
Z25hbF91c2VkDQo+PiBpcyBjYWxsZWQgdG8gZmx1c2ggZG9uZV9pZHggYW5kIG5vdGlmeSB0aGUg
Z3Vlc3QgaWYgbmVlZGVkLg0KPj4gDQo+PiBIb3dldmVyLCBzaWduYWxpbmcgdGhlIGd1ZXN0IGNh
biB0YWtlIG5vbi10cml2aWFsIHRpbWUuIER1cmluZyB0aGlzDQo+PiB3aW5kb3csIGFkZGl0aW9u
YWwgUlggcGF5bG9hZHMgbWF5IGFycml2ZSBvbiByeF9yaW5nIHdpdGhvdXQgZnVydGhlcg0KPj4g
a2lja3MuIFRoZXNlIG5ldyBwYXlsb2FkcyB3aWxsIHNpdCB1bnByb2Nlc3NlZCB1bnRpbCBhbm90
aGVyIGtpY2sNCj4+IGFycml2ZXMsIGluY3JlYXNpbmcgbGF0ZW5jeS4gSW4gaGlnaC1yYXRlIFVE
UCBSWCB3b3JrbG9hZHMsIHRoaXMgd2FzDQo+PiBvYnNlcnZlZCB0byBvY2N1ciBvdmVyIDIwayB0
aW1lcyBwZXIgc2Vjb25kLg0KPj4gDQo+PiBUbyBtaW5pbWl6ZSB0aGlzIHdpbmRvdyBhbmQgaW1w
cm92ZSBvcHBvcnR1bml0aWVzIHRvIHByb2Nlc3MgcGFja2V0cw0KPj4gcHJvbXB0bHksIGltbWVk
aWF0ZWx5IGNhbGwgcGVla19oZWFkX2xlbiBhZnRlciBzaWduYWxpbmcuIElmIG5ldyBwYWNrZXRz
DQo+PiBhcmUgZm91bmQsIHRyZWF0IGl0IGFzIGEgYnVzeSBwb2xsIGludGVycnVwdCBhbmQgcmVx
dWV1ZSBoYW5kbGVfcngsDQo+PiBpbXByb3ZpbmcgZmFpcm5lc3MgdG8gVFggaGFuZGxlcnMgYW5k
IG90aGVyIHBlbmRpbmcgQ1BVIHdvcmsuIFRoaXMgYWxzbw0KPj4gaGVscHMgc3VwcHJlc3MgdW5u
ZWNlc3NhcnkgdGhyZWFkIHdha2V1cHMsIHJlZHVjaW5nIHdha2VyIENQVSBkZW1hbmQuDQo+PiAN
Cj4+IFNpZ25lZC1vZmYtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4NCj4+IC0tLQ0K
Pj4gZHJpdmVycy92aG9zdC9uZXQuYyB8IDIxICsrKysrKysrKysrKysrKysrKysrKw0KPj4gMSBm
aWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+PiBpbmRleCAzNWRlZDQzMzA0
MzEuLjA0Y2I1ZjFkYzZlNCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+
ICsrKyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+IEBAIC0xMDE1LDYgKzEwMTUsMjcgQEAgc3Rh
dGljIGludCB2aG9zdF9uZXRfcnhfcGVla19oZWFkX2xlbihzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQs
IHN0cnVjdCBzb2NrICpzaywNCj4+IHN0cnVjdCB2aG9zdF92aXJ0cXVldWUgKnR2cSA9ICZ0bnZx
LT52cTsNCj4+IGludCBsZW4gPSBwZWVrX2hlYWRfbGVuKHJudnEsIHNrKTsNCj4+IA0KPj4gKyBp
ZiAoIWxlbiAmJiBybnZxLT5kb25lX2lkeCkgew0KPj4gKyAvKiBXaGVuIGlkbGUsIGZsdXNoIHNp
Z25hbCBmaXJzdCwgd2hpY2ggY2FuIHRha2Ugc29tZQ0KPj4gKyAqIHRpbWUgZm9yIHJpbmcgbWFu
YWdlbWVudCBhbmQgZ3Vlc3Qgbm90aWZpY2F0aW9uLg0KPj4gKyAqIEFmdGVyd2FyZHMsIGNoZWNr
IG9uZSBsYXN0IHRpbWUgZm9yIHdvcmssIGFzIHRoZSByaW5nDQo+PiArICogbWF5IGhhdmUgcmVj
ZWl2ZWQgbmV3IHdvcmsgZHVyaW5nIHRoZSBub3RpZmljYXRpb24NCj4+ICsgKiB3aW5kb3cuDQo+
PiArICovDQo+PiArIHZob3N0X25ldF9zaWduYWxfdXNlZChybnZxLCAqY291bnQpOw0KPj4gKyAq
Y291bnQgPSAwOw0KPj4gKyBpZiAocGVla19oZWFkX2xlbihybnZxLCBzaykpIHsNCj4gDQo+IA0K
PiBJIGFsc28gd29uZGVyIHdoeSBkb24ndCB3ZSBhc3NpZ24gbGVuIGhlcmUuDQo+IEkgZ2V0IHRo
ZSBwb2ludCBhYm91dCBiZWluZyBmYWlyIHRvIFRYIGJ1dCBpdCdzIG5vdA0KPiBpbmRlZmluaXRl
IHBvbGwsIGp1c3QgYSBzaW5nbGUgcGVlayDigKYNCg0KVGhlIGZpcnN0IHZlcnNpb24gSSBtYWRl
IG9mIHRoaXMgcGF0Y2ggZGlkIHRoaXMuIEl0IHdvcmtzLA0KYnV0IEkgbGlrZWQgdGhlIGlkZWEg
b2YgaGF2aW5nIGJha2VkIGluIGZhaXJuZXNzIGRlc2lnbg0Kd2lzZS4gSXQgY291bGQgZ28gZWl0
aGVyIHdheSB0aG91Z2g/DQoNClRoZSBuaWNlIGJpdCBhYm91dCBkZWZlcnJpbmcgdG8gdGhlIFRY
IGhhbmRsZXIgKG9yIG90aGVyDQp3b3JrKSBpcyB0aGF0IHlvdeKAmWQgdGhlbiBuYXR1cmFsbHkg
YmF0Y2ggdXAgbW9yZSB3b3JrLA0Kc28gdGhlIGViYiBuIGZsb3cgc2hvdWxkIGJlIG5pY2VyIGlu
IGEgbWl4ZWQgbG9hZCBlbnZpcm9ubWVudA0KDQpUaG91Z2h0cz8NCg0KPj4gKyAvKiBNb3JlIHdv
cmsgY2FtZSBpbiBkdXJpbmcgdGhlIG5vdGlmaWNhdGlvbg0KPj4gKyAqIHdpbmRvdy4gVG8gYmUg
ZmFpciB0byB0aGUgVFggaGFuZGxlciBhbmQgb3RoZXINCj4+ICsgKiBwb3RlbnRpYWxseSBwZW5k
aW5nIHdvcmsgaXRlbXMsIHByZXRlbmQgbGlrZQ0KPj4gKyAqIHRoaXMgd2FzIGEgYnVzeSBwb2xs
IGludGVycnVwdGlvbiBzbyB0aGF0DQo+PiArICogdGhlIFJYIGhhbmRsZXIgd2lsbCBiZSByZXNj
aGVkdWxlZCBhbmQgdHJ5DQo+PiArICogYWdhaW4uDQo+PiArICovDQo+PiArICpidXN5bG9vcF9p
bnRyID0gdHJ1ZTsNCj4+ICsgfQ0KPj4gKyB9DQo+PiArDQo+PiBpZiAoIWxlbiAmJiBydnEtPmJ1
c3lsb29wX3RpbWVvdXQpIHsNCj4+IC8qIEZsdXNoIGJhdGNoZWQgaGVhZHMgZmlyc3QgKi8NCj4+
IHZob3N0X25ldF9zaWduYWxfdXNlZChybnZxLCAqY291bnQpOw0KPj4gLS0gDQo+PiAyLjQzLjAN
Cj4gDQoNCg==

