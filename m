Return-Path: <kvm+bounces-65813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 763CCCB8396
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 09:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F213304D9DE
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 08:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FDF530DEDD;
	Fri, 12 Dec 2025 08:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tmYiCgsu";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aralI9ic"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAA2253F39;
	Fri, 12 Dec 2025 08:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765527443; cv=fail; b=O9otwwlSm7ogs2SEgDFmgGzKzeZTkHvpNjovJzY6uUhw7ni744nTEdWPBUZRlPoAq3tL27Eq7nu7onnCg0J4lbf4dqC0m69GS9+f4kDeqfDWeoEHnv2fBACIw4BxIkBfCUwDlJErs15yFERhRsQjohFZ1RA3JezqlIrycQqPR74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765527443; c=relaxed/simple;
	bh=+8mYtlA0PuB9vaUYcuh0AWryogP3Zj3OhI03w9MLlbs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c9e1uZYJEAw72uELyPa4wMnlpuJfDfskDRwcYVTyRzUN/wnaDcZRl3da/CS+LdLG7YpjwgP/y7gvMjwveLXC2ERiwUU5SFqWfFYZklu/kFCs6EYJuFS1hNdVpn5G6Z6kxEKa1DHVyMyaCyS2Bml2y3l5845sM0xbddXNO/p5OxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tmYiCgsu; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aralI9ic; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC08ATA3387389;
	Fri, 12 Dec 2025 00:16:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+8mYtlA0PuB9vaUYcuh0AWryogP3Zj3OhI03w9MLl
	bs=; b=tmYiCgsuz50HKDxDpNCLkSk62/yDS3Wd/PKzlwdeUGZMoBlc8BNBRbgq3
	VbAQuc9LQs5Vt/dtQCVIzavWapBdV+nY4MUB/ie9lZ8cxHYYEpIGQ4YkuUeg9jN1
	H+zhZc5hDvMszhxmVvIiaLyYrtVWRBVpQwph0IFzLu+ekgX3gBB6oXVUTRcXPHXo
	+oQjYsqBvjPN96/PfepxAM5DvwZwTbrG1rOqECJHlhbkhnFeiGOwyEIvwAVPVfLv
	Bcb+5HHROBLhBt+iE8hfscfmKRRk/dT8UE2Sq9vAPZxt/6mR8rk7hoo75sKoDBYg
	W9FyPgdiY4v99rM6haP6jCEVFqwkQ==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023109.outbound.protection.outlook.com [40.107.201.109])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b087rrrak-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Dec 2025 00:16:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mJwavh2vK8VkQLOHuCf4NWmW6QRiaA33VC8Wkkjeaw9r5GcwKosLYuuQCZkXrUbKPqi8YtNDDETP3y2oKL4LY0/D05annzQjpcUubB25vajuS6Wc5hHxJmJIWQRkFRdYvy8lk9lganh4KZ8T58SUkUngatUxIKi0N943OTF1PHtYGe0yXy2kyAXYQ3c97Q7dD+2hiJ43w9hnS8cduAwiO7kcLX79ChpkMyW80njLj8mWDhcMhW4YS/dEA03QcoEd1GC3qENGt407K6ZieEa0ZoZ4JmgYncGSLpQVeu6riO8zsyRRRA2dLkihcC03yXl8p4CuZRUsZIlcnNqHm1AkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8mYtlA0PuB9vaUYcuh0AWryogP3Zj3OhI03w9MLlbs=;
 b=wIO8hl72J7ymvA59H58rtWOdCDhMpRviiFxXALCqKUgkeLUmrN9za8KJgN5c7PQJmlxGJrbFAhMHwGSPzTTtmALaIx8VpGLkGONzoiDOCmU+GV0V/urgLoBrxx4YdpTz5ztX+HwN+oKLzSIouNqjYAH2vBvQ3bzIdDUNwzpn+o3NBsv5Bbon45NUTiF0m5WRtzqLmK7g4yTXfkc3qPG0hF9xei4U6eLa3yPN8R73xVyythIaESxlscTDItx+8d2LpYLSNY2vAuCHSL7uGIj4c6jSJz1r0cdMN7OgwX7x7ysM186p29+ORFnGokA39eZmP0O4/KO3fx0lJ0UvzouykQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8mYtlA0PuB9vaUYcuh0AWryogP3Zj3OhI03w9MLlbs=;
 b=aralI9icLTfwAsexgGQsvxbNBJTdvOx2mcCMfCFb7Ye1PRwiqS9XP9D9+lpoHlq0l46HyMC0DMaE52dMrTCdwFCtzUo2CloYIB2USnw1WEf6tKTHJYvI2uie0Hg3qvmHthYisVSNtfrabW4H7oRW+1TYz9yq3KumZW6ghQAHfBNCBw42qZ3iJ8gVDuOwieaUEAKyF3GRtFXgG+kFaaPBDXZzgfuawtNqm5tOM3CaYp2o1pAIoZ3eEtdpCfr+Rg/cYJvnYkLPEr9wJxGJc8e0uQxNe7nLV1MqOn+7LPYizvLfyNJiPjwQNH35C/4481b0UNjhkWuEVINlParH8b19IA==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by SJ0PR02MB8419.namprd02.prod.outlook.com (2603:10b6:a03:3f3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 08:16:53 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 08:16:53 +0000
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
Thread-Index: AQHcao1m0m+Je6bySUSdnhU8EZf0EbUdH8CAgAB3S4CAAAaPgIAADJeA
Date: Fri, 12 Dec 2025 08:16:53 +0000
Message-ID: <C343BC29-647C-4F60-82DB-2A21B8B21EC2@nutanix.com>
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
 <83cf40c6168c97670193340b00d0fe71a35a6c1b.camel@infradead.org>
 <B45DB519-3B04-46F7-894E-42A44DF2FC8E@nutanix.com>
 <e0378e55610bf5431e78a090501948a8c12c73cb.camel@infradead.org>
In-Reply-To: <e0378e55610bf5431e78a090501948a8c12c73cb.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|SJ0PR02MB8419:EE_
x-ms-office365-filtering-correlation-id: e7e8a664-df30-4e9c-11ca-08de3956cf06
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WFBHaE80SzYzaFJzczY3R01XNGtBb2JrR0RxODF2dEJQWmFWVmFOSWFVWWk4?=
 =?utf-8?B?ak43bndRbDMvZmlyUVIrZlBSdFg2SmdHQ0lsV1FUUXZDelNsU0MzNStpYnF3?=
 =?utf-8?B?QUJGa1pwdi90Z2RvWHRyQStja1JuVC8xRlhhRUxkUVAyRXlMZHV4VkFMdGNZ?=
 =?utf-8?B?QlppOXBEbS9oT0lEVTE0dTJOSG5VSWQzV2JNaTMySFBTTEsxM2RHdHZncDlu?=
 =?utf-8?B?bWRZL1hEWGxUNkJWUjZuWWoxUW1TK01ObEljU0NGd2locUYweGI1b1ZiRGYx?=
 =?utf-8?B?clRlUnlaWS81aUxaSVQ5TWZhSW5VelBsYXF0WWF4Q2tJVGJKQlZIN3VmekVx?=
 =?utf-8?B?WU9JWitMZW1xdlQvUGMxMEQzNk9sMHB2SVRoeHZCeXdTcEhiVUJDcTZLNHBP?=
 =?utf-8?B?ZnlRSGtOeVdpZExKdlB0QVJPT0xJSmUvRHdIRUVUZHJjeXliVEtpS1I1bldp?=
 =?utf-8?B?dUx4SHY2R2dmUkxmS1N0QUlwbURaWFgrZHdPT1JtR29tbjAycjhnbEw2NktY?=
 =?utf-8?B?L2FSTC9JMDY2c3VEMXpHT3RqUkJyM2VaVUo1NEhRNFRVWEpBaEJSajdGV1Vr?=
 =?utf-8?B?QUFUWUlhdVJ4UnZ0Mk5JSEgzVEpVbjJ4RTRucTBudktjdGh4SFB5LzN1Tnc1?=
 =?utf-8?B?MjYzQklQVEltMUFmd1hHUVhlcGFhTU51dGJ1SC9FTGZvcFJmQ2l1UHdTWkV6?=
 =?utf-8?B?NTFUZ0xwcXRubk1wYi90ZGtENXptMkJ6WldqMmc0KzJ5VjNhTjdGTXFDMWJn?=
 =?utf-8?B?aTBNcFZhWmJLb01oR21JUTRrUmdQNmF1RVF4ZXlQb0Y1T2I5QUtHcDA3WDVy?=
 =?utf-8?B?aGZoTUNBcFQvZDNvckFKMyt0OWVzT1RsbzRndWp0SHQwUWZlTmVWcEt4Umxs?=
 =?utf-8?B?d1hkaTBXL0tLWE1FVzdtZmxpWkhpYUxMWmowTUNOWmsyRG0yMUd3SnZ5cjhC?=
 =?utf-8?B?M2o0U3RBenhlSi82ZlpZTGxKcE9xSVBFYUpYcWhLVkpjaDlmaStWQ3lzZlJ4?=
 =?utf-8?B?RTUybHpCSkNUNWR1alNPY3BVT2hYa1FmbUpqVmdRamlSNVdMcmZsMGV5TVBL?=
 =?utf-8?B?VmtLRVc5NG40VEdFRHFiOTlSTXpKNTgyNkhoY0w5R3BuUDNFWEtvMnVZY3dF?=
 =?utf-8?B?MTVFbmVlSHpqU1RoOVliMUMrODd0NU9lMnRKU2YyQ3k2ZWtpN0ZFeXJMNGVF?=
 =?utf-8?B?cHlHR3BmTTFySDdRd1dRWkNUdk0vUnhpQkhsZWV2Y3JwbzVFcVdvVnlxY2p6?=
 =?utf-8?B?UVRCL0hNQWVMcnJwYlZtZmxTY2VEcUFEY3I4WUVOMEE2N2FiN29vTjZyWmR5?=
 =?utf-8?B?N0tHTi9Dck5vQ3M2RG1CbjdvbEFUbXh4MzA4WDQ3VVRjN0ZzdWJVUmxHVnBs?=
 =?utf-8?B?Ui9rY3R6K251ZUMwNG5uMUNudmtDWnYwS3AyMmI1ZnZxN0xRcytKRjdnSERT?=
 =?utf-8?B?d0ZITW03Q1hiME9MWUp3VmhucjRTUERudHdKbytIUnlLZ2tNaTIwbEdUV1ZC?=
 =?utf-8?B?VHJGalRxaFNxaGR6U1RIbDZnN0ZPWXFDUS84RGxMbVVtRWhXRHZaVUFWaGFS?=
 =?utf-8?B?dlRZeU13L1prZW5NUjRrV0gwbE5GdStOR2g2MGdQUkFPR0VhYitjNTN0WnFn?=
 =?utf-8?B?YVJYT0dKSzhXaHhoaFhZSmZDZmdiaUpud21PVjh0WnFKU1FJOUV3bzZNTStX?=
 =?utf-8?B?SU1mZGZFYmFhS1pWYTNBRlhjWEZDWDJUM1FnditkSmVFVWJHYTJNcmNHRGUr?=
 =?utf-8?B?UG92YXVibVhvZUMzaXgrdDZtODA1K0c0NGRwT1EzR1d1bEN1djB4TStJbFVJ?=
 =?utf-8?B?YmcxREFqeERVN0hnQWpXOERuWU9sU1B3YUVrRVptZlF0Q1g0T2lGWjQ4aU9J?=
 =?utf-8?B?ZGYrOTVRQy8xb0c2ZnU2ZHRMQUxHZnlLRDFhL0Jia09mc1FsYzc3eXdRbHhr?=
 =?utf-8?B?QWRPbVFMbmVaa0E4TXFHNHVXU2lxenZZd0NlSXp3OXFOQmF6MjIrZ0ZrdFJR?=
 =?utf-8?B?ZTQ5UlJlV0R0NWplNHZCQVZuaDRCd29GRWprclUwOGtQTjJveStYbXVxdWhu?=
 =?utf-8?Q?wuK/Pr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eWZJZGNNN2lENDZ4UmdCY1VFSGNRUk9HbWluMERKVU10WnlnYWl2MStvSGRt?=
 =?utf-8?B?bWcrTE9OSHpZcHJFQlhKNmdNUENHb3dQUGhpRjRUVGkreFQ4T0xaTXpPeGFR?=
 =?utf-8?B?OXMvMFJYUEFzYVhDRkc3d2h4TEtFanVjTmRlamw5Nkt1eVNlQlVzNEdsRW1M?=
 =?utf-8?B?T1dHNWVFR3FYQUg5RngvWFZWTXhBMXU3UjRVU2VCREJueTk4OUREN0YzbVp5?=
 =?utf-8?B?anIrN3JiSUZHMjNrVXRUTkpuYWxnMzU2UDUwZ0pOdXp5OUFBdlVTT09TMExR?=
 =?utf-8?B?UW5LcVM4N2RlUCtSOW1mODE0aUswcUtWdWxiN0VEN05VdHBiSStXc3FVSFJV?=
 =?utf-8?B?SjR0dTBuVmRKUXF0Y1NPYTM0ZWdYYlhQS0wzbitTK3Avc1UvM0VCNWpzZUtj?=
 =?utf-8?B?bFNTMXd5RjNjVXgwMXlZdFJCdUNPbDBJdTBqUkhuL2NBdXFPZXZBb2pFbjRo?=
 =?utf-8?B?MVhGODRKTi94OFB2dGxPUFFUeVVVZzZuNWJ5eko5MGY1RnRMRDAyMTZIcnor?=
 =?utf-8?B?UVRvSUNJTlBEVUZYRFpwc1NELzc5OTFDemx4OTZQTnFBRmhkb3NEdktxTEs1?=
 =?utf-8?B?YVBTT29GL0w2azRYSW5YTytEdE5Qd1ZDSWZoVVJpWWhNYlRqVzg5N2pHWnRj?=
 =?utf-8?B?aG9xMzhJUHk4Zi9hVzBDU1lWaXI2MG45NXJPTEV0NXZzcVJPQm5neW51VHhP?=
 =?utf-8?B?MXFmWHJmbVdTcTdHbVYraExMb0dFVlRVSWtQa2tSK3Zaamk4aHdvQlJsK3VN?=
 =?utf-8?B?MHl5M0RVM2hTSW11bS9ockIwam5sOFIvRWFuS1lER0gzbSt5UXNnbFhKSVNT?=
 =?utf-8?B?L1hYVGhpSjB5b1dFcUFPMjZEem1yMnRxOS9JSGhRK2FLeVcyQVhzWkpxVTZt?=
 =?utf-8?B?b3BNeFd5VHgzVmhMclNuRHBjYitqQkdYVXlNRFUzSW95SGtoaHVhK2IxUTRX?=
 =?utf-8?B?a2pmWmN0Qk5RdVMxUkV5ZnVzZE05V3ZOd0VDZWtmYzh5Zmxad1JqdnlJYWQz?=
 =?utf-8?B?OHljZksyRjZTdVYwZjRnSzhXQkM1MUd3NGJCWnFBenUyZ1pja2tMSnBxeE5v?=
 =?utf-8?B?cDNISi80QjY1NEd1M3VtK2czWXdPZzBlK2RSb045NGVLZ0MrSjY1Y0ZCQjhz?=
 =?utf-8?B?OGlCS2xWMStlNE5RWkQ3Y2wwTG9ESVRFNGhmMG9vYUVPVFd3UzFPSkNzNnUx?=
 =?utf-8?B?YVVCSi9qQlczMURnTXlnRXcramhmZ3NpK3U2ZWkwYituWEJnb0FxdUgwaHNI?=
 =?utf-8?B?eWdVM3I0Zy9sdSthaUN4TDVPVDhzNWtzUTExOTZJdVZHQjFFNG5vaDZKMktE?=
 =?utf-8?B?U3hLVTdQMVBoSE4yUHQ1Z20rZnV5WlVZbVlnUHFPWGRVd080NGoveG5RU2U5?=
 =?utf-8?B?Z0I3cnJzVGsrU09Rb0l0ekgyMjZBOE9STm0xZzMvTGY0NHk5ZnQyZHFEVDlD?=
 =?utf-8?B?UDFhTldTZlRIVVZhY1Qxc05LYlJ6VHE5NHVUbHV0UVBXMzJtZGt2NkFlcFBm?=
 =?utf-8?B?NlB6VVhjVmFZMXovNG10M3BPVzEyZWUybXlXdWtDaGlZblZmTTdZZnRwVzlk?=
 =?utf-8?B?SmtkMk1ZbGJmWlJFcmwyamhTMkRtM0RCOUo3cCtKTkJlNkNXOWVzODZLTlpO?=
 =?utf-8?B?QVRGZmpBM0NlbHVENVM5S0w3cUpvSU0xWHVHMlpqMEQrRFJnaExDNXEzZ3I2?=
 =?utf-8?B?TjZrdWZxK25lTEVBYjg0MnFnUUlwWmcybkQ0eDVGVFQ3YzdzVDdPUzlROGFT?=
 =?utf-8?B?ZHdqeDd1a0pvdzdpN2EvZ00rb1NrY3ZkVUY4UGp0M2pTMTdWMkU5TXU3aVll?=
 =?utf-8?B?NmRhRXFqcjMza2s3Y0krazc0RkRPcEF4dnhSdFZQS2VpRkFaVG8rUG5iZTdX?=
 =?utf-8?B?MlpJTWVTQjBjck9EUDU3dXREeE1sZHl1SjJsVzJWWENwNVF2YVV1QWUzL3FG?=
 =?utf-8?B?VnpySUk2ZUVoQWdici9zQzlpZXJxSFVQNlVDVmF0WUl0OUU5cExaeWg1dEdn?=
 =?utf-8?B?MU1HcEFtZWJkYTh2MDdIQlE2aGJSTHQ5V0ZoV1l5Q05xenk0b2h0NFAyN0ZT?=
 =?utf-8?B?YzJFZWV0VnZGMFNXNWdvWjducFRRdjgwaHZwZzBUN0dYV3M0K3ZuVk41eW1O?=
 =?utf-8?B?UERhbmIvSUNWVUlKMllSNnVtU0wrZjVoQ08vS1dRSlBVRXl5SXM4WlRaZTl3?=
 =?utf-8?B?Nm1tSHVGcVgxb3ZMellSMjUrcklhUzQ2L3BIUFdOT0tqR3ZiamorbTBtUi81?=
 =?utf-8?B?elZjR21XSEgrWWhma05uTVNVQm93PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <198507A9770BEC41976AFDF60AE5B31A@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e8a664-df30-4e9c-11ca-08de3956cf06
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 08:16:53.5989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pisuZjWZGEseBWdviXo64DHw/GFEBxzHqn02c2vzfCGwLj6mjNLIW/UzzlwUOexuzMG7FmCHkignHtB3ouFdw8ctgnHsIpOaZ++715ES1Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB8419
X-Proofpoint-ORIG-GUID: YncF5056X-kjmIbS4kTTPmcS76Hghzpq
X-Proofpoint-GUID: YncF5056X-kjmIbS4kTTPmcS76Hghzpq
X-Authority-Analysis: v=2.4 cv=WMRyn3sR c=1 sm=1 tr=0 ts=693bcf77 cx=c_pps
 a=79HFkgKL4DfSaZBTv+UA5w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=81NYpxkajzgLfl-sC4cA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA2MCBTYWx0ZWRfXw2aMZSdCuIPn
 NfbW38YfeGZF2l1P3C+L3jgXDQVt0cP/uglnDqa5dUPKln/dzYf/9l6gevXarvo/XkGGS5vVIB8
 +1uDeZSBF7v0lg6VeCqlRh9kfgLEklOZw41mpR54NeIJoBrkxZhsEEKnhPMoEFPqjZr68ZNZbp2
 6jgHsUUUnOLUq9AMSq62eefguqeTSXIx0AaMqpIEAnzGRs4AszPKkVTp9lWZOLE4bCQGA73sS0t
 mTiWL4ICVYNSCb0GgsPLN4WQpkbYavXKPKz8PMdgzHClOwwsvgyo9MOsuY6Rylv/2qv5O5EbVqM
 T7HqBXK69JwBmZ4tIxzgj6jsxCE2cp8wnt4kwwCd7EOGimufOz8DfZN29uDB2DeccxMQTYjqTGv
 JSdc8PSUTo3EsEGJQicPI0/0H0xd6w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_01,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTIgRGVjIDIwMjUsIGF0IDE6MDHigK9QTSwgRGF2aWQgV29vZGhvdXNlIDxkd213
MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IFN1cmVseSB0aGUgcG9pbnQgb2YgaGVscGVy
IGZ1bmN0aW9ucyBpcyB0aGF0IHRoZXkgbGl2ZSBpbiBhIGhlYWRlciBmaWxlDQo+IHNvbWV3aGVy
ZSBhbmQgYXJlIG5vdCAqZHVwbGljYXRlZCogaW4gdGhlIGRpZmZlcmVudCBDIGZpbGVzIHRoYXQg
dXNlDQo+IHRoZW0/DQo+IA0KPj4gQEAgLTEwNSw2ICsxMDUsNDMgQEAgYm9vbCBrdm1fYXBpY19w
ZW5kaW5nX2VvaShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCB2ZWN0b3IpDQo+PiAgICAgICAg
ICAgICAgICAgYXBpY190ZXN0X3ZlY3Rvcih2ZWN0b3IsIGFwaWMtPnJlZ3MgKyBBUElDX0lSUik7
DQo+PiAgfQ0KPj4gIA0KPj4gK3N0YXRpYyBib29sIGt2bV9sYXBpY19hZHZlcnRpc2Vfc3VwcHJl
c3NfZW9pX2Jyb2FkY2FzdChzdHJ1Y3Qga3ZtICprdm0pDQo+PiArew0KPj4gKyAgICAgICAvKg0K
Pj4gKyAgICAgICAgKiBSZXR1cm5zIHRydWUgaWYgS1ZNIHNob3VsZCBhZHZlcnRpc2UgU3VwcHJl
c3MgRU9JIGJyb2FkY2FzdCBzdXBwb3J0DQo+PiArICAgICAgICAqIHRvIHRoZSBndWVzdC4NCj4+
ICsgICAgICAgICoNCj4+ICsgICAgICAgICogSW4gc3BsaXQgSVJRQ0hJUCBtb2RlOiBhZHZlcnRp
c2UgdW5sZXNzIHRoZSBWTU0gZXhwbGljaXRseSBkaXNhYmxlZA0KPj4gKyAgICAgICAgKiBpdC4g
VGhpcyBwcmVzZXJ2ZXMgbGVnYWN5IHF1aXJreSBiZWhhdmlvciB3aGVyZSBLVk0gYWR2ZXJ0aXNl
ZCB0aGUNCj4+ICsgICAgICAgICogY2FwYWJpbGl0eSBldmVuIHRob3VnaCBpdCBkaWQgbm90IGFj
dHVhbGx5IHN1cHByZXNzIEVPSXMuDQo+PiArICAgICAgICAqDQo+PiArICAgICAgICAqIEluIGtl
cm5lbCBJUlFDSElQIG1vZGU6IG9ubHkgYWR2ZXJ0aXNlIGlmIHRoZSBWTU0gZXhwbGljaXRseQ0K
Pj4gKyAgICAgICAgKiBlbmFibGVkIGl0IChhbmQgdXNlIHRoZSBJT0FQSUMgdmVyc2lvbiAweDIw
KS4NCj4+ICsgICAgICAgICovDQo+PiArICAgICAgICBpZiAoaXJxY2hpcF9zcGxpdChrdm0pKSB7
DQo+PiArICAgICAgICAgICAgICAgcmV0dXJuIGt2bS0+YXJjaC5zdXBwcmVzc19lb2lfYnJvYWRj
YXN0X21vZGUgIT0NCj4+ICsgICAgICAgICAgICAgICAgICAgICAgIEtWTV9TVVBQUkVTU19FT0lf
QlJPQURDQVNUX0RJU0FCTEVEOw0KPj4gKyAgICAgICB9IGVsc2Ugew0KPj4gKyAgICAgICAgICAg
ICAgIHJldHVybiBrdm0tPmFyY2guc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdF9tb2RlID09DQo+PiAr
ICAgICAgICAgICAgICAgICAgICAgICBLVk1fU1VQUFJFU1NfRU9JX0JST0FEQ0FTVF9FTkFCTEVE
Ow0KPj4gKyAgICAgICB9DQo+IA0KPiBJY2ssIHRoYXQgbWFrZXMgbXkgYnJhaW4gaHVydCwgYW5k
IG9iZnVzY2F0ZXMgdGhlIG5pY2UgY2xlYW4gc2ltcGxlDQo+IEVOQUJMRUQvRElTQUJMRUQgY2Fz
ZXMuIEhvdyBhYm91dDoNCj4gDQo+ICAgc3dpdGNoKGt2bS0+YXJjaC5zdXBwcmVzc19lb2lfYnJv
YWRjYXN0X21vZGUpIHsNCj4gICAgICBjYXNlIEtWTV9TVVBQUkVTU19FT0lfQlJPQURDQVNUX0VO
QUJMRUQ6IHJldHVybiB0cnVlOw0KPiAgICAgIGNhc2UgS1ZNX1NVUFBSRVNTX0VPSV9CUk9BRENB
U1RfRElTQUJMRUQ6IHJldHVybiBmYWxzZTsNCj4gICAgICBkZWZhdWx0OiByZXR1cm4gIWlvYXBp
Y19pbl9rZXJuZWwoa3ZtKTsNCj4gICB9DQoNClRoYW5rcywgdGhlIHN3aXRjaCBsb2dpYyBpcyBp
bmRlZWQgc2ltcGxlci4gDQoNCj4gT24gMTIgRGVjIDIwMjUsIGF0IDE6MDHigK9QTSwgRGF2aWQg
V29vZGhvdXNlIDxkd213MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+PiArfQ0KPj4gKw0K
Pj4gK3N0YXRpYyBib29sIGt2bV9sYXBpY19pZ25vcmVfc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdChz
dHJ1Y3Qga3ZtICprdm0pDQo+PiArew0KPj4gKyAgICAgICAvKg0KPj4gKyAgICAgICAgKiBSZXR1
cm5zIHRydWUgaWYgS1ZNIHNob3VsZCBpZ25vcmUgdGhlIHN1cHByZXNzIEVPSSBicm9hZGNhc3Qg
Yml0IHNldCBieQ0KPj4gKyAgICAgICAgKiB0aGUgZ3Vlc3QgYW5kIGJyb2FkY2FzdCBFT0lzIGFu
eXdheS4NCj4+ICsgICAgICAgICoNCj4+ICsgICAgICAgICogT25seSByZXR1cm5zIGZhbHNlIHdo
ZW4gdGhlIFZNTSBleHBsaWNpdGx5IGVuYWJsZWQgU3VwcHJlc3MgRU9JDQo+PiArICAgICAgICAq
IGJyb2FkY2FzdC4gSWYgZGlzYWJsZWQgYnkgVk1NLCB0aGUgYml0IHNob3VsZCBiZSBpZ25vcmVk
IGFzIGl0IGlzIG5vdA0KPj4gKyAgICAgICAgKiBzdXBwb3J0ZWQuIExlZ2FjeSBiZWhhdmlvciB3
YXMgdG8gaWdub3JlIHRoZSBiaXQgYW5kIGJyb2FkY2FzdCBFT0lzDQo+PiArICAgICAgICAqIGFu
eXdheS4NCj4+ICsgICAgICAgICovDQo+PiArICAgICAgIHJldHVybiBrdm0tPmFyY2guc3VwcHJl
c3NfZW9pX2Jyb2FkY2FzdF9tb2RlICE9DQo+PiArICAgICAgICAgICAgICAgICAgICAgICBLVk1f
U1VQUFJFU1NfRU9JX0JST0FEQ0FTVF9FTkFCTEVEOw0KPj4gK30NCj4gDQo+IFN0aWxsIGtpbmQg
b2YgaGF0ZSB0aGUgaW52ZXJzZSBsb2dpYyBhbmQgdGhlIGNvbmp1bmN0aW9uIG9mICdpZ25vcmUN
Cj4gc3VwcHJlc3MnIHdoaWNoIGlzIGhhcmQgdG8gcGFyc2UgYXMgYSBkb3VibGUtbmVnYXRpdmUu
IFdoYXQgd2FzIHdyb25nDQo+IHdpdGggYSAna3ZtX2xhcGljX2ltcGxlbWVudF9zdXBwcmVzc19l
b2lfYnJvYWRjYXN0KCkgd2hpY2ggcmV0dXJucyB0cnVlDQo+IGlmIHN1cHByZXNzX2VvaV9icm9h
ZGNhc3RfbW9kZSA9PSBLVk1fU1VQUFJFU1NfRU9JX0JST0FEQ0FTVF9FTkFCTEVEPw0KDQoNCkkg
dGhvdWdodCB0aGUgZWFybGllciBkaXNjdXNzaW9uIHByZWZlcnJlZCBrdm1fbGFwaWNfaWdub3Jl
X3N1cHByZXNzX2VvaV9icm9hZGNhc3QoKSwgYnV0DQpJ4oCZbSBub3QgdGllZCB0byBpdC4NCg0K

