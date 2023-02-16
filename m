Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452DB69977A
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjBPObf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 09:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbjBPObd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 09:31:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748164B514
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 06:31:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C01614E2
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 14:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270DC433EF;
        Thu, 16 Feb 2023 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676557889;
        bh=QqKWnxVCmWjaRHHpFhF9lvt+Kt1/5o5W5NIuE4VWNwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBVBIVKxfN+otxuDh6tjITGWlD2qZDMmlePf2P+zsLwLtBZNJml2UZXr9wo/KzhfD
         +DLAftqcKO6kMhOlxQELU7as2b7dfitiOvkVwlY10gpOBFJFZPHS6sIuU6AE+V5RYt
         pVv+G9Sk34MHxhtlqfNthRXYV6d+lnZRLOkQyZVzprLW7rYrfV2Rd4E4UezXAA04FW
         W1uo3lEp0Hh/Qbo3JiraAVfgDlNBoRfdUwUUjgHwIjgpYxS+DJDtlE7RIVJZDW/Gz0
         5j+AQZjL6T7Ch/3llwQjP97zZBhI8X3ThnLoq5JGtoCH9cyU9OoK1yt9IcWC5DUA7y
         vqMnS8MLWR9Iw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pSf8v-00AuwB-OE;
        Thu, 16 Feb 2023 14:21:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>, dwmw2@infradead.org
Subject: [PATCH 11/16] KVM: arm64: Document KVM_ARM_SET_CNT_OFFSETS and co
Date:   Thu, 16 Feb 2023 14:21:18 +0000
Message-Id: <20230216142123.2638675-12-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230216142123.2638675-1-maz@kernel.org>
References: <20230216142123.2638675-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add some basic documentation on the effects of KVM_ARM_SET_CNT_OFFSETS.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/virt/kvm/api.rst | 47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0a67cb738013..bdd361fd90f4 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5937,6 +5937,53 @@ delivery must be provided via the "reg_aen" struct.
 The "pad" and "reserved" fields may be used for future extensions and should be
 set to 0s by userspace.
 
+4.138 KVM_ARM_SET_CNT_OFFSETS
+-----------------------------
+
+:Capability: KVM_CAP_COUNTER_OFFSETS
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_counter_offsets (in)
+:Returns: 0 on success, <0 on error
+
+This capability indicates that userspace is able to apply a set of
+VM-wide offsets to the virtual and physical counters as viewed by the
+guest using the KVM_ARM_SET_CNT_OFFSETS ioctl and the following data
+structure:
+
+	struct kvm_arm_counter_offsets {
+		__u64 virtual_offset;
+		__u64 physical_offset;
+
+	#define KVM_COUNTER_SET_VOFFSET_FLAG   (1UL << 0)
+	#define KVM_COUNTER_SET_POFFSET_FLAG   (1UL << 1)
+
+		__u64 flags;
+		__u64 reserved;
+	};
+
+Each of the two offsets describe a number of counter cycles that are
+subtracted from the corresponding counter (similar to the effects of
+the CNTVOFF_EL2 and CNTPOFF_EL2 system registers). For each offset
+that userspace wishes to change, it must set the corresponding flag in
+the "flag" field. These values always apply to all vcpus (already
+created or created after this ioctl) in this VM.
+
+It is userspace's responsibility to compute the offsets based, for
+example, on previous values of the guest counters.
+
+With nested virtualisation, the virtual offset as no effect on the
+execution of the guest, and the nested hypervisor is responsible for
+the offset that is presented to its own guests.
+
+Any flag value that isn't described here, or any value other than 0
+for the "reserved" field may result in an error being returned.
+
+Note that using this ioctl results in KVM ignoring subsequent
+userspace writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the
+SET_ONE_REG interface. No error will be returned, but the resulting
+offset will not be applied.
+
 5. The kvm_run structure
 ========================
 
-- 
2.34.1

