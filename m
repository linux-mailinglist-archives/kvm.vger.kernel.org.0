Return-Path: <kvm+bounces-46188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A3FAB3C0E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:27:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B733246126F
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BE1923BF96;
	Mon, 12 May 2025 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="c0rcTY6w";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="MewUL5f/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F631E503C;
	Mon, 12 May 2025 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063641; cv=fail; b=FUz9bUNfWmXl+MEhrpuwKoS7Ls1bdUhzxKfKM71A592W5RTruLlllf+JtFS7KqySQD76yFjxSnqPm9aT+hWiDGKaa3eG29UNCTtygMgDZLHAjOEaS7AuLsG+3U25fk3kv7Jz7L/HSWCFJgcNtyfvwU7kbm4XPVeUIzcutdXt4v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063641; c=relaxed/simple;
	bh=et1Y2BLDuQVbLOOlF/GT3IPKfp+5g6yJ9A6Sv3mfVg4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lb4D3b1TtB17dSykgxQD6o/VFt2YtKTjURqacBNCSR+t8txdrDHxnKkfZp2mnK51nNwEfcbkJHhR0JcDGViHgywQzUzYn9N9GuQ757To0BQAEKYa0Rn8JUnot3qQLqCuRCf8mHDCyniOWreFPAL3yd139mCb82Cw/j9ke+SUiBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=c0rcTY6w; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=MewUL5f/; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CE4RwO016414;
	Mon, 12 May 2025 08:26:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=et1Y2BLDuQVbLOOlF/GT3IPKfp+5g6yJ9A6Sv3mfV
	g4=; b=c0rcTY6whpEz2FsVkw/HeavmpZ70MqqkLT9iLYurTSk/P1QlqJd63lRwx
	v8NO7j7adgfZpff+iFgD3+TlNAISYLfJ7kOUCKAKeP7zdjK91/iagu6xr6Ipk55+
	2RO/CO+V0An3G3ZfZyJQxfl2VMDrpgnQ09nSesXW4ubWKMgtqpXAapkAoIA80Fhr
	aI5Uw/Z+P2ZALAg9AGYNrdMDODv4IHK57Cy90k/7OSCYFQ0tF9lDiRIBIhenyD6U
	dDjoZHstIDKHxjaznGs4vZCkAE2slbCm6Y99mEYdhqwtxgW1uVJ8HDtArviEzaKc
	1aUFKmDlOL8nrRfudip3wxZxfHVjw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazlp17012037.outbound.protection.outlook.com [40.93.1.37])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46j5vkbd54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 08:26:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I42DBzYWkGkUKQvLh1+tyL9PEh2TJudAK13cjedxlHZW7Qz8sV8e0HcK6UQHn7hmYs6FEKPbfh4G46Z642ZFuY6y/jD/wvZo+YMRYoDiWnYNQ4gz+FO/SJRGVSwv1+Wg29d8VeKA8pU3MDQ5C3IyTOHtPKTrBfStkGT9sjOtETXgrHFMiELSr5P3i9iAIqm5WW5SIHvp3SAW5ORdnW7RGYlXNQrDLvd9r0+sPX+Q0vrPQ6GmotVXgdzCvNXreUsk0DVcms9euLx2qNy+2S+oDDhPC9bVB5zQNwuMVaHMAsws3T2KjDRkuDv2zOes7izPWim2Wh5fmeCZovAZiS9M3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=et1Y2BLDuQVbLOOlF/GT3IPKfp+5g6yJ9A6Sv3mfVg4=;
 b=KO0HuTvu6DIGQVqZV4GENgAvtNKY24VJ4fzMKIiiVitxm5VztszkzrigoLpSbiZokRywQ76GAB0JBcS1gwURpSx68sFNdW+WhieAw0IeRY5Fyl3SsKl/gDtP1mfkkUaa+MFyGqlTP0fQiYu6drWrrKgNy5BV5rkDTFOmYBENNQ04Z5kHOhxQmzdBJvg839SteVgXxVUi1JBUx9QEB5wop+i1XBHO4kc32ARN7skPfx+yoy46CsNXxsc/JYpM1OgVaJShA1OMdLFqojaxOqLNtvafPsUm1n3uQ3zjZE3nk9SavK9R8y/BDVvoDQpXyBXhXLOzH+hNvSn7K8ZoqFNXsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=et1Y2BLDuQVbLOOlF/GT3IPKfp+5g6yJ9A6Sv3mfVg4=;
 b=MewUL5f/09bOU1Toxq/hWSPwz3yacj/f60ZzaJccVVxpptqjoVYg76HRK6zXBOXN0v2XQb1g5uKvoHDc3OzqAC1AF5kZXma7iufxLiSApUA13cFiBj4BMQldDCqIfTgxLHwkHDuCSVrGh/QdvFBNnAf4t3eq7ASkv7MddIk1SyhTwLQEkeaOkwHTKIzPWaa/FskVl9dPQ417z+gUmUC+sasHbYUvF2rfzd1nYQ29SD4msYOo5FJWFBlL1Q0J6rv7YqWicQCOXCD8jhMm48Y2YquuX5371H0CCIkSMud9DpS+v4r6npyclBptgGjFNQiFWODRC7eZXgMNX7t7b+vb5w==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SA1PR02MB9829.namprd02.prod.outlook.com
 (2603:10b6:806:379::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.14; Mon, 12 May
 2025 15:26:30 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 15:26:30 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Paolo Bonzini
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
        Alexander Grest
	<Alexander.Grest@microsoft.com>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Tao Su
	<tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Topic: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Index: AQHblFPgL0brNbuxF0+4/LV272jmjbOkqSgAgABXlICAKnsHgA==
Date: Mon, 12 May 2025 15:26:30 +0000
Message-ID: <E3D7BE10-0A15-45ED-84FD-9CD871DC0DCD@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250415.AegioKi3ioda@digikod.net> <Z_5weSEpN1rDbYAs@google.com>
In-Reply-To: <Z_5weSEpN1rDbYAs@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SA1PR02MB9829:EE_
x-ms-office365-filtering-correlation-id: c9a667bb-9300-4df7-29c5-08dd91695eb3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|10070799003|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MjRib3B4Wi8zSnFxdHhYU1hzazBHMTU3ZThTZCthQit1ek1UL042TlRVeUow?=
 =?utf-8?B?dkZGbllZL0p4ZUl2ZStBYk9Ja29CeUYxTFp6S3JLdUNuUXVCNjNFZVNIRFFz?=
 =?utf-8?B?UGlwb1NoZ0F6cW1jcGdUOW9RQVJYSnpMQllEM3NNdEdLWGFmUjZUQ3Y5Uzlm?=
 =?utf-8?B?cGkvUFVGSHV5eW9iSVpQNERadFpWaGpSN1NnRkpXZUdDcTFVNFViQTVpWDNl?=
 =?utf-8?B?OTYxQnpSakYwUFNNV2FyQTdSblpZaUpTS1BKa3U5bWh6bzAwbGc0Ykg1dG9F?=
 =?utf-8?B?cjExZVQydzVKWWJsa1hwdkVsTzdYWTcxTmJHTlBLc2ZUd20xaklCeEJJb2Zo?=
 =?utf-8?B?UFpLR3pVd3dFOWMwS2J1M2drSENQeXhJOVB1V2lBOGxWaHlDdGN4Z05xbzVO?=
 =?utf-8?B?QUtydHRXcXFuUVBhYkxIQmFYT0NnTzZ1ZGE0ZlpoK3BrRjFlTGJLa291dkNl?=
 =?utf-8?B?Z0NvRDRWemx6aTg3N0l5ZFdwK2x0TUVuMU1yT0FwOXhSbEZ5dGJaMHd5T3Vh?=
 =?utf-8?B?bWUxVnREWEhHYUVCcDNpRXRwd3crd1dCNElITFMwa0EzdkN3TFdYNUljMFQ4?=
 =?utf-8?B?bVJPaXE5UGhIQ0M3RjZrRmEzTmJzeVhVeVRaem5pUkNOeVZQa3ZWVk9MSm9T?=
 =?utf-8?B?RW9WazF5d3VLTnU4aFV3dUp5a2hsaDJWOGJqR3h5OGdPTkQ3elJBa0c1Sk5s?=
 =?utf-8?B?QVRqUXBZVXA5eWt3ZmxXdTdwQVJTSW0yZlpMR1FDSCsrNGlldWlYMlMydVJ1?=
 =?utf-8?B?UWhia0RUSHlWQVg2WDVTV1RvUFRscjZpT25MOGtyaEFDQ2JBUTZpK0xQU3Mz?=
 =?utf-8?B?ZUVmQnh1dnFjSFBRZThRcHpUZHFsdlcvTndZMzFBaTVRRVpiWTVNamx5MEhn?=
 =?utf-8?B?TXRwdEdNdlJQT0NvZDJ4dnJrNjV3N1Rab3A4bC9ac1VuSHV6akg2RzhqelYr?=
 =?utf-8?B?akt6M2ZHSzBUV210RVN0VDNaUU85cVRqS0Q1R1Q1Qm9jZ2tNTGJwZVBrdFpz?=
 =?utf-8?B?U29ib0Z3TDBXQ0FWOWtkbGl5WGJENkFmNFFUUXdRd1ZzN0xCNW4wWGRnMlgx?=
 =?utf-8?B?VVNPUi9NQXllM3dYWUhXMTQwbFpncDlNMTZINVJ3TjBSdzBlWjdMY01NM3hr?=
 =?utf-8?B?STVtQmkyZG9Oa1JLUVZZQVdLMVpBWnNENm53UlhENGlQYjcyMmh1VW9TakxR?=
 =?utf-8?B?dHVjRlB2UkZPM3A1TFFVR1MvN2U0VjdvWWVxQ2VYTGJUTTRZRHdVRDB2R201?=
 =?utf-8?B?NGJJRWxvMDI2TUJrUS9YVElLbWMrWXFjQjNpTnhEdEw5VW9pOCtNRVVlZENi?=
 =?utf-8?B?VmhDTDZsM3dNQlQwUDFtUjJRbEVtY0huaWtBaU1PN25PbGVZT2ZDYm9PZ3pm?=
 =?utf-8?B?V01SRGM5QkQ3ZkRlRXpleFNHUWpFKzI5N2ZnMUM2bnpuKzZuK2ZCREJuWW9O?=
 =?utf-8?B?SlcwRnc3WDYyOEljTE9XS08rbGlhSTFJWG5wYTRwakc3a25aRSszTFZkVlFG?=
 =?utf-8?B?Z2ZUNHpKZ0ZHaGsxVHF0YVJOdHNhNDlzOXN3L1BXcytxNnV3cjgxK2VRR0dp?=
 =?utf-8?B?bExNekJ1OGJ4b0xvK3BJMG1LdGNDZ05JMlRZTkhBN2lWVEtyZ2tmWWZDeUhS?=
 =?utf-8?B?TkVhR3Z5TEluNkJaQ0IxbHhyWGROSkdWU0kxekNXa1pDK21jeE0zTkNwaXYx?=
 =?utf-8?B?QWgzRk5CNHh6VnRPbDJtTnBISzRPaFNwMHBXSXAyM3VoYzlMV1JuZ3JWaE13?=
 =?utf-8?B?VHBGdkhJYVA1QlpYK1pabVZWbmhwRTROeUJyWVEwOC9FZFJNdFY1VWVISVlP?=
 =?utf-8?B?Nkl6WFpvY0VmbEluT3l6U2tQTHdmZ2NKemtHN0FWMnU0M1JtblVmWkNGc2JH?=
 =?utf-8?B?bGlDbW13TWQ0M1ZvZS9vaWovRU0venRpM0p3Y25VbDNkNEpCOVhBaWZMbjk1?=
 =?utf-8?B?Y1FVeUNQeTZnbGo5TW0zUWc4cXczbWdTYlczd2R1M0NvVnh5MkZhMmZkcy9H?=
 =?utf-8?B?SEs1K2RrZWRBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?aHhObnRzUFhvdmhQRzN1bkJMM3JWT2FmcE1GdjgzZlpPcm80MUo0RmFSUkxj?=
 =?utf-8?B?MnFLenZzUzhnRlpaWm5rVVpjMExpQ21wRitqbk9neW5CeHF4VDJNM3U0TStR?=
 =?utf-8?B?bktIeUJBbWhLUDVoZEEzZ1NVTXJKalhiM09NVVlaaVhsZG1yWC9Wbi9vdVM0?=
 =?utf-8?B?WnVsYXlPN0ZjZTF5R05NVGNVWTFOYWdGS3FBM25NZzZqUmVyS2ZCdFFCU084?=
 =?utf-8?B?NktDcGNaMnNhRFR4cEREcXFnbGgyMlRsL2lmdmFLWDFBUGFJQnJCblBxUXp0?=
 =?utf-8?B?ZXlPSDdheEZwaFNlYnNWeWQycWgzTjJLWERFVVFBdHMvK1dJNFlVa2F5SG1j?=
 =?utf-8?B?eEhKVU0raXFrdGh6Uk45dDBkaSs4enhGWHB3SDZKWC9XQXFMbnBWeXlyVUNW?=
 =?utf-8?B?Y2U0V1daNDh1QjRydWE0S1ZKeWhKTXpJUW8vWnZxb3JHRDc1Y1Zscy8zajNn?=
 =?utf-8?B?dG5WWTJZS2N6UzVGMzZKZGpVaUE2RzhYR1pWVy9LejlzaTh6WE5wVkRhTE5H?=
 =?utf-8?B?RzQxUDdoZEZDdzZLRUp0enlpL2FKaXVkYnlTRUxjK0V1TjZzL3Y5dWRmcXl0?=
 =?utf-8?B?L2N6NXJzMlo4Z2RFdTZRT1BTdjcwekZLd2diU0ZVem9LMUVrUmVPT2FCWWhx?=
 =?utf-8?B?NG5KbHpOQnhGUXhOK2F6Z1hLWExVc2trdVMrMitLdTd4Sk01R1RLd0xpSTNY?=
 =?utf-8?B?SkU1TmZETi92K1BWWEVjUEtJamtjM3BmQ1F6dlV5SXJjS1FBdDZHcGV2VUlI?=
 =?utf-8?B?Q1NRenBDSk5SMkswbk1HWlFabldPSzVQRS9GWEZhb0FzZzFMckJnalFIZDls?=
 =?utf-8?B?aFo2dllPUWlTcHMvUWJVYzFqeVVsdFkySGE3Wk9RdHFadXhEUFlsd0xBQW5t?=
 =?utf-8?B?aDNOS3g5L29zYkx3Mk1GeUxGUmpxbzU2dlRETmErbU9sOFA0WGN6RTJTT2o0?=
 =?utf-8?B?Y1pFc054d0xWY3pXcjBDTmVkbnZiTk9EZnFPcGNZMmx6NnRONmY0bm9kWnhW?=
 =?utf-8?B?bUhYSnRFOUdhSDhFSnZlNU9tNUZaTGYxNjhKWWd4UjQ5SWllOFpybkpQMDFJ?=
 =?utf-8?B?bnpaYWVNKzlyVndOTlNwUUw2MmNiT0hDQUdpdzhSbDNKV1p1Y0tzUk81L0FP?=
 =?utf-8?B?R0F2UWh0ZVpzMG1ubndpT3VGMUVwallJS2E3Q1lqV2RYNHV0c1pUNGdXNHhP?=
 =?utf-8?B?RkZHa2dJMTczb3hRRWxRWWY2dnFaME9TR3RjRGprWGlyaXY5em5tMHZQMmcr?=
 =?utf-8?B?VkdQNnJxb01rZkVmYzBYUi9CaTlwSUlhTFhGVksrQ1N0MjNBL2xqQVhNKzVG?=
 =?utf-8?B?dWZvWlVFc25WcEQrWTNIeE1WZkNHcEtiK1lobzhjazlQeG1MRmhMTExET2Fo?=
 =?utf-8?B?VXdhS0lXM09NWVZtaFRhRlp0N1hFODI1K0xHUGxUckxQakY5cXZyaFlEd09Y?=
 =?utf-8?B?d0NGam1YdXFtSVBVZklvZTZkWXR1eTFoMjMxYWdGaUZWb3U3RWdtNW80Qld2?=
 =?utf-8?B?allUNzU5UU5IUDA2b1NkVnZKS2Rjem9Wd2FXTTVsTHUva2NkbUJEa0lodHYx?=
 =?utf-8?B?VUluY1VCcDhuNXBhdHd3bi8wL3psTCtoLzRpVVRybWlxVlFnWE9kUERKQ0Jh?=
 =?utf-8?B?dUlrdE50TW9jeFdVRXljV05qTUxGdHFqdHdUYlpmWHBjemtmNWJQKzdnbkp5?=
 =?utf-8?B?WUFKZUdBU0ZOQUpmRWw5ckhHS3g0SHRla1ZjS21SQjFaZDBGQ2pTanhVUkhU?=
 =?utf-8?B?anU5N2R4OHhqMGlYRHUzZUlmdmpLK0pWVXN4TUt3aWN4Zm9WVlNnQlZROEdq?=
 =?utf-8?B?U2k3N29zSm5GYzJaWnpYL1puMUlJVkhzZ1B0N2NrRnNkNUN4WWxIMXFyc0xR?=
 =?utf-8?B?cXhpbEZpRStkUVovSXBEWVNjalBESDNjOGxYSGVCTi9acG8rWi9BSEkvQXZu?=
 =?utf-8?B?ZDNQbUVUUStkOHgrYkp5aGRiMU94YnVCaHBYMDhIMlhYa3JHeWhjV29uU1Fk?=
 =?utf-8?B?T0JlMU43SmF5blo0Z1RZZlR1cThiZGd5elZIVWs3RTJDYTJuTWgxdC9qYnR6?=
 =?utf-8?B?amliY1ViMFNRdXYzOWFJd2ZyVlA1cW53a2V0SkM4c3dYUm9jMWlhZ00vdjdM?=
 =?utf-8?B?WE52WnoweTl6OStpWUVTeWZoZk1VU3dES21jUEFBcjk2YlE4K2Jib3ExYmtq?=
 =?utf-8?B?dGZwMGhZVUhBUkE2MjVWZUcxeVhzS1R4Z0t4QVdmd2xFa20wYVFjYmxOK2R4?=
 =?utf-8?B?Vm1rRGprbWhxTnpVT2pqZmxnSUhBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCF4F07E06B34C49805C862EAF3D069A@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a667bb-9300-4df7-29c5-08dd91695eb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 15:26:30.2768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jX75rcAAz4Lr5+UZgvjwsXj/WA50GBhAXckM9YjcNQhJbedBpITD9PCPbGCjynC0jgUyry4a8gJXA1qGb9HSaSt5haCvIW5hPF/6MGaqRAU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB9829
X-Proofpoint-ORIG-GUID: WwkLwaxuTZ7DQanX5kc1fQ04mWbYeJ6D
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDE2MCBTYWx0ZWRfXxSqE+RJwymfv RSCpRvlAFYLB73KvMp1nXMxJS5jqMavQFNheXWMYqCwl2KBfH6xiwkuEDysv2vjMCV0N7uIysDc 471QZqcOuG+PxykqyHc4JOX/BZ7QLULNa34l+/4dt6Z04cCuke+9MO6ZtG0t1GTWzRiGTPeZchf
 0z3tNJAbcQrVLXRDCSV1pmt7UpxPG7nLGLdkfSM6fUmOijwBKBxWoUMHvqw8CqpixRe2TGYfFn/ h502sSSc8YQag50Ytvv2HmXwkVKqS1lP0P8M70lJdRTdbfPVKq9hHEhEnlZA5TjokefhmErpTGX xKWVEtd/H+E0wSg5Zn2qTEZ6yHAg51to5dPzhaI+rpFQOvD8ASSnBNbk35hI9ZfvJeKcxPztxmD
 IMa+PygIDdQQwZarDpVQ758FLVkl1sDWF0UnxhSjRdyzAw5IoH75sDqm1my54VYHBo6ySmYM
X-Proofpoint-GUID: WwkLwaxuTZ7DQanX5kc1fQ04mWbYeJ6D
X-Authority-Analysis: v=2.4 cv=Qapmvtbv c=1 sm=1 tr=0 ts=68221329 cx=c_pps a=Xy/G6Uf5sNtwtd22ls67ng==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=uBGOFHXavpWG35tVWvEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_05,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDE1LCAyMDI1LCBhdCAxMDo0M+KAr0FNLCBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJ
T046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IE9uIFR1ZSwgQXBy
IDE1LCAyMDI1LCBNaWNrYcOrbCBTYWxhw7xuIHdyb3RlOg0KPj4gSGksDQo+PiANCj4+IFRoaXMg
c2VyaWVzIGxvb2tzIGdvb2QsIGp1c3Qgc29tZSBpbmxpbmVkIHF1ZXN0aW9ucy4NCj4+IA0KPj4g
U2VhbiwgUGFvbG8sIHdoYXQgZG8geW91IHRoaW5rPw0KPiANCj4gSXQncyBoaWdoIHVwIG9uIG15
IHRvZG8sIGJ1dCBJJ3ZlIGJlZW4gc3dhbXBlZCB3aXRoIG5vbi11cHN0cmVhbSBzdHVmZiBmb3Ig
dGhlDQo+IGxhc3QgZmV3IHdlZWtzIChhbmQgSSdtIG5vdCBxdWl0ZSBvdXQgb2YgdGhlIHdvb2Rz
KSwgc28gSSBtaWdodCBub3QgZ2V0IHRvIGl0DQo+IHRoaXMgd2Vlay4NCg0KR2VudGxlIHBpbmcg
b24gdGhpcyBzZXJpZXMsIEkga25vdyB5b3XigJl2ZSBiZWVuIHN3YW1wZWQsIGFueQ0KbGluZSBv
ZiBzaWdodCBvbiBnZXR0aW5nIG91dCBvZiB0aGUgd29vZHM/IEp1c3QgZ290IGJhY2sgZnJvbSB0
cmF2ZWwNCm15c2VsZiBzbyBJ4oCZbSBjYXRjaGluZyB1cCBvbiB0b2Rvcw==

