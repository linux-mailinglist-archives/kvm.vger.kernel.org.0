Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B9754A163
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352185AbiFMVaN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 17:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353159AbiFMV3W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 17:29:22 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57C0394
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:33 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id i19-20020aa79093000000b0050d44b83506so2828857pfa.22
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 14:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Kj1m4/hp4yXa0MCKZFilZvFRZAcbfqXBAQSF/QNTX0I=;
        b=Ejx7pQeJpfGG0NaTdJvphAGp4nv3Ihs+s1AJftLby+RDwLbq4kgntxJuqvoKueo8hx
         54rII6yXHK1HDJLoL27lmAg6Gwxs7HF+a3ym+KNQ1iJoz7SGrB85nWOH0hONhmj0qCMp
         whi/Ro+Gsr2v38mem6shBBdglqIXrMBlo991Eo8vUytdJhwVRIAigHdnznxg2Nci3HEn
         ru93AOURfwT6gVAHQg26kGqkhaHgD3YW3+PpylZzhAOm57FKdVxrD36AWjxE/aSZmhOb
         8j7bqHKQMY6bDvQvgczyM6YQ6Dtc3aSEFeg0kd8/FQUA00qoHJifBIY2Lqo5wmJ2FmM3
         GfOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Kj1m4/hp4yXa0MCKZFilZvFRZAcbfqXBAQSF/QNTX0I=;
        b=0+D7RsSuho2Lc37bBJe43AsAPEHpg+Nf8DFvlMoMBwq5kdKujr+NnmPjUcyGqLd+yV
         UJaqeWsIDuNPMSMDA6JH0O6BjqP0DX6QLhjeEMmiPcpVTI1zxUEmW7SaLYitdN53XJ1X
         OBFmWQTg7sAc21vvh4/FhCsmsJQmbzX6QbDGQjByYA5NVMw5GXTSJOjidCip01UwAFIx
         20YQ2vfSJuTudz9SWg5VXBeUCf5+eJOPcZA35CDc0k/5mlOpIR1rWijTwl+lqNt/LirW
         nZSXx5P8dtnae3sZun+8DmyysO5/u63idB8U3a73dcoEN5eXujWRcjAZfa9gJ3+wNZc0
         25bg==
X-Gm-Message-State: AJIora9TrYiWh3Nugox4bUhvDA+F5sSuEPd55vs8JPQdkDS5J+t/aze4
        I5EiVuHUAw6GKbIxi1zNHlilGPoJqbQlR4d1kbb/314GTy985c5m09NbiwF8OMfOQbhbh4UxiFz
        vy3iQNDtDyNSTw8FETbi2wU91ZNAFJhxCZG5rjaKw79eiGF2qb1sDOwyGcxuW
X-Google-Smtp-Source: AGRyM1smgvIZPd4Fy0LJ7U8fw816XS0spLgdGPVjYHUYW8dPHNfQ3e1xW40sIVmdC2nvZP1ZeTLY6Y+cAqme
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:903:1d2:b0:168:e3b9:e62b with SMTP id
 e18-20020a17090301d200b00168e3b9e62bmr981167plh.115.1655155533185; Mon, 13
 Jun 2022 14:25:33 -0700 (PDT)
Date:   Mon, 13 Jun 2022 21:25:17 +0000
In-Reply-To: <20220613212523.3436117-1-bgardon@google.com>
Message-Id: <20220613212523.3436117-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220613212523.3436117-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v9 04/10] KVM: selftests: Clean up coding style in binary
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
index 9d3b9a0ce2ef..3002fab2bbf1 100644
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
2.36.1.476.g0c4daa206d-goog

