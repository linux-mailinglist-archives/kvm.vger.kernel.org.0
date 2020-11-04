Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8015A2A6773
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgKDPVt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41525 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729980AbgKDPVs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:21:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gv3mjdz+uSzq+uJJFTus6NPzAUxrll/VVcJIM1JiH98=;
        b=P4+lz9tBd+kDMHaTrw9N4kgAYYwpgN8V/QR+ElGL0LHDfp2zPyIRXoC+6ZgRn5zb7tSiqg
        /lPCdDLJkY7jYBU8BjUf7IBLFAaqZmC9tOkJ7ENSOPMmpuFmRxZmAmIXR1+IhW9eprYafx
        nX2fTB2W4A+gCrYzhAudhScyYHpds/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-UDIu-vk-P92UN3ViJRjo8w-1; Wed, 04 Nov 2020 10:21:42 -0500
X-MC-Unique: UDIu-vk-P92UN3ViJRjo8w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8BEF1899422;
        Wed,  4 Nov 2020 15:21:40 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D81519C4F;
        Wed,  4 Nov 2020 15:21:34 +0000 (UTC)
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
Subject: [PULL 28/33] util/vfio-helpers: Trace PCI I/O config accesses
Date:   Wed,  4 Nov 2020 15:18:23 +0000
Message-Id: <20201104151828.405824-29-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKV2Ugc29t
ZXRpbWUgZ2V0IGtlcm5lbCBwYW5pYyB3aXRoIHNvbWUgZGV2aWNlcyBvbiBBYXJjaDY0Cmhvc3Rz
LiBBbGV4IFdpbGxpYW1zb24gc3VnZ2VzdHMgaXQgbWlnaHQgYmUgYnJva2VuIFBDSWUKcm9vdCBj
b21wbGV4LiBBZGQgdHJhY2UgZXZlbnQgdG8gcmVjb3JkIHRoZSBsYXRlc3QgSS9PCmFjY2VzcyBi
ZWZvcmUgY3Jhc2hpbmcuIEluIGNhc2UsIGFzc2VydCBvdXIgYWNjZXNzZXMgYXJlCmFsaWduZWQu
CgpSZXZpZXdlZC1ieTogRmFtIFpoZW5nIDxmYW1AZXVwaG9uLm5ldD4KUmV2aWV3ZWQtYnk6IFN0
ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlw
cGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTEw
MzAyMDczMy4yMzAzMTQ4LTMtcGhpbG1kQHJlZGhhdC5jb20KU2lnbmVkLW9mZi1ieTogU3RlZmFu
IEhham5vY3ppIDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVy
aWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0tCiB1dGlsL3ZmaW8taGVscGVycy5jIHwgOCArKysrKysr
KwogdXRpbC90cmFjZS1ldmVudHMgICB8IDIgKysKIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL3V0aWwvdmZpby1oZWxwZXJzLmMgYi91dGlsL3ZmaW8taGVs
cGVycy5jCmluZGV4IDE0YTU0OTUxMGYuLjFkNGVmYWZjYWEgMTAwNjQ0Ci0tLSBhL3V0aWwvdmZp
by1oZWxwZXJzLmMKKysrIGIvdXRpbC92ZmlvLWhlbHBlcnMuYwpAQCAtMjI3LDYgKzIyNywxMCBA
QCBzdGF0aWMgaW50IHFlbXVfdmZpb19wY2lfcmVhZF9jb25maWcoUUVNVVZGSU9TdGF0ZSAqcywg
dm9pZCAqYnVmLAogewogICAgIGludCByZXQ7CiAKKyAgICB0cmFjZV9xZW11X3ZmaW9fcGNpX3Jl
YWRfY29uZmlnKGJ1Ziwgb2ZzLCBzaXplLAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcy0+Y29uZmlnX3JlZ2lvbl9pbmZvLm9mZnNldCwKKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHMtPmNvbmZpZ19yZWdpb25faW5mby5zaXplKTsKKyAgICBhc3NlcnQo
UUVNVV9JU19BTElHTkVEKHMtPmNvbmZpZ19yZWdpb25faW5mby5vZmZzZXQgKyBvZnMsIHNpemUp
KTsKICAgICBkbyB7CiAgICAgICAgIHJldCA9IHByZWFkKHMtPmRldmljZSwgYnVmLCBzaXplLCBz
LT5jb25maWdfcmVnaW9uX2luZm8ub2Zmc2V0ICsgb2ZzKTsKICAgICB9IHdoaWxlIChyZXQgPT0g
LTEgJiYgZXJybm8gPT0gRUlOVFIpOwpAQCAtMjM3LDYgKzI0MSwxMCBAQCBzdGF0aWMgaW50IHFl
bXVfdmZpb19wY2lfd3JpdGVfY29uZmlnKFFFTVVWRklPU3RhdGUgKnMsIHZvaWQgKmJ1ZiwgaW50
IHNpemUsIGludAogewogICAgIGludCByZXQ7CiAKKyAgICB0cmFjZV9xZW11X3ZmaW9fcGNpX3dy
aXRlX2NvbmZpZyhidWYsIG9mcywgc2l6ZSwKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBzLT5jb25maWdfcmVnaW9uX2luZm8ub2Zmc2V0LAorICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHMtPmNvbmZpZ19yZWdpb25faW5mby5zaXplKTsKKyAgICBhc3Nl
cnQoUUVNVV9JU19BTElHTkVEKHMtPmNvbmZpZ19yZWdpb25faW5mby5vZmZzZXQgKyBvZnMsIHNp
emUpKTsKICAgICBkbyB7CiAgICAgICAgIHJldCA9IHB3cml0ZShzLT5kZXZpY2UsIGJ1Ziwgc2l6
ZSwgcy0+Y29uZmlnX3JlZ2lvbl9pbmZvLm9mZnNldCArIG9mcyk7CiAgICAgfSB3aGlsZSAocmV0
ID09IC0xICYmIGVycm5vID09IEVJTlRSKTsKZGlmZiAtLWdpdCBhL3V0aWwvdHJhY2UtZXZlbnRz
IGIvdXRpbC90cmFjZS1ldmVudHMKaW5kZXggMjRjMzE4MDNiMC4uOGQzNjE1ZTcxNyAxMDA2NDQK
LS0tIGEvdXRpbC90cmFjZS1ldmVudHMKKysrIGIvdXRpbC90cmFjZS1ldmVudHMKQEAgLTg1LDMg
Kzg1LDUgQEAgcWVtdV92ZmlvX25ld19tYXBwaW5nKHZvaWQgKnMsIHZvaWQgKmhvc3QsIHNpemVf
dCBzaXplLCBpbnQgaW5kZXgsIHVpbnQ2NF90IGlvdmEKIHFlbXVfdmZpb19kb19tYXBwaW5nKHZv
aWQgKnMsIHZvaWQgKmhvc3QsIHNpemVfdCBzaXplLCB1aW50NjRfdCBpb3ZhKSAicyAlcCBob3N0
ICVwIHNpemUgMHglenggaW92YSAweCUiUFJJeDY0CiBxZW11X3ZmaW9fZG1hX21hcCh2b2lkICpz
LCB2b2lkICpob3N0LCBzaXplX3Qgc2l6ZSwgYm9vbCB0ZW1wb3JhcnksIHVpbnQ2NF90ICppb3Zh
KSAicyAlcCBob3N0ICVwIHNpemUgMHglenggdGVtcG9yYXJ5ICVkIGlvdmEgJXAiCiBxZW11X3Zm
aW9fZG1hX3VubWFwKHZvaWQgKnMsIHZvaWQgKmhvc3QpICJzICVwIGhvc3QgJXAiCitxZW11X3Zm
aW9fcGNpX3JlYWRfY29uZmlnKHZvaWQgKmJ1ZiwgaW50IG9mcywgaW50IHNpemUsIHVpbnQ2NF90
IHJlZ2lvbl9vZnMsIHVpbnQ2NF90IHJlZ2lvbl9zaXplKSAicmVhZCBjZmcgcHRyICVwIG9mcyAw
eCV4IHNpemUgMHgleCAocmVnaW9uIGFkZHIgMHglIlBSSXg2NCIgc2l6ZSAweCUiUFJJeDY0Iiki
CitxZW11X3ZmaW9fcGNpX3dyaXRlX2NvbmZpZyh2b2lkICpidWYsIGludCBvZnMsIGludCBzaXpl
LCB1aW50NjRfdCByZWdpb25fb2ZzLCB1aW50NjRfdCByZWdpb25fc2l6ZSkgIndyaXRlIGNmZyBw
dHIgJXAgb2ZzIDB4JXggc2l6ZSAweCV4IChyZWdpb24gYWRkciAweCUiUFJJeDY0IiBzaXplIDB4
JSJQUkl4NjQiKSIKLS0gCjIuMjguMAoK

