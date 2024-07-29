Return-Path: <kvm+bounces-22528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A680A93FEF4
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 22:16:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 597272842CE
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 20:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75BFB189F27;
	Mon, 29 Jul 2024 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s8noHZtj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C1537708;
	Mon, 29 Jul 2024 20:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722284183; cv=none; b=Gyy46tojhjaHKmfX4hheijGDENYeUaHIJXZZbs+pFK2wPWXG3QqZ7qXtq++kvw2TVOreb7DSOf3yF+bkzA7/mlbtTdqIjZVy4fg6DeYNlXN58ZVDya7UzluOvffODfW3JXjMckeBVD3YTdhQLGbRmiSHXG83p4A6OEskM4evf5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722284183; c=relaxed/simple;
	bh=W6KAHewPqBWvTYeXUfCgX1Srngxie2xftkjBbCQbEF4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=d0YODogvOhoP1owPlwRr5fCfdxNTfcS8fHBu2LuzWU4fU2rFHhjKNV3n4XUIEF+iXkXI3RhuoadcXNw+qOrnou1/APnoNXAoKb2FeqYr+vIvbubnAKAXvy+nrSKh6gCsVxunmSIXNPtoXE9qywHXjq22xnpgOwoFm9iqhr1l6nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s8noHZtj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28276C32786;
	Mon, 29 Jul 2024 20:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722284183;
	bh=W6KAHewPqBWvTYeXUfCgX1Srngxie2xftkjBbCQbEF4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s8noHZtj4DzASuJ0hCImeSNqJ4oIYIvM0G9Ejy0llG7ik/UwAXt3mYcV5QHSt5SE8
	 /Sd95zOMejXL5aT5L/L4iKdXapONFue2IW1ibFX+cmzNUISmHX/4X/JXXcYaox03zF
	 UJyXyCied2UO7WSFKVmKqm7pb3OC3FXDrJCdjTLP6/7zxIqopmd8i79i/TTxPrBWU4
	 S4if9oFBi1AI9NG+4POLOVsRh6gVF2Hn370ggtmmajmNM2AHmXAZcZgBYZvC+ul9Ka
	 Bg3S537620AAIqWqocYyw2kXvgfGMkxlddleZiMcFSgqubG/yL7vNixdQXwHua8s+u
	 LWkPVuU8soQbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1AA73C43445;
	Mon, 29 Jul 2024 20:16:23 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: fixes for rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240728191956-mutt-send-email-mst@kernel.org>
References: <20240728191956-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <netdev.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240728191956-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 6d834691da474ed1c648753d3d3a3ef8379fa1c1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 10826505f52357c7c9e12358db97a3acbe82e958
Message-Id: <172228418309.31709.8455898722757053480.pr-tracker-bot@kernel.org>
Date: Mon, 29 Jul 2024 20:16:23 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, dan.carpenter@linaro.org, jiri@nvidia.com, jiri@resnulli.us, mst@redhat.com, quic_jjohnson@quicinc.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 28 Jul 2024 19:19:56 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/10826505f52357c7c9e12358db97a3acbe82e958

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

