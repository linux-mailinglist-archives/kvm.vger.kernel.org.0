Return-Path: <kvm+bounces-66578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B752CD80C6
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 26675301E1A8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B64C2E06D2;
	Tue, 23 Dec 2025 04:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bnrTbpps";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="iXMxufxM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EE12D5C68;
	Tue, 23 Dec 2025 04:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463861; cv=fail; b=qe7MOIHCt7aFSa8sXKVYT6UHYIpQN99UkGQCoyAYYb6Ilc2Bs8b8DseNSZafLZbtnpYCguAjI1wHF8tkNUVNz1eTSywGE7T05f3P79uXTRBO6juYELLFrr3G85nqZCV5EhpU1PL1J8GulaEOtofncCWoIdt69X+AvgWKop+axZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463861; c=relaxed/simple;
	bh=tnMcPrh2vA6kq2HGdH/py6GFA58gZXsTdEIrqsVZUPs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PunRgE8y26wVneAwMdqYrQ6PaECQl+wyS8bZY6wzZwoNRrHDeHBN/nxjLJsprEMskeuazQ9wpRoTa6loWpoisGImWsmmYCRFmAaWJqgQpXVaJUeJhaNqfcmXRp69BakmwBpuaixqTTyxq32sxhmj4qMRPC2qrQ4TX6yYC9on3yU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bnrTbpps; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=iXMxufxM; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN0riXF1956892;
	Mon, 22 Dec 2025 20:15:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tnMcPrh2vA6kq2HGdH/py6GFA58gZXsTdEIrqsVZU
	Ps=; b=bnrTbppseqOisz4agFJxutVj1DgRox7K8O9BiZ33mqOfJBoOrk/Pw6PZJ
	V32rxegtRTXygIOvAbABtJojPC41VUyhdTV51hiFnOigDn2tpeJbJhL/vJU31v7L
	FSFD6L9EgDzjiX/lhR6b/j2Tw3xYjC9/3c9hGIbTcCl/WTvLOH+DIOF2Uj7lT2jj
	YI06RoM4l7lvnHPM77GqTej0Jz+PhfG7IqSjzOeR1QxnEzRXOlcFjzdzVaJ7Tv7X
	gyHo7RMYyLoPYd27QcTELeeTiAyVsgVcgd/Kqm42zN72/zLTUeoztdrqgf71vPLh
	LrMjUv9RCwKvyflmJL73PjolX6SNA==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023105.outbound.protection.outlook.com [40.107.201.105])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5s0qvwvs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ch2zGlYd5ev50zVzAMpEORz6y1ei6xNBayy4hQ9xGy2mbGmaI3TaQXfIX05o7AK3RdaFOnNMRrtj9qy7rTKviJuiYlialgdfrVQCSMALCYa1YZnlSi87pHWOVHGw5esrDsKhPdNrCLtUPz69gQsGqVUigKGTnfbRzuTGim3psfWlz2xGMfxEUKrtWbtyhuGbj0JjNZriNoPGFll4/xCmYSS0gpBXdIdTbQ77geKAlEd1VcmY7Zj6P1UUCXOqLPSpHIo5xWNFdw2LrVfJXIObe4uxJM0S2NR5YIa+L0LxXsFDCSKN+tDp5d44rLlPhrFIjEq1jjrEx0/db8OZA8aG+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnMcPrh2vA6kq2HGdH/py6GFA58gZXsTdEIrqsVZUPs=;
 b=UCjveDn64xnbQEw7Bn+hDBZVnA/xlZ3eHSvrPGTzoJvL9lMADbC5CNyw1US5dBaKNgLB8mWp+LH+geoVsgQhLKNrWU3bk8kfj+DGda3D17MwKi7qJGBtjEq4OO38kMZfEsplsAYRlsYwOk3T5TbIR8mYGsy6rik7/zedrck9UtNtaUmVfKgjUNaZRM5GS6cdg6YsmneRsrbiV1JLjjOpgxsxFa3QNl907J+fL8T7LW1z6K8WQ6C/BG0oRdlXT0grZyiA/Oo6gdtoBgsZdL0J/1YgRtqjSwErir4zTMzV4I80r/ahZNSMC4ogZ5U6KlKBgOerHq+EjaPXN+sRnLGbXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnMcPrh2vA6kq2HGdH/py6GFA58gZXsTdEIrqsVZUPs=;
 b=iXMxufxM10q0yMHF/svzP70ZB/KDVtmTnSx6fHW4mqR2IRIC0Z+F29a/+Gz2aQeHjsomGLNSUAvxoQD1oKxqPeLHGJD2xqKgDRdRkpIgSPsJYWJ5yqiNADs9mtIwYRzBZxGBSBsCADh9NJH3WmRlNFDwTYpRvIPCxtqRf4EUDwS9fBptqbMvLo77TtcJPRFlRMZ1yWy9381YSJ8xsI9QpbBGfkfgWPAtEUEgrd6SttWggRo+pH6m0Onbr9QySi+Mmtv1owEfvl8ec8wD4mjgpG030ZpShWQ+oGOR5SkFtYWYPb6q3KWhXGC8egCmmVlfJ/Xcu0vaZvKOLnXw81ivgQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:38 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:38 +0000
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
Subject: Re: [RFC PATCH 05/18] KVM: x86: Add pt_guest_exec_control to
 kvm_vcpu_arch
