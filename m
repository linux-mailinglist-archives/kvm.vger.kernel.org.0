Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851411469A7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgAWNso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:44 -0500
Received: from foss.arm.com ([217.140.110.172]:39794 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729182AbgAWNsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FF5DFEC;
        Thu, 23 Jan 2020 05:48:42 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 74ECE3F68E;
        Thu, 23 Jan 2020 05:48:41 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 18/30] hw/vesa: Set the size for BAR 0
Date:   Thu, 23 Jan 2020 13:47:53 +0000
Message-Id: <20200123134805.1993-19-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

BAR 0 is an I/O BAR and is registered as an ioport region. Let's set its
size, so a guest can actually use it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/vesa.c b/hw/vesa.c
index a665736a76d7..e988c0425946 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -70,6 +70,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 
 	vesa_base_addr			= (u16)r;
 	vesa_pci_device.bar[0]		= cpu_to_le32(vesa_base_addr | PCI_BASE_ADDRESS_SPACE_IO);
+	vesa_pci_device.bar_size[0]	= PCI_IO_SIZE;
 	r = device__register(&vesa_device);
 	if (r < 0)
 		return ERR_PTR(r);
-- 
2.20.1

