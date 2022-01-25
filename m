Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAA249B155
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 11:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240667AbiAYKFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 05:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238629AbiAYKAG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 05:00:06 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EDEC061768;
        Tue, 25 Jan 2022 02:00:04 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z5so4853747plg.8;
        Tue, 25 Jan 2022 02:00:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+9/h4WgwvINM2uXFYzps/DVN0t3qraH1rjLtTgc8ipg=;
        b=BY1Kpc6uzILlB69ntbdcG2NpCbHQ8Kgd1/1Li8Tju2eMKDY9dOYABLBX/ZV+gNSB4x
         HKQJ9oDd0SWF0AGc9y99lvHQYi1aKBZUxPtjknshvOzJpm8gnILRuU4pwvel550nWeQz
         5iRbxJfwOvnPPAejDvi/6WSyjS5KlAq2lnrFu+vqvmn9Iy6dYAFq/uWO1LA71qjEY5oe
         zdSQZId+y8KwX+VtkbC7XsUzfJ8DfMd1+NtknroUpNHq79pEYBUHqw0shUV7skIXIF8y
         sF2lPJNBbYgDDzh6yGDM2gepbiOcr0OaSV+5+jn1bdNr5lTNHNpA92Ihrdj1qO1MSUp6
         D1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+9/h4WgwvINM2uXFYzps/DVN0t3qraH1rjLtTgc8ipg=;
        b=Kr+rEoo3hR2Ft1viIC8mRlBAsR7C/NX2q1R6bdCMelumw8T7YOSrZP0twuwM9LXkYe
         izbihSOk11RRKNUmv124csJj5wxlRVl9PE84HlmNz+9DOcvIWoAWzmtRx2LgWjLC5y2w
         +Op8JeLHeO02ychT+ZBNbh7XuOMY6ULth9CTE8Bhfxc78ZDzLVZzuTS+bWYsibhvq/pm
         z/le88QZlh64PazknsxrHhTQnuUMT6Agmgw38BCvnrQfuCQN63o8XFb1yG106GmAmdnM
         yDdCMwj6lMLKmvAMb+JCzD/4Jr3SG5W48CmKXSOiRRVuIOYhFiH6EMy0BPgsAGmGQQxH
         z/Fw==
X-Gm-Message-State: AOAM533DA1OFUDVmNYgjqD6iwX2kchs4P20qIwENgBcDujKm1uCN4lWJ
        4WaUB7goHi8SoJM+kHrq0oI=
X-Google-Smtp-Source: ABdhPJx9dQJt1f7yFLZ5RvUiloClMf6N9IKzWq88HkQ/mZTjsAYfIya8rtD+02X0/9THQWaQx6g2cQ==
X-Received: by 2002:a17:90a:5d8c:: with SMTP id t12mr2601800pji.189.1643104803775;
        Tue, 25 Jan 2022 02:00:03 -0800 (PST)
Received: from CLOUDLIANG-MB0.tencent.com ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id mq3sm201606pjb.4.2022.01.25.02.00.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 02:00:03 -0800 (PST)
From:   Jinrong Liang <ljr.kernel@gmail.com>
X-Google-Original-From: Jinrong Liang <cloudliang@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Xianting Tian <xianting.tian@linux.alibaba.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/19] KVM: Remove unused "flags" of kvm_pv_kick_cpu_op()
Date:   Tue, 25 Jan 2022 17:59:09 +0800
Message-Id: <20220125095909.38122-20-cloudliang@tencent.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20220125095909.38122-1-cloudliang@tencent.com>
References: <20220125095909.38122-1-cloudliang@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jinrong Liang <cloudliang@tencent.com>

The "unsigned long flags" parameter of  kvm_pv_kick_cpu_op() is not used,
so remove it. No functional change intended.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e438e009ba9..acd34adc097f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8940,7 +8940,7 @@ static int kvm_pv_clock_pairing(struct kvm_vcpu *vcpu, gpa_t paddr,
  *
  * @apicid - apicid of vcpu to be kicked.
  */
-static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
+static void kvm_pv_kick_cpu_op(struct kvm *kvm, int apicid)
 {
 	struct kvm_lapic_irq lapic_irq;
 
@@ -9059,7 +9059,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_UNHALT))
 			break;
 
-		kvm_pv_kick_cpu_op(vcpu->kvm, a0, a1);
+		kvm_pv_kick_cpu_op(vcpu->kvm, a1);
 		kvm_sched_yield(vcpu, a1);
 		ret = 0;
 		break;
-- 
2.33.1

