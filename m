Return-Path: <kvm+bounces-71493-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gHZUKJl6nGlfIAQAu9opvQ
	(envelope-from <kvm+bounces-71493-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:04:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2B9179508
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 17:04:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4D863307DE60
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 16:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 836C13101A2;
	Mon, 23 Feb 2026 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsZdLBDj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D8F30FC29;
	Mon, 23 Feb 2026 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862436; cv=none; b=ZVp05lp3GwYCkiccxXzgMqKA6+VUimE7pz0oQSkuX1H6Vqa2yP9746zzru28dPekUN561LgyKYeCkBGWKRNpHJbzyMkks6y8LJle0s8I/1ed0MgB908GvX3a9XjRzlaNh2Sdc4C4Ys4jKJq2MAgywr7S7tq7mjv8EVWMdCWc3aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862436; c=relaxed/simple;
	bh=UKIhO7k7VLQSgpTXiMxkaWE6pX9f9Kduyb6QirGAR1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m3tZEtflAxSyKvxR7TaqOJL2YLAGlFYOXRVWUkQwLvtkl0IAb7EKc7h+OmqhpvijxnEn/F/FTn/LS4RDG0zJp8bgC43lXca79hdfLZmkV3OFMsw7wR85nFTxTTnroCismpixpFYjVrQRGtpSoRFQhaf8GuvlMauhdlY1mK0FHG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsZdLBDj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D452C2BC87;
	Mon, 23 Feb 2026 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771862436;
	bh=UKIhO7k7VLQSgpTXiMxkaWE6pX9f9Kduyb6QirGAR1I=;
	h=From:To:Cc:Subject:Date:From;
	b=FsZdLBDjEJUxdXZcm5UP08dJ3SCq5dXZBKUUZfLIOTe/JTGDZbuNoSm2tnZ1VCJLe
	 KAAbD7RxD5LRWKE1lWRYrUZSWYsanD+BTRIVmIuBElt3CoimYKrru+3xAMdTRm6kTM
	 DwWpruTckuDudPpDWaw0H8ElsivatrsVQ8/y3RcwNJNL9VnQFepsUVcZitWTIbcSOp
	 sviYiGz/sxtq7amVM6yEa/2KH1N5N7yOpunOp+cs9oKCtX3SoHeETt1m+MjapijHqL
	 0HpLpPj4dYlwogCnmaZ0cwCjjwz9KueQVdbsAlZ9DvBVXv+AD0kVp0sP5Vya2FwDEi
	 VCmQiKjHmok+g==
From: Yosry Ahmed <yosry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH] MAINTAINERS: Update Yosry Ahmed's email address
Date: Mon, 23 Feb 2026 16:00:26 +0000
Message-ID: <20260223160027.122307-1-yosry@kernel.org>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[cmpxchg.org,gmail.com,kvack.org,vger.kernel.org,kernel.org];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-71493-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 8A2B9179508
X-Rspamd-Action: no action

Use my kernel.org email address.

Signed-off-by: Yosry Ahmed <yosry@kernel.org>
---
 .mailmap    | 3 ++-
 MAINTAINERS | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/.mailmap b/.mailmap
index e1cf6bb85d333..15b7a064b0bb6 100644
--- a/.mailmap
+++ b/.mailmap
@@ -890,7 +890,8 @@ Yanteng Si <si.yanteng@linux.dev> <siyanteng@loongson.cn>
 Ying Huang <huang.ying.caritas@gmail.com> <ying.huang@intel.com>
 Yixun Lan <dlan@kernel.org> <dlan@gentoo.org>
 Yixun Lan <dlan@kernel.org> <yixun.lan@amlogic.com>
-Yosry Ahmed <yosry.ahmed@linux.dev> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosryahmed@google.com>
+Yosry Ahmed <yosry@kernel.org> <yosry.ahmed@linux.dev>
 Yu-Chun Lin <eleanor.lin@realtek.com> <eleanor15x@gmail.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Zack Rusin <zack.rusin@broadcom.com> <zackr@vmware.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index b8d8a5c415976..58e0684cd757e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -29185,7 +29185,7 @@ K:	zstd
 
 ZSWAP COMPRESSED SWAP CACHING
 M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Yosry Ahmed <yosry.ahmed@linux.dev>
+M:	Yosry Ahmed <yosry@kernel.org>
 M:	Nhat Pham <nphamcs@gmail.com>
 R:	Chengming Zhou <chengming.zhou@linux.dev>
 L:	linux-mm@kvack.org
-- 
2.53.0.345.g96ddfc5eaa-goog


