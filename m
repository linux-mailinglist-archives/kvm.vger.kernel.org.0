Return-Path: <kvm+bounces-9439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2DA860373
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 21:03:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B7011F2526A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 20:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938566E60A;
	Thu, 22 Feb 2024 20:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGD/v7ve"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD732548EA;
	Thu, 22 Feb 2024 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708632201; cv=none; b=Z+tLnbQWqpKvWqHywWY9fYyurz1SVZZBMUSLyABGv4eZ3AI6DWia7lGfCr81tkbn+bacKd1ZNakoYzFlSVP/Aahj6ktm3DgO+0iPXdPSe74Yd3cTkvn8wiyFqg3f04Wz0Bi9U2MLBGg67AYqUIwBOpQ+T6kGTIjxnn24kDboitY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708632201; c=relaxed/simple;
	bh=T7r/4WSkGDKc96mto37aPOmcOTt+wPazyC3Uwb2o0x8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ezMnZeVorUeNt9t5N1wev7WifAgdUTD5PR9lTX6DJAQGhTdetPT8VcNhlFrizv7Y2GZsjwuUpi9AzT/Tx+Kj2j8utpwt9b41aQ0Uwib1CdBICdJd55whU3zLX6UmQ9V5YQ/Umm6eXqkSM8X6Q6v1jK8NH9pFHnZ0MpkYCtI4M1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGD/v7ve; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D4CFC433F1;
	Thu, 22 Feb 2024 20:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708632201;
	bh=T7r/4WSkGDKc96mto37aPOmcOTt+wPazyC3Uwb2o0x8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=VGD/v7vezpF479PDvh+EdxHAVp/DaQ0aYhcLiIQwM+9KXhZDWkkQBL9ZEsj16Umoj
	 TresCfR079y9l6YANX9gHUGFH/UKPdSKGk9dNyYIPe+b1riRj+QzfLTXPj+SL5Nk2z
	 ZedRZxUWkp+O7L+p2//OUIfB40F8OozP6RZ9gfe0jD9+evqRivSWsDbgtxh11z3A2V
	 9y7DGy1RfZFIBR8Nhr+UMzhEOAYw/fBamMbelG6qgsVxDlmEjdz6XKOMjnwoEdaMt/
	 m3HwzOLOCW2MpHsrTjeBzkV/Bej+ucoVGz+KTGKQ5VG/fzlThKOo6iR7Fz916MRa2o
	 I+4pwY3jbGmpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 190EAC395F1;
	Thu, 22 Feb 2024 20:03:21 +0000 (UTC)
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240222132304.GA3882153@nvidia.com>
References: <20240222132304.GA3882153@nvidia.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240222132304.GA3882153@nvidia.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd
X-PR-Tracked-Commit-Id: 510325e5ac5f45c1180189d3bfc108c54bf64544
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4c36fbb46f1326c8a11d81594a710098909eb9bf
Message-Id: <170863220108.18444.5780012185035340615.pr-tracker-bot@kernel.org>
Date: Thu, 22 Feb 2024 20:03:21 +0000
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 22 Feb 2024 09:23:04 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git tags/for-linus-iommufd

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4c36fbb46f1326c8a11d81594a710098909eb9bf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

