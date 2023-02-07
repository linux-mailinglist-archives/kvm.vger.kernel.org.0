Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA46468CD5D
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 04:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjBGDS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 22:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBGDSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 22:18:24 -0500
X-Greylist: delayed 92337 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 06 Feb 2023 19:18:01 PST
Received: from baidu.com (mx20.baidu.com [111.202.115.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF12C4C12
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 19:18:01 -0800 (PST)
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [RFC][PATCH] kvm: i8254: Deactivate APICv when using in-kernel
 PIT re-injection mode.
Thread-Topic: [RFC][PATCH] kvm: i8254: Deactivate APICv when using in-kernel
 PIT re-injection mode.
Thread-Index: AQHZOgrdfR9KGY/2UE+hfXZPxusz5K7C0VGQ
Date:   Tue, 7 Feb 2023 03:17:46 +0000
Message-ID: <4e6c620a5b8348a8bdd47f7f2406aa05@baidu.com>
References: <1675673814-23372-1-git-send-email-lirongqing@baidu.com>
 <8a9deed754bb45cf48fa8562850dadc511bbd4df.camel@redhat.com>
In-Reply-To: <8a9deed754bb45cf48fa8562850dadc511bbd4df.camel@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.206.20]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.54
X-FE-Last-Public-Client-IP: 100.100.100.38
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWF4aW0gTGV2aXRza3kg
PG1sZXZpdHNrQHJlZGhhdC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgRmVicnVhcnkgNiwgMjAyMyA1
OjEwIFBNDQo+IFRvOiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+OyBrdm1Admdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUkZDXVtQQVRDSF0ga3ZtOiBpODI1NDogRGVh
Y3RpdmF0ZSBBUElDdiB3aGVuIHVzaW5nIGluLWtlcm5lbCBQSVQNCj4gcmUtaW5qZWN0aW9uIG1v
ZGUuDQo+IA0KPiBPbiBNb24sIDIwMjMtMDItMDYgYXQgMTY6NTYgKzA4MDAsIGxpcm9uZ3FpbmdA
YmFpZHUuY29tIHdyb3RlOg0KPiA+IEZyb206IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT4NCj4gPg0KPiA+IEludGVsIFZNWCBBUElDdiBhY2NlbGVyYXRlcyBFT0kgd3JpdGUgYW5k
IGRvZXMgbm90IHRyYXAuIFRoaXMgY2F1c2VzDQo+ID4gaW4ta2VybmVsIFBJVCByZS1pbmplY3Rp
b24gbW9kZSB0byBmYWlsIHNpbmNlIGl0IHJlbGllcyBvbiBpcnEtYWNrDQo+ID4gbm90aWZpZXIg
bWVjaGFuaXNtLiBTbywgQVBJQ3YgaXMgYWN0aXZhdGVkIG9ubHkgd2hlbiBpbi1rZXJuZWwgUElU
IGlzDQo+ID4gaW4gZGlzY2FyZCBtb2RlIGUuZy4gdy8gcWVtdSBvcHRpb246DQo+ID4NCj4gPiAJ
LWdsb2JhbCBrdm0tcGl0Lmxvc3RfdGlja19wb2xpY3k9ZGlzY2FyZA0KPiA+DQo+ID4gU2lnbmVk
LW9mZi1ieTogTGkgUm9uZ1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+IC0tLQ0KPiA+
ICBhcmNoL3g4Ni9rdm0vdm14L3ZteC5jIHwgMyArKy0NCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGluZGV4DQo+ID4gZmU1
NjE1Zi4uMTY5NTJhOSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+
ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+IEBAIC04MDUxLDcgKzgwNTEsOCBA
QCBzdGF0aWMgYm9vbCB2bXhfY2hlY2tfYXBpY3ZfaW5oaWJpdF9yZWFzb25zKGVudW0NCj4ga3Zt
X2FwaWN2X2luaGliaXQgcmVhc29uKQ0KPiA+ICAJCQkgIEJJVChBUElDVl9JTkhJQklUX1JFQVNP
Tl9IWVBFUlYpIHwNCj4gPiAgCQkJICBCSVQoQVBJQ1ZfSU5ISUJJVF9SRUFTT05fQkxPQ0tJUlEp
IHwNCj4gPiAgCQkJICBCSVQoQVBJQ1ZfSU5ISUJJVF9SRUFTT05fQVBJQ19JRF9NT0RJRklFRCkg
fA0KPiA+IC0JCQkgIEJJVChBUElDVl9JTkhJQklUX1JFQVNPTl9BUElDX0JBU0VfTU9ESUZJRUQp
Ow0KPiA+ICsJCQkgIEJJVChBUElDVl9JTkhJQklUX1JFQVNPTl9BUElDX0JBU0VfTU9ESUZJRUQp
IHwNCj4gPiArCQkJICBCSVQoQVBJQ1ZfSU5ISUJJVF9SRUFTT05fUElUX1JFSU5KKTsNCj4gPg0K
PiA+ICAJcmV0dXJuIHN1cHBvcnRlZCAmIEJJVChyZWFzb24pOw0KPiA+ICB9DQo+IA0KPiBBRkFJ
SywgQVBJQ3YgaGFzIEVPSSBleGl0aW5nIGJpdG1hcCwgZm9yIHRoaXMgZXhhY3QgcHVycG9zZSwg
aXQgYWxsb3dzIHRvIHRyYXAgb25seQ0KPiBzb21lIHZlY3RvcnMgd2hlbiBFT0kgaXMgcGVyZm9y
bWVkLg0KPiANCj4gS1ZNIHVzZXMgaXQgc28gQVBJQ3Ygc2hvdWxkbid0IG5lZWQgdGhpcyBpbmhp
Yml0IGJ1dCBpdCBpcyBwb3NzaWJsZSB0aGF0IHNvbWV0aGluZw0KPiBnb3QgYnJva2VuLg0KPiAN
Cj4gVGFrZSBhIGxvb2sgYXQgdmNwdV9sb2FkX2VvaV9leGl0bWFwLg0KPiANCg0KVGhhbmtzLCBJ
IHdpbGwgbG9vayBhdCBpdA0KDQoNCi1MaQ0KDQo+IEJlc3QgcmVnYXJkcywNCj4gCU1heGltIExl
dml0c2t5DQoNCg==
