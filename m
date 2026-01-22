Return-Path: <kvm+bounces-68940-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +D4BInK2cmk4owAAu9opvQ
	(envelope-from <kvm+bounces-68940-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 00:44:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FC06E936
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 00:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B1DD3023370
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 23:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 069753DC5A4;
	Thu, 22 Jan 2026 23:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ZDfKOZYl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9695310652
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769125457; cv=none; b=u48puTUobuwyLRnerZ7HOTIPctnIPNCtvtJoU72pBKouwPAYP5TQi0UAWxSEG7R+e2XVIA60ull4VNqhpTqm92eQRWGX1JWwI4kipbDpK0GWMzyhs9iux2dQXXNvOuJ5tFIHN/Ed1Ew6Dmr++SDqie7xoalBi/Svf3ExOHK5lnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769125457; c=relaxed/simple;
	bh=tD5f+h84ofqnK09ZH5j1acZDqC2EpodfEzB0D4Jj1p0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BcTDEFLEREEaDGFPkj10uLCKcqE0MygJJSg3dbRTRN/p66YarpqAE75tDEGhTCSbuIknV1bqieRA/0rZvef3uKxcg7CG6KS5uauBwYwDMn33+Gi/DJHj1FrV9mqww+yn4ZJgmHUJ7e5gz/QleezzTVyzgfZeOqVW5AfIH4CPaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ZDfKOZYl; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-894703956b8so24751196d6.1
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 15:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769125446; x=1769730246; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Udk1T2MTSGRhmMtQ3jtc9BpxDT02wAcqHYT9NWJE+U4=;
        b=ZDfKOZYlbtc9e45Oa3sa1G7jUMTTapbJ6M5R1c9Wv5Hr9dhqqOYNk3GWFL6qT5RooY
         QECtTwO60TgTg8cxbTwE3Er6g+0bPKh5ablKSUxfxlDm6QFthJT11cFz/iG273fyZjaf
         avZMMJOmsZDjP0WBBupWp4wYZsoXAoE51jUmQqcbkOrGT2uh1AcXLxyyZ7b6qWxCoJwO
         TgtuYU7L0seUT4rOWSC4kTkRxn8HxNt2DhlCdQU3pIxt7/9nGJksqSV+hZYpxmDaNj4C
         Re3vmbgh+CxxPpwIC2hokIpOoeoGrOXLCeAfSW11mktw/rGGXhYkfYoePkh7oz1JInot
         O1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769125446; x=1769730246;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Udk1T2MTSGRhmMtQ3jtc9BpxDT02wAcqHYT9NWJE+U4=;
        b=r62P3R8ssPErscRXq8RpIPkV80zopOwVSuESQbjADLLtW/dnT6iq+nkjPS7RIVrGWG
         EzJ599oMd60L0CsYzmusAj0TEkwUrG3r6IOs8IIfS8QwbEmP9OLdctPlre6itCP0DfR/
         20L7ckBAj5kn6T7DnA+M1cKVh+srm3HEuTACyNTUNG0+KmGSxtHBg/i5b4TltsLa5B4u
         yW0UY5xflxvtU5xOSoWXdPsG/Tx9MXdW7xs7qW4YikwPsK8suRqpVTwCfHiMCsjDhuso
         AhZbVSIsZkRwkaJEkMYeXlGl2z7i0O28PfqphI95OizidLZyLpduw1fS2RE2/CYUfA2+
         E2dQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnRmQoUZ4FD6FBhzHUfTX2/lPDNeVQrm1nGXxhE3fz8HdtNrqart2Pj28a+1gSGtVX5Bk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu71ZGpexP3wzL6FsnKZEWnq2BtLzhTds8AWCcxkpy1uabnrs1
	qV/Ac+auvXqLQOXNDSRW9aKNZJ6iDDuyuwWzsf1AdVkeIzMEcflrfU9MgfqZgGRJXa4=
X-Gm-Gg: AZuq6aK9wrsrI0CvQY3FsaVSgYwwNvauz9fnTqJeW0Rwst0UTA/eea3wBvjwiAt3BvZ
	LiwupL3KhYrIGVgo+XdBWRdfwh8ljGJqTXfxt/80+BG+kj81a1INCKK8IdOH2N/dcROlkHUpXx+
	ObLknYZ/4RDLSaKFG7dvIr7fy2x8Ld85UXBtvlu9yvVX6xyvRu9Pi5i1b7cCm9bzVsXAw5VoXtF
	Bi3msAe8/T2O4z2rrM3tm/HBRuS1tXNcmEOcv7AWrM/Xmutf5tkrd4xOluf9h742EQ3UO2feRuP
	z61s0s6taP8xd5s1kADwoP8mLbnYGVO1rQaRBNf6pTQ6AyfamVlobTkbMSsEz6L38VlH/SVPKB+
	y5wU89jtcAHuCwBpdZ5a3Jv2FXUHtZ1WVLj4ZwNyoUTiS+ANLG9Jd53ktP33A1RahuBBxks4wFu
	BGgU7gUb4XAcayzjc9H0IrBZYq9sDDj6vZkClXTfg/EVzXhGA5YtLfDujoz9s4Z5Czlpg=
X-Received: by 2002:a05:6214:2269:b0:894:6530:efd1 with SMTP id 6a1803df08f44-894901ac85dmr20677696d6.19.1769125446269;
        Thu, 22 Jan 2026 15:44:06 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c6e3854a6csm44128885a.41.2026.01.22.15.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 15:44:05 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vj4LM-00000006gRo-0Lke;
	Thu, 22 Jan 2026 19:44:04 -0400
Date: Thu, 22 Jan 2026 19:44:04 -0400
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
Subject: Re: [PATCH v3 6/7] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260122234404.GB1589888@ziepe.ca>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
 <20260120-dmabuf-revoke-v3-6-b7e0b07b8214@nvidia.com>
 <b129f0c1-b61e-4efb-9e25-d8cdadaca1b3@amd.com>
 <20260121133146.GY961572@ziepe.ca>
 <b88b500c-bacc-483d-9d1a-725d4158302a@amd.com>
 <20260121160140.GF961572@ziepe.ca>
 <a1c55bd8-9891-4064-83fe-ac56141e586f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1c55bd8-9891-4064-83fe-ac56141e586f@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-68940-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.977];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 32FC06E936
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 12:32:03PM +0100, Christian König wrote:
> >> What roughly happens is that each DMA-buf mapping through a couple
> >> of hoops keeps a reference on the device, so even after a hotplug
> >> event the device can only fully go away after all housekeeping
> >> structures are destroyed and buffers freed.
> > 
> > A simple reference on the device means nothing for these kinds of
> > questions. It does not stop unloading and reloading a driver.
> 
> Well as far as I know it stops the PCIe address space from being re-used.
> 
> So when you do an "echo 1 > remove" and then an re-scan on the
> upstream bridge that works, but you get different addresses for your
> MMIO BARs!

That's pretty a niche scenario.. Most people don't rescan their PCI
bus. If you just do rmmod/insmod then it will be re-used, there is no
rescan to move the MMIO around on that case.

> Oh, well I never looked to deeply into that.
> 
> As far as I know it doesn't block, but rather the last drm_dev_put()
> just cleans things up.
> 
> And we have a CI test system which exercises that stuff over and
> over again because we have a big customer depending on that.

I doubt a CI would detect a UAF like we are discussing here..

Connect a RDMA pinned importer. Do rmmod. If rmmod doesn't hang the
driver has a UAF on some RAS cases. Not great, but is unlikely to
actually trouble any real user.

Jason

