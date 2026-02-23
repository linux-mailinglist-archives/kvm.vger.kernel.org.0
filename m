Return-Path: <kvm+bounces-71543-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6IEMOR7XnGkJLAQAu9opvQ
	(envelope-from <kvm+bounces-71543-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:39:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B416617E751
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 23:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C1D963032D00
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 22:39:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717F637BE7B;
	Mon, 23 Feb 2026 22:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jE8odhRp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A947237BE79
	for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 22:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771886338; cv=none; b=FWNjsPQDpZ9lcFTRKiZvN6gqqAuMh6jEnmcoVv4qCyQOVsyyoMSA2CCjO8ilvPgD+Et2fD0XwTctnlTyUhRe+YAzAy5m9ZO9AiYhvlQEUlyuXRN+QGTafoj2PNlfkds6FEgBns+9hoDOtZe+3gp0GBVnCO0IP1klnNeNSY0FEOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771886338; c=relaxed/simple;
	bh=WgeYmElNUd8JWXtDscMvKbTYKQRR4nvqCMrxNQNtld4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Rr+rINwLWpPIMiGCaGLBGbb9nbBSf2db1sItCVbp+vby8xHITLo2DS7V7VlLRTDNh8g1D5rBd2OoEAVGi1WTdlY0Ad09YBV9KyhkMpUIy786vzKy5Mr/InRke+CU8luTe+KquOsCWLz7rP++fW+oQsf39+spyqTwEYZbk90XNtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jE8odhRp; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-79827d28feaso26961367b3.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 14:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886335; x=1772491135; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g/yCmM+X3z1/BoTwo6svOrTqbVDwyb97Jpk/MjzyWmU=;
        b=jE8odhRpi+A5fYcaIkttPI6rdvQvXlTeFUD7oqhwWKK6ZsCv/rkRijElk2BkBcw7ID
         kXl7UaVfk4gq5d3fmJ4x035+0JYeBZZTI48hPI0DhyTAoqhCFWm58tFnUxbd/SPqOy9P
         3TH52LdyySAvIMZjRgh8NU6vvZIN3i+dBqOTm75rK26J1qtUnGDFYJwDV3yMGLRlHK31
         5tTKoW/TAaloqxP7wX29sXv8grKlph030P7cgpHQyEIH5g1C00Eqs1Z0W70jhq0NRAL6
         JFj3JCRrc9piWD6in6TC4q1bok4Y+LqAUWQAKy1e07hS1o/YAN1c+hp0EVLb799Qu4uh
         BDbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886335; x=1772491135;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=g/yCmM+X3z1/BoTwo6svOrTqbVDwyb97Jpk/MjzyWmU=;
        b=Iq/HHoOfnqGzF7btU17HOkjQta4KYc2TEwQWew2yuZyKNceJkICs1Rc8kESMKN/rKQ
         tkck/dwKRWadID8S7RF5H9PA3GZeuz/0aIyiClFxli8UFaq3vSrOaxJjvumFlrKDtwCd
         AQt7uhPbFUTVF/JYq+Lc+tRxmDc46SkejVuu6HOwvXNT4o6fFarPc66QgJcA/hsqb7Wa
         ZEqcNBk77zmiprFr4/RxgF+dqGSpbWIF91DX8ZRoIJ3WO+wZkbbaApAvTa9NTRLYFfbK
         +VeGNTRhL5WQstCfIzhzsZG0m74q0SU2d/bRR2egVFiLZ7cI8xhk3Rf/q+IdKmiK9sw1
         xzMw==
X-Forwarded-Encrypted: i=1; AJvYcCV5QYaluWiQg9qza4r9610kjriPzYHaztI/L7NCnZuZEJ1OjkJk5DeKO7YiqHShZhvlnkc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7K7g/SRQK7zvxGHBevGAo5exQEBLbWl37gHl31Pv6ArAfSl06
	vElm3m8RQF1axUpvwxxqJPyeQa+DCdwJzg7cziYaOdZWgyINfZ/+M010
X-Gm-Gg: ATEYQzx7wL4d0tKsgXKvTWPeXscJhK8I/RAoIEQdiFdYlA7I4B0cDUvzZ59hheLbVp2
	3WHlZ8rnfq6dxxMAjGcQH3YkepfeZ7+Ll/V588NzefjIDNHySBr2EOcOAIroS3dOyc21/P/WbFN
	SEuzEteELQw/eWOhtRZq2+gAq4QmizuNc6geYvbhrnCOrHhePYTfZQATiUCu7jzewjbwoW1duqQ
	ox7URcEiwWPf8fzKwdLCtEhmbVDIL68nJDA8S50Sup+jbj1MaEHdMRM8b3ZdM2lK9n4p12UbM5R
	9G74G2y+3CxeauxtwbYZYoWPA8TLHH7L5xtiC2XgLBrvgsrPtqRbHyTyufiSUMYZaF79RbeEJzD
	FqjjXPSo3y6QULrdRMY3ytr1c4uHw82/NeUznBRv3ytuWWAp6wvnbLlYXZqgHP7ghiY4gq1lRZo
	lbSvjnRCjH7HJfRo4UcdMeR6T3wrVQCPhl
X-Received: by 2002:a05:690c:a:b0:794:c01a:18e6 with SMTP id 00721157ae682-7982903c9aamr91568337b3.47.1771886334599;
        Mon, 23 Feb 2026 14:38:54 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:54::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7982dbdf23dsm37723417b3.21.2026.02.23.14.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:54 -0800 (PST)
From: Bobby Eshleman <bobbyeshleman@gmail.com>
Date: Mon, 23 Feb 2026 14:38:33 -0800
Subject: [PATCH net v3 2/3] vsock: lock down child_ns_mode as write-once
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260223-vsock-ns-write-once-v3-2-c0cde6959923@meta.com>
References: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
In-Reply-To: <20260223-vsock-ns-write-once-v3-0-c0cde6959923@meta.com>
To: Stefano Garzarella <sgarzare@redhat.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>, 
 Shuah Khan <shuah@kernel.org>, Bobby Eshleman <bobbyeshleman@meta.com>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: virtualization@lists.linux.dev, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 kuniyu@google.com, ncardwell@google.com, 
 Daan De Meyer <daan.j.demeyer@gmail.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71543-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[lists.linux.dev,vger.kernel.org,google.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,meta.com:mid,meta.com:email]
X-Rspamd-Queue-Id: B416617E751
X-Rspamd-Action: no action

From: Bobby Eshleman <bobbyeshleman@meta.com>

Two administrator processes may race when setting child_ns_mode as one
process sets child_ns_mode to "local" and then creates a namespace, but
another process changes child_ns_mode to "global" between the write and
the namespace creation. The first process ends up with a namespace in
"global" mode instead of "local". While this can be detected after the
fact by reading ns_mode and retrying, it is fragile and error-prone.

Make child_ns_mode write-once so that a namespace manager can set it
once and be sure it won't change. Writing a different value after the
first write returns -EBUSY. This applies to all namespaces, including
init_net, where an init process can write "local" to lock all future
namespaces into local mode.

Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Co-developed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
---
 include/net/af_vsock.h    | 13 +++++++++++--
 include/net/netns/vsock.h |  3 +++
 net/vmw_vsock/af_vsock.c  | 15 ++++++++++-----
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index d3ff48a2fbe0..533d8e75f7bb 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -276,10 +276,19 @@ static inline bool vsock_net_mode_global(struct vsock_sock *vsk)
 	return vsock_net_mode(sock_net(sk_vsock(vsk))) == VSOCK_NET_MODE_GLOBAL;
 }
 
