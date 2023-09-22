Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B777AB634
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjIVQmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjIVQmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:42:49 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B310AA1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:42:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59e758d6236so34412077b3.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695400963; x=1696005763; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=H4eLjsCfwu3fm0a4rgJ9szHKh6uo1UIVw8FcAqngMH0=;
        b=kZ8eH83IO4M5e3pweqO6tDq4MHvmE3rO8xJvQuNNRbDMXBCH7xWcW1h+SL6klByHoZ
         5r14VBuLtyIl4WoW8xjSPxs9J9LSVcGxi6ItybssbcDzmqe+xes/o8RA28g6GQ3bsk1H
         iLHNEI2hXkU8CXjpZivs/rKKGpXm9FCrEgAu9AiPgrS7GIXrEsaynkGcHa+D0bLac1rk
         thpucRfaMzSi3ngXrN0U2I9a5oz7tmXw544SOQE6euOhX3/nOGgFv8Yu0ZZnXSfkIbXd
         6Mhs8DWgA5rCcQ46zrqKvDwHzATYWNYQ3nkMg3QPcXZwycfuwJXcQ7xPbX9LBPOgc9f5
         JHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695400963; x=1696005763;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H4eLjsCfwu3fm0a4rgJ9szHKh6uo1UIVw8FcAqngMH0=;
        b=onIbQQ1g9aATJlHF06pv0ej249lq7M3yhv9TkIKwSQnLYmbqyVrZ1Ts6kbuSHu3cDS
         sJnRM0P5X7BW/Xto09SBWlHc1daS6P6NwFFu02S0p9EObeRIbW40ipFUudxLBT+FoKBI
         UwHdg/B6UUKr/QYP83o82DqULLlkH6VooZ2vBcUhorPjqFHuUiTyx4UYcN3n/8406fgu
         Z+vG21K9g0UTWO6BY0cOFiUSIlYCAo2Bb75KMuPsxu4IwFFI9QMGTbSanWhc9lPwXSgl
         lc6B5uXiWjBWtqVh1My8lxHIMzD6iBBGpOsLZlzb2UKXJljzxViQBNvu4knmfEGdlH18
         XyAg==
X-Gm-Message-State: AOJu0YyZwKnALqXpwB2ihaXt2jja4IMz1iZ2/RTrJ4aSdpRoWD1oO0jc
        nwxPNbAcFT/xtrE5xi/Dh3016Z/IjvChsnl3SXBKxzqjvHzxQiyDLMOArJ/LUEthUKq7EM1hf5K
        m+GH7LtFqwMf1FWrvjOdHu5mekICX+JJtg2pxlyI/83aiP4dKYy1AYhrIw6ieYdg=
X-Google-Smtp-Source: AGHT+IHH85cz4KOc3dKsHsW7LZdUEe3sxzS8ZQ4Kiumre7k+tlzAWNpAu/D8XOaxBL3n4jlIQ2QGVS7DAl4fKw==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a81:ac21:0:b0:584:41a6:6cd8 with SMTP id
 k33-20020a81ac21000000b0058441a66cd8mr2983ywh.8.1695400962906; Fri, 22 Sep
 2023 09:42:42 -0700 (PDT)
Date:   Fri, 22 Sep 2023 09:42:37 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230922164239.2253604-1-jmattson@google.com>
Subject: [PATCH 1/3] KVM: x86: Allow HWCR.McStatusWrEn to be cleared once set
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
index 6c9c81e82e65..3421ed7fcee0 100644
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
2.42.0.515.g380fc7ccd1-goog

