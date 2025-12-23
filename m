Return-Path: <kvm+bounces-66574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4C77CD80A8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:19:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47F333038282
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A1BD2E03F1;
	Tue, 23 Dec 2025 04:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Re97dwXH";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="oilsqgXx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147D517C211;
	Tue, 23 Dec 2025 04:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463482; cv=fail; b=Kvl6wmfENfQlmvTb+8gX8gsy9uts1FeZr8oby1jclS0S/WsTKXb6uc3aG52FYBINeL0TjK7HIGTPJNlflMjcssRV8ryBkDtrcH7/jRtce4i0u+mu47KD6upixO7cP7Gb+sYCIOoLhLlmb0eOaiZ5clYGXefkipstnyk8VIpZF2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463482; c=relaxed/simple;
	bh=NqZ91GR4ljaGXj4sDRLP/EAfaXnkp9RGZiLOA4tidd0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rqi2QUIgeBYpLV5R97uHXA9OQ5mwNg5N+nBY2gVlOaRdwjsHaZNkwE1u739a4ygjkr2McPbn4my1cXiUhAGcEWbBSDUgcUiiub+0q45i/bEeVt8K3DqOmdX9aj5a3W8svQC+Alm/6wqjJ/lj1STse0LzZfCuLkuqsylHx+/OdfM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Re97dwXH; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=oilsqgXx; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMHLI3N2280199;
	Mon, 22 Dec 2025 20:17:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=NqZ91GR4ljaGXj4sDRLP/EAfaXnkp9RGZiLOA4tid
	d0=; b=Re97dwXH7Ooshqv7Sm7333fyFR6AaH1pGl+l6X70XS0MiYuRp2MOWca+d
	UJ1S5o8zPykUfXjHITDRp5reANfSZCIFYm664bw4vlr1u9B/wdSEjtEfBrVNCWyj
	2A8qR4kF4XNUfCP0CnU4CgLDpcHLwcLJUzoALzYJxKSKxBt7akGpUAx/5sCCDiE3
	N9fN9dmrJUnrkkviGxWb6ShyiIbNJpDPspxRI2RfJGFUlDVYqMDTxhKyRS8c+MDY
	TayWOYhufvLjTepA+S8nzboQQNVEh/Izs1T5ghrhctBuTASGGVGgWHtTX79HUOXM
	Tv5IIyqPT8HJJoUjCgkWkCDPPKPTQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11021082.outbound.protection.outlook.com [40.107.208.82])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5v7yvrjj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:17:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ci61+pOFn3mj8VgJ/0sRe34Wj/r4H8lEhk9VhKuk/eKuQfdBHV2gkL0LwNrXjZ1jERPdVFhf2U6Fcix+fitvEA6aW4dDwB0UjDL/eocPBugOBczs8Th6uQKt6gaQEF2V9v0n8mq+bsSyfGSDAHKuHdStTfiRSId1gIklOI54PvONItfb4rghCs4FIlL93dS9y9jJPnuATPLyo1t4Z15xPcz4iY/9nQV7uEQNBGnMmHuESabfnYH8uKwE3pbu9ooTv+6XQ0N8L/ncAIxowPxHM3DjJtehV/V5RdxUqZS/IL9rziKlT1pPm0nx0Ad3Xt4eQOU2wMMii9vH422YC2nbEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NqZ91GR4ljaGXj4sDRLP/EAfaXnkp9RGZiLOA4tidd0=;
 b=an8bIKYWgZXC0wRtmdjrw0fnn+hkADDWDs0lyrZETl9iq+pIw0iF9hcf0NYn4CB9mI3H5aEmLetiTPl1ucszAKVDtVn6WTZOSJuHn5w23U0AUf+qR6OuNz0oL0EEzx6MCX1mbMzxuoe1uvVrsh2hUC8rbIq/d7rrszcjgWxgEMuaZaDK11GQgfU/7n21eyvUDLYJ8Ihvg7scK5qDUzadpRFGeaIBh7K4It3CqLnLwrC7zyF/o3lkQiKbJBqXZWUiO9RCCHEqAeN342TXlkeAX7/gXzke34FTelSBkALxjylVPCBiA19YJhU2/aF5cEeAhueMhCINOdE4lfijGuCO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NqZ91GR4ljaGXj4sDRLP/EAfaXnkp9RGZiLOA4tidd0=;
 b=oilsqgXxwaLiwJjpxHOw3Znn5RcJt7o02APnYDCcrlEa1951R+VlTY4eET0J+yapsS3iS6Zr7btyYNEnh764ALXTpZGfQJ8zgMJTh2BJFIfxzwbY9oGabqbcmz2A7xT7GW9ftUzFgx/yrhzS2F3LXqhnr9CuaKiWo3//z0AuOhIaX+qwGuoG0rAEG9vCwXPCaBV3l9S393o4dUAwJ9ghDdKGx6f8mvyfe08nRxg9OpOXKceWHDGiTplbgzed63XtbwLroKDwokGwK+qHn6cpRpsdEtTRTV7vKrA2jMaJDfnTEK9xE9CITqVrRrFY9bUYMwOuo13ToLSYr4kyTvLNxw==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH2PR02MB6933.namprd02.prod.outlook.com
 (2603:10b6:610:88::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:17:28 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:17:28 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Alexander Grest
	<Alexander.Grest@microsoft.com>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Tao Su
	<tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Topic: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Index: AQHblFPgL0brNbuxF0+4/LV272jmjbPP5hMAgWB3UgA=
Date: Tue, 23 Dec 2025 04:17:28 +0000
Message-ID: <76E7FF2E-D430-41BD-9270-62761AC836B2@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <aCJsSvc4_azZNrKI@google.com>
In-Reply-To: <aCJsSvc4_azZNrKI@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH2PR02MB6933:EE_
x-ms-office365-filtering-correlation-id: 1d2333bd-9b2d-40ad-30b3-08de41da2f82
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?N0dBL0NxT0VzbHdrSjgxcnNuUkV0WldvZkhzTXR3WThWTFUrM3RNTGsxTC95?=
 =?utf-8?B?VmRZaU9BdGFISWpMVUoxdzQwS2J3Nlk0TEJjTXRnMkRJU1VzWUpNT29SYkJO?=
 =?utf-8?B?UFVNYzBFZFV5QVNlS1djbVlkTTFEQlN1T1dtSGVtbU4vaXVLSWljNFByWEkz?=
 =?utf-8?B?bG9QZ2trUkw2MmRsaG1EQVkzenBDWmJjNVd1dXViVUxkNmF6Y0F4Rld1a1lx?=
 =?utf-8?B?NzNWM3A1Qm00d2g3alFpSjRUS0pUZzZzbkFPYUpWZzdZa2JLNjFrdG80REJG?=
 =?utf-8?B?Tis2MGpIeGZ5ZFhxWUplWDhTZysxbXdkQ0hqT0JuSXU3YzNKdEgrNzQ2c1FC?=
 =?utf-8?B?N3JPN0pKVFV5T2lMMk5oQ0lLWi9zYUJwN2l2UWZhV09qOGg2VncwWGxEMGVu?=
 =?utf-8?B?dDNSN1ppbGg0NDVCenI5R1llM3FMZkcxQUZXUzQ2N1Y3TUhzK2ZGUk9YYXNl?=
 =?utf-8?B?cHkxRWNPQUpUMThYdHpWZVBpRDZDNXpGR0E3SEJpeHFMZm1EYkN3bVlzd081?=
 =?utf-8?B?bTJNcG4wMmdKWFU2VTA1aWhaYzR0NE5vMW9pdlBhVXB5ZzV0R2JRZGhOamNn?=
 =?utf-8?B?dFN2MWo0VVduN0xwbE5ETmVLUXBuUGtJTHhQKzRhdmJqNkIrWnozSEZnQm5K?=
 =?utf-8?B?TVFCa3k3cVVQNi9wZjNDUGxTU2hqNjF3cGFlNHhsaTBjRkZTM1pjQ0ZhamhD?=
 =?utf-8?B?MDJYR0VuUUowWGk3QVV5VUpNZnB5MktyU0lzdU1vc1Zybzlkc0FIMmRWUzQw?=
 =?utf-8?B?MlE5N0tJMDRObjIzZGowOGdXclpCNlhpcURtcFgyRCtWcWc1bWNjS0hEOTRR?=
 =?utf-8?B?UEJlUUg4a0NTSU41RDZjRGNVa2ZMdm56SmMwdGd6c29UZ1pYUm5BeGtjV2VN?=
 =?utf-8?B?b1pJU0RGcS9yY2R5ZkluZnlqd1NldGJkYlc3NExnRUpJdnZXVU9vL04vNmJZ?=
 =?utf-8?B?TWRiS1hyV0pBWml5c1VPMmt3VS9CdGhocnYwclU0ZHQxRFJnb3ByYUlvQkE2?=
 =?utf-8?B?SUlnT3BrVWRleUtoV1d5Q0xzSDk0aHZZWlVXZnFaZncvZU9ETTVMQW9aUmVz?=
 =?utf-8?B?b2ZzZjgzYlBKeEg0Y0F0d3ZxMUE0K2NMbEl1OTFnM3lxMEVsRHNHRE5LSUR4?=
 =?utf-8?B?REFRM1U2U0o4dzFFRnM5Qzc1OGIxYS9udy9zNGVWd1cxQUpPNGl6N3lzcjlp?=
 =?utf-8?B?TzNRNkEzU085dDlybUs5MDdZb1IxalJxcDZ5c0tMMWs5dDVWOHVSQkUyZFYv?=
 =?utf-8?B?K0JuRXg0QUkxaldFb2MrQUpzcVp3ektzUGNiK1AzeTNWclhHaFgyaU5PWDVN?=
 =?utf-8?B?cERSMUxwWTB0aVBTeUV6b1BHKzB0UUtUVFowVHY1dUl6SlpnU3ZNbW5hSFVu?=
 =?utf-8?B?MHR1aDZTc1FTMFFrNHQxWVh1cU9DWUo3cVVJR1NxNGJLTlEzZTNLblN2OVdn?=
 =?utf-8?B?eDJMUDJPTDVjcmgxcEliaThtL2p0UytPRVJUUTZEbUtWQUJybGhaSHpreFNx?=
 =?utf-8?B?TGptaTZxYVVTemVzeTJMU0JvVjl3N0Q0Y0JQYTV6YWFZWDUyeEZ6UmFSR3E3?=
 =?utf-8?B?ZXBBTUN6Mng3THV3MEw1dUVsWUI0NFIxWGVvMFdRNWVUOGREblQ5QjNnWHE0?=
 =?utf-8?B?UEVSalhNZDIvclJ4ZDhrM0ljVVp2TUpGanBBRW53RTJXQndCMHNBMGliRS9K?=
 =?utf-8?B?MitlaEcwcHI4RDAxRWplSGdsRnlHNWpKU1VvS2YvTTVvMUw5ckg1Z01vSTd3?=
 =?utf-8?B?c2lrOHU0NU42TkVraWk0QXpseFE4dVZSRlVCclh1bXd5bUphSGtDSVU2Vmxa?=
 =?utf-8?B?b2lnYkJYdjMvWXpTbVZMMnN6M2Q4b1oxc2owZTRQZFo1RzkyMlVjQXVQK25a?=
 =?utf-8?B?SkliYWk3R00xb1NWM3hWaGN2Y2FwQkg2UVVzaXB2ZG1kY3FIcDhScEtJbWlG?=
 =?utf-8?B?Ynl5bE5uU3JCNkgxaXZsSVUzL0JGQmhaZkUwazE3ZGp3SUt4WkFPQVgvY1FM?=
 =?utf-8?B?bXN3N0lYYlFwdUc0Z0VIVTVvb3BOMy8vUUtxM01TZDUwMnFtWmZMRXVib2Iy?=
 =?utf-8?B?eUhBL3dPUzJuY3F5QkFRbkN3U1Z5NlFKVkxNUT09?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VUpYbkNwb3FZMzB6K1l0U3dNMm14cHMyMmRyT3ZOSVNkelJlaGpGQ2ZRc3Fv?=
 =?utf-8?B?Y2tTVGNzUHNsdHJFSEVLRFg4ZjBYZTJGVUwwamxvc0RKdzRlZHpPdVNESDNN?=
 =?utf-8?B?YklVaW9uc2w3QXh1RFNmSmhubDJCODZldy8xd2QzdG5mN1I1aWdTVTNDaTVB?=
 =?utf-8?B?cU1KRFhwOWZ2b2FvU05IMDBRaWpFSlNYNE0vWk5FTm1jVzZNcit5OFlQbFhE?=
 =?utf-8?B?dHNCZmJLZ2Q3c2srVWFpUkxxTmhJNUtOekdZZzN0N2FJYi8wY2pFMitBRHlH?=
 =?utf-8?B?cUZiUVM4TWsxTzBOT20vME1CVlJXQWpqZnpQN0RjYTYzWVRoVVJkeFhTaG5s?=
 =?utf-8?B?MUFHa1Y1d0dRT005TjJsRllWNW9RSjlDTmowOW02RC9UZWY5WER0YlA3TjVs?=
 =?utf-8?B?dTkrTXBJWXRvS1hydzY3emJJSDVIZ1VuOXpjazd2dDVla2Nld3pIVlhteE5q?=
 =?utf-8?B?eXV5MlFUWFYrSVdlNHB3NU1EUE52MmJhQlMraFBJMVQwcEdEVnRmbDhKT0o5?=
 =?utf-8?B?c20yc2wyQUR5enZVU3RIK3R0UkdYa0lUYm1XcGVjTXR1R2Y3TjNmQytRWUtu?=
 =?utf-8?B?UVp4VWNBYkVUeW5MZUlRbjZ2aklvcVY0aXBtL2JGVXhKblRkQWlhN0dlbllu?=
 =?utf-8?B?UjZuQktXNmYrRTNMaUZQbUtuSFdya3o4R3FRMjc4RDZZRzZoKzI2cFY0ejhJ?=
 =?utf-8?B?anhJYU1zWmR6Q29CMWNVVXhkOFZTbW9UbVZadTNFZ1F2aCtvNVRNOE9wVVMx?=
 =?utf-8?B?MGJxM3htZGdkNjRsKzlUYkhtbThGT0xsaUVFaFBDcGVyaHFIVmZqcCszN1FV?=
 =?utf-8?B?S1F1UXZzMlVHVGVwTFZGNHdBRElvN1VrSTdtYU90Y25uYjBDSVV5OHpQWnY3?=
 =?utf-8?B?SVZkWGdmMjgwdFYxZ3lkY2IzYTFrRWFQazlFQjNBa3Y1VUgvRUd3c05wcStV?=
 =?utf-8?B?NkdoTWZsRDVjVHZHTjVWamFPSlNLZ3BlUWR6R3VaNjVlYVM3WFRZREY3QTZa?=
 =?utf-8?B?enZzVmVETzh2bWtYY0JXTCtBckNrY2t1akVIOHlEOTFoM3BsVG9jRHNKcTFx?=
 =?utf-8?B?S2IvaXJVY1VyZ2Q4UkNPS0VNSzJDVmJqRzlNWkRDaTQzcGlrR3luRzhOUlpW?=
 =?utf-8?B?YXUzbW5uekdjK245UUFiQXJBWUNXQW5pMTFNejZlN3I2dTZIMlNLTTBMaEVO?=
 =?utf-8?B?V2E5ZG9WMXFFWmpjTUZmTnNQN1Vrc2xUdGRJQlYvM3p4a2pickRqYnkyS3ps?=
 =?utf-8?B?a3ZySWdMYXZCTTI0c3k1NWtGb0todm9SWUNGU3c1bXdVbnh0dXNVdUNVMnZJ?=
 =?utf-8?B?OXdrUkxjbXJaVHMyM0d3ZEZ1ZEFtQmRlNVBWVVc2V2U0NDRuQjg2Z2NzaXpr?=
 =?utf-8?B?RmcvdFRLdWJlaUs1Um5rTW9idTUvNWdKZThGTWpLbFJ3RzIweUliWWk3TnhX?=
 =?utf-8?B?Q0lHdnZRRTE3SVQ0Sm00TXZrT0dIMVkzVUVjUzgycU51bjlsZk9ma3RicWp2?=
 =?utf-8?B?RTgvNUFxZ2dKU0JyaDFERUt2a0NFV3JKdjA5NThnbXk0aEpwcWFQdTBSRVIv?=
 =?utf-8?B?ZmpjSlRjZ1pCOU9ONGJiYXlrQ2FhRkorc3FKV2dDZ0pzRnB3WmticGRVL3dQ?=
 =?utf-8?B?MWxqeWZVVFVxYWFIQWJtWkRacmk2VGg4UWlrSDRMT2RFZ2M1L0V3WHNSWEx0?=
 =?utf-8?B?a2lxeVFhZ25ueXY3UDlZbC9aaFNZRTJYaFRJMldoaExmRGJaYXlFK0MyRGtM?=
 =?utf-8?B?SW9iQUEwcXZta2sxM2RxVzIyYWYyOWZGa2loYU9VR2VBU21vRjZQR2tKOFZ0?=
 =?utf-8?B?SE9Wc2svNllSZUdKbmM2YVhqS09RY29YUVhVdVJ1RmN0MnpNMUZmR0lOdWVS?=
 =?utf-8?B?bGc4ZUxxU2V5Y3B0bWxBanBCRVZ2cEVQOWNqR2tlV2RkZ29xNDE2c0VQWUVv?=
 =?utf-8?B?aUpiZ0FWVjY2eG8vVXVzU0pGWklxTHY2N2xGdmFLSGZvc3R0WXlER2hmRk9n?=
 =?utf-8?B?dVV2OGRCK24xa3YzcDJkTjlvTmgyc3dxdVQwd3BNZVF4djRxTkxLNDI4L1Ur?=
 =?utf-8?B?WWZncjNFdGRBbXUvMlA4b3dtSFpqWFIwaXBlVDBnaXhCSVNxMndWcTJnQ1F0?=
 =?utf-8?B?aVluNzhuazVJM0o2N3FXaC95V2N3V0lhUmZqUzErTVRXVkp5czY3MUdJeHkw?=
 =?utf-8?B?N2pYeFJaTzZSZmMydkNPeWV3MCt5c0NKbCtaYk1keXNzY21PVXJ6QlBTSjJk?=
 =?utf-8?B?OTZ0UVJkekVkbEk1Rzcxa3JLV3A1VFdyZC9tVGdsN1I4eEhTekVkWDd1WUJu?=
 =?utf-8?B?RTZxd1NaMkxvOEFZU0ZRRkRuajFrUWVwOWFrVEVqMkZLMXFPa01YOGVWdHg3?=
 =?utf-8?Q?9RtqyRxM3uZdmC7tNtqxxCKtZDPgwZzrTm2MSurf7gtDZ?=
x-ms-exchange-antispam-messagedata-1: UalGwIHN8UP482kOpldR1s/QiOaL776cz/I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0CAA73426ABC534AA3E6B28BBFCC7E20@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d2333bd-9b2d-40ad-30b3-08de41da2f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:17:28.8668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T0uU7SF863CxNHgUHLkDihyTRYwITiuEla0yvAIkSEOeQE9h944N2GwTt+Ijeuq1CfCpWkkMLK13WzPjo/9304Hpd05FAXncjDbmO9J2IDI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6933
X-Proofpoint-ORIG-GUID: DgKYa5pTMgC4bMAC-IXANrrAqjHH3V_H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX1IPmGk+9JzqE
 cI1+vAK1RqZleapXbDQQE/IUFbl76+arK1Gy6XCDr4H6nWxKvmLp7++1DQZa3n7JiNOUw653VC5
 66YJy7Qt1MakzuEKQk+Vmo5EHPf7P4Uu2h48ygdbsfZku0bu3ksWbAzZD+V75Z3fAuUzKcGlLmY
 MuYbNhXBeBG5e2j1CdQ4Me0/VJnBimEvL4lADS9MNOTeYwO85MrAJNEjPRs2DABjo8uw57e2dQi
 NZ2l3JgGmIi3GfyMvQl3pVHU9VFemJw1USsNhe61N4N8LM0OOCyiMGkDi/PdcY/rDMYSU8qLKJd
 62P0lXmHKTCZ2cDRWeFXZ8aQfCSXlrcw/fKkyrcOK2b9B9lRBiD33qOO6nw4UlJj0tJdEFGX2vb
 FBHnZuQrxb6CGyq/4Mn0zgKo1iUQna4WHHuO6UOqRseyc/vOaTqT0W/tmV1UO93/nQXdon70a1d
 B/PIswvNCMRtKK506XQ==
X-Authority-Analysis: v=2.4 cv=S8TUAYsP c=1 sm=1 tr=0 ts=694a17da cx=c_pps
 a=Wfyg2MIdxp6jvjeZNnPfXA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=NEAV23lmAAAA:8 a=1XWaLZrsAAAA:8 a=B6I2y0zZYI9ASOGh6RsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DgKYa5pTMgC4bMAC-IXANrrAqjHH3V_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjQ24oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gIyMgU3VtbWFyeQ0KPj4gVGhpcyBzZXJpZXMgaW50cm9kdWNl
cyBzdXBwb3J0IGZvciBJbnRlbCBNb2RlLUJhc2VkIEV4ZWN1dGUgQ29udHJvbA0KPj4gKE1CRUMp
IHRvIEtWTSBhbmQgbmVzdGVkIFZNWCB2aXJ0dWFsaXphdGlvbiwgYWltaW5nIHRvIHNpZ25pZmlj
YW50bHkNCj4+IHJlZHVjZSBWTWV4aXRzIGFuZCBpbXByb3ZlIHBlcmZvcm1hbmNlIGZvciBXaW5k
b3dzIGd1ZXN0cyBydW5uaW5nIHdpdGgNCj4+IEh5cGVydmlzb3ItUHJvdGVjdGVkIENvZGUgSW50
ZWdyaXR5IChIVkNJKS4NCj4gDQo+IC4uLg0KPiANCj4+ICMjIFRlc3RpbmcNCj4+IEluaXRpYWwg
dGVzdGluZyBoYXMgYmVlbiBvbiBkb25lIG9uIDYuMTItYmFzZWQgY29kZSB3aXRoOg0KPj4gIEd1
ZXN0cw0KPj4gICAgLSBXaW5kb3dzIDExIDI0SDIgMjYxMDAuMjg5NA0KPj4gICAgLSBXaW5kb3dz
IFNlcnZlciAyMDI1IDI0SDIgMjYxMDAuMjg5NA0KPj4gICAgLSBXaW5kb3dzIFNlcnZlciAyMDIy
IFcxSDIgMjAzNDguODI1DQo+PiAgUHJvY2Vzc29yczoNCj4+ICAgIC0gSW50ZWwgU2t5bGFrZSA2
MTU0DQo+PiAgICAtIEludGVsIFNhcHBoaXJlIFJhcGlkcyA2NDQ0WQ0KPiANCj4gVGhpcyBzZXJp
ZXMgbmVlZHMgdGVzdGNhc2VzLCBhbmQgbG90cyBvZiAnZW0uICBBIHNob3J0IGxpc3Qgb2ZmIHRo
ZSB0b3Agb2YgbXkgaGVhZDoNCg0KTG90cyBpcyByaWdodCwgZm9yIHRoZSBFUFQgc3VpdGUsIHRo
aXMgYWRkZWQgMTYwMCBpbmRpdmlkdWFsIHRlc3RzIGFjY29yZGluZyB0byB0aGUNCnN1bW1hcnkg
YXQgdGhlIGVuZCBvZiB0aGUgc3VpdGUsIG5vdCBjb3VudGluZyB0aGUgVk1MQVVOQ0gvVk1SRVNV
TUUgZnJvbSB0aGUgVk1YDQpzdWl0ZS4NCg0KU3RhcnRpbmcgLT4gU1VNTUFSWTogNzc4OCB0ZXN0
cw0KQ3VycmVudCAgLT4gU1VNTUFSWTogOTQyNSB0ZXN0cw0KDQo+IA0KPiAtIE5ldyBLVk0tVW5p
dC1UZXN0IChLVVQpIGVwdF9hY2Nlc3NfeHh4IHRlc3RjYXNlcyB0byB2ZXJpZnkgS1ZNIGRvZXMg
dGhlIHJpZ2h0DQo+ICAgdGhpbmcgd2l0aCByZXNwZWN0IHRvIHVzZXIgYW5kIHN1cGVydmlzb3Ig
Y29kZSBmZXRjaGVzIHdoZW4gTUJFQyBpczoNCj4gDQo+ICAgICAxLiBTdXBwb3J0ZWQgYW5kIEVu
YWJsZWQNCj4gICAgIDIuIFN1cHBvcnRlZCBidXQgRGlzYWJsZWQNCj4gICAgIDMuIFVuc3VwcG9y
dGVkDQo+IA0KPiAtIEtVVCB0ZXN0Y2FzZXMgdG8gdmVyaWZ5IFZNTEFVTkNIL1ZNUkVTVU1FIGNv
bnNpc3RlbmN5IGNoZWNrcy4NCj4gDQo+IC0gS1VUIHRlc3RjYXNlcyB0byB2ZXJpZnkgS1ZNIHRy
ZWF0cyBXUklUQUJMRStVU0VSX0VYRUMgYXMgYW4gaWxsZWdhbCBjb21iaW5hdGlvbiwNCj4gICBp
LmUuIHRoYXQgTUJFQyBkb2Vzbid0IGFmZmVjdCB0aGUgVz0xLFI9MCBiZWhhdmlvci4NCj4gDQo+
IFRoZSBhY2Nlc3MgdGVzdHMgaW4gcGFydGljdWxhciBhYnNvbHV0ZWx5IG5lZWQgdG8gYmUgcHJv
dmlkZWQgYWxvbmcgd2l0aCB0aGUgbmV4dA0KPiB2ZXJzaW9uLiAgVW5sZXNzIEknbSBtaXNzaW5n
IHNvbWV0aGluZywgdGhpcyBSRkMgaW1wbGVtZW50YXRpb24gaXMgYnVnZ3kgdGhyb3VnaG91dA0K
PiBkdWUgdG8gdHJhY2tpbmcgTUJFQyBvbiBhIHBlci12Q1BVIGJhc2lzLCBhbmQgYWxsIG9mIHRo
b3NlIGJ1Z3Mgc2hvdWxkIGJlIGV4cG9zZWQNCj4gYnkgZXZlbiByZWxhdGl2ZSBiYXNpYyB0ZXN0
Y2FzZXMuDQoNCkdyZWV0aW5ncyBmcm9tIERlY2VtYmVyICh5aWtlcyEpLiBDb21pbmcgYmFjayBh
cm91bmQgb24gdGhpcywgSeKAmXZlIGdvdHRlbiB0bw0KcmViYXNlIHRoZSBlbnRpcmUgc2VyaWVz
IG9uIDYuMTggYW5kIGluY29ycG9yYXRlIGFsbCAob3IganVzdCBhYm91dCBhbGwpDQpjb21tZW50
cy9mZWVkYmFjayBmcm9tIHRoaXMgUkZDIHNlcmllcyBpbnRvIGEgdjEgc2VyaWVzIHRoZXJlLg0K
DQpJ4oCZdmUgYWxzbyBleHRlbmRlZCBLVVQgdGVzdCBjYXNlcyBhcyBzdWdnZXN0ZWQgKG9yIGF0
IGxlYXN0IEkgYmVsaWV2ZSBJ4oCZdmUgZ290DQp0aGVtIGFsbCBjb3ZlcmVkLCBoYXBweSB0byB0
YWtlIGZlZWRiYWNrIGlmIEkgbWlzc2VkIHNvbWV0aGluZykuIFRoZXkgYXJlIG1vc3RseQ0Kd29y
a2luZywgYnV0IGFzIHlvdeKAmWxsIHNlZSBpbiB0aGUgc2VyaWVzIEnigJlsbCBzZW5kIG91dCB0
aGVyZSAoYW5kIHRoZSBtaXJyb3IgbGluaw0KYmVsb3cpLCB0aGVyZSBhcmUgZm91ciBjb21taXRz
IHRoYXQgSeKAmW0gaGF2aW5nIHRyb3VibGUgd2l0aCwgYW5kIEnigJlkIGFwcHJlY2lhdGUNCnNv
bWUgaGVscC4gSeKAmW0gcHJvYmFibHkgbWlzc2luZyBzb21ldGhpbmcgcGFpbmZ1bGx5IHNpbGx5
Lg0KDQpWMSBzZXJpZXMgd2lsbCBiZSBvdXQgdG8gTEtNTCBzaG9ydGx5LCBidXQgaW4gdGhlIG1l
YW4gdGltZSwgR2l0SHViIG1pcnJvcnMgZm9yDQphbGwgY29tcG9uZW50cyBhcmUgaGVyZToNCmh0
dHBzOi8vZ2l0aHViLmNvbS9Kb25Lb2hsZXIvcWVtdS90cmVlL21iZWMtdjENCmh0dHBzOi8vZ2l0
aHViLmNvbS9Kb25Lb2hsZXIvbGludXgvdHJlZS9tYmVjLXYxLTYuMTgNCmh0dHBzOi8vZ2l0aHVi
LmNvbS9Kb25Lb2hsZXIva3ZtLXVuaXQtdGVzdHMvdHJlZS9tYmVjLXYxIA==

