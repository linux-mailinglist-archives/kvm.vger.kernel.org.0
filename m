Return-Path: <kvm+bounces-44461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 581E0A9DCE7
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 21:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98E0E925811
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 19:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9773A1DF99C;
	Sat, 26 Apr 2025 19:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yWD5Z+L8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bb05ASbR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2B11D63CD;
	Sat, 26 Apr 2025 19:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745695315; cv=fail; b=MDr3Z/0nePKDOmPcHAJEWdWab8ssWF7Xrg+VVCb0R9Dn/QJw/Vh/rbwRvyzcOt2iOmJ/WqkdgDTYDi2A/Xgl0SQ6IHcd5eiJPWTKpf6Hm+eavE8jwD+3/d6o9tsc/8gRqKVRfkLYNDL2qxcTU+atXiPtN2BNDm7aSM/NZlVviX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745695315; c=relaxed/simple;
	bh=Cin1bWWzVHZJMPi/haKuEtFR9Ase7h7Pe9Ele7c9dCg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L3PA+XSmH5a15Da6NQhgmFaeMpEWvqVwLy2krIQvkUMmIan8BMclcaSqZ1f0ygzLleX6+m4d0O9r7UpZ/5Uxoey5LNKRsVKzEGSjBQlWX+GAXbaMtp/nlMLZpgpZc6I/Xne4UtVQr61Cla8AerkvSdFbpPVWee4JnhLjzB/2lSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yWD5Z+L8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bb05ASbR; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53QBv5AU001208;
	Sat, 26 Apr 2025 12:21:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=Cin1bWWzVHZJMPi/haKuEtFR9Ase7h7Pe9Ele7c9d
	Cg=; b=yWD5Z+L8poWLM/alIkzJEgFl3XdjIAucXuIAYLWlMFPP52woZCVWRfxB6
	0oHRXrpWDV1nH99ZYy5Q7nuSGI+S2JgZezLHyTG9GQbgle5RGH5U+b700cXFofH3
	aYLt3wwuEji/NI3MpYhhZPpAkjkknmnj4PKP4IEgQ3N04Fa+hH9naAVUOrTGuHAe
	A6netqXISSq6UzOT3e0NTRZlSUWsJtMEXc7xVxt/yENa7Lo/EnJKBcy6vpNJOM98
	GWhFkusETUVqP+CL9XDaNeHSXgC8Dh4XP+pa2uAVm6q2bIlHnrIOM1Qq2u5DdULc
	xaA3Nio+TwOlak+3kAuI1gyCYjBbw==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011030.outbound.protection.outlook.com [40.93.12.30])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 468y1y8cmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 26 Apr 2025 12:21:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TPjK+Nh7VKnEn3BlImbivQqLyEsC/HI7MyOJVQ79ZQwsuhivtPKjIt70Hb0xr1xdvtbb5COna70qsqCzq4E3M11qGK9eNgPghEr0cdjaEOF2YSH3b8AYcz/EWda+/JuMDLoHZPhwt8OlI+9xUsJBVQq78lTYm4jK/ksa03IpGAjMDsAt7Uj548npSyRH9jsqEoj/rsTHgOdqN+cxFPJdMasy68RzAMCd+GDVvk3AR7LJpGWuWoEdttdx/3+JFItl3iAOL4OroyYpA5Ez6hZRGGdOfvtaiMb6i1R9rWwRRuj7zuBKasO1EKWIqQ525zvtMGNBQu561KnQ3hHbmH8t/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cin1bWWzVHZJMPi/haKuEtFR9Ase7h7Pe9Ele7c9dCg=;
 b=ZTxjwKHtl3TeSO+4oKV+CkS+seO7wrZf/p62E2cnCWq9k5VoEKW8xihMBkIql2CDSoQC96gkedmJSFFd5fo197sPLeO5lhVnkfWNA+AzJ6scR7AT/s20a+2UNDF0olab1Jc0Z7KpoWxT+gB+kKtDBMdWTeNZysJBMiKFfr10R/PCyKSjOYVkbD41wemmRIEnpOj3JcX0dH5CgXqxbznR5l3zFZT0T3bQgCjo1QGN3z6Mu0GuExBPI0WzH+tZ7LtKfqEWI3hmnzy5p0awT4XJmOr81dJA5kjwXBF57eLnBJplVy35TGrA1KIAAoxZv+ZWAlAc6/stHxlcEqPqrdQEBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cin1bWWzVHZJMPi/haKuEtFR9Ase7h7Pe9Ele7c9dCg=;
 b=bb05ASbRq7NvQjFJ1jJJM5Fid70IMnqSRb1mheVOFv9a865UsLIOKAnXwPimgy5VCfnhH6FBRa13w20mi0mNmJfcn0uKC6xdNlimSPh+UkhZy4IEzOOY5plZb2yqtpdLbhmvl3QL8qaXkBeFAeXZkceKN5ylLRgE3q6G/v9fzHL8kBZmKFVJWMP5BsRtVAZgsDLe00Zl94yaCy8jBnXvC7IG3dfWNnht56xamSVQLGPeDjAdlw+fu/0Ie6bj7HUbxJmlBkrmCQ7xBqR4fLC/Z/0ASFP4W0towkZ6ZHUn7FPV+m5ca2QSVenbXwfUbJZzrn45K3/H5yRGjCigm9AYZA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CYYPR02MB9785.namprd02.prod.outlook.com
 (2603:10b6:930:c6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.13; Sat, 26 Apr
 2025 19:21:37 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8699.012; Sat, 26 Apr 2025
 19:21:36 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Topic: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Thread-Index: AQHbsYwmjuQam6Y/SEmtlBggg4gnP7OyupuAgAAGMoCAA5jFgIAABCQA
Date: Sat, 26 Apr 2025 19:21:36 +0000
Message-ID: <F2B6ED72-EC48-495F-A3D1-E6681DA10A7B@nutanix.com>
References: <20250420010518.2842335-1-jon@nutanix.com>
 <a0894275-6b23-4cff-9e36-a635f776c403@redhat.com>
 <20250424080749-mutt-send-email-mst@kernel.org>
 <368F25EF-AC86-4FB6-B119-8DBE8DDE8F09@nutanix.com>
In-Reply-To: <368F25EF-AC86-4FB6-B119-8DBE8DDE8F09@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|CYYPR02MB9785:EE_
x-ms-office365-filtering-correlation-id: 964bc273-dbdb-493c-b2aa-08dd84f79047
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WGR4ajJwMFRIdEw4am5HZ0hYY0NhRkhpZEdiSTBnaldjKytFQ0FidFdKYjNB?=
 =?utf-8?B?NzFYRnovamJHY2hpU1pNbWNkR0NhVHZXSkg2YkVWYWxXRzRVckQ1TmlNUm1B?=
 =?utf-8?B?R0xEZVNReFM3YjBQSHZFM2w5TCtkc1NCdHliUmYxMWtDeUpBZSszQm1QSStR?=
 =?utf-8?B?dTA1VnhwRS9aQ09xNGJOT3ROMTkzNCs4SkUzS1FPanF2bjdKZ3lkaVlBN2I5?=
 =?utf-8?B?Rm4zbXhLaVlEMXFWQ1A5RjNTbUcwdkxvYXRyY3JLUFdIdkw0dlNvWkJBb1FB?=
 =?utf-8?B?OFZ0dmNtVVkySjZYclJJOWEwSG9YZnF3cytEenBXbmwyb0owUkxIYWdPcHZL?=
 =?utf-8?B?Mld2N3dqMEpESVpwaGhLcFlJRkFHUW1uK3hrb3F1WWlZRTdPbjd4QzNYMmtV?=
 =?utf-8?B?NjZIdk5ELzJBcGVabExMY1NxR2JxRmZ2N0sxaU5JcytpWnE4UThmOUZCc05S?=
 =?utf-8?B?ZDdySGNLVjQyU2lUUUkxbzE3MWhtOVpLZ2VwYmhidVZrWnFoeFZmWHBUcThv?=
 =?utf-8?B?bWExbkxDdFBzU1ZFTFNrZE11OXN5K3lUYjJuVDgzTmgySTgxUWhrL2VFVDhQ?=
 =?utf-8?B?dU5NZkxrV2JDekdWREc4bUFrUmwzZjVMbWhVSkIvT1BpenJYVEJYTWRyL3FX?=
 =?utf-8?B?blR1eXc5MEdQeEdEUURKOEJqRE40amtnYWptRG5RWThYWTVuTG53MWZZbFFK?=
 =?utf-8?B?dGF4TzNDdEVVU2Zpd3c5czJ4Ly9HcU5NQld6Nk9oNkpRWVVIeThiNzBlYmxX?=
 =?utf-8?B?cnBlVThMNzArangremtyUVRISjRVRkc5cFQxcGpqUExvRVY2TzhtVGpEVFlC?=
 =?utf-8?B?YjNsSmpwOThOcG9iRk1mVFMzVUNpK0F2bHVjeTZrUXVaZm96dlEzSFVFa25J?=
 =?utf-8?B?RW9qZ3NGQXRUSm1CWmx1V053TGNkbGZiU09nK1BDVTVqQmcxMkxZblN1NXpE?=
 =?utf-8?B?cWo1L2tUTVZaZjVoY0VnbjZPVkFDYnhJZlllZER6RjFrOW52Y2tJN3k2eWtW?=
 =?utf-8?B?eTdFNHFaaWQvVjBwU29MNjVPVitNTGVUZHhJcWZQWm95WVhLWjN4Qk5TKzUy?=
 =?utf-8?B?SFRtbHdqS0J4MWhnbVk5MFRsR3NQbXJ1R1AzTW54Y1NnNmR5Y2JUZEp6V3NK?=
 =?utf-8?B?dnhaaXVNS1pRMFpkaEZaWHhOeHRvT0FFK2NuU2xtd0FPc1FYbjJkZStxSEdV?=
 =?utf-8?B?Mnd5aEVIM1gwTGtMZ0prMDlDN0t0OWE5Q2hQbmQ2V3g5QzJaN0VOQmRUSENv?=
 =?utf-8?B?THdOY1JsczV3ODNnL0VSQUJ5ZDdoanZxR3RZN2pyWGt2UWJobzVHdDZnVUZz?=
 =?utf-8?B?bmFNMHkwb2NGNmJYb0ZSOE96a1NRZWR5QW5PUDRIUTZ1YmFsaTdrK1NwR2pX?=
 =?utf-8?B?WFhSNHB0Q2xvQ1lnYXlFZHJ2UUhMZ3Rtb2NCcU5xNDRialdJRUtlSGlHS3A1?=
 =?utf-8?B?ZFZkS3VTa3RGaXV3bkZ1ajkyeEwya1lscE1tNXQ2V0NGVXI0b3UrY2dWV0t2?=
 =?utf-8?B?eFYwS21pWm54ZXg5QnMvUEswRlVBb2VrSTZFbGF3eFZwb0NCYU90SmlCNnB3?=
 =?utf-8?B?K1RwMW1wbTU4Q2pNK0RLME5yb1I1UzBRd3RZZDNZcjkzSjhBRmhQcGpMRUdT?=
 =?utf-8?B?SjZMTldaNkpoTTFxTndqNGRjZGNKU3djbmkxaHR2KzF4ekpDUi9nNUk0WmlV?=
 =?utf-8?B?VXU3Z0Rpd0E2UmlMMmVlMFVOYjk0djl3aEF5UTBYTFYvT1RUbStPc2ZZcE5Q?=
 =?utf-8?B?Y2F5MENEZXZNRStwVzZ4bEpXTFFnSWZGTmJ3OHlTTUxqeDcxTi92aFZyY01V?=
 =?utf-8?B?cnl4bkJGSDFFSTJJclNDRlN1YXVuS1ZVTmMvWnQ4QzFibTdCN1dhYVI3NnBw?=
 =?utf-8?B?NmZHOHNsWHVCcmp5YnJRamp4VjE0WW56dCt3Qll2TDZwMi8zK3FXT3hUS0lk?=
 =?utf-8?B?c3dIYi9iM0ZBQWErLy9zZllKdzFadE5qVU1NRUxJRUFWMWZ2U1ZiOVNjQmRM?=
 =?utf-8?Q?mpFCOQ7BmnyBzrAeyu4id9+1DYf1pE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Qmw5ek5SY0t4cExhN3B1MEc5MDA3ek1TTVBOeXhjOURzYnA1ZC9wOXVkTzJO?=
 =?utf-8?B?VU5YSGtQYnIwdmc1d2RxR2xPeWNsZ3Zoc3A2NDRMN2xKQ05FNTVQNUJhTFdQ?=
 =?utf-8?B?ZEdpQ0NXa1dUa3oyY1N3eGk3ZHEzUDV1cnk3Q2N0OXJ1RklVMko1SGNUam1P?=
 =?utf-8?B?YVc5SnBKWDFFVUIrejB4MXNQQ1FqODJuaStydGlVbDM2cUl4VjByaW1hTm9M?=
 =?utf-8?B?T1ZpaVZqbndWT0g0a0l6bXFYQ1hoeEpLeFFkR3QyN2g0UkQydGUwQzBiMVlw?=
 =?utf-8?B?K3hEdEFMTXlVNlJWKzllOS9FalltcjMyWHRkek5Dc01uMWNOMEVqcVMxTkZw?=
 =?utf-8?B?eW5BSWNKc0VIL0hTZ3FjQldUNHFJbUM2SWV4aVVVKytOd3RMNCszWkRBcEpP?=
 =?utf-8?B?dG9yc0NJWWgyL1d3dDFpMXl0dWlUdmtLUFdWK3Z4ZEg3U2FhWXNqRlEyTjlJ?=
 =?utf-8?B?VjhIYXluOVNBOFFGZnZUN1FseUZIVW1jeGcxakRnQUdOVGw4RmxuVldxSUNK?=
 =?utf-8?B?L1d2TTlFN0NpS0E1Y2lEL3Z1RnVqRG5kY2JtSlc0RUhML3VVOFUzRU5saHla?=
 =?utf-8?B?L2JaSy9QbkVhQ0k5ZGJKdm5XNDRjd1RrVkpIUTl4cmhUR3JkdzdjaVVZeVJF?=
 =?utf-8?B?MlFZdUswck5sOUE4Z2dULzRpYkxRUDUwSGlZMjFKeW1iY0wzK2JtUy9tQno0?=
 =?utf-8?B?dlVDOHNIcHprc0JuUDdDaGdLM0VNcUtpTXJZVVZrLzJ2R09rSGp2MmVON2RU?=
 =?utf-8?B?M0w0dmEyT0UyTnZJRU1aUFltMEdUMEUwTmFXYlFUZmpka2MwbmZmUnk4ZzM0?=
 =?utf-8?B?Ny9lR1JILzd2QWlXN2p0REZOZVZWSTc4bEhOL21TRFE4UE90eDRTMjZTUE5y?=
 =?utf-8?B?V3JyWGNDQXJidnhlWjRodkVMeXhqeHB1cWlmWGZDY0dGaUp6ZEdSQUFWajhl?=
 =?utf-8?B?REdzaCt6V1hmRWVyUU9IZ3BNUzhEaG05SjQzMnhBMks2dVZGeDFGOHB5RXBH?=
 =?utf-8?B?aGxCd3JXRWlSeXBhRzlqTzJyaUY3emFGOFJ1Q2pmdit5Y2d3VWM4dUpMdG9F?=
 =?utf-8?B?ZEs3MlFxZXd0cFRlSG8xd1d4Uk1SZkNiYmtVNHFmMEowS1BpL2ZvUGdtS25Z?=
 =?utf-8?B?dVAzOG5OdGpaOFI2dnZXY2dONVJSZDVKZTRVeVdFaGRpa0xIRW1jczZYYWxn?=
 =?utf-8?B?TjhCSGJkM1Fqb09FUTlEL2VZTXo4eXUzRlB0ckxZOXdlTElrNCs1ZlhBRytl?=
 =?utf-8?B?RXlyM3lieGlSdWhDYWp4cnd6b3krOGlGU3ArYm5mTm5mTDJBUXVpZVRqQmlH?=
 =?utf-8?B?b05UMEJSb1BVa0dtVzQ0eHE5QldiY3VJRW0zeXVwTTlFM3J3OVpGK09DSytD?=
 =?utf-8?B?THdPVXVmdTVVdVc2ODhlUTZPWWlCSTAzbnRHQVNVL1EydVo3OC9lbG15ZnNS?=
 =?utf-8?B?WkVOZEFFOGhUNFVzWUZCa1FnbUdQUktVZ3VPbWsrbWVEYnJxVlNkSmJlbnhZ?=
 =?utf-8?B?QndFbVY5a0pienplRjBiUVRISVFxMm40b0IzV2xCMjkxWnQ4TGNWbGhEWHVh?=
 =?utf-8?B?SExDdDdUL3M2RGdiSk84YUxaOW84KzFBYytxdXdxQytvU01qWVF2SXI1Q1pQ?=
 =?utf-8?B?YUJrYW42TTdVL3RNbjhCQzQzaEN2dDhtUGhtT1FMdUdJM2xobUpwV1YwRGox?=
 =?utf-8?B?Ukx4OHgxNGx1K0pRRXpXc3RIZThpUXZ2NmtkR0g3Tk0xRkRteHF0cXpBSWpT?=
 =?utf-8?B?Nk4vTDlwUzBJMDQwVTJ0K3ZCZ25kOVkvV1BDTVJIeVJGOVNyM2hGemM4VXJE?=
 =?utf-8?B?Um5ySlc2L2NXQnd4VGYyNnNGc2ZRNmNCbjJYU1RvTEpIUldzbnlyZmxJaWd1?=
 =?utf-8?B?azNqekhPOGMrMGU2UGkySnFtWkZBblJhQTM0c1c5VGlqT2tBTVpXMHcyQmpQ?=
 =?utf-8?B?QmhFZWVZRWRvQ0VvUGFpQlZXSnNWaU0xVERzOWcrMGJhdGZFV3BxYlF6bDlx?=
 =?utf-8?B?K0IvZHN5eEl5SWFTcUQxSE92R3cvM2JrUWE5ZU9ZQ0ZsMVVVNUkrUjM2MG5n?=
 =?utf-8?B?SUUzdDBQRHpwUUtIUVl3NjlqaHJMaEc4UHVwbDZGQmhsbmRhZE51RTBzdGt0?=
 =?utf-8?B?bnpsdEFMM3U4aWQyWTAwRTY5MUFuOFFLYndrUWc4NkZ3SGZ6K2JnelJER1pZ?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC0D2460CEF6254AA5CB7294E37C34D3@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 964bc273-dbdb-493c-b2aa-08dd84f79047
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2025 19:21:36.8675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vFZRfQR7FoTwL6V1lF0deFWefbIjUw/qv9gf8mTpC70VdJSFHiD8XG+S+180NCp6GCH4RcShgjHfR1WaJdgdJR6Y9E2m5gAywbNnJ2A7m4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR02MB9785
X-Authority-Analysis: v=2.4 cv=NcDm13D4 c=1 sm=1 tr=0 ts=680d3244 cx=c_pps a=f1nyBA1UpxJqkn7M4uMBEg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=20KFwNOVAAAA:8 a=1FV7vWVsGJLn-bvxmXkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: TWsEBwKk84W-If3MSgUlNh_DkwW11w7h
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI2MDEzMSBTYWx0ZWRfXzpTIeiJL3kxF IxjWgWRfnQ17CLD2DmLoiRav2ZY3aoSOLU3EiDyNKS6Kn+REpxNHbRNpqDw+FEjTq9uwNC3e4zK KG9lR6i6EPVyhMf0gTQqG8Iftks3l4PFsupKrZr7HmAmA99us+61uEfDt8cLYzKZfi6VaMV9Moh
 vYh7HulXhbahTeTF2gSLIVVlnMwWuZm+vXiVaaC8XnOhzDsPHTX9ZPXS/Eap4mv+lwrEeMcNIgH 3D29AVs+rfHUwy8h+31v/MpPxIWsQa+V4yIbzGWsZbsTTpq3BPN4oQFCRHLbaXSlV5wL1La+arE ElTZHdzySZXdmnj+JrrhseYCfPoxNRKFipvwkMwvyn/luniPLxT46Iex4nO3zGoCwymE4OGvTXw
 h5O97jEvrcqRG5z8hLMgdI5X9lNMy2aFIJQFW0HZc9aL/8SwUazFr79d0PklbbAYEithO0F8
X-Proofpoint-GUID: TWsEBwKk84W-If3MSgUlNh_DkwW11w7h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-26_03,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDI2LCAyMDI1LCBhdCAzOjA24oCvUE0sIEpvbiBLb2hsZXIgPGpvbkBudXRh
bml4LmNvbT4gd3JvdGU6DQo+IA0KPiANCj4gDQo+PiBPbiBBcHIgMjQsIDIwMjUsIGF0IDg6MTHi
gK9BTSwgTWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT4gd3JvdGU6DQo+PiANCj4+
ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tfA0KPj4gQ0FVVElPTjogRXh0ZXJuYWwgRW1haWwNCj4+IA0KPj4gfC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0hDQo+PiANCj4+IE9uIFRodSwgQXByIDI0LCAyMDI1IGF0IDAxOjQ4OjUzUE0gKzAyMDAs
IFBhb2xvIEFiZW5pIHdyb3RlOg0KPj4+IE9uIDQvMjAvMjUgMzowNSBBTSwgSm9uIEtvaGxlciB3
cm90ZToNCj4+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zo
b3N0L25ldC5jDQo+Pj4+IGluZGV4IGI5YjllOWQ0MDk1MS4uOWIwNDAyNWVlYTY2IDEwMDY0NA0K
Pj4+PiAtLS0gYS9kcml2ZXJzL3Zob3N0L25ldC5jDQo+Pj4+ICsrKyBiL2RyaXZlcnMvdmhvc3Qv
bmV0LmMNCj4+Pj4gQEAgLTc2OSwxMyArNzY5LDE3IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9j
b3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5ldCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+Pj4gYnJl
YWs7DQo+Pj4+IC8qIE5vdGhpbmcgbmV3PyAgV2FpdCBmb3IgZXZlbnRmZCB0byB0ZWxsIHVzIHRo
ZXkgcmVmaWxsZWQuICovDQo+Pj4+IGlmIChoZWFkID09IHZxLT5udW0pIHsNCj4+Pj4gKyAvKiBJ
ZiBpbnRlcnJ1cHRlZCB3aGlsZSBkb2luZyBidXN5IHBvbGxpbmcsIHJlcXVldWUNCj4+Pj4gKyAq
IHRoZSBoYW5kbGVyIHRvIGJlIGZhaXIgaGFuZGxlX3J4IGFzIHdlbGwgYXMgb3RoZXINCj4+Pj4g
KyAqIHRhc2tzIHdhaXRpbmcgb24gY3B1DQo+Pj4+ICsgKi8NCj4+Pj4gaWYgKHVubGlrZWx5KGJ1
c3lsb29wX2ludHIpKSB7DQo+Pj4+IHZob3N0X3BvbGxfcXVldWUoJnZxLT5wb2xsKTsNCj4+Pj4g
LSB9IGVsc2UgaWYgKHVubGlrZWx5KHZob3N0X2VuYWJsZV9ub3RpZnkoJm5ldC0+ZGV2LA0KPj4+
PiAtIHZxKSkpIHsNCj4+Pj4gLSB2aG9zdF9kaXNhYmxlX25vdGlmeSgmbmV0LT5kZXYsIHZxKTsN
Cj4+Pj4gLSBjb250aW51ZTsNCj4+Pj4gfQ0KPj4+PiArIC8qIEtpY2tzIGFyZSBkaXNhYmxlZCBh
dCB0aGlzIHBvaW50LCBicmVhayBsb29wIGFuZA0KPj4+PiArICogcHJvY2VzcyBhbnkgcmVtYWlu
aW5nIGJhdGNoZWQgcGFja2V0cy4gUXVldWUgd2lsbA0KPj4+PiArICogYmUgcmUtZW5hYmxlZCBh
ZnRlcndhcmRzLg0KPj4+PiArICovDQo+Pj4+IGJyZWFrOw0KPj4+PiB9DQo+Pj4gDQo+Pj4gSXQn
cyBub3QgY2xlYXIgdG8gbWUgd2h5IHRoZSB6ZXJvY29weSBwYXRoIGRvZXMgbm90IG5lZWQgYSBz
aW1pbGFyIGNoYW5nZS4NCj4+IA0KPj4gSXQgY2FuIGhhdmUgb25lLCBpdCdzIGp1c3QgdGhhdCBK
b24gaGFzIGEgc2VwYXJhdGUgcGF0Y2ggdG8gZHJvcA0KPj4gaXQgY29tcGxldGVseS4gQSBjb21t
aXQgbG9nIGNvbW1lbnQgbWVudGlvbmluZyB0aGlzIHdvdWxkIGJlIGEgZ29vZA0KPj4gaWRlYSwg
eWVzLg0KPiANCj4gWWVhLCB0aGUgdXRpbGl0eSBvZiB0aGUgWkMgc2lkZSBpcyBhIGhlYWQgc2Ny
YXRjaGVyIGZvciBtZSwgSSBjYW7igJl0IGdldCBpdCB0byB3b3JrDQo+IHdlbGwgdG8gc2F2ZSBt
eSBsaWZlLiBJ4oCZdmUgZ290IGEgc2VwYXJhdGUgdGhyZWFkIEkgbmVlZCB0byByZXNwb25kIHRv
IEV1Z2VuaW8NCj4gb24sIHdpbGwgdHJ5IHRvIGNpcmNsZSBiYWNrIG9uIHRoYXQgbmV4dCB3ZWVr
Lg0KPiANCj4gVGhlIHJlYXNvbiB0aGlzIG9uZSB3b3JrcyBzbyB3ZWxsIGlzIHRoYXQgdGhlIGxh
c3QgYmF0Y2ggaW4gdGhlIGNvcHkgcGF0aCBjYW4NCj4gdGFrZSBhIG5vbi10cml2aWFsIGFtb3Vu
dCBvZiB0aW1lLCBzbyBpdCBvcGVucyB1cCB0aGUgZ3Vlc3QgdG8gYSByZWFsIHNhdyB0b290aA0K
PiBwYXR0ZXJuLiBHZXR0aW5nIHJpZCBvZiB0aGF0LCBhbmQgYWxsIHRoYXQgY29tZXMgd2l0aCBp
dCAoZXhpdHMsIHN0YWxscywgZXRjKSwganVzdA0KPiBwYXlzIG9mZi4NCj4gDQo+PiANCj4+Pj4g
QEAgLTgyNSw3ICs4MjksMTQgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3R4X2NvcHkoc3RydWN0IHZo
b3N0X25ldCAqbmV0LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPj4+PiArK252cS0+ZG9uZV9pZHg7
DQo+Pj4+IH0gd2hpbGUgKGxpa2VseSghdmhvc3RfZXhjZWVkc193ZWlnaHQodnEsICsrc2VudF9w
a3RzLCB0b3RhbF9sZW4pKSk7DQo+Pj4+IA0KPj4+PiArIC8qIEtpY2tzIGFyZSBzdGlsbCBkaXNh
YmxlZCwgZGlzcGF0Y2ggYW55IHJlbWFpbmluZyBiYXRjaGVkIG1zZ3MuICovDQo+Pj4+IHZob3N0
X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsNCj4+Pj4gKw0KPj4+PiArIC8qIEFsbCBv
ZiBvdXIgd29yayBoYXMgYmVlbiBjb21wbGV0ZWQ7IGhvd2V2ZXIsIGJlZm9yZSBsZWF2aW5nIHRo
ZQ0KPj4+PiArICogVFggaGFuZGxlciwgZG8gb25lIGxhc3QgY2hlY2sgZm9yIHdvcmssIGFuZCBy
ZXF1ZXVlIGhhbmRsZXIgaWYNCj4+Pj4gKyAqIG5lY2Vzc2FyeS4gSWYgdGhlcmUgaXMgbm8gd29y
aywgcXVldWUgd2lsbCBiZSByZWVuYWJsZWQuDQo+Pj4+ICsgKi8NCj4+Pj4gKyB2aG9zdF9uZXRf
YnVzeV9wb2xsX3RyeV9xdWV1ZShuZXQsIHZxKTsNCj4+PiANCj4+PiBUaGlzIHdpbGwgY2FsbCB2
aG9zdF9wb2xsX3F1ZXVlKCkgcmVnYXJkbGVzcyBvZiB0aGUgJ2J1c3lsb29wX2ludHInIGZsYWcN
Cj4+PiB2YWx1ZSwgd2hpbGUgQUZBSUNTIHByaW9yIHRvIHRoaXMgcGF0Y2ggdmhvc3RfcG9sbF9x
dWV1ZSgpIGlzIG9ubHkNCj4+PiBwZXJmb3JtZWQgd2l0aCBidXN5bG9vcF9pbnRyID09IHRydWUu
IFdoeSBkb24ndCB3ZSBuZWVkIHRvIHRha2UgY2FyZSBvZg0KPj4+IHN1Y2ggZmxhZyBoZXJlPw0K
Pj4gDQo+PiBIbW0gSSBhZ3JlZSB0aGlzIGlzIHdvcnRoIHRyeWluZywgYSBmcmVlIGlmIHBvc3Np
Ymx5IHNtYWxsIHBlcmZvcm1hbmNlDQo+PiBnYWluLCB3aHkgbm90LiBKb24gd2FudCB0byB0cnk/
DQo+IA0KPiBJIG1lbnRpb25lZCBpbiB0aGUgY29tbWl0IG1zZyB0aGF0IHRoZSByZWFzb24gd2Xi
gJlyZSBkb2luZyB0aGlzIGlzIHRvIGJlDQo+IGZhaXIgdG8gaGFuZGxlX3J4LiBJZiBteSByZWFk
IG9mIHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlIGlzIGNvcnJlY3QsDQo+IHdlIHdvdWxk
IG9ubHkgY2FsbCB2aG9zdF9wb2xsX3F1ZXVlIGlmZjoNCj4gMS4gVGhlIFRYIHJpbmcgaXMgbm90
IGVtcHR5LCBpbiB3aGljaCBjYXNlIHdlIHdhbnQgdG8gcnVuIGhhbmRsZV90eCBhZ2Fpbg0KPiAy
LiBXaGVuIHdlIGdvIHRvIHJlZW5hYmxlIGtpY2tzLCBpdCByZXR1cm5zIG5vbi16ZXJvLCB3aGlj
aCBtZWFucyB3ZQ0KPiBzaG91bGQgcnVuIGhhbmRsZV90eCBhZ2FpbiBhbnlob3cNCj4gDQo+IElu
IHRoZSByaW5nIGlzIHRydWx5IGVtcHR5LCBhbmQgd2UgY2FuIHJlLWVuYWJsZSBraWNrcyB3aXRo
IG5vIGRyYW1hLCB3ZQ0KPiB3b3VsZCBub3QgcnVuIHZob3N0X3BvbGxfcXVldWUuDQo+IA0KPiBU
aGF0IHNhaWQsIEkgdGhpbmsgd2hhdCB5b3XigJlyZSBzYXlpbmcgaGVyZSBpcywgd2Ugc2hvdWxk
IGNoZWNrIHRoZSBidXN5DQo+IGZsYWcgYW5kICpub3QqIHRyeSB2aG9zdF9uZXRfYnVzeV9wb2xs
X3RyeV9xdWV1ZSwgcmlnaHQ/IElmIHNvLCBncmVhdCwgSSBkaWQNCj4gdGhhdCBpbiBhbiBpbnRl
cm5hbCB2ZXJzaW9uIG9mIHRoaXMgcGF0Y2g7IGhvd2V2ZXIsIGl0IGFkZHMgYW5vdGhlciBjb25k
aXRpb25hbA0KPiB3aGljaCBmb3IgdGhlIHZhc3QgbWFqb3JpdHkgb2YgdXNlcnMgaXMgbm90IGdv
aW5nIHRvIGFkZCBhbnkgdmFsdWUgKEkgdGhpbmspDQo+IA0KPiBIYXBweSB0byBkaWcgZGVlcGVy
LCBlaXRoZXIgb24gdGhpcyBjaGFuZ2Ugc2VyaWVzLCBvciBhIGZvbGxvdyB1cD8NCg0KU29ycnks
IEkgZG8gbm90IGtub3cgd2h5IHRoaXMgZW1haWwgc2VudCBpdHNlbGYgYWdhaW4gd2hlbiBJIG9w
ZW5lZCBteQ0KbGFwdG9wLCBteSBtaXN0YWtlIHNvbWVob3cuDQoNCj4gDQo+PiANCj4+IA0KPj4+
IEBNaWNoYWVsOiBJIGFzc3VtZSB5b3UgcHJlZmVyIHRoYXQgdGhpcyBwYXRjaCB3aWxsIGdvIHRo
cm91Z2ggdGhlDQo+Pj4gbmV0LW5leHQgdHJlZSwgcmlnaHQ/DQo+Pj4gDQo+Pj4gVGhhbmtzLA0K
Pj4+IA0KPj4+IFBhb2xvDQo+PiANCj4+IEkgZG9uJ3QgbWluZCBhbmQgdGhpcyBzZWVtcyB0byBi
ZSB3aGF0IEpvbiB3YW50cy4NCj4+IEkgY291bGQgcXVldWUgaXQgdG9vLCBidXQgZXh0cmEgcmV2
aWV3ICBpdCBnZXRzIGluIHRoZSBuZXQgdHJlZSBpcyBnb29kLg0KPiANCj4gTXkgYXBvbG9naWVz
LCBJIHRob3VnaHQgYWxsIG5vbi1idWcgZml4ZXMgaGFkIHRvIGdvIHRocnUgbmV0LW5leHQsDQo+
IHdoaWNoIGlzIHdoeSBJIHNlbnQgdGhlIHYyIHRvIG5ldC1uZXh0OyBob3dldmVyIGlmIHlvdSB3
YW50IHRvIHF1ZXVlDQo+IHJpZ2h0IGF3YXksIEnigJltIGdvb2Qgd2l0aCBlaXRoZXIuIEl0cyBh
IGZhaXJseSB3ZWxsIGNvbnRhaW5lZCBwYXRjaCB3aXRoDQo+IGEgaHVnZSB1cHNpZGUgOikgDQo+
IA0KPj4gDQo+PiAtLSANCj4+IE1TVA0KPj4gDQo+IA0KDQo=

