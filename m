Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89F613C41
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 18:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiJaRi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 13:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiJaRi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 13:38:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7CBADFC8
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:26 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c10-20020a17090aa60a00b00212e91df6acso4622094pjq.5
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 10:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kq/eZnm8KvVNCuvFzuVFxcpb13DgkgGwUFDn8WRVQDY=;
        b=HEdUgImzn+VEbHPYvaZ0HgFbjDJGIk8wIHqGS/9PCWMgap01r2wCipJs5dGPYKLvfb
         bkINgkook0xzMYJKEm9F2vj2f7pklzdOOKvDYW8ZHuWm3Y82nbkyOFOQOBGiTKi5QMDz
         TZnrHhMRvXzvy8MzZbtvqfQeiTjqkK+C+XAXmw+cbKeZ64itLxAZTmHyDLKx/XcwIuUt
         WQOzEAqVx+C0y47gHA0fRuB5oC3Qfv/sw3GLOqZcUhH575/H+Mft29y8fmkepsZi0FiU
         aEpPAxvOG/8Bw+fRfi/7TIc9ytUU2zCOFqj2Ci/teIxuO68UFNhFUYEBOL5HU4j02Eqo
         nakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kq/eZnm8KvVNCuvFzuVFxcpb13DgkgGwUFDn8WRVQDY=;
        b=nh9q4+uBU7TiMYEfPl02jugRZTnpck+lyTGkTz33zfIMm/s5s4mNEpatSuCMmNFDmG
         9mkmjTqgR6cvsPl+uCSXdC+JZ7Q46mV7iVPjsLnvElE0qgzRC5WLXqxjYepL1cF2JvKQ
         Pgqo77glTIIAvMYCnKXqPdDcZbI5mQ/MytVrxQorXvu+6olYL6MX1uinXYAUrwBFCKiv
         vpIG9Poitei8B5nugednUFPRWG8UvEHaRGlucosoY+99QdNGePvx9oDCLBoqJNGtggg+
         xxDg8z0a6DstBCGB7DBmREQg3YDulJ/muoanmJR9cMcDMXh00sQJgAZTglqFJiViBzb5
         AMsA==
X-Gm-Message-State: ACrzQf264q59EGSgq+BW6GxlpW4jRM2gydIb6QdInSPOkncMVhrNd9gf
        M0G0QPkNnxG3e7/5OkMvEXOe8hokYfO/
X-Google-Smtp-Source: AMsMyM4NICw/E/s0gzfYXMP8cAx4ACX5PLCeF4HuM5mwP9I2cALnY0dhiK/XTkvvJ6lzxx5AtEaNXWS+228h
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:ee52:b0:186:a808:5374 with SMTP id
 18-20020a170902ee5200b00186a8085374mr15157892plo.158.1667237906326; Mon, 31
 Oct 2022 10:38:26 -0700 (PDT)
Date:   Mon, 31 Oct 2022 10:38:16 -0700
In-Reply-To: <20221031173819.1035684-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221031173819.1035684-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031173819.1035684-3-vipinsh@google.com>
Subject: [PATCH v7 2/5] KVM: selftests: Put command line options in
 alphabetical order in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, wei.w.wang@intel.com, kvm@vger.kernel.org,
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
Reviewed-by: Wei Wang <wei.w.wang@intel.com>
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
2.38.1.273.g43a17bfeac-goog

