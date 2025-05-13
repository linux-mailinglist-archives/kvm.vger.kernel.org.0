Return-Path: <kvm+bounces-46280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22017AB492F
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 653067B0B96
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D508192D8A;
	Tue, 13 May 2025 02:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LMMtNfD5";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Q364DLfW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FEE19CC11;
	Tue, 13 May 2025 02:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747101880; cv=fail; b=D4zeRizlCfo+KOH9OiuDnWQUt9VpcylHrzf1K+6eSU9r2FuprfJoUmOiJf5qXtKNfp7WsqjCNwVp1bWTdrFiMew+wLlsGwMaMBATFjpn4mjNPXASt2MNqYRdKuEzqkPEXTjT/lSM5vt23rS/BIqOGJQ7VgyWCOrHOCa32tiPvAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747101880; c=relaxed/simple;
	bh=KdLNBOoR5rU5V3IITweaVq+InJUtrR6GEp0I84DKQ/c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EXDo/DlX59jkFyry2Nf74rbqkJFsJLQdZw69I5GiZD/nE5QmBmrzb5anE1LpXqXgze9F5+IawMVDKZ2fLAUv3dkNZ+v3hZvpvOcwBiU9EkjUI/Bkik3+H4pBQtddNvHc14nFCNUIcRv+ZEOCgYLZQh54wYwRfi1mGDx6mN2oDqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LMMtNfD5; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Q364DLfW; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CJZQ90029144;
	Mon, 12 May 2025 19:04:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=KdLNBOoR5rU5V3IITweaVq+InJUtrR6GEp0I84DKQ
	/c=; b=LMMtNfD5NKAwWykOaED6XIb1HA9gTl4TPM11imbJGo1bZS1un/QeFPLq0
	iXIidCQkt755AbB+WcUG5VmCePbmPXznoZUGFdAHwP04sHpg3AKShJDyKcCIsWN2
	de7+oQFleRskOzzHKFNQ49qflBn+Y89KzvpALA7TDQFMqU0cZcoxWtCFd0HjbdOm
	wUgb2HAfIH1A3CTsGmuASAS5v0SAEqsqY9mK5Hv6U3ahu4BN/UYmbzkzcH9qRHX3
	uCvyycp+W3iZimqszzMuxU15D9hUnCeMb4gvTsZnckqryI7NXs7UQAzhSLFawPYj
	9CoZzx+z+F5F3OetdDeNOL32aocyQ==
