Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7451653D469
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350465AbiFDBY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350388AbiFDBYK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:24:10 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B48313B6
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:22:27 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so4106877plg.15
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JhO3Pfqpfwvl6Pg5WoaBIuDDbRoUFFPm/3/rKP0GHj0=;
        b=Ewgk0zIl2X4eFMXV19jbpEsGXZP6HUvKFsmTBBQURf4xxkDLnN3y+nfGhL8TD5/HUm
         Z9kQt98CuGzfgi0a52OIbLPgGgaZRKA4UdBv2Z/wpLG0/IapWCZwvP+O7qYR0QtHiVsr
         z7WYayl9SH5XEg9H08w+ffaOlTTG4acKKbVF+vQFcS9ITPDPWJ/k9o8CPS1N3oTe/NtN
         ns80BNtrZ4ZZ4jgyB43xntta8rLLHJnN3DftjSIvxTvnrJJxyZEalysDaneEUG/xN1fe
         MBEvRkLJTrW/bHL5G7Gqb4dapyfW9j+ivFUsPKPVzm8HBVWMdw5+8ORfLlHwEMXQBL+D
         IrZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JhO3Pfqpfwvl6Pg5WoaBIuDDbRoUFFPm/3/rKP0GHj0=;
        b=s8/IVaCanBAKTEmyJGup+wuDJfRu1gUWp6Q8YZmHIpX2KdwK4IeU3TAFTEGi4RAfzS
         VSiq+7HjUYoo/dIqfmLmEC7elygFit2qO7crz7VOtldDERDplMw63jakeU0OGBHLt93K
         uW9Ra5646iU9SVtxa3w7jI5bfnrBSBtDKU95+8u+xCW02fgqUmr/GJBA58Ku58i/7dLM
         T3vvH9hFu0w9pbzgBxDVcqMjkA+zchKJzj9hQEo5/Q8ww48rmDg1G2yFJkRNAzGL8q2U
         /z6ZNsLxbuVO5LtxCohevrTPHXTVduK0Bcot0JUXprxH8W4/kuiUc32ckI8wqZ5qiORv
         Lqeg==
X-Gm-Message-State: AOAM533BNtkY3Vggwam8LOCkr15By72jDoj+uKYIRzbjdc+7YXYQ7cGn
        lbtomBwpkHtnvG5B55wA0NxAixjMSP0=
X-Google-Smtp-Source: ABdhPJxS2lZ7pIC8pnehjqv4quML9zflFji8IUQ+8TSateGizJ9gQSh2GlujdB+K0SgqNrmR1qE6j/TO4Gw=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:a517:b0:161:e5f2:9a26 with SMTP id
 s23-20020a170902a51700b00161e5f29a26mr12797900plq.132.1654305734883; Fri, 03
 Jun 2022 18:22:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:58 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-43-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 42/42] KVM: selftests: Drop unused SVM_CPUID_FUNC macro
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop SVM_CPUID_FUNC to reduce the probability of tests open coding CPUID
checks instead of using kvm_cpu_has() or this_cpu_has().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/svm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm.h b/tools/testing/selftests/kvm/include/x86_64/svm.h
index 2225e5077350..c8343ff84f7f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm.h
@@ -218,8 +218,6 @@ struct __attribute__ ((__packed__)) vmcb {
 	struct vmcb_save_area save;
 };
 
-#define SVM_CPUID_FUNC 0x8000000a
-
 #define SVM_VM_CR_SVM_DISABLE 4
 
 #define SVM_SELECTOR_S_SHIFT 4
-- 
2.36.1.255.ge46751e96f-goog

