Return-Path: <kvm+bounces-66582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F7BCD80DE
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:27:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50560301D9EA
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CAD2E1C57;
	Tue, 23 Dec 2025 04:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Oq4u7xiu";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hEIzq/gE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CF32D24AC;
	Tue, 23 Dec 2025 04:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766464033; cv=fail; b=bGwREmluCAa2+mWb4StChtUnTG9XqHn5mHH5ieOQFY6CIkxERnE1W4bRBWdiZN4whNivJ8UD3iWWvm/hEkSuMDxjOfCox3UQdWnOYjCZAiBsLZ2rAN49uk1iLzSDfsNkRjFJVf+a4iAX4qqUqd5hV2DVdAz18GvA4qT+UMDFz4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766464033; c=relaxed/simple;
	bh=MKiguqGd3GHuMdyuyJUog2MPQY8EgjuDv6UGNvQMShI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pX65zy+H1iCxS7CORQiUQC5oSTDEtlxmoO44r6SDg5ckzu9vIfXcm5JddrE00GVaMXxtgxLAt2+LlY0PwPlkFPVSgb1hSU7PrcjKbyiUsDZW/LckK7XcS5fRJTRHkNNNKWwFMIJ/RX8Y1DVmZG5QwgelTmTWXKLAQbGPQlHX+/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Oq4u7xiu; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hEIzq/gE; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1pnKj2850305;
	Mon, 22 Dec 2025 20:15:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=MKiguqGd3GHuMdyuyJUog2MPQY8EgjuDv6UGNvQMS
	hI=; b=Oq4u7xiuzczAhBQgTVIAM3ryvq4/IcfIdZtlnf4F/09jSHIPgSHDVERl2
	gZZqephXIo38KMXMXdBhg2/1ub6jN64lqBIV6Sz3hJSk4TGSt1xiB0sNqOasuOOR
	5k+U8fyjjVekVKprmYxrJC7ayt/xrEsInMazqblQtyd/HcoSQhv6mI3tYJmneZzM
	FKM96CaUAuY44cfgNSsq18hvxtiyJxMILPFKlfCcJyvyPsH3SDGcJGNCTdO7n/wH
	23M1Bq3uJuMeeyn6y7jOlhgc2wJZFYkZQcgJkHcIAqFGl9vQ1RpBN+HpsyEzjN3U
	HaDbGfIaVgio1/iGpJbkAlWR7uUGQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023080.outbound.protection.outlook.com [40.107.201.80])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b77f7hmg3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B1v0juUdSqBWgN9Zyuno2bovLXhFAtdEzPuoN9FuBe1r1jKkLF4OO0GgvX2/mDoUlTtToKrd9SnhRzTIzYDWEv6d2DRPuSId3Aq8kZUI/dYmiMh7Tvcpwg+3KCMSQ6SLzIGsw3Paubxk/g4k0rhPttyoDMJmMkulnXZPu3AQP5qERhQDgUcBmvALwGRWPyHq9W/gUCNBSdQb0zsJ8WnbGiA8EDnwhP9anCbt7FGubs4ysyEQm3zJygsIi5FKsVYxbsxZ/UtWv7GiJVIN/7JrU09sysaw/9z86fsL5w2RLOPeMSj1HGhJmz01jLgnuBgvg0EYcUww5pAQhsgLtZt1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKiguqGd3GHuMdyuyJUog2MPQY8EgjuDv6UGNvQMShI=;
 b=t2Y1bzDHqwW61P+CnsSfROG9Lo6JK5bmfSBPku7jHfZ/sNaz1Fz9AZBfjgzhp+paSnMQQgTpDzr4zopT2PN5ihNduEJEb691jNTL7tbj0NmrQyWqHOvNrpKnNoPguFPzQuWemHx7yCRaKkLyHSCuFlBS6lbWs0zOFizrb8AOPaN0tHia6psM2jaXHrbe9ii2x/J3XxeEqEJ1AzHLfxGOPADyiCjhYSrPkDL8UfOqF+JG2b0RKQPFNXJszL4Tj8NtHmmeswi3M+St04Jpl6PLIze1pZrt2TYPXBE4a3V5q/THTtYJ95ik0Ix+/9B7Gv5YvCRtFRudcZ+dB346OkOkHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKiguqGd3GHuMdyuyJUog2MPQY8EgjuDv6UGNvQMShI=;
 b=hEIzq/gEweMLTypF8xQvp3XO4K4YjaORWh5i14vLSDgaeIqx08J/bZZ7q/ABLsBjNc7jKzhUUp6rFgMVKDPD25zqg+Lq+DwTUuHCV87aMxJVQl9UFnsitjluyIK28kj+XCXEatEgMcMVWFI0Ih5X2APIgl6ojDCPMn4hEzZLHCcUzcFniStYnd1Q+liKFlEW+5mQlDJs1WCHHw+3CfJtCpXGGR6sQNk4wh7eyYVxgLe4Y+RjnYbmAWfwsaTnzSrtB/3b4j5IrGi3hDR4AHOjRridl6x14P96MfUgtfwUDw1FsYpuz9tyLqiGDNejnyiabhJgXZd0waoOzineUQ413A==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:51 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:51 +0000
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
Subject: Re: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to
 understand MBEC
