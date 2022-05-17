Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544435298FC
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 07:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbiEQFMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 01:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiEQFMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 01:12:49 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D639275CB
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f2-20020a17090274c200b0016158e7c490so3754996plt.9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EJNs5SvJLs6HPsmYgdWi7V4fczZNjIN6G6RaPYy3W5Q=;
        b=Vc5H0oQqZvib9pXn9UPrBkm8Q0WD7T9SbaOxX/7Zc5NipbdZD0djFJxF50o3WXhBRG
         UVtTg1kwVi12VESss4yFXWohlI1sJiPRvjqklLMxfa1NTq7jbf/6Cj1UR/cXGfRtbBsF
         ZYME2oTDTGBh8xGEqgzTEEStqZ6h3CloKMdWqRHHXzKX7iAUYlcheHdZoOWhQ/3+yIoW
         UUL3Ow18FxjTHHERpWzJdB5ros0HO6EFIWUndjbnYxtKavcKSuYf8EtMoKsxgpA7kYpz
         kDx19SE4A4tTyXqLBvlFVaUWzRf0TUaaNpPFs4g71MZtjO6Wrpv9ZnnaKvDvhOD9iK4i
         0zwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EJNs5SvJLs6HPsmYgdWi7V4fczZNjIN6G6RaPYy3W5Q=;
        b=aiPSVActn/i5LBJW0nYeHHpgaRgXRHpl0P0qWSzJF7awBXR4XeMJlIKwEeFHHYRGv8
         BzgoqMiolJub0qgEWBzFThSqFFeFuJjQnGdJXA+yq3XBxOoth5c5z2dfV6XFBzKF2knN
         5nza0OBHppf28femFn+o3fC4kUF2/NToNQbphggnBDVXTHrUDUAgaj9SPp9FU/ivVOpX
         dwNWREYuiHfYbJ6B+HtdxCb89LSGDpIVT9qUJTjqTWG7EL/+C/MG1QsBDPpxQ0fXnfui
         1oukkZnqh0igZ3jL54a7azXfxwd04BqYDuSxuWOdAgkHDfF2vcmd2McqarLboDhXj0KQ
         rzlQ==
X-Gm-Message-State: AOAM531JtACNabDre8Y+KokKabJe/KerKWd3gKbBqCcD3J9BzEPqfHlo
        4r6g00YfKrjREFnlU4qtNSLmh8AahcmCwpd9UFulrQXHaWKUn1wv8mRgRcntzfvwy8xmsirH+fZ
        vocVmMqCR1/eCOgIIj6oo+83NyKxcm+3KAp+XHSXlLWYGxc7ExOnllIgTewzMaTtiu5xl
X-Google-Smtp-Source: ABdhPJzzWxpws8dN0zFYQVzajOzfuNFZ4HjVb0X5DbtbFmOLkHt+/guao4zC2IASO/QWTzSJdCD6ObWTSfryOG1K
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:4ac9:b0:1df:6944:b1e4 with SMTP
 id mh9-20020a17090b4ac900b001df6944b1e4mr6641402pjb.207.1652764367990; Mon,
 16 May 2022 22:12:47 -0700 (PDT)
Date:   Tue, 17 May 2022 05:12:38 +0000
In-Reply-To: <20220517051238.2566934-1-aaronlewis@google.com>
Message-Id: <20220517051238.2566934-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220517051238.2566934-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH 3/3] selftests: kvm/x86: Verify the pmu event filter matches
 the correct event
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

Add a test to demonstrate that when the guest programs an event select
it is matched correctly in the pmu event filter and not inadvertently
filtered.  This could happen on AMD if the high nybble[1] in the event
select gets truncated away only leaving the bottom byte[2] left for
matching.

This is a contrived example used for the convenience of demonstrating
this issue, however, this can be applied to event selects 0x28A (OC
Mode Switch) and 0x08A (L1 BTB Correction), where 0x08A could end up
being denied when the event select was only set up to deny 0x28A.

[1] bits 35:32 in the event select register and bits 11:8 in the event
    select.
[2] bits 7:0 in the event select register and bits 7:0 in the event
    select.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 .../kvm/x86_64/pmu_event_filter_test.c        | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 30c1a5804210..93d77574b255 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -281,6 +281,22 @@ static uint64_t test_with_filter(struct kvm_vm *vm,
 	return run_vm_to_sync(vm);
 }
 
+static void test_amd_deny_list(struct kvm_vm *vm)
+{
+	uint64_t event = EVENT(0x1C2, 0);
+	struct kvm_pmu_event_filter *f;
+	uint64_t count;
+
+	f = create_pmu_event_filter(&event, 1, KVM_PMU_EVENT_DENY);
+	count = test_with_filter(vm, f);
+
+	free(f);
+	if (count != NUM_BRANCHES)
+		pr_info("%s: Branch instructions retired = %lu (expected %u)\n",
+			__func__, count, NUM_BRANCHES);
+	TEST_ASSERT(count, "Allowed PMU event is not counting");
+}
+
 static void test_member_deny_list(struct kvm_vm *vm)
 {
 	struct kvm_pmu_event_filter *f = event_filter(KVM_PMU_EVENT_DENY);
@@ -463,6 +479,9 @@ int main(int argc, char *argv[])
 		exit(KSFT_SKIP);
 	}
 
+	if (use_amd_pmu())
+		test_amd_deny_list(vm);
+
 	test_without_filter(vm);
 	test_member_deny_list(vm);
 	test_member_allow_list(vm);
-- 
2.36.1.124.g0e6072fb45-goog

