Return-Path: <kvm+bounces-68739-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MKPqMq/4cGmgbAAAu9opvQ
	(envelope-from <kvm+bounces-68739-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:02:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2827D59A01
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 844E8A80ECD
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31CE54C9008;
	Wed, 21 Jan 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxAYAXVQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRjmRTpM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20054C8FEF
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769006906; cv=none; b=MgjHuFISyu/RUCSR10pirTu0Vq/XS1SykYC4XGzlJQbuNoBGsquFSrbqOzSkOagbgOY9g+1tKKpQiEDnz3CP8nVeXtm1eBGXXJDWfJQO3yyBYrwFY9JYYFS3HHaTc2o90EzjRz3jpJAO7h9FnhTuYZuO9EcMd9peNcFgjTH8NgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769006906; c=relaxed/simple;
	bh=QUpRm5BO1PsMpJA/m+7TudemIjgPpKiHIo5jnkzHoIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuD6vpMxR0hBw3G0eUql6BTi5vJwC80FX1FNaeqyJJZX6nXofBvRy2ZjG0Zi+X59SlgVHsbh5lZQsW5iOET17Fn55ugz2QcUdknna4oXWqGsiVW88/lSPQhEI+zFX5kwMdgK4BTZetfg2jmFEF2WYEDm1wxO7hBIAZqjbHln3gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxAYAXVQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YRjmRTpM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769006902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VUJ1S4k/wjMiGcuwXZdRwnP1r4qcoeHu/Fk7TCF9Czg=;
	b=OxAYAXVQGfCqEXQ8ha9r7E0hNuArMvJZgThYPDfb2/rOn1VUti8BF2CNnLZYaVMXifHZbS
	HzrWZ6JMmJwGaX3gok3FNjN0ZhXiUzZmfCGGcpecEtsSzN+ZuVuJ6ICAnE0grtJe0sytnj
	8g96krKJDzmpuZ2FOyvQ7K5EYngfC04=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-4tqyAeMvM4ukXJQ3RccxQA-1; Wed, 21 Jan 2026 09:48:19 -0500
X-MC-Unique: 4tqyAeMvM4ukXJQ3RccxQA-1
X-Mimecast-MFC-AGG-ID: 4tqyAeMvM4ukXJQ3RccxQA_1769006899
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4801bceb317so65184065e9.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 06:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769006898; x=1769611698; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VUJ1S4k/wjMiGcuwXZdRwnP1r4qcoeHu/Fk7TCF9Czg=;
        b=YRjmRTpMJdzf8jSCZR5c6CUp2tqRg1IYXX7KFzzPx+S1hKu0rBPBEabK10izkFbZb7
         8aTnKUHGysBsdMwSM6i9tSiwT71ZCiKtR2fQRqKUiZmonS6Z8AyvmSmolPtWBVzi7hid
         EriDanVwNTHpbXWDo6tL0DmgFyKRtm45oqiTwimWc6fGHGZqX9bFE4/tqm8Mrcrc5sMj
         x3yLAIEr2mCNho2mM2Zl7hYMhul16caalRx/hFxITRdpOGTsUitDlvoxNGSWYIWp3/L4
         vieFfk4GkGCcCeXe+jUnyK529YJzuOzknU5KJP4gS1gW7Uht45DCb4t/gtJJAyN3p+jr
         Zv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769006898; x=1769611698;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VUJ1S4k/wjMiGcuwXZdRwnP1r4qcoeHu/Fk7TCF9Czg=;
        b=QGC+ce/duADN0UK2y6GK7qeq8yjg0jbBxWq+K+i8PC4alFbZ6DS7jQqpxVT2/tL5Wf
         dw1GSwleqJ+G5ceHW+IFzBp49mpGbs2U059bCtxLvwWs2ioIhDa80y1KpPMQdaGOnpVt
         akhhV3Gtxx5O2egnfODQrqiOttsAJT6WmpK1N9YdK6e8Td4WnPu1w208k3h0/0BofCaf
         nGVypEG+P4jDT4myQKWBV0EpZeA7risIfkpWmDagVU4/t+UGWpBfzhaGAIKrE4NXXOxQ
         Sp4VisNMTKnAry0zdcu2EBezYCIsqsufNUMh4uUDYDnb8Y+a6He8eMCSSWlJzatxg35B
         rKWw==
X-Forwarded-Encrypted: i=1; AJvYcCVaxu2Gwm6rrIwJeBgOcSE7ZtI6v3j65TSeDXv16AZztKIAJwAUkSM01JkGssgGpLj51V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbpZ0deMCw98aR26r7Tgp/jtsZ+ISwj9UJz9CJXCc2h0Xi3BXm
	wegke5V99XfSG6WAo05N040iZRe+m9QLXw2C6XfcOIRLJCIv9I2eTKMDJv0q3fmq2X6G/jhmi2V
	NpmXICANFQjBN1w9YagbReYmxXr/pbBTl2eRR4OPFVnjIsI95fzUsXQ==
X-Gm-Gg: AZuq6aK6ljfaPPl6si53KTxSF9Cvmmq5F6yjnHiMpqh9HVuMWEan3+ZN7p5hvNenqzO
	jIj/hWB7JPYp1uN0NgPGTjeprDevtWXnJ9df3TMiM2q1KVBCQ2krYmlOieokkUd74dSkBVh7d9h
	qE+7Xqs93/AwYtPtvf2+ONmRiHSQvvUCzcKsu4S2NclXYsAPxWmabMONCtMmqwxhhh8HEknYZex
	gG0s7NyYwFrMo4w6QkxUm+pJlemGMCaVp/U2aYSP93nEkzjZ9eXM3DH2+670c4R3FRFV53S6eYd
	hXVOh5jA/6CQ8MxO+4BraONyPwmC45qH5KDpID0gFBiMhC6CS63mk057xPdpw0UChcnvyDHGBMc
	fN+yOn9BGA4D7MLEkIwtuyeaUXjmhsHmYxGfRX4Nux+Du/W+xhmEyfl7n2IY=
X-Received: by 2002:a05:600c:820b:b0:47a:9560:ec28 with SMTP id 5b1f17b1804b1-4803e7a2d1dmr73114265e9.13.1769006898461;
        Wed, 21 Jan 2026 06:48:18 -0800 (PST)
X-Received: by 2002:a05:600c:820b:b0:47a:9560:ec28 with SMTP id 5b1f17b1804b1-4803e7a2d1dmr73113705e9.13.1769006897944;
        Wed, 21 Jan 2026 06:48:17 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-58.retail.telecomitalia.it. [82.53.134.58])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48042c5965fsm22479875e9.17.2026.01.21.06.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:48:16 -0800 (PST)
