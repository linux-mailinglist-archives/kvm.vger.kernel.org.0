Return-Path: <kvm+bounces-71253-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OOAuCe7llWneVwIAu9opvQ
	(envelope-from <kvm+bounces-71253-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:16:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A52C2157A9C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 17:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7572F301AB88
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 16:15:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5645C344040;
	Wed, 18 Feb 2026 16:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jand+f8M"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E43F328626
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771431344; cv=none; b=agXRY+W0Fsclltfkcha+ozFRPUsLEd7Dy6dskoX4xmFLCK7/7YcS0mLf+gQvlO6lPcx4Pw8G3wVu780FQpM39iowXyFnJm+IspFSGc2DW6DfgOnK/nWHIHFW3AOdB6RRyTCKsVkA2oXh4xaWIGlodkLjlXBQ5W0GnYFz486TQYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771431344; c=relaxed/simple;
	bh=M8x3Eta6dsHBZmEiqBxFrizv2ZeW28diPeGIt7lnfCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAAsfsNETbDAj5M4UzfekUkHqNW02KNpbTSPWncLj/oow9xA+dIj67iktuMlCdBu6zkxslivn5XCO8vr1c8D/0sN9J8I6dX1qyxgY5LoDUAShnvs58zVzhJb/dNz/HN2aNafIV46eaqen4ScFRcGcTjmcKzVbHvFLIaXS+8eGWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jand+f8M; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-649278a69c5so4985995d50.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 08:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771431341; x=1772036141; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2QPsjXZQUdipsGNcNiU7XkuEdRr5aKeXHMLyIc5cKOk=;
        b=jand+f8M3Jd5O3rcSzxwSXS3iXpIymlb5nzewPOdqK0MB2H8r2pVIQtTsfaE1fqGwQ
         woFexX9sumlrZ3IpXGi62Jwwywe8Qb8NrzYQDffeoFkpj86kt17hwnW+T9RURb1futKv
         wDcFcPtjocXiWm1cdi9QMZhl4VNsS8Ijl9/+8Km0Bc0GHk5UF67sfHMpjgrEO0dK7o9L
         /632maIJJCSz2ucDEAYS01S/I3H7egf58AhrjY1fL2mx4K1HJCJ3c1Kn0VP+wPJNHjbX
         vCuC22r9gOqSTB7tQYGr4eWB+cNbbv4N1+GCxbhzOE27BapNm0u50lcivnrwvpteOM0c
         33zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771431341; x=1772036141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2QPsjXZQUdipsGNcNiU7XkuEdRr5aKeXHMLyIc5cKOk=;
        b=V/Oi0bWrXShmq4qKIjC2aY2StMiBHJQkkqjBPRrVO8eczsv2qipEV4lungvMMoEj4F
         mIVS3UYHFBj9CK5y0aqtxTOcLx0loCHUQKAqUiEXjnymqdOm/DypXzdQQyH3DPGvx7ic
         IZ+ogDHQTtdsjBW4ztoPqCrM9Cim6helBIGrwYmkKOevQKA9fP4oP1kfW4EB03w43wHk
         MxjDMr8CBCDl2RmHUCmTQDmwUFCED2KApMCn0kZG2th2Y3PoCjtf9LZyPb+SM8R1oJgn
         xsnY2pFGWgC6y1qwFQ6OnrVzTbc4ljd5Hi1r2cXJoAebO7yt9YBj+VsqB+CMHUmoI7Cm
         VypQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVz+NXZ29SGwGjGYpp0INtyWcfgMzbExmWqgRAL0MP2xXIU+fzX6CuwqNWOrqaJUhN2/o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxR6ZUYx1tSbITtgOgXhcij4MoTBryo4KAyrOoNoIv2rwTVxhS8
	u35cxlFfv/i5rRqMJHIpQkZcfCK9wWc42ulHmp/vCFeKbhfODmuhXOkk
X-Gm-Gg: AZuq6aKGYxVwxdxs8IA9zpLdfc2JIKqKW9n1UEf08cnqih0TI/Zl6JnTffVVnTOU+tx
	uPmA6uZbK7keHejfCKpKxUJgIh0MH+xezkdkfDWNOKydpvKrzzxp7+z0ygazpV0zt0aPogfdkdd
	gGBAdTlZk0hJWrJvxLM8JM4pM58yipiyH38VQ2A67mMv3GUUdOH/utXlV2cniQZDKzXOA/Cg6dK
	ySWFvSMKszLVLf40kqiXOinnGiDGtxzAOZc9/lsK5bkEe1g31y1TVX76l/Ho3aMXxXGS1ghA6ZF
	K9wL35Glyw8pCOnguBH2TbMAuJvp8xHmZYn5LXT9Do+fHKnshFTf9Omtn+rr51yqBNlm+LC05K/
	KzXpC4UOpm/FhAzEovXPPnR4Eo2oIq7Wxh1k6zZFVNB9y3jK6nYYI2b2B3kQgEX8gTMQZeaRt18
	WXQvDqwu66WW7GzVrtuRKa8gy/xOQf6oTJ5fXf4qN0KzZJt0Y=
X-Received: by 2002:a53:de11:0:b0:649:3897:ba21 with SMTP id 956f58d0204a3-64c14d381f8mr13378167d50.52.1771431341018;
        Wed, 18 Feb 2026 08:15:41 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:55::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64c22ea3ddfsm5898507d50.8.2026.02.18.08.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 08:15:40 -0800 (PST)
Date: Wed, 18 Feb 2026 08:15:38 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net] vsock: lock down child_ns_mode as write-once
Message-ID: <aZXlqv5ukWymz/NI@devvm11784.nha0.facebook.com>
References: <20260217-vsock-ns-write-once-v1-1-a1fb30f289a9@meta.com>
 <aZV6HRAIsf_rNRM2@sgarzare-redhat>
 <aZWUmbiH11Eh3Y4v@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZWUmbiH11Eh3Y4v@sgarzare-redhat>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71253-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,meta.com,lists.linux.dev,vger.kernel.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,meta.com:email,devvm11784.nha0.facebook.com:mid]
