Return-Path: <kvm+bounces-71450-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4BxOMn38m2kC+wMAu9opvQ
	(envelope-from <kvm+bounces-71450-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:06:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 367C817287A
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 08:06:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F8BA3047427
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 07:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3253734C121;
	Mon, 23 Feb 2026 07:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4RXnl+HE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D073431E7
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 07:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771830295; cv=none; b=kdq7FmXzZwkZDTx5J2q/6sWudndINapR/jGd/7LCdb3L3Zz+f/d/hbG6lFXS0vhUau31zF5EAV8g0au5Ut1qtVTZy6qcCo748rO593zCm+XmiTiCfMV5ioeSPmfxcjm4cvqAB1nGhR0wcXHNrMrHi0hBKNAtnu/p11nXORmQ/Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771830295; c=relaxed/simple;
	bh=jh3ZPt1ZHay6YAxI3Ut5XTGeyxbcY4vqjvfPdGHfjT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PLpp3u4BrBcdE/jRAlD5jDssTG9oLWGmpyMzlB0XJBePMTlW7U5reRXoFIYXNfbx2S0IfJ0RREZZrqqfI6F87eluKUdACTR1NOnIEJb0yomJNGXcC6iIxU0AUuyqX7epGRSaGDCMbL3Gi3A85liulGPydUvnhtZupWjbUFx9PdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4RXnl+HE; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3568090851aso30162450a91.1
        for <kvm@vger.kernel.org>; Sun, 22 Feb 2026 23:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830294; x=1772435094; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MlhRSEkvP3hGcg7973jpELqHCKZWjzo4VY3xzNikZZA=;
        b=4RXnl+HEPFnYO5Abb98HyOUyEyvgMNxGXNkjFN7oZF6nmEbTgWz81nIucB7bUElkX7
         5y23GohWVyovdZJ1B0GN0az6qP19WSWNMXuRWYfDUEWOYHJBP8+1IMj8+JVSuPJ2pgoC
         2jNwM7rpA6SgNxVxhmshMmI8si7nexMt6sn2k9oC4oAazEOTkZFXs5rBApjfpcabPy62
         0Tv+QJthomyh4D4iDfNmv13TzyPzEk3p0RVkePNX/uL66V73+KpPxa8m+Zb007jXNgJd
         mmrtbozRBGPiqyDQluo0nl696OmZhVKZpkgda6Ropg1FoCiyETZs4UWzu12N4HUWhjkK
         rnhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830294; x=1772435094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MlhRSEkvP3hGcg7973jpELqHCKZWjzo4VY3xzNikZZA=;
        b=kVWE5IKx2txZi3oi5Ay7Cj/4tFHpCoS55e10xpxJ1AhWFtbAP9TTP0UhfKUgr0VFlc
         OB7/2waXddIwiGShy0i1cLU/i8LoksMl0D7g6GYYUYHpBG4GTsCQtF/gpBKEQOdR9Atb
         ViWka0VYpW0N5mQ7BWjQj0FBvj4m45hmDoAlper5KKODnFYzytVQG1KMibdCrawMhG61
         eBNs9tHUf5yTRFJRxtRZbOeDT5U4kkf9jDQ+/Q16HAb6LMUjgHa/ISn8xIRua3OBCovT
         UJCaDtyHk40f1fdQXjCeAa9Zt94oYhPmblPLhUgdhLkRpF9BVptMUiHBBaHtAHLJl+x+
         wDhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVE2FCwTsDOotm3pHDakzX9vBxxvRGAcz/PDQuN0+ri3Hs7PKjOMO9FgA2Tz9UoNE5RCns=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7Ls5OHnK5vh5TgXVUcihCETO2ZdnLpnOiixxWxBI0HOXy6BFT
	4tYRK6htnjRtPvPG1kZuY8djf0dq9DwgZY6hop9MqfBYtP6+8O0KGzde0FCncVadKPd67jFIGiG
	3tK2YZG8kJ253GwK4HeySmgRT9A==
X-Received: from pjbjz17.prod.google.com ([2002:a17:90b:14d1:b0:354:7c70:1a9])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e0a4:b0:393:f002:ff59 with SMTP id adf61e73a8af0-39545e91cd1mr6474154637.19.1771830293252;
 Sun, 22 Feb 2026 23:04:53 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:35 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <3e363901b177d8c2ae5088cfaeb3862621bbce9b.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 02/10] KVM: guest_memfd: Directly allocate folios with filemap_alloc_folio()
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71450-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[30];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 367C817287A
X-Rspamd-Action: no action

__filemap_get_folio_mpol() is parametrized by a bunch of GFP flags, which
adds complexity for the reader. Since guest_memfd doesn't meaningfully use
any of the other FGP flags, undo that complexity by directly calling
filemap_alloc_folio().

Directly calling filemap_alloc_folio() also allows the order of 0 to be
explicitly specified, which is the only order guest_memfd supports. This is
easier to understand, and removes the chance of anything else being able to
unintentionally influence allocated folio size.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 51 +++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2df27b6443115..2488d7b8f2b0d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -107,6 +107,39 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
 }
 
+static struct folio *__kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+{
+	/* TODO: Support huge pages. */
+	struct mempolicy *policy;
+	struct folio *folio;
+	gfp_t gfp;
+	int ret;
+
+	/*
+	 * Fast-path: See if folio is already present in mapping to avoid
+	 * policy_lookup.
+	 */
+	folio = filemap_lock_folio(inode->i_mapping, index);
+	if (!IS_ERR(folio))
+		return folio;
+
+	gfp = mapping_gfp_mask(inode->i_mapping);
+
+	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
+	folio = filemap_alloc_folio(gfp, 0, policy);
+	mpol_cond_put(policy);
+	if (!folio)
+		return ERR_PTR(-ENOMEM);
+
+	ret = filemap_add_folio(inode->i_mapping, folio, index, gfp);
+	if (ret) {
+		folio_put(folio);
+		return ERR_PTR(ret);
+	}
+
+	return folio;
+}
+
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -118,23 +151,11 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
  */
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 {
-	/* TODO: Support huge pages. */
-	struct mempolicy *policy;
 	struct folio *folio;
 
-	/*
-	 * Fast-path: See if folio is already present in mapping to avoid
-	 * policy_lookup.
-	 */
-	folio = filemap_lock_folio(inode->i_mapping, index);
-	if (!IS_ERR(folio))
-		return folio;
-
-	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
-	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
-					 FGP_LOCK | FGP_CREAT,
-					 mapping_gfp_mask(inode->i_mapping), policy);
-	mpol_cond_put(policy);
+	do {
+		folio = __kvm_gmem_get_folio(inode, index);
+	} while (PTR_ERR(folio) == -EEXIST);
 
 	/*
 	 * External interfaces like kvm_gmem_get_pfn() support dealing
-- 
2.53.0.345.g96ddfc5eaa-goog


