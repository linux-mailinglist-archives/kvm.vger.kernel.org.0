Return-Path: <kvm+bounces-49083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95ADCAD5A97
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 17:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BCFD172A68
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 15:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC3E1DED52;
	Wed, 11 Jun 2025 15:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FsfYJjMt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5D4156F45
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749656095; cv=none; b=fBPYlfQEtdcOaoladNhJZIiScwidScRv98srWjhTN1R+rYHJeuifdRp1lUhfeRT/V5QS8gUpgLUtCKVjDKPpkyHeYErlCZ2tPNy+4y80xaX1Q5j310tpGvqV3K1XyUkAS9AfJjmzPoAfJQU1oq/e5SbL/r8NbeWULdLQqmTtEPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749656095; c=relaxed/simple;
	bh=6Lp1YjREXD8XuU03fSOrFeXNy8fDR+x1wFcllQdfkVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNvz4vBDyIpP2QleX8MbNoFsG7TtQ3/RAV8CwU3SEv8xGTxiP8S27uko3/TusKhwdAQIzfO7UJ0CwR2i5QvghxWUUv3FUdq56aDp265mwpTLGFnR5Q4GoQmmQxct6rJcFOFXrKv0Xy18G1I38mCopD7/gc/k55u4Kk0qa1pCYuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FsfYJjMt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6B1C4CEE3;
	Wed, 11 Jun 2025 15:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749656095;
	bh=6Lp1YjREXD8XuU03fSOrFeXNy8fDR+x1wFcllQdfkVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FsfYJjMtTs7znHFEZqLYWl4T7e4Ix37q/ZvcunI77l/4kQNEu3r0cyAcTlyCIvr/p
	 iqYZYl/5+PpzH2t79viXsOXIF4x15a07sDt574XImc/8E5Qjl2MXcp0hg/Y+Kf4Kur
	 UNRSE3LWJ1dcRZ7Sj2woscR0ChWy3P1ckZZrfBN3mFJTKxhRFQ+HjC6t8NCmfWKgI9
	 eOK/8EjXiEv2VWguY/UkQd7DLOSURbmgYyEk69dUM2bmE9suQT61HcfPihKcFJ6A9K
	 xD9SfaZtuWwqHaX+WxKYWpi0Vrfs7zEzVSPMbeq6PRS7gndzjfXnFgBwbmtgmnIR3h
	 aM5+DB6VTMzhQ==
Date: Wed, 11 Jun 2025 21:03:16 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Delete split IRQ chip variants of
 apic and ioapic tests
Message-ID: <hgumicvwzdqahup3qt3vsquxwesu2rlupabog2ubucpsz5ydth@3j2i36vyddjz>
References: <20250604000812.199087-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250604000812.199087-1-seanjc@google.com>

On Tue, Jun 03, 2025 at 05:08:12PM -0700, Sean Christopherson wrote:
> Remove the dedicated {io,}apic-split testcases and instead rely on users
> to run KVM-Unit-Tests with ACCEL="kvm,kernel_irqchip=split" to provide the
> desired coverage.
> 
> While providing more coverage by "default" is nice, the flip side of doing
> so is that makes it annoying for an end user to do more, and gives the
> false impression that the configurations in unittests.cfg are the only
> configurations worth testing.

Got it, thanks for the patch!

> 
> E.g. with kernel_irqchip=split, svm_npt fails on x2AVIC hardware due to
> test bugs, hyperv_connections fails due to what is effectively a QEMU bug
> that also got hoisted into KVM], and vmx_apic_passthrough_tpr_threshold_test
> fails (with some KVM versions) due to a KVM bug that happened to be masked
> by another KVM bug with the in-kernel PIT emulation.
> 
> Link: https://lore.kernel.org/all/Z8ZBzEJ7--VWKdWd@google.com
> Link: https://lore.kernel.org/all/202502271500.28201544-lkp@intel.com
> Link: https://lore.kernel.org/all/20250304211223.124321-1-seanjc@google.com
> Cc: Naveen N Rao <naveen@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/unittests.cfg | 13 -------------
>  1 file changed, 13 deletions(-)

I know you have pulled this already, but FWIW:
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


