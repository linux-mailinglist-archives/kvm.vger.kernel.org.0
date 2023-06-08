Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9B7727F42
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 13:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235190AbjFHLpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 07:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbjFHLpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 07:45:51 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4AF52132;
        Thu,  8 Jun 2023 04:45:14 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.111])
        by gateway (Coremail) with SMTP id _____8DxCeorv4Fk_oIAAA--.1878S3;
        Thu, 08 Jun 2023 19:44:43 +0800 (CST)
Received: from zhaotianrui$loongson.cn ( [10.20.42.111] ) by
 ajax-webmail-localhost.localdomain (Coremail) ; Thu, 8 Jun 2023 19:44:40
 +0800 (GMT+08:00)
X-Originating-IP: [10.20.42.111]
Date:   Thu, 8 Jun 2023 19:44:40 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?6LW15aSp55Ge?= <zhaotianrui@loongson.cn>
To:     "Youling Tang" <tangyouling@loongson.cn>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Huacai Chen" <chenhuacai@kernel.org>,
        "WANG Xuerui" <kernel@xen0n.name>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, "Jens Axboe" <axboe@kernel.dk>,
        "Mark Brown" <broonie@kernel.org>,
        "Alex Deucher" <alexander.deucher@amd.com>,
        "Oliver Upton" <oliver.upton@linux.dev>, maobibo@loongson.cn,
        "Xi Ruoyao" <xry111@xry111.site>
Subject: Re: Re: [PATCH v12 26/31] LoongArch: KVM: Implement kvm exception
 vector
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20220411(feba7c69)
 Copyright (c) 2002-2023 www.mailtech.cn .loongson.cn
In-Reply-To: <b0e8a311-d988-a1be-a256-130adcdbbfc6@loongson.cn>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-27-zhaotianrui@loongson.cn>
 <b0e8a311-d988-a1be-a256-130adcdbbfc6@loongson.cn>
Content-Transfer-Encoding: base64
X-CM-CTRLDATA: 7YaRS2Zvb3Rlcl90eHQ9MzczMTo2MTI=
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <592bfebe.ac52.1889ad2b799.Coremail.zhaotianrui@loongson.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAf8Bxt+Qov4FkRXUHAA--.665W
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/1tbiAQAQAGSAc4EYygABsU
X-Coremail-Antispam: 1Uk129KBj93XoWxCw4DZr45AF1DZFyUJF4UKFX_yoWrXF1fpF
        yfCw1jkr4UW342v3W2kr4q9F13A3yxKr17CrsrK345Zw4vvr95J3yvq39akFsxKryqvF1x
        ZayDtr1Y9a1UG3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUQab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
        6r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lFcxC0VAYjxAxZF0Ew4CEw7xC0wACY4xI67k04243AVC20s07MxkF7I0En4kS14v2
        6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14
        v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
        IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JwCE64xvF2
        IEb7IF0Fy7YxBIdaVFxhVjvjDU0xZFpf9x07jYiihUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CgoKPiAtLS0tLeWOn+Wni+mCruS7ti0tLS0tCj4g5Y+R5Lu25Lq6OiAiWW91bGluZyBUYW5nIiA8
