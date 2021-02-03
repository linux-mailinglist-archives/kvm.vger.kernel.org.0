Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363ED30E2C6
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 19:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhBCSrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 13:47:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:4700 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhBCSrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 13:47:52 -0500
IronPort-SDR: /f5tW5qJ+VOuGtfHAVyi8tyMiuchYFY17oBJ1mFxs79UzM9g88azVndMEyGtSShri3rdMrWo4g
 YNep9LIIIB1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9884"; a="168204748"
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="168204748"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 10:47:09 -0800
IronPort-SDR: re6HrahFHDYKZXm9xZ4Khmo07QMwdCRxVzpnOO13NMXzjeGicI6G4Ua2DbM0dT3YcFAvjgVAl4
 FUvuQzWXAerA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,399,1602572400"; 
   d="scan'208";a="371585594"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 03 Feb 2021 10:47:09 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 10:47:09 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 10:47:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 10:47:08 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 10:47:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVuOdVdooPWoaZGb24ZwG/bkjYIHAJoU2kEFsqopKxxBwuzZW0Urp+5mxlO44QxP/bmGsb3T+/dmSsUApXJE3aaxtYepdPAJ3oxHCT7U2OYsdQLDKgF5/2cLi662L4vmRlpSgn8Ia1mANrQ8EkXtuFHAQFW6/l1CX9kt3Sr4ipeEwOixLmwTEY/9xX/MXQG5hpJ5oU/HcZiKoXm5Y7enAUgv3i54WKxpZDBXVMiVsP1Z4qDdQJP0VuDaqj/nkz8kHjb4NVyQnvjKmj/O4BJcIiMjjXBOIj2uHdK3qkZwqKACBhV2r3muXk9eRAtEqrJrswsdAmLtGmhFd0O4xiSoSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPT3K6iH4DiWOz2yip8iK4BeT1Ohglexa9dfwW1p2M4=;
 b=GTCMbMAgvaKCEahdCFp8ho5rsQFEzUgKxzkF2u4fSzi0ZLoplyTrY0s+echyzbYjQ2Z2uzbsAv4WPAZFAo8PkfGRPdZ1M71tdm0RsXUeqtWdBsB7Lhm54c3lufJaPmMVeogTUcJvA/ZNOZtro+SxJfcb1AZOwO6rCIwchuWjaZuYsDr8e7/F4umQG1y0jgYiUmZNH94ZmNADF6nVot8ait4j6o/NwBIXyrzN0kx1GuuiqUNPfygW6PXJLposPCwMt2i4xWa1xacPX80GGgu1WX6xqJIKXPOWU2/87dSzQcVAOSkBD9rcHEdVXqzpjAFPyQzcjdecogK41+lJWaebwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPT3K6iH4DiWOz2yip8iK4BeT1Ohglexa9dfwW1p2M4=;
 b=ht6mPyj4ps76ducOVoO/7iXvKmro7oMhHPRWNIyAwJkdhEUQdzn30p5jgjf5rbe0JoiSgrowKPDUj2GqH7ByOLFjn18AICQIkPw5U+9EEWC27Tbw3PIwqeprjzT4TWEjHKeWW6VL3/cbqK3Tvr32mJrgoiSj8vEKS+kHvsgvOXg=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA2PR11MB4859.namprd11.prod.outlook.com (2603:10b6:806:f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 3 Feb
 2021 18:47:06 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4%7]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 18:47:06 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Huang, Haitao" <haitao.huang@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>
Subject: Re: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Thread-Topic: [RFC PATCH v3 23/27] KVM: VMX: Add SGX ENCLS[ECREATE] handler to
 enforce CPUID restrictions
Thread-Index: AQHW8/Op5IGDUFdnGEG+JZD4BWOmBKpG0geA
Date:   Wed, 3 Feb 2021 18:47:06 +0000
Message-ID: <c235e9ca6fae38ae3a6828218cb1a68f2a0c3912.camel@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
         <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
