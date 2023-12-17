Return-Path: <kvm+bounces-4647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D6CD815DF9
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 09:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDBB31F22581
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 08:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCB763DC;
	Sun, 17 Dec 2023 08:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XROIEh4b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F9D3C3F
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 08:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e5748d50bbso7792197b3.1
        for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 00:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702800562; x=1703405362; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cjUSNe+bIsKYLrf1i8KK45ElvyWQbESYTUWNmf5dvpE=;
        b=XROIEh4bGgdrndOSm9jbSvu/lJDWD00B4DbDZByFo/MxPcJ85or4uECojjFSkMK4ZD
         ibVrYGUmRtje4D7dI528n7428RlpqK066moAEOtiMdn20OC4eFceePYIoiG8BqQMf5cr
         FJwF3nPtM+Cqur/gtLfMWqC40KodwQvJNLxRMTXwL+XWLJbTBO6BS+x5dxAWztrlbMjZ
         8q80Bzgbl9q2SWhT8i8mLL2HFbQhXooEY114ApKFg3KEariBeItyEKxoNS8TCqeE8hER
         m+a3KO8Xvi6+8xI6fg4KcsnZb0ixBdNFYjhsgtz6lRco5LuHWPOhfRvc+SpihSp5HlSO
         zQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702800562; x=1703405362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cjUSNe+bIsKYLrf1i8KK45ElvyWQbESYTUWNmf5dvpE=;
        b=buK3cx7CYLaRdCVJCkEs78PgkwGVYpQph0ggPndgPHw7y/U6JmFhSRq3JEJufBOqm8
         Sp4MmxQTr+po5r2MYYjoKRBdNHjNHq0xMyZu1iC356UzpSmRhwzIlJMFqIgrOCOn9wbz
         ZDW3LvbsO4QwoCCQVhSgSJU39pzXkqTQ5BBpLQMcf/9mkQzkQ7JR2l4pvQj+27/aXYXz
         LhwCoBwJSbJku+ckKDkoN5y4i8wsXTx8SuzGFWXTU2YfRM5wUmJYxH+aUoh2jVtF+mOJ
         N3EYcNEXZwTRRMlZ1+4aezt0aze1NZfSvUgH+8J1KAdY+q6SQeX1zWpxLKLTXyA6HIxh
         7HiQ==
X-Gm-Message-State: AOJu0YyFu4oCNnKmVJfaDzm/tIiqigh+7bF/yHdoojRCcY4cY9VjxBds
	Pbsh9IYR0UC/2UW1l/MmG4t+B4xw5Y0mqRd89A==
X-Google-Smtp-Source: AGHT+IEk69ugEQxkS8QhkN2m7ULUqQhtERRZfMer+dPR3UXS3OTGyFS+Wx9Wm+2Kxy1YuSoHcfkw1ezou9Bj9TkSPQ==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:3eb4:e132:f78a:5ba9])
 (user=almasrymina job=sendgmr) by 2002:a05:690c:2c83:b0:5e5:d445:d9a9 with
 SMTP id ep3-20020a05690c2c8300b005e5d445d9a9mr237216ywb.3.1702800562290; Sun,
 17 Dec 2023 00:09:22 -0800 (PST)
Date: Sun, 17 Dec 2023 00:09:10 -0800
In-Reply-To: <20231217080913.2025973-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231217080913.2025973-1-almasrymina@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231217080913.2025973-3-almasrymina@google.com>
Subject: [PATCH net-next v2 2/3] net: introduce abstraction for network memory
From: Mina Almasry <almasrymina@google.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, 
	"=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>, Shakeel Butt <shakeelb@google.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add the netmem_t type, an abstraction for network memory.

To add support for new memory types to the net stack, we must first
abstract the current memory type from the net stack. Currently parts of
the net stack use struct page directly:

- page_pool
- drivers
- skb_frag_t

Originally the plan was to reuse struct page* for the new memory types,
and to set the LSB on the page* to indicate it's not really a page.
However, for compiler type checking we need to introduce a new type.

netmem_t is introduced to abstract the underlying memory type. Currently
it's a no-op abstraction that is always a struct page underneath. In
parallel there is an undergoing effort to add support for devmem to the
net stack:

https://lore.kernel.org/netdev/20231208005250.2910004-1-almasrymina@google.com/

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v2:

- Use container_of instead of a type cast (David).
---
 include/net/netmem.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 include/net/netmem.h

diff --git a/include/net/netmem.h b/include/net/netmem.h
new file mode 100644
index 000000000000..b60b00216704
--- /dev/null
+++ b/include/net/netmem.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * netmem.h
+ *	Author:	Mina Almasry <almasrymina@google.com>
+ *	Copyright (C) 2023 Google LLC
+ */
+
+#ifndef _NET_NETMEM_H
+#define _NET_NETMEM_H
+
+struct netmem {
+	union {
+		struct page page;
+
+		/* Stub to prevent compiler implicitly converting from page*
+		 * to netmem_t* and vice versa.
+		 *
+		 * Other memory type(s) net stack would like to support
+		 * can be added to this union.
+		 */
+		void *addr;
+	};
+};
+
+static inline struct page *netmem_to_page(struct netmem *netmem)
+{
+	return &netmem->page;
+}
+
+static inline struct netmem *page_to_netmem(struct page *page)
+{
+	return container_of(page, struct netmem, page);
+}
+
+#endif /* _NET_NETMEM_H */
-- 
2.43.0.472.g3155946c3a-goog


