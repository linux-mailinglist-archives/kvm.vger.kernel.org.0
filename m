Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68887108BC3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfKYKch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:37 -0500
Received: from foss.arm.com ([217.140.110.172]:47714 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727551AbfKYKcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:36 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7BAD328;
        Mon, 25 Nov 2019 02:32:35 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D91C43F52E;
        Mon, 25 Nov 2019 02:32:34 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 05/16] arm: pci.c: Advertise only PCI bus 0 in the DT
Date:   Mon, 25 Nov 2019 10:30:22 +0000
Message-Id: <20191125103033.22694-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "bus-range" property encodes the first and last bus number. kvmtool
uses bus 0 for PCI and bus 1 for MMIO.  Advertise only the PCI bus in
the PCI DT node by setting "bus-range" to <0, 0>.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/pci.c b/arm/pci.c
index 557cfa98938d..ed325fa4a811 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -30,7 +30,7 @@ void pci__generate_fdt_nodes(void *fdt)
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
 	unsigned nentries = 0;
 	/* Bus range */
-	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
+	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(0), };
 	/* Configuration Space */
 	u64 cfg_reg_prop[] = { cpu_to_fdt64(KVM_PCI_CFG_AREA),
 			       cpu_to_fdt64(ARM_PCI_CFG_SIZE), };
-- 
2.20.1

