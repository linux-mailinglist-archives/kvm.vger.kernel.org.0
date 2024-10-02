Return-Path: <kvm+bounces-27802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0914E98DA6E
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B49CC1F2182E
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9F5B1D1F4E;
	Wed,  2 Oct 2024 14:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwWY+ofT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72051D0E3A;
	Wed,  2 Oct 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878563; cv=none; b=YCV1qdVDarpBo7BVeON/r9oJHoSWj68HQ1gaVNFrw3kaaa9nnjvsLMbpl8FkAlvAwCI3kZOC01Y4HnupnA+qMxq2XgXLTk0Xl9avNg3X58GFm1z3Zeun/MzLvOTZChMLeWIQD69ixFwLzmAaet7+EAkABwk0wk5d1D5FH8Nw/Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878563; c=relaxed/simple;
	bh=yT+r31n70xCHi9EJMEKqCQB+IFdPVXH1wU6lHdxyhaY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ogxHdMhTT84wJPaGovU94l/nH2soRBbyVKJdFG1+jGT2QZQEdGhLNWV57ABx6ohkzABdiyL6V1OGYcfWoRU6eXfji2AzI3ErrVH3IiH+HUz3zr83dqPocPq7vOCi0vd1Tw2g90xGvV2MXbxRbUYNp9mSkMfVWLH/kJy798RGbCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwWY+ofT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFEAC4CEC5;
	Wed,  2 Oct 2024 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727878563;
	bh=yT+r31n70xCHi9EJMEKqCQB+IFdPVXH1wU6lHdxyhaY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EwWY+ofTD1RSYoGGOL6Vcvz9EuF+qNPMnvZDH48oUuKzgPank5dJBlTdcWuZQjeQx
	 RPK7QrHcfjLn4OhDBF1x6E8qByaJqxsXwu5RVXAV238lE2ev/IrSEp7z/kgTWzuwsJ
	 iBUBL9pao1WJXmUH5P8USJ/xE0zO/Y3pvfFBUItQGXhNEoKN9SwCrSyZHvZKJyVtZ3
	 aE3JUqnZi4SvXAjlPc/BvFJeMzQA8q9uwImceqlGnxE8Nm8uOg38gvA6aeMwn6h+R+
	 nKv5rZQ2CPdKemFAu7st/jNezRO0kbukwY0dwNNQFaaFMzxuow6TsqtmQ7f9vN4sgG
	 B0xvu5FSWOuGw==
Date: Wed, 2 Oct 2024 07:16:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, stefanha@redhat.com, "Michael
 S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Eugenio
 =?UTF-8?B?UMOpcmV6?= <eperezma@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, mcgrof@kernel.org
Subject: Re: [PATCH v2] vhost/vsock: specify module version
Message-ID: <20241002071602.793d3e2d@kernel.org>
In-Reply-To: <CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
References: <20240929182103.21882-1-aleksandr.mikhalitsyn@canonical.com>
	<w3fc6fwdwaakygtoktjzavm4vsqq2ks3lnznyfcouesuu7cqog@uiq3y4gjj5m3>
	<CAEivzxe6MJWMPCYy1TEkp9fsvVMuoUu-k5XOt+hWg4rKR57qTw@mail.gmail.com>
	<ib52jo3gqsdmr23lpmsipytbxhecwvmjbjlgiw5ygwlbwletlu@rvuyibtxezwl>
	<CAEivzxdP+7q9vDk-0V8tPuCo1mFw92jVx0u3B8jkyYKv8sLcdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Sep 2024 19:03:52 +0200 Aleksandr Mikhalitsyn wrote:
> > At this point my question is, should we solve the problem higher and
> > show all the modules in /sys/modules, either way?  
> 
> Probably, yes. We can ask Luis Chamberlain's opinion on this one.
> 
> +cc Luis Chamberlain <mcgrof@kernel.org>
> 
> >
> > Your use case makes sense to me, so that we could try something like
> > that, but obviously it requires more work I think.  
> 
> I personally am pretty happy to do more work on the generic side if
> it's really valuable
> for other use cases and folks support the idea.

IMHO a generic solution would be much better. I can't help but feel
like exposing an arbitrary version to get the module to show up in 
sysfs is a hack.

IIUC the list of built in modules is available in
/lib/modules/*/modules.builtin, the user space can't read that?

