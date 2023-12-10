Return-Path: <kvm+bounces-4005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5F180BCAF
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 20:12:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC1C61F20F35
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 19:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FBB1BDF9;
	Sun, 10 Dec 2023 19:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If1aQRS2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DD11B290
	for <kvm@vger.kernel.org>; Sun, 10 Dec 2023 19:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04EB7C433C8;
	Sun, 10 Dec 2023 19:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702235538;
	bh=OBgho9S8DE+BbMJEFCO6gAmVLt74G8J0r8T1zE2Ai9w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=If1aQRS2zGoMU/gA+8Sf7nELMNAq/K4oJJCtMJ0v/U3+a2S4uMLl9pgoqtDZ0etbL
	 uvIx1JbwJ1JSyHJsPBixaleFr+Q+zhl2F5D/9cWQv0CUQWX/tGwGVg8Ol677pXQhaV
	 OwQqKu2pX7PP5EnEH0v8mFrI0kaXyGvJ5N9PckQuQrqqqCyBPfHnnNHHehrcW0/wqF
	 o+g7VYD67kmoF7Uh0oj7F0MkJi+RWxGuzhhE92bTwbQSaFApWPQF3BRmB9OpM9Zfyx
	 +N3YCFHwIV4ZZ6SnjMNK9agmRdcNxmJZXqhP/M9ISNUagb9bpQQyi/ZtVtLNm6o3JM
	 HaKTVB8HBLoog==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6B4BC04E32;
	Sun, 10 Dec 2023 19:12:17 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.7-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20231210110101.2435586-1-pbonzini@redhat.com>
References: <20231210110101.2435586-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231210110101.2435586-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 4cdf351d3630a640ab6a05721ef055b9df62277f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0aea22c7ab05f9dfebbccf265a399331435b8938
Message-Id: <170223553793.2016.2840443282804935759.pr-tracker-bot@kernel.org>
Date: Sun, 10 Dec 2023 19:12:17 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 10 Dec 2023 06:01:01 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0aea22c7ab05f9dfebbccf265a399331435b8938

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

