Return-Path: <kvm+bounces-65815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 18F41CB844D
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 09:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E2553063178
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 08:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB77630FF3B;
	Fri, 12 Dec 2025 08:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nV3wywRo";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dA7V2tB/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78660285CAD;
	Fri, 12 Dec 2025 08:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765528078; cv=fail; b=tMYcZfbvmxcwqxXWcRIwcwjX7tNH8DcG+CySD1xdLbtSVRFkwOqKKGZM5tjc/Ey8EdnozX7xairQLj3NwzKtGuz2gR623KsqLX8PxFCGr1ZoU4rwAkGrQX2lvBCbYw6RNAkPE0l58E1uCkVyjrvrRpQg0KDqvtkv8LOGUN1zErc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765528078; c=relaxed/simple;
	bh=aAZCf5k+9FitRPA6z9gqOFpwRwi3/Ch/x5pAeu+Khrk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zyz8HnhAvKBMzLJ3zNVYwBfGIYRLifZ3lFP/TrHQT7VrRvWyF2ZscVYYdR6OVG8pQNy8qMo0m2uroY3wy1QlQEkDWYQPW+oIoby/gNskzcBQSV/jo4Ntjz/IPpsEozzQoMOeCrMw567o+b4hD1m9RJwicERo+F8ow1vU5KFIFiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nV3wywRo; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dA7V2tB/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC09gbt3769495;
	Fri, 12 Dec 2025 00:27:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=aAZCf5k+9FitRPA6z9gqOFpwRwi3/Ch/x5pAeu+Kh
	rk=; b=nV3wywRo9boOTh0BfjWj26m10Fu7OpEAYpoCXZSeQOFQDAwmc8xWyl6C/
	GNUUDjBj9CF+ucF7A/R/alEZilbN64Ocrfh4ilL2HftyPwp8sKROO7CBuUNKDHde
	TqupnW+apk0mavMEas9+8TuH320qkGjL3wl1sE9FmXETfnHqmOLIbY6zFDO7Bjdp
	Eim6rHHciO8EufTSAHrArjtWk+iJ43fay9T7GAeqHtMlYplbap49G/rkMelLBQDw
	bRCl3slvC2LJ0++Wc+BpGV2Zpl7DI3BmLahJO/VwD6IQZwAoR7kzBtJ8KBl9Sx9q
	n/MtKPkC6Om7Mxe6AyMIk7Ns4HVWQ==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022091.outbound.protection.outlook.com [52.101.48.91])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b0890rrsb-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Dec 2025 00:27:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VV9BW+hehhpgro1/CIE1Up4A5iTy/F6PLAKcGYHle/EMLPVDXMtlCf1JwsZUm+8zVk2l7lvvxZzJ3nVjWv4GEyZwTdADPio02enWsaCf1f2TlEAqJBI4OdAhM4YwI9qxDGCUXY8z85YAQ0N1WPkcfY2oSVINnT3Le0WWm1AL4xLTBNi8R5xgKdf/x9U5OC9nxSdq+na+RqeMWmHa8pTjbLDLe0ZnGtG7oc4H9V9JUqzfYyc/EzHh1ZczRlJbL3YWZaO8SF0KztziG5CnmndVoFdY8d6RVQ+XWdyYwvcpDl4gjIr2SifwArFvOBtjCQ15MwtulMBmxBux65AEKq8Zqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAZCf5k+9FitRPA6z9gqOFpwRwi3/Ch/x5pAeu+Khrk=;
 b=DLPG3jTjshtZzSIZE7iwFvhco/P6QdXZr3P0q5q57+vSNApDC8uiQMAdUypwRoDKUH5kuzvy9pUtoxRG/ehAv9EILxFh1fWN6EZkNfZWIiwU58Y7vdrEqODX6I65smJZcL+GJuV1J6Su4HQEwU6MHqcQk4ccJs2T8zPD7F+yK19OjDmO8+sdkr/alTD+kni/L1oejgRK74VWrLFiPsyLvgNzRNpGkBqIN2SfyLBvscsA+JifMTAD7VI/1Bj9zW5yfKOPLssX8mPBTxlhoxHt41oGzUyM3AS90LGWTWCm9IWIbKioZWL3PVNjf0rECfG3X1wxTCbV1Z9Z67lY1SO2Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAZCf5k+9FitRPA6z9gqOFpwRwi3/Ch/x5pAeu+Khrk=;
 b=dA7V2tB/iqv/fqN+sDK0kGIszANcaPtIe50/vvhD8PfSdV+QVvAtCdWwFbOfeSsjq7hRrl9t6LSSlb6VG6NskTLNOzO91Q+nbqn670g9vetR4jzjjFh7i+aGSA2qx0ifDqoPPdFh8mEwWPSt2+W5J6qENVcAfTtBu2kW2cGnVnzJYgF0DF6BhHTWpNKLT/nd/2ZETLXOXkoyYsAj249yi5y3mwAt+W2GkTzL5x9AZpEVYYppEpLCCGyRdEHekemfGP9puzmgrI7BXUTUElCoA2G9IbK4hTCaO0Y1dDAF/V3bhkV7IVQErqMFTrQ6um0mpzsoFW3qW46brHZQ/7Jv1Q==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CO1PR02MB8651.namprd02.prod.outlook.com (2603:10b6:303:15e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.10; Fri, 12 Dec
 2025 08:27:23 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 08:27:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index:
 AQHcao1m0m+Je6bySUSdnhU8EZf0EbUdH8CAgAB3S4CAAAaPgIAADJeAgAAAsgCAAAI+AA==
Date: Fri, 12 Dec 2025 08:27:23 +0000
Message-ID: <AD54CBB2-98C1-45CD-B9D8-FDBF9892B84F@nutanix.com>
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
 <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
 <B45DB519-3B04-46F7-894E-42A44DF2FC8E@nutanix.com>
 <e0378e55610bf5431e78a090501948a8c12c73cb.camel@infradead.org>
 <C343BC29-647C-4F60-82DB-2A21B8B21EC2@nutanix.com>
 <b48116fac4723c6884b300a599b39f946f361ef8.camel@infradead.org>
In-Reply-To: <b48116fac4723c6884b300a599b39f946f361ef8.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|CO1PR02MB8651:EE_
x-ms-office365-filtering-correlation-id: c04dd36b-f731-4073-a102-08de39584649
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YzgrNEl4QkJlaERxWlFNaHNKeVl4WGFvRUI2Y2w4VVRNZDdIc2NGOGpEc2Nh?=
 =?utf-8?B?dk1MQXFnSUwrWm1GekFha2RobXZIakxrMjJDbmZDbW5LSFBaKzJuWFVJTHA4?=
 =?utf-8?B?QmlvM2hpb2RFQzdKRm00eDBTTWJ4aXZ3bDBGTGpDcjFHTUVld1dJbVlJeXdJ?=
 =?utf-8?B?R1h3QklmY0xzeWc0ZHI5WDNFWm55M2s0b1RNMUs5TEJBV25SNnVkdUptdy9K?=
 =?utf-8?B?cEltc0ZTZ1VpQm53MW9ramhicWVNMTJ6cWZkaDhNSFh1Vy9Fb1FuekcwQWN2?=
 =?utf-8?B?RjFaVG4wSlNNSWJvTHYyUkR1QS8zM05yazFCdHNFeFBYYm5XamxJUmY1Tjdr?=
 =?utf-8?B?NjdBdWozeVYxdS9SOElHSmpzZ09TTit0MTJNKzloVVdOTmJOaTBWOVBVVUxR?=
 =?utf-8?B?TS92MWs5cTA1YWtEWjVLRUNnZEZ6OXFUTWNCQlpFYitvT2czNklneWpobDJz?=
 =?utf-8?B?WnFLcCtmUzdRMW9MN3VoN2NxL2xucjVYNjBMSFFiK3dsUWUxMkNKRHRoT1pY?=
 =?utf-8?B?MHM0cnlqb21hYWFGRWRBK0ZsLzB1Q3ltRlI0ZHFzR0JhMDRGZ2ZzbUNRd0pu?=
 =?utf-8?B?WXRxNmpNSEhOYngwZ1hLdHlHbGxHUXFvUm03M1paWFFNN2VtdWpVdmw5MWpk?=
 =?utf-8?B?Qjh2djc3ZXA5RndNTEVyYmZZbW1saFFZeitGK2FJVzJoMitJNjZremFjTjgr?=
 =?utf-8?B?ZGdBOEFZczh2ajJ5aVB2ZmxDenlzbytBUzIyZStibDhzZ1pha0xMNU1WY1Rr?=
 =?utf-8?B?VFR5QkVxYS9yNjZRSlVqUlV5WER4QmU0UnhXc1JyREpXb2FDeERNeXJqQmdo?=
 =?utf-8?B?b0g3WTdmeWdnSzM1MFF5SjVMaEJKa2VlTzJ0emplTWV0SVk4OUd1WndjL0Za?=
 =?utf-8?B?aGJmcUUwcW1tT2lJdGZjRGVaNHA4TUZhR1RzQ2dmc2lNcm5Xdmc1d0pzREk5?=
 =?utf-8?B?a2tHNTRhTEwwNVMrWGNMWlFmd3pVd2Rlb2RORDIzcjFjdGkyTlVmVnFQK0lk?=
 =?utf-8?B?OStVQVdrSHNkVktKcDhDWFd1QVdjSXlyQmFoTm9qR2s0UklvRnJXUXJrSDlH?=
 =?utf-8?B?K2lWTXJSbDB0ZmorTld5KzV5aWpqcTd0OTRTenVlNFc3azc2dGhwL2E3QzVq?=
 =?utf-8?B?MXk3bjNra1dNanRxUm9JcTU0dXZZbDM0WitZWURrd0tVWmdCcWNteDZQeTJO?=
 =?utf-8?B?QUEycXB2RFZ2N0JRaEZCZ0c5UHdkNXVseUNCRllNWFdRWU5abjRwNyt0YzVm?=
 =?utf-8?B?MDBXM1VaanN6citrdXgvaHpjeU1hMnhnSjIrVmdpWjJpd240aDBQWEhFUldV?=
 =?utf-8?B?akd5UmtQb0lCSmQ0MHlPRERiR0pPZU9iK256T2FqQk1Lb0tMVElpNC9SM0Zt?=
 =?utf-8?B?ODdSakZlODRhQnEzUE83dzBobGdrZjVUdlVTY3VqMllneUp1dFZZUUJjQTQ5?=
 =?utf-8?B?QXBlb2sxb1pIYW5tWkdaWnRTa0IzV0thTTUvc0xtcnR5YTNXa050ZTliY0JW?=
 =?utf-8?B?NHVHR0I3N0xBbVNHdmJQUDYvckZVWm5WaVJ1cWJIRVR1YnhsVitTbzJlb21v?=
 =?utf-8?B?U2tNMktYSTkvTU1XQVYrYWFrVjFhdWdoeEExOFExNkhFRldBQUxBblptNjZK?=
 =?utf-8?B?UFVsYS9WWFVIKzQ0R0h6dGxPTWg4VHZlOUtIZ1NLY2o4eTRKYVZvQlFiZW9l?=
 =?utf-8?B?QnhaVFBJcnEycUU5Sm42TnpPZXNyYSthMnFpeWxZV1NXUkNLQm9Dek0yT2sx?=
 =?utf-8?B?VXhYME1QOVI0bjliV3R2WjNkWmpuRllQYW5Hc2tTdFlaRm8xSThSYUo1RXBU?=
 =?utf-8?B?S0JQV3FLeEkzRWIwM1pCMVRYRUk1dWROMTBKR2wzN21RWEhOazNrR05kNnNI?=
 =?utf-8?B?S2t1cnNjYzAxV1pJc3FjUU9vMHF4czRsT2NtRlRWRTVSdTRKZUpkRGhFRTBi?=
 =?utf-8?B?R0kxNlNWWGs2aXZwWDc4YmFLZGJ5bXh0Sjk1ZUxDQ28wUm5yOGdvbFRPVnR2?=
 =?utf-8?B?OXJlaUR1M2tzMXFlbzRWSThiSytoMzRvMUpwVHVQMTZFL1BTSWMxSjloWGp4?=
 =?utf-8?Q?s2iMyX?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cE05TmttSGUyRDRrR1g5aWE5Nm0rNkduQ3BhS3g1ZENxMFdGSFJ6empMQ3Qw?=
 =?utf-8?B?SUFZbjlENndTdjl5Q3dCcVpmTWdqTlJNdzFGNVlJQXlTbFVqMjNFSkpqcWp6?=
 =?utf-8?B?VjZCTlBNQ2E1ZlFRYjFDNjR1dWRhbVFDVjdjdXY5YnFnVExQVHF1RjkxeEFq?=
 =?utf-8?B?WHBvejFObFdqN0MzaVRVeEpzMGFIMFkwd1gzcjMwbHZGYlJLN1pTMlIzSVF4?=
 =?utf-8?B?Yk5zZVZ3TDRVc0hxeW1EK0J0c0l3dkVzMFA0YzJ0d3ZpY3BheERYYU1xMHpP?=
 =?utf-8?B?eldrUzZTSGg4YmtzdndMa0Q2Tlc0NWJYcHRXQ2txYzNMRUhORCtra0pScGVk?=
 =?utf-8?B?ZG84WFNhSjFuT0JvSUVvbzlzWVUvT1NGY0x5SUVyTmtXenJZS08ydWJhdFN6?=
 =?utf-8?B?Z1pTR2lXV3hzdmxEcTI0bncrMzE4dXdnZkNla0tuV25YOXpROW45Um55R0xn?=
 =?utf-8?B?N0U0RHhhWkdLMjZlUThuUXdON3JneFRVemh6OS9XWjB4STZUSmptSXc4TEJw?=
 =?utf-8?B?MHBoVitjNGlEdzlDeHFPNlBPbWV3dnp1TTZ4Wm5EaGZuZ3VDQzhhL25tazBQ?=
 =?utf-8?B?dnVXS09aTEoxUnJzK252N09BcWp5bWdKNjdvYkNTU20rVys0TjVzOTM0SThC?=
 =?utf-8?B?bjhzYW01RlBidDhhTk16VE80cHFYak9ha3NqL0c4WlpkU2IxK3VGay9vQi9I?=
 =?utf-8?B?ek80ZytIYldGaFNWQ1A1Y1pOZ3RjU1JWSDNyNXV2azY2VEJWbVQvV0VacXpQ?=
 =?utf-8?B?ZGxKWkFlS1ZxUHVyVENlVWplRytOSlFaNU8rWU5ROXlhVk5acy9HVGhwOEhn?=
 =?utf-8?B?b21Ta1Jqa2FoSDFGNlY5bHU2UTk4RUdhVFNMM1gzTTdEZE1xZ0VxZ094cC80?=
 =?utf-8?B?Rjc2UXB3dnlGb08wVHRvV2N6QkJQWHN4elU2L3orVDdkMWRESUZhREluQ20x?=
 =?utf-8?B?ZzZwSU9XM0pJV05Rb0pWV2o0U0MvV0pKZEk2MEpzWG5OdW5QVVdGZVB4ODdY?=
 =?utf-8?B?Z1l0NG1DQ2ZNc3NEZ0pJc2dKTmtuamFSd0NYWUgyVkdpZE40ei9KQ3F2M2s5?=
 =?utf-8?B?SkFIbGZRdWhGUHRIeXRIb1oxNTFlVFowQ1o5NUVUR1pmbEdhUUpVQ1BTMjVL?=
 =?utf-8?B?Y1pGUHFjclpyNUNpenRlQnFtMTBUL3FTRWxIdm42cFdDNEtxZkxmcExxM3Uz?=
 =?utf-8?B?Y21xc3BOdzJmL21waFZzck5hdmlSMjM0U1NPcVJpZFlGeEhUMFlCSUgxLy9T?=
 =?utf-8?B?a1JFbVFyc1hsVm5GWmNXOGJIeEhOb0pydTlaREpuTDl4aFJmNHRpLzFOMVls?=
 =?utf-8?B?ZmJVUXYwWnh1ZkpEMDA0T1BFbVFsaVh3WnVoZ2owcUdHbjRLSjlNQWh4TFhJ?=
 =?utf-8?B?eWF1UnlLRGJIVitSQm1PRHdteTJtYkNxQnNLVk82c1N0aGFPNlZXQkhVUUY3?=
 =?utf-8?B?NUpUTFdqMVoydGxEZnowcUZobmozT0Q1TzFmcFRvYXRRZ25PN2lhelFEbGJ2?=
 =?utf-8?B?dnhFSnF5RkIwcjBxT0tOenMwd3k0NTIvMk5XVm82ZUl0bG90a3J3VEFGa1oz?=
 =?utf-8?B?YnNnaStaZVRtODRabkxwNjVoVlU1MWtmYVd4b0FPQ0VJNGlYV2p5VzNZK3NC?=
 =?utf-8?B?aU1QM0lhaDNDYmk4WnRrTjI1QTh4TzNsQkNVTW9kQXl3dHJxSnBBcVhoVE5i?=
 =?utf-8?B?YTdDcUY1VHFxcHJxT0xHOFVKS09DTUtVKytuR2JkcUs3N1pNVm9GTGtxaFNs?=
 =?utf-8?B?VVdyUDZTb204Mm5FTGN5QzJqdkJQQk13ODlGUHBjMks1RmVreVhUenpNNUVM?=
 =?utf-8?B?YXNoc1k2bU9jMGI3UUVub3J6K1F2T3k3SlBXT0cyUDJUSnVTKzFWU0d0UXli?=
 =?utf-8?B?Vmw2dzZpQlM0UUFqbHUrMVE2RGtxZFlaV1UyRkRTZkhWekZFYXpQZmZ3bjMy?=
 =?utf-8?B?WVU3TXI0dGZHbE1OQmRpcFNrTGIxZ3dZRW1YQVk0WDcxcEdCV1pYV0xtdnE0?=
 =?utf-8?B?YW90QkVsaDNQZ3NNQmxsUUxoV3Y0MDFjcmJYaW9wL2hHN0VWV3o5VG9tbDBn?=
 =?utf-8?B?MFA3Mlo5YjJaZXBiZWNOdXNVS0x3eEkrU3FnNk1TNjFMOE9RcnBwY0xSbjR3?=
 =?utf-8?B?RTEvZEFUc09nYnU3RHV1WCtvVEpROVl3MGZmbVc4WFVZS0VLNlR6TDR6VFdk?=
 =?utf-8?B?Ull1azVtNXVUNnV6cDlWWFRsTDRIbDdXY3duQnlSU0FLeDI5bXV2QmliNkh3?=
 =?utf-8?B?Rk9iWjd1Znc0cTYxamhIbDUveTN3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6EA306A10875F84EA7B516B63CCF6C01@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c04dd36b-f731-4073-a102-08de39584649
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 08:27:23.1962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z9jykJDtES/sePpE/36nkQRFetbZQDqfHLTJdk8IFoIs1Z9TQYecOfXREkanHPwnGrXaXTp8bxGmqZq15BLMEnS89X6/97br0PaevMbzOOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8651
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA2MCBTYWx0ZWRfX9CgfOk6ix1jE
 Wj5Hl1M0WfbF8gWQPGvTKPcfMUogdk18CfgrCOM5v5AeYQX2B+GzLQkHLEKINaOseUbECPeGald
 1pG7y7c1hM5LOP6U7zSN8ofTrm01OAJZSiVg3mN8VzB8PP/PEN8JbrwPHcR/Epnh7Nd0d0fp41E
 zHgeUR9ta1ga+Aem/imuEgtMSIIJvz+JySxJnTBkdaka5b4hIlkzVqYarrX9GLWPHpMlXLLR9JT
 2xyCZAyKiceb7Y/loZ33nSnf11q3XRFBy0wYqh9BPU14tISi2AEjWU+faSmY8qR713gJkYcFCSV
 YNXc53CMhDv8QkJ75JXb6fIcUe11gKSFc7TofwAXD+q3bxG6dsBf61R6v7DI3vpoownRatlSmS3
 lkR74SbygkbauNDUjdx2CDEN9UXrSA==
X-Authority-Analysis: v=2.4 cv=Q4nfIo2a c=1 sm=1 tr=0 ts=693bd1ee cx=c_pps
 a=gqqRaR/JtIFMplGXl4YyTg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=zO98mkqt4NiYWxvmdz0A:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: gsKf2T0ubM49fhcLn5bj06FZUKRhgkhI
X-Proofpoint-ORIG-GUID: gsKf2T0ubM49fhcLn5bj06FZUKRhgkhI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_02,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTIgRGVjIDIwMjUsIGF0IDE6NDnigK9QTSwgRGF2aWQgV29vZGhvdXNlIDxkd213
MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgMjAyNS0xMi0xMiBhdCAwODox
NiArMDAwMCwgS2h1c2hpdCBTaGFoIHdyb3RlOg0KPj4gSSB0aG91Z2h0IHRoZSBlYXJsaWVyIGRp
c2N1c3Npb24gcHJlZmVycmVkDQo+PiBrdm1fbGFwaWNfaWdub3JlX3N1cHByZXNzX2VvaV9icm9h
ZGNhc3QoKSwgYnV0DQo+PiBJ4oCZbSBub3QgdGllZCB0byBpdC4NCj4gDQo+IEkgdGhpbmsgc29t
ZSBvZiB0aGF0IGVhcmxpZXIgZGlzY3Vzc2lvbiB3YXMgJ2luZm9ybWVkJyBieSBtZSB0eXBpbmcN
Cj4gY29kZSBpbnRvIG15IG1haWxlciwgYW5kIG1hbmFnaW5nIHRvIHR5cGUgYW4gZXhhbXBsZSB3
aG9zZSBuYW1lIGltcGxpZWQNCj4gdGhlIGV4YWN0IG9wcG9zaXRlIG9mIHdoYXQgdGhlIGNvZGUg
YWN0dWFsbHkgcmV0dXJuZWQuIDopDQo+IA0KDQpHb3QgaXQgOiksIEhvdyBhYm91dCBrdm1fbGFw
aWNfcmVzcGVjdF9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KCk/IEl0IGF2b2lkcyB0aGUgDQpkb3Vi
bGUtbmVnYXRpdmUgYW5kIGtlZXBzIHRoZSBzZW1hbnRpY3MgY2xlYXIu

