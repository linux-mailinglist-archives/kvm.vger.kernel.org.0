Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD0C2A6748
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 16:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbgKDPSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 10:18:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26410 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729975AbgKDPSk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Nov 2020 10:18:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604503118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wW+h3oqLqN0qv5qORjU20C22HmS9KzpZRnwB4nEBi30=;
        b=Mm1KJpIHw8bFx5mvlxLAfAORCiXCjfA6BD/YQ4+sDMCstDAV0CjkH8T1LWovAaw1HRvxxm
        nhHMsoFouh5rcCopdbbbqeUN4fD+lFV2sEyEtpY/g7xSo9LJ53IyAn+OveJn0hP+qDJ85S
        NpRR8NACfzXVQXxyyFOhesbzmNjSIz4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-wbClRXVeP2yWlNA77x9C8g-1; Wed, 04 Nov 2020 10:18:34 -0500
X-MC-Unique: wbClRXVeP2yWlNA77x9C8g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFC8A1018F60;
        Wed,  4 Nov 2020 15:18:32 +0000 (UTC)
Received: from localhost (ovpn-115-145.ams2.redhat.com [10.36.115.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45B0C5C3E0;
        Wed,  4 Nov 2020 15:18:29 +0000 (UTC)
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
        Klaus Jensen <its@irrelevant.dk>
Subject: [PULL 00/33] Block patches
Date:   Wed,  4 Nov 2020 15:17:55 +0000
Message-Id: <20201104151828.405824-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VGhlIGZvbGxvd2luZyBjaGFuZ2VzIHNpbmNlIGNvbW1pdCA4NTA3YzlkNWM5YTYyZGUyYTBlMjgx
YjY0MGY5OTVlMjZlYWM0NmFmOg0KDQogIE1lcmdlIHJlbW90ZS10cmFja2luZyBicmFuY2ggJ3Jl
bW90ZXMva2V2aW4vdGFncy9mb3ItdXBzdHJlYW0nIGludG8gc3RhZ2luZyAoMjAyMC0xMS0wMyAx
NTo1OTo0NCArMDAwMCkNCg0KYXJlIGF2YWlsYWJsZSBpbiB0aGUgR2l0IHJlcG9zaXRvcnkgYXQ6
DQoNCiAgaHR0cHM6Ly9naXRsYWIuY29tL3N0ZWZhbmhhL3FlbXUuZ2l0IHRhZ3MvYmxvY2stcHVs
bC1yZXF1ZXN0DQoNCmZvciB5b3UgdG8gZmV0Y2ggY2hhbmdlcyB1cCB0byBmYzEwN2Q4Njg0MGIz
MzY0ZTkyMmMyNmNmNzYzMWI3ZmQzOGNlNTIzOg0KDQogIHV0aWwvdmZpby1oZWxwZXJzOiBBc3Nl
cnQgb2Zmc2V0IGlzIGFsaWduZWQgdG8gcGFnZSBzaXplICgyMDIwLTExLTAzIDE5OjA2OjIzICsw
MDAwKQ0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQpQdWxsIHJlcXVlc3QgZm9yIDUuMg0KDQpOVk1lIGZpeGVzIHRvIHNv
bHZlIElPTU1VIGlzc3VlcyBvbiBub24teDg2IGFuZCBlcnJvciBtZXNzYWdlL3RyYWNpbmcNCmlt
cHJvdmVtZW50cy4gRWxlbmEgQWZhbmFzb3ZhJ3MgaW9ldmVudGZkIGZpeGVzIGFyZSBhbHNvIGlu
Y2x1ZGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBTdGVmYW4gSGFqbm9jemkgPHN0ZWZhbmhhQHJlZGhh
dC5jb20+DQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCg0KRWxlbmEgQWZhbmFzb3ZhICgyKToNCiAgYWNjZWwva3ZtOiBh
ZGQgUElPIGlvZXZlbnRmZHMgb25seSBpbiBjYXNlIGt2bV9ldmVudGZkc19hbGxvd2VkIGlzDQog
ICAgdHJ1ZQ0KICBzb2Z0bW11L21lbW9yeTogZml4IG1lbW9yeV9yZWdpb25faW9ldmVudGZkX2Vx
dWFsKCkNCg0KRXJpYyBBdWdlciAoNCk6DQogIGJsb2NrL252bWU6IENoYW5nZSBzaXplIGFuZCBh
bGlnbm1lbnQgb2YgSURFTlRJRlkgcmVzcG9uc2UgYnVmZmVyDQogIGJsb2NrL252bWU6IENoYW5n
ZSBzaXplIGFuZCBhbGlnbm1lbnQgb2YgcXVldWUNCiAgYmxvY2svbnZtZTogQ2hhbmdlIHNpemUg
YW5kIGFsaWdubWVudCBvZiBwcnBfbGlzdF9wYWdlcw0KICBibG9jay9udm1lOiBBbGlnbiBpb3Yn
cyB2YSBhbmQgc2l6ZSBvbiBob3N0IHBhZ2Ugc2l6ZQ0KDQpQaGlsaXBwZSBNYXRoaWV1LURhdWTD
qSAoMjcpOg0KICBNQUlOVEFJTkVSUzogQ292ZXIgImJsb2NrL252bWUuaCIgZmlsZQ0KICBibG9j
ay9udm1lOiBVc2UgaGV4IGZvcm1hdCB0byBkaXNwbGF5IG9mZnNldCBpbiB0cmFjZSBldmVudHMN
CiAgYmxvY2svbnZtZTogUmVwb3J0IHdhcm5pbmcgd2l0aCB3YXJuX3JlcG9ydCgpDQogIGJsb2Nr
L252bWU6IFRyYWNlIGNvbnRyb2xsZXIgY2FwYWJpbGl0aWVzDQogIGJsb2NrL252bWU6IFRyYWNl
IG52bWVfcG9sbF9xdWV1ZSgpIHBlciBxdWV1ZQ0KICBibG9jay9udm1lOiBJbXByb3ZlIG52bWVf
ZnJlZV9yZXFfcXVldWVfd2FpdCgpIHRyYWNlIGluZm9ybWF0aW9uDQogIGJsb2NrL252bWU6IFRy
YWNlIHF1ZXVlIHBhaXIgY3JlYXRpb24vZGVsZXRpb24NCiAgYmxvY2svbnZtZTogTW92ZSBkZWZp
bml0aW9ucyBiZWZvcmUgc3RydWN0dXJlIGRlY2xhcmF0aW9ucw0KICBibG9jay9udm1lOiBVc2Ug
dW5zaWduZWQgaW50ZWdlciBmb3IgcXVldWUgY291bnRlci9zaXplDQogIGJsb2NrL252bWU6IE1h
a2UgbnZtZV9pZGVudGlmeSgpIHJldHVybiBib29sZWFuIGluZGljYXRpbmcgZXJyb3INCiAgYmxv
Y2svbnZtZTogTWFrZSBudm1lX2luaXRfcXVldWUoKSByZXR1cm4gYm9vbGVhbiBpbmRpY2F0aW5n
IGVycm9yDQogIGJsb2NrL252bWU6IEludHJvZHVjZSBDb21wbGV0aW9uIFF1ZXVlIGRlZmluaXRp
b25zDQogIGJsb2NrL252bWU6IFVzZSBkZWZpbml0aW9ucyBpbnN0ZWFkIG9mIG1hZ2ljIHZhbHVl
cyBpbiBhZGRfaW9fcXVldWUoKQ0KICBibG9jay9udm1lOiBDb3JyZWN0bHkgaW5pdGlhbGl6ZSBB
ZG1pbiBRdWV1ZSBBdHRyaWJ1dGVzDQogIGJsb2NrL252bWU6IFNpbXBsaWZ5IEFETUlOIHF1ZXVl
IGFjY2Vzcw0KICBibG9jay9udm1lOiBTaW1wbGlmeSBudm1lX2NtZF9zeW5jKCkNCiAgYmxvY2sv
bnZtZTogU2V0IHJlcXVlc3RfYWxpZ25tZW50IGF0IGluaXRpYWxpemF0aW9uDQogIGJsb2NrL252
bWU6IENvcnJlY3QgbWluaW11bSBkZXZpY2UgcGFnZSBzaXplDQogIGJsb2NrL252bWU6IEZpeCB1
c2Ugb2Ygd3JpdGUtb25seSBkb29yYmVsbHMgcGFnZSBvbiBBYXJjaDY0IGFyY2gNCiAgYmxvY2sv
bnZtZTogRml4IG52bWVfc3VibWl0X2NvbW1hbmQoKSBvbiBiaWctZW5kaWFuIGhvc3QNCiAgdXRp
bC92ZmlvLWhlbHBlcnM6IEltcHJvdmUgcmVwb3J0aW5nIHVuc3VwcG9ydGVkIElPTU1VIHR5cGUN
CiAgdXRpbC92ZmlvLWhlbHBlcnM6IFRyYWNlIFBDSSBJL08gY29uZmlnIGFjY2Vzc2VzDQogIHV0
aWwvdmZpby1oZWxwZXJzOiBUcmFjZSBQQ0kgQkFSIHJlZ2lvbiBpbmZvDQogIHV0aWwvdmZpby1o
ZWxwZXJzOiBUcmFjZSB3aGVyZSBCQVJzIGFyZSBtYXBwZWQNCiAgdXRpbC92ZmlvLWhlbHBlcnM6
IEltcHJvdmUgRE1BIHRyYWNlIGV2ZW50cw0KICB1dGlsL3ZmaW8taGVscGVyczogQ29udmVydCB2
ZmlvX2R1bXBfbWFwcGluZyB0byB0cmFjZSBldmVudHMNCiAgdXRpbC92ZmlvLWhlbHBlcnM6IEFz
c2VydCBvZmZzZXQgaXMgYWxpZ25lZCB0byBwYWdlIHNpemUNCg0KIE1BSU5UQUlORVJTICAgICAg
ICAgIHwgICAyICsNCiBpbmNsdWRlL2Jsb2NrL252bWUuaCB8ICAxOCArKy0tDQogYWNjZWwva3Zt
L2t2bS1hbGwuYyAgfCAgIDYgKy0NCiBibG9jay9udm1lLmMgICAgICAgICB8IDIwOSArKysrKysr
KysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tDQogc29mdG1tdS9tZW1vcnkuYyAg
ICAgfCAgMTEgKystDQogdXRpbC92ZmlvLWhlbHBlcnMuYyAgfCAgNDMgKysrKystLS0tDQogYmxv
Y2svdHJhY2UtZXZlbnRzICAgfCAgMzAgKysrKy0tLQ0KIHV0aWwvdHJhY2UtZXZlbnRzICAgIHwg
IDEwICsrLQ0KIDggZmlsZXMgY2hhbmdlZCwgMTk1IGluc2VydGlvbnMoKyksIDEzNCBkZWxldGlv
bnMoLSkNCg0KLS0gDQoyLjI4LjANCg0K

