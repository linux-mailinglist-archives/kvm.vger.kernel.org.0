Return-Path: <kvm+bounces-4735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CC4817718
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 17:13:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03B0F285517
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 16:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C38414FF77;
	Mon, 18 Dec 2023 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mkk6nrL4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73018498A8
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--pgonda.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e74c97832aso4439457b3.2
        for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702915950; x=1703520750; darn=vger.kernel.org;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=teKIIGiquHq+1YOg1okkWYa610kfWCGwfg6B3Yy0FU8=;
        b=mkk6nrL4LQyte+H18tRFtDCD9RXy2gWJM1xSTGqSM6/5JnFsQgPSavsaxAY0bLszei
         hU6COGaqDAk+ir1x835lNf9VFI+V1V2gps2l9KnzIa7jxdps3/dYorDHMZm3DpwpxvAU
         bk6mpqOYZclc3LFSU8Z6YhDBGByVea9MyX0wxHZ3NAUrXpyGQhgm1d+ykrDkcQBAFHex
         Qzz8VlfqYnjG8uEbrscCTzmjJWh4Q98hRbRX5/XJxoSInMJn6ZfI7DWqPSt3CY8pfLan
         zduagbbDtD+DskUJ3F2351mOV5EE+mwo8ok7v8oAcwwAPh9J71UaYKT7Z9jsT1FnuDNM
         Yh9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702915950; x=1703520750;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=teKIIGiquHq+1YOg1okkWYa610kfWCGwfg6B3Yy0FU8=;
        b=R4ZIC94IFnyPBtqN8pNLtXliwgEI7Vof8eAOkShtbIdvnvjfpYw71CXM1hl2ybsl9F
         u3eG7vOUvujw2dn0RSPo+BJ6ifXlPfmrG4mwOUSYfTxZP1Tbs0a+89B+jvkC91uDGsqf
         7YArfCWU7mcBWeacWS21ysl3nrv5AMHBECJIwoWnQCRUBiDbDXj+4mrHteSJLgvxAeJ+
         yBDbX5rGYq2s8I57lRvZh/BrHQhuQ+NRrWbhyvFSKTSvYgoHfDQD8W30gdOJMwaUHU4D
         MWvrGkYiwfEckrXPo5PbfCR8I7p6N+R3emDIL0aHywVS2Y0m8K/i99FLq707xVTP+z3S
         tN9A==
X-Gm-Message-State: AOJu0Yzoc3OGEpNn7BIlGD4SBLVIvVzmpOHzPM/6eVT1jmSTOwwBtatM
	FzDpdcv4SrNkYmDGLmfWw5MezMVQlkJR9ggzF+glJ5IdFclYWX22zLLWHOfxqPJdacTiAiKI+9S
	nP4S8wXP/PkAsmxz813P66bmO5N1U6h+jpXpg/lYNqFwhYr7Q1/l/9dHSlQ==
X-Google-Smtp-Source: AGHT+IHHJ/h1id6QM5gTHv8R0WCtorYqxwTKhy6PdHSwH0fhR0UFNjc180YRqc/0P4Sg9gIgccqH5YukuZg=
X-Received: from pgonda1.kir.corp.google.com ([2620:0:1008:15:8aeb:e3fa:237c:63a5])
 (user=pgonda job=sendgmr) by 2002:a05:690c:10c:b0:5e6:1e40:e2e3 with SMTP id
 bd12-20020a05690c010c00b005e61e40e2e3mr964727ywb.5.1702915950328; Mon, 18 Dec
 2023 08:12:30 -0800 (PST)
Date: Mon, 18 Dec 2023 08:11:40 -0800
In-Reply-To: <20231218161146.3554657-1-pgonda@google.com>
Message-Id: <20231218161146.3554657-3-pgonda@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231218161146.3554657-1-pgonda@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Subject: [PATCH V7 2/8] KVM: selftests: Make sparsebit structs const where appropriate
From: Peter Gonda <pgonda@google.com>
To: kvm@vger.kernel.org
Cc: Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Andrew Jones <andrew.jones@linux.dev>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Michael Roth <michael.roth@amd.com>

Subsequent patches will introduce an encryption bitmap in kvm_util that
would be useful to allow tests to access in read-only fashion. This
will be done via a const sparsebit*. To avoid warnings or the need to
add casts everywhere, add const to the various sparsebit functions that
are applicable for read-only usage of sparsebit.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
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
index 88cb6b84e6f3..cfed9d26cc71 100644
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
@@ -775,7 +775,7 @@ static void node_reduce(struct sparsebit *s, struct node *nodep)
 /* Returns whether the bit at the index given by idx, within the
  * sparsebit array is set or not.
  */
