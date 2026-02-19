Return-Path: <kvm+bounces-71355-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JcvCY04l2l2vwIAu9opvQ
	(envelope-from <kvm+bounces-71355-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 17:21:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB8216099B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 17:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 54EF03053673
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 16:21:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2184934CFC6;
	Thu, 19 Feb 2026 16:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ExUTnMfY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B123234AAF9
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771518059; cv=none; b=RvVHaNHGbyLTDPXVJeVCzaHbdcbkMhLYSYzpoVcn/hvMvCagKslHmk273jjswesA++i6veZnqmFFVOS0DgVdE/vYv1iTZ1BN6JZaB5KdAHeUlyYx2uSMy4Oe0oCJ3to7LuaCBUbiev9TxiPEHczbZ3CfMatuYcgOSAkDaZPowsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771518059; c=relaxed/simple;
	bh=aa8HpnhkhFTvaDoDL/ahRUcPG5SO2+yPR1Wf7Wra0gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oCimCagAKU0fWt/jUrB7MPSf2Pfshx0hHWqYjMYdE5CubFY9xdSlU9Mqgv1ezgZQsLnmzD8qEjSyS7jixBL4rzGyaekNqjvhzOye3mgiQl+WOYSdqIIt3fUzCBSCYL4EoknUkMhKx/8X0+o52OWHK05hNGK5C8iv1lei0GYpjkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ExUTnMfY; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79800183233so15025537b3.1
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 08:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771518056; x=1772122856; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A0rYjgp7Ch70SpS2AmmIHyWg8daqBojfooxoM3vehGQ=;
        b=ExUTnMfY2pjcYe+2x1vuGkgPM06jeUQKRHQ7Yxu6Q6X2E9/O8/FoaICaAQOLOayz6Z
         BNZHkvUVikIOctAhZxiPTuBLSl54h1WWPUegX0BkyQKs4jzoMpJMCSNHKONopkx0jAeP
         0NwbacL5nceiK125gQk+MUZcjYTC/yv4NLD3bHrobJsQrZE5Hh/3DSQXnYlC0x+O2G27
         YEExOEeqzneqcAKR12OVcdn+viQBzLooJCmiZ6BE3FbScUKggvS3RYH5M8orsOQM27/r
         cKHaHxTwbyCdAt77/x7zJ020vWqgAVOq90qtcdXwsRv20xfa74Qer7WGtfSpukZH1rgp
         ehAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771518057; x=1772122857;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0rYjgp7Ch70SpS2AmmIHyWg8daqBojfooxoM3vehGQ=;
        b=p2VS0Z3tJECTFxqgaBi4TIQumtjW0BLnY4XLnRNO9ZqZfZAjHhWmqMvmrhzyYwQSCo
         aDw2yOkxZw16KQVOSajoYPvHm87MHcwgiQLV0t/PvPxkZYnhpSdCvZFTn4CzOzST5ZJa
         GUl7kInC6uLe9PI56kslQ5oBLie1uMDSvRHcPdLQMVh1hErvfXNlNRyasgqV4QQ0N349
         VFxgWLXR8atX51yfqg0yATtx5AJt5mGpUSKcCw0hvrgY+07osurBEdNqq3dYdL7yXyPP
         u7jmklFtyQfOZfyFMw7ROFCxBQC2waU+xUnIHXM6UUwrOjZPMMqXo2lP2ND+6MN2tPUv
         kh7w==
X-Forwarded-Encrypted: i=1; AJvYcCU1m+lS6jxb9Y05Eae54wBwTMQHdM+WhVKHTpaL7iO/vRvXz5U1/kGZhxmHVUyA8iYwZZw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRdSThpaKPfPDSmoHl6lcqH8YbZNbgmdmOv8w2vfOcyvgKQLhS
	MRESuk8GtpDuE6pqtv3qFkC8OrlNbiFmf4BGBXFi7ecKJr4VxSIdN6FJ
X-Gm-Gg: AZuq6aIUjqBBMGbIH5um7SGRZuNH5jvpIugfTuUc+4kUltxjPUooegcuolhBlTw5OFX
	4zrMstfqkxsXR3o9wWpc5PubdYOKfe9Bv23ZBmb9m/fjAEk/+E/4hxQTLbOxFXgN3UIt44xT4B9
	W4WNIkwY+L8Ha21ldEWgGGyijahP2cpuu94a5LwnwRFu+ikAKNRSFSs6CCGbWh8T5tPlvObMN9A
	Eu6rkNCtgHVuFVHnrRlTNeaulNegcD4+poR9m10OB1OjCU9pKjYMw9pOXDuQ+/R0EkMI0MHojyc
	rSIZ3RJEvx5NcK5IMAYxHy8yvCAZJmotnOYD0UQjhv6gz0fieOZ6JeXMJ28ipY/mkpceGH/80Do
	8WoDqD8QawadJ2lWAiaJLPm9vWlBozzThb2HL2wy+JB2usiVmVD4oAxwjEeh/4DxVSRd0dCHoIu
	9uUVf9iCjRXuoBPt4ZeFsgGZ/myhiiz1XerfqywihJXCy7BA==
X-Received: by 2002:a05:690c:7283:b0:797:e635:697a with SMTP id 00721157ae682-79807f8664emr16321727b3.1.1771518056461;
        Thu, 19 Feb 2026 08:20:56 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7966c267ba3sm131250537b3.48.2026.02.19.08.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 08:20:56 -0800 (PST)
Date: Thu, 19 Feb 2026 08:20:54 -0800
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
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net v2 2/3] vsock: lock down child_ns_mode as write-once
Message-ID: <aZc4ZgTDtMPDWYxH@devvm11784.nha0.facebook.com>
References: <20260218-vsock-ns-write-once-v2-0-19e4c50d509a@meta.com>
 <20260218-vsock-ns-write-once-v2-2-19e4c50d509a@meta.com>
 <aZbR2H2oDyIAxDef@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZbR2H2oDyIAxDef@sgarzare-redhat>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71355-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[davemloft.net,google.com,kernel.org,redhat.com,meta.com,lwn.net,linuxfoundation.org,lists.linux.dev,vger.kernel.org,gmail.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bobbyeshleman@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:email,devvm11784.nha0.facebook.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7BB8216099B
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 11:35:52AM +0100, Stefano Garzarella wrote:
> On Wed, Feb 18, 2026 at 10:10:37AM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Two administrator processes may race when setting child_ns_mode as one
> > process sets child_ns_mode to "local" and then creates a namespace, but
> > another process changes child_ns_mode to "global" between the write and
> > the namespace creation. The first process ends up with a namespace in
> > "global" mode instead of "local". While this can be detected after the
> > fact by reading ns_mode and retrying, it is fragile and error-prone.
> > 
> > Make child_ns_mode write-once so that a namespace manager can set it
> > once and be sure it won't change. Writing a different value after the
> > first write returns -EBUSY. This applies to all namespaces, including
> > init_net, where an init process can write "local" to lock all future
> > namespaces into local mode.
> > 
> > Fixes: eafb64f40ca4 ("vsock: add netns to vsock core")
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > Suggested-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> > Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> nit: usually the S-o-b of the author is the last when sending a patch.

Ah good to know, thanks. Will change.

> 
> > ---
> > include/net/af_vsock.h    | 20 +++++++++++++++++---
> > include/net/netns/vsock.h |  9 ++++++++-
> > net/vmw_vsock/af_vsock.c  | 15 ++++++++++-----
> > 3 files changed, 35 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> > index d3ff48a2fbe0..9bd42147626d 100644
> > --- a/include/net/af_vsock.h
> > +++ b/include/net/af_vsock.h
> > @@ -276,15 +276,29 @@ static inline bool vsock_net_mode_global(struct vsock_sock *vsk)
> > 	return vsock_net_mode(sock_net(sk_vsock(vsk))) == VSOCK_NET_MODE_GLOBAL;
> > }
> > 
> > -static inline void vsock_net_set_child_mode(struct net *net,
> > +static inline bool vsock_net_set_child_mode(struct net *net,
> > 					    enum vsock_net_mode mode)
> > {
> > -	WRITE_ONCE(net->vsock.child_ns_mode, mode);
> > +	int locked = mode + VSOCK_NET_MODE_LOCKED;
> > +	int cur;
> > +
> > +	cur = READ_ONCE(net->vsock.child_ns_mode);
> > +	if (cur == locked)
> > +		return true;
> > +	if (cur >= VSOCK_NET_MODE_LOCKED)
> > +		return false;
> > +
> > +	if (try_cmpxchg(&net->vsock.child_ns_mode, &cur, locked))
> > +		return true;
> > +
> > +	return cur == locked;
> 
> Sorry, it took me a while to get it entirely :-(
> This overcomplication is exactly what I wanted to avoid when I proposed the
> change in v1:
> https://lore.kernel.org/netdev/aZWUmbiH11Eh3Y4v@sgarzare-redhat/

Glad you thought so too, because I actually think your original proposed
snippet in that thread is the best/simplest so far.

> 
> 
> > }
> > 
> > static inline enum vsock_net_mode vsock_net_child_mode(struct net *net)
> > {
> > -	return READ_ONCE(net->vsock.child_ns_mode);
> > +	int mode = READ_ONCE(net->vsock.child_ns_mode);
> > +
> > +	return mode & (VSOCK_NET_MODE_LOCKED - 1);
> 
> This is working just because VSOCK_NET_MODE_LOCKED == 2, so IMO this should
> at least set as value in the enum and documented on top of vsock_net_mode.
> 
> > }
> > 
> > /* Return true if two namespaces pass the mode rules. Otherwise, return false.
> > diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
> > index b34d69a22fa8..d20ab6269342 100644
> > --- a/include/net/netns/vsock.h
> > +++ b/include/net/netns/vsock.h
> > @@ -7,6 +7,7 @@
> > enum vsock_net_mode {
> > 	VSOCK_NET_MODE_GLOBAL,
> > 	VSOCK_NET_MODE_LOCAL,
> > +	VSOCK_NET_MODE_LOCKED,
> 
> This is not really a mode, so IMO should not be part of `enum
> vsock_net_mode`. If you really want it, maybe we can add both
> VSOCK_NET_MODE_GLOBAL_LOCKED and VSOCK_NET_MODE_LOCAL_LOCKED, which can be
> less error prone if we will touch this enum one day.
> 
> > };
> > 
> > struct netns_vsock {
> > @@ -16,6 +17,12 @@ struct netns_vsock {
> > 	u32 port;
> > 
> > 	enum vsock_net_mode mode;
> > -	enum vsock_net_mode child_ns_mode;
> > +
> > +	/* 0 (GLOBAL)
> > +	 * 1 (LOCAL)
> > +	 * 2 (GLOBAL + LOCKED)
> > +	 * 3 (LOCAL + LOCKED)
> > +	 */
> > +	int child_ns_mode;
> 
> Sorry, I don't like this too much, since it seems too complicated to read
> and to maintain, If we really want to use just one variable, maybe we can
> use -1 as UNSET for child_ns_mode. If it is UNSET, vsock_net_child_mode()
> can just return `mode` since it's the default that we also documented, if
> it's set, it means that is locked with the value specified.
> 
> Maybe with code is easier, I mean something like this:
> 
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index d3ff48a2fbe0..fcd5b538df35 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -276,15 +276,25 @@ static inline bool vsock_net_mode_global(struct vsock_sock *vsk)
>  	return vsock_net_mode(sock_net(sk_vsock(vsk))) == VSOCK_NET_MODE_GLOBAL;
>  }
> -static inline void vsock_net_set_child_mode(struct net *net,
> +static inline bool vsock_net_set_child_mode(struct net *net,
>  					    enum vsock_net_mode mode)
>  {
> -	WRITE_ONCE(net->vsock.child_ns_mode, mode);
> +	int old = VSOCK_NET_CHILD_NS_UNSET;
> +
> +	if (try_cmpxchg(&net->vsock.child_ns_mode, &old, mode))
> +		return true;
> +
> +	return old == mode;
>  }
>  static inline enum vsock_net_mode vsock_net_child_mode(struct net *net)
>  {
> -	return READ_ONCE(net->vsock.child_ns_mode);
> +	int mode = READ_ONCE(net->vsock.child_ns_mode);
> +
> +	if (mode == VSOCK_NET_CHILD_NS_UNSET)
> +		return net->vsock.mode;
> +
> +	return mode;
>  }
>  /* Return true if two namespaces pass the mode rules. Otherwise, return false.
> diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
> index b34d69a22fa8..bf52baf7d7a7 100644
> --- a/include/net/netns/vsock.h
> +++ b/include/net/netns/vsock.h
> @@ -9,6 +9,8 @@ enum vsock_net_mode {
>  	VSOCK_NET_MODE_LOCAL,
>  };
> +#define VSOCK_NET_CHILD_NS_UNSET (-1)
> +
>  struct netns_vsock {
>  	struct ctl_table_header *sysctl_hdr;
> @@ -16,6 +18,13 @@ struct netns_vsock {
>  	u32 port;
>  	enum vsock_net_mode mode;
> -	enum vsock_net_mode child_ns_mode;
> +
> +	/* Write-once child namespace mode, must be initialized to
> +	 * VSOCK_NET_CHILD_NS_UNSET. Transitions once from UNSET to a
> +	 * vsock_net_mode value via try_cmpxchg on first sysctl write.
> +	 * While UNSET, vsock_net_child_mode() returns the namespace's
> +	 * own mode since it's the default.
> +	 */
> +	int child_ns_mode;
>  };
>  #endif /* __NET_NET_NAMESPACE_VSOCK_H */
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 9880756d9eff..f0cb7c6a8212 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -2853,7 +2853,8 @@ static int vsock_net_child_mode_string(const struct ctl_table *table, int write,
>  		    new_mode == VSOCK_NET_MODE_GLOBAL)
>  			return -EPERM;
> -		vsock_net_set_child_mode(net, new_mode);
> +		if (!vsock_net_set_child_mode(net, new_mode))
> +			return -EBUSY;
>  	}
>  	return 0;
> @@ -2922,7 +2923,7 @@ static void vsock_net_init(struct net *net)
>  	else
>  		net->vsock.mode = vsock_net_child_mode(current->nsproxy->net_ns);
> -	net->vsock.child_ns_mode = net->vsock.mode;
> +	net->vsock.child_ns_mode = VSOCK_NET_CHILD_NS_UNSET;
>  }
>  static __net_init int vsock_sysctl_init_net(struct net *net)
> 
> If you like it, please add my Co-developed-by and S-o-b.

