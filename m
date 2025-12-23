Return-Path: <kvm+bounces-66571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 404CECD808C
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:16:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ADF11301D336
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF5E2E1730;
	Tue, 23 Dec 2025 04:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SNBefVxZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="lA3iT2Lr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A75477E;
	Tue, 23 Dec 2025 04:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463403; cv=fail; b=KJvftGqBUvfA/x75FTGTMPpcQglH4wXQ4wzdSyz2bSIPv3EPhOS1nMvORWXlFUxWp4CzVC7/AqZg+qmyP34Rxr0qJ6afIq0YjkgExXpxSgYmsPFFXMHqe1mCfFiqR7tnxYzkqhzl8fXtkPubU4TuGVYlg9nH8Fp57zfckAByjt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463403; c=relaxed/simple;
	bh=4x9871WgVtJCfriRwubRvYiehs4Ya6TGNtswY4Bce2Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c7NkfLhC9H/t2adFYOoegC3Rp7LDnY5Lk8hr7AAyJ4wJjN3CO9CDHqEg9ZGytOnXoS7J3opDCOAX0MNVMl62hsIdU14p6vwgSO7ZyLA+WJFXRbpMVGY6AZnTQyaF9Iqx6Zqxn4IUpunFYKIx74tbkgweqfg0Lf/HV/l9khdvIOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SNBefVxZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=lA3iT2Lr; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMJib281942616;
	Mon, 22 Dec 2025 20:16:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4x9871WgVtJCfriRwubRvYiehs4Ya6TGNtswY4Bce
	2Q=; b=SNBefVxZ8JuCOMHf5taptlAJROV0pJdy6ZQvfz6r3eNfkHTrwqIHvbABz
	zJY6FuQhLk0dIdwXL9sPZS8ZWvvDhmbbGFNIzdqSGzV1fgffIfvGFQBygrQj5OPc
	AmNI1/1jzEp916vrvRoF+4GCUFVfsM6uc4UB2PxBftff9iPLhPzxXlYX5zat7L2j
	AZWTnQK4Y78eBBoZc0W0mMxWxd5LI85lCVR/XoX+OjQNHe6c/BuPz9RFAhIjJImw
	ZMxy2ZA2xvirzU0Vh1nBVv21Wx40pEBgm5rxSiAc9r7d36J2kPSQ9hYS76yITRFb
	HpgkSwlu9hz52yIJ/wuyVO2y2YqjA==
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11022122.outbound.protection.outlook.com [40.107.200.122])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b73ydt2eu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:16:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXzDpd+CCS973d5JrRLby2X6oKQ4+aYV3WPDwPd2vE9s9z2GV7LBDVmltw0uTTPmpqvVEoZnTQFwdVTJyUR8rLVHFAwLjB4hfaD18at103Ck2T3KZRjqz2vd23m7/m+zdUTwJ7sw++YKe3p0xGoz1nYrIm302pivKRMwbDVmIQd+vqSph2/7h4adI8glH7EP6A1aEc5pVNsPAt6KWYFGPuFWczdFCSuzr4j5Uzp5pmrX2Qq+1xKN6WavA+MtRRsKtAPZQcSIKp+1Ino7I60goM8a9k9jiGoyietynOFgLg8/FF7AErXKJS/+Q18KaXZ3OxkLo4IjgPljreupgQuVUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4x9871WgVtJCfriRwubRvYiehs4Ya6TGNtswY4Bce2Q=;
 b=VoVFW55Dm+IjaaQ1Sunx2rRlk+2J8J54rjoAr+y4gBq2a71BApFfe9go/zvi9sXoXirSvJOqfRaQcu/x7r7o5UAQnPSesCj4c77wUZLSPkeCy7ZNO2P58zSs9OdvZNlwqmnj8iz78c+fv9M59Ykko0uhM0vkmNIrhG6zS3o/Xbw8KfRGdWmh/J74IeGs08Qu0zPnGB2kktU2H6ODZn6NXRecZ3Wmqa4zbJshP+ArQnPNB9Nn0vG7VyvGVd7vHhPTC4/Z/YYf0tAGuBOVKoM9G37gR0QBkCGcfnmw1M4dKT+4R/79FU1luaW9VfVETXbVUe1VG/qhAHzDHZrQRfJ2NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4x9871WgVtJCfriRwubRvYiehs4Ya6TGNtswY4Bce2Q=;
 b=lA3iT2Lrb0hYFkSlDnjzPUxc0pTYDmXZkkmbIeFoWv0Ho+p4zwQIyB1JLxPaMxZmBbUR+RI9NfS74SBYdldbA3HLW2q5jSD/Gvys9xInTCeH72Cbtb7vdu6zcPDxIZ6rpfoMS89w6HvSFpu52mF5OY2zx6PTDi4rBbBlH1znKnV64aZl4iHykqNEMB1gK251Jy9DWA6m5mKhfd8ftka1MSjFM8ahi0l0eLY+Y/JEl/xNNQ8MKrsag9SQPZgANVB/QRbIkNY0eOF33WGLmrAktv40S9CE3mxf243Vm5JNwyOvF6WvPCH/WPgQkcfmdUoQcoSY+ACrNQXaQ0/lFSMllQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH2PR02MB6933.namprd02.prod.outlook.com
 (2603:10b6:610:88::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:16:02 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:16:02 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jon Kohler <jon@nutanix.com>
CC: Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH 17/18] KVM: VMX: Allow MBEC with EVMCS
Thread-Topic: [RFC PATCH 17/18] KVM: VMX: Allow MBEC with EVMCS
Thread-Index: AQHblFQAwzN6irY5bE6x7d5A98UrcLPP4sUAgABKfQCBYC+8AA==
Date: Tue, 23 Dec 2025 04:16:02 +0000
Message-ID: <75DA0FC8-A77C-47EE-BADB-309E90CC58AA@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-18-jon@nutanix.com> <aCJphDlQLyWri9kR@google.com>
 <1F4D7E0A-B4DB-4E9B-B97D-FF4DF6A7902C@nutanix.com>
