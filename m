Return-Path: <kvm+bounces-70788-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Cq3CR+Si2kVWQAAu9opvQ
	(envelope-from <kvm+bounces-70788-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E92711EF3F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0EC8306343A
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:16:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264EE31AABA;
	Tue, 10 Feb 2026 20:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n4QqpDiT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44630334694
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754551; cv=none; b=GqusmFuoWKLAHIbqFB8E0HZgHUX9ob3TdFlixZudwbf03K49Ihb5VFIRb/C9Q6wIpH8gfox6NYl8IktdR/c4L3XFphnSG36W3fVJBEsR78YyCoscXoAHllQRNMBFczbtQhD9xj2FDqDj9RJ4xQ9+sfgnktYrSchczjrCDJTPsmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754551; c=relaxed/simple;
	bh=vq2c1rRSG0L4bWZMyy+WIYxOc6zrEcYn8r9S5+uf2bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEBCIvBwPAzu/b6/PFvG2JX5OpWn8IQI1YBCJyvtG46e6wNZmB/uwNhHHbyn0ULY5Yo65i3OUgM7dALGLc+y4TGCtiY3FhK0aH1hrsbrrnHBXdjek/NWcj/+nXUQTPB4Xp2xidnfhoQionPPKsCTuHwq3AnLUzxEtBnh0C6+qDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n4QqpDiT; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a95de4b5cbso39076855ad.1
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754550; x=1771359350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VA/qlQJvE8uq8B0wfP8QzURuC1Jx2blScgULUKFJUFo=;
        b=n4QqpDiTmv+cUmihdVIKo8cpCDdpTTo0PO8OOJreFRDyWS7F6UIiVt6U8Qj0BLJYWc
         0PptYqx3WMYu9cPl1tBsPtYoUikv4E397+OBrK3fK0gvlTGkb2O7zwe2/tODG4RdBgNO
         14Aiw+0pL/tzC/MrceP3aiq7O5QDTMFAm/WCXZuq51DzfNqoH4Tx313Kebdb+NzZ14r+
         LB5fwVCQofuoJuH5cWUguu6XAjNdSbpcikE/m8XRnur3w3n8jo7/249QBg+L4orTpx6N
         883HttaXE6AeyeKQ2QvDF/0RNWRt7iIUCO4CtAkHp4jgvZQWQVbdMbFz1BjSz1cQHoDy
         Akwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754550; x=1771359350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VA/qlQJvE8uq8B0wfP8QzURuC1Jx2blScgULUKFJUFo=;
        b=QDyhQovQYUSaCK7+npxTHVodWWTa7ZapWyVKlWdOTxCqOhv8McL9l1v0azGLuy2CKa
         cudkkvkaTV50Pf3HUFY68t7jE9HnGjJ2eBihN/vMFbD0IIxjhj2tITMS8u0N0jAGD4Qh
         AxOoBWl//5yNJJJFhvz3byVtGf+GyCtkjXXIJdtM7B4QQrfNijuZJ7EgJ2u04A8z2CK4
         V6XbASCuoISTaNDhVL8trSR/GIhTLIhWHCvqFLypJgKhpOyADWbH7TwHiYNEwUVPxkEq
         2NOFdsXlL50N5AjRybtLOA9Nxmc/FYUtS2HA+4VmSiqn//zx5MX/pYFqNBzowmSqysBP
         f62A==
X-Forwarded-Encrypted: i=1; AJvYcCX3e6HfGy21EYLErShz74iXg1OGuvZ8QGDYavsjuIH76KmNi+0lVDwchjd9YicR9cTuONc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4rfCqeYWEdB5DsfA5LlsOCkvRPuufEdUJPCdNEBikf78ijzK3
	Uo7zzrA1vkyT2Bk+gf6OmxbacP0V31guVERGq2GG8NgB76px4GtZNcdOA8UIJRIMnwU=
X-Gm-Gg: AZuq6aJWNskgFSwdkAvTPH3wVp+zEqR0qHcF8kJGaHqRPMKJ1tZEzsewyqEbFRrnjUn
	pqdIX9f33Wv3bX/6gL0oGJvq0UPywxiEE7YQFu86fKOkq+XGoMo37MQbK4oyJB1+7ZIph8i93Tc
	J3sTDu2y8DB7JfUVwCwYL8uyDQ0b4GqS40BmtCadmhROhrsJwJiuuTm7OwEW7l4qTe6bvrTLVMv
	MixWYetV26EWNRlYVrJd/rP+HdvEI34wA1KR6QKO9h5wmZ7V/dW6T8xiuJ+7+oXvavCaWXsdPK4
	TyqhSwxFbr0oYd9O7yPeC9jzRrYp5LjVod6fV3MSGUEiZXMR1h3YoF7gt/UafX6eh8o7Tmi6Kfo
	Fk1G3+EIvAfnOiFth3gEsQGd6UZ5ePQPrGxg2IXVj0djjEiqMH2Md5Y3pOhAPIs/lPqmz8OCUN9
	66vjktS4I+8xFCdsFqvGs6VwDYPT4J9DIdn96lBBoukOD2VnS6dznGxuMF9KabkfRSJ+FcShMix
	p3pjRqmYzg0jc4=
X-Received: by 2002:a17:902:f601:b0:2a7:5751:5b30 with SMTP id d9443c01a7336-2ab10549744mr34280145ad.12.1770754549501;
        Tue, 10 Feb 2026 12:15:49 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:49 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 05/12] tcg: move tcg_use_softmmu to tcg/tcg-internal.h
