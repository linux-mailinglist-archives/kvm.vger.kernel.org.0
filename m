Return-Path: <kvm+bounces-4645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 40952815DF2
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 09:09:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0337B2256B
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 08:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC572103;
	Sun, 17 Dec 2023 08:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hsqj3sjW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B61860
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 08:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e56d85fa91so7250407b3.2
        for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 00:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702800558; x=1703405358; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QsH9QLVPpBb4NCLNFoF1VK/l5bin9axXMtCbklwluC0=;
        b=Hsqj3sjWLSd3Q3tGXVjtQAQO6Gi0KBz0TlNlTERU89+AMPeq1pRvBQttLfaa6oWPJk
         l3fbdVabPT9ZMGFWAD+lhdY59gEmkF7dujVHYgPxTwOuoUuJk7x4poKPpGge1TsmsUBD
         d3Ca0h9PYR6dUfEOgsgWU6p0yt/rnswMNqViOkHH+L+4H8L/gPCNM9BFNVIboWMGw6RT
         53V6UFu72kwkffDWdX8k09iNX+KnHThaxAIheMscsBMC1CKEm/pEY8nTWpLcZvGCjNXH
         1Bj0NgeczECeS7/aOtv2XpBVREOUUj6wRK8S5ycUYDe7ueZFHG4OBX6hx42dR9itHCFS
         JfEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702800558; x=1703405358;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QsH9QLVPpBb4NCLNFoF1VK/l5bin9axXMtCbklwluC0=;
        b=wNEOVsWaRdv+jgBNSWWqmh5blFV02BxLW28WE2x1T/tTVUL9aC9S7e08fsn3ktkWB+
         UuWaDS+HRUpWATOkfKuYYRdU7LnWNetLRDsv1VDBIF7GSssH/w55Dsbqrqb1cZlO4P7g
         6jJNj4a+Hs83o7WAzcImFb0XQMsY9JM2G3+MS2PgRzVPwJvo+MNnV047a9DJ5mwJLle+
         6LQYq7MgCfgeJrhqDLlVo34FVbNqXbt9e9Zf3PNhFvvEoDWzeMHOWgAsMIp+rr4K2L5X
         B8qx9SXEMwT2tzoDfKogBX6owYpxaDtquiV2+ZfsXEtF5ktjDhGb/pymfKMO96XjHNWz
         HuJA==
X-Gm-Message-State: AOJu0YyPAMO21Fay6mTTb3Ytq2RA9O3BnfJkNDLEb/QpxLw5KLYUTfxZ
	eNqtSvkikbg5Qqbo7V8ktSrAMHdviIdn+apeIg==
X-Google-Smtp-Source: AGHT+IFgkSK2rNHEatJQvrQrdr36+TUgi1Z/vuAfdrjxwnBPxU+VrSvy3F8ozm4eK5gFgSf5MjBLCP8BZU+cLVBeyg==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:3eb4:e132:f78a:5ba9])
 (user=almasrymina job=sendgmr) by 2002:a05:690c:e1d:b0:5e4:afdb:a5ff with
 SMTP id cp29-20020a05690c0e1d00b005e4afdba5ffmr1117521ywb.6.1702800557793;
 Sun, 17 Dec 2023 00:09:17 -0800 (PST)
Date: Sun, 17 Dec 2023 00:09:08 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231217080913.2025973-1-almasrymina@google.com>
Subject: [PATCH net-next v2 0/3] Abstract page from net stack
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
Content-Transfer-Encoding: quoted-printable

Changes in v2:
- Reverted changes to the page_pool. The page pool now retains the same
  API, so that we don't have to touch many existing drivers. The devmem
  TCP series will include the changes to the page pool.

- Addressed comments.

This series is a prerequisite to the devmem TCP series. For a full
snapshot of the code which includes these changes, feel free to check:

https://github.com/mina/linux/commits/tcpdevmem-rfcv5/

-----------

Currently these components in the net stack use the struct page
directly:

1. Drivers.
2. Page pool.
3. skb_frag_t.

To add support for new (non struct page) memory types to the net stack, we
must first abstract the current memory type.

Originally the plan was to reuse struct page* for the new memory types,
and to set the LSB on the page* to indicate it's not really a page.
However, for safe compiler type checking we need to introduce a new type.

struct netmem is introduced to abstract the underlying memory type.
Currently it's a no-op abstraction that is always a struct page underneath.
In parallel there is an undergoing effort to add support for devmem to the
net stack:

https://lore.kernel.org/netdev/20231208005250.2910004-1-almasrymina@google.=
com/

Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>

Mina Almasry (3):
  vsock/virtio: use skb_frag_*() helpers
  net: introduce abstraction for network memory
  net: add netmem_t to skb_frag_t

 include/linux/skbuff.h           | 70 ++++++++++++++++++++++++--------
 include/net/netmem.h             | 35 ++++++++++++++++
 net/core/skbuff.c                | 22 +++++++---
 net/kcm/kcmsock.c                | 10 ++++-
 net/vmw_vsock/virtio_transport.c |  6 +--
 5 files changed, 116 insertions(+), 27 deletions(-)
 create mode 100644 include/net/netmem.h

--=20
2.43.0.472.g3155946c3a-goog


