Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2702A6757
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgKDPTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:19:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730196AbgKDPTv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wv0iF36gbURFbN6c8IQknm689XzZJeY+jivZ5m5LzG0=;
        b=IqH4BU03hV8yDCeJHAH9aHPcN1nwo7rVFxW/7nC4Lcbtn+zPqr41jLX2xkUo16sDpAqCTH
        7fkWZoI4On+saFLJjxLVmqPt313iNlY1VPwDcUNb0Rm3YZhTyH/v2kS4KBRQuAPSIUAmv6
        fKYR74FAblcEnR1oExvQlVK30YttLS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-VBQQwfAFP32vDI9sfEqtxw-1; Wed, 04 Nov 2020 10:19:48 -0500
X-MC-Unique: VBQQwfAFP32vDI9sfEqtxw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F387E1018F64;
        Wed,  4 Nov 2020 15:19:45 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06E4155776;
        Wed,  4 Nov 2020 15:19:38 +0000 (UTC)
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
Subject: [PULL 10/33] block/nvme: Move definitions before structure declarations
Date:   Wed,  4 Nov 2020 15:18:05 +0000
Message-Id: <20201104151828.405824-11-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKVG8gYmUg
YWJsZSB0byB1c2Ugc29tZSBkZWZpbml0aW9ucyBpbiBzdHJ1Y3R1cmUgZGVjbGFyYXRpb25zLApt
b3ZlIHRoZW0gZWFybGllci4gTm8gbG9naWNhbCBjaGFuZ2UuCgpSZXZpZXdlZC1ieTogRXJpYyBB
dWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogU3RlZmFuIEhham5vY3pp
IDxzdGVmYW5oYUByZWRoYXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxt
ZEByZWRoYXQuY29tPgpNZXNzYWdlLWlkOiAyMDIwMTAyOTA5MzMwNi4xMDYzODc5LTktcGhpbG1k
QHJlZGhhdC5jb20KU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVmYW5oYUByZWRo
YXQuY29tPgpUZXN0ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJAcmVkaGF0LmNvbT4KLS0t
CiBibG9jay9udm1lLmMgfCAxOSArKysrKysrKysrLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MTAgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay9udm1l
LmMgYi9ibG9jay9udm1lLmMKaW5kZXggZTk1ZDU5ZDMxMi4uYjA2MjlmNWRlOCAxMDA2NDQKLS0t
IGEvYmxvY2svbnZtZS5jCisrKyBiL2Jsb2NrL252bWUuYwpAQCAtNDEsNiArNDEsMTYgQEAKIAog
dHlwZWRlZiBzdHJ1Y3QgQkRSVk5WTWVTdGF0ZSBCRFJWTlZNZVN0YXRlOwogCisvKiBTYW1lIGlu
ZGV4IGlzIHVzZWQgZm9yIHF1ZXVlcyBhbmQgSVJRcyAqLworI2RlZmluZSBJTkRFWF9BRE1JTiAg
ICAgMAorI2RlZmluZSBJTkRFWF9JTyhuKSAgICAgKDEgKyBuKQorCisvKiBUaGlzIGRyaXZlciBz
aGFyZXMgYSBzaW5nbGUgTVNJWCBJUlEgZm9yIHRoZSBhZG1pbiBhbmQgSS9PIHF1ZXVlcyAqLwor
ZW51bSB7CisgICAgTVNJWF9TSEFSRURfSVJRX0lEWCA9IDAsCisgICAgTVNJWF9JUlFfQ09VTlQg
PSAxCit9OworCiB0eXBlZGVmIHN0cnVjdCB7CiAgICAgaW50MzJfdCAgaGVhZCwgdGFpbDsKICAg
ICB1aW50OF90ICAqcXVldWU7CkBAIC04MSwxNSArOTEsNiBAQCB0eXBlZGVmIHN0cnVjdCB7CiAg
ICAgUUVNVUJIICAgICAgKmNvbXBsZXRpb25fYmg7CiB9IE5WTWVRdWV1ZVBhaXI7CiAKLSNkZWZp
bmUgSU5ERVhfQURNSU4gICAgIDAKLSNkZWZpbmUgSU5ERVhfSU8obikgICAgICgxICsgbikKLQot
LyogVGhpcyBkcml2ZXIgc2hhcmVzIGEgc2luZ2xlIE1TSVggSVJRIGZvciB0aGUgYWRtaW4gYW5k
IEkvTyBxdWV1ZXMgKi8KLWVudW0gewotICAgIE1TSVhfU0hBUkVEX0lSUV9JRFggPSAwLAotICAg
IE1TSVhfSVJRX0NPVU5UID0gMQotfTsKLQogc3RydWN0IEJEUlZOVk1lU3RhdGUgewogICAgIEFp
b0NvbnRleHQgKmFpb19jb250ZXh0OwogICAgIFFFTVVWRklPU3RhdGUgKnZmaW87Ci0tIAoyLjI4
LjAKCg==

