Return-Path: <kvm+bounces-6456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 273578322DE
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 02:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B1ED1C21895
	for <lists+kvm@lfdr.de>; Fri, 19 Jan 2024 01:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9D94A07;
	Fri, 19 Jan 2024 01:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmDOijC+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFDA3C2F;
	Fri, 19 Jan 2024 01:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705626526; cv=none; b=tusQwXnw0D8X7gNmPq1MEhQdB5aLre4Rcq5MPoI3nVc/9r5VUVsyH7yl5H72CNJ9YQjF+DmYgAqVWWWPW/pZxykHsOwAw2rHdMPiffu7kb1mI8CTr3UIa4OO51tWw4MzqxrAUQBJdCVYk3sRGoUBPB8VVPPJHtWZq3X0gJLp+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705626526; c=relaxed/simple;
	bh=XDfbcGHP/y28g2YdfPBjeNCJEWD8ii8iInMWhyU8HZc=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CJXh7e6CKS10iQ0fr5Yh7TIjjSt0yVOBTUi44Trnuls2xCKlAN0Pz1YElWRLcwS0NLXikpKBE67YpYAnZoannw19qRnQOqPw2qXAFoh7QDZu7k34XzXyTTj7F8peEWyK/62DtuD8HGUeH7S8EnSSF40QfNTts9hWSQCPJ4ekHOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmDOijC+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id F33B4C433C7;
	Fri, 19 Jan 2024 01:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705626526;
	bh=XDfbcGHP/y28g2YdfPBjeNCJEWD8ii8iInMWhyU8HZc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YmDOijC+fVw7SSodJcAPm23HxgXWdH/M2iMzUXbO1c60MZL33ALJJFtBQgrquF4Hj
	 M24tFVXqmSJPR7gXs+CNwo6JWsHZB8QlyX7jfxsb6p0b8MBNXVU69pxHiu2ID6pyW2
	 ousje6HK8REuNA/ZDFUToxfyt7gSUUnaewmBfgjSoOhEAQ0BTBllplk74N7/Cd4F7v
	 TBi+gB1PvcUSKI+3fc6Vv7w3XEnFu7R6hcgHW6RCd+WpYF5pFfRuRd83gwayI0JrAc
	 G82VGceqWDGiG+W6AqEBNfQqY9yad9n0afCqz1Jzv3UBayupAV7WxXzIgRgEzTa0lW
	 plIHams2MI+gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1110D8C970;
	Fri, 19 Jan 2024 01:08:45 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240116112828-mutt-send-email-mst@kernel.org>
References: <20240116112828-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240116112828-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: f16d65124380ac6de8055c4a8e5373a1043bb09b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0b7359ccddaaa844044c62000734f0cb92ab6310
Message-Id: <170562652591.16604.2931669549259177440.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jan 2024 01:08:45 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, changyuanl@google.com, christophe.jaillet@wanadoo.fr, dtatulea@nvidia.com, eperezma@redhat.com, jasowang@redhat.com, michael.christie@oracle.com, mst@redhat.com, pasha.tatashin@soleen.com, rientjes@google.com, stevensd@chromium.org, tytso@mit.edu, xuanzhuo@linux.alibaba.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 16 Jan 2024 11:28:28 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0b7359ccddaaa844044c62000734f0cb92ab6310

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