X-Rspamd-Queue-Id: A52C2157A9C
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 11:43:42AM +0100, Stefano Garzarella wrote:
> On Wed, Feb 18, 2026 at 11:02:02AM +0100, Stefano Garzarella wrote:
> > On Tue, Feb 17, 2026 at 05:45:10PM -0800, Bobby Eshleman wrote:
> > > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > > 
> > > To improve the security posture of vsock namespacing, this patch locks
> > > down the vsock child_ns_mode sysctl setting with a write-once policy.
> > > The user may write to child_ns_mode only once in each namespace, making
> > > changes to either local or global mode be irreversible.
> > > 
> > > This avoids security breaches where a process in a local namespace may
> > > attempt to jailbreak into the global vsock ns space by setting
> > > child_ns_mode to "global", creating a new namespace, and accessing the
> > > global space through the new namespace.
> > 
> > Commit 6a997f38bdf8 ("vsock: prevent child netns mode switch from local
> > to global") should avoid exactly that, so I don't get this. Can you
> > elaborate more how this can happen without this patch?
> > 
> > I think here we should talk more about what we described in
> > https://lore.kernel.org/netdev/aZNNBc390y6V09qO@sgarzare-redhat/ which
> > is that two administrator processes could compete in setting
> > `child_ns_mode` and end up creating a namespace with an `ns_mode`
> > different from the one set in `child_ns_mode`. But I would also explain
> > that this can still be detected by the process by looking at `ns_mode`
> > and trying again.  With this patch, we avoid this and allow the
> > namespace manager to set it once and be sure that it cannot be changed
> > again.

Oh that's right, I lost track of the original intent when writing this.

> > 
> > > 
> > > Additionally, fix the test functions that this change would otherwise
> > > break by adding "global-parent" and "local-parent" namespaces and using
> > > them as intermediaries to spawn namespaces in the given modes. This
> > > avoids the need to change "child_ns_mode" in the init_ns. nsenter must
> > > be used because ip netns unshares the mount namespace so nested "ip
> > > netns add" breaks exec calls from the init ns.
> > 
> > I'm not sure what the policy is in netdev, but I would prefer to have
> > selftest changes in another patch (I think earlier in the series so as
> > not to break the bisection), in order to simplify backporting (e.g. in
> > CentOS Stream, to keep the backport small, I didn't backport the dozens
> > of patches for selftest that we did previously).

Sounds good! I wasn't sure if breakage so tightly coupled should be in
the same patch or not, I'm happy to split it up to ease backporting.

> > 
> > Obviously, if it's not possible and breaks the bisection, I can safely
> > skip these changes during the backport.
> > 
> > > 
> > > Test run:
> > > 
> > > 1..25
> > > ok 1 vm_server_host_client
> > > ok 2 vm_client_host_server
> > > ok 3 vm_loopback
> > > ok 4 ns_host_vsock_ns_mode_ok
> > > ok 5 ns_host_vsock_child_ns_mode_ok
> > > ok 6 ns_global_same_cid_fails
> > > ok 7 ns_local_same_cid_ok
> > > ok 8 ns_global_local_same_cid_ok
> > > ok 9 ns_local_global_same_cid_ok
> > > ok 10 ns_diff_global_host_connect_to_global_vm_ok
> > > ok 11 ns_diff_global_host_connect_to_local_vm_fails
> > > ok 12 ns_diff_global_vm_connect_to_global_host_ok
> > > ok 13 ns_diff_global_vm_connect_to_local_host_fails
> > > ok 14 ns_diff_local_host_connect_to_local_vm_fails
> > > ok 15 ns_diff_local_vm_connect_to_local_host_fails
> > > ok 16 ns_diff_global_to_local_loopback_local_fails
> > > ok 17 ns_diff_local_to_global_loopback_fails
> > > ok 18 ns_diff_local_to_local_loopback_fails
> > > ok 19 ns_diff_global_to_global_loopback_ok
> > > ok 20 ns_same_local_loopback_ok
> > > ok 21 ns_same_local_host_connect_to_local_vm_ok
> > > ok 22 ns_same_local_vm_connect_to_local_host_ok
> > > ok 23 ns_delete_vm_ok
> > > ok 24 ns_delete_host_ok
> > > ok 25 ns_delete_both_ok
> > > SUMMARY: PASS=25 SKIP=0 FAIL=0
> > 
> > IMO this can be removed from the commit message, doesn't add much value
> > other than say that all test passes.

sgtm!

> > 
> > > 
> > > Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
> > > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > > Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> > > Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > include/net/af_vsock.h                  |  6 +++++-
> > > include/net/netns/vsock.h               |  1 +
> > > net/vmw_vsock/af_vsock.c                | 10 ++++++----
> > > tools/testing/selftests/vsock/vmtest.sh | 35
> > > +++++++++++++++------------------
> > > 4 files changed, 28 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > > index d3ff48a2fbe0..c7de33039907 100644
> > > --- a/include/net/af_vsock.h
> > > +++ b/include/net/af_vsock.h
> > > @@ -276,10 +276,14 @@ static inline bool vsock_net_mode_global(struct vsock_sock *vsk)
> > > 	return vsock_net_mode(sock_net(sk_vsock(vsk))) == VSOCK_NET_MODE_GLOBAL;
> > > }
> > > 
> > > -static inline void vsock_net_set_child_mode(struct net *net,
> > > +static inline bool vsock_net_set_child_mode(struct net *net,
> > > 					    enum vsock_net_mode mode)
> > > {
> > > +	if (xchg(&net->vsock.child_ns_mode_locked, 1))
> > > +		return false;
> > > +
> > > 	WRITE_ONCE(net->vsock.child_ns_mode, mode);
> > > +	return true;
> > > }
> > > 
> > > static inline enum vsock_net_mode vsock_net_child_mode(struct net *net)
> > > diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
> > > index b34d69a22fa8..8c855fff8039 100644
> > > --- a/include/net/netns/vsock.h
> > > +++ b/include/net/netns/vsock.h
> > > @@ -17,5 +17,6 @@ struct netns_vsock {
> > > 
> > > 	enum vsock_net_mode mode;
> > > 	enum vsock_net_mode child_ns_mode;
> > > +	int child_ns_mode_locked;
> > > };
> > > #endif /* __NET_NET_NAMESPACE_VSOCK_H */
> > > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > > index 9880756d9eff..35e097f4fde8 100644
> > > --- a/net/vmw_vsock/af_vsock.c
> > > +++ b/net/vmw_vsock/af_vsock.c
> > > @@ -90,14 +90,15 @@
> > > *
> > > *   - /proc/sys/net/vsock/ns_mode (read-only) reports the current namespace's
> > > *     mode, which is set at namespace creation and immutable thereafter.
> > > - *   - /proc/sys/net/vsock/child_ns_mode (writable) controls what mode future
> > > + *   - /proc/sys/net/vsock/child_ns_mode (write-once) controls what mode future
> > > *     child namespaces will inherit when created. The initial value matches
> > > *     the namespace's own ns_mode.
> > > *
> > > *   Changing child_ns_mode only affects newly created namespaces, not the
> > > *   current namespace or existing children. A "local" namespace cannot set
> > > - *   child_ns_mode to "global". At namespace creation, ns_mode is inherited
> > > - *   from the parent's child_ns_mode.
> > > + *   child_ns_mode to "global". child_ns_mode is write-once, so that it may
> > > + *   be configured and locked down by a namespace manager. At namespace
> > > + *   creation, ns_mode is inherited from the parent's child_ns_mode.
> > 
> > We just merged commit a07c33c6f2fc ("vsock: document namespace mode
> > sysctls") in the net tree, so we should update also
> > Documentation/admin-guide/sysctl/net.rst

Indeed.

> > 
> > > *
> > > *   The init_net mode is "global" and cannot be modified.
> > 
> > Maybe we should also emphasise in the documentation and in the commit
> > description that `child_ns_mode` in `init_net` also is write-once, so
> > writing `local` to that one by the init process (e.g. systemd),
> > essentially will make all the new namespaces in `local` mode. This could
> > be useful for container/namespace managers.
> > 

Sounds good.

> > > *
> > > @@ -2853,7 +2854,8 @@ static int vsock_net_child_mode_string(const struct ctl_table *table, int write,
> > > 		    new_mode == VSOCK_NET_MODE_GLOBAL)
> > > 			return -EPERM;
> > > 
> > > -		vsock_net_set_child_mode(net, new_mode);
> > > +		if (!vsock_net_set_child_mode(net, new_mode))
> > > +			return -EPERM;
> > 
> > So, if `child_ns_mode` is set to `local` but locked, writing `local`
> > again will return -EPERM, is this really what we want?
> > 
> > I'm not sure if we can relax it a bit, but then we may race between
> > reader and writer, so maybe it's fine like it is in this patch, but we
> > should document better that any writes (even same value) after the first
> > one will return -EPERM.
> 
> I think we can try in this way:
> 
> static inline bool vsock_net_set_child_mode(struct net *net,
> 					    enum vsock_net_mode mode)
> {
> 	int new_locked = mode + 1;
> 	int old_locked = 0;
> 
> 	if (try_cmpxchg(&net->vsock.child_ns_mode_locked,
> 			&old_locked, new_locked)) {
> 		WRITE_ONCE(net->vsock.child_ns_mode, mode);
> 		return true;
> 	}
> 
> 	return old_locked == new_locked;
> }
> 
> With a comment like this near child_ns_mode_locked in struct netns_vsock:
> /* 0 = unlocked
>  * 1 = locked to GLOBAL (VSOCK_NET_MODE_GLOBAL + 1)
>  * 2 = locked to LOCAL  (VSOCK_NET_MODE_LOCAL + 1)
>  */

This looks good to me. Will change.

> 
> While writing that, I thought that we can even remove `child_ns_mode_locked`
> and use a single variable where encode the value and the state, but maybe
> it's an unnecessary extra complexity.
> 
> Stefano
> 
> > 
> > About that, should we return something different, like -EBUSY ?
> > Not a strong opinion, just to differentiate with the other check before.
> > 
> > Thanks,
> > Stefano
> 

Differentiating with -EBUSY sounds useful. Will add that and document.

Best,
Bobby

