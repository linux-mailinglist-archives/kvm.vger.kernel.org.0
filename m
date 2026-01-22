Return-Path: <kvm+bounces-68908-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFZDIMNUcmkJiwAAu9opvQ
	(envelope-from <kvm+bounces-68908-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:48:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EC16A429
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:48:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D23F3002E58
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE02F4657F4;
	Thu, 22 Jan 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l2Rj+KiD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920EA43CEF7
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097693; cv=none; b=S8gw6hyBgMSfRYgzdExljcs4mFChXr/hdIKvZKUj5rj1b55sTzZK9HHPcK1rvxIUf7JDwlgvEQoouA7z8z7g5XJWWQh/zQxHzbo98OGn6R2Vrz4+g04SmOB81L47FmuWb1F+l+vc7c+PWHk9qwyBrO9wxkbKVJvxFnzH2FihnyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097693; c=relaxed/simple;
	bh=9JzOfqiTFO39kgxFQWVLYY5umNJRQRPCw/NtCy7HzoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ubO5sVNosjZATBL+LOTTLzT91aK0NVhP2kmXnhZHS8PeawiQVXyUUOqj3MlykTKj5fDNLJORidWvqQuhKUOqSB5Kw4Yc6E7M1yfTwqevtelc+N48Dke6V9BZUAWvQWmshwAnQwnHi0sV/GjMZOCh5dpgVMXZjmCXhSkCZlqToxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l2Rj+KiD; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-648ff033fb2so1268929d50.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769097688; x=1769702488; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4nNXaOW8SsH8VsbBiV479RmC0+eq7tMcFo5rcunlQoQ=;
        b=l2Rj+KiDdtD2q2NtiGMA5033btXx9v484iJj7k8xvoYFUvON0uWN//Nj0B5cEZyYul
         k8z+xwAcG4QnP/VahCqMOrvr3kNZJu14BB2o8opiF+eHpFAxpgElXJ6ycHbEVZkbIRD7
         rpdBZZfPcAObZ4iovLDSomfuB/s4pjTq2lFUqlmgqWdE6oJy5RUYj5cZe9uGJHN0M494
         llfIRIqnvzfZwBz14cODqAs3+Sa9Ytcpw6atLylFbOKCh0RbvLu7V39tzPsAij/QIppG
         Kn19Zf7i/MnoUjTB2+4IWB1BZUNurieL8640i6M9ASZR7pjIn3vnLTbALhflJdeG896f
         VXFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769097688; x=1769702488;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4nNXaOW8SsH8VsbBiV479RmC0+eq7tMcFo5rcunlQoQ=;
        b=J6E+vvS20OHrtT0nwI/FgBQdXATj0AGDA21r1Jsd1gY7G0NT/UaOcyTmz3UuxyKpIA
         YCIjmZVv8tQoHffYrtXRsfjveddU5pD2f5qPFtzeXzjd+1XUD4F7/pjU8OkLbEvpxgOz
         +EW3KC9BWo+3gMJxB0uLhy7TTBGULTLVeNKlpB2ACAV4rER9TSyQ+XW4nycm/VUWdsPs
         Sv6gvimHQxQtyZrt612+02pInqqZwRTkCyKIZNyDUJeNl8Zq5IlBSMaKLSxDan3bVDyj
         SdVtqJewNl76KbwDPDuMdxmrcnxPEPi689We3uo9+MnWf8eiST/ydcYbP787QHRKmGjp
         BKqg==
X-Forwarded-Encrypted: i=1; AJvYcCXr+6O9stXPlbSiJ3Lr6MDplrOWhC2qKx5CKne7flybTaL+stcUOi1AD5dMVnROEeoaHKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHVVDRJfd3myzTqaroGMS8+/e6e3uxt3UV/XYBcC3S8FStH+8j
	z3UcvjNzLlEiBcDI05+NMBhbMRvLtB6xg9b9xRhb1fm1dD9rPG7D3o1d
X-Gm-Gg: AZuq6aJ4Y1Uya5RB8cSqYoBMj7P/hPdHjdoB+EikVElH1bt1Z4MEI5NxwCm7Xb2Lh2q
	8hWH3aqXUVDxmWoYLaoafTShJpS1vVJBKq1RttIft48NexgM07WKhsrF1gK68zofqOXtH2+MSke
	GUR7hzVW2gqsMNPv+fr8jnlGPOCYwVNKevGhDhc/GXE8EgXf0s+b4nl2y15/u0071a1Z2P2wx9m
	HAg0kAAawpjQ8WSqIugnzNQ23tJkoSWfADj5rfQVuQtS9FwJaHmiIWPOqiikiOekzzAQhQKILga
	+S/X+7WGSr7+pbXc+bE7MxweRybmBSh1x54xQZ0sUPDDVDhcEp5h70NP4x6jFgNUxTycau+lav+
	b2yT5cacs7mCMWPQjkahejjDVg55fDJBPMagKJi5ABiGJvruPsmIYLniFQIf+UkhrRU8bhMnx5Q
	XZO5dOY2NgCi9jwTvH80q7421lZGq2uHL2dg==
X-Received: by 2002:a05:690e:d8b:b0:649:4689:c4a9 with SMTP id 956f58d0204a3-6494689c534mr4815658d50.89.1769097685513;
        Thu, 22 Jan 2026 08:01:25 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:7::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-649170acbdbsm9523979d50.13.2026.01.22.08.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:01:24 -0800 (PST)
Date: Thu, 22 Jan 2026 08:01:23 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>, linux-doc@vger.kernel.org,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v16 00/12] vsock: add namespace support to
 vhost-vsock and loopback
