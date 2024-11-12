Return-Path: <kvm+bounces-31674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B319C64C6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 00:04:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04F15B3F2D8
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:39:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F382E21B436;
	Tue, 12 Nov 2024 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uIRGqaNL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F46121A708;
	Tue, 12 Nov 2024 21:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731447511; cv=none; b=n2dMKLGIOUkMhpTQfhGh4rSnNYOamvlKTxy842RALcoNzWQERc8x9d1Owx7DYldYlZaeFRymiE9TnB9YalTmgncSyWCOGWIRPJ+31T72XgBd5FwdBVL0lTQC/uBSBQZzw/Gsqjq7oQONh0HqZM/MCFiEHOSfXx9jBHvfTOfTUNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731447511; c=relaxed/simple;
	bh=GssntrLcu2mDnuX5jQSlOXYogDuW1SsQ1I4NEoPL7Sk=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=HRhlPW0Gk0wH8hMjHQMOQ7tZdUWx625HUiZvz11yiWB0/2Wm8pxYW0rT3tYdZIkiaXO26vFaKVfwrS2pF/mRC0aFDlWo7yq+RhCDnEzQeKMm2WtjQC6V2sKFsh4eEbemx8Ri8PsfXifgBXICFXp96VJfqbTUuyYIrN3VxWg7nFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uIRGqaNL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1526C4CED7;
	Tue, 12 Nov 2024 21:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731447510;
	bh=GssntrLcu2mDnuX5jQSlOXYogDuW1SsQ1I4NEoPL7Sk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=uIRGqaNLSCR9lCC0ILq4PxeDQrUSpLt/zeZr9AaE1CwzsrSqrHFyR9jOL2vLCnlrk
	 YW8ES4E0bKFcuxsXg778NPfswyjoVSjR54Rld9bUiyriGf/zkmNEKz2LbNUJ3l/XRi
	 4VQdNCxBbPAkgKjXU0wDIJBUppDV+900rruXvdaDzr4Lvj1JLCZUFGz9RGort5mv1L
	 L2CPJIcoPXjhfKcjW7RMNZpMYGUMireBeWky42D3CDdWBqFRsW8jLez5uWZCV6/pQ0
	 Uv2KAU8JJIffSQ+2aewdjW+2BXJ0UczETp/kQJPlPY7k3ROI47dU7jO+Ts8LXRvQAG
	 PvtCcwT2SvjUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CB73809A80;
	Tue, 12 Nov 2024 21:38:42 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.12-rc8 or final
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241112181700.384873-1-pbonzini@redhat.com>
References: <20241112181700.384873-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241112181700.384873-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: aa0d42cacf093a6fcca872edc954f6f812926a17
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 14b6320953a3f856a3f93bf9a0e423395baa593d
Message-Id: <173144752082.678506.8319615124792683166.pr-tracker-bot@kernel.org>
Date: Tue, 12 Nov 2024 21:38:40 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 12 Nov 2024 13:17:00 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/14b6320953a3f856a3f93bf9a0e423395baa593d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

