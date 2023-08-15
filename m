Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C3277C937
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 10:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbjHOIOd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 04:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235575AbjHOIOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 04:14:07 -0400
Received: from baidu.com (mx21.baidu.com [220.181.3.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BF8172A
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 01:14:05 -0700 (PDT)
From:   "Gao,Shiyuan" <gaoshiyuan@baidu.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: VMX: Rename vmx_get_max_tdp_level to
 vmx_get_max_ept_level
Thread-Topic: [PATCH] KVM: VMX: Rename vmx_get_max_tdp_level to
 vmx_get_max_ept_level
Thread-Index: AQHZy39C7x6I8MxfvUObePG6ILxg3K/pmSgAgAFr+wA=
Date:   Tue, 15 Aug 2023 07:56:59 +0000
Message-ID: <2AAF3DBB-9257-4ECB-B95E-6C87EAE79DF9@baidu.com>
References: <20230810113853.98114-1-gaoshiyuan@baidu.com>
 <ZNpu9qJOqLxG5pq4@google.com>
In-Reply-To: <ZNpu9qJOqLxG5pq4@google.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.192.197]
Content-Type: text/plain; charset="utf-8"
Content-ID: <83C31D28DCEF4F489880A241AFE26540@internal.baidu.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.17
X-FE-Last-Public-Client-IP: 100.100.100.60
X-FE-Policy-ID: 15:10:21:SYSTEM
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiBPbiBUaHUsIEF1ZyAxMCwgMjAyMywgU2hpeXVhbiBHYW8gd3JvdGU6DQo+ID4gSW4gdm14LCBl
cHRfbGV2ZWwgbG9va3MgYmV0dGVyIHRoYW4gdGRwIGxldmVsIGFuZCBpcyBjb25zaXN0ZW50IHdp
dGgNCj4gPiBzdm0gZ2V0X25wdF9sZXZlbCgpLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogU2hp
eXVhbiBHYW8gPGdhb3NoaXl1YW5AYmFpZHUuY29tIDxtYWlsdG86Z2Fvc2hpeXVhbkBiYWlkdS5j
b20+Pg0KPiA+IC0tLQ0KPiA+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCA0ICsrLS0NCj4gPiAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4g
ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3Zt
eC5jDQo+ID4gaW5kZXggZGY0NjFmMzg3ZTIwLi5mMGNmZDFmMTBhMDYgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14
LmMNCj4gPiBAQCAtMzM1MCw3ICszMzUwLDcgQEAgdm9pZCB2bXhfc2V0X2NyMChzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgY3IwKQ0KPiA+IHZteC0+ZW11bGF0aW9uX3JlcXVp
cmVkID0gdm14X2VtdWxhdGlvbl9yZXF1aXJlZCh2Y3B1KTsNCj4gPiB9DQo+ID4NCj4gPiAtc3Rh
dGljIGludCB2bXhfZ2V0X21heF90ZHBfbGV2ZWwodm9pZCkNCj4gPiArc3RhdGljIGludCB2bXhf
Z2V0X21heF9lcHRfbGV2ZWwodm9pZCkNCj4gPiB7DQo+ID4gaWYgKGNwdV9oYXNfdm14X2VwdF81
bGV2ZWxzKCkpDQo+ID4gcmV0dXJuIDU7DQo+ID4gQEAgLTg1MjYsNyArODUyNiw3IEBAIHN0YXRp
YyBfX2luaXQgaW50IGhhcmR3YXJlX3NldHVwKHZvaWQpDQo+ID4gKi8NCj4gPiB2bXhfc2V0dXBf
bWVfc3B0ZV9tYXNrKCk7DQo+ID4NCj4gPiAtIGt2bV9jb25maWd1cmVfbW11KGVuYWJsZV9lcHQs
IDAsIHZteF9nZXRfbWF4X3RkcF9sZXZlbCgpLA0KPiA+ICsga3ZtX2NvbmZpZ3VyZV9tbXUoZW5h
YmxlX2VwdCwgMCwgdm14X2dldF9tYXhfZXB0X2xldmVsKCksDQo+ID4gZXB0X2NhcHNfdG9fbHBh
Z2VfbGV2ZWwodm14X2NhcGFiaWxpdHkuZXB0KSk7DQo+DQo+DQo+IEFueW9uZSBlbHNlIGhhdmUg
YW4gb3BpbmlvbiBvbiB0aGlzPyBJJ20gbGVhbmluZyB0b3dhcmQgYXBwbHlpbmcgaXQsIGJ1dCBh
IHNtYWxsDQo+IHBhcnQgb2YgbWUgYWxzbyBraW5kYSBsaWtlcyB0aGUgInRkcCIgbmFtZSAodGhv
dWdoIGV2ZXJ5IHRpbWUgSSBsb29rIGF0IHRoaXMgcGF0Y2gNCj4gdGhhdCBwYXJ0IG9mIG1lIGdl
dHMgZXZlbiBzbWFsbGVyLi4uKS4NCj4NCg0KUmVtaW5kLCBwbGVhc2UgbG9vayBhdCB0aGlzIHBh
dGNoIGFnYWluIDopDQoNCg==
