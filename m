Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD23215360A
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 18:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgBERNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 12:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgBERNk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 12:13:40 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3D3217BA;
        Wed,  5 Feb 2020 17:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580922819;
        bh=ByLBNjKpvL+drbFX8db69SNp4tEdGchnbyAQs3iHRb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iCM6hM+bb28rKzRuVjqlQQfEjExev5RFGl4vKClni8TbrDdA3KnfUDOlkrt7RMKH/
         SjwbzAYtml7/RMnoUDH/MDmLuecBm+J0daKpfym3ZZVydrrgCtRvyd+n7a0uMvt5aX
         AsfPYoM4Op3j6Jvjmz/nYTQBP/se6WYP2k1F5JWQ=
Date:   Wed, 5 Feb 2020 17:13:34 +0000
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <Anup.Patel@wdc.com>
Cc:     Will Deacon <will.deacon@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        palmer@dabbelt.com
Subject: Re: [kvmtool RFC PATCH v2 0/8] KVMTOOL RISC-V support
Message-ID: <20200205171334.GB908@willie-the-truck>
References: <20200127123527.106825-1-anup.patel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127123527.106825-1-anup.patel@wdc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 27, 2020 at 12:35:55PM +0000, Anup Patel wrote:
> This series adds RISC-V support for KVMTOOL and it is based on
> the v10 of KVM RISC-V series. The KVM RISC-V patches are not yet
> merged in Linux kernel but it will be good to get early review
> for KVMTOOL RISC-V support.
> 
> The KVMTOOL RISC-V patches can be found in riscv_master branch at:
> https//github.com/kvm-riscv/kvmtool.git
> 
> The KVM RISC-V patches can be found in riscv_kvm_master branch at:
> https//github.com/kvm-riscv/linux.git
> 
> The QEMU RISC-V hypervisor emulation is done by Alistair and is
> available in mainline/alistair/riscv-hyp-ext-v0.5.1 branch at:
> https://github.com/kvm-riscv/qemu.git
> 
> Changes since v1:
>  - Use linux/sizes.h in kvm/kvm-arch.h
>  - Added comment in kvm/kvm-arch.h about why PCI config space is 256M
>  - Remove forward declaration of "struct kvm" from kvm/kvm-cpu-arch.h
>  - Fixed placement of DTB and INITRD in guest RAM
>  - Use __riscv_xlen instead of sizeof(unsigned long) in __kvm_reg_id()

I don't know anything about the RISC-V virtualisation architecture, so
I've added Palmer to cc in case he can review this and/or suggest somebody
else who can.

Will
