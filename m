Return-Path: <kvm+bounces-459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EED07DFDF3
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 03:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADB40281DFB
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 02:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E64E15B4;
	Fri,  3 Nov 2023 02:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lmGqiI9o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F371119
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 02:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80D14C433C8;
	Fri,  3 Nov 2023 02:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698978024;
	bh=vQG/1KfPyp0tpJGPUCsls9XsSFs6pXv6NJ79Zz0uIFA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=lmGqiI9oI1MiiF1jzGJXLFNv75W4TuIsdyAmLl0LbhmaWE6PH1pOemY5aWo4Gl6De
	 M5CAEUdlNDb0nG5jqDjZmG/QJ3q43D8hE+tBxVbHaf+kLx3zcvxMn49L4u4FyRMHqk
	 whk8XBNJOfq3Nwi+JcrU9F01fEsEjjw1BOWuT8m/a50upO9PbWuV7AB3gmK6jOxQyF
	 1dy59nDUGC7qFboHaFpWwIRsjnvHkgtc5VEytsp3wWShcSRa0JoBTEXqBCw3tJSeJc
	 VhmbBdgEbX4jevOzHHeYVDjzahgkf3nrS9pS9URQ6I4cRVg4Lj6mpUy+bSmVYWfH5P
	 92Qfw3lfqEITg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64B79EAB08B;
	Fri,  3 Nov 2023 02:20:24 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.7 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231102172917.142863-1-pbonzini@redhat.com>
References: <20231102172917.142863-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231102172917.142863-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 45b890f7689eb0aba454fc5831d2d79763781677
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6803bd7956ca8fc43069c2e42016f17f3c2fbf30
Message-Id: <169897802435.29625.14357865463439364819.pr-tracker-bot@kernel.org>
Date: Fri, 03 Nov 2023 02:20:24 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  2 Nov 2023 13:29:17 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6803bd7956ca8fc43069c2e42016f17f3c2fbf30

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

