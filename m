Return-Path: <kvm+bounces-11939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A65C87D50C
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 21:38:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B86D1F215CE
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 20:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736A955C05;
	Fri, 15 Mar 2024 20:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqPMcYNj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9963154911;
	Fri, 15 Mar 2024 20:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710535055; cv=none; b=aT+fU6ayXhvzw+OLlA420UJebuN4TTlLPP001bfSwiU+XhkT3tc2mlT0zhAvZ5UtB45Qp8uhZ4t22CAkNuDK8PQotUcfaRIJcwdVYev98JvQlPF7XfcY5/MMATUm37Elg14Jkk/gtG1CWR+9WTI0XxU16Ugm/p1jByilAWuuc5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710535055; c=relaxed/simple;
	bh=wSlo6Cr0jNnihTYxdwch5tSWIHAUDGd3k7/kuPxLl7s=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Oz6CbVF6q7ULz4mV0MTW9Fvpfm/XS1qniTLJPx/vRdAG2hWRdvEytusukZLNSx4tgwDSUeMXOt8ev9tG9OONxbWLeRvqi8dTsZbmDhayz5YbAPrk8kjmBhuR+8P+UEQwvhnwf155h5RWb5hyvML6cnagfILs1df4xpXGIHsC64c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sqPMcYNj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 797B4C43399;
	Fri, 15 Mar 2024 20:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710535055;
	bh=wSlo6Cr0jNnihTYxdwch5tSWIHAUDGd3k7/kuPxLl7s=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=sqPMcYNjHkx0rw7lEFrdJ/TrvkvhUZchq3+KywDhAZtDO1Ou8Bk+oWJ5bNK/TpxRK
	 i14Wj4/YY4779nD7jDMXrXXI0yOgq4v9bYMiO40M0vBzKcUJoW+447ngNLgOFIeCi6
	 E3mETFAQz0utre147F9q+q50Yh4HpjnSwK8E2kqxylzyi1pPV1KpGDoc65oCJxiDTG
	 xDPjF3G7YezTeju9b9busU6jkLn49mtocgD4GFofynzIKvIYHYRKJ/4MG4KVyhpJGY
	 ifoWyyr2bUfercC4ZSqhpPm+dNXs3swsBJ6Y8Sqv9h+TQHvr8gkFiVkO4nT4vm/6tb
	 +z/bfmJ3WBCKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73C3AD95060;
	Fri, 15 Mar 2024 20:37:35 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.9-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240314170157.0a6bdd52.alex.williamson@redhat.com>
References: <20240314170157.0a6bdd52.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240314170157.0a6bdd52.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.9-rc1
X-PR-Tracked-Commit-Id: 7447d911af699a15f8d050dfcb7c680a86f87012
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4138f02288333cb596885e9af03dd3ea2de845cb
Message-Id: <171053505546.29375.9900984620897502590.pr-tracker-bot@kernel.org>
Date: Fri, 15 Mar 2024 20:37:35 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 14 Mar 2024 17:01:57 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.9-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4138f02288333cb596885e9af03dd3ea2de845cb

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

