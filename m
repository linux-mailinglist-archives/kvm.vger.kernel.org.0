Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A717B3CD8
	for <lists+kvm@lfdr.de>; Sat, 30 Sep 2023 01:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbjI2XC5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 19:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjI2XC4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 19:02:56 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F1FDD
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:53 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d865f1447a2so19450301276.2
        for <kvm@vger.kernel.org>; Fri, 29 Sep 2023 16:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696028573; x=1696633373; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4qxiUgymJbSqYVSjVnDwaQ0NwklGc/ZL8ErYIOq5iH8=;
        b=XoCZ12ekoRJC6sxsKYUoywHrWeVEhC3EEfkqK+W+ApHVl9Z1uREcw9X86uVALXmaLB
         BN6DuLdB88HNAPPa1ZQTLCdF83NSXsXJdKxHn0P+cMNePzwCWAHDXCEuqf/SbQlh16zL
         obG2B5KG4eYfc4CckATqJPY2BwuShT067n+Gpj1cEsMRHmM9inFgPWpfOKfAvi9tQhUM
         b0mGjP3rMwkCaaKYmxckqoCdxfDpG1wcRwQ0U+piwF0F4u+YrkzMCf534rgGVynIGBcI
         OYzu9ZaG7KccSWdOD5GQkyzhUEGPNI12pLBOaSmGNtTWAYXzF1HcVVrWEjFOD5g7xlMI
         Ve8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696028573; x=1696633373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4qxiUgymJbSqYVSjVnDwaQ0NwklGc/ZL8ErYIOq5iH8=;
        b=EpZHFgdPDfMhTqv+Sv4tBgwnOGNn1wH2xkAgYdL9A4J4ajbqLl4sSEBALAP9SIOwXL
         pAM4ctByjyUxOsxeoKL9wxDUcaeEfRbKeWS9+1zsHI6oVBWoEgQKQ2ZQ8HlKl3EcyIzy
         OaoLMS665iyiFhmurUwjqLTFW9rB0F7TEOSuqDJnziH1+RnULZ281c9L+B+c4h8zIR/V
         bc1agCeCCRe7coCtSygbJ4d/2CPvec5Bv/rZVGilGBPWIS1SYI/yVj7afW7k7cBdqO5b
         ZSMwXIDYd4p7rX4PttxGgv1qimIXqNd9ZMfty/wQFvwiA6GJ4EaAzFGwQBgIoZZjmXex
         3l+A==
X-Gm-Message-State: AOJu0Yycv0EIbCMY3RkAUrOalXpJpHgzTOpijxt1azKVexCVnazROIaf
        2GqTDW5NXw3rSJYoxJ93rHKacyzv2wSJ4Tq0sK03BZ4O+qDSs4v38wT4yAuKPgr6qWevOUaq2wH
        /gYMklucDQkPKXnq/lAxKKjbk6ws9rVVWZ2jYs4v/vdmcQEiL4wkxvF5oq4rUIiQ=
X-Google-Smtp-Source: AGHT+IGPF5ryTOZBlbr9GFfNA/E6HIFoGMe5kjaqZhLS2gXREcMuYtnS4Gt5eGGZvXNvz60SMKz4CZEqzlGJQA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a05:6902:181c:b0:d7f:8e0a:4b3f with SMTP
 id cf28-20020a056902181c00b00d7f8e0a4b3fmr91409ybb.3.1696028573121; Fri, 29
 Sep 2023 16:02:53 -0700 (PDT)
Date:   Fri, 29 Sep 2023 16:02:44 -0700
In-Reply-To: <20230929230246.1954854-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230929230246.1954854-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <20230929230246.1954854-2-jmattson@google.com>
Subject: [PATCH v4 1/3] KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
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

When HWCR is set to 0, store 0 in vcpu->arch.msr_hwcr.

Fixes: 191c8137a939 ("x86/kvm: Implement HWCR support")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..1a323cae219c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3701,12 +3701,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~(u64)0x8;	/* ignore TLB cache disable */
 
 		/* Handle McStatusWrEn */
-		if (data == BIT_ULL(18)) {
-			vcpu->arch.msr_hwcr = data;
-		} else if (data != 0) {
+		if (data & ~BIT_ULL(18)) {
 			kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 			return 1;
 		}
+		vcpu->arch.msr_hwcr = data;
 		break;
 	case MSR_FAM10H_MMIO_CONF_BASE:
 		if (data != 0) {
-- 
2.42.0.582.g8ccd20d70d-goog

