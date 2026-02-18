Return-Path: <kvm+bounces-71284-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMqHN9FGlmmCdQIAu9opvQ
	(envelope-from <kvm+bounces-71284-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:10:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4028B15ACD8
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9770F301AF64
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 23:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E175933A9EB;
	Wed, 18 Feb 2026 23:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OUER1H17"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1724B338591
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 23:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771456203; cv=none; b=gJiNDp26CnnV37yEO0GRETocccWKm0ilzfLxlbGC/rsB/0gnBijHLUZFpP8zFxxvBr6Yk/ILzYaO9eSnvajdg3BEuculGFvFSWCAJ9qUl+PC2TEGuBWv4oQ/sHrbAl1zuoHMOjNG14zzARplyxk/Uii4lgz27KC9r8OEvP5teBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771456203; c=relaxed/simple;
	bh=MByk4hSAFbKkxC6i1yq2Mk8O9HmDoquRpiPer8jQF5c=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eTk/A8WO5XEnoIVulBtrDAXrzssGH69gf0UjTbO7aHN9Kii+7MHLlVgEFWbSbCGx2vqjPh7Vj83Wsoft9wNXWtGNYuSalp+dHC5UN74YHhbu9fSCQn5FCV07dwAsuycCiqGm8hDNOn+AC+2jBC+1qtY5zz4OPqeZon8U8YJ4TxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OUER1H17; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354bee18a62so217096a91.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 15:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771456201; x=1772061001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OWOINm3e3DPyYp+MALQrUc03EAsaMju3QEgs1Iy4qyc=;
        b=OUER1H17ntBUJKVKM8/c+oouoeJKmQiY62A/8T1Hd+xwJC99XjT27EEKNnIGPr72Hn
         xSwbeu8P4BJnpFUa+TOS1b/JaTyinqIvZl++1moGYPaAB5OUtqd1JlAB3GGuTA0/f3NP
         xKILw/BvIskh3QmPCMbPxwSTsi7aMeXvLmEUAMIF2sdECoY9GTpVK91okJVN6Y6CCf45
         yIXoHDnJRlFo4KiLi0PWLW0VbYGIcwBVgvECCEiSN8tQCVDkxIXKqfK/B73qE0kZq4tP
         Y6ipNSBLcHHwlcSDe18yobS26Bnj1fp2Etdmf5cijY9+VyouJz648Ryamjes0mlxXPTZ
         vkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771456201; x=1772061001;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OWOINm3e3DPyYp+MALQrUc03EAsaMju3QEgs1Iy4qyc=;
        b=wx5Hf1rsh2gGn5Ly5lQiDAcfURwUX8EUCulDDiI4iwC7K0noedfI90dBNj85wT8Xjd
         T89ZvyzykiqD/NxusA5A4GjJoYUwhLkOO/bE2kkh5ImUO10s/LtXHn7qOdj1pLQBWz0E
         Z3avOGDLyGa2LYZ3YMbs5Utklv2WS2gSjABUpr8Q2+XMCcdKQgCyOL2zqL9FoDx5C0ho
         P9yDRlbBqKDGFbL4U7v8IHHzYi9IWq69Ctxq7VBKhhpOh0uhOoKd6wdnUdoZwcKBwIBo
         SX7LGYl4c1/Ecf7Dp8pNA2ajHJx29e1u0q6MfniWYvntG7hUIqMP0NlTtcih3/imZerI
         Lqmg==
X-Gm-Message-State: AOJu0Yw/FpBZDuBXJUOK/vKKYy5dXPzUB57lQa8Z2kBcYiQun/pH56qZ
	lukNSLZQc5Hb4VvQ1GVWg1zeyg8kPDWeysIjNdmvllpwf99pTssfPnWCu1SDk3ZmRwFowxADX9i
	/p0OKBQ==
X-Received: from pjbfh6.prod.google.com ([2002:a17:90b:346:b0:34a:b3a0:78b9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524b:b0:356:22ef:57b9
 with SMTP id 98e67ed59e1d1-356aab969ffmr13504581a91.3.1771456201261; Wed, 18
 Feb 2026 15:10:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 18 Feb 2026 15:09:50 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260218230958.2877682-1-seanjc@google.com>
Subject: [PATCH v2 0/8] KVM: SVM: A fix and cleanups for VMCB intercepts
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71284-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 4028B15ACD8
X-Rspamd-Action: no action

Fix a likely-benign bug where KVM fails to mark vmcb01 intercepts as dirty
after recalculating intercepts while L2 is active, then do a bunch of related
cleanup, e.g. to split recalc_intercepts() into nested vs. non-nested
functionality.

v2:
 - Fix the aforementioned bug.
 - Split recalc_intercepts() instead of simply renaming it.
 - Move the new WARN in nested_vmcb02_recalc_intercepts() to its own patch.
 - Use less weird local variables even if they aren't consistent with the
   existing code...
 - ... and then change some names in the existing code to provide consistency.

v1: https://lkml.kernel.org/r/20260112182022.771276-1-yosry.ahmed%40linux.dev

Sean Christopherson (6):
  KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
  KVM: SVM: Separate recalc_intercepts() into nested vs. non-nested
    parts
  KVM: nSVM: Directly (re)calc vmcb02 intercepts from
    nested_vmcb02_prepare_control()
  KVM: nSVM: Use intuitive local variables in
    nested_vmcb02_recalc_intercepts()
  KVM: nSVM: Move vmcb_ctrl_area_cached.bus_lock_rip to svm_nested_state
  KVM: nSVM: Capture svm->nested.ctl as vmcb12_ctrl when preparing
    vmcb02

Yosry Ahmed (2):
  KVM: nSVM: WARN and abort vmcb02 intercepts recalc if vmcb02 isn't
    active
  KVM: nSVM: Use vmcb12_is_intercept() in
    nested_sync_control_from_vmcb02()

 arch/x86/kvm/svm/nested.c | 88 +++++++++++++++++++--------------------
 arch/x86/kvm/svm/sev.c    |  2 +-
 arch/x86/kvm/svm/svm.c    |  6 +--
 arch/x86/kvm/svm/svm.h    | 28 +++++++++----
 4 files changed, 67 insertions(+), 57 deletions(-)


base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
-- 
2.53.0.345.g96ddfc5eaa-goog


