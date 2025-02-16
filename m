Return-Path: <kvm+bounces-38322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C88CCA37704
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 19:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A0DDD1890648
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 18:58:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5481A23A2;
	Sun, 16 Feb 2025 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzpyNjk/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E9F18A6AB;
	Sun, 16 Feb 2025 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739732294; cv=none; b=ewouwibM1wysulcC6NdC8U26uLo15yaM7t0zhqVeIaytcBD1TjfgY2xuhm1lMLkKLIzeKG2v6E15Yn/hfuG1aamzK8i0H/JCUardm+AajQCFUe7jFXiAsJQ9+UJthn9NPziM7wx4K1YvwvzPk0SnAA4gw+/6bosJ74A5n2V9TAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739732294; c=relaxed/simple;
	bh=XIV3e3fbX5gvX4TdY6S7c/GYGI1CsRxoIRixeT8a/Ik=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=TIVumtULEw47FER/MCLTG1v7fF3TtfnN4Z/R28SEdxnEC9jovkC6T8IeaGeCz+AogXvZeL2LLaazerpeRRiYjDdCp3ebkijdixFPbP7YAOKw/x3ZRqdIAtymC9cRMMAceb3+zT3Gjxu1J0ozfJPVSFgmYS1yg916y8+tM5Kohmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzpyNjk/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADB4C4CEDD;
	Sun, 16 Feb 2025 18:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739732293;
	bh=XIV3e3fbX5gvX4TdY6S7c/GYGI1CsRxoIRixeT8a/Ik=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DzpyNjk/0gOPmdBKGESzmYqsz54Kyns6ihLEfuS9ue4Nrl2x/iX/tigm5dnXMrqil
	 DLjztsxq+s6QIRPDPhCqiNw5poNcMrSmwPjv024mLTOn0tkYZMLowecY3hplx7h2hK
	 cvPqhC7a8hPUd7+clgx1xEXd+o7UjF1vf2jjUtHprLTpO02428J7powwQXtnzhts1u
	 dCjdPRIxKzk76HE0oxQbbvRNkhASv4oAU2SXMIsdnHUbFGNTtR2pO0s4PT9k6cIkl0
	 ym5xgAKS2brZlKnk4PTul+cuTwTGgapcJQR/6p59dc1Z51YAgiC9Ha9na5B1sFABdx
	 CKRL2P4l2hqZw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB117380AA7F;
	Sun, 16 Feb 2025 18:58:44 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.14-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250216062837.4152522-1-pbonzini@redhat.com>
References: <20250216062837.4152522-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250216062837.4152522-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: d3d0b8dfe06098d6d584266c35e9a0947f5b7132
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 82ff31645685559e3732f7143538c9fe88221453
Message-Id: <173973232346.2551255.12990538932823702149.pr-tracker-bot@kernel.org>
Date: Sun, 16 Feb 2025 18:58:43 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, eauger@redhat.com, maz@kernel.org, seanjc@google.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 16 Feb 2025 07:28:37 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/82ff31645685559e3732f7143538c9fe88221453

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