Thread-Topic: [RFC PATCH 05/18] KVM: x86: Add pt_guest_exec_control to
 kvm_vcpu_arch
Thread-Index: AQHblFPtCebxNraH0U+p0yoIXgxwf7PPqukAgWCx+QA=
Date: Tue, 23 Dec 2025 04:15:38 +0000
Message-ID: <FBA5D186-CB54-48C4-97B2-E130FEAB429E@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-6-jon@nutanix.com> <aCI6qMg6OjT-cWzR@google.com>
In-Reply-To: <aCI6qMg6OjT-cWzR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: 471cdc3f-33a5-4028-11cf-08de41d9edb3
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ek9wc0V6ZHQyWE5vZStXQXlGOHhSdzRIZ3VkSHZMek9tL2F1eE1UMlA4dnNn?=
 =?utf-8?B?UnRTQlJTcU82UlhZNHhOYnZDWkVsNzlud1l5OFA5QU9YK1NLWUJUOUF0b0dk?=
 =?utf-8?B?Q3Z1NGRwSUYvSGNuNnFiemZVd3RjSDZ5WEhDd00yQWdHUnZTUmUrY2NPWFhO?=
 =?utf-8?B?eHZIV3UzN0d5QmczbDlPUjZaMnRLbmtmNU9jbWFvVEFIVS83Q01oMlBvVFMr?=
 =?utf-8?B?WS84K2MrUWNzZkVneGk3R0xYV0ZpQTZDbllSV2RUNVlUb0JNb0xsYzNSUXVI?=
 =?utf-8?B?MU9uQ0M1VFNGTkRxbTJQS0h3MS82YjVtb3FNNEh6ZlBLY1M5RnQ4KzZXa0kx?=
 =?utf-8?B?QjBmY3BpSGF0Zm1SeDlpTjR2amxIQW5YR3RRamRqV09Ec0tiWFJyQjFTSmh3?=
 =?utf-8?B?RlVvN3k2Q0pKUW9zQUN5SzAxQ3dadTQrZXhtY0xHdFdaK1htVk42N2tYMjcw?=
 =?utf-8?B?RkYydnNpYzNjbXV0YnFoQjJ0SHhrVEY4NFdVWTBpdmYxL0J0UGhwSmRkeGt0?=
 =?utf-8?B?eUtpd21VTmNWWUdxSllkYm8xY3NFZUN4ZzRnRUM2bTArOHlxcnB0STBHZ1Fx?=
 =?utf-8?B?ZW9BbWhaVm11OThBREVob2RRbGhPZERIQTdOMFN4bFdoKzdYbkRGUm9Lbjhj?=
 =?utf-8?B?S0VOamovaDg2cTM2K2pvMXZhaHRZUElkODJmV3k4d0taa1UvS2N6TStnZkxX?=
 =?utf-8?B?c2R2dXk0UHVzU0trOU9QbkU4YTlINTFXd2cwUFZjdHVETzBiN2VnSVRoaC81?=
 =?utf-8?B?UGFiUzBIQ1R0UURIbGUyN0xjazYwUGpNYlFvVGw3cW55bGM2clNxUW0xNk5D?=
 =?utf-8?B?bkxvL2hjRWV3OWdqaUJieURORkpBUmdjbktUSGc3bWVFRnJwak1oTEMvN0Zx?=
 =?utf-8?B?ODR5LzA5R0ZVTFNienNnTjZUOGZJeFZua1RxdWNHd25LQWNvNVNpZGlYNWZy?=
 =?utf-8?B?RTFwNGxmMmYvNUV4Y3hQUVFTMm9LQ3d6OWd5b0tnQ1lPcGEyNWRQendsSlRm?=
 =?utf-8?B?cWJkVkttU3BnRTVoZlpSVFB6bGRFTzBXVHZGYzNoU0NOUmpzZVJnTTFxTG9r?=
 =?utf-8?B?bFIzK0g1eTNEZE5HUVFubS9RZHNKQmtXOXp0M1Z4OWZLbE1HQmtQSkxKSGtS?=
 =?utf-8?B?d0ZCUjNIa1UweWIwUDliNTRWYkFUd3BqNVg0ZzlxSW1lcHBQbCt6cjhRTkg1?=
 =?utf-8?B?NnNodDkvSEZsYlNwM2Z2TXBSZjlHQkp1NWFOZVAwQU9KUUUwNDdDRjVkQTZE?=
 =?utf-8?B?bFRETC9VR2t2MVVFeUh1MVVRK1Z4RW56S1lZN1ZIWWpjMTRyaUN4cmQ1K1Ez?=
 =?utf-8?B?V2lCVkhkRzR0RFBDYzFIUVA1UFJ4ZzYyT2VsaHJuUWNLNEZaZWxWZFRVVFZl?=
 =?utf-8?B?Vy9IWEVTdmhuZWlWYnpacHUramNBbm1veVY5VEtIeEJxM2YyYUl6RjE4bkRB?=
 =?utf-8?B?UHJBaTlxSlpSckpMZXNkc3hwTVM4eldqclZSYWFOOUxEbXBoZHR6Mmo5Zk8y?=
 =?utf-8?B?bi9CR0F5RlZoTkZoUFNFc2hXdUFjYnAxQmJqMjBST08xSVhDcHZpUFYvZ0Jl?=
 =?utf-8?B?T2RUOFB0a0ovUmJFWkZzLzVsNnZ5R1F0YnZUM25rUTBHU052TnZ5NVRUSHZl?=
 =?utf-8?B?QUo5SThwQVJFNC9HcVRuQ3Rwd0RvdUxmZDNwL1FqWjZBRnVvMlZVTmE4dzJ3?=
 =?utf-8?B?YUEvRkVVV25nM3dFdFFPMU02d296dm9RQTRVejl3cnFtVGdKeVZkenJVTGRF?=
 =?utf-8?B?MlJEU2Y2eGtWMnhzZUFubXFSNG5hVGNNZmRwRkM2S1BIRjhoaFhXbWlwZ1Zx?=
 =?utf-8?B?clliY2FqSkFRTW52SEhDUkc5c0lmSUI4cXVRN2VlbG9UalJDRkxRUlpQZHda?=
 =?utf-8?B?VnZQOHh2WTlTZGcvMXhKejlOM3dXb0VxblZXV0tXVDE0eUNNdU12dXFCVG1G?=
 =?utf-8?B?RTg5WW4rMDh5VHNzbWZSL1gvaHBvcUJYQXhvYjdtdEl3SWtlQWZYc0JlNlBO?=
 =?utf-8?B?WmZQU2gvSHp5ZUp4aXVwR01PUEd5dElKR2dOOFFkRFJSNXZkdnhtcDFqRFhQ?=
 =?utf-8?Q?vY8lTk?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MjFqa1FMV0U1bS8yOWQzSXNhNUdkQmRuK2syTFNqTjlWWGxkZTZ0R2NaNlRw?=
 =?utf-8?B?Q2ZndXltOS9jd0hGeWJxQ1M1V0FLdjZlbDdmMzZPZEFWaS9BWUt4K1dKRUc3?=
 =?utf-8?B?UHhpQkt2V2ZKMFBJSEFwSjJ1RmJYYzBDZ0hYR3VUS3dVQ3BYdUFDUzlBTDM1?=
 =?utf-8?B?RTdPa2w3SU95R2JmaVNqbHVSVFM5Tnd5UHFLcXI4V2FKQWFmNGN3VUJ6U0Rl?=
 =?utf-8?B?RHpvV0xWdmUxd0h4OVExdmtqNHlzVmtNQURpL0xnN3R6cHdyenJyM2ptWHgv?=
 =?utf-8?B?Mm92ckRUN0xjMjJWVUwyTUtCcERnbFhzVmx5M1dYM3RtZE45bFVYL2VSVW80?=
 =?utf-8?B?MFA4RVJyYnpiNUxJc0FVSW92bktyeUFMSFRFaEZhWGRkanRxV2tmNHZIZlRL?=
 =?utf-8?B?b0c4YlZ5Q3Z1SHBCdG9EenQrTjlOS2RXR0RoZ1JWcnFCb2s0aU1LU1piTSta?=
 =?utf-8?B?bytDL0Nsc25SRk1CSVBsdjBCdXp6YkFpK2srbzFteDNxbktsaCtvaWdEMFcx?=
 =?utf-8?B?ampqRUVCYmt0elo4T0U0SzhjL0NPUkpaVGlKVVk1VW5FR0tUeHJRSnBSTndk?=
 =?utf-8?B?cHlYNDQvcjFhTjZTTjU1dTdFN2dFWkZjc0VDTTBNWnE2VUVaUFprQnVoZ2Z6?=
 =?utf-8?B?UzJjVFY3Sm02alZxd2hxVTNhQ1BiK0N3K0svUEp5N1laOTNtYUtvU1MyTGpD?=
 =?utf-8?B?UlEweGFiN2MwSWtQUHF0QkZ0RXNSZVM2MW5aeEN1bzVORHNpUjBVWXJ1enFa?=
 =?utf-8?B?S0ZKSDFiaUROYnpzVW5ZQzhXMkNEL3RJSXVlNEErckVIdUtTRU5JVzhZdEZJ?=
 =?utf-8?B?aWM1TU9QVXliVWZRSmpzbml2WktPYU5rT2N0SHdpSUFndmJnSDZYOXdITURW?=
 =?utf-8?B?elNXUmxLN2J1U3dOT0ZOL3FIY0J4cldmRlVKMzk0cG14UlhsRVZGYzlPL3Nn?=
 =?utf-8?B?QXZKRGxvaGJNOWdkYjV4aDVoOCtEUml0YWxJbGY2a2J0bVhnbGpnQVNubXlq?=
 =?utf-8?B?bXYxWXBHY0xrOEVORzYybWRlb1M0S09KVTFJd2xvUG0vUGpqZXg5cUI2dWVi?=
 =?utf-8?B?b2FmSVpadUpsRWlwc01DeC9jRGhwWVdmTkgrK2lKUHhMYVhlSjNuTHpXVk5h?=
 =?utf-8?B?enpud1FYbnY1S3ZKYWpEZ3FJMkJIMU03OEhTSmxScFg0R0ZUUkZCdkVyUkRF?=
 =?utf-8?B?ampWalkyL1FKRWJBb0U0NmhaaW95M0RhaEtCdm1SRWpwR0gzQ3dOd1lxbXI2?=
 =?utf-8?B?TkRQWkFzTWRpVHpMeitlU1d0dkJQYmFReE9ucWw1d1R2VDFFMjJzQWdXOHVl?=
 =?utf-8?B?eXdWQVNuMmE1ZWVFdWJJYmIxdllDY0QzRjF0QzJKbkxIcUN2SHNuRGhkSVA0?=
 =?utf-8?B?ZTdIZEcvQzlhajU5VlAxWU1ma09FZjFjMzNKWm1wMWhqR0pNMVRtTnRja2Vs?=
 =?utf-8?B?UFplUnRseWQxSHVVZ2JIbkpueHNtR2Y5NVgyblIxVzlpTXltVEFHQWF3MlBo?=
 =?utf-8?B?RlJjcWd3aEZ0U3lVc2VoTERBUm5jdlJJM3g3bWo4RmlTWVBPWDNHd2JuNWlK?=
 =?utf-8?B?NStHajhuTnJVTkhlQ2t5Z1JsczVua1RFbnlUL1N4MVZBTXR6Q21pZ09wTVQ1?=
 =?utf-8?B?M09yUEJlZktjaTV3b3FlYUFPSXEzWXVxanlJMyttblErVm82K1F1RWVwTUdq?=
 =?utf-8?B?Y3lISDNsNGRxUWplcjdFeTFEQ2tGZWlRVzZ5OXZVZVJKWWRGRG9Gb1NNVTRI?=
 =?utf-8?B?eFpFZHVwSVNXaTk3clVyMk5Ib0F4ZVZqRXI1dEpkZVY0bTU1WVUxOHptcmw0?=
 =?utf-8?B?dzJkWHpXdUZPc2JPUWhnQ3dPV25Ca0hPWXFHM2Y3aVlPazN4NDFmeTk4ZnZZ?=
 =?utf-8?B?OUN1RGNRSEx1NmkvbVBPcGlndTFaRkE3S0xaUHNTSk1xem1tK3dNQzhySVlh?=
 =?utf-8?B?czVWU25mcEFrM2ZNeHJsbmVYL2lMcjZTMFRaYXI5Z1RZYUxuaWlQWndGNVVy?=
 =?utf-8?B?Ukg2cFZkUmdqOUw4RUFtVURlM3Q3dEplSEtZVEdJMWdYZjM5Y0dDWFVQZ3Nv?=
 =?utf-8?B?c1RyWEwzdnZrcEx5c2NiRjJSbkNWVDVFbnJuSXBZMU9qS1o1QjNVeXFabWMy?=
 =?utf-8?B?VXZkY1gwcCswbEZpTlUwbm5kTEtjT1kwR0ZiaW1IV2g1WVRuMWliNEYxUDBH?=
 =?utf-8?B?cDQ4OVN2d0dESVM1WFdrUExKZkFpeUtTRW41OEZPdFNDa2tZNWlueFI5QTFN?=
 =?utf-8?B?ckxOYzRwbDJvMWVPQSsxb05sYUNjT0FpVzVITHJWYmhsbXJyUVltLzg1c2xU?=
 =?utf-8?B?Q0Y0QXp3SHhGRGxZcXM3Rk1ZOEJsM3JhR0ZnanJpOWxNSThFSVdNeXVpM3JE?=
 =?utf-8?Q?RxmGlffTs4NYSyC9VyqbqYxOqUUWgBjEhIot4N5tTv0J1?=
