Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC819521FEC
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346514AbiEJPwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347249AbiEJPwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:52:08 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEC225294;
        Tue, 10 May 2022 08:48:10 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id hf18so13860148qtb.0;
        Tue, 10 May 2022 08:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X3BNtoB4/F6niqoFfX4fx2Osn5fqWuTD5b1GlgfZFp8=;
        b=EabF1/L+wbkUd27VSF3/tF7Hgi1fgBopaHKNIvv3dj7doyy+kNYd+Am9ZenQfeE7MZ
         ez5LqgKnknGkr1X29oqKKeG5hO/HuqrPteNcfsqyla7aPBl8/XkUB4lOzZQPPxZ9ldyG
         mQP7YlICvUFB2oeF73toiOU/LxGQFPnJbQQckBNiTyWwxgz6DQ8o3cweqAQps+n5cG5I
         Nxy/HGqtH5Rk6LIj+b4gHe/FBUpavd3d0H2rir/Wgs1k+DoVD+5hBQ/c3R9wdySzZFHl
         egkJYRJqH2fWH+/EPULpjEqfOGIyjVTmZUZ7eBjLK5HvO4C3OnuWrT1+Q9W/Eq3pvkT0
         czXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X3BNtoB4/F6niqoFfX4fx2Osn5fqWuTD5b1GlgfZFp8=;
        b=Bzeqr8gqp6LUW5mMG0pxczxUPSvgD9Hm6tpsr/i++wpaSGRApvKGVEDdC7uzFSwNpU
         gziTdTjiXwX8THXjJPs/ENqwdiMaVRMUNNrypTsWoRKgwWzM4UVLR1/t+CtmpkgAyfyQ
         rIhhw36xFKXOC71NK55CbJCNKg929DR2Q+DQsSThqB/B96B1RiRVS+YWItsT/WWwxg0s
         YiQEOgmMMzVWJ60HQ6MuO0PxbhVar6ekygvdDCcIk6Bf0Q88qKRAzUeSpiAz3asHEiZ6
         lcmAKatjWqtLwd/44sYlnOVpEyMYyl7ztMHR+jOZKSlPzjrHwqN+mcLnKComR1Blr1bC
         iKsA==
X-Gm-Message-State: AOAM532zQv2Qh4UvwO+douzBu4wP5FI/Ti1wNLr+Shvqkdqv/YmFJ4pi
        qeFj9BVjMOq7Xn4v2jHNEZ4=
X-Google-Smtp-Source: ABdhPJyRW2QB7yHYRodyUu35HiFlfKOXN/E+mTqJPQVZwWYac/HVRljaueGzRFfeuCppzBfOZdhAEA==
X-Received: by 2002:a05:622a:64d:b0:2f3:e942:be29 with SMTP id a13-20020a05622a064d00b002f3e942be29mr2156043qtb.390.1652197689818;
        Tue, 10 May 2022 08:48:09 -0700 (PDT)
Received: from localhost ([98.242.65.84])
        by smtp.gmail.com with ESMTPSA id a36-20020a05620a43a400b0069fc13ce212sm8677904qkp.67.2022.05.10.08.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:48:09 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Nicholas Piggin <npiggin@gmail.com>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matti Vaittinen <Matti.Vaittinen@fi.rohmeurope.com>,
        linux-kernel@vger.kernel.org
Cc:     Yury Norov <yury.norov@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH 11/22] KVM: x86: hyper-v: replace bitmap_weight() with hweight64()
Date:   Tue, 10 May 2022 08:47:39 -0700
Message-Id: <20220510154750.212913-12-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220510154750.212913-1-yury.norov@gmail.com>
References: <20220510154750.212913-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_hv_flush_tlb() applies bitmap API to a u64 variable valid_bank_mask.
Since valid_bank_mask has a fixed size, we can use hweight64() and avoid
excessive bloating.

CC: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Ingo Molnar <mingo@redhat.com>
CC: Jim Mattson <jmattson@google.com>
CC: Joerg Roedel <joro@8bytes.org>
CC: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: Wanpeng Li <wanpengli@tencent.com>
CC: kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org
CC: x86@kernel.org
Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 arch/x86/kvm/hyperv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 41585f0edf1e..b652b856df2b 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1855,7 +1855,7 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		all_cpus = flush_ex.hv_vp_set.format !=
 			HV_GENERIC_SET_SPARSE_4K;
 
-		if (hc->var_cnt != bitmap_weight((unsigned long *)&valid_bank_mask, 64))
+		if (hc->var_cnt != hweight64(valid_bank_mask))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 		if (all_cpus)
@@ -1956,7 +1956,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
 		valid_bank_mask = send_ipi_ex.vp_set.valid_bank_mask;
 		all_cpus = send_ipi_ex.vp_set.format == HV_GENERIC_SET_ALL;
 
-		if (hc->var_cnt != bitmap_weight(&valid_bank_mask, 64))
+		if (hc->var_cnt != hweight64(valid_bank_mask))
 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
 
 		if (all_cpus)
-- 
2.32.0

