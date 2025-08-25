Return-Path: <kvm+bounces-55693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B788AB34EBB
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:01:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB24418990CA
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:01:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1EE310785;
	Mon, 25 Aug 2025 21:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UbiU5j0v"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B60630AAD4;
	Mon, 25 Aug 2025 21:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756159153; cv=none; b=u9Gg7hipZ2WBwi+VDNt+9d0KN15MMTVcT28FcQT5NLSBVZNU/3TqMTWKnORQqQduhEiOjWmd3RpF6iECN9lw9ckKmEYuYv1mz4WVxJ9x5/LhHfLC0gnI6LMCE/0j+9D6qV/QmEdIyw5TP4MmJHDhnNuNrLm9xNWBEaCd4X9gf+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756159153; c=relaxed/simple;
	bh=16EPmrHdMEr6M3sM1MYmbbFsavhSkZ1KC1VkNUsuyoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X57k8sAib1H9li7vL3MZblVfamMVLxTB7693vbSuXmd878eDRaqS3ztuDpbEMUbjHJrHlq8Yr7SsIkDaWDGuWr+7g78/3lwCKAeM/HRGtJoVLp6ijrogAFuSn5Uges+eDXBIKjqZzqSCAdViltUsXUyg9HB7lPW63RsqbfRmv/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UbiU5j0v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C683C113D0;
	Mon, 25 Aug 2025 21:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756159153;
	bh=16EPmrHdMEr6M3sM1MYmbbFsavhSkZ1KC1VkNUsuyoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbiU5j0vJ3AJEAOSTsxd2W6/CTIR+XIRNKEvOnBYNra7He8lRJIPJGqH4+KOX3Zh5
	 ji9pQOfmCyT4xh+Son4fcpUEpOk6UIs3rtYLLYlcwxTiIxIcOxUFKw3UJMM9ZQ3P7z
	 y6Vj/9SKq+/gQlsKlAU09j+YpYBYHGedhJzVcR3I7IviSExr/a8ojvOrHRwd2++2/6
	 l7dhuPBkdVf/uS9PULid/UmpjflC/JBahaqKiu1I/I/IAH9ajkupkWmX6mZsyFux43
	 rqFTTr5VT/o/gML6oin9loXLfBn3rpcqr6Iwp47Gx6JUjS8CbdFUyh9fxlPmkQw3ae
	 Y5pYpV92nfWCQ==
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-perf-users@vger.kernel.org,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: [PATCH 11/11] tools headers: Sync uapi/linux/vhost.h with the kernel source
Date: Mon, 25 Aug 2025 14:59:03 -0700
Message-ID: <20250825215904.2594216-12-namhyung@kernel.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250825215904.2594216-1-namhyung@kernel.org>
References: <20250825215904.2594216-1-namhyung@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To pick up the changes in this cset:

  7d9896e9f6d02d8a vhost: Reintroduce kthread API and add mode selection
  333c515d189657c9 vhost-net: allow configuring extended features

This addresses these perf build warnings:

  Warning: Kernel ABI header differences:
    diff -u tools/perf/trace/beauty/include/uapi/linux/vhost.h include/uapi/linux/vhost.h

Please see tools/include/uapi/README for further details.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
* This is on top of the fix below:
  https://lore.kernel.org/r/20250819063958.833770-1-namhyung@kernel.org

 .../trace/beauty/include/uapi/linux/vhost.h   | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/perf/trace/beauty/include/uapi/linux/vhost.h b/tools/perf/trace/beauty/include/uapi/linux/vhost.h
index d4b3e2ae1314d1fc..c57674a6aa0dbbea 100644
--- a/tools/perf/trace/beauty/include/uapi/linux/vhost.h
+++ b/tools/perf/trace/beauty/include/uapi/linux/vhost.h
@@ -235,4 +235,39 @@
  */
 #define VHOST_VDPA_GET_VRING_SIZE	_IOWR(VHOST_VIRTIO, 0x82,	\
 					      struct vhost_vring_state)
+
+/* Extended features manipulation */
+#define VHOST_GET_FEATURES_ARRAY _IOR(VHOST_VIRTIO, 0x83, \
+				       struct vhost_features_array)
+#define VHOST_SET_FEATURES_ARRAY _IOW(VHOST_VIRTIO, 0x83, \
+				       struct vhost_features_array)
+
+/* fork_owner values for vhost */
+#define VHOST_FORK_OWNER_KTHREAD 0
+#define VHOST_FORK_OWNER_TASK 1
+
+/**
+ * VHOST_SET_FORK_FROM_OWNER - Set the fork_owner flag for the vhost device,
+ * This ioctl must called before VHOST_SET_OWNER.
+ * Only available when CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL=y
+ *
+ * @param fork_owner: An 8-bit value that determines the vhost thread mode
+ *
+ * When fork_owner is set to VHOST_FORK_OWNER_TASK(default value):
+ *   - Vhost will create vhost worker as tasks forked from the owner,
+ *     inheriting all of the owner's attributes.
+ *
+ * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
+ *   - Vhost will create vhost workers as kernel threads.
+ */
+#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
+
+/**
+ * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost device.
+ * Only available when CONFIG_VHOST_ENABLE_FORK_OWNER_CONTROL=y
+ *
+ * @return: An 8-bit value indicating the current thread mode.
+ */
+#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
+
 #endif
-- 
2.51.0.261.g7ce5a0a67e-goog


