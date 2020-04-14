Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E81A7FFC
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391074AbgDNOkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:40:32 -0400
Received: from foss.arm.com ([217.140.110.172]:57142 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391045AbgDNOkE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6566DC14;
        Tue, 14 Apr 2020 07:40:04 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 76D363F73D;
        Tue, 14 Apr 2020 07:40:03 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 06/18] arm/pci: Advertise only PCI bus 0 in the DT
Date:   Tue, 14 Apr 2020 15:39:34 +0100
Message-Id: <20200414143946.1521-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "bus-range" property encodes the PCI bus number of the PCI
controller and the largest bus number of any PCI buses that are
subordinate to this node [1]. kvmtool emulates only PCI bus 0.
Advertise this in the PCI DT node by setting "bus-range" to <0,0>.

[1] IEEE Std 1275-1994, Section 3 "Bus Nodes Properties and Methods"

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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

