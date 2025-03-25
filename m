Return-Path: <kvm+bounces-42007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12084A70C6F
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 22:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 349FF176139
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 21:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF59269AF8;
	Tue, 25 Mar 2025 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzrIknPf"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7161DD0F6;
	Tue, 25 Mar 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742939691; cv=none; b=nIn+OrmljT2I/b8C+C9e9A5CVGXvrHIXi7DEvtTTx8ExKOu/JjU+pqjtwVHE2srEJ8Kl/8piVcuaUOsYQp0bBZa2lX8r+hcIXmjm2WQZoiu3RmymHa0xXA6DbBV8KpPKE5+x6c6lqqYr2QnAxwNWr5biVHUOMneJ/Dl/6K3FQA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742939691; c=relaxed/simple;
	bh=WCQwq5xp5gq2j+MG0tdr2R8JODxTfXqKf/Pgzge4IRM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=JrTU/080PCtbwCd5hpoLe9OWkl/Oi1tIoRvWUXX00rM8SJbj0nhuviH1rfa1XUs1jZV6kEDfGwBkRNzzt2NbI+g9a5MNwXW7KCELNhtVxPCzA5Fdm4i3sZ26JUBk/ORl64GnbyUiFZEzmuaFWeFYx5db5CK1d4sDfgzz1AHQSSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzrIknPf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9DDC4CEE4;
	Tue, 25 Mar 2025 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742939690;
	bh=WCQwq5xp5gq2j+MG0tdr2R8JODxTfXqKf/Pgzge4IRM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=dzrIknPfu+3IW4gBXn6LCqwquBymQliLQobA9XvE5LUobOZoFTFGDVe3o07KqLLyX
	 2txQJNHP5hSQjBMiOrZvcAUTSf9QLA1O/7FA14GDVYKjZ0TLFtz5jGykoT3GcZ9wiI
	 qAYWNzpIEwHiUSeOUthYbp2QM8t4XVU5+k3Q1L/I6ytGDqVTfNO33IWZjbl5Ntfb7B
	 hfV74USAsNqbKEgAOY3TKbWf4+66F7ZKzOH9wMgIy8D4w+YhliL5yBd79Wec0FjD8b
	 FhhCymT3+Rhv65fsuQzjVxRrVxcyo3xCa5NGxhZc7eXlgbMfsrM8Y85/Eb/waJwHYx
	 +lJ7zf3rCwzQw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0C3380DBFC;
	Tue, 25 Mar 2025 21:55:27 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.15
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250321182445.162466-1-pbonzini@redhat.com>
References: <20250321182445.162466-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250321182445.162466-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: edb0e8f6e2e19c10a240d08c5d6f3ab3cdd38808
Message-Id: <174293972652.745772.47913542732198784.pr-tracker-bot@kernel.org>
Date: Tue, 25 Mar 2025 21:55:26 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 21 Mar 2025 14:24:43 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/edb0e8f6e2e19c10a240d08c5d6f3ab3cdd38808

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

