Return-Path: <kvm+bounces-72610-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJC4MEtWp2lsgwAAu9opvQ
	(envelope-from <kvm+bounces-72610-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:44:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 278211F7B12
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 22:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DE3A23141771
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 21:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 419723932F8;
	Tue,  3 Mar 2026 21:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="XHqT1+OR"
X-Original-To: kvm@vger.kernel.org
Received: from pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.83.148.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87B73932DF;
	Tue,  3 Mar 2026 21:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.83.148.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772574220; cv=none; b=GvHJmCsUYOJCD0zKsWAt2MYnI7AWjZsg2Hhsjxz2hjEz1LL8tqSWGZTw/YKwtDsomuiiJPVqfEXfzGU112Y8k5YyW/QLcZkJNJDP7pQHiSgZuNymGWysEgtkSiA/2dXNK/zWUjWvaaRBuOlTQKqEMlhvgawFVWY7N80TZI8a344=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772574220; c=relaxed/simple;
	bh=PzZ/ezFzbZYsh4eEucGwJNBE0sfci7zr4IfTd9AZZQE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ImmmSEB40pLbhG13QiTbkwR72l7IVmNpj1bS9TIDddLuxiDiiJd/ePcmxoqmtEJiSvRlwKEYubKtirQQVoanfX4GYG28W/jHZBnXYlupM0ijkov4JOBeznvKUWdInIV2gm5R54iKTSX/MXKOIDfQkfl2lyaH1YqPgGLOtz5tc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=XHqT1+OR; arc=none smtp.client-ip=35.83.148.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772574217; x=1804110217;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D3ckCkYROGkaxEpbd7UYWDIIPso4ExOTEY90wAeHS5w=;
  b=XHqT1+ORnUOur3z6+04PMzUDUbSkS5lfcTpvXEKBnmSMxLCkutPALExF
   OMyDmsnJK1T/leAvD7gZ6/prh551t6iZiE5bAgJIUa3WTo+KXXfYgo5m9
   e6rBLP2Sw2D5pTfezv+eGcgVfx9WrkdbWbA1oFxLcLWsvRUMprHQzTNzm
   33zmZNnLLHgeMeCSOHt/g1VvXwFe6tvjp7N3yPV10ng/MVxy9w5jmNAe9
   yv+0PzgB+yRfUgjOa4JiHiFza+Lo/fslAJMOH+PTGYtjpT9/ONyTdgmC9
   0WuNEHka9Rnn7ZkUASpC8LLVOm6ucNbtp7n+va/TR8vd38Ukc8ABGubgr
   A==;
X-CSE-ConnectionGUID: LacM7+auRcGIgU+IqM8cXg==
X-CSE-MsgGUID: 7PkRHH6xQZySyQkP+cWsLA==
X-IronPort-AV: E=Sophos;i="6.21,322,1763424000"; 
   d="scan'208";a="14011449"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-014.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 21:43:35 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:17624]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.102:2525] with esmtp (Farcaster)
 id a9b15450-ae14-40c5-b4b8-c776a92886c5; Tue, 3 Mar 2026 21:43:34 +0000 (UTC)
X-Farcaster-Flow-ID: a9b15450-ae14-40c5-b4b8-c776a92886c5
Received: from EX19D020UWC004.ant.amazon.com (10.13.138.149) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 3 Mar 2026 21:43:34 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D020UWC004.ant.amazon.com (10.13.138.149) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 3 Mar 2026 21:43:31 +0000
From: Alexander Graf <graf@amazon.com>
To: <virtualization@lists.linux.dev>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<kvm@vger.kernel.org>, <eperezma@redhat.com>, Jason Wang
	<jasowang@redhat.com>, <mst@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	<bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Jonathan Corbet
	<corbet@lwn.net>, Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa
	<vishnu.dasa@broadcom.com>, <nh-open-source@amazon.com>,
	<syzbot@syzkaller.appspotmail.com>
