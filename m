Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17CB7B50D3
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 13:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236631AbjJBLDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 07:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjJBLDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 07:03:36 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E42AFE
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 04:03:28 -0700 (PDT)
Received: from lhrpeml500003.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RzdLm67rxz6K5vm;
        Mon,  2 Oct 2023 19:01:52 +0800 (CST)
Received: from lhrpeml500001.china.huawei.com (7.191.163.213) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 2 Oct 2023 12:03:24 +0100
Received: from lhrpeml500001.china.huawei.com ([7.191.163.213]) by
 lhrpeml500001.china.huawei.com ([7.191.163.213]) with mapi id 15.01.2507.031;
 Mon, 2 Oct 2023 12:03:24 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
        "Liu Zhiwei" <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Chris Wulff" <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Alistair Francis" <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>,
        "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
        "wangyanan (Y)" <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
        =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        xianglai li <lixianglai@loongson.cn>,
        Salil Mehta <salil.mehta@opnsrc.net>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Bibo Mao <maobibo@loongson.cn>
Subject: RE: [PATCH 07/22] exec/cpu: Introduce the CPU address space
 destruction function
Thread-Topic: [PATCH 07/22] exec/cpu: Introduce the CPU address space
 destruction function
Thread-Index: AQHZ6kpHZRJs2Ph4/02c9MXTagqXa7A2aEcw
Date:   Mon, 2 Oct 2023 11:03:24 +0000
Message-ID: <e4002b7625444645a2f65e4060a58b58@huawei.com>
References: <20230918160257.30127-1-philmd@linaro.org>
 <20230918160257.30127-8-philmd@linaro.org>
