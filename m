Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7458C57E844
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 22:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233195AbiGVUXP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 16:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236185AbiGVUXN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 16:23:13 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB77BAF86D
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:12 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id q40-20020a17090a17ab00b001f2103a43d9so2588897pja.6
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 13:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uFFomE9McIhxEaakq3AcdFJVoCHJYlFtlPzmQhcfNTI=;
        b=OEQwJJK5ut/BwgDd33BHk9sk+gFmpxH1/X9O3THrQ1peZvNqCRQbAxvYgg0QEnqizk
         e70UXYyNk2fl7XbLYC/7MgCX2I4JN8dyOtFjlMOpbIb9D71tiNndAFN2o3JXuhENH8x6
         dIl6LLtpTiM/ak01DiNsxCEn2CD26rFuZfNm0xNxCuJmCzBXTMigN+dSItqb9aMt33ns
         53FFjcuJI1Qhkp8PbzKf8TIjVmFbLOxHxXoll90v2dpXPoHVqW5/9Cpc51w7rY8Y8aDT
         uTMWmlnKYR3eqsNtWbHQPQVps8mH35nigOgH9iKRdMh5ct4339QED/yeO5lLBSDV8WRB
         MfVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uFFomE9McIhxEaakq3AcdFJVoCHJYlFtlPzmQhcfNTI=;
        b=27gzoCOe003d0wr/7h3bkiTb9t/q1Qy5drzrOiFvKCDZsG3ym3tVBkIScUkBaWncrG
         Zoks7Y/DsN5xoGN8r8CXdXWQSwofxg7vxZfU/uPKoW4IZp/XTUPGX1YkRmbNdELw7Qg/
         8xf+KfsbSg1Ph9HRRqbUifCUWbGwlZPvXr9yarBHfazxKSMupuEmck2TgNhadyrxsQjp
         zFGrOoWueHVSZ3V8CxIAQ5D7LZ47QeaS/RW0RDLVuYdgZKx6OUECL08FgyYWoCydZP+h
         ZHkt9H6BqaMm0b6F2tfpnrD4p2uuCJU3p7zcGQWpeYtT3KJx7wB4cBUYaNSoDZsiRpcM
         dVdg==
X-Gm-Message-State: AJIora/INzLENhWoT0q3yIb7G2099hrHJIW80g+gdgmHzTnl5HvEnOET
        Vzd1VRcAx1gRzntsSzXyrWH5fjYPGU780XKDI95g5wDOPONii6CYptqywUrX7NN1gZSDsACLng/
        WqbhLiT1jqQorBxVG19NxPz3S0WpHM6+zqc9EAZXNo/JO4guir+bQwJ5bS7ehn48Bi9Xm
X-Google-Smtp-Source: AGRyM1txnq64zwd2wko4ScD9CIyfL0QMjTgy5t/r1IHemhPYUjjs4wy3k/8h+DwHAb7n3OL8voKH4xSzGmG5lQm5
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:2644:b0:16d:1f61:399e with SMTP
 id je4-20020a170903264400b0016d1f61399emr1547183plb.38.1658521392202; Fri, 22
 Jul 2022 13:23:12 -0700 (PDT)
Date:   Fri, 22 Jul 2022 20:23:00 +0000
In-Reply-To: <20220722202303.391709-1-aaronlewis@google.com>
Message-Id: <20220722202303.391709-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220722202303.391709-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v3 1/4] KVM: x86: Do not allow use of the MSR filter allow
 flag in the kernel
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

Protect the kernel from using the flag KVM_MSR_FILTER_DEFAULT_ALLOW.
Its value is 0, and using it incorrectly could have unintended
consequences. E.g. prevent someone in the kernel from writing something
like this.

if (filter.flags & KVM_MSR_FILTER_DEFAULT_ALLOW)
        <allow the MSR>

and getting confused when it doesn't work.

It would be more ideal to remove this flag altogether, but userspace
may already be using it, so protecting the kernel is all that can
reasonably be done at this point.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

Google's VMM is already using this flag, so we *know* that dropping the
flag entirely will break userspace.  All we can do at this point is
prevent the kernel from using it.

 arch/x86/include/uapi/asm/kvm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ee3896416c68..e6dd76c94d47 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -222,7 +222,9 @@ struct kvm_msr_filter_range {
 
 #define KVM_MSR_FILTER_MAX_RANGES 16
 struct kvm_msr_filter {
+#ifndef __KERNEL__
 #define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#endif
 #define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
 	__u32 flags;
 	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
-- 
2.37.1.359.gd136c6c3e2-goog

