Return-Path: <kvm+bounces-71308-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QMYoDT1clmkdeQIAu9opvQ
	(envelope-from <kvm+bounces-71308-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:41:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 144FE15B38A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 01:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7E752300F10B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 00:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321E522FE0A;
	Thu, 19 Feb 2026 00:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKypQ9FC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7831F4611;
	Thu, 19 Feb 2026 00:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771461681; cv=none; b=dDX6dZYwKmanJIWRk/yLa6M4tBMXBMo2EMXpZDYQCPIxddYsjQ10KUjaS4N21eyLJw0F4eJLB001vdqkHxkSWe31J2mlTDhqrtCZzB98yU3zXR8OOp5pdsERZno65Ph49/XzeiwEE79vsd5htune5SPXeHBMd5QjBIskSJDm9rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771461681; c=relaxed/simple;
	bh=1VGZTiHH6lz93ptvC5y3a1UDrS1AgfaABSsTg9z2EJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m91icz0dBDgIZyLPoTOMt0cNrXNXRfzh4XaKbYBm1teQTcSdAqJsg/oiNyscgGfJr07Q82j3loh0vZz9oWoulSDlPySKvrLQf7IKcJsbcy0pF0tJBrHXLt4dqN1SgpYdtQPWyHqCCNpO2yPoVIINBHPOdbyGUO6dwtQeSY0vegA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OKypQ9FC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37721C116D0;
	Thu, 19 Feb 2026 00:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771461681;
	bh=1VGZTiHH6lz93ptvC5y3a1UDrS1AgfaABSsTg9z2EJ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OKypQ9FCe5NJdl0PkK/RF5NUIDU2I7XtINI3jrfj6r/81bv0xVOSR3fpDe4QUfZ39
	 N6W9pq3qrPMxKaAs37uZGv0iwBNO2rarziJrLjITdH/VRLGpGdAJWK19WR2aoBq8qi
	 AM14IBSge7mnd/uM4fNFNNTGLUAUk79RW/Uo80iHonCPTg3c0/tI5+oS35Yee4VEXa
	 AtBS0Qa2HBPV4KswbcanaRJdiHu4WDezt9IWyKunHWTCODGGBpUB8dBW7Vi+jn2Rk4
	 GPxZjRToew1aavNrU9x/cxqCndtV7gkVZ2ULYWYv4jIB6sogQ9dO9S7w99dp1RmUSW
	 X4V6x/ez6K96A==
Date: Wed, 18 Feb 2026 16:41:19 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Hajnoczi
 <stefanha@redhat.com>, Shuah Khan <shuah@kernel.org>, Bobby Eshleman
 <bobbyeshleman@meta.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Daan De Meyer <daan.j.demeyer@gmail.com>
Subject: Re: [PATCH net] vsock: lock down child_ns_mode as write-once
Message-ID: <20260218164119.72368d53@kernel.org>
In-Reply-To: <aZXlqv5ukWymz/NI@devvm11784.nha0.facebook.com>
References: <20260217-vsock-ns-write-once-v1-1-a1fb30f289a9@meta.com>
	<aZV6HRAIsf_rNRM2@sgarzare-redhat>
	<aZWUmbiH11Eh3Y4v@sgarzare-redhat>
	<aZXlqv5ukWymz/NI@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71308-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FREEMAIL_CC(0.00)[redhat.com,davemloft.net,google.com,kernel.org,meta.com,lists.linux.dev,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 144FE15B38A
X-Rspamd-Action: no action

On Wed, 18 Feb 2026 08:15:38 -0800 Bobby Eshleman wrote:
> > > I'm not sure what the policy is in netdev, but I would prefer to have
> > > selftest changes in another patch (I think earlier in the series so as
> > > not to break the bisection), in order to simplify backporting (e.g. in
> > > CentOS Stream, to keep the backport small, I didn't backport the dozens
> > > of patches for selftest that we did previously).  
> 
> Sounds good! I wasn't sure if breakage so tightly coupled should be in
> the same patch or not, I'm happy to split it up to ease backporting.

FWIW the netdev recommendation is indeed to split the selftests out.
Also to bungle selftest patches with the fix into one series targeting
net, even tho the selftests patches won't have a Fixes tag.

