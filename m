Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34144D6821
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350479AbiCKR6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350458AbiCKR6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:58:43 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BDD6C96B
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:39 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id f11-20020a056602070b00b00645d08010fcso6772056iox.15
        for <kvm@vger.kernel.org>; Fri, 11 Mar 2022 09:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BGsr6pN9enYniNk4zGr+nWX2xORuU1JL7wS+cLweFVM=;
        b=G8cB3TIlGOvwQlgqnb6Mv3A6ZDlk82Jx93jjWrLxun3vDuSleV+2ZENfuUS1eSZq+K
         IgQ+GM9Xo82V8Mun7Lw//GhahVM4rZ371b9ilQF12s4J9ZiMeW81c7rONn3ZnADLdkRR
         u2WDOuwVoayXZQ+3DSiHPrNnfLhLIsa/IdvllbJZZ7pvFOzW7aSZNQ8W7lifUWwLCuf2
         DzxMLwqWeIeg6ntp2KnMOFHYpbHF7VkUH7zkgVfTqKkbCvbnG93z8jQ35Nzt65Ow3VLB
         yQHFcdwj2Grigd5frLaWlCQhcWFuBSzZAr/5LUkcx2FguOxyMPYLNFA5zfXBNAuS2oIg
         Zn/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BGsr6pN9enYniNk4zGr+nWX2xORuU1JL7wS+cLweFVM=;
        b=yuTGfsFc89Ae4QW45S3dm5oP53TRf2THMvOTesUsd7UpJ/HmbVhG+6TiyNP93AUcx1
         HCu0Usmbqb5NBLa75oBYZxmy1NJyN2DJUYwxyK4UGbRUb6WlHK9gy531SPLftkMghcCc
         UHob9G0PgX7YysWXaDKdfKlIcUrjrpSjQLHieO8E8rFseFectWOu9X1flQ8rXbZJrPjY
         zhio60OqTUmqliNaAiE2U6wQ+OBvDah9uEeeWOZCJGeqbmuMUneu1H4YJRj/VUUOwY6g
         MTI3mFI7oCJ/nbHZOECyJ5uEp0JZHwZBMy9RXsM+GaGiwXjIDIoHD9gUGzMMvF0w/IIO
         R5Uw==
X-Gm-Message-State: AOAM532aSIA3sbsnbZ3Panpar6Qny083tF2mBweNf3Vfe6KADiLWUCOL
        bvbYK2BO/UZD4ffE40HGQiznM/N70Mw=
X-Google-Smtp-Source: ABdhPJzy7TljJ49dSoKSsh7qQwadwo8KUyffYqNTXf0RMjBpnuNAtwt/ATgmZWQS3claaoNqk/pp2mmirz8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:15c5:b0:646:4d0f:7728 with SMTP id
 f5-20020a05660215c500b006464d0f7728mr8810250iow.63.1647021458831; Fri, 11 Mar
 2022 09:57:38 -0800 (PST)
Date:   Fri, 11 Mar 2022 17:57:13 +0000
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
Message-Id: <20220311175717.616958-2-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311175717.616958-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [RFC PATCH kvmtool 1/5] TESTONLY: Sync KVM headers with pending changes
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oliver Upton <oupton@google.com>
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

Signed-off-by: Oliver Upton <oupton@google.com>
---
 include/linux/kvm.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 1daa452..e5bb5f1 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -444,6 +444,8 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_WAKEUP         4
+#define KVM_SYSTEM_EVENT_SUSPEND        5
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -634,6 +636,7 @@ struct kvm_vapic_addr {
 #define KVM_MP_STATE_OPERATING         7
 #define KVM_MP_STATE_LOAD              8
 #define KVM_MP_STATE_AP_RESET_HOLD     9
+#define KVM_MP_STATE_SUSPENDED         10
 
 struct kvm_mp_state {
 	__u32 mp_state;
@@ -1131,6 +1134,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
 #define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_VM_GPA_BITS 207
+#define KVM_CAP_XSAVE2 208
+#define KVM_CAP_SYS_ATTRIBUTES 209
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 210
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1162,11 +1169,20 @@ struct kvm_irq_routing_hv_sint {
 	__u32 sint;
 };
 
+struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+};
+
+#define KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL ((__u32)(-1))
+
 /* gsi routing entry types */
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
+#define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -1178,6 +1194,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
 };
@@ -1208,6 +1225,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -2031,4 +2049,7 @@ struct kvm_stats_desc {
 
 #define KVM_GET_STATS_FD  _IO(KVMIO,  0xce)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 #endif /* __LINUX_KVM_H */
-- 
2.35.1.723.g4982287a31-goog

