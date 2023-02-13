Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3190694290
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjBMKSR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbjBMKSJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:09 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99136EB6D
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:08 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04392176C;
        Mon, 13 Feb 2023 02:18:51 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8494E3F703;
        Mon, 13 Feb 2023 02:18:07 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com,
        ricarkol@google.com
Subject: [PATCH v4 03/30] arm/Makefile.common: Compile lib/acpi.c if CONFIG_EFI=y
Date:   Mon, 13 Feb 2023 10:17:32 +0000
Message-Id: <20230213101759.2577077-4-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexandru Elisei <alexandru.elisei@arm.com>

For arm/arm64, ACPI is available only when UEFI is present. Compile
acpi.c if CONFIG_EFI is set to 'y'. For now, only x86 can configure the
tests with --enable-efi, but that will soon change.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/Makefile.common | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 1bbec64f..3a726c20 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -54,6 +54,10 @@ cflatobjs += lib/arm/smp.o
 cflatobjs += lib/arm/delay.o
 cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
 
+ifeq ($(CONFIG_EFI),y)
+cflatobjs += lib/acpi.o
+endif
+
 OBJDIRS += lib/arm
 
 libeabi = lib/arm/libeabi.a
-- 
2.25.1

