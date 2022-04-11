Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1CC64FB948
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345271AbiDKKWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345267AbiDKKWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76FA3F896;
        Mon, 11 Apr 2022 03:19:59 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so2477783pjb.1;
        Mon, 11 Apr 2022 03:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yVqyTL4ujwWScT/jvuVWEttx50zCjvsAOh65liAPMmk=;
        b=ecyLt/GveOYBmpHYn7UvosVTVs8aFGj5Fuw6Q5MJNXehb+4O+mTfhAJSMUl4PC0xTI
         mZDXYrC8Z3uEZSxcVfirkF1jzzs/y6p7zsKMluj2710JjMDibNet4m1hZlGIJnnLGikG
         ptcxOi0PLYDg0ur+uXQAOVAsvKTTfmTdGL7wC9P/DQSge+J6oc6u/+DgTS5F/L0/Blyu
         KhvK7YuWy88cH4siL2GZIGtteNs1qZDuJ7WIE4vDMQAMBcZ+MSpz1WkgX1llU63iYpMM
         ceQa2QFbuwFQCsjlmSEzqMRJl8JoMiN0CuOh/Lk6SBV/cyajtlIVfr3PHzqIts8ueb9n
         NwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yVqyTL4ujwWScT/jvuVWEttx50zCjvsAOh65liAPMmk=;
        b=uuqgv0NH6ZTe25aHjNegubgSY/Hkss30dB3kzxinYVlHkp8y2scmxtrAF35t34WX2d
         pL0sQ5SOHd5TBBzF9t2RXwJ1fmbwXyTIBJPGY92rc5fO7KRb5Fmsrvlxh58adECzW1aW
         B8reW6niq4VmVwiy9pk/HfxUYmcbTXkF9IT489UnqJX0x95G6fPfwERnO28fvnLse0O9
         GPQcKA6GTNEvBOWqJBiuXjrxFyJF7onqqbgFyHMHwIIkjMz8uQVLzqxM/+xVYAeGHERw
         fEXx9g9ftfO8BmyORfxY65aKZnK9elTsPB++vzi9KaKIOlfzMQy+7RL1CMuVhtXNTUsD
         V9Ug==
X-Gm-Message-State: AOAM533XP9w6nCbebelQb1NTq97fG7Bg131S8Cc/A6xNl0vSBROXWhSV
        GgXShslYx4NPnL8Rr9YPlobLeWjiKEE=
X-Google-Smtp-Source: ABdhPJw34EetoDqye8k+kNlEQEHM1PbvrkiInQ56Vbzx3GDsSD2pGpLLiCj4OJZYRZDKBBOjtbmFsw==
X-Received: by 2002:a17:90b:2385:b0:1cb:74f7:6517 with SMTP id mr5-20020a17090b238500b001cb74f76517mr9761997pjb.142.1649672398653;
        Mon, 11 Apr 2022 03:19:58 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:19:58 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 02/17] perf/x86/intel: Handle guest PEBS overflow PMI for KVM guest
Date:   Mon, 11 Apr 2022 18:19:31 +0800
Message-Id: <20220411101946.20262-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

With PEBS virtualization, the guest PEBS records get delivered to the
guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
to distinguish whether the PMI comes from the guest code like Intel PT.

No matter how many guest PEBS counters are overflowed, only triggering
one fake event is enough. The fake event causes the KVM PMI callback to
be called, thereby injecting the PEBS overflow PMI into the guest.

KVM may inject the PMI with BUFFER_OVF set, even if the guest DS is
empty. That should really be harmless. Thus guest PEBS handler would
retrieve the correct information from its own PEBS records buffer.

Cc: linux-perf-users@vger.kernel.org
Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/core.c | 42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 0988ff3e18fb..510fc2de4cd2 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2852,6 +2852,47 @@ static void intel_pmu_reset(void)
 	local_irq_restore(flags);
 }
 
+/*
+ * We may be running with guest PEBS events created by KVM, and the
+ * PEBS records are logged into the guest's DS and invisible to host.
+ *
+ * In the case of guest PEBS overflow, we only trigger a fake event
+ * to emulate the PEBS overflow PMI for guest PEBS counters in KVM.
+ * The guest will then vm-entry and check the guest DS area to read
+ * the guest PEBS records.
+ *
+ * The contents and other behavior of the guest event do not matter.
+ */
+static void x86_pmu_handle_guest_pebs(struct pt_regs *regs,
+				      struct perf_sample_data *data)
+{
+	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
+	struct perf_event *event = NULL;
+	int bit;
+
+	if (!unlikely(perf_guest_state()))
+		return;
+
+	if (!x86_pmu.pebs_ept || !x86_pmu.pebs_active ||
+	    !guest_pebs_idxs)
+		return;
+
+	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
+			 INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
+		event = cpuc->events[bit];
+		if (!event->attr.precise_ip)
+			continue;
+
+		perf_sample_data_init(data, 0, event->hw.last_period);
+		if (perf_event_overflow(event, data, regs))
+			x86_pmu_stop(event, 0);
+
+		/* Inject one fake event is enough. */
+		break;
+	}
+}
+
 static int handle_pmi_common(struct pt_regs *regs, u64 status)
 {
 	struct perf_sample_data data;
@@ -2903,6 +2944,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		u64 pebs_enabled = cpuc->pebs_enabled;
 
 		handled++;
+		x86_pmu_handle_guest_pebs(regs, &data);
 		x86_pmu.drain_pebs(regs, &data);
 		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
-- 
2.35.1

