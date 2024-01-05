Return-Path: <kvm+bounces-5740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A70E78259C3
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 19:11:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4296F1F21B06
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FB535EF6;
	Fri,  5 Jan 2024 18:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j6ZYU9ym"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BB4358BC;
	Fri,  5 Jan 2024 18:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C69FFC433C8;
	Fri,  5 Jan 2024 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704478234;
	bh=xf5K+vLGoVayFLRfO/w9Sh2PeeFLqzXHcKFCZpfJ+kU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=j6ZYU9ymORCZYjNtd7qlb2Q2CTUK4SjqyQWGMD63fx19sj03RMMcNTWXP0fVkskXS
	 7Jjznn1vPkNuTM/eFIHZr+6Gr1dMAcG3acUYOofhj8HbHvtLpRiVMiRamJAmAQGCST
	 91Aff/kPf19DEjxTEhouI4JtZrGULo8wYd4AJHkzQWVFWynnyywif1hoe/PVGmzIUs
	 sdEYDq7pgg7bKn3Ms4ulgfsAHlLnuREpc1QQ8zh3pPeyv9QhBwXbPVST92WNcLARaI
	 g31h6ubtUov5MzifYazK8OJDrAgHPGl6smLcN4FHQsdlVymMgnmxxugXKNrGDVw4bb
	 PVVCy9c0TXauw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA97DDCB6D8;
	Fri,  5 Jan 2024 18:10:34 +0000 (UTC)
Subject: Re: [GIT PULL] Final KVM fix for Linux 6.7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240104154844.129586-1-pbonzini@redhat.com>
References: <20240104154844.129586-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240104154844.129586-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 971079464001c6856186ca137778e534d983174a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7987b8b75f1b0d00483629a0ba006dac81e227c8
Message-Id: <170447823469.11319.11023428195130053455.pr-tracker-bot@kernel.org>
Date: Fri, 05 Jan 2024 18:10:34 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peterz@infradead.org, paulmck@kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu,  4 Jan 2024 16:48:44 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7987b8b75f1b0d00483629a0ba006dac81e227c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

