Return-Path: <kvm+bounces-70195-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLfrE9JLg2n4kwMAu9opvQ
	(envelope-from <kvm+bounces-70195-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:38:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F0AFEE6894
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AED43302D0DD
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:35:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE1E0407576;
	Wed,  4 Feb 2026 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Uv0WIWUc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE855261B9E
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770212126; cv=none; b=J99Qh42/XZpiBkwago6KV53VkfmnWW+fA24j8RQz5p3RePJvD93B70COO5bYYJ4RoKbEuXwTzyGeJa7XA6Vx5xQRuufdWB2fwJGCZryk725abNAUn7Y+WygYXb5jhObTNcabdxn8s70xJcFWLPebK6SM/onZXjt5Vf8FJFhZPfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770212126; c=relaxed/simple;
	bh=H/kTkGZP8AkvmyFzU3sXO08Z5L27cMenr5LlCq/UphI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MHuVhLamyBBqpyiLArvhq1By+3fKHTA0pR4rKN02J3kvZw+0GgWk4iSiBpQsVnO2sMiq8amxDCPdf2AJ4dmwjj9Vcebs8V50ixX/hcC4ZJ0ChYPXGEzbPZSAMmohWWx6bOeg0fXKn4hi51ACrezCvobLQnaObp4kG9zIkqd9PvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Uv0WIWUc; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5036d7d14easo69348991cf.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 05:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770212125; x=1770816925; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cy8s41Ej9e437sslVRAHtURD2nYFlOPaZF56zUYznoI=;
        b=Uv0WIWUcqJtPXKa/5Y7ubmiDv0M8T+sBw1uP2dAfNaKLquu1fLoQKAHmC/IPmVrWqC
         5tWvyrmfii+V58Isx8AjekbvEEXTun3IiyFlip6GExElerbAkxZP4NI3Hd0F3oriQ+CO
         huxr/QhQ2zEgauiFRlsDaxzXkEQwWbqkmlxNAazL2vfE+Rrydjoj2jCuzWZut7u/trmJ
         JZURS7iHKu6X9E5OtW2VnFzp4SID4WKhMRBz0+mx9vj7TjxtkGVvptuDo0MUaH+4N62Q
         dSkX82jwu3reH9HUOItc1utLRRMj9Ds+/4kG0qtsIdGyVJfF8KeZQ6Y96Lqv55UIV4An
         TwMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770212125; x=1770816925;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cy8s41Ej9e437sslVRAHtURD2nYFlOPaZF56zUYznoI=;
        b=ndHajPOFIx4MkTtPfZDMRqlepsiUBiJJJf62y2vbhUYV9O+9/kYLvRf+oKkSLzFd21
         cBJ2ZrDHFpYHKQxhXUU0sglL/2LYJrXkhJ/Wl9LQ0vd8D7wHaXxKgpA3dA8VGMrUwSIR
         L5oQzDp+fffODEyujM4OUQrEM5rrltl0Ml8VX/l6T7f901Q/AV0QFVSKtLsonkgqEIX/
         e41FKRB9xmDgc6+zIamtN7+H6WEQ1N959NGzCdZsfK51EZ2Qu4ExdT8X0bq7T1atkVqs
         YWBG+PervZq2iRfZXnzGAmEt5b1NkOs8y10JHX1DR7HLpHgYf7+pD2L4DQBgqbXeq4wY
         EJXA==
X-Forwarded-Encrypted: i=1; AJvYcCUPySnoK/qYwiu9Eb9BZYp6lV9TjZ2P06bH6V9Oh870Pc7hGUUhWHbuh7LkakhS4dqgnvc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyemp3s/VfzyNxsALU4dvHIsEv176va2PXCMyFbZqHpXXiVpCbZ
	KxKss49xmTYGW7ItZhYX+G63LWQvMM2nFWkaHbwDnOvRWl8lcmq9jlUQcWfGl9ojUk8=
X-Gm-Gg: AZuq6aL2eeg5cY5IwRDlyuPeAHDRVag9brQ41uoCFwXXe8YOLkQ0Lj03liI8OckJOOI
	oTIqZnDt1xTL0PLMokZBzrfEXrDj06T2FN4sr8Y17+PYszmrTPdlHIv0DkDLXGyKcbu1gZ8u8X2
	HjfEH4PyRqwz/Ez03Bez8xVTeqZD9N2lxcDLz3ZVkQ6ScOUQEbM41/kVtztACZGdy3Henmn4v0v
	OupMuNYFf54Uh/x/wNXmy8sd0yulZjnlmWSMAjW60H6GMFVWPdcE0yb6hZZNseMPZgo3mK0C0QW
	oYdSWspF+UKWEGWU+Tw2vKzI4J30n+e+a57D1bNIADxNtJDc+dBrRk/dmiX0Qgk+F03h4IIOheR
	20f990Upm1PTHlonRkjWnJZVS+nctDCzqcnd3wlsf+vNMoWuJTt8BVnMIxtcOWpN9PzdSE1X2wJ
	1Dg2QxEkALcgHDVlHgUgv08E7xM3peVibhiBczTGoF1AJzEF9dCUBoGbpVt8i8s0X/7jE=
X-Received: by 2002:a05:622a:1aaa:b0:4f4:d29a:40e7 with SMTP id d75a77b69052e-5061c1c1dc5mr32950871cf.74.1770212124739;
        Wed, 04 Feb 2026 05:35:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5061c17babbsm16346801cf.15.2026.02.04.05.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 05:35:24 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vnd2R-0000000H0ml-1uPP;
	Wed, 04 Feb 2026 09:35:23 -0400
Date: Wed, 4 Feb 2026 09:35:23 -0400
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
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204133523.GD2328995@ziepe.ca>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal>
 <20260204081630.GA6771@unreal>
 <6d5c392b-596b-4341-9992-aa4b26001804@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d5c392b-596b-4341-9992-aa4b26001804@amd.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-70195-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
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
X-Rspamd-Queue-Id: F0AFEE6894
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:54:13AM +0100, Christian König wrote:
> 
> Mhm, sounds like AMDs mail servers never send my last mail out.

Oh :(
 
> As far as I can see all patches have an reviewed-by, I also gave an
> rb on patch #6 (should that mail never got out as well). The
> discussion on patch v5 is just orthogonal I think, the handling was
> there even completely before this patch set.

Leon I guess grab the reviewed-by from this email and we have a full
package if it needs a v8

> For upstreaming as long as the VFIO and infiniband folks don't
> object I would like to take that through the drm-misc branch (like
> every other DMA-buf change).

No issue here, both subsystems are waiting for this..

> So as long as nobody objects I can push that today, but I can't
> promise that Dave/Linus will take it for the 6.20 window.

Sure, thanks, and if it doesn't happen for whatever reason lets just
consider it pending for the next cycle.

Next is to work on the dma mapping type, I should be able to post a
rfc next week for people to look at.

Thanks,
Jason

