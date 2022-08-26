Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46E65A2F53
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 20:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345299AbiHZStQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 14:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiHZSss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 14:48:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED0CE9261
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:45:56 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id i1-20020a170902cf0100b001730caeec78so1554902plg.7
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 11:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=ed1e9YFm1bkZbR55Fi4AhXJIeJ9QRqoxJ1lB8J6isug=;
        b=crNOK3R3j37Xfzsw7QfNA/TW9IqQ86Oi4O+K9vKqcNRVNnRTzE1oXlyg98BmhLviPJ
         KLHYIbkEOkvBDd1CAUcAro992fVQk+vABTN3+2WkuHttTBFSOXWL7HdLVGnMNkkGlzqh
         aLPSLCRKfUKHTR/OLGAc2hEERwQwipghOY/UpBheYsv7EHMtLiGGJziLMXC2peRxrUHF
         cHmb9c1lPOczty49iWiq1S0AezJ119qzmB/nm9yxkjrc0X9cBCkG4wMbtm3z6vizScOL
         mL6P55tmRz+wuKR7IF1Sis2CxD2sQYTuUpPxGvduoZg7KF2JCnPww4DF3z30H5LdM7UD
         AunQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=ed1e9YFm1bkZbR55Fi4AhXJIeJ9QRqoxJ1lB8J6isug=;
        b=5fDdvMTftLPrHr5EOxsZdfBtvbAOUEMmmRQ2FamlSBiDNI1wbVewO0ZphxksXfbgGl
         3/naPTrNXw9nhA4FmOKjIT0kMVZicKa/hrOyV4qsWn1lqpHJ3kQqn7stP4icdr8+43GI
         lTNL6izry72SUv3fD2WfDkMafAZwS5R7OPUiZGxpoXLvp8Pt78QzquYPrFCxaj0BGBZ9
         UfgRXNePZz+OhBoSLTaHceMVqNWgTgabQM1x2p7t3u3FpPcx63yMn0iw8nh1jDFsqu4e
         yNjbrJDEO6VHcrXyFa04efYOvZ1VuQ+pjkX7c9HZMbeybunBel1NifadJkKC9Twn7Vfy
         Zl6A==
X-Gm-Message-State: ACgBeo3mpLuR/mHF85wmqBA/2CX4r92nPR0iSso1Z3EYom5yYLFZXBU/
        MGemjFTP8p3dGsoZS3U0T+UI7Cjn9j71
X-Google-Smtp-Source: AA6agR4VDwzUoO8UNjuYNU++2w8cs4ot7vOoQfFlsV1MVMK5t9LYoz+dLgPORgCghxFYDB3BmNjS+AqIy1UU
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:c1:b0:1f4:f757:6b48 with SMTP id
 v1-20020a17090a00c100b001f4f7576b48mr5715558pjd.56.1661539555510; Fri, 26 Aug
 2022 11:45:55 -0700 (PDT)
Date:   Fri, 26 Aug 2022 11:44:58 -0700
In-Reply-To: <20220826184500.1940077-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20220826184500.1940077-1-vipinsh@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826184500.1940077-3-vipinsh@google.com>
Subject: [PATCH v3 2/4] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, dmatlack@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index a03db7f9f4c0..acf8b80c91d1 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -406,51 +406,53 @@ int main(int argc, char *argv[])
 
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
 			dirty_log_manual_caps = 0;
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
2.37.2.672.g94769d06f0-goog