Thread-Topic: [RFC PATCH 13/18] KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to
 understand MBEC
Thread-Index: AQHblFP5gtiSh+duMEucqkZZvv2RGLPPweOAgWCbDoA=
Date: Tue, 23 Dec 2025 04:15:51 +0000
Message-ID: <D4E24A7A-8F95-4DD5-B7CF-8081BB9D7984@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-14-jon@nutanix.com> <aCJN789_iZa6omeu@google.com>
In-Reply-To: <aCJN789_iZa6omeu@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: 7cea1a13-6010-44c2-6eca-08de41d9f5aa
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YVFjTzZBZFlLcGUxNTZCTmIrTW1ETjQraG85Wjdtak55NVFUZ2RadkFtMHpG?=
 =?utf-8?B?a2FkYVliVS9PZ2FzUXFpUWoxbUt3YVFMVG8wbHZRekhlcEJ5ZXZMZWlyczZF?=
 =?utf-8?B?cEJ4L1g2ckFrR0pVN0t6YnBpdnhSMjExc3loU0pZRFR2R21CcUl1UEFENkRq?=
 =?utf-8?B?QUNjSXZLNDdScGN4eDJvcXpuSWd5SjVHS1VLOUtmRk5MN2lOSmFEZHBEbW9u?=
 =?utf-8?B?aXdsT1RtWVd5cTNMSEZOOW14ckloa0o4RkZicjEwMUN3T1dkMXhsQTA4ZU14?=
 =?utf-8?B?dTdpS2dpL3ZlV1Rmem42czN4ZnQrd3ZTbUozS3VURFZiVERIMmx6ejcxVE5Q?=
 =?utf-8?B?a3QzYllJTjQvUGZSYytLa21sbzBTNjBMaG9QaHFBVWlWMWkzbmFVNDEydXNM?=
 =?utf-8?B?QnY4UnZqQ1UyOFp4eFU1QVVpUDE0S1JHb2g0alljeU5rbTJGa3UwK1NXL3p1?=
 =?utf-8?B?dG9iNmNQdThLdEtmM05DbWFOYmI4Y2xwZnNCd2xWQ2k4OVEyRU5DUWpLL1Ba?=
 =?utf-8?B?VDRZRXFCOGp5bGRUb3BLNVliRjEyb0tZdmZFaGZpeDhZZUJYL1pLWjZ5YklG?=
 =?utf-8?B?RzFwbmtzN09GUDhyU2F5ck1iUkxYaTRoK0lwVjVQbDF1TVJaUFhJWW03aWxP?=
 =?utf-8?B?dzhnYTFzNmgrNkFicEZnMElvRytrTHNjRDhta0JVVTN6YnpKbW5UcnZuSk9H?=
 =?utf-8?B?MVFxUXRKSmhuWFEzVG42QXB4WXNtckRuU3J6SHQ2S0FCS2szRWVjVkhkdFNS?=
 =?utf-8?B?NXRYUjBzMkkrRzZHcHdLWjU4VE81eEtETmYrUDd5RndUQXJsejMvdU9iWEdp?=
 =?utf-8?B?U283Z2M5NjRGVmpzQlNUVWFYbEFVV1Voa2FEZlAzR3BnVDY1ekk3UjFqOWYz?=
 =?utf-8?B?OWhDNVhNZktWNTNuTGRzWWtsQWpMWXdHNHdFNTJXa2dPRlhTTjcvd0wybUsw?=
 =?utf-8?B?Zm9Zbk1kclB2YlJKeFVNMkdkNk9zb1ZjKzA3Qzg1cDE2TVFvM2F6RE5HWEdV?=
 =?utf-8?B?Mitici9TMy9IZUZ3Zmp5N3pSazZBeitySEttRUk5dEpGd0tMQm80RW5VVzRp?=
 =?utf-8?B?dCsyK3VsV1VpK0UrREZMcFNSbjhSTGlGSkt4VHVzV3RhOVlyL01Eb1VoL09l?=
 =?utf-8?B?TXJKeDdCRnVrYjB5bWpuOXZsMTIzZXI4Q0NWaE9zZE1PNE9lYVhDN0VBSFVk?=
 =?utf-8?B?ZzRpenlRRDVvWk1pY1BnZnRFa3MyZmZIempUS0l0ZnB0V094clJUZW8zeGtM?=
 =?utf-8?B?Ky9tNG9HY3FVWUV6cmVSZTY4RlQrdUE1RExBMnF3YXlaZ2hKRXFzWXNyTS9N?=
 =?utf-8?B?dTEwbi90enJXUUZ6aXRYeTF2emZ2Ri91d3ordWdMZCtXRjFQb2R2ZHlHRHVu?=
 =?utf-8?B?aFdxcExOSFhlYUcyRU9YRytsa3RiUHZ2VWg5UGZycHp3NTkwQkZFN1k2c1Bl?=
 =?utf-8?B?T2RoWlZ4cGJJSUFraE9IUFNpSXJKbXQybVlMN2RTWUp0YXhkWFNsS3BaODV1?=
 =?utf-8?B?dlhhbEFUSy9MWXNmK0FVVEVtMkpvb2l4T0dyRnNyM2laK1lFRVQycUt5Si9q?=
 =?utf-8?B?LzJsd1Z6bzhrQ0NqY0RZa1NjYkw3MlhFalREMWtSUjVuSEtqRmpDdEtYRGpM?=
 =?utf-8?B?WlYxcUYwWjRzMC9XYUI4SmJqbmY2OGJid0xSZ1VpeXZoVXgrS0c5ZzFiYWNZ?=
 =?utf-8?B?MU1TMmlPRXVuVDVBWVdKSjVGa3Z5SFhjU1REVzNoMWxZdWhaZUxiMlZWeTRH?=
 =?utf-8?B?ZmVXU0IzOG9Dd0ZuNjZSZmdjVi9hUUxDK205aSsxM2lqQXp4WGM3RTY3REd0?=
 =?utf-8?B?NHVzL0RpZ280S1VyVmtVbmR5dWs3VVRMdDRJcHpieURrOStmOUZ2UDNsU0Nh?=
 =?utf-8?B?b2ZMdDV4SmhzclVGNGZKRGUrTjgxODBYWi9vVUEvRWJINHpIRlBHalV0U1JR?=
 =?utf-8?B?Mm1ERWFYdEFhN3d2VG1CeFIyWmkxbm5rVk5ITHBGaW44ZXpzOHFhaG5rMDlT?=
 =?utf-8?B?dUMxNHU4UUc1d1UrRGpxckplemxwQU4yd3dGYVVpQzY2Y1JmK1dDemxQck0v?=
 =?utf-8?Q?P8/P3v?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NWg3bHpQdEhmRnJ1czFRNWk3cDNySGJzMlRPZ3pnTTZhK051a2pybW5aQjA0?=
 =?utf-8?B?MnowZytva0RXbUxPUDkvbm53YlUxREtPeDYrZC9UcHNUc0VOTTAxdUErSmlQ?=
 =?utf-8?B?UGF3cXVmMDFad0RCL1BnUE5zaWdVWnh4ZGRqUWNwckN5bHBVLzRaQklBVXRk?=
 =?utf-8?B?N0xQdmMxamtmNS9rQll6MlZ6dnJrYWlKYXVtckdxN1p2NmEvV2M0V25DdytG?=
 =?utf-8?B?WG9nemRUM2laQzh4S3Fudy8wcEI3bnNMTXlqYXVQM1l1SGdCT2pjY01iVnJX?=
 =?utf-8?B?cm1uMThodEZuMEJTbDJUN0VwUmJpUmlyV3BCa3JuNWRva3ZTb1pjLzVQMWow?=
 =?utf-8?B?NW9YZ05ENm4xWHBEMG1ZcGxmbXRVaTI5S1gyZmFQeVpwelM0cDFmaWtDcUp5?=
 =?utf-8?B?ZmtqUkljQk5YVlYwdzJjOWNPdEE2cUYvcVpsSjVOQmJNWjdwQm1pWkliakYy?=
 =?utf-8?B?UDNWVFRRd1pSVTdZaTdBMmtxbVgra0pMZC93cWc0QlhGblFhMUhIZGlyQjNZ?=
 =?utf-8?B?RCtQRTdndEM2TUtKR3ZUeFg3bVFmZDA1d1Z1VlcwVFFGKy9uSWRjWndpOG9P?=
 =?utf-8?B?ODVod1NVRVFvdmRzbzBXZVd5c0x5NW82WngzVTNZQWhOeEJXbm9zTmV3TWxv?=
 =?utf-8?B?Nk5vczdFdkV2YmlpV0JDYlV0OEtYcnFGYXV4bUg1aUIzYVNjUDUrbURuOEI3?=
 =?utf-8?B?VGRKVFU3V0dVQ3pKNGZ5SlRNQTF6UkxNa0l5QkF4eTBoMks1ZnYvdkk3L1Vs?=
 =?utf-8?B?R3R2OTVCVlZCNElMV3k1em5Hc1Ftb1YzdHVBNU16dk9SdUY2NTA0ZDlRMGc5?=
 =?utf-8?B?LzBOTUcvZStzb1ZPYWlVMitHMXcxd01HRGEwRUh1SHRMS3NNTSt2SUd1Q1Mv?=
 =?utf-8?B?QW5xa2hCci9MQTRiL3hrRW9FbzBrUFlwUmZNS1gvYnNOTGNZSlRiVUpsbEtP?=
 =?utf-8?B?d2dHeldmZjZGU1VFcWVrTDJBcW16ZENqMS83ZFowd3hYdEQ0NUthaDV4VFQz?=
 =?utf-8?B?OUlwMHF0WkRaRFFEcXVmVENjdUQxZ1lTM1BzcXdiK2lEaEZ3VnlLaFVxdG1C?=
 =?utf-8?B?VTRZU3d1NWx1cXNqNkNKVzd1bGFoVHl4ZDZhSDhKa0dZanIvdFpuZm1QQXJC?=
 =?utf-8?B?eFl2OTNWVkRTMWpFajhQaXZPa1AybFpKRUgxcWF3cjhUenFGK21lVDlaR0dE?=
 =?utf-8?B?Z3ZlNEJtdUFoRnlFL0JxdzNkS0V3ajZaay8zdnhUR09ZWG5aTUdRRFkyQVJ5?=
 =?utf-8?B?UmtHTkxzMmpaS0pydUlmUG9QanBCNlU5TzFzRjZzVWZVVDBmbFIrdCs5RWdP?=
 =?utf-8?B?WXdaazFsTGgrMG9DY1RLdHNBMWVxbmlUVHI2L2JJL3FrdGRtcG9pd2JNU2pa?=
 =?utf-8?B?UytNeFZOMGFkWmkyWFo3YUp0amVzd01QQnBybDltczV4STRHOWovdHdublRC?=
 =?utf-8?B?UkxSRURtN3FHRktHMGUwL1hoSWZRdHdmbmwwUnNrZElVMnV6L000MFhBaFpl?=
 =?utf-8?B?d3NURDV2N09QN0thWTlpaWppV0Vyb3htVXN6WStJcUlySWFCa3pVa3pDcTBP?=
 =?utf-8?B?SEJVNEJyTTZ6dXJiaHd5d2JIVUJWRUdja3FvWDRJQWxHUlBBWkY5anU0LzQ5?=
 =?utf-8?B?b09xZld6VVFQSm9STElVLy80cTRjQUl3ZHlpZ0lLdzNPcldicVJXanFEL3Vw?=
 =?utf-8?B?NktIVHk5aGtWQlljZ1lTU1RYVDVFaFhjL0I1Y2ZLRmJuK0ZBWXBUNEgxV1p3?=
 =?utf-8?B?MXQrY2tUcFR5QUdOVGRSZ2kwVFpZRDFYZ0ZhR2wvTkh5Zmo3azJBWFl2UDU3?=
 =?utf-8?B?NkxVRUNZaG41T1VKanlTRndxaFdzYm9Id3NqOHVjTWNUYm9VMUY0WFo4ZjZu?=
 =?utf-8?B?MGF1SEpWMEVRTVZ6dG12T0NtblhkSmc2djhLamdnbHhpbnBKWGZJZXFMcmNo?=
 =?utf-8?B?VTJoa1ZzT1ZZU0RLZ3k3RlBZMC9YdDZiYlowMjU3VlVqeHdHMkREUkEvcmNo?=
 =?utf-8?B?UGdDOC9PQ1lxTU1JdE9jdkNaME5DVEkwVmttSlBvUnRhbDM1RGdLemRFRG5S?=
 =?utf-8?B?cVgzbWl0dWt4dkQwM2RMZmZqZjMzQmlwQ0k2Um9XRDM2YVJpdm1Eb0srSHZS?=
 =?utf-8?B?QTB6TDkwU2JkTHF3d0F3aFJzVkNYZVZGNlZVUVN5cTBrRC9DYk5PaGpKcVQz?=
 =?utf-8?B?MmJwanEwQzNrcENWamlvZFdZSk9SakZWSmwyRklQNUNaN3VaMytrK2JQOW9H?=
 =?utf-8?B?OUdackdkOUhKckQ0QmhUOU9CUFM2dmJ2U2IxRXVXTzcrN2NqSHNEcW9ZUm5S?=
 =?utf-8?B?dTNlaU10Vk1vbU42Ulh6Y25rNUJqVUl4dWVXRXRlbGxKZ2RQTEh3bFJVYUJF?=
 =?utf-8?Q?rtKDaLNuGezgg86perFlgdyFhP8y5PHHF7oWt2r8ZG1LS?=
