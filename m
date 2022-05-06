Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F8551E084
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444288AbiEFVBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444279AbiEFVA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C87406A065
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:57:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A473614BF;
        Fri,  6 May 2022 13:57:12 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEB813F800;
        Fri,  6 May 2022 13:57:11 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 18/23] arm64: Change gnu-efi imported file to use defined types
Date:   Fri,  6 May 2022 21:56:00 +0100
Message-Id: <20220506205605.359830-19-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220506205605.359830-1-nikos.nikoleris@arm.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/efi/reloc_aarch64.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index 0867279..fa0cd6b 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -34,14 +34,11 @@
     SUCH DAMAGE.
 */
 
-#include <efi.h>
-#include <efilib.h>
-
+#include "efi.h"
 #include <elf.h>
 
-EFI_STATUS _relocate (long ldbase, Elf64_Dyn *dyn,
-		      EFI_HANDLE image EFI_UNUSED,
-		      EFI_SYSTEM_TABLE *systab EFI_UNUSED)
+efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
+		       efi_system_table_t *sys_tab)
 {
 	long relsz = 0, relent = 0;
 	Elf64_Rela *rel = 0;
-- 
2.25.1

