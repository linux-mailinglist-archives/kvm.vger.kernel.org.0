Return-Path: <kvm+bounces-72570-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2IOHEj8yp2k8fwAAu9opvQ
	(envelope-from <kvm+bounces-72570-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:10:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C75201F5B41
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 720A930B65A8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC7442F561;
	Tue,  3 Mar 2026 19:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="eDsWbQXx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vAWel0DP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B0C423A6B;
	Tue,  3 Mar 2026 19:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772564762; cv=fail; b=HOH1h69bU8E9u8623nmtM1Xl9CJusKBLpytmZvGnYaflY3e9UHxRhFlqPlP/gROT/pbd+wpSqOvfFBTXGwrO/7OS5yudOrZEMRJDnGo0KiZZsPJVDzw3KHuKOAljohl2D6N2YcWzFa0vXeOH4u/1knfx/t7hQJpuEWrqe3qScz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772564762; c=relaxed/simple;
	bh=pf0NNdBstXBZTyzQeU/lDgaNDtZXSUb4gOU9zKlk368=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gm9XF90I3500+uYwLD8CNHz1Yt9oP65ZcIZNWNWMVnwUtHLtQkm3+n++geaX9Z0zPTmqyuxSNWekXd2Z/rSxK4KjymhoQGLD+CRMHu9yRqBL6EMAz52w2MxHIAxuScaIC6Tm1PSff2vQCRDMkB8Jx/ojuRUzAYNDg+wvwxVuLPQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=eDsWbQXx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vAWel0DP; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 623IwY3g3097571;
	Tue, 3 Mar 2026 11:04:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=pf0NNdBstXBZTyzQeU/lDgaNDtZXSUb4gOU9zKlk3
	68=; b=eDsWbQXxarnoc8DLh3NAo/6DMwrBIk/3eqjjnjoedgW0vmkLRysmTaiUv
	VANlpPtY++xH/R3qdiRBkARDlbgwol11WVw/tegIHIpXjNE/VHvU9UyClZCMXoVX
	0KGiN2qYMfF/ma2uEXduq7pu4WFUhz4Ee9ia9hA1g0P48qAIt+z0FLD93mXJJDO4
	q0lGKCS26GeeNr/N9SdH6+gPQtvOcsZqalfS77eLdfg0bpb8kCX5w4BoCDQ6qxm5
	IE3qbzYMcxbIPjmaHA4FumPMyAQK1xEEWeY7MPfviAJ27CS0q31wpgB0rRTGV932
	F8zzDaBWMucC0rpj1cxuECnUj8Hhg==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022136.outbound.protection.outlook.com [40.107.209.136])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4cndr7bwd0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Mar 2026 11:04:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9PxxRzi8/YZnb+qJBcaSFNymTOAieCEIDnrpaYmgGtIVqU2/vTZEzGi6oOypB0xIt9lh3GaZYWWIY+88n+yyEGcOd8DCJyOaTkCjQPxQ/7DXrA8v1jx3t6KIOSxu3XtxCQTfnV/PBBydoxZ9jhg8mHc2A78eEYqVv31xqN8ZYoUHZWCWAZGmzOk59DjeXGaiBjn4zgEHmNHpmu7qhP8JJfqQIqDQiKVHhfNaP9bvHDmPznud/xavS3hAj5OXBkRny0F9WqYvL939fVi2T75MDfhoqlNqtouY5BlfDfgY2RyZabDoaqFYsvcnRM6XzMZolKLYEDQ4ynqDm6XRLbRfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pf0NNdBstXBZTyzQeU/lDgaNDtZXSUb4gOU9zKlk368=;
 b=j6rtEUJQBZEA9xtBW9/ufcHs/QzniXeddfF4lrY/NRag+yCDta7XXX4P7+dwx6sq42vOTIYKOAZyBMtBiLhAanon1ZCD892yQIPzRFah1DdYqSj7C4WUE5L5tHjup0MwuFHVOf/hEuQCdcG26kJFd7qEmO4KZz8BJBIhyPx7poNo2Ef4EFz7K/Yz3zSRj3+az//TPeIEplWLfEUZ0sqNLFssegRiD+2G3QH1eaII4F2a34FqUDBNBjW5bLBURvZhnjMI9RYdvPZewykha1w7lK1/B0N1M/GQF665b0Nv9PMCyoohoPwWFbdRyM8YSp/D9OxDKsHYEEBUtIhdkbh+nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pf0NNdBstXBZTyzQeU/lDgaNDtZXSUb4gOU9zKlk368=;
 b=vAWel0DPV8SrI+xUCBr9cMwp4NMfY3EAIj23Ruq7u13ENQKvmnLGZN0sFuZcnD7bRGwEqM9bbRs/0aN5U1rsFSlqb5VxicxP4spNI6Q4z4VSCqoX/jp2PK3TUDKOmzZ+S5hQeJOFAFLJfssy2O5T+IwJHvKJSxvFybPaxx+VBoKbywnZF8dmiht0OzCeJ3OpIKP1Fg4TTdh/SE7seMXAqfoM+417X+P2qJISa0atwQPhZwqrjQJXR5PVieeqJRkFwiupcb3D6qs4EPp0Je/TZO83aSwdZqwsf8jXg+IbGo7wIGtZ8jUanPJTDEogD+0c/KTrdUjAyX897IdUQppp/w==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8598.namprd02.prod.outlook.com
 (2603:10b6:510:10b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 19:04:52 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%3]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 19:04:52 +0000
