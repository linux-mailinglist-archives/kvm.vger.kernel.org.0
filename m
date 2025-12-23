Return-Path: <kvm+bounces-66577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A0592CD80C0
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1E593022A8E
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F02732E06D2;
	Tue, 23 Dec 2025 04:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pY+Ev6dd";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aZxRrh/7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000522D8DC4;
	Tue, 23 Dec 2025 04:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463809; cv=fail; b=XtL74Tpx8x63DpFFhAz3E/1ECMNNAOEWW8iIJborbgOXjj4z3IYgVQxena5A5vBa/wasLeYGJh5j6l9Pw6eC+GQhMEhR57z128yhxWE9wlYooJu6esRZSY/ItCwR9OoMQEozOcoXSKn6fh30i6+aWlKSkWpFhszVqOVwsCGW7LI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463809; c=relaxed/simple;
	bh=v1BtaxXoT28CYtpNlqb6mfhfuq24O2GV9pAeIzsWBx8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cfPLMfCOCR7vsB3yJZiR5fKgLepYBOPCVv6VmZIkVIvZe8L4XuIRqyNd7JiA9fhyxoO3rQyJpfwMmn1lunQ1rynr5QhsJvtQCYVXRQvXoEMNrFUnngi1GWrF3kW9unEHfyoxle3ogloeUQ5P6Jyq9kR5t+rC4kl481IrKphttoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pY+Ev6dd; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aZxRrh/7; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMI793m2549984;
	Mon, 22 Dec 2025 20:15:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=v1BtaxXoT28CYtpNlqb6mfhfuq24O2GV9pAeIzsWB
	x8=; b=pY+Ev6ddJ6ejQBsGF5qgN2Sc/77pf5hUAw3Wx3Eo1ox6oGoKXktfLSVYf
	LjcIB5wSxnBx5g/C0XFzMlLXdvQ0isJV0xOX/gm1xynIejC0pBIZA5KZKCwPFAB6
	OTjFcUYWv6p5MhULbmPRki1HgZCldEzaQr9A3thD0QR3cPD1rGTuOPujVm46VBc8
	058/zf/8Cj0/T5TGdrLQAGCbBKdMaEEcrIwPLtC60s9IneRnXa1JDOapOypic1XX
	vEEbWe/K6U/YtpR1l/AQ0xRyXvfqtfVyuW3xujAgUS27fXcL1FKV2sRYYPr+0VUw
	n9RXj5sxsY3UWHnC47+kTzhryQFwQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023137.outbound.protection.outlook.com [40.107.201.137])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5v7yvrf5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PTX+cLh6rYPXtEAB4G+IGhOCexPm0WQwvFHajK/l4OKvuGJEqpl5W7ufkcnFN4V7oft206BIiFNnDCc1HWIor0aEIcnblXogBGc0gndj+vI2+W3satuU/MWlDWGWMWICD6pR7R6UHrOMsyXdVQXwHQl+7RMj3OmDy+cgdLQgb+Qh3Em8bj2bPco7dWS1U35BouOjTlNaNEww9TQyWYbQHjKEWhkfYN37kLebQCm04EvrQJjrrFEmQUSvys2j60WgbJRurNY7KfUIH+okkegJXj63FOWYhQBwB2LdpVm09Q+o8FPnwvClv62XgC9CpQGgXCIO4hf+MfmorxmdaUEC9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1BtaxXoT28CYtpNlqb6mfhfuq24O2GV9pAeIzsWBx8=;
 b=jUEqPz/n+eR8kIVFccriteCdmrTjLZRKehLUv2XOGhpC0EAebUIYKC09JzWwOQ9TwC8VELPBr0Ibt5JJBOcDP69L4WEWTSaTxutbtqtWX9WXT0c3TOELvYK37WAFNcgCKlVqTlXYrF/mq1U4JA2YfdzLO3KTwKV1Vq4m54X8SNcgPOn295cwDz2GEYrYSqfJb4GeWHm+T9d4UZOy3fKQ//86z/q17ka1A7HDwgg4qZxL0Zw241ylk46pPhj0a3gB9k9w6IUcY6/EyzmdWqsSEra0Mo6ZSfU/19Tp6YHRB0bOvCzUM+7GRPTqMJk9AB6+ISt3Z+RJG0mu92FoFmyU/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v1BtaxXoT28CYtpNlqb6mfhfuq24O2GV9pAeIzsWBx8=;
 b=aZxRrh/7yFQlK8fEM6e1vJcXOXcKnSVRArkexBylwB05A3OCKPcFgRPBvSKZCmIm8xjCOMzYzA1JoThjBiHssjhsQdkPOLiMfQ7qsV46LucXeZbvTVZxbo/hzE5nZe3fmO/EHispcuoyRfcBfYVrvqc8U+rbXFOB1xpF09LL6DnmcmQ6KosQWgRC/7XajP02d+MZe3sktIhiCSVPGzdeqZ5RXGNeS6RoEhawWCPHnrCoThfc8j9b2vqzyOuBtOGB+CIZcb45j/FXJFqIRaN49eLr0yfDYJJrxJ/vGl9L89SEWxnul6ksJ9z1r3LzjYKkgSEan7eZ2pSIEJYjSnsmhg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:46 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:46 +0000
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
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?=
	<mic@digikod.net>
