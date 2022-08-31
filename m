Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A8F5A8309
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbiHaQVp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiHaQVi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:21:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934DF642CC
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:37 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id s15-20020a5b044f000000b00680c4eb89f1so2480193ybp.7
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=FrolBsEnIQB8NH/AA4jI3zIKQW1U/a5tHK/SUi8cjJM=;
        b=paI8LspsGb/W0aWtzJeVLPHYht775yP9lw7YJW4LnDrhajffTc5S0q8Y9aKYFW90T1
         1dz7ao5CL496VLKoWb0Hb/SR+jC891hitv7ybxUkpU6PNpTTXSQLAyKEiElSKkGPLgfm
         i1zD9cKDaMalv+ggemtC47/GUHmoGXaQaq5GmYovNH+deeCoXWdG/vQRfMyqa658rFpO
         tWa88eQizZAP+BO3tzVgcLCtXVPcMxOxkBNeTZwT8mBL01ICwNI4gGmOtjgQhw28qZZO
         Qin7FqO4tTBg26vrI9YZoLBEOajcepuEZx/FjcBKum2L/vkyBCiSYaGgDIAkwJcLDqUu
         mtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=FrolBsEnIQB8NH/AA4jI3zIKQW1U/a5tHK/SUi8cjJM=;
        b=25oe2lXvKHt3/o7UYJ5G81kG1J7/3ReN1GRua+WtqL8+vwH0kagdoBfl6T0GZt2Qy0
         q+/a3ZCWY7xFr6GQXOtijchY8XmMQiYrEj9rZRePwMNuv0NXMHdDpc490pazslS3m7t+
         73C+f4wStZdb0zIYjxpKhAfDdfMkukc/RGocyTeYfYQiciaVxyyEjM2ft/YwlDmKnR1h
         w3FPGMZ64FXUb9UvMAIkfQkdrvEVNEi18ml21MQMfjDcPHStZ7t79aeDU+CJWy8ns+bd
         cePQl4WbeLjbVq1IkOQdSM9ZxH19AfIQ8EGDVBdYP+s0dcptiuD6Qo64OlHJqhyLN1xJ
         FCtQ==
X-Gm-Message-State: ACgBeo34O7h4fngPuizbS4OhsxsiYzPsuh2/J9QEmt8kYis0i55OZVR8
        P/UgsL83pkIeAX4UBcrKEb0quUzSCPvNntX2r8mxZfRogLn2IqhnZLnTFxB1SpV7vQTw4wH+kAw
        W1JaHL3igR5gBwhgqQLNlvzTwpJ8WmckkHAJrpv4eKCXb8Ut+V2kjDE4rbYDBueCgQz6Z
X-Google-Smtp-Source: AA6agR45hZry9dAxdv1EvkEWkYn5+1E8BYb3bHCZHcjA5lv1v5CqxMm4VYs8/1WHZXjVvMFtC/SuXNfesSgXkQKJ
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6902:12cc:b0:695:6549:a86a with
 SMTP id j12-20020a05690212cc00b006956549a86amr16207481ybu.65.1661962896647;
 Wed, 31 Aug 2022 09:21:36 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:21:19 +0000
In-Reply-To: <20220831162124.947028-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220831162124.947028-3-aaronlewis@google.com>
Subject: [PATCH v4 2/7] kvm: x86/pmu: Remove invalid raw events from the pmu
 event filter
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

If a raw event is invalid, i.e. bits set outside the event select +
unit mask, the event will never match the search, so it's pointless
to have it in the list.  Opt for a shorter list by removing invalid
raw events.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 98f383789579..e7d94e6b7f28 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -577,6 +577,38 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+static inline u64 get_event_filter_mask(void)
+{
+	u64 event_select_mask =
+		static_call(kvm_x86_pmu_get_eventsel_event_mask)();
+
+	return event_select_mask | ARCH_PERFMON_EVENTSEL_UMASK;
+}
+
+static inline bool is_event_valid(u64 event, u64 mask)
+{
+	return !(event & ~mask);
+}
+
+static void remove_invalid_raw_events(struct kvm_pmu_event_filter *filter)
+{
+	u64 raw_mask;
+	int i, j;
+
+	if (filter->flags)
+		return;
+
+	raw_mask = get_event_filter_mask();
+	for (i = 0, j = 0; i < filter->nevents; i++) {
+		u64 raw_event = filter->events[i];
+
+		if (is_event_valid(raw_event, raw_mask))
+			filter->events[j++] = raw_event;
+	}
+
+	filter->nevents = j;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
@@ -608,6 +640,8 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	/* Ensure nevents can't be changed between the user copies. */
 	*filter = tmp;
 
+	remove_invalid_raw_events(filter);
+
 	/*
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */
-- 
2.37.2.672.g94769d06f0-goog

