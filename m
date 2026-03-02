Return-Path: <kvm+bounces-72388-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNInBjiqpWmpDgAAu9opvQ
	(envelope-from <kvm+bounces-72388-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:18:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF691DBA8D
	for <lists+kvm@lfdr.de>; Mon, 02 Mar 2026 16:18:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8487530EEDFD
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 15:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31F0411604;
	Mon,  2 Mar 2026 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WNrY60Ac";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="FiKaHq+2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A040F8D8
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772464342; cv=none; b=b8BKKnntCWH4H/T6/fhLjLjt+L11iUDDYeSf2QhW8PAgXr0ipBQ6X0GmxrlDC14kWFdq+YW1aaKJJykqAgcq9GmaoPrgWxutmmH8jH2HGaUDZY9RBGAezd3PQx8Mf8McXHteMGl2PIgSejvvSZbL4qIbTxFfWz8GzCDMsg7jL80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772464342; c=relaxed/simple;
	bh=op0liavrrZXpHIYFE8b5murCMpJBWBYITF7jRogwVXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gf+e3PYXaYvBxLDMFM+uMLON/5+5QUZzBbDoHSB8wXTvdoNBmPoYntVr94X2jzaH0AMeX85RISIvQqX3sqESUNhd4qFhu2g7sBYTYkl7bcuk27RVCaL73M1MpLAFSwLNrAQ5pu+EtBKt91gsmhZdnXJda2MIpkLvsTsv8gpBmSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WNrY60Ac; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=FiKaHq+2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772464339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RF0n2SJ1RvllNep2fFvHq0JPMVeIU4OKpnJDj8ItlsE=;
	b=WNrY60AciXkRUrU7h7ICByvMGUZj1SnNtt+hm75P8we+1+FJxkJ1wIOUoE9QZ/1D0nKLG3
	vzhXClEwxWSPQ3ufLyXyqY1TbJcpfigwvcUFWe9lBcv71DesprVc0EvDAklpJXCSl8koL3
	KS/8gcEt4+G7JCvQsWinErhHURtZKMc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-_BYLGL49Ns6Pi39d7GmT7g-1; Mon, 02 Mar 2026 10:12:16 -0500
X-MC-Unique: _BYLGL49Ns6Pi39d7GmT7g-1
X-Mimecast-MFC-AGG-ID: _BYLGL49Ns6Pi39d7GmT7g_1772464335
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so50439805e9.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 07:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772464335; x=1773069135; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RF0n2SJ1RvllNep2fFvHq0JPMVeIU4OKpnJDj8ItlsE=;
        b=FiKaHq+2tyH8zoTrCU34EKgaF6VI4eGrN7Cpbgpl+PK5i9Xi1gzBpVkXVTuX0/q+a0
         GrU8h9k5AzbcY92nNVQACuup3wznw+f/TOJ1Dc5QUwJMgS/3gUHhyvOFMOw+SKm/jmAa
         7vwIfA2H4OV8wzoSeCRzOKTBwyFtVgHf+qkV3silkj5mu1YfM4P+q/evcNISgDe5MiMV
         lmm3qELJZMuLhM74D257VLkImoXcgGS/tVtoQm++PHkshiu8gSx8VvdOBrU3UvvtxzpZ
         nIzYn0LoiPHZR9xsY1hAI0CCwwM8DHzHmYdaWSQzVcBdWNrlRJVWcxQtELEQHGcZahdd
         /9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772464335; x=1773069135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RF0n2SJ1RvllNep2fFvHq0JPMVeIU4OKpnJDj8ItlsE=;
        b=euPVpqQlHWS2TdyX+5IFEqWqT4hDoiylw3fLSIOI51RjtCmXaP1W/g25eIdbxqjQco
         xDZ16Fqcu7HgFnfeax04saxfPB4t61k9VTCD2igQ0u86Qc/ORI9NhDy6wUjIrSBCJ/+c
         JwCyrCuR01gmgLdlhlHKCJY9E3zAOoeqg7lK3eITchKG+NsTmXJ6GglUAxV8gu1VeLax
         2JKQzvEGcJ8xnfdrHlIR0eKi4MNxiaGHJa0jwG0seHIiP0087JW4HRFaIw4EnflicFDK
         93M29XDZ5b2Mm33yJk8MYl0DS+YfeM/uOnF5tbEoCvgSTZ0EpG8ykMBYCMfonEa3jKec
         lo7g==
X-Forwarded-Encrypted: i=1; AJvYcCWr7WiFitrq6ZvuWJ1Q+Uz5U+r1e2p6Hrd9cuOunywrFvnIxDj+GquzFC9pdle0QHv2usM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoynpFxX423OTrifVU2kEEzR+IUW5kMjFLdWi6n8zix/AbFFoD
	y2TgI9SOGtXbUD83vHsJsfYuvA6+1w1maoqqQmnwfJma5K43P2ecCOySwNKKOrRKPwnVytYzZBN
	piOZQUPMd+7GfayL/TwWHD6v+XJYdskme9gSOYDfvWHDroFUFTwkkPw==
X-Gm-Gg: ATEYQzyDMnnTkCGYblt0ANzvqDlw5pn7mtfedCNicC198Ra+8iyFoQesYcunq/asrRa
	dKm7MReZlfhuLUAeOblxdJCJr3U3AhyS25rlvuiQFMsB6KyTOQ1yO7AVTlBinziMeCu4pqXOyL6
	3CxguvBDpZPCJcAkEEozHoKFgErNZFxPbi8DVtOwmWT/El1si3SM/X+4Mhl+nhqRgpZePO+WW6L
	+s75WhWzhgP+0ukmmwDdsLtKVWH6SkF0mr/Vr113iMvYo7dXNvlMkrSzgWtZYAYNnWKuzby6i21
	4LW4Wtb0AWqjGTRinvLEBsVR1U7upPUdIdNdD5/5hqECY210DHyvFApzyN971nPHpPU06frDsJI
	fZbC+pX9/5NkFDbTiJbpa159FYY7jmXfNeZXlbGFWb8cZgg==
X-Received: by 2002:a05:600c:8106:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-483c9bb6559mr206067715e9.4.1772464335135;
        Mon, 02 Mar 2026 07:12:15 -0800 (PST)
X-Received: by 2002:a05:600c:8106:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-483c9bb6559mr206067215e9.4.1772464334575;
        Mon, 02 Mar 2026 07:12:14 -0800 (PST)
Received: from redhat.com (IGLD-80-230-79-166.inter.net.il. [80.230.79.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd765604sm360962425e9.15.2026.03.02.07.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 07:12:13 -0800 (PST)
Date: Mon, 2 Mar 2026 10:12:11 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: linux-kernel@vger.kernel.org, ShuangYu <shuangyu@yunyoo.cc>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC] vhost: fix vhost_get_avail_idx for a non empty ring
Message-ID: <20260302101125-mutt-send-email-mst@kernel.org>
References: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
 <aaWTjPXDqhMZlwLr@sgarzare-redhat>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaWTjPXDqhMZlwLr@sgarzare-redhat>
X-Rspamd-Queue-Id: 6EF691DBA8D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72388-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 03:30:53PM +0100, Stefano Garzarella wrote:
> On Mon, Mar 02, 2026 at 03:51:49AM -0500, Michael S. Tsirkin wrote:
> > vhost_get_avail_idx is supposed to report whether it has updated
> > vq->avail_idx. Instead, it returns whether all entries have been
> > consumed, which is usually the same. But not always - in
> > drivers/vhost/net.c and when mergeable buffers have been enabled, the
> > driver checks whether the combined entries are big enough to store an
> > incoming packet. If not, the driver re-enables notifications with
> > available entries still in the ring. The incorrect return value from
> > vhost_get_avail_idx propagates through vhost_enable_notify and causes
> > the host to livelock if the guest is not making progress, as vhost will
> > immediately disable notifications and retry using the available entries.
> 
> Here I'd add something like this just to make it clear the full picture,
> because I spent quite some time to understand how it was related to the
> Fixes tag (which I agree is the right one to use).
> 
>   This goes back to commit d3bb267bbdcb ("vhost: cache avail index in
>   vhost_enable_notify()") which changed vhost_enable_notify() to compare
>   the freshly read avail index against vq->last_avail_idx instead of the
>   previously cached vq->avail_idx. Commit 7ad472397667 ("vhost: move
>   smp_rmb() into vhost_get_avail_idx()") then carried over the same
>   comparison when refactoring vhost_enable_notify() to call the unified
>   vhost_get_avail_idx().

Indeed.

> > 
> > The obvious fix is to make vhost_get_avail_idx do what the comment
> > says it does and report whether new entries have been added.
> > 
> > Reported-by: ShuangYu <shuangyu@yunyoo.cc>
> > Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
> > Cc: Stefano Garzarella <sgarzare@redhat.com>
> > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Lightly tested, posting early to simplify testing for the reporter.
> 
> Tested with vhost-vsock and I didn't see any issue.
> 
> Thanks!
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> > 
> > drivers/vhost/vhost.c | 11 +++++++----
> > 1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 2f2c45d20883..db329a6f6145 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1522,6 +1522,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
> > static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
> > {
> > 	__virtio16 idx;
> > +	u16 avail_idx;
> > 	int r;
> > 
> > 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
> > @@ -1532,17 +1533,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
> > 	}
> > 
> > 	/* Check it isn't doing very strange thing with available indexes */
> > -	vq->avail_idx = vhost16_to_cpu(vq, idx);
> > -	if (unlikely((u16)(vq->avail_idx - vq->last_avail_idx) > vq->num)) {
> > +	avail_idx = vhost16_to_cpu(vq, idx);
> > +	if (unlikely((u16)(avail_idx - vq->last_avail_idx) > vq->num)) {
> > 		vq_err(vq, "Invalid available index change from %u to %u",
> > -		       vq->last_avail_idx, vq->avail_idx);
> > +		       vq->last_avail_idx, avail_idx);
> > 		return -EINVAL;
> > 	}
> > 
> > 	/* We're done if there is nothing new */
> > -	if (vq->avail_idx == vq->last_avail_idx)
> > +	if (avail_idx == vq->avail_idx)
> > 		return 0;
> > 
> > +	vq->avail_idx = avail_idx;
> > +
> > 	/*
> > 	 * We updated vq->avail_idx so we need a memory barrier between
> > 	 * the index read above and the caller reading avail ring entries.
> > -- 
> > MST
> > 