Subject: Re: [RFC PATCH 11/18] KVM: VMX: Enhance EPT violation handler for
 PROT_USER_EXEC
Thread-Topic: [RFC PATCH 11/18] KVM: VMX: Enhance EPT violation handler for
 PROT_USER_EXEC
Thread-Index: AQHblFP2dwm3hnDEPEGdGOkNqOSnpbPPtc+AgWCnG4A=
Date: Tue, 23 Dec 2025 04:15:46 +0000
Message-ID: <9AD984B5-64B3-42D4-B087-44112868D693@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-12-jon@nutanix.com> <aCJDzU1p_SFNRIJd@google.com>
In-Reply-To: <aCJDzU1p_SFNRIJd@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: a38736d4-d64b-4036-ea4f-08de41d9f253
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y0RYQTlVRFkyQmk1UHlHR3JLajNEZ1llamJYd0dzM3NqNFFpZG9oaGtVWnZm?=
 =?utf-8?B?d1NNdXNXQ0JQOFdFMExWOWRuVmtrL254NXNFeVNpYVJkSmJ2eEoxbmFIWkl1?=
 =?utf-8?B?aFYwS3lZbG5wcWNpSEpxb2dsaUdTa2hBK1VuUmRTOFNaVXdiTHd1aUo0MFRy?=
 =?utf-8?B?K2p5MHI3UWJreDJLVHBkeittTEJ3aW9tR1RoRWNmYloyRUprRGRacjAwRDBX?=
 =?utf-8?B?MjI0T3dHRWNsbmVnNC9lK0MvWFlVUmpJbkZzOXR3Ukx5U21jYWduY1IyVmhI?=
 =?utf-8?B?TmllR1E2MUxJdFBHeWllaVhlWlc1b0oycnRzVDZTRjNGNUFTZWVNR0wvcGJ6?=
 =?utf-8?B?cW9CcVdoMGpKeml5ZUY2dXNaa2pWRzREV1ZhRkI3UUl3Ynp5Vm1rc0RNZ1Rw?=
 =?utf-8?B?aVlUcUZ6dkhHUWRlMVNOSWxpZzFIcXpTd2J5QWtSbXR0eWQ4Yms1eFA0R3lG?=
 =?utf-8?B?U1VrZlppQ3AyYXhDMUcrWTFxakdtWEhHTFVSeVI1Qzl5dDdFeGJDQktIY1ZK?=
 =?utf-8?B?Q0dDZnMzTVhpOERGazFxZ24ydk5jTG1CcUxWV3BLSEdoWUlML3VIMGRJUDhS?=
 =?utf-8?B?T1YzSXZHdHdhd3p2TnhXVUg1dlhodUlmcUkzRTg5WVFFTzhHMkZXRE5vd3M5?=
 =?utf-8?B?aERKQUl1cTlCZ08zaXV5NURMa2JyTkljcXRoVk1ySC9DdFpDazEwNjFhd2xt?=
 =?utf-8?B?eTdZTlgrelVocUhOcW1qbDk2RVBxM3Q2VjNSamJTeG11OUUzdHdycjIyUEt0?=
 =?utf-8?B?eFJKT2U1amRiZ1hlbkhDQlRwV0ZpV09aVW9RVUJoYlpscSt2dUJkb1lndi9L?=
 =?utf-8?B?b1pUV0pGWGVKRmFhbWE0ZWw1Vk1iaCtibFFTWjREb2JBdHVwbGszUGlqRzF4?=
 =?utf-8?B?WCtaY21zUTIrWFZRNW9CUDBUa0RLQVZZd0VIM3A4MndUeVc1dEtEUll1V3FH?=
 =?utf-8?B?cWlyZDdZbURZMW1kYXhob3U5TmEyelVvOWtvNHZFaGJXR3pVY1ErSFNILzZJ?=
 =?utf-8?B?SnkwUGMzOTExRXR2N3pBYWFyU1k0Z3VOMFVQL1pWNXZwZjRwaFRQVXQ0K1JH?=
 =?utf-8?B?Tk9GUWo3QjNFdWUvOTBaSXBMZitiT2U2dEtabjVYakdVRTVzQ0s5WU5lVWdD?=
 =?utf-8?B?aE9DSmtLNXBGZFYwalZ0MnkxcTladkRRUnJ4T3QyYjVhOWVDKzZybEZXN3hM?=
 =?utf-8?B?Nlppa21xaTRwb3BUa25MUVZLRFR3R1hNVklXZ21tQ0U3UllveDNEd3NiMVRQ?=
 =?utf-8?B?TVJ6VVBFMnptcHFFM05yYXlITGs5ZGROTDVIR0lTbk9Hd2I4ZUZzR0hQWm1X?=
 =?utf-8?B?eFBaeXh6SDNEcU11WDZ5amg3OWdPYjQwMmFvWmpsdHJsY0VqeG11ZkdFUUxL?=
 =?utf-8?B?OTNhVzhWWDNFT0NxdTBFQUxkOHdOY1BaU2ZkZEg2VUQxTnJDYmVsS0ZMbjcr?=
 =?utf-8?B?K1kvVHlndmVjYTg2T1hoZlYxdEpWSTZPVXBUbzVFa0NKNTlSNlpJZWIyU1Fu?=
 =?utf-8?B?Qis0VUFRckt2cjJtdE5DYi8yWVFqOFltbGNscCtFRzYxNTRaRHdQUDVvNEd6?=
 =?utf-8?B?LzAwTDNROVY5MWR2NEdmdFZkZzlKc3ZpQlVhQ09qNHlMTTdoZWIxL095SmRE?=
 =?utf-8?B?NXFaSXJmdldWQXFTQTJ6NmZBSE5iNW9jN3pLNStJZzJHanFXZlZBdGgxTjJp?=
 =?utf-8?B?c0xGeEIzVkhWL0F2NXFJdGNNRFBNY3VTbEVCMmY0YUNUWC9VOG00VG1lVWFT?=
 =?utf-8?B?SjY4bUkxOVRkVVhYUHVma0huOTlkUVhLc2VXc3NDOG03SENmQmEzQkJES2hR?=
 =?utf-8?B?V3JEVzVxUHh0WE5ZQWMvbkFCclFxVldZT0tKeXVtRmhYNk1QQUVpMUZXOFVR?=
 =?utf-8?B?RjRuSENFZFB1eHplWDZvYytUc0NNdGZPWTh3OWdhRmlUQkY3M21PQWdXbzdV?=
 =?utf-8?B?bmYreXhTVE5sRDY4VTB0SVRXSXk1UXVzUWdSRGtrdkV6RDMzSnR4RjJiVGdG?=
 =?utf-8?B?M1hJS2RHV0dYVlYwY3Z0YUZZbURRUmVUakgyT0VHeHViU0NKUytvNlc3ekg4?=
 =?utf-8?Q?5fsPy4?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OEtGWUdmdnhMQUE1TStCRk9ZQk51ME1qOE1Eck0rMER6ZW53bEhZWlAzTEdJ?=
 =?utf-8?B?NGNmL21zTjVFMmpudXVaV0dTZzZpTm1IdzViNW9nTEI3cGNSYlhZbWRjOWZu?=
 =?utf-8?B?MTdObG1FblV3NFJWUnVFanhDUGZkb29Tb0dwTzdpWnU2OTZwRmNLVlg4RzM3?=
 =?utf-8?B?Yzc1S2hrMFNVZjl5VUxZYjBKRVcweUc3Ujc5NjZsK3ordXBDcE1XVCtpTFR6?=
 =?utf-8?B?UHNRQWkwUXVTWDZKSXRJWVd1TzdINW1WVjlIMHkyeC85S1hJdUY4VWVZVUtG?=
 =?utf-8?B?RU54OGMvbW5qYmhQNXBXWmFGV0YxMEFFNWdhSmFkNFlzQWZPajVrR2p2NFJn?=
 =?utf-8?B?NGdPRDMvc2d2ZXZWclZqQldYQVY3REw5MmIvTi8xVHJyWjJlcjRDWU5jLzJa?=
 =?utf-8?B?eXhqVXI1bGFnN0pMSDNWU1lXNzN3TEdxc3FGMUVYTEszL1pXZXFxZ2ZVYkR6?=
 =?utf-8?B?SENHSm1hQXJVSVViMVFhbkJFVnFadTFRbXhOb1FieFMzTGtTbDNYMVJCWUMr?=
 =?utf-8?B?VUw0WWlRTk9vdlNYSDJXZW80R1IrYVQxU3k5RmdBMnJyNW5iaDJaNTNWQWJ2?=
 =?utf-8?B?T0RXL1FpaWMxQVBBY3Z6Y3kyNGVXL1UwUTZQQUcyV1U2WTZCNmxDeitzUUdw?=
 =?utf-8?B?V3J5RUpGTGtHN0tySWxYbXRWQW9jcWhrdnRNR1pXQ2ZhdVhQNHFJN3o3blNY?=
 =?utf-8?B?RVI1ZU1uVEl1dkEwc1VqVS90Y210WllVV2k1Nm05UnhrUUMxSzlVUnk3Lzdh?=
 =?utf-8?B?TFJhWmZuVTlRY1hVQXZVaG9ZTTVVcXNMakQ2aiswOGFzUkpMQ0U3MVBkeThM?=
 =?utf-8?B?RkQyNHNzOHMyYk1SdUJLZHRFK09KMGJnbkhXQlRmQ3ZsVkVyQVduUHR1ZDQ1?=
 =?utf-8?B?ZTRnRW1iY0JudDZRSE0wS1EyNy9GL0x5cVNHeTJJRFl4Vjg4ZzN4L1lnaHEv?=
 =?utf-8?B?Mm51dWR4cTVnRVNabTRsQnd2d3ZZSTRWN2FLOFBlVUxlK1RZSDl4TDFKUWJQ?=
 =?utf-8?B?cTJ2RnpyT3BMY1JxSWRBL3JaOWx3YlJSdmRkemkxVVcyN2d1aHlUY1kxRk4x?=
 =?utf-8?B?ZVhuSkF4WmtmVGR1eFQvbVVDRnF3QUVMeW1TYWtqMmRJTUtnYk5JMStWazRB?=
 =?utf-8?B?WHRSOGFNZHJrN1l1NkJaUDFBb0pZVFlGeHVVVUo2NDFwZzhFdkJPQURGeUp2?=
 =?utf-8?B?V21ndloya3o4ZGRoOU5LMndMSXNORnBWZHV6VXE2UXpTUlQ4WG4yRVJ0ckxn?=
 =?utf-8?B?T3F0ekQrbHp6ZGlxM2RiNlJQcW1PdHA5bzFtZXlhMUtxV2Uwejd6UUdyaTM3?=
 =?utf-8?B?N1ZSdzNqZFlJWUNLckpMR3VTL3lvQThUa21zOXgxWW1aVGdyMlVYV1N5bkNX?=
 =?utf-8?B?VVhIWW5ZOTNzMVhMYnF3S1lFSXlRZ2pCSnpsUUViejNWcmJaQjhmQ2gwbEor?=
 =?utf-8?B?bFIrNHVnd0FOdnhBcDBIbzlubUVwTVA2UjE5NkZNQ1g4UHlRczBVdDlhVmh4?=
 =?utf-8?B?eVVrYjU3akh6dTVtOGhJRjVnUmpBRXFuL3BrdDgzSUY1N1A2MGltQi9ROTcr?=
 =?utf-8?B?eGpRcXF2MnJxUUl1eFhIVWZULzdKdTZyQ2lRdGFhOXFJdmIrQzVsRG92ZWl3?=
 =?utf-8?B?T2hiNjYzKzNGVy9VNjNDNkJuSzY1Uy9EZ3NtUEEyVGhpQkZSTHdpVGsxakRQ?=
 =?utf-8?B?WVBmU0F1K3VlbGVKbEJKMnFpRFNOemYxN0F5WEd6SjF3c240alN6SjhzcGN6?=
 =?utf-8?B?S2x6R2RibGpSdTV4Ky9TVUlZRUE2WTZSY0hPL2pCemY4eVBlaFhWYUNWWmRa?=
 =?utf-8?B?alZ5WFhkRU9pZk8vZkpRbjBneHYydWlhcGpzS2Y1M0REMGMxUGdNWWlPdnd4?=
 =?utf-8?B?UllHOUJ0Y3Y1aHg0TTZ6bDFJZ2xWa3ZzYVNEK3ZaY055N2c4cDNJb214VHJ1?=
 =?utf-8?B?QUtRblFwVTE0UVpnRlJCVzZRM3hxTThBZDFhZ2h1aVFJdFVGZFNNL2VWVWt2?=
 =?utf-8?B?TkdOTlNrcXZuaDlKZ2FTekNpamNrWEdZTmxGOWordzBxTVBoVEVaNmtvdGJY?=
 =?utf-8?B?LzZIb2JldkJ2SzZPUkQ0cW0wTkJDb3BDS0RpQ054T3ZmT2hId096amkwcjJ2?=
 =?utf-8?B?QlBKSE1Qc0k2UXhmMS9vbTRYYkY2bEQ5T29nZklXMENUaUQrOVZZY1pCVDlo?=
 =?utf-8?B?U1R5VCt2ZkROODhSSzhRTDZhN3pHZUZFYjBlZlB5a1luaURvN2RJK1NHVTNv?=
 =?utf-8?B?VXJzSWV0TmhSVmRvVXhITXFRV1dtdTUrUVY4Rk5heEZlRU9CYTVlaVBQZERR?=
 =?utf-8?B?OStCS3lSRkI4SkVOWWV1bEw4WGpCTHJHV0FGMGZTaExEaU44YXE5bEVWd09h?=
 =?utf-8?Q?5xqwZOw+1jcjTYIiPQrL4iqbBIRaBIf54abRjeOeShzHZ?=
