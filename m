Return-Path: <kvm+bounces-12352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 702C5881C5E
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 07:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E7E2C1F2226C
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 06:10:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09D543A1C5;
	Thu, 21 Mar 2024 06:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sR844fvX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ftyg9bTo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2270A881F
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 06:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711001448; cv=fail; b=sm21O1YJq4ruQk2EYMroR73JRup5YyFtSp8qoI90eAQwrQnAuGtxXnGPdo41eKW7v8sQA3cnuKTEbUMMhJgE6cr8QC8bBoRt0UG3C/nRapexrdgnyw4WajWUm8x2EZpEUTZIsAR/olCsogyGZWlGcLZs3UFktGtUQRV1Bi61H5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711001448; c=relaxed/simple;
	bh=j6Oq/Yk1WjxuCQWHmYtpXIc0xDfoy0M9gyyy60L5fa8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CCnF7/Kx5B4PaZ/+T9mxvVT03Gc37I/8Q0ccsC99w27Sl8y8IgrZY9wOzfTdzttwr5MqIvljFKIxuCDSJKZjHq40E5syCsPc+uA6bws1mlgRRk2ukKXfjyxQmvTPl/gxjV8ywE/tS5xnjrGbH7utQ00GpEpckzkYmQGhS0w53b4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sR844fvX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ftyg9bTo; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42KNUhHB017842;
	Wed, 20 Mar 2024 22:48:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=proofpoint20171006; bh=j6Oq/Yk1WjxuCQWHmYtpXIc0xDfoy0M9gyyy60
	L5fa8=; b=sR844fvXqn10JAOToBpKGpVHr7k0Bx2Jz8f/nlSO6VIRfH/SiFlpGE
	nzKhorim+igsP3xYsigpYP5UGOLtkiKSavaEuezCcUqZBaMoyJIbc8v+VwqyXI/Q
	w6xvJTHWeDglRqvQUPEc/qGQvrDldgVVur70j9WLw9v0VtBZppu88sXmeFTtzT5R
	UNyTw4qR5vGguD3+J1vYXBO5vY3wnPxMWPlSooMKPjBOARFEwR1Q1EmPNrrh8+kV
	UMEKZj6KbkeOhKzDZV8io3fRb35J33peUdqkNhFwkqb7eGSyLWL4PzPWRZQfdN6x
	2aIGBbX7pHZOYquu6JA/TZQuCfCrK/wQ==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3wyhqn3bhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Mar 2024 22:48:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPHw2Gj9s2k++J3ztC6S0D0orp37gBkG/3y5WuzK4X7jl6TP5aTjgPwz61NyUZVrrJxGC0yf5qZf8w3CBSyiInsNC29hvO1ICqLaWQMdwZJt9zGZv+8TFkyTm73Ztl6arpdLXSyG234I5BekE1VkeQBOGXUpdXXD4rCg+kNGDBm6UkKocfZXVCvC/kWMHnH0TAF6qsmYUDyx3OdXbszs+EUaYpV8wxIBQlx6ylyh9JvVRmJCcgrDXMOVZzpdpI5CzuQkHFUS1mv7SE8ZjYQNzvjdjCPsFsScX8Kf7Zbc0SZn7hGpT3w54/WZE5Y6hlYPf68EVNWK0qSboL8OlhXpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6Oq/Yk1WjxuCQWHmYtpXIc0xDfoy0M9gyyy60L5fa8=;
 b=n+tTIXSopixS+Q9OIVYqlV1+Oq2qvd1t53rwi1LWpO7kWjWRs786LiNeE4fQdx6hQmpWi7UVHYejmPA40OyMJGkC+R6kJeRbETe1SdPr9cT1ggFG98dFgVwEFoOIHJ+6RvhYRDh09wkzIgeEoPvHMgidv4vBGMLXVpRgLTaMmIztAjso0FXLx5xW0Oyu3QSILwsV1p+cW+qDF1+AvmPCMF7S5nimW9nN8/OBvX0yW+xU6pfiBU6cWtOD+rPYbHxNM8VBJG0olkDRDVZEBRYj6Vb25S/4mJ0I8deT24EaWr2V4PuNo6ATm0kycz6CYdBbibP+N3Ihr1qvgQt2KFe/KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6Oq/Yk1WjxuCQWHmYtpXIc0xDfoy0M9gyyy60L5fa8=;
 b=ftyg9bToTZl+J04PmDOPm9Jbfq4NDXdWgfaD5bwa+Ss4ZMF8qnNsBHSBJXA+stiZohSOJv+NsAfYszMYwyjFC/0yRHlQyVkL/nL1sBYJ12I4pKtn+Nql16LlCNRoSiu4ySNOG2HUAop7mfx4gahPwL9gKIhx/OLjWnEx5rfQe3XSXC1BfbXmOG97vyuPq/PQPyoH3PP1AUOIeq1vk6Ci2f+kYwv2O64xVbImwsnOLrvzdup/MUNSn1We1+XZoqDVUHvhnuWu4WJzb1ZnMexlJHNrv1qnEdybKjAzsFnXuiEHhjM3uEPp8wlEOqWXAVmQGVNZ0pSYMrR1WepSFWQseg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH7PR02MB8929.namprd02.prod.outlook.com (2603:10b6:510:1fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Thu, 21 Mar
 2024 05:48:01 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8547:57c5:c274:1e6b]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8547:57c5:c274:1e6b%6]) with mapi id 15.20.7386.025; Thu, 21 Mar 2024
 05:48:01 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>,
        "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>,
        Aravind Retnakaran
	<aravind.retnakaran@nutanix.com>,
        "Carl Waldspurger [C]"
	<carl.waldspurger@nutanix.com>,
        David Vrabel <david.vrabel@nutanix.com>,
        "david@redhat.com" <david@redhat.com>,
        "will@kernel.org" <will@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Thread-Topic: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Thread-Index: AQHaZP94vJDynSfMhkS84iipQRUQf7FB3KCA
