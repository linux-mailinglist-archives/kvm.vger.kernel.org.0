Return-Path: <kvm+bounces-4646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C0E815DF5
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 09:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81DBE1F21F5C
	for <lists+kvm@lfdr.de>; Sun, 17 Dec 2023 08:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402243D65;
	Sun, 17 Dec 2023 08:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vhvMowPD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D8C1C27
	for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 08:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbd0be3a7e9so1210429276.0
        for <kvm@vger.kernel.org>; Sun, 17 Dec 2023 00:09:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702800560; x=1703405360; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx3B6aLRQGDHWIOJfDNBvVD3RlXkr+3jhLG4738eUjE=;
        b=vhvMowPDr4sLum8/34TI9++Tk1uFJc07pqhf20tmo5zM3v8PhMagvrXPbIQ8OIpLBD
         9xnezFGb/RekGg82Z/GCkdBWQH8ehOHy4FtpvNQRRwNlJVw9tmjp8h8warVitOJHtpOz
         uCBs4eDOgK3WjSGPoBJ9t3giV92Lupxo5w4CDXt8awG4/wCWQndY6NVMd7F6zklL3r2/
         z/c7hfrYs3nRP2b4kQqK5ECfCVIB6ctsjfQDUbHU8y1zSgUSrpavluBB4tuJp2pOnOhC
         6+nKGicouYy8xQ5y38Pi9O1TAy4D71VYzaVL+iZYL6i7990iKpF9NlgxespIru74W194
         RpIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702800560; x=1703405360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx3B6aLRQGDHWIOJfDNBvVD3RlXkr+3jhLG4738eUjE=;
        b=pe/N+THvP7LkRdLuYvhzNHdvR6facHcKFkoGOM/EXtNClwmIZh1LiV6cjpEEgB1H46
         0hW1boq454y5Lh73wDnG27MkN32lB9yYCplVyuL/d3JTq7sFJhPGa5dR5ZNAKiFVzK+S
         887cQC9/EF0dnCl3Ykqkuj4gZAFCQyIRYILPYLFDv4lPfecF+vLYd+UDN/j2hwBm10eC
         NLMBA4EaDx/nQowNfCVf9vWCJXKEFeely1hCdZ6w5jA+ZKyZsQa0kJGApfm+Fxm1HQZi
         ktTJudfW4au20ihRhcoVEsa+XaDDJb8opmGVzMP6tHQnNfKKCtO1bvk51SfkHjf33j6x
         8Q/A==
X-Gm-Message-State: AOJu0YxZiy0sL3tCh6PGlBIctsFvinXDjkrN2JUE+/RPMwhe9vSFGH7I
	QnJxjv0CWWSVa27fslclwmsPJd8kVeGDcrR7bg==
X-Google-Smtp-Source: AGHT+IEwZTJQinwLs899XxaD5GQX67+mFW+pdrHRCj7vW1TcxI+XrOUDAC3B4t5e+jZNBioLBKKYu7HWw6u6KGTvBg==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:3eb4:e132:f78a:5ba9])
 (user=almasrymina job=sendgmr) by 2002:a05:6902:1343:b0:dbd:13b8:2598 with
 SMTP id g3-20020a056902134300b00dbd13b82598mr628107ybu.3.1702800560127; Sun,
 17 Dec 2023 00:09:20 -0800 (PST)
Date: Sun, 17 Dec 2023 00:09:09 -0800
In-Reply-To: <20231217080913.2025973-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231217080913.2025973-1-almasrymina@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231217080913.2025973-2-almasrymina@google.com>
Subject: [PATCH net-next v2 1/3] vsock/virtio: use skb_frag_*() helpers
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

Minor fix for virtio: code wanting to access the fields inside an skb
frag should use the skb_frag_*() helpers, instead of accessing the
fields directly. This allows for extensions where the underlying
memory is not a page.

Signed-off-by: Mina Almasry <almasrymina@google.com>

---

v2:

- Also fix skb_frag_off() + skb_frag_size() (David)
- Did not apply the reviewed-by from Stefano since the patch changed
relatively much.

---
 net/vmw_vsock/virtio_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f495b9e5186b..1748268e0694 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -153,10 +153,10 @@ virtio_transport_send_pkt_work(struct work_struct *work)
 				 * 'virt_to_phys()' later to fill the buffer descriptor.
 				 * We don't touch memory at "virtual" address of this page.
 				 */
-				va = page_to_virt(skb_frag->bv_page);
+				va = page_to_virt(skb_frag_page(skb_frag));
 				sg_init_one(sgs[out_sg],
-					    va + skb_frag->bv_offset,
-					    skb_frag->bv_len);
+					    va + skb_frag_off(skb_frag),
+					    skb_frag_size(skb_frag));
 				out_sg++;
 			}
 		}
-- 
2.43.0.472.g3155946c3a-goog


