Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1B819431B
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgCZPZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:29 -0400
Received: from foss.arm.com ([217.140.110.172]:33938 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728496AbgCZPZ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9EE3E7FA;
        Thu, 26 Mar 2020 08:25:28 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 965EE3F71E;
        Thu, 26 Mar 2020 08:25:27 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v3 kvmtool 30/32] arm/fdt: Remove 'linux,pci-probe-only' property
Date:   Thu, 26 Mar 2020 15:24:36 +0000
Message-Id: <20200326152438.6218-31-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

PCI now supports configurable BARs. Get rid of the no longer needed,
Linux-only, fdt property.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/fdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index c80e6da323b6..02091e9e0bee 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -130,7 +130,6 @@ static int setup_fdt(struct kvm *kvm)
 
 	/* /chosen */
 	_FDT(fdt_begin_node(fdt, "chosen"));
-	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
 
 	/* Pass on our amended command line to a Linux kernel only. */
 	if (kvm->cfg.firmware_filename) {
-- 
2.20.1