-bool sparsebit_is_set(struct sparsebit *s, sparsebit_idx_t idx)
+bool sparsebit_is_set(const struct sparsebit *s, sparsebit_idx_t idx)
 {
 	struct node *nodep;
 
@@ -921,7 +921,7 @@ static inline sparsebit_idx_t node_first_clear(struct node *nodep, int start)
  * used by test cases after they detect an unexpected condition, as a means
  * to capture diagnostic information.
  */
-static void sparsebit_dump_internal(FILE *stream, struct sparsebit *s,
+static void sparsebit_dump_internal(FILE *stream, const struct sparsebit *s,
 	unsigned int indent)
 {
 	/* Dump the contents of s */
@@ -969,7 +969,7 @@ void sparsebit_free(struct sparsebit **sbitp)
  * sparsebit_alloc().  It can though already have bits set, which
  * if different from src will be cleared.
  */
-void sparsebit_copy(struct sparsebit *d, struct sparsebit *s)
+void sparsebit_copy(struct sparsebit *d, const struct sparsebit *s)
 {
 	/* First clear any bits already set in the destination */
 	sparsebit_clear_all(d);
@@ -981,7 +981,7 @@ void sparsebit_copy(struct sparsebit *d, struct sparsebit *s)
 }
 
 /* Returns whether num consecutive bits starting at idx are all set.  */
-bool sparsebit_is_set_num(struct sparsebit *s,
+bool sparsebit_is_set_num(const struct sparsebit *s,
 	sparsebit_idx_t idx, sparsebit_num_t num)
 {
 	sparsebit_idx_t next_cleared;
@@ -1005,14 +1005,14 @@ bool sparsebit_is_set_num(struct sparsebit *s,
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
@@ -1041,13 +1041,13 @@ bool sparsebit_is_clear_num(struct sparsebit *s,
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
@@ -1070,20 +1070,20 @@ bool sparsebit_any_set(struct sparsebit *s)
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
 
@@ -1097,7 +1097,7 @@ sparsebit_idx_t sparsebit_first_set(struct sparsebit *s)
 /* Returns the index of the first cleared bit.  Abort if
  * no bits are cleared.
  */
-sparsebit_idx_t sparsebit_first_clear(struct sparsebit *s)
+sparsebit_idx_t sparsebit_first_clear(const struct sparsebit *s)
 {
 	struct node *nodep1, *nodep2;
 
@@ -1151,7 +1151,7 @@ sparsebit_idx_t sparsebit_first_clear(struct sparsebit *s)
 /* Returns index of next bit set within s after the index given by prev.
  * Returns 0 if there are no bits after prev that are set.
  */
-sparsebit_idx_t sparsebit_next_set(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_set(const struct sparsebit *s,
 	sparsebit_idx_t prev)
 {
 	sparsebit_idx_t lowest_possible = prev + 1;
@@ -1244,7 +1244,7 @@ sparsebit_idx_t sparsebit_next_set(struct sparsebit *s,
 /* Returns index of next bit cleared within s after the index given by prev.
  * Returns 0 if there are no bits after prev that are cleared.
  */
-sparsebit_idx_t sparsebit_next_clear(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_clear(const struct sparsebit *s,
 	sparsebit_idx_t prev)
 {
 	sparsebit_idx_t lowest_possible = prev + 1;
@@ -1300,7 +1300,7 @@ sparsebit_idx_t sparsebit_next_clear(struct sparsebit *s,
  * and returns the index of the first sequence of num consecutively set
  * bits.  Returns a value of 0 of no such sequence exists.
  */
-sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_set_num(const struct sparsebit *s,
 	sparsebit_idx_t start, sparsebit_num_t num)
 {
 	sparsebit_idx_t idx;
@@ -1335,7 +1335,7 @@ sparsebit_idx_t sparsebit_next_set_num(struct sparsebit *s,
  * and returns the index of the first sequence of num consecutively cleared
  * bits.  Returns a value of 0 of no such sequence exists.
  */
-sparsebit_idx_t sparsebit_next_clear_num(struct sparsebit *s,
+sparsebit_idx_t sparsebit_next_clear_num(const struct sparsebit *s,
 	sparsebit_idx_t start, sparsebit_num_t num)
 {
 	sparsebit_idx_t idx;
@@ -1583,7 +1583,7 @@ static size_t display_range(FILE *stream, sparsebit_idx_t low,
  * contiguous bits.  This is done because '-' is used to specify command-line
  * options, and sometimes ranges are specified as command-line arguments.
  */
-void sparsebit_dump(FILE *stream, struct sparsebit *s,
+void sparsebit_dump(FILE *stream, const struct sparsebit *s,
 	unsigned int indent)
 {
 	size_t current_line_len = 0;
@@ -1681,7 +1681,7 @@ void sparsebit_dump(FILE *stream, struct sparsebit *s,
  * s.  On error, diagnostic information is printed to stderr and
  * abort is called.
  */
-void sparsebit_validate_internal(struct sparsebit *s)
+void sparsebit_validate_internal(const struct sparsebit *s)
 {
 	bool error_detected = false;
 	struct node *nodep, *prev = NULL;
-- 
2.43.0.472.g3155946c3a-goog


