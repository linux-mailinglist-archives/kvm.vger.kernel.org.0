Return-Path: <kvm+bounces-46286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB2A2AB4968
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:18:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6530219E6183
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9981ADC7B;
	Tue, 13 May 2025 02:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zvJ4LV1b";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FXDpDr8p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320AE19AD8C;
	Tue, 13 May 2025 02:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102723; cv=fail; b=EKL1rJVXm5Uvq1GvoGcIJjzOLzf/uoSL6IT8lmpQjsDNH82NLYafwHU2XqRxxxusoq5ndaH1PKgzGw+KbdSYNyNOMRepVHeQhfgNms/YfC+WGFuQhMKya4uHsYr+tEKgX3Bw8Wp0CD0is5ocljKIfFX93PVNjEqEMf874w+Y0Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102723; c=relaxed/simple;
	bh=q2bxOBd8fA7eP2RoXSodeVtsPSdp2dP9xPj5o7hxub8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hcxVIzgAxkPSZrEUButAfTXxCSUMybYKm61Z1xPpvXKOqeOb8EMKhzXWxWLjvHxfhoj+Y0Z/Bgkk0SpAt44EznvTaEHE5tLGT++f5ftyLPo7cosQOiLnuqITiPU2/bgnVn2rbSPiPOQhTe9YxfeWB8c5M905HPr8rN37IqiEUNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zvJ4LV1b; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FXDpDr8p; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CJxFBt023340;
	Mon, 12 May 2025 19:18:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=q2bxOBd8fA7eP2RoXSodeVtsPSdp2dP9xPj5o7hxu
	b8=; b=zvJ4LV1bMBlj7qO9MbGbalDJ+pagVjLrVRTEWNZG0SADS9ngVS/I0l8Ni
	cz1+io3QbVUXWhOSPpkUMpaQ0hdJe/rjP7mC14gBcTHT7sXImOytL4/HQWa28oQx
	Zge2ZkmoEOlVpA0N1X2TKQg6/jNYdvX4puQepbcSqdYYZGE8tjS/I36wCC2zx49k
	mQyCxCUENbvWqfzFqUQirbZx6h1MiQLIWrEqwaaXwCalfGhOo05rueaKF/avfIm4
	sXV6PEB4a/93BuZrYjusWm4Ym6EXEXcWI9qdZRQ8sh9IiZuP9exQnmlrYTXjib5f
	LNx2ZsM6JlNH4z5+IGkoLFWXewtpg==
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j4bb4qwq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:18:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J15ID5OH7Ab8Mtand2PJkn82e/Dx2P3qk+RY1oBfL0AgjC4mVOb+sqxIL0vro0dJBxUvkwjkSrIuU3ct+s4L+qMcpaK9c36MCC1T8UNGTU30qRmlkkpG7s/JqiD2Vd1hGYgvZjt2SIkDV8x4f4/HupWVz5dNXxtbANjYTTiJhuLJHnc6jBU7maa7Ervy85ayvTcpcDak+mrUStLONb+qWf+6kCY6oUp7B7ANVHCxZWP7tWfcK4PiQil/i+dwJ4XGXcaBP8W46fJEyN1XId7I8X2h3jXiYyXW88usRgp2pvb/kXY+0eV6Dwmu/j36ZoIM8nDPKyl39FRu9N3eEa59SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q2bxOBd8fA7eP2RoXSodeVtsPSdp2dP9xPj5o7hxub8=;
 b=ZpSkS4txCa8jaEvXmqh+c5C4iok3Te37mm4VNNSxZUyQXvari64J1v46J4Zl7JKXsmCAHWcWvwsiOup3HylHY6qmTd+HG6UUCHn6XyOhzmdW+hGgtopna21SBfsscXy5awQfoPAPQ8+Bj92oTZ14XBO26ttQpM+rc1cxTDJqg+VSv8gRnlug+kMYsTKJgT8N/qS64kbQaCAwx2LvERBhEO0znprFN0U0Hcl/NiY8Bu7HgpLhTbVml0ME+soXUS2L/6ZV6MBB4e0foAN5CHpLi6ZdwXpT7yljdkcxErwCbKKZ5CpTInKNfw69qj9qfTPR/0WyqDvU3s1hJzqONiDOHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q2bxOBd8fA7eP2RoXSodeVtsPSdp2dP9xPj5o7hxub8=;
 b=FXDpDr8pwtx5ptZi9UWRFKFPAuRWc+xogBb0S6/qXRvwWygWsRQPxSg4mBNhStUiOBqzxq6nc8oOfklk0seeSoRtMCgLxUJehnwLwzLQ8W7FNaavwGfwH7kRhzap2lpPCwKcFtUUVenNoREewp7xFGuW5Cf6sBJs6sT++9YUIye8dNCOUOJksYrpVHt38eQztFbcQ8pv4v28M9uIbsAlDfVOoD3cwsmS0n1VGj9yZ4Ftd/cvUCEuQ7zc8wPFTWVnEmwykV3wMhnq3/gSMTSIkMwlLiJB1R2zqLpSP11sqt3XFXlcpFUac0+sJv9OAx+zMS1Pdxc3LjHJj9fVB8LkQw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7151.namprd02.prod.outlook.com
 (2603:10b6:a03:290::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:18:18 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:18:18 +0000
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
Subject: Re: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Thread-Topic: [RFC PATCH 03/18] KVM: x86: Add module parameter for Intel MBEC
Thread-Index: AQHblFPo9Ax1PZfsL0GVCsZrrlSLcrPPqPiAgACI54A=
Date: Tue, 13 May 2025 02:18:18 +0000
Message-ID: <9B4F1C6D-05C1-4CFF-ABCA-3314E695894E@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-4-jon@nutanix.com> <aCI5B7Mz8mgP-V2o@google.com>
In-Reply-To: <aCI5B7Mz8mgP-V2o@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7151:EE_
x-ms-office365-filtering-correlation-id: 38683688-30eb-48fe-1b7e-08dd91c46cd4
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZUNoYk5KOG5rRW12VXoxcHRKUFNVY0ErR05OaHFybVdSanpkZmhOd2JVRkN0?=
 =?utf-8?B?RXp2NVBraG0wb2pMK3o3b01HaGhLTEl2Skc0VmZZTFFCZWRXV1VRQ0ZFNWZK?=
 =?utf-8?B?YmdETXI4OHNtMEpaeThDUGN5U3hzVXp6d1pLdy9ITnNDQ2Irdnd5OHI2OUVC?=
 =?utf-8?B?cEJSK0ZIdFVkK1cyam1PTG1KQjNIaHc0OVNnMVltaGMxWWdKSmhkYWQ5OTJ4?=
 =?utf-8?B?U2V0ckZoeGZQOXJrRVQ1SVNDQm5HZUYrQTVHaEFmUnRTdk0wd3UwZDRWNnVX?=
 =?utf-8?B?clFUSzJvSHFSTVc4eHI3M0RNRkV6eDBWbTBsNlpteTZMam1hbE1EWE9BM0pk?=
 =?utf-8?B?TFppOHBQNXNGUVQ2UmU1TldkcUtuVjJ6dmNzT0ZXYVVVakhBU2duM0JhL2I2?=
 =?utf-8?B?dFhTMUcxNGgraWwrMnQwdlJGMW4vU1EzVHYydG45cUpUTUdPRkhLNlZQeGFq?=
 =?utf-8?B?REtQamtPQkxaYnRCZlBzQVNpanltZVRYS3NEWjFCWW5tS29WMXZyQmxHNXha?=
 =?utf-8?B?OHNtZi9sUFNGMDlMUWEyM2dHN0pDeW1CeE1WMTBjQVZWbzNQeHZvSGdjVXJP?=
 =?utf-8?B?WDUxTHBIWnBLbmJwejJFTkg5K3lHVzY4UGVUYUhUSzFyYXdPVTNodU9VcnVl?=
 =?utf-8?B?RnkrYW52aFNPMmJkcHkxWTdFbWNuNzlDUnVMYjlYaUw4NzhHN3B0RTlqS1JB?=
 =?utf-8?B?b1FGci9TRWhHSUI0bU5xRmlHcVEvcncxTDNzU1daYUM2OEcwRXZqZjZoZkZT?=
 =?utf-8?B?d05udUhaaGhJSEwzSExqQkVFbnVHdXlyK0UreUlnZmVGMFVJTzhxRWxnWDRF?=
 =?utf-8?B?dk9hUkFQWkRiV0l3Vmt0dTB5bEl5RUN3SktIV0lLWVR5VW1pWlUvK0JyS3NW?=
 =?utf-8?B?aGZOd21FeFZCWWdpTmRJMEtTbHNTcTc5TEFSTGhtYnIzVEhVdkpSdkVMU2tt?=
 =?utf-8?B?WjZXSEFsdWFOdThYK0VieVR2OEhoVUdPRFpTMVl4c1p2YmorYVNtSm9ueUlU?=
 =?utf-8?B?N1B5SDJwdDdETW5xZWE5bklUVGlsVmRYdUM5Q0tCQmt3bjJxbG13eHQxRXdn?=
 =?utf-8?B?RVd5eUVpUVM2OTZqazVjTHRmdVpnSWkxai9KMUMyc2wwTVpjbHRmZG5OZ3Aw?=
 =?utf-8?B?a3A3K0NhRUxnNzVrZ2ZVQ1I1ZGNYNTVpWUh5R3o3RCtQd0FSU3NnMWNDVHI4?=
 =?utf-8?B?anU1YlI4MlNEMmlWWm1vVXRid3hTM1pWYWYrWks1WU5QZHg3ZEZCQXNYb2xE?=
 =?utf-8?B?dWU5N2l5TnNCaWNtZTMxc3Vkb1VmeVh6V1pnSkdsY2tXWndjc2gvQ1JUK1V6?=
 =?utf-8?B?TitQME5wNnVBYUtJMTdjN1M0TUYxNDhJOXNncFRWbUFVQWR0cXVENlMyY0xT?=
 =?utf-8?B?QlpqTDJGR2dYMkNtSHU2Tk5sZXMrSVVBVThEVDBoR2FXMGVsTUpnaWZ0YmRl?=
 =?utf-8?B?WWtQajdjMHhoVjZYd01FQ0VxTGw4NWtVSTJJc3QzUlE2Y2QxekthNkc2V2cy?=
 =?utf-8?B?T0dSUi92ejgrWUp0RTVDNk5PWnRGdEpoMURsVjYzT2I2QmRDT09UV0VrVEMv?=
 =?utf-8?B?RFFmTVJuQmdrNjFqUGJuaTJwWURhRU5nc3VSY3Q2S1M2UVYvaVhKam9CN1FD?=
 =?utf-8?B?UFNZekF4MUV4VDhRU2JOTEtMVHVMOG9IRFRaeW5sd2RFN0YwbFUrd2hXbUNZ?=
 =?utf-8?B?N0JPZlNRYTI3c1M0akxDYlRGMmVjanZnOHo3bnlFd0RXQ0thNVJVQ1BTTTVS?=
 =?utf-8?B?Nm9HcElRWHNjVTM4YzEwd3pxL1hNODE0djJtSU8vY1FjVWpSSHZCd0hCdHc2?=
 =?utf-8?B?ZlV0T3oybElNdmYxREs1MjAwS1dXL1AySEgwT0NyTU9FVFFPa0hKTnVsUm5h?=
 =?utf-8?B?akp4U1RYQkJnTjR1VzllSnZ5cWFsL3M1V0tERnlkdVRTSWdFTEVDNGZMZVpP?=
 =?utf-8?B?MnhPTHBxVTZmajJaVjc5T21EbTkwTHhuLzd6cnk1V3pPakV2V1huQkdMVlhF?=
 =?utf-8?Q?KICB5t8TaxCbmH5StsOs3AzP8deiU8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MUIxUUk1d1FTR2pWdVNMSExIVmNRdDc4RnJZdndzbGlvNHFqOTF3UEFKV2hi?=
 =?utf-8?B?dXc3WnpFQk5xZ1ZyQXJzbkRsRWlqUG1TV0VyVGxJeDd4RmtkSTVaWklnM1Vx?=
 =?utf-8?B?SEd5QjRESXpMZE9VMGorSU81K3hEbS9ieFFTZ3BCdU51Tnc5L3pvbVhtOFdL?=
 =?utf-8?B?R08xTjNpeUMvQVBxR05TZmFlSnFUSjkxd2xML3pvd2REUjNQQW9RU3JQdHhB?=
 =?utf-8?B?YXk0U3dsWFZ4OFlJeXRySVg5Z2lxc3dzcjIrREpLZEs1bXdqYk1JdUNESVQ3?=
 =?utf-8?B?TVhDUEpMRUdCSytwWjdLbnZRcFZTUkpwK0pUazVyd3Q5aVRzNmhkZUlPMzRy?=
 =?utf-8?B?WU0rTEo0bGNwdXUyVFZLeTVwcWhOS2p3K0JMN0NPQVg2eWs0UGY5Q25NTTRq?=
 =?utf-8?B?SjkwREJQWlVXaGRUbmx6eHNBeWZrQWVrcjExLzFGdzJvYzdRNnBsQ2QxVmtQ?=
 =?utf-8?B?Ri9yemhXNGJaNnkwMTNWSXhsZ0xNUmdPZnhPWDlsUFJEcC9leC8zdFNNcGNE?=
 =?utf-8?B?Ym81SjljbG9TdWJRRlNkZ09razd1bjV0MXZ4YkdiQlJlUi96WGlweG83MUl5?=
 =?utf-8?B?bDdkTWU1U3AwYmNSY2VJU29WMGhUVkQ1eW95bDJOVW1qc3A5TFNodHU2K1ZT?=
 =?utf-8?B?eG1DWEhhTDRabm45VnJWcGxDTmZ2WjI5dmFNWlhYSFpaRmczelBrWGxXKzlt?=
 =?utf-8?B?aHZIR1dqbUpHWEJqWjAvcWE4bFU4YnpzUGlGZlh3MU5pUzFBSXNsOXZKWUFZ?=
 =?utf-8?B?NVBqaWhQQVJNQXgwSzJ5VzNEMDBvdW85dVRFRXdjWUI2eE1id09kckJEcTlj?=
 =?utf-8?B?TVVrRXF4bWFWVFF5RWlGREdiNHhtbU9rTEw2N1lJdGt0ZGZWR0xoWlpqQjJ1?=
 =?utf-8?B?MWlMcmNqTUhGc2p0MVJGbG9pS2dxUk9zMG41M0hVcmlaVDA0cVR5dHlEM2Qz?=
 =?utf-8?B?QW4wUHkxeEhuNGw4dTFDVkFROHFOSTJmTWdmMHhpQW1Ja2d1NndEa0VWN2cw?=
 =?utf-8?B?UWJsUXE5K2s2VjYranlpUzFWZnd5TlVzdG5FRmpzWitjTUg0amtXUDlLL281?=
 =?utf-8?B?bWRQUDM5dUNIeG9kcTIrK0ZCamFrT3d5Z3NJeHljK2dMK2RUWlRKalBLWUxR?=
 =?utf-8?B?YVp6Q0R5QXkzdVFWQ0ZPNyt4dTFySzltZ01oTC9lY3RUNTBteHUyUitNWlBh?=
 =?utf-8?B?TW1TaXlOUVVLcUdCQmJKUUtQSUlkYWlydDYwWnczNWZWemd3TEMwTHozaDZC?=
 =?utf-8?B?VjNDQTdOb3BHamc0VlpBdkVRTEw4VjJIdTJoeXJjRWxmZTQ0eklTbGdMTVlG?=
 =?utf-8?B?SkI0dmdrTW9nMzh0U3JNZmJqZ1A5S3dRZXllTzU1NHU1enZzZGJwcVJoZGpR?=
 =?utf-8?B?VExXcGxDcVpOTklaQ285QjBBciszRmhvbjBkTmtsS1c5dm5FTDJpTkZDNzlP?=
 =?utf-8?B?QkViNVNuUEVSaXY0aWxmaDdHL295QnFLVHNiOEhKbWNEMWJ4YWxDeEhnY1ht?=
 =?utf-8?B?Y0hlcWMwbUNJR05wQm1iblZtdkRXbHRHRUFid0gwd3ZyUDQrTW1jUG1ITVhW?=
 =?utf-8?B?OXFRL2J0SnpRUkdLbDdCWUMySmZmVENKSEdHWmwwL3VSeTltZSs2ZDMwZEFJ?=
 =?utf-8?B?c1VycitZYno3d2I2UlUwSVcvY0NKbHI1dWU1NFVwK090TDJnRzJTWmNCMFY1?=
 =?utf-8?B?RXBDcEFmZVB2ekhIdUpTQ2J2ZGt4Sk1hNXJHa1UwbkNjR3VKRFhHWEZVWi84?=
 =?utf-8?B?TjVVaXptTnZyU3dnM1o0dkdxbnc1NnZVeFVtaGlCQnhXRi93MTViMWQ2YXIx?=
 =?utf-8?B?WXRHclBsRlNDOC8vdm10d3NDVFdWVkdWMHZZazFLOGJZRGRCRzlHTjBMQjRw?=
 =?utf-8?B?NzFWeDlQZGt0U0hrdXdTZzF1OTYvUlBWUEhwa2hGMVFRbVcxV2JrUG5sTjRm?=
 =?utf-8?B?czJndlQvZTlzWDdNb1RDMEtna2lnd3JhanN4UkhFMTdERitjbXRTb1pSdzRY?=
 =?utf-8?B?SHlGQm1jc3hhbDB0Z0U3ZjY4ZVYzZXpjeEJqZmQrNmNlOXBEZDRNNXVzczU1?=
 =?utf-8?B?QWhsZXUzN1cvZkFCZHVNdGZoUFpPekhoQ0lDVEdEZVlGMHJFMVl3OVNtOFZC?=
 =?utf-8?B?NGYvVGprWGNRSllFS0JMN3hZbUwrdmF1azRRb1hyM2VmY0k4c1RkNDRXMDRz?=
 =?utf-8?B?b1NDRFRuTlIvcW5XOG44d1JLR0w2a3QraXRILzNQOFV3QjNSbmNDbVpnam9N?=
 =?utf-8?B?TzhvR1J5UnBPVmNIV1hCeXRVcHl3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <600853C26DA5874E9CD594BEEE767347@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 38683688-30eb-48fe-1b7e-08dd91c46cd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:18:18.1561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hv12DgmLuSsidqKclrv+3GJEtTTVZPr7POj4jK7hG1zecVLAF3MLseawzUAkPl7FDgvFYl51EQ+0bNZydH7oFr4TL73cJHId+sIx3Xwu+ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMCBTYWx0ZWRfX8TKd2S+/1AM0 C9hABXWJHAKAmU5aodMnQApkBIKTYGa3yH4O8uRh1gbSJLwp51FyOLkdTwPJGqvV8j7Cc7choRR awLZEWaENngSncWeD74H1rC8/PJZYkN/qvBp4xl6PcrdRAhlNO4AaxqldT7dhgUDP/G3Fxag1Wg
 9AnxOzgNX0/4KueBjRgcoh7aYFV3PfNzP+iw6YozsNvFJdip7XFq0+V8WkKkps3+tsE7ZLsDxj7 YpFHZS5V0/9wK2IptKluRYbUCrBGmZqmRYV+EODEUzpR2MJYnEPx7Vxi/0VdykFglkkMYwfV5HG NnzNTzKyolI1W+Wk+DQqIMvRG/Rtm0B/WiKcCmhwoD7hp5bNUnStHNgR/7Q4BxVETyksuUZcmIA
 c/wFgXkHaw022usFpxXTPo/lF/YgjmvQjFj0lwfI3EG36ykav3DRBaKhg5gxjgWn4a2dpc6Y
X-Proofpoint-ORIG-GUID: IjEsRZioVhKjSRd69jsUuDyF7Nyrff9i
X-Proofpoint-GUID: IjEsRZioVhKjSRd69jsUuDyF7Nyrff9i
X-Authority-Analysis: v=2.4 cv=B6K50PtM c=1 sm=1 tr=0 ts=6822abec cx=c_pps a=2bhcDDF4uZIgm5IDeBgkqw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=pwqPN2CfIOQqU-GuvW0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjA44oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBBZGQgJ2VuYWJsZV9wdF9ndWVzdF9leGVj
X2NvbnRyb2wnIG1vZHVsZSBwYXJhbWV0ZXIgdG8geDg2IGNvZGUsIHdpdGgNCj4+IGRlZmF1bHQg
dmFsdWUgZmFsc2UuDQo+IA0KPiAuLi4NCj4gDQo+PiArYm9vbCBfX3JlYWRfbW9zdGx5IGVuYWJs
ZV9wdF9ndWVzdF9leGVjX2NvbnRyb2w7DQo+PiArRVhQT1JUX1NZTUJPTF9HUEwoZW5hYmxlX3B0
X2d1ZXN0X2V4ZWNfY29udHJvbCk7DQo+PiArbW9kdWxlX3BhcmFtKGVuYWJsZV9wdF9ndWVzdF9l
eGVjX2NvbnRyb2wsIGJvb2wsIDA0NDQpOw0KPiANCj4gVGhlIGRlZmF1bHQgdmFsdWUgb2YgYSBw
YXJhbWV0ZXIgZG9lc24ndCBwcmV2ZW50IHVzZXJzcGFjZSBmcm9tIGVuYWJsZWQgdGhlIHBhcmFt
Lg0KPiBJLmUuIHRoZSBpbnN0YW50IHRoaXMgcGF0Y2ggbGFuZHMsIHVzZXJzcGFjZSBjYW4gZW5h
YmxlIGVuYWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2wsDQo+IHdoaWNoIG1lYW5zIE1CRUMgbmVl
ZHMgdG8gYmUgMTAwJSBmdW5jdGlvbmFsIGJlZm9yZSB0aGlzIGNhbiBiZSBleHBvc2VkIHRvIHVz
ZXJzcGFjZS4NCj4gDQo+IFRoZSByaWdodCB3YXkgdG8gZG8gdGhpcyBpcyB0byBzaW1wbHkgb21p
dCB0aGUgbW9kdWxlIHBhcmFtIHVudGlsIEtWTSBpcyByZWFkeSB0bw0KPiBsZXQgdXNlcnNwYWNl
IGVuYWJsZSB0aGUgZmVhdHVyZS4NCj4gDQo+IEFsbCB0aGF0IHNhaWQsIEkgZG9uJ3Qgc2VlIGFu
eSByZWFzb24gdG8gYWRkIGEgbW9kdWxlIHBhcmFtIGZvciB0aGlzLiAgKktWTSogaXNuJ3QNCj4g
dXNpbmcgTUJFQywgdGhlIGd1ZXN0IGlzIHVzaW5nIE1CRUMuICBBbmQgdW5sZXNzIGhvc3QgdXNl
cnNwYWNlIGlzIGJlaW5nIGV4dHJlbWVseQ0KPiBjYXJlbGVzcyB3aXRoIFZNWCBNU1JzLCBleHBv
c2luZyBNQkVDIHRvIHRoZSBndWVzdCB3aWxsIHJlcXVpcmUgYWRkaXRpb25hbCBWTU0NCj4gZW5h
YmxpbmcgYW5kL29yIHVzZXIgb3B0LWluLg0KPiANCj4gS1ZNIHByb3ZpZGVzIG1vZHVsZSBwYXJh
bXMgdG8gY29udHJvbCBmZWF0dXJlcyB0aGF0IEtWTSBpcyB1c2luZywgZ2VuZXJhbGx5IHdoZW4N
Cj4gdGhlcmUgaXMgbm8gc2FuZSBhbHRlcm5hdGl2ZSB0byB0ZWxsIEtWTSBub3QgdG8gdXNlIGEg
cGFydGljdWxhciBmZWF0dXJlLCBpLmUuDQo+IHdoZW4gdGhlcmUgaXMgd2F5IGZvciB0aGUgdXNl
ciB0byBkaXNhYmxlIGEgZmVhdHVyZSBmb3IgdGVzdGluZy9kZWJ1ZyBwdXJwb3Nlcy4NCj4gDQo+
IEZ1cnRoZXJtb3JlLCBob3cgdGhpcyBzZXJpZXMga2V5cyBvZmYgdGhlIG1vZHVsZSBwYXJhbSB0
aHJvdWdob3V0IEtWTSBpcyBjb21wbGV0ZWx5DQo+IHdyb25nLiAgVGhlICpvbmx5KiBpbnB1dCB0
aGF0IHVsdGltYXRlbHkgbWF0dGVycyBpcyB0aGUgY29udHJvbCBiaXQgaW4gdm1jczEyLg0KPiBX
aGV0aGVyIG9yIG5vdCBLVk0gYWxsb3dzIHRoYXQgYml0IHRvIGJlIHNldCBjb3VsZCBiZSBjb250
cm9sbGVkIGJ5IGEgbW9kdWxlIHBhcmFtLA0KPiBidXQgS1ZNIHNob3VsZG4ndCBiZSBsb29raW5n
IGF0IHRoZSBtb2R1bGUgcGFyYW0gb3V0c2lkZSBvZiB0aGF0IHBhcnRpY3VsYXIgY2hlY2suDQo+
IA0KPiBUTDtEUjogYWR2ZXJ0aXNpbmcgYW5kIGVuYWJsaW5nIE1CRUMgc2hvdWxkIGNvbWUgYWxv
bmcgd2hlbiBLVk0gYWxsb3dzIHRoZSBiaXQgdG8NCj4gICAgICAgYmUgc2V0IGluIHZtY3MxMi4N
Cg0KR290Y2hhLCBhbmQgSSB0aGluayB0aGlzIGZhY3QgYWxvbmUgd2lsbCBkcml2ZSBhIG5pY2Ug
Yml0IG9mIGNsZWFudXAgdGhydQ0KdGhlIGVudGlyZSBzZXJpZXMuIFdpbGwgbW9wIGl0IHVw

