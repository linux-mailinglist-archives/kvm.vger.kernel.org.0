Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D2811E7F0
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 17:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfLMQSj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 11:18:39 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728032AbfLMQSi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 11:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576253917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wz+kj9bS7gdLelr2F1XTImk+uhNKHdBToR+OTBW2CLw=;
        b=ARgXs80X6Oz740wQySDOCTsnUMLDtzH/IBDamZ8FLQhekFR/kJPKpd7R5rCuUtEJUBh0QW
        hskHdAqkxdd6k3G/XlWDIQqvHZ6hMyyAvXSvOk382a4qsnQeY5XLoRaJ0iceGMHzX9wYtq
        e0TyKO+JUU6lsKBPoTKWTlqhbyRoTO0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-LJRbsRb5OhS3yg3bYkLDHQ-1; Fri, 13 Dec 2019 11:18:36 -0500
X-MC-Unique: LJRbsRb5OhS3yg3bYkLDHQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7D391005512;
        Fri, 13 Dec 2019 16:18:34 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-205-147.brq.redhat.com [10.40.205.147])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D383D19C4F;
        Fri, 13 Dec 2019 16:18:20 +0000 (UTC)
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
Subject: [PATCH 02/12] hw/i386/pc: Move kvm_i8259_init() declaration to sysemu/kvm.h
Date:   Fri, 13 Dec 2019 17:17:43 +0100
Message-Id: <20191213161753.8051-3-philmd@redhat.com>
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

Move the KVM-related call to "sysemu/kvm.h".

Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@redhat.com>
---
 include/hw/i386/pc.h | 1 -
 include/sysemu/kvm.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 1f86eba3f9..9866dfbd60 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -138,7 +138,6 @@ typedef struct PCMachineClass {
=20
 extern DeviceState *isa_pic;
 qemu_irq *i8259_init(ISABus *bus, qemu_irq parent_irq);
-qemu_irq *kvm_i8259_init(ISABus *bus);
 int pic_read_irq(DeviceState *d);
 int pic_get_output(DeviceState *d);
=20
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 9fe233b9bf..0f57667f79 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -518,6 +518,7 @@ void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_ir=
q irq, int gsi);
 void kvm_pc_gsi_handler(void *opaque, int n, int level);
 void kvm_pc_setup_irq_routing(bool pci_enabled);
 void kvm_init_irq_routing(KVMState *s);
+qemu_irq *kvm_i8259_init(ISABus *bus);
=20
 /**
  * kvm_arch_irqchip_create:
--=20
2.21.0

