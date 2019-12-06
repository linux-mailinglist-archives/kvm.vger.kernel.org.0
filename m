Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED5B1150E0
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 14:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLFNPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 08:15:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47405 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbfLFNPp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 08:15:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575638144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MLDnBsWA2sFSFtoTw/NU467cHCiZwmFim8KHvfPZ3+E=;
        b=ZC/KaW7Ik22wtHI+WJXm9q9PTNK+WSN7FzUZ/bEBs3uvn2MHpi/yy7e19v1g2cTJfGpEbG
        DDGyhKVjFBtP+PCTwWhahpyRYdLGEX6Vy/01cEHa0gmY1SjxtMTQE6F7Ce84j2xhkuD9GU
        eyLPrXlwXsbJt22w+bgBCPYbtnJlRYI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48--0ksnmB9PiW1ROw1eCvRsw-1; Fri, 06 Dec 2019 08:15:43 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8A3518036B3;
        Fri,  6 Dec 2019 13:15:42 +0000 (UTC)
Received: from thuth.com (ovpn-116-205.ams2.redhat.com [10.36.116.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85EC25DA32;
        Fri,  6 Dec 2019 13:15:38 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, radimkrcmar@gmail.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH] MAINTAINERS: Radim is no longer available as kvm-unit-tests maintainer
Date:   Fri,  6 Dec 2019 14:15:34 +0100
Message-Id: <20191206131534.18509-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: -0ksnmB9PiW1ROw1eCvRsw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Radim's mail address @redhat.com is not valid anymore, so we should
remove this line from the MAINTAINERS file.

Thanks for all your work on kvm-unit-tests during the past years, Radim!

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d195826..48da1db 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -54,7 +54,6 @@ Descriptions of section entries:
 Maintainers
 -----------
 M: Paolo Bonzini <pbonzini@redhat.com>
-M: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
 L: kvm@vger.kernel.org
 T: git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
=20
@@ -88,7 +87,6 @@ F: lib/s390x/*
=20
 X86
 M: Paolo Bonzini <pbonzini@redhat.com>
-M: Radim Kr=C4=8Dm=C3=A1=C5=99 <rkrcmar@redhat.com>
 L: kvm@vger.kernel.org
 F: x86/*
 F: lib/x86/*
--=20
2.18.1

