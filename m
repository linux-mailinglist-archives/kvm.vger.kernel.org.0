Return-Path: <kvm+bounces-67692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 768D9D108D2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 05:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F20353045CE7
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 04:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C13130BF63;
	Mon, 12 Jan 2026 04:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PDfB4trc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jweWIjO2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5E73D6F;
	Mon, 12 Jan 2026 04:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768191377; cv=fail; b=PkhY/zLt5f/EfrfS5vnIqIV26TpsxQKrFVg/FIdLIMDQLdB7Agz6u5HB9L1HKL10d7+ANUkWgtfk4SN4ENXp5U55Ty69LkUYP5rGvkloXEBim3rx4CckXe+bpDXXlNObz+qxkhNSEpKK7U95qOduc41+xU5+alD+iJlJSVK6RwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768191377; c=relaxed/simple;
	bh=PFk53vmCuz4OB/nF6UdFoybGq5ByBr5K/yiwqnSWPls=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GWuWLxjPj38z6FclmmfA+YzeL/+odggclKHDYDgJbEFww7FCTRqPRQaBvmMwwEmC967YtAjKgXNPMG5lk7oQoJRtEuff2HdVq5vN3eOmJ5jEMDHNsO16Mtth97iJkqAvEtMtTLfcFtTVovad4gEVBMTxhYHN1JbaXllj2gw2Gf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PDfB4trc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jweWIjO2; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60BKwNl62417784;
	Sun, 11 Jan 2026 20:15:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=PFk53vmCuz4OB/nF6UdFoybGq5ByBr5K/yiwqnSWP
	ls=; b=PDfB4trcUVMJyPKyekSMHamL8z8kACOxD2iikcuyknb31Y+jJ/ttV4t4Y
	9UrY3DXrobHEi2wt1hJEhWVSKBDrJI+f82SS2+icHencfo4wEAFT3iMGK3pJ0hOn
	aTRkye9gM5+xo08FMyCtSNkfmLlwNLBT5W/Nv9ms4bx1ZN+sUAXCuF2MQ0iUZGXJ
	LNqs+NeVkxTZgIiKsILy0cUOviAnfqY13+l12nj9ErO0i37rMBXexxdd+jCq2DEL
	9A0iB6wP9j4+PwELfRcd6XRh3JldPtsOSmfx/l26niZYY8FvVuU7m89TYeLO+FGL
	XvtY3n6lURfG3v3vxVgz27jyW0/GA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020088.outbound.protection.outlook.com [52.101.46.88])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bkpyfj1un-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 11 Jan 2026 20:15:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHxij/VV524DWbLhGkQspEC4X8WcgfXSR5yHP6eWxWbZfBq/U43T33bSA0N3dcmv6jk1I0y03uEFJ4DATFiYJ54vEc4W57SQ7F/9BJg2NPCwVHIOVPb1HYUP4dHGbOzMME1V9u6NdPN3vTxDSjj79TG046nn4vLl7QdFx74gzGDu+NVm41pAg5tjJYM4yrE9kGj/og8hiBwQviqFSA3+egrfXJz6ifZALHlwwoq69xYx6J+q0e7S/VTbOSrzvjrTDUwcprAXfvO/nei/PSZnwDSCs/QEQArtHHC2C7+8Yu12ewaDMzeuRZNc5mc5+Mvqf5+9Lfmeeu44gNVHvMaesw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFk53vmCuz4OB/nF6UdFoybGq5ByBr5K/yiwqnSWPls=;
 b=H9pDikk8qbQmDsCUw2Of1Hl6NEh9iaII4d0iKxdhHZWp9CnF++CaoYBBpeKe05SsJS9eWm42NqCd9klLeUF7rv2u4nTTrXq3CmXQ9R//6zO88NiGc0C0mE/mn7dyY5DXst5Hq51YMK0/7G2AMSaIkRO6i8W2jRygbIHsGgVh1LEX8g2H2F0AE0c8w9axjnaUaEMegxKSc9/08fLs40nnu3mUOq719wA2zZ19cUmVHxkBpJrp7KYstQ4avbzns/pq61+FNSWoeEq2dzpkibtWt+9WDthHPyjlhef5iotBM2VqXTPJZweiZnz1SJ0yoOh09Tnuz2KjmM1LuEVle0zf8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFk53vmCuz4OB/nF6UdFoybGq5ByBr5K/yiwqnSWPls=;
 b=jweWIjO2WLZD+hAjif4SZ99OqGM70LkK49uj2NfX0j5coeYv3L+OBrNEWzwfhwVL2Dztlt0mTIc/0M6K6T61HoxkGUSky010xXsAQ4EaU1/EUVzW8oPNpSv2SZJsLXqluPyvS4wVe1lP2QLrMROXbQY5fygsengS0mw87Ud6N8P+W2OJMhw0MR/d+aEmcH+d1EpToXm6gXghfVwFlYCFQgCt+ExJkCccplFLmmOzMHwy4uSIN2N5c0y7qRAdvlYwuxy2GIOz2erL/sFqr5crYOZP4SEIM9Qp5EMeNmLXHfhok4ud7EApgr9fY+gKGjGBzCbw72V5eU+3cFvYJqzNZg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by MWHPR02MB10594.namprd02.prod.outlook.com (2603:10b6:303:283::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 04:15:38 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 04:15:37 +0000
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
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Thread-Topic: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Thread-Index: AQHceLTCGUfuM4IR+kesh1yecA5IOrU/Ft+AgA7r6QA=
Date: Mon, 12 Jan 2026 04:15:37 +0000
Message-ID: <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-2-khushit.shah@nutanix.com>
 <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
In-Reply-To: <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|MWHPR02MB10594:EE_
x-ms-office365-filtering-correlation-id: 98492dea-2ce5-461e-a723-08de51913d79
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VmNqQzFPNjBmVjRjbEY4UlljVVphRll5bHNwK1F5MHZSWHBEdC9CK3E5T0F4?=
 =?utf-8?B?Y2szbk1mVUpKZm5wNVBtN3U0RFVXWHFOZm1jclNBb3BMdkc4MjNoSjNjeFYw?=
 =?utf-8?B?SGlPY29Pcy9ZZXhtM3ZjWWxRMjlndXhjUzJRTWoyczlkQTF4K3lnUDdVR1hu?=
 =?utf-8?B?Y0ptR2wvRUpzRkpkUWc4c1Zyak1jY3VUV3NwUzJRdDQxbzhTSndIV3pHMmtk?=
 =?utf-8?B?cUx6NE1YNkNaSzBoMUV0YmRqWGxMSEJDZTZrZHF4U2tRR3c2aXAxZ2xJWlRl?=
 =?utf-8?B?aWphZG9BaVoyMHRXMVRRWTVOVnRVQWwwRnozTWkwQ3RVNXhjY3ZMYTNIeVdU?=
 =?utf-8?B?djFDNkhhZ25JSi9tMHB4Y01rM1pHRjEwZkF6TE95VzJ2ZU5acXhCeWt3YWpo?=
 =?utf-8?B?bDVZRlVTeEtFWlNrQytTZGpPNXh1SUVsem1kaHBsVWg0eGVTcmx3bmVLbEE3?=
 =?utf-8?B?ZjlhdGZwNnl4VlB1TkdVcDQ4Mk5heDN3eWw1eTJDNWxFS0xJbUhmUHN5a3Nj?=
 =?utf-8?B?RC9LYVFYWkxSbVEyTFJETkdVaW1Rc0ZIc0NoWWpUbXVrL2JsWERUdWlQQ2RQ?=
 =?utf-8?B?aHJEWm9Uc094VDBGeitrU3lleE9GeG1yWTk2M2FlSzFwMktkNVdXRExGTUc5?=
 =?utf-8?B?ekpEeFBUU2NxM3EvbWZtOTJjak85Qy9jODA2c1R1Sm5vL3o3VFgvMkhmc2N5?=
 =?utf-8?B?ZzJMWUR2S2dlWklDRWVQTzJhaU9FZFRvQ1NTZXJmSnduMy9saFNkZkpSTm5B?=
 =?utf-8?B?T1JxUUIxM3g4MzhlZVNKUVRCMGd3Ni9CbGRnWXRBRnFTYVV0cWQ4dWdBbFZ3?=
 =?utf-8?B?WTNyS0VvRFB5aGlJci8rbkJjNGJ1TFFUcSt3RXlKQ2pITVd4UWxYeE5yQXpM?=
 =?utf-8?B?NzM2NkZldUJsemxKQ3hiUEdwQVFIY2VsVFNxcUVMSTRXZURybCtIQkYyMDI1?=
 =?utf-8?B?SXdjdk1iYWM3MVRINnpOUWVuWW1zdGk2NXZIcEdOQlJqckN5UEloa29KUEJh?=
 =?utf-8?B?Q1lBRWRIeG15ZFdmZ0w4cEd4Y2VuMEp5SWE0djhvSnNJL2pGRld5YUtuUXZk?=
 =?utf-8?B?a1NzckJHQTAycnlNdWE1ZGxyTTc4MUtGWFFLWkowdFczVXBGdkZ2U21UUEds?=
 =?utf-8?B?T0RBU3c2TzNkVFA1YSt5c2NQOStja283M2w3VTNIQ2Z2ZURNK3JOUkVoZ00w?=
 =?utf-8?B?SGIvSGE1alVENEYzRVAyWGF1YnF4dWQ4VzBMYkZOY2xDL2FzMmxJVXR4NWNT?=
 =?utf-8?B?dmZYeCtpc3Nmb1Jhdm5Nc0p2UlczQnB3M2ZFMHpOU0RRT2hadXVCanMxUk5E?=
 =?utf-8?B?SlVSYVBvOHpsSUwrTTNKK0tldVJ2MG1wMWNIelV3Z3BUWmhGRmpXMnZjaXFV?=
 =?utf-8?B?eVIxVkt3VEJTQzJ2Q2M3VWVEb21VblhIWlE4cDQ2N1cxZDRvSWtNdzNNb1FS?=
 =?utf-8?B?eVVrSGdRRksyaWl1dXhtRWtWOENqUlNYTXZSNGhQdzgxYjM3NHRSeXpEeXlP?=
 =?utf-8?B?dmh2d3pGTGhpQWRuS29kc2ZCUm1jTlQzbmp5MEt3MTdDY1VvNkxEMENzNDVE?=
 =?utf-8?B?dXhHSlduazlqeDM3WTllODRZZzAvRllXS3ZTYmNNM294a0t0UmxVQWRFYm5Q?=
 =?utf-8?B?V25Ia0s0cnE2cUdDVDhBS0YyQ2liREdLOHBwU1Bidmp1b1VEL0tob3d1UXlw?=
 =?utf-8?B?bTYyeWRFWDBLRW4xK2c5YTE2NWY5Rm5vRWtYVlBxakc4UlNSR0xNdFhTOVVz?=
 =?utf-8?B?MWo4V1pzdWR2aEJVL3BiU24yemwvdnlQc0haRU1nNHkxbW1sZGVpM1p2N0ls?=
 =?utf-8?B?NTZ4UE9BSXFERm5zblBKUXhoQThZSUZzcGlNaEc3c2tqQTlZV09DaUpZSUps?=
 =?utf-8?B?ZGk2VWx6M3pTVE0zbUk2L0ViVkxVZ0lITzUvM0JLc1BaMEVYckw0ZWh5emtW?=
 =?utf-8?B?NlV5NTFjM3dLdlFOYUFjODRDdERhdWR6MDFRaXhoRlJEd2dwRjd3UXVrYXZ6?=
 =?utf-8?B?V2Q1M1dlMGJVVXU3NHRJdjZoZUphSjlaQXlQblVObnRTUGdudzZMaXVhWVcv?=
 =?utf-8?Q?gMzD2z?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?blpoRHFUYTJ1Q2dteUZJNGt6TEN3SlRkM0Z3dUU2WG43ZFV5Qk9LOSszcWxw?=
 =?utf-8?B?ZXEvQytqNU9yME1OdCtrL1p2dVZIT2dLNUxUUWtjVjZLODdMcStqNUoxTGZR?=
 =?utf-8?B?V1VkQURZd2RyN0RreU90UUx2S09hOTZ5UXBjbm15OVRUaXcvNDdUa0RXSjRp?=
 =?utf-8?B?cUgwWXJSSnp0V0hBREN1NDFiRllCWU91OHFBbjBsNTY1VkV6Yk1FSjFWZ213?=
 =?utf-8?B?VjBrUThOai9tcmhUQldxazFpeHErSkxtaGNTRnRiTGlVZXBpdWxXQkRYYmw0?=
 =?utf-8?B?aHp5VkFRZ2Fid2RqdHc0VVBMSmdvUFlCVHhTVGRGVzFqUGtyNnJ2UE1CR3pB?=
 =?utf-8?B?MytwVks4OFRtK2VOdTJLOUE2aU5yWEZ6MXdvUTdoT2o1RlJTMlJ6bUcxM25z?=
 =?utf-8?B?aStMcDR1SWpDRDlEbUFKMTlXd3VVeU1laDR6akFnbzEwZFAvOWx6L1ZQY0xG?=
 =?utf-8?B?UVpSSjNLVG02SmRIbEhQTkxkQ0xBcnhyMytRV1UvTTUyaEZJY1hCNnd6K1BH?=
 =?utf-8?B?UmJacnRmb3k2ZEdlUjJmT0xOaXRVa2ZKU211NjhrQTh0a3FuTHBlZnFWb2Ew?=
 =?utf-8?B?d0FHVFZLYldvd3VOWnNTVEJsYTBvR1dybElUeXJDZkxuQjMrYndza0hYOU01?=
 =?utf-8?B?YXgyV2NJZU96Nm1KazNjbUcyYVFoajEwVUdOSVpQNnhDd0NSM0VqR1FuQlYw?=
 =?utf-8?B?QXBDTHVSM3pqRDVseGN5Smk3M3BsVFhBNUc3cTAycXFEcjNOVjRkMElQalhR?=
 =?utf-8?B?YmJuTTQzVnlOTVd6dk1sbEJ3aUtWNzNOVTZuVEhkaUwrem5vQVpQeEFrRFhE?=
 =?utf-8?B?eDJYSVVWNk1SUW1Hc2l6b09TcmVFd2VqWUs0eVRQcDI5RzVyQkg5M2YxTG5B?=
 =?utf-8?B?UXI3T3RCckVIOUVUVnZ3QkorZUxEVlRwUzU1N2M4MmQwanhvbENpb3JWRDA4?=
 =?utf-8?B?Y0syaVV6Z29YRzI4NTU5ZzJXb0tGbk42QlRObzdxK0VyTFlkUWRPMXhVTm1K?=
 =?utf-8?B?dTgxRXRPeWdyUjZQSU1VTFVUc2JTbWZqbUZ5Y1JiRStzSGdpakFLNWZKNmY2?=
 =?utf-8?B?SjVHTVN0RHJwRndiaXQ1dlJ6R0ZEdXpIcXFrbjZuWE5WL09TY3BRK1FBOHZY?=
 =?utf-8?B?QXh3eWI5RkVBbUtuNkQwcWE2SDhUbzlHc1l5MkIzMVUxVFBsYTdNTVVtaGE1?=
 =?utf-8?B?SVNpMUJrdDRwMTcwMDkxclJob3dHUTl6TXBKR1BkQ1VwZW9IQmFLZm9EQ2py?=
 =?utf-8?B?VVNKRnI4OGU4dWVFbGRXaUZPRGMxaWtzc0RhMndseUUxQ1M3Q1ZJSUxTZDZ5?=
 =?utf-8?B?YzF4T1kxSFdSczhIYktvVW1MUXd3a010V29Ha3ZzYTdnOEdWbXlTaitrOE5j?=
 =?utf-8?B?Uks1bzVWQldwL2V6c0RIOFd2ZmhsYmRqdnlqUkRjenhwd0FWSkRpLzJxT3Bj?=
 =?utf-8?B?LzZaNjI3cVU4YnMwek5aYlVYVUVOdytPMzI2UUZvdzJVbGx4cUtNLzlFVDV4?=
 =?utf-8?B?S01yMEFlL1lsdndQbmJFQ25FTkR6bzAvS0VCdEdWbldTM3FoeS9SSm9LeGln?=
 =?utf-8?B?QUErRTdPMnZReno3UUdZYWw5bFpNWkRiUEhjeE90Yi9LL0pXVndIeStMZ3BV?=
 =?utf-8?B?bW5wV3poNkFJODBXNGdtMStkMjdjdWRFYTVqampVTEtNdnptOW1Da3JrSW12?=
 =?utf-8?B?QkZpbHNkemZNVDE3WGtwUDlSb3pzaEQ4SThTTzhqM2h0VElIZ2dqOXdBNjdH?=
 =?utf-8?B?dDMzZ05qQ3F0L2crRG04S0ZwSDJzb3JTaGtZcWpPRzRJZWxsaTNsdkJ0dC9F?=
 =?utf-8?B?SHRoUThXdDVKVTQ4c0RBSnhiYjVGdkYvTnVPeHNJMjlMdlRhQ2k0NllBYnQ1?=
 =?utf-8?B?c2I0SDAyeGhtWCsrYXF6bjd1c2RNQ0JjcTRpMW4wcTQwalVFbWxGUXN6aHVZ?=
 =?utf-8?B?QkZXazY3b2VvdnF5M3BEY1F6T3hYbWpIV1hMME05ZldYSlZ2eFViV20vYXBQ?=
 =?utf-8?B?cnRJZFFKcGQwQ3Y1ZkNhUjE1M0pjRldvc0RqYW1YVmJJNndWT3VtbU9RYVFq?=
 =?utf-8?B?UGNjVSt1aGVQbXRkOFB6b0tDYmVQUU1zMnBZdGpPL2YwTnl5NkRhT1FyS1Ns?=
 =?utf-8?B?L3h1K29aOURJZVEzcHNDVURtSHdtajdGdEdHa0VyK2lsV21DS3B4aExNcldH?=
 =?utf-8?B?cjRmbHhkcHY0SnJySzRkOXhZSGFZN0NjVlI2enZieDh4VVh6MDJoclo3RXlN?=
 =?utf-8?B?U0tvWE42cEZocEZYNjhFbzdaWjRZVDdCRWJIR3RGTUNsbzIyMXcvcUVMUGlT?=
 =?utf-8?B?dHJpMy93K2ZsWC80ZUFEN3o3RFhRcTQzcS9uZ2E5aDgxd1Y0TzN5c3NqYUlm?=
 =?utf-8?Q?j7ucxT0pyonZP8eI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86245291FC12CA43B3203042555384C1@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98492dea-2ce5-461e-a723-08de51913d79
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2026 04:15:37.6299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/zr3bHNev+4tv2ZeL2dDuAU38u4wGNAd0FY8PkW2Yq3e+IIXmMzKk6PJjqo/dihlIaCP6keqq++wYZPxVVlkUPwm7XBxBoiJmhLLd9tzc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR02MB10594
X-Authority-Analysis: v=2.4 cv=B4O0EetM c=1 sm=1 tr=0 ts=6964756c cx=c_pps
 a=XrAAyJxZ/W28UfFUt0AM7g==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=64Cc0HZtAAAA:8 a=pBOR-ozoAAAA:8 a=MVh_znRYb5bsjvVvi58A:9
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAzMiBTYWx0ZWRfX3a0QqY22mNkA
 gwLQFbMwq4ZmUO84J1i0SuHn+mN0piKq0LKs4c3HMrPEMH5ATWKphkeOmYqa8t2Ra0tAqAj4L1Y
 krTnulQEw0uFl33No4Y5t+BhvJEpGzd1tb6iVoGZt9hCqu/m97lPT0MmV1Q7Z0HGE/qGO/B4s+y
 ldD2AVZ3jOOFZRCwEuch9leCl+qFd9Zzo156Ku4Hr0YMYYxLG6eeW5xmSU9JSS4/JOJHwJ90ULI
 6L5dAJGP3SYk5Xaat+9PH4nMLGZvwkSLd+4hoFhB8/vutXKg1BdYX2EfBrrHfksVq7QGQQLWu0p
 qEJ8N+82Kzw/PCxDjr+nvuVgK/J4OVWoBURzCstwL3GoP2vY2l9jTGcG5kF37Ne/K8lnK05j1gQ
 VxND2pxkRSCFq38yr7cSmG/KqqB6jK7Rsiicr9wjkvcr5Xz61RWysR0uboMAbXArQ06CkZvqjkR
 K40XZ+25MoSv3AEUdxw==
X-Proofpoint-GUID: 9A6mGm056pusgaUpf_cw2WVDCU46M9i1
X-Proofpoint-ORIG-GUID: 9A6mGm056pusgaUpf_cw2WVDCU46M9i1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-12_01,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMiBKYW4gMjAyNiwgYXQgOTo1M+KAr1BNLCBEYXZpZCBXb29kaG91c2UgPGR3bXcy
QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4gT24gTW9uLCAyMDI1LTEyLTI5IGF0IDExOjE3
ICswMDAwLCBLaHVzaGl0IFNoYWggd3JvdGU6DQo+PiBFeHRyYWN0IHRoZSBzdXBwcmVzcyBFT0kg
YnJvYWRjYXN0IChEaXJlY3RlZCBFT0kpIGxvZ2ljIGludG8gaGVscGVyDQo+PiBmdW5jdGlvbnMg
YW5kIG1vdmUgdGhlIGNoZWNrIGZyb20ga3ZtX2lvYXBpY191cGRhdGVfZW9pX29uZSgpIHRvDQo+
PiBrdm1faW9hcGljX3VwZGF0ZV9lb2koKSAocmVxdWlyZWQgZm9yIGEgbGF0ZXIgcGF0Y2gpLiBQ
cmVwYXJlDQo+PiBrdm1faW9hcGljX3NlbmRfZW9pKCkgdG8gaG9ub3IgU3VwcHJlc3MgRU9JIEJy
b2FkY2FzdCBpbiBzcGxpdCBJUlFDSElQDQo+PiBtb2RlLg0KPj4gDQo+PiBJbnRyb2R1Y2UgdHdv
IGhlbHBlciBmdW5jdGlvbnM6DQo+PiAtIGt2bV9sYXBpY19hZHZlcnRpc2Vfc3VwcHJlc3NfZW9p
X2Jyb2FkY2FzdCgpOiBkZXRlcm1pbmVzIHdoZXRoZXIgS1ZNDQo+PiAgIHNob3VsZCBhZHZlcnRp
c2UgU3VwcHJlc3MgRU9JIEJyb2FkY2FzdCBzdXBwb3J0IHRvIHRoZSBndWVzdA0KPj4gLSBrdm1f
bGFwaWNfcmVzcGVjdF9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KCk6IGRldGVybWluZXMgd2hldGhl
ciBLVk0gc2hvdWxkDQo+PiAgIGhvbm9yIHRoZSBndWVzdCdzIHJlcXVlc3QgdG8gc3VwcHJlc3Mg
RU9JIGJyb2FkY2FzdHMNCj4+IA0KPj4gVGhpcyByZWZhY3RvcmluZyBwcmVwYXJlcyBmb3IgSS9P
IEFQSUMgdmVyc2lvbiAweDIwIHN1cHBvcnQgYW5kIHVzZXJzcGFjZQ0KPj4gY29udHJvbCBvZiBz
dXBwcmVzcyBFT0kgYnJvYWRjYXN0IGJlaGF2aW9yLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBL
aHVzaGl0IFNoYWggPGtodXNoaXQuc2hhaEBudXRhbml4LmNvbT4NCj4gDQo+IExvb2tzIGdvb2Qg
dG8gbWUsIHRoYW5rcyBmb3IgcHVzaGluZyB0aGlzIHRocm91Z2ggdG8gY29tcGxldGlvbiENCj4g
DQo+IA0KPiBSZXZpZXdlZC1ieTogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51az4N
Cj4gDQo+IE5pdDogSWRlYWxseSBJIHdvdWxkIHdvdWxkIHByZWZlciB0byBzZWUgYW4gZXhwbGlj
aXQgJ25vIGZ1bmN0aW9uYWwNCj4gY2hhbmdlIGludGVuZGVkJyBhbmQgYSByZWZlcmVuY2UgdG8g
Y29tbWl0IDBiY2MzZmI5NWI5N2EuDQoNCg0KSSB0b29rIGFub3RoZXIgY2FyZWZ1bCBsb29rIGF0
IHRoZSByZWZhY3RvciBzcGVjaWZpY2FsbHkgdGhyb3VnaCB0aGUNCuKAnG5vIGZ1bmN0aW9uYWwg
Y2hhbmdl4oCdIGxlbnMuDQoNClRoZSBsZWdhY3kgYmVoYXZpb3Igd2l0aCB0aGUgaW4ta2VybmVs
IElSUUNISVAgY2FuIGJlIHN1bW1hcml6ZWQgYXM6DQotIFN1cHByZXNzIEVPSSBCcm9hZGNhc3Qg
KFNFT0lCKSBpcyBub3QgYWR2ZXJ0aXNlZCB0byB0aGUgZ3Vlc3QuDQotIElmIHRoZSBndWVzdCBu
ZXZlcnRoZWxlc3MgZW5hYmxlcyBTRU9JQiwgaXQgaXMgaG9ub3JlZCAoYWxyZWFkeSBpbiB1bi1z
DQogIHVwcG9ydGVkIHRlcnJpdG9yeSkuDQotIEV2ZW4gaW4gdGhhdCBjYXNlLCB0aGUgbGVnYWN5
IGNvZGUgc3RpbGwgZW5kcyB1cCBjYWxsaW5nDQogIGt2bV9ub3RpZnlfYWNrZWRfaXJxKCkgaW4g
a3ZtX2lvYXBpY191cGRhdGVfZW9pX29uZSgpLg0KDQpXaXRoIHRoZSByZWZhY3Rvciwga3ZtX25v
dGlmeV9hY2tlZF9pcnEoKSBpcyBubyBsb25nZXIgcmVhY2hlZCBpbiB0aGlzDQpzcGVjaWZpYyBs
ZWdhY3kgc2NlbmFyaW8gd2hlbiB0aGUgZ3Vlc3QgZW5hYmxlcyBTRU9JQiBkZXNwaXRlIGl0IG5v
dA0KYmVpbmcgYWR2ZXJ0aXNlZC4gSSBiZWxpZXZlIHRoaXMgaXMgYWNjZXB0YWJsZSwgYXMgdGhl
IGd1ZXN0IGlzIHJlbHlpbmcNCm9uIGFuIHVuYWR2ZXJ0aXNlZCBmZWF0dXJlLg0KDQpGb3Igbm9u
LVFVSVJLRUQgY29uZmlndXJhdGlvbnMsIHRoZSBiZWhhdmlvciBpcyBhbHNvIGNvcnJlY3Q6DQot
IFdoZW4gU0VPSUIgaXMgRU5BQkxFRCwga3ZtX25vdGlmeV9hY2tlZF9pcnEoKSBpcyBjYWxsZWQg
b24gRU9JUiB3cml0ZSwNCiAgd2hlbiBlbmFibGVkIGJ5IGd1ZXN0Lg0KLSBXaGVuIFNFT0lCIGlz
IERJU0FCTEVELCBrdm1fbm90aWZ5X2Fja2VkX2lycSgpIGlzIGNhbGxlZCBvbiBFT0kNCiAgYnJv
YWRjYXN0Lg0KDQpJIHdvdWxkIGFwcHJlY2lhdGUgb3RoZXJzIGNoaW1pbmcgaW4gaWYgdGhleSBz
ZWUgYSByZWFzb24gdG8gcHJlc2VydmUNCnRoZSBsZWdhY3kgYWNrIGJlaGF2aW9yIGV2ZW4gaW4g
dGhlIHVuc3VwcG9ydGVkIGNhc2Uu

