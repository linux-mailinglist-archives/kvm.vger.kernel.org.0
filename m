Return-Path: <kvm+bounces-68613-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6L+rAc2McGkEYQAAu9opvQ
	(envelope-from <kvm+bounces-68613-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:22:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC295370E
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 09:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CD6708C4975
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 13:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E582F227B95;
	Tue, 20 Jan 2026 13:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RFlINO8a"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com [209.85.222.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B681FC0EA
	for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 13:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768914935; cv=none; b=Zna7tnPQCHEPt42N8iCXp3TA/k/vx+7QjmC40H6vSSzflw7dgUOFIlHVZ4uswvbmLKGI3Wcz0yMpx38LCYuPM4vSMaKZE2stTHyXpqyWilPBZe9Wqq59Araqdfolwce7GymAV3XL1eieKlzWTYEdthRZ+waJgz/3vG5xZqCZ4l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768914935; c=relaxed/simple;
	bh=xnk/b5HPpyfNnMbI+XkeyZX1b7NurY2cBOv/ZUy0nkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjNQ7kVDw0ogCdPxrhK7DvvdNun+W0jbWSjXWOoxgR6iaAW+dtsKU2sSk9gxlmLmIoaCODBzVxxgMw2c0tGV2X8tK/6A7suMHuNgJ9n6IqKG4b53R4kZMIfBtU4LtQHc/T1r0/t4tHPMZwNam1n47oALvVFxDLH3DSYPsLMPukk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RFlINO8a; arc=none smtp.client-ip=209.85.222.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qk1-f193.google.com with SMTP id af79cd13be357-8c537b9fcbfso545061485a.1
        for <kvm@vger.kernel.org>; Tue, 20 Jan 2026 05:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768914932; x=1769519732; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jl2KF0othdvrwDImGzxJcxoX7WKdbBXFC823mMEO8nY=;
        b=RFlINO8aI/gtHD1iK1qOubIgA1mTdMNPt8iQAYSpLQp2g1TlT+Cx3OQVDA1IGPOeWt
         f+zeQtvB1AQfxpPyCoN5cF+yC45Y5ePBC+bGWd/kgwNupGi3FD9Q2objOpwPUZbcLs+S
         05Jmj3mko0PFL8fWfKlSUNIa76h60tdFktwHUKDXgbodeT/MGcHE+HmSnAxf3aQBmmkQ
         tLsHSd+DhZo9MiBRJe+m1AAhT+I4EtsBqZNhSZEbaBVa2KQf/EW/n95kTnlNj+m8b5i2
         ABLKaQlyxiol14GRTgukxU3TXS+Zn11QO2BDT67ciWNxc2qt1jrU23q/ouRUUL5EOVeO
         YMNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768914932; x=1769519732;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jl2KF0othdvrwDImGzxJcxoX7WKdbBXFC823mMEO8nY=;
        b=nyo70HPXzoYUbRTjZmj2a8gU0YVUIaW3K0ojMXCwzz5ghuBauo1G4KKjnXwEWU1rp3
         fAtSb70tmz13xC4T0R8uG5Y9lxd78laQx0D9NDVtTyd93ezgd7La8jeNjiapUwMNXSNw
         CKefvM71sTmmEMSzLKUQsonTNsM/q3ulvLWJBU24KPSpVq+lTPQDgekrtuPfzW4RDKHf
         Rdh3oEft0+R8IUBAKjBzp8RK7zlHjG8OLMqxYwZw85nl8VVF1Jckh9vKMmPJHUP36rly
         qc/7YjnCsSi7U7AxQWCaUgV3nGLa58GAgO1xkUhVK1oxBnjBae12cmlR+WNrUVYm2JkU
         kPYw==
X-Forwarded-Encrypted: i=1; AJvYcCX8XRWi1bqVvXpwgHtHz3P1dOWvNXoebYix8X+dsA04yIfdOmisysZHLK1W9h7m6zc+iDw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFMeBgsWpRR5XMyG8xVfyq71T2kjeKo+AtEXMh4XvwvB+UdLy+
	NA9LwYgd3shY4BJkLlI9/f7InOmcMsFkOG1z4hRzPHJWJTXwPA7U/ji049mQ4h9EYkM=
X-Gm-Gg: AY/fxX4m4Ho3mfMI8k7Ixa3ziSRwlLAwFJkca1J0KR6laV8nrLhXQddVy6taeAfLE/L
	L31oOEgWDGyO1aZT8f7eXm0G5fVMgBbo+XZDZOrqwagERFaf/ClMlV4wu0wFDtNik78yP6PuSiZ
	3LBe9pewSnsDfxddVDtpOI5EWex1H1QmajcabmORThfaOm8e1cjmKm4kjWuE0jgvHdBJlxeZcV8
	oTrnxfKsNKNOsmoLatGDEpKSDO8uKLiSDYEQ3V+LxFgjiDhBJqAb50aYOvLdpenG8VaeqtZyXe/
	u5wQehocFFmIDFSeH62A64Dktl7oOxbj2GqWxrbANx3w/RubsD2mc/9vf9I2zDEGBp0Ks1N6MO4
	2di4XbmiRyW2CEBqJc7TZgdC4ga0kF7dZs2S5iI3Bg8ZjsD87P6SmrOX+2Rfc5qdUCI/+31L/7a
	GV19uvKOuyd7vWwxikBdybWrMo1o7bDDkaM/Rh50ZQlhVMySvm0Xj2PWJwfbdJyFbJewI=
X-Received: by 2002:a05:620a:999:b0:8c6:a68a:bc04 with SMTP id af79cd13be357-8c6a68ac1c8mr1389837085a.7.1768914931884;
        Tue, 20 Jan 2026 05:15:31 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6a7292cfbsm1017788585a.50.2026.01.20.05.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 05:15:31 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viBZy-00000005W6K-36CW;
	Tue, 20 Jan 2026 09:15:30 -0400
Date: Tue, 20 Jan 2026 09:15:30 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
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
	Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev, intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/4] iommufd: Require DMABUF revoke semantics
