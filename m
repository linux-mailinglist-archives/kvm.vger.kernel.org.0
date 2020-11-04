Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 175BC2A6761
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgKDPUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:20:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730484AbgKDPUb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:20:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vjhB44v9kOs3ahxuUHYm/yBWG7LK4WTgoOjlXqldY2o=;
        b=LQU8v1SKpsl5JCpJW0FEhXUzhvmhwZ4on9Rpx/84JroAq+ViMxZm4a04QoPYcRn76O3Bdf
        C3TOfix0mQUsKO6c0liEtycNYrXdGdPmqHMmykjU6eOQVGQsxyr4bwr++aXwQRCWPk9Ue2
        z0Has9yKhFmZnq0mVIfiteziMMU7alU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-pznsf-JWPkSG9oDzHdOomw-1; Wed, 04 Nov 2020 10:20:28 -0500
X-MC-Unique: pznsf-JWPkSG9oDzHdOomw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F02E8049F4;
        Wed,  4 Nov 2020 15:20:26 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B61460BFA;
        Wed,  4 Nov 2020 15:20:19 +0000 (UTC)
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
Subject: [PULL 15/33] block/nvme: Use definitions instead of magic values in add_io_queue()
Date:   Wed,  4 Nov 2020 15:18:10 +0000
Message-Id: <20201104151828.405824-16-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKUmVwbGFj
ZSBtYWdpYyB2YWx1ZXMgYnkgZGVmaW5pdGlvbnMsIGFuZCBzaW1wbGlmaXkgc2luY2UgdGhlCm51
bWJlciBvZiBxdWV1ZXMgd2lsbCBuZXZlciByZWFjaCA2NEsuCgpSZXZpZXdlZC1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3pp
IDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxt
ZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5MzMwNi4xMDYzODc5LTE0LXBoaWxt
ZEByZWRoYXQuY29tClNpZ25lZC1vZmYtYnk6IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVk
aGF0LmNvbT4KVGVzdGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Ci0t
LQogYmxvY2svbnZtZS5jIHwgOSArKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svbnZtZS5jIGIvYmxvY2sv
bnZtZS5jCmluZGV4IDZlYWJhNGU3MDMuLjcyODViZDJlMjcgMTAwNjQ0Ci0tLSBhL2Jsb2NrL252
bWUuYworKysgYi9ibG9jay9udm1lLmMKQEAgLTY1Miw2ICs2NTIsNyBAQCBzdGF0aWMgYm9vbCBu
dm1lX2FkZF9pb19xdWV1ZShCbG9ja0RyaXZlclN0YXRlICpicywgRXJyb3IgKiplcnJwKQogICAg
IE52bWVDbWQgY21kOwogICAgIHVuc2lnbmVkIHF1ZXVlX3NpemUgPSBOVk1FX1FVRVVFX1NJWkU7
CiAKKyAgICBhc3NlcnQobiA8PSBVSU5UMTZfTUFYKTsKICAgICBxID0gbnZtZV9jcmVhdGVfcXVl
dWVfcGFpcihzLCBiZHJ2X2dldF9haW9fY29udGV4dChicyksCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgbiwgcXVldWVfc2l6ZSwgZXJycCk7CiAgICAgaWYgKCFxKSB7CkBAIC02NjAs
OCArNjYxLDggQEAgc3RhdGljIGJvb2wgbnZtZV9hZGRfaW9fcXVldWUoQmxvY2tEcml2ZXJTdGF0
ZSAqYnMsIEVycm9yICoqZXJycCkKICAgICBjbWQgPSAoTnZtZUNtZCkgewogICAgICAgICAub3Bj
b2RlID0gTlZNRV9BRE1fQ01EX0NSRUFURV9DUSwKICAgICAgICAgLmRwdHIucHJwMSA9IGNwdV90
b19sZTY0KHEtPmNxLmlvdmEpLAotICAgICAgICAuY2R3MTAgPSBjcHVfdG9fbGUzMigoKHF1ZXVl
X3NpemUgLSAxKSA8PCAxNikgfCAobiAmIDB4RkZGRikpLAotICAgICAgICAuY2R3MTEgPSBjcHVf
dG9fbGUzMigweDMpLAorICAgICAgICAuY2R3MTAgPSBjcHVfdG9fbGUzMigoKHF1ZXVlX3NpemUg
LSAxKSA8PCAxNikgfCBuKSwKKyAgICAgICAgLmNkdzExID0gY3B1X3RvX2xlMzIoTlZNRV9DUV9J
RU4gfCBOVk1FX0NRX1BDKSwKICAgICB9OwogICAgIGlmIChudm1lX2NtZF9zeW5jKGJzLCBzLT5x
dWV1ZXNbSU5ERVhfQURNSU5dLCAmY21kKSkgewogICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJG
YWlsZWQgdG8gY3JlYXRlIENRIGlvIHF1ZXVlIFsldV0iLCBuKTsKQEAgLTY3MCw4ICs2NzEsOCBA
QCBzdGF0aWMgYm9vbCBudm1lX2FkZF9pb19xdWV1ZShCbG9ja0RyaXZlclN0YXRlICpicywgRXJy
b3IgKiplcnJwKQogICAgIGNtZCA9IChOdm1lQ21kKSB7CiAgICAgICAgIC5vcGNvZGUgPSBOVk1F
X0FETV9DTURfQ1JFQVRFX1NRLAogICAgICAgICAuZHB0ci5wcnAxID0gY3B1X3RvX2xlNjQocS0+
c3EuaW92YSksCi0gICAgICAgIC5jZHcxMCA9IGNwdV90b19sZTMyKCgocXVldWVfc2l6ZSAtIDEp
IDw8IDE2KSB8IChuICYgMHhGRkZGKSksCi0gICAgICAgIC5jZHcxMSA9IGNwdV90b19sZTMyKDB4
MSB8IChuIDw8IDE2KSksCisgICAgICAgIC5jZHcxMCA9IGNwdV90b19sZTMyKCgocXVldWVfc2l6
ZSAtIDEpIDw8IDE2KSB8IG4pLAorICAgICAgICAuY2R3MTEgPSBjcHVfdG9fbGUzMihOVk1FX1NR
X1BDIHwgKG4gPDwgMTYpKSwKICAgICB9OwogICAgIGlmIChudm1lX2NtZF9zeW5jKGJzLCBzLT5x
dWV1ZXNbSU5ERVhfQURNSU5dLCAmY21kKSkgewogICAgICAgICBlcnJvcl9zZXRnKGVycnAsICJG
YWlsZWQgdG8gY3JlYXRlIFNRIGlvIHF1ZXVlIFsldV0iLCBuKTsKLS0gCjIuMjguMAoK

