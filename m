Return-Path: <kvm+bounces-28081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 592A9993658
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 20:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD9C0B20E74
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2024 18:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53E01DE2C3;
	Mon,  7 Oct 2024 18:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbwE+EjL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05DA1DD549;
	Mon,  7 Oct 2024 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728326265; cv=none; b=iG2EbK2NAJ6oRcSeLIFKypHjuB5AD8iwJtpQRhM6L+hCexFFJetpwrohottsZljYITibL65X3SZ78PFyfZ/97CJcr0LQIGS0xgJbaJ3c0wWb/TRQiREbZYOYbRxtmi0k4ybUflnQr3DW+g1Dcl6I5xWP+YQa8YHM+LkOUXVxNsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728326265; c=relaxed/simple;
	bh=LLhywHX9oky1MmQko4cR0K0+0vGqeLQ5ItXxdltoVMY=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=g4IF6OLl4OcGNA5pPZnelL/bgmBB2feQpTyWfBI+ZCYfgiWu/Zi7Fl5hUztQp2UVazdeBXHBNT9QRabCHDIV+qhG6kx0lpJTqqohosm8l8BzmLCHWoH29AXFPRuycZjfLME/QboFw6CiIpIe8mG24tzrfeQZyEbDyQC8F5+0okk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbwE+EjL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9255C4CEC6;
	Mon,  7 Oct 2024 18:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728326265;
	bh=LLhywHX9oky1MmQko4cR0K0+0vGqeLQ5ItXxdltoVMY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bbwE+EjL8F4nNIiefYEhe+cGfTjuDVF04N09G5HJ/ae0oiHdcPHoKP5On9Er/ne9i
	 0Y0kNH8Gwx/qH6R5iGKt9bkLYBRfFFfr4wh2yea8ClhQWyVMiJ555AhUG230hKv4zi
	 wxeyR1wiWGe2jHeEyR1kctQHIBbUCb4yGjeHYGRgsLfalvjMCdCPys7ngMkIiiyIRm
	 PN/4s3aPYytfsGoWAMkCwsrlrbPVRS8xh75xD6DMF+weeKdKeoXx+AbE+2y6UEY+0y
	 wY93g1/6abauy2QRE1Sw2BzoN+xM2KBrVRebU/fy5y26fUfxVxJ/HHiY1EmrGTfUJG
	 OE3i55Img3KuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB58C3803262;
	Mon,  7 Oct 2024 18:37:50 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: bugfixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20241007115158-mutt-send-email-mst@kernel.org>
References: <20241007115158-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20241007115158-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 221af82f606d928ccef19a16d35633c63026f1be
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 87d6aab2389e5ce0197d8257d5f8ee965a67c4cd
Message-Id: <172832626951.4133236.13974754342123497528.pr-tracker-bot@kernel.org>
Date: Mon, 07 Oct 2024 18:37:49 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, brauner@kernel.org, dan.carpenter@linaro.org, elver@google.com, jasowang@redhat.com, lkp@intel.com, luigi.leonardi@outlook.com, michael.christie@oracle.com, mst@redhat.com, schalla@marvell.com, sgarzare@redhat.com, syzbot+8a02104389c2e0ef5049@syzkaller.appspotmail.com, wh1sper@zju.edu.cn
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 7 Oct 2024 11:51:58 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/87d6aab2389e5ce0197d8257d5f8ee965a67c4cd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

