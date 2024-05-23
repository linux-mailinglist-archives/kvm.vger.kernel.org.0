Return-Path: <kvm+bounces-18078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F32B68CDAD9
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 21:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9079FB232C9
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 19:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4575183CDC;
	Thu, 23 May 2024 19:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ax57mVbZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B30DEC7;
	Thu, 23 May 2024 19:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716492483; cv=none; b=Z5VMO/mPTML7ZKylJZBCP5oTb1jPQMC7Y8XAfVVlWetAqQpC8uwAr1821ekW8TGIr3UJqwBhgvnoPM3ZFrMXQ88EWSOFavyB8RPr4NC8isoFjJ/zYh6Klby4ErPOdorD5naa8m5gVx7HbOjvdphpVgGjghVADfI7zJ4Dy/sZY04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716492483; c=relaxed/simple;
	bh=tvcn4t4beKheL9H/x+fSj1XLbpUqByppEr7H5kgRrHU=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nk83haDazzwFtAur6QG/Cp1VO03SFcHAw7Ykx8ODRweCPjiG5Hj86t7epV5OohLSlcCI4lFF3AybxjXoyNS09vApAKE9vSjXwKSQdMb+t0v8x5Sha+QeT0wd7hWsRRy7/CaKkoNvlUr//J6NARI2ijnCJtBekRT3Txly3ZureH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ax57mVbZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3AC84C2BD10;
	Thu, 23 May 2024 19:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716492483;
	bh=tvcn4t4beKheL9H/x+fSj1XLbpUqByppEr7H5kgRrHU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ax57mVbZ01Feg1Y+eRtIEc0Bpwsir089k06Zmh/FcSPpS8nvNs0Im9fHm9hOW/Ixl
	 3LSVrx/zSjsOaK1HCNbcA4CiDEGSRYP5CFRXeuaoj3UlBr9L8i4035q1rvYG33e1Ea
	 1gyM8KBI+TT+xDa8OL9TvJgIOtxEoHdBARgFi7zGGs3SzRQ1/krryGguCiqMPDccHd
	 DNXf9As4IOkVdyA0+HoHnH4Q6BDh4YPD6YhZzQ/sVprEtYsczcIVwlkHSqHrkxzuYm
	 WMjX9U6ccgYQrAEUuEdMZzPHQvi73DuE+htx2gVTu+512Jm5IFSe6wRSn020anRKTb
	 5XUmBuW5vQUTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 281E9C43617;
	Thu, 23 May 2024 19:28:03 +0000 (UTC)
Subject: Re: [GIT PULL v2] virtio: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <Zk7bX3XlEWtaPbxZ@redhat.com>
References: <Zk7bX3XlEWtaPbxZ@redhat.com>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <Zk7bX3XlEWtaPbxZ@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: c8fae27d141a32a1624d0d0d5419d94252824498
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2ef32ad2241340565c35baf77fc95053c84eeeb0
Message-Id: <171649248315.6115.15871807359949037854.pr-tracker-bot@kernel.org>
Date: Thu, 23 May 2024 19:28:03 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anton.yakovlev@opensynergy.com, bartosz.golaszewski@linaro.org, christophe.jaillet@wanadoo.fr, dave.jiang@intel.com, david@redhat.com, eperezma@redhat.com, herbert@gondor.apana.org.au, jasowang@redhat.com, jiri@nvidia.com, jiri@resnulli.us, johannes@sipsolutions.net, krzysztof.kozlowski@linaro.org, lingshan.zhu@intel.com, linus.walleij@linaro.org, lizhijian@fujitsu.com, martin.petersen@oracle.com, maxime.coquelin@redhat.com, michael.christie@oracle.com, mst@redhat.com, sgarzare@redhat.com, stevensd@chromium.org, sudeep.holla@arm.com, syzbot+98edc2df894917b3431f@syzkaller.appspotmail.com, u.kleine-koenig@pengutronix.de, viresh.kumar@linaro.org, xuanzhuo@linux.alibaba.com, yuxue.liu@jaguarmicro.com, zhanglikernel@gmail.com, Srujana Challa <schalla@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 23 May 2024 02:00:17 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2ef32ad2241340565c35baf77fc95053c84eeeb0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

