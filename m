Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B57473D5C
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 07:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhLNGyB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 01:54:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:49649 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhLNGyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 01:54:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639464840; x=1671000840;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I37muLj4/DA2ikw0U4icge0IXt24Rlxb1tsRvvTKlOo=;
  b=TVbaVHUWqRlIMH33tzpBNm1U83vI2CItjsoL4Zniw5LQov2DNW0C2Vjv
   hKpd96LLwre6ZJz8dBxHttW8YNutwT6NxvgbLFt9STPoDxl1ZHJ7t2dsv
   wBPCv6cNRgb5tZOkSy+USOfIJjYXPAhR1VPdrm0T0fXOfb7mTjfg1eAXY
   v11a+lI9DV8nbWvvcEi4IOKiJK8Yrb2MoicO1d5dmP5yXik7GF8LH872l
   gQBMdFsH9iUWl/Z3fPLIq2Yrf2f5nisL2JRIemoX+S7ODyegzX4xkWFlQ
   hciwpUadImqWrVYpVV0qx6f2u4cqmMRxJlDhsxnKslmVOQBYBe6IuK0hW
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="219596415"
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="219596415"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 22:51:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,204,1635231600"; 
   d="scan'208";a="545059016"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga001.jf.intel.com with ESMTP; 13 Dec 2021 22:51:04 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 22:51:04 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 22:51:04 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 22:51:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 22:51:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kJnFGgflN25J2yz2xIVeRL6OLBLBviV4/OAiXrj33tU6p4WhAMquHQPXv6OqIYBQ4f7bK2rSOlV8GPdgcAc5KqPzVf0FnyjYtpksQ6O+ed6vxq6BFH8WAKyb/stL5x0w1+AthnJet0OJ3c5MG0piY0/AJA1ewLunpdOjydPSb2MbvAQ4XT9RzrQbd63d3fbnmgU3YXKU2FLhgnQ0/XbVHOWSvPDcgEPairp4o6PllUsav0zt2a1/6Uahgk6/68iMRqlNCMKVo7B3uWBUH+ghY5tJ/6z+V0fmQf7BLy4iogJ2MKuScvA0lpXVuHgTEYrmTYTVqErms1bf2uYAdxOVSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I37muLj4/DA2ikw0U4icge0IXt24Rlxb1tsRvvTKlOo=;
 b=ZI3qSz/eYq5uVHB00qLfszF+UBuvuKgppiI9aRiSZd0ZpOjXIEqHru6omTGvCp7mH/P9SDXKXwpoUejbc4dnaI6yhi7zT/npljy/Eqbh0H7EOHyaN14JABC9ABJefBBuyc9yykl9FXJfRnKdFC4rlmK6ckOfUONkBq5fhGn2KsgWKxAzw0WT5ynjsco0pLwg62dj7C3NBI9t/tcbJydNgnrBsZ/6ve6iPzCofUZtFguVZyhxMlwRaCkXf9dXstaAwl8MyXy4n0c3FSJvsbmEgPWSWjXsm9xrkmKIcYVbh4brsHKHTY6DNRYynEoMbhxIQFnG1jCPjwV3YqdfcxcPJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I37muLj4/DA2ikw0U4icge0IXt24Rlxb1tsRvvTKlOo=;
 b=vzMHcawClN7nFxaSitZd/jZ/jlNCktQPOYTrqKUKtVB+AeIt366sJF5UDOBqLVDuzxVcxXL2li8aJ7xOf8kenya0HC2UtzuqnkR3FnsHYbVgHbl9LJv7/8pCH7DPpeURbKjx5gb7t53YgG3BPLWUixrn4M7xcJFANHTUnkVc6iQ=
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN6PR11MB3857.namprd11.prod.outlook.com (2603:10b6:405:79::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 06:50:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::5c8a:9266:d416:3e04%3]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 06:50:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
CC:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: RE: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
Thread-Topic: [patch 0/6] x86/fpu: Preparatory changes for guest AMX support
Thread-Index: AQHX8JVdumtpU16HQ0KEkuhbSomwoawxjHaQ
Date:   Tue, 14 Dec 2021 06:50:56 +0000
Message-ID: <BN9PR11MB52761C38E5A664D21960D1858C759@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20211214022825.563892248@linutronix.de>
In-Reply-To: <20211214022825.563892248@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 723834a4-2b9f-4f51-9250-08d9bece144b
x-ms-traffictypediagnostic: BN6PR11MB3857:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN6PR11MB38578B8A28C9ED92AB2944778C759@BN6PR11MB3857.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:409;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QKkUCY6gh9T2mu40zu3qod8vSh5cnzbsusQQZ8iQBfLSBeeaCZv5WKMXLvbWVvYbCBPXdWSHTk/25JmWwuFl7syhH8ht+DbQZkxOV5DRhMoXEZO18Nui/ogtVIPR4MirBlvxTtdNV2glAwZmvmbskfKVTjMk5J4isPOiQavD8r30tonFCNSva5ZkZ8XSYUQjB1jhH2y6fZS0z39Q3fA0+/KTjyM6wCg05kvKBRUBLkLBkSZwFUCmLoOZLmjrsmOryBNccoJPZl07hZatlyVRPqHgnJqt+tkVC6TPNKVtjSMTiIhGy0AvjlwVXXmpcp6NN+5LaHV9qTRChbXoTguDqQ4Z5u+kxpGIpeC/6hrtuo/+3cJb+gsQubJMb+k1kCD3RG165lujDrEsEPM2wE7nzuKw8Ak2KEAi9E3fboho8HFLNnATGKqkORPkzNt1dM9pODjL69LAipmM0Xwowuc5STcXBZrd/6tJzqOfphN6CxJqOw2qJ+cQHqrFNsbyazTszZXfTMGHWsGJY/PpVSckMVzwpzlPLXzmQjsSgEfxg9uZXLLxHOZfL4kjRe6q2Mv3oICcKLlmJmeNGJYDKlOFlq0etxh8LaawXrybr9DEJk0ybTVMBUZ+FUllLOGuMUSx2BjpyxRBEBVk/yXYjLbwJdX7uLqE2bCFynxzOES1DNZ+k3RA2agrv8OFieNywUbp3qi95d4Lxtl2XVpjkY7uuh2BiaU7vMhGIEEihAc4ZnBqrRBFmqBsLTDrufU8sH6agGWWH0VDSAk+NiqntATxg4atUFltSNOzhRH0KZekDKA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(26005)(9686003)(508600001)(4326008)(83380400001)(66946007)(64756008)(66476007)(66556008)(66446008)(76116006)(38070700005)(4744005)(38100700002)(6506007)(33656002)(7696005)(52536014)(86362001)(5660300002)(110136005)(966005)(82960400001)(186003)(8936002)(71200400001)(2906002)(316002)(54906003)(55016003)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjNpMExwY2E4L1VnVTBpL3AzVGFLVEJuK0E2b3BCek03N2I2RC8waG1tZXlT?=
 =?utf-8?B?N3RtekFLc2V6R21zWkpiYjZiSFpDdTRaZVJuZTFpVXV5QkM3czBXQkVSaUEz?=
 =?utf-8?B?Z3FXMEJ2OTk2RWhNczZuakZabTRUeVFCZHpJcUdBbHN6UU5TSDNGeFZrdFVC?=
 =?utf-8?B?cEF1dEZFTEFWTXpYQkZIdDY2OGc2ek0yalVmMFBsY3JvUjRDZWlMTmUrZzk2?=
 =?utf-8?B?N0Zid0NrYW9lWGJMYXVST1BXRGp3Mm45UHB3TjVnc3YyZVpLcEc0cHR5NGlr?=
 =?utf-8?B?ZU1WTTdlZ1diUUJtT2RMZnI4WFJYY1F6eDVhY2VkcHVNVFp0VlNhZnh3aGVr?=
 =?utf-8?B?WWYrRGNxSG5qRmtJcTBOcDQzaksxTG9WV2NLTm1KdGNRZm1yUzhBaEE4WlEz?=
 =?utf-8?B?Vm1QRVpEazNyV2ovc3RxK2hqcnBqUnd4eHhaQXJiaTRRVzVLSjNJTUVWUVE0?=
 =?utf-8?B?ajVubHZyODVqV01aYmVRV1ZLKzByM013QmFuYkE4a0lxSmIzY0RrcEg1UlV5?=
 =?utf-8?B?ZEF5bGkyQ2Y1cWYwQVB6Qll4eW9xcXYwWnZFcFoxNFdSSkdmbmpMRHg5eC9l?=
 =?utf-8?B?dVI4RE5HK2xBVnRXYlYyL0FvTlNNV2EzSXNXS1FxR05Sc2R2S2hVckkrMkQv?=
 =?utf-8?B?UTdmeU1MNTJKdElVY1gxS2U5SVdneXIwUHZHclU3aGduek83Sk8yblpZOEFW?=
 =?utf-8?B?WVRtek8rS3hJODh4N2dGQ1NaVU1JTUwvSjRDQ1FPNEVSK3lUbmJpNkFmbmN2?=
 =?utf-8?B?WXEzbnVLb0hiTnhXQ3JUZkllcEZNdHlFRVlobjlGa3ZBbmJNdzZyRHB1Y1da?=
 =?utf-8?B?a0RmaDdBN0IyM2RPblRlc3pSUktTbFVudUZCZFo4dHhqS0FBZGZ3elNBNTBJ?=
 =?utf-8?B?OFQvSFBOc2JudTFVSTVBS3N0NFlSakxGcTRub1ZyeWpwQVptZHZtTnVGVm1G?=
 =?utf-8?B?bU91QnlHYkJJNHpoUE45cEZ5US94aThzbkFNR2pPakt5aHZ0RVN4R1REK2Rx?=
 =?utf-8?B?RUtnaFlVY2NFeXd1NEY4REZZdHVPZ09ESHIyMm9oZ3JOaFNQZ3hhSWdHYWhG?=
 =?utf-8?B?Q3VKUWFRQ051VjdJd3Q1V1dJbjhkQWI1QVRIQXZ0T2dzc1ZHL0Zsbi9GSmpD?=
 =?utf-8?B?TUdaQk5taHFOQzM4ZEdvdG1UNFhsZlBxT3JwZmxaQXkzSkswajNBN1ExL3hz?=
 =?utf-8?B?SGNBd20rZU8reFJrSkdCZU0rN3NobXN0NC9yVEhsMk1rVlBjTlBaYW1adEhI?=
 =?utf-8?B?Ly9qcTl6OW4wWkpaSVJ3YklWczFqeFJlYmRkektHZkpydU9iMnZBRlpjR3JL?=
 =?utf-8?B?aTIwdWtzdGo1M3czcXo1Q1FmN1l1eWdBaWNWcmdobzNWQjdMR012QS93bE9X?=
 =?utf-8?B?bW1hN0JxWXNOc2VqVmprVFBtdldKWm5HWVd1T3d6YWFTbUQ2WnV5NW52VGdu?=
 =?utf-8?B?WGphWUtFb1U4WGZHRUFXdFdFM1dwWHpaam1tYXZtYklhZXJ4OUpnS2FzTi9a?=
 =?utf-8?B?aEFSQXZtenZ0TkxoOEYyWmNTc01IU1NVNy8zVktZczJZZzl4T21HNWRIc2xy?=
 =?utf-8?B?VDkrc2k2Q0M2cTRPZ1pQSDJPZzVVNWxPWThpYXhCNy9vVlpHVi9WNEsrTS9B?=
 =?utf-8?B?RmF2UVFkdlJHZlZ0bGsxdzZRL2hXWmNrT2d3WTlPR1g2aXRTajBLQkNrTFlG?=
 =?utf-8?B?N2VVeUVkMkt5QTRyT3NwTmlKOEJMV1FpZnF1OVk5dS9yaVByZEV5cmdIZEgz?=
 =?utf-8?B?Y05rcWY0aDNkelBtMVlFL2lzVjU5V2svTWppZnVxNTByUUZ2UnhxTDB6czdn?=
 =?utf-8?B?WWw2WHEzTDM2YTc3SzZMdDhpcDA3UnZscnd3cy8wVFBFSjB1V3VWdkYrdWUv?=
 =?utf-8?B?eVhCM0Fkdy9NUlF6ZDJyUDYvaGQwL21ScHJOQUR4em5wQktRL1RMYXJOcFUr?=
 =?utf-8?B?NzhGa2Nicmd5cXNiYjc1a3kxR0VMNFRrMnBpbngzVUJHWEZNaUF2WFM1VjUz?=
 =?utf-8?B?REI0Q2cvcGpNdUxBMi84MkNDV0NXZjBrSzRRSGI3dTMxdEc5R0pQY3hqL2Fz?=
 =?utf-8?B?bDFTUWhzMjdZUFV3aHNFMlpuaWZDckVRTE0wQTlQbkM1U0tFS0d1N3c1VCt5?=
 =?utf-8?B?WkR0RTNoVGNUZjYrcWR6SHgwTnpEVVJyS2ZadzZQVS9xMnlUaWNrQmlldDVz?=
 =?utf-8?Q?alHD4fKfCdaiB2oP91TGIlM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723834a4-2b9f-4f51-9250-08d9bece144b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 06:50:56.1757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yn7zAkusWler3+pOXBwf0UBUMULEVkSgKWS7wL10icB+VgqXzmWmoKQCtAbU1WS18tkIP9SQY3nml7YoI/bvMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3857
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBGcm9tOiBUaG9tYXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT4NCj4gU2VudDogVHVl
c2RheSwgRGVjZW1iZXIgMTQsIDIwMjEgMTA6NTAgQU0NCj4gDQo+IEZvbGtzLA0KPiANCj4gdGhp
cyBpcyBhIGZvbGxvdyB1cCB0byB0aGUgaW5pdGlhbCBza2V0Y2ggb2YgcGF0Y2hlcyB3aGljaCBn
b3QgcGlja2VkIHVwIGJ5DQo+IEppbmcgYW5kIGhhdmUgYmVlbiBwb3N0ZWQgaW4gY29tYmluYXRp
b24gd2l0aCB0aGUgS1ZNIHBhcnRzOg0KPiANCj4gICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
ci8yMDIxMTIwODAwMDM1OS4yODUzMjU3LTEtDQo+IHlhbmcuemhvbmdAaW50ZWwuY29tDQo+IA0K
PiBUaGlzIHVwZGF0ZSBpcyBvbmx5IHRvdWNoaW5nIHRoZSB4ODYvZnB1IGNvZGUgYW5kIG5vdCBj
aGFuZ2luZyBhbnl0aGluZyBvbg0KPiB0aGUgS1ZNIHNpZGUuDQo+IA0KPiAgICAgQklHIEZBVCBX
QVJOSU5HOiBUaGlzIGlzIGNvbXBpbGUgdGVzdGVkIG9ubHkhDQo+IA0KPiBJbiBjb3Vyc2Ugb2Yg
dGhlIGRpY3N1c3Npb24gb2YgdGhlIGFib3ZlIHBhdGNoc2V0IGl0IHR1cm5lZCBvdXQgdGhhdCB0
aGVyZQ0KPiBhcmUgYSBmZXcgY29uY2VwdHVhbCBpc3N1ZXMgdnMuIGhhcmR3YXJlIGFuZCBzb2Z0
d2FyZSBzdGF0ZSBhbmQgYWxzbw0KPiB2cy4gZ3Vlc3QgcmVzdG9yZS4NCg0KT3ZlcmFsbCB0aGlz
IGlzIGRlZmluaXRlbHkgYSBnb29kIG1vdmUgYW5kIGFsc28gaGVscCBzaW1wbGlmeSB0aGUNCktW
TSBzaWRlIGxvZ2ljLiDwn5iKDQoNClRoYW5rcw0KS2V2aW4NCg==
