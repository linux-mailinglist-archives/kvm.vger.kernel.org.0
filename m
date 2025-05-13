Return-Path: <kvm+bounces-46278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC43BAB490B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4116A7A8292
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 01:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D7E01A3A8D;
	Tue, 13 May 2025 02:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="k1AYunEK";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Zl5rbePl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DE9199252;
	Tue, 13 May 2025 01:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747101601; cv=fail; b=mLGhyx2xFn07B/yxSq2IF5ACXBkqE+M2EvWCS8niJML1xxJL2b5Wc9zaRvQtqPy/Rd7f+CA6Lh14mScucKF4xQd5Jh6G6rVtdS5BRrQQhYjJgkN+Iue10NddsY4zAd1dUAIFcq907fUdpwtYCGbrOJPkQtSVjqGeUn7qscJ9SMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747101601; c=relaxed/simple;
	bh=cjLNl6SJcuA+9LvB56utWxUvXCXzl7iLFqKOWWpZsi0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ty3XPWwEGFPxdw9Ze3TXBBR73bupWC3k57CJG3+zzPvU/DYYoOLRlemtkTEcLvxNXgYBPNgRa9srXXYfqKp5SspqTiutUsaC13L21sGj5sIeuZUUaEQhy6YEMPRIT+BSftj5ks6Yr1FnuKpeBWDclWAHdIhDR2CsoXIadujjnjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=k1AYunEK; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Zl5rbePl; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CJZQ8i029144;
	Mon, 12 May 2025 18:59:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=cjLNl6SJcuA+9LvB56utWxUvXCXzl7iLFqKOWWpZs
	i0=; b=k1AYunEKHw9ouslLfgZ1WaHfgP5p6e9/7JJMJzMXmzEgQ4n21MY9+FBNv
	lF3qNg0xTZUqXC0gmNOKK9DwcdFH+GAumN9JBnP1LMOMqh8rQXGl6hTeMP7T5I/z
	e5ALPiTePDWTnkpVQ226wl9nrrNshAEhe65QJ0GRCmtr/NjLlOMSiAPWvaOfWHJ6
	zutWv6HTM00p+megPJZssT3vwBfkWtIq8Ff5n7JNZ2Phf+6kFffCwc9g3E9JdRJn
	L1g5yc02j/Lz96g8N6NBXRoFEMrmuqHDs4g9LelQ30Trx4rJPYO/rZLFZ+YFn6TA
	qPiKM5ubnUVf50wnRveeCAfImCS+w==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azlp17010021.outbound.protection.outlook.com [40.93.12.21])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j6b04k5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 18:59:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B8EIZO5YvSw8ds7z5EnvKVcko5szYe/DZN6pJafrq2H+qWbBhsNy84+wMeKGk7SlB2T9gkNPfV2+HQZjT+Dfs2zLZ/l3Vu2cvMP7z6k108sTXJe7fEKrA/+UKyeMFXT6HHmnduUolPCKLoHZFhsU5lsHbSeHQRLCKBgCTAG2HwQHP7LuEVFBjusWdtYLw6UhxIC+/apV+cat36qxR7a9h0rGQgDjHpBFHK7MZKkUckaQ6DADUUzyWuHfcEJUVx756yZCATho2vStkCrNC2c94VRUoOKq+NO6ECGgzpkDyHRiSMahtB1C6KYYppp5s5KGz6ResIxiwINwoknES+fogg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjLNl6SJcuA+9LvB56utWxUvXCXzl7iLFqKOWWpZsi0=;
 b=Q05sUvmkciRj6AjbeizVjq6X5hGuK38Fx19HyY2UYfVEkEyEre9bagMblyupdqNW85PXUOJjCaw316EpHRO66OMGa7//SE3he2c7DtAJx9bZJJNYjj5134Zuug7EGMbYCL82EJZ9edqBwPoAcVv9jZgbxoJkt+eyw1o4zQRO/tjCAnjF6wp0Y1b0BCX8wywUegLzM8hdiL/rFNyekc6Wpy3BXkrmizRbPTD+Spb4fytyuGpvwzHKaPwcgdjwEcjklKAVIj0CtKTpxMusSwDv01x//JL7U8ZTAwVF2cqo5vPnIwx4fKSRp6bLeIP/d07y0XNroiTJofGZVWj69jFowg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cjLNl6SJcuA+9LvB56utWxUvXCXzl7iLFqKOWWpZsi0=;
 b=Zl5rbePlmTeX/BNcG+UiUJlOLFS3PMtJMMQEWWmZNuXc1KIUvvVM1SxVTcQDqE23wYO1GFMLV/H0h2EJ6vIDJufGZAyZXkA6yGHGP9A03NZ9Cm77aevmvmjEyMwWgYEoSiMpf9My6HXq8H9anyoZEziD97sv8RrmcuULg2oVKyf3oy+afF1IsVRw+LK5QyR+cnWFf9pFNauZ2Ty9uV4O5b0v8zJF5QXpYb0J2iJfKvUpUQDxm6Yh0QVHfVwnEPByy9VP+rLMYooF+Pjmyq/TjSMFpMruq7PfBeOjHZV2seW+cTJ90u+UoWtSe+tZscI8f8my3krUXj4eDArzz1hWfQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DM8PR02MB8198.namprd02.prod.outlook.com
 (2603:10b6:8:4::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 01:59:22 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 01:59:22 +0000
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
        Alexander Grest
	<Alexander.Grest@microsoft.com>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>,
        Tao Su
	<tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Topic: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Index: AQHblFPgL0brNbuxF0+4/LV272jmjbPP5hMAgABGgoA=
Date: Tue, 13 May 2025 01:59:21 +0000
Message-ID: <09F33B66-1750-43FB-B97F-5BC3DF42B356@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <aCJsSvc4_azZNrKI@google.com>
In-Reply-To: <aCJsSvc4_azZNrKI@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|DM8PR02MB8198:EE_
x-ms-office365-filtering-correlation-id: 70ffb7d6-4bdb-4d16-d37f-08dd91c1c79f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QnJTR2dicnZNMHFoa2xBUWNyY3JpY3V2d1FrT2hKaythUHZXYkJidE95ajRi?=
 =?utf-8?B?Vml6SkdwMVprUnRMamU4ayt3U3R5VVhiaXdlaDFDTitjbkhFTm1Cc01JMVpP?=
 =?utf-8?B?SFZvMStwclJRUlFEOWlmNENESTFyVWIxSXgwbStCQ3ErU1VoZDE3eHZEd2s5?=
 =?utf-8?B?TnlBSERXc1orcDBqTGpwaTlGQzhXV1FUbGJIdXIySFpFdHVWT2NjdGZVS1Nr?=
 =?utf-8?B?bnpFRzBxTVVidk9yRnJUKzg5UkF2ZWxseW5KemlIbFBuMzQxbkJGVE9ld1F1?=
 =?utf-8?B?K05jYXpuUExhOVlKd0YvVmFaRzlGbTZ0L3FPdlljaFVVY3d3MEtUOTNPV0FF?=
 =?utf-8?B?ZjlKa25DK0xNVnNtUlZZOEFEZDFYMHVDajcrZ3k4cGg0aUtKZC9OMytJMk9R?=
 =?utf-8?B?dVlYVEVrRTZJRDU3alVYRXV3S2RpbitnQjFJY0pJV2R4ZFVyM2xEUHd5TXJ6?=
 =?utf-8?B?cHA0VG16ajcxVmFiYTcvTlp1VEVBUEEyOVdaMyt1YWFKWEkwZ3pVT2VaVm1P?=
 =?utf-8?B?SzZTSjNUT0lCT2xCcjJLMVhlSlZ3YVZxVS9kVkFmTEtjRjFqL2hKRmJzYXVM?=
 =?utf-8?B?VVh5S2JYSFhhSnJMdjVyZmdGZUxCTVcvalIreURxNGhCWVc3c3NWa0NVRXZS?=
 =?utf-8?B?YnVpQUU1cE9NNm41T2dpSVZGdURmczdYSk9XUXIvQnZpOG1yajMxaisyWVZV?=
 =?utf-8?B?Uk5xVHZuR3NnTG5xS2lGVU5tcWtxc3dSdEVzcENwcjBoWTVkR2hKbzluZGJB?=
 =?utf-8?B?RWIzZ2Y0RHFCc0ZDenZQamljU2ZVRHZaVXZ0L1FaVGh6RjIrNTJOelJNN080?=
 =?utf-8?B?SENuZjM1WUE4V2Q4U2hxSGZUZ2d5QXhhR2pScWI3TGRQMkpDRHVJQVllNGNI?=
 =?utf-8?B?c1dwKytwcUFSUlRBUWl1bEtqWUVaTk5sYjVYTzJHOUZnY0dPQzk0TjN4Slg5?=
 =?utf-8?B?cFBCZmkvZ1B3cXFNNDgvTUhEQVpCaEM4b2xHeS8wNG1sRFl1QThiRWkwVnh3?=
 =?utf-8?B?Qlp6TkdyN0VsdEhpYWx0SURHZlpJN1hNOU94aDloa2hlYzhISWQxYUdDZitF?=
 =?utf-8?B?aTRxamZBdDluQno4b3lzVVRHZkxDNDYvV0JiREVyTm1qWGQ1WHJzcjZIakdX?=
 =?utf-8?B?aXF0Zngzb3hJWHJMMnJnZ3JCRm9xT0h0SURQT0VsNXpEeW1QOVRuZ0l6NDJi?=
 =?utf-8?B?ck5jYWN1WTQ5aTg3dGR1U0FaZXRkeHFHdjFOem9CLzVma3gyOTVTUExVTXJ1?=
 =?utf-8?B?bjZoTnMvUXoxRXoxQjYvL3NDdHVRbVYydWp0dzZTVzA5VytrRmRrSGpDWk5Z?=
 =?utf-8?B?aWFHcWs4VXV3Q2t4N2lzcGF2aFBiTGxUTFFZbW5IWU1ScFg0UlJrcGI3TTBH?=
 =?utf-8?B?NE1IWGNFemhWeDk0aUFNTGNWZjZMMnh3bnovRktiUTJ3Z2FIUEZ1Rzk5ZE40?=
 =?utf-8?B?SW45THNYVXBoeFpwNnBsOUFSeUR4Ly9IWkh4MTU2V2V6RndSQkRZd1lscHJX?=
 =?utf-8?B?MkxLT3ZEcTQvMW5NcUM3bWxDcjAvdGEzNjlENUFVYUdiRGFoM3J5Z0pPc2V6?=
 =?utf-8?B?UjBPWUpzNXFEQjNWcDFjTTEyOE41SWorUU1FQzcyU0hMY3ZXcVRYTVNtcERK?=
 =?utf-8?B?T3YvaU1vRXE5L296akJRMFBVc0E0N0QreVloUTNFNnpIRS9ndTBqSzFUQ3pC?=
 =?utf-8?B?aFFndzFIQXBKQlRUdjlpTU5YSEo4WU9Yb0dvb0wxdHJQOFVCVWZna3d4bVdi?=
 =?utf-8?B?bERkN1ZralB1bElieHJWK0pHSEVyK05MYjRobVY3QWloQkdHQXE5WkFwYys4?=
 =?utf-8?B?NC9KUWNrbGRYL3cxRlVjd3B1Rmdrc0FkcXJjTG9iQmVMUkNHekJwdngzbjFp?=
 =?utf-8?B?dVpOTGNFZW5odzE3MUkxQXJjL3lRSk1OKzRtUlJDTFRjZUxDdVFCdDZJVGtK?=
 =?utf-8?B?VFdpWWFOb01acWNOUERTWHR1K1oyK0xUUTZOY1FCOVZ1b1Jucm05Q3VZOVMz?=
 =?utf-8?Q?8Ua6EijDOQKLJeH2DlrCGy66eSgffg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WGsvcTVUK1kxaFJCNFZYelRhZHVwZUpJUkFVditwUTl6RHQzalJlcTB0Zlgr?=
 =?utf-8?B?aXM1M0hVTmUyN0FON2VvRVlhazRZemRwUUF1NHdzcmZKMDV4dXVZcFhCWlBK?=
 =?utf-8?B?NmVDc01CUXZ6VXE5aVo3TDdJcmg5Tjd4WmpqdjhpR09QSVVRN1Q0dFl1WHlF?=
 =?utf-8?B?aHlFKzlwK2FMM2R4cXFtcEl5czBYcDVXa2xhVzdOd0RwYzVjMkVWNitQemMy?=
 =?utf-8?B?aHY4MEFienNMeERiVFg1RUdmd3hYUGVXc2l5dXFucE1NbENULzgxQ2JZZGdL?=
 =?utf-8?B?TXQ5RHoveVphc3dtcFJlK1BjcTZhVWlRQ2pTcEd6Si9NajlWOFQ4TnE5WWJv?=
 =?utf-8?B?bTBNN2FxMHNlZG53WnoxdkgvWi9NL0I4WDZCWmgrc0tQcEphSHBiWXo5RjZQ?=
 =?utf-8?B?WDhhUnh0ekpQVEJveGRwZzNYRDFTSTJyMHNKalU3WDN0UVcvMEpiblRXNU1i?=
 =?utf-8?B?eXk0WEhocG02ZVVGa1d0MnBMMC9kTXVFUEZhMHRhRTVWT2I0WjJFODF5WVZY?=
 =?utf-8?B?aVRBUFVVVWtqaDNMLzNxc0RZZmk3Q2Z6SXpyOTBOblBjbkZSbHV5aTBNMnN1?=
 =?utf-8?B?UGlnWHFoM3hDaXM2aTNQQUh0RW9OTG1ONklJUGxwb1FIREQvblExdlM5a05B?=
 =?utf-8?B?Y3h2WWNId3NIS041Q1pxclAweE1FZzFzeWc0clozdjlLdUMrZmRwRGNtK3ds?=
 =?utf-8?B?N1lsUUlsZXBRRWt5dUQ3N2FGc2UxcGRKMVFNSjFvaW1iRXBKa0hvckRhMU9Y?=
 =?utf-8?B?ZUhDeWU3Y2lTanRiT3kwbjhRbFJTeXVmeUVvdWNUbGRKYTNkY29jSEtEbUNx?=
 =?utf-8?B?OURtMERiVjBVQVp6bUZoQ1ZEMUQyaFJ0MG9CRmQ0UVk3TGpoZW4vdUx6aFZi?=
 =?utf-8?B?K0JDb1czWkJibVR3MnRZeFBvSndscXdiOVVQL1VsTG9mdkg0eWRLdG1iRGlV?=
 =?utf-8?B?d2hGZUVIZnFFWVVmVVFkbjFqK2tUWnRQeXRKRHd3b082V2ZoVTNXTlV2b0dr?=
 =?utf-8?B?OWFLTzJtTGVEVlNVQ1VMdVgrcWtRWjRKS09EdjZOL3ZjK2xCbXRDZXE1VXQx?=
 =?utf-8?B?K3lZSGhCcEVxMHo3akUwVWVvR1hRbmp5aUlKbFRzR1I2dGI5eFZKVGRsb0l2?=
 =?utf-8?B?bXIzd3dqRFdJOEhwWnlrb3Bkc0Z4YkI1bXBKOWtTbllJdVVoc0IrVm43ZVRj?=
 =?utf-8?B?UnNDV2pDL0FlNE5TS2N0bllneGtsYnJsTVhpV3Q3RjNtMDY4S3ozbjNwVWw3?=
 =?utf-8?B?Ym9jZ0ZGOWg4NnNEZGIvTEY1cnlzQ0R4cjJobWs1R0x1cGhtSHpJUHhlVTdi?=
 =?utf-8?B?NmIrd1lMdXdySmQrNXhuWFduWDdLRTc5YlU0SzZnZTkvN21OeUlOWjJ0VEkz?=
 =?utf-8?B?ai9QMEVWeWU1TW1ST2ZUSDJndklkREdCRk1WM0RtdUZ1bEMxSDAvOGJ1TEQx?=
 =?utf-8?B?bm5BY0krQ2JCcEJmYzBFZGMrM0VuWG0ySTRLMEk5TFBCT3BVNFg0QnNFNzhv?=
 =?utf-8?B?SCsyS0x3eUxRTjREN2cvcURRalMwNVcxN0g5U25tM2Y4Mm1IQW5wMWVZam5j?=
 =?utf-8?B?RnZVSldjOXlSZzd6ZWIza2ZtQndJZUsxaTJDdWh3SjI2aEZ5N210N1dLV3Zx?=
 =?utf-8?B?YWt2elAxb0hCL1VCODk0NzlnVWVFSlpTR05FMWl0U204UjFWMWRtN3VrUlNF?=
 =?utf-8?B?S05rMXpLTkFXcHRDMDlmS3RUUG1yS1gzajB2RG8zd3F4azJIT2NNVWF3U241?=
 =?utf-8?B?cW81d0hCL1ZFeDBxcXBoR2tGK3g5elo5SUwyWndoREQwNGVHYS9mMVRTZGdn?=
 =?utf-8?B?S1MrVFQvL21EY21vTjJFMWtwUStvNllKb0IwZTEvc0FaL3pwUk8vWlhUWUlP?=
 =?utf-8?B?NkFaWHdXSGVIbHdYVFM5VWVjRGc3MUdmQmpBcUZqWHRFZ2cyYWY4V2pvdEFn?=
 =?utf-8?B?Z1lDWkFMcmN1N1c5Q3JISmUrMlVGUUFoWmpaRTVXNmRMVnpwYlNVOUVsOCtL?=
 =?utf-8?B?bEhSRXpKZ01DaVRPcWFwc3hYYmZJbHhwZDdCdlQ1Vi90a3l1MjdmODBFdUxY?=
 =?utf-8?B?K3kzNGVwby9naVErbnduQ3JJUHA5V3JsanpySEE3QlhpdS9XT1NwbjRKYnRK?=
 =?utf-8?B?TzFyNkE3cXh5MkZTS0JYTGZkT1I3VmlESWkwb2RIS3UvdXI2YWoxZWNCMk9k?=
 =?utf-8?B?ME9RNi9sdnFPOUVYcWZGTmIyZHozUkRWcElRRUgrY2Vua3JNamhEcm5lQ2Fq?=
 =?utf-8?B?ZWlnYzFmZTVSK2tMa1NVL3RGYW9nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C45B8E972F4D14E90B02E48974FF231@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ffb7d6-4bdb-4d16-d37f-08dd91c1c79f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 01:59:21.9994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tAUU9UJbw7nvXuxjoh1BjXJukOtG4AV8WmGVWzk691HD7VJQmPI7NKMO8PtPJTqOa2vqrSwANHqAIKN0nomnrqRfu9IcyJaUYnbl09nRlLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR02MB8198
X-Proofpoint-GUID: O7dbcloTlov8jngOgvtt7wPaMo9ZO-qn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxNiBTYWx0ZWRfX5qFAQDaHiJHg 3p3rFbSLS58+gMZ419t0QMIcoX5kWYqBh2/UkL8+38jClZlBo4iUDQsHHlWJycsc/cuRizUEQXW l/vYxnj42OcE8cLw/IYqnOAG/pgqtc7HtjJx2M4pIFV5ERWszxKTvCxR8Nt3cuuWpgzmRebP7q3
 DWZJBXzV7sxyp9bRmi/89371jm8n+3w2NEEgIgMgHPoOYA1X0RO3+Vs/mXUbKwEHRLWx4lMbB48 EwlSdoblRzf0BIczAPHtjxp0FXi78aaZN/S4hwRmiDQNNg6y7hzXQ6xMpkxyWrBfW1aVUqgUlav gv2296OG96DGwuCuSizM4PsHSyz8+IJqBCJCnGuJ/BoCKZTEXwBml/mb8+MbpPKyRL2tRE2gGjs
 7z+SMfdZSbedntorg5uRuSm2yeGAgM+DqwqAU/eteDEsqCOb50QGUdDnRs2m3V+cnY8am4br
X-Authority-Analysis: v=2.4 cv=FZs3xI+6 c=1 sm=1 tr=0 ts=6822a77c cx=c_pps a=6dLVn7RwcbTzQ1hpYGxp6A==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=LX7I1kJAzDWPOCG7xg8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: O7dbcloTlov8jngOgvtt7wPaMo9ZO-qn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjQ24oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiAjIyBTdW1tYXJ5DQo+PiBUaGlzIHNlcmll
cyBpbnRyb2R1Y2VzIHN1cHBvcnQgZm9yIEludGVsIE1vZGUtQmFzZWQgRXhlY3V0ZSBDb250cm9s
DQo+PiAoTUJFQykgdG8gS1ZNIGFuZCBuZXN0ZWQgVk1YIHZpcnR1YWxpemF0aW9uLCBhaW1pbmcg
dG8gc2lnbmlmaWNhbnRseQ0KPj4gcmVkdWNlIFZNZXhpdHMgYW5kIGltcHJvdmUgcGVyZm9ybWFu
Y2UgZm9yIFdpbmRvd3MgZ3Vlc3RzIHJ1bm5pbmcgd2l0aA0KPj4gSHlwZXJ2aXNvci1Qcm90ZWN0
ZWQgQ29kZSBJbnRlZ3JpdHkgKEhWQ0kpLg0KPiANCj4gLi4uDQo+IA0KPj4gIyMgVGVzdGluZw0K
Pj4gSW5pdGlhbCB0ZXN0aW5nIGhhcyBiZWVuIG9uIGRvbmUgb24gNi4xMi1iYXNlZCBjb2RlIHdp
dGg6DQo+PiAgR3Vlc3RzDQo+PiAgICAtIFdpbmRvd3MgMTEgMjRIMiAyNjEwMC4yODk0DQo+PiAg
ICAtIFdpbmRvd3MgU2VydmVyIDIwMjUgMjRIMiAyNjEwMC4yODk0DQo+PiAgICAtIFdpbmRvd3Mg
U2VydmVyIDIwMjIgVzFIMiAyMDM0OC44MjUNCj4+ICBQcm9jZXNzb3JzOg0KPj4gICAgLSBJbnRl
bCBTa3lsYWtlIDYxNTQNCj4+ICAgIC0gSW50ZWwgU2FwcGhpcmUgUmFwaWRzIDY0NDRZDQo+IA0K
PiBUaGlzIHNlcmllcyBuZWVkcyB0ZXN0Y2FzZXMsIGFuZCBsb3RzIG9mICdlbS4gIEEgc2hvcnQg
bGlzdCBvZmYgdGhlIHRvcCBvZiBteSBoZWFkOg0KPiANCj4gLSBOZXcgS1ZNLVVuaXQtVGVzdCAo
S1VUKSBlcHRfYWNjZXNzX3h4eCB0ZXN0Y2FzZXMgdG8gdmVyaWZ5IEtWTSBkb2VzIHRoZSByaWdo
dA0KPiAgIHRoaW5nIHdpdGggcmVzcGVjdCB0byB1c2VyIGFuZCBzdXBlcnZpc29yIGNvZGUgZmV0
Y2hlcyB3aGVuIE1CRUMgaXM6DQo+IA0KPiAgICAgMS4gU3VwcG9ydGVkIGFuZCBFbmFibGVkDQo+
ICAgICAyLiBTdXBwb3J0ZWQgYnV0IERpc2FibGVkDQo+ICAgICAzLiBVbnN1cHBvcnRlZA0KPiAN
Cj4gLSBLVVQgdGVzdGNhc2VzIHRvIHZlcmlmeSBWTUxBVU5DSC9WTVJFU1VNRSBjb25zaXN0ZW5j
eSBjaGVja3MuDQo+IA0KPiAtIEtVVCB0ZXN0Y2FzZXMgdG8gdmVyaWZ5IEtWTSB0cmVhdHMgV1JJ
VEFCTEUrVVNFUl9FWEVDIGFzIGFuIGlsbGVnYWwgY29tYmluYXRpb24sDQo+ICAgaS5lLiB0aGF0
IE1CRUMgZG9lc24ndCBhZmZlY3QgdGhlIFc9MSxSPTAgYmVoYXZpb3IuDQo+IA0KPiBUaGUgYWNj
ZXNzIHRlc3RzIGluIHBhcnRpY3VsYXIgYWJzb2x1dGVseSBuZWVkIHRvIGJlIHByb3ZpZGVkIGFs
b25nIHdpdGggdGhlIG5leHQNCj4gdmVyc2lvbi4gIFVubGVzcyBJJ20gbWlzc2luZyBzb21ldGhp
bmcsIHRoaXMgUkZDIGltcGxlbWVudGF0aW9uIGlzIGJ1Z2d5IHRocm91Z2hvdXQNCj4gZHVlIHRv
IHRyYWNraW5nIE1CRUMgb24gYSBwZXItdkNQVSBiYXNpcywgYW5kIGFsbCBvZiB0aG9zZSBidWdz
IHNob3VsZCBiZSBleHBvc2VkDQo+IGJ5IGV2ZW4gcmVsYXRpdmUgYmFzaWMgdGVzdGNhc2VzLg0K
DQpUaGFua3MgZm9yIHRoZSByZXZpZXcsIFNlYW4uIEnigJlsbCB3b3JrIG9uIHJlYmFzaW5nIG15
IHBhdGNoZXMgZnJvbSA2LjEyIHRvIGxhdGVzdA0KYW5kIGluY29ycG9yYXRpbmcgdGhlIGZlZWRi
YWNrIGFjcm9zcyB0aGUgYm9hcmQuDQoNCk9uIHRoZSBLVVQgc2lkZSwgZ29vZCBuZXdzIGlzIEkg
YWxyZWFkeSBoYXZlIG1vc3Qgb2YgdGhhdCBkb25lLWlzaCwgc28gSeKAmWxsIHR1bmUNCnRoZW0g
dXAgd2hlbiBJIGdldCB0aGUgbmV4dCByZXYgb2YgdGhlIHNlcmllcywgYW5kIHNlbmQgdGhlbSBi
b3RoIG91dCB0b2dldGhlci4NCg0K

