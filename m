Return-Path: <kvm+bounces-69040-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOhtAOAIdWk3AAEAu9opvQ
	(envelope-from <kvm+bounces-69040-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 19:01:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 491057E6A4
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 19:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B8CE63016D3F
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 18:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708DA255E34;
	Sat, 24 Jan 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsg+06/M"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D8C1917F0;
	Sat, 24 Jan 2026 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769277657; cv=none; b=qL3YY42fRZMmBdf0MzPv4MQsaKYXrAAtXOEgvQfrbzPhJXVisydCb7nQwYIlPY5whdqIbTz2hxTXF5IWxBQu8zUA15sInIJvb3QF8AluCfykogR/X7l+ympIS4Pe2sugpFC235X7D8gKjskqohNverriYQ2U8NJ8C/f9A1E2VKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769277657; c=relaxed/simple;
	bh=9Opwm4ZvfNw2AnFQLfJTk/NOKWSEdQvXsFaGtuz8TwE=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=sC+VzppyKjME3zECM42BxjUAfSxnhKWHbbljNYeSrtyFy+KjrWpsrWcTIwecIFTYKX6wXJQ5sRvQY8ss7sQrr9BAG84Z46cuZE5p8PwtSAQIjIYWJYtkjrDRddaexTMYBvKwIKJl6SBvTA8eYeN8BGOXchRT8P8r+Np0HdCuWOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsg+06/M; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D884C116D0;
	Sat, 24 Jan 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769277657;
	bh=9Opwm4ZvfNw2AnFQLfJTk/NOKWSEdQvXsFaGtuz8TwE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=nsg+06/MEGKd+8DObk10a2WWZcuC+11ZS6gXCTBaR3gr02ukeIIDDpvQSCR1zDX/n
	 mfCWtBcthlGmgAjs2xDwbnQcGDEGw7fHR6OLMAoNG3d9IQNl6wYDur0kGTNhEJPdUQ
	 tcV78iZfIp80RKI9CUcTxa1PWXqojDFfwOFZf7a7vOJ4EU5WWfPxvpn1Jf2xFgi+AA
	 ajTlEXNybkmGjH2YB35w8qqB3sZSuI8SM/ePI2yq/mq8j4Zq3oI9WjVGm9aYNfII0H
	 9HFD4T/ZHjjvmoS66V9juI3w4Gyvv3VqO6ojGQgnY/MARdZLYFmi4s2dXfEz4phxdb
	 dFJDnBtng0LDg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id CF05A380820E;
	Sat, 24 Jan 2026 18:00:53 +0000 (UTC)
Subject: Re: [GIT PULL] KVM fixes for Linux 6.19-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260124081601.16453-1-pbonzini@redhat.com>
References: <20260124081601.16453-1-pbonzini@redhat.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260124081601.16453-1-pbonzini@redhat.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus
X-PR-Tracked-Commit-Id: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4a51fe919b06cb33ab5834600b501058e944f42b
Message-Id: <176927765272.3337695.9143627054969804238.pr-tracker-bot@kernel.org>
Date: Sat, 24 Jan 2026 18:00:52 +0000
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_FROM(0.00)[bounces-69040-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 491057E6A4
X-Rspamd-Action: no action

The pull request you sent on Sat, 24 Jan 2026 09:16:01 +0100:

> https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4a51fe919b06cb33ab5834600b501058e944f42b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

