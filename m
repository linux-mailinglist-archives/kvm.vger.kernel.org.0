Return-Path: <kvm+bounces-32607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A78869DAF04
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:40:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19DA1B21E6F
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E15320370D;
	Wed, 27 Nov 2024 21:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4Y8TeTj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43B20010A;
	Wed, 27 Nov 2024 21:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732743627; cv=none; b=dfAHJDea38nr7NwWgdEpszssjqzieSns0JMO6t/rOQ1I5UcRWo/nTTTB1nTHAtfeBD7Di6eoStGU4gIWJoM2R7jLvPPeLxqd14Er0De0Q6y5KuOZzgp0g6tcLqXHqvptSlaTFikkybfCD8D4JTI6OdE84G5/+TQHeJAfqKXzqXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732743627; c=relaxed/simple;
	bh=fU3yQoPBUwwHe11Y/r/SWLKZYVkaYtuYawhFhhwo+jM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=eEpfS/5x0VAMvb2hx8/BZetc0rCTCsfLp/uH6vAkrG8Uis2gGqXp45xanO2JmwPs4fRQMXMZOjdH6TRnARIJ69mDxdQzNEZyydbT5+5uXrK23cnQ1+n6Iwx/7DxUpZ9wFJfPaFrnIj/5Yi7u1gli80pZHojjV5BRQyZBY3JfOgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4Y8TeTj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D683C4CECC;
	Wed, 27 Nov 2024 21:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732743626;
	bh=fU3yQoPBUwwHe11Y/r/SWLKZYVkaYtuYawhFhhwo+jM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Y4Y8TeTjNUGN3Sx5K8/Eo7H+w2r6PTxa72WY8eSOXjtUxg7DUNJzN45odT+hNE4tc
	 Vrt/T0xdFXoTokrpaxYG4xrHE2gZbFyACNyhZa14/bEwE05T29JI4gsavXJNqloYNO
	 zqCPmj9j6Efmru0zw1bB2xSZctmedgG4zG/r4PArCVy2EuNYBOPMzN1E2BE0odw/r+
	 fLlEOGMSn++wn24wZxyEGoxa/2CmGDiCDOPjXkEpusSb51Jl4W6YyYQCUzByf5WKop
	 C4EjpdnLLsg/BieimgniXSw5cTnWl3BUvzP3at1SYbCbyViqyODMfUzZDgqN4d8WLT
	 UCst6BuDDJGlQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 79D65380A944;
	Wed, 27 Nov 2024 21:40:40 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241126163144-mutt-send-email-mst@kernel.org>
References: <20241126163144-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <virtualization.lists.linux.dev>
X-PR-Tracked-Message-Id: <20241126163144-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 6a39bb15b3d1c355ab198d41f9590379d734f0bb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2a50b1e766a09f1a2da5f291956b8dceb58b5d54
Message-Id: <173274364003.1220377.12173502747975037192.pr-tracker-bot@kernel.org>
Date: Wed, 27 Nov 2024 21:40:40 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, colin.i.king@gmail.com, dtatulea@nvidia.com, eperezma@redhat.com, huangwenyu1998@gmail.com, jasowang@redhat.com, mgurtovoy@nvidia.com, mst@redhat.com, philipchen@chromium.org, si-wei.liu@oracle.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 26 Nov 2024 16:31:44 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2a50b1e766a09f1a2da5f291956b8dceb58b5d54

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

