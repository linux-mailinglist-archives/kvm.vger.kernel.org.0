Return-Path: <kvm+bounces-68910-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wILLLSFVcmkJiwAAu9opvQ
	(envelope-from <kvm+bounces-68910-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:49:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 55E376A4BF
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:49:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B98D7303B6AA
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 16:42:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55C43E2EB0;
	Thu, 22 Jan 2026 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YM3E+uzS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="loh1vGe0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC493E26E9
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769098999; cv=none; b=gkyxo3HrjwpslenUcuiA8K0gUTzH0l1089/72MSlpa8/rq+2UUd4riM/rshxpH1/JDZjWgqnz37ypsFX/jmRXxcXbflWJLIuXblLMHkRGVdnBU78S+GZ5US82mD8RWs2xSuJG55lUbLH7scR19+fc+kseFLO2wg0uI2RmLEVTAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769098999; c=relaxed/simple;
	bh=0cpZL4CnoQJayvprLSYCcWhCM1ZKggb8ujo1E/u12io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZZ/Ybyn3wnwPdSZD/VeitzTjjGnARE/Hj620rOLY5bB/uFFhnDgMx1PpExQLWzpB6E9/HQLjGObzDSxYtmg8R2DPX6D0S9ZF/YT0xN85kamCWdeM0QaHixWCUAuq7DMmFFAsWKJlYaNsRpLAm+nEoXmOKDqd5Na9WD9aWqRXA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YM3E+uzS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=loh1vGe0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769098991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7WZme2OWA32GKcXEMiT1Hf8mk1aTvSRs5qR+MZWFuW0=;
	b=YM3E+uzSH16xiXAMZAdbEbvNptwCDTj+MXaK5lLxwXTJeDxf4ksOG7WZvl10PwA/vFqhMp
	I0qZ9m51nU+HmAGl3L8QYE/jQNWflsZyc6Zqivt98YnK7vRp+Y1vPw/WXe92U9FumuQ8jV
	8U5ypfpBixGoBQobqOjK+YO3zd9bhoE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-Q7_Wg52fOgKgka9aH4Rosg-1; Thu, 22 Jan 2026 11:23:09 -0500
X-MC-Unique: Q7_Wg52fOgKgka9aH4Rosg-1
X-Mimecast-MFC-AGG-ID: Q7_Wg52fOgKgka9aH4Rosg_1769098989
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4801e2e3532so8327015e9.2
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 08:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769098988; x=1769703788; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7WZme2OWA32GKcXEMiT1Hf8mk1aTvSRs5qR+MZWFuW0=;
        b=loh1vGe0ej+t+iXE1837bDxRN/UroGX8KDm8IGIX9VelTb91I4N35/PVQ84BxKysTf
         eM6EIkPYzGpkhLoBiH8/P9ytk8fSGazemRDZ64u3AsevOWh32WZwZKVPi1vPS2yhQHRW
         IbaqmvSO6VWvc1qkZ5Wc776E3yhjNnhIhPROpTPf/ORbJEFNyqiEdqRUcYFtZVH1ZcQP
         ufcOKreEHd2oZsuB3SRVD8gdsXdMwyKP68yHbGnEt1AkKg6YoHv7xf5JLgaH29hAFB/o
         VFemUvU+1YThPV7QKXco2NFyZ16Km/bc3xr5WzX03X+oL42jKvUNJIammPusji6O4HoF
         PB4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769098988; x=1769703788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7WZme2OWA32GKcXEMiT1Hf8mk1aTvSRs5qR+MZWFuW0=;
        b=XCk0lPbZUodHYTWS1sNaqzxipKJgzSdegl86VdZPF0H3ibD8dC42DpPT/Iy7xanE9F
         TcMpvXL70B+JnUfK3nEHfvI7kDQ5AWsScaHyVcBC9XjdYVcUSMgyA+acl1rTho42pjMl
         D6vQEuWPqmz++8uFhEx8oEjwJ9J6xRp8MtxOv+7Z5qQEhq1AQcF4NzEoaNX/ZmosOHVF
         BLSJnG+rNyV3mH0lCNZGO8y4ns1dxTeoWacxw85pRpo56PnOeFZz0kNG6HPSr2Qo78KO
         m6mwmYx5qBFkQnSFafTJMBTIpmTVmxpq+ThenXc/fD5KAxMezWk6TiL6fgzcafEFLE7G
         nbyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX2E6plhBKhqHfTL4sACBC2BSjzkqH15XR5+aX+mn8LgqHPSXv4YR0QQd8vgykfjEogHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvCjwEPUfIbQ+cS9QHNDAPv5UEAK7WkbNNBcmtdkO2AcntbEt+
	jQTlSHrqWZovqa1tKH2shupQYUJ9tKmjS9D5JbHGdvwpeLlWzra0VNwuhuPJ6A+HaN5t8qwJAgg
	aibJFmhtt/RD2Yq86kqcbo8yVBaJxi3oqRjFNv+QvaG18pXA0wYDL/Q==
X-Gm-Gg: AZuq6aISXiKoIswLB41jWX4pLtZBCwhOgp9gai3pnQ/mO47mBTA9jtbsYyEVYw1HZdA
	me/67UvcSsTfJEhdSbOuyKXBFFJ/QsZiOusHkpG4gjFUZ6SppBbZKFcgm/92HT3u/bp6EsOVvv6
	8AARtUviMKdma4xXQuWNgklHnN556ASHV1CvehTaAEA43cuhtmi2MwSFtw6b6gzo9VU0WyBrmE3
	C56LeWlvwZJodli/JoWUn04b/DR2ASpjNLpS5AoN6rA5d7lNV5gjAjO0j3WHBraMqqJPq+AKKyk
	T1FRJ3xF6tIISjk6jF/eZwhmNi8VYeqddoRXRv+fuuQCMrR36/AdSfd61Vn0qAjIiDgEaxxsazL
	z3XTu+YPTnAooHUHcR5lfapCaECUsglfPsQ==
X-Received: by 2002:a05:600c:34d0:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-4804c9afcf4mr2882595e9.23.1769098988416;
        Thu, 22 Jan 2026 08:23:08 -0800 (PST)
X-Received: by 2002:a05:600c:34d0:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-4804c9afcf4mr2882145e9.23.1769098987778;
        Thu, 22 Jan 2026 08:23:07 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804252b02dsm57271945e9.5.2026.01.22.08.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:23:06 -0800 (PST)
Date: Thu, 22 Jan 2026 11:23:02 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
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
Message-ID: <20260122112252-mutt-send-email-mst@kernel.org>
References: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121-vsock-vmtest-v16-0-2859a7512097@meta.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68910-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,ozlabs.org:url,meta.com:email]
X-Rspamd-Queue-Id: 55E376A4BF
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 02:11:40PM -0800, Bobby Eshleman wrote:
> This series adds namespace support to vhost-vsock and loopback. It does
> not add namespaces to any of the other guest transports (virtio-vsock,
> hyperv, or vmci).
> 
> The current revision supports two modes: local and global. Local
> mode is complete isolation of namespaces, while global mode is complete
> sharing between namespaces of CIDs (the original behavior).
> 
> The mode is set using the parent namespace's
> /proc/sys/net/vsock/child_ns_mode and inherited when a new namespace is
> created. The mode of the current namespace can be queried by reading
> /proc/sys/net/vsock/ns_mode. The mode can not change after the namespace
> has been created.
> 
> Modes are per-netns. This allows a system to configure namespaces
> independently (some may share CIDs, others are completely isolated).
> This also supports future possible mixed use cases, where there may be
> namespaces in global mode spinning up VMs while there are mixed mode
> namespaces that provide services to the VMs, but are not allowed to
> allocate from the global CID pool (this mode is not implemented in this
> series).
> 
> Additionally, added tests for the new namespace features:
> 
> tools/testing/selftests/vsock/vmtest.sh
> 1..25
> ok 1 vm_server_host_client
> ok 2 vm_client_host_server
> ok 3 vm_loopback
> ok 4 ns_host_vsock_ns_mode_ok
> ok 5 ns_host_vsock_child_ns_mode_ok
> ok 6 ns_global_same_cid_fails
> ok 7 ns_local_same_cid_ok
> ok 8 ns_global_local_same_cid_ok
> ok 9 ns_local_global_same_cid_ok
> ok 10 ns_diff_global_host_connect_to_global_vm_ok
> ok 11 ns_diff_global_host_connect_to_local_vm_fails
> ok 12 ns_diff_global_vm_connect_to_global_host_ok
> ok 13 ns_diff_global_vm_connect_to_local_host_fails
> ok 14 ns_diff_local_host_connect_to_local_vm_fails
> ok 15 ns_diff_local_vm_connect_to_local_host_fails
> ok 16 ns_diff_global_to_local_loopback_local_fails
> ok 17 ns_diff_local_to_global_loopback_fails
> ok 18 ns_diff_local_to_local_loopback_fails
> ok 19 ns_diff_global_to_global_loopback_ok
> ok 20 ns_same_local_loopback_ok
> ok 21 ns_same_local_host_connect_to_local_vm_ok
> ok 22 ns_same_local_vm_connect_to_local_host_ok
> ok 23 ns_delete_vm_ok
> ok 24 ns_delete_host_ok
> ok 25 ns_delete_both_ok
> SUMMARY: PASS=25 SKIP=0 FAIL=0
> 
> Thanks again for everyone's help and reviews!
> 
> Suggested-by: Sargun Dhillon <sargun@sargun.me>
> Signed-off-by: Bobby Eshleman <bobbyeshleman@gmail.com>


