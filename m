Return-Path: <kvm+bounces-71610-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GMm8Fjd+nWk/QQQAu9opvQ
	(envelope-from <kvm+bounces-71610-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:32:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCF2185680
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:32:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BF9AA30EDB35
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ADEA37883C;
	Tue, 24 Feb 2026 10:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJc65pZF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76CC11EDA2C;
	Tue, 24 Feb 2026 10:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771929065; cv=none; b=V6AnBe4hesNV9ObEqFs42C3ChOKo/eiQ8uEiR1iQHpTmN0oFWzFmxe893ZzOxmGbH/XCgWgojuLqSXSAIMewzFI1XjBwc5Dpf6O72y9Pq3+tENjmaDWagguz0/qtPoPYkrL7c9OheXKoRQJYSkDw5I7v3bmg0N8p9YLML7C/2eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771929065; c=relaxed/simple;
	bh=oUwk8VP9X5cwOfy2FaQDDjO2Cz9u/z4sh5gcdr9Ylx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0OGM9SetIB6tljaFErOY6nRpA6M90yWnBtW5OYoJtbdIO1lid0FuWvc7LMUU40RieZ+Big4ggz5jxKtYoXsBUjgeVvUQPsmBelZOAawFHbbw0piEJK6R25U4Cqq8Jp3xQ8WCe+k+Qrm+uKlGJA1K3Cy5xy9w576vgLvCq5KOTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJc65pZF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACDBC116D0;
	Tue, 24 Feb 2026 10:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771929065;
	bh=oUwk8VP9X5cwOfy2FaQDDjO2Cz9u/z4sh5gcdr9Ylx4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XJc65pZFDlsZzYhzthM1hMrgBmoCoDRrZXYo8ZXGTAAiBaqdsf54Np++GWVGUvvoC
	 0pz/rfohc9lRY0RXJZTvHS/qyGw1ZIQlbsTLz8o6hbr9L1i1oy38rqutgO1Vtkev1P
	 22Ja3XtxWP2KCAqX6CuVF3QkH2KcHrQmkBWxN/x0LNnjG/w4SmjNdg0hPTz/QWKqnd
	 EYlZikYgFjCRULv1KP5Hc0VEhvcUA7HQy0+e8SoPqrOHViszFP7Cz1dPBVb51eF1ID
	 UDGPuaUrmTI6Zm3YKLWvQRYb44/p19BnjdaCM9HsM/uE64YeFqJkcb69ZxSsCwof5d
	 3PKIpr1BPzk7A==
Date: Tue, 24 Feb 2026 12:31:00 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Simona Vetter <simona@ffwll.ch>, Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260224103100.GI10607@unreal>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260217080206.GJ12989@unreal>
 <0aa8147c-254d-4a1c-89ee-9dc4d4b6b022@amd.com>
 <20260217133431.GN12989@unreal>
 <90088594-5835-4f4f-9e69-aaee67109aa1@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90088594-5835-4f4f-9e69-aaee67109aa1@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71610-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,linaro.org,amd.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1BCF2185680
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 07:55:15PM +0100, Christian König wrote:
> On 2/17/26 14:34, Leon Romanovsky wrote:
> > On Tue, Feb 17, 2026 at 10:52:25AM +0100, Christian König wrote:
> >> On 2/17/26 09:02, Leon Romanovsky wrote:
> >>> On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
> >>>> Changelog:
> >>>> v7:
> >>>>  * Fixed messed VFIO patch due to rebase.
> >>>
> >>> <...>
> >>>
> >>> Christian,
> >>>
> >>> What should be my next step? Should I resubmit it?
> >>
> >> No, the patches are fine as they are. I'm just waiting for the backmerge of upstream to apply them.
> 
> And pushed to drm-misc-next.
> 
> There was a minor merge conflict in patch #5. I think I fixed it up correctly, but only compile tested the result.

You resolved it correctly.

> 
> Would probably be good time to now test drm-misc-next if you have some userspace test cases.

Sure, thanks a lot.

> 
> Regards,
> Christian.
> 
> > 
> > Thanks
> 

