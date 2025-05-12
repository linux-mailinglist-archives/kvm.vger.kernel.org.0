Return-Path: <kvm+bounces-46189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4C1AB3C12
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 17:28:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 761F9189B98A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 15:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D00423C4E2;
	Mon, 12 May 2025 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tC7/alF9";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SbgoN4zm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F481E503C;
	Mon, 12 May 2025 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747063677; cv=fail; b=Cv7am3RW+ydskM3tDzBKzNQhEo4JbUlzusnrzAfmbX0OMrdrKumEQXunPPgzsl/1a0jdT5gbOlBFvy4FFIaIkF9xiYwjUX9yLJ8OuCSuNY7bSaheGogTma9z04LEHAoW/yNUl+tcqyG1jJ6ycXRlGZkTqKqDaqYZcnJTjuaxr1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747063677; c=relaxed/simple;
	bh=ITwSnUvzF/xqOZ4nJXVYtNBgLJmix3MKf8dGzlTFg1o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SfniULcJpVRrf1FWGAi3nDZnl3A5GCnOEE38WW8oCCUKFeGyBtqWdfYEHBC6IG2JT10jDY5nabxHb/6ximwFZ3FHnE9RXs8gj0ZLQM6fGVahN1kUFFR9jU+Tq9BruvJwDWy9DawQ0fITwKmX4ZcdwLJ8bTd5AvkRtqOE/Q99ixE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tC7/alF9; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SbgoN4zm; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CAT4qp008999;
	Mon, 12 May 2025 08:27:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=ITwSnUvzF/xqOZ4nJXVYtNBgLJmix3MKf8dGzlTFg
	1o=; b=tC7/alF9/0A0eiZnSvrOzzYmqdmnoumVkTdWCVLd1oq7Bt+RgYiMvz4rl
	UnSKJXjIiNTP598mX/hxEgRWfyRyraVHErnw987d60yXjUM2Lga0K1uuvFS+Be5T
	Rr/WPcZ7/sdak07xG1NLv0G8gfCSDN8pDSb1Y7z5puFoxylwbvoVVC8PBNf3KbeD
	XcMopNx9DqsIkR75ppDMetHHEpSHTmspR+/QqcdHxOqCIPZ9MUG0U7nAHnDymF/3
	IoxyeTmlxRgtU/MFRJAv4OCg5rC4NdI0R+ja96uNfoR4Ny0Opa2VbbkdR05RymRo
	IcA7+BAqqo23WakbOWZ4gyUY0IYdg==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazlp17011027.outbound.protection.outlook.com [40.93.14.27])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j64c3hq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 08:27:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JkGDX/hkJIYEc2qzDnmUjCX8ob24Q1kogYhiunQ7MrVbbLhpuQZ5mKVfXt07x76hdIa+rWSUrvpDaWCUDg+pF3N7jvoZGyOA6L4yC0mdYp76/XtZQdRmOSPNID86M0eOpb9H/pb+/d1uHx01YcsJBVx7Hj9suPds83jp/a9v+Fcj1ljGn65WWmJjZv49IX95MO3nRIpcGj1g6q36QlZDj1T2mBkrPEzrR0QiMocTdkoXSh8QyMZJIl8P7lhE60s+8dV15RyXqbUXv/CE0ByD4e+G73o9O21oBKWP9B0dAMJshlqc2SUuPR+qQI7x5ArGMxzbRzEO3mjKvnxv2JcpUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITwSnUvzF/xqOZ4nJXVYtNBgLJmix3MKf8dGzlTFg1o=;
 b=rReuSsjQJTlKYkEYIOsPc0IfeyR78bNSHG+exLqzFBZxcl1mCAbMMRuCsb7Fw+6wHrg0AhqwaQDXOm1sMLfeAgF2Ftkm+Pqbhj9DNvjARCS1YLuA/mkaL4mCCdQEYEMiasZ1KoaI9dRiZygSRnksN1AwYmq2Oi/mDOr+LhU19+csAK4bgx/64L+LPBlguwgngyDsBF7a77jeeoSHiQ5tuXyV5kmjKv73lbcEnmoBRs+JwL14VxAU5BWk1ZsR25iqr2rmQPYWMK7EVuITQA1bUaqoOk1wOCriU588Lovi3bfDdurn7D4r99bAKNXyAXIt8nkzLRA3NgEA1qJl939G0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ITwSnUvzF/xqOZ4nJXVYtNBgLJmix3MKf8dGzlTFg1o=;
 b=SbgoN4zmwbWQdxklEKOzpixQ8unlNtz9wF7Ugatl/47j8Pt+kzq6F252cSbSU6WaxVZuG39Nzaxyu1IoKSJOdEJxLRzEgcj6d35CDUrZd9KAkI/0ROhiKC1GRXXk3JzD3j9QxwEldd0RYBvFQBc6utbJrIvHHVqVgBJqWdob+4agJOdwSTpMfGnse31UJranuEhdWWCng2NyD96Itmt1auUYpsVwBu+P0L3lvPd1rovoIDhWwPkJER3pD20fZWtYCrvdOXzU2CTgM0R7en/SE/0TwTz7sEnzjgYb/13CeF4ImM7wi2atEDr7RbhbIUbqC3qq/TXzdGRuDz+EXSq/yw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA0PR02MB9583.namprd02.prod.outlook.com
 (2603:10b6:208:409::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Mon, 12 May
 2025 15:26:58 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 15:26:58 +0000
From: Jon Kohler <jon@nutanix.com>
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
CC: Alexander Grest <Alexander.Grest@microsoft.com>,
        Nicolas Saenz Julienne
	<nsaenz@amazon.es>,
        "Madhavan T . Venkataraman"
	<madvenka@linux.microsoft.com>,
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?=
	<mic@digikod.net>,
        Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Topic: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Index: AQHblFPgL0brNbuxF0+4/LV272jmjbOxhcYAgB32HoA=
Date: Mon, 12 May 2025 15:26:58 +0000
Message-ID: <98E4DC9B-6BB6-48A7-A27D-4739044E39CD@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <994de1c0-04c2-485b-bab0-909e293d1cf8@codelabs.ch>
In-Reply-To: <994de1c0-04c2-485b-bab0-909e293d1cf8@codelabs.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA0PR02MB9583:EE_
x-ms-office365-filtering-correlation-id: 158afccd-3ad5-40dc-c922-08dd91696f8e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?NjhaendQYzV6ZEgwTzdwYkRoSTJVcGlvajByOGlCb0xnUk1tREFybUxZRXZM?=
 =?utf-8?B?N2djbGpBRlQxYXRQYXJlQmQ0U2xtOXFUNHVvcU93QU5JRTZDazcxYWkrSXFt?=
 =?utf-8?B?UG9QSHpORW5RbHJROUlMeXFDSDJzSVhlbGJmVFFtVUxqbnFXSmx5OXV2OG9z?=
 =?utf-8?B?TXd3RndxNkIwL1RESm9lMVNJMnQxM04rTlh2MFVhYlFySHByVlEyTS95MWNy?=
 =?utf-8?B?UUl1YkdCQngvN0pHREZvUHRPZmRZZ3d3Sy9jaDFuMUN1Ty9vaXMrRHZFZytZ?=
 =?utf-8?B?dE5vNUdWUjV6RzNaMERlRm1ja2pIeXZZYVB1Q2ltVTJML2pCak1XVkpCMlNE?=
 =?utf-8?B?UXgzTzZrTXkrT2RBb1loUXBkVGlGd0ZOdCtOcWtzVGRlazdSOTl6b01DYzZ6?=
 =?utf-8?B?NG1ydi9MamxmSkVNUFY2N0wxTXBWelVYUExScWt1RWNjTGdFTWxQTmhoRW0r?=
 =?utf-8?B?OVRwOCsyWlZtdkFxRUdIbEF1eVVVeFF2T3NUOTlBK1BpTVdtYldQQjlabm8w?=
 =?utf-8?B?a0RlVUtTZDVqODFQdlRBV3BKd3FiWHJ6VDN3TWY4WTRlRS9JNSt4S1NSQUlx?=
 =?utf-8?B?OGt6UGZPQVlOQWUwYnNjZEtYOXFaWE5PdU90UGVjWkdLbWluZ044d1U3YTVR?=
 =?utf-8?B?dlJsMGtwR2MrYzdLMzZmZUlPRkJ4U1h1RkY1RnRVclQyaEdGbWY2cVE5amUv?=
 =?utf-8?B?SThqdk5POGNXYUxpaTJTbTN6S3lCWk5DUk5YNnB4eVU1OVgvci92MjM0SzBp?=
 =?utf-8?B?d3N5WTVhOHhkcGhQT1NlZ1JwWDcxdG1QNDhuOWg3d1JhQ3BnK09IR0EzVnUx?=
 =?utf-8?B?aHdNOVpETjh1TTlRQ2JNdFdYd0QwOFdlTTNleEFlMU53cndBVlVLenZwVlp1?=
 =?utf-8?B?Z05INzJlZ0ZyYzA2dDFIS2pKek9ocVhhMURyc0FnbWRjVmRZSWlYRzZjRUJn?=
 =?utf-8?B?VjFGTmNuWVl3c1FvU3NDOTk2NzdTZGdaSEU4SXJjdEZscHpPdmNiRGkzdm9o?=
 =?utf-8?B?Uks0bFNQRHlYcXFQUDlPUUJ2dFo0b1A4ODZjNmdTcDNJUjM3eURMZm1JQjFw?=
 =?utf-8?B?cjIyTThpSHpweXNYMTFSWnpIUkp6UlJ3UGE1UkFKQ1Jyd05hQXZLNkVSNGxG?=
 =?utf-8?B?NER6L1BGQ25qS2tERkZsUEp0WXdZRVV6ZFFMVmdsNUxpWVNKbTRmZ2UvOTM4?=
 =?utf-8?B?UHJQNXVCYlZ1TkN2RGZEOGhtZ2FKeXhFblEzWlo3STBJZlhxWktkQmFIRHgr?=
 =?utf-8?B?V3kvdlhNYjF3UHNZamlMcFhmdDlXa2Y3QkVEbGVKaVFsdzgrejloZkRpd1BP?=
 =?utf-8?B?U2swRVI2cjFEVVprTkc5S0J2WEI2VlN1YlZZMXNlS25jZ1RzUUtMNlF0UlhF?=
 =?utf-8?B?V3kwQ1Z4WkdKNTJ1TE5pcTlyYmtjUmRTeElIaGNjelJuSFZDNXREemRTbjB4?=
 =?utf-8?B?clJWK0FjbWQyY1BNcXFrRTdUUjNWUGpJcGpRRlM1Y2E4UzcvVWw2bk5kNkZG?=
 =?utf-8?B?c0FUMVdOQlFaQXlwYUQwY3F5VVN6K2xjODNIclNzWWkvU2pOZXB2ckR6a21n?=
 =?utf-8?B?bXl0MGlSMmV1VXlUaVFwL3RkVUZaL3FheGFScis0NGNGQ25USC9mQ2FaWnlH?=
 =?utf-8?B?MlZWUW56MjgzbGtLZDkxMzNEZlZxN0F2Sm1VY1RXVmxjT1VPVlBubHZZNkwr?=
 =?utf-8?B?ZTB2TGFVdXFvTnlkeElDQjBSSXBhRjFkZ2M4UkhHU0lPc0xIN293b0x5a1FP?=
 =?utf-8?B?bWI1ZVk3R2Y0Smc5WERYVStVc2NyVXNyWk5qZDkvL1I2aWVhc01UZHE2dTl3?=
 =?utf-8?B?V3NTWFA5dnYrdkhLNmtCSnI3Ync4TUk2dUQ0T21yNVFtY29aeDNzQnpKeWxY?=
 =?utf-8?B?V0pSQi9RWlMzM3o2V1J2ZGNCTHhwUXhZN0R5MFFyUDRWZC9UckVlcXROUUh3?=
 =?utf-8?B?T0tCUG5WM3RDRmxhODIvQTJPQlRvaEhNSUs4MDQ3ZkdsdDdwRWhDTEdSOXlN?=
 =?utf-8?B?UFJXM1I2VVdRPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dWtLMW80ekdnZGpXUjZsMDlhOFZVTE9XeGFhWmk4enFHK3UyU2lRcHJ0end5?=
 =?utf-8?B?NUszUEd2V3d3ZXJJNTljbHMzR2loOE9OM1d2aU93SDJKM3hlVmtHVEZOK3Fq?=
 =?utf-8?B?Mm5WeDhqVlovbCszTWRiMGtxSWVYYkNreEMwajFHQ1I0WU9GSGpEZ3UyRUM2?=
 =?utf-8?B?MlIwSTVZeXBSdDRHRzBnaXB3MU9SekxhVmR2RXVxcG04TGJaZTlqbE5vaXF0?=
 =?utf-8?B?eitPWE1NYWFya2hOcFFHNEQrYXJLRTBNcEY4V2o5SmZKMjBMMmhYc3VncXhK?=
 =?utf-8?B?SnhsdVBCeEdBYUlCcE1xUU5PT29CYU1hcFlOTUt4WHFoZlhuVFRVQ2E5b2NF?=
 =?utf-8?B?bnQxM1dNejdTQXlLdWJHWEZPcGxyMzFjanE0TXAxQVpDQ0gxNlZZdXBOVlk2?=
 =?utf-8?B?bEtid3pGZGZkZDdRc0JqeHNGdHFHanhBZjhhWVhWY0hCdU1hdHREdjV2bkw2?=
 =?utf-8?B?NkxwZzdjK3hySUxCWXAvNEU1TkRRTU5xeDMzNDQzRnN5NUp0dGl4MHQySUJr?=
 =?utf-8?B?TythRXVoUEl3S3R4VHlEYVQxZ1ZhUFlDS1d6Vm12VERreXVRdUdZaTMzaHlH?=
 =?utf-8?B?YUVxS0E3VzAzZy9peGpSL0xaTzFOeUhuZUpXcWZMNTZ1WUowU2tQcXhGS05Z?=
 =?utf-8?B?L013ODVyOHRldzJvcGpWR2JraHJFS2p0aU1FaGZST3ZlLzQveGk5NGdWR3Z0?=
 =?utf-8?B?Z3ZOaVp4OHdmQmp4N2dMVFlZNFlNNE1qZ2VFMFBUQlRGZlF5SHNrTUxlSnNv?=
 =?utf-8?B?S09kZnVJU01GcU9DbGlXME1EN1JmNkRkSlR4YnFYK3pyQVE3T1NtaUlhWG5I?=
 =?utf-8?B?WThzdmF4T0JQR21LQzgvelBoYjBmd2xmdjFGTDZQdW9TRjY2SzR4VWduWm1P?=
 =?utf-8?B?Sm02OHZacE9sWExzU1pnT011SVNWZXc5Z09BUktJbmZvOWtRL2lub0tJbEU1?=
 =?utf-8?B?RmlOQTNBbEJ5VTZ0bkYwUW1vVTYvREhRVHVyZm9BQ3k5ckZzeGowclJ3VzZK?=
 =?utf-8?B?eU5pVzUxY1ZlTmNSWXpnd0pIbUt5ekIzbXV4SzZiV1MwZ1ZraWkrUnlMejZT?=
 =?utf-8?B?enhIMU1QaWJYeVoxMm84ZFRvU0hsZEJyWEs3dk8wMVI2MkVFL0tqZFhYOHdr?=
 =?utf-8?B?a1FXQmhwODJkVnhHUGhVY1dvbUZybjBaYzVaak1TM1RYTUg4aTNLSG01QUVv?=
 =?utf-8?B?bnZQRkw3ODRNb2I3ZEVLMERsOVN0QW9ZWWd4dUdkdkpRNW8rd2lkT0Rxblcy?=
 =?utf-8?B?TTZHK0pHMFpuUnNISGdlZXlET0Q1WkMxWWwxeFlxbStjV0pXS2h1MXJVYVMw?=
 =?utf-8?B?YUN4TlErKzBNeEpoeUQ0K2NPK3BwWHEwVThiVzBSVWVxM0NSOUhxYTNOVjNl?=
 =?utf-8?B?NHlOM3g1NCthWkNUMVB1SnQ5ZUUxZm4xbkFHdHB2bzIrMElleU9KOGJicDlY?=
 =?utf-8?B?di90a2NscUpRcGlRYlc1T0gzMTBDcGVOOHNiYWZ1NmxCalRtZlNDeUh5L0tl?=
 =?utf-8?B?aEVlZVFSblVOYjdGUzEraEhzRlEvTFVzQ2J4blNJdndQUWNCMWZSOUVpQXNE?=
 =?utf-8?B?S1VTOG1INmlRQUtmNGNndHRsSW54NjI4VmZWSkxzV0g2VFNiWmRxQ0I3dnlZ?=
 =?utf-8?B?VnhFQXMvZmljTTNJd04vaWxjOER1SGhSbXdHRXBlN3BSUHpESWtrajE4NkRi?=
 =?utf-8?B?ZmUyQTIrWDBuN1c4b3pEYkx6SHpRMzhta0UvNkFGOUhhUnZ6NkI3dnFpY0hi?=
 =?utf-8?B?R0pSajg4UVZwUUc3cjhybG9tQnQwaUZ3a1BBaE9EQkUzTHQ3RndkaEptYU5r?=
 =?utf-8?B?a09JZW1zYnozalZpcXluZ21KcnlKc1RmazBPT1IwS2dpeXcydUM2TWYyVDFP?=
 =?utf-8?B?NFVybGNEV3cwSlA5SWdoRDMzSnMxSFE3QzhFMnY0UkRrWGxxMzB0czN5YWpu?=
 =?utf-8?B?NEJEbUdESnEramJLRktLdWtRalgvRHkwdm9nNGlPcjRQRmErNG9kekQxOTBz?=
 =?utf-8?B?MTE0dTVFUnBVMVprMTR5d0dxRGJGNFQxNmkzTTBPSVZ6UndoVENYVUhiSkI3?=
 =?utf-8?B?Mkp3RVdiNENnTjJpc0JBeFVIOCtybTlGbEJrOUhFTE9KV0ZlUEZVaG00M2tJ?=
 =?utf-8?B?TUZ0RlBZb0U4Zjh2YTB0L1pBQ2h0T1p1UUh2SVB5T1ByMVU5WFlnR1RIODdN?=
 =?utf-8?B?enRtTDlFNldDYVFUd2xtYlo5azdlREVaYUh3VUF4UkVzV1VUUGN3N2FRYXdN?=
 =?utf-8?B?c2t0aTJENTBWazViaDVNbzJjTlFnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08621F4B576B72408F1DB5ECBB1304D0@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 158afccd-3ad5-40dc-c922-08dd91696f8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 15:26:58.5084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tQiKy+5VgdiEbHh8vHSYAXgpB+6Tc4KKY79d1FiopYUVDa54w8ip6ZlvzzHHkbw26CjWKmWPe0skDP/bd6b4vN6AvwsqOPyV6D4kIJiWULM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9583
X-Proofpoint-GUID: UzuMbEwoOl3TjvXY6s0f_DS0Bn0zEWBV
X-Proofpoint-ORIG-GUID: UzuMbEwoOl3TjvXY6s0f_DS0Bn0zEWBV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEyMDE2MSBTYWx0ZWRfX6gX8Fh3YjVDX zELZVUp2JA6UJCLyIjpBcRaAwTkMZrcwPDTy96x9kiC3NOYB3/AozZOt9AHrmNzhMwF7cpc9rto 1zDFG9FA/MPB/tXhUth+cjtowofzg+Y0Fm8d47+hPJLa5OYggro427v4NehBvUeaI6aAaKi0R1A
 aA+n8j1usCtjsKQNRhGnkSIZ/cVFKJdj+vjVtK/YyCnrIA8Ybcbp2XiCGaaSRrixEDl+1ttq+2U dk+7en6y9LA1FApZJQvxuoWReVgXZhEY0rVHr+aERh5X5Wsp+av4nOQTRbDxZ8/dMgmLBmjupJx h4tJEQqCqGPA64+vAZqL5AbgL5rs6mHLBLfqk6JcwwzNdkdfLffj6MA8kJIFc350FQlgLsJl5Wd
 cqKrG/mvA2uI37P7qnbxJ71PZklqvyMRZIZ4HULZ8vHfy1/Uvv2Z8z/Tw+VPZWretPRY5Ca7
X-Authority-Analysis: v=2.4 cv=YIOfyQGx c=1 sm=1 tr=0 ts=68221349 cx=c_pps a=B/o3nIjBIeux7E2B8s4M4A==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=3aE2Mwi2ebfnSqt0jGcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_05,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDIzLCAyMDI1LCBhdCA5OjU04oCvQU0sIEFkcmlhbi1LZW4gUnVlZWdzZWdn
ZXIgPGtlbkBjb2RlbGFicy5jaD4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gSGksDQo+IA0KPiBP
biAzLzEzLzI1IDIxOjM2LCBKb24gS29obGVyIHdyb3RlOg0KPiANCj4gW3NuaXBdDQo+IA0KPj4g
VGhlIHNlbWFudGljcyBmb3IgRVBUIHZpb2xhdGlvbiBxdWFsaWZpY2F0aW9ucyBhbHNvIGNoYW5n
ZSB3aGVuIE1CRUMNCj4+IGlzIGVuYWJsZWQsIHdpdGggYml0IDUgcmVmbGVjdGluZyBzdXBlcnZp
c29yL2tlcm5lbCBtb2RlIGV4ZWN1dGUNCj4+IHBlcm1pc3Npb25zIGFuZCBiaXQgNiByZWZsZWN0
aW5nIHVzZXIgbW9kZSBleGVjdXRlIHBlcm1pc3Npb25zLg0KPj4gVGhpcyB1bHRpbWF0ZWx5IHNl
cnZlcyB0byBleHBvc2UgdGhpcyBmZWF0dXJlIHRvIHRoZSBMMSBoeXBlcnZpc29yLA0KPj4gd2hp
Y2ggY29uc3VtZXMgTUJFQyBhbmQgaW5mb3JtcyB0aGUgTDIgcGFydGl0aW9ucyBub3QgdG8gdXNl
IHRoZQ0KPj4gc29mdHdhcmUgTUJFQyBieSByZW1vdmluZyBiaXQgMTQgaW4gMHg0MDAwMDAwNCBF
QVggWzRdLg0KPiANCj4gU2hvdWxkIHRoaXMgc2F5IGJpdCAxMyBvZiAweDQwMDAwMDA0LkVBWD8g
QWNjb3JkaW5nIHRvIHRoZSByZWZlcmVuY2VkIGRvY3MgWzRdOg0KPiANCj4gQml0IDEzOiAiUmVj
b21tZW5kIHVzaW5nIElOVCBmb3IgTUJFQyBzeXN0ZW0gY2FsbHMuIg0KPiANCj4gQml0IDE0OiAi
UmVjb21tZW5kIGEgbmVzdGVkIGh5cGVydmlzb3IgdXNpbmcgdGhlIGVubGlnaHRlbmVkIFZNQ1Mg
aW50ZXJmYWNlLiBBbHNvIGluZGljYXRlcyB0aGF0IGFkZGl0aW9uYWwgbmVzdGVkIGVubGlnaHRl
bm1lbnRzIG1heSBiZSBhdmFpbGFibGUgKHNlZSBsZWFmIDB4NDAwMDAwMEEpLiINCj4gDQo+IFJl
Z2FyZHMsDQo+IEFkcmlhbg0KDQpZZXMsIHlvdSBhcmUgY29ycmVjdCwgSeKAmWxsIGZpeCBvbiB0
aGUgbmV4dCBnby1hcm91bmQsIHRoYW5rcyBmb3INCnBvaW50aW5nIHRoYXQgb3V0

