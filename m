Return-Path: <kvm+bounces-68735-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kIxlN6L1cGmgbAAAu9opvQ
	(envelope-from <kvm+bounces-68735-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:49:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F555976A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 16:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 104CBA4C04E
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4552494A1D;
	Wed, 21 Jan 2026 14:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqhQkB0H"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE504949E8;
	Wed, 21 Jan 2026 14:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769005914; cv=none; b=p9qyc78i0CtCIOusEQTzUg87wRaS+IAir1SXxjRRdcHmFJhR85xEWqJm9mKaCezs5zpL4x0TjsNgDiidDJ/TGlHPhet0dKknF+PXtpcBxXIfCiUIxKDIzsfpsITs0GDdATM4X2EqLIN67IKQOBuCFFxDc+ZfTYMBWvB4Pj4XfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769005914; c=relaxed/simple;
	bh=PeR5g4KP8x/lJhIeGe2dDKX2Op8R7HIZRzZ9ayHsJco=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AslVuI0aRbLVvFM9DRUeEnTvhQrw03T6UfGosytyPJjlGJJHUPfeMvJLOLsS5ChyAlD6ypgSPyEZ5BanW+jlilpZjPVLmVe1dIdEraMEst6Qk+ArM7E/BVH5QHezpJCL6RLva21cm0HHhdik+lxhNd2+NF14ma7syZFzYSTyFFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqhQkB0H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2629C4CEF1;
	Wed, 21 Jan 2026 14:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769005914;
	bh=PeR5g4KP8x/lJhIeGe2dDKX2Op8R7HIZRzZ9ayHsJco=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqhQkB0HZ1m+DKmEb4iOkwxeDGvAPNkuGn61XTxaCqhuL9qVbUQfxtrTwPujoAdVb
	 VrWiUmPtEeUvE9nGyKANKxMoUIMS0e5nHQ31T+VEQXUu37yer/5Hzj5XuurNOilyo2
	 +YYGfaIa3Dbj0S4Qd6g3VaXA17/1wzg6rpzqnlrG4nsV8pQRcJ1G7Oj+N6BLxO/rpy
	 nVcDdV+4eAHtYRPFNU2TGJOODjbr6a9NoxnTowpmmzFAyZbPWVMuabJ0YV3hjf1iNz
	 8aDY8IqPHmmGAsQTtHkqpxZzOBU4w+H2paxEDwGUBatWmmBD4eAn1X2NjKOH85/uBz
	 eYXBSWhDgDLeQ==
Date: Wed, 21 Jan 2026 16:31:50 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Sumit Semwal <sumit.semwal@linaro.org>,
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
Message-ID: <20260121143150.GD13201@unreal>
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
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8689345b-241a-47f4-8e9a-61cde285bf8b@amd.com>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68735-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[ziepe.ca,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 85F555976A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 03:15:46PM +0100, Christian König wrote:
> On 1/21/26 14:59, Jason Gunthorpe wrote:
> > On Wed, Jan 21, 2026 at 02:52:53PM +0100, Christian König wrote:
> >> On 1/21/26 14:18, Jason Gunthorpe wrote:
> >>> On Wed, Jan 21, 2026 at 10:17:16AM +0100, Christian König wrote:
> >>>> The whole idea is to make invalidate_mappings truly optional.
> >>>
> >>> But it's not really optional! It's absence means we are ignoring UAF
> >>> security issues when the exporters do their move_notify() and nothing
> >>> happens.
> >>
> >> No that is unproblematic.
> >>
> >> See the invalidate_mappings callback just tells the importer that
> >> the mapping in question can't be relied on any more.
> >>
> >> But the mapping is truly freed only by the importer calling
> >> dma_buf_unmap_attachment().
> >>
> >> In other words the invalidate_mappings give the signal to the
> >> importer to disable all operations and the
> >> dma_buf_unmap_attachment() is the signal from the importer that the
> >> housekeeping structures can be freed and the underlying address
> >> space or backing object re-used.
> > 
> > I see
> > 
> > Can we document this please, I haven't seen this scheme described
> > anyhwere.
> > 
> > And let's clarify what I said in my other email that this new revoke
> > semantic is not just a signal to maybe someday unmap but a hard
> > barrier that it must be done once the fences complete, similar to
> > non-pinned importers.
> 
> Well, I would avoid that semantics.
> 
> Even when the exporter requests the mapping to be invalidated it does not mean that the mapping can go away immediately.
> 
> It's fine when accesses initiated after an invalidation and then waiting for fences go into nirvana and have undefined results, but they should not trigger PCI AER, warnings from the IOMMU or even worse end up in some MMIO BAR of a newly attached devices.
> 
> So if the exporter wants to be 100% sure that nobody is using the mapping any more then it needs to wait for the importer to call dma_buf_unmap_attachment().
> 
> > The cover letter should be clarified with this understanding too.
> 
> Yeah, completely agree. We really need to flash out that semantics in the documentation.

Someone knowledgeable needs to document this properly, either in the code  
or in the official documentation. A cover letter is not the right place for  
subtle design decisions.

Thanks

> 
> Regards,
> Christian.
> 
> > 
> > Jason
> 

