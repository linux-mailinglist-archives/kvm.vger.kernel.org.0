Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 887DE11E806
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbfLMQTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:19:45 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728147AbfLMQTp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDPjG3bzf4auKjid69BMILX9vi363Mf6WYlN4QfXbhI=;
        b=eLl+lJReOT6+DEy8Sh4L7tX7UTJx5rZpY2Lyr7lSiraIR/hnS+YcXh3Nd5cWRUIWzndezX
        x8Sh/dgBoIcBFShu47E8ILg+pSGE+IQtdeJ+/mIm0OupqReXaA2mEn1sDcfF6TwIQnNM8s
        mPxSo1sbugk4IZuwZRdZZmBjc0pK338=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-JGYk5EipN_i0mWuUmywLaw-1; Fri, 13 Dec 2019 11:19:40 -0500
X-MC-Unique: JGYk5EipN_i0mWuUmywLaw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70F3F102C8BB;
        Fri, 13 Dec 2019 16:19:37 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06C8B19C4F;
        Fri, 13 Dec 2019 16:19:26 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     John Snow <jsnow@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        qemu-block@nongnu.org, Richard Henderson <rth@twiddle.net>,
        xen-devel@lists.xenproject.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 07/12] hw/ide/piix: Remove superfluous DEVICE() cast
Date:   Fri, 13 Dec 2019 17:17:48 +0100
Message-Id: <20191213161753.8051-8-philmd@redhat.com>
In-Reply-To: <20191213161753.8051-1-philmd@redhat.com>
References: <20191213161753.8051-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 02a9594b4f0 already converted 'dev' to DeviceState.
Since the cast is superfluous, remove it.

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 hw/ide/piix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/ide/piix.c b/hw/ide/piix.c
index db313dd3b1..ffeff4e095 100644
--- a/hw/ide/piix.c
+++ b/hw/ide/piix.c
@@ -193,7 +193,8 @@ int pci_piix3_xen_ide_unplug(DeviceState *dev, bool a=
ux)
             blk_unref(blk);
         }
     }
-    qdev_reset_all(DEVICE(dev));
+    qdev_reset_all(dev);
+
     return 0;
 }
=20
--=20
2.21.0

