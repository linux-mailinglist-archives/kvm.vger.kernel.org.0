Return-Path: <kvm+bounces-49694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 28ADFADC957
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 13:29:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C98A3177B20
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C53E2DBF70;
	Tue, 17 Jun 2025 11:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIq6CVk8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5B528C5D9;
	Tue, 17 Jun 2025 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750159733; cv=none; b=Jmy1bzWlsaxj8XKyi2L9Ec1PfbmgP4NX7bPSHcQ3c1PUApXd26ZA2/HSgdNnYX7j/pHX7o653oG8LKdnrxt5C3OmWNKUM3/EgKG09C2kK7sp3eqUSHHt2SJVIbKyC6wXBZY+pTjZDM3XXD1AKCobth69/CmZOTe/k5oA3THPWQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750159733; c=relaxed/simple;
	bh=0dx58dAXWwLSFLPZaNvW7pvmSE1ntlszBFTVF+qcWQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSEG9KxAdWIzTcbRfx8P9sPUJEtXHjzcIBVjDgz3xT+pMCMFvItC9jJ5EjfzOMqwlzC7KJkEN1nDfBOjz96HSIFOdC5wvbrQlYiaqYt98Vu8wORPVhxC6GoYx70ts31UQ7yaa7UNKSUQGsbw/egL5LGrMOiJAB7ZyqKa4S3ab0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIq6CVk8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC5AC4CEE3;
	Tue, 17 Jun 2025 11:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750159732;
	bh=0dx58dAXWwLSFLPZaNvW7pvmSE1ntlszBFTVF+qcWQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIq6CVk8N0iIuFVEGfCkEndeu5tRBIf5o+cjPO/B5l60Jqme8QH4k8RFs3q3gtxmE
	 ZHUupVWP5nUsVPIr67xiGQBwAO2oBezz0rqPks2hdfqh2ECyQEA/bUzvk8kOCytwm8
	 RA+WmEToPVAT7/4ql6iBRZeC2/eTq0nz6WUBQfr412qqIxU7mK4ragtM37QCZdsKkR
	 xFLpGoBhAyjIncDvnmgoG2tKgH4OxE2A2FzkD4KIeVqEpNUQpa5V9uWSxJZ/y0Ixhk
	 oGNoOgGwmtigAw62yQgcqIa9MnsqAjXe2bIBSKuNfGFZBQBSgH4W5WuhZGy7Iyo28H
	 sAQP0VtA6pdQQ==
Date: Tue, 17 Jun 2025 12:28:49 +0100
From: Simon Horman <horms@kernel.org>
To: linux@treblig.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] vhost: vringh: Remove unused functions
Message-ID: <20250617112849.GH5000@horms.kernel.org>
References: <20250617001838.114457-1-linux@treblig.org>
 <20250617001838.114457-3-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617001838.114457-3-linux@treblig.org>

On Tue, Jun 17, 2025 at 01:18:37AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> The functions:
>   vringh_abandon_kern()
>   vringh_abandon_user()
>   vringh_iov_pull_kern() and
>   vringh_iov_push_kern()
> were all added in 2013 by
> commit f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> but have remained unused.
> 
> Remove them and the two helper functions they used.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Thanks for the update.

Reviewed-by: Simon Horman <horms@kernel.org>


