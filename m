Return-Path: <kvm+bounces-62545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 85E43C4867E
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:45:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0C61188FD90
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 17:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8092DEA6F;
	Mon, 10 Nov 2025 17:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUnCrNVH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEAD255E26;
	Mon, 10 Nov 2025 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762796691; cv=none; b=CWvteK/0utbzaSMdLw241iJGnzpUpLI/62imBJXVyocFboBeH1Ie461s8h5RAqzYQuNCszPCW75CSGBWA2v+GbXhsCngTsjyQ5zF8gmYptS5hmKYy8MdvmS2drwWQ4nwArUDlcT02F5fB3kCDWsXYq7K77Up96sHhPQY0XG/vnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762796691; c=relaxed/simple;
	bh=q01hNp7MEvUPVollMwmjOFZ+eSGr2cxfJGqFAWlWetk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=VmyyOuXlSgguKj3cJpHApn2nnVf6bl1C71fcedmJYygl6ZOzDreXeWjL5UezENIpBn6LbGitGtnFyI5GGFhJdk9TLIMSShi1l8D2snxScXFrjWkZP4yvSNy9HjCmdnY+xiOC9AYwuEnw+OCqdnatOq9tbz8EK3IZzRJz1J8WLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUnCrNVH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54F2C4CEFB;
	Mon, 10 Nov 2025 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762796690;
	bh=q01hNp7MEvUPVollMwmjOFZ+eSGr2cxfJGqFAWlWetk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=kUnCrNVHRakhYWg98WQaVbO+20arfoZo7oCrdPM86u6hM7GtowD0sdlgbJdgEqRTA
	 +HXDfLorjy+kG/uhiQwZ8ybE/v5ntIxggcospy8DOa4tuBX1Y1Sk2p71Rfx2QvBvwE
	 fnhOG9f1qR+uLtabg0PnIEGOEmZYkAhP7fla6T37h8jYuben46v5M6V+iUz7fuBa3w
	 xRLl5WL7huQUBcNR2OagCSizEPsXU6F2Br/t7Nq3+olJnVtsGeBi6StJehs2NTTliH
	 Kb2pel1VzC2jqhFLqsE7vANIWZtnt/96I/7+YzxXG1mGSX4SNehj9SZYUtH/+S0ELL
	 gtBwdnPhpdPuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE1B3380CEF8;
	Mon, 10 Nov 2025 17:44:22 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.18-rc5^H6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251110152517.421706-1-pbonzini@redhat.com>
References: <20251110152517.421706-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251110152517.421706-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8a4821412cf2c1429fffa07c012dd150f2edf78c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4ea7c1717f3f2344f7a1cdab4f5875cfa89c87a9
Message-Id: <176279666119.2712400.9318192458272274727.pr-tracker-bot@kernel.org>
Date: Mon, 10 Nov 2025 17:44:21 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 10 Nov 2025 16:25:17 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4ea7c1717f3f2344f7a1cdab4f5875cfa89c87a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

