Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976CF2A677A
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730792AbgKDPWH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:22:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728380AbgKDPWD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:22:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ibeTODLX+Mzom4ZToC9+tF5dVJPoyLG0M5njv6JL8uc=;
        b=OvLYa5KPhdmMeuQt4mvYdQbDqGmarFIZbTNn0ByjP7Vj4eRmCPx3LHY8A8GtVPnP2vI6t9
        1LsyRMaCX2C6TO/IbwiKMB2avxvgQ3WRmzUYDzvatjHP6ijKGOl72g0RUtMYAlEiCsRDSW
        yIhhkPimIQfn12S+2lCEdReEPy09yso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-4HcHifymMeqvaMKKdJjvng-1; Wed, 04 Nov 2020 10:21:59 -0500
X-MC-Unique: 4HcHifymMeqvaMKKdJjvng-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F0501868403;
        Wed,  4 Nov 2020 15:21:58 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 099FC60C84;
        Wed,  4 Nov 2020 15:21:51 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>, Fam Zheng <fam@euphon.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Keith Busch <kbusch@kernel.org>, Max Reitz <mreitz@redhat.com>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Coiby Xu <Coiby.Xu@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Klaus Jensen <its@irrelevant.dk>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PULL 31/33] util/vfio-helpers: Improve DMA trace events
