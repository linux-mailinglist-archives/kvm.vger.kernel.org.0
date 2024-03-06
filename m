Return-Path: <kvm+bounces-11086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DF8A872BEB
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:59:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32D9EB22D9B
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B39E36FD1;
	Wed,  6 Mar 2024 00:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="KupWpdJK"
X-Original-To: kvm@vger.kernel.org
Received: from slateblue.cherry.relay.mailchannels.net (slateblue.cherry.relay.mailchannels.net [23.83.223.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B28612E
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709686732; cv=pass; b=A7U+OABrjPsga/zVEVvR76S6ST+2bqGAQ7cBOUofl8HTvhzSdimxjx5QHKz99vU+WnVh1CEculQclfEHZ+YNYCdocOXQhYw7F8tCLD+9l6O0bStJhlHjG1qnm8OLtuKkeuGoobwjiuqIsub3PoM200D+FopIC4QC3dbwtdgrGJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709686732; c=relaxed/simple;
	bh=d+5Zd4khyhEDwJqmZ6kkCg4maPTRHHQ6hfUNFL/fafY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DukUAnspLuuKmeejQxQtVcshCYL9mck91Ea87iI3SP+OSdw+iIM8IPYcI+QOAPX3AOOOJe4zfD8/xm0nkopOVXfMK2Zsk2EDgeeF7146hkbr97bCq1YamwPmAQvk0plVzOqp1YMqCSIHzxgX9J+sbW21iH9kSyoD16vG9EAcX0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=KupWpdJK; arc=pass smtp.client-ip=23.83.223.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 8A80D76183B
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:49:43 +0000 (UTC)
Received: from pdx1-sub0-mail-a210.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 2740A761D70
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:49:43 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1709686183; a=rsa-sha256;
	cv=none;
	b=K7nv0Lwfk9t/EHclFIs5DxiiDjYBXhHLHUWrHOEeb5HTBkD4G9q5Vg3RXTeQ1nOEwdCFlu
	UN/Zdx4455vhvGV3+3YkNo7FE5g3b6Q41evpsS4OrpHjKOQy03oRdMHedjztjjfVk2f6z4
	V9eNYRIRPVcL+1pnTa7rKuxWmGJyCuRm2Zz3o/okakTMYk0FYZ5BJ1kYe4JpVUW3EDle8h
	9q0rIL2X0xATy2g56dikLZ/DaHOiFZktR9ZwrcV5VGQCIprUVG1mUv1S3zn7NN7csR0gZi
	iFmLIa+O8OB8xiAFmZNAN7oZMYc7P1OeSRbgdqbzjhC+oOr/0X8I4GhgGCz7qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1709686183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNLKvccLFdiUKHv2i3lmJ34W+CDmNNDBX/usWGypHyw=;
	b=0nXwR901hCYqBbGNGzhyCXQgDGviCFepve84/terqnKSlCeYy2sKTJlB9AOnzv11yVNBNK
	9+RVeyBi/rBoAkhYcSMLhQn4d8jt6pgrH94E8SmfmyyCKWB70XY4cGR7c+3IR9zQCjqQGD
	TZdM4k7QJOw9ojFENh6Q8eRbg1YWki/4mRLgq+ddfG73bmt5D7gACT98lKOCG1eJBzQaeT
	wN5IB21IjjidyVEL/vafvuRpwtaPe5JZaMhNqF0iyBJBzrbOPr7UpCA4r7Z9DKzqZn2LoQ
	gIlMVOl2FbXdvVY+UNXEvdBzvv7LAF4S/0UaNd3QhH8PRZ5NFZWJ6Ov1VRflIg==
ARC-Authentication-Results: i=1;
	rspamd-55b4bfd7cb-72zfx;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Left-Stupid: 0720babb093403d9_1709686183379_895519528
X-MC-Loop-Signature: 1709686183379:1417750995
X-MC-Ingress-Time: 1709686183379
Received: from pdx1-sub0-mail-a210.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.124.220.170 (trex/6.9.2);
	Wed, 06 Mar 2024 00:49:43 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a210.dreamhost.com (Postfix) with ESMTPSA id 4TqDNQ6lcCz9F
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 16:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1709686183;
	bh=DNLKvccLFdiUKHv2i3lmJ34W+CDmNNDBX/usWGypHyw=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=KupWpdJKMKNqq4ZM0GGCfLFa2tI4fp5I/QkLxtkIAHekPCxg5xZz38EQpe8siheyd
	 ns/4TuQYU+qyN2id+rZkvzfhCnR3ipJ/Fy+Uw9UEjAQgphtZAdRw/gunKHuDBi72PV
	 XbQKQVyrZM6QslHj5xqAGiR+JEHyrUZ5lkRYp+r1S1k99MvM30t4lfFnorJcU5CD73
	 e5EZB7K/uWJYbwgXA6f5vCwOsAdz1WOOBat/XoJfKd8OYNFyP0SpswORcBLNqtspto
	 L0KNkundKivT2DWttpfdve3cg9iqC2e2KNtIT2Wt1WtcHLoYRPf2acF2j/AJZ0qUUP
	 1EZFIFhkaptvQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e0082
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Tue, 05 Mar 2024 16:49:34 -0800
Date: Tue, 5 Mar 2024 16:49:34 -0800
From: Krister Johansen <kjlx@templeofstupid.com>
To: stable@vger.kernel.org
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Subject: [PATCH 5.15.y v2 0/2] fix softlockups in stage2_apply_range()
Message-ID: <cover.1709685364.git.kjlx@templeofstupid.com>
References: <cover.1709665227.git.kjlx@templeofstupid.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1709665227.git.kjlx@templeofstupid.com>

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

Change in v2:  I ran format-patch without the --from option which incorrectly
generated the first series without leaving Oliver in place as the author.  The
v2 should retain the correct authorship.  Apologies for the mistake.

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


