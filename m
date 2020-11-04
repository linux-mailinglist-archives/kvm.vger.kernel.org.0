Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454672A674B
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgKDPS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:18:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730616AbgKDPS4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oL3ELJHJad57HtFMYj3OrTr7NYemUoxtUw7hulfPZF0=;
        b=VFw7TVHr+3ub1P0ggUbVdbb3WPVTER2/Z+/mACzs1HX0iLqwBi/Bb8D2qdRPhVhECvfGdN
        xNnucBRf8U9s5AIBBl3sY4jXRx1E0ZvW4o4fgoicpZUlPPeOlBzkgi02CBtnR9d4Kcta9k
        b72xgL6TRBzxGaPD6vJUC6dxySZlLwA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-AW5D_4UkOR6iBI34-Klj4Q-1; Wed, 04 Nov 2020 10:18:48 -0500
X-MC-Unique: AW5D_4UkOR6iBI34-Klj4Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F7A31018F60;
        Wed,  4 Nov 2020 15:18:47 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD20B610F3;
        Wed,  4 Nov 2020 15:18:43 +0000 (UTC)
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
        Klaus Jensen <k.jensen@samsung.com>
Subject: [PULL 03/33] MAINTAINERS: Cover "block/nvme.h" file
Date:   Wed,  4 Nov 2020 15:17:58 +0000
Message-Id: <20201104151828.405824-4-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKVGhlICJi
bG9jay9udm1lLmgiIGhlYWRlciBpcyBzaGFyZWQgYnkgYm90aCB0aGUgTlZNZSBibG9jawpkcml2
ZXIgYW5kIHRoZSBOVk1lIGVtdWxhdGVkIGRldmljZS4gQWRkIHRoZSAnRjonIGVudHJ5IG9uCmJv
dGggc2VjdGlvbnMsIHNvIGFsbCBtYWludGFpbmVycy9yZXZpZXdlcnMgYXJlIG5vdGlmaWVkCndo
ZW4gaXQgaXMgY2hhbmdlZC4KClNpZ25lZC1vZmYtYnk6IFBoaWxpcHBlIE1hdGhpZXUtRGF1ZMOp
IDxwaGlsbWRAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RlZmFuIEhham5vY3ppIDxzdGVm
YW5oYUByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogS2xhdXMgSmVuc2VuIDxrLmplbnNlbkBzYW1z
dW5nLmNvbT4KTWVzc2FnZS1JZDogPDIwMjAwNzAxMTQwNjM0LjI1OTk0LTEtcGhpbG1kQHJlZGhh
dC5jb20+Ci0tLQogTUFJTlRBSU5FUlMgfCAyICsrCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCBjMWQx
NjAyNmJhLi5lYTQ3YjllODg5IDEwMDY0NAotLS0gYS9NQUlOVEFJTkVSUworKysgYi9NQUlOVEFJ
TkVSUwpAQCAtMTg3OCw2ICsxODc4LDcgQEAgTTogS2xhdXMgSmVuc2VuIDxpdHNAaXJyZWxldmFu
dC5kaz4KIEw6IHFlbXUtYmxvY2tAbm9uZ251Lm9yZwogUzogU3VwcG9ydGVkCiBGOiBody9ibG9j
ay9udm1lKgorRjogaW5jbHVkZS9ibG9jay9udm1lLmgKIEY6IHRlc3RzL3F0ZXN0L252bWUtdGVz
dC5jCiBGOiBkb2NzL3NwZWNzL252bWUudHh0CiBUOiBnaXQgZ2l0Oi8vZ2l0LmluZnJhZGVhZC5v
cmcvcWVtdS1udm1lLmdpdCBudm1lLW5leHQKQEAgLTI5NjIsNiArMjk2Myw3IEBAIFI6IEZhbSBa
aGVuZyA8ZmFtQGV1cGhvbi5uZXQ+CiBMOiBxZW11LWJsb2NrQG5vbmdudS5vcmcKIFM6IFN1cHBv
cnRlZAogRjogYmxvY2svbnZtZSoKK0Y6IGluY2x1ZGUvYmxvY2svbnZtZS5oCiBUOiBnaXQgaHR0
cHM6Ly9naXRodWIuY29tL3N0ZWZhbmhhL3FlbXUuZ2l0IGJsb2NrCiAKIEJvb3RkZXZpY2UKLS0g
CjIuMjguMAoK

