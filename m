Return-Path: <kvm+bounces-49615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C0BADB184
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 15:18:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59D05188C812
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A03B2E92B9;
	Mon, 16 Jun 2025 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hrDQxP9M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADB92E06EE;
	Mon, 16 Jun 2025 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750079774; cv=none; b=HXxmhtr3x/4Aj2OupQ3JIi8P5NwwNXpupSM5gRHv+m7aFRVKIvpQegAimW4e0fiy1ng6Z+gspUY4NVwv8wgZ/iivA8kBOPgonI6vupb5lqv15GxAcSD+CJxthfMmmuE2UvI5tc1NpMWFP6jO90mVF03u7ZFxayO9YfKY3Q2Voo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750079774; c=relaxed/simple;
	bh=ijos+ZXc+kb+My9+MNdhO2s8PVtsN3Qz0nVOwY+r3rY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMPCmM32ye0CGw79HQQ4a7t2v2fhbM/Vh1E+lOOlRb0RnvUGMK0dk7DmrICzbmqCwJuSGK4jw1xbPiUyccR2lIPGzvvhC8ayZNf9Hbl2yY+wf02vU2yFlOuGTm33ujkKdCo92ntdFaCTz7RSNikUo+tUEZZ6p0qRFgc7wGnLagA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hrDQxP9M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48B1C4CEEA;
	Mon, 16 Jun 2025 13:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750079773;
	bh=ijos+ZXc+kb+My9+MNdhO2s8PVtsN3Qz0nVOwY+r3rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hrDQxP9MmH8s6HR9OXT17iQAC8iM272kzT96lZl6NZElnNtIVMIRMPVMk8ekuxz/n
	 8oamRo930IM0NQuz2qze3J/IhhQ2SU3glyw7mk2zjfaiLdxkPPP4PzjaNwsC4MgwWs
	 5pzQS3Sa1thr1vPK8WWx6pts5q0hv0ucB1eNjYq0M0qPkgpTfPs9GsF+u4u+FF3IrG
	 c6chvBW+YT96A5Z55M6J+IlFMABwieid72nBmZvKJVuNn8hi4+vi5yLTXEm3oinqtg
	 8PuwVqO7djWQesvBq/1JgFAPtSJHbCInUc5AWdB7E64nfNDgYZshB52b+k9hLusW+k
	 gTel9JlWE7MOA==
Date: Mon, 16 Jun 2025 14:16:09 +0100
From: Simon Horman <horms@kernel.org>
To: linux@treblig.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost: vringh: Remove unused iotlb functions
Message-ID: <20250616131609.GC4750@horms.kernel.org>
References: <20250613230731.573512-1-linux@treblig.org>
 <20250613230731.573512-2-linux@treblig.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613230731.573512-2-linux@treblig.org>

On Sat, Jun 14, 2025 at 12:07:30AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> The functions:
>   vringh_abandon_iotlb()
>   vringh_notify_disable_iotlb() and
>   vringh_notify_enable_iotlb()
> 
> were added in 2020 by
> commit 9ad9c49cfe97 ("vringh: IOTLB support")
> but have remained unused.
> 
> Remove them.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Simon Horman <horms@kernel.org>


