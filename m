Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E461DE68F
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgEVMQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:16:44 -0400
Received: from mail.loongson.cn ([114.242.206.163]:53530 "EHLO loongson.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728475AbgEVMQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:16:44 -0400
Received: by ajax-webmail-mail.loongson.cn (Coremail) ; Fri, 22 May 2020
 20:16:33 +0800 (GMT+08:00)
X-Originating-IP: [106.39.149.52]
Date:   Fri, 22 May 2020 20:16:33 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From:   =?UTF-8?B?5q+b56Kn5rOi?= <maobibo@loongson.cn>
To:     "Paolo Bonzini" <pbonzini@redhat.com>
Cc:     "Huacai Chen" <chenhuacai@gmail.com>,
        "Aleksandar Markovic" <aleksandar.qemu.devel@gmail.com>,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "Fuxin Zhang" <zhangfx@lemote.com>,
        "Jiaxun Yang" <jiaxun.yang@flygoat.com>
Subject: Re: Re: [PATCH V6 15/15] MAINTAINERS: Update KVM/MIPS maintainers
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.10a build 20191018(4c4f6d15)
 Copyright (c) 2002-2020 www.mailtech.cn .loongson.cn
In-Reply-To: <3269366b-7239-bb06-0bc6-cb661b9e5206@redhat.com>
References: <1589688372-3098-1-git-send-email-chenhc@lemote.com>
 <1589688372-3098-16-git-send-email-chenhc@lemote.com>
 <20200517082242.GA3939@alpha.franken.de>
 <CAHiYmc5m+UhWv__F_FKqhiTkJxgqErmFn5K_DAW2y5Pp6_4dyA@mail.gmail.com>
 <CAHiYmc4m7uxYU0coRGJS8ou=KyjC=DYs506NyXyw_-eKmPVJRQ@mail.gmail.com>
 <CAAhV-H4SspEUMLDTSZH3YmNbd+cRx3JK+mtsGo6cJ2NLKHPkKQ@mail.gmail.com>
 <CAHiYmc7ykeeF_w25785yiDjJf3AwOzfJybiS=LxfjYizn_2zEQ@mail.gmail.com>
 <23cbe8a9-21a9-93a3-79aa-8ab17818a585@redhat.com>
 <CAAhV-H6aGkxV41ymu+HPxiSBq9uw-QhmaxFxnZYJTfUay946cg@mail.gmail.com>
 <3269366b-7239-bb06-0bc6-cb661b9e5206@redhat.com>
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <36c31c9.f74c.1723c504640.Coremail.maobibo@loongson.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: AQAAf9Axtumiwsde3dc3AA--.15581W
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/1tbiAQAECV3QvLuL-QAAsw
X-Coremail-Antispam: 1Ur529EdanIXcx71UUUUU7IcSsGvfJ3iIAIbVAYjsxI4VWxJw
        CS07vEb4IE77IF4wCS07vE1I0E4x80FVAKz4kxMIAIbVAFxVCaYxvI4VCIwcAKzIAtYxBI
        daVFxhVjvjDU=
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

dGhhbmsgaHVhY2FpIGZvciB0aGUgZWZmb3J0cywga3ZtIG1pcHMgaXMgY29taW5nIGJhY2sgOikK
CgomZ3Q7IC0tLS0t5Y6f5aeL6YKu5Lu2LS0tLS0KJmd0OyDlj5Hku7bkuro6ICJQYW9sbyBCb256
aW5pIiA8cGJvbnppbmlAcmVkaGF0LmNvbT4KJmd0OyDlj5HpgIHml7bpl7Q6IDIwMjAtMDUtMjIg
MTU6MjQ6NDIgKOaYn+acn+S6lCkKJmd0OyDmlLbku7bkuro6ICJIdWFjYWkgQ2hlbiIgPGNoZW5o
dWFjYWlAZ21haWwuY29tPgomZ3Q7IOaKhOmAgTogIkFsZWtzYW5kYXIgTWFya292aWMiIDxhbGVr
c2FuZGFyLnFlbXUuZGV2ZWxAZ21haWwuY29tPiwgIlRob21hcyBCb2dlbmRvZXJmZXIiIDx0c2Jv
Z2VuZEBhbHBoYS5mcmFua2VuLmRlPiwga3ZtIDxrdm1Admdlci5rZXJuZWwub3JnPiwgIm9wZW4g
bGlzdDpNSVBTIiA8bGludXgtbWlwc0B2Z2VyLmtlcm5lbC5vcmc+LCAiRnV4aW4gWmhhbmciIDx6
aGFuZ2Z4QGxlbW90ZS5jb20+LCAiSmlheHVuIFlhbmciIDxqaWF4dW4ueWFuZ0BmbHlnb2F0LmNv
bT4KJmd0OyDkuLvpopg6IFJlOiBbUEFUQ0ggVjYgMTUvMTVdIE1BSU5UQUlORVJTOiBVcGRhdGUg
S1ZNL01JUFMgbWFpbnRhaW5lcnMKJmd0OyAKJmd0OyBPbiAyMi8wNS8yMCAwNzozNCwgSHVhY2Fp
IENoZW4gd3JvdGU6CiZndDsgJmd0OyZndDsgSSBhbSBnb2luZyB0byBxdWV1ZSB0aGVtIGZvciA1
LjguCiZndDsgJmd0OyBUaGFuayB5b3UgZm9yIHlvdXIgaGVscC4gQnV0IHRoaXMgc2VyaWVzIGRl
cGVuZHMgb24gYW4gZWFybHkgcGF0Y2gKJmd0OyAmZ3Q7IGZyb20gSmlheHVuIFlhbmcgKCJNSVBT
OiBMb29uZ3NvbjY0OiBQcm9iZSBDUFUgZmVhdHVyZXMgdmlhIENQVUNGRyIpCiZndDsgJmd0OyB3
aGljaCBzZWVtcyBvbmx5IGluIE1JUFMgdHJlZSBub3cuIFNvLCBtYXliZSB0aGlzIHNlcmllcyBp
cyBiZXR0ZXIgYmUKJmd0OyAmZ3Q7IHF1ZXVlZCBpbiBUaG9tYXMncyB0cmVlPwomZ3Q7ICZndDsg
CiZndDsgCiZndDsgVGhhdCdzIG5vdCBhIHByb2JsZW0sIEkgY2FuIGhhbmRsZSBpdCBkdXJpbmcg
dGhlIG1lcmdlIHdpbmRvdy4gIEluIHRoZQomZ3Q7IGZ1dHVyZSBJJ2QgYXNrIGZvciBhIHRvcGlj
IGJyYW5jaCBvciBzb21ldGhpbmcgbGlrZSB0aGF0LgomZ3Q7IAomZ3Q7IFRoYW5rcyBmb3IgYnJp
bmdpbmcgS1ZNL01JUFMgYmFjayB0byBsaWZlLiA6KQomZ3Q7IAomZ3Q7IFBhb2xvCjwvamlheHVu
LnlhbmdAZmx5Z29hdC5jb20+PC96aGFuZ2Z4QGxlbW90ZS5jb20+PC9saW51eC1taXBzQHZnZXIu
a2VybmVsLm9yZz48L2t2bUB2Z2VyLmtlcm5lbC5vcmc+PC90c2JvZ2VuZEBhbHBoYS5mcmFua2Vu
LmRlPjwvYWxla3NhbmRhci5xZW11LmRldmVsQGdtYWlsLmNvbT48L2NoZW5odWFjYWlAZ21haWwu
Y29tPjwvcGJvbnppbmlAcmVkaGF0LmNvbT4=
