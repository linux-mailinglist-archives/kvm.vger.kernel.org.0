Return-Path: <kvm+bounces-69171-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gLD4EhrRd2mxlQEAu9opvQ
	(envelope-from <kvm+bounces-69171-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 21:39:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B92BB8D279
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 21:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7F0C7303BB3E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 20:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C352D7D30;
	Mon, 26 Jan 2026 20:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ENqilvO3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7234C296BDC
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 20:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769459936; cv=none; b=kNJPlZfs8KtI/cYO8nNOnU2eAzI2HL77Szd0LRyxHVXk3/2mQrcNENldJXvlE9Tmnjm6kQR9NWDHjc0nXqli7z3amB/TXP/Ymh/ItXRm+dIxi5dsA3SVDsDcTNdLDcjQlg/xj5feM8uQTgs5QsGE9UcKF2FB6i19F+xn3qUpbP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769459936; c=relaxed/simple;
	bh=ReePk5ebIABc/04zyOJasPQOtiwxWbIgDXrD19pnIPk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QaEMmPtzZYEQn7bS+C3HwuHYQolK6xzSIR6Pcu+gqB8PpVqv6lEGFnkISlaKYyaf1Qfhx2KfiD1ODwjs6XLME9g6GYnfdy9So3x6d24BLSGwSYiSf92AyXiraWEqK/djQZk+kFdKqLY1ylP4iyBi5wlfYsupM2rnlJziALxZnwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ENqilvO3; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a35ae38bdfso1715ad.1
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 12:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769459934; x=1770064734; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=heQW4XXGxVNpbsMWtr+Uf/Qjg2mRHLgzAq6EBq5z5Gc=;
        b=ENqilvO3yHNYxJOrBt3JSHu/J1ym8/v63iMpFaPstmn1DAgs606o/DB+mBzpFxEeO4
         mohiD/SGVtJmpSrM1Um3Uz5WFoMGhwv8VYIvdp9vHnqkLUAiCSwOzDJMdpFvLlQwEawE
         NyW9CXTGGNWOEbu4Xic/wTW/zxHCU/rTDwazPY8QzsPhaZzwAsSF5cFhP+j2tyetkWG+
         IFRScGqMdHZgIk2wdOipjZt8NNqMkKn5+PlhwWoLAmiyDVFtyiHJD4r91ODEuEHKnuZy
         f/uat5iPozNN1IMlQWUW+KioXuNyTZG/tPWXb7hCNRp4oiEKLBlrW/l/9Pe+iVJCD7Nc
         WtXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769459934; x=1770064734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=heQW4XXGxVNpbsMWtr+Uf/Qjg2mRHLgzAq6EBq5z5Gc=;
        b=Fsu+5EqpJ6JDC0GwREHth0HVrNVwcbgwnn92z5tp+xQ5qTnE//XU3mui15nicHlVQN
         WDZvHfbruF7pgKfw5k1DBMRRtWWxsRV6a5AZIt8yswJQXFYdVf5dqH6llxk/s6fIE+2S
         QNDztFmVn/fEz2w89uYK9J+RmOCFxxsdRC1h5pntQAXqvKQIyW6Kz5MJwh9saN+6ruG0
         QmJ316NamJKaZcDwdIA6mMzR1OpKsyPbpBMnGUjZ1QMdHIkQxJYgqLjdjhi/EYIZLM1E
         M6knJitJIPYNk9FMAajMs6eX/BjKtiCJwkscWGKWbM+gtuR/NIJk4lgv6In15JcnYEuF
         XtSw==
X-Forwarded-Encrypted: i=1; AJvYcCUDGLE6tOMCvNCm/XX9IRu9+A43WyYg6N0qCD+ANb2aJLDOvZwUhSwXpHucU/bB/oShIE0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgsrEqZcLwtiTKzmy+/KnqQNQm0Es1r/JbOdy12S3hr/rXaUI+
	E04rnap8vN8MQNSoVoTaJo0m6+gvXmP+QqzzbkqQxs6JhPoYD8Tfz/K5ZwqVa4h3Fg==
X-Gm-Gg: AZuq6aLlQPavy2ORRKBiWL268+XrOpooeqlJN8/eFyQsCQAliMbestBa0s0I2aB1zU0
	81yheBvcCPmWO5TX0vb8rYfzD/b6oC9hqdWBeoZHIKzbs6ewshXS0Zj3dLhA2BtZbRUlzcooUCV
	Jf720KkfIUUuw2i16SPKXomylgpEm4Ck2qbGw4rYMLXdWxdra0O4kNSKEnmEv4yJP7iVm1tPGDf
	Gz+Y7yYjpOlOUQcgnB1fjBbPJWQDMPXHb/GYqBYUQGK8GvH1OxSp/I18NyMbBpj3GEBXEqQJs8B
	QG/TuTOyQ7bJqniz9Y5+LT3eI/JmZ4I9ivNa2zTgLupxUzGLIj9plnz37XSTifSL4J9bHH01CLX
	v2MeQkDEN/dosuBz8yMT3X6+M/yeu2NVg8flgFA8idDIdt3uZfFNhxgHRhQDfzvWF3531+OtRAk
	jumaBVO3Pw0IRYAXsslFyMxZVsqVuARA2mD4KericzUWKjAcze
X-Received: by 2002:a17:903:32d2:b0:2a7:7f07:340e with SMTP id d9443c01a7336-2a844901809mr3288195ad.4.1769459933510;
        Mon, 26 Jan 2026 12:38:53 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fdce1fsm94536115ad.101.2026.01.26.12.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 12:38:53 -0800 (PST)
Date: Mon, 26 Jan 2026 20:38:44 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <aXfQ1LFNDUrfeuHf@google.com>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-6-f98fca917e96@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260124-dmabuf-revoke-v5-6-f98fca917e96@nvidia.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-69171-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_TWELVE(0.00)[35];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[praan@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: B92BB8D279
X-Rspamd-Action: no action

Hi Leon,

On Sat, Jan 24, 2026 at 09:14:18PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Some exporters need a flow to synchronously revoke access to the DMA-buf
> by importers. Once revoke is completed the importer is not permitted to
> touch the memory otherwise they may get IOMMU faults, AERs, or worse.
> 
> DMA-buf today defines a revoke flow, for both pinned and dynamic
> importers, which is broadly:
> 
> 	dma_resv_lock(dmabuf->resv, NULL);
> 	// Prevent new mappings from being established
> 	priv->revoked = true;
> 
> 	// Tell all importers to eventually unmap
> 	dma_buf_invalidate_mappings(dmabuf);
> 
> 	// Wait for any inprogress fences on the old mapping
> 	dma_resv_wait_timeout(dmabuf->resv,
> 			      DMA_RESV_USAGE_BOOKKEEP, false,
> 			      MAX_SCHEDULE_TIMEOUT);
> 	dma_resv_unlock(dmabuf->resv, NULL);
> 
> 	// Wait for all importers to complete unmap
> 	wait_for_completion(&priv->unmapped_comp);
> 
> This works well, and an importer that continues to access the DMA-buf
> after unmapping it is very buggy.
> 
> However, the final wait for unmap is effectively unbounded. Several
> importers do not support invalidate_mappings() at all and won't unmap
> until userspace triggers it.
> 
> This unbounded wait is not suitable for exporters like VFIO and RDMA tha
> need to issue revoke as part of their normal operations.
> 
> Add dma_buf_attach_revocable() to allow exporters to determine the
> difference between importers that can complete the above in bounded time,
> and those that can't. It can be called inside the exporter's attach op to
> reject incompatible importers.
> 
> Document these details about how dma_buf_invalidate_mappings() works and
> what the required sequence is to achieve a full revocation.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/dma-buf/dma-buf.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/dma-buf.h   |  9 +++------
>  2 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 1629312d364a..f0e05227bda8 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -1242,13 +1242,59 @@ void dma_buf_unmap_attachment_unlocked(struct dma_buf_attachment *attach,
>  }
>  EXPORT_SYMBOL_NS_GPL(dma_buf_unmap_attachment_unlocked, "DMA_BUF");
>  
> +/**
> + * dma_buf_attach_revocable - check if a DMA-buf importer implements
> + * revoke semantics.
> + * @attach: the DMA-buf attachment to check
> + *
> + * Returns true if the DMA-buf importer can support the revoke sequence
> + * explained in dma_buf_invalidate_mappings() within bounded time. Meaning the
> + * importer implements invalidate_mappings() and ensures that unmap is called as
> + * a result.
> + */
> +bool dma_buf_attach_revocable(struct dma_buf_attachment *attach)
> +{
> +	return attach->importer_ops &&
> +	       attach->importer_ops->invalidate_mappings;
> +}
> +EXPORT_SYMBOL_NS_GPL(dma_buf_attach_revocable, "DMA_BUF");
> +

I noticed that Patch 5 removes the invalidate_mappings stub from 
umem_dmabuf.c, effectively making the callback NULL for an RDMA 
importer. Consequently, dma_buf_attach_revocable() (introduced here)
will return false for these importers.

Since the cover letter mentions that VFIO will use
dma_buf_attach_revocable() to prevent unbounded waits, this appears to
effectively block paths like the VFIO-export -> RDMA-import path..

Given that RDMA is a significant consumer of dma-bufs, are there plans
to implement proper revocation support in the IB/RDMA core (umem_dmabuf)? 

It would be good to know if there's a plan for bringing such importers
into compliance with the new revocation semantics so they can interop
with VFIO OR are we completely ruling out users like RDMA / IB importing
any DMABUFs exported by VFIO?

Thanks,
Praan

