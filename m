Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD911EEAE9
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 21:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgFDTJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 15:09:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:26077 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgFDTJv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 15:09:51 -0400
IronPort-SDR: 7FlRlmwCsmBXMr9qKWrixp5OK/aVe6t/QCCxj7Fypcos92WVR1wn2CJmF/zcLrBQZ6UtSpSMVi
 U9kI1Lfbybpg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2020 12:09:48 -0700
IronPort-SDR: lMp2hOkWz6usfz+m7iPhHl1UEKMeB9mFOsx0YYcOuEX2zWW+J/lqKP1zvOQyt56FERjgjuttNB
 frMA8YhO5KZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,472,1583222400"; 
   d="scan'208";a="258448245"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga007.jf.intel.com with ESMTP; 04 Jun 2020 12:09:48 -0700
Received: from fmsmsx115.amr.corp.intel.com (10.18.116.19) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 12:09:47 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx115.amr.corp.intel.com (10.18.116.19) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 4 Jun 2020 12:09:47 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 4 Jun 2020 12:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwokFZFxKYqWHO4q0FzOhnXM2m5rLaJopnAKHJzjb3FBJa3eC0AA0z7hhW++oIkKZ3KWHldHqI7RA6QIu9rw4eiMPaOjeML9CZFFcPyw1Yiw6xx9KZhA1g3oBKflpb86LcpE/2dvPLwxG8/OaSzQPjav0mTU4Mvz/IveJVjEjuduS9BAv7yJTKwti8RzpHq9XjCS+0f3eaB++4zfpUWKbeoAQxNMJRJfI+UBxAQKYyxYDrxz6dFPhlnrmy43noaE5VbR4h0D+c4M82Wmv/PQ3nVHlQ5frUBGqnsNKHWVfzp/tEzyzeAn790BWeS3MQIv26vs4LM3uy4fiX0gwt+wQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyjElbarlQxEIRQrs7bC+lHKz/l5WImqx07aaMhW4jI=;
 b=BEsZgnob86qS31B40LT5YWB7vECvBY6ahOBNlpA/b2s8xnp7ynqMnQAcbgogKES/nG80mQbTRvJt0e724d/j+kppTUnsIwwZsreZ1hZUvAlBQtlgq1x0RPO/PJ3qQm26vvusHe9+R8RCKbDlf3/dQWD5SlZhuEaW/FqYcJhgARAPVzLGYMWJcIyfGRKMAGfFdtEZTPAS8mwhre2nW/GwIn+VqS7yYvMJoujPWJyg+HIUeKraTeczIplbDpMCagQ62ebIV1wlKBsVKJmLf0l3tOJYAmgOyXIKeWbPP7urKShK+c5klDMXuGpwm/sD85oiCG+/nqFzx+tTnfe936oO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EyjElbarlQxEIRQrs7bC+lHKz/l5WImqx07aaMhW4jI=;
 b=Dt9awqU8DkvRlnD+pTiohgSnAZB9olXeA6BaB0OBmRCTeDhVskLjNdP1UfORDSyqY4yIoDv8eK3a6VwtVEgR5WgkNYrbcZLm0mtq51IOo1v7SyhVNCr8bGxq/9Vmf1w1BD8WnojkWyXOID58A2MRkJYLfEUV9e+Crcf26EPpwyg=
