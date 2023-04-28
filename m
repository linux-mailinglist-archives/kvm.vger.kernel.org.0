Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374766F1722
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbjD1ME6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233263AbjD1MEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:04:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7A651BEC
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:04:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 992E21474;
        Fri, 28 Apr 2023 05:05:37 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A71163F5A1;
        Fri, 28 Apr 2023 05:04:52 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 04/29] lib: Fix style for acpi.{c,h}
Date:   Fri, 28 Apr 2023 13:03:40 +0100
Message-Id: <20230428120405.3770496-5-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Manually fix style issues to make the files consistent with the kernel
coding style.

Zero-length array members have been replaced with flexible array members
(for details about the motivation, consult
Documentation/process/deprecated.rst in the Linux tree, the section about
zero-length and one-element arrays).

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
[ Alex E: changes other than indentation ]
---
 lib/acpi.h | 18 +++++++++---------
 lib/acpi.c | 16 ++++++++--------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/acpi.h b/lib/acpi.h
index b67bbe19..2da49451 100644
--- a/lib/acpi.h
+++ b/lib/acpi.h
@@ -3,7 +3,7 @@
 
 #include "libcflat.h"
 
-#define ACPI_SIGNATURE(c1, c2, c3, c4)				\
+#define ACPI_SIGNATURE(c1, c2, c3, c4) \
 	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
 
 #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
@@ -11,9 +11,9 @@
 #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
 #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
 
-#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8)	\
-	((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |		\
-	((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32)
+#define ACPI_SIGNATURE_8BYTE(c1, c2, c3, c4, c5, c6, c7, c8) \
+	(((uint64_t)(ACPI_SIGNATURE(c1, c2, c3, c4))) |	     \
+	 ((uint64_t)(ACPI_SIGNATURE(c5, c6, c7, c8)) << 32))
 
 #define RSDP_SIGNATURE_8BYTE (ACPI_SIGNATURE_8BYTE('R', 'S', 'D', ' ', 'P', 'T', 'R', ' '))
 
@@ -34,20 +34,20 @@ struct rsdp_descriptor {	/* Root System Descriptor Pointer */
 	u32 length;			/* Length of table, in bytes, including header */ \
 	u8  revision;			/* ACPI Specification minor version # */	\
 	u8  checksum;			/* To make sum of entire table == 0 */		\
-	u8  oem_id [6];			/* OEM identification */			\
-	u8  oem_table_id [8];		/* OEM table identification */			\
+	u8  oem_id[6];			/* OEM identification */			\
+	u8  oem_table_id[8];		/* OEM table identification */			\
 	u32 oem_revision;		/* OEM revision number */			\
-	u8  asl_compiler_id [4];	/* ASL compiler vendor ID */			\
+	u8  asl_compiler_id[4];		/* ASL compiler vendor ID */			\
 	u32 asl_compiler_revision;	/* ASL compiler revision number */
 
 struct acpi_table {
 	ACPI_TABLE_HEADER_DEF
-	char data[0];
+	char data[];
 };
 
 struct rsdt_descriptor_rev1 {
 	ACPI_TABLE_HEADER_DEF
-	u32 table_offset_entry[1];
+	u32 table_offset_entry[];
 };
 
 struct fadt_descriptor_rev1 {
diff --git a/lib/acpi.c b/lib/acpi.c
index 836156a1..3f87711a 100644
--- a/lib/acpi.c
+++ b/lib/acpi.c
@@ -11,9 +11,9 @@ void set_efi_rsdp(struct rsdp_descriptor *rsdp)
 
 static struct rsdp_descriptor *get_rsdp(void)
 {
-	if (efi_rsdp == NULL) {
+	if (efi_rsdp == NULL)
 		printf("Can't find RSDP from UEFI, maybe set_efi_rsdp() was not called\n");
-	}
+
 	return efi_rsdp;
 }
 #else
@@ -28,9 +28,8 @@ static struct rsdp_descriptor *get_rsdp(void)
 			break;
 	}
 
-	if (addr == 0x100000) {
+	if (addr == 0x100000)
 		return NULL;
-	}
 
 	return rsdp;
 }
@@ -38,18 +37,18 @@ static struct rsdp_descriptor *get_rsdp(void)
 
 void *find_acpi_table_addr(u32 sig)
 {
-	struct rsdp_descriptor *rsdp;
 	struct rsdt_descriptor_rev1 *rsdt;
+	struct rsdp_descriptor *rsdp;
 	void *end;
 	int i;
 
 	/* FACS is special... */
 	if (sig == FACS_SIGNATURE) {
 		struct fadt_descriptor_rev1 *fadt;
+
 		fadt = find_acpi_table_addr(FACP_SIGNATURE);
 		if (!fadt)
 			return NULL;
-
 		return (void *)(ulong) fadt->firmware_ctrl;
 	}
 
@@ -72,9 +71,10 @@ void *find_acpi_table_addr(u32 sig)
 	end = (void *)rsdt + rsdt->length;
 	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
 		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
-		if (t && t->signature == sig) {
+
+		if (t && t->signature == sig)
 			return t;
-		}
 	}
+
 	return NULL;
 }
-- 
2.25.1

