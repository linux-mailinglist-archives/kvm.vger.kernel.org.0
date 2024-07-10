Return-Path: <kvm+bounces-21339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 527E392D8BA
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 21:03:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8458E1C22107
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 19:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845AB197A77;
	Wed, 10 Jul 2024 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qajc7io2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF2E7BAF7;
	Wed, 10 Jul 2024 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720638210; cv=none; b=bhN7cli4aosD4cvpAVTSFe3bhvcl4O+U5ahfr5ZRBPVzVWbShiDnRO1R28rw5U2N1d7hMKH7fkRwcuhvGBFLqxH7lhY1wUuVJ/qMT8GvDPFmm5fkXSuaNwXD7SSYbyrdF22F9Kxc267wPKoD0HnJcd0szyub5SwJ6jbN+SKdnds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720638210; c=relaxed/simple;
	bh=wwlcU/4dYoTWHl8adO03+Pyz9g+LZrqpcPIwQKMIyAA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=CbNdup7Q4pHqT4XWMNB3EaiGDBXClF1EgnNoXFyGvgYY4sVhBUtKH23Y0PdeBpw0pVBUfHtiHXs56sUJgcYa2L3fooWEKHefP+k88HlLIxgKMt0WxaNgiM4cbKKbSsUSaq25X+qZvBiyNLjnIgeb2YZxC3+h4+1b5/dwEx5TCdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qajc7io2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84734C32781;
	Wed, 10 Jul 2024 19:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720638210;
	bh=wwlcU/4dYoTWHl8adO03+Pyz9g+LZrqpcPIwQKMIyAA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Qajc7io23k+hOy0H4WChAaSQww43/NJU2S4hbO9m9rUeKK//rUjRgEy2MvZN8ljzC
	 fgTEAMIfRWwtXsyP5DmSfiLdPKx66N7VgRQ2Y1nKXUvJeNSCbUyueQWpSZMhUPXRtU
	 X9P/UVHwPt+vu+BWdj5N6QgqJVsaiqBwGXCU3CeNhMEcxfISclrcXZ3lZTZckLpkeh
	 ZWdqaTJLTNUy2orn/C3NKNI3/RnDypwhlOrQO2FcI9AbGNHyhTaF5q8g7eo+QnyRZ+
	 D8qbs82DVawrnmkp2wA1rV5I5xIBLWRBs6oNAlPXhO/BOhpQ6ZBR6wokWOF+zaAB1M
	 Hkw93nJroWayg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7992AC4332E;
	Wed, 10 Jul 2024 19:03:30 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fix for v6.10
From: pr-tracker-bot@kernel.org
In-Reply-To: <20240710112751.7168972e.alex.williamson@redhat.com>
References: <20240710112751.7168972e.alex.williamson@redhat.com>
X-PR-Tracked-List-Id: <kvm.vger.kernel.org>
X-PR-Tracked-Message-Id: <20240710112751.7168972e.alex.williamson@redhat.com>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10
X-PR-Tracked-Commit-Id: 5a88a3f67e37e39f933b38ebb4985ba5822e9eca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d6e1712b78251cf4470b0543bb4a8b491949aa32
Message-Id: <172063821049.17909.11277468528686870748.pr-tracker-bot@kernel.org>
Date: Wed, 10 Jul 2024 19:03:30 +0000
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Liu, Yi L" <yi.l.liu@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Wed, 10 Jul 2024 11:27:51 -0600:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d6e1712b78251cf4470b0543bb4a8b491949aa32

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

