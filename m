Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4E6BBD1B
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 20:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjCOTS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 15:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjCOTSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 15:18:54 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5FC10D4
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 12:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1678907927; x=1710443927;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=F9iGP9igsKijaS8B/vjog/6xKaUXwaHq94WMpiPMKzQ=;
  b=Lc+ju48ulihnFKP1cJNRk9qO3nF8TYBhfLy/HiTBDatP25iIkagoBB3g
   I1Mz23hevg4ZKuwwawhfcflYrCtTSuCLsOQv8YgETwg5/9ZpLzOJwnrm+
   mxF+MvAasJoBxLsZMMIbJRfVkqJZPKB7jMu1q3tAi4iMo9MLV43efycXq
   4=;
X-IronPort-AV: E=Sophos;i="5.98,262,1673913600"; 
   d="scan'208";a="193763099"
Subject: RE: [PATCH v2 28/32] contrib/gitdm: add Amazon to the domain map
Thread-Topic: [PATCH v2 28/32] contrib/gitdm: add Amazon to the domain map
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 19:18:44 +0000
Received: from EX19D007EUA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id 39AA4614E0;
        Wed, 15 Mar 2023 19:18:40 +0000 (UTC)
Received: from EX19D032EUC004.ant.amazon.com (10.252.61.238) by
 EX19D007EUA002.ant.amazon.com (10.252.50.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 15 Mar 2023 19:18:39 +0000
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX19D032EUC004.ant.amazon.com (10.252.61.238) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 15 Mar 2023 19:18:38 +0000
Received: from EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174]) by
 EX19D032EUC002.ant.amazon.com ([fe80::e696:121c:a227:174%3]) with mapi id
 15.02.1118.024; Wed, 15 Mar 2023 19:18:38 +0000
From:   "Durrant, Paul" <pdurrant@amazon.co.uk>
To:     =?utf-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
CC:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        =?utf-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        "qemu-riscv@nongnu.org" <qemu-riscv@nongnu.org>,
        Riku Voipio <riku.voipio@iki.fi>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        "Wainer dos Santos Moschetta" <wainersm@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hao Wu <wuhaotsh@google.com>, Cleber Rosa <crosa@redhat.com>,
        "Daniel Henrique Barboza" <danielhb413@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        "Aurelien Jarno" <aurelien@aurel32.net>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
        Juan Quintela <quintela@redhat.com>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@kaod.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Peter Maydell" <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Stafford Horne <shorne@gmail.com>,
        Weiwei Li <liweiwei@iscas.ac.cn>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Vijai Kumar K <vijai@behindbytes.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        "David Gibson" <david@gibson.dropbear.id.au>,
        Song Gao <gaosong@loongson.cn>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Niek Linnenbank" <nieklinnenbank@gmail.com>,
        Greg Kurz <groug@kaod.org>,
        "Laurent Vivier" <laurent@vivier.eu>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>,
        "Xiaojuan Yang" <yangxiaojuan@loongson.cn>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Alexander Bulekov <alxndr@bu.edu>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Bandan Das <bsd@redhat.com>,
        "Alistair Francis" <Alistair.Francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Beraldo Leal <bleal@redhat.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Paul Durrant <paul@xen.org>, Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Hanna Reitz <hreitz@redhat.com>, Peter Xu <peterx@redhat.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Woodhouse, David" <dwmw@amazon.co.uk>
Thread-Index: AQHZV2apTBBYyxjleEWGMj/FoJnYva78Nptg
Date:   Wed, 15 Mar 2023 19:18:38 +0000
Message-ID: <387a4403ee92487d821e6f83301b08a9@amazon.co.uk>
References: <20230315174331.2959-1-alex.bennee@linaro.org>
 <20230315174331.2959-29-alex.bennee@linaro.org>