From: Jon Kohler <jon@nutanix.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "open
 list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "ken@codelabs.ch"
	<ken@codelabs.ch>,
        "Alexander.Grest@microsoft.com"
	<Alexander.Grest@microsoft.com>,
        "chao.gao@intel.com" <chao.gao@intel.com>,
        "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
        "mic@digikod.net" <mic@digikod.net>,
        "nsaenz@amazon.es" <nsaenz@amazon.es>,
        "tao1.su@linux.intel.com" <tao1.su@linux.intel.com>,
        "xiaoyao.li@intel.com"
	<xiaoyao.li@intel.com>,
        "zhao1.liu@intel.com" <zhao1.liu@intel.com>
Subject: Re: [PATCH 5/8] KVM: x86/mmu: bootstrap support for Intel MBEC
Thread-Topic: [PATCH 5/8] KVM: x86/mmu: bootstrap support for Intel MBEC
Thread-Index: AQHcc8mgQmEYcrkAtUW0F5GAPqo3fbWdhd8AgAATvAA=
Date: Tue, 3 Mar 2026 19:04:52 +0000
Message-ID: <9A277ADB-E2DD-4CA3-AB8E-DF019F73EA06@nutanix.com>
References: <20251223054806.1611168-1-jon@nutanix.com>
 <20251223054806.1611168-6-jon@nutanix.com>
 <4a4bd216-3cdf-4098-8a59-a4cbceb31677@redhat.com>
