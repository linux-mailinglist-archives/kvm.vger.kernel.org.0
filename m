Return-Path: <kvm+bounces-46284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D98EAB495D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 956527A933F
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA191A9B40;
	Tue, 13 May 2025 02:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pW0ouuTE";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cC7BCdL8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A1179A3;
	Tue, 13 May 2025 02:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102604; cv=fail; b=gb6m37ThSCOzsi60y8TwjP4QyCMuzGfB2ouc4DdpPnwfHlUXZjXHNuZoVSSfZvc0Rjt8OwuQ9jcqn7+Oa87mjWPl/AY7ew9cDRbHQpJmo/Cqm0ebS37RClL746Q5uKF3JZTiZQhprt/pCLJ0LOg7G4GAlt9UEy+hutXa7qE+BA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102604; c=relaxed/simple;
	bh=JzqLrDoTHU04K4n+b69u5Wnuyl2YTI3YYQYvDmlbB4s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bizdok5YsTVt2Y1z0N7HzJqSX4Dz77A0PSHyln1RUWOybknEULGHDUERCulXdaso1ojNHHWkppV7k7kZmDGPFFWwhU1EMsdmzMcE/6o+E/MjtRv/0XpPTiONTdrq2f8sY4i8edXwNBBhRqUn/zzl0x+e6/D2j518TqPJDaFCRJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pW0ouuTE; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cC7BCdL8; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CLB19d022279;
	Mon, 12 May 2025 19:16:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=JzqLrDoTHU04K4n+b69u5Wnuyl2YTI3YYQYvDmlbB
	4s=; b=pW0ouuTESjgy0Z69pgieE0LfoYxebFELKd3ut1j5v9CzK7NQVLqVgeATt
	k7vdj3SavQpQ9aGb+p0BO4RUnAY6q5dgwMjfP/9rGdp1u1V3dBfEkrt+hr6jeKH5
	U3BDOyYvkecmh7Tkw7UyA7+XqAcmRxhICEfaV1p7CSWw+i5v7Jf29k3GNc8VdV6w
	nPUAJiEEV7nwk6dnzjLClKAWO2V7XeyI1W7sMFHRG14iRXyao8NRK/YHaiDd+Q/P
	zxJ3MrxfrGuAQ/d2ol9mN16Ic4bM6ZWxLh4U6dxg8ASao2aoKRKHB2yXSPzpFnHO
	6TCaoRkL7OU39dQnW0Z3IRer3SL2Q==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46j2q8cn15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:16:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ermPoXmQa40JlbxNo6I0OrZhZDInMgIjzmeVOPVKWgEPI3getRT+UDQeCzzWh6rhLyHz5UnuvXj2tuOpy0qxnIgUjLBJnYKrl+0feern5ywcq3ahYm4nsMpGwaGDKer4/gFZw7//vnkO0Htv/5hs1BnDQy9RZMDTgVIueRs1JMymysAjvMHv4itMSfAYZvny1HcRW2gzE2xIIi80exHIbTziVemCUFEgUg3WPdoVeGnXr0QbXZPpl7mXmCporT5ektJYC49Cg8le7NKDpDlmGYEeb20ADV29HBGQdrlVmPih5xPC0P7XOufqf84DlVWsmL5NPLEDTRbzZwo0bv9/8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JzqLrDoTHU04K4n+b69u5Wnuyl2YTI3YYQYvDmlbB4s=;
 b=xsM7mci7hvJM4cC5o4HLOyQt2nCJbAXcnUzKIoUEnWhYsxbdlQUrWY6xFQAOXoSLpPSG+QBijY8FeiAQPDPT6IFE8qQDNVk6Qql5SSdMwXtY6KYLJXucdETejHsxyUccsfaQDDPdCekzVgdeBJiFEf+OZ9jOSxA8uC3O85bQc5koZ2W7vBAa0OrGKiVAQAuoYZvbfs7600BnWAUuRQYpSDmISiTVN57w5+RmYtGdqfGj7MfbpDyMH8d803WvTnuGYeUke6NYMabfvmn37T9m7TtOQ/U+Mn0Ba0+mF3a1+f2jnV/50Y29eT+nqQALpkaSVgRiT0m3HTLZzAghVVYLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JzqLrDoTHU04K4n+b69u5Wnuyl2YTI3YYQYvDmlbB4s=;
 b=cC7BCdL8L2PFx8d+Wvfpe3P5lB3wRR4WXSSog+YIvesaVC3N9fhWxWDMuEMm0tdhGBYzWgozqvxlnXhhSzjYAU5JYH7NCJgK+gRQKiyJ6qeWVWyxRGDcG4uNYPPrIzlw6iQu/8Xb+S+rYBDDCLDIhLT375kiuOer586NudGqMKHHcMXs42J+fGJ5dJCdLWtWp23BqaDkdMcwqSof0Yu4tKszzAX/MN3MmZPzvlvgKpSSVEsth6UVMtjCRzZIg+1kayEBczAz/d/ZpDNlkSpK7h/rY/h+dIEQIufDaQR9B53SlRP19Ds6YJujFfqHxrx+IqiyjFIS640tjEz1PTiMcQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7151.namprd02.prod.outlook.com
 (2603:10b6:a03:290::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:16:16 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:16:16 +0000
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
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Topic: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Index: AQHblFPuD2Myz8OZIk2A34TqIykpjLPPrUYAgACECQA=
Date: Tue, 13 May 2025 02:16:16 +0000
Message-ID: <49556BAF-9244-4FE5-9BA9-846F2959ABD1@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-7-jon@nutanix.com> <aCI8pGJbn3l99kq8@google.com>
In-Reply-To: <aCI8pGJbn3l99kq8@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7151:EE_
x-ms-office365-filtering-correlation-id: c8620a0e-cb83-4921-29fb-08dd91c4247d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?eXlycTBia2hBRzFCd2Q5K1RqU0RrWTB0aUJnT3NpUEJ4ZXhQS3pLNWRvNmZj?=
 =?utf-8?B?RVBIUldIVWVxNTBnWHBjbSsyK1dLSHI0NVU0S096Tk5RdXFMK3ZhL2xQTk5O?=
 =?utf-8?B?cXgweVRFcnlmbHYwdW1yWm4wV3NrR3l5MU5JcFhXMjZ3RkxMSFVwa3ZQUzJ3?=
 =?utf-8?B?MlhvUHVJTi9MeFJSQlUrOWw4M2NJSnJxMC8xNGVIU2JVVnByRXI2cUowZXJo?=
 =?utf-8?B?ZVMzNStUUjMxb2UvVysvQ2NOeW1aMVZaeDIweFNTNkRMUndHU3lTa1FUaU1Q?=
 =?utf-8?B?VGhYdzVham4yWXFvTnZoZ3cveFpXM1BGcEJBcCtsYmsxK0NrOHdRTmdHMWk3?=
 =?utf-8?B?QlJKRDdYTVBWUFJHNXUrZnZtS1pHQVB0RTFQRTBBeWs2NU9Zb2ErWkdwN1Nv?=
 =?utf-8?B?S2Z3L3JFaUxmcUVBb1ZKN1crNnhqYUZuNVRDbHZTLytuVVdaaFlFNFhtQ3NP?=
 =?utf-8?B?Z0VCZnowZTkyRlo0UzJTVHRLbVBWYUMzTTBkakVmMmxNZnZmM3VmbFZkdi84?=
 =?utf-8?B?dXZTbG82LzNCRkxvWHlZUUM4TC9OeThOQWozeW44MnN3Q0h2OU1rSVRJbzNo?=
 =?utf-8?B?b3lVMXNiUDU4NmJOdXBCRUJiZjNjamxwRlRYRjIzUXVCU2cvbmlqOEdPcGVy?=
 =?utf-8?B?UWE5cXhHL3JGcVNmSEYyd01sR3RtZ0h4RW5FbCtwTmpFb1A5YWlsWnNTUysy?=
 =?utf-8?B?WWNpTnZCSTAwaTU4NFJoR1RJb09BcGY5RkJob0xacENBNDNyWFB3WVFKdE9R?=
 =?utf-8?B?Y1VoMkE3cWZjT0w5MXNBL1lpVWRZNVg4VzFmaEY3NTV4a2FWL3QvTWF2a2lY?=
 =?utf-8?B?T0dhaDRjT3BqcUFLTXhHYnNNeVhaZVVyaWZLNGxhcTZabVZZY2lwNlQ4UmVN?=
 =?utf-8?B?OVpVSDZtRERyM3Y5Rit2MDQ2ZVUzQ2NFQm1IY0ViYzQzbnZlMHZkQjVTYTE0?=
 =?utf-8?B?SlNOMVMrelZmR2VEbUFTYytNZ3lWMnJhSC9VYnRIZDFvUnFMSGxSSllqSzFF?=
 =?utf-8?B?WTBBMUk0N1lxMHhHQ004MDZSWFluYmVMb01UVlVOSVByRFcyTnNNd2R1VFJB?=
 =?utf-8?B?WXpmR3I5bnFncWNnNVVIMFVnbDZBbDgwUW5uR2ttdGl0cGMwZzJBMFA1V0d3?=
 =?utf-8?B?Y3lZYjJCWWh4Q3JyVHlxQVpQbUJXYWc2WXB2aTlFL0x4SUk4azlVVnVqK3lq?=
 =?utf-8?B?WVkyYm1BeHd3UnE5WENoN3g3S1JIQUlSUWlSVW4vMTR2MWZnd3l2R0xObExq?=
 =?utf-8?B?bEVXNTN4QitrY1NZWUJkK0V2WGVkZnEwQW5Vb1dNblBMdHFxdmRoUmRJUisx?=
 =?utf-8?B?eU9jWEVlaHRSb1dJODFMNURsbUZ4SVpjZm5pdCs3QVlnbHhjakR2MkFHMXUv?=
 =?utf-8?B?bVhRK0U5WFpDSzFrNThzdXg5TjRyYnZpcSs2VHR1dCtsMElPcW8rSUU1enZ6?=
 =?utf-8?B?dVNLdkdLNG1ZckZHWThvTit2Q0pkTjBTTitTUEtXR2I0Ukt1aW1nK1I0bHFn?=
 =?utf-8?B?b25lbUxqN2hONnpHeXBCU0xiZkp2eW5SZ2J2WHYzZFQ2UTRCV2J4MTVrelpy?=
 =?utf-8?B?R3QzWG9JcVVIenBwdmJWY2tuSWVnZGFxaW54WEE3WUxkcE9lYkZla2V1eUhw?=
 =?utf-8?B?MDhEaVNXNXhQNlV4OEhvM3RFUFUwL3dTV21ldFZUWkU1djJHVCtxNWRzejF3?=
 =?utf-8?B?QWdacTJlcTNub1BUcFNjZzJzR0xtMTFCZ0NPVEdkU092RWVVUTlodVIwWnUr?=
 =?utf-8?B?U3d6bEtLTUhlWVVBSHpNOUtjQ3cvS2xzTmdWMGVINUJROE9waTVQUnh4c094?=
 =?utf-8?B?ZytldHJhNzlSd1RCbk9hZHZZYnBId1JZVHJtT0dGWmVWUHpWZE81TzlwbHVx?=
 =?utf-8?B?U0V0bzhHbEtIeXptZXhvRzNEYWZDUEVhLzdvVVd3VnJwZFNvVUJCaUxRQkpB?=
 =?utf-8?B?ZTUwUXg0aDJtTHlWdUYyaTIrVHp5cUlpTXdiK09BckcvTmJEQkdlYUUzNi9x?=
 =?utf-8?Q?/SMm63+m+rF/6+4mKid2ON4PIUQlPE=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UzYxTzl4Y2d3bm5jUGdtaFZCTDVoYWtVQU1qQlFEZFg2dXVtL3pCdUxmL0Mz?=
 =?utf-8?B?TUNNZDYrbGdKQkU2U0Fqc1RoMjYvMEpXb04xbkZUQStMOEtVcjUxdmhYcjRS?=
 =?utf-8?B?N3BZMVoxem1OcEN6UDJkcFQ4VHlFZGtLMER0b09acXoySnpWSlpCU05NMkpL?=
 =?utf-8?B?WTM4cit2bFpWWkFGVlRWSUlHbnAwYmoxcDl4RFZqY3hCbE9yNVZPV21YZ1dn?=
 =?utf-8?B?elBBeHB3ZTJyeFgzVTN4S2xTdnlGWEJlWnVOMFBFUUFsNnBVbmNuclZvbXBz?=
 =?utf-8?B?YjNuN2Nqb0FaVFVBTmJlb1U0OEJLc01QN1l0NkFFdE41dVZhZVgva1lKWHZl?=
 =?utf-8?B?cUVPSGtoQUsrSDI4SzZ1WG8vRlI5OXZpSEMzUTZoWnVaOE8xdmNUb3VDd1Iy?=
 =?utf-8?B?YlVPYmRMSzJoa1JyNTNraUhocGtoVDNRUmw2YUE5N0o4SER5WElUOUlOdklE?=
 =?utf-8?B?Q3Rudk1sWUFocElBeksxMFFaaVd1MG1pZVhCdFVJMzZJcE1COHdXUEFoOWZt?=
 =?utf-8?B?Vi8wYXlucUVmYXp0WFFrUTZpNU5KWWdSaGFlcW1ETlBZVjl4bzRzUzh1QVNq?=
 =?utf-8?B?ZDhSTlFqS3pSeTBkRXJQdUlpbVNXZ3JpaVdjL0FpYmZRQTM5ZmFWdWpzNm1O?=
 =?utf-8?B?Wk03OUd3QU5LZlNUamN6MXZub3A5Y0dUdlljT1ErMzIxaDV1VTlZR01pSkNq?=
 =?utf-8?B?R0RMWnBwVXcwL1JLeFhjS0VWdkk4cGNyODBiY0tML2ZzcWxMZmsrYng2ZWEx?=
 =?utf-8?B?TmhMRHhLcTNDUlZqaGFCa0Q2NHllTWlhTWNYRmpwaFhYcTRpbDVpS1RuWEs4?=
 =?utf-8?B?NjN4dVcxRHdxSmw5TFJmOGJHY2pmZFhUWng0U09XTm1SRXhIVnBvR0hwWklo?=
 =?utf-8?B?S2F4bnlxTG0wUEhUTlpoQlVQU1FyL2RzclNYR1kzQkpHN0xLbE15Qk12NEdm?=
 =?utf-8?B?WkM4anIyZzVsTGlhNU50UDZyd0VXM0hCZG4wb0RwUlhTYWh5SG0zdmg1RWd0?=
 =?utf-8?B?TUhiTXc1dG5XN3BCdFBrV0JtaDVpeEJxSVMvR25nWE9lTGtacTYxWjVWa0dy?=
 =?utf-8?B?ajc2SHRjcElia2dwUS9pMmJ0a0ZEZWhVUEdFTGlVSURyaDVoSG5xUlAzTVdO?=
 =?utf-8?B?dG1WL3RSS2gyK3N3bytaZ09TS2xBLzFRem04SHZmbnhPYnNiSm16cVhHTEJM?=
 =?utf-8?B?R1pKQVljWmlRK1NidnhvdC9LbnNMNGZ2NjlyT2tucGdBZTlmM3NCZmdnQ0lh?=
 =?utf-8?B?dlMxYjFjUE8rQVEyV1NHVVRnWTdXWmNXYThuYUEvaG1IWXVQMkc0bnlBdFg4?=
 =?utf-8?B?TkVHNmJGQ2ZXbGV4TVZqRHZSMzJ5OUNucmdUMno4NnR3RHlMQThjeGs0eHg4?=
 =?utf-8?B?SGJGcUpxZGoxczlwREJ4bXNzZFpVcmFGZlIzMUI4aUVXTUphSE15T3daUHp0?=
 =?utf-8?B?TVl6M3J6cFNoUVhrbFZzRU9YYnZFY3RsVUhTTDVrdEtadzNKRjVFV0VYM1BV?=
 =?utf-8?B?QWZtVktyTXVLRFBmclAxYjRBdU44UzVBc0FIZnZVdlk2NFJjZjFBcW41eEpR?=
 =?utf-8?B?eU9UaW9WUEJqS2c0QlRZLzNZWURtTFpyMGZYNXBqdVJKS1VFTXJ5R0dyOHNE?=
 =?utf-8?B?TEhxMkxvZkYvZ2tYZm9XeDZvSDVBckJCcUxISnQ2MzJnL0ZPNEY0bENOb09t?=
 =?utf-8?B?YVBKZ1kvOU00WjBIa1lJaGdzM2JqVzV0Q1NBUEorVGxxdGM0cm1XeXd4akNi?=
 =?utf-8?B?cGtuUW9LcFpUdXpVc2pWem5BQmtsS01sYUJ4dkR1emYxUHZLRXd4aTlCZlp5?=
 =?utf-8?B?dW8zdzNHSlBYMDdTN3VhQzZPMFpiNmxhVkxhenlQalQxelNUZ3hrY1QxQ05Z?=
 =?utf-8?B?V1hZTnJNd1dESHhiWlZPbDdCam9YaW9mb1c3MCs1RFMwc0lRdjZQYmdLODdO?=
 =?utf-8?B?NUVLMSsxODFuRUtGa3N6NS9aSXVCaWtFcFZENiswL2RIanB6ei9peHJXL1pa?=
 =?utf-8?B?OEFudDl6bDhIMnh4WGREUGUxNVR4bE52R0dyOFAwNWx0LzdCZkRkdXh1N29P?=
 =?utf-8?B?MktKeUdMbnNxTFllMnJQYkZEb2JrOFpZMmo2UDd6Z2oxNHh1RUdScitwUlR1?=
 =?utf-8?B?amZPT0xaRFpZOEwvcjlzdUxtVjMxU3FLeEtRcCtlTGk4YVM2VW4vcUQ4VWMz?=
 =?utf-8?B?dURkblFTSmkvVFJ6ZUJ5WDk0L25OcDhtT1dUTTV4OUQ5dGNRekdMaVVKS0tD?=
 =?utf-8?B?WG11UDZXSzVPbzF1R1gvcjVWNkxnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A596158BA2D424EB658969A5942C654@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c8620a0e-cb83-4921-29fb-08dd91c4247d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:16:16.8217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: igXXkz2m07W3yTGw6yWtQn5NJeHPCB0GwIMVmdyplA0MB5XWEgwc5TXzzjK6gwLS60or3lzOCfd259DIDZWymljff3G30S72fJO3JMFe5VU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxOSBTYWx0ZWRfX1/P/XRODLkfV IahjZIp1dKF7WlTw/jMVFk6+Iv3Exfj6XfFISik7uK0GjLR7LUMFI8eTba9x/RYhf2XK0HfJeXI zRI/ojUvC2YX2j3l+29pYpF6DXW8SRYGX85UkpmBQAL9DtUN67VtLB65lbPvAVSX2bPL/5bfBxv
 mmlzMqMnMDhyn8JGzoHTJll9tITD4znZasIqd08y+pTOCZkTlEw+JleOlk/KM3Cwa7yU+aDvTMI CGSbOsu30cMCNHu3AZXZMQzyP2aa0wAFNDxxHZ+3XLrYbGrz+aJmm3hle+1lQWXV2Z07o5rJrlR ldQ83Ug2TnhmGKp/8cFFZjDHBZiJhyXeHMy1NH7pjBqNqj569IrZzR9YTPGod9rmHX22gevUzqn
 xUs9iqyu1MRguR6erZTjlyfMHoKdAMEh+kTrXbO8rfEWhlWZIl75xqM3QfuieLJWdu9w1jbX
X-Proofpoint-ORIG-GUID: KZOdmM_tcbhHOfHLIZ4wEyUNCDgNhxnM
X-Proofpoint-GUID: KZOdmM_tcbhHOfHLIZ4wEyUNCDgNhxnM
X-Authority-Analysis: v=2.4 cv=X9JSKHTe c=1 sm=1 tr=0 ts=6822ab73 cx=c_pps a=Odf1NfffwWNqZHMsEJ1rEg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=S5DzxORFGov57kMQ9zkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjIz4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBBZGQgbG9naWMgdG8gZW5hYmxlIC8gZGlz
YWJsZSBJbnRlbCBNb2RlIEJhc2VkIEV4ZWN1dGlvbiBDb250cm9sIChNQkVDKQ0KPj4gYmFzZWQg
b24gc3BlY2lmaWMgY29uZGl0aW9ucy4NCj4+IA0KPj4gTUJFQyBkZXBlbmRzIG9uOg0KPj4gLSBV
c2VyIHNwYWNlIGV4cG9zaW5nIHNlY29uZGFyeSBleGVjdXRpb24gY29udHJvbCBiaXQgMjINCj4+
IC0gRXh0ZW5kZWQgUGFnZSBUYWJsZXMgKEVQVCkNCj4+IC0gVGhlIEtWTSBtb2R1bGUgcGFyYW1l
dGVyIGBlbmFibGVfcHRfZ3Vlc3RfZXhlY19jb250cm9sYA0KPj4gDQo+PiBJZiBhbnkgb2YgdGhl
c2UgY29uZGl0aW9ucyBhcmUgbm90IG1ldCwgTUJFQyB3aWxsIGJlIGRpc2FibGVkDQo+PiBhY2Nv
cmRpbmdseS4NCj4gDQo+IFdoeT8gIEkga25vdyB3aHksIGJ1dCBJIGtub3cgd2h5IGRlc3BpdGUg
dGhlIGNoYW5nZWxvZ2UsIG5vdCBiZWNhdXNlIG9mIHRoZQ0KPiBjaGFuZ2Vsb2cuDQo+IA0KPj4g
U3RvcmUgcnVudGltZSBlbmFibGVtZW50IHdpdGhpbiBga3ZtX3ZjcHVfYXJjaC5wdF9ndWVzdF9l
eGVjX2NvbnRyb2xgLg0KPiANCj4gQWdhaW4sIHdoeT8gIElmIHlvdSBhY3R1YWxseSB0cmllZCB0
byBleHBsYWluIHRoaXMsIEkgdGhpbmsvaG9wZSB5b3Ugd291bGQgcmVhbGl6ZQ0KPiB3aHkgaXQn
cyB3cm9uZy4NCj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29obGVyIDxqb25AbnV0YW5peC5j
b20+DQo+PiANCj4+IC0tLQ0KPj4gYXJjaC94ODYva3ZtL3ZteC92bXguYyB8IDExICsrKysrKysr
KysrDQo+PiBhcmNoL3g4Ni9rdm0vdm14L3ZteC5oIHwgIDcgKysrKysrKw0KPj4gMiBmaWxlcyBj
aGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPj4gaW5kZXggN2E5OGYwM2Vm
MTQ2Li4xMTY5MTAxNTlhM2YgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5j
DQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+PiBAQCAtMjY5NCw2ICsyNjk0LDcg
QEAgc3RhdGljIGludCBzZXR1cF92bWNzX2NvbmZpZyhzdHJ1Y3Qgdm1jc19jb25maWcgKnZtY3Nf
Y29uZiwNCj4+IHJldHVybiAtRUlPOw0KPj4gDQo+PiB2bXhfY2FwLT5lcHQgPSAwOw0KPj4gKyBf
Y3B1X2Jhc2VkXzJuZF9leGVjX2NvbnRyb2wgJj0gflNFQ09OREFSWV9FWEVDX01PREVfQkFTRURf
RVBUX0VYRUM7DQo+PiBfY3B1X2Jhc2VkXzJuZF9leGVjX2NvbnRyb2wgJj0gflNFQ09OREFSWV9F
WEVDX0VQVF9WSU9MQVRJT05fVkU7DQo+PiB9DQo+PiBpZiAoIShfY3B1X2Jhc2VkXzJuZF9leGVj
X2NvbnRyb2wgJiBTRUNPTkRBUllfRVhFQ19FTkFCTEVfVlBJRCkgJiYNCj4+IEBAIC00NjQxLDEx
ICs0NjQyLDE1IEBAIHN0YXRpYyB1MzIgdm14X3NlY29uZGFyeV9leGVjX2NvbnRyb2woc3RydWN0
IHZjcHVfdm14ICp2bXgpDQo+PiBleGVjX2NvbnRyb2wgJj0gflNFQ09OREFSWV9FWEVDX0VOQUJM
RV9WUElEOw0KPj4gaWYgKCFlbmFibGVfZXB0KSB7DQo+PiBleGVjX2NvbnRyb2wgJj0gflNFQ09O
REFSWV9FWEVDX0VOQUJMRV9FUFQ7DQo+PiArIGV4ZWNfY29udHJvbCAmPSB+U0VDT05EQVJZX0VY
RUNfTU9ERV9CQVNFRF9FUFRfRVhFQzsNCj4+IGV4ZWNfY29udHJvbCAmPSB+U0VDT05EQVJZX0VY
RUNfRVBUX1ZJT0xBVElPTl9WRTsNCj4+IGVuYWJsZV91bnJlc3RyaWN0ZWRfZ3Vlc3QgPSAwOw0K
Pj4gfQ0KPj4gaWYgKCFlbmFibGVfdW5yZXN0cmljdGVkX2d1ZXN0KQ0KPj4gZXhlY19jb250cm9s
ICY9IH5TRUNPTkRBUllfRVhFQ19VTlJFU1RSSUNURURfR1VFU1Q7DQo+PiArIGlmICghZW5hYmxl
X3B0X2d1ZXN0X2V4ZWNfY29udHJvbCkNCj4+ICsgZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllf
RVhFQ19NT0RFX0JBU0VEX0VQVF9FWEVDOw0KPiANCj4gVGhpcyBpcyB3cm9uZyBhbmQgdW5uZWNl
c3NhcnkuICBBcyBtZW50aW9uZWQgZWFybHksIHRoZSBpbnB1dCB0aGF0IG1hdHRlcnMgaXMNCj4g
dm1jczEyLiAgVGhpcyBmbGFnIHNob3VsZCAqbmV2ZXIqIGJlIHNldCBmb3Igdm1jczAxLg0KDQpJ
4oCZbGwgcGFnZSB0aGlzIGJhY2sgaW4sIGJ1dCBJ4oCZbSBsaWtlIDc1JSBzdXJlIGl0IGRpZG7i
gJl0IHdvcmsgd2hlbiBJIGRpZCBpdCB0aGF0IHdheS4NCg0KRWl0aGVyIHdheSwgdGhhbmtzIGZv
ciB0aGUgZmVlZGJhY2ssIEnigJlsbCBjaGFzZSB0aGF0IGRvIGdyb3VuZC4NCg0KPiANCj4+IGlm
IChrdm1fcGF1c2VfaW5fZ3Vlc3Qodm14LT52Y3B1Lmt2bSkpDQo+PiBleGVjX2NvbnRyb2wgJj0g
flNFQ09OREFSWV9FWEVDX1BBVVNFX0xPT1BfRVhJVElORzsNCj4+IGlmICgha3ZtX3ZjcHVfYXBp
Y3ZfYWN0aXZlKHZjcHUpKQ0KPj4gQEAgLTQ3NzAsNiArNDc3NSw5IEBAIHN0YXRpYyB2b2lkIGlu
aXRfdm1jcyhzdHJ1Y3QgdmNwdV92bXggKnZteCkNCj4+IGlmICh2bXgtPnZlX2luZm8pDQo+PiB2
bWNzX3dyaXRlNjQoVkVfSU5GT1JNQVRJT05fQUREUkVTUywNCj4+ICAgICBfX3BhKHZteC0+dmVf
aW5mbykpOw0KPj4gKw0KPj4gKyB2bXgtPnZjcHUuYXJjaC5wdF9ndWVzdF9leGVjX2NvbnRyb2wg
PQ0KPj4gKyBlbmFibGVfcHRfZ3Vlc3RfZXhlY19jb250cm9sICYmIHZteF9oYXNfbWJlYyh2bXgp
Ow0KPiANCj4gVGhpcyBzaG91bGQgZWZmZWN0aXZlbHkgYmUgZGVhZCBjb2RlLCBiZWNhdXNlIHZt
eF9oYXNfbWJlYygpIHNob3VsZCBuZXZlciBiZQ0KPiB0cnVlIGF0IHZDUFUgY3JlYXRpb24uDQoN
CkFjaywgd2lsbCBmaXgNCg0K

