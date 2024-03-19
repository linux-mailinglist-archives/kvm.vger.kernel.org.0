Return-Path: <kvm+bounces-12162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A83788025B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 17:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3A711F2263C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 16:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1741C12B72;
	Tue, 19 Mar 2024 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqafG1FO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331EA111B1;
	Tue, 19 Mar 2024 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710865935; cv=none; b=gY6CXYlJWaxKdAtOcm/PkzRW7jgJPR5fpZvn4pLhRd9N06ugPMDjCBnnpH6IN1NtkTPacPxr3pmgwlymulI/ft18Iw3nlL75WT7zr74S93nzBsvPioae9PPEvnSzf+1PaHGz82bEZNegv3TlRzLq2ouKRsUnY0dMTAdlAdAPFp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710865935; c=relaxed/simple;
	bh=dlwS+ClYwtdCIhyRMHsdbtRf3zIzcBodhDuKwd+a6r4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=r7IxgF+Dkjbt773U4ZKBYABdLFEvZSX3mG7IUULFXhJaoGg9/Mejg00g8H7uR6HLMUhdrEMynLMOa4DaXoyBM92elM+k7zUbGUf9z5JAooqQJ8zdzrqrHzPfuGkbcnAFa0RCVnCK+tqJY/lJ9YqfiQZdSCT5Ys/YnSk479oM9VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqafG1FO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07641C433C7;
	Tue, 19 Mar 2024 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710865935;
	bh=dlwS+ClYwtdCIhyRMHsdbtRf3zIzcBodhDuKwd+a6r4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KqafG1FOkpQ1tdSHmOM60N3qo+kOfsYOfMeSna55txX+1i+AeJRYBB0RLCBBwOJdA
	 P8Zl+dfevApg/fTIQzEwgyrWb/g2LivLHaHjVjnZFHXDxLpRR2hihs7OGrSZFFdDZu
	 e5szhg4Z+P6J0PAnAVAfHnj08LTiNzpKMxgC3V17cKU2TMawKIrDohePcxHoPclan9
	 sWVA46+AnWm6O7WR0Mlcw01n+EU7qeyguE34jiW1OrK+VUxpCQkbTmaph2xrv0bs8s
	 Y6KXl7cKjswa3L4uxlA+jknT5YRY0Woznmtz8Ldre8Uh75/h0QYeGzPWtD9aVospJA
	 P6DpI9lV8tBtA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1E92D84BB3;
	Tue, 19 Mar 2024 16:32:14 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240319034143-mutt-send-email-mst@kernel.org>
References: <20240319034143-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240319034143-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 5da7137de79ca6ffae3ace77050588cdf5263d33
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d95fcdf4961d27a3d17e5c7728367197adc89b8d
Message-Id: <171086593498.7768.14462757833782378841.pr-tracker-bot@kernel.org>
Date: Tue, 19 Mar 2024 16:32:14 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, andrew@daynix.com, david@redhat.com, dtatulea@nvidia.com, eperezma@redhat.com, feliu@nvidia.com, gregkh@linuxfoundation.org, jasowang@redhat.com, jean-philippe@linaro.org, jonah.palmer@oracle.com, leiyang@redhat.com, lingshan.zhu@intel.com, maxime.coquelin@redhat.com, mst@redhat.com, ricardo@marliere.net, shannon.nelson@amd.com, stable@kernel.org, steven.sistare@oracle.com, suzuki.poulose@arm.com, xuanzhuo@linux.alibaba.com, yishaih@nvidia.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 19 Mar 2024 03:41:43 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d95fcdf4961d27a3d17e5c7728367197adc89b8d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

