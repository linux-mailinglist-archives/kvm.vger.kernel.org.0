Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E551A7FFA
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391042AbgDNOkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:40:02 -0400
Received: from foss.arm.com ([217.140.110.172]:57102 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391034AbgDNOj7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:39:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A51C831B;
        Tue, 14 Apr 2020 07:39:58 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B5FCB3F73D;
        Tue, 14 Apr 2020 07:39:57 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 01/18] Makefile: Use correct objcopy binary when cross-compiling for x86_64
Date:   Tue, 14 Apr 2020 15:39:29 +0100
Message-Id: <20200414143946.1521-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the compiler toolchain version of objcopy instead of the native one
when cross-compiling for the x86_64 architecture.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Tested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 3862112c5ec6..f72f163101c3 100644
--- a/Makefile
+++ b/Makefile
@@ -22,6 +22,7 @@ CC	:= $(CROSS_COMPILE)gcc
 CFLAGS	:=
 LD	:= $(CROSS_COMPILE)ld
 LDFLAGS	:=
+OBJCOPY	:= $(CROSS_COMPILE)objcopy
 
 FIND	:= find
 CSCOPE	:= cscope
@@ -480,7 +481,7 @@ x86/bios/bios.bin.elf: x86/bios/entry.S x86/bios/e820.c x86/bios/int10.c x86/bio
 
 x86/bios/bios.bin: x86/bios/bios.bin.elf
 	$(E) "  OBJCOPY " $@
-	$(Q) objcopy -O binary -j .text x86/bios/bios.bin.elf x86/bios/bios.bin
+	$(Q) $(OBJCOPY) -O binary -j .text x86/bios/bios.bin.elf x86/bios/bios.bin
 
 x86/bios/bios-rom.o: x86/bios/bios-rom.S x86/bios/bios.bin x86/bios/bios-rom.h
 	$(E) "  CC      " $@
-- 
2.20.1