dGFuZ3lvdWxpbmdAbG9vbmdzb24uY24+Cj4g5Y+R6YCB5pe26Ze0OjIwMjMtMDYtMDYgMTU6MDA6
MTEgKOaYn+acn+S6jCkKPiDmlLbku7bkuro6ICJUaWFucnVpIFpoYW8iIDx6aGFvdGlhbnJ1aUBs
b29uZ3Nvbi5jbj4KPiDmioTpgIE6IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcsIGt2bUB2
Z2VyLmtlcm5lbC5vcmcsICJQYW9sbyBCb256aW5pIiA8cGJvbnppbmlAcmVkaGF0LmNvbT4sICJI
dWFjYWkgQ2hlbiIgPGNoZW5odWFjYWlAa2VybmVsLm9yZz4sICJXQU5HIFh1ZXJ1aSIgPGtlcm5l
bEB4ZW4wbi5uYW1lPiwgIkdyZWcgS3JvYWgtSGFydG1hbiIgPGdyZWdraEBsaW51eGZvdW5kYXRp
b24ub3JnPiwgbG9vbmdhcmNoQGxpc3RzLmxpbnV4LmRldiwgIkplbnMgQXhib2UiIDxheGJvZUBr
ZXJuZWwuZGs+LCAiTWFyayBCcm93biIgPGJyb29uaWVAa2VybmVsLm9yZz4sICJBbGV4IERldWNo
ZXIiIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPiwgIk9saXZlciBVcHRvbiIgPG9saXZlci51
cHRvbkBsaW51eC5kZXY+LCBtYW9iaWJvQGxvb25nc29uLmNuLCAiWGkgUnVveWFvIiA8eHJ5MTEx
QHhyeTExMS5zaXRlPgo+IOS4u+mimDogUmU6IFtQQVRDSCB2MTIgMjYvMzFdIExvb25nQXJjaDog
S1ZNOiBJbXBsZW1lbnQga3ZtIGV4Y2VwdGlvbiB2ZWN0b3IKPiAKPiAKPiAKPiBPbiAwNS8zMC8y
MDIzIDA5OjUyIEFNLCBUaWFucnVpIFpoYW8gd3JvdGU6Cj4gPiBJbXBsZW1lbnQga3ZtIGV4Y2Vw
dGlvbiB2ZWN0b3IsIHVzaW5nIF9rdm1fZmF1bHRfdGFibGVzIGFycmF5IHRvIHNhdmUKPiA+IHRo
ZSBoYW5kbGUgZnVuY3Rpb24gcG9pbnRlciBhbmQgaXQgaXMgdXNlZCB3aGVuIHZjcHUgaGFuZGxl
IGV4aXQuCj4gPgo+ID4gU2lnbmVkLW9mZi1ieTogVGlhbnJ1aSBaaGFvIDx6aGFvdGlhbnJ1aUBs
b29uZ3Nvbi5jbj4KPiA+IC0tLQo+ID4gIGFyY2gvbG9vbmdhcmNoL2t2bS9leGl0LmMgfCA0OCAr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgNDggaW5zZXJ0aW9ucygrKQo+ID4KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2xvb25nYXJjaC9r
dm0vZXhpdC5jIGIvYXJjaC9sb29uZ2FyY2gva3ZtL2V4aXQuYwo+ID4gaW5kZXggMTBmOTkyMmE3
ZTc2Li42MjUwNDVmYzk1YzggMTAwNjQ0Cj4gPiAtLS0gYS9hcmNoL2xvb25nYXJjaC9rdm0vZXhp
dC5jCj4gPiArKysgYi9hcmNoL2xvb25nYXJjaC9rdm0vZXhpdC5jCj4gPiBAQCAtNjU3LDMgKzY1
Nyw1MSBAQCBzdGF0aWMgaW50IF9rdm1faGFuZGxlX2ZwdV9kaXNhYmxlZChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpCj4gPiAgCWt2bV9vd25fZnB1KHZjcHUpOwo+ID4gIAlyZXR1cm4gUkVTVU1FX0dV
RVNUOwo+ID4gIH0KPiA+ICsKPiA+ICsvKgo+ID4gKyAqIExvb25nYXJjaCBLVk0gY2FsbGJhY2sg
aGFuZGxpbmcgZm9yIG5vdCBpbXBsZW1lbnRlZCBndWVzdCBleGl0aW5nCj4gPiArICovCj4gPiAr
c3RhdGljIGludCBfa3ZtX2ZhdWx0X25pKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiA+ICt7Cj4g
PiArCXVuc2lnbmVkIGxvbmcgZXN0YXQsIGJhZHY7Cj4gPiArCXVuc2lnbmVkIGludCBleGNjb2Rl
LCBpbnN0Owo+ID4gKwo+ID4gKwkvKgo+ID4gKwkgKiAgRmV0Y2ggdGhlIGluc3RydWN0aW9uLgo+
ID4gKwkgKi8KPiA+ICsJYmFkdiA9IHZjcHUtPmFyY2guYmFkdjsKPiA+ICsJZXN0YXQgPSB2Y3B1
LT5hcmNoLmhvc3RfZXN0YXQ7Cj4gPiArCWV4Y2NvZGUgPSAoZXN0YXQgJiBDU1JfRVNUQVRfRVhD
KSA+PiBDU1JfRVNUQVRfRVhDX1NISUZUOwo+ID4gKwlpbnN0ID0gdmNwdS0+YXJjaC5iYWRpOwo+
ID4gKwlrdm1fZXJyKCJFeGNjb2RlOiAlZCBQQz0lI2x4IGluc3Q9MHglMDh4IEJhZFZhZGRyPSUj
bHggZXN0YXQ9JSNseFxuIiwKPiA+ICsJCQlleGNjb2RlLCB2Y3B1LT5hcmNoLnBjLCBpbnN0LCBi
YWR2LCByZWFkX2djc3JfZXN0YXQoKSk7Cj4gPiArCWt2bV9hcmNoX3ZjcHVfZHVtcF9yZWdzKHZj
cHUpOwo+ID4gKwl2Y3B1LT5ydW4tPmV4aXRfcmVhc29uID0gS1ZNX0VYSVRfSU5URVJOQUxfRVJS
T1I7Cj4gPiArCj4gPiArCXJldHVybiBSRVNVTUVfSE9TVDsKPiA+ICt9Cj4gPiArCj4gPiArc3Rh
dGljIGV4aXRfaGFuZGxlX2ZuIF9rdm1fZmF1bHRfdGFibGVzW0VYQ0NPREVfSU5UX1NUQVJUXSA9
IHsKPiA+ICsJW0VYQ0NPREVfVExCTF0JCT0gX2t2bV9oYW5kbGVfcmVhZF9mYXVsdCwKPiA+ICsJ
W0VYQ0NPREVfVExCSV0JCT0gX2t2bV9oYW5kbGVfcmVhZF9mYXVsdCwKPiA+ICsJW0VYQ0NPREVf
VExCTlJdCQk9IF9rdm1faGFuZGxlX3JlYWRfZmF1bHQsCj4gPiArCVtFWENDT0RFX1RMQk5YXQkJ
PSBfa3ZtX2hhbmRsZV9yZWFkX2ZhdWx0LAo+ID4gKwlbRVhDQ09ERV9UTEJTXQkJPSBfa3ZtX2hh
bmRsZV93cml0ZV9mYXVsdCwKPiA+ICsJW0VYQ0NPREVfVExCTV0JCT0gX2t2bV9oYW5kbGVfd3Jp
dGVfZmF1bHQsCj4gPiArCVtFWENDT0RFX0ZQRElTXQkJPSBfa3ZtX2hhbmRsZV9mcHVfZGlzYWJs
ZWQsCj4gPiArCVtFWENDT0RFX0dTUFJdCQk9IF9rdm1faGFuZGxlX2dzcHIsCj4gPiArfTsKPiBJ
dCBjYW4gYmUgbW9kaWZpZWQgYXMgZm9sbG93cyBhbmQgcmVtb3ZlIF9rdm1faW5pdF9mYXVsdCgp
Lgo+IAo+IHN0YXRpYyBleGl0X2hhbmRsZV9mbiBfa3ZtX2ZhdWx0X3RhYmxlc1tFWENDT0RFX0lO
VF9TVEFSVF0gPSB7Cj4gCVswIC4uLiBFWENDT0RFX0lOVF9TVEFSVCAtIDFdCT0gX2t2bV9mYXVs
dF9uaSwKPiAKPiAJW0VYQ0NPREVfVExCTF0JCQk9IF9rdm1faGFuZGxlX3JlYWRfZmF1bHQsCj4g
CVtFWENDT0RFX1RMQkldCQkJPSBfa3ZtX2hhbmRsZV9yZWFkX2ZhdWx0LAo+IAlbRVhDQ09ERV9U
TEJOUl0JCQk9IF9rdm1faGFuZGxlX3JlYWRfZmF1bHQsCj4gCVtFWENDT0RFX1RMQk5YXQkJCT0g
X2t2bV9oYW5kbGVfcmVhZF9mYXVsdCwKPiAJW0VYQ0NPREVfVExCU10JCQk9IF9rdm1faGFuZGxl
X3dyaXRlX2ZhdWx0LAo+IAlbRVhDQ09ERV9UTEJNXQkJCT0gX2t2bV9oYW5kbGVfd3JpdGVfZmF1
bHQsCj4gCVtFWENDT0RFX0ZQRElTXQkJCT0gX2t2bV9oYW5kbGVfZnB1X2Rpc2FibGVkLAo+IAlb
RVhDQ09ERV9HU1BSXQkJCT0gX2t2bV9oYW5kbGVfZ3NwciwKPiB9Owo+IAo+IFRoYW5rcywKPiBZ
b3VsaW5nCkhpIFlvdWxpbmcsCldoZW4gSSBjb21waWxlIHRoaXMgY29kZSB3aXRoIFc9MSwgdGhl
cmUgaXMgYSB3YXJuaW5nOiBpbml0aWFsaXplZCBmaWVsZCBvdmVyd3JpdHRlbiBbLVdvdmVycmlk
ZS1pbml0XSwgc28gY29uc2lkZXJpbmcgdGhpcyBwcm9ibGVtIEkgdGhpbmsgd2UgaGF2ZSB0byBr
ZWVwIHRoZSBwcmV2aW91cyBfa3ZtX2luaXRfZmF1bHQsIHdoYXQgZG8geW91IHRoaW5rIG9mIGl0
PwoKVGhhbmtzClRpYW5ydWkgWmhhbwo+IAo+ID4gKwo+ID4gK2ludCBfa3ZtX2hhbmRsZV9mYXVs
dChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGludCBmYXVsdCkKPiA+ICt7Cj4gPiArCXJldHVybiBf
a3ZtX2ZhdWx0X3RhYmxlc1tmYXVsdF0odmNwdSk7Cj4gPiArfQo+ID4gKwo+ID4gK3ZvaWQgX2t2
bV9pbml0X2ZhdWx0KHZvaWQpCj4gPiArewo+ID4gKwlpbnQgaTsKPiA+ICsKPiA+ICsJZm9yIChp
ID0gMDsgaSA8IEVYQ0NPREVfSU5UX1NUQVJUOyBpKyspCj4gPiArCQlpZiAoIV9rdm1fZmF1bHRf
dGFibGVzW2ldKQo+ID4gKwkJCV9rdm1fZmF1bHRfdGFibGVzW2ldID0gX2t2bV9mYXVsdF9uaTsK
PiA+ICt9Cj4gPgoNCg0K5pys6YKu5Lu25Y+K5YW26ZmE5Lu25ZCr5pyJ6b6Z6Iqv5Lit56eR55qE
5ZWG5Lia56eY5a+G5L+h5oGv77yM5LuF6ZmQ5LqO5Y+R6YCB57uZ5LiK6Z2i5Zyw5Z2A5Lit5YiX
5Ye655qE5Liq5Lq65oiW576k57uE44CC56aB5q2i5Lu75L2V5YW25LuW5Lq65Lul5Lu75L2V5b2i
5byP5L2/55So77yI5YyF5ous5L2G5LiN6ZmQ5LqO5YWo6YOo5oiW6YOo5YiG5Zyw5rOE6Zyy44CB
5aSN5Yi25oiW5pWj5Y+R77yJ5pys6YKu5Lu25Y+K5YW26ZmE5Lu25Lit55qE5L+h5oGv44CC5aaC
5p6c5oKo6ZSZ5pS25pys6YKu5Lu277yM6K+35oKo56uL5Y2z55S16K+d5oiW6YKu5Lu26YCa55+l
5Y+R5Lu25Lq65bm25Yig6Zmk5pys6YKu5Lu244CCIA0KVGhpcyBlbWFpbCBhbmQgaXRzIGF0dGFj
aG1lbnRzIGNvbnRhaW4gY29uZmlkZW50aWFsIGluZm9ybWF0aW9uIGZyb20gTG9vbmdzb24gVGVj
aG5vbG9neSAsIHdoaWNoIGlzIGludGVuZGVkIG9ubHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5
IHdob3NlIGFkZHJlc3MgaXMgbGlzdGVkIGFib3ZlLiBBbnkgdXNlIG9mIHRoZSBpbmZvcm1hdGlv
biBjb250YWluZWQgaGVyZWluIGluIGFueSB3YXkgKGluY2x1ZGluZywgYnV0IG5vdCBsaW1pdGVk
IHRvLCB0b3RhbCBvciBwYXJ0aWFsIGRpc2Nsb3N1cmUsIHJlcHJvZHVjdGlvbiBvciBkaXNzZW1p
bmF0aW9uKSBieSBwZXJzb25zIG90aGVyIHRoYW4gdGhlIGludGVuZGVkIHJlY2lwaWVudChzKSBp
cyBwcm9oaWJpdGVkLiBJZiB5b3UgcmVjZWl2ZSB0aGlzIGVtYWlsIGluIGVycm9yLCBwbGVhc2Ug
bm90aWZ5IHRoZSBzZW5kZXIgYnkgcGhvbmUgb3IgZW1haWwgaW1tZWRpYXRlbHkgYW5kIGRlbGV0
ZSBpdC4g