x-ms-exchange-antispam-messagedata-1: qM/+gzfeD22PwdTuw9x8Vh6DMNiGi9OjOkY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4749E076E3CBD149B0B0456070826B21@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a38736d4-d64b-4036-ea4f-08de41d9f253
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:46.2426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2YQlRjCXd/aZSuA6+8IU5OGbAZfbRWQ5gVftOSVnN9Qz53UDWTeSV3Y5ySspuoJANEqouX8U0o3+UFGqunkCgGrLO9PXNU5Rml8Do0J13Aw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Proofpoint-ORIG-GUID: WF6lsJL6bApKMpo_r6ha6ht6SE1oHOx1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX8KZ2dz73tJvk
 p968TrUX98LM8Wl952NBMy0QqAU3Fa7Ed6a/aMcBuPPjW0MeqE13oHxR9zbzLkQXWr0+DhYVwgj
 snLrcPNEVqv1V0foRsW8YdId70Mxzg3qBCFVoVU6SR1GSjGmhGs2KA5yNsmjG6AovQhh86bonZ4
 w2aHI39oOiHTvNkAc6vkXfCEHayfDwjptTyWmGqgeefQImkAXeMESiar+7X8I0BzxcrHz/vRBe4
 4H66vMM8DeHGy2+BgZb3S4FvOCekIuTZs+Rk6BvWuUJmZe5Y2GnDP8byXbTcmZ6ZPUpI4czzllq
 +13zNyPMhiB+qwMETdmZL8cCOwU7vIFjK/FMmC6AL2wrCYnOQqixmhcthc5l/hxKV1K+PTe/rsH
 K6yFZcrhjNhu/J8O0jvogr4ZKQMAPPKPC1mLY5FbARSw1kVhkdxWhuFS0R9TkkUFOyzwaw8do0V
 Pb8F6AdeNObvd03/uhw==