Subject: [PATCH v3] vsock: add G2H fallback for CIDs not owned by H2G transport
Date: Tue, 3 Mar 2026 21:43:29 +0000
Message-ID: <20260303214329.71711-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D036UWC003.ant.amazon.com (10.13.139.214) To
 EX19D020UWC004.ant.amazon.com (10.13.138.149)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 278211F7B12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-8.16 / 15.00];
	WHITELIST_DMARC(-7.00)[amazon.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amazon.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amazon.com:s=amazoncorp2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	TAGGED_FROM(0.00)[bounces-72610-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[appspotmail.com:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[graf@amazon.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[amazon.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Action: no action

When no H2G transport is loaded, vsock currently routes all CIDs to the
G2H transport (commit 65b422d9b61b, "vsock: forward all packets to the
host when no H2G is registered"). Extend that existing behavior: when
an H2G transport is loaded but does not claim a given CID, the
connection falls back to G2H in the same way.

This matters in environments like Nitro Enclaves, where an instance may
run nested VMs via vhost-vsock (H2G) while also needing to reach sibling
enclaves at higher CIDs through virtio-vsock-pci (G2H). With the old
code, any CID > 2 was unconditionally routed to H2G when vhost was
loaded, making those enclaves unreachable without setting
VMADDR_FLAG_TO_HOST explicitly on every connect.

Requiring every application to set VMADDR_FLAG_TO_HOST creates friction:
tools like socat, iperf, and others would all need to learn about it.
The flag was introduced 6 years ago and I am still not aware of any tool
that supports it. Even if there was support, it would be cumbersome to
use. The most natural experience is a single CID address space where H2G
only wins for CIDs it actually owns, and everything else falls through to
G2H, extending the behavior that already exists when H2G is absent.

To give user space at least a hint that the kernel applied this logic,
automatically set the VMADDR_FLAG_TO_HOST on the remote address so it
can determine the path taken via getpeername().

Add a per-network namespace sysctl net.vsock.g2h_fallback (default 1).
At 0 it forces strict routing: H2G always wins for CID > VMADDR_CID_HOST,
or ENODEV if H2G is not loaded.

Signed-off-by: Alexander Graf <graf@amazon.com>
Tested-by: syzbot@syzkaller.appspotmail.com

---

v1 -> v2:

  - Rebase on 7.0, include namespace support
  - Add net.vsock.g2h_fallback sysctl
  - Rework description
  - Set VMADDR_FLAG_TO_HOST automatically
  - Add VMCI support
  - Update vsock_assign_transport() comment

v2 -> v3:

  - Use has_remote_cid() on G2H transport to gate the fallback. This is
    used by VMCI to indicate that it never takes G2H CIDs > 2.
  - Move g2h_fallback into struct netns_vsock to enable namespaces
    and fix syzbot warning
  - Gate the !transport_h2g case on g2h_fallback as well, folding the
    pre-existing no-H2G fallback into the new logic
  - Remove has_remote_cid() from VMCI again. Instead implement it in
    virtio.
---
 Documentation/admin-guide/sysctl/net.rst | 28 +++++++++++++++++++
 drivers/vhost/vsock.c                    | 13 +++++++++
 include/net/af_vsock.h                   |  9 +++++++
 include/net/netns/vsock.h                |  2 ++
 net/vmw_vsock/af_vsock.c                 | 34 ++++++++++++++++++++----
 net/vmw_vsock/virtio_transport.c         |  7 +++++
 6 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 3b2ad61995d4..98b9eaa9cb9e 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -602,3 +602,31 @@ it does not modify the current namespace or any existing children.
 
 A namespace with ``ns_mode`` set to ``local`` cannot change
 ``child_ns_mode`` to ``global`` (returns ``-EPERM``).
+
+g2h_fallback
+------------
+
+Controls whether connections to CIDs not owned by the host-to-guest (H2G)
+transport automatically fall back to the guest-to-host (G2H) transport.
+
+When enabled, if a connect targets a CID that the H2G transport (e.g.
+vhost-vsock) does not serve, or if no H2G transport is loaded at all, the
+connection is routed via the G2H transport (e.g. virtio-vsock) instead. This
+allows a host running both nested VMs (via vhost-vsock) and sibling VMs
+reachable through the hypervisor (e.g. Nitro Enclaves) to address both using
+a single CID space, without requiring applications to set
+``VMADDR_FLAG_TO_HOST``.
+
+When the fallback is taken, ``VMADDR_FLAG_TO_HOST`` is automatically set on
+the remote address so that userspace can determine the path via
+``getpeername()``.
+
+Note: With this sysctl enabled, user space that attempts to talk to a guest
+CID which is not implemented by vhost will create host vsock traffic.
+Environments that rely on H2G-only isolation should set it to 0.
+
+Values:
+
+	- 0 - Connections to CIDs <= 2 or with VMADDR_FLAG_TO_HOST use G2H;
+	  all others use H2G (or fail with ENODEV if H2G is not loaded).
+	- 1 - Connections to CIDs not owned by H2G fall back to G2H. (default)
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 054f7a718f50..319e3a690108 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -91,6 +91,18 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
 	return NULL;
 }
 
+static bool vhost_transport_has_remote_cid(struct vsock_sock *vsk, u32 cid)
+{
+	struct sock *sk = sk_vsock(vsk);
+	struct net *net = sock_net(sk);
+	bool found;
+
+	rcu_read_lock();
+	found = vhost_vsock_get(cid, net) != NULL;
+	rcu_read_unlock();
+	return found;
+}
+
 static void
 vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			    struct vhost_virtqueue *vq)
@@ -424,6 +436,7 @@ static struct virtio_transport vhost_transport = {
 		.module                   = THIS_MODULE,
 
 		.get_local_cid            = vhost_transport_get_local_cid,
+		.has_remote_cid           = vhost_transport_has_remote_cid,
 
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 533d8e75f7bb..4e40063adab4 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -179,6 +179,15 @@ struct vsock_transport {
 	/* Addressing. */
 	u32 (*get_local_cid)(void);
 
+	/* Check if this transport serves a specific remote CID.
+	 * For H2G transports: return true if the CID belongs to a registered
+	 * guest. If not implemented, all CIDs > VMADDR_CID_HOST go to H2G.
+	 * For G2H transports: return true if the transport can reach arbitrary
+	 * CIDs via the hypervisor (i.e. supports the fallback overlay). VMCI
+	 * does not implement this as it only serves CIDs 0 and 2.
+	 */
+	bool (*has_remote_cid)(struct vsock_sock *vsk, u32 remote_cid);
+
 	/* Read a single skb */
 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
 
diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
index dc8cbe45f406..7f84aad92f57 100644
--- a/include/net/netns/vsock.h
+++ b/include/net/netns/vsock.h
@@ -20,5 +20,7 @@ struct netns_vsock {
 
 	/* 0 = unlocked, 1 = locked to global, 2 = locked to local */
 	int child_ns_mode_locked;
+
+	int g2h_fallback;
 };
 #endif /* __NET_NET_NAMESPACE_VSOCK_H */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 2f7d94d682cb..0cdc3df9b63c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -545,9 +545,13 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
  * The vsk->remote_addr is used to decide which transport to use:
  *  - remote CID == VMADDR_CID_LOCAL or g2h->local_cid or VMADDR_CID_HOST if
  *    g2h is not loaded, will use local transport;
- *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
- *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
+ *  - remote CID <= VMADDR_CID_HOST or remote flags field includes
+ *    VMADDR_FLAG_TO_HOST, will use guest->host transport;
+ *  - remote CID > VMADDR_CID_HOST and h2g is loaded and h2g claims that CID,
+ *    will use host->guest transport;
+ *  - h2g not loaded or h2g does not claim that CID and g2h claims the CID via
+ *    has_remote_cid, will use guest->host transport (when g2h_fallback=1)
+ *  - anything else goes to h2g or returns -ENODEV if no h2g is available
  */
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 {
@@ -581,10 +585,19 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	case SOCK_SEQPACKET:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
+		else if (remote_cid <= VMADDR_CID_HOST ||
 			 (remote_flags & VMADDR_FLAG_TO_HOST))
 			new_transport = transport_g2h;
-		else
+		else if (transport_h2g &&
+			 (!transport_h2g->has_remote_cid ||
+			  transport_h2g->has_remote_cid(vsk, remote_cid)))
+			new_transport = transport_h2g;
+		else if (sock_net(sk)->vsock.g2h_fallback &&
+			 transport_g2h && transport_g2h->has_remote_cid &&
+			 transport_g2h->has_remote_cid(vsk, remote_cid)) {
+			vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
+			new_transport = transport_g2h;
+		} else
 			new_transport = transport_h2g;
 		break;
 	default:
@@ -2879,6 +2892,15 @@ static struct ctl_table vsock_table[] = {
 		.mode		= 0644,
 		.proc_handler	= vsock_net_child_mode_string
 	},
+	{
+		.procname	= "g2h_fallback",
+		.data		= &init_net.vsock.g2h_fallback,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 
 static int __net_init vsock_sysctl_register(struct net *net)
@@ -2894,6 +2916,7 @@ static int __net_init vsock_sysctl_register(struct net *net)
 
 		table[0].data = &net->vsock.mode;
 		table[1].data = &net->vsock.child_ns_mode;
+		table[2].data = &net->vsock.g2h_fallback;
 	}
 
 	net->vsock.sysctl_hdr = register_net_sysctl_sz(net, "net/vsock", table,
@@ -2928,6 +2951,7 @@ static void vsock_net_init(struct net *net)
 		net->vsock.mode = vsock_net_child_mode(current->nsproxy->net_ns);
 
 	net->vsock.child_ns_mode = net->vsock.mode;
+	net->vsock.g2h_fallback = 1;
 }
 
 static __net_init int vsock_sysctl_init_net(struct net *net)
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 77fe5b7b066c..57f2d6ec3ffc 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -547,11 +547,18 @@ bool virtio_transport_stream_allow(struct vsock_sock *vsk, u32 cid, u32 port)
 static bool virtio_transport_seqpacket_allow(struct vsock_sock *vsk,
 					     u32 remote_cid);
 
+static bool virtio_transport_has_remote_cid(struct vsock_sock *vsk, u32 cid)
+{
+	/* The CID could be implemented by the host. Always assume it is. */
+	return true;
+}
+
 static struct virtio_transport virtio_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
 
 		.get_local_cid            = virtio_transport_get_local_cid,
+		.has_remote_cid           = virtio_transport_has_remote_cid,
 
 		.init                     = virtio_transport_do_socket_init,
 		.destruct                 = virtio_transport_destruct,
-- 
2.47.1




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


