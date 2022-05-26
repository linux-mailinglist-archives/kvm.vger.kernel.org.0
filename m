Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113995352F5
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348349AbiEZRy0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343642AbiEZRyW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:54:22 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A38DA7E32
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:19 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o8-20020a17090a9f8800b001dc9f554c7fso1427065pjp.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=falxtzP4l1rM8q3vaJiFDhXAWycm4MI2aAJ4+6pFDbo=;
        b=Iy7Dxc3igXT8IaYfpRfrevtHrWY0aG5RMOHxZFj1X3DSUrAa9qJVreThMq7/xLkq4a
         fZMvR3ZTjvrg7dRmTnDc6HYXsd3dFiIB2XuVHIsu3TFrv0WqNcPIdK/aNOaUdcK3qEva
         G/jlnDADPDyj7xMTwBNtDLfeUGtEI5Q9/OYBpirxN2g6EqjaeSaklU/jDfLKFdnmz+w1
         ICfl4elBVBMQ5pa6z//x1FCkMUBEmpaOWAMGBLdBtI+ReYvwByWhsyM7dEVRfUZ+9K0g
         7a38FAhAHvfbCmszrVQSNb/gt1u7XhyrkeyFmLjMHldrtgL2HndL4D78Sbk5q0jfGFVX
         /pQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=falxtzP4l1rM8q3vaJiFDhXAWycm4MI2aAJ4+6pFDbo=;
        b=mQhEqTfdsqYQuxxCaBiwFIHnfu1c905hEFSc/cDWIHpEXcCDCDsssR2lHbgH+iVYnp
         /pxNM0lLk7iRHgFFXp5fX5CQYQfFBUAK9B4l2v7klJU6T5blEe3S76nNGd5iV5Sr4gy0
         a794pCb+kWy0nhcKve2OV3iB+KotXuBTL+UHnwR/EnJFqX2WmZ3Stf6xOfgKLdfnZAcw
         LimLwXhPL/Y5KhejBmAdsnKWst8Vfhgbhca58agRuTKm1AXIN7UD5NaezHtmV+3p9RIP
         E65ybnD4vqJCFQC3Fgi5kcO1OPocJ5r9phGetV3EfBbbOkWYidE1/rtI3pABxWF6ZP8d
         1cYg==
X-Gm-Message-State: AOAM530usraxwoipzhFamT5KUR5OHQGi+rKvsUaRo6dqgmtWp9pCeu/R
        cwGmelEdmsNYfbt/jvu0CWBNhB+GGvW6c/PvIL8N3SUvRK+il8HzDakZVXgiMQdlmnVE5XKcaZT
        /PfYMpE0wJJp17BVgrtvqtY0LmW79yATSxW3iIG36RPcqfMjQ+e9c452oIRG0
X-Google-Smtp-Source: ABdhPJwDSn6DdJNOrV9sZ9BKy5TmJDviFFwJMbDvGYeKHMI/CLjzBDvij+HHDmlczSRBHT4jPllBJbS375pX
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:1a44:b0:510:a043:3b09 with SMTP
 id h4-20020a056a001a4400b00510a0433b09mr39441711pfv.62.1653587658635; Thu, 26
 May 2022 10:54:18 -0700 (PDT)
Date:   Thu, 26 May 2022 17:54:01 +0000
In-Reply-To: <20220526175408.399718-1-bgardon@google.com>
Message-Id: <20220526175408.399718-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220526175408.399718-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v8 04/11] KVM: selftests: Clean up coding style in binary
 stats test
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

From: Sean Christopherson <seanjc@google.com>

Fix a variety of code style violations and/or inconsistencies in the
binary stats test.  The 80 char limit is a soft limit and can and should
be ignored/violated if doing so improves the overall code readability.

Specifically, provide consistent indentation and don't split expressions
at arbitrary points just to honor the 80 char limit.

Opportunistically expand/add comments to call out the more subtle aspects
of the code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/kvm_binary_stats_test.c     | 79 +++++++++++--------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index a5198b9a19c1..956dc40d9bc7 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -40,27 +40,31 @@ static void stats_test(int stats_fd)
 	/* Read kvm stats id string */
 	id = malloc(header.name_size);
 	TEST_ASSERT(id, "Allocate memory for id string");
+
 	ret = read(stats_fd, id, header.name_size);
 	TEST_ASSERT(ret == header.name_size, "Read id string");
 
 	/* Check id string, that should start with "kvm" */
 	TEST_ASSERT(!strncmp(id, "kvm", 3) && strlen(id) < header.name_size,
-				"Invalid KVM stats type, id: %s", id);
+		    "Invalid KVM stats type, id: %s", id);
 
 	/* Sanity check for other fields in header */
 	if (header.num_desc == 0) {
 		printf("No KVM stats defined!");
 		return;
 	}
