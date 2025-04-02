Return-Path: <kvm+bounces-42437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DDFA786A9
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3083418921DD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E91C1547F2;
	Wed,  2 Apr 2025 03:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WnfYF05p"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E7813212A;
	Wed,  2 Apr 2025 03:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743562801; cv=none; b=t5sDUVhCqky3WD+oQwjG8+dQvuu0yVQMuPlbnbaRM4ic7k1TBAIXyrBAo8FrWn+ma3Wid+6OmhSFI6Ol/CiWK95XBOjtiaGqlk/OxhuMdxp7idrDzf6N8D6eXfHHNmmeFZ7kWirQAkWefsalOwkOAVJ6CTYpk9VdxsAo3IXZTEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743562801; c=relaxed/simple;
	bh=cBegnqxyaf7YFhV8gdshiCgSRHNCbqwZpHwMsgzPVU8=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=tRG0gW5s5zqKSoIU66hIJmqCYBT0YPmGQ3qOySDhMX34N3pE0UpLYBO6L8zEv1QZ0jfqyDrjdfaSZ1qkxlX/m8CdHbUi9mn+Eo2WwI3eGynxpyDkuk16Pd3LzGyjnCQhRkXsK48KPHAXiRvedoxZWuPl9Vh7twDBY70gvzcpZHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WnfYF05p; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155D9C4CEE4;
	Wed,  2 Apr 2025 03:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743562801;
	bh=cBegnqxyaf7YFhV8gdshiCgSRHNCbqwZpHwMsgzPVU8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WnfYF05peA4S0kOdhskH/oX0d4S7GtV1w47wb0BVdpkUHw8vdEIFsJaT9WnEdLZVm
	 +i6UISHWhX13Bm0I7dfFe5yWLPOQkdL+6Dx3neGi5637PigkSYObOJfQgcRW6A/UqZ
	 fFHot6nRlgVc+n1es2MPp881gqHjNJnBDPzazn98rfq9/18MUEc+9I/lHt9cgFGe2t
	 hfBIiEUfoLnPD3k0tCatpbsc/ad2jQsXUeLMkYv3n9hNhiLR0E2OxXAQj+SIpCylAE
	 vghABnO3fKyef2GvJtECxLrCp9Z1axoVbanc5F72Op7FkTlkfpLI1ZL6/+7QOEJRKd
	 0kTjRy79jpfQA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F292C380AAFD;
	Wed,  2 Apr 2025 03:00:38 +0000 (UTC)
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250331123404-mutt-send-email-mst@kernel.org>
References: <20250331123404-mutt-send-email-mst@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250331123404-mutt-send-email-mst@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
X-PR-Tracked-Commit-Id: 9d8960672d63db4b3b04542f5622748b345c637a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4b98d5dcd145aab10219b9f259b70110cd34f01a
Message-Id: <174356283768.1007346.2332728582930191029.pr-tracker-bot@kernel.org>
Date: Wed, 02 Apr 2025 03:00:37 +0000
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, anton.yakovlev@opensynergy.com, bettyzhou@google.com, cong.meng@oracle.com, dtatulea@nvidia.com, eauger@redhat.com, eperezma@redhat.com, eric.auger@redhat.com, hongyu.ning@linux.intel.com, jasowang@redhat.com, jstultz@google.com, kernel-team@android.com, kshk@linux.ibm.com, linux-sound@vger.kernel.org, michael.christie@oracle.com, mst@redhat.com, perex@perex.cz, sgarzare@redhat.com, si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@redhat.com, tiwai@suse.com, virtualization@lists.linux.dev, wangyufeng@kylinos.cn, wh1sper@zju.edu.cn
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

The pull request you sent on Mon, 31 Mar 2025 12:34:04 -0400:

> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4b98d5dcd145aab10219b9f259b70110cd34f01a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

