Return-Path: <kvm+bounces-68746-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLoFGsX9cGmgbAAAu9opvQ
	(envelope-from <kvm+bounces-68746-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:24:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CDEF259D97
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 17:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 38319ACAA43
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1737047ECEC;
	Wed, 21 Jan 2026 15:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t97wEG8R"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34D73EDABE;
	Wed, 21 Jan 2026 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010386; cv=none; b=NWgsexj5dyZXrtSo7eYIfQN9IG6GMMbRPj8ymAuiExXSPWImbrSUEGUAhfPZJmsi/XuHiCR5CNpjXneevE6/z1677cuKi02g5koLtcDYamDdZSd7SOVjAm4T2xIqU/EFxZx4LPwThIPIdManrFKvWCYfNSwgKAFn0S6HKhyPd2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010386; c=relaxed/simple;
	bh=wsp0Ee/Wyi7vSUVwVM1dt7Rh8gLnheehWV+BoZfOvsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SyWr7/l1IZXmovXzKQYUroo1D0jFTB9VcAQzwtEQFmgM+qKXbhZB7w9jX8PRNrl6ITubqUBgp987SR+IodRgr8pQS/DkqNJKm99isiCh6bHvMu+1y633XEI0NlaMmVM2l6XXA6yJMttwYsDcu/0ebNrXUQT8gdvWVyZaUQPlVfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t97wEG8R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79C7C4CEF1;
	Wed, 21 Jan 2026 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769010385;
	bh=wsp0Ee/Wyi7vSUVwVM1dt7Rh8gLnheehWV+BoZfOvsU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t97wEG8R3Vclg+HjbADh6Re31LoTY+IEQ//+/mnlWg1SY0DWWznX+wkzufS/8RTPw
	 cFRK4kAf7NSHmPyBgCi82jqY7mcIsr1SPIUA+DfGH+0sVbcGIIjaD3E9NvDWdaGQVx
	 LdTOIbm0sfpJbWGFzlKIoFrPX2a1YPoLdupT/uZEE8P5zTY/Y9osGFW/VyLT82WWgJ
	 TZMQRbM9NUBS2Upq18HxU+6bzyq7clPDWPDeMzkHTDGuxQmBCpWoxQ0JRBZ6ihl7MC
	 pISuKsiX5PxQGXQHWql6x3YzR56jEtvSfhu2oH2477i9lN+U+568UYrW9OFuumSVq0
	 ES+FsrOJCjoVw==
Date: Wed, 21 Jan 2026 17:46:21 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>
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
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] vfio: Validate dma-buf revocation semantics
Message-ID: <20260121154621.GH13201@unreal>
References: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
 <20260121-dmabuf-revoke-v4-8-d311cbc8633d@nvidia.com>
 <20260121134712.GZ961572@ziepe.ca>
 <20260121144701.GF13201@unreal>
 <20260121154137.GD961572@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121154137.GD961572@ziepe.ca>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68746-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,8bytes.org,arm.com,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
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
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: CDEF259D97
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 11:41:37AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 04:47:01PM +0200, Leon Romanovsky wrote:
> > > We need to push an urgent -rc fix to implement a pin function here
> > > that always fails. That was missed and it means things like rdma can
> > > import vfio when the intention was to block that. It would be bad for
> > > that uAPI mistake to reach a released kernel.
> > 
> > I don't see any urgency here. In the current kernel, the RDMA importer
> > prints a warning to indicate it was attached to the wrong exporter.
> > VFIO also invokes dma_buf_move_notify().
> 
> The design of vfio was always that it must not work with RDMA because
> we cannot tolerate the errors that happen due to ignoring the
> move_notify.
> 
> The entire purpose of this series could be stated as continuing to
> block RDMA while opening up other pining users.
> 
> So it must be addressed urgently before someone builds an application
> relying on this connection.

Done, https://lore.kernel.org/all/20260121-vfio-add-pin-v1-1-4e04916b17f1@nvidia.com/T/#u

Thanks

> 
> Jason

