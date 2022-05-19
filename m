Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE46552D50A
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiESNtn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbiESNth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:49:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D821A045
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81456B824A6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA919C385B8;
        Thu, 19 May 2022 13:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652968086;
        bh=S0NIjDKf9+rgpK0PQjxkwGZ1hayqbk6xeRNbkZiaeAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5NfQ+2MWe5P5aBo/67wWU4PsJrsByA2i3PIYW5amw33uWiZxKKHtRExK7tShypjR
         3RVV7PraQRArJOIzQiwnm58dAl0OvyWJlKtVbA9kxMzEA/M5YnwvdM0pfqrgQ75RHg
         mWgxOoZAJGVJXCiNYqfkJJ+7coKcovUfOlLvMoweq/LKnbzMlcvuIi3WfyIyL7mtNy
         Zd7UtBcY9qvZtCJXIIGWBGN37rhXsjkAK2N0jHQh4LqnfHPWC60nCN7hu+U1+mw1Cu
         ETJl94SJxf9ramNn7jNOykMirgiO6qu5E8gSoFHfZeESZ8+SSPT1+uKzIrIBakI9/9
         KPZkXwdwX2m7g==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 86/89] KVM: arm64: Reformat/beautify PTP hypercall documentation
Date:   Thu, 19 May 2022 14:42:01 +0100
Message-Id: <20220519134204.5379-87-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PTP hypercall documentation doesn't produce the best-looking table
when formatting in HTML as all of the return value definitions end up
on the same line.

Reformat the PTP hypercall documentation to follow the formatting used
by hypercalls.rst.

Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/virt/kvm/arm/ptp_kvm.rst | 38 ++++++++++++++++----------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst b/Documentation/virt/kvm/arm/ptp_kvm.rst
index aecdc80ddcd8..7c0960970a0e 100644
--- a/Documentation/virt/kvm/arm/ptp_kvm.rst
+++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
@@ -7,19 +7,29 @@ PTP_KVM is used for high precision time sync between host and guests.
 It relies on transferring the wall clock and counter value from the
 host to the guest using a KVM-specific hypercall.
 
-* ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID: 0x86000001
+``ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID``
+----------------------------------------
 
-This hypercall uses the SMC32/HVC32 calling convention:
+Retrieve current time information for the specific counter. There are no
+endianness restrictions.
 
-ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
-    ==============    ========    =====================================
-    Function ID:      (uint32)    0x86000001
-    Arguments:        (uint32)    KVM_PTP_VIRT_COUNTER(0)
-                                  KVM_PTP_PHYS_COUNTER(1)
-    Return Values:    (int32)     NOT_SUPPORTED(-1) on error, or
-                      (uint32)    Upper 32 bits of wall clock time (r0)
-                      (uint32)    Lower 32 bits of wall clock time (r1)
-                      (uint32)    Upper 32 bits of counter (r2)
-                      (uint32)    Lower 32 bits of counter (r3)
-    Endianness:                   No Restrictions.
-    ==============    ========    =====================================
++---------------------+-------------------------------------------------------+
+| Presence:           | Optional                                              |
++---------------------+-------------------------------------------------------+
+| Calling convention: | HVC32                                                 |
++---------------------+----------+--------------------------------------------+
+| Function ID:        | (uint32) | 0x86000001                                 |
++---------------------+----------+----+---------------------------------------+
+| Arguments:          | (uint32) | R1 | ``KVM_PTP_VIRT_COUNTER (0)``          |
+|                     |          |    +---------------------------------------+
+|                     |          |    | ``KVM_PTP_PHYS_COUNTER (1)``          |
++---------------------+----------+----+---------------------------------------+
+| Return Values:      | (int32)  | R0 | ``NOT_SUPPORTED (-1)`` on error, else |
+|                     |          |    | upper 32 bits of wall clock time      |
+|                     +----------+----+---------------------------------------+
+|                     | (uint32) | R1 | Lower 32 bits of wall clock time      |
+|                     +----------+----+---------------------------------------+
+|                     | (uint32) | R2 | Upper 32 bits of counter              |
+|                     +----------+----+---------------------------------------+
+|                     | (uint32) | R3 | Lower 32 bits of counter              |
++---------------------+----------+----+---------------------------------------+
-- 
2.36.1.124.g0e6072fb45-goog