Date: Thu, 21 Mar 2024 05:48:01 +0000
Message-ID: <EDE1F181-FC4F-4E76-9F89-C35579193480@nutanix.com>
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
In-Reply-To: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR02MB7555:EE_|PH7PR02MB8929:EE_
x-ms-office365-filtering-correlation-id: 6579d6c7-570a-4b7f-b91d-08dc496a7891
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 VDtWvy7SXCuK0Gc+jTa3oULrGNJ8Ay+XirbSPlSGIvOw2SgcDtNGlVqvsi7m/X/mGcGRa86R2gMtnWlqO8/xvu7hvHcAhMarKYdg07hD03ekPwkNDaTZZxd3jCpjR1GHBayCAkAhi417eSWgUVmG5HiXMm2yfZY5cdK9ZL0FAx9uy45jpXNh6rRwg4GdMNPOWn4Rcmh24DwDon/OGVwAMlQzvvaqauBPElVlPaFTNmYUql+5lhGxVyAL4jmZMJxTQeqJCrHQrGcF8dTWQ8HhQ5tA+re1Te+4uDPOh79++ZPuP1AOYYAm5djnKKPCpViN4bNK91NP8pjD5RwSz23B82u5pGmxEFhqb9L5sgOOfo3dMKMGXoNi3jRxpDgGzTL5d7bQ/cBf2uipAWBr8m0MhqBlKuM+etZzVLE61J/PSffjNCX9scHp/YRKLRVuploUKyzHRNwr8a7Gq5i+axfRwo8T4SPGE1Ikv1lZEDsp6wYGOSota7pICww27olPnI78mWGvipaqilFudFsvNK9Mi3/v9WvPMOgfvGpO7kbhFeIxLvEAfaWxL0YKVt/z/1gmh/SAf3Yq+XLYAq2ydi8Y62+ib/DhC2Cr4+gFA02Jn+nz/nZS+QKXEOpjBd693EEljYTuG1SfwzMpq17TmVeSSW86fvYLAFM5nFgVTJV5ZIF0zOrbhpqEMJxTMzh/nd/TUkf9vC196k+ESU7JzN6jZZN3h6QIn/vDL0KoeMTM06s=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005)(921011)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?WjN2VFlLcGZiVHU5bzJGUXQra2NCOXZUOTMzTW1QaG5EeW9ScXVBUHY2TjJU?=
 =?utf-8?B?VjZEV1pFamdzOHQwejMyYTZiam5LV3U4a2VhTjlaV292cDA2S0pkbHpHVlpo?=
 =?utf-8?B?RVhYSVZGOVVyUUtoTDM3Z2l0N2xRbzY2QmFRbXdmWUFjWHhPQ3RvZlJCa2JL?=
 =?utf-8?B?ZkNwZ1FRNmtXYzNGaWJMUGMzZi9scFliSjdvQVNQQnFQaWJ1alJaazM0VlVV?=
 =?utf-8?B?bkhNMFJhMWQzT3liNDY2bHRITlZaWTBab3lSYWU4MkdFaU5uVkFkNVF0WXFw?=
 =?utf-8?B?K0JGNDdYbGZGenFnMUlzek1zNmNidWI2MU1FWFNMWDhXVkcvemFRWUhLWDJ2?=
 =?utf-8?B?RWU4RWpVM2NNZDhtSE1QZFJvNU40NzhUdUF6U1pDWUdPSWRqZ1BqaVdQbG10?=
 =?utf-8?B?VDFFNWZ0MzBlZFg2MnF4TGl5SkdmWi9qSUl0UzFta1ZtWnBoaEkvVU5mVXFz?=
 =?utf-8?B?NGE1aHJsU08rK1U1cS9ZaE15YktKOEc3NFVBREdKVGM0d243SkVqTS9IV2pH?=
 =?utf-8?B?VGd6Y21acFp1Q0kxSmtabG5ab2xhbk9zUW9CY2RIbVptd2FSa3RuSkFabmhB?=
 =?utf-8?B?K1ZIbEJKNndEdXBZUnVDWnZTR3pqd2srZXY2RDNsRHlsL0tqenZZcVlqakRI?=
 =?utf-8?B?cG5wdXEvSzgzQTl1bE5Wb01XcXhCRXcvSUl0eFpZTmowWDByc1FBTzEwL3Vn?=
 =?utf-8?B?S0Z0S3dQQ3pqZHQxSHJlNlIzSGkxRDUzNUNkSExWdkZYTC81K1RxdWdkU1FV?=
 =?utf-8?B?VXlWd2QyODZXZ3F5dkNhRDFlMFRYdFpmdklDMFg4R08rWmU0eC9TbUJxUW5L?=
 =?utf-8?B?b1FnbHpqcHJNS0YrMVhJd3BBRUkweU1VNEcwQ1J5MFVIMjBNWGdDOGtwcU9t?=
 =?utf-8?B?eERwSmxmemVrRTFPb2JVa3duQm5ISGRmcFNtVmhySWVvVGFrM0NqS3EzWGxO?=
 =?utf-8?B?aldYVmxkMEZjWE10MkZ0b1BBZkF6OHBVeUs4dXE4Rk1NWWY2R2RyUFNkeXZ4?=
 =?utf-8?B?M0dFc24yWmZsZ1l0UFNUa3FvejdnNlhYTnFtREM0MXkvampMeUwwc2hYS1R1?=
 =?utf-8?B?Zkx5a0RTVXByY29Zd0NPWkJ4Zi9VTnlXbUJiM0g1dVRnajRPb0pMT1ptMzZW?=
 =?utf-8?B?am5PMlVpS3JVTHNOTzdWcjh2OFhTV2Y2Sm1wWmtNbEFxUWdJODZyNGZNOGYx?=
 =?utf-8?B?bUlWL1VpTjc0YzNXRjVpTXhLc0xVRFpKQ0hNRUxEcm05YjBxQSt0SDl0WVVF?=
 =?utf-8?B?TkhVdmVwbjcyTnlwRWVOdFcrSjZ6Yk1STldMczNSRWhPWENBTVgrUnJHVVRO?=
 =?utf-8?B?U0RraS9acUVNd0RlWnFBcnczY0l3QXZQYkhEeHlyTUdXOWxLWHF6MDJIdmlz?=
 =?utf-8?B?NVRCN0ZBdTEzV21XR2xEdnFwelc5bGhoNFU3OFdjSXh6dW5ud0xvYlhDU1Rt?=
 =?utf-8?B?OTFSUHlvL3pUemNraEV5eGQvQ3RGd1MyYlRVbERRd1R0aDZabWs0aHdWRDFU?=
 =?utf-8?B?RXJHbWdRTFJBTExMNWdaMU5CdlNQaDA3dE1XYXZWSDlnRU5IaE8rYnhIT093?=
 =?utf-8?B?a2RyM2hGMDFCb2xxWE82SzBadVZkRVBPSFg4dU5lTjVkbnhudkx0VThxUDZJ?=
 =?utf-8?B?T3hqeVEyRnozMDdQdnJXbFRpN002dFNEL1hkelJBdFE3dnFDdWxrdHZNQzJl?=
 =?utf-8?B?S2pWUnZvejZqcTJyU1ZETFp6ZzhpVW0rYzlGZ1k0ZlduWUdDTk5XdUZpOUQ2?=
 =?utf-8?B?WFNFbDdmOEJONVJScnJWbGF6V1JVUmMyRk9QYkxGd1AzaEFaQ1hLbFNwaVJY?=
 =?utf-8?B?eklrV0F3YXYzZC94Z3VqMXZCVXZPR1ltUDR3Nk95OXZFUjBtSURrOFhsbnRi?=
 =?utf-8?B?SjJWMlpsRGtmQ3cwekMxR2liYTBFSzk3MTdMS3U4c21FdFk3UTd6R3FycXE4?=
 =?utf-8?B?SGx1YXRvRUplZC9udy9zTmgrSGkxWXlESlI1eHpwS3ZnK0ZhUUJTbHVpc0NX?=
 =?utf-8?B?ajhGTzJTbWhselZrYWUxaCtPeU82blR0QUpyb2ZYNzkzbWM0RHI0b2V3MWFX?=
 =?utf-8?B?VFl2enk3NlJkc29NRUlwaU9hc1FOdVNyU0FUV3JHS3VycS8vYjlET0tIWlB6?=
 =?utf-8?B?eC9VVUVQRTR3SE1sWUdXY2R1VUxFU2lZSCtYcERFcDM4L0YyMzRESExvRDhl?=
 =?utf-8?B?bzlpRC9Vcm5UUU01UVdiOTlObjRoNUd4aGEzd3dWc3FlVFE0WDBuK1IyaWFu?=
 =?utf-8?B?NGFTV21Wa1hheW5acXhvSjNCcmRnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AD35F5C83A0454D9C755011D058763F@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6579d6c7-570a-4b7f-b91d-08dc496a7891
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 05:48:01.7415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rLzJgnwO2Pm6aEqknx9R5zrd6ZkmOCySEewVcCT/cO+otR5dZyfU3N7dXpsGwCUyoqVA2s/QBqPcot31gN1r8jAcoNV1Q7rcdjA8JOQMbdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB8929
X-Proofpoint-GUID: 1JbyK0H_wVd9NovKtvR5UeQlTJ9v5qIO
X-Proofpoint-ORIG-GUID: 1JbyK0H_wVd9NovKtvR5UeQlTJ9v5qIO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_02,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

