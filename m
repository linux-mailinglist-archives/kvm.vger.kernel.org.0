Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8959F2A674C
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgKDPTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:19:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730624AbgKDPTG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:19:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8n5FGglofSWSuHLIHxXfbLQCLImF7XWLpkLxdv5S0c=;
        b=SzXgXxxvWyxqhHjGmcTJKJ6z1oAdwSiuiq5Xk089NqEirKnUiF3WXOiaYelNVoDWb74Aj0
        ROZ3St+eWNjCrudRfxSdvDd3b1hrtUmzW6G7fniIHf9wbfNcht0ix+ILO8ihR1s2PIMgl9
        NDrbZYbWrMLZB3T7IXy2o1IoSoqcFAM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-VvnFW5qSNtGrsM6uWq_Zww-1; Wed, 04 Nov 2020 10:19:02 -0500
X-MC-Unique: VvnFW5qSNtGrsM6uWq_Zww-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07F7D8030B0;
        Wed,  4 Nov 2020 15:19:01 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DB485B4CE;
        Wed,  4 Nov 2020 15:18:54 +0000 (UTC)
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
Subject: [PULL 04/33] block/nvme: Use hex format to display offset in trace events
Date:   Wed,  4 Nov 2020 15:17:59 +0000
Message-Id: <20201104151828.405824-5-stefanha@redhat.com>
In-Reply-To: <20201104151828.405824-1-stefanha@redhat.com>
References: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

