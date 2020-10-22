Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C16296336
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2902174AbgJVQ75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 12:59:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:18479 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505164AbgJVQ75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 12:59:57 -0400
IronPort-SDR: Hlv+YRmEZ97EnOJk3Kv104gt8jNjmQfcx39AAwgmgIO4pkDZ8+H3ZC2WokdAjXD9N/2rBMKe1B
 bBCTDa8cl4CA==
X-IronPort-AV: E=McAfee;i="6000,8403,9782"; a="229192583"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="229192583"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 09:59:56 -0700
IronPort-SDR: YA/bFmmscUyoCmtUcYsbLrttKHBtSlaxviSy4+1Ol8AyuZ0oZo6jmndVclvb5+jU7rKQ9X8fRI
 QnGIxusRZGoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="348829550"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 22 Oct 2020 09:59:56 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 22 Oct 2020 09:59:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 22 Oct 2020 09:59:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 22 Oct 2020 09:59:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ae32m0Z09RMmWKRunTB+DdxALKiqQzyPt0NMGNePqrwOcF2XYZYskJUPJraoPiNAMRkmyxhZMyzjH/bOq+/7EyVnUGRoLyG3o+l23YMw9ii7nOXUELen8YSR9CI69CXRZ8fewkUrsL/alTyxcB7Tuz04nfynUlgihAUS0c8irHofZdokXNQyPfe+5TutO+GA/ndNOwNrRs2jne1m97gs95Ed+0CnsAXaoWlT90mheRixf/OVz6/9v6EwjYim3Lg6WrkbFUcV6P+eVdHL0pNGBqkPaWkJzGuRqpmfnZhPMl2Ff9icPeiPMkDpFl8DBDwvRhbieXD+gR+004fy8+gkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHA8NR2LJbSuqGzHg+oFMHmuatFHQYgruz+E8c2Hv4U=;
 b=NQqDQh5OGBQS3/HGVJX/DDuR+AiK3slbRe5g6R8MiMeJ81w+KuNxgkSvqh4hEorV23yX5dOThXKvineqq+V3QrEHswntGrIIdmORnC/gTzR94cwV8vsuMcsyxFzX066kU/TBRy2AVcbP/NY+Xc9pHqern4NWZI6I7LtKmerdNyIyLXEpFAeCj4B/Dncct0DO/pq1ACuh9/iuJGmrb7kfIa113a5Wv3ctvCZUZ2f5vuUKewAyYsSf/Jcu/jFrAzA49zp3qbWKZyh5Dri6pmDBk9PjsmWadobh7XOO0NY9vSaqP9tLsdvHs5+1iUS3+suqma7upeaQlY8DL7HFDFUP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHA8NR2LJbSuqGzHg+oFMHmuatFHQYgruz+E8c2Hv4U=;
 b=ZLoSCXpL58awo95yrawZuAb/j5/s/8iPZfgPnysmLeCGhLb5a2trtT7XPbpoBoZ76iM+NT1F+hKvat6ewS8B7jjTF3P3zHv9qOc0PtC95ExVVHymbo27kC2xhaNoO+CCntN+1aWrIuGL4F4l4OygTWJf+DGqL8BYnQ3LSugV7zA=
Received: from SN6PR11MB3184.namprd11.prod.outlook.com (2603:10b6:805:bd::17)
 by SN6PR11MB2541.namprd11.prod.outlook.com (2603:10b6:805:57::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Thu, 22 Oct
 2020 16:59:49 +0000
Received: from SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704]) by SN6PR11MB3184.namprd11.prod.outlook.com
 ([fe80::b901:8e07:4340:6704%7]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 16:59:49 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "kirill@shutemov.name" <kirill@shutemov.name>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "wad@chromium.org" <wad@chromium.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFCv2 14/16] KVM: Handle protected memory in
 __kvm_map_gfn()/__kvm_unmap_gfn()
