Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455DD6646EF
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 18:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238799AbjAJRES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 12:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238662AbjAJREG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 12:04:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD171485BE
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:03 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pa16-20020a17090b265000b0020a71040b4cso5029119pjb.6
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 09:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8e2eHCiIkXd8zz4xcerKzAeu3DXKJJykbXTSOUoDpY=;
        b=F1m0coJy7gqbwEQyQ6QJkHaTucQBCwh0O6OF2TXhVbztLjnViwpwIauj/8fy1Nt4/a
         b8vft6K/A5GnyZtltpWi4PUbEkiwRnjwONAQTxL6yskiQa4fzW9ovYT1bBwOAoaCpf0q
         swzWb821zh3wuSWc5DEBRB8hp2Et7lg6hjavwNL5PXb629uwBWZP37sxMHyt9XIrU06S
         Df1oeW/hetAuN8MRlqokxldnqZu6ITtZVUTZluJwcE/xOgSYqryp6Yvg4w9Bwhi+6x2s
         nfbqCE88s27rO2buYLXmHcYXTlmTW/CWPPi/RR6pAdhizGo7mmw/mn20LoKYsVLdNjxV
         U8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W8e2eHCiIkXd8zz4xcerKzAeu3DXKJJykbXTSOUoDpY=;
        b=mgDst2Qcv+YVRcz4hB7aAaHXyOIW6GN/3yZb/qQLhHc2e6mJrBWxiHQC5wybziPjCp
         JwyeRzDE+WoIBwCx7D/RcqVJpXocZ892+oe7FhGepLiXtfHEqU8POsGKgtxxc5xc3nZi
         E4J23KE1+6ASZuRsUu2dkckB1pe6971tmjCO+P80n6jeMxwibN0c2XQ1hqp+ceGOZgnl
         fEqFXsJDLPK/D2F6xb2AUryZH30AQgXzPMpV2mIuhDzN14TTFK5EQGBEmNzUwE3CHPej
         kl8x5CGRk4e4C/fl1GGcNiSZnCGO34CTFL/wVdiCIGdkYx0mgU6DNXmwB3AhztHk5AWS
         mamA==
X-Gm-Message-State: AFqh2krYdjqFT9od4boOUSFpKUg5GBgtpYj5mUwvMajYHWVIqKS2aYIm
        yYG6JGQdllNVYZpmmhSNXISKA19tNrlB6TO33HrMlPijcNxHm24SEgrolUgVo8gi2QJTqcDXi92
        DJCga8kqa87DPPcbqatB+2ezEB56Jq56GDgaILCuLmkxfYYkzM7q9LegF8w==
X-Google-Smtp-Source: AMrXdXvcrS1bdpPzezNRpEqWaBQ7uWRQt6wFQg0bMtqbh1itPcANGb7OeggdSA//IJuUYJTgSZeh4taoq24=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:11:8358:4c2a:eae1:4752])
 (user=pgonda job=sendgmr) by 2002:a17:902:7605:b0:189:e206:2223 with SMTP id
 k5-20020a170902760500b00189e2062223mr4605333pll.97.1673370243184; Tue, 10 Jan
 2023 09:04:03 -0800 (PST)
Date:   Tue, 10 Jan 2023 09:03:52 -0800
In-Reply-To: <20230110170358.633793-1-pgonda@google.com>
Message-Id: <20230110170358.633793-2-pgonda@google.com>
Mime-Version: 1.0
References: <20230110170358.633793-1-pgonda@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Subject: [PATCH V6 1/7] KVM: selftests: sparsebit: add const where appropriate
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerly Tng <ackerleytng@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Peter Gonda <pgonda@google.com>
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

From: Michael Roth <michael.roth@amd.com>

Subsequent patches will introduce an encryption bitmap in kvm_util that
would be useful to allow tests to access in read-only fashion. This
will be done via a const sparsebit*. To avoid warnings or the need to
add casts everywhere, add const to the various sparsebit functions that
are applicable for read-only usage of sparsebit.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 .../testing/selftests/kvm/include/sparsebit.h | 36 +++++++-------
 tools/testing/selftests/kvm/lib/sparsebit.c   | 48 +++++++++----------
 2 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/sparsebit.h b/tools/testing/selftests/kvm/include/sparsebit.h
index 12a9a4b9cead..fb5170d57fcb 100644
--- a/tools/testing/selftests/kvm/include/sparsebit.h
+++ b/tools/testing/selftests/kvm/include/sparsebit.h
@@ -30,26 +30,26 @@ typedef uint64_t sparsebit_num_t;
 
 struct sparsebit *sparsebit_alloc(void);
 void sparsebit_free(struct sparsebit **sbitp);
