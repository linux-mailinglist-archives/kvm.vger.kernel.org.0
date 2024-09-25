Return-Path: <kvm+bounces-27404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F88A9851CD
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 06:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 535C6282038
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 04:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF47154444;
	Wed, 25 Sep 2024 04:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQBL34Ie"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB3514D430;
	Wed, 25 Sep 2024 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727237088; cv=none; b=FwPqCsgEQfJUHrY4zbsdFBUfy8loOeB0hi/GdtBApAPka4TtuBzPJJ3Ibn5A70kahwzRyGoNrl1YdmacwE/VTAUh99FU+z2DaDT98WcgipkdtShsFo23ZvhS2O+/s9bGZ2wgt2/7a/hlChk+2alVsGIiqPdvqKv/Mcco5urAEU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727237088; c=relaxed/simple;
	bh=HyDO27bbwvGnP2jk3WuUqwpQO7z9TvoRhrGQnYKy/6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiSYqcx5YVPsZ4XgGsm/RtzamNe8Xv39w94e55j3rKYmfwv76Xc74QZTeq42VfvHPnEyMMlFrAWGWHs7iFjCirWDFe+4rBfyDn0JY7K4yjrM6LDgzwpDGCU21esucTWVCSHVHs7m9VUHyfBCC1xToIsYylHCFEoERiRDGJPSa1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQBL34Ie; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB99C4CED9;
	Wed, 25 Sep 2024 04:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727237088;
	bh=HyDO27bbwvGnP2jk3WuUqwpQO7z9TvoRhrGQnYKy/6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQBL34IelkalYU64HSrr/DsX0BuQE+jKtfbNvPFQSIMgo8p1KG9CyQMDhPA3TM7eO
	 gtIDt8SwJDppUi4jdi61PaexYtD8GRSnRWo0onAYlUTNfT6iqxAtV9Q8nmSlhyLi0k
	 m+bCU1h1qOcw+cWYPNpwdRHuoFSaTjroH2NpnA9Q4aII4DEbBQqVFKU/6YsTDAr0UW
	 kqLB99kWqbBij+IzFQhMYLIE11akCQSMCxa2eIMKLopamEf59Nw7uubmOqYLBRsmAF
	 L3Kfc5WazHECQ6zPlhU4cgL2rFDGjNk9c1GHOv8BBZiTPgLiv7Wnc7PFNpzxlVDyya
	 jF3WjEsswy2LQ==
Received: from mchehab by mail.kernel.org with local (Exim 4.98)
	(envelope-from <mchehab+huawei@kernel.org>)
	id 1stJGg-0000000828L-1RA4;
	Wed, 25 Sep 2024 06:04:46 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qemu-arm@nongnu.org,
	qemu-devel@nongnu.org
Subject: [PATCH 11/15] acpi/ghes: better name GHES memory error function
Date: Wed, 25 Sep 2024 06:04:16 +0200
Message-ID: <f4c031c627e761b2a48267f1cec1af3a7ad0acbb.1727236561.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <cover.1727236561.git.mchehab+huawei@kernel.org>
References: <cover.1727236561.git.mchehab+huawei@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

The current function used to generate GHES data is specific for
memory errors. Give a better name for it, as we now have a generic
function as well.

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 hw/acpi/ghes-stub.c    | 2 +-
 hw/acpi/ghes.c         | 2 +-
 include/hw/acpi/ghes.h | 5 +++--
 target/arm/kvm.c       | 3 ++-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index 2b64cbd2819a..7cec1812dad9 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,7 +11,7 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
 {
     return -1;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 900f1571bc97..3af1cd16d4d7 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -454,7 +454,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     return;
 }
 
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 1b988ac1e2f2..051a9322141f 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -81,15 +81,16 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
+int acpi_ghes_memory_errors(uint16_t source_id,
+                            uint64_t error_physical_addr);
 void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t error_physical_addr);
 
 /**
  * acpi_ghes_present: Report whether ACPI GHES table is present
  *
  * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_record_errors() to record a memory error.
+ * safe to call acpi_ghes_memory_errors() to record a memory error.
  */
 bool acpi_ghes_present(void);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 849e2e21b304..57192285fb96 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2373,7 +2373,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                if (!acpi_ghes_memory_errors(ARM_ACPI_HEST_SRC_ID_SYNC,
+                                             paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
                     error_report("failed to record the error");
-- 
2.46.1


