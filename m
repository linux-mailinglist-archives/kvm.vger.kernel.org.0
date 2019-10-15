Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040FBD7BAF
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388140AbfJOQc0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:32:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbfJOQc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:32:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CF7F618CB911;
        Tue, 15 Oct 2019 16:32:25 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26E3619C58;
        Tue, 15 Oct 2019 16:32:16 +0000 (UTC)
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
Subject: [PATCH 26/32] hw/pci-host/piix: Move RCR_IOPORT register definition
Date:   Tue, 15 Oct 2019 18:26:59 +0200
Message-Id: <20191015162705.28087-27-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Tue, 15 Oct 2019 16:32:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

The RCR_IOPORT register belongs to the PIIX chipset.
Move the definition to "piix.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 hw/pci-host/piix.c            | 1 +
 include/hw/i386/pc.h          | 6 ------
 include/hw/southbridge/piix.h | 6 ++++++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/hw/pci-host/piix.c b/hw/pci-host/piix.c
index 3292703de7..3770575c1a 100644
--- a/hw/pci-host/piix.c
+++ b/hw/pci-host/piix.c
@@ -27,6 +27,7 @@
 #include "hw/irq.h"
 #include "hw/pci/pci.h"
 #include "hw/pci/pci_host.h"
+#include "hw/southbridge/piix.h"
 #include "hw/qdev-properties.h"
 #include "hw/isa/isa.h"
 #include "hw/sysbus.h"
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 183326d9fe..1c20b96571 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -257,12 +257,6 @@ typedef struct PCII440FXState PCII440FXState;
 
 #define TYPE_IGD_PASSTHROUGH_I440FX_PCI_DEVICE "igd-passthrough-i440FX"
 
-/*
- * Reset Control Register: PCI-accessible ISA-Compatible Register at address
- * 0xcf9, provided by the PCI/ISA bridge (PIIX3 PCI function 0, 8086:7000).
- */
-#define RCR_IOPORT 0xcf9
-
 PCIBus *i440fx_init(const char *host_type, const char *pci_type,
                     PCII440FXState **pi440fx_state, int *piix_devfn,
                     ISABus **isa_bus, qemu_irq *pic,
diff --git a/include/hw/southbridge/piix.h b/include/hw/southbridge/piix.h
index add352456b..79ebe0089b 100644
--- a/include/hw/southbridge/piix.h
+++ b/include/hw/southbridge/piix.h
@@ -18,6 +18,12 @@ I2CBus *piix4_pm_init(PCIBus *bus, int devfn, uint32_t smb_io_base,
                       qemu_irq sci_irq, qemu_irq smi_irq,
                       int smm_enabled, DeviceState **piix4_pm);
 
+/*
+ * Reset Control Register: PCI-accessible ISA-Compatible Register at address
+ * 0xcf9, provided by the PCI/ISA bridge (PIIX3 PCI function 0, 8086:7000).
+ */
+#define RCR_IOPORT 0xcf9
+
 extern PCIDevice *piix4_dev;
 
 DeviceState *piix4_create(PCIBus *pci_bus, ISABus **isa_bus,
-- 
2.21.0

