Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A282730CEBD
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhBBWXB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:23:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:44066 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235414AbhBBWW1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:22:27 -0500
IronPort-SDR: vNjeKA7CZkJle8HbpoBDy2LGGKWtwTLE4QhLIpWxv76N7fgcIHZ6runJ8fGQqzwCPdLbr7EhOQ
 t3ClKAIlJibQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="160705858"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="160705858"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 14:21:45 -0800
IronPort-SDR: 1x2VdJlpTav4JgfvZnqYiqiy5RY46pJsBAcyZbdEm+B5zi9w8LP6dolhBF98s/M+hdxe99Wnon
 GxPz7oil10uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="372129246"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 02 Feb 2021 14:21:45 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 2 Feb 2021 14:21:44 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 2 Feb 2021 14:21:44 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 2 Feb 2021 14:21:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMDWrC1LWsdd6F2fpstyMiUtHPdfBe39aZ0Z0rGdZEqN6lOFYVZz82GDct1dFlIw2tpnLcN482LEbx0MCr5VOfS8qSgyTZLgs27nEiGzZLEI9Lx/lYphncn3TRTRpHAppFwXYEVdc/5MNCu4IBpy4Meu9W8AoXXqw1xl4qd99J3jD431CJpFrAt2M2PIlpOoeqbhAZj+Lx+/WYuIi7vmOLYMCpeHZPRtNsP/v4pyj+ywRObcSIo7xpRLrAns23I+2W3ImWh4ap+x6A9MOsW305xYhJIRJ+EqBxy0ZvxjsNM6D906Vf3EGlMJGmVbEQ4fNIgDl2VKV8vtAe8mtiC+pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLgysZ975qD4sOjbxPfseHocStRCHNpW8yRHMXEZ2Oo=;
 b=kI9/TlteXsxmkAIrnfQfhO/511S8qEA/olbwxoVDMWqvQLyDUk1D0u609XenTo75ajYcRbvrP2SmIEzducLlR9IEHiTiaNtptKLROI4EJXpiteFHh+Eo9RI+TA2FMQy6n5oBdQrF9mLzhi85EI/kUm8YCev2Wvj8m92pNFEwqIHYyrl+O9dbw62rT+sOO55cnsykyIPrVyW/VpU/aYjcLRyWI0AeBgXzIkygeUBOC3IePR3qs5rQJZXgxh9PHle4Fs8dFGq2SEHpMYWrw20gPS0bxl2nmkM4B7db71PGrHJoR0n3J0nLeSDQEYfFro9AoOfoylzZ8YGSc17qWyASbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLgysZ975qD4sOjbxPfseHocStRCHNpW8yRHMXEZ2Oo=;
 b=NwStOd84Xa9QYAwM00DRT+aAu9LXGB1ZAKUop+epgT3ZvvVp2yF1yACVqMnInsdjB1BYcxfhoPPOFj/woUkFs6v1fDfc+HQLCg/LU14V3o+uiWqptahdQqOh37Ol3Q/5m69/7wzXtYtJhCqGVhrq6Tgm9WzlwJZmyLdwZrk5rY8=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SA2PR11MB5018.namprd11.prod.outlook.com (2603:10b6:806:11a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Tue, 2 Feb
 2021 22:21:42 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::ac4a:f330:44cb:fbf4%7]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 22:21:42 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "corbet@lwn.net" <corbet@lwn.net>,
        "luto@kernel.org" <luto@kernel.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "jethro@fortanix.com" <jethro@fortanix.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "b.thiel@posteo.de" <b.thiel@posteo.de>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "Huang, Haitao" <haitao.huang@intel.com>
