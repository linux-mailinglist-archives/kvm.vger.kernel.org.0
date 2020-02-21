Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC9FB1679F5
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 10:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgBUJyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 04:54:02 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:40166 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727036AbgBUJyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 04:54:02 -0500
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id BC80C69A9B68207696AD;
        Fri, 21 Feb 2020 17:53:59 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.16]) by
 DGGEMM405-HUB.china.huawei.com ([10.3.20.213]) with mapi id 14.03.0439.000;
 Fri, 21 Feb 2020 17:53:51 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Xu <peterx@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: RE: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Thread-Topic: [PATCH v2] KVM: x86: enable dirty log gradually in small chunks
Thread-Index: AQHV56Y5Alj8LhDzKkeojlXWbxjKp6gj8luAgAF1QXA=
Date:   Fri, 21 Feb 2020 09:53:51 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB06606@DGGEMM528-MBX.china.huawei.com>
References: <20200220042828.27464-1-jianjay.zhou@huawei.com>
 <20200220192809.GA15253@xz-x1>
In-Reply-To: <20200220192809.GA15253@xz-x1>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.228.206]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUGV0ZXIgWHUgW21haWx0
bzpwZXRlcnhAcmVkaGF0LmNvbV0NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyMSwgMjAyMCAz
OjI4IEFNDQo+IFRvOiBaaG91amlhbiAoamF5KSA8amlhbmpheS56aG91QGh1YXdlaS5jb20+DQo+
IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBwYm9uemluaUByZWRoYXQuY29tOyB3YW5neGluIChV
KQ0KPiA8d2FuZ3hpbnhpbi53YW5nQGh1YXdlaS5jb20+OyBIdWFuZ3dlaWRvbmcgKEMpDQo+IDx3
ZWlkb25nLmh1YW5nQGh1YXdlaS5jb20+OyBzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwuY29t
OyBMaXVqaW5zb25nDQo+IChQYXVsKSA8bGl1LmppbnNvbmdAaHVhd2VpLmNvbT4NCj4gU3ViamVj
dDogUmU6IFtQQVRDSCB2Ml0gS1ZNOiB4ODY6IGVuYWJsZSBkaXJ0eSBsb2cgZ3JhZHVhbGx5IGlu
IHNtYWxsIGNodW5rcw0KPiANCj4gT24gVGh1LCBGZWIgMjAsIDIwMjAgYXQgMTI6Mjg6MjhQTSAr
MDgwMCwgSmF5IFpob3Ugd3JvdGU6DQo+ID4gQEAgLTU4NjUsOCArNTg2NSwxMiBAQCB2b2lkDQo+
IGt2bV9tbXVfc2xvdF9yZW1vdmVfd3JpdGVfYWNjZXNzKHN0cnVjdCBrdm0gKmt2bSwNCj4gPiAg
CWJvb2wgZmx1c2g7DQo+ID4NCj4gPiAgCXNwaW5fbG9jaygma3ZtLT5tbXVfbG9jayk7DQo+ID4g
LQlmbHVzaCA9IHNsb3RfaGFuZGxlX2FsbF9sZXZlbChrdm0sIG1lbXNsb3QsIHNsb3Rfcm1hcF93
cml0ZV9wcm90ZWN0LA0KPiA+IC0JCQkJICAgICAgZmFsc2UpOw0KPiA+ICsJaWYgKGt2bS0+bWFu
dWFsX2RpcnR5X2xvZ19wcm90ZWN0ICYgS1ZNX0RJUlRZX0xPR19JTklUSUFMTFlfU0VUKQ0KPiA+
ICsJCWZsdXNoID0gc2xvdF9oYW5kbGVfbGFyZ2VfbGV2ZWwoa3ZtLCBtZW1zbG90LA0KPiA+ICsJ
CQkJCQlzbG90X3JtYXBfd3JpdGVfcHJvdGVjdCwgZmFsc2UpOw0KPiA+ICsJZWxzZQ0KPiA+ICsJ
CWZsdXNoID0gc2xvdF9oYW5kbGVfYWxsX2xldmVsKGt2bSwgbWVtc2xvdCwNCj4gPiArCQkJCQkJ
c2xvdF9ybWFwX3dyaXRlX3Byb3RlY3QsIGZhbHNlKTsNCj4gDQo+IEFub3RoZXIgZXh0cmEgY29t
bWVudDoNCj4gDQo+IEkgdGhpbmsgd2Ugc2hvdWxkIHN0aWxsIGtlZXAgdGhlIG9sZCBiZWhhdmlv
ciBmb3IgS1ZNX01FTV9SRUFET05MWSAoaW4NCj4ga3ZtX21tdV9zbG90X2FwcGx5X2ZsYWdzKCkp
KSBmb3IgdGhpcy4uLiAgDQoNCkkgYWxzbyByZWFsaXplZCB0aGlzIGlzc3VlIGFmdGVyIHBvc3Rp
bmcgdGhpcyBwYXRjaCwgYW5kIEkgYWdyZWUuDQoNCj4gU2F5LCBpbnN0ZWFkIG9mIGRvaW5nIHRo
aXMsIG1heWJlIHdlDQo+IHdhbnQga3ZtX21tdV9zbG90X3JlbW92ZV93cml0ZV9hY2Nlc3MoKSB0
byB0YWtlIGEgbmV3IHBhcmFtZXRlciB0bw0KPiBkZWNpZGUgdG8gd2hpY2ggbGV2ZWwgd2UgZG8g
dGhlIHdyLXByb3RlY3QuDQoNCkhvdyBhYm91dCB1c2luZyB0aGUgImZsYWdzIiBmaWVsZCB0byBk
aXN0aW5ndWlzaDoNCg0KCQlpZiAoKGt2bS0+bWFudWFsX2RpcnR5X2xvZ19wcm90ZWN0ICYgS1ZN
X0RJUlRZX0xPR19JTklUSUFMTFlfU0VUKQ0KICAgICAgICAgICAgICAgICYmIChtZW1zbG90LT5m
bGFncyAmIEtWTV9NRU1fTE9HX0RJUlRZX1BBR0VTKSkNCiAgICAgICAgICAgICAgICBmbHVzaCA9
IHNsb3RfaGFuZGxlX2xhcmdlX2xldmVsKGt2bSwgbWVtc2xvdCwNCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzbG90X3JtYXBfd3JpdGVfcHJvdGVjdCwgZmFsc2UpOw0K
ICAgICAgICBlbHNlDQogICAgICAgICAgICAgICAgZmx1c2ggPSBzbG90X2hhbmRsZV9hbGxfbGV2
ZWwoa3ZtLCBtZW1zbG90LA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
IHNsb3Rfcm1hcF93cml0ZV9wcm90ZWN0LCBmYWxzZSk7DQoNClJlZ2FyZHMsDQpKYXkgWmhvdQ0K
DQo+IA0KPiBUaGFua3MsDQo+IA0KPiA+ICAJc3Bpbl91bmxvY2soJmt2bS0+bW11X2xvY2spOw0K
PiA+DQo+ID4gIAkvKg0KPiANCj4gLS0NCj4gUGV0ZXIgWHUNCg0K
