Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB714C658B
	for <lists+kvm@lfdr.de>; Mon, 28 Feb 2022 10:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiB1JSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 04:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiB1JSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 04:18:33 -0500
Received: from spam.unicloud.com (gw.haihefund.cn [220.194.70.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DAD33A1F
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 01:17:53 -0800 (PST)
Received: from eage.unicloud.com ([220.194.70.35])
        by spam.unicloud.com with ESMTP id 21S9HI4t050430;
        Mon, 28 Feb 2022 17:17:18 +0800 (GMT-8)
        (envelope-from luofei@unicloud.com)
Received: from zgys-ex-mb09.Unicloud.com (10.10.0.24) by
 zgys-ex-mb11.Unicloud.com (10.10.0.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.17; Mon, 28 Feb 2022 17:17:17 +0800
Received: from zgys-ex-mb09.Unicloud.com ([fe80::eda0:6815:ca71:5aa]) by
 zgys-ex-mb09.Unicloud.com ([fe80::eda0:6815:ca71:5aa%16]) with mapi id
 15.01.2375.017; Mon, 28 Feb 2022 17:17:17 +0800
From:   =?gb2312?B?wt63yQ==?= <luofei@unicloud.com>
To:     qemu-devel <qemu-devel@nongnu.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBpMzg2OiBTZXQgTUNHX1NUQVRVU19SSVBWIGJpdCBm?=
 =?gb2312?Q?or_mce_SRAR_error?=
Thread-Topic: [PATCH] i386: Set MCG_STATUS_RIPV bit for mce SRAR error
Thread-Index: AQHYDdpiM0Sj+cD120OyD4W4YWbm6ayo7CVD
Date:   Mon, 28 Feb 2022 09:17:17 +0000
Message-ID: <4e86fc594ede4b029d0f82d9d1ca0142@unicloud.com>
References: <20220120084634.131450-1-luofei@unicloud.com>
In-Reply-To: <20220120084634.131450-1-luofei@unicloud.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.10.1.7]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-DNSRBL: 
X-MAIL: spam.unicloud.com 21S9HI4t050430
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

cGluZw0KaHR0cHM6Ly9wYXRjaGV3Lm9yZy9RRU1VLzIwMjIwMTIwMDg0NjM0LjEzMTQ1MC0xLWx1
b2ZlaUB1bmljbG91ZC5jb20vDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fDQq3orz+yMs6IMLet8kNCreiy83KsbzkOiAyMDIyxOox1MIyMMjVIDE2OjQ2DQrK1bz+yMs6
IHFlbXUtZGV2ZWwNCrOty806IFBhb2xvIEJvbnppbmk7IE1hcmNlbG8gVG9zYXR0aTsga3ZtQHZn
ZXIua2VybmVsLm9yZzsgwt63yQ0K1vfM4jogW1BBVENIXSBpMzg2OiBTZXQgTUNHX1NUQVRVU19S
SVBWIGJpdCBmb3IgbWNlIFNSQVIgZXJyb3INCg0KSW4gdGhlIHBoeXNpY2FsIG1hY2hpbmUgZW52
aXJvbm1lbnQsIHdoZW4gYSBTUkFSIGVycm9yIG9jY3VycywNCnRoZSBJQTMyX01DR19TVEFUVVMg
UklQViBiaXQgaXMgc2V0LCBidXQgcWVtdSBkb2VzIG5vdCBzZXQgdGhpcw0KYml0LiBXaGVuIHFl
bXUgaW5qZWN0cyBhbiBTUkFSIGVycm9yIGludG8gdmlydHVhbCBtYWNoaW5lLCB0aGUNCnZpcnR1
YWwgbWFjaGluZSBrZXJuZWwganVzdCBjYWxsIGRvX21hY2hpbmVfY2hlY2soKSB0byBraWxsIHRo
ZQ0KY3VycmVudCB0YXNrLCBidXQgbm90IGNhbGwgbWVtb3J5X2ZhaWx1cmUoKSB0byBpc29sYXRl
IHRoZSBmYXVsdHkNCnBhZ2UsIHdoaWNoIHdpbGwgY2F1c2UgdGhlIGZhdWx0eSBwYWdlIHRvIGJl
IGFsbG9jYXRlZCBhbmQgdXNlZA0KcmVwZWF0ZWRseS4gSWYgdXNlZCBieSB0aGUgdmlydHVhbCBt
YWNoaW5lIGtlcm5lbCwgaXQgd2lsbCBjYXVzZQ0KdGhlIHZpcnR1YWwgbWFjaGluZSB0byBjcmFz
aA0KDQpTaWduZWQtb2ZmLWJ5OiBsdW9mZWkgPGx1b2ZlaUB1bmljbG91ZC5jb20+DQotLS0NCiB0
YXJnZXQvaTM4Ni9rdm0va3ZtLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS90YXJnZXQvaTM4Ni9rdm0va3ZtLmMg
Yi90YXJnZXQvaTM4Ni9rdm0va3ZtLmMNCmluZGV4IDJjOGZlYjRhNmYuLjE0NjU1NTc3ZjAgMTAw
NjQ0DQotLS0gYS90YXJnZXQvaTM4Ni9rdm0va3ZtLmMNCisrKyBiL3RhcmdldC9pMzg2L2t2bS9r
dm0uYw0KQEAgLTUzNyw3ICs1MzcsNyBAQCBzdGF0aWMgdm9pZCBrdm1fbWNlX2luamVjdChYODZD
UFUgKmNwdSwgaHdhZGRyIHBhZGRyLCBpbnQgY29kZSkNCg0KICAgICBpZiAoY29kZSA9PSBCVVNf
TUNFRVJSX0FSKSB7DQogICAgICAgICBzdGF0dXMgfD0gTUNJX1NUQVRVU19BUiB8IDB4MTM0Ow0K
LSAgICAgICAgbWNnX3N0YXR1cyB8PSBNQ0dfU1RBVFVTX0VJUFY7DQorICAgICAgICBtY2dfc3Rh
dHVzIHw9IE1DR19TVEFUVVNfUklQViB8IE1DR19TVEFUVVNfRUlQVjsNCiAgICAgfSBlbHNlIHsN
CiAgICAgICAgIHN0YXR1cyB8PSAweGMwOw0KICAgICAgICAgbWNnX3N0YXR1cyB8PSBNQ0dfU1RB
VFVTX1JJUFY7DQotLQ0KMi4yNy4wDQoNCg==