Date: Wed, 21 Jan 2026 15:48:13 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Bryan Tan <bryan-bt.tan@broadcom.com>, Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>, 
	linux-doc@vger.kernel.org, Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v15 01/12] vsock: add netns to vsock core
Message-ID: <aXDYfYy3f1NQm5A0@sgarzare-redhat>
References: <20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com>
 <20260116-vsock-vmtest-v15-1-bbfd1a668548@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260116-vsock-vmtest-v15-1-bbfd1a668548@meta.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68739-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sgarzare@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 2827D59A01
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Jan 16, 2026 at 01:28:41PM -0800, Bobby Eshleman wrote:
>From: Bobby Eshleman <bobbyeshleman@meta.com>
>
>Add netns logic to vsock core. Additionally, modify transport hook
>prototypes to be used by later transport-specific patches (e.g.,
>*_seqpacket_allow()).
>
>Namespaces are supported primarily by changing socket lookup functions
>(e.g., vsock_find_connected_socket()) to take into account the socket
>namespace and the namespace mode before considering a candidate socket a
>"match".
>
>This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
>report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
>for new namespaces.
>
>Add netns functionality (initialization, passing to transports, procfs,
>etc...) to the af_vsock socket layer. Later patches that add netns
>support to transports depend on this patch.

nit: maybe we should mention here why we changed the random port 
allocation

