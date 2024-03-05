Return-Path: <kvm+bounces-11063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1D68727D5
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 20:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 472411F29352
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 19:42:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A75955C607;
	Tue,  5 Mar 2024 19:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="knva6nXZ"
X-Original-To: kvm@vger.kernel.org
Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC3F5C601
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 19:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709667710; cv=pass; b=iW1XTatAcJ6juP7c6aAwcJdg3x0XXUWMvayoxVRBq6zYKsApoQZd8/auLodWLbKYG+TGW+nRewC2gDST7VsBOyXM4vO3Psz822rg2tboKyAKtMddSUPBuUiF1+hMbrZ7UnD8fk+nNV3FRB3TRJGjAPI1hdV96aGC895K0DDoKR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709667710; c=relaxed/simple;
	bh=giaEKfckGjS3IKGGoymltghhXFc22afEJBfjWIyAyuU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NvQ39q/P0RS/nU5n8s1yDPJMoLUZPe3Yuzpk5dyeDiIvqI0K5S51ZXD7fpYhCp93rCOJY7x6R5y2uKxB9CEOgmgiKBWx7M4MyPXnBl+Wwmu9ZhiCjlCX2IkAQH5PbkJux83xXFQXC03NN2kX5ZXMD+GNPz/xhjz0cSIbgOOiAIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=knva6nXZ; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 27E545018ED
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 19:41:48 +0000 (UTC)
Received: from pdx1-sub0-mail-a206.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B010C502586
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 19:41:47 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1709667707; a=rsa-sha256;
	cv=none;
	b=K/fS+wIisssVNgEsZ8d7hGLMeQlrErFxHvSmi0b69HjWrbB59C9GD0GJprOpIU4a8ElP6h
	KbAr2qZjJW0Ixbl99F5cBXXrvMsljjZBHGOJdu47/XqtpAiZkzxWSrc4Q/vS3XevsXwEJM
	AWZ+ef/scqsqRoP4njAbYn4vDk0/nHWVx6vnJLq9gsUl/szHBu2RIK4EvaBub2Wh82ZqMf
	ZaVDamqjjrZNyB3I3gtakA6+sLqhZ0rghOXXMksPmigB0/Q8R5BPf4bEMZX4AiSIiSIRJq
	RzpE2f6AJkwD0eFvZ8+d7sfS7MfNqgx1/LaKccv0eZutmaG76k4RRF2VQ8wUZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1709667707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=LpYhkwRacccxYX97IU6DnVg+TCfnBanFzugoowp1BSc=;
	b=g3EtBrDdXUyF4RD0DR4mmU2xVJhEqYeLWFNLhsFq9Z0978hdMufiJZTBe0PqH0rldNE34I
	z+uSJAL/wUtJrqMIWToBwJAMBtfG3LnNR3t4qZ5aP2Xh0/mZubyzJEuk5lJLEfe0BDhYJb
	H/f8jAtHrGWitGG2ll/ZqX2NjBIGqxg2j2he/ok9Fhu6+M+zaL0nAdvz9Ps75JzMj+eYk9
	0KiCVUAwneqHU9IBrxnd69Ut7LgbNTHZVqhQoe4xXMr0r6WGZK8y3m8undDUd2Yz10S5yA
	5AxGyV/NwZDwXtZDoICI7L+urvtxvl3b0EGgpDbVde7CvzDUDRjjvF5XfmGoBA==
ARC-Authentication-Results: i=1;
	rspamd-7f9dd9fb96-fw85s;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Rock-Abiding: 370e0a781b359892_1709667707967_1029468684
X-MC-Loop-Signature: 1709667707967:366236100
X-MC-Ingress-Time: 1709667707967
Received: from pdx1-sub0-mail-a206.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.104.192.87 (trex/6.9.2);
	Tue, 05 Mar 2024 19:41:47 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a206.dreamhost.com (Postfix) with ESMTPSA id 4Tq5Y73bCtz16
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 11:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1709667707;
	bh=LpYhkwRacccxYX97IU6DnVg+TCfnBanFzugoowp1BSc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=knva6nXZzUfXzecR0T2AUebiWkgg6Jw6UPmg56LI9hT1XxhGv/5HbgCZbKqd6F24B
	 dr4jhyKbiIM6tc2+af4mFXDJLp5t6HG36+/rNhsqwlq6l1+OvtZrtteyt5uHJ9rxE7
	 rqCgWTg1uDdpD1RMQN6omFZ0GnE1yjXC8i78p/7GYG2Mjc89V9y/lMEsLDyVUu5To/
	 yYYoXYd/OhcNZZtHjdQFeJO8EzHQIbyl1GemNSzte39thRTeCGtTDf0tagQqSIjd+g
	 7Z3xDMzKOyWbMwxNsM3tGuKMTg5WumyMhhEQW0J1eGqNNs6Gn5lgf0S/J+BcNMIi3m
	 xOH6jCG4rcbOQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e00eb
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Tue, 05 Mar 2024 11:41:38 -0800
Date: Tue, 5 Mar 2024 11:41:38 -0800
From: Krister Johansen <kjlx@templeofstupid.com>
To: stable@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: [PATCH 5.15.y 0/2] fix softlockups in stage2_apply_range()
Message-ID: <cover.1709665227.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Stable Team,
In 5.15, unmapping large kvm vms on arm64 can generate softlockups.  My team has
been hitting this when tearing down VMs > 100Gb in size.

Oliver fixed this with the attached patches.  They've been in mainline since
6.1.

I tested on 5.15.150 with these patches applied. When they're present,
both the dirty_log_perf_test detailed in the second patch, and
kvm_page_table_test no longer generate softlockups when unmapping VMs
with large memory configurations.

Would you please consider these patches for inclusion in an upcoming 5.15
release?

Thanks,

-K

Oliver Upton (2):
  KVM: arm64: Work out supported block level at compile time
  KVM: arm64: Limit stage2_apply_range() batch size to largest block

 arch/arm64/include/asm/kvm_pgtable.h    | 18 +++++++++++++-----
 arch/arm64/include/asm/stage2_pgtable.h | 20 --------------------
 arch/arm64/kvm/mmu.c                    |  9 ++++++++-
 3 files changed, 21 insertions(+), 26 deletions(-)

-- 
2.25.1


