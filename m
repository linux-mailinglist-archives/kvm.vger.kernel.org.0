Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7A121C51F
	for <lists+kvm@lfdr.de>; Sat, 11 Jul 2020 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728623AbgGKQQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Jul 2020 12:16:59 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:15133 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728441AbgGKQQ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 11 Jul 2020 12:16:58 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Sat, 11 Jul 2020 09:16:52 -0700
Received: from sc2-haas01-esx0118.eng.vmware.com (sc2-haas01-esx0118.eng.vmware.com [10.172.44.118])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id 7D63D4060D;
        Sat, 11 Jul 2020 09:16:58 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <kvm@vger.kernel.org>, Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: reverse FW_CFG_MAX_ENTRY and FW_CFG_MAX_RAM
Date:   Sat, 11 Jul 2020 09:14:32 -0700
Message-ID: <20200711161432.32862-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: namit@vmware.com does not
 designate permitted sender hosts)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

FW_CFG_MAX_ENTRY should obviously be the last entry.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 lib/x86/fwcfg.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/x86/fwcfg.h b/lib/x86/fwcfg.h
index 64d4c6e..8095d8a 100644
--- a/lib/x86/fwcfg.h
+++ b/lib/x86/fwcfg.h
@@ -20,8 +20,8 @@
 #define FW_CFG_NUMA             0x0d
 #define FW_CFG_BOOT_MENU        0x0e
 #define FW_CFG_MAX_CPUS         0x0f
-#define FW_CFG_MAX_ENTRY        0x10
-#define FW_CFG_MAX_RAM		0x11
+#define FW_CFG_MAX_RAM		0x10
+#define FW_CFG_MAX_ENTRY        0x11
 
 #define FW_CFG_WRITE_CHANNEL    0x4000
 #define FW_CFG_ARCH_LOCAL       0x8000
-- 
2.25.1

