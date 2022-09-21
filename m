Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4299C5C00E2
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 17:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiIUPPj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 11:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiIUPPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 11:15:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBFE8A7CE
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k126-20020a253d84000000b0068bb342010dso5471994yba.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 08:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=lF3Reezuhyb2LBP8KxxkRM/gjijnUv8OAEcc3rfK5XU=;
        b=haKyNeV5X1/gX6FH1qbQrta5Kw9mAhfJBBlBJ5cgEzbtHhUyGggtyQ8IVDm6/GRUaJ
         GqixoSQCP/m3MlWR6zrXCJke+MDU//esJnRcY4d5hnnL0eXcbEzeqC4T7PcFTcaiQFHp
         XfBOm86Kac2k1M12NJuZ23itH3tWkFP2Y+MdmDj54S4YPmpdJKmelfuirH/7R1Tacwr8
         NsSoalHzZeWkchR7QMYvZWPKWxuthyuKeesQiRUGBEbKoc2KxIM96M7aUl5t4GG5vzjb
         33HaS3sAdFxDreBwQH10y31EtpKBz1zPsLBmwI+zT/Mo3zgbui9DNRYibQA6IcPAg4vG
         PuFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=lF3Reezuhyb2LBP8KxxkRM/gjijnUv8OAEcc3rfK5XU=;
        b=J6r22vR4U4jQ+2qwq170s6k6+cWbPYPvUlc2zjy0oqJSowPdz5Iy0hAdR5Y2fm8SSL
         9bDTe1MtTr6khBzWds7aLg+ETMlW8KROP0RF64rsUL5FjThvKFrb3z1tM8LHzeBrv46q
         1mw5RdRkxZ/HXL/dpT8p2rH0Q5F01/JgbWe+urCAziGNuSSKFdqXqgghY3lD8s7V3lnd
         DT/hX7eUHeSmHKXPgurFQ1KEi6SGJ9OaOqO/uHW4kUxUJ8l4wO+qTmORwErvXsDP9Jmg
         TJshlLZRj/EWu6DQJ170HbSvc9s3Knz8RTTZ3+Wt9u2TqdYfr4S/3lEYXCNz2vOXbi30
         rsCw==
X-Gm-Message-State: ACrzQf1vx+tei3R2UtbOaSVT7OyDAQyi0nOTN/sHslObv5dlRSP/u5wb
        crm4FzFTHG4PU0LuvFuzJL16IJiilAyRMqml0ZFwDTKcWB2CZC5OgChNSVp1ouIxqRtoERBjFnu
        iwKEkwpV7Xs037opMFpfM0eP+8HquE7yrD6HJq4ijWWkz9gO2atr06CC1Bs/MtN6igP0m
X-Google-Smtp-Source: AMsMyM5Bf83wvCosETZK9JQTWremeoMPMDbFYlfGOnjWw1Kib8VaX3LNyDOqhC1wb053fi0o/IyumY5/EjKbgqyT
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:6c06:0:b0:6b3:b370:44b5 with SMTP
 id h6-20020a256c06000000b006b3b37044b5mr17173112ybc.281.1663773332729; Wed,
 21 Sep 2022 08:15:32 -0700 (PDT)
Date:   Wed, 21 Sep 2022 15:15:22 +0000
In-Reply-To: <20220921151525.904162-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220921151525.904162-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921151525.904162-3-aaronlewis@google.com>
Subject: [PATCH v4 2/5] KVM: x86: Add a VALID_MASK for the MSR exit reason flags
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the mask KVM_MSR_EXIT_REASON_VALID_MASK for the MSR exit reason
flags.  This simplifies checks that validate these flags, and makes it
easier to introduce new flags in the future.

No functional change intended.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/x86.c       | 4 +---
 include/uapi/linux/kvm.h | 3 +++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..852614246825 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6182,9 +6182,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
 		r = -EINVAL;
-		if (cap->args[0] & ~(KVM_MSR_EXIT_REASON_INVAL |
-				     KVM_MSR_EXIT_REASON_UNKNOWN |
-				     KVM_MSR_EXIT_REASON_FILTER))
+		if (cap->args[0] & ~KVM_MSR_EXIT_REASON_VALID_MASK)
 			break;
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..44d476c3143a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -485,6 +485,9 @@ struct kvm_run {
 #define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
 #define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
 #define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+#define KVM_MSR_EXIT_REASON_VALID_MASK	(KVM_MSR_EXIT_REASON_INVAL   |	\
+					 KVM_MSR_EXIT_REASON_UNKNOWN |	\
+					 KVM_MSR_EXIT_REASON_FILTER)
 			__u32 reason; /* kernel -> user */
 			__u32 index; /* kernel -> user */
 			__u64 data; /* kernel <-> user */
-- 
2.37.3.968.ga6b4b080e4-goog

