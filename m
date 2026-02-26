Return-Path: <kvm+bounces-71977-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KN8VGs9UoGlLiQQAu9opvQ
	(envelope-from <kvm+bounces-71977-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:12:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AE3D1A7470
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 15:12:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 644A6315A047
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 13:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9033A0EB1;
	Thu, 26 Feb 2026 13:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="fKpF0e/z"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B4C39A810
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 13:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.68.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772114036; cv=none; b=SjXGeTiuzFbXal+fj8ZwNSunwW9Bbmsrd9gWW81CWvTVHgllh8fkW15K/3K+pGLZlFYBB70PqCy3ZXvgbY1H+1HIJsqX4mj6aya8Z0BsQVhLnAuNLpRJ5ZsNWgUAbxgP2/IX+DB4QGmx3/CzPdGFQIWktcltwIZs/0U4vuUIfuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772114036; c=relaxed/simple;
	bh=BfdWcCc4DQwq6SV4HDFHF8CQOgoG4ofMKlY5HLQ0wOw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDJsidvtRinnM33mZlritZABPfNvJ2IGe+8K0CbqhqqHreYkXxJMKENYgBzGd94fd2LhUHUTFQp+i+pcYSKJkOfYv7vmuF9qthOlpzsq5iNV9huPnbUXH1Pa7n3/yb09Ttk7FNFzVdTfKvlE0/eaaee7lbVS7FL4yh4wEzKD5JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=fKpF0e/z; arc=none smtp.client-ip=44.246.68.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772114031; x=1803650031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7WbOIVc+TbDZEw/Q4kSpN9AtNmGX8m86zsMOB+5RjeY=;
  b=fKpF0e/z8JuslASOTrWhDBMdfQX0btSa66Z0CEchyKzkxvncqEl5O402
   R/fef2ce+Y2zbKng+f/JvPqxOu4S1IW7fOCUi1LMShzgxFI0XPeaE2Tb7
   bPTAmFDIkUn+H/lh+TYhG4Vqn5JJFKHmOv+jKeK4Fs6EdCiB6ll/Pwp2h
   xzxUtCJibxB2NBfEhmEH+T9Awwm/TEk2nw1y2rCiRHQG56gJSiI/qcFcn
   NN2Ewe+m+fZMVwyaiDO2rXH1rD93VDPZa1o3sFTY+0jecnHeVsmtlqYSN
   uxA9GVQrcpkOXc1HMl70Q8NrHHl58PfCsmTSY5ChFmS3y6/c0BQ7k/f4N
   w==;
X-CSE-ConnectionGUID: 1khp8cqmSnKQefNu/5EgFw==
X-CSE-MsgGUID: 6RangPUxRwi1vkD45/nbWg==
X-IronPort-AV: E=Sophos;i="6.21,312,1763424000"; 
   d="scan'208";a="13869323"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:53:48 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.105:16398]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.33.152:2525] with esmtp (Farcaster)
 id 6d87129d-0b84-4a83-a8f5-aaec4f48364d; Thu, 26 Feb 2026 13:53:48 +0000 (UTC)
X-Farcaster-Flow-ID: 6d87129d-0b84-4a83-a8f5-aaec4f48364d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:48 +0000
Received: from dev-dsk-itazur-1b-11e7fc0f.eu-west-1.amazon.com (172.19.66.53)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 26 Feb 2026 13:53:45 +0000
From: Takahiro Itazuri <itazur@amazon.com>
To: <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Fuad Tabba <tabba@google.com>,
	Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, Paul Durrant <pdurrant@amazon.com>,
	Nikita Kalyazin <kalyazin@amazon.com>, Patrick Roy
	<patrick.roy@campus.lmu.de>, Takahiro Itazuri <zulinx86@gmail.com>
Subject: [RFC PATCH v2 5/7] KVM: pfncache: Rename invalidate_start() helper
Date: Thu, 26 Feb 2026 13:53:06 +0000
Message-ID: <20260226135309.29493-6-itazur@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226135309.29493-1-itazur@amazon.com>
References: <20260226135309.29493-1-itazur@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,google.com,kernel.org,infradead.org,amazon.com,campus.lmu.de,gmail.com];
	TAGGED_FROM(0.00)[bounces-71977-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[itazur@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 0AE3D1A7470
X-Rspamd-Action: no action

Rename gfn_to_pfn_cache_invalidate_start() to
gpc_invalidate_hva_range_start() to explicitly indicate that it takes a
range of HVA range.

No functional changes intended.

Signed-off-by: Takahiro Itazuri <itazur@amazon.com>
---
 virt/kvm/kvm_main.c |  2 +-
 virt/kvm/kvm_mm.h   | 12 ++++++------
 virt/kvm/pfncache.c |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5871882ff1db..d64e70f8e8e3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -763,7 +763,7 @@ static int kvm_mmu_notifier_invalidate_range_start(stru=
ct mmu_notifier *mn,
 	 * mn_active_invalidate_count (see above) instead of
 	 * mmu_invalidate_in_progress.
 	 */
-	gfn_to_pfn_cache_invalidate_start(kvm, range->start, range->end);
+	gpc_invalidate_hva_range_start(kvm, range->start, range->end);
=20
 	/*
 	 * If one or more memslots were found and thus zapped, notify arch code
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 9fcc5d5b7f8d..abd8e7d33ab0 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -56,13 +56,13 @@ struct kvm_follow_pfn {
 kvm_pfn_t hva_to_pfn(struct kvm_follow_pfn *kfp);
=20
 #ifdef CONFIG_HAVE_KVM_PFNCACHE
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
-				       unsigned long start,
-				       unsigned long end);
+void gpc_invalidate_hva_range_start(struct kvm *kvm,
+				    unsigned long start,
+				    unsigned long end);
 #else
-static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
-						     unsigned long start,
-						     unsigned long end)
+static inline void gpc_invalidate_hva_range_start(struct kvm *kvm,
+						  unsigned long start,
+						  unsigned long end)
 {
 }
 #endif /* HAVE_KVM_PFNCACHE */
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 531adc4dcb11..3ff8251727e2 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -23,8 +23,8 @@
 /*
  * MMU notifier 'invalidate_range_start' hook.
  */
-void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long star=
t,
-				       unsigned long end)
+void gpc_invalidate_hva_range_start(struct kvm *kvm, unsigned long start,
+				    unsigned long end)
 {
 	struct gfn_to_pfn_cache *gpc;
=20
--=20
2.50.1


