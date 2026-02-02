Return-Path: <kvm+bounces-69873-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WFCmEATJgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69873-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:55:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8A34CE7D2
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:55:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B89A303296B
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782F3371062;
	Mon,  2 Feb 2026 15:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="cc9sz5lo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD72512F5
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770047715; cv=none; b=lOuMOCM1BPVbl7WERbH6zNF5OSy2hARcOJ+EX550Y9WPZ7diDwGvyBRenVRrpSmFIHu5/frmcrWCOYK4lZj3nJUgVdj4wtjlCejQlmMm7JVCAQo7Jl262BiNxDQtkWtDmF1mf+pUro1wkuQNxoZ81gHe53c9urUMHE2wXAk/T/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770047715; c=relaxed/simple;
	bh=kGopxFZIlz3MVRgBeMLykRwwSqchomFgyOoC00zrG+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dF7ix6upieFXOQ+YIR6ZEL2WI+Md76boFVdrkQqxeZUKn1uH+ZfWL9WIbtBT0S34nYKsTeZWfB3RDXJjy0KTX+qqNKs1igWb4eZU0q2yDklAJaczvolX00mQzuO8BB/lMprJx+tnVxxef+13ZhynPiZ71N2FuyDcre3NTBULA0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=cc9sz5lo; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-505d872f90fso28873601cf.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 07:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770047713; x=1770652513; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ALEv89D4GoCyBIrWNO6jRp/YUrS6bKKk+NOOQflmefI=;
        b=cc9sz5loG5+85psAhMPsZpMcj5wll6NsIJR0nz3trS1TSKRBQCVs/8zKA0AQb862mB
         Hip6EjCC8qyYGazpS517/dsxEKQUL9YRGo2+UlHIx7Bw3/Y2TtJ6VZFeO6lZhNQRwjNJ
         qFSvOrbH1I8RdRdSOnwIdkKnzl+Viut72ZJ0fouAuB0PZsu7IXYhy1LhYYO1asqZSmlF
         yVNq/NGrj2Jm4/AZyheEgc/vkvEdcZJdHbkqW5x/akbImqkrDYwyQ65wPk+HYQydkj0L
         zk00gpIj8T2z6N/LDfmJdQht3voEmNvroqmXEp27Ii3Xyq27u2n0cyLmmoBWP1P9ncqD
         JoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770047713; x=1770652513;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALEv89D4GoCyBIrWNO6jRp/YUrS6bKKk+NOOQflmefI=;
        b=iDawJyOYt4qFAH8Pkt7GNQ6Em8Vu/C3fztLMWX985VkQ4lciiHihn+vRuv/Eu5XekD
         gXGOkJAM4A7UIF+pEBSUTo0mN4vTSG7ZAmXeDfARZX9+/lLiH6aZD1ojxPHQ7hgPBNHa
         lxruyJrnPWl547scrr6kJdYXpVhc8so9zPzvW+cogUz0DEaYkDOYnWwpN5e8OqqZHEEe
         RJ/VozxmlR4HmkfJpCYwdE4aiZmyqz3PgBpBPE52OpyQvyopgRkct/2/x8yXr30qqTua
         OjLHI4laF+l/3hrgtLKZn1+nQ+PUT8mIpv68hDiRv/3wGcvIascgiGBgBOx/+r+JQkYq
         5g0w==
X-Forwarded-Encrypted: i=1; AJvYcCWKuOWrSXN/zR4wYWhWk44DQ09qA8mMrsWlXiN+fDEaJ15Fz2eSvVrgHQLJc9VGIpxopS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzcMfmRJ8a4KZoBZUS9NotE6B1RKgB4bc+rvOX4iftFsNcpBgiG
	mcFXPbG/X5EHqpGahM5C1QMZ51khi8QcsDctYDlIki4dVAER+11CZjKQrzCcFc/+H38=
