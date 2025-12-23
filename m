Return-Path: <kvm+bounces-66575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 67DD4CD80B1
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:23:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AE63B3002B93
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:23:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C311E2E11BC;
	Tue, 23 Dec 2025 04:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BhIx7jmx";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jZRL+6rP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD0B2D24AC;
	Tue, 23 Dec 2025 04:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463781; cv=fail; b=ChaM9PEZbyRRgVb0aFuGl31ngvwiwWzTPT4SuGYaC0Bm+X2woOrDpVezCQU7ne00MvVHudL/PSYnYOQnT0Nfqlj8H+pLgMlNVgsn/zhV1rG1M99HSBqOIakDc6RPCLlEq+J9JW9Qa3DNsO/TdGzANOvR/cSn3d97xem1BflrI0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463781; c=relaxed/simple;
	bh=DgkTEiDKvlUPfeBIWv+lTquokVxLzhfzzi5pfvBHAvc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pgtiA+MNAeU4w7s1uC5m0hYvXLCxSBau3dvPmwCh/a0p6CZpSxXqDcbP19D7XnlXgHxrDSHf7qBQ0A5EIUwFCTkuxlK15D2m+U8Eqg27/3GRWpq48lxxa7MSRyHPuVFq0kLCk4OomRjt1kgauZRD48boIXS2dMJXePKB/AlhL1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BhIx7jmx; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jZRL+6rP; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMI8Er12865958;
	Mon, 22 Dec 2025 20:15:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=DgkTEiDKvlUPfeBIWv+lTquokVxLzhfzzi5pfvBHA
	vc=; b=BhIx7jmxGan7sbCtZWkrGUa3KkmGYMmJZ2AycycttHx9msybgiiPvK9gI
	aoVHsLMtl+Uvmn1Sffa/X2QlzOeJh6iEcS4bvO2CrZWjMuazm/Tj87rvDwcxt07A
	2GHfqmYnLZa5dGvwoGV2Ji8XIxENKSpDOK45MNg8b8vr+vfZohj/tMuNvgaCH4+z
	QvgqtZxIjS2BJcS5bAobUcMdCtwk97pUh612eiHxu5h4AIpG2uj4OV1uyHXc7PP0
	V7fr7hWUtkRKG1ng9IAAVpQAQEucd/xFCqJmXl4SsfMKostPEA1biwfcK7CcdRN7
	xxZ8UeypKoQX0Gt/SvC68EhPSRunw==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11022141.outbound.protection.outlook.com [52.101.48.141])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b7b0hs30n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B//XsUcT9b3Fce6gqGvfvIvn9DQRXTGrH+a2wh0cCgBKM7f6BI5ANDk9Bg00nsJ5r9Cgl1vq25Qwcl3fEnc6CqV+arZ2H/tfVtguoo/uDUANKWm5xl7gFQVh8Nm7uxi7aI9Q0s6U6r7ViAWVA3sGfXbtrP44oVIOsNATmZAH+rdTivLoO8uml8h+6iLzINa12ciY1RBN3Q6mkYYADXoarXfw6kKHAKCnmOi5Pqt4PURVOSpsdEPUoEV+qDvIxTciBODHN5uQwl+LNlTeJWbOzbSMdM3jAFMPCJjJBin77BFgZnQW550yQ0hcRj0QX84l+aEqaVF0+lcqcMa4JltqXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgkTEiDKvlUPfeBIWv+lTquokVxLzhfzzi5pfvBHAvc=;
 b=MP1Ii6mj1w0tvMFdOIH394l9WGeubrL1i/yvS3Fp13mVpvF604ss5aPyF0NunDreKgYxeW3TXasrLuGBv3XmBYNeMdK0Avb5wtiFYUmcp78jna8ZLQZ9VRc/MbAjXXFWdfTPBuL30IoZdk4W+auOx2S3EJzehZKJHCsTUT3rP6toTe7t/OPEDE5Cb872ND4xXgi+78pv3PaxCeFe7/zpJ6WFDgtYQL+pqpFtm5jgzXt8qVYuQROXnbMiy/sjU9RVCAJ6qroH6Ap+EeLTZJ2Ugnc8a6w4oqJxLWgAx6nMT8bWaZM3z4d40+qUhYrSp2QNP/wpWO4jio+f4tCNv4dIyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgkTEiDKvlUPfeBIWv+lTquokVxLzhfzzi5pfvBHAvc=;
 b=jZRL+6rP3LQU3MySFU9i6EQfWogpPbcBKv4SBIaKxMI0ayRDF8P1zabEjbvh5c46Q9Fleo91Q8qKLzHTfnmq3rDP/Iiw+C0IpJZp4qb03GEcmlCh2XPyl4h3/foI2Ut9QMqaYEP9IWs7LC+GcdtWlas9y6ORRc0FP5RpGCMfGPkL81fICN9JeJeSQx3x4IBAz/LEpQT9OxWGv7QZ6159pSAsXS/d2nRiGKaJir7Rg1SoMBFRIkdka2N8jkCzxhOtlDGwHvHnoI56LxvWl2uJ76MJg11EWpCC0j/B2Gg9dUqu8mSXwRibEw6lJ0IS+8rYuJog1vV8s8KRcObSXlNWEQ==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:36 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:36 +0000
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
Thread-Index: AQHblFPuD2Myz8OZIk2A34TqIykpjLPPrUYAgWCvmIA=
Date: Tue, 23 Dec 2025 04:15:35 +0000
Message-ID: <55ABBD78-A71B-4C37-9784-283E929B59C2@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-7-jon@nutanix.com> <aCI8pGJbn3l99kq8@google.com>
In-Reply-To: <aCI8pGJbn3l99kq8@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: 8dd71284-4c2d-4e1e-3cd8-08de41d9ec3b
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z1VnWkp0YWp2WmVBWkpXK1pEWXhHdGEwTW9rZmxDTGRWMFNnQjVHRXF2S3Nl?=
 =?utf-8?B?dFBDVWNTczc5ZFVibnZ0RloxaGo1L0t5R1dpVGx6UmNpTkJxb2VIcnlMOXZi?=
 =?utf-8?B?bU5ZT2hXQW5BVWljc3dKZmdFdTVvN3RZc2ljMmVpS1VkdUZFaVpHZWtROXMr?=
 =?utf-8?B?SGVsUUYrbFNvVDM0L1d5RXRqQ0c4VjFYZDk0RlRFZkM2QXhnVzNrTEdjdGhT?=
 =?utf-8?B?Y1hwNE9PVFBkV3AxUjJKK2NlNHRrdTd6V0VvTHorWHFkeWxpV2ZJVzQvRGpr?=
 =?utf-8?B?SXNaVEpNODZpbXh5eGJSWVhxcmU4WnphZFBHNkZJczJERHZ4SThhNVdjbW9p?=
 =?utf-8?B?Rmx6ZjZJNTcvbDVmTXdGSStINWVFVWo3L0lqbGh2VmdhdTdMc21aeW5acXJk?=
 =?utf-8?B?cWZ3b1c5OFMva25xVUdEMXUwN1pPRUFuYVlpOUNNRmQ4aFhrb20rM1Jjb1dt?=
 =?utf-8?B?ZVI2c3RpeloyTUdXYkYwaWptZkx0UFRZbEdWdTFMa3ZtVXpWVVYrVXNlVHQv?=
 =?utf-8?B?OURTbTRsR2ZES3g5WVJZYXJlV0FsejYvUDdPb0JIZUxlbHo3VlFFblZ5LzNl?=
 =?utf-8?B?VEtRQnBHZzVRMVNDZGNGZnllTU9tTWUwcmZLTVpmaFhFalE5WW54MVJFZGln?=
 =?utf-8?B?TkRaamhCaGpCNTd6UFBuR1NxaFdjaEhQMldKTzJKUmdNL0lVU0tYQmp6cE5m?=
 =?utf-8?B?aFZjY3ZIdFFJVUVHVk9IQTJoNTREZ3RqUFh5WW9Ib2pDb0F6NFNlNTlJNFlk?=
 =?utf-8?B?bGVMdWNoVlBkU2x6VEFqdm5BMFFYUjVidURHOStKYkdaaTdEc0ZGVFIwVjZ3?=
 =?utf-8?B?Qlp6UnA3VGg1L214Nkp0bHBranlYS2NZM1hPTlFlay9haUZYQUVzc0ZnemFz?=
 =?utf-8?B?T1Q4YjlnbmM1Tlc5aXNRdytkVC9JbUtsKzhKMkFkUy9LOUV6UHBuS01QSUJH?=
 =?utf-8?B?RVUzcHhicHRnTG9yRkp3QndNRDBKVjd1Q21nbkZ4OTdVcXhIOWJWSGVmVFRm?=
 =?utf-8?B?dGZ0Wnl2M3ZTdU5yUklzcG5IUEIzUFNSQ0RxZThnZG1uYy9kbDhNYjVlWkJq?=
 =?utf-8?B?NnhUYS9NcFlrYnIrWStNN1hDaDBIVEtIeDN4VGxkZnloQUFqbERsMzZyOGQv?=
 =?utf-8?B?ZjRzZHh4UWJvS0grZitaSVJ0M3hnUkVRdVhYWklXM2hZZU1CWUNFZkVGcm43?=
 =?utf-8?B?VDZ5WTFmUkRjbTFnMkEyaGdzUUJ4TmpDVld6cmlDK0RvQ0J1TU1kV3FCc01s?=
 =?utf-8?B?QmtyRWxNbXYvSnhKbFN3SFBjcmVma2szVWl5ajJiVVViQnJ5emhYcnFEdVQx?=
 =?utf-8?B?RW1qcWNveGxGYUZKNkdqUXBkV05FNHcvUUdYMnBWejk3eHkvUXUwK1grQ2ps?=
 =?utf-8?B?ZExnWDNvdEl1VkdqSDR4M3YvUm5wT0U2Umtqek1qTFNSd01zOXhWbU9ZR2Vx?=
 =?utf-8?B?K2gzeWd5VHk4N250a0Q3OGNrWmlGbzRGV1lSd00rTXhUQmUrbjhObjloWktI?=
 =?utf-8?B?b0oyaUk0M3FLZGh4TytiMjV3a0ZvZUYrUzV3ZzgvWUZ2bFRiK0FtUDVLV3I1?=
 =?utf-8?B?TzhpUFk1eWRLREZUcUQ2RkoxaFdMZUIwWWRjVm4yZ2hvMUhYWVJuMnFGZVpC?=
 =?utf-8?B?d1UranNxeXBqMGhZaU9rM1F0RjcvSFNEWDdYREVTK2pFQ0NuYmg4ejRtaUNI?=
 =?utf-8?B?dWhpVFlwSHZXOGE3TEczeUxnakJpVmRzYWlIN0dHZXZlbXBieXF2ZmJ1eWNW?=
 =?utf-8?B?dGJ2cXRmQm5ZaVJDcGdza2VGYkYybEczMTRTdnlQTy9zU1hlT0hIWE96TFYy?=
 =?utf-8?B?Z2hIa3NSbWk1VHpmbnFrNjFBczlFODBqS0FZMFVvc0xlNEJiamg4T1AzTzRu?=
 =?utf-8?B?KzhLYllFcWdmZ2s0L0RaNldtMzAwMktyNjlUbHRqM0dQMnJNMGE4V29YeXVP?=
 =?utf-8?B?b1NGZ0llSVdFZzFja2FQWEMzQ2FmZlJLSkcxYWxWTFNUYW5MRVdZREsvZHJO?=
 =?utf-8?B?RXNlNHdvL3FFZkFzSDk3bGowTGNOd1VJR2tWV3pxUkUyL0lSMm1SYjJMeGU0?=
 =?utf-8?Q?derpY7?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b3FjVnN4T1J6L1c1c1pYUm5NRWpaMGoyNWZuOVR6ZzNkYUp2bzlCRlVxUTlK?=
 =?utf-8?B?V2FnN1ovRm5BR2dHVldZTllyV01SR0xtZnNaVWJvM0g5YzQ1Nk1oZ0w5Rll6?=
 =?utf-8?B?Z045ajF4MEdINjRGMndLYmpDUkEza1B2d01kcWpHeUVYakZRWElNNW5lY0hx?=
 =?utf-8?B?NXRmb2ZzRWtUZnhqM3YvVjlob2V2N1hZdWUwY1UzTFBjUFZDL2dFNnNKN2d4?=
 =?utf-8?B?RURVbVBVVU9BUnJNRHJpQWdZOG4rMGJ3STBwVTZWdXlJSnV4K1JiNU9QU0F2?=
 =?utf-8?B?TlQxVCszQTJOS2VZQXo0NFVBMnlUR3RmTU54T3pXTHlHUllxNlAvcXRhekZM?=
 =?utf-8?B?OU40N3Exejh2U1JEb3JaaVlidDFnOGluZkFvL1lTQkxTK095UnpRaWFLZlBk?=
 =?utf-8?B?U2IyMXFPZ1dOcVQyNkJ1TXFkU0s5SlYxNU01YmQ2TGJxTW5PYy9PeDZteVdM?=
 =?utf-8?B?YUtiTHdLNm5tZjRreEE2bVU4bVBwYlBhQzAycXdJRjcyd0E1aVJ0SVM4cStP?=
 =?utf-8?B?N2JYY25IS1dnMld4SWlLcUliZzc0S2NRam1hcUUvUUJkSmw2dVBpTzhwVnVO?=
 =?utf-8?B?eEltak9POGFaNVEvOVBkbnd6SElvOFoyczRGZEgvRk5JVmV5THRFWEdKcU0z?=
 =?utf-8?B?UVh0TTJabGJ1clJtMXBCbmV1anIxTDVHSm0yZTJsZWxVQmpJZGV0VThWYVNU?=
 =?utf-8?B?Tld4bi81MjF1STlEUkowMkJsb2gvRmVwSTVEZkxNM0lRU1dQbnA4VDkrZVFK?=
 =?utf-8?B?MVVFcnorNWg3Tjh0SHlUT3VBM1B2U1RtOUVCU3I4eTMyRVllUXZnVHpCTi9W?=
 =?utf-8?B?OVVsR25DRW5MY2gxNlpYelNjMGdCREZXTEVzTWE5MmVjdTBrbyttMXA1aWd1?=
 =?utf-8?B?SnpWbktYZC91ejBzTDl0ZVZHeGNuUzB2REsxVDZzaE9Ea1BNTlhyK1dLWGhp?=
 =?utf-8?B?c2IxUE5LYzJEenluTHR6ajU3a3Bnak50SW55bDVrNHRCcW5kTTg3cnlxb0xh?=
 =?utf-8?B?cTZ1Q0p5QmM3NDljQ2pCcllRRkRhRFlKOVpVMFFjcDR4YnNFT1lsdTN0Q2lE?=
 =?utf-8?B?ZHNkRjhDcG11Uk1DODRXYW9NKzRKYWVveXVLcVp4bGdMcEJDOGtJNjlnYjFa?=
 =?utf-8?B?LzZQTGRQZkJqNittekZaNko4eFNrazNJc2JaU1hqTm9WR2ovYy9tNDRLajMw?=
 =?utf-8?B?dytLVTBhSGdxUnlaM2t6UkFaZ0JJTm92Sk0xT28yQlRyTUZlVVBPVGJiTEhi?=
 =?utf-8?B?cmJNc1V3UVNGaW9uQW92UHpjYWl6d3ZXWmxWSnhybWYrcFJZNzhCWXNqcHdj?=
 =?utf-8?B?MUJ5T2lSUFNnKyt6SkI5RVRsR2grWHNSL2I5b2duQkFNcVZyVTFLRDMwRjhX?=
 =?utf-8?B?Q0c5eVp2cTNRUjkySTcyYUdQSkRVN1c2RldiYlprTDlDWk0yNWlaRWFncFdu?=
 =?utf-8?B?Z1hYM1hoaEZHdjdnNVYxMVFOZlVUSGx2bSt3OUpYc3J1UVk5ZmFEZ09XYS96?=
 =?utf-8?B?dllqMUh2cFRJbEVFbm5RcktGQXVndk50MUN4Zk9FVGgzZkh5djZ3Uk5nRkFB?=
 =?utf-8?B?YzJWaERSUHFlcU8zUTgxaXBkS25NSytYUFhhOStuMTlsa3pYNWxoQlZ5SVR5?=
 =?utf-8?B?QVV2MXFmdDNzSm0xM29ZOWxlaUpXSFp5VE53cXFoMUZrWGo0MWJxNUhNdVFQ?=
 =?utf-8?B?dkE3WXZsUHF2UHhTRG81bmpIVjFVbEZjSVJJMUEya21QTzlVd09sc1R4WkNL?=
 =?utf-8?B?S25jRnRRU1NxWDFIK3JOa3dyM2JJV09Jb2VDNXJ4YXV1UDR1Mlp0VmFPeWNL?=
 =?utf-8?B?YWZXN3RQOURER1ptS096ZC9iR2ovQUVSeW5GSmw5WFc2T0ZjakQxSUI0ZUdS?=
 =?utf-8?B?RGFJYlZaVmRWZ3FzR3dLbUMvanJSbzZzQ2I4NnZzaC9KMldlelcyQ1hwVyti?=
 =?utf-8?B?dXpzTGUySkZkRm8wbG12WmpjajFGSmkxV0lYNlRoSUhmamN5WVlUV1NEOXdo?=
 =?utf-8?B?cjZ1cVJnN0g0cGRidTdwYk95eTNiNDh5QjMwbWlyR1V1U2xTaVRvWFJOU2pp?=
 =?utf-8?B?UHNaUDE1akV4cUR0U0ZiTzFkRHI2aGZmL1Z4aFpQOXdROE9YYjRoTHlROEdj?=
 =?utf-8?B?aG9vY1pWVEVUbVhQQ3poZUwzUFZaSTNoMEVVYmRWTGhDU0lieXU5VUU4VXQz?=
 =?utf-8?B?SlIxWUs1UDJjRERNcnZFeTgrOG5uNVVvTHBuSGVuU0ZmdnVDK2FuTDArNFNk?=
 =?utf-8?B?RnRzTE55dW8wa0ZZUTIzUFEyTjBvcjJNR0xCN053TlNiM1hQZDUxaWEwUHpM?=
 =?utf-8?B?TUtHYU12dGxobHd0dzJLVjJ1RHZsZlc0YVRGaFVUQ0FNNTBNM0x4UmtjV3Js?=
 =?utf-8?Q?urXVB75xMczOd9BVnJrsRZ4vG3ZflWREVgu2dgRLimhO+?=