-	/* Check overlap */
-	TEST_ASSERT(header.desc_offset > 0 && header.data_offset > 0
-			&& header.desc_offset >= sizeof(header)
-			&& header.data_offset >= sizeof(header),
-			"Invalid offset fields in header");
+	/*
+	 * The descriptor and data offsets must be valid, they must not overlap
+	 * the header, and the descriptor and data blocks must not overlap each
+	 * other.  Note, the data block is rechecked after its size is known.
+	 */
+	TEST_ASSERT(header.desc_offset && header.desc_offset >= sizeof(header) &&
+		    header.data_offset && header.data_offset >= sizeof(header),
+		    "Invalid offset fields in header");
+
 	TEST_ASSERT(header.desc_offset > header.data_offset ||
-			(header.desc_offset + size_desc * header.num_desc <=
-							header.data_offset),
-			"Descriptor block is overlapped with data block");
+		    (header.desc_offset + size_desc * header.num_desc <= header.data_offset),
+		    "Descriptor block is overlapped with data block");
 
 	/* Read kvm stats descriptors */
 	stats_desc = read_stats_descriptors(stats_fd, &header);
@@ -68,14 +72,17 @@ static void stats_test(int stats_fd)
 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = get_stats_descriptor(stats_desc, i, &header);
+
 		/* Check type,unit,base boundaries */
-		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
-				<= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK)
-				<= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
-				<= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
-		/* Check exponent for stats unit
+		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK) <= KVM_STATS_TYPE_MAX,
+			    "Unknown KVM stats type");
+		TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK) <= KVM_STATS_UNIT_MAX,
+			    "Unknown KVM stats unit");
+		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK) <= KVM_STATS_BASE_MAX,
+			    "Unknown KVM stats base");
+
+		/*
+		 * Check exponent for stats unit
 		 * Exponent for counter should be greater than or equal to 0
 		 * Exponent for unit bytes should be greater than or equal to 0
 		 * Exponent for unit seconds should be less than or equal to 0
@@ -86,47 +93,51 @@ static void stats_test(int stats_fd)
 		case KVM_STATS_UNIT_NONE:
 		case KVM_STATS_UNIT_BYTES:
 		case KVM_STATS_UNIT_CYCLES:
-			TEST_ASSERT(pdesc->exponent >= 0,
-					"Unsupported KVM stats unit");
+			TEST_ASSERT(pdesc->exponent >= 0, "Unsupported KVM stats unit");
 			break;
 		case KVM_STATS_UNIT_SECONDS:
-			TEST_ASSERT(pdesc->exponent <= 0,
-					"Unsupported KVM stats unit");
+			TEST_ASSERT(pdesc->exponent <= 0, "Unsupported KVM stats unit");
 			break;
 		}
 		/* Check name string */
 		TEST_ASSERT(strlen(pdesc->name) < header.name_size,
-				"KVM stats name(%s) too long", pdesc->name);
+			    "KVM stats name(%s) too long", pdesc->name);
 		/* Check size field, which should not be zero */
-		TEST_ASSERT(pdesc->size, "KVM descriptor(%s) with size of 0",
-				pdesc->name);
+		TEST_ASSERT(pdesc->size,
+			    "KVM descriptor(%s) with size of 0", pdesc->name);
 		/* Check bucket_size field */
 		switch (pdesc->flags & KVM_STATS_TYPE_MASK) {
 		case KVM_STATS_TYPE_LINEAR_HIST:
 			TEST_ASSERT(pdesc->bucket_size,
-			    "Bucket size of Linear Histogram stats (%s) is zero",
-			    pdesc->name);
+				    "Bucket size of Linear Histogram stats (%s) is zero",
+				    pdesc->name);
 			break;
 		default:
 			TEST_ASSERT(!pdesc->bucket_size,
-			    "Bucket size of stats (%s) is not zero",
-			    pdesc->name);
+				    "Bucket size of stats (%s) is not zero",
+				    pdesc->name);
 		}
 		size_data += pdesc->size * sizeof(*stats_data);
 	}
-	/* Check overlap */
-	TEST_ASSERT(header.data_offset >= header.desc_offset
-		|| header.data_offset + size_data <= header.desc_offset,
-		"Data block is overlapped with Descriptor block");
+
+	/*
+	 * Now that the size of the data block is known, verify the data block
+	 * doesn't overlap the descriptor block.
+	 */
+	TEST_ASSERT(header.data_offset >= header.desc_offset ||
+		    header.data_offset + size_data <= header.desc_offset,
+		    "Data block is overlapped with Descriptor block");
+
 	/* Check validity of all stats data size */
 	TEST_ASSERT(size_data >= header.num_desc * sizeof(*stats_data),
-			"Data size is not correct");
+		    "Data size is not correct");
+
 	/* Check stats offset */
 	for (i = 0; i < header.num_desc; ++i) {
 		pdesc = get_stats_descriptor(stats_desc, i, &header);
 		TEST_ASSERT(pdesc->offset < size_data,
-			"Invalid offset (%u) for stats: %s",
-			pdesc->offset, pdesc->name);
+			    "Invalid offset (%u) for stats: %s",
+			    pdesc->offset, pdesc->name);
 	}
 
 	/* Allocate memory for stats data */
-- 
2.36.1.124.g0e6072fb45-goog

