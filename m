Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270055FA783
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 00:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiJJWF5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 18:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJJWFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 18:05:51 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BC471BC0
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:05:46 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j12-20020a63594c000000b004468ff8fc78so6824611pgm.10
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 15:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+m8/CnpnyvF/GMTtF6+sToX6YjEtcCxB1JvOB9LqxJw=;
        b=PholZ6LrpQEfu25226/v2UKnjcJGs/R7bxejmrFeiGkNU55JfdTr4D75MaSsyQyvZx
         wYfHbIaIwqm2IbRXTuLtlRMat9KesrHKkpqAWLSNHJiQICCEEGOT6G0rz95kqtCw/KF9
         C/n30NajbKG/6Ke8KCKSdq0TSy6OPHA6pschqU/u78SL5j9HTPeWtgRObEh6dlRW32el
         RN17W70iHZyg3zemr7QFhWbtFWOQD6i1pJPspoJxkeSsCMwUokog5AGmWLtKP/4VeMzK
         QR+wx0Guj6LTZTvu/J7sG72WhW219IyNDElxD10++7q2r1fVxvfHXGaXI67kYiW/6oBY
         I5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+m8/CnpnyvF/GMTtF6+sToX6YjEtcCxB1JvOB9LqxJw=;
        b=vYb/GtV5iTggpTUN/JPFDfz4cAa8yH83nMepe2BnAoPT49jL+S1CEgLeJPnYBq9v/B
         efjmwwa9NaBZrThNeYwkN4A90teP42u67OmO/7gGN8LYYtC/rr6beJV9iqWrbwmvPecH
         B2I5tKvhUbrtWsCtmBLD1hriGZz8yVGUOI7YaBQGBONzkwUX21XQ7sUzejENDag4Cw02
         dYDUkdbkcjMWRYd+VaIG87PA6VTEhA1PWeUe4svXSAJgmI8a1vQGQy7LqhMyDmFx4ihO
         3uc2Thvk3k6w4QYzaJfaqcFFboVxAw0bWC4SaC6V00n2y60JQAaDD/ty/FUUf2BZkE6P
         LrtA==
X-Gm-Message-State: ACrzQf2pzrO/V+4RozOZa3FSOGhJ+JStNtfN6hpyjXUxoIFSfxZO2eWQ
        yEhiV0ANKupbbq44q1lrifRunC9cjpI2
X-Google-Smtp-Source: AMsMyM5LjSwU9NZziyHZ3eKQp48olOgBmxwhqstL09MA18f6jUGebiGPyyvh6iI3erGD5/XecKDtce8rNk3w
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:a70b:b0:181:d20e:6565 with SMTP id
 w11-20020a170902a70b00b00181d20e6565mr10525054plq.66.1665439546476; Mon, 10
 Oct 2022 15:05:46 -0700 (PDT)
Date:   Mon, 10 Oct 2022 15:05:35 -0700
In-Reply-To: <20221010220538.1154054-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221010220538.1154054-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221010220538.1154054-3-vipinsh@google.com>
Subject: [PATCH v5 2/5] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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
2.38.0.rc1.362.ged0d419d3c-goog