Message-ID: <aXJJ0yjZB5mT162B@devvm11784.nha0.facebook.com>
References: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
 <aXH7YCgl0qI2dF1T@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXH7YCgl0qI2dF1T@sgarzare-redhat>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68908-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[gmail.com];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F1EC16A429
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 02:55:36PM +0100, Stefano Garzarella wrote:
> On Wed, Jan 21, 2026 at 02:11:40PM -0800, Bobby Eshleman wrote:
> > This series adds namespace support to vhost-vsock and loopback. It does
> > not add namespaces to any of the other guest transports (virtio-vsock,
> > hyperv, or vmci).
> > 
> > The current revision supports two modes: local and global. Local
> > mode is complete isolation of namespaces, while global mode is complete
> > sharing between namespaces of CIDs (the original behavior).
> > 
> > The mode is set using the parent namespace's
> > /proc/sys/net/vsock/child_ns_mode and inherited when a new namespace is
> > created. The mode of the current namespace can be queried by reading
> > /proc/sys/net/vsock/ns_mode. The mode can not change after the namespace
> > has been created.
> > 
> > Modes are per-netns. This allows a system to configure namespaces
> > independently (some may share CIDs, others are completely isolated).
> > This also supports future possible mixed use cases, where there may be
> > namespaces in global mode spinning up VMs while there are mixed mode
> > namespaces that provide services to the VMs, but are not allowed to
> > allocate from the global CID pool (this mode is not implemented in this
> > series).
> > 
> > Additionally, added tests for the new namespace features:
> > 
> > tools/testing/selftests/vsock/vmtest.sh
> > 1..25
> > ok 1 vm_server_host_client
> > ok 2 vm_client_host_server
> > ok 3 vm_loopback
> > ok 4 ns_host_vsock_ns_mode_ok
> > ok 5 ns_host_vsock_child_ns_mode_ok
> > ok 6 ns_global_same_cid_fails
> > ok 7 ns_local_same_cid_ok
> > ok 8 ns_global_local_same_cid_ok
> > ok 9 ns_local_global_same_cid_ok
> > ok 10 ns_diff_global_host_connect_to_global_vm_ok
> > ok 11 ns_diff_global_host_connect_to_local_vm_fails
> > ok 12 ns_diff_global_vm_connect_to_global_host_ok
> > ok 13 ns_diff_global_vm_connect_to_local_host_fails
> > ok 14 ns_diff_local_host_connect_to_local_vm_fails
> > ok 15 ns_diff_local_vm_connect_to_local_host_fails
> > ok 16 ns_diff_global_to_local_loopback_local_fails
> > ok 17 ns_diff_local_to_global_loopback_fails
> > ok 18 ns_diff_local_to_local_loopback_fails
> > ok 19 ns_diff_global_to_global_loopback_ok
> > ok 20 ns_same_local_loopback_ok
> > ok 21 ns_same_local_host_connect_to_local_vm_ok
> > ok 22 ns_same_local_vm_connect_to_local_host_ok
> > ok 23 ns_delete_vm_ok
> > ok 24 ns_delete_host_ok
> > ok 25 ns_delete_both_ok
> > SUMMARY: PASS=25 SKIP=0 FAIL=0
> > 
> > Thanks again for everyone's help and reviews!
> 
> Thank you for your hard work and patience!
> 
> I think we've come up with an excellent solution that's also not too
> invasive.

Thanks, and I appreciate all of the work you and other maintainers put
into this as well! I think we honed in on a great solution too.
> 
> All the patches have my R-b, I've double-checked and tested this v16.
> Everything seems to be working fine (famous last words xD).
> 
> So this series is good to go IMO!
> 
> Next step should be to update the vsock(7) namespace.

Sounds good, I'll follow up with that and CC you + other reviewers that
participated here.

Thanks again,
Bobby

