Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7799853A02F
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 11:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350989AbiFAJVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 05:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350194AbiFAJVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 05:21:17 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCBD5642F;
        Wed,  1 Jun 2022 02:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1654075276; x=1685611276;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=jW7h6+CGuvQNzV1y+ZZYmfWxXfIVM8X7oDJPmxBnKYI=;
  b=Ekxx59Pz25aUW6/jZMQRgexLtmA33qKJJ7CG4NP1UeFt2X2YZghnchEG
   bQnDC9Z3RTUgh5TTcm2D+YHXCcVcsfyxEqBYgTvMTzLZ/9qGHsSeTRmhO
   Ay1cgSLP9AeZlwA0kYhi2rkvJM5Qw3B+YfJVTt/0hdej2RHy7nU1VkXBb
   k=;
X-IronPort-AV: E=Sophos;i="5.91,266,1647302400"; 
   d="scan'208";a="224274785"
Subject: RE: ...\n
Thread-Topic: ...\n
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 01 Jun 2022 09:21:01 +0000
Received: from EX13D33EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id 9FA70A27E0;
        Wed,  1 Jun 2022 09:21:00 +0000 (UTC)
Received: from EX13D32EUC003.ant.amazon.com (10.43.164.24) by
 EX13D33EUC001.ant.amazon.com (10.43.164.13) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 1 Jun 2022 09:20:59 +0000
Received: from EX13D32EUC003.ant.amazon.com ([10.43.164.24]) by
 EX13D32EUC003.ant.amazon.com ([10.43.164.24]) with mapi id 15.00.1497.036;
 Wed, 1 Jun 2022 09:20:59 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC:     "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Thread-Index: AQHYdPhkNX+wk5QumkS6hY2ybmOpva05D+WAgAABcbCAAQ0lgIAAE6AAgAALn5CAAAOKgIAABfXw
Date:   Wed, 1 Jun 2022 09:20:58 +0000
Message-ID: <b0a029b784fe4648b1351042fdca6e11@EX13D32EUC003.ant.amazon.com>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
 <87r148olol.fsf@redhat.com>
 <48edf12807254a2b86e339b26873bf00@EX13D32EUC003.ant.amazon.com>
 <2bdfde74-da27-667d-d1c4-3b17147cecce@redhat.com>