DQo+IE9uIDIyLUZlYi0yMDI0LCBhdCAxOjIyIEFNLCBTaGl2YW0gS3VtYXIgPHNoaXZhbS5rdW1h
cjFAbnV0YW5peC5jb20+IHdyb3RlOg0KPiANCj4gVGhlIGN1cnJlbnQgdjEwIHBhdGNoc2V0IGlu
Y2x1ZGVzIHRoZSBmb2xsb3dpbmcgY2hhbmdlcyBvdmVyIHY5Og0KPiANCj4gMS4gVXNlIHZtYV9w
YWdlc2l6ZSBhcyB0aGUgZGlydHkgZ3JhbnVsYXJpdHkgZm9yIHVwZGF0aW5nIGRpcnR5IHF1b3Rh
DQo+IG9uIGFybTY0Lg0KPiAyLiBEbyBub3QgdXBkYXRlIGRpcnR5IHF1b3RhIGZvciBpbnN0YW5j
ZXMgd2hlcmUgdGhlIGh5cGVydmlzb3IgaXMNCj4gd3JpdGluZyBpbnRvIGd1ZXN0IG1lbW9yeS4g
QWNjb3VudGluZyBmb3IgdGhlc2UgaW5zdGFuY2VzIGluIHZDUFVzJw0KPiBkaXJ0eSBxdW90YSBp
cyB1bmZhaXIgdG8gdGhlIHZDUFVzLiBBbHNvLCBzb21lIG9mIHRoZXNlIGluc3RhbmNlcywNCj4g
c3VjaCBhcyByZWNvcmRfc3RlYWxfdGltZSwgZnJlcXVlbnRseSB0cnkgdG8gcmVkdW5kYW50bHkg
bWFyayB0aGUgc2FtZQ0KPiBzZXQgb2YgcGFnZXMgZGlydHkgYWdhaW4gYW5kIGFnYWluLiBUbyBh
dm9pZCB0aGVzZSBkaXN0b3J0aW9ucywgd2UgaGFkDQo+IHByZXZpb3VzbHkgcmVsaWVkIG9uIGNo
ZWNraW5nIHRoZSBkaXJ0eSBiaXRtYXAgdG8gYXZvaWQgcmVkdW5kYW50bHkNCj4gdXBkYXRpbmcg
cXVvdGFzLiBTaW5jZSB3ZSBoYXZlIG5vdyBkZWNvdXBsZWQgZGlydHktcXVvdGEtYmFzZWQNCj4g
dGhyb3R0bGluZyBmcm9tIHRoZSBsaXZlLW1pZ3JhdGlvbiBkaXJ0eS10cmFja2luZyBwYXRoLCB3
ZSBoYXZlDQo+IHJlc29sdmVkIHRoaXMgaXNzdWUgYnkgc2ltcGx5IGF2b2lkaW5nIHRoZSBtaXMt
YWNjb3VudGluZyBjYXVzZWQgYnkNCj4gdGhlc2UgaHlwZXJ2aXNvci1pbmR1Y2VkIHdyaXRlcyB0
byBndWVzdCBtZW1vcnkuICBUaHJvdWdoIGV4dGVuc2l2ZQ0KPiBleHBlcmltZW50cywgd2UgaGF2
ZSB2ZXJpZmllZCB0aGF0IHRoaXMgbmV3IGFwcHJvYWNoIGlzIGFwcHJveGltYXRlbHkNCj4gYXMg
ZWZmZWN0aXZlIGFzIHRoZSBwcmlvciBhcHByb2FjaCB0aGF0IHJlbGllZCBvbiBjaGVja2luZyB0
aGUgZGlydHkNCj4gYml0bWFwLg0KPiANCg0KSGkgTWFyYywNCg0KSeKAmXZlIHRyaWVkIG15IGJl
c3QgdG8gYWRkcmVzcyBhbGwgdGhlIGNvbmNlcm5zIHJhaXNlZCBpbiB0aGUgcHJldmlvdXMgcGF0
Y2hzZXQuIEnigJlkIHJlYWxseSBhcHByZWNpYXRlIGl0IGlmIHlvdSBjb3VsZCBzaGFyZSB5b3Vy
IHRob3VnaHRzIGFuZCBhbnkgZmVlZGJhY2sgeW91IG1pZ2h0IGhhdmUgb24gdGhpcyBvbmUuDQoN
ClRoYW5rcywNClNoaXZhbQ==