Subject: Re: [RFC PATCH v3 00/27] KVM SGX virtualization support
Thread-Topic: [RFC PATCH v3 00/27] KVM SGX virtualization support
Thread-Index: AQHW88wLzX3OEqPTjE+UPIrin+cR3qpFe/eA
Date:   Tue, 2 Feb 2021 22:21:42 +0000
Message-ID: <4b4b9ed1d7756e8bccf548fc41d05c7dd8367b33.camel@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.3 (3.38.3-1.fc33) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f2ba407-7f7c-49d1-fe0f-08d8c7c8eb55
x-ms-traffictypediagnostic: SA2PR11MB5018:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB50183A0029AEA70A34543BCDC9B59@SA2PR11MB5018.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hkUs+CnVEdoKGGeFys5S2lpvLqBFgqwjNXGfAX905x8nkwDaFz8Ud4UpoQD2T77ZJx61Cz3ZvP92ZCVPF76I71bEWq5xLDa1vPPUSn8TBMowFi4p+EMi/gVClPncLHjCxildm6ytKAdiPEUxl/JbpBN5/bQ76Vu9TC6+KGHegptsyyprQJnWP/rogj4zj3e3/lwhLmSRk6NbppzrhJxrFPRF7MY1anMyjoN2h9eQEal4h49rju0ur6hLu8iXXZQ5MZ/DDkQqL6O5qwjGpG8RQvs0RTDhBiA4uUrgMjWAGZzf6eFrPKqrNQyLCVTQ2by0nYsi8v27Ww3Rj9en5P0iGs75JNHpr5cQpwIkYIAeOb05X1mfIjHsOBafjb1dNn1tJHrPdoZVdxlZ0tin1CEYDmuJrDaC8pjcVcEXcbryeR6mneGJjn8se4Z3YwmYnwaNG/hxm3G+StqQ7IuYl2YeQ9fdNtwjkSIL1hGdt5oTZzFrpfDqAd2wP3bqyF3eNd0iWMSbDQJ4CBOOGXvgL6r58A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(316002)(2906002)(6486002)(83380400001)(54906003)(71200400001)(478600001)(66946007)(110136005)(6512007)(2616005)(5660300002)(86362001)(4744005)(4326008)(26005)(64756008)(76116006)(7416002)(36756003)(91956017)(8936002)(6506007)(107886003)(8676002)(66556008)(186003)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y2RsdjNBU2dSeHpkNkNVQTc0V01UVWJUb1lpZVdhSFhkRnkxWXRCVkpzSG1L?=
 =?utf-8?B?d3VhR0xMaDY0SnZHOEVkRm1IK3lJTWNiZ2trRFRadkFIL0w0a3drWEZ2VXBi?=
 =?utf-8?B?MVFYM3AwSUs0bk4zR1duK1BTOWRLQjA1UnJDRmQ1UFdCM3RlNFZmOHpvN3J2?=
 =?utf-8?B?cHQ0ZnQxV3VVNkRCQ3FZcDdLLzRrOVlqNWFOck9CRFg5SG9SZUFtNzlFbm1I?=
 =?utf-8?B?ZmZJVFhtMTI1RWV3dWFjS3JVVkdzRUhkVnFQOFVBWWNRTmtQNytIQi90Q1JF?=
 =?utf-8?B?SW41QTdQS09LRkhBeUlyQzRIMkFRampJK0s0MzZwWFJ1Q2hITW12cmQwaEJl?=
 =?utf-8?B?Um5FVENDaGNHcHkxNTREWjFjQnBxcDNRM25XQ1g5OWdnZ2M4ZzJ5M1JpeXBE?=
 =?utf-8?B?S1p6dUlRcFBxKzgxK2hJdWI1dkhBcXVIL1hoWGpCamQwTnlNNkVPNmhxU1dI?=
 =?utf-8?B?SEl6YnJKTkFzM1c0b3lVbVh3azJxTTVpNC80a3I5RzJaVUNMR1pLUkNYcTNN?=
 =?utf-8?B?VTV1OEd5RWlHL0NCN1VKWmFZWkNHRm9zWitVNjBhSVZwVmVzaUFDUlpoRENm?=
 =?utf-8?B?amVhMCsxZHZhR3VPOE1QVnBOOGEwV2VCM2pLSE5ZVnl0ZklzazZlWmhxZStm?=
 =?utf-8?B?cXJhVUpHZ0ZZQ1IzdGtMdVJsL2hZdEF5SzhPekZBUkJnT1NkOERqU2VCVy9T?=
 =?utf-8?B?OVVxS0FZbG9mYVl6cTBBRU9Jd0dHeGExaCtua0prM2c4ZnlERFNRWlRqRHky?=
 =?utf-8?B?Nnp6RExpbkZUc3hhT0Rzc2swN1Y4eWtmTWhVUXBlUTJtQ3B3ZC9zbmFOVkZC?=
 =?utf-8?B?bFY2azhrWEIrczkxNjFSUE9hY3VoRUZtcVRDTEpLSVBWdjhEaFpvVExBZjFB?=
 =?utf-8?B?cGEvSnFDOWhVUzloQVZBNCtOVmMwVHU2UlBld0RLWlRSMHdoSXdVd2hoUWtJ?=
 =?utf-8?B?SWh6M0EwVG1UQWNid1BVTzRlQS9nSVowUFY1VkZ0V2F5N2ZsS1lpS1lBejEw?=
 =?utf-8?B?ckpwN29Ca20yLzFhV0ZoRGw1YVJWTmpubHhFd3FkYW5uVElWTXVPMkJGM2Zo?=
 =?utf-8?B?bEFqQUNXNjhkT1NCdHJYN08xWUhoL2h4STA2V2dkUE5NVWNzSFM3S1YvTkxK?=
 =?utf-8?B?QTE2MGY1NkM2VU95MmhtamNZd2FuZTJFdHYvOURvU2ZFVG44YUU0eE03SHVI?=
 =?utf-8?B?b1JUNFgwRmMyNHpIZ3VEbDhRdnRNZUpySEpCOThuQmEwZ3lWM3J5M3BmZmJN?=
 =?utf-8?B?MjhqWTJGcWhKcUlOVmVpZTE1U3FpSWtSOUUxOUg5NXEwcW1VQlF2TFppU0Vs?=
 =?utf-8?B?Wk51RmFQcVBvV1ZubGw1aHAyZGpPU2o1a0M3clk3N1o0djV2VXRXS25EL0l6?=
 =?utf-8?B?MHZhcEZXTkhUN0YxN1pWWloxZlhrcFlpenlyTzZOekkwdzdsRXc2RVZ5Smpy?=
 =?utf-8?B?MnoxWnVwalZtek9KL2lVREJ3TENqZ3MxOXlGQjVjZ0F1eEJwalJoK0RSUGJU?=
 =?utf-8?B?NlpFSzU3UlRtbUp5VlhlZ1ExRVlXdG5XbllTOG11Y3JlR2lldG1xNVdlck9u?=
 =?utf-8?B?Z0FvM2dOcWtWblIycTZ6NzBaU2owNUhRaUNFRm1kSmQ5dlBRT0g2U1dwRXRL?=
 =?utf-8?B?bjQ4aThZdlRUbDNMSkxreWtwK0tWM2NoenZZYzlVOTh0OW9DV0d5TGZJVnp3?=
 =?utf-8?B?c05FVjFzamgxWitJMkZIOFpoTTlYMis1U1UzVmlvYkVlbkRxUm1wdkhJaFhs?=
 =?utf-8?B?UlNpeTlvSm9RVmlnRjZPSGkyb0JxOVRmZEZtbjRMbExqell0aGgxRG05N3N3?=
 =?utf-8?B?T3JXZHlMeGxXSjdzeElqZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDCB3FD1E56D0140AA061F91B7C374DD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2ba407-7f7c-49d1-fe0f-08d8c7c8eb55
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 22:21:42.6714
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bJ12YNHALS5Rnzg2uwnWBz0T8PgTSpvz9vnfQf41XRr8eF0jlIfZvQijhnAehdGxV8O6QduNV9uLg1qEtpfLIRDutmMRFM6T2uELry1cjSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5018
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTI2IGF0IDIzOjEwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRo
aXMgc2VyaWVzIGFkZHMgS1ZNIFNHWCB2aXJ0dWFsaXphdGlvbiBzdXBwb3J0LiBUaGUgZmlyc3Qg
MTUgcGF0Y2hlcw0KPiBzdGFydGluZw0KPiB3aXRoIHg4Ni9zZ3ggb3IgeDg2L2NwdS4uIGFyZSBu
ZWNlc3NhcnkgY2hhbmdlcyB0byB4ODYgYW5kIFNHWA0KPiBjb3JlL2RyaXZlciB0bw0KPiBzdXBw
b3J0IEtWTSBTR1ggdmlydHVhbGl6YXRpb24sIHdoaWxlIHRoZSByZXN0IGFyZSBwYXRjaGVzIHRv
IEtWTQ0KPiBzdWJzeXN0ZW0uDQoNCkRvIHdlIG5lZWQgdG8gcmVzdHJpY3Qgbm9ybWFsIEtWTSBo
b3N0IGtlcm5lbCBhY2Nlc3MgdG8gRVBDIChpLmUuIHZpYQ0KX19rdm1fbWFwX2dmbigpIGFuZCBm
cmllbmRzKT8gQXMgYmVzdCBJIGNhbiB0ZWxsIHRoZSBleGFjdCBiZWhhdmlvciBvZg0KdGhpcyBr
aW5kIG9mIGFjY2VzcyBpcyB1bmRlZmluZWQuIFRoZSBjb25jZXJuIHdvdWxkIGJlIGlmIGFueSBI
VyBldmVyDQp0cmVhdGVkIGl0IGFzIGFuIGVycm9yLCB0aGUgZ3Vlc3QgY291bGQgc3ViamVjdCB0
aGUgaG9zdCBrZXJuZWwgdG8gaXQuDQpJcyBpdCB3b3J0aCBhIGNoZWNrIGluIHRob3NlPw0K
