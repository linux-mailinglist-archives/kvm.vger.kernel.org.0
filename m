Return-Path: <kvm+bounces-13998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CD30989DF75
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0E17B2CF59
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 15:14:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 518F113A3F2;
	Tue,  9 Apr 2024 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2huhTvk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726A1139587
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712675354; cv=none; b=WifvbaTl3j0SbNZVzKbVBhgL7YQem9LPK6fciJsqWTKN6KCpWz0SU13NxE/z0no90VwJKyhdEq1Ui0lNCXxjLqQ3iyOJ7VVNRUy6Z5cxftF+kiaRGL/qtgMdzwfNrZSh4u/rXpc7xg7IICej/XLSplrjVScgQa0V/e/EUuqj0S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712675354; c=relaxed/simple;
	bh=iQVaga5XZ580sTsyzcQdFpyE1jo3biPDtTiUGN/XPp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rswWLT+LMbTjq3krQ9H8HaW0kq6ZvgQoroUKj9Tr1TVN71tlFY/RnBLIY06oIiltlP6VC6Y6EUl040puqZZ8COuZp1tPqF/9R4f6HYw0/Noz7vm6Ls7Qs3WqFiEqzLHjj9b5HugmZduq1PKa4VEhAz6+33t6CiJpK0iuk10JqRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2huhTvk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F4EC433F1;
	Tue,  9 Apr 2024 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712675354;
	bh=iQVaga5XZ580sTsyzcQdFpyE1jo3biPDtTiUGN/XPp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b2huhTvkthfm2Zj8JDPgcTATYuUPhoFJI/bUGnF1wq1g69uIxeXzNBOyHDd763raG
	 LT+xOASfKyFx2/LDI2DWuvqIajUQDYJEQM98Y/LYjgn6C7LJirJEc3fCwwyJcCCto8
	 bd4eLZEh/Lv+p95xCDf5UIRGyhgIRp9JZN7jdul1rXkEWIynVjqSoi7ZkkFkAKZXGm
	 zRLvWmOTE/uOAKHOim7VDHBGnA6CulkQbdGCvfU9GkOZJn4xN8BDtIUEY8Qpgb5RvC
	 AIvzJAHdP2HpbknTrJ4sWKli9SU/Xyd4qPQ2656d8T+DGhjZW41sEvOHX2ZLBvNZe4
	 sswbrJu1nRldw==
Date: Tue, 9 Apr 2024 16:09:07 +0100
From: Will Deacon <will@kernel.org>
To: =?utf-8?B?56em5bCR6Z2S?= <qinshaoqing@bosc.ac.cn>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org,
	Bonzini <pbonzini@redhat.com>, Patra <atishp@atishpatra.org>,
	Jones <ajones@ventanamicro.com>, Patel <anup@brainfault.org>,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Patel <apatel@ventanamicro.com>,
	=?utf-8?B?546L54S2?= <wangran@bosc.ac.cn>,
	=?utf-8?B?5byg5YGl?= <zhangjian@bosc.ac.cn>
Subject: Re: [kvmtool PATCH 1/1] riscv: Add zacas extension
Message-ID: <20240409150907.GB23464@willie-the-truck>
References: <3095a39b.95.18d3440cf62.Coremail.qinshaoqing@bosc.ac.cn>
 <20240409145531.GA23464@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240409145531.GA23464@willie-the-truck>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Apr 09, 2024 at 03:55:31PM +0100, Will Deacon wrote:
> On Tue, Jan 23, 2024 at 10:57:59AM +0800, 秦少青 wrote:
> > Add parsing for Zacas ISA extension which was ratified recently in the
> > riscv-zacas manual.
> > 
> > Signed-off-by: Shaoqing Qin <qinshaoqing@bosc.ac.cn>
> > ---
> >  riscv/fdt.c                         | 1 +
> >  riscv/include/asm/kvm.h             | 1 +
> >  riscv/include/kvm/kvm-config-arch.h | 3 +++
> >  3 files changed, 5 insertions(+)
> > 
> > diff --git a/riscv/fdt.c b/riscv/fdt.c
> > index 9af71b5..1b4f701 100644
> > --- a/riscv/fdt.c
> > +++ b/riscv/fdt.c
> > @@ -22,6 +22,7 @@ struct isa_ext_info isa_info_arr[] = {
> >  	{"svnapot", KVM_RISCV_ISA_EXT_SVNAPOT},
> >  	{"svpbmt", KVM_RISCV_ISA_EXT_SVPBMT},
> >  	{"zbb", KVM_RISCV_ISA_EXT_ZBB},
> > +	{"zacas", KVM_RISCV_ISA_EXT_ZACAS},
> >  	{"zicbom", KVM_RISCV_ISA_EXT_ZICBOM},
> >  	{"zicboz", KVM_RISCV_ISA_EXT_ZICBOZ},
> >  	{"zihintpause", KVM_RISCV_ISA_EXT_ZIHINTPAUSE},
> > diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
> > index 992c5e4..0c65ff0 100644
> > --- a/riscv/include/asm/kvm.h
> > +++ b/riscv/include/asm/kvm.h
> > @@ -122,6 +122,7 @@ enum KVM_RISCV_ISA_EXT_ID {
> >  	KVM_RISCV_ISA_EXT_ZICBOM,
> >  	KVM_RISCV_ISA_EXT_ZICBOZ,
> >  	KVM_RISCV_ISA_EXT_ZBB,
> > +	KVM_RISCV_ISA_EXT_ZACAS,
> >  	KVM_RISCV_ISA_EXT_SSAIA,
> >  	KVM_RISCV_ISA_EXT_V,
> >  	KVM_RISCV_ISA_EXT_SVNAPOT,
> > diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> > index 863baea..7840f91 100644
> > --- a/riscv/include/kvm/kvm-config-arch.h
> > +++ b/riscv/include/kvm/kvm-config-arch.h
> > @@ -43,6 +43,9 @@ struct kvm_config_arch {
> >  	OPT_BOOLEAN('\0', "disable-zbb",				\
> >  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZBB],	\
> >  		    "Disable Zbb Extension"),				\
> > +	OPT_BOOLEAN('\0', "disable-zacas",				\
> > +		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZACAS],	\
> > +		    "Disable Zacas Extension"),				\
> >  	OPT_BOOLEAN('\0', "disable-zicbom",				\
> >  		    &(cfg)->ext_disabled[KVM_RISCV_ISA_EXT_ZICBOM],	\
> >  		    "Disable Zicbom Extension"),			\
> 
> I tried to apply this now that the upstream kernel seems to understand
> ZACAS, but the patch doesn't seem to apply against the latest kvmtool
> sources.
> 
> Please can you rebase it onto the latest version and send a v2?

Oh, sorry, I got my kernel trees mixed up and thought the KVM part of
ZACAS had landed in 6.8. In fact, it looks like it's merged for 6.9, so
we should wait for that to release before re-generating the headers in
kvmtool.

Will

