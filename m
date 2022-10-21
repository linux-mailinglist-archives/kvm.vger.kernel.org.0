Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19924608045
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiJUUv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJUUvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:18 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BC81EF06F
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-367c2e72a6dso39935017b3.1
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uk4BW0JD1RYXAeT0Rcp18HTfg5VEFzTrzuBnkS8/VcA=;
        b=XlXcV9L70nwuY6MeU2S9T6iMXVjR5L4sssENmTKeCsnqgUEqO3/0wAVhYVUXkGPh2S
         ultmNB5ixSkKNDuiHAcetS3xTRTLCvTZQs5f1g6nEum5Rxi63IgmZMjKdpnf9VKAnsnZ
         XWQituwGiR7hqDgZGZrSu3MrZEtpOo2hM+ZSKxidBzvsx3Bt65lojZpivuWMQF9iMU4o
         cnReSIuJTxsQcCXy/B74Mf0TkLdh2L7WUnF4GTGiyBJKrGYlizo0WRnuLYK83v29XtVM
         1fJxpONNDpJnc1tb7PP9KkZhxyTXIp1bcVcg+/T9rjcYObtZGcGye1n5ycdT1FOV9far
         IJHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uk4BW0JD1RYXAeT0Rcp18HTfg5VEFzTrzuBnkS8/VcA=;
        b=z8R4jSo8XHotuAF8g8QHVN8F5Y9bzCJ3xUOSpcDTapnOZNm4vcXw/RPmPtNlJ+N8YG
         PYd/E9wnqFWCByniXtQBA7Rv8hZainn9Ezs+78COlqADI+OP9A69dnZwPf8Z7lp/GsuT
         /5mDtJi9TR8NkDD2t/5LRXK7MJWZT51qrVQ6PpcJDzJ1bwHjm/MocHOla3gj1Sowlj3m
         duTMRYSVodgtRLDmLMNrepdbqNXCAllZVT9mGVDzoT7xaKFcwCmZapMakfb1eN8OIsRT
         Dbw2cpqa38LGXFRAUWp0dw5dmoFI3pQtu+iEQimQkg7piL6dxUcn0+FJK18FvwGFtXyj
         wzvQ==
X-Gm-Message-State: ACrzQf13DomDAY1nJZWLMLp630p2eZZb+pt9NuPSUDXgZ6gKON0zlbLv
        QvJR2bcJQjRSwQF0K2lVQbhGC9jEfGuyKM/2cZ7LOhRoZNvAF4UNicSR9yrmLsWZw2ejxbwXnWo
        416liRZo6RWXeMMYcDp3YK/ZXHT0RcEMTnr0UsfOsCHrSSZQlQBsV7PiWJUt+p4kAkjIv
X-Google-Smtp-Source: AMsMyM6ExarsiJYUryPh3yKjb9DOmjCqvDtB59QVOEAxnU3OCToehTcLHE/XJSRWJNEAvLWmQh55oyTdd2MJb+D9
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a25:22d4:0:b0:6c3:6ec7:3dc9 with SMTP
 id i203-20020a2522d4000000b006c36ec73dc9mr17932507ybi.520.1666385476775; Fri,
 21 Oct 2022 13:51:16 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:50:59 +0000
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-2-aaronlewis@google.com>
Subject: [PATCH v6 1/7] kvm: x86/pmu: Correct the mask used in a pmu event
 filter lookup
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

When checking if a pmu event the guest is attempting to program should
be filtered, only consider the event select + unit mask in that
decision. Use an architecture specific mask to mask out all other bits,
including bits 35:32 on Intel.  Those bits are not part of the event
select and should not be considered in that decision.

Fixes: 66bb8a065f5a ("KVM: x86: PMU Event Filter")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c           | 3 ++-
 arch/x86/kvm/pmu.h           | 2 ++
 arch/x86/kvm/svm/pmu.c       | 1 +
 arch/x86/kvm/vmx/pmu_intel.c | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d9b9a0f0db17..f1615aed2edb 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -273,7 +273,8 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 		goto out;
 
 	if (pmc_is_gp(pmc)) {
-		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
+		key = pmc->eventsel & (kvm_pmu_ops.EVENTSEL_EVENT |
+				       ARCH_PERFMON_EVENTSEL_UMASK);
 		if (bsearch(&key, filter->events, filter->nevents,
 			    sizeof(__u64), cmp_u64))
 			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..aa1799b1562a 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -40,6 +40,8 @@ struct kvm_pmu_ops {
 	void (*reset)(struct kvm_vcpu *vcpu);
 	void (*deliver_pmi)(struct kvm_vcpu *vcpu);
 	void (*cleanup)(struct kvm_vcpu *vcpu);
+
+	const u64 EVENTSEL_EVENT;
 };
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b68956299fa8..8af8f4d0336c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -228,4 +228,5 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.refresh = amd_pmu_refresh,
 	.init = amd_pmu_init,
 	.reset = amd_pmu_reset,
+	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 };
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 25b70a85bef5..57d006410ae4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -811,4 +811,5 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.reset = intel_pmu_reset,
 	.deliver_pmi = intel_pmu_deliver_pmi,
 	.cleanup = intel_pmu_cleanup,
+	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 };
-- 
2.38.0.135.g90850a2211-goog

