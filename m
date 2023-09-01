Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F468790249
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 20:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349050AbjIAS5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 14:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345183AbjIAS5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 14:57:20 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB0EE56
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 11:57:16 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b88decb2a9so3204805ad.0
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 11:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693594636; x=1694199436; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UTtQ2n9VcqGq8vgh9w64aDfJyyICRpGgD1PyNdDzmPc=;
        b=tV+tCDtFjP19VpIMqqU8wR91VFBObR5+7LYbPD2aACjy5p2OC2Hw/7Axlc2eha5VHr
         rpD/38AccAIPzooW9uJZ0eGn3W0FBjKfyjPXrmsw2vaoIoirakb1plgPPrnOvdF7TjiV
         5xRGLVanG0Vk6dn0FHTLgyWJHxz81diaXkHNl6xHQjGU3PjgnFuyTT1F+sTFek++6/Tw
         BZxnCsk3TcV8aiyjYe0TC0C46ZZX9weEqqJQcgCAOybVbH2bZ6tbIdhHd92pRY4209AJ
         1kBaagEQGAnEoFnuBSnqZZZBDuIAEEvD40mhKVo1ggww47fKrZAi3IWhWqrj84gF1iWJ
         ZIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693594636; x=1694199436;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UTtQ2n9VcqGq8vgh9w64aDfJyyICRpGgD1PyNdDzmPc=;
        b=jaOn1XFz+RaeZo4qoOYV2pqBBMMHAQOZv09ysAWvxs/Yxgvjo+oq/DuKKb07cME7EJ
         AJTVGpMPJqSbuczswZZSvrE8rjvZhpFuyR6/Su+PhaO7xdLS8zOwt76kLo2ncwO4CQWv
         ZWs74lofV7jJvOBOmU/Ol46L+3b0yopJfpqXLD9zcT+a5PkRC5upor36deXG1+ea1jNX
         1+eT70B4Ln1czVMxvomRfSct/bfv2AvseG36ZehiDX2VySB1teqFkTMmoE+eHuBrJue6
         BuNf8k6OXXD0UqifkCWnZ9ButstKKM+SD1wGzY1zl8bX6kQhYoQZ+SZnweYyG3xhDOYq
         uHLQ==
X-Gm-Message-State: AOJu0YxKU2qbZAc1Bgbu3Tvju48TqAsFjy0ankD88jHKA97CxaBJ5VGX
        vyhaEQboRQZ3E80uXiSwQAyWBgxkUONLrrqobHcZVK0IUWuABvURGuiijMByVso9dZStGbWgwHQ
        sW0DxpGCnnEr70kAd3O1DxAFnC+qPGZ3KvW2U8FTauZqnsz92bz34s/QU4a8qQP4=
X-Google-Smtp-Source: AGHT+IFUFV5okVGqEGNyhdxRjhAZ9iywAihYO9xACtTXPYC0YkPvISZqyZAMxXSFmqpgqMSPLw8oyGUgWzZfRA==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:ce91:b0:1bb:ad19:6b77 with SMTP
 id f17-20020a170902ce9100b001bbad196b77mr1115240plg.2.1693594635978; Fri, 01
 Sep 2023 11:57:15 -0700 (PDT)
Date:   Fri,  1 Sep 2023 11:56:46 -0700
In-Reply-To: <20230901185646.2823254-1-jmattson@google.com>
Mime-Version: 1.0
References: <20230901185646.2823254-1-jmattson@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901185646.2823254-2-jmattson@google.com>
Subject: [PATCH 2/2] KVM: x86: Mask LVTPC when handling a PMI
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <likexu@tencent.com>, Mingwei Zhang <mizhang@google.com>,
        Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>
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

Per the SDM, "When the local APIC handles a performance-monitoring
counters interrupt, it automatically sets the mask flag in the LVT
performance counter register."

Add this behavior to KVM's local APIC emulation, to reduce the
incidence of "dazed and confused" spurious NMI warnings in Linux
guests (at least, those that use a PMI handler with "late_ack").

Fixes: 23930f9521c9 ("KVM: x86: Enable NMI Watchdog via in-kernel PIT source")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/lapic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index a983a16163b1..1a79ec54ae1e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2743,6 +2743,8 @@ int kvm_apic_local_deliver(struct kvm_lapic *apic, int lvt_type)
 		vector = reg & APIC_VECTOR_MASK;
 		mode = reg & APIC_MODE_MASK;
 		trig_mode = reg & APIC_LVT_LEVEL_TRIGGER;
+		if (lvt_type == APIC_LVTPC)
+			kvm_lapic_set_reg(apic, lvt_type, reg | APIC_LVT_MASKED);
 		return __apic_accept_irq(apic, mode, vector, 1, trig_mode,
 					NULL);
 	}
-- 
2.42.0.283.g2d96d420d3-goog

