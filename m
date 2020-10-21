Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03323294641
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 03:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411051AbgJUBUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 21:20:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:2331 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411041AbgJUBUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 21:20:24 -0400
IronPort-SDR: /KBajzi091msNacA+DnPQ0PvgrryeD/fJhLF8BFMYsuV4gaOhbntkT64c+RjbhDBiVLPNPkU+t
 Eejddpr94emw==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="154249196"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="154249196"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 18:20:23 -0700
IronPort-SDR: SBExeO+jPtEUPdZjBpfY1F6f0mNLIxGjtA2oGfx5aeOupwsCQlKOIN/Omy1PHDisGTnv/6NuJ1
 wSuu2dHDMgmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="523720856"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 20 Oct 2020 18:20:23 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 18:20:23 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 20 Oct 2020 18:20:22 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 20 Oct 2020 18:20:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 20 Oct 2020 18:20:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHMV8I9RXeTUWFPRFahBaneAkk2YkqV7nWVocbGrs1GaDROdjky7gIWtOtPDJTLxgzFEjdIfZNdhsV6qpeJlO35YvT4XIeO/75dojRajOHQJA0JsrFwh7o50RSFksvEF9d0OyNNCd4qPN001A0PH+eZIoZTZrcl7K0fX0ldEpZIIhyg8C4ZtfQqeyw89Je4OzqdjMuD1b5mvSIBfSYb3IfXwCC/X7Mn/LqLs4UzYcbuLg1Ob7fU6rIhnS+Nvfi+g8TLMQyXwSjw1whO/6acfmW9API5RRM6lofV3YDrwV9Ey9VfVU/Y8IucBeNYYvHiL8wEisqz2KlNZAJE28LADNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s88AciiKRh0dIC5Pyzt78Qjdr2R/pniuE11oZdcUwhM=;
 b=OT6O22t6Mp34F0NIGxXS5BV19lEvCeaVnM2ELabPPzl01vBEgR/TdTc7/XQBBLilguKPkP83CnyAan1oJxmcyoGTwtyazkMrdHi+x/LW5ThQS2jFD0HElA1MeslmfWoaIUWq/ILdEa8h4P9Mb3fPGtAmquyxpzHVr4wsU4YyX867C18tA3vF3sj5RJWSFkIM7Fm/YrWS5/CGfrrambp/M82ivBuqaFvLZQ9FLx/h1nlZBaCA9ZnsvNOUzdiYc5rZgw1BtNoF7bjeYebQf6XbS4la9FuWM28lzsN9sFueRtT8i4eM/cT4ZamU7l70QobK8cXNqadBMxYTRZTL25mn3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s88AciiKRh0dIC5Pyzt78Qjdr2R/pniuE11oZdcUwhM=;
 b=EBCmfrkaxOsSfy5PpPo605xs2Dri+Wq06WixL+uAJACEyfODlnojK3gCE9ZbCD1y1fYzFCYwOJW8MamU2o94IbvDOGrW+GNxKGsOrOKWsntxjuTlTwuMjz3lr5LH2N2fuS035x+2C1AkDBj60Ez7PJtKYvEUAAYe60lxNJPjHTE=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB3135.namprd11.prod.outlook.com (2603:10b6:805:d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Wed, 21 Oct
 2020 01:20:18 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 01:20:18 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "david@redhat.com" <david@redhat.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "kirill@shutemov.name" <kirill@shutemov.name>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rppt@linux.ibm.com" <rppt@linux.ibm.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "wad@chromium.org" <wad@chromium.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Thread-Topic: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
Thread-Index: AQHWpqkA1YU9N1KX5UmrdwJUGbXroKmgaPoAgAARMICAAMkvgA==
Date:   Wed, 21 Oct 2020 01:20:18 +0000
Message-ID: <fac0a35ff7c7543467c5704767f9815ff719566b.camel@intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
         <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
         <f153ef1a-a758-dec7-b39c-9990aac9d653@redhat.com>
         <2759b4bf-e1e3-d006-7d86-78a40348269d@redhat.com>
In-Reply-To: <2759b4bf-e1e3-d006-7d86-78a40348269d@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
authentication-results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.55.39]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7cbcd769-3c7d-4f22-48b0-08d8755f7911
x-ms-traffictypediagnostic: SN6PR11MB3135:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3135AA9B720D98D6B82A43B4C91C0@SN6PR11MB3135.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D6jehHXLAltz5e86I3s03/S04Zo5cRuHMQQmN0GheviCqiAf8uMbtmm8FtI0l48jgsOU4T1Pwk9V1zs9Gg5uc58XYkkb9ZMmcUdxmWJXGA++TVCKjGhcmEEW8uKXP4c7PzoaK9SSqJr2AnRe6GCsDaCmTCl471KGA96BS07UQr5cIOwn9a37Mpt1k7q8LkieCFoIesmMmgDmLV8o5GB+izcOMHsfXXUbvlkjviVgST2BugZ0hR9UrcuLI2433p/FXF3afrbz7URxhmJXJAlL3HP5P7EarSSw7a1B1yKbhcF6K0ynfX2q+SCNzf9BnjgdWEUkvPJ2NjNPXp+QU8zgDTqoG67QP/Jm6qJlcuEx2hgcw6stCgugzue5Sf6L6QwQ6i/WQJxPXGARTvHfoqKMmzvJwBezJouHGOEbFR3mPSHKoVwIYJEycNT9s0f07axg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(86362001)(186003)(5660300002)(8936002)(71200400001)(26005)(2616005)(66946007)(76116006)(91956017)(66446008)(66556008)(64756008)(66476007)(4326008)(2906002)(6506007)(110136005)(6486002)(8676002)(83380400001)(6512007)(53546011)(54906003)(966005)(478600001)(7416002)(36756003)(316002)(4001150100001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: hCxKdD4CrcyzcIuIP4Q5VDxCAn195mvVIvs562Bti6Nzc2qAiwpnO+MDZ0lokRSSlFt2rLPIhm1dDlQ4VBjC7l3byqa8E6RcOfeNouZHsyZo5i6AXauIMzAdf3TDUEgyS+hBNKaC3HSP6gWAz2baAtcykwUCctXo+gxR+2J0uAdjy5SGuoQWXytO2WYFtQa1GmkrQ0OI2juzSdQxzoolAlxsttCzwW4IzpSd3pJfy/JHYgTiBGTNSc1dGJu1Ikd13RvQO18qDWgSwmOF1cYvHOLheR8ERCpmEUoy1wLGPGkULRLfC8chbn4DhAeYoK1RkOQFCLr3AJLQScrNCY5OPCsaB3bJjN7VI+CdewIYAL1nloQmevnakLBI0QUi1tWA2Gepzj4daLl8Mg/xruu0pd5kagOKbgEXbqioQnIgAhoD4GfeUAfY3WSdW9yKofvxj8Sa6v9yoNm7S6EjsegXkXWAAN4iQevjzWPQcloEhNjmdQj2WSowy864ou/hEQ/lRSOogrsLLUua5PlmqqFopC+9E+UEtKNKFY3QccTu3N8q1k09Uqc82NLb94XSgga7z20mKi+N2SkUqip0Uy8OIjquao+d7a89hwUZn2FL9Y0BFYct9Xelr60eY0567+XV6FBOGDIcMCHUg1diNYyCcg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA32C5F54B9D3D43BE44DB76D5299B8F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbcd769-3c7d-4f22-48b0-08d8755f7911
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 01:20:18.5284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yZY9mQU6nM/km5acvugyOvWruhf7ca4xcX3Gg2PuK1NUG2EZb4pkvsDtsr2XosUoIF2jdD+9KxCblNCljRrpZ5jPb5U8KfDQufqO/V52WyQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3135
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIwLTEwLTIwIGF0IDE1OjIwICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90
ZToNCj4gT24gMjAuMTAuMjAgMTQ6MTgsIERhdmlkIEhpbGRlbmJyYW5kIHdyb3RlOg0KPiA+IE9u
IDIwLjEwLjIwIDA4OjE4LCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3JvdGU6DQo+ID4gPiBJZiB0aGUg
cHJvdGVjdGVkIG1lbW9yeSBmZWF0dXJlIGVuYWJsZWQsIHVubWFwIGd1ZXN0IG1lbW9yeSBmcm9t
DQo+ID4gPiBrZXJuZWwncyBkaXJlY3QgbWFwcGluZ3MuDQo+ID4gDQo+ID4gR2FoLCB1Z2x5LiBJ
IGd1ZXNzIHRoaXMgYWxzbyBkZWZlYXRzIGNvbXBhY3Rpb24sIHN3YXBwaW5nLCAuLi4gb2gNCj4g
PiBnb3NoLg0KPiA+IEFzIGlmIGFsbCBvZiB0aGUgZW5jcnlwdGVkIFZNIGltcGxlbWVudGF0aW9u
cyBkaWRuJ3QgYnJpbmcgdXMNCj4gPiBlbm91Z2gNCj4gPiB1Z2xpbmVzcyBhbHJlYWR5IChTRVYg
ZXh0ZW5zaW9ucyBhbHNvIGRvbid0IHN1cHBvcnQgcmVib290cywgYnV0DQo+ID4gY2FuIGF0DQo+
ID4gbGVhc3Qga2V4ZWMoKSBJSVJDKS4NCj4gPiANCj4gPiBTb21ldGhpbmcgc2ltaWxhciBpcyBk
b25lIHdpdGggc2VjcmV0bWVtIFsxXS4gQW5kIHBlb3BsZSBkb24ndCBzZWVtDQo+ID4gdG8NCj4g
PiBsaWtlIGZyYWdtZW50aW5nIHRoZSBkaXJlY3QgbWFwcGluZyAoaW5jbHVkaW5nIG1lKS4NCj4g
PiANCj4gPiBbMV0gaHR0cHM6Ly9sa21sLmtlcm5lbC5vcmcvci8yMDIwMDkyNDEzMjkwNC4xMzkx
LTEtcnBwdEBrZXJuZWwub3JnDQo+ID4gDQo+IA0KPiBJIGp1c3QgdGhvdWdodCAiaGV5LCB3ZSBt
aWdodCBoYXZlIHRvIHJlcGxhY2UgcHVkL3BtZCBtYXBwaW5ncyBieQ0KPiBwYWdlDQo+IHRhYmxl
cyB3aGVuIGNhbGxpbmcga2VybmVsX21hcF9wYWdlcyIsIHRoaXMgY2FuIGZhaWwgd2l0aCAtRU5P
TUVNLA0KPiB3aHkNCj4gaXNuJ3QgdGhlcmUgcHJvcGVyIGVycm9yIGhhbmRsaW5nLg0KPiANCj4g
VGhlbiBJIGRpdmVkIGludG8gX19rZXJuZWxfbWFwX3BhZ2VzKCkgd2hpY2ggc3RhdGVzOg0KPiAN
Cj4gIlRoZSByZXR1cm4gdmFsdWUgaXMgaWdub3JlZCBhcyB0aGUgY2FsbHMgY2Fubm90IGZhaWwu
IExhcmdlIHBhZ2VzDQo+IGZvcg0KPiBpZGVudGl0eSBtYXBwaW5ncyBhcmUgbm90IHVzZWQgYXQg
Ym9vdCB0aW1lIGFuZCBoZW5jZSBubyBtZW1vcnkNCj4gYWxsb2NhdGlvbnMgZHVyaW5nIGxhcmdl
IHBhZ2Ugc3BsaXQuIg0KPiANCj4gSSBhbSBwcm9iYWJseSBtaXNzaW5nIHNvbWV0aGluZyBpbXBv
cnRhbnQsIGJ1dCBob3cgaXMgY2FsbGluZw0KPiBrZXJuZWxfbWFwX3BhZ2VzKCkgc2FmZSAqYWZ0
ZXIqIGJvb3Rpbmc/ISBJIGtub3cgd2UgdXNlIGl0IGZvcg0KPiBkZWJ1Z19wYWdlYWxsb2MoKSwg
YnV0IHVzaW5nIGl0IGluIGEgcHJvZHVjdGlvbi1yZWFkeSBmZWF0dXJlIGZlZWxzDQo+IGNvbXBs
ZXRlbHkgaXJyZXNwb25zaWJsZS4gV2hhdCBhbSBJIG1pc3Npbmc/DQo+IA0KDQpNeSB1bmRlcnN0
YW5kaW5nIHdhcyB0aGF0IERFQlVHX1BBR0VBTExPQyBtYXBzIHRoZSBkaXJlY3QgbWFwIGF0IDRr
DQpwb3N0LWJvb3QgYXMgd2VsbCBzbyB0aGF0IGtlcm5lbF9tYXBfcGFnZXMoKSBjYW4ndCBmYWls
IGZvciBpdCwgYW5kIHRvDQphdm9pZCBoYXZpbmcgdG8gdGFrZSBsb2NrcyBmb3Igc3BsaXRzIGlu
IGludGVycnVwdHMuIEkgdGhpbmsgeW91IGFyZSBvbg0KdG8gc29tZXRoaW5nIHRob3VnaC4gVGhh
dCBmdW5jdGlvbiBpcyBlc3NlbnRpYWxseSBhIHNldF9tZW1vcnlfKCkNCmZ1bmN0aW9ucyBvbiB4
ODYgYXQgbGVhc3QsIGFuZCBtYW55IGNhbGxlcnMgZG8gbm90IGNoZWNrIHRoZSBlcnJvcg0KY29k
ZXMuIEtlZXMgQ29vayBoYXMgYmVlbiBwdXNoaW5nIHRvIGZpeCB0aGlzIGFjdHVhbGx5OiANCmh0
dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy83DQoNCkFzIGxvbmcgYXMgYSBwYWdl
IGhhcyBiZWVuIGJyb2tlbiB0byA0aywgaXQgc2hvdWxkIGJlIGFibGUgdG8gYmUgcmUtDQptYXBw
ZWQgd2l0aG91dCBmYWlsdXJlIChsaWtlIGRlYnVnIHBhZ2UgYWxsb2MgcmVsaWVzIG9uKS4gSWYg
YW4gaW5pdGlhbA0KY2FsbCB0byByZXN0cmljdCBwZXJtaXNzaW9ucyBuZWVkcyBhbmQgZmFpbHMg
dG8gYnJlYWsgYSBwYWdlLCBpdHMgcmVtYXANCmRvZXMgbm90IG5lZWQgdG8gc3VjY2VlZCBlaXRo
ZXIgYmVmb3JlIGZyZWVpbmcgdGhlIHBhZ2UsIHNpbmNlIHRoZSBwYWdlDQpuZXZlciBnb3Qgc2V0
IHdpdGggYSBsb3dlciBwZXJtaXNzaW9uLiBUaGF0J3MgbXkgdW5kZXJzdGFuZGluZyBmcm9tDQp4
ODYncyBjcGEgYXQgbGVhc3QuIFRoZSBwcm9ibGVtIGJlY29tZXMgdGhhdCB0aGUgcGFnZSBzaWxl
bnRseSBkb2Vzbid0DQpoYXZlIGl0cyBleHBlY3RlZCBwcm90ZWN0aW9ucyBkdXJpbmcgdXNlLiBV
bmNoZWNrZWQgc2V0X21lbW9yeV8oKQ0KY2FjaGluZyBwcm9wZXJ0eSBjaGFuZ2UgZmFpbHVyZXMg
bWlnaHQgcmVzdWx0IGluIGZ1bmN0aW9uYWwgcHJvYmxlbXMNCnRob3VnaC4NCg0KU28gdGhlcmUg
aXMgc29tZSBiYWNrZ3JvdW5kIGlmIHlvdSB3YW50ZWQgaXQsIGJ1dCB5ZWEsIEkgYWdyZWUgdGhp
cw0KZmVhdHVyZSBzaG91bGQgaGFuZGxlIGlmIHRoZSB1bm1hcCBmYWlsZWQuIFByb2JhYmx5IHJl
dHVybiBhbiBlcnJvciBvbg0KdGhlIElPQ1RMIGFuZCBtYXliZSB0aGUgaHlwZXJjYWxsLiBrZXJu
ZWxfbWFwX3BhZ2VzKCkgYWxzbyBkb2Vzbid0IGRvIGENCnNob290ZG93biB0aG91Z2gsIHNvIHRo
aXMgZGlyZWN0IG1hcCBwcm90ZWN0aW9uIGlzIG1vcmUgaW4gdGhlIGJlc3QNCmVmZm9ydCBjYXRl
Z29yeSBpbiBpdHMgY3VycmVudCBzdGF0ZS4NCg0KDQpGb3IgdW5tYXBwaW5nIGNhdXNpbmcgZGly
ZWN0IG1hcCBmcmFnbWVudGF0aW9uLiBUaGUgdHdvIHRlY2huaXF1ZXMNCmZsb2F0aW5nIGFyb3Vu
ZCwgYmVzaWRlcyBicmVha2luZyBpbmRpc2NyaW1pbmF0ZWx5LCBzZWVtIHRvIGJlOg0KMS4gR3Jv
dXAgYW5kIGNhY2hlIHVubWFwcGVkIHBhZ2VzIHRvIG1pbmltaXplIHRoZSBkYW1hZ2UgKGxpa2Ug
c2VjcmV0DQptZW0pDQoyLiBTb21laG93IHJlcGFpciB0aGVtIGJhY2sgdG8gbGFyZ2UgcGFnZXMg
d2hlbiByZXNldCBSVyAoYXMgS2lyaWxsIGhhZA0KdHJpZWQgZWFybGllciB0aGlzIHllYXIgaW4g
YW5vdGhlciBzZXJpZXMpDQoNCkkgaGFkIGltYWdpbmVkIHRoaXMgdXNhZ2Ugd291bGQgd2FudCBz
b21ldGhpbmcgbGlrZSB0aGF0IGV2ZW50dWFsbHksDQpidXQgbmVpdGhlciBoZWxwcyB3aXRoIHRo
ZSBvdGhlciBsaW1pdGF0aW9ucyB5b3UgbWVudGlvbmVkIChtaWdyYXRpb24sDQpldGMpLg0K