Received: from sj2pr03cu002.outbound.protection.outlook.com (mail-westusazlp17013078.outbound.protection.outlook.com [40.93.1.78])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j6b04keg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WlTLPGuweNOAkil4j+fGkbA3GXrOijlYPqdEhRV4t7rZn4JcjF0rOtgTn11yUcG+QpDZFe+IYhi7xFBaXnpvj1o74O7W9k0SCj3R0aBM+4fbPvAd71AeZCOgpOfEhaOMmMFJd5dib7gdnzsy8LSHhL+oKPK7hvS6a6PSatB0LUminFRstlQrcloBc2oj2SXzSfnHZ4HQdhouh2nGI4V99pPshFCxuJ5ePBFfLdKNB1qoBb4kYh5F2WVpH5CTTDWlvVqqniRwiKJDhiY4utAUWwY37N/VWPUh4ZOnxEwvpv6lcc2apJcb+TyudQYmN0l08DbTQe+SLqjvMcuApn0Quw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KdLNBOoR5rU5V3IITweaVq+InJUtrR6GEp0I84DKQ/c=;
 b=qwAXM4nX93/+BvCfJj2hXIOO0/vuUj3urW7ncfoofJSNVSh3/tMKJV65pwTjdfswMXQrtjg3trOhu+QQQPdFIwE7JATQcJwQJNCJY8r77LTj5OfaFdQxeY1uzZa2MLPM8HcDhR1bJJU5V8Dsdi5XthHAiHXJIsR7GTxNmRIi2jFHgVF5We89i9oLViY6BOvj3rX+WTC91HE7OoBZYt3/gg1dO+8FEVRV7GOvRGYhvdyF93TiMIjYDdYfMNdPo6uCDeLJncOH1/2VtoJs41KhIs/KvoBL+53i8FLqeuOBBr3R01ulgOW192xtBZXD8cg8zt0HKoK5Sagaws4jrRPj9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KdLNBOoR5rU5V3IITweaVq+InJUtrR6GEp0I84DKQ/c=;
 b=Q364DLfWZ6s4GGakv47T1B/UEZs+jVhEcL4nEOFaWJ0ZdPSgNVKHPYH6CPHgOrXHbFdtwoUgNwoqOn7lXcmS8r2V5ZQxskxyApfbDtR1i2Z8N4JpPpR/x+mG6OvSBTBWwqBE3rPkomJLHSvugUF63t3ww39vvpjrkRpAnSDqtmQdoF0EDer9w3Hg/6fbcKtAv/58NZEI1GvkdYkSni3wUAniE0inSU07qW1rzIxbHtmy9qXUMsAzACOT55RLVn6VifxxegYOPzNGkK4J54ROMetJ+dN8kwQUi656X3+IBr0YQ4Gsx1c0nFYIPwT6HlNkYDt7Pcn8LUXh0KAswpMZNg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA0PR02MB9662.namprd02.prod.outlook.com
 (2603:10b6:208:48c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Tue, 13 May
 2025 02:04:13 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:04:13 +0000
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
	<linux-kernel@vger.kernel.org>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand
 MBEC
Thread-Topic: [RFC PATCH 15/18] KVM: x86/mmu: Extend make_spte to understand
 MBEC
Thread-Index: AQHblFP84BlVF0wWWUSY/v0FR0BUXrPP4TcAgABMuQA=
Date: Tue, 13 May 2025 02:04:13 +0000
Message-ID: <9F6D5641-E2DC-47EF-BAFC-E0FF20D1FC08@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-16-jon@nutanix.com> <aCJoNvABQugU2rdZ@google.com>
In-Reply-To: <aCJoNvABQugU2rdZ@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA0PR02MB9662:EE_
x-ms-office365-filtering-correlation-id: b80f85b3-ea8b-4b95-88b4-08dd91c27516
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|7416014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VTc3cnIrd3lRN0VsMlZaTWhBTEdqUDNpS2xIc3VBakk2dFZqZ08xMWg0eXBG?=
 =?utf-8?B?K2NFRU91UWdycnVUQ3FlbDVpR04wMmtrSVM5bGdLZisvei8xYkFiaHpaNEVv?=
 =?utf-8?B?V3BqOEhJZUtaRWJzMVNPWWtDcy9iK24xRERTT2F6THZOSFVSREVDZE5rajRa?=
 =?utf-8?B?aHc3dHFrNjNWNExMaWZjcWpZeDNDbVNwdUtUdWhSQ1Fob0NFTmZoV1pqM3Vq?=
 =?utf-8?B?aUlLQXltZkNENHNoY0tsT3dIMGczQ3F6MU53MktDTWF3VjBrWnAxNENIUTU3?=
 =?utf-8?B?bHJ3MTJBM0p4dkJwajc2NmVseU45OGx5U3QyOVFkNDVtenlHM3lVT3ZWb3No?=
 =?utf-8?B?ZndkVXAraGhhU0xMdjNjd3BicEVobE9LMktudnJSMVdMbStuNzl4S2tSblor?=
 =?utf-8?B?RU02NkdvZXNvQUhIaEFXZUdvL3poNkhPQk9SellucUNsbFRaRGNobUYxZFBo?=
 =?utf-8?B?UWNoU1FnbVZNWjFpOVEvRFdhSjl3Z2pDa0FiRElLYXpZRnF4eExJanFZRTdC?=
 =?utf-8?B?V09jcVM2cEs5Z1YvQWtvQ2RiUG9JODVLcU1wWDRJTEdSN25iYVZvY0p4WXpI?=
 =?utf-8?B?UzUxSXQ5UHZxWGwyaEVWczFIS0NYSHBudDBxRlJFRkZxNTdpeGJJTFIxazZY?=
 =?utf-8?B?R25Wb04xTWErTlduVTlqdnVYVi9tbmtlcVVIaUM4MWhWeWswdWJ4QkFkZ3dF?=
 =?utf-8?B?NnRPNkVBN3JrQmhNWmNzaURjbGY3MzIyN25NMk5MTyt0UjVGZE00RGltdzFT?=
 =?utf-8?B?N25vN3VkRk9pa1hhRitBTzBjWk5IbWlkWkNyVTdtdzlHcXRtcGkxYUlsa3Bk?=
 =?utf-8?B?bGxKYkNjQ0RnRzdQNisvM1Qrbmk2Mk5rVUVlSVpRaXRvVHNPdStlaWk3eXBk?=
 =?utf-8?B?Vk9pYkg4bWUraGZiYXpWUW43dnRuWDEzcHdnTFJUbWJ5c2V0d0kzT2loY1Qz?=
 =?utf-8?B?UU1VdzlLOVJLT1czV2poQUJwQW9nZFRkamJrRGNMMFh6UzlDMzdBYXFCV1VO?=
 =?utf-8?B?c2dJcWFqTE9JYzdUK05JY0N5eVBkMlFKYXczNnVLV0g4cDVZd1JIaWVaYjZp?=
 =?utf-8?B?aHRoTWQzeDRiMEwyUndaVnJCOFExT3h5c24zNlRzTlpGblBnY1RWckdDZk1Q?=
 =?utf-8?B?WW4vazFoZ1M1VGNiK09rSHBJaFN3TGRkNEFMVTBXRGIydHJTWFV5VWRDbk4v?=
 =?utf-8?B?U3BHTGR1eWRBaCtscEhOSWc0aUhhdWVXZkhNcU5SencwMTRxcW9COXZYRnpO?=
 =?utf-8?B?TllPc1NPNjgxSzU1TlpnMEw2VXJMWTB1bzBHNDNVckVJbjhZRnBsNEd2eDFB?=
 =?utf-8?B?YkV2dmN5MW9KUTc4T3FpVlhIMmRRbHJsaEVVdGRZNFlqcVVhUVlhWTJ4dmNT?=
 =?utf-8?B?ck5rR0pmOXJJcWpYZFdyUCtGVStZWVVjVk05TjE4T1gvQUpYK1g2TS95cGZm?=
 =?utf-8?B?ZFFGTFBvWUZyL25TOFFiUTdaNUZGMWovd2NOVmVVM3lzVnhwK2hlcTZvM0Vh?=
 =?utf-8?B?dzlMZnhjSi91eWFvdUFDbGN6NGNWNG5uS3ZQTzNsWW5XWkJwWGlRMFdGYnpQ?=
 =?utf-8?B?WWkwY2NUcHJXQkR3eFlSYWYzWm1ZWjEwNHhYRVJUUDBMdFZHWmJTZzRFUk9U?=
 =?utf-8?B?cCsyVFhMVmNVVURhdUtadXJhNTRDT290OFdiVXZyRkUycHhCaUxRR3lLUTc4?=
 =?utf-8?B?bk1DU2dtTkJ4Vm1yVXQ2RmQ2czR2dU52ejhsWi9Xd2hjQWdVNExHbEFyellL?=
 =?utf-8?B?cGM0SU5GZFNlL2VHcE8yUWxRaERNU3NrTEpNYitYYlBJYUhKNWFveWNjdDFj?=
 =?utf-8?B?ajdzcG0zYVZCNE5FUmtnNEltTWlLOHpzQUlSNXBIWjhGWnBwZUdGSjNEVzZy?=
 =?utf-8?B?cVRnb0NNMU9SQlNuSngxcm9YdlZubWJkc0hHUjloWmtFRDNGQ3MvMzRnSWpR?=
 =?utf-8?B?YktGV2xqeGx5eWZJeE9RSmI1em9qOHZEYjg2Mktya0oramE0S1hybGZ4aExl?=
 =?utf-8?Q?D+Fi7zBvyc6VWI3sU75jCFP3ZrmWAI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bnRGdzB1b1RHL1VRQVhkMFJQN055d1d6RVlHQW9hVzhZcVBIMElDUUkvQmJL?=
 =?utf-8?B?TTV0UE5iK0s4RmNaWlBSWGlya1VCYWdhclhLdTBCMGRSSEpXN2VMZzFxVTEy?=
 =?utf-8?B?b3ZHRmFvSVdjS253UUJJUzUxYWFJam1MdnkyUlRkeUJhREMvNlozYktTMjVU?=
 =?utf-8?B?SW85WDZmS0xINXgrZ3pVRXdLeW9kTDhlY0Y2WTkzVmFCWXJGQjdnenNLWVNv?=
 =?utf-8?B?cXJodzlFeGt3SXg1L1k2ZGRTeVUvNUFBaTBJL25GWXpXMXc1eFR6N0xoYS82?=
 =?utf-8?B?Q3d0Z2pGdjRsVm92OTdOcm05YkFkRTZmUjg2eW14ZEZ0SXZLWmUxZGJVNzVG?=
 =?utf-8?B?VnByL25MdE9jaVRhdGpVVmx0VVEwdlZ1c0FPUXI0UnJIeEV6N0ZuaDdnSHJI?=
 =?utf-8?B?WWVxaTBGcklxU2l2Z0VWRTZQd0N6aGN2OGFaR2VSS0xJeE1TU2lJMnVOK2xI?=
 =?utf-8?B?N3pDVmVnWDVpbk5YbHM3bHZySFNSWjk4ejdqWDM0ZGh1ZWpVMHhZL0lOMUVx?=
 =?utf-8?B?WGoyaXpYU2NrVDNMZDFRZ2pHQktMbVVEQldQdHBTK09CTGw1SEVHU3FRWk1I?=
 =?utf-8?B?bDhCT2Q5WWJWOHRJanJXK0ovOVdnUFJTbXJWbVFqSHlIeGNXWHk1MnJTZ0lT?=
 =?utf-8?B?WXFPRDVSdFpnR3ZHRGJPOEQxdEg5SDdYd3lLb0VUNXMvd1dWUjhRQVZXQTE4?=
 =?utf-8?B?V0d3dmlWQmlCU2xycFZZUTdUSGVMa3R0YjRGNm1SdlBHaXF1Y2hORUlqaFBK?=
 =?utf-8?B?RkJ3d0phZDhaVUNhQ0FEem9EUGpkLzRHSWs5VTBvSklJSHZmSmVTa3hDOTc5?=
 =?utf-8?B?aVdjRGZuUXcrWjFlVVcwL2pQUmV2djdoem5QS2J6ZklwdksvR25aT2h5dHBu?=
 =?utf-8?B?ZlRRdklpU1lkUkJzV21abGFCZHd6VWVsUzJlNjFwQkFWN3dvUFdsSm53dkZs?=
 =?utf-8?B?NHorbGpvVXk1RHdtanhCT2tGVzdCYzU0K2p2cnFPRGNLLy9WdzFwL2srV3p5?=
 =?utf-8?B?Q2x2MEJnMXpsWGVWMEN4STNNVFNuUHM5T3c0bVZTTnRXTlh4bFhVc3RIdUtN?=
 =?utf-8?B?S3lhLy9VTWtxVVJrU3hleXhxWnRlbXRiQlNOZnk0SlR3YWhFUGhpM1RXRjE5?=
 =?utf-8?B?bDV1cUZNekVna3pxc3hyUTZqUkZSb0dFYTdxeXZYUVB6cFZIL0xyQk03UFZR?=
 =?utf-8?B?L0s1MkUrUDF1SlIwaE5yVlR3NStHd3dHU0d0UXovamdHcFZRVkNva3Z2TGJj?=
 =?utf-8?B?c2xGUGZIcDRqcWxaR3BRVGNRb1ArV1pxcTMrdks5ZWsxNW1ZL0Q2WnFKVXJh?=
 =?utf-8?B?aG1kbTVQb09DeFhPZUwzQnIwd2RmeDJyWjI3SmZOQ0J3cEdEUVRFQUtFQkdt?=
 =?utf-8?B?eHQwMyttcTU3SE5SalR2UmMwZmZtRFBZVU8vZjVsVTdxNHJYQnh4T20wM1dJ?=
 =?utf-8?B?dmt5cURnSVQ3ZGpEd2MvUE92MXJZTGhHbjhQQjJrd1lSNk5wWVc0TUg2NzV3?=
 =?utf-8?B?eHFzUmxLYmpqVCt4SVNJd1Y4NkkxYWFTZVpEdUpmejRjNW9tcnNKU0lTdGo4?=
 =?utf-8?B?U1pnam0yMGlQMlJQSzJLYzZnMTQ1aTJXbjVmUVBaNFJhY1hIeEpNeWl2RlVS?=
 =?utf-8?B?RUdLZWpvQmg0aWZGSnlNV1YxMGlNbmtUR3dLVGtNTEt2QUp3dHZTWW1EbVE5?=
 =?utf-8?B?UnROYzhJOUdFN0poblduZEJOY3ExSjlER0lrVStOSzNoWFF0bmRoR0ZVekJD?=
 =?utf-8?B?QXJSSU5COUQ5c3hya2RQbDVUZk8vamp3bU95eEFlbnczVDUvcExNRnZtc2gy?=
 =?utf-8?B?V2tGcGh2Ymh1dmpqL0d2MWs4VE9peU1TYXd3WjM1clhrUE9ROE1TbFBMSnNV?=
 =?utf-8?B?SS9IcWUzNzBydHFYNk56U1ZuMmRZYWRtVUtxRXdMczFQM3hGTWNzNkIrQUQy?=
 =?utf-8?B?a0xYN1RlRjJXWVBsTHFRTVVrWFJVeVRDN1NKdGFPRDVZVmczcDFtMFVZUytP?=
 =?utf-8?B?WUlETEFkUFROazQraG1FYjhHeUEvOXl3Wmg1QzBDQkRjWWQyaktjUDQ1bEFy?=
 =?utf-8?B?KzN2QjFPQTZSQzE3US9nSDhQRmt5UGxCanRGQkx6MnhsOEJqTlZUS1RPUGZl?=
 =?utf-8?B?Zi8yUTZpaVRINTZPQlVsUGdZbmoxR2s3T0l1QkRBZWlLc016WHpCYlZRUE1M?=
 =?utf-8?B?bERSaDkrdGl5d3pBLzJlMDAxR2VLZmR1WUJIWndLM0oxMkY2UkpxSUNoV0VJ?=
 =?utf-8?B?Q04reUFaM3MyakxpYUVKaE1rc1BBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BFD197C78DA25E4CADEE33B557EFCCE2@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b80f85b3-ea8b-4b95-88b4-08dd91c27516
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:04:13.0549
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: okmWR2T5no05Fpc9obxXigrmGd81w5vMsPgFlFrCYj6Li+Lb6M4i1WH8wfF2jhB3vT1keBaQFQXOwuLNKdcUcD+rflOZIOWzbSePygF5dFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9662
X-Proofpoint-GUID: LA-Iq1iWaNJJmkuASr9rVrES0AGIwu7e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxNyBTYWx0ZWRfXxiQ+qalIcvZR vyMkb4VBC3isyKaVjjyCQWn51mh98qx//AsckrZKgVxS578nzxZ2/vPxZJfDEv6tIIDDuLPnMS9 Ib51UudMzza5NUYlnZxwVX2x+fRs08TsjqN1kpq2DAgTGtyZefR7VF1tPY1FiwFZS1EYj/1FjUr
 /a5S3qlkkzLiGlhuHkaySmR2q87CmRMApvPTSSFXjS5ega3YtGO1XdJf2yc3Zc9bakXgyId3JYs rGKAT9soNla/RnKhrwKswp3/qMHz+NqZ1FuN28feYitO8DzcUoEIQSqptDSz/Erm2Ih0GqHLPMx xsArb1HOUf8VTqKpbr+gOeVx2dseps90qUGv5D6e5RwXayULRXUD4X1s4+ThhgjdN9x/ZqNH5s+
 IbUqPoOETPvq6+hyLrT6kkQomctPVCX5x5pj42OYkMC7TkGb7NLivT/mdMKBR6lbPftb8JdN
X-Authority-Analysis: v=2.4 cv=FZs3xI+6 c=1 sm=1 tr=0 ts=6822a89f cx=c_pps a=l9cCpZ6fIogKje1+qubiRw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=RTXGalF2iBwoXAbM_BQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LA-Iq1iWaNJJmkuASr9rVrES0AGIwu7e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjI54oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBFeHRlbmQgbWFrZV9zcHRlIHRvIG1hc2sg
aW4gYW5kIG91dCBiaXRzIGRlcGVuZGluZyBvbiBNQkVDIGVuYWJsZW1lbnQuDQo+IA0KPiBTYW1l
IGNvbXBsYWludHMgYWJvdXQgdGhlIHNob3J0bG9nIGFuZCBjaGFuZ2Vsb2cgbm90IHNheWluZyBh
bnl0aGluZyB1c2VmdWwuDQoNCmFjaw0KDQo+IA0KPj4gDQo+PiBOb3RlOiBGb3IgdGhlIFJGQy92
MSBzZXJpZXMsIEkndmUgYWRkZWQgc2V2ZXJhbCAnRm9yIFJldmlldycgaXRlbXMgdGhhdA0KPj4g
bWF5IHJlcXVpcmUgYSBiaXQgZGVlcGVyIGluc3BlY3Rpb24sIGFzIHdlbGwgYXMgc29tZSBsb25n
IHdpbmRlZA0KPj4gY29tbWVudHMvYW5ub3RhdGlvbnMuIFRoZXNlIHdpbGwgYmUgY2xlYW5lZCB1
cCBmb3IgdGhlIG5leHQgaXRlcmF0aW9uDQo+PiBvZiB0aGUgc2VyaWVzIGFmdGVyIGluaXRpYWwg
cmV2aWV3Lg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29obGVyIDxqb25AbnV0YW5peC5j
b20+DQo+PiBDby1kZXZlbG9wZWQtYnk6IFNlcmdleSBEeWFzbGkgPHNlcmdleS5keWFzbGlAbnV0
YW5peC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTZXJnZXkgRHlhc2xpIDxzZXJnZXkuZHlhc2xp
QG51dGFuaXguY29tPg0KPj4gDQo+PiAtLS0NCj4+IGFyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3Rt
cGwuaCB8ICAzICsrKw0KPj4gYXJjaC94ODYva3ZtL21tdS9zcHRlLmMgICAgICAgIHwgMzAgKysr
KysrKysrKysrKysrKysrKysrKysrKystLS0tDQo+PiAyIGZpbGVzIGNoYW5nZWQsIDI5IGluc2Vy
dGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9r
dm0vbW11L3BhZ2luZ190bXBsLmggYi9hcmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190bXBsLmgNCj4+
IGluZGV4IGEzYTVjYWNkYTYxNC4uNzY3NTIzOWYyZGQxIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94
ODYva3ZtL21tdS9wYWdpbmdfdG1wbC5oDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3BhZ2lu
Z190bXBsLmgNCj4+IEBAIC04NDAsNiArODQwLDkgQEAgc3RhdGljIGludCBGTkFNRShwYWdlX2Zh
dWx0KShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAqZmF1bHQN
Cj4+ICAqIHRoZW4gd2Ugc2hvdWxkIHByZXZlbnQgdGhlIGtlcm5lbCBmcm9tIGV4ZWN1dGluZyBp
dA0KPj4gICogaWYgU01FUCBpcyBlbmFibGVkLg0KPj4gICovDQo+PiArIC8vIEZPUiBSRVZJRVc6
DQo+PiArIC8vIEFDQ19VU0VSX0VYRUNfTUFTSyBzZWVtcyBub3QgbmVjZXNzYXJ5IHRvIGFkZCBo
ZXJlIHNpbmNlDQo+PiArIC8vIFNNRVAgaXMgZm9yIGtlcm5lbC1vbmx5Lg0KPj4gaWYgKGlzX2Ny
NF9zbWVwKHZjcHUtPmFyY2gubW11KSkNCj4+IHdhbGtlci5wdGVfYWNjZXNzICY9IH5BQ0NfRVhF
Q19NQVNLOw0KPiANCj4gSSB3b3VsZCBzdHJhaWdodCB1cCBXQVJOLCBiZWNhdXNlIGl0IHNob3Vs
ZCBiZSBpbXBvc3NpYmxlIHRvIHJlYWNoIHRoaXMgY29kZSB3aXRoDQo+IEFDQ19VU0VSX0VYRUNf
TUFTSyBzZXQuICBJbiBmYWN0LCB0aGlzIGVudGlyZSBibG9iIG9mIGNvZGUgc2hvdWxkIGJlICNp
ZmRlZidkDQo+IG91dCBmb3IgUFRUWVBFX0VQVC4gIEFGQUlDVCwgdGhlIG9ubHkgcmVhc29uIGl0
IGRvZXNuJ3QgYnJlYWsgbkVQVCBpcyBiZWNhdXNlDQo+IGl0cyBpbXBvc3NpYmxlIHRvIGhhdmUg
YSBXUklURSBFUFQgdmlvbGF0aW9uIHdpdGhvdXQgUkVBRCAoYS5rLmEuIFVTRVIpIGJlaW5nDQo+
IHNldC4NCg0KV291bGQgeW91IGxpa2UgbWUgdG8gc2VuZCBhIHNlcGFyYXRlIHBhdGNoIG91dCBm
b3IgdGhhdCB0byBjbGVhbiB1cCBhcw0KSSBnbz8gT3IgbWFrZSBzdWNoIGlmZGVm4oCZZXJ5IGFz
IHBhcnQgb2YgdGhpcyBzZXJpZXM/DQoNCj4gDQo+PiB9DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL21tdS9zcHRlLmMgYi9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuYw0KPj4gaW5kZXggNmY0
OTk0YjNlNmQwLi44OWJkYWUzZjlhZGEgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11
L3NwdGUuYw0KPj4gKysrIGIvYXJjaC94ODYva3ZtL21tdS9zcHRlLmMNCj4+IEBAIC0xNzgsNiAr
MTc4LDkgQEAgYm9vbCBtYWtlX3NwdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3Zt
X21tdV9wYWdlICpzcCwNCj4+IGVsc2UgaWYgKGt2bV9tbXVfcGFnZV9hZF9uZWVkX3dyaXRlX3By
b3RlY3Qoc3ApKQ0KPj4gc3B0ZSB8PSBTUFRFX1REUF9BRF9XUlBST1RfT05MWTsNCj4+IA0KPj4g
KyAvLyBGb3IgTEtNTCBSZXZpZXc6DQo+PiArIC8vIEluIE1CRUMgY2FzZSwgeW91IGNhbiBoYXZl
IGV4ZWMgb25seSBhbmQgYWxzbyBiaXQgMTANCj4+ICsgLy8gc2V0IGZvciB1c2VyIGV4ZWMgb25s
eS4gRG8gd2UgbmVlZCB0byBjYXRlciBmb3IgdGhhdCBoZXJlPw0KPj4gc3B0ZSB8PSBzaGFkb3df
cHJlc2VudF9tYXNrOw0KPj4gaWYgKCFwcmVmZXRjaCkNCj4+IHNwdGUgfD0gc3B0ZV9zaGFkb3df
YWNjZXNzZWRfbWFzayhzcHRlKTsNCj4+IEBAIC0xOTcsMTIgKzIwMCwzMSBAQCBib29sIG1ha2Vf
c3B0ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwLA0KPj4g
aWYgKGxldmVsID4gUEdfTEVWRUxfNEsgJiYgKHB0ZV9hY2Nlc3MgJiBBQ0NfRVhFQ19NQVNLKSAm
Jg0KPiANCj4gTmVlZHMgdG8gY2hlY2sgQUNDX1VTRVJfRVhFQ19NQVNLLg0KPiANCj4+ICAgICBp
c19ueF9odWdlX3BhZ2VfZW5hYmxlZCh2Y3B1LT5rdm0pKSB7DQo+PiBwdGVfYWNjZXNzICY9IH5B
Q0NfRVhFQ19NQVNLOw0KPj4gKyBpZiAodmNwdS0+YXJjaC5wdF9ndWVzdF9leGVjX2NvbnRyb2wp
DQo+PiArIHB0ZV9hY2Nlc3MgJj0gfkFDQ19VU0VSX0VYRUNfTUFTSzsNCj4+IH0NCj4+IA0KPj4g
LSBpZiAocHRlX2FjY2VzcyAmIEFDQ19FWEVDX01BU0spDQo+PiAtIHNwdGUgfD0gc2hhZG93X3hf
bWFzazsNCj4+IC0gZWxzZQ0KPj4gLSBzcHRlIHw9IHNoYWRvd19ueF9tYXNrOw0KPj4gKyAvLyBG
b3IgTEtNTCBSZXZpZXc6DQo+PiArIC8vIFdlIGNvdWxkIHByb2JhYmx5IG9wdGltaXplIHRoZSBs
b2dpYyBoZXJlLCBidXQgdHlwaW5nIGl0IG91dA0KPj4gKyAvLyBsb25nIGhhbmQgZm9yIG5vdyB0
byBtYWtlIGl0IGNsZWFyIGhvdyB3ZSdyZSBjaGFuZ2luZyB0aGUgY29udHJvbA0KPj4gKyAvLyBm
bG93IHRvIHN1cHBvcnQgTUJFQy4NCj4gDQo+IEkgYXBwcmVjaWF0ZSB0aGUgZWZmb3J0LCBidXQg
dGhpcyBkaWQgZmFyIG1vcmUgaGFybSB0aGFuIGdvb2QuICBSZXZpZXdpbmcgY29kZQ0KPiB0aGF0
IGhhcyB6ZXJvIGNoYW5jZSBvZiBiZWluZyB0aGUgZW5kIHByb2R1Y3QgaXMgYSB3YXN0ZSBvZiB0
aW1lLiAgQW5kIHVubGVzcyBJJ20NCj4gb3Zlcmxvb2tpbmcgYSBzdWJ0bGV0eSwgeW91J3JlIG1h
a2luZyB0aGlzIHdheSBoYXJkZXIgdGhhbiBpdCBuZWVkcyB0byBiZToNCj4gDQo+IGlmIChwdGVf
YWNjZXNzICYgKEFDQ19FWEVDX01BU0sgfCBBQ0NfVVNFUl9FWEVDX01BU0spKSB7DQo+IGlmIChw
dGVfYWNjZXNzICYgQUNDX0VYRUNfTUFTSykNCj4gc3B0ZSB8PSBzaGFkb3dfeF9tYXNrOw0KPiAN
Cj4gaWYgKHB0ZV9hY2Nlc3MgJiBBQ0NfVVNFUl9FWEVDX01BU0spDQo+IHNwdGUgfD0gc2hhZG93
X3V4X21hc2s7DQo+IH0gZWxzZSB7DQo+IHNwdGUgfD0gc2hhZG93X254X21hc2s7DQo+IH0NCg0K
QWNrLCBteSBhcG9sb2dpZXMsIHdhc27igJl0IHRyeWluZyB0byBtYWtlIHRoaW5ncyBoYXJkZXIs
IGJ1dCBJIGFwcHJlY2lhdGUgdGhlDQpjYW5kaWQgZmVlZGJhY2suIFRoYW5rcyBmb3IgdGhlIHN1
Z2dlc3RlZCBjb2RlLCBJ4oCZbGwgaW5jb3Jwb3JhdGUgdGhhdCBvbiB0aGUgbmV4dA0KZ28uIA0K
DQo+IA0KPiBLVk0gbmVlZHMgdG8gZW5zdXJlIEFDQ19VU0VSX0VYRUNfTUFTSyBpc24ndCBzcHVy
aW91c2x5IHNldCwgYnV0IEtWTSBzaG91bGQgYmUNCj4gZG9pbmcgdGhhdCBhbnl3YXlzLg0KPiAN
Cj4+ICsgaWYgKCF2Y3B1LT5hcmNoLnB0X2d1ZXN0X2V4ZWNfY29udHJvbCkgeyAvLyBub24tbWJl
YyBsb2dpYw0KPj4gKyBpZiAocHRlX2FjY2VzcyAmIEFDQ19FWEVDX01BU0spDQo+PiArIHNwdGUg
fD0gc2hhZG93X3hfbWFzazsNCj4+ICsgZWxzZQ0KPj4gKyBzcHRlIHw9IHNoYWRvd19ueF9tYXNr
Ow0KPj4gKyB9IGVsc2UgeyAvLyBtYmVjIGxvZ2ljDQo+PiArIGlmIChwdGVfYWNjZXNzICYgQUND
X0VYRUNfTUFTSykgeyAvKiBtYmVjOiBrZXJuZWwgZXhlYyAqLw0KPj4gKyBpZiAocHRlX2FjY2Vz
cyAmIEFDQ19VU0VSX0VYRUNfTUFTSykNCj4+ICsgc3B0ZSB8PSBzaGFkb3dfeF9tYXNrIHwgc2hh
ZG93X3V4X21hc2s7IC8vIEtNWCA9IDEsIFVNWCA9IDENCj4+ICsgZWxzZQ0KPj4gKyBzcHRlIHw9
IHNoYWRvd194X21hc2s7ICAvLyBLTVggPSAxLCBVTVggPSAwDQo+PiArIH0gZWxzZSBpZiAocHRl
X2FjY2VzcyAmIEFDQ19VU0VSX0VYRUNfTUFTSykgeyAvKiBtYmVjOiB1c2VyIGV4ZWMsIG5vIGtl
cm5lbCBleGVjICovDQo+PiArIHNwdGUgfD0gc2hhZG93X3V4X21hc2s7IC8vIEtNWCA9IDAsIFVN
WCA9IDENCj4+ICsgfSBlbHNlIHsgLyogbWJlYzogbnggKi8NCj4+ICsgc3B0ZSB8PSBzaGFkb3df
bnhfbWFzazsgLy8gS01YID0gMCwgVU1YID0gMA0KPj4gKyB9DQo+PiArIH0NCj4+IA0KPj4gaWYg
KHB0ZV9hY2Nlc3MgJiBBQ0NfVVNFUl9NQVNLKQ0KPj4gc3B0ZSB8PSBzaGFkb3dfdXNlcl9tYXNr
Ow0KPj4gLS0gDQo+PiAyLjQzLjANCg0KDQo=