Date: Tue, 10 Feb 2026 12:15:33 -0800
Message-ID: <20260210201540.1405424-6-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70788-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email,c.inc:url]
X-Rspamd-Queue-Id: 7E92711EF3F
X-Rspamd-Action: no action

In next commit, we'll apply same helper pattern for base helpers
remaining.

Our new helper pattern always include helper-*-common.h, which ends up
including include/tcg/tcg.h, which contains one occurrence of
CONFIG_USER_ONLY.
Thus, common files not being duplicated between system and target
relying on helpers will fail to compile. Existing occurrences are:
- target/arm/tcg/arith_helper.c
- target/arm/tcg/crypto_helper.c

This occurrence of CONFIG_USER_ONLY is for defining variable
tcg_use_softmmu, and we rely on dead code elimination with it in various
tcg-target.c.inc.

Thus, move its definition to tcg/tcg-internal.h, so helpers can be
included by common files. Also, change it to a define, as it has fixed
values for now.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/tcg/tcg.h  | 6 ------
 tcg/tcg-internal.h | 6 ++++++
 tcg/tcg.c          | 4 ----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/tcg/tcg.h b/include/tcg/tcg.h
index 60942ce05c2..45c7e118c3d 100644
--- a/include/tcg/tcg.h
+++ b/include/tcg/tcg.h
@@ -445,12 +445,6 @@ static inline bool temp_readonly(TCGTemp *ts)
     return ts->kind >= TEMP_FIXED;
 }
 
-#ifdef CONFIG_USER_ONLY
-extern bool tcg_use_softmmu;
-#else
-#define tcg_use_softmmu  true
-#endif
-
 extern __thread TCGContext *tcg_ctx;
 extern const void *tcg_code_gen_epilogue;
 extern uintptr_t tcg_splitwx_diff;
diff --git a/tcg/tcg-internal.h b/tcg/tcg-internal.h
index 2cbfb5d5caa..26156846120 100644
--- a/tcg/tcg-internal.h
+++ b/tcg/tcg-internal.h
@@ -34,6 +34,12 @@ extern TCGContext **tcg_ctxs;
 extern unsigned int tcg_cur_ctxs;
 extern unsigned int tcg_max_ctxs;
 
+#ifdef CONFIG_USER_ONLY
+#define tcg_use_softmmu false
+#else
+#define tcg_use_softmmu true
+#endif
+
 void tcg_region_init(size_t tb_size, int splitwx, unsigned max_threads);
 bool tcg_region_alloc(TCGContext *s);
 void tcg_region_initial_alloc(TCGContext *s);
diff --git a/tcg/tcg.c b/tcg/tcg.c
index e7bf4dad4ee..3111e1f4265 100644
--- a/tcg/tcg.c
+++ b/tcg/tcg.c
@@ -236,10 +236,6 @@ static TCGAtomAlign atom_and_align_for_opc(TCGContext *s, MemOp opc,
                                            MemOp host_atom, bool allow_two_ops)
     __attribute__((unused));
 
-#ifdef CONFIG_USER_ONLY
-bool tcg_use_softmmu;
-#endif
-
 TCGContext tcg_init_ctx;
 __thread TCGContext *tcg_ctx;
 
-- 
2.47.3