In-Reply-To: <d68c01baed78f859ac5fce4519646fc8a356c77d.1611634586.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3 (3.38.3-1.fc33) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.137.77]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 058772a5-d2a1-477b-6691-08d8c8741afd
x-ms-traffictypediagnostic: SA2PR11MB4859:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB485918988DC4B4500A347614C9B49@SA2PR11MB4859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ESwa88y/3zW3lNHHXjLuOtYRbTE8qlWHTLrLmh1qY4IwuUrlhgu2WRH6vq9Kcn5tLD9/8HJlUR9TPWGrD/f7Mj170YbkXDlzv8VPXVcvVl69+YxSOvsyi0hbNJR1Y33mXvn8akTZn09gJrBxC8F/4XFcd9yRNFumscQyp6xh14XqvS6LLw/dB6Aoyo/NKzp7URCJueGZGdCc91OZRuwNdwisNKfSSKyprjWOpRMfYOHiQSR3Kl2QC+EAWaM8+5GG3srjIm3/8e1RN0cAUNBH+aH5jb6Y8jbGND+I1CiUo2/wCktYyAohXMrJCxfWj2EbxJ20EokvinwjGCy6SdCCKGT+IPp2l7+iOip4WpzvTUiVlugWodh24+/nqEGG5vui9MNOSebibGElCC5MCMCRNpuklk2SZSwFJxCD8cLxqUFZkI/hcws5eFfauqpOUssOpAeWMAgenGBA46bpaH2Ak+zCoVsL7B7col6FFNo1LQ6zLlJe73An60dxzi0CUVTbtiAxhF5nV7ux1lse1SfeZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(39860400002)(396003)(136003)(71200400001)(6506007)(36756003)(110136005)(54906003)(2906002)(6512007)(8936002)(316002)(83380400001)(66556008)(76116006)(2616005)(5660300002)(6486002)(4326008)(64756008)(91956017)(66946007)(66476007)(8676002)(186003)(26005)(478600001)(66446008)(86362001)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M1BuaWhZZm02NVdGcVAyQUtJKzI1M1N4ZWhxSGh1djZtc0RkS2lZU1k3Wjcy?=
 =?utf-8?B?NnhiQklFMXdtMmFFRzNiVEMyWFkzRVo1YW1KRHpTV3dGeFZlUEcxcm1FL1ds?=
 =?utf-8?B?QlkzTnlNaWpnaFh1VkFzNHRYckZyL1d2Yzl6cm1qNnB6bDdMMlhJYmV1aXBG?=
 =?utf-8?B?aEl6WVF3QmFuaE5iRnpIaFpYY2E0NW05K1JwZWtyQlkrNHFWV0lOM1ZYYmRn?=
 =?utf-8?B?Z1Z1M084RHcwR3lVa0pCbjlneWF4WlNUbnlCc3lFK0EwQlpZSHhNSk5KZXVU?=
 =?utf-8?B?aVp6WTdOWFZyVFFYdUFqSktaRTN6NDdsZithMkF1MTYwSzZ6NnBiVTJNM1Ev?=
 =?utf-8?B?Tm5OYTBsb0VZblNLbGdTeTFpVStsc3Nudm5IdnhlUCtCcTlvbm1BMFJ5amR6?=
 =?utf-8?B?Z29VcWN6UW8zTERpdFhJRTNlZ1V5dXVaVzAwWFhIRVBUN1ZNbXJ6a2F2R1JW?=
 =?utf-8?B?c1FWb3FrQjNKMUlHSi9WWXFCU0FzQkltMnlCaXVEazZOc09GWHRUeUsvSlFC?=
 =?utf-8?B?aW1vcUxXYVZoazRDM3V5SDFaVXRvODBLQkV2RkhWZGkzakc2QUozbTJ1QjVs?=
 =?utf-8?B?SCt4bHlQdHRmK3JkSWdwK0szU0R6RU5RSkRoRFEvZUhiMU1wd3JZRUQ0OWVv?=
 =?utf-8?B?RHE1V3d4RkJYcXd6aFRiN3RqeFJsUnpYWDlMQXphaXZKc2dyVTB5TTBRdjR4?=
 =?utf-8?B?aTNRVWFYYVA4NHZYTVIrYjh5R280dWh0d2Y5VzJBRE5XN1NkVHJxYkkvZ3Z3?=
 =?utf-8?B?SmJ4Nml5cTViWWF6VmJjbCtDRlFvYkFFT05zQkcySmUvL2dWLzhMVnJHblNP?=
 =?utf-8?B?UVFRL1R4dUN3TUN5bEMwVXV0QXlaYVlEUjc4WWFRRTV6VVpod0duMFdIV2pk?=
 =?utf-8?B?enQ0TjBTa2F0ckh1M0pkWk1SU1hUU1ZSWTF0OXVsaEZGbnk0aFVqdnpRN0E2?=
 =?utf-8?B?M0pEdjJocGR5andYNC9jWi9VYlZzdnFYTjlHL1h0eGIzR29TMWhDK3JVRi9O?=
 =?utf-8?B?eG9BMFBGVzdMTFVJakJpK3I3Tk44TzRCa09RWGd0MGxhRUlDR3l1cGN0K1Qy?=
 =?utf-8?B?R1QrYjdnS1U3d0JvdU9OZFMwWGZ5OXg1dTBQNDIwT1J5Wk1kdUxmdXNTQVZX?=
 =?utf-8?B?OWdKRzZ3VGZtUHdvbzJ1VU9EN043c1BFQzM0WURDK3FPRjhpYkJKeE1MRXh5?=
 =?utf-8?B?cUQ2L3Z6YnJDWEJWamtDbXoreDJrU0xjNFM0NVlpbytRdDdaelVqRWcwaHZi?=
 =?utf-8?B?Nmc4cmJZL1cyek9HV05yeHZxSnp2S21CRmR2TjM1azl1bERBaXFMLzRvV1pr?=
 =?utf-8?B?ekZ4SzJxNVM4ZDZhWHZwR2loZHk0dVFwcWZaajRZci9CbW8xcThWNnBWei9r?=
 =?utf-8?B?aDlwanpCemRCTmhTN0hidjNlYVVCdFNxOFFWK1VMbWxvU1VFSEcyaHdvSVVp?=
 =?utf-8?B?Q29OZWIycU9xT1daYXVLamhKRmQ5TkFidE40TmVwekphMlhPMGJJeU96ajB0?=
 =?utf-8?B?YU1NUW1rc0dNYmJPZVQyTFBBc3R6WHR4RmpsQ21WVjhSdUpBWDFjQXJLL0pV?=
 =?utf-8?B?WnFva3JEbU9QN2E1MmRkdXJYTWZXUkE2bGx2US96TWovU25nYkI3ME9aWEF3?=
 =?utf-8?B?TktLS2hmNUhzaW0zUTVhczZhcWRlQzMvVnFNS2FLL2JlNHdjejZQUXhobDBU?=
 =?utf-8?B?UzBBRDc1QzJYL2d3Z1ZqOE5GOFNOWWtWN3pVOE1YMTRQeFFtSGREUDF5K0Zr?=
 =?utf-8?B?VmdudlBXK0tHa0NHbEdtejloQnZSMDJEcXNsbGQ2VVorTnJFNVM4TlpaeG1l?=
 =?utf-8?B?bjFuWmlyWWlET1pCcHd0Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A06A1C79082F804B994C2C97A1DCC5DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 058772a5-d2a1-477b-6691-08d8c8741afd
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 18:47:06.6471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gGYwGDjz+5F3KmmRbEpdqLMNyBMSwYpe6vtgpWCZztEU6KZSufNAZtwFG/bmDarL7jgEEZ9pCPFTlOwcKEaLdjILB/nOIiyayzEFAy04yQA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4859
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTI2IGF0IDIyOjMxICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ICvC
oMKgwqDCoMKgwqDCoC8qIEV4aXQgdG8gdXNlcnNwYWNlIGlmIGNvcHlpbmcgZnJvbSBhIGhvc3Qg
dXNlcnNwYWNlIGFkZHJlc3MNCj4gZmFpbHMuICovDQo+ICvCoMKgwqDCoMKgwqDCoGlmIChzZ3hf
cmVhZF9odmEodmNwdSwgbV9odmEsICZtaXNjc2VsZWN0LA0KPiBzaXplb2YobWlzY3NlbGVjdCkp
IHx8DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZ3hfcmVhZF9odmEodmNwdSwgYV9odmEsICZh
dHRyaWJ1dGVzLA0KPiBzaXplb2YoYXR0cmlidXRlcykpIHx8DQo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoCBzZ3hfcmVhZF9odmEodmNwdSwgeF9odmEsICZ4ZnJtLCBzaXplb2YoeGZybSkpIHx8DQo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCBzZ3hfcmVhZF9odmEodmNwdSwgc19odmEsICZzaXplLCBz
aXplb2Yoc2l6ZSkpKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7
DQo+ICsNCj4gK8KgwqDCoMKgwqDCoMKgLyogRW5mb3JjZSByZXN0cmljdGlvbiBvZiBhY2Nlc3Mg
dG8gdGhlIFBST1ZJU0lPTktFWS4gKi8NCj4gK8KgwqDCoMKgwqDCoMKgaWYgKCF2Y3B1LT5rdm0t
PmFyY2guc2d4X3Byb3Zpc2lvbmluZ19hbGxvd2VkICYmDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oCAoYXR0cmlidXRlcyAmIFNHWF9BVFRSX1BST1ZJU0lPTktFWSkpIHsNCj4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoGlmIChzZ3hfMTJfMS0+ZWF4ICYgU0dYX0FUVFJfUFJPVklTSU9O
S0VZKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBy
X3dhcm5fb25jZSgiS1ZNOiBTR1ggUFJPVklTSU9OS0VZDQo+IGFkdmVydGlzZWQgYnV0IG5vdCBh
bGxvd2VkXG4iKTsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9pbmplY3Rf
Z3AodmNwdSwgMCk7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMTsN
Cj4gK8KgwqDCoMKgwqDCoMKgfQ0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoC8qIEVuZm9yY2UgQ1BV
SUQgcmVzdHJpY3Rpb25zIG9uIE1JU0NTRUxFQ1QsIEFUVFJJQlVURVMgYW5kDQo+IFhGUk0uICov
DQo+ICvCoMKgwqDCoMKgwqDCoGlmICgodTMyKW1pc2NzZWxlY3QgJiB+c2d4XzEyXzAtPmVieCB8
fA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgKHUzMilhdHRyaWJ1dGVzICYgfnNneF8xMl8xLT5l
YXggfHwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICh1MzIpKGF0dHJpYnV0ZXMgPj4gMzIpICYg
fnNneF8xMl8xLT5lYnggfHwNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgICh1MzIpeGZybSAmIH5z
Z3hfMTJfMS0+ZWN4IHx8DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCAodTMyKSh4ZnJtID4+IDMy
KSAmIH5zZ3hfMTJfMS0+ZWR4KSB7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBr
dm1faW5qZWN0X2dwKHZjcHUsIDApOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
cmV0dXJuIDE7DQo+ICvCoMKgwqDCoMKgwqDCoH0NCg0KRG9uJ3QgeW91IG5lZWQgdG8gZGVlcCBj
b3B5IHRoZSBwYWdlaW5mby5jb250ZW50cyBzdHJ1Y3QgYXMgd2VsbD8NCk90aGVyd2lzZSB0aGUg
Z3Vlc3QgY291bGQgY2hhbmdlIHRoZXNlIGFmdGVyIHRoZXkgd2VyZSBjaGVja2VkLg0KDQpCdXQg
aXQgc2VlbXMgaXQgaXMgY2hlY2tlZCBieSB0aGUgSFcgYW5kIHNvbWV0aGluZyBpcyBjYXVnaHQg
dGhhdCB3b3VsZA0KaW5qZWN0IGEgR1AgYW55d2F5PyBDYW4geW91IGVsYWJvcmF0ZSBvbiB0aGUg
aW1wb3J0YW5jZSBvZiB0aGVzZQ0KY2hlY2tzPw0KDQo=
