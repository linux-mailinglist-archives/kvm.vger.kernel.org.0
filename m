Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5391E1D354E
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgENPi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:58 -0400
Received: from foss.arm.com ([217.140.110.172]:39248 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgENPi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:56 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5DC621FB;
        Thu, 14 May 2020 08:38:56 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35EA73F71E;
        Thu, 14 May 2020 08:38:54 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org,
        Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v4 kvmtool 11/12] arm/fdt: Remove 'linux,pci-probe-only' property
Date:   Thu, 14 May 2020 16:38:28 +0100
Message-Id: <1589470709-4104-12-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
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
2.7.4