In-Reply-To: <4a4bd216-3cdf-4098-8a59-a4cbceb31677@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|PH0PR02MB8598:EE_
x-ms-office365-filtering-correlation-id: de62e454-8b35-46f0-297b-08de7957c009
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|10070799003|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 Fv0i7e96hDQV1I+ed1QXV/c8hUsag2pYZzkbPMu7JBM4FtzYf8XcssvyMuq+uc4vONdkz1sXrbdso6HmFd1SFO55Kddkwj3elJ7EakxU0d16ESwvgGIaDXP+OPlYZFyYrB6aDJ6C0s5JNWjZmNUbqtai2zFEZcgxXRK5fPjwMZ4tXy5t4JQWJms6Zt2UornjbtDiZhH9OITTFvBKppgsFsD/ecNYXFBl6DEOGi4TfMjixwme6YFYzyiQlwiBlBtg7J7U9rcUX5W0si9Y0KbXbHKt5K/JF7vL0h4zir6pxMDq5QpqgqJwzHoJ2+JZ9sLMrwwRXxRXNWXA1H1BnWKaV4JqZKg50WOluQGDA+cBL9K6myFJ7kJ0NKJ3j7UwfjjMwyyFfZ6FAUN85hbe4hPaRpBHQWz+ZLZ1bNqGGcIKNh9B6eeU+hoUpWYHHmEn6F875mwAdtxmRvgz+Aeq5SY5WxJlY/iuGKsO9pYkaqrwU0v9WkEDzG/FtzJ+CWdAHaJFTIgm8BsA3XE3V/q4xdxO2qLgeuSwd7OG0xM6FAwh6hSk6SGYMzfUiIyUIGQDHjWZ3oEHWvuwUfTaUpQxsmovsW6EpP+hcsLAzjQWJ+Vy8bS2qsOR/Ax4SXWohzOs7Vgd246gWVFi90MjBf5cptj1endkHhMfmlkuR6ca097s3vzCMq+hyzNVj2WVcEJBkPiRtJeWj7hwphNDd1oO0JOhHY139F0Bj6YaVW6i66JbnDhtqWILNGfqxbL+YbmhH1SrNa4AKKBH38ZAsJSU3N1KOtfzcz0UCUHoaxslxjFl/GI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S2taYi9PeW42MnZoai94MFJ0R0JuZjBRSnM5bHM1TlQ2ckxWN2o4T0wxWjBu?=
 =?utf-8?B?R3BvV2JOdFZpUGlBT3c0SVYrbXQxVWpGbzlBQzFnZHhacStONHh4Ujg1VVBv?=
 =?utf-8?B?OStVNHRkT1J0U0JkbW9hOS9LTnVDczhvSVlxU2dvem5Xc2NTSGh0WDNQRzFY?=
 =?utf-8?B?WjBEVW1xSFFLODFmS01jMDdMSVNoWW1ETktiQlhoM0FSNGdCeDdLdEMrMjhZ?=
 =?utf-8?B?amRYVC93Y29sSytseEZJVDNDTHhYaGZuek5kTmk5ZG5BWFpiTFh1b3BObHZN?=
 =?utf-8?B?bzVHQmdFeE16eUF6YVZsWStmZFZyS25OT0IweEIrQmVNNjhrZWZ2WlZJUU5N?=
 =?utf-8?B?Y3pQQ1pzamZPVFp0SHErVDQ2R2owUEUxV2UyZDF0eThrUkYvc01hN3Zhd1BU?=
 =?utf-8?B?cUZMWVV5VTk3RW1GMUpISlVvN2RKYmdVamhMSGhTOHRMTVBqTkFXeEY3U2Qr?=
 =?utf-8?B?Z2F0VFJ3TVpJZGd2OTVsV1RPRjV4NUJPc1p2ZzN6MlNWejQ3U21qY241aXV4?=
 =?utf-8?B?U1dITWgzRGZ5VVhqZDZydUQzQ1l2WG92c2hhQ1lLeG5zVk1sbXpjOGlqMVdt?=
 =?utf-8?B?WmFrL2N0VC9TeTB2ZmdCQlR1amNwb2dVL2JCbnhXRzI5U0ZxbkZhQ3ZCY3Jj?=
 =?utf-8?B?WkZNWXl4OFlDYXZJZ3Q0WmZlNktjcHpuUC90R3RsQmNIV2t4KzdiZVFBV2dr?=
 =?utf-8?B?Qm5QRWdaazB0MmpTVGVwcElURGszc3IwU3hTNTlpeURuaDFiczNMd2N6Qk5T?=
 =?utf-8?B?ZTJwU0RmbWFzTyt4elJzRXh2eXVFUy9BNEpVNXRyeGFJeFNjaEF4U2Z2eUNo?=
 =?utf-8?B?bFJQckNIaTB0Z2dlQjExRlc3VnZYMnpTMDNHRGJ6UG00MWxmcVFUMyt5ZVFD?=
 =?utf-8?B?dXI4cGp6Wk5rdHA3QWNFUVRnYnNqSVM1akErMnRXRVJ0cHkvV1lkSTB5dG9K?=
 =?utf-8?B?aEJmV2FrejN6aVJpdG84c202K01ZcldPT1RWV0ZnMUJZTExWNm5JMTUxaGVQ?=
 =?utf-8?B?dCtSRzVTSW5vSlJzL1pyR0tBV2RwdXY3clVteGZQNk9RTE9iQWlDM3lxa0JP?=
 =?utf-8?B?S0ZZK2NDMlNoQTdnQzN6ekdlTG1ibmdHR1ZSci83TXZoTmlBbkcwMmRlQWli?=
 =?utf-8?B?R0VmMDhtT1JGMkkxUTNiaUF4KzFIZSs1ejBJOHl2bWJVeC9CTWpuUUw5Nkxx?=
 =?utf-8?B?VitDRHFIeFBXOGJqaEtwcW8wSkd3UE8rQzJjSjBtSXNJeGJLZFlzMXM1VmRJ?=
 =?utf-8?B?WGdDcFkwNm84U0R1eFpWMUhZamI3UmYrSUU2SmFBaHlFREtWTXN3VDh1N1oy?=
 =?utf-8?B?SW9Ec2ZqOXh5dHNQQ1E2NnpPOGlwTHpLT0xVTS9qYW9VT28rMGZtWktiYWFo?=
 =?utf-8?B?bkhWeW41NVl2VGZ4WXBZN3dqWmNHWUI5TlQyVlE4SEZ2YnBNbGtJeU5BQ3kv?=
 =?utf-8?B?aHhFdHp0QnNQRUduOWNSb1BYSTdNN2NVT1RvaWdxQ2x2UncyTnE4dFMreVhK?=
 =?utf-8?B?Mko0cHUvbDYwajhPcXNYQis5aFczY2pTRWZ5ZXRxMmR0TnlpSDhRN1RESytZ?=
 =?utf-8?B?b2FYRUhxMzYvTnNQa1EzMVVBSXBneXpyR1czWTJjNFR0UVZZUVhVZFZQZjZW?=
 =?utf-8?B?YVNNQTBreGpBSTZMU2FRVnZPM3JvRnI0K05rdzNuSjJZR1ZHd29IZ2xiZU1m?=
 =?utf-8?B?U1hPVmtST3JUQjdNQVFLZzZuMmFlZEtPOVRhWjVDcDZHYTNhSEZtNUhCUlRt?=
 =?utf-8?B?UzltY1B0U3h5V1Y0Tzl3d21BSWVXMkdkbkttYThFaUdFYzF6TVhWZEdwRXpj?=
 =?utf-8?B?c1RudWtnZmNCczI1V25RZTBqT3d6Y0NTejNNcThqSnAxT1RnZWsrN1ZnVlJW?=
 =?utf-8?B?OTh6ZEFQNHcybHRFcXNhaDl1Y2NUVGF6ZGl0STlQL0hPZkhPUDJiT1puWVRv?=
 =?utf-8?B?aWVsSDBtUGJ5SHp6N3llVDM5NS8wUTZJSTRXNUtKMVdMZzlNRmNUcjUyV0pi?=
 =?utf-8?B?aFJVUFJ1d3JqOWgvS1F2aEVqRWR0YkdvREhSaHk1UldwN1hZcW00WndwTTE4?=
 =?utf-8?B?bkpTdzNCdnFSNjBOenJZVU9JZHJlZ1UrZE5sYnVSV0tMQkcwbGp1cDJaTWl2?=
 =?utf-8?B?ZjV1UDhlN3kxUGtqNStzYk9wUnd4T1lzS21HelNDR01hRG9ta0VhZ3RmN0FI?=
 =?utf-8?B?aTVCUk1qbW12NTFPQjNPYUZ1K205Uyt1S0drdTg2TDhvVlF6bWxSdzlROEdE?=
 =?utf-8?B?blRzSDU4d3o3Ty9SSDh0NUZoczhrdVA0U1lBeWVoek5Lc21LbkFubDEyY0lQ?=
 =?utf-8?B?L203R0JSUEJjSTJpWnZUTmJSZHNlci9rOHVmcFlVSXBvKzY1Y1ZPaENVd2s1?=
 =?utf-8?Q?YCPhx5M+54QFWEcuBA4Z3gzy+bdlbpfOqXI2W7abwC1DC?=
