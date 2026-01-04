Return-Path: <kvm+bounces-66977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B70D2CF09D6
	for <lists+kvm@lfdr.de>; Sun, 04 Jan 2026 06:29:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8B0B301EC65
	for <lists+kvm@lfdr.de>; Sun,  4 Jan 2026 05:29:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7E3D2D640D;
	Sun,  4 Jan 2026 05:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yg6Zqa0y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A52720322
	for <kvm@vger.kernel.org>; Sun,  4 Jan 2026 05:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767504552; cv=none; b=NEBf508jr3eu+OReeEjoQT3EdVBaJLNLYpj9K2EFjmbqcAKTYQe6jm8h4Q0WUqQgm0ed3xZQeNTPvECmthjxDlWnm8UIXBcOfeMMmHMx8qMd4rR/Gv5XM69l2rz7cbbSzO6D5ouBVrOkfWykQ4cakh2lwWhW18PyX3NxOREMFQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767504552; c=relaxed/simple;
	bh=65vgSVMqf/BQy1Yp33ggrUZQR1FCpsrPR3lKZwoF6e0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lsFXlzvhw+GXpZdJCkaleD0i76KXtJyB8ciulM1DGOyd9bimZyk5DPm73tMnrC64WG3aYTp3Skgz3AWMk9WdKcZ++EkcSdRXY/tIIzRxrLHSpW1MsNfbuT/jNCXzxupMDoZgRjWuLnpXfVTjmlCkWSZfMGGu5pC2Msik0xpFE+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yg6Zqa0y; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-11beb0a7bd6so1228608c88.1
        for <kvm@vger.kernel.org>; Sat, 03 Jan 2026 21:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767504548; x=1768109348; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nvOkP8SZJigPzeyYaj+yZhhAkS0A2aAjhXuUNUZVL+k=;
        b=Yg6Zqa0yl4Ps3xat499EvczeKmPP3moBORRbUlV1QwjEzeMc2FetSIJuCtbs0xtf+l
         lCWXpwZzaZAEqvlD0feNi3BzaeGwEw9+ejVV+ZUjPH1Lpan1bVeLIixJaVysBv+/t5IV
         X6YFXEH5EKv1KMD6dbg8J7d7sWaWzu8wK59iQ90DJMds5LwqrLJEMQcY49mX6eC/kQVV
         bHEo2ypbv+2s6Wj3z8y8lxVNyQBOTMvbiL0tTw7YnhkiXz3fUdvsRDd9kbVNpOkjDxQ5
         DBrABF2OGuS5DIGq7A+GwgXOr3T4uR8t7sJyTp3eHFAUf2ft/ISVWPeE2X7lvHUzovGG
         FAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767504548; x=1768109348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nvOkP8SZJigPzeyYaj+yZhhAkS0A2aAjhXuUNUZVL+k=;
        b=JltbbaMn2pTPkf86rfCXWDuPa7lPkjWlnt6jgjTgXMwM3Wm9e58vUMnaSyVooeyd5e
         MkAEBuAaGWBQc2+ONTj1ukCqDMlfv7AryDWmIrovUnVpOMvrzEVwpryt5brQXFiBShw9
         4yyPDUZm6SLZahDalouzV2pCU4K+b2SeW9ZaD2rBeCTzHeK+gMghz5fwCuJ1/BMTbekC
         BfJqd6WWkcpckGEiToDzzt3nmqjwvYOYLy19YHalopunDeP58IqF9rflFFf5VLuiBjBh
         ZG3t5uTFGFeZ6y0LWom7fJz2I8FIQFdfNtTPOFiP/7fQo0mIT//38FlQwIGfLOX7xm/7
         Y7QA==
X-Forwarded-Encrypted: i=1; AJvYcCVOvSC3JXgLsUEN2p6/HmwBnmvSEYSh3XiwfzyYi2cK9lN3rKUbCvsXuIATGf7yqZgDi0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsPB/qErk2HK2aAeFYk+vPLsbeqmbqmDFkZk/yhDQYolyJT8F8
	TSswmcFmIknbNgAs+WRf+FMxjMnbjeq0bFAP99ELn4/brAUhNMjlsmPNuD2BiA==
