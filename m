Return-Path: <kvm+bounces-4966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1853C81A898
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 22:46:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9A4F28AD9F
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 21:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57DF4B5BA;
	Wed, 20 Dec 2023 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4lOWbTMM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3F64AF73
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 21:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e56d85fa91so3808287b3.2
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703108712; x=1703713512; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9DyntanP2TiYwqFVgk0wpxjTNS8jI1v6Olu/+yXZqok=;
        b=4lOWbTMMj1O2iBSll5lu/Jd+IThP1l7RW484oJgQpD8zPntRS3Z1tT2A+oEW5xczrj
         j+86M/agI2V3NfGts3lyFZff06ryZLsh57Nd5BfQbFkzOck6QFrRz6aklX5t/8Ts9/Z4
         tbfh+AgC45PGxIAxwuoVTzB46w4ILPFAsrhHcrxvGA3yL1ng5OKgWtHB1oSZXaOrDUmW
         RmNoLy47J7pH/+DodP7JN1FXAOxSm0oGImGUZxtJR5XEZFQqRE0ztjXGfxMUmfb7EO6h
         RSxfFj21fb/CIEoLwQAH+Ky6wNb2tRvabuGjCm+ZuIobpRqXTpL44ZotD55VScBa4jYL
         NoAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703108712; x=1703713512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9DyntanP2TiYwqFVgk0wpxjTNS8jI1v6Olu/+yXZqok=;
        b=OvGdm8gPGYg55QINvE8wyPAw8A+khPpz8LZJICGPa1lh9jsKLwmyLdqwV8Wa/Yt45h
         S4v+b/DZ+0M6xOgfeTeIfSTJaaUIDTgy0oWIMQdelHPAuxPIixxwRCecMXa1y3v4ifjQ
         XGpSylAaDnBB1L3wx9EnioUEkjn7iJ/UePh1kh0DrnULTnTIE9hu+UzeWGEPiSUF2SNG
         3Se0AgJ9rw2YqCTXdk6+AVy2G0izmmf4UK/n2zI8tzSV9b/wQ3iyOJ8sddTiS6mm9VHs
         LUUmnstEYnsjpENkDFZx537NWN3fSaUypNJBN8mbbZqmeJhN327yn/GlgXEAP4JWz1VL
         cAlA==
X-Gm-Message-State: AOJu0YxD0lDSgRujVrP2ELzvoWqS7vNtO6ZWv26vww3RHXQ34O8DjT8Y
	wltId2cdpNRW5ZIYKbReYAz0Hhg9IxyPLIdhBQ==
X-Google-Smtp-Source: AGHT+IEhvRRPXhRIbkUsMDUYI1y9yD6AP93JUuvPEHvk1q4Gg3JVzRIEWkIp64BLMiqACjKB2LfP8ZKyYsRUNNprHQ==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:13cc:a33:a435:3fe9])
 (user=almasrymina job=sendgmr) by 2002:a25:a28a:0:b0:dbd:b756:983a with SMTP
 id c10-20020a25a28a000000b00dbdb756983amr151334ybi.9.1703108712675; Wed, 20
 Dec 2023 13:45:12 -0800 (PST)
Date: Wed, 20 Dec 2023 13:45:01 -0800
In-Reply-To: <20231220214505.2303297-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231220214505.2303297-1-almasrymina@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231220214505.2303297-3-almasrymina@google.com>
Subject: [PATCH net-next v3 2/3] net: introduce abstraction for network memory
From: Mina Almasry <almasrymina@google.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	David Howells <dhowells@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	"=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>, Shakeel Butt <shakeelb@google.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add the netmem_ref type, an abstraction for network memory.

To add support for new memory types to the net stack, we must first
abstract the current memory type. Currently parts of the net stack
use struct page directly:

- page_pool
- drivers
- skb_frag_t

Originally the plan was to reuse struct page* for the new memory types,
and to set the LSB on the page* to indicate it's not really a page.
However, for compiler type checking we need to introduce a new type.

netmem_ref is introduced to abstract the underlying memory type. Currently
it's a no-op abstraction that is always a struct page underneath. In
parallel there is an undergoing effort to add support for devmem to the
net stack:

https://lore.kernel.org/netdev/20231208005250.2910004-1-almasrymina@google.com/

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v3:

- Modify struct netmem from a union of struct page + new types to an opaque
  netmem_ref type.  I went with:

  +typedef void *__bitwise netmem_ref;

  rather than this that Jakub recommended:

  +typedef unsigned long __bitwise netmem_ref;

  Because with the latter the compiler issues warnings to cast NULL to
  netmem_ref. I hope that's ok.

- Add some function docs.

v2:

- Use container_of instead of a type cast (David).
---
 include/net/netmem.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 include/net/netmem.h

diff --git a/include/net/netmem.h b/include/net/netmem.h
new file mode 100644
index 000000000000..edd977326203
--- /dev/null
+++ b/include/net/netmem.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ *	Network memory
+ *
+ *	Author:	Mina Almasry <almasrymina@google.com>
+ */
+
+#ifndef _NET_NETMEM_H
+#define _NET_NETMEM_H
+
+/**
+ * typedef netmem_ref - a nonexistent type marking a reference to generic
+ * network memory.
+ *
+ * A netmem_ref currently is always a reference to a struct page. This
+ * abstraction is introduced so support for new memory types can be added.
+ *
+ * Use the supplied helpers to obtain the underlying memory pointer and fields.
+ */
+typedef void *__bitwise netmem_ref;
+
+/* This conversion fails (returns NULL) if the netmem_ref is not struct page
+ * backed.
+ *
+ * Currently struct page is the only possible netmem, and this helper never
+ * fails.
+ */
+static inline struct page *netmem_to_page(netmem_ref netmem)
+{
+	return (struct page *)netmem;
+}
+
+/* Converting from page to netmem is always safe, because a page can always be
+ * a netmem.
+ */
+static inline netmem_ref page_to_netmem(struct page *page)
+{
+	return (netmem_ref)page;
+}
+
+#endif /* _NET_NETMEM_H */
-- 
2.43.0.472.g3155946c3a-goog