RnJvbTogUGhpbGlwcGUgTWF0aGlldS1EYXVkw6kgPHBoaWxtZEByZWRoYXQuY29tPgoKVXNlIHRo
ZSBzYW1lIGZvcm1hdCB1c2VkIGZvciB0aGUgaHcvdmZpby8gdHJhY2UgZXZlbnRzLgoKU3VnZ2Vz
dGVkLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBF
cmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+ClJldmlld2VkLWJ5OiBTdGVmYW4gSGFq
bm9jemkgPHN0ZWZhbmhhQHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5h
dWdlckByZWRoYXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1LURhdWTDqSA8
cGhpbG1kQHJlZGhhdC5jb20+Ck1lc3NhZ2UtaWQ6IDIwMjAxMDI5MDkzMzA2LjEwNjM4NzktMy1w
aGlsbWRAcmVkaGF0LmNvbQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhh
QHJlZGhhdC5jb20+ClRlc3RlZC1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29t
PgotLS0KIGJsb2NrL3RyYWNlLWV2ZW50cyB8IDEyICsrKysrKy0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9ibG9jay90
cmFjZS1ldmVudHMgYi9ibG9jay90cmFjZS1ldmVudHMKaW5kZXggMGUzNTFjM2ZhMy4uMDk1NWM4
NWM3OCAxMDA2NDQKLS0tIGEvYmxvY2svdHJhY2UtZXZlbnRzCisrKyBiL2Jsb2NrL3RyYWNlLWV2
ZW50cwpAQCAtMTQ0LDEzICsxNDQsMTMgQEAgbnZtZV9zdWJtaXRfY29tbWFuZCh2b2lkICpzLCBp
bnQgaW5kZXgsIGludCBjaWQpICJzICVwIHF1ZXVlICVkIGNpZCAlZCIKIG52bWVfc3VibWl0X2Nv
bW1hbmRfcmF3KGludCBjMCwgaW50IGMxLCBpbnQgYzIsIGludCBjMywgaW50IGM0LCBpbnQgYzUs
IGludCBjNiwgaW50IGM3KSAiJTAyeCAlMDJ4ICUwMnggJTAyeCAlMDJ4ICUwMnggJTAyeCAlMDJ4
IgogbnZtZV9oYW5kbGVfZXZlbnQodm9pZCAqcykgInMgJXAiCiBudm1lX3BvbGxfY2Iodm9pZCAq
cykgInMgJXAiCi1udm1lX3Byd19hbGlnbmVkKHZvaWQgKnMsIGludCBpc193cml0ZSwgdWludDY0
X3Qgb2Zmc2V0LCB1aW50NjRfdCBieXRlcywgaW50IGZsYWdzLCBpbnQgbmlvdikgInMgJXAgaXNf
d3JpdGUgJWQgb2Zmc2V0ICUiUFJJZDY0IiBieXRlcyAlIlBSSWQ2NCIgZmxhZ3MgJWQgbmlvdiAl
ZCIKLW52bWVfd3JpdGVfemVyb2VzKHZvaWQgKnMsIHVpbnQ2NF90IG9mZnNldCwgdWludDY0X3Qg
Ynl0ZXMsIGludCBmbGFncykgInMgJXAgb2Zmc2V0ICUiUFJJZDY0IiBieXRlcyAlIlBSSWQ2NCIg
ZmxhZ3MgJWQiCitudm1lX3Byd19hbGlnbmVkKHZvaWQgKnMsIGludCBpc193cml0ZSwgdWludDY0
X3Qgb2Zmc2V0LCB1aW50NjRfdCBieXRlcywgaW50IGZsYWdzLCBpbnQgbmlvdikgInMgJXAgaXNf
d3JpdGUgJWQgb2Zmc2V0IDB4JSJQUkl4NjQiIGJ5dGVzICUiUFJJZDY0IiBmbGFncyAlZCBuaW92
ICVkIgorbnZtZV93cml0ZV96ZXJvZXModm9pZCAqcywgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRf
dCBieXRlcywgaW50IGZsYWdzKSAicyAlcCBvZmZzZXQgMHglIlBSSXg2NCIgYnl0ZXMgJSJQUklk
NjQiIGZsYWdzICVkIgogbnZtZV9xaW92X3VuYWxpZ25lZChjb25zdCB2b2lkICpxaW92LCBpbnQg
biwgdm9pZCAqYmFzZSwgc2l6ZV90IHNpemUsIGludCBhbGlnbikgInFpb3YgJXAgbiAlZCBiYXNl
ICVwIHNpemUgMHglenggYWxpZ24gMHgleCIKLW52bWVfcHJ3X2J1ZmZlcmVkKHZvaWQgKnMsIHVp
bnQ2NF90IG9mZnNldCwgdWludDY0X3QgYnl0ZXMsIGludCBuaW92LCBpbnQgaXNfd3JpdGUpICJz
ICVwIG9mZnNldCAlIlBSSWQ2NCIgYnl0ZXMgJSJQUklkNjQiIG5pb3YgJWQgaXNfd3JpdGUgJWQi
Ci1udm1lX3J3X2RvbmUodm9pZCAqcywgaW50IGlzX3dyaXRlLCB1aW50NjRfdCBvZmZzZXQsIHVp
bnQ2NF90IGJ5dGVzLCBpbnQgcmV0KSAicyAlcCBpc193cml0ZSAlZCBvZmZzZXQgJSJQUklkNjQi
IGJ5dGVzICUiUFJJZDY0IiByZXQgJWQiCi1udm1lX2RzbSh2b2lkICpzLCB1aW50NjRfdCBvZmZz
ZXQsIHVpbnQ2NF90IGJ5dGVzKSAicyAlcCBvZmZzZXQgJSJQUklkNjQiIGJ5dGVzICUiUFJJZDY0
IiIKLW52bWVfZHNtX2RvbmUodm9pZCAqcywgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBieXRl
cywgaW50IHJldCkgInMgJXAgb2Zmc2V0ICUiUFJJZDY0IiBieXRlcyAlIlBSSWQ2NCIgcmV0ICVk
IgorbnZtZV9wcndfYnVmZmVyZWQodm9pZCAqcywgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBi
eXRlcywgaW50IG5pb3YsIGludCBpc193cml0ZSkgInMgJXAgb2Zmc2V0IDB4JSJQUkl4NjQiIGJ5
dGVzICUiUFJJZDY0IiBuaW92ICVkIGlzX3dyaXRlICVkIgorbnZtZV9yd19kb25lKHZvaWQgKnMs
IGludCBpc193cml0ZSwgdWludDY0X3Qgb2Zmc2V0LCB1aW50NjRfdCBieXRlcywgaW50IHJldCkg
InMgJXAgaXNfd3JpdGUgJWQgb2Zmc2V0IDB4JSJQUkl4NjQiIGJ5dGVzICUiUFJJZDY0IiByZXQg
JWQiCitudm1lX2RzbSh2b2lkICpzLCB1aW50NjRfdCBvZmZzZXQsIHVpbnQ2NF90IGJ5dGVzKSAi
cyAlcCBvZmZzZXQgMHglIlBSSXg2NCIgYnl0ZXMgJSJQUklkNjQiIgorbnZtZV9kc21fZG9uZSh2
b2lkICpzLCB1aW50NjRfdCBvZmZzZXQsIHVpbnQ2NF90IGJ5dGVzLCBpbnQgcmV0KSAicyAlcCBv
ZmZzZXQgMHglIlBSSXg2NCIgYnl0ZXMgJSJQUklkNjQiIHJldCAlZCIKIG52bWVfZG1hX21hcF9m
bHVzaCh2b2lkICpzKSAicyAlcCIKIG52bWVfZnJlZV9yZXFfcXVldWVfd2FpdCh2b2lkICpxKSAi
cSAlcCIKIG52bWVfY21kX21hcF9xaW92KHZvaWQgKnMsIHZvaWQgKmNtZCwgdm9pZCAqcmVxLCB2
b2lkICpxaW92LCBpbnQgZW50cmllcykgInMgJXAgY21kICVwIHJlcSAlcCBxaW92ICVwIGVudHJp
ZXMgJWQiCi0tIAoyLjI4LjAKCg==

