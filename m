Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10A07B3CD9
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 01:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbjI2XC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 19:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjI2XC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 19:02:58 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B2E5
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d865f1447a2so19450321276.2
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696028575; x=1696633375; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b1N3hWIObrM3fuetz2htOwqrUuVS9pLtFCiKQQfrRbw=;
        b=PGJP2LhqSP3QAtxp9QqY7vi8Fx2msalupJ/gL6Tdl5sjgOJph7FXUV/ED2elBh8/ax
         f8wNnbB4SatdExgn3Ie3+PPZ702Krch6sHfl6fIWXeGiUMI9r1ioxPCtEU4rx+T0+ERI
         Rs6hw6bFm2iBCPZ7zTd1e4OnhYKDwtfePF9IyWoCuRRNfsTjk+U8kpUE6V9KTwwfHRic
         VbTU7aCpCcLI5eEDnAG4Ax4NhsdCSF+onIWWv7Bp7EzC66UYcIhGxegeBf4NlcTeSjyh
         O1DKONOrJyJApEOrSFa1NNxqg9CS4IK+VqG9mdvv0sjgMhIZE1oJ7lehKVJvSJF9pFH7
         DsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696028575; x=1696633375;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1N3hWIObrM3fuetz2htOwqrUuVS9pLtFCiKQQfrRbw=;
        b=pOy2M/SLDppnaRz92t0KShLFl24KRkT1WIqNmZeQrKZLkLGJHUTP8h/sqNqCLF61Ry
         q/UMh2oC3bs4xTkJU1mL9524D7dJJBmIwbWZDzY9TishTJc2J35+8YesuJD+tKo6+kWI
         cDl42OHyfyGPdQUDAtQfFCvN1cLicZlNGz3NmNpRfs5q5w0yJyKm2nQ9aWD9NcGa6ynH
         cSbZegeTkM9V+d/2GTRwH/W3Y04/bD84Ag/l8I8v4FS5DQiUw16Lg+TN1CbZqGNxqM2O
         J2dBlIw7VuSJcuEgc2+ivpcnc5lJ/81xDoPxIXJEavB9KaicZ1ZdOaZkMkiftbEcS98E
         rU3w==
X-Gm-Message-State: AOJu0YzeqTjSkSO79qt5fQLKGfsTZWn2L6pz+t8ppHF5GRYlSJmVkyl+
        dRZodwmMu61nL6V2oyNiwN+qx+7cw39lyMUYej0drmFI/N0vOLjM+EGqGRAJqQ3eFsa5kivI2xv
        PfNWux/8Xd0Y9T0igJTZU3hOxxyG02a6mBSz9dYfyYP9xEJX7X8dxH6c3nQaAWI8=
X-Google-Smtp-Source: AGHT+IG7gno1SzVapuhxDgTmDt+C92bvzrQXHG9yeNYZGGTmk2ROkx7/JlZM7Pe+hyG0+exoxWLWbxYbWLgO2g==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a25:ae84:0:b0:d0c:c83b:94ed with SMTP id
 b4-20020a25ae84000000b00d0cc83b94edmr81222ybj.10.1696028575420; Fri, 29 Sep
 2023 16:02:55 -0700 (PDT)
Date:   Fri, 29 Sep 2023 16:02:45 -0700
In-Reply-To: <20230929230246.1954854-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230929230246.1954854-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230929230246.1954854-3-jmattson@google.com>
Subject: [PATCH v4 2/3] KVM: x86: Virtualize HWCR.TscFreqSel[bit 24]
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, "'Sean Christopherson '" <seanjc@google.com>,
        "'Paolo Bonzini '" <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On certain CPUs, Linux guests expect HWCR.TscFreqSel[bit 24] to be
set. If it isn't set, they complain:
	[Firmware Bug]: TSC doesn't count with P0 frequency!

Allow userspace to set this bit in the virtual HWCR to eliminate the
above complaint.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1a323cae219c..86a1bb0e6227 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3700,8 +3700,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x100;	/* ignore ignne emulation enable */
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
-		/* Handle McStatusWrEn */
-		if (data & ~BIT_ULL(18)) {
+		/*
+		 * Allow McStatusWrEn and TscFreqSel. (Linux guests from v3.2
+		 * through at least v6.6 whine if TscFreqSel is clear,
+		 * depending on F/M/S.
+		 */
+		if (data & ~(BIT_ULL(18) | BIT_ULL(24))) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
-- 
2.42.0.582.g8ccd20d70d-goog

