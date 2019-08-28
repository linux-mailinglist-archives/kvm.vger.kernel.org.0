Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 179B1A0370
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 15:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbfH1NjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 09:39:05 -0400
Received: from foss.arm.com ([217.140.110.172]:59622 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726816AbfH1NjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 09:39:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A408815AB;
        Wed, 28 Aug 2019 06:39:03 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CE493F246;
        Wed, 28 Aug 2019 06:39:02 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: [kvm-unit-tests RFC PATCH 10/16] lib: Add UL and ULL definitions to linux/const.h
Date:   Wed, 28 Aug 2019 14:38:25 +0100
Message-Id: <1566999511-24916-11-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The UL macro was previously defined in lib/arm64/asm/pgtable-hwdef.h. Move
it to lib/linux/const.h so it can be used in other files. To keep things
consistent, also add an ULL macro.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/linux/const.h             | 7 +++++--
 lib/arm64/asm/pgtable-hwdef.h | 2 --
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/linux/const.h b/lib/linux/const.h
index c872bfd25e13..e3c7fec3f4b8 100644
--- a/lib/linux/const.h
+++ b/lib/linux/const.h
@@ -21,7 +21,10 @@
 #define _AT(T,X)	((T)(X))
 #endif
 
-#define _BITUL(x)	(_AC(1,UL) << (x))
-#define _BITULL(x)	(_AC(1,ULL) << (x))
+#define UL(x) 		_AC(x, UL)
+#define ULL(x)		_AC(x, ULL)
+
+#define _BITUL(x)	(UL(1) << (x))
+#define _BITULL(x)	(ULL(1) << (x))
 
 #endif /* !(_LINUX_CONST_H) */
diff --git a/lib/arm64/asm/pgtable-hwdef.h b/lib/arm64/asm/pgtable-hwdef.h
index 045a3ce12645..e6f02fae4075 100644
--- a/lib/arm64/asm/pgtable-hwdef.h
+++ b/lib/arm64/asm/pgtable-hwdef.h
@@ -9,8 +9,6 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
-#define UL(x) _AC(x, UL)
-
 #define PTRS_PER_PTE		(1 << (PAGE_SHIFT - 3))
 
 /*
-- 
2.7.4

