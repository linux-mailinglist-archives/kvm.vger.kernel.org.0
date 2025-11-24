Return-Path: <kvm+bounces-64398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 04568C81581
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 44A714E6F99
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:29:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E88A314A7A;
	Mon, 24 Nov 2025 15:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="V5KZ7d0T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B744C2F39DC
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 15:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998082; cv=none; b=toVssaSaRlHRq5sIsRkwfQdLtuRsH6pxdJVCxreBvjPSznf2twgQOt6+2EsOl0/s0iV7x26Th/L0pJa2BIsHl9UtOQVQGeyBG0i5+9/V6PtbIj/RaGv7iQGnlyYzvzpZ6bhExo4tJqrQI9ROQK/faLMVMMdthrL4zmxEIlJB+Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998082; c=relaxed/simple;
	bh=q1RSYP6MsAvIm0Pq2Uruz+WZQe9fgkegsjE1gjboYnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i/aPsKEXX3RTkiLgBZ0Oq6XLCKXzKKcEvG1VCTLixKgueLNKBrdpjHkSi1ORx6FXP9/Xd2Ih2gclY1vseqhgCOazL+j8GqlQIi7GFE6//icPJUhs4NIbExZXDr9gNDq/MVlTkJs/ghBlpWDVJumtwihdzExp1Kppry9RcJRhO50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=V5KZ7d0T; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-43346da8817so21095865ab.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 07:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1763998080; x=1764602880; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q1RSYP6MsAvIm0Pq2Uruz+WZQe9fgkegsjE1gjboYnk=;
        b=V5KZ7d0TWB5xN7Tflj5OCflPhBySC6XszabAvnxm/rcySmjNin1+k7xXjURXbA0SZB
         TAiQXXLUqPHqY9K14jlGny/j8VQCi14hbgoik8SopBGavPBVdl/JwCb5RekbD16WoEpv
         EfpClUI57rfEX0zmtmXGVBD035OZIpzuaFwFCkaN7ceJ2zwntqyRgpx39Jqdd7QBZfAm
         XTjOuH8ClaS07u0zWHmmAg0rgEH3+iNdQMw41U1QIm7XXx8HQr0QzxJUPS6zooWMq87r
         97Gmg1MvRH4RFCPe5PfFz4lVJzphrrjvCzw5v7P9V+2+n7m6IZlw4IYjuTw4gX43Y/vj
         SmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763998080; x=1764602880;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q1RSYP6MsAvIm0Pq2Uruz+WZQe9fgkegsjE1gjboYnk=;
        b=GhKFPOK5AXwbacn/pwKdrVZiaP3vS1TFnd/Ly/4q9RNZ0OJsz5g2PTW6ukT9qzx1fb
         0VcaO5+aGR+svEp9iFzMZwGyqPzLg+fvNkw6uXrcNt03WrbDmg15jDyP0i6ae5qKtKQ3
         1KbMpX1adLaF78xI5itXGW+k72k/IV+sUmTDM0GKfSDXj1ZFfb3yBByfGZhpVGdCmHfT
         J+Bn1uRkwr3vwWaQMHFDbhNUu0vm+DGZRUwD6CE3kA8Ng7XatTwKi5qKMRiUk1/j5Cwn
         8E6TaUpiNKUNATwpQI1RcMewGxutyIDRuVU1JbUqKA9wHbihCqAwom3PQ7UZpx7pzdSO
         oi6g==
X-Forwarded-Encrypted: i=1; AJvYcCWXOwstPC2hgrh5dNkR3H82cnBAehUlqFM7FoRzxnFu4QvvdzLEIP1XaE8HBwvBoplpaD0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5QDdmu96iVnXixkYiUjJWNLyT+LiIQkaij/U2kqSk1sXpBZQu
	bnmGrdOM1zy6RSErSj3v9IWFKo0LpQknY+rnxSpVBcxc8fL034VgQyxxTV+IEiUsiug=
X-Gm-Gg: ASbGncvHq0bdmCC2JVlfdevLBIgewd2eR5zCAFxtnDaZd2rVtycpDepLVF+ZAc0ardQ
	B/u2PT866g0JsiyzT9eba7qLhilG6g9ETuFVk9kefBswFXcM6yzQ4Pl/xOTupNUzGZmEe0BPokA
	+Xt3pYmExnuDSFwnLiN0NJOhmMHM5RIMKA2aXsMdyr+f1b2pQYXogJNLWe06OLlQOkGuuDr7HHJ
	3XP9PajC4kHfzDiHam3qo2Ha6mkPP1rsoxg2be/h2K3xWOmb6sFQ/LFLv877cp8H5Vh5BndTpQm
	QEelIHOgHNLlvmSS8k6PCPWrnSej/WOLRnUHtwDirgzN+jOW0XRvGfSvjv+Fdk6qTalaYgeMPSF
	KIvVNroqGSbvixGLes2DtBzBaF27Kb25NbDDB79HqULz9njBLrbhaivMhnic5qxHUioYU+K2TtG
	VJ85wedx2Y0gXt
X-Google-Smtp-Source: AGHT+IHmDpkWVE+bXi7YcFx06zdDu1mvUX5E8wtndVMa3n+flWgwc0GhUUEOVNOo3pwJ3is8DkRQDw==
X-Received: by 2002:a05:6e02:3187:b0:433:7842:7967 with SMTP id e9e14a558f8ab-435b90f7448mr96578225ab.11.1763998079832;
        Mon, 24 Nov 2025 07:27:59 -0800 (PST)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-435a90dba32sm60356135ab.28.2025.11.24.07.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 07:27:59 -0800 (PST)
Date: Mon, 24 Nov 2025 09:27:57 -0600
From: Andrew Jones <ajones@ventanamicro.com>
To: Guo Ren <guoren@kernel.org>
Cc: fangyu.yu@linux.alibaba.com, anup@brainfault.org, 
	atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	alex@ghiti.fr, kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RISC-V: KVM: Allow to downgrade HGATP mode via SATP mode
Message-ID: <20251124-4ecf1b6b91b8f0688b762698@orel>
References: <20251122075023.27589-1-fangyu.yu@linux.alibaba.com>
 <CAJF2gTTRBFTnu2pA5rh16EWLvF_Wo=+vpZMUK9roDkDPes4Fpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJF2gTTRBFTnu2pA5rh16EWLvF_Wo=+vpZMUK9roDkDPes4Fpg@mail.gmail.com>

On Sun, Nov 23, 2025 at 10:33:19AM +0800, Guo Ren wrote:
> On Sat, Nov 22, 2025 at 3:50 PM <fangyu.yu@linux.alibaba.com> wrote:
> >
> > From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
> >
> > Currently, HGATP mode uses the maximum value detected by the hardware
> > but often such a wide GPA is unnecessary, just as a host sometimes
> > doesn't need sv57.
> > It's likely that no additional parameters (like no5lvl and no4lvl) are
> > needed, aligning HGATP mode to SATP mode should meet the requirements
> > of most scenarios.
> Yes, no5/4lvl is not clear about satp or hgatp. So, covering HGPATP is
> reasonable.

The documentation should be improved, but I don't think we want to state
that these parameters apply to both s- and g-stage. If we need parameters
to dictate KVM behavior (g-stage management), then we should add KVM
module parameters.

Thanks,
drew