X-Gm-Gg: AY/fxX7X0wLRZKUGVg+/MiT84dKKfH4GuVat1b7Q8Rz5kUiycTgJChusy+9c1CPDg2v
	83IjLy65uNMJ5gch82tM/MkS/t1BkKfHtiQ6UEfqRYS9YMkWritxt5tS6SBjS0Avqnwrs1Xccio
	7YQjmeDgL6fN/szwDFSxHgWsSBwvNOavr+pJH0yTdEqEw4hR/NaJzWf5mIUpDCeM1SOoDj0Gfb6
	cwEb4/ihGS+cODhW9xbrJuwjd3ZlKv4PBS/Tp0/cDgNgoe+ZnsSyKJhFwe0tIFXW2q2v5t4mnNx
	9a56PnVL36xokLwC4qcgBiXBKNYZ25QHuY9HLrlpcVrEmaAfZFomVL/lJWjjUyiu4FJjSP62Fdv
	7ZgOUJnX2IxmGLjUYscC6IBwXP7uNs9hkX8ZX+G8hwgemH37uRqPws92VHtgxjO5klHMSAsanIY
	Oxquth0JgQ2PSBCwKg
X-Google-Smtp-Source: AGHT+IEUP35P72PXbqK3T+Jw88HQN7ZqgMrv6wlEXPBBGaZBS9BBhhgZozXciIYpR2i4MqLpZOsSXw==
X-Received: by 2002:a05:7022:320:b0:11f:3479:fb72 with SMTP id a92af1059eb24-121d808b16emr3204222c88.6.1767504547989;
        Sat, 03 Jan 2026 21:29:07 -0800 (PST)
Received: from localhost ([2601:647:6802:dbc0:8a10:ce2:890f:8db0])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfdd0sm164944598c88.4.2026.01.03.21.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Jan 2026 21:29:07 -0800 (PST)
Date: Sat, 3 Jan 2026 21:29:06 -0800
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Cong Wang <cwang@multikernel.io>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [Patch net] vsock: fix DMA cacheline overlap warning using
 coherent memory
Message-ID: <aVn6ooxGnWH3X8ZZ@pop-os.localdomain>
References: <20251228015451.1253271-1-xiyou.wangcong@gmail.com>
 <20251228104521-mutt-send-email-mst@kernel.org>
 <aVGz39EoF5ScJfIP@pop-os.localdomain>
 <20251230081220-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251230081220-mutt-send-email-mst@kernel.org>

On Tue, Dec 30, 2025 at 08:12:47AM -0500, Michael S. Tsirkin wrote:
> On Sun, Dec 28, 2025 at 02:49:03PM -0800, Cong Wang wrote:
> > On Sun, Dec 28, 2025 at 02:31:36PM -0500, Michael S. Tsirkin wrote:
> > > On Sat, Dec 27, 2025 at 05:54:51PM -0800, Cong Wang wrote:
> > > > From: Cong Wang <cwang@multikernel.io>
> > > > 
> > > > The virtio-vsock driver triggers a DMA debug warning during probe:
> > > > 
> > [...]
> > > > This occurs because event_list[8] contains 8 struct virtio_vsock_event
> > > > entries, each only 4 bytes (__le32 id). When virtio_vsock_event_fill()
> > > > creates DMA mappings for all 8 events via virtqueue_add_inbuf(), these
> > > > 32 bytes all fit within a single 64-byte cacheline.
> > > > 
> > > > The DMA debug subsystem warns about this because multiple DMA_FROM_DEVICE
> > > > mappings within the same cacheline can cause data corruption: if the CPU
> > > > writes to one event while the device is writing another event in the same
> > > > cacheline, the CPU cache writeback could overwrite device data.
> > > 
> > > But the CPU never writes into one of these, or did I miss anything?
> > > 
> > > The real issue is other data in the same cache line?
> > 
> > You are right, it is misleading.
> > 
> > The CPU never writes to the event buffers themselves, it only reads them
> > after the device writes. The problem is other struct fields in the same
> > cacheline.
> > 
> > I will update the commit message.
> > 
> > > 
> > > You want virtqueue_map_alloc_coherent/virtqueue_map_free_coherent
> > > methinks.
> > > 
> > > Then you can use normal inbuf/outbut and not muck around with premapped.
> > > 
> > > 
> > > I prefer keeping fancy premapped APIs for perf sensitive code,
> > > let virtio manage DMA API otherwise.
> > 
> > Yes, I was not aware of these API's, they are indeed better than using
> > DMA API's directly.
> > 
> > Thanks!
> > Cong
> 
> BTW I sent an RFC fixing these bugs in all drivers. Review/testing would
> be appreciated.

Thanks for taking care of it.

In case you need, it is 100% reproducible with CONFIG_DMA_API_DEBUG=y.

If you need my config, here it is:
https://github.com/congwang/kernelconfig/blob/master/kvm-debug-config

Regards,
Cong Wang