Message-ID: <20260120131530.GN961572@ziepe.ca>
References: <20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com>
 <20260118-dmabuf-revoke-v2-3-a03bb27c0875@nvidia.com>
 <20260119165951.GI961572@ziepe.ca>
 <20260119182300.GO13201@unreal>
 <20260119195444.GL961572@ziepe.ca>
 <20260120131046.GS13201@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260120131046.GS13201@unreal>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68613-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	RCPT_COUNT_TWELVE(0.00)[31];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,nvidia.com:email,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 6DC295370E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Jan 20, 2026 at 03:10:46PM +0200, Leon Romanovsky wrote:
> On Mon, Jan 19, 2026 at 03:54:44PM -0400, Jason Gunthorpe wrote:
> > On Mon, Jan 19, 2026 at 08:23:00PM +0200, Leon Romanovsky wrote:
> > > On Mon, Jan 19, 2026 at 12:59:51PM -0400, Jason Gunthorpe wrote:
> > > > On Sun, Jan 18, 2026 at 02:08:47PM +0200, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > 
> > > > > IOMMUFD does not support page fault handling, and after a call to
> > > > > .invalidate_mappings() all mappings become invalid. Ensure that
> > > > > the IOMMUFD DMABUF importer is bound to a revoke‑aware DMABUF exporter
> > > > > (for example, VFIO).
> > > > > 
> > > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > > ---
> > > > >  drivers/iommu/iommufd/pages.c | 9 ++++++++-
> > > > >  1 file changed, 8 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
> > > > > index 76f900fa1687..a5eb2bc4ef48 100644
> > > > > --- a/drivers/iommu/iommufd/pages.c
> > > > > +++ b/drivers/iommu/iommufd/pages.c
> > > > > @@ -1501,16 +1501,22 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
> > > > >  		mutex_unlock(&pages->mutex);
> > > > >  	}
> > > > >  
> > > > > -	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > > > > +	rc = dma_buf_pin(attach);
> > > > >  	if (rc)
> > > > >  		goto err_detach;
> > > > >  
> > > > > +	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
> > > > > +	if (rc)
> > > > > +		goto err_unpin;
> > > > > +
> > > > >  	dma_resv_unlock(dmabuf->resv);
> > > > >  
> > > > >  	/* On success iopt_release_pages() will detach and put the dmabuf. */
> > > > >  	pages->dmabuf.attach = attach;
> > > > >  	return 0;
> > > > 
> > > > Don't we need an explicit unpin after unmapping?
> > > 
> > > Yes, but this patch is going to be dropped in v3 because of this
> > > suggestion.
> > > https://lore.kernel.org/all/a397ff1e-615f-4873-98a9-940f9c16f85c@amd.com
> > 
> > That's not right, that suggestion is about changing VFIO. iommufd must
> > still act as a pinning importer!
> 
> There is no change in iommufd, as it invokes dma_buf_dynamic_attach()
> with a valid &iopt_dmabuf_attach_revoke_ops. The check determining whether
> iommufd can perform a revoke is handled there.

iommufd is a pining importer. I did not add a call to pin because it
only worked with VFIO that would not support it. Now that this series
fixes it the pin must be added. Don't drop this patch.

All the explanations we just gave say this special revoke mode only
activates if the buffer is pinned by the importer, so iommufd must pin
it. Otherwise it says it is working in the move mode with faulting
that it cannot support.

Jason

