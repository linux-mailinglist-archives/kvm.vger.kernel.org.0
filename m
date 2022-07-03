Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6E356497D
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 21:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiGCTQw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Jul 2022 15:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiGCTQv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Jul 2022 15:16:51 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AD86243
        for <kvm@vger.kernel.org>; Sun,  3 Jul 2022 12:16:50 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id q132-20020a632a8a000000b00411eb01811fso2340510pgq.3
        for <kvm@vger.kernel.org>; Sun, 03 Jul 2022 12:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vazLTlsYU+mYFnCPz/KZ8cOdjR8SVTeoUYL47/gBt1w=;
        b=ZodkwlLK0IT7ofzMQt2k4WOZP0X2X2953VKOqvEd0vxi6qdy9w8JbnSHtEkZ+MNLTc
         3hi56DCsho54HnXeg1DqaO0P0dtKOdkqzA+NOZs8hYb3GxSvVnUhLImYVQAhfj3BOz1b
         CASv8AFIs4URYXNKLTeYjUMwXaglnE4D7wx1P0cLQm07n9KKcry/EXih0NX7IMqaFaQS
         /Q6YxGhF/7hceKbsuFxBGg3UqCjokYAJ6yL9WHPmT6xGG0zq/ZI55YQrqrHkjAaMlODk
         3iAT0TqjpE+wYV7x2rdzYz9+pMHYG6m94ZUP9YEDla8TINCfa23aFJZNuxtjAqFcm8DW
         EXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vazLTlsYU+mYFnCPz/KZ8cOdjR8SVTeoUYL47/gBt1w=;
        b=FMjR9CMauFEdOyZRSdsRtSnP4/Jk9JzEY8UYNfrO5TXBlBZ+kSHOBtanNT3UVOPneE
         +OGZmpbWApTuH2lbgTH6TR7UxvBD94MfBGuFn+RnkfoQoqBx7xBBoAhF3SEnTlGutObx
         LgENrLNatTLJgzMdLx+lnFwj3IhwUsB6hC4bA5HSs1j2VzsmiVI6wPnK10TGWmFzCWs9
         aokyasfN/f9nj9MJk76Iy7tK0R3rrVKfmKjzv4PEks6AzH3wf4YoSXROG/tQmSAT5JLT
         Z/PJ7jqh9m2S/iWEX1uy+MHWbzR+kDzSg7thGGrdazKd1xojB6B2WyZHonmJVnPNCMOr
         52vA==
X-Gm-Message-State: AJIora9J4zIZU2BbsmuneXA5rh5N/Ii8fsHpQxVNDWdGVTBW310kCAx7
        9rjiixVJ7wqlm+0iQ9xwSsKCaLzkVoZbFVy1abkBVu1LVjhZE7MSOKJKE+bC4/AnF2g07If5W7r
        Xmr7oT874yw8KT6If/lYBacu4+vTDxhzrL2DfiU3p9qfgXEgAuRc+vIra6ix0dVPdG6w+
X-Google-Smtp-Source: AGRyM1t2rgmG3fiYGGTFv0Zq47qwynn/K+X9urm5CuzTRvM9+BSrxYU2+zV3eNyA1ZpGq4br8lE/+UtavXMsx7F8
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:cec4:b0:16a:16d6:f67f with SMTP
 id d4-20020a170902cec400b0016a16d6f67fmr30334899plg.139.1656875810234; Sun,
 03 Jul 2022 12:16:50 -0700 (PDT)
Date:   Sun,  3 Jul 2022 19:16:36 +0000
In-Reply-To: <20220703191636.2159067-1-aaronlewis@google.com>
Message-Id: <20220703191636.2159067-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220703191636.2159067-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 3/3] KVM: x86: Don't deflect MSRs to userspace that can't be filtered
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If an MSR is not permitted to be filtered and deflected to userspace,
don't then allow it to be deflected to userspace by other means.  If an
MSR that cannot be filtered #GP's, and KVM is configured to send all
MSRs that #GP to userspace, that MSR will be sent to userspace as well.
Prevent that from happening by filtering out disallowed MSRs from being
deflected to userspace.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/x86.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 031678eff28e..a84741f7d254 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1712,6 +1712,15 @@ void kvm_enable_efer_bits(u64 mask)
 }
 EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
 
+bool kvm_msr_filtering_disallowed(u32 index)
+{
+	/* x2APIC MSRs do not support filtering. */
+	if (index >= 0x800 && index <= 0x8ff)
+		return true;
+
+	return false;
+}
+
 bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 {
 	struct kvm_x86_msr_filter *msr_filter;
@@ -1721,8 +1730,8 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 	int idx;
 	u32 i;
 
-	/* x2APIC MSRs do not support filtering. */
-	if (index >= 0x800 && index <= 0x8ff)
+	/* Prevent certain MSRs from using MSR Filtering. */
+	if (kvm_msr_filtering_disallowed(index))
 		return true;
 
 	idx = srcu_read_lock(&kvm->srcu);
@@ -1962,6 +1971,9 @@ static int kvm_msr_user_space(struct kvm_vcpu *vcpu, u32 index,
 	if (!(vcpu->kvm->arch.user_space_msr_mask & msr_reason))
 		return 0;
 
+	if (kvm_msr_filtering_disallowed(index))
+		return 0;
+
 	vcpu->run->exit_reason = exit_reason;
 	vcpu->run->msr.error = 0;
 	memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
-- 
2.37.0.rc0.161.g10f37bed90-goog

