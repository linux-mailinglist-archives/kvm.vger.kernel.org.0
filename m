Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D7251E085
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444294AbiEFVBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444285AbiEFVA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:58 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1FC55C655
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:57:14 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E73D14BF;
        Fri,  6 May 2022 13:57:14 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8D8F3F800;
        Fri,  6 May 2022 13:57:13 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 20/23] lib: Avoid external dependency in libelf
Date:   Fri,  6 May 2022 21:56:02 +0100
Message-Id: <20220506205605.359830-21-nikos.nikoleris@arm.com>
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

There is just a small number of definitions we need from
uapi/linux/elf.h and asm/elf.h and the relocation code is
self-contained.

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
---
 arm/efi/reloc_aarch64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arm/efi/reloc_aarch64.c b/arm/efi/reloc_aarch64.c
index fa0cd6b..3f6d9a6 100644
--- a/arm/efi/reloc_aarch64.c
+++ b/arm/efi/reloc_aarch64.c
@@ -34,8 +34,7 @@
     SUCH DAMAGE.
 */
 
-#include "efi.h"
-#include <elf.h>
+#include <efi.h>
 
 efi_status_t _relocate(long ldbase, Elf64_Dyn *dyn, efi_handle_t image,
 		       efi_system_table_t *sys_tab)
-- 
2.25.1

