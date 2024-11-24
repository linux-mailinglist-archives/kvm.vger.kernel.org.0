Return-Path: <kvm+bounces-32396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDBA69D6C58
	for <lists+kvm@lfdr.de>; Sun, 24 Nov 2024 01:33:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89D0F281A11
	for <lists+kvm@lfdr.de>; Sun, 24 Nov 2024 00:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE557FC1D;
	Sun, 24 Nov 2024 00:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FCM/hFKv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003A81FDA;
	Sun, 24 Nov 2024 00:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732408428; cv=none; b=oaqZqVSQdUciH8k5OORJfOHI+r0/Np4sRZYqKoIolj67MXnaZilkAvPlgUoIBxjLoATSZIBy4MHsa14/9MsOg9qYwQbFNvqzl/oteZfCF6t1mDe2Vzb6xfIBG9/M9tMFd5X78a3t0qSMjqCcdOvC1LiW9EW0RBWOKgvz9UAtP5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732408428; c=relaxed/simple;
	bh=4gcOksbKepw2ZNyQzNtx4YN1Dv8j1QB0E1ZrfK7wKwI=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=mEmnUwfUkIsDhe9aVwAwQzqJg++nPA8R4vKeucw6X1qibW/Uy7kXd38o0AjDElro01MaSLmE9vy0oxUDAgzMxSzwlZe3n5d93p0mp6lD7dzYLd5FKN15aci5gCI3F1Ivq2cTp8S1r76JB19rdsFa6shNT62p+EyoyJInI36v9O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FCM/hFKv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7696C4CECD;
	Sun, 24 Nov 2024 00:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732408427;
	bh=4gcOksbKepw2ZNyQzNtx4YN1Dv8j1QB0E1ZrfK7wKwI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=FCM/hFKvcnnB8lqQOLR1gaDsIez/rwmkpY+aadTvE1jQfm7GjR6NxVvBsJkRSQey1
	 ehcWck0G0Qil4c0/jC2wkYJkTqWq5NZGRKjC4DuQJwCzUC5l96zPih3ORrxqQUyA7n
	 I4/UXeOs9MZdso5ZBJ+FQURA8PZHWvf9V/RWVrCPOQkJz/7EvlvS0uBCwUmtVju+nh
	 B4I6OoxXL7bWcN5CQ/NlXOS8Mu6kv8g8i7IPessC3NmI1YoUiKMkxMJySfLXkR1qOh
	 okyi4qQFl65xx1uedwWo3DCW4StSQAHF80FO0782Amh9XmW41d5qQmqmyx6Xvx6c1e
	 gDJG+Egw7EwEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 712743809A06;
	Sun, 24 Nov 2024 00:34:01 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.13 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241120135842.79625-1-pbonzini@redhat.com>
References: <20241120135842.79625-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241120135842.79625-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 9ee62c33c0fe017ee02501a877f6f562363122fa
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9f16d5e6f220661f73b36a4be1b21575651d8833
Message-Id: <173240844002.3120895.15621578400375854949.pr-tracker-bot@kernel.org>
Date: Sun, 24 Nov 2024 00:34:00 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 20 Nov 2024 08:58:42 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9f16d5e6f220661f73b36a4be1b21575651d8833

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

