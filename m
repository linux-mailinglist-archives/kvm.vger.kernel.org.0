Return-Path: <kvm+bounces-69722-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yP1oK8O4fGkEOgIAu9opvQ
	(envelope-from <kvm+bounces-69722-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:57:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E6E0BB68B
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:57:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 668B23031808
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F476319851;
	Fri, 30 Jan 2026 13:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="eIYcXAWS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B8E30F54A
	for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 13:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769781382; cv=none; b=plOAfbS+++gb4w6VZr2tUue3jhIfaji65xge0WNJWEY6FApe+YkKygAqOwuQcYYJcwMjgzGiUXsEMvVdt5xIuI20LalXJsx0O7IKCyWrnhzAZp2qzyDtWXwfk9xfZ/s76us8xPxcpBNP8eI5QAmMul1p+Oke1PTU7pwnfh/xcmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769781382; c=relaxed/simple;
	bh=SL16M++KtfIb+4uJE+a/R7kOylXhnM5j4tZGOMk8fro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmMcXxlNij2wMang2+J/SXiGgllIhPTXLiyppaJ9guRgJFlkDFwOTkdeGu+hj4Nnc+nTQ7U1fbTU78FgPkjHBLvhBdUEXVijeq3m+dROJkEk4pTCG9bttzW3hATyZxrZ7i22AmLj0vbIWi1m5Soha2jNT5Bw3fTM5qlPCivs4/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=eIYcXAWS; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-88ffcb14e11so27843176d6.0
        for <kvm@vger.kernel.org>; Fri, 30 Jan 2026 05:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769781379; x=1770386179; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nHaCd4HrbYw78ScpRIoaj6AeaBJaVtnx8urFDLScj1Y=;
        b=eIYcXAWSoo1RbCh5BvSxy6AEZnoiozLBx1VBEN2IWQi8ZC19oyIWOOVmRnZzJF+1Yk
         SCC/pCL3wp5JE8KWke6ThiaLJnoP1be7LSDKGW24XvZ5Kn+ozIGNhbOhK/olKYWEHD2u
         uSe+TCKw4TcbIHEYVz4MZIlSHAcwYGMub7mqUUEn3ZYEjOyamT+dTcZCo5KOg8J9d6sw
         ANgcr5CV39slNHFiDZTsXt8wUcpjwcDmngp47QEGfM5rWOW/2zbuqcrvmM22lo8AwwHE
         4FunVydn1CLvLnxp1o/5Oz9rFQSCnwmeedSXMFIuXAXZS6xG8M2dhjxa5VrLVJI2FSo2
         hGew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769781379; x=1770386179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nHaCd4HrbYw78ScpRIoaj6AeaBJaVtnx8urFDLScj1Y=;
        b=idud1WtpOX52GQXBO0y2V2m2lTfycFeL29D4rlbso6QJjtkU9/dgd0iRrXQ39UUuul
         peJq9dzPCraj1MqgyAjP1LgvbMoEJ5gnyda3/ftJrQOJ14wZiuSLz+bIasXdOTQX499x
         QnNjDH0CmoVWzeCiSln0M+iSbEGjZw7qIYXjTv/B73cQv8fShU4na7TwGCISr5Xi2MfC
         0o3BfBRUOTDLukmA0bE00h/GcF/+xgabiGBK8zPR/Sj6Ck7BQFTOxtpa88VaJa9tMck9
         K+2YJPXROZGwu1q4oPaukWLZc97tk9X4oWdf2leDAPaoFCHW1q43rIxXsGZ+XDsioSLB
         bk4A==
X-Forwarded-Encrypted: i=1; AJvYcCXT/xLdmQEnoYr5HaPaE6+6m17UNt+qNYCTEfb5RDuwiOYhCLVXAcxtKDLPO3gGPh6Qd0Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOjWoYrwkT7dYEL2lYMaBz3DgdwrU9/KxLWenWveHv8c7RK5lj
	nlrV7AFYEGzQKLIKETFrdYKVCBcWJ3DJT4PbaS/dCsXXXy7fK0w5zniN2C7oBgOS3C4=
X-Gm-Gg: AZuq6aJ+mrH6DbLb+aNv25WlJFVd9R34L/cVYbNnUv0zJXehreF0vd8BiCMO+msQpLE
	yewdS7rAMaiaw/YAd8U6aBEpCYCIOBe8lW0Udy4Tg580rreI8Cqw5FOw9DFXUXHLXj3A6RKrGJs
	wqNMAR19ZispMUSnGkoQtcBZmLPQuoO6VP5uEONF/MoTHKugRR4th7jPNTL8v5CbDY8qfKr6hMg
	pNM1aguYu2vRAHBLpHxNv8HVW2sbvjGHOh7BqDSH1S+7mRHY7ve4oiZ4qnvtVFEAS19vBW6PysW
	jTfUa88UAYKI9eQLFhrdtvJcCOHEWdGQJLzrI5AgeLcaJw+fDpiZB/N+ZEraKTANaSSOQ05dRtY
	JCo6oneY+zX29uQMtiel1BFSdWFkROa0fWY51+rf1+hRMmUtd8q4NeeSpMBuk6AfFv22QHHCkHk
	awXBTcMYXZjkcK8tojA0Vv4DxKGm3MpFERqQt6AaASZLObBxQdHfQ+rwVoMs712NvbYyemEO0Iq
	WT1EQ==
X-Received: by 2002:a05:6214:2a48:b0:88a:529a:a53a with SMTP id 6a1803df08f44-894ea09691emr43666386d6.51.1769781379597;
        Fri, 30 Jan 2026 05:56:19 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-894d376da66sm59670316d6.50.2026.01.30.05.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 05:56:19 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vloyw-0000000AmRb-29H1;
	Fri, 30 Jan 2026 09:56:18 -0400
Date: Fri, 30 Jan 2026 09:56:18 -0400
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
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260130135618.GC2328995@ziepe.ca>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
 <20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
 <31872c87-5cba-4081-8196-72cc839c6122@amd.com>
 <20260130130131.GO10992@unreal>
 <d25bead8-8372-4791-a741-3371342f4698@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d25bead8-8372-4791-a741-3371342f4698@amd.com>
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
	TAGGED_FROM(0.00)[bounces-69722-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,ziepe.ca:mid,ziepe.ca:dkim]
X-Rspamd-Queue-Id: 4E6E0BB68B
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 02:21:08PM +0100, Christian König wrote:

> That would work for me.
> 
> Question is if you really want to do it this way? See usually
> exporters try to avoid blocking such functions.

Yes, it has to be this way, revoke is a synchronous user space
triggered operation around things like FLR or device close. We can't
defer it into some background operation like pm.

> >>>  		}
> >>>  		fput(priv->dmabuf->file);
> >>
> >> This is also extremely questionable. Why doesn't the dmabuf have
> >> a reference while on the linked list?

If we hold a refcount while on the list then the FD can never be
closed.

There is locking protecting the list so that it is safe and close
continues to work right.

Jason

