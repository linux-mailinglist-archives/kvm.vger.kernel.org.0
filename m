Return-Path: <kvm+bounces-69173-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHrMJynWd2mFlwEAu9opvQ
	(envelope-from <kvm+bounces-69173-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:01:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 661C78D6D6
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:01:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EC3D23008995
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 21:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3522F2DEA68;
	Mon, 26 Jan 2026 21:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="V9H7+3Id"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A722DC76E
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 21:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769461273; cv=none; b=EglPN3+IVWMDWbWPK/3QoYQrMPnX1WNvXSNtet//4ZczrTVn/ho149Rpcew/Z/0eP7O45B99cuv3PHxkISP48IAZ6FqsJYiXBuv1flrJUDDAQWkctv1Q4cUvccY/e2LZjOtX62J4BabDr4IlmGmoMd6XNQrIH5XPA/Sd+fgl2+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769461273; c=relaxed/simple;
	bh=/uBBJ41PsJ+poHfkbr45RI19WGdtV1Pwu8dAjRjrE+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MPn2q2yFXD2urHYCmKUOaQFrf1Wzuz8RGUhoSGA5hqXk7lOvFFaWnJlN2pxOV3L9rEDJqeoTYt4LZDvj2q1A3N41/tvKkrMFH1bd2zoneiGkbGHecnpSEqMCUMv7xGHfDccNow/TGHZNToA71B9f9vIk6C91v9r7Jfb4WZeHLxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=V9H7+3Id; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-89461ccc46eso89763046d6.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 13:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769461271; x=1770066071; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Tu3uAyHuSXXXZq6VSWtVG72sHh/RWKg7/MHSYDvcONg=;
        b=V9H7+3Idk+sIAFevqUXVEpK+mTKlHABOW2S+GVajpGNFMc/qDA2vun05ep798kV5FS
         vViiO1MjGIWm2dRrzxCLj309UMGTSn61IQzvd+aiZMmQK6dD7ydt7quMEH0p8V4avKRd
         CXYlVfypwhbGaxaXUZmin/cwGOfH2a2VJvZhJf6x+Wqa2VLUYgYdS0tASsE/k8YZ/55P
         YaL6RaFesydc1hGo1u3yPbBe3TTIMy70Bgm7r8sTloVNQYE+tiCoVCK/kgmGjpKTocwj
         xo9M6WJA8jeIHXUkbI3Hw3PlZV7XoSBOozkqXNQuARwhrRXzCEdDhqnrk6bwnYj+1qj1
         Fp/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769461271; x=1770066071;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tu3uAyHuSXXXZq6VSWtVG72sHh/RWKg7/MHSYDvcONg=;
        b=UIS45zAkIgEQFQ120mL0YMGiPitHXeFooedVQCNcptNmFHUhozUoyZ5e+CWwUYXBtI
         PX9C6OvAH2EvffV0xrtxMfkHY916GWkOzR2ZxenKCreIicUlkZ6zqnNzd5Uw3a5mdy9H
         Qhj77303qASQwgv5dHv+uXeIJlWNrSo+ZdzROYkj8hkunhvbvhkfVcttE5RggAbv3SPY
         mkzHKsslfnc2d81WpTUatB9rjWA/dMQFQzABqhV1cvG5XFkiSFlAhd9UoQ31+Q6HzDCo
         JSSL6ITg44RDOzl46y3AzsVz5m73M6aTbdJ0UGrMtwnfyUSoVywHDaOmaeF9zrMdxMCJ
         8+FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUN9+nD45UfW1uiiLhwDXjZPSSraYOnSYOpXE4K6VOIfzbUvjcVlSkHTCxx+Vjyy8b7Vrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHZQhg5lbfpnM7t2NhqCyMY3wMPnkTG4EHSPsgsAm3z71XfGOx
	cFGjDagY0iSpmkd0h/jglwn6L23ycCQnbJc7T1qjWxVQZU659HCDbORTIE3r2+CypDs=
X-Gm-Gg: AZuq6aInWb5BeEei1aUUXj5QW3spbjFyKw5G/H4cAiF3eu7BM9JQo8XuxQNV/FHVpH6
	uMRuZUEu3LrnGuErdzODhemf1aJgFh66nnclWIruPWYbSgC5Zp2Z54S2vY2xNbJdf6zBkwr9DbD
	7pL7WqpoPSLQemITcDneGujn3fwkk/feYgyZsLrSvGA1tc+lqfApLA4r+09MTdgjPuznEdciae0
	D1/rF8la7v1s4pV5l2kjIAufWqag+0pYauvQxZJTac4zUnaqKOegBnlJsSeyuMFyTuAXFnFpupp
	WivWEuOAJX46KjVFDqONwAAr4tmx9AwOlj1x98386eQ0ZgtG/VDE+7ly28+6MT4IhGmIFFpoI/B
	IL7eIhF013AaHk6f6betdrO1iEnyWJc96wXH7XGj70wgGLpjnuU2WTTVpnduGz+tHuZr8Uv8EXL
	+pWzibBS8eIZyi1G/RSwa4we9xTtjfr6HTnrCgtl3qlJihowFjIjssNDYWeZuFvsAQkpo=
X-Received: by 2002:a05:6214:1cc9:b0:894:7b34:dacd with SMTP id 6a1803df08f44-894b06f336dmr73487126d6.31.1769461270245;
        Mon, 26 Jan 2026 13:01:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894918b1436sm104983856d6.35.2026.01.26.13.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 13:01:09 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vkThs-00000008z30-31vX;
	Mon, 26 Jan 2026 17:01:08 -0400
Date: Mon, 26 Jan 2026 17:01:08 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pranjal Shrivastava <praan@google.com>
Cc: Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
Subject: Re: [PATCH v5 6/8] dma-buf: Add dma_buf_attach_revocable()
Message-ID: <20260126210108.GD1641016@ziepe.ca>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-6-f98fca917e96@nvidia.com>
 <aXfQ1LFNDUrfeuHf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXfQ1LFNDUrfeuHf@google.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-69173-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 661C78D6D6
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 08:38:44PM +0000, Pranjal Shrivastava wrote:
> I noticed that Patch 5 removes the invalidate_mappings stub from 
> umem_dmabuf.c, effectively making the callback NULL for an RDMA 
> importer. Consequently, dma_buf_attach_revocable() (introduced here)
> will return false for these importers.

Yes, that is the intention.

> Since the cover letter mentions that VFIO will use
> dma_buf_attach_revocable() to prevent unbounded waits, this appears to
> effectively block paths like the VFIO-export -> RDMA-import path..

It remains usable with the ODP path and people are using that right
now.

> Given that RDMA is a significant consumer of dma-bufs, are there plans
> to implement proper revocation support in the IB/RDMA core (umem_dmabuf)? 

This depends on each HW, they need a way to implement the revoke
semantic. I can't guess what is possible, but I would hope that most
HW could at least do a revoke on a real MR.

Eg a MR rereg operation to a kernel owned empty PD is an effective
"revoke", and MR rereg is at least defined by standards so HW should
implement it.
 
> It would be good to know if there's a plan for bringing such importers
> into compliance with the new revocation semantics so they can interop
> with VFIO OR are we completely ruling out users like RDMA / IB importing
> any DMABUFs exported by VFIO?

It will be driver dependent, there is no one shot update here.

Jason