In-Reply-To: <20230918160257.30127-8-philmd@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.195.33.168]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SGkgUGhpbGxpcGUsDQpUaGlzIHBhdGNoIGhhcyBiZWVuIHRha2VuIGFzIGl0IGlzIGZyb20gQVJN
J3MgUkZDIGFuZCB0aGUgY29tbW9uIHBhdGNoLXNldCBtZW50aW9uZWQgYmVsb3cuDQpTbyBTT0Jz
IGFyZSBhbGwgd3JvbmcgZXZlcnl3aGVyZS4NCg0KDQpPcmlnaW5hbCBSRkMgcG9zdGVkIGluIHRo
ZSB5ZWFyIDIwMjAuDQpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8yMDIw
MDYxMzIxMzYyOS4yMTk4NC0yMy1zYWxpbC5tZWh0YUBodWF3ZWkuY29tLw0KDQpSZWNlbnRseSBw
b3N0ZWQgUkZDIFYyDQpbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8yMDIz
MDkyNjEwMDQzNi4yODI4NC0xLXNhbGlsLm1laHRhQGh1YXdlaS5jb20vVC8jbTVmNWFlNDBiMDkx
ZDY5ZDAxMDEyODgwZDc1MDBkOTY4NzRhOWQzOWMNCg0KUmVjZW50IGNvbW1vbiBwYXRjaC1zZXQg
Zm9yIFZpcnR1YWwgQ1BVIEhvdHBsdWcNClszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9xZW11
LWRldmVsLzIwMjMwOTMwMDAxOTMzLjI2NjAtOS1zYWxpbC5tZWh0YUBodWF3ZWkuY29tLw0KDQpb
NF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8yMDIzMDkzMDAwMTkzMy4yNjYw
LTEwLXNhbGlsLm1laHRhQGh1YXdlaS5jb20vDQoNCkJlc2lkZSBteSBvcmlnaW5hbCBwYXRjaC1z
ZXQgaGFkIGJ1ZyB3aGljaCB5b3UgaGF2ZSBpbmhlcml0ZWQgaW4gdGhpcyBwYXRjaC1zZXQuDQog
DQpUaGFua3MNClNhbGlsDQoNCg0KPiBGcm9tOiBxZW11LWFybS1ib3VuY2VzK3NhbGlsLm1laHRh
PWh1YXdlaS5jb21Abm9uZ251Lm9yZyA8cWVtdS1hcm0tDQo+IGJvdW5jZXMrc2FsaWwubWVodGE9
aHVhd2VpLmNvbUBub25nbnUub3JnPiBPbiBCZWhhbGYgT2YgUGhpbGlwcGUgTWF0aGlldS0NCj4g
RGF1ZMOpDQo+IFNlbnQ6IE1vbmRheSwgU2VwdGVtYmVyIDE4LCAyMDIzIDU6MDMgUE0NCj4gVG86
IHFlbXUtZGV2ZWxAbm9uZ251Lm9yZw0KPiBDYzogTGF1cmVudCBWaXZpZXIgPGxhdXJlbnRAdml2
aWVyLmV1PjsgUGFvbG8gQm9uemluaQ0KPiA8cGJvbnppbmlAcmVkaGF0LmNvbT47IE1heCBGaWxp
cHBvdiA8amNtdmJrYmNAZ21haWwuY29tPjsgRGF2aWQgSGlsZGVuYnJhbmQNCj4gPGRhdmlkQHJl
ZGhhdC5jb20+OyBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+OyBBbnRvbiBKb2hhbnNzb24N
Cj4gPGFuam9AcmV2Lm5nPjsgUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5hcm8ub3Jn
PjsNCj4ga3ZtQHZnZXIua2VybmVsLm9yZzsgTWFyZWsgVmFzdXQgPG1hcmV4QGRlbnguZGU+OyBE
YXZpZCBHaWJzb24NCj4gPGRhdmlkQGdpYnNvbi5kcm9wYmVhci5pZC5hdT47IEJyaWFuIENhaW4g
PGJjYWluQHF1aWNpbmMuY29tPjsgWW9zaGlub3JpDQo+IFNhdG8gPHlzYXRvQHVzZXJzLnNvdXJj
ZWZvcmdlLmpwPjsgRWRnYXIgRSAuIElnbGVzaWFzDQo+IDxlZGdhci5pZ2xlc2lhc0BnbWFpbC5j
b20+OyBDbGF1ZGlvIEZvbnRhbmEgPGNmb250YW5hQHN1c2UuZGU+OyBEYW5pZWwNCj4gSGVucmlx
dWUgQmFyYm96YSA8ZGJhcmJvemFAdmVudGFuYW1pY3JvLmNvbT47IEFydHlvbSBUYXJhc2Vua28N
Cj4gPGF0YXI0cWVtdUBnbWFpbC5jb20+OyBNYXJjZWxvIFRvc2F0dGkgPG10b3NhdHRpQHJlZGhh
dC5jb20+OyBxZW11LQ0KPiBwcGNAbm9uZ251Lm9yZzsgTGl1IFpoaXdlaSA8emhpd2VpX2xpdUBs
aW51eC5hbGliYWJhLmNvbT47IEF1cmVsaWVuIEphcm5vDQo+IDxhdXJlbGllbkBhdXJlbDMyLm5l
dD47IElseWEgTGVvc2hrZXZpY2ggPGlpaUBsaW51eC5pYm0uY29tPjsgRGFuaWVsDQo+IEhlbnJp
cXVlIEJhcmJvemEgPGRhbmllbGhiNDEzQGdtYWlsLmNvbT47IEJhc3RpYW4gS29wcGVsbWFubg0K
PiA8a2Jhc3RpYW5AbWFpbC51bmktcGFkZXJib3JuLmRlPjsgQ8OpZHJpYyBMZSBHb2F0ZXIgPGNs
Z0BrYW9kLm9yZz47IEFsaXN0YWlyDQo+IEZyYW5jaXMgPGFsaXN0YWlyLmZyYW5jaXNAd2RjLmNv
bT47IEFsZXNzYW5kcm8gRGkgRmVkZXJpY28gPGFsZUByZXYubmc+Ow0KPiBTb25nIEdhbyA8Z2Fv
c29uZ0Bsb29uZ3Nvbi5jbj47IE1hcmNlbCBBcGZlbGJhdW0NCj4gPG1hcmNlbC5hcGZlbGJhdW1A
Z21haWwuY29tPjsgQ2hyaXMgV3VsZmYgPGNyd3VsZmZAZ21haWwuY29tPjsgTWljaGFlbCBTLg0K
PiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT47IEFsaXN0YWlyIEZyYW5jaXMgPGFsaXN0YWlyQGFs
aXN0YWlyMjMubWU+Ow0KPiBGYWJpYW5vIFJvc2FzIDxmYXJvc2FzQHN1c2UuZGU+OyBxZW11LXMz
OTB4QG5vbmdudS5vcmc7IHdhbmd5YW5hbiAoWSkNCj4gPHdhbmd5YW5hbjU1QGh1YXdlaS5jb20+
OyBMdWMgTWljaGVsIDxsdWNAbG1pY2hlbC5mcj47IFdlaXdlaSBMaQ0KPiA8bGl3ZWl3ZWlAaXNj
YXMuYWMuY24+OyBCaW4gTWVuZyA8YmluLm1lbmdAd2luZHJpdmVyLmNvbT47IFN0YWZmb3JkIEhv
cm5lDQo+IDxzaG9ybmVAZ21haWwuY29tPjsgWGlhb2p1YW4gWWFuZyA8eWFuZ3hpYW9qdWFuQGxv
b25nc29uLmNuPjsgRGFuaWVsIFAgLg0KPiBCZXJyYW5nZSA8YmVycmFuZ2VAcmVkaGF0LmNvbT47
IFRob21hcyBIdXRoIDx0aHV0aEByZWRoYXQuY29tPjsgUGhpbGlwcGUNCj4gTWF0aGlldS1EYXVk
w6kgPHBoaWxtZEBsaW5hcm8ub3JnPjsgcWVtdS1hcm1Abm9uZ251Lm9yZzsgSmlheHVuIFlhbmcN
Cj4gPGppYXh1bi55YW5nQGZseWdvYXQuY29tPjsgUmljaGFyZCBIZW5kZXJzb24NCj4gPHJpY2hh
cmQuaGVuZGVyc29uQGxpbmFyby5vcmc+OyBBbGVrc2FuZGFyIFJpa2Fsbw0KPiA8YWxla3NhbmRh
ci5yaWthbG9Ac3lybWlhLmNvbT47IEJlcm5oYXJkIEJlc2Nob3cgPHNoZW50ZXlAZ21haWwuY29t
PjsgTWFyaw0KPiBDYXZlLUF5bGFuZCA8bWFyay5jYXZlLWF5bGFuZEBpbGFuZGUuY28udWs+OyBx
ZW11LXJpc2N2QG5vbmdudS5vcmc7IEFsZXgNCj4gQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz47IE5pY2hvbGFzIFBpZ2dpbiA8bnBpZ2dpbkBnbWFpbC5jb20+OyBHcmVnDQo+IEt1cnog
PGdyb3VnQGthb2Qub3JnPjsgTWljaGFlbCBSb2xuaWsgPG1yb2xuaWtAZ21haWwuY29tPjsgRWR1
YXJkbyBIYWJrb3N0DQo+IDxlZHVhcmRvQGhhYmtvc3QubmV0PjsgTWFya3VzIEFybWJydXN0ZXIg
PGFybWJydUByZWRoYXQuY29tPjsgUGFsbWVyDQo+IERhYmJlbHQgPHBhbG1lckBkYWJiZWx0LmNv
bT47IHhpYW5nbGFpIGxpIDxsaXhpYW5nbGFpQGxvb25nc29uLmNuPjsgU2FsaWwNCj4gTWVodGEg
PHNhbGlsLm1laHRhQG9wbnNyYy5uZXQ+OyBJZ29yIE1hbW1lZG92IDxpbWFtbWVkb0ByZWRoYXQu
Y29tPjsgQW5pDQo+IFNpbmhhIDxhbmlzaW5oYUByZWRoYXQuY29tPjsgQmlibyBNYW8gPG1hb2Jp
Ym9AbG9vbmdzb24uY24+DQo+IFN1YmplY3Q6IFtQQVRDSCAwNy8yMl0gZXhlYy9jcHU6IEludHJv
ZHVjZSB0aGUgQ1BVIGFkZHJlc3Mgc3BhY2UNCj4gZGVzdHJ1Y3Rpb24gZnVuY3Rpb24NCj4gDQo+
IEZyb206IHhpYW5nbGFpIGxpIDxsaXhpYW5nbGFpQGxvb25nc29uLmNuPg0KPiANCj4gSW50cm9k
dWNlIG5ldyBmdW5jdGlvbiB0byBkZXN0cm95IENQVSBhZGRyZXNzIHNwYWNlIHJlc291cmNlcw0K
PiBmb3IgY3B1IGhvdC0odW4pcGx1Zy4NCj4gDQo+IENvLWF1dGhvcmVkLWJ5OiAiU2FsaWwgTWVo
dGEiIDxzYWxpbC5tZWh0YUBvcG5zcmMubmV0Pg0KPiBDYzogIlNhbGlsIE1laHRhIiA8c2FsaWwu
bWVodGFAb3Buc3JjLm5ldD4NCj4gQ2M6IFhpYW9qdWFuIFlhbmcgPHlhbmd4aWFvanVhbkBsb29u
Z3Nvbi5jbj4NCj4gQ2M6IFNvbmcgR2FvIDxnYW9zb25nQGxvb25nc29uLmNuPg0KPiBDYzogIk1p
Y2hhZWwgUy4gVHNpcmtpbiIgPG1zdEByZWRoYXQuY29tPg0KPiBDYzogSWdvciBNYW1tZWRvdiA8
aW1hbW1lZG9AcmVkaGF0LmNvbT4NCj4gQ2M6IEFuaSBTaW5oYSA8YW5pc2luaGFAcmVkaGF0LmNv
bT4NCj4gQ2M6IFBhb2xvIEJvbnppbmkgPHBib256aW5pQHJlZGhhdC5jb20+DQo+IENjOiBSaWNo
YXJkIEhlbmRlcnNvbiA8cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZz4NCj4gQ2M6IEVkdWFy
ZG8gSGFia29zdCA8ZWR1YXJkb0BoYWJrb3N0Lm5ldD4NCj4gQ2M6IE1hcmNlbCBBcGZlbGJhdW0g
PG1hcmNlbC5hcGZlbGJhdW1AZ21haWwuY29tPg0KPiBDYzogIlBoaWxpcHBlIE1hdGhpZXUtRGF1
ZMOpIiA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IENjOiBZYW5hbiBXYW5nIDx3YW5neWFuYW41NUBo
dWF3ZWkuY29tPg0KPiBDYzogIkRhbmllbCBQLiBCZXJyYW5nw6kiIDxiZXJyYW5nZUByZWRoYXQu
Y29tPg0KPiBDYzogUGV0ZXIgWHUgPHBldGVyeEByZWRoYXQuY29tPg0KPiBDYzogRGF2aWQgSGls
ZGVuYnJhbmQgPGRhdmlkQHJlZGhhdC5jb20+DQo+IENjOiBCaWJvIE1hbyA8bWFvYmlib0Bsb29u
Z3Nvbi5jbj4NCj4gU2lnbmVkLW9mZi1ieTogeGlhbmdsYWkgbGkgPGxpeGlhbmdsYWlAbG9vbmdz
b24uY24+DQo+IE1lc3NhZ2UtSUQ6DQo+IDwzYTRmYzJhM2RmNGI3NjdjM2MyOTZhN2RhM2JjMTVj
YTljMjUxMzE2LjE2OTQ0MzMzMjYuZ2l0LmxpeGlhbmdsYWlAbG9vbmdzbw0KPiBuLmNuPg0KPiAt
LS0NCj4gIGluY2x1ZGUvZXhlYy9jcHUtY29tbW9uLmggfCAgOCArKysrKysrKw0KPiAgaW5jbHVk
ZS9ody9jb3JlL2NwdS5oICAgICB8ICAxICsNCj4gIHNvZnRtbXUvcGh5c21lbS5jICAgICAgICAg
fCAyNCArKysrKysrKysrKysrKysrKysrKysrKysNCj4gIDMgZmlsZXMgY2hhbmdlZCwgMzMgaW5z
ZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvZXhlYy9jcHUtY29tbW9uLmgg
Yi9pbmNsdWRlL2V4ZWMvY3B1LWNvbW1vbi5oDQo+IGluZGV4IDQxNzg4YzBiZGQuLmViNTZhMjI4
YTIgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvZXhlYy9jcHUtY29tbW9uLmgNCj4gKysrIGIvaW5j
bHVkZS9leGVjL2NwdS1jb21tb24uaA0KPiBAQCAtMTIwLDYgKzEyMCwxNCBAQCBzaXplX3QgcWVt
dV9yYW1fcGFnZXNpemVfbGFyZ2VzdCh2b2lkKTsNCj4gICAqLw0KPiAgdm9pZCBjcHVfYWRkcmVz
c19zcGFjZV9pbml0KENQVVN0YXRlICpjcHUsIGludCBhc2lkeCwNCj4gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBjb25zdCBjaGFyICpwcmVmaXgsIE1lbW9yeVJlZ2lvbiAqbXIpOw0KPiAr
LyoqDQo+ICsgKiBjcHVfYWRkcmVzc19zcGFjZV9kZXN0cm95Og0KPiArICogQGNwdTogQ1BVIGZv
ciB3aGljaCBhZGRyZXNzIHNwYWNlIG5lZWRzIHRvIGJlIGRlc3Ryb3llZA0KPiArICogQGFzaWR4
OiBpbnRlZ2VyIGluZGV4IG9mIHRoaXMgYWRkcmVzcyBzcGFjZQ0KPiArICoNCj4gKyAqIE5vdGUg
dGhhdCB3aXRoIEtWTSBvbmx5IG9uZSBhZGRyZXNzIHNwYWNlIGlzIHN1cHBvcnRlZC4NCj4gKyAq
Lw0KPiArdm9pZCBjcHVfYWRkcmVzc19zcGFjZV9kZXN0cm95KENQVVN0YXRlICpjcHUsIGludCBh
c2lkeCk7DQo+IA0KPiAgdm9pZCBjcHVfcGh5c2ljYWxfbWVtb3J5X3J3KGh3YWRkciBhZGRyLCB2
b2lkICpidWYsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaHdhZGRyIGxlbiwgYm9v
bCBpc193cml0ZSk7DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2h3L2NvcmUvY3B1LmggYi9pbmNs
dWRlL2h3L2NvcmUvY3B1LmgNCj4gaW5kZXggOTJhNDIzNDQzOS4uYzkwY2YzYTE2MiAxMDA2NDQN
Cj4gLS0tIGEvaW5jbHVkZS9ody9jb3JlL2NwdS5oDQo+ICsrKyBiL2luY2x1ZGUvaHcvY29yZS9j
cHUuaA0KPiBAQCAtMzY2LDYgKzM2Niw3IEBAIHN0cnVjdCBDUFVTdGF0ZSB7DQo+ICAgICAgUVNJ
TVBMRVFfSEVBRCgsIHFlbXVfd29ya19pdGVtKSB3b3JrX2xpc3Q7DQo+IA0KPiAgICAgIENQVUFk
ZHJlc3NTcGFjZSAqY3B1X2FzZXM7DQo+ICsgICAgaW50IGNwdV9hc2VzX3JlZl9jb3VudDsNCj4g
ICAgICBpbnQgbnVtX2FzZXM7DQo+ICAgICAgQWRkcmVzc1NwYWNlICphczsNCj4gICAgICBNZW1v
cnlSZWdpb24gKm1lbW9yeTsNCj4gZGlmZiAtLWdpdCBhL3NvZnRtbXUvcGh5c21lbS5jIGIvc29m
dG1tdS9waHlzbWVtLmMNCj4gaW5kZXggMTgyNzdkZGQ2Ny4uYzc1ZTNlODA0MiAxMDA2NDQNCj4g
LS0tIGEvc29mdG1tdS9waHlzbWVtLmMNCj4gKysrIGIvc29mdG1tdS9waHlzbWVtLmMNCj4gQEAg
LTc2MSw2ICs3NjEsNyBAQCB2b2lkIGNwdV9hZGRyZXNzX3NwYWNlX2luaXQoQ1BVU3RhdGUgKmNw
dSwgaW50IGFzaWR4LA0KPiANCj4gICAgICBpZiAoIWNwdS0+Y3B1X2FzZXMpIHsNCj4gICAgICAg
ICAgY3B1LT5jcHVfYXNlcyA9IGdfbmV3MChDUFVBZGRyZXNzU3BhY2UsIGNwdS0+bnVtX2FzZXMp
Ow0KPiArICAgICAgICBjcHUtPmNwdV9hc2VzX3JlZl9jb3VudCA9IGNwdS0+bnVtX2FzZXM7DQo+
ICAgICAgfQ0KPiANCj4gICAgICBuZXdhcyA9ICZjcHUtPmNwdV9hc2VzW2FzaWR4XTsNCj4gQEAg
LTc3NCw2ICs3NzUsMjkgQEAgdm9pZCBjcHVfYWRkcmVzc19zcGFjZV9pbml0KENQVVN0YXRlICpj
cHUsIGludCBhc2lkeCwNCj4gICAgICB9DQo+ICB9DQo+IA0KPiArdm9pZCBjcHVfYWRkcmVzc19z
cGFjZV9kZXN0cm95KENQVVN0YXRlICpjcHUsIGludCBhc2lkeCkNCj4gK3sNCj4gKyAgICBDUFVB
ZGRyZXNzU3BhY2UgKmNwdWFzOw0KPiArDQo+ICsgICAgYXNzZXJ0KGFzaWR4IDwgY3B1LT5udW1f
YXNlcyk7DQo+ICsgICAgYXNzZXJ0KGFzaWR4ID09IDAgfHwgIWt2bV9lbmFibGVkKCkpOw0KPiAr
ICAgIGFzc2VydChjcHUtPmNwdV9hc2VzKTsNCj4gKw0KPiArICAgIGNwdWFzID0gJmNwdS0+Y3B1
X2FzZXNbYXNpZHhdOw0KPiArICAgIGlmICh0Y2dfZW5hYmxlZCgpKSB7DQo+ICsgICAgICAgIG1l
bW9yeV9saXN0ZW5lcl91bnJlZ2lzdGVyKCZjcHVhcy0+dGNnX2FzX2xpc3RlbmVyKTsNCj4gKyAg
ICB9DQo+ICsNCj4gKyAgICBhZGRyZXNzX3NwYWNlX2Rlc3Ryb3koY3B1YXMtPmFzKTsNCj4gKw0K
PiArICAgIGNwdS0+Y3B1X2FzZXNfcmVmX2NvdW50LS07DQo+ICsgICAgaWYgKGNwdS0+Y3B1X2Fz
ZXNfcmVmX2NvdW50ID09IDApIHsNCj4gKyAgICAgICAgZ19mcmVlKGNwdS0+Y3B1X2FzZXMpOw0K
PiArICAgICAgICBjcHUtPmNwdV9hc2VzID0gTlVMTDsNCj4gKyAgICB9DQo+ICsNCj4gK30NCj4g
Kw0KPiAgQWRkcmVzc1NwYWNlICpjcHVfZ2V0X2FkZHJlc3Nfc3BhY2UoQ1BVU3RhdGUgKmNwdSwg
aW50IGFzaWR4KQ0KPiAgew0KPiAgICAgIC8qIFJldHVybiB0aGUgQWRkcmVzc1NwYWNlIGNvcnJl
c3BvbmRpbmcgdG8gdGhlIHNwZWNpZmllZCBpbmRleCAqLw0KPiAtLQ0KPiAyLjQxLjANCj4gDQo+
IA0KDQo=
