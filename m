Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F173D7BBA
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388166AbfJOQd1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 12:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388164AbfJOQd1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 12:33:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61EB97BDA9;
        Tue, 15 Oct 2019 16:33:27 +0000 (UTC)
Received: from x1w.redhat.com (ovpn-204-35.brq.redhat.com [10.40.204.35])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F265B4100;
        Tue, 15 Oct 2019 16:33:15 +0000 (UTC)
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
Subject: [PATCH 31/32] hw/pci-host: Rename incorrectly named 'piix' as 'i440fx'
Date:   Tue, 15 Oct 2019 18:27:04 +0200
Message-Id: <20191015162705.28087-32-philmd@redhat.com>
In-Reply-To: <20191015162705.28087-1-philmd@redhat.com>
References: <20191015162705.28087-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 15 Oct 2019 16:33:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <f4bug@amsat.org>

We moved all the PIIX3 southbridge code out of hw/pci-host/piix.c,
it now only contains i440FX northbridge code.
Rename it to match the chipset modelled.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 MAINTAINERS                      | 2 +-
 hw/i386/Kconfig                  | 2 +-
 hw/pci-host/Kconfig              | 2 +-
 hw/pci-host/Makefile.objs        | 2 +-
 hw/pci-host/{piix.c => i440fx.c} | 0
 5 files changed, 4 insertions(+), 4 deletions(-)
 rename hw/pci-host/{piix.c => i440fx.c} (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4845f47d93..1bc9959b8a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1225,7 +1225,7 @@ M: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
 S: Supported
 F: include/hw/i386/
 F: hw/i386/
-F: hw/pci-host/piix.c
+F: hw/pci-host/i440fx.c
 F: hw/pci-host/q35.c
 F: hw/pci-host/pam.c
 F: include/hw/pci-host/i440fx.h
diff --git a/hw/i386/Kconfig b/hw/i386/Kconfig
index 589d75e26a..cfe94aede7 100644
--- a/hw/i386/Kconfig
+++ b/hw/i386/Kconfig
@@ -60,7 +60,7 @@ config I440FX
     select PC_PCI
     select PC_ACPI
     select ACPI_SMBUS
-    select PCI_PIIX
+    select PCI_I440FX
     select PIIX3
     select IDE_PIIX
     select DIMM
diff --git a/hw/pci-host/Kconfig b/hw/pci-host/Kconfig
index 397043b289..b0aa8351c4 100644
--- a/hw/pci-host/Kconfig
+++ b/hw/pci-host/Kconfig
@@ -28,7 +28,7 @@ config PCI_SABRE
     select PCI
     bool
 
-config PCI_PIIX
+config PCI_I440FX
     bool
     select PCI
     select PAM
diff --git a/hw/pci-host/Makefile.objs b/hw/pci-host/Makefile.objs
index a9cd3e022d..efd752b766 100644
--- a/hw/pci-host/Makefile.objs
+++ b/hw/pci-host/Makefile.objs
@@ -13,7 +13,7 @@ common-obj-$(CONFIG_VERSATILE_PCI) += versatile.o
 
 common-obj-$(CONFIG_PCI_SABRE) += sabre.o
 common-obj-$(CONFIG_FULONG) += bonito.o
-common-obj-$(CONFIG_PCI_PIIX) += piix.o
+common-obj-$(CONFIG_PCI_I440FX) += i440fx.o
 common-obj-$(CONFIG_PCI_EXPRESS_Q35) += q35.o
 common-obj-$(CONFIG_PCI_EXPRESS_GENERIC_BRIDGE) += gpex.o
 common-obj-$(CONFIG_PCI_EXPRESS_XILINX) += xilinx-pcie.o
diff --git a/hw/pci-host/piix.c b/hw/pci-host/i440fx.c
similarity index 100%
rename from hw/pci-host/piix.c
rename to hw/pci-host/i440fx.c
-- 
2.21.0

