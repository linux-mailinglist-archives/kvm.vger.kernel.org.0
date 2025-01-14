Return-Path: <kvm+bounces-35368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 494E1A10592
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 12:37:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CC4757A0600
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 11:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF73234D0D;
	Tue, 14 Jan 2025 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="piXy+fmx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 426D6234D01;
	Tue, 14 Jan 2025 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736854668; cv=none; b=rscMnoJC0OZGk9xkPk84K6gUdJTMJP4LL6c+H9/Ss9Qg9pdOit4rTD4NbaxnNJ8nxmIjbCHGW39bdCNKgiaOW4XEv0Zrh/863ZR7BkhiAbp6VvpMZXxWW3wAMm1L1soBlTH6X7bxx7uD01vkzcqAZZ6BvXdPn1aKxeU7Vbi7UkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736854668; c=relaxed/simple;
	bh=LCU2BqrkYnMixzNGqgtubf2sA3LVBqm5Sym2l2hLSbg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gd5AjVNtdfM/+NjApRLt1JxTJre7kO0YpWOqKHTftB0J0hHbzH+/WzBwFF/aKFtTe4FYdG0f3zFrvKF1zGXnF/CfkphGFKDWw5M+ADAOHi7sbcKauuEAN3Tkkxso+l48jGcO1x/VPZi1edJ77X3luUP/1Y+A0N9sC4DGBUN7n9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=piXy+fmx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D86CC4CEDD;
	Tue, 14 Jan 2025 11:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736854667;
	bh=LCU2BqrkYnMixzNGqgtubf2sA3LVBqm5Sym2l2hLSbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piXy+fmxJ9AqbQmmPbVJUBW7zZCQU9MOu0QYpes6k3T7aynJbQxQ/qLF8GL2goH9i
	 oAeTg0zROrvMjRJYFg6y0cor7koLv634jCRK4bX+S9YcOQH0eWwAnpO9HjjVa3tO+P
	 jPuFArGtrRH9JNW7BuaUvlAYlVzHuPjCy2b4J6eZAOEvIXeIboo8FqwH5iFUccBqJ7
	 QgCsKqitUqOa39Kc2MddO/U+nVayinfyajuN+kddnklCH7ueNcUS+gUdOyQJ6Pp4Ly
	 kZ+U4An3H46QJoFZfwOaAcLFgQs7PwB0MocrxQgS98X2AJPr1hrLEm0eStfZM4LFD/
	 +t4cbH3MP8pDA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXfEv-00C6r6-9b;
	Tue, 14 Jan 2025 11:37:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH 0/2] KVM: arm64: nv: Fix sysreg RESx-ication
Date: Tue, 14 Jan 2025 11:37:41 +0000
Message-Id: <173685465356.1386682.11809569175289871162.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250112165029.1181056-1-maz@kernel.org>
References: <20250112165029.1181056-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, maz@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Sun, 12 Jan 2025 16:50:27 +0000, Marc Zyngier wrote:
> Joey recently reported that some rather basic tests were failing on
> NV, and managed to track it down to critical register fields (such as
> HCR_EL2.E2H) not having their expect value.
> 
> Further investigation has outlined a couple of critical issues:
> 
> - Evaluating HCR_EL2.E2H must always be done with a sanitising
>   accessor, no ifs, no buts. Given that KVM assumes a fixed value for
>   this bit, we cannot leave it to the guest to mess with.
> 
> [...]

Applied to next, thanks!

[1/2] KVM: arm64: nv: Always evaluate HCR_EL2 using sanitising accessors
      commit: c139b6d1b4d27724987af5071177fb5f3d60c1e4
[2/2] KVM: arm64: nv: Apply RESx settings to sysreg reset values
      commit: 36f998de853cfad60508dfdfb41c9c40a2245f19

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.



