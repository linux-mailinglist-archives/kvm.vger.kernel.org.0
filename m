Return-Path: <kvm+bounces-66910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EBFCCEC883
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 21:27:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD5B13019BCF
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 20:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B73930B502;
	Wed, 31 Dec 2025 20:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gU0dX2fh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2F01A239A;
	Wed, 31 Dec 2025 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767212805; cv=none; b=sanLpAUGaHllQxwD6ZAeqMqHmiu6hciMaXcHB+MHFPqe2Kp8coiHTtjUaZ2hDDDdwbbEjL2ddqBJlfAvoSts1oDaz3Ot5ArRwe5hzcMhn+X+RW8qz3K4TEZA79dyL80AwxU0VlucL5i/To7IUPFIGMjnE+TpqsbuxPGiPurjgqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767212805; c=relaxed/simple;
	bh=IVcA4DFKMWxGjB8HqvwpjSkZ5anGQrWEYDfv4osPYwQ=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=cSjOolqNHZLC/D1FcItZMsYYv3bS0q5twWvx5+GNUB1fG1YoIWLnPOUvKaLZnHtYuJBisE7Sn/HT0Tg80Odqva3JMlKyBAftDL4TFi6/bQMwIoMwCMgZB3erwJrzodZ/PNrMYIq2Tx/J734CAJuglYDKrQRZ57YZpM1ewVmW4hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gU0dX2fh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A3DC113D0;
	Wed, 31 Dec 2025 20:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767212805;
	bh=IVcA4DFKMWxGjB8HqvwpjSkZ5anGQrWEYDfv4osPYwQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=gU0dX2fhGQoOOS1aGZzx1zFZHWFOWF91XuB2KZ6L34izyBamIAqJmVn2w6DSBYbTn
	 guMCHFXJWPe6WY6IgXjQO4GVuImkGibVdHUH8sSwE1SpBCNGDUilyy98/ugCALYCm8
	 Rf6xRFYfTMCul4QLxCZN8woqRi8a7kAhFLcoO2HCV1I+nAYUBaW3A4k94Eil/5Ksed
	 Tt8yf64eVQlDTd7lDKDR8gMtW6nofOm5GkTskTDwf6dhpKRSvxp1VJDVymXqvXjWl5
	 oMrrSskKnBdreGPZphDcpQovWox9FyMd2JQTmbWbTd+AGDSJs4h13fQBjoNxdHmRID
	 oph17e2ro/U6w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B64EF3809A83;
	Wed, 31 Dec 2025 20:23:27 +0000 (UTC)
Subject: Re: [GIT PULL] VFIO fixes for v6.19-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251230141739.7e11a0c4.alex@shazbot.org>
References: <20251230141739.7e11a0c4.alex@shazbot.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251230141739.7e11a0c4.alex@shazbot.org>
X-PR-Tracked-Remote: https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc4
X-PR-Tracked-Commit-Id: acf44a2361b8d6356b71a970ab016065b5123b0e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 349bd28a86f2bc33b8c61f6cc7886f45d5c7cda7
Message-Id: <176721260624.3592664.5623653955371085290.pr-tracker-bot@kernel.org>
Date: Wed, 31 Dec 2025 20:23:26 +0000
To: Alex Williamson <alex@shazbot.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Tue, 30 Dec 2025 14:17:39 -0700:

> https://github.com/awilliam/linux-vfio.git tags/vfio-v6.19-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/349bd28a86f2bc33b8c61f6cc7886f45d5c7cda7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

