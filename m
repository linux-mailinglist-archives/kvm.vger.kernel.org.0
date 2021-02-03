Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A521330D084
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 01:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBCAxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 19:53:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:44810 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhBCAxA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 19:53:00 -0500
IronPort-SDR: VAONEE9BYi7MM5qP+0NjJiltRm8NnBZjEjDidgT31oVmq1U2kdsQoFeVCnDyP2+7coCAmMVcw6
 NKrS8DavkpZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265792423"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="265792423"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:52:16 -0800
IronPort-SDR: KXUABoXppr4uVceP1HViYoEHd4cYcsM6knj3vvySB+HIXvAfXk1sCTRPOKEEF6L5awN7tUw6Cg
 SjawcFUPmMwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="507555560"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 02 Feb 2021 16:52:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 16:52:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Feb 2021 16:52:14 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 2 Feb 2021 16:52:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxvaFK7IBiLV2y5rXqWjqA3BKgCk9LLp8aVShkr8KOGw+ryiWn92znhAxNom7ZCWIl21xyh+h5cxZSA5gU2vOjaLR/2rLqi93SvSJYxJde+SN8K2HsaZ7Gpff6jyONTwr2RJBIS6STNNW9lzoQjj+E72F/EXmIAmZus8p9xY4AcS/2IBsQ3kppQJ10OkIq4SnFUyKqtxrHlHRmclI3D4cM3CR3UB0Mmdfb9k9Z9710kd27sIJAVhA/lBovwF8wlS+A3HvvGhRHM0KYlkZbPPM9WFBD6YAsW92StQuoe9gkwm6zbgp4YQ6OOaxOPs2NN+3nVzgE5V6t+muWLSRjW3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8ifzUhNjP4minsgtS1cnsFrxR7zrnmRvXClBxrNSfY=;
 b=VUm9UXuFkfRncTF4kmRzKTJJtiIayPPBlbRASs4uHwSfPfij4bZpNtKPC7mcYoYQKtceDXjBG1g/01k6nFC0PVwo6yBkV6lsnFZ3uZFUPMk2c5wXN0nNq0ifWb0bbj3MlFQA4wmKwLKDqIHDFxofd0mFGMPJ4Pozu6hnSuEk1+VRiqNLtgWpBIPJLeVhkomr/52vgtbGYffrSrk0V/pHatT3XzUaYglt5SFy1p8e0A+2oFsvG5M6xbSEys4U7Q4nSNlYwxgfBYB7FA2tMWYVsV/+ntg+hSwzc8J982XfkWa1TeB7juCd+2tyo5w6NNPuBl25dTFlotq6jkY5qbvXag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8ifzUhNjP4minsgtS1cnsFrxR7zrnmRvXClBxrNSfY=;
 b=asXHj+Fl4gJo1k9iIV2RVgZi0CQMaNS/+O6wIbERAySBBJpAlI9zceUnSaml12gzmVmwbGdoGJj+1P+MdRLFhyk93VHIbMVcKADB1rGWdnl2sGkaNBeXeSNc6/s25If1maN3W8p2mKotqgwPIDEnwwNnHkfum98ZzY1evRYHyNA=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB2926.namprd11.prod.outlook.com (2603:10b6:805:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 00:52:02 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4%7]) with mapi id 15.20.3805.028; Wed, 3 Feb 2021
 00:52:02 +0000
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
Thread-Index: AQHW8/Op5IGDUFdnGEG+JZD4BWOmBKpFpaiA
Date:   Wed, 3 Feb 2021 00:52:01 +0000
Message-ID: <f60226157935d2bbc20958e6eae7c3532b72f7a3.camel@intel.com>
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
x-originating-ip: [134.134.139.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 435ecb7e-7621-4903-cdff-08d8c7ddeb3f
x-ms-traffictypediagnostic: SN6PR11MB2926:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB292608E483F089C8FC327B23C9B49@SN6PR11MB2926.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P+UBDa4umALGHC6iYh0u+NX0a6yeypgHQZiBINbAl8IAHlsywXMCO5NLFT3YMqOt6UDfUUIH5cZ5giDzZQec8s8lSgWxxyAtP2r/fWQ7SSKnp9Hdm7i4GNpoznAzfnW65kbWv0BB2LG99IhPkCLw+Yj6CJ+09FG7X3lF6fjOXrSIgayACjmensZ4SIC07QvKw85+v65EGRpOTATsYOFiyn3b+tXOy4/ovWDHmV+7zlVldidWn6dj1Y9Q//4fKN3EiaejlHzUJ83Z3onblr5vef0KFWQV7KwbEWmlLHAKvW7PibhujgIPXJMTGgHL9kxFoYpyqje50S1OsAAq+Rkk1DUu5hKpVGxG0mdFSgvKmwlMRbEO/vgkCuJO1eqlf3nroXPs1XFUUpLEDGKhxQkuPwsMW6WU4L6MWbZ082Dwm+lX2jpW+YB1wyfQvMR7WgXf8w/u7jlGY87U+0bX9topXDItarIcuJYyXOfj2Mv8NdE5265F0e5w7H/JmWHqZXs6Bivb5gtPsSPvjKYL+iwN4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(8676002)(91956017)(6512007)(71200400001)(54906003)(6506007)(6486002)(478600001)(7416002)(83380400001)(110136005)(8936002)(36756003)(186003)(26005)(64756008)(76116006)(66556008)(2906002)(66476007)(66446008)(4326008)(2616005)(5660300002)(86362001)(66946007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VmNSaDRlN3BqN3FiTGEvTnBub1B4czBjQUJjUFJnWVlFd09aRkI4b3AyK3Fj?=
 =?utf-8?B?SnpVWEdGR1dFTzZmNDd6SVhIeVVHVkJpWkp5TXBKMzU3UExqbWhvdDgwVXgy?=
 =?utf-8?B?djZPbXpZUWhraFNQVmhhNE9EelBnUmZ3VmhYR1h2RGxmYmlEVlJML3c1UERT?=
 =?utf-8?B?Qis4Mm1PTnRnUlJhUE5tZzN6SGlIQnFISWhaVE9kUEpuR05xN1ZYTHo2MGtH?=
 =?utf-8?B?OGFlOUVRN0dSZ3pJZlFCMXRpaUExeU81NFZVTFlHdkV0bVZ0Q2NKZnJja1Bq?=
 =?utf-8?B?Z3ZFQjNwWmlmNWZ6UlY3ckZCNWsvRHBEY3VybkdZVmxPL041djFaNnNVVTZr?=
 =?utf-8?B?c1M3UURZTm5jNTJudmZjRUJET0JqU2RQQ0xFcEVXaWJ3Z2pVM0E0MGNsbUl0?=
 =?utf-8?B?cE51NmNkenB6MHVMQzFZamhOUGc3M2tMNEVHQkx6aURqR1dnYWtsY0RWUWE5?=
 =?utf-8?B?bU51aUJwZnNabTVsTXRTeWFUYW5wWElnR1dXaGo2d2szaWJMQm10ek9OMlFK?=
 =?utf-8?B?eStzbmhpb214NTRJYUYzRHU2WXdyNVh3NGdmSWhYSjdVMlhzUHBpcVdzQ2d1?=
 =?utf-8?B?dlgwbDkrM2FHaE5pRnhVQ0lMWGVpN2gvSTF5TTlIWEdpRzBMVnpYUEtvUEJM?=
 =?utf-8?B?eEFXMEpFdDJCbVhsYjJVSno2V01WZ1BvaUZYem5ZQ0d4MHB1Rjl5SWw1b2Zn?=
 =?utf-8?B?NFhPdUlVeWx4QUcrZ2U0OTFBbEdWM1VLVW8wSTdwU0IwUUxjU041VFlhS3dj?=
 =?utf-8?B?R1dXSjczSnVvdS9SalpJWnliaGNYWENwZWpiNXRsS05XTllRV1hMOWwwTFhl?=
 =?utf-8?B?UWhIQVNRS3R4VWNrRzBGOFcrT3N4WG4xTVFhcjNabjRFYm1DNXhyOEpZMWxY?=
 =?utf-8?B?M2NtTmsxTUxhM3dSd1ZqNkRGL3hKc1V0eGx0OU16WVFxaDZvMHNqbTBiV0Vz?=
 =?utf-8?B?RUNrTXgvNFVGcWFNTUlETnRBbDUzSlY0Uy9GcWVnMXB2dnhWQkFydTJNUUFi?=
 =?utf-8?B?aHVBbkY5VGhENXFGSDBueVdVUDVvUURmWWhrSjA2UmFxQlJPOE5wWEU0ZUc2?=
 =?utf-8?B?M3VrZmRaVWJGZ1Q2QTFJU1BiQlJ0MkxQUGwvWGJIbTBiekR4aE9yRWNpakZL?=
 =?utf-8?B?cVBxVEpnS2IwWkRuamZPYW5CYmdOOG1MV0tJekVBMTBSVmltdUVIMVNrWHBE?=
 =?utf-8?B?bGFQVXV5eWtXakNueTU5dkdHUENkTWQwNTUyV2JMazhOdGlyZUFZcDd3YmRx?=
 =?utf-8?B?TE1vTWErMGJuRDc1cmhiV1ljZE5xQXVpRzRsdzYzY2JVeXZkV3JYU2JVbjZG?=
 =?utf-8?B?bXc1NjdVdTVKTmNDNWNLRzNKcm5lY1FVWk1ybElMdlN6am8yNTZORGJGcTlR?=
 =?utf-8?B?Y05hUkhaSkNVREREQ0V5TlZ0SEdJQk4vOVJmTnVJeU04SlRVUS9WWlhLa3dT?=
 =?utf-8?B?MlZ3eVdmRlR6YnhreGlFVWVhaDl3V2FpRFhKUzl0dCtIdnpibTNTN2M3SjhO?=
 =?utf-8?B?OSs4ZUpvUE9kUTlTSE1JVys4T012MEdrOC9wSkpJd3orS3U5cG0rOFNXRGFV?=
 =?utf-8?B?czlMTzAvdWNBdzJaTFprYnVvR3FOTGRWSm5LWjZNWERBaUtqZkZOcjFPRU9H?=
 =?utf-8?B?Ui9TQnhrcDltS2pxRWlLdk0xV29hMzlxVkg2ZHdlU09FOTAwQWFyYnFLNFMx?=
 =?utf-8?B?ZndtYXBDczgyZ3hZRWVqbXk2eVV6dVNmVUpsYzJzMnNKZDVGL0FObHhoY0ZC?=
 =?utf-8?B?dTMrWDAvWHl4NW85NVl6ZUFNSFdmTVhEZWx3WjZ5ZjUrR1ducnVjMGVOa0xF?=
 =?utf-8?B?UnlyUDN5UE1ZS1NmYnA0dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <456BAE188870F54F831C0E6015FC068D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435ecb7e-7621-4903-cdff-08d8c7ddeb3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 00:52:01.9503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNs7veH+gRvZeDQc3dxK7uFd/IbBtT5iHoYBFAar5VDcML4QK9JRAigD+1Tv/GVozhCgRoAC+9yjCFoCr4b8iDU4B3Eo/g8MSnBfWHfuv8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2926
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTI2IGF0IDIyOjMxICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+ICtz
dGF0aWMgaW50IGhhbmRsZV9lbmNsc19lY3JlYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4g
K3sNCj4gK8KgwqDCoMKgwqDCoMKgdW5zaWduZWQgbG9uZyBhX2h2YSwgbV9odmEsIHhfaHZhLCBz
X2h2YSwgc2Vjc19odmE7DQo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBrdm1fY3B1aWRfZW50cnky
ICpzZ3hfMTJfMCwgKnNneF8xMl8xOw0KPiArwqDCoMKgwqDCoMKgwqBncGFfdCBtZXRhZGF0YV9n
cGEsIGNvbnRlbnRzX2dwYSwgc2Vjc19ncGE7DQo+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBzZ3hf
cGFnZWluZm8gcGFnZWluZm87DQo+ICvCoMKgwqDCoMKgwqDCoGd2YV90IHBhZ2VpbmZvX2d2YSwg
c2Vjc19ndmE7DQo+ICvCoMKgwqDCoMKgwqDCoHU2NCBhdHRyaWJ1dGVzLCB4ZnJtLCBzaXplOw0K
PiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgeDg2X2V4Y2VwdGlvbiBleDsNCj4gK8KgwqDCoMKgwqDC
oMKgdTggbWF4X3NpemVfbG9nMjsNCj4gK8KgwqDCoMKgwqDCoMKgdTMyIG1pc2NzZWxlY3Q7DQo+
ICvCoMKgwqDCoMKgwqDCoGludCB0cmFwbnIsIHI7DQo+ICsNCj4gK8KgwqDCoMKgwqDCoMKgc2d4
XzEyXzAgPSBrdm1fZmluZF9jcHVpZF9lbnRyeSh2Y3B1LCAweDEyLCAwKTsNCj4gK8KgwqDCoMKg
wqDCoMKgc2d4XzEyXzEgPSBrdm1fZmluZF9jcHVpZF9lbnRyeSh2Y3B1LCAweDEyLCAxKTsNCj4g
K8KgwqDCoMKgwqDCoMKgaWYgKCFzZ3hfMTJfMCB8fCAhc2d4XzEyXzEpIHsNCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9pbmplY3RfZ3AodmNwdSwgMCk7DQo+ICvCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMTsNCj4gK8KgwqDCoMKgwqDCoMKgfQ0KPiAr
DQo+ICvCoMKgwqDCoMKgwqDCoGlmIChzZ3hfZ2V0X2VuY2xzX2d2YSh2Y3B1LCBrdm1fcmJ4X3Jl
YWQodmNwdSksIDMyLCAzMiwNCj4gJnBhZ2VpbmZvX2d2YSkgfHwNCj4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgIHNneF9nZXRfZW5jbHNfZ3ZhKHZjcHUsIGt2bV9yY3hfcmVhZCh2Y3B1KSwgNDA5Niwg
NDA5NiwNCj4gJnNlY3NfZ3ZhKSkNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAxOw0KPiArDQo+ICvCoMKgwqDCoMKgwqDCoC8qDQo+ICvCoMKgwqDCoMKgwqDCoCAqIENv
cHkgdGhlIFBBR0VJTkZPIHRvIGxvY2FsIG1lbW9yeSwgaXRzIHBvaW50ZXJzIG5lZWQgdG8gYmUN
Cj4gK8KgwqDCoMKgwqDCoMKgICogdHJhbnNsYXRlZCwgaS5lLiB3ZSBuZWVkIHRvIGRvIGEgZGVl
cCBjb3B5L3RyYW5zbGF0ZS4NCj4gK8KgwqDCoMKgwqDCoMKgICovDQo+ICvCoMKgwqDCoMKgwqDC
oHIgPSBrdm1fcmVhZF9ndWVzdF92aXJ0KHZjcHUsIHBhZ2VpbmZvX2d2YSwgJnBhZ2VpbmZvLA0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBzaXplb2YocGFnZWluZm8pLCAmZXgpOw0KPiArwqDCoMKgwqDCoMKgwqBpZiAociA9
PSBYODZFTVVMX1BST1BBR0FURV9GQVVMVCkgew0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKga3ZtX2luamVjdF9lbXVsYXRlZF9wYWdlX2ZhdWx0KHZjcHUsICZleCk7DQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMTsNCj4gK8KgwqDCoMKgwqDCoMKgfSBl
bHNlIGlmIChyICE9IFg4NkVNVUxfQ09OVElOVUUpIHsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHNneF9oYW5kbGVfZW11bGF0aW9uX2ZhaWx1cmUodmNwdSwgcGFnZWluZm9fZ3Zh
LA0KPiBzaXplKTsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0K
PiArwqDCoMKgwqDCoMKgwqB9DQo+ICsNCj4gK8KgwqDCoMKgwqDCoMKgLyoNCj4gK8KgwqDCoMKg
wqDCoMKgICogVmVyaWZ5IGFsaWdubWVudCBlYXJseS7CoCBUaGlzIGNvbnZlbmllbnRseSBhdm9p
ZHMgaGF2aW5nDQo+IHRvIHdvcnJ5DQo+ICvCoMKgwqDCoMKgwqDCoCAqIGFib3V0IHBhZ2Ugc3Bs
aXRzIG9uIHVzZXJzcGFjZSBhZGRyZXNzZXMuDQo+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiArwqDC
oMKgwqDCoMKgwqBpZiAoIUlTX0FMSUdORUQocGFnZWluZm8ubWV0YWRhdGEsIDY0KSB8fA0KPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqAgIUlTX0FMSUdORUQocGFnZWluZm8uY29udGVudHMsIDQwOTYp
KSB7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1faW5qZWN0X2dwKHZjcHUs
IDApOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDE7DQo+ICvCoMKg
wqDCoMKgwqDCoH0NCj4gKw0KPiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDCoMKgwqDCoMKgwqAg
KiBUcmFuc2xhdGUgdGhlIFNFQ0lORk8sIFNPVVJDRSBhbmQgU0VDUyBwb2ludGVycyBmcm9tIEdW
QQ0KPiB0byBHUEEuDQo+ICvCoMKgwqDCoMKgwqDCoCAqIFJlc3VtZSB0aGUgZ3Vlc3Qgb24gZmFp
bHVyZSB0byBpbmplY3QgYSAjUEYuDQo+ICvCoMKgwqDCoMKgwqDCoCAqLw0KPiArwqDCoMKgwqDC
oMKgwqBpZiAoc2d4X2d2YV90b19ncGEodmNwdSwgcGFnZWluZm8ubWV0YWRhdGEsIGZhbHNlLA0K
PiAmbWV0YWRhdGFfZ3BhKSB8fA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2d4X2d2YV90b19n
cGEodmNwdSwgcGFnZWluZm8uY29udGVudHMsIGZhbHNlLA0KPiAmY29udGVudHNfZ3BhKSB8fA0K
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2d4X2d2YV90b19ncGEodmNwdSwgc2Vjc19ndmEsIHRy
dWUsICZzZWNzX2dwYSkpDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4g
MTsNCj4gKw0KDQpEbyBwYWdlaW5mby5tZXRhZGF0YSBhbmQgcGFnZWluZm8uY29udGVudHMgbmVl
ZCBjYW5ub25pY2FsIGNoZWNrcyBoZXJlPw0KDQpJIHdhcyBub3RpY2luZyB0aGUgb3RoZXIgZGF5
IHRoYXQgdGhlIGd1ZXN0IHdhbGtlciBjb3VsZCBhY2Nlc3MgaG9zdA0KbWVtb3J5IHNsaWdodGx5
IG91dHNpZGUgb2YgYSBtZW1zbG90IGlmIGl0IGV2ZXIgZ290IHBhc3NlZCBhIGd2YSB3aXRoDQpi
aXRzIGhpZ2hlciB0aGF0IHRoZSB2YSBiaXRzLiBPciBhdCBsZWFzdCBpdCBhcHBlYXJlZCB0aGF0
IHdheS4gSQ0KZGlkbid0IGZ1bGx5IHdhZGUgaW50byB0aGUgYml0IG1hdGggYmVjYXVzZSBhbGwg
Y2FsbGVycyBmcm9tIHRoZSBndWVzdA0KZGlkIGNhbm5vbmljYWwgY2hlY2tzLg0K
