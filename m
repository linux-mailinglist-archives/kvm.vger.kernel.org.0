Return-Path: <kvm+bounces-72520-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHUtBATXpmnHWgAAu9opvQ
	(envelope-from <kvm+bounces-72520-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 13:41:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 712AD1EF9DA
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 13:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F198C30FF48E
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 12:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE80345722;
	Tue,  3 Mar 2026 12:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmTVzkBH";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7Mfx8Tf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1ED832FA29
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541153; cv=none; b=uTB9mQOZ7AdR2oUkUd6v+koB9yyz2ObjkTLa5X7W1fFfXS3BHkruu234WKzwcWQb9mZrrhhp2EyD1WgeEH1PHn6el8lDh7TurliUZ/DEPB2MVus8QyoakhJqSTOh+EKBtNDO4BOnFVz0wVUI/YKne9OVwiwjiJw+Z7TbqrtM8h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541153; c=relaxed/simple;
	bh=vMNiiAt1Fwy9Teu2yIb26JC5dV3q4DvAFgv8ItOJHfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ClQWWbux6tNMtS8377NZAP9EclD1LGZv45Sj8P4+O7hE47q2RyRFbWprTSRnoZvxkhRCcmbjEIdJwdANCLOCokRYTNLD6Lb2pwSIgO3Cqt03Z9Qa48y+CIL+tkqnZOuBwGXygACdez3udktNWD2VKZdYWjcG+A+g+V3O97NRk9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmTVzkBH; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=L7Mfx8Tf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772541150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=33vOBPb9YBeaZHuv0n0JQPoCQUrGGFAN/nM5xsJK9iY=;
	b=ZmTVzkBH8MQHcOiOpAsuqAnEyhh1bg9T/pRucApQmGd9dgUlSa09zwv045A+iq1HnqZnLA
	5y6CN5WcE1rN3AczzXgSPzLujdwgDwGg3QApIQwo2DNQdHWffxMzkncy6LIedeH5Rb6IZ9
	Ed95GODkNPOqJJW/zJg7Rh5QOZ9L3+4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-UVS6fE8bO86Rw1lzPfZHrg-1; Tue, 03 Mar 2026 07:32:29 -0500
X-MC-Unique: UVS6fE8bO86Rw1lzPfZHrg-1
X-Mimecast-MFC-AGG-ID: UVS6fE8bO86Rw1lzPfZHrg_1772541148
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4806b12ad3fso46365445e9.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 04:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772541148; x=1773145948; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=33vOBPb9YBeaZHuv0n0JQPoCQUrGGFAN/nM5xsJK9iY=;
        b=L7Mfx8Tf7UoOHamY1uAizJjtgx+vbogGy79NU9OCE+iEx1j1EVs+WVFQHv+xGIBt9G
         oWialC8rA0nldnegfhM6dAMAZ7YfRQSQ6NJaZ4GRWOVeMjlR0H/ahMB0E2Wk0jamtTS3
         +SD7Jk9Ai8dGa872W6oCn3NupOzne+BkPGvi18wLD7wbEgFvwWtRphGVSAA6E+6IIkTS
         9BXOrUV/uWki6+izVXWFezdjj5izvGFsq6KE5OUlW6lkmDxzlJDSC/eAZiWjjyd0VmqZ
         FnvxS0/ipms3yG9pu6xDPoKM7gpyjdckJxuRs4ZDurgt0bRtoSuSy44Dz+iFniVN45ER
         SzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772541148; x=1773145948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33vOBPb9YBeaZHuv0n0JQPoCQUrGGFAN/nM5xsJK9iY=;
        b=avfzoy1BtXK/mmJJ1p9plqLS7/KPG27KR4w4BJvn87fCPhybiZfswTosNYZjvHb6pP
         CPXPX/DnDK89PTKa31m9eB2u4yrhm3GySxAJHaDzWNEeQNa0M0oqLWLh6mW5lcvDrjgD
         pFyH2L98kuhITCN5XcLFX4AffSi4LfHC1VVnDVBo/TKDnlEs9GokBQtSaSeviu7jeloG
         0Y3zJn73KtYVqL1KWLV8RkDzxGV9ZesyDcX7z1sXIryrJQVRi3vj/hJ8UkiPl33nfJ9O
         4eNKkcZHyeOiSurrGvqwqeNimrtxKvvmeTGUaW/PXo698hbPiVXmSGM7NQfDu/ZqiyzM
         nHtw==
X-Forwarded-Encrypted: i=1; AJvYcCVKe9xSh5fGPy6x0STDeXyAsG6dVWiOeurt6nhaioZCo3OIKHDWqhRBXuwUxFX65RWgwJ8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBpt+Hr7I5kX8NnAYeEUpk4/oqDlrkoer0+o5qU9QUd6de4GFa
	z1cu0p8l0jW5SHkdI3lqSxSuCplsRHhIeD9Z6bmAEztRosYA58hsL2CNNeiXYwegExHspH2y3UE
	lYdRYQt9EyPr8UDQ0AcQOnGoDVF/ZgVu3ces0xB+RnTbisKqcq345IA==
X-Gm-Gg: ATEYQzxO4gm6sYk9NB4GuB5lt6//Edtsj43QEGHnoLyaFgTZQjNHzMzfNnoGil8riHJ
	TkPPtgq/gj3hN8Gcq0yse4s+d9Ua4C8VTOZgp2hZ7H8j3oUPHnMLZwvjGcL9ZSpeYUj8Hwn5KV6
	yOuiRqwHhd6/2T2RXeVxqCglLt8XWlLewBNKr9fGGwICthmgn0aIlMCkGj8n0HZxPWDNeUiF9/r
	3NB27k2vlWk9SIrDL7/6rOFpYR1LIKL71fq92qnYovNbO0wUDfEF60f2qkzXIKd/+SuDdMNydUR
	KD+HSbdXSUv8ppxD8KMaT/B5w2yWpeIWVkYHZEnat/fncvtSzL2I/iCntCxt6yp7/1jkPNHlcAq
	GnfXxbXhZ2/3JP8hWHvhXgHiIwx19B5Ov7KWil25SpMdYVlcEC0hdrsfw8C1DKqPLBJOXeMU=
X-Received: by 2002:a05:600c:3b22:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-483c9c2d29amr255124565e9.30.1772541148149;
        Tue, 03 Mar 2026 04:32:28 -0800 (PST)
X-Received: by 2002:a05:600c:3b22:b0:479:35e7:a0e3 with SMTP id 5b1f17b1804b1-483c9c2d29amr255123855e9.30.1772541147625;
        Tue, 03 Mar 2026 04:32:27 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4851262ee4asm24386825e9.1.2026.03.03.04.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 04:32:25 -0800 (PST)
Date: Tue, 3 Mar 2026 13:32:20 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: virtualization@lists.linux.dev, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, eperezma@redhat.com, 
	Jason Wang <jasowang@redhat.com>, mst@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, 
	bcm-kernel-feedback-list@broadcom.com, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock: add G2H fallback for CIDs not owned by H2G
 transport
Message-ID: <aabUfziQhUFeZZx9@sgarzare-redhat>
References: <20260302194926.90378-1-graf@amazon.com>
 <aaa0UCkzFRyuVp4N@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aaa0UCkzFRyuVp4N@sgarzare-redhat>
X-Rspamd-Queue-Id: 712AD1EF9DA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72520-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 11:28:20AM +0100, Stefano Garzarella wrote:
>Please mark this as `net-next` material. AF_VSOCK core changes are 
>queued by net maintainers and that will help them to get the right 
>tree:
>https://docs.kernel.org/process/maintainer-netdev.html#git-trees-and-patch-flow
>
>On Mon, Mar 02, 2026 at 07:49:26PM +0000, Alexander Graf wrote:
>>Vsock maintains a single CID number space which can be used to
>>communicate to the host (G2H) or to a child-VM (H2G). The current logic
>>assumes that G2H is only relevant for CID <= 2 because these target the
>>hypervisor. However, in environments like Nitro Enclaves, an instance
>>that hosts vhost_vsock powered VMs may still want to communicate to
>>Enclaves that are reachable at higher CIDs through virtio-vsock-pci.
>>
>>Vsock introduced VMADDR_FLAG_TO_HOST to allow user space applications
>>to clearly express a desire to talk to the host instead of a guest via
>>the passed target CID. However, users may not actually know which one
>>they want to talk to and the application ecosystem has not picked up a
>>way for users to specify that desire.
>>
>>Instead, make it easy for users and introduce a G2H fallback mechanism:
>>when user space attempts to connect to a CID and the H2G transport
>>(vhost-vsock / VMCI) does not own it, automatically route the connection
>>through the G2H transport. This provides a single unified CID address
>>space where vhost-registered CIDs go to nested VMs and all other CIDs
>>are routed to the hypervisor.
>>
>>To give user space at least a hint that the kernel applied this logic,
>>automatically set the VMADDR_FLAG_TO_HOST on the remote address so it
>>can determine the path taken via getpeername().
>>
>>To force the system back into old behavior, provide a sysctl
>>(net.vsock.g2h_fallback, defaults to 1).
>
>I'm still concerned about this change. Perhaps we should document the 
>fact that if H2G is not loaded, we already behave in this way, and 
>sysctl helps us definitively to better define this behavior.
>
>>
>>Signed-off-by: Alexander Graf <graf@amazon.com>
>>
>>---
>>
>>v1 -> v2:
>>
>> - Rebase on 7.0, include namespace support
>> - Add net.vsock.g2h_fallback sysctl
>> - Rework description
>> - Set VMADDR_FLAG_TO_HOST automatically
>> - Add VMCI support
>> - Update vsock_assign_transport() comment
>>---
>>Documentation/admin-guide/sysctl/net.rst | 22 ++++++++++++++++++++++
>>drivers/misc/vmw_vmci/vmci_context.c     |  1 +
>>drivers/vhost/vsock.c                    | 13 +++++++++++++
>>include/linux/vmw_vmci_api.h             |  1 +
>>include/net/af_vsock.h                   |  3 +++
>>net/vmw_vsock/af_vsock.c                 | 20 +++++++++++++++++++-
>>net/vmw_vsock/vmci_transport.c           |  6 ++++++
>>7 files changed, 65 insertions(+), 1 deletion(-)
>>
>>diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
>>index 3b2ad61995d4..cc364baa9021 100644
>>--- a/Documentation/admin-guide/sysctl/net.rst
>>+++ b/Documentation/admin-guide/sysctl/net.rst
>>@@ -602,3 +602,25 @@ it does not modify the current namespace or any existing children.
>>
>>A namespace with ``ns_mode`` set to ``local`` cannot change
>>``child_ns_mode`` to ``global`` (returns ``-EPERM``).
>>+
>>+g2h_fallback
>>+------------
>>+
>>+Controls whether connections to CIDs not owned by the host-to-guest (H2G)
>>+transport automatically fall back to the guest-to-host (G2H) transport.
>>+
>>+When enabled, if a connect targets a CID that the H2G transport (e.g.
>>+vhost-vsock) does not serve, the connection is routed via the G2H transport
>>+(e.g. virtio-vsock) instead. This allows a host running both nested VMs
>>+(via vhost-vsock) and sibling VMs reachable through the hypervisor (e.g.
>>+Nitro Enclaves) to address both using a single CID space, without requiring
>>+applications to set ``VMADDR_FLAG_TO_HOST``.
>>+
>>+When the fallback is taken, ``VMADDR_FLAG_TO_HOST`` is automatically set on
>>+the remote address so that userspace can determine the path via
>>+``getpeername()``.
>>+
>>+Values:
>>+
>>+	- 0 - Connections to CIDs < 3 get handled by G2H, others by H2G.
>>+	- 1 - Connections to CIDs not owned by H2G fall back to G2H. (default)
>>diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
>>index 19ca00feed6e..577296784df5 100644
>>--- a/drivers/misc/vmw_vmci/vmci_context.c
>>+++ b/drivers/misc/vmw_vmci/vmci_context.c
>>@@ -364,6 +364,7 @@ bool vmci_ctx_exists(u32 cid)
>>	rcu_read_unlock();
>>	return exists;
>>}
>>+EXPORT_SYMBOL_GPL(vmci_ctx_exists);
>>
>>/*
>> * Retrieves VMCI context corresponding to the given cid.
>>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>>index 054f7a718f50..319e3a690108 100644
>>--- a/drivers/vhost/vsock.c
>>+++ b/drivers/vhost/vsock.c
>>@@ -91,6 +91,18 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid, struct net *net)
>>	return NULL;
>>}
>>
>>+static bool vhost_transport_has_remote_cid(struct vsock_sock *vsk, u32 cid)
>>+{
>>+	struct sock *sk = sk_vsock(vsk);
>>+	struct net *net = sock_net(sk);
>>+	bool found;
>>+
>>+	rcu_read_lock();
>>+	found = vhost_vsock_get(cid, net) != NULL;
>>+	rcu_read_unlock();
>>+	return found;
>>+}
>>+
>>static void
>>vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
>>			    struct vhost_virtqueue *vq)
>>@@ -424,6 +436,7 @@ static struct virtio_transport vhost_transport = {
>>		.module                   = THIS_MODULE,
>>
>>		.get_local_cid            = vhost_transport_get_local_cid,
>>+		.has_remote_cid           = vhost_transport_has_remote_cid,
>>
>>		.init                     = virtio_transport_do_socket_init,
>>		.destruct                 = virtio_transport_destruct,
>>diff --git a/include/linux/vmw_vmci_api.h b/include/linux/vmw_vmci_api.h
>>index 41764a684423..c412d17c572f 100644
>>--- a/include/linux/vmw_vmci_api.h
>>+++ b/include/linux/vmw_vmci_api.h
>>@@ -37,6 +37,7 @@ int vmci_doorbell_create(struct vmci_handle *handle, u32 flags,
>>int vmci_doorbell_destroy(struct vmci_handle handle);
>>u32 vmci_get_context_id(void);
>>bool vmci_is_context_owner(u32 context_id, kuid_t uid);
>>+bool vmci_ctx_exists(u32 cid);
>>int vmci_register_vsock_callback(vmci_vsock_cb callback);
>>
>>int vmci_event_subscribe(u32 event,
>>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>>index 533d8e75f7bb..0aeb25642827 100644
>>--- a/include/net/af_vsock.h
>>+++ b/include/net/af_vsock.h
>>@@ -179,6 +179,9 @@ struct vsock_transport {
>>	/* Addressing. */
>>	u32 (*get_local_cid)(void);
>>
>>+	/* Check if this transport serves a specific remote CID. */
>>+	bool (*has_remote_cid)(struct vsock_sock *vsk, u32 remote_cid);
>>+
>>	/* Read a single skb */
>>	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
>>
>>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>>index 2f7d94d682cb..b41bc734d6c0 100644
>>--- a/net/vmw_vsock/af_vsock.c
>>+++ b/net/vmw_vsock/af_vsock.c
>>@@ -210,6 +210,8 @@ static const struct vsock_transport *transport_dgram;
>>static const struct vsock_transport *transport_local;
>>static DEFINE_MUTEX(vsock_register_mutex);
>>
>>+static int vsock_g2h_fallback = 1;
>>+
>>/**** UTILS ****/
>>
>>/* Each bound VSocket is stored in the bind hash table and each connected
>>@@ -547,7 +549,8 @@ static void vsock_deassign_transport(struct vsock_sock *vsk)
>> *    g2h is not loaded, will use local transport;
>> *  - remote CID <= VMADDR_CID_HOST or h2g is not loaded or remote flags field
>> *    includes VMADDR_FLAG_TO_HOST flag value, will use guest->host transport;
>>- *  - remote CID > VMADDR_CID_HOST will use host->guest transport;
>>+ *  - remote CID > VMADDR_CID_HOST will use host->guest transport if h2g has
>>+ *    registered that CID, otherwise will use guest->host transport (overlay);
>> */
>>int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>>{
>>@@ -584,6 +587,12 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
>>		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
>>			 (remote_flags & VMADDR_FLAG_TO_HOST))
>>			new_transport = transport_g2h;
>>+		else if (vsock_g2h_fallback &&
>
>IMO `vsock_g2h_fallback` should also control the fallback when 
>transport_h2g == NULL. In this way is easiest to justify why the 
>default is to have the fallback enabled.
>
>>+			 transport_h2g->has_remote_cid &&
>>+			 !transport_h2g->has_remote_cid(vsk, remote_cid)) {
>>+			vsk->remote_addr.svm_flags |= VMADDR_FLAG_TO_HOST;
>>+			new_transport = transport_g2h;
>>+		}
>>		else
>>			new_transport = transport_h2g;
>>		break;
>>@@ -2879,6 +2888,15 @@ static struct ctl_table vsock_table[] = {
>>		.mode		= 0644,
>>		.proc_handler	= vsock_net_child_mode_string
>>	},
>>+	{
>>+		.procname	= "g2h_fallback",
>>+		.data		= &vsock_g2h_fallback,
>>+		.maxlen		= sizeof(int),
>>+		.mode		= 0644,
>>+		.proc_handler	= proc_dointvec_minmax,
>>+		.extra1		= SYSCTL_ZERO,
>>+		.extra2		= SYSCTL_ONE,
>>+	},
>
>syzbot is reporting a warning with this change:
>https://lore.kernel.org/netdev/69a6940b.a70a0220.135158.0007.GAE@google.com/
>    sysctl net/vsock/g2h_fallback: data points to kernel global data:     
>vsock_g2h_fallback
>
>IIUC because vsock_table is per-netns stuff, while `g2h_fallback` is a 
>global setting, so I guess we need to use another ctl_table for that.

