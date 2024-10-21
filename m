Return-Path: <kvm+bounces-29303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A080F9A724C
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 20:28:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30AA3B234BF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 18:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4737F1FB3E0;
	Mon, 21 Oct 2024 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDhLY6TC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F2F1F943D;
	Mon, 21 Oct 2024 18:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729535259; cv=none; b=VRRNrgn1gU3yEwEz7EYQrpE4WGUE9ZfAzBLICOlG6dZk8aLO6rL3jdTFE0VGnlMTo+LnFx3El/rzvIrQ0nEFOnYxYdR3iPaftnWYj0kJJjS4v7k0d3lRw6inWBQ67Fp509Q5+gqFTRhHGmdhvlEgbkJbr3e9RKrDqr6Pib1iU0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729535259; c=relaxed/simple;
	bh=d7JiMxq0Q/PHaiQfnDHkr+cbd/mQ+55F4E1gHyDw1Cs=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VRqbNG77npi0RIJMnwnBCMwuMCHrZoL52XkLL4PD8PT+89k/lNZvTiqww0jOCMi9ZQG84hJvKCueTJ4w2Tn81KPoWWi+wxKel4pCANeChIFLwcCcB+HxIj0IglNPNaJenyTMoYtwlAcSo528b+IEJZEdtNrrjYj193CGttjnKHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDhLY6TC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002E2C4CEC7;
	Mon, 21 Oct 2024 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729535259;
	bh=d7JiMxq0Q/PHaiQfnDHkr+cbd/mQ+55F4E1gHyDw1Cs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=NDhLY6TClL4uRjiqkw1u67sGNBRBaf+g4n333OLBZ4RzD7UVYEQ8dnZjpNx44dTbo
	 u+Sk44KWZv8dAt/ruZl3CDLZzQnmFLIgqHYF2EvyyPotMI3+YYh8qxgPEWK3j26xNt
	 aan5JQUx25ImmRTKLHgGG3ccZuR9vux+/c73gd9KnAX3NmHskPqOxBa2mJo47hiYgZ
	 BdYMXaFEKOPhpfHgQ5ydyp2iISxWzz+EIQeavGQTopAk12m9HjKN3aKSHeoOjhY9L1
	 1eHrscS6y6ZOG6/zjfGn+Psb9Ju/IquvyposThDbsi9akpKyvKNUMnrkrOw0GigM2S
	 rEVkaBeSJMu8w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 359A23809A8A;
	Mon, 21 Oct 2024 18:27:46 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.12-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241021171728.274997-1-pbonzini@redhat.com>
References: <20241021171728.274997-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241021171728.274997-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e9001a382fa2c256229adc68d55212028b01d515
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d129377639907fce7e0a27990e590e4661d3ee02
Message-Id: <172953526462.401524.15967453300022660637.pr-tracker-bot@kernel.org>
Date: Mon, 21 Oct 2024 18:27:44 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 21 Oct 2024 13:17:28 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d129377639907fce7e0a27990e590e4661d3ee02

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

