Return-Path: <kvm+bounces-71388-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yHWiM0Pfl2nW9gIAu9opvQ
	(envelope-from <kvm+bounces-71388-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 05:12:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F39EA1648FE
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 05:12:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CBEFB301FD91
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 04:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45C912F7AB0;
	Fri, 20 Feb 2026 04:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMaFyqG2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C88A2F691D;
	Fri, 20 Feb 2026 04:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771560641; cv=none; b=LRlKMBesv//lzc8Dhuq8ukyJyXp4+0aMWPfxxwmRZrr5xrDWbHQbDaDGp1Yfu5xAXXsaY/SjUNTc3srgUWGt8uGRhRAP12PxTlHyuP6a50TO37PnhKCkPegQ3g5rnd3RTVh1RpIy5IhsZk4lx6hUqrGsukHT3iCzzrFI2xd9Vxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771560641; c=relaxed/simple;
	bh=fHDGQg8Y8I31uG+H3itYMHO1lNQuNdbaHv3s+w2VA9E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fuUXnQ3m/mXXhicl7LSDcwrZX7poUGBiTAYTTvJKyaeHu8+lr4s1PqwX0Bqm5cuniZIaF+Tuywgy9hMtmQL9qCt0i4A2v8/e8I8uoDnwU6XwbcO0ya5vzNfura39Y3HRsIh6BhkSBtjW2QVOyFXrt1jjEcv/GDx4lq0PiBfDQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMaFyqG2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7E0C19424;
	Fri, 20 Feb 2026 04:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771560641;
	bh=fHDGQg8Y8I31uG+H3itYMHO1lNQuNdbaHv3s+w2VA9E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oMaFyqG2bTps/8USOYgV6sHoWWaZWkyD8fr7yLmY5l7usrVYWzQZzpzEhFrj5oIso
	 JsHHbdcmGWZfgObZBMrrGYnYu32BPlMnnVgwwSDA1ys0qiJ1qOLadxN3JSuLSdLeIV
	 tnZk2pdJNKsAWT931GvGXNP4fol0h+61TmknQ8GSGiCMQCV6UL7UDupsNR66mU84jY
	 Uf0+Fkd9Pj07dGm9AzWla0qfC5/ONLfwGajcUnLXdYT+BVuNcuJZmO6sBygjchoA7g
	 hhSIJI8pnZDmIXMjKC9Jz5/fJyymINQf46MMxuBF/t5nZ792GREhqQxlQeEORgXYm7
	 E3Z2SpOIzWr4w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA0853809A88;
	Fri, 20 Feb 2026 04:10:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 00/21] paravirt: cleanup and reorg
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177156064929.189817.13253801870624912064.git-patchwork-notify@kernel.org>
Date: Fri, 20 Feb 2026 04:10:49 +0000
References: <20260105110520.21356-1-jgross@suse.com>
In-Reply-To: <20260105110520.21356-1-jgross@suse.com>
To: =?utf-8?b?SsO8cmdlbiBHcm/DnyA8amdyb3NzQHN1c2UuY29tPg==?=@codeaurora.org
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, luto@kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, kys@microsoft.com,
 haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
 longli@microsoft.com, peterz@infradead.org, will@kernel.org,
 boqun.feng@gmail.com, longman@redhat.com, jikos@kernel.org,
 jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
 boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
 ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
 bcm-kernel-feedback-list@broadcom.com, linux@armlinux.org.uk,
 catalin.marinas@arm.com, chenhuacai@kernel.org, kernel@xen0n.name,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 chleroy@kernel.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
 vkuznets@redhat.com, sstabellini@kernel.org, oleksandr_tyshchenko@epam.com,
 daniel.lezcano@linaro.org, oleg@redhat.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[signature check failed: fail, {[1] = sig:subspace.kernel.org:reject}];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:-];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	R_DKIM_REJECT(0.00)[kernel.org:s=k20201202];
	FREEMAIL_CC(0.00)[lists.infradead.org,vger.kernel.org,kernel.org,lists.linux.dev,lists.ozlabs.org,linutronix.de,redhat.com,alien8.de,linux.intel.com,zytor.com,microsoft.com,infradead.org,gmail.com,oracle.com,lists.xenproject.org,broadcom.com,armlinux.org.uk,arm.com,xen0n.name,linux.ibm.com,ellerman.id.au,dabbelt.com,eecs.berkeley.edu,ghiti.fr,linaro.org,goodmis.org,google.com,suse.de,epam.com];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,kvm@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-71388-lists,kvm=lfdr.de,linux-riscv];
	NEURAL_SPAM(0.00)[0.383];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	RCPT_COUNT_GT_50(0.00)[58];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alien8.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F39EA1648FE
X-Rspamd-Action: no action

Hello:

This series was applied to riscv/linux.git (fixes)
by Borislav Petkov (AMD) <bp@alien8.de>:

On Mon,  5 Jan 2026 12:04:59 +0100 you wrote:
> Some cleanups and reorg of paravirt code and headers:
> 
> - The first 2 patches should be not controversial at all, as they
>   remove just some no longer needed #include and struct forward
>   declarations.
> 
> - The 3rd patch is removing CONFIG_PARAVIRT_DEBUG, which IMO has
>   no real value, as it just changes a crash to a BUG() (the stack
>   trace will basically be the same). As the maintainer of the main
>   paravirt user (Xen) I have never seen this crash/BUG() to happen.
> 
> [...]

Here is the summary with links:
  - [v5,05/21] paravirt: Remove asm/paravirt_api_clock.h
    https://git.kernel.org/riscv/c/68b10fd40d49
  - [v5,06/21] sched: Move clock related paravirt code to kernel/sched
    https://git.kernel.org/riscv/c/e6b2aa6d4004
  - [v5,10/21] riscv/paravirt: Use common code for paravirt_steal_clock()
    https://git.kernel.org/riscv/c/ee9ffcf99f07

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