x-ms-exchange-antispam-messagedata-1: yL+w+UnV5Xtzllb6Hqq/CodEqRkWmU730Sk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3488169F2A594B4298DF886724ED8E05@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd71284-4c2d-4e1e-3cd8-08de41d9ec3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:35.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I1CTj5W/om3NDeaKek3jQW9jAKTPTet5u9Ggr9wXkRg1s+7L6X5GqFzGhTUK8Vo87w/PYXD0c1n7Oz5rG8HhmbHtNrxuc0d+IcKHgUII+7s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Authority-Analysis: v=2.4 cv=KNNXzVFo c=1 sm=1 tr=0 ts=694a1769 cx=c_pps
 a=ba6qusln56cF+elEDyS4hw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=fSbrKvJzvW48NGn5wUEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX54k+D4PouH8d
 NBWtkWDk6rEaVLEPDaZ2Ndwj8iZFEu8p0FBFRCKlnG4mlkfN569tj3e7XyLz7JuGlhbflurMeqp
 mBLDtvJ62T4mHvxM6naEuUb6eDVoDapE+XXg+jvaa2/WwetYq4EaoWtlwjuf0r+q/0Jzo4J3ej+
 vviGWXvATHchg+1Tp3xiiYb1DadGWp27oxLBsJoMmCnRERtd0HShWkrWBxW24BRixUSPaw1c9gE
 jwRuCSV0Hl4edUUiQB+6w/GOGfxvTfsUhtuXTe6IBBvuE9sGQkri3ZSJEwjlWPxjUp7wxPdV7hZ
 U9XxQZgzdbLNnz6PMl5OsRugWe+5J4+2Iy59jFxi7BdD7iQqNhemEUMeTUNxce7qNk+FYucebtL
 wpzvJzONMZHyeJBlyR8L5DSqqbp1Rnf/oh1DPRbFhTHDS7WOR+psb8Flhmif63IRAPnOeu8b8lr
 XlE5CZrIiDBSTcRbdsg==
