Return-Path: <kvm+bounces-72070-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wNsyCS6coGlVlAQAu9opvQ
	(envelope-from <kvm+bounces-72070-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:17:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 293B31AE3F4
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:17:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BB95B300517B
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F7D44B664;
	Thu, 26 Feb 2026 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ENrf3Xmu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46690426D05
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772132884; cv=none; b=idYAglzoTfWpxaXt9+/jYGqO0NamL3Do54VuqPjHWG1v8IOeI/4Z1gihipgnKTKdfHm+MFUzewsadbhLrdOXzDWz27c+X0XJg86brGuzeE0L+uGI/ysYohRkrm4EqoKCO7f+ZTIevl8eyy32THvwmEWfrYUnOU04+ZZGraINuGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772132884; c=relaxed/simple;
	bh=TCV8SHxQHsXrYuGIcmh++Ac4sy1d4lzsmHPaj831Y4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n9A01USbUrPv8AetXC+WpwyT396JpReAvSX/83+n3ICxEG+GX+WQrL7S35cAclGZzyrwZu7ChbdTxcjevTRcG01+B/dBri5pBQr3l3JKr5Qcyqk8vzmQVwCHQP+rDUcpKgoNbXkN0iyaXUeKpf2jVdTfw/N9OhAOhfh6f9P5Z7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ENrf3Xmu; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-896f9397ecdso15967716d6.3
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 11:07:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1772132879; x=1772737679; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2JiPECMiS4IcPtH3bhy01xeh4Gb/Awq8dGQAxIHV6Bg=;
        b=ENrf3XmuAu2uaEKbD/sbqd0bBJ1pGgUNkD7Ey1teIkpFnRsaBC7IET+HVov1PcmGdN
         kqctIkApeAddD2aZNQ6iTizYIuEnmK3gHQQ9qB0PbxtM5LuixAIB2r0WwDfqisLWjcP9
         ajAAi8eKj1yAuQUYx/tBOw6bD6ggByBetJ0reWLC7kBcwNVkG9/s9KHVt+JNMpXq+Hyw
         SPHybM9gc4B0u2hvkB7vs67/TaU8S1BHVHYkWFrp5XAeBctGpEzLyI/5HlCtOCM/qbgJ
         SpaMF/o7JGUmAmSlfAW/925bVpUzUIUNK5JguzN4JFx8/1Tu/fD2N4P5uNRpnpEAv+G4
         Q6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772132879; x=1772737679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2JiPECMiS4IcPtH3bhy01xeh4Gb/Awq8dGQAxIHV6Bg=;
        b=oo/PatkTH8nOfWyfyLpKUcFFpVbas/xtRx3gZZFjlJMIxOkpfxb0+gQY8RLg0kEX9T
         NYroriE/Lg47i0x8KC/hz2OGwn3dQyNcHBlNyMO1yUpBdjlx4B4bi9mAnCo5exe8Gdfa
         lDnQZfsCgY6sR3gJe7zAc/q4wr6SLs909ixQnO4bljOzSHF7zWX/ao2R1l0HFIzJmpVC
         31yrV0PMMKLpYVRg/o/NzlDVeJYek0L1qP2U8edOkZtzXhVPAF7k1wLJkxBSrbCggLZU
         zfunXzAfdZSbB6yPHy/ChK955WP04DU6EysRTRR+1VLDcD/5rpyCpoOyVUtx2hsWeBcc
         SzEw==
X-Forwarded-Encrypted: i=1; AJvYcCUWigZuAn8G4PjXilXENNhja34mfr9+oPs/SIHgqNUJIVlMxzkgUrg3Hu+xcbgUIoZwX80=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBjW0NAUaKJanaNUzEpkq+eOBKD6u0+aIEIuDp7Vq773WVREeZ
	z3oG2ISspKrb0lCx7OfMctyqAm6yNnYI5FIkdyz+vcviUmtRj4ZphrbCastamRQaa1g=
X-Gm-Gg: ATEYQzxnj/FKOt9dTQpBzWsSkzsdCZyLHMWpTQ2Y2MRLIQPO/HfQ2Fsc4r4QtHq8skZ
	tIqfxHHI42DpYEMb0Fss8IdjTn+tyKrnW7lva4hWs/XCAD4E1/sfLSg65kbJiKub4Lxp13W83oc
	VHb3M6H/4pY+omBEwtOCLpLi3EEhgSdvHPXhrRdR+Wj8jNrprrGQfGwbQbnH0V8RNRByBFqTSma
	sXM7rOwPCPliR8HNZTaNZMDDdzr6mUJ7sT3csDJ6DixT9LkdFmHqcx385PDpFh6iW8aRPM5FXoo
	xyvoFWIKqF0x1k3DgRnd+OpKST3tfSmU2cIrQAdDti6j3L7NF1K42ZtRlHl2In/qyww550hMx4w
	gJWKjU8qlxgyFjwSB9BpCOyIKCczSv7ni+ZzkNEMG2pGAkOdv5H6nODYRHmDrCHXwAi9vxZSzpr
	1GZZc2D77c2wbQ6CcuLZl46ZXE7r2Q+dYuGHWgwqW0H2X/HK908SKpnWm5X+zf9PqpYkfDdyVRb
	GibX0CT
X-Received: by 2002:a05:6214:252f:b0:882:3781:e29d with SMTP id 6a1803df08f44-899d1d7250dmr3034716d6.10.1772132878800;
        Thu, 26 Feb 2026 11:07:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7376847sm24657116d6.28.2026.02.26.11.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:07:58 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vvgiL-00000000O8A-1yT1;
	Thu, 26 Feb 2026 15:07:57 -0400
Date: Thu, 26 Feb 2026 15:07:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
	linux-coco@lists.linux.dev, Dan Williams <dan.j.williams@intel.com>,
	Santosh Shukla <santosh.shukla@amd.com>,
	"Pratik R . Sampat" <prsampat@amd.com>,
	Fuad Tabba <tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	michael.roth@amd.com, vannapurve@google.com
Subject: Re: [RFC PATCH kernel] iommufd: Allow mapping from KVM's guest_memfd
Message-ID: <20260226190757.GA44359@ziepe.ca>
References: <20260225075211.3353194-1-aik@amd.com>
 <aZ7-tTpobKiCFT5L@google.com>
 <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgEiod74cRoVQVC5LUbWDZf6Wwz1ssjQN0fveN=RBAjsTw@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[ziepe.ca:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72070-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ziepe.ca:+];
	DMARC_NA(0.00)[ziepe.ca];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@ziepe.ca,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ziepe.ca:mid,ziepe.ca:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 293B31AE3F4
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 12:19:52AM -0800, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Wed, Feb 25, 2026, Alexey Kardashevskiy wrote:
> >> For the new guest_memfd type, no additional reference is taken as
> >> pinning is guaranteed by the KVM guest_memfd library.
> >>
> >> There is no KVM-GMEMFD->IOMMUFD direct notification mechanism as
> >> the assumption is that:
> >> 1) page stage change events will be handled by VMM which is going
> >> to call IOMMUFD to remap pages;
> >> 2) shrinking GMEMFD equals to VM memory unplug and VMM is going to
> >> handle it.
> >
> > The VMM is outside of the kernel's effective TCB.  Assuming the VMM will always
> > do the right thing is a non-starter.
> 
> I think looking up the guest_memfd file from the userspace address
> (uptr) is a good start

Please no, if we need complicated things like notifiers then it is
better to start directly with the struct file interface and get
immediately into some guestmemfd API instead of trying to get their
from a VMA. A VMA doesn't help in any way and just complicates things.

> I didn't think of this before LPC but forcing unmapping during
> truncation (aka shrinking guest_memfd) is probably necessary for overall
> system stability and correctness, so notifying and having guest_memfd
> track where its pages were mapped in the IOMMU is necessary. Whether or
> not to unmap during conversions could be a arch-specific thing, but all
> architectures would want the memory unmapped if the memory is removed
> from guest_memfd ownership.

Things like truncate are a bit easier to handle, you do need a
protective notifier, but if it detects truncate while an iommufd area
still covers the truncated region it can just revoke the whole
area. Userspace made a mistake and gets burned but the kernel is
safe. We don't need something complicated kernel side to automatically
handle removing just the slice of truncated guestmemfd, for example.

If guestmemfd is fully pinned and cannot free memory outside of
truncate that may be good enough (though somehow I think that is not
the case) - and I don't understand what issues Intel has with iommu
access.

Jason