In-Reply-To: <1F4D7E0A-B4DB-4E9B-B97D-FF4DF6A7902C@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH2PR02MB6933:EE_
x-ms-office365-filtering-correlation-id: a2772164-861b-4f6c-84a3-08de41d9fc2e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VWhUVGw1UnRtU2x1UDZ0cURHVTFQRjdBODRKcDRzN2c5Y0NWRnRZQUFxUVUx?=
 =?utf-8?B?TlhxTkRKY013ZHdkRnM5VmE0Nm05U0R2anpmNTNSbDVIMW4ybDNrTy9Iai9Z?=
 =?utf-8?B?OHdKWE43YXE1dE16VmM0NUpaeE9OVWhoR0QxSS9uakhrOGZNOG8yaEU2UHI1?=
 =?utf-8?B?aUNuMnZhTy9GVlc4VGhOTm9IM1VhR2Y4eWpudUQ5ZHBOQzV2aGQ4bnlxMVJB?=
 =?utf-8?B?b3pYamlmTkVvam5aTzlhcnVVZTE3YXRCVXFPUHpadXh5bHR5NTB4bW03L0VY?=
 =?utf-8?B?eDhWT3RyYWtHWXNVYWFvQkRSQXBDOUpNV1BCNitWendISDQwZC83ckdEbEIz?=
 =?utf-8?B?NGx6Q1kxQ1RiRjRRQnFSRStIMU1EZllDUGsyMzlOUWh2K3VNUThEc2srblhz?=
 =?utf-8?B?L1BVTW1kbW44WmRrdkZEVkxkRzR6YjFvVW53SEFhUmg3VVlyalp1SXRPQkxD?=
 =?utf-8?B?VnJONjM5TVd6QThKQ2I2UWZSNURPS1oycW1uUlc2c285SzZITjdkaWNaR0lv?=
 =?utf-8?B?T0plemlZd1l4ZHdodjBuckJxNjlPdFg0Y3ljRzBJQUNYb2pGZmh4VU93Um80?=
 =?utf-8?B?MWJHZ2txaVNqNXVFOEdXNkpQYXRhT0d4MThxQkpFcDgyOGltMnF0K1ZNdnNi?=
 =?utf-8?B?UWhWbUlZMlpTck1kOFo0Ty9qTG94MWxmV1VpK00zUlcxYURYRFA5WjZpL0dk?=
 =?utf-8?B?Y0dEOUVxbWxJOVZEU2xYalkrbzMzV291WGVtMENRRGE0UTM5eldjKys4Y0h5?=
 =?utf-8?B?R3RHSlJ4U1A5YjAzcnh5UENDOXhDMUkyaTFZRDd6WlFMYnkzUWJUNUx3N0tL?=
 =?utf-8?B?eGhLRFNTL3VJMnl0R1JGbEdqN3lBVEpTRmMvVmUxdGQ1NU5vUlR6czFnZlNi?=
 =?utf-8?B?bUE5WkJvZjhpbDM1UDRWNUJKZk1HL1R0WDR3c29QaDZSZE8xckVmQ3dSYTdO?=
 =?utf-8?B?aGEvVXhuUUhIVzMxOVZ3dm5abndpT0VZUHNpWXozSmxNRThJOHJFZnBjSHcv?=
 =?utf-8?B?SDljUGY2cGpIZGYwMjZTV3VQMDlDbDJFcjZZVzNsdUlxdWZKWkwzU2NhK01K?=
 =?utf-8?B?RVFPTFBuK0tsbWlOZFpwVCtNdFJhZlFGZm4wNy9iZFA2cnRHMWsvZDBDM2lE?=
 =?utf-8?B?VithaUhJNnh3SjN6a2NFUFVkM3FvK1hiazZaMlhrakhDcFZ5MGhDN3M3VUIw?=
 =?utf-8?B?RWhQNlRValJkeUNXMWRrV3puQUZuZ3ZubW5ReTA3bVV5Tzc3Qm5DQ2NxY0Q2?=
 =?utf-8?B?d2VIRnF5WUo0VllteDhnN1N6RExLZUMyb0EwRlVNZUZvckJ6aG5LaW96T1U5?=
 =?utf-8?B?dFBnVXBBWG1LOUw0TDVxcXdZbFFpV0NlK3Q0MHRaUFVHVnY3aVRtN3ZSazNJ?=
 =?utf-8?B?dlBucCtibkRrdnhaaEFzN0lrV29qRDBoZWpWWmdWNXBtOU16UVRJMzVsencv?=
 =?utf-8?B?YTB4eFlQVExXYWhrZCtUMWJjSkxaZ1JMN3ZRcnBuM0hDL0JpTWpKaU5CRlFq?=
 =?utf-8?B?bEtiS00rZ1loTDB4Q3JjaVYvY0hzbUpnVnV2MTFhWUtTdXVsQWJpalpUeHU4?=
 =?utf-8?B?Znd2NldXbjFOWTVXTjBMNlg5VDNXWEY1RHhUNmdRZ25nTnhMWThvUlJEZDZq?=
 =?utf-8?B?MHZ4VDI4cGlJSFFLQ1dIeERsVkZyNlVhejZlMVR4MjVGNVFpYkgxNXF1VjRa?=
 =?utf-8?B?S0ptcUgwYVp1TENPVmZ6SnZERlUxMlZCOEJrQWl4QlZyWndFeE5JWFhxcjlI?=
 =?utf-8?B?MGNoV1d5UE90TlRGUnRDVTFtVW9DeFRZN2l3clRldnkwVDlZTXAzOEtjajEx?=
 =?utf-8?B?T1FVK3pCaURqNUh4alhsQnVOQ0lWZ2RFZjJKeGkzZ21Nb2x6Y0xWZU82cTdR?=
 =?utf-8?B?ZjVwZCtNWEZWMXA5L2pCazdqOGdkRWE2UkJ3R0I5TzFnUlRXZzJIM09SYldx?=
 =?utf-8?B?c0dvV1dGSFhJOWVMNVdpcGFqREtMcXpxbE02cjZGQ1dOdjZkUmpHNXFnb1E2?=
 =?utf-8?B?cEZmdUdUc1p4cjBqc0xsaU56L2JTdnZwUmdOMHE3QjJFTVhzODdqaHlwSi83?=
 =?utf-8?Q?YpNPTM?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NzQxam5zbmpPVkQ2VW1lMFhSbXR6U3hlc3VvbGdONzl2RFRCd3hTR3Vjbi9P?=
 =?utf-8?B?UWFlR3lmYnE0b244aStsOHdsRHpsK1ZYcWRSZVh2SHZNNmhpVldMQlpzL3po?=
 =?utf-8?B?Rks2NVYxY002OXFpR2k5S2U3MzJjTjVER09JNDA4VENrVDQ5enVNbi83VFJl?=
 =?utf-8?B?RHN5aEtrRnJFaWl2bi9ickUxVk1wSUx0bkZ4bE4xVUZzdkxQQ3BMd25sNktn?=
 =?utf-8?B?aEUxaFNGMFFvK0R1cGQ2TThrL2pkTXBoOCtLTWczb1QwQjBKbGkwVGgwaFNl?=
 =?utf-8?B?RDIvQmNuY3UzN3BmaXI2WTYzdmQ5N3VqbGZOUGd3QjlOL3BQK3FuUEhES014?=
 =?utf-8?B?RlpRcDBVNHRiVjh0dHNObFg4R3E4a2UrUkl6Zkw4NlkxYm93dG9VUlZWR2pp?=
 =?utf-8?B?RVVoQVlOZE1TUEVlbWhrQ3RRNTNVNHY3Y1NSclBMcDdIYTJkMm5YN1p2UjR1?=
 =?utf-8?B?dmJCaWNKN3hxRW1qaXZ3NGxJM0d3RDlwYXNRN0dqSGNSaitpVno4UjMzdUdE?=
 =?utf-8?B?dkNKSHQ0aUtoeEVVcmJON0FJMlVvamljOGh6UVZJOW9hSWxxWGdzZ1VjdGVk?=
 =?utf-8?B?bWdGK1hHNE1WKy9KdzVMZHlZd2dUcjdLTE1YODJkRW9QYXBJNCtDQWVUYVJZ?=
 =?utf-8?B?QXR6Uk56Q3ZRY3pRV3RrdTlGR29UNE1iR3A0RzdzRkJwVzFBUFp2Tk04b3lH?=
 =?utf-8?B?OHRkNU5GVEh1RFJLYUl1WStMWG1nd1lLUHBmb3dUdlFISldxdVBsNVF0ZS8v?=
 =?utf-8?B?dlhseFpVNWFuTmdhSGxxVndsVUhaSDF5eXp6T2oveklUejI2aU9JUEpRUnZ0?=
 =?utf-8?B?Ujd6eHl6bGpTcnExTEJFQWNKa0ZrOWlIK2VvYzAzMG94UTZRaGNLK2pQWkZm?=
 =?utf-8?B?eTFDVjlZazQrR2Yrc0NzeGI1K0tkdmp4TWRJdUR3YmNBY3ZjRytOMkQ0QkF3?=
 =?utf-8?B?bDZVWHRySzVMNzY2NU9DbTdpMFl1eElFZVRJOFFTZ2llbEJkUHByQ2J5eC9s?=
 =?utf-8?B?Ujg5ZVNWSXhFcjVDYXdmTFY4R1JUdGhWd0xzMEZWbnI2NjVOOHNobDkzc1Vv?=
 =?utf-8?B?Ky83aDJMY1llVy90dUVZaUlCUURvMktIZ21DTzNLVWRETkFRYVZCK2tGdlM5?=
 =?utf-8?B?TEI1djQ2SHNGOTZkTnJNd3FScTd3L1pwV0RUZktreHBiOWFVK0hXSHdFcXVJ?=
 =?utf-8?B?ZmhiQVJpZDlwM0VJT2VGNU5rM0VTbnZpWGtBZHJQb1BhbEUySUphWXVDWXgr?=
 =?utf-8?B?VjFiN1R3cHVRMDVUaVFBTERWUU13cUFraWFDS0o1alo4eWs4TTlrOXpwd0Vm?=
 =?utf-8?B?QUFNT2E3ZEtPaHZiTWx3Y0MxMHlrSy9ady85WStJT1hEN3JWYnczVmVYMmpP?=
 =?utf-8?B?SmxGQkhLRERNNlJsM0JubklxeWNYOWZTdFpESG5tb3RKTFplOExJUnlmQjVt?=
 =?utf-8?B?azBCWm40VlhyZHZVRjhSbzYzckR5TU04OVREK1JRTmFWek9hYzh3a2krY1dj?=
 =?utf-8?B?bWNjWVhPZVd3dzNRLzcyYkdpWEd5TU1KUnJMSjlFY0E1VW52cy9hdFFnbERJ?=
 =?utf-8?B?b1AvcEcyZC8zTVNRZnlNU0I5Qnd0SUt5UGlIa1BUem5HZ3piTzZRU3lCY2ow?=
 =?utf-8?B?bGhFVlJpbGZUcjMxcEFLUVlxNkEySUp3VFR6Q1oxaTB4QmErdUJxeHZPRGlt?=
 =?utf-8?B?Q2pYSjRValB4bk5VeU9EbW84YzIvY0J6eG00ZXVHTzRCd2M3OUthNGRWQkFK?=
 =?utf-8?B?N3FNTUNpekt1c0szVnB2d0ZhUExnMElnaTcyTXVIaExSVkwwUnlqOUtISm4r?=
 =?utf-8?B?cXB6SHRTck1iY1EvUXRGMTgvYTI1S2dxTzZiVGJPTEpXTGlBaFF2Wld5U09P?=
 =?utf-8?B?c0F1eEUzTCtlR3JPVlExZUl6TnpXMlBHRVBXUEdFaGtQbVZxQWg3YWJlaEwz?=
 =?utf-8?B?aG5MYml5MWNkanV6dkF3TzJXNVdObEw5NjVQbms5WTUxVDVtczMrRERzUG1H?=
 =?utf-8?B?NmpzSnV1aE9SUU02eGwycFdrcEQ2OTE2dElxaURNU0Y0YWs2ZW0wK29oVDRa?=
 =?utf-8?B?TGxLb2pySzE5cHFXZk9MYmN3VlJyLzE2a013MnAreVc5Q0F1NkVzMmNmVkZJ?=
 =?utf-8?B?M2pNbTYrMVhKdXhxZEVsN0N4ZCtMZ1RwZXVwRms1amlXUjE4QVNxR1EwZFZn?=
 =?utf-8?B?cWpBSCtUZ29DUXVKWTB0YnpaOWxvR2tjQkNTMmYwd2grWnh6NjlEc1NURllo?=
 =?utf-8?B?cTVXUE9zSzFqaUU1RnVIbWx3dTNVaFhJN1hTN25TbFE1TlRBQnJ1bXZjYzM1?=
 =?utf-8?B?UXhNeUd0c0NFTWk4NW9pM2xsLytwTG4zKytQaHZkM1NlZjRkYWJ4dTJiSHho?=
 =?utf-8?Q?8rxhhjfP7crkG1gbXSx15Xap4nuTjdjb2f2XM8mszEPTd?=
