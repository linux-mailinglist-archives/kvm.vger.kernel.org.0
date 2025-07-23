Return-Path: <kvm+bounces-53188-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FDDAB0ED15
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:21:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6064E7B543E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:19:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE63279DDB;
	Wed, 23 Jul 2025 08:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMvdhjIV"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CB017BEBF;
	Wed, 23 Jul 2025 08:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753258853; cv=none; b=j04cWt1O7jpAqK/VdFztCkqzcPPPRYU1EG++IWfyv41vkWEXaa+aFLuMRoAIHi9di0o5M11A5pjMDtMFYQJqW6Hz2xM+/sn2m+cvUf0lgjyyg3Tm6E2N9+MpNIFhTZlYWIccWYcbBchDq5x9k2mmYYuw9eRY+OwUOLVZYzsRmnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753258853; c=relaxed/simple;
	bh=Xsw3QoZiMPB8j16P6Zigy/0n3Pl6zL7Tf5S+EO6pdSc=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dZJPfapD25U4XiMHFQcCrnFFhe/KP1tAcvPH7r0KLFkLe+odzKlPiTMPjAP8leLjd8ySPi0eBalVYXsGkgd1PtK/sA+SyJA64imvHvK6yJdOvEIr+h5JnnSZ0NBXBBhGC8EMjD61gB9gjfA08xqyCPDhCgdKrL6AKI8Ea+w7v5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMvdhjIV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68972C4CEE7;
	Wed, 23 Jul 2025 08:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753258852;
	bh=Xsw3QoZiMPB8j16P6Zigy/0n3Pl6zL7Tf5S+EO6pdSc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IMvdhjIVoTWOkOkifH69KUZdMExh3V0toaYm4XhvU5rQbUnqJ2W4/K9ljJhPpvAsJ
	 vBFe7YZ7c6P90+WqFyAIQ35nBaxBfCMVfRbvZKe0RXzK4Pg8puy92WGPjZw1q2nHM4
	 9p75I7HG1gZbDDrJGAwzy3lkgZcX5A9aPQ+yzory8QnE3mx4OJnwYOzkIbYUUjCxG9
	 nABfhefve/uAggH7xD+fSFwbUUt3jyv6kbu13WY6dI/T2xfzpEiNCkAck5WNIWDK7t
	 Ka4dWmv1gbJ5l/O0T8xz0hWbbZ5+BUREZl3UkbF1mM0CemYFKhUhQqrSQPcjIdoSln
	 rlQCXtwYFzblw==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUiX-000bju-0K;
	Wed, 23 Jul 2025 09:20:49 +0100
Date: Wed, 23 Jul 2025 09:20:35 +0100
Message-ID: <87pldrtj1o.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Kunwu Chan <kunwu.chan@linux.dev>
Cc: Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
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
Subject: Re: [PATCH v15 16/21] KVM: arm64: Handle guest_memfd-backed guest page faults
In-Reply-To: <07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-17-tabba@google.com>
	<07976427-e5a4-4ca4-93e9-a428a962b0b2@linux.dev>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-SA-Exim-Connect-IP: 82.132.236.66
X-SA-Exim-Rcpt-To: kunwu.chan@linux.dev, tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@q
 uicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Tue, 22 Jul 2025 13:31:34 +0100,
Kunwu Chan <kunwu.chan@linux.dev> wrote:
>=20
> On 2025/7/18 00:27, Fuad Tabba wrote:
> > Add arm64 architecture support for handling guest page faults on memory
> > slots backed by guest_memfd.
> >=20
> > This change introduces a new function, gmem_abort(), which encapsulates
> > the fault handling logic specific to guest_memfd-backed memory. The
> > kvm_handle_guest_abort() entry point is updated to dispatch to
> > gmem_abort() when a fault occurs on a guest_memfd-backed memory slot (as
> > determined by kvm_slot_has_gmem()).
> >=20
> > Until guest_memfd gains support for huge pages, the fault granule for
> > these memory regions is restricted to PAGE_SIZE.
>=20
> Since huge pages are not currently supported, would it be more
> friendly to define=C2=A0 sth like
>=20
> "#define GMEM_PAGE_GRANULE PAGE_SIZE" at the top (rather than
> hardcoding PAGE_SIZE)
>=20
> =C2=A0and make it easier to switch to huge page support later?

No. PAGE_SIZE always has to be the fallback, no matter what. When (and
if) larger mappings get supported, there will be extra code for that
purpose, not just flipping a definition.

Thanks,

	M.

--=20
Jazz isn't dead. It just smells funny.

