Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7310517AED
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 01:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbiEBXmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 May 2022 19:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiEBXmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 May 2022 19:42:37 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB3E27CDC
        for <kvm@vger.kernel.org>; Mon,  2 May 2022 16:39:07 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id d64-20020a17090a6f4600b001da3937032fso365160pjk.5
        for <kvm@vger.kernel.org>; Mon, 02 May 2022 16:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=mpC3gngOJnTYNbZIy5XpBZE4tNfXvg4sSdGII/rINPg=;
        b=kwJzZU08zTMMYRTPGul44netZRFM/Fn7mp2jbTMXigZFZjwIWzKp7+vSa1nCB8qwgS
         kCbrRB58JNwK9MoOO12gCVsZ1DM+1nuUeA98O7urT8dIDnngCH704X7hz0NU8r1zvpat
         wcnNFYuTZ4XW1B6+wWWG43FqBL56s+0FTwQGVOOpie0v1F0ZphBbDiIoVstFw3HISQHo
         0SuqofRCG5wZcjFZVbOcarkCL/9CBE0/mqvaXhokdaQJppOXdi/iIR2L2gpYpyzsDj1h
         lL4DO4OXCo4BSRFALMwUYoqFOLGiQueq4HT8CsYDiYofE9GPbh6PvRZTzCBd8Ujzg0PD
         /Zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=mpC3gngOJnTYNbZIy5XpBZE4tNfXvg4sSdGII/rINPg=;
        b=fXdSAYM1pFpsxiR7yNHK2L5fhyRNeBJtZsYXwRn7AqHWNYDyAxXgZRlXWWpmNxYCGi
         ze+6JY2U7jFG3tEHSkm2hFZwVCKAF+gjyDjJZ8k4vv6TNmeBwGUYvDLV6HLOlKSBmUgA
         TF8TkM+mWVzd7FhXEA8d7EWw1002RwshVGQ7enu65dRV+icNbWBpG40oyoLMlMKKg2Kc
         oQgg9NFMCFIfvZQdTuxnBtx7MwgmLHT/g7n/RXPYa7H17PUAzVgeAuITdoD8atPCHo/d
         Mz/rExNCV3WwRtEZaK/xTmRrAL+ygbZtz9RUSXn5mtngr0CM4sxvsso+iZPWtpTNQ6kA
         rcbw==
X-Gm-Message-State: AOAM533YYmMOOPt5Htdbp1gs7i3FmS9p3KT+aJo9VhdGr2G4dsTPTXNm
        f6paocIevDtWTiCY8GflFCOJimHrQEWt
X-Google-Smtp-Source: ABdhPJyaZXXkFRI0DH02jQSgoTliFZw6c6KZBZFaTXiesw7Fo73NRrlthGbaEga6iWfIyzRxWO1La6dDWR5Z
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:d4d2:b0:15e:a9b0:3b21 with SMTP id
 o18-20020a170902d4d200b0015ea9b03b21mr5688864plg.142.1651534746776; Mon, 02
 May 2022 16:39:06 -0700 (PDT)
Date:   Mon,  2 May 2022 23:38:49 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-6-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Gavin Shan <gshan@redhat.com>
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

Since the doc also covers general hypercalls' details,
rather than just PSCI, and the fact that the bitmap firmware
registers' details will be added to this doc, rename the file
to a more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.36.0.464.gb9c8b46e94-goog

