Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B721508E8C
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381184AbiDTRiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381151AbiDTRiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8B71C908
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:24 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id n1-20020a654881000000b003a367d46721so1388154pgs.4
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/WN+yQl9cRZbs0/aNri7VlZHQDfluYCzOSG0WstbyTE=;
        b=IdRdrVfW6zavsuxkVXPnJzXeo2nzapoQdyuhyUVdK59hwA12/+DIxIusvzG1Pgw1rY
         y33iLnu2Turp/on+QGE7p4SVQu/kFIrOPYhSa4JEmicJeeGUuHTNh9HBjGZnrAtKCyC+
         Bi1pjf2gV8OIUOKS/DFlx4Mf3DOcxgd93DdJcLt+1IhUVcCudKZ6j5kjf/jQcVzhs7k/
         iw8mz3BmDYzsTzINpIpQK5zRk42tGb8lIBR2Xs5n7QVP7W8VLWeZj93ikMeYZBouwv4Y
         Fp0I6v2667StwjFBDb32NrEoavujzCXFyIQCsm4Yp3q5XTFojTUXzX6hZl0qYFk9zdme
         II8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/WN+yQl9cRZbs0/aNri7VlZHQDfluYCzOSG0WstbyTE=;
        b=T5dcMFLSUR6lx5PELhmg/2jXEZ0kIbvBfBSWE3vLuF6EiiaYjqK8aofUXPtex1wW3O
         LYbu9NZnGujgtNlkOjlzw/rVpeKDZso+pVU7Nltrg4TJF4v5rG4wPX/UDbyXi5msZtiX
         iBZkykN8IFeoh/EctiizdjK0FbqflWKODCjCIk2CleU/Cph38oJPaVoUvo0164fU/BCv
         iUaCjoqdo0IyAa+1fiiNeSofj8ckAQrov23vbn7UZMMrOYOkiC5DsT1qbov6G2sVF2EV
         2jxfxOrLku+nKcIRivJ3T4laAylpZfT84H3yQkp+hz490PwQOl5ZJ+jCh8Pyy90yVpGS
         Ag/A==
X-Gm-Message-State: AOAM531hRF+PD5hxEW+rTo3tDcM07hY3Jh09fnhloxRZDBxrxcFSDw34
        o5GnrMqclyRxDnjcZ1SG1gffBh2HMAfN
X-Google-Smtp-Source: ABdhPJzXAeRMx6UDOA4niT29o66r3ow8bEfxQ/t864dKCjYXPRz2a5XhBz92ea/OoSzjbBm0oxWyi1OQSoh9
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr80977pjb.1.1650476124026; Wed, 20 Apr
 2022 10:35:24 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:07 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 04/10] KVM: selftests: Clean up coding style in binary
 stats test
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 .../selftests/kvm/kvm_binary_stats_test.c     | 91 ++++++++++++-------
 1 file changed, 56 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index b49fae45db1e..8b31f8fc7e08 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -35,47 +35,64 @@ static void stats_test(int stats_fd)
 	/* Read kvm stats header */
 	read_stats_header(stats_fd, &header);
 
+	/*
+	 * The base size of the descriptor is defined by KVM's ABI, but the
+	 * size of the name field is variable as far as KVM's ABI is concerned.
+	 * But, the size of name is constant for a given instance of KVM and
+	 * is provided by KVM in the overall stats header.
+	 */
 	size_desc = sizeof(*stats_desc) + header.name_size;
 
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
 	stats_desc = read_stats_desc(stats_fd, &header);
 
 	/* Sanity check for fields in descriptors */
 	for (i = 0; i < header.num_desc; ++i) {
+		/*
+		 * Note, size_desc includes the of the name field, which is
+		 * variable, i.e. this is NOT equivalent to &stats_desc[i].
+		 */
 		pdesc = (void *)stats_desc + i * size_desc;
-		/* Check type,unit,base boundaries */
-		TEST_ASSERT((pdesc->flags & KVM_STATS_TYPE_MASK)
-				<= KVM_STATS_TYPE_MAX, "Unknown KVM stats type");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_UNIT_MASK)
-				<= KVM_STATS_UNIT_MAX, "Unknown KVM stats unit");
-		TEST_ASSERT((pdesc->flags & KVM_STATS_BASE_MASK)
-				<= KVM_STATS_BASE_MAX, "Unknown KVM stats base");
-		/* Check exponent for stats unit
+
+		/* Check type, unit, and base boundaries */
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
@@ -86,47 +103,51 @@ static void stats_test(int stats_fd)
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
 		pdesc = (void *)stats_desc + i * size_desc;
 		TEST_ASSERT(pdesc->offset < size_data,
-			"Invalid offset (%u) for stats: %s",
-			pdesc->offset, pdesc->name);
+			    "Invalid offset (%u) for stats: %s",
+			    pdesc->offset, pdesc->name);
 	}
 
 	/* Allocate memory for stats data */
-- 
2.36.0.rc0.470.gd361397f0d-goog

