Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9610CE41
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 19:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfK1SEl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 13:04:41 -0500
Received: from foss.arm.com ([217.140.110.172]:39358 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726876AbfK1SEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Nov 2019 13:04:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FE6A31B;
        Thu, 28 Nov 2019 10:04:40 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1D3DF3F6C4;
        Thu, 28 Nov 2019 10:04:39 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, drjones@redhat.com,
        maz@kernel.org, andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 07/18] lib: arm/arm64: Add missing include for alloc_page.h in pgtable.h
Date:   Thu, 28 Nov 2019 18:04:07 +0000
Message-Id: <20191128180418.6938-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191128180418.6938-1-alexandru.elisei@arm.com>
References: <20191128180418.6938-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pgtable.h is used only by mmu.c, where it is included after alloc_page.h.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/pgtable.h   | 1 +
 lib/arm64/asm/pgtable.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index 794514b8c927..e7f967071980 100644
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
index dbf9e7253b71..6412d67759e4 100644
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
2.20.1

