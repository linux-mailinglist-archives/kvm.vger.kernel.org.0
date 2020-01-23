Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC531469A3
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAWNs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:56 -0500
Received: from foss.arm.com ([217.140.110.172]:39872 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbgAWNsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 234B2FEC;
        Thu, 23 Jan 2020 05:48:55 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F3AB63F68E;
        Thu, 23 Jan 2020 05:48:53 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 kvmtool 28/30] arm/fdt: Remove 'linux,pci-probe-only' property
Date:   Thu, 23 Jan 2020 13:48:03 +0000
Message-Id: <20200123134805.1993-29-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

PCI now supports configurable BARs. Get rid of the no longer needed,
Linux-only, fdt property.

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