X-Proofpoint-GUID: kFA1Ie_P_JitzcQc-PUSgjFQhMqmw-Rp
X-Proofpoint-ORIG-GUID: kFA1Ie_P_JitzcQc-PUSgjFQhMqmw-Rp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjIz4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gQWRkIGxvZ2ljIHRvIGVuYWJsZSAvIGRpc2FibGUgSW50ZWwg
TW9kZSBCYXNlZCBFeGVjdXRpb24gQ29udHJvbCAoTUJFQykNCj4+IGJhc2VkIG9uIHNwZWNpZmlj
IGNvbmRpdGlvbnMuDQo+PiANCj4+IE1CRUMgZGVwZW5kcyBvbjoNCj4+IC0gVXNlciBzcGFjZSBl
eHBvc2luZyBzZWNvbmRhcnkgZXhlY3V0aW9uIGNvbnRyb2wgYml0IDIyDQo+PiAtIEV4dGVuZGVk
IFBhZ2UgVGFibGVzIChFUFQpDQo+PiAtIFRoZSBLVk0gbW9kdWxlIHBhcmFtZXRlciBgZW5hYmxl
X3B0X2d1ZXN0X2V4ZWNfY29udHJvbGANCj4+IA0KPj4gSWYgYW55IG9mIHRoZXNlIGNvbmRpdGlv
bnMgYXJlIG5vdCBtZXQsIE1CRUMgd2lsbCBiZSBkaXNhYmxlZA0KPj4gYWNjb3JkaW5nbHkuDQo+
IA0KPiBXaHk/ICBJIGtub3cgd2h5LCBidXQgSSBrbm93IHdoeSBkZXNwaXRlIHRoZSBjaGFuZ2Vs
b2dlLCBub3QgYmVjYXVzZSBvZiB0aGUNCj4gY2hhbmdlbG9nLg0KPiANCj4+IFN0b3JlIHJ1bnRp
bWUgZW5hYmxlbWVudCB3aXRoaW4gYGt2bV92Y3B1X2FyY2gucHRfZ3Vlc3RfZXhlY19jb250cm9s
YC4NCj4gDQo+IEFnYWluLCB3aHk/ICBJZiB5b3UgYWN0dWFsbHkgdHJpZWQgdG8gZXhwbGFpbiB0
aGlzLCBJIHRoaW5rL2hvcGUgeW91IHdvdWxkIHJlYWxpemUNCj4gd2h5IGl0J3Mgd3JvbmcuDQo+
IA0KPj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gDQo+
PiAtLS0NCj4+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAxMSArKysrKysrKysrKw0KPj4gYXJj
aC94ODYva3ZtL3ZteC92bXguaCB8ICA3ICsrKysrKysNCj4+IDIgZmlsZXMgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC92bXgu
YyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4+IGluZGV4IDdhOThmMDNlZjE0Ni4uMTE2OTEw
MTU5YTNmIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPj4gKysrIGIv
YXJjaC94ODYva3ZtL3ZteC92bXguYw0KPj4gQEAgLTI2OTQsNiArMjY5NCw3IEBAIHN0YXRpYyBp
bnQgc2V0dXBfdm1jc19jb25maWcoc3RydWN0IHZtY3NfY29uZmlnICp2bWNzX2NvbmYsDQo+PiBy
ZXR1cm4gLUVJTzsNCj4+IA0KPj4gdm14X2NhcC0+ZXB0ID0gMDsNCj4+ICsgX2NwdV9iYXNlZF8y
bmRfZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllfRVhFQ19NT0RFX0JBU0VEX0VQVF9FWEVDOw0K
Pj4gX2NwdV9iYXNlZF8ybmRfZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllfRVhFQ19FUFRfVklP
TEFUSU9OX1ZFOw0KPj4gfQ0KPj4gaWYgKCEoX2NwdV9iYXNlZF8ybmRfZXhlY19jb250cm9sICYg
U0VDT05EQVJZX0VYRUNfRU5BQkxFX1ZQSUQpICYmDQo+PiBAQCAtNDY0MSwxMSArNDY0MiwxNSBA
QCBzdGF0aWMgdTMyIHZteF9zZWNvbmRhcnlfZXhlY19jb250cm9sKHN0cnVjdCB2Y3B1X3ZteCAq
dm14KQ0KPj4gZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllfRVhFQ19FTkFCTEVfVlBJRDsNCj4+
IGlmICghZW5hYmxlX2VwdCkgew0KPj4gZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllfRVhFQ19F
TkFCTEVfRVBUOw0KPj4gKyBleGVjX2NvbnRyb2wgJj0gflNFQ09OREFSWV9FWEVDX01PREVfQkFT
RURfRVBUX0VYRUM7DQo+PiBleGVjX2NvbnRyb2wgJj0gflNFQ09OREFSWV9FWEVDX0VQVF9WSU9M
QVRJT05fVkU7DQo+PiBlbmFibGVfdW5yZXN0cmljdGVkX2d1ZXN0ID0gMDsNCj4+IH0NCj4+IGlm
ICghZW5hYmxlX3VucmVzdHJpY3RlZF9ndWVzdCkNCj4+IGV4ZWNfY29udHJvbCAmPSB+U0VDT05E
QVJZX0VYRUNfVU5SRVNUUklDVEVEX0dVRVNUOw0KPj4gKyBpZiAoIWVuYWJsZV9wdF9ndWVzdF9l
eGVjX2NvbnRyb2wpDQo+PiArIGV4ZWNfY29udHJvbCAmPSB+U0VDT05EQVJZX0VYRUNfTU9ERV9C
QVNFRF9FUFRfRVhFQzsNCj4gDQo+IFRoaXMgaXMgd3JvbmcgYW5kIHVubmVjZXNzYXJ5LiAgQXMg
bWVudGlvbmVkIGVhcmx5LCB0aGUgaW5wdXQgdGhhdCBtYXR0ZXJzIGlzDQo+IHZtY3MxMi4gIFRo
aXMgZmxhZyBzaG91bGQgKm5ldmVyKiBiZSBzZXQgZm9yIHZtY3MwMS4NCj4gDQo+PiBpZiAoa3Zt
X3BhdXNlX2luX2d1ZXN0KHZteC0+dmNwdS5rdm0pKQ0KPj4gZXhlY19jb250cm9sICY9IH5TRUNP
TkRBUllfRVhFQ19QQVVTRV9MT09QX0VYSVRJTkc7DQo+PiBpZiAoIWt2bV92Y3B1X2FwaWN2X2Fj
dGl2ZSh2Y3B1KSkNCj4+IEBAIC00NzcwLDYgKzQ3NzUsOSBAQCBzdGF0aWMgdm9pZCBpbml0X3Zt
Y3Moc3RydWN0IHZjcHVfdm14ICp2bXgpDQo+PiBpZiAodm14LT52ZV9pbmZvKQ0KPj4gdm1jc193
cml0ZTY0KFZFX0lORk9STUFUSU9OX0FERFJFU1MsDQo+PiAgICAgX19wYSh2bXgtPnZlX2luZm8p
KTsNCj4+ICsNCj4+ICsgdm14LT52Y3B1LmFyY2gucHRfZ3Vlc3RfZXhlY19jb250cm9sID0NCj4+
ICsgZW5hYmxlX3B0X2d1ZXN0X2V4ZWNfY29udHJvbCAmJiB2bXhfaGFzX21iZWModm14KTsNCj4g
DQo+IFRoaXMgc2hvdWxkIGVmZmVjdGl2ZWx5IGJlIGRlYWQgY29kZSwgYmVjYXVzZSB2bXhfaGFz
X21iZWMoKSBzaG91bGQgbmV2ZXIgYmUNCj4gdHJ1ZSBhdCB2Q1BVIGNyZWF0aW9uLg0KDQpBY2sv
ZG9uZSAtIGFsbCBvZiB0aGlzIHdlbnQgYXdheSBpbiB2MSBpbiBmYXZvciBvZiB0aGUgYWR2ZXJ0
aXNlbWVudCBpbiBuZXN0ZWQuYw0KDQo=