x-ms-exchange-antispam-messagedata-1: NDvXh8HAwhim/cDl1YQEA56Z1TNPbDyeZKQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A3812B6CBFBD34A97CC02A20675D216@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a2772164-861b-4f6c-84a3-08de41d9fc2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:16:02.7166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCedgLL2cWMdM2Tiuvf8Aq6xWh/MKC91yy6ddISBM9jkg7lqFfE1f/0W8c/L60PziVUtRkdQZSIg0gqH+X+6aKOTqR+8KTj0ySeUd53Rlg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6933
X-Proofpoint-ORIG-GUID: pFpGZ0WdiLSANUi0NmqBloAbtz_rjCNk
X-Proofpoint-GUID: pFpGZ0WdiLSANUi0NmqBloAbtz_rjCNk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfXz3PVRqXKuQBh
 02Q58wPcpgMSgjLp1UN8fsQCvvnmTy1y1e9hJLvSSz8jaX6llygOHg1z6S/K1JsTVypwKvZBONA
 JBs+AKqO/0t4GNpucYZQts4hcuxgO/amYLT1Dh0jyRNPS6Zoj6EtItAxAGFCCUoAXVBtQGaGoAO
 YemJUn1FMtsGqcNqKbsgn58X82hKqoftxcRmJEJI2KYncvYvC6jXiS8E7sJzzyeu2JCIJ65W85c
 5o+FjHe3jiIGUdu3CsFVibsZu2Jr5qQu1WYP65wT5m94rK4yUmHIbyydkI1RElnhlXhAJRQ5of6
 jPezl4if9NujCrVWooDnRghD6ZtZA4ksnXVUd3VrF0XnT5ZTA3pb1BU1Xewgtfhg9k3YLC4hl9b
 JkFjhykmZ6yXKnLxe+vBm6JUEnaAa48j7Ju9vKlEbY86ZS3Kpf1t/9dwKxnb1j6nYMRk3vlyVpm
 ocNtax2mwOf0uvqx8YQ==