Date:   Wed,  4 Nov 2020 15:18:26 +0000
Message-Id: <20201104151828.405824-32-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKRm9yIGRl
YnVnZ2luZyBwdXJwb3NlLCB0cmFjZSB3aGVyZSBETUEgcmVnaW9ucyBhcmUgbWFwcGVkLgoKUmV2
aWV3ZWQtYnk6IEZhbSBaaGVuZyA8ZmFtQGV1cGhvbi5uZXQ+ClJldmlld2VkLWJ5OiBTdGVmYW4g
SGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1h
dGhpZXUtRGF1ZMOpIDxwaGlsbWRAcmVkaGF0LmNvbT4KTWVzc2FnZS1pZDogMjAyMDExMDMwMjA3
MzMuMjMwMzE0OC02LXBoaWxtZEByZWRoYXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpu
b2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1
Z2VyQHJlZGhhdC5jb20+Ci0tLQogdXRpbC92ZmlvLWhlbHBlcnMuYyB8IDMgKystCiB1dGlsL3Ry
YWNlLWV2ZW50cyAgIHwgNSArKystLQogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvdXRpbC92ZmlvLWhlbHBlcnMuYyBiL3V0aWwv
dmZpby1oZWxwZXJzLmMKaW5kZXggMjc4YzU0OTAyZS4uYzI0YTUxMGRmOCAxMDA2NDQKLS0tIGEv
dXRpbC92ZmlvLWhlbHBlcnMuYworKysgYi91dGlsL3ZmaW8taGVscGVycy5jCkBAIC02MjcsNyAr
NjI3LDcgQEAgc3RhdGljIGludCBxZW11X3ZmaW9fZG9fbWFwcGluZyhRRU1VVkZJT1N0YXRlICpz
LCB2b2lkICpob3N0LCBzaXplX3Qgc2l6ZSwKICAgICAgICAgLnZhZGRyID0gKHVpbnRwdHJfdClo
b3N0LAogICAgICAgICAuc2l6ZSA9IHNpemUsCiAgICAgfTsKLSAgICB0cmFjZV9xZW11X3ZmaW9f
ZG9fbWFwcGluZyhzLCBob3N0LCBzaXplLCBpb3ZhKTsKKyAgICB0cmFjZV9xZW11X3ZmaW9fZG9f
bWFwcGluZyhzLCBob3N0LCBpb3ZhLCBzaXplKTsKIAogICAgIGlmIChpb2N0bChzLT5jb250YWlu
ZXIsIFZGSU9fSU9NTVVfTUFQX0RNQSwgJmRtYV9tYXApKSB7CiAgICAgICAgIGVycm9yX3JlcG9y
dCgiVkZJT19NQVBfRE1BIGZhaWxlZDogJXMiLCBzdHJlcnJvcihlcnJubykpOwpAQCAtNzgzLDYg
Kzc4Myw3IEBAIGludCBxZW11X3ZmaW9fZG1hX21hcChRRU1VVkZJT1N0YXRlICpzLCB2b2lkICpo
b3N0LCBzaXplX3Qgc2l6ZSwKICAgICAgICAgICAgIH0KICAgICAgICAgfQogICAgIH0KKyAgICB0
cmFjZV9xZW11X3ZmaW9fZG1hX21hcHBlZChzLCBob3N0LCBpb3ZhMCwgc2l6ZSk7CiAgICAgaWYg
KGlvdmEpIHsKICAgICAgICAgKmlvdmEgPSBpb3ZhMDsKICAgICB9CmRpZmYgLS1naXQgYS91dGls
L3RyYWNlLWV2ZW50cyBiL3V0aWwvdHJhY2UtZXZlbnRzCmluZGV4IDUyZDQzY2RhM2YuLjA4MjM5
OTQxY2IgMTAwNjQ0Ci0tLSBhL3V0aWwvdHJhY2UtZXZlbnRzCisrKyBiL3V0aWwvdHJhY2UtZXZl
bnRzCkBAIC04Miw4ICs4Miw5IEBAIHFlbXVfdmZpb19yYW1fYmxvY2tfYWRkZWQodm9pZCAqcywg
dm9pZCAqcCwgc2l6ZV90IHNpemUpICJzICVwIGhvc3QgJXAgc2l6ZSAweCV6CiBxZW11X3ZmaW9f
cmFtX2Jsb2NrX3JlbW92ZWQodm9pZCAqcywgdm9pZCAqcCwgc2l6ZV90IHNpemUpICJzICVwIGhv
c3QgJXAgc2l6ZSAweCV6eCIKIHFlbXVfdmZpb19maW5kX21hcHBpbmcodm9pZCAqcywgdm9pZCAq
cCkgInMgJXAgaG9zdCAlcCIKIHFlbXVfdmZpb19uZXdfbWFwcGluZyh2b2lkICpzLCB2b2lkICpo
b3N0LCBzaXplX3Qgc2l6ZSwgaW50IGluZGV4LCB1aW50NjRfdCBpb3ZhKSAicyAlcCBob3N0ICVw
IHNpemUgMHglenggaW5kZXggJWQgaW92YSAweCUiUFJJeDY0Ci1xZW11X3ZmaW9fZG9fbWFwcGlu
Zyh2b2lkICpzLCB2b2lkICpob3N0LCBzaXplX3Qgc2l6ZSwgdWludDY0X3QgaW92YSkgInMgJXAg
aG9zdCAlcCBzaXplIDB4JXp4IGlvdmEgMHglIlBSSXg2NAotcWVtdV92ZmlvX2RtYV9tYXAodm9p
ZCAqcywgdm9pZCAqaG9zdCwgc2l6ZV90IHNpemUsIGJvb2wgdGVtcG9yYXJ5LCB1aW50NjRfdCAq
aW92YSkgInMgJXAgaG9zdCAlcCBzaXplIDB4JXp4IHRlbXBvcmFyeSAlZCBpb3ZhICVwIgorcWVt
dV92ZmlvX2RvX21hcHBpbmcodm9pZCAqcywgdm9pZCAqaG9zdCwgdWludDY0X3QgaW92YSwgc2l6
ZV90IHNpemUpICJzICVwIGhvc3QgJXAgPC0+IGlvdmEgMHglIlBSSXg2NCAiIHNpemUgMHglengi
CitxZW11X3ZmaW9fZG1hX21hcCh2b2lkICpzLCB2b2lkICpob3N0LCBzaXplX3Qgc2l6ZSwgYm9v
bCB0ZW1wb3JhcnksIHVpbnQ2NF90ICppb3ZhKSAicyAlcCBob3N0ICVwIHNpemUgMHglenggdGVt
cG9yYXJ5ICVkICZpb3ZhICVwIgorcWVtdV92ZmlvX2RtYV9tYXBwZWQodm9pZCAqcywgdm9pZCAq
aG9zdCwgdWludDY0X3QgaW92YSwgc2l6ZV90IHNpemUpICJzICVwIGhvc3QgJXAgPC0+IGlvdmEg
MHglIlBSSXg2NCIgc2l6ZSAweCV6eCIKIHFlbXVfdmZpb19kbWFfdW5tYXAodm9pZCAqcywgdm9p
ZCAqaG9zdCkgInMgJXAgaG9zdCAlcCIKIHFlbXVfdmZpb19wY2lfcmVhZF9jb25maWcodm9pZCAq
YnVmLCBpbnQgb2ZzLCBpbnQgc2l6ZSwgdWludDY0X3QgcmVnaW9uX29mcywgdWludDY0X3QgcmVn
aW9uX3NpemUpICJyZWFkIGNmZyBwdHIgJXAgb2ZzIDB4JXggc2l6ZSAweCV4IChyZWdpb24gYWRk
ciAweCUiUFJJeDY0IiBzaXplIDB4JSJQUkl4NjQiKSIKIHFlbXVfdmZpb19wY2lfd3JpdGVfY29u
ZmlnKHZvaWQgKmJ1ZiwgaW50IG9mcywgaW50IHNpemUsIHVpbnQ2NF90IHJlZ2lvbl9vZnMsIHVp
bnQ2NF90IHJlZ2lvbl9zaXplKSAid3JpdGUgY2ZnIHB0ciAlcCBvZnMgMHgleCBzaXplIDB4JXgg
KHJlZ2lvbiBhZGRyIDB4JSJQUkl4NjQiIHNpemUgMHglIlBSSXg2NCIpIgotLSAKMi4yOC4wCgo=

