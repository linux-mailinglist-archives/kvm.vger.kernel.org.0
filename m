Return-Path: <kvm+bounces-68744-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNGIDCkLcWmPcQAAu9opvQ
	(envelope-from <kvm+bounces-68744-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:21:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C505A743
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6889CAAFA93
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D74948B39A;
	Wed, 21 Jan 2026 15:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="d8ipf+KU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF34E413242
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 15:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010102; cv=none; b=F1TcqQo+Oa+s+j8DZGh9VdvttIgWKM9Eqs2T9DlpbMPjBujGn/LrvEi/UbjRV1PYdJSc/EERu/f7DPtLKyb0cjA+sWdfIipbc4z+BqvCeSFzCeqrRSM8twQ1UuPooNfjRDC5fuiLyNJoL2fMkxvDOlFtpa54ujlUR9T2hYoSbGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010102; c=relaxed/simple;
	bh=MtzfM60Cs9mbb/vDYLGt1i8sN5P/nhUKDazT3BzO028=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F5i4i2wHKnP6SmbhyFk6CLaDTjbWJMdh+OUylwIe6ly8CblatNvV3fM1MB0FEfoYnpoCV6TL/xH4leqzSFw3sivnDmGkv5GzKxiG1dANoUuGIh9owwihKQcj3wA59twb0ISYcEPSp4bR0KVq8BDyR58sQ2ZV/V+dMf8xzE4H/1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=d8ipf+KU; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-888bd3bd639so12378926d6.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 07:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1769010099; x=1769614899; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ou8wYJVgke38aZatOGIOXXNbnvyF2AuO4MiXOCQfuAM=;
        b=d8ipf+KU++d9oWZgIR6lkxHBb8zf4MCRmoRwF7J76jVX9G5OiIyG0n6WJtb9AzNyCW
         jOjZq8LRWOOMO+Er2zSfMqVdcWQ5lDt4hZIILiz99LspfnYKq6Vm96pR1HOSOWuJs1ZG
         32i4aWr/fTBs/O3a8mldRbft0k6Baj9NWL2EeQdEiMYBskC4B9Yc5557kORXLi+3GJG7
         Pb8f/UNhY3khb4fQObQ8ddLiXbUAdCup/sKMLFCrWUMLzi9q2BqKM2Vaqyonmzp/1hPw
         25xyxonm5frcsDVntEjX1kH31oHyKXlWqJew8afiw3qggmbb8YPqg0OOTeGFqoKjzyCd
         pF9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769010099; x=1769614899;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ou8wYJVgke38aZatOGIOXXNbnvyF2AuO4MiXOCQfuAM=;
        b=c4vrDgDqb+KFg6+nkJwbFITT9iq+UpMggezA1S8b3stVE0SorGSeUOr7MNHhoQrTgj
         qrRlMed3qfK9H0d2sQQ2rLv7G6mQVSoOPMZkaUiidEZVYxp9+sDalAqTvrbkhX6+rP1g
         sZNiG3KejpiFLqHU3F3odNVIugvPCCG74TiRF4FJFwnTcaYandn9HKgIOvtxyRTzZ758
         2IGRsdY2DXfUO4KWZTQKMlyIKxgOSytX4aV3bcXRnzY06NOXKsqOLzjDC/MyGSKOc9Hw
         ILaLKIQBUtd8ztOnhh/B0Eo2q1Fn7HplJwtTZ+ggcBwBeGnPyCQCz1B6JakT88gkhtD7
         EsuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaOLhvTfPqbHnEIA1rV6IYIG8PnPKdNoSu8k/E4/KbS7dos2jk4IwA1sn72RxVD+9SAmY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOtc4I7BKykEyweFIW18KBSljrPIlQkw7qCEVtP8B/Lxf/fbdD
	v4ewjRt1NFCpnbvnd2g2XU7pq/4DWQm4FTP2sOZocbrL+Dh6IwXDoAPItXkdBXI0Tug=
X-Gm-Gg: AZuq6aLFdoRs/LWLrtJHWZba93N4rPkIW5Cht7pydg9FSMKl3nxIR6RQRuJyjfFoDWM
	PniArOMl1pK+0PLkfx7R60Zggawb5tM6SZ+jNybpxxD89dMO+F6XXQx8z0fhse3dztgh9Tfr0vk
	yuxPyoEVGiQwLCDShBWlmmCJHz0ZNEQE16U95gtwOdiyJT0ZbVGg6pRv6a4ntXttEJOjOA9/dp0
	KHqpNJzSu6hbLcTPpbvfviXmW/7C2fDm6EFbWMQBJjzu3t4iOw40QDNisgpcWrgd56gXhjYaaid
	h2LgYT0QIChY54ewyA//XvWDHq/oJFhQn8dHI8l1A8/xmnV2lkho33eSYeWW7jjmQ0tnRF8TIVO
	nlShajVJhEqTmOaq+Nyzm4tcBsU/AJsIHYLeda+Ivb/yoWZRxu9/RjTo+RlnCGDplcJTN9rKjUV
	9N+8tsbjdcQuhBcadbc9NV1+KRGrHd3yZS1ClhE2PQjDf+rvz2pjftmK9a95RfL2lf7YtJPJ5It
	A9+jQ==
X-Received: by 2002:a05:6214:212b:b0:888:6fde:7b72 with SMTP id 6a1803df08f44-8942d7e0460mr262093776d6.32.1769010098574;
        Wed, 21 Jan 2026 07:41:38 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8946a1e3d28sm30951806d6.7.2026.01.21.07.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 07:41:37 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1viaKv-00000006EjK-1pDz;
	Wed, 21 Jan 2026 11:41:37 -0400
Date: Wed, 21 Jan 2026 11:41:37 -0400
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
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] vfio: Validate dma-buf revocation semantics
Message-ID: <20260121154137.GD961572@ziepe.ca>
References: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
 <20260121-dmabuf-revoke-v4-8-d311cbc8633d@nvidia.com>
 <20260121134712.GZ961572@ziepe.ca>
 <20260121144701.GF13201@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121144701.GF13201@unreal>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68744-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ziepe.ca:mid,ziepe.ca:dkim,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: C5C505A743
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 04:47:01PM +0200, Leon Romanovsky wrote:
> > We need to push an urgent -rc fix to implement a pin function here
> > that always fails. That was missed and it means things like rdma can
> > import vfio when the intention was to block that. It would be bad for
> > that uAPI mistake to reach a released kernel.
> 
> I don't see any urgency here. In the current kernel, the RDMA importer
> prints a warning to indicate it was attached to the wrong exporter.
> VFIO also invokes dma_buf_move_notify().

The design of vfio was always that it must not work with RDMA because
we cannot tolerate the errors that happen due to ignoring the
move_notify.

The entire purpose of this series could be stated as continuing to
block RDMA while opening up other pining users.

So it must be addressed urgently before someone builds an application
relying on this connection.

Jason