Thread-Topic: [RFCv2 14/16] KVM: Handle protected memory in
 __kvm_map_gfn()/__kvm_unmap_gfn()
Thread-Index: AQHWpqj4ToecU9lBzE+dZx9c9zC6jKmiaMOAgAEhioCAAFHgAA==
Date:   Thu, 22 Oct 2020 16:59:49 +0000
Message-ID: <4df3bb56f56f5a8d69b4b288317111046158cebb.camel@intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
         <20201020061859.18385-15-kirill.shutemov@linux.intel.com>
         <8404a8802dbdbf81c8f75249039580f9e6942095.camel@intel.com>
         <20201022120645.vdmytvcmdoku73os@box>
In-Reply-To: <20201022120645.vdmytvcmdoku73os@box>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.1 (3.30.1-1.fc29) 
authentication-results: shutemov.name; dkim=none (message not signed)
 header.d=none;shutemov.name; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.55.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ff7ff15-2c9b-4d37-2253-08d876abe322
x-ms-traffictypediagnostic: SN6PR11MB2541:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2541EB8E1494C73124059926C91D0@SN6PR11MB2541.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIjuKfOzBqKmEkhJ9B+O3ncR1oSLnWxMrVoV8tDh6v4/cpCDWVUJV7Tqw2I0Pb1RjOIeXf0/6p/5iNEAGdDxsO+0zR/wPCvDkx/qaBIKSDwZFd52sdTU6v9DUp0kQ4EGVGata2HI7PS8raxiebu5atRpMqV7q0dPhizRDA63EPqeLH/9Zdwp5PFp2nwXr614kIVggOMLNGgmi9/wpc4VWPO3rq7wCmOemLJc6Y0PC3IjXs95ZFrhcgw6BSK9xzkfzAKtHyCoPaKmq7IPbo4Xn3nNhtS88g5hmIawGFxPR7QD5rfanWJUvnIh+pSorKCQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3184.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(54906003)(5660300002)(316002)(6512007)(36756003)(8936002)(71200400001)(4001150100001)(2906002)(8676002)(4326008)(478600001)(7416002)(6486002)(86362001)(91956017)(83380400001)(2616005)(26005)(66476007)(186003)(66946007)(66556008)(64756008)(66446008)(76116006)(6916009)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qZzVSM+3a+4z9C0bZ+x52YaiZOUKZuO6+4k9kBKn50koiNOhWfREVO1QyTUBTor5kR96tZumDv1+KN1i+Mmgja5FjjrNVfvOyQFHLYbn6I/wZTbua6SPhWxTV5c40Bq5rOzWnPvoGVj7Sfuiz4J3kfFgqvOvos00QyiE2Z8DpoVI9DBZ15Au7SOFXHPWcVUuoHJ1jAY0odPLqlWOwqJpAezHvA5myhBwHk/sUHIkmk/d2fbu8qKVaHu+6BJuDsI8MjzgSZAkxltnl9d32fyXSGv/DNBhn744d0vevgwr4CdE6wJaK8McDxn9J/a4+6quTt0gG6HJj/OgqUFUNU4CMj1A27zUNp3PJaUkhqI8J2QsWtsE/YHy4JUXKubsERI1cEn3qsKzEY89PU8cv8w8rmrIWJsNtAVaRNW7Y9MFmdGYniQHFfv0lK1ZIz3lAz1lyui/ESjy8JRXMz5AZho2lER05ATXOmW88wVEyT59bHaPB9lJCn09tLDpUQWJqbTwsGl4Q04HRynDEb7qegJqNdK/AVO6Uq9WVtaLY9n7l/cpZne+mi3ZKgHGhBxbRRBVbD4NeQIhAzMQ8xqBDqKN5chGXzWNuOkzK65V3GhBVcgBEqpTxkUNfXT76GujZDm67o2cIQADmPL3pNdqIqoBrA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <09681E5BFD18224882CF920062BA1252@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3184.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff7ff15-2c9b-4d37-2253-08d876abe322
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 16:59:49.3806
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +N8l3eLGFZ5WziEQrmpKYpGfA80MfQaEidDYULJXXK3IKl766ZHuTisD7+djfdSIB5Owqsik9RRxlew0Cr6HRb8q3Zknrbso+g5AP2cFx/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2541
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVGh1LCAyMDIwLTEwLTIyIGF0IDE1OjA2ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+ID4gSSB0aGluayB0aGUgcGFnZSBjb3VsZCBoYXZlIGdvdCB1bm1hcHBlZCBzaW5jZSB0
aGUgZ3VwIHZpYSB0aGUNCj4gPiBoeXBlcmNhbGwgb24gYW5vdGhlciBDUFUuIEl0IGNvdWxkIGJl
IGFuIGF2ZW51ZSBmb3IgdGhlIGd1ZXN0IHRvDQo+ID4gY3Jhc2gNCj4gPiB0aGUgaG9zdC4NCj4g
DQo+IEhtLi4gSSdtIG5vdCBzdXJlIEkgZm9sbG93LiBDb3VsZCB5b3UgZWxhYm9yYXRlIG9uIHdo
YXQgc2NlbmFyaW8geW91DQo+IGhhdmUNCj4gaW4gbWluZD8NCg0KS2luZCBvZiBzaW1pbGFyIHNj
ZW5hcmlvIGFzIHRoZSB1c2Vyc3BhY2UgdHJpZ2dlcmVkIG9vcHMuIE15DQp1bmRlcnN0YW5kaW5n
IGlzIHRoYXQgdGhlIHByb3RlY3RlZCBzdGF0dXMgd2FzIGdhdGhlcmVkIGFsb25nIHdpdGggdGhl
DQpndXAsIGJ1dCBhZnRlciB0aGUgbW0gZ2V0cyB1bmxvY2tlZCwgbm90aGluZyBzdG9wcyB0aGUg
cGFnZQ0KdHJhbnNpdGlvbmluZyB0byB1bm1hcHBlZCg/KS4gQXQgd2hpY2ggcG9pbnQga21hcCgp
IGZyb20gYSBwcmV2aW91cyBndXANCndpdGggIXByb3RlY3RlZCwgd291bGQgZ28gZG93biB0aGUg
cmVndWxhciBrbWFwKCkgcm91dGUgYW5kIHJldHVybiBhbg0KYWRkcmVzcyB0byBhbiB1bm1hcHBl
ZCBwYWdlLg0KDQpTbyB0aGUgZ3Vlc3Qga2VybmVsIGNvdWxkIHN0YXJ0IHdpdGggYSBwYWdlIG1h
cHBlZCBhcyBzaGFyZWQgdmlhIHRoZQ0KaHlwZXJjYWxsLiBUaGVuIHRyaWdnZXIgb25lIG9mIHRo
ZSBQViBNU1IncyB0aGF0IGttYXAoKSBvbiBDUFUwLiBPbg0KQ1BVMSwgYWZ0ZXIgdGhlIGd1cCBv
biBDUFUwLCBpdCBjb3VsZCB0cmFuc2l0aW9uZWQgdGhlIHBhZ2UgdG8NCnByaXZhdGUvdW5tYXBw
ZWQgdmlhIHRoZSBoeXBlcmNhbGwuIFNvIHRoZSBodmFfdG9fcGZuKCkgd291bGQgZmluZA0KIXBy
b3RlY3RlZCwgYnV0IGJ5IHRoZSB0aW1lIHRoZSBrbWFwKCkgaGFwcGVuZWQgdGhlIHBhZ2Ugd291
bGQgaGF2ZQ0KYmVlbiB1bm1hcHBlZC4gQW0gSSBtaXNzaW5nIHNvbWV0aGluZz8NCg0K
