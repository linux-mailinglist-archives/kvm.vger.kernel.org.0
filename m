Return-Path: <kvm+bounces-66920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id C00EBCEE01D
	for <lists+kvm@lfdr.de>; Fri, 02 Jan 2026 09:15:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2CA2C3001BF2
	for <lists+kvm@lfdr.de>; Fri,  2 Jan 2026 08:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 564342D24BF;
	Fri,  2 Jan 2026 08:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YA76nKi/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713302D5C74
	for <kvm@vger.kernel.org>; Fri,  2 Jan 2026 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767341707; cv=none; b=RGaNsOltbuW3MscF/lrCKvPjPK/VnsbcNyG1ZM/qTjFpcXCprfflgWove0sEr4WLo6AhEsNhEommXrDDbxAjt50Gn49wetK+UvzCMOhAa9s3ZbroW2ztR+tjomNmqL1si+r6q8Q+Dbqy4s70OIo0f/OWHuj/ex51FKyThG5WPgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767341707; c=relaxed/simple;
	bh=pR9J2JcpyuSslYDA7lsLX4ZhILZRZva1Jx7LQCRL2xc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bo9VcTY6+fiQVK43tNWQVbJp54c6p/3D6i8gQ16FcTQP4pcOy4J/qkuNbJGYAJl5Q7TM1j/B8YKTB2PPeXpo7Np/Z6HR2Ml8G/LEKb77pDsg1VID6Q5HkOlUzS2Nzf9kTtBBIXvggrFPIQk83FWGRqRGKBXfXtYD3eJZjpcDNJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YA76nKi/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477aa91e75dso12208695e9.3
        for <kvm@vger.kernel.org>; Fri, 02 Jan 2026 00:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767341702; x=1767946502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7B5OROvqw/DgiaRfLYZJf4GjF/wj6CLJOtpsQ8Z+Uq0=;
        b=YA76nKi/w+4r6QrU3u2zf5Le8V9XRZBLFbZgcDqg8nvt9MckDoEaO8By8k5rFaH2zj
         M6FOWUp+8LwZBjF7Ct+EYIO0kH0S0v+Pr9wSVpl4cXLp1lFB/7/Pb3+7EkRYFZ3ouqef
         b8TA2l7ZzYNtFHMUb7pVDcW0ZmWyV8GwubCAvrstaOiHAncUBTCHGnjdqJUtd1u693Nf
         pm12hnFgGAbipqxoZBPGus+ExXjFykcTzIXHpoBAw8wzK/IcFi5XxjN/gsygR6pDcVF0
         P1iYMU4BuJYFaPN7BknV7Vy3fKB9GXy/u40sq+1UrdlhP1knI9/5NYPkaXLxDyogj33o
         q9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767341702; x=1767946502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7B5OROvqw/DgiaRfLYZJf4GjF/wj6CLJOtpsQ8Z+Uq0=;
        b=rCG2tMP0141W9L6Y8DCIS9z3SrCX6lIxoY6V4bLP8vL/daljkCOrbSFzCGehO1Qhbs
         Rh+X+DFx3Kj2LGNzmG+yjRH7M513G2sdVYrL5DKHhrrkbXrfSCdXpfqw5aybSBiTJA4m
         H3gTpmp/NkOGQHW+NattSsIjW0FpLJtIb646i6GDd0/rR3SzdNdVKsDZRLa10bv++eW6
         N2FNf/AKVIQtwOasqgYdtmPQldH3W3tqOCXwblcwUKHljgPlpiGpA8IHSGf/O5bpiKLM
         WBaOtOwas0B1fk4U+He+eU/UYZEDTjxbDC+QI+XQfz28gFBmmac/2x7+YUvMh58ha96N
         Rt0g==
X-Forwarded-Encrypted: i=1; AJvYcCU+0Mc5Ua+Dd4KRDPh4tin+ACjiIiWNcBVzEzdA5BbaAmC4C7PBWYSDfqp+w3760uh4YTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRmdHBVZX3dthLHfGOH4AV942eF5euI1eeJBeKwOvG0qvnUVuG
	jcl1Q+yPUTuCKkQdqlLsxX1Lxqit7T9wtZJFCZVTi5G0KKWsl1Y8SRqD1nJ5O7TybdY=
