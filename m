Return-Path: <kvm+bounces-59653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id A758FBC6574
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 20:49:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 54B1534F648
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 18:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DC72C0266;
	Wed,  8 Oct 2025 18:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="odG/K/qP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB3E19755B;
	Wed,  8 Oct 2025 18:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759949341; cv=none; b=th8zLbvnwkmDHN7X2+t0UKu+OMbv0E3bkU/5qdl76akG890p1et+ZBmb2LyGqlRc5tTNZNOHEHkfuXoSw8XM59WqQ4Oq1bjbufhhT81m1lBr6j7pTzEVBSXvhvhrL3mQYzXqQVOUPOirjyLITP9W/iWcR2YIinp6Hs72OvPO4lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759949341; c=relaxed/simple;
	bh=IFO0GROAtVBYQ8fKl09zSewsa6maI0Kl6CTnDvaVugw=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=ZWS3FMGBwHaqOGxo00ZNv7xuoqi49HiHJq8Eedawbhoki7pswcivCoTjGbn+zFdkqDbji30I2fDlhdVGecr9cfZpxACnad6Cg24pefizlVyeykMVZV9jw+uF070ZtCaNZpUdcWWpq432P1Cv2ay6UqmYd8YbP/ywkYqBux/l4ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=odG/K/qP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE54C4CEE7;
	Wed,  8 Oct 2025 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759949340;
	bh=IFO0GROAtVBYQ8fKl09zSewsa6maI0Kl6CTnDvaVugw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=odG/K/qPMbGoD/M2ESF45AtV/H3bqsyP0K/ystvzxI5PSAnnMc3Vof8IEEUHGNnbr
	 /vmlLW6aj1uM137RYJC9mU73HnDVLNrdCuACcsLHxvjjiggBWFVQTKwy/7A5e7uCX9
	 jQjr5Nt1MwgCsFAKsOlBzs92DJ0aHy9JaHeat4ABWFauyrVmO1pj7/awyzpoZWPs9N
	 hg8stCxlEaHPVkN/peHReYGdQZighLP+dvcLVWyvwoz9VYPd3uSBYAdUbrZMDagLls
	 Ynd8vPkq0H1xfhaCcls4rbJKELekGWOnXjW/6SuD/ypym2Bhp0kB2hjW75oZsg8g6k
	 ckHITkWc3y8pg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D223A4100B;
	Wed,  8 Oct 2025 18:48:50 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO updates for v6.18-rc1 part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251008100846.47bcedd1.alex.williamson@redhat.com>
References: <20251008100846.47bcedd1.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251008100846.47bcedd1.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc1-pt2
X-PR-Tracked-Commit-Id: 451bb96328981808463405d436bd58de16dd967d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ed4d6e92463e8dfe6dfb971f8edc6b5d9ea18722
Message-Id: <175994932876.3563654.17555154040155181670.pr-tracker-bot@kernel.org>
Date: Wed, 08 Oct 2025 18:48:48 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, lizhe.67@bytedance.com, =?UTF-8?B?Q8Op?= =?UTF-8?B?ZHJpYw==?= Le Goater <clg@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 8 Oct 2025 10:08:46 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc1-pt2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ed4d6e92463e8dfe6dfb971f8edc6b5d9ea18722

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

