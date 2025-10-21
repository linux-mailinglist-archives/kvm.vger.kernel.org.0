Return-Path: <kvm+bounces-60702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 262C8BF7FDC
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2E383ACD57
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC38434E74E;
	Tue, 21 Oct 2025 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ByFrb+rV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EBNSGVCt"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD61145B27;
	Tue, 21 Oct 2025 17:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761069383; cv=none; b=f6ISsyPBQEypxAwbdHjJXIp/eVoy20fV/fgqYiGUfvkTS25V6+/qZEDNczwGycZH04MEekvtDnmBPgUy9We7HQTWVvpHrIlooKqM6SJKLAtMixDfoejGltcrXJaOrloOwj86uygU9qUXHwfZGINva3HkHVbrMkG1E9v1uOpW4IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761069383; c=relaxed/simple;
	bh=kdJbQlHr7SVojT6O/yafv3JN1eydhc5dG279GAI5Rh4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=CnZxPJLVmMSBSjP+lGokYxBBYSsXDaGOcvptuzJ5azz2/LcQNyM6y3uLavoT448DfIKYhucGMpPVZNkYSlFQ3hfg87S4ehW+DMrSUFYEwYpN/MDmmkW5bofYsnHU3gdQMQ1paNR9U99ThxK7NBro+yy2S7N52XymJODL3eKlRf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ByFrb+rV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EBNSGVCt; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id B8FAAEC010A;
	Tue, 21 Oct 2025 13:56:18 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 21 Oct 2025 13:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:message-id:mime-version:reply-to
	:subject:subject:to:to; s=fm1; t=1761069378; x=1761155778; bh=Fs
	ZaDVo3mx36GaalwjwGl4VMzh7w8alfiF8lN7kDfEQ=; b=ByFrb+rVVLkii7nHy+
	LIgx0lWBkuWPQatfGcrdb4kb5ENuXhB6jdUWj7YXMdjls9DkVM7y8305MJDV5d+9
	ZqApHgvPISt+8EKsoBJo7s6pqbdFW9sboqHoVTBUYuJf9U/mug8WMnQEqA76lgZT
	Gn3Y1NFvQqhwf022VhxvaZJDW+CSzHp3NAxM+8BHH+mJ9ccRvV+hqk70VgjrCBGo
	eMuoLjE+Exc5Az+gCDVhiaRYAWo7rlxUK09VYEINWBH6lmU0f+GsTfzOx4gQFO2i
	gP2OgCCO4x4OVIuntLA6fsC7Bu6jMr4gDkrmPOrpUzluT3pv4VJ4gsLh9XG2Xwb5
	FzYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1761069378; x=1761155778; bh=FsZaDVo3mx36GaalwjwGl4VMzh7w
	8alfiF8lN7kDfEQ=; b=EBNSGVCtZSt4ZQDroVQvh6xNcSlhruwWsdurOWdYmx+4
	n44hGCK2Ft/KhHoRAIg/NzXGWtL1pcK4nQ7vMQkXRRaaZPmRuWz6tnkdRahyvAz4
	s3UtaCvDblnvZBCpb1p4xs9KpqGaN6jbmhwUWdaUuFXHKKvKe7hQb+jPPRTIKjdX
	0sMN1z/wLCirmPEzrCx0XIowIOFrvoX6hAONlExgoczIUmMwvH5rs2czHW05P4ci
	oTa/fxYc2SWpZ8hEiQWfNomSI4Wc8kMAGg9aS8z+PDXkigRvVVjG1zC+8UjP/ygE
	LzxqWZi+TuumKt50GMJb49ifNdRe8iB1jrnwRIja8Q==
X-ME-Sender: <xms:Qsn3aAaRxhlOD7ygN-MRKmmteQ1gJ8L1BSL35913N3GWIBO2Lvo4Dg>
    <xme:Qsn3aJMxfx614mU5_VhQUX5u70kBN8jZuGFuiER0H3JWxqtc3e_GmkXLu2KYn6_h4
    iY3jxmCZdDR1pM781DD2hXR2HjNHomxecTc4_nwax0Xh3fbsOrnhQ>
X-ME-Received: <xmr:Qsn3aFZjdx2YTym6KnjXf253e_SQwdcWP24pobYBcatZyU6Un6wUf_T3Wqs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugedufeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucghihhl
    lhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrthhtvg
    hrnhepieefgeeileehheeuhefghefhgfehvdfgtdeiffeuhfdvvdekhefhueeuudfffeel
    necuffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgs
    pghrtghpthhtohepgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrg
    hlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvh
    hmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghlvgigrdifihhllhhi
    rghmshhonhesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:Qsn3aH3d8kSgBMkUiAYbR-YflSz760oKsmhmlicFzX1DtrHb1K-dJg>
    <xmx:Qsn3aLevjavPq2HQCdzWVnes7hY8oVEXNZAT6Nqhz6S4p7HmbuPqgA>
    <xmx:Qsn3aIEhEyFEMFujscUzeoXBUB5lbc5IexVESv-pNZgqzuIYZhvqUQ>
    <xmx:Qsn3aM28PakenGLA6o4Bkw6AXx5a7M-Neh9YCcL42cFx5I_q9I_SSA>
    <xmx:Qsn3aCxxZhba38RfDV1GB0as-wvIkgrxbgipRa4RF5a5fkIUozK17Yyr>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Oct 2025 13:56:17 -0400 (EDT)
Date: Tue, 21 Oct 2025 11:56:15 -0600
From: Alex Williamson <alex@shazbot.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, <alex.williamson@redhat.com>
Subject: [GIT PULL] VFIO update for v6.18-rc3
Message-ID: <20251021115615.4e5dd756@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Linus,

A tiny update as I'm changing jobs.  Different email, same signing key
for now.  Thanks,

Alex

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.18-rc3

for you to fetch changes up to b2c37c1168f537900158c860174001d055d8d583:

  MAINTAINERS: Update Alex Williamson's email address (2025-10-20 15:45:03 -0600)

----------------------------------------------------------------
VFIO update for v6.18-rc3

 - Update VFIO maintainers entry (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      MAINTAINERS: Update Alex Williamson's email address

 .mailmap    | 1 +
 MAINTAINERS | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

