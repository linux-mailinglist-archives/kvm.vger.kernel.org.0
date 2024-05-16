Return-Path: <kvm+bounces-17496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0A68C6FB2
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:56:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD78E2844F3
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CB7815C9;
	Thu, 16 May 2024 00:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rma7kMlY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26BA10E3;
	Thu, 16 May 2024 00:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715820998; cv=none; b=CMveJyhom3N8Zt4kX83TDhhmTOrLzpeZixnoL/hQvw/vUzuxUPlxn7oDZhEGL86LImJSBNQpYmFQ938XwshzxcZlJlHuESZQxayw3O82by7rdlAc+lTrSF8L81v46ibIOYROG/svpD0fiyUkCnG6kWWqm9Js284wprZs56Qhe+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715820998; c=relaxed/simple;
	bh=IigjHqvM7nUV+AtkbvZjLvuo204MJ//foHLr1kI982E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=O/MapAKO3rWVTVtkI447NOY9WDGgCIVRw2cNBDlnqIf9gistXVsEWgHJ79Y7R32YyYffmc/JvOxeqm9Nb71LOxUvR9aAXdY5I2n9WYG4ggbyynureeDSE22AU8m5Fy+FdxhOFt7s6FpJwkUpgDRcUkhEZLcv2IlO1TpQXzcpgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rma7kMlY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9614BC116B1;
	Thu, 16 May 2024 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715820998;
	bh=IigjHqvM7nUV+AtkbvZjLvuo204MJ//foHLr1kI982E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Rma7kMlYizkNs0QxnuE55EFGZ6m+X6IWXjIxq8nl0SBETLYuvbW0qVJLLv8ZeGRn5
	 kQlYyGdkeRaQzmqzL8Nv0IGqC3dgSSkkiWji6wS+84cxcIFke7Yg8c0m6Kg+RqLJK8
	 G7m+tXtqD2G1ZpdbfKW41XSSq3nXPUkIyLVRQPwShkmmoNc6UsDSiHxwoR9dIY64LK
	 DR2M88nSX5q16blLC3nkh2AZNQrYtOl3QZ5dDtA6wpuC1/Qzu9LfE8fYd6mwKWwiQL
	 vEp/Oe7thS8oEjx/3k8F+gxgcy4d81CTklpRy6/fEIjZ9Rm//Hmw10xDqP5swCJ8YS
	 NsmGayKRyaYIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D824C43332;
	Thu, 16 May 2024 00:56:38 +0000 (UTC)
Subject: Re: [GIT PULL] First batch of KVM changes for Linux 6.10 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240515175056.4050172-1-pbonzini@redhat.com>
References: <20240515175056.4050172-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240515175056.4050172-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: cba23f333fedf8e39743b0c9787b45a5bd7d03af
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: f4b0c4b508364fde023e4f7b9f23f7e38c663dfe
Message-Id: <171582099856.27993.16253011922423131565.pr-tracker-bot@kernel.org>
Date: Thu, 16 May 2024 00:56:38 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 15 May 2024 13:50:51 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/f4b0c4b508364fde023e4f7b9f23f7e38c663dfe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