In-Reply-To: <20230315174331.2959-29-alex.bennee@linaro.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.82.26]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4IEJlbm7DqWUgPGFsZXgu
YmVubmVlQGxpbmFyby5vcmc+DQo+IFNlbnQ6IDE1IE1hcmNoIDIwMjMgMTc6NDMNCj4gVG86IHFl
bXUtZGV2ZWxAbm9uZ251Lm9yZw0KPiBDYzogQWtpaGlrbyBPZGFraSA8YWtpaGlrby5vZGFraUBn
bWFpbC5jb20+OyBNYXJjLUFuZHLDqSBMdXJlYXUNCj4gPG1hcmNhbmRyZS5sdXJlYXVAcmVkaGF0
LmNvbT47IHFlbXUtcmlzY3ZAbm9uZ251Lm9yZzsgUmlrdSBWb2lwaW8NCj4gPHJpa3Uudm9pcGlv
QGlraS5maT47IElnb3IgTWFtbWVkb3YgPGltYW1tZWRvQHJlZGhhdC5jb20+OyBYaWFvIEd1YW5n
cm9uZw0KPiA8eGlhb2d1YW5ncm9uZy5lcmljQGdtYWlsLmNvbT47IFRob21hcyBIdXRoIDx0aHV0
aEByZWRoYXQuY29tPjsgV2FpbmVyIGRvcw0KPiBTYW50b3MgTW9zY2hldHRhIDx3YWluZXJzbUBy
ZWRoYXQuY29tPjsgRHIuIERhdmlkIEFsYW4gR2lsYmVydA0KPiA8ZGdpbGJlcnRAcmVkaGF0LmNv
bT47IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5jb20+OyBIYW8NCj4g
V3UgPHd1aGFvdHNoQGdvb2dsZS5jb20+OyBDbGViZXIgUm9zYSA8Y3Jvc2FAcmVkaGF0LmNvbT47
IERhbmllbCBIZW5yaXF1ZQ0KPiBCYXJib3phIDxkYW5pZWxoYjQxM0BnbWFpbC5jb20+OyBKYW4g
S2lzemthIDxqYW4ua2lzemthQHdlYi5kZT47IEF1cmVsaWVuDQo+IEphcm5vIDxhdXJlbGllbkBh
dXJlbDMyLm5ldD47IHFlbXUtYXJtQG5vbmdudS5vcmc7IE1hcmNlbG8gVG9zYXR0aQ0KPiA8bXRv
c2F0dGlAcmVkaGF0LmNvbT47IEVkdWFyZG8gSGFia29zdCA8ZWR1YXJkb0BoYWJrb3N0Lm5ldD47
IEFsZXhhbmRyZQ0KPiBJb29zcyA8ZXJkbmF4ZUBjcmFucy5vcmc+OyBHZXJkIEhvZmZtYW5uIDxr
cmF4ZWxAcmVkaGF0LmNvbT47IFBhbG1lcg0KPiBEYWJiZWx0IDxwYWxtZXJAZGFiYmVsdC5jb20+
OyBJbHlhIExlb3Noa2V2aWNoIDxpaWlAbGludXguaWJtLmNvbT47IHFlbXUtDQo+IHBwY0Bub25n
bnUub3JnOyBKdWFuIFF1aW50ZWxhIDxxdWludGVsYUByZWRoYXQuY29tPjsgQ8OpZHJpYyBMZSBH
b2F0ZXINCj4gPGNsZ0BrYW9kLm9yZz47IERhcnJlbiBLZW5ueSA8ZGFycmVuLmtlbm55QG9yYWNs
ZS5jb20+Ow0KPiBrdm1Admdlci5rZXJuZWwub3JnOyBNYXJjZWwgQXBmZWxiYXVtIDxtYXJjZWwu
YXBmZWxiYXVtQGdtYWlsLmNvbT47IFBldGVyDQo+IE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGlu
YXJvLm9yZz47IFJpY2hhcmQgSGVuZGVyc29uDQo+IDxyaWNoYXJkLmhlbmRlcnNvbkBsaW5hcm8u
b3JnPjsgU3RhZmZvcmQgSG9ybmUgPHNob3JuZUBnbWFpbC5jb20+OyBXZWl3ZWkNCj4gTGkgPGxp
d2Vpd2VpQGlzY2FzLmFjLmNuPjsgU3VuaWwgViBMIDxzdW5pbHZsQHZlbnRhbmFtaWNyby5jb20+
OyBTdGVmYW4NCj4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+OyBUaG9tYXMgSHV0aCA8
aHV0aEB0dXhmYW1pbHkub3JnPjsgVmlqYWkNCj4gS3VtYXIgSyA8dmlqYWlAYmVoaW5kYnl0ZXMu
Y29tPjsgTGl1IFpoaXdlaQ0KPiA8emhpd2VpX2xpdUBsaW51eC5hbGliYWJhLmNvbT47IERhdmlk
IEdpYnNvbg0KPiA8ZGF2aWRAZ2lic29uLmRyb3BiZWFyLmlkLmF1PjsgU29uZyBHYW8gPGdhb3Nv
bmdAbG9vbmdzb24uY24+OyBQYW9sbw0KPiBCb256aW5pIDxwYm9uemluaUByZWRoYXQuY29tPjsg
TWljaGFlbCBTLiBUc2lya2luIDxtc3RAcmVkaGF0LmNvbT47IE5pZWsNCj4gTGlubmVuYmFuayA8
bmlla2xpbm5lbmJhbmtAZ21haWwuY29tPjsgR3JlZyBLdXJ6IDxncm91Z0BrYW9kLm9yZz47IExh
dXJlbnQNCj4gVml2aWVyIDxsYXVyZW50QHZpdmllci5ldT47IFFpdWhhbyBMaSA8UWl1aGFvLkxp
QG91dGxvb2suY29tPjsgUGhpbGlwcGUNCj4gTWF0aGlldS1EYXVkw6kgPHBoaWxtZEBsaW5hcm8u
b3JnPjsgWGlhb2p1YW4gWWFuZw0KPiA8eWFuZ3hpYW9qdWFuQGxvb25nc29uLmNuPjsgTWFobW91
ZCBNYW5kb3VyIDxtYS5tYW5kb3VyckBnbWFpbC5jb20+Ow0KPiBBbGV4YW5kZXIgQnVsZWtvdiA8
YWx4bmRyQGJ1LmVkdT47IEppYXh1biBZYW5nIDxqaWF4dW4ueWFuZ0BmbHlnb2F0LmNvbT47DQo+
IHFlbXUtYmxvY2tAbm9uZ251Lm9yZzsgWWFuYW4gV2FuZyA8d2FuZ3lhbmFuNTVAaHVhd2VpLmNv
bT47IERhdmlkDQo+IFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz47IHFlbXUtczM5MHhA
bm9uZ251Lm9yZzsgU3RyYWhpbmphIEphbmtvdmljDQo+IDxzdHJhaGluamEucC5qYW5rb3ZpY0Bn
bWFpbC5jb20+OyBCYW5kYW4gRGFzIDxic2RAcmVkaGF0LmNvbT47IEFsaXN0YWlyDQo+IEZyYW5j
aXMgPEFsaXN0YWlyLkZyYW5jaXNAd2RjLmNvbT47IEFsZWtzYW5kYXIgUmlrYWxvDQo+IDxhbGVr
c2FuZGFyLnJpa2Fsb0BzeXJtaWEuY29tPjsgVHlyb25lIFRpbmcgPGtmdGluZ0BudXZvdG9uLmNv
bT47IEtldmluDQo+IFdvbGYgPGt3b2xmQHJlZGhhdC5jb20+OyBEYXZpZCBIaWxkZW5icmFuZCA8
ZGF2aWRAcmVkaGF0LmNvbT47IEJlcmFsZG8NCj4gTGVhbCA8YmxlYWxAcmVkaGF0LmNvbT47IEJl
bmlhbWlubyBHYWx2YW5pIDxiLmdhbHZhbmlAZ21haWwuY29tPjsgUGF1bA0KPiBEdXJyYW50IDxw
YXVsQHhlbi5vcmc+OyBCaW4gTWVuZyA8YmluLm1lbmdAd2luZHJpdmVyLmNvbT47IFN1bmlsDQo+
IE11dGh1c3dhbXkgPHN1bmlsbXV0QG1pY3Jvc29mdC5jb20+OyBIYW5uYSBSZWl0eiA8aHJlaXR6
QHJlZGhhdC5jb20+Ow0KPiBQZXRlciBYdSA8cGV0ZXJ4QHJlZGhhdC5jb20+OyBBbGV4IEJlbm7D
qWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+OyBHcmFmDQo+IChBV1MpLCBBbGV4YW5kZXIgPGdy
YWZAYW1hem9uLmRlPjsgRHVycmFudCwgUGF1bCA8cGR1cnJhbnRAYW1hem9uLmNvLnVrPjsNCj4g
V29vZGhvdXNlLCBEYXZpZCA8ZHdtd0BhbWF6b24uY28udWs+DQo+IFN1YmplY3Q6IFtFWFRFUk5B
TF0gW1BBVENIIHYyIDI4LzMyXSBjb250cmliL2dpdGRtOiBhZGQgQW1hem9uIHRvIHRoZQ0KPiBk
b21haW4gbWFwDQo+IA0KPiBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRz
aWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdA0KPiBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdw0KPiB0
aGUgY29udGVudCBpcyBzYWZlLg0KPiANCj4gDQo+IA0KPiBXZSBoYXZlIG11bHRpcGxlIGNvbnRy
aWJ1dG9ycyBmcm9tIGJvdGggLmNvLnVrIGFuZCAuY29tIHZlcnNpb25zIG9mDQo+IHRoZSBhZGRy
ZXNzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPg0KPiBDYzogQWxleGFuZGVyIEdyYWYgPGdyYWZAYW1hem9uLmNvbT4NCj4gQ2M6IFBh
dWwgRHVycmFudCA8cGR1cnJhbnRAYW1hem9uLmNvbT4NCj4gQ2M6IERhdmlkIFdvb29kaG91c2Ug
PGR3bXdAYW1hem9uLmNvLnVrPg0KPiBSZXZpZXdlZC1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVk
w6kgPHBoaWxtZEBsaW5hcm8ub3JnPg0KPiBNZXNzYWdlLUlkOiA8MjAyMzAzMTAxODAzMzIuMjI3
NDgyNy03LWFsZXguYmVubmVlQGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgY29udHJpYi9naXRkbS9k
b21haW4tbWFwIHwgMiArKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2NvbnRyaWIvZ2l0ZG0vZG9tYWluLW1hcCBiL2NvbnRyaWIvZ2l0ZG0v
ZG9tYWluLW1hcA0KPiBpbmRleCA0YTk4OGM1YjVmLi44ZGNlMjc2YTFjIDEwMDY0NA0KPiAtLS0g
YS9jb250cmliL2dpdGRtL2RvbWFpbi1tYXANCj4gKysrIGIvY29udHJpYi9naXRkbS9kb21haW4t
bWFwDQo+IEBAIC00LDYgKzQsOCBAQA0KPiAgIyBUaGlzIG1hcHMgZW1haWwgZG9tYWlucyB0byBu
aWNlIGVhc3kgdG8gcmVhZCBjb21wYW55IG5hbWVzDQo+ICAjDQo+IA0KPiArYW1hem9uLmNvbSAg
ICAgIEFtYXpvbg0KPiArYW1hem9uLmNvLnVrICAgIEFtYXpvbg0KDQpZb3UgbWlnaHQgd2FudCAn
YW1hem9uLmRlJyB0b28gYnV0IGFzIGZhciBhcyBpdCBnb2VzLi4uDQoNClJldmlld2VkLWJ5OiBQ
YXVsIER1cnJhbnQgPHBkdXJyYW50QGFtYXpvbi5jb20+DQoNCj4gIGFtZC5jb20gICAgICAgICBB
TUQNCj4gIGFzcGVlZHRlY2guY29tICBBU1BFRUQgVGVjaG5vbG9neSBJbmMuDQo+ICBiYWlkdS5j
b20gICAgICAgQmFpZHUNCj4gLS0NCj4gMi4zOS4yDQoNCg==
