Return-Path: <kvm+bounces-8276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD3184D0EF
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 19:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFA1F1C23714
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 18:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC6E12C54B;
	Wed,  7 Feb 2024 18:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFcnIIgF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4855312B15A;
	Wed,  7 Feb 2024 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707329335; cv=none; b=mcOoY30j//OMG2PIGztbKY8ActVQMakD9rswhH38ql+VvpxIiJTvCwiascJSfIpULDap9bxeEMjMisfrkaxB9N15O0SHsjgm1ldhrvjrf6RXP4QZlsk7Wm2G2EOUODROR6zYU8UonF95Hz0H0HEg6LIvPyup/OgvTr5JPvmg58k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707329335; c=relaxed/simple;
	bh=UXOVvErhhejeJv/afmJ/s4cpm4uILUA/UODLbK8EXKM=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=nJSQekD8UTg5e17cxrVdrNrONEGcrTYsO4pTGXIhaRRCWjrrs55P8XgNoWxcoZd/3M5Cy/fmtqV3TXOX3aTBYqH5ZL/xHV/SXORWKozNtQKhNRa+AOcOc5HftphBVBqdhVRVnAoYMmrE/CJZRpmI2C0V3s7/Wux5veMP209/AZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFcnIIgF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E10BC433F1;
	Wed,  7 Feb 2024 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707329335;
	bh=UXOVvErhhejeJv/afmJ/s4cpm4uILUA/UODLbK8EXKM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JFcnIIgFrmDzzoYk/PYQN10Smb9iskWhFVD+E9iga6YFvdmzebXbLrlIEAAD7q5L5
	 2cvOK4cqdGIZq/8klft5FAqZNsoUHtqXrZcC7AuxVALosbE1Rb4wA8IdKdq8B9OKkL
	 M2XMPBQ8IPVmqlv9wTPHRqTrbTjOnUwh9NXRIo1kljiHP0ptRuCg56+7ArkHfvMACl
	 OM0KM7Y9Jj4FLw1kteIpenaLdWFTjpmhPKOHmeQKnMYiX4TgI+PrKpT0CQBDu7wC+e
	 WWXSChHYS8GKR4mI4VWwGVP0KDHu/VotKbLkKxGINgab4WVIDsrj6JZWMyTnnafybi
	 NVS8ciSE6vwWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08536D8C96E;
	Wed,  7 Feb 2024 18:08:55 +0000 (UTC)
Subject: Re: [GIT PULL] KVM changes for 6.8-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240206182128.3271452-1-pbonzini@redhat.com>
References: <20240206182128.3271452-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240206182128.3271452-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e459647710070684a48384d67742822379de8c1c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5c24ba20555acd68537be26f05296649e171a27d
Message-Id: <170732933502.14404.10080874035895601066.pr-tracker-bot@kernel.org>
Date: Wed, 07 Feb 2024 18:08:55 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue,  6 Feb 2024 13:21:28 -0500:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5c24ba20555acd68537be26f05296649e171a27d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

