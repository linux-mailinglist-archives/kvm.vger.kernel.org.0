Return-Path: <kvm+bounces-11087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5E7872C00
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 02:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ED40CB26D4F
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CC896FD0;
	Wed,  6 Mar 2024 01:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="CUyDawRL"
X-Original-To: kvm@vger.kernel.org
Received: from crocodile.elm.relay.mailchannels.net (crocodile.elm.relay.mailchannels.net [23.83.212.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586AD173
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 01:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.212.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709687626; cv=pass; b=gRqGm1/6hkLyAxLrYBQw9r3vEorTbGqTgdDEHEuA60OO3L4LjT9QTKt5IkZ7XKKEPfdxKmwr990bKF6ATRxU8LnQlBkry0E2ATy5SBEsqD20wxM+332h2mg5khCV2k7ZBLIr7Tj3M1JXl6+qmpYSuBnoflIapWNY2Vu7R5IsJBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709687626; c=relaxed/simple;
	bh=HJle/GNNs09UVXorHkOiCGDS4/HVoyXE/hJOlYVCxmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knxdT0U7k7gQdcfk0lqYka97J6J+qSFtjcm+5MWXRqR4GgPcXRv+NHtt0uIxQJcRQsGJBoXtuyKFXLu+O5l9hda8/krjS5c7rHCMgUNDQXJPpP7R1dOsqNGVsQrsCX6APNT6rFHNkLPdl4Xw6U9FEYNbaveGG2Oy+MYScYt7pio=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=CUyDawRL; arc=pass smtp.client-ip=23.83.212.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 81CAE5414C0
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:49:51 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2269154157D
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:49:51 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1709686191; a=rsa-sha256;
	cv=none;
	b=cpGlcBhIkhrlLd+pmunN0Pp4D6WKmO3WDl02rJuM0NrOj/FJeLrthdQObS1sNjua11Gi1Q
	W1ENUY9+51Bg2jrHUtaTbifkT7dAkZdp8f1C0FzTIaDuL5tiOBLu0tbgPjirNHmsRYDGgP
	MScPspnN7yptBdj+XvOQwjlo7rb1JYlgbJy4N8OyHasWsnV8y/nnsTE45HWgDrdPluxJbb
	5UQEtASLvD2gs1uz4T4wTgwQIuBmOWDHHnBPWgAENsAU+LKmXpnW3SvDP792YIgCsGyuHo
	zwyBcBm8tEW10cCbnHgg8Y646yLjMIgkNbGmXrlZhM8CvJuGhMkrWScStKfDhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1709686191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EpX9FMnkSA9qP79yTLo4VHBROcf/tv5MB/+02P/ztu0=;
	b=6qNfORp40gZrMcpTuq4ZY1ksHBxObLBwXg+mxlNdzeP7GFpmpJbvmgwGvYlAk3Uz9I8HTN
	0JKdeIpOkfaxBz7VSX1orlQ/9+7aBeu7WynJ43sRc72NAHRSj0/ch5ehfxdItwciPvYnvp
	CQuiMeI2trUzeFd1yy7Pv5daySEV2pf+G/FYCmH8AOje0CuBAsvnwOwFsdWyM5DtynX01r
	qb8GJQMAo0F+1qiG2QQUZbpg/blgDkZ1hc4gWbDI1/2azy0TqfBDqK+4irIqAMy1l5VHf5
	+2yQ5kQxs5sVphzjaIQadzNgYLYY+L8iftpAI2EaT1rKdRroa1Tut9YiWNMo0A==
ARC-Authentication-Results: i=1;
	rspamd-55b4bfd7cb-cj6mq;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Bottle: 43e0bb2f3d3ed186_1709686191380_2653870835
X-MC-Loop-Signature: 1709686191380:931242876
X-MC-Ingress-Time: 1709686191379
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.27.58 (trex/6.9.2);
	Wed, 06 Mar 2024 00:49:51 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4TqDNZ34nFzh6
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1709686190;
	bh=EpX9FMnkSA9qP79yTLo4VHBROcf/tv5MB/+02P/ztu0=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=CUyDawRLchInh2Z4hVUfwX06jZhk+jl4CWZEYX87v5l4IlFUDUXgV5ObfUSA5ZvSL
	 SmMSwIRoTYQvSGisDjchljM8w5MDE34aqyW6TQ28Ou9XBS92IqK2UArFUTCTul0QsD
	 jiJABEP1yLON7RNurEWcfp9kHBjnT92PpTNV3Tt4TvztGQjpIQfio0of3daCyFm3hU
	 jrU3yb68B4VH+KrW51f91btUGMR3Bsw6x25BqBruM6RundTWbmhhw2aLvyRD5izZTI
	 lxDzkuGk/0XAMCpSGZzcerRGWDqrYr189HgAiLJEuU1YixqVr5TqZzAvJve0uotf4Q
	 abEVsgrCUc2gg==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0082
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Tue, 05 Mar 2024 16:49:42 -0800
Date: Tue, 5 Mar 2024 16:49:42 -0800
From: Krister Johansen <kjlx@templeofstupid.com>
To: stable@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: [PATCH 5.15.y v2 1/2] KVM: arm64: Work out supported block level at
 compile time
Message-ID: <21a92d6c66b6100d45a9cf8a0e48f613576157fa.1709685364.git.kjlx@templeofstupid.com>
References: <cover.1709665227.git.kjlx@templeofstupid.com>
 <cover.1709685364.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1709685364.git.kjlx@templeofstupid.com>

From: Oliver Upton <oliver.upton@linux.dev>

commit 3b5c082bbfa20d9a57924edd655bbe63fe98ab06 upstream.

Work out the minimum page table level where KVM supports block mappings
at compile time. While at it, rewrite the comment around supported block
mappings to directly describe what KVM supports instead of phrasing in
terms of what it does not.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221007234151.461779-2-oliver.upton@linux.dev
Signed-off-by: Krister Johansen <kjlx@templeofstupid.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 027783829584..87e782eec925 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -13,6 +13,18 @@
 
 #define KVM_PGTABLE_MAX_LEVELS		4U
 
+/*
+ * The largest supported block sizes for KVM (no 52-bit PA support):
+ *  - 4K (level 1):	1GB
+ *  - 16K (level 2):	32MB
+ *  - 64K (level 2):	512MB
+ */
+#ifdef CONFIG_ARM64_4K_PAGES
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1U
+#else
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
+#endif
+
 static inline u64 kvm_get_parange(u64 mmfr0)
 {
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
@@ -58,11 +70,7 @@ static inline u64 kvm_granule_size(u32 level)
 
 static inline bool kvm_level_supports_block_mapping(u32 level)
 {
-	/*
-	 * Reject invalid block mappings and don't bother with 4TB mappings for
-	 * 52-bit PAs.
-	 */
-	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
+	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
 }
 
 /**
-- 
2.25.1


