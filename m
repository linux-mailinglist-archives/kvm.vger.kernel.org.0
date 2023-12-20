Return-Path: <kvm+bounces-4965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 698A381A895
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 22:46:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CEC31C208BF
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 21:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0DAF4B147;
	Wed, 20 Dec 2023 21:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QQ2nudT2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A51498AB
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 21:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--almasrymina.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5e8d966fbc0so1629107b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703108711; x=1703713511; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx3B6aLRQGDHWIOJfDNBvVD3RlXkr+3jhLG4738eUjE=;
        b=QQ2nudT2J+0/gyYlb4aFR4GB1GA9nYXGLGGlkwgTAFDf2nttTsqQ8jKu8mlH8lGNPW
         KCTcxPUN8vkn4s7EXCKVEYjnScp89S2zQvvWJdG+Gb4mq1w2DGrsktLgUjJSz01In2hn
         nbG77gGNJVQ8o7N+ODDBEFcUrDOEnxSeewm1YIW/BDWU3s/oNzeor5fgtLVdyCFTVhvr
         GYeHhrKhFMCvBy/EyeS376WEoQYFcJmTwenkANWzHdXvG6PPRflXGVocePVfpRrwDM6Y
         tAAqjYwAmmOeW/MMMc+dVyQG5EJofnsxMMIQEdGRhzhJyh/B9wX+/tJ/S8QusrQr4865
         azgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703108711; x=1703713511;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx3B6aLRQGDHWIOJfDNBvVD3RlXkr+3jhLG4738eUjE=;
        b=An7X8nwxYN7B3u5GJXlrJuPDGHdn/rnL1yAeDQtM4bWib2uVMgiZNidwQA3tYD3wWK
         ic/BNnEjFmxMPTcR1EYux9C+EFeTTpHsvBeJw7MrEORX/xhoVzmCQFw2iSQoI99CFfdW
         r35XHSG6csw6tLio8Exx+Nu/p7gNiQnJTfZd9FsxIVnCfR88GTKL3EOkndIb2dT/r7Lu
         fhPA1WoVVeJGzgM60gm3+kTINDCNHMG0IWmwRgthnWAOkjpKYptEcnKgDYytVPSCYfgz
         O72J1SmBIzUuLMCt2IRZhCvieHJF5jIi+1o5R6ib5l0xzxPGoVwzkGQULP1Of/8UTLwc
         Bxog==
X-Gm-Message-State: AOJu0Yy91L/5wTk63xEbQ3f8INnubor1pf52LvrAVk+c+4vBUwWaLD/Y
	xAnUPjJwfwk/jkD+NHOYLgVoYF7xNdG1Wm2Ncg==
X-Google-Smtp-Source: AGHT+IHeeVda1fzWpC2MyIipIVgO0VQgD0ORR43fQFWg6vkMg277efZauOAp6kk/JYNZ/heCWJCa9Vn36QS5XwGBZg==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2c4:200:13cc:a33:a435:3fe9])
 (user=almasrymina job=sendgmr) by 2002:a05:690c:c01:b0:5d6:f1d2:2e5e with
 SMTP id cl1-20020a05690c0c0100b005d6f1d22e5emr170815ywb.0.1703108710831; Wed,
 20 Dec 2023 13:45:10 -0800 (PST)
Date: Wed, 20 Dec 2023 13:45:00 -0800
In-Reply-To: <20231220214505.2303297-1-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231220214505.2303297-1-almasrymina@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231220214505.2303297-2-almasrymina@google.com>
Subject: [PATCH net-next v3 1/3] vsock/virtio: use skb_frag_*() helpers
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


