Return-Path: <kvm+bounces-58142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 091E2B8924C
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 12:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 674D23B0AB5
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:49:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5350309F02;
	Fri, 19 Sep 2025 10:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0jxgH2m"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA3D239E61;
	Fri, 19 Sep 2025 10:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758278969; cv=none; b=Ukgyi/tY9uUoWGN2Cnf1FztG6AyBY1bdLMyVkulI/IqmFkrtTxC/FE8G0rmYNDlnI6I4sLa9iL/56F+hqdcq/NvXPzxOzXMnpn/uM6bTpfTlD52ojjtnyRCg9QQVBJufW4kSwiU5kMYolFhXzlB2eQQtJgj7r78rhVKdAcg3KAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758278969; c=relaxed/simple;
	bh=cHzHIlxAkWUgQ24eo+IV0iI7C9yYFaGpGxUswY89kBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dckv/xoN9JIrh3Pvzouq1DV9dftWORCwO0Bap3pPzSiT74LBu1/Mrdg4w+46Qhv/+1j5Veo2eXtCwMIBbwgxfouPoLWUfkQDz5YjIEroJnUEgBBqGt4W5eHs/fh1+u3IVaTslHJhlU8h150b6Nf1ifoiGkqeYnlNBK/O/2Or0vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0jxgH2m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DEFC4CEF0;
	Fri, 19 Sep 2025 10:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758278967;
	bh=cHzHIlxAkWUgQ24eo+IV0iI7C9yYFaGpGxUswY89kBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S0jxgH2mqdO6NsiEOQZ+4Mh83PE35MJnNuY7l0f7cDkNko9j+ADn3k17yx0X4LpEb
	 DQFJPaM5nq/Hdobiacy1/VxkDZWNP4jLbunB/e+4IJvSldQmQMhn9OKEzoW9X3N949
	 wJiPjM+R4UxnqSVC+CQr3A3zglB3r2e4y2wpo8GgA7BhTk0Q9iN21I52JQNQL+2MYO
	 BlPCSPcz0k+dImlhxfpK3BuXRZLtGGijlxF5sIh7vC2hW2A0pX4Fk+97IMJpxYVHTK
	 esQVDVaXhrmAHQ6k068i7k6rSGHp6r5WIXdUcp5p6dM01lMvrGdEZ0TRrU3BiUpPfX
	 5MRFCGI+nHHlg==
Date: Fri, 19 Sep 2025 16:12:58 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: SVM: Enable AVIC for Zen4+ (if x2AVIC)
Message-ID: <owztdzclln5pmgsuxgzt54vneiejtngdkujaebr7r35zx3f4lj@xvvhwvumkkha>
References: <20250919002136.1349663-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919002136.1349663-1-seanjc@google.com>

On Thu, Sep 18, 2025 at 05:21:30PM -0700, Sean Christopherson wrote:
> Enable AVIC by default for Zen4+, so long as x2AVIC is supported (which should
> be the case if AVIC is supported).
> 
> v3:
>  - Don't advise the user to enable force_avic. [Naveen]
>  - Gather AVIC related module params in avic.c (by moving code/helpers to
>    avic.c).
>  - Print "AVIC enabled" even when it's forced.
>  - Enable by default iff x2AVIC is supported.
>  - Use "auto" to select KVM's automatic/default behavior.
> 
> v2: https://lore.kernel.org/all/cover.1756993734.git.naveen@kernel.org
> 
> v1: http://lkml.kernel.org/r/20250626145122.2228258-1-naveen@kernel.org
> 
> Naveen N Rao (1):
>   KVM: SVM: Enable AVIC by default for Zen4+ if x2AVIC is support
> 
> Sean Christopherson (5):
>   KVM: SVM: Move x2AVIC MSR interception helper to avic.c
>   KVM: SVM: Update "APICv in x2APIC without x2AVIC" in avic.c, not svm.c
>   KVM: SVM: Always print "AVIC enabled" separately, even when force
>     enabled
>   KVM: SVM: Don't advise the user to do force_avic=y (when x2AVIC is
>     detected)
>   KVM: SVM: Move global "avic" variable to avic.c
> 
>  arch/x86/kvm/svm/avic.c | 149 +++++++++++++++++++++++++++++++++-------
>  arch/x86/kvm/svm/svm.c  |  62 +----------------
>  arch/x86/kvm/svm/svm.h  |   4 +-
>  3 files changed, 125 insertions(+), 90 deletions(-)

Thanks for putting this together! I have confirmed that this correctly 
enables AVIC by default on a Zen 5 system and does not do so on a Zen 1 
system.

For the series:
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>


- Naveen


