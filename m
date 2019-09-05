Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7BAA9D1A
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 10:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732258AbfIEIfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 04:35:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:48494 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730753AbfIEIfP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 04:35:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 894C7AC93;
        Thu,  5 Sep 2019 08:35:13 +0000 (UTC)
From:   Andreas Schwab <schwab@suse.de>
To:     Anup Patel <Anup.Patel@wdc.com>
Cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Anup Patel <anup@brainfault.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alexander Graf <graf@amazon.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-riscv\@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v7 18/21] RISC-V: KVM: Add SBI v0.1 support
References: <20190904161245.111924-1-anup.patel@wdc.com>
        <20190904161245.111924-20-anup.patel@wdc.com>
X-Yow:  Now KEN is having a MENTAL CRISIS because his "R.V." PAYMENTS are
 OVER-DUE!!
Date:   Thu, 05 Sep 2019 10:35:12 +0200
In-Reply-To: <20190904161245.111924-20-anup.patel@wdc.com> (Anup Patel's
        message of "Wed, 4 Sep 2019 16:16:02 +0000")
Message-ID: <mvmef0v87jz.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sep 04 2019, Anup Patel <Anup.Patel@wdc.com> wrote:

> From: Atish Patra <atish.patra@wdc.com>
>
> The KVM host kernel running in HS-mode needs to handle SBI calls coming
> from guest kernel running in VS-mode.
>
> This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
> implemented correctly except remote tlb flushes. For remote TLB flushes,
> we are doing full TLB flush and this will be optimized in future.

Note that this conflicts with
https://patchwork.kernel.org/patch/11107221/ which removes <asm/sbi.h>
from <asm/tlbflush.h>.  You should probably include that header
explicitly in arch/riscv/kvm/vcpu_sbi.c.

Andreas.

-- 
Andreas Schwab, SUSE Labs, schwab@suse.de
GPG Key fingerprint = 0196 BAD8 1CE9 1970 F4BE  1748 E4D4 88E3 0EEA B9D7
"And now for something completely different."
