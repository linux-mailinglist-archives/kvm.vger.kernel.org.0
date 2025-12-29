Return-Path: <kvm+bounces-66777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C5CCE72FF
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 16:18:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FEBD301EF80
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 15:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D47132ABC5;
	Mon, 29 Dec 2025 15:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ym2Diiz0";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vRsVgsAK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFC031ED83;
	Mon, 29 Dec 2025 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767021435; cv=fail; b=pIhFya1TD5z9iKwKyjRXyeqTz6WRoGqHiaBQgXAjk1M4niDZo2v0vp9ZhL/pkdkWgsdpPnWCzme4YqGS1PBTvgTL23xM63gtkZYWF5ymj45OAdvphwM1BAzK1cryACQ4U8oqg4ZJHyha0rkhK8hzlp+0kCe9ytx1HnXc3OfnVEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767021435; c=relaxed/simple;
	bh=lRoXafV80ccEoMetlYIIOfCQ12Xy2sN7Vt7LIwthfQc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=V07gtYWJhQlBl/KyOqegRZ7uF2T16NSCsZjWpfmN6/UIzdmIeQy5B4M0alq6ztWvn92eoecTLu5DZTtCzGoBHzRxKN7Gboujo2b7ybhwqxS95oUWAwH5gBpsxA+k0wLr6sSab8CTU2PwwZ4CtCQtU/BIj1T1p1nQYLsrc1ZoZKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ym2Diiz0; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vRsVgsAK; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BTBfLXd370179;
	Mon, 29 Dec 2025 07:16:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=lRoXafV80ccEoMetlYIIOfCQ12Xy2sN7Vt7LIwthf
	Qc=; b=ym2Diiz0GR3v1XARpGyC6+uGW14rV7Xj3RH2tT/RxO8xV00iCtRbL3tg8
	YyFZDraHTcJYMbM3RIZS2Ggy8xsuZP4qbaS7b8ZtFqX4OSU9YD8dwH3ROIJD9Gfq
	xzaGYui9vvrNviDa9AsVoe35DOrNrjxlKECLaGsZ7O4pF8QcJV/JRM23q9UHf5sm
	BhzaIXYr3wkbVfsMi7CeofYa596iaXfxpVl7YLZ0fXWWNmEDwVzzx5NSkguuQsZL
	ij2Uj8i/Nadbc/qdecl75EuAwXBlxdUJ8twPLzxEC0TuJoHn/0IjdENMve4RyP5v
	Kc4roqkZ9lyrL3jScxwkpxTn7HCTw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020081.outbound.protection.outlook.com [52.101.46.81])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4bac87b4ct-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 07:16:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fi2NkH7ewQ1e87CoKyIGNKetQuDCtYZk9TMswJwX3PJTqYB3uQk37GnyCg8ghSDeoNDtTF22Z7ah8g2795dHlCwGY3eqXbpU15pjZdZD8jRE4pBRIB/n7o9Imjf9+LE1lnn/UikDJ9d+TZu+Fgd0TQJlAtnOPhwweMLQokxRe+9YPY7C+sTynOMgLti5IH9uzI3g4pBlFbXskWtCXhmWs0IzIgpgxsvIXVDSyLRMGB3UnvAZpQ0K4dQJnBAtGh/3oq3wBDXQ1iE3dYGnolFovQ6OZahVk8Rz/A0fRWpJI7Vn3BCEl2pEtXxP0rgoK2kXu1umVQ5CgJ5KZ1tTQ5pz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRoXafV80ccEoMetlYIIOfCQ12Xy2sN7Vt7LIwthfQc=;
 b=VH5guRGeu3Gn3FG4hgLH2TMCFAX01KK2OUYWDFklKoarelehyxPnxhzafnI9DKtbRC4ScMbwjZ5wHcM1BI/f+d6qqYeFOAO/0xUWP/lAGopJkrW3lJBZNg4gNnec/O0UWJv5PVRGAfoQTuOj7/TXBRIbnFjj8ohli0seZfVKUamr3UiBrHlSES0WHNSJKHYtvWWCb6GZRSn7K2IKxorYDA3nPE1ylnwUmhS7Zx7FxyMEqjeDPyOJc9CDu98OZ5l9Dxxs+5vjMXXyFw+pEJxA90sYphwFDxqSCYp/Bs1D1vAFlhp4jfBhEo35NRP8ExpWiTR4rIx/RyB38u5fSZ5gPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRoXafV80ccEoMetlYIIOfCQ12Xy2sN7Vt7LIwthfQc=;
 b=vRsVgsAKRMtiZTCkzMNb+Kxg9J+IOFUfXj6eTPb/jfhc8jI7VHVLWbOM4qb401IUMBhlvVb3QbCuRXIqnPvUfilfYQSCRKhLU7GAbw95a2g4giwWwJGoR5fO+Li6ssBe97AVMDvMqdTwtI48CDRK8pxVcroSJuewi/JBp2cSHL3KopUb0NKtwVcEiM/Xoj2JPGonRRdAtCbJHGPbYZVu+upwlUkSVF48vaookrp/ge3su1ny24FyGgmohGzqU7Gz5w86ptHXf/4HAAnvm6rrZHDkepi7AnlZVJ73sReDLBNJT1iaS9/DZ23DZ3/k/6WSv+lqOR/O/VtrJlBQsp2H9g==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by CH3PR02MB9563.namprd02.prod.outlook.com (2603:10b6:610:125::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 15:16:40 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 15:16:40 +0000
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
Subject: Re: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Topic: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
Thread-Index: AQHceLTEKfxcrcgmBUCGXzBVU4MWXbU4fimAgAALkYCAAAtAgIAAJdKA
Date: Mon, 29 Dec 2025 15:16:40 +0000
Message-ID: <BE16B024-0BE6-46B4-A1B4-7B2F00E4107B@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-3-khushit.shah@nutanix.com>
 <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
 <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com>
 <9a04f3dda43aa50e2a160ccfd57d0d4f168b3dce.camel@infradead.org>
In-Reply-To: <9a04f3dda43aa50e2a160ccfd57d0d4f168b3dce.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR02MB7557:EE_|CH3PR02MB9563:EE_
x-ms-office365-filtering-correlation-id: f2db7986-4b1e-4a65-e7d7-08de46ed445a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SnNKeWU2TVlPUTFBeGdwaWs3blFXRllQQi9YeDFBUjRYZEdPV2U4eFA4aFNt?=
 =?utf-8?B?aXNWcFRJUlc5d0tldGJRbXpUV1U5MGlNSnF6cmtTL0RSQXhEdFFqQkQwRkpY?=
 =?utf-8?B?eGkwcUZFYy9BSWdIYWJyZE1WbGdzR1Z0UVZGdlRNTzdwL2hWeE9CTEZzbnBW?=
 =?utf-8?B?Q1F2WFBVeHRKTlNqZjF6WEtad1p4NHZGT3cwcXUvSWdneTg0MkNLVXNYS3Jl?=
 =?utf-8?B?cjZzbktBUVNoRTJTVE5jcWoxS044TFBnSnVkVUkxVC9JTGM5VHprWCtpbjcv?=
 =?utf-8?B?dTE2OGV1aGFPNHJrVk03WUxxNUFMM0R3NjF4YVpqbDNjejBMNjFXL0tLZDBH?=
 =?utf-8?B?a2hKSExpcGFBMnQrNGZmaXRCTWNacVdMVGZEelZ4YlJtVmZxUFBDSVdJc1Bm?=
 =?utf-8?B?ajloYVc0T3cvYnVhNzlHRDN3UzIzUmwrUTFDUFlQVWNjOFlhUjBPTWJNd0lo?=
 =?utf-8?B?UVAvZHRraEZqV0VSN2JiNWJSdlo1WHlCVGdnMFArZGs3T3dneDV5SnBnamRi?=
 =?utf-8?B?Q0NITzNvVFZYMTZXNFZrWGVXWDJvYUtpY2x3WkdDWmc0ZmVBT0xMYkRydjhj?=
 =?utf-8?B?L3dZYkNFN0F1bDI4V0h4VXV0aVRuQXdiUTNtT3EyTkZTeGxYL2poL3RDUS85?=
 =?utf-8?B?Q0xtdDF1bnZVZ0VEakVDN1htRGdJVENlajR2U1Y0bC8vZUxhM0UxeDR3UnFE?=
 =?utf-8?B?YXkrdlNTOWRsWU8zWXJpekZmUnEyTW82ZHR6MjZubkdwY3V1TDZrcU9aMlph?=
 =?utf-8?B?MG8zSjZVLzBsdjV4WVlLMmV3NXVlVEN1TW9FMzZUVWt0dVZ4MzlQUEl6Zm5p?=
 =?utf-8?B?UlNxbGVNUFFwU0d5dUNqaElBNHIrTDNLbEhKY21FMHBDQUtLZENBM1lxZUN5?=
 =?utf-8?B?TFJGNTNmVGtUa0pXRTR1VzBIQXZwZVBFVy9WeGxoVDhtTUFUcndUelc0bmxm?=
 =?utf-8?B?MW8wTTNoNldQYUtUUHRrVWx1T0dHZlZ0emNwZDU4RldiWE5uQkM1b2w3WVVH?=
 =?utf-8?B?SXBYOU00OHdmcnYybU8rMUtjMEFZU0dGcE1IQzBZZDRQcnpxK0pjUTl3TkJ4?=
 =?utf-8?B?QUxqcEhNK2JOSTd6YVQ2VFV1Qitlb05xTmhoTnR6eGtvNDQzU0Nmc1ZpNC9M?=
 =?utf-8?B?ZkZISFRqc1NJUUhkNUlrVFBoVnpKM3p5L09nbnNNc1N4aHpoRGFpdkJ3blNS?=
 =?utf-8?B?QUFsRll0UnhpT2svVjY5WW1Ma253Q1Jld3FtQXlSeC9NdkJmcE0rd2ZDR09J?=
 =?utf-8?B?dTUyZTYwNnBibUVJTkpyc3d1azhhdUluOUZPd0xuV0ZQdGlrYjBCbHJidm9v?=
 =?utf-8?B?SnFNNG9OcUZLOGV0M1IzNGNYWEtPQWREMG1iWlVjSUJFTExEcnpzVFJ1WG43?=
 =?utf-8?B?ZVd1Q0ZuQ29LanVObWc3c0xrTVByMk1FY2gzZmpsME94cXgxNjgxS0lsVHZu?=
 =?utf-8?B?My9NbW5hVEJyYXFxSmNXYWdjUVFYTXE4bWVnWVpJandPa2diSlcvTWQ3YlVN?=
 =?utf-8?B?ZERNcnVNdVFlOUVVYzl4OXd3MzhYV2x1ZnhPZkExOSt2RlFVQXFVTlZkUStl?=
 =?utf-8?B?NDIvcC8wY1NxUVhTODBlWXBxUjhiaHFDYXNpYlQxelZYTVRjc1d3alM4TjU1?=
 =?utf-8?B?S0MxaXhTR3RzQXFQWVFub2VZTlkxU1VTcm96bmdXOVZpeERKK0RXdUxmL0p4?=
 =?utf-8?B?NFRPUzY5SG1taFlWWEdmL0k2c3RtaUJuNjI3OHVVelcwdml2VG1nNkdma2oy?=
 =?utf-8?B?eU9pMEF4WWlKNEErQlROd25jcUE4NGh6RDRuSnNpRU1zdTFYZzVha0x4Yk9q?=
 =?utf-8?B?eGZsOWFZSEhkeERaU01Kc2xLMVNsWms1UzB0cDBDenBLSUdNZWcvSzdKeDNn?=
 =?utf-8?B?czNzQTFTWlFHaVQ4OTFWbC9ZTm1XNmR2UTF2M0I0bmpKaS9KWUFJdmlaeTJ5?=
 =?utf-8?B?bTlyR2xlc2pOek14dVNkRVd6Y2dyWEpXejVKU0lId1BTUlNvT0tWeTl6d3Bw?=
 =?utf-8?B?WDcrWHN0QUovSFFudko3dzJrbHBhdndTamJrMWVMVWNjei9kK0l6SUljUFZS?=
 =?utf-8?Q?Y3yBg7?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c013Tm43c0RqQ2RxQlFhaWpRTGw2NFBKUGtqSTVEWFVNWkt2V1VaaW1wc3dG?=
 =?utf-8?B?bE5qVnNaMmFNb0FQMlFob1k5THpRVlJnbUtpZnBraTJhKzN4TGVIbUlwNzls?=
 =?utf-8?B?cFprQUZ1aUNBNmRnQVZ1NWcralVDS2doMkpZeFBraDQ4TnNUb1ZCS0VLMFpz?=
 =?utf-8?B?enNlcUNtU3FIbU1sK2ZGU0lscmtCYkhKQktyZDJIbzBYclJVUU01b1pHeFh1?=
 =?utf-8?B?SVZiR0twL09Ya1U3OTRCT0VWMkdaL1Z1VEJoVmttSkE2azR4Tk83SHdacXpt?=
 =?utf-8?B?dHI5YzJ6ekNManlUUzYvYVY5WU1WdEJ0TmxVYm9HSlZTUHNyM0pNYTY5UFBK?=
 =?utf-8?B?MVloclUxUFJtcVlleUE3VVZOSTRQeUJRYVNMRDRTMGhFWFBKbUtMS0RGTmVq?=
 =?utf-8?B?TVpRN1Mwcm8yQXpUaW9jQ2tZZVg0TnErelAvb0FDbU9zK1NvdUtoa0FpN2Rh?=
 =?utf-8?B?NDhnL3hzN0dYcnI0bEZhb083TEMwcnpSZ2lhWlIzT3pYL3JrSTJLTithSVpQ?=
 =?utf-8?B?a2VSdU1tUHJ0dXBEK25iR1RoSnZXOWpxK3VzSGdHa3NXdGFLUXlzMzRMK0VF?=
 =?utf-8?B?VXpWU05jNUJXcTc5MXFxVUxWYkE5VUxIWFhyZXh3MDZFRTF1alF4cFh0dXc1?=
 =?utf-8?B?UEJ5QjRqZW1GVjVJMGY3K3BsTWlRa1NhNDVlYkFFZW4vM1VENVhCMUp5MEw4?=
 =?utf-8?B?ejBRVFIvanZvTzk0LzlJOUxRdkhaaTloTjg4NUtvVHRyVUZEN0xtS0UxQ1ZP?=
 =?utf-8?B?eWcrWG8yRXFia1NHdTFmelIwWFN1ZlRwTjBadFU4dXgycDZUbTgxeDB6Wm0z?=
 =?utf-8?B?K0JYMTVwcXBqdy9iSVpHU0hvWFFWdzE2b1lRMXRlVlBjV1g5VDAwVUlRVHUz?=
 =?utf-8?B?Q21ONEVGd21mSThQTWdlbVI5UHVzSEJHV0FjdkdzRHFNc1lSeDNYZERXZkF0?=
 =?utf-8?B?VkQyRFg0anIvSFZHOU00K0QwaDN5d3NyRFU0RHpYQms4TFJ3cmNUN0U0UTZY?=
 =?utf-8?B?Y3BUbjRiM2x4SW5sdEQwdVRpSGVBa2JmdXByN1FwSEhOYkNUU2w1NE1oWWRL?=
 =?utf-8?B?RU56ejBTZ0ZqU1Z1ZllDVlFXZWZ0VDF0M2dDNmY2YVlMajNtUVNxT1VFc2VR?=
 =?utf-8?B?S2pJeElFLzhZcG9IYlFlcVc1VnJnNitRUHpNU1VDM0dzL2R1NGdza1QwNTRx?=
 =?utf-8?B?WFYzeUVGc3ZMQmRlYnRYK1BJWEpUbVZORzdqb2Y0K2ZXalRpU1pWd1lnL1Mr?=
 =?utf-8?B?Uk9QUThtMFBac05wTGFFRklZeFdVR3RuazlMcndDanlTOHBKY3l0VU9GUTFo?=
 =?utf-8?B?R2NGUVVZbEZOdUpHOGduUGdHTGJFbHlFWlBoZG1sZ2VoRlNkcXpKM2U0S0or?=
 =?utf-8?B?M3c2b0F0ODJVUEsyTGtpQVFMNkNTZTQ2WUhoemJIODFiV2xVWTJUZllERDVT?=
 =?utf-8?B?Wm9OditpSDhaRVlKTnJwcCtYWU1URU1LZTVCOWtoZmR1OEQ4Q04wazVQaE94?=
 =?utf-8?B?dGluYy83UWtuOGhzOHA0RngrTStzVzhGK3ZVb0p2MWRlbTBtSGQrL2NSVDU5?=
 =?utf-8?B?dTN6a01wTnk0WW1ZZ1pieGdNcDYxNDlrbGJhL3BWYU9CVmJ4QmEydWRnWk9E?=
 =?utf-8?B?V0xnMGxHUDU5c0x6bThmaTMvS0g0QUIyemYzK3ltUjlwUm9pVmMzenZ0aGVp?=
 =?utf-8?B?S0RZWWYrTklPMkRxYnZ1Wlc2b2pNTFQ2aU5NNDNYQUhuZE95SGx6QXZabGhw?=
 =?utf-8?B?cWZ0c1gwc3NUZXRGQUZMVWljUWVMMWtyVDlLR3VyTWNUQzhrMDc2STIxSWFU?=
 =?utf-8?B?Qng1TDZtZC92MHd6VTI0NmM0eDJKNXRQV0pkQ2pMRENlTXYzWGZ0Y3JpYWtU?=
 =?utf-8?B?Z2dXSVh2VjJ4WGhJWVh4Q1dRaE9lSWhueEdkWkdVaDhzTTFhMzlETHdnaVRI?=
 =?utf-8?B?UE14QkNoSFRRTklrUHd2VUlxeWx2K00wTGlyeDNHNnJwak5iVWIxcE1Sa1Vs?=
 =?utf-8?B?MmxBMXFvb3dLTTRNbml1anJaQmhLN05LTi9saVhxcWhwVVQvQ3o0SGhGSGsr?=
 =?utf-8?B?UWxwS1grUkVhakovSnlWcUFyajRhRk9wSFFROWt6MjBNN1NycUh0elBEdVRx?=
 =?utf-8?B?K1dJY0YwL3duUU90QnB3aWo0OC8wMkVrbGNiaDhGc2J4Ry96TUFMQ3dvcmQy?=
 =?utf-8?B?K3ZTWHZqeHoyYVBiUFdhVFZLSzB3VlVyWG9Rbk04WlZZVDJzV05yd2RxMnFP?=
 =?utf-8?B?cGpzYnZIRlFER0Q0NlJTaUlROVlCd0owcTNwUnVJd3pwZjgyTis4QlQyMDRo?=
 =?utf-8?B?Y1NZRFJtTHUvVTRWYU8yMTFqWUdOaXdsbEprdXZ4WmR1UkpHYUwyb3JqcUhB?=
 =?utf-8?Q?SvGq0o14GpX1NOwE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D23014FC600C3948A3D75235BA035CB0@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f2db7986-4b1e-4a65-e7d7-08de46ed445a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Dec 2025 15:16:40.0446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OpSlGp3iF+5lhybjJ2Kewx+lKrsZg+GmlgGaI3PFq96MKgue3j4DCXQXmU5FjrfeIW8cbx4tgyoGKROaAAo0lybvTNQC+UwO7Du46aAXQr0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9563
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDE0MCBTYWx0ZWRfX7ZIYNGoXVC3N
 P9321PfzYa8ARK5apkTvdBaIovQBqTQ+efjLon1sCH6+FfqT+TZhSpe0R749SaOq5WCBdY7P1b1
 p0g2/zm59RFbpTTttos+sNNZYire/wKHeP1bUR611fjowBo6d8ZrbPB6PM8dF9JKUSrbDnf4tmM
 Q9t9l8Z5pd8VUh6STM1W84kUPf3WasA0zNHeBB9qZFXFF8ENMc6ez5XvilyEracck5lY1nTxir/
 3JvbdWDAyUVXd7UQQtKgibxr+MFUirbN4EdIu5Qij+oyz0FdAEl2TRqeFcjQmNOO81O8QaUP8po
 sm53z4llcU20/myG3aGCH8HIUxWnvWQdiEhIEj56Z2FKBLEMDGkDYbrdHb2fXUY4lqlb9AR7JT8
 gkF/iKEPMCAEAqzWBH/b1kW0TuEjuuanB9Y2/Lg/ChxTL6SI4p6zjT2rZH7X7I2RbMTKBpnIiVa
 ZHZTcFFvO0WAHg0WG5g==
X-Proofpoint-ORIG-GUID: GMgGmYVyeCsmcGepiDWZkZpOekzh0Svr
X-Proofpoint-GUID: GMgGmYVyeCsmcGepiDWZkZpOekzh0Svr
X-Authority-Analysis: v=2.4 cv=L+YQguT8 c=1 sm=1 tr=0 ts=69529b5b cx=c_pps
 a=Sq8Pev+jtt5PqluhJgCvtQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=Gd4Sl0Ab6vcR41TWUzIA:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_04,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMjkgRGVjIDIwMjUsIGF0IDY6MzHigK9QTSwgRGF2aWQgV29vZGhvdXNlIDxkd213
MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IEhtPyBJSVVDIGt2bV9sYXBpY19hZHZlcnRp
c2Vfc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdCgpIGlzIHRydWUgd2hlbmV2ZXINCj4gdXNlcnNwYWNl
ICpoYXNuJ3QqIHNldCBLVk1fWDJBUElDX0RJU0FCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVA0K
PiAoZWl0aGVyIHVzZXJzcGFjZSBoYXMgZXhwbGljaXRseSAqZW5hYmxlZCogaXQgaW5zdGVhZCwg
b3IgdXNlcnNwYWNlIGhhcw0KPiBkb25lIG5laXRoZXIgYW5kIHdlIHNob3VsZCBwcmVzZXJ2ZSB0
aGUgbGVnYWN5IGJlaGF2aW91cikuDQoNClRoZSBsZWdhY3kgYmVoYXZpb3VyIGZvciAia3ZtX2xh
cGljX2FkdmVydGlzZV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0KCkiIGlzOg0KLSB0cnVlIGZvciBz
cGxpdCBJUlFDSElQICh1c2Vyc3BhY2UgSS9PIEFQSUMpDQotIGZhbHNlIGZvciBpbi1rZXJuZWwg
SVJRQ0hJUA0KDQpUaGUgaW4ta2VybmVsIElSUUNISVAgY2FzZSB3YXMgImZpeGVkIiBieSBjb21t
aXQgMGJjYzNmYjk1Yjk3ICgiS1ZNOiBsYXBpYzoNCnN0b3AgYWR2ZXJ0aXNpbmcgRElSRUNURURf
RU9JIHdoZW4gaW4ta2VybmVsIElPQVBJQyBpcyBpbiB1c2UiKSwgd2hpY2ggbWFkZQ0KaXQgcmV0
dXJuIGZhbHNlIHdoZW4gSU9BUElDIGlzIGluLWtlcm5lbC4NCg0KV2l0aCB0aGlzIHNlcmllcywg
aW4gUVVJUktFRCBtb2RlIHRoZSBmdW5jdGlvbiBzdGlsbCByZXR1cm5zICFpb2FwaWNfaW5fa2Vy
bmVsKCksDQpwcmVzZXJ2aW5nIHRoYXQgZXhhY3QgbGVnYWN5IGJlaGF2aW9yLiBUaGUgSS9PIEFQ
SUMgdmVyc2lvbiAweDIwICh3aXRoIEVPSVIpDQppcyBvbmx5IHVzZWQgd2hlbiB1c2Vyc3BhY2Ug
ZXhwbGljaXRseSBzZXRzIHRoZSBFTkFCTEUgZmxhZy4NCg0KVGhlIGNvbW1lbnRzIGluIHBhdGNo
IDEgZXhwbGFpbiB0aGlzIGluIG1vcmUgZGV0YWlsIDsp

