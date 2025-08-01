Return-Path: <kvm+bounces-53858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D06F0B188D3
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 23:36:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C2ACAA6ED3
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 21:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EE628ECD8;
	Fri,  1 Aug 2025 21:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LKbOGzXg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503271A0712;
	Fri,  1 Aug 2025 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754084166; cv=none; b=SKCIgNr0rCTkITEHOP9QXLgLaYiqvbzLm/TYPrcU2hapvdEpqPyEL59ROJGVvT1ihuD5yVE5odJCzbJYN46gyNaOnZ5jgwb4iqWYrIhtjAvxqSbF6U874H9sTtbBNxD7sk8WK6j/0eUgJvv5oOq/bidxh1ozNfapITBwK8MqEgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754084166; c=relaxed/simple;
	bh=OAhxtFG5/w7PuEcTCyyGE3DZIR3gPMJhst9cdG+Sii8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Y15skCjxJxrChBjDEjML+V0dr40+BWuyrjunu6xj3I+2ObbzvgFROnvBufcZeXvhVqyeO3iZMsP1zjHv70+dbCWaWkndUCWVBm6M0z8CeGRHqYIBA6xVHrZtOul6F9z1SkzwmX9KG2E+/1pULinvzoDsICXZ1IrIj5K8QRCTNR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LKbOGzXg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3145BC4CEE7;
	Fri,  1 Aug 2025 21:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754084166;
	bh=OAhxtFG5/w7PuEcTCyyGE3DZIR3gPMJhst9cdG+Sii8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=LKbOGzXgxsPFW8TtF7VP1qfx/+sHCW+gx/mom/RaRml6ukmz1lpq/rjEGlVoP4HVI
	 M0GibQPDIEob8KYA5gikYNNvrQ9+6OH9tSatdzwdHZCOxip8I9wx0DFIL/HSQQZBAO
	 6s9e4PLoo7Y95EXKcghNJ3gZs8AqdnjJrXgZBflyIrd3P9ZXPxa2q2QvtMvRLtRkzN
	 S7n4RaG7sCWNx5io3KS4U3xzhlzKylo+NcAqQd8YE0v2+8/FNMpmsGUnrQPZza1Uc/
	 hEDW5+1Lit4nBcozsOGaF5WrPDxPeC7/zmuEi4Rkvw7SuLx0A3CR7/TVdA7/430OBg
	 ZF5fm4Hdqn3SQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE152383BF56;
	Fri,  1 Aug 2025 21:36:22 +0000 (UTC)
Subject: Re: [GIT PULL v2] virtio, vhost: features, fixes
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250801091318-mutt-send-email-mst@kernel.org>
References: <20250801091318-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <stable.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250801091318-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 6693731487a8145a9b039bc983d77edc47693855
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 821c9e515db512904250e1d460109a1dc4c7ef6b
Message-Id: <175408418138.4088284.1058038045286020103.pr-tracker-bot@kernel.org>
Date: Fri, 01 Aug 2025 21:36:21 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, alok.a.tiwari@oracle.com, anders.roxell@linaro.org, dtatulea@nvidia.com, eperezma@redhat.com, eric.auger@redhat.com, jasowang@redhat.com, jonah.palmer@oracle.com, kraxel@redhat.com, leiyang@redhat.com, linux@treblig.org, lulu@redhat.com, michael.christie@oracle.com, mst@redhat.com, parav@nvidia.com, si-wei.liu@oracle.com, stable@vger.kernel.org, viresh.kumar@linaro.org, wangyuli@uniontech.com, will@kernel.org, wquan@redhat.com, xiaopei01@kylinos.cn
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 1 Aug 2025 09:13:18 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/821c9e515db512904250e1d460109a1dc4c7ef6b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

