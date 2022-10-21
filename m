Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FD86080A6
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 23:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiJUVSm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 17:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiJUVSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 17:18:31 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA25C2A4E0E
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:28 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id i14-20020aa78d8e000000b0056b275d8a48so982933pfr.20
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 14:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vMVJJoBCzsMQyaPTMVzkUL5zwK0EC1PhaZ6zsLS80Z8=;
        b=HJ9djxnnBohMH2BuprRhqnTKlyK1QQaQQXtmQoanmuQoqUMDQMYGc9BSE002jjc0Fg
         DXHA1NrvZ90Vx0Glb1IZHVqqv5aPUe/3FdfYJxiuPWrI03UNtpkP0nS5o36wpmdQV6pf
         X5T5T7j6X1VRYDo+/BCdUkiM6ydddIS4Iw/VRrYJqljLPLzI1gwN0EnFx9cKBddI+89F
         +NVywaVi0bTZqZf4HCCwUrqDXjMJzdy1hu+yOpcnO22t4ecRkNrjuBWdccFZzlJmAb9H
         sKLwBYRi4ODZCSnVQBhSxMtJC1HB/hs1CvqxRcnzUjdoq6MWB9hbqGRsgI0ARWqSZagv
         53ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vMVJJoBCzsMQyaPTMVzkUL5zwK0EC1PhaZ6zsLS80Z8=;
        b=ZbbFCkjdu4Hz4V3Ojtkp0Ap5Jtrdpiczzc0Yl+EZ7Whc3CXhVIVPQPZNKCURDNyGJL
         DkdNYihzgnu7VbJWWRGczfMtNYtmr5ObdKvQ2BNrywYM3I2DcDR3/+lvSC2I8OnvB6H0
         WowfEEQkmwU0KFIUgCGSBduWb0YLobpanJHM7ENrStj7RxJYoOiL0OuraQaa+hWljLZG
         ajLQfz1cMgoqd2BH9NqOEOYiDdfqFdbvgk8YLqysVhL50hnfw2/RdpUk11+Bb9sq69TL
         qsCR6G4Gi+NPSTU/aulycMT6jExwc4gyxz/bEJ5AIQjuAasJ6Zq9lkuHqhSWOze3SyuK
         s+hA==
X-Gm-Message-State: ACrzQf3g9irI8VUMvkQbTdBGVkBmxbmZG3528t3Mo0+aApzwKwTujrZ/
        RsxT+k1/7rVaJYaNDo/5zfqyrRFA2Ls+
X-Google-Smtp-Source: AMsMyM7V4uXgcGGlfWbQJ7+kkGcksx4OvxRBy8B8Ny2q3pJ+N0RT61EiANiSuuOJzJcLOB5DiO2vhb55kYZq
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a05:6a00:1306:b0:555:6d3f:11ed with SMTP
 id j6-20020a056a00130600b005556d3f11edmr21113463pfu.55.1666387107996; Fri, 21
 Oct 2022 14:18:27 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:18:13 -0700
In-Reply-To: <20221021211816.1525201-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221021211816.1525201-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221021211816.1525201-3-vipinsh@google.com>
Subject: [PATCH v6 2/5] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are 13 command line options and they are not in any order. Put
them in alphabetical order to make it easy to add new options.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 36 ++++++++++---------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 56e08da3a87f..5bb6954b2358 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -406,50 +406,52 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "eghi:p:m:nb:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "b:ef:ghi:m:nop:s:v:x:")) != -1) {
 		switch (opt) {
+		case 'b':
+			guest_percpu_mem_size = parse_size(optarg);
+			break;
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
 			break;
+		case 'f':
+			p.wr_fract = atoi(optarg);
+			TEST_ASSERT(p.wr_fract >= 1,
+				    "Write fraction cannot be less than one");
+			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
 			break;
+		case 'h':
+			help(argv[0]);
+			break;
 		case 'i':
 			p.iterations = atoi(optarg);
 			break;
-		case 'p':
-			p.phys_offset = strtoull(optarg, NULL, 0);
-			break;
 		case 'm':
 			guest_modes_cmdline(optarg);
 			break;
 		case 'n':
 			perf_test_args.nested = true;
 			break;
-		case 'b':
-			guest_percpu_mem_size = parse_size(optarg);
+		case 'o':
+			p.partition_vcpu_memory_access = false;
 			break;
-		case 'f':
-			p.wr_fract = atoi(optarg);
-			TEST_ASSERT(p.wr_fract >= 1,
-				    "Write fraction cannot be less than one");
+		case 'p':
+			p.phys_offset = strtoull(optarg, NULL, 0);
+			break;
+		case 's':
+			p.backing_src = parse_backing_src_type(optarg);
 			break;
 		case 'v':
 			nr_vcpus = atoi(optarg);
 			TEST_ASSERT(nr_vcpus > 0 && nr_vcpus <= max_vcpus,
 				    "Invalid number of vcpus, must be between 1 and %d", max_vcpus);
 			break;
-		case 'o':
-			p.partition_vcpu_memory_access = false;
-			break;
-		case 's':
-			p.backing_src = parse_backing_src_type(optarg);
-			break;
 		case 'x':
 			p.slots = atoi(optarg);
 			break;
-		case 'h':
 		default:
 			help(argv[0]);
 			break;
-- 
2.38.0.135.g90850a2211-goog

