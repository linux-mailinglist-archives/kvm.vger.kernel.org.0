Return-Path: <kvm+bounces-53124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D56ACB0DA9E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 15:17:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17A103A3894
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12B05D8F0;
	Tue, 22 Jul 2025 13:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJNhgn6q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0028525776;
	Tue, 22 Jul 2025 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753190258; cv=none; b=SULFLelkltuow1eagNixkrN4kyqovSXBQhM5Q2RnifDyw+TxLhFMpV9PLM3/jPX6rIm/fPZqtDDyVpl1+1nLmP2cRFnyFVGjN86WnxZhXP7HtFXtZ8V8/lDwN79CoQ1Bk+yu3Oer99KWzOHpPM3Lc0nwnXXlb0fpy0ilbeNklbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753190258; c=relaxed/simple;
	bh=3leS8riuCJe+lnyQnQIcRHprkIXpvrMzyIhcjLqEY1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mrxkruyIx7doW+vfQM4I91fKbhuCDiDi9vaHEKg4RoS+y9S6+b4GM4CimXCAm4l8KlP+BKeKEVOVrNkmpLsl0FwS1repVV+0VNciLQ6po7Dc9GYL3FGfqd5HoMt4nq7oag3JcT9nYrf7ik9HyxlNLICZcRL8SD+Wy7dGdmLWtqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJNhgn6q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EE0C4CEEB;
	Tue, 22 Jul 2025 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753190255;
	bh=3leS8riuCJe+lnyQnQIcRHprkIXpvrMzyIhcjLqEY1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJNhgn6qehAH7M6iwdt46ZSRtnpNN7QCYzYCFtpxyCOf9hD4MrstgMo6XRuzOF91c
	 sjv8RgAd4UifKt4aPajQt1uLJIdA0CTSwNfFbDlcF8QJmy0M1E/dH6Wnj4IbwqUdGe
	 ykJV6IdS8vz+9K5Gck9anM2yCECJ0V9cL76ZDvhaL3VsgFphEVvk35vu854JJEIwlA
	 mZWzP7DiEysaVcb+3NYpPiKRGR79NaQI9mdGR3PpkUTqTS0UDACcR/srpvBKQCaSpU
	 pNXOiIOJ9CTniD++dcKH1fM5/oz7ADMNXTsOBMNvN1K4Jc/tbgBPJI1VGCJ8Pig1kl
	 UZQ70MIhMgvQg==
Date: Tue, 22 Jul 2025 14:17:30 +0100
From: Will Deacon <will@kernel.org>
To: Anup Patel <anup@brainfault.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	linux-riscv@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	Atish Patra <atishp@rivosinc.com>
Subject: Re: [PATCH v4 0/9] Add SBI v3.0 PMU enhancements
Message-ID: <aH-PanNcaHsbSlOd@willie-the-truck>
References: <20250721-pmu_event_info-v4-0-ac76758a4269@rivosinc.com>
 <CAAhSdy2XM+3UQD0FZehJnmCbjwRMCZQpt1cEkb4gmJu+LFsaKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhSdy2XM+3UQD0FZehJnmCbjwRMCZQpt1cEkb4gmJu+LFsaKQ@mail.gmail.com>

On Tue, Jul 22, 2025 at 09:29:40AM +0530, Anup Patel wrote:
> On Tue, Jul 22, 2025 at 8:45 AM Atish Patra <atishp@rivosinc.com> wrote:
> >
> > SBI v3.0 specification[1] added two new improvements to the PMU chaper.
> > The SBI v3.0 specification is frozen and under public review phase as
> > per the RISC-V International guidelines.
> >
> > 1. Added an additional get_event_info function to query event availablity
> > in bulk instead of individual SBI calls for each event. This helps in
> > improving the boot time.
> >
> > 2. Raw event width allowed by the platform is widened to have 56 bits
> > with RAW event v2 as per new clarification in the priv ISA[2].
> >
> > Apart from implementing these new features, this series improves the gpa
> > range check in KVM and updates the kvm SBI implementation to SBI v3.0.
> >
> > The opensbi patches have been merged. This series can be found at [3].
> >
> > [1] https://github.com/riscv-non-isa/riscv-sbi-doc/releases/download/v3.0-rc7/riscv-sbi.pdf
> > [2] https://github.com/riscv/riscv-isa-manual/issues/1578
> > [3] https://github.com/atishp04/linux/tree/b4/pmu_event_info_v4
> >
> > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > ---
> > Changes in v4:
> > - Rebased on top of v6.16-rc7
> > - Fixed a potential compilation issue in PATCH5.
> > - Minor typos fixed PATCH2 and PATCH3.
> > - Fixed variable ordering in PATCH6
> > - Link to v3: https://lore.kernel.org/r/20250522-pmu_event_info-v3-0-f7bba7fd9cfe@rivosinc.com
> >
> > Changes in v3:
> > - Rebased on top of v6.15-rc7
> > - Link to v2: https://lore.kernel.org/r/20250115-pmu_event_info-v2-0-84815b70383b@rivosinc.com
> >
> > Changes in v2:
> > - Dropped PATCH 2 to be taken during rcX.
> > - Improved gpa range check validation by introducing a helper function
> >   and checking the entire range.
> > - Link to v1: https://lore.kernel.org/r/20241119-pmu_event_info-v1-0-a4f9691421f8@rivosinc.com
> >
> > ---
> > Atish Patra (9):
> >       drivers/perf: riscv: Add SBI v3.0 flag
> >       drivers/perf: riscv: Add raw event v2 support
> >       RISC-V: KVM: Add support for Raw event v2
> >       drivers/perf: riscv: Implement PMU event info function
> >       drivers/perf: riscv: Export PMU event info function
> >       KVM: Add a helper function to validate vcpu gpa range
> >       RISC-V: KVM: Use the new gpa range validate helper function
> >       RISC-V: KVM: Implement get event info function
> >       RISC-V: KVM: Upgrade the supported SBI version to 3.0
> >
> >  arch/riscv/include/asm/kvm_vcpu_pmu.h |   3 +
> >  arch/riscv/include/asm/kvm_vcpu_sbi.h |   2 +-
> >  arch/riscv/include/asm/sbi.h          |  13 +++
> >  arch/riscv/kvm/vcpu_pmu.c             |  75 ++++++++++++-
> >  arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
> >  arch/riscv/kvm/vcpu_sbi_sta.c         |   6 +-
> >  drivers/perf/riscv_pmu_sbi.c          | 191 +++++++++++++++++++++++++---------
> >  include/linux/kvm_host.h              |   2 +
> >  include/linux/perf/riscv_pmu.h        |   1 +
> >  virt/kvm/kvm_main.c                   |  21 ++++
> >  10 files changed, 258 insertions(+), 59 deletions(-)
> 
> Are you okay with this series going through the KVM RISC-V tree ?

The Risc-V PMU stuff usually goes via Palmer, so whatever he reckons.

Will

