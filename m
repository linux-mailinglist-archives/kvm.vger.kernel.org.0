Return-Path: <kvm+bounces-41219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3042EA64C0E
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 12:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 525901885851
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:14:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5584523314E;
	Mon, 17 Mar 2025 11:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tIS/Ow7G"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F1738DD8;
	Mon, 17 Mar 2025 11:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742210068; cv=none; b=uPhbFnSMCpsJx6CgNlI0mkINQpcgSBfpPce6lOtta3qq8Kc69T00jsYi6GydU7FKJMOdp6NUEQxSC/3XuIKgkK8zIxn7twRMD8E0XfSDzRlyBUeo5LkYTOM6x3c/ptFZpRnKf+i6Md4x6oHhJJguudsjqzpROMvmQKoMqbNP4gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742210068; c=relaxed/simple;
	bh=olspEIPKk6rcyvIO+w/teEaMf7L+mVlGm6dUa9CeGt0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=SAaVGtuGmBqntWYu/e1MuKxXMLxltHqWC5gDgTb8VQZbuSK3LLCAUnT6Bb+uZv6Jkbp0R0reR/vQN5d3J/kgh71Y55Zc2QWB6q6VWQ3Po83HFhEmDYGUGHxDtKhqEYUWdsOH54tnvs+Z1sHtyFAojLOHk2y/BKD4BHLAfRR6g70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tIS/Ow7G; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40217C4CEE3;
	Mon, 17 Mar 2025 11:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742210068;
	bh=olspEIPKk6rcyvIO+w/teEaMf7L+mVlGm6dUa9CeGt0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tIS/Ow7GXqsWtQyG1cWgOVYafiS9fSXmvDQcK4bT8uIgL0oHGfGRp5lX4Wui9UjcE
	 YM7TVYFsaA+n9xZ3X22nXGxQ1Zzw18eWH/NMHl6ozjkflHXvMdRWH5R7DdlMCMqVyk
	 +Z5E7CXvPHVTZpmZLVsXltPw/8ec8EKeWPo4fdIiLEiPNwtWyzEhMhS4VzMy5AFqJH
	 6kZmcwqjLwLul1cHWLeu49dBpbI9bT4cAUZNZ+NVhH+C74/uxwOqZTCR38E8pGHLC7
	 SSagaLrNVTpowRIhD0hnHl57hpXlsb/A7HL7QUfsR4qxrUxcvtlHP2epoV125xCAvw
	 /oNHJOrq5mqhw==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tu8QM-00EGdc-4o;
	Mon, 17 Mar 2025 11:14:26 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 17 Mar 2025 11:14:25 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, Will Deacon
 <will@kernel.org>, Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 0/9] arm: Drop support for 32-bit kvmtool
In-Reply-To: <20250314222516.1302429-1-oliver.upton@linux.dev>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
User-Agent: Roundcube Webmail/1.4.15
Message-ID: <a1eb2b0dd3cfe00cce12278ae44b9117@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2025-03-14 22:25, Oliver Upton wrote:
> The last stable kernel to support 32-bit KVM/arm is 5.4, which is on
> track for EOL at the end of this year. Considering this, and the fact
> that 32-bit KVM never saw much usage in the first place, it is probably
> time to toss out the coprolite.

coprolithe! :D

> 
> Of course, this has no effect on the support for 32-bit guests on 
> 64-bit
> KVM.
> 
> Oliver Upton (9):
>   Drop support for 32-bit arm
>   arm64: Move arm64-only features into main directory
>   arm64: Combine kvm.c
>   arm64: Merge kvm-cpu.c
>   arm64: Combine kvm-config-arch.h
>   arm64: Move remaining kvm/* headers
>   arm64: Move asm headers
>   arm64: Rename top-level directory
>   arm64: Get rid of the 'arm-common' include directory

FWIW:

Acked-by: Marc Zyngier <maz@kernel.org>

         M.
-- 
Jazz is not dead. It just smells funny...

