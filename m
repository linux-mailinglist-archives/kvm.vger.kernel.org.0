Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E553A44EA
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 17:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhFKP1h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 11:27:37 -0400
Received: from foss.arm.com ([217.140.110.172]:32842 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231804AbhFKP1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 11:27:36 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06EFF1FB;
        Fri, 11 Jun 2021 08:25:38 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60D293F73D;
        Fri, 11 Jun 2021 08:25:37 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH] configure: arm: Update kvmtool UART address
Date:   Fri, 11 Jun 2021 16:26:21 +0100
Message-Id: <20210611152621.34242-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvmtool commit 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher
addresses") changed the UART address from 0x3f8 to 0x1000000. Update the
UART early address accordingly when kvm-unit-tests is configured with
--target=kvmtool.

Users of older kvmtool versions can still enjoy having a working early UART
by configuring kvm-unit-tests with --earlycon=uart,mmio,0x3f8. Note that in
this case --target=kvmtool is still recommended because it enables all
erratas.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 4ad5a4bcd782..bd0c14edb777 100755
--- a/configure
+++ b/configure
@@ -189,7 +189,7 @@ elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     if [ "$target" = "qemu" ]; then
         arm_uart_early_addr=0x09000000
     elif [ "$target" = "kvmtool" ]; then
-        arm_uart_early_addr=0x3f8
+        arm_uart_early_addr=0x1000000
         errata_force=1
     else
         echo "--target must be one of 'qemu' or 'kvmtool'!"
-- 
2.32.0