Will do!

> 
> BTW, let's discuss here more about it and agree before sending a new
> version, so this should also allow other to comment eventually.
> 
> Thanks,
> Stefano

Tbh, I like your original proposal from v1 best (copied below). I like
that the whole locking mechanism is self-contained there in one place,
and doesn't ripple out elsewhere into the code (e.g.,
vsock_net_child_mode() carrying logic around UNSET). Wdyt?

static inline bool vsock_net_set_child_mode(struct net *net,
					    enum vsock_net_mode mode)
{
	int new_locked = mode + 1;
	int old_locked = 0;

	if (try_cmpxchg(&net->vsock.child_ns_mode_locked,
			&old_locked, new_locked)) {
		WRITE_ONCE(net->vsock.child_ns_mode, mode);
		return true;
	}

	return old_locked == new_locked;
}


Best,
Bobby

> 
> > };
> > #endif /* __NET_NET_NAMESPACE_VSOCK_H */
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 9880756d9eff..50044a838c89 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -90,16 +90,20 @@
> >  *
> >  *   - /proc/sys/net/vsock/ns_mode (read-only) reports the current namespace's
> >  *     mode, which is set at namespace creation and immutable thereafter.
> > - *   - /proc/sys/net/vsock/child_ns_mode (writable) controls what mode future
> > + *   - /proc/sys/net/vsock/child_ns_mode (write-once) controls what mode future
> >  *     child namespaces will inherit when created. The initial value matches
> >  *     the namespace's own ns_mode.
> >  *
> >  *   Changing child_ns_mode only affects newly created namespaces, not the
> >  *   current namespace or existing children. A "local" namespace cannot set
> > - *   child_ns_mode to "global". At namespace creation, ns_mode is inherited
> > - *   from the parent's child_ns_mode.
> > + *   child_ns_mode to "global". child_ns_mode is write-once, so that it may be
> > + *   configured and locked down by a namespace manager. Writing a different
> > + *   value after the first write returns -EBUSY. At namespace creation, ns_mode
> > + *   is inherited from the parent's child_ns_mode.
> >  *
> > - *   The init_net mode is "global" and cannot be modified.
> > + *   The init_net mode is "global" and cannot be modified. The init_net
> > + *   child_ns_mode is also write-once, so an init process (e.g. systemd) can
> > + *   set it to "local" to ensure all new namespaces inherit local mode.
> >  *
> >  *   The modes affect the allocation and accessibility of CIDs as follows:
> >  *
> > @@ -2853,7 +2857,8 @@ static int vsock_net_child_mode_string(const struct ctl_table *table, int write,
> > 		    new_mode == VSOCK_NET_MODE_GLOBAL)
> > 			return -EPERM;
> > 
> > -		vsock_net_set_child_mode(net, new_mode);
> > +		if (!vsock_net_set_child_mode(net, new_mode))
> > +			return -EBUSY;
> > 	}
> > 
> > 	return 0;
> > 
> > -- 
> > 2.47.3
> > 
> 

