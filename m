Return-Path: <kvm+bounces-26828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D43F797852E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 17:52:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BF9E1C20DDD
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 15:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BAC75817;
	Fri, 13 Sep 2024 15:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uwk+KaZs";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="J94tLqBX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1A74418;
	Fri, 13 Sep 2024 15:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726242712; cv=fail; b=E/Wtk+r/mMHKzSypfms8WsfkpgJ5TJhLRZWmmJQ9t7G3DLEWhiVm/EW17YAQ0RYB44N4zoViJrzUThOyo2CUFPIJyUrvkTDpzeGujfxkZLo4/kN1jKbZ5P0dlIPWaiKfQwg+4kL1qW8lHrHqAptPDXRPLYb+cDmozAW2RUyVfqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726242712; c=relaxed/simple;
	bh=lgT/3Vt47RVS7WgDEcRMfqoKCGIWxo6uh5gMszf/XBY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fAfxp3RJSg1aJMd8zGYGHAzA82lofLpn2Y0BqaqFwIEiiBxlJSlQKY0lg2eIht3ndgN7IRW5UW4pv3xcH+uNh3hXahS7HOxS1Rnjo8BSt0GkNQHyiJOsRUG4FsOilN9FsSak3RUpPm/E7W3ZR2WOT8oMfRJoIQVdDeqp1ymM2qM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uwk+KaZs; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=J94tLqBX; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DBR8rX010145;
	Fri, 13 Sep 2024 08:51:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lgT/3Vt47RVS7WgDEcRMfqoKCGIWxo6uh5gMszf/X
	BY=; b=uwk+KaZsljIS0ix82AH2uwRU+Q/NiSWb6nEzRTYkHH11UNQMzSOu9k8AD
	6Mtl6TiuogbEKG/C9EYUWSb8YaP6qOHolU+F7AJcr4/YBg84P61/6BPIclSVDnUm
	rV41aa7+TS0bG78IS7eNp+bc76VyYRx6v+IlY5w43FKZdYnGU97A54f8+30t+M+f
	7luqS2B89AVSsO48zxl4KErjTZBO544bZnPcuUoZJ3JdWJd1A2RNqBgRUoUaCY49
	uQBb6Q7VySNRC2L6vbjbGfaONcluftn2hg1gT0rVRqj/U5gEbRgpR15D9axWfM4H
	6DhTzn2iwtz1fKHTgnNSAtUJYYnrQ==