-static inline void vsock_net_set_child_mode(struct net *net,
+static inline bool vsock_net_set_child_mode(struct net *net,
 					    enum vsock_net_mode mode)
 {
-	WRITE_ONCE(net->vsock.child_ns_mode, mode);
+	int new_locked = mode + 1;
+	int old_locked = 0; /* unlocked */
+
+	if (try_cmpxchg(&net->vsock.child_ns_mode_locked,
+			&old_locked, new_locked)) {
+		WRITE_ONCE(net->vsock.child_ns_mode, mode);
+		return true;
+	}
+
+	return old_locked == new_locked;
 }
 
 static inline enum vsock_net_mode vsock_net_child_mode(struct net *net)
diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
index b34d69a22fa8..dc8cbe45f406 100644
--- a/include/net/netns/vsock.h
+++ b/include/net/netns/vsock.h
@@ -17,5 +17,8 @@ struct netns_vsock {
 
 	enum vsock_net_mode mode;
 	enum vsock_net_mode child_ns_mode;
+
+	/* 0 = unlocked, 1 = locked to global, 2 = locked to local */
+	int child_ns_mode_locked;
 };
 #endif /* __NET_NET_NAMESPACE_VSOCK_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9880756d9eff..50044a838c89 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -90,16 +90,20 @@
  *
  *   - /proc/sys/net/vsock/ns_mode (read-only) reports the current namespace's
  *     mode, which is set at namespace creation and immutable thereafter.
- *   - /proc/sys/net/vsock/child_ns_mode (writable) controls what mode future
+ *   - /proc/sys/net/vsock/child_ns_mode (write-once) controls what mode future
  *     child namespaces will inherit when created. The initial value matches
  *     the namespace's own ns_mode.
  *
  *   Changing child_ns_mode only affects newly created namespaces, not the
  *   current namespace or existing children. A "local" namespace cannot set
- *   child_ns_mode to "global". At namespace creation, ns_mode is inherited
- *   from the parent's child_ns_mode.
+ *   child_ns_mode to "global". child_ns_mode is write-once, so that it may be
+ *   configured and locked down by a namespace manager. Writing a different
+ *   value after the first write returns -EBUSY. At namespace creation, ns_mode
+ *   is inherited from the parent's child_ns_mode.
  *
- *   The init_net mode is "global" and cannot be modified.
+ *   The init_net mode is "global" and cannot be modified. The init_net
+ *   child_ns_mode is also write-once, so an init process (e.g. systemd) can
+ *   set it to "local" to ensure all new namespaces inherit local mode.
  *
  *   The modes affect the allocation and accessibility of CIDs as follows:
  *
@@ -2853,7 +2857,8 @@ static int vsock_net_child_mode_string(const struct ctl_table *table, int write,
 		    new_mode == VSOCK_NET_MODE_GLOBAL)
 			return -EPERM;
 
-		vsock_net_set_child_mode(net, new_mode);
+		if (!vsock_net_set_child_mode(net, new_mode))
+			return -EBUSY;
 	}
 
 	return 0;

-- 
2.47.3


