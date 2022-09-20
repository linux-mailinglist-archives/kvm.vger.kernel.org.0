Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AE45BEC33
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiITRqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiITRqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:46:15 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83BF642D3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:14 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso1947655pjh.6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=h15zewX4aPbMc4C2GYlo8ZIeVJfYD6uzoHaarPDW2js=;
        b=LFcjKoMZ7qt8MFE8KkJndripEch7U9Hv4+rLs7BPAPQigGoG+c273uRqtWabO0F8rp
         3z2de34RZk4AZDaRKHNWwBAhJYKl+vaKQeifsduPBTqgTkVqqTle4x29A3B54TuOCXkC
         A8y/5BLu03/HCwsm68FT95ZmlDiPXhbEblrCuhqCPzkHlRaqALnJbl19c9oWudyYheZi
         ww9gDlJv7i0xeLD62qCNhSlVnSrnJF1vdCkk18cKZcC0z0mFRst2J+d6Bqg3aaEnQCbo
         EA3lbzNcRFn1Nk8qN+0Anv13wqyHCHHqTMz0m3LF5tpdcMDRJqLLDRH60FE5zIeludxg
         1TOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=h15zewX4aPbMc4C2GYlo8ZIeVJfYD6uzoHaarPDW2js=;
        b=LVMK/EtvCH4taIB0i7CyqZ0Fg6BFa3ps5qH/9H9vmdOQAG0Cd5cZCY+S6A0LGNLvbC
         5y40PyAkOeDuzqJ89A1xzc+z97t3W8uCX4llUskpuPWnUx8iVF+nL7ha+oMIyqacSuoz
         QOe7MaQe/1L7r2HwNpMkaRhqeXEQCfuU7f3FLA839cjSV7+FPEDJQLrdV5CHbhsHlz4K
         0f0vIL/MINsfV7DXOMvG24PD0Bnv2BeM4A1E9KaGn471S4xKIzASDSrqbGYshFyJpy5w
         W+odojKMHqs32UI2JKChEuedOu2BPLKQlkuSkppG8iPKljASM6viiMeAlT/vSWjo76bG
         u3SA==
X-Gm-Message-State: ACrzQf2TK4w+368sYlTeU+MHyvG3Klw+Ur0F8bgbNjSwni4Pc7XbJTK5
        8jB3LSTdBjZ30ODxyFydRhFRX0oklGnKx3KY46LPKbQ+96ttvjNXNf7FgFBpv+1ij+IngHBX5g0
        EQivAIts/pzyhDIMowy856aRAFNzXG5Q6ejC+FkoOOyVjPi4dGP+kkfMhVBQaA2M8f8ZY
X-Google-Smtp-Source: AMsMyM7evh2lG0Zo/9sECnfbRk5U8mv3yZhAhC9KzMoV0oHB/Ebzcxs+65Vn688SY+f7gFfTlsMlM/lDbybionq7
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:4c92:b0:202:fcca:60ae with SMTP
 id my18-20020a17090b4c9200b00202fcca60aemr5185995pjb.52.1663695974100; Tue,
 20 Sep 2022 10:46:14 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:45:58 +0000
In-Reply-To: <20220920174603.302510-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220920174603.302510-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920174603.302510-3-aaronlewis@google.com>
Subject: [PATCH v5 2/7] kvm: x86/pmu: Remove invalid raw events from the pmu
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

If a raw event is invalid, i.e. bits set outside the event select +
unit mask, the event will never match the search, so it's pointless
to have it in the list.  Opt for a shorter list by removing invalid
raw events.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
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
2.37.3.968.ga6b4b080e4-goog

