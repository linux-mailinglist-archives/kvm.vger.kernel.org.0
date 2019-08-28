Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C3BA0360
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfH1Niz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:38:55 -0400
Received: from foss.arm.com ([217.140.110.172]:59532 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfH1Niy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:38:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2BE1A28;
        Wed, 28 Aug 2019 06:38:54 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0565A3F246;
        Wed, 28 Aug 2019 06:38:52 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 03/16] lib: arm/arm64: Add missing include for alloc_page.h in pgtable.h
Date:   Wed, 28 Aug 2019 14:38:18 +0100
Message-Id: <1566999511-24916-4-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pgtable.h is used only by mmu.c, where it is included after alloc_page.h.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/pgtable.h   | 1 +
 lib/arm64/asm/pgtable.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 241dff69b38a..b01c34348321 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -13,6 +13,7 @@
  *
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
+#include <alloc_page.h>
 
 /*
  * We can convert va <=> pa page table addresses with simple casts
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index ee0a2c88cc18..e9dd49155564 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -14,6 +14,7 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 #include <alloc.h>
+#include <alloc_page.h>
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/pgtable-hwdef.h>
-- 
2.7.4

