Return-Path: <kvm+bounces-43601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9A0CA92E28
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 01:20:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25E50189D723
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 23:20:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747362222CB;
	Thu, 17 Apr 2025 23:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JH71K5wM"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EBF221F26;
	Thu, 17 Apr 2025 23:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744931942; cv=none; b=hY2RqmqDMVnAUV8zqmETw6OS2wsvl49PpqZ+/Sq0GPM0YJMqlzx73r41BoDCg55F4azbrs8KyLYrHuK93hgJNwUxg3crAfsRaYl6IAR74MCJqDHt7YBU30+QCJXzgK6mOUj5WUrr/2CcHDR5mSPcwtChIscENTM4XNQ7gSDa6Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744931942; c=relaxed/simple;
	bh=Iir24eKUcnodhO1x+T0YfWQ/PmFwny6Jovw0teAgAbE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=SmafwfpNV9Shs9K1xQ5bKRBOQd/DENwXDiWQV8cWA8MOIZ8MV6sK1vCHFW2tHS4kvUlUwYH+MWltG3ZvYlkzE6oYYLQ5K4wEXVmZ4V7ZgoTkIzma7vxF/yN3QA+WFkOhdxxDqE9ifjyt8xuNDlIfXxnBoVFmb6P1+DbuyerMpA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JH71K5wM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D34C4CEE4;
	Thu, 17 Apr 2025 23:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744931942;
	bh=Iir24eKUcnodhO1x+T0YfWQ/PmFwny6Jovw0teAgAbE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JH71K5wMEvAKXujavEA9FrZ/B7YavO/BXTqK+oVKRfeDnrYWw+qyuAz+XzTl8CAuO
	 qZ2ILqjxC78/JvAvNTIhWK89ETBYNvqD9G6pdYsLc7nVTWpggF/AeoHC04EO7ETilm
	 00HSSdrQ1fdsGYtOmom5HzPJ23p4Hkpn3CLP2c5Xz7awVhw7ZQKZ0JDiGUN53l3aLZ
	 ldVmDgKbQ/xMNHe2zn27F9v6rxRd/mkcgfo/UMVJG+Be/P4PUEgZZpirlFukiLht3O
	 rgZZVdFG3pi9IsE8QIs4Y2D3lwpHHL/5X1jNyNihh8f19aOO8yD+YIQ6ts4Eh8euMB
	 O2TbxitzqCqMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF76380AAEB;
	Thu, 17 Apr 2025 23:19:41 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO update for v6.15-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250417130952.52761ea6.alex.williamson@redhat.com>
References: <20250417130952.52761ea6.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250417130952.52761ea6.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc3
X-PR-Tracked-Commit-Id: 2bd42b03ab6b04dde1753bd6b38eeca5c70f3941
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 399537bea39b07b106e8f68f83e9b76864d08c2d
Message-Id: <174493198041.45874.6263693059303137432.pr-tracker-bot@kernel.org>
Date: Thu, 17 Apr 2025 23:19:40 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, sbhat@linux.ibm.com
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Thu, 17 Apr 2025 13:09:52 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.15-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/399537bea39b07b106e8f68f83e9b76864d08c2d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

