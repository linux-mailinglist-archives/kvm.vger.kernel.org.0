Return-Path: <kvm+bounces-68743-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COb3LVEAcWmgbAAAu9opvQ
	(envelope-from <kvm+bounces-68743-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:35:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 26ED459F91
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:35:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9E93350F0D0
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD193D6476;
	Wed, 21 Jan 2026 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Q5t28WBa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D208048B37D
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010002; cv=none; b=c44rcB1qEs1JGc8iCySWYfFG0bn803Vm0G8djumazbCUsIbbdl/lAieOY+9SntYUOMRC16i1XVJdMV5Bv/4tneTWKvnqETdLcBJZSoNenmXH8S5nVo9p2PQ0a/6KjBCO5Bo2iJ5+6h0BO+6TbH2Ylhu5k9Yfm2x5aXaGnInsYv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010002; c=relaxed/simple;
	bh=6/tSgLR7J3UgafXRAX+XBEPxIV3H81+kUIgU8b8gh7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L6oowbIm9WhV2sjfL+EWF9j7i+Yb3ReMl1DVjzU6obuAt4d4i7mmi7Hef9Im7RjgEQV/AE11HPd1xtJazZvHp2Knd73IxoEYyNDHTdg8J0Q25YGi4RtZHviaeXTCazedAMdqvJe9dYHGsYFtcb/6Bx8aP6ckmVFKdfsP5ncKGcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Q5t28WBa; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-88a35a00506so117096d6.2
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 07:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769009999; x=1769614799; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q/gIihsafKtPWuGmVrtzbFv3/1+tW3nx1RJPQscpuso=;
        b=Q5t28WBauqxSIFFO+z3pNwgQL0CteOzJh7gunoIJsoVQL41CI5Ms5EFVC12yVCJIki
         wUj4Nf7GaOCTspAuxB2YbS8hnkgpPKC5/HIV2zEDfzxeku3sNbmfi88lUA3HzkbGpHhi
         G2KC9gggYU9TXLUTfA9o8XhIfXHTWJaFKKm4LpUnJ4ZPgQUogL2NXyRC+LFrIK6j5Hdh
         dyYtaQKro+wGKQmTci2PvDRdnBG3XSmfEdjMxCvk2zH27NanfqifB1XEdGDKSLkB37TB
         HcDKtZ0OHi6B41p6oD7ox4hhwtHtoc6LH1caz/H885T9uQT1KBKth1/+MJngzdbDuIRl
         1RDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769009999; x=1769614799;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/gIihsafKtPWuGmVrtzbFv3/1+tW3nx1RJPQscpuso=;
        b=CKpVAbce4+vilZKYo3MMBpYhCAnYLQKFAbqgRIM9MBMX4+knrw+7+3U4ihA1CgeO7D
         7R6SMpQSOlhVNO5yt1VSttP0HW3o4QJJpbeTy+P6ecDMsxt2DNOJBW3bMfHMMVGg9R3f
         U/HlfH8W3uaQkxWy2LwhsRzi2UhVjLPqfl3l57uNYN6KqzV6jykeRd7cBn3z7Ey4b/Qw
         3+WZD7aE3NCTNWFpm2H5aEFu455fSeok1+yVlO2/3NRwCgAfprHHY7nEA4z5D10lsKol
         k+6JlVxGEuuhHXtu05jVGXILxDyo5EgtL61+1VEbUDgBDnFKdjKhXEjX84Jg40yp+9Uz
         f33w==
X-Forwarded-Encrypted: i=1; AJvYcCWVqg3p65lpJuXKOPkARoTjIPC0u3jdcnSYnVLCugCY94L5j9kYRQwfr9xbdCCexI0h0Vo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxQEx/ifxmsUw+cRf6RxhJU1Ig6C1DKN6zKC44eltqm24/uw7/
	30pD3wV/6T72J4+vjLl1DfzylVMuhvIw76P371jxvbDobJeyL9Cgo8V5wBZjJ1gUdTE=
X-Gm-Gg: AZuq6aKyK7rdKF3poAPOoPjT9bCmg++IQqbTM3Q3+tfo5pzZN1md/s9ZfHpsHT+aB76
	vub1Mn7ExKHuUcU9cjXd0JugdWOO9Mp/nPgE39QnYsph6tjxjo9QixKS/ZuSUPzQ98YQKJuKtLR
	c1eZYHXfngzC+7yTlnrHC1C6pU9kOqo0oaHzwxlg7NfiRoCxvE6kfpq08eCF5JujQnOtOvxefcL
	QVi1Wlk+q9bc+CjAT4GC6cIKFfPgZZMlUUYSlXOTb28qQeS2teN3lEDOuKkPXarzXfyUFgwkz8F
	ZoXFGICtOa9+FAIuRlIglqMIRZh9p66QsXZiOMybWSBDzdXTM8VZw6voTJzPhCmQsMyQ/NFo0gd
	X7uhg3NSs1K/HOhLe5Kvp1QYD7mqaRymJdWCj8/F954wfxMIrhgx0eUU4fvxoMmky6bE1EccPMW
	E8PoZVPZKRY2Xhn7f7CG3O7zkoxff1Z0VTgS5LgHPDfC1/K0YU9hpDgRN5NJISTmuOSeY=
X-Received: by 2002:a05:6214:469b:b0:894:3cde:f81e with SMTP id 6a1803df08f44-8943cdef85amr237172426d6.41.1769009998640;
        Wed, 21 Jan 2026 07:39:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894592ba642sm58791866d6.57.2026.01.21.07.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 07:39:57 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viaJJ-00000006EiI-13u3;
	Wed, 21 Jan 2026 11:39:57 -0400
Date: Wed, 21 Jan 2026 11:39:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/7] dma-buf: Document RDMA non-ODP
 invalidate_mapping() special case