X-Authority-Analysis: v=2.4 cv=QZBrf8bv c=1 sm=1 tr=0 ts=694a1786 cx=c_pps
 a=jsJx5cRpnMcsqjM19+T+dw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=pLadhOQfIWX4x_kijgoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAxMDowMeKAr1BNLCBKb24gS29obGVyIDxqb25AbnV0
YW5peC5jb20+IHdyb3RlOg0KPiANCj4+IE9uIE1heSAxMiwgMjAyNSwgYXQgNTozNeKAr1BNLCBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+PiANCj4+IE9u
IFRodSwgTWFyIDEzLCAyMDI1LCBKb24gS29obGVyIHdyb3RlOg0KPj4+IEV4dGVuZCBFVk1DUzFf
U1VQUE9SVEVEXzJOREVYRUMgdG8gdW5kZXJzdGFuZCBNQkVDIGVuYWJsZW1lbnQsDQo+Pj4gb3Ro
ZXJ3aXNlIHByZXNlbnRpbmcgYm90aCBFVk1DUyBhbmQgTUJFQyBhdCB0aGUgc2FtZSB0aW1lIHdp
bGwgZGlzYWJsZQ0KPj4+IE1CRUMgcHJlc2VudGF0aW9uIGludG8gdGhlIGd1ZXN0Lg0KPj4gDQo+
PiBBIGJyaWVmIHJ1bmRvd24gb24gYW55IHJlbGV2YW50IGhpc3Rvcnkgb2YgZVZNQ1Mgc3VwcG9y
dCBmb3IgTUJFQyB3b3VsZCBiZQ0KPj4gYXBwcmVjaWF0ZWQsIGlmIHRoZXJlIGlzIGFueS4NCj4g
DQo+IFRoZXJlIGlzbuKAmXQgYW55LCBidXQgdGhlIGJyb2FkZXIgdGhlbWUgb2Yg4oCcbWFrZSB0
aGUgY29tbWl0L3Nob3J0IGxvZyBiZXR0ZXLigJ0gd2lsbA0KPiB0aWR5IHRoaXMgdXAsIGFzIEkg
c3BlbnQgcXVpdGUgYSBsb3Qgb2YgdGltZSBvbiB0aGlzIGVWTUNTIGFyZWEgdHJ5aW5nIHRvIHdy
YXAgbXkNCj4gaGVhZCBhcm91bmQgdGhhdCwgSeKAmWxsIGNvZGlmeSB0aGF0IGtub3dsZWRnZSBp
biB0aGUgY29tbWl0IGxvZw0KDQpJ4oCZdmUgc2ltcGxpZmllZCB0aGlzIHBhdGNoIGluIHRoZSBW
MSBzZXJpZXMgYW5kIGV4cGFuZGVkIHRoZSBjb21taXQgbG9nIGEgcGluY2gsDQphbmQgZm9jdXNl
ZCB0aGUgbG9nIG9uIHRoZSByZWFsIHVzZSBjYXNlIGhlcmUsIHdoaWNoIGlzIG1ha2luZyBWTSBh
ZG1pbmlzdHJhdGlvbg0KZWFzeSwgc28gdGhhdCBhZG1pbnMgKGFuZC9vciBWTU1zKSBjYW4gZXhw
b3NlIGJvdGggTUJFQyBhbmQgRVZNQ1MsIGFuZCBXaW5kb3dzDQp3aWxsIGp1c3Qg4oCcZG8gdGhl
IHJpZ2h0IHRoaW5n4oCdIGZvciBwZXJmb3JtYW5jZSwgd2hpY2ggaXMgY29uc3VtaW5nIE1CRUMg
d2hlbg0KSFZDSSBpcyBlbmFibGVkLCBhbmQgRVZNQ1Mgd2hlbiBIVkNJIGlzIG5vdCBlbmFibGVk
Lg0KDQo+IA0KPj4gDQo+Pj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXgu
Y29tPg0KPj4+IA0KPj4+IC0tLQ0KPj4+IGFyY2gveDg2L2t2bS92bXgvaHlwZXJ2LmMgICAgICAg
fCA1ICsrKystDQo+Pj4gYXJjaC94ODYva3ZtL3ZteC9oeXBlcnZfZXZtY3MuaCB8IDEgKw0KPj4+
IDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pj4gDQo+
Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvaHlwZXJ2LmMgYi9hcmNoL3g4Ni9rdm0v
dm14L2h5cGVydi5jDQo+Pj4gaW5kZXggZmFiNmExYWQ5OGRjLi45NDFhMjljOWU2NjcgMTAwNjQ0
DQo+Pj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9oeXBlcnYuYw0KPj4+ICsrKyBiL2FyY2gveDg2
L2t2bS92bXgvaHlwZXJ2LmMNCj4+PiBAQCAtMTM4LDcgKzEzOCwxMCBAQCB2b2lkIG5lc3RlZF9l
dm1jc19maWx0ZXJfY29udHJvbF9tc3Ioc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1MzIgbXNyX2lu
ZGV4LCB1NjQgKg0KPj4+IGN0bF9oaWdoICY9IGV2bWNzX2dldF9zdXBwb3J0ZWRfY3RscyhFVk1D
U19FWEVDX0NUUkwpOw0KPj4+IGJyZWFrOw0KPj4+IGNhc2UgTVNSX0lBMzJfVk1YX1BST0NCQVNF
RF9DVExTMjoNCj4+PiAtIGN0bF9oaWdoICY9IGV2bWNzX2dldF9zdXBwb3J0ZWRfY3RscyhFVk1D
U18yTkRFWEVDKTsNCj4+PiArIHN1cHBvcnRlZF9jdHJscyA9IGV2bWNzX2dldF9zdXBwb3J0ZWRf
Y3RscyhFVk1DU18yTkRFWEVDKTsNCj4+PiArIGlmICghdmNwdS0+YXJjaC5wdF9ndWVzdF9leGVj
X2NvbnRyb2wpDQo+Pj4gKyBzdXBwb3J0ZWRfY3RybHMgJj0gflNFQ09OREFSWV9FWEVDX01PREVf
QkFTRURfRVBUX0VYRUM7DQo+PiANCj4+IE5vIGlkZWEgd2hhdCB5b3UncmUgdHJ5aW5nIHRvIGRv
LCBidXQgSSBkb24ndCBzZWUgaG93IHRoaXMgaXMgbmVjZXNzYXJ5IGluIGFueQ0KPj4gY2FwYWNp
dHkuDQo+IA0KPiBUaGUgZVZNQ1MgY29kZSBoYXMgdGhpcyBsb2dpYyB0byBiZSBhYmxlIHRvIOKA
nHBlZWwgYmFja+KAnSBjaGFuZ2VzIGJhc2VkDQo+IG9uIHJ1bnRpbWUgbGV2ZWwgZW5hYmxlbWVu
dC4gSSB0aGluayB3aXRoIHRoZSBicm9hZGVyIGNoYW5nZXMgdG8gdGhlIHNlcmllcw0KPiBzdWdn
ZXN0ZWQgKG1vdmluZyBjb250cm9sIG91dCBvZiB2Y3B1IHN0cnVjdHVyZSBoZXJlKSwgdGhlbiB0
aGlzIGdvZXMgYXdheS4NCj4gDQo+IEnigJlsbCBzZWVrIHRvIHNpbXBsaWZ5IHRoaXMuDQoNClll
YSBJIGdvdCByaWQgb2YgdGhpcyBzaGVuYW5pZ2Fucy4NCg0KPiANCj4+IA0KPj4+ICsgY3RsX2hp
Z2ggJj0gc3VwcG9ydGVkX2N0cmxzOw0KPj4+IGJyZWFrOw0KPj4+IGNhc2UgTVNSX0lBMzJfVk1Y
X1RSVUVfUElOQkFTRURfQ1RMUzoNCj4+PiBjYXNlIE1TUl9JQTMyX1ZNWF9QSU5CQVNFRF9DVExT
Og0KPj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L2h5cGVydl9ldm1jcy5oIGIvYXJj
aC94ODYva3ZtL3ZteC9oeXBlcnZfZXZtY3MuaA0KPj4+IGluZGV4IGE1NDNmY2NmYzU3NC4uOTMw
NDI5ZjM3NmY5IDEwMDY0NA0KPj4+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvaHlwZXJ2X2V2bWNz
LmgNCj4+PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L2h5cGVydl9ldm1jcy5oDQo+Pj4gQEAgLTg3
LDYgKzg3LDcgQEANCj4+PiBTRUNPTkRBUllfRVhFQ19QVF9DT05DRUFMX1ZNWCB8IFwNCj4+PiBT
RUNPTkRBUllfRVhFQ19CVVNfTE9DS19ERVRFQ1RJT04gfCBcDQo+Pj4gU0VDT05EQVJZX0VYRUNf
Tk9USUZZX1ZNX0VYSVRJTkcgfCBcDQo+Pj4gKyBTRUNPTkRBUllfRVhFQ19NT0RFX0JBU0VEX0VQ
VF9FWEVDIHwgXA0KPj4+IFNFQ09OREFSWV9FWEVDX0VOQ0xTX0VYSVRJTkcpDQo+Pj4gDQo+Pj4g
I2RlZmluZSBFVk1DUzFfU1VQUE9SVEVEXzNSREVYRUMgKDBVTEwpDQo+Pj4gLS0gDQo+Pj4gMi40
My4wDQo+Pj4gDQo+IA0KDQo=

