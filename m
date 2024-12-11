Return-Path: <kvm+bounces-33519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B28809ED97E
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:20:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94FB82823DA
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25BA1F0E46;
	Wed, 11 Dec 2024 22:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BEGJ+njA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A2A1A841F;
	Wed, 11 Dec 2024 22:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955601; cv=none; b=TT0WmDBqL9d0l4Ud+iQyJwF1lWghIIEkxvO5mj6LulSaUzH0x4kBsdOWGyEV77tY9FuxGsLWCcxkruyeNDDZrU5QSf3pTnH3qWUnJb8CsafYrlr8gOeWOok7HZdw8iEGBzTHeEu9wirEj72ApR7XONiIovJ8pMMzm4WTr8khFIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955601; c=relaxed/simple;
	bh=eSYCGPK4PvAqsXZyCXWW12lbDf1VapALJ3PXGKc5DrM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Qnvof6nz8+ffQBjN+OrfNvh5t5mQ1ZmtZlFiCUAgFCPoXgPzFOQIWTGewuNqWuaTNJHK7ZobWBuu9vHG7SVT7s5VBJWCZrJlHL1eb2/FYzsbBUJZ6iIcQeuqHNtipk9uN9AmYa6hicVS29uOmMVbfM9qh+49eLpv2h4HdiXm0so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BEGJ+njA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB085C4CED2;
	Wed, 11 Dec 2024 22:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733955600;
	bh=eSYCGPK4PvAqsXZyCXWW12lbDf1VapALJ3PXGKc5DrM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=BEGJ+njAEO8C7LvpUoeznO45Hnr7lQvxC8H3U8ckhugo0k3qydoOtfxqpAU7p+zMl
	 UljpyYQzv03OnJ6RmMU/xunHyNRpPWUaoS0zRf2DkDPm8M2tNo0C/XypxK6S7cq2wD
	 vLF6uCegajLFdQKEm6kIMIARAy08ikDEiPSYtHAE8jMlLEeuJRVgfkzjFMz7Tc7Fcm
	 dp0cfwbDREfK7fSHOtI0jn+OJ94pvbgCZGbG739sPMhcOdQyaIUi3x1L0jyDHzXJTM
	 6VRzrZPPK7UoWjzdOXn4SxP8IzdHbmlkhXrSiJHYVk4j5e9i7WpVDaRS4/fG6Rx63U
	 QjW9z4aFIPKCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB3E2380A965;
	Wed, 11 Dec 2024 22:20:17 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.13-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241211134543.715454ea.alex.williamson@redhat.com>
References: <20241211134543.715454ea.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241211134543.715454ea.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc3
X-PR-Tracked-Commit-Id: 9c7c5430bca36e9636eabbba0b3b53251479c7ab
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ec8e2d3889114f41d07cd341e80dc6de7f8eb213
Message-Id: <173395561660.1747277.12280886869001491637.pr-tracker-bot@kernel.org>
Date: Wed, 11 Dec 2024 22:20:16 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Yishai Hadas <yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 11 Dec 2024 13:45:43 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.13-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ec8e2d3889114f41d07cd341e80dc6de7f8eb213

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