(not a big deal, only if you need to resend)

>
>dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
>modified to take a vsk in order to perform logic on namespace modes. In
>future patches, the net will also be used for socket
>lookups in these functions.
>
>Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
>---
>Changes in v15:
>- make static port in __vsock_bind_connectible per-netns
>- remove __net_initdata because we want the ops beyond just boot
>- add vsock_init_ns_mode kernel cmdline parameter to set init ns mode
>- use if (ret || !write) in __vsock_net_mode_string() (Stefano)
>- add vsock_net_mode_global() (Stefano)
>- hide !net == VSOCK_NET_MODE_GLOBAL inside vsock_net_mode() (Stefano)
>- clarify af_vsock.c comments on ns_mode/child_ns_mode (Stefano)
>
>Changes in v14:
>- include linux/sysctl.h in af_vsock.c
>- squash patch 'vsock: add per-net vsock NS mode state' into this patch
>  (prior version can be found here):
>  https://lore.kernel.org/all/20251223-vsock-vmtest-v13-1-9d6db8e7c80b@meta.com/)
>
>Changes in v13:
>- remove net_mode and replace with direct accesses to net->vsock.mode,
>  since this is now immutable.
>- update comments about mode behavior and mutability, and sysctl API
>- only pass NULL for net when wanting global, instead of net_mode ==
>  VSOCK_NET_MODE_GLOBAL. This reflects the new logic
>  of vsock_net_check_mode() that only requires net pointers (not
>  net_mode).
>- refactor sysctl string code into a re-usable function, because
>  child_ns_mode and ns_mode both handle the same strings.
>- remove redundant vsock_net_init(&init_net) call in module init because
>  pernet registration calls the callback on the init_net too
>
>Changes in v12:
>- return true in dgram_allow(), stream_allow(), and seqpacket_allow()
>  only if net_mode == VSOCK_NET_MODE_GLOBAL (Stefano)
>- document bind(VMADDR_CID_ANY) case in af_vsock.c (Stefano)
>- change order of stream_allow() call in vmci so we can pass vsk
>  to it
>
>Changes in v10:
>- add file-level comment about what happens to sockets/devices
>  when the namespace mode changes (Stefano)
>- change the 'if (write)' boolean in vsock_net_mode_string() to
>  if (!write), this simplifies a later patch which adds "goto"
>  for mutex unlocking on function exit.
>
>Changes in v9:
>- remove virtio_vsock_alloc_rx_skb() (Stefano)
>- remove vsock_global_dummy_net, not needed as net=NULL +
>  net_mode=VSOCK_NET_MODE_GLOBAL achieves identical result
>
>Changes in v7:
>- hv_sock: fix hyperv build error
>- explain why vhost does not use the dummy
>- explain usage of __vsock_global_dummy_net
>- explain why VSOCK_NET_MODE_STR_MAX is 8 characters
>- use switch-case in vsock_net_mode_string()
>- avoid changing transports as much as possible
>- add vsock_find_{bound,connected}_socket_net()
>- rename `vsock_hdr` to `sysctl_hdr`
>- add virtio_vsock_alloc_linear_skb() wrapper for setting dummy net and
>  global mode for virtio-vsock, move skb->cb zero-ing into wrapper
>- explain seqpacket_allow() change
>- move net setting to __vsock_create() instead of vsock_create() so
>  that child sockets also have their net assigned upon accept()
>
>Changes in v6:
>- unregister sysctl ops in vsock_exit()
>- af_vsock: clarify description of CID behavior
>- af_vsock: fix buf vs buffer naming, and length checking
>- af_vsock: fix length checking w/ correct ctl_table->maxlen
>
>Changes in v5:
>- vsock_global_net() -> vsock_global_dummy_net()
>- update comments for new uAPI
>- use /proc/sys/net/vsock/ns_mode instead of /proc/net/vsock_ns_mode
>- add prototype changes so patch remains c)mpilable
>---
> Documentation/admin-guide/kernel-parameters.txt |  14 +
> MAINTAINERS                                     |   1 +
> drivers/vhost/vsock.c                           |   6 +-
> include/linux/virtio_vsock.h                    |   4 +-
> include/net/af_vsock.h                          |  61 ++++-
> include/net/net_namespace.h                     |   4 +
> include/net/netns/vsock.h                       |  21 ++
> net/vmw_vsock/af_vsock.c                        | 328 ++++++++++++++++++++++--
> net/vmw_vsock/hyperv_transport.c                |   7 +-
> net/vmw_vsock/virtio_transport.c                |   9 +-
> net/vmw_vsock/virtio_transport_common.c         |   6 +-
> net/vmw_vsock/vmci_transport.c                  |  26 +-
> net/vmw_vsock/vsock_loopback.c                  |   8 +-
> 13 files changed, 444 insertions(+), 51 deletions(-)
>
>diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>index a8d0afde7f85..b6e3bfe365a1 100644
>--- a/Documentation/admin-guide/kernel-parameters.txt
>+++ b/Documentation/admin-guide/kernel-parameters.txt
>@@ -8253,6 +8253,20 @@ Kernel parameters
> 			            them quite hard to use for exploits but
> 			            might break your system.
>
>+	vsock_init_ns_mode=
>+			[KNL,NET] Set the vsock namespace mode for the init
>+			(root) network namespace.
>+
>+			global      [default] The init namespace operates in
>+			            global mode where CIDs are system-wide and
>+			            sockets can communicate across global
>+			            namespaces.
>+
>+			local       The init namespace operates in local mode
>+			            where CIDs are private to the namespace and
>+			            sockets can only communicate within the same
>+			            namespace.
>+