-void sparsebit_copy(struct sparsebit *dstp, struct sparsebit *src);
+void sparsebit_copy(struct sparsebit *dstp, const struct sparsebit *src);
 
-bool sparsebit_is_set(struct sparsebit *sbit, sparsebit_idx_t idx);
-bool sparsebit_is_set_num(struct sparsebit *sbit,
+bool sparsebit_is_set(const struct sparsebit *sbit, sparsebit_idx_t idx);
+bool sparsebit_is_set_num(const struct sparsebit *sbit,
 			  sparsebit_idx_t idx, sparsebit_num_t num);
-bool sparsebit_is_clear(struct sparsebit *sbit, sparsebit_idx_t idx);
-bool sparsebit_is_clear_num(struct sparsebit *sbit,
+bool sparsebit_is_clear(const struct sparsebit *sbit, sparsebit_idx_t idx);
+bool sparsebit_is_clear_num(const struct sparsebit *sbit,
 			    sparsebit_idx_t idx, sparsebit_num_t num);
-sparsebit_num_t sparsebit_num_set(struct sparsebit *sbit);
-bool sparsebit_any_set(struct sparsebit *sbit);
-bool sparsebit_any_clear(struct sparsebit *sbit);
-bool sparsebit_all_set(struct sparsebit *sbit);
-bool sparsebit_all_clear(struct sparsebit *sbit);
-sparsebit_idx_t sparsebit_first_set(struct sparsebit *sbit);
-sparsebit_idx_t sparsebit_first_clear(struct sparsebit *sbit);
-sparsebit_idx_t sparsebit_next_set(struct sparsebit *sbit, sparsebit_idx_t prev);
-sparsebit_idx_t sparsebit_next_clear(struct sparsebit *sbit, sparsebit_idx_t prev);
-sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *sbit,
+sparsebit_num_t sparsebit_num_set(const struct sparsebit *sbit);
+bool sparsebit_any_set(const struct sparsebit *sbit);
+bool sparsebit_any_clear(const struct sparsebit *sbit);
+bool sparsebit_all_set(const struct sparsebit *sbit);
+bool sparsebit_all_clear(const struct sparsebit *sbit);
+sparsebit_idx_t sparsebit_first_set(const struct sparsebit *sbit);
+sparsebit_idx_t sparsebit_first_clear(const struct sparsebit *sbit);
+sparsebit_idx_t sparsebit_next_set(const struct sparsebit *sbit, sparsebit_idx_t prev);
+sparsebit_idx_t sparsebit_next_clear(const struct sparsebit *sbit, sparsebit_idx_t prev);
+sparsebit_idx_t sparsebit_next_set_num(const struct sparsebit *sbit,
 				       sparsebit_idx_t start, sparsebit_num_t num);
-sparsebit_idx_t sparsebit_next_clear_num(struct sparsebit *sbit,
+sparsebit_idx_t sparsebit_next_clear_num(const struct sparsebit *sbit,
 					 sparsebit_idx_t start, sparsebit_num_t num);
 
 void sparsebit_set(struct sparsebit *sbitp, sparsebit_idx_t idx);
@@ -62,9 +62,9 @@ void sparsebit_clear_num(struct sparsebit *sbitp,
 			 sparsebit_idx_t start, sparsebit_num_t num);
 void sparsebit_clear_all(struct sparsebit *sbitp);
 
-void sparsebit_dump(FILE *stream, struct sparsebit *sbit,
+void sparsebit_dump(FILE *stream, const struct sparsebit *sbit,
 		    unsigned int indent);
-void sparsebit_validate_internal(struct sparsebit *sbit);
+void sparsebit_validate_internal(const struct sparsebit *sbit);
 
 #ifdef __cplusplus
 }
diff --git a/tools/testing/selftests/kvm/lib/sparsebit.c b/tools/testing/selftests/kvm/lib/sparsebit.c
index 50e0cf41a7dd..6777a5b1fbd2 100644
--- a/tools/testing/selftests/kvm/lib/sparsebit.c
+++ b/tools/testing/selftests/kvm/lib/sparsebit.c
@@ -202,7 +202,7 @@ static sparsebit_num_t node_num_set(struct node *nodep)
 /* Returns a pointer to the node that describes the
  * lowest bit index.
  */
-static struct node *node_first(struct sparsebit *s)
+static struct node *node_first(const struct sparsebit *s)
 {
 	struct node *nodep;
 
@@ -216,7 +216,7 @@ static struct node *node_first(struct sparsebit *s)
  * lowest bit index > the index of the node pointed to by np.
  * Returns NULL if no node with a higher index exists.
  */
-static struct node *node_next(struct sparsebit *s, struct node *np)
+static struct node *node_next(const struct sparsebit *s, struct node *np)
 {
 	struct node *nodep = np;
 
@@ -244,7 +244,7 @@ static struct node *node_next(struct sparsebit *s, struct node *np)
  * highest index < the index of the node pointed to by np.
  * Returns NULL if no node with a lower index exists.
  */
-static struct node *node_prev(struct sparsebit *s, struct node *np)
+static struct node *node_prev(const struct sparsebit *s, struct node *np)
 {
 	struct node *nodep = np;
 
@@ -273,7 +273,7 @@ static struct node *node_prev(struct sparsebit *s, struct node *np)
  * subtree and duplicates the bit settings to the newly allocated nodes.
  * Returns the newly allocated copy of subtree.
  */
-static struct node *node_copy_subtree(struct node *subtree)
+static struct node *node_copy_subtree(const struct node *subtree)
 {
 	struct node *root;
 
@@ -307,7 +307,7 @@ static struct node *node_copy_subtree(struct node *subtree)
  * index is within the bits described by the mask bits or the number of
  * contiguous bits set after the mask.  Returns NULL if there is no such node.
  */
-static struct node *node_find(struct sparsebit *s, sparsebit_idx_t idx)
+static struct node *node_find(const struct sparsebit *s, sparsebit_idx_t idx)
 {
 	struct node *nodep;
 
@@ -393,7 +393,7 @@ static struct node *node_add(struct sparsebit *s, sparsebit_idx_t idx)
 }
 
 /* Returns whether all the bits in the sparsebit array are set.  */
-bool sparsebit_all_set(struct sparsebit *s)
+bool sparsebit_all_set(const struct sparsebit *s)
 {
 	/*
 	 * If any nodes there must be at least one bit set.  Only case
@@ -776,7 +776,7 @@ static void node_reduce(struct sparsebit *s, struct node *nodep)
 /* Returns whether the bit at the index given by idx, within the
  * sparsebit array is set or not.
  */
-bool sparsebit_is_set(struct sparsebit *s, sparsebit_idx_t idx)
+bool sparsebit_is_set(const struct sparsebit *s, sparsebit_idx_t idx)
 {
 	struct node *nodep;
 
@@ -922,7 +922,7 @@ static inline sparsebit_idx_t node_first_clear(struct node *nodep, int start)
  * used by test cases after they detect an unexpected condition, as a means
  * to capture diagnostic information.
  */
-static void sparsebit_dump_internal(FILE *stream, struct sparsebit *s,
+static void sparsebit_dump_internal(FILE *stream, const struct sparsebit *s,
 	unsigned int indent)
 {
 	/* Dump the contents of s */
@@ -970,7 +970,7 @@ void sparsebit_free(struct sparsebit **sbitp)
  * sparsebit_alloc().  It can though already have bits set, which
  * if different from src will be cleared.
  */
-void sparsebit_copy(struct sparsebit *d, struct sparsebit *s)
+void sparsebit_copy(struct sparsebit *d, const struct sparsebit *s)
 {
 	/* First clear any bits already set in the destination */
 	sparsebit_clear_all(d);
@@ -982,7 +982,7 @@ void sparsebit_copy(struct sparsebit *d, struct sparsebit *s)
 }
 
 /* Returns whether num consecutive bits starting at idx are all set.  */
-bool sparsebit_is_set_num(struct sparsebit *s,
+bool sparsebit_is_set_num(const struct sparsebit *s,
 	sparsebit_idx_t idx, sparsebit_num_t num)
 {
 	sparsebit_idx_t next_cleared;
@@ -1006,14 +1006,14 @@ bool sparsebit_is_set_num(struct sparsebit *s,
 }
 
 /* Returns whether the bit at the index given by idx.  */
-bool sparsebit_is_clear(struct sparsebit *s,
+bool sparsebit_is_clear(const struct sparsebit *s,
 	sparsebit_idx_t idx)
 {
 	return !sparsebit_is_set(s, idx);
 }
 
 /* Returns whether num consecutive bits starting at idx are all cleared.  */
-bool sparsebit_is_clear_num(struct sparsebit *s,
+bool sparsebit_is_clear_num(const struct sparsebit *s,
 	sparsebit_idx_t idx, sparsebit_num_t num)
 {
 	sparsebit_idx_t next_set;
@@ -1042,13 +1042,13 @@ bool sparsebit_is_clear_num(struct sparsebit *s,
  * value.  Use sparsebit_any_set(), instead of sparsebit_num_set() > 0,
  * to determine if the sparsebit array has any bits set.
  */
-sparsebit_num_t sparsebit_num_set(struct sparsebit *s)
+sparsebit_num_t sparsebit_num_set(const struct sparsebit *s)
 {
 	return s->num_set;
 }
 
 /* Returns whether any bit is set in the sparsebit array.  */
-bool sparsebit_any_set(struct sparsebit *s)
+bool sparsebit_any_set(const struct sparsebit *s)
 {
 	/*
 	 * Nodes only describe set bits.  If any nodes then there
@@ -1071,20 +1071,20 @@ bool sparsebit_any_set(struct sparsebit *s)
 }
 
 /* Returns whether all the bits in the sparsebit array are cleared.  */
-bool sparsebit_all_clear(struct sparsebit *s)
+bool sparsebit_all_clear(const struct sparsebit *s)
 {
 	return !sparsebit_any_set(s);
 }
 
 /* Returns whether all the bits in the sparsebit array are set.  */
-bool sparsebit_any_clear(struct sparsebit *s)
+bool sparsebit_any_clear(const struct sparsebit *s)
 {
 	return !sparsebit_all_set(s);
 }
 
 /* Returns the index of the first set bit.  Abort if no bits are set.
  */
-sparsebit_idx_t sparsebit_first_set(struct sparsebit *s)
+sparsebit_idx_t sparsebit_first_set(const struct sparsebit *s)
 {
 	struct node *nodep;
 
@@ -1098,7 +1098,7 @@ sparsebit_idx_t sparsebit_first_set(struct sparsebit *s)
 /* Returns the index of the first cleared bit.  Abort if
  * no bits are cleared.
  */
-sparsebit_idx_t sparsebit_first_clear(struct sparsebit *s)
+sparsebit_idx_t sparsebit_first_clear(const struct sparsebit *s)
 {
 	struct node *nodep1, *nodep2;
 
@@ -1152,7 +1152,7 @@ sparsebit_idx_t sparsebit_first_clear(struct sparsebit *s)
 /* Returns index of next bit set within s after the index given by prev.
  * Returns 0 if there are no bits after prev that are set.
  */
-sparsebit_idx_t sparsebit_next_set(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_set(const struct sparsebit *s,
 	sparsebit_idx_t prev)
 {
 	sparsebit_idx_t lowest_possible = prev + 1;
@@ -1245,7 +1245,7 @@ sparsebit_idx_t sparsebit_next_set(struct sparsebit *s,
 /* Returns index of next bit cleared within s after the index given by prev.
  * Returns 0 if there are no bits after prev that are cleared.
  */
-sparsebit_idx_t sparsebit_next_clear(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_clear(const struct sparsebit *s,
 	sparsebit_idx_t prev)
 {
 	sparsebit_idx_t lowest_possible = prev + 1;
@@ -1301,7 +1301,7 @@ sparsebit_idx_t sparsebit_next_clear(struct sparsebit *s,
  * and returns the index of the first sequence of num consecutively set
  * bits.  Returns a value of 0 of no such sequence exists.
  */
-sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_set_num(const struct sparsebit *s,
 	sparsebit_idx_t start, sparsebit_num_t num)
 {
 	sparsebit_idx_t idx;
@@ -1336,7 +1336,7 @@ sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *s,
  * and returns the index of the first sequence of num consecutively cleared
  * bits.  Returns a value of 0 of no such sequence exists.
  */
-sparsebit_idx_t sparsebit_next_clear_num(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_clear_num(const struct sparsebit *s,
 	sparsebit_idx_t start, sparsebit_num_t num)
 {
 	sparsebit_idx_t idx;
@@ -1584,7 +1584,7 @@ static size_t display_range(FILE *stream, sparsebit_idx_t low,
  * contiguous bits.  This is done because '-' is used to specify command-line
  * options, and sometimes ranges are specified as command-line arguments.
  */
-void sparsebit_dump(FILE *stream, struct sparsebit *s,
+void sparsebit_dump(FILE *stream, const struct sparsebit *s,
 	unsigned int indent)
 {
 	size_t current_line_len = 0;
@@ -1682,7 +1682,7 @@ void sparsebit_dump(FILE *stream, struct sparsebit *s,
  * s.  On error, diagnostic information is printed to stderr and
  * abort is called.
  */
-void sparsebit_validate_internal(struct sparsebit *s)
+void sparsebit_validate_internal(const struct sparsebit *s)
 {
 	bool error_detected = false;
 	struct node *nodep, *prev = NULL;
-- 
2.39.0.314.g84b9a713c41-goog

