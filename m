Return-Path: <kvm+bounces-68529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB317D3B4C4
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 18:46:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1771630ED42D
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 17:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E3432B9A9;
	Mon, 19 Jan 2026 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A7Kh/x2F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE90F288515;
	Mon, 19 Jan 2026 17:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768843467; cv=none; b=sgn435CnqZkE6h1BI4yk8+4uja7WL5VXBAudD1Z/8xFZw9g88H/qFuJrg48eboPx1JXsJ8Gv/M5ASGuBhThdAuYNIS23mdDSP8wWtqjQgpaWa+mrSI+0IvIOgTRJS6YO/3vyONXiC6dwdOlNvyKMVg0KSHEbDChLFhkehw6wyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768843467; c=relaxed/simple;
	bh=qk3XuufPPEIck/9A121yktRTMzQ3kk4TF/duoWERK0Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M7H4V4OY/8k5rAgHiBdQOFeYWt/5jklw3an6Kkat0Be8ciOPhzicO2ccs51iZ+L56IQJtPcYQCRPCGEbo9kq5x01ZRVHcCuLdK0l9QOuKX+0PmetjMGD3t6LOkO7D1QilOpEKUWVDHQ8nmamVWvU+U9IvT08zXrNNJBDyJ7zrVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A7Kh/x2F; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768843467; x=1800379467;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=qk3XuufPPEIck/9A121yktRTMzQ3kk4TF/duoWERK0Q=;
  b=A7Kh/x2FeOZ0vfi0QpXM+KbS9sCp87IyGIm85l0+nB69n9TZivGxJK4C
   MJysZX0YmjdiMH/5WahD1ZcDfZMtzEI9c2a3jf55UOw6JlLBuN2jDEC57
   Hyat/tdD6JTYOi88nVgUBCFQT1K0rnPEbxxp7qFAqZ4s9Zf+Ie6Yq/3I9
   8sIwmRjkBTHPfv8c32OlvxaH0tAWM+K9ex9uvcYZaWnn8Z8eFNNTiDPzx
   N6WXDuH+fVQuWMhOKROp7YxTLJTH63CAPhzQztKbxnRGcQo5zLN0AhzP/
   HkBj5M0Hr+ICU2ANQ+I8ct5M0W0o86Df9sXBIUQEXc6ZeBIaMgeiPdoM9
   Q==;
X-CSE-ConnectionGUID: rmNVlQMwSASzAIRQvTAdiw==
X-CSE-MsgGUID: pGMbrTAgQ4qKNJGv/C0H4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="70107680"
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="70107680"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 09:24:26 -0800
X-CSE-ConnectionGUID: cCp8cmdLTFaKiKQxa3/2oQ==
X-CSE-MsgGUID: 4scyjDTQQq6KHTJ1sXWYZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,238,1763452800"; 
   d="scan'208";a="243499496"
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO [10.245.244.32]) ([10.245.244.32])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 09:24:19 -0800
Message-ID: <9679639cc7d9c2a27c5529484546faa65013f261.camel@linux.intel.com>
Subject: Re: [PATCH v2 0/4] dma-buf: document revoke mechanism to invalidate
 shared buffers
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Sumit Semwal
 <sumit.semwal@linaro.org>,  Christian =?ISO-8859-1?Q?K=F6nig?=	
 <christian.koenig@amd.com>, Alex Deucher <alexander.deucher@amd.com>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Gerd Hoffmann
 <kraxel@redhat.com>,  Dmitry Osipenko <dmitry.osipenko@collabora.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu	
 <olvaffe@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
  Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann
 <tzimmermann@suse.de>, Lucas De Marchi	 <lucas.demarchi@intel.com>, Rodrigo
 Vivi <rodrigo.vivi@intel.com>, Kevin Tian	 <kevin.tian@intel.com>, Joerg
 Roedel <joro@8bytes.org>, Will Deacon	 <will@kernel.org>, Robin Murphy
 <robin.murphy@arm.com>, Alex Williamson	 <alex@shazbot.org>,
 linux-media@vger.kernel.org, 	dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, 	linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, 	virtualization@lists.linux.dev,
 intel-xe@lists.freedesktop.org, 	linux-rdma@vger.kernel.org,
 iommu@lists.linux.dev, kvm@vger.kernel.org
Date: Mon, 19 Jan 2026 18:24:16 +0100
In-Reply-To: <20260119162424.GE961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
	 <f115c91bbc9c6087d8b32917b9e24e3363a91f33.camel@linux.intel.com>
	 <20260119075229.GE13201@unreal>
	 <9112a605d2ee382e83b84b50c052dd9e4a79a364.camel@linux.intel.com>
	 <20260119162424.GE961572@ziepe.ca>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-01-19 at 12:24 -0400, Jason Gunthorpe wrote:
> On Mon, Jan 19, 2026 at 10:27:00AM +0100, Thomas Hellstr=C3=B6m wrote:
> > this sounds like it's not just undocumented but also in some cases
> > unimplemented. The xe driver for one doesn't expect move_notify()
> > to be
> > called on pinned buffers, so if that is indeed going to be part of
> > the
> > dma-buf protocol,=C2=A0 wouldn't support for that need to be advertised
> > by
> > the importer?
>=20
> Can you clarify this?
>=20
> I don't see xe's importer calling dma_buf_pin() or dma_buf_attach()
> outside of tests? It's importer implements a fully functional looking
> dynamic attach with move_notify()?
>=20
> I see the exporer is checking for pinned and then not calling
> move_notify - is that what you mean?

No it was if move_notify() is called on a pinned buffer, things will
probably blow up.

And I was under the impression that we'd might be pinning imported
framebuffers but either we don't get any of those or we're using the
incorrect interface to pin, so it might not be a big issue from the xe
side. Need to check this.

In any case we'd want to support revoking also of pinned buffers moving
forward, so question really becomes whether in the mean-time we need to
flag somehow that we don't support it.

Thanks,
Thomas


>=20
> When I looked through all the importers only RDMA obviously didn't
> support move_notify on pinned buffers.
>=20
> Jason


