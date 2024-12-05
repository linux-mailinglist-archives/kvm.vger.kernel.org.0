Return-Path: <kvm+bounces-33177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6B6B9E611F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:08:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA964168D80
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 23:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 563E31D63F5;
	Thu,  5 Dec 2024 23:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUqsSLpu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBF31D516B;
	Thu,  5 Dec 2024 23:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733440114; cv=none; b=WtumInunZinxZDDwlwHFJ1vQe1wrcinCZvM6dVDRBUt96FnCio+C2+biZZgEskEW08ZyD1RiNEsTxtD7enDKcpOiAvh8oNGzVYXf6iXhxPJjoJbuGSd3SMU4vKtjcz1ALj7Cjz4IpQXOOGKHjqnkX7CCVjA9Om2zM6HfE4vfHGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733440114; c=relaxed/simple;
	bh=jjQpgUIPmfsC6nRQVAaYTUzJgF4swssT+/yq7WtEvj4=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=e+KLfSxmKO/uMK5eyB11mytfmurW0Oll8InYM7N/bsbTOOg+OAlEiTo+dc9cGgPc+HHCPnKKiapExjuArPcj+UTnRWzKTpN3eUkvcH+UJVUdxA2BMTLoYk464rgbQR9LAS272dIezuMqgPgGU/GT9267BqaiXl3sJLXQDkd8Reg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUqsSLpu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89F9C4CEDC;
	Thu,  5 Dec 2024 23:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733440113;
	bh=jjQpgUIPmfsC6nRQVAaYTUzJgF4swssT+/yq7WtEvj4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KUqsSLpulTu+vk9aa/pygWfY1T6W4nhpuKvSLWB9cdWPASYpGMFUOLU1ye4aF8jqz
	 CF9GgpV58Ky5bzho91Ut6/WmntU9qmarka6mellsfYrKwpWKuep1VGt4DempyoUgyp
	 IpXLgxI+z6PV3KMXQL33F8jN1V58twQVHspWrDXJS4+m4Rvq5lFP4X+yBN2T1WeYNS
	 s8k0/wx2ql5+R5uyTXHVVF8MhCsz3dJEJWzpp/Wt0wOiCBOsivJQ+3z3BcW941cY0w
	 gtko94FCAEMK8G6xCbCXOZTjj4Yp/YyyIbVEi5KDSTjMQCkLJopq5OLoCvm2R5kbK2
	 fJ5oh5O8nF5Bw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EADF0380A952;
	Thu,  5 Dec 2024 23:08:49 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241205184430.GA2110789@nvidia.com>
References: <20241205184430.GA2110789@nvidia.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241205184430.GA2110789@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 2ca704f55e22b7b00cc7025953091af3c82fa5c0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6a103867b95ac7f9cc7dffe2fcad2f6c0d60b9ae
Message-Id: <173344012854.2095723.6382327871295265993.pr-tracker-bot@kernel.org>
Date: Thu, 05 Dec 2024 23:08:48 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 5 Dec 2024 14:44:30 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6a103867b95ac7f9cc7dffe2fcad2f6c0d60b9ae

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