Received: from cy4pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17010007.outbound.protection.outlook.com [40.93.6.7])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41gjr7ye1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 08:51:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3Bt6LK1UOrlHisoky4yxLetpXF+71soPoU6mxsyjrsJ5YkZq0jcMKiHkczGhUYiXicKbjd5Cn9MBHWg+6LFg548KPVOU8cxKlqqOTEozIv82ziHme34tI1WtK5GzmCF/vqoycQ+4984ja3XeFEZmudRtmd458jMlRSDzEhDm5zwHQR4bn/DmoQd7CqkRvUzwulhlT8RvjQmGK3sAp4Ni7C0rtvv1uXvoxBj49+gMy4M9yhlfARBm/aQ27GPIPq2GuVQUMqKbUfUZ9+qTYP4Gk9XQ/yQvgb9Arb8VGNajlYmDfDLqe87qzUHZOK83jf4y1XDAA+HybYaoMgVIWmfzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lgT/3Vt47RVS7WgDEcRMfqoKCGIWxo6uh5gMszf/XBY=;
 b=jJ3ZXulZK8xQra6ubxLhK2SDeL0FGbipoIcU7S+dmmfbR/7E1d2/JR5XzhugQVos54l9SgbagV0HRJPun6hRS2wO6Ty5yXcajFlkXiJrbTOt1Sh4148z2rcJ4uRy7l7PB871/Z/sHTqHnjC+V6CGCohKUAW+4VqbEDdjBSWkAOYRD1s4p1hZgzi6sl6vxDl5oYddmny0Ac+odE5kFL6NugezE4oglT4ELTEPn6p/lLOnEhI80cgGakG041O0jI46Eov3911wtKwpNGBYb+6gT4xiogluL5yP6TJE6fJ3sj3AlG5C7c3htvnEcOGlplDG9kqNmAI1sFtpux+gO87aWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgT/3Vt47RVS7WgDEcRMfqoKCGIWxo6uh5gMszf/XBY=;
 b=J94tLqBXCgaTQFGDtes9wpAvwpsH9raLD8nSIzZjzn+FPYix3SCB9D6Oko3yObxwZ19iJ6j4ktbDzU9o73+Qw82GOgP76WFSWouV6BiO84h9qZrXyM3EnrrhHR7nlxqjqfkDqV9NL3FjEDsAVUBJr3rT6xSAfCcRWTCTegmp3qVIT5QoFOqw2X8hRsc2sK2j6LB8Cp4xZk8yQzxpqdgSMDq5GieRvBtt/30CxPS47cLbCK3QefHcGD/8VjmyCL9c1XYSbVkNBIQhJfsApk8sEuXoGecCuvu9p52l9pnLSmMqXgcqaXLtjSSNn4SpUuc6pcCXgkXEhlGKtuglfmlRbA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA3PR02MB10519.namprd02.prod.outlook.com
 (2603:10b6:208:533::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.27; Fri, 13 Sep
 2024 15:51:02 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Fri, 13 Sep 2024
 15:51:02 +0000
From: Jon Kohler <jon@nutanix.com>
To: Chao Gao <chao.gao@intel.com>
CC: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner
	<tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra
	<peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar
	<mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, X86 ML
	<x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Topic: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Index: AQHbBRtn4jznGhv7KU+IMqTomlXzNrJUQp8AgAAIdoCAAAs8AIAA2x8AgACtw4A=
Date: Fri, 13 Sep 2024 15:51:01 +0000
Message-ID: <3244950F-0422-49AD-812D-DE536DAF5D7E@nutanix.com>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
 <20240912162440.be23sgv5v5ojtf3q@desk> <ZuPNmOLJPJsPlufA@intel.com>
In-Reply-To: <ZuPNmOLJPJsPlufA@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA3PR02MB10519:EE_
x-ms-office365-filtering-correlation-id: 1811c929-c44b-43e1-2dc6-08dcd40bde63
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZFYxTkRLOGFYRVlSandJZUJCb3ladDRoSGhLTlFLR1BvcTN1a2tCSnFFcVkx?=
 =?utf-8?B?a2VOVHcxaGljdDBVcFAvdzM5cWxYaDlZRmxNQUpVMDJONzF6V3FsWHg2eXo4?=
 =?utf-8?B?S09vZk5IUGtyeGVmaldmc2dUSEtmUm9FUjdMZk1sWWgxUDlrV1BSRk9vU3RK?=
 =?utf-8?B?STAxZktaWDk2dmRsOXdQMUFwRmdmVXdBUjQ2U2Voc2lXejl5WEJKUXFhRmlP?=
 =?utf-8?B?Yks4T3hpdmlsSEkzSHZqQ1RNcDU1NDgvRm1LMzRFWkcrOEI3ZENuQ1NFODAz?=
 =?utf-8?B?VHlFY1hLWno2UXRCME9GUDNUdFRoN3NiVWt2MlAxRmJ5OE5wVThEMEMydE13?=
 =?utf-8?B?bFY0bTRNTFVCNHE4M1V6VWtDZzlmaGlOZzZPditWTVVXWDh4aFdNZ05DWjVT?=
 =?utf-8?B?UGV0YnNCQlpXWDhSekJ0LzBMQlhtclNTSXZCSTJFdVF1TGkzMzRvL2ZoSEtv?=
 =?utf-8?B?Um5YMmhabnM3dmhNNEhQUmxWNHVFMnNQbzA3WndWeGZyd2I4OEhEc044OWN0?=
 =?utf-8?B?L3FNdUdUS2Q3N3dtQXFsZEtCWndDdVRZdGpLeUlDaTlndWdrdmdUUDFtMlgw?=
 =?utf-8?B?VFJjaHFFSk1abHBXSGpJbGNYc3pnVE9ZdXIzUStGNTBSbUxOK01jdmwvb25p?=
 =?utf-8?B?RTZ0VjJsbHpIU3l0dTgvWTFvUzFMMnVYYnRrOGNDTzRoaGlVU2R5VEhNSHJ0?=
 =?utf-8?B?djN0NGpheXgwR056aUNiTzdmb1JJOUhBRTNXdjRUOGkxaUhqV0FuOGhrRkpG?=
 =?utf-8?B?VitVRmg5WEcrZ01XeFU3WGliRDZuZWwvaHZON3NVdmZvR0M4aldGeEhjazA4?=
 =?utf-8?B?b3pOVlB6RzEwOVRUdUwvbGJGNDcyZHJLYk9RU2lXeEtDcy96YzJFejRFNlZk?=
 =?utf-8?B?MDFTY0VKcm85eWEyMitHRlpJUW9rUnpDbGRxR29TbjJJbmhpZUdrVzZmeGpk?=
 =?utf-8?B?RVk5NWhjQ2VhVlZpTGI2cWdJZjltS3lZYVhxaFMwbkZhMG1HeldTb3hoRFBG?=
 =?utf-8?B?UXlKTFRSa24rM2NpVjcxbi9pdTZnd3dJWEtmTFJ4MFhQcWtWN3NiK2hFcUxH?=
 =?utf-8?B?QytZMUxGdmxaVXBmWG4wVVZjWmRBOVVlTm9sUlpoem9Tb2FDTFQ2d3h3MGp2?=
 =?utf-8?B?RTUxNE43ZW1FODRqUlVwZ245cVZKNmc2QldmZjRsVzhEMzdBa3dEQUFhV2xP?=
 =?utf-8?B?ZWdLT1FWeXVCT1VsbnYraTdBK3lvZUQzOHJaeit0dm52MldxVWoySGMzM2I0?=
 =?utf-8?B?bmk2Tmdtam4ybHlreVBkNmNWeCthQ20xOVlTcDVkQUNsODJVREhwOGFWSW01?=
 =?utf-8?B?aEpsWDhtZVlNL1ZzTzdEdDc5aitRaUxuYUNuSjZZUS9QcEUrWkVORStqZitq?=
 =?utf-8?B?MFJ5TU9tV2VDTC91cXNQam11VGVzQU83bWNmeFVSK0VHMTJrV2ltVjI0OW95?=
 =?utf-8?B?d1NoYTF0QW9PL2FiVzB2SnVaaTNrRGpDZGlpZzdJRHJKa2pWOVdGZDZtb2Fj?=
 =?utf-8?B?Wm5tWnJDcUZQK2RDTDBxNGxUTjhvWkFRa2FxU0tuL2s5aW9QcHJlbXg2OE1R?=
 =?utf-8?B?Ymwyd2RZR3czWE02bjYxOUJtNFpzNFBGNnd0ODBTRk9DaGhSNTh4TU9oTkJk?=
 =?utf-8?B?VmY5RnpRSld4K3YzN0RKUnFuRGo1cUhCdUdvelhlV05UVlVtVmhtMU9iTm50?=
 =?utf-8?B?TFhjREc1OU1jY0ViOFhnOFZONTdNMWVMMDgvazNWdGE5d2IrN1RkbWtBY2o0?=
 =?utf-8?B?dkVGOXZKWnpSNm9FVTg1bWdQZm03blg2djgyQUd5RUFKbjMxRkY5Q2ZoWDA0?=
 =?utf-8?B?ZHd2WHdLbG1Gb3d3RkpzYWRBMVlYMEVFMnZTQmVRVXhkOUt1WkJCZm9iQm1P?=
 =?utf-8?B?aCs2eHFJM1BTS2tvN1hicGVBeTd2MjkvS3JqU3FCaVd0YWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QXJ2TXJuWFhsOElzVjZHSUJYcU9tWTJya2xTajlSSk54eGlWQ3hET3M2c0VZ?=
 =?utf-8?B?ZnJlUVZMcFloUkVuUFR3TUVoMmJyN1Q5c3M5YTVyTHF2ck5ocThBbU5FS1NB?=
 =?utf-8?B?Ty9zZ3p4RzVYTTZPOTByRFBFQ0hGcXYrQlBOb1VmU2JNQzJkKzRXZWNzZDc2?=
 =?utf-8?B?d0UxT0F5YkEwZUpEbDBpbmtMMXdXYnFLTkIxVTY2K2VWRU43WlRSQ2VSNFRy?=
 =?utf-8?B?cGsrSm5QSjZWYUNDSThvRkhmaWZ6OGRValFpbVFLN2RnNGhRRlh0azY5UDZO?=
 =?utf-8?B?akIxbDBCUkdQeTY4RmZvaTd5THgrOUVYbmVmZTZJTkt3R3RzSjJGTHpiWEdw?=
 =?utf-8?B?YmxhZ1B3R3RmWHZ4eDE5NFFtWU1oOEExZUYyVmdzVUR4a1NscWZDUmJKOENZ?=
 =?utf-8?B?Rk9pbHVSckxNNzNPbklod2Nza1JHNjVmM0pydnl1aGtiQnlzWkRVMmg0ZGNu?=
 =?utf-8?B?ZzA5U1V6T1ppY3NjRHVWa0liU2xNdkhhck1WZkN5VmdRSlEzV0x6cFVPTUhF?=
 =?utf-8?B?Nnc1cmxXVlRiMGxXK29hU3VDREpZY1kwcFJUOTRJYnJ5aExJdDFvaWFKaThE?=
 =?utf-8?B?QzFaeGFwampWbWVXajN1M3RCMi9VWU0xV0RjcWlvVEZzN1R3Qy9jeXNSZFBy?=
 =?utf-8?B?RUdxdU5NMDYxT2NpUXV0K3MrVURFMzhEajBGcUZSMVliNHRzTWlqdzhpNGNx?=
 =?utf-8?B?UGRrQzhKZ0VtQTQ1b3pRVCsyWWx6ZVBzc1lycXBOeFNZMmJlblhOZmxTczV1?=
 =?utf-8?B?aHhtakZtQnpkWnNYZ3NpNUFET0NMa3hJY1NFUm9KRC8yODJhQUVZUHdPcU04?=
 =?utf-8?B?dDNpNFozWjRlNWNQSGREN0NBZ1hpZUpZWWxlT1RNZzB6OXhCZXVUZFdTQjJK?=
 =?utf-8?B?Tis3M1I1bFp4TnhPNk93ck94M2V3UThaeDRuVjN3Z3M2a2VMWkY1T0RTT0VG?=
 =?utf-8?B?M3hqUk5jYW5XWmRDaVFsemk5OEdaTFZTMWxEeitlb29FeHpCcFpxZ0JOWWxi?=
 =?utf-8?B?V1VucXovdHZsMU1meHQ1cThHcDZGRUEwZml6OHBiYm1MSmk2YWsyTEUvRVlK?=
 =?utf-8?B?dDB3bFdJQ25ZOWhiWDZxV2VkdWZKbHUxdlA5VFdtTnd6VHorR252WVN5VTZS?=
 =?utf-8?B?bE5ORHVNOVlieDJTbHhYRXpwdVFDaWlEMW85L0h2bEp3V1kwU01Xdlc0bDhF?=
 =?utf-8?B?WkxQdXVHd0VvTDRRM3RuQWt0U1hoQVpNeEJ6Z0x3T3d4b0w1TytzYWZNdDhq?=
 =?utf-8?B?RHdydFJLbHBhOGtHbFpKUk5iaktWdzJXdVlDeTFWSHNUS0hNZHZiY254cmFR?=
 =?utf-8?B?Tkw3TElUY0NNbDZpZW1vRHdmdXJKdVRzY3hYbFMxWUdXY1JtYjFvdDF5S3Qw?=
 =?utf-8?B?eFg4S0tGTEVwVWpRR2ZiKzhHZko5R3BuSXE2OHZuTWtZTjh2amFQRDhHcFNX?=
 =?utf-8?B?RzVFOURMV1lLSE8xNlIzR2Jhd0ZwWFdFUVRBYnJnejRCaEg2d0F1MHpBN1c1?=
 =?utf-8?B?dVRGMnQrdXNxWE5wUk1xWTJxY3E5OGIya0hubWdZbkhqS0J6RFRGdVJ1cFFI?=
 =?utf-8?B?dzYxU3NXbkpJNHEzT0FVb2NZbDlDdWdmZWlFUSsrWnlkeUVNc0tZR0JkY1hK?=
 =?utf-8?B?WTROb1dCcnVnc0pYWVlkVHR1RjVkYlNnR2hCNzJwVk1DOFhrcC8vVTlCUER0?=
 =?utf-8?B?alE4WjVyaHg0alJCOUNybVJlSGVTV1ZibXBXc2xMVHVCTWhiR2NZS3lzOXdB?=
 =?utf-8?B?cHF0VGsrZjRNWDJmQkNiU29ZRGJPRURJaS82dmF5cURnVXliWTUxc1h2V25r?=
 =?utf-8?B?TGkrTDErMDk3b3NMRU1mQzRxbXJEMXVEa1BlS2F4aHlzS1o3d0FoZ0YzYnND?=
 =?utf-8?B?TXJTOUFna3RJZUI3T3VDaFFLWUJabEJxYWlhQVdaWGlobEVCK3lkZENjaHQx?=
 =?utf-8?B?MG9aNnpNNEhudDY5Z21wbFo5aWtONzBDODFYd1lZZHFOSml2ZnJoK1pvMmhG?=
 =?utf-8?B?UVhZa1MrVEdVaCtDUUJxVnFJMEpYQVV0L3hSK09MWHR3NUt2T3UraGM0UkdR?=
 =?utf-8?B?V0FLbk5YeElEbERoN2doNyt0Wkx2ZWtqOWxGZU05Q0pMUnJSSTVlWTNFdHdX?=
 =?utf-8?B?aWh2MTVNNmlmRVc0YnhYNjYzSmQ1NUFnaXMxd05qQVZaYnNkQ1ZLMFFQWDgv?=
 =?utf-8?B?d3NnT0ZGUXprYnBVRXpvOXdXbXFxdyt6KzNvMC9sVEx0VlBsamk4Z3RrQUxh?=
 =?utf-8?B?Q2NDalFyYWROa2ttZWR1S0xiQzh3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FF27E52F600BF48B80BFEF0DEC3560A@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1811c929-c44b-43e1-2dc6-08dcd40bde63
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 15:51:02.0036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BO5Iq9fkO3u27V9MvOOh2MU48V7kxMEJYJRRn0dpEcBA84Pc8KDqC5bKVlIMv7WvaekW90ukiI7eo6WzBBEH94EuT3AzzCout0i/L5Hv2QA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR02MB10519
X-Authority-Analysis: v=2.4 cv=J9z47xnS c=1 sm=1 tr=0 ts=66e45f68 cx=c_pps a=6nUVeFXZkCqfDP2MWDHPNQ==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=QyXUC8HyAAAA:8
 a=VwQbUJbxAAAA:8 a=6t8ktNIx8MKHhpzd5TYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: jjimaSn1QRiLpdiycJ3qxbbVtL-lPHti
X-Proofpoint-GUID: jjimaSn1QRiLpdiycJ3qxbbVtL-lPHti
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEzLCAyMDI0LCBhdCAxOjI44oCvQU0sIENoYW8gR2FvIDxjaGFvLmdhb0Bp
bnRlbC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+ICBDQVVUSU9OOiBFeHRlcm5h
bCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBUaHUsIFNlcCAxMiwgMjAyNCBh
dCAwOToyNDo0MEFNIC0wNzAwLCBQYXdhbiBHdXB0YSB3cm90ZToNCj4+IE9uIFRodSwgU2VwIDEy
LCAyMDI0IGF0IDAzOjQ0OjM4UE0gKzAwMDAsIEpvbiBLb2hsZXIgd3JvdGU6DQo+Pj4+IEl0IGlz
IG9ubHkgd29ydGggaW1wbGVtZW50aW5nIHRoZSBsb25nIHNlcXVlbmNlIGluIFZNRVhJVF9PTkxZ
IG1vZGUgaWYgaXQgaXMNCj4+Pj4gc2lnbmlmaWNhbnRseSBiZXR0ZXIgdGhhbiB0b2dnbGluZyB0
aGUgTVNSLg0KPj4+IA0KPj4+IFRoYW5rcyBmb3IgdGhlIHBvaW50ZXIhIEkgaGFkbuKAmXQgc2Vl
biB0aGF0IHNlY29uZCBzZXF1ZW5jZS4gSeKAmWxsIGRvIG1lYXN1cmVtZW50cyBvbg0KPj4+IHRo
cmVlIGNhc2VzIGFuZCBjb21lIGJhY2sgd2l0aCBkYXRhIGZyb20gYW4gU1BSIHN5c3RlbS4NCj4+
PiAxLiBhcy1pcyAod3Jtc3Igb24gZW50cnkgYW5kIGV4aXQpDQo+Pj4gMi4gU2hvcnQgc2VxdWVu
Y2UgKGFzIGEgYmFzZWxpbmUpDQo+Pj4gMy4gTG9uZyBzZXF1ZW5jZQ0KPj4gDQoNClBhd2FuLA0K
DQpUaGFua3MgZm9yIHRoZSBwb2ludGVyIHRvIHRoZSBsb25nIHNlcXVlbmNlLiBJJ3ZlIHRlc3Rl
ZCBpdCBhbG9uZyB3aXRoIA0KTGlzdGluZyAzIChUU1ggQWJvcnQgc2VxdWVuY2UpIHVzaW5nIEtV
VCB0c2NkZWFkbGluZV9pbW1lZCB0ZXN0LiBUU1ggDQphYm9ydCBzZXF1ZW5jZSBwZXJmb3JtcyBi
ZXR0ZXIgdW5sZXNzIEJISSBtaXRpZ2F0aW9uIGlzIG9mZiBvciANCmhvc3QvZ3Vlc3Qgc3BlY19j
dHJsIHZhbHVlcyBtYXRjaCwgYXZvaWRpbmcgV1JNU1IgdG9nZ2xpbmcuIEhhdmluZyB0aGUNCnZh
bHVlcyBtYXRjaCB0aGUgRElTX1MgdmFsdWUgaXMgZWFzaWVyIHNhaWQgdGhhbiBkb25lIGFjcm9z
cyBhIGZsZWV0DQp0aGF0IGlzIGFscmVhZHkgdXNpbmcgZUlCUlMgaGVhdmlseS4NCg0KVGVzdCBT
eXN0ZW06DQotIEludGVsIFhlb24gR29sZCA2NDQyWSwgbWljcm9jb2RlIDB4MmIwMDA1YzANCi0g
TGludXggNi42LjM0ICsgcGF0Y2hlcywgcWVtdSA4LjINCi0gS1ZNIFVuaXQgVGVzdHMgQCBsYXRl
c3QgKDE3ZjZmMmZkKSB3aXRoIHRzY2RlYWRsaW5lX2ltbWVkICsgZWRpdHM6DQotIFRvZ2dsZSBz
cGVjIGN0cmwgYmVmb3JlIHRlc3QgaW4gbWFpbigpDQotIFVzZSBjcHUgdHlwZSBTYXBwaGlyZVJh
cGlkcy12Mg0KDQpUZXN0IHN0cmluZzoNClRFU1ROQU1FPXZtZXhpdF90c2NkZWFkbGluZV9pbW1l
ZCBUSU1FT1VUPTkwcyBNQUNISU5FPSBBQ0NFTD0gdGFza3NldCAtYyAyNiAuL3g4Ni9ydW4geDg2
L3ZtZXhpdC5mbGF0IFwNCi1zbXAgMSAtY3B1IFNhcHBoaXJlUmFwaWRzLXYyLCt4MmFwaWMsK3Rz
Yy1kZWFkbGluZSAtYXBwZW5kIHRzY2RlYWRsaW5lX2ltbWVkIHxncmVwIHRzY2RlYWRsaW5lDQoN
ClRlc3QgUmVzdWx0czoNCjEuIHNwZWN0cmVfYmhpPW9uLCBob3N0IHNwZWNfY3RybD0xMDI1LCBn
dWVzdCBzcGVjX2N0cmw9MTogdHNjZGVhZGxpbmVfaW1tZWQgMzg3OCAoV1JNU1IgdG9nZ2xpbmcp
DQoyLiBzcGVjdHJlX2JoaT1vbiwgaG9zdCBzcGVjX2N0cmw9MTAyNSwgZ3Vlc3Qgc3BlY19jdHJs
PTEwMjU6IHRzY2RlYWRsaW5lX2ltbWVkIDMxNTMgKG5vIFdSTVNSIHRvZ2dsaW5nKQ0KMy4gc3Bl
Y3RyZV9iaGk9dm1leGl0LCBCSEIgbG9uZyBzZXF1ZW5jZSwgaG9zdC9ndWVzdCBzcGVjX2N0cmw9
MTogdHNjZGVhZGxpbmVfaW1tZWQgMzYyOSAoc3RpbGwgYmV0dGVyIHRoYW4gdGVzdCAxLCBwZW5h
bHR5IG9ubHkgb24gZXhpdCkNCjQuIHNwZWN0cmVfYmhpPXZtZXhpdCwgVFNYIGFib3J0IHNlcXVl
bmNlLCBob3N0L2d1ZXN0IHNwZWNfY3RybD0xOiB0c2NkZWFkbGluZV9pbW1lZCAzMjk0IChiZXN0
IGdlbmVyYWwgcHVycG9zZSBwZXJmb3JtYW5jZSkNCjUuIHNwZWN0cmVfYmhpPXZtZXhpdCwgVFNY
IGFib3J0IHNlcXVlbmNlLCBob3N0IHNwZWNfY3RybD0xLCBndWVzdCBzcGVjX2N0cmw9MTAyNTog
dHNjZGVhZGxpbmVfaW1tZWQgNDAxMSAobmVlZHMgb3B0aW1pemF0aW9uKQ0KDQpJbiBzaG9ydCwg
dGhlcmUgaXMgYSBzaWduaWZpY2FudCBzcGVlZHVwIHRvIGJlIGhhZCBoZXJlLg0KDQpBcyBmb3Ig
dGVzdCA1LCBob25lc3QgdGhhdCBpcyBzb21ld2hhdCBpbnZhbGlkIGJlY2F1c2UgaXQgd291bGQg
YmUNCmRlcGVuZGVudCBvbiB0aGUgVk1NIHVzZXIgc3BhY2Ugc2hvd2luZyBCSElfQ1RSTC4NCg0K
UUVNVSBhcyBhbiBleGFtcGxlIGRvZXMgbm90IGRvIHRoYXQsIHNvIGV2ZW4gd2l0aCBsYXRlc3Qg
cWVtdSBhbmQgbGF0ZXN0DQprZXJuZWwsIGd1ZXN0cyB3aWxsIHN0aWxsIHVzZSBCSEIgbG9vcCBl
dmVuIG9uIFNQUisrIHRvZGF5LCBhbmQgdGhleQ0KY291bGQgdXNlIHRoZSBUU1ggbG9vcCB3aXRo
IHRoaXMgcHJvcG9zZWQgY2hhbmdlIGlmIHRoZSBWTU0gZXhwb3NlcyBSVE0NCmZlYXR1cmUuDQoN
CkknbSBoYXBweSB0byBwb3N0IGEgVjIgcGF0Y2ggd2l0aCBteSBUU1ggY2hhbmdlcywgb3IgdGFr
ZSBhbnkgb3RoZXINCnN1Z2dlc3Rpb25zIGhlcmUuIA0KDQpUaGFua3MgYWxsLA0KSm9uDQoNCj4+
IEkgd29uZGVyIGlmIHZpcnR1YWwgU1BFQ19DVFJMIGZlYXR1cmUgaW50cm9kdWNlZCBpbiBiZWxv
dyBzZXJpZXMgY2FuDQo+PiBwcm92aWRlIHNwZWVkdXAsIGFzIGl0IGNhbiByZXBsYWNlIHRoZSBN
U1IgdG9nZ2xpbmcgd2l0aCBmYXN0ZXIgVk1DUw0KPj4gb3BlcmF0aW9uczoNCj4gDQo+ICJ2aXJ0
dWFsIFNQRUNfQ1RSTCIgd29uJ3QgcHJvdmlkZSBzcGVlZHVwLiB0aGUgd3Jtc3Igb24gZW50cnkv
ZXhpdCBpcyBzdGlsbA0KPiBuZWVkIGlmIGd1ZXN0J3MgKGVmZmVjdGl2ZSkgdmFsdWUgYW5kIGhv
c3QncyB2YWx1ZSBhcmUgZGlmZmVyZW50Lg0KPiANCj4gInZpcnR1YWwgU1BFQ19DVFJMIiBqdXN0
IHByZXZlbnRzIGd1ZXN0cyBmcm9tIHRvZ2dsaW5nIHNvbWUgYml0cy4gSXQgZG9lc24ndA0KPiBz
d2l0Y2ggdGhlIE1TUiBiZXR3ZWVuIGd1ZXN0IHZhbHVlIGFuZCBob3N0IHZhbHVlIG9uIGVudHJ5
L2V4aXQuIHNvLCBLVk0gaGFzDQo+IHRvIGRvIHRoZSBzd2l0Y2hpbmcgd2l0aCB3cm1zci9yZG1z
ciBpbnN0cnVjdGlvbnMuIEEgbmV3IGZlYXR1cmUsICJsb2FkDQo+IElBMzJfU1BFQ19DVFJMIiBW
TVggY29udHJvbCAocmVmZXIgdG8gQ2hhcHRlciAxNSBpbiBJU0Ugc3BlY1sqXSksIGNhbiBoZWxw
IGJ1dA0KPiBpdCBpc24ndCBzdXBwb3J0ZWQgb24gU1BSLg0KPiANCj4gWypdOiBodHRwczovL3Vy
bGRlZmVuc2UucHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2NkcmR2Mi5pbnRlbC5j
b21fdjFfZGxfZ2V0Q29udGVudF82NzEzNjgmZD1Ed0lEYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0
R2NnJnI9TkdQUkdHbzM3bVFpU1hnSEttNXJDUSZtPWM3U0ZqY3p5WGVPNU1jRTRmaXJVWmFpT1Z1
TEJWd0xYQXpLVjlXUXFNcUtDQ0V3U3ZWazBWNGNrby1mYWxRWW8mcz0taHNrcmxoclI0aXVUMnN6
MEtrR0puN2hDU0FHSXRldTNfVEdRelBnaDhJJmU9IA0KPiANCj4+IA0KPj4gaHR0cHM6Ly91cmxk
ZWZlbnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19sb3JlLmtlcm5lbC5vcmdf
a3ZtXzIwMjQwNDEwMTQzNDQ2Ljc5NzI2Mi0yRDEtMkRjaGFvLmdhby00MGludGVsLmNvbV8mZD1E
d0lEYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9TkdQUkdHbzM3bVFpU1hnSEttNXJDUSZt
PWM3U0ZqY3p5WGVPNU1jRTRmaXJVWmFpT1Z1TEJWd0xYQXpLVjlXUXFNcUtDQ0V3U3ZWazBWNGNr
by1mYWxRWW8mcz1yc2FFZEFOOUtFanRBTVNOLWtlNHg0Ujg3RmdmeHN2Q3Nkd2JDRms3Vk9FJmU9
IA0KPj4gDQo+PiBBZGRpbmcgQ2hhbyBmb3IgdGhlaXIgb3Bpbmlvbi4NCg0K