x-ms-exchange-antispam-messagedata-1: cvm8mS+W6q165oYVEaUmhOkvfxUdWcMBx3E=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F65815B219EE504CB7E671A3D14862FE@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	V+OMiHWai31CFkQMkdz+m1xPDd/0ohTTgKb+6uiPpy0jWS/33Q+uQ/2C+3O6lzBZvCn1xVs1xpKH2WVRvAWZR/RhCPzsgXrsAKawtFjGlnk8G7SCAFKxnA0Ai133eYKI2PACZ53/aBsum1wzl7yIV8TlNqadAyTKoepImSj2RrzyaiGY3NQF8prqteb7AFlA0GSwOaBk6tih50bkDmUx6LcGPNcWrF70NrtdL5wjsz4LGAy/aPITKB5I6R9bnvIU4FN789RRmbrfMIbY/HIBHhSQiqDtQwrHWXCo6aDxlBDLC3Qcjp9pvNcB1PvaOyHWdg58v99JhL9B/KsYkpkAdw==
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de62e454-8b35-46f0-297b-08de7957c009
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 19:04:52.3976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZFfeldhvRd5HE5gOvDfv3H7ZfspIhIs/QBFqWMO7+R+VR7KvPSLgr9bj+3nG5w8Vl9Zu13uUVfGqS0+VnaHOESykNP6PJTH9SIT2Oj3g/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8598
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAzMDE1NSBTYWx0ZWRfX4Hz7wMduNSdY
 +81tL+0IUgzwTLb5JXb9YjrcX+ZAdKKnZq+jgf65zAKyauMHBL1Km2kb0zZ29TwpZUABKztfdPM
 mrn0dUSyNuOtC7Je/O/YOsE7h8ihseaeA8Bo3UHa5LwT2sBzFQ023WCmgqLqPkVGuu/tunJ643F
 JSuaQY6WK3Gzq+m2Z5eUC1dcoWZcfejyKJG61D1T2UhT+tEER2qe7q6yCl+jY3ThmrEqIgu7P1Y
 zFfCalc4v63RUj2cgMDF6kFSYmak/mpqdwbHqNsDhw2mo6Mh3InOfXLzqnO4suGFxK+Ics3p6Nx
 xd7jSobTzHWB4XDEwpyQa6N5Qa+eX119KPvD6wHZqiUsHP16cmZ0fSlzxcoZMXkiGbCE5sT+HiY
 E7Z9qM8/mVdK31vN1OHgEfPcMFEqQrfnDteNBkB0Gs5h7b4pIMPf4GCkn7tr1r09+xxIwDjHNLR
 GKAB7dnMOvBgrQm/J+Q==
