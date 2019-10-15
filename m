Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82B62D7B76
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbfJOQ3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:29:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47758 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727651AbfJOQ3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:29:39 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 547332D7E1;
        Tue, 15 Oct 2019 16:29:39 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3D1319C58;
        Tue, 15 Oct 2019 16:29:31 +0000 (UTC)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Markovic <amarkovic@wavecomp.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        xen-devel@lists.xenproject.org,
        Laurent Vivier <lvivier@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 12/32] piix4: rename PIIX4 object to piix4-isa
Date:   Tue, 15 Oct 2019 18:26:45 +0200
Message-Id: <20191015162705.28087-13-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 15 Oct 2019 16:29:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Hervé Poussineau <hpoussin@reactos.org>

Other piix4 parts are already named piix4-ide and piix4-usb-uhci.

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hervé Poussineau <hpoussin@reactos.org>
Message-Id: <20171216090228.28505-15-hpoussin@reactos.org>
[PMD: rebased]
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/isa/piix4.c       | 1 -
 hw/mips/mips_malta.c | 2 +-
 include/hw/isa/isa.h | 2 ++
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/isa/piix4.c b/hw/isa/piix4.c
index 1cfc51335a..c3a2bd0d70 100644
--- a/hw/isa/piix4.c
+++ b/hw/isa/piix4.c
@@ -45,7 +45,6 @@ typedef struct PIIX4State {
     uint8_t rcr;
 } PIIX4State;
 
-#define TYPE_PIIX4_PCI_DEVICE "PIIX4"
 #define PIIX4_PCI_DEVICE(obj) \
     OBJECT_CHECK(PIIX4State, (obj), TYPE_PIIX4_PCI_DEVICE)
 
diff --git a/hw/mips/mips_malta.c b/hw/mips/mips_malta.c
index 7d25ab6c23..e499b7a6bb 100644
--- a/hw/mips/mips_malta.c
+++ b/hw/mips/mips_malta.c
@@ -1414,7 +1414,7 @@ void mips_malta_init(MachineState *machine)
     ide_drive_get(hd, ARRAY_SIZE(hd));
 
     pci = pci_create_simple_multifunction(pci_bus, PCI_DEVFN(10, 0),
-                                          true, "PIIX4");
+                                          true, TYPE_PIIX4_PCI_DEVICE);
     dev = DEVICE(pci);
     isa_bus = ISA_BUS(qdev_get_child_bus(dev, "isa.0"));
     piix4_devfn = pci->devfn;
diff --git a/include/hw/isa/isa.h b/include/hw/isa/isa.h
index 018ada4f6f..79f703fd6c 100644
--- a/include/hw/isa/isa.h
+++ b/include/hw/isa/isa.h
@@ -147,4 +147,6 @@ static inline ISABus *isa_bus_from_device(ISADevice *d)
     return ISA_BUS(qdev_get_parent_bus(DEVICE(d)));
 }
 
+#define TYPE_PIIX4_PCI_DEVICE "piix4-isa"
+
 #endif
-- 
2.21.0