X-Gm-Gg: AZuq6aIfO6mcH83nzqPLycJ8Y/7BM8G8/lQsNE6tzm72uBp9BfvmLmXqPaDGMADHLLi
	LRSb5FXs0j/hgWDrV31iP/ceUXYvtQd/SVKwGhdrOKTVCRcSDFqj3YxH5zaj0iSKLor3rqLHQdk
	lJEyIzxbJ7q4v44mmSsXCixcSzo3VT4PISLwRXOOdNEDcR8uNoUS4OzCYLE2cUvoaMS/UAqHDd3
	oOIAUGGa32O6jg12EIlAhNDGPv1aPbUEB6YyRluwnyy+uJhM33DLwrSCLah8dgVOXrFL5eIxgX1
	/2PJvCvfb35tS7T/K/aBahXYMyYNp55oDD6oKGvDO84ME3d8gSf//QmOu1ww7S4DxPUeUw5gm9F
	7CXQk1/iCA22IexgP70lzMlyT6LESuBMmSr075+qLZ0S3cjxI0bTYosTcy4DGvEGeOmM9vVr3v+
	Q6kVE1XGuvILWOEt90JV/5t4J2d5YFJ9bl9zpH1MxpXQ8y+jN/jkoKYCCaElGnHjmOfSY=
X-Received: by 2002:a05:622a:1a82:b0:4f1:dfc8:50b with SMTP id d75a77b69052e-505d22b2818mr153088161cf.76.1770047712810;
        Mon, 02 Feb 2026 07:55:12 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50337ba3997sm107174411cf.17.2026.02.02.07.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 07:55:12 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vmwGd-0000000FWiw-2z4k;
	Mon, 02 Feb 2026 11:55:11 -0400
Date: Mon, 2 Feb 2026 11:55:11 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>
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
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260202155511.GI2328995@ziepe.ca>
References: <20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
 <31872c87-5cba-4081-8196-72cc839c6122@amd.com>
 <20260130130131.GO10992@unreal>
 <d25bead8-8372-4791-a741-3371342f4698@amd.com>
 <20260130135618.GC2328995@ziepe.ca>
 <d1dce6c1-9a89-4ae4-90eb-7b6d8cdcdd91@amd.com>
 <20260130144415.GE2328995@ziepe.ca>
 <c976c33c-4fa7-4350-8dcc-a5c218d1b0d6@amd.com>
 <20260202151221.GH2328995@ziepe.ca>
 <44ec9689-045e-401b-b9cc-17abdd938bc7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44ec9689-045e-401b-b9cc-17abdd938bc7@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-69873-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: E8A34CE7D2
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 04:21:50PM +0100, Christian König wrote:
> > I admit I don't know a lot about VFIO PM support.. Though I thought in
> > the VFIO case PM was actually under userspace control as generally the
> > PM control is delegated to the VM.
> > 
> > Through that lens, what is happening here is correct. If the VM
> > requests to shut down VFIO PM (through a hypervisor vfio ioctl) then
> > we do want to revoke the DMABUF so that the VM can't trigger a AER/etc
> > by trying to access the sleeping PCI device.
> > 
> > I don't think VFIO uses automatic PM on a timer, that doesn't make
> > sense for it's programming model.
> 
> From your description I agree that this doesn't make sense, but from
> the code it looks like exactly that is done.
> 
> Grep for pm_runtime_* on drivers/vfio/pci, but could be that I
> misunderstood the functionality, e.g. didn't spend to much time on
> it.
> 
> Just keep it in the back of your mind and maybe double check if that
> is actually the desired behavior.

I had a small conversation with AlexW and we think VFIO is OK (bugs
excluded).

The use of the PM timer is still under userspace control, even though
a timer is still involved.

Basically there are a series of IOCTL defined in VFIO, like
LOW_POWER_ENTRY that all isolate the PCI device from userspace. The
mmap is blocked with SIBGUS and the DMABUFs are revoked.

The VFIO uAPI contract requries userspace to stop touching the device
immediately when using these IOCTLs. The PM timer may still be
involved, but is an implementation detail.

Effectively VFIO has a device state "isolated" meaning that userspace
cannot access the MMIO, and it enters this state based on various
IOCTLs from userspace. It ties mmap and DMABUF together so that if
mmap SIGBUS's the DMABUF is unmapped.

I understand your remarks, and this use of PM is certainly nothing
that any other driver should copy, but it does make sense for VFIO. If
there are bugs/issues we would continue to keep the overall property
that SGIBUS==DMABUF unmapped and only adjust when that happens.

TBH, I don't think people use the VFIO PM feature very much.

Jason

