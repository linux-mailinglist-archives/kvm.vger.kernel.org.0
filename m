Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2FE57EAE1
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiGWAxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbiGWAxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:53:15 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E97CC0B54
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:26 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y37-20020a056a001ca500b00528bbf82c1eso2470377pfw.10
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=pY4rxlForxQbmu/q/udq3u4PIKEqbChyIAtdlo0LuhQ=;
        b=jPrSuztZoQ+lv7DF55SpPwpb/t2LP0ggMpXTN+6d2s8+55zaysm3QQBP8Z3dzruo2o
         lREV46xx9I1bXRGbXpOL33TxjMZUuQG2e8zq/E0ToWO9e7NNFrYN+fBcWhIq2MusDfep
         GDOehkBROOUKx7WNbUh3ARt4u8Wmuu4FdWLqEy7RyeF4jGhh+7Ulkgwkl9Lh8McSE6MR
         uzFyKK7bMEbhavZyQsbty2jo61hTaji6uOs5ogQ1/oeD/v4onFOVoc/sl2YZj9XGryGu
         QKvvMM+5AyVnvxIbpc5xx54iTR4BNyZ/fT5YOaHBF7VFpj4I2kwGJ+VOClGI85TuwSEx
         B7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=pY4rxlForxQbmu/q/udq3u4PIKEqbChyIAtdlo0LuhQ=;
        b=4XADso21W0LoMydcoaYMWzoN5joB5NLj7JX3Zc+sBAjdfeQ/OHmJQmoaOUEcipKIXp
         LnRfJ5CZTkD91+9AjELQFIwVPXTqGr06iBrd4TjYuJy+0KUiZpngPHymviuTtgnMNsrj
         sjCT8/bdOf/latJapOX1bSPR/TCt1c6tq/NZYkegGNiLhsUkXdXLaYw8xVIb7jRohWS5
         SD1HoErvfJWz8mvjIUw5VNwZeeByV6GEdFOylmvOhH+KMq+LohJTm33AZZzPmfit+a4G
         o2+QUmVVztYlvXxYsiYOJIgfIfETgoHlcMlZ0cDfFHsVRJjNZHunR+0QhU2pHk4ch9Fc
         U6BA==
X-Gm-Message-State: AJIora+TwwfQ6ptULcoPxjzZmb0Qmlonz7As+gWUEAI//cnMJOBugIM8
        mbBLy8xh9gK6KVQBMJnfJFsESatCoBA=
X-Google-Smtp-Source: AGRyM1tZF7A/hmAoF/i10swfVyMGFVoUBG9EO5sdAqyF2KJRh9MXKffaX5v65KQb9NdY4WmE/8K/jDye1j4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:b4d:b0:52a:f2cf:b0e4 with SMTP id
 p13-20020a056a000b4d00b0052af2cfb0e4mr2464187pfo.2.1658537535476; Fri, 22 Jul
 2022 17:52:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:34 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-22-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 21/24] KVM: VMX: Update MTF and ICEBP comments to document
 KVM's subtle behavior
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the oddities of ICEBP interception (trap-like #DB is intercepted
as a fault-like exception), and how using VMX's inner "skip" helper
deliberately bypasses the pending MTF and single-step #DB logic.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf8877c545ce..7864353f7547 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1578,9 +1578,13 @@ static void vmx_update_emulated_instruction(struct kvm_vcpu *vcpu)
 
 	/*
 	 * Per the SDM, MTF takes priority over debug-trap exceptions besides
-	 * T-bit traps. As instruction emulation is completed (i.e. at the
-	 * instruction boundary), any #DB exception pending delivery must be a
-	 * debug-trap. Record the pending MTF state to be delivered in
+	 * TSS T-bit traps and ICEBP (INT1).  KVM doesn't emulate T-bit traps
+	 * or ICEBP (in the emulator proper), and skipping of ICEBP after an
+	 * intercepted #DB deliberately avoids single-step #DB and MTF updates
+	 * as ICEBP is higher priority than both.  As instruction emulation is
+	 * completed at this point (i.e. KVM is at the instruction boundary),
+	 * any #DB exception pending delivery must be a debug-trap of lower
+	 * priority than MTF.  Record the pending MTF state to be delivered in
 	 * vmx_check_nested_events().
 	 */
 	if (nested_cpu_has_mtf(vmcs12) &&
@@ -5085,8 +5089,10 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 			 * instruction.  ICEBP generates a trap-like #DB, but
 			 * despite its interception control being tied to #DB,
 			 * is an instruction intercept, i.e. the VM-Exit occurs
-			 * on the ICEBP itself.  Note, skipping ICEBP also
-			 * clears STI and MOVSS blocking.
+			 * on the ICEBP itself.  Use the inner "skip" helper to
+			 * avoid single-step #DB and MTF updates, as ICEBP is
+			 * higher priority.  Note, skipping ICEBP still clears
+			 * STI and MOVSS blocking.
 			 *
 			 * For all other #DBs, set vmcs.PENDING_DBG_EXCEPTIONS.BS
 			 * if single-step is enabled in RFLAGS and STI or MOVSS
-- 
2.37.1.359.gd136c6c3e2-goog