x-ms-exchange-antispam-messagedata-1: lmAo92ZkOtfOpb5tLMuG0mhCV9mtIg8n/L8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B12A29EDD7C70B49839511B933AE728A@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cea1a13-6010-44c2-6eca-08de41d9f5aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:51.8174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a89VX8kEuZK2Kw2x/MIahoyoEdieLmIEbWxnh4fVgCfrlNTIfs7IiiKGjjPESuQFseHINi5yErPBqUVJ7QCKGsWpHyMiPRDHVfEwOeEHc6s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Authority-Analysis: v=2.4 cv=Jtv8bc4C c=1 sm=1 tr=0 ts=694a1779 cx=c_pps
 a=cfv+jupdUrUvkxZLjajzrw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=BOVaaSFCdiHrxuoauHkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfXxO7qGxWKgynn
 mmQS/AhVboLNj5F0h20FTuZE4c+LuisHnPs2iJ0ei41ShfEFhYW5l1CIPsnVh7IZMjZY/BarhwE
 5hzShfQubTH9focalBd2WHo56S/0vetTLx6Ut3gP4VDHB4s5En6MYLSKvEMPEAynipjwjCtp8d8
 DxOXmlStCyKkxsgW900uugwFFkGk4NGsDtEefU/aOJH2WSpZgvgA/HZvZwSSpryT53Dc3ubSH86
 P70G7R+NJl8WqVmQ0MJEL9P5HheVMHAcP3AoHzVn4WDovXx7QgdQtvh6SOxlYfytscTg266tE6K
 aFd0t/PsCFvii8iu+lE4nO6lkb1ntBuCHAftQ54DaubJqnMvmuEibUI47j4XCp1SjNGn0l9V24a
 jKVywpPq8/SNsYR7LUVi42m2H4lsMHV9jAVZdKr0TxuT1vOFNBaIKZrYHL//53hotcJXE7WGLDx
 JJKuP5PpXZl1OOtU+ww==
