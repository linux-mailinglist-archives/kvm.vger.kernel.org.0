Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29A6176E01
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgCCEaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 23:30:10 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2975 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726859AbgCCEaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:30:09 -0500
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id C3831BB387B08619B24D;
        Tue,  3 Mar 2020 12:30:06 +0800 (CST)
Received: from DGGEMM528-MBX.china.huawei.com ([169.254.8.90]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0439.000;
 Tue, 3 Mar 2020 12:29:57 +0800
From:   "Zhoujian (jay)" <jianjay.zhou@huawei.com>
To:     Peter Feiner <pfeiner@google.com>
CC:     Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "quintela@redhat.com" <quintela@redhat.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>,
        "linfeng (M)" <linfeng23@huawei.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Junaid Shahid <junaids@google.com>
Subject: RE: RFC: Split EPT huge pages in advance of dirty logging
Thread-Topic: RFC: Split EPT huge pages in advance of dirty logging
Thread-Index: AdXmU97BvyK5YKoyS5++my9GnvXVk///1+yA//428yCAA1S3gP/+abuggAMs8gCAAd62AIAAJJ4A//B2yiAD16MpAP/+sSEw
Date:   Tue, 3 Mar 2020 04:29:57 +0000
Message-ID: <B2D15215269B544CADD246097EACE7474BB4DD60@DGGEMM528-MBX.china.huawei.com>
References: <B2D15215269B544CADD246097EACE7474BAF9AB6@DGGEMM528-MBX.china.huawei.com>
 <20200218174311.GE1408806@xz-x1>
 <B2D15215269B544CADD246097EACE7474BAFF835@DGGEMM528-MBX.china.huawei.com>
 <20200219171919.GA34517@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB03772@DGGEMM528-MBX.china.huawei.com>
 <CANgfPd-P_=GqcMiwLSSkUhZDt42aMLUsCJt+CPdUN5yR3RLHmQ@mail.gmail.com>
 <cd4626a1-44b5-1a62-cf4b-716950a6db1b@google.com>
 <CAM3pwhGF3ABoew5UOd9xUxtm14VN_o0gr+D=KfR3ZEQjmKgUdQ@mail.gmail.com>
 <B2D15215269B544CADD246097EACE7474BB4A71D@DGGEMM528-MBX.china.huawei.com>
 <CAM3pwhH8xyisEq_=LFTy=sZNA2kRTQTbBqW6GA-0M-AiJy0q1g@mail.gmail.com>
In-Reply-To: <CAM3pwhH8xyisEq_=LFTy=sZNA2kRTQTbBqW6GA-0M-AiJy0q1g@mail.gmail.com>
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

DQoNCkZyb206IFBldGVyIEZlaW5lciBbbWFpbHRvOnBmZWluZXJAZ29vZ2xlLmNvbV0gDQpTZW50
OiBUdWVzZGF5LCBNYXJjaCAzLCAyMDIwIDEyOjI5IEFNDQpUbzogWmhvdWppYW4gKGpheSkgPGpp
YW5qYXkuemhvdUBodWF3ZWkuY29tPg0KQ2M6IEJlbiBHYXJkb24gPGJnYXJkb25AZ29vZ2xlLmNv
bT47IFBldGVyIFh1IDxwZXRlcnhAcmVkaGF0LmNvbT47IGt2bUB2Z2VyLmtlcm5lbC5vcmc7IHFl
bXUtZGV2ZWxAbm9uZ251Lm9yZzsgcGJvbnppbmlAcmVkaGF0LmNvbTsgZGdpbGJlcnRAcmVkaGF0
LmNvbTsgcXVpbnRlbGFAcmVkaGF0LmNvbTsgTGl1amluc29uZyAoUGF1bCkgPGxpdS5qaW5zb25n
QGh1YXdlaS5jb20+OyBsaW5mZW5nIChNKSA8bGluZmVuZzIzQGh1YXdlaS5jb20+OyB3YW5neGlu
IChVKSA8d2FuZ3hpbnhpbi53YW5nQGh1YXdlaS5jb20+OyBIdWFuZ3dlaWRvbmcgKEMpIDx3ZWlk
b25nLmh1YW5nQGh1YXdlaS5jb20+OyBKdW5haWQgU2hhaGlkIDxqdW5haWRzQGdvb2dsZS5jb20+
DQpTdWJqZWN0OiBSZTogUkZDOiBTcGxpdCBFUFQgaHVnZSBwYWdlcyBpbiBhZHZhbmNlIG9mIGRp
cnR5IGxvZ2dpbmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQZXRl
ciBGZWluZXIgW21haWx0bzpwZmVpbmVyQGdvb2dsZS5jb21dDQoNClsuLi5dDQoNCj5IaSBKYXks
DQo+SSd2ZSBiZWVuIHNpY2sgc2luY2UgSSBzZW50IG15IGxhc3QgZW1haWwsIHNvIEkgaGF2ZW4n
dCBnb3R0ZW4gdG8gdGhpcyBwYXRjaCBzZXQgeWV0LiBJJ2xsIHNlbmQgaXQgaW4gdGhlIG5leHQg
d2VlayBvciB0d28uwqANCg0KT0ssIHBsZWFzZSB0YWtlIGNhcmUgb2YgeW91cnNlbGYuDQoNCg0K
UmVnYXJkcywNCkpheSBaaG91DQo=
