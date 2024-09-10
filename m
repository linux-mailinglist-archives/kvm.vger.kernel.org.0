Return-Path: <kvm+bounces-26337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AC1E974293
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97D421C25FF6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0A31A7076;
	Tue, 10 Sep 2024 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dbos0dSg";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NKLqoUT6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9105A17ADE9;
	Tue, 10 Sep 2024 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725994034; cv=fail; b=l0J8yNxThpyUy/wGNlwxQTLdr3hnVbghsFf9Y/FE59f894MhR7vPz/B7rxY/uW3CJTVYbZUjOns9SObKS/RFlw5+9Na47tPajzt5k2SxGwpBLUA9KEO3H+We+9LFgb/UiyPwICd0iP0VV4oFWIhGbWOnMzmC3LSGR7GZIP4masc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725994034; c=relaxed/simple;
	bh=NGEnWxIRsEQTSZD5uXLUPHBRExmEyzr1oSiP//tz9JY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SOGl1ruUZygIcywE/8M9vrf5QoNxwQMq9FNtlAy+LZumVJDQd2YG07mD9sBh6NGvzI2W8YsLInBbKpafiXiIYksaEQrj1mVyy09+Tzj9XPOMgOU2sNwVU6s+d16P8H9H0wx+2GWn61xfgwdF1FQ5fgAAz01aQe6gpTXeHTvW264=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dbos0dSg; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NKLqoUT6; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48AAC0Q8020595;
	Tue, 10 Sep 2024 11:47:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=NGEnWxIRsEQTSZD5uXLUPHBRExmEyzr1oSiP//tz9
	JY=; b=dbos0dSgZdGoSSE8Ds8cPvF2ybS30Ed1E7G3yzuM05xA9h9DiiiCTh5QJ
	Bp7AmM+aVRIirUxvSOxcrAQR0utW/dLtUNoARIR6/oc7dOYCmm2wgiVrPff/y9IF
	IMBdaq7XPRzkvTJOfvy5bn+T0PdVS2+IWxmc/C8MlrwLU8kLvVmePwftgQ9sp3VS
	hUoTEow4rCrPvT50SEjmxLlvI3ti7+Nf4CUHLjJDCTkHTS1CNvbHjDwvh46Y9u0S
	vwLxGxlUimEoTzKNfj2XUN4yDl3IpZ74RtXsRNuCBq1tskhhgyyIh7kYMbH58d/q
	zUNx56CtM99k3qWWc6LevWliyjQmA==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41gjr7q4ax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Sep 2024 11:47:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vcBNZolyxZPITvtt3My7JpGQZsGpsI0JheuFcpFFfBXLQbqqPP+QwuSKV8VlBlCiR2reX3iZvYdznsblSAEt7d0nX/MZmsQ7Ur9IIp45hQsOgORbkGEVNIvChWBFMmIOyrG2rgPjpzVJ8KfJnsMcd9prYAPg438KyWKlJ1hKMM8fl2Fn4wa7L054ydwKVjuH+agoL4tUKOfn2+xTrN5UmX0sDS/R2E5bd0UyhDVvlo1Xjhak/vEOsc1ONTAK4e4/Xwq3U809wqVYhpIizuoJj/6fqWwrqge484ZtO4t/fnbYgH79dU1eLEovJsxhpyo0mDDPyLuCm0pMm/EaPpLdTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGEnWxIRsEQTSZD5uXLUPHBRExmEyzr1oSiP//tz9JY=;
 b=a9B9v9G2YkoZErZqLY67RAMATtnx2YAtET3zcZbjSqneJUHTE0teYjlA9dciZvf4SpdEfnthkeNqfDYdOBw/A/H6Npz7+olM7Etgm9grZqY86KDkawzxmNJlzyPwUHZQb4+HdSJguaTzVKfXl57BRWkpC1VLjIXGPSqCxPTKabzrtQYQBbPgXFO6edi3JtNggHURzO5Q7NCWEiKN7XmhMv0RQhnZ/IbqUWLocZ7owCndk78M4RRgbsFXesE5W0FCeyniMiPSJvtF2NTVCvMYrKNYjnxwg88HIiwQXkMzmgZoOACvVM2jwPOuUd3pxxy20l36C2esCRPbsHt+K7ooCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGEnWxIRsEQTSZD5uXLUPHBRExmEyzr1oSiP//tz9JY=;
 b=NKLqoUT6cKJvM660j4rr274C6nlXKz/1i36F2izXv2ZKRxJF2IDAIkq723nfw2uQ0ci1L7f8HlZGFHstUIs3Cgurv2YQe1LA/32mDjqVj9V2gJgz/gxy+NMWpv/vkywjbPd+sQ+VblndNvWD0YJi/MdrJc4MSz9sgD/9ha90eHRuOYKGm1cQyklQdI73LwMExxOu/TzWutw9UUb6SVEZCKUGrGz0f16PKRs1uUvep1VJEb4mV3t0dbgsZhNBnvlmF11ghlNYFNIDyHxOP0GkCieC9C9dGWZQhnwRD8KKHEiHkTRU8/yieKURUvn3j5Gv1/KM8+1sr1YG/fCZzzJ1yQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB8418.namprd02.prod.outlook.com
 (2603:10b6:a03:3f2::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Tue, 10 Sep
 2024 18:47:00 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Tue, 10 Sep 2024
 18:47:00 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Fenghua Yu
	<fenghua.yu@intel.com>,
        "kyung.min.park@intel.com"
	<kyung.min.park@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: KVM: x86: __wait_lapic_expire silently using TPAUSE C0.2
Thread-Topic: KVM: x86: __wait_lapic_expire silently using TPAUSE C0.2
Thread-Index: AQHbAIY2gBwyHCc720+eCv8PSNcAB7JP1zQAgAGLVYA=
Date: Tue, 10 Sep 2024 18:47:00 +0000
Message-ID: <2E1344D0-E955-4E15-9766-73E3DAA73634@nutanix.com>
References: <DA40912C-CACC-4273-95B8-60AC67DFE317@nutanix.com>
 <Zt9IeD_15ZsFElIa@google.com>
In-Reply-To: <Zt9IeD_15ZsFElIa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB8418:EE_
x-ms-office365-filtering-correlation-id: 8499edb6-c463-48b8-7ee3-08dcd1c8f45a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?M2JnVGRLamUxbGRkSm5WMmloWENHamlvTmdZaXFsZFQ1WHFKVGJDV2p2MzVM?=
 =?utf-8?B?LzhzVlhucXdEdWNSSEY1bFl2SjJSeDQ3NHJ1M3FxcWlBKythMm9WK1pTZCtD?=
 =?utf-8?B?WTFyYnhlaWE2U3lLd2JXK0xQcThrV05vZytjWVFtYUJDcFlFUVZiZS9XT1BV?=
 =?utf-8?B?UmxYMEFRZHA4U05qMFh5YkVjdlBpR0lqaUJXdFU3THNWUysrZkRHdGRpaFFm?=
 =?utf-8?B?NWhLY3BEZ2RFMm9ybWVmSURrWkp2dHp2eUxqU2l4NWJ4enVUNTdTMHdGN0VS?=
 =?utf-8?B?WkMvdHV2VE5Nc01FVzgwKzhWQ3hTTENBS1FueDVJVm95VTkvVGNoZ1pzOGRq?=
 =?utf-8?B?cVAvYWh1VExBSmc2UXEvYjZsbUJkMUxlWmpJQjI0eGhXRDBUMjRsaTlzQTdQ?=
 =?utf-8?B?OERIRjgrRysySlo4Q05QOWFNK0praXhBV2ZoVWRjSDdFejFYY08yT1YwTUlo?=
 =?utf-8?B?OTloUHZCUzVtVTNjRHhFY2tqeWtLZGRCWkJBUzVNVnc3Q3JtZllBc0hIVUtH?=
 =?utf-8?B?cmxRUEd2WU1ENmF6M0JwN0FvanoxcURLMVJzUm9HRXVGcHVJRFhOekFXTmp4?=
 =?utf-8?B?Y1RWUGxadlk0UUhuZ2RCVC9TaWVNTGd1REJYUEUvQ2Y1VlVsSmFxdDZhSzZs?=
 =?utf-8?B?eFJvVTJOMzJpL3VZVkc4NDB5ZkNjNkJJWHlrTitkZ0lmSDc4ZmxzVUo0ZGY1?=
 =?utf-8?B?RXgrbjhBOEtlb2lhbG5nUStrVHNxb0twVTh4SzRRbXRZcmlyc1NUZ2R0VjBH?=
 =?utf-8?B?Z1ZENmVBQUQ5ZzlHMml0STBVK0RDYWJ1NERaSmZ1OE1tQUJBVXpSUVY1ZDh6?=
 =?utf-8?B?ZlgwNDhmVnJIb2FSUllSNkdWV3lZUDdsZ1d0MGZlcC9uZ1lZV250N2VmdC93?=
 =?utf-8?B?RWZNeEZPb0lscG1uNEZSNEs5VG1ubm5vWlFiVmx6ZE0zaklUb2RRdVpNWWJB?=
 =?utf-8?B?MVVsMEZnVVd0YXNpV0VUNllQWFVUeG9sYjF0blMxSDhLSVo5Yk8vRUh3R0s0?=
 =?utf-8?B?YXAvVlpSY3pTSFc3ZzIzdXMzZHd3M0IrY0dsNnNrWEZpZXA3WXRZODlmZ3Vx?=
 =?utf-8?B?eGxQQ0tSTHUvVW1odTFKLzZRR2dyQ1pwS1BISk5YMHBxZnptWWdYeVNlK3Mx?=
 =?utf-8?B?cllTbUFBWnZhQUsxeUE1Wmk3R0ZHZklBdnkzYkgxWG9xSys1U0Ywa2phSStJ?=
 =?utf-8?B?UGNITW9KZ2tjSURhMzFuZDRBMVBLV1EvelRUUG83Tm8zb2RqNzB3amhEbTFi?=
 =?utf-8?B?TkpZbVkyVHA5M3lYQVMyZnRRRHk5WHlrNHo4ME43cWxDY2dWM3dxd0tCSVhx?=
 =?utf-8?B?MW9jZm9Fb2xKUElHTFNYYzdPa3pXc2Y4VjVpNng4NGpQSmRkdEZBcWpIMWUw?=
 =?utf-8?B?OXlhbG1HeUp2RmR0TFNtUkpPaWx1a3d5NXFYeGVYajFxS0t0cjZvNTdkYUJx?=
 =?utf-8?B?MXluOG5VTkIxdkREaXNNUTQ5ZW1mYXhqTy9XdS9NSFloeDIvVEpYdUNKK2FB?=
 =?utf-8?B?OEFyZUVBV3pyU3VWUnF3VjBFNldPNWFMemdrK0ptdmVBc3Avd2dZZnVqWktK?=
 =?utf-8?B?UFQ2eWZnVWZnSlFEVWJaSURZdUU5MTZQb3JBSmd4QUFJZ0duM29wMWhZOS9G?=
 =?utf-8?B?NnNtSE5pak9nbDNQM05tSDFTbTIwZVM4MUdoNjFPSXpubVV5OGd4T3F0OFRk?=
 =?utf-8?B?ZUJoNzVWdWhkU3d6Kzc3QzNvaTIwaVRlRm5RR1BMQmdYVmh3ald4YU5FMm1i?=
 =?utf-8?B?WThpTXA1eVFscjFvMC9lREllUDlPdEdJTG40N0VEeG94dDdPSDJaZFF4ZEl0?=
 =?utf-8?B?UXdVUHZQblRPN1JvYTJMaVRBQ3RJZHN4MVNUZkNSWlJlYStsRVM3RUk2UkVV?=
 =?utf-8?B?bThvL0NOKzVqUFp2NlNLL0xpdkVadC9JUkxQcUI4M0VNaEE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YjJSODlhanlHcDdXbkZoRVB1SVgzMG5FNmZpZEZDTTdKYXhXcVRoeVo0c1l0?=
 =?utf-8?B?a3FHTE1Xb0tlKzlIZHhZOHhiWFNRZEZOS0hXd25tU3VCTzRJTWgzWFZ4S3Ni?=
 =?utf-8?B?Mlp1WDhnaURzUjQ1aEpCaTgwaDlPOVZhOXZYU2E5NEVLQVhIRlpiY1QyWFE2?=
 =?utf-8?B?K3JQS2Q2L0NudDAwMHJBaHBYNUN4TkVzVjdqU09nWkZOZUlqalkwRE5hM2gx?=
 =?utf-8?B?Qi9vYVRHQjR0R2VYemJpVGFydkJiYWFZOVNpZFd6TVBnWHkxLzhObjJGQW8r?=
 =?utf-8?B?SVdxeitJN1FCdUs2RkpYeWN4T2dvV2hMMlp1dzBqSVV6WEx2SlpXQzlKRmVE?=
 =?utf-8?B?QlcxSEFOUjBJWjFqWkZnR1E1OWlBNnJCL0FKU0Q2TjIvOVdjOVUzZGpmVWgr?=
 =?utf-8?B?ak5kRnNuWHFsYTJYRGFJOC9CemxZSFg0ZlJRd2gwWGgvenJkcFBOVHRJbU9C?=
 =?utf-8?B?RHBzeVJEcUhzRnNBS3k1TnhQQ1pvRmtwOFVZWkVhT1Q0RXdHblFEK05MNVIw?=
 =?utf-8?B?TW9OUS9wVVVOTDBsWDNET00wUC9IdEpGWkNxNmFLdU95czhZQTZ6ak9PTUZD?=
 =?utf-8?B?b0JvMWp4elVKSXZkOGRoNExXb2tsMmNKN0sxYmtOa1VJb3JxRStrZWsvQjN6?=
 =?utf-8?B?NHJZZlFpbUg4MEk2VmV3TlFOUk4ydjdzRzRPeWM1ellUQzhWRFJ1MldONnBH?=
 =?utf-8?B?NTRSeTQ1RXo3ekZtZ0tzNlk4SjdSdWE0Q3h2dnBhNU85QUd1b29tYVZaOExq?=
 =?utf-8?B?bGlnMlFCVWxZWWRlc0hYblN3dXZvUS8vU3ZyNDdkUTZyUDkyZjlHUHFMb3dW?=
 =?utf-8?B?SkJteDJ1MEk2bjNTblkrcW8xQ0xWZXdkckdQZ1h0a05KR3pQR2RNc3kxSVNh?=
 =?utf-8?B?SERLZ2MrbTVtS1ZaaFJ1Mm9qSkw5N24zN0ozdkVYUTlaQ1FpdE8xVVR2U0xO?=
 =?utf-8?B?TTlJQXdlZjNUMmkva3VkcDRMeFVOaG1zZlhPZnpwK0hEUnRBdGRGTzJnYytX?=
 =?utf-8?B?Y1Qxb21KZHlPSndJVDdPMGFHNzlXMm45dTBIVDU0UVZsOW5JMlZFcUpCaHV2?=
 =?utf-8?B?ZGs4bFVRbnZETVRNVUtuTmVkdGZjQXluVlZwVDNRQ01mWWh6VTFMN2lkTnl3?=
 =?utf-8?B?RlFscEp3MXhXeldYOEJIYlZ0Z0J3Z21KeXhjdExkNDlzVWQ3bFdXYkQ1Q3NS?=
 =?utf-8?B?WDdVcGJaOUNHRXlZcXp1RlRldFR6YVVKNC9WS2xZQVkyYW43U09sVGRLN2dx?=
 =?utf-8?B?OUN5eWlhOHJCazVkWk5Fakx2c05vTWxQV1JOZGxSMGdtRkRrUGt3MllFeXEy?=
 =?utf-8?B?Yk4xU3oxRmp1UXVFMlg2RDlkaVd1WlNiZFN4V1FhdXlLQ0llTlJvN1hDZWJs?=
 =?utf-8?B?azVoODl6RzdjSDFicmVJN1pqWHJIZUg3SzVVb3JXYnppRlV4MTkyMW5Ybi9T?=
 =?utf-8?B?N05naGFMbC9nSU80S0V6eVhuWW9KMnhoRDVRVlZnUGxHc0VTNHJuU1Z5cXhL?=
 =?utf-8?B?LzE1KzdrMmJ4cENKeXdXSmlhT0w2WHcxK0dWaGVuU3dQcTlzbjFwQzV4M1Zh?=
 =?utf-8?B?UkNTTEd1QnBNVUJWdE1ZcW5sL0pJTm1zeUpHdVM3MHlUb3p5VHROZzRma1FR?=
 =?utf-8?B?d2c1amZ1WEdQUVdxcFRLN1Z3OGJyWEFscThWTGJjSjA2TWR3OUlLSHlQdHJM?=
 =?utf-8?B?dnlLalBuS2pYVVF6Q0RTVDdQSVNjakdyZUEydnRTODNFbVBMQ2QvdUtlM3V1?=
 =?utf-8?B?UEZvNUFNTWYxdWNmeTluWGxLNUt6VG9mWWhGUklEZEtHOVhKNHREeTBVOEt4?=
 =?utf-8?B?K2FxZDBKYkUvdzdlTGlJSVE2U09CVGxqdkQ2Wm1SNkU5WVRXY09rTkNnemd3?=
 =?utf-8?B?Z2hrcEJ5RXBnYmtYcmVJaGRzemJZTnRTYktFNmd2cVlwU3hhUTZnU3plR0Q1?=
 =?utf-8?B?MzltRnJSaU9CZTJXZWRQYTZ1WUdvVCs3MjJScFF4aWRrcW4veXhkd054ZGM0?=
 =?utf-8?B?biszZTVsa05MOHNteks5emFWK3krYXlYSkYyaTVnSGJkbkxWbnUvdFIvdjNl?=
 =?utf-8?B?ZUx6dGxjS3NBTWlCeEJ5cDkvL25kOExOcU1RRzNTMEFFTGxnbm1XUGIyTE5B?=
 =?utf-8?B?WWdyQmdpWGhFZUFheUlmMjlxc2xUdlN5NlpvektueG1oWnIzNGFLYXkzQU03?=
 =?utf-8?B?b1hTTlZkemxiUUpBTkFuYVVRbUVvNzloazQ5dExrbWVkemlLekNrZnVvd29N?=
 =?utf-8?B?SEU3OUpSa0Y2STE0ajJQcmxEMGZRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAE9A7EC508A974B9CE3275EE1629F22@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8499edb6-c463-48b8-7ee3-08dcd1c8f45a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 18:47:00.2503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j6NrIG9EJy1vqz7KaFhQkjXGziBymq6Z/dznZvF2vbAYuCOnRWIi6Ir4iWs9xxq1Ykf9o4PYqYPZ6N6PdHDAuCaXBNIlOqmUKk8SVM5mZ74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8418
X-Authority-Analysis: v=2.4 cv=J9z47xnS c=1 sm=1 tr=0 ts=66e09426 cx=c_pps a=PdgAl9AEy1hEU2ikvxmBtw==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8
 a=C3K400O9zDaOjxKwSQwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: uXBA2yLDTggc8cUMiSRxJRE-o-gWJxzb
X-Proofpoint-GUID: uXBA2yLDTggc8cUMiSRxJRE-o-gWJxzb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_06,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDksIDIwMjQsIGF0IDM6MTHigK9QTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9O
OiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBGcmksIFNlcCAw
NiwgMjAyNCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IGRlbGF5X2hhbHRfZm4gdXNlcyBfX3RwYXVz
ZSgpIHdpdGggVFBBVVNFX0MwMl9TVEFURSwgd2hpY2ggaXMgdGhlIHBvd2VyDQo+PiBvcHRpbWl6
ZWQgdmVyc2lvbiBvZiB0cGF1c2UsIHdoaWNoIGFjY29yZGluZyB0byBkb2N1bWVudGF0aW9uIFsz
XSBpcw0KPj4gYSBzbG93ZXIgd2FrZXVwIGxhdGVuY3kgYW5kIGhpZ2hlciBwb3dlciBzYXZpbmdz
LCB3aXRoIGFuIGFkZGVkIGJlbmVmaXQNCj4+IG9mIGJlaW5nIG1vcmUgU01UIHlpZWxkIGZyaWVu
ZGx5Lg0KPj4gDQo+PiBGb3IgZGF0YWNlbnRlciwgbGF0ZW5jeSBzZW5zaXRpdmUgd29ya2xvYWRz
LCB0aGlzIGlzIHByb2JsZW1hdGljIGFzDQo+PiB0aGUgY2FsbCB0byBrdm1fd2FpdF9sYXBpY19l
eHBpcmUgaGFwcGVucyBkaXJlY3RseSBwcmlvciB0byByZWVudHJ5DQo+PiB0aHJvdWdoIHZteF92
Y3B1X2VudGVyX2V4aXQsIHdoaWNoIGlzIHRoZSBleGFjdCB3cm9uZyBwbGFjZSBmb3Igc2xvdw0K
Pj4gd2FrZXVwIGxhdGVuY3kuDQo+IA0KPiAuLi4NCj4gDQo+PiBTbywgd2l0aCBhbGwgb2YgdGhh
dCBzYWlkLCB0aGVyZSBhcmUgYSBmZXcgdGhpbmdzIHRoYXQgY291bGQgYmUgZG9uZSwNCj4+IGFu
ZCBJJ20gZGVmaW5pdGVseSBvcGVuIHRvIGlkZWFzOg0KPj4gMS4gVXBkYXRlIGRlbGF5X2hhbHRf
dHBhdXNlIHRvIHVzZSBUUEFVU0VfQzAxX1NUQVRFIHVuaWxhdGVyYWxseSwgd2hpY2gNCj4+IGFu
ZWNkb3RhbGx5IHNlZW1zIGlubGluZSB3aXRoIHRoZSBzcGlyaXQgb2YgaG93IEFNRCBpbXBsZW1l
bnRlZA0KPj4gTVdBSVRYLCB3aGljaCB1c2VzIHRoZSBzYW1lIGRlbGF5X2hhbHQgbG9vcCwgYW5k
IGNhbGxzIG13YWl0eCB3aXRoDQo+PiBNV0FJVFhfRElTQUJMRV9DU1RBVEVTLiANCj4+IDIuIFBy
b3ZpZGUgc3lzdGVtIGxldmVsIGNvbmZpZ3VyYWJpbGl0eSB0byBkZWxheS5jIHRvIG9wdGlvbmFs
bHkgdXNlDQo+PiBDMDEgYXMgYSBjb25maWcga25vYiwgbWF5YmUgYSBjb21waWxlIGxldmUgc2V0
dGluZz8gVGhhdCB3YXkgZGlzdHJvcw0KPj4gYWltaW5nIGF0IGxvdyBlbmVyZ3kgZGVwbG95bWVu
dHMgY291bGQgdXNlIHRoYXQsIGJ1dCBvdGhlcndpc2UNCj4+IGRlZmF1bHQgaXMgbG93IGxhdGVu
Y3kgaW5zdGVhZD8NCj4+IDMuIFByb3ZpZGUgc29tZSBkaWZmZXJlbnQgZGVsYXkgQVBJIHRoYXQg
S1ZNIGNvdWxkIGNhbGwsIGluZGljYXRpbmcgaXQNCj4+IHdhbnRzIGxvdyB3YWtldXAgbGF0ZW5j
eSBkZWxheXMsIGlmIGhhcmR3YXJlIHN1cHBvcnRzIGl0Pw0KPj4gNC4gUHVsbCB0aGlzIGNvZGUg
aW50byBrdm0gY29kZSBkaXJlY3RseSAoYm9vb29vbz8pIGFuZCBtYW5hZ2UgaXQNCj4+IGRpcmVj
dGx5IGluc3RlYWQgb2YgdXNpbmcgZGVsYXkuYyAoYm9vb29vbz8pDQo+PiA1LiBTb21ldGhpbmcg
ZWxzZT8NCj4gDQo+IFRoZSBvcHRpb24gdGhhdCB3b3VsZCBsaWtlbHkgZ2l2ZSB0aGUgYmVzdCBv
ZiBib3RoIHdvcmxkcyB3b3VsZCBiZSB0byBwcmlvcml0aXplDQo+IGxvd2VyIHdha2V1cCBsYXRl
bmN5IGZvciAic21hbGwiIGRlbGF5cy4gIFRoYXQgY291bGQgYmUgZG9uZSBpbiBfX2RlbGF5KCkg
YW5kL29yDQo+IGluIEtWTS4gIEUuZy4gZGVsYXlfaGFsdF90cGF1c2UoKSBxdWl0ZSBjbGVhcmx5
IGFzc3VtZXMgYSByZWxhdGl2ZWx5IGxvbmcgZGVsYXksDQo+IHdoaWNoIGlzIGEgZmxhd2VkIGFz
c3VtcHRpb24gaW4gdGhpcyBjYXNlLg0KPiANCj4gLyoNCj4gKiBIYXJkIGNvZGUgdGhlIGRlZXBl
ciAoQzAuMikgc2xlZXAgc3RhdGUgYmVjYXVzZSBleGl0IGxhdGVuY3kgaXMNCj4gKiBzbWFsbCBj
b21wYXJlZCB0byB0aGUgIm1pY3Jvc2Vjb25kcyIgdGhhdCB1c2xlZXAoKSB3aWxsIGRlbGF5Lg0K
PiAqLw0KPiBfX3RwYXVzZShUUEFVU0VfQzAyX1NUQVRFLCBlZHgsIGVheCk7DQo+IA0KPiBUaGUg
cmVhc29uIEkgc2F5ICJhbmQvb3IgS1ZNIiBpcyB0aGF0IGV2ZW4gd2l0aG91dCBUUEFVU0UgaW4g
dGhlIHBpY3R1cmUsIGl0IG1pZ2h0DQo+IG1ha2Ugc2Vuc2UgZm9yIEtWTSB0byBhdm9pZCBfX2Rl
bGF5KCkgZm9yIGFueXRoaW5nIGJ1dCBsb25nIGRlbGF5cy4gIEJvdGggYmVjYXVzZQ0KPiB0aGUg
b3ZlcmhlYWQgb2YgZS5nLiBkZWxheV90c2MoKSBjb3VsZCBiZSBoaWdoZXIgdGhhbiB0aGUgZGVs
YXkgaXRzZWxmLCBidXQgYWxzbw0KPiBiZWNhdXNlIHRoZSBpbnRlbnQgb2YgS1ZNJ3MgZGVsYXkg
aXMgc29tZXdoYXQgdW5pcXVlLg0KPiANCj4gQnkgZGVmaW5pdGlvbiwgS1ZNIF9rbm93c18gdGhl
cmUgaXMgYW4gSVJRIHRoYXQgaXMgYmVpbmcgZGVsaXZlciB0byB0aGUgdkNQVSwgaS5lLg0KPiBl
bnRlcmluZyB0aGUgZ3Vlc3QgYW5kIHJ1bm5pbmcgdGhlIHZDUFUgYXNhcCBpcyBhIHByaW9yaXR5
LiAgVGhlIF9vbmx5XyByZWFzb24gS1ZNDQo+IGlzIHdhaXRpbmcgaXMgdG8gbm90IHZpb2xhdGUg
dGhlIGFyY2hpdGVjdHVyZS4gIFJlZHVjaW5nIHBvd2VyIGNvbnN1bXB0aW9uIGFuZA0KPiBldmVu
IGxldHRpbmcgYW4gU01UIHNpYmxpbmcgcnVuIGFyZSBhcmd1YWJseSBub24tZ29hbHMsIGkuZS4g
aXQgbWlnaHQgYmUgYmVzdCBmb3INCj4gS1ZNIHRvIGF2b2lkIGV2ZW4gcmVndWxhciBvbCcgUEFV
U0UgaW4gdGhpcyBzcGVjaWZpYyBzY2VuYXJpbywgdW5sZXNzIHRoZSB3YWl0DQo+IHRpbWUgaXMg
c28gaGlnaCB0aGF0IGRlbGF5aW5nIFZNLUVudGVyIG1vcmUgdGhhbiB0aGUgYWJzb2x1dGUgYmFy
ZSBtaW5pbXVtDQo+IGJlY29tZXMgYSB3b3J0aHdoaWxlIHRyYWRlb2ZmLg0KDQpIZXkgU2VhbiAt
IHRoYW5rcyBmb3IgdGhlIHNhZ2UgYWR2aWNlIGFzIGFsd2F5cy4NCg0KSG93IGFib3V0IHNvbWV0
aGluZyBsaWtlIHRoaXMgZm9yIHRoZSByZWd1bGFyIG9s4oCZIFBBVVNFIHJvdXRlPw0KDQpOb3Rl
OiB0aGUgbmRlbGF5IHNpZGUgd291bGQgbGlrZWx5IGJlIGEgYml0IG1vcmUgYW5ub3lpbmcgdG8g
aGFuZGxlIHRvIGludGVybmFsaXplDQp0byBLVk0sIGJ1dCBwZXJoYXBzIHdlIGNvdWxkIGp1c3Qg
aGF2ZSBkZWxheSBsaWJyYXJ5IHJldHVybiB0aGUgYW1vdW50IG9mIGN5Y2xlcywNCmFuZCB0aGVu
IGRvIHRoZSBsb29wIEnigJl2ZSBnb3QgYXMgYSBzZXBhcmF0ZSwgS1ZNIG9ubHkgZnVuYz8NCg0K
LS0tIGEvYXJjaC94ODYva3ZtL2xhcGljLmMNCisrKyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQpA
QCAtMTYyNywxNiArMTYyNywzOSBAQCBzdGF0aWMgYm9vbCBsYXBpY190aW1lcl9pbnRfaW5qZWN0
ZWQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBfX3dhaXRfbGFw
aWNfZXhwaXJlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGd1ZXN0X2N5Y2xlcykNCiB7DQog
ICAgICAgIHU2NCB0aW1lcl9hZHZhbmNlX25zID0gdmNwdS0+YXJjaC5hcGljLT5sYXBpY190aW1l
ci50aW1lcl9hZHZhbmNlX25zOw0KKyAgICAgICB1NjQgc3RhcnQsIGVuZCwgZGVsYXlfYnkgPSAw
Ow0KIA0KICAgICAgICAvKg0KICAgICAgICAgKiBJZiB0aGUgZ3Vlc3QgVFNDIGlzIHJ1bm5pbmcg
YXQgYSBkaWZmZXJlbnQgcmF0aW8gdGhhbiB0aGUgaG9zdCwgdGhlbg0KLSAgICAgICAgKiBjb252
ZXJ0IHRoZSBkZWxheSB0byBuYW5vc2Vjb25kcyB0byBhY2hpZXZlIGFuIGFjY3VyYXRlIGRlbGF5
LiAgTm90ZQ0KLSAgICAgICAgKiB0aGF0IF9fZGVsYXkoKSB1c2VzIGRlbGF5X3RzYyB3aGVuZXZl
ciB0aGUgaGFyZHdhcmUgaGFzIFRTQywgdGh1cw0KLSAgICAgICAgKiBhbHdheXMgZm9yIFZNWCBl
bmFibGVkIGhhcmR3YXJlLg0KKyAgICAgICAgKiBjb252ZXJ0IHRoZSBkZWxheSB0byBuYW5vc2Vj
b25kcyB0byBhY2hpZXZlIGFuIGFjY3VyYXRlIGRlbGF5Lg0KKyAgICAgICAgKg0KKyAgICAgICAg
KiBOb3RlOiBvcGVuIGNvZGUgZGVsYXkgZnVuY3Rpb24gYXMgS1ZNJ3MgdXNlIGNhc2UgaXMgYSBi
aXQgc3BlY2lhbCwgYXMNCisgICAgICAgICogd2Uga25vdyB3ZSBuZWVkIHRvIHJlZW50ZXIgdGhl
IGd1ZXN0IGF0IGEgc3BlY2lmaWMgdGltZTsgaG93ZXZlciwgdGhlDQorICAgICAgICAqIGRlbGF5
IGxpYnJhcnkgbWF5IGludHJvZHVjZSBhcmNoaXRlY3R1cmFsIGRlbGF5cyB0aGF0IHdlIGRvIG5v
dCB3YW50LA0KKyAgICAgICAgKiBzdWNoIGFzIHVzaW5nIFRQQVVTRS4gT3VyIG1pc3Npb24gaXMg
dG8gc2ltcGx5IGdldCBpbnRvIHRoZSBndWVzdCBhcw0KKyAgICAgICAgKiBzb29uIGFzIHBvc3Np
YmxlIHdpdGhvdXQgdmlvbGF0aW5nIGFyY2hpdGVjdHVyYWwgY29uc3RyYWludHMuDQorICAgICAg
ICAqIFJGQzogS2VlcCBuZGVsYXkgZm9yIGhlbHAgY29udmVydGluZyB0byBuc2VjPyBvciBwdWxs
IHRoYXQgaW4gdG9vPw0KICAgICAgICAgKi8NCiAgICAgICAgaWYgKHZjcHUtPmFyY2gudHNjX3Nj
YWxpbmdfcmF0aW8gPT0ga3ZtX2NhcHMuZGVmYXVsdF90c2Nfc2NhbGluZ19yYXRpbykgew0KLSAg
ICAgICAgICAgICAgIF9fZGVsYXkobWluKGd1ZXN0X2N5Y2xlcywNCi0gICAgICAgICAgICAgICAg
ICAgICAgIG5zZWNfdG9fY3ljbGVzKHZjcHUsIHRpbWVyX2FkdmFuY2VfbnMpKSk7DQorICAgICAg
ICAgICAgICAgZGVsYXlfYnkgPSBtaW4oZ3Vlc3RfY3ljbGVzLCANCisgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBuc2VjX3RvX2N5Y2xlcyh2Y3B1LCB0aW1lcl9hZHZh
bmNlX25zKSk7DQorDQorICAgICAgICAgICAgICAgaWYgKGRlbGF5X2J5ID09IDApIHsNCisgICAg
ICAgICAgICAgICAgICAgICAgIHJldHVybjsNCisgICAgICAgICAgICAgICB9IGVsc2Ugew0KKyAg
ICAgICAgICAgICAgICAgICAgICAgc3RhcnQgPSByZHRzYygpOw0KKw0KKyAgICAgICAgICAgICAg
ICAgICAgICAgZm9yICg7Oykgew0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjcHVf
cmVsYXgoKTsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW5kID0gcmR0c2MoKTsN
CisNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWYgKGRlbGF5X2J5IDw9IGVuZCAt
IHN0YXJ0KQ0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0K
Kw0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZWxheV9ieSAtPSBlbmQgLSBzdGFy
dDsNCisgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RhcnQgPSBlbmQ7DQorICAgICAg
ICAgICAgICAgICAgICAgICB9DQorICAgICAgICAgICAgICAgfQ0KICAgICAgICB9IGVsc2Ugew0K
ICAgICAgICAgICAgICAgIHU2NCBkZWxheV9ucyA9IGd1ZXN0X2N5Y2xlcyAqIDEwMDAwMDBVTEw7
DQogICAgICAgICAgICAgICAgZG9fZGl2KGRlbGF5X25zLCB2Y3B1LT5hcmNoLnZpcnR1YWxfdHNj
X2toeik7DQoNCg0K

