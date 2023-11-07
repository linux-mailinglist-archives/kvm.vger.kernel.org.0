Return-Path: <kvm+bounces-869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFD27E3AD0
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 12:11:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88AB4B20D96
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 11:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB9A2D05C;
	Tue,  7 Nov 2023 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4wnZRb8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5557E2D039
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 11:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4B1C433C7;
	Tue,  7 Nov 2023 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699355507;
	bh=e87nqDFOCROw30RUl54wWtybz1CTvx+dw++A2SwS0LM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N4wnZRb8LygVseWpWTVGFoNMCtqC7o2715vxpK2i9eMn6A8gcKScKo3A6bNzmFoFB
	 ofH4WACWJCWGjQAgONztmvyayvrVhLQaLZ/oSlUkISbl5Nsc+oxhIZvn1zijnDxEY1
	 TEugKIdjzo/fJHUXRm436gdxqOhJ8LqD94zv7OEg/OWZK1P28ZDkvD3V/Sxxodu6En
	 /dXbvJ6RDVdpZUuT/CZs5gZXvp60Jg1WPQrAuFLf7hc6vZkYB51lc4x1V3+Xj0yz8M
	 ucH8syOZsb0DZl598lMOYAYrY8hxLizMcVXWSH6BkZQBXsTfkxK9YNaulQUbPRIlH3
	 IxitS7sgFs0/A==
Date: Tue, 7 Nov 2023 11:11:42 +0000
From: Will Deacon <will@kernel.org>
To: Anup Patel <apatel@ventanamicro.com>
Cc: julien.thierry.kdev@gmail.com, maz@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v2 0/6] RISC-V AIA irqchip and Svnapot support
Message-ID: <20231107111142.GA19291@willie-the-truck>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
 <CAK9=C2Vvu=kcR5CtzSFFh4DFvqxMsLrLNAHpMxoxrCf8nUixbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2Vvu=kcR5CtzSFFh4DFvqxMsLrLNAHpMxoxrCf8nUixbw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Oct 12, 2023 at 09:50:29AM +0530, Anup Patel wrote:
> On Mon, Sep 18, 2023 at 6:27 PM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > The latest KVM in Linux-6.5 has support for:
> > 1) Svnapot ISA extension support
> > 2) AIA in-kernel irqchip support
> >
> > This series adds corresponding changes in KVMTOOL to use the above
> > mentioned features for Guest/VM.
> >
> > These patches can also be found in the riscv_aia_v2 branch at:
> > https://github.com/avpatel/kvmtool.git
> >
> > Changes since v1:
> >  - Rebased on commit 9cb1b46cb765972326a46bdba867d441a842af56
> >  - Updated PATCH1 to sync header with released Linux-6.5
> >
> > Anup Patel (6):
> >   Sync-up header with Linux-6.5 for KVM RISC-V
> >   riscv: Add Svnapot extension support
> >   riscv: Make irqchip support pluggable
> >   riscv: Add IRQFD support for in-kernel AIA irqchip
> >   riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
> >   riscv: Fix guest/init linkage for multilib toolchain
> 
> Friendly ping ?

There are a bunch of open review comments from Drew that need to be
addressed in a subsequent version.

Will

