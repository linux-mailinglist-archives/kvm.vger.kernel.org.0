Return-Path: <kvm+bounces-54922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF154B2B2AE
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F3AC18981B4
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED38D271462;
	Mon, 18 Aug 2025 20:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ea/5Op6Y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080C82356B9;
	Mon, 18 Aug 2025 20:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755549869; cv=none; b=S1Wv1S7gZiZYD3JHZ3ui34oP2InB87cbskkcrZ5aWKBevLjCspBrsoaU4MCjvJMb+D6ZrLX5S19ULO9BJU9hq2h12JKc0/++dLuMAFDutPBh3rj1gUejDohkQ2qC+rvi02NicvqT9tOyBSwgKuAUJI6YAV7x9aQO7oPLflZFHsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755549869; c=relaxed/simple;
	bh=ei8U9Qa2kHPZ45JCS9YCU7DNd0J2meh6z8WTCeINIo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMMVkYeaiOVSecOZV14vitnJurOQjbVE3i+ecUeLGln+wu7t5681V5UtyEuTgCxg3wAKgOzHG/fnKAf4M++rBuFZ7Y3Q1WeZ1R7P6JEePl+g+mIUGUt1KOQLTeMUdY7r+uYMy79DpgiVDBcf6BlYdlBgk2reck75iXqIOwNDOkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ea/5Op6Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15516C4CEEB;
	Mon, 18 Aug 2025 20:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755549868;
	bh=ei8U9Qa2kHPZ45JCS9YCU7DNd0J2meh6z8WTCeINIo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ea/5Op6Yr0qPdz49hQ27fRSXuiaUFiJre7DYcaG/myqR2j+8IVCtz92DcHcgDWrYa
	 KpdVxoeFHV4vqkWM7oOEsaJnTb4NyhP/sHQ7PqFGau54U5N97nTp9RXQHQ/0KyKNd1
	 6vSJfMFwJRxnXWd7pbgPE7xpDLi1lJoWKy3wcXI05sbbyUR+HIOCUURbWCq9bl6ZzX
	 ZdzNEWSgQ4LNs5eosf/RCQDxjuJWXstsm4FigGPeZbU+8BQyLGLG2fffqMzzw9RFE8
	 kMhnT8aC9cSxkQWrDPraopjbu93VcVyJFWwxnSEK+veSx8VOZvklS0W+fsWp9Fu2Ka
	 EgzarMC24YzgQ==
Date: Mon, 18 Aug 2025 17:44:25 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] vhost: perf tools build error after syncing vhost.h
Message-ID: <aKOQqaoGVwpS1HSb@x1>
References: <aKOLrqklBb9jdSxF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aKOLrqklBb9jdSxF@google.com>

On Mon, Aug 18, 2025 at 01:23:10PM -0700, Namhyung Kim wrote:
> Hello,
> 
> I was sync'ing perf tools copy of kernel sources to apply recent
> changes.  But there's a build error when it converts vhost ioctl
> commands due to a conflicting slot like below.

I haven't looked at this specific case in detail, but in the past the
synchronization of tools/ copies did catch things like this, yes :-)

- Arnaldo
 
>   In file included from trace/beauty/ioctl.c:93:
>   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c: In function ‘ioctl__scnprintf_vhost_virtio_cmd’:
>   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: error: initialized field overwritten [-Werror=override-init]
>      36 |         [0x83] = "SET_FORK_FROM_OWNER",
>         |                  ^~~~~~~~~~~~~~~~~~~~~
>   tools/perf/trace/beauty/generated/ioctl/vhost_virtio_ioctl_array.c:36:18: note: (near initialization for ‘vhost_virtio_ioctl_cmds[131]’)
>   
> I think the following changes both added entries to 0x83.
> 
>   7d9896e9f6d02d8a vhost: Reintroduce kthread API and add mode selection
>   333c515d189657c9 vhost-net: allow configuring extended features
> 
> The below patch fixes it for me.
> 
> Thanks,
> Namhyung
> 
> 
> ---8<---
> diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> index 283348b64af9ac59..c57674a6aa0dbbea 100644
> --- a/include/uapi/linux/vhost.h
> +++ b/include/uapi/linux/vhost.h
> @@ -260,7 +260,7 @@
>   * When fork_owner is set to VHOST_FORK_OWNER_KTHREAD:
>   *   - Vhost will create vhost workers as kernel threads.
>   */
> -#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x83, __u8)
> +#define VHOST_SET_FORK_FROM_OWNER _IOW(VHOST_VIRTIO, 0x84, __u8)
>  
>  /**
>   * VHOST_GET_FORK_OWNER - Get the current fork_owner flag for the vhost device.
> @@ -268,6 +268,6 @@
>   *
>   * @return: An 8-bit value indicating the current thread mode.
>   */
> -#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x84, __u8)
> +#define VHOST_GET_FORK_FROM_OWNER _IOR(VHOST_VIRTIO, 0x85, __u8)
>  
>  #endif

