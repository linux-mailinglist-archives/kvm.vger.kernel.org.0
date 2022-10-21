Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8377608047
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 22:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiJUUv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 16:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiJUUvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 16:51:20 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9D31DDDEB
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:19 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id q12-20020a170902dacc00b00184ba4faf1cso2281928plx.23
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 13:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zjDeRZW/tcKRSwT0d4EUt6UgZbpYaaAXDqRA6BwR2I8=;
        b=XzHpV26/SwaypDZJ7ik1NdI7z/JxGGQ7ufzeHGi+itBDTCIS1z+mn5pw3yBmzUz1Kt
         wzLAkqTi46Y2epOGGZsvYEfGp2d+ZgElqjjDcrdhnNumtqqFAMcDBcT2Lr7hUpzpSeTm
         UZpVxGzUxzemlaaTJUUwMpwKVoGdj69Hiv6vXB7sydJCQJ0HjBKo4a4qlyY9KriTQknS
         taR+ZYMxlpenIpAivdMDgm58GdAb50jVr2LwcHUIeh3eKbe+l6iy63SPpIX7f2M+hNde
         arMAKfknGFZQK9qfdy3KjxU6Gj5o3HGEqnR0w3DImgEpkXgTo6KThxAxEG+QOTNesjD6
         UYPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zjDeRZW/tcKRSwT0d4EUt6UgZbpYaaAXDqRA6BwR2I8=;
        b=ExA19z0hqH3/oTu+9rzjAuBBcRK8Dh1/T+xNn8dV9bcVB6cF+moCJUcyGvE7AXyY1D
         DJ6QPZrwEruqZttzqX6pcY7rdPnLDInJi9+gOrlD7n/nnARZmaMkkWfWaDaok9bSNIKp
         XbG9dszOwJdogEsxz1I6RyUpqx/M1WIAjgUqGSSexKug6ijZWWVemvyMomhReGGG9IE0
         MnccLzvS0iif9R0df5nEQ3kP/ePaf1jDuPwae75OuMkFj6lntA6wgxl94PGDy/GMJnPu
         lM6GsqEJ+MY4aBrJGA5Z3Z47ruPS3wybkB4CVb6t/X1i8aB5qs86BJzOER3GODO+uJgA
         wc8w==
X-Gm-Message-State: ACrzQf1UEx6kGg0qB8Y2ynf3XC/S41rMssBet7WUEHjwNB2HiC5yMkEg
        azscyMVvE4KD04LInS28Z3ErAOZNTwQWRk06pl28xoY9ppFM0CcjTQSknKFC8GZSTYOb4loO0D8
        LhSlNVCSRNhaeGDMj0WNLdQa3E65qZRQE4S2MRi73YzmedjBCsdMdt2v3MM7VUDi3kPYa
X-Google-Smtp-Source: AMsMyM5374hXhNFSuV/QeenJZlqgFmvv/ogUqrd8c6gBF0+VDpocjz3jWpfpeksXe8PBHG6v3MHUU4acNsObct7M
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:be8:b0:56b:2c80:31e0 with SMTP
 id x40-20020a056a000be800b0056b2c8031e0mr3171703pfu.44.1666385479256; Fri, 21
 Oct 2022 13:51:19 -0700 (PDT)
Date:   Fri, 21 Oct 2022 20:51:00 +0000
In-Reply-To: <20221021205105.1621014-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20221021205105.1621014-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021205105.1621014-3-aaronlewis@google.com>
Subject: [PATCH v6 2/7] kvm: x86/pmu: Remove impossible events from the pmu
 event filter
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

If it's not possible for an event in the pmu event filter to match a
pmu event being programmed by the guest, it's pointless to have it in
the list.  Opt for a shorter list by removing those events.

Because this is established uAPI the pmu event filter can't outright
rejected these events as garbage and return an error.  Instead, play
nice and remove them from the list.

Also, opportunistically rewrite the comment when the filter is set to
clarify that it guards against *all* TOCTOU attacks on the verified
data.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f1615aed2edb..a79f0d5ecaf0 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -575,6 +575,21 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 }
 EXPORT_SYMBOL_GPL(kvm_pmu_trigger_event);
 
+static void remove_impossible_events(struct kvm_pmu_event_filter *filter)
+{
+	int i, j;
+
+	for (i = 0, j = 0; i < filter->nevents; i++) {
+		if (filter->events[i] & ~(kvm_pmu_ops.EVENTSEL_EVENT |
+					  ARCH_PERFMON_EVENTSEL_UMASK))
+			continue;
+
+		filter->events[j++] = filter->events[i];
+	}
+
+	filter->nevents = j;
+}
+
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_pmu_event_filter tmp, *filter;
@@ -603,9 +618,11 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(filter, argp, size))
 		goto cleanup;
 
-	/* Ensure nevents can't be changed between the user copies. */
+	/* Restore the verified state to guard against TOCTOU attacks. */
 	*filter = tmp;
 
+	remove_impossible_events(filter);
+
 	/*
 	 * Sort the in-kernel list so that we can search it with bsearch.
 	 */
-- 
2.38.0.135.g90850a2211-goog

