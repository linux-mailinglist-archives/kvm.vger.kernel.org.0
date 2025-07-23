Return-Path: <kvm+bounces-53190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B621B0ED38
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:29:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C0A81C82BE8
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4262427A10C;
	Wed, 23 Jul 2025 08:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+NEuPjY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6693727990E;
	Wed, 23 Jul 2025 08:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753259366; cv=none; b=SdS2ZwoETugFfzWzcT9oAgH/gWLT/R9+/K7Nw7n/OP+KPyKvVLleD+pnb5MNPuBs3eIDCHfgfV0UoTzlETnyD+SPcmtnwTtOo4qwSroZXY3pWuznbyccys7bKW4egDmgFPUt6PJ4NItSq6EkBzPLVjI/Kyh5o6OzZQ1u6k2dP9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753259366; c=relaxed/simple;
	bh=yZzDzspz/hbs+ZI2bARhhg1NrwdEQ/R1WgItfyvWZ64=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7zEwm2DahNZcAOvUe6kaVlZRnkh5yO0TweYlS0/qw65ekqi4gjHvH5S+xc50n9uyDxZM9vIS9KU+qjly7S/ZBdKD8wxA1gv0LpMyY0r39r4BEUmrEfcMU4XG4QRF55hC9erUomEAXBqkaIWWWfSNpXZJzX5RkFxM3fbA/nDJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+NEuPjY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4194C4CEE7;
	Wed, 23 Jul 2025 08:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753259365;
	bh=yZzDzspz/hbs+ZI2bARhhg1NrwdEQ/R1WgItfyvWZ64=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=U+NEuPjYVaMphb588UKQdnFGh8jYQIaGAFO5RSZHHS2uTzxjbffJ0wV4RvByDdefU
	 /yAbktW7knDpaELNN+dmSB3mYqfeH46gUiJQvPoUWU1sRxnpQEcNRc5SovTJQpGxx0
	 MX5wycFo6RF4QbJ6mD/LrV9SeGtSHRPRI/ZrUiIsxHcf3ofChhVSa5fb/YtRPuuVz4
	 /NhVhbIKE79+8AeB5pLHK98D1jqVlLWG4xV/X3wBGY4Z2dgXyioYf3DdxMkfhIiKCh
	 Tdm2s0Mn57hQU+44blC2fsrBL65MJMZlNp9/6m39D/5Bdr7xxK0cFMKlj06FkNGjb6
	 IintvPIq5gWUg==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUqp-000bs6-Dx;
	Wed, 23 Jul 2025 09:29:23 +0100
Date: Wed, 23 Jul 2025 09:29:17 +0100
Message-ID: <87ms8vtin6.wl-maz@kernel.org>
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
Subject: Re: [PATCH v15 17/21] KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
In-Reply-To: <20250717162731.446579-18-tabba@google.com>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-18-tabba@google.com>
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
X-SA-Exim-Connect-IP: 82.132.236.66
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 17 Jul 2025 17:27:27 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Handle faults for memslots backed by guest_memfd in arm64 nested
> virtualization triggerred by VNCR_EL2.
> 
> * Introduce is_gmem output parameter to kvm_translate_vncr(), indicating
>   whether the faulted memory slot is backed by guest_memfd.
> 
> * Dispatch faults backed by guest_memfd to kvm_gmem_get_pfn().
> 
> * Update kvm_handle_vncr_abort() to handle potential guest_memfd errors.
>   Some of the guest_memfd errors need to be handled by userspace,
>   instead of attempting to (implicitly) retry by returning to the guest.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Jazz isn't dead. It just smells funny.