My comment on v14 was more to start a discussion :-) sorry to not be 
clear.

I briefly discussed it with Paolo in chat to better understand our 
policy between cmdline parameters and module parameters, and it seems 
that both are discouraged.

So he asked me if we have a use case for this, and thinking about it, I 
don't have one at the moment. Also, if a user decides to set all netns 
to local, whether init_net is local or global doesn't really matter, 
right?

So perhaps before adding this, we should have a real use case.
Perhaps more than this feature, I would add a way to change the default 
of all netns (including init_net) from global to local. But we can do 
that later, since all netns have a way to understand what mode they are 
in, so we don't break anything and the user has to explicitly change it, 
knowing that they are breaking compatibility with pre-netns support.\


That said, at this point, maybe we can remove this, documenting that 
init_net is always global, and if we have a use case in the future, we 
can add this (or something else) to set the init_net mode (or change the 
default for all netns).

Let's wait a bit before next version to wait a comment from Paolo or 
Jakub on this. But I'm almost fine with both ways, so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

> 	vt.color=	[VT] Default text color.
> 			Format: 0xYX, X = foreground, Y = background.
> 			Default: 0x07 = light gray on black.

[...]

>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index a3505a4dcee0..3fc8160d51df 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c

[...]

>@@ -235,33 +303,42 @@ static void __vsock_remove_connected(struct 
>vsock_sock *vsk)
> 	sock_put(&vsk->sk);
> }
>

In the v14 I suggested to add some documentation on top of the 
vsock_find*() vs vsock_find_*_net() to explain better which one should 
be used by transports.

Again is not a big deal, we can fix later if you don't need to resend.

Thanks,
Stefano

