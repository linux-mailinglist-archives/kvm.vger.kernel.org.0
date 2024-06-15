Return-Path: <kvm+bounces-19732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 984039095C9
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 05:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48C791F23915
	for <lists+kvm@lfdr.de>; Sat, 15 Jun 2024 03:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C118134B0;
	Sat, 15 Jun 2024 03:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiDoM2EV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C33DDBE;
	Sat, 15 Jun 2024 03:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718420476; cv=none; b=h1T0XAKu26KH1IZwySqTwZH+3LQ/AjTd2O9SxyJ6w58lOpenRA0wxY/DKva2goOYaDXO++JvF6OeJf1Zcgnnp1B98+PFnZwNtPz/17HGjQ19fSPKuDWYuMiWP3/7kMM9k6AbypjAOrWq1hEUM+LkTLaXICJ8RgR9mctHP4wqhK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718420476; c=relaxed/simple;
	bh=t3rJks7yJbdEqG8zt9/92RNbWuowzMxt0oIbn0kmN8E=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=jk5tw6k5/JpdlgSKWPhoAcqT0cU2DBfVGOq983moJeRpeh83C9b+0PO0DA7HaO95/ySu44tdlF2D63uT3Eg60IRLSXLl6S5Ij4J8V32gH/0KrlHP93DvjntBqiZ6iOcMtdo3e3woncnrGs4y2QiuHhk5TFm50JYVh95gAfX255c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiDoM2EV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38455C2BD10;
	Sat, 15 Jun 2024 03:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718420476;
	bh=t3rJks7yJbdEqG8zt9/92RNbWuowzMxt0oIbn0kmN8E=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=DiDoM2EVZNVJOBuqjJkwqLNZJ86//EhzXZUCCLvWt+roStgTO1BKOr0Fw0xXeT6/X
	 utTNvDxgwzpLipHUUYZedeUZ9RWFjmDfsUsQZhkjnGVj9z2qyft5y0AznQjq6EusX6
	 SSSmtrpwD9pq9C/WLukxGnVAvyEOfZ02ecTDE1vQMiwrYICc4aJAW4WgrL5zuVXm5Q
	 T/UQHQb1YIa995prHQXH63zvZulzf5rC9CCsuIgOcZOoHHO/3Vb3IOZZPv8o/Di8qT
	 ShJp633xc1HjUCIj8nhiXONdGSxA/haAk2cBhDrRS9lGgjBbVkJyB08OGRi77Caeix
	 xeALkQjHl8dmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E9A7C4332D;
	Sat, 15 Jun 2024 03:01:16 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.10-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240614155603.34567eb7.alex.williamson@redhat.com>
References: <20240614155603.34567eb7.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240614155603.34567eb7.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10-rc4
X-PR-Tracked-Commit-Id: d71a989cf5d961989c273093cdff2550acdde314
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 68132b353622137d25a5c6854b69ea679318d870
Message-Id: <171842047618.4182.3433178184056125065.pr-tracker-bot@kernel.org>
Date: Sat, 15 Jun 2024 03:01:16 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Fri, 14 Jun 2024 15:56:03 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/68132b353622137d25a5c6854b69ea679318d870

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

