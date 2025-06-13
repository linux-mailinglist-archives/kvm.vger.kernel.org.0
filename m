Return-Path: <kvm+bounces-49471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25230AD9426
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBAAC17E942
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 18:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98ADA239581;
	Fri, 13 Jun 2025 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cDr+L3Mr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2DD22F74F;
	Fri, 13 Jun 2025 18:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749837867; cv=none; b=Z/yLLi52THCtRwXxJXeJ9xU6n2X3WGAvrOCnsGfzPjCLBJfdK0sHYjjtHDODz4+jToWLQExhbrKjZa7nemdaSVD6nIv/LdKanHva7dUZymma0UPxrvagngydmNjrrzBNC64ygcT1NuDQ0z1PyOrt8JP+nCbxrVkwbn26Pcuav9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749837867; c=relaxed/simple;
	bh=DzM+I6K1KaI2aN9uRbIZ3vJ7S5jaXugsoGam+IqJYcQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=fenUyPPo5Db2ySN220XxsLLoyIQsUABNotEveBYJlmC6TjYLawhrEZkHuMK76wU+zido9T24sf+LKHelGwb9+S/N7xkZGSc/Ti8DHJunEdsuE9lgM5SJcWd/wZJh2Xq3hR1aynLf2aACY9HP58r2oKdwl/IL8aPhHvA427QkAqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cDr+L3Mr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A2ACC4CEE3;
	Fri, 13 Jun 2025 18:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749837867;
	bh=DzM+I6K1KaI2aN9uRbIZ3vJ7S5jaXugsoGam+IqJYcQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cDr+L3MrsZsRByI+b1O642Z5ia1Uwj+5oxqvDM/767iNlsAvVdQRHzdSIttq7Ziws
	 i+18P4NJQ1CfMXo2KIvl2aOqXJATsuiFSySS1csHuWS550vmQFjf8+4FRjsiiyM505
	 WH9e/inDmcaHTIH0YxsGKaMcH+l/FSDFGVJe12ubFAToAFVEKF7jnZcPOizYERo0/o
	 5iUUF23rj8MotuQV7O2vqq2bRUAkh4Xu2t2yoqqL2B2LweLg2M9VjTGgb6bjRYqIt5
	 NDK2951WnoYKjrCugJV26Xhajm5xAFc1TYGoW9VGCAzXgtwuQdPSiatVFRoirO9E/n
	 ZQ9gNC/bKSVSg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CB4380AAD0;
	Fri, 13 Jun 2025 18:04:58 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.16-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250613164603.163319-1-pbonzini@redhat.com>
References: <20250613164603.163319-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250613164603.163319-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8046d29dde17002523f94d3e6e0ebe486ce52166
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dde63797055cf3615bdac744d641e19e165467bb
Message-Id: <174983789685.834702.16014820427450041694.pr-tracker-bot@kernel.org>
Date: Fri, 13 Jun 2025 18:04:56 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 13 Jun 2025 12:46:03 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dde63797055cf3615bdac744d641e19e165467bb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