>-static struct sock *__vsock_find_bound_socket(struct sockaddr_vm *addr)
>+static struct sock *__vsock_find_bound_socket_net(struct sockaddr_vm *addr,
>+						  struct net *net)
> {
> 	struct vsock_sock *vsk;
>
> 	list_for_each_entry(vsk, vsock_bound_sockets(addr), bound_table) {
>-		if (vsock_addr_equals_addr(addr, &vsk->local_addr))
>-			return sk_vsock(vsk);
>+		struct sock *sk = sk_vsock(vsk);
>+
>+		if (vsock_addr_equals_addr(addr, &vsk->local_addr) &&
>+		    vsock_net_check_mode(sock_net(sk), net))
>+			return sk;
>
> 		if (addr->svm_port == vsk->local_addr.svm_port &&
> 		    (vsk->local_addr.svm_cid == VMADDR_CID_ANY ||
>-		     addr->svm_cid == VMADDR_CID_ANY))
>-			return sk_vsock(vsk);
>+		     addr->svm_cid == VMADDR_CID_ANY) &&
>+		     vsock_net_check_mode(sock_net(sk), net))
>+			return sk;
> 	}
>
> 	return NULL;
> }
>
>-static struct sock *__vsock_find_connected_socket(struct sockaddr_vm *src,
>-						  struct sockaddr_vm *dst)
>+static struct sock *
>+__vsock_find_connected_socket_net(struct sockaddr_vm *src,
>+				  struct sockaddr_vm *dst, struct net *net)
> {
> 	struct vsock_sock *vsk;
>
> 	list_for_each_entry(vsk, vsock_connected_sockets(src, dst),
> 			    connected_table) {
>+		struct sock *sk = sk_vsock(vsk);
>+
> 		if (vsock_addr_equals_addr(src, &vsk->remote_addr) &&
>-		    dst->svm_port == vsk->local_addr.svm_port) {
>-			return sk_vsock(vsk);
>+		    dst->svm_port == vsk->local_addr.svm_port &&
>+		    vsock_net_check_mode(sock_net(sk), net)) {
>+			return sk;
> 		}
> 	}
>
>@@ -304,12 +381,13 @@ void vsock_remove_connected(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(vsock_remove_connected);
>
>-struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>+struct sock *vsock_find_bound_socket_net(struct sockaddr_vm *addr,
>+					 struct net *net)
> {
> 	struct sock *sk;
>
> 	spin_lock_bh(&vsock_table_lock);
>-	sk = __vsock_find_bound_socket(addr);
>+	sk = __vsock_find_bound_socket_net(addr, net);
> 	if (sk)
> 		sock_hold(sk);
>
>@@ -317,15 +395,22 @@ struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>
> 	return sk;
> }
>+EXPORT_SYMBOL_GPL(vsock_find_bound_socket_net);
>+
>+struct sock *vsock_find_bound_socket(struct sockaddr_vm *addr)
>+{
>+	return vsock_find_bound_socket_net(addr, NULL);
>+}
> EXPORT_SYMBOL_GPL(vsock_find_bound_socket);
>
>-struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>-					 struct sockaddr_vm *dst)
>+struct sock *vsock_find_connected_socket_net(struct sockaddr_vm *src,
>+					     struct sockaddr_vm *dst,
>+					     struct net *net)
> {
> 	struct sock *sk;
>
> 	spin_lock_bh(&vsock_table_lock);
>-	sk = __vsock_find_connected_socket(src, dst);
>+	sk = __vsock_find_connected_socket_net(src, dst, net);
> 	if (sk)
> 		sock_hold(sk);
>
>@@ -333,6 +418,13 @@ struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>
> 	return sk;
> }
>+EXPORT_SYMBOL_GPL(vsock_find_connected_socket_net);
>+
>+struct sock *vsock_find_connected_socket(struct sockaddr_vm *src,
>+					 struct sockaddr_vm *dst)
>+{
>+	return vsock_find_connected_socket_net(src, dst, NULL);
>+}
> EXPORT_SYMBOL_GPL(vsock_find_connected_socket);
>
> void vsock_remove_sock(struct vsock_sock *vsk)


