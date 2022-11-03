Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085986188A7
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbiKCTUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiKCTTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:19:36 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1071F220EC
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:17:53 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u3-20020a056a00124300b0056d4ab0c7cbso1157484pfi.7
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ovgosCt4jnwitMXwMKCysBvgrm3+dNcn5ErZ+9z2FWI=;
        b=BLb5ANRwwvLxPe1YHBq7ajF1efDE+8zNzwxtA8iraNodDcA1b6M8P4ZOevUFrZIRpm
         JbNFXAPeS1VjjAxMmX40GMrEq/Ubvnbl2JIUBonTgamHcUqHuG/XZtEjiwThKiDFkeTZ
         brEw2+4yR6QSwcns6wOv61Xparvw73G0hmvBJ9lWCfcDe2h/9+m3FQNHXFQ1GUNPKc7n
         VZ4aWE+8tdf45dS0Cid2xuXGOUh7Qjd2fbXsQ5Gn04K1yV3upSyMhRiKK6mITWRS6QBt
         TjzrLRF53OeyQRLiFnbLZTqoCEZ/9yWuUxWIHUvjz0OhMl8371/xHWrevkmCKFem1wkI
         +M/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ovgosCt4jnwitMXwMKCysBvgrm3+dNcn5ErZ+9z2FWI=;
        b=cdtyl2i+7r5vLwz2DwUf7aX7dgdwpDbPiZF43sdrYodjNlR50AZ8nHJ5runxvyQnuy
         Vt+YOVuAZgGspAFdY1VmixCheiRXKk8fOYLdrbsytZLCaFUTyeVNtE3GQCc5C75vyv3t
         S/F7BlgTmFaVoD+zKSQKnjO21KU45sjJcaSIiiaU6YFMEYG9RWFcprKLYMdJMohEp6QK
         lnjh2Hh9sZNH2S3eGrl1lc+xuF6XSuSrWPDQfaMNWaq3WmUYaG9bzIWXap84I65+wd+D
         NMLWpdGzWLpQfreZ20QDYLErF+Vj0Gg/GGcURIqUOmCKH0WPXG7iM8nC9HCjz/kmGKLm
         y0jw==
X-Gm-Message-State: ACrzQf36x/nTRIYxejx3+7BsWTB7plwvS9l7+X+o3sKUaOkx3ulzADkb
        HUYs0cpCyqzxmYa5qe9l6+EcB51QmzHw
X-Google-Smtp-Source: AMsMyM5QwspdASpVvaoU1609JuX5wqhdSJ1iqVzvrfJuvt35SPzA+ufIA8+TJy51UI/BwXrAeQ7b1q3grEcN
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:d506:b0:187:30e1:c468 with SMTP id
 b6-20020a170902d50600b0018730e1c468mr17959502plg.139.1667503054973; Thu, 03
 Nov 2022 12:17:34 -0700 (PDT)
Date:   Thu,  3 Nov 2022 12:17:17 -0700
In-Reply-To: <20221103191719.1559407-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221103191719.1559407-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221103191719.1559407-6-vipinsh@google.com>
Subject: [PATCH v9 5/7] KVM: selftests: Shorten the test args in memslot_modification_stress_test.c
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

Change test args memslot_modification_delay and nr_memslot_modifications
to delay and nr_iterations for simplicity.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/memslot_modification_stress_test.c     | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index d7ddc8a105a2..f27f07e4a5cc 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -87,8 +87,8 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 }
 
 struct test_params {
-	useconds_t memslot_modification_delay;
-	uint64_t nr_memslot_modifications;
+	useconds_t delay;
+	uint64_t nr_iterations;
 	bool partition_vcpu_memory_access;
 };
 
@@ -107,8 +107,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	pr_info("Started all vCPUs\n");
 
-	add_remove_memslot(vm, p->memslot_modification_delay,
-			   p->nr_memslot_modifications);
+	add_remove_memslot(vm, p->delay, p->nr_iterations);
 
 	run_vcpus = false;
 
@@ -144,9 +143,8 @@ int main(int argc, char *argv[])
 	int max_vcpus = kvm_check_cap(KVM_CAP_MAX_VCPUS);
 	int opt;
 	struct test_params p = {
-		.memslot_modification_delay = 0,
-		.nr_memslot_modifications =
-			DEFAULT_MEMSLOT_MODIFICATION_ITERATIONS,
+		.delay = 0,
+		.nr_iterations = DEFAULT_MEMSLOT_MODIFICATION_ITERATIONS,
 		.partition_vcpu_memory_access = true
 	};
 
@@ -158,8 +156,8 @@ int main(int argc, char *argv[])
 			guest_modes_cmdline(optarg);
 			break;
 		case 'd':
-			p.memslot_modification_delay = atoi_paranoid(optarg);
-			TEST_ASSERT(p.memslot_modification_delay >= 0,
+			p.delay = atoi_paranoid(optarg);
+			TEST_ASSERT(p.delay >= 0,
 				    "A negative delay is not supported.");
 			break;
 		case 'b':
@@ -175,7 +173,7 @@ int main(int argc, char *argv[])
 			p.partition_vcpu_memory_access = false;
 			break;
 		case 'i':
-			p.nr_memslot_modifications = atoi_paranoid(optarg);
+			p.nr_iterations = atoi_paranoid(optarg);
 			break;
 		case 'h':
 		default:
-- 
2.38.1.273.g43a17bfeac-goog