x-ms-exchange-antispam-messagedata-1: lxZHXJs3NmBMm5fKR5A+IdZIMBcLEXpyxLM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <065FBF1B8926E44C9B1D27E50BE0F685@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 471cdc3f-33a5-4028-11cf-08de41d9edb3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:38.4366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5POrAwCipyj1zBAI48dfIXCauKFRtfkL0+MBNMU7Y6SKNP+1r8UDDRcNH1wHTRkFeqKFdXTP/0FBMiE17KnxveJDoLyL3N2Sm2Aby4mG6Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Proofpoint-GUID: 1qO3VJanGnaC3V_L3oG54I0iD-AOjMnE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfXxC4gPBfYdq0l
 8dYAYeIvIPx94HBsaIX1Y4zeJYV0zwDQ0Oxi9s3e7yyyzdr9CVA3dIjd7xbhXaPxg3wE6+w2rmf
 utWg/tXJWobMOiexDeMZVNeN9t+NyOjPBRr495FWNtxWAbgaBWW37XNPBqfjNeEi+LhlvR+RlUM
 W/xyrIqcWruYK/Qpdpcl8RwwZ+zAG+OukVDNC8hVSmsDD57S6hmhg7t+VJaNyH81RYLZdHxU5mm
 BKmO892B5x3Q8wUqBH/SOqiA3FTtt6gOzZMXVvgttLKhUFJWiLgEkL1tYrC7JS5N+L2QUkJCSem
 wpVXfn5OmVkQ81SSo8fF8QaiW0L1jM+/QAHm4O/as+2cpaAZ9kNsfqhrgZkEjpSn8izCGz1gKKw
 +UNW9iKP0HsssdxQ7Ca1rNPnEDdTLuug14BRK9K9dA/D+j+qtQGz2aPicYWpmRE9tafwzNB9r7+
 MF8I9TAuSqUunMlCRQg==
