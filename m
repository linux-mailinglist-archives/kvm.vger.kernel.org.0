Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29A81EC72E
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 04:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725910AbgFCCJ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 22:09:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:61255 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgFCCJz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 22:09:55 -0400
IronPort-SDR: 2+Fvnd5eFzNypVoxXb/UXPgoedu+UE4X29etYMhFuOT+FbmJUa5+2VQHQL6c+8xXwI/hMrDhU1
 ovLngig335wg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2020 19:09:54 -0700
IronPort-SDR: QbflBtgYucsFCYdwYWVAXfTCvscpVYn0PXEMN1daIhEUw/0qVvQJv7S4y349ne5pj0lbCvsORt
 Q6RYXZhIRZmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,466,1583222400"; 
   d="scan'208";a="286866321"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga002.jf.intel.com with ESMTP; 02 Jun 2020 19:09:53 -0700
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 2 Jun 2020 19:09:53 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX122.amr.corp.intel.com (10.22.225.227) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 2 Jun 2020 19:09:53 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 2 Jun 2020 19:09:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POe7yxJ9JlvIA27N8d5QTpSeEC+VUmUzJaKyKD8ufQNq0MbMBq7FUci4MUY6JiAeA9fhBGbsdSItPhH9NHK9q7k3XILc0RozF+024B7kOc8ABlYlcz9vwRTWfZjh/hdw+sDvQFPLR6wBz+X5M7i63vuhM5lLdqEJ/C9DJES3SL7Zq5TKaP2XKS3WnIUNkOa0JbnqZ8L64DRO3qTWNofwUSLU41xbhIOAie8j55Fp456z0hLwuHti+OsJ9yJ7p1SgWjZCBbEVFefbLGf+RkdVvANCAeUTO25dSUEMn2BlqkAwhhGu2TbKD12IjT/Pl7MW2gxNQcSahYnLNYE8rA4jEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boCeAhovVHPKht5qpq+r8fMQ09IMx8GYfQq11X3J+Rk=;
 b=JQnGG/IsE6DMdW7zXA0j7rH0XryNVqtj0OhwD5W9qLMd0xX2AkEwniAYC03rxkywTV/A+Nle3OEktDbbip7eLjhgIUvSb5ZBrkph9fmaUJf+TwS/ItQqcvWc1OaQ/dDfXMq2QXwEB5xZmKulJZmmZl6GYRJDXvqmSog95ldiFOC8y7wpjOhPChHWXL7QXic9BB8DvWg/g2wvQvk9lRrkCOWjtp9XM4Tp+nMSQV3bEUF+LjFak5JKJcgzNfYbjUQHqg0quU4tEkAY4NXUptyTvEA07pe01bU5hlrY2L9e/yEXtETUTTg3cnut8WVqPI2ac94buSBkS3f2VTyO78J59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=boCeAhovVHPKht5qpq+r8fMQ09IMx8GYfQq11X3J+Rk=;
 b=Fa4gkbqjCmKU1lx1+vZMDkck9drtv2bzfrYSFbsyRmFwnj0hYf4pMNsdYBByVV0kl0EvjDfUAF6ZZKb0xiwpRot5uRmB8DzNSCEvQK/eGHSCZ2kWwDA7wZpcS0Lc2zjLXhNcHeIlyBzxEn7qQVEJ4kyYVTKAEATrNMIoKbPpLaQ=
