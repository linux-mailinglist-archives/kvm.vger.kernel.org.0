Return-Path: <kvm+bounces-52159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E421B01D63
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:26:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE88F1CA55E8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:26:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB772D3A6D;
	Fri, 11 Jul 2025 13:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZFMgq/Nu"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A582D373C;
	Fri, 11 Jul 2025 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240354; cv=none; b=WYogRIKEkXCo2/EWKwS4tVpqdXdodYF+JfJo6IrRO58cDCtq28XUC0rpgIV/JSycEhQP+3itfugYGMPLvDpS25GQpjp4UHBUGgWraOwbrawHDcPtlo6lP1zyvjhTmOWoDNQaS1drwJ247cZJjKZnDFOAmqyFziZDuZD+Er+lgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240354; c=relaxed/simple;
	bh=ElLDnp76WNWwDKvqu1oD1zoyAlrNJ4iqci+1Wx68bzk=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgSrbDF5EYU1YKrTZibpSKZiCRwBtD2lzPRbebhoDslMItnGtzfBmwBXwbCokmbPrBYGF0UJ90eaM5DarZOSBv64dSWWq9RDo6ppWdTz03+ZMlE0S5ise5GlzY4T2R8xuI5neiCMjc5MPkF4xVavTYZ7XftibdpwKZpEPTTKMsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZFMgq/Nu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFB8C4CEED;
	Fri, 11 Jul 2025 13:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752240353;
	bh=ElLDnp76WNWwDKvqu1oD1zoyAlrNJ4iqci+1Wx68bzk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZFMgq/Nud9mlT2A/Ke4bhx0atcdEPWwejkPk1r1Jqekr8HUbwj0QBghb3auZMrwse
	 fRSDnBrMddjw1ds1n/Oe4GnRfhmYF1RaYI64/NJ4LqEwvWBEu/JGinDi5w3onmcoK0
	 jU/Rfjt0y4kFsOpOfLwPP6SRHY9kkpcegtCeY9IX9Uya59Abzr/nLn4luB6NrisESD
	 oOiQ+6/02wIn4YcyhVc0AQ7MhfgxDvm+4KKH/fmhX8u+R/02boN6O33FluZ09k/uMB
	 mFQzRONSNfN14uQ6jE7rdZhTbLtXk/Twi3t41PLnMJJeh8zNWHR5rV9NVLYN5B7MXm
	 J+0TZOjxbhJeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uaDl8-00EspX-Jy;
	Fri, 11 Jul 2025 14:25:50 +0100
Date: Fri, 11 Jul 2025 14:25:49 +0100
Message-ID: <86bjpqamg2.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	chenhuacai@kernel.org,
	mpe@ellerman.id.au,
	anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	seanjc@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	xiaoyao.li@intel.com,
	yilun.xu@intel.com,
	chao.p.peng@linux.intel.com,
	jarkko@kernel.org,
	amoorthy@google.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	mic@digikod.net,
	vbabka@suse.cz,
	vannapurve@google.com,
	ackerleytng@google.com,
	mail@maciej.szmigiero.name,
	david@redhat.com,
	michael.roth@amd.com,
	wei.w.wang@intel.com,
	liam.merwick@oracle.com,
	isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com,
	steven.price@arm.com,
	quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	oliver.upton@linux.dev,
	will@kernel.org,
	qperret@google.com,
	keirf@google.com,
	roypat@amazon.co.uk,
	shuah@kernel.org,
	hch@infradead.org,
	jgg@nvidia.com,
	rientjes@google.com,
	jhubbard@nvidia.com,
	fvdl@google.com,
	hughd@google.com,
	jthoughton@google.com,
	peterx@redhat.com,
	pankaj.gupta@amd.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v13 15/20] KVM: arm64: Refactor user_mem_abort()
In-Reply-To: <20250709105946.4009897-16-tabba@google.com>
References: <20250709105946.4009897-1-tabba@google.com>
	<20250709105946.4009897-16-tabba@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 09 Jul 2025 11:59:41 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Refactor user_mem_abort() to improve code clarity and simplify
> assumptions within the function.
> 
> Key changes include:
> 
> * Immediately set force_pte to true at the beginning of the function if
>   logging_active is true. This simplifies the flow and makes the
>   condition for forcing a PTE more explicit.
> 
> * Remove the misleading comment stating that logging_active is
>   guaranteed to never be true for VM_PFNMAP memslots, as this assertion
>   is not entirely correct.
> 
> * Extract reusable code blocks into new helper functions:
>   * prepare_mmu_memcache(): Encapsulates the logic for preparing and
>     topping up the MMU page cache.
>   * adjust_nested_fault_perms(): Isolates the adjustments to shadow S2
>     permissions and the encoding of nested translation levels.
> 
> * Update min(a, (long)b) to min_t(long, a, b) for better type safety and
>   consistency.
> 
> * Perform other minor tidying up of the code.
> 
> These changes primarily aim to simplify user_mem_abort() and make its
> logic easier to understand and maintain, setting the stage for future
> modifications.
> 
> No functional change intended.
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Without deviation from the norm, progress is not possible.