X-Proofpoint-ORIG-GUID: 1qO3VJanGnaC3V_L3oG54I0iD-AOjMnE
X-Authority-Analysis: v=2.4 cv=H4fWAuYi c=1 sm=1 tr=0 ts=694a176c cx=c_pps
 a=mXWPUgXNGD4LDRIkHGcDmw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=jwkJa1XhHEixTXbLhHEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjE14oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gQWRkIGJvb2wgZm9yIHB0X2d1ZXN0X2V4ZWNfY29udHJvbCB0
byBrdm1fdmNwdV9hcmNoLCB0byBiZSB1c2VkIGZvcg0KPj4gcnVudGltZSBjaGVja3MgZm9yIElu
dGVsIE1vZGUgQmFzZWQgRXhlY3V0aW9uIENvbnRyb2wgKE1CRUMpIGFuZA0KPj4gQU1EIEd1ZXN0
IE1vZGUgRXhlY3V0ZSBDb250cm9sIChHTUVUKS4NCj4+IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9u
IEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gDQo+PiAtLS0NCj4+IGFyY2gveDg2L2luY2x1
ZGUvYXNtL2t2bV9ob3N0LmggfCAyICsrDQo+PiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspDQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4gaW5kZXggZmQzN2RhZDM4Njcw
Li4xOTIyMzNlYjU1N2EgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1f
aG9zdC5oDQo+PiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQo+PiBAQCAt
ODU2LDYgKzg1Niw4IEBAIHN0cnVjdCBrdm1fdmNwdV9hcmNoIHsNCj4+IHN0cnVjdCBrdm1faHlw
ZXJ2aXNvcl9jcHVpZCBrdm1fY3B1aWQ7DQo+PiBib29sIGlzX2FtZF9jb21wYXRpYmxlOw0KPj4g
DQo+PiArIGJvb2wgcHRfZ3Vlc3RfZXhlY19jb250cm9sOw0KPiANCj4gQWdhaW4sIGFzaWRlIGZy
b20gdGhlIGZhc3QgdGhhdCBwdXR0aW5nIHRoaXMgaW4ga3ZtX3ZjcHVfYXJjaCBpcyB3cm9uZywg
dGhpcyBub3QNCj4gd29ydGggb2YgYSBzZXBhcmF0ZSBwYXRjaC4NCj4gDQoNCkFjay9kb25lIC0g
bW92ZWQgYWxsIG9mIHRoaXMgdG8gbW11IHJvbGUgaW4gdjEsIG11Y2ggY2xlYW5lciB0aGVyZQ==

