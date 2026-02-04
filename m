Return-Path: <kvm+bounces-70160-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iNEPFG4Kg2lbhAMAu9opvQ
	(envelope-from <kvm+bounces-70160-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:59:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B5334E36D4
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 09:59:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1DD38307180E
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 08:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A33D539E195;
	Wed,  4 Feb 2026 08:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7pTqA4L"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4CD1D63F0;
	Wed,  4 Feb 2026 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770195371; cv=none; b=Cn1MpzkQ6aHwO01ZaszC7iQ7QMqWuDpTT8HAXLAmJMYJLDX5SQvs3NxUUpuvAwU0Ju964uFgBtdm18LppXCRD9FiEmfIr2Ogt9++5EKrdkrgxOy3u1X78A54a9JNa0IY314nhy+IS+bnN+cz4OuFKxnUVdxsdpPxfDxT1XCxC8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770195371; c=relaxed/simple;
	bh=7OhNdyQd9Hj4JZ3WwzaaVRughLWneBid2/id9k15jgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCjnXeO6edTc6IH/YPy/kARgcXI+9G4w48iifL+KDtrObNgPgFjNsueT6esY9kJvd9kXWc8LH5GgxrCzDrGCVYwonG80w+0yJiOBTRwfajCsBf8yh7iD6WZWbQaX1Cbx1FFxu/u4nZUrBRF/6WIf/FjrLOqvL9NvS7Z+zqL94ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7pTqA4L; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAFAC4CEF7;
	Wed,  4 Feb 2026 08:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770195371;
	bh=7OhNdyQd9Hj4JZ3WwzaaVRughLWneBid2/id9k15jgM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V7pTqA4L9gw8RLNHTPQ3c3PmSmPUJN8CJLkSplhC/tA6rLyNs/ON8PEJ77FghkrYL
	 7YC7kC+vzUJczQux8gMcjkSltXZByy2k3Y/tn+IZTssRYphrNHoXV/inmhMNPSeTpq
	 /EElHDk0r2Fud4Ow8YLv+QLv1E77BycSs/6TXoM2dUc9VjGtgSPDYwYm8Ej4MLTHbO
	 elG6nwpwLEFKKVyCeZfL3VndxYrhjKHWPJEgy+OWK/3jRcIHqHo7MMa8eGJO5MfqPJ
	 iaudGOxgyj2Q+GiGdIWm2eFONDY0yvSNQsmD2v7LsLyMzax1HMUELlY3ibNKbudFUm
	 17VPZKFF1DiPg==
Date: Wed, 4 Feb 2026 09:56:08 +0100
From: Maxime Ripard <mripard@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Alex Deucher <alexander.deucher@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Gerd Hoffmann <kraxel@redhat.com>, Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
	Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Lucas De Marchi <lucas.demarchi@intel.com>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Felix Kuehling <Felix.Kuehling@amd.com>, 
	Alex Williamson <alex@shazbot.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204-icy-classic-crayfish-68da6d@houat>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal>
 <20260204081630.GA6771@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="md2hsdfsayzd7ozo"
Content-Disposition: inline
In-Reply-To: <20260204081630.GA6771@unreal>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-3.76 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70160-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[amd.com,linaro.org,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,ziepe.ca,8bytes.org,kernel.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mripard@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B5334E36D4
X-Rspamd-Action: no action


--md2hsdfsayzd7ozo
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
MIME-Version: 1.0

On Wed, Feb 04, 2026 at 10:16:30AM +0200, Leon Romanovsky wrote:
> On Mon, Feb 02, 2026 at 06:04:25PM +0200, Leon Romanovsky wrote:
> > On Sat, Jan 31, 2026 at 07:34:10AM +0200, Leon Romanovsky wrote:
> > > Changelog:
> > > v7:
> >=20
> > <...>
> >=20
> > > Leon Romanovsky (8):
> > >       dma-buf: Rename .move_notify() callback to a clearer identifier
> > >       dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_map=
pings()
> > >       dma-buf: Always build with DMABUF_MOVE_NOTIFY
> > >       vfio: Wait for dma-buf invalidation to complete
> > >       dma-buf: Make .invalidate_mapping() truly optional
> > >       dma-buf: Add dma_buf_attach_revocable()
> > >       vfio: Permit VFIO to work with pinned importers
> > >       iommufd: Add dma_buf_pin()
> > >=20
> > >  drivers/dma-buf/Kconfig                     | 12 -----
> > >  drivers/dma-buf/dma-buf.c                   | 69 +++++++++++++++++++=
+-----
> > >  drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 ++---
> > >  drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
> > >  drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
> > >  drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
> > >  drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++-
> > >  drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
> > >  drivers/gpu/drm/xe/xe_dma_buf.c             | 14 ++---
> > >  drivers/infiniband/core/umem_dmabuf.c       | 13 -----
> > >  drivers/infiniband/hw/mlx5/mr.c             |  2 +-
> > >  drivers/iommu/iommufd/pages.c               | 11 +++-
> > >  drivers/iommu/iommufd/selftest.c            |  2 +-
> > >  drivers/vfio/pci/vfio_pci_dmabuf.c          | 80 +++++++++++++++++++=
+++-------
> > >  include/linux/dma-buf.h                     | 17 +++---
> > >  15 files changed, 153 insertions(+), 96 deletions(-)
> >=20
> > Christian,
> >=20
> > Given the ongoing discussion around patch v5, I'm a bit unclear on the
> > current state. Is the series ready for merging, or do you need me to
> > rework anything further?
>=20
> Christian,
>=20
> Let's not miss the merge window for work that is already ready.

The cutoff date for the merge window was on 25/1, so it was already
missed by the time you sent your series.

Maxime

--md2hsdfsayzd7ozo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaYMJowAKCRAnX84Zoj2+
djVFAX4o65eZLnv9pSuBC/f19F9Wa+5AV3tbnVDyNWy7aEVTPVlpkwyBh3kSx24f
CiGuWJUBgMDxh0mGTwKw1M4dapaGNtVEhWvE/mj7fWyRzk3l536hontO+fVSQspp
IjEjywqm8A==
=TNrj
-----END PGP SIGNATURE-----

--md2hsdfsayzd7ozo--

