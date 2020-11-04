Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75E32A6782
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgKDPWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:22:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730771AbgKDPWN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:22:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cH2CGoXWvm04g9eHJoqZTGGKfM5E7bMEhprVr3Z+0Y=;
        b=Vb/TWVCkTo9aq2PoU4MCYmSPdYyHIoTTMvGFb/Y/18v2PRRcPKX6cWRLfoBIiWtU0vri+a
        N4A8mO1zr+sYSGXteL9AyMenANg9CsSZN/fiqXw8+gYiFjkg1/WUvdKDoSDaIBlVf4lcyz
        3FOPUTqwMwqtMqSX5VlUm9iOC/VOOuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-VWXyczpqOUmLid0zwfx0aw-1; Wed, 04 Nov 2020 10:22:07 -0500
X-MC-Unique: VWXyczpqOUmLid0zwfx0aw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDA151099F65;
        Wed,  4 Nov 2020 15:22:05 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CEE35D9CC;
        Wed,  4 Nov 2020 15:21:59 +0000 (UTC)
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
Subject: [PULL 32/33] util/vfio-helpers: Convert vfio_dump_mapping to trace events
Date:   Wed,  4 Nov 2020 15:18:27 +0000
Message-Id: <20201104151828.405824-33-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKVGhlIFFF
TVVfVkZJT19ERUJVRyBkZWZpbml0aW9uIGlzIG9ubHkgbW9kaWZpYWJsZSBhdCBidWlsZC10aW1l
LgpUcmFjZSBldmVudHMgY2FuIGJlIGVuYWJsZWQgYXQgcnVuLXRpbWUuIEFzIHdlIHByZWZlciB0
aGUgbGF0dGVyLApjb252ZXJ0IHFlbXVfdmZpb19kdW1wX21hcHBpbmdzKCkgdG8gdXNlIHRyYWNl
IGV2ZW50cyBpbnN0ZWFkCm9mIGZwcmludGYoKS4KClJldmlld2VkLWJ5OiBGYW0gWmhlbmcgPGZh
bUBldXBob24ubmV0PgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRo
YXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8cGhpbG1kQHJl
ZGhhdC5jb20+Ck1lc3NhZ2UtaWQ6IDIwMjAxMTAzMDIwNzMzLjIzMDMxNDgtNy1waGlsbWRAcmVk
aGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5j
b20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgotLS0KIHV0
aWwvdmZpby1oZWxwZXJzLmMgfCAxOSArKysrLS0tLS0tLS0tLS0tLS0tCiB1dGlsL3RyYWNlLWV2
ZW50cyAgIHwgIDEgKwogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDE1IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL3V0aWwvdmZpby1oZWxwZXJzLmMgYi91dGlsL3ZmaW8taGVs
cGVycy5jCmluZGV4IGMyNGE1MTBkZjguLjczZjdiZmE3NTQgMTAwNjQ0Ci0tLSBhL3V0aWwvdmZp
by1oZWxwZXJzLmMKKysrIGIvdXRpbC92ZmlvLWhlbHBlcnMuYwpAQCAtNTIxLDIzICs1MjEsMTIg
QEAgUUVNVVZGSU9TdGF0ZSAqcWVtdV92ZmlvX29wZW5fcGNpKGNvbnN0IGNoYXIgKmRldmljZSwg
RXJyb3IgKiplcnJwKQogICAgIHJldHVybiBzOwogfQogCi1zdGF0aWMgdm9pZCBxZW11X3ZmaW9f
ZHVtcF9tYXBwaW5nKElPVkFNYXBwaW5nICptKQotewotICAgIGlmIChRRU1VX1ZGSU9fREVCVUcp
IHsKLSAgICAgICAgcHJpbnRmKCIgIHZmaW8gbWFwcGluZyAlcCAlIiBQUkl4NjQgIiB0byAlIiBQ
Ukl4NjQgIlxuIiwgbS0+aG9zdCwKLSAgICAgICAgICAgICAgICh1aW50NjRfdCltLT5zaXplLCAo
dWludDY0X3QpbS0+aW92YSk7Ci0gICAgfQotfQotCiBzdGF0aWMgdm9pZCBxZW11X3ZmaW9fZHVt
cF9tYXBwaW5ncyhRRU1VVkZJT1N0YXRlICpzKQogewotICAgIGludCBpOwotCi0gICAgaWYgKFFF
TVVfVkZJT19ERUJVRykgewotICAgICAgICBwcmludGYoInZmaW8gbWFwcGluZ3NcbiIpOwotICAg
ICAgICBmb3IgKGkgPSAwOyBpIDwgcy0+bnJfbWFwcGluZ3M7ICsraSkgewotICAgICAgICAgICAg
cWVtdV92ZmlvX2R1bXBfbWFwcGluZygmcy0+bWFwcGluZ3NbaV0pOwotICAgICAgICB9CisgICAg
Zm9yIChpbnQgaSA9IDA7IGkgPCBzLT5ucl9tYXBwaW5nczsgKytpKSB7CisgICAgICAgIHRyYWNl
X3FlbXVfdmZpb19kdW1wX21hcHBpbmcocy0+bWFwcGluZ3NbaV0uaG9zdCwKKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBzLT5tYXBwaW5nc1tpXS5pb3ZhLAorICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHMtPm1hcHBpbmdzW2ldLnNpemUpOwogICAgIH0K
IH0KIApkaWZmIC0tZ2l0IGEvdXRpbC90cmFjZS1ldmVudHMgYi91dGlsL3RyYWNlLWV2ZW50cwpp
bmRleCAwODIzOTk0MWNiLi42MWUwZDRiY2RmIDEwMDY0NAotLS0gYS91dGlsL3RyYWNlLWV2ZW50
cworKysgYi91dGlsL3RyYWNlLWV2ZW50cwpAQCAtODAsNiArODAsNyBAQCBxZW11X211dGV4X3Vu
bG9jayh2b2lkICptdXRleCwgY29uc3QgY2hhciAqZmlsZSwgY29uc3QgaW50IGxpbmUpICJyZWxl
YXNlZCBtdXRleAogcWVtdV92ZmlvX2RtYV9yZXNldF90ZW1wb3Jhcnkodm9pZCAqcykgInMgJXAi
CiBxZW11X3ZmaW9fcmFtX2Jsb2NrX2FkZGVkKHZvaWQgKnMsIHZvaWQgKnAsIHNpemVfdCBzaXpl
KSAicyAlcCBob3N0ICVwIHNpemUgMHglengiCiBxZW11X3ZmaW9fcmFtX2Jsb2NrX3JlbW92ZWQo
dm9pZCAqcywgdm9pZCAqcCwgc2l6ZV90IHNpemUpICJzICVwIGhvc3QgJXAgc2l6ZSAweCV6eCIK
K3FlbXVfdmZpb19kdW1wX21hcHBpbmcodm9pZCAqaG9zdCwgdWludDY0X3QgaW92YSwgc2l6ZV90
IHNpemUpICJ2ZmlvIG1hcHBpbmcgJXAgdG8gaW92YSAweCUwOCIgUFJJeDY0ICIgc2l6ZSAweCV6
eCIKIHFlbXVfdmZpb19maW5kX21hcHBpbmcodm9pZCAqcywgdm9pZCAqcCkgInMgJXAgaG9zdCAl
cCIKIHFlbXVfdmZpb19uZXdfbWFwcGluZyh2b2lkICpzLCB2b2lkICpob3N0LCBzaXplX3Qgc2l6
ZSwgaW50IGluZGV4LCB1aW50NjRfdCBpb3ZhKSAicyAlcCBob3N0ICVwIHNpemUgMHglenggaW5k
ZXggJWQgaW92YSAweCUiUFJJeDY0CiBxZW11X3ZmaW9fZG9fbWFwcGluZyh2b2lkICpzLCB2b2lk
ICpob3N0LCB1aW50NjRfdCBpb3ZhLCBzaXplX3Qgc2l6ZSkgInMgJXAgaG9zdCAlcCA8LT4gaW92
YSAweCUiUFJJeDY0ICIgc2l6ZSAweCV6eCIKLS0gCjIuMjguMAoK

