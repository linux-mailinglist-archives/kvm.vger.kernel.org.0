Return-Path: <kvm+bounces-71394-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WN10ClLgl2ne9gIAu9opvQ
	(envelope-from <kvm+bounces-71394-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 05:17:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA591164A78
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 05:17:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C4C4430C2416
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 04:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D07732F765;
	Fri, 20 Feb 2026 04:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PI8xqvtK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838BF32E6A2;
	Fri, 20 Feb 2026 04:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771560656; cv=none; b=SDbyCieHcn7hHUdSQuYXw2DgJGcGnyY7oeNZ7qXCGJJx2NqlH3iSc+EyGQ2ZzeE2yQtWabttjb0BPaqD6RCbtpSnKMlNsKpqcioB5WLFUy3KMj4XFmbUiWOpQIJjvMjMkuAEgJGwyJUhHW3cLHOFU8AJ7zSez9IUahRkO6dznhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771560656; c=relaxed/simple;
	bh=3KVU56LlvB/E74bXL0kiXIK3YWovwzwFpcCv6TDm0yg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=J8ZalURm0opRIlrvFRScAz2/XHsK/qO2eOJ+4UCbCsJYa+IbgGOkSmng5U8un9Qh5z/k+G59LegY+Laf2mUQaRHb57hT1s7UxuAXv91yWRz9gqeoT+lFw5cJ82BbqF7tTEsob6DBEQtnnSyqo1MawY/qpLDnrE0sN3ePy9cozpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PI8xqvtK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C601C19421;
	Fri, 20 Feb 2026 04:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560656;
	bh=3KVU56LlvB/E74bXL0kiXIK3YWovwzwFpcCv6TDm0yg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PI8xqvtK6mt4NbScn0lPJJcRTuhp4oZSjEV5Bunk199bmj2O35FGRjyUrG0ucZtwv
	 Sry3bA5yvXF3253Owr+6Y2CnaxKM5TG1sVYwgjaPUHZ3twZ5MLNZJ7n5whiDKx2nFF
	 bz6ONRijkFxar+yzOhAvv4Qhg+pl/ROaVFIz0JIW80Q8C0LZIOjvvvElTU/hKGtrqK
	 eIy3/yUYokjnwhHTpZ5RoqmDfe+k4v+ccLgGMS7LzrK8cXPG1/joPZL0VCXMMJ16Ig
	 /tavtvZ52AbSW/kNnBu0thcamZtTfO2cdraY0OjA7kRtTRD3V6taSv56yzsXXjCjUA
	 Zn2Y5nUyVhhWw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA0463809A88;
	Fri, 20 Feb 2026 04:11:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] irqchip/riscv-imsic: Adjust the number of available
 guest
 irq files
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156066430.189817.17794056497252031488.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:11:04 +0000
References: <20260104133457.57742-1-luxu.kernel@bytedance.com>
In-Reply-To: <20260104133457.57742-1-luxu.kernel@bytedance.com>
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: linux-riscv@lists.infradead.org, anup@brainfault.org,
 atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71394-lists,kvm=lfdr.de,linux-riscv];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NO_DN(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[brainfault.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BA591164A78
X-Rspamd-Action: no action

Hello:

This patch was applied to riscv/linux.git (fixes)
by Anup Patel <anup@brainfault.org>:

On Sun,  4 Jan 2026 21:34:57 +0800 you wrote:
> Currently, KVM assumes the minimum of implemented HGEIE bits and
> "BIT(gc->guest_index_bits) - 1" as the number of guest files available
> across all CPUs. This will not work when CPUs have different number
> of guest files because KVM may incorrectly allocate a guest file on a
> CPU with fewer guest files.
> 
> To address above, during initialization, calculate the number of
> available guest interrupt files according to MMIO resources and
> constrain the number of guest interrupt files that can be allocated
> by KVM.
> 
> [...]

Here is the summary with links:
  - [v5] irqchip/riscv-imsic: Adjust the number of available guest irq files
    https://git.kernel.org/riscv/c/376e2f8cca28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



