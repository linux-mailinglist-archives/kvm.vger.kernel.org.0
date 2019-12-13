Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E1E11E808
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfLMQUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:20:08 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39343 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728116AbfLMQUI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:20:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576254007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a8wBTE5cUDwAyuXnH+hRuodn6C9SR01WXRNOHU/iiao=;
        b=AFuwLkT0ZNJDIhprUk3hV1TfkoUmjtCFcuEeoNp0dCdcdFi1gvqgsh8LyCr2YXSCG/PywM
        06/0i01doxDKuOTBgPLZePM6I4oAOcU6B7rwyWVtVJM4u1Is44Mc9spgGTpGoIPLSY4rpN
        KKfW3bFc6WA2YjDcYhFp778ptkgvna4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-HUXIkw6eNy6QdyW3JyJ81A-1; Fri, 13 Dec 2019 11:20:05 -0500
X-MC-Unique: HUXIkw6eNy6QdyW3JyJ81A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13E62593A1;
        Fri, 13 Dec 2019 16:20:04 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79E2A19C4F;
        Fri, 13 Dec 2019 16:19:49 +0000 (UTC)
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
Subject: [PATCH 09/12] hw/intc/ioapic: Make ioapic_print_redtbl() static
Date:   Fri, 13 Dec 2019 17:17:50 +0100
Message-Id: <20191213161753.8051-10-philmd@redhat.com>
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

Since commit 0c8465440 the ioapic_print_redtbl() function is not
used outside of ioapic_common.c, make it static, and remove its
prototype declaration in "ioapic_internal.h".

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/i386/ioapic_internal.h | 1 -
 hw/intc/ioapic_common.c           | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/hw/i386/ioapic_internal.h b/include/hw/i386/ioapic_i=
nternal.h
index d46c87c510..8b743aeed0 100644
--- a/include/hw/i386/ioapic_internal.h
+++ b/include/hw/i386/ioapic_internal.h
@@ -118,7 +118,6 @@ struct IOAPICCommonState {
=20
 void ioapic_reset_common(DeviceState *dev);
=20
-void ioapic_print_redtbl(Monitor *mon, IOAPICCommonState *s);
 void ioapic_stat_update_irq(IOAPICCommonState *s, int irq, int level);
=20
 #endif /* QEMU_IOAPIC_INTERNAL_H */
diff --git a/hw/intc/ioapic_common.c b/hw/intc/ioapic_common.c
index 5538b5b86e..72ea945377 100644
--- a/hw/intc/ioapic_common.c
+++ b/hw/intc/ioapic_common.c
@@ -76,7 +76,7 @@ static void ioapic_irr_dump(Monitor *mon, const char *n=
ame, uint32_t bitmap)
     monitor_printf(mon, "\n");
 }
=20
-void ioapic_print_redtbl(Monitor *mon, IOAPICCommonState *s)
+static void ioapic_print_redtbl(Monitor *mon, IOAPICCommonState *s)
 {
     static const char *delm_str[] =3D {
         "fixed", "lowest", "SMI", "...", "NMI", "INIT", "...", "extINT"}=
;
--=20
2.21.0

