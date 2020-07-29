Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428EC2319D9
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 08:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgG2G41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 02:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgG2G4Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 02:56:25 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7076DC061794;
        Tue, 28 Jul 2020 23:56:25 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p3so13751766pgh.3;
        Tue, 28 Jul 2020 23:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=xWIw178xfSixLgPUzYTe7I8j3e6PwAuVlCjEytmrmR0=;
        b=dgtcd6tjh0uEX3rlLPmlMzZu/Uv07s/IsFw3o4l2zLSnE+ho0R2rrG2kcjZFqLY2Pk
         iSs/ZdQRdmlv1ISB9+xV/nep911YhWdIsUyQN7PztMzvlf8hJO2k6JVHCPhpelXRhXxb
         pDZpexNdMWFfQG/IFm2M54P0fi+bYb6/hJWw/a8wYMUWsT3VIhBVWGisXGmAuR8n1aAm
         +xoIa4hipe4/lv1R+KrVvU1FOlRlyl6UPI5pcVLR6ckOG8X5wLO3RKR/tPk1YJLt2WZ9
         yy4h7xNUv+Lz2y+i842tctysMmRV4QkKG5nTGO62/GXnRdMOxExrZSDm6LjRTWqXCRmi
         fG7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=xWIw178xfSixLgPUzYTe7I8j3e6PwAuVlCjEytmrmR0=;
        b=ZtUbHStdc0I6Dwjv1oAjzKrFfojsQZLa+dAdemkdeimzXxDqWixA4q94BfBljUotgN
         nHmGXEp/A3e7L8/Ol0iIqBHr1CG2Ae8F+4ZdD4NVKuskBl2961Du95ixy8WMc9WRp4FI
         lDkmM01/fSc6Pbdt9yqBNpgtwrP2yQXmcMoO02esGDauJngRKd3VVhZbM0XXEQafZHQx
         Cw+HS7IHWlADeNfzrcQZvBZh8USIuIIrTztRLuC/9xNnDmh3zYbNAqMVtmN4jCz9JSrf
         HrwjAJa1LQwhlFqN5s17WwXmF7AyLJk9rDV/QHN8JIL2CijzkY36BI/xXWRCh2nSUuec
         QfVQ==
X-Gm-Message-State: AOAM532di70P+VIrh/rQh6pUk+dC0OmqnLvIhohwgWccE0YDzeprBZhJ
        OyWG8Xf0mLlH31pw5PqebpQ=
X-Google-Smtp-Source: ABdhPJygd6nN+UYd24IN0o0Rpe/UczDjuVDaEFQjq54WAbA1vi7+YvcMGLQBvZQq5Zut4N2rVeLGYQ==
X-Received: by 2002:a62:ce88:: with SMTP id y130mr28386033pfg.37.1596005784985;
        Tue, 28 Jul 2020 23:56:24 -0700 (PDT)
Received: from software.domain.org (28.144.92.34.bc.googleusercontent.com. [34.92.144.28])
        by smtp.gmail.com with ESMTPSA id 127sm1207202pgf.5.2020.07.28.23.56.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 23:56:24 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>
Subject: [PATCH 1/5] PCI: Move PCI_VENDOR_ID_REDHAT definition to pci_ids.h
Date:   Wed, 29 Jul 2020 14:58:35 +0800
Message-Id: <1596005919-29365-1-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of duplicating the PCI_VENDOR_ID_REDHAT definition everywhere,
move it to include/linux/pci_ids.h is better.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
This patch has been merged into PCI tree, but the current MIPS tree need
it to avoid build error.

 drivers/gpu/drm/qxl/qxl_dev.h           | 2 --
 drivers/net/ethernet/rocker/rocker_hw.h | 1 -
 include/linux/pci_ids.h                 | 2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/qxl/qxl_dev.h b/drivers/gpu/drm/qxl/qxl_dev.h
index a0ee416..a7bc31f 100644
--- a/drivers/gpu/drm/qxl/qxl_dev.h
+++ b/drivers/gpu/drm/qxl/qxl_dev.h
@@ -131,8 +131,6 @@ enum SpiceCursorType {
 
 #pragma pack(push, 1)
 
-#define REDHAT_PCI_VENDOR_ID 0x1b36
-
 /* 0x100-0x11f reserved for spice, 0x1ff used for unstable work */
 #define QXL_DEVICE_ID_STABLE 0x0100
 
diff --git a/drivers/net/ethernet/rocker/rocker_hw.h b/drivers/net/ethernet/rocker/rocker_hw.h
index 59f1f8b..62fd84c 100644
--- a/drivers/net/ethernet/rocker/rocker_hw.h
+++ b/drivers/net/ethernet/rocker/rocker_hw.h
@@ -25,7 +25,6 @@ enum {
 
 #define ROCKER_FP_PORTS_MAX 62
 
-#define PCI_VENDOR_ID_REDHAT		0x1b36
 #define PCI_DEVICE_ID_REDHAT_ROCKER	0x0006
 
 #define ROCKER_PCI_BAR0_SIZE		0x2000
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0ad5769..5c709a1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2585,6 +2585,8 @@
 
 #define PCI_VENDOR_ID_ASMEDIA		0x1b21
 
+#define PCI_VENDOR_ID_REDHAT		0x1b36
+
 #define PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS	0x1c36
 
 #define PCI_VENDOR_ID_CIRCUITCO		0x1cc8
-- 
2.7.0