Received: from CY4PR1101MB2216.namprd11.prod.outlook.com
 (2603:10b6:910:25::17) by CY4PR1101MB2296.namprd11.prod.outlook.com
 (2603:10b6:910:1a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Wed, 3 Jun
 2020 02:09:51 +0000
Received: from CY4PR1101MB2216.namprd11.prod.outlook.com
 ([fe80::9c64:9b0a:fde3:b715]) by CY4PR1101MB2216.namprd11.prod.outlook.com
 ([fe80::9c64:9b0a:fde3:b715%5]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 02:09:51 +0000
From:   "Huang, Kai" <kai.huang@intel.com>
To:     "kirill@shutemov.name" <kirill@shutemov.name>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wad@chromium.org" <wad@chromium.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
Thread-Topic: [RFC 02/16] x86/kvm: Introduce KVM memory protection feature
Thread-Index: AQHWMDfmobu4KV6DMkmIy0XuK+plk6i46ZCAgAAEoYCAAnnKAIAAPEWAgAqTbwA=
Date:   Wed, 3 Jun 2020 02:09:51 +0000
Message-ID: <0cd53be8abede7e82a68c32b1d8b0e4ca6f24a05.camel@intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
         <20200522125214.31348-3-kirill.shutemov@linux.intel.com>
         <87d06s83is.fsf@vitty.brq.redhat.com> <20200525151525.qmfvzxbl7sq46cdq@box>
         <20200527050350.GK31696@linux.intel.com>
         <87eer56abe.fsf@vitty.brq.redhat.com>
In-Reply-To: <87eer56abe.fsf@vitty.brq.redhat.com>
Accept-Language: en-NZ, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: shutemov.name; dkim=none (message not signed)
 header.d=none;shutemov.name; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b969c4a-359b-46f6-9403-08d807633330
x-ms-traffictypediagnostic: CY4PR1101MB2296:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2296F34F9FC6E4B97FA3B3B3F7880@CY4PR1101MB2296.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 04238CD941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cbtW1qNtbDRyz+cziHF7HHRl7mUu16LnaqN9JnfOrinuWw5zd5yEMquYB0lXEqxjpCXRBbeKbinmrUZgsZn9T/ctLaxyY+q7FVm4AINR9wy+7nmW+ZACPkRpD1mktSL8NhLXkUeHCcVZA5AC2qjpQ/D/v6BhUv8AMXcfpwhJLS+dK1R2XvM1a15qW6qaxyjInBIy/5RxXyR8Y8obx2uQ5PcGAJWayH3IHErp+TnY4uU4GnzK6dyou3vPC0cnJO/RjHbV67tdJp3Wm143mPSUJG9s0PN8kLrPWdVwofrbRsjMHmZjpzLrYrkQ/wtRt4NpTwqYKhNQ8xdi7jt9+fylqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2216.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(376002)(366004)(39850400004)(346002)(136003)(26005)(86362001)(2906002)(36756003)(186003)(478600001)(6506007)(110136005)(316002)(71200400001)(5660300002)(54906003)(2616005)(66446008)(8936002)(7416002)(83380400001)(6512007)(4326008)(66946007)(64756008)(6486002)(76116006)(91956017)(66476007)(66556008)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bROksxzbTfp83Rb8sCOl1pxH+gUtPnRhGFV9Gsgz5yP8krbT6ebsXFasdDkiwQ6ooYBLOrQtcJ0EUjCCes7v4egYKRKLHJdmul/MQyje/YFsl//emzvW6ISyNJLegj0d2NBByoRZeWbIXJu0c+i377n3ffQ7i2lWWQwl8Ma5UmGSvnYcoBagxqNS03BTr6KVI4QVv/ahd5E66vK9Yta4fpizltkpWCXqJncg1zKvf8FgM+SVO14LTFstmKhukrHRTCBrSGhcx2Q9/wdbYhtyoRWUKl56U6ijeg5dYBVtTPk557enIfaDl9q+EH7OSKGg3p/ex26OPicdJUcc1HF+PsRzkoLk2h5fk3PA0NIy+lartfZyShGexmcv2czIswlcTxbFTB0b4A01VOLB3PiCRaKf6An7Ji/9NxsW46fgJWH2+Yxs5Yvn/3T/k4JaGpDxBLIpdSRB9T1HCANwwPpVExqUSvfzUvEEiVYO79b+5eo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C5F792F5855A44C80818142B624C311@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b969c4a-359b-46f6-9403-08d807633330
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2020 02:09:51.3734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pWyLKNl2ICA6eGKUu6vGjJyKiFdbzT1xg8Sma5fNhXfKcP9Y8ZZFBBUw+xyfgwjP2F6ib1dS2vxb3AHmHtRemw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2296
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDEwOjM5ICswMjAwLCBWaXRhbHkgS3V6bmV0c292IHdyb3Rl
Og0KPiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29t
PiB3cml0ZXM6DQo+IA0KPiA+IE9uIE1vbiwgTWF5IDI1LCAyMDIwIGF0IDA2OjE1OjI1UE0gKzAz
MDAsIEtpcmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+IE9uIE1vbiwgTWF5IDI1LCAyMDIw
IGF0IDA0OjU4OjUxUE0gKzAyMDAsIFZpdGFseSBLdXpuZXRzb3Ygd3JvdGU6DQo+ID4gPiA+ID4g
QEAgLTcyNyw2ICs3MzQsMTUgQEAgc3RhdGljIHZvaWQgX19pbml0IGt2bV9pbml0X3BsYXRmb3Jt
KHZvaWQpDQo+ID4gPiA+ID4gIHsNCj4gPiA+ID4gPiAgCWt2bWNsb2NrX2luaXQoKTsNCj4gPiA+
ID4gPiAgCXg4Nl9wbGF0Zm9ybS5hcGljX3Bvc3RfaW5pdCA9IGt2bV9hcGljX2luaXQ7DQo+ID4g
PiA+ID4gKw0KPiA+ID4gPiA+ICsJaWYgKGt2bV9wYXJhX2hhc19mZWF0dXJlKEtWTV9GRUFUVVJF
X01FTV9QUk9URUNURUQpKSB7DQo+ID4gPiA+ID4gKwkJaWYgKGt2bV9oeXBlcmNhbGwwKEtWTV9I
Q19FTkFCTEVfTUVNX1BST1RFQ1RFRCkpIHsNCj4gPiA+ID4gPiArCQkJcHJfZXJyKCJGYWlsZWQg
dG8gZW5hYmxlIEtWTSBtZW1vcnkNCj4gPiA+ID4gPiBwcm90ZWN0aW9uXG4iKTsNCj4gPiA+ID4g
PiArCQkJcmV0dXJuOw0KPiA+ID4gPiA+ICsJCX0NCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gKwkJ
bWVtX3Byb3RlY3RlZCA9IHRydWU7DQo+ID4gPiA+ID4gKwl9DQo+ID4gPiA+ID4gIH0NCj4gPiA+
ID4gDQo+ID4gPiA+IFBlcnNvbmFsbHksIEknZCBwcmVmZXIgdG8gZG8gdGhpcyB2aWEgc2V0dGlu
ZyBhIGJpdCBpbiBhIEtWTS1zcGVjaWZpYw0KPiA+ID4gPiBNU1IgaW5zdGVhZC4gVGhlIGJlbmVm
aXQgaXMgdGhhdCB0aGUgZ3Vlc3QgZG9lc24ndCBuZWVkIHRvIHJlbWVtYmVyIGlmDQo+ID4gPiA+
IGl0IGVuYWJsZWQgdGhlIGZlYXR1cmUgb3Igbm90LCBpdCBjYW4gYWx3YXlzIHJlYWQgdGhlIGNv
bmZpZyBtc3IuIE1heQ0KPiA+ID4gPiBjb21lIGhhbmR5IGZvciBlLmcuIGtleGVjL2tkdW1wLg0K
PiA+ID4gDQo+ID4gPiBJIHRoaW5rIHdlIHdvdWxkIG5lZWQgdG8gcmVtZW1iZXIgaXQgYW55d2F5
LiBBY2Nlc3NpbmcgTVNSIGlzIHNvbWV3aGF0DQo+ID4gPiBleHBlbnNpdmUuIEJ1dCwgb2theSwg
SSBjYW4gcmV3b3JrIGl0IE1TUiBpZiBuZWVkZWQuDQo+ID4gDQo+ID4gSSB0aGluayBWaXRhbHkg
aXMgdGFsa2luZyBhYm91dCB0aGUgY2FzZSB3aGVyZSB0aGUga2VybmVsIGNhbid0IGVhc2lseSBn
ZXQNCj4gPiBhdCBpdHMgY2FjaGVkIHN0YXRlLCBlLmcuIGFmdGVyIGJvb3RpbmcgaW50byBhIG5l
dyBrZXJuZWwuICBUaGUga2VybmVsIHdvdWxkDQo+ID4gc3RpbGwgaGF2ZSBhbiBYODZfRkVBVFVS
RSBiaXQgb3Igd2hhdGV2ZXIsIHByb3ZpZGluZyBhIHZpcnR1YWwgTVNSIHdvdWxkIGJlDQo+ID4g
cHVyZWx5IGZvciByYXJlIHNsb3cgcGF0aHMuDQo+ID4gDQo+ID4gVGhhdCBiZWluZyBzYWlkLCBh
IGh5cGVyY2FsbCBwbHVzIENQVUlEIGJpdCBtaWdodCBiZSBiZXR0ZXIsIGUuZy4gdGhhdCdkDQo+
ID4gYWxsb3cgdGhlIGd1ZXN0IHRvIHF1ZXJ5IHRoZSBzdGF0ZSB3aXRob3V0IHJpc2tpbmcgYSAj
R1AuDQo+IA0KPiBXZSBoYXZlIHJkbXNyX3NhZmUoKSBmb3IgdGhhdCEgOi0pIE1TUiAoYW5kIGh5
cGVyY2FsbCB0byB0aGF0IG1hdHRlcikNCj4gc2hvdWxkIGhhdmUgYW4gYXNzb2NpYXRlZCBDUFVJ
RCBmZWF0dXJlIGJpdCBvZiBjb3Vyc2UuDQo+IA0KPiBZZXMsIGh5cGVyY2FsbCArIENQVUlEIHdv
dWxkIGRvIGJ1dCBub3JtYWxseSB3ZSB0cmVhdCBDUFVJRCBkYXRhIGFzDQo+IHN0YXRpYyBhbmQg
aW4gdGhpcyBjYXNlIHdlJ2xsIG1ha2UgaXQgYSBkeW5hbWljYWxseSBmbGlwcGluZw0KPiBiaXQu
IEVzcGVjaWFsbHkgaWYgd2UgaW50cm9kdWNlICdLVk1fSENfRElTQUJMRV9NRU1fUFJPVEVDVEVE
JyBsYXRlci4NCg0KTm90IHN1cmUgd2h5IGlzIEtWTV9IQ19ESVNBQkxFX01FTV9QUk9URUNURUQg
bmVlZGVkPw0KDQo+IA0KPiA+ID4gTm90ZSwgdGhhdCB3ZSBjYW4gYXZvaWQgdGhlIGVuYWJsaW5n
IGFsZ290aGVyLCBpZiB3ZSBtb2RpZnkgQklPUyB0byBkZWFsDQo+ID4gPiB3aXRoIHByaXZhdGUv
c2hhcmVkIG1lbW9yeS4gQ3VycmVudGx5IEJJT1MgZ2V0IHN5c3RlbSBjcmFzaCBpZiB3ZSBlbmFi
bGUNCj4gPiA+IHRoZSBmZWF0dXJlIGZyb20gdGltZSB6ZXJvLg0KPiA+IA0KPiA+IFdoaWNoIHdv
dWxkIG1lc2ggYmV0dGVyIHdpdGggYSBDUFVJRCBmZWF0dXJlIGJpdC4NCj4gPiANCj4gDQo+IEFu
ZCBtYXliZSBldmVuIGhlbHAgdXMgdG8gcmVzb2x2ZSAncmVib290JyBwcm9ibGVtLg0KDQpJTU8g
d2UgY2FuIGFzayBRZW11IHRvIGNhbGwgaHlwZXJjYWxsIHRvICdlbmFibGUnIG1lbW9yeSBwcm90
ZWN0aW9uIHdoZW4NCmNyZWF0aW5nIFZNLCBhbmQgZ3Vlc3Qga2VybmVsICpxdWVyaWVzKiB3aGV0
aGVyIGl0IGlzIHByb3RlY3RlZCB2aWEgQ1BVSUQNCmZlYXR1cmUgYml0Lg0KDQo=