Received: from BY5PR11MB3863.namprd11.prod.outlook.com (2603:10b6:a03:18a::28)
 by BY5PR11MB4024.namprd11.prod.outlook.com (2603:10b6:a03:192::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 19:09:20 +0000
Received: from BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::ec4e:a2a2:f273:9074]) by BY5PR11MB3863.namprd11.prod.outlook.com
 ([fe80::ec4e:a2a2:f273:9074%6]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 19:09:20 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Will Deacon <will@kernel.org>
CC:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David Rientjes" <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Thread-Topic: [RFC 00/16] KVM protected memory extension
Thread-Index: AQHWOoe1lM84g0zHPkupUbQ0L9bpcKjIp0WAgAAq94A=
Date:   Thu, 4 Jun 2020 19:09:19 +0000
Message-ID: <6DBAB6A4-A1F9-40E9-B81B-74182DDCF939@intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200604161523.39962919@why> <20200604154835.GE30223@linux.intel.com>
 <20200604163532.GE3650@willie-the-truck>
In-Reply-To: <20200604163532.GE3650@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [73.223.163.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 412d89c5-8dba-4696-ad7f-08d808bac903
x-ms-traffictypediagnostic: BY5PR11MB4024:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4024C19399DFD3160C1620739A890@BY5PR11MB4024.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 04244E0DC5
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IcZGAGRmfXiRmT5xO9ro1vvw966H6a7MSxQvbE3fk+u6fCwLwA7NAJEFwpg0D5OmeDXfP0qZ4H54uYO3+5BdSYGXKuIwsBo6b3Y16lGtle/wSPVb/OIStF6jCl54/s6eajI7ThQYySW84rq2q96jlcGwT7j9Vy7GhqjGzIEqtZcyE4ya9mC5H+8ZWjCHIm0iuODu/Qds84TUMZjF90Sw7eIM+M428gLBseQP1cjsw8SRvONtMSoGUfVcwMArPu7AEqxbZw+hi69p+Pe4Shc4npUmpSjlkBl23R9/bUm83dtIwnJd4Xe6AfJDFxmsGMM502xmcdbVww4N9gHVoHurX/zreokhhVOpwU1WBOeHSfcFmspR9Ytzx3l1OcsTPx2Gt5pRguJKTSSRv44hI1VARg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3863.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(366004)(39860400002)(346002)(376002)(26005)(316002)(8936002)(54906003)(2906002)(6486002)(71200400001)(6916009)(186003)(2616005)(8676002)(7416002)(6512007)(36756003)(83380400001)(66946007)(76116006)(66446008)(478600001)(4326008)(64756008)(66556008)(966005)(33656002)(66476007)(6506007)(86362001)(5660300002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: au/3h/VtYKBl1N3PdLsuSGwHELbv8j4lDfNoIbbTkGrzl9UfTkuBSy3mHE1EEHpbBw3Ypt03kRpitLDzueBrWPrzksS1yFbpx2uND3U4Kh2J5+AW+GZECv8Jsfozx+fQZB0WVO8j9hOW8wFVH2Jpb3v5AQ9ONMUGg4Bs37vz9jGNnz56Yne5m4o47aak4xmYCH9vSw05YpbdB2a1xZ+qhsKn3CZBBiiaN/ZGUNmfbzYFrC8pNtN+KFX0km0Bl4AEOfkSRMR6PSL0ec5TxYvJ1hDrGxAIte/q4tNJ2hR6B1C89IYKVPs55+madoRjuUFgUUiN/4g5HqA6ZZ320uVTULq0wv/RUI6DOGl35YoxZoE8Qt6F0x8vtVIly2cJSFsHz1kiwa8g3lURXnnnPHpN6TUBuJJcfaU7cO2z7wz8OtipQT3uLpn1w37i/aqA1PU1J5sqVoqA/UGKyal9RSUMc1lBiE/l15168EmwEGT3TvQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9169E2FF5211C1499CE96EF62ECC4A13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 412d89c5-8dba-4696-ad7f-08d808bac903
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2020 19:09:19.9417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EvQ8mtohKyHw4x3FHOp3hy0LK60CYI2H/CF7vmaTw6BaKmhFdx5M5uJvQTRTTARDAUabu6ebVTTm8pivPx7xTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4024
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiANCj4gT24gSnVuIDQsIDIwMjAsIGF0IDk6MzUgQU0sIFdpbGwgRGVhY29uIDx3aWxsQGtlcm5l
bC5vcmc+IHdyb3RlOg0KPiANCj4gSGkgU2VhbiwNCj4gDQo+IE9uIFRodSwgSnVuIDA0LCAyMDIw
IGF0IDA4OjQ4OjM1QU0gLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+PiBPbiBU
aHUsIEp1biAwNCwgMjAyMCBhdCAwNDoxNToyM1BNICswMTAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6
DQo+Pj4gT24gRnJpLCAyMiBNYXkgMjAyMCAxNTo1MTo1OCArMDMwMA0KPj4+ICJLaXJpbGwgQS4g
U2h1dGVtb3YiIDxraXJpbGxAc2h1dGVtb3YubmFtZT4gd3JvdGU6DQo+Pj4gDQo+Pj4+ID09IEJh
Y2tncm91bmQgLyBQcm9ibGVtID09DQo+Pj4+IA0KPj4+PiBUaGVyZSBhcmUgYSBudW1iZXIgb2Yg
aGFyZHdhcmUgZmVhdHVyZXMgKE1LVE1FLCBTRVYpIHdoaWNoIHByb3RlY3QgZ3Vlc3QNCj4+Pj4g
bWVtb3J5IGZyb20gc29tZSB1bmF1dGhvcml6ZWQgaG9zdCBhY2Nlc3MuIFRoZSBwYXRjaHNldCBw
cm9wb3NlcyBhIHB1cmVseQ0KPj4+PiBzb2Z0d2FyZSBmZWF0dXJlIHRoYXQgbWl0aWdhdGVzIHNv
bWUgb2YgdGhlIHNhbWUgaG9zdC1zaWRlIHJlYWQtb25seQ0KPj4+PiBhdHRhY2tzLg0KPj4+PiAN
Cj4+Pj4gDQo+Pj4+ID09IFdoYXQgZG9lcyB0aGlzIHNldCBtaXRpZ2F0ZT8gPT0NCj4+Pj4gDQo+
Pj4+IC0gSG9zdCBrZXJuZWwg4oCdYWNjaWRlbnRhbOKAnSBhY2Nlc3MgdG8gZ3Vlc3QgZGF0YSAo
dGhpbmsgc3BlY3VsYXRpb24pDQo+Pj4+IA0KPj4+PiAtIEhvc3Qga2VybmVsIGluZHVjZWQgYWNj
ZXNzIHRvIGd1ZXN0IGRhdGEgKHdyaXRlKGZkLCAmZ3Vlc3RfZGF0YV9wdHIsIGxlbikpDQo+Pj4+
IA0KPj4+PiAtIEhvc3QgdXNlcnNwYWNlIGFjY2VzcyB0byBndWVzdCBkYXRhIChjb21wcm9taXNl
ZCBxZW11KQ0KPj4+PiANCj4+Pj4gPT0gV2hhdCBkb2VzIHRoaXMgc2V0IE5PVCBtaXRpZ2F0ZT8g
PT0NCj4+Pj4gDQo+Pj4+IC0gRnVsbCBob3N0IGtlcm5lbCBjb21wcm9taXNlLiAgS2VybmVsIHdp
bGwganVzdCBtYXAgdGhlIHBhZ2VzIGFnYWluLg0KPj4+PiANCj4+Pj4gLSBIYXJkd2FyZSBhdHRh
Y2tzDQo+Pj4gDQo+Pj4gSnVzdCBhcyBhIGhlYWRzIHVwLCB3ZSAodGhlIEFuZHJvaWQga2VybmVs
IHRlYW0pIGFyZSBjdXJyZW50bHkNCj4+PiBpbnZvbHZlZCBpbiBzb21ldGhpbmcgcHJldHR5IHNp
bWlsYXIgZm9yIEtWTS9hcm02NCBpbiBvcmRlciB0byBicmluZw0KPj4+IHNvbWUgbGV2ZWwgb2Yg
Y29uZmlkZW50aWFsaXR5IHRvIGd1ZXN0cy4NCj4+PiANCj4+PiBUaGUgbWFpbiBpZGVhIGlzIHRv
IGRlLXByaXZpbGVnZSB0aGUgaG9zdCBrZXJuZWwgYnkgd3JhcHBpbmcgaXQgaW4gaXRzDQo+Pj4g
b3duIG5lc3RlZCBzZXQgb2YgcGFnZSB0YWJsZXMgd2hpY2ggYWxsb3dzIHVzIHRvIHJlbW92ZSBt
ZW1vcnkNCj4+PiBhbGxvY2F0ZWQgdG8gZ3Vlc3RzIG9uIGEgcGVyLXBhZ2UgYmFzaXMuIFRoZSBj
b3JlIGh5cGVydmlzb3IgcnVucyBtb3JlDQo+Pj4gb3IgbGVzcyBpbmRlcGVuZGVudGx5IGF0IGl0
cyBvd24gcHJpdmlsZWdlIGxldmVsLiBJdCBzdGlsbCBpcyBLVk0NCj4+PiB0aG91Z2gsIGFzIHdl
IGRvbid0IGludGVuZCB0byByZWludmVudCB0aGUgd2hlZWwuDQo+Pj4gDQo+Pj4gV2lsbCBoYXMg
d3JpdHRlbiBhIG11Y2ggbW9yZSBsaW5nby1oZWF2eSBkZXNjcmlwdGlvbiBoZXJlOg0KPj4+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bWFybS8yMDIwMDMyNzE2NTkzNS5HQTgwNDhAd2lsbGll
LXRoZS10cnVjay8NCj4+IA0KDQpXZSAoSW50ZWwgdmlydHVhbGl6YXRpb24gdGVhbSkgYXJlIGFs
c28gd29ya2luZyBvbiBhIHNpbWlsYXIgdGhpbmcsIHByb3RvdHlwaW5nIHRvIG1lZXQgc3VjaCBy
ZXF1aXJlbWVudHMsIGkuLmUgInNvbWUgbGV2ZWwgb2YgY29uZmlkZW50aWFsaXR5IHRvIGd1ZXN0
c+KAnS4gTGludXgvS1ZNIGlzIHRoZSBob3N0LCBhbmQgdGhlIEtpcmlsbOKAmXMgcGF0Y2hlcyBh
cmUgaGVscGZ1bCB3aGVuIHJlbW92aW5nIHRoZSBtYXBwaW5ncyBmcm9tIHRoZSBob3N0IHRvIGFj
aGlldmUgbWVtb3J5IGlzb2xhdGlvbiBvZiBhIGd1ZXN0LiBCdXQsIGl04oCZcyBub3QgZWFzeSB0
byBwcm92ZSB0aGVyZSBhcmUgbm8gb3RoZXIgbWFwcGluZ3MuDQoNClRvIHJhaXNlIHRoZSBsZXZl
bCBvZiBzZWN1cml0eSwgb3VyIGlkZWEgaXMgdG8gZGUtcHJpdmlsZWdlIHRoZSBob3N0IGtlcm5l
bCBqdXN0IHRvIGVuZm9yY2UgbWVtb3J5IGlzb2xhdGlvbiB1c2luZyBFUFQgKEV4dGVuZGVkIFBh
Z2UgVGFibGUpIHRoYXQgdmlydHVhbGl6ZXMgZ3Vlc3QgKHRoZSBob3N0IGtlcm5lbCBpbiB0aGlz
IGNhc2UpIHBoeXNpY2FsIG1lbW9yeTsgYWxtb3N0IGV2ZXJ5dGhpbmcgaXMgcGFzc3Rocm91Z2gu
IEFuZCB0aGUgRVBUIGZvciB0aGUgaG9zdCBrZXJuZWwgZXhjbHVkZXMgdGhlIG1lbW9yeSBmb3Ig
dGhlIGd1ZXN0KHMpIHRoYXQgaGFzIGNvbmZpZGVudGlhbCBpbmZvLiBTbywgdGhlIGhvc3Qga2Vy
bmVsIHNob3VsZG7igJl0IGNhdXNlIFZNIGV4aXRzIGFzIGxvbmcgYXMgaXTigJlzIGJlaGF2aW5n
IHdlbGwgKENQVUlEIHN0aWxsIGNhdXNlcyBhIFZNIGV4aXQsIHRob3VnaCkuIA0KDQpXaGVuIHRo
ZSBjb250cm9sIGVudGVycyBLVk0sIHdlIGdvIGJhY2sgdG8gcHJpdmlsZWdlZCAoaHlwZXJ2aXNv
ciBvciByb290KSBtb2RlLCBhbmQgaXQgd29ya3MgYXMgZG9lcyB0b2RheS4gT25jZSBhIFZNIGV4
aXQgaGFwcGVucywgd2Ugd2lsbCBzdGF5IGluIHRoZSByb290IG1vZGUgYXMgbG9uZyBhcyB0aGUg
ZXhpdCBjYW4gYmUgaGFuZGxlZCB3aXRoaW4gS1ZNLiBJZiB3ZSBuZWVkIHRvIGRlcGVuZCBvbiB0
aGUgaG9zdCBrZXJuZWwsIHdlIGRlLXByaXZpbGVnZSB0aGUgaG9zdCBrZXJuZWwgKGkuZS4gVk0g
ZW50ZXIpLiBZZXMsIGl0IHNvdW5kcyB1Z2x5Lg0KDQpUaGVyZSBhcmUgY2xlYW5lciAoYnV0IG1v
cmUgZXhwZW5zaXZlKSBhcHByb2FjaGVzLCBhbmQgd2UgYXJlIGNvbGxlY3RpbmcgZGF0YSBhdCB0
aGlzIHBvaW50LiBGb3IgZXhhbXBsZSwgd2UgY291bGQgcnVuIHRoZSBob3N0IGtlcm5lbCAobGlr
ZSBYZW4gZG9tMCkgb24gdG9wIG9mIGEgdGhpbj8gaHlwZXJ2aXNvciB0aGF0IGNvbnNpc3RzIG9m
IEtWTSBhbmQgbWluaW1hbGx5IGNvbmZpZ3VyZWQgTGludXguICANCg0KPiANCj4+IElJVUMsIGlu
IHRoaXMgbW9kZSwgdGhlIGhvc3Qga2VybmVsIHJ1bnMgYXQgRUwxPyAgQW5kIHRvIHN3aXRjaCB0
byBhIGd1ZXN0DQo+PiBpdCBoYXMgdG8gYm91bmNlIHRocm91Z2ggRUwyLCB3aGljaCBpcyBLVk0s
IG9yIGF0IGxlYXN0IGEgY2h1bmsgb2YgS1ZNPw0KPj4gSSBhc3N1bWUgdGhlIEVMMS0+RUwyLT5F
TDEgc3dpdGNoIGlzIGRvbmUgYnkgdHJhcHBpbmcgYW4gZXhjZXB0aW9uIG9mIHNvbWUNCj4+IGZv
cm0/DQo+IA0KPiBZZXMsIGFuZCB0aGlzIGlzIGFjdHVhbGx5IHRoZSB3YXkgdGhhdCBLVk0gd29y
a3Mgb24gc29tZSBBcm0gQ1BVcyB0b2RheSwNCj4gYXMgdGhlIG9yaWdpbmFsIHZpcnR1YWxpc2F0
aW9uIGV4dGVuc2lvbnMgaW4gdGhlIEFybXY4IGFyY2hpdGVjdHVyZSBkbw0KPiBub3QgbWFrZSBp
dCBwb3NzaWJsZSB0byBydW4gdGhlIGtlcm5lbCBkaXJlY3RseSBhdCBFTDIgKGZvciBleGFtcGxl
LCB0aGVyZQ0KPiBpcyBvbmx5IG9uZSBwYWdlLXRhYmxlIGJhc2UgcmVnaXN0ZXIpLiBUaGlzIHdh
cyBsYXRlciBhZGRyZXNzZWQgaW4gdGhlDQo+IGFyY2hpdGVjdHVyZSBieSB0aGUgIlZpcnR1YWxp
c2F0aW9uIEhvc3QgRXh0ZW5zaW9ucyAoVkhFKSIsIGFuZCBzbyBLVk0NCj4gc3VwcG9ydHMgYm90
aCBvcHRpb25zLg0KPiANCj4gV2l0aCBub24tVkhFIHRvZGF5LCB0aGVyZSBpcyBhIHNtYWxsIGFt
b3VudCBvZiAid29ybGQgc3dpdGNoIiBjb2RlIGF0DQo+IEVMMiB3aGljaCBpcyBpbnN0YWxsZWQg
YnkgdGhlIGhvc3Qga2VybmVsIGFuZCBwcm92aWRlcyBhIHdheSB0byB0cmFuc2l0aW9uDQo+IGJl
dHdlZW4gdGhlIGhvc3QgYW5kIHRoZSBndWVzdC4gSWYgdGhlIGhvc3QgbmVlZHMgdG8gZG8gc29t
ZXRoaW5nIGF0IEVMMg0KPiAoZS5nLiBwcml2aWxlZ2VkIFRMQiBpbnZhbGlkYXRpb24pLCB0aGVu
IGl0IG1ha2VzIGEgaHlwZXJjYWxsIChIVkMgaW5zdHJ1Y3Rpb24pDQo+IHZpYSB0aGUga3ZtX2Nh
bGxfaHlwKCkgbWFjcm8gKGFuZCB0aGlzIGVuZHMgdXAganVzdCBiZWluZyBhIGZ1bmN0aW9uIGNh
bGwNCj4gZm9yIFZIRSkuDQo+IA0KPj4gSWYgYWxsIG9mIHRoZSBhYm92ZSBhcmUgInllcyIsIGRv
ZXMgS1ZNIGFscmVhZHkgaGF2ZSB0aGUgbmVjZXNzYXJ5IGxvZ2ljIHRvDQo+PiBwZXJmb3JtIHRo
ZSBFTDEtPkVMMi0+RUwxIHN3aXRjaGVzLCBvciBpcyB0aGF0IGJlaW5nIGFkZGVkIGFzIHBhcnQg
b2YgdGhlDQo+PiBkZS1wcml2aWxlZ2luZyBlZmZvcnQ/DQo+IA0KPiBUaGUgbG9naWMgaXMgdGhl
cmUgYXMgcGFydCBvZiB0aGUgbm9uLVZIRSBzdXBwb3J0IGNvZGUsIGJ1dCBpdCdzIG5vdCBncmVh
dA0KPiBmcm9tIGEgc2VjdXJpdHkgYW5nbGUuIEZvciBleGFtcGxlLCB0aGUgZ3Vlc3Qgc3RhZ2Ut
MiBwYWdlLXRhYmxlcyBhcmUgc3RpbGwNCj4gYWxsb2NhdGVkIGJ5IHRoZSBob3N0LCB0aGUgaG9z
dCBoYXMgY29tcGxldGUgYWNjZXNzIHRvIGd1ZXN0IGFuZCBoeXBlcnZpc29yDQo+IG1lbW9yeSAo
aW5jbHVkaW5nIGh5cGVydmlzb3IgdGV4dCkgYW5kIHRoaW5ncyBsaWtlIGt2bV9jYWxsX2h5cCgp
IGFyZSBhIGJpdA0KPiBvZiBhbiBvcGVuIGRvb3IuIFdlJ3JlIHdvcmtpbmcgb24gbWFraW5nIHRo
ZSBFTDIgY29kZSBtb3JlIHNlbGYgY29udGFpbmVkLA0KPiBzbyB0aGF0IGFmdGVyIHRoZSBob3N0
IGhhcyBpbml0aWFsaXNlZCBLVk0sIGl0IGNhbiBzaHV0IHRoZSBkb29yIGFuZCB0aGUNCj4gaHlw
ZXJ2aXNvciBjYW4gaW5zdGFsbCBhIHN0YWdlLTIgdHJhbnNsYXRpb24gb3ZlciB0aGUgaG9zdCwg
d2hpY2ggbGltaXRzIGl0cw0KPiBhY2Nlc3MgdG8gaHlwZXJ2aXNvciBhbmQgZ3Vlc3QgbWVtb3J5
LiBUaGVyZSB3aWxsIGNsZWFybHkgYmUgSU9NTVUgd29yayBhcw0KPiB3ZWxsIHRvIHByZXZlbnQg
RE1BIGF0dGFja3MuDQoNClNvdW5kcyBpbnRlcmVzdGluZy4gDQoNCi0tLSANCkp1bg0KSW50ZWwg
T3BlbiBTb3VyY2UgVGVjaG5vbG9neSBDZW50ZXINCg0KDQoNCg0KDQo=
