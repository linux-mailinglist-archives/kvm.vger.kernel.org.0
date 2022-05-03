Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598E8518C59
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 20:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241462AbiECSed (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 14:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241446AbiECSe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 14:34:29 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14F71EAC4
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 11:30:55 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id j8-20020aa78d08000000b0050ade744b37so9797239pfe.16
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 11:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZcTa31/SHnSC3s49aeO+K0dpZ+qhe9XO6pQANg17BXs=;
        b=a/uhsK4RxHQP14ztHfIBSg/ZakJ/fA1TktE7S4+NmjsAWXMvT7CHxbvRcXbpPxTnI4
         FJ7DNFpnR2rgysgV3lab22Gx49Y8jYUzy/PyiIfY2+lC9hkVtENJiHwOzbtSZSC5h1Jn
         TVGZ4o3FY5VoGf1OBlTVKhdZusATR7tfAKQXdUmslb9QWP5LjXzYNmQauFLTPDIWGJzl
         VeMF3MPtyRQw1DOx+azwWeB6ffJSJelEpeH7m65S/xoY9ziCjS866cesm5Uydxousnvz
         Q4ypxTqYWCcii2ghtZMepBSSe9GlGH+4dc5x9x9sKzkWXPRZE6pauzBo5e8+tWP381u3
         kxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZcTa31/SHnSC3s49aeO+K0dpZ+qhe9XO6pQANg17BXs=;
        b=IdeoR+a86C5pw0E1nFBtIUa9kC7bYumOXEyC4Ly2j4AP1/yo6TIrCgvoB/DC7VzZnC
         TrQzgn48NV1Q0gWbIO8Mi3gLIxCh7B1bfvIJ0t1Dz/FTaWbACEb0cNEOCvsEzcU5Vq9R
         39b8z/4ksf7UJ1s5vMmCYnNo80zWs8G/55ZxMtCPy2LXz6bVGXT00147IfWUWZIfeEV1
         N+mr7pYosVzIR6JzVz5X0q4LR2809mwDo4NGfmahZgS1jYBW9nq8kprVpNd+CzI/QbUM
         BqUKge0AGpmg1x7q2mr1uHh1x7pFNhespZ8rmBVUbC2rek63Q61m98pQPfn5goxHxyKl
         SIQQ==
X-Gm-Message-State: AOAM531ZjV6qnPsOfjy9lQtnXgcizjSAwWi1fzN/a6iHiHas6IDthsxo
        qtqpp8+fc/mMLeMGQYa4oAjHD81LiQq/
X-Google-Smtp-Source: ABdhPJwKNcoCpu+ARCo6tvNf0QQNqqET3WtWsj+SzdxHk4KQcXVPUEr+UmdvoeaImFrUbpaNsddEqZnU1Gtb
X-Received: from sweer.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:e45])
 (user=bgardon job=sendgmr) by 2002:a17:902:8644:b0:15a:3b4a:538a with SMTP id
 y4-20020a170902864400b0015a3b4a538amr17965247plt.146.1651602655150; Tue, 03
 May 2022 11:30:55 -0700 (PDT)
Date:   Tue,  3 May 2022 18:30:38 +0000
In-Reply-To: <20220503183045.978509-1-bgardon@google.com>
Message-Id: <20220503183045.978509-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220503183045.978509-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 04/11] KVM: selftests: Clean up coding style in binary
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
2.36.0.464.gb9c8b46e94-goog