X-Gm-Gg: AY/fxX4wUNckKmoDgElwqIaTecFn5KP2Sy3oC0zQJcvs72VScH6F1DvDhQivHHT4ArH
	VKmHpCHAnpdERJ0Rysl32g3lsgSzDFfXlPzeOXZaxO7MzzPQrZ+QaWDr1SMF0c8qrJ6J/Fn0zlv
	TSGHB7ZxuZXa7+s+P2AUd4Yy60xEJW9uGcci6MPPaI7ysP29/CT/S+l5evV0u4XamGvrAsnBibs
	8+IS6fbI1dOzOGG+Mbrjehb7QmzpJaVCXu8oaOEoPPf3hpNeWxeV2ArHTt6n3v5dO43rFKGUp/Q
	6O/B99vSHZvFtY6WeLdQ2R46ZkNYpkFyY9P/+kE5+3Iexq0773rdysFkz1beQ1Pzc7f4yPEuC2o
	l1hHLxSAvExyQNvhaV28RBNePRLad+3Dn3TlnrmjAXUnGwhz+uyEkC29sKtWJqFeIGLkykqg++2
	GQl1rV59w5t2KhnVVd8v0B17GlkKB4POQb2OAJt1zGkH0qaNXe5YFyxF5Q+tuX3lJpANroEGRGt
	jMQ
X-Google-Smtp-Source: AGHT+IEG7/UqWg/6ELIcyq0mVb3xfMQn4RI8cpiRrR5W4zXnA35xM+TJgjTRoe1XllkShxIti5fDKg==
X-Received: by 2002:a05:600c:3151:b0:477:a203:66dd with SMTP id 5b1f17b1804b1-47d197f69demr322547935e9.2.1767341702410;
        Fri, 02 Jan 2026 00:15:02 -0800 (PST)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47be27b0d5asm792930555e9.13.2026.01.02.00.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 00:15:01 -0800 (PST)
Date: Fri, 2 Jan 2026 09:14:59 +0100
From: Petr Tesarik <ptesarik@suse.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jason Wang <jasowang@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Eugenio =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, Xuan Zhuo
 <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella
 <sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Leon Romanovsky
 <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org,
 virtualization@lists.linux.dev, linux-scsi@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 01/13] dma-mapping: add
 __dma_from_device_align_begin/end
Message-ID: <20260102091459.6bec60c2@mordecai>
In-Reply-To: <20251231154722-mutt-send-email-mst@kernel.org>
References: <cover.1767089672.git.mst@redhat.com>
	<ca12c790f6dee2ca0e24f16c0ebf3591867ddc4a.1767089672.git.mst@redhat.com>
	<20251231150159.1779b585@mordecai>
	<20251231154722-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 31 Dec 2025 15:48:26 -0500
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Dec 31, 2025 at 03:01:59PM +0100, Petr Tesarik wrote:
> > On Tue, 30 Dec 2025 05:15:46 -0500
> > "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >   
> > > When a structure contains a buffer that DMA writes to alongside fields
> > > that the CPU writes to, cache line sharing between the DMA buffer and
> > > CPU-written fields can cause data corruption on non-cache-coherent
> > > platforms.
> > > 
> > > Add __dma_from_device_aligned_begin/__dma_from_device_aligned_end
> > > annotations to ensure proper alignment to prevent this:
> > > 
> > > struct my_device {
> > > 	spinlock_t lock1;
> > > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > > 	char dma_buffer2[16];
> > > 	__dma_from_device_aligned_end spinlock_t lock2;
> > > };
> > > 
> > > When the DMA buffer is the last field in the structure, just
> > > __dma_from_device_aligned_begin is enough - the compiler's struct
> > > padding protects the tail:
> > > 
> > > struct my_device {
> > > 	spinlock_t lock;
> > > 	struct mutex mlock;
> > > 	__dma_from_device_aligned_begin char dma_buffer1[16];
> > > 	char dma_buffer2[16];
> > > };  
> > 
> > This works, but it's a bit hard to read. Can we reuse the
> > __cacheline_group_{begin, end}() macros from <linux/cache.h>?
> > Something like this:
> > 
> > #define __dma_from_device_group_begin(GROUP)			\
> > 	__cacheline_group_begin(GROUP)				\
> > 	____dma_from_device_aligned
> > #define __dma_from_device_group_end(GROUP)			\
> > 	__cacheline_group_end(GROUP)				\
> > 	____dma_from_device_aligned
> > 
> > And used like this (the "rxbuf" group id was chosen arbitrarily):
> > 
> > struct my_device {
> > 	spinlock_t lock1;
> > 	__dma_from_device_group_begin(rxbuf);
> > 	char dma_buffer1[16];
> > 	char dma_buffer2[16];
> > 	__dma_from_device_group_end(rxbuf);
> > 	spinlock_t lock2;
> > };
> > 
> > Petr T  
> 
> Made this change, and pushed out to my tree.
> 
> I'll post the new version in a couple of days, if no other issues
> surface.

FTR except my (non-critical) suggestions for PATCH 5/13, the updated
series looks good to me.

Thank you!

Petr T

