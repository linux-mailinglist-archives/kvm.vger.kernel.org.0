Return-Path: <kvm+bounces-59494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 67750BB90CC
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 20:18:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E95304E9E43
	for <lists+kvm@lfdr.de>; Sat,  4 Oct 2025 18:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE44D3594B;
	Sat,  4 Oct 2025 18:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSRrfV9m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F82286412;
	Sat,  4 Oct 2025 18:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759601908; cv=none; b=QYBhMHhQ8p23UGZ04/h7PmA9mlEpxlw/rLtVLGLQRw7odPuJf45ANR/z7RMvGKNt7Dfj9ra6g6xCtdzFd85pTviArgH7ARh5z5SLV3ByJOLdliUbdM4z1sIJUokBU2hZOCYRPavi9PF3v1S9CUg1+G4wXuaDfqxN9X63LZpz/Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759601908; c=relaxed/simple;
	bh=9DSDvi20syE4S/9NQ+idEY3W2vXhnKSx/nttmOpTDx4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=g2HWY76c77W2yjvmNkuhrAIwOGl52FqjNI+O12CLnePuQnm8k60V6U0hiTylrOyVsqXeQp9M9yRMe0XFCKD4lJfArbQ+Ee9W/Td868NgRaAICOXWmdQ84cI+2iSj8fkAl5iVtqkZOLlO6uj5QkAUWhKlG9N/J6O5J9ZGuPYlJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSRrfV9m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A880FC4CEF1;
	Sat,  4 Oct 2025 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759601908;
	bh=9DSDvi20syE4S/9NQ+idEY3W2vXhnKSx/nttmOpTDx4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=cSRrfV9mmTTVKN4fc0CviumXfOHJG7PkAJL5PsnHjpJH0DVDmAjrlC8CequpCRr1Y
	 y+cqs+9+eI+hKJd+HIabZEXaI0zf2k61l8i6wLwE97lqZ3G4R7KEoNqeFso++HynkQ
	 T34fyb7CsnFa7adDsDqmj/xQwS3N9l29ng/TI7REBY/s4QQ1LfSBbGW26GWbzLwtge
	 Tb8UvmSecRTqLz4rHKG8fGwPRuSszZqlx9J1xOEzAIDtPgA/weUFUNZvr73Rjap4Mk
	 C2lAapC5IFsaJKiE8Y9u06s4Z+K/izj82zZcbGo4ZT2E0ehkSRwENLeCLx/Cso1g4m
	 9OmviVNcn7Mlw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD4639D0C1A;
	Sat,  4 Oct 2025 18:18:20 +0000 (UTC)
Subject: Re: [GIT PULL] virtio,vhost: fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251001073158-mutt-send-email-mst@kernel.org>
References: <20251001073158-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251001073158-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: ed9f3ab9f3d3655e7447239cac80e4e0388faea8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf897d2626abe4559953342e2f7dda05d034c8c7
Message-Id: <175960189917.404121.15074893987937595842.pr-tracker-bot@kernel.org>
Date: Sat, 04 Oct 2025 18:18:19 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jasowang@redhat.com, leiyang@redhat.com, mst@redhat.com, rongqianfeng@vivo.com, sgarzare@redhat.com, sheng.zhao@bytedance.com, zhangjiao2@cmss.chinamobile.com, zhao.xichao@vivo.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 1 Oct 2025 07:31:58 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf897d2626abe4559953342e2f7dda05d034c8c7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

