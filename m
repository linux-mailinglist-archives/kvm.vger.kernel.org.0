Return-Path: <kvm+bounces-46281-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D4F8AB4949
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:10:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 671197A20B5
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:09:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391991B4227;
	Tue, 13 May 2025 02:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Y7IOuEcQ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="IsW/vwYM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53301A4F1F;
	Tue, 13 May 2025 02:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102209; cv=fail; b=tr51THCmKW7brHvC/Uo7wHaS9Ju1e3xDw3OBe8ma1MW0FxQyfgguDjMPwwqwI2lvRSXGGnJpTGVHKkWDj473LyqIhp6d265QypJWf40ShJKIMTi/bCSua4pHXy5ahhJ3G/VJ42WwlI3bttnnZFRmlart9a0Q7hcIfdQ4Ap55zTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102209; c=relaxed/simple;
	bh=DM503kEVQeHSOdh8D8oQDyXsp/cBNo7HKmnH+zBQ+QU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T/81Wlaz/9Tkupqu4BKItXAkc6MlM5JjKLyqGzDUNUYHoxJb+MEZryv29H3eGp9xVpXHurkfYbsJ53WxW/P3geH4qGxkKRDxgWwLQaeTRR3k03IjIpQaT5h4AQurskQetpNHBJvQlRV1I6g4k6f0P3aaelQljxKrV6/sGnRQ2KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Y7IOuEcQ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=IsW/vwYM; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CIFauC019710;
	Mon, 12 May 2025 19:09:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=DM503kEVQeHSOdh8D8oQDyXsp/cBNo7HKmnH+zBQ+
	QU=; b=Y7IOuEcQadUwLBRMqZOJPhwRC6sKxN7dr6J55nNP3094bsagVbr4q5Zc0
	c0m6+BdGUDp6CaRNTIZ7M7soYbNr2xSFnwsuD3iN/6a5I6qpP8sk7jslxyAIOlX3
	70RFH5aGEq7fZDqMJXNww5HG9rZFEmOg0NJhugDN21wrq9WWKA+6bj0nE1BJwF0g
	jXJAvYhhnNgaX86c2fMSeG5O4LWyB3KLui24m/+T2pQXDkoEtPKFjcZUe1Pv5DS6
	TKpuOSkwsEvexG7Rx0HzuF42nOwxE9H6nzx/FNZbOPhWWsfR+y+5k9awfuvGgfcm
	tdOP+MsbsmkTbo48eO2ey/AvBQCJA==
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46j64c4pcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:09:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZrvWLKG4XAdskjFg2MS8ydRCEQ3J9lfH/BeuyqHcEQb9Xs/WN5ELodpZ93wVKSUqdkcFZ47scUZy6pwjA60zKBNe8nqoicKLfVv8cySdEKXOqIY08Vye6IvuPY2zIQhR+9/8+tBZ1Zcux6S2yBBoAl6RpPBn+sb25q9qppJK2OacaBnLGoADXZ/bwWVK8/hs1HM5OVtqVgibbjrtsqADNQN/axnHlkqN6B4WB9+8/hi5a8nUvC+ayXoOPr9DKtdpW8C9WFFzIgkN83LPtkXdjYEePJw35LrJyO2mPO8SOR8gANuiojEa3+T/JjU6AmGisZWl+Sxw6f4o+le+sN3bzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DM503kEVQeHSOdh8D8oQDyXsp/cBNo7HKmnH+zBQ+QU=;
 b=IDKQG/aF0FHFWvGCqYNRCLyv07pcBGmPwGkwLNGDviKGQOkyL1RafidWlXHzz5BJqgds+q/na5VutDvyzRwOvaoGOZyKpVwh7LpHoNzn68UhwEFPA0SiGAsRRDk220/i8+fMVO7mcmSjlGlMunpnpm9VwLvWBtvENWLjV7G6m2m00lEKZko4H/4Zt1z32Mu87BksTCCXq9JDgetQanBSx3TqbSoHYvuFMo1h97yPsxZl6BVHy5bGubT+ozR82Kqy6rcEabxwOKfeWt8jeFjpkvp1hjIlpEO3qJYHZanle7EQb94hyg9MDUlyHKFWiEvizWY3+IMywNO6Z9njWEBdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DM503kEVQeHSOdh8D8oQDyXsp/cBNo7HKmnH+zBQ+QU=;
 b=IsW/vwYMcGQ/Is4QQ8d/bjHF9VS59PAysfdPBUstV+AqP29N0CoJc/mGERc45fDHHMGmzvkTAqGowH0OiDZJc8d/8cpxkRCal+SfbQakNrwzp8pU96e2RThmgv9YQ9YEevhTZzIdeTQyPFDc8KeCSkKgEJY5CwIkHvcagVL5KmLvL11Bf4JCscBToxvdUu6vzu2AfMKkAAEGfcExq60FoNJTrvUq3Q+HHSWJek8svmSQYAledFj6jFAy54EFD3vW525CRAE6eyAu0QdWVNHz71wCmFDxBBg3LIyrkJluqTO5ALEnlKNKErUdiKFRbMuvrx1KUxdHgDScfmIMz3BaOg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7151.namprd02.prod.outlook.com
 (2603:10b6:a03:290::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:09:26 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:09:25 +0000
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
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?=
	<mic@digikod.net>,
        "amit.shah@amd.com" <amit.shah@amd.com>
Subject: Re: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to
 understand MBEC
Thread-Topic: [RFC PATCH 14/18] KVM: x86/mmu: Extend is_executable_pte to
 understand MBEC
Thread-Index: AQHblFP7puy8TgmqfkeW3xyH95EPUbPP3beAgABRrQA=
Date: Tue, 13 May 2025 02:09:25 +0000
Message-ID: <9E0F858E-BAFB-46B3-8D00-442BE46F4D00@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-15-jon@nutanix.com> <aCJlR9jZniZN_7cH@google.com>
In-Reply-To: <aCJlR9jZniZN_7cH@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7151:EE_
x-ms-office365-filtering-correlation-id: 388caf57-92b9-4c2a-3517-08dd91c32f42
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TkxlV1R0QmR6UWF4Q0hEOHlvWmdhYkt3akFVcHJUVExRSUcwL2FFcXBBbHhw?=
 =?utf-8?B?aTVDQVMxVEIraWRSeElnT2hOSzNua0tCRWd1THVrV3NHSjVoZUM4Tm5WVUc5?=
 =?utf-8?B?d2hmaWN0bDhGNXNGbUVSWHRrM2MzVkx2eWRSL3ExbXdtOXpsajNUVVg2MFFk?=
 =?utf-8?B?WitOV0VnRUlaZDViT3FBd0FNUk51cDQya2d4bWtXZlZMOEN5YUt2UWlSek9K?=
 =?utf-8?B?N2NkV3ZGOUZCdlZuQmRQTU5HVkhWOHcyMkJEMDJwQ0Z3ZFJ1eTZBeVBYeDBQ?=
 =?utf-8?B?bU9BRWNhSDNhdHROay9GTU0vTnpqcldtVjY0eHA2RjAvNEUwbFo0VTRFN0I4?=
 =?utf-8?B?aVhQYTdIVExSdUdTd1dqYnQ0ejY0aFhEZXNZZGhHOXhIOGtvU0V6cG5rY0xs?=
 =?utf-8?B?ZUovSlZNNFFZTlJQM2NJcUVWSTlmOWZyb3NiMitRaVZQY0J2U3c2NW12ZFJX?=
 =?utf-8?B?UG5YWmw2dDlwZWZpZHp1T2VOYmhFMzAwNzY2U1c4WVIydFpvYzJaaWZpN0lI?=
 =?utf-8?B?eEo3Q2lqaHNFTUMvYkZhdmo2aTAxMi90V2VmSU9wV1o5UG9yOTdibHdmZ2hM?=
 =?utf-8?B?ZVZRZTZjTDhXelYxNzJMczRGQ2ZnemhzTXREd3lnZ2hPK3pFdVB0NWJ0anNB?=
 =?utf-8?B?ZE5Cc0MybUo5RFYvaEZNdXNqWmp0OU1LUVBXRmttMjR0VlE1RVdhWERwanRs?=
 =?utf-8?B?ajIxUFlNaEdXcVhqeHJPeldkbys3SEI0STRHazlIaEg0blNvdnJ0clo5V2R6?=
 =?utf-8?B?Z1RHU0Rxb1pNcEpuTzRpUUpQeU5SQnJoRnU3czRZTTVya2pNMnlkK0pZUHVy?=
 =?utf-8?B?Tm9JU01NZ1lGaSsrN2loYkI5dnJtekRqWS9abGhwWEtJRzA0RWF3ZnFndVFh?=
 =?utf-8?B?a2VEakp5ei9pSHFQRnpRTy91THo5bUtadVlCcmJaalc4VmxubGczS1NYZEJp?=
 =?utf-8?B?VldZVWhUTlFHOE9EcDZSd2tFT2NlY3NDNldZei9RZTBOVjBjNlorTTBMTGlG?=
 =?utf-8?B?eldJMWdvYXNhTUREMkdsVGlLVGg4ZUs4VVI4Z3ZhVXhRVkpUbGNTRmlKVE5W?=
 =?utf-8?B?S2VicitSaHRVRkcvSXAvanV4ZzdEUGdCbFlxL3BrSUJtM1Nwbm5BeldJRFRC?=
 =?utf-8?B?dmVrczJtcmJoNEU2aEtuUXNxSTJNaElWVU9VVHNGSkdCUkNOSXZObFlCb3Iy?=
 =?utf-8?B?NGJmU0tJNlJkQktpVnpZU3lxZWtvQUlDRkplMzFZeVNsUVR2YllESkhwMi9w?=
 =?utf-8?B?V25TQVIxY1VUdkFWSFFVNWx4S2tTMjZjemFoaXlQVjRXNkc4blBBbFpIOE5l?=
 =?utf-8?B?TlcrNnlBUVR2MHJGR3pWZkZ3bTg4Z2ZaWFpXckMwdlk1V21aaVhKZFRWQWdw?=
 =?utf-8?B?b0RHclljTUgvNDlDTzhnQ1BEa09CcUh3dnMwQXVVUHMvS29HSVgvcnRkRCtF?=
 =?utf-8?B?eXROYzI2YjJMOUdpMENHR1hxZ1Y3Sm9kT3N1TVZtVUg3eWh3TitKT21HbmlI?=
 =?utf-8?B?YWRReFY3TGlQQUZLSGs3UFowalFBZllCcHlJMDU5bFZXWjFSWk0wSmFxUm5B?=
 =?utf-8?B?anN6SlQvU09jODdOdlZkNm9OWEJRdzFsR1BEOGhtRHFvS3NpOHlvNFkrZFll?=
 =?utf-8?B?dDlkbzNKMkpoQ1IyRmg1ek5vN3JsektVdUx5YXB1UGdHeTRhMDhVZGtMRkZj?=
 =?utf-8?B?bGt2RmV0M0RoNUl4cHVYRDUvNGc0QUQzZFN6d0ZEcHFnV3YralpsenZMNkhY?=
 =?utf-8?B?TUpJZkVVTExKQTJvMFNBS0pobWZYVnhWZmxVSVY1TENZZngrVC9ONHF4NDUy?=
 =?utf-8?B?d1p3Qk50aVlRdXNwWDRvMW96OWNKM0ZrZ3JRMGlSekV5UUppSHlLTlJOQ0pz?=
 =?utf-8?B?UEhVcGxpNVJPdkVGdGMzUS9oTFVPaUtlcTM0RTNLQmM2eHZoT0MwQkIyTlk4?=
 =?utf-8?B?ZWpRazYrYk10RnhjTTFNODdKM29wc0tManZyaEJtRzRiTllOMko5a0g0cXBK?=
 =?utf-8?Q?5AmPmypqMQ/8IGMREWE657bOExRgzg=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MTYyYnpEWC9BNWMxb2pVaEdLRE1YMTZVdEFPWEllcjFqZWxGSmxOcGk4ZlBE?=
 =?utf-8?B?bWdZSElhNFRNYnZCdkVBcjhEdUVuUFhCZUpkcG5PTFVPNVcyKzFMb0tJWjVB?=
 =?utf-8?B?K0E0b21xdkdKZmlndmpUV05GaGdaY3liYXBDMUF4TGRmb1FiQmJCSFgyMUFt?=
 =?utf-8?B?eTVGQ1NDTURUQ1pxK0FnbHY5Z1BmcHd1T0F6TWxUWW1LRHlJVXRIUFV6YVNL?=
 =?utf-8?B?Y0V4TlBMaGJhRnljcVl2NG5aNUVCMHh5UVBLQVludG84djhSZDI4L2h2WWNM?=
 =?utf-8?B?SVR3TG1CczRpYllMczVYeUhkTHNUcEo1MzRza25vWTFPallHVW01V2ltUUh2?=
 =?utf-8?B?aFE0a2xlQVh2VnlxYVdPWXpiZ2pIMXlaZStYRlVad0lBdDhhRUYrUjVqMlBs?=
 =?utf-8?B?aGZzU1BQMUExM05UZ1hPS25uN2haN3VXdUFMWVpqaHZxRDZBL0puOGsvNlEz?=
 =?utf-8?B?RU5UKzd4OUFLMFFlT282UXk5WStwSUErWFVhWlVtT0ZMUzV4SzJwZmZ5OTVZ?=
 =?utf-8?B?Z0NsSWJTS2cwQ25BRWJJeExKQzltS0ZNclE5MXdTWi9KVEswMElJQTA5NjIv?=
 =?utf-8?B?Y2JtWmJmY2tUbjZKZTBFT3YvZHRSSlJMTm5YVkhkOVN0Ym4vZ3hqUnpveVFI?=
 =?utf-8?B?L20vMDZnSFNTZGZtazM0SGVheG9ZcEF0UUhqd3JyRlhuRW16TWd0WFdDTFFk?=
 =?utf-8?B?UXhTdXRXRjBsOUd1a1pBZE9ud3lRb1MxU2tISS9paVEwN3FWZHUrdDRhNlFJ?=
 =?utf-8?B?K0JFSytaYUNEYTU5T2grZ09MY0N5YU1acGJnS2V4R2tDR0VBZk0zOUdvcTV3?=
 =?utf-8?B?Y0NJdTFLVVpTTkFORUVqakc2c0wyanorUkExZDNrZnVabHVoOG1jc04wMjRI?=
 =?utf-8?B?cjllN0ErODBDZTlyL045WlhnNHZyMHZSZ1lZRlJPUjVpaUZQZDFNcldCS3JG?=
 =?utf-8?B?RWdiWDJzanBqNnliNzkrNGJXa0Z4bmNFKzJsY1RsWk9wVmtNVTBlWDB2SURD?=
 =?utf-8?B?MFQzS0tISWY1RUZjb2pZTUd3S3E1dHNUcGhraC9zNHR5ZE42ekNrODBOMkY2?=
 =?utf-8?B?WmlFYUVKNklGZ3FrbGVwU3Q3eVZFaGV4UnA4cTBkdjZ6djI2ZlF6RWZFOE5S?=
 =?utf-8?B?VEdQS3V5K0xsc01GOW9nVDRmeGwrR1hrRW9xNmc5M1dsS3NVenJnRXZYNGE2?=
 =?utf-8?B?WkE0RS95RlVIclQ3UlBkY01ZWDZtTDBFczlxcFIvRUQ0U1NvdHNVd2dYanFD?=
 =?utf-8?B?QW1hOGlVbThjRnY1RTdFZElFRjFhL2VyTUQwcDcySDZvVXJUc2NEMzhVU2Qw?=
 =?utf-8?B?R0U1K1lMak9la0tqcHhGWVRhTVJNK1lXWVRUajhDVDdOZWxwRm5xaExUK3Nr?=
 =?utf-8?B?L1JKK2xBcHJZU0xjMC82RnRLRkpPaGFTSlBieFJORWF1NEt2anE0ekxlMHQ0?=
 =?utf-8?B?WEVPWDYzaXBYQVlBc2paZVVHRWNETU5SNkNxQWlGUkpSZWVFc2JFTkFTMVlU?=
 =?utf-8?B?dk90eVpZbXJHT3dQbmphVzlrUE1HamUwS3V3SVBoUU0vZGtmT29RN2VnZ3Y3?=
 =?utf-8?B?WXlaS1lGZWh3QkJiOUg0L2lIR0FCVXZFRThJaDl1ZDkvWlpHWkk4dTJ0NmE2?=
 =?utf-8?B?NEZNKzZReGV2dysrbTJ6Z1lEVUJVaE5ad0tUandMWjlSdFJiMmQycFdNU0JP?=
 =?utf-8?B?aGZnNXZFNXNwUkdSV29kUERiOHhiYTVvZ2RwZkVDVjYwVHRFMGJweHBxMnJV?=
 =?utf-8?B?VExXOWJiOVFvaHFROEo1aUZ0dGJnZEg3a0lKRXNUYTUyWEpPWngzbktnVUl1?=
 =?utf-8?B?U2NHbXVpRVpSOHVJZVhSQ1VoTmZaUjFvcW1JK3hyaHppM25WMkUyRWlralI2?=
 =?utf-8?B?RVVjSys3dTJ1eENKYmNlaC91NW1aNk9FbElUOVpWOWV6NjBuQytIWjFTRVFE?=
 =?utf-8?B?Zm5uWnNlRTBrV1VMa3EwcW9Wbnc5d1RZQVBIcUsxd1dpUngwKzVwU1BMZmky?=
 =?utf-8?B?TXdTRXlISjYxMFNlSGpFZm1GN28wK05WSmtnM0ZuQ01vblVzQjFnb01HcGhE?=
 =?utf-8?B?VHB6S1R5Q2JXajYwMnBibXpseTV0TG5BZC9OdFlINU5TbTdmUlMwUjY5eDAr?=
 =?utf-8?B?emVBVWxuQjU0dHdUUHZlZmhFdSsvMklJdnlUNVpMb2xuZDEzZkxpbW5Pb055?=
 =?utf-8?B?ZnV1UWRjM2VWOEVuS0hpTG50ejZhcVRWa0tPMVB3YnYrNVNPaHMzTVFXNjZu?=
 =?utf-8?B?cWJObS9hUTFhdHZSSExxSU8xWS9BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <197455CF6CDFF047A62E4084124ACE27@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 388caf57-92b9-4c2a-3517-08dd91c32f42
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:09:25.3583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tcnOs6xJ0JMVyQu9dhium2lzgGmfKhub2lxvURXm1mbMqhtyz7Pc/xcCCT1KZ9KhLOhoQEHuwCnfy1YCyOq/NhzhEmkSYQZ7E8EPM0YtO/g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7151
X-Proofpoint-GUID: iy9iKfGpzocSJTLurhr_wn69FE7RalXb
X-Proofpoint-ORIG-GUID: iy9iKfGpzocSJTLurhr_wn69FE7RalXb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxOCBTYWx0ZWRfX4Pj+66xmH+nP uMVpPHTY+X27K2Lz40kwJPiDd7jERI3c0apsjfjSbhK1ZRCizg73IW4+29d1RuCebINxMAR9BWG YthfWBHCLBxi0+s+MW5q9mpJRbkq6SZPb6Ken5CSZnJjNUlcYrD+3uD9EodD5DHCXBKpW157jYU
 57vvlYpOH5XZKjGp1cBR5l8onEkOnXBb25jU0H2Hls6hQSjVpy25lkUNtCCCt87q+U/L3dMVGa2 gD85Afs+qqOKh7EeZiEbmsvG+ccPGzKeByDr3+vmr4WC18zLYC3EkLnUd0DwKKcJBhmo9L/hP+l g+lJuDNuBGrkc+7168lBtFzYb9x3MQsK67FTff4CWAJJr3RoCcS911BmHc5SltsJ99c+6jRJYej
 uYVDO1AifVI8oX1ejLTpVrGEFmzKfpmdDVqYcnPzwjYo8oURgj01hF1JGHXN+mFrYU1SC28E
X-Authority-Analysis: v=2.4 cv=YIOfyQGx c=1 sm=1 tr=0 ts=6822a9da cx=c_pps a=R19XVbJ/69TrMGWtO/A4Aw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=rN3IRV3TWbPnILPW67AA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjE24oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBAQCAtMzU5LDE1ICszNjAsMTcgQEAgVFJB
Q0VfRVZFTlQoDQo+PiBfX2VudHJ5LT5zcHRlcCA9IHZpcnRfdG9fcGh5cyhzcHRlcCk7DQo+PiBf
X2VudHJ5LT5sZXZlbCA9IGxldmVsOw0KPj4gX19lbnRyeS0+ciA9IHNoYWRvd19wcmVzZW50X21h
c2sgfHwgKF9fZW50cnktPnNwdGUgJiBQVF9QUkVTRU5UX01BU0spOw0KPj4gLSBfX2VudHJ5LT54
ID0gaXNfZXhlY3V0YWJsZV9wdGUoX19lbnRyeS0+c3B0ZSk7DQo+PiArIF9fZW50cnktPmt4ID0g
aXNfZXhlY3V0YWJsZV9wdGUoX19lbnRyeS0+c3B0ZSwgdHJ1ZSwgdmNwdSk7DQo+PiArIF9fZW50
cnktPnV4ID0gaXNfZXhlY3V0YWJsZV9wdGUoX19lbnRyeS0+c3B0ZSwgZmFsc2UsIHZjcHUpOw0K
Pj4gX19lbnRyeS0+dSA9IHNoYWRvd191c2VyX21hc2sgPyAhIShfX2VudHJ5LT5zcHRlICYgc2hh
ZG93X3VzZXJfbWFzaykgOiAtMTsNCj4+ICksDQo+PiANCj4+IC0gVFBfcHJpbnRrKCJnZm4gJWxs
eCBzcHRlICVsbHggKCVzJXMlcyVzKSBsZXZlbCAlZCBhdCAlbGx4IiwNCj4+ICsgVFBfcHJpbnRr
KCJnZm4gJWxseCBzcHRlICVsbHggKCVzJXMlcyVzJXMpIGxldmVsICVkIGF0ICVsbHgiLA0KPj4g
IF9fZW50cnktPmdmbiwgX19lbnRyeS0+c3B0ZSwNCj4+ICBfX2VudHJ5LT5yID8gInIiIDogIi0i
LA0KPj4gIF9fZW50cnktPnNwdGUgJiBQVF9XUklUQUJMRV9NQVNLID8gInciIDogIi0iLA0KPj4g
LSAgX19lbnRyeS0+eCA/ICJ4IiA6ICItIiwNCj4+ICsgIF9fZW50cnktPmt4ID8gIlgiIDogIi0i
LA0KPj4gKyAgX19lbnRyeS0+dXggPyAieCIgOiAiLSIsDQo+IA0KPiBJIGRvbid0IGhhdmUgYSBi
ZXR0ZXIgaWRlYSwgYnV0IEkgZG8gd29ycnkgdGhhdCBYIHZzLiB4IHdpbGwgbGVhZCB0byBjb25m
dXNpb24uDQo+IEJ1dCBhcyBJIHNhaWQsIEkgZG9uJ3QgaGF2ZSBhIGJldHRlciBpZGVhLi4uDQoN
ClJhbXBhbnQgY29uZnVzaW9uIG9uIHRoaXMgaW4gb3VyIGludGVybmFsIHJldmlldywgYnV0IGl0
IHdhcyB0aGUgYmVzdCB3ZSBjb3VsZA0KY29tZSB1cCB3aXRoIG9uIHRoZSBmaXJzdCBnby1hcm91
bmQgaGVyZSAob3V0c2lkZSBvZiBhZGRpdGlvbmFsIHJpZ29yIG9uIGNvZGUNCmNvbW1lbnRzLCBl
dGMpIOKApiB3aGljaCBjZXJ0YWlubHkgZG9u4oCZdCBoZWxwIGF0IHJ1bi90cmFjZSB0aW1lLg0K
DQo+IA0KPj4gIF9fZW50cnktPnUgPT0gLTEgPyAiIiA6IChfX2VudHJ5LT51ID8gInUiIDogIi0i
KSwNCj4+ICBfX2VudHJ5LT5sZXZlbCwgX19lbnRyeS0+c3B0ZXANCj4+ICkNCj4+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaCBiL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+
PiBpbmRleCAxZjdiMzg4YTU2YWEuLmZkN2UyOWEwYTU2NyAxMDA2NDQNCj4+IC0tLSBhL2FyY2gv
eDg2L2t2bS9tbXUvc3B0ZS5oDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaA0KPj4g
QEAgLTM0Niw5ICszNDYsMjAgQEAgc3RhdGljIGlubGluZSBib29sIGlzX2xhc3Rfc3B0ZSh1NjQg
cHRlLCBpbnQgbGV2ZWwpDQo+PiByZXR1cm4gKGxldmVsID09IFBHX0xFVkVMXzRLKSB8fCBpc19s
YXJnZV9wdGUocHRlKTsNCj4+IH0NCj4+IA0KPj4gLXN0YXRpYyBpbmxpbmUgYm9vbCBpc19leGVj
dXRhYmxlX3B0ZSh1NjQgc3B0ZSkNCj4+ICtzdGF0aWMgaW5saW5lIGJvb2wgaXNfZXhlY3V0YWJs
ZV9wdGUodTY0IHNwdGUsIGJvb2wgZm9yX2tlcm5lbF9tb2RlLA0KPiANCj4gcy9mb3Jfa2VybmVs
X21vZGUvaXNfdXNlcl9hY2Nlc3MgYW5kIGludmVydC4gIEEgaGFuZGZ1bCBvZiBLVk0gY29tbWVu
dHMgZGVzY3JpYmUNCj4gc3VwZXJ2aXNvciBhcyAia2VybmVsIG1vZGUiLCBidXQgdGhvc2UgYXJl
IHF1aXRlIG9sZCBhbmQgSU1PIHVubmVjZXNzYXJpbHkgaW1wcmVjaXNlLg0KPiANCj4+ICsgICAg
IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gDQo+IFRoaXMgbmVlZHMgdG8gYmUgYW4gbW11IChv
ciBtYXliZSBhIHJvb3Qgcm9sZT8pLiAgSG1tLCB0aGlua2luZyBhYm91dCB0aGUgcGFnZQ0KPiBy
b2xlLCBJIGRvbid0IHRoaW5rIG9uZSBuZXcgYml0IHdpbGwgc3VmZmljZS4gIFNpbXBseSBhZGRp
bmcgQUNDX1VTRVJfRVhFQ19NQVNLDQo+IHdvbid0IGxldCBLVk0gZGlmZmVyZW50aWF0ZSBiZXR3
ZWVuIHNoYWRvdyBwYWdlcyBjcmVhdGVkIHdpdGggQUNDX0VYRUNfTUFTSyBmb3INCj4gYW4gTU1V
IHdpdGhvdXQgTUJFQywgYW5kIGEgcGFnZSBjcmVhdGVkIGV4cGxpY2l0bHkgd2l0aG91dCBBQ0Nf
VVNFUl9FWEVDX01BU0sNCj4gZm9yIGFuIE1NVSAqd2l0aCogTUJFQy4NCj4gDQo+IFdoYXQgSSdt
IG5vdCBzdXJlIGFib3V0IGlzIGlmIE1CRUMvR01FVCBzdXBwb3J0IG5lZWRzIHRvIGJlIGNhcHR1
cmVkIGluIHRoZSBiYXNlDQo+IHBhZ2Ugcm9sZSwgb3IgaWYgaXQgc2hvdmluZyBpdCBpbiBrdm1f
bW11X2V4dGVuZGVkX3JvbGUgd2lsbCBzdWZmaWNlLiAgSSdsbCB0aGluaw0KPiBtb3JlIG9uIHRo
aXMgYW5kIHJlcG9ydCBiYWNrLCBuZWVkIHRvIHJlZnJlc2ggYWxsIHRoZSBzaGFkb3dpbmcgcGFn
aW5nIHN0dWZmLCBhZ2Fpbi4uLg0KPiANCj4gDQo+PiB7DQo+PiAtIHJldHVybiAoc3B0ZSAmIChz
aGFkb3dfeF9tYXNrIHwgc2hhZG93X254X21hc2spKSA9PSBzaGFkb3dfeF9tYXNrOw0KPj4gKyB1
NjQgeF9tYXNrID0gc2hhZG93X3hfbWFzazsNCj4+ICsNCj4+ICsgaWYgKHZjcHUtPmFyY2gucHRf
Z3Vlc3RfZXhlY19jb250cm9sKSB7DQo+PiArIHhfbWFzayB8PSBzaGFkb3dfdXhfbWFzazsNCj4+
ICsgaWYgKGZvcl9rZXJuZWxfbW9kZSkNCj4+ICsgeF9tYXNrICY9IH5WTVhfRVBUX1VTRVJfRVhF
Q1VUQUJMRV9NQVNLOw0KPj4gKyBlbHNlDQo+PiArIHhfbWFzayAmPSB+Vk1YX0VQVF9FWEVDVVRB
QkxFX01BU0s7DQo+PiArIH0NCj4gDQo+IFRoaXMgaXMgZ29pbmcgdG8gZ2V0IG1lc3N5IHdoZW4g
R01FVCBzdXBwb3J0IGNvbWVzIGFsb25nLCBiZWNhdXNlIHRoZSBVL1MgYml0DQo+IHdvdWxkIG5l
ZWQgdG8gYmUgaW52ZXJ0ZWQgdG8gZG8gdGhlIHJpZ2h0IHRoaW5nIGZvciBzdXBlcnZpc29yIGZl
dGNoZXMuICBSYXRoZXINCj4gdGhhbiB0cnlpbmcgdG8gc2hvZWhvcm4gc3VwcG9ydCBpbnRvIHRo
ZSBleGlzdGluZyBjb2RlLCBJIHRoaW5rIHdlIHNob3VsZCBwcmVwDQo+IGZvciBHTUVUIGFuZCBt
YWtlIHRoZSBjb2RlIGEgd2VlIGJpdCBlYXNpZXIgdG8gZm9sbG93IGluIHRoZSBwcm9jZXNzLiAg
V2UgY2FuDQo+IGV2ZW4gaW1wbGVtZW50IHRoZSBhY3R1YWwgR01FVCBzZW1hbmN0aWNzLCBidXQg
Z3VhcmRlZCB3aXRoIGEgV0FSTiAoZW11bGF0aW5nDQo+IEdNRVQgaXNuJ3QgYSB0ZXJyaWJsZSBm
YWxsYmFjayBpbiB0aGUgZXZlbnQgb2YgYSBLVk0gYnVnKS4NCg0KK0FtaXQNCg0KV2XigJlyZSBv
biB0aGUgc2FtZSBwYWdlIHRoZXJlLiBJbiBmYWN0LCBBbWl0IGFuZCBJIGhhdmUgYmVlbiB0YWxr
aW5nIG9mZiBsaXN0IGFib3V0DQpHTUVUIHdpdGggKG5vdGlvbmFsbHkpIHRoaXMgc2FtZSBnb2Fs
IGluIG1pbmQsIG9mIHRyeWluZyB0byBtYWtlIHN1cmUgd2UgZG8gdGhpcyBpbg0Kc3VjaCBhIHdh
eSB3aGVyZSB3ZSBkb27igJl0IG5lZWQgdG8gcmV3b3JrIHRoZSB3aG9sZSB0aGluZyBmb3IgR01F
VC4NCg0KPiANCj4gaWYgKHNwdGUgJiBzaGFkb3dfbnhfbWFzaykNCj4gcmV0dXJuIGZhbHNlOw0K
PiANCj4gaWYgKCFyb2xlLmhhc19tb2RlX2Jhc2VkX2V4ZWMpDQo+IHJldHVybiAoc3B0ZSAmIHNo
YWRvd194X21hc2spID09IHNoYWRvd194X21hc2s7DQo+IA0KPiBpZiAoV0FSTl9PTl9PTkNFKCFz
aGFkb3dfeF9tYXNrKSkNCj4gcmV0dXJuIGlzX3VzZXJfYWNjZXNzIHx8ICEoc3B0ZSAmIHNoYWRv
d191c2VyX21hc2spOw0KPiANCj4gcmV0dXJuIHNwdGUgJiAoaXNfdXNlcl9hY2Nlc3MgPyBzaGFk
b3dfdXhfbWFzayA6IHNoYWRvd194X21hc2spOw0KDQpBY2ssIEnigJlsbCBjaGV3IG9uIHRoaXMu
DQoNCg==