Acked-by: Michael S. Tsirkin <mst@redhat.com>

> 
> Changes in v16:
> - updated comments/docs/commit msg (vsock_find_* funcs, init net
>   mode, why change random port alloc)
> - removed init ns mode cmdline
> - fixed the missing ${ns} arg for vm_ssh in vmtest.sh
> - Link to v15: https://lore.kernel.org/r/20260116-vsock-vmtest-v15-0-bbfd1a668548@meta.com
> 
> Changes in v15:
> - see per-patch change notes in 'vsock: add netns to vsock core'
> - Link to v14: https://lore.kernel.org/r/20260112-vsock-vmtest-v14-0-a5c332db3e2b@meta.com
> 
> Changes in v14:
> - squashed 'vsock: add per-net vsock NS mode state' into 'vsock: add
>   netns to vsock core' (MST)
> - remove RFC tag
> - fixed base-commit (still had b4 configured to depend on old vmtest.sh
>   series)
> - Link to v13: https://lore.kernel.org/all/20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com/
> 
> Changes in v13:
> - add support for immutable sysfs ns_mode and inheritance from sysfs child_ns_mode
> - remove passing around of net_mode, can be accessed now via
>   vsock_net_mode(net) since it is immutable
> - update tests for new uAPI
> - add one patch to extend the kselftest timeout (it was starting to
>   fail with the new tests added)
> - Link to v12: https://lore.kernel.org/r/20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com
> 
> Changes in v12:
> - add ns mode checking to _allow() callbacks to reject local mode for
>   incompatible transports (Stefano)
> - flip vhost/loopback to return true for stream_allow() and
>   seqpacket_allow() in "vsock: add netns support to virtio transports"
>   (Stefano)
> - add VMADDR_CID_ANY + local mode documentation in af_vsock.c (Stefano)
> - change "selftests/vsock: add tests for host <-> vm connectivity with
>   namespaces" to skip test 29 in vsock_test for namespace local
>   vsock_test calls in a host local-mode namespace. There is a
>   false-positive edge case for that test encountered with the
>   ->stream_allow() approach. More details in that patch.
> - updated cover letter with new test output
> - Link to v11: https://lore.kernel.org/r/20251120-vsock-vmtest-v11-0-55cbc80249a7@meta.com
> 
> Changes in v11:
> - vmtest: add a patch to use ss in wait_for_listener functions and
>   support vsock, tcp, and unix. Change all patches to use the new
>   functions.
> - vmtest: add a patch to re-use vm dmesg / warn counting functions
> - Link to v10: https://lore.kernel.org/r/20251117-vsock-vmtest-v10-0-df08f165bf3e@meta.com
> 
> Changes in v10:
> - Combine virtio common patches into one (Stefano)
> - Resolve vsock_loopback virtio_transport_reset_no_sock() issue
>   with info->vsk setting. This eliminates the need for skb->cb,
>   so remove skb->cb patches.
> - many line width 80 fixes
> - Link to v9: https://lore.kernel.org/all/20251111-vsock-vmtest-v9-0-852787a37bed@meta.com
> 
> Changes in v9:
> - reorder loopback patch after patch for virtio transport common code
> - remove module ordering tests patch because loopback no longer depends
>   on pernet ops
> - major simplifications in vsock_loopback
> - added a new patch for blocking local mode for guests, added test case
>   to check
> - add net ref tracking to vsock_loopback patch
> - Link to v8: https://lore.kernel.org/r/20251023-vsock-vmtest-v8-0-dea984d02bb0@meta.com
> 
> Changes in v8:
> - Break generic cleanup/refactoring patches into standalone series,
>   remove those from this series
> - Link to dependency: https://lore.kernel.org/all/20251022-vsock-selftests-fixes-and-improvements-v1-0-edeb179d6463@meta.com/
> - Link to v7: https://lore.kernel.org/r/20251021-vsock-vmtest-v7-0-0661b7b6f081@meta.com
> 
> Changes in v7:
> - fix hv_sock build
> - break out vmtest patches into distinct, more well-scoped patches
> - change `orig_net_mode` to `net_mode`
> - many fixes and style changes in per-patch change sets (see individual
>   patches for specific changes)
> - optimize `virtio_vsock_skb_cb` layout
> - update commit messages with more useful descriptions
> - vsock_loopback: use orig_net_mode instead of current net mode
> - add tests for edge cases (ns deletion, mode changing, loopback module
>   load ordering)
> - Link to v6: https://lore.kernel.org/r/20250916-vsock-vmtest-v6-0-064d2eb0c89d@meta.com
> 
> Changes in v6:
> - define behavior when mode changes to local while socket/VM is alive
> - af_vsock: clarify description of CID behavior
> - af_vsock: use stronger langauge around CID rules (dont use "may")
> - af_vsock: improve naming of buf/buffer
> - af_vsock: improve string length checking on proc writes
> - vsock_loopback: add space in struct to clarify lock protection
> - vsock_loopback: do proper cleanup/unregister on vsock_loopback_exit()
> - vsock_loopback: use virtio_vsock_skb_net() instead of sock_net()
> - vsock_loopback: set loopback to NULL after kfree()
> - vsock_loopback: use pernet_operations and remove callback mechanism
> - vsock_loopback: add macros for "global" and "local"
> - vsock_loopback: fix length checking
> - vmtest.sh: check for namespace support in vmtest.sh
> - Link to v5: https://lore.kernel.org/r/20250827-vsock-vmtest-v5-0-0ba580bede5b@meta.com
> 
> Changes in v5:
> - /proc/net/vsock_ns_mode -> /proc/sys/net/vsock/ns_mode
> - vsock_global_net -> vsock_global_dummy_net
> - fix netns lookup in vhost_vsock to respect pid namespaces
> - add callbacks for vsock_loopback to avoid circular dependency
> - vmtest.sh loads vsock_loopback module
> - remove vsock_net_mode_can_set()
> - change vsock_net_write_mode() to return true/false based on success
> - make vsock_net_mode enum instead of u8
> - Link to v4: https://lore.kernel.org/r/20250805-vsock-vmtest-v4-0-059ec51ab111@meta.com
> 
> Changes in v4:
> - removed RFC tag
> - implemented loopback support
> - renamed new tests to better reflect behavior
> - completed suite of tests with permutations of ns modes and vsock_test
>   as guest/host
> - simplified socat bridging with unix socket instead of tcp + veth
> - only use vsock_test for success case, socat for failure case (context
>   in commit message)
> - lots of cleanup
> 
> Changes in v3:
> - add notion of "modes"
> - add procfs /proc/net/vsock_ns_mode
> - local and global modes only
> - no /dev/vhost-vsock-netns
> - vmtest.sh already merged, so new patch just adds new tests for NS
> - Link to v2:
>   https://lore.kernel.org/kvm/20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com
> 
> Changes in v2:
> - only support vhost-vsock namespaces
> - all g2h namespaces retain old behavior, only common API changes
>   impacted by vhost-vsock changes
> - add /dev/vhost-vsock-netns for "opt-in"
> - leave /dev/vhost-vsock to old behavior
> - removed netns module param
> - Link to v1:
>   https://lore.kernel.org/r/20200116172428.311437-1-sgarzare@redhat.com
> 
> Changes in v1:
> - added 'netns' module param to vsock.ko to enable the
>   network namespace support (disabled by default)
> - added 'vsock_net_eq()' to check the "net" assigned to a socket
>   only when 'netns' support is enabled
> - Link to RFC: https://patchwork.ozlabs.org/cover/1202235/
> 
> ---
> Bobby Eshleman (12):
>       vsock: add netns to vsock core
>       virtio: set skb owner of virtio_transport_reset_no_sock() reply
>       vsock: add netns support to virtio transports
>       selftests/vsock: increase timeout to 1200
>       selftests/vsock: add namespace helpers to vmtest.sh
>       selftests/vsock: prepare vm management helpers for namespaces
>       selftests/vsock: add vm_dmesg_{warn,oops}_count() helpers
>       selftests/vsock: use ss to wait for listeners instead of /proc/net
>       selftests/vsock: add tests for proc sys vsock ns_mode
>       selftests/vsock: add namespace tests for CID collisions
>       selftests/vsock: add tests for host <-> vm connectivity with namespaces
>       selftests/vsock: add tests for namespace deletion
> 
>  MAINTAINERS                             |    1 +
>  drivers/vhost/vsock.c                   |   44 +-
>  include/linux/virtio_vsock.h            |    9 +-
>  include/net/af_vsock.h                  |   61 +-
>  include/net/net_namespace.h             |    4 +
>  include/net/netns/vsock.h               |   21 +
>  net/vmw_vsock/af_vsock.c                |  335 +++++++++-
>  net/vmw_vsock/hyperv_transport.c        |    7 +-
>  net/vmw_vsock/virtio_transport.c        |   22 +-
>  net/vmw_vsock/virtio_transport_common.c |   62 +-
>  net/vmw_vsock/vmci_transport.c          |   26 +-
>  net/vmw_vsock/vsock_loopback.c          |   22 +-
>  tools/testing/selftests/vsock/settings  |    2 +-
>  tools/testing/selftests/vsock/vmtest.sh | 1055 +++++++++++++++++++++++++++++--
>  14 files changed, 1531 insertions(+), 140 deletions(-)
> ---
> base-commit: d8f87aa5fa0a4276491fa8ef436cd22605a3f9ba
> change-id: 20250325-vsock-vmtest-b3a21d2102c2
> 
> Best regards,
> -- 
> Bobby Eshleman <bobbyeshleman@meta.com>


