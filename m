Return-Path: <kvm+bounces-48211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F91ACBC34
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 22:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C44E3A3D17
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 20:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC273196C7C;
	Mon,  2 Jun 2025 20:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2z4/Dxo"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44912C859;
	Mon,  2 Jun 2025 20:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748895303; cv=none; b=mlZ0KhFm/Vr0FzYAKiEs2Z11hZoNrsTspxvgUldqgp1vXjkWmRkkedb+8CftkNa45IUnFZPvhjNZwvIH4VZz7wB2H2Q9/Sq/V4FYP02pebCgNz/5qFIF3dnSHrInKWbX/u2RbSZkhpg0liWvF0ORAyG1/g3lGRR93IOTcu5Zo7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748895303; c=relaxed/simple;
	bh=4v2jzH55kKBdCZzHbv27am8i8sXvaVHDG/daqmSAwe8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Omsd1tRk/mZ0vRNtB7fhJdBOQPIJTLzNi0nWkzq3iXYvUMx2JbH//Bqwh86DqIBbKISpx3kB20GDzp8+U6CMpr0OrNKYLw3T/DAzn8WMPtpKXa4S6ypzrY99TJwNAZ9y5d/KAiuEfOJg5h1kYwnE9K2i94vyqWS5zBmZh/ivC80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r2z4/Dxo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A80DC4CEEB;
	Mon,  2 Jun 2025 20:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748895303;
	bh=4v2jzH55kKBdCZzHbv27am8i8sXvaVHDG/daqmSAwe8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=r2z4/DxoJ0+sK+7iJ/YoQCEMvlyHrooUF3bccr5/DQqddA+ZVRoKOb3WsSVn7JmzE
	 vgF5uHtwjN3MXiSXJ/HBnvbqevXePV/RPpoYpZsVJFXqvJEFV+9Sw0vvodcH+WG3W1
	 a/N9zLCA5ybgvn9bxzhuRVNpx5LC6Xv94oj3rpKJGFQHy0+zGGIQ39ROcnRIGayJ2z
	 4Wge2yTXcvUQDvNBy1o8LxUr9/HiUyuXuopRJ4aOD0t4n4zxwkdB8LSCvogKqk70Fk
	 6gwXUYQXxVflfuiFqTS3snpmRoKAEtEz6S+DXwQkfzlZ/j3Tn2le7nw4tkcYAyyHIm
	 bAz8s56IELU+w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33F5F380AAD0;
	Mon,  2 Jun 2025 20:15:37 +0000 (UTC)
Subject: Re: [GIT PULL] Second batch of KVM changes for Linux 6.16 merge window
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250602071139.133967-1-pbonzini@redhat.com>
References: <20250602071139.133967-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250602071139.133967-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: 61374cc145f4a56377eaf87c7409a97ec7a34041
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7f9039c524a351c684149ecf1b3c5145a0dff2fe
Message-Id: <174889533584.896656.2847439054547318432.pr-tracker-bot@kernel.org>
Date: Mon, 02 Jun 2025 20:15:35 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon,  2 Jun 2025 03:11:39 -0400:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7f9039c524a351c684149ecf1b3c5145a0dff2fe

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

