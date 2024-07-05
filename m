Return-Path: <kvm+bounces-21050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7943F928DD7
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 21:38:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D3F61F23669
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 19:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41BEA176228;
	Fri,  5 Jul 2024 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VbXHBXOL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F81741DD;
	Fri,  5 Jul 2024 19:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720208278; cv=none; b=gCMpPb2onHtMTc6uul/6o6TqNl493qNSIx+QUC6n1TS4AJp0b1o7j5DjgQkrxQEZ1FlkfOu+wo70EZkIzrpZNK37jKaJa20izjZq4GL+nl2huuFoUYpKWwqNyCIiTmry+0pGKF2Me2SAcM/OpysQ78vnEoeoVlGVgSmBytu21UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720208278; c=relaxed/simple;
	bh=Um9yAaBxyq1RdNsvWsdMSKXcQ8uJpx1Yfm2LH+FxV54=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=qOxQO0nlSFvMMA4jLxxahxKSiDysi8nHnRQ7SqRIK4hcHNn1+gaNSnixmIxh4XWXF+KsnAjYOintuLbZjWPX8qZtJ1LAE9gUZMEzrO+Se+oiIRc/sj5PyFUyKeoAyi5ZxxjcECPC63UJFkADyqmaR8wuvb3UKOezSqf14a6Lse4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VbXHBXOL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5248BC4AF0F;
	Fri,  5 Jul 2024 19:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720208278;
	bh=Um9yAaBxyq1RdNsvWsdMSKXcQ8uJpx1Yfm2LH+FxV54=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VbXHBXOLBC6GbgUQ3ixfdlK3+NTfJbPBAyBavrtY3rzxwlJgImF2aCv0oFVGt3G3N
	 6TTdhqXCh5wlawHsNq0st1eeNp/rb2wboz5RoPWnd0Xw5wnriCd5wgoydPFC7563o1
	 osDpi+FpYBJqUDliCsu7Cq5DCGCh8mJ8aCeCic6WMZQosNIgtGTGid19escEzWsxhn
	 pPy2Dd12klWJEWoY2wtooR7906noWbZmYdnGtlC/XX07hn8f6NXqxeGj5Xt78AEWHr
	 GZ8881ok1yztUd2pXb5zkXX0akgIzG+1K8Ik9dIdlCW+TIbMwkp84QOM/r6/NXNDX7
	 7ZwoVpFPTKIoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 44A72C433A2;
	Fri,  5 Jul 2024 19:37:58 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for Linux 6.10-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240705085120.659090-1-pbonzini@redhat.com>
References: <20240705085120.659090-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240705085120.659090-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 8ad209fc6448e1d7fff7525a8d40d2fb549f72d1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 75aa87ca486b95ffae678300722022f01d33b7ca
Message-Id: <172020827826.9250.15215158713497708064.pr-tracker-bot@kernel.org>
Date: Fri, 05 Jul 2024 19:37:58 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri,  5 Jul 2024 04:51:20 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/75aa87ca486b95ffae678300722022f01d33b7ca

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