Message-ID: <20260121153957.GC961572@ziepe.ca>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-3-b7e0b07b8214@nvidia.com>
 <4fe42e7e-846c-4aae-8274-3e9a5e7f9a6d@amd.com>
 <20260121091423.GY13201@unreal>
 <7cfe0495-f654-4f9d-8194-fa5717eeafff@amd.com>
 <20260121131852.GX961572@ziepe.ca>
 <8a8ba092-6cfa-41d2-8137-e5e9d917e914@amd.com>
 <20260121135948.GB961572@ziepe.ca>
 <8689345b-241a-47f4-8e9a-61cde285bf8b@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8689345b-241a-47f4-8e9a-61cde285bf8b@amd.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68743-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 26ED459F91
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 03:15:46PM +0100, Christian König wrote:
> > And let's clarify what I said in my other email that this new revoke
> > semantic is not just a signal to maybe someday unmap but a hard
> > barrier that it must be done once the fences complete, similar to
> > non-pinned importers.
> 
> Well, I would avoid that semantics.
>
> Even when the exporter requests the mapping to be invalidated it
> does not mean that the mapping can go away immediately.
> 
> It's fine when accesses initiated after an invalidation and then
> waiting for fences go into nirvana and have undefined results, but
> they should not trigger PCI AER, warnings from the IOMMU or even
> worse end up in some MMIO BAR of a newly attached devices.

So what's the purpose of the fence if accesses can continue after
waiting for fences?

If we always have to wait for the unmap call, is the importer allowed
to call unmap while its own fences are outstanding?

> So if the exporter wants to be 100% sure that nobody is using the
> mapping any more then it needs to wait for the importer to call
> dma_buf_unmap_attachment().

We are trying to introduce this new idea called "revoke".

Revoke means the exporter does some defined sequence and after the end
of that sequence it knows there are no further DMA or CPU accesses to
its memory at all.

It has to happen in bounded time, so it can't get entangled with
waiting for userspace to do something (eg importer unmap via an ioctl)

It has to be an absolute statement because the VFIO and RDMA exporter
use cases can trigger UAFs and AERs if importers keep accessing.

So, what exactly should the export sequence be? We were proposing to
call invalidate_mapping() and when it returns there is no access.

The fence is missing, so now the sequences includes wait for the
fences.

And now you are saying we have to wait for all unmaps? Not only wait
for the unmaps, but the importers now also must call unmap as part of
their invalidate_mapping() callback.. Is that OK? Do existing
importers do that?

If all the above are yes, then lets document explicitly this is the
required sequence and we can try to make it work. Please say, because
we just don't know and keep getting surprised :)

Thanks,
Jason

