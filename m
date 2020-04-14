Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71FD1A8005
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391089AbgDNOlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:41:53 -0400
Received: from foss.arm.com ([217.140.110.172]:57208 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391073AbgDNOkZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:40:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F9F413A1;
        Tue, 14 Apr 2020 07:40:17 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 412F83F73D;
        Tue, 14 Apr 2020 07:40:16 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 17/18] hw/vesa: Set the size for BAR 0
Date:   Tue, 14 Apr 2020 15:39:45 +0100
Message-Id: <20200414143946.1521-18-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414143946.1521-1-alexandru.elisei@arm.com>
References: <20200414143946.1521-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implemented BARs have an non-zero address and a size. Let's set the size
for BAR 0.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/vesa.c b/hw/vesa.c
index ad09373ea2ff..dd59a112330b 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -69,6 +69,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 		goto out_error;
 
 	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
+	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
 	r = device__register(&vesa_device);
 	if (r < 0)
 		goto unregister_ioport;
-- 
2.20.1

