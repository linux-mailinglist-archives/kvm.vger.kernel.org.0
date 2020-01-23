Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E38014698A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgAWNsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:22 -0500
Received: from foss.arm.com ([217.140.110.172]:39646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgAWNsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:22 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F9E91007;
        Thu, 23 Jan 2020 05:48:20 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 95DEF3F68E;
        Thu, 23 Jan 2020 05:48:19 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 01/30] Makefile: Use correct objcopy binary when cross-compiling for x86_64
Date:   Thu, 23 Jan 2020 13:47:36 +0000
Message-Id: <20200123134805.1993-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
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
index b76d844f2e01..6d6880dd4f8a 100644
--- a/Makefile
+++ b/Makefile
@@ -22,6 +22,7 @@ CC	:= $(CROSS_COMPILE)gcc
 CFLAGS	:=
 LD	:= $(CROSS_COMPILE)ld
 LDFLAGS	:=
+OBJCOPY	:= $(CROSS_COMPILE)objcopy
 
 FIND	:= find
 CSCOPE	:= cscope
@@ -479,7 +480,7 @@ x86/bios/bios.bin.elf: x86/bios/entry.S x86/bios/e820.c x86/bios/int10.c x86/bio
 
 x86/bios/bios.bin: x86/bios/bios.bin.elf
 	$(E) "  OBJCOPY " $@
-	$(Q) objcopy -O binary -j .text x86/bios/bios.bin.elf x86/bios/bios.bin
+	$(Q) $(OBJCOPY) -O binary -j .text x86/bios/bios.bin.elf x86/bios/bios.bin
 
 x86/bios/bios-rom.o: x86/bios/bios-rom.S x86/bios/bios.bin x86/bios/bios-rom.h
 	$(E) "  CC      " $@
-- 
2.20.1