X-Authority-Analysis: v=2.4 cv=S8TUAYsP c=1 sm=1 tr=0 ts=694a1773 cx=c_pps
 a=fZezqqEN0LPY/ff19f4zYQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=CDL3TQjOww8iQmOnD6IA:9
 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-GUID: WF6lsJL6bApKMpo_r6ha6ht6SE1oHOx1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjU04oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gRnJvbTogTWlja2HDq2wgU2FsYcO8biA8bWljQGRpZ2lrb2Qu
bmV0Pg0KPj4gDQo+PiBBZGQgRVBUX1ZJT0xBVElPTl9QUk9UX1VTRVJfRVhFQyAoNikgdG8gcmVm
bGVjdCB0aGUgdXNlciBleGVjdXRhYmxlDQo+PiBwZXJtaXNzaW9ucyBvZiBhIGdpdmVuIGFkZHJl
c3Mgd2hlbiBJbnRlbCBNQkVDIGlzIGVuYWJsZWQuDQo+PiANCj4+IFJlZmFjdG9yIHVzYWdlIG9m
IEVQVF9WSU9MQVRJT05fUldYX1RPX1BST1QgdG8gdW5kZXJzdGFuZCBhbGwgb2YgdGhlDQo+PiBz
cGVjaWZpYyBiaXRzIHRoYXQgYXJlIG5vdyBwb3NzaWJsZSB3aXRoIE1CRUMuDQo+PiANCj4+IElu
dGVsIFNETSAnRXhpdCBRdWFsaWZpY2F0aW9uIGZvciBFUFQgVmlvbGF0aW9ucycgc3RhdGVzIHRo
ZSBmb2xsb3dpbmcNCj4+IGZvciBCaXQgNi4NCj4+ICBJZiB0aGUg4oCcbW9kZS1iYXNlZCBleGVj
dXRlIGNvbnRyb2zigJ0gVk0tZXhlY3V0aW9uIGNvbnRyb2wgaXMgMCwgdGhlDQo+PiAgdmFsdWUg
b2YgdGhpcyBiaXQgaXMgdW5kZWZpbmVkLiBJZiB0aGF0IGNvbnRyb2wgaXMgMSwgdGhpcyBiaXQg
aXMNCj4+ICB0aGUgbG9naWNhbC1BTkQgb2YgYml0IDEwIGluIHRoZSBFUFQgcGFnaW5nLXN0cnVj
dHVyZSBlbnRyaWVzIHVzZWQNCj4+ICB0byB0cmFuc2xhdGUgdGhlIGd1ZXN0LXBoeXNpY2FsIGFk
ZHJlc3Mgb2YgdGhlIGFjY2VzcyBjYXVzaW5nIHRoZQ0KPj4gIEVQVCB2aW9sYXRpb24uIEluIHRo
aXMgY2FzZSwgaXQgaW5kaWNhdGVzIHdoZXRoZXIgdGhlIGd1ZXN0LXBoeXNpY2FsDQo+PiAgYWRk
cmVzcyB3YXMgZXhlY3V0YWJsZSBmb3IgdXNlci1tb2RlIGxpbmVhciBhZGRyZXNzZXMuDQo+PiAN
Cj4+ICBCaXQgNiBpcyBjbGVhcmVkIHRvIDAgaWYgKDEpIHRoZSDigJxtb2RlLWJhc2VkIGV4ZWN1
dGUgY29udHJvbOKAnQ0KPj4gIFZNLWV4ZWN1dGlvbiBjb250cm9sIGlzIDE7IGFuZCAoMikgZWl0
aGVyIChhKSBhbnkgb2YgRVBUDQo+PiAgcGFnaW5nLXN0cnVjdHVyZSBlbnRyaWVzIHVzZWQgdG8g
dHJhbnNsYXRlIHRoZSBndWVzdC1waHlzaWNhbCBhZGRyZXNzDQo+PiAgb2YgdGhlIGFjY2VzcyBj
YXVzaW5nIHRoZSBFUFQgdmlvbGF0aW9uIGlzIG5vdCBwcmVzZW50OyBvcg0KPj4gIChiKSA0LWxl
dmVsIEVQVCBpcyBpbiB1c2UgYW5kIHRoZSBndWVzdC1waHlzaWNhbCBhZGRyZXNzIHNldHMgYW55
DQo+PiAgYml0cyBpbiB0aGUgcmFuZ2UgNTE6NDguDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IE1p
Y2thw6tsIFNhbGHDvG4gPG1pY0BkaWdpa29kLm5ldD4NCj4+IENvLWRldmVsb3BlZC1ieTogSm9u
IEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8
am9uQG51dGFuaXguY29tPg0KPj4gDQo+PiAtLS0NCj4+IGFyY2gveDg2L2luY2x1ZGUvYXNtL3Zt
eC5oICAgICB8ICA3ICsrKystLS0NCj4+IGFyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaCB8
IDE1ICsrKysrKysrKysrKy0tLQ0KPj4gYXJjaC94ODYva3ZtL3ZteC92bXguYyAgICAgICAgIHwg
IDcgKysrKystLQ0KPj4gMyBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25zKCspLCA4IGRlbGV0
aW9ucygtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdm14Lmgg
Yi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaA0KPj4gaW5kZXggZmZjOTBkNjcyYjVkLi44NGM1
YmU0MTZmNWMgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS92bXguaA0KPj4g
KysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdm14LmgNCj4+IEBAIC01ODcsNiArNTg3LDcgQEAg
ZW51bSB2bV9lbnRyeV9mYWlsdXJlX2NvZGUgew0KPj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX1BS
T1RfUkVBRCBCSVQoMykNCj4+ICNkZWZpbmUgRVBUX1ZJT0xBVElPTl9QUk9UX1dSSVRFIEJJVCg0
KQ0KPj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX1BST1RfRVhFQyBCSVQoNSkNCj4+ICsjZGVmaW5l
IEVQVF9WSU9MQVRJT05fUFJPVF9VU0VSX0VYRUMgQklUKDYpDQo+IA0KPiBVZ2gsIFREWCBhZGRl
ZCB0aGlzIGFzIEVQVF9WSU9MQVRJT05fRVhFQ19GT1JfUklORzNfTElOIChhcHBhcmVudGx5IHRo
ZSBURFggbW9kdWxlDQo+IGVuYWJsZXMgTUJFQz8pLiAgSSBsaWtlIHlvdXIgbmFtZSBhIGxvdCBi
ZXR0ZXIuDQo+IA0KPj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX1BST1RfTUFTSyAoRVBUX1ZJT0xB
VElPTl9QUk9UX1JFQUQgIHwgXA0KPj4gRVBUX1ZJT0xBVElPTl9QUk9UX1dSSVRFIHwgXA0KPj4g
RVBUX1ZJT0xBVElPTl9QUk9UX0VYRUMpDQo+IA0KPiBIbW0sIHNvIEkgdGhpbmsgRVBUX1ZJT0xB
VElPTl9QUk9UX01BU0sgc2hvdWxkIGluY2x1ZGUgRVBUX1ZJT0xBVElPTl9QUk9UX1VTRVJfRVhF
Qy4NCj4gVGhlIGV4aXN0aW5nIFREWCBjaGFuZ2UgZG9lcyBub3QsIGJlY2F1c2UgdW5mb3J0dW5h
dGVseSB0aGUgYml0IGlzIHVuZGVmaW5lZCBpZg0KPiBNQkVDIGlzIHVuc3VwcG9ydGVkLCBidXQg
dGhhdCdzIGVhc3kgdG8gc29sdmUgYnkgdW5jb25kaXRpb25hbGx5IGNsZWFyaW5nIHRoZSBiaXQN
Cj4gaW4gaGFuZGxlX2VwdF92aW9sYXRpb24oKS4gIEFuZCB0aGVuIHdoZW4gbmVzdGVkLUVQVCBN
QkVDIHN1cHBvcnQgY29tZXMgYWxvbmcsDQo+IGhhbmRsZV9lcHRfdmlvbGF0aW9uKCkgY2FuIGJl
IG1vZGlmaWVkIHRvIGNvbmRpdGlvbmFsbHkgY2xlYXIgdGhlIGJpdCBiYXNlZCBvbg0KPiB3aGV0
aGVyIG9yIG5vdCB0aGUgY3VycmVudCBNTVUgc3VwcG9ydHMgTUJFQy4NCj4gDQo+IEknbGwgcG9z
dCBhIHBhdGNoIHRvIGluY2x1ZGUgdGhlIGJpdCBpbiBFUFRfVklPTEFUSU9OX1BST1RfTUFTSywg
YW5kIG9wcG9ydHVuaXN0aWNhbGx5DQo+IGNoYW5nZSB0aGUgbmFtZS4NCg0KSSBkaWRu4oCZdCBz
ZWUgYSBwYXRjaCBmb3IgdGhpcyBpbiA2LjE4LCBzbyBJIGFkZGVkIGEgc2ltcGxlIHByZXAgcGF0
Y2ggZm9yIHRoaXMgaW4gdjENCmluIG15IHNlcmllcy4gSGFwcHkgdG8gcGVlbCBpdCBvdXQgaWYg
bmVlZGVkIHNvIHdlIGNhbiBsYW5kIHRoYXQgc29vbmVyLCBidXllcnMgY2hvaWNlLg0KDQo+PiBA
QCAtNTk2LDcgKzU5Nyw3IEBAIGVudW0gdm1fZW50cnlfZmFpbHVyZV9jb2RlIHsNCj4+ICNkZWZp
bmUgRVBUX1ZJT0xBVElPTl9SRUFEX1RPX1BST1QoX19lcHRlKSAoKChfX2VwdGUpICYgVk1YX0VQ
VF9SRUFEQUJMRV9NQVNLKSA8PCAzKQ0KPj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX1dSSVRFX1RP
X1BST1QoX19lcHRlKSAoKChfX2VwdGUpICYgVk1YX0VQVF9XUklUQUJMRV9NQVNLKSA8PCAzKQ0K
Pj4gI2RlZmluZSBFUFRfVklPTEFUSU9OX0VYRUNfVE9fUFJPVChfX2VwdGUpICgoKF9fZXB0ZSkg
JiBWTVhfRVBUX0VYRUNVVEFCTEVfTUFTSykgPDwgMykNCj4+IC0jZGVmaW5lIEVQVF9WSU9MQVRJ
T05fUldYX1RPX1BST1QoX19lcHRlKSAoKChfX2VwdGUpICYgVk1YX0VQVF9SV1hfTUFTSykgPDwg
MykNCj4gDQo+IFdoeT8gIFRoZXJlJ3Mgbm8gZXNjYXBpbmcgdGhlIGZhY3QgdGhhdCBFWEVDLCBh
LmsuYS4gWCwgaXMgZG9pbmcgZG91YmxlIGR1dHkgYXMNCj4gImV4ZWMgZm9yIGFsbCIgYW5kICJr
ZXJuZWwgZXhlYyIuICBBbmQgS1ZNIGhhcyBuZWFybHkgdHdvIGRlY2FkZXMgb2YgaGlzdG9yeQ0K
PiB1c2luZyBFWEVDL1ggdG8gcmVmZXIgdG8gImV4ZWMgZm9yIGFsbCIuICBJIHNlZSBubyByZWFz
b24gdG8gdGhyb3cgYWxsIG9mIHRoYXQNCj4gYXdheSBhbmQgZGlzY2FyZCB0aGUgaW50dWl0aXZl
IGFuZCBwZXJ2YXNpdmUgUldYIGxvZ2ljLg0KDQpZZWEsIGFncmVlZCwgdGhpcyB3YXMgd2F5IHRv
byBjb25mdXNpb24gaW4gUkZDLCBJIGZpeGVkIGl0IGFsbCBpbiB2MSAoa25vY2sgb24gd29vZCks
IHNvDQppdCBpcyBtdWNoIGVhc2llciBvbiB0aGUgZXllcyBhY3Jvc3MgdGhlIGJvYXJkLiANCg0K
Pj4gQEAgLTUxMCw3ICs1MTEsMTUgQEAgc3RhdGljIGludCBGTkFNRSh3YWxrX2FkZHJfZ2VuZXJp
Yykoc3RydWN0IGd1ZXN0X3dhbGtlciAqd2Fsa2VyLA0KPj4gKiBOb3RlLCBwdGVfYWNjZXNzIGhv
bGRzIHRoZSByYXcgUldYIGJpdHMgZnJvbSB0aGUgRVBURSwgbm90DQo+PiAqIEFDQ18qX01BU0sg
ZmxhZ3MhDQo+PiAqLw0KPj4gLSB3YWxrZXItPmZhdWx0LmV4aXRfcXVhbGlmaWNhdGlvbiB8PSBF
UFRfVklPTEFUSU9OX1JXWF9UT19QUk9UKHB0ZV9hY2Nlc3MpOw0KPj4gKyB3YWxrZXItPmZhdWx0
LmV4aXRfcXVhbGlmaWNhdGlvbiB8PQ0KPj4gKyBFUFRfVklPTEFUSU9OX1JFQURfVE9fUFJPVChw
dGVfYWNjZXNzKTsNCj4+ICsgd2Fsa2VyLT5mYXVsdC5leGl0X3F1YWxpZmljYXRpb24gfD0NCj4+
ICsgRVBUX1ZJT0xBVElPTl9XUklURV9UT19QUk9UKHB0ZV9hY2Nlc3MpOw0KPj4gKyB3YWxrZXIt
PmZhdWx0LmV4aXRfcXVhbGlmaWNhdGlvbiB8PQ0KPj4gKyBFUFRfVklPTEFUSU9OX0VYRUNfVE9f
UFJPVChwdGVfYWNjZXNzKTsNCj4gDQo+IElNTywgdGhpcyBpcyBhIGJpZyBuZXQgbmVnYXRpdmUu
ICBJIG11Y2ggcHJlZmVyIHRoZSBleGlzdGluZyBjb2RlLCBhcyBpdCBoaWdobGlnaHRzDQo+IHRo
YXQgVVNFUl9FWEVDIGlzIHRoZSBvZGRiYWxsLg0KDQpTb2xkLCBJIGRpZG7igJl0IGxvdmUgaXQg
ZWl0aGVyLiBWMSBpcyBtdWNoIHNtb290aGVyIGluIHRoaXMgYXJlYS4NCj4gDQo+PiArIGlmICh2
Y3B1LT5hcmNoLnB0X2d1ZXN0X2V4ZWNfY29udHJvbCkNCj4gDQo+IFRoaXMgaXMgd3Jvbmcgb24g
bXVsdGlwbGUgZnJvbnRzLiAgQXMgbWVudGlvbmVkIGVhcmxpZXIgaW4gdGhlIHNlcmllcywgdGhp
cyBpcyBhDQo+IHByb3BlcnR5IG9mIHRoZSBNTVUgKG1vcmUgc3BlY2lmaWNhbGx5LCB0aGUgcm9v
dCByb2xlKSwgbm90IG9mIHRoZSB2Q1BVLg0KPiANCj4gQW5kIGNvbnN1bHRpbmcgTUJFQyBzdXBw
b3J0ICpvbmx5KiB3aGVuIHN5bnRoZXNpemluZyB0aGUgZXhpdCBxdWFsaWZjYXRpb24gaXMNCj4g
d3JvbmcsIGJlY2F1c2UgaXQgbWVhbnMgcHRlX2FjY2VzcyBjb250YWlucyBib2d1cyBkYXRhIHdo
ZW4gY29uc3VtZWQgYnkNCj4gRk5BTUUoZ3B0ZV9hY2Nlc3MpLiAgQXQgYSBnbGFuY2UsIEZOQU1F
KGdwdGVfYWNjZXNzKSBwcm9iYWJseSBuZWVkcyB0byBiZSBtb2RpZmllZA0KPiB0byB0YWtlIGlu
IHRoZSBwYWdlIHJvbGUsIGUuZy4gbGlrZSBGTkFNRShzeW5jX3NwdGUpIGFuZCBGTkFNRShwcmVm
ZXRjaF9ncHRlKQ0KPiBhbHJlYWR5IGFkanVzdCB0aGUgYWNjZXNzIGJhc2VkIG9uIHRoZSBvd25p
bmcgc2hhZG93IHBhZ2UncyBhY2Nlc3MgbWFzay4NCg0KQWNrL2RvbmUsIGdvdCByaWQgb2YgYWxs
IG9mIHRoZSB2Y3B1IGNydWZ0IGFuZCBtb3ZlZCBldmVyeXRoaW5nIHRvIG1tdSByb2xlLCB3aGlj
aA0KaXMgbXVjaCBlYXNpZXIgdG8gZGVhbCB3aXRoLiBBbHNvIHdlbnQgYW5kIGJydXNoZWQgdXAg
YSBmZXcgbW9yZSBvZiB0aGVzZSBhcmVhcy4NCg0KPj4gKyB3YWxrZXItPmZhdWx0LmV4aXRfcXVh
bGlmaWNhdGlvbiB8PQ0KPj4gKyBFUFRfVklPTEFUSU9OX1VTRVJfRVhFQ19UT19QUk9UKHB0ZV9h
Y2Nlc3MpOw0KPj4gfQ0KPj4gI2VuZGlmDQo+PiB3YWxrZXItPmZhdWx0LmFkZHJlc3MgPSBhZGRy
Ow0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0v
dm14L3ZteC5jDQo+PiBpbmRleCAxMTY5MTAxNTlhM2YuLjBhYWRmYTkyNDA0NSAxMDA2NDQNCj4+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgv
dm14LmMNCj4+IEBAIC01ODA5LDcgKzU4MDksNyBAQCBzdGF0aWMgaW50IGhhbmRsZV90YXNrX3N3
aXRjaChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiANCj4+IHN0YXRpYyBpbnQgaGFuZGxlX2Vw
dF92aW9sYXRpb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4gew0KPj4gLSB1bnNpZ25lZCBs
b25nIGV4aXRfcXVhbGlmaWNhdGlvbjsNCj4+ICsgdW5zaWduZWQgbG9uZyBleGl0X3F1YWxpZmlj
YXRpb24sIHJ3eF9tYXNrOw0KPj4gZ3BhX3QgZ3BhOw0KPj4gdTY0IGVycm9yX2NvZGU7DQo+PiAN
Cj4+IEBAIC01ODM5LDcgKzU4MzksMTAgQEAgc3RhdGljIGludCBoYW5kbGVfZXB0X3Zpb2xhdGlv
bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+PiBlcnJvcl9jb2RlIHw9IChleGl0X3F1YWxpZmlj
YXRpb24gJiBFUFRfVklPTEFUSU9OX0FDQ19JTlNUUikNCj4+ICAgICAgPyBQRkVSUl9GRVRDSF9N
QVNLIDogMDsNCj4+IC8qIGVwdCBwYWdlIHRhYmxlIGVudHJ5IGlzIHByZXNlbnQ/ICovDQo+PiAt
IGVycm9yX2NvZGUgfD0gKGV4aXRfcXVhbGlmaWNhdGlvbiAmIEVQVF9WSU9MQVRJT05fUFJPVF9N
QVNLKQ0KPj4gKyByd3hfbWFzayA9IEVQVF9WSU9MQVRJT05fUFJPVF9NQVNLOw0KPj4gKyBpZiAo
dmNwdS0+YXJjaC5wdF9ndWVzdF9leGVjX2NvbnRyb2wpDQo+PiArIHJ3eF9tYXNrIHw9IEVQVF9W
SU9MQVRJT05fUFJPVF9VU0VSX0VYRUM7DQo+PiArIGVycm9yX2NvZGUgfD0gKGV4aXRfcXVhbGlm
aWNhdGlvbiAmIHJ3eF9tYXNrKQ0KPj4gICAgICA/IFBGRVJSX1BSRVNFTlRfTUFTSyA6IDA7DQo+
IA0KPiBBcyBtZW50aW9uZWQgYWJvdmUsIGlmIEtWTSBjbGVhcnMgRVBUX1ZJT0xBVElPTl9QUk9U
X1VTRVJfRVhFQyB3aGVuIGl0J3MNCj4gdW5kZWZpbmVkLCB0aGVuIHRoaXMgY2FuIHNpbXBseSB1
c2UgRVBUX1ZJT0xBVElPTl9QUk9UX01BU0sgdW5jaGFuZ2VkLg0KDQpTb2xkIQ0KDQo+PiBpZiAo
ZXJyb3JfY29kZSAmIEVQVF9WSU9MQVRJT05fR1ZBX0lTX1ZBTElEKQ0KPj4gLS0gDQo+PiAyLjQz
LjANCj4+IA0KPiANCg0K

