Return-Path: <kvm+bounces-67238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A839CFED9B
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 17:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4F81D32A6A45
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 16:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE4A3644C5;
	Wed,  7 Jan 2026 16:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Ft7TghyP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A83C346A1A
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767801677; cv=none; b=E85Qz5hLKUGseXo5wQtZTOvAKZdk0Jso+yUBms1Gi6+MGSa5D9vrvLyDSLrLVpO2pd30pGFlP+ixw5XnKqb2I7f2ro7H3O639CEBafrn+llOOqdSm4omrkENjNR9sP8XE3NavLX8qqjU9t+EQjdm7IgsbPOsqorp1JU2Xfr8pGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767801677; c=relaxed/simple;
	bh=V4bVj2wSElYjvUgQlZ6az/4rqywQNYaAH3LZ9i/qB6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nbh+EM/xL/17UeO/alSsLKd0bXqTBZO1cpqWqJXpnkioBDXKe85Q7KBMAUxyRlmWKzSXv0kGC+E2N0XNwE+8aKeFuxJhdaRJD+7nyJG6fR1wb5QfjQbwVvC+FpmKuQgwSL2I4Kr+xtjKDp4rtVsxRstFPcYIZWQ2qABn9RWzp3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Ft7TghyP; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88a37cb5afdso10998256d6.0
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 08:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1767801653; x=1768406453; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ftSoJlbCa6MOGNHtdz3xW3rHVknPRmwRfQPP71m23p0=;
        b=Ft7TghyPMhyrb8gGBX881I5VOypjVaEZudanM8zG1RpGlp6JpOZRBP/0Mdbd+OShn3
         IzoJ2JeRQ0szwl765mDxp+X2zzojtSinUIXBNjPLLVPV4tnqC7r27qQYNkHzmsaQjMV2
         Fpi1OmRALrgsBXYzyy3GCO5MZtF1qd4fDxqsKiiuNv8REzkXSfrhYJno863pzO54/9AF
         T4xQ/nB36plu0hFqGot8QHfW1Mnn9n/ICptAuofp3gWnnXjtjaUIDy3dkEPsKuuyDMng
         DATsBIDSSoJkiYVa+hFPO7j4VoUMm8OfGFzEFjWifY2YbyI5t8iNsSie7bUNNTw3umZZ
         IUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767801653; x=1768406453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ftSoJlbCa6MOGNHtdz3xW3rHVknPRmwRfQPP71m23p0=;
        b=pQs/MrhNaQ1U+nNgMo8cFXR3Ny23wWMN/orMhm8WVhwfSi1KrsKpk9nXyFv7RZaga/
         SodCtzY3hONGiEBrniBnTaFxcB15WtuZqU+Ts5Z7mDpYPvealr4TB3ModFtLRsxwc08u
         9yZ31kWw7DpS8s7nWR9aLm+JFFrYbiQfH9bupvvm9IpRi6HHg0VQAyoZ36Za2Ikzn+mM
         BzxiOKwdbSLnRtfaHNtqA1K9IgZ1Pross7lGees+kJhH1784avienGZHMcokdL9PXxjg
         SrVaCdIKFdZdrMkbGzhBDaUkRdMZkgv/8ieVVPJfoge3YkURviuKeTar2tk0Acro4hny
         1Bfg==
X-Forwarded-Encrypted: i=1; AJvYcCV57ms49q4/QPL/cH8Mfy5ntjBwP4QkAU+sNipjmhdr67FXNyPD8x/8lD9opG2/8bIHRAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YynqZoZsR+UyKojsLabusNBMZNn1z59CbRPIge2sbimkPsHf1qM
	kr+vDMCG4qaPcT+AQ8U2mhQN7sxypFlWUSLgKCrXTNrq91osbD/rfiVEee85An10p+/rpM7y8zD
	GGmXP
X-Gm-Gg: AY/fxX6pJ4edGeR0YZoKTnideKOd2YBYwfsDKomHt/JMe+MOgHdev6AAcFxO9n1tnK+
	2Aq7Mu04kcWuJ8ZAooAL05e+QcfL4w+J2eN1zwDo8fL/AxRfbbB5DlLFUFPUWiyEzOC15AJ31ph
	kbiEg5+QedUFnISxjEWJKDLEi2JmAX5VcB1sTw7AFO2UBBVQR8gVRym6ARk4Bod6dFhBETMQetz
	yz4xLdiedC94uKFrKyRUV8z7X7QA1IX8kOmD/ly/yvPEm2i6iOg5OFuS3aKYb0OogrsvSkftkZY
	4jJoAxL8l6YnWzGugNnzs/vtaWeaE6Txmm/iGtpezNuvj4BaIwRniJoyYxRJnX2IZbDfo1/dCJk
	nmTooMKzkmBHq+j31jQvg2F5sPv3fKOYr6OYw4/7JiSUxW2ydTHO5FuauK/6zNXC/9eObbjg1nr
	zyEHerNC+rxRiKe6AuYb5sGhW4AiyLo0DdBjKD0bS2LxejTmldVe/0PtKdNNhtN3P2UuodEYEf2
	UoAtw==
X-Google-Smtp-Source: AGHT+IEsFTBclBHNaJgPLh58sVSxPObjQlXbE6JZhrOur9VbgMkz2k1BHIEIa/RCFDyuscOAoE/vIQ==
X-Received: by 2002:a05:6214:411:b0:888:4930:7989 with SMTP id 6a1803df08f44-89083d0d91bmr44153996d6.36.1767801649963;
        Wed, 07 Jan 2026 08:00:49 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8907725ffc7sm34937966d6.44.2026.01.07.08.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 08:00:49 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vdVxn-00000002CVI-0vE2;
	Wed, 07 Jan 2026 12:00:47 -0400
Date: Wed, 7 Jan 2026 12:00:47 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex@shazbot.org>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	kvm@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: types: reuse common =?utf-8?Q?phys=5Fv?=
 =?utf-8?Q?ec_type_instead_of_DMABUF_open=E2=80=91coded?= variant
Message-ID: <20260107160047.GB340082@ziepe.ca>
References: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260107-convert-to-pvec-v1-1-6e3ab8079708@nvidia.com>

On Wed, Jan 07, 2026 at 11:14:14AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> After commit fcf463b92a08 ("types: move phys_vec definition to common header"),
> we can use the shared phys_vec type instead of the DMABUF‑specific
> dma_buf_phys_vec, which duplicated the same structure and semantics.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
> Alex,
> 
> According to diffstat, VFIO is the subsystem with the largest set of changes,
> so it would be great if you could take it through your tree.
> 
> The series is based on the for-7.0/blk-pvec shared branch from Jens:
> https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=for-7.0/blk-pvec

Great!

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

