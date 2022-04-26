Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3855450FD7B
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 14:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238485AbiDZMqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 08:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346490AbiDZMqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 08:46:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355B3179EAB
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 05:43:38 -0700 (PDT)
Received: from fraeml740-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KnhM43P6qz67NMW;
        Tue, 26 Apr 2022 20:41:04 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml740-chm.china.huawei.com (10.206.15.221) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 14:43:35 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 13:43:35 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2375.024; Tue, 26 Apr 2022 13:43:35 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "chao.p.peng@intel.com" <chao.p.peng@intel.com>,
        "yi.y.sun@intel.com" <yi.y.sun@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: RE: [RFC 00/18] vfio: Adopt iommufd
Thread-Topic: [RFC 00/18] vfio: Adopt iommufd
Thread-Index: AQHYT+0OTGNprklv2E6ANQZpjBJsW60CAlLggAATGICAABalMA==
Date:   Tue, 26 Apr 2022 12:43:35 +0000
Message-ID: <4ac4956cfe344326a805966535c1dc43@huawei.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <4f920d463ebf414caa96419b625632d5@huawei.com>
 <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
In-Reply-To: <be8aa86a-25d1-d034-5e3b-6406aa7ff897@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBBdWdlciBbbWFp
bHRvOmVyaWMuYXVnZXJAcmVkaGF0LmNvbV0NCj4gU2VudDogMjYgQXByaWwgMjAyMiAxMjo0NQ0K
PiBUbzogU2hhbWVlcmFsaSBLb2xvdGh1bSBUaG9kaSA8c2hhbWVlcmFsaS5rb2xvdGh1bS50aG9k
aUBodWF3ZWkuY29tPjsgWWkNCj4gTGl1IDx5aS5sLmxpdUBpbnRlbC5jb20+OyBhbGV4LndpbGxp
YW1zb25AcmVkaGF0LmNvbTsgY29odWNrQHJlZGhhdC5jb207DQo+IHFlbXUtZGV2ZWxAbm9uZ251
Lm9yZw0KPiBDYzogZGF2aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1OyB0aHV0aEByZWRoYXQuY29t
OyBmYXJtYW5AbGludXguaWJtLmNvbTsNCj4gbWpyb3NhdG9AbGludXguaWJtLmNvbTsgYWtyb3dp
YWtAbGludXguaWJtLmNvbTsgcGFzaWNAbGludXguaWJtLmNvbTsNCj4gampoZXJuZUBsaW51eC5p
Ym0uY29tOyBqYXNvd2FuZ0ByZWRoYXQuY29tOyBrdm1Admdlci5rZXJuZWwub3JnOw0KPiBqZ2dA
bnZpZGlhLmNvbTsgbmljb2xpbmNAbnZpZGlhLmNvbTsgZXJpYy5hdWdlci5wcm9AZ21haWwuY29t
Ow0KPiBrZXZpbi50aWFuQGludGVsLmNvbTsgY2hhby5wLnBlbmdAaW50ZWwuY29tOyB5aS55LnN1
bkBpbnRlbC5jb207DQo+IHBldGVyeEByZWRoYXQuY29tOyBaaGFuZ2ZlaSBHYW8gPHpoYW5nZmVp
Lmdhb0BsaW5hcm8ub3JnPg0KPiBTdWJqZWN0OiBSZTogW1JGQyAwMC8xOF0gdmZpbzogQWRvcHQg
aW9tbXVmZA0KDQpbLi4uXQ0KIA0KPiA+Pg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0v
MC12MS1lNzljZDhkMTY4ZTgrNi1pb21tdWZkX2pnZ0BudmlkaWEuY29tDQo+ID4+IC8NCj4gPj4g
WzJdIGh0dHBzOi8vZ2l0aHViLmNvbS9sdXhpczE5OTkvaW9tbXVmZC90cmVlL2lvbW11ZmQtdjUu
MTctcmM2DQo+ID4+IFszXSBodHRwczovL2dpdGh1Yi5jb20vbHV4aXMxOTk5L3FlbXUvdHJlZS9x
ZW11LWZvci01LjE3LXJjNi12bS1yZmN2MQ0KPiA+IEhpLA0KPiA+DQo+ID4gSSBoYWQgYSBnbyB3
aXRoIHRoZSBhYm92ZSBicmFuY2hlcyBvbiBvdXIgQVJNNjQgcGxhdGZvcm0gdHJ5aW5nIHRvDQo+
IHBhc3MtdGhyb3VnaA0KPiA+IGEgVkYgZGV2LCBidXQgUWVtdSByZXBvcnRzIGFuIGVycm9yIGFz
IGJlbG93LA0KPiA+DQo+ID4gWyAgICAwLjQ0NDcyOF0gaGlzaV9zZWMyIDAwMDA6MDA6MDEuMDog
ZW5hYmxpbmcgZGV2aWNlICgwMDAwIC0+IDAwMDIpDQo+ID4gcWVtdS1zeXN0ZW0tYWFyY2g2NC1p
b21tdWZkOiBJT01NVV9JT0FTX01BUCBmYWlsZWQ6IEJhZCBhZGRyZXNzDQo+ID4gcWVtdS1zeXN0
ZW0tYWFyY2g2NC1pb21tdWZkOiB2ZmlvX2NvbnRhaW5lcl9kbWFfbWFwKDB4YWFhYWZlYjQwY2Uw
LA0KPiAweDgwMDAwMDAwMDAsIDB4MTAwMDAsIDB4ZmZmZmI0MGVmMDAwKSA9IC0xNCAoQmFkIGFk
ZHJlc3MpDQo+ID4NCj4gPiBJIHRoaW5rIHRoaXMgaGFwcGVucyBmb3IgdGhlIGRldiBCQVIgYWRk
ciByYW5nZS4gSSBoYXZlbid0IGRlYnVnZ2VkIHRoZQ0KPiBrZXJuZWwNCj4gPiB5ZXQgdG8gc2Vl
IHdoZXJlIGl0IGFjdHVhbGx5IHJlcG9ydHMgdGhhdC4NCj4gRG9lcyBpdCBwcmV2ZW50IHlvdXIg
YXNzaWduZWQgZGV2aWNlIGZyb20gd29ya2luZz8gSSBoYXZlIHN1Y2ggZXJyb3JzDQo+IHRvbyBi
dXQgdGhpcyBpcyBhIGtub3duIGlzc3VlLiBUaGlzIGlzIGR1ZSB0byB0aGUgZmFjdCBQMlAgRE1B
IGlzIG5vdA0KPiBzdXBwb3J0ZWQgeWV0Lg0KPiANCg0KWWVzLCB0aGUgYmFzaWMgdGVzdHMgYWxs
IGdvb2Qgc28gZmFyLiBJIGFtIHN0aWxsIG5vdCB2ZXJ5IGNsZWFyIGhvdyBpdCB3b3JrcyBpZg0K
dGhlIG1hcCgpIGZhaWxzIHRob3VnaC4gSXQgbG9va3MgbGlrZSBpdCBmYWlscyBpbiwNCg0KaW9t
bXVmZF9pb2FzX21hcCgpDQogIGlvcHRfbWFwX3VzZXJfcGFnZXMoKQ0KICAgaW9wdF9tYXBfcGFn
ZXMoKQ0KICAgLi4NCiAgICAgcGZuX3JlYWRlcl9waW5fcGFnZXMoKQ0KDQpTbyBkb2VzIGl0IG1l
YW4gaXQganVzdCB3b3JrcyBiZWNhdXNlIHRoZSBwYWdlIGlzIHJlc2lkZW50KCk/DQoNClRoYW5r
cywNClNoYW1lZXINCg0KDQoNCg==