X-Authority-Analysis: v=2.4 cv=YOqSCBGx c=1 sm=1 tr=0 ts=69a730d6 cx=c_pps
 a=aZOTJIJ1i17uwAYHC389yQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=20KFwNOVAAAA:8
 a=fKkDrsfPm87_V-rcrTwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 5bDfEs0PeJU42YuRMqJ5IqfzP1K8Vu87
X-Proofpoint-ORIG-GUID: 5bDfEs0PeJU42YuRMqJ5IqfzP1K8Vu87
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-03_02,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Queue-Id: C75201F5B41
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72570-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	DKIM_TRACE(0.00)[nutanix.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jon@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

DQoNCj4gT24gTWFyIDMsIDIwMjYsIGF0IDEyOjU04oCvUE0sIFBhb2xvIEJvbnppbmkgPHBib256
aW5pQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gMTIvMjMvMjUgMDY6NDcsIEpvbiBLb2hs
ZXIgd3JvdGU6DQo+PiBFeHRlbmQga3ZtX21tdV9wYWdlX3JvbGUgYWNjZXNzIGJpdGZpZWxkIGZy
b20gMyB0byA0LCB3aGVyZSB0aGUgNHRoIGJpdA0KPj4gd2lsbCBiZSB1c2VkIHRvIHRyYWNrIHVz
ZXIgZXhlY3V0YWJsZSBwYWdlcyB3aXRoIEludGVsIG1vZGUtYmFzZWQNCj4+IGV4ZWN1dGUgY29u
dHJvbCAoTUJFQykuDQo+PiBFeHRlbmQgU1BURSBnZW5lcmF0aW9uIGFuZCBpbnRyb2R1Y2Ugc2hh
ZG93X3V4IHZhbHVlIHRvIGFjY291bnQgZm9yDQo+PiB1c2VyIGFuZCBrZXJuZWwgZXhlY3V0YWJs
ZSBkaXN0aW5jdGlvbnMgdW5kZXIgTUJFQy4NCj4gDQo+IFdoaWxlIE1CRUMgaGFzIGEgZGlmZmVy
ZW50IGRlZmluaXRpb24gb2YgdGhlIGJpdHMsIEdNRVQgaXMgZXNzZW50aWFsbHkgU01FUCAoZXhj
ZXB0IHRoYXQgQU1EIGNvdWxkbid0IHJldHJvZml0IGl0IGludG8gaENSNC5TTUVQIGR1ZSB0byBo
b3cgTlBUIGhhbmRsZXMgdGhlIFUgYml0KS4gIEkgd29uZGVyIGlmIGl0J3MgcG9zc2libGUgdG8g
aGFuZGxlIE1CRUMgYXMgU01FUCBhcyB3ZWxsLCB3aXRoIHNvbWUgYWRkaXRpb25hbCBoYW5kbGlu
ZyBvZiB0aGUgU1BURXMgKHdpdGggc2hhZG94X3hfbWFzayBhbmQgc2hhZG93X3V4X21hc2sgdGFr
aW5nIHRoZSBmdW5jdGlvbmFsaXR5IG9mIHNoYWRvd19ueF9tYXNrIGFuZCBzaGFkb3dfdV9tYXNr
KSBidXQgbm8gbGFyZ2UgY2hhbmdlcyB0byB0aGUgTU1VLg0KPiANCj4gVGhpcyBzaG91bGQgYmUg
YSBtdWNoIHNpbXBsZXIgcGF0Y2ggc2V0IGlmIGl0IGNhbiBiZSBtYWRlIHRvIHdvcmsuICBJJ2xs
IHRha2UgYSBsb29rLg0KPiANCj4gUGFvbG8NCg0KVGhhbmtzLCBQYW9sby4gQ2VydGFpbmx5IGlm
IHdlIGNhbiBtYWtlIHRoaXMgc2ltcGxlciwgSeKAmW0gYWxsIGZvciBpdC4NCkkgYXBwcmVjaWF0
ZSBhbnkgaGVscCB3ZSBjYW4gZ2V0IG9uIHRoaXMgb25lLiANCg0KSGFwcHkgdG8gdGVzdCBvdXQg
YWRkaXRpb25hbCBhcHByb2FjaGVzLCBhcyB3ZeKAmXZlIGdvdCB0aGUgV2luZG93cw0KcGVyZm9y
bWFuY2UgcmVncmVzc2lvbiB0ZXN0IGZvciB0aGlzIGNvbXBsZXRlbHkgYXV0b21hdGVkIG9uIG91
ciBzaWRlDQp0byBzdHVkeSB0aGUgaW1wYWN0IG9uZSB3YXkgb3IgdGhlIG90aGVyLg0KDQpUaGFu
a3MgYWdhaW4sDQpKb24=