X-Proofpoint-ORIG-GUID: cf_O5gfQu7AImjZyVyVSdm40efZMOoal
X-Proofpoint-GUID: cf_O5gfQu7AImjZyVyVSdm40efZMOoal
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAzOjM34oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IFBsZWFzZSBiZSBtb3JlIHByZWNpc2Ug
d2l0aCB0aGUgc2hvcnRsb2dzLiAgIlVuZGVyc3RhbmQgTUJFQyIgaXMgZXh0cmVtZWx5IHZhZ3Vl
Lg0KDQpBY2svRG9uZSAtIGZpeGVkIGFjcm9zcyB0aGUgYm9hcmQgaW4gdjEgc2VyaWVzLCB0aG91
Z2ggdGhpcyBvbmUgaW4gdjEgaXMgc3RpbGwNCmEgYml0IHNraW5ueS4gSSBoYXZlIG5hcnJvd2Vk
IGRvd24gdGhpcyBzcGVjaWZpYyBwYXRjaCB0byAqanVzdCogZm9jdXMgb24gdGhpcw0KTU1JTyBn
ZW5lcmF0aW9uIG1hc2sgYml0LCBiZWNhdXNlIE1CRUMgY2FuIGJlIHVzZWQgYXMgYSBwcmVzZW50
IGJpdCBhY2NvcmRpbmcgdG8NCnRoZSBTRE0sIHNvIGl0IHNlZW1zIGxpa2UgaXQgaXMgbmVjZXNz
YXJ5IHRvIGNhcnZlIG91dCBvZiB0aGUgTU1JTyBtYXNrLg0KDQpMb29raW5nIGJhY2sgb24gdGhp
cywgaXQgc2VlbXMgKGNvcnJlY3QgbWUgaWYgSeKAmW0gd3JvbmcpIHRoYXQgdGhpcyBpcyBpbiBs
aW5lIHdpdGgNCnRoZSBvcmlnaW5hbCB3b3JrIG9uIGNvbW1pdCA4YmFkNDYwICgiS1ZNOiB4ODYv
bW11OiBBZGQgc2FuaXR5IGNoZWNrIHRoYXQgTU1JTw0KU1BURSBtYXNrIGRvZXNuJ3Qgb3Zlcmxh
cCBnZW4iKQ0KDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBKb24gS29obGVyIHdyb3RlOg0KPj4g
QWRqdXN0IHRoZSBTUFRFX01NSU9fQUxMT1dFRF9NQVNLIGFuZCBhc3NvY2lhdGVkIHZhbHVlcyB0
byBtYWtlIHRoZXNlDQo+PiBtYXNrcyBhd2FyZSBvZiBQVEUgQml0IDEwLCB0byBiZSB1c2VkIGJ5
IEludGVsIE1CRUMuDQo+IA0KPiBTYW1lIHRoaW5nIGhlcmUuICAiYXdhcmUgb2YgUFRFIGJpdCAx
MCIgZG9lc24ndCBkZXNjcmliZSB0aGUgY2hhbmdlIGluIGEgd2F5IHRoYXQNCj4gYWxsb3dzIGZv
ciBxdWljayByZXZpZXcgb2YgdGhlIHBhdGNoLiAgRS5nLiANCj4gDQo+ICBLVk06IHg4Ni9tbXU6
IEV4Y2x1ZGUgRVBUIE1CRUMncyB1c2VyLWV4ZWN1dGFibGUgYml0IGZyb20gdGhlIE1NSU8gZ2Vu
ZXJhdGlvbg0KPiANCj4gVGhlIGNoYW5nZWxvZ3MgYWxzbyBuZWVkIHRvIGV4cGxhaW4gKndoeSou
ICBJZiB5b3UgYWN0dWFsbHkgdHJpZWQgdG8gd3JpdGUgb3V0DQo+IGp1c3RpZmljYXRpb24gZm9y
IHdoeSBLVk0gY2FuJ3QgdXNlIGJpdCAxMCBmb3IgdGhlIE1NSU8gZ2VuZXJhdGlvbiwgdGhlbiB1
bmxlc3MNCj4geW91IHN0YXJ0IG1ha2luZyBzdHVmZiB1cCAob3IgQ2hhbyBhbmQgSSBhcmUgbWlz
c2luZyBzb21ldGhpbmcpLCB5b3UnbGwgY29tZSB0bw0KPiBzYW1lIGNvbmNsdXNpb24gdGhhdCBD
aGFvIGFuZCBJIGNhbWUgdG86IHRoaXMgcGF0Y2ggaXMgdW5uZWNlc3NhcnkuDQoNCg==