Oh right, as Michael pointed out maybe it is better to have this 
per-netns and inherit the value from the parent while init_ns will have 
the default.

Stefano

>
>Thanks,
>Stefano
>
>>};
>>
>>static int __net_init vsock_sysctl_register(struct net *net)
>>diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
>>index 4296ca1183f1..de3dff52c566 100644
>>--- a/net/vmw_vsock/vmci_transport.c
>>+++ b/net/vmw_vsock/vmci_transport.c
>>@@ -2045,6 +2045,11 @@ static u32 vmci_transport_get_local_cid(void)
>>	return vmci_get_context_id();
>>}
>>
>>+static bool vmci_transport_has_remote_cid(struct vsock_sock *vsk, u32 cid)
>>+{
>>+	return vmci_ctx_exists(cid);
>>+}
>>+
>>static struct vsock_transport vmci_transport = {
>>	.module = THIS_MODULE,
>>	.init = vmci_transport_socket_init,
>>@@ -2074,6 +2079,7 @@ static struct vsock_transport vmci_transport = {
>>	.notify_send_post_enqueue = vmci_transport_notify_send_post_enqueue,
>>	.shutdown = vmci_transport_shutdown,
>>	.get_local_cid = vmci_transport_get_local_cid,
>>+	.has_remote_cid = vmci_transport_has_remote_cid,
>>};
>>
>>static bool vmci_check_transport(struct vsock_sock *vsk)
>>-- 
>>2.47.1
>>
>>
>>
>>
>>Amazon Web Services Development Center Germany GmbH
>>Tamara-Danz-Str. 13
>>10243 Berlin
>>Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
>>Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
>>Sitz: Berlin
>>Ust-ID: DE 365 538 597
>>
>>