In-Reply-To: <2bdfde74-da27-667d-d1c4-3b17147cecce@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.66]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-15.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYW9sbyBCb256aW5pIDxwYm9u
emluaUByZWRoYXQuY29tPg0KPiBTZW50OiAwMSBKdW5lIDIwMjIgMDk6NTcNCj4gVG86IER1cnJh
bnQsIFBhdWwgPHBkdXJyYW50QGFtYXpvbi5jby51az47IFZpdGFseSBLdXpuZXRzb3YgPHZrdXpu
ZXRzQHJlZGhhdC5jb20+OyBQZXRlciBaaWpsc3RyYQ0KPiA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+
DQo+IENjOiBBbGxpc3RlciwgSmFjayA8amFsbGlzdGVAYW1hem9uLmNvbT47IGJwQGFsaWVuOC5k
ZTsgZGlhcG9wQGFtYXpvbi5jby51azsgaHBhQHp5dG9yLmNvbTsNCj4gam1hdHRzb25AZ29vZ2xl
LmNvbTsgam9yb0A4Ynl0ZXMub3JnOyBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOw0KPiBtZXRpa2F5YUBhbWF6b24uY28udWs7IG1pbmdvQHJlZGhhdC5j
b207IHJrcmNtYXJAcmVkaGF0LmNvbTsgc2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbTsN
Cj4gdGdseEBsaW51dHJvbml4LmRlOyB3YW5wZW5nbGlAdGVuY2VudC5jb207IHg4NkBrZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJFOiBbRVhURVJOQUxdLi4uXG4NCj4gDQo+IENBVVRJT046IFRoaXMg
ZW1haWwgb3JpZ2luYXRlZCBmcm9tIG91dHNpZGUgb2YgdGhlIG9yZ2FuaXphdGlvbi4gRG8gbm90
IGNsaWNrIGxpbmtzIG9yIG9wZW4NCj4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBjYW4gY29uZmly
bSB0aGUgc2VuZGVyIGFuZCBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUuDQo+IA0KPiANCj4gDQo+
IE9uIDYvMS8yMiAxMDo1NCwgRHVycmFudCwgUGF1bCB3cm90ZToNCj4gPiBUaGF0IGlzIGV4YWN0
bHkgdGhlIGNhc2UuIFRoaXMgaXMgbm90ICdzb21lIGhhcmUtYnJhaW5lZCBtb25leQ0KPiA+IHNj
aGVtZSc7IHRoZXJlIGlzIGdlbnVpbmUgY29uY2VybiB0aGF0IG1vdmluZyBhIFZNIGZyb20gb2xk
IGgvdyB0bw0KPiA+IG5ldyBoL3cgbWF5IGNhdXNlIGl0IHRvIHJ1biAndG9vIGZhc3QnLCBicmVh
a2luZyBhbnkgc3VjaCBjYWxpYnJhdGlvbg0KPiA+IGRvbmUgYnkgdGhlIGd1ZXN0IE9TL2FwcGxp
Y2F0aW9uLiBJIGFsc28gZG9uJ3QgaGF2ZSBhbnkgcmVhbC13b3JsZA0KPiA+IGV4YW1wbGVzLCBi
dXQgYnVncyBtYXkgd2VsbCBiZSByZXBvcnRlZCBhbmQgaGF2aW5nIGEgbGV2ZXIgdG8gYWRkcmVz
cw0KPiA+IHRoZW0gaXMgSU1PIGEgZ29vZCBpZGVhLiBIb3dldmVyLCBJIGFsc28gYWdyZWUgd2l0
aCBQYW9sbyB0aGF0IEtWTQ0KPiA+IGRvZXNuJ3QgcmVhbGx5IG5lZWQgdG8gYmUgZG9pbmcgdGhp
cyB3aGVuIHRoZSBWTU0gY291bGQgZG8gdGhlIGpvYg0KPiA+IHVzaW5nIGNwdWZyZXEsIHNvIHdl
J2xsIHB1cnN1ZSB0aGF0IG9wdGlvbiBpbnN0ZWFkLiAoRldJVyB0aGUgcmVhc29uDQo+ID4gZm9y
IGludm9sdmluZyBLVk0gd2FzIHRvIGRvIHRoZSBmcmVxIGFkanVzdG1lbnQgcmlnaHQgYmVmb3Jl
IGVudGVyaW5nDQo+ID4gdGhlIGd1ZXN0IGFuZCB0aGVuIHJlbW92ZSB0aGUgY2FwIHJpZ2h0IGFm
dGVyIFZNRVhJVCkuDQo+IA0KPiBCdXQgaWYgc28sIHlvdSBzdGlsbCB3b3VsZCBzdWJtaXQgdGhl
IGZ1bGwgZmVhdHVyZSwgd291bGRuJ3QgeW91Pw0KPiANCg0KWWVzOyB0aGUgY29tbWl0IG1lc3Nh
Z2Ugc2hvdWxkIGhhdmUgYXQgbGVhc3Qgc2FpZCB0aGF0IHdlJ2QgZm9sbG93IHVwLi4uIGJ1dCBh
IGZ1bGwgc2VyaWVzIHdvdWxkIGhhdmUgYmVlbiBhIGJldHRlciBpZGVhLg0KDQo+IFBhdWwsIHRo
YW5rcyBmb3IgY2hpbWluZyBpbiwgYW5kIHNvcnJ5IGZvciBsZWF2aW5nIHlvdSBvdXQgb2YgdGhl
IGxpc3QNCj4gb2YgcGVvcGxlIHRoYXQgY2FuIGhlbHAgSmFjayB3aXRoIGhpcyB1cHN0cmVhbWlu
ZyBlZmZvcnRzLiAgOikNCj4gDQoNCk5QLg0KDQogIFBhdWwNCg0KPiBQYW9sbw0KDQo=
