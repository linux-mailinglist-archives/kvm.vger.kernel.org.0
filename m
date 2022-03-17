Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EF44DBBF0
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343725AbiCQA6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 20:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354962AbiCQA55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 20:57:57 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94BC1A3A4
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 17:56:42 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j1-20020a170903028100b0014b1f9e0068so1952701plr.8
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 17:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Jg9GQhk+MrZN5dXhW+X4cf0jKpd+avRpNX7anKj5Jrc=;
        b=m89l2hQAmUEdjNqV8OSCTfysZ/zOOwEFynaTXmVlR6Yzoo1Tx/dZoxyW6lOexx8+fq
         QUzXN6cI+cdNXN/EtWPD+f16r6B89XHPNUsNz4fxE70ESglpMWEl6bUWyJCBhYEsbYQb
         zxe9PXL1GLkt1QJJ4VG3Ie8JbNi3IGFnlkc9yRNI//242WCP8SA6wjBDbrK8gWrpduTZ
         OgvfmcZOxe567V08fuXZiraQk4SlFSiORjD6r1LqMp6mzhggpxoeD7hT2Yyyvo9M0k6l
         sMc8dnS9btYLpIWRh7ECmbtm7cyooPtA7nCYio+MoLGW2LDuWd26q4maprX8HLyqA1fe
         Ne/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Jg9GQhk+MrZN5dXhW+X4cf0jKpd+avRpNX7anKj5Jrc=;
        b=w82m0X5D05pjCqZ/uNVwZH0mKh8zazYB7kjFYmxlmIBHQTmQb/qo8VzX71FkAx4MlY
         MHl+duKhjfmBIqOJjo9sC6uLmHt8sw+oEoJPzcH46krLB2NcBbYI/5hX0aI6wtsI4yd/
         7h6at5zuY0Ol1p+HZupedQZoSrGvioG4SjNoeGn2o8+j8Up5MY6hxF06mV3asNZGweQp
         jLA/Mvh6jimuPu89BlBN91NH2eNB05J8jJ/atVSxug93lH++BKMSzvh1Th4NjVHaFVl/
         cTC2H1PUxFWJjiIjK4EqXSXeN4GbbCOvaY+OnftJ0HrJi+wKq4LDxEMlh+uFnGfucG4t
         adRw==
X-Gm-Message-State: AOAM532+bdjC2tiRB2jkSvhBvEVyuExoKX//VnhWoZBnehw+8Hb+QI8l
        JlDGq9NazsB0k7mnly5OonzaEu0AYDJQZtp4+v9cXqXRNIus/gmSavoRgmEAplrIqwZqvGav7Yc
        WWgbUePZbuoG84a1m6GMyDzqlX5xU0Rk1JZTZnJgfJo587/9gpbOftp9iwM4SBCZyRcBGXWI=
X-Google-Smtp-Source: ABdhPJwHRN519VOfnvRnJr+eDRdY4WPxlBAdx8ibhHEmrVvzFG7w2BsmEup87mQKjxpdevwHPl3T4yZQyEjnfWSjTw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:124a:b0:153:47d7:de49 with
 SMTP id u10-20020a170903124a00b0015347d7de49mr2556590plh.81.1647478602084;
 Wed, 16 Mar 2022 17:56:42 -0700 (PDT)
Date:   Thu, 17 Mar 2022 00:56:30 +0000
In-Reply-To: <20220317005630.3666572-1-jingzhangos@google.com>
Message-Id: <20220317005630.3666572-3-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220317005630.3666572-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v1 2/2] KVM: arm64: Add debug tracepoint for vcpu exits
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This tracepoint only provides a hook for poking vcpu exits information,
not exported to tracefs.
A timestamp is added for the last vcpu exit, which would be useful for
analysis for vcpu exits.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 3 +++
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/trace_arm.h        | 8 ++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index daa68b053bdc..576f2c18d008 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -415,6 +415,9 @@ struct kvm_vcpu_arch {
 
 	/* Arch specific exit reason */
 	enum arm_exit_reason exit_reason;
+
+	/* Timestamp for the last vcpu exit */
+	u64 last_exit_time;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f49ebdd9c990..98631f79c182 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	ret = 1;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	while (ret > 0) {
+		trace_kvm_vcpu_exits(vcpu);
 		/*
 		 * Check conditions before entering the guest
 		 */
@@ -898,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		local_irq_enable();
 
 		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
+		vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
 
 		/* Exit types that need handling before we can be preempted */
 		handle_exit_early(vcpu, ret);
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..3e7dfd640e23 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -301,6 +301,14 @@ TRACE_EVENT(kvm_timer_emulate,
 		  __entry->timer_idx, __entry->should_fire)
 );
 
+/*
+ * Following tracepoints are not exported in tracefs and provide hooking
+ * mechanisms only for testing and debugging purposes.
+ */
+DECLARE_TRACE(kvm_vcpu_exits,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu));
+
 #endif /* _TRACE_ARM_ARM64_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.35.1.723.g4982287a31-goog

